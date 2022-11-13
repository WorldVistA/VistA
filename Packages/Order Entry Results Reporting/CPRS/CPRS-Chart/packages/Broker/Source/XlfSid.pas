{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: XlfSid Thread or Process security in Windows.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 07/16/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
  ************************************************** }

unit XlfSid;
// *******************************************************
// These functions get their data from the Thread
// or Process security ID in Windows.
// GetNTLogonUser returns the Domain\Username that
// authenticated the user/
// GetNTLogonSid returns a string with the users SID.
// ********************************************************

interface

uses
  {System}
  SysUtils,
  {WinApi}
  Windows;

type { From MSDN }

  StringSid = ^LPTSTR;

function ConvertSidToStringSid(Sid: { THandle } PSID; var StrSid: LPTSTR)
  : BOOL stdcall;

function GetNTLogonUser(): string;
function GetNTLogonSid(): string;

implementation

function ConvertSidToStringSid; external advapi32 name 'ConvertSidToStringSidW';

function GetNTLogonUser(): string;
var
  hToken: THANDLE;
  tic: TTokenInformationClass;
  ptkUser: PSIDAndAttributes;
  P: pointer;
  buf: PChar;
  cbti: DWORD;
  Name: PChar;
  cbName: DWORD;
  RDN: PChar;
  cbRDN: DWORD;
  snu: DWORD;
begin
  Result := '';
  tic := TokenUser;
  Name := '';
  RDN := '';

  try
    // Get the calling thread's access token
    if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, longbool(true),
      hToken) then
      if (GetLastError() <> ERROR_NO_TOKEN) then
        exit
        // Retry against process token if no thread token exist.
      else if not OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, hToken)
      then
        exit;
    // Obtain the size of the user info in the token
    // Call should fail due to zero-length buffer
    if GetTokenInformation(hToken, tic, nil, 0, cbti) then
      exit;

    // Allocate buffer for user Info
    buf := StrAlloc(cbti);

    // Retrive the user info from the token.
    if not GetTokenInformation(hToken, tic, buf, cbti, cbti) then
      exit;
    cbName := 0;
    cbRDN := 0;
    snu := 0;
    P := buf; // Use pointer to recast PChar
    ptkUser := PSIDAndAttributes(P);
    // call to get the size of name and RDN.
    LookupAccountSid(nil, ptkUser.Sid, Name, cbName, RDN, cbRDN, snu);
    Name := StrAlloc(cbName);
    RDN := StrAlloc(cbRDN);
    // Call to fillin Name and RDN
    LookupAccountSid(nil, ptkUser.Sid, Name, cbName, RDN, cbRDN, snu);
    Result := string(RDN) + '\' + string(Name);
    StrDispose(Name);
    StrDispose(RDN);
  finally
    if (hToken <> 0) then
      CloseHandle(hToken);

  end;

end;

function GetNTLogonSid(): string;
var
  hToken: THANDLE;
  tic: TTokenInformationClass;
  ptkUser: PSIDAndAttributes;
  P: pointer;
  buf: PChar;
  StrSid: PChar;
  cbti: DWORD;
  // cbName: DWORD;
  // cbRDN: DWORD;
  // snu: DWORD;
begin
  Result := '';
  tic := TokenUser;

  try
    // Get the calling thread's access token
    if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, longbool(true),
      hToken) then
      if (GetLastError() <> ERROR_NO_TOKEN) then
        exit
        // Retry against process token if no thread token exist.
      else if not OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, hToken)
      then
        exit;
    // Obtain the size of the user info in the token
    // Call should fail due to zero-length buffer
    if GetTokenInformation(hToken, tic, nil, 0, cbti) then
      exit;

    // Allocate buffer for user Info
    buf := StrAlloc(cbti);

    // Retrive the user info from the token.
    if not GetTokenInformation(hToken, tic, buf, cbti, cbti) then
      exit;
    P := buf; // Use pointer to recast PChar
    ptkUser := PSIDAndAttributes(P);
    // P := nil;
    if ConvertSidToStringSid(ptkUser.Sid, StrSid) = true then
    begin
      Result := PChar(StrSid);
      localFree(Cardinal(StrSid));
    end;
  finally
    if (hToken <> 0) then
      CloseHandle(hToken);
  end;
      if Assigned(buf) then StrDispose(buf);
end;

end.

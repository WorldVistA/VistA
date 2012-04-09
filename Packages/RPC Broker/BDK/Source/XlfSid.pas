unit XlfSid;
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

//*******************************************************
//These functions get thier data from the Thread
// or Process security ID in Windows.
// GetNTLogonUser returns the Domain\Username that
//  authtcated the user/
// GetNTLogonSid returns a string with the users SID.
//********************************************************

interface

uses windows, SysUtils;
type  {From MSDN}

  StringSid = ^LPTSTR;

function ConvertSidToStringSid(Sid: {THandle}PSID; var StrSid: LPTSTR): BOOL stdcall;

function GetNTLogonUser(): string;
function GetNTLogonSid(): string;

implementation


function ConvertSidToStringSid; external advapi32 name 'ConvertSidToStringSidA';

function GetNTLogonUser(): string;
var
    hToken: THANDLE;
    tic: TTokenInformationClass;
    ptkUser:  PSIDAndAttributes;
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
    //Get the calling thread's access token
    if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY
                , longbool(true), hToken) then
         if (GetLastError() <> ERROR_NO_TOKEN) then exit
    // Retry against process token if no thread token exist.
          else
          if not OpenProcessToken(GetCurrentProcess()
                 ,TOKEN_QUERY, hToken) then exit;
    // Obtain the size of the user info in the token
    // Call should fail due to zero-length buffer
    if GetTokenInformation(hToken, tic, nil, 0, cbti) then exit;

    // Allocate buffer for user Info
    buf := StrAlloc(cbti);

    // Retrive the user info from the token.
    if not GetTokenInformation(hToken, tic, buf, cbti, cbti) then exit;
    cbName := 0;
    cbRDN := 0;
    snu := 0;
    P := buf;  //Use pointer to recast PChar
    ptkUser := PSIDAndAttributes(P);
    //call to get the size of name and RDN.
    LookupAccountSid( nil, ptkUser.Sid, Name, cbName
                            , RDN, cbRDN, snu);
    Name := StrAlloc(cbName);
    RDN := StrAlloc(cbRDN);
    //Call to fillin Name and RDN
    LookupAccountSid( nil, ptkUser.Sid, Name, cbName
                            , RDN, cbRDN, snu);
    Result := string(RDN) + '\' + string(Name);
    StrDispose(Name);
    StrDispose(RDN);
    finally
    if (hToken <> 0) then CloseHandle(hToken);
    end;

end;

function GetNTLogonSid(): string;
var
    hToken: THANDLE;
    tic: TTokenInformationClass;
    ptkUser:  PSIDAndAttributes;
    P: pointer;
    buf: PChar;
    StrSid: PChar;
    cbti: DWORD;
//    cbName: DWORD;
//    cbRDN: DWORD;
//    snu: DWORD;
begin
    Result := '';
    tic := TokenUser;

    try
    //Get the calling thread's access token
    if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY
                , longbool(true), hToken) then
         if (GetLastError() <> ERROR_NO_TOKEN) then exit
    // Retry against process token if no thread token exist.
          else
          if not OpenProcessToken(GetCurrentProcess()
                 ,TOKEN_QUERY, hToken) then exit;
    // Obtain the size of the user info in the token
    // Call should fail due to zero-length buffer
    if GetTokenInformation(hToken, tic, nil, 0, cbti) then exit;

    // Allocate buffer for user Info
    buf := StrAlloc(cbti);

    // Retrive the user info from the token.
    if not GetTokenInformation(hToken, tic, buf, cbti, cbti) then exit;
    P := buf;  //Use pointer to recast PChar
    ptkUser := PSIDAndAttributes(P);
//    P := nil;
    if ConvertSidToStringSid(ptkUser.sid, StrSid) = true then
        begin
        Result := PChar(StrSid);
        localFree(Cardinal(StrSid));
        end;
    finally
    if (hToken <> 0) then CloseHandle(hToken);
    end;

end;
end.

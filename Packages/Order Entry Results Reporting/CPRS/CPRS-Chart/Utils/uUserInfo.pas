unit uUserInfo;

interface

uses
  Winapi.Windows, Winapi.Messages;

function getUserInfo(): string;

implementation

uses
  System.SysUtils;

const
  INFO_BUFFER_SIZE = 32767;

type
   _USER_NAME_FORMAT = (NameUnknown, NameFullyQualifiedDN, NameSamCompatible,
    NameDisplay, NameUniqueId, NameCanonical, NameUserPrincipal,
    NameCanonicalEx, NameServicePrincipal, NameDnsDomain, NameGivenName,
    NameSurname);

    TUserNameFormat = _USER_NAME_FORMAT;

function GetUserNameEx(UserNameFormat: TUserNameFormat; lpBuffer: LPWSTR;
  var nSize: DWORD): BOOL; stdcall;
  external 'secur32.dll' name 'GetUserNameExW';

function getUserInfo(): string;
var
  pcUserInfo: array [1 .. INFO_BUFFER_SIZE] of WideChar;
  UserInfoSize: DWORD;
  ComputerInfoSize: DWORD;
  pcBuf: PWideChar;
  TotalBufSize: integer;
begin
  ComputerInfoSize := INFO_BUFFER_SIZE;
  UserInfoSize := INFO_BUFFER_SIZE;

  if GetUserNameEx(NameSamCompatible, @pcUserInfo, UserInfoSize) then
  begin
    TotalBufSize := ComputerInfoSize + UserInfoSize + 1;

    GetMem(pcBuf, (SizeOf(WideChar) * TotalBufSize));
    try
      strCopy(pcBuf, @pcUserInfo);
      Result := WideCharToString(pcBuf);
      Result := StringReplace(Result, '\', '_', [rfReplaceAll]);
    finally
      FreeMem(pcBuf);
    end;
  end
  else
    Result := '';
end;

end.

unit ORProcessUtilities;

interface

uses
  Windows, SysUtils;

type
  EORProcessException = class(Exception);
  HANDLE              = NativeUInt;

procedure RaiseLastOsErrorEx(const _Format: string); overload;
procedure RaiseLastOsErrorEx(_ErrorCode: integer; _Format: string); overload;
function GetLastOsError(out _Error: string; const _Format: string = ''): DWORD; overload;
function GetLastOsError(_ErrCode: integer; out _Error: string; const _Format: string = ''): DWORD; overload;

function GetProcessDomainAndUser(PID: DWORD): string;
function GetPIDforProcess(const AProcessName: string): DWORD;

//Windows API functions for enumerating processes
function EnumProcesses(
  lpidProcess: PDWORD;
  cb         : DWORD;
  lpcbNeeded : LPDWORD
  ): boolean; stdcall;

function EnumProcessModules(
  hProcess  : HANDLE;
  lphModule : PHMODULE;
  cb        : DWORD;
  lpcbNeeded: LPDWORD
  ): boolean; stdcall;

function GetModuleBaseName (
  hProcess  : HANDLE;
  hMod      : HMODULE;
  lpBaseName: LPWSTR;
  nSize     : DWORD
  ): boolean; stdcall;

implementation

type
  PUserToken = ^UserToken;

  _UserToken = record
    User: TSIDAndAttributes;
  end;

  UserToken = _UserToken;


procedure RaiseLastOsErrorEx(const _Format: string); overload;
begin
  RaiseLastOsErrorEx(GetLastError, _Format);
end;

procedure RaiseLastOsErrorEx(_ErrorCode: integer; _Format: string); overload;
var
  Error: EOSError;
begin
  if _ErrorCode <> ERROR_SUCCESS then
    Error := EOSError.CreateFmt(_Format, [_ErrorCode, SysErrorMessage(_ErrorCode)])
  else
    Error := EOsError.CreateFmt(_Format, [_ErrorCode, ('unknown OS error')]);
  Error.ErrorCode := _ErrorCode;
  raise Error;
end;

function GetLastOsError(out _Error: string; const _Format: string = ''): DWORD;
begin
  Result := GetLastOsError(GetLastError, _Error, _Format);
end;

function GetLastOsError(_ErrCode: integer; out _Error: string; const _Format: string = ''): DWORD;
var
  s: string;
begin
  Result := _ErrCode;
  if Result <> ERROR_SUCCESS then
    s := SysErrorMessage(Result)
  else
    s := ('unknown OS error');
  if _Format <> '' then
    try
      _Error := Format(_Format, [Result, s])
    except
      _Error := s;
    end else
    _Error := s;
end;

function Win32CheckEx(_RetVal: BOOL; out _ErrorCode: DWORD; out _Error: string;
  const _Format: string = ''): BOOL;
begin
  Result := _RetVal;
  if not Result then
    _ErrorCode := GetLastOsError(_Error, _Format);
end;

function GetProcessDomainAndUser(PID: DWORD): string;
var
  ProcHandle: THandle;
  TokenHandle: THandle;
  UserToken: PUserToken;
  TokenLength: Cardinal;
  ReturnLength: Cardinal;
  UserSize: DWORD;
  DomainSize: DWORD;
  SIDUser: SID_NAME_USE;
  User: string;
  Domain: string;
  LastError: Integer;
begin
  TokenLength := 0;
  ReturnLength := 0;
  UserSize := 0;
  DomainSize := 0;

  ProcHandle := OpenProcess(PROCESS_QUERY_INFORMATION, false, PID);
  try
    if ProcHandle = 0 then
      RaiseLastOSErrorEx('Error 0x%x in GetProcessDomainAndUser OpenProcess: %s');
    if not OpenProcessToken(ProcHandle, TOKEN_QUERY, TokenHandle) then
      RaiseLastOSErrorEx('Error 0x%x in GetProcessDomainAndUser OpenProcessToken: %s');
    try
      if not GetTokenInformation(TokenHandle, TokenUser, nil, TokenLength, ReturnLength) then
        begin
          LastError := GetLastError;
          if LastError <> ERROR_INSUFFICIENT_BUFFER then
          begin
            SetLastError(LastError);
            RaiseLastOSErrorEx('Error 0x%x in GetProcessDomainAndUser GetTokenInformation 1st call: %s');
          end;
        end;
      TokenLength := ReturnLength;
      UserToken := HeapAlloc(GetProcessHeap, 0, ReturnLength);
      try
        if not GetTokenInformation(TokenHandle, TokenUser, UserToken, TokenLength,
          ReturnLength)then
            RaiseLastOSErrorEx('Error 0x%x in GetProcessDomainAndUser GetTokenInformation 2nd call: %s');

        if not LookupAccountSID(nil, UserToken.User.Sid, nil, UserSize, nil, DomainSize, SidUser) then
        begin
          LastError := GetLastError;
          if LastError <> ERROR_INSUFFICIENT_BUFFER then
          begin
            SetLastError(LastError);
            RaiseLastOSErrorEx('Error 0x%x in GetProcessDomainAndUser LookupAccountSID 1st Call: %s');
          end;
        end;

        if (UserSize = 0) or (DomainSize = 0) then
          raise EORProcessException.Create('Error in GetProcessDomainAndUser LookupAccountSID: Zero value for UserSize or DomainSize');

        SetLength(User, UserSize);
        SetLength(Domain, DomainSize);

        if not LookupAccountSID(nil, UserToken.User.Sid, PWideChar(User), UserSize,
          PWideChar(Domain), DomainSize, SIDUser) then
          RaiseLastOSErrorEx('Error 0x%x in LookupAccountSID 2nd Call: %s');

        Result := StrPas(PWideChar(Domain)) + '/' + StrPas(PWideChar(User));
      finally
        HeapFree(GetProcessHeap, 0, UserToken);
      end;
    finally
      CloseHandle(TokenHandle);
    end;
  finally
    CloseHandle(ProcHandle);
  end;
end;


function GetPIDforProcess(const AProcessName: string): DWORD;
var
  ProcessArray: array [0..1023] of DWORD;
  BytesNeeded: DWORD;
  ProcessesAvailable: DWORD;
  I: Integer;

  procedure PrintProcessNameAndID(PID: DWORD);
  var
    ProcessName: array [0..MAX_PATH] of WideChar;
    ProcessHandle: HANDLE;
    ModuleHandle: HMODULE;
  begin
    ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);

    try
      if 0 = ProcessHandle then
        RaiseLastOSErrorEX('Error 0x%x in OpenProcess: %s');

      if EnumProcessModules(ProcessHandle, @ModuleHandle, sizeOf(ModuleHandle), @BytesNeeded) then
        GetModuleBaseName(ProcessHandle, ModuleHandle, @ProcessName[0], sizeof(ProcessName) div sizeof(WideChar));

    finally
      CloseHandle(ProcessHandle);
    end;
  end;
begin
  if not EnumProcesses(@ProcessArray[0], SizeOf(ProcessArray), @BytesNeeded) then
    RaiseLastOSErrorEx('Error 0x%x in EnumProcesses: %s');

  ProcessesAvailable := BytesNeeded div SizeOf(DWORD);

  for I := 0 to ProcessesAvailable - 1 do
  begin
    if ProcessArray[i] <> 0 then
      PrintProcessNameAndID(ProcessArray[i]);
  end;
end;

//------------------------------------------------------------------------------
// Imported Windows API functions.
//------------------------------------------------------------------------------

function EnumProcesses; external 'psapi.dll' name 'EnumProcesses';
function EnumProcessModules; external 'psapi.dll' name 'EnumProcessModules';
function GetModuleBaseName; external 'psapi.dll' name 'GetModuleBaseNameW';

end.

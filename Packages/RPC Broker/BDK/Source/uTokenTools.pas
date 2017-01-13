unit uTokenTools;

interface

uses
  Windows;

function CheckTokenMembership(TokenHandle: THandle; SidToCheck: PSID; out IsMember: BOOL): BOOL; stdcall;
function SHTestTokenMembership(hToken: THandle; ulRID: ULONG): BOOL; stdcall;
function IsUserAnAdmin(): BOOL; stdcall;

implementation

function GetAdvApi32Lib(): HMODULE;
const
  ModuleName = 'ADVAPI32';
{$WRITEABLECONST ON}
const
  ModuleHandle: HMODULE = HMODULE(nil);
{$WRITEABLECONST OFF}
begin
  Result := ModuleHandle;
  if Result = HMODULE(nil) then
  begin
    Result := LoadLibrary(ModuleName);
    if Result <> HMODULE(nil) then
      ModuleHandle := Result;
  end;
end;

{$WARN UNSAFE_CODE OFF}
function CheckTokenMembership(TokenHandle: THandle; SidToCheck: PSID;
  out IsMember: BOOL): BOOL;
type
  TFNCheckTokenMembership = function(TokenHandle: THandle; SidToCheck: PSID;
    out IsMember: BOOL): BOOL; stdcall;
{$WRITEABLECONST ON}
const
  Initialized: Integer = 0;
  RealApiFunc: TFNCheckTokenMembership = nil;
{$WRITEABLECONST OFF}
type
  TAceHeader = packed record
    AceType : Byte;
    AceFlags: Byte;
    AceSize : Word;
  end;
  TAccessAllowedAce = packed record
    Header : TAceHeader;
    Mask : ACCESS_MASK;
    SidStart: DWORD;
  end;
const
  ACL_REVISION = 2;
  DesiredAccess = 1;
  GenericMapping: TGenericMapping = (
    GenericRead : STANDARD_RIGHTS_READ;
    GenericWrite : STANDARD_RIGHTS_WRITE;
    GenericExecute: STANDARD_RIGHTS_EXECUTE;
    GenericAll : STANDARD_RIGHTS_ALL
  );
var
  ClientToken: THandle;
  ProcessToken: THandle;
  SecurityDescriptorSize: Cardinal;
  SecurityDescriptor: PSecurityDescriptor;
  Dacl: PACL;
  PrivilegeSetBufferSize: ULONG;
  PrivilegeSetBuffer: packed record
    PrivilegeSet: TPrivilegeSet;
    Buffer: array [0..2] of TLUIDAndAttributes;
  end;
  GrantedAccess: ACCESS_MASK;
  AccessStatus: BOOL;
begin
  if Initialized = 0 then
  begin
    RealApiFunc := TFNCheckTokenMembership(
      GetProcAddress(GetAdvApi32Lib(), 'CheckTokenMembership'));
    InterlockedIncrement(Initialized);
  end;
  if Assigned(RealApiFunc) then
    Result := RealApiFunc(TokenHandle, SidToCheck, IsMember)
  else
  begin
    Result := False;
    IsMember := False;
    ClientToken := THandle(nil);
    try
      if TokenHandle <> THandle(nil) then
        ClientToken := TokenHandle
      else if not OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, False,
        ClientToken) then
      begin
        ClientToken := THandle(nil);
        if GetLastError() = ERROR_NO_TOKEN then
        begin
          if OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY or
            TOKEN_DUPLICATE, ProcessToken) then
          try
            if not DuplicateToken(ProcessToken, SecurityImpersonation,
              @ClientToken) then
            begin
              ClientToken := THandle(nil);
            end;
          finally
            CloseHandle(ProcessToken);
          end;
        end;
      end;
      if ClientToken <> THandle(nil) then
      begin
        SecurityDescriptorSize := SizeOf(TSecurityDescriptor) +
          SizeOf(TAccessAllowedAce) + SizeOf(TACL) +
          3 * GetLengthSid(SidToCheck);
        SecurityDescriptor := PSecurityDescriptor(
          LocalAlloc(LMEM_ZEROINIT, SecurityDescriptorSize));
        if SecurityDescriptor <> nil then
        try
          if InitializeSecurityDescriptor(SecurityDescriptor,
            SECURITY_DESCRIPTOR_REVISION) then
          begin
            if SetSecurityDescriptorOwner(SecurityDescriptor, SidToCheck,
              False) then
            begin
              if SetSecurityDescriptorGroup(SecurityDescriptor, SidToCheck,
                False) then
              begin
                Dacl := PACL(SecurityDescriptor);
                Inc(PSecurityDescriptor(Dacl));
                if InitializeAcl(Dacl^,
                  SecurityDescriptorSize - SizeOf(TSecurityDescriptor),
                  ACL_REVISION) then
                begin
                  if AddAccessAllowedAce(Dacl^, ACL_REVISION, DesiredAccess,
                    SidToCheck) then
                  begin
                    if SetSecurityDescriptorDacl(SecurityDescriptor, True, Dacl,
                      False) then
                    begin
                      PrivilegeSetBufferSize := SizeOf(PrivilegeSetBuffer);
                      Result := AccessCheck(SecurityDescriptor, ClientToken,
                        DesiredAccess, GenericMapping,
                        PrivilegeSetBuffer.PrivilegeSet, PrivilegeSetBufferSize,
                        GrantedAccess, AccessStatus);
                      if Result then
                        IsMember := AccessStatus and
                          (GrantedAccess = DesiredAccess);
                    end;
                  end;
                end;
              end;
            end;
          end;
        finally
          LocalFree(HLOCAL(SecurityDescriptor));
        end;
      end;
    finally
      if (ClientToken <> THandle(nil)) and
        (ClientToken <> TokenHandle) then
      begin
        CloseHandle(ClientToken);
      end;
    end;
  end;
end;
{$WARN UNSAFE_CODE ON}

function GetShell32Lib(): HMODULE;
const
  ModuleName = 'SHELL32';
{$WRITEABLECONST ON}
const
  ModuleHandle: HMODULE = HMODULE(nil);
{$WRITEABLECONST OFF}
begin
  Result := ModuleHandle;
  if Result = HMODULE(nil) then
  begin
    Result := LoadLibrary(ModuleName);
    if Result <> HMODULE(nil) then
      ModuleHandle := Result;
  end;
end;

function SHTestTokenMembership(hToken: THandle; ulRID: ULONG): BOOL; stdcall;
type
  TFNSHTestTokenMembership = function(hToken: THandle; ulRID: ULONG): BOOL; stdcall;
{$WRITEABLECONST ON}
const
  Initialized: Integer = 0;
  RealApiFunc: TFNSHTestTokenMembership = nil;
{$WRITEABLECONST OFF}
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
var
  SidToCheck: PSID;
begin
  if Initialized = 0 then
  begin
    RealApiFunc := TFNSHTestTokenMembership(
      GetProcAddress(GetShell32Lib(), 'SHTestTokenMembership'));
    InterlockedIncrement(Initialized);
  end;
  if Assigned(RealApiFunc) then
    Result := RealApiFunc(hToken, ulRID)
  else
  begin
    Result := AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
      SECURITY_BUILTIN_DOMAIN_RID, ulRID, 0, 0, 0, 0, 0, 0, SidToCheck);
    if Result then
    try
      if not CheckTokenMembership(THandle(nil), SidToCheck, Result) then
        Result := False;
    finally
      FreeSid(SidToCheck);
    end;
  end;
end;

function IsUserAnAdmin(): BOOL;
const
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
type
  TFNIsUserAnAdmin = function(): BOOL; stdcall;
{$WRITEABLECONST ON}
const
  Initialized: Integer = 0;
  RealApiFunc: TFNIsUserAnAdmin = nil;
{$WRITEABLECONST OFF}
begin
  if Initialized = 0 then
  begin
    RealApiFunc := TFNIsUserAnAdmin(
      GetProcAddress(GetShell32Lib(), 'IsUserAnAdmin'));
    InterlockedIncrement(Initialized);
  end;
  if Assigned(RealApiFunc) then
    Result := RealApiFunc()
  else
    Result := SHTestTokenMembership(THandle(nil), DOMAIN_ALIAS_RID_ADMINS);
end;

end.

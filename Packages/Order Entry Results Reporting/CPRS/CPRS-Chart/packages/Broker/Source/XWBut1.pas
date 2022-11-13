{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey, Herlan Westra
  Description: Contains TRPCBroker and related components.
  Unit: XWBut1 contains utilities used by the BDK.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.
  2. Added   REG_IAMRIOSERVICE = 'Software\Vista\Common\RIOSERVER' and
  REG_IAMRIOPORT = 'Software\Vista\Common\RIOPORT' entries for the
  IAM service name and IAM port name.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. Added REG_IAM Key for obtaining Identity and Access Management (IAM)
  Secure Token Service (STS) URL from Windows registry.

  Changes in v1.1.60 (HGW 05/08/2014) XWB*1.1*60
  1. Change to set access permissions when reading from or writing
  to Windows registry.
  2. Fixed deletion of key values (was trying to delete a key).

  Changes in v1.1.47 (JLI 06/17/2008) XWB*1.1*47
  1. Deleted unused code.
  ************************************************** }

unit XWBut1;

interface

uses
  {System}
  System.Sysutils, System.Classes, System.IniFiles,
  {System.Win}
  System.Win.Registry,
  {WinApi}
  WinApi.Messages, WinProcs,
  {Vcl}
  Vcl.Dialogs;

const
  xwb_ConnectAction = wm_User + 200;
  IniFile = 'VISTA.INI'; // This is no longer used.
  BrokerSection = 'RPCBroker';
  BrokerServerSection = 'RPCBroker_Servers';
  TAB = #9;
  { For Registry interaction }
  { Roots }
  HKCR = HKEY_CLASSES_ROOT;
  HKCU = HKEY_CURRENT_USER;
  HKLM = HKEY_LOCAL_MACHINE;
  HKU = HKEY_USERS;
  HKCC = HKEY_CURRENT_CONFIG;
  HKDD = HKEY_DYN_DATA;
  { Keys }
  REG_IAM = 'Software\Vista\Common\IAM';
  REG_IAM_AD = 'Software\Vista\Common\IAM_AD';
  REG_IAMRIOSERVICE = 'Software\Vista\Common\RIOSERVER'; // p71
  REG_IAMRIOPORT = 'Software\Vista\Common\RIOPORT'; // p71
  REG_BROKER = 'Software\Vista\Broker';
  REG_VISTA = 'Software\Vista';
  REG_SIGNON = 'Software\Vista\Signon';
  REG_SERVERS = 'Software\Vista\Broker\Servers';

var
  RetryLimit: integer;

function BuildSect(s1: string; s2: string): string;
procedure GetHostList(HostList: TStrings);
function GetHostsPath: String;
function GetIniValue(Value, Default: string): string;
function Iff(Condition: boolean; strTrue, strFalse: string): string;
function Sizer(s1: string; s2: string): string;
function ReadRegData(Root: HKEY; Key, Name: string): string;
procedure WriteRegData(Root: HKEY; Key, Name, Value: string);
procedure DeleteRegData(Root: HKEY; Key, Name: string);
function ReadRegDataDefault(Root: HKEY; Key, Name, Default: string): string;
procedure ReadRegValues(Root: HKEY; Key: string; var RegValues: TStringList);
procedure ReadRegValueNames(Root: HKEY; Key: string; var RegNames: TStringList);

implementation

{ ---------------------------- BuildSect ---------------------------
  ------------------------------------------------------------------ }
Function BuildSect(s1: string; s2: string): string;
var
  s, x: String; // JLI 090804
begin
  if s2 <> '' then
    s := s1 + s2
  else
    s := s1;
  x := IntToStr(length(s));
  if length(x) = 1 then
    x := '00' + x;
  if length(x) = 2 then
    x := '0' + x;
  Result := x + s;
end;

{ --------------------------- GetHostList --------------------------
  Reads HOSTS file and fills the passed HostList with all
  entries from that file.
  ------------------------------------------------------------------ }
procedure GetHostList(HostList: TStrings);
var
  I, SpacePos: integer;
  IP, HostName: string;
  s: string; // Individual line from Hosts file.
  WholeList: TStringList;
begin

  HostList.Clear;
  WholeList := nil;
  try
    WholeList := TStringList.Create; { create temp buffer }
    WholeList.LoadFromFile(GetHostsPath + '\HOSTS'); { read in the file }
    for I := 0 to WholeList.Count - 1 do
    begin
      s := WholeList[I];
      { ignore lines that start with '#' and empty lines }
      if (Copy(s, 1, 1) <> '#') and (length(s) > 0) then
      begin
        while Pos(TAB, s) > 0 do // Convert tabs to spaces
          s[Pos(TAB, s)] := ' ';
        IP := Copy(s, 1, Pos(' ', s) - 1); { get IP addr }
        { parse out Host name }
        SpacePos := length(IP) + 1;
        while Copy(s, SpacePos, 1) = ' ' do
          inc(SpacePos);
        HostName := Copy(s, SpacePos, 255);
        if Pos(' ', HostName) > 0 then
          HostName := Copy(HostName, 1, Pos(' ', HostName) - 1);
        if Pos('#', HostName) > 0 then
          HostName := Copy(HostName, 1, Pos('#', HostName) - 1);
        HostList.Add(HostName + '   [' + IP + ']');
      end { if };
    end { for };
  finally
    WholeList.Free;
  end { try };
end;

{ GetHostsPath returns path to host file without terminating '\'.
  If path in VISTA.INI that is used.  Otherwise, path is determined based
  on default windows directory and Windows OS. }
function GetHostsPath: String;
var
  OsInfo: TOSVersionInfo; // Type for OS info
  HostsPath: String;
  WinDir: PChar;
begin
  Result := '';
  OsInfo.dwOSVersionInfoSize := SizeOf(OsInfo);
  GetVersionEx(OsInfo); // Retrieve OS info
  WinDir := StrAlloc(MAX_PATH + 1);
  GetWindowsDirectory(WinDir, MAX_PATH); // Retieve windows directory
  HostsPath := StrPas(WinDir);
  StrDispose(WinDir);
  { Now check OS.  VER_PLATFORM_WIN32_WINDOWS indicates Windows 95.
    If Windows 95, hosts default directory is windows directory.
    Else assume NT and append NT's directory for hosts to windows directory. }
  if OsInfo.dwPlatformID <> VER_PLATFORM_WIN32_WINDOWS then
    HostsPath := HostsPath + '\system32\drivers\etc';
  HostsPath := GetIniValue('HostsPath', HostsPath);
  if Copy(HostsPath, length(HostsPath), 1) = '\' then // Strip terminating '\'
    HostsPath := Copy(HostsPath, 1, length(HostsPath) - 1);
  Result := HostsPath;
end;

{ -------------------------- GetIniValue --------------------------
  ------------------------------------------------------------------ }
function GetIniValue(Value, Default: string): string;
var
  DhcpIni: TIniFile;
  pchWinDir: array [0 .. 100] of char;
begin
  GetWindowsDirectory(pchWinDir, SizeOf(pchWinDir));
  DhcpIni := TIniFile.Create(IniFile);
  Result := DhcpIni.ReadString(BrokerSection, Value, 'Could not find!');
  if Result = 'Could not find!' then
  begin
    { during Broker install Installing=1 so warnings should not display }
    if ((Value <> 'Installing') and (GetIniValue('Installing', '0') <> '1'))
    then
    begin
      DhcpIni.WriteString(BrokerSection, Value, Default);
    end;
    Result := Default;
  end;
  DhcpIni.Free;
end;

{ ------------------------------ Iff ------------------------------
  ------------------------------------------------------------------ }
function Iff(Condition: boolean; strTrue, strFalse: string): string;
begin
  if Condition then
    Result := strTrue
  else
    Result := strFalse;
end;

{ ------------------------------ Sizer -----------------------------
  This function is used in conjunction with the ListSetUp function.  It returns
  the number of characters found in the string passed in.  The string is
  returned with a leading 0 for the 3 character number format required by the
  broker call.
  ------------------------------------------------------------------ }
function Sizer(s1: string; s2: string): string;
var
  x: integer;
  st: string;
begin
  st := s1 + s2;
  x := length(st);
  st := IntToStr(x);
  if length(st) < 3 then
    Result := '0' + st
  else
    Result := st;
end;

{ Function to retrieve a data value from the Windows Registry.
  If Key or Name does not exist, null returned. }
function ReadRegData(Root: HKEY; Key, Name: string): string;
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := Root;
    Registry.Access := KEY_READ; // p60
    if Registry.OpenKey(Key, False) then
    begin
      Result := Registry.ReadString(Name);
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

{ Function to set a data value into the Windows Registry.
  If Key or Name does not exist, it is created.
  p60 - Change to set high-level access to Windows registry }
procedure WriteRegData(Root: HKEY; Key, Name, Value: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE); // p60
  try
    Registry.RootKey := Root;
    Registry.Access := KEY_WRITE; // p60
    if Registry.OpenKey(Key, True) then
      Registry.WriteString(Name, Value);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

{ Procedure to delete a data value into the Windows Registry.
  p60 - Change to set high-level access to Windows registry }
procedure DeleteRegData(Root: HKEY; Key, Name: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE); // p60
  try
    Registry.RootKey := Root;
    Registry.Access := KEY_WRITE; // p60
    if Registry.OpenKey(Key, True) then
      Registry.DeleteValue(Name);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

{ Returns string value from registry.  If value is '', then Default
  value is filed in Registry and Default is returned. }
function ReadRegDataDefault(Root: HKEY; Key, Name, Default: string): string;
begin
  Result := ReadRegData(Root, Key, Name);
  if Result = '' then
  begin
    WriteRegData(Root, Key, Name, Default);
    Result := Default;
  end;
end;

{ Returns name=value pairs for a key.  Format returned same as found in .ini
  files.  Useful with the Values method of TStringList. }
procedure ReadRegValues(Root: HKEY; Key: string; var RegValues: TStringList);
var
  RegNames: TStringList;
  Registry: TRegistry;
  I: integer;
begin
  RegNames := TStringList.Create;
  Registry := TRegistry.Create(KEY_READ); // p60
  try
    Registry.RootKey := Root;
    Registry.Access := KEY_READ; // p60
    if Registry.OpenKey(Key, False) then
    begin
      Registry.GetValueNames(RegNames);
      for I := 0 to (RegNames.Count - 1) do
        RegValues.Add(RegNames.Strings[I] + '=' + Registry.ReadString
          (RegNames.Strings[I]));
    end
    else
      RegValues.Add('');
  finally
    Registry.Destroy;
    RegNames.Free;
  end;
end;

procedure ReadRegValueNames(Root: HKEY; Key: string; var RegNames: TStringList);
var
  Registry: TRegistry;
  ReturnedNames: TStringList;
begin
  RegNames.Clear;
  Registry := TRegistry.Create(KEY_READ); // p60
  ReturnedNames := TStringList.Create;
  try
    Registry.RootKey := Root;
    Registry.Access := KEY_READ; // p60
    if Registry.OpenKey(Key, False) then
    begin
      Registry.GetValueNames(ReturnedNames);
      RegNames.Assign(ReturnedNames);
    end;
  finally
    Registry.Free;
    ReturnedNames.Free;
  end;
end;

end.

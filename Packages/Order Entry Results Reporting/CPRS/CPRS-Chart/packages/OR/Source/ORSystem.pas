unit ORSystem;

{$O-}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses 
  Windows;

const
  CPRS_ROOT_KEY =  HKEY_LOCAL_MACHINE;
  CPRS_USER_KEY =  HKEY_CURRENT_USER;
  CPRS_SOFTWARE = 'Software\Vista\CPRS';
  CPRS_REG_AUTO = 'AutoUpdate';
  CPRS_REG_GOLD = 'GoldCopyPath';
  CPRS_REG_ONLY = 'LimitUpdate';
  CPRS_REG_ASK  = 'AskFirst';
  CPRS_REG_LAST = 'LastUpdate-';
  CPRS_USER_LAST = 'Software\Vista\CPRS\LastUpdate';
  CPRS_LAST_DATE = 'Software\Vista\CPRS\DateUpdated';

function ClientVersion(const AFileName: string): string;
function CompareVersion(const A, B: string): Integer;
procedure CopyFileDate(const Source, Dest: string);
procedure CopyLastWriteTime(const Source, Dest: string);
procedure Delay(i: Integer; AllowUserInput: Boolean = true);
function FullToFilePart(const AFileName: string): string;
function FullToPathPart(const AFileName: string): string;
function IsWin95Style: Boolean;
function ParamIndex(const AName: string): Integer;
function ParamSearch(const AName: string): string;
function QuotedExeName: string;
function RegKeyExists(ARoot: HKEY; const AKey: string): Boolean;
function RegReadInt(const AName: string): Integer;
function RegReadStr(const AName: string): string;
function RegReadBool(const AName: string): Boolean;
procedure RegWriteInt(const AName: string; AValue: Integer);
procedure RegWriteStr(const AName, AValue: string);
procedure RegWriteBool(const AName: string; AValue: Boolean);
function UserRegReadDateTime(const AKey, AName: string): TDateTime;
procedure UserRegWriteDateTime(const AKey, AName: string; AValue: TDateTime);
function UserRegReadInt(const AKey, AName: string): Integer;
procedure UserRegWriteInt(const AKey, AName: string; AValue: Integer);
procedure RunProgram(const AppName: string);
function BorlandDLLVersionOK: boolean;

implementation

uses
  SysUtils, Classes, Forms, Registry, ORFn, UResponsiveGUI;

const
  CREATE_KEY = True;  // cause key to be created if it's not in the registry

function FileLastWrite(const FileName: string): LARGE_INTEGER;
var
  AHandle: THandle;
  FindData: TWin32FindData;
begin
  Result.QuadPart := 0;
  AHandle := FindFirstFile(PChar(FileName), FindData);
  if AHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(AHandle);
    Result.LowPart  := FindData.ftLastWriteTime.dwLowDateTime;
    Result.HighPart := FindData.ftLastWriteTime.dwHighDateTime;
  end;
end;

function ClientVersion(const AFileName: string): string;
var
  ASize, AHandle: DWORD;
  Buf: string;
  FileInfoPtr: Pointer; //PVSFixedFileInfo;
begin
  Result := '';
  ASize:=GetFileVersionInfoSize(PChar(AFileName), AHandle);
  if ASize > 0 then
  begin
    SetLength(Buf, ASize);
    GetFileVersionInfo(PChar(AFileName), AHandle, ASize, Pointer(Buf));
    VerQueryValue(Pointer(Buf), '\', FileInfoPtr, ASize);
    with TVSFixedFileInfo(FileInfoPtr^) do Result := IntToStr(HIWORD(dwFileVersionMS)) + '.' +
                                                     IntToStr(LOWORD(dwFileVersionMS)) + '.' +
                                                     IntToStr(HIWORD(dwFileVersionLS)) + '.' +
                                                     IntToStr(LOWORD(dwFileVersionLS));
  end;
end;

function CompareVersion(const A, B: string): Integer;
// Result Low Integer means A is not a valid version number
// Result Low Integer + 1 means B is not a valid version number
// Result <> 0 means version numbers do not match
// Result = 0 means version numbers match
var
  NumA, NumB: array [0..3] of Integer;
begin
  NumA[0] := StrToIntDef(Piece(A, '.', 1), -1) * 16777216;
  NumA[1] := StrToIntDef(Piece(A, '.', 2), -1) * 65536;
  NumA[2] := StrToIntDef(Piece(A, '.', 3), -1) * 256;
  NumA[3] := StrToIntDef(Piece(A, '.', 4), -1);
  if (NumA[0] < 0) or (NumA[1] < 0) or (NumA[2] < 0) or (NumA[3] < 0) then
    Exit(Low(Integer));

  NumB[0] := StrToIntDef(Piece(B, '.', 1), -1) * 16777216;
  NumB[1] := StrToIntDef(Piece(B, '.', 2), -1) * 65536;
  NumB[2] := StrToIntDef(Piece(B, '.', 3), -1) * 256;
  NumB[3] := StrToIntDef(Piece(B, '.', 4), -1);
  if (NumB[0] < 0) or (NumB[1] < 0) or (NumB[2] < 0) or (NumB[3] < 0) then
    Exit(Low(Integer)+1);

  Result := NumA[0] + NumA[1] + NumA[2] + NumA[3] -
    NumB[0] - NumB[1] - NumB[2] - NumB[3];
end;

procedure CopyFileDate(const Source, Dest: string);
{ from TI2972 }
var
  SourceHand, DestHand: Integer;
begin
  SourceHand := FileOpen(Source, fmOutput);       { open source file }
  DestHand := FileOpen(Dest, fmInput);            { open dest file }
  FileSetDate(DestHand, FileGetDate(SourceHand)); { get/set date }
  FileClose(SourceHand);                          { close source file }
  FileClose(DestHand);                            { close dest file }
end;

procedure CopyLastWriteTime(const Source, Dest: string);
var
  HandleSrc, HandleDest: Integer;
  LastWriteTime: TFileTime;
begin
  HandleSrc  := FileOpen(Source, fmOpenRead or fmShareDenyNone);
  HandleDest := FileOpen(Dest,   fmOpenWrite);
  if (HandleSrc > 0) and (HandleDest > 0) then
  begin
    if GetFileTime(THandle(HandleSrc), nil, nil, @LastWriteTime) = TRUE
      then SetFileTime(THandle(HandleDest), nil, nil, @LastWriteTime);
    FileClose(HandleSrc);
    FileClose(HandleDest);
  end;
end;

procedure Delay(i: Integer; AllowUserInput: Boolean = true);
const
  AMilliSecond = 0.000000011574;
var
  Start: TDateTime;
begin
  Start := Now;
  while Now < (Start + (i * AMilliSecond)) do
  begin
    If AllowUserInput then
      Application.ProcessMessages
    else
      TResponsiveGUI.ProcessMessages;
  end;
end;

procedure FileCopy(const FromFileName, ToFileName: string);
var
  FromFile, ToFile: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..16384] of Char;
begin
  AssignFile(FromFile, FromFileName);                  // Input file
  Reset(FromFile, 1);		                               // Record size = 1
  AssignFile(ToFile, ToFileName);	                     // Output file
  Rewrite(ToFile, 1);		                               // Record size = 1
  repeat
    BlockRead(FromFile, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToFile, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromFile);
  CloseFile(ToFile);
end;

procedure FileCopyWithDate(const FromFileName, ToFileName: string);
var
  FileHandle, ADate: Integer;
begin
  FileCopy(FromFileName, ToFileName);
  FileHandle := FileOpen(FromFileName, fmOpenRead or fmShareDenyNone);
  ADate := FileGetDate(FileHandle);
  FileClose(FileHandle);
  if ADate < 0 then Exit;
  FileHandle := FileOpen(ToFileName, fmOpenWrite or fmShareDenyNone);
  if FileHandle > 0 then FileSetDate(FileHandle, ADate);
  FileClose(FileHandle);
end;

procedure CopyFileWithDate(const FromFileName, ToFileName: string);
var
  FileHandle, ADate: Integer;
begin
  if CopyFile(PChar(FromFileName), PChar(ToFileName), False) then
  begin
    FileHandle := FileOpen(FromFileName, fmOpenRead or fmShareDenyNone);
    ADate := FileGetDate(FileHandle);
    FileClose(FileHandle);
    if ADate < 0 then Exit;
    FileHandle := FileOpen(ToFileName, fmOpenWrite or fmShareDenyNone);
    if FileHandle > 0 then FileSetDate(FileHandle, ADate);
    FileClose(FileHandle);
  end;
end;

function FullToFilePart(const AFileName: string): string;
var
  DirBuf: string;
  FilePart: PChar;
  NameLen: DWORD;
begin
  Result := '';
  SetString(DirBuf, nil, 255);
  NameLen := GetFullPathName(PChar(AFileName), 255, PChar(DirBuf), FilePart);
  if NameLen > 0 then Result := FilePart;
end;

function FullToPathPart(const AFileName: string): string;
var
  DirBuf: string;
  FilePart: PChar;
  NameLen: Cardinal;
begin
  Result := '';
  SetString(DirBuf, nil, 255);
  NameLen := GetFullPathName(PChar(AFileName), 255, PChar(DirBuf), FilePart);
  if NameLen > 0 then Result := Copy(DirBuf, 1, NameLen - StrLen(FilePart));
end;

function IsWin95Style: Boolean;
begin
  Result := Lo(GetVersion) >= 4;          // True = Win95 interface, otherwise old interface
end;

function ParamIndex(const AName: string): Integer;
var
  i: Integer;
  x: string;
begin
  Result := 0;
  for i := 1 to ParamCount do
  begin
    x := UpperCase(ParamStr(i));
    x := Piece(x, '=', 1);
    if x = Uppercase(AName) then
    begin
      Result := i;
      Break;
    end;
  end; {for i}
end;

function ParamSearch(const AName: string): string;
var
  i: Integer;
  x: string;
begin
  Result := '';
  for i := 1 to ParamCount do
  begin
    x := UpperCase(ParamStr(i));
    x := Copy(x, 1, Pos('=', x) - 1);
    if x = Uppercase(AName) then
    begin
      Result := UpperCase(Copy(ParamStr(i), Length(x) + 2, Length(ParamStr(i))));
      Break;
    end;
  end; {for i}
end;

function QuotedExeName: string;
var
  i: Integer;
begin
  Result := '"' + ParamStr(0) + '"';
  for i := 1 to ParamCount do Result := Result + ' ' + ParamStr(i);
end;

function RegReadInt(const AName: string): Integer;
var
  Registry: TRegistry;
begin
  Result := 0;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKeyReadOnly(CPRS_SOFTWARE) and Registry.ValueExists(AName)
      then Result := Registry.ReadInteger(AName);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

function RegReadStr(const AName: string): string;
var
  Registry: TRegistry;
begin
  Result := '';
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKeyReadOnly(CPRS_SOFTWARE) and Registry.ValueExists(AName)
      then Result := Registry.ReadString(AName);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

function RegReadBool(const AName: string): Boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKeyReadOnly(CPRS_SOFTWARE) and Registry.ValueExists(AName)
      then Result := Registry.ReadBool(AName);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure RegWriteInt(const AName: string; AValue: Integer);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKey(CPRS_SOFTWARE, CREATE_KEY) then Registry.WriteInteger(AName, AValue);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure RegWriteStr(const AName, AValue: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKey(CPRS_SOFTWARE, CREATE_KEY) then Registry.WriteString(AName, AValue);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure RegWriteBool(const AName: string; AValue: Boolean);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_ROOT_KEY;
    if Registry.OpenKey(CPRS_SOFTWARE, CREATE_KEY) then Registry.WriteBool(AName, AValue);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

function RegKeyExists(ARoot: HKEY; const AKey: string): Boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := ARoot;
    //Result := Registry.KeyExists(AKey); {this tries to open key with full access}
    if Registry.OpenKeyReadOnly(AKey) and (Registry.CurrentKey <> 0) then Result := True;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

function UserRegReadDateTime(const AKey, AName: string): TDateTime;
var
  Registry: TRegistry;
begin
  Result := 0;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_USER_KEY;
    if Registry.OpenKey(AKey, CREATE_KEY) and Registry.ValueExists(AName) then
    try
      Result := Registry.ReadDateTime(AName);
    except
      on ERegistryException do Result := 0;
    end;
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure UserRegWriteDateTime(const AKey, AName: string; AValue: TDateTime);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_USER_KEY;
    if Registry.OpenKey(AKey, CREATE_KEY) then Registry.WriteDateTime(AName, AValue);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

function UserRegReadInt(const AKey, AName: string): Integer;
var
  Registry: TRegistry;
begin
  Result := 0;
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_USER_KEY;
    if Registry.OpenKey(AKey, CREATE_KEY) and Registry.ValueExists(AName)
      then Result := Registry.ReadInteger(AName);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure UserRegWriteInt(const AKey, AName: string; AValue: Integer);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := CPRS_USER_KEY;
    if Registry.OpenKey(AKey, CREATE_KEY) then Registry.WriteInteger(AName, AValue);
    Registry.CloseKey;
  finally
    Registry.Free;
  end;
end;

procedure RunProgram(const AppName: string);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  FillChar(StartInfo, SizeOf(StartInfo), 0);
  StartInfo.CB := SizeOf(StartInfo);
  CreateProcess(nil, PChar(AppName), nil, nil, False, DETACHED_PROCESS or NORMAL_PRIORITY_CLASS,
    nil, nil, StartInfo, ProcInfo);
end;

function BorlandDLLVersionOK: boolean;
const
  DLL_CURRENT_VERSION = 10;
  TC_DLL_ERR   = 'ERROR - BORLNDMM.DLL';
  TX_NO_RUN    = 'This version of CPRS is unable to run because' + CRLF;
  TX_NO_DLL    = 'no copy of BORLNDMM.DLL can be found' + CRLF +
                 'in your workstation''s current PATH.';
  TX_OLD_DLL1  = 'the copy of BORLNDMM.DLL located at:' + CRLF + CRLF;
  TX_OLD_DLL2  = CRLF + CRLF + 'is out of date  (Version ';
  TX_CALL_IRM  = CRLF + CRLF +'Please contact IRM for assistance.';
var
  DLLHandle: HMODULE;
  DLLNamePath: array[0..261] of Char;
  DLLVersion: string;
begin
  Result := TRUE;
  DLLHandle := GetModuleHandle('BORLNDMM.DLL');
  if DLLHandle <=0 then
  begin
    InfoBox(TX_NO_RUN + TX_NO_DLL + TX_CALL_IRM, TC_DLL_ERR, MB_ICONERROR or MB_OK);
    Result := FALSE;
    Exit;
  end;
  Windows.GetModuleFileName(DLLHandle, DLLNamePath, 261);
  DLLVersion := ClientVersion(DLLNamePath);
  if StrToIntDef(Piece(DLLVersion, '.', 1), 0) < DLL_CURRENT_VERSION then
  begin
    InfoBox(TX_NO_RUN + TX_OLD_DLL1 + '   ' + DLLNamePath + TX_OLD_DLL2 + DLLVersion + ')' +
            TX_CALL_IRM, TC_DLL_ERR, MB_ICONERROR or MB_OK);
    Result := false;
  end;
end;

end.

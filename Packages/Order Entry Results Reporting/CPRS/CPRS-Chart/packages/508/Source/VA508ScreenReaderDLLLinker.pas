unit VA508ScreenReaderDLLLinker;

interface

{ TODO -oJeremy Merrill -c508 :Add ability to handle multiple instances / multiple appliations to JAWS at the same time -
  will need to use Application.MainForm handle approach, probably need to use different
  registry keys with handle in registry key name.  JAWS has a GetAppMainWindow command
  to get the handle.  Will need a cleanup command in delphi to make sure we don't leave
  junk in the registry - probably search running apps, and if the main form's handle isn't in
  the registry, delete entries. }
uses
  Windows, SysUtils, Forms, Classes, VA508AccessibilityConst;

{$I 'VA508ScreenReaderDLLStandard.inc'}
// Returns true if a link to a screen reader was successful.  The first link that
// is established causes searching to stop.
// Searches for .SR files in this order:
// 1) Current machine's Program Files directory
// 2) \Program Files directory on drive where app resides,
// if it's different than the current machine's program files directory
// 3) The directory the application was run from.

function ScreenReaderDLLsExist: boolean;
function IsScreenReaderSupported(Unload: boolean): boolean;
function InitializeScreenReaderLink: boolean;
procedure CloseScreenReaderLink;
function CheckForJaws(): boolean;

type
  TVA508RegisterCustomBehaviorProc = procedure(BehaviorType: integer;
    Before, After: PChar); stdcall;
  TVA508SpeakTextProc = procedure(Text: PChar); stdcall;
  TVA508IsRunningFunc = function(HighVersion, LowVersion: Word): BOOL; stdcall;
  TVA508CheckJawsFunc = function(): BOOL; stdcall;
  TVA508ConfigChangePending = function: boolean; stdcall;
  TVA508ComponentDataProc = procedure(WindowHandle: HWND;
    DataStatus: LongInt = DATA_NONE; Caption: PChar = nil; Value: PChar = nil;
    Data: PChar = nil; ControlType: PChar = nil; State: PChar = nil;
    Instructions: PChar = nil; ItemInstructions: PChar = nil); stdcall;

var
  SRSpeakText: TVA508SpeakTextProc = nil;
  SRIsRunning: TVA508IsRunningFunc = nil;
  SRCheckJaws: TVA508CheckJawsFunc = nil;
  SRRegisterCustomBehavior: TVA508RegisterCustomBehaviorProc = nil;
  SRComponentData: TVA508ComponentDataProc = nil;
  SRConfigChangePending: TVA508ConfigChangePending = nil;
  // ValidSRFiles: TStringList = nil;
  ValidSRFile: String = '';
  ExecuteFind: boolean = TRUE;
  DoInitialize: boolean = TRUE;
  InitializeResult: boolean = FALSE;

implementation

uses VAUtils, VA508AccessibilityRouter, VA508AccessibilityManager,
  system.inifiles, system.Win.Registry, system.Math;

const
{$IFDEF VER180}
  ScreenReaderFileExtension = '.SR';
{$ELSE}
  ScreenReaderFileExtension = '.SR3';
{$ENDIF}
  ScreenReaderCommonFilesDir = 'VistA\Common Files\';
  ScreenReaderSearchSpec = '*' + ScreenReaderFileExtension;
{$WARNINGS OFF}   // Ignore platform specific code warning
  BadFile = faHidden or faSysFile or faDirectory or faSymLink;
{$WARNINGS ON}
  DllCallError =
    'The following error occured when trying to run %s from the Jaws framework. Error: %s';
  JAWS_SCRIPT_LIST = 'VA508ScriptList.INI';

  cOsUnknown = -1;
  cOsWin95 = 0;
  cOsWin98 = 1;
  cOsWin98SE = 2;
  cOsWinME = 3;
  cOsWinNT = 4;
  cOsWin2000 = 5;
  cOsXP = 6;
  cOSWin7 = 7;

{$REGION 'Initialize Proc Definition'}

type
  TVA508InitializeProc = function(CallBackProc: TComponentDataRequestProc)
    : BOOL; stdcall;
  TVA508InitializeExProc = function(ComponentCallBackProc
    : TComponentDataRequestProc; DoThread: boolean; ShowSplash: boolean;
    HostApplication: String): BOOL; stdcall;

const
  TVA508InitializeProcName = 'Initialize';
  TVA508InitializeExProcName = 'InitializeEx';

var
  SRInitialize: TVA508InitializeProc = nil;
  SRInitializeEx: TVA508InitializeExProc = nil;

function Initialize(ComponentCallBackProc: TComponentDataRequestProc)
  : BOOL; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508InitializeProc;
begin
  CompileVerification := Initialize;
  Result := FALSE;
end;

function InitializeEx(ComponentCallBackProc: TComponentDataRequestProc;
  DoThread: boolean; ShowSplash: boolean; HostApplication: String)
  : BOOL; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508InitializeExProc;
begin
  CompileVerification := InitializeEx;
  Result := FALSE;
end;

{$HINTS ON}
{$ENDREGION}
{$REGION 'ShutDown Proc Definition'}

type
  TVA508ShutDownProc = procedure; stdcall;

const
  TVA508ShutDownProcName = 'ShutDown';

var
  SRShutDown: TVA508ShutDownProc = nil;

procedure ShutDown; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508ShutDownProc;
begin
  CompileVerification := ShutDown;
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'RegisterCustomBehavior Proc Definition'}

const
  TVA508RegisterCustomBehaviorProcName = 'RegisterCustomBehavior';

procedure RegisterCustomBehavior(BehaviorType: integer;
  Before, After: PChar); stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508RegisterCustomBehaviorProc;
begin
  CompileVerification := RegisterCustomBehavior;
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'ComponentData Proc Definition'}

const
  TVA508ComponentDataProcName = 'ComponentData';

procedure ComponentData(WindowHandle: HWND; DataStatus: LongInt = DATA_NONE;
  Caption: PChar = nil; Value: PChar = nil; Data: PChar = nil;
  ControlType: PChar = nil; State: PChar = nil; Instructions: PChar = nil;
  ItemInstructions: PChar = nil); stdcall;

{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508ComponentDataProc;
begin
  CompileVerification := ComponentData;
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'SpeakText Proc Definition'}

const
  TVA508SpeakTextProcName = 'SpeakText';

procedure SpeakText(Text: PChar); stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508SpeakTextProc;
begin
  CompileVerification := SpeakText;
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'IsRunning Proc Definition'}

const
  TVA508IsRunningFuncName = 'IsRunning';

function IsRunning(HighVersion, LowVersion: Word): BOOL; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508IsRunningFunc;
begin
  CompileVerification := IsRunning;
  Result := FALSE; // avoid compiler warning...
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'CheckForJaws Proc Definition'}

const
  TVA508CheckJawsFuncName = 'FindJaws';

function FindJaws(): BOOL; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508CheckJawsFunc;
begin
  CompileVerification := FindJaws;
  Result := FALSE; // avoid compiler warning...
end;
{$HINTS ON}
{$ENDREGION}
{$REGION 'ConfigChangePending Proc Definition'}

const
  TVA508ConfigChangePendingName = 'ConfigChangePending';

function ConfigChangePending: boolean; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508ConfigChangePending;
begin
  CompileVerification := ConfigChangePending;
  Result := FALSE; // avoid compiler warning...
end;
{$HINTS ON}
{$ENDREGION}

var
  DLLHandle: THandle = 0;

procedure ClearProcPointers;
begin
  SRInitialize := nil;
  SRInitializeEx := nil;
  SRShutDown := nil;
  SRRegisterCustomBehavior := nil;
  SRSpeakText := nil;
  SRIsRunning := nil;
  SRComponentData := nil;
  SRConfigChangePending := nil;
  DoInitialize := FALSE;
  InitializeResult := FALSE;
end;

Function ProcessInitialize: boolean;

  function FindScriptFileLocation(aBasePath, aFileName: string): String;
  const
    Jaws_Script_Folder = 'Jaws Scripts';
  var
    ScriptDir: String;
  begin
    aBasePath := AppendBackSlash(aBasePath);
    ScriptDir := Jaws_Script_Folder;
    ScriptDir := AppendBackSlash(ScriptDir);
    if FileExists(aBasePath + ScriptDir + aFileName) then
      Result := aBasePath + ScriptDir
    else if FileExists(aBasePath + aFileName) then
      Result := aBasePath
    else
      Result := '';
  end;

  Function RunInitEx(var aRtnValue: boolean; aIniFile: TINIFile;
    aSectionName, HostApp: String): boolean;
  const
    subSection = 'SplashScreen';
    p = '|';
  var
    SectionValue: String;
  begin
    Result := FALSE;
    if aIniFile.ValueExists(aSectionName, subSection) then
    begin
      SectionValue := aIniFile.ReadString(aSectionName, subSection, '');
      if not(Trim(SectionValue) = '') then
      begin
        aRtnValue := SRInitializeEx(ComponentDataRequested,
          Uppercase(Piece(SectionValue, p, 1)) = 'TRUE',
          Uppercase(Piece(SectionValue, p, 2)) = 'TRUE', HostApp);
        Result := TRUE;
      end;
    end;
  end;

var
  ScriptsFileName, SectionName, path: String;
  ScriptsFile: TINIFile;
begin
  Result := FALSE;
  ScriptsFileName := FindScriptFileLocation(ExtractFilePath(ValidSRFile),
    JAWS_SCRIPT_LIST);
  if ScriptsFileName <> '' then
  begin
    ScriptsFileName := AppendBackSlash(ScriptsFileName) + JAWS_SCRIPT_LIST;
    if FileExists(ScriptsFileName) then
    begin
      ScriptsFile := TINIFile.Create(ScriptsFileName);
      try
        SetLength(path, MAX_PATH);
        SetLength(path, GetModuleFileName(HInstance, PChar(path),
          Length(path)));

        // second look for a specific version
        SectionName := Piece(ExtractFileName(path), '.', 1) + '|' +
          FileVersionValue(path, FILE_VER_FILEVERSION);

        If not RunInitEx(Result, ScriptsFile, SectionName, path) then
        begin
          SectionName := Piece(ExtractFileName(path), '.', 1);
          If not RunInitEx(Result, ScriptsFile, SectionName, path) then
            Result := SRInitialize(ComponentDataRequested);
        end;

      finally
        ScriptsFile.Free;
      end;

    end;
  end
  else
    Result := SRInitialize(ComponentDataRequested);
end;

function InitializeScreenReaderLink: boolean;
begin
  if DoInitialize then
  begin
    try
      InitializeResult := ProcessInitialize;
      // SRInitialize(ComponentDataRequested);
    Except
      On e: Exception do
        raise e.Create(Format(DllCallError, ['SRInitialize', e.Message]));
    End;
    DoInitialize := FALSE;
    if not InitializeResult then
      CloseScreenReaderLink;
  end;
  Result := InitializeResult;
end;

procedure CloseScreenReaderLink;
begin
  if DLLHandle > HINSTANCE_ERROR then
  begin
    try
      SRShutDown;
    Except
      On e: Exception do
        raise e.Create(Format(DllCallError, ['SRShutDown', e.Message]));
    End;
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
    ClearProcPointers;
  end;
end;

procedure LoadScreenReader();
var
  FileName: string;
begin
  FileName := ValidSRFile; // ValidSRFiles[index];
  DLLHandle := LoadLibrary(PChar(FileName));
  if DLLHandle > HINSTANCE_ERROR then
  begin
    if not assigned(SRInitialize) then
      SRInitialize := GetProcAddress(DLLHandle, TVA508InitializeProcName);
    if not assigned(SRInitializeEx) then
      SRInitializeEx := GetProcAddress(DLLHandle, TVA508InitializeExProcName);
    if not assigned(SRShutDown) then
      SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName);
    if not assigned(SRRegisterCustomBehavior) then
      SRRegisterCustomBehavior := GetProcAddress(DLLHandle,
        TVA508RegisterCustomBehaviorProcName);
    if not assigned(SRSpeakText) then
      SRSpeakText := GetProcAddress(DLLHandle, TVA508SpeakTextProcName);
    if not assigned(SRIsRunning) then
      SRIsRunning := GetProcAddress(DLLHandle, TVA508IsRunningFuncName);
    if not assigned(SRComponentData) then
      SRComponentData := GetProcAddress(DLLHandle, TVA508ComponentDataProcName);
    if not assigned(SRConfigChangePending) then
      SRConfigChangePending := GetProcAddress(DLLHandle,
        TVA508ConfigChangePendingName);
    DoInitialize := TRUE;
  end;
end;

function CheckForJaws(): boolean;
var
  FileName: string;
begin
  Result := FALSE;
  // for I := 0 to ValidSRFiles.Count - 1 do
  // begin
  FileName := ValidSRFile; // ValidSRFiles[I];
  DLLHandle := LoadLibrary(PChar(FileName));
  try
    if DLLHandle > HINSTANCE_ERROR then
    begin
      if not assigned(SRShutDown) then
        SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName);
      // need for the close
      SRCheckJaws := GetProcAddress(DLLHandle, TVA508CheckJawsFuncName);
      Try
        Result := SRCheckJaws;
      Except
        On e: Exception do
          raise e.Create(Format(DllCallError, ['SRCheckJaws', e.Message]));
      End;
    end;
  finally
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
  end;
  // end;
end;

function CheckRunning(Unload: boolean;
  HighVersion, LowVersion: integer): boolean;
begin
  // Calling IsRunning this way, instead of setting ok to it's result,
  // prevents ok from begin converted to a LongBool at compile time
  try
    if assigned(SRIsRunning) and SRIsRunning(HighVersion, LowVersion) then
      Result := TRUE
    else
      Result := FALSE;
    if Unload and (DLLHandle > HINSTANCE_ERROR) then
    begin
      FreeLibrary(DLLHandle);
      DLLHandle := 0;
    end;
  Except
    On e: Exception do
      raise e.Create(Format(DllCallError, ['SRShutDown', e.Message]));
  End;
end;

procedure FindScreenReaders;
var
  ok: boolean;

  procedure CheckProcs;
  begin
    if not assigned(SRInitialize) then
      SRInitialize := GetProcAddress(DLLHandle, TVA508InitializeProcName);
    if not assigned(SRInitializeEx) then
      SRInitializeEx := GetProcAddress(DLLHandle, TVA508InitializeExProcName);

    ok := assigned(SRInitialize) or assigned(SRInitializeEx);
    if ok then
    begin
      if not assigned(SRShutDown) then
        SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName);
      ok := assigned(SRShutDown);
      if ok then
      begin
        if not assigned(SRRegisterCustomBehavior) then
          SRRegisterCustomBehavior := GetProcAddress(DLLHandle,
            TVA508RegisterCustomBehaviorProcName);
        ok := assigned(SRRegisterCustomBehavior);
        if ok then
        begin
          if not assigned(SRSpeakText) then
            SRSpeakText := GetProcAddress(DLLHandle, TVA508SpeakTextProcName);
          ok := assigned(SRSpeakText);
          if ok then
          begin
            if not assigned(SRIsRunning) then
              SRIsRunning := GetProcAddress(DLLHandle, TVA508IsRunningFuncName);
            ok := assigned(SRIsRunning);
            if ok then
            begin
              if not assigned(SRComponentData) then
                SRComponentData := GetProcAddress(DLLHandle,
                  TVA508ComponentDataProcName);
              ok := assigned(SRComponentData);
              if ok then
              begin
                if not assigned(SRConfigChangePending) then
                  SRConfigChangePending := GetProcAddress(DLLHandle,
                    TVA508ConfigChangePendingName);
                ok := assigned(SRConfigChangePending);
              end;
            end;
          end;
        end;
      end;
    end;
    ClearProcPointers;
  end;

  procedure CheckFile(FileName: string);
  begin
    DLLHandle := 0;
    ok := FileExists(FileName);
    if ok then
    begin
      ok := FALSE;
      // idx := ValidSRFiles.IndexOf(FileName);
      // if idx < 0 then
      // begin
      DLLHandle := LoadLibrary(PChar(FileName));
      if DLLHandle > HINSTANCE_ERROR then
      begin
        try
          CheckProcs;
          if ok then
            // ValidSRFiles.Add(FileName)
            ValidSRFile := FileName;
        finally
          FreeLibrary(DLLHandle);
          DLLHandle := 0;
        end;
      end;
      // end;
    end
  end;

  procedure ScanScreenReaders(dir: string; addCommonFilesPath: boolean = TRUE);
  var
    SR: TSearchRec;
    Done: integer;
    RootDir: string;
  begin
    if dir = '' then
      exit;
    RootDir := AppendBackSlash(dir);
    if addCommonFilesPath then
      RootDir := RootDir + ScreenReaderCommonFilesDir;
    Done := FindFirst(RootDir + ScreenReaderSearchSpec, faAnyFile, SR);
    try
      while Done = 0 do
      begin
        if ((SR.Attr and BadFile) = 0) and
          (CompareText(ExtractFileExt(SR.Name), ScreenReaderFileExtension) = 0)
        then
        begin
          CheckFile(RootDir + SR.Name);
        end;
        Done := FindNext(SR);
      end;
    finally
      FindClose(SR);
    end;
  end;

begin
  if ExecuteFind then
  begin
    ok := FALSE;
    // if not assigned(ValidSRFiles) then
    // ValidSRFiles := TStringList.Create;
    ScanScreenReaders(ExtractFilePath(Application.ExeName), FALSE);

    if not ok then
      ScanScreenReaders(GetAlternateProgramFilesPath);
    if not ok then
      ScanScreenReaders(GetProgramFilesPath);
    ExecuteFind := FALSE;
  end;
end;

function ScreenReaderDLLsExist: boolean;
begin
  FindScreenReaders;
  Result := Trim(ValidSRFile) <> ''; // (ValidSRFiles.Count > 0);
end;

function IsScreenReaderSupported(Unload: boolean): boolean;
var
  HighVersion, LowVersion: integer;
begin
  try
    FindScreenReaders;
    VersionStringSplit(VA508AccessibilityManagerVersion, HighVersion, LowVersion);
    LoadScreenReader();
    Result := CheckRunning(Unload, HighVersion, LowVersion);
    if Result then
      exit;
    if not Unload then
    begin
      FreeLibrary(DLLHandle);
      DLLHandle := 0;
    end;
  Except
    On e: Exception do
      raise Exception.Create(e.Message);
  end;
end;

initialization

finalization

CloseScreenReaderLink;
// if assigned(ValidSRFiles) then
// FreeAndNil(ValidSRFiles);

end.

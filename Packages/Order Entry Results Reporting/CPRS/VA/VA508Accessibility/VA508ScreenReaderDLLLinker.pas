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
//    if it's different than the current machine's program files directory
// 3) The directory the application was run from.

function ScreenReaderDLLsExist: boolean;
function IsScreenReaderSupported(Unload: Boolean): boolean;
function InitializeScreenReaderLink: boolean;
procedure CloseScreenReaderLink;
function CheckForJaws(): Boolean;


type
  TVA508RegisterCustomBehaviorProc = procedure(BehaviorType: integer; Before, After: PChar); stdcall;
  TVA508SpeakTextProc = procedure(Text: PChar); stdcall;
  TVA508IsRunningFunc = function(HighVersion, LowVersion: Word): BOOL; stdcall;
  TVA508CheckJawsFunc =  function(): BOOL; stdcall;
  TVA508ConfigChangePending = function: boolean; stdcall;
  TVA508ComponentDataProc = procedure (WindowHandle: HWND;
                                   DataStatus:   LongInt = DATA_NONE;
                                   Caption:      PChar = nil;
                                   Value:        PChar = nil;
                                   Data:         PChar = nil;
                                   ControlType:  PChar = nil;
                                   State:        PChar = nil;
                                   Instructions: PChar = nil;
                                   ItemInstructions: PChar = nil); stdcall;
var
  SRSpeakText: TVA508SpeakTextProc = nil;
  SRIsRunning: TVA508IsRunningFunc = nil;
  SRCheckJaws: TVA508CheckJawsFunc = nil;
  SRRegisterCustomBehavior: TVA508RegisterCustomBehaviorProc = nil;
  SRComponentData: TVA508ComponentDataProc = nil;
  SRConfigChangePending: TVA508ConfigChangePending = nil;
  ValidSRFiles: TStringList = nil;
  ExecuteFind: boolean = TRUE;
  DoInitialize: boolean = TRUE;
  InitializeResult: boolean = FALSE;

implementation

uses VAUtils, VA508AccessibilityRouter, VA508AccessibilityManager;

const
{$Ifdef VER180}
  ScreenReaderFileExtension = '.SR';
{$Else}
  ScreenReaderFileExtension = '.SR3';
{$EndIf}
  ScreenReaderCommonFilesDir = 'VistA\Common Files\';
  ScreenReaderSearchSpec = '*' + ScreenReaderFileExtension;
{$WARNINGS OFF}   // Ignore platform specific code warning
  BadFile = faHidden or faSysFile or faDirectory or faSymLink;
{$WARNINGS ON}

{$REGION 'Initialize Proc Definition'}
type
  TVA508InitializeProc = function(CallBackProc: TComponentDataRequestProc): BOOL; stdcall;
const
  TVA508InitializeProcName = 'Initialize';
var
  SRInitialize: TVA508InitializeProc = nil;

function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL; stdcall;
{$HINTS OFF}   // Ignore unused variable hint
var
  CompileVerification: TVA508InitializeProc;
begin
  CompileVerification := Initialize;
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

procedure RegisterCustomBehavior(BehaviorType: integer; Before, After: PChar); stdcall;
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

procedure ComponentData(WindowHandle:     HWND;
                        DataStatus:       LongInt = DATA_NONE;
                        Caption:          PChar   = nil;
                        Value:            PChar   = nil;
                        Data:             PChar   = nil;
                        ControlType:      PChar   = nil;
                        State:            PChar   = nil;
                        Instructions:     PChar   = nil;
                        ItemInstructions: PChar   = nil); stdcall;

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
  SRShutDown := nil;
  SRRegisterCustomBehavior := nil;
  SRSpeakText := nil;
  SRIsRunning  := nil;
  SRComponentData := nil;
  SRConfigChangePending := nil;
  DoInitialize := FALSE;
  InitializeResult := FALSE;
end;

function InitializeScreenReaderLink: boolean;
begin
  if DoInitialize then
  begin
    InitializeResult := SRInitialize(ComponentDataRequested);
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
    SRShutDown;
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
    ClearProcPointers;
  end;
end;

procedure LoadScreenReader(index: integer);
var
  FileName: string;
begin
  FileName := ValidSRFiles[index];
  DLLHandle := LoadLibrary(PChar(FileName));
  if DLLHandle > HINSTANCE_ERROR then
  begin
    SRInitialize := GetProcAddress(DLLHandle, TVA508InitializeProcName);
    SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName);
    SRRegisterCustomBehavior := GetProcAddress(DLLHandle, TVA508RegisterCustomBehaviorProcName);
    SRSpeakText := GetProcAddress(DLLHandle, TVA508SpeakTextProcName);
    SRIsRunning := GetProcAddress(DLLHandle, TVA508IsRunningFuncName);
    SRComponentData := GetProcAddress(DLLHandle, TVA508ComponentDataProcName);
    SRConfigChangePending := GetProcAddress(DLLHandle, TVA508ConfigChangePendingName);    
    DoInitialize := TRUE;
  end;
end;

function CheckForJaws(): Boolean;
var
  FileName: string;
  I: integer;
begin
  result := false;
  for I := 0 to ValidSRFiles.Count - 1 do
  begin
   FileName := ValidSRFiles[I];
   DLLHandle := LoadLibrary(PChar(FileName));
   if DLLHandle > HINSTANCE_ERROR then
   begin
    SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName); //need for the close
    SRCheckJaws := GetProcAddress(DLLHandle, TVA508CheckJawsFuncName);
    result := SRCheckJaws;
   end;
  end;
end;

function CheckRunning(Unload: boolean; HighVersion, LowVersion: integer): boolean;
begin
// Calling IsRunning this way, instead of setting ok to it's result,
// prevents ok from begin converted to a LongBool at compile time
  if assigned(SRIsRunning) and SRIsRunning(HighVersion, LowVersion) then
    Result := TRUE
  else
    Result := FALSE;
  if Unload and (DLLHandle > HINSTANCE_ERROR)then
  begin
    FreeLibrary(DLLHandle);
    DLLHandle := 0;
  end;
end;


procedure FindScreenReaders;
var
  ok: boolean;

  procedure CheckProcs;
  begin
    SRInitialize := GetProcAddress(DLLHandle, TVA508InitializeProcName);
    ok := assigned(SRInitialize);
    if ok then
    begin
      SRShutDown := GetProcAddress(DLLHandle, TVA508ShutDownProcName);
      ok := assigned(SRShutDown);
      if ok then
      begin
        SRRegisterCustomBehavior := GetProcAddress(DLLHandle, TVA508RegisterCustomBehaviorProcName);
        ok := assigned(SRRegisterCustomBehavior);
        if ok then
        begin
          SRSpeakText := GetProcAddress(DLLHandle, TVA508SpeakTextProcName);
          ok := assigned(SRSpeakText);
          if ok then
          begin
            SRIsRunning := GetProcAddress(DLLHandle, TVA508IsRunningFuncName);
            ok := assigned(SRIsRunning);
            if ok then
            begin
              SRComponentData := GetProcAddress(DLLHandle, TVA508ComponentDataProcName);
              ok := assigned(SRComponentData);
              if ok then
              begin
                SRConfigChangePending := GetProcAddress(DLLHandle, TVA508ConfigChangePendingName);
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
  var
    idx: integer;
  begin
    DLLHandle := 0;
    ok := FileExists(FileName);
    if ok then
    begin
      ok := FALSE;
      idx := ValidSRFiles.IndexOf(FileName);
      if idx < 0 then
      begin
        DLLHandle := LoadLibrary(PChar(FileName));
        if DLLHandle > HINSTANCE_ERROR then
        begin
          try
            CheckProcs;
            if ok then
              ValidSRFiles.Add(FileName)
          finally
            FreeLibrary(DLLHandle);
            DLLHandle := 0;
          end;
        end;
      end;
    end
  end;

  procedure ScanScreenReaders(dir: string; addCommonFilesPath: boolean = true);
  var
    SR: TSearchRec;
    Done: integer;
    RootDir: string;
  begin
    if dir = '' then exit;
    RootDir := AppendBackSlash(dir);
    if addCommonFilesPath then
      RootDir := RootDir + ScreenReaderCommonFilesDir;
    Done := FindFirst(RootDir + ScreenReaderSearchSpec, faAnyFile, SR);
    try
      while Done = 0 do
      begin
        if((SR.Attr and BadFile) = 0) and (CompareText(ExtractFileExt(SR.Name), ScreenReaderFileExtension) = 0) then
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
    if not assigned(ValidSRFiles) then
      ValidSRFiles := TStringList.Create;
    ScanScreenReaders(GetProgramFilesPath);
    if not ok then
      ScanScreenReaders(GetAlternateProgramFilesPath);
    if not ok then
      ScanScreenReaders(ExtractFilePath(Application.ExeName), FALSE);
    ExecuteFind := FALSE;
  end;
end;

function ScreenReaderDLLsExist: boolean;
begin
  FindScreenReaders;
  Result := (ValidSRFiles.Count > 0);
end;

function IsScreenReaderSupported(Unload: Boolean): boolean;
var
  i: integer;
  HighVersion, LowVersion: integer;
begin
  Result := FALSE;
  FindScreenReaders;
  VersionStringSplit(VA508AccessibilityManagerVersion, HighVersion, LowVersion);
  for I := 0 to ValidSRFiles.Count - 1 do
  begin
    LoadScreenReader(i);
    Result := CheckRunning(Unload, HighVersion, LowVersion);
    if Result then exit;
    if not Unload then
    begin
      FreeLibrary(DLLHandle);
      DLLHandle := 0;
    end;
  end;
end;

initialization

finalization
  CloseScreenReaderLink;
  if assigned(ValidSRFiles) then
    FreeAndNil(ValidSRFiles);

end.

{ ******************************************************************************
  {
  {                                 JAWS FrameWork
  {
  { The framework keeps the jaws scripts updated and acts as a middle man to the
  { Jaws application.
  {
  {
  {
  { Last modified by: Chris Bell
  { Last modified: 5/25/16
  { Last Modified Description:
  {   Added splash screen with version information as well as an update to the new log control
  {
  {
  { DONE -oJeremy Merrill -c508 :
  Add something that prevents overwriting of the script files if another
  app is running that's using the JAWS DLL }
{ DONE -oJeremy Merrill -c508 : Add check in here to look at script version in JSS file -
  ZZZZZZBELLC: This appears to already be added. Marking as done }
{ DONE -oJeremy Merrill -c508 :
  Replace registry communication with multiple windows - save strings in the window titles
  Use EnumerateChildWindows jaws script function in place of the FindWindow function
  that's being used right now.- EnumerateChildWindows with a window handle of 0
  enumerates all windows on the desktop.  Will have to use the first part of the window
  title as an ID, and the last part as the string values.  Will need to check for a maximum
  string lenght, probably have to use multiple windows for long text.
  Will also beed to have a global window shared by muiltiple instances of the JAWS.SR DLL. }
{ DONE -oJeremy Merrill -c508 :
  Need to add version checking to TVA508AccessibilityManager component
  and JAWS.DLL.  Warning needs to display just like JAWS.DLL and JAWS. }
{ DONE -oJeremy Merrill -c508 :Figure out why Delphi IDE is loading the DLL when JAWS is running  -
  probably has something to do with the VA508 package being installed -
  need to test for csDesigning some place that we're not testing for (maybe?) }
{ DONE -oJeremy Merrill -c508 :
  Change APP_DATA so that "application data" isn't used - Windows Vista
  doesn't use this value - get data from Windows API call - ZZZZZZBELLC:
  This is no longer an issue since we do not call this function. }

{ DONE -oBrian Juergensmeyer -c508 : Removed call to check to see if JAWS was running.  It won't work under Win10. }
{ DONE -oChris Bell -c508 : Add log ability }
{ DONE -oChris Bell -c508 : Merge dispatcher into DLL to circumvent the UAC warning with windows 7 }
{ DONE -oChris Bell -c508 : Correct issue with UIPI since Jaws runs at a higher priority as CPRS. This limits API calls. }
{ DONE -oChris Bell -c508 : Modify code to accommodate for users lack of Admin rights. }
{ TODO -oChris Bell -c508 : Mass code cleanup. }
{ TODO -oChris Bell -c508 : Update jcScriptMerge code }
{ ****************************************************************************** }

unit JAWSImplementation;

interface

uses
{$IFDEF VER180}
  Messages,
{$ELSE}
  Winapi.Messages,
{$ENDIF}
  SysUtils, Windows, Classes, Registry, StrUtils, Forms, Dialogs,
  ExtCtrls, VAUtils, DateUtils, PSApi, IniFiles, ActiveX, SHFolder,
  ShellAPI, VA508AccessibilityConst, fVA508DispatcherHiddenWindow, U_LogObject;

{$I 'VA508ScreenReaderDLLStandard.inc'}
Function FindCommandSwitch(SwitchName: string; var ReturnValue: string)
  : Boolean; overload;
Function FindCommandSwitch(SwitchName: string): Boolean; overload;

exports Initialize, ShutDown, RegisterCustomBehavior, ComponentData, SpeakText,
  IsRunning, ConfigChangePending
{$IFDEF VER180}
  ;
{$ELSE}
  , FindJaws;
{$ENDIF}

implementation

uses fVA508HiddenJawsMainWindow, FSAPILib_TLB, ComObj, tlhelp32, U_SplashScreen,
  Vcl.Controls;

const

  JAWS_COM_OBJECT_VERSION = '8.0.2173';
  VA508_REG_COMPONENT_CAPTION = 'Caption';
  VA508_REG_COMPONENT_VALUE = 'Value';
  VA508_REG_COMPONENT_CONTROL_TYPE = 'ControlType';
  VA508_REG_COMPONENT_STATE = 'State';
  VA508_REG_COMPONENT_INSTRUCTIONS = 'Instructions';
  VA508_REG_COMPONENT_ITEM_INSTRUCTIONS = 'ItemInstructions';
  VA508_REG_COMPONENT_DATA_STATUS = 'DataStatus';
  SLASH = '\';
  JAWS_COMMON_SCRIPT_PATH_TEXT = 'freedom scientific\jaws\';
  JAWS_REGROOT = 'SOFTWARE\Freedom Scientific\JAWS';
  JAWS_SCRIPTDIR = 'SETTINGS\enu';
  JAWS_INSTALL_DIRECTORY_VAR = 'Target';
  JAWS_SHARED_DIR = 'Shared\';
  KEY_WOW64_64KEY = $0100;

type
  TCompareType = (jcPrior, jcINI, jcLineItems, jcVersion, jcScriptMerge,
    jcINIMRG, jcLineItemsMRG);

  TAddFiles = record
    FileName: string;
  end;

  TFileInfo = record
    FileName: string;
    CompareType: TCompareType;
    Required: Boolean;
    Compile: Boolean;
    Exist: Boolean;
    Add_To_Uses: array of TAddFiles;
    Dependencies: array of TAddFiles;
  end;

  TFileInfoArray = Array of TFileInfo;

const
  JAWS_SCRIPT_NAME = 'VA508JAWS';
  JAWS_APP_NAME = 'VA508APP';
  JAWS_SCRIPT_VERSION = 'VA508_Script_Version';
  JAWS_FRAMEWORK_USES = ';VA508_FRAMEWORK_USES';
  JAWS_SCRIPT_LIST = 'VA508ScriptList.INI';
  CompiledScriptFileExtension = '.JSB';
  ScriptFileExtension = '.JSS';
  ScriptDocExtension = '.JSD';
  ConfigFileExtension = '.JCF';
  KeyMapExtension = '.JKM';
  DictionaryFileExtension = '.JDF';
  Jaws_Script_Folder = 'Jaws Scripts';

  JAWS_VERSION_ERROR = ERROR_INTRO +
    'The Accessibility Framework can only communicate with JAWS ' +
    JAWS_REQUIRED_VERSION + CRLF +
    'or later versions.  Please update your version of JAWS to a minimum of' +
    CRLF + JAWS_REQUIRED_VERSION +
    ', or preferably the most recent release, to allow the Accessibility' + CRLF
    + 'Framework to communicate with JAWS.  If you are getting this message' +
    CRLF + 'and you already have a compatible version of JAWS, please contact your'
    + CRLF + 'system administrator, and request that they run, with administrator rights,'
    + CRLF + 'the JAWSUpdate application located in the \Program Files\VistA\' +
    CRLF + 'Common Files directory. JAWSUpdate is not required for JAWS' + CRLF
    + 'versions ' + JAWS_COM_OBJECT_VERSION + ' and above.' + CRLF;

  JAWS_FILE_ERROR = ERROR_INTRO +
    'The JAWS interface with the Accessibility Framework requires the ability' +
    CRLF + 'to write files to the hard disk, but the following error is occurring trying to'
    + CRLF + 'write to the disk:' + CRLF + '%s' + CRLF +
    'Please contact your system administrator in order to ensure that your ' +
    CRLF + 'security privileges allow you to write files to the hard disk.' +
    CRLF + 'If you are sure you have these privileges, your hard disk may be full.  Until'
    + CRLF + 'this problem is resolved, the Accessibility Framework will not be able to'
    + CRLF + 'communicate with JAWS.';

  JAWS_USER_MISSMATCH_ERROR = ERROR_INTRO +
    'An error has been detected in the state of JAWS that will not allow the' +
    CRLF + 'Accessibility Framework to communicate with JAWS until JAWS is shut'
    + CRLF + 'down and restarted.  Please restart JAWS at this time.';

  DLL_VERSION_ERROR = ERROR_INTRO +
    'The Accessibility Framework is at version %s, but the required JAWS' + CRLF
    + 'support files are only at version %s.  The new support files should have'
    + CRLF + 'been released with the latest version of the software you are currently'
    + CRLF + 'running.  The Accessibility Framework will not be able to communicate'
    + CRLF + 'with JAWS until these support files are installed.  Please contact your'
    + CRLF + 'system administrator for assistance.';

  JAWS_AUTO_NOT_RUNNING = ERROR_INTRO +
    'The Accessibility Framework was unable to identify a running instance of JAWS.'
    + ' If you are running JAWS ' + JAWS_REQUIRED_VERSION + ' or later please '
    + 'verify your shortcut contains the JAWS executable name' + CRLF + CRLF +
    'Example: /SCREADER:JAWS Application Name.exe.' + CRLF +
    'If you do not have access to update the %s shortcut, please contact your local '
    + ' support/help personnel.' + CRLF +
    'This message box will automatically close after 30 seconds';

  JAWS_NOT_RUNNING = ERROR_INTRO +
    'The Accessibility Framework was unable to identify a running instance of JAWS.'
    + ' The Accessibility Framework will not be able to communicate' +
    'with JAWS until the correct JAWS application name is passed into the shortcut for %s .'
    + CRLF + CRLF + '/SCREADER=:%s is not running ' + CRLF +
    'If you do not have access to update the %s shortcut, please contact your local '
    + ' support/help personnel.' + CRLF +
    'This message box will automatically close after 30 seconds';

  JAWS_ERROR_VERSION = 1;
  JAWS_ERROR_FILE_IO = 2;
  JAWS_ERROR_USER_PROBLEM = 3;
  DLL_ERROR_VERSION = 4;
  JAWS_ERROR_COUNT = 4;
  JAWS_RELOAD_DELAY = 500;
  MB_TIMEDOUT = 32000;

var
  JAWSErrorMessage: array [1 .. JAWS_ERROR_COUNT] of string = (
    JAWS_VERSION_ERROR,
    JAWS_FILE_ERROR,
    JAWS_USER_MISSMATCH_ERROR,
    DLL_VERSION_ERROR
  );

  JAWSErrorsShown: array [1 .. JAWS_ERROR_COUNT] of Boolean = (
    FALSE,
    FALSE,
    FALSE,
    FALSE
  );

type
  TJAWSSayString = function(StringToSpeak: PChar; Interrupt: BOOL)
    : BOOL; stdcall;
  TJAWSRunScript = function(ScriptName: PChar): BOOL; stdcall;

  TStartupID = record
    Handle: HWND;
    InstanceID: Integer;
    MsgID: Integer;
  end;

  tCompileFile = record
    FileName: String;
    Compiled: Boolean;
    Compiler: String;
    DependentFile: Array of tCompileFile;
    function CompileFile(var RtnMsg: String): Boolean;
  end;

  TJawsRecord = record
    Version: Double;
    Compiler: string;
    DefaultScriptDir: String;
    UserScriptDir: String;
    FDictionaryFileName: string;
    FConfigFile: string;
    FKeyMapFile: string;
    FKeyMapINIFile: TINIFile;
    FKeyMapINIFileModified: Boolean;
    FAssignedKeys: TStringList;
    FConfigINIFile: TINIFile;
    FConfigINIFileModified: Boolean;
    FDictionaryFile: TStringList;
    FDictionaryFileModified: Boolean;
  end;

  TJAWSManager = class
  strict private
    FRequiredFilesFound: Boolean;
    FMainForm: TfrmVA508HiddenJawsMainWindow;
    FWasShutdown: Boolean;
    FJAWSFileError: string;
    FHiddenJaws: TForm;
    // FRootScriptFileName: string;
    // FRootScriptAppFileName: string;
    JAWSAPI: IJawsApi;
  private
    fComponentCallBackProc: TComponentDataRequestProc;
    fScriptFilesChanged: Boolean;
    procedure ShutDown;
    procedure MakeFileWritable(FileName: string);
    procedure LaunchMasterApplication;
    procedure KillINIFiles(Sender: TObject);
    procedure ReloadConfiguration;
    procedure EnsureWindow;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure ShowError(ErrorNumber: Integer); overload;
    class procedure ShowError(ErrorNumber: Integer;
      data: array of const); overload;
    // class function GetPathFromJAWS(PathID: Integer;
    // DoLowerCase: boolean = TRUE): string;
    class function GetJAWSWindow: HWND;
    class function IsRunning(HighVersion, LowVersion: Word): BOOL;
    class function FindJaws(): HWND;
    function Initialize(ComponentCallBackProc: TComponentDataRequestProc): BOOL;
    procedure SendComponentData(WindowHandle: HWND; DataStatus: LongInt;
      Caption, Value, data, ControlType, State, Instructions,
      ItemInstructions: PChar);
    procedure SpeakText(Text: PChar);
    procedure RegisterCustomBehavior(Before, After: string; Action: Integer);
    class function JAWSVersionOK: Boolean;
    class function JAWSTalking2CurrentUser: Boolean;
    function FileErrorExists: Boolean;
    procedure GetScriptFiles(var info: TFileInfoArray);
    property RequiredFilesFound: Boolean read FRequiredFilesFound;
    property MainForm: TfrmVA508HiddenJawsMainWindow read FMainForm;
    property ScriptFilesChanged: Boolean read fScriptFilesChanged;
  end;

{$IFDEF UNICODE}
function MessageBoxTimeOut(HWND: HWND; lpText: PWideChar; lpCaption: PWideChar;
  uType: UINT; wLanguageId: Word; dwMilliseconds: DWORD): Integer; stdcall;
  external user32 name 'MessageBoxTimeoutW';
{$ELSE}
function MessageBoxTimeOut(HWND: HWND; lpText: PChar; lpCaption: PChar;
  uType: UINT; wLanguageId: Word; dwMilliseconds: DWORD): Integer; stdcall;
  external user32 name 'MessageBoxTimeoutA';
{$ENDIF}

var
  // ******************************************************************
  // Archived Variable
  // ******************************************************************
  // DLLMessageID: UINT = 0;

  JAWSManager: TJAWSManager = nil;
  JawsRecord: array of TJawsRecord;
  ScriptFiles: TFileInfoArray;
  JAWSHandle: HWND = 0;
  UserSplash: tSplashTaskDialog;

const
  FJAWSHandleSearchPerformed: Boolean = false; // blj 17 Dec 2018
                                         // Many of the APIs used to interact with
                                         // 64 bit executables (like JAWS) are not working
                                         // (by design) with 32 bit executables like CPRS.
                                         // Because of this, we're doing multiple searches and
                                         // harassing the user with multiple error
                                         // dialogs.

  //

{$REGION 'Add export methods to this region'}

  // ******************************************************************
  // Ensure the JAWSmanager object exist
  // ******************************************************************
procedure EnsureManager;
begin
  if not assigned(JAWSManager) then
  begin
    // This should only happen ONCE.  If it happens more than once, then we have an
    // issue.
    LogInterface.LogText('INITIALIZATION', 'In Ensure Manager.  JAWSManager is nil');
    JAWSManager := TJAWSManager.Create;
  end;
end;

// ******************************************************************
// Checks to see if the screen reader is currently running
// ******************************************************************
function IsRunning(HighVersion, LowVersion: Word): BOOL; stdcall;
begin
  EnsureManager; // need to preload the directories
  Result := TJAWSManager.IsRunning(HighVersion, LowVersion);
end;

function FindJaws(): BOOL; stdcall;
begin
  EnsureManager; // need to preload the directories
  if FJAWSHandleSearchPerformed then
    exit;
  FJAWSHandleSearchPerformed := true;
  LogInterface.LogText('INITIALIZATION','In Exported FindJAWS method');
  JAWSHandle := TJAWSManager.FindJaws;
  Result := (JAWSHandle <> 0);
end;

// ******************************************************************
// Executed after IsRunning returns TRUE, when the DLL is accepted
// as the screen reader of choice
// ******************************************************************
function InitializeSub(ComponentCallBackProc: TComponentDataRequestProc): BOOL;
begin
  EnsureManager;
  UserSplash.TaskMaxProg := (3 + Length(ScriptFiles)) * Length(JawsRecord) + 1;
  Result := JAWSManager.Initialize(ComponentCallBackProc);
end;

function Initialize(ComponentCallBackProc: TComponentDataRequestProc)
  : BOOL; stdcall;
var
  VersionNum: string;
  i, ForceNum: Integer;
begin
  // Need to make threaded
  UserSplash := nil;

  // If not show task dialog
  ForceNum := -1;
  if FindCommandSwitch('FORCEUPD') then
    ForceNum := 0
  else
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
    begin
      VersionNum := FloatToStr(JawsRecord[i].Version);
      if Pos('.', VersionNum) > 0 then
        VersionNum := Copy(VersionNum, 1, Pos('.', VersionNum) - 1);
      if FindCommandSwitch('FORCEUPD' + VersionNum) then
      begin
        ForceNum := StrToIntDef(VersionNum, 0);
        break;
      end;
    end;
  end;

  UserSplash := tSplashTaskDialog.Create(InitializeSub, ComponentCallBackProc,
    LogInterface.Active, ForceNum);
  try
    if LogInterface.Active then
      UserSplash.LogPath := LogInterface.LogFile;
    UserSplash.Show;
    Result := UserSplash.ReturnValue;
    if Result then
    begin
      JAWSManager.EnsureWindow;
      JAWSManager.LaunchMasterApplication;
      if JAWSManager.ScriptFilesChanged then
      begin
        JAWSManager.MainForm.ConfigReloadNeeded;
      end;
    end;

  finally
    FreeAndNil(UserSplash);
  end;

end;

// ******************************************************************
// Executed when the DLL is unloaded or screen reader is no longer
// needed
// ******************************************************************
procedure ShutDown; stdcall;
begin
  if assigned(JAWSManager) then
  begin
    JAWSManager.ShutDown;
    FreeAndNil(JAWSManager);
  end;
end;

// ******************************************************************
// Determines if configuration changes are pending
// ******************************************************************
function ConfigChangePending: Boolean; stdcall;
begin
  Result := FALSE;
  if assigned(JAWSManager) and assigned(JAWSManager.MainForm) and
    (JAWSManager.MainForm.ConfigChangePending) then
    Result := TRUE;
end;

// ******************************************************************
// Returns Component Data as requested by the screen reader
// ******************************************************************
procedure ComponentData(WindowHandle: HWND; DataStatus: LongInt = DATA_NONE;
  Caption: PChar = nil; Value: PChar = nil; data: PChar = nil;
  ControlType: PChar = nil; State: PChar = nil; Instructions: PChar = nil;
  ItemInstructions: PChar = nil); stdcall;
begin
  EnsureManager;
  JAWSManager.SendComponentData(WindowHandle, DataStatus, Caption, Value, data,
    ControlType, State, Instructions, ItemInstructions);
end;

// ******************************************************************
// Instructs the Screen Reader to say the specified text
// ******************************************************************
procedure SpeakText(Text: PChar); stdcall;
begin
  EnsureManager;
  JAWSManager.SpeakText(Text);
end;

// ******************************************************************
// Registers any custom behavior
// ******************************************************************
procedure RegisterCustomBehavior(BehaviorType: Integer; Before, After: PChar);
begin
  EnsureManager;
  JAWSManager.RegisterCustomBehavior(Before, After, BehaviorType);
end;

{$ENDREGION}
{$REGION 'Add TJAWSManager methods to this region'}

// ******************************************************************
// Makes a file writable
// ******************************************************************
procedure TJAWSManager.MakeFileWritable(FileName: string);
const
{$WARNINGS OFF} // Don't care about platform specific warning
  NON_WRITABLE_FILE_ATTRIB = faReadOnly or faHidden;
{$WARNINGS ON}
  WRITABLE_FILE_ATTRIB = faAnyFile and (not NON_WRITABLE_FILE_ATTRIB);

var
  Attrib: Integer;
begin
{$WARNINGS OFF} // Don't care about platform specific warning
  Attrib := FileGetAttr(FileName);
{$WARNINGS ON}
  if (Attrib and NON_WRITABLE_FILE_ATTRIB) <> 0 then
  begin
    Attrib := Attrib and WRITABLE_FILE_ATTRIB;
{$WARNINGS OFF} // Don't care about platform specific warning
    if FileSetAttr(FileName, Attrib) <> 0 then
{$WARNINGS ON}
      FJAWSFileError := 'Could not change read-only attribute of file "' +
        FileName + '"';

  end;
end;

// ******************************************************************
// Create method for the JawsManager
// ******************************************************************
constructor TJAWSManager.Create;
const
  COMPILER_FILENAME = 'scompile.exe';
  // JAWS_APP_NAME = 'VA508APP';

  function ContinueToLoad(TempSubDir: string): Boolean;
  Var
    TempUSDir, TempDSDir, PathToCheck: String;
    idx1, idx2: Integer;
  begin
    // Default Script
    TempDSDir := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) +
      JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(TempSubDir);

    // User Script
    TempUSDir := GetSpecialFolderPath(CSIDL_APPDATA) +
      JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(TempSubDir);

    // Script Folder
    PathToCheck := '';
    idx1 := Pos(JAWS_COMMON_SCRIPT_PATH_TEXT, TempUSDir);
    idx2 := Pos(JAWS_COMMON_SCRIPT_PATH_TEXT, TempDSDir);

    PathToCheck := Copy(TempUSDir, 1, idx1 - 1) + Copy(TempDSDir, idx2, MaxInt);

    Result := DirectoryExists(PathToCheck);
    // Check to see if directory exist (they have ran jaws)

  end;

// ******************************************************************
// Load the jaws directories via regestries
// ******************************************************************
  procedure LoadJawsDirectories;
  var
    reg: TRegistry;
    keys: TStringList;
    i: Integer;
    key, Dir, SubDir, Version: string;
  begin
    keys := TStringList.Create;
    try
      reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey(JAWS_REGROOT, FALSE);
        reg.GetKeyNames(keys);
        for i := 0 to keys.Count - 1 do
        begin
          Version := keys[i];
          key := JAWS_REGROOT + '\' + keys[i] + '\';
          reg.CloseKey;
          SubDir := Version + '\' + JAWS_SCRIPTDIR;
          if reg.OpenKey(key, FALSE) then
          begin
            Dir := LowerCase(reg.ReadString(JAWS_INSTALL_DIRECTORY_VAR));
            LogInterface.LogText('Jaws Found', 'Version: ' + Version + #13#10 +
              'Directory: ' + Dir);

            Dir := AppendBackSlash(Dir) + COMPILER_FILENAME;
            if FileExists(Dir) and ContinueToLoad(SubDir) then
            begin
              SetLength(JawsRecord, Length(JawsRecord) + 1);
              JawsRecord[high(JawsRecord)].Version :=
                StrTofloatDef(Version, -1);
              JawsRecord[high(JawsRecord)].Compiler := Dir;
              Dir := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) +
                JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(SubDir);
              JawsRecord[high(JawsRecord)].DefaultScriptDir := Dir;
              Dir := GetSpecialFolderPath(CSIDL_APPDATA) +
                JAWS_COMMON_SCRIPT_PATH_TEXT + AppendBackSlash(SubDir);
              JawsRecord[high(JawsRecord)].UserScriptDir := Dir;
            end;
          end;

        end;
      finally
        reg.free;
      end;
    finally
      keys.free;
    end;
  end;

// ******************************************************************
// Ensure all the required files are present in the vista folder
// ******************************************************************
  procedure FindJAWSRequiredFiles;
  var
    path: string;
    i: Integer;
    LogTxt: string;
  begin
    SetLength(path, MAX_PATH);
    SetLength(path, GetModuleFileName(HInstance, PChar(path), Length(path)));
    path := ExtractFilePath(path);
    path := AppendBackSlash(path);
    // look for the script files in the same directory as this DLL

    FRequiredFilesFound := TRUE;

    // Look up the files
    if Length(ScriptFiles) = 0 then
      GetScriptFiles(ScriptFiles);

    if Length(ScriptFiles) > 0 then
    begin
      LogInterface.LogText(' Scripts  ',
        'Folder:' + ExtractFilePath(ScriptFiles[0].FileName))
    end
    else
      LogInterface.LogText(' Scripts  ',
        '!! No files to lookup !! Please check the VA508ScriptList.INI');

    // now ensure that the required files are there
    for i := low(ScriptFiles) to high(ScriptFiles) do
    begin
      LogTxt := 'File Name:' + ExtractFileName(ScriptFiles[i].FileName);
      if ScriptFiles[i].Required then
      begin
        LogTxt := LogTxt + #13#10 + 'Required: YES';
        if not ScriptFiles[i].Exist then
        begin
          FRequiredFilesFound := FALSE;
          LogTxt := LogTxt + #13#10 + 'File Found: NO';
          // break;
        end
        else
          LogTxt := LogTxt + #13#10 + 'File Found: YES';
      end
      else
      begin
        LogTxt := LogTxt + #13#10 + 'Required: NO';
        if not ScriptFiles[i].Exist then
          LogTxt := LogTxt + #13#10 + 'File Found: NO'
        else
          LogTxt := LogTxt + #13#10 + 'File Found: YES';

      end;

      LogInterface.LogText(IntToStr(i + 1) + '/' + IntToStr(Length(ScriptFiles)
        - 1), LogTxt);
    end;
  end;

begin
  SetLength(JawsRecord, 0);
  LoadJawsDirectories;
  if Length(JawsRecord) > 0 then
// RTC Defect 609561
// Original code ----------------------------------------------------- begin
{
    FindJAWSRequiredFiles;
  if not FRequiredFilesFound then
    ShowError(JAWS_ERROR_FILE_IO, ['Required files missing']);
}
// Original code ------------------------------------------------------- end
// Modified code ----------------------------------------------------- begin
    begin  //: Looking for JAWSRequired Files only if the registry entries were found
      FindJAWSRequiredFiles;
      if not FRequiredFilesFound then
        ShowError(JAWS_ERROR_FILE_IO, ['Required files missing']);
    end;
// Modified code ------------------------------------------------------- end
end;

// ******************************************************************
// Destroy method for the JawsManager
// ******************************************************************
destructor TJAWSManager.Destroy;
begin
  SetLength(JawsRecord, 0);
  ShutDown;
  inherited;
end;

// ******************************************************************
// Returns if an error has been captured
// ******************************************************************
function TJAWSManager.FileErrorExists: Boolean;
begin
  Result := (FJAWSFileError <> '');
end;

// ******************************************************************
// Fills out the file array with sciprts to be moved over
// ******************************************************************
procedure TJAWSManager.GetScriptFiles(var info: TFileInfoArray);
var
  ScriptsFile: TINIFile;
  path, ScriptsFileName, TmpStr: string;
  Scripts: TStringList;
  i, X, Y: Integer;

  function FindScriptFileLocation(aBasePath, aFileName: string): String;
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

  function LoadInfoRec(aPatchDir, aFileName, Value: String): TFileInfo;
  var
    TmpCompare: string;
    FoundPath: String;
    TmpStrLst: TStringList;
    i: Integer;
  begin
    SetLength(Result.Add_To_Uses, 0);
    FoundPath := FindScriptFileLocation(aPatchDir, aFileName);
    if FoundPath <> '' then
    begin
      Result.FileName := AppendBackSlash(FoundPath) + aFileName;
      Result.Exist := FileExists(Result.FileName);
    end
    else
    begin
      Result.FileName := aFileName;
      Result.Exist := FALSE;
    end;

    TmpCompare := Piece(Value, '|', 1);
    if UpperCase(TmpCompare) = 'JCPRIOR' then
      Result.CompareType := jcPrior
    else if UpperCase(TmpCompare) = 'JCINI' then
      Result.CompareType := jcINI
    else if UpperCase(TmpCompare) = 'JCLINEITEMS' then
      Result.CompareType := jcLineItems
    else if UpperCase(TmpCompare) = 'JCVERSION' then
      Result.CompareType := jcVersion
    else if UpperCase(TmpCompare) = 'JCSCRIPTMERGE' then
      Result.CompareType := jcScriptMerge
    else if UpperCase(TmpCompare) = 'JCINIMRG' then
      Result.CompareType := jcINIMRG
    else if UpperCase(TmpCompare) = 'JCLINEITEMSMRG' then
      Result.CompareType := jcLineItemsMRG;

    TmpCompare := Piece(Value, '|', 2);
    if UpperCase(TmpCompare) = 'TRUE' then
      Result.Required := TRUE
    else if UpperCase(TmpCompare) = 'FALSE' then
      Result.Required := FALSE;

    TmpCompare := Piece(Value, '|', 3);
    if UpperCase(TmpCompare) = 'TRUE' then
      Result.Compile := TRUE
    else if UpperCase(TmpCompare) = 'FALSE' then
      Result.Compile := FALSE;

    TmpCompare := Piece(Value, '|', 4);
    if Trim(TmpCompare) <> '' then
    begin
      TmpCompare := Piece(TmpCompare, '[', 2);
      TmpCompare := Piece(TmpCompare, ']', 1);
      TmpStrLst := TStringList.Create;
      try
        TmpStrLst.Text := TmpCompare;
        for i := 0 to TmpStrLst.Count - 1 do
        begin
          SetLength(Result.Add_To_Uses, Length(Result.Add_To_Uses) + 1);
          Result.Add_To_Uses[High(Result.Add_To_Uses)].FileName :=
            TmpStrLst.Strings[i];
        end;
      finally
        TmpStrLst.free;
      end;
    end;

  end;

  function LoadOverWrites(SectionName: String): Boolean;
  var
    i, X: Integer;
    FileName, extName: String;
  begin
    if ScriptsFile.SectionExists(SectionName) then
    begin
      Result := TRUE;
      ScriptsFile.ReadSectionValues(SectionName, Scripts);
      for i := 0 to Scripts.Count - 1 do
      begin
        // if script is named after the app then replace
        FileName := Piece(ExtractFileName(Scripts.Names[i]), '.', 1);
        extName := Piece(ExtractFileName(Scripts.Names[i]), '.', 2);
        // Section name should be the applications name
        if UpperCase(FileName) = UpperCase(SectionName) then
        begin
          if Pos('MRG', UpperCase(Piece(Scripts.Values[Scripts.Names[i]], '|',
            1))) = 0 then
          begin
            for X := Low(info) to High(info) do
            begin
              if (UpperCase(Piece(ExtractFileName(info[X].FileName), '.', 1))
                = UpperCase(JAWS_APP_NAME)) and
                (UpperCase(Piece(ExtractFileName(info[X].FileName), '.', 2))
                = UpperCase(extName)) then
              begin
                // overwrite its corrisponding va508app file
                info[X] := LoadInfoRec(path, Scripts.Names[i],
                  Scripts.Values[Scripts.Names[i]]);
                break;
              end;
            end;
          end
          else
          begin
            SetLength(info, Length(info) + 1);
            info[High(info)] := LoadInfoRec(path, Scripts.Names[i],
              Scripts.Values[Scripts.Names[i]]);
          end;
        end
        else
        begin
          SetLength(info, Length(info) + 1);
          info[High(info)] := LoadInfoRec(path, Scripts.Names[i],
            Scripts.Values[Scripts.Names[i]]);
        end;
      end;
    end
    else
      Result := FALSE;
  end;

begin
  SetLength(path, MAX_PATH);
  SetLength(path, GetModuleFileName(HInstance, PChar(path), Length(path)));
  path := ExtractFilePath(path);
  path := AppendBackSlash(path);
  ScriptsFileName := FindScriptFileLocation(path, JAWS_SCRIPT_LIST);
  if ScriptsFileName <> '' then
  begin
    ScriptsFileName := AppendBackSlash(ScriptsFileName) + JAWS_SCRIPT_LIST;
    if FileExists(ScriptsFileName) then
    begin
      ScriptsFile := TINIFile.Create(ScriptsFileName);
      Scripts := TStringList.Create;
      try
        SetLength(info, 0);
        ScriptsFile.ReadSectionValues('SCRIPTS', Scripts);
        for i := 0 to Scripts.Count - 1 do
        begin
          SetLength(info, Length(info) + 1);
          info[High(info)] := LoadInfoRec(path, Scripts.Names[i],
            Scripts.Values[Scripts.Names[i]]);
        end;

        // Now check for custom overwrites
        // first look for general App
        TmpStr := Piece(ExtractFileName(ParamStr(0)), '.', 1);
        LoadOverWrites(TmpStr);

        // second look for a specific version
        TmpStr := TmpStr + '|' + FileVersionValue(ParamStr(0),
          FILE_VER_FILEVERSION);
        LoadOverWrites(TmpStr);

      finally
        ScriptsFile.free;
      end;
    end;
  end;

  // Now update the dependencies
  for i := Low(info) to High(info) do
  begin
    if Length(info[i].Add_To_Uses) > 0 then
    begin
      for X := Low(info[i].Add_To_Uses) to High(info[i].Add_To_Uses) do
      begin
        for Y := Low(info) to High(info) do
        begin
          if UpperCase(ExtractFileName(info[Y].FileName))
            = UpperCase(info[i].Add_To_Uses[X].FileName) then
          begin
            SetLength(info[Y].Dependencies, Length(info[Y].Dependencies) + 1);
            info[Y].Dependencies[High(info[Y].Dependencies)].FileName :=
              ExtractFileName(info[i].FileName);
            break;
          end;
        end;
      end;
      SetLength(info[i].Add_To_Uses, 0);
    end;
  end;

end;

// ******************************************************************
// Return the handle of the Jaws application
// ******************************************************************
class function TJAWSManager.GetJAWSWindow: HWND;
const
  VISIBLE_WINDOW_CLASS: PChar = 'JFWUI2';
  VISIBLE_WINDOW_TITLE: PChar = 'JAWS';
  VISIBLE_WINDOW_TITLE2: PChar = 'Remote JAWS';
begin
  if JAWSHandle = 0 then
  begin
    JAWSHandle := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE);
    if JAWSHandle = 0 then
      JAWSHandle := FindWindow(VISIBLE_WINDOW_CLASS, VISIBLE_WINDOW_TITLE2);
    if JAWSHandle = 0 then
      JAWSHandle := FindJaws();
  end;

  Result := JAWSHandle;
end;

// ******************************************************************
// Return the handle of an application
// ******************************************************************
function FindHandle(exeFileName: string): HWND;
type
  TEInfo = record
    PID: DWORD;
    HWND: THandle;
  end;

  function CallBack(Wnd: DWORD; var EI: TEInfo): BOOL; stdcall;
  var
    PID: DWORD;
  begin
    GetWindowThreadProcessID(Wnd, @PID);;
    Result := (PID <> EI.PID) and (GetParent(Wnd) <> 0);
    // Result := (PID <> EI.PID) or (not IsWindowVisible(Wnd)) or
    // (not IsWindowEnabled(Wnd));
    if not Result then
      EI.HWND := Wnd;
  end;

var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  EInfo: TEInfo;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(exeFileName))) then
    begin
      EInfo.PID := FProcessEntry32.th32ProcessID;
      EInfo.HWND := 0;
      EnumWindows(@CallBack, Integer(@EInfo));
      Result := EInfo.HWND;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// ******************************************************************
// Is jaws running? and if so set the return var to the handle
// ******************************************************************
class function TJAWSManager.FindJaws(): HWND;
const
  ORIGNIAL_JAWS_EXE = 'jfw.exe';
var
  JawsParam, ErrMsg: String;
  reg: TRegistry;
  CanContinue: Boolean;
begin
  if FJAWSHandleSearchPerformed then
  begin
    LogInterface.LogText('INITIALIZATION', 'JAWS handle search already performed.  No need to do it again.');
    exit;
  end;

  // assume its not running
  Result := 0;

  LogInterface.LogText('INITIALIZATION', 'In TJAWSManager.FindJAWS');

  // Allow to turn off jaws if not wanted
  FindCommandSwitch('SCREADER', JawsParam);
  CanContinue := not(UpperCase(JawsParam) = 'NONE');

  if not CanContinue then
    LogInterface.LogText('Jaws Run  ',
      'Jaws Framework explictily turnded off via SCREADER parameter');

  // check for the registry
  if CanContinue then
  begin
    // check if JAWS has been installed by looking at the registry
    reg := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      CanContinue := reg.KeyExists(JAWS_REGROOT);
    finally
      reg.free;
    end;
  end;

  if not CanContinue then
    LogInterface.LogText('Jaws Run  ', 'Jaws registry not found');

  // look for the exe (jaws 16 and up)
  if CanContinue then
  begin
    Result := FindHandle(ORIGNIAL_JAWS_EXE);

    // cant find expected app running so look for paramater
    if Result = 0 then
    begin
      JawsParam := '';
      FindCommandSwitch('SCREADER', JawsParam);
      if Trim(JawsParam) <> '' then
      begin
        // Look for the paramater exe
        Result := FindHandle(JawsParam);
        if Result = 0 then
        begin
          // could not find the parameter exe running
          ErrMsg := Format(JAWS_NOT_RUNNING,
            [ExtractFileName(Application.ExeName), JawsParam,
            ExtractFileName(Application.ExeName)]);
          MessageBoxTimeOut(Application.Handle, PWideChar(ErrMsg),
            'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
            MB_TASKMODAL or MB_TOPMOST, 0, 30000);
          LogInterface.LogText('Jaws Run  ',
            'Instance Name: !! No running instances of JAWSfound !!');
        end
        else
          LogInterface.LogText('Jaws Run  ', 'Instance Name: ' + JawsParam);
      end
      else
      begin
      // no parameter and expected exe is not running
        ErrMsg := Format(JAWS_AUTO_NOT_RUNNING,
          [ExtractFileName(Application.ExeName),
          ExtractFileName(Application.ExeName)]);
        MessageBoxTimeOut(Application.Handle, PWideChar(ErrMsg),
          'JAWS Accessibility Detection Error', MB_OK or MB_ICONERROR or
          MB_TASKMODAL or MB_TOPMOST, 0, 30000);
      end;

      // set the global and return
      JAWSHandle := Result;

    end
    else
      LogInterface.LogText('Jaws Run  ', 'Instance Name: ' + ORIGNIAL_JAWS_EXE);

  end;
  FJAWSHandleSearchPerformed := true;
end;

// ******************************************************************
// Initial setup for JawsManager
// ******************************************************************
function TJAWSManager.Initialize(ComponentCallBackProc
  : TComponentDataRequestProc): BOOL;
var
  DestPath, StatText, LogTxt: string;
  ScriptFileChanges: Boolean;
  LastFileUpdated: Boolean;
  // CompileCommands: TStringList;
  CompileFiles: Array of tCompileFile;
  ArryCnt: Integer;

  // ******************************************************************
  // Retrieves the JAWS_SCRIPT_VERSION from a script file
  // ******************************************************************
  function GetVersion(FileName: string): Integer;
  var
    list: TStringList;
    p, i: Integer;
    line: string;
    working: Boolean;
  begin
    Result := 0;
    list := TStringList.Create;
    try
      list.LoadFromFile(FileName);
      i := 0;
      working := TRUE;
      while working and (i < list.Count) do
      begin
        line := list[i];
        p := Pos('=', line);
        if p > 0 then
        begin
          if Trim(Copy(line, 1, p - 1)) = JAWS_SCRIPT_VERSION then
          begin
            line := Trim(Copy(line, p + 1, MaxInt));
            if Copy(line, Length(line), 1) = ',' then
              delete(line, Length(line), 1);
            Result := StrToIntDef(line, 0);
            working := FALSE;
          end;
        end;
        Inc(i);
      end;
    finally
      list.free;
    end;
  end;

// ******************************************************************
// Compares versions between two script files
// ******************************************************************
  function VersionDifferent(FromFile, ToFile: string): Boolean;
  var
    FromVersion, ToVersion: Integer;
  begin
    FromVersion := GetVersion(FromFile);
    ToVersion := GetVersion(ToFile);
    Result := (FromVersion > ToVersion);
  end;

// ******************************************************************
// Determines if a line From FromFile is missing in the ToFile
// ******************************************************************
  function LineItemUpdateNeeded(FromFile, ToFile: string): Boolean;
  var
    fromList, toList: TStringList;
    i, idx: Integer;
    line: string;
  begin
    Result := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(ToFile);
      for i := 0 to fromList.Count - 1 do
      begin
        line := fromList[i];
        if Trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            Result := TRUE;
            break;
          end;
        end;
      end;
    finally
      toList.free;
      fromList.free;
    end;
  end;

// ******************************************************************
// Determines if an INI value from FromFile is missing in the ToFile
// ******************************************************************
  function INIUpdateNeeded(FromFile, ToFile: string): Boolean;
  var
    FromINIFile, ToINIFile: TINIFile;
    Sections, Values: TStringList;
    i, j: Integer;
    section, key, val1, val2: string;
  begin
    Result := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TINIFile.Create(FromFile);
      try
        ToINIFile := TINIFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for i := 0 to Sections.Count - 1 do
          begin
            section := Sections[i];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(section, key, '');
              Result := (val1 <> val2);
              if Result then
                break;
            end;
            if Result then
              break;
          end;
        finally
          ToINIFile.free;
        end;
      finally
        FromINIFile.free;
      end;
    finally
      Sections.free;
      Values.free;
    end;
  end;

{$REGION '*********************** Archived Sub Methods ***********************'}
{
  function IsUseLine(data: string): boolean;
  var
  p: Integer;
  begin
  Result := (copy(data, 1, 4) = 'use ');
  if Result then
  begin
  Result := FALSE;
  p := pos('"', data);
  if p > 0 then
  begin
  p := posEX('"', data, p + 1);
  if p = length(data) then
  Result := TRUE;
  end;
  end;
  end;

  function IsFunctionLine(data: string): boolean;
  var
  p1, p2: Integer;
  line: string;
  begin
  Result := FALSE;
  line := data;
  p1 := pos(' ', line);
  if (p1 > 0) then
  begin
  if copy(line, 1, p1 - 1) = 'script' then
  Result := TRUE
  else
  begin
  p2 := posEX(' ', line, p1 + 1);
  if p2 > 0 then
  begin
  line := copy(line, p1 + 1, p2 - p1 - 1);
  if (line = 'function') then
  Result := TRUE;
  end;
  end;
  end;
  end;

  function CheckForUseLineAndFunction(FromFile, ToFile: string): boolean;
  var
  FromData: TStringList;
  ToData: TStringList;
  UseLine: string;
  I: Integer;
  line: string;

  begin
  Result := FALSE;
  FromData := TStringList.Create;
  ToData := TStringList.Create;
  try
  UseLine := '';
  AppUseLine := '';
  AppStartFunctionLine := -1;
  FromData.LoadFromFile(FromFile);
  for I := 0 to FromData.Count - 1 do
  begin
  line := LowerCase(trim(FromData[I]));
  if (UseLine = '') and IsUseLine(line) then
  begin
  UseLine := line;
  AppUseLine := FromData[I];
  end
  else if (AppStartFunctionLine < 0) and IsFunctionLine(line) then
  AppStartFunctionLine := I;
  if (UseLine <> '') and (AppStartFunctionLine >= 0) then
  break;
  end;
  if (UseLine = '') or (AppStartFunctionLine < 0) then
  exit;

  AppNeedsUseLine := TRUE;
  AppScriptNeedsFunction := TRUE;
  ToData.LoadFromFile(ToFile);
  for I := 0 to ToData.Count - 1 do
  begin
  line := LowerCase(trim(ToData[I]));
  if AppNeedsUseLine and IsUseLine(line) and (line = UseLine) then
  AppNeedsUseLine := FALSE
  else if AppScriptNeedsFunction and IsFunctionLine(line) then
  AppScriptNeedsFunction := FALSE;
  if (not AppNeedsUseLine) and (not AppScriptNeedsFunction) then
  break;
  end;
  if AppNeedsUseLine or AppScriptNeedsFunction then
  Result := TRUE;
  finally
  FromData.Free;
  ToData.Free;
  end;
  end;

  function DoScriptMerge(FromFile, ToFile, ThisCompiler: string): boolean;
  var
  BackupFile: string;
  FromData: TStringList;
  ToData: TStringList;
  I, idx: Integer;
  ExitCode: Integer;
  begin
  Result := TRUE;
  BackupFile := ToFile + '.BACKUP';
  if FileExists(BackupFile) then
  begin
  MakeFileWritable(BackupFile);
  DeleteFile(PChar(BackupFile));
  end;
  DeleteCompiledFile(ToFile);
  CopyFile(PChar(ToFile), PChar(BackupFile), FALSE);
  MakeFileWritable(ToFile);
  FromData := TStringList.Create;
  ToData := TStringList.Create;
  try
  ToData.LoadFromFile(ToFile);
  if AppNeedsUseLine then
  ToData.Insert(0, AppUseLine);
  if AppScriptNeedsFunction then
  begin
  FromData.LoadFromFile(FromFile);
  ToData.Insert(1, '');
  idx := 2;
  for I := AppStartFunctionLine to FromData.Count - 1 do
  begin
  ToData.Insert(idx, FromData[I]);
  inc(idx);
  end;
  ToData.Insert(idx, '');
  end;
  if not assigned(JAWSAPI) then
  JAWSAPI := CoJawsApi.Create;
  ToData.SaveToFile(ToFile);
  ExitCode := ExecuteAndWait('"' + ThisCompiler + '"', '"' + ToFile + '"');
  JAWSAPI.StopSpeech;
  if ExitCode = 0 then // compile succeeded!
  ReloadConfiguration
  else
  Result := FALSE; // compile failed - just copy the new one
  finally
  FromData.Free;
  ToData.Free;
  end;
  end;

}
{$ENDREGION}
// ******************************************************************
// Fire off the correct check based on the CompareType
// ******************************************************************
  function UpdateNeeded(FromFile, ToFile: string;
    CompareType: TCompareType): Boolean;
  begin
    Result := TRUE;
    try
      case CompareType of
        jcScriptMerge:
          Result := VersionDifferent(FromFile, ToFile);
        jcPrior:
          Result := LastFileUpdated;
        jcVersion:
          Result := VersionDifferent(FromFile, ToFile);
        jcINI:
          Result := INIUpdateNeeded(FromFile, ToFile);
        jcLineItems:
          Result := LineItemUpdateNeeded(FromFile, ToFile);
        jcINIMRG:
          Result := INIUpdateNeeded(FromFile, ToFile);
        jcLineItemsMRG:
          Result := LineItemUpdateNeeded(FromFile, ToFile);
      end;
    except
      on E: Exception do
        FJAWSFileError := E.Message;
    end;
  end;

// ******************************************************************
// Update the Ini File
// ******************************************************************
  procedure INIFileUpdate(FromFile, ToFile: String);
  var
    FromINIFile, ToINIFile: TINIFile;
    Sections, Values: TStringList;
    i, j: Integer;
    section, key, val1, val2: string;
    modified: Boolean;
  begin
    modified := FALSE;
    Sections := TStringList.Create;
    Values := TStringList.Create;
    try
      FromINIFile := TINIFile.Create(FromFile);
      try
        ToINIFile := TINIFile.Create(ToFile);
        try
          FromINIFile.ReadSections(Sections);
          for i := 0 to Sections.Count - 1 do
          begin
            section := Sections[i];
            FromINIFile.ReadSectionValues(section, Values);
            for j := 0 to Values.Count - 1 do
            begin
              key := Values.Names[j];
              val1 := Values.ValueFromIndex[j];
              val2 := ToINIFile.ReadString(section, key, '');
              if (val1 <> val2) then
              begin
                ToINIFile.WriteString(section, key, val1);
                modified := TRUE;
              end;
            end;
          end;
        finally
          if modified then
            ToINIFile.UpdateFile();
          ToINIFile.free;
        end;
      finally
        FromINIFile.free;
      end;
    finally
      Sections.free;
      Values.free;
    end;
  end;

// ******************************************************************
// Update the Line Item
// ******************************************************************
  procedure LineItemFileUpdate(FromFile, ToFile: string);
  var
    fromList, toList: TStringList;
    i, idx: Integer;
    line: string;
    modified: Boolean;
  begin
    modified := FALSE;
    fromList := TStringList.Create;
    toList := TStringList.Create;
    try
      fromList.LoadFromFile(FromFile);
      toList.LoadFromFile(ToFile);
      for i := 0 to fromList.Count - 1 do
      begin
        line := fromList[i];
        if Trim(line) <> '' then
        begin
          idx := toList.IndexOf(line);
          if idx < 0 then
          begin
            toList.Add(line);
            modified := TRUE;
          end;
        end;
      end;
    finally
      if modified then
        toList.SaveToFile(ToFile);
      toList.free;
      fromList.free;
    end;
  end;

// ******************************************************************
// Remove a Compiled file
// ******************************************************************
  procedure DeleteCompiledFile(ToFile: string);
  var
    CompiledFile: string;
  begin
    CompiledFile := Copy(ToFile, 1, Length(ToFile) -
      Length(ExtractFileExt(ToFile)));
    CompiledFile := CompiledFile + CompiledScriptFileExtension;
    if FileExists(CompiledFile) then
    begin
      MakeFileWritable(CompiledFile);
      DeleteFile(PChar(CompiledFile));
    end;
  end;

  Procedure LoadFileIntoCompiler(ToFile: string; ThisJawsRec: TJawsRecord);
  var
    FileName, extName, Depfile: String;
    X, Y: Integer;
    LookForVaApp: Boolean;
  begin
    SetLength(CompileFiles, Length(CompileFiles) + 1);
    CompileFiles[High(CompileFiles)].FileName := ToFile;
    CompileFiles[High(CompileFiles)].Compiled := FALSE;
    CompileFiles[High(CompileFiles)].Compiler := ThisJawsRec.Compiler;

    // Load dependencies
    FileName := Piece(ExtractFileName(ToFile), '.', 1);
    extName := Piece(ExtractFileName(ToFile), '.', 2);
    LookForVaApp := FileName = Piece(ExtractFileName(ParamStr(0)), '.', 1);

    // Build dependencies
    for X := Low(ScriptFiles) to High(ScriptFiles) do
    begin
      if (ExtractFileName(ScriptFiles[X].FileName) = ExtractFileName(ToFile)) or
        ((LookForVaApp) and
        (UpperCase(Piece(ExtractFileName(ScriptFiles[X].FileName), '.', 1))
        = UpperCase(JAWS_APP_NAME)) and
        (UpperCase(Piece(ExtractFileName(ScriptFiles[X].FileName), '.', 2))
        = UpperCase(extName))) then
      begin
        if Length(ScriptFiles[X].Dependencies) > 0 then
        begin
          for Y := Low(ScriptFiles[X].Dependencies)
            to High(ScriptFiles[X].Dependencies) do
          begin
            SetLength(CompileFiles[High(CompileFiles)].DependentFile,
              Length(CompileFiles[High(CompileFiles)].DependentFile) + 1);
            Depfile := ExtractFilePath(ToFile);
            Depfile := AppendBackSlash(Depfile);
            CompileFiles[High(CompileFiles)].DependentFile
              [High(CompileFiles[High(CompileFiles)].DependentFile)].FileName :=
              Depfile + ScriptFiles[X].Dependencies[Y].FileName;
            CompileFiles[High(CompileFiles)].DependentFile
              [High(CompileFiles[High(CompileFiles)].DependentFile)
              ].Compiled := FALSE;
            CompileFiles[High(CompileFiles)].DependentFile
              [High(CompileFiles[High(CompileFiles)].DependentFile)].Compiler :=
              ThisJawsRec.Compiler;
          end;
        end;
        break;
      end;
    end;
  end;

// ******************************************************************
// Update the ToFile from the FromFile
// ******************************************************************
  procedure UpdateFile(FromFile, ToFile: string; ThisJawsRec: TJawsRecord;
    info: TFileInfo);
  var
    DoCopy: Boolean;
    error: Boolean;
    CheckOverwrite: Boolean;
    VersionNum: string;
  begin
    DoCopy := FALSE;
    if FileExists(ToFile) then
    begin
      MakeFileWritable(ToFile);
      CheckOverwrite := TRUE;

      VersionNum := FloatToStr(ThisJawsRec.Version);
      if Pos('.', VersionNum) > 0 then
        VersionNum := Copy(VersionNum, 1, Pos('.', VersionNum) - 1);
      if FindCommandSwitch('FORCEUPD') or
        FindCommandSwitch('FORCEUPD' + VersionNum) then
      begin
        CheckOverwrite := FALSE;
        DoCopy := TRUE;
      end
      else
      begin

        try
          case info.CompareType of
            jcScriptMerge:
              DoCopy := TRUE;
            jcPrior, jcVersion:
              DoCopy := TRUE;
            jcINI:
              INIFileUpdate(FromFile, ToFile);
            jcLineItems:
              LineItemFileUpdate(FromFile, ToFile);
            jcINIMRG:
              INIFileUpdate(FromFile, ToFile);
            jcLineItemsMRG:
              LineItemFileUpdate(FromFile, ToFile);
          end;
        except
          on E: Exception do
            FJAWSFileError := E.Message;
        end;
      end;
    end
    else
    begin
      CheckOverwrite := FALSE;
      DoCopy := TRUE;
    end;

    if DoCopy then
    begin
      error := FALSE;
      if not CopyFile(PChar(FromFile), PChar(ToFile), FALSE) then
      begin
        error := TRUE;
        LogTxt := LogTxt + #13#10 + 'Error copying to: "' +
          ExtractFilePath(ToFile) + '" ' + CRLF +
          '!! Error in CopyFile method!!';
        if assigned(UserSplash) then
          UserSplash.TaskError := 'Error copying to: "' +
            ExtractFilePath(ToFile);
      end
      else
        LogTxt := LogTxt + #13#10 + 'copied to: "' +
          ExtractFilePath(ToFile) + '".';

      if (not error) and (not FileExists(ToFile)) then
      begin
        error := TRUE;
      end;
      if (not error) and CheckOverwrite and (info.CompareType <> jcPrior) and
        UpdateNeeded(FromFile, ToFile, info.CompareType) then
        error := TRUE;
      if error and (not FileErrorExists) then
        FJAWSFileError := 'Error copying "' + ExtractFilePath(FromFile) + '" to'
          + CRLF + '"' + ExtractFilePath(ToFile) + '".';
      if (not error) and (info.Compile) then
      begin
        DeleteCompiledFile(ToFile);
        LoadFileIntoCompiler(ToFile, ThisJawsRec);
        LogTxt := LogTxt + #13#10 + 'Compile Needed: YES';
      end
      else
        LogTxt := LogTxt + #13#10 + 'Compile Needed: NO';
    end;
  end;

  Procedure UpdateUses(ToFile, aUpdateStr: string);
  var
    tempStrLst: TStringList;
    i: Integer;
  begin
    tempStrLst := TStringList.Create;
    try
      tempStrLst.LoadFromFile(ToFile);
      for i := 0 to tempStrLst.Count - 1 do
      begin
        if Pos(JAWS_FRAMEWORK_USES, tempStrLst[i]) > 0 then
        begin
          tempStrLst[i] := aUpdateStr;
          break;
        end;
      end;
      tempStrLst.SaveToFile(ToFile);
    finally
      tempStrLst.free;
    end;
  end;

// ******************************************************************
// Keeps Jaws files aliged with the ones in Vist\Common Files
// ******************************************************************
  procedure EnsureJAWSScriptsAreUpToDate(var ThisJawsRec: TJawsRecord);
  var
    DestFile, FromFile, ToFile, AppName, Ext: string;
    idx1, idx2, i, X: Integer;
    DoUpdate, DoUses: Boolean;
    VersionNum, UsesStr, UpdFileName: String;
  begin
    AppName := ExtractFileName(ParamStr(0));
    Ext := ExtractFileExt(AppName);
    AppName := LeftStr(AppName, Length(AppName) - Length(Ext));
    DestPath := '';
    idx1 := Pos(JAWS_COMMON_SCRIPT_PATH_TEXT, ThisJawsRec.UserScriptDir);
    idx2 := Pos(JAWS_COMMON_SCRIPT_PATH_TEXT, ThisJawsRec.DefaultScriptDir);
    if (idx1 > 0) and (idx2 > 0) then
    begin
      DestPath := Copy(ThisJawsRec.UserScriptDir, 1, idx1 - 1) +
        Copy(ThisJawsRec.DefaultScriptDir, idx2, MaxInt);

      DestFile := DestPath + AppName;
      ThisJawsRec.FDictionaryFileName := DestFile + DictionaryFileExtension;
      ThisJawsRec.FConfigFile := DestFile + ConfigFileExtension;
      ThisJawsRec.FKeyMapFile := DestFile + KeyMapExtension;
      LastFileUpdated := FALSE;

      // Look up the files
      if Length(ScriptFiles) = 0 then
        GetScriptFiles(ScriptFiles);

      for i := low(ScriptFiles) to high(ScriptFiles) do
      begin
        DoUses := FALSE;
        // Look for dependencies
        if Length(ScriptFiles[i].Dependencies) > 0 then
        begin
          UsesStr := '';
          // add the compiled dependencies to the uses
          for X := Low(ScriptFiles[i].Dependencies)
            to High(ScriptFiles[i].Dependencies) do
          begin
            UpdFileName := Piece(ScriptFiles[i].Dependencies[X].FileName, '.',
              1) + CompiledScriptFileExtension;
            UsesStr := UsesStr + 'use "' + UpdFileName + '"' + #10#13
          end;
          DoUses := TRUE;
        end;

        if UpperCase(Piece(ExtractFileName(ScriptFiles[i].FileName), '.', 1)) = JAWS_APP_NAME
        then
        begin
          FromFile := ScriptFiles[i].FileName;
          ToFile := DestFile + ExtractFileExt(ScriptFiles[i].FileName);
        end
        else
        begin
          FromFile := ScriptFiles[i].FileName;
          ToFile := DestPath + ExtractFileName(ScriptFiles[i].FileName);
        end;
        LogTxt := 'Filename: ' + ExtractFileName(FromFile);
        if ScriptFiles[i].Exist then
        begin
          if FileExists(ToFile) then
          begin
            // add force for rebuild
            VersionNum := FloatToStr(ThisJawsRec.Version);
            if Pos('.', VersionNum) > 0 then
              VersionNum := Copy(VersionNum, 1, Pos('.', VersionNum) - 1);

            if FindCommandSwitch('FORCEUPD') then
              DoUpdate := TRUE
            else if FindCommandSwitch('FORCEUPD' + VersionNum) then
              DoUpdate := TRUE
            else
              DoUpdate := UpdateNeeded(FromFile, ToFile,
                ScriptFiles[i].CompareType);
            if DoUpdate then
            begin
              MakeFileWritable(ToFile);
              LogTxt := LogTxt + #13#10 + 'Update needed: YES'
            end
            else
              LogTxt := LogTxt + #13#10 + 'Update needed: NO';

          end
          else
            DoUpdate := TRUE;
          LastFileUpdated := DoUpdate;
          if DoUpdate and (not FileErrorExists) then
          begin
            UpdateFile(FromFile, ToFile, ThisJawsRec, ScriptFiles[i]);
            if DoUses then
              UpdateUses(ToFile, UsesStr);
            ScriptFileChanges := TRUE;
          end;

          if FileErrorExists then
            break;
          LogInterface.LogText(' Compare  ', LogTxt);
        end;
        UserSplash.IncProg;
      end;

    end
    else
      FJAWSFileError := 'Unknown File Error';
    // should never happen - condition checked previously
  end;

// ******************************************************************
// Recompile Jaws with the new files
// ******************************************************************
  procedure DoCompiles(ThisJawsRec: TJawsRecord);
  var
    i, X, Y: Integer;
    RunTxt: String;
    RunStatus: Boolean;
  begin
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;

    LogInterface.LogText(' Compile  ', 'Compiler: ' + ThisJawsRec.Compiler);
    for i := Low(CompileFiles) to High(CompileFiles) do
    begin
      if not CompileFiles[i].Compiled then
      begin
        if Length(CompileFiles[i].DependentFile) > 0 then
        begin
          for X := Low(CompileFiles[i].DependentFile)
            to High(CompileFiles[i].DependentFile) do
          begin
            if not CompileFiles[i].DependentFile[X].Compiled then
            begin
              try
                RunStatus := CompileFiles[i].DependentFile[X]
                  .CompileFile(RunTxt);
                if not RunStatus then
                begin
                  LogInterface.LogText(' ERROR  ',
                    'File: ' + ExtractFileName(CompileFiles[i].DependentFile[X]
                    .FileName) + #13#10 + RunTxt);
                  if assigned(UserSplash) then
                    UserSplash.TaskError := 'File: ' +
                      ExtractFileName(CompileFiles[i].DependentFile[X].FileName)
                      + ' - ' + RunTxt;
                end
                else
                  LogInterface.LogText(' Compile  ',
                    'File: ' + ExtractFileName(CompileFiles[i].DependentFile[X]
                    .FileName) + #13#10 + RunTxt);

                JAWSAPI.StopSpeech;
                // Update the record
                CompileFiles[i].DependentFile[X].Compiled := TRUE;

                // Find the main record and mark it as compiled
                for Y := Low(CompileFiles) to High(CompileFiles) do
                begin
                  if ExtractFileName(CompileFiles[Y].FileName)
                    = ExtractFileName(CompileFiles[i].DependentFile[X].FileName)
                  then
                  begin
                    CompileFiles[Y].Compiled := TRUE;
                    break;
                  end;
                end;

              except
                on E: Exception do
                begin
                  LogInterface.LogText('Error compiling ' +
                    ExtractFileName(CompileFiles[i].DependentFile[X].FileName),
                    E.Message);
                  if assigned(UserSplash) then
                    UserSplash.TaskError := 'Error compiling ' +
                      ExtractFileName(CompileFiles[i].DependentFile[X].FileName)
                      + ' - ' + E.Message;
                end;
              end;
            end;
          end;
        end;

        try
          RunStatus := CompileFiles[i].CompileFile(RunTxt);
          if not RunStatus then
          begin
            LogInterface.LogText(' ERROR  ',
              'File: ' + ExtractFileName(CompileFiles[i].FileName) + #13#10
              + RunTxt);
            if assigned(UserSplash) then
              UserSplash.TaskError := 'File: ' +
                ExtractFileName(CompileFiles[i].FileName) + ' - ' + RunTxt;
          end
          else
            LogInterface.LogText(' Compile  ',
              'File: ' + ExtractFileName(CompileFiles[i].FileName) + #13#10
              + RunTxt);
          JAWSAPI.StopSpeech;
          // Update the record
          CompileFiles[i].Compiled := TRUE;
        except
          on E: Exception do
          begin
            LogInterface.LogText('Error compiling ' +
              ExtractFileName(CompileFiles[i].FileName), E.Message);
            if assigned(UserSplash) then
              UserSplash.TaskError := 'Error compiling ' +
                ExtractFileName(CompileFiles[i].FileName) + ' - ' + E.Message;
          end;
        end;

      end;
    end;

    ReloadConfiguration;
  end;

begin
  Result := FALSE;
  for ArryCnt := Low(JawsRecord) to High(JawsRecord) do
  begin
    StatText := 'Processing JAWS ' + FloatToStr(JawsRecord[ArryCnt].Version);
    LogInterface.LogText('JAWS ' + FloatToStr(JawsRecord[ArryCnt].Version), '');
    UserSplash.TaskTitle := StatText;
    ScriptFileChanges := FALSE;
    if JAWSManager.RequiredFilesFound then
    begin
      FJAWSFileError := '';
      SetLength(CompileFiles, 0);
      try
        UserSplash.TaskText :=
          'Ensuring Jaws script files are up to date with latest versions';
        EnsureJAWSScriptsAreUpToDate(JawsRecord[ArryCnt]);
        UserSplash.IncProg;

        if Length(CompileFiles) > 0 then
        begin
          UserSplash.TaskText :=
            'Jaws scripts updated. Compiling necessary script files';
          DoCompiles(JawsRecord[ArryCnt]);
        end;
        UserSplash.IncProg;
      finally
        SetLength(CompileFiles, 0);
      end;
      if FileErrorExists then
        ShowError(JAWS_ERROR_FILE_IO, [FJAWSFileError]);
    end
    else
      UserSplash.IncProg(2 + Length(ScriptFiles));
    UserSplash.IncProg;
  end;
  UserSplash.TaskTitle := 'General';
  UserSplash.TaskText := 'Verifying User compatibility';
  UserSplash.IncProg;
  fComponentCallBackProc := ComponentCallBackProc;
  fScriptFilesChanged := ScriptFileChanges;
  Result := JAWSTalking2CurrentUser;

end;

// ******************************************************************
// Returns if the JawsManager is running
// ******************************************************************
class function TJAWSManager.IsRunning(HighVersion, LowVersion: Word): BOOL;

  function ComponentVersionSupported: Boolean;
  var
    SupportedHighVersion, SupportedLowVersion: Integer;
    FileName, newVersion, convertedVersion, currentVersion: string;
    addr: Pointer;

  begin
    addr := @TJAWSManager.IsRunning;
    FileName := GetDLLFileName(addr);
    currentVersion := FileVersionValue(FileName, FILE_VER_FILEVERSION);
    VersionStringSplit(currentVersion, SupportedHighVersion,
      SupportedLowVersion);
    Result := FALSE;
    if (HighVersion < SupportedHighVersion) then
      Result := TRUE
    else if (HighVersion = SupportedHighVersion) and
      (LowVersion <= SupportedLowVersion) then
      Result := TRUE;
    if not Result then
    begin
      newVersion := IntToStr(HighVersion) + '.' + IntToStr(LowVersion);
      convertedVersion := IntToStr(SupportedHighVersion) + '.' +
        IntToStr(SupportedLowVersion);
      ShowError(DLL_ERROR_VERSION, [newVersion, convertedVersion]);
    end;

    if Result then
      LogInterface.LogText('Jaws Check', 'DLL Version: ' + currentVersion +
        ' supported')
    else
      LogInterface.LogText('Jaws Check', 'DLL Version: ' + currentVersion +
        ' not supported');
  end;

begin
  Result := (GetJAWSWindow <> 0);
  if Result then
    Result := ComponentVersionSupported;
  if Result then
    Result := JAWSVersionOK;
  if Result then
  begin
    EnsureManager;
    with JAWSManager do
      Result := RequiredFilesFound;
  end;
end;

// ******************************************************************
// Verfiy jaws and application are ran by the same user
// ******************************************************************
class function TJAWSManager.JAWSTalking2CurrentUser: Boolean;
var
  CurrentUserPath: string;
  WhatJAWSThinks: string;

  // ******************************************************************
  // Gathers the username that ran the process
  // ******************************************************************
  Function GetProcessDomainAndUser(PID: DWORD): string;
  type
    PUserToken = ^UserToken;

    _UserToken = record
      User: TSIDAndAttributes;
    end;

    UserToken = _UserToken;
  var
    TkHandle, PHandle: THandle;
    SidUsr: SID_NAME_USE;
    RBuf: Cardinal;
    PUser: PUserToken;
    DomainSize, UserSize: DWORD;
    Ok: Boolean;
    User, Domain: string;
  begin
    Result := '';
    PHandle := OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, PID);
    if PHandle <> 0 then
    begin
      if OpenProcessToken(PHandle, TOKEN_QUERY, TkHandle) then
      begin
        Ok := GetTokenInformation(TkHandle, TokenUser, nil, 0, RBuf);
        PUser := nil;
        while (not Ok) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
        begin
          ReallocMem(PUser, RBuf);
          Ok := GetTokenInformation(TkHandle, TokenUser, PUser, RBuf, RBuf);
        end;
        CloseHandle(TkHandle);

        if not Ok then
        begin
          Exit;
        end;

        UserSize := 0;
        DomainSize := 0;
        LookupAccountSid(nil, PUser.User.Sid, nil, UserSize, nil,
          DomainSize, SidUsr);
        if (UserSize <> 0) and (DomainSize <> 0) then
        begin
          SetLength(User, UserSize);
          SetLength(Domain, DomainSize);
          if LookupAccountSid(nil, PUser.User.Sid, PChar(User), UserSize,
            PChar(Domain), DomainSize, SidUsr) then
            Result := StrPas(PChar(Domain)) + '/' + StrPas(PChar(User));
        end;

        if Ok then
        begin
          FreeMem(PUser);
        end;
      end;
      CloseHandle(PHandle);
    end;
  end;

{$REGION '*********************** Archived Sub Method ***********************'}
{
  procedure Fix(var path: string);
  var
  idx: Integer;
  begin
  idx := pos(APP_DATA, LowerCase(path));
  if idx > 0 then
  path := LeftStr(path, idx - 1);
  idx := length(path);
  while (idx > 0) and (path[idx] <> '\') do
  dec(idx);
  delete(path, 1, idx);
  end;
}
{$ENDREGION}
// ******************************************************************
// Verify same user using Jaws and Application
// ******************************************************************
  function UserProblemExists: Boolean;
  var
    JAWSWindow: HWND;
    JAWSPid: DWORD;
    CPRSPid: DWORD;
  begin
    JAWSWindow := GetJAWSWindow;
    JAWSPid := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessID(JAWSWindow, @JAWSPid);
    CPRSPid := GetCurrentProcessID;
    LogInterface.LogText('JAWS CHECK', 'Current PID: ' + IntToStr(CPRSPid));
    LogInterface.LogText('JAWS CHECK', '   JAWS PID: ' + IntToStr(JAWSPid));
    CurrentUserPath := GetProcessDomainAndUser(CPRSPid);
    LogInterface.LogText('JAWS CHECK', 'User Problem Exists 2072 CurrentUserPath: ' + CurrentUserPath);
    WhatJAWSThinks := GetProcessDomainAndUser(JAWSPid);
    LogInterface.LogText('JAWS CHECK', 'User Problem Exists 2074  WhatJAWSThinks: ' + WhatJawsThinks);
    Result := StrIComp(PWideChar(CurrentUserPath), PWideChar(WhatJAWSThinks)) <> 0;
  end;

begin
  // blj 4 Dec 2018 - attempting to find the JAWS window and query it is no longer possible effectively
  // from CPRS due to permissions problems.  According to Microsoft, the APIs being used to query
  // will not, by design, work when querying a 64 bit process from 32 bit code.  After repeated testing,
  // it was found that JAWS was connecting to CPRS anyway, making this check superfluous.
  {
  if UserProblemExists then
  begin
    ShowError(JAWS_ERROR_USER_PROBLEM);
    Result := FALSE;
  end
  else
  }
    Result := TRUE;
end;

// ******************************************************************
// Verify the version of Jaws is supported
// ******************************************************************
class function TJAWSManager.JAWSVersionOK: Boolean;
var
  JFileVersion: string;
  JFile: string;
  i: Integer;
  ErrFound, Ok: Boolean;

  // ******************************************************************
  // Try to create the Jaws Api
  // ******************************************************************
  function OlderVersionOKIfCOMObjectInstalled: Boolean;
  var
    api: IJawsApi;
  begin
    Result := VersionOK(JAWS_REQUIRED_VERSION, JFileVersion);
    if Result then
    begin
      try
        try
          api := CoJawsApi.Create;
        except
          Result := FALSE;
        end;
      finally
        api := nil;
      end;
    end;
  end;

begin
  ErrFound := FALSE;
  for i := Low(JawsRecord) to High(JawsRecord) do
  begin
    JFile := ExtractFilePath(JawsRecord[i].Compiler) +
      JAWS_APPLICATION_FILENAME;
    if FileExists(JFile) then
    begin
      JFileVersion := FileVersionValue(JFile, FILE_VER_FILEVERSION);
      Ok := VersionOK(JAWS_COM_OBJECT_VERSION, JFileVersion);
      if not Ok then
        Ok := OlderVersionOKIfCOMObjectInstalled;
    end
    else
    begin
      // if file not found, then assume a future version where the exe was moved
      // to a different location
      Ok := TRUE;
    end;
    if not Ok then
    begin
      ErrFound := TRUE;
      break;
    end;
    if Ok then
      LogInterface.LogText('Jaws Check', 'Instance Version: ' + JFileVersion +
        ' supported')
    else
      LogInterface.LogText('Jaws Check', 'Instance Version: ' + JFileVersion +
        ' not supported');
  end;
  if ErrFound then
    ShowError(JAWS_ERROR_VERSION);

  Result := not ErrFound;

end;

// ******************************************************************
// Delete Ini files
// ******************************************************************
procedure TJAWSManager.KillINIFiles(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(JawsRecord) to High(JawsRecord) do
  begin
    if assigned(JawsRecord[i].FDictionaryFile) then
    begin
      if JawsRecord[i].FDictionaryFileModified then
      begin
        MakeFileWritable(JawsRecord[i].FDictionaryFileName);
        JawsRecord[i].FDictionaryFile.SaveToFile
          (JawsRecord[i].FDictionaryFileName);
      end;
      FreeAndNil(JawsRecord[i].FDictionaryFile);
    end;

    if assigned(JawsRecord[i].FConfigINIFile) then
    begin
      if JawsRecord[i].FConfigINIFileModified then
      begin
        JawsRecord[i].FConfigINIFile.UpdateFile;
      end;
      FreeAndNil(JawsRecord[i].FConfigINIFile);
    end;

    if assigned(JawsRecord[i].FKeyMapINIFile) then
    begin
      if JawsRecord[i].FKeyMapINIFileModified then
      begin
        JawsRecord[i].FKeyMapINIFile.UpdateFile;
      end;
      FreeAndNil(JawsRecord[i].FKeyMapINIFile);
    end;

    if assigned(JawsRecord[i].FAssignedKeys) then
      FreeAndNil(JawsRecord[i].FAssignedKeys);
  end;
end;

// ******************************************************************
// Create the dispatcher window
// ******************************************************************
procedure TJAWSManager.LaunchMasterApplication;
begin
  if not assigned(FHiddenJaws) then
    FHiddenJaws := TfrmVA508JawsDispatcherHiddenWindow.Create(Application);
end;

procedure TJAWSManager.RegisterCustomBehavior(Before, After: string;
  Action: Integer);

const
  WindowClassesSection = 'WindowClasses';
  MSAAClassesSection = 'MSAAClasses';
  DICT_DELIM: char = char($2E);
  CommonKeysSection = 'Common Keys';
  CustomCommandHelpSection = 'Custom Command Help';
  KeyCommand = 'VA508SendCustomCommand(';
  KeyCommandLen = Length(KeyCommand);

var
  modified: Boolean;

  procedure Add2INIFile(var INIFile: TINIFile; var FileModified: Boolean;
    FileName, SectionName, data, Value: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    oldValue := INIFile.ReadString(SectionName, data, '');
    if oldValue <> Value then
    begin
      INIFile.WriteString(SectionName, data, Value);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RemoveFromINIFile(var INIFile: TINIFile; var FileModified: Boolean;
    FileName, SectionName, data: string);
  var
    oldValue: string;

  begin
    if not assigned(INIFile) then
    begin
      MakeFileWritable(FileName);
      INIFile := TINIFile.Create(FileName);
      FileModified := FALSE;
    end;
    oldValue := INIFile.ReadString(SectionName, data, '');
    if oldValue <> '' then
    begin
      INIFile.DeleteKey(SectionName, data);
      modified := TRUE;
      FileModified := TRUE;
    end;
  end;

  procedure RegisterCustomClassChange;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
      Add2INIFile(JawsRecord[i].FConfigINIFile,
        JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
        WindowClassesSection, Before, After);
  end;

  procedure RegisterMSAAClassChange;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
      Add2INIFile(JawsRecord[i].FConfigINIFile,
        JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
        MSAAClassesSection, Before, '1');
  end;

  procedure RegisterCustomKeyMapping;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
    begin
      Add2INIFile(JawsRecord[i].FKeyMapINIFile,
        JawsRecord[i].FKeyMapINIFileModified, JawsRecord[i].FKeyMapFile,
        CommonKeysSection, Before, KeyCommand + After + ')');
      if not assigned(JawsRecord[i].FAssignedKeys) then
        JawsRecord[i].FAssignedKeys := TStringList.Create;
      JawsRecord[i].FAssignedKeys.Add(Before);
    end;
  end;

  procedure RegisterCustomKeyDescription;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
      Add2INIFile(JawsRecord[i].FConfigINIFile,
        JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
        CustomCommandHelpSection, Before, After);
  end;

  procedure DecodeLine(line: string; var before1, after1: string);
  var
    i, j, Len: Integer;
  begin
    before1 := '';
    after1 := '';
    Len := Length(line);
    if (Len < 2) or (line[1] <> DICT_DELIM) then
      Exit;
    i := 2;
    while (i < Len) and (line[i] <> DICT_DELIM) do
      Inc(i);
    before1 := Copy(line, 2, i - 2);
    j := i + 1;
    while (j <= Len) and (line[j] <> DICT_DELIM) do
      Inc(j);
    after1 := Copy(line, i + 1, j - i - 1);
  end;

  procedure RegisterCustomDictionaryChange;
  var
    i, idx, X: Integer;
    line, before1, after1: string;
    Add: Boolean;
  begin
    for X := Low(JawsRecord) to High(JawsRecord) do
    begin
      if not assigned(JawsRecord[X].FDictionaryFile) then
      begin
        JawsRecord[X].FDictionaryFile := TStringList.Create;
        JawsRecord[X].FDictionaryFileModified := FALSE;
        if FileExists(JawsRecord[X].FDictionaryFileName) then
          JawsRecord[X].FDictionaryFile.LoadFromFile
            (JawsRecord[X].FDictionaryFileName);
      end;

      Add := TRUE;
      idx := -1;
      for i := 0 to JawsRecord[X].FDictionaryFile.Count - 1 do
      begin
        line := JawsRecord[X].FDictionaryFile[i];
        DecodeLine(line, before1, after1);
        if (before1 = Before) then
        begin
          idx := i;
          if after1 = After then
            Add := FALSE;
          break;
        end;
      end;
      if Add then
      begin
        line := DICT_DELIM + Before + DICT_DELIM + After + DICT_DELIM;
        if idx < 0 then
          JawsRecord[X].FDictionaryFile.Add(line)
        else
          JawsRecord[X].FDictionaryFile[idx] := line;
        modified := TRUE;
        JawsRecord[X].FDictionaryFileModified := TRUE;
      end;
    end;
  end;

  procedure RemoveComponentClass;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
      RemoveFromINIFile(JawsRecord[i].FConfigINIFile,
        JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
        WindowClassesSection, Before);
  end;

  procedure RemoveMSAAClass;
  Var
    i: Integer;
  begin
    for i := Low(JawsRecord) to High(JawsRecord) do
      RemoveFromINIFile(JawsRecord[i].FConfigINIFile,
        JawsRecord[i].FConfigINIFileModified, JawsRecord[i].FConfigFile,
        MSAAClassesSection, Before);
  end;

  procedure PurgeKeyMappings;
  var
    i, X: Integer;
    Name, Value: string;
    keys: TStringList;
    delete: Boolean;
  begin
    for X := Low(JawsRecord) to High(JawsRecord) do
    begin
      if not assigned(JawsRecord[X].FKeyMapINIFile) then
      begin
        MakeFileWritable(JawsRecord[X].FKeyMapFile);
        JawsRecord[X].FKeyMapINIFile :=
          TINIFile.Create(JawsRecord[X].FKeyMapFile);
        JawsRecord[X].FKeyMapINIFileModified := FALSE;
      end;
      keys := TStringList.Create;
      try
        JawsRecord[X].FKeyMapINIFile.ReadSectionValues(CommonKeysSection, keys);
        for i := keys.Count - 1 downto 0 do
        begin
          Value := Copy(keys.ValueFromIndex[i], 1, KeyCommandLen);
          if Value = KeyCommand then
          begin
            name := keys.Names[i];
            delete := (not assigned(JawsRecord[X].FAssignedKeys));
            if not delete then
              delete := (JawsRecord[X].FAssignedKeys.IndexOf(name) < 0);
            if delete then
            begin
              JawsRecord[X].FKeyMapINIFile.DeleteKey(CommonKeysSection, name);
              JawsRecord[X].FKeyMapINIFileModified := TRUE;
              modified := TRUE;
            end;
          end;
        end;
      finally
        keys.free;
      end;
    end;
  end;

begin
  { TODO : check file io errors when updating config files }
  modified := FALSE;
  case Action of
    BEHAVIOR_ADD_DICTIONARY_CHANGE:
      RegisterCustomDictionaryChange;
    BEHAVIOR_ADD_COMPONENT_CLASS:
      RegisterCustomClassChange;
    BEHAVIOR_ADD_COMPONENT_MSAA:
      RegisterMSAAClassChange;
    BEHAVIOR_ADD_CUSTOM_KEY_MAPPING:
      RegisterCustomKeyMapping;
    BEHAVIOR_ADD_CUSTOM_KEY_DESCRIPTION:
      RegisterCustomKeyDescription;
    BEHAVIOR_REMOVE_COMPONENT_CLASS:
      RemoveComponentClass;
    BEHAVIOR_REMOVE_COMPONENT_MSAA:
      RemoveMSAAClass;
    BEHAVIOR_PURGE_UNREGISTERED_KEY_MAPPINGS:
      PurgeKeyMappings;
  end;
  if modified and assigned(FMainForm) then
  begin
    FMainForm.ResetINITimer(KillINIFiles);
    FMainForm.ConfigReloadNeeded;
  end;
end;

// ******************************************************************
// Fires off the reload all configs through Jaws
// ******************************************************************
procedure TJAWSManager.ReloadConfiguration;
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.RunFunction('ReloadAllConfigs');
end;

// ******************************************************************
// Send either data or event to Jaws
// ******************************************************************
procedure TJAWSManager.SendComponentData(WindowHandle: HWND;
  DataStatus: LongInt; Caption, Value, data, ControlType, State, Instructions,
  ItemInstructions: PChar);

// ******************************************************************
// Send to dispatcher
// ******************************************************************
  procedure SendRequestResponse;
  begin
    FMainForm.WriteData(VA508_REG_COMPONENT_CAPTION, Caption);
    FMainForm.WriteData(VA508_REG_COMPONENT_VALUE, Value);
    FMainForm.WriteData(VA508_REG_COMPONENT_CONTROL_TYPE, ControlType);
    FMainForm.WriteData(VA508_REG_COMPONENT_STATE, State);
    FMainForm.WriteData(VA508_REG_COMPONENT_INSTRUCTIONS, Instructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_ITEM_INSTRUCTIONS,
      ItemInstructions);
    FMainForm.WriteData(VA508_REG_COMPONENT_DATA_STATUS, IntToStr(DataStatus));
    FMainForm.PostData;
  end;

// ******************************************************************
// Run the change event through Jaws
// ******************************************************************
  procedure SendChangeEvent;
  var
    Event: WideString;
  begin
    Event := 'VA508ChangeEvent(' + IntToStr(WindowHandle) + ',' +
      IntToStr(DataStatus) + ',"' + StrPas(Caption) + '","' + StrPas(Value) +
      '","' + StrPas(ControlType) + '","' + StrPas(State) + '","' +
      StrPas(Instructions) + '","' + StrPas(ItemInstructions) + '"';
    if not assigned(JAWSAPI) then
      JAWSAPI := CoJawsApi.Create;
    JAWSAPI.RunFunction(Event)
  end;

begin
  if (data <> nil) and (Length(data) > 0) then
  begin
    Value := data;
    DataStatus := DataStatus AND DATA_MASK_DATA;
    DataStatus := DataStatus OR DATA_VALUE;
  end;
  if (DataStatus and DATA_CHANGE_EVENT) <> 0 then
  begin
    DataStatus := DataStatus AND DATA_MASK_CHANGE_EVENT;
    SendChangeEvent;
  end
  else
    SendRequestResponse;
end;

// ******************************************************************
// Display a certian error
// ******************************************************************
class procedure TJAWSManager.ShowError(ErrorNumber: Integer);
begin
  ShowError(ErrorNumber, []);
end;

// ******************************************************************
// Display a certian formated error
// ******************************************************************
class procedure TJAWSManager.ShowError(ErrorNumber: Integer;
  data: array of const);
var
  error: string;

begin
  if not JAWSErrorsShown[ErrorNumber] then
  begin
    error := JAWSErrorMessage[ErrorNumber];
    if Length(data) > 0 then
      error := Format(error, data);
    JAWSErrorsShown[ErrorNumber] := TRUE;
    if assigned(UserSplash) then
      UserSplash.ShowSystemError('JAWS Accessibility Component Error' + CRLF +
        PChar(error))
    else
      MessageBox(0, PChar(error), 'JAWS Accessibility Component Error',
        MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_TOPMOST);

  end;
end;

// ******************************************************************
// Clean up files and memory
// ******************************************************************
procedure TJAWSManager.ShutDown;
var
  i: Integer;
begin
  if FWasShutdown then
    Exit;
  if assigned(JAWSAPI) then
  begin
    try
      JAWSAPI := nil; // causes access violation
    except
    end;
  end;
  KillINIFiles(nil);
  if assigned(FMainForm) then
    FreeAndNil(FMainForm);
  FWasShutdown := TRUE;
  if assigned(FHiddenJaws) then
    FHiddenJaws.free;
  SetLength(JawsRecord, 0);
  for i := Low(ScriptFiles) to High(ScriptFiles) do
  begin
    SetLength(ScriptFiles[i].Add_To_Uses, 0);
    SetLength(ScriptFiles[i].Dependencies, 0);
  end;
  SetLength(ScriptFiles, 0);
end;

// ******************************************************************
// Say a specific string through Jaws
// ******************************************************************
procedure TJAWSManager.SpeakText(Text: PChar);
begin
  if not assigned(JAWSAPI) then
    JAWSAPI := CoJawsApi.Create;
  JAWSAPI.SayString(Text, FALSE);
end;

// ******************************************************************
// Ensure the hidden main window is created and recompile
// ******************************************************************
procedure TJAWSManager.EnsureWindow;
begin
  if not assigned(FMainForm) then
    FMainForm := TfrmVA508HiddenJawsMainWindow.Create(nil);
  FMainForm.ComponentDataCallBackProc := fComponentCallBackProc;
  FMainForm.ConfigReloadProc := ReloadConfiguration;
  FMainForm.HandleNeeded;
  Application.ProcessMessages;
end;

{$REGION '************************** Archived Method *************************'}
{
  class function TJAWSManager.GetPathFromJAWS(PathID: Integer;
  DoLowerCase: boolean = TRUE): string;
  const
  JAWS_MESSAGE_ID = 'JW_GET_FILE_PATH';
  // version is in directory after JAWS \Freedom Scientific\JAWS\*.*\...
  JAWS_PATH_ID_APPLICATION = 0;
  JAWS_PATH_ID_USER_SCRIPT_FILES = 1;
  JAWS_PATH_ID_JAWS_DEFAULT_SCRIPT_FILES = 2;
  // 0 = C:\Program Files\Freedom Scientific\JAWS\8.0\jfw.INI
  // 1 = D:\Documents and Settings\zzzzzzmerrij\Application Data\Freedom Scientific\JAWS\8.0\USER.INI
  // 2 = D:\Documents and Settings\All Users\Application Data\Freedom Scientific\JAWS\8.0\Settings\enu\DEFAULT.SBL
  var
  atm: ATOM;
  len: Integer;
  path: string;
  JAWSWindow: HWND;
  JAWSMsgID: UINT = 0;
  begin
  JAWSWindow := GetJAWSWindow;
  if JAWSMsgID = 0 then
  JAWSMsgID := RegisterWindowMessage(JAWS_MESSAGE_ID);
  Result := '';
  atm := SendMessage(JAWSWindow, JAWSMsgID, PathID, 0);
  if atm <> 0 then
  begin
  SetLength(path, MAX_PATH * 2);
  len := GlobalGetAtomName(atm, PChar(path), MAX_PATH * 2);
  GlobalDeleteAtom(atm);
  if len > 0 then
  begin
  SetLength(path, len);
  Result := ExtractFilePath(path);
  if DoLowerCase then
  Result := LowerCase(Result);
  end;
  end;
  end;
}
{$ENDREGION}
{$ENDREGION}
{ function tCompileFile.CompileFile(var RtnMsg: String): integer;
  begin
  result := ExecuteAndWait('"' + Compiler + '"', RtnMsg, '"' + FileName + '"');
  end; }

function tCompileFile.CompileFile(var RtnMsg: String): Boolean;
var
  RtnLst: TStringList;
begin
  RtnLst := TStringList.Create;
  try
    Result := RunSilentCmd(Compiler, FileName, RtnMsg);
    RtnLst.Text := RtnMsg;
    if RtnLst.Count > 1 then
      Result := FALSE;

  finally
    RtnLst.free;
  end;

end;

Function FindCommandSwitch(SwitchName: string; var ReturnValue: string)
  : Boolean;
begin
{$IFDEF VER180}
  Result := D2006FindCmdLineSwitch(SwitchName, ReturnValue, TRUE,
    [clstD2006ValueAppended]);
{$ELSE}
  Result := FindCmdLineSwitch(SwitchName, ReturnValue, TRUE,
    [clstValueAppended]);
{$ENDIF}
end;

Function FindCommandSwitch(SwitchName: string): Boolean;
begin
{$IFDEF VER180}
  Result := D2006FindCmdLineSwitch(SwitchName, ['-'], TRUE);
{$ELSE}
  Result := FindCmdLineSwitch(SwitchName, ['-'], TRUE);
{$ENDIF}
end;

initialization

LogInterface.Active := FindCommandSwitch('JL');

CoInitializeEx(nil, COINIT_APARTMENTTHREADED); // COINIT_MULTITHREADED);

Application.MainFormOnTaskbar := TRUE;

finalization

ShutDown;

CoUninitialize;

end.

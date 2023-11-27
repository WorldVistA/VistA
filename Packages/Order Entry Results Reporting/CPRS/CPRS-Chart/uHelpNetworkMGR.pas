unit uHelpNetworkMGR;

////////////////////////////////////////////////////////////////////////////////
///                                                                          ///
///                     WINDOWS HELP FILE FRAMEWORK                          ///
///                                                                          ///
///     -DESCRIPTION                                                         ///
///               Downloads Help file from "Thin" client directory           ///
///                 Can be downloaded via new thread if desired              ///
///               Ensures required MS update exist on the users machine      ///
///                 (if applicable)                                          ///
///                                                                          ///
///                                                                          ///
///     -IMPLEMNTATION                                                       ///
///          Two methods exist to  call this functionality                   ///
///         ******************  RECOMMENDED  ******************              ///
///      1) A background thread is created to seamlessly retrieve this file  ///
///         and save it to the Local appdata folder (under the current       ///
///         application name). A Check is also ran to verify that the user   ///
///         has the proper windows update (if applicable) to run HLP files.  ///
///                                                                          ///
///         ******************  OPTIONAL ******************                  ///
///      2) A foreground download can be fired that will retrieve the file   ///
///         showing the user the current download process and allowing them  ///
///         to abort the process at any time.                                ///
///                                                                          ///
////////////////////////////////////////////////////////////////////////////////


interface
{$WARN UNIT_PLATFORM OFF}

uses
  Classes,
  Messages,
  windows,
  sysutils,
  ShlObj,
  Forms,
  SHFolder,
  ComCtrls,
  StdCtrls,
  Dialogs,
  mmsystem,
  controls,
  ComObj,
  Variants,
  ShellAPI,
  Registry,
  ActiveX,
  Math,
  UResponsiveGUI;

type

  ///============= THREADS =============
  tHelpThread = class(TThread) //Used to run background job
  private
    fstrOriginalHelp: string;
    fInstanceCheck: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(OriginalHelp: string; InstanceCheck: Boolean);
    destructor Destroy; override;
  end;

  tRetrivalThread = class(TThread) //Used to retrieve the file
  private
    fSuccess: Boolean;
    fDone: Boolean;
    fTo: string;
    fFrom: string;
    fProgressBar: TProgressBar;
    fProgRoutine: Pointer;
    fAbort: PBOOL;
    fForm: TForm;
  protected
    procedure Execute; override;
  public
    constructor Create(Source, Destination: string; aProgressBar: TProgressBar; CallBack: Pointer; Canceled: PBOOL; AForm: TForm);
    destructor Destroy; override;
  end;

  ///============= INSTANCE TYPE =============
  EntryXp = packed record
    Session: LongWord; // 32 bit [0-3]
    TimesOpened: LongWord; // 32 bit [4-6] *Starts at 5
    LastOpenedDateTime: TFileTime; // 64 bit [7-15]
  end;

  Entry = packed record
    Unknown: LongWord; // 32 bit [0-3]
    TimesOpened: LongWord; //32 bit [4-7]  *Starts at 1
    FocusTime: LongWord; //32 bit [8-11]
    FocusUnknown: LongWord; //32 bit [12-15]
    FutureUse1: LongWord; //32 bit [16-19]
    FutureUse2: LongWord; //32 bit [20-23]
    FutureUse3: LongWord; //32 bit [24-27]
    FutureUse4: LongWord; //32 bit [28-31]
    FutureUse5: LongWord; //32 bit [32-35]
    FutureUse6: LongWord; //32 bit [36-39]
    FutureUse7: LongWord; //32 bit [40-43]
    FutureUse8: LongWord; //32 bit [44-47]
    FutureUse9: LongWord; //32 bit [48-51]
    FutureUse10: LongWord; //32 bit [52-55]
    Unknown2: LongWord; // 32 bit [56-59]
    LastOpenedDateTime: TFileTime; // 64 bits [60-67]
    Unknown3: LongWord; // 32 bit [68-71]
  end;

  PEntryXP = ^EntryXp;
  PEntry = ^Entry;
  TByteArray = array of byte;
  PByteArray = ^TByteArray;

  ///============= PUBLIC PROCEDURES =============
procedure LoadHelpFile(HelpFile: string; InstanceCheck: Boolean = false); //DL help and show progress
procedure LoadHelpFileBackGround(HelpFile: string; InstanceCheck: Boolean = false); //DL help in background thread

///============= PRIVATE FUNCTIONS =============
function LoadLocalHelp(OriginalHelpFile: string; var NewLocalHelpFile: string; ShowProgress: Boolean = True): Boolean; //DL's the help if needed
function DisplayProgress(Source, Destination: string): boolean; //Builds the display to the end user
function CopyFileWithProgressBar2(TotalFileSize, TotalBytesTransferred,
  StreamSize, StreamBytesTransferred: LARGE_INTEGER;
  dwStreamNumber, dwCallbackReason: DWORD; hSourceFile,
  hDestinationFile: THandle; lpData: Pointer): DWORD; stdcall; //Used to update the message box displayed to the user
function GetOperatingSystem: Integer; // Will return Version of OS
function ISHotFixID_Installed(const HotFixID: string): Boolean; // Used to determine if the given Microsoft Update is installed
function GetWinDir: string; // Returns Windows Directory
procedure HotFixError; //Generates showmsg regarding needed Windows Update.
function InstanceCount: Integer;

const
  wbemFlagForwardOnly = $00000020;
  wbemFlagReturnImmediately = $00000010;
  cOsUnknown = -1;
  cOsWin95 = 0;
  cOsWin98 = 1;
  cOsWin98SE = 2;
  cOsWinME = 3;
  cOsWinNT = 4;
  cOsWin2000 = 5;
  cOsXP = 6;
  cOSWin7 = 7;

var
  FCanceled: Boolean; //Allow the DL to be canceled
  aProgressLabel: TLabel; //Label that appears to the end user

  //Uncomment the line below to turn on the HotFix check
  // {$DEFINE HOTFIXCHK}

implementation

uses
  VAUtils;

///============= PUBLIC PROCEDURES =============


procedure LoadHelpFile(HelpFile: string; InstanceCheck: Boolean = false);
var
  LocalHelpFile: string;
  FilePath: string;
begin
  Screen.Cursor := crHourGlass;
  try

    //Need the patch
    FilePath := ExtractFilePath(HelpFile);
    if FilePath = '' then
      FilePath := ExtractFilePath(Application.ExeName);
    HelpFile := FilePath + ExtractFileName(HelpFile);
    //Process the download
    if (not LoadLocalHelp(HelpFile, LocalHelpFile)) and (not FCanceled) then

      case
        //There was an error and the user did not abort
      VAUtils.ShowMsg('Error while trying to open "Thin Client" help.',
        'Help File', smiWarning, smbAbortRetryCancel) of
        smrAbort, srmCancel:
          begin
            Application.HelpFile := '';
          end;
        smrRetry:
          begin
            LoadHelpFile(HelpFile);
          end;
      end
    else
    begin
      //file already exist or is local
      if not FCanceled then
        Application.HelpFile := LocalHelpFile;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure LoadHelpFileBackGround(HelpFile: string; InstanceCheck: Boolean = false);
var
  HelpThread: tHelpThread;
begin
  //Need the patch
  HelpFile := ExtractFilePath(HelpFile) + ExtractFileName(HelpFile);
  HelpThread := tHelpThread.Create(HelpFile, InstanceCheck);
  HelpThread.Start;
end;


///============= PRIVATE FUNCTIONS =============

function GetOperatingSystem: Integer;

var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  Result := cOsUnknown;
  { set operating system type flag }
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
  begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if majorVer <= 6 then
            Result := cOsWin7;
          if (majorVer = 4) or (majorVer = 5) then
            Result := cOsWinNT
          else
          begin
            if majorVer = 5 then
            begin
              if (majorVer = 5) and (minorVer = 0) then
                Result := cOsWin2000
              else
                if (majorVer = 5) and (minorVer = 1) then
                  Result := cOsXP
                else
                  Result := cOsUnknown;
            end;
          end;
        end;
      VER_PLATFORM_WIN32_WINDOWS: { Windows 9x/ME }
        begin
          if (majorVer = 4) and (minorVer = 0) then
            Result := cOsWin95
          else
            if (majorVer = 4) and (minorVer = 10) then
            begin
              if osVerInfo.szCSDVersion[1] = 'A' then
                Result := cOsWin98SE
              else
                Result := cOsWin98;
            end
            else
              if (majorVer = 4) and (minorVer = 90) then
                Result := cOsWinME
              else
                Result := cOsUnknown;
        end;
    else
      Result := cOsUnknown;
    end;
  end
  else
    Result := cOsUnknown;
end;

function ISHotFixID_Installed(const HotFixID: string): Boolean;
const
  wbemFlagForwardOnly = $00000020;
  wbemFlagReturnImmediately = $00000010;
var
  FSWbemLocator: OLEVariant;
  FWMIService: OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject: OLEVariant;
  oEnum: IEnumvariant;
  iValue: LongWord;
begin;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  FWbemObjectSet := FWMIService.ExecQuery(Format('SELECT * FROM Win32_QuickFixEngineering Where HotFixID="%s"', [HotFixID]), 'WQL', wbemFlagForwardOnly or wbemFlagReturnImmediately);
  oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  Result := oEnum.Next(1, FWbemObject, iValue) = 0;
end;

function GetWinDir: string;
var
  dir: array[0..MAX_PATH] of Char;
begin
  GetWindowsDirectory(dir, MAX_PATH);
  Result := StrPas(dir);
end;

procedure HotFixError;
begin
  VAUtils.ShowMsg('In order to view the Help Files for ' + Application.Title + ', you must install Windows Update KB917607.' + #13#10#13#10
    + 'Information about this update can be found at: http://support.microsoft.com/kb/917607' + #13#10#13#10
    + 'Please contact your local IT staff to install this update.', 'Attention');
end;

function LoadLocalHelp(OriginalHelpFile: string; var NewLocalHelpFile: string; ShowProgress: Boolean = True): Boolean;
var
  LocalOnly, AppDir: string;

  //Returns the size of a file
  function GetFileSize(const FileName: string): Cardinal;
  var
    SearchRec: TSearchRec;
  begin
    Result := 0;
    if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
      Result := SearchRec.Size;
  end;

  //Returns the file's date / time
  function getFileDateTime(const FileName: string): TDateTime;
  begin
    FileAge(FileName, result);
  end;

  //Finds the users special directory
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array[0..MaxChar] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  Result := False;
  try
    //Check if the file is not local to this machine
    if ((copy(OriginalHelpFile, 1, 2) = '\\') or (GetDriveType(PChar(ExtractFilePath(OriginalHelpFile))) = DRIVE_REMOTE)) then
    begin
      if FileExists(OriginalHelpFile) then
      begin
        //Set up the new local path for the file

        NewLocalHelpFile := LocalAppDataPath;
        if (copy(NewLocalHelpFile, length(NewLocalHelpFile), 1) <> '\') then
          NewLocalHelpFile := NewLocalHelpFile + '\';
        LocalOnly := NewLocalHelpFile;
        //Now set the application level
        NewLocalHelpFile := NewLocalHelpFile + Application.title;
        if (copy(NewLocalHelpFile, length(NewLocalHelpFile), 1) <> '\') then
          NewLocalHelpFile := NewLocalHelpFile + '\';
        AppDir := NewLocalHelpFile;

        //try to create or use base direcrtory
        if not DirectoryExists(AppDir) then
          if not ForceDirectories(AppDir) then
            NewLocalHelpFile := LocalOnly;

        NewLocalHelpFile := NewLocalHelpFile + extractFileName(OriginalHelpFile);

        //does the file exist or if so has it been updated
        result := FileExists(NewLocalHelpFile) and (getFileDateTime(OriginalHelpFile) = getFileDateTime(NewLocalHelpFile)) and (GetFileSize(OriginalHelpFile) = GetFileSize(NewLocalHelpFile));

        if ShowProgress then
        begin
          //show the user what were doing
          if not result then
          begin
            result := DisplayProgress(OriginalHelpFile, NewLocalHelpFile);
          end;
        end
        else
        begin
          //Background download
          if not result then
          begin
            result := Windows.CopyFile(PChar(OriginalHelpFile), PChar(NewLocalHelpFile), False);
            result := result and (getFileDateTime(OriginalHelpFile) = getFileDateTime(NewLocalHelpFile)) and (GetFileSize(OriginalHelpFile) = GetFileSize(NewLocalHelpFile));
          end;
        end;
      end;
    end
    else
    begin
      //file is already local
      NewLocalHelpFile := OriginalHelpFile;
      result := true;
    end;

  except
    Result := false;
  end;


end;

function DisplayProgress(Source, Destination: string): boolean;
var
  AMsgDialog: TForm;
  AProgressBar: TProgressBar;
  RetrivalThread: tRetrivalThread;

  //Fire off the copy process
  function CopyWithProgress(): Boolean;
  begin
    result := CopyFileEx(PChar(Source), PChar(Destination), @CopyFileWithProgressBar2,
      AProgressBar, @FCanceled, COPY_FILE_RESTARTABLE);
  end;

begin
  //Create the message dialog
  AMsgDialog := CreateMessageDialog('Retrieving help file for ' + Application.Title + #13 + 'Press "ABORT" to cancel this process', mtWarning, [mbAbort]);
  AMsgDialog.Caption := 'Downloading Help File';
  AMsgDialog.Height := 160;
  AMsgDialog.FormStyle := fsStayOnTop;

  //Progress bar
  AProgressBar := TProgressBar.Create(AMsgDialog);
  AProgressBar.Parent := AMsgDialog;
  AProgressBar.Align := alBottom;
  AProgressBar.Margins.Left := 8; //D2006 and up
  AProgressBar.Margins.Right := 8; //D2006 and up

  //Label
  aProgressLabel := TLabel.Create(AMsgDialog);
  aProgressLabel.Parent := AMsgDialog;
  aProgressLabel.Align := alBottom;
  aProgressLabel.Alignment := taCenter;
  aProgressLabel.Margins.Left := 8; //D2006 and up
  aProgressLabel.Margins.Right := 8; //D2006 and up

  //process the download
  RetrivalThread := tRetrivalThread.Create(Source, Destination, AProgressBar, @CopyFileWithProgressBar2, @FCanceled, AMsgDialog);
  RetrivalThread.Start;

  if AMsgDialog.ShowModal = mrAbort then
    FCanceled := true; //User canceled the dl
  Result := RetrivalThread.fSuccess;

  while not RetrivalThread.fDone do
    TResponsiveGUI.ProcessMessages(True);
  AMsgDialog.Free;
end;

function InstanceCount: Integer;
const
  myKey = 'Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist';
var
  reg: TRegistry;
  DataSize: LongWord;
  ValueName, Rot13Coded: string;
  i, X: integer;
  e: Entry;
  eXP: EntryXp;
  Tab: TByteArray;
  SubKeyNames, ValueNames: TStringList;
  LoopKey: string;
  SysTime: TSystemTime;
  TimeZone: TTimeZoneInformation;

  function Rot13(Str: string): string;
  const
    OrdBigA = Ord('A');
    OrdBigZ = Ord('Z');
    OrdSmlA = Ord('a');
    OrdSmlZ = Ord('z');
  var
    i, o: integer;
  begin
    for i := 1 to length(Str) do
    begin
      o := Ord(Str[i]);
      if InRange(o, OrdBigA, OrdBigZ) then
        Str[i] := Chr(OrdBigA + (o - OrdBigA + 13) mod 26)
      else if InRange(o, OrdSmlA, OrdSmlZ) then
        Str[i] := Chr(OrdSmlA + (o - OrdSmlA + 13) mod 26);
    end;
    Result := Str;
  end;

begin
  Result := 0;
  try
    //Code the application
    Rot13Coded := Rot13('\' + ExtractFileName(Application.ExeName));

    SubKeyNames := TStringList.Create;
    ValueNames := TStringList.Create;
    try

      //Look to the registry
      reg := TRegistry.Create;
      try
        //Open the main branch
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKeyReadOnly(mykey);
        //Get all the possible sub keys
        reg.GetKeyNames(SubKeyNames);

        //Close the current key
        Reg.CloseKey;

        //set the value key
        ValueName := Rot13Coded;

        //Lets loop though the sub keys
        for x := 0 to SubKeyNames.Count - 1 do begin
          //look for our key
          LoopKey := MyKey + '\' + SubKeyNames[x] + '\Count';
          if reg.KeyExists(LoopKey) then begin
            //Open the key up
            reg.OpenKeyReadOnly(LoopKey);

            reg.GetValueNames(ValueNames);

            for I := 0 to ValueNames.Count - 1 do begin
              if Pos(UpperCase(ValueName), UpperCase(ValueNames[i])) > 0 then begin

                //Get the size then set it
                DataSize := reg.GetDataSize(ValueNames[i]);
                // If DataSize > 72 then Continue;
                SetLength(Tab, DataSize);
                //Read the binary for this application
                Reg.ReadBinaryData(ValueNames[i], Tab[0], DataSize);

                if GetOperatingSystem = cOSWin7 then begin
                  //Add to the record
                  e := PEntry(PByteArray(tab))^;
                  FileTimeToSystemTime(e.LastOpenedDateTime, SysTime);
                  GetTimeZoneInformation(TimeZone);
                  SystemTimeToTzSpecificLocalTime(@TimeZone, SysTime, SysTime);
                  if (e.TimesOpened > 1) and (FormatDateTime('mm/dd/yyyy', Now) = FormatDateTime('mm/dd/yyyy', SystemTimeToDateTime(SysTime))) then
                    Inc(Result);
                end else if GetOperatingSystem = cOsXP then begin
                  eXP := PEntryXP(PByteArray(tab))^;
                  FileTimeToSystemTime(eXP.LastOpenedDateTime, SysTime);
                  GetTimeZoneInformation(TimeZone);
                  SystemTimeToTzSpecificLocalTime(@TimeZone, SysTime, SysTime);
                  if (eXP.TimesOpened > 6) and (FormatDateTime('mm/dd/yyyy', Now) = FormatDateTime('mm/dd/yyyy', SystemTimeToDateTime(SysTime))) then
                    Inc(Result);
                end;

                Tab := nil;
              end;
            end;
          end;
          //Close the key
          Reg.CloseKey;
        end;
      finally
        reg.Free;
      end;
    finally
      ValueNames.free;
      SubKeyNames.Free;
    end;
  except
    //an error occured
    Result := 0;
  end;
end;

///============= HELP THREAD =============

constructor tHelpThread.Create(OriginalHelp: string; InstanceCheck: Boolean);
begin
  inherited Create(True);
  fstrOriginalHelp := OriginalHelp;
  fInstanceCheck := InstanceCheck;
  FreeOnTerminate := True;
end;

destructor tHelpThread.Destroy;
begin
  inherited;
  CoUninitialize;
end;

procedure tHelpThread.Execute;
var
  LocalHelpFile: string;
begin
  if Terminated then
    Exit;

  CoInitialize(nil);
  if LoadLocalHelp(fstrOriginalHelp, LocalHelpFile, false) then
    Application.HelpFile := LocalHelpFile;

  Sleep(Random(100));
end;

///============= CALL BACK =============

function CopyFileWithProgressBar2(TotalFileSize, TotalBytesTransferred,
  StreamSize, StreamBytesTransferred: LARGE_INTEGER;
  dwStreamNumber, dwCallbackReason: DWORD; hSourceFile, hDestinationFile: THandle;
  lpData: Pointer): DWORD; stdcall;

  function FormatByteSize(const bytes: Longint): string;
  const
    B = 1; //byte
    KB = 1024 * B; //kilobyte
    MB = 1024 * KB; //megabyte
    GB = 1024 * MB; //gigabyte
  begin
    if bytes > GB then
      result := FormatFloat('#.## GB', bytes / GB)
    else if bytes > MB then
      result := FormatFloat('#.## MB', bytes / MB)
    else if bytes > KB then
      result := FormatFloat('#.## KB', bytes / KB)
    else
      result := FormatFloat('#.## bytes', bytes);
  end;

begin
  if not FCanceled then begin
    //Set the max progress bar
    if dwCallbackReason = CALLBACK_STREAM_SWITCH then
      TProgressBar(lpData).Max := TotalFileSize.QuadPart;

    //set the potion progress bar
    TProgressBar(lpData).Position := TotalBytesTransferred.QuadPart;

    //set the label
    aProgressLabel.Caption := FormatByteSize(TotalBytesTransferred.QuadPart) + ' out of ' + FormatByteSize(TotalFileSize.QuadPart);

    //Let the copy continue
    Result := PROGRESS_CONTINUE;
  end else
   Result := PROGRESS_CANCEL;
end;

///============= RETRIEVAL THREAD =============

constructor tRetrivalThread.Create(Source, Destination: string; aProgressBar: TProgressBar; CallBack: Pointer; Canceled: PBOOL; AForm: TForm);
begin
  inherited Create(True);
  fSuccess := false;
  fDone := false;
  fTo := Destination;
  fFrom := Source;
  fProgressBar := aProgressBar;
  fProgRoutine := CallBack;
  fAbort := Canceled;
  fForm := AForm;
  FreeOnTerminate := True;
end;

destructor tRetrivalThread.Destroy;

begin
  inherited;
  fDone := true;
  if not Boolean(fAbort^) then begin
    fForm.Perform(WM_CLOSE, 0, 0);
    fForm.ModalResult := mrOk;
  end;
end;

procedure tRetrivalThread.Execute;
begin
  if Terminated then
    Exit;

  fSuccess := CopyFileEx(PChar(FFrom), PChar(fTo), fProgRoutine,
    fProgressBar, fAbort, COPY_FILE_RESTARTABLE);

  Sleep(Random(100));
end;

end.

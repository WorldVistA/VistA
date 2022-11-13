{ ******************************************************************************
  *
  * AV Catcher
  *
  * Description
  *      Log the Access violation to a log file and allow the user to copy
  *      the information into an email if needed.
  *
  *
  *
  *
  * ****************************************************************************** }

unit AVCatcher;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.ImageList,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  Vcl.Imaging.pngimage;

type
  TAppExcept = class(TForm)
    ImageList1: TImageList;
    pnlBottom: TPanel;
    btnLogFile: TButton;
    btnLogEMail: TButton;
    pnlTop: TPanel;
    imgAV: TImage;
    lblAVHeading: TLabel;
    lblAVText: TLabel;
    PnlDetailsMsg: TPanel;
    lblDeatailTxt1: TLabel;
    lblDeatailTxt2: TLabel;
    pnlDetails: TPanel;
    LogDetails: TMemo;
    btnClose: TButton;
    pnlBtns: TGridPanel;
    btnCustom: TButton;
    procedure lblDeatailTxt1Click(Sender: TObject);
    procedure LogDetailsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLogEMailClick(Sender: TObject);
  private
    Function CalcWidthResize(): Integer;
  public
    constructor CreateForm(AOwner: TComponent; aException: Exception);
  end;

  TAppException = procedure(Sender: TObject; E: Exception) of object;

  TExceptionLogger = class(TObject)
  private
    fErrLogString: TStringList;
    fAppException: TAppException;
    fAfterAppException: TAppException;
    FOnBtnCustomClick: TNotifyEvent;
    FBtnCustomCaption: string;
    FAVLogFile: string; // Log file for the AV info
    fEmailTo: TStringList;
    fEnabled: Boolean;
    fDaysToPurge: Integer;
    fVisible: Boolean;
    fTerminateApp: Boolean;
    fParsing: boolean;
    fExceptObj: Exception;
    procedure WaitForParsing;
    procedure AppException(Sender: TObject; E: Exception);
    // Inital way to call code
    procedure CatchException(Sender: TObject; E: Exception);
    // Creates blank email with log information in body
    procedure EmailError(LogMessage: String);
    // Sets up the log file for the AppData folder
    function GetLogFileName: string;
    // Writes error to log file (creates new files if needed)
    procedure LogError(LogMessage: string);
    function RightPad(S: string; ch: char; Len: Integer): string;
    // Purges log files based on DaysToPurge const
    Function ThePurge: String;
    procedure StartParsing(AException: Exception; AParseResult: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    property BtnCustomCaption: string read FBtnCustomCaption
      write FBtnCustomCaption;
    property AVLogFile: string read GetLogFileName write FAVLogFile;
    property TerminateApp: Boolean read fTerminateApp write fTerminateApp;
    property DaysToPurge: Integer read fDaysToPurge write fDaysToPurge;
    property Enabled: Boolean read fEnabled write fEnabled;
    property Visible: Boolean read FVisible write FVisible;
    property EmailTo: TStringList read fEmailTo;
    property OnBtnCustomClick: TNotifyEvent read FOnBtnCustomClick
      write FOnBtnCustomClick;
    property OnAppException: TAppException read fAppException
      write fAppException;
    property OnAfterAppException: TAppException read fAfterAppException
      write fAfterAppException;
  end;

var
  ExceptionLog: TExceptionLogger;

implementation

uses
  Winapi.SHFolder,
  Winapi.ShellAPI,
  System.StrUtils,
  System.Types,
  Vcl.Dialogs,
  Vcl.Graphics,
  IdURI,
  UExceptHook,
  uMapParser;


{$R *.dfm}

{$REGION' CRC'}
const
{ copied from ORFn - table for calculating CRC values }
  CRC32_TABLE: array[0..255] of DWORD =
    ($0,       $77073096, $EE0E612C, $990951BA, $76DC419,  $706AF48F, $E963A535, $9E6495A3,
    $EDB8832,  $79DCB8A4, $E0D5E91E, $97D2D988, $9B64C2B,  $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $1DB7106,  $98D220BC, $EFD5102A, $71B18589, $6B6B51F,  $9FBFE4A5, $E8B8D433,
    $7807C9A2, $F00F934,  $9609A88E, $E10E9818, $7F6A0DBB, $86D3D2D,  $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $3B6E20C,  $74B1D29A, $EAD54739, $9DD277AF, $4DB2615,  $73DC1683,
    $E3630B12, $94643B84, $D6D6A3E,  $7A6A5AA8, $E40ECF0B, $9309FF9D, $A00AE27,  $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $26D930A,  $9C0906A9, $EB0E363F, $72076785, $5005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $CB61B38,  $92D28E9B, $E5D5BE0D, $7CDCEFB7, $BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

{ returns a cyclic redundancy check for a string }

function UpdateCrc32(Value: DWORD; var Buffer: array of Byte; Count: Integer): DWORD;
var
 i: integer;
begin
 Result:=Value;
 for i := 0 to Pred(Count) do
   Result := ((Result shr 8) and $00FFFFFF) xor
     CRC32_TABLE[(Result xor Buffer[i]) and $000000FF];
end;

function CRCForFile(AFileName: string): DWORD;
const
 BUF_SIZE = 16383;
type
 TBuffer = array[0..BUF_SIZE] of Byte;
var
 Buffer: Pointer;
 AHandle, BytesRead: Integer;
begin
 Result:=$FFFFFFFF;
 GetMem(Buffer, BUF_SIZE);
 AHandle := FileOpen(AFileName, fmShareDenyWrite);
 repeat
  BytesRead := FileRead(AHandle, Buffer^, BUF_SIZE);
  Result := UpdateCrc32(Result, TBuffer(Buffer^), BytesRead);
 until BytesRead <> BUF_SIZE;
 FileClose(AHandle);
 FreeMem(Buffer);
 Result := not Result;
end;

{$ENDREGION}
{$REGION 'TAppExceptThread'}

type
  TAppExceptThread = class(TThread)
  private
    FExceptionLogger: TExceptionLogger;
    fE: Exception;
    FParseResult: TStrings;
  protected
    procedure Execute; override;
  public
    constructor Create(AExceptionLogger: TExceptionLogger; aException: Exception; AParseResult: TStrings); overload;
    destructor Destroy; override;
  end;

constructor TAppExceptThread.Create(AExceptionLogger: TExceptionLogger;
  AException: Exception; AParseResult: TStrings);
begin
  FExceptionLogger := AExceptionLogger;
  FExceptionLogger.fParsing := True;
  fE := AException;
  FParseResult := AParseResult;
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TAppExceptThread.Destroy;
begin
  if Assigned(FExceptionLogger) then
    Synchronize(
      procedure
      begin
        FExceptionLogger.fParsing := False;
      end);
  inherited;
end;

procedure TAppExceptThread.Execute;

  function GetAppVersionStr: string;
  var
    Exe: string;
    Size, Handle: DWORD;
    Buffer: TBytes;
    FixedPtr: PVSFixedFileInfo;
  begin
    Exe := ParamStr(0);
    Size := GetFileVersionInfoSize(PChar(Exe), Handle);
    if Size = 0 then RaiseLastOSError;
    SetLength(Buffer, Size);
    if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
      RaiseLastOSError;
    if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
      RaiseLastOSError;
    Result := Format('%d.%d.%d.%d', [
      LongRec(FixedPtr.dwFileVersionMS).Hi, // major
      LongRec(FixedPtr.dwFileVersionMS).Lo, // minor
      LongRec(FixedPtr.dwFileVersionLS).Hi, // release
      LongRec(FixedPtr.dwFileVersionLS).Lo]); // build
  end;

  procedure GatherStackInfo(var OutList: TStringList);
  const
    MAX_STACK_LENGTH = 50; // How many stack addresses do we map
    NoMapFormat = '[%p]';
    StackFormat = '[%p] %s (Line %s, "%s")';
  var
    P: Pointer;
    aUnit, aMethod, aLine: string;
    AStack: TStack;
    Parser: TMapParser;
    CurrentLevel: Integer;
  begin
    if not Assigned(OutList) then Exit;
    with ExceptionLog do
    begin
      fExceptObj := fe;
      OutList.Add(StringOfChar(' ', 15) + 'Application Information');
      OutList.Add(RightPad('', '=', 50));
      OutList.Add(RightPad('Name', ' ', 10) + ': ' + ExtractFileName(Application.ExeName));
      OutList.Add(RightPad('Version', ' ', 10) + ': ' + GetAppVersionStr);
      OutList.Add(RightPad('CRC', ' ', 10) + ': ' + IntToHex(CRCForFile(Application.ExeName), 8));
      OutList.Add('');
      OutList.Add(StringOfChar(' ', 15) + 'Error Information');
      OutList.Add(RightPad('', '=', 50));
      OutList.Add(RightPad('Date/Time', ' ', 10) + ': ' + FormatDateTime('mm/dd/yyyy hh:mm:ss', now()));
      OutList.Add(RightPad('Unit', ' ', 10) + ': ' + fE.UnitName);
      OutList.Add(RightPad('Class', ' ', 10) + ': ' + fE.ClassName);
      OutList.Add(RightPad('Message', ' ', 10) + ': ' + fE.Message);
      if fE.ToString <> fE.Message then OutList.Add(RightPad('Text', ' ', 10) + ': ' + fE.ToString);
      OutList.Add('');
      OutList.Add(StringOfChar(' ', 15) + 'Error Trace');
      OutList.Add(RightPad('', '=', 50));

      AStack := TStack(fE.StackInfo);
      if Assigned(AStack) then
      begin
        CurrentLevel := 0;
        Parser := tMapParser.Create; // slightly faster than threaded version
        try
          for P in AStack do
          begin
            if CurrentLevel >= MAX_STACK_LENGTH then Break;
            if not Parser.MapLoaded then
            begin
              OutList.Add(Format(NoMapFormat, [P]));
              Inc(CurrentLevel);
            end else begin
              Parser.LookupInMap(LongWord(P), aUnit, aMethod, aLine);
              if (aUnit <> 'NA') then begin
                OutList.Add(Format(StackFormat, [P, aMethod, aLine, aUnit]));
                Inc(CurrentLevel);
              end;
            end;
          end;
        finally
          Parser.Free;
        end;
      end;
    end;
  end;

var
  AStackInfo: TStringList;
begin
  try
    inherited;
    AStackInfo := TStringList.Create;
    try
      if Assigned(FExceptionLogger) and Assigned(fE) then
        GatherStackInfo(AStackInfo); // Can't use ExceptionLog.fErrLogString directly on the thread without synchronize!!!
      if Assigned(FExceptionLogger) then
        Synchronize(
          procedure
          begin
            FExceptionLogger.fErrLogString.Text := AStackInfo.Text;
            if Assigned(FParseResult) then FParseResult.Text := AStackInfo.Text;
          end);
    finally
      FreeAndNil(AStackInfo)
    end;
  except
    // swallow
  end;
end;

{$ENDREGION}
{$REGION' TExceptionLogger'}

// ==============================================================================
// DaysToPurge defines how long a log file can exist on the system. If/when a
// new exception happens all files older than the purge days will be deleted.
// ==============================================================================
constructor TExceptionLogger.Create;
begin
  inherited;
  fDaysToPurge := 60;
  fEnabled := True;
  fEmailTo := TStringList.Create;
  fVisible := true;
  fTerminateApp := false;
  fErrLogString := TStringList.Create;
  Application.OnException := AppException;
end;

destructor TExceptionLogger.Destroy();
begin
  FreeAndNil(fErrLogString);
  FreeAndNil(fEmailTo);
  inherited;
end;

procedure TExceptionLogger.AppException(Sender: TObject; E: Exception);
begin
  if Assigned(fAppException) then
    fAppException(Sender, E);

  if fEnabled then
    CatchException(Sender, E)
  else
    Application.ShowException(E);

  if assigned(fAfterAppException) and fEnabled then
    fAfterAppException(Sender, E);
  if fTerminateApp and (not Application.Terminated) then
    Application.Terminate;
end;

procedure TExceptionLogger.CatchException(Sender: TObject; E: Exception);
var
  AExceptionForm: TAppExcept;
begin
  fErrLogString.Clear;
  try
    try
      AExceptionForm := TAppExcept.CreateForm(Application, E);
      try
        AExceptionForm.ShowModal;
        Screen.Cursor := crHourGlass;
        try
          WaitForParsing;
          LogError(fErrLogString.Text);
          //Log to email
          if fVisible and
            (AExceptionForm.ModalResult = mrNo) then
            EmailError(fErrLogString.Text);
        finally
          Screen.Cursor := crDefault;
        end;
      finally
        if Assigned(AExceptionForm) then
          AExceptionForm.Free;
      end;
    except
      // swallow
    end;
  finally
    fErrLogString.Clear;
  end;
end;

function TExceptionLogger.GetLogFileName: string;
var
  OurLogFile, LocalOnly, AppDir, AppName: string;

  // Finds the users special directory
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MAX_PATH] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  if Trim(FAVLogFile) <> '' then
    Result := FAVLogFile
  else
  begin
    OurLogFile := LocalAppDataPath;
    if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
      OurLogFile := OurLogFile + '\';

    LocalOnly := OurLogFile;

    // Now set the application level
    OurLogFile := OurLogFile + ExtractFileName(Application.ExeName);
    if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
      OurLogFile := OurLogFile + '\';
    AppDir := OurLogFile;

    // try to create or use base direcrtory
    if not DirectoryExists(AppDir) then
      if not ForceDirectories(AppDir) then
        OurLogFile := LocalOnly;

    // Get the application name
    AppName := ExtractFileName(Application.ExeName);
    AppName := Copy(AppName, 0, Pos('.', AppName) - 1);

    OurLogFile := OurLogFile + AppName + '_' + IntToStr(GetCurrentProcessID) +
      '_' + FormatDateTime('mm_dd_yy_hh_mm', now) + '_LOG.TXT';

    FAVLogFile := OurLogFile;
    Result := OurLogFile;
  end;
end;

procedure TExceptionLogger.StartParsing(AException: Exception;
  AParseResult: TStrings);
begin
  TAppExceptThread.Create(Self, aException, AParseResult);
end;

Function TExceptionLogger.ThePurge(): String;
const
  aFileMask = '*_LOG.txt';
var
  searchResult: TSearchRec;
  iDelCnt, iErrorCnt, iFile: Integer;
  dtFileDate, dtNow: TDateTime;
  sFilePath: string;
begin
  // Init variables
  iDelCnt := 0;
  iErrorCnt := 0;
  dtNow := Date;
  sFilePath := ExtractFilePath(AVLogFile);

  // Loop through dir looking for the files
  iFile := FindFirst(sFilePath + aFileMask, faAnyFile, searchResult);
  while iFile = 0 do
  begin
    // Make sure we are on a file and not a directory
    if (searchResult.Name <> '.') and (searchResult.Name <> '..') and
      ((searchResult.Attr and faDirectory) <> faDirectory) then
    begin
      // Check the date of the file
      dtFileDate := searchResult.TimeStamp;
      if trunc(dtNow - dtFileDate) + 1 > fDaysToPurge then
      begin
        // Try to delete and update the count as needed
        if not DeleteFile(sFilePath + searchResult.Name) then
          Inc(iErrorCnt)
        else
          Inc(iDelCnt);
      end;
    end;
    // Grab the next file
    iFile := FindNext(searchResult);
  end;
  // Free up memory allocation
  FindClose(searchResult);

  // If any files were purged or errored then add this to the return message
  if (iErrorCnt > 0) or (iDelCnt > 0) then
  begin
    Result := (StringOfChar(' ', 15) + 'Log Purge Information');
    Result := Result + #13#10 + (RightPad('', '=', 50));
    Result := Result + #13#10 + (RightPad('Days:', ' ', 10) + ': ' +
      IntToStr(fDaysToPurge));
    Result := Result + #13#10 + (RightPad('Purged', ' ', 10) + ': ' +
      IntToStr(iDelCnt));
    Result := Result + #13#10 + (RightPad('NA', ' ', 10) + ': ' +
      IntToStr(iErrorCnt));
    Result := Result + #13#10 + #13#10;
  end
  else
    Result := '';
end;

procedure TExceptionLogger.WaitForParsing;
var
  cr: TCursor;
begin
  if fParsing then
  begin
    cr := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      while fParsing do
      begin
        Sleep(100);
        Application.ProcessMessages;
      end;
    finally
      Screen.Cursor := cr;
    end;
  end;
end;

procedure TExceptionLogger.LogError(LogMessage: string);
var
  myFile: TextFile;
begin
  // Clean the old dir on first run
  if Trim(FAVLogFile) = '' then
    LogMessage := ThePurge + LogMessage;

  // Asign our file
  AssignFile(myFile, AVLogFile);
  if FileExists(AVLogFile) then
    Append(myFile)
  else
    ReWrite(myFile);

  // Write this final line
  WriteLn(myFile, LogMessage);

  CloseFile(myFile);

  // Old code that would open file explorer to the log directory
  { if MessageDlg('Error logged, do you wish to navigate to the file?',
    mtInformation, [mbYes, mbNo], -1) = mrYes then
    ShellExecute(0, nil, 'explorer.exe', PChar('/select,' + CPRS_LogFileName),
    nil, SW_SHOWNORMAL); }
end;

Procedure TExceptionLogger.EmailError(LogMessage: string);
var
  EmailUsrs, TmpStr: string;

  function EncodeURIComponent(const ASrc: string): string;
  const
    HexMap: string = '0123456789ABCDEF';

    function IsSafeChar(ch: Byte): Boolean;
    begin
      if (ch >= 48) and (ch <= 57) then
        Result := True // 0-9
      else if (ch >= 65) and (ch <= 90) then
        Result := True // A-Z
      else if (ch >= 97) and (ch <= 122) then
        Result := True // a-z
      else if (ch = 33) then
        Result := True // !
      else if (ch >= 39) and (ch <= 42) then
        Result := True // '()*
      else if (ch >= 45) and (ch <= 46) then
        Result := True // -.
      else if (ch = 95) then
        Result := True // _
      else if (ch = 126) then
        Result := True // ~
      else
        Result := False;
    end;

  var
    I, J: Integer;
    Bytes: TBytes;
  begin
    Result := '';

    Bytes := TEncoding.UTF8.GetBytes(ASrc);

    I := 0;
    J := Low(Result);

    SetLength(Result, Length(Bytes) * 3); // space to %xx encode every byte

    while I < Length(Bytes) do
    begin
      if IsSafeChar(Bytes[I]) then
      begin
        Result[J] := char(Bytes[I]);
        Inc(J);
      end
      else
      begin
        Result[J] := '%';
        Result[J + 1] := HexMap[(Bytes[I] shr 4) + Low(ASrc)];
        Result[J + 2] := HexMap[(Bytes[I] and 15) + Low(ASrc)];
        Inc(J, 3);
      end;
      Inc(I);
    end;

    SetLength(Result, J - Low(ASrc));
  end;

  procedure SendMail(Subject, Body, RecvAddress, Attachs: string);
  const
    cEmailError = 'An error occured trying to generate the email. Please copy '
      + 'the data from the details section and manually send to %s';
    cCRLF = #13#10;
  var
    stringlist, AttachmentStr: TStringList;
    EMailStr: PWideChar;
    S: String;
  begin
    stringlist := TStringList.Create;
    try

      stringlist.Add('mailto:' + RecvAddress);
      stringlist.Add('?Subject=' + TIdURI.ParamsEncode(Subject));
      stringlist.Add('&Body=' + TIdURI.ParamsEncode(Body));

      if Attachs <> '' then
      begin
        AttachmentStr := TStringList.Create;
        try
          AttachmentStr.LoadFromFile(Attachs);
          if CompareText(StringReplace(Body, cCRLF, '', [rfReplaceAll]),
            StringReplace(AttachmentStr.Text, cCRLF, '', [rfReplaceAll])) <> 0
          then
          begin
            S := cCRLF + RightPad('', 'X', 50) + cCRLF + StringOfChar(' ', 15) +
              'Session Errors' + cCRLF + RightPad('', 'X', 50) + cCRLF + cCRLF;
            AttachmentStr.Insert(0, S);
            stringlist.Add(TIdURI.ParamsEncode(AttachmentStr.Text));
          end;
        finally
          AttachmentStr.Free;
        end;
      end;

      GetMem(EMailStr, (Length(stringlist.Text) + 1) * SizeOf(WideChar));
      try
        StringToWideChar(stringlist.Text, EMailStr,
          Length(stringlist.Text) + 1);
        if ShellExecute(Application.Handle, nil, EMailStr, nil, nil,
          SW_NORMAL) <= 0 then
          ShowMessage(Format(cEmailError, [RecvAddress]));
      finally
        FreeMem(EMailStr);
      end;

    finally
      stringlist.Free;
    end;
  end;

  function SetEmailSubject: String;
  Const
    mMsgLookup = 'M  ERROR=';
  var
    StrtPos, EndPos: Integer;
    ErrStr: String;
    AStack: TStack;
  begin
    if not Assigned(fExceptObj) then
      Exit;

    Result := fExceptObj.UnitName + '.' + fExceptObj.ClassName;
    ErrStr := '';
    if Trim(fExceptObj.ClassName) = 'EBrokerError' then
    begin
      StrtPos := Pos(mMsgLookup, fExceptObj.Message);
      if StrtPos > -1 then
      begin
        StrtPos := StrtPos + Length(mMsgLookup);
        EndPos := PosEx(#13, fExceptObj.Message, StrtPos) - StrtPos;
        ErrStr := Copy(fExceptObj.Message, StrtPos, EndPos);
        Result := Result + '[{' + ErrStr + '}]';
      end;
    end
    else
    begin
      try
        if Assigned(fExceptObj.StackInfo) and
          (TObject(fExceptObj.StackInfo) is TStack) then
        begin
          AStack := TStack(fExceptObj.StackInfo);
          if AStack.Count > 0 then
            ErrStr := Format('[%p]', [AStack.First]);
        end;
      except
        raise Exception.Create('StackInfo is not of expected type');
      end;

      Result := Result + ErrStr;
    end;
  end;

begin

  // Need to figure out the ole object method
  // fEmailTo.Delimiter := ';';
  EmailUsrs := '';
  for TmpStr in fEmailTo do
  begin
    if (EmailUsrs <> '') then
      EmailUsrs := EmailUsrs + '; ';
    EmailUsrs := EmailUsrs + TmpStr;
  end;
  SendMail(ExtractFileName(Application.ExeName) +' Error logged - ' + SetEmailSubject,
    LogMessage, EmailUsrs, AVLogFile);

end;

function TExceptionLogger.RightPad(S: string; ch: char; Len: Integer): string;
var
  RestLen: Integer;
begin
  Result := S;
  RestLen := Len - Length(S);
  if RestLen < 1 then
    exit;
  Result := S + StringOfChar(ch, RestLen);
end;

{$ENDREGION}
{$REGION 'TAppExcept'}

constructor TAppExcept.CreateForm(AOwner: TComponent; aException: Exception);
begin
  inherited Create(AOwner);
  with ExceptionLog do
  begin
    if fEmailTo.Count = 0 then
      pnlBtns.ColumnCollection[2].Value := 0
    else
      pnlBtns.ColumnCollection[2].Value := 25;
    pnlBtns.UpdateControlsColumn(2);

    if Assigned(FOnBtnCustomClick) then
    begin
      pnlBtns.ColumnCollection[3].Value := 25;
      btnCustom.Visible := true;
      btnCustom.Caption := FBtnCustomCaption;
      btnCustom.OnClick := FOnBtnCustomClick;
    end
    else
    begin
     pnlBtns.ColumnCollection[3].Value := 0;
     btnCustom.Visible := false;
    end;
    pnlBtns.UpdateControlsColumn(3);

    lblAVText.Caption := aException.Message;
    StartParsing(aException, LogDetails.Lines);
  end;
end;

procedure TAppExcept.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
end;

procedure TAppExcept.lblDeatailTxt1Click(Sender: TObject);
var
  NewWidth: Integer;
begin
  ExceptionLog.WaitForParsing;
  Self.AutoSize := False;
  try
    NewWidth := CalcWidthResize;
    //Ensure that the width and height dont go past the screen
    if Screen.DesktopWidth > (Self.Width + NewWidth) then
      Self.Width := Self.Width + NewWidth;
    if screen.DesktopHeight < (Self.Height) then
      Self.Height := Screen.DesktopHeight;
  finally
    Self.AutoSize := True;
  end;
  pnlDetails.Visible := True;
end;

procedure TAppExcept.LogDetailsChange(Sender: TObject);
var
  RemainingArea, RequestNewHeigh: Integer;
begin
  RemainingArea := (Screen.WorkAreaHeight - LogDetails.ClientToScreen(Point(0,
    0)).y) - (pnlBtns.Height + 30);
  RequestNewHeigh := LogDetails.Font.Size - 4 + (LogDetails.Lines.Count + 2) *
    -1 * (LogDetails.Font.Height - 3);

  if RequestNewHeigh > RemainingArea then
    pnlDetails.Height := RemainingArea
  else
    pnlDetails.Height := RequestNewHeigh;
end;

procedure TAppExcept.btnLogEMailClick(Sender: TObject);
begin
  // This ensures that parsing is done before the modal result is returned
  ExceptionLog.WaitForParsing;
end;

Function TAppExcept.CalcWidthResize(): Integer;
var
  DC: HDC;
  CacheFont : HFont;
  I, LineCharCnt, LongLineIDX: Integer;
  LngLineText: String;
  TextSize: TSize;
begin
  DC := GetDC(Logdetails.Handle);
  try
    CacheFont := SelectObject(DC, Logdetails.Font.Handle);
    try
      LngLineText := '';
      LongLineIDX := -1;
      LineCharCnt := 0;
      LngLineText := '';
      for I := 0 to Logdetails.Lines.Count - 0 do
      begin
        if Length(LogDetails.Lines[i]) > LineCharCnt then
        begin
          LineCharCnt := Length(LogDetails.Lines[i]);
          LongLineIDX := I;
        end;
      end;
      LngLineText := LogDetails.Lines[LongLineIDX];

      GetTextExtentPoint32(DC, PChar(LngLineText), Length(LngLineText), TextSize);
      Result := TextSize.cx  - (self.Width) + 100;
    finally
      SelectObject(DC, CacheFont);
    end;
  finally
    ReleaseDC(Logdetails.Handle, DC);
  end;
end;

{$ENDREGION}

initialization
  ExceptionLog := TExceptionLogger.Create;
  StartExceptionStackMonitoring;
finalization
  StopExceptionStackMonitoring;
  FreeAndNil(ExceptionLog);
end.

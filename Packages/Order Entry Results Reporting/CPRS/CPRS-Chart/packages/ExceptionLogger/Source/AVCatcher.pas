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
  ****************************************************************************** }

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
  Vcl.Imaging.pngimage,
  System.JSON.Types,
  System.JSON.Writers,
  System.JSON.Builders,
  System.Generics.Collections,
  uMapParser,
  uModuleParser,
  UExceptHook,
  VA508AccessibilityManager;

type
  Exception = System.SysUtils.Exception;

  TAppExcept = class(TForm)
    ImageList1: TImageList;
    pnlBottom: TPanel;
    btnLogFile: TButton;
    btnLogEMail: TButton;
    pnlTop: TPanel;
    imgAV: TImage;
    lblAVHeading: TLabel;
    PnlDetailsMsg: TPanel;
    lblDeatailTxt1: TLabel;
    lblDeatailTxt2: TLabel;
    pnlDetails: TPanel;
    LogDetails: TMemo;
    btnClose: TButton;
    pnlBtns: TGridPanel;
    btnCustom: TButton;
    lblAVText: TVA508StaticText;
    procedure lblDeatailTxt1Click(Sender: TObject);
    procedure LogDetailsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLogEMailClick(Sender: TObject);
  private
    FShowingDetails: Boolean;
    F508Manager: TVA508AccessibilityManager;
    function CalcWidthResize(): Integer;
  public
    constructor CreateForm(AOwner: TComponent; AException: Exception);
  end;

  TAppException = procedure(Sender: TObject; E: Exception) of object;
  TCustomExceptionDetailsEvent = procedure(var CustomDetails: TStringList)
    of object;

  TErrorObject = class(TThread)
  private
    FJSONBuilder: TJSONObjectBuilder;
    FJSONWriter: TJsonTextWriter;
    FStringWriter: TStringWriter;
    FStringBuilder: TStringBuilder;
    FReadableString: TStringList;
    FMapParser: TMapParser;
    FModuleParser: TModuleParser;
    FCustomErrorStrings: TStringList;
    FMaxStackDepth: Integer;
    FExceptionStack: TStack;
    FExceptionUnitName: string;
    FExceptionClassName: string;
    FExceptionMessage: string;
    FExceptionString: string;
    function GetJSONString: string;
    function GetReadableString: TStringList;
  protected
    procedure Execute; override;
  public
    constructor Create(AException: Exception; ACustomDetails: TStrings;
      AMapParser: TMapParser; AMaxStackDepth: Integer); overload;
    destructor Destroy; override;
    property JSONBuilder: TJSONObjectBuilder read FJSONBuilder;
    property JSONString: string read GetJSONString;
    property ReadableString: TStringList read GetReadableString;
    property ExceptionStack: TStack read FExceptionStack;
    property ExceptionUnitName: string read FExceptionUnitName;
    property ExceptionClassName: string read FExceptionClassName;
    property ExceptionMessage: string read FExceptionMessage;
    property ExceptionString: string read FExceptionString;
  end;

  TExceptionLogger = class(TObject)
  private
    FAppException: TAppException;
    FAfterAppException: TAppException;
    FOnBtnCustomClick: TNotifyEvent;
    FBtnCustomCaption: string;
    FAVLogFile: string; // Log file for the AV info
    FEmailTo: TStringList;
    FEnabled: Boolean;
    FMaxStackDepth: Integer;
    FDaysToPurge: Integer;
    FVisible: Boolean;
    FTerminateApp: Boolean;
    FCustomErrorStrings: TStringList;
    FOnCustomExceptionDetails: TCustomExceptionDetailsEvent;
    FErrors: TObjectList<TErrorObject>;
    FMapParser: TMapParser;
    FPurgeInfo: TStringList;
    FIncludeModuleInfo: Boolean;
    procedure WaitForParsing;
    procedure AppException(Sender: TObject; E: Exception);
    // Inital way to call code
    procedure CatchException(Sender: TObject; E: Exception);
    // Creates blank email with log information in body
    procedure EmailError;
    // Sets up the log file for the AppData folder
    function GetLogFileName: string;
    // Writes JSON file
    procedure SaveJSON;
    // Purges log files based on DaysToPurge const
    function PurgeOldLogs: string;
    procedure StartParsing(AException: Exception; ACustomDetails: TStrings);
    procedure AddCustomExceptionDetails;
  public type
    TSortOrder = (soNone, soFirst, soLast);
  public const
    ErrorLineLength = 70;
    ErrorNamePadding = 10;
  public
    constructor Create;
    destructor Destroy; override;
    // Adds a Name Value pair to the List, seperated by a colon after padding
    // the Name to Pad length
    class procedure AddDetail(List: TStrings; Name, Value: string;
      Pad: integer = ErrorNamePadding);
    // Adds a section header to the passed in TStrings in the same format used
    // by the exception log report
    class procedure AddSectionHeader(List: TStrings; Caption: string;
      SortOrder: TSortOrder = soNone; Len: integer = ErrorLineLength);
    class function FileVersion(const AFileName: string): string;
    class function RightPad(S: string; ch: char; Len: Integer): string;
    property BtnCustomCaption: string read FBtnCustomCaption
      write FBtnCustomCaption;
    property AVLogFile: string read GetLogFileName write FAVLogFile;
    property TerminateApp: Boolean read FTerminateApp write FTerminateApp;
    property DaysToPurge: Integer read FDaysToPurge write FDaysToPurge;
    property Enabled: Boolean read FEnabled write FEnabled;
    property MaxStackDepth: Integer read FMaxStackDepth write FMaxStackDepth;
    property Visible: Boolean read FVisible write FVisible;
    property EmailTo: TStringList read FEmailTo;
    property IncludeModuleInfo: Boolean read FIncludeModuleInfo write FIncludeModuleInfo;
    property OnBtnCustomClick: TNotifyEvent read FOnBtnCustomClick
      write FOnBtnCustomClick;
    property OnAppException: TAppException read FAppException
      write FAppException;
    property OnAfterAppException: TAppException read FAfterAppException
      write FAfterAppException;
    property OnCustomExceptionDetails: TCustomExceptionDetailsEvent
      read FOnCustomExceptionDetails write FOnCustomExceptionDetails;
    property MapParser: TMapParser read FMapParser;
    property Errors: TObjectList<TErrorObject> read FErrors;
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
  UResponsiveGUI,
  Winapi.ActiveX,
  System.Win.ComObj,
  System.Variants,
  Outlook2010,
  Vcl.OleServer,
  VAUtils,
  VA508AccessibilityRouter;

{$R *.dfm}
{$REGION' CRC'}

const
  { copied from ORFn - table for calculating CRC values }
  CRC32_TABLE: array [0 .. 255] of DWORD = ($0, $77073096, $EE0E612C, $990951BA,
    $76DC419, $706AF48F, $E963A535, $9E6495A3, $EDB8832, $79DCB8A4, $E0D5E91E,
    $97D2D988, $9B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064, $6AB020F2,
    $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7, $136C9856,
    $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD,
    $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75,
    $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5,
    $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $1DB7106, $98D220BC,
    $EFD5102A, $71B18589, $6B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2, $F00F934,
    $9609A88E, $E10E9818, $7F6A0DBB, $86D3D2D, $91646C97, $E6635C01, $6B6B51F4,
    $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3,
    $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7,
    $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73,
    $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998, $B0D09822,
    $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320, $9ABFB3B6,
    $3B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $4DB2615, $73DC1683, $E3630B12,
    $94643B84, $D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671,
    $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9,
    $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1,
    $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C, $BC66831A, $256FD2A0,
    $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE, $B2BD0B28,
    $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D, $9B64C2B0,
    $EC63F226, $756AA39C, $26D930A, $9C0906A9, $EB0E363F, $72076785, $5005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7,
    $BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B,
    $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF,
    $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC, $40DF0B66,
    $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C, $CABAC28A,
    $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF, $B3667A2E,
    $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);

  { returns a cyclic redundancy check for a string }

function UpdateCrc32(Value: DWORD; var Buffer: array of Byte;
  Count: Integer): DWORD;
var
  i: Integer;
begin
  Result := Value;
  for i := 0 to Pred(Count) do
    Result := ((Result shr 8) and $00FFFFFF) xor CRC32_TABLE
      [(Result xor Buffer[i]) and $000000FF];
end;

function CRCForFile(AFileName: string): DWORD;
const
  BUF_SIZE = 16383;
type
  TBuffer = array [0 .. BUF_SIZE] of Byte;
var
  Buffer: Pointer;
  AHandle, BytesRead: Integer;
begin
  Result := $FFFFFFFF;
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
{$REGION 'TErrorObject'}

constructor TErrorObject.Create(AException: Exception; ACustomDetails: TStrings;
  AMapParser: TMapParser; AMaxStackDepth: Integer);
begin
  FStringBuilder := TStringBuilder.Create;
  FStringWriter := TStringWriter.Create(FStringBuilder);
  FJSONWriter := TJsonTextWriter.Create(FStringWriter);
  FJSONWriter.Formatting := TJsonFormatting.Indented;
  FJSONBuilder := TJSONObjectBuilder.Create(FJSONWriter);
  FReadableString := TStringList.Create;

  FExceptionStack := TStack.Create;
  FExceptionStack.Assign(AException.StackInfo);

  FExceptionUnitName := AException.UnitName;
  FExceptionClassName := AException.ClassName;
  FExceptionMessage := AException.Message;
  FExceptionString := AException.ToString;

  FMapParser := TMapParser.Create;
  FMapParser.Assign(AMapParser);

  FModuleParser := TModuleParser.Create;

  FMaxStackDepth := AMaxStackDepth;

  FCustomErrorStrings := TStringList.Create;
  FCustomErrorStrings.Assign(ACustomDetails);

  inherited Create(False);
end;

destructor TErrorObject.Destroy;
begin
  FreeAndNil(FCustomErrorStrings);
  FreeAndNil(FExceptionStack);
  FreeAndNil(FModuleParser);
  FreeAndNil(FMapParser);
  FreeAndNil(FReadableString);
  FreeAndNil(FJSONBuilder);
  FreeAndNil(FJSONWriter);
  FreeAndNil(FStringWriter);
  FreeAndNil(FStringBuilder);
  inherited;
end;

procedure TErrorObject.Execute;

  procedure GatherStackInfo(OutList, ParsedStack: TStringList;
    out VersionStr, TopStack: string);

    procedure Add(Text: string);
    begin
      OutList.Add(Text);
      if Assigned(ParsedStack) then ParsedStack.Add(Text);
    end;

    procedure LookupInModules(const LookUpAddr: Pointer;
      out AModule, AMethod: string; out AOffSet: DWord);
    begin
      FModuleParser.RetrieveModuleInfo(LookUpAddr, AModule, AMethod, AOffSet);
    end;

  const
    NoMapFormat  = '[%p]';
    StackFormat  = '[%p] %s (Line %s, "%s")';
    ModuleFormat = '[%p]   %s (Offset %d/$%x, "%s")';
  var
    P: Pointer;
    AUnit, AMethod, ALine, AModule: string;
    AOffset: DWord;
    CurrentLevel: Integer;
    AWasAddressFound: Boolean;
  begin
    VersionStr := TExceptionLogger.FileVersion(Application.ExeName);
    if Assigned(FExceptionStack) and (FExceptionStack.Count > 0) then
      TopStack := Format(NoMapFormat, [FExceptionStack[0]])
    else TopStack := Format(NoMapFormat, [nil]);

    if Assigned(OutList) then
    begin
      ExceptionLog.AddSectionHeader(OutList,'Application Information');
      ExceptionLog.AddDetail(OutList, 'Name',
        ExtractFileName(Application.ExeName));
      ExceptionLog.AddDetail(OutList, 'Version', VersionStr);
      ExceptionLog.AddDetail(OutList, 'CRC',
        IntToHex(CRCForFile(Application.ExeName), 8));
      ExceptionLog.AddSectionHeader(OutList,'Error Information');
      ExceptionLog.AddDetail(OutList, 'Date/Time',
        FormatDateTime('mm/dd/yyyy hh:nn:ss', Now));
      ExceptionLog.AddDetail(OutList, 'Unit', FExceptionUnitName);
      ExceptionLog.AddDetail(OutList, 'Class', FExceptionClassName);
      ExceptionLog.AddDetail(OutList, 'Message', FExceptionMessage);
      if Length(Trim(FCustomErrorStrings.Text)) > 0 then
        OutList.Add(FCustomErrorStrings.Text);
      if FExceptionString <> FExceptionMessage then
        ExceptionLog.AddDetail(OutList, 'Text', FExceptionString);
      ExceptionLog.AddSectionHeader(OutList,'Error Trace', soFirst);

      if Assigned(FExceptionStack) then
      begin
        CurrentLevel := 0;
        for P in FExceptionStack do
        begin
          if CurrentLevel >= FMaxStackDepth then
            Break;
          if not FMapParser.IsMapLoaded then
          begin
            AWasAddressFound := False;
          end else begin
            FMapParser.LookupInMap(LongWord(P), AUnit, AMethod, ALine);
            AWasAddressFound := AUnit <> 'NA';
          end;

          if AWasAddressFound then
          begin
            Add(Format(StackFormat, [P, AMethod, ALine, AUnit]));
          end else begin
            if not ExceptionLog.IncludeModuleInfo then
            begin
              Format(NoMapFormat, [P]);
            end else begin
              LookupInModules(P, AModule, AMethod, AOffSet);
              if AModule = Application.ExeName then
                Add(Format(NoMapFormat, [P]))
              else Add(Format(ModuleFormat, [P, AModule, AOffSet, AOffSet,
                AMethod]));
            end;
          end;
          Inc(CurrentLevel);
        end;
      end;
    end;
  end;

var
  AStackInfo, ParsedStack: TStringList;
  VersionStr, TopStack: string;
begin
  inherited;
  try
    AStackInfo := nil;
    ParsedStack := nil;
    try
      AStackInfo := TStringList.Create;
      ParsedStack := TStringList.Create;
      GatherStackInfo(AStackInfo, ParsedStack, VersionStr, TopStack);
      ReadableString.Assign(AStackInfo);
      JSONBuilder //
      { - }.BeginObject //
      { --- }.BeginArray('Exception') //
      { ----- }.BeginObject //
      { ------- }.BeginArray('App') //
      { --------- }.BeginObject //
      { ----------- }.Add('Name', ExtractFileName(Application.ExeName)) //
      { ----------- }.Add('Version', VersionStr) //
      { ----------- }.Add('CRC', IntToHex(CRCForFile(Application.ExeName), 8))
      //
      { --------- }.EndObject //
      { ------- }.EndArray //
      //
      { ------- }.BeginArray('Error') //
      { --------- }.BeginObject //
      { ----------- }.Add('Date/Time', Now) //
      { ----------- }.Add('Unit', FExceptionUnitName) //
      { ----------- }.Add('Class', FExceptionClassName)
        .Add('Message', FExceptionMessage) //
      { --------- }.EndObject //
      { ------- }.EndArray //
      //
      { ------- }.BeginArray('Custom') //
      { --------- }.BeginObject //
      { ----------- }.Add('Data', FCustomErrorStrings.Text) //
      { --------- }.EndObject //
      { ------- }.EndArray //
      //
      { ------- }.BeginArray('Stack') //
      { --------- }.BeginObject //
      { ----------- }.Add('Top', TopStack) //
      { ----------- }.Add('Data', ParsedStack.Text) //
      { --------- }.EndObject //
      { ------- }.EndArray //
      //
      { ----- }.EndObject //
      { --- }.EndArray //
      { - }.EndObject; //

    finally
      FreeAndNil(ParsedStack);
      FreeAndNil(AStackInfo)
    end;
  except
    // swallow
  end;
end;

function TErrorObject.GetJSONString: string;
begin
  Result := FStringBuilder.ToString;
end;

function TErrorObject.GetReadableString: TStringList;
begin
  Result := FReadableString;
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
  FMaxStackDepth := 100;
  FDaysToPurge := 60;
  FEnabled := True;
  FEmailTo := TStringList.Create;
  FVisible := True;
  FTerminateApp := False;
  FCustomErrorStrings := TStringList.Create;
  Application.OnException := AppException;
  FMapParser := TMapParser.Create;
  FErrors := TObjectList<TErrorObject>.Create;
  FPurgeInfo := TStringList.Create;
end;

destructor TExceptionLogger.Destroy();
begin
  FreeAndNil(FPurgeInfo);
  FreeAndNil(FErrors);
  FreeAndNil(FMapParser);
  FreeAndNil(FCustomErrorStrings);
  FreeAndNil(FEmailTo);
  inherited;
end;

procedure TExceptionLogger.AddCustomExceptionDetails;
begin
  FCustomErrorStrings.Clear;
  if Assigned(FOnCustomExceptionDetails) then
    FOnCustomExceptionDetails(FCustomErrorStrings);
end;

class procedure TExceptionLogger.AddDetail(List: TStrings; Name, Value: string;
  Pad: integer = ErrorNamePadding);
begin
  List.Add(Name.PadRight(Pad) + ': ' + Value);
end;

class procedure TExceptionLogger.AddSectionHeader(List: TStrings;
  Caption: string; SortOrder: TSortOrder; Len: integer);
const
  SORT_ORDERS: array[TSortOrder] of string = ('', ' (most recent first)',
    ' (most recent last)');
begin
  if List.Count > 0 then
    List.Add('');
  if Caption <> '' then
  begin
    Caption := Caption + SORT_ORDERS[SortOrder];
    List.Add(StringOfChar(' ', 15) + Caption);
  end;
  List.Add(StringOfChar('=', Len));
end;

procedure TExceptionLogger.AppException(Sender: TObject; E: Exception);

  procedure ShowErrorDialog;
  const
    ErrorMsg = 'Due to the nature of the error %s must shut down';
  var
    ErrorDlg: TTaskDialog;
  begin
    ErrorDlg := TTaskDialog.Create(nil);
    try
      ErrorDlg.Caption := 'Non Recoverable Error';
      ErrorDlg.Title := 'ERROR';
      ErrorDlg.Text := Format(ErrorMsg, [Application.Title]);
      ErrorDlg.CommonButtons := [tcbClose];
      ErrorDlg.MainIcon := tdiError;
      ErrorDlg.Execute;
    finally
      FreeAndNil(ErrorDlg);
    end;

  end;

begin
  if Assigned(FAppException) then
    FAppException(Sender, E);

  if FEnabled then
    CatchException(Sender, E)
  else
    Application.ShowException(E);

  if Assigned(FAfterAppException) and FEnabled then
    FAfterAppException(Sender, E);
  if FTerminateApp and (not Application.Terminated) then
  begin
    ShowErrorDialog;
    Application.Terminate;
  end;
end;

procedure TExceptionLogger.CatchException(Sender: TObject; E: Exception);
var
  AExceptionForm: TAppExcept;

begin
  try
    FMapParser.LoadUpMapFile;
    AExceptionForm := TAppExcept.CreateForm(Application, E);
    try
      AExceptionForm.ShowModal;
      Screen.Cursor := crHourGlass;
      try
        WaitForParsing;
        PurgeOldLogs;
        SaveJSON;
        if FVisible and (AExceptionForm.ModalResult = mrNo) then
          EmailError;

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
      '_' + FormatDateTime('mm_dd_yy_hh_nn', Now) + '_LOG.JSON';

    FAVLogFile := OurLogFile;
    Result := OurLogFile;
  end;
end;

procedure TExceptionLogger.StartParsing(AException: Exception;
  ACustomDetails: TStrings);
var
  ErrObj: TErrorObject;
begin
  ErrObj := TErrorObject.Create(AException, ACustomDetails, FMapParser,
    FMaxStackDepth);
  Errors.Add(ErrObj);
end;

function TExceptionLogger.PurgeOldLogs(): string;
const
  AFileMask = '*_LOG.json';
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
  iFile := FindFirst(sFilePath + AFileMask, faAnyFile, searchResult);
  while iFile = 0 do
  begin
    // Make sure we are on a file and not a directory
    if (searchResult.Name <> '.') and (searchResult.Name <> '..') and
      ((searchResult.Attr and faDirectory) <> faDirectory) then
    begin
      // Check the date of the file
      dtFileDate := searchResult.TimeStamp;
      if trunc(dtNow - dtFileDate) + 1 > FDaysToPurge then
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
    AddSectionHeader(FPurgeInfo, 'Log Purge Information');
    ExceptionLog.AddDetail(FPurgeInfo, 'Days:', IntToStr(FDaysToPurge));
    ExceptionLog.AddDetail(FPurgeInfo, 'Purged', IntToStr(iDelCnt));
    ExceptionLog.AddDetail(FPurgeInfo, 'NA', IntToStr(iErrorCnt));
    FPurgeInfo.Add('');
    FPurgeInfo.Add('');
  end
  else
    Result := '';
end;

procedure TExceptionLogger.WaitForParsing;
const
  Thread_Wait_Timeout = 60000;
  Wait_Error_Msg = 'Error processing exception lookup';
var
  Cr: TCursor;
  AThreadHandles: TWOHandleArray;
  AErrorObj: TErrorObject;
  AThreadCnt: Integer;
  rWait: Cardinal;
begin
  Cr := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    AThreadCnt := 0;

    for AErrorObj in FErrors do
    begin
      if not AErrorObj.Terminated then
      begin
        AThreadHandles[AThreadCnt] := AErrorObj.Handle;
        Inc(AThreadCnt);
      end;
    end;

    if AThreadCnt > MAXIMUM_WAIT_OBJECTS then
      raise Exception.CreateFmt('Max number of threads: %d',
        [MAXIMUM_WAIT_OBJECTS]);

    if AThreadCnt > 0 then
    begin
      rWait := WaitForMultipleObjects(AThreadCnt, @AThreadHandles, True, Thread_Wait_Timeout);
      case rWait of
        WAIT_FAILED: RaiseLastOSError;
        WAIT_TIMEOUT: raise exception.Create(Wait_Error_Msg);
      end;

    end;

  finally
    Screen.Cursor := Cr;
  end;
end;

procedure TExceptionLogger.SaveJSON;
var
  JsonFileStrings: TStringList;
  i: Integer;
begin
  JsonFileStrings := TStringList.Create;
  try
    JsonFileStrings.Add('[');
    // Write this final line
    for i := 0 to FErrors.Count - 1 do
    begin
      JsonFileStrings.Add(FErrors[i].JSONString);
      if i < FErrors.Count - 1 then
        JsonFileStrings.Add(',');
    end;
    JsonFileStrings.Add(']');
    JsonFileStrings.SaveToFile(AVLogFile);
  finally
    FreeAndNil(JsonFileStrings);
  end;
end;

procedure TExceptionLogger.EmailError;
var
  EmailUsrs, TmpStr: string;

  procedure SendMail(Subject, Body, RecvAddress: string);
  const
    cEmailError = 'An error occured trying to generate the email. Please copy '
      + 'the data from the details section and manually send to %s';
    cCRLF = #13#10;
  var
    stringlist: TStringList;
    EMailStr: PWideChar;
  begin
    stringlist := TStringList.Create;
    try

      stringlist.Add('mailto:' + RecvAddress);
      stringlist.Add('?Subject=' + TIdURI.ParamsEncode(Subject));
      stringlist.Add('&Body=' + TIdURI.ParamsEncode(Body));

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

  procedure TryAutoSendMail(Subject, RecvAddress, Attachs: string);

    procedure BuildBody(Strings: TStringList);
    begin
      if FPurgeInfo.Count > 0 then
        Strings.AddStrings(FPurgeInfo);

      for var i: Integer := 0 to FErrors.Count - 1 do
      begin
        if FErrors.Count > 1 then
          Strings.Add('Error: ' + IntToStr(i + 1));
        Strings.AddStrings(FErrors[i].ReadableString);
        if i < FErrors.Count - 1 then
        begin
          Strings.Add('');
          Strings.Add('');
        end;
      end;
    end;

  var
    OutlookApp: TOutlookApplication;
    MailItem: _MailItem;
    BodyStrings, AttachStrings: TStringList;
  begin
    BodyStrings := TStringList.Create;
    try
      try
        BuildBody(BodyStrings);

        OutlookApp := TOutlookApplication.Create(Application);
        try
          OutlookApp.ConnectKind := ckRunningOrNew;
          OutlookApp.Connect;
          MailItem := OutlookApp.CreateItem(olMailItem) as _MailItem;
          MailItem.Subject := Subject;
          MailItem.Recipients.Add(RecvAddress);
          MailItem.Body := BodyStrings.Text;
          MailItem.Attachments.Add(Attachs, olByValue, 1, 'Exception.JSON');
          MailItem.Send;
        finally
          FreeAndNil(OutlookApp);
        end;
      except
        AttachStrings := TStringList.Create;
        try
          AttachStrings.LoadFromFile(Attachs);

          AddSectionHeader(BodyStrings, 'Exception JSON');
          BodyStrings.Add('<JSON_BEGIN>');
          BodyStrings.AddStrings(AttachStrings);
          BodyStrings.Add('<JSON_END>');
          SendMail(Subject, BodyStrings.Text, RecvAddress);

        finally
          FreeAndNil(AttachStrings);
        end;
      end;
    finally
      FreeAndNil(BodyStrings);
    end;
  end;

  function SetEmailSubject: string;
  const
    mMsgLookup = 'M  ERROR=';
  var
    StrtPos, EndPos: Integer;
    ErrStr: string;
    AStack: TStack;
    ErrorObj: TErrorObject;
  begin
    if FErrors.Count <= 0 then
      Exit('[missing exception information]');

    ErrorObj := FErrors[0];

    Result := ErrorObj.ExceptionUnitName + '.' + ErrorObj.ExceptionClassName;
    ErrStr := '';
    if Trim(ErrorObj.ClassName) = 'EBrokerError' then
    begin
      StrtPos := Pos(mMsgLookup, ErrorObj.ExceptionMessage);
      if StrtPos > 0 then
      begin
        StrtPos := StrtPos + Length(mMsgLookup);
        EndPos := PosEx(#13, ErrorObj.ExceptionMessage, StrtPos) - StrtPos;
        ErrStr := Copy(ErrorObj.ExceptionMessage, StrtPos, EndPos);
        Result := Result + '[{' + ErrStr + '}]';
      end;
    end
    else
    begin
      try
        if Assigned(ErrorObj.FExceptionStack) and
          (TObject(ErrorObj.FExceptionStack) is TStack) then
        begin
          AStack := TStack(ErrorObj.FExceptionStack);
          if AStack.Count > 0 then
            ErrStr := Format('[%p]', [AStack.First]);
        end;
      except
        Exit('StackInfo is not of expected type');
      end;

      Result := Result + ErrStr;
    end;
  end;

begin
  // Need to figure out the ole object method
  // fEmailTo.Delimiter := ';';
  EmailUsrs := '';
  for TmpStr in FEmailTo do
  begin
    if (EmailUsrs <> '') then
      EmailUsrs := EmailUsrs + '; ';
    EmailUsrs := EmailUsrs + TmpStr;
  end;
  TryAutoSendMail(ExtractFileName(Application.ExeName) + ' Error logged - ' +
    SetEmailSubject, EmailUsrs, AVLogFile);
end;

class function TExceptionLogger.FileVersion(const AFileName: string): string;
var
  BFileName: string;
  ASize, AHandle: DWORD;
  ABuffer: TBytes;
  AFixedFileInfo: PVSFixedFileInfo;
begin
  // GetFileVersionInfo modifies the filename parameter data while parsing.
  // Copy the string const into a local variable to create a writeable copy.
  BFileName := AFileName;
  UniqueString(BFileName);
  ASize := GetFileVersionInfoSize(PChar(BFileName), AHandle);
  if ASize > 0 then
  begin
    Setlength(ABuffer, ASize);
    if not GetFileVersionInfo(PChar(BFileName), AHandle, ASize, ABuffer) then
      RaiseLastOSError;
    if not VerQueryValue(ABuffer, '\', Pointer(AFixedFileInfo), ASize) then
      RaiseLastOSError;
    Result := Format('%d.%d.%d.%d', [ //
      LongRec(AFixedFileInfo.dwFileVersionMS).Hi, // major
      LongRec(AFixedFileInfo.dwFileVersionMS).Lo, // minor
      LongRec(AFixedFileInfo.dwFileVersionLS).Hi, // release
      LongRec(AFixedFileInfo.dwFileVersionLS).Lo]); // build
  end
  else
    RaiseLastOSError;
end;

class function TExceptionLogger.RightPad(S: string; ch: Char;
  Len: Integer): string;
begin
  Result := s.PadRight(Len, ch);
end;

{$ENDREGION}
{$REGION 'TAppExcept'}

constructor TAppExcept.CreateForm(AOwner: TComponent; AException: Exception);
begin
  inherited Create(AOwner);

  if ExceptionLog.FEmailTo.Count = 0 then
    pnlBtns.ColumnCollection[2].Value := 0
  else
    pnlBtns.ColumnCollection[2].Value := 25;
  pnlBtns.UpdateControlsColumn(2);

  if Assigned(ExceptionLog.FOnBtnCustomClick) then
  begin
    pnlBtns.ColumnCollection[3].Value := 25;
    btnCustom.Visible := True;
    btnCustom.Caption := ExceptionLog.FBtnCustomCaption;
    btnCustom.OnClick := ExceptionLog.FOnBtnCustomClick;
  end
  else
  begin
    pnlBtns.ColumnCollection[3].Value := 0;
    btnCustom.Visible := False;
  end;
  pnlBtns.UpdateControlsColumn(3);

  lblAVText.Caption := AException.Message;
  if ScreenReaderActive then
  begin
    F508Manager := TVA508AccessibilityManager.Create(Self);
    F508Manager.AccessText[lblAVText] := lblAVHeading.Caption;
    // will read lblAVHeading.Caption, then VA508StaticText1.Caption
    lblAVText.TabStop := True;
    lblAVText.TabOrder := 0;
    lblDeatailTxt1.Visible := False;
    lblDeatailTxt2.Visible := False;
  end;

  ExceptionLog.AddCustomExceptionDetails;

  ExceptionLog.StartParsing(AException, ExceptionLog.FCustomErrorStrings);

end;

procedure TAppExcept.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_EXSTYLE, WS_EX_APPWINDOW);
  if Assigned(Application.MainForm) then
  begin
    Font.Size := Application.MainForm.Font.Size;
    LogDetails.Font.Size := Font.Size;
    lblDeatailTxt1.Font.Size := Font.Size;
    PnlDetailsMsg.Height := Font.Size * 2;
  end;
end;

procedure TAppExcept.lblDeatailTxt1Click(Sender: TObject);
var
  NewWidth: Integer;
  ErorObject: TErrorObject;
  R: TRect;
begin
  if FShowingDetails then
    Exit;
  FShowingDetails := True;

  ExceptionLog.WaitForParsing;

  for ErorObject in ExceptionLog.FErrors do
  begin
    LogDetails.Lines.AddStrings(ErorObject.ReadableString);
    TExceptionLogger.AddSectionHeader(LogDetails.Lines, '');
    LogDetails.Lines.Add(TExceptionLogger.RightPad('', '=', TExceptionLogger.ErrorLineLength));
    LogDetails.Lines.Add('');
  end;

  Self.AutoSize := False;
  try
    NewWidth := CalcWidthResize;
    // Ensure that the width and height dont go past the screen
    Self.Width := Self.Width + NewWidth;
    Self.Height := Screen.DesktopHeight;
    R := BoundsRect;
    ForceRectInsideWorkArea(R, Application.MainForm);
    BoundsRect := r;
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

function TAppExcept.CalcWidthResize(): Integer;
var
  DC: HDC;
  CacheFont: HFont;
  i, LineCharCnt, LongLineIDX: Integer;
  LngLineText: string;
  TextSize: TSize;
begin
  DC := GetDC(LogDetails.Handle);
  try
    CacheFont := SelectObject(DC, LogDetails.Font.Handle);
    try
      LngLineText := '';
      LongLineIDX := -1;
      LineCharCnt := 0;
      LngLineText := '';
      for i := 0 to LogDetails.Lines.Count - 0 do
      begin
        if Length(LogDetails.Lines[i]) > LineCharCnt then
        begin
          LineCharCnt := Length(LogDetails.Lines[i]);
          LongLineIDX := i;
        end;
      end;
      LngLineText := LogDetails.Lines[LongLineIDX];

      GetTextExtentPoint32(DC, PChar(LngLineText), Length(LngLineText),
        TextSize);
      Result := TextSize.cx - (Self.Width) + 100;
    finally
      SelectObject(DC, CacheFont);
    end;
  finally
    ReleaseDC(LogDetails.Handle, DC);
  end;
end;

{$ENDREGION}

initialization

ExceptionLog := TExceptionLogger.Create;
StartExceptionStackMonitoring;
SpecifyFormIsNotADialog(TAppExcept);

finalization

StopExceptionStackMonitoring;
FreeAndNil(ExceptionLog);

end.

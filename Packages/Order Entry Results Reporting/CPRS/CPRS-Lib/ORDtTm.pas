unit ORDtTm;

{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,
  Grids, Calendar, ExtCtrls, ORFn, ORNet, ORDtTmCal, Mask, ComCtrls,
  OR2006Compatibility,
  ORCtrls, VAClasses, VA508AccessibilityManager, VA508AccessibilityRouter,
  DateUtils, Math, ORDtTmListBox;

type

  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  TDateRange = class(TObject)
  private
    fMinDate: Double;
    fMaxDate: Double;
    procedure SetMinDate(Const aMinDte: Double);
    procedure SetMaxDate(const aMaxDte: Double);
  public
    property MaxDate: Double read fMaxDate write SetMaxDate;
    property MinDate: Double read fMinDate write SetMinDate;
    function IsBetweenMinAndMax(const LookupDate: TDateTime): Boolean;
    function IsFullDay(const aDate: TDateTime): Boolean;
    constructor Create;
  end;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End

  TORCalendar = class(ORDtTmCal.TORCalendar) // CPRSPackages.ORDtTmCal
  private
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    fValidRange: TDateRange;
    procedure SetValidRange(aRange: TDateRange);
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    function IsBetweenMinAndMax(const LookupDate: TDateTime): Boolean;

    function getMinDateTime: TDateTime;
    function getMaxDateTime: TDateTime;
    function isRangeMode: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    // constructor CreateByRange(AOwner: TComponent;aDateRange:TDateRange);

    destructor Destroy(); override;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    property ValidRange: TDateRange read fValidRange write SetValidRange;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    property MinDateTime: TDateTime read getMinDateTime;
    property MaxDateTime: TDateTime read getMaxDateTime;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;
      AState: TGridDrawState); override;
  end;

  TORfrmDtTm = class(Tfrm2006Compatibility)
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    TxtDateSelected: TLabel;
    Label1: TLabel;
    bvlFrame: TBevel;
    lblDate: TPanel;
    txtTime: TEdit;
    lstHour: TORDtTmListBox;
    lstMinute: TORDtTmListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    calSelect: TORCalendar;
    pnlPrevMonth: TPanel;
    pnlNextMonth: TPanel;
    imgPrevMonth: TImage;
    imgNextMonth: TImage;
    bvlRButton: TBevel;
    cmdToday: TButton;
    cmdNow: TButton;
    cmdMidnight: TButton;
    procedure FormCreate(Sender: TObject);
    procedure calSelectChange(Sender: TObject);
    procedure cmdTodayClick(Sender: TObject);
    procedure txtTimeChange(Sender: TObject);
    procedure lstHourClick(Sender: TObject);
    procedure lstMinuteClick(Sender: TObject);
    procedure cmdNowClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure imgPrevMonthClick(Sender: TObject);
    procedure imgNextMonthClick(Sender: TObject);
    procedure imgPrevMonthMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgNextMonthMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPrevMonthMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgNextMonthMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cmdMidnightClick(Sender: TObject);
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstHourEnter(Sender: TObject);
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
  private
    FFromSelf: Boolean;
    FNowPressed: Boolean;
    TimeIsRequired: Boolean;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    procedure setTimeListsBySelectedDate;
    procedure setRangeTimeBoundaries;
    procedure setButtonStatus;
    function TimeIsValid: Boolean;
    function IsRangeMode: Boolean;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
  protected
    procedure Loaded; override;
  end;

  { TORDateTimeDlg }

  TORDateTimeDlg = class(TComponent)
  private
    FDateTime: TDateTime;
    FDateOnly: Boolean;
    FRequireTime: Boolean;
    FRelativeTime: string;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    fDateRange: TDateRange;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    function GetFMDateTime: TFMDateTime;
    procedure SetDateOnly(Value: Boolean);
    procedure SetFMDateTime(Value: TFMDateTime);
    procedure SetRequireTime(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    property DateRange: TDateRange read fDateRange write fDateRange;
    property DateTime: TDateTime read FDateTime write FDateTime;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    property RelativeTime: string read FRelativeTime;
  published
    property FMDateTime: TFMDateTime read GetFMDateTime write SetFMDateTime;
    property DateOnly: Boolean read FDateOnly write SetDateOnly;
    property RequireTime: Boolean read FRequireTime write SetRequireTime;
  end;

  // 508 class
  TORDateButton = class(TBitBtn);

  { TORDateBox }

  TORDateEdit = class(TEdit)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TORDateBox = class(TORDateEdit, IVADynamicProperty,
    IORBlackColorModeCompatible)
  private
    FFMDateTime: TFMDateTime;
    FDateOnly: Boolean;
    FRequireTime: Boolean;
    FButton: TORDateButton;
    FFormat: string;
    FTimeIsNow: Boolean;
    FTemplateField: Boolean;
    FCaption: TStaticText;
    FBlackColorMode: Boolean;
    FOnDateDialogClosed: TNotifyEvent;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    fDateSelected: TDateTime;
    fDateRange: TDateRange;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    procedure ButtonClick(Sender: TObject);
    function GetFMDateTime: TFMDateTime;
    function GetRelativeTime: string;
    procedure SetDateOnly(Value: Boolean);
    procedure SetFMDateTime(Value: TFMDateTime);
    procedure SetEditRect;
    procedure SetRequireTime(Value: Boolean);
    procedure UpdateText;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetTemplateField(const Value: Boolean);
    procedure SetCaption(const Value: string);
    function GetCaption(): string;
  protected
    procedure Change; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property DateButton: TORDateButton read FButton;
    procedure SetEnabled(Value: Boolean); override;
    // wat v28  when disabling TORDateBox, button still appears active, this addresses that
  public
    constructor Create(AOwner: TComponent); override;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    destructor Destroy(); override;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    function IsValid: Boolean;
    procedure Validate(var ErrMsg: string);
    procedure SetBlackColorMode(Value: Boolean);
    function SupportsDynamicProperty(PropertyID: Integer): Boolean;
    function GetDynamicProperty(PropertyID: Integer): string;
    property Format: string read FFormat write FFormat;
    property RelativeTime: string read GetRelativeTime;
    property TemplateField: Boolean read FTemplateField write SetTemplateField;
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    property DateSelected: TDateTime read fDateSelected write fDateSelected;
    property DateRange: TDateRange read fDateRange write fDateRange;
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
  published
    property FMDateTime: TFMDateTime read GetFMDateTime write SetFMDateTime;
    property DateOnly: Boolean read FDateOnly write SetDateOnly;
    property RequireTime: Boolean read FRequireTime write SetRequireTime;
    property Caption: string read GetCaption write SetCaption;
    property OnDateDialogClosed: TNotifyEvent read FOnDateDialogClosed
      write FOnDateDialogClosed;
  end;

  // 508 classes
  TORDayCombo = class(TORComboBox);
  TORMonthCombo = class(TORComboBox);

  TORYearEdit = class(TMaskEdit)
  private
    FTemplateField: Boolean;
    procedure SetTemplateField(const Value: Boolean);
  protected
    property TemplateField: Boolean read FTemplateField write SetTemplateField;
  end;

  TORYearEditClass = Class of TORYearEdit;

  TORDateCombo = class(TCustomPanel, IORBlackColorModeCompatible)
  private
    FYearChanging: Boolean;
    FMonthCombo: TORMonthCombo;
    FDayCombo: TORDayCombo;
    FYearEdit: TORYearEdit;
    FYearUD: TUpDown;
    FCalBtn: TORDateButton;
    FIncludeMonth: Boolean;
    FIncludeDay: Boolean;
    FIncludeBtn: Boolean;
    FLongMonths: Boolean;
    FMonth: Integer;
    FDay: Integer;
    FYear: Integer;
    FCtrlsCreated: Boolean;
    FOnChange: TNotifyEvent;
    FRebuilding: Boolean;
    FTemplateField: Boolean;
    FBlackColorMode: Boolean;
    FORYearEditClass: TORYearEditClass;
    fColor: TColor; // NSR20071216 AA 2016-01-22
    procedure SetColor(const Value: TColor); // NSR20071216 AA 2016-01-22
    procedure SetIncludeBtn(const Value: Boolean);
    procedure SetIncludeDay(Value: Boolean);
    procedure SetIncludeMonth(const Value: Boolean);
    procedure SetLongMonths(const Value: Boolean);
    procedure SetDay(Value: Integer);
    procedure SetMonth(Value: Integer);
    procedure SetYear(const Value: Integer);
    function GetFMDate: TFMDateTime;
    procedure SetFMDate(const Value: TFMDateTime);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure SetTemplateField(const Value: Boolean);
  protected
    procedure Rebuild; virtual;
    function InitDays(GetSize: Boolean): Integer;
    function InitMonths(GetSize: Boolean): Integer;
    function GetYearSize: Integer;
    procedure DoChange;
    procedure MonthChanged(Sender: TObject);
    procedure DayChanged(Sender: TObject);
    procedure YearChanged(Sender: TObject);
    procedure BtnClicked(Sender: TObject);
    {XE8 requires integer, XE3 required SmallInt}
    procedure YearUDChange(Sender: TObject; var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
    procedure YearKeyPress(Sender: TObject; var Key: Char);
    procedure CheckDays;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resized(Sender: TObject);
    property MonthCombo: TORMonthCombo read FMonthCombo;
    property DayCombo: TORDayCombo read FDayCombo;
    property YearEdit: TORYearEdit read FYearEdit;
    property YearUD: TUpDown read FYearUD;
    property CalBtn: TORDateButton read FCalBtn;
    property ORYearEditClass: TORYearEditClass read FORYearEditClass
      write FORYearEditClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DateText: string;
    procedure SetBlackColorMode(Value: Boolean);
    property TemplateField: Boolean read FTemplateField write SetTemplateField;
    property FMDate: TFMDateTime read GetFMDate write SetFMDate;
  published
    function Text: string;
    property IncludeBtn: Boolean read FIncludeBtn write SetIncludeBtn;
    property IncludeDay: Boolean read FIncludeDay write SetIncludeDay;
    property IncludeMonth: Boolean read FIncludeMonth write SetIncludeMonth;
    property LongMonths: Boolean read FLongMonths write SetLongMonths
      default False;
    property Month: Integer read FMonth write SetMonth;
    property Day: Integer read FDay write SetDay;
    property Year: Integer read FYear write SetYear;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Color: TColor read fColor write SetColor; // NSR20071216
    property Anchors;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property TabOrder;
    property TabStop;
    property Visible;
  end;

function IsLeapYear(AYear: Integer): Boolean;
function DaysPerMonth(AYear, AMonth: Integer): Integer;
function ServerFMNow: TFMDateTime;
function ServerParseFMDate(const AString: string): TFMDateTime;
function ServerToday: TDateTime;

procedure Register;

implementation

uses
  System.UITypes;

{$R *.DFM}
{$R ORDtTm}

const
  FMT_DATETIME = 'dddddd@hh:nn';
  FMT_DATEONLY = 'dddddd';
  AdjVertSize = 8;
  FontHeightText = 'BEFHILMSTVWXZfgjmpqtyk';

var
  uServerToday: TFMDateTime;
  FormatSettings: TFormatSettings;

  { Server-dependent functions ---------------------------------------------------------------- }

function ActiveBroker: Boolean;
begin
  Result := False;
  if (RPCBrokerV <> nil) and RPCBrokerV.Connected then
    Result := True;
end;

function ServerFMNow: TFMDateTime;
var
  aStr: string;
begin
  if ActiveBroker then
    begin
      CallVistA('ORWU DT', ['NOW'], aStr);
      Result := StrToFloat(aStr);
    end
  else
    Result := DateTimeToFMDateTime(Now);
end;

function ServerNow: TDateTime;
begin
  if ActiveBroker then
    Result := FMDateTimeToDateTime(ServerFMNow)
  else
    Result := Now;
end;

function ServerToday: TDateTime;
begin
  if uServerToday = 0 then
    uServerToday := Int(ServerFMNow);
  Result := FMDateTimeToDateTime(uServerToday);
end;

function ServerParseFMDate(const AString: string): TFMDateTime;
var
  aStr: string;
begin
  if ActiveBroker then
    begin
      CallVistA('ORWU DT', [AString, 'TSX'], aStr);
      Result := StrToFloat(aStr);
    end
  else Result := 0;
end;

function RelativeDateTime(ADateTime: TDateTime): string;
var
  Offset: Integer;
  h, n, s, l: Word;
  ATime: string;
begin
  Offset := Trunc(Int(aDateTime) - Int(ServerToday));
  if Offset < 0 then
    Result := 'T' + IntToStr(Offset)
  else if Offset = 0 then
    Result := 'T'
  else
    Result := 'T+' + IntToStr(Offset);
  DecodeTime(aDateTime, h, n, s, l);
  ATime := Format('@%.2d:%.2d', [h, n]);
  if ATime <> '@00:00' then
    Result := Result + ATime;
end;

procedure LoadEllipsis(bitmap: TBitMap; BlackColorMode: Boolean);
var
  ResName: string;
begin
  if BlackColorMode then
    ResName := 'BLACK_BMP_ELLIPSIS'
  else
    ResName := 'BMP_ELLIPSIS';
  bitmap.LoadFromResourceName(hInstance, ResName);
end;

/// /////////////////////////////////////////////////////////////////////////////
function stripCharSet(AString: String; aSet: TSysCharSet): String;
var
  i: Integer;
begin
  Result := AString;
  for i := Length(Result) downto 1 do
    if not CharInSet(Result[i], aSet) then
      Delete(Result, i, 1);
end;

function stripChars(AString: String): String;
begin
  Result := stripCharSet(AString, ['0' .. '9']);
end;

{ TfrmORDtTm -------------------------------------------------------------------------------- }

procedure TORfrmDtTm.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  lstHour.TopIndex := 6;
  FFromSelf := False;
  if ScreenReaderSystemActive then
    GetScreenReader.Speak(Label1.Caption);
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
procedure TORfrmDtTm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TORfrmDtTm.setTimeListsBySelectedDate;
begin
  lstHour.MinTime := -1;
  lstHour.MaxTime := -1;
  lstMinute.MinTime := -1;
  lstMinute.MaxTime := -1;
  // Check for Min and Max of calendar
  if DateOf(calSelect.CalendarDate) <= DateOf(calSelect.MinDateTime) then
  begin
    lstHour.MinTime := HourOf(calSelect.MinDateTime);
    lstMinute.MinTime := MinuteOf(calSelect.MinDateTime);
    if TimeOf(calSelect.CalendarDate) < calSelect.MinDateTime then
    begin
      lstHour.ItemIndex := HourOf(calSelect.MinDateTime);
      lstMinute.ItemIndex := MinuteOf(calSelect.MinDateTime) div 5;
    end;
  end
  else if DateOf(calSelect.CalendarDate) >= DateOf(calSelect.MaxDateTime) then
  begin
    lstHour.MaxTime := HourOf(calSelect.MaxDateTime);
    lstMinute.MaxTime := MinuteOf(calSelect.MaxDateTime);
    if TimeOf(calSelect.CalendarDate) > calSelect.MaxDateTime then
    begin
      lstHour.ItemIndex := HourOf(calSelect.MaxDateTime);
      lstMinute.ItemIndex := MinuteOf(calSelect.MinDateTime) div 5;
    end;
  end
  else // Date within range
  begin
    lstHour.ItemIndex := 6;
    lstMinute.ItemIndex := 0;
  end;
  lstHour.Repaint;
  lstMinute.Repaint;
end;

// NSR20071216 AA 2016-01-22 ----------------------------------------------- End
function TORfrmDtTm.IsRangeMode: Boolean;
begin
// fix for Defect #332950:
// Access violation in TORDateCombo component on selecting the date in the associated Calendar form
  Result := calSelect.isRangeMode;
end;

procedure TORfrmDtTm.calSelectChange(Sender: TObject);
begin
  lblDate.Caption := FormatDateTime('dddddd', calSelect.CalendarDate);
  FNowPressed := False;
  if ScreenReaderSystemActive then
  begin
    // TxtDateSelected.Caption := lblDate.Caption;
    TxtDateSelected.Caption := Label1.Caption + ' ' + lblDate.Caption;
    GetScreenReader.Speak(lblDate.Caption);
  end;
  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  if IsRangeMode then // check if the valid range was set
  begin
    // Now need to enforce invalid times
    setTimeListsBySelectedDate;
    if TimeIsRequired then
      lstMinuteClick(nil);
    setButtonStatus;
  end;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
end;

procedure TORfrmDtTm.imgPrevMonthMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPrevMonth.BevelOuter := bvLowered;
end;

procedure TORfrmDtTm.imgNextMonthMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlNextMonth.BevelOuter := bvLowered;
end;

procedure TORfrmDtTm.imgPrevMonthClick(Sender: TObject);
begin
  calSelect.PrevMonth;
end;

procedure TORfrmDtTm.imgNextMonthClick(Sender: TObject);
begin
  calSelect.NextMonth;
end;

procedure TORfrmDtTm.imgPrevMonthMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlPrevMonth.BevelOuter := bvRaised;
end;

procedure TORfrmDtTm.imgNextMonthMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlNextMonth.BevelOuter := bvRaised;
end;

procedure TORfrmDtTm.cmdTodayClick(Sender: TObject);
begin
  calSelect.CalendarDate := ServerToday;

  // cmdToday is disabled if out of assigned valid range
  if not IsRangeMode then
  begin
    lstHour.ItemIndex := -1;
    lstMinute.ItemIndex := -1;
    txtTime.Text := '';
  end;
end;

procedure TORfrmDtTm.txtTimeChange(Sender: TObject);
begin
  if not FFromSelf then
  begin
    lstHour.ItemIndex := -1;
    lstMinute.ItemIndex := -1;
  end;
  FNowPressed := False;
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
procedure TORfrmDtTm.setButtonStatus;
var
  dt: TDateTime;
begin
  if IsRangeMode then
  begin
    cmdNow.Enabled := calSelect.ValidRange.IsBetweenMinAndMax(Now);
    cmdToday.Enabled := calSelect.ValidRange.IsBetweenMinAndMax(ServerToday);
    dt := calSelect.CalendarDate;
    cmdMidnight.Enabled := calSelect.ValidRange.IsBetweenMinAndMax
      (round(dt) + 1 - 1 / (24 * 60));
  end;
end;

procedure TORfrmDtTm.setRangeTimeBoundaries;
var
  HourSel: String;
begin
  // only in case the valid range is assigned
  if (not assigned(calSelect.ValidRange)) or (
  (calSelect.ValidRange.MaxDate = -1) and (calSelect.ValidRange.MinDate = -1)
  )
  then
    exit;

  // Need to set the min minute
  lstMinute.MinTime := -1;
  lstMinute.MaxTime := -1;

  // Grab the hour selected
  if lstHour.ItemIndex < 0 then
    HourSel := '0'
  else
    HourSel := stripChars(lstHour.Items[lstHour.ItemIndex]);

  // Now need to enforce invalid times
  if DateOf(calSelect.CalendarDate) = DateOf(calSelect.MinDateTime) then
  begin // date is on the range boundary
    if StrToIntDef(HourSel, -1) <= HourOf(calSelect.MinDateTime) then
    begin // reset minutes of the boundary hour
      lstHour.ItemIndex := HourOf(calSelect.MinDateTime);

      lstMinute.MinTime := MinuteOf(calSelect.MinDateTime);
      // calculate min index
      if (lstMinute.ItemIndex = -1) // minutes were not selected
        or (lstMinute.ItemIndex < MinuteOf(calSelect.MinDateTime)) then
        // assign min index if mot assigned
        lstMinute.ItemIndex := MinuteOf(calSelect.MinDateTime)
    end
    else
      // reset minutes
      lstMinute.ItemIndex := 0; // -1;
  end
  else if DateOf(calSelect.CalendarDate) = DateOf(calSelect.MaxDateTime) then
  begin // date is on the range boundary
    if StrToIntDef(HourSel, -1) >= HourOf(calSelect.MaxDateTime) then
    begin
      lstHour.ItemIndex := HourOf(calSelect.MaxDateTime);

      lstMinute.MaxTime := MinuteOf(calSelect.MaxDateTime);
      // calculate min index
      if (lstMinute.ItemIndex = -1) or
        (lstMinute.ItemIndex > MinuteOf(calSelect.MinDateTime)) then
        // assign min index if mot assigned
        lstMinute.MaxTime := MinuteOf(calSelect.MaxDateTime);
    end
    else
      // reset minutes
      lstMinute.ItemIndex := 0; // was -1;
  end;
  lstMinute.Repaint;
end;
// NSR20071216 AA 2016-01-22 ----------------------------------------------- End

procedure TORfrmDtTm.lstHourClick(Sender: TObject);
begin
  setRangeTimeBoundaries; // NSR20071216 AA 2016-01-29

  if lstHour.ItemIndex = 0 then
    lstMinute.Items[0] := ':01  --'
  else
    lstMinute.Items[0] := ':00  --'; // <------ NEW CODE
  lstMinuteClick(self);
end;

procedure TORfrmDtTm.lstHourEnter(Sender: TObject);
begin
  setRangeTimeBoundaries; // NSR20071216 AA 2016-01-29
end;

procedure TORfrmDtTm.lstMinuteClick(Sender: TObject);
var
  AnHour, AMinute: Integer;
begin
  if lstHour.ItemIndex >= 0 then
  begin
    AnHour := lstHour.ItemIndex;
    if lstMinute.ItemIndex >= 0 then
      AMinute := lstMinute.ItemIndex * 5
    else
      AMinute := 0; // NSR20071216 AA 2016-01-29
    if (AnHour = 0) and (AMinute = 0) then
      AMinute := 1; // <-------------- NEW CODE
    FFromSelf := True;
    txtTime.Text := Format('%.2d:%.2d ', [AnHour, AMinute]);

    FFromSelf := False;
  end;
end;

procedure TORfrmDtTm.cmdNowClick(Sender: TObject);
begin
  calSelect.CalendarDate := ServerToday;
  txtTime.Text := FormatDateTime('hh:nn', ServerNow); // if ampm time

    lstHour.ItemIndex := -1;
    lstMinute.ItemIndex := -1;

  FNowPressed := True;
end;

procedure TORfrmDtTm.cmdMidnightClick(Sender: TObject);
begin
  txtTime.Text := '23:59'; // if military time

  lstHour.ItemIndex := -1;
  lstMinute.ItemIndex := -1;
end;

function TORfrmDtTm.TimeIsValid: Boolean;
var
  dt: TDateTime;
  tm: TDateTime;
const
  fmtOutOfRange = 'Time entered %s is outside of the allowed range.' + CRLF +
    'Please enter a valid time.';

  procedure ReportError(aSelection: String);
  begin
    InfoBox(Format(fmtOutOfRange, [aSelection])
{$IFDEF DEBUG}
    + CRLF + CRLF
    + 'Min date:time ' + FormatDateTime('c',calSelect.fValidRange.MinDate) + CRLF
    + 'Max date:time ' + FormatDateTime('c',calSelect.fValidRange.MaxDate) + CRLF
{$ENDIF}
    , 'Invalid Time', MB_OK);
  end;

begin
  if not TimeIsRequired then
    Result := True
  else
    begin
      Result := False;
      if Length(txtTime.Text) > 0 then
      begin
        try
          tm := strToTime(txtTime.Text);
          if IsRangeMode then
            begin
              dt := calSelect.CalendarDate;
              dt := trunc(dt) + tm;
              if not calSelect.IsBetweenMinAndMax(dt) then
                {$IFDEF DEBUG}
                ReportError(formatDateTime('c',dt))
                {$ELSE}
                ReportError(txtTime.Text)
                {$ENDIF}
              else
                Result := True;
            end
          else
            Result := True;
        except
          on EConvertError do
            ReportError('Invalid Time string' + CRLF + 'Please enter a valid time');
        end;
      end
      else
        ReportError('Please enter a valid time');
    end;
end;

procedure TORfrmDtTm.cmdOKClick(Sender: TObject);
var
  X: string;

begin
  if not TimeIsRequired then
    begin
      ModalResult := mrOK;
      exit;
    end;

  if TimeIsRequired and (Length(txtTime.Text) = 0) then
  begin
    InfoBox('An entry for time is required.', 'Missing Time', MB_OK);
    exit;
  end;

  if Length(txtTime.Text) > 0 then
  begin
    X := Trim(txtTime.Text);
    if (X = '00:00') or (X = '0:00') or (X = '00:00:00') or (X = '0:00:00') then
      X := '00:01'; // <------- CHANGED CODE
    try
      StrToTime(X);
      txtTime.Text := X;
      if TimeIsValid then // NSR20071216 AA 2016-01-29
        ModalResult := mrOK;
    except
      on EConvertError do
        InfoBox('Incorrect time value "'+X+'"', 'Invalid Time value', MB_OK);
    end;
  end;
end;

procedure TORfrmDtTm.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TORfrmDtTm.Loaded;
begin
  inherited Loaded;
  UpdateColorsFor508Compliance(self);
end;

{ TORDateTimeDlg }

constructor TORDateTimeDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not(csDesigning in ComponentState) then
    FDateTime := ServerToday
  else
    FDateTime := SysUtils.Date;
end;

function TORDateTimeDlg.Execute: Boolean;
const
  HORZ_SPACING = 8;
var
  frmDtTm: TORfrmDtTm;

  // NSR20071216 AA 2016-01-29 --------------------------------------------- Begin
  procedure setRange;
  begin
    with frmDtTm do
    begin
      if Assigned(self.DateRange) then
      begin
        if (self.DateRange.MinDate <> -1) or (self.DateRange.MaxDate <> -1) then
          Caption := Caption + ' between ' + FormatDateTime('dddddd@hh:nn',
            self.DateRange.MinDate) + ' and ' +
            FormatDateTime('dddddd@hh:nn', self.DateRange.MaxDate);
        calSelect.ValidRange := self.DateRange;
        calSelect.CalendarDate := self.DateTime;
        setButtonStatus;
      end;
    end;
  end;
// NSR20071216 AA 2016-01-29 ----------------------------------------------- End

begin
  frmDtTm := TORfrmDtTm.Create(Application);
  try
    with frmDtTm do
    begin
      lblDate.Caption := FormatDateTime('dddddd',FDateTime);
      setRange; // NSR20071216 AA 2016-01-22

      if Frac(FDateTime) > 0
      // then txtTime.Text := FormatDateTime('h:nn ampm', FDateTime);  // if ampm time
      then
        txtTime.Text := FormatDateTime('hh:nn', FDateTime); // if military time
      if RequireTime then
        TimeIsRequired := True;
      if DateOnly then
      begin
        txtTime.Visible := False;
        lstHour.Visible := False;
        lstMinute.Visible := False;
        cmdNow.Visible := False;
        cmdMidnight.Visible := False;
        bvlFrame.Width := bvlFrame.Width - txtTime.Width - HORZ_SPACING;
        cmdOK.Left := cmdOK.Left - txtTime.Width - HORZ_SPACING;
        cmdCancel.Left := cmdOK.Left;
        ClientWidth := ClientWidth - txtTime.Width - HORZ_SPACING;
      end;
      Result := (ShowModal = IDOK);
      if Result then
      begin
        FDateTime := Int(calSelect.CalendarDate);
        if Length(txtTime.Text) > 0 then
          FDateTime := FDateTime + StrToTime(txtTime.Text);
        if FNowPressed then
          FRelativeTime := 'NOW'
        else
          FRelativeTime := RelativeDateTime(FDateTime);
      end;
    end;
  finally
    frmDtTm.Free;
  end;
end;

function TORDateTimeDlg.GetFMDateTime: TFMDateTime;
begin
  Result := DateTimeToFMDateTime(FDateTime);
end;

procedure TORDateTimeDlg.SetDateOnly(Value: Boolean);
begin
  FDateOnly := Value;
  if FDateOnly then
  begin
    FRequireTime := False;
    FDateTime := Int(FDateTime);
  end;
end;

procedure TORDateTimeDlg.SetFMDateTime(Value: TFMDateTime);
begin
  if Value > 0 then
    FDateTime := FMDateTimeToDateTime(Value);
end;

procedure TORDateTimeDlg.SetRequireTime(Value: Boolean);
begin
  FRequireTime := Value;
  if FRequireTime then
    FDateOnly := False;
end;

{ TORDateEdit ----------------------------------------------------------------------------- }

procedure TORDateEdit.CreateParams(var Params: TCreateParams);
{ sets a one line edit box to multiline style so the editing rectangle can be changed }
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

{ TORDateBox -------------------------------------------------------------------------------- }

constructor TORDateBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TORDateButton.Create(self);
  FButton.Parent := self;
  FButton.Width := 18;
  FButton.Height := 17;
  FButton.OnClick := ButtonClick;
  FButton.TabStop := False;
  FBlackColorMode := False;
  LoadEllipsis(FButton.Glyph, False);
  FButton.Visible := True;
  FFormat := FMT_DATETIME;
  fDateRange := TDateRange.Create; // NSR20071216 AA 2016-01-22
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
destructor TORDateBox.Destroy();
begin
  inherited;
  fDateRange.Free;
end;
// NSR20071216 AA 2016-01-22 ----------------------------------------------- End

procedure TORDateBox.WMSize(var Message: TWMSize);
var
  ofs: Integer;

begin
  inherited;
  if Assigned(FButton) then
  begin
    if BorderStyle = bsNone then
      ofs := 0
    else
      ofs := 4;
    FButton.SetBounds(Width - FButton.Width - ofs, 0, FButton.Width,
      Height - ofs);
  end;
  SetEditRect;
end;

procedure TORDateBox.SetTemplateField(const Value: Boolean);
var
  Y: Integer;

begin
  if (FTemplateField <> Value) then
  begin
    FTemplateField := Value;
    Y := TextHeightByFont(Font.Handle, FontHeightText);
    if Value then
    begin
      FButton.Width := Y + 2;
      Height := Y;
      BorderStyle := bsNone;
    end
    else
    begin
      FButton.Width := 18;
      Height := Y + AdjVertSize;
      BorderStyle := bsSingle;
    end;
  end;
end;

function TORDateBox.SupportsDynamicProperty(PropertyID: Integer): Boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

procedure TORDateBox.ButtonClick(Sender: TObject);
var
  DateDialog: TORDateTimeDlg;
  ParsedDate: TFMDateTime;
begin
  DateDialog := TORDateTimeDlg.Create(Application);
  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  DateDialog.DateRange := DateRange;
  if DateSelected <> 0 then // RTC item # 322517 (20160518)
  DateDialog.DateTime := DateSelected;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
  if Length(Text) > 0 then
  begin
    ParsedDate := ServerParseFMDate(Text);
    if ParsedDate > -1 then
      FFMDateTime := ParsedDate
    else
      FFMDateTime := 0;
  end;
  DateDialog.DateOnly := FDateOnly;
  DateDialog.FMDateTime := FFMDateTime;
  DateDialog.RequireTime := FRequireTime;

  if DateDialog.Execute then
  begin
    FFMDateTime := DateDialog.FMDateTime;
    UpdateText;
    FTimeIsNow := DateDialog.RelativeTime = 'NOW';
    fDateSelected := DateDialog.DateTime; // NSR20071216 AA 2016-01-22
  end;
  DateDialog.Free;
  if Assigned(OnDateDialogClosed) then
    OnDateDialogClosed(self);
  if Visible and Enabled then // Some events may hide the component
    SetFocus;
end;

procedure TORDateBox.Change;
begin
  inherited Change;
  FTimeIsNow := False;
end;

procedure TORDateBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_RETURN) then
  begin
    FButton.Click;
    Key := 0;
  end;
end;

procedure TORDateBox.KeyPress(var Key: Char);
begin
  if Key = #13 then
    Key := #0;
  inherited;
end;

function TORDateBox.GetFMDateTime: TFMDateTime;
begin
  Result := 0;
  if Length(Text) > 0 then
    Result := ServerParseFMDate(Text);
  FFMDateTime := Result;
end;

function TORDateBox.GetRelativeTime: string;
begin
  Result := '';
  if FTimeIsNow then
    Result := 'NOW'
  else if UpperCase(Text) = 'NOW' then
    Result := 'NOW'
  else if Length(Text) > 0 then
  begin
    FFMDateTime := ServerParseFMDate(Text);
    if FFMDateTime > 0 then
      Result := RelativeDateTime(FMDateTimeToDateTime(FFMDateTime));
  end;
end;

procedure TORDateBox.SetDateOnly(Value: Boolean);
begin
  FDateOnly := Value;
  if FDateOnly then
  begin
    FRequireTime := False;
    FFMDateTime := Int(FFMDateTime);
    if FFormat = FMT_DATETIME then
      FFormat := FMT_DATEONLY;
  end;
  UpdateText;
end;

procedure TORDateBox.SetFMDateTime(Value: TFMDateTime);
begin
  FFMDateTime := Value;
  UpdateText;
end;

procedure TORDateBox.SetRequireTime(Value: Boolean);
begin
  FRequireTime := Value;
  if FRequireTime then
  begin
    if FFormat = FMT_DATEONLY then
      FFormat := FMT_DATETIME;
    SetDateOnly(False);
  end;
end;

procedure TORDateBox.SetEditRect;
{ change the edit rectangle to not hide the calendar button - taken from SPIN.PAS sample }
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, Longint(@Loc));
  Loc.Bottom := ClientHeight + 1; // +1 is workaround for windows paint bug
  Loc.Right := FButton.Left - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, Longint(@Loc));
end;

procedure TORDateBox.UpdateText;
begin
  if FFMDateTime > 0 then
  begin
    if (FFormat = FMT_DATETIME) and (Frac(FFMDateTime) = 0) then
      Text := FormatFMDateTime(FMT_DATEONLY, FFMDateTime)
    else
      Text := FormatFMDateTime(FFormat, FFMDateTime);
  end;
end;

procedure TORDateBox.Validate(var ErrMsg: string);
var
  dt: TDateTime;
  dateToVistA: string;
const
  fmtDT = 'c';
begin
  ErrMsg := '';
  if DateSelected > 0 then
  begin
    {
      !!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
      //We need to make sure that there is a date entered before parse
      if FRequireTime and ((Pos('@', Text) = 0) or (Length(Piece(Text, '@', 1)) = 0)) then
      ErrMsg := 'Date Required';
    }
    DateTimeToString(dateToVistA, 'yyyy/mm/dd@hh:mm', DateSelected);
    FFMDateTime := ServerParseFMDate(dateToVistA);
    if FFMDateTime <= 0 then
      ErrMsg := 'Invalid Date/Time';
    if FRequireTime and (Frac(FFMDateTime) = 0) then
      ErrMsg := ErrMsg + 'Time Required' + CRLF;
    if FDateOnly and (Frac(FFMDateTime) > 0) then
      ErrMsg := ErrMsg + 'Time not Required' + CRLF;

    dt := FMDateTimeToDateTime(FFMDateTime);

    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    if (fDateRange.MinDate > 0) and (dt < fDateRange.MinDate) then
      ErrMsg := ErrMsg + 'Date/Time selected (' + FormatDateTime(fmtDT, dt) +
        ' )' + CRLF + 'can''t be less than ' + FormatDateTime(fmtDT,
        fDateRange.MinDate) + CRLF;
    if (fDateRange.MaxDate > 0) and (dt > fDateRange.MaxDate) then
      ErrMsg := ErrMsg + 'Date/Time selected (' + FormatDateTime(fmtDT, dt) +
        ')' + CRLF + 'can''t be greater than ' + FormatDateTime(fmtDT,
        fDateRange.MaxDate) + CRLF;
{$IFDEF DEBUG_AA}
    if ErrMsg <> '' then
      ErrMsg := Name + ':  ' + ErrMsg;
{$ENDIF}
    ErrMsg := Trim(ErrMsg);
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
  end;
end;

function TORDateBox.IsValid: Boolean;
var
  X: string;
begin
  Validate(X);
  Result := (Length(X) = 0);
  if (Length(Text) = 0) then
    Result := False;
end;

procedure TORDateBox.SetBlackColorMode(Value: Boolean);
begin
  if FBlackColorMode <> Value then
  begin
    FBlackColorMode := Value;
    LoadEllipsis(FButton.Glyph, FBlackColorMode);
  end;
end;

procedure TORDateBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaption) then
  begin
    FCaption := TStaticText.Create(self);
    FCaption.AutoSize := False;
    FCaption.Height := 0;
    FCaption.Width := 0;
    FCaption.Visible := True;
    FCaption.Parent := Parent;
    FCaption.BringtoFront;
  end;
  FCaption.Caption := Value;
end;

procedure TORDateBox.SetEnabled(Value: Boolean);
begin
  FButton.Enabled := Value;
  inherited;
end;

function TORDateBox.GetCaption: string;
begin
  Result := FCaption.Caption;
end;

function TORDateBox.GetDynamicProperty(PropertyID: Integer): string;
begin
  if PropertyID = DynaPropAccesibilityCaption then
    Result := GetCaption
  else
    Result := '';
end;

function IsLeapYear(AYear: Integer): Boolean;
begin
  Result := (AYear mod 4 = 0) and ((AYear mod 100 <> 0) or (AYear mod 400 = 0));
end;

function DaysPerMonth(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array [1 .. 12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30,
    31, 30, 31);
begin
  if (AYear < 1) or (AMonth < 1) then
    Result := 0
  else
  begin
    Result := DaysInMonth[AMonth];
    if (AMonth = 2) and IsLeapYear(AYear) then
      Inc(Result); { leap-year Feb is special }
  end;
end;

{ TORDateCombo ------------------------------------------------------------------------- }

const
  ComboBoxAdjSize = 24;
  EditAdjHorzSize = 8;
  DateComboCtrlGap = 2;
  FirstYear = 1800;
  LastYear = 2200;

  { TORDateComboEdit }

procedure TORYearEdit.SetTemplateField(const Value: Boolean);
begin
  if (FTemplateField <> Value) then
  begin
    FTemplateField := Value;
    if Value then
      BorderStyle := bsNone
    else
      BorderStyle := bsSingle;
  end;
end;

{ TORDateCombo }

constructor TORDateCombo.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption, csAcceptsControls];
  BevelOuter := bvNone;
  FIncludeMonth := True;
  FIncludeDay := True;
  FIncludeBtn := True;
  OnResize := Resized;
  FORYearEditClass := TORYearEdit;
end;

destructor TORDateCombo.Destroy;
begin
  if Assigned(FMonthCombo) then
    FMonthCombo.Free;
  if Assigned(FDayCombo) then
    FDayCombo.Free;
  if Assigned(FYearEdit) then
    FYearEdit.Free;
  if Assigned(FYearUD) then
    FYearUD.Free;
  if Assigned(FCalBtn) then
    FCalBtn.Free;
  inherited;
end;

function TORDateCombo.GetYearSize: Integer;
begin
  Result := TextWidthByFont(Font.Handle, '8888') + EditAdjHorzSize;
end;

function TORDateCombo.InitDays(GetSize: Boolean): Integer;
var
  dy: Integer;
begin
  Result := 0;
  if (Assigned(FDayCombo)) then
  begin
    dy := DaysPerMonth(FYear, FMonth) + 1;
    while (FDayCombo.Items.Count < dy) do
    begin
      if (FDayCombo.Items.Count = 0) then
        FDayCombo.Items.Add(' ')
      else
        FDayCombo.Items.Add(IntToStr(FDayCombo.Items.Count));
    end;
    while (FDayCombo.Items.Count > dy) do
      FDayCombo.Items.Delete(FDayCombo.Items.Count - 1);
    if (GetSize) then
      Result := TextWidthByFont(Font.Handle, '88') + ComboBoxAdjSize;
    if (FDay > (dy - 1)) then
      SetDay(dy - 1);
  end;
end;

function TORDateCombo.InitMonths(GetSize: Boolean): Integer;
var
  i, Size: Integer;
begin
  Result := 0;
  if (Assigned(FMonthCombo)) then
  begin
    FMonthCombo.Items.Clear;
    FMonthCombo.Items.Add(' ');
    for i := 1 to 12 do
    begin
      if FLongMonths then
        FMonthCombo.Items.Add(FormatSettings.LongMonthNames[i])
      else
        FMonthCombo.Items.Add(FormatSettings.ShortMonthNames[i]);
      if GetSize then
      begin
        Size := TextWidthByFont(Font.Handle, FMonthCombo.Items[i]);
        if (Result < Size) then
          Result := Size;
      end;
    end;
    if GetSize then
      Inc(Result, ComboBoxAdjSize);
  end;
end;

procedure TORDateCombo.Rebuild;
var
  Wide, X, Y: Integer;

begin
  if (not FRebuilding) then
  begin
    FRebuilding := True;
    try
      ControlStyle := ControlStyle + [csAcceptsControls];
      try
        Y := TextHeightByFont(Font.Handle, FontHeightText);
        if not FTemplateField then
          Inc(Y, AdjVertSize);
        X := 0;
        if (FIncludeMonth) then
        begin
          if (not Assigned(FMonthCombo)) then
          begin
            FMonthCombo := TORMonthCombo.Create(self);
            FMonthCombo.Parent := self;
            FMonthCombo.Top := 0;
            FMonthCombo.Left := 0;
            FMonthCombo.Style := orcsDropDown;
            FMonthCombo.DropDownCount := 13;
            FMonthCombo.ListItemsOnly := True;
            FMonthCombo.OnChange := MonthChanged;
          end;
          FMonthCombo.Font := Font;
          FMonthCombo.TemplateField := FTemplateField;
          Wide := InitMonths(True);
          FMonthCombo.Width := Wide;
          FMonthCombo.Height := Y;
          FMonthCombo.ItemIndex := FMonth;
          Inc(X, Wide + DateComboCtrlGap);

          if (FIncludeDay) then
          begin
            if (not Assigned(FDayCombo)) then
            begin
              FDayCombo := TORDayCombo.Create(self);
              FDayCombo.Parent := self;
              FDayCombo.Top := 0;
              FDayCombo.Style := orcsDropDown;
              FDayCombo.ListItemsOnly := True;
              FDayCombo.OnChange := DayChanged;
              FDayCombo.DropDownCount := 11;
            end;
            FDayCombo.Font := Font;
            FDayCombo.TemplateField := FTemplateField;
            Wide := InitDays(True);
            FDayCombo.Width := Wide;
            FDayCombo.Height := Y;
            FDayCombo.Left := X;
            FDayCombo.ItemIndex := FDay;
            Inc(X, Wide + DateComboCtrlGap);
          end
          else if Assigned(FDayCombo) then
          begin
            FDayCombo.Free;
            FDayCombo := nil;
          end;
        end
        else
        begin
          if Assigned(FDayCombo) then
          begin
            FDayCombo.Free;
            FDayCombo := nil;
          end;
          if Assigned(FMonthCombo) then
          begin
            FMonthCombo.Free;
            FMonthCombo := nil;
          end;
        end;
        if (not Assigned(FYearEdit)) then
        begin
          FYearEdit := FORYearEditClass.Create(self);
          FYearEdit.Parent := self;
          FYearEdit.Top := 0;
          FYearEdit.EditMask := '9999;1; ';
          FYearEdit.OnKeyPress := YearKeyPress;
          FYearEdit.OnChange := YearChanged;
        end;
        FYearEdit.Font := Font;
        FYearEdit.TemplateField := FTemplateField;
        Wide := GetYearSize;
        FYearEdit.Width := Wide;
        FYearEdit.Height := Y;
        FYearEdit.Left := X;
        Inc(X, Wide);
        if (not Assigned(FYearUD)) then
        begin
          FYearUD := TUpDown.Create(self);
          FYearUD.Parent := self;
          FYearUD.Thousands := False;
          FYearUD.Min := FirstYear - 1;
          FYearUD.Max := LastYear;
          FYearUD.OnChangingEx := YearUDChange;
        end;
        FYearEdit.TabOrder := 0;
        FYearUD.Top := 0;
        FYearUD.Left := X;
        FYearUD.Height := Y;
        FYearUD.Position := FYear;
        Inc(X, FYearUD.Width + DateComboCtrlGap);
        if (FIncludeBtn) then
        begin
          if (not Assigned(FCalBtn)) then
          begin
            FCalBtn := TORDateButton.Create(self);
            FCalBtn.TabStop := False;
            FCalBtn.Parent := self;
            FCalBtn.Top := 0;
            LoadEllipsis(FCalBtn.Glyph, FBlackColorMode);
            FCalBtn.OnClick := BtnClicked;
          end;
          Wide := FYearEdit.Height;
          if (Wide > Y) then
            Wide := Y;
          FCalBtn.Width := Wide;
          FCalBtn.Height := Wide;
          FCalBtn.Left := X;
          Inc(X, Wide + DateComboCtrlGap);
        end
        else if Assigned(FCalBtn) then
        begin
          FCalBtn.Free;
          FCalBtn := nil;
        end;
        self.Width := X - DateComboCtrlGap;
        self.Height := Y;
        CheckDays;
        FCtrlsCreated := True;
        DoChange;
      finally
        ControlStyle := ControlStyle - [csAcceptsControls];
      end;
    finally
      FRebuilding := False;
    end;
  end;
end;

procedure TORDateCombo.SetBlackColorMode(Value: Boolean);
begin
  if FBlackColorMode <> Value then
  begin
    FBlackColorMode := Value;
    if Assigned(FCalBtn) then
      LoadEllipsis(FCalBtn.Glyph, FBlackColorMode);
  end;
end;

procedure TORDateCombo.SetDay(Value: Integer);
begin
  if (not Assigned(FDayCombo)) and (not(csLoading in ComponentState)) then
    Value := 0;
  if (Value > DaysPerMonth(FYear, FMonth)) then
    Value := 0;
  if (FDay <> Value) then
  begin
    FDay := Value;
    if (Assigned(FDayCombo)) then
    begin
      if (FDayCombo.Items.Count <= FDay) then
        InitDays(False);
      FDayCombo.ItemIndex := FDay;
    end;
    DoChange;
  end;
end;

procedure TORDateCombo.SetIncludeBtn(const Value: Boolean);
begin
  if (FIncludeBtn <> Value) then
  begin
    FIncludeBtn := Value;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetIncludeDay(Value: Boolean);
begin
  if (Value) and (not FIncludeMonth) then
    Value := False;
  if (FIncludeDay <> Value) then
  begin
    FIncludeDay := Value;
    if (not Value) then
      FDay := 0;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetIncludeMonth(const Value: Boolean);
begin
  if (FIncludeMonth <> Value) then
  begin
    FIncludeMonth := Value;
    if (not Value) then
    begin
      FIncludeDay := False;
      FMonth := 0;
      FDay := 0;
    end;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetMonth(Value: Integer);
begin
  if (not Assigned(FMonthCombo)) and (not(csLoading in ComponentState)) then
    Value := 0;
  if (Value < 0) or (Value > 12) then
    Value := 0;
  if (FMonth <> Value) then
  begin
    FMonth := Value;
    if (Assigned(FMonthCombo)) then
      FMonthCombo.ItemIndex := FMonth;
    CheckDays;
    DoChange;
  end;
end;

procedure TORDateCombo.SetLongMonths(const Value: Boolean);
begin
  if (FLongMonths <> Value) then
  begin
    FLongMonths := Value;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetYear(const Value: Integer);
begin
  if (FYear <> Value) then
  begin
    FYear := Value;
    if (FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if (not FYearChanging) and (Assigned(FYearEdit)) and (Assigned(FYearUD))
    then
    begin
      FYearChanging := True;
      try
        if (FYear = 0) then
        begin
          FYearEdit.Text := '    ';
          FYearUD.Position := FirstYear - 1
        end
        else
        begin
          FYearEdit.Text := IntToStr(FYear);
          FYearUD.Position := FYear;
        end;
      finally
        FYearChanging := False;
      end;
    end;
    if (FMonth = 2) then
      InitDays(False);
    CheckDays;
    DoChange;
  end;
end;

procedure TORDateCombo.DayChanged(Sender: TObject);
begin
  FDay := FDayCombo.ItemIndex;
  if (FDay < 0) then
    FDay := 0;
  CheckDays;
  DoChange;
end;

procedure TORDateCombo.MonthChanged(Sender: TObject);
begin
  FMonth := FMonthCombo.ItemIndex;
  if (FMonth < 0) then
    FMonth := 0;
  InitDays(False);
  CheckDays;
  DoChange;
end;

procedure TORDateCombo.YearChanged(Sender: TObject);
begin
  if FYearChanging then
    exit;
  FYearChanging := True;
  try
    FYear := StrToIntDef(FYearEdit.Text, 0);
    if (FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if (FYear = 0) then
      FYearUD.Position := FirstYear - 1
    else
      FYearUD.Position := FYear;
    if (FMonth = 2) then
      InitDays(False);
    CheckDays;
    DoChange;
  finally
    FYearChanging := False;
  end;
end;

procedure TORDateCombo.CheckDays;
var
  MaxDays: Integer;

begin
  if (FIncludeMonth and Assigned(FMonthCombo)) then
  begin
    FMonthCombo.Enabled := (FYear > 0);
    if (FYear = 0) then
      SetMonth(0);
    if (FIncludeMonth and FIncludeDay and Assigned(FDayCombo)) then
    begin
      FDayCombo.Enabled := ((FYear > 0) and (FMonth > 0));
      MaxDays := DaysPerMonth(FYear, FMonth);
      if (FDay > MaxDays) then
        SetDay(MaxDays);
    end;
  end;
end;

procedure TORDateCombo.Loaded;
begin
  inherited;
  if (not FCtrlsCreated) then
    Rebuild;
end;

procedure TORDateCombo.Paint;
begin
  if (not FCtrlsCreated) then
    Rebuild;
  inherited;
end;

procedure TORDateCombo.BtnClicked(Sender: TObject);
var
  mm, dd, yy: Integer;
  m, d, Y: Word;
  DateDialog: TORDateTimeDlg;
begin
  DateDialog := TORDateTimeDlg.Create(self);
  try
    mm := FMonth;
    dd := FDay;
    yy := FYear;
    DecodeDate(Now, Y, m, d);
    if (FYear = 0) then
      FYear := Y;
    if (FYear = Y) then
    begin
      if ((FMonth = 0) or (FMonth = m)) and (FDay = 0) then
      begin
        FMonth := m;
        FDay := d;
      end;
    end;
    if (FMonth = 0) then
      FMonth := 1;
    if (FDay = 0) then
      FDay := 1;
    DateDialog.FMDateTime := GetFMDate;
    DateDialog.DateOnly := True;
    DateDialog.RequireTime := False;
    if DateDialog.Execute then
    begin
      FYear := 0;
      FMonth := 0;
      FDay := 0;
      SetFMDate(DateDialog.FMDateTime);
    end
    else
    begin
      SetYear(yy);
      SetMonth(mm);
      SetDay(dd);
    end;
  finally
    DateDialog.Free;
  end;
end;

procedure TORDateCombo.YearUDChange(Sender: TObject; var AllowChange: Boolean;
  NewValue: Integer; Direction: TUpDownDirection);
var
  Y, m, d: Word;
begin
  if FYearChanging then
    exit;
  FYearChanging := True;
  try
    if FYearUD.Position = (FirstYear - 1) then
    begin
      DecodeDate(Now, Y, m, d);
      FYear := Y;
      FYearUD.Position := Y;
      AllowChange := False;
    end
    else
      FYear := NewValue;
    if (FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if (FYear = 0) then
      FYearEdit.Text := '    '
    else
      FYearEdit.Text := IntToStr(FYear);
    if (FMonth = 2) then
      InitDays(False);
    CheckDays;
    DoChange;
  finally
    FYearChanging := False;
  end;
end;

procedure TORDateCombo.YearKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['0' .. '9']) and (FYearEdit.Text = '    ') then
  begin
    FYearEdit.Text := Key + '   ';
    Key := #0;
    FYearEdit.SelStart := 1;
    FYearEdit.SelText := '';
  end;
end;

function TORDateCombo.GetFMDate: TFMDateTime;
begin
  if (FYear < FirstYear) then
    Result := 0
  else
    Result := ((FYear - 1700) * 10000 + FMonth * 100 + FDay);
end;

procedure TORDateCombo.SetFMDate(const Value: TFMDateTime);
var
  ival, mo, dy: Integer;
begin
  if (Value = 0) then
  begin
    SetYear(0);
    SetMonth(0);
  end
  else
  begin
    ival := Trunc(Value);
    if (Length(IntToStr(ival)) <> 7) then
      exit;
    dy := (ival mod 100);
    ival := ival div 100;
    mo := ival mod 100;
    ival := ival div 100;
    SetYear(ival + 1700);
    SetMonth(mo);
    InitDays(False);
    SetDay(dy);
  end;
end;

function TORDateCombo.DateText: string;
begin
  Result := '';
  if (FYear > 0) then
  begin
    if (FMonth > 0) then
    begin
      if FLongMonths then
        Result := FormatSettings.LongMonthNames[FMonth]
      else
        Result := FormatSettings.ShortMonthNames[FMonth];
      if (FDay > 0) then
        Result := Result + ' ' + IntToStr(FDay);
      Result := Result + ', ';
    end;
    Result := Result + IntToStr(FYear);
  end;
end;

procedure TORDateCombo.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

procedure TORDateCombo.Resized(Sender: TObject);
begin
  Rebuild;
end;

procedure TORDateCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Rebuild;
end;

function TORDateCombo.Text: string;
var
  tmp, fmt, m: string;
begin
  Result := '';
  tmp := FloatToStr(FMDate);
  if (tmp <> '') and (tmp <> '0') and (Length(tmp) >= 7) then
  begin
    if FLongMonths then
      m := 'mmmm'
    else
      m := 'mmm';
    if (copy(tmp, 4, 4) = '0000') then
      fmt := 'yyyy'
    else if (copy(tmp, 6, 2) = '00') then
      fmt := m + ', YYYY'
    else
      fmt := m + ' D, YYYY';
    Result := FormatFMDateTimeStr(fmt, tmp)
  end;
end;

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS', [TORDateTimeDlg, TORDateBox, TORDateCombo]);
end;

procedure TORDateCombo.SetTemplateField(const Value: Boolean);
begin
  if FTemplateField <> Value then
  begin
    FTemplateField := Value;
    Rebuild;
  end;
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin

Procedure TORDateCombo.SetColor(const Value: TColor);
begin
  fColor := Value;
  if Assigned(FMonthCombo) then
    FMonthCombo.Color := fColor;
  if Assigned(FDayCombo) then
    FDayCombo.Color := fColor;
  if Assigned(FYearEdit) then
    FYearEdit.Color := fColor;
end;

{ TORCalendar ------------------------------------------------------------------------------- }
constructor TORCalendar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TORCalendar.Destroy();
begin
  inherited;
end;

procedure TORCalendar.KeyDown(var Key: Word; Shift: TShiftState);
var
  iDelta: Integer;
begin
  // inherited;
  if ssCtrl in Shift then
    iDelta := 11
  else
    iDelta := 0;

  if Key = VK_PRIOR then
  begin
    CalendarDate := IncMonth(CalendarDate, -iDelta);
    if isRangeMode and (CalendarDate < MinDateTime) then
      CalendarDate := MinDateTime;
  end
  else if Key = VK_LEFT then
  begin
    CalendarDate := CalendarDate - 1;
    if isRangeMode and (CalendarDate < MinDateTime) then
      CalendarDate := MinDateTime;
  end
  else if Key = VK_NEXT then
  begin
    CalendarDate := IncMonth(CalendarDate, iDelta);
    if isRangeMode and (CalendarDate > MaxDateTime) then
      CalendarDate := MaxDateTime;
  end
  else if Key = VK_RIGHT then
  begin
    CalendarDate := CalendarDate + 1;
    if isRangeMode and (CalendarDate > MaxDateTime) then
      CalendarDate := MaxDateTime;
  end;
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin

procedure TORCalendar.SetValidRange(aRange: TDateRange);
begin
  fValidRange := aRange;
  if ValidRange.IsBetweenMinAndMax(ServerToday) then
    CalendarDate := ServerToday
  else
    CalendarDate := ValidRange.MinDate;
end;
// NSR20071216 AA 2016-01-22 ----------------------------------------------- End

function TORCalendar.getMinDateTime: TDateTime;
begin
  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  if Assigned(ValidRange) then
    Result := ValidRange.MinDate
  else
    Result := -1.0;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
end;

function TORCalendar.getMaxDateTime: TDateTime;
begin
  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  if Assigned(ValidRange) then
    Result := ValidRange.MaxDate
  else
    Result := -1.0;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
end;

function TORCalendar.IsBetweenMinAndMax(const LookupDate: TDateTime): Boolean;
begin
  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  if Assigned(ValidRange) then
    Result := ValidRange.IsBetweenMinAndMax(LookupDate)
  else
    Result := True;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
end;

function TORCalendar.isRangeMode: boolean;
begin
// fix for Defect #332950:
// Access violation in TORDateCombo component on selecting the date in the associated Calendar form
  Result := Assigned(ValidRange) and (
    (ValidRange.MaxDate <> -1) or (ValidRange.MinDate <> -1)
    );
end;

function TORCalendar.SelectCell(ACol, ARow: Longint): Boolean;
var
  TheText: string;
  DteToChk: TDateTime;
  _min, _max: TDateTime;
begin
  Result := (Inherited);

  TheText := CellText[ACol, ARow];
  if TheText = '' then
    exit;
  DteToChk := EncodeDate(Year, Month, StrToIntDef(TheText, 0));

  // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
  if Assigned(ValidRange) then
  begin
    if Result then
    begin
      _min := getMinDateTime;
      _max := getMaxDateTime;
      if _min <> -1 then
        Result := DateOf(DteToChk) >= DateOf(FloatToDateTime(_min));
      if _max <> -1 then
        Result := Result and
          (DateOf(DteToChk) <= DateOf(FloatToDateTime(_max)));
    end;
  end;
  // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
end;

function InverseColor(Color: TColor): TColor;
var
  rgb_: TColorref;

  function Inv(b: Byte): Byte;
  begin
    if b > 128 then
      Result := 0
    else
      Result := 255;
  end;

begin
  rgb_ := ColorToRgb(Color);
  rgb_ := RGB(Inv(GetRValue(rgb_)), Inv(GetGValue(rgb_)), Inv(GetBValue(rgb_)));

  Result := rgb_;
end;

procedure TORCalendar.DrawCell(ACol, ARow: Longint; ARect: TRect;
  AState: TGridDrawState);
var
  TheText: string;
  DteToChk: TDateTime;
  CurMonth, CurYear, CurDay: Word;
  UseColor: TColor;
  _min, _max: TDateTime;

begin
  TheText := CellText[ACol, ARow];
  with ARect, Canvas do
  begin
    // NSR20071216 AA 2016-01-22 --------------------------------------------- Begin
    if Assigned(ValidRange) then
    // NSR20071216 AA 2016-01-22 ----------------------------------------------- End
    begin
      _min := getMinDateTime;
      _max := getMaxDateTime;

      if StrToIntDef(TheText, -1) <> -1 then
      begin
        DteToChk := EncodeDate(Year, Month, StrToIntDef(TheText, 0));
        UseColor := clWindow;
        // if IsFullDay(DteToChk) then
        // UseColor := clLtGray;

        if (_min <> -1) and (_max <> -1) then
        begin
          // All dates between
          if not IsBetweenMinAndMax(DteToChk) then
            UseColor := clLtGray;
        end
        else if _min <> -1 then
        begin
          // All dates between
          if DateOf(DteToChk) < DateOf(FloatToDateTime(_min)) then
            UseColor := clLtGray;
        end
        else if _max <> -1 then
        begin
          // All dates between
          if DateOf(DteToChk) > DateOf(FloatToDateTime(_max)) then
            UseColor := clLtGray;
        end;
        Brush.Color := UseColor;
      end;
    end;
    DecodeDate(Date, CurYear, CurMonth, CurDay);
    if (CurYear = Year) and (CurMonth = Month) and (IntToStr(CurDay) = TheText)
    then
    begin
      TheText := '[' + TheText + ']';
      Font.Style := [fsBold];
    end;

    Font.Color := InverseColor(Brush.Color);

    TextRect(ARect, Left + (Right - Left - TextWidth(TheText)) div 2,
      Top + (Bottom - Top - TextHeight(TheText)) div 2, TheText);
  end;
end;

// NSR20071216 AA 2016-01-22 --------------------------------------------- Begin

/// /////////////////////////////////////////////////////////////////////////////
constructor TDateRange.Create;
begin
  inherited;
  fMinDate := -1;
  fMaxDate := -1;
end;

procedure TDateRange.SetMinDate(Const aMinDte: Double);
begin
  if (fMaxDate <> -1) and (aMinDte > fMaxDate) then
  begin
    raise Exception.Create('Min date cannot be after Max date');
    exit;
  end;
  fMinDate := aMinDte;
end;

procedure TDateRange.SetMaxDate(const aMaxDte: Double);
begin
  if (fMinDate <> -1) and (aMaxDte < fMinDate) then
  begin
    raise Exception.Create('Max date cannot be before Min date');
    exit;
  end;
  fMaxDate := aMaxDte;
end;

function TDateRange.IsBetweenMinAndMax(const LookupDate: TDateTime): Boolean;
var
  dd, ddd, dt: TDateTime;
begin
  dt := LookupDate;
  dd := fMinDate;
  ddd := fMaxDate;
  Result := (dt >= dd) and (dt <= ddd);
  // Result := (dt >= DateOf(fMinDate)) and (dt <= DateOf(fMaxDate));
end;

function TDateRange.IsFullDay(const aDate: TDateTime): Boolean;
var
  _min, _max, dtMin, dtMax: TDateTime;
begin
  _min := TDateTime(MinDate);
  _max := TDateTime(MaxDate);
  dtMin := round(aDate) + 1 / (24 * 60 * 60);
  dtMax := round(aDate + 1) - 1 / (24 * 60 * 60);
  Result := (_min < dtMin) and (dtMax < _max);
end;
// NSR20071216 AA 2016-01-22 ----------------------------------------------- End

initialization

uServerToday := 0;
FormatSettings := TFormatSettings.Create;

end.

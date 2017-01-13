unit ORDtTm;

{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  Grids, Calendar, ExtCtrls, ORFn, ORNet, ORDtTmCal, Mask, ComCtrls, OR2006Compatibility,
  ORCtrls, VAClasses, VA508AccessibilityManager, VA508AccessibilityRouter;

type
  TORfrmDtTm = class(Tfrm2006Compatibility)
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    TxtDateSelected: TLabel;
    Label1: TLabel;
	bvlFrame: TBevel;
    lblDate: TPanel;
    txtTime: TEdit;
    lstHour: TListBox;
    lstMinute: TListBox;
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
  private
    FFromSelf: Boolean;
    FNowPressed:  Boolean;
    TimeIsRequired: Boolean;
  protected
    procedure Loaded; override;
  end;

  { TORDateTimeDlg }

  TORDateTimeDlg = class(TComponent)
  private
    FDateTime:     TDateTime;
    FDateOnly:     Boolean;
    FRequireTime:  Boolean;
    FRelativeTime: string;
    function GetFMDateTime: TFMDateTime;
    procedure SetDateOnly(Value: Boolean);
    procedure SetFMDateTime(Value: TFMDateTime);
    procedure SetRequireTime(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    property RelativeTime: string     read FRelativeTime;
  published
    property FMDateTime:  TFMDateTime read GetFMDateTime   write SetFMDateTime;
    property DateOnly:    Boolean     read FDateOnly       write SetDateOnly;
    property RequireTime: Boolean     read FRequireTime    write SetRequireTime;
  end;

  // 508 class
  TORDateButton = class (TBitBtn);

  { TORDateBox }

  TORDateEdit = class(TEdit)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TORDateBox = class(TORDateEdit, IVADynamicProperty, IORBlackColorModeCompatible)
  private
    FFMDateTime: TFMDateTime;
    FDateOnly: Boolean;
    FRequireTime: Boolean;
    FButton: TORDateButton;
    FFormat: string;
    FTimeIsNow: Boolean;
    FTemplateField: boolean;
    FCaption: TStaticText;
    FBlackColorMode: boolean;
    FOnDateDialogClosed : TNotifyEvent;
    procedure ButtonClick(Sender: TObject);
    function GetFMDateTime: TFMDateTime;
    function GetRelativeTime: string;
    procedure SetDateOnly(Value: Boolean);
    procedure SetFMDateTime(Value: TFMDateTime);
    procedure SetEditRect;
    procedure SetRequireTime(Value: Boolean);
    procedure UpdateText;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetTemplateField(const Value: boolean);
    procedure SetCaption(const Value: string);
    function  GetCaption(): string;
  protected
    procedure Change; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    property DateButton: TORDateButton read FButton;
    procedure SetEnabled(Value: Boolean); override; //wat v28  when disabling TORDateBox, button still appears active, this addresses that
  public
    constructor Create(AOwner: TComponent); override;
    function IsValid: Boolean;
    procedure Validate(var ErrMsg: string);
    procedure SetBlackColorMode(Value: boolean);
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
    property Format: string read FFormat write FFormat;
    property RelativeTime: string     read GetRelativeTime;
    property TemplateField: boolean read FTemplateField write SetTemplateField;
  published
    property FMDateTime:  TFMDateTime read GetFMDateTime  write SetFMDateTime;
    property DateOnly:    Boolean     read FDateOnly    write SetDateOnly;
    property RequireTime: Boolean     read FRequireTime write SetRequireTime;
    property Caption: string read GetCaption write SetCaption;
    property OnDateDialogClosed: TNotifyEvent read FOnDateDialogClosed write FOnDateDialogClosed;
  end;

  // 508 classes
  TORDayCombo = class (TORComboBox);
  TORMonthCombo = class (TORComboBox);
  TORYearEdit = class(TMaskEdit)
  private
    FTemplateField: boolean;
    procedure SetTemplateField(const Value: boolean);
  protected
    property TemplateField: boolean read FTemplateField write SetTemplateField;
  end;

  TORYearEditClass = Class of TORYearEdit;

  TORDateCombo = class(TCustomPanel, IORBlackColorModeCompatible)
  private
    FYearChanging: boolean;
    FMonthCombo: TORMonthCombo;
    FDayCombo: TORDayCombo;
    FYearEdit: TORYearEdit;
    FYearUD: TUpDown;
    FCalBtn: TORDateButton;
    FIncludeMonth: boolean;
    FIncludeDay: boolean;
    FIncludeBtn: boolean;
    FLongMonths: boolean;
    FMonth: integer;
    FDay: integer;
    FYear: integer;
    FCtrlsCreated: boolean;
    FOnChange: TNotifyEvent;
    FRebuilding: boolean;
    FTemplateField: boolean;
    FBlackColorMode: boolean;
    FORYearEditClass: TORYearEditClass;
    procedure SetIncludeBtn(const Value: boolean);
    procedure SetIncludeDay(Value: boolean);
    procedure SetIncludeMonth(const Value: boolean);
    procedure SetLongMonths(const Value: boolean);
    procedure SetDay(Value: integer);
    procedure SetMonth(Value: integer);
    procedure SetYear(const Value: integer);
    function GetFMDate: TFMDateTime;
    procedure SetFMDate(const Value: TFMDateTime);
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure SetTemplateField(const Value: boolean);
  protected
    procedure Rebuild; virtual;
    function InitDays(GetSize: boolean): integer;
    function InitMonths(GetSize: boolean): integer;
    function GetYearSize: integer;
    procedure DoChange;
    procedure MonthChanged(Sender: TObject);
    procedure DayChanged(Sender: TObject);
    procedure YearChanged(Sender: TObject);
    procedure BtnClicked(Sender: TObject);
    procedure YearUDChange(Sender: TObject; var AllowChange: Boolean;
                           NewValue: Smallint; Direction: TUpDownDirection);
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
    property ORYearEditClass: TORYearEditClass read FORYearEditClass write FORYearEditClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DateText: string;
    procedure SetBlackColorMode(Value: boolean);
    property TemplateField: boolean read FTemplateField write SetTemplateField;
    property FMDate: TFMDateTime read GetFMDate write SetFMDate;
  published
    function Text: string;
    property IncludeBtn: boolean read FIncludeBtn write SetIncludeBtn;
    property IncludeDay: boolean read FIncludeDay write SetIncludeDay;
    property IncludeMonth: boolean read FIncludeMonth write SetIncludeMonth;
    property LongMonths: boolean read FLongMonths write SetLongMonths default FALSE;
    property Month: integer read FMonth write SetMonth;
    property Day: integer read FDay write SetDay;
    property Year: integer read FYear write SetYear;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

procedure Register;

implementation

{$R *.DFM}
{$R ORDtTm}

const
  FMT_DATETIME = 'mmm d,yyyy@hh:nn';
  FMT_DATEONLY = 'mmm d,yyyy';
  AdjVertSize = 8;
  FontHeightText = 'BEFHILMSTVWXZfgjmpqtyk';

var
  uServerToday: TFMDateTime;
  FormatSettings: TFormatSettings;

{ Server-dependent functions ---------------------------------------------------------------- }

function ActiveBroker: Boolean;
begin
  Result := False;
  if (RPCBrokerV <> nil) and RPCBrokerV.Connected then Result := True;
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
  if ActiveBroker
    then Result := FMDateTimeToDateTime(ServerFMNow)
    else Result := Now;
end;

function ServerToday: TDateTime;
begin
  if uServerToday = 0 then uServerToday := Int(ServerFMNow);
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
  h,n,s,l: Word;
  ATime: string;
begin
  Offset := Trunc(Int(ADateTime) - Int(ServerToday));
  if Offset < 0 then Result := 'T' + IntToStr(Offset)
  else if Offset = 0 then Result := 'T'
  else Result := 'T+' + IntToStr(Offset);
  DecodeTime(ADateTime, h, n, s, l);
  ATime := Format('@%.2d:%.2d', [h, n]);
  if ATime <> '@00:00' then Result := Result + ATime;
end;

procedure LoadEllipsis(bitmap: TBitMap; BlackColorMode: boolean);
var
  ResName: string;
begin
  if BlackColorMode then
    ResName := 'BLACK_BMP_ELLIPSIS'
  else
    ResName := 'BMP_ELLIPSIS';
  bitmap.LoadFromResourceName(hInstance, ResName);
end;

{ TfrmORDtTm -------------------------------------------------------------------------------- }

procedure TORfrmDtTm.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  lstHour.TopIndex := 6;
  FFromSelf := False;
 // calSelectChange(Self);
  If ScreenReaderSystemActive then begin
     GetScreenReader.Speak(Label1.Caption);
  end;
end;

procedure TORfrmDtTm.calSelectChange(Sender: TObject);
begin
  lblDate.Caption := FormatDateTime('mmmm d, yyyy', calSelect.CalendarDate);
  FNowPressed := False;
  If ScreenReaderSystemActive then begin
     //TxtDateSelected.Caption := lblDate.Caption;
     TxtDateSelected.Caption := Label1.Caption + ' ' + lblDate.Caption;
     GetScreenReader.Speak(lblDate.Caption);
  end;
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

procedure TORfrmDtTm.imgPrevMonthMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlPrevMonth.BevelOuter := bvRaised;
end;

procedure TORfrmDtTm.imgNextMonthMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   pnlNextMonth.BevelOuter := bvRaised;
end;

procedure TORfrmDtTm.cmdTodayClick(Sender: TObject);
begin
  calSelect.CalendarDate := ServerToday;
  lstHour.ItemIndex := -1;
  lstMinute.ItemIndex := -1;
  txtTime.Text := '';
end;

procedure TORfrmDtTm.txtTimeChange(Sender: TObject);
begin
  if not FFromSelf then begin
    lstHour.ItemIndex := -1;
    lstMinute.ItemIndex := -1;
  end;
  FNowPressed := False;
end;

procedure TORfrmDtTm.lstHourClick(Sender: TObject);
begin
  if lstHour.ItemIndex = 0 then lstMinute.Items[0] := ':01  --' else lstMinute.Items[0] := ':00  --'; //<------ NEW CODE
  if lstMinute.ItemIndex < 0 then lstMinute.ItemIndex := 0;
  lstMinuteClick(Self);
end;

procedure TORfrmDtTm.lstMinuteClick(Sender: TObject);
var
  AnHour, AMinute: Integer;
begin
  if lstHour.ItemIndex >=  0 then begin
    AnHour := lstHour.ItemIndex;

    AMinute := lstMinute.ItemIndex * 5;
    if (AnHour = 0) and (AMinute = 0) then AMinute := 1;  //<-------------- NEW CODE
    FFromSelf := True;
    txtTime.Text := Format('%.2d:%.2d ', [AnHour, AMinute]);

    FFromSelf := False;
  end;
end;

procedure TORfrmDtTm.cmdNowClick(Sender: TObject);
begin
  calSelect.CalendarDate := ServerToday;
  txtTime.Text := FormatDateTime('hh:nn', ServerNow);        // if ampm time
  FNowPressed := True;
end;

procedure TORfrmDtTm.cmdMidnightClick(Sender: TObject);
begin
  txtTime.Text := '23:59';      // if military time
end;

procedure TORfrmDtTm.cmdOKClick(Sender: TObject);
var
  x: string;
begin
  if TimeIsRequired and (Length(txtTime.Text) = 0) then begin
    InfoBox('An entry for time is required.', 'Missing Time', MB_OK);
    Exit;
  end;
  if Length(txtTime.Text) > 0 then begin
    x := Trim(txtTime.Text);
    if (x='00:00') or (x='0:00') or (x='00:00:00') or (x='0:00:00') then x := '00:01';  //<------- CHANGED CODE
    StrToTime(x);
    txtTime.Text := x;
  end;
  ModalResult := mrOK;
end;

procedure TORfrmDtTm.cmdCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TORfrmDtTm.Loaded;
begin
  inherited Loaded;
  UpdateColorsFor508Compliance(Self);
end;

{ TORDateTimeDlg }

constructor TORDateTimeDlg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
    FDateTime := ServerToday
  else
    FDateTime  := SysUtils.Date;
end;

function TORDateTimeDlg.Execute: Boolean;
const
  HORZ_SPACING = 8;
var
  frmDtTm: TORfrmDtTm;
begin
  frmDtTm := TORfrmDtTm.Create(Application);
  try
    with frmDtTm do begin
      calSelect.CalendarDate := Int(FDateTime);
      if Frac(FDateTime) > 0
        //then txtTime.Text := FormatDateTime('h:nn ampm', FDateTime);  // if ampm time
        then txtTime.Text := FormatDateTime('hh:nn', FDateTime);        // if military time
      if RequireTime then TimeIsRequired := True;
      if DateOnly then begin
        txtTime.Visible     := False;
        lstHour.Visible     := False;
        lstMinute.Visible   := False;
        cmdNow.Visible      := False;
        cmdMidnight.Visible := False;
        bvlFrame.Width := bvlFrame.Width - txtTime.Width - HORZ_SPACING;
        cmdOK.Left := cmdOK.Left - txtTime.Width - HORZ_SPACING;
        cmdCancel.Left := cmdOK.Left;
        ClientWidth := ClientWidth - txtTime.Width - HORZ_SPACING;
      end;
      Result := (ShowModal = IDOK);
      if Result then begin
        FDateTime := Int(calSelect.CalendarDate);
        if Length(txtTime.Text) > 0 then FDateTime := FDateTime + StrToTime(txtTime.Text);
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
  if FDateOnly then begin
    FRequireTime := False;
    FDateTime := Int(FDateTime);
  end;
end;

procedure TORDateTimeDlg.SetFMDateTime(Value: TFMDateTime);
begin
  if Value > 0 then FDateTime := FMDateTimeToDateTime(Value);
end;

procedure TORDateTimeDlg.SetRequireTime(Value: Boolean);
begin
  FRequireTime := Value;
  if FRequireTime then FDateOnly := False;
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
  FButton := TORDateButton.Create(Self);
  FButton.Parent := Self;
  FButton.Width := 18;
  FButton.Height := 17;
  FButton.OnClick := ButtonClick;
  FButton.TabStop := False;
  FBlackColorMode := False;
  LoadEllipsis(FButton.Glyph, FALSE);
  FButton.Visible := True;
  FFormat := FMT_DATETIME;
end;

procedure TORDateBox.WMSize(var Message: TWMSize);
var
  ofs: integer;

begin
  inherited;
  if assigned(FButton) then begin
    if BorderStyle = bsNone then
      ofs := 0
    else
      ofs := 4;
    FButton.SetBounds(Width - FButton.Width - ofs, 0, FButton.Width, Height - ofs);
  end;
  SetEditRect;
end;

procedure TORDateBox.SetTemplateField(const Value: boolean);
var
  Y: integer;

begin
  if(FTemplateField <> Value) then begin
    FTemplateField := Value;
    Y := TextHeightByFont(Font.Handle, FontHeightText);
    if Value then begin
      FButton.Width := Y+2;
      Height := Y;
      BorderStyle := bsNone;
    end else begin
      FButton.Width := 18;
      Height := y + AdjVertSize;
      BorderStyle := bsSingle;
    end;
  end;
end;

function TORDateBox.SupportsDynamicProperty(PropertyID: integer): boolean;
begin
  Result := (PropertyID = DynaPropAccesibilityCaption);
end;

procedure TORDateBox.ButtonClick(Sender: TObject);
var
  DateDialog: TORDateTimeDlg;
  ParsedDate: TFMDateTime;
begin
  DateDialog := TORDateTimeDlg.Create(Application);
  if Length(Text) > 0 then begin
    ParsedDate := ServerParseFMDate(Text);
    if ParsedDate > -1 then FFMDateTime := ParsedDate else FFMDateTime := 0;
  end;
  DateDialog.DateOnly := FDateOnly;
  DateDialog.FMDateTime := FFMDateTime;
  DateDialog.RequireTime := FRequireTime;
  if DateDialog.Execute then begin
    FFMDateTime := DateDialog.FMDateTime;
    UpdateText;
    FTimeIsNow := DateDialog.RelativeTime = 'NOW';
  end;
  DateDialog.Free;
  if Assigned(OnDateDialogClosed) then OnDateDialogClosed(Self);
  if Visible and Enabled then //Some events may hide the component
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
  if (Key = VK_RETURN) then begin
    FButton.Click;
    Key := 0;
  end;
end;

procedure TORDateBox.KeyPress(var Key: Char);
begin
 if Key = #13 then Key := #0;
 inherited;
end;

function TORDateBox.GetFMDateTime: TFMDateTime;
begin
  Result := 0;
  if Length(Text) > 0 then Result := ServerParseFMDate(Text);
  FFMDateTime := Result;
end;

function TORDateBox.GetRelativeTime: string;
begin
  Result := '';
  if FTimeIsNow then Result := 'NOW'
  else if UpperCase(Text) = 'NOW' then Result := 'NOW'
  else if Length(Text) > 0 then begin
    FFMDateTime := ServerParseFMDate(Text);
    if FFMDateTime > 0 then Result := RelativeDateTime(FMDateTimeToDateTime(FFMDateTime));
  end;
end;

procedure TORDateBox.SetDateOnly(Value: Boolean);
begin
  FDateOnly := Value;
  if FDateOnly then begin
    FRequireTime := False;
    FFMDateTime := Int(FFMDateTime);
    if FFormat = FMT_DATETIME then FFormat := FMT_DATEONLY;
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
  if FRequireTime then begin
    if FFormat = FMT_DATEONLY then FFormat := FMT_DATETIME;
    SetDateOnly(False);
  end;
end;

procedure TORDateBox.SetEditRect;
{ change the edit rectangle to not hide the calendar button - taken from SPIN.PAS sample }
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;               // +1 is workaround for windows paint bug
  Loc.Right  := FButton.Left - 2;
  Loc.Top    := 0;
  Loc.Left   := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TORDateBox.UpdateText;
begin
  if FFMDateTime > 0 then begin
    if (FFormat =FMT_DATETIME) and (Frac(FFMDateTime) = 0) then
      Text := FormatFMDateTime(FMT_DATEONLY, FFMDateTime)
    else
      Text := FormatFMDateTime(FFormat, FFMDateTime);
  end;
end;

procedure TORDateBox.Validate(var ErrMsg: string);
begin
  ErrMsg := '';
  if Length(Text) > 0 then begin
   {
!!!!!! THIS HAS BEEN REMOVED AS IT CAUSED PROBLEMS WITH REMINDER DIALOGS - ZZZZZZBELLC !!!!!!
    //We need to make sure that there is a date entered before parse
    if FRequireTime and ((Pos('@', Text) = 0) or (Length(Piece(Text, '@', 1)) = 0)) then
     ErrMsg := 'Date Required';
    }
    FFMDateTime := ServerParseFMDate(Text);
    if FFMDateTime <= 0 then Errmsg := 'Invalid Date/Time';
    if FRequireTime and (Frac(FFMDateTime) = 0) then ErrMsg := 'Time Required';
    if FDateOnly    and (Frac(FFMDateTime) > 0) then ErrMsg := 'Time not Required';
  end;
end;

function TORDateBox.IsValid: Boolean;
var
  x: string;
begin
  Validate(x);
  Result := (Length(x) = 0);
  if (Length(Text) = 0) then Result := False;
end;

procedure TORDateBox.SetBlackColorMode(Value: boolean);
begin
  if FBlackColorMode <> Value then begin
    FBlackColorMode := Value;
    LoadEllipsis(FButton.Glyph, FBlackColorMode);
  end;
end;

procedure TORDateBox.SetCaption(const Value: string);
begin
  if not Assigned(FCaption) then begin
     FCaption := TStaticText.Create(self);
     FCaption.AutoSize := False;
     FCaption.Height := 0;
     FCaption.Width  := 0;
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
    result := FCaption.Caption;
end;

function TORDateBox.GetDynamicProperty(PropertyID: integer): string;
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
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  if(AYear < 1) or (AMonth < 1) then
    Result := 0
  else begin
    Result := DaysInMonth[AMonth];
    if (AMonth = 2) and IsLeapYear(AYear) then Inc(Result); { leap-year Feb is special }
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

procedure TORYearEdit.SetTemplateField(const Value: boolean);
begin
  if(FTemplateField <> Value) then begin
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
  FIncludeMonth := TRUE;
  FIncludeDay := TRUE;
  FIncludeBtn := TRUE;
  OnResize := Resized;
  FORYearEditClass := TORYearEdit;
end;

destructor TORDateCombo.Destroy;
begin
  if assigned(FMonthCombo) then FMonthCombo.Free;
  if assigned(FDayCombo) then FDayCombo.Free;
  if assigned(FYearEdit) then FYearEdit.Free;
  if assigned(FYearUD) then FYearUD.Free;
  if assigned(FCalBtn) then FCalBtn.Free;
  inherited;
end;

function TORDateCombo.GetYearSize: integer;
begin
  Result := TextWidthByFont(Font.Handle, '8888') + EditAdjHorzSize;
end;

function TORDateCombo.InitDays(GetSize: boolean): integer;
var
  dy: integer;
begin
  Result := 0;
  if(assigned(FDayCombo)) then begin
    dy := DaysPerMonth(FYear, FMonth) + 1;
    while (FDayCombo.Items.Count < dy) do begin
      if(FDayCombo.Items.Count = 0) then
        FDayCombo.Items.Add(' ')
      else
        FDayCombo.Items.Add(inttostr(FDayCombo.Items.Count));
    end;
    while (FDayCombo.Items.Count > dy) do
      FDayCombo.Items.Delete(FDayCombo.Items.Count-1);
    if(GetSize) then
      Result := TextWidthByFont(Font.Handle, '88') + ComboBoxAdjSize;
    if(FDay > (dy-1)) then
      SetDay(dy-1);
  end;
end;

function TORDateCombo.InitMonths(GetSize: boolean): integer;
var
  i, Size: integer;
begin
  Result := 0;
  if(assigned(FMonthCombo)) then begin
    FMonthCombo.Items.Clear;
    FMonthCombo.Items.Add(' ');
    for i := 1 to 12 do begin
      if FLongMonths then
        FMonthCombo.Items.Add(FormatSettings.LongMonthNames[i])
      else
        FMonthCombo.Items.Add(FormatSettings.ShortMonthNames[i]);
      if GetSize then begin
        Size := TextWidthByFont(Font.Handle, FMonthCombo.Items[i]);
        if(Result < Size) then
          Result := Size;
      end;
    end;
    if GetSize then
      inc(Result, ComboBoxAdjSize);
  end;
end;

procedure TORDateCombo.Rebuild;
var
  Wide, X, Y: integer;

begin
  if(not FRebuilding) then begin
    FRebuilding := True;
    try
      ControlStyle := ControlStyle + [csAcceptsControls];
      try
        Y := TextHeightByFont(Font.Handle, FontHeightText);
        if not FTemplateField then
          inc(Y,AdjVertSize);
        X := 0;
        if (FIncludeMonth) then begin
          if (not assigned(FMonthCombo)) then begin
            FMonthCombo := TORMonthCombo.Create(Self);
            FMonthCombo.Parent := Self;
            FMonthCombo.Top := 0;
            FMonthCombo.Left := 0;
            FMonthCombo.Style := orcsDropDown;
            FMonthCombo.DropDownCount := 13;
            FMonthCombo.ListItemsOnly := True;
            FMonthCombo.OnChange := MonthChanged;
          end;
          FMonthCombo.Font := Font;
          FMonthCombo.TemplateField := FTemplateField;
          Wide := InitMonths(TRUE);
          FMonthCombo.Width := Wide;
          FMonthCombo.Height := Y;
          FMonthCombo.ItemIndex := FMonth;
          inc(X, Wide + DateComboCtrlGap);

          if (FIncludeDay) then begin
            if (not assigned(FDayCombo)) then begin
              FDayCombo := TORDayCombo.Create(Self);
              FDayCombo.Parent := Self;
              FDayCombo.Top := 0;
              FDayCombo.Style := orcsDropDown;
              FDayCombo.ListItemsOnly := True;
              FDayCombo.OnChange := DayChanged;
              FDayCombo.DropDownCount := 11;
            end;
            FDayCombo.Font := Font;
            FDayCombo.TemplateField := FTemplateField;
            Wide := InitDays(TRUE);
            FDayCombo.Width := Wide;
            FDayCombo.Height := Y;
            FDayCombo.Left := X;
            FDayCombo.ItemIndex := FDay;
            inc(X, Wide + DateComboCtrlGap);
          end else if assigned(FDayCombo) then begin
            FDayCombo.Free;
            FDayCombo := nil;
          end;
        end else begin
          if assigned(FDayCombo) then begin
            FDayCombo.Free;
            FDayCombo := nil;
          end;
          if assigned(FMonthCombo) then begin
            FMonthCombo.Free;
            FMonthCombo := nil;
          end;
        end;
        if (not assigned(FYearEdit)) then begin
          FYearEdit := FORYearEditClass.Create(Self);
          FYearEdit.Parent := Self;
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
        inc(X, Wide);
        if (not assigned(FYearUD)) then begin
          FYearUD := TUpDown.Create(Self);
          FYearUD.Parent := Self;
          FYearUD.Thousands := FALSE;
          FYearUD.Min := FirstYear-1;
          FYearUD.Max := LastYear;
          FYearUD.OnChangingEx := YearUDChange;
        end;
        FYearEdit.TabOrder := 0;
        FYearUD.Top := 0;
        FYearUD.Left := X;
        FYearUD.Height := Y;
        FYearUD.Position := FYear;
        inc(X, FYearUD.Width + DateComboCtrlGap);
        if (FIncludeBtn) then begin
          if (not assigned(FCalBtn)) then begin
            FCalBtn := TORDateButton.Create(Self);
            FCalBtn.TabStop := FALSE;
            FCalBtn.Parent := Self;
            FCalBtn.Top := 0;
            LoadEllipsis(FCalBtn.Glyph, FBlackColorMode);
            FCalBtn.OnClick := BtnClicked;
          end;
          Wide := FYearEdit.Height;
          if(Wide > Y) then Wide := Y;
          FCalBtn.Width := Wide;
          FCalBtn.Height := Wide;
          FCalBtn.Left := X;
          inc(X, Wide + DateComboCtrlGap);
        end else if assigned(FCalBtn) then begin
          FCalBtn.Free;
          FCalBtn := nil;
        end;
        Self.Width := X - DateComboCtrlGap;
        Self.Height := Y;
        CheckDays;
        FCtrlsCreated := TRUE;
        DoChange;
      finally
        ControlStyle := ControlStyle - [csAcceptsControls];
      end;
    finally
      FRebuilding := FALSE;
    end;
  end;
end;

procedure TORDateCombo.SetBlackColorMode(Value: boolean);
begin
  if FBlackColorMode <> Value then begin
    FBlackColorMode := Value;
    if assigned(FCalBtn) then
      LoadEllipsis(FCalBtn.Glyph, FBlackColorMode);
  end;
end;

procedure TORDateCombo.SetDay(Value: integer);
begin
  if (not assigned(FDayCombo)) and (not (csLoading in ComponentState)) then
    Value := 0;
  if (Value > DaysPerMonth(FYear, FMonth)) then
    Value := 0;
  if (FDay <> Value) then begin
    FDay := Value;
    if(assigned(FDayCombo)) then begin
      if(FDayCombo.Items.Count <= FDay) then
        InitDays(FALSE);
      FDayCombo.ItemIndex := FDay;
    end;
    DoChange;
  end;
end;

procedure TORDateCombo.SetIncludeBtn(const Value: boolean);
begin
  if(FIncludeBtn <> Value) then begin
    FIncludeBtn := Value;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetIncludeDay(Value: boolean);
begin
  if(Value) and (not FIncludeMonth) then
    Value := FALSE;
  if(FIncludeDay <> Value) then begin
    FIncludeDay := Value;
    if(not Value) then FDay := 0;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetIncludeMonth(const Value: boolean);
begin
  if(FIncludeMonth <> Value) then begin
    FIncludeMonth := Value;
    if(not Value) then begin
      FIncludeDay := FALSE;
      FMonth := 0;
      FDay := 0;
    end;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetMonth(Value: integer);
begin
  if(not assigned(FMonthCombo)) and (not (csLoading in ComponentState)) then
    Value := 0;
  if(Value <0) or (Value > 12) then
    Value := 0;
  if(FMonth <> Value) then begin
    FMonth := Value;
    if(assigned(FMonthCombo)) then
      FMonthCombo.ItemIndex := FMonth;
    CheckDays;
    DoChange;
  end;
end;

procedure TORDateCombo.SetLongMonths(const Value: boolean);
begin
  if(FLongMonths <> Value) then begin
    FLongMonths := Value;
    Rebuild;
  end;
end;

procedure TORDateCombo.SetYear(const Value: integer);
begin
  if(FYear <> Value) then begin
    FYear := Value;
    if(FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if(not FYearChanging) and (assigned(FYearEdit)) and (assigned(FYearUD)) then begin
      FYearChanging := True;
      try
        if(FYear = 0) then begin
          FYearEdit.Text := '    ';
          FYearUD.Position := FirstYear-1
        end else begin
          FYearEdit.Text := IntToStr(FYear);
          FYearUD.Position := FYear;
        end;
      finally
        FYearChanging := FALSE;
      end;
    end;
    if(FMonth = 2) then
      InitDays(FALSE);
    CheckDays;
    DoChange;
  end;
end;

procedure TORDateCombo.DayChanged(Sender: TObject);
begin
  FDay := FDayCombo.ItemIndex;
  if(FDay < 0) then
    FDay := 0;
  CheckDays;
  DoChange;
end;

procedure TORDateCombo.MonthChanged(Sender: TObject);
begin
  FMonth := FMonthCombo.ItemIndex;
  if(FMonth < 0) then
    FMonth := 0;
  InitDays(FALSE);
  CheckDays;
  DoChange;
end;

procedure TORDateCombo.YearChanged(Sender: TObject);
begin
  if FYearChanging then exit;
  FYearChanging := True;
  try
    FYear := StrToIntDef(FYearEdit.Text, 0);
    if(FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if(FYear = 0) then
      FYearUD.Position := FirstYear-1
    else
      FYearUD.Position := FYear;
    if(FMonth = 2) then
      InitDays(FALSE);
    CheckDays;
    DoChange;
  finally
    FYearChanging := False;
  end;
end;

procedure TORDateCombo.CheckDays;
var
  MaxDays: integer;

begin
  if(FIncludeMonth and assigned(FMonthCombo)) then begin
    FMonthCombo.Enabled := (FYear > 0);
    if (FYear = 0) then
      SetMonth(0);
    if(FIncludeMonth and FIncludeDay and assigned(FDayCombo)) then begin
      FDayCombo.Enabled := ((FYear > 0) and (FMonth > 0));
      MaxDays := DaysPerMonth(FYear, FMonth);
      if(FDay > MaxDays) then
        SetDay(MaxDays);
    end;
  end;
end;

procedure TORDateCombo.Loaded;
begin
  inherited;
  if(not FCtrlsCreated) then
    Rebuild;
end;

procedure TORDateCombo.Paint;
begin
  if(not FCtrlsCreated) then
    Rebuild;
  inherited;
end;

procedure TORDateCombo.BtnClicked(Sender: TObject);
var
  mm, dd, yy: integer;
  m, d, y: word;
  DateDialog: TORDateTimeDlg;
begin
  DateDialog := TORDateTimeDlg.Create(self);
  try
    mm := FMonth;
    dd := FDay;
    yy := FYear;
    DecodeDate(Now, y, m, d);
    if(FYear = 0) then FYear := y;
    if(FYear = y) then begin
      if((FMonth = 0) or (FMonth = m)) and (FDay = 0) then begin
        FMonth := m;
        FDay := d;
      end;
    end;
    if(FMonth = 0) then
      FMonth := 1;
    if(FDay = 0) then
      FDay := 1;
    DateDialog.FMDateTime := GetFMDate;
    DateDialog.DateOnly := True;
    DateDialog.RequireTime := False;
    if DateDialog.Execute then begin
      FYear := 0;
      FMonth := 0;
      FDay := 0;
      SetFMDate(DateDialog.FMDateTime);
    end else begin
      SetYear(yy);
      SetMonth(mm);
      SetDay(dd);
    end;
  finally
    DateDialog.Free;
  end;
end;

procedure TORDateCombo.YearUDChange(Sender: TObject; var AllowChange: Boolean;
                                    NewValue: Smallint; Direction: TUpDownDirection);
var
  y, m, d: word;
begin
  if FYearChanging then exit;
  FYearChanging := True;
  try
    if FYearUD.Position = (FirstYear-1) then begin
      DecodeDate(Now, y, m, d);
      FYear := y;
      FYearUD.Position := y;
      AllowChange := False;
    end
    else
      FYear := NewValue;
    if(FYear < FirstYear) or (FYear > LastYear) then
      FYear := 0;
    if(FYear = 0) then
      FYearEdit.Text := '    '
    else
      FYearEdit.Text := IntToStr(FYear);
    if(FMonth = 2) then
      InitDays(FALSE);
    CheckDays;
    DoChange;
  finally
    FYearChanging := FALSE;
  end;
end;

procedure TORDateCombo.YearKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['0'..'9']) and (FYearEdit.Text = '    ') then begin
    FYearEdit.Text := Key + '   ';
    Key := #0;
    FYearEdit.SelStart := 1;
    FYearEdit.SelText := '';
  end;
end;

function TORDateCombo.GetFMDate: TFMDateTime;
begin
  if(FYear < FirstYear) then
    Result := 0
  else
    Result := ((FYear - 1700) * 10000 + FMonth * 100 + FDay);
end;

procedure TORDateCombo.SetFMDate(const Value: TFMDateTime);
var
  ival, mo, dy: integer;
begin
  if(Value = 0) then begin
    SetYear(0);
    SetMonth(0);
  end else begin
    ival := trunc(Value);
    if(length(IntToStr(ival)) <> 7) then
      exit;
    dy := (ival mod 100);
    ival := ival div 100;
    mo := ival mod 100;
    ival := ival div 100;
    SetYear(ival + 1700);
    SetMonth(mo);
    InitDays(FALSE);
    SetDay(dy);
  end;
end;

function TORDateCombo.DateText: string;
begin
  Result := '';
  if(FYear > 0) then begin
    if(FMonth > 0) then begin
      if FLongMonths then
        Result := FormatSettings.LongMonthNames[FMonth]
      else
        Result := FormatSettings.ShortMonthNames[FMonth];
      if(FDay > 0) then
        Result := Result + ' ' + IntToStr(FDay);
      Result := Result + ', ';
    end;
    Result := Result + IntToStr(FYear);
  end;
end;

procedure TORDateCombo.DoChange;
begin
  if assigned(FOnChange) then
    FOnChange(Self);
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
  if(tmp <> '') and (tmp <> '0') and (length(Tmp) >= 7) then begin
    if FLongMonths then
      m := 'mmmm'
    else
      m := 'mmm';
    if(copy(tmp,4,4) = '0000') then
      fmt := 'yyyy'
    else
    if(copy(tmp,6,2) = '00') then
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

procedure TORDateCombo.SetTemplateField(const Value: boolean);
begin
  if FTemplateField <> Value then begin
    FTemplateField := Value;
    Rebuild;
  end;
end;

initialization
  uServerToday := 0;
  FormatSettings := TFormatSettings.Create;

end.

unit fSurrogateEdit;

{
  This unit implements class TfrmSurrogateEdit that provides data for
  Surrogate Management Functionality within CPRS Graphical User Interface (GUI)
  (Request #20071216)
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager,
  Vcl.StdCtrls, ORDtTm, ORCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, ORDtTmRng,
  System.Actions, Vcl.ActnList;

const
  fmtListDateTimeControls = 'mmm dd.yyyy@hh:nn';

type
  TfrmSurrogateEdit = class(TfrmBase508Form)
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlSurrogateTools: TPanel;
    cboSurrogate: TORComboBox;
    ordtbStart: TORDateBox;
    ordtbStop: TORDateBox;
    VA508StaticText1: TStaticText;
    VA508StaticText2: TStaticText;
    VA508StaticTextName: TStaticText;
    btnReset: TButton;
    stxtAllowedRange: TLabel;
    ALMain: TActionList;
    ActionReset: TAction;
    txtOK: TStaticText;
    txtCancel: TStaticText;
    txtReset: TStaticText;
    procedure ordtbStartDateDialogClosed(Sender: TObject);
    procedure ordtbStopDateDialogClosed(Sender: TObject);
    procedure cboSurrogateNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cboSurrogateChange(Sender: TObject);
    procedure ALMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure ActionResetExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fData: string;
    FStart: TDateTime;
    FStop: TDateTime;
    FMin: TDateTime;
    FMax: TDateTime;
    FSurrogate: string;
    FIsLastRecord: Boolean;
    fUseDefaultPeriod: Boolean;
    procedure setValues(const aName, aStart, aStop, aMin, aMax, aData: string;
      bLast, bUseDefaults: Boolean); overload;
    procedure SetValues(const AName: string; AStart, AStop, AMin, AMax:
      TDateTime; const AData: string; AIsLastRecord, AUseDefaultPeriod:
      Boolean); overload;
    procedure setButtonStatus;
    procedure Update508;
  end;

var
  defaultSurrPeriod: Integer = 7; // days to plan ahead   //  V32 Defect 101 SDS 4/3/2017 - change from 1 month to 1 week

function editSurrogate(var aSurrogate, aStart, aStop, aMin, aMax, aData: String;
  bLast: Boolean; useDefaultDates: Boolean): Integer;

implementation

uses
  Math, ORFn, rCore, System.UITypes, fOptionsSurrogate, uORLists, uSimilarNames,
  System.DateUtils,
  VAUtils;

{$R *.dfm}

function editSurrogate(var aSurrogate, aStart, aStop, aMin, aMax, aData: String;
  bLast: Boolean; useDefaultDates: Boolean): Integer;
var
  frmSurrogateEdit: TfrmSurrogateEdit;
begin
  Application.CreateForm(TfrmSurrogateEdit, frmSurrogateEdit);
  try
    ResizeAnchoredFormToFont(frmSurrogateEdit);
    with frmSurrogateEdit do
    begin
      setValues(aSurrogate, aStart, aStop, aMin, aMax, aData, bLast, UseDefaultDates);
      Result := ShowModal;
      if Result = mrOK then
      begin
        aData := cboSurrogate.ItemID;
        aSurrogate := cboSurrogate.Text;
        aStart := FormatDateTime(fmtListDateTimeSec, ordtbStart.DateSelected);
        if Trim(ordtbStop.Text) = '' then begin
          aStop := '';
        end else begin
          aStop := FormatDateTime(fmtListDateTimeSec, ordtbStop.DateSelected);
        end;
      end;
    end;
  finally
    FreeAndNil(frmSurrogateEdit);
  end;
end;

procedure TfrmSurrogateEdit.setValues(const AName: string; AStart, AStop, AMin,
  AMax: TDateTime; const AData: string; AIsLastRecord, AUseDefaultPeriod: Boolean);
var
  ATarget: string;
begin
  FSurrogate := AName;
  FData := AData;
  FIsLastRecord := AIsLastRecord;
  FUseDefaultPeriod := AUseDefaultPeriod;
  FMin := AMin;
  FMax := AMax;
  if (FMax > 0) and (FMin >= FMax) then
    raise Exception.Create('Min must be before Max');

  FStart := AStart;
  if (FStart <= 0) and FUseDefaultPeriod then FStart := FMin; // use the default period
  if FStart > 0 then FStart := Max(AMin, AStart); // Move start up to min range

  FStop := AStop;
  if (FStop <= 0) and (FStart > 0) and FUseDefaultPeriod then
    FStop := FStart + defaultSurrPeriod; // use the default period
  if FMax > 0 then FStop := Min(FStop, FMax); // Move stop back to max range

  ordtbStart.DateRange.MinDate := FMin;
  if FMax > 0 then ordtbStart.DateRange.MaxDate := IncMinute(FMax, -1);
  if FStart > 0 then begin
    ordtbStart.DateSelected := FStart;
    ordtbStart.Text := FormatDateTime(fmtListDateTimeControls, FStart);
  end else begin
    ordtbStart.DateSelected := FMin; // start at the valid range
    ordtbStart.Text := '';
  end;

  ordtbStop.DateRange.MinDate := IncMinute(FMin);
  if FMax > 0 then ordtbStop.DateRange.MaxDate := FMax;
  if FStop > 0 then begin
    ordtbStop.DateSelected := FStop;
    ordtbStop.Text := FormatDateTime(fmtListDateTimeControls, FStop);
  end else begin
    ordtbStop.DateSelected := ordtbStart.DateSelected; // start at the valid range
    ordtbStop.Text := '';
  end;

  ATarget := piece(aName, ',', 1);
  if Length(ATarget) > 1 then
    ATarget := Copy(ATarget, 1, Length(ATarget) - 1);
  if AData = '' then // v32 Defect 101, SDS 4/10/2017 - avoid dropdown list trying to select "dbl..."
    cboSurrogate.InitLongList('')
  else
    cboSurrogate.InitLongList(ATarget);
  cboSurrogate.SelectByID(FData);
  TSimilarNames.RegORComboBox(cboSurrogate);

  // V32 Issue 101, SDS 4/4/2017
  if FMax > 0 then begin
    stxtAllowedRange.Caption := Format(
      'Start and stop times must be within this range...: '#13#10+
        '%s (earliest) '#13#10'%s (latest)',
      [FormatDateTime(fmtListDateTime, FMin),
        FormatDateTime(fmtListDateTime, FMax)]);
  end else begin
    stxtAllowedRange.Caption := Format(
      'Start time must be on or after: '#13#10'%s',
      [FormatDateTime(fmtListDateTime, FMin)]);
  end;

  amgrMain.AccessText[ordtbStart] := Format(
    'Surrogate Start Date and Time must be on or after %s. '+
    'Press the enter key to access.',
    [FormatDateTime(fmtListDateTime, FMin)]);
  if FMax > 0 then begin
    amgrMain.AccessText[ordtbStop] := Format(
      'Surrogate Stop Date and Time must be no later than %s. '+
      'Press the enter key to access.',
      [FormatDateTime(fmtListDateTime, FMax)]);
    stxtAllowedRange.Caption := Format(
      'Start and stop times must be within this range...: '#13#10+
        '%s (earliest) '#13#10'%s (latest)',
      [FormatDateTime(fmtListDateTime, FMin),
        FormatDateTime(fmtListDateTime, FMax)]);
  end else begin
    stxtAllowedRange.Caption := Format(
      'Start time must be on or after: '#13#10'%s',
      [FormatDateTime(fmtListDateTime, FMin)]);
  end;

  setButtonStatus;

  ordtbStopDateDialogClosed(nil);
  ordtbStartDateDialogClosed(nil);
end;

procedure TfrmSurrogateEdit.Update508;
begin
  txtOK.Visible := ScreenReaderActive and (not btnOK.Enabled);
  txtCancel.Visible := ScreenReaderActive and (not btnCancel.Enabled);
  txtReset.Visible := ScreenReaderActive and (not btnReset.Enabled);
end;

procedure TfrmSurrogateEdit.setValues(const aName, aStart, aStop, aMin, aMax,
  aData: String; bLast, bUseDefaults: Boolean);
var
  dtStart, dtStop, dtMin, dtMax: TDateTime;
begin
  if aStart = '' then dtStart := 0 else dtStart := StrDateToDate(aStart);
  if aStop = '' then dtStop := 0 else dtStop := StrDateToDate(aStop);
  if aMin = '' then dtMin := 0 else dtMin := StrDateToDate(aMin);
  if aMax = '' then dtMax := 0 else dtMax := StrDateToDate(aMax);
  SetValues(aName, dtStart, dtStop, dtMin, dtMax, aData, bLast, bUseDefaults);
end;

procedure TfrmSurrogateEdit.ActionResetExecute(Sender: TObject);
// V32 defect 101 SDS
begin
  inherited;
  setValues(fSurrogate, fStart, fStop, fMin, fMax, fData, FIsLastRecord,
    fUseDefaultPeriod);
end;

procedure TfrmSurrogateEdit.ALMainUpdate(Action: TBasicAction; var Handled: Boolean);
// V32 defect 101 SDS
// the action list onUpdate method is called when the Delphi event loop is idle
begin
  inherited;
  actionReset.Enabled := (piece(cboSurrogate.Text, ' ', 1) <> fSurrogate) or
    (ordtbStop.DateSelected <> FStop) or
    (ordtbStart.DateSelected <> FStart);
  Update508;
end;

procedure TfrmSurrogateEdit.cboSurrogateChange(Sender: TObject);
begin
  inherited;
  setButtonStatus;
end;

procedure TfrmSurrogateEdit.cboSurrogateNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  inherited;
  setPersonList(cboSurrogate, StartFrom, Direction);
end;

procedure TfrmSurrogateEdit.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Const
  MsgMain = 'The following error(s) occurred.' + CRLF+CRLF;
var
  msg, ErrMsg: String;

  function DateTimeErrorReport(aSelector: TORDateBox): String;
  var
    FMDT: TFMDateTime;
    DateBx: String;
  begin
    if not assigned(aSelector) then begin
      Result := 'Selector was not defined'
    end else begin
      if aSelector = ordtbStart then begin
        DateBx := 'Start Date/Time'
      end else begin
        DateBx := 'End Date/Time';
      end;
      if Trim(aSelector.Text) = '' then begin
        if aSelector <> ordtbStop then begin
          Result := DateBx + ' Required' + CRLF
        end;
      end else begin
        FMDT := ServerParseFMDate(aSelector.Text);
        if FMDT < 0 then begin
          Result := 'Invalid '+ DateBx +' of ' + aSelector.Text + CRLF
        end else begin
          Result := '';
          aSelector.DateSelected := FmDateTimeToDateTime(FMDT);
          aSelector.Validate(Result);
          if Result <> '' then
            Result := DateBx +': '+ Result + CRLF;
        end;
      end;
    end;
  end;

begin
  inherited;
  if modalResult = mrCancel then // V32 Defect 101 SDS use modal result instead of FCancel, so X at top right works
    exit;

  msg := msg + DateTimeErrorReport(ordtbStart);
  msg := msg + DateTimeErrorReport(ordtbStop);

  if not CheckForSimilarName(cboSurrogate, ErrMsg, sPr) then
  begin
    if ErrMsg <> '' then
      msg := msg + ErrMsg + CRLF;
  end;

  if (cboSurrogate.Text = '') or (cboSurrogate.ItemID = 0) then
    msg := msg + 'Please Select the Surrogate Name' + CRLF;
  if (Trim(ordtbStop.Text) <> '') and (ordtbStop.DateSelected <= ordtbStart.DateSelected) then
    msg := msg + 'Start Date can''t be greater than or equal to Stop date' + CRLF;
  CanClose := msg = '';
  if not CanClose then
  begin
    msg := MsgMain + msg;
    MessageDLG(msg, mtError, [mbOK], 0);
  end;
end;

procedure TfrmSurrogateEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Update508;
end;

procedure TfrmSurrogateEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmSurrogateEdit.FormShow(Sender: TObject);
var
  i: LongInt;
begin
  inherited;
  // cboSurrogate.InitLongList(fSurrogate); V32 Defect 101  SDS - redundant, done in setupData
  i := StrToIntDef(fData, -1);
  if i > -1 then
  begin
    cboSurrogate.SelectByIEN(i);
    TSimilarNames.RegORComboBox(cboSurrogate);
  end;
  cboSurrogate.SetFocus;
  Update508;
end;

procedure TfrmSurrogateEdit.ordtbStartDateDialogClosed(Sender: TObject);
var
  AStartDate: TDateTime;
begin
  inherited;
  AStartDate := ordtbStart.DateSelected;
  if AStartDate > 0 then
  begin
    ordtbStop.DateRange.MinDate := IncMinute(AStartDate);
    if ordtbStop.DateSelected < ordtbStop.DateRange.MinDate then
    begin
      ordtbStop.DateSelected := ordtbStop.DateRange.MinDate;
      ordtbStop.Text := ''; // this will make it included in the next section
    end;

    if FUseDefaultPeriod and (Trim(ordtbStop.Text) = '') then
    begin
      ordtbStop.DateSelected := AStartDate + defaultSurrPeriod; // use the default period
      if FMax > 0 then ordtbStop.DateSelected :=
        Min(ordtbStop.DateSelected, FMax); // Move stop back to max range
      ordtbStop.Text :=
        FormatDateTime(fmtListDateTimeControls, ordtbStop.DateSelected);
    end;
  end;
end;

procedure TfrmSurrogateEdit.ordtbStopDateDialogClosed(Sender: TObject);
var
  dt: TDateTime;
begin
  inherited;
  dt := ordtbStop.DateSelected;
  if dt = 0 then Exit; // RDD: this does nothing????
//  bug not allowing to go to the future
//  ordtbStart.DateRange.MaxDate := dt;
end;

procedure TfrmSurrogateEdit.setButtonStatus;
begin
  btnOK.Enabled := cboSurrogate.Text <> '';
  Update508;
end;

end.

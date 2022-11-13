unit fAlertRangeEdit;

{
  This unit implements class TfrmAlertRangeEdit that provides data for
  Notification Alert Processing Improvement (GUI)
  (Request #20081008)
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fBase508Form, VA508AccessibilityManager,
  Vcl.StdCtrls, ORDtTm, ORCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, ORDtTmRng,
  Vcl.Buttons;

type
  ECPRSInvalidDate = class(Exception);

  TfrmAlertRangeEdit = class(TfrmBase508Form)
    pnlBottom: TPanel;
    bvlBottom: TBevel;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    ordtbStart: TORDateBox;
    ordtbStop: TORDateBox;
    stxtStart: TVA508StaticText;
    stxtStop: TVA508StaticText;
    stxtChanged: TStaticText;
    btnRestore: TButton;
    stxtRangeInfo: TVA508StaticText;
    stxtRange: TVA508StaticText;
    pnlTop: TPanel;
    stxtRangeHint: TVA508StaticText;
    procedure btnRestoreClick(Sender: TObject);
    procedure ordtbStartDateDialogClosed(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    fStart,
    fStop,
    fMin,
    fMax: String;

    procedure setValues(aStart, aStop, aMin, aMax: String);
    procedure validateUserDate(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmAlertRangeEdit: TfrmAlertRangeEdit;

const
  fmtDateTime = 'mm/dd/yyyy@hh:nn';
  fmtDateOnly = 'mmm dd yyyy';
  fmtLimit = 'Please note that range can''t exceed %d day(s) limit set for this site.';

  txtTitle = 'Date Range Selector';

  fmtErrorMinDate = 'Selected date "%s" can''t be before ';
  fmtErrorMaxDate = 'Selected date "%s" can''t be after ';
  fmtErrorRange = 'Selected date "%s" sould be within "%s - %s" range';

function editAlertRange(var aStart, aStop, aMin, aMax: String; Limit:Integer): Integer;
function StrDateToDate(aDate: String): TDateTime;

implementation

uses
  ORFn, ORNet, rCore, System.UITypes, fFrame;

{$R *.dfm}

function StrDateToDate(aDate: String): TDateTime;
var
  dtDate, dtTime: Real;
  sDate, sTime: String;
  delim: Char;
begin
  delim := '@';
  if pos('@', aDate) = 0 then
    delim := ' ';

  sDate := piece(aDate, delim, 1);
  sTime := piece(aDate, delim, 2);

  dtDate := strToDate(sDate);
  dtTime := strToTime(sTime);

  Result := dtDate + dtTime;
end;

function editAlertRange(var aStart, aStop, aMin, aMax: String; Limit:Integer): Integer;
begin
  if not assigned(frmAlertRangeEdit) then
    Application.CreateForm(TfrmAlertRangeEdit, frmAlertRangeEdit);
  try
    ResizeAnchoredFormToFont(frmAlertRangeEdit);
    with frmAlertRangeEdit do
    begin
      btnrestore.enabled := true;
      stxtRangeHint.Caption := Format(fmtLimit,[Limit]);
      setValues(aStart, aStop, aMin, aMax);
      Result := ShowModal;
      if Result = mrOK then
      begin
        aStart := FormatDateTime(fmtDateTime, ordtbStart.DateSelected);
        aStop := FormatDateTime(fmtDateTime, ordtbStop.DateSelected);
      end;
    end;
  finally
    frmAlertRangeEdit.Release;
    frmAlertRangeEdit := nil;
  end;
end;

procedure TfrmAlertRangeEdit.setValues(aStart, aStop, aMin, aMax: String);
var
  dtStart, dtStop, dtMin, dtMax: TDateTime;

begin
  fStart := aStart;
  fStop := aStop;
  fMin := aMin;
  fMax := aMax;

  dtStart := StrDateToDate(aStart);
  dtStop := StrDateToDate(aStop);
  dtMin := StrDateToDate(aMin) - 1.0; // including min date
  dtMax := trunc(StrDateToDate(aMax)) + 0.99999;

  ordtbStart.DateRange.MinDate := trunc(dtMin);
  ordtbStart.DateRange.MaxDate := dtStop;
  ordtbStart.DateSelected := dtStart;
  ordtbStart.DateOnly := True;
  ordtbStart.Text := FormatDateTime(fmtDateOnly, dtStart);
  ordtbStart.OnExit := validateUserDate;

  ordtbStop.DateRange.MinDate := dtStart;
  ordtbStop.DateRange.MaxDate := dtMax;
  ordtbStop.DateSelected := dtStop;
  ordtbStop.DateOnly := True;
  ordtbStop.Text := FormatDateTime(fmtDateOnly, dtStop);
  ordtbStop.OnExit := validateUserDate;

  stxtRange.Caption := FormatDateTime(fmtDateOnly,dtMin) + ' .. ' +
    FormatDateTime(fmtDateOnly,dtMax);
end;

procedure TfrmAlertRangeEdit.validateUserDate(Sender: TObject);
var
  sError, sDate, sMin, sMax: String;
  aFMDate: Double;
  aDateTime: TDateTime;

  function withinLimits(aValue: TDateTime): Boolean;
  begin
    sError := '';
    if (Sender = ordtbStart) and ((ordtbStop.DateSelected < aValue) or
      ( aValue < ordtbStart.DateRange.MinDate))then
      begin
        sDate := FormatDateTime(fmtDateOnly,aValue);
        sMin := FormatDateTime(fmtDateOnly,ordtbStart.DateRange.MinDate);
        sMax := FormatDateTime(fmtDateOnly,ordtbStop.DateSelected);
        sError := Format(fmtErrorRange, [sDate,sMin,sMax]);
      end;

    if (Sender = ordtbStop) and ((aValue < ordtbStart.DateSelected) or
      (ordtbStop.DateRange.MaxDate < aValue)) then
      begin
        sDate := FormatDateTime(fmtDateOnly,aValue);
        sMin := FormatDateTime(fmtDateOnly,ordtbStart.DateSelected);
        sMax := FormatDateTime(fmtDateOnly,ordtbStop.DateRange.MaxDate);
        sError := Format(fmtErrorRange, [sDate,sMin,sMax]);
      end;
    Result := sError = '';
  end;

begin
  if ActiveControl = btnCancel then
    exit;

  if Sender is TORDateBox then
    if TORDateBox(Sender).Text <> '' then
      try
        CallVistA('ORWU DT', [TORDateBox(Sender).Text], aFMDate);
        if aFMDate > -1 then
        begin
          aDateTime := FMDateTimeToDateTime(aFMDate);
          if withinLimits(aDateTime) then
          begin
            TORDateBox(Sender).FMDateTime := aFMDate;
            TORDateBox(Sender).DateSelected := aDateTime;
          end
          else
            raise ECPRSInvalidDate.CreateFmt('%s', [sError]);
        end
        else
          raise ECPRSInvalidDate.CreateFmt
            ('Value %s is not a valid fileman date', [TORDateBox(Sender).Text]);

        // correct ranges if data is valid
        if Sender = ordtbStart then
          ordtbStop.DateRange.MinDate := aDateTime
        else
          ordtbStart.DateRange.MaxDate := aDateTime

      except
        on E: ECPRSInvalidDate do
        begin
          InfoBox(E.Message, txtTitle, MB_OK + MB_ICONERROR);
          TORDateBox(Sender).SetFocus;
          TORDateBox(Sender).Text := FormatDateTime(fmtDateOnly,
            TORDateBox(Sender).DateSelected);
          stxtChanged.Visible := False;
        end;
        else
          raise;
      end;
end;

procedure TfrmAlertRangeEdit.btnRestoreClick(Sender: TObject);
begin
  inherited;
  setValues(fStart, fStop, fMin, fMax);
  stxtChanged.Visible := false;
end;

procedure TfrmAlertRangeEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmAlertRangeEdit.ordtbStartDateDialogClosed(Sender: TObject);
var
  sDate: String;
  dt: TDateTime;
  dtBox: TORDateBox;

begin
  inherited;
  dt := TORDateBox(Sender).DateSelected;
  if dt = 0 then
    exit;

  sDate := FormatDateTime(fmtDateOnly, dt);
  dtBox := TORDateBox(Sender);
  if dt < dtBox.DateRange.MinDate then
  begin
    dt := dtBox.DateRange.MinDate;
    InfoBox(Format(fmtErrorMinDate, [sDate]) + FormatDateTime(fmtDateOnly,
      dtBox.DateRange.MinDate), txtTitle, MB_OK + MB_ICONERROR);
  end
  else if dt > dtBox.DateRange.MaxDate then
  begin
    dt := dtBox.DateRange.MaxDate;
    InfoBox(Format(fmtErrorMaxDate, [sDate]) + FormatDateTime(fmtDateOnly,
      dtBox.DateRange.MaxDate), txtTitle, MB_OK + MB_ICONERROR);
  end
  else
  begin
    if Sender = ordtbStart then
      ordtbStop.DateRange.MinDate := dt
    else
      ordtbStart.DateRange.MaxDate := dt;
  end;

  dtBox.DateSelected := dt;
  dtBox.Text := FormatDateTime(fmtDateOnly, dt);

  btnRestore.enabled := (ordtbStop.DateSelected <> StrDateToDate(fStart)) or
    (ordtbStart.DateSelected <> StrDateToDate(fStop));

  stxtChanged.Visible := btnRestore.enabled;
end;

end.

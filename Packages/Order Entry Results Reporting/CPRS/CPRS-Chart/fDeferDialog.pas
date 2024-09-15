unit fDeferDialog;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.DateUtils,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ActnList,
  Vcl.ComCtrls,
  fBase508Form,
  VA508AccessibilityManager;

type
  TDeferBy = (dfbCustom, dfb1H, dfb2H, dfb3H, dfb4H, dfb6H, dfb8H, dfb12H, dfb1D, dfb2D, dfb3D, dfb4D, dfb5D, dfb6D, dfb7D, dfb8D, dfb9D, dfb10D, dfb11D, dfb12D, dfb13D, dfb14D);

  TfrmDeferDialog = class(TfrmBase508Form)
    acList: TActionList;
    acNewDeferalClicked: TAction;
    acDefer: TAction;

    cmdCancel: TButton;
    cmdDefer: TButton;

    pnlBottom: TPanel;
    pnlLeft: TPanel;

    gbxDeferBy: TGroupBox;
    lblCustom: TLabel;
    Bevel2: TBevel;

    cbxDeferBy: TComboBox;

    stxtDeferUntilDate: TStaticText;
    stxtDeferUntilTime: TStaticText;
    stxtDescription: TStaticText;
    gp: TGridPanel;
    lblDate: TLabel;
    dtpDate: TDateTimePicker;
    lblTime: TLabel;
    dtpTime: TDateTimePicker;

    procedure FormCreate(Sender: TObject);
    procedure acNewDeferalClickedExecute(Sender: TObject);
    procedure acDeferExecute(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    fDeferByDefault: TDeferBy;
    fMaxDeferDateTime: TDateTime;
    fDeferUntil: TDateTime;

    function getDefaultDeferral: TDeferBy;
    function getDeferUntil: TDateTime;
    function getDeferUntilMax: TDateTime;
    function getDeferUntilFM: string;
    function getTitle: string;
    function getDescription: string;

    procedure setDefaultDeferral(const aValue: TDeferBy);
    procedure setDeferUntil(const aValue: TDateTime);
    procedure setDeferUntilMax(const aValue: TDateTime);
    procedure setTitle(const aValue: string);
    procedure setDescription(const aValue: string);
  public
    function Execute: boolean;

    property DeferUntilDefault: TDeferBy read getDefaultDeferral write setDefaultDeferral;
    property DeferUntilMax: TDateTime read getDeferUntilMax write setDeferUntilMax;
    property DeferUntil: TDateTime read getDeferUntil write setDeferUntil;
    property DeferUntilFM: string read getDeferUntilFM;
    property Title: string read getTitle write setTitle;
    property Description: string read getDescription write setDescription;
  end;

implementation

uses uSizing;

const
  // dfbCustom, dfb1H, dfb2H, dfb3H, dfb4H, dfb6H, dfb8H, dfb12H, dfb1D, dfb2D, dfb3D, dfb4D, dfb5D, dfb6D, dfb7D, dfb8D, dfb9D, dfb10D, dfb11D, dfb12D, dfb13D, dfb14D);
  DEFER_BY_LABEL: array [TDeferBy] of string = ('Custom', '1 Hour', '2 Hours', '3 Hours', '4 Hours', '6 Hours', '8 Hours', '12 Hours', '1 Day', '2 Days', '3 Days', '4 Days', '5 Days', '6 Days', '7 Days (1 week)', '8 Days', '9 Days', '10 Days', '11 Days', '12 Days', '13 Days', '14 Days (2 weeks)');
  DEFER_BY_HOURS: array [TDeferBy] of integer = (0, 1, 2, 3, 4, 6, 8, 12, 24, 48, 72, 96, 120, 144, 168, 192, 216, 240, 264, 288, 312, 336);

{$R *.dfm}

procedure TfrmDeferDialog.FormCreate(Sender: TObject);
var
  aDeferBy: TDeferBy;
  i: Integer;
begin
//  Font.Assign(Screen.IconFont);
  Font.Size := Application.MainForm.Font.Size;
  AdjustToolPanel(pnlBottom);

  i := getMainFormTextHeight;
  gp.Height := 2 * ( i + 12);

  for aDeferBy := Low(TDeferBy) to High(TDeferBy) do
    cbxDeferBy.Items.Add(DEFER_BY_LABEL[aDeferBy]);
  dtpDate.DateTime := Now;
  dtpTime.DateTime := Now;
  setDefaultDeferral(dfbCustom);
  setDeferUntilMax(IncDay(Now, 14));
end;

procedure TfrmDeferDialog.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    begin
      Key := 0;
      ModalResult := mrCancel;
    end;
end;

function TfrmDeferDialog.Execute: boolean;
begin
  Result := (ShowModal = mrOK);
end;

function TfrmDeferDialog.getDefaultDeferral: TDeferBy;
begin
  Result := fDeferByDefault;
end;

function TfrmDeferDialog.getDeferUntil: TDateTime;
begin
  Result := fDeferUntil;
end;

function TfrmDeferDialog.getDeferUntilFM: string;
var
  y, m, d: Word;
  hh, mm, ss, ms: Word;
  dbl: double;
begin
  DecodeDate(fDeferUntil, y, m, d);
  DecodeTime(fDeferUntil, hh, mm, ss, ms);
  dbl := ((y - 1700) * 10000) + (m * 100) + d +
    (hh * 0.01) + (mm * 0.0001) + (ss * 0.000001);
  Result := Format('%0.6f', [dbl]);
  while (Copy(Result, Length(Result), 1) = '0') do
    Result := Copy(Result, 1, Length(Result) - 1);
  if (Copy(Result, Length(Result), 1) = '.') then
    Result := Copy(Result, 1, Length(Result) - 1);
end;

function TfrmDeferDialog.getDescription: string;
begin
  Result := stxtDescription.Caption;
end;

function TfrmDeferDialog.getDeferUntilMax: TDateTime;
begin
  Result := fMaxDeferDateTime;
end;

function TfrmDeferDialog.getTitle: string;
begin
  Result := Caption;
end;

procedure TfrmDeferDialog.setDefaultDeferral(const aValue: TDeferBy);
begin
  fDeferByDefault := aValue;
  cbxDeferBy.ItemIndex := (Ord(aValue));
  acNewDeferalClicked.Execute;
end;

procedure TfrmDeferDialog.setDeferUntil(const aValue: TDateTime);
begin
  fDeferUntil := aValue;
end;

procedure TfrmDeferDialog.setDescription(const aValue: string);
begin
  stxtDescription.Caption := aValue;
end;

procedure TfrmDeferDialog.setDeferUntilMax(const aValue: TDateTime);
begin
  fMaxDeferDateTime := aValue;
end;

procedure TfrmDeferDialog.setTitle(const aValue: string);
begin
  Caption := aValue;
end;

procedure TfrmDeferDialog.acDeferExecute(Sender: TObject);
begin
  if cbxDeferBy.ItemIndex = 0 then
    begin
      fDeferUntil := Trunc(dtpDate.DateTime) + Frac(dtpTime.DateTime);

      if (fDeferUntil >= IncMinute(Now, 5)) and (fDeferUntil <= fMaxDeferDateTime) then
        ModalResult := mrOK
      else
        MessageDlg(
          FormatDateTime('"Deferal date/time must be at least 5 minutes in the future and no more than "MMM D, YYYY hh:mm ampm"."', fMaxDeferDateTime),
          mtInformation, [mbOk], 0)
    end
  else
    ModalResult := mrOK;
end;

procedure TfrmDeferDialog.acNewDeferalClickedExecute(Sender: TObject);
var
  aDeferBy: integer;
begin
  aDeferBy := DEFER_BY_HOURS[TDeferBy(cbxDeferBy.ItemIndex)];
  if aDeferBy > 0 then
    fDeferUntil := IncHour(Now, aDeferBy)
  else
    fDeferUntil := Trunc(dtpDate.DateTime) + Frac(dtpTime.DateTime);

  case Trunc(fDeferUntil) - Trunc(Now) of
    0:
      stxtDeferUntilDate.Caption := 'Date: Today';
    1:
      stxtDeferUntilDate.Caption := 'Date: Tomorrow';
  else
    stxtDeferUntilDate.Caption := FormatDateTime('"Date: "MMM D, YYYY', fDeferUntil);
  end;

  stxtDeferUntilTime.Caption := FormatDateTime('"Time: "hh:mm ampm', fDeferUntil);

  dtpDate.Enabled := (aDeferBy = 0);
  dtpTime.Enabled := (aDeferBy = 0);
  lblDate.Enabled := (aDeferBy = 0);
  lblTime.Enabled := (aDeferBy = 0);
  lblCustom.Enabled := (aDeferBy = 0);

  stxtDeferUntilDate.Enabled := (aDeferBy <> 0);
  stxtDeferUntilTime.Enabled := (aDeferBy <> 0);
end;

end.

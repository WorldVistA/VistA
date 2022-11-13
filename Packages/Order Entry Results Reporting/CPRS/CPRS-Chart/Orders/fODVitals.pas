unit fODVitals;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ComCtrls, ExtCtrls, StdCtrls, ORCtrls, ORDtTm,
  VA508AccessibilityManager;

type
  TfrmODVitals = class(TfrmODBase)
    cboMeasurement: TORComboBox;
    cboSchedule: TORComboBox;
    calStart: TORDateBox;
    calStop: TORDateBox;
    grpCallHO: TGroupBox;
    lblMeasurement: TLabel;
    lblSchedule: TLabel;
    lblStart: TLabel;
    lblStop: TLabel;
    txtBPsys: TCaptionEdit;
    txtBPDia: TCaptionEdit;
    txtPulseLT: TCaptionEdit;
    txtPulGT: TCaptionEdit;
    txtTemp: TCaptionEdit;
    lblBPsys: TLabel;
    lblBPdia: TLabel;
    lblPulseLT: TLabel;
    lblPulseGT: TLabel;
    lblTemp: TLabel;
    chkCallHO: TCheckBox;
    txtComment: TCaptionEdit;
    lblComment: TLabel;
    spnBPsys: TUpDown;
    spnBPdia: TUpDown;
    spnPulseLT: TUpDown;
    spnPulseGT: TUpDown;
    spnTemp: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    procedure InitDialog; override;
    procedure Validate(var AnErrMsg: string); override;
  public
    procedure SetupDialog(OrderAction: Integer; const ID: string); override;
  end;

var
  frmODVitals: TfrmODVitals;

implementation

{$R *.DFM}

uses uConst, ORFn, rODBase, fFrame, VAUtils;

const
  TX_NO_MEASUREMENT = 'A measurement must be selected.';
  TX_BAD_START      = 'The start date is not valid.';
  TX_BAD_STOP       = 'The stop date is not valid.';
  TX_STOPSTART     = 'The stop date must be after the start date.';

procedure TfrmODVitals.FormCreate(Sender: TObject);
var
  sl: TStrings;
begin
  frmFrame.pnlVisit.Enabled := false;
  inherited;
  FillerID := 'OR';                     // does 'on Display' order check **KCM**
  StatusText('Loading Dialog Definition');
  Responses.Dialog := 'GMRVOR';
  //Responses.Dialog := 'ORWD GENERIC VITALS';       // loads formatting info
  StatusText('Loading Default Values');            // there are no defaults for text only
  sl := TSTringList.Create;
  try
    setODForVitals(sl);
    CtrlInits.LoadDefaults(sl);
  finally
    sl.Free;
  end;
  InitDialog;
  StatusText('');
end;

procedure TfrmODVitals.InitDialog;
begin
  inherited;
  txtComment.Text := '';
  with CtrlInits do
  begin
    SetControl(cboMeasurement,  'Measurements');
    SetControl(cboSchedule,     'Schedules');
  end;
  ActiveControl := cboMeasurement;  //SetFocusedControl(cboMeasurement);
end;

procedure TfrmODVitals.SetupDialog(OrderAction: Integer; const ID: string);
begin
  inherited;
  if OrderAction in [ORDER_COPY, ORDER_EDIT, ORDER_QUICK] then with Responses do
  begin
    Changing := True;
    SetControl(cboMeasurement, 'ORDERABLE', 1);
    SetControl(cboSchedule,    'SCHEDULE',  1);
    SetControl(calStart,       'START',     1);
    SetControl(calStop,        'STOP',      1);
    SetControl(txtComment,     'COMMENT',   1);
    Changing := False;
    ControlChange(Self);
  end;
end;

procedure TfrmODVitals.Validate(var AnErrMsg: string);
var
  ErrMsg: string;

  procedure SetError(const x: string);
  begin
    if Length(AnErrMsg) > 0 then AnErrMsg := AnErrMsg + CRLF;
    AnErrMsg := AnErrMsg + x;
  end;

begin
  inherited;
  if cboMeasurement.ItemIEN <= 0 then SetError(TX_NO_MEASUREMENT);
  calStart.Validate(ErrMsg);
  if Length(ErrMsg) > 0          then SetError(TX_BAD_START);
  calStop.Validate(ErrMsg);
  if Length(ErrMsg) > 0          then SetError(TX_BAD_STOP);
  if (Length(calStop.Text) > 0) and (calStop.FMDateTime <= calStart.FMDateTime)
                                 then SetError(TX_STOPSTART);

end;

procedure TfrmODVitals.ControlChange(Sender: TObject);
begin
  inherited;
  if Changing then Exit;
  Responses.Clear;
  with cboMeasurement do if ItemIEN > 0      then Responses.Update('ORDERABLE', 1, ItemID, Text);
  with cboSchedule    do if Length(Text) > 0 then Responses.Update('SCHEDULE' , 1, Text,   Text);
  with calStart       do if Length(Text) > 0 then Responses.Update('START',     1, Text,   Text);
  with calStop        do if Length(Text) > 0 then Responses.Update('STOP',      1, Text,   Text);
  with txtComment     do if Length(Text) > 0 then Responses.Update('COMMENT',   1, Text,   Text);
  memOrder.Text := Responses.OrderText;
end;

procedure TfrmODVitals.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  frmFrame.pnlVisit.Enabled := true;
end;

end.

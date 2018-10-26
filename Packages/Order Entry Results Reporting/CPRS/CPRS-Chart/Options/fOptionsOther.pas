unit fOptionsOther;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ORCtrls, ORFn, rOrders, uCore, ORDtTm, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsOther = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    bvlBottom: TBevel;
    stStart: TStaticText;
    stStop: TStaticText;
    dtStart: TORDateBox;
    dtStop: TORDateBox;
    lblMedsTab: TLabel;
    lblTabDefault: TStaticText;
    lblTab: TLabel;
    cboTab: TORComboBox;
    chkLastTab: TCheckBox;
    Bevel1: TBevel;
    lblEncAppts: TLabel;
    stStartEncAppts: TStaticText;
    txtTodayMinus: TStaticText;
    txtEncStart: TCaptionEdit;
    txtDaysMinus: TStaticText;
    spnEncStart: TUpDown;
    txtDaysPlus: TStaticText;
    spnEncStop: TUpDown;
    txtEncStop: TCaptionEdit;
    txtTodayPlus: TStaticText;
    stStopEncAppts: TStaticText;
    Bevel2: TBevel;
    btnEncDefaults: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtStartExit(Sender: TObject);
    procedure dtStopExit(Sender: TObject);
    procedure dtStartChange(Sender: TObject);
    procedure txtEncStartChange(Sender: TObject);
    procedure txtEncStopChange(Sender: TObject);
    procedure txtEncStartExit(Sender: TObject);
    procedure txtEncStopExit(Sender: TObject);
    procedure btnEncDefaultsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FstartDt: TFMDateTime;
    FstopDt: TFMDateTime;
    FEncStartDays, FEncStopDays, FEncDefStartDays, FEncDefStopDays: integer;
    OK2Closed: boolean;
    //FDefaultEvent: string;
  public
    { Public declarations }
  end;

var
  frmOptionsOther: TfrmOptionsOther;

const
  ENC_MAX_LIMIT = 999;

procedure DialogOptionsOther(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

{$R *.DFM}

uses
  rOptions, uOptions, rCore, rSurgery, uConst, fMeds, VAUtils;

procedure DialogOptionsOther(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsOther: TfrmOptionsOther;
begin
  frmOptionsOther := TfrmOptionsOther.Create(Application);
  actiontype := 0;
  try
    with frmOptionsOther do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsOther);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsOther.Release;
  end;
end;

procedure TfrmOptionsOther.FormShow(Sender: TObject);
// displays defaults
// opening tab^use last tab^autosave seconds^verify note title
var
  last: integer;
  values, tab: string;
begin
  OK2Closed := True;
  FastAssign(rpcGetOtherTabs, cboTab.Items);
  if (cboTab.Items.IndexOf('Surgery') > -1) and (not ShowSurgeryTab) then
    cboTab.Items.Delete(cboTab.Items.IndexOf('Surgery'));
  values := rpcGetOther;
  tab := Piece(values, '^', 1);
  last := strtointdef(Piece(values, '^', 2), 0);
  cboTab.SelectByID(tab);
  cboTab.Tag := strtointdef(tab, -1);
  chkLastTab.Checked := last = 1;
  chkLastTab.Tag := last;
  cboTab.SetFocus;
  rpcGetRangeForMeds(FstartDt, FstopDt);
  if FstartDt > 1 then
    dtStart.Text := FormatFMDateTime('dddddd',FstartDt);
  if FstopDt > 1 then
    dtStop.Text  := FormatFMDateTime('dddddd', FstopDt);
  rpcGetRangeForEncs(FEncDefStartDays, FEncDefStopDays, True); // True gets params settings above User/Service level.
  if FEncDefStartDays < 1 then
    FEncDefStartDays := 0;
  if FEncDefStopDays < 1 then
    FEncDefStopDays := 0;
  rpcGetRangeForEncs(FEncStartDays, FEncStopDays, False);      // False gets User/Service params.
  if ((FEncStartDays < 0) and (FEncStartDays <> 0)) then
    FEncStartDays := FEncDefStartDays;
  txtEncStart.Text := IntToStr(FEncStartDays);
  if ((FEncStopDays < 0) and (FEncStopDays <> 0)) then
    FEncStopDays := FEncDefStopDays;
  txtEncStop.Text := IntToStr(FEncStopDays);
end;

procedure TfrmOptionsOther.btnOKClick(Sender: TObject);
// opening tab^use last tab^autosave seconds^verify note title
var
  values, theVal: string;
begin
  OK2Closed := True;
  values := '';
  if cboTab.ItemIEN <> cboTab.Tag then
    values := values + cboTab.ItemID;
  values := values + '^';
  if chkLastTab.Checked then
    if chkLastTab.Tag <> 1 then
      values := values + '1';
  if not chkLastTab.Checked then
    if chkLastTab.Tag <> 0 then
      values := values + '0';
  values := values + '^^';
  rpcSetOther(values);
   if (dtStart.Text = '') and (dtStop.Text = '') then
    begin
      if InfoBox('A date range is not set for the meds tab. Continue?', 'No Date Range Defined', MB_YESNO) = ID_NO then
      begin
         dtStart.SetFocus;
         OK2Closed := false;
         Exit;
      end;
    end
  else if (dtStart.Text = '') or (dtStop.Text = '') then
    begin
      ShowMsg('A complete date range needs to be set. ');
      if dtStart.Text = '' then dtStart.SetFocus
      else dtStop.SetFocus;
      OK2Closed := false;
      Exit;
    end;
  //if Pos('Y', Uppercase(dtStart.Text))>0 then
  if Uppercase(Copy(dtStart.Text, Length(dtStart.Text), Length(dtStart.Text))) = 'Y' then

    begin
      ShowMsg('Start Date relative date cannot have a Y');
      OK2Closed := false;
      dtStart.SetFocus;
      Exit;
    end;
  //if Pos('Y', Uppercase(dtStop.Text))>0 then
  if Uppercase(Copy(dtStop.Text, Length(dtStop.Text), Length(dtStop.Text))) = 'Y' then
    begin
      ShowMsg('Stop Date relative date cannot have a Y');
      OK2Closed := false;
      dtStart.SetFocus;
      Exit;
    end;
  if (dtStop.FMDateTime > 0) and (dtStart.FMDateTime > 0) then
  begin
    if dtStop.FMDateTime < dtStart.FMDateTime then
    begin
      ShowMsg('The stop time can not prior to the start time.');
      dtStop.FMDateTime := FMToday;
      dtStop.SetFocus;
      OK2Closed := false;
      Exit;
    end;
    theVal := dtStart.RelativeTime + ';' + dtStop.RelativeTime;
    rpcPutRangeForMeds(theVal);
  end;
  if (dtStart.Text = '') and (dtStop.Text = '') then
    rpcPutRangeForMeds('');
  rpcPutRangeForEncs(txtEncStart.Text, txtEncStop.Text);
  if frmMeds <> nil then
    frmMeds.RefreshMedLists;
end;

procedure TfrmOptionsOther.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose := OK2Closed;
  
end;

procedure TfrmOptionsOther.FormCreate(Sender: TObject);
begin
  FStartDT  := 0;
  FStopDT   := 0;
end;

procedure TfrmOptionsOther.dtStartExit(Sender: TObject);
begin
  if dtStart.FMDateTime > FMToday then
  begin
    ShowMsg('Start time can not greater than today.');
    dtStart.FMDateTime := FMToday;
    dtStart.SetFocus;
    Exit;
  end;
end;

procedure TfrmOptionsOther.dtStopExit(Sender: TObject);
begin
  if (dtStop.FMDateTime > 0) and (dtStart.FMDateTime > 0) then
    if (dtStop.FMDateTime < dtStart.FMDateTime) then
    begin
      ShowMsg('Stop time can not prior to start time');
      dtStop.FMDateTime := FMToday;
      dtStop.SetFocus;
      Exit;
    end;
end;

procedure TfrmOptionsOther.dtStartChange(Sender: TObject);
begin
 (* if (dtStart.FMDateTime > FMToday) then
  begin
    ShowMsg('Start time can not greater than today.');
    dtStart.FMDateTime := FMToday;
    dtStart.SetFocus;
    Exit;
  end;    *)
end;

procedure TfrmOptionsOther.txtEncStartChange(Sender: TObject);
begin
with txtEncStart do
  begin
    if Text = '' then
      Exit;
    if Text = ' ' then
      Text := '0';
    if StrToInt(Text) < 0 then
      Text := '0';
    if StrToIntDef(Text, ENC_MAX_LIMIT) > ENC_MAX_LIMIT then
      begin
        Text := IntToStr(ENC_MAX_LIMIT);
        Beep;
        InfoBox('Number must be < ' + IntToStr(ENC_MAX_LIMIT), 'Warning', MB_OK or MB_ICONWARNING);
      end;
  end;
end;

procedure TfrmOptionsOther.txtEncStopChange(Sender: TObject);
begin
with txtEncStop do
  begin
    if Text = '' then
      Exit;
    if Text = ' ' then
      Text := '0';
    if StrToInt(Text) < 0 then
      Text := '0';
    if StrToIntDef(Text, ENC_MAX_LIMIT) > ENC_MAX_LIMIT then
      begin
        Text := IntToStr(ENC_MAX_LIMIT);
        Beep;
        InfoBox('Number must be < ' + IntToStr(ENC_MAX_LIMIT), 'Warning', MB_OK or MB_ICONWARNING);
      end;
  end;
end;

procedure TfrmOptionsOther.txtEncStartExit(Sender: TObject);
begin
with txtEncStart do
  if Text = '' then
    Text := '0';
end;

procedure TfrmOptionsOther.txtEncStopExit(Sender: TObject);
begin
with txtEncStart do
  if Text = '' then
    Text := '0';
end;

procedure TfrmOptionsOther.btnCancelClick(Sender: TObject);
begin
  inherited;
  OK2Closed := True;
end;

procedure TfrmOptionsOther.btnEncDefaultsClick(Sender: TObject);
begin
txtEncStart.Text := IntToStr(FEncDefStartDays);
txtEncStop.Text := IntToStr(FEncDefStopDays);
end;

end.

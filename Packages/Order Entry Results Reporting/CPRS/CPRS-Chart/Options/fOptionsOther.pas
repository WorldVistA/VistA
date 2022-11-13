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
    grpOverAll: TGroupBox;
    stStart: TStaticText;
    dtStart: TORDateBox;
    stStop: TStaticText;
    dtStop: TORDateBox;
    grpInpatientMeds: TGroupBox;
    stStartIn: TStaticText;
    dtStartIn: TORDateBox;
    stStopIn: TStaticText;
    dtStopIn: TORDateBox;
    grpOutpatientMeds: TGroupBox;
    stStartOp: TStaticText;
    dtStartOp: TORDateBox;
    stStopOp: TStaticText;
    dtStopOp: TORDateBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
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
    procedure dtStartInExit(Sender: TObject);
    procedure dtStopInExit(Sender: TObject);
    procedure dtStartOpExit(Sender: TObject);
    procedure dtStopOpExit(Sender: TObject);
  private
    { Private declarations }
    FstartDt: TFMDateTime;
    FstopDt: TFMDateTime;
    FstartDtIn: TFMDateTime;
    FstopDtIn: TFMDateTime;
    FstartDtOp: TFMDateTime;
    FstopDtOp: TFMDateTime;
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
  PSPO_1157 = 'OR*3.0*498'; //Check for required patch to enable PSPO 1157 functionality

procedure DialogOptionsOther(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

{$R *.DFM}

uses
  rOptions, uOptions, rCore, rSurgery, uConst, fMeds, VAUtils, rMisc;

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
  PatchInstalled: boolean;
begin
  OK2Closed := True;
  rpcGetOtherTabs(cboTab.Items);
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
    dtStart.Text := FormatFMDateTime('mmm d, yyyy',FstartDt);
  if FstopDt > 1 then
    dtStop.Text  := FormatFMDateTime('mmm d, yyyy', FstopDt);
  rpcGetRangeForMedsIn(FstartDtIn, FstopDtIn);
  if FstartDtIn > 1 then
    dtStartIn.Text := FormatFMDateTime('mmm d, yyyy',FstartDtIn);
  if FstopDtIn > 1 then
    dtStopIn.Text  := FormatFMDateTime('mmm d, yyyy', FstopDtIn);
  rpcGetRangeForMedsOp(FstartDtOp, FstopDtOp);
  if FstartDtOp > 1 then
    dtStartOp.Text := FormatFMDateTime('mmm d, yyyy',FstartDtOp);
  if FstopDtOp > 1 then
    dtStopOp.Text  := FormatFMDateTime('mmm d, yyyy', FstopDtOp);
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
  PatchInstalled := ServerHasPatch(PSPO_1157);
  if not(PatchInstalled) then
    begin
      grpInpatientMeds.Visible := false;
      grpOutpatientMeds.Visible := false;
    end;
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
   if (dtStart.Text = '') and (dtStop.Text = '') and (dtStartIn.Text = '') and (dtStopIn.Text = '') and (dtStartOp.Text = '') and (dtStopOp.Text = '') then
    begin
      if InfoBox('A date range is not set for the meds tab. Continue?', 'No Date Range Defined', MB_YESNO) = ID_NO then
      begin
         dtStart.SetFocus;
         OK2Closed := false;
         Exit;
      end;
    end
  else if (dtStartIn.Text = '') and (dtStopIn.Text = '') and (dtStartOp.Text = '') and (dtStopOp.Text = '') and ((dtStart.Text = '') or (dtStop.Text = '')) then
    begin
      ShowMsg('A complete Overall date range needs to be set. ');
      if dtStart.Text = '' then dtStart.SetFocus
      else dtStop.SetFocus;
      OK2Closed := false;
      Exit;
    end
  else if ((dtStartIn.Text = '') and (not (dtStopIn.Text = ''))) or ((not (dtStartIn.Text = '')) and (dtStopIn.Text = '')) then
    begin
      ShowMsg('A complete Inpatient date range needs to be set. ');
      if dtStartIn.Text = '' then dtStartIn.SetFocus
      else dtStopIn.SetFocus;
      OK2Closed := false;
      Exit;
    end
  else if ((dtStartOp.Text = '') and (not (dtStopOp.Text = ''))) or ((not (dtStartOp.Text = '')) and (dtStopOp.Text = '')) then
    begin
      ShowMsg('A complete Outpatient date range needs to be set. ');
      if dtStartOp.Text = '' then dtStartOp.SetFocus
      else dtStopOp.SetFocus;
      OK2Closed := false;
      Exit;
    end;
  if Uppercase(Copy(dtStart.Text, Length(dtStart.Text), Length(dtStart.Text))) = 'Y' then
    begin
      ShowMsg('Overall Start Date relative date cannot have a Y');
      OK2Closed := false;
      dtStart.SetFocus;
      Exit;
    end;
  if Uppercase(Copy(dtStop.Text, Length(dtStop.Text), Length(dtStop.Text))) = 'Y' then
    begin
      ShowMsg('Overall Stop Date relative date cannot have a Y');
      OK2Closed := false;
      dtStart.SetFocus;
      Exit;
    end;
    if Uppercase(Copy(dtStartIn.Text, Length(dtStartIn.Text), Length(dtStartIn.Text))) = 'Y' then
    begin
      ShowMsg('Inpatient Start Date relative date cannot have a Y');
      OK2Closed := false;
      dtStartIn.SetFocus;
      Exit;
    end;
  if Uppercase(Copy(dtStopIn.Text, Length(dtStopIn.Text), Length(dtStopIn.Text))) = 'Y' then
    begin
      ShowMsg('Inpatient Stop Date relative date cannot have a Y');
      OK2Closed := false;
      dtStartIn.SetFocus;
      Exit;
    end;
    if Uppercase(Copy(dtStartOp.Text, Length(dtStartOp.Text), Length(dtStartOp.Text))) = 'Y' then
    begin
      ShowMsg('Outpatient Start Date relative date cannot have a Y');
      OK2Closed := false;
      dtStartOp.SetFocus;
      Exit;
    end;
  if Uppercase(Copy(dtStopOp.Text, Length(dtStopOp.Text), Length(dtStopOp.Text))) = 'Y' then
    begin
      ShowMsg('Outpatient Stop Date relative date cannot have a Y');
      OK2Closed := false;
      dtStartOp.SetFocus;
      Exit;
    end;
  if (dtStop.FMDateTime > 0) and (dtStart.FMDateTime > 0) then
  begin
    if dtStop.FMDateTime < dtStart.FMDateTime then
    begin
      ShowMsg('The OverAll Meds Default stop time cannot be prior to its start time.');
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
  if (dtStopIn.FMDateTime > 0) and (dtStartIn.FMDateTime > 0) then
  begin
    if dtStopIn.FMDateTime < dtStartIn.FMDateTime then
    begin
      ShowMsg('The Inpatient Meds stop time cannot be prior to its start time.');
      dtStopIn.FMDateTime := FMToday;
      dtStopIn.SetFocus;
      OK2Closed := false;
      Exit;
    end;
    theVal := dtStartIn.RelativeTime + ';' + dtStopIn.RelativeTime;
    rpcPutRangeForMedsIn(theVal);
  end;
  if (dtStartIn.Text = '') and (dtStopIn.Text = '') then
    rpcPutRangeForMedsIn('');
  if (dtStopOp.FMDateTime > 0) and (dtStartOp.FMDateTime > 0) then
  begin
    if dtStopOp.FMDateTime < dtStartOp.FMDateTime then
    begin
      ShowMsg('The Outpatient/non-VA Meds stop time cannot be prior to its start time.');
      dtStopOp.FMDateTime := FMToday;
      dtStopOp.SetFocus;
      OK2Closed := false;
      Exit;
    end;
    theVal := dtStartOp.RelativeTime + ';' + dtStopOp.RelativeTime;
    rpcPutRangeForMedsOp(theVal);
  end;
  if (dtStartOp.Text = '') and (dtStopOp.Text = '') then
    rpcPutRangeForMedsOp('');
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
    ShowMsg('OverAll Meds Default Start time cannot be greater than today.');
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
      ShowMsg('OverAll Meds Default Stop time cannot be prior to start time');
      dtStop.FMDateTime := FMToday;
      dtStop.SetFocus;
      Exit;
    end;
end;

procedure TfrmOptionsOther.dtStartInExit(Sender: TObject);
begin
  if dtStartIn.FMDateTime > FMToday then
  begin
    ShowMsg('Inpatient Meds Start time cannot be greater than today.');
    dtStartIn.FMDateTime := FMToday;
    dtStartIn.SetFocus;
    Exit;
  end;
end;

procedure TfrmOptionsOther.dtStopInExit(Sender: TObject);
begin
if (dtStopIn.FMDateTime > 0) and (dtStartIn.FMDateTime > 0) then
    if (dtStopIn.FMDateTime < dtStartIn.FMDateTime) then
    begin
      ShowMsg('Inpatient Meds Stop time cannot be prior to start time');
      dtStopIn.FMDateTime := FMToday;
      dtStopIn.SetFocus;
      Exit;
    end;
end;

procedure TfrmOptionsOther.dtStartOpExit(Sender: TObject);
begin
  if dtStartOp.FMDateTime > FMToday then
  begin
    ShowMsg('Outpatient/non-VA Meds Start time cannot be greater than today.');
    dtStartOp.FMDateTime := FMToday;
    dtStartOp.SetFocus;
    Exit;
  end;
end;

procedure TfrmOptionsOther.dtStopOpExit(Sender: TObject);
begin
  if (dtStopOp.FMDateTime > 0) and (dtStartOp.FMDateTime > 0) then
    if (dtStopOp.FMDateTime < dtStartOp.FMDateTime) then
    begin
      ShowMsg('Outpatient/non-VA Meds Stop time cannot be prior to start time');
      dtStopOp.FMDateTime := FMToday;
      dtStopOp.SetFocus;
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

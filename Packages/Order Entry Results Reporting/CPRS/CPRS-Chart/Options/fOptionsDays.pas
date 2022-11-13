unit fOptionsDays;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, fOptions, ComCtrls, OrFn, ORCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsDays = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    bvlTop: TBevel;
    bvlMiddle: TBevel;
    txtLabInpatient: TCaptionEdit;
    spnLabInpatient: TUpDown;
    txtLabOutpatient: TCaptionEdit;
    spnLabOutpatient: TUpDown;
    txtVisitStart: TCaptionEdit;
    spnVisitStart: TUpDown;
    txtVisitStop: TCaptionEdit;
    spnVisitStop: TUpDown;
    lblVisit: TStaticText;
    lblVisitStop: TLabel;
    lblVisitStart: TLabel;
    lblLabOutpatient: TLabel;
    lblLabInpatient: TLabel;
    lblLab: TStaticText;
    lblVisitValue: TMemo;
    lblLabValue: TMemo;
    btnLabDefaults: TButton;
    btnVisitDefaults: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spnVisitStartClick(Sender: TObject; Button: TUDBtnType);
    procedure spnVisitStopClick(Sender: TObject; Button: TUDBtnType);
    procedure spnLabInpatientClick(Sender: TObject; Button: TUDBtnType);
    procedure spnLabOutpatientClick(Sender: TObject; Button: TUDBtnType);
    procedure txtLabInpatientKeyPress(Sender: TObject; var Key: Char);
    procedure btnLabDefaultsClick(Sender: TObject);
    procedure btnVisitDefaultsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure txtLabInpatientChange(Sender: TObject);
    procedure txtLabInpatientExit(Sender: TObject);
    procedure txtLabOutpatientChange(Sender: TObject);
    procedure txtLabOutpatientExit(Sender: TObject);
    procedure txtVisitStartExit(Sender: TObject);
    procedure txtVisitStartKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtVisitStopExit(Sender: TObject);
    procedure txtVisitStopKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtVisitStartKeyPress(Sender: TObject; var Key: Char);
    procedure txtVisitStopKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FStartEntered: boolean;
    FStopEntered: boolean;
    procedure AdjustVisitLabel;
    procedure AdjustLabLabel;
  public
    { Public declarations }
  end;

var
  frmOptionsDays: TfrmOptionsDays;

procedure DialogOptionsDays(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, uOptions, VAUtils;

{$R *.DFM}

procedure DialogOptionsDays(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsDays: TfrmOptionsDays;
begin
  frmOptionsDays := TfrmOptionsDays.Create(Application);
  actiontype := 0;
  try
    with frmOptionsDays do
    begin
{
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
}
//      ResizeAnchoredFormToFont(frmOptionsDays);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsDays.Release;
  end;
end;

procedure TfrmOptionsDays.FormCreate(Sender: TObject);
begin
  FStartEntered := false;
  FStopEntered := false;
end;

procedure TfrmOptionsDays.FormShow(Sender: TObject);
  //get lab defaults, personal values, visit defaults, personal values
  //tags for textboxes hold setting, tags on spinbuttons hold default,
  //tag of 1 on buttons indicate system default being used
var
  labin, labout, visitstart, visitstop: integer;
  labindef, laboutdef, visitstartdef, visitstopdef: integer;
begin
  rpcGetLabDays(labindef, laboutdef);
  rpcGetLabUserDays(labin, labout);
  rpcGetApptDays(visitstartdef, visitstopdef);
  rpcGetApptUserDays(visitstart, visitstop);

  txtLabInpatient.Text := inttostr(-labin);
  txtLabInpatient.Tag := labin;
  txtLabOutpatient.Text := inttostr(-labout);
  txtLabOutpatient.Tag := labout;
  txtVisitStart.Tag := visitstart - 1;
  txtVisitStop.Tag := visitstop - 1;

  spnLabInpatient.Tag := labindef;
  spnLabOutpatient.Tag := laboutdef;
  spnVisitStart.Tag := visitstartdef;
  spnVisitStop.Tag := visitstopdef;

  spnLabInpatientClick(self, btNext);
  spnLabOutpatientClick(self, btNext);
  spnVisitStartClick(self, btNext);
  spnVisitStopClick(self, btNext);
  
  txtLabInpatient.SetFocus;
end;

procedure TfrmOptionsDays.spnVisitStartClick(Sender: TObject;
  Button: TUDBtnType);
var
  tagnum: integer;
begin
  with txtVisitStart do
  begin
    if FStartEntered then
    begin
      if Hint = '' then Hint := 'T';
      tagnum := RelativeDate(Hint);
      if tagnum = INVALID_DAYS then
      begin
        Text := Hint;
        beep;
        InfoBox('Start Date entry was invalid', 'Warning', MB_OK or MB_ICONWARNING);
        ShowDisplay(txtVisitStart);
        FStartEntered := false;
        exit;
      end
      else
      begin
        DateLimits(DAYS_LIMIT, tagnum);
        if tagnum <> INVALID_DAYS then
          Tag := tagnum;
      end;
    end;
    SetFocus;
    if Button = btNext then tagnum := Tag + 1
    else tagnum := Tag - 1;
    Text := Hint;
    DateLimits(DAYS_LIMIT, tagnum);
    if tagnum <> INVALID_DAYS then
      Tag := tagnum;
    ShowDisplay(txtVisitStart);
  end;
  btnVisitDefaults.Tag := 0;
  AdjustVisitLabel;
  FStartEntered := false;
end;

procedure TfrmOptionsDays.spnVisitStopClick(Sender: TObject;
  Button: TUDBtnType);
var
  tagnum: integer;
begin
  with txtVisitStop do
  begin
    if FStopEntered then
    begin
      if Hint = '' then Hint := 'T';
      tagnum := RelativeDate(Hint);
      if tagnum = INVALID_DAYS then
      begin
        Text := Hint;
        beep;
        InfoBox('Stop Date entry was invalid', 'Warning', MB_OK or MB_ICONWARNING);
        ShowDisplay(txtVisitStop);
        FStopEntered := false;
        exit;
      end
      else
      begin
        DateLimits(DAYS_LIMIT, tagnum);
        if tagnum = INVALID_DAYS then
        begin
          Text := Hint;
          ShowDisplay(txtVisitStop);
          FStopEntered := false;
          exit;
        end;
      end;
    end;
    SetFocus;
    if Button = btNext then tagnum := Tag + 1
    else tagnum := Tag - 1;
    Text := Hint;
    DateLimits(DAYS_LIMIT, tagnum);
    if tagnum <> INVALID_DAYS then
      Tag := tagnum;
    ShowDisplay(txtVisitStop);
  end;
  btnVisitDefaults.Tag := 0;
  AdjustVisitLabel;
  FStopEntered := false;
end;

procedure TfrmOptionsDays.spnLabInpatientClick(Sender: TObject;
  Button: TUDBtnType);
begin
 // txtLabInpatient.SetFocus; cq:13554
  txtLabInpatient.Tag := strtointdef(txtLabInpatient.Text, 0);
  btnLabDefaults.Tag := 0;
  AdjustLabLabel;
end;

procedure TfrmOptionsDays.spnLabOutpatientClick(Sender: TObject;
  Button: TUDBtnType);
begin
  //txtLabOutpatient.SetFocus;  cq:13554
  txtLabOutpatient.Tag := strtointdef(txtLabOutpatient.Text, 0);
  btnLabDefaults.Tag := 0;
  AdjustLabLabel;
end;

procedure TfrmOptionsDays.txtLabInpatientKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Perform(WM_NextDlgCtl, 0, 0);
    exit;
  end;
  if not CharInSet(Key, ['0'..'9', #8]) then
  begin
    Key := #0;
    beep;
  end;
end;

procedure TfrmOptionsDays.btnLabDefaultsClick(Sender: TObject);
begin
  txtLabInpatient.Text := inttostr(spnLabInpatient.Tag);
  spnLabInpatientClick(self, btNext);
  txtLabOutpatient.Text := inttostr(spnLabOutpatient.Tag);
  spnLabOutpatientClick(self, btNext);
  btnLabDefaults.Tag := 1;
end;

procedure TfrmOptionsDays.btnVisitDefaultsClick(Sender: TObject);
begin
  txtVisitStart.Tag := spnVisitStart.Tag - 1;
  spnVisitStartClick(self, btNext);
  txtVisitStop.Tag := spnVisitStop.Tag - 1;
  spnVisitStopClick(self, btNext);
  btnVisitDefaults.Tag := 1;
end;

procedure TfrmOptionsDays.AdjustVisitLabel;
var
  start, stop: string;
begin
  start := txtVisitStart.Text;
  stop := txtVisitStop.Text;
  if start <> 'Today' then start := start + ' days';
  if stop <> 'Today' then stop := stop + ' days';
  lblVisitValue.Text := 'Appointments and visits will be displayed on the cover sheet '
                         + 'from ' + start + ' to ' + stop + '.'
end;

procedure TfrmOptionsDays.AdjustLabLabel;
begin
  lblLabValue.Text := 'Lab results will be displayed on the cover sheet '
                       + 'back ' + txtLabInpatient.Text + ' days for inpatients and '
                       + txtLabOutpatient.Text + ' days for outpatients.';
end;

procedure TfrmOptionsDays.btnOKClick(Sender: TObject);
begin
  rpcSetDays(txtLabInpatient.Tag, txtLabOutpatient.Tag, txtVisitStart.Tag, txtVisitStop.Tag);
end;

procedure TfrmOptionsDays.txtLabInpatientChange(Sender: TObject);
var
  maxvalue: integer;
begin
  maxvalue := spnLabInpatient.Max;
  with txtLabInpatient do
  begin
    if strtointdef(Text, maxvalue) > maxvalue then
    begin
      beep;
      InfoBox('Number must be < ' + inttostr(maxvalue), 'Warning', MB_OK or MB_ICONWARNING);
      if strtointdef(Text, 0) > maxvalue then
        Text := inttostr(maxvalue);
    end;
  end;
  spnLabInpatientClick(self, btNext);
end;

procedure TfrmOptionsDays.txtLabInpatientExit(Sender: TObject);
begin
  with txtLabInpatient do
  begin
    if Text = '' then
    begin
      Text := '0';
      spnLabInpatientClick(self, btNext);
    end
    else if (Copy(Text, 1, 1) = '0') and (length(Text) > 1) then
    begin
      Text := inttostr(strtointdef(Text, 0));
      spnLabInpatientClick(self, btNext);
    end;
  end;
end;

procedure TfrmOptionsDays.txtLabOutpatientChange(Sender: TObject);
var
  maxvalue: integer;
begin
  maxvalue := spnLabOutpatient.Max;
  with txtLabOutpatient do
  begin
    if strtointdef(Text, maxvalue) > maxvalue then
    begin
      beep;
      InfoBox('Number must be < ' + inttostr(maxvalue), 'Warning', MB_OK or MB_ICONWARNING);
      if strtointdef(Text, 0) > maxvalue then
        Text := inttostr(maxvalue);
    end;
  end;
  spnLabOutpatientClick(self, btNext);
end;

procedure TfrmOptionsDays.txtLabOutpatientExit(Sender: TObject);
begin
  with txtLabOutpatient do
  begin
    if Text = '' then
    begin
      Text := '0';
      spnLabOutpatientClick(self, btNext);
    end
    else if (Copy(Text, 1, 1) = '0') and (length(Text) > 1) then
    begin
      Text := inttostr(strtointdef(Text, 0));
      spnLabOutpatientClick(self, btNext);
    end;
  end;
end;

procedure TfrmOptionsDays.txtVisitStartExit(Sender: TObject);
begin
  with txtVisitStart do
  if Text = '' then
  begin
    Text := 'T-1';
    Hint := 'T-1';
    spnVisitStartClick(self, btNext);
  end;
  TextExit(txtVisitStart, FStartEntered, DAYS_LIMIT);
  AdjustVisitLabel;
end;

procedure TfrmOptionsDays.txtVisitStartKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  txtVisitStart.Hint := txtVisitStart.Text;   // put text in hint since text not available to spin
  FStartEntered := true;
end;

procedure TfrmOptionsDays.txtVisitStopExit(Sender: TObject);
begin
  with txtVisitStop do
  if Text = '' then
  begin
    Text := 'T-1';
    Hint := 'T-1';
    spnVisitStopClick(self, btNext);
  end;
  TextExit(txtVisitStop, FStopEntered, DAYS_LIMIT);
  AdjustVisitLabel;
end;

procedure TfrmOptionsDays.txtVisitStopKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  txtVisitStop.Hint := txtVisitStop.Text;   // put text in hint since text not available to spin
  FStopEntered := true;
end;

procedure TfrmOptionsDays.txtVisitStartKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    FStartEntered := true;
    Perform(WM_NextDlgCtl, 0, 0);
  end;
end;

procedure TfrmOptionsDays.txtVisitStopKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
  begin
    FStopEntered := true;
    Perform(WM_NextDlgCtl, 0, 0);
  end;
end;

end.

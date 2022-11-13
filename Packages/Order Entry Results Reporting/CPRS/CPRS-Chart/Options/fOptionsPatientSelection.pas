unit fOptionsPatientSelection;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, OrFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsPatientSelection = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    cboProvider: TORComboBox;
    cboTreating: TORComboBox;
    cboTeam: TORComboBox;
    cboWard: TORComboBox;
    cboMonday: TORComboBox;
    cboTuesday: TORComboBox;
    cboWednesday: TORComboBox;
    cboThursday: TORComboBox;
    cboFriday: TORComboBox;
    cboSaturday: TORComboBox;
    cboSunday: TORComboBox;
    txtVisitStart: TCaptionEdit;
    txtVisitStop: TCaptionEdit;
    spnVisitStart: TUpDown;
    spnVisitStop: TUpDown;
    lblClinicDays: TLabel;
    lblMonday: TLabel;
    lblTuesday: TLabel;
    lblWednesday: TLabel;
    lblThursday: TLabel;
    lblFriday: TLabel;
    lblSaturday: TLabel;
    lblSunday: TLabel;
    lblVisitStart: TLabel;
    lblVisitStop: TLabel;
    lblVisitDateRange: TMemo;
    lblInfo: TMemo;
    lbWard: TLabel;
    lblTeam: TLabel;
    lblTreating: TLabel;
    lblProvider: TLabel;
    radListSource: TRadioGroup;
    grpSortOrder: TGroupBox;
    radAlphabetical: TRadioButton;
    radRoomBed: TRadioButton;
    radAppointmentDate: TRadioButton;
    radTerminalDigit: TRadioButton;
    radSource: TRadioButton;
    bvlBottom: TBevel;
    cboPCMM: TORComboBox;
    lblPcmm: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spnVisitStartClick(Sender: TObject; Button: TUDBtnType);
    procedure spnVisitStopClick(Sender: TObject; Button: TUDBtnType);
    procedure btnOKClick(Sender: TObject);
    procedure txtVisitStartExit(Sender: TObject);
    procedure txtVisitStopExit(Sender: TObject);
    procedure txtVisitStartKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure txtVisitStopKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboProviderExit(Sender: TObject);
    procedure radListSourceClick(Sender: TObject);
    procedure cboMondayNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure txtVisitStartKeyPress(Sender: TObject; var Key: Char);
    procedure txtVisitStopKeyPress(Sender: TObject; var Key: Char);
    procedure cboProviderKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FStartEntered: boolean;
    FStopEntered: boolean;
    FProviderSpecial: boolean;   // used to avoid duplicate action on cboProviderKeyUp
  public
    { Public declarations }
    procedure NextControl(Key: Char);
  end;

var
  frmOptionsPatientSelection: TfrmOptionsPatientSelection;

procedure DialogOptionsPatientSelection(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, uOptions, rCore, uORLists, uSimilarNames, VAUtils;

{$R *.DFM}

procedure DialogOptionsPatientSelection(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsPatientSelection: TfrmOptionsPatientSelection;
begin
  frmOptionsPatientSelection := TfrmOptionsPatientSelection.Create(Application);
  actiontype := 0;
  try
    with frmOptionsPatientSelection do
    begin
      FProviderSpecial := false;
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsPatientSelection);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsPatientSelection.Release;
  end;
end;

procedure TfrmOptionsPatientSelection.FormCreate(Sender: TObject);
begin
  FStartEntered := false;
  FStopEntered := false;
  cboMonday.InitLongList('');
  cboTuesday.InitLongList('');
  cboWednesday.InitLongList('');
  cboThursday.InitLongList('');
  cboFriday.InitLongList('');
  cboSaturday.InitLongList('');
  cboSunday.InitLongList('');
  cboProvider.InitLongList('');
  ListSpecialtyAll(cboTreating.Items);
  ListTeamAll(cboTeam.Items);
  ListPcmmAll(cboPcmm.Items);
  ListWardAll(cboWard.Items);
end;

procedure TfrmOptionsPatientSelection.FormShow(Sender: TObject);
var
  visitstart, visitstop: integer;
  mon, tues, wed, thurs, fri, sat, sun: integer;
  visitstartdef, visitstopdef: integer;
  defprovider, deftreating, deflist, defward, defpcmm: integer;
  //defsrc: string;
begin
  rpcGetClinicUserDays(visitstart, visitstop);
  visitstartdef := visitstart;
  visitstopdef := visitstop;
  txtVisitStart.Tag := visitstart - 1;
  txtVisitStop.Tag := visitstop - 1;
  spnVisitStart.Tag := visitstartdef;
  spnVisitStop.Tag := visitstopdef;
  spnVisitStartClick(self, btNext);
  spnVisitStopClick(self, btNext);

  rpcGetClinicDefaults(mon, tues, wed, thurs, fri, sat, sun);
  cboMonday.SelectByIEN(mon);
  if cboMonday.Text = '' then
    cboMonday.SetExactByIEN(mon, ExternalName(mon, 44));
  cboTuesday.SelectByIEN(tues);
  if cboTuesday.Text = '' then
    cboTuesday.SetExactByIEN(tues, ExternalName(tues, 44));
  cboWednesday.SelectByIEN(wed);
  if cboWednesday.Text = '' then
    cboWednesday.SetExactByIEN(wed, ExternalName(wed, 44));
  cboThursday.SelectByIEN(thurs);
  if cboThursday.Text = '' then
    cboThursday.SetExactByIEN(thurs, ExternalName(thurs, 44));
  cboFriday.SelectByIEN(fri);
  if cboFriday.Text = '' then
    cboFriday.SetExactByIEN(fri, ExternalName(fri, 44));
  cboSaturday.SelectByIEN(sat);
  if cboSaturday.Text = '' then
    cboSaturday.SetExactByIEN(sat, ExternalName(sat, 44));
  cboSunday.SelectByIEN(sun);
  if cboSunday.Text = '' then
    cboSunday.SetExactByIEN(sun, ExternalName(sun, 44));

  // TDP - Modified 5/28/2014 to handle new possible "E" default list source
  with radListSource do
    case DfltPtListSrc of
      'P': ItemIndex := 0;
      'S': ItemIndex := 1;
      'T': ItemIndex := 2;
      'W': ItemIndex := 3;
      'C': ItemIndex := 4;
      'E': ItemIndex := 5;
      'M': ItemIndex := 6;
    end;
  //defsrc := DefltPtListSrc;
  {with radListSource do
  begin
    if defsrc = 'P' then ItemIndex := 0;
    if defsrc = 'S' then ItemIndex := 1;
    if defsrc = 'T' then ItemIndex := 2;
    if defsrc = 'W' then ItemIndex := 3;
    if defsrc = 'C' then ItemIndex := 4;
    if defsrc = 'PT' then ItemIndex := 5;
    if defsrc = 'M' then ItemIndex := 6;
  end;    }
  radListSourceClick(self);

  case rpcGetListOrder of
    'A': radAlphabetical.Checked := true;
    'R':
      begin
        if radRoomBed.Enabled then
          radRoomBed.Checked := true
        else
          radAlphabetical.Checked := True;
      end;
    'P': 
      begin
        if radAppointmentDate.Enabled then
          radAppointmentDate.Checked := true
        else
          radAlphabetical.Checked := True;
      end;
    'T': radTerminalDigit.Checked := true;
    'S': radSource.Checked := true;
    else
       radAlphabetical.Checked := true;
  end;

  rpcGetListSourceDefaults(defprovider, deftreating, deflist, defward, defpcmm);
  cboProvider.SelectByIEN(defprovider);
  TSimilarNames.RegORComboBox(cboProvider);
  cboTreating.SelectByIEN(deftreating);
  cboTeam.SelectByIEN(deflist);
  cboWard.SelectByIEN(defward);
  cboPcmm.SelectByIEN(defpcmm);

  radListSource.SetFocus;
end;

procedure TfrmOptionsPatientSelection.spnVisitStartClick(Sender: TObject;
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
        DateLimits(SELECTION_LIMIT, tagnum);
        if tagnum <> INVALID_DAYS then
          Tag := tagnum;
      end;
    end;
    SetFocus;
    if Button = btNext then tagnum := Tag + 1
    else tagnum := Tag - 1;
    Text := Hint;
    DateLimits(SELECTION_LIMIT, tagnum);
    if tagnum <> INVALID_DAYS then
      Tag := tagnum;
    ShowDisplay(txtVisitStart);
  end;
  FStartEntered := false;
end;

procedure TfrmOptionsPatientSelection.spnVisitStopClick(Sender: TObject;
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
        DateLimits(SELECTION_LIMIT, tagnum);
        Tag := tagnum;
      end;
    end;
    SetFocus;
    if Button = btNext then tagnum := Tag + 1
    else tagnum := Tag - 1;
    Text := Hint;
    DateLimits(SELECTION_LIMIT, tagnum);
    Tag := tagnum;
    ShowDisplay(txtVisitStop);
  end;
  FStopEntered := false;
end;

procedure TfrmOptionsPatientSelection.btnOKClick(Sender: TObject);
var
  StartDays, StopDays, mon, tues, wed, thurs, fri, sat, sun: integer;
  PLSort: Char;
  PLSource, aErrMsg: string;
  pcmm, prov, spec, team, ward: integer;
begin

  if not CheckForSimilarName(cboProvider, aErrMsg, sPr) then
  begin
    ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Invalid Provider');
    exit;
  end;

  StartDays := txtVisitStart.Tag;
  StopDays := txtVisitStop.Tag;
  mon := cboMonday.ItemIEN;
  tues := cboTuesday.ItemIEN;
  wed := cboWednesday.ItemIEN;
  thurs := cboThursday.ItemIEN;
  fri := cboFriday.ItemIEN;
  sat := cboSaturday.ItemIEN;
  sun := cboSunday.ItemIEN;
  rpcSetClinicDefaults(StartDays, StopDays, mon, tues, wed, thurs, fri, sat, sun);
  case radListSource.ItemIndex of
    0: PLSource := 'P';
    1: PLSource := 'S';
    2: PLSource := 'T';
    3: PLSource := 'W';
    4: PLSource := 'C';
    5: PLSource := 'E'; // TDP - Added 5/27/2014 PCMM Team
    6: PLSource := 'M';
    else
       PLSource := 'P';
  end;
  if radAlphabetical.Checked then PLSort := 'A'
  else if radRoomBed.Checked then PLSort := 'R'
  else if radAppointmentDate.Checked then PLSort := 'P'
  else if radSource.Checked then PLSort := 'S'
  else PLSort := 'T';
  prov := cboProvider.ItemIEN;
  spec := cboTreating.ItemIEN;
  team := cboTeam.ItemIEN;
  ward := cboWard.ItemIEN;
  pcmm := cboPcmm.ItemIEN; // TDP - Added 5/27/2014 PCMM Team
  rpcSetPtListDefaults(PLSource, PLSort, prov, spec, team, ward, pcmm);
  ResetDfltSort;
end;

procedure TfrmOptionsPatientSelection.txtVisitStartExit(Sender: TObject);
begin
  with txtVisitStart do
  if Text = '' then
  begin
    Text := 'T-1';
    Hint := 'T-1';
    spnVisitStartClick(self, btNext);
  end;
  TextExit(txtVisitStart, FStartEntered, SELECTION_LIMIT);
end;

procedure TfrmOptionsPatientSelection.txtVisitStopExit(Sender: TObject);
begin
  with txtVisitStop do
  if Text = '' then
  begin
    Text := 'T-1';
    Hint := 'T-1';
    spnVisitStopClick(self, btNext);
  end;
  TextExit(txtVisitStop, FStopEntered, SELECTION_LIMIT);
end;

procedure TfrmOptionsPatientSelection.txtVisitStartKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  txtVisitStart.Hint := txtVisitStart.Text;   // put text in hint since text not available to spin
  FStartEntered := true;
end;

procedure TfrmOptionsPatientSelection.txtVisitStopKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  txtVisitStop.Hint := txtVisitStop.Text;   // put text in hint since text not available to spin
  FStopEntered := true;
end;

procedure TfrmOptionsPatientSelection.cboProviderExit(Sender: TObject);
begin
  if Sender is TORComboBox then
  begin
    with (Sender as TORComboBox) do
    begin
      if Text = '' then ItemIndex := -1; // TDP (7/23/2014) - Added to clear combo box defaults during save consistently
      if ItemIndex < 0 then
        Text := '';
    end;
  end;
end;

procedure TfrmOptionsPatientSelection.radListSourceClick(Sender: TObject);
begin
  if radListSource.ItemIndex = 4 then
  begin
    if radRoomBed.Checked then
      radAlphabetical.Checked := true;
    radRoomBed.Enabled := false;
    radAppointmentDate.Enabled := true;
  end
  else
  begin
    if radAppointmentDate.Checked then
      radAlphabetical.Checked := true;
    radAppointmentDate.Enabled := false;
    radRoomBed.Enabled := true;
  end;
  if radListSource.ItemIndex = 6 then
  begin
    radSource.Enabled := true;
    radAppointmentDate.Enabled := true;
    radRoomBed.Enabled := false;
  end
  else
    radSource.Enabled := false;
end;

procedure TfrmOptionsPatientSelection.cboMondayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setClinicList((Sender as TORComboBox), StartFrom, Direction);
end;
(* RTC 272867
procedure TfrmOptionsPatientSelection.cboTuesdayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboTuesday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmOptionsPatientSelection.cboWednesdayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboWednesday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmOptionsPatientSelection.cboThursdayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboThursday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmOptionsPatientSelection.cboFridayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboFriday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmOptionsPatientSelection.cboSaturdayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboSaturday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;

procedure TfrmOptionsPatientSelection.cboSundayNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboSunday.ForDataUse(SubSetOfClinics(StartFrom, Direction));
end;
*)

procedure TfrmOptionsPatientSelection.cboProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setProviderList(cboProvider, StartFrom, Direction);
end;

procedure TfrmOptionsPatientSelection.NextControl(Key: Char);
begin
  if Key = #13 then Perform(WM_NextDlgCtl, 0, 0);
end;

procedure TfrmOptionsPatientSelection.txtVisitStartKeyPress(
  Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FStartEntered := true;
    Perform(WM_NextDlgCtl, 0, 0);
  end;
end;

procedure TfrmOptionsPatientSelection.txtVisitStopKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    FStopEntered := true;
    FProviderSpecial := true;    // used to avoid duplicate action on cboProviderKeyUp
    Perform(WM_NextDlgCtl, 0, 0);
  end;
end;

procedure TfrmOptionsPatientSelection.cboProviderKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if not FProviderSpecial then NextControl(Char(Key));
  FProviderSpecial := false;
end;

end.

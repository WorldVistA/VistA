unit fOptionsTeams;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, OrFn, Menus, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsTeams = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnClose: TButton;
    lstPatients: TORListBox;
    lstTeams: TORListBox;
    lblTeams: TLabel;
    lblPatients: TLabel;
    lstUsers: TORListBox;
    lblTeamMembers: TLabel;
    btnRemove: TButton;
    chkPersonal: TCheckBox;
    chkRestrict: TCheckBox;
    bvlBottom: TBevel;
    lblInfo: TMemo;
    lblSubscribe: TLabel;
    cboSubscribe: TORComboBox;
    mnuPopPatient: TPopupMenu;
    mnuPatientID: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure chkPersonalClick(Sender: TObject);
    procedure lstTeamsClick(Sender: TObject);
    procedure chkRestrictClick(Sender: TObject);
    procedure cboSubscribeClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure mnuPatientIDClick(Sender: TObject);
    procedure lstPatientsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cboSubscribeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboSubscribeMouseClick(Sender: TObject);
  private
    FKeyBoarding: boolean;
    { Private declarations }
    procedure FillATeams;
    procedure FillList(alist: TORListBox; members: TStrings);
    procedure MergeList(alist: TORListBox; members: TStrings);
    function ItemNotAMember(alist: TStrings; listnum: string): boolean;
    function MemberNotOnList(alist: TStrings; listnum: string): boolean;
  public
    { Public declarations }
  end;

var
  frmOptionsTeams: TfrmOptionsTeams;

procedure DialogOptionsTeams(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses rOptions, uOptions, rCore, fOptions;

{$R *.DFM}

procedure DialogOptionsTeams(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsTeams: TfrmOptionsTeams;
begin
  frmOptionsTeams := TfrmOptionsTeams.Create(Application);
  actiontype := 0;
  try
    with frmOptionsTeams do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsTeams);
      ShowModal;
    end;
  finally
    frmOptionsTeams.Release;
  end;
end;

procedure TfrmOptionsTeams.FormCreate(Sender: TObject);
begin
  rpcGetTeams(lstTeams.Items);
  lstTeams.ItemIndex := -1;
  FillATeams;
end;

procedure TfrmOptionsTeams.FillATeams;
var
  i: integer;
  alist: TStringList;
begin
  cboSubscribe.Items.Clear;
  alist := TStringList.Create;
  rpcGetAteams(alist);
  for i := 0 to alist.Count - 1 do
  if MemberNotOnList(lstTeams.Items, Piece(alist[i], '^', 1)) then
    cboSubscribe.Items.Add(alist[i]);
  cboSubscribe.Enabled := cboSubscribe.Items.Count > 0;
  lblSubscribe.Enabled := cboSubscribe.Items.Count > 0;
  alist.Free;
end;

procedure TfrmOptionsTeams.FillList(alist: TORListBox; members: TStrings);
var
  i: integer;
begin
  for i := 0 to members.Count - 1 do
  if MemberNotOnList(alist.Items, Piece(members[i], '^', 1)) then
    alist.Items.Add(members[i]);
end;

procedure TfrmOptionsTeams.MergeList(alist: TORListBox; members: TStrings);
var
  i: integer;
begin
  for i := alist.Items.Count - 1 downto 0 do
  if ItemNotAMember(members, Piece(alist.Items[i], '^', 1)) then
    alist.Items.Delete(i);
end;

function TfrmOptionsTeams.ItemNotAMember(alist: TStrings; listnum: string): boolean;
var
  i: integer;
begin
  result := true;
  for i := 0 to alist.Count - 1 do
    if listnum = Piece(alist[i], '^', 1) then
    begin
      result := false;
      break;
    end;
end;

function TfrmOptionsTeams.MemberNotOnList(alist: TStrings; listnum: string): boolean;
var
  i: integer;
begin
  result := true;
  with alist do
  for i := 0 to Count - 1 do
    if listnum = Piece(alist[i], '^', 1) then
    begin
      result := false;
      break;
    end;
end;

procedure TfrmOptionsTeams.chkPersonalClick(Sender: TObject);
begin
  lstTeams.Items.Clear;
  if chkPersonal.Checked then
    rpcGetAllTeams(lstTeams.Items)
  else
    rpcGetTeams(lstTeams.Items);
  lstTeams.ItemIndex := -1;
  lstTeamsClick(self);
end;

procedure TfrmOptionsTeams.lstTeamsClick(Sender: TObject);
var
  i, teamid, cnt: integer;
  astrings: TStringList;
begin
  lstPatients.Items.Clear;
  lstUsers.Items.Clear;
  chkRestrict.Enabled := lstTeams.SelCount > 1;
  astrings := TStringList.Create;
  cnt := 0;
  with lstTeams do
  begin
    for i := 0 to Items.Count - 1 do
    if Selected[i] then
    begin
      inc(cnt);
      teamid := strtointdef(Piece(Items[i], '^', 1), 0);
      if (cnt > 1) and chkRestrict.Checked then
      begin
        ListPtByTeam(astrings, teamid);
        MergeList(lstPatients, astrings);
        rpcListUsersByTeam(astrings, teamid);
        MergeList(lstUsers, astrings);
      end
      else
      begin
        ListPtByTeam(astrings, teamid);
        if astrings.Count = 1 then         // don't fill the '^No patients found.' msg
        begin
          if Piece(astrings[0], '^', 1) <> '' then
            FillList(lstPatients, astrings);
        end
        else
          FillList(lstPatients, astrings);
        rpcListUsersByTeam(astrings, teamid);
        FillList(lstUsers, astrings);
      end;
    end;
    btnRemove.Enabled := (SelCount = 1)
                          and (Piece(Items[ItemIndex], '^', 3) <> 'P')
                          and (Piece(Items[ItemIndex], '^', 7) = 'Y');
    if SelCount > 0 then
    begin
      if lstPatients.Items.Count = 0 then
        lstPatients.Items.Add('^No patients found.');
      if lstUsers.Items.Count = 0 then
        lstUsers.Items.Add('^No team members found.');
    end;
  end;
  astrings.Free;
end;

procedure TfrmOptionsTeams.chkRestrictClick(Sender: TObject);
begin
  lstTeamsClick(self);
end;

procedure TfrmOptionsTeams.cboSubscribeClick(Sender: TObject);
begin
  FKeyBoarding := False
end;

procedure TfrmOptionsTeams.btnRemoveClick(Sender: TObject);
begin
  with lstTeams do
    if InfoBox('Do you want to remove yourself from '
      + Piece(Items[ItemIndex], '^', 2) + '?',
      'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    rpcRemoveList(ItemIEN);
    Items.Delete(ItemIndex);
    lstTeamsClick(self);
    FillATeams;
  end;
end;

procedure TfrmOptionsTeams.mnuPatientIDClick(Sender: TObject);
begin
  DisplayPtInfo(lstPatients.ItemID);
end;

procedure TfrmOptionsTeams.lstPatientsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mnuPopPatient.AutoPopup := (lstPatients.Items.Count > 0)
                              and (lstPatients.ItemIndex > -1)
                              and (Button = mbRight);
end;

procedure TfrmOptionsTeams.cboSubscribeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of VK_RETURN:
    if (cboSubscribe.ItemIndex > -1) then
    begin
      FKeyBoarding := False;
      cboSubscribeMouseClick(self); // Provide onmouseclick behavior.
    end;
  else
    FKeyBoarding := True; // Suppress onmouseclick behavior.
  end;
end;

procedure TfrmOptionsTeams.cboSubscribeMouseClick(Sender: TObject);
begin
  if FKeyBoarding then
    FKeyBoarding := False
  else
  begin
    with cboSubscribe do
    if ItemIndex < 0 then
      exit
    else if InfoBox('Do you want to join '
      + Piece(Items[ItemIndex], '^', 2) + '?',
      'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      rpcAddList(ItemIEN);
      lstTeams.Items.Add(Items[ItemIndex]);
      Items.Delete(ItemIndex);
      ItemIndex := -1;
      Text := '';
      Enabled := Items.Count > 0;
      lblSubscribe.Enabled := Items.Count > 0;
    end
    else
    begin
      ItemIndex := -1;
      Text := '';
    end;
  end;
end;

end.

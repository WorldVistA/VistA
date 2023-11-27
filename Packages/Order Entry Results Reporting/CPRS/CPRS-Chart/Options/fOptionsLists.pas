unit fOptionsLists;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, OrFn, Menus, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOptionsLists = class(TfrmBase508Form)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lblAddBy: TLabel;
    lblPatientsAdd: TLabel;
    lblPersonalPatientList: TLabel;
    lblPersonalLists: TLabel;
    lstAddBy: TORComboBox;
    btnPersonalPatientRA: TButton;
    btnPersonalPatientR: TButton;
    lstListPats: TORListBox;
    lstPersonalPatients: TORListBox;
    btnListAddAll: TButton;
    btnNewList: TButton;
    btnDeleteList: TButton;
    lstPersonalLists: TORListBox;
    radAddByType: TRadioGroup;
    btnListSaveChanges: TButton;
    btnListAdd: TButton;
    lblInfo: TMemo;
    bvlBottom: TBevel;
    mnuPopPatient: TPopupMenu;
    mnuPatientID: TMenuItem;
    grpVisibility: TRadioGroup;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNewListClick(Sender: TObject);
    procedure radAddByTypeClick(Sender: TObject);
    procedure lstPersonalListsChange(Sender: TObject);
    procedure lstAddByClick(Sender: TObject);
    procedure btnDeleteListClick(Sender: TObject);
    procedure btnListSaveChangesClick(Sender: TObject);
    procedure btnPersonalPatientRAClick(Sender: TObject);
    procedure btnListAddAllClick(Sender: TObject);
    procedure btnPersonalPatientRClick(Sender: TObject);
    procedure lstPersonalPatientsChange(Sender: TObject);
    procedure btnListAddClick(Sender: TObject);
    procedure lstListPatsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstAddByNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure mnuPatientIDClick(Sender: TObject);
    procedure lstListPatsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstPersonalPatientsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lstAddByKeyPress(Sender: TObject; var Key: Char);
    procedure grpVisibilityClick(Sender: TObject);
    procedure lstAddByChange(Sender: TObject);
    procedure lstAddByEnter(Sender: TObject);
    procedure lstAddByExit(Sender: TObject);
    procedure lstAddByKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstAddByMouseClick(Sender: TObject);
  private
    { Private declarations }
    FLastList: integer;
    FChanging: boolean;
    FProviderChanging: Boolean;
    FAddSelection: Boolean;
    procedure AddIfUnique(entry: string; aList: TORListBox);
  public
    { Public declarations }
  end;

var
  frmOptionsLists: TfrmOptionsLists;

procedure DialogOptionsLists(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);

implementation

uses fOptionsNewList, rOptions, uOptions, rCore, mPtSelOptns, VAUtils, uORLists, uSimilarNames;

{$R *.DFM}

const
  LIST_ADD = 1;
  LIST_PERSONAL = 2;

procedure DialogOptionsLists(topvalue, leftvalue, fontsize: integer; var actiontype: Integer);
// create the form and make it modal, return an action
var
  frmOptionsLists: TfrmOptionsLists;
begin
  frmOptionsLists := TfrmOptionsLists.Create(Application);
  actiontype := 0;
  try
    with frmOptionsLists do
    begin
      if (topvalue < 0) or (leftvalue < 0) then
        Position := poScreenCenter
      else
      begin
        Position := poDesigned;
        Top := topvalue;
        Left := leftvalue;
      end;
      ResizeAnchoredFormToFont(frmOptionsLists);
      ShowModal;
      actiontype := btnOK.Tag;
    end;
  finally
    frmOptionsLists.Release;
  end;
end;

procedure TfrmOptionsLists.FormCreate(Sender: TObject);
begin
  rpcGetPersonalLists(lstPersonalLists.Items);
  grpVisibility.ItemIndex := 1;
  grpVisibility.Enabled := FALSE;
  radAddByType.ItemIndex := 0;
  radAddByTypeClick(self);
  FLastList := 0;
end;

procedure TfrmOptionsLists.btnNewListClick(Sender: TObject);
var
  newlist: string;
  newlistnum: integer;
begin
  newlist := '';
  DialogOptionsNewList(Font.Size, newlist);
  newlistnum := strtointdef(Piece(newlist, '^', 1), 0);
  if newlistnum > 0 then
  begin
    with lstPersonalLists do
    begin
      Items.Add(newlist);
      SelectByIEN(newlistnum);
    end;
    lstPersonalListsChange(self);
    lstPersonalPatients.Items.Clear;
    lstPersonalPatientsChange(self);
  end;
end;

procedure TfrmOptionsLists.radAddByTypeClick(Sender: TObject);
begin
  with lstAddBy do
  begin
    Clear;
    case radAddByType.ItemIndex of
      0: begin
           ListItemsOnly := false;
           LongList := true;
           InitLongList('');
           lblAddBy.Caption := 'Patient:';
         end;
      1: begin
           ListItemsOnly := false;
           LongList := false;
           ListWardAll(lstAddBy.Items);
           lblAddBy.Caption := 'Ward:';
         end;
      2: begin
           ListItemsOnly := false;
           LongList := true;
           InitLongList('');
           lblAddBy.Caption := 'Clinic:';
         end;
      3: begin
           ListItemsOnly := false;
           LongList := true;
           InitLongList('');
           lblAddBy.Caption := 'Provider:';
         end;
      4: begin
           ListItemsOnly := false;
           LongList := false;
           ListSpecialtyAll(lstAddBy.Items);
           lblAddBy.Caption := 'Specialty:';
         end;
      5: begin
           ListItemsOnly := false;
           LongList := false;
           ListTeamAll(lstAddBy.Items);
           lblAddBy.Caption := 'List:';
         end;
      6: begin
           ListItemsOnly := false;
           LongList := false;
           ListPcmmAll(lstAddBy.Items);
           lblAddBy.Caption := 'PCMM Team:';
         end;

    end;
    lstAddBy.Caption := lblAddBy.Caption;
    ItemIndex := -1;
    Text := '';
  end;
    lstListPats.Items.Clear;
    lstListPatsChange(self);
end;

procedure TfrmOptionsLists.AddIfUnique(entry: string; aList: TORListBox);
var
  i: integer;
  ien: string;
  inlist: boolean;
begin
  ien := Piece(entry, '^', 1);
  inlist := false;
  with aList do
  for i := 0 to Items.Count - 1 do
    if ien = Piece(Items[i], '^', 1) then
    begin
      inlist := true;
      break;
    end;
  if not inlist then
    aList.Items.Add(entry);
end;

procedure TfrmOptionsLists.lstPersonalListsChange(Sender: TObject);
var
  x: integer;
begin
  if (btnListSaveChanges.Enabled) and (not FChanging) then
  begin
    if InfoBox('Do you want to save changes to '
        + Piece(lstPersonalLists.Items[FLastList], '^', 2) + '?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      btnListSaveChangesClick(self);
  end;
  if lstPersonalLists.ItemIndex > -1 then FLastList := lstPersonalLists.ItemIndex;
  lstPersonalPatients.Items.Clear;
  btnDeleteList.Enabled := lstPersonalLists.ItemIndex > -1;
  with lstPersonalLists do
  begin
    if (ItemIndex < 0) or (Items.Count <1) then
    begin
      btnListAdd.Enabled := false;
      btnListAddAll.Enabled := false;
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      btnListSaveChanges.Enabled := false;
      grpVisibility.Enabled := False;
      exit;
    end;
    ListPtByTeam(lstPersonalPatients.Items, strtointdef(Piece(Items[ItemIndex], '^', 1), 0));
    grpVisibility.Enabled := TRUE;
    FChanging := True;
    x := StrToIntDef(Piece(Items[ItemIndex], '^', 9), 1);
    if x = 2 then x := 1;
    grpVisibility.ItemIndex := x;
    FChanging := False;
    btnDeleteList.Enabled := true;
  end;
  if lstPersonalPatients.Items.Count = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstPersonalPatients.Items[0], '^', 1) = '' then
    begin
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      exit;
    end;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := false;
end;

procedure TfrmOptionsLists.lstAddByChange(Sender: TObject);
var
 aErrMsg: String;

  procedure ShowMatchingPatients;
  begin
    with lstAddBy do begin
      if ShortCount > 0 then begin
        if ShortCount = 1 then begin
          ItemIndex := 0;
        end;
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      InitLongList('');
    end;
  end;

begin
  inherited;
  if FProviderChanging and ((radAddByType.ItemIndex = 0) or (radAddByType.ItemIndex = 3)) then
    exit;

  if radAddByType.ItemIndex = 0 {patient} then begin
    with lstAddBy do
    if TfraPtSelOptns.IsLast5(Text) then begin
        ListPtByLast5(Items, Text);
        ShowMatchingPatients;
      end
    else if TfraPtSelOptns.IsFullSSN(Text) then begin
        ListPtByFullSSN(Items, Text);
        ShowMatchingPatients;
    end;
  end;

 if radAddByType.ItemIndex = 3 then
  begin
    if not CheckForSimilarName(lstAddBy, aErrMsg, sPr, lstPersonalLists.Items) then
    begin
      ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Invalid Provider');
    end;
  end;

  if FAddSelection or (radAddByType.ItemIndex <> 0) then
  begin
    FAddSelection := False;
    lstAddByClick(sender);
  end;
end;


procedure TfrmOptionsLists.lstAddByClick(Sender: TObject);
var
  ien: string;
  visitstart, visitstop, i: integer;
  visittoday, visitbegin, visitend: TFMDateTime;
  aList: TStringList;
  PtRec: TPtIDInfo;
begin
  if lstAddBy.ItemIndex < 0 then exit;
  ien := Piece(lstAddBy.Items[lstAddBy.ItemIndex], '^', 1);
  If ien = '' then exit;
  case radAddByType.ItemIndex of
    0:
    begin
      PtRec := GetPtIDInfo(ien);
      lblAddBy.Caption := 'Patient:   SSN: ' + PtRec.SSN;
      lstAddBy.Caption := lblAddBy.Caption;
      AddIfUnique(lstAddBy.Items[lstAddBy.ItemIndex], lstListPats);
    end;
    1:
    begin
      ListPtByWard(lstListPats.Items, strtointdef(ien,0));
    end;
    2:
    begin
      rpcGetApptUserDays(visitstart, visitstop);   // use user's date range for appointments
      visittoday := FMToday;
      visitbegin := FMDateTimeOffsetBy(visittoday, LowerOf(visitstart, visitstop));
      visitend := FMDateTimeOffsetBy(visittoday, HigherOf(visitstart, visitstop));
      aList := TStringList.Create;
      ListPtByClinic(lstListPats.Items, strtointdef(ien, 0), floattostr(visitbegin), floattostr(visitend));
      for i := 0 to aList.Count - 1 do
        AddIfUnique(aList[i], lstListPats);
      aList.Free;
    end;
    3:
    begin
      ListPtByProvider(lstListPats.Items, strtoint64def(ien,0));
    end;
    4:
    begin
      ListPtBySpecialty(lstListPats.Items, strtointdef(ien,0));
    end;
    5:
    begin
      ListPtByTeam(lstListPats.Items, strtointdef(ien,0));
    end;
    6:
    begin
      ListPtByPCMMTeam(lstListPats.Items, strtointdef(ien,0));
    end;

  end;
  if lstListPats.Items.Count = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstListPats.Items[0], '^', 1) = '' then
    begin
      btnListAddAll.Enabled := false;
      btnListAdd.Enabled := false;
      exit;
    end;
  btnListAddAll.Enabled := (lstListPats.Items.Count > 0) and (lstPersonalLists.ItemIndex > -1);
  btnListAdd.Enabled := (lstListPats.SelCount > 0) and (lstPersonalLists.ItemIndex > -1);
end;

procedure TfrmOptionsLists.lstAddByEnter(Sender: TObject);
begin
  inherited;
  FProviderChanging := true;
  FAddSelection := False;
end;

procedure TfrmOptionsLists.lstAddByExit(Sender: TObject);
begin
  inherited;
  FAddSelection := False;
  if FProviderChanging then
  begin
    FProviderChanging := False;
    lstAddByChange(sender);
  end;
end;

procedure TfrmOptionsLists.btnDeleteListClick(Sender: TObject);
var
  oldindex: integer;
  deletemsg: string;
begin
  with lstPersonalLists do
    deletemsg := 'You have selected "' + DisplayText[ItemIndex]
      + '" to be deleted.' + CRLF + 'Are you sure you want to delete this list?';
  if InfoBox(deletemsg, 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    btnListSaveChanges.Enabled := false;
    with lstPersonalLists do
    begin
      oldindex := ItemIndex;
      if oldindex > -1 then
      begin
        rpcDeleteList(Piece(Items[oldindex], '^', 1));
        Items.Delete(oldindex);
        btnPersonalPatientRAClick(self);
        btnListSaveChanges.Enabled := false;
      end;
      if Items.Count > 0 then
      begin
        if oldindex = 0 then
          ItemIndex := 0
        else if oldindex > (Items.Count - 1) then
          ItemIndex := Items.Count - 1
        else
          ItemIndex := oldindex;
        btnListSaveChanges.Enabled := false;
        lstPersonalListsChange(self);
      end;
    end;
  end;
end;

procedure TfrmOptionsLists.btnListSaveChangesClick(Sender: TObject);
var
  listien: integer;
begin
  listien := strtointdef(Piece(lstPersonalLists.Items[FLastList], '^', 1), 0);
  rpcSaveListChanges(lstPersonalPatients.Items, listien, grpVisibility.ItemIndex);
  btnListSaveChanges.Enabled := false;
  rpcGetPersonalLists(lstPersonalLists.Items);
  lstPersonalLists.ItemIndex := FLastList;
  lstPersonalListsChange(Self);
  if lstPersonalPatients.CanFocus then
    lstPersonalPatients.SetFocus;
end;

procedure TfrmOptionsLists.btnPersonalPatientRAClick(Sender: TObject);
begin
  lstPersonalPatients.Items.Clear;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.btnListAddAllClick(Sender: TObject);
var
  i: integer;
begin
  with lstPersonalPatients do
  begin
    if Items.Count = 1 then
      if Piece(Items[0], '^', 1) = '' then
        Items.Clear;
  end;
  with lstListPats do
  begin
    for i := 0 to Items.Count - 1 do
      AddIfUnique(Items[i], lstPersonalPatients);
    Items.Clear;
    lstPersonalPatientsChange(self);
    lstAddBy.ItemIndex := -1;
    btnListAddAll.Enabled := false;
    lstPersonalPatientsChange(self);
  end;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.btnPersonalPatientRClick(Sender: TObject);
var
  i: integer;
begin
  if not btnPersonalPatientR.Enabled then exit;
  with lstPersonalPatients do
  for i := Items.Count - 1 downto 0 do
    if Selected[i] then
      Items.Delete(i);
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.lstPersonalPatientsChange(Sender: TObject);
begin
  if lstPersonalPatients.SelCount = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstPersonalPatients.Items[0], '^', 1) = '' then
    begin
      btnPersonalPatientR.Enabled := false;
      btnPersonalPatientRA.Enabled := false;
      exit;
    end;
  btnPersonalPatientR.Enabled := lstPersonalPatients.SelCount > 0;
  btnPersonalPatientRA.Enabled := lstPersonalPatients.Items.Count > 0;
end;

procedure TfrmOptionsLists.btnListAddClick(Sender: TObject);
var
  i: integer;
begin
  if not btnListAdd.Enabled then exit;
  with lstPersonalPatients do
  begin
    if Items.Count = 1 then
      if Piece(Items[0], '^', 1) = '' then
        Items.Clear;
  end;
  with lstListPats do
  for i := Items.Count - 1 downto 0 do
    if Selected[i] then
    begin
      AddIfUnique(Items[i], lstPersonalPatients);
      Items.Delete(i);
    end;
  lstListPatsChange(self);
  lstPersonalPatientsChange(self);
  btnListSaveChanges.Enabled := true;
end;

procedure TfrmOptionsLists.lstListPatsChange(Sender: TObject);
begin
  if lstListPats.SelCount = 1 then         // avoid selecting '^No patients found.' msg
    if Piece(lstListPats.Items[0], '^', 1) = '' then
      exit;
  btnListAdd.Enabled := (lstListPats.SelCount > 0) and (lstPersonalLists.ItemIndex > -1);
  btnListAddAll.Enabled := (lstListPats.Items.Count > 0) and (lstPersonalLists.ItemIndex > -1);
end;

procedure TfrmOptionsLists.FormShow(Sender: TObject);
begin
  with lstPersonalLists do
    if Items.Count < 1 then
      ShowMsg('You have no personal lists. Use "New List..." to create one.')
    else
    begin
      ItemIndex := 0;
      lstPersonalListsChange(self);
    end;
end;

procedure TfrmOptionsLists.grpVisibilityClick(Sender: TObject);
begin
  inherited;
  if not FChanging then btnListSaveChanges.Enabled := True;
end;

procedure TfrmOptionsLists.lstAddByNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  with lstAddBy do
  begin
    case radAddByType.ItemIndex of
      0: begin
           Pieces := '2';
           setPatientList(lstAddBy, StartFrom, Direction);
         end;
      1: begin
           Pieces := '2';
         end;
      2: begin
           Pieces := '2';
           setClinicList(lstAddBy, StartFrom, Direction);
         end;
      3: begin
           Pieces := '2,3';
           setProviderList(lstAddBy, StartFrom, Direction);
         end;
      4: begin
           Pieces := '2';
         end;
      5: begin
           Pieces := '2';
         end;
    end;
  end;
end;

procedure TfrmOptionsLists.btnOKClick(Sender: TObject);
begin
  if btnListSaveChanges.Enabled then
  begin
    if InfoBox('Do you want to save changes to '
        + Piece(lstPersonalLists.Items[FLastList], '^', 2) + '?',
        'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      btnListSaveChangesClick(self);
  end;
end;

procedure TfrmOptionsLists.mnuPatientIDClick(Sender: TObject);
begin
  case mnuPopPatient.Tag of
    LIST_PERSONAL: DisplayPtInfo(lstPersonalPatients.ItemID);
    LIST_ADD:      DisplayPtInfo(lstListPats.ItemID);
  end;
end;

procedure TfrmOptionsLists.lstListPatsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mnuPopPatient.AutoPopup :=      (lstListPats.Items.Count > 0)
                              and (lstListPats.ItemIndex > -1)
                              and (lstListPats.SelCount = 1)
                              and (Button = mbRight)
                              and (btnListAdd.Enabled);
  mnuPopPatient.Tag := LIST_ADD;
end;

procedure TfrmOptionsLists.lstPersonalPatientsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mnuPopPatient.AutoPopup :=      (lstPersonalPatients.Items.Count > 0)
                              and (lstPersonalPatients.ItemIndex > -1)
                              and (lstPersonalPatients.SelCount = 1)
                              and (Button = mbRight)
                              and (btnPersonalPatientR.Enabled);
  mnuPopPatient.Tag := LIST_PERSONAL;
end;

procedure TfrmOptionsLists.lstAddByKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  if (radAddByType.ItemIndex = 0) then
  begin
    FProviderChanging := ((Key = VK_UP) or (Key = VK_DOWN) or
        (Key = VK_PRIOR) or (Key = VK_NEXT));
    FAddSelection := (Key = VK_RETURN);
  end else if (radAddByType.ItemIndex = 3) then
  begin
    FProviderChanging := (Key <> VK_RETURN);
  end;
end;

procedure TfrmOptionsLists.lstAddByKeyPress(Sender: TObject;
  var Key: Char);

  procedure ShowMatchingPatients;
  begin
    with lstAddBy do
    begin
      if ShortCount > 0 then
      begin
        if ShortCount = 1 then
        begin
          ItemIndex := 0;
        end;
        Items.Add(LLS_LINE);
        Items.Add(LLS_SPACE);
      end;
      InitLongList('');
    end;
    Key := #0; //Now that we've selected it, don't process the last keystroke!
  end;

var
  FutureText: string;
begin
  if radAddByType.ItemIndex = 0 {patient} then
  begin
    with lstAddBy do
    begin
      FutureText := Text + Key;
      if TfraPtSelOptns.IsLast5(FutureText) then
        begin
          ListPtByLast5(Items, FutureText);
          ShowMatchingPatients;
        end
      else if TfraPtSelOptns.IsFullSSN(FutureText) then
        begin
          ListPtByFullSSN(Items, FutureText);
          ShowMatchingPatients;
        end;
    end;
  end;
end;

procedure TfrmOptionsLists.lstAddByMouseClick(Sender: TObject);
begin
  inherited;
  FProviderChanging := False;
  FAddSelection := True;
  lstAddByChange(sender);
end;

end.

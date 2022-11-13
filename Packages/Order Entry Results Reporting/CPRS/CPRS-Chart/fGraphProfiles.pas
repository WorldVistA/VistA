unit fGraphProfiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, CheckLst, ORCtrls, ORFn, uGraphs, rCore, uCore,
  fBase508Form, VA508AccessibilityManager;

type
  TfrmGraphProfiles = class(TfrmBase508Form)
    btnAdd: TButton;
    btnAddAll: TButton;
    btnClear: TButton;
    btnClose: TButton;
    btnDelete: TButton;
    btnRemoveAll: TButton;
    btnRemoveOne: TButton;
    btnRename: TButton;
    btnSave: TButton;
    btnSavePublic: TButton;
    bvlBase: TBevel;
    cboAllItems: TORComboBox;
    lblApply: TLabel;
    lblDisplay: TLabel;
    lblEditInfo: TLabel;
    lblEditInfo1: TLabel;
    lblSelectandDefine: TLabel;
    lblSelection: TLabel;
    lblSelectionInfo: TLabel;
    lstActualItems: TORListBox;
    lstDrugClass: TListBox;
    lstItemsDisplayed: TORListBox;
    lstItemsSelection: TORListBox;
    lstScratch: TListBox;
    lstTests: TListBox;
    pnlApply: TPanel;
    pnlSource: TPanel;
    pnlTempData: TPanel;
    radSourceAll: TRadioButton;
    radSourcePat: TRadioButton;
    radTop: TRadioButton;
    radBottom: TRadioButton;
    radBoth: TRadioButton;
    radNeither: TRadioButton;
    lblSave: TLabel;
    lblClose: TLabel;
    lblUser: TLabel;
    pnlAllSources: TPanel;
    pnlSources: TPanel;
    lblSource: TLabel;
    lstSources: TORListBox;
    pnlOtherSources: TPanel;
    pnlOtherSourcesUser: TPanel;
    lblOtherPersons: TLabel;
    cboUser: TORComboBox;
    pnlOtherSourcesBottom: TPanel;
    lstOtherSources: TORListBox;
    btnViews: TButton;
    btnDefinitions: TButton;
    pnlOtherViews: TPanel;
    lblOtherViews: TLabel;
    splViews: TSplitter;
    lbl508EditInfo: TVA508StaticText;
    lbl508EditInfo1: TVA508StaticText;
    lbl508Apply: TVA508StaticText;
    lbl508SelectOthers: TVA508StaticText;
    lbl508SelectionInfo: TVA508StaticText;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDefinitionsClick(Sender: TObject);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure btnRemoveOneClick(Sender: TObject);
    procedure btnViewsClick(Sender: TObject);
    procedure cboAllItemsClick(Sender: TObject);
    procedure cboAllItemsChange(Sender: TObject);
    procedure cboAllItemsNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboUserNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure lstItemsDisplayedChange(Sender: TObject);
    procedure lstItemsDisplayedDblClick(Sender: TObject);
    procedure lstSourcesChange(Sender: TObject);
    procedure lstSourcesDblClick(Sender: TObject);
    procedure lstSourcesEnter(Sender: TObject);
    procedure lstSourcesExit(Sender: TObject);
    procedure lstOtherSourcesEnter(Sender: TObject);
    procedure lstOtherSourcesExit(Sender: TObject);
    procedure radSourceAllClick(Sender: TObject);

    procedure btnDeleteClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);

    procedure AddToList(aItem: string; aListBox: TORListBox);
    procedure ArrangeList(aCheckFile, aCheckItem, aItem: string;
      aListBox: TORListBox; var addtolist: boolean);
    procedure AssignHints;
    procedure AssignProfile(aList: TStrings; aProfile: string; UserNum: int64; allitems: boolean);
    procedure AssignProfilePre(aList: TStrings; var aProfile: string; UserNum: int64);
    procedure AssignProfilePost(aList: TStrings; var aProfile, typedata: string);
    procedure CheckPublic;
    procedure FillSource(aList: TORListBox);
    function ProfileExists(aName, aType: string): boolean;
    procedure lstOtherSourcesChange(Sender: TObject);
    procedure cboUserChange(Sender: TObject);
    procedure cboUserEnter(Sender: TObject);
    procedure cboUserExit(Sender: TObject);
    procedure cboUserKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboUserMouseClick(Sender: TObject);
    procedure cboUserClick(Sender: TObject);
  private
    FHintPauseTime: integer;
    FPublicEditor: boolean;
    FChanging: Boolean;
    procedure CheckToClear;
    procedure QualifierDelete(line: string);
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
  public
    procedure AllItemsAfter(var filetype, typedata: string);
    procedure AllItemsBefore(var typedata: string);
    procedure IDProfile(var profilename, proftype: string);
    procedure ListBoxSetup(Sender: TObject);
    procedure ComboBoxSetup(Sender: TObject);
    procedure Report(aListBox: TORListBox);
    function GetProfileName(infotitle, info: string; var newprofilename: string): boolean;
  end;

var
  frmGraphProfiles: TfrmGraphProfiles;

procedure DialogOptionsGraphProfiles(var actiontype: boolean);
procedure DialogGraphProfiles(var actionOK: boolean;
  var checkaction: boolean; aGraphSetting: TGraphSetting;
  var aProfname, aProfilestring, aSection: string;
  const PatientDFN: string; var aCounter: integer;
  apply: boolean; aSelections: string);

implementation

{$R *.DFM}

uses
  UITypes, rGraphs, fGraphData, fGraphOthers, fRptBox, VAUtils, uORLists, uSimilarNames;

procedure DialogOptionsGraphProfiles(var actiontype: boolean);
// create the form and make it modal, return an action
var
  FGraphSetting: TGraphSetting;
  settings: string;
  actionOK, checkaction: boolean;
  counter: integer;
  aSelections, profile, profilestring, section: string;
begin
  if (GtslData = nil) then
  begin
    ShowMsg(TXT_NOGRAPHING);
    exit;
  end;
  settings := GetCurrentSetting;
  FGraphSetting := GraphSettingsInit(settings);
  checkaction := false;
  actionOK := false;
  profile := '*';
  counter := BIG_NUMBER;
  aSelections :='';
  DialogGraphProfiles(actionOK, checkaction, FGraphSetting,
    profile, profilestring, section, Patient.DFN, counter, false, aSelections);
  FGraphSetting.Free;
end;

procedure DialogGraphProfiles(var actionOK: boolean;
  var checkaction: boolean; aGraphSetting: TGraphSetting;
  var aProfname, aProfilestring, aSection: string;
  const PatientDFN: string; var aCounter: integer;
  apply: boolean; aSelections: string);
var
  i: integer;
  astring, counter, profile, profileitem, profiletype, profiletext: string;
  frmGraphProfiles: TfrmGraphProfiles;
begin
  frmGraphProfiles := TfrmGraphProfiles.Create(Application);
  try
    with frmGraphProfiles do
    begin
      lblSave.Hint := aProfname;
      lblClose.Hint := PatientDFN;
      if apply then
      begin
        pnlApply.Visible := true;
        frmGraphProfiles.Caption := 'Select Items and Define Views';
      end
      else
      begin
        pnlApply.Visible := false;
        frmGraphProfiles.Caption := 'Define Views';
      end;
      if length(aSelections) > 0 then
      begin
        if GtslViews.Count = 0 then
          GtslViews.Insert(0, VIEW_CURRENT + '^<current selections>^' + aSelections)
        else if Piece(GtslViews[0], '^', 1) <> VIEW_CURRENT then
          GtslViews.Insert(0, VIEW_CURRENT + '^<current selections>^' + aSelections)
        else
          GtslViews[0] := VIEW_CURRENT + '^<current selections>^' + aSelections;
      end;
      ResizeAnchoredFormToFont(frmGraphProfiles);
      ShowModal;
      actionOK := (btnClose.Tag = 1);
      profiletext := '';
      aProfname := '';
      if actionOK then
      begin
        aProfname := lblSave.Hint;
        if radTop.Checked then aSection := 'top'
        else if radBottom.Checked then aSection := 'bottom'
        else if radBoth.Checked then aSection := 'both'
        else aSection := 'neither';
        profile := '';
        with lstItemsDisplayed do
        for i := 0 to Items.Count - 1 do
        begin
          astring := Items[i];
          profiletext := profiletext + Piece(astring, '^', 3) + '^';
          profiletype := Piece(astring, '^', 1);
          if profiletype = '8925' then
            profileitem := UpperCase(Piece(astring, '^', 3))
          else
            profileitem := Piece(astring, '^', 2);
          profile := profile + profiletype + '~' + profileitem + '~|';
        end;
        if (GtslViews.Count > 0) and (Piece(GtslViews[0], '^', 1) = VIEW_CURRENT) then
          counter := inttostr(GtslViews.Count)
        else
          counter := inttostr(GtslViews.Count + 1);
        aProfileString := '<view' + counter + '>^' + profile + '^' + profiletext;
        GtslViews.Add(aProfileString);
        aCounter := strtointdef(counter, BIG_NUMBER);
        with aGraphSetting do
        begin
          lstActualItems.Items.Clear;
          with lstItemsDisplayed do
          for i := 0 to Items.Count - 1 do
          begin
            lstActualItems.Items.Add(Piece(Items[i], '<', 1));  //get rid of <any>
          end;
          ItemsForDisplay := lstActualItems.Items;
        end;
      end;
    end;
  finally
    frmGraphProfiles.Release;
  end;
end;

procedure TfrmGraphProfiles.FormCreate(Sender: TObject);
begin
  FPublicEditor := GraphPublicEditor;
  if ScreenReaderActive then
  begin
    lbl508EditInfo.Enabled := True;
    lbl508EditInfo.Visible := True;
    lbl508EditInfo.TabStop := True;
    lbl508EditInfo1.Enabled := True;
    lbl508EditInfo1.Visible := True;
    lbl508EditInfo1.TabStop := True;
    lbl508SelectionInfo.Enabled := True;
    lbl508SelectionInfo.Visible := True;
    lbl508SelectionInfo.TabStop := True;
    lbl508Apply.Enabled := True;
    lbl508Apply.Visible := True;
    lbl508Apply.TabStop := True;
    lbl508SelectOthers.TabStop := True;
  end;
end;

procedure TfrmGraphProfiles.FormShow(Sender: TObject);
begin
  if GtslData = nil then
  begin
    radSourceAll.Checked := true;
    radSourcePat.Enabled := false;
  end
  else if GtslData.Count < 1 then
  begin
    radSourceAll.Checked := true;
    radSourcePat.Enabled := false;
  end;
  cboAllItems.Visible := radSourceAll.Checked;
  FillSource(lstSources);
  cboUser.InitLongList('');
  FHintPauseTime := Application.HintHidePause;
  Application.HintHidePause := 9000; // uses a longer hint pause time
end;

procedure TfrmGraphProfiles.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.HintHidePause := FHintPauseTime;
end;

procedure TfrmGraphProfiles.radSourceAllClick(Sender: TObject);
var
  dfn: string;
begin
  if Sender = radSourceAll then
  begin
    lstItemsSelection.Visible := false;
    cboAllItems.Visible := true;
  end
  else
  begin
    if radSourcePat.Tag = 0 then
    begin
      dfn := lblClose.Hint;
      rpcGetAllItems(lstTests.Items, dfn);  // items for patient
      rpcGetItems(lstDrugClass.Items, '50.605', dfn);
      radSourcePat.Tag := 1;
    end;
    cboAllItems.Visible := false;
    lstItemsSelection.Visible := true;
  end;
  if lstSources.ItemIndex > 0 then
  begin
    lstSources.Tag := BIG_NUMBER;
    lstSourcesChange(lstSources);
  end
  else if lstSources.ItemIndex > 0 then
  begin
    lstOtherSources.Tag := BIG_NUMBER;
    lstOtherSourcesChange(lstOtherSources);
  end;
end;

procedure TfrmGraphProfiles.lstSourcesChange(Sender: TObject);
var
// CQ #15852 - Changed UserNum to Int64 for a long DUZ - JCS
  UserNum: int64;
  filetype, typedata: string;
  aListBox: TORListBox;
begin
  CheckPublic;
  aListBox := (Sender as TORListBox);
  if aListBox = lstOtherSources then
    exit;
  if lstSources.Tag <> BIG_NUMBER then
    exit;
  UserNum := User.DUZ;
  lstOtherSources.ItemIndex := -1;
  cboAllItems.Items.Clear;
  cboAllItems.Text := '';
  if aListBox.ItemIndex = -1 then exit;
  typedata :=  aListBox.Items[aListBox.ItemIndex];
  if pos(LLS_FRONT, typedata) > 0 then  // <clear all selections>
  begin
    lstItemsSelection.Clear;
    cboAllItems.Items.Clear;
    cboAllItems.Text := '';
    exit;
  end;
  filetype := Piece(typedata, '^', 1);
  if (filetype = VIEW_PERSONAL)
  or (filetype = VIEW_PUBLIC)
  or (filetype = VIEW_LABS)
  or (filetype = VIEW_TEMPORARY)
  or (filetype = VIEW_CURRENT) then
  begin
    AssignProfile(cboAllItems.Items, typedata, UserNum, false);
    FastAssign(cboAllItems.Items, lstItemsSelection.Items);
  end
  else
  begin
    AllItemsBefore(typedata);
    AllItemsAfter(filetype, typedata);
  end;
  cboAllItemsChange(cboAllItems);
end;

procedure TfrmGraphProfiles.lstSourcesDblClick(Sender: TObject);
begin
  if cboAllItems.Visible then
  begin
    if cboAllItems.Items.Count < 1 then exit;
    cboAllItems.ItemIndex := 0;
    cboAllItemsClick(cboAllItems);
  end
  else
  begin
    if lstItemsSelection.Items.Count < 1 then exit;
    lstItemsSelection.Selected[0] := true;
    cboAllItemsClick(lstItemsSelection);
  end;
end;

procedure TfrmGraphProfiles.lstSourcesEnter(Sender: TObject);
begin
  lstSources.Tag := BIG_NUMBER;
end;

procedure TfrmGraphProfiles.lstSourcesExit(Sender: TObject);
begin
  lstSources.Tag := 0;
end;

procedure TfrmGraphProfiles.lstOtherSourcesChange(Sender: TObject);
var
// CQ #15852 - Changed UserNum to Int64 for a long DUZ - JCS
  UserNum: int64;
  filetype, typedata: string;
  aListBox: TORListBox;
begin
  CheckPublic;
  aListBox := (Sender as TORListBox);
  if aListBox = lstSources then
    exit;
  if lstOtherSources.Tag <> BIG_NUMBER then
    exit;
  UserNum := cboUser.ItemID;
  lstSources.ItemIndex := -1;
  cboAllItems.Items.Clear;
  cboAllItems.Text := '';
  if aListBox.ItemIndex = -1 then exit;
  typedata :=  aListBox.Items[aListBox.ItemIndex];
  if pos(LLS_FRONT, typedata) > 0 then  // <clear all selections>
  begin
    lstItemsSelection.Clear;
    cboAllItems.Items.Clear;
    cboAllItems.Text := '';
    exit;
  end;
  filetype := Piece(typedata, '^', 1);
  if (filetype = VIEW_PERSONAL)
  or (filetype = VIEW_PUBLIC)
  or (filetype = VIEW_LABS) then
  begin
    AssignProfile(cboAllItems.Items, typedata, UserNum, false);
    FastAssign(cboAllItems.Items, lstItemsSelection.Items);
  end
  else
  begin
    AllItemsBefore(typedata);
    AllItemsAfter(filetype, typedata);
  end;
  cboAllItemsChange(cboAllItems);
end;

procedure TfrmGraphProfiles.lstOtherSourcesEnter(Sender: TObject);
begin
  lstOtherSources.Tag := BIG_NUMBER;
end;

procedure TfrmGraphProfiles.lstOtherSourcesExit(Sender: TObject);
begin
  lstOtherSources.Tag := 0;
end;

procedure TfrmGraphProfiles.cboUserChange(Sender: TObject);
var
 ErrMsg: String;
begin
  inherited;
  if FChanging then
    exit;

  if not CheckForSimilarName(cboUser, ErrMsg, sPr) then
  begin
    ShowMsgOn(Trim(ErrMsg) <> '' , ErrMsg, 'Similiar Name Selection');
    exit;
  end;

  cboUserClick(Sender);
end;

procedure TfrmGraphProfiles.cboUserClick(Sender: TObject);
begin
  inherited;

  FillSource(lstOtherSources);
  if cboUser.ItemIndex <> -1 then
    lblOtherViews.Caption := cboUser.DisplayText[cboUser.ItemIndex] + ' Views:'
  else
    lblOtherViews.Caption := 'Other Views:'
end;

procedure TfrmGraphProfiles.cboUserEnter(Sender: TObject);
begin
  inherited;
  FChanging := true;
end;

procedure TfrmGraphProfiles.cboUserExit(Sender: TObject);
begin
  inherited;
  if FChanging then
  begin
    FChanging := False;
    cboUserChange(sender);
  end;
end;

procedure TfrmGraphProfiles.cboUserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FChanging := True;

  if Key = VK_LEFT then
    Key := VK_UP;
  if Key = VK_RIGHT then
    Key := VK_DOWN;
  if Key = VK_RETURN then
    FChanging := False;
end;

procedure TfrmGraphProfiles.cboUserMouseClick(Sender: TObject);
begin
  inherited;
  if FChanging then
  begin
    FChanging := False;
    cboUserChange(sender);
  end;
end;

procedure TfrmGraphProfiles.cboUserNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  setPersonList(cboUser, StartFrom, Direction);
end;

procedure TfrmGraphProfiles.cboAllItemsChange(Sender: TObject);
var
 astring: string;
begin
 if (Sender is TORListBox) then
   btnClear.Enabled := btnSave.Enabled or ((Sender as TORListBox).Items.Count > 0)
 else if (Sender is TORComboBox) then
   btnClear.Enabled := btnSave.Enabled or ((Sender as TORComboBox).Items.Count > 0);
 if lstItemsSelection.Visible then
 begin
   btnAddAll.Enabled := lstItemsSelection.Items.Count > 0;
   btnAdd.Enabled := lstItemsSelection.ItemIndex > -1;
   if btnAdd.Enabled then
     astring := lstItemsSelection.Items[lstItemsSelection.ItemIndex];
 end
 else
 begin
   btnAddAll.Enabled := cboAllItems.Items.Count > 0;
   btnAdd.Enabled := cboAllItems.ItemIndex > -1;
 end;
end;

procedure TfrmGraphProfiles.cboAllItemsClick(Sender: TObject);
begin
  if Sender is TButton then
  begin
    if lstItemsSelection.Visible then
    begin
      if Sender = btnAddAll then
        lstItemsSelection.ItemIndex := 0;
      Sender := lstItemsSelection;
    end
    else
    begin
      if Sender = btnAddAll then
        cboAllItems.ItemIndex := 0;
      Sender := cboAllItems;
    end;
  end;
  if (Sender is TORComboBox) then
    ComboBoxSetup(Sender)
  else if (Sender is TORListBox) then
    ListBoxSetup(Sender)
  else exit;
  lstItemsDisplayedChange(self);
  CheckToClear;
end;

procedure TfrmGraphProfiles.cboAllItemsNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  filetype: string;
  sl: TStrings;
begin
  if lstSources.ItemIndex = -1 then
    exit;
  filetype := Piece(lstSources.Items[lstSources.ItemIndex], '^', 1);
  sl := TSTringList.Create;
  try
    rpcLookupItems(sl, filetype, StartFrom, Direction);
    cboAllItems.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmGraphProfiles.lstItemsDisplayedChange(Sender: TObject);
begin
  btnSave.Enabled := lstItemsDisplayed.Items.Count > 0;
  btnSavePublic.Enabled := btnSave.Enabled and FPublicEditor;
  btnRemoveAll.Enabled := btnSave.Enabled;
  btnAdd.Enabled := (cboAllItems.Visible and (cboAllItems.ItemIndex > -1)) or
    (lstItemsSelection.Visible and (lstItemsSelection.ItemIndex > -1));
  btnRemoveOne.Enabled := btnSave.Enabled and
    (lstItemsDisplayed.ItemIndex > -1);
  btnClear.Enabled := btnSave.Enabled or (lstItemsSelection.Items.Count > 0);
  if btnSave.Enabled and pnlApply.Visible then
    btnClose.Caption := 'Close and Display'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmGraphProfiles.lstItemsDisplayedDblClick(Sender: TObject);
var
  line: string;
begin
  if lstItemsDisplayed.ItemIndex < 0 then exit;
  line := lstItemsDisplayed.Items[lstItemsDisplayed.ItemIndex];
  lstItemsDisplayed.Items.Delete(lstItemsDisplayed.ItemIndex);
  QualifierDelete(line);
  lstItemsDisplayedChange(self);
end;

procedure TfrmGraphProfiles.btnRemoveOneClick(Sender: TObject);
begin
  lstItemsDisplayedDblClick(self);
  CheckToClear;
end;

procedure TfrmGraphProfiles.btnRemoveAllClick(Sender: TObject);
begin
  lstItemsDisplayed.Clear;
  lstItemsDisplayedChange(self);
  CheckToClear;
end;

procedure TfrmGraphProfiles.btnDefinitionsClick(Sender: TObject);
var
  firstpublic, firstpersonal, firstlabs: boolean;
  i, j: integer;
  aLine, aProfile, filetype, aString, front, back, piece2: string;
  aList, templist: TStringList;
begin
  front := Piece(LLS_FRONT, '^', 2);
  back := Piece(LLS_BACK, '^', 1);
  templist := TStringList.Create;
  aList := TStringList.Create;
  lstScratch.Clear;
  lstScratch.Sorted := false;
  firstpublic := true;
  firstpersonal := true;
  firstlabs := true;
  for i := 0 to lstSources.Items.Count - 1 do
  begin
    aLine :=  lstSources.Items[i];
    filetype := Piece(aLine, '^', 1);
    aProfile := Piece(aLine, '^', 2);
    if (filetype = VIEW_PERSONAL)
    or (filetype = VIEW_PUBLIC)
    or (filetype = VIEW_LABS) then
    begin
      if (filetype = VIEW_PUBLIC) and firstpublic then
      begin
        templist.Add(' ');
        templist.Add(front + copy('Public Views' + back, 0, 60));
        firstpublic := false;
      end
      else
      if (filetype = VIEW_PERSONAL) and firstpersonal then
      begin
        templist.Add(' ');
        templist.Add(front + copy('Personal Views' + back, 0, 60));
        firstpersonal := false;
      end
      else
      if (filetype = VIEW_LABS) and firstlabs then
      begin
        templist.Add(' ');
        templist.Add(front + copy('Lab Groups' + back, 0, 60));
        firstlabs := false;
      end;
      AssignProfile(aList, aLine, User.DUZ, true);
      templist.Add(aProfile);
      for j := 0 to aList.Count - 1 do
      begin
        aLine := aList[j];
        piece2 := Piece(aLine, '^', 2);
        if strtointdef(copy(piece2, 0, 1), -1) > 0 then
        begin
          aString := Piece(aLine, '^', 3);
          if copy(aString, 0, 1) = '_' then
            aString := copy(aString, 2, length(aString));
          templist.Add('   ' + aString);
        end
        else
        begin

        end;
      end;
    end;
  end;
  if cboUser.ItemIndex > -1 then
  begin
    firstpersonal := true;
    firstlabs := true;
    templist.Add('');
    templist.Add('');
    templist.Add('Views and Lab Groups for ' + cboUser.Text);
    for i := 0 to lstOtherSources.Items.Count - 1 do
    begin
      aLine :=  lstOtherSources.Items[i];
      filetype := Piece(aLine, '^', 1);
      aProfile := Piece(aLine, '^', 2);
      if (filetype = VIEW_PERSONAL)
      or (filetype = VIEW_LABS) then
      begin
        if (filetype = VIEW_PERSONAL) and firstpersonal then
        begin
          templist.Add(' ');
          templist.Add(front + copy('Views' + back, 0, 60));
          firstpersonal := false;
        end
        else
        if (filetype = VIEW_LABS) and firstlabs then
        begin
          templist.Add(' ');
          templist.Add(front + copy('Lab Groups' + back, 0, 60));
          firstlabs := false;
        end;
        AssignProfile(aList, aLine, cboUser.ItemID, true);
        templist.Add(aProfile);
        for j := 0 to aList.Count - 1 do
        begin
          aLine := aList[j];
          piece2 := Piece(aLine, '^', 2);
          if strtointdef(copy(piece2, 0, 1), -1) > 0 then
          begin
            aString := Piece(aLine, '^', 3);
            if copy(aString, 0, 1) = '_' then
              aString := copy(aString, 2, length(aString));
            templist.Add('   ' + aString);
          end;
        end;
      end;
    end;
  end;
  templist.Insert(0, 'Definitions of Views and Lab Groups');
  templist.Insert(1, '');
  templist.Insert(2,'Your Personal Views, Public Views, and Lab Groups');
  ReportBox(templist, 'Views and Lab Groups', true);
  templist.Free;
  aList.Free;
end;

procedure TfrmGraphProfiles.btnClearClick(Sender: TObject);
begin
  lstItemsDisplayed.Items.Clear;
  lstItemsSelection.Items.Clear;
  cboAllItems.Items.Clear;
  cboAllItems.Text :='';
  lstItemsDisplayedChange(self);
  cboAllItemsChange(self);
  lstSources.ItemIndex := -1;
  lstOtherSources.ItemIndex := -1;
end;

procedure TfrmGraphProfiles.btnDeleteClick(Sender: TObject);
var
  publicview: boolean;
  info, profilename, profname, proftype: string;
begin
  if lstSources.ItemIndex < 0 then
  begin
    ShowMsg('You must select a valid View for deletion.');
    exit;
  end;
  publicview := false;
  profilename := '';
  info := lstSources.Items[lstSources.ItemIndex];
  proftype := Piece(info, '^', 1);
  profname := Piece(info, '^', 2);
  if proftype = VIEW_PERSONAL then
    profilename := profname
  else if (proftype = VIEW_PUBLIC) and FPublicEditor then
  begin
    profilename := profname;
    publicview := true;
  end
  else
  begin
    ShowMsg('You must select a valid View for deletion.');
    exit;
  end;
  if publicview then
  begin
    if MessageDlg('This is Public and may be used by others.'
      + #13 + 'Delete ' + profilename + '?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      rpcDeleteGraphProfile(UpperCase(profilename), '1');
      btnClose.Tag := 1;
      MessageDlg('The public view, ' + profilename + ' has been deleted.',
      mtInformation, [mbOk], 0);
    end
    else exit;
  end
  else
  begin
    if MessageDlg('Delete ' + profilename + '?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      rpcDeleteGraphProfile(UpperCase(profilename), '0');
      btnClose.Tag := 1;
      MessageDlg('Your personal view, ' + profilename + ' has been deleted.',
      mtInformation, [mbOk], 0);
    end
    else exit;
  end;
  btnClearClick(self);
  lstItemsDisplayed.Items.Clear;
  lstItemsSelection.Items.Clear;
  cboAllItems.Items.Clear;
  cboAllItems.Text :='';
  GraphDataOnUser;
  FormShow(self);
  lstItemsDisplayedChange(self);
  btnDelete.Enabled := false;
  btnRename.Enabled := false;
  if lstSources.Count > 0 then
    lstSources.ItemIndex := 0;
end;

procedure TfrmGraphProfiles.btnRenameClick(Sender: TObject);
var
  profentered, publicview: boolean;
  i, j: integer;
  astring, info, infotitle, newprofilename, profile, profileitem, profilename, profiletype, profname, proftype: string;
  aList: TStrings;
begin
  if lstSources.ItemIndex < 0 then
  begin
    ShowMsg('You must select a valid View to rename.');
    exit;
  end;
  publicview := false;
  profilename := '';
  info := lstSources.Items[lstSources.ItemIndex];
  proftype := Piece(info, '^', 1);
  profname := Piece(info, '^', 2);
  if proftype = VIEW_PERSONAL then
    profilename := profname
  else if (proftype = VIEW_PUBLIC) and FPublicEditor then
  begin
    profilename := profname;
    publicview := true;
  end
  else
  begin
    ShowMsg('You must select a valid View to rename.');
  end;
  btnRemoveAllClick(self);
  lstSourcesDblClick(self);
  if publicview then
  begin
    infotitle := 'Rename this Public View';
    info := 'This is Public and may be used by others.'
      + #13 + 'Enter a new name for ' + profilename + '.'
  end
  else
  begin
    infotitle := 'Rename your Personal View';
    info := 'Enter a new name for ' + profilename + '.'
  end;
  profentered := GetProfileName(infotitle, info, newprofilename);
  if not profentered then exit;
  info := '';
  if not ProfileExists(newprofilename, VIEW_PUBLIC) and publicview then
    info := 'The Public View, ' + profilename + ', will be changed to '
      + newprofilename + #13 + 'Is this OK?'
  else if not ProfileExists(newprofilename, VIEW_PERSONAL) then
    info := 'Your Personal View, ' + profilename + ', will be changed to '
      + newprofilename + #13 + 'Is this OK?';
  if length(info) > 0 then
    if MessageDlg(info, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
  aList := TStringList.Create;
  profile := '';
  aList.Clear;
  j := 1;
  with lstItemsDisplayed do
  for i := 0 to Items.Count - 1 do
  begin
    astring := Items[i];
    profiletype := Piece(astring, '^', 1);
    if profiletype = '8925' then
      profileitem := UpperCase(Piece(astring, '^', 3))
    else
      profileitem := Piece(astring, '^', 2);
    profile := profile + profiletype + '~' + profileitem + '~|';
    j := j + 1;
    if (j mod 10) = 0 then
      if length(profile) > 0 then
      begin
        aList.Add(UpperCase(profile));
        profile := '';
      end;
  end;
  if length(profile) > 0 then
  begin
    aList.Add(UpperCase(profile));
    profile := '';
  end;
  if publicview then
  begin
    proftype := VIEW_PUBLIC;
    rpcDeleteGraphProfile(UpperCase(profilename), '1');
    rpcSetGraphProfile(newprofilename, '1', aList);
    btnClose.Tag := 1;
  end
  else
  begin
    proftype := VIEW_PERSONAL;
    rpcDeleteGraphProfile(UpperCase(profilename), '0');
    rpcSetGraphProfile(newprofilename, '0', aList);
    btnClose.Tag := 1;
  end;
  aList.Free;
  IDProfile(newprofilename, proftype);
end;

procedure TfrmGraphProfiles.btnSaveClick(Sender: TObject);
var
  profentered, puplicedit: boolean;
  i, j: integer;
  astring, info, infotitle, profile, profileitem, profilename, profiletype, profname, proftype: string;
  aList: TStrings;
begin
  puplicedit := Sender = btnSavePublic;
  if lstItemsDisplayed.Items.Count < 1 then exit;
  profilename := '';
  if lstSources.ItemIndex > -1 then
  begin
    info := lstSources.Items[lstSources.ItemIndex];
    if pos(LLS_FRONT, info) < 1 then
    begin
      proftype := Piece(info, '^', 1);
      profname := Piece(info, '^', 2);
      profilename := profname;
    end;
  end;
  if puplicedit then
  begin
    infotitle := 'Save this Public View';
    info := 'Save this Public View by entering a name for it.'
      + #13 + 'If you are editing a View, enter the View''s name to overwrite it.';
  end
  else
  begin
    infotitle := 'Save your Personal View';
    info := 'Save your Personal View by entering a name for it.'
      + #13 + 'If you are editing a View, enter the View''s name to overwrite it.';
  end;
  profentered := GetProfileName(infotitle, info, profilename);
  if not profentered then exit;
  info := '';
  if ProfileExists(profilename, VIEW_PUBLIC) and FPublicEditor and puplicedit then
    info := 'The Public View, ' + profilename + ', will be overwritten.'
      + #13 + 'Is this OK?'
  else if ProfileExists(profilename, VIEW_PERSONAL) and (not puplicedit) then
    info := 'Your Personal View, ' + profilename + ', will be overwritten.'
      + #13 + 'Is this OK?';
  if length(info) > 0 then
    if MessageDlg(info, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
  aList := TStringList.Create;
  profile := '';
  aList.Clear;
  j := 1;
  with lstItemsDisplayed do
  for i := 0 to Items.Count - 1 do
  begin
    astring := Items[i];
    profiletype := Piece(astring, '^', 1);
    if profiletype = '8925' then
      profileitem := UpperCase(Piece(astring, '^', 3))
    else
      profileitem := Piece(astring, '^', 2);
    profile := profile + profiletype + '~' + profileitem + '~|';
    j := j + 1;
    if (j mod 10) = 0 then
      if length(profile) > 0 then
      begin
        aList.Add(UpperCase(profile));
        profile := '';
      end;
  end;
  if length(profile) > 0 then
  begin
    aList.Add(UpperCase(profile));
    profile := '';
  end;
  if puplicedit then
  begin
    proftype := VIEW_PUBLIC;
    rpcSetGraphProfile(profilename, '1', aList);
    btnClose.Tag := 1;
  end
  else
  begin
    proftype := VIEW_PERSONAL;
    rpcSetGraphProfile(profilename, '0', aList);
    btnClose.Tag := 1;
  end;
  aList.Free;
  IDProfile(profilename, proftype);
end;

procedure TfrmGraphProfiles.btnCloseClick(Sender: TObject);
begin
  if lstItemsDisplayed.Items.Count > 0 then
    btnClose.Tag := 1;
  Close;
end;

procedure TfrmGraphProfiles.btnViewsClick(Sender: TObject);
begin             // not used
  pnlOtherSources.Visible := not pnlOtherSources.Visible;
  if pnlOtherSources.Visible then
    btnViews.Caption := 'Hide other views'
  else
    btnViews.Caption := 'Show other views';
  DialogGraphOthers(1);
end;

procedure TfrmGraphProfiles.CheckPublic;
var
  typedata: string;
begin
  if lstSources.ItemIndex = -1 then
  begin
    btnDelete.Enabled := false;
    btnRename.Enabled := false;
    exit;
  end;
  typedata :=  lstSources.Items[lstSources.ItemIndex];
  btnDelete.Enabled := (Piece(typedata, '^', 1) = VIEW_PERSONAL)
                    or ((Piece(typedata, '^', 1) = VIEW_PUBLIC) and FPublicEditor);
  btnRename.Enabled := btnDelete.Enabled;
end;

procedure TfrmGraphProfiles.ListBoxSetup(Sender: TObject);
var
  profileselected: boolean;
  i: integer;
  selection, first, profileitem: string;
begin
  with (Sender as TORListBox) do
  begin
    if ItemIndex < 0 then exit;
    selection := Items[ItemIndex];
    if length(Piece(selection, '_', 2)) > 0 then
      selection := Piece(selection, '_', 1) + ' ' + Piece(selection, '_', 2);
    first := Piece(selection, '^', 1);
    if first = '' then exit;     // line
    profileselected := strtointdef(Piece(selection, '^', 2), 0) < 0;
    if profileselected then
    begin
      for i := 2 to Items.Count - 1 do
      begin
        profileitem := Items[i];
        if length(Piece(profileitem, '_', 2)) > 0 then
          profileitem := Piece(profileitem, '_', 1) + ' ' + Piece(profileitem, '_', 2);   //*****???? ^
        AddToList(profileitem, lstItemsDisplayed);
      end;
    end
    else
      AddToList(selection, lstItemsDisplayed);
    if ItemIndex = 0 then Clear;        //profile or type <any>
    ItemIndex := -1;
  end;
end;

procedure TfrmGraphProfiles.ComboBoxSetup(Sender: TObject);
var
  profileselected: boolean;
  i: integer;
  selection, first, profileitem, subtype: string;
begin
  with (Sender as TORComboBox) do
  begin
    if ItemIndex < 0 then exit;
    selection := Items[ItemIndex];
    subtype := Piece(Items[0], '^', 3);
    subtype := Piece(subtype, ':', 2);
    subtype := copy(subtype, 2, length(subtype));
    subtype := Piece(subtype, ' ', 1);
    if UpperCase(copy(selection, 1, 5)) = '63AP;' then
        selection := copy(selection, 1, 4) + '^A;' + copy(selection, 6, 1) + ';'
        + Piece(selection, '^', 2) + '^' + subtype + ': ' + Piece(selection, '^', 3)
    else if UpperCase(copy(selection, 1, 5)) = '63MI;' then
        selection := copy(selection, 1, 4) + '^M;' + copy(selection, 6, 1) + ';'
        + Piece(selection, '^', 2) + '^' + subtype + ': ' + Piece(selection, '^', 3);
    if length(Piece(selection, '_', 2)) > 0 then
      selection := Piece(selection, '_', 1) + ' ' + Piece(selection, '_', 2);
    first := Piece(selection, '^', 1);
    if first = '' then exit;     // line
    profileselected := strtointdef(Piece(selection, '^', 2), 0) < 0;
    if profileselected then
    begin
      for i := 2 to Items.Count - 1 do
      begin
        profileitem := Items[i];
        if length(Piece(profileitem, '_', 2)) > 0 then
          profileitem := Piece(profileitem, '_', 1) + ' ' + Piece(profileitem, '_', 2);   //*****???? ^
        AddToList(profileitem, lstItemsDisplayed);
      end;
    end
    else
      AddToList(selection, lstItemsDisplayed);
    if ItemIndex = 0 then Clear;        //profile or type <any>
    ItemIndex := -1;
  end;
end;

procedure TfrmGraphProfiles.Report(aListBox: TORListBox);
var
  profileselected: boolean;
  i: integer;
  selection, first, profileitem, subtype: string;
begin
  with aListBox do
  begin
    if ItemIndex < 0 then exit;
    selection := Items[ItemIndex];
    subtype := Piece(Items[0], '^', 3);
    subtype := Piece(subtype, ':', 2);
    subtype := copy(subtype, 2, length(subtype));
    subtype := Piece(subtype, ' ', 1);
    if UpperCase(copy(selection, 1, 5)) = '63AP;' then
        selection := copy(selection, 1, 4) + '^A;' + copy(selection, 6, 1) + ';'
        + Piece(selection, '^', 2) + '^' + subtype + ': ' + Piece(selection, '^', 3)
    else if UpperCase(copy(selection, 1, 5)) = '63MI;' then
        selection := copy(selection, 1, 4) + '^M;' + copy(selection, 6, 1) + ';'
        + Piece(selection, '^', 2) + '^' + subtype + ': ' + Piece(selection, '^', 3);
    if length(Piece(selection, '_', 2)) > 0 then
      selection := Piece(selection, '_', 1) + ' ' + Piece(selection, '_', 2);
    first := Piece(selection, '^', 1);
    if first = '' then exit;     // line
    profileselected := strtointdef(Piece(selection, '^', 2), 0) < 0;
    if profileselected then
    begin
      for i := 2 to Items.Count - 1 do
      begin
        profileitem := Items[i];
        if length(Piece(profileitem, '_', 2)) > 0 then
          profileitem := Piece(profileitem, '_', 1) + ' ' + Piece(profileitem, '_', 2);   //*****???? ^
        AddToList(profileitem, lstItemsDisplayed);
      end;
    end
    else
      AddToList(selection, lstItemsDisplayed);
    if ItemIndex = 0 then Clear;        //profile or type <any>
    ItemIndex := -1;
  end;
end;

procedure TfrmGraphProfiles.CheckToClear;
begin
  if (cboAllItems.Visible and (cboAllItems.Items.Count = 0))
  or (lstItemsSelection.Visible and (lstItemsSelection.Items.Count = 0)) then
  begin
    lstSources.ItemIndex := -1;
    lstOtherSources.ItemIndex := -1;
    btnAdd.Enabled := false;
    btnAddAll.Enabled := false;
  end;
end;

procedure TfrmGraphProfiles.QualifierDelete(line: string);
var
  i: integer;
  filenum: string;
begin
  if Piece(line, '^', 1) <> '0' then exit;
  filenum := Piece(line, '^', 2);
  if strtointdef(filenum, 0) < 0 then exit;
  if (filenum = '52') or (filenum = '55') or (filenum = '55NVAE')
  or (filenum = '55NVA') or (filenum = '53.79') then
  with lstItemsDisplayed do
  for i := 0 to Items.Count - 1 do
  if (Piece(Items[i], '^', 2) = '50.605') and (Piece(Items[i], '^', 1) = '0') then
  begin
    Items.Delete(i);
    break;
  end;
end;

procedure TfrmGraphProfiles.AllItemsBefore(var typedata: string);
var
  i: integer;
begin
  with cboAllItems.Items do
  begin
    Clear;
    cboAllItems.InitLongList('');
    typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
    Insert(0, typedata);
    Insert(1, '^' + LLS_LINE);
    if Piece(typedata, '^', 2) = '63AP' then
    begin
      for i := 0 to lstSources.Items.Count - 1 do
      if copy(lstSources.Items[i], 1, 5) = '63AP;' then
      begin
        typedata := lstSources.Items[i];
        typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
        Add(typedata);
      end;
    end
    else if Piece(typedata, '^', 2) ='63MI' then
    begin
      for i := 0 to lstSources.Items.Count - 1 do
      if copy(lstSources.Items[i], 1, 5) = '63MI;' then
      begin
        typedata := lstSources.Items[i];
        typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
        Add(typedata);
      end;
    end;
  end;
end;

procedure TfrmGraphProfiles.AllItemsAfter(var filetype, typedata: string);
var
  i: integer;
  itemdata: string;
begin
  with lstItemsSelection.Items do
  begin
    Clear;
    lstItemsSelection.Sorted := true;
    //typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
    typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 3);
    Insert(0, typedata);
    Insert(1, '^' + LLS_LINE);
    if filetype = '63AP' then                         // finish subitems ***********
    begin
      lstItemsSelection.Sorted := false;
      for i := 0 to lstSources.Items.Count - 1 do
      if copy(lstSources.Items[i], 1, 5) = '63AP;' then
      begin
        typedata := lstSources.Items[i];
        typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
        Add(typedata);
      end;
    end
    else if filetype ='63MI' then
    begin
      lstItemsSelection.Sorted := false;
      for i := 0 to lstSources.Items.Count - 1 do
      if copy(lstSources.Items[i], 1, 5) = '63MI;' then
      begin
        typedata := lstSources.Items[i];
        typedata := '0^' + Piece(typedata, '^', 1) + '^ ' + Piece(typedata, '^', 2) + ' <any>';
        Add(typedata);
      end;
    end
    else if filetype = '50.605' then
    for i := 0 to lstDrugClass.Items.Count - 1 do
    begin
      itemdata := lstDrugClass.Items[i];
      if filetype = Piece(itemdata, '^', 1) then
        Add(itemdata);
    end
    else if copy(filetype, 1, 5) = '63AP;' then
    begin
      filetype := copy(filetype, 1, 4) + '^A;' + copy(filetype, 6, 1) + ';';
      for i := 0 to lstTests.Items.Count - 1 do
      begin
        itemdata := lstTests.Items[i];
        if filetype = UpperCase(copy(itemdata, 1, 9)) then
          Add(itemdata);
      end;
    end
    else if copy(filetype, 1, 5) = '63MI;' then
    begin
      filetype := copy(filetype, 1, 4) + '^M;' + copy(filetype, 6, 1) + ';';
      for i := 0 to lstTests.Items.Count - 1 do
      begin
        itemdata := lstTests.Items[i];
        if filetype = UpperCase(copy(itemdata, 1, 9)) then
          Add(itemdata);
      end;
    end
    else if filetype <> '405' then
    for i := 0 to lstTests.Items.Count - 1 do
    begin
      itemdata := lstTests.Items[i];
      if filetype = UpperCase(Piece(itemdata, '^', 1)) then
        Add(itemdata);
    end;
    cboAllItemsChange(lstItemsSelection);
  end;
end;

procedure TfrmGraphProfiles.AddToList(aItem: string; aListBox: TORListBox);
var
  addtolist: boolean;
  checkfile, checkitem: string;
begin
  aItem := UpperCase(Pieces(aItem, '^', 1, 2)) + '^' + Piece(aItem, '^', 3);
  checkfile := Piece(aItem, '^', 1);
  checkitem := Piece(aItem, '^', 2);
  if checkfile = '0' then
  begin
    checkfile := checkitem;       // if drug class any - 52,0;55,0
    checkitem := '0';           // if drug class item - go thru meds
  end;
  ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
  if addtolist then aListBox.Items.Add(aItem);
  if (checkfile = '50.605') and (checkitem = '0') then
  begin
    checkfile := '52';
    aItem := '0^52^ Medication,Outpatitent <any>';
    ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
    if addtolist then aListBox.Items.Add(aItem);
    checkfile := '55';
    aItem := '0^55^ Medication,Inpatitent <any>';
    ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
    if addtolist then aListBox.Items.Add(aItem);
    checkfile := '53.79';
    aItem := '0^53.79^ Medication,BCMA <any>';
    ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
    if addtolist then aListBox.Items.Add(aItem);
    {checkfile := '55NVAE';               // nonvameds as events is not used
    aItem := '0^55NVAE^ Medication,Non-VA-Event <any>';
    ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
    if addtolist then aListBox.Items.Add(aItem);}
    checkfile := '55NVA';
    aItem := '0^55NVA^ Medication,Non-VA <any>';
    ArrangeList(checkfile, checkitem, aItem, aListBox, addtolist);
    if addtolist then aListBox.Items.Add(aItem);
  end;
end;

procedure TfrmGraphProfiles.ArrangeList(aCheckFile, aCheckItem, aItem: string;
  aListBox: TORListBox; var addtolist: boolean);
var
  i: integer;
  listfile, listitem: string;
begin
  addtolist := true;
  with aListBox do
  for i := Items.Count - 1 downto 0 do
  begin
    listfile := Piece(Items[i], '^', 1);
    listitem := Piece(Items[i], '^', 2);
    if listfile = '0' then
    begin
      listfile := listitem;
      listitem := '0';
    end;
    if (aCheckItem = listitem) and (aCheckFile = listfile) then
    begin
      addtolist := false;
      break;
    end
    else
    if (listitem = '0') and (aCheckFile = listfile) then
    begin
      addtolist := false;
      break;
    end
    else
    if listitem = '0' then
    begin
      if aCheckFile = Piece(listfile, ';', 1) then
        if Piece(aCheckItem, ';', 2) = Piece(listfile, ';', 2) then
        begin
          addtolist := false;
          break;
        end;
    end
    else
    if (aCheckItem = '0') and (aCheckFile = listfile) then
      Items.Delete(i);
  end;
end;

// CQ #15852 - Changed UserNum to Int64 for a long DUZ - JCS
procedure TfrmGraphProfiles.AssignProfile(aList: TStrings; aProfile: string; UserNum: int64; allitems: boolean);
var
  i, k: integer;
  preprofile, typedata, typepart, typeone, typetwo, testname, teststring: string;
  itempart, itempart1, itempart2, itemnums, itemname, itemtest: string;
begin
  preprofile := aProfile;
  aList.Clear;
  if Piece(aProfile, '^', 1) = VIEW_TEMPORARY then
  begin
    typedata := Piece(aProfile, '^', 3);
    for i := 1 to BIG_NUMBER do
    begin
      typepart := Piece(typedata, '|', i);
      if typepart = '' then
        break;
      testname := Piece(aProfile, '^', i + 3);
      typeone := Piece(typepart, '~', 1);
      typetwo := Piece(typepart, '~', 2);
      aList.Add(typeone + '^' + typetwo + '^' + testname);
    end;
    typedata := '0^' + Piece(aProfile, '^', 1) + '^ ' + Piece(aProfile, '^', 2);
    aList.Insert(0, typedata);
    aList.Insert(1, '^' + LLS_LINE);
    exit;
  end;
  if Piece(aProfile, '^', 1) = VIEW_CURRENT then   // current selection on list
  begin
    typedata := '0^-1^ ' + Piece(aProfile, '^', 2);
    aProfile := Piece(aProfile, '^', 3);
    aList.Add(typedata);
    aList.Add('^' + LLS_LINE);
    for i := 1 to BIG_NUMBER do
    begin
      itempart := Piece(aProfile, '|', i);
      if itempart = '' then exit;
      itempart1 := Piece(itempart, '~', 1);
      itempart2 := Piece(itempart, '~', 2);
      itemnums := itempart1 + '^' + itempart2;
      itemname := '';
      for k := 0 to GtslItems.Count - 1 do
      begin
        itemtest := UpperCase(Pieces(GtslItems[k], '^', 1, 2));
        if Piece(itemtest, '^', 1) = '63' then
          itemtest := Piece(itemtest, '.', 1);
        if itemtest = itemnums then
        begin
          itemname := Piece(GtslItems[k], '^', 4);
          itemname := Piece(itemname, '(', 1);   // removes specimen parens on name
          itemname := Piece(itemname, '[', 1);   // removes refrange bracket on name
          itemname := trim(itemname);
          itemnums := itemnums + '^' + itemname;
          aList.Add(itemnums);
          break;
        end;
      end;
    end;
    typedata := '0^' + Piece(aProfile, '^', 1) + '^ ' + Piece(aProfile, '^', 2);
    aList.Insert(0, typedata);
    aList.Insert(1, '^' + LLS_LINE);
    exit;
  end;
  if radSourceAll.Checked or allitems then
  begin
    AssignProfilePre(aList, aProfile, UserNum);
    for i := 0 to aList.Count - 1 do
    begin
      teststring := aList[i];
      if Piece(teststring, '^', 1) = '0' then
        aList[i] := '0^' + Piece(teststring, '^', 2) + '^_' + Piece(teststring, '^', 3);
    end;
    typedata := '0^' + Piece(aProfile, '^', 1) + '^ ' + Piece(aProfile, '^', 2);
    aList.Insert(0, typedata);
    aList.Insert(1, '^' + LLS_LINE);
    exit;
  end;
  if Piece(aProfile, '^', 1) = VIEW_LABS then
  begin
    lstScratch.Items.Clear;
    GetATestGroup(aList, strtointdef(Piece(Piece(aProfile, '^', 2), ')', 1), -1), UserNum);
    for i  := 0 to aList.Count - 1 do
      aList[i] := '63^' + aList[i];
  end
  else
  if Piece(aProfile, '^', 1) = VIEW_PUBLIC then
  begin
    GetGraphProfiles(UpperCase(Piece(aProfile, '^', 2)), '1', 0, 0, lstScratch.Items);
    typedata := '0^-1^ ' + Piece(aProfile, '^', 2);
  end
  else
  begin
    GetGraphProfiles(UpperCase(Piece(aProfile, '^', 2)), '0', 0, UserNum, lstScratch.Items);
    typedata := '0^' + Piece(aProfile, '^', 1) + '^ ' + Piece(aProfile, '^', 2);
  end;
  if Piece(aProfile, '^', 1) = VIEW_LABS then
    exit;
  for i := 0 to lstScratch.Items.Count - 1 do
    aProfile := aProfile + lstScratch.Items[i];
  aProfile := Piece(aProfile, '^', 3);
  AssignProfilePost(aList, aProfile, typedata);
end;

// CQ #15852 - Changed UserNum to Int64 for a long DUZ - JCS
procedure TfrmGraphProfiles.AssignProfilePre(aList: TStrings; var aProfile: string; UserNum: int64);
var
  i: integer;
begin
  if Piece(aProfile, '^', 1) = VIEW_LABS then
  begin
    GetATestGroup(aList, strtointdef(Piece(Piece(aProfile, '^', 2), ')', 1), -1), UserNum);
    for i  := 0 to aList.Count - 1 do
      aList[i] := '63^' + aList[i];
  end
  else
  if Piece(aProfile, '^', 1) = VIEW_PUBLIC then
    GetGraphProfiles(UpperCase(Piece(aProfile, '^', 2)), '1', 1, 0, aList)
  else
  if Piece(aProfile, '^', 1) = VIEW_PERSONAL then
    GetGraphProfiles(UpperCase(Piece(aProfile, '^', 2)), '0', 1, UserNum, aList)
  else
    GetGraphProfiles(UpperCase(Piece(aProfile, '^', 2)), '0', 1, UserNum, aList);
end;

procedure TfrmGraphProfiles.AssignProfilePost(aList: TStrings; var aProfile, typedata: string);
var
  stop: boolean;
  i, j, k: integer;
  itempart, itempart1, itempart2, itemnums, itemname, itemtest: string;
begin
  aList.Clear;
  aList.Add(typedata);
  aList.Add('^' + LLS_LINE);
  for i := 1 to BIG_NUMBER do
  begin
    itempart := Piece(aProfile, '|', i);
    if itempart = '' then exit;
    itempart1 := Piece(itempart, '~', 1);
    itempart2 := Piece(itempart, '~', 2);
    itemnums := itempart1 + '^' + itempart2;
    itemname := '';
    if itempart1 = '0' then
    begin
      for j := 0 to lstSources.Items.Count - 1 do
        if itempart2 = Piece(lstSources.Items[j], '^', 1) then
        begin
          itemname := Piece(lstSources.Items[j], '^', 2);
          break;
        end;
      typedata := '0^' + itempart2 + '^_' + itemname + ' <any>';
      aList.Add(typedata);
    end
    else
    if (itempart1 <> '0') then    //DRUG CLASS NOT INCLUDED
    begin
      stop := false;
      for k := 0 to lstTests.Items.Count - 1 do
      begin
        itemtest := UpperCase(Pieces(lstTests.Items[k], '^', 1, 2));
        if itemtest = itemnums then
        begin
          itemname := Piece(lstTests.Items[k], '^', 3);
          itemnums := itemnums + '^' + itemname;
          aList.Add(itemnums);
          stop := true;
          break;
        end;
      end;
      if not stop then
      for k := 0 to lstDrugClass.Items.Count - 1 do
      begin
        itemtest := UpperCase(Pieces(lstDrugClass.Items[k], '^', 1, 2));
        if itemtest = itemnums then
        begin
          itemname := Piece(lstDrugClass.Items[k], '^', 3);
          itemnums := itemnums + '^' + itemname;
          aList.Add(itemnums);
          break;
        end;
      end;
    end;
  end;
end;

procedure TfrmGraphProfiles.FillSource(aList: TORListBox);
var
  i: integer;
// CQ #15852 - Changed UserNum to Int64 for a long DUZ - JCS
  UserNum: Int64;
  dfntype, firstline, listline: string;
begin
  with aList do
  begin
    Clear;
    firstline := '';
    Sorted := true;
    OnClick := OnChange;     // turn off onchange event when loading
    OnChange := nil;
    if aList = lstSources then                  // user
    begin
      rpcGetTypes(Items, '0', true);   //*** use GtslAllTypes ???
      for i := 0 to Items.Count - 1 do
      begin
        listline := Items[i];
        dfntype := UpperCase(Piece(listline, '^', 1));
        SetPiece(listline, '^', 1, dfntype);
        Items[i] := listline;
      end;
      Sorted := false;
      Items.Insert(0, LLS_FRONT + copy('Types' + LLS_BACK, 0, 30) + '^0');
      UserNum := User.DUZ;
      if GtslViews.Count > 0 then
      begin
        Items.Add(LLS_FRONT + copy('Temporary Views' + LLS_BACK, 0, 30) + '^0');
        for i := 0 to GtslViews.Count - 1 do
        begin
          listline := GtslViews[i];
          if Piece(listline, '^', 1) = VIEW_CURRENT then
            Items.Add(listline)
          else
            Items.Add(VIEW_TEMPORARY + '^' + listline + '^');
        end;
      end;
    end
    else                                         // other user
    begin
      UserNum := cboUser.ItemIEN;
      Sorted := false;
    end;
    GetGraphProfiles('1', '0', 0, UserNum, lstScratch.Items);
    lstScratch.Sorted := true;
    if lstScratch.Items.Count > 0 then
    begin
      Items.Add(LLS_FRONT + copy('Personal Views' + LLS_BACK, 0, 30) + '^0');
      for i := 0 to lstScratch.Items.Count - 1 do
        Items.Add(VIEW_PERSONAL + '^' + lstScratch.Items[i] + '^');
    end;
    GetGraphProfiles('1', '1', 0, 0, lstScratch.Items);
    lstScratch.Sorted := true;
    if (lstScratch.Items.Count > 0) and (aList = lstSources) then
    begin
      Items.Add(LLS_FRONT + copy('Public Views' + LLS_BACK, 0, 30) + '^0');
      for i := 0 to lstScratch.Items.Count - 1 do
        Items.Add(VIEW_PUBLIC + '^' + lstScratch.Items[i] + '^');
    end;
    rpcTestGroups(lstScratch.Items,UserNum);
    lstScratch.Sorted := true;
    if lstScratch.Items.Count > 0 then
    begin
      Items.Add(LLS_FRONT + copy('Lab Groups' + LLS_BACK, 0, 30) + '^0');
      for i := 0 to lstScratch.Items.Count - 1 do
        Items.Add(VIEW_LABS + '^' + Piece(lstScratch.Items[i], '^', 2) + '^' + Piece(lstScratch.Items[i], '^', 1));
    end;
    OnChange := OnClick;
    OnClick := nil;
  end;
end;

function TfrmGraphProfiles.ProfileExists(aName, aType: string): boolean;
var
  i: integer;
  info, sourcetype, profilename: string;
begin
  Result := false;
  aName := UpperCase(aName);
  for i := lstSources.Items.Count - 1 downto 0 do
  begin
    info := lstSources.Items[i];
    profilename := Piece(info, '^', 2);
    sourcetype := Piece(info, '^', 1);
    if (UpperCase(profilename) = aName) and (aType = sourcetype) then
    begin
      Result := true;
      break;
    end;
  end;
end;

procedure TfrmGraphProfiles.AssignHints;
var
  i: integer;
begin                       // text defined in uGraphs
  for i := 0 to ControlCount - 1 do with Controls[i] do
    Controls[i].ShowHint := true;
  RadSourcePat.Hint := HINT_PAT_SOURCE;
  RadSourceAll.Hint := HINT_ALL_SOURCE;
  lblSelectionInfo.Hint := HINT_SELECTION_INFO;
  lbl508SelectionInfo.Hint := HINT_SELECTION_INFO;
  lblSource.Hint := HINT_SOURCE;
  lstSources.Hint := HINT_SOURCE;
  pnlSources.Hint := HINT_SOURCE;
  pnlAllSources.Hint := HINT_SOURCE;
  splViews.Hint := HINT_SOURCE;
  lbl508SelectOthers.Hint := HINT_OTHER_SOURCE;
  lblOtherViews.Hint := HINT_OTHER_SOURCE;
  lstOtherSources.Hint := HINT_OTHER_SOURCE;
  pnlOtherSources.Hint := HINT_OTHER_SOURCE;
  pnlOtherSourcesBottom.Hint := HINT_OTHER_SOURCE;
  pnlOtherViews.Hint := HINT_OTHER_SOURCE;
  lblOtherViews.Hint := HINT_OTHER_SOURCE;
  lblOtherPersons.Hint := HINT_OTHERS;
  cboUser.Hint := HINT_OTHERS;
  pnlOtherSourcesUser.Hint := HINT_OTHERS;
  btnDefinitions.Hint := HINT_BTN_DEFINITION;
  lblSelection.Hint := HINT_SELECTION;
  lstItemsSelection.Hint := HINT_SELECTION;
  cboAllItems.Hint := HINT_SELECTION;
  lblDisplay.Hint := HINT_DISPLAY;
  lstItemsDisplayed.Hint := HINT_DISPLAY;
  btnAddAll.Hint := HINT_BTN_ADDALL;
  btnAdd.Hint := HINT_BTN_ADD1;
  btnRemoveOne.Hint := HINT_BTN_REMOVE1;
  btnRemoveAll.Hint := HINT_BTN_REMOVEALL;
  btnClear.Hint := HINT_BTN_CLEAR;
  btnDelete.Hint := HINT_BTN_DELETE;
  btnRename.Hint := HINT_BTN_RENAME;
  btnSave.Hint := HINT_BTN_SAVE;
  btnSavePublic.Hint := HINT_BTN_SAVE_PUB;
  pnlApply.Hint := HINT_APPLY;
  btnClose.Hint := HINT_BTN_CLOSE;
end;

procedure TfrmGraphProfiles.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin            // clicking the ? button will have controls show hints
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // ignore biHelp border icon
    AssignHints;
    ShowMsg('Help is now available.' + #13 +
                'By pausing over a list or control, hints will appear.');
  end
  else
    inherited;
end;

function TfrmGraphProfiles.GetProfileName(infotitle, info: string; var newprofilename: string): boolean;
begin
  Result := InputQuery(infotitle, info, newprofilename);
  if not Result then exit;
  if newprofilename = '' then
  begin
    Result := false;
    exit;
  end;
  if (length(newprofilename) < 3)
  or (length(newprofilename) > 30)
  or (Pos('^', newprofilename) > 0)
  or (Pos('|', newprofilename) > 0)
  or (Pos('~', newprofilename) > 0) then
  begin
    ShowMsg('Not accepted - names of views must be 3-30 characters.');
    Result := false;
    exit;
  end;
end;

procedure TfrmGraphProfiles.IDProfile(var profilename, proftype: string);
var
  i, match: integer;
  info, aName, aType: string;
begin
  if length(profilename) > 0 then
    lblSave.Hint := profilename;
  btnClearClick(self);
  lstScratch.Items.Clear;
  lstSources.Items.Clear;
  GraphDataOnUser;
  FormShow(btnSave);
  match := -1;
  profilename := UpperCase(profilename);
  for i := lstSources.Items.Count - 1 downto 0 do
  begin
    info := lstSources.Items[i];
    aType := Piece(info, '^', 1);
    aName := Piece(info, '^', 2);
    if (UpperCase(aName) = profilename) and (aType = proftype) then
    begin
      match := i;
      break;
    end;
  end;
  if match = -1 then exit;
  lstSources.ItemIndex := match;
  lstSources.Tag := BIG_NUMBER;
  lstSourcesChange(lstSources);
end;

end.

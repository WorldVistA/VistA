unit fLabTestGroups;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, ORCtrls, StdCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmLabTestGroups = class(TfrmBase508Form)
    pnlLabTestGroups: TORAutoPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cmdClear: TButton;
    cmdRemove: TButton;
    lstList: TORListBox;
    cboTests: TORComboBox;
    cmdUp: TSpeedButton;
    pnlUpButton: TKeyClickPanel;
    cmdDown: TSpeedButton;
    pnlDownButton: TKeyClickPanel;
    bvlTestGroups: TBevel;
    cboUsers: TORComboBox;
    lstTestGroups: TORListBox;
    cmdReplace: TButton;
    lblTests: TLabel;
    lblList: TLabel;
    cboSpecimen: TORComboBox;
    lblSpecimen: TLabel;
    lblTestGroups: TLabel;
    lblUsers: TLabel;
    lblOrder: TLabel;
    cmdDelete: TButton;
    cmdAdd: TButton;
    cmdAddTest: TButton;
    lblDefine: TVA508StaticText;
    lblTestGroup: TLabel;
    lbl508TstGrp: TVA508StaticText;
    lbl508Order: TVA508StaticText;
    procedure FormCreate(Sender: TObject);
    procedure cboTestsNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdClearClick(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure cmdUpClick(Sender: TObject);
    procedure cmdDownClick(Sender: TObject);
    procedure lstListClick(Sender: TObject);
    procedure cboUsersNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboSpecimenNeedData(Sender: TObject; const StartFrom: string;
      Direction, InsertAt: Integer);
    procedure cboUsersClick(Sender: TObject);
    procedure cmdReplaceClick(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure cmdDeleteClick(Sender: TObject);
    procedure cboTestsChange(Sender: TObject);
    procedure cboTestsEnter(Sender: TObject);
    procedure cboTestsExit(Sender: TObject);
    procedure cmdAddTestClick(Sender: TObject);
    procedure pnlUpButtonEnter(Sender: TObject);
    procedure pnlUpButtonExit(Sender: TObject);
    procedure pnlDownButtonEnter(Sender: TObject);
    procedure pnlDownButtonExit(Sender: TObject);
    procedure pnlUpButtonResize(Sender: TObject);
    procedure pnlDownButtonResize(Sender: TObject);
    procedure lstTestGroupsChange(Sender: TObject);
  private
    { Private declarations }
    procedure AddTests(tests: TStrings);
    procedure TestGroupEnable;
  public
    { Public declarations }
  end;

procedure SelectTestGroups(FontSize: Integer);

implementation

uses fLabs, ORFn, rLabs, uCore, VAUtils, VA508AccessibilityRouter;

{$R *.DFM}

procedure SelectTestGroups(FontSize: Integer);
var
  frmLabTestGroups: TfrmLabTestGroups;
  W, H: integer;
begin
  frmLabTestGroups := TfrmLabTestGroups.Create(Application);
  try
    with frmLabTestGroups do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth := W; pnlLabTestGroups.Width := W;
      ClientHeight := H; pnlLabTestGroups.Height := H;
      with lblTestGroup do begin
        AutoSize := False;
        Height := lstList.Height div 3;
        Width := cmdAddTest.Width * 4 div 3;
        AutoSize := True;
      end;
      with lblOrder do begin
        AutoSize := False;
        Height := lstList.Height div 3;
        Width := cmdAddTest.Width div 2 + 10;
        AutoSize := True;
      end;
      FastAssign(frmLabs.lstTests.Items, lstList.Items);
      if lstList.Items.Count > 0 then lstList.ItemIndex := 0;
      lstListClick(frmLabTestGroups);
      ShowModal;
    end;
  finally
    frmLabTestGroups.Release;
  end;
end;

procedure TfrmLabTestGroups.FormCreate(Sender: TObject);
var
  i: integer;
  blood, urine, serum, plasma: string;
begin
  cboTests.LockDrawing;
  try
    cboTests.InitLongList('');
    cboSpecimen.LockDrawing;
    try
      cboSpecimen.InitLongList('');
      SpecimenDefaults(blood, urine, serum, plasma);
      cboSpecimen.Items.Add('0^Any');
      cboSpecimen.Items.Add(serum + '^Serum');
      cboSpecimen.Items.Add(blood + '^Blood');
      cboSpecimen.Items.Add(plasma + '^Plasma');
      cboSpecimen.Items.Add(urine + '^Urine');
      cboSpecimen.Items.Add(LLS_LINE);
      cboSpecimen.Items.Add(LLS_SPACE);
      cboSpecimen.ItemIndex := 0;
    finally
      cboSpecimen.UnlockDrawing;
    end;
    cboUsers.InitLongList(User.Name);
    for i := 0 to cboUsers.Items.Count - 1 do
      if StrToInt64Def(Piece(cboUsers.Items[i], '^', 1), 0) = User.DUZ then
      begin
        cboUsers.ItemIndex := i;
        break;
      end;
    if cboUsers.ItemIndex > -1 then cboUsersClick(self);
  finally
    cboTests.UnlockDrawing;
  end;
  cmdUp.Enabled := false;
  pnlUpButton.TabStop := false;
  cmdDown.Enabled := false;
  pnlDownButton.TabStop := false;
  lstList.Clear;
  if ScreenReaderSystemActive then
  begin
    lbl508TstGrp.Enabled := True;
    lbl508TstGrp.Visible := True;
    lbl508TstGrp.TabStop := True;
    lbl508Order.Enabled := True;
    lbl508Order.Visible := True;
    lbl508Order.TabStop := True;
  end;
end;

{
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    set

  finally
    sl.Free;
  end;
}
procedure TfrmLabTestGroups.cboTestsNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
//begin
//  cboTests.ForDataUse(ChemTest(StartFrom, Direction));
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    setChemTest(sl,StartFrom, Direction);
    cboTests.ForDataUse(sl);

  finally
    sl.Free;
  end;
end;

procedure TfrmLabTestGroups.cmdOKClick(Sender: TObject);
begin
  if lstList.Items.Count = 0 then
    ShowMsg('No tests were selected.')
  else
  begin
    FastAssign(lstList.Items, frmLabs.lstTests.Items);
    frmLabs.lblSpecimen.Caption := cboSpecimen.Items[cboSpecimen.ItemIndex];
    Close;
  end;
end;

procedure TfrmLabTestGroups.cmdClearClick(Sender: TObject);
//var
  //i: integer;
begin
  lstList.Clear;
  lstListClick(self);
  lstTestGroups.ClearSelection;
  //for i := 0 to lstTestGroups.Count - 1 do
  //  lstTestGroups.Selected[i] := false;
end;

procedure TfrmLabTestGroups.cmdRemoveClick(Sender: TObject);
var
  newindex: integer;
begin
  if lstList.Items.Count > 0 then
  begin
    if lstList.ItemIndex = (lstList.Items.Count -1 ) then
      newindex := lstList.ItemIndex - 1
    else
      newindex := lstList.ItemIndex;
    lstList.Items.Delete(lstList.ItemIndex);
    if lstList.Items.Count > 0 then lstList.ItemIndex := newindex;
  end;
  lstListClick(self);
  lstTestGroups.ClearSelection;
end;

procedure TfrmLabTestGroups.cmdUpClick(Sender: TObject);
var
  newindex: integer;
  templine: string;
begin
  if cmdUp.Enabled then begin
    newindex := lstList.ItemIndex - 1;
    templine := lstList.Items[lstList.ItemIndex - 1];
    lstList.Items[lstList.ItemIndex - 1] := lstList.Items[lstList.ItemIndex];
    lstList.Items[lstList.ItemIndex] := templine;
    lstList.ItemIndex := newindex;
    lstListClick(self);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak('Test Moved Up');
  end;
end;

procedure TfrmLabTestGroups.cmdDownClick(Sender: TObject);
var
  newindex: integer;
  templine: string;
begin
  if cmdDown.Enabled then begin
    newindex := lstList.ItemIndex + 1;
    templine := lstList.Items[lstList.ItemIndex + 1];
    lstList.Items[lstList.ItemIndex + 1] := lstList.Items[lstList.ItemIndex];
    lstList.Items[lstList.ItemIndex] := templine;
    lstList.ItemIndex := newindex;
    lstListClick(self);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak('Test Moved Down');
  end;
end;

procedure TfrmLabTestGroups.lstListClick(Sender: TObject);
begin
  cmdUp.Enabled := not (lstList.ItemIndex = 0);
  pnlUpButton.TabStop := not (lstList.ItemIndex = 0);
  cmdDown.Enabled := not (lstList.ItemIndex = lstList.Items.Count - 1);
  pnlDownButton.TabStop := not (lstList.ItemIndex = lstList.Items.Count - 1);
  if lstList.Items.Count = 0 then
  begin
    cmdUp.Enabled := false;
    pnlUpButton.TabStop := false;
    cmdDown.Enabled := false;
    pnlDownButton.TabStop := false;
    cmdClear.Enabled := false;
    cmdRemove.Enabled := false;
  end
  else
  begin
    cmdClear.Enabled := true;
    cmdRemove.Enabled := true;
  end;
  TestGroupEnable;
end;

procedure TfrmLabTestGroups.cboUsersNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
//begin
//  cboUsers.ForDataUse(Users(StartFrom, Direction));
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    setUsers(sl,StartFrom, Direction);
    cboUsers.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmLabTestGroups.cboSpecimenNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
//begin
//  cboSpecimen.ForDataUse(Specimens(StartFrom, Direction));
var
  sl: TSTrings;
begin
  sl := TStringList.Create;
  try
    setSpecimens(sl,StartFrom, Direction);
     cboSpecimen.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmLabTestGroups.cboUsersClick(Sender: TObject);
begin
  setTestGroups(lstTestGroups.Items,cboUsers.ItemIEN);
  TestGroupEnable;
end;

procedure TfrmLabTestGroups.AddTests(tests: TStrings);
var
  i, j, textindex: integer;
  ok: boolean;
begin
  textindex := lstList.Items.Count;
  for i := 0 to tests.Count - 1 do
  begin
    ok := true;
    for j := 0 to lstList.Items.Count - 1 do
      if lstList.Items[j] = tests[i] then
      begin
        ok := false;
        textindex := j;
      end;
    if ok then
    begin
      lstList.Items.Add(tests[i]);
      textindex := lstList.Items.Count - 1;
    end;
  end;
  lstList.ItemIndex := textindex;
  lstListClick(self);
end;

procedure TfrmLabTestGroups.lstTestGroupsChange(Sender: TObject);
var
  sl: TStrings;
begin
  if lstTestGroups.ItemIEN > 0 then
  begin
    sl := TStringList.Create;
    try
      setATestGroup(sl,lstTestGroups.ItemIEN, cboUsers.ItemIEN);
      AddTests(sl);
    finally
      sl.Free;
    end;
  end;
end;

procedure TfrmLabTestGroups.TestGroupEnable;
begin
  cmdAdd.Enabled := (lstList.Items.Count > 0) and (lstList.Items.Count < 8);
  cmdDelete.Enabled := (cboUsers.ItemIEN = User.DUZ) and (lstTestGroups.ItemIndex > -1);
  cmdReplace.Enabled := cmdAdd.Enabled and cmdDelete.Enabled;
end;

procedure TfrmLabTestGroups.cmdReplaceClick(Sender: TObject);
var
  text: string;
  i: integer;
begin
  text := 'Do you want to REPLACE your test group -' + #13 + '  ';
  text := text + lstTestGroups.DisplayText[lstTestGroups.ItemIndex] + #13;
  text := text + ' with:' + #13 + '  ';
  for i := 0 to lstList.Items.Count -1 do
    text := text + lstList.DisplayText[i] + #13 + '  ';
  if InfoBox(text,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    UTGReplace(lstList.Items, lstTestGroups.ItemIEN); //Show508Message('Replace'); //Replace
    if ScreenReaderSystemActive then
      GetScreenReader.Speak('test group replaced');
  end;
  cboUsersClick(self);
  lstTestGroups.SetFocus;
end;

procedure TfrmLabTestGroups.cmdAddClick(Sender: TObject);
var
  text: string;
  i: integer;
begin
  text := 'Do you wish to create a NEW test group with these tests: ' + #13 + '  ';
  for i := 0 to lstList.Items.Count -1 do
    text := text + lstList.DisplayText[i] + #13 + '  ';
  if InfoBox(text,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    UTGAdd(lstList.Items);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak('New test group created');
    cboUsers.InitLongList(User.Name);
    for i := 0 to cboUsers.Items.Count - 1 do
      if StrToInt64Def(Piece(cboUsers.Items[i], '^', 1), 0) = User.DUZ then
      begin
        cboUsers.ItemIndex := i;
        break;
      end;
  end;
  if cboUsers.ItemIndex > -1 then cboUsersClick(self);
  lstTestGroups.SetFocus;
end;

procedure TfrmLabTestGroups.cmdDeleteClick(Sender: TObject);
var
  text: string;
  i: integer;
begin
  text := 'Do you wish to DELETE your test group:' + #13 + '  ';
  text := text + lstTestGroups.DisplayText[lstTestGroups.ItemIndex] + #13 + '  ';
  if InfoBox(text,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    UTGDelete(lstTestGroups.ItemIEN);
    if ScreenReaderSystemActive then
      GetScreenReader.Speak('Test group deleted');
    cboUsers.Text := '';
    lstTestGroups.Clear;
    cboUsers.InitLongList(User.Name);
    for i := 0 to cboUsers.Items.Count - 1 do
      if StrToInt64Def(Piece(cboUsers.Items[i], '^', 1), 0) = User.DUZ then
      begin
        cboUsers.ItemIndex := i;
        break;
      end;
  end;
  if cboUsers.ItemIndex > -1 then cboUsersClick(self);
  lstTestGroups.SetFocus;
end;

procedure TfrmLabTestGroups.cboTestsChange(Sender: TObject);
begin
  cmdAddTest.Enabled := cboTests.ItemIndex > -1;
end;

procedure TfrmLabTestGroups.cboTestsEnter(Sender: TObject);
begin
  cmdAddTest.Default := true;
end;

procedure TfrmLabTestGroups.cboTestsExit(Sender: TObject);
begin
  cmdAddTest.Default := false;
end;

procedure TfrmLabTestGroups.cmdAddTestClick(Sender: TObject);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    setATest(sl, cboTests.ItemIEN);
    AddTests(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmLabTestGroups.pnlUpButtonEnter(Sender: TObject);
begin
  pnlUpButton.BevelOuter := bvLowered;
end;

procedure TfrmLabTestGroups.pnlUpButtonExit(Sender: TObject);
begin
  pnlUpButton.BevelOuter := bvNone;
end;

procedure TfrmLabTestGroups.pnlDownButtonEnter(Sender: TObject);
begin
  pnlDownButton.BevelOuter := bvLowered;
end;

procedure TfrmLabTestGroups.pnlDownButtonExit(Sender: TObject);
begin
  pnlDownButton.BevelOuter := bvNone;
end;

procedure TfrmLabTestGroups.pnlUpButtonResize(Sender: TObject);
begin
  cmdUp.Width := pnlUpButton.Width;
end;

procedure TfrmLabTestGroups.pnlDownButtonResize(Sender: TObject);
begin
  cmdDown.Width := pnlDownButton.Width;
end;

end.

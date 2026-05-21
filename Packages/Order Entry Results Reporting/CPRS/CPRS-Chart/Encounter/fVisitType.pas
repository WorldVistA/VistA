unit fVisitType;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  fPCEBase,
  StdCtrls,
  CheckLst,
  ORCtrls,
  ExtCtrls,
  Buttons,
  uPCE,
  rPCE,
  ORFn,
  rCore,
  ComCtrls,
  mVisitRelated,
  VA508AccessibilityManager,
  ORCheckComboBox,
  U508Button,
  U508ORCheckComboBox,
  fBase508Frame;

type
  TfrmVisitType = class(TfrmPCEBase)
    lstVTypeSection: TORListBox;
    fraVisitRelated: TfraVisitRelated;
    pnlSC: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    lblProvider: TLabel;
    cboPtProvider: U508ORCheckComboBox.TORCheckComboBox;
    lbProviders: TORListBox;
    lblCurrentProv: TLabel;
    lblVTypeSection: TLabel;
    pnlBottomMiddle: TPanel;
    btnPrimary: U508Button.TButton;
    btnDelete: U508Button.TButton;
    btnAdd: U508Button.TButton;
    lblMod: TLabel;
    lbMods: TORListBox;
    lblVType: TLabel;
    lbxVisits: TORListBox;
    grdMain: TGridPanel;
    grdBottom: TGridPanel;
    procedure lstVTypeSectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPrimaryClick(Sender: TObject);
    procedure cboPtProviderDblClick(Sender: TObject);
    procedure cboPtProviderChange(Sender: TObject);
    procedure cboPtProviderNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure lbProvidersChange(Sender: TObject);
    procedure lbProvidersDblClick(Sender: TObject);
    procedure lbxVisitsClickCheck(Sender: TObject; Index: Integer);
    procedure lbModsClickCheck(Sender: TObject; Index: Integer);
    procedure lbxVisitsClick(Sender: TObject);
    procedure memSCDisplayEnter(Sender: TObject);
    procedure cboPtProviderKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cboPtProviderMainCheckboxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    FSplitterMove: boolean;
    procedure ShowModifiers;
    procedure CheckModifiers;
    procedure Loaded; override;
  private
    FChecking: boolean;
    FCheckingMods: boolean;
    FLastCPTCodes: string;
    FLastMods: string;
    procedure UpdateProviderButtons;
  public
    procedure MatchVType;
    procedure RefreshProviders;
  end;

var
  USCchecked: Boolean = False;
  PriProv: Int64;

const
  TX_NO_PROVIDER_CAP = 'Invalid Provider';

implementation

{$R *.DFM}

uses
  fEncounterFrame,
  uCore,
  uConst,
  VA508AccessibilityRouter,
  uORLists,
  uSimilarNames,
  VAUtils,
  uMisc;

const
  FN_NEW_PERSON = 200;

procedure TfrmVisitType.Loaded;
begin
  AutoSizeDisabled := true;
  inherited;
end;

procedure TfrmVisitType.MatchVType;
var
  i: Integer;
  Found: Boolean;
begin
  with uVisitType do
  begin
    if Code = '' then Exit;
    Found := False;
    with lstVTypeSection do for i := 0 to Items.Count - 1 do
      if Piece(Items[i], U, 2) = Category then
      begin
        ItemIndex := i;
        lstVTypeSectionClick(Self);
        Found := True;
        break;
      end;
    if Found then for i := 0 to lbxVisits.Items.Count - 1 do
      if Pieces(lbxVisits.Items[i], U, 1, 2) = Code + U + Narrative then
      begin
        lbxVisits.ItemIndex := i;
        FChecking := TRUE;
        try
          lbxVisits.Checked[i] := True;
          lbxVisitsClickCheck(Self, i);
        finally
          FChecking := FALSE;
        end;
      end;
  end;
end;

procedure TfrmVisitType.lstVTypeSectionClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  ListVisitTypeCodes(lbxVisits.Items, lstVTypeSection.ItemIEN);
  with uVisitType do for i := 0 to lbxVisits.Items.Count - 1 do
    begin
      if ((uVisitType <> nil) and (Pieces(lbxVisits.Items[i], U, 1, 2) = Code + U + Narrative)) then
        begin
          FChecking := TRUE;
          try
            lbxVisits.Checked[i] := True;
            lbxVisits.ItemIndex := i;
          finally
            FChecking := FALSE;
          end;
        end;
    end;
  lbxVisitsClick(Self);
end;

procedure TfrmVisitType.RefreshProviders;
var
  i: integer;
  ProvData: TPCEProviderRec;
  ProvEntry: string;
begin
  lbProviders.Clear;
  for i := 0 to uProviders.count-1 do
  begin
    ProvData := uProviders[i];
    ProvEntry := IntToStr(ProvData.IEN) + U + ProvData.Name;
    if(ProvData.Primary) then
      ProvEntry := ProvEntry + ' (Primary)';
    lbProviders.Items.Add(ProvEntry);
  end;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.FormCreate(Sender: TObject);
var
  AIEN: Int64;
begin
  inherited;
  FTabName := CT_VisitNm;
  FSectionTabCount := 2;
  FormResize(Self);
  AIEN := uProviders.PendingIEN(TRUE);
  if(AIEN = 0) then
  begin
    AIEN := uProviders.PendingIEN(FALSE);
    if(AIEN = 0) then
    begin
      cboPtProvider.InitLongList(User.Name);
      AIEN := User.DUZ;
    end
    else
      cboPtProvider.InitLongList(uProviders.PendingName(FALSE));
    cboPtProvider.SelectByIEN(AIEN);
  end
  else
  begin
    cboPtProvider.InitLongList(uProviders.PendingName(TRUE));
    cboPtProvider.SelectByIEN(AIEN);
  end;
  RefreshProviders;
  FLastMods := uEncPCEData.VisitType.Modifiers;
  fraVisitRelated.TabStop := False;
  TSimilarNames.RegORComboBox(cboPTProvider);
  cboPtProvider.MainCheckBoxVisible := IncludeNonVAProviders(cboPtProvider);
end;

procedure TfrmVisitType.FormResize(Sender: TObject);
const
  LBCheckWidthSpace = 18;
var
  V, I: Integer;
  S: string;
begin
  inherited;
  FSectionTabs[0] := -(lbxVisits.Width - LBCheckWidthSpace - MainFontWidth -
    ScrollBarWidth);

  V := (lbMods.Width - LBCheckWidthSpace - (4 * MainFontWidth) -
    ScrollBarWidth);
  S := '';
  for I := 1 to 20 do
  begin
    if S <> '' then S := S + ',';
    S := S + IntToStr(V);
    if (V < 0) then Dec(V, 32)
    else Inc(V, 32);
  end;
  lbMods.TabPositions := S;
  lbxVisits.TabPositions := S;
end;

procedure TfrmVisitType.FormShow(Sender: TObject);
begin
  inherited;
  RefreshProviders;
end;

procedure TfrmVisitType.UpdateProviderButtons;
var
  ok: boolean;
begin
  ok := (lbProviders.ItemIndex >= 0);
  btnDelete.Enabled := ok;
  btnPrimary.Enabled := ok;
  btnAdd.Enabled := (cboPtProvider.ItemIEN <> 0);
end;

procedure TfrmVisitType.btnAddClick(Sender: TObject);
var
  aErrMsg: String;
  aSimRtn: Boolean;
begin
  inherited;
  aSimRtn := CheckForSimilarName(cboPTProvider, aErrMsg, sPr, lbProviders.Items);
  if aSimRtn then
  begin
    uProviders.AddProvider(IntToStr(cboPTProvider.ItemIEN), cboPTProvider.Text, FALSE);
    RefreshProviders;
    lbProviders.SelectByIEN(cboPTProvider.ItemIEN);
  end else begin
    ShowMsgOn(Trim(aErrMsg) <> '' , aErrMsg, 'Similiar Name Selection');
  end;
end;

procedure TfrmVisitType.btnDeleteClick(Sender: TObject);
var
  idx: integer;
begin
  inherited;
  If lbProviders.ItemIndex = -1 then exit;
  idx := uProviders.IndexOfProvider(lbProviders.ItemID);
  if(idx >= 0) then
    uProviders.Delete(idx);
  RefreshProviders;
end;

procedure TfrmVisitType.btnPrimaryClick(Sender: TObject);
var
  idx: integer;
  AIEN: Int64;
begin
  inherited;
  if lbProviders.ItemIndex = -1 then exit;
  AIEN := lbProviders.ItemIEN;
  idx := uProviders.IndexOfProvider(IntToStr(AIEN));
  if(idx >= 0) then
    uProviders.PrimaryIdx := idx;
  RefreshProviders;
  lbProviders.SelectByIEN(AIEN);
  btnPrimary.SetFocus;
end;

procedure TfrmVisitType.cboPtProviderDblClick(Sender: TObject);
begin
  inherited;
  btnAddClick(Sender);
end;

procedure TfrmVisitType.cboPtProviderKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    btnAddClick(nil);
end;

procedure TfrmVisitType.cboPtProviderMainCheckboxClick(Sender: TObject);
begin
  inherited;
  var ALastData := cboPtProvider.SelectedDataString;
  cboPtProvider.ReInitLongList;
  if ALastData <> cboPtProvider.SelectedDataString then
    cboPtProviderChange(cboPtProvider);
end;

procedure TfrmVisitType.cboPtProviderChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.cboPtProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TStrings;
begin
  inherited;
  if (uEncPCEData.VisitCategory = 'E') then
    setPersonList(cboPtProvider, StartFrom, Direction)
  else
  begin
    sl := TStringList.Create;
    try
      setSubSetOfUsersWithClass(cboPtProvider, sl, StartFrom, Direction,
        FloatToStr(uEncPCEData.PersonClassDate));
      cboPtProvider.ForDataUse(sl);
    finally
      FreeAndNil(sl);
    end;
  end;
end;

procedure TfrmVisitType.lbProvidersChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.lbProvidersDblClick(Sender: TObject);
begin
  inherited;
  btnDeleteClick(Sender);
end;

procedure TfrmVisitType.lbxVisitsClickCheck(Sender: TObject;
  Index: Integer);
var
  i: Integer;
  x, CurCategory: string;
begin
  inherited;
  if FChecking or FClosing then exit;
  for i := 0 to lbxVisits.Items.Count - 1 do
    if i <> lbxVisits.ItemIndex then
    begin
      FChecking := TRUE;
      try
        uVisitType.Modifiers := '';
        lbxVisits.Checked[i] := False;
      finally
        FChecking := FALSE;
      end;
    end;
  if lbxVisits.Checked[lbxVisits.ItemIndex] then with uVisitType do
  begin
    with lstVTypeSection do CurCategory := Piece(Items[ItemIndex], U, 2);
    x := Pieces(lbxVisits.Items[lbxVisits.ItemIndex], U, 1, 2);
    x := 'CPT' + U + Piece(x, U, 1) + U + CurCategory + U + Piece(x, U, 2) + U + '1' + U
        + IntToStr(uProviders.PrimaryIEN);
    uVisitType.SetFromString(x);
  end
  else
  begin
    uVisitType.Clear;
  end;
end;

procedure TfrmVisitType.ShowModifiers;
const
  ModTxt = 'Modifiers';
  ForTxt = ' for ';
  Spaces = '    ';
var
  TopIdx: integer;
  Codes, VstName, Hint, Msg: string;
begin
  Codes := '';
  VstName := '';
  Hint := '';
  if(Codes = '') and (lbxVisits.ItemIndex >= 0) then
  begin
    Codes := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,1) + U;
    VstName := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,2);
    Hint := VstName;
  end;
  msg := ModTxt;
  if(VstName <> '') then
    msg := msg + ForTxt;
  lblMod.Caption := msg + VstName;
  lbMods.Caption := lblMod.Caption;
  if(pos(CRLF,Hint)>0) then
    Hint := ':' + CRLF + Spaces + Hint;
  lblMod.Hint := msg + Hint;

  if(FLastCPTCodes = Codes) then
    TopIdx := lbMods.TopIndex
  else
  begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  ListCPTModifiers(lbMods.Items, Codes, ''); // Needed);
  lbMods.TopIndex := TopIdx;
  CheckModifiers;
end;

procedure TfrmVisitType.CheckModifiers;
var
  i, idx, cnt, mcnt: integer;
  Code, Mods: string;
  state: TCheckBoxState;
begin
  if lbMods.Items.Count < 1 then exit;
  FCheckingMods := TRUE;
  try
    cnt := 0;
    Mods := ';';
    if uVisitType.Modifiers <> '' then
      begin
        inc(cnt);
        Mods := Mods + uVisitType.Modifiers;
      end;
    if(cnt = 0) and (lbxVisits.ItemIndex >= 0) then
    begin
      Mods := ';' + UpdateVisitTypeModifierList(lbxVisits.Items, lbxVisits.ItemIndex);
      lbxVisits.Checked[lbxVisits.ItemIndex] := True;
      cnt := 1;
    end;
    for i := 0 to lbMods.Items.Count-1 do
    begin
      state := cbUnchecked;
      if(cnt > 0) then
      begin
        Code := ';' + piece(lbMods.Items[i], U, 1) + ';';
        mcnt := 0;
        repeat
          idx := pos(Code, Mods);
          if(idx > 0) then
          begin
            inc(mcnt);
            delete(Mods, idx, length(Code) - 1);
          end;
        until (idx = 0);
        if mcnt >= cnt then
          State := cbChecked
        else
        if(mcnt > 0) then
          State := cbGrayed;
      end;
      lbMods.CheckedState[i] := state;
    end;
  finally
    FCheckingMods := FALSE;
  end;
end;

procedure TfrmVisitType.lbModsClickCheck(Sender: TObject; Index: Integer);
var
  idx: integer;
  ModIEN: string;
  Add: boolean;
begin
  if FCheckingMods or (Index < 0) then exit;
  Add := (lbMods.Checked[Index]);
  ModIEN := piece(lbMods.Items[Index],U,1) + ';';
  idx := pos(';' + ModIEN, ';' + uVisitType.Modifiers);
  if(idx > 0) then
  begin
    if not Add then
    begin
      delete(uVisitType.Modifiers, idx, length(ModIEN));
    end;
  end
  else
  begin
    if Add then
    begin
      uVisitType.Modifiers := uVisitType.Modifiers + ModIEN;
    end;
  end;
end;

procedure TfrmVisitType.lbxVisitsClick(Sender: TObject);
begin
  inherited;
  ShowModifiers;
end;

procedure TfrmVisitType.memSCDisplayEnter(Sender: TObject);
begin
  inherited;
  if (ScreenReaderActive) then
    GetScreenReader.Speak('Service Connection and Rated Disabilities');
  memSCDisplay.SelStart := 0;
end;

initialization
  SpecifyFormIsNotADialog(TfrmVisitType);
end.

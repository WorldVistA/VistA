unit fVisitType;
{------------------------------------------------------------------------------
Update History

    2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
-------------------------------------------------------------------------------}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORCtrls, ExtCtrls, Buttons, uPCE, rPCE, ORFn, rCore,
  ComCtrls, mVisitRelated, VA508AccessibilityManager;

type

  TfrmVisitType = class(TfrmPCEBase)
    pnlTop: TPanel;
    splLeft: TSplitter;
    splRight: TSplitter;
    pnlLeft: TPanel;
    lstVTypeSection: TORListBox;
    pnlMiddle: TPanel;
    fraVisitRelated: TfraVisitRelated;
    pnlSC: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    pnlBottom: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnPrimary: TButton;
    pnlBottomLeft: TPanel;
    lblProvider: TLabel;
    cboPtProvider: TORComboBox;
    pnlBottomRight: TPanel;
    lbProviders: TORListBox;
    lblCurrentProv: TLabel;
    lblVTypeSection: TLabel;
    pnlModifiers: TPanel;
    lbMods: TORListBox;
    lblMod: TLabel;
    pnlSection: TPanel;
    lbxVisits: TORListBox;
    lblVType: TLabel;
    procedure lstVTypeSectionClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
    procedure FormResize(Sender: TObject);
    procedure lbxVisitsClickCheck(Sender: TObject; Index: Integer);
    procedure lbModsClickCheck(Sender: TObject; Index: Integer);
    procedure lbxVisitsClick(Sender: TObject);
    procedure memSCDisplayEnter(Sender: TObject);
    procedure cboPtProviderKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    FSplitterMove: boolean;
    procedure ShowModifiers;
    procedure CheckModifiers;
  private
    FChecking: boolean;
    FCheckingMods: boolean;
    FLastCPTCodes: string;
    FLastMods: string;
    procedure RefreshProviders;
    procedure UpdateProviderButtons;
  public
    procedure MatchVType;
  end;

var
  frmVisitType: TfrmVisitType;
  USCchecked:boolean = false;
//  PriProv: Int64;
  PriProv: Int64;

const
  LBCheckWidthSpace = 18;
  TX_NO_PROVIDER_CAP = 'Invalid Provider';

implementation

{$R *.DFM}

uses
  fEncounterFrame, uCore, uConst, VA508AccessibilityRouter, uORLists, uSimilarNames, VAUtils;

const
  FN_NEW_PERSON = 200;

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

procedure TfrmVisitType.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  //process before closing

end;

(*function ExposureAnswered: Boolean;
begin
  result := false;
  //if SC answered set result = true
end;*)


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
end;

(*procedure TfrmVisitType.SynchEncounterProvider;
// add the Encounter.Provider if this note is for the current encounter
var
  ProviderFound, PrimaryFound: Boolean;
  i: Integer;
  AProvider: TPCEProvider;
begin
  if (FloatToStrF(uEncPCEData.DateTime, ffFixed, 15, 4) =      // compensate rounding errors
      FloatToStrF(Encounter.DateTime,   ffFixed, 15, 4)) and
     (uEncPCEData.Location = Encounter.Location) and
     (Encounter.Provider > 0) then
  begin
    ProviderFound := False;
    PrimaryFound := False;
    for i := 0 to ProviderLst.Count - 1 do
    begin
      AProvider := TPCEProvider(ProviderLst.Items[i]);
      if AProvider.IEN = Encounter.Provider then ProviderFound := True;
      if AProvider.Primary = '1' then PrimaryFound := True;
    end;
    if not ProviderFound then
    begin
      AProvider := TPCEProvider.Create;
      AProvider.IEN := Encounter.Provider;
      AProvider.Name := ExternalName(Encounter.Provider, FN_NEW_PERSON);
      if not PrimaryFound then
      begin
        AProvider.Primary := '1';
        uProvider := Encounter.Provider;
      end
      else AProvider.Primary := '0';
      AProvider.Delete := False;
      ProviderLst.Add(AProvider);
    end;
  end;
end;
*)

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
    sl := TSTringList.Create;
    try
      setSubSetOfUsersWithClass(cboPtProvider, sl, StartFrom, Direction,
        FloatToStr(uEncPCEData.PersonClassDate));
      cboPtProvider.ForDataUse(sl);
    finally
      sl.Free;
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

procedure TfrmVisitType.FormResize(Sender: TObject);
var
  v, i, gap: integer;
  s: string;
  padding, size: integer;
  btnOffset: integer;

  function GetTopPanelSize: integer;
  begin
    Result := ClientHeight - btnOK.Height - pnlMiddle.Height - pnlBottom.Height - (gap * 2);
  end;

begin
  gap := MainFont.Size - 4;
  if FSplitterMove then
    FSplitterMove := FALSE
  else
  begin
//      inherited;
    FSectionTabs[0] := -(lbxVisits.width - LBCheckWidthSpace - MainFontWidth - ScrollBarWidth);
    FSectionTabs[1] := -(lbxVisits.width - (6*MainFontWidth) - ScrollBarWidth);
    if(FSectionTabs[0] <= FSectionTabs[1]) then FSectionTabs[0] := FSectionTabs[1]+2;
    lbxVisits.TabPositions := SectionString;
    v := (lbMods.width - LBCheckWidthSpace - (4*MainFontWidth) - ScrollBarWidth);
    s := '';
    for i := 1 to 20 do
    begin
      if s <> '' then s := s + ',';
      s := s + inttostr(v);
      if(v<0) then
        dec(v,32)
      else
        inc(v,32);
    end;
    lbMods.TabPositions := s;
  end;
  btnOffset := btnAdd.Width div 7;
  padding := btnAdd.Width + (btnOffset * 2);
  size := (ClientWidth - padding) div 2;
  pnlBottomLeft.Width := size;
  pnlBottomRight.Width := size;
  btnAdd.Left := size + btnOffset;
  btnDelete.Left := size + btnOffset;
  btnPrimary.Left := size + btnOffset;
  btnOK.top := ClientHeight - btnOK.Height - gap;
  btnCancel.top := btnOK.Top;
  btnCancel.Left := ClientWidth - btnCancel.Width - gap;
  btnOK.Left := btnCancel.Left - btnOK.Width - gap;
  size := GetTopPanelSize;
  if size < 60 then
  begin
    pnlBottom.Height := btnAdd.Height + btnDelete.Height + btnPrimary.Height + (gap * 4);
    btnAdd.Top := gap;
    btnDelete.Top := btnAdd.Top + btnAdd.Height + gap;
    btnPrimary.Top := btnDelete.Top + btnDelete.Height + gap;
    size := GetTopPanelSize;
  end;
  pnlTop.Height := size;
  pnlTop.Top := 0;
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
//      + IntToStr(uProvider);
    uVisitType.SetFromString(x);
  end
  else
  begin
    uVisitType.Clear;
    //with lstVTypeSection do CurCategory := Piece(Items[ItemIndex], U, 2);
  end;
end;

procedure TfrmVisitType.ShowModifiers;
const
  ModTxt = 'Modifiers';
  ForTxt = ' for ';
  Spaces = '    ';

var
  TopIdx: integer;
//  Needed,
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
//    Needed := piece(lbxVisit.Items[lbxVisit.ItemIndex],U,4); Don't show expired codes!
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
  memSCDisplay.SelStart := 0;
end;

initialization
  SpecifyFormIsNotADialog(TfrmVisitType);

//frmVisitType.CreateProviderList;

finalization
//frmVisitType.FreeProviderList;

end.

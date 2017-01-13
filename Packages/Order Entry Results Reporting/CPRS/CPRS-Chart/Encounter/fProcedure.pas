unit fProcedure;
{Warning: The tab order has been changed in the OnExit event of several controls.
 To change the tab order of lbSection, lbxSection, lbMods, and btnOther you must do it programatically.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ComCtrls, CheckLst, ORCtrls, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, fPCEBaseGrid, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmProcedures = class(TfrmPCEBaseMain)
    lblProcQty: TLabel;
    spnProcQty: TUpDown;
    txtProcQty: TCaptionEdit;
    lbMods: TORListBox;
    splRight: TSplitter;
    lblMod: TLabel;
    cboProvider: TORComboBox;
    lblProvider: TLabel;
    procedure txtProcQtyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject); override;
    procedure splRightMoved(Sender: TObject);
    procedure clbListClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure lbModsClickCheck(Sender: TObject; Index: Integer);
    procedure lbSectionClick(Sender: TObject);
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure btnOtherClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure cboProviderNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboProviderChange(Sender: TObject);
    procedure lbxSectionExit(Sender: TObject);
    procedure lbModsExit(Sender: TObject);
    procedure btnOtherExit(Sender: TObject);
    procedure lstRenameMeClick(Sender: TObject);
    procedure lstRenameMeChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstRenameMeInsert(Sender: TObject; Item: TListItem);
  private
    FCheckingCode: boolean;
    FCheckingMods: boolean;
    FLastCPTCodes: string;
    FModsReadOnly: boolean;
    FProviderChanging: boolean;
    FModsROChecked: string;
    function MissingProvider: boolean;
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure ShowModifiers;
    procedure CheckModifiers;
  public
    function OK2SaveProcedures: boolean;
    procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
  end;

var
  frmProcedures: TfrmProcedures;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, rCore, VA508AccessibilityRouter;

const
  TX_PROC_PROV = 'Each procedure requires selection of a Provider before it can be saved.';
  TC_PROC_PROV = 'Missing Procedure Provider';

procedure TfrmProcedures.txtProcQtyChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEProc(lstRenameMe.Objects[i]).Quantity := spnProcQty.Position;
    GridChanged;
  end;
end;

procedure TfrmProcedures.cboProviderChange(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if(NotUpdating) then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEProc(lstRenameMe.Objects[i]).Provider := cboProvider.ItemIEN;
    FProviderChanging := TRUE; // CQ 11707
    try
      GridChanged;
    finally
      FProviderChanging := FALSE;
    end;
  end;
end;

procedure TfrmProcedures.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_ProcNm;
  FPCEListCodesProc := ListProcedureCodes;
  cboProvider.InitLongList(uProviders.PCEProviderName);
  FPCEItemClass := TPCEProc;
  FPCECode := 'CPT';
  FSectionTabCount := 1;
  FormResize(Self);
  lbMods.HideSelection := TRUE;
end;

procedure TfrmProcedures.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumProcQty, '1');
  //x := x + U + '1';
end;

procedure TfrmProcedures.UpdateControls;
var
  ok, First: boolean;
  SameQty: boolean;
  SameProv: boolean;
  i: integer;
  Qty: integer;
  Prov: int64;
  Obj: TPCEProc;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstRenameMe.SelCount > 0);
      lblProcQty.Enabled := ok;
      txtProcQty.Enabled := ok;
      spnProcQty.Enabled := ok;
      cboProvider.Enabled := ok;
      lblProvider.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameQty := TRUE;
        SameProv := TRUE;
        Prov := 0;
        Qty := 1;
        for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCEProc(lstRenameMe.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Qty := Obj.Quantity;
              Prov := Obj.Provider;
            end
            else
            begin
              if(SameQty) then
                SameQty := (Qty = Obj.Quantity);
              if(SameProv) then
                SameProv := (Prov = Obj.Provider);
            end;
          end;
        end;
        if(SameQty) then
        begin
          spnProcQty.Position := Qty;
          txtProcQty.Text := IntToStr(Qty);
          txtProcQty.SelStart := length(txtProcQty.Text);
        end
        else
        begin
          spnProcQty.Position := 1;
          txtProcQty.Text := '';
        end;
        if not FProviderChanging then // CQ 11707
        begin
          if(SameProv) then
            cboProvider.SetExactByIEN(Prov, ExternalName(Prov, 200))
          else
            cboProvider.SetExactByIEN(uProviders.PCEProvider, uProviders.PCEProviderName);
            //cboProvider.ItemIndex := -1;     v22.8 - RV
        end;
      end
      else
      begin
        txtProcQty.Text := '';
        cboProvider.ItemIndex := -1;
      end;
//      ShowModifiers;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmProcedures.FormResize(Sender: TObject);
var
  v, i: integer;
  s: string;
  
begin
  inherited;
  FSectionTabs[0] := -(lbxSection.width - LBCheckWidthSpace - MainFontWidth - ScrollBarWidth);
  UpdateTabPos;
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

procedure TfrmProcedures.splRightMoved(Sender: TObject);
begin
  inherited;
  lblMod.Left := lbMods.Left + pnlMain.Left;
  FSplitterMove := TRUE;
  FormResize(Sender);
end;

procedure TfrmProcedures.clbListClick(Sender: TObject);
begin
  inherited;
  Sync2Section;
  UpdateControls;
  ShowModifiers;
end;

procedure TfrmProcedures.btnSelectAllClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.ShowModifiers;
const
  ModTxt = 'Modifiers';
  ForTxt = ' for ';
  Spaces = '    ';
  CommonTxt = ' Common to Multiple Procedures';

var
  i, TopIdx: integer;
//  Needed,
  Codes, ProcName, Hint, Msg: string;
  Proc: TPCEProc;

begin
  if(not NotUpdating) then exit;
  Codes := '';
  ProcName := '';
  Hint := '';
//  Needed := '';
  for i := 0 to lstRenameMe.Items.Count-1 do
  begin
    if(lstRenameMe.Items[i].Selected) then
    begin
      Proc := TPCEProc(lstRenameMe.Objects[i]);
      Codes := Codes + Proc.Code + U;
      if(ProcName = '') then
        ProcName := Proc.Narrative
      else
        ProcName := CommonTxt;
      if(Hint <> '') then
        Hint := Hint + CRLF + Spaces;
      Hint := Hint + Proc.Narrative;
//      Needed := Needed + Proc.Modifiers;
    end;
  end;
  if(Codes = '') and (lbxSection.ItemIndex >= 0) then
  begin
    Codes := piece(lbxSection.Items[lbxSection.ItemIndex],U,1) + U;
    ProcName := piece(lbxSection.Items[lbxSection.ItemIndex],U,2);
    Hint := ProcName;
//    Needed := piece(lbxSection.Items[lbxSection.ItemIndex],U,4); Don't show expired codes!
  end;
  msg := ModTxt;
  if(ProcName <> '') and (ProcName <> CommonTxt) then
    msg := msg + ForTxt;
  lblMod.Caption := msg + ProcName;
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

procedure TfrmProcedures.CheckModifiers;
var
  i, idx, cnt, mcnt: integer;
  Code, Mods: string;
  state: TCheckBoxState;

begin
  FModsReadOnly := TRUE;
  if lbMods.Items.Count < 1 then exit;
  FCheckingMods := TRUE;
  try
    cnt := 0;
    Mods := ';';
    for i := 0 to lstRenameMe.Items.Count-1 do
    begin
      if(lstRenameMe.Items[i].Selected) then
      begin
        inc(cnt);
        Mods := Mods + TPCEProc(lstRenameMe.Objects[i]).Modifiers;
        FModsReadOnly := FALSE;
      end;
    end;
    if(cnt = 0) and (lbxSection.ItemIndex >= 0) then
    begin
      Mods := ';' + UpdateModifierList(lbxSection.Items, lbxSection.ItemIndex);
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
    if FModsReadOnly then
    begin
      FModsROChecked := lbMods.CheckedString;
      lbMods.Font.Color := clInactiveCaption;
    end
    else
      lbMods.Font.Color := clWindowText;
  finally
    FCheckingMods := FALSE;
  end;
end;

procedure TfrmProcedures.lbModsClickCheck(Sender: TObject; Index: Integer);
var
  i, idx: integer;
  PCEObj: TPCEProc;
  ModIEN: string;
  DoChk, Add: boolean;

begin
  if FCheckingMods or (Index < 0) then exit;
  if FModsReadOnly then
  begin
    lbMods.CheckedString := FModsROChecked;
    exit;
  end;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      DoChk := FALSE;
      Add := (lbMods.Checked[Index]);
      ModIEN := piece(lbMods.Items[Index],U,1) + ';';
      for i := 0 to lstRenameMe.Items.Count-1 do
      begin
        if(lstRenameMe.Items[i].Selected) then
        begin
          PCEObj := TPCEProc(lstRenameMe.Objects[i]);
          idx := pos(';' + ModIEN, ';' + PCEObj.Modifiers);
          if(idx > 0) then
          begin
            if not Add then
            begin
              delete(PCEObj.Modifiers, idx, length(ModIEN));
              DoChk := TRUE;
            end;
          end
          else
          begin
            if Add then
            begin
              PCEObj.Modifiers := PCEObj.Modifiers + ModIEN;
              DoChk := TRUE;
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
    if DoChk then
      GridChanged;
  end;
end;

procedure TfrmProcedures.lbModsExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
    if btnOther.CanFocus then
      btnOther.SetFocus;
end;

procedure TfrmProcedures.lbSectionClick(Sender: TObject);
begin
  inherited;
  ShowModifiers;
end;

procedure TfrmProcedures.lbxSectionClickCheck(Sender: TObject;
  Index: Integer);
var
  i: integer;
begin
  if FCheckingCode then exit;
  FCheckingCode := TRUE;
  try
    inherited;
    Sync2Grid;
    lbxSection.Selected[Index] := True;
    if(lbxSection.ItemIndex >= 0) and (lbxSection.ItemIndex = Index) and
      (lbxSection.Checked[Index]) then
    begin
      UpdateModifierList(lbxSection.Items, Index); // CQ#16439
      lbxSection.Checked[Index] := TRUE;    
      for i := 0 to lstRenameMe.Items.Count-1 do
      begin
        if(lstRenameMe.Items[i].Selected) then
        with TPCEProc(lstRenameMe.Objects[i]) do
        begin
          if(Category = GetCat) and
            (Pieces(lbxSection.Items[Index], U, 1, 2) = Code + U + Narrative) then
          begin
            { TODO -oRich V. -cEncounters : v21/22 - Added this block to default provider for procedures.}
            if Provider = 0 then Provider := uProviders.PCEProvider;
            { uPCE.TPCEProviderList.PCEProvider function sorts this out automatically:                            }
            {   1.  Current CPRS encounter provider, if present and has active person class as of encounter date. }
            {   2.  Current user, if has active person class as of encounter date.                                }
            {   3.  Primary provider for the visit, if defined.                                                   }
            {   4.  No default.                                                                                   }
            Modifiers := Piece(lbxSection.Items[lbxSection.ItemIndex], U, 4);
            GridChanged;
            lbxSection.Selected[Index] := True; // CQ#15493
            exit;
          end;
        end;
      end;
    end;
  finally
    FCheckingCode := FALSE;
  end;
end;

procedure TfrmProcedures.lbxSectionExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lbMods.CanFocus then
      lbMods.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbSection.CanFocus then
      lbSection.SetFocus;
end;

procedure TfrmProcedures.lstRenameMeChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.lstRenameMeClick(Sender: TObject);
begin
  inherited;
    Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.lstRenameMeInsert(Sender: TObject; Item: TListItem);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.btnOtherClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.btnOtherExit(Sender: TObject);
begin
  if TabIsPressed then begin
    if lstRenameMe.CanFocus then
      lstRenameMe.SetFocus;
  end
  else if ShiftTabIsPressed then
    if lbMods.CanFocus then
      lbMods.SetFocus;    
end;

procedure TfrmProcedures.btnRemoveClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  ShowModifiers;
end;

procedure TfrmProcedures.cboProviderNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  inherited;
  if(uEncPCEData.VisitCategory = 'E') then
    cboProvider.ForDataUse(SubSetOfPersons(StartFrom, Direction))
  else
    cboProvider.ForDataUse(SubSetOfUsersWithClass(StartFrom, Direction,
                                     FloatToStr(uEncPCEData.PersonClassDate)));
end;

function TfrmProcedures.OK2SaveProcedures: boolean;
begin
  Result := TRUE;
  if MissingProvider then
  begin
    InfoBox(TX_PROC_PROV, TC_PROC_PROV, MB_OK or MB_ICONWARNING);
    Result := False;
  end;
end;

function TfrmProcedures.MissingProvider: boolean;    
var
  i: integer;
  AProc: TPCEProc;
begin
  { TODO -oRich V. -cEncounters : {v21 - Entry of a provider for each new CPT is now required}
            {Existing CPTs on the encounter will NOT require entry of a provider}
            {Monitor status of new service request #20020203.}
  Result := False;

  { Comment out the block below (and the "var" block above) }
  {  to allow but not require entry of a provider with each new CPT entered}
//------------------------------------------------
  for i := 0 to lstRenameMe.Items.Count - 1 do
  begin
    AProc := TPCEProc(lstRenameMe.Objects[i]);
    if AProc.fIsOldProcedure then continue;
    if (AProc.Provider = 0) then
    begin
      Result := True;
      lstRenameMe.ItemIndex := i;
      lstRenameMe.Items[i].Selected := true;
      exit;
    end;
  end;
//-------------------------------------------------
end;

procedure TfrmProcedures.InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
var
  i: integer;
begin
  inherited;
  for i := 0 to lstRenameMe.Items.Count - 1 do
    TPCEProc(lstRenameMe.Objects[i]).fIsOldProcedure := True;
end;

initialization
  SpecifyFormIsNotADialog(TfrmProcedures);

end.

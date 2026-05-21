unit fPCEBaseMain;
// Warning: The tab order has been changed in the OnExit event of several
//   controls. To change the tab order of lbSection, lbxSection, and btnOther
//   you must do it programatically.

// When adding a splitter and a panel to the top section, set
//  Panel.Parent = pnlSplitter
//  Panel.Align = alRight
//  Panel.Constraints.Width = 100
//  Splitter.Parent = pnlSplitter
//  Splitter.Align = alRight
//  Splitter.MinWidth = 102
//  Splitter.Width = 6
// Components aligned with margins on the panel should have their left margin
//  set to 0.
// These values play nice with each other and with the stuff on this form.

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  ORCtrls,
  fPCEBaseGrid,
  rPCE,
  uPCE,
  VA508AccessibilityManager,
  U508Button,
  U508CaptionEdit;

type
  TCopyItemsMethod = procedure(Dest: TCaptionListView) of object;
  TListSectionsProc = procedure(Dest: TStrings);

  TfrmPCEBaseMain = class(TfrmPCEBaseGrid)
    lbSection: TORListBox;
    edtComment: U508CaptionEdit.TCaptionEdit;
    lblSection: TLabel;
    lblList: TLabel;
    lblComment: TLabel;
    btnRemove: U508Button.TButton;
    btnOther: U508Button.TButton;
    btnSelectAll: U508Button.TButton;
    lbxSection: TORListBox;
    pnlMain: TPanel;
    pnlGridRight: TPanel;
    grdMain: TGridPanel;
    pnlComments: TPanel;
    procedure lbSectionClick(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure edtCommentExit(Sender: TObject);
    procedure edtCommentChange(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure FormResize(Sender: TObject); virtual;
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure splLeftMoved(Sender: TObject);
    procedure edtCommentKeyPress(Sender: TObject; var Key: Char);
    procedure lbSectionExit(Sender: TObject);
    procedure btnOtherExit(Sender: TObject);
    procedure lbxSectionExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstCaptionListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lstCaptionListClick(Sender: TObject);
    procedure lstCaptionListExit(Sender: TObject);
    procedure lstCaptionListInsert(Sender: TObject; Item: TListItem);
    procedure FormShow(Sender: TObject);
  private
    FCommentItem: integer;
    FCommentChanged: boolean;
    FUpdateCount: integer;
    FSectionPopulated: boolean;
  protected
    FUpdatingGrid: boolean;
    FPCEListCodesProc: TPCEListCodesProc;
    FPCEItemClass: TPCEItemClass;
    FPCECode: string;
    FSplitterMove: Boolean;
    FProblems: TStringList;
    function GetCat: string;
    procedure UpdateNewItemStr(var x: string); virtual; abstract;
    procedure GridChanged; virtual;
    procedure UpdateControls; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    function NotUpdating: Boolean;
    procedure CheckOffEntries;
    procedure UpdateTabPos;
    procedure Sync2Grid;
    procedure Sync2Section;
    procedure FormatVimmInputs(Grid, IsSkinTest: Boolean);
  public
    procedure AllowTabChange(var AllowChange: boolean); override;
    procedure InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
    procedure RemoveAll;
  end;

var
  frmPCEBaseMain: TfrmPCEBaseMain;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  ORFn,
  fPCELex,
  fPCEOther,
  fEncounterFrame,
  fHFSearch,
  VA508AccessibilityRouter,
  ORCtrlsVA508Compatibility,
  UBAConst,
  rvimm,
  uCore;

{$R *.DFM}

var
  part: Integer = 3;

type
  TLBSectionManager = class(TORListBox508Manager)
  public
    function GetItemInstructions(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
  end;

procedure TfrmPCEBaseMain.lbSectionClick(Sender: TObject);
var
  SecItems: TStrings;
begin
  inherited;
  ClearGrid;
  FPCEListCodesProc(lbxSection.Items, lbSection.ItemIEN);
  CheckOffEntries;
  FSectionPopulated := True;
  if (lbSection.Items.Count > 0) then
    lblList.Caption := StringReplace(lbSection.DisplayText[lbSection.ItemIndex],
      '&', '&&', [rfReplaceAll] );
  if (lbSection.DisplayText[lbSection.ItemIndex] = DX_PROBLEM_LIST_TXT) then
  begin
    SecItems := lbxSection.Items;
    FastAssign(SecItems, FProblems);
  end;
end;

procedure TfrmPCEBaseMain.GridChanged;
var
  I: Integer;
  TmpList: TStringList;
begin
  TmpList := TStringList.Create;
  try
    BeginUpdate;
    try
      SaveGridSelected;
      FastAssign(lstCaptionList.ItemsStrings, TmpList);
      for I := lstCaptionList.Items.Count - 1 downto 0 do
      begin
        if lstCaptionList.Objects[I] is TPCEItem then
        begin
          TmpList[I] := TPCEItem(lstCaptionList.Objects[I]).ItemStr;
          TmpList.Objects[I] := lstCaptionList.Objects[I];
        end else begin
          lstCaptionList.Objects[I].Free;
          lstCaptionList.Items[I].Delete;
          TmpList.Delete(I);
          RemoveGridSelected(I);
        end;
      end;

      lstCaptionList.ItemsStrings.Assign(TmpList); //cq: 13228
      RestoreGridSelected;
    finally
      EndUpdate;
    end;
  finally
    FreeAndNil(TmpList);
  end;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.btnOtherClick(Sender: TObject);
var
  x, Code: string;
  APCEItem: TPCEItem;
  SrchCode: integer;
begin
  inherited;
  ClearGrid;
  SrchCode := (Sender as Vcl.StdCtrls.TButton).Tag;
  if(SrchCode <= LX_Threshold) then
    LexiconLookup(Code, SrchCode, 0, False, '')
  else
  if(SrchCode = PCE_HF) then
    HFLookup(Code)
  else
    OtherLookup(Code, SrchCode);
  btnOther.SetFocus;
  if Code <> '' then
  begin
    x := FPCECode + U + Piece(Code, U, 1) + U + U + Piece(Code, U, 2);
    if FPCEItemClass = TPCEProc then
      SetPiece(x, U, pnumProvider, IntToStr(uProviders.PCEProvider));
    UpdateNewItemStr(x);
    APCEItem := FPCEItemClass.Create;
    APCEItem.SetFromString(x);
    GridIndex := lstCaptionList.Add(APCEItem.ItemStr, APCEItem);
  end;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.edtCommentExit(Sender: TObject);
begin
  inherited;
  if (FCommentChanged) then
  begin
    FCommentChanged := False;
    if (FCommentItem >= 0) and (FCommentItem < lstCaptionList.Items.Count) and
      (lstCaptionList.Objects[FCommentItem] is TPCEItem) then
        TPCEItem(lstCaptionList.Objects[FCommentItem]).Comment :=
        edtComment.text;
  end;
end;

procedure TfrmPCEBaseMain.AllowTabChange(var AllowChange: boolean);
begin
  edtCommentExit(Self);
end;

procedure TfrmPCEBaseMain.edtCommentChange(Sender: TObject);
begin
  inherited;
  FCommentItem := GridIndex;
  FCommentChanged := TRUE;
end;

procedure TfrmPCEBaseMain.btnRemoveClick(Sender: TObject);
var
  I, J: Integer;
  APCEItem: TPCEItem;
  CurCategory, SCode, SNarr: String;
begin
  inherited;
  FUpdatingGrid := True;
  try
    CurCategory := GetCat;
    for I := lstCaptionList.Items.Count - 1 downto 0 do
      if (lstCaptionList.Items[I].Selected) then
      begin
      if lstCaptionList.Objects[I] is TPCEItem then
      begin
        APCEItem := TPCEItem(lstCaptionList.Objects[I]);
        if APCEItem.Category = CurCategory then
        begin
          for J := 0 to lbxSection.Items.Count - 1 do
          begin
            SCode := Piece(lbxSection.Items[J], U, 1);
            SNarr := Piece(lbxSection.Items[J], U, 2);
              if (Pos(APCEItem.Code, SCode) > 0) and
                (Pos(SNarr, APCEItem.Narrative) > 0) then
                  lbxSection.Checked[J] := False;
            end;
        end;
      end;
      lstCaptionList.Objects[I].Free;
      lstCaptionList.Items[I].Delete
    end;

    ClearGrid;
  finally
    FUpdatingGrid := False;
  end;
end;

procedure TfrmPCEBaseMain.UpdateControls;
var
  CommentOK: Boolean;
begin
  btnSelectAll.Enabled := (lstCaptionList.Items.Count > 0);
  btnRemove.Enabled := (lstCaptionList.Items.Count > 0);
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      inherited;
      CommentOK := (lstCaptionList.SelCount = 1);
      lblComment.Enabled := CommentOK;
      edtComment.Enabled := CommentOK;
      if(CommentOK) and (lstCaptionList.Objects[GridIndex] is TPCEItem) then
        edtComment.Text := TPCEItem(lstCaptionList.Objects[GridIndex]).Comment
      else
        edtComment.Text := '';
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmPCEBaseMain.FormatVimmInputs(Grid, IsSkinTest: Boolean);
begin
  uvimmInputs.noGrid := Grid;
  uvimmInputs.makeNote := False;
  uvimmInputs.collapseICE := True;
  uvimmInputs.canSaveData := False;
  uvimmInputs.patientName := Patient.Name;
  uvimmInputs.patientIEN := Patient.DFN;
  uvimmInputs.userName := User.Name;
  uvimmInputs.userIEN := User.DUZ;
  uvimmInputs.isSkinTest := IsSkinTest;
  uVimmInputs.startInEditMode := False;
  uvimmInputs.encounterProviderName := uEncPCEData.Providers.PCEProviderName;
  uvimmInputs.encounterProviderIEN := uEncPCEData.Providers.PCEProvider;
  uvimmInputs.encounterLocation := uEncPCEData.Location;
  uvimmInputs.encounterCategory := uEncPCEData.VisitCategory;
  uvimmInputs.dateEncounterDateTime := uEncPCEData.VisitDateTime;
  uvimmInputs.visitString := uEncPCEData.VisitString;
  if uEncPCEData.VisitCategory = 'E' then
    uVimmInputs.selectionType := 'historical'
  else uVimmInputs.selectionType := 'current';
  uVimmInputs.immunizationReading := False;
end;

procedure TfrmPCEBaseMain.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);
  FProblems := TStringList.Create;
  lbxSection.HideSelection := TRUE;
  amgrMain.ComponentManager[lbSection] := TLBSectionManager.Create;
end;

procedure TfrmPCEBaseMain.FormDestroy(Sender: TObject);
begin
  inherited;
  FProblems.Free;
end;

procedure TfrmPCEBaseMain.InitTab(ACopyProc: TCopyItemsMethod; AListProc: TListSectionsProc);
begin
  AListProc(lbSection.Items);
  ACopyProc(lstCaptionList);
  lbSection.ItemIndex := 0;
  lbSectionClick(lbSection);
  ClearGrid;
  GridChanged;
end;

procedure TfrmPCEBaseMain.BeginUpdate;
begin
  if FUpdateCount <= 0 then FUpdateCount := 0;
  Inc(FUpdateCount);
end;

procedure TfrmPCEBaseMain.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then FUpdateCount := 0;
end;

function TfrmPCEBaseMain.NotUpdating: Boolean;
begin
  Result := FUpdateCount <= 0;
end;

procedure TfrmPCEBaseMain.RemoveAll;
begin
  Self.btnSelectAll.Click;
  Self.btnRemove.Click;
end;

procedure TfrmPCEBaseMain.CheckOffEntries;
{ TODO -oRich V. -cCode Set Versioning : Uncomment these lines to prevent acceptance of existing inactive DX codes. }
const
  TX_INACTIVE_CODE1 = 'The diagnosis of "';
  TX_INACTIVE_ICD_CODE = '" entered for this encounter contains an inactive ICD code of "';
  TX_INACTIVE_SCT_CODE = '" entered for this encounter contains an inactive SNOMED CT code';
  TX_INACTIVE_CODE3 = ' as of the encounter date, and will be removed.' + #13#10#13#10 +
                          'Please select another diagnosis.';
  TC_INACTIVE_CODE = 'Diagnosis Contains Inactive Code';
var
  i, j: Integer;
  CurCategory, SCode, SNarr: string;
  APCEItem: TPCEItem;
begin
  FUpdatingGrid := TRUE;
  try
    if(lbSection.Items.Count < 1) then exit;
    CurCategory := GetCat;
    for i := lstCaptionList.Items.Count - 1 downto 0 do
    begin
      if not (lstCaptionList.Objects[i] is TPCEItem) then
        continue;
      APCEItem := TPCEItem(lstCaptionList.Objects[i]);
      if APCEItem.Category = CurCategory then
      begin
        for j := 0 to lbxSection.Items.Count - 1 do
        begin
          SCode := Piece(lbxSection.Items[j], U, 1);
          SNarr := Piece(lbxSection.Items[j], U, 2);
          if (Pos(APCEItem.Code, SCode) > 0) then
          begin
            if (CurCategory = 'Problem List Items') and ((Pos('#', Piece(lbxSection.Items[j], U, 4)) > 0) or
               (Pos('$', Piece(lbxSection.Items[j], U, 4)) > 0)) then
            begin
              if (Pos('#', Piece(lbxSection.Items[j], U, 4)) > 0) then
                InfoBox(TX_INACTIVE_CODE1 + APCEItem.Narrative + TX_INACTIVE_ICD_CODE +
                     APCEItem.Code + TX_INACTIVE_CODE3, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK)
              else if (Pos('$', Piece(lbxSection.Items[j], U, 4)) > 0) then
                InfoBox(TX_INACTIVE_CODE1 + APCEItem.Narrative + TX_INACTIVE_SCT_CODE +
                     TX_INACTIVE_CODE3, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
              lbxSection.Checked[j] := False;
              APCEItem.Free;
              lstCaptionList.Items.Delete(i);
            end
            else
              lbxSection.Checked[j] := True;
          end;
        end;
      end;
    end;
  finally
    FUpdatingGrid := FALSE;
  end;
end;

procedure TfrmPCEBaseMain.btnSelectAllClick(Sender: TObject);
var
  I: Integer;
begin
  inherited;
  BeginUpdate;
  try
    for I := 0 to lstCaptionList.Items.Count - 1 do
      lstCaptionList.Items[I].Selected := True;
  finally
    EndUpdate;
  end;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.FormResize(Sender: TObject);
begin
  if FSplitterMove then
    FSplitterMove := False
  else
    inherited;
end;

procedure TfrmPCEBaseMain.FormShow(Sender: TObject);
begin
  pnlMain.Height := (self.ClientHeight - pnlBottomAncestor.Height) div part;
  pnlComments.Align := alBottom;
  inherited;
end;

function TfrmPCEBaseMain.GetCat: string;
begin
  Result := '';
  if(lbSection.Items.Count > 0) and (lbSection.ItemIndex >= 0) then
    Result := Piece(lbSection.Items[lbSection.ItemIndex], U, 2);
end;

procedure TfrmPCEBaseMain.lbxSectionClickCheck(Sender: TObject;
  Index: Integer);
var
  i, j: Integer;
  x, SCat, SCode, SNarr, CodeCatNarr: string;
  APCEItem: TPCEItem;
  Found, OK: boolean;
begin
  inherited;
  if FUpdatingGrid or FClosing then exit;

  SCat := GetCat;
  for i := 0 to lbxSection.Items.Count-1 do
  begin
    x := ORFn.Pieces(lbxSection.Items[i], U, 1, 2);
    SCode := Piece(x, U, 1);
    SNarr := Piece(x, U, 2);
    CodeCatNarr := SCode + U + SCat + U + SNarr;
    Found := FALSE;
    for j := lstCaptionList.Items.Count - 1 downto 0 do
    begin
      if not (lstCaptionList.Objects[j] is TPCEItem) then
        continue;
      APCEItem := TPCEItem(lstCaptionList.Objects[j]);
      OK := (SCat = APCEItem.Category) and (Pos(APCEItem.Code, SCode) > 0);
      if OK then
      begin
        if (FPCEItemClass = TPCEDiag) and (TPCEDiag(APCEItem).OldNarrative <> '') then
          OK := (Pos(SNarr, TPCEDiag(APCEItem).OldNarrative) > 0)
        else
          OK := (Pos(SNarr, APCEItem.Narrative) > 0);
      end;
      if OK then
      begin
        Found := TRUE;
        if(lbxSection.Checked[i]) then break;
        APCEItem.Free;
        lstCaptionList.Items.Delete(j);
      end;
    end;
    if(lbxSection.Checked[i] and (not Found)) then
    begin
      x := FPCECode + U + CodeCatNarr;
      if FPCEItemClass = TPCEProc then
      begin
        SetPiece(x, U, pnumProvider, IntToStr(uProviders.PCEProvider));
        SetPiece(x, U, pnumProcQty, Piece(lbxSection.Items[i], U, 7));
      end;
      UpdateNewItemStr(x);
      APCEItem := FPCEItemClass.Create;
      APCEItem.SetFromString(x);
      GridIndex := lstCaptionList.Add(APCEItem.ItemStr, APCEItem);
    end;
  end;

  UpdateControls;
end;

procedure TfrmPCEBaseMain.lstCaptionListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.lstCaptionListClick(Sender: TObject);
begin
  inherited;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.lstCaptionListInsert(Sender: TObject; Item: TListItem);
begin
  inherited;
  UpdateControls;
end;

procedure TfrmPCEBaseMain.UpdateTabPos;
begin
  lbxSection.TabPositions := SectionString;
end;

procedure TfrmPCEBaseMain.splLeftMoved(Sender: TObject);
// RDD: Can I remove all of this?
begin
  inherited;
  FSplitterMove := True;
  FormResize(Sender);
end;

procedure TfrmPCEBaseMain.Sync2Grid;
var
  i, idx, cnt, NewIdx: Integer;
  SCode, SNarr: String;
  APCEItem: TPCEItem;
begin
  if(FUpdatingGrid or FClosing) then exit;
  FUpdatingGrid := TRUE;
  try
    cnt := 0;
    idx := -1;
    for i := 0 to lstCaptionList.Items.Count - 1 do
    begin
      if(lstCaptionList.Items[i].Selected) and (lstCaptionList.Objects[i] is TPCEItem) then
      begin
        if(idx < 0) then idx := i;
        inc(cnt);
        if(cnt > 1) then break;
      end;
    end;
    NewIdx := -1;
    if(cnt = 1) then
    begin
      APCEItem := TPCEItem(lstCaptionList.Objects[idx]);
      if APCEItem.Category = GetCat then
      begin
        for i := 0 to lbxSection.Items.Count - 1 do
        begin
          SCode := Piece(lbxSection.Items[i], U, 1);
          SNarr := Piece(lbxSection.Items[i], U, 2);
          if (Pos(APCEItem.Code, SCode) > 0) and
            (Pos(SNarr, APCEItem.Narrative) > 0) then
          begin
            NewIdx := i;
            break;
          end;
        end;
      end;
    end;
    lbxSection.ItemIndex := NewIdx;
  finally
    FUpdatingGrid := FALSE;
  end;
end;

procedure TfrmPCEBaseMain.Sync2Section;
var
  i, idx: Integer;
  APCEItem: TPCEItem;
  SCat, SCode, SNarr: String;
begin
  if(FUpdatingGrid or FClosing) then exit;
  FUpdatingGrid := TRUE;
  try
    idx := lbxSection.ItemIndex;
    if (idx >= 0) then
    begin
      SCat := GetCat;
      SCode := Piece(lbxSection.Items[idx], U, 1);
      SNarr := Piece(lbxSection.Items[idx], U, 2);
    end
    else
    begin
      SCat := '~@';
      SCode := '~@';
      SNarr := '~@';
    end;
    for i := 0 to lstCaptionList.Items.Count - 1 do
    begin
      if not (lstCaptionList.Objects[i] is TPCEItem) then
        continue;
      APCEItem := TPCEItem(lstCaptionList.Objects[i]);
      lstCaptionList.Items[I].Selected :=
        ((SCat = APCEItem.Category) and (Pos(APCEItem.Code, SCode) > 0) and
        (Pos(SNarr, APCEItem.Narrative) >= 0));
    end;
  finally
    FUpdatingGrid := FALSE;
  end;
end;

procedure TfrmPCEBaseMain.edtCommentKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if (Key = '?') and
     ((edtComment.Text = '') or (edtComment.SelStart = 0)) then
    Key := #0;
end;

{ TLBSectionManager }

function TLBSectionManager.GetItemInstructions(Component: TWinControl): string;
var
  lb : TORListBox;
  idx: integer;
begin
  lb := TORListBox(Component);
  idx := lb.ItemIndex;
  if (idx >= 0) and lb.Selected[idx] then
    Result := 'Press space bar to populate ' +
        TfrmPCEBaseMain(Component.Owner).FTabName + ' section'
  else
    result := inherited GetItemInstructions(Component);
end;

function TLBSectionManager.GetState(Component: TWinControl): string;
var
  frm: TfrmPCEBaseMain;
begin
  Result := '';
  frm := TfrmPCEBaseMain(Component.Owner);
  if frm.FSectionPopulated then
  begin
    frm.FSectionPopulated := FALSE;
    Result := frm.FTabName + ' section populated with ' +
      IntToStr(frm.lbxSection.Count) + ' items';
  end;
end;

procedure TfrmPCEBaseMain.lbSectionExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed and lbxSection.CanFocus then lbxSection.SetFocus;
end;

procedure TfrmPCEBaseMain.lbxSectionExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
  begin
    if btnOther.CanFocus then btnOther.SetFocus;
  end else begin
    if ShiftTabIsPressed and lbSection.CanFocus then lbSection.SetFocus;
  end;
end;

procedure TfrmPCEBaseMain.btnOtherExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
  begin
    if lstCaptionList.CanFocus then lstCaptionList.SetFocus;
  end else begin
    if ShiftTabIsPressed and lbxSection.CanFocus then lbxSection.SetFocus;
  end;
end;

procedure TfrmPCEBaseMain.lstCaptionListExit(Sender: TObject);
begin
  inherited;
  if ShiftTabIsPressed and btnOther.CanFocus then btnOther.SetFocus;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPCEBaseMain);
end.

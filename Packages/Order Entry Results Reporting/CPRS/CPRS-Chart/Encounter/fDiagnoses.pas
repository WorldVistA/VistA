unit fDiagnoses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORNet, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  ComCtrls, fPCEBaseMain, UBAGlobals, UBAConst, UCore, VA508AccessibilityManager,
  ORCtrls;

type
  TfrmDiagnoses = class(TfrmPCEBaseMain)
    cmdDiagPrimary: TButton;
    ckbDiagProb: TCheckBox;
    procedure cmdDiagPrimaryClick(Sender: TObject);
    procedure ckbDiagProbClicked(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormResize(Sender: TObject); override;
    procedure lbxSectionClickCheck(Sender: TObject; Index: Integer);
    procedure btnOKClick(Sender: TObject);  override;
    procedure lbSectionClick(Sender: TObject);
    procedure GetEncounterDiagnoses;
    procedure lbSectionDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbxSectionDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbGridSelect(Sender: TObject);
  private
    procedure EnsurePrimaryDiag;
    function isProblem(diagnosis: TPCEDiag): Boolean;
    function isEncounterDx(problem: string): Boolean;
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

const
  TX_INACTIVE_ICD_CODE     = 'The "#" character next to the code for this problem indicates that the problem' + #13#10 +
                             'references an ICD code that is not active as of the date of this encounter.' + #13#10 +
                             'Before you can select this problem, you must update the ICD code it contains' + #13#10 +
                             'via the Problems tab.';
  TX_INACTIVE_SCT_CODE     = 'The "#" character next to the code for this problem indicates that the problem' + #13#10 +
                             'references a SNOMED CT code that is not active as of the date of this encounter.' + #13#10 +
                             'Before you can select this problem, you must update the SNOMED CT code it contains' + #13#10 +
                             'via the Problems tab.';
  TX_INACTIVE_ICD_SCT_CODE = 'The "#" character next to the code for this problem indicates that the problem' + #13#10 +
                             'references BOTH an ICD and a SNOMED CT code that is not active as of the date' + #13#10 +
                             'of this encounter. Before you can select this problem, you must update the codes' + #13#10 +
                             'it contains via the Problems tab.';
  TC_INACTIVE_CODE         = 'Problem Contains Inactive Code';
  TX_REDUNDANT_DX          = 'The problem that you''ve selected is already included in the list of diagnoses' + #13#10 +
                             'for this encounter. No need to select it again...';
  TC_REDUNDANT_DX          = 'Redundant Diagnosis: ';

var
  frmDiagnoses: TfrmDiagnoses;
  dxList : TStringList;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, UBACore, VA508AccessibilityRouter;

type
  TORCBImgIdx = (iiUnchecked, iiChecked, iiGrayed, iiQMark, iiBlueQMark,
    iiDisUnchecked, iiDisChecked, iiDisGrayed, iiDisQMark,
    iiFlatUnChecked, iiFlatChecked, iiFlatGrayed,
    iiRadioUnchecked, iiRadioChecked, iiRadioDisUnchecked, iiRadioDisChecked);

const
  CheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'ORCB_UNCHECKED', 'ORCB_CHECKED', 'ORCB_GRAYED', 'ORCB_QUESTIONMARK',
    'ORCB_BLUEQUESTIONMARK', 'ORCB_DISABLED_UNCHECKED', 'ORCB_DISABLED_CHECKED',
    'ORCB_DISABLED_GRAYED', 'ORCB_DISABLED_QUESTIONMARK',
    'ORLB_FLAT_UNCHECKED', 'ORLB_FLAT_CHECKED', 'ORLB_FLAT_GRAYED',
    'ORCB_RADIO_UNCHECKED', 'ORCB_RADIO_CHECKED',
    'ORCB_RADIO_DISABLED_UNCHECKED', 'ORCB_RADIO_DISABLED_CHECKED');

  BlackCheckBoxImageResNames: array[TORCBImgIdx] of PChar = (
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_QUESTIONMARK', 'BLACK_ORCB_BLUEQUESTIONMARK',
    'BLACK_ORCB_DISABLED_UNCHECKED', 'BLACK_ORCB_DISABLED_CHECKED',
    'BLACK_ORCB_DISABLED_GRAYED', 'BLACK_ORCB_DISABLED_QUESTIONMARK',
    'BLACK_ORLB_FLAT_UNCHECKED', 'BLACK_ORLB_FLAT_CHECKED', 'BLACK_ORLB_FLAT_GRAYED',
    'BLACK_ORCB_RADIO_UNCHECKED', 'BLACK_ORCB_RADIO_CHECKED',
    'BLACK_ORCB_RADIO_DISABLED_UNCHECKED', 'BLACK_ORCB_RADIO_DISABLED_CHECKED');

var
  ORCBImages: array[TORCBImgIdx, Boolean] of TBitMap;

function GetORCBBitmap(Idx: TORCBImgIdx; BlackMode: boolean): TBitmap;
var
  ResName: string;
begin
  if (not assigned(ORCBImages[Idx, BlackMode])) then
  begin
    ORCBImages[Idx, BlackMode] := TBitMap.Create;
    if BlackMode then
      ResName := BlackCheckBoxImageResNames[Idx]
    else
      ResName := CheckBoxImageResNames[Idx];
    ORCBImages[Idx, BlackMode].LoadFromResourceName(HInstance, ResName);
  end;
  Result := ORCBImages[Idx, BlackMode];
end;

procedure TfrmDiagnoses.EnsurePrimaryDiag;
var
  i: Integer;
  Primary: Boolean;

begin
  with lbGrid do
  begin
    Primary := False;
    for i := 0 to Items.Count - 1 do
      if TPCEDiag(Items.Objects[i]).Primary then
        Primary := True;

    if not Primary and (Items.Count > 0) then
    begin
      GridIndex := Items.Count - 1;//0; zzzzzzbellc CQ 15836
      TPCEDiag(Items.Objects[Items.Count - 1]).Primary := True;
      GridChanged;
    end;
  end;
end;

procedure TfrmDiagnoses.cmdDiagPrimaryClick(Sender: TObject);
var
  gi, i: Integer;
  ADiagnosis: TPCEDiag;

begin
  inherited;
  gi := GridIndex;
  with lbGrid do for i := 0 to Items.Count - 1 do
  begin
    ADiagnosis := TPCEDiag(Items.Objects[i]);
    ADiagnosis.Primary := (gi = i);
  end;
  GridChanged;
end;

procedure TfrmDiagnoses.ckbDiagProbClicked(Sender: TObject);
var
  i: integer;
const
  PL_ITEMS = 'Problem List Items';

begin
  inherited;
  if(NotUpdating) then
  begin
    for i := 0 to lbGrid.Items.Count-1 do
      if(lbGrid.Selected[i]) then
        TPCEDiag(lbGrid.Items.Objects[i]).AddProb := (ckbDiagProb.Checked) and
                                                     (not isProblem(TPCEDiag(lbGrid.Items.Objects[i]))) and
                                                     (TPCEDiag(lbGrid.Items.Objects[i]).Category <> PL_ITEMS);
    GridChanged;
  end;
end;

procedure TfrmDiagnoses.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_DiagNm;
  FPCEListCodesProc := ListDiagnosisCodes;
  FPCEItemClass := TPCEDiag;
  FPCECode := 'POV';
  FSectionTabCount := 3;
  FormResize(Self);
end;

procedure TfrmDiagnoses.btnRemoveClick(Sender: TObject);
begin
  inherited;
  Sync2Grid;
  EnsurePrimaryDiag;
end;

procedure TfrmDiagnoses.UpdateNewItemStr(var x: string);
begin
  inherited;
  if lbGrid.Items.Count = 0 then
    x := x + U + '1'
  else
    x := x + U + '0';
end;

function TfrmDiagnoses.isProblem(diagnosis: TPCEDiag): Boolean;
var
  i: integer;
  p, code, narr, sct: String;
begin
  result := false;
  for i := 0 to FProblems.Count - 1 do
  begin
    p := FProblems[i];
    code := piece(p, '^', 1);
    narr := piece(p, '^', 2);
    if (pos('SCT', narr) > 0) or (pos('SNOMED', narr) > 0) then
      sct := piece(piece(piece(narr, ')', 1), '(', 2), ' ', 2)
    else
      sct := '';
    narr := TrimRight(piece(narr, '(',1));
    if pos(diagnosis.Code, code) > 0 then
    begin
      result := true;
      break;
    end
    else if (sct <> '') and (pos(sct, diagnosis.Narrative) > 0) then
    begin
      result := true;
      break;
    end
    else if pos(narr, diagnosis.Narrative) > 0 then
    begin
      result := true;
      break;
    end;
  end;
end;

function TfrmDiagnoses.isEncounterDx(problem: string): Boolean;
var
  i: integer;
  dx, code, narr, pCode, pNarrative, sct: String;

function getSCT(narr: string): string;
begin
  if (pos('SNOMED CT ', narr) > 0) then
    result := copy(narr, pos('SNOMED CT ', narr) + 10, length(narr))
  else
    result := '';
end;

begin
  result := false;
  pCode := piece(problem, U, 1);
  pNarrative := piece(problem, U, 2);
  for i := 0 to lbGrid.Items.Count - 1 do
  begin
    dx := lbGrid.Items[i];
    narr := piece(dx, U, 3);
    code := piece(piece(copy(narr, pos('ICD-9-CM', narr), length(narr)), ' ', 2), ')', 1);
    sct := getSCT(piece(narr, ':', 1));
    if pos(pCode, narr) > 0 then
    begin
      result := true;
      break;
    end
    else if (sct <> '') and (pos(sct, pNarrative) > 0) then
    begin
      result := true;
      break;
    end
    else if pos(narr, pNarrative) > 0 then
    begin
      result := true;
      break;
    end;
  end;
end;

procedure TfrmDiagnoses.UpdateControls;
var
  i, j, k, PLItemCount: integer;
  OK: boolean;
const
  PL_ITEMS = 'Problem List Items';
begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      cmdDiagPrimary.Enabled := (lbGrid.SelCount = 1);
      OK := (lbGrid.SelCount > 0);
      PLItemCount := 0;
      if OK then
        for k := 0 to lbGrid.Items.Count - 1 do
        begin
          if (lbGrid.Selected[k]) then
          begin
            if (TPCEDiag(lbGrid.Items.Objects[k]).Category = PL_ITEMS) or isProblem(TPCEDiag(lbGrid.Items.Objects[k])) then
              PLItemCount := PLItemCount + 1;
          end;
        end;
      OK := OK and (PLItemCount < lbGrid.SelCount);
      ckbDiagProb.Enabled := OK;
      if(OK) then
      begin
        j := 0;
        for i := 0 to lbGrid.Items.Count-1 do
        begin
          if(lbGrid.Selected[i]) and (TPCEDiag(lbGrid.Items.Objects[i]).AddProb) then
            inc(j);
        end;
        if(j = 0) then
          ckbDiagProb.Checked := FALSE
        else
        if(j < lbGrid.SelCount) then
          ckbDiagProb.State := cbGrayed
        else
          ckbDiagProb.Checked := TRUE;
      end
      else
        ckbDiagProb.Checked := FALSE;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmDiagnoses.FormResize(Sender: TObject);
begin
  inherited;
  FSectionTabs[0] := -(lbxSection.width - LBCheckWidthSpace - (10 * MainFontWidth) - ScrollBarWidth);
  FSectionTabs[1] := -FSectionTabs[0]+2;
  FSectionTabs[2] := -FSectionTabs[0]+4;
  UpdateTabPos;
end;

procedure TfrmDiagnoses.lbxSectionClickCheck(Sender: TObject;
  Index: Integer);
begin
  if (not FUpdatingGrid) and (lbxSection.Checked[Index]) then
  begin
    if (Piece(lbxSection.Items[Index], U, 4) = '#') then
    begin
      InfoBox(TX_INACTIVE_ICD_CODE, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end
    else if (Piece(lbxSection.Items[Index], U, 4) = '$') then
    begin
      InfoBox(TX_INACTIVE_SCT_CODE, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end
    else if (Piece(lbxSection.Items[Index], U, 4) = '#$') then
    begin
      InfoBox(TX_INACTIVE_ICD_SCT_CODE, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end
    else if isEncounterDx(lbxSection.Items[Index]) then
    begin
      InfoBox(TX_REDUNDANT_DX, TC_REDUNDANT_DX + piece(lbxSection.Items[Index], '^',2),
        MB_ICONWARNING or MB_OK);
      lbxSection.Checked[Index] := False;
      exit;
    end;
  end;
  inherited;
  EnsurePrimaryDiag;
end;

procedure TfrmDiagnoses.lbxSectionDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Narr, Code: String;
  Format, CodeTab, ItemRight, DY: Integer;
  ARect, TmpR: TRect;
  BMap: TBitMap;
begin
  inherited;
  Narr := Piece((Control as TORListBox).Items[Index], U, 2);
  Code := Piece((Control as TORListBox).Items[Index], U, 3);
  CodeTab := StrToInt(Piece(lbxSection.TabPositions, ',', 2));

  // draw CheckBoxes
  with lbxSection do
  begin
    if (CheckBoxes) then
    begin
      case CheckedState[Index] of
        cbUnchecked:
        begin
          if (FlatCheckBoxes) then
            BMap := GetORCBBitmap(iiFlatUnChecked, False)
          else
            BMap := GetORCBBitmap(iiUnchecked, False);
        end;
        cbChecked:
        begin
          if (FlatCheckBoxes) then
            BMap := GetORCBBitmap(iiFlatChecked, False)
          else
            BMap := GetORCBBitmap(iiChecked, False);
        end;
      else // cbGrayed:
      begin
        if (FlatCheckBoxes) then
          BMap := GetORCBBitmap(iiFlatGrayed, False)
        else
          BMap := GetORCBBitmap(iiGrayed, False);
        end;
      end;
      TmpR := Rect;
      TmpR.Right := TmpR.Left;
      dec(TmpR.Left, (LBCheckWidthSpace - 5));
      DY := ((TmpR.Bottom - TmpR.Top) - BMap.Height) div 2;
      Canvas.Draw(TmpR.Left, TmpR.Top + DY, BMap);
    end;
  end;

  // draw the Problem Text
  ARect := (Control as TListBox).ItemRect(Index);
  ARect.Left := ARect.Left + LBCheckWidthSpace;
  ItemRight := ARect.Right;
  ARect.Right := CodeTab - 10;
  Format := (DT_LEFT or DT_NOPREFIX or DT_WORD_ELLIPSIS);
  DrawText((Control as TListBox).Canvas.Handle, PChar(Narr), Length(Narr), ARect, Format);

  // now draw ICD codes
  ARect.Left := CodeTab;
  ARect.Right := ItemRight;
  DrawText((Control as TListBox).Canvas.Handle, PChar(Code), Length(Code), ARect, Format);
end;

procedure TfrmDiagnoses.btnOKClick(Sender: TObject);
begin
  inherited;
  if  BILLING_AWARE then
     GetEncounterDiagnoses;
end;

procedure TfrmDiagnoses.lbGridSelect(Sender: TObject);
begin
  inherited;
  Sync2Grid;
end;

procedure TfrmDiagnoses.lbSectionClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmDiagnoses.GetEncounterDiagnoses;
var
  i: integer;
  dxCode, dxName: string;
  ADiagnosis: TPCEItem;
begin
  inherited;
  UBAGlobals.BAPCEDiagList.Clear;
  with lbGrid do for i := 0 to Items.Count - 1 do
  begin
    ADiagnosis := TPCEDiag(Items.Objects[i]);
    dxCode :=  ADiagnosis.Code;
    dxName :=  ADiagnosis.Narrative;
    if BAPCEDiagList.Count = 0 then
       UBAGlobals.BAPCEDiagList.Add(U + DX_ENCOUNTER_LIST_TXT);
    UBAGlobals.BAPCEDiagList.Add(dxCode + U + dxName);
  end;
end;


procedure TfrmDiagnoses.lbSectionDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  inherited;
  if (control as TListbox).items[index] = DX_PROBLEM_LIST_TXT then
     (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     if (control as Tlistbox).items[index] = DX_PERSONAL_LIST_TXT then
        (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     if (control as Tlistbox).items[index] =  DX_TODAYS_DX_LIST_TXT  then
        (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     if (control as Tlistbox).items[index] = DX_ENCOUNTER_LIST_TXT then
        (Control as TListBox).Canvas.Font.Style := [fsBold]
  else
     (Control as TListBox).Canvas.Font.Style := [];

  (Control as TListBox).Canvas.TextOut(Rect.Left+2, Rect.Top+1, (Control as
              TListBox).Items[Index]); {display the text }
end;

initialization
  SpecifyFormIsNotADialog(TfrmDiagnoses);

end.

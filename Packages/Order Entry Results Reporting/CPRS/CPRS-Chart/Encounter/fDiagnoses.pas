unit fDiagnoses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ORNet, ExtCtrls, Buttons, uPCE, ORFn,
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
  private
    procedure EnsurePrimaryDiag;
    procedure GetSCTforICD(ADiagnosis: TPCEDiag);
    procedure UpdateProblem(AplIEN: String; AICDCode: String; ASCTCode: String = '');
    function isProblem(diagnosis: TPCEDiag): Boolean;
    function isEncounterDx(problem: string): Boolean;
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

const
  TX_INACTIVE_ICD_CODE     = 'This problem references an ICD code that is not active as of the date of this encounter. ' +
                             'Please update the ICD Diagnosis.';
  TX_NONSPEC_ICD_CODE      = 'Please enter a more specific ICD Diagnosis for this problem.';
  TX_INACTIVE_SCT_CODE     = 'This problem references a SNOMED CT code that is not active as of the date of this encounter. ' +
                             'Please update the SNOMED CT code.';
  TX_INACTIVE_ICD_SCT_CODE = 'This problem references BOTH an ICD and a SNOMED CT code that are not active as of the date ' +
                             'of this encounter. Please update the codes now.';
  TX_ICD_LACKS_SCT_CODE    = 'Addition of a diagnosis to the problem list requires a SNOMED CT code. Please ' +
                             'select the SNOMED CT concept which best describes the diagnosis: ';
  TX_PROB_LACKS_SCT_CODE   = 'You''ve selected to update a problem from the Problem List which now requires a SNOMED CT code. ' +
                             'Please enter a SNOMED CT equivalent term which best describes the diagnosis: ';

  TC_INACTIVE_CODE         = 'Problem Contains Inactive Code';
  TC_NONSPEC_CODE          = 'Problem Contains Non-Specific Code';
  TC_I10_LACKS_SCT         = 'SNOMED CT Needed for Problem Entry';

  TX_REDUNDANT_DX          = 'The problem that you''ve selected is already included in the list of diagnoses ' +
                             'for this encounter. No need to select it again...';
  TC_REDUNDANT_DX          = 'Redundant Diagnosis: ';

  TX_INV_ICD10_DX          = 'The selected ICD-10-CM diagnosis cannot be added to an encounter prior to ICD-10 implementation.' + CRLF + CRLF +
                             'Please select a valid ICD-9-CM diagnosis which best describes the diagnosis.';
  TC_INV_ICD10_DX          = 'Invalid Selection';

var
  frmDiagnoses: TfrmDiagnoses;
  dxList : TStringList;
  PLUpdated: boolean = False;

implementation

{$R *.DFM}

uses
  fEncounterFrame, uConst, UBACore, VA508AccessibilityRouter, fPCELex, rPCE, uProbs, rProbs, rCore;

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

  PL_ITEMS = 'Problem List Items';

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
  with lstRenameMe do
  begin
    Primary := False;
    for i := 0 to Items.Count - 1 do
      if TPCEDiag(Objects[i]).Primary then
        Primary := True;

    if not Primary and (Items.Count > 0) then
    begin
      GridIndex := Items.Count - 1;//0; zzzzzzbellc CQ 15836
      TPCEDiag(Objects[Items.Count - 1]).Primary := True;
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
  with lstRenameMe do for i := 0 to Items.Count - 1 do
  begin
    ADiagnosis := TPCEDiag(Objects[i]);
    ADiagnosis.Primary := (gi = i);
  end;
  GridChanged;
end;

procedure TfrmDiagnoses.ckbDiagProbClicked(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if(NotUpdating) then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
    begin
      if(lstRenameMe.Items[i].Selected) then
      begin
        TPCEDiag(lstRenameMe.Objects[i]).AddProb := (ckbDiagProb.Checked) and
                                                     (not isProblem(TPCEDiag(lstRenameMe.Objects[i]))) and
                                                     (TPCEDiag(lstRenameMe.Objects[i]).Category <> PL_ITEMS);
        //TODO: Add check for I10Active
        if TPCEDiag(lstRenameMe.Objects[i]).AddProb and
          (Piece(Encounter.GetICDVersion, U, 1) = '10D') and
          (not ((pos('SCT', TPCEDiag(lstRenameMe.Objects[i]).Narrative) > 0) or
          (pos('SNOMED', TPCEDiag(lstRenameMe.Objects[i]).Narrative) > 0))) then
            GetSCTforICD(TPCEDiag(lstRenameMe.Objects[i]));
      end;
    end;
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
  if lstRenameMe.Items.Count = 0 then
    x := x + U + '1'
  else
    x := x + U + '0';
end;

procedure TfrmDiagnoses.UpdateProblem(AplIEN: String; AICDCode: String; ASCTCode: String = '');
var
  AList: TStringList;
  ProbRec: TProbRec;
  CodeSysStr: String;
  DateOfInt: TFMDateTime;
begin
  // Update problem list entry with new ICD (& SCT) code(s) (& narrative).
  AList := TStringList.create;
  try
    FastAssign(EditLoad(AplIEN), AList) ;
    ProbRec := TProbRec.create(AList);
    ProbRec.PIFN := AplIEN;

    if AICDCode <> '' then
    begin
      ProbRec.Diagnosis.DHCPtoKeyVal(Pieces(AICDCode, U, 1, 2));
      CodeSysStr := Piece(AICDCode, U, 4);
      if (Pos('10', CodeSysStr) > 0) then
        CodeSysStr := '10D^ICD-10-CM'
      else
        CodeSysStr := 'ICD^ICD-9-CM';
      ProbRec.CodeSystem.DHCPtoKeyVal(CodeSysStr);
    end;

    if ASCTCode <> '' then
    begin
      ProbRec.SCTConcept.DHCPtoKeyVal(Pieces(ASCTCode, U, 1, 2));
      //TODO: need to accommodate changes to Designation Code
      ProbRec.Narrative.DHCPtoKeyVal(U + Piece(ASCTCode, U, 3));
      ProbRec.SCTDesignation.DHCPtoKeyVal(Piece(ASCTCode, U, 4) + U + Piece(ASCTCode, U, 4));
    end;

    ProbRec.RespProvider.DHCPtoKeyVal(IntToStr(Encounter.Provider) + u + Encounter.ProviderName);
    if Encounter.DateTime = 0 then DateOfInt := FMNow
    else DateOfInt := Encounter.DateTime;
    ProbRec.CodeDateStr := FormatFMDateTime('yyyy/mm/dd', DateOfInt);
    AList.Clear;
    FastAssign(EditSave(ProbRec.PIFN, User.DUZ, User.StationNumber, '1', ProbRec.FilerObject, ''), AList);
  finally
    AList.clear;
  end;
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

function ExtractCode(narr: String; csys: String): String;
var cso: Integer;
begin
  if csys = 'SCT' then
  begin
    cso := 4;
  end
  else if (csys = 'ICD') and (pos('ICD-10', narr) > 0) then
  begin
    csys := 'ICD-10-CM';
    cso := 10;
  end
  else
  begin
    csys := 'ICD-9-CM';
    cso := 9;
  end;
  if (pos(csys, narr) > 0) then
    result := Piece(copy(narr, pos(csys, narr) + cso, length(narr)), ')', 1)
  else
    result := '';
end;

begin
  result := false;
  pCode := piece(problem, U, 1);
  pNarrative := piece(problem, U, 2);
  for i := 0 to lstRenameMe.Items.Count - 1 do
  begin
    dx := lstRenameMe.Strings[i];
    narr := piece(dx, U, 3);
    code := ExtractCode(narr, 'ICD');
    sct := ExtractCode(narr, 'SCT');
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
      cmdDiagPrimary.Enabled := (lstRenameMe.SelCount = 1);
      OK := (lstRenameMe.SelCount > 0);
      PLItemCount := 0;
      if OK then
        for k := 0 to lstRenameMe.Items.Count - 1 do
        begin
          if (lstRenameMe.Items[k].Selected) then
          begin
            if (TPCEDiag(lstRenameMe.Objects[k]).Category = PL_ITEMS) or isProblem(TPCEDiag(lstRenameMe.Objects[k])) then
              PLItemCount := PLItemCount + 1;
          end;
        end;
      OK := OK and (PLItemCount < lstRenameMe.SelCount);
      ckbDiagProb.Enabled := OK;
      if(OK) then
      begin
        j := 0;
        for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if(lstRenameMe.Items[i].Selected) and (TPCEDiag(lstRenameMe.Objects[i]).AddProb) then
            inc(j);
        end;
        if(j = 0) then
          ckbDiagProb.Checked := FALSE
        else
        if(j < lstRenameMe.SelCount) then
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

procedure TfrmDiagnoses.lbxSectionClickCheck(Sender: TObject; Index: Integer);
var
  ICDCode, ICDPar, SCTCode, SCTPar, plIEN, msg, SecItem, InputStr, OrigProbStr, I10Description: String;

function GetSearchString(AString: String): String;
begin
  if (Pos('#', AString) > 0) then
    Result := TrimLeft(Piece(AString, '#', 2))
  else
    Result := AString;
end;

begin
  if (not FUpdatingGrid) and (lbxSection.Checked[Index]) then
  begin
    SCTPar := '';
    InputStr := '';
    OrigProbStr := lbxSection.Items[Index];
    if (Piece(lbxSection.Items[Index], U, 4) = '#') or
       (Pos('799.9', Piece(lbxSection.Items[Index], U, 1)) > 0) or
       (Pos('R69', Piece(lbxSection.Items[Index], U, 1)) > 0) then
    begin
      if (Piece(lbxSection.Items[Index], U, 4) = '#') then
        msg := TX_INACTIVE_ICD_CODE
      else
        msg := TX_NONSPEC_ICD_CODE;

      InputStr := GetSearchString(Piece(lbxSection.Items[Index], U, 2));

      LexiconLookup(ICDCode, LX_ICD, 0, True, InputStr, msg);

      if (Piece(ICDCode, U, 1) <> '') then
      begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := Pieces(ICDCode, U, 1, 2) + U + Piece(ICDCode, U, 1) + U + plIEN;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then
        begin
          if not (Pos('SCT', Piece(ICDCode, U, 2)) > 0) and (Piece(Encounter.GetICDVersion, U, 1) = '10D') then
          begin
            //ask for SNOMED CT
            I10Description := Piece(ICDCode, U, 2) + ' (' + Piece(ICDCode, U, 4) + #32 + Piece(ICDCode, U, 1) + ')';
            LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + I10Description);

            if (Piece(SCTCode, U, 4) <> '') then
            begin
              SecItem := lbxSection.Items[Index];
              SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

              FUpdatingGrid := TRUE;
              lbxSection.Items[Index] := SecItem;
              lbxSection.Checked[Index] := True;
              if plIEN <> '' then
              begin
                SCTPar := Piece(SCTCode, U, 4) + U + Piece(SCTCode, U, 4) + U + Piece(SCTCode, U, 2) + U + Piece(SCTCode, U, 3);
              end;
              FUpdatingGrid := FALSE;
            end
            else
            begin
              //Undo previous ICD-10 updates when cancelling out of the SCT update dialog
              lbxSection.Items[Index] := OrigProbStr;
              lbxSection.Checked[Index] := False;
              FUpdatingGrid := False;
              exit;
            end;
          end;
          ICDPar := Piece(ICDCode, U, 3) + U + Piece(ICDCode, U, 1) + U + Piece(ICDCode, U, 2) + U + Piece(ICDCode, U, 4);
          UpdateProblem(plIEN, ICDPar, SCTPar);
          PLUpdated := True;
        end;
        FUpdatingGrid := FALSE;
      end
      else
      begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end
    else if (Piece(lbxSection.Items[Index], U, 4) = '$') then
    begin
      // correct inactive SCT Code
      msg := TX_INACTIVE_SCT_CODE;

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) <> '') then
      begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SecItem := lbxSection.Items[Index];
        SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := SecItem;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then
        begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          UpdateProblem(plIEN, '', SCTPar);
          PLUpdated := True;
        end;
        FUpdatingGrid := FALSE;
      end
      else
      begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end
    else if (Piece(lbxSection.Items[Index], U, 4) = '#$') then
    begin
      // correct inactive SCT Code
      msg := TX_INACTIVE_SCT_CODE;

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) = '') then
      begin
        lbxSection.Checked[Index] := False;
        exit;
      end;

      // correct inactive ICD Code
      msg := TX_INACTIVE_ICD_CODE;

      LexiconLookup(ICDCode, LX_ICD, 0, True, '', msg);

      if (Piece(ICDCode, U, 1) <> '') and (Piece(SCTCode, U, 3) <> '') then
      begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SetPiece(ICDCode, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := Pieces(ICDCode, U, 1, 2) + U + Piece(ICDCode, U, 1) + U + plIEN;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then
        begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          ICDPar := Piece(ICDCode, U, 3) + U + Piece(ICDCode, U, 1) + U + Piece(ICDCode, U, 2) + U + Piece(ICDCode, U, 4);
          UpdateProblem(plIEN, ICDPar, SCTPar);
          PLUpdated := True;
        end;
        FUpdatingGrid := FALSE;
      end
      else
      begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end
    else if (Piece(lbSection.Items[lbSection.ItemIndex], U, 2) = PL_ITEMS) and
      (Piece(Encounter.GetICDVersion, U, 1) = '10D') and
      not (Pos('SCT', Piece(lbxSection.Items[Index], U, 2)) > 0) then
    begin
      // Problem Lacks SCT Code
      msg := TX_PROB_LACKS_SCT_CODE + CRLF + CRLF + Piece(lbxSection.Items[Index], U, 2);

      LexiconLookup(SCTCode, LX_SCT, 0, True, InputStr, msg);

      if (Piece(SCTCode, U, 3) <> '') then
      begin
        plIEN := Piece(lbxSection.Items[Index], U, 5);

        SecItem := lbxSection.Items[Index];
        SetPiece(SecItem, U, 2, Piece(SCTCode, U, 2));

        FUpdatingGrid := TRUE;
        lbxSection.Items[Index] := SecItem;
        lbxSection.Checked[Index] := True;
        if plIEN <> '' then
        begin
          SCTPar := Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 3) + U + Piece(SCTCode, U, 2);
          UpdateProblem(plIEN, '', SCTPar);
          PLUpdated := True;
        end;
        FUpdatingGrid := FALSE;
      end
      else
      begin
        lbxSection.Checked[Index] := False;
        exit;
      end;
    end
    else if (Piece(Encounter.GetICDVersion, U, 1) = 'ICD') and
      ((Pos('ICD-10', Piece(lbxSection.Items[Index], U, 2)) > 0) or (Piece(lbxSection.Items[Index], U, 6)='10D')) then
    begin
      // Attempting to add an ICD10 diagnosis code to an ICD9 encounter
      InfoBox(TX_INV_ICD10_DX, TC_INV_ICD10_DX, MB_ICONERROR or MB_OK);
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
  if ckbDiagProb.Checked then
     PLUpdated := True;
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
  with lstRenameMe do for i := 0 to Items.Count - 1 do
  begin
    ADiagnosis := TPCEDiag(Objects[i]);
    dxCode :=  ADiagnosis.Code;
    dxName :=  ADiagnosis.Narrative;
    if BAPCEDiagList.Count = 0 then
       UBAGlobals.BAPCEDiagList.Add(U + DX_ENCOUNTER_LIST_TXT);
    UBAGlobals.BAPCEDiagList.Add(dxCode + U + dxName);
  end;
end;

procedure TfrmDiagnoses.GetSCTforICD(ADiagnosis: TPCEDiag);
var
  Code, msg, ICDDescription: String;
begin
  // look-up SNOMED CT
  if Pos('ICD-10-CM', ADiagnosis.Narrative) > 0 then
    ICDDescription := ADiagnosis.Narrative
  else
    ICDDescription := ADiagnosis.Narrative + ' (' + Piece(Encounter.GetICDVersion, U, 2) + #32 + ADiagnosis.Code + ')';
  msg := TX_ICD_LACKS_SCT_CODE + CRLF + CRLF + ICDDescription;
  LexiconLookup(Code, LX_SCT, 0, False, '', msg);
  if (Code = '') then
  begin
    ckbDiagProb.Checked := False;
  end
  else
  begin
    ADiagnosis.Narrative := Piece(Code, U, 2);
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

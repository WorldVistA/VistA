unit fImmunization;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager, fVimm, rvimm;

type
  TfrmImmunizations = class(TfrmPCEBaseMain)
    btnAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnOtherClick(Sender: TObject);
    procedure btnOtherExit(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject); override;
    procedure btnCancelClick(Sender: TObject);
  private
    procedure setDiagnosisList(delimitedText: string; var povList: TStringList);
    procedure setProcedureList(delimitedText: string; var cptList: TStringList);
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
//    procedure FormatVimmInputs(Grid: boolean);
    procedure processVimm;
//    procedure ChangeProvider;
  end;

var
  frmImmunizations: TfrmImmunizations;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, uCore, uConst, uMisc;


procedure TfrmImmunizations.btnAddClick(Sender: TObject);
var
i: integer;
APCEItem: TPCEImm;
vimmData: TVimmResult;
begin
  inherited;
  FormatVimmInputs(false, false);
  uvimmInputs.DataList := TStringList.Create;
  try
    for i := 0 to lstCaptionList.Items.Count-1 do
      if lstCaptionList.Objects[i] is TPCEImm then
      begin
        APCEItem := TPCEImm(lstCaptionList.Objects[i]);
        if not assigned(APCEItem) then continue;
        vimmData := findVimmResultsByDelimitedStr(APCEItem.delimitedStrTxt, APCEItem.delimitedStr1Txt,
                    APCEItem.delimitedStr2Txt);
        if vimmData.documType = '' then
          begin
            if uEncPCEData.VisitCategory = 'E' then vimmData.documType := 'Historical'
            else vimmData.documType := 'Administered';
          end;
        uVimmInputs.DataList.AddObject('DATA' + U + vimmData.id, vimmData);
      end;
    uVimmInputs.fromCover := false;
    processVimm;
  finally
     clearResults;
     clearInputs;
  end;
end;

procedure TfrmImmunizations.btnCancelClick(Sender: TObject);
begin
  inherited;
  clearResults;
  clearInputs;
end;

procedure TfrmImmunizations.btnOKClick(Sender: TObject);
begin
  inherited;
  clearResults;
  clearInputs;
end;

procedure TfrmImmunizations.btnOtherClick(Sender: TObject);
begin
//  inherited;
end;

procedure TfrmImmunizations.btnOtherExit(Sender: TObject);
begin
////  inherited;
end;

procedure TfrmImmunizations.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_ImmNm;
  FPCEListCodesProc := ListImmunizCodes;
  FPCEItemClass := TPCEImm;
  FPCECode := 'IMM';
  self.btnRemove.Visible := false;
  self.btnSelectAll.Visible := false;
end;

procedure TfrmImmunizations.FormPaint(Sender: TObject);
begin
inherited;
//  if ckbContra.Focused = True then
//  begin
//    frmImmunizations.Canvas.Pen.Width := 1;
//    frmImmunizations.Canvas.Pen.Style := psDot;
//    frmImmunizations.Canvas.MoveTo(lblContra.Left - 2,lblContra.Top - 1);
//    frmImmunizations.Canvas.LineTo(lblContra.Left + lblContra.Width + 2,lblContra.Top - 1);
//    frmImmunizations.Canvas.LineTo(lblContra.Left + lblContra.Width + 2,lblContra.Top + lblContra.Height);
//    frmImmunizations.Canvas.LineTo(lblContra.Left - 2,lblContra.Top + lblContra.Height);
//    frmImmunizations.Canvas.LineTo(lblContra.Left - 2,lblContra.Top - 1);
//  end;
end;

procedure TfrmImmunizations.processVimm;
var
  resultList: TStringList;
  i, idx: Integer;
  str, code: String;
  data: TVimmResult;
  imm: TPCEImm;
  povList, cptList: TStringList;
  codesList, tempList: TStrings;

  procedure removeAll;
  begin
    lstCaptionList.SelectAll;
    btnRemoveClick(lstCaptionList);
  end;

  function finditem(data: TVimmResult): Integer;
  var
  i: integer;
  APCEItem: TPCEImm;
  begin
    result := -1;
    for i := 0 to lstCaptionList.Items.count -1 do
      begin
        if lstCaptionList.Objects[i] is TPCEImm then
        begin
          APCEItem := TPCEImm(lstCaptionList.Objects[i]);
          if APCEItem.Narrative <> data.name then continue;
          if Pieces(APCEItem.delimitedStrTxt, U, 1, 2) = Pieces(data.DelimitedStr, u, 1, 2) then
            begin
              result := i;
              break;
            end;
        end;
      end;
  end;

  function removeOld(resultList: TStringList; var immList: TStrings; var cptList: TStringList; var povList: TStringList): boolean;
  var
  c, r: integer;
  APCEItem: TPCEImm;
  tmpList: TStrings;
  found: boolean;
  data: TVimmResult;
  delStr, code: string;
  begin
    tmpList := TStringList.Create;
    try
      for c := 0 to lstCaptionList.Items.Count-1 do
        if lstCaptionList.Objects[c] is TPCEImm then
        begin
          APCEItem := TPCEImm(lstCaptionList.Objects[c]);
          found := false;
          if assigned(APCEItem) then
          begin
            for r := 0 to resultList.Count - 1 do
            begin
              data := TVimmResult(resultList.Objects[r]);
              if Pieces(APCEItem.delimitedStrTxt, U, 1, 2) = Pieces(data.DelimitedStr, u, 1, 2) then
                begin
                  if pos('ICR', Piece(data.DelimitedStr, U, 1)) > 0  then
                  begin
                    if CompareText(Piece(APCEItem.delimitedStrTxt, U, 5), Piece(data.DelimitedStr, u, 5)) = 0 then
                    begin
                      found := true;
                      break;
                    end;
                  end
                  else
                  begin
                    found := true;
                    break;
                  end;
                end;
            end;
            if not found then tmpList.Add(IntToStr(c));
          end;
        end;
      Result := (tmpList.Count > 0);
      if Result then
      begin
        lstCaptionList.ClearSelection;
        for r := 0 to tmpList.Count - 1 do
          begin
            c := StrToInt(tmpList.Strings[r]);
            if lstCaptionList.Objects[c] is TPCEImm then
            begin
              delStr := TPCEImm(lstCaptionList.Objects[c]).delimitedStrTxt;
              code := Piece(delStr, U, 1);
              code := StripAllExcept(code, UpperCaseLetters) + '-';
              setPiece(delStr, U, 1, code);
              immList.Add(delStr);
            end;
            lstCaptionList.Items[c].Selected  := true;
          end;
        btnRemoveClick(lstCaptionList);
      end;
    finally
      FreeAndNil(tmpList);
    end;
  end;

begin
  resultList := TStringList.Create;
  str := '';
  povList := TStringList.Create;
  cptList := TStringList.Create;
  codesList := TStringList.Create;
  tempList := TStringList.Create;
  try
    if performVimm(resultList, false) = false then
      Exit;
    frmEncounterFrame.getCodesList(tempList);
    codesList.AddStrings(tempList);
    tempList.Clear;

    if resultList.Count = 0 then
    begin
      if lstCaptionList.Items.Count > 0 then
      begin
        for idx := 0 to lstCaptionList.Items.Count - 1 do
          if lstCaptionList.Objects[idx] is TPCEImm then          
          begin
            str := TPCEImm(lstCaptionList.Objects[idx]).delimitedStrTxt;
            code := Piece(str, U, 1);
            code := StripAllExcept(code, UpperCaseLetters) + '-';
            setPiece(str, U, 1, code);
            codesList.Add(str);
          end;
        removeAll;
        ShowMessage('Please review the diagnosis and procedure tabs for accuracy');
      end;
    end
    else if resultList.Count > 0 then
    begin
      for i := 0 to resultList.Count - 1 do
      begin
        data := TVimmResult(resultList.Objects[i]);
        idx := finditem(data);
        if idx > -1 then
        begin
          if lstCaptionList.Objects[idx] is TPCEImm then
          begin
            TPCEImm(lstCaptionList.Objects[idx]).delimitedStrTxt := data.DelimitedStr;
            TPCEImm(lstCaptionList.Objects[idx]).delimitedStr1Txt := data.DelimitedStr2;
            TPCEImm(lstCaptionList.Objects[idx]).delimitedStr2Txt := data.DelimitedStr3;
            TPCEImm(lstCaptionList.Objects[idx]).series := data.getSeriesFromString;
            TPCEImm(lstCaptionList.Objects[idx]).Contraindicated := data.isContraindicated;
            TPCEImm(lstCaptionList.Objects[idx]).Refused := data.isRefused;
            if Pos('IMM', Piece(data.DelimitedStr, U, 1)) > 0 then
              codesList.Add(data.DelimitedStr);
          end;
        end
        else
        begin
          imm := TPCEImm.Create(data);
          codesList.Add(imm.delimitedStrTxt);
          lstCaptionList.AddObject(imm.Narrative, imm);
          if data.diagnosisDelimitedStr <> '' then
            begin
              setDiagnosisList(data.diagnosisDelimitedStr, povList);
              codesList.Add(data.diagnosisDelimitedStr);
            end;
          if data.procedureDelimitedStr <> '' then
            begin
              setProcedureList(data.procedureDelimitedStr, cptList);
              codesList.Add(data.procedureDelimitedStr);
            end;
        end;
      end;
    end;

    if removeOld(resultList, codesList, cptList, povList) then
      ShowMessage('Please review the diagnosis and procedure tabs for accuracy');

    lstCaptionList.Update;
    if (codesList <> nil) and (codesList.Count > 0) then
    begin
      getBillIngCodesList(codesList, IntToStr(uEncPCEData.VisitIEN), tempList);
      for idx := 0 to tempList.Count - 1 do
      begin
        str := tempList[idx];
        if pos('CPT',Piece(str, U, 1)) > 0 then
          begin
            if piece(str, U, 1) = 'CPT-' then
              cptList.Add(str)
            else
              setProcedureList(str, cptList);
          end;
        if pos('POV',Piece(str, U, 1)) > 0 then
          begin
            if piece(str, U, 1) = 'POV-' then
              povList.Add(str)
            else
              setDiagnosisList(str, povList);
          end;
      end;
    end;

    lstCaptionList.SelectAll;
    GridChanged;

    frmEncounterFrame.synchPCEVimmData(povList, cptList);
  finally
    FreeAndNil(tempList);
    FreeAndNil(resultList);
    FreeAndNil(codesList);
    KillObj(@povList, True);
    KillObj(@cptList, True);
  end;
end;

procedure TfrmImmunizations.setDiagnosisList(delimitedText: string;
  var povList: TStringList);
var
  pceDiag: TPCEDiag;
begin
  pceDiag := TPCEDiag.Create;
  pceDiag.SetFromString(delimitedText);
  povList.AddObject(delimitedText, pceDiag);
end;

procedure TfrmImmunizations.setProcedureList(delimitedText: string;
  var cptList: TStringList);
var
  pceProc: TPCEProc;
begin
  pceProc := TPCEProc.Create;
  if Piece(delimitedText, U, 6) = '' then
    SetPiece(delimitedText, U, 6, IntToStr(uEncPCEData.Providers.PCEProvider));
  pceProc.SetFromString(delimitedText);
  cptList.AddObject(delimitedText, pceProc);
end;

procedure TfrmImmunizations.UpdateNewItemStr(var x: string);
begin
  inherited;
  SetPiece(x, U, pnumImmSeries, NoPCEValue);
  SetPiece(x, U, pnumImmReaction, NoPCEValue);
  SetPiece(x, U, pnumImmRefused, '0');
  SetPiece(x, U, pnumImmContra, '0');
end;

procedure TfrmImmunizations.UpdateControls;
var
  ok, Contra, First: boolean;
  SameS, SameR, SameC: boolean;
  i: integer;
  Ser, React: string;
  Obj: TPCEImm;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
      if(ok) then
      begin
        First := TRUE;
        SameS := TRUE;
        SameR := TRUE;
        SameC := TRUE;
        Contra := FALSE;
        Ser := NoPCEValue;
        React := NoPCEValue;
        for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected and (lstCaptionList.Objects[i] is TPCEImm) then
          begin
            Obj := TPCEImm(lstCaptionList.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Contra := Obj.Contraindicated;
              Ser := Obj.Series;
              React := Obj.Reaction;
            end
            else
            begin
              if(SameS) then
                SameS := (Ser = Obj.Series);
              if(SameR) then
                SameR := (React = Obj.Reaction);
              if(SameC) then
                SameC := (Contra = Obj.Contraindicated);
            end;
          end;
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmImmunizations);

end.

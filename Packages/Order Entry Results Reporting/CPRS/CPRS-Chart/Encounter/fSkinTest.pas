unit fSkinTest;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Buttons,
  ORCtrls,
  fPCEBaseMain,
  VA508AccessibilityManager,
  U508Button;

type
  TfrmSkinTests = class(TfrmPCEBaseMain)
    btnSkinEdit: U508Button.TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSkinEditClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject); override;
    procedure btnCancelClick(Sender: TObject);
  private
    procedure processVimm;
    procedure setDiagnosisList(delimitedText: string; var povList: TStringList);
    procedure setProcedureList(delimitedText: string; var cptList: TStringList);
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure Loaded; override;
  end;

implementation

{$R *.DFM}

uses
  System.SysUtils,
  VA508AccessibilityRouter,
  ORFn,
  uConst,
  uMisc,
  fEncounterFrame,
  uPCE,
  rPCE,
  fVimm,
  rvimm;

procedure TfrmSkinTests.btnCancelClick(Sender: TObject);
begin
  inherited;
  clearResults;
  clearInputs;
end;

procedure TfrmSkinTests.btnOKClick(Sender: TObject);
begin
  inherited;
  clearResults;
  clearInputs;
end;

procedure TfrmSkinTests.btnSkinEditClick(Sender: TObject);
var
  i: integer;
  APCEItem: TPCESkin;
  vimmData: TVimmResult;
begin
  inherited;
  FormatVimmInputs(false, true);
  uvimmInputs.DataList := TStringList.Create;
  try
    for i := 0 to lstCaptionList.Items.Count - 1 do
    begin
      if lstCaptionList.Objects[i] is TPCESkin then
      begin
        APCEItem := TPCESkin(lstCaptionList.Objects[i]);
        if not assigned(APCEItem) then continue;
        vimmData := findVimmResultsByDelimitedStr(APCEItem.delimitedStrTxt,
          APCEItem.delimitedStr1Txt, '');
        if uvimmInputs.selectionType = 'historical' then
            vimmData.documType := 'Historical';

        uvimmInputs.DataList.AddObject('DATA' + U + vimmData.id, vimmData);
      end;
    end;
    uvimmInputs.fromCover := false;
    processVimm;
  finally
    clearResults;
    clearInputs;
  end;
end;

procedure TfrmSkinTests.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_SkinNm;
  FPCEListCodesProc := ListSkinCodes;
  FPCEItemClass := TPCESkin;
  FPCECode := 'SK';
  self.btnRemove.Visible := false;
  self.btnSelectAll.Visible := false;
  self.edtComment.Visible := false;
  pnlMain.Visible := false;
  self.lblSection.Visible := false;
  self.lblList.Visible := false;
end;

procedure TfrmSkinTests.Loaded;
begin
  AutoSizeDisabled := true;
  inherited;
end;

procedure TfrmSkinTests.processVimm;

  function finditem(data: TVimmResult): integer;
  var
    i: integer;
    APCEItem: TPCESkin;
  begin
    result := -1;
    for i := 0 to lstCaptionList.Items.Count - 1 do
    begin
      if lstCaptionList.Objects[i] is TPCESkin then
      begin
        APCEItem := TPCESkin(lstCaptionList.Objects[i]);
        if APCEItem.Narrative <> data.name then continue;
        if Piece(APCEItem.delimitedStrTxt, U, 2) = Piece(data.DelimitedStr, U, 2)
        then
        begin
          result := i;
          break;
        end;
      end;
    end;
  end;

  procedure removeAll;
  begin
    lstCaptionList.SelectAll;
    btnRemoveClick(lstCaptionList);
  end;

  function removeOld(resultList: TStringList; codeslist: TStrings): boolean;
  var
    c, r: integer;
    APCEItem: TPCESkin;
    tempList: TStrings;
    found: boolean;
    data: TVimmResult;
    delStr, code: string;
  begin
    tempList := TStringList.Create;
    try
      for c := 0 to lstCaptionList.Items.Count - 1 do
      begin
        if lstCaptionList.Objects[c] is TPCESkin then
        begin
          APCEItem := TPCESkin(lstCaptionList.Objects[c]);
          found := false;
          if assigned(APCEItem) then
          begin
            for r := 0 to resultList.Count - 1 do
            begin
              data := TVimmResult(resultList.Objects[r]);
              if Pieces(APCEItem.delimitedStrTxt, U, 1, 2)
                = Pieces(data.DelimitedStr, U, 1, 2) then
              begin
                found := true;
                break;
              end;
            end;
            if not found then tempList.Add(IntToStr(c));
          end;
        end;
      end;
      result := (tempList.Count > 0);
      if result then
      begin
        lstCaptionList.ClearSelection;
        for r := 0 to tempList.Count - 1 do
        begin
          c := StrToInt(tempList.Strings[r]);
          if lstCaptionList.Objects[c] is TPCESkin then
          begin
            delStr := TPCESkin(lstCaptionList.Objects[c]).delimitedStrTxt;
            code := Piece(delStr, U, 1);
            code := StripAllExcept(code, UpperCaseLetters) + '-';
            setPiece(delStr, U, 1, code);
            codeslist.Add(delStr);
          end;
          lstCaptionList.Items[c].Selected := true;
        end;
        btnRemoveClick(lstCaptionList);
      end;
    finally
      FreeAndNil(tempList);
    end;
  end;

var
  resultList: TStringList;
  i, idx: integer;
  str, code: string;
  data: TVimmResult;
  skin: TPCESkin;
  povList, cptList: TStringList;
  codeslist, tempList: TStrings;
begin
  resultList := nil;
  povList := nil;
  cptList := nil;
  codeslist := nil;
  str := '';
  try
    resultList := TStringList.Create;
    povList := TStringList.Create;
    cptList := TStringList.Create;
    codeslist := TStringList.Create;
    tempList := TStringList.Create;
    if performVimm(resultList, false) = false then Exit;
    frmEncounterFrame.getCodesList(codeslist);
    if resultList.Count = 0 then
    begin
      for idx := 0 to lstCaptionList.Items.Count - 1 do
      begin
        if lstCaptionList.Objects[idx] is TPCESkin then
        begin
          str := TPCESkin(lstCaptionList.Objects[idx]).delimitedStrTxt;
          code := Piece(str, U, 1);
          code := StripAllExcept(code, UpperCaseLetters) + '-';
          setPiece(str, U, 1, code);
          codeslist.Add(str);
        end;
      end;
      removeAll;
      ShowMessage
        ('Please review the diagnoses and procedure tabs for accuracy');
    end
    else if resultList.Count > 0 then
    begin
      for i := 0 to resultList.Count - 1 do
      begin
        data := TVimmResult(resultList.Objects[i]);
        idx := finditem(data);
        if idx > -1 then
        begin
          if lstCaptionList.Objects[idx] is TPCESkin then
          begin
            TPCESkin(lstCaptionList.Objects[idx]).delimitedStrTxt :=
              data.DelimitedStr;
            TPCESkin(lstCaptionList.Objects[idx]).delimitedStr1Txt :=
              data.DelimitedStr2;
            TPCESkin(lstCaptionList.Objects[idx]).Results :=
              data.getReadingResult;
            TPCESkin(lstCaptionList.Objects[idx]).Reading :=
              data.getReadingValue;
            if pos('SK', Piece(data.DelimitedStr, U, 1)) > 0 then
                codeslist.Add(data.DelimitedStr);
          end;
        end else begin
          skin := TPCESkin.Create(data);
          codeslist.Add(skin.delimitedStrTxt);
          lstCaptionList.AddObject(skin.Narrative, skin);
          if data.diagnosisDelimitedStr <> '' then
          begin
            setDiagnosisList(data.diagnosisDelimitedStr, povList);
            codeslist.Add(data.diagnosisDelimitedStr);
          end;
          if data.procedureDelimitedStr <> '' then
          begin
            setProcedureList(data.procedureDelimitedStr, cptList);;
            codeslist.Add(data.procedureDelimitedStr);
          end;
        end;
      end;
    end;

    if removeOld(resultList, codeslist) then
        ShowMessage
        ('Please review the diagnosis and procedure tabs for accuracy');
    lstCaptionList.Update;
    if (codeslist <> nil) and (codeslist.Count > 0) then
    begin
      getBillIngCodesList(codeslist, IntToStr(uEncPCEData.VisitIEN), tempList);
      for idx := 0 to tempList.Count - 1 do
      begin
        str := tempList[idx];
        if pos('CPT', Piece(str, U, 1)) > 0 then
        begin
          if Piece(str, U, 1) = 'CPT-' then cptList.Add(str)
          else setProcedureList(str, cptList);
        end;
        if pos('POV', Piece(str, U, 1)) > 0 then
        begin
          if Piece(str, U, 1) = 'POV-' then povList.Add(str)
          else setDiagnosisList(str, povList);
        end;
      end;
    end;
    lstCaptionList.SelectAll;
    GridChanged;

    frmEncounterFrame.synchPCEVimmData(povList, cptList);

  finally
    FreeAndNil(tempList);
    FreeAndNil(codeslist);
    cptList.OwnsObjects := true;
    FreeAndNil(cptList);
    povList.OwnsObjects := true;
    FreeAndNil(povList);
    FreeAndNil(resultList);
  end;
end;

procedure TfrmSkinTests.setDiagnosisList(delimitedText: string;
  var povList: TStringList);
var
  pceDiag: TPCEDiag;
begin
  pceDiag := TPCEDiag.Create;
  pceDiag.SetFromString(delimitedText);
  povList.AddObject(delimitedText, pceDiag);
end;

procedure TfrmSkinTests.setProcedureList(delimitedText: string;
  var cptList: TStringList);
var
  pceProc: TPCEProc;
begin
  pceProc := TPCEProc.Create;
  if Piece(delimitedText, U, 6) = '' then
      setPiece(delimitedText, U, 6,
      IntToStr(uEncPCEData.Providers.PCEProvider));
  pceProc.SetFromString(delimitedText);
  cptList.AddObject(delimitedText, pceProc);
end;

procedure TfrmSkinTests.UpdateNewItemStr(var x: string);
begin
  setPiece(x, U, pnumSkinResults, NoPCEValue);
  setPiece(x, U, pnumSkinReading, '');
end;

procedure TfrmSkinTests.UpdateControls;
var
  ok, First: boolean;
  SameRes, SameRead: boolean;
  i: integer;
  Res: string;
  Read: string;
  Obj: TPCESkin;
begin
  inherited;
  if (NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
      if (ok) then
      begin
        First := true;
        SameRes := true;
        SameRead := true;
        Res := NoPCEValue;
        read := '0';
        for i := 0 to lstCaptionList.Items.Count - 1 do
        begin
          if lstCaptionList.Items[i].Selected and
            (lstCaptionList.Objects[i] is TPCESkin) then
          begin
            Obj := TPCESkin(lstCaptionList.Objects[i]);
            if (First) then
            begin
              First := false;
              Res := Obj.Results;
              read := Obj.Reading;
            end else begin
              if (SameRes) then SameRes := (Res = Obj.Results);
              if (SameRead) then
              begin
                SameRead := (read = Obj.Reading);
              end;
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

SpecifyFormIsNotADialog(TfrmSkinTests);

end.

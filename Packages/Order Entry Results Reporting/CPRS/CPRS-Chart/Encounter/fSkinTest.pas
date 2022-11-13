unit fSkinTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, ORCtrls, StdCtrls, ComCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, rCore, fPCEBaseMain, VA508AccessibilityManager, fVimm, rvimm;

type
  TfrmSkinTests = class(TfrmPCEBaseMain)
    btnSkinEdit: TButton;
//    procedure EdtReadingChange(Sender: TObject);
    procedure edtDtReadChange(Sender: TObject);
    procedure edtDTGivenChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure UpDnReadingChanging(Sender: TObject;
//      var AllowChange: Boolean);
    procedure lstCaptionListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
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
  public
  end;

var
  frmSkinTests: TfrmSkinTests;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, uCore, uConst, uMisc;

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
    for i := 0 to lstCaptionList.Items.Count-1 do
      if lstCaptionList.Objects[i] is TPCESkin then
      begin
        APCEItem := TPCESkin(lstCaptionList.Objects[i]);
        if not assigned(APCEItem) then continue;
        vimmData := findVimmResultsByDelimitedStr(APCEItem.delimitedStrTxt, APCEItem.delimitedStr1Txt, '');
        if uVimmInputs.selectionType = 'historical' then vimmData.documType := 'Historical';

        uVimmInputs.DataList.AddObject('DATA' + U + vimmData.id, vimmData);
      end;
    uVimmInputs.fromCover := false;
    processVimm;
  finally
     clearResults;
     clearInputs;
  end;
end;

{///////////////////////////////////////////////////////////////////////////////
//Name:procedure TfrmSkinTests.EdtReadingChange(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:Change the reading assigned to the skin test.
///////////////////////////////////////////////////////////////////////////////}
//procedure TfrmSkinTests.EdtReadingChange(Sender: TObject);
//var
//  x, i: integer;
//
//begin
//  if(NotUpdating) then
//  begin
//    x := StrToIntDef(EdtReading.Text, 0);
//    for i := 0 to lstCaptionList.Items.Count-1 do
//      if(lstCaptionList.Items[i].Selected) then
//        TPCESkin(lstCaptionList.Objects[i]).Reading := x;
//
//    GridChanged;
//  end;
//end;

procedure TfrmSkinTests.edtDtReadChange(Sender: TObject);
begin
end;
(*
var
  DtRead: TFMDateTime;
  ASkinTest: TPCESkin;
begin
  inherited;
  if lstSkinSelect.ItemIndex < 0 then Exit;

  with lstSkinSelect do ASkinTest := TPCESkin(Items.Objects[ItemIndex]);
  DtRead := StrToFMDateTime(edtReading.text);
  with lstSkinSelect do if (ItemIndex > -1) then
  begin
    ASkinTest.DTRead := DTRead;
    Items[ItemIndex] := ASkinTest.ItemStr;
  end;
end;
*)

procedure TfrmSkinTests.edtDTGivenChange(Sender: TObject);
begin
end;
(*
var
  DtGiven: TFMDateTime;
  ASkinTest: TPCESkin;
begin
  inherited;
  if lstSkinSelect.ItemIndex < 0 then Exit;

  with lstSkinSelect do ASkinTest := TPCESkin(Items.Objects[ItemIndex]);
  DtGiven := StrToFMDateTime(edtDTGiven.text);
  with lstSkinSelect do if (ItemIndex > -1) then
  begin
    ASkinTest.DTGiven := DTGIven;
    Items[ItemIndex] := ASkinTest.ItemStr;
  end;
end;
*)
(*
procedure TfrmSkinTests.CheckSkinRules;
begin
  //Results must be between 0 and 40
  if StrToInt(EdtReading.Text) < 0 then EdtReading.text := '0';
  if StrToInt(EdtReading.Text) > 40 then EdtReading.text := '40';

(*  //if reading >10, result must be "positive"
  if (StrToInt(EdtReading.Text) > 9) and
    (CompareText(Piece(cboSkinResults.items[cboSkinResults.itemindex],U,1),'P') <> 0) then
    begin
      if (Piece(cboSkinResults.items[cboSkinResults.itemindex],U,1) = '@') then    // not selected
      begin
        cboSkinResults.SelectById('P');
      end
      else
      begin
        Show508Message('If the reading is over 9, the results are required to be positive.');
        cboSkinResults.SelectById('P');
       end;
    end;
end;
*)

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
//  PCELoadORCombo(cboSkinResults);
end;

procedure TfrmSkinTests.lstCaptionListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  inherited;
//  If UpperCase(cboSkinResults.Text) = 'NO TAKE' then begin
//    cboReading.Visible := false;
////   EdtReading.Visible := False;
////   UpDnReading.Visible := False;
////   lblReading.Visible := False;
//  end else begin
//    cboReading.Visible := true;
////   EdtReading.Visible := True;
////   UpDnReading.Visible := True;
////   lblReading.Visible := True;
//  end;

end;

procedure TfrmSkinTests.processVimm;
var
  resultList: TStringList;
  i, idx: Integer;
  str, code: String;
  data: TVimmResult;
  skin: TPCESkin;
//  pceProc: TPCEProc;
//  pceDiag: TPCEDiag;
  povList, cptList: TStringList;
  codesList, tempList: TStrings;

  function finditem(data: TVimmResult): Integer;
  var
  i: integer;
  APCEItem: TPCESkin;
  begin
    result := -1;
    for i := 0 to lstCaptionList.Items.count -1 do
      begin
        if lstCaptionList.Objects[i] is TPCESkin then
        begin
          APCEItem := TPCESkin(lstCaptionList.Objects[i]);
          if APCEItem.Narrative <> data.name then continue;
          if Piece(ApceItem.delimitedStrTxt, U, 2) = Piece(data.DelimitedStr, u, 2) then
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
      for c := 0 to lstCaptionList.Items.Count-1 do
        if lstCaptionList.Objects[c] is TPCESkin then
        begin
          APCEItem := TPCESkin(lstCaptionList.Objects[c]);
          found := false;
          if assigned(APCEItem) then
          begin
            for r := 0 to resultList.Count - 1 do
              begin
                data := TVimmResult(resultList.Objects[r]);
                if Pieces(APCEItem.delimitedStrTxt, U, 1, 2) = Pieces(data.DelimitedStr, u, 1, 2) then
                  begin
                    found := true;
                    break;
                  end;
              end;
            if not found then tempList.Add(IntToStr(c));
          end;
        end;
      Result := (tempList.Count > 0);
      if Result then
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
              codesList.Add(delStr);
            end;
            lstCaptionList.Items[c].Selected  := true;
          end;
        btnRemoveClick(lstCaptionList);
      end;
    finally
      FreeAndNil(tempList);
    end;

  end;


begin
  resultList := TStringList.Create;
  povList := TStringList.Create;
  cptList := TStringList.Create;
  codesList := TStringList.Create;
  tempList := TStringList.Create;
  str := '';
  try
    if performVimm(resultList, false) = false then
      Exit;
    frmEncounterFrame.getCodesList(codesList);
    if resultList.Count = 0 then
      begin
        for idx := 0 to lstCaptionList.Items.Count - 1 do
          if lstCaptionList.Objects[idx] is TPCESkin then
          begin
            str := TPCESkin(lstCaptionList.Objects[idx]).delimitedStrTxt;
            code := Piece(str, U, 1);
            code := StripAllExcept(code, UpperCaseLetters) + '-';
            setPiece(str, U, 1, code);
            codesList.Add(str);
          end;
        removeAll;
        ShowMessage('Please review the diagnoses and procedure tabs for accuracy');
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
                TPCESkin(lstCaptionList.Objects[idx]).delimitedStrTxt := data.DelimitedStr;
                TPCESkin(lstCaptionList.Objects[idx]).delimitedStr1Txt := data.DelimitedStr2;
                TPCESkin(lstCaptionList.Objects[idx]).Results := data.getReadingResult;
                TPCESkin(lstCaptionList.Objects[idx]).Reading := data.getReadingValue;
                if pos('SK', Piece(data.DelimitedStr, U, 1)) > 0 then
                  codesList.Add(data.DelimitedStr);
              end;
          end
        else
          begin
            skin := TPCESkin.Create(data);
            codesList.Add(skin.delimitedStrTxt);
            lstCaptionList.AddObject(skin.Narrative, skin);
            if data.diagnosisDelimitedStr <> '' then
              begin
                setDiagnosisList(data.diagnosisDelimitedStr, povList);
                codesList.Add(data.diagnosisDelimitedStr);
              end;
            if data.procedureDelimitedStr <> '' then
              begin
                setProcedureList(data.procedureDelimitedStr, cptList);;
                codesList.Add(data.procedureDelimitedStr);
              end;
          end;
      end;
    end;

    if removeOld(resultList, codeslist) then
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
    SetPiece(delimitedText, U, 6, IntToStr(uEncPCEData.Providers.PCEProvider));
  pceProc.SetFromString(delimitedText);
  cptList.AddObject(delimitedText, pceProc);
end;

procedure TfrmSkinTests.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumSkinResults, NoPCEValue);
  SetPiece(x, U, pnumSkinReading, '');
//  SetPiece(x, U, pnumSkinDTRead);
//  SetPiece(x, U, pnumSkinDTGiven);
end;

procedure TfrmSkinTests.UpdateControls;
var
  ok, First: boolean;
  SameRes, SameRead: boolean;
//  objRead
  i: integer;
  Res: string;
//  Read: integer;
  Read: string;
  Obj: TPCESkin;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
//      lblSkinResults.Enabled := ok;
//      lblReading.Enabled := ok;
//      cboSkinResults.Enabled := ok;
//      cboReading.Enabled := ok;
//      EdtReading.Enabled := ok;
//      UpDnReading.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameRes := TRUE;
        SameRead := TRUE;
        Res := NoPCEValue;
//        objRead := false;
        Read := '0';
        for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected and (lstCaptionList.Objects[i] is TPCESkin) then
          begin
            Obj := TPCESkin(lstCaptionList.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Res := Obj.Results;
              Read := Obj.Reading;
//              objRead := true;
            end
            else
            begin
              if(SameRes) then
                SameRes := (Res = Obj.Results);
              if(SameRead) then
                begin
                  SameRead := (Read = Obj.Reading);
                end;
            end;
          end;
        end;
     
//        if(SameRes) then
//          cboSkinResults.SelectByID(Res)
//        else
//          cboSkinResults.Text := '';
        if(SameRead) then
        begin
//          if not objRead then cboReading.ItemIndex := 0
//          else
//            begin
//              idx := cboReading.Items.IndexOf(Read);
//              cboReading.ItemIndex := idx;
//            end;
//          UpDnReading.Position := Read;
//          EdtReading.Text := IntToStr(Read);
//          EdtReading.SelStart := length(EdtReading.Text);
        end
        else
        begin
//          cboReading.ItemIndex := -1;
//          UpDnReading.Position := 0;
//          EdtReading.Text := '';
        end;
      end
      else
      begin
//        cboSkinResults.Text := '';
////        EdtReading.Text := '';
//        cboReading.ItemIndex := -1;
//        cboReading.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

//procedure TfrmSkinTests.UpDnReadingChanging(Sender: TObject;
//  var AllowChange: Boolean);
//begin
//  inherited;
//  if(UpDnReading.Position = 0) then
//    EdtReadingChange(Sender);
//end;

initialization
  SpecifyFormIsNotADialog(TfrmSkinTests);

end.
  
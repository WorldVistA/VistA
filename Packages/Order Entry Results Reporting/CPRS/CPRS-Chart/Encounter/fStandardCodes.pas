unit fStandardCodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, fPCEBaseMain, ORCtrls, ORFn,
  VA508AccessibilityManager, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  ORStaticText, ORClasses, uPCE;

type
  TfrmStandardCodes = class(TfrmPCEBaseMain)
    lblMag: TLabel;
    edtMag: TCaptionEdit;
    lblUCUM: TLabel;
    btnTaxonomy: TButton;
    pnlRight: TPanel;
    lbxCodes: TORListBox;
    lblCodes: TLabel;
    btnAdd: TButton;
    ckbAdd2PL: TCheckBox;
    lblTaxonomies: TORStaticText;
    btnPL: TButton;
    lblUCUM2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject); override;
    procedure btnTaxonomyClick(Sender: TObject);
    procedure btnPLClick(Sender: TObject);
    procedure lbSectionChange(Sender: TObject);
    procedure lbxCodesChange(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lbxCodesDblClick(Sender: TObject);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
    procedure ckbAdd2PLClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtMagEnter(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
    procedure clbListClick(Sender: TObject);
    procedure lbSectionClick(Sender: TObject);
  private
    FTaxonomies: boolean;
    FProblemList: boolean;
    FProblems: TORStringList;
    FTaxIEN: integer;
    procedure showMagnitude(active: boolean);
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateControls; override;
    procedure UpdateNewItemStr(var x: string); override;
    function NotOnPL(index: integer): boolean;
  end;

var
  frmStandardCodes: TfrmStandardCodes;

implementation

{$R *.dfm}

uses fEncounterFrame, rPCE, rCore, uProbs, uCore, rProbs, uMisc;

procedure ListStandardCodes(Dest: TStrings; SectionIndex: Integer);
begin
// keep routine blank
end;

procedure TfrmStandardCodes.btnAddClick(Sender: TObject);
var
  i, j: integer;
  x,code,id,narr,cat: string;
  item,item2: TStandardCode;
  ok: boolean;
begin
  inherited;
  if lbxCodes.SelCount < 1 then exit;
  for i := 0 to lbxCodes.Count-1 do
  begin
    if lbxCodes.Selected[i] then
    begin
      x := lbxCodes.Items[i];
      code := piece(x,U,2);
      cat := piece(x,U,1);
      narr := piece(x,U,3);
      id := 'SC';
      ok := true;
      item := TStandardCode.Create;
      try
        item.SetFromString(id+U+code+U+U+narr+U+cat);
        item.taxId := FTaxIEN;
        x := item.ItemStr;
        for j := 0 to lstCaptionList.Items.Count-1 do
        begin
          item2 := lstCaptionList.Objects[j] as TStandardCode;
          if x = item2.ItemStr then
          begin
            showmessage('"' + cat + ' ' + code + '  ' + narr + '" has already been added.');
            ok := False;
            break;
          end;
        end;
        if ok then
        begin
          lstCaptionList.Add(item.ItemStr, item);
        end;
      finally
        if not ok then
          item.Free;
      end;
    end;
  end;
end;

procedure TfrmStandardCodes.btnOKClick(Sender: TObject);
//var
//  i: integer;
//  code: TStandardCode;
//  aList: TStringList;
//  PLPt: TPLPt;

begin
  inherited;
//  for i := 0 to lstCaptionList.Items.Count-1 do
//  begin
//    code := TStandardCode(lstCaptionList.Objects[i]);
//    if code.Add2PL and NotOnPL(i) then
//    begin
//      aList := TStringList.Create;
//      try
//        InitPt(aList,Patient.DFN);
//        PLPt := TPLPt.create(Alist);
//        aList.Clear;
//        AddSave(aList, PLPt.GetGMPDFN(Patient.DFN, Patient.Name),
//           uEncPCEData.Prov ProviderID, PLPt.ptVAMC, ProbRec.FilerObject, FSearchString);
//      finally
//        aList.Free;
//      end;
//    end;
//  end;
end;

procedure TfrmStandardCodes.btnPLClick(Sender: TObject);
begin
  inherited;
  if FTaxonomies then
  begin
    lblTaxonomies.Visible := false;
    lbSection.Visible := false;
    btnTaxonomy.Enabled := True;
    FTaxonomies := False;
  end;
  if not FProblemList then
  begin
    lbxCodes.Items.Assign(FProblems);
    lblCodes.Caption := 'Problem List';
    lblCodes.Visible := true;
    lbxCodes.Visible := true;
    btnAdd.Visible := true;
    btnAdd.Enabled := false;
    btnPL.Enabled := False;
    FProblemList := True;
  end;
end;

procedure TfrmStandardCodes.btnSelectAllClick(Sender: TObject);
begin
  inherited;
  UpdateControls;
end;

procedure TfrmStandardCodes.btnTaxonomyClick(Sender: TObject);
begin
  if FProblemList then
  begin
    btnPL.Enabled := True;
    FProblemList := False;
  end;
  if not FTaxonomies then
  begin
    lbxCodes.Clear;
    RemTaxWCodes(lbSection.Items);
    lblTaxonomies.Visible := true;
    lblCodes.Caption := 'Standard Codes';
    lblCodes.Visible := true;
    lbSection.Visible := true;
    lbxCodes.Visible := true;
    btnAdd.Visible := true;
    btnAdd.Enabled := false;
    btnTaxonomy.Enabled := False;
    FTaxonomies := True;
  end;
end;

procedure TfrmStandardCodes.ckbAdd2PLClick(Sender: TObject);
var
  i: integer;
  code: TStandardCode;
  add: boolean;

begin
  inherited;
  if NotUpdating then
  begin
    add := (ckbAdd2PL.State in [cbChecked, cbGrayed]);
    for i := 0 to lstCaptionList.Items.Count-1 do
    begin
      if lstCaptionList.items[i].Selected and NotOnPL(i) then
      begin
        code := TStandardCode(lstCaptionList.Objects[i]);
        code.Add2PL := add;
        lstCaptionList.Strings[i] := code.ItemStr;
      end;
    end;
  end;
end;

procedure TfrmStandardCodes.clbListClick(Sender: TObject);
begin
  inherited;
  btnAdd.Enabled := (lbxCodes.SelCount > 0);
end;

procedure TfrmStandardCodes.edtMagChange(Sender: TObject);
var
 item: TStandardCode;

begin
  inherited;
  if (GridIndex<0) or (lstCaptionList.SelCount <> 1) then exit;
  item := lstCaptionList.Objects[GridIndex] as TStandardCode;
  item.Magnitude := edtMag.Text;
end;

procedure TfrmStandardCodes.edtMagEnter(Sender: TObject);
begin
  inherited;
  ParseMagUCUM4StandardCodes(edtMag);
end;

procedure TfrmStandardCodes.edtMagExit(Sender: TObject);
begin
  inherited;
  PostValidateMag(edtMag);
end;

procedure TfrmStandardCodes.edtMagKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  ValidateMagKeyPress(Sender, Key);
end;

procedure TfrmStandardCodes.FormActivate(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmStandardCodes.FormCreate(Sender: TObject);

  procedure LoadPL;
  var
    i, p1, p2: integer;
    list: TStringList;
    Date: TFMDateTime;
    x, code, txt: string;

  begin
    list := TStringList.Create;
    try
      if (uEncPCEData.DateTime <= 0) or CharInSet(uEncPCEData.VisitCategory, ['E','H']) then
        date := FMNow
      else
        date := uEncPCEData.DateTime;
      ProblemList(list, Patient.DFN, 'A', Date);
      list.Delete(0);
      for i := 0 to list.Count-1 do
      begin
        x := piece(list[i],U,3);
        p1 := pos('(SCT ', x);
        if P1 > 0 then
        begin
          p2 := pos(')', x, p1);
          if p2 > 0 then
          begin
            code := copy(x,p1+5,p2-p1-5);
            txt := trim(copy(x, 1, p1-1));
            FProblems.Add('SCT' + U + code + U + txt);
          end;
        end;
      end;
      FProblems.SortByPiece(3);
    finally
      list.Free;
    end;
  end;

begin
  inherited;
  FTabName := CT_STDNm;
  FPCEListCodesProc := ListStandardCodes;
  FPCEItemClass := TStandardCode;
  FPCECode := 'SC';
  FTaxonomies := False;
  FProblems := TORStringList.Create;
  LoadPL;
  ParseMagUCUM4StandardCodes(edtMag);
end;

procedure TfrmStandardCodes.FormDestroy(Sender: TObject);
begin
  FProblems.Free;
  inherited;
end;

procedure TfrmStandardCodes.FormShow(Sender: TObject);
begin
  inherited;
  UpdateControls;
end;

procedure TfrmStandardCodes.lbSectionChange(Sender: TObject);
var
  x: string;
  date: TFMDateTime;
begin
  inherited;
  FTaxIEN := -1;
  if FTaxonomies then
  begin
    lbxCodes.Clear;
    btnAdd.Enabled := false;
    if (lbSection.ItemIndex >= 0) then
    begin
      x := lbSection.Items[lbSection.ItemIndex];
      if CharInSet(uEncPCEData.VisitCategory,['E','H']) then
        date := FMNow
      else
        date := uEncPCEData.VisitDateTime;
      TaxCodes(lbxCodes.Items, StrToIntDef(piece(x,U,1),0), date);
      FTaxIen := StrToIntDef(Piece(x, U, 1), -1);
    end;
  end;
end;

procedure TfrmStandardCodes.lbSectionClick(Sender: TObject);
begin
  inherited;
  btnAdd.Enabled := false;
end;

procedure TfrmStandardCodes.lbxCodesChange(Sender: TObject);
begin
  inherited;
  btnAdd.Enabled := (lbxCodes.SelCount > 0);
end;

procedure TfrmStandardCodes.lbxCodesDblClick(Sender: TObject);
begin
  inherited;
  btnAddClick(Sender);
end;

function TfrmStandardCodes.NotOnPL(index: integer): boolean;
var
  sct: TStandardCode;

begin
  sct := TStandardCode(lstCaptionList.Objects[index]);
  Result := FProblems.IndexOfPiece(sct.Code, U, 2) < 0;
end;

procedure TfrmStandardCodes.showMagnitude(active: boolean);
begin
  self.lblMag.Visible := active;
  self.lblUCUM.Visible := active;
  self.lblUCUM2.Visible := active;
  self.edtMag.Visible := active;
end;

procedure TfrmStandardCodes.UpdateControls;
var
  ok: boolean;
  ucum: string;
  ucumIEN, i, cnt, count: integer;
  Code: TStandardCode;

  function NonPLCount: integer;
  var
    i: integer;

  begin
    Result := 0;
    for i := 0 to lstCaptionList.Items.Count-1 do
    begin
      if lstCaptionList.Items[i].Selected then
      begin
        if NotOnPL(i) then
          inc(Result);
      end;
    end;
  end;

begin
  inherited UpdateControls;
  if NotUpdating then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount = 1);
      lblMag.Enabled := ok;
      lblUCUM.Enabled := ok;
      edtMag.Enabled := ok;
      count := NonPLCount;
      ckbAdd2PL.Enabled := (count > 0);
      if ok and (GridIndex > -1) then
      begin
        code := TStandardCode(lstCaptionList.Objects[GridIndex]);
        edtMag.Text := code.Magnitude;
        ucumIEN := StrToInt64Def(code.UCUMCode, 0);
        if (edtMag.Text <> '0') and (ucumIEN >0) then
          begin
            showMagnitude(true);
            ucum := GetUCUMText(ucumIEN);
            lblUCUM2.Caption := ucum;
          end
        else if code.taxId > -1 then
          begin
            if assigned(code.UCUMInfo) then
              code.UCUMCode := code.UCUMInfo.Code;
            ParseMagUCUMData(code.UCUMInfo, lblMag, edtMag, lblUCUM, lblUCUM2);
          end
        else showMagnitude(false);
        if ckbAdd2PL.Enabled then
          ckbAdd2PL.Checked := code.Add2PL
        else
          ckbAdd2PL.Checked := False;
      end
      else
      begin
        edtMag.Text := '';
        lblUCUM2.Caption := '';
      end;
      if btnAdd.Visible then
        btnAdd.Enabled := lbxCodes.SelCount > 0;
      if (lstCaptionList.SelCount > 1) then
      begin
        cnt := 0;
        for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected and
             TStandardCode(lstCaptionList.Objects[i]).Add2PL and
             NotOnPL(i) then
            inc(cnt);
        end;
        if cnt = 0 then
          ckbAdd2PL.Checked := False
        else
        if cnt = count then
          ckbAdd2PL.Checked := True
        else
          ckbAdd2PL.State := cbGrayed;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmStandardCodes.UpdateNewItemStr(var x: string);
var
  Tmp, Code, CSShort, CSLong: string;
  i, j, sp: integer;
  k: TCodingSystem;

begin
  inherited;
  Tmp := Piece(x, U, pnumNarrative);
  Code := '';
  CSShort := '';
  CSLong := '';
  j := 0;
  sp := 0;
  i := length(Tmp);
  if Tmp[i]=')' then
    j := i;
  while (i>0) and (Tmp[i]<>'(') do
  begin
    if Tmp[i] = ' ' then
      sp := i + 1;
    dec(i);
  end;
  if (i < j) and (i > 0) and (sp > 0) then
  begin
    Code := copy(Tmp,sp,j-sp);
    CSShort := copy(Tmp, i+1, sp-i-2);
    Tmp := Trim(copy(Tmp,1,i-1));
    for k := low(TCodingSystem) to high(TCodingSystem) do
    begin
      if CSShort = CodingSystemID[k] then
      begin
        CSLong := CodingSystemDesc[k];
        break;
      end;
    end;
    SetPiece(x, U ,pnumCode, Code);
    SetPiece(x, U, pnumCategory, CSLong);
    SetPiece(x, U, pnumNarrative, Tmp);
    SetPiece(x, U, pnumCodingSystem, CSShort);
  end;
end;

end.

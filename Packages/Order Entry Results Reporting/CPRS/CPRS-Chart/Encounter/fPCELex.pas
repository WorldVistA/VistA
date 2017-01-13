unit fPCELex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, uCore,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, Buttons, VA508AccessibilityManager,
  ComCtrls, fBase508Form, CommCtrl, mTreeGrid, rCore;

type
  TfrmPCELex = class(TfrmBase508Form)
    txtSearch: TCaptionEdit;
    cmdSearch: TButton;
    pnlStatus: TPanel;
    pnlDialog: TPanel;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cmdExtendedSearch: TBitBtn;
    pnlSearch: TPanel;
    pnlList: TPanel;
    lblStatus: TVA508StaticText;
    lblSelect: TVA508StaticText;
    lblSearch: TLabel;
    tgfLex: TTreeGridFrame;
    procedure cmdSearchClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure cmdExtendedSearchClick(Sender: TObject);
    function isNumeric(inStr: String): Boolean;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tgfLextvChange(Sender: TObject; Node: TTreeNode);
    procedure tgfLextvClick(Sender: TObject);
    procedure tgfLextvDblClick(Sender: TObject);
    procedure tgfLextvEnter(Sender: TObject);
    procedure tgfLextvExit(Sender: TObject);
    procedure tgfLextvHint(Sender: TObject; const Node: TTreeNode;
      var Hint: string);
    procedure tgfLextvExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  private
    FLexApp: Integer;
    FSuppressCodes: Boolean;
    FCode:   string;
    FDate:   TFMDateTime;
    FICDVersion: String;
    FI10Active: Boolean;
    FExtend: Boolean;
    FMessage: String;
    FSingleCodeSys: Boolean;
    FCodeSys: String;
    function ParseNarrCode(ANarrCode: String): String;
    procedure SetApp(LexApp: Integer);
    procedure SetDate(ADate: TFMDateTime);
    procedure SetICDVersion(ADate: TFMDateTime);
    procedure enableExtend;
    procedure disableExtend;
    procedure updateStatus(status: String);
    procedure SetColumnTreeModel(ResultSet: TStrings);
    procedure processSearch;
    procedure setClientWidth;
    procedure CenterForm(w: Integer);
  end;

procedure LexiconLookup(var Code: string; ALexApp: Integer; ADate: TFMDateTime = 0; AExtend: Boolean = False; AInputString: String = ''; AMessage: String = ''; ADefaultToInput: Boolean = False);

implementation

{$R *.DFM}

uses rPCE, uProbs, rProbs, UBAGlobals, fEncounterFrame;

var
  TriedExtend: Boolean = false;

procedure LexiconLookup(var Code: string; ALexApp: Integer; ADate: TFMDateTime = 0; AExtend: Boolean = False; AInputString: String = ''; AMessage: String = ''; ADefaultToInput: Boolean = False);
var
  frmPCELex: TfrmPCELex;
begin
  frmPCELex := TfrmPCELex.Create(Application);
  try
    ResizeFormToFont(TForm(frmPCELex));

    if (ADate = 0) and Assigned(uEncPCEData) then
      begin
         if uEncPCEData.VisitCategory = 'E' then ADate := FMNow
         else ADate := uEncPCEData.VisitDateTime;
      end;

    if ADefaultToInput and (AInputString <> '') then
      frmPCELex.txtSearch.Text := Piece(frmPCELex.ParseNarrCode(AInputString), U, 2);
    frmPCELex.SetApp(ALexApp);
    frmPCELex.SetDate(ADate);
    frmPCELex.SetICDVersion(ADate);
    frmPCELex.FMessage := AMessage;
    frmPCELex.FExtend := AExtend;
    if (ALexApp = LX_ICD) then
      frmPCELex.FExtend := True;
    frmPCELex.ShowModal;
    Code := frmPCELex.FCode;
    if (AInputString <> '') and (Pos('(SCT', AInputString) > 0) and (ALexApp <> LX_SCT) then
      SetPiece(Code, U, 2, AInputString);
  finally
    frmPCELex.Free;
  end;
end;

procedure TfrmPCELex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Release;
end;

procedure TfrmPCELex.FormCreate(Sender: TObject);
var
  UserProps: TStringList;
begin
  inherited;
  FCode := '';
  FCodeSys := '';
  FI10Active := False;
  FSingleCodeSys := True;
  FExtend := False;
  UserProps := TStringList.Create;
  FastAssign(InitUser(User.DUZ), UserProps);
  PLUser := TPLUserParams.create(UserProps);
  FSuppressCodes := PLUser.usSuppressCodes;
  ResizeAnchoredFormToFont(self);

  tgfLex.DefTreeViewWndProc := tgfLex.tv.WindowProc;
  tgfLex.tv.WindowProc := tgfLex.TreeViewWndProc;
end;

procedure TfrmPCELex.FormShow(Sender: TObject);
var
  lt: String;
  dh, lh: Integer;
begin
  inherited;

  if FSuppressCodes then
  begin
    tgfLex.ShowCode := False;
    tgfLex.ShowTargetCode := False;
  end
  else
  begin
    tgfLex.ShowCode := True;
    tgfLex.ShowTargetCode := not FI10Active;
  end;
  
  tgfLex.ShowDescription := True;
  tgfLex.HorizPanelSpace := 8;
  tgfLex.VertPanelSpace := 4;

  if FMessage <> '' then
  begin
    lt := lblSearch.Caption;
    lh := lblSearch.Height;
    lblSearch.AutoSize := True;
    lblSearch.Caption := FMessage + CRLF + CRLF + lt;
    lblSearch.AutoSize := False;
    dh := (lblSearch.Height - lh);
    pnlSearch.Height := pnlSearch.Height + dh;
    Height := Height + dh;
  end;
  CenterForm(tgfLex.ClientWidth);
  if FExtend and (txtSearch.Text <> '') then
  begin
    if FExtend then
      cmdExtendedSearch.Click
    else
      cmdSearch.Click;
  end;
end;

procedure TfrmPCELex.SetApp(LexApp: Integer);
begin
  FLexApp := LexApp;
  case LexApp of
  LX_ICD: begin
            Caption := 'Lookup Diagnosis';
            lblSearch.Caption := 'Search for Diagnosis:';
          end;
  LX_CPT: begin
            Caption := 'Lookup Procedure';
            lblSearch.Caption := 'Search for Procedure:';
          end;
  end;
end;

procedure TfrmPCELex.SetDate(ADate: TFMDateTime);
begin
  FDate := ADate;
end;

procedure TfrmPCELex.SetICDVersion(ADate: TFMDateTime);
begin
  if ADate = 0 then
     begin
       FICDVersion := Encounter.GetICDVersion;
     end
  else
     begin
       if ICD10ImplDate > ADate then
         FICDVersion := 'ICD^ICD-9-CM'
       else
         FICDVersion := '10D^ICD-10-CM';
     end;

  if (Piece(FICDVersion, '^', 1) = '10D') then
    FI10Active := True;
  cmdExtendedSearch.Hint := 'Search ' + Piece(FICDVersion, '^', 2) + ' Diagnoses...';
  tgfLex.pnlTargetCodeSys.Caption := Piece(FICDVersion, '^', 2) + ':  ';
end;

procedure TfrmPCELex.enableExtend;
begin
  cmdExtendedSearch.Visible := true;
  cmdExtendedSearch.Enabled := true;
end;

procedure TfrmPCELex.disableExtend;
begin
  cmdExtendedSearch.Enabled := false;
  cmdExtendedSearch.Visible := false;
  if not FI10Active then
    FExtend := False;
end;

procedure TfrmPCELex.txtSearchChange(Sender: TObject);
begin
  inherited;
  cmdSearch.Default := True;
  cmdOK.Default := False;
  cmdCancel.Default := False;
  disableExtend;
  if tgfLex.tv.Items.Count > 0 then
  begin
    tgfLex.tv.Selected := nil;
    tgfLex.tv.Items.Clear;
    CenterForm(Constraints.MinWidth);
  end;
end;

procedure TfrmPCELex.cmdSearchClick(Sender: TObject);
begin
  TriedExtend := false;
  FCodeSys := '';
  FSingleCodeSys := True;
  if not FI10Active and (FLexApp = LX_ICD) then
    FExtend := False;
  if not tgfLex.pnlTarget.Visible then tgfLex.pnlTarget.Visible := True;
  processSearch;
end;

procedure TfrmPCELex.setClientWidth;
var
  i, maxw, tl, maxtl: integer;
  ctn: TLexTreeNode;
begin
  maxtl := 0;
  for i := 0 to pred(tgfLex.tv.Items.Count) do
  begin
    ctn := tgfLex.tv.Items[i] as TLexTreeNode;
    tl := TextWidthByFont(Font.Handle, ctn.Text);
    if (tl > maxtl) then
      maxtl := tl;
  end;

  maxw := maxtl + 30;

  if maxw < Constraints.MinWidth then
    maxw := Constraints.MinWidth;

  self.Width := maxw;

  //resize tv to maximum pixel width of its elements
  if (maxw > 0) and (self.ClientWidth <> maxw) then
  begin
    CenterForm(maxw);
  end;
end;

procedure TfrmPCELex.CenterForm(w: Integer);
var
  wdiff, mainw: Integer;
begin
  mainw := Application.MainForm.Width;

  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (tgfLex.Width - tgfLex.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;

  invalidate;
end;

procedure TfrmPCELex.SetColumnTreeModel(ResultSet: TStrings);
var
  i: Integer;
  Node, StubNode: TLexTreeNode;
  RecStr: String;
begin
  tgfLex.tv.Items.Clear;
  for i := 0 to ResultSet.Count - 1 do
  begin
    //RecStr = VUID^Description^CodeSys^Code^TargetCodeSys^TargetCode^DesignationID^Parent
    RecStr := ResultSet[i];
    if Piece(RecStr, '^', 8) = '' then
      Node := (tgfLex.tv.Items.Add(nil, Piece(RecStr, '^', 2))) as TLexTreeNode
    else
      Node := (tgfLex.tv.Items.AddChild(tgfLex.tv.Items[(StrToInt(Piece(RecStr, '^', 8))-1)], Piece(RecStr, '^', 2))) as TLexTreeNode;

    with Node do
    begin
      VUID := Piece(RecStr, '^', 1);
      Text := Piece(RecStr, '^', 2);
      CodeDescription := Text;
      CodeSys := Piece(RecStr, '^', 3);

      if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
        FSingleCodeSys := False;

      FCodeSys := CodeSys;

      Code := Piece(RecStr, '^', 4);

      if Piece(RecStr, '^', 8) <> '' then
        ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 8)) - 1);

      //TODO: Need to accommodate Designation Code in ColumnTreeNode...
      if CodeSys = 'SNOMED CT' then
      begin
        CodeIEN := Code;
        DesignationID := Piece(RecStr, '^', 7);
      end
      else
        CodeIEN := Piece(RecStr, '^', 9);

      TargetCode := Piece(RecStr, '^', 6);

    end;
    if (Node.VUID = '+') then
    begin
      StubNode := (tgfLex.tv.Items.AddChild(Node, 'Searching...')) as TLexTreeNode;
      with StubNode do
      begin
        VUID := '';
        Text := 'Searching...';
        CodeDescription := Text;
        CodeSys := 'ICD-10-CM';

        if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
          FSingleCodeSys := False;

        FCodeSys := CodeSys;

        Code := '';
        CodeIEN := '';

        ParentIndex := IntToStr(Node.Index);
      end;
    end;
  end;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
end;

procedure TfrmPCELex.processSearch;
const
  TX_SRCH_REFINE1 = 'Your search ';
  TX_SRCH_REFINE2 = ' matched ';
  TX_SRCH_REFINE3 = ' records, too many to display.' + CRLF + CRLF + 'Suggestions:' + CRLF +
                    #32#32#32#32#42 + '   Refine your search by adding more words' + CRLF + #32#32#32#32#42 + '   Try different keywords';
  MaxRec = 5000;
var
  LexResults: TStringList;
  found, subset, SearchStr: String;
  FreqOfText: integer;
  Match: TLexTreeNode;
begin
  if Length(txtSearch.Text) = 0 then
  begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
  end;

  if (FLexApp = LX_ICD) or (FLexApp = LX_SCT) then
  begin
    if FExtend and (FLexApp = LX_ICD) then
      subset := Piece(FICDVersion, '^', 2) + ' Diagnoses'
    else
      subset := 'SNOMED CT Concepts';
  end
  else if FLexApp = LX_CPT then
    subset := 'Current Procedural Terminology (CPT)'
  else
    subset := 'Clinical Lexicon';

  LexResults := TStringList.Create;

  try
    Screen.Cursor := crHourGlass;
    updateStatus('Searching ' + subset + '...');
    SearchStr := Uppercase(txtSearch.Text);
    FreqOfText := GetFreqOfText(SearchStr);
    if FreqOfText > MaxRec then
    begin
      InfoBox(TX_SRCH_REFINE1 + #39 + SearchStr + #39 + TX_SRCH_REFINE2 + IntToStr(FreqOfText) + TX_SRCH_REFINE3,'Refine Search', MB_OK or MB_ICONINFORMATION);
      lblStatus.Caption := '';
      Exit;
    end;
    ListLexicon(LexResults, SearchStr, FLexApp, FDate, FExtend, FI10Active);

    if (Piece(LexResults[0], u, 1) = '-1') then
    begin
      found := '0 matches found';
      if FExtend then
        found := found + ' by ' + subset + ' Search.'
      else
        found := found + '.';
      lblSelect.Visible := False;
      txtSearch.SetFocus;
      txtSearch.SelectAll;
      cmdOK.Default := False;
      cmdOK.Enabled := False;
      tgfLex.tv.Enabled := False;
      tgfLex.tv.Items.Clear;
      cmdCancel.Default := False;
      cmdSearch.Default := True;
      if not FExtend and (FLexApp = LX_ICD) then
      begin
        cmdExtendedSearch.Click;
        Exit;
      end;
    end
    else
    begin
      found := inttostr(LexResults.Count) + ' matches found';
      if FExtend then
        found := found + ' by ' + subset + ' Search.'
      else
        found := found + '.';

      SetColumnTreeModel(LexResults);

      setClientWidth;
      lblSelect.Visible := True;
      tgfLex.tv.Enabled := True;
      tgfLex.tv.SetFocus;

      Match := tgfLex.FindNode(SearchStr);

      if Match <> nil then
      begin  {search term is on return list, so highlight it}
        cmdOk.Enabled := True;
        ActiveControl := tgfLex.tv;
      end
      else
        begin
          tgfLex.tv.Items[0].Selected := False;
        end;

      if (not FExtend) and (FLexApp = LX_ICD) and (not isNumeric(txtSearch.Text)) then
        enableExtend;
      cmdSearch.Default := False;
    end;
    updateStatus(found);
    if FExtend then tgfLex.pnlTarget.Visible := False;
  finally
    LexResults.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPCELex.cmdExtendedSearchClick(Sender: TObject);
begin
  inherited;
  FExtend := True;
  FCodeSys := '';
  FSingleCodeSys := True;
  processSearch;
  disableExtend;
end;

procedure TfrmPCELex.cmdOKClick(Sender: TObject);
var
  Node: TLexTreeNode;
begin
  inherited;
  if(tgfLex.SelectedNode = nil) then
    Exit;
  Node := tgfLex.SelectedNode;
  if ((FLexApp = LX_ICD) or (FLexApp = LX_SCT)) and (Node.Code <> '') then
  begin
    if (Copy(Node.CodeSys, 0, 3) = 'ICD') then
      FCode := Node.Code + U + Node.Text
    else if (Copy(Node.CodeSys, 0, 3) = 'SNO')  then
      FCode := Node.TargetCode + U + Node.Text + ' (SNOMED CT ' + Node.Code + ')' + U + Node.DesignationID;

    FCode := FCode + U + Node.CodeIEN + U + Node.CodeSys;
  end
  else if BAPersonalDX then
    FCode := LexiconToCode(StrToInt(Node.VUID), FLexApp, FDate) + U + Node.Text + U + Node.VUID
  else
    FCode := LexiconToCode(StrToInt(Node.VUID), FLexApp, FDate) + U + Node.Text;
  Close;
end;

procedure TfrmPCELex.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FCode := '';
  Close;
end;

procedure TfrmPCELex.tgfLextvChange(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  tgfLex.tvChange(Sender, Node);
  if (tgfLex.SelectedNode = nil) or (tgfLex.SelectedNode.VUID = '+')  then
  begin
    cmdOK.Enabled := false;
    cmdOk.Default := false;
  end
  else  // valid Node selected
  begin
    cmdOK.Enabled := true;
    cmdOK.Default := true;
    cmdSearch.Default := false;
  end;
end;

procedure TfrmPCELex.tgfLextvClick(Sender: TObject);
begin
  inherited;
  if(tgfLex.SelectedNode <> nil) and (tgfLex.SelectedNode.VUID <> '+') then
  begin
    cmdOK.Enabled := true;
    cmdSearch.Default := False;
    cmdOK.Default := True;
  end;
end;

procedure TfrmPCELex.tgfLextvDblClick(Sender: TObject);
begin
  inherited;
  tgfLextvClick(Sender);
  if tgfLex.SelectedNode.VUID <> '+' then
    cmdOKClick(Sender);
end;

procedure TfrmPCELex.tgfLextvEnter(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
end;

procedure TfrmPCELex.tgfLextvExit(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
end;

procedure TfrmPCELex.tgfLextvExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  ctNode, ChildNode, StubNode: TLexTreeNode;
  ChildRecs: TStringList;
  RecStr: String;
  i: integer;
begin
  inherited;
  ctNode := Node as TLexTreeNode;

  if ctNode.VUID = '+' then
  begin
    ChildRecs := TStringList.Create;
    ListLexicon(ChildRecs, ctNode.Code, FLexApp, FDate, True, FI10Active);

    //clear node's placeholder child
    ctNode.DeleteChildren;

    //create children
    for i := 0 to ChildRecs.Count - 1 do
    begin
      RecStr := ChildRecs[i];
      ChildNode := (tgfLex.tv.Items.AddChild(ctNode, Piece(RecStr, '^', 2))) as TLexTreeNode;

      with ChildNode do
      begin
        VUID := Piece(RecStr, '^', 1);
        Text := Piece(RecStr, '^', 2);
        CodeDescription := Text;
        CodeSys := Piece(RecStr, '^', 3);

        if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
          FSingleCodeSys := False;

        FCodeSys := CodeSys;

        Code := Piece(RecStr, '^', 4);

        if Piece(RecStr, '^', 8) <> '' then
          ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 8)) - 1);

        //TODO: Need to accommodate Designation Code in ColumnTreeNode...
        if CodeSys = 'SNOMED CT' then
          CodeIEN := Code
        else
          CodeIEN := Piece(RecStr, '^', 9);

        TargetCode := Piece(RecStr, '^', 6);
      end;

      if (ChildNode.VUID = '+') then
      begin
        StubNode := (tgfLex.tv.Items.AddChild(ChildNode, 'Searching...')) as TLexTreeNode;
        with StubNode do
        begin
          VUID := '';
          Text := 'Searching...';
          CodeDescription := Text;
          CodeSys := 'ICD-10-CM';

          if ((FCodeSys <> '') and (CodeSys <> FCodeSys)) then
            FSingleCodeSys := False;

          FCodeSys := CodeSys;

          Code := '';
          CodeIEN := '';

          ParentIndex := IntToStr(Node.Index);
        end;
      end;
    end;
  end;
  AllowExpansion := True;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
  tgfLex.tv.Invalidate;
end;

procedure TfrmPCELex.tgfLextvHint(Sender: TObject; const Node: TTreeNode;
  var Hint: string);
begin
  inherited;
  // Only show hint if caption is less than width of Column[0]
  if TextWidthByFont(Font.Handle, Node.Text) < tgfLex.tv.Width then
    Hint := ''
  else
    Hint := Node.Text;
end;

procedure TfrmPCELex.updateStatus(status: String);
begin
  lblStatus.caption := status;
  lblStatus.Invalidate;
  lblStatus.Update;
end;

function TfrmPCELex.isNumeric(inStr: String): Boolean;
var
  dbl: Double;
  error, intDecimal: Integer;
begin
  Result := False;
  if (FormatSettings.DecimalSeparator <> '.') then
    intDecimal := Pos(FormatSettings.DecimalSeparator, inStr)
  else
    intDecimal := 0;
  if (intDecimal > 0) then
    inStr[intDecimal] := '.';
  Val(inStr, dbl, error);
  if (dbl = 0.0) then
    ; //do nothing
  if (intDecimal > 0) then
    inStr[intDecimal] := FormatSettings.DecimalSeparator;
  if (error = 0) then
    Result := True;
end;

function TfrmPCELex.ParseNarrCode(ANarrCode: String): String;
var
  narr, code: String;
  ps: Integer;
begin
  narr := ANarrCode;
  ps := Pos('(SCT', narr);
  if not (ps > 0) then
    ps := Pos('(SNOMED', narr);
  if not (ps > 0) then
    ps := Pos('(ICD', narr);
  if (ps > 0) then
  begin
    narr := TrimRight(Copy(ANarrCode, 0, ps - 1));
    code := Copy(ANarrCode, ps, Length(ANarrCode));
    code := Piece(Piece(Piece(code, ')', 1), '(', 2), ' ', 2);
  end
  else
    code := '';
  Result := code + U + narr;
end;

end.


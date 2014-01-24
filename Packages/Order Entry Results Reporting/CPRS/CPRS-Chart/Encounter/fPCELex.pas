unit fPCELex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, uCore, uProbs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, Buttons, VA508AccessibilityManager,
  ComCtrls;

type
  TfrmPCELex = class(TfrmAutoSz)
    txtSearch: TCaptionEdit;
    cmdSearch: TButton;
    lblSelect: TLabel;
    pnlStatus: TPanel;
    pnlDialog: TPanel;
    pnlButtons: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    cmdExtendedSearch: TBitBtn;
    pnlSearch: TPanel;
    lblSearch: TLabel;
    pnlList: TPanel;
    lvLex: TListView;
    lblStatus: TVA508StaticText;
    procedure cmdSearchClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure lvLexClick(Sender: TObject);
    procedure txtSearchChange(Sender: TObject);
    procedure lvLexDblClick(Sender: TObject);
    procedure cmdExtendedSearchClick(Sender: TObject);
    function isNumeric(inStr: String): Boolean;
    procedure lvLexEnter(Sender: TObject);
    procedure lvLexExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvLexChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvLexCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvLexInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
  private
    FLexApp: Integer;
    FSuppressCodes: Boolean;
    FCode:   string;
    FDate:   TFMDateTime;
    FICDVersion: String;
    FExtend: Boolean;
    FSingleCodeSys: Boolean;
    FCodeSys: String;
    function lvLexGridWidth(lv: TListView): Integer;
    procedure SetApp(LexApp: Integer);
    procedure SetDate(ADate: TFMDateTime);
    procedure SetICDVersion(ADate: TFMDateTime);
    procedure enableExtend;
    procedure disableExtend;
    procedure updateStatus(status: String);
    procedure processSearch(Extend: Boolean);
    procedure setClientWidth(lv: TListView);
    procedure CenterForm(lv: TListView; w: Integer);
    procedure ApplicationShowHint(var HintStr: String; var CanShow: Boolean;
      var HintInfo: THintInfo);
  end;

  // subclass THintWindow to override font size
  TListViewHintWindowClass = class(THintWindow)
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFontSize(fontsize: Integer);
    function GetFontSize: Integer;
  end;

procedure LexiconLookup(var Code: string; LexApp: Integer; ADate: TFMDateTime = 0);

implementation

{$R *.DFM}

uses rPCE, rProbs, UBAGlobals;

var
  TriedExtend: Boolean = false;
  PCEShowHint: TShowHintEvent;
  LVHintWindowClass: TListViewHintWindowClass;

constructor TListViewHintWindowClass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // use CPRS font size for hint window
  SetFontSize(Application.MainForm.Font.Size);
  LVHintWindowClass := Self;
end;

function TListViewHintWindowClass.GetFontSize: Integer;
begin
  Result := Canvas.Font.Size;
end;

procedure TListViewHintWindowClass.SetFontSize(fontsize: Integer);
begin
  Canvas.Font.Size := fontsize;
end;

procedure LexiconLookup(var Code: string; LexApp: Integer; ADate: TFMDateTime = 0);
var
  frmPCELex: TfrmPCELex;
begin
  frmPCELex := TfrmPCELex.Create(Application);
  try
    ResizeFormToFont(TForm(frmPCELex));
    if (ADate = 0) and not ((Encounter.VisitCategory = 'E') or (Encounter.VisitCategory = 'H')
      or (Encounter.VisitCategory = 'D')) then
        ADate := Encounter.DateTime;
    frmPCELex.SetApp(LexApp);
    frmPCELex.SetDate(ADate);
    frmPCELex.SetICDVersion(ADate);
    frmPCELex.ShowModal;
    Code := frmPCELex.FCode;
  finally
    frmPCELex.Free;
  end;
end;

procedure TfrmPCELex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Application.OnShowHint := PCEShowHint;
  Release;
end;

procedure TfrmPCELex.FormCreate(Sender: TObject);
var
  UserProps: TStringList;
begin
  inherited;
  FCode := '';
  FCodeSys := '';
  FSingleCodeSys := True;
  FExtend := false;
  UserProps := TStringList.Create;
  FastAssign(InitUser(User.DUZ), UserProps);
  PLUser := TPLUserParams.create(UserProps);
  FSuppressCodes := PLUser.usSuppressCodes;
  ResizeAnchoredFormToFont(self);
  PCEShowHint := Application.OnShowHint;
  Application.OnShowHint := ApplicationShowHint;
end;

procedure TfrmPCELex.FormShow(Sender: TObject);
begin
  inherited;
  txtSearch.setfocus;
  if FSuppressCodes then
  begin
    lvLex.Columns[1].Width := 0;
    lvLex.Columns[2].Width := 0;
    lvLex.Columns[3].Width := 0;
  end;
  CenterForm(lvLex, lvLex.ClientWidth);
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
  FICDVersion := GetICDVersion(ADate);
  cmdExtendedSearch.Hint := 'Search ' + Piece(FICDVersion, '^', 2) + ' Diagnoses...';
  lvLex.Columns[3].Caption := Piece(FICDVersion, '^', 2);
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
  FExtend := false;
end;

procedure TfrmPCELex.txtSearchChange(Sender: TObject);
begin
  inherited;
  cmdSearch.Default := True;
  cmdOK.Default := False;
  cmdCancel.Default := False;
  disableExtend;
  if lvLex.Items.Count > 0 then
  begin
    lvLex.Clear;
    CenterForm(lvLex, Constraints.MinWidth);
  end;
end;

procedure TfrmPCELex.cmdSearchClick(Sender: TObject);
begin
  if Piece(FICDVersion, '^', 1) = '10D' then
    cmdExtendedSearch.Click
  else
  begin
    TriedExtend := false;
    FExtend := false;
    FCodeSys := '';
    FSingleCodeSys := True;
    processSearch(false);
  end;
end;

procedure TfrmPCELex.setClientWidth(lv: TListView);
var
  i, maxw, tl, maxtl, csl, maxcsl, cl, maxcl, il, maxil: integer;
begin
  maxtl := 0;
  maxcsl := 0;
  maxcl := 0;
  maxil := 0;
  for i := 0 to pred(lv.Items.Count) do
  begin
    tl := TextWidthByFont(Font.Handle, lv.Items[i].Caption);
    if (tl > maxtl) then
      maxtl := tl;
    csl := TextWidthByFont(Font.Handle, lv.Items[i].SubItems[0]);
    if (csl > maxcsl) then
      maxcsl := csl;
    cl := TextWidthByFont(Font.Handle, lv.Items[i].SubItems[1]);
    if (cl > maxcl) then
      maxcl := cl;
    il := TextWidthByFont(Font.Handle, lv.Items[i].SubItems[2]);
    if (il > maxil) then
      maxil := il;
  end;

  il := TextWidthByFont(Font.Handle, Piece(FICDVersion, '^', 2));
  if ((maxil <> 0) and (il > maxil)) then
    maxil := il;

  csl := TextWidthByFont(Font.Handle, 'Code System');
  if (csl > maxcsl) then
    maxcsl := csl;

  //max text width = 500
  if maxtl > 490 then
    maxtl := 490;

  //set lv column widths
  lv.Columns[0].Width := maxtl + 10;
  if FSuppressCodes then
  begin
    maxw := maxtl + 10;
  end
  else
  begin
    if FSingleCodeSys then
    begin
      lv.Columns[1].Width := 0;
      lv.Columns[2].Caption := FCodeSys;
      if (maxcsl > maxcl) then
         maxcl := maxcsl;      
    end
    else
    begin
      lv.Columns[1].Width := maxcsl + 15;
      lv.Columns[2].Caption := 'Code';
    end;
    lv.Columns[2].Width := maxcl + 15;
    if (maxil = 0) then
      lv.Columns[3].Width := 0
    else
      lv.Columns[3].Width := maxil + 15;
    maxw := maxtl + maxcsl + maxcl + maxil + 55;
  end;

  //resize lv to maximum pixel width of its elements
  if (maxw > 0) and (self.ClientWidth <> maxw) then
  begin
    CenterForm(lv, maxw);
  end;
end;

procedure TfrmPCELex.ApplicationShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if HintInfo.HintControl = lvLex then
  begin
    HintInfo.HintWindowClass := TListViewHintWindowClass;
    if LVHintWindowClass <> nil then
      if LVHintWindowClass.GetFontSize <> Application.MainForm.Font.Size then
        LVHintWindowClass.SetFontSize(Application.MainForm.Font.Size);
  end;
end;

procedure TfrmPCELex.CenterForm(lv: TListView; w: Integer);
var
  wdiff, mainw, gw: Integer;
begin
  mainw := Application.MainForm.Width;
  self.Constraints.MaxWidth := 0;
  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (lv.Width - lv.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);
  gw := lvLexGridWidth(lvLex);
  if (lv.ClientWidth > gw) then
    lv.Columns[0].Width := lv.Columns[0].Width + (lv.ClientWidth - gw);

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;
  self.Constraints.MaxWidth := self.Width;
  invalidate;
end;

procedure TfrmPCELex.processSearch(Extend: Boolean);
var
  LexResults: TStringList;
  onlist: Integer;
  found, subset, SearchStr: String;
  MatchItem: TListItem;
procedure SetLexList(v:string);
var   {too bad ORCombo only allows 1 piece to be shown}
  i, j: integer;
  txt, term, codesys, code, icdver, icd, x: String;
  lvListItem: TListItem;
begin
  lvLex.Clear;

  onlist := -1;
  for i := 0 to pred(LexResults.count) do
  begin
    txt := LexResults[i];
    term := Piece(txt, u, 2);
    codesys := Piece(txt, u, 3);
    code := Piece(txt, u, 4);
    icdver := Piece(txt, u, 5);
    icd := Piece(txt, u, 6);

    if ((FCodeSys <> '') and (codesys <> FCodeSys)) then
       FSingleCodeSys := False;

    FCodeSys := codesys;

    j := Pos(' *', Term);
    if j > 0 then
      x := UpperCase(Copy(Term, 1, j-1))
    else
      x := UpperCase(Term);

    if (x = V) or (codesys = V) or (code = V) then
       onlist := i;

    with lvLex do
    begin
      lvListItem := Items.Add;
      lvListItem.Caption := term;
      lvListItem.SubItems.Add(codesys);
      lvListItem.SubItems.Add(code);
      lvListItem.SubItems.Add(icd);
      lvListItem.Data := Pointer(txt);
      if onlist = i then
        MatchItem := lvListItem;
    end;
  end;

  lvLex.Enabled := True;
  lvLex.SetFocus;
end;
begin {processSearch body}
  if Length(txtSearch.Text) = 0 then
  begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
  end;

  if (FLexApp = LX_ICD) or (FLexApp = LX_SCT) then
  begin
    if Extend then
      subset := Piece(FICDVersion, '^', 2) + ' Diagnoses'
    else
      subset := 'SNOMED CT Problem List Subset';
  end
  else if FLexApp = LX_CPT then
    subset := 'Current Procedural Terminology (CPT)'
  else
    subset := 'Clinical Lexicon';

  LexResults := TStringList.Create;

  try
    Screen.Cursor := crDefault;
    updateStatus('Searching ' + subset + '...');
    SearchStr := Uppercase(txtSearch.Text);
    ListLexicon(LexResults, SearchStr, FLexApp, FDate, FExtend);

    if (Piece(LexResults[0], u, 1) = '-1') then
    begin
      found := '0 matches found';
      if FExtend then
        found := found + ' by Extended Search.'
      else
        found := found + '.';
      lblSelect.Visible := False;
      txtSearch.SetFocus;
      txtSearch.SelectAll;
      cmdOK.Default := False;
      cmdOK.Enabled := False;
      lvLex.Enabled := False;
      lvLex.Clear;
      cmdCancel.Default := False;
      cmdSearch.Default := True;
      if not FExtend and ((FLexApp = LX_SCT) or (FLexApp = LX_ICD)) then
      begin
        enableExtend;
        cmdExtendedSearch.Setfocus;
      end;
      { remove to enable NTRT request.
      else
      begin
        executeNTRTChoice(txtSearch.text);
        txtSearch.clear;
        lstSelect.Items.clear;
        updateStatus('');
        txtSearch.SetFocus;
        DisableExtend;
      end;
      remove to enable NTRT request. }
    end
    else
    begin
      found := inttostr(LexResults.Count) + ' matches found';
      if FExtend then
        found := found + ' by Extended Search.'
      else
        found := found + '.';

      SetLexList(SearchStr);

      setClientWidth(lvLex);
      lblSelect.Visible := True;
      lvLex.SetFocus;

      if (onlist >= 0) and (MatchItem <> nil) then
      begin  {search term is on return list, so highlight it}
        onlist := lvLex.Items.IndexOf(MatchItem);
        lvLex.Items[onlist].Selected := True;
        lvLex.Items[onlist].Focused := True;
        cmdOk.Enabled := True;
        ActiveControl := cmdOK;
      end;

      if (not Extend) and ((FLexApp = LX_ICD) or (FLexApp = LX_SCT)) and (not isNumeric(txtSearch.Text)) then
        enableExtend;
      cmdSearch.Default := False;
    end;
    updateStatus(found);
  finally
    LexResults.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmPCELex.lvLexChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
  begin
    cmdOK.Enabled := false;
    cmdOk.Default := false;
  end
  else
  begin
    cmdOK.Enabled := true;
    cmdOK.Default := true;
    cmdSearch.Default := false;
  end;
end;

procedure TfrmPCELex.lvLexClick(Sender: TObject);
begin
  inherited;
  if(lvLex.ItemIndex > -1) then
  begin
    cmdOK.Enabled := true;
    cmdSearch.Default := False;
    cmdOK.Default := True;
  end;
end;

procedure TfrmPCELex.lvLexCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Format, i: Integer;
  Left: Array[0..3] of Integer;
  ARect: TRect;
begin
  inherited;
  DefaultDraw := True;
  // if Problem Text is long, draw the ListView element yourself
  if TextWidthByFont(Font.Handle, Item.Caption) > 490 then
  begin
    // draw the Problem Text
    ARect := Item.DisplayRect(drLabel);
    Left[0] := ARect.Left;
    Left[1] := Left[0] + Sender.Column[0].Width;
    Left[2] := Left[1] + Sender.Column[1].Width;
    Left[3] := Left[2] + Sender.Column[2].Width;
    ARect.Left := ARect.Left + 2;
    ARect.Right := ARect.Right - 2;
    Format := (DT_LEFT or DT_NOPREFIX or DT_WORD_ELLIPSIS);
    DrawText(Sender.Canvas.Handle, PChar(Item.Caption), Length(Item.Caption), ARect, Format);
    // now draw SNOMED-CT & ICD codes
    for i := 0 to Item.SubItems.Count - 1 do
    begin
      ARect.Left := Left[i + 1] + Sender.Margins.Left;
      ARect.Right := ARect.Left + Sender.Column[i + 1].Width - Sender.Margins.Right;
      DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[i]), Length(Item.SubItems[i]), ARect, Format);
    end;
    DefaultDraw := False;
  end;
end;

procedure TfrmPCELex.cmdExtendedSearchClick(Sender: TObject);
begin
  inherited;
  FExtend := true;
  FCodeSys := '';
  FSingleCodeSys := True;
  processSearch(true);
  disableExtend;
end;

procedure TfrmPCELex.cmdOKClick(Sender: TObject);
var
  Item: String;
begin
  inherited;
  if(lvLex.ItemIndex = -1) then
    Exit;
  Item := String(lvLex.Items[lvLex.ItemIndex].Data);
  if (FLexApp = LX_ICD) and (Piece(Item, U, 4) <> '') then
  begin
    if (Copy(Piece(Item, U, 3), 0, 3) = 'ICD') then
      FCode := Piece(Item, U, 4) + U + Piece(Item, U, 2)
    else if (Copy(Piece(Item, U, 3), 0, 3) = 'SNO')  then
      FCode := Piece(Item, U, 6) + U + Piece(Item, U, 2) + ' (SNOMED CT ' + Piece(Item, U, 4) + ')';   
    if BAPersonalDX then
      FCode := FCode + U + Piece(Item, U, 1);
  end
  else if BAPersonalDX then
    FCode := (LexiconToCode(StrToInt(Piece(Item, U, 1)), FLexApp, FDate) + U + Piece(Item, U, 2) + U + Piece(Item, U, 1) )
  else
    FCode := LexiconToCode(StrToInt(Piece(Item, U, 1)), FLexApp, FDate) + U + Piece(Item, U, 2);
  Close;
end;

procedure TfrmPCELex.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FCode := '';
  Close;
end;

procedure TfrmPCELex.lvLexDblClick(Sender: TObject);
begin
  inherited;
  lvLexClick(Sender);
  cmdOKClick(Sender);
end;

procedure TfrmPCELex.lvLexEnter(Sender: TObject);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
end;

procedure TfrmPCELex.lvLexExit(Sender: TObject);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
    cmdOK.Enabled := false
  else
    cmdOK.Enabled := true;
end;

function TfrmPCELex.lvLexGridWidth(lv: TListView): Integer;
var
  i, w: Integer;
begin
  w := 0;
  for i := 0 to lv.Columns.Count - 1 do
    w := w + lv.Column[i].Width;

  Result := w;
end;

procedure TfrmPCELex.lvLexInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin
  inherited;
  // Only show hint if caption is less than width of Column[0]
  if TextWidthByFont(Font.Handle, Item.Caption) < (Sender as TListview).Column[0].Width then
    InfoTip := '';
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
  if (DecimalSeparator <> '.') then
    intDecimal := Pos(DecimalSeparator, inStr)
  else
    intDecimal := 0;
  if (intDecimal > 0) then
    inStr[intDecimal] := '.';
  Val(inStr, dbl, error);
  if (dbl = 0.0) then
    ; //do nothing
  if (intDecimal > 0) then
    inStr[intDecimal] := DecimalSeparator;
  if (error = 0) then
    Result := True;
end;
end.


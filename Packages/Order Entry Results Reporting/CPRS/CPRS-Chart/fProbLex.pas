unit fProbLex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ORFn, uProbs, StdCtrls, Buttons, ExtCtrls, ORctrls, uConst,
  fAutoSz, uInit, fBase508Form, VA508AccessibilityManager, Grids, fProbFreetext,
  ComCtrls, Windows, rPCE;

type
  TfrmPLLex = class(TfrmBase508Form)
    {Label1: TLabel;}
    bbCan: TBitBtn;
    bbOK: TBitBtn;
    pnlStatus: TPanel;
    lblStatus: TVA508StaticText;
    ebLex: TCaptionEdit;
    bbSearch: TBitBtn;
    bbExtendedSearch: TBitBtn;
    pnlDialog: TPanel;
    pnlSearch: TPanel;
    pnlButtons: TPanel;
    pnlList: TPanel;
    lblSelect: TLabel;
    lblSearch: Tlabel;
    lvLex: TListView;
    bbFreetext: TBitBtn;
    procedure EnableExtend;
    procedure DisableExtend;
    procedure EnableFreeText;
    procedure DisableFreeText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbOKClick(Sender: TObject);
    procedure bbCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ebLexKeyPress(Sender: TObject; var Key: Char);
    procedure bbSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbExtendedSearchClick(Sender: TObject);
    procedure ebLexChange(Sender: TObject);
    procedure setClientWidth(lv: TListView);
    procedure CenterForm(lv: TListView; w: Integer);
    procedure lvLexEnter(Sender: TObject);
    procedure lvLexExit(Sender: TObject);
    procedure lvLexClick(Sender: TObject);
    procedure lvLexChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormResize(Sender: TObject);
    procedure lvLexCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvLexInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ApplicationShowHint(var HintStr: String; var CanShow: Boolean;
      var HintInfo: THintInfo);
    procedure bbFreetextClick(Sender: TObject);
  private
    FExtendOffered: Boolean;
    FSuppressCodes: Boolean;
    FICDLookup: Boolean;
    FBuildingList: Boolean;
    FCenteringForm: Boolean;
    FICDVersion: String;
    FProblemNOS: String;
    FContinueNOS: String;
    procedure SetICDVersion(ADate: TFMDateTime = 0);
    function lvLexGridWidth(lv: TListView): Integer;
    procedure updateStatus(status: String);
    procedure processSearch(Extend: Boolean);
//    function SaveFTMessageBox(IncludeCheckBox: Boolean): Boolean;
    function SaveFreetext: Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure SetSearchString(sstring: String);
    function SetFreetextProblem: String;
  end;

  // subclass THintWindow to override font size
  TListViewHintWindowClass = class(THintWindow)
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFontSize(fontsize: Integer);
    function GetFontSize: Integer;
  end;

implementation

uses
 fProbs, rProbs, fProbEdt;

{$R *.DFM}

var
 ProblemNOSs: TStringList;
 TriedExtend: Boolean = false;
 PLShowHint: TShowHintEvent;
 LVHintWindowClass: TListViewHintWindowClass;

const
  TX799 = '799.9';
  TX_CONTINUE_799 = 'The term you selected is not yet mapped to an ICD-9-CM code.' + CRLF + CRLF +
                    'If you select this term, an ICD-9-CM code of 799.9 will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-9-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TXR69 = 'R69.';
  TX_CONTINUE_R69 = 'The term you selected is not yet mapped to an ICD-10-CM code.' + CRLF + CRLF +
                    'If you select this term, an ICD-10-CM code of R69. will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-10-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TX_FREETEXT_799  = 'A suitable term was not found based on user input and current defaults. ' + CRLF + CRLF +
                     'If you proceed with this nonspecific term, an ICD code of "799.9 - OTHER ' +
                     'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY" will ' +
                     'be filed.' + CRLF + CRLF + 'Use ';
  TX_EXTEND_SEARCH = 'A suitable term was not found in the Problem List subset of SNOMED CT. ' + CRLF + CRLF +
                     'If you''d like to extend your search to include the entire Clinical ' +
                     'Findings Hierarchy of SNOMED CT, click the Extend Search button.';
  TX_CHOOSE        = 'You must select a valid term to identify your patient''s problem. Either click ' +
                     'on a term from the list, or click on the Extend Search button, to extend your ' +
                     'search to include the entire Clinical Findings Hierarchy of SNOMED CT.';
  SUPPRESS_CODES = False;

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

procedure TfrmPLLex.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ProblemNOSs.Free;
  Application.OnShowHint := PLShowHint;
  Release;
end;

procedure TfrmPLLex.bbExtendedSearchClick(Sender: TObject);
begin
  TriedExtend := true;
  processSearch(true);
  DisableExtend;
  if (ebLex.Text <> '') and (lblstatus.Caption <> 'Code search failed by Extended Search.') then
    EnableFreeText;
end;

procedure TfrmPLLex.bbFreetextClick(Sender: TObject);
begin
  inherited;
  if not SaveFreetext then
    Exit;

  //save freetext problem
  PLProblem := SetFreetextProblem;
  {prevents GPF if system close box is clicked while frmDlgProbs is visible}
  if (not Application.Terminated) and (not uInit.TimedOut) then
    if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
  Close;
end;

procedure TfrmPLLex.updateStatus(status: String);
begin
  lblStatus.caption := status;
  lblStatus.Invalidate;
  lblStatus.Update;
end;

procedure TfrmPLLex.SetICDVersion(ADate: TFMDateTime = 0);
begin
  FICDVersion := GetICDVersion(ADate);
  lvLex.Columns[2].Caption := Piece(FICDVersion, '^', 2);
  if Piece(FICDVersion, '^', 1) = 'ICD' then
  begin
    FProblemNOS := TX799;
    FContinueNOS := TX_CONTINUE_799;
  end
  else
  begin
    FProblemNOS := TXR69;
    FContinueNOS := TX_CONTINUE_R69;
  end;
end;

procedure TfrmPLLex.bbOKClick(Sender: TObject);

function setProblem: String;
var
  x, y: String;
  i: integer;
begin
  x := String(lvLex.Items[lvLex.ItemIndex].Data);
  y := Piece(x, U, 2);
  i := Pos(' *', y);
  if i > 0 then y := Copy(y, 1, i - 1);
  SetPiece(x, U, 2, y);
  Result := x + '|' + ebLex.Text;
end;

begin
  {nothing entered, nothing selected - bail out}
  if (ebLex.Text = '') and ((lvLex.ItemIndex < 0) or (lvLex.Items.Count = 0)) then
    exit
  {nothing selected, or search returned void - suggest extended search}
  else if ((lvLex.ItemIndex < 0) or (lvLex.Items.Count = 0)) then
  begin
    if TriedExtend then
    begin
      if not SaveFreetext then
        Exit;

      //save freetext problem
      PLProblem := SetFreetextProblem;
      Exit;
    end
    else
    begin
      if not FExtendOffered then
      begin
        if (lvLex.Items.Count = 0) then
          InfoBox(TX_EXTEND_SEARCH, 'Term not found', MB_OK or MB_ICONINFORMATION)
        else
          InfoBox(TX_CHOOSE, 'Term not selected', MB_OK or MB_ICONINFORMATION);
      end
      else
      begin
        if not SaveFreetext then
          Exit;
        PLProblem := SetFreetextProblem;
        if (not Application.Terminated) and (not uInit.TimedOut) then
          if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
        Close;
      end;
      EnableExtend;
      FExtendOffered := true;
    end;
    exit;
  end
  else if TriedExtend and ((lvLex.Items[lvLex.ItemIndex].SubItems[1] = '')
       or  ((lvLex.Items[lvLex.ItemIndex].SubItems[1] = FProblemNOS)
       and (ProblemNOSs.IndexOf(lvLex.Items[lvLex.ItemIndex].SubItems[0]) < 0))) then
  begin
    if InfoBox(FContinueNOS + UpperCase(lvLex.Items[lvLex.ItemIndex].Caption) + '?', 'Unmapped Problem Selected',
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES then Exit;
    PLProblem := setProblem;
  end
  else
    PLProblem := setProblem;

  {prevents GPF if system close box is clicked while frmDlgProbs is visible}
  if (not Application.Terminated) and (not uInit.TimedOut) then
     if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
  Close;
end;

// override ApplicationShowHint to assign TListViewWindowClass for lvLex
procedure TfrmPLLex.ApplicationShowHint(var HintStr: String;
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

procedure TfrmPLLex.bbCanClick(Sender: TObject);
begin
 PLProblem:='';
 close;
end;

procedure TfrmPLLex.FormCreate(Sender: TObject);
begin
  FExtendOffered := False;
  FBuildingList := False;
  FCenteringForm := False;
  FICDLookup := False;
  FSuppressCodes := PLUser.usSuppressCodes;
  PLProblem := '';
  ProblemNOSs := TStringList.Create;
  ResizeAnchoredFormToFont(self);
  PLShowHint := Application.OnShowHint;
  Application.OnShowHint := ApplicationShowHint;
  SetICDVersion(0);
end;

procedure TfrmPLLex.FormResize(Sender: TObject);
var
  cw, gap, newtl: Integer;
function MaxTextWidth(lv: TListView): Integer;
  var
    i, tl, maxtl: Integer;
begin
  maxtl := 0;
  for i := 0 to lv.Items.Count - 1 do
  begin
    tl := TextWidthByFont(Font.Handle, lv.Items[i].Caption);
    if (tl > maxtl) then
      maxtl := tl;
  end;
  Result := maxtl;
end;
begin
  inherited;
  if not FCenteringForm then
  begin
    Constraints.MaxWidth := 0;
    cw := lvLex.Columns[1].Width + lvLex.Columns[2].Width;
    gap := (lvLex.ClientWidth - (lvLex.Columns[0].Width + cw));
    if (gap <> 0) then
    begin
      newtl := lvLex.Columns[0].Width + gap;
      if newtl < 500 then
        lvLex.Columns[0].Width := newtl
      else
      begin
        lvLex.Columns[0].Width := 500;
        Constraints.MaxWidth := 500 + cw + (lvLex.Width - lvLex.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);
      end;
    end
    else if (lvLex.Items.Count > 0) then
    begin
      newtl := MaxTextWidth(lvLex) + 10;
      if newtl < 500 then
        lvLex.Columns[0].Width := newtl
      else
      begin
        lvLex.Columns[0].Width := 500;
        Constraints.MaxWidth := 500 + cw + (lvLex.Width - lvLex.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);
      end;
    end;
  end;
end;

procedure TfrmPLLex.ebLexKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    bbSearchClick(Sender);
    Key:=#0;
  end
  else
  begin
    lblStatus.caption:='';
    lvLex.Clear;
  end;
end;

procedure TfrmPLLex.ebLexChange(Sender: TObject);
begin
  inherited;
  bbSearch.Default := True;
  bbOK.Default := False;
  DisableExtend;
  DisableFreeText;
  if (lvLex.Items.Count > 0) then
  begin
    lvLex.Clear;
    updateStatus('');
    CenterForm(lvLex, Constraints.MinWidth);
  end;
end;

procedure TfrmPLLex.setClientWidth(lv: TListView);
var
  i, maxw, tl, maxtl, cl, maxcl, il, maxil: integer;
begin
  maxtl := 0;
  maxcl := 0;
  maxil := 0;
  for i := 0 to pred(lv.Items.Count) do
  begin
    tl := TextWidthByFont(Font.Handle, lv.Items[i].Caption);
    if (tl > maxtl) then
      maxtl := tl;
    cl := TextWidthByFont(Font.Handle, lv.Items[i].SubItems[0]);
    if (cl > maxcl) then
      maxcl := cl;
    il := TextWidthByFont(Font.Handle , lv.Items[i].SubItems[1]);
    if (il > maxil) then
      maxil := il;
  end;

  il := TextWidthByFont(Font.Handle, Piece(FICDVersion, '^', 2));
  if (il > maxil) then
    maxil := il;

  //max text width = 500
  if maxtl > 490 then
    maxtl := 490;
  //set lv column widths
  lv.Columns[0].Width := maxtl + 10;
  if FSuppressCodes or FICDLookup then
  begin
    maxw := maxtl + 10;
  end
  else
  begin
    lv.Columns[1].Width := maxcl + 15;
    lv.Columns[1].MinWidth := lv.Columns[1].Width;
    lv.Columns[2].Width := maxil + 15;
    lv.Columns[2].MinWidth := lv.Columns[1].Width;
    maxw := maxtl + maxcl + maxil + 40;
  end;

  //resize lv to maximum pixel width of its elements
  if (maxw > 0) and (self.ClientWidth <> maxw) then
  begin
    CenterForm(lv, maxw);
  end;
end;

procedure TfrmPLLex.SetSearchString(sstring: String);
begin
  ebLex.Text := sstring;
  Invalidate;
end;

procedure TfrmPLLex.CenterForm(lv: TListView; w: Integer);
var
  wdiff, mainw, gw: Integer;
begin
  FCenteringForm := True;
  mainw := Application.MainForm.Width;
//  self.Constraints.MaxWidth := 0;
  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (lv.Width - lv.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);
  gw := lvLexGridWidth(lvLex);
  if (lv.ClientWidth > gw) then
    lv.Columns[0].Width := lv.Columns[0].Width + (lv.ClientWidth - gw);

  if lv.Columns[0].Width = 500 then
    self.Constraints.MaxWidth := self.Width;

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;
//  self.Constraints.MaxWidth := self.Width;
  invalidate;
  FCenteringForm := False;
end;

procedure TfrmPLLex.bbSearchClick(Sender: TObject);
begin
  TriedExtend := false;
  ProblemNOSs.Clear;
  DisableFreeText;
  processSearch(false);
end;

procedure TfrmPLLex.processSearch(Extend: Boolean);
var
  ProblemList: TStringList;
  v, Max, subset: string;
  onlist: integer;
  MatchItem: TListItem;
procedure SetLexList(v:string);
var
  i, j: integer;
  txt, term, icd, sct, x: String;
  lvListItem: TListItem;
begin
  lvLex.Clear;

  onlist := -1;
  for i := 0 to pred(ProblemList.count) do
  begin
    txt := ProblemList[i];
    term := Piece(txt, u, 2);
    icd := Piece(txt, u, 3);
    sct := Piece(txt, u, 6);
    if (not TriedExtend) and (icd = FProblemNOS) then
      ProblemNOSs.Append(sct);

    j := Pos(' *', Term);
    if j > 0 then
      x := UpperCase(Copy(Term, 1, j-1))
    else
      x := UpperCase(Term);

    if (x = V) or (icd = V) or (sct = V) then
       onlist := i;

    with lvLex do
    begin
      lvListItem := Items.Add;
      lvListItem.Caption := term;
      lvListItem.SubItems.Add(sct);
      lvListItem.SubItems.Add(icd);
      lvListItem.Data := Pointer(txt);
      if onlist = i then
        MatchItem := lvListItem;
    end;
  end;

  if Piece(txt, '^', 1) = 'icd' then
  begin
    ebLex.SelectAll;
    ebLex.SetFocus;
    lvLex.Enabled := false;
    lvLex.Columns[1].Width := 0;
    lvLex.Columns[1].MaxWidth := 0;
    lvLex.Columns[2].Width := 0;
    lvLex.Columns[2].MaxWidth := 0;
    FICDLookup := True;
  end
  else
  begin
    lvLex.Enabled := True;
    lvLex.SetFocus;
  end;
end;
begin  {processSearch body}

  FICDLookup := False;

  if ebLex.text = '' then
  begin
   InfoBox('Enter a term to search for, then click "SEARCH"', 'Information', MB_OK or MB_ICONINFORMATION);
   exit; {don't bother to drop if no text entered}
  end;

  if Extend then
    subset := ' by Extended Search'
  else
    subset := '';

  FBuildingList := True;

  ProblemList := TStringList.Create;
  try
    Screen.Cursor := crHourglass;
    updateStatus('Searching ' + subset + '...');

    v := uppercase(ebLex.text);
    if (v <> '') then
    begin
      lvLex.Clear;
      lvLex.Refresh;
      lvLex.ItemIndex := -1;
      if Extend then
        ProblemList.Assign(ProblemLexiconSearch(v, 0, True))
      else
        ProblemList.Assign(ProblemLexiconSearch(v));
    end;
    if ProblemList.count > 0 then
    begin
      Max := ProblemList[pred(ProblemList.count)]; {get max number found}
      ProblemList.delete(pred(ProblemList.count)); {shed max# found}
      SetLexList(v);
      setClientWidth(lvLex);
      updateStatus(Max + subset + '.');

      EnableExtend;
      ActiveControl := bbCan;
      if onlist >= 0 then
      begin  {search term is on return list, so highlight it}
        if MatchItem <> nil then
          onlist := lvLex.Items.IndexOf(MatchItem);
        lvLex.Items[onlist].Selected := True;
        lvLex.Items[onlist].Focused := True;
        bbOk.Enabled := True;
        ActiveControl := bbOK;
      end;
    end
    else {search results are empty}
    begin
      updateStatus('No Entries Found ' + subset + ' for "' + ebLex.text + '"');
      if TriedExtend then
      begin
        if not SaveFreetext then
          Exit;
        PLProblem := SetFreetextProblem;
        if (not Application.Terminated) and (not uInit.TimedOut) then
          if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
        Close;
      end
      else
      begin
        {if not FExtendOffered then
          InfoBox(TX_EXTEND_SEARCH, 'Term not found', MB_OK or MB_ICONINFORMATION);}
        EnableExtend;
        {processSearch(true);}
        FExtendOffered := true;
//        bbOK.Enabled := true;
      end;
    end;
  finally
    ProblemList.free;
    FBuildingList := False;
    Screen.Cursor := crDefault;
  end;
end;

function TfrmPLLex.SaveFreetext: Boolean;
var
  FTMsgDialog: TForm;
  SaveFT: Boolean;
begin
  SaveFT := False;
  FTMsgDialog := CreateFreetextMessage(UpperCase(ebLex.Text), FICDVersion);

  with FTMsgDialog do
  try
    Position := poOwnerFormCenter;

    if (ShowModal = ID_YES) then
    begin
      SaveFT := True;
    end;
    finally
      Free;

    Result := SaveFT;
  end;
end;


{function TfrmPLLex.SaveFTMessageBox(IncludeCheckBox: Boolean): Boolean;
var
  FTMsgDialog: TForm;
  NTRTCheckBox: TCheckBox;
  SaveFT: Boolean;
begin
  SaveFT := False;
  FTMsgDialog := CreateMessageDialog(TX_FREETEXT_799 + UpperCase(ebLex.Text)
     + '?', mtConfirmation, [mbYes, mbNo], mbNo);

  if IncludeCheckBox then
    NTRTCheckBox := TCheckBox.Create(FTMsgDialog) ;

  with FTMsgDialog do
  try
    Caption := 'Unresolved Entry';
    Position := poOwnerFormCenter;

    if IncludeCheckBox then
    begin
      Height := 200;
      with NTRTCheckBox do
      begin
        Parent := FTMsgDialog;
        Caption := '&Request New Term';
        Top := 140;
        Left := 55;
        Width := 120;
        Hint := 'Check this box if you would like ' + UpperCase(ebLex.Text) +
                ' to be considered for inclusion'#13#10'in future revisions of SNOMED CT.';
        ShowHint := True;
      end;
    end;

    if (ShowModal = ID_YES) then
    begin
      SaveFT := True;

      if IncludeCheckBox and NTRTCheckBox.Checked then
        RequestNTRT := True;
    end;
    finally
      Free;

    Result := SaveFT;
  end;
end;}

function TFrmPLLex.SetFreetextProblem: String;
begin
  Result := '1^' + ebLex.Text + '^799.9^^^^|' + ebLex.Text;
end;

procedure TfrmPLLex.EnableExtend;
begin
  bbSearch.Enabled := false;
  bbExtendedSearch.Visible := true;
  bbExtendedSearch.Enabled := true;
  bbExtendedSearch.setFocus;
end;

procedure TfrmPLLex.DisableExtend;
begin
  bbSearch.Enabled := true;
  bbExtendedSearch.Enabled := false;
end;

procedure TfrmPLLex.EnableFreeText;
begin
  bbFreetext.Visible := true;
  bbFreetext.Enabled := true;
end;

procedure TfrmPLLex.DisableFreeText;
begin
  bbFreetext.Enabled := false;
  bbFreetext.Visible := false;
end;

procedure TfrmPLLex.FormShow(Sender: TObject);
begin
  ebLex.setfocus;
  RequestNTRT := False;
  if FSuppressCodes then
  begin
    lvLex.Columns[1].Width := 0;
    lvLex.Columns[1].MaxWidth := 0;
    lvLex.Columns[2].Width := 0;
    lvLex.Columns[2].MaxWidth := 0;
  end;
  CenterForm(lvLex, lvLex.ClientWidth);
  if FSuppressCodes then
     lvLex.Columns[0].MinWidth := lvLex.Columns[0].Width;
end;

procedure TfrmPLLex.lvLexChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
  begin
    bbOK.Enabled := false;
    bbOK.Default := false;
  end
  else
  begin
    bbOK.Enabled := true;
    bbOK.Default := true;
    bbSearch.Default := false;
  end;
end;

procedure TfrmPLLex.lvLexClick(Sender: TObject);
begin
  inherited;
  bbOK.Enabled := true;
  bbOKClick(sender);
end;

procedure TfrmPLLex.lvLexCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Format, i: Integer;
  Left: Array[0..2] of Integer;
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

procedure TfrmPLLex.lvLexEnter(Sender: TObject);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

procedure TfrmPLLex.lvLexExit(Sender: TObject);
begin
  inherited;
  if (lvLex.ItemIndex < 0) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

function TfrmPLLex.lvLexGridWidth(lv: TListView): Integer;
var
  i, w: Integer;
begin
  w := 0;
  for i := 0 to lv.Columns.Count - 1 do
    w := w + lv.Column[i].Width;

  Result := w;
end;

procedure TfrmPLLex.lvLexInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: string);
begin
  inherited;
  // Only show hint if caption is less than width of Column[0]
  if TextWidthByFont(Font.Handle, Item.Caption) < (Sender as TListview).Column[0].Width then
    InfoTip := '';
end;

end.

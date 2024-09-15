unit fProbLex;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ORFn, uProbs, StdCtrls, Buttons, ExtCtrls, ORctrls, uConst,
  fAutoSz, uInit, fBase508Form, VA508AccessibilityManager, Grids, fProbFreetext,
  ComCtrls, Windows, rPCE, mTreeGrid, VA508AccessibilityRouter;

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
    bbFreetext: TBitBtn;
    tgfLex: TTreeGridFrame;
    procedure EnableExtend;
    procedure DisableExtend;
    procedure EnableFreeText;
    procedure DisableFreeText;
    procedure bbOKClick(Sender: TObject);
    procedure bbCanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ebLexKeyPress(Sender: TObject; var Key: Char);
    procedure bbSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbExtendedSearchClick(Sender: TObject);
    procedure ebLexChange(Sender: TObject);
    procedure setClientWidth(tgf: TTreeGridFrame);
    procedure CenterForm(tgf: TTreeGridFrame; w: Integer);
    procedure bbFreetextClick(Sender: TObject);
    procedure tgfLextvChange(Sender: TObject; Node: TTreeNode);
    procedure tgfLextvEnter(Sender: TObject);
    procedure tgfLextvExit(Sender: TObject);
    procedure tgfLextvDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FExtendOffered: Boolean;
    FSuppressCodes: Boolean;
    FICDLookup: Boolean;
    FBuildingList: Boolean;
    FCenteringForm: Boolean;
    FICDVersion: String;
    FProblemNOS: String;
    FContinueNOS: String;
    FI10Active: Boolean;
    procedure SetICDVersion(ADate: TFMDateTime = 0);
    procedure updateStatus(status: String);
    procedure processSearch(Extend: Boolean);
    procedure SetColumnTreeModel(ResultSet: TStrings);
    function SaveFreetext: Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure SetSearchString(sstring: String);
    function SetFreetextProblem: String;
  end;


implementation

uses
 fProbs, rProbs, fProbEdt, uCore, rCore, VAUtils;

{$R *.DFM}

var
 ProblemNOSs: TStringList;
 TriedExtend: Boolean = false;
 InitSearch: Boolean = false; // dont want to speak while searching

const
  TX799 = '799.9';
  TX_CONTINUE_799 = 'The term you selected is not yet mapped to an ICD-9-CM code. ' +
                    'If you select this term, an ICD-9-CM code of 799.9 will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-9-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TXR69 = 'R69.';
  TX_CONTINUE_R69 = 'The term you selected is not yet mapped to an ICD-10-CM code. ' +
                    'If you select this term, an ICD-10-CM code of R69. will be entered into ' +
                    'the system and your selected term will be sent for review to be mapped ' +
                    'to an ICD-10-CM code. Until that process is completed, you will not be able ' +
                    'to choose your selected term from the Encounter Form pick list.' + CRLF + CRLF +
                    'Use ';
  TX_FREETEXT_799  = 'A suitable term was not found based on user input and current defaults. ' +
                     'If you proceed with this nonspecific term, an ICD code of "799.9 - OTHER ' +
                     'UNKNOWN AND UNSPECIFIED CAUSE OF MORBIDITY OR MORTALITY" will ' +
                     'be filed.' + CRLF + CRLF + 'Use ';
  TX_EXTEND_SEARCH = 'A suitable term was not found in the Problem List subset of SNOMED CT. ' +
                     'If you''d like to extend your search to include the entire Clinical ' +
                     'Findings Hierarchy of SNOMED CT, click the Extend Search button. ';
  TX_CHOOSE        = 'You must select a valid term to identify your patient''s problem. Either click ' +
                     'on a term from the list, or click on the Extend Search button, to extend your ' +
                     'search to include the entire Clinical Findings Hierarchy of SNOMED CT.';
  SUPPRESS_CODES = False;

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
  if ScreenReaderSystemActive then
      GetScreenReader.Speak(lblStatus.caption);
end;

procedure TfrmPLLex.SetICDVersion(ADate: TFMDateTime = 0);
begin
  FICDVersion := Encounter.GetICDVersion;
  tgfLex.TargetTitle := Piece(FICDVersion, '^', 2) + ':  ';
  if Piece(FICDVersion, '^', 1) = 'ICD' then
  begin
    FProblemNOS := TX799;
    FContinueNOS := TX_CONTINUE_799;
    FI10Active := False;
    tgfLex.ShowTargetCode := True;
  end
  else
  begin
    FProblemNOS := TXR69;
    FContinueNOS := TX_CONTINUE_R69;
    FI10Active := True;
    tgfLex.ShowTargetCode := False;
  end;
end;

procedure TfrmPLLex.bbOKClick(Sender: TObject);

function setProblem: String;
var
  x, y: String;
  i: integer;
begin
  x := String(tgfLex.SelectedNode.Data);
  y := Piece(x, U, 2);
  i := Pos(' *', y);
  if i > 0 then y := Copy(y, 1, i - 1);
  SetPiece(x, U, 2, y);
  // e.g., Result = 7030665^Atrial arrhythmia^427.9^2566^SNOMED CT^17366009^29361012^ICD-9-CM|arrhyth
  Result := x + '|' + ebLex.Text;
end;

begin
  {nothing entered, nothing selected - bail out}
  if (ebLex.Text = '') and (tgfLex.SelectedNode = nil) and (tgfLex.tv.Items.Count = 0) then
    Exit
  {nothing selected, or search returned void - suggest extended search}
  else if ((tgfLex.SelectedNode = nil) or (tgfLex.tv.Items.Count = 0)) then
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
        if (tgfLex.tv.Items.Count = 0) then
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
    Exit;
  end
  {else if TriedExtend and ((tgfLex.SelectedNode.Code = '')
       or  ((tgfLex.SelectedNode.TargetCode = FProblemNOS)
       and (ProblemNOSs.IndexOf(tgfLex.SelectedNode.Code) < 0))) then
  begin
    if (InfoBox(FContinueNOS + UpperCase(tgfLex.SelectedNode.Text) + '?', 'Unmapped Problem Selected',
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
    PLProblem := setProblem;
  end}
  else
    PLProblem := setProblem;

  {prevents GPF if system close box is clicked while frmDlgProbs is visible}
  if (not Application.Terminated) and (not uInit.TimedOut) then
     if Assigned(frmProblems) then PostMessage(frmProblems.Handle, UM_PLLex, 0, 0);
  Close;
end;

procedure TfrmPLLex.bbCanClick(Sender: TObject);
begin
 PLProblem:='';
 close;
end;

procedure TfrmPLLex.FormCreate(Sender: TObject);
var
  ADate: TFMDateTime;
begin
  ADate := 0;
  FExtendOffered := False;
  FBuildingList := False;
  FCenteringForm := False;
  FICDLookup := False;
  FSuppressCodes := PLUser.usSuppressCodes;
  PLProblem := '';
  ProblemNOSs := TStringList.Create;
  ResizeAnchoredFormToFont(self);
  if not ((Encounter.VisitCategory = 'E') or (Encounter.VisitCategory = 'H')
    or (Encounter.VisitCategory = 'D')) then
      ADate := Encounter.DateTime;
  SetICDVersion(ADate);
  tgfLex.HorizPanelSpace := 8;
  tgfLex.VertPanelSpace := 4;

  tgfLex.DefTreeViewWndProc := tgfLex.tv.WindowProc;
  tgfLex.tv.WindowProc := tgfLex.TreeViewWndProc;
end;

procedure TfrmPLLex.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ProblemNOSs);
  inherited;
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
  end;
end;

procedure TfrmPLLex.ebLexChange(Sender: TObject);
begin
  inherited;
  bbSearch.Default := True;
  bbOK.Default := False;
  DisableExtend;
  DisableFreeText;
  if tgfLex.tv.Items.Count > 0 then
  begin
    tgfLex.tv.Selected := nil;
    tgfLex.tv.Items.Clear;
    updateStatus('');
    CenterForm(tgfLex, Constraints.MinWidth);
  end;
end;

procedure TfrmPLLex.setClientWidth(tgf: TTreeGridFrame);
var
  i, maxw, tl, maxtl: integer;
  ctn: TLexTreeNode;
begin
  maxtl := 0;
  for i := 0 to pred(tgf.tv.Items.Count) do
  begin
    ctn := tgf.tv.Items[i] as TLexTreeNode;
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
    CenterForm(tgf, maxw);
  end;
end;

procedure TfrmPLLex.SetSearchString(sstring: String);
begin
  ebLex.Text := sstring;
  Invalidate;
end;

procedure TfrmPLLex.CenterForm(tgf: TTreeGridFrame; w: Integer);
var
  wdiff, mainw: Integer;
begin
  FCenteringForm := True;
  mainw := Application.MainForm.Width;

  if w > mainw then
  begin
    w := mainw;
  end;

  self.ClientWidth := w + (tgf.Width - tgf.ClientWidth) + (pnlList.Padding.Left + pnlList.Padding.Right);

  wdiff := ((mainw - self.Width) div 2);
  self.Left := Application.MainForm.Left + wdiff;

  invalidate;
  FCenteringForm := False;
end;

procedure TfrmPLLex.tgfLextvChange(Sender: TObject; Node: TTreeNode);
Var
 ReaderTxt: TStringList;
begin
  inherited;
  tgfLex.tvChange(Sender, Node);
  if (tgfLex.SelectedNode = nil) then
  begin
    bbOK.Enabled := false;
    bbOK.Default := false;
  end
  else
  begin
    bbOK.Enabled := true;
    bbOK.Default := true;
    bbSearch.Default := false;

    if not InitSearch then
    begin
     ReaderTxt := TStringList.Create;
     try
     if ScreenReaderSystemActive then
      if tgfLex.mmoDesc.visible then
       ReaderTxt.Add('Description: ' + tgfLex.mmoDesc.Lines.Text);
      if tgfLex.mmoCode.visible then
       ReaderTxt.Add(tgfLex.CodeTitle + ' '+  tgfLex.mmoCode.Lines.Text);
      if tgfLex.pnlTargetCodeSys.Visible then

      //if tgfLex.mmoTargetCode.visible then
       ReaderTxt.Add(tgfLex.TargetTitle + ' ' + tgfLex.mmoTargetCode.Lines.Text);

       GetScreenReader.Speak(ReaderTxt.Text);
     finally
       ReaderTxt.Free;
     end;
    end;
  end;
end;

procedure TfrmPLLex.tgfLextvDblClick(Sender: TObject);
begin
  inherited;
  bbOK.Enabled := true;
  bbOKClick(sender);
end;

procedure TfrmPLLex.tgfLextvEnter(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

procedure TfrmPLLex.tgfLextvExit(Sender: TObject);
begin
  inherited;
  if (tgfLex.SelectedNode = nil) then
    bbOK.Enabled := false
  else
    bbOK.Enabled := true;
end;

procedure TfrmPLLex.bbSearchClick(Sender: TObject);
begin
  TriedExtend := false;
  ProblemNOSs.Clear;
  DisableFreeText;
  InitSearch := true;
  processSearch(false);
  InitSearch := false;
end;

procedure TfrmPLLex.SetColumnTreeModel(ResultSet: TStrings);
var
  i: Integer;
  Node: TLexTreeNode;
  RecStr, Desc: String;
begin
  //  1     2        3      4       5       6         7          8     9       10
  //VUID^SCT TEXT^ICDCODE^ICDIEN^CODE SYS^CONCEPT^DESIGNATION^ICDVER^PARENT^FULL DESCRIPTION
  tgfLex.tv.Items.Clear;
  tgfLex.tv.Refresh;

  for i := 0 to ResultSet.Count - 1 do
  begin
    RecStr := ResultSet[i];
    Desc := Piece(RecStr, '^', 10);
    if Desc = '' then
      Desc := Piece(RecStr, '^', 2);
    if Piece(RecStr, '^', 9) = '' then
      Node := (tgfLex.tv.Items.Add(nil, Desc)) as TLexTreeNode
    else
      Node := (tgfLex.tv.Items.AddChild(tgfLex.tv.Items[(StrToInt(Piece(RecStr, '^', 9))-1)], Desc)) as TLexTreeNode;

    Node.ResultLine := RecStr;
    Node.VUID := Piece(RecStr, '^', 1);
    Node.Text := Desc;
    Node.CodeDescription := Piece(RecStr, '^', 2);
    Node.CodeFullDescription := Desc;
    Node.CodeIEN := Piece(RecStr, '^', 4);
    Node.CodeSys := Piece(RecStr, '^', 5);
    Node.Code := Piece(RecStr, '^', 6);
    Node.TargetCode := Piece(RecStr, '^', 3);
    Node.TargetCodeIEN := Piece(RecStr, '^', 4);
    Node.TargetCodeSys := Piece(RecStr, '^', 8);

    if Piece(RecStr, '^', 9) <> '' then
      Node.ParentIndex := IntToStr(StrToInt(Piece(RecStr, '^', 9)) - 1);

    //Data = pointer to RecStr
    Node.Data := Pointer(RecStr);

    if Piece(RecStr, '^', 1) = 'icd' then
    begin
      ebLex.SelectAll;
      ebLex.SetFocus;
      tgfLex.tv.Enabled := false;
      FICDLookup := True;
    end
    else
    begin
      tgfLex.tv.Enabled := True;
    end;
  end;
  //sort treenodes
  tgfLex.tv.AlphaSort(True);
end;

procedure TfrmPLLex.processSearch(Extend: Boolean);
const
  TX_SRCH_REFINE1 = 'Your search ';
  TX_SRCH_REFINE2 = ' matched ';
  TX_SRCH_REFINE3 = ' records, too many to display.' + CRLF + CRLF + 'Suggestions:' + CRLF +
                    #32#32#32#32#42 + '   Refine your search by adding more words' + CRLF + #32#32#32#32#42 + '   Try different keywords';
  MaxRec = 5000;
var
  aDest:TStrings;
  ProblemList: TStringList;
  v, Max, subset: string;
  Match: TLexTreeNode;
  SvcCat: Char;
  DateOfInterest: TFMDateTime;
  FreqOfText: integer;
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
    FreqOfText := GetFreqOfText(v);
    if FreqOfText > MaxRec then
      begin
        InfoBox(TX_SRCH_REFINE1 + #39 + v + #39 + TX_SRCH_REFINE2 + IntToStr(FreqOfText) + TX_SRCH_REFINE3,'Refine Search', MB_OK or MB_ICONINFORMATION);
        lblStatus.Caption := '';
        Exit;
      end;

    SvcCat := Encounter.VisitCategory;
    if (SvcCat = 'E') or (SvcCat = 'H') then
      DateOfInterest := FMNow
    else
      DateOfInterest := Encounter.DateTime;

    if (v <> '') then
    begin
      aDest := TSTringList.Create;
      try
        if Extend then
          ProblemLexiconSearch(aDest,v, DateOfInterest, True)
        else
          ProblemLexiconSearch(aDest, v, DateOfInterest);
        ProblemList.Assign(aDest);
      finally
        aDest.Free;
      end;
    end;
    if ProblemList.count > 0 then
    begin
      Max := ProblemList[pred(ProblemList.count)]; {get max number found}
      ProblemList.delete(pred(ProblemList.count)); {shed max# found}
      SetColumnTreeModel(ProblemList);
      SetClientWidth(tgfLex);
      if ProblemList.Count < 1 then
        Max := 'Code search failed';
      UpdateStatus(Max + subset + '.');

      EnableExtend;
      ActiveControl := bbCan;

      if Max = 'Code search failed' then
      begin
       bbOk.Enabled := False;
       Exit;
      end;
      Match := tgfLex.FindNode(v);

      if Match <> nil then
      begin
        bbOk.Enabled := True;
      end
      else
      begin
        tgfLex.tv.Items[0].MakeVisible;
      end;
      if Piece(ProblemList.Strings[0],U,1) = 'icd' then
        begin
          bbOK.Enabled := False;
          bbExtendedSearch.Enabled := False;
        end
      else
        begin
          ActiveControl := tgfLex.tv;
          tgfLex.tv.Items[0].Selected := False;
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
        EnableExtend;
        FExtendOffered := true;
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

function TFrmPLLex.SetFreetextProblem: String;
var
  ICDCode: String;
begin
  if FI10Active then ICDCode := 'R69.' else ICDCode := '799.9';
  Result := '1^' + ebLex.Text + '^' + ICDCode + '^^^^|' + ebLex.Text;
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
    tgfLex.ShowCode := False;
    tgfLex.ShowTargetCode := False;
  end
  else
  begin
    tgfLex.ShowCode := True;
    tgfLex.ShowTargetCode := FI10Active;
  end;
  tgfLex.ShowDescription := True;

  CenterForm(tgfLex, tgfLex.ClientWidth);
end;

end.

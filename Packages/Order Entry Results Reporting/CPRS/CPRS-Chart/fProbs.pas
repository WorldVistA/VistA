unit fProbs;
{$O-}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, Menus, ORCtrls, Buttons, uProbs,
  Grids, Vawrgrid, ORfn, uCore, fProbEdt, uConst, ComCtrls,
  VA508AccessibilityManager, VAUtils, fBase508Form;

type
  TfrmProblems = class(TfrmHSplit)
    mnuProbs: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartCover: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    Z3: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActInactivate: TMenuItem;
    mnuActRemove: TMenuItem;
    mnuActVerify: TMenuItem;
    Z4: TMenuItem;
    mnuActAnnotate: TMenuItem;
    Z1: TMenuItem;
    mnuViewActive: TMenuItem;
    mnuViewBoth: TMenuItem;
    popProb: TPopupMenu;
    popChange: TMenuItem;
    popInactivate: TMenuItem;
    popRestore: TMenuItem;
    popRemove: TMenuItem;
    popVerify: TMenuItem;
    N36: TMenuItem;
    popAnnotate: TMenuItem;
    N37: TMenuItem;
    pnlProbList: TORAutoPanel;
    pnlProbCats: TPanel;
    lblProbCats: TLabel;
    lstCatPick: TORListBox;
    pnlProbEnt: TPanel;
    pnlProbDlg: TPanel;
    wgProbData: TCaptionListBox;
    mnuViewInactive: TMenuItem;
    mnuViewRemoved: TMenuItem;
    N1: TMenuItem;
    mnuActRestore: TMenuItem;
    mnuViewFilters: TMenuItem;
    N2: TMenuItem;
    lblProbList: TOROffsetLabel;
    pnlView: TPanel;
    N3: TMenuItem;
    popViewDetails: TMenuItem;
    lstView: TORListBox;
    lblView: TOROffsetLabel;
    N4: TMenuItem;
    mnuActDetails: TMenuItem;
    bbNewProb: TORAlignButton;
    lblProbEnt: TLabel;
    mnuViewSave: TMenuItem;
    mnuViewRestoreDefault: TMenuItem;
    mnuViewComments: TMenuItem;
    sptProbPanel: TSplitter;
    pnlButtons: TPanel;
    bbOtherProb: TORAlignButton;
    bbCancel: TORAlignButton;
    pnlProbs: TPanel;
    lblProblems: TLabel;
    lstProbPick: TORListBox;
    edProbEnt: TCaptionEdit;
    mnuChartSurgery: TMenuItem;
    HeaderControl: THeaderControl;
    mnuViewInformation: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewReminders: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    mnuViewPostings: TMenuItem;
    mnuOptimizeFields: TMenuItem;
    procedure mnuChartTabClick(Sender: TObject);
    procedure lstProbPickClick(Sender: TObject);
    procedure lstProbPickDblClick(Sender: TObject);
    procedure lstCatPickClick(Sender: TObject);
    procedure lstProbActsClick(Sender: TObject);
    procedure pnlRightResize(Sender:TObject);
    procedure pnlProbEntResize(Sender: TObject);
    procedure wgProbDataClick(Sender: TObject);
    procedure wgProbDataDblClick(Sender: TObject);
    procedure edProbEntKeyPress(Sender: TObject; var Key: Char);
    procedure bbOtherProbClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure lstViewClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuViewSaveClick(Sender: TObject);
    procedure mnuViewRestoreDefaultClick(Sender: TObject);
    procedure mnuViewCommentsClick(Sender: TObject);
    procedure wgProbDataMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure wgProbDataDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure HeaderControlSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure lstViewExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure pnlRightExit(Sender: TObject);
    procedure bbNewProbExit(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure mnuOptimizeFieldsClick(Sender: TObject);
    procedure HeaderControlSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure HeaderControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HeaderControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function getTotalSectionsWidth : integer;
    procedure setSectionWidths;
    procedure sptHorzMoved(Sender: TObject);
  private
    FContextString: string;
    FFilterString: string;
    FI10Active: Boolean;
    FAllProblems: TStringList;      //Unfiltered list of problems
    FProblemsVisible: TStringList;  //Parallels FAllProblems.  "Y" for visible
    FItemData: TStringList;  //Parallels Grid.  String representation of integer indexes into FAllProblems
    // FProblemsVisible[FItemData[i]] = 'Y'
    FWarningShown: boolean;
    FOldFramePnlPatientExit: TNotifyEvent;
  //  FMousing: TDateTime;
    FSilent: boolean;
    procedure frmFramePnlPatientExit(Sender: TObject);
    procedure UMCloseProblem(var Message:TMessage); message UM_CLOSEPROBLEM; {pdr}
    procedure ApplyViewFilters;
//    procedure UMPLFilter(var Message:TMessage); message UM_PLFILTER; {pdr}
    procedure UMPLLexicon(var Message:TMessage); message UM_PLLEX; {pdr}
    procedure GetRowCount;
    procedure RefreshList;
    procedure SetGridPieces(Pieces: string);
    procedure ShowPnlView();
    function PlainText( MString: string): string;
    function MString( index: integer): string;
  public
    function  AllowContextChange(var WhyNot: string): Boolean; override;
    procedure LoadProblems;
    procedure LoadUserCats(AList:Tstringlist);
    procedure LoadUserProbs(AList:TstringList);
    procedure AddProblem;
    procedure EditProblem(const why:char);
    procedure LoadPatientParams(AList:TstringList);
    procedure LoadUserParams(Alist:TstringList);
    procedure UpdateProblem(const why:char;Line: string;AllProblemsIndex:integer);
    procedure RestoreProblem;
    procedure LoadPatientProblems(AList:TstringList;const status:char;init:boolean);
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure NoRowSelected;
    procedure RowSelected;
    procedure ClearGrid;
    procedure RequestPrint; override;
    procedure SetFontSize( NewFontSize: integer); override;
    function HighlightDuplicate( NewProb: string; const Msg: string;
      DlgType: TMsgDlgType; Action: string): boolean;
    property Silent: Boolean read FSilent write FSilent;
  end;

  function EncounterPresent: Boolean;

const
  TX_PROV_LOC        = 'A provider and location must be selected before' +  #13#10 +
                       'entering or making any change to a problem.';
  TC_PROV_LOC        = 'Incomplete Information';
  TX_INVALID_PATIENT = 'Problem list is unavailable:  Patient DFN is undefined.';
  TC_NO_PATIENT      = 'No patient is selected';
  TX_INACTIVE_CODE_V = 'references an inactive ICD code, and must be updated'  + #13#10 +
                       'using the ''Change'' option before it can be verified.';
  TC_INACTIVE_CODE   = 'Inactive Code';
  TX_INACTIVE_ICODE  = 'This problem references an inactive ICD code,' + #13#10 +
                       'and must be updated using the ''Change'' option.';
  TC_INACTIVE_ICODE  = 'Inactive ICD code';
  TX_INACTIVE_SCODE  = 'This problem references an inactive SNOMED CT code,' + #13#10 +
                       'and must be updated using the ''Change'' option.';
  TC_INACTIVE_SCODE  = 'Inactive SNOMED CT code';
  TX_ADD_REMOVED     = 'Cannot add to the "Removed Problem List"';
  TC_ADD_REMOVED     = 'Unable to add';

  RPT_PROBLIST  = 21;
  CT_PROBLEMS   = 2;

  // GridColWidths[i] = 0 for columns that are always hidden
  // GridColWidths[i] = -1 for one (and only one) adjustable column
  GridColWidths: Array[0..15] of integer =(0, 5, -1, 9, 9, 0, 12, 12, 12, 0, 0, 0, 0, 0, 0, 0);

  type
  arOrigSecWidths = array[0..15] of integer;

var
  frmProblems: TfrmProblems;
  dlgProbs:TfrmdlgProb;
  gFontHeight: Integer;
  gFontWidth: Integer;
  gFixedWidth: Integer;
  origWidths: arOrigSecWidths;

implementation

uses fFrame, fProbFlt, fProbLex, rProbs, rcover, fCover, fRptBox, rCore,
     fProbCmt, fEncnt, fReportsPrint, fReports, rPCE, DateUtils, VA2006Utils,
     VA508AccessibilityRouter;

{$R *.DFM}

function TfrmProblems.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := inherited AllowContextChange(WhyNot);  // sets result = true
  //if dlgProbs <> nil then Result := dlgProbs.OkToQuit;
  //if dlgProbs <> nil then dlgProbs.bbQuitClick(Self);
  //need to check here and set to false if quit was cancelled or true if accepted

  if dlgProbs <> nil then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
    '1': begin
           WhyNot := 'Changes to current problem will be discarded.';
           Result := False;
         end;
    '0': begin
           if WhyNot = 'COMMIT' then
             begin
               FSilent := True;
               dlgProbs.Silent := True;
               dlgProbs.bbQuitClick(Self);
             end
           else
             begin
               dlgProbs.bbQuitClick(Self);
               Result := dlgProbs.CanQuit;
             end;
         end;
    end;
end;

procedure TfrmProblems.ClearPtData;
begin
  inherited ClearPtData;
  ClearGrid;
  lblProbList.Caption := '';
  wgProbData.Caption := lblProbList.Caption;
  FWarningShown := False;
end;

procedure TfrmProblems.DisplayPage;
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_PROBLEMS;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  if InitPatient then
    begin
      FWarningShown := False;
      if PLUser <> nil then
        begin
          PLUser.Destroy;
          PLUser := nil;
        end;
      //ClearPtData;
      ShowPnlView;
      pnlButtons.SendToBack;
      pnlButtons.Hide;
      LoadProblems ;
    end;
  //CQ #11529: 508 PL tab - defaults the focus to the New Problem button ONLY upon switching to the Probs tab.  {TC}
  if TabCtrlClicked and (ChangingTab = CT_PROBLEMS) then ProbTabClicked := True;
  if (bbNewProb.CanFocus) and (not pnlButtons.Visible) and ((not PTSwitchRefresh) or ProbTabClicked) then bbNewProb.SetFocus;
  if PTSwitchRefresh then PTSwitchRefresh := False;
  if TabCtrlClicked then TabCtrlClicked := False;
  if ProbTabClicked then ProbTabClicked := False;
end;

procedure TfrmProblems.mnuChartTabClick(Sender: TObject);
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

{------------------------ pdr - Problem list gadget event methods ------------}
procedure TfrmProblems.lstCatPickClick(Sender: TObject);
var
  AList:TStringList;
begin
  AList:=TStringList.create;
  try
    LoadUserProbs(AList);
  finally
    AList.free;
  end;
end;

procedure TfrmProblems.lstProbActsClick(Sender: TObject);
var
  act, i, j: integer;
  Alist: TstringList;
  cmt, ProblemIFN, ut, x, line, comments: string ;
  ProbRec: TProbRec ;
  ContextString, FilterString: string;
  FilterChanged: boolean;
  AllProblemsIndex: integer;
begin
  if PLPt = nil then
  begin
    InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  act := TComponent(Sender).tag ;
  if act = 0 then exit;
   // make sure a visit (time & location) is available before creating the problem
  case act of
    100: {add new problem}
      begin
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox(TX_ADD_REMOVED, TC_ADD_REMOVED, MB_ICONINFORMATION or MB_OK);
            exit;
          end;
        if not EncounterPresent then exit;
        PLProblem := '';
        AList := TStringList.Create;
        pProviderID := Encounter.Provider;
        pProviderName := Encounter.ProviderName ;
        try
          if pnlView.Visible then
            begin
              pnlView.SendToBack;
              pnlProbCats.Show;
              pnlProbCats.BringToFront;
              pnlButtons.Visible := True;
              if PLUser.usUseLexicon then
                begin
                  lblProbCats.Visible := True;
                  lstCatPick.Visible  := True;
                  lblProblems.Visible := True;
                  lstProbPick.Visible := True;
                  lstCatPick.Clear ;
                  LoadUserCats(AList);
                  bbOtherProb.Visible := True;
                  pnlProbList.Visible := True;
                  lstCatPick.TabStop := True;
                  lstProbPick.TabStop := True;
                  lstView.TabStop := False;
                  bbNewProb.TabStop := False;
                  pnlProbList.BringToFront ;
                  pnlProbCats.ClientHeight := (pnlProbList.ClientHeight - pnlButtons.ClientHeight) div 2;
                  pnlProbEnt.Visible  := False;
                  pnlProbEnt.SendToBack;
                  if (lstCatPick.Items.Count = 1) then
                    if Piece(lstCatPick.Items[0], U, 1) = '-1' then
                      bbOtherProbClick(Self);
                end
              else
                begin
                  bbOtherProb.Visible := False;
                  edProbEnt.Visible := True;
                  lblProbEnt.Visible := True;
                  pnlProbEnt.Visible  := True;
                  pnlProbEnt.BringToFront;
                  pnlProbList.Visible := False;
                  lstCatPick.TabStop := False;
                  lstProbPick.TabStop := False;
                  lstView.TabStop := True;
                  bbNewProb.TabStop := True;
                  pnlProbList.SendToBack ;
                  edProbEnt.text      := '';
                  if pnlProbEnt.Visible then edProbEnt.SetFocus;
                end;
            end
          else
            begin
              if (lstProbPick.itemindex < 0) and (edProbEnt.text = '') then
                InfoBox('Select a Problem to add from lists' + #13#10 + ' on left or enter a new one ',
                  'Information', MB_OK or MB_ICONINFORMATION)
              else
                begin
                  AddProblem;
                  lstProbPick.itemindex := -1;
                end;
            end ;
        finally
          AList.Free;
        end;
      end;
    200: {Inactivate}
      begin
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox('Cannot inactivate a problem on the "Removed Problem List"',
              'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
        if (wgProbData.ItemIndex < 0) or (Piece(MString(wgProbData.itemindex), U, 3) = '') then
          InfoBox('Select a patient problem from the grid on right',
            'Information', MB_OK or MB_ICONINFORMATION)
        else
          begin
            if not EncounterPresent then exit;
            pProviderID := Encounter.Provider;
            pProviderName := Encounter.ProviderName ;
            AllProblemsIndex := 0;
            repeat
              begin
                if wgProbData.Selected[AllProblemsIndex] then
                  begin
                    Line := FAllProblems[AllProblemsIndex];
                    if CharAt(Piece(Line, U, 2), 1) = 'A' then
                      UpdateProblem('I',Line,AllProblemsIndex)
                    else
                      InfoBox('Problem "' + Trim(UpperCase(Piece(Piece(Line, U, 3), #13, 1))) + '" is already inactive.',
                      'Problem not updated', MB_ICONINFORMATION or MB_OK);
                  end;
                inc(AllProblemsIndex);
              end;
            until AllProblemsIndex >= wgProbData.Count;
            RefreshList;
          end;
        if (PlUser.usViewAct='A') then
          begin
            AList := TStringList.Create ;
            LoadPatientProblems(Alist,'A',False) ;
            NoRowSelected ;
          end;
        RefreshList;
      end;
    250: {Verify}
      begin
        if not PLuser.usVerifyTranscribed then exit ;
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox('Cannot verify a problem on the "Removed Problem List"',
              'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
        if (wgProbData.ItemIndex < 0) or (Piece(MString(wgProbData.ItemIndex), U, 3) = '') then
          InfoBox('Select a patient problem from the grid on right',
            'Information', MB_OK or MB_ICONINFORMATION)
        else
          begin
            if not EncounterPresent then exit;
            pProviderID := Encounter.Provider;
            pProviderName := Encounter.ProviderName ;
            AllProblemsIndex := 0;
            repeat
              begin
                if wgProbData.Selected[AllProblemsIndex] then
                  begin
                    Line := FAllProblems[AllProblemsIndex];
                    if Pos('#',Piece(Line, U, 2)) > 0 then
                      InfoBox('Problem "' + Trim(UpperCase(Piece(Piece(Line, U, 3), #13, 1))) + '" ' + #13#10 +
                      TX_INACTIVE_CODE_V, TC_INACTIVE_CODE, MB_ICONWARNING or MB_OK)
                    else if Pos('(u)',Piece(Line, U, 2)) = 0 then
                      InfoBox('Problem "' + Trim(UpperCase(Piece(Piece(Line, U, 3), #13, 1))) + '" is already verified.',
                      'Problem not updated', MB_ICONINFORMATION or MB_OK)
                    else
                      UpdateProblem('V',Line,AllProblemsIndex);
                  end;
                inc(AllProblemsIndex);
              end;
            until AllProblemsIndex >= wgProbData.Count;
            RefreshList;
            mnuActVerify.Enabled := False;
            popVerify.Enabled := False;
          end;
      end;
    300: {detail}
      with wgProbData do
        begin
          if ItemIndex < 0 then
            InfoBox('Select a problem from the grid for Detail Display',
              'Information', MB_OK or MB_ICONINFORMATION)
          else if StrToIntDef(Piece(MString(ItemIndex), U, 1),0)>0 then
            ReportBox(DetailProblem(StrToInt(Piece(MString(ItemIndex), U, 1))),
              Piece(Piece(MString(ItemIndex), U, 3), #13, 1), True);
        end;
    400: {edit}
      begin
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox('Cannot select a problem to edit from the "Removed Problem List"',
              'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
        if wgProbData.ItemIndex < 0 then
          InfoBox('Select a problem from the grid to Edit', 'Information', MB_OK or MB_ICONINFORMATION)
        else
          begin
            if not EncounterPresent then exit;
            pProviderID := Encounter.Provider;
            pProviderName := Encounter.ProviderName ;
            EditProblem('E');
          end
      end;
    500: {Remove}
      begin
        if not PlUser.usPrimeUser then exit ;
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox('Cannot remove from the "Removed Problem List"' +#13#10 + 'Use "Restore Problem"',
              'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
        if wgProbData.ItemIndex < 0 then
          InfoBox('Select a problem from the grid to remove', 'Information', MB_OK or MB_ICONINFORMATION)
        else
          begin
            if not EncounterPresent then exit;
            pProviderID := Encounter.Provider;
            pProviderName := Encounter.ProviderName ;
            EditProblem('R');
          end;
      end;
    550: {Restore}
      begin
        if not PlUser.usPrimeUser then exit ;
        if PlUser.usViewAct <> 'R' then
          begin
            InfoBox('View the Removed Problems Display, and select a record to restore.',
              'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
       if wgProbData.ItemIndex < 0 then
         InfoBox('Select a problem to restore from the grid on right', 'Information', MB_OK or MB_ICONINFORMATION)
       else
         begin
           if not EncounterPresent then exit;
           pProviderID := Encounter.Provider;
           pProviderName := Encounter.ProviderName ;
           RestoreProblem;
         end;
      end;
    600: {Add Comment}
      begin
        if PlUser.usViewAct = 'R' then
          begin
            InfoBox('Cannot add a comment to a removed problem', 'Information', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
        if wgProbData.ItemIndex < 0 then
          InfoBox('Select a problem to annotate from the grid on right', 'Information', MB_OK or MB_ICONINFORMATION)
        else
          begin
            if not EncounterPresent then exit;
            pProviderID := Encounter.Provider;
            pProviderName := Encounter.ProviderName ;
            AList := TStringList.Create;
            ProblemIFN := Piece(MString(wgProbData.ItemIndex), U, 1);
            FastAssign(EditLoad(ProblemIFN), AList) ;
            if Alist.count = 0 then
              begin
                InfoBox('No Data on Host for problem ' + ProblemIFN, 'Information', MB_OK or MB_ICONINFORMATION);
                close;
                exit;
              end;
            ProbRec:=TProbRec.Create(Alist); {create a problem object}
            try
              ProbRec.PIFN := ProblemIFN;
              if ProbRec.CmtIsXHTML then
                begin
                  InfoBox(ProbRec.CmtNoEditReason, 'Unable to add new comment', MB_ICONWARNING or MB_OK);
                  exit;
                end ;
              cmt := NewComment ;
              if (StrToInt(Piece(cmt, U, 1)) > 0) and (Piece(cmt, U, 3) <> '') then
                begin
                  ProbRec.AddNewComment(Piece(cmt, U, 3));
                  ut := '';
                  If PLUser.usPrimeUser then ut := '1';
                  FastAssign(EditSave(ProblemIFN, pProviderID, PLPt.ptVAMC, ut, ProbRec.FilerObject, ''), AList);
                  LoadPatientProblems(AList, PlUser.usViewAct[1], True);
                end ;
            finally
              Alist.Free ;
              ProbRec.Free ;
            end ;
          end ;
      end;
    700: {Active only}
      begin
        Alist := TstringList.create;
        try
          PlUser.usViewAct := 'A';
          LoadPatientProblems(Alist, 'A', False);
          SetPiece(FContextString, ';', 3, 'A');
          GetRowCount;
        finally
          Alist.free;
        end;
      end;
    800: {inactive Only}
      begin
        Alist := TstringList.create;
        try
          PlUser.usViewAct := 'I';
          LoadPatientProblems(Alist, 'I', False);
          SetPiece(FContextString, ';', 3, 'I');
          GetRowCount;
        finally
          Alist.free;
        end;
      end;
    900: {all problems display}
      begin
        Alist := TstringList.create;
        try
          PlUser.usViewAct := 'B';
          LoadPatientProblems(Alist, 'B', False);
          SetPiece(FContextString, ';', 3, 'B');
          GetRowCount;
        finally
          Alist.free;
        end;
      end;
    950: {Removed Problems Display}
      begin
        Alist := TstringList.create;
        try
          PlUser.usViewAct := 'R';
          LoadPatientProblems(Alist, 'R', False);
          SetPiece(FContextString, ';', 3, 'R');
          GetRowCount;
        finally
          Alist.free;
        end;
      end;
    975: {Select viewing filters}
      begin
        lstView.ItemIndex := -1;
        ContextString := '^;;' + PLUser.usViewAct[1] + ';' + PLUser.usViewComments;
        GetViewFilters(Font.Size, PLFilters, ContextString, FilterString, FilterChanged);
        if not FilterChanged then exit;
        FContextString := ContextString;
        FFilterString := FilterString;
        if (Piece(ContextString, ';', 3) <> PLUser.usViewAct[1]) then
          begin
            AList := TStringList.Create;
            try
              PLUser.usViewAct := Piece(ContextString, ';', 3);
              LoadPatientProblems(Alist, PLUser.usViewAct[1], False);
            finally
              AList.Free;
            end;
          end;
        if (Piece(ContextString, ';', 4) <> PLUser.usViewComments) then with FAllProblems do
          begin
            for i := 0 to Count - 1 do
              begin
                if Objects[i] = nil then continue;
                x := Piece(Piece(Strings[i], U, 3), #13, 1);
                if Piece(ContextString, ';', 4) = '1' then
                  begin
                    comments := '';
                    for j := 0 to TStringList(Objects[i]).Count - 1 do
                      comments := comments + '         ' + TStringList(Objects[i]).Strings[j] + #13#10;
                      //comments := comments + '   CMT:  ' + TStringList(Items.Objects[i]).Strings[j] + #13#10;
                    line := Strings[i];
                    SetPiece(line, U, 3, x + #13#10 + comments);
                    Strings[i] := line;
                    mnuViewComments.Checked := True;
                  end
                else
                  begin
                    line := Strings[i];
                    SetPiece(line, U, 3, x);
                    Strings[i] := line;
                    mnuViewComments.Checked := False;
                  end;
              end;
            RefreshList;
            PLUser.usViewComments := Piece(ContextString, ';', 4);
          end;
        pnlRightResize(Self);
      end ;
  end;
end;

procedure TfrmProblems.lstProbPickClick(Sender: TObject);
begin
  if PlUser.usViewAct = 'R' then exit;
  pProviderID := Encounter.Provider ;
  AddProblem;
  TListBox(sender).itemindex := -1;
end;

procedure TfrmProblems.pnlProbEntResize(Sender: TObject);
(*var
  i:integer;*)
begin
(*  for i := 0 to pred(twincontrol(sender).controlcount) do
    begin
      twincontrol(sender).controls[i].width := twincontrol(sender).width - 4;
      twincontrol(sender).controls[i].left := 2;
    end;*)
end;

procedure TfrmProblems.wgProbDataClick(Sender: TObject);
var
  S: string;
begin
  pnlRight.font.color := self.font.color;
  S := MString(wgProbData.ItemIndex);
  //pnlRight.caption := Piece(Piece(S, U , 3), #13, 1); //fixes part (b) of CQ #15531: 508 Problems Tab [CPRS v28.1] {TC}
  if (Piece(S, U, 1) = '') or
     (Pos('No data available',  Piece(S, U, 2)) > 0) or
     (Pos('No problems found.', Piece(S, U, 2)) > 0)
   then NoRowSelected else RowSelected ;
end;

procedure TfrmProblems.wgProbDataDblClick(Sender: TObject);
begin
  lstProbActsClick(mnuActDetails);
end;

procedure TfrmProblems.lstProbPickDblClick(Sender: TObject);
begin
  if PlUser.usViewAct = 'R' then exit;
  pProviderID := Encounter.Provider ;
  AddProblem;
  TListBox(sender).itemindex := -1;
end;

procedure TfrmProblems.edProbEntKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then lstProbPickDblClick(sender);
end;

procedure TfrmProblems.bbOtherProbClick(Sender: TObject);
var
  frmPLLex: TfrmPLLex;
begin
  if not PLUser.usUseLexicon then exit; {don't allow lookup}
  frmPLLex := TFrmPLLex.create(Application);
  try
    frmPLLex.showmodal;
  finally
    frmPLLex.Free;
  end;
end;

procedure TfrmProblems.UMCloseProblem(var Message:TMessage);
begin
  pnlView.BringToFront ;
  ShowPnlView;
  bbCancel.Enabled := True ;
  bbOtherProb.enabled := true; {restore lexicon access}
  pnlButtons.Visible := False;
  pnlButtons.SendToBack;
  pnlProbEnt.Visible :=  (not PLUser.usUseLexicon) ;
  if PLuser.usViewAct = 'A' then
    pnlRight.caption := ACTIVE_LIST_CAP
  else if PLuser.usViewAct = 'I' then
    pnlRight.caption := INACTIVE_LIST_CAP
  else if PLuser.usViewAct = 'B' then
    pnlRight.caption := BOTH_LIST_CAP
  else if PLuser.usViewAct = 'R' then
    pnlRight.caption := REMOVED_LIST_CAP
  else
    begin
      PlUser.usViewAct := 'A';
      pnlRight.caption := ACTIVE_LIST_CAP;
    end;
  if dlgProbs <> nil then dlgProbs:=nil;
end;

//procedure TfrmProblems.UMPLFilter(var Message:TMessage);
procedure TfrmProblems.ApplyViewFilters;
var
  i: integer;
  wantnulls: boolean;
begin
  {the following escape is necessitated by change in default row height which
   corrupts display of hidden rows in wgProbData. Since the default rowheight
   is changed with each change in screen size, this gets called once before
   PLFilters is created}
  if PLFilters = nil then exit; {not initialized}
  {show all rows}
  wantnulls := (PLFilters.ProviderList.indexof('-1') > -1);
  for i := 0 to pred(FProblemsVisible.count) do FProblemsVisible[i] := 'Y';

  {filter for provider}
  if PLFilters.ProviderList.Count > 0 then
    if PLFilters.ProviderList[0] <> '0' then { 0 signifies all }
      for i := 0 to pred(FAllProblems.count) do
        if Piece(FAllProblems[i], U, 1) <> '' then {don't want to disappear empty rows}
          if (PLFilters.ProviderList.indexof(Piece(FAllProblems[i], U, 10)) < 0) or
             ((Piece(FAllProblems[i], U, 10) = '') and (not wantnulls)) then
            FProblemsVisible[i] := 'N';

  if PLUser.usCurrentView = PL_UF_VIEW then exit; {Bail out - no filtering by Loc}

  {conditionally filter for clinic(s) - may be multiple selected}
  if PLUser.usCurrentView = PL_OP_VIEW then
    begin
      wantnulls := (PLFilters.ClinicList.indexof('-1') > -1);
      if PLFilters.ClinicList.Count = 0 then exit;
      if PLFilters.ClinicList[0] <> '0' then { 0 signifies all }
        for i := 0 to pred(FAllProblems.count) do
          if (Piece(FAllProblems[i], U, 1) <> '') and          {don't want to disappear empty rows}
             (FProblemsVisible[i] = 'Y') then                          {don't want if already filtered}
            begin
              if (Piece(FAllProblems[i], U ,11) <> '') and       {clinic not on user list}
                       (PLFilters.ClinicList.indexof(Piece(FAllProblems[i], U, 11)) < 0) then
                FProblemsVisible[i] := 'N'
              else if ((Piece(FAllProblems[i], U, 11) = '') and (not wantnulls)) then {no clinic recorded}
                FProblemsVisible[i] := 'N';
            end;
    end
  else
  {conditionally filter for service - may be multiple selected}
    begin
      wantnulls := (PLFilters.ServiceList.indexof('-1') > -1);
      if PLFilters.ServiceList.Count = 0 then exit;
      if PLFilters.ServiceList[0] <> '0' then { 0 signifies all }
        for i := 0 to pred(FAllProblems.count) do
          if (Piece(FAllProblems[i], U, 1) <> '') and        {don't want to disappear empty rows}
            (FProblemsVisible[i] = 'Y') then                         {don't want if already filtered}
            begin
              if (Piece(FAllProblems[i], U, 12) <> '') and              {Service not on user list}
                      (PLFilters.ServiceList.indexof(Piece(FAllProblems[i], U, 12)) < 0) then
                FProblemsVisible[i] := 'N'
              else if (Piece(FAllProblems[i], U, 12) = '') and (not wantnulls) then               {no Service recorded}
                FProblemsVisible[i] := 'N';
            end;
    end;
end;

procedure TfrmProblems.GetRowCount;
var
  ShownProbs, TotalProbs: integer;
begin
  if (wgProbData.Items.Count > 0) and (Piece(wgProbData.Items[0], U, 1) <> '') then
    ShownProbs := wgProbData.Items.Count
  else
    ShownProbs := 0;

  if (FAllProblems.Count > 0) and (Piece(FAllProblems[0], U, 1) <> '') then
    TotalProbs := FAllProblems.Count
  else
    TotalProbs := 0;
    
  case PLUser.usViewAct[1] of
    'A': lblProbList.Caption := ACTIVE_LIST_CAP ;
    'I': lblProbList.Caption := INACTIVE_LIST_CAP ;
    'B': lblProbList.Caption := BOTH_LIST_CAP ;
    'R': lblProbList.Caption := REMOVED_LIST_CAP ;
  end;
  lblProbList.Caption := lblProbList.Caption + '   (' + IntToStr(ShownProbs) + ' of ' + IntToStr(TotalProbs) + ')';
  wgProbData.Caption := lblProbList.Caption;
end;


procedure TfrmProblems.UMPLLexicon(var Message:TMessage);
begin
  if PLProblem = '' then exit; {shouldn't happen but...}
  if dlgProbs = nil then AddProblem;
end;

procedure TfrmProblems.SetGridPieces( Pieces: string);
var
  i, AdjustCol, cxUsed: Integer;
  PieceSet: set of 0..High(GridColWidths);
  x: string;
begin
  PieceSet := [];
  x := Pieces;
  while x <> '' do begin
    PieceSet := PieceSet + [StrToIntDef(Piece(x, ',', 1), 1)-1];
    if Pos(',', x) = 0 then
      break;
    x := Copy(x, Pos(',',x)+1, Length(x));
  end;
  AdjustCol := 0;
  cxUsed := 0;
  for i := 0 to High(GridColWidths) do
    if i in PieceSet then
    begin
      if GridColWidths[i] > -1 then
      begin
        if GridColWidths[i] > 0 then
        begin
          HeaderControl.Sections[i].MaxWidth := 10000;
          HeaderControl.Sections[i].Width := ForChars(GridColWidths[i], gFontWidth);
          cxUsed := cxUsed + HeaderControl.Sections[i].Width;
        end
        else
        begin
          HeaderControl.Sections[i].Width := 0;
          HeaderControl.Sections[i].MaxWidth := 0;
        end;
      end
      else
        AdjustCol := i;
    end
    else
    begin
      HeaderControl.Sections[i].Width := 0;
      HeaderControl.Sections[i].MaxWidth := 0;
    end;
  HeaderControl.Sections[AdjustCol].AutoSize := True;
  HeaderControl.Sections[AdjustCol].Width := HeaderControl.Width - cxUsed;
  //mnuOptimizeFieldsClick(self);       //******** test making compression, proportional, or no spacing on resize
end;

procedure TfrmProblems.pnlRightResize(Sender: TObject);
begin
  if PLUser = nil then exit;
  if PLUser.usCurrentView = PL_IP_VIEW then
    SetGridPieces('2,3,4,5,8,9')
  else if PLUser.usCurrentView = PL_OP_VIEW then
    SetGridPieces('2,3,4,5,7');
  {have to do this to recover hidden rows}
  ApplyViewFilters;
  RefreshList;
  GetRowCount;
  //PostMessage(frmProblems.Handle, UM_PLFILTER,0,0);
end;

procedure TfrmProblems.FormCreate(Sender: TObject);
begin
  inherited;
//  FixHeaderControlDelphi2006Bug(HeaderControl);
  FAllProblems := TStringList.Create;
  FProblemsVisible := TStringList.Create;
  FItemData := TStringList.Create;
  PageID := CT_PROBLEMS;
  GetFontInfo(Canvas.Handle, gFontWidth, gFontHeight);
  FI10Active := (Piece(Encounter.GetICDVersion, U, 1) <> 'ICD');
end;

procedure TfrmProblems.LoadUserParams(Alist:TstringList);
var
  i: integer;
begin
  FastAssign(InitUser(User.DUZ), AList) ;
  //FastAssign(InitUser(Encounter.Provider), AList) ;
  PLUser := TPLUserParams.create(Alist);
  FContextString := PLUser.usDefaultContext;
  FFilterString :=  PLUser.usDefaultView + '/';
  if PLFilters <> nil then
    begin
      if PLUser.usDefaultView = 'C' then with PLFilters.ClinicList do
          for i := 0 to Count - 1 do
            if Piece(Strings[i], U, 1) <> '-1' then
              FFilterString := FFilterString + Piece(Strings[i], U, 1) + '/';
      if PLUser.usDefaultView = 'S' then with PLFilters.ServiceList do
          for i := 0 to Count - 1 do
            if Piece(Strings[i], U, 1) <> '-1' then
              FFilterString := FFilterString + Piece(Strings[i], U, 1) + '/';
    end;
  mnuViewComments.Checked := (PLUser.usViewComments = '1');
  if PLUser.usTesting then
    InfoBox('WARNING - Test User Parameters in Effect', 'Warning', MB_OK or MB_ICONWARNING);
  pnlRightResize(Self);
end;

procedure TfrmProblems.LoadPatientParams(AList:TstringList);
begin
  FastAssign(InitPt(Patient.DFN), AList) ;
  PLPt := TPLPt.create(Alist);
end;

procedure TfrmProblems.ClearGrid;
var
  i:integer;
begin
  with FAllProblems do for i := 0 to Count - 1 do
    if Objects[i] <> nil then
      begin
        TStringList(Objects[i]).Free;
        Objects[i] := nil;
      end;
  wgprobdata.Clear;
  FAllProblems.Clear;
  FProblemsVisible.Clear;
end;


procedure TfrmProblems.LoadPatientProblems(AList:TStringList; const Status:char; init:boolean);
var {init should only be true when initializing a list for a new patient}
  x, line, ver, prio, comments, cs: String;
  i, j, inactI, inactS: Integer;
  st: char;
  CmtList: TStringList;
  DateOfInterest: TFMDateTime;
  //SCCond, tmpSCstr: string;

  procedure ReverseList(Alist:TstringList);
  var
    i,j:integer;
  begin
    i:=0;
    j:=pred(Alist.count);
    while i<j do
      begin
        alist.exchange(i,j);
        inc(i);
        dec(j);
      end;
  end;

begin  {Body}
  FI10Active := (Piece(Encounter.GetICDVersion, U, 1) <> 'ICD');
  CmtList := TStringList.Create;
  if PLFilters=nil then {create view filter lists}
    PLFilters:=TPLFilters.create;
  try
    ClearGrid;
    inactI := 0;
    inactS := 0;
    if PLPt = nil then
      begin
        InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
        AList.Clear;
        AList.Add('No data available');
      end
    else
      begin
        st:=status;
        if st= '' then st := 'A'; {default to active list}
        if Patient.Inpatient then   //CQ 21793
          DateOfInterest := FMNow
        else
          DateOfInterest := Encounter.DateTime;
        FastAssign(ProblemList(Patient.DFN, st, DateOfInterest), AList);
      end;
    if Status = 'R' then
      SetGridPieces('3,4,5,7,8,9')
    else
      SetGridPieces('2,3,4,5,7,8,9');
    if Alist.count > 1 then Alist.delete(0); {get rid of first element - it is a list count}
    SortByPiece(AList, u, 6); { Sort by FM date/time }
    SetListFMDateTime('dddddd',AList, u, 6);      { Change FM date to MM/DD/YY  }
    SetListFMDateTime('dddddd',AList, u, 5);      { Change FM date to MM/DD/YY  }
    if PLUser.usReverseChronDisplay then {reverse chron order if required}
      ReverseList(Alist);
    {populate the grid}
    if ((Alist.Count = 1) and (pos('No data available', Alist[0]) > 0))then
      begin
        FAllProblems.Add('^^No problems found.');
        FProblemsVisible.Add('Y');
        RefreshList;
        Alist.Clear ;
        NoRowSelected;
        exit ;
      end ;
    for i := 0 to pred(Alist.count) do
    begin
      FAllProblems.Add('');
      FProblemsVisible.Add('Y');
      comments := '';
      CmtList.Clear;
      x := AList[i];
      if (Piece(x, U, 18) = '#') and CharInSet(CharAt(UpperCase(Status), 1), ['A', 'B', 'I', 'R']) and (not FI10Active) then
        begin
          ver := '#';      // inactive ICD code flag takes precedence over unverified flag
          if (Piece(x, U, 2) = 'A') then inactI := inactI + 1;
        end
      else if (Piece(x, U, 18) = '$') and CharInSet(CharAt(UpperCase(Status), 1), ['A', 'B', 'I', 'R']) then
        begin
          ver := '#';      // inactive SNOMED CT code flag takes precedence over unverified flag
          if (Piece(x, U, 2) = 'A') then inactS := inactS + 1;
        end
      else if (PlUSer.usVerifyTranscribed) and
              (Piece(x, U, 9) = 'T') then
        ver := '(u)'
      else
        ver := '   ';
      if Piece(x, U, 14) = 'A' then prio   := ' * ' else prio   := '   ' ;
      Line := '';
      SetPiece(Line, U, 2, Piece(x, U, 2) + prio + ver);
      if Piece(x, U, 15) = '1' then  //problem has comments
        begin
          FastAssign(GetProblemComments(Piece(x, U, 1)), CmtList);
          if FAllProblems.Objects[i] = nil then FAllProblems.Objects[i]:= TStringList.Create;
          FastAssign(CmtList, TStringList(FAllProblems.Objects[i]));
        end;

      SetPiece(Line, U, 3, Piece(x, U, 3));

      if Piece(x, U, 19) <> '' then
      begin
        if Piece(x, U, 20) = 'ICD' then
          cs := 'ICD-9-CM'
        else if Piece(x, U, 20) = '10D' then
          cs := 'ICD-10-CM'
        else
          cs := Piece(x, U, 20);
        SetPiece(Line, U, 3, Piece(Line, U, 3) + #13#10 + cs + ' Text: ' + MixedCase(Piece(x, U, 19)));
      end;
      if PLUser.usViewComments = '1' then
        begin
          for j := 0 to CmtList.Count-1 do
            comments := comments + '         ' + CmtList.Strings[j] + #13#10;
          SetPiece(Line, U, 3, Piece(Line, U, 3) + #13#10 + comments);
        end;
      SetPiece(Line, U, 4, Trim(Piece(x, U, 5)));                        {onset date}
      SetPiece(Line, U, 5, Trim(Piece(x, U, 6)));                        {last updated}
      SetPiece(Line, U, 7, MixedCase(Piece(Piece(x, U, 10), ';', 2)));   {location name}
      SetPiece(Line, U, 8, MixedCase(Piece(Piece(x, U, 12), ';', 2)));   {provider name}
      SetPiece(Line, U, 9, MixedCase(Piece(Piece(x, U, 13), ';', 2)));   {service name}
      {hidden cells}
      SetPiece(Line, U, 1, Piece(x, U, 1));                              {problem IEN}
      SetPiece(Line, U, 6, Piece(x, U, 7));                              {service connected status}
      SetPiece(Line, U, 11, Piece(Piece(x, U, 10), ';', 1));              {location IEN}
      SetPiece(Line, U, 13, Piece(x, U, 11));                             {loc type}
      SetPiece(Line, U, 10, Piece(Piece(x, U, 12), ';', 1));              {responsible provider IEN}
      SetPiece(Line, U, 12, Piece(Piece(x, U, 13), ';', 1));              {service IEN}
      SetPiece(Line, U, 14, Piece(x, U, 4));                              {code}
      SetPiece(Line, U, 15, Piece(x, U, 17));                             {Service-connected conditions}
      SetPiece(Line, U, 16, Piece(x, U, 18));                             {# = inactive ICD code stored with problem}
      FAllProblems[i] := Line;
    end;
    Alist.clear;
    if not init then
      SetViewFilters(Alist)
    else
      InitViewFilters(Alist);
    ApplyViewFilters;
    RefreshList;
    lstProbPick.ItemIndex := -1;
    if (ProbRec <> nil) and (ProbRec.PIFN <> '') then
      begin
        for i := 0 to wgProbData.Items.count-1 do
          if (Piece(MString(i), U, 1) = ProbRec.PIFN) then
             wgProbData.ItemIndex := i ;
        wgProbDataClick(Self);
      end
    else
      wgProbData.ItemIndex := -1;
    if (wgProbData.Items.Count > 0) and (wgProbData.ItemIndex > -1) then
      RowSelected
    else
      NoRowSelected;
    pnlRightResize(Self);
    if (not FWarningShown) and (inactI > 0) and (inactS > 0) and CharInSet(CharAt(UpperCase(Status), 1), ['A', 'B']) then
      begin
       InfoBox('There are ' + IntToStr(inactI) + ' active problem(s) flagged with a "#" as having ' +
               'inactive ICD codes as of the Encounter date. There are also ' + IntToStr(inactS) +
               ' active problem(s) flagged with a "#" as having inactive SNOMED CT codes as of ' +
               'the Encounter date. You may correct these problems using the "Change" option.',
               'Inactive ICD & SNOMED CT Codes Found', MB_ICONWARNING or MB_OK);
       FWarningShown := True;
      end
    else if (not FWarningShown) and (inactI > 0) and CharInSet(CharAt(UpperCase(Status), 1), ['A', 'B']) then
      begin
       InfoBox('There are ' + IntToStr(inactI) + ' active problem(s) flagged with a "#" as having ' +
               'inactive ICD codes as of the Encounter date. You may correct these problems using the "Change" option.',
               'Inactive ICD Codes Found', MB_ICONWARNING or MB_OK);
       FWarningShown := True;
      end
    else if (not FWarningShown) and (inactS > 0) and CharInSet(CharAt(UpperCase(Status), 1), ['A', 'B']) then
      begin
       InfoBox('There are ' + IntToStr(inactS) + ' active problem(s) flagged with a "#" as having ' +
               'inactive SNOMED CT codes as of the Encounter date. You may correct these problems ' +
               'using the "Change" option.', 'Inactive SNOMED CT Codes Found', MB_ICONWARNING or MB_OK);
       FWarningShown := True;
      end;
  finally
    CmtList.Free;
  end;
end;

procedure TfrmProblems.LoadUserCats(AList:TStringList);
begin
  if not PLUser.usUseLexicon then exit; {Bail out if not to use lexicon}
  Alist.clear;
  FastAssign(UserProblemCategories(Encounter.Provider,Encounter.Location), AList) ;
  if Alist.count = 0 then
    begin
      lstCatPick.Items.Add('-1^None defined - use OTHER') ;
      lstProbPick.Visible := False ;
      lblProblems.Visible := False ;
      exit ;
    end ;
  FastAssign(AList, lstCatPick.Items);
  lstCatPick.itemindex := 0;
  lstCatPickClick(frmProblems);
end;

procedure TfrmProblems.LoadUserProbs(AList:TStringList);
var
  catien: string;
begin
  if not PLUser.usUseLexicon then exit; {Bail out if not to use lexicon}
  if lstCatPick.itemindex < 0 then exit; {bail out}
  Alist.clear;
  catien := IntToStr(lstCatPick.itemIEN);
  FastAssign(UserProblemList(catien), AList) ;
  {File 125.12, Each line contains: PROBLEM^DISPLAY TEXT^CODE^CODE IFN }
  {code ifn is derived}
  FastAssign(Alist, lstProbPick.Items);
end;

procedure TfrmProblems.LoadProblems;
var
  AList: TStringList;
  i: integer;
begin
  pProviderID := 0;
  AList := TStringList.Create;
  try
    lstView.ItemIndex := -1;
    StatusText('Retrieving problem list...') ;
    if (PLUser = nil) or InitPatient then LoadUserParams(Alist);
    Alist.clear;
    if Patient.DFN <> '' then LoadPatientParams(Alist);
    Alist.clear;
    LoadPatientProblems(AList, PlUser.usViewAct[1], True); {initialize patient list}
    lstView.ItemIndex := -1;
    AList.clear;
    lstCatPick.Clear ;
    LoadUserCats(AList);
    {SET APPLICATION DEFAULTS}
    if (not PLUser.usPrimeUser) then
      begin {activities available to GMPLUSER only}
        mnuActRestore.enabled := False;
        mnuActRemove.enabled:=false;
        mnuViewRemoved.Enabled := False;
        popRemove.enabled:=false;
        popRestore.enabled := False;
        i := lstView.Items.IndexOf('Removed');
        if i > -1 then lstView.Items.Delete(i);
        mnuActVerify.enabled:=false;
        popVerify.enabled:=false;
      end;
    if (not PLUser.usVerifyTranscribed) then
      begin
        mnuActVerify.enabled:=false;
        popVerify.enabled:=false;
      end;
  finally
    AList.Free;
    StatusText('') ;
  end;
end;

function TfrmProblems.HighlightDuplicate( NewProb: string; const Msg: string;
  DlgType: TMsgDlgType; Action: string): boolean;
var
  dup: string;
  exprList, icdList, textList: TstringList;
  cmpp, i, exprPos, icdPos, textPos: integer;
  collapserow: boolean;
begin
  Result := False;
  cmpp := -1;
  if Piece(newprob, U, 1) = '' then
    dup := CheckForDuplicateProblem('1', Piece(newprob, U, 2))
  else
    dup := CheckForDuplicateProblem(Piece(newprob,U,1), Piece(newprob, U, 2));

  if (Piece(dup, U, 1) <> '0') then
    // if adding, check all existing problems for duplicates
    // if changing, exclude curent problem from duplicate check
    if (Action = 'ADD') or ((Action = 'CHANGE') and (Piece(dup, U, 1) <> ProbRec.PIFN)) then
      begin
        if (Piece(dup, U, 2) <> PLUser.usViewAct) and (PLUser.usViewAct <> 'B') then
          begin
            lstView.SelectByID(Piece(dup, U, 2));
            lstViewClick(Self);
          end;
        exprList := TStringList.Create;
        icdList := TStringList.Create;
        textList := TStringList.create;
        try {find and highlight duplicate problem - match problem text minus trailing '*'}
          for i := 0 to FAllProblems.Count - 1 do
          begin
            exprList.Add(TrimRight(Piece(FAllProblems[i], U, 1)));
            icdList.Add(TrimRight(Piece(FAllProblems[i], U, 14)));
            textList.Add(TrimRight(Piece(Piece(Piece(Piece(FAllProblems[i], U, 3), #13, 1), '*', 1),'(', 1)));
          end;
          exprPos := exprList.IndexOf(TrimRight(Piece(dup, U, 1)));
          icdPos  := icdList.IndexOf(TrimRight(Piece(newprob, U, 3)));
          textPos := textList.indexof(TrimRight(Piece(Piece(Piece(newprob, U, 2), '*', 1),'(', 1)));
          if exprPos > -1 then
            cmpp := exprPos
          else if icdPos > -1 then
            cmpp := icdPos
          else if textPos > -1 then
            cmpp := textPos;
        finally
          textList.free;
        end;
        if cmpp > -1 then
          begin
            collapserow:= (FProblemsVisible[cmpp] <> 'Y');
            if CollapseRow then
              wgProbData.Items.Insert(0, FAllProblems[cmpp]);
            //translate from FAllProblems index to wgProbData index
            for i := 0 to wgProbData.Items.Count - 1 do
            begin
              if StrToInt(FItemData[i]) = cmpp then with wgProbData do
              begin
                TopIndex := i;
                ItemIndex := i;
                Selected[i] := True;
                //break;
              end
              else if wgProbData.Selected[i] = True then
                wgProbData.Selected[i] := False;
            end;
            case DlgType of
              mtInformation:
                InfoBox(Msg, 'Information', MB_OK or MB_ICONINFORMATION);
              mtConfirmation:
                Result := InfoBox(Msg, 'Confirmation', MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES;
            end;
            if collapserow then wgProbData.Items.Delete(0);
          end;
      end;
end;

procedure TfrmProblems.AddProblem;
const
  TX799 = '799.9';
var
  newprob: string;
begin
  if (PLPt.ptDead<>'') then {Check for dead patient}
    if InfoBox('This Patient has been deceased since ' + PLPt.ptDead + #13#10 +
    '        Proceed with problem addition?', 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDNO then
      exit; {bail out - if don't want to add to dead}
  {problems are in the form of: ien^.01^icd^icdifn , although only the .01 is required}
  if PLProblem <> '' then
    begin
      newProb:=PLProblem;
      PLProblem:='';
    end
  else if edProbEnt.text<>'' then
    begin
      newprob:= u + edProbEnt.text + u + TX799 + u; {free text problem entry from editbox}
      edProbEnt.Visible := False;
      lblProbEnt.Visible := False;
      edProbEnt.Text := '';
    end
  else if lstProbPick.itemindex > -1 then {problem selected from user list}
    {Each line contains: PROBLEM^DISPLAY TEXT^CODE^CODE IFN^SNOMED CT CONCEPT^SNOMED CT DESIGNATION }
    newprob:=lstProbPick.Items[lstProbPick.itemindex];
  if NewProb='' then exit; {should never happen}
  bbCancel.Enabled := False ;
  bbOtherProb.enabled:=false; {don't let them invoke lexicon till add completed}

  //  =============  new duplicate checking code  ===================
  if HighlightDuplicate(NewProb, 'This problem looks similar to the highlighted problem'
                 + #13#10 + '        Proceed?', mtConfirmation, 'ADD') then
  begin
    bbCancel.Enabled := True ;
    bbOtherProb.enabled:=true; {don't let them invoke lexicon till add completed}
    exit; {bail out - if don't want dups}
  end ;
//============================== End new code =========================
  if ProbRec = nil then
    begin
      pnlRight.Caption := lblProbList.caption ;
      lblProbList.caption:='Add Problem';
      wgProbData.Caption := lblProbList.Caption;
      pnlProbDlg.Visible := True;
      pnlProbDlg.BringToFront ;
      dlgProbs:=TFrmDlgProb.create(pnlProbDlg);
      dlgProbs.HorzScrollBar.Range := dlgProbs.ClientWidth;
      dlgProbs.VertScrollBar.Range := dlgProbs.ClientHeight;
      dlgProbs.parent:=pnlProbDlg;
      dlgProbs.Align := alClient ;
      dlgProbs.Reason:='A';
      dlgProbs.SubjProb:=newprob;
      dlgProbs.show;
      PostMessage(dlgProbs.Handle, UM_TAKEFOCUS, 0, 0);
      wgProbData.TabStop := False; //fixes part (c) of CQ #15531: 508 Problems tab [CPRS v28.1] {TC}.
      //prevents the selected problem or last entered problem from the PL captionlistbox
      //underneath pnlProbDlg to be focused & read by Jaws
    end
  else
    InfoBox('Current Add/Edit/Display activity must be completed' + #13#10 +
      'before another record may be added',
      'Information', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmProblems.EditProblem(const why: char);
var
  prob: string;
  reas: string;
begin
  prob := Piece(MString(wgProbData.ItemIndex), U, 1);
  if (prob <> '') and (ProbRec = nil) then
    begin
      StatusText('Retrieving selected problem...') ;
      bbCancel.Enabled := False ;
      bbOtherProb.enabled := false; {don't let them invoke lexicon till edit completed}
      case why of
        'E','e','C','c' : reas := 'Edit Problem';
        'D','d'         : reas := 'Display Problem';
        'R','r'         : reas := 'Remove Problem';
      end;
      pnlRight.Caption   := lblProbList.caption ;
      lblProbList.caption     := reas;
      wgProbData.Caption := lblProbList.Caption;
      pnlProbDlg.Visible := True;
      pnlProbDlg.BringToFront ;
      //prevents JAWS from reading the top item in the wgProbData caption listbox when hidden from view.
      pnlProbDlg.SetFocus;
      dlgProbs           := TFrmDlgProb.create(pnlProbDlg);
      dlgProbs.HorzScrollBar.Range := dlgProbs.ClientWidth;
      dlgProbs.VertScrollBar.Range := dlgProbs.ClientHeight;
      dlgProbs.parent    := pnlProbDlg;
      dlgProbs.Align     := alClient ;
      dlgProbs.Reason    := why;
      with wgProbData do dlgProbs.subjProb:=prob + u + Trim(Piece(Piece(Piece(MString(itemindex), U, 3), #13, 1), '(', 1)) + u + Piece(MString(itemindex), U, 14);
      StatusText('') ;
      dlgProbs.Show;
      PostMessage(dlgProbs.Handle, UM_TAKEFOCUS, 0, 0);
      wgProbData.TabStop := False;  //fixes part (c) of CQ #15531: 508 Problems tab [CPRS v28.1] {TC}.
      //prevents the selected problem or last entered problem from the PL captionlistbox
      //underneath pnlProbDlg to be focused & read by Jaws
    end
  else
    begin
      case why of
        'E','e','C','c' : reas := 'Edited';
        'D','d'         : reas := 'Displayed';
        'R','r'         : reas := 'Removed';
      end;
      InfoBox('Current Add/Edit/Display activity must be completed' + #13#10 +
        'before another record may be ' + reas,
        'Information', MB_OK or MB_ICONINFORMATION);
    end;
end;

procedure TfrmProblems.UpdateProblem(const why:char; Line: string; AllProblemsIndex: integer);
var
  Alist: TstringList;
  DateOfInterest: TFMDateTime;
  SvcCat: Char;
  ProblemIFN: string;
  sv: string;
begin
  alist := TstringList.create;
  try
    problemIFN := Piece(Line, U, 1);
    {get the basic info - could shortcut, but try this for now}
    FastAssign(EditLoad(ProblemIFN), AList) ;
    probRec := TProbrec.create(Alist);
    probRec.PIFN := problemIFN;
    ProbRec.RespProvider.DHCPtoKeyVal(inttostr(Encounter.Provider) + u + Encounter.ProviderName);   {REV - V13}
    SvcCat := Encounter.VisitCategory;
    if (SvcCat = 'E') or (SvcCat = 'H') then
      DateOfInterest := FMNow
    else
      DateOfInterest := Encounter.DateTime;
    Alist.clear;
    case why of
      'I': begin
             ProbRec.status := 'I';
             {assume resolution date now with this option. user should do full edit otherwise}
             ProbRec.DateResStr := 'T';
             Probrec.DateModStr := 'T';
             FastAssign(ProblemUpdate(ProbRec.AltFilerObject), AList) ;
           end;
      'V': begin
            if not IsActiveICDCode(ProbRec.Diagnosis.extern, DateOfInterest) then
              begin
                InfoBox(TX_INACTIVE_ICODE, TC_INACTIVE_ICODE, MB_ICONWARNING or MB_OK);
                exit;
              end
            else if (ProbRec.SCTConcept.extern <> '') and not IsActiveSCTCode(ProbRec.SCTConcept.extern, DateOfInterest) then
              begin
                InfoBox(TX_INACTIVE_SCODE, TC_INACTIVE_SCODE, MB_ICONWARNING or MB_OK);
                exit;
              end;
             Probrec.condition := 'P';
             Probrec.DateModStr := 'T';
             FastAssign(ProblemVerify(ProbRec.PIFN), AList) ;
           end;
    end;

    if Alist.count<1 then {show error message}
      InfoBox('Unable to update record ', 'Information', MB_OK or MB_ICONINFORMATION)
    else if Alist[0]<'1' then
      InfoBox('Unable to update record: ' + #13#10 + ' ' + Alist[1] + ' (' + Probrec.PIFN + ')',
        'Information', MB_OK or MB_ICONINFORMATION)
    {show inactivated problem}
    else if (why='I') then
      begin
        if (PlUser.usViewAct='A') then
          FProblemsVisible[AllProblemsIndex] := 'N'
        else
        begin
          SetPiece(line, U, 2, 'I');
          FAllProblems[AllProblemsIndex] := line;
        end;
      end
    else if (why='V') then {show verified problem}
      begin
        sv := Piece(Line, U, 2);
        SetPiece(line, U, 2, Copy(sv,1,4)); //remove (u)
        FAllProblems[AllProblemsIndex] := line;
      end;
  finally
    Changes.RefreshCoverPL := True;
    alist.free;
    ProbRec.free;
    ProbRec := nil;
  end;
end;

procedure TfrmProblems.RestoreProblem;
const
  TC_RESTORE_EDIT = 'Unable to restore';
  TX_RESTORE_EDIT = 'This problem references an inactive ICD code,' + #13#10 +
                    'and must be updated using the ''Change'' option' + #13#10 +
                    'before it can be restored.' + #13#10 + #13#10 +
                    'Would you like to edit this problem?';
var
  Alist:TstringList;
  AProbRec: TProbRec;
  ProblemIFN: string;
  DateOfInterest: TFMDateTime;
  SvcCat: Char;
begin
  Alist := TStringList.create;
  ProblemIFN := Piece(MString(wgProbData.ItemIndex), U, 1);
  FastAssign(EditLoad(ProblemIFN), AList) ;
  AProbRec:=TProbRec.Create(Alist); {create a problem object}
  SvcCat := Encounter.VisitCategory;
  if (SvcCat = 'E') or (SvcCat = 'H') then
    DateOfInterest := FMNow
  else
    DateOfInterest := Encounter.DateTime;
  try
    if not IsActiveICDCode(AProbRec.Diagnosis.extern, DateOfInterest) then
      begin
        if InfoBox(TX_RESTORE_EDIT, TC_RESTORE_EDIT, MB_YESNO or MB_ICONWARNING) = IDYES then
        begin
          AProbRec.Status := 'A';
          EditProblem('C');
        end
        else
          Exit;
      end
    else
      begin
        FastAssign(ProblemReplace(ProblemIFN), Alist) ;
        if Alist[0] <> '1' then
          InfoBox('Unable to restore the problem record: ' + #13#10 + ' (' + AProbrec.PIFN + ')',
            'Information', MB_OK or MB_ICONINFORMATION)
        else
          LoadPatientProblems(AList, 'R', False);
        GetRowCount;
      end;
  finally
    Changes.RefreshCoverPL := True;
    AList.free;
    AProbRec.Free;
  end;
end;

procedure TfrmProblems.NoRowSelected;
begin
  mnuActDetails.enabled    := false;
  mnuActChange.enabled     := false;
  mnuActVerify.enabled     := false;
  mnuActInactivate.enabled := false;
  mnuActRestore.enabled    := false;
  mnuActRemove.enabled     := false;
  mnuActAnnotate.enabled   := false;
  popChange.enabled        := false;
  popVerify.enabled        := false;
  popInactivate.enabled    := false;
  popRestore.enabled       := false;
  popRemove.enabled        := false;
  popAnnotate.enabled      := false;
  popViewDetails.enabled   := False;
end ;

procedure TfrmProblems.RowSelected;
var
 AnyUnver, AnyAct: integer;
 i: integer;
begin
  if wgProbData.SelCount > 1 then
    begin
      mnuActDetails.enabled    := false;
      mnuActChange.enabled     := false;
      mnuActRestore.enabled    := false;
      mnuActRemove.enabled     := false;
      mnuActAnnotate.enabled   := false;
      popChange.enabled        := false;
      popRestore.enabled       := false;
      popRemove.enabled        := false;
      popAnnotate.enabled      := false;
      popViewDetails.enabled   := false;
      AnyUnver := 0;
      AnyAct := 0;
      for i := 0 to wgProbData.Count - 1 do
       begin
        if wgProbData.Selected[i] and (Copy(Piece(MString(i), U, 2),5,3)='(u)') then
          AnyUnver := AnyUnVer + 1;
        if wgProbData.Selected[i] and (Copy(Piece(MString(i), U, 2),1,1) = 'A') then
          AnyAct := AnyAct + 1;
       end;
      mnuActVerify.enabled     := PLUser.usVerifyTranscribed and
                                  PLUser.usPrimeUser and (AnyUnver > 0);
      popVerify.enabled        := PLUser.usVerifyTranscribed and
                                  PLUser.usPrimeUser and (AnyUnver > 0);
      mnuActInactivate.enabled := (AnyAct > 0);
      popInactivate.enabled    := (AnyAct > 0);
    end
  else
    begin
      mnuActDetails.enabled    := true;
      mnuActChange.enabled     := true;
      mnuActRestore.enabled    := PLUser.usPrimeUser;
      mnuActRemove.enabled     := PLUser.usPrimeUser;
      mnuActAnnotate.enabled   := true;
      popChange.enabled        := true;
      popRestore.enabled       := PLUser.usPrimeUser;
      popRemove.enabled        := PLUser.usPrimeUser;
      popAnnotate.enabled      := true;
      popViewDetails.enabled   := true ;
      mnuActVerify.enabled     := PLUser.usVerifyTranscribed and
                                  PLUser.usPrimeUser and
                                  (Copy(Piece(MString(wgProbData.ItemIndex), U, 2),5,3)='(u)') ;
      popVerify.enabled        := PLUser.usVerifyTranscribed and
                                  PLUser.usPrimeUser and
                                  (Copy(Piece(MString(wgProbData.ItemIndex), U, 2),5,3)='(u)') ;
      mnuActInactivate.enabled := Copy(Piece(MString(wgProbData.ItemIndex), U, 2),1,1) = 'A' ;
      popInactivate.enabled    := Copy(Piece(MString(wgProbData.ItemIndex), U, 2),1,1) = 'A' ;
    end;

  //Disable menu actions for REMOVED problems list display
  if PLUser.usViewAct = 'R' then
    begin
      mnuActAnnotate.Enabled   := False;
      mnuActChange.Enabled     := False;
      mnuActInactivate.Enabled := False;
      mnuActRemove.Enabled     := False;
      mnuActVerify.Enabled     := False;
      popAnnotate.Enabled      := False;
      popChange.Enabled        := False;
      popInactivate.Enabled    := False;
      popRemove.Enabled        := False;
      popVerify.Enabled        := False;
    end;
end ;

procedure TfrmProblems.bbCancelClick(Sender: TObject);
begin
  inherited;
  //Hide Panels
  pnlButtons.Hide;
  pnlButtons.SendToBack;
  pnlProbCats.Hide;
  pnlProbCats.SendToBack;

  //Show pnlView & Add Back to tab Order
  ShowPnlView;
  //shift focus to another ctrl so the Cancel btn does not get read twice by JAWS,
  //once upon tabbing to the btn & 2nd after it is selected/clicked (focus remained on btn)
  lstView.SetFocus;
end;

procedure TfrmProblems.lstViewClick(Sender: TObject);
begin
  inherited;
  case lstView.ItemIndex of
    0:  tag := 700 ;      {Active}
    1:  tag := 800 ;      {Inactive}
    2:  tag := 900 ;      {Both}
    3:  tag := 950 ;      {Removed}
{       4:  tag := 975 ;      {Filters...}
  end ;
  lstProbActsClick(Self) ;
  mnuOptimizeFieldsClick(self);
end;

function EncounterPresent: Boolean;
{ make sure a location and provider are selected, returns false if not }
begin
  Result := True;
  if (Encounter.Provider = 0) or (Encounter.Location = 0) then
  begin
    UpdateEncounter(NPF_ALL);  {*KCM*}
    frmFrame.DisplayEncounterText;
  end;
  if (Encounter.Provider = 0) or (Encounter.Location = 0) then
  begin
    if not frmFrame.CCOWDrivedChange then
      InfoBox(TX_PROV_LOC, TC_PROV_LOC, MB_OK or MB_ICONWARNING);  {!!!}
    Result := False;
  end;
end;

procedure TfrmProblems.FormDestroy(Sender: TObject);
begin
  ClearGrid;
  FItemData.Free;
  FAllProblems.Free;
  FProblemsVisible.Free;
  inherited;
end;

procedure TfrmProblems.mnuViewSaveClick(Sender: TObject);
begin
  inherited;
  if PLPt = nil then
    begin
      InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  if InfoBox('Replace current defaults?','Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      with PLUser do
        begin
          usDefaultContext := FContextString;
          usDefaultView    := Piece(FFilterString, '/', 1);
        end;
      SaveViewPreferences(FFilterString + U + FContextString);
    end;
end;

procedure TfrmProblems.mnuViewRestoreDefaultClick(Sender: TObject);
begin
  inherited;
  if PLPt = nil then
    begin
      InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  if PLFilters <> nil then
    begin
      PLFilters.Destroy;
      PLFilters := nil;
    end;
  if PLUser <> nil then
    begin
      PLUser.Destroy;
      PLUser := nil;
    end;
  if ScreenReaderActive then
     GetScreenReader.Speak('Returning to default view.');
  ShowPnlView;
  LoadProblems ;
end;

procedure TfrmProblems.mnuViewCommentsClick(Sender: TObject);
var
  x, line, comments: string;
  i, j: integer;
begin
  inherited;
  if PLPt = nil then
    begin
      InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  mnuViewComments.Checked := not mnuViewComments.Checked;
  SetPiece(FContextString, ';', 4, BOOLCHAR[mnuViewComments.Checked]);
  PLUser.usViewComments := BOOLCHAR[mnuViewComments.Checked];
  with FAllProblems do
    begin
      for i := 0 to Count - 1 do
        begin
          if Objects[i] = nil then continue;
          x := Piece(Piece(Strings[i], U, 3), #13, 1);
          if PLUser.usViewComments = '1' then
            begin
              comments := '';
              for j := 0 to TStringList(Objects[i]).Count - 1 do
                comments := comments + '         ' + TStringList(Objects[i]).Strings[j] + #13#10;
                //comments := comments + '   CMT:  ' + TStringList(Items.Objects[i]).Strings[j] + #13#10;
              Line := Strings[i];
              SetPiece(Line, U, 3, x + #13#10 + comments);
              Strings[i] := Line;
            end
          else
          begin
            Line := Strings[i];
            SetPiece(Line, U, 3, x);
            Strings[i] := Line;
          end;
        end;
    end;
  RefreshList;
end;

procedure TfrmProblems.RequestPrint;
begin
  inherited;
  if PLPt = nil then
    begin
      InfoBox(TX_INVALID_PATIENT, TC_NO_PATIENT, MB_OK or MB_ICONWARNING);
      Exit;
    end;
  uReportType := '';
  PrintReports(IntToStr(RPT_PROBLIST), 'Problem List')
end;

procedure TfrmProblems.SetFontSize( NewFontSize: integer);
var
  OldParent: TWinControl;
begin
  OldParent := nil;
  if Assigned(dlgProbs) then begin
    OldParent := dlgProbs.Parent;
    dlgProbs.Parent := nil;
  end;
  try
    {These labels are hidden in an ORAutoPanel, so have to be sized manually}
    lblProbCats.Height := ResizeHeight( Font, MainFont, lblProbCats.Height);
    lblProblems.Height := ResizeHeight( Font, MainFont, lblProblems.Height);
    inherited SetFontSize( NewFontSize);
  finally
    if Assigned(dlgProbs) then
      dlgProbs.Parent := OldParent;
  end;
  if Assigned(dlgProbs) then
    dlgProbs.SetFontSize( MainFontSize);
  mnuOptimizeFieldsClick(self);
end;

procedure TfrmProblems.RefreshList;
var
  i: integer;
begin
  RedrawSuspend(wgProbData.Handle);
  wgProbData.Clear;
  FItemData.Clear;
  for i := 0 to FAllProblems.Count-1 do
    if FProblemsVisible[i] = 'Y' then begin
      FItemData.Add(IntToStr(i));
      if Piece(FAllProblems[i], U, 1) <> '' then
        wgProbData.Items.Add(PlainText(FAllProblems[i]))
      else
        wgProbData.Items.Add(FAllProblems[i]);
    end;
  wgProbData.Invalidate;
  RedrawActivate(wgProbData.Handle);
end;

procedure TfrmProblems.wgProbDataMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
var
  ARect: TRect;
  x: string;
  NewHeight: Integer;
begin
  inherited;
  NewHeight := Height;
  with wgProbData do if Index < Items.Count then
  begin
    ARect := ItemRect(Index);
    ARect.Left  := HeaderControl.Sections[0].Width + HeaderControl.Sections[1].Width + 2;
    ARect.Right := ARect.Left + HeaderControl.Sections[2].Width - 6;
    x := Piece(MString(Index), U, 3);
    NewHeight := WrappedTextHeightByFont( Canvas, Font, x, ARect);
    if NewHeight > 255 then NewHeight := 255;   // windows appears to only look at 8 bits *KCM*
    if NewHeight <  13 then NewHeight := 13;    // show at least one line                 *KCM*
  end; {if Index}
  Height := NewHeight;
end;

procedure TfrmProblems.wgProbDataDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  i: integer;
begin
  inherited;
  with wgProbData do if Index < Items.Count then
  begin
    ListGridDrawLines(wgProbData, HeaderControl, Index, State);
    for i := 0 to HeaderControl.Sections.Count -1 do
      ListGridDrawCell(wgProbData, HeaderControl, Index, i, Piece(MString(Index),U,i+1), i = 2);
  end; {if Index}
end;

function TfrmProblems.PlainText(MString: string): string;
var
  i: integer;
begin
  result := '';
  with HeaderControl do
    for i := 0 to Sections.Count -1 do
      if Sections[i].MaxWidth > 0 then
        if Trim(Piece(MString, U, i+1)) <> '' then
          result := result + Sections[i].Text + ': ' + Piece(MString, U, i+1) + CRLF;
end;

function TfrmProblems.MString(index: integer): string;
begin
  if index = -1 then
    result := ''
  else
    result := FAllProblems[StrToInt(FItemData[index])];
end;

procedure TfrmProblems.HeaderControlSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  wgProbData.Invalidate;
  {FEvtColWidth := HeaderControl.Sections[0].Width;     //code from fOrders
  RedrawSuspend(Self.Handle);
  //RedrawOrderList;
  RedrawActivate(Self.Handle);
  wgProbData.Invalidate;
  pnlRight.Refresh;
  pnlLeft.Refresh; }
end;

{Tab Order tricks.  Need to change
  lstView

  bbNewProb
  bbOtherProb
  bbCancel

  pnlProbDlg
  wgProbData

to
  lstView

  pnlProbDlg
  wgProbData

  bbNewProb
  bbOtherProb
  bbCancel
}

procedure TFrmProblems.lstViewExit(Sender: TObject);
begin
  inherited;
 { if IncSecond(FMousing,1) < Now  then
  begin
    if (Screen.ActiveControl = bbNewProb) or
        (Screen.ActiveControl = bbOtherProb) or
        (Screen.ActiveControl = bbCancel) then
      FindNextControl( bbCancel, True, True, False).SetFocus;
  end;
  FMousing := 0; }
end;

procedure TFrmProblems.pnlRightExit(Sender: TObject);
begin
  inherited;
{  if IncSecond(FMousing,1) < Now then
  begin
    if (Screen.ActiveControl = frmFrame.pnlPatient) then
    begin
      if lstView.Visible then
        FindNextControl( lstView, True, True, False).SetFocus
      else
        FindNextControl( edProbEnt, True, True, False).SetFocus
    end
    else
    if (Screen.ActiveControl = bbNewProb) or
        (Screen.ActiveControl = bbOtherProb) or
        (Screen.ActiveControl = bbCancel) then
    begin
      if bbNewProb.Visible then
        FindNextControl( bbNewProb, False, True, False).SetFocus
      else
        FindNextControl( bbOtherProb, False, True, False).SetFocus;
    end;
  end;
  FMousing := 0; }
end;

procedure TFrmProblems.bbNewProbExit(Sender: TObject);
begin
  inherited;
{  if IncSecond(FMousing,1) < Now then
  begin
    if (Screen.ActiveControl = pnlProbDlg) or
        (Screen.ActiveControl = wgProbData) then
      frmFrame.pnlPatient.SetFocus
    else
    if (Screen.ActiveControl = lstView) or
        (Screen.ActiveControl = lstCatPick) then
      FindNextControl( frmFrame.pnlPatient, False, True, False).SetFocus;
  end;
  FMousing := 0;}
end;

procedure TFrmProblems.frmFramePnlPatientExit(Sender: TObject);
begin
  FOldFramePnlPatientExit(Sender);
  inherited;
{  if IncSecond(FMousing,1) < Now then
  begin
    if (Screen.ActiveControl = pnlProbDlg) or
        (Screen.ActiveControl = wgProbData) then
      FindNextControl( pnlProbDlg, False, True, False).SetFocus;
  end;
  FMousing := 0;}
end;

procedure TFrmProblems.FormHide(Sender: TObject);
begin
  inherited;
  frmFrame.pnlPatient.OnExit := FOldFramePnlPatientExit;
end;

procedure TFrmProblems.FormShow(Sender: TObject);
begin
  inherited;
  FOldFramePnlPatientExit := frmFrame.pnlPatient.OnExit;
  frmFrame.pnlPatient.OnExit := frmFramePnlPatientExit;
  RequestNTRT := False;
  NTRTComment := '';
  if Changes.RefreshProblemList then
  begin
    LoadProblems;
    Changes.RefreshProblemList := False;
  end;
end;

procedure TfrmProblems.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
 // FMousing := Now;
end;

procedure TfrmProblems.ShowPnlView;
begin
  pnlView.BringToFront;
  pnlView.Show;
  lstView.TabStop := true;
  bbNewProb.TabStop := true;
end;

procedure TfrmProblems.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmProblems.mnuViewInformationClick(Sender: TObject);
begin
  inherited;
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not (Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not (Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmProblems.mnuOptimizeFieldsClick(Sender: TObject);
var
  totalSectionsWidth, unitvalue: integer;
begin
  totalSectionsWidth := pnlRight.Width - 3;
  if totalSectionsWidth < 16 then exit;
  unitvalue := round(totalSectionsWidth / 16);
  with HeaderControl do
  begin
    if Sections[1].Width > 0 then Sections[1].Width := unitvalue;
    Sections[2].Width := pnlRight.Width - (unitvalue * 11) - 5;
    Sections[3].Width := unitvalue * 2;
    Sections[4].Width := unitvalue * 2;
    if Sections[6].Width > 0 then Sections[6].Width := unitvalue;
    if Sections[7].Width > 0 then Sections[7].Width := unitvalue * 2;
    if Sections[8].Width > 0 then Sections[8].Width := unitvalue * 2;
    if Sections[15].Width > 0 then Sections[15].Width := unitvalue;
  end;
  HeaderControlSectionResize(HeaderControl, HeaderControl.Sections[0]);
  HeaderControl.Repaint;
end;

procedure TfrmProblems.HeaderControlSectionClick(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  //if Section = HeaderControl.Sections[1] then
    mnuOptimizeFieldsClick(self);
end;

procedure TfrmProblems.HeaderControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  totalSectionsWidth, originalwidth: integer;
begin
  inherited;
  totalSectionsWidth := getTotalSectionsWidth;
  if totalSectionsWidth > wgProbData.Width - 5 then
  begin
    originalwidth := 0;
    for i := 0 to HeaderControl.Sections.Count - 1 do
      originalwidth := originalwidth + origWidths[i];
    if originalwidth < totalSectionsWidth then
    begin
      for i := 0 to HeaderControl.Sections.Count - 1 do
        HeaderControl.Sections[i].Width := origWidths[i];
      wgProbData.Invalidate;
    end;
  end;
end;

function TfrmProblems.getTotalSectionsWidth : integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to HeaderControl.Sections.Count - 1 do
     Result := Result + HeaderControl.Sections[i].Width;
end;

procedure TfrmProblems.HeaderControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  setSectionWidths;
end;

procedure TfrmProblems.setSectionWidths;
var
  i: integer;
begin
  for i := 0 to 15 do
     origWidths[i] := HeaderControl.Sections[i].Width;
end;

procedure TfrmProblems.sptHorzMoved(Sender: TObject);
begin
  inherited;
  mnuOptimizeFieldsClick(self);
end;

initialization
  SpecifyFormIsNotADialog(TfrmProblems);

end.



unit fSurgery;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, fDrawers, ImgList, fSurgeryView, rSurgery, uSurgery,
  uCaseTree, uTIU, fBase508Form, VA508AccessibilityManager,
  VA508ImageListLabeler, ORextensions;

type
  TfrmSurgery = class(TfrmHSplit)
    mnuNotes: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    Z1: TMenuItem;
    mnuViewDetail: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    Z2: TMenuItem;
    mnuActSave: TMenuItem;
    mnuActDelete: TMenuItem;
    mnuActEdit: TMenuItem;
    mnuActSign: TMenuItem;
    mnuActAddend: TMenuItem;
    lblCases: TOROffsetLabel;
    pnlRead: TPanel;
    lblTitle: TOROffsetLabel;
    memSurgery: TRichEdit;
    pnlWrite: TPanel;
    memNewNote: TRichEdit;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewBySurgeon: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewUncosigned: TMenuItem;
    mnuViewUnsigned: TMenuItem;
    mnuActSignList: TMenuItem;
    cmdNewNote: TORAlignButton;
    lblSpace1: TLabel;
    popNoteMemo: TPopupMenu;
    popNoteMemoCut: TMenuItem;
    popNoteMemoCopy: TMenuItem;
    popNoteMemoPaste: TMenuItem;
    Z10: TMenuItem;
    popNoteMemoSignList: TMenuItem;
    popNoteMemoDelete: TMenuItem;
    popNoteMemoEdit: TMenuItem;
    popNoteMemoSave: TMenuItem;
    popNoteMemoSign: TMenuItem;
    popNoteList: TPopupMenu;
    popNoteListAll: TMenuItem;
    popNoteListByDate: TMenuItem;
    mnuActIdentifyAddlSigners: TMenuItem;
    popNoteMemoAddlSign: TMenuItem;
    Z11: TMenuItem;
    popNoteMemoSpell: TMenuItem;
    popNoteMemoGrammar: TMenuItem;
    mnuViewCustom: TMenuItem;
    N1: TMenuItem;
    mnuViewSaveAsDefault: TMenuItem;
    ReturntoDefault1: TMenuItem;
    pnlDrawers: TPanel;
    splDrawers: TSplitter;
    popNoteMemoTemplate: TMenuItem;
    Z12: TMenuItem;
    mnuOptions: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    N2: TMenuItem;
    mnuEditSharedTemplates: TMenuItem;
    mnuNewSharedTemplate: TMenuItem;
    popNoteMemoAddend: TMenuItem;
    pnlFields: TPanel;
    lblNewTitle: TLabel;
    lblRefDate: TLabel;
    lblAuthor: TLabel;
    lblVisit: TLabel;
    lblCosigner: TLabel;
    cmdChange: TButton;
    lblSubject: TLabel;
    txtSubject: TCaptionEdit;
    timAutoSave: TTimer;
    popNoteMemoPaste2: TMenuItem;
    popNoteMemoReformat: TMenuItem;
    Z4: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActLoadBoiler: TMenuItem;
    bvlNewTitle: TBevel;
    popNoteMemoSaveContinue: TMenuItem;
    N3: TMenuItem;
    mnuEditDialgFields: TMenuItem;
    N4: TMenuItem;
    popNoteListExpandSelected: TMenuItem;
    popNoteListExpandAll: TMenuItem;
    popNoteListCollapseSelected: TMenuItem;
    popNoteListCollapseAll: TMenuItem;
    popNoteListCustom: TMenuItem;
    mnuActDetachFromIDParent: TMenuItem;
    N5: TMenuItem;
    popNoteListDetachFromIDParent: TMenuItem;
    popNoteListAddIDEntry: TMenuItem;
    mnuActAddIDEntry: TMenuItem;
    mnuIconLegend: TMenuItem;
    N6: TMenuItem;
    popNoteMemoFind: TMenuItem;
    dlgFindText: TFindDialog;
    dlgReplaceText: TReplaceDialog;
    popNoteMemoReplace: TMenuItem;
    N7: TMenuItem;
    tvSurgery: TORTreeView;
    mnuChartSurgery: TMenuItem;
    lstNotes: TORListBox;
    sptVert: TSplitter;
    memPCEShow: TRichEdit;
    cmdPCE: TORAlignButton;
    popNoteListBySurgeon: TMenuItem;
    popNoteListUnsigned: TMenuItem;
    popNoteListUncosigned: TMenuItem;
    N8: TMenuItem;
    popNoteMemoPreview: TMenuItem;
    popNoteMemoInsTemplate: TMenuItem;
    popNoteMemoEncounter: TMenuItem;
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
    imgLblImages: TVA508ImageListLabeler;
    imgLblSurgery: TVA508ImageListLabeler;
    procedure mnuChartTabClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure cmdNewNoteClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure mnuActSaveClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuActAddendClick(Sender: TObject);
    procedure mnuActSignListClick(Sender: TObject);
    procedure mnuActDeleteClick(Sender: TObject);
    procedure mnuActEditClick(Sender: TObject);
    procedure mnuActSignClick(Sender: TObject);
    procedure cmdPCEClick(Sender: TObject);
    procedure popNoteMemoCutClick(Sender: TObject);
    procedure popNoteMemoCopyClick(Sender: TObject);
    procedure popNoteMemoPasteClick(Sender: TObject);
    procedure popNoteMemoPopup(Sender: TObject);
    procedure pnlWriteResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuViewDetailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuActIdentifyAddlSignersClick(Sender: TObject);
    procedure popNoteMemoAddlSignClick(Sender: TObject);
    procedure popNoteMemoSpellClick(Sender: TObject);
    procedure popNoteMemoGrammarClick(Sender: TObject);
    procedure mnuViewSaveAsDefaultClick(Sender: TObject);
    procedure mnuViewReturntoDefaultClick(Sender: TObject);
    procedure popNoteMemoTemplateClick(Sender: TObject);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure mnuEditSharedTemplatesClick(Sender: TObject);
    procedure mnuNewSharedTemplateClick(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure pnlFieldsResize(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure memNewNoteChange(Sender: TObject);
    procedure popNoteMemoReformatClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActLoadBoilerClick(Sender: TObject);
    procedure popNoteMemoSaveContinueClick(Sender: TObject);
    procedure mnuEditDialgFieldsClick(Sender: TObject);
    procedure popNoteListExpandAllClick(Sender: TObject);
    procedure popNoteListCollapseAllClick(Sender: TObject);
    procedure popNoteListExpandSelectedClick(Sender: TObject);
    procedure popNoteListCollapseSelectedClick(Sender: TObject);
    procedure popNoteListPopup(Sender: TObject);
    procedure mnuIconLegendClick(Sender: TObject);
    procedure popNoteMemoFindClick(Sender: TObject);
    procedure dlgFindTextFind(Sender: TObject);
    procedure popNoteMemoReplaceClick(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure tvSurgeryClick(Sender: TObject);
    procedure tvSurgeryChange(Sender: TObject; Node: TTreeNode);
    procedure tvSurgeryExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvSurgeryCollapsed(Sender: TObject; Node: TTreeNode);
    procedure lstNotesClick(Sender: TObject);
    procedure memNewNoteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sptHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure popNoteMemoPreviewClick(Sender: TObject);
    procedure popNoteMemoInsTemplateClick(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
  private
    FEditingIndex: Integer;                      // index of note being currently edited
    FCurrentContext: TSurgCaseContext;
    FDefaultContext: TSurgCaseContext;
    FImageFlag: TBitmap;
    FCaseList: TStringList;
    FChanged: Boolean;                           // true if any text has changed in the note
    FEditCtrl: TCustomEdit;
    FSilent: Boolean;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FConfirmed: boolean;
    FLastNoteID: string;
    FEditingNotePCEObj: boolean;
    FDeleted: boolean;
    procedure ClearEditControls;
    procedure DoAutoSave(Suppress: integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    procedure InsertAddendum;
    procedure InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
    function LacksRequiredForCreate: Boolean;
    procedure LoadForEdit;
    procedure  LoadSurgeryCases;
    procedure  UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure SetViewContext(AContext: TSurgCaseContext);
    function GetDrawers: TFrmDrawers;
    procedure SetEditingIndex(const Value: Integer);
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    procedure ProcessNotifications;
    function SetSurgTreeLabel(AContext: TSurgCaseContext): string;
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedNote(var Saved: Boolean);
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetSubjectVisible(ShouldShow: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    function StartNewEdit(NewNoteType: integer): Boolean;
    //function CanFinishReminder: boolean;
    procedure DisplayPCE;
    function VerifyNoteTitle: Boolean;
    procedure ShowPCEButtons(Editing: boolean);
    procedure EnableDisableMenus(IsTIUDocument: boolean);
  public
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure AssignRemForm;
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
  end;

var
  frmSurgery: TfrmSurgery;
  uSurgeryContext: TSurgCaseContext;

implementation

{$R *.DFM}

uses fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem, fEncounterFrame,
     rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners, fNoteDR, fConsults, uSpell,
     fTIUView, fTemplateEditor, uReminders, fReminderDialog, uOrders, rConsults, fReminderTree,
     fNoteProps, fNotesBP, fTemplateFieldEditor, uTemplates, dShared, rTemplates,
     FIconLegend, fPCEEdit, rTIU, fRptBox, fTemplateDialog, VA508AccessibilityRouter,
     System.Types, rECS, ORNet, trpcb;

const
  CT_SURGERY  = 11;                             // chart tab - surgery

  NT_NEW_NOTE = -10;                             // Holder IEN for a new note
  NT_ADDENDUM = -20;                             // Holder IEN for a new addendum

  NT_ACT_NEW_NOTE  = 2;
  NT_ACT_ADDENDUM  = 3;
  NT_ACT_EDIT_NOTE = 4;
  NT_ACT_ID_ENTRY  = 5;

  TX_NEED_VISIT = 'A visit is required before creating a new surgery report.';
  TX_CREATE_ERR = 'Error Creating Report';
  TX_UPDATE_ERR = 'Error Updating Report';
  TX_NO_NOTE    = 'No surgery report is currently being edited';
  TX_SAVE_NOTE  = 'Save Surgery Report';
  TX_ADDEND_NO  = 'Cannot make an addendum to a report that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this surgery report?';
  TX_DEL_ERR    = 'Unable to Delete Report';
  TX_SIGN       = 'Sign Report';
  TX_COSIGN     = 'Cosign Report';
  TX_SIGN_ERR   = 'Unable to Sign Report';
//  TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
//                  'answered.  The Encounter form will now be opened.  Please answer all '+
//                 'service connected questions.';
//  TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NONOTE     = 'No surgery report is currently selected.';
  TX_NONOTE_CAP = 'No Report Selected';
  TX_NOPRT_NEW  = 'This surgery report may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Surgery Report';
  TX_NO_ALERT   = 'There is insufficient information to process this alert.' + CRLF +
                  'Either the alert has already been deleted, or it contained invalid data.' + CRLF + CRLF +
                  'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  //TX_ORDER_LOCKED = 'This record is locked by an action underway on the Consults tab';
  //TC_ORDER_LOCKED = 'Unable to access record';
  //TX_NO_ORD_CHG   = 'The note is still associated with the previously selected request.' + CRLF +
  //                  'Finish the pending action on the consults tab, then try again.';
  //TC_NO_ORD_CHG   = 'Locked Consult Request';
  TX_NEW_SAVE1    = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2    = CRLF + CRLF + 'Do you wish to save this report and begin a new one?';
  TX_NEW_SAVE3    = CRLF + CRLF + 'Do you wish to save this report and begin a new addendum?';
  TX_NEW_SAVE4    = CRLF + CRLF + 'Do you wish to save this report and edit the one selected?';
  //TX_NEW_SAVE5    = CRLF + CRLF + 'Do you wish to save this report and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2    = 'Create New Report';
  TC_NEW_SAVE3    = 'Create New Addendum';
  TC_NEW_SAVE4    = 'Edit Different Report';
  //TC_NEW_SAVE5    = 'Create New Interdisciplinary Entry';
  TX_EMPTY_NOTE   = CRLF + CRLF + 'This report contains no text and will not be saved.' + CRLF +
                    'Do you wish to delete this report?';
  TC_EMPTY_NOTE   = 'Empty Report';
  TX_EMPTY_NOTE1   = 'This report contains no text and can not be signed.';
  TC_NO_LOCK      = 'Unable to Lock Report';
  TX_ABSAVE       = 'It appears the session terminated abnormally when this' + CRLF +
                    'report was last edited. Some text may not have been saved.' + CRLF + CRLF +
                    'Do you wish to continue and sign the report?';
  TC_ABSAVE       = 'Possible Missing Text';
  TX_NO_BOIL      = 'There is no boilerplate text associated with this title.';
  TC_NO_BOIL      = 'Load Boilerplate Text';
  TX_BLR_CLEAR    = 'Do you want to clear the previously loaded boilerplate text?';
  TC_BLR_CLEAR    = 'Clear Previous Boilerplate Text';
  TX_DETACH_CNF     = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';
  TX_RETRACT_CAP    = 'Retraction Notice';
  TX_RETRACT        = 'This document will now be RETRACTED.  As Such, it has been removed' +CRLF +
                      ' from public view, and from typical Releases of Information,' +CRLF +
                      ' but will remain indefinitely discoverable to HIMS.' +CRLF +CRLF;

var
  uPCEShow, uPCEEdit:  TPCEData;
  ViewContext: Integer;
  frmDrawers: TfrmDrawers;
  uChanging: Boolean;

{ TPage common methods --------------------------------------------------------------------- }

function TfrmSurgery.AllowContextChange(var WhyNot: string): Boolean;
begin
  dlgFindText.CloseDialog;
  Result := inherited AllowContextChange(WhyNot);  // sets result = true
  if Assigned(frmTemplateDialog) then
    if Screen.ActiveForm = frmTemplateDialog then
    //if (fsModal in frmTemplateDialog.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'A template in progress will be aborted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmTemplateDialog.Silent := True;
                 frmTemplateDialog.ModalResult := mrCancel;
               end;
           end;
    end;
  if EditingIndex <> -1 then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             if memNewNote.GetTextLen > 0 then
               WhyNot := 'A report in progress will be saved as unsigned.  '
             else
               WhyNot := 'An empty report in progress will be deleted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then FSilent := True;
             SaveCurrentNote(Result)
           end;
    end;
  if Assigned(frmEncounterFrame) then
    if Screen.ActiveForm = frmEncounterFrame then
    //if (fsModal in frmEncounterFrame.FormState) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := WhyNot + 'Encounter information being edited will not be saved';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmEncounterFrame.Abort := False;
                 frmEncounterFrame.Cancel := True;
               end;
           end;
    end;
end;

procedure TfrmSurgery.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  uChanging := True;
  tvSurgery.Items.BeginUpdate;
  KillCaseTreeObjects(tvSurgery);
  tvSurgery.Items.Clear;
  tvSurgery.Items.EndUpdate;
  lstNotes.Clear;
  uChanging := False;
  memSurgery.Clear;
  uPCEShow.Clear;
  uPCEEdit.Clear;
  frmDrawers.ResetTemplates;
end;

procedure TfrmSurgery.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_SURGERY;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  if InitPage then
  begin
    FDefaultContext := GetCurrentSurgCaseContext;
    FCurrentContext := FDefaultContext;
    popNoteMemoSpell.Visible   := SpellCheckAvailable;
    popNoteMemoGrammar.Visible := popNoteMemoSpell.Visible;
    Z11.Visible                := popNoteMemoSpell.Visible;
    timAutoSave.Interval := User.AutoSave * 1000;  // convert seconds to milliseconds
    SetEqualTabStops(memNewNote);
  end;
  // to indent the right margin need to set Paragraph.RightIndent for each paragraph?
  if InitPatient and not (CallingContext = CC_NOTIFICATION) then
    begin
      SetViewContext(FDefaultContext);
    end;
  case CallingContext of
    CC_INIT_PATIENT: if not InitPatient then
                       begin
                         SetViewContext(FDefaultContext);
                       end;
    CC_NOTIFICATION:  ProcessNotifications;
  end;
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmSurgery.FormCreate(Sender: TObject);
begin
  inherited;
  PageID := CT_SURGERY;
  EditingIndex := -1;
  FEditNote.LastCosigner := 0;
  FEditNote.LastCosignerName := '';
  FLastNoteID := '';
  frmDrawers := TfrmDrawers.CreateDrawers(Self, pnlDrawers, [],[]);
  frmDrawers.Align := alBottom;
  frmDrawers.RichEditControl := memNewNote;
  frmDrawers.NewNoteButton := cmdNewNote;
  frmDrawers.Splitter := splDrawers;
  frmDrawers.DefTempPiece := 1;
  FImageFlag := TBitmap.Create;
  FCaseList := TStringList.Create;
end;

procedure TfrmSurgery.pnlRightResize(Sender: TObject);
{ memSurgery (TRichEdit) doesn't repaint appropriately unless it's parent panel is refreshed }
begin
  inherited;
  pnlRight.Refresh;
  memSurgery.Repaint;
end;

procedure TfrmSurgery.pnlWriteResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memNewNote, MAX_ENTRY_WIDTH - 1);
  memNewNote.Constraints.MinWidth := TextWidthByFont(memNewNote.Font.Handle, StringOfChar('X', MAX_ENTRY_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;
  pnlLeft.Width := self.ClientWidth - pnlWrite.Width - sptHorz.Width;
end;

procedure TfrmSurgery.SetViewContext(AContext: TSurgCaseContext);
var
  Saved: boolean;
begin
  inherited;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FCurrentContext := AContext;
  EditingIndex := -1;
  tvSurgery.Enabled := True ;
  pnlRead.BringToFront ;
  with uSurgeryContext do
    begin
      Changed        := True;
      OpProc         := FCurrentContext.OpProc;
      BeginDate      := FCurrentContext.BeginDate;
      EndDate        := FCurrentContext.EndDate;
      FMBeginDate    := FCurrentContext.FMBeginDate;
      FMEndDate      := FCurrentContext.FMEndDate;
      MaxDocs        := FCurrentContext.MaxDocs;
      Status         := FCurrentContext.Status;
      GroupBy        := FCurrentContext.GroupBy;
      TreeAscending  := FCurrentContext.TreeAscending;
      mnuViewClick(Self);
    end;
end;

procedure TfrmSurgery.FormDestroy(Sender: TObject);
begin
  FCaseList.Free;
  FImageFlag.Free;
  KillCaseTreeObjects(tvSurgery);
  inherited;
end;

function TfrmSurgery.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers ;
end;

procedure TfrmSurgery.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
var
  i: integer;
begin
  with Tree do
    begin
      uChanging := True;
      Items.BeginUpdate;
      for i := 0 to DocList.Count - 1 do
        begin
          if Piece(DocList[i], U, 10) <> '' then
            lstNotes.Items.Add(DocList[i]);
        end;
      BuildCaseTree(DocList, '0', Tree, nil, uSurgeryContext);
      Items.EndUpdate;
      uChanging := False;
    end;
end;

procedure TfrmSurgery.RequestPrint;
var
  Saved: Boolean;
begin
  with lstNotes do
  begin
    if ItemIndex = EditingIndex then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
    if ItemIEN > 0 then PrintNote(ItemIEN, MakeNoteDisplayText(Items[ItemIndex])) else
    begin
      if ItemIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
      if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

procedure TfrmSurgery.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

procedure TfrmSurgery.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  pnlLeft.Width := pnlLeft.Constraints.MinWidth;
  sptHorz.Left := pnlLeft.Width;
  memSurgery.Font.Size     := NewFontSize;
  memNewNote.Font.Size  := NewFontSize;
  lblTitle.Font.Size    := NewFontSize;
  frmDrawers.Font.Size  := NewFontSize;
  SetEqualTabStops(memNewNote);
  // adjust heights of pnlAction, pnlFields, and lstEncntShow
end;

procedure TfrmSurgery.mnuViewClick(Sender: TObject);
{ changes the list of notes available for viewing }
var
  //AuthCtxt: TAuthorContext;
  //DateRange: TNoteDateRange;
  AContext: TSurgCaseContext;
  Saved: Boolean;
begin
  inherited;
  // save note at EditingIndex?
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FLastNoteID := lstNotes.ItemID;
  mnuViewDetail.Checked := False;
  uChanging := True;
  AContext := GetCurrentSurgCaseContext;
  StatusText('Retrieving surgery case list...');
  if Sender is TMenuItem then ViewContext := TMenuItem(Sender).Tag
  else with AContext do
    begin
      if ((BeginDate + EndDate + Status + GroupBy + IntToStr(MaxDocs)) <> '0') then
        ViewContext := SR_CUSTOM
      else
        ViewContext := SR_ALL;
    end;
  with tvSurgery do if (Selected <> nil) and (Piece(TORTreeNode(Selected).StringData, U, 10) <> '') then
    FLastNoteID := Piece(TORTreeNode(Selected).StringData, U, 1);
  case ViewContext of
  SR_RECENT, SR_ALL:  begin
                        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                        FillChar(uSurgeryContext, SizeOf(uSurgeryContext), 0);
                        //FCurrentContext.MaxDocs := uSurgeryContext.MaxDocs;
                        FCurrentContext.Status := IntToStr(ViewContext);
                        LoadSurgeryCases;
                      end;
  SR_CUSTOM:     begin
                   if Sender is TMenuItem then
                     begin
                       SelectSurgeryView(Font.Size, True, FCurrentContext, uSurgeryContext);
                     end;
                   with uSurgeryContext do (*if Changed then*)
                   begin
                       FCurrentContext.OpProc := OpProc;
                       FCurrentContext.BeginDate := BeginDate;
                       FCurrentContext.EndDate := EndDate;
                       FCurrentContext.FMBeginDate := FMBeginDate;
                       FCurrentContext.FMEndDate := FMEndDate;
                       if (FMBeginDate > 0) and (FMEndDate > 0) then
                         FCurrentContext.Status := IntToStr(SR_BY_DATE)
                       else
                         FCurrentContext.Status := Status;
                       FCurrentContext.MaxDocs := MaxDocs;
                       FCurrentContext.GroupBy := GroupBy;
                       FCurrentContext.TreeAscending := TreeAscending;
                       LoadSurgeryCases;
                   end;
                 end;
  end; {case}
  lblCases.Caption := SetSurgTreeLabel(FCurrentContext);
  tvSurgery.Caption := lblCases.Caption;
  StatusText('');
end;

procedure TfrmSurgery.popNoteMemoFindClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgFindText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      Options := [frDown, frHideUpDown];
      Execute;
    end;
end;

procedure TfrmSurgery.dlgFindTextFind(Sender: TObject);
begin
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmSurgery.ClearEditControls;
{ resets controls used for entering a new progress note }
begin
  // clear FEditNote (should FEditNote be an object with a clear method?)
  with FEditNote do
  begin
    DocType      := 0;
    Title        := 0;
    TitleName    := '';
    DateTime     := 0;
    Author       := 0;
    AuthorName   := '';
    Cosigner     := 0;
    CosignerName := '';
    Subject      := '';
    Location     := 0;
    LocationName := '';
    PkgRef       := '';
    PkgIEN       := 0;
    PkgPtr       := '';
    NeedCPT      := False;
    Addend       := 0;
    {LastCosigner & LastCosignerName aren't cleared because they're used as default for next note.}
    Lines        := nil;
  end;
  // clear the editing controls (also clear the new labels?)
  txtSubject.Text := '';
  memNewNote.Clear;
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
end;

procedure TfrmSurgery.ShowPCEControls(ShouldShow: Boolean);
begin
  sptVert.Visible    := ShouldShow;
  memPCEShow.Visible := ShouldShow;
  if(ShouldShow) then
    sptVert.Top := memPCEShow.Top - sptVert.Height;
  memSurgery.Invalidate;
end;

procedure TfrmSurgery.DisplayPCE;
{ displays PCE information if appropriate & enables/disabled editing of PCE data }
var
  EnableList, ShowList: TDrawers;
  VitalStr:   TStringlist;
  NoPCE:      boolean;
  ActionSts: TActionRec;
  AnIEN: integer;

begin
  memPCEShow.Clear;
  with lstNotes do if ItemIndex = -1 then
  begin
    ShowPCEControls(FALSE);
    frmDrawers.DisplayDrawers(FALSE);
  end
  else if ItemIndex = EditingIndex then
  begin
    with uPCEEdit do
    begin
      AddStrData(memPCEShow.Lines);
      NoPCE := (memPCEShow.Lines.Count = 0);
      VitalStr  := TStringList.create;
      try
        GetVitalsFromDate(VitalStr, uPCEEdit);
        AddVitalData(VitalStr, memPCEShow.Lines);
      finally
        VitalStr.free;
      end;
      ShowPCEButtons(TRUE);
      ShowPCEControls(cmdPCE.Enabled or (memPCEShow.Lines.Count > 0));
      if(NoPCE and memPCEShow.Visible) then
        memPCEShow.Lines.Insert(0, TX_NOPCE);

      if(InteractiveRemindersActive) then
      begin
        if(GetReminderStatus = rsNone) then
          EnableList := [odTemplates]
        else
          EnableList := [odTemplates, odReminders];
        ShowList := [odTemplates, odReminders];
      end
      else
      begin
        EnableList := [odTemplates];
        ShowList := [odTemplates];
      end;
      frmDrawers.DisplayDrawers(TRUE, EnableList, ShowList);
    end;
  end else
  begin
    ShowPCEButtons(FALSE);
    frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]);
    AnIEN := lstNotes.ItemIEN;
    ActOnDocument(ActionSts, AnIEN, 'VIEW');
    if ActionSts.Success then
    begin
      StatusText('Retrieving encounter information...');
      with uPCEShow do
      begin
        NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
        PCEForNote(AnIEN, uPCEEdit);
        AddStrData(memPCEShow.Lines);
        NoPCE := (memPCEShow.Lines.Count = 0);
        VitalStr  := TStringList.create;
        try
          GetVitalsFromNote(VitalStr, uPCEShow, AnIEN);
          AddVitalData(VitalStr, memPCEShow.Lines);
        finally
          VitalStr.free;
        end;
        ShowPCEControls(memPCEShow.Lines.Count > 0);
        if(NoPCE and memPCEShow.Visible) then
          memPCEShow.Lines.Insert(0, TX_NOPCE);
      end;
      StatusText('');
    end
    else
      ShowPCEControls(FALSE);
  end; {if ItemIndex}
end;

{ supporting calls for writing notes }

function TfrmSurgery.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
begin
  with lstNotes do if ItemIndex > -1 then
    Result := FormatFMDateTime('dddddd', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              '  ' + Piece(Items[AnIndex], U, 2) + ', ' + Piece(Items[AnIndex], U, 6) + ', ' +
              Piece(Piece(Items[AnIndex], U, 5), ';', 2)
end;

function TfrmSurgery.LacksRequiredForCreate: Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
begin
  Result := False;
  with FEditNote do
  begin
    if Title <= 0    then Result := True;
    if Author <= 0   then Result := True;
    if DateTime <= 0 then Result := True;
    if (DocType = TYP_ADDENDUM) then
    begin
      if AskCosignerForDocument(Addend, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end else
    begin
      if Title > 0 then CurTitle := Title else CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Author, DateTime) and (Cosigner <= 0) then Result := True;
    end;
  end;
end;

function TfrmSurgery.VerifyNoteTitle: Boolean;
const
  VNT_UNKNOWN = 0;
  VNT_NO      = 1;
  VNT_YES     = 2;
var
  AParam: string;
begin
  if FVerifyNoteTitle = VNT_UNKNOWN then
  begin
    AParam := GetUserParam('ORWOR VERIFY NOTE TITLE');
    if AParam = '1' then FVerifyNoteTitle := VNT_YES else FVerifyNoteTitle := VNT_NO;
  end;
  Result := FVerifyNoteTitle = VNT_YES;
end;

procedure TfrmSurgery.SetSubjectVisible(ShouldShow: Boolean);
{ hide/show subject & resize panel accordingly - leave 6 pixel margin above memNewNote }
begin
  if ShouldShow then
  begin
    lblSubject.Visible := True;
    txtSubject.Visible := True;
    pnlFields.Height   := txtSubject.Top + txtSubject.Height + 6;
  end else
  begin
    lblSubject.Visible := False;
    txtSubject.Visible := False;
    pnlFields.Height   := lblVisit.Top + lblVisit.Height + 6;
  end;
end;


{ create, edit & save notes }

procedure TfrmSurgery.InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
{ creates the editing context for a new progress note & inserts stub into top of view list }
const
  IS_ID_CHILD = False;
var
  EnableAutosave, HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  x, AClassName: string;
  DocInfo: string;
begin
  if tvSurgery.Selected = nil then exit;
  if PCaseTreeObject(tvSurgery.Selected.Data)^.OperativeProc = '' then
    begin
      InfoBox('You must first select the case to which this document will apply', 'Select a case', 0);
      exit;
    end;
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FillChar(FEditNote, SizeOf(FEditNote), 0);  //v15.7
    with FEditNote do
    begin
      DocType      := TYP_PROGRESS_NOTE;
      Title        := DfltNoteTitle;
      TitleName    := DfltNoteTitleName;
      DateTime     := FMNow;
      Author       := User.DUZ;
      AuthorName   := User.Name;
      Location     := Encounter.Location;
      LocationName := Encounter.LocationName;
      VisitDate    := Encounter.DateTime;
      if IsIDChild then
        IDParent   := AnIDParent
      else
        IDParent   := 0;
      // Cosigner & PkgRef, if needed, will be set by fNoteProps
    end;
    // check to see if interaction necessary to get required fields
    if PCaseTreeObject(tvSurgery.Selected.Data)^.IsNonORProc then AClassName := DCL_SURG_NON_OR else AClassName := DCL_SURG_OR;
    if LacksRequiredForCreate or VerifyNoteTitle
      then HaveRequired := ExecuteNoteProperties(FEditNote, CT_SURGERY, IS_ID_CHILD, IS_ID_CHILD, AClassName, 0)
      else HaveRequired := True;
    if HaveRequired then
    begin
      // set up uPCEEdit for entry of new note
      uPCEEdit.UseEncounter := True;
      uPCEEdit.NoteDateTime := FEditNote.DateTime;
      uPCEEdit.PCEForNote(USE_CURRENT_VISITSTR, uPCEShow);
      FEditNote.NeedCPT  := uPCEEdit.CPTRequired;
       // create the note
      PutNewNote(CreatedNote, FEditNote);

      uPCEEdit.NoteIEN := CreatedNote.IEN;
      if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
      if CreatedNote.ErrorText = '' then
      begin
        //x := $$RESOLVE^TIUSRVLO formatted string
        //7348^Note Title^3000913^NERD, YOURA  (N0165)^1329;Rich Vertigan;VERTIGAN,RICH^8E REHAB MED^complete^Adm: 11/05/98;2981105.095547^        ;^^0^^^2
        with FEditNote do
          begin
            x := IntToStr(CreatedNote.IEN) + U + TitleName + U + FloatToStr(FEditNote.DateTime) + U +
                 Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
                 U + U + U + U + U + U + U;
          end;

        lstNotes.Items.Insert(0, x);
        uChanging := True;
        tvSurgery.Items.BeginUpdate;
(*        if IsIDChild then
          begin
            tmpNode := tvSurgery.FindPieceNode(IntToStr(AnIDParent), 1, U, tvSurgery.Items.GetFirstNode);
            tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
            tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
            tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeCaseTreeObject(x));
            tmpNode.ImageIndex := IMG_ID_CHILD;
            tmpNode.SelectedIndex := IMG_ID_CHILD;
          end
        else*)
          begin
            tmpNode := tvSurgery.Items.AddObjectFirst(tvSurgery.Items.GetFirstNode, 'New Note in Progress',
                                                    MakeCaseTreeObject('NEW^New Note in Progress^^^^^^^^^^^%^0'));
            TORTreeNode(tmpNode).StringData := 'NEW^New Note in Progress^^^^^^^^^^^%^0';
            tmpNode.ImageIndex := IMG_SURG_TOP_LEVEL;
            tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeCaseTreeObject(x));
            tmpNode.ImageIndex := IMG_SURG_RPT_SINGLE;
            tmpNode.SelectedIndex := IMG_SURG_RPT_SINGLE;
          end;
        tmpNode.StateIndex := IMG_NO_IMAGES;
        TORTreeNode(tmpNode).StringData := x;
        tvSurgery.Selected := tmpNode;
        tvSurgery.Items.EndUpdate;
        uChanging := False;
        Changes.Add(CH_SUR, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
        lstNotes.ItemIndex := 0;
        EditingIndex := 0;
        SetSubjectVisible(AskSubjectForNotes);
        if not assigned(TmpBoilerPlate) then
          TmpBoilerPlate := TStringList.Create;
        LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title);
        FChanged := False;
        cmdChangeClick(Self); // will set captions, sign state for Changes
        lstNotesClick(Self);  // will make pnlWrite visible
        if timAutoSave.Interval <> 0 then EnableAutosave := TRUE;
        if txtSubject.Visible then txtSubject.SetFocus else memNewNote.SetFocus;
      end else
      begin
        // if note creation failed or failed to get note lock (both unlikely), unlock consult
        InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
        HaveRequired := False;
      end; {if CreatedNote.IEN}
    end; {if HaveRequired}
    if not HaveRequired then ClearEditControls;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      QuickCopy(TmpBoilerPlate, memNewNote);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
end;

procedure TfrmSurgery.InsertAddendum;
{ sets up fields of pnlWrite to write an addendum for the selected note }
const
  AS_ADDENDUM = True;
  IS_ID_CHILD = False;
var
  HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  tmpNode: TTreeNode;
  x: string;
begin
  ClearEditControls;
  with FEditNote do
  begin
    DocType      := TYP_ADDENDUM;
    Title        := TitleForNote(lstNotes.ItemIEN);
    TitleName    := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    if Copy(TitleName,1,1) = '+' then TitleName := Copy(TitleName, 3, 199);
    DateTime     := FMNow;
    Author       := User.DUZ;
    AuthorName   := User.Name;
    Addend       := lstNotes.ItemIEN;
    x            := GetPackageRefForNote(lstNotes.ItemIEN);
    if Piece(x, U, 1) <> '-1' then
      begin
        PkgRef       := GetPackageRefForNote(lstNotes.ItemIEN);
        PkgIEN       := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr       := Piece(PkgRef, ';', 2);
      end;
    //Lines        := memNewNote.Lines;
    // Cosigner, if needed, will be set by fNoteProps
    // Location info will be set after the encounter is loaded
  end;
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate
    then HaveRequired := ExecuteNoteProperties(FEditNote, CT_SURGERY, IS_ID_CHILD, False, '', 0)
    else HaveRequired := True;
  if HaveRequired then
  begin
    uPCEEdit.NoteDateTime := FEditNote.DateTime;
    uPCEEdit.PCEForNote(FEditNote.Addend, uPCEShow);
    FEditNote.Location     := uPCEEdit.Location;
    FEditNote.LocationName := ExternalName(uPCEEdit.Location, 44);
    FEditNote.VisitDate    := uPCEEdit.DateTime;
    PutAddendum(CreatedNote, FEditNote, FEditNote.Addend);

    uPCEEdit.NoteIEN := CreatedNote.IEN;
    if CreatedNote.IEN > 0 then LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
    if CreatedNote.ErrorText = '' then
    begin
      with FEditNote do
        begin
          x := IntToStr(CreatedNote.IEN) + U + 'Addendum to ' + TitleName + U + FloatToStr(DateTime) + U +
               Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
               U + U + PkgRef + U + U + U + U + U;
        end;


      lstNotes.Items.Insert(0, x);
      uChanging := True;
      tvSurgery.Items.BeginUpdate;
      tmpNode := tvSurgery.Items.AddObjectFirst(tvSurgery.Items.GetFirstNode, 'New Addendum in Progress',
                                              MakeCaseTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_SURG_TOP_LEVEL;
      tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeCaseTreeObject(x));
      TORTreeNode(tmpNode).StringData := x;

      tmpNode.ImageIndex := IMG_SURG_ADDENDUM;
      tmpNode.SelectedIndex := IMG_SURG_ADDENDUM;
      tvSurgery.Selected := tmpNode;
      tvSurgery.Items.EndUpdate;
      uChanging := False;
      Changes.Add(CH_SUR, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
      lstNotes.ItemIndex := 0;
      EditingIndex := 0;
      SetSubjectVisible(AskSubjectForNotes);
      cmdChangeClick(Self); // will set captions, sign state for Changes
      lstNotesClick(Self);  // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
      memNewNote.SetFocus;
    end else
    begin
      // if note creation failed or failed to get note lock (both unlikely), unlock consult
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
    end; {if CreatedNote.IEN}
  end; {if HaveRequired}
  if not HaveRequired then ClearEditControls;
end;

procedure TfrmSurgery.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  x: string;
begin
  ClearEditControls;
  EditingIndex := lstNotes.ItemIndex;
  Changes.Add(CH_SUR, lstNotes.ItemID, GetTitleText(EditingIndex), '', CH_SIGN_YES);
  GetNoteForEdit(FEditNote, lstNotes.ItemIEN);
  memNewNote.Lines.Assign(FEditNote.Lines);
  FChanged := False;
  if FEditNote.Title = TYP_ADDENDUM then
  begin
    FEditNote.DocType := TYP_ADDENDUM;
    FEditNote.TitleName := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    if Copy(FEditNote.TitleName,1,1) = '+' then FEditNote.TitleName := Copy(FEditNote.TitleName, 3, 199);
    if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0
      then FEditNote.TitleName := FEditNote.TitleName + 'Addendum to ';
  end;

  uChanging := True;
  tvSurgery.Items.BeginUpdate;

  tmpNode := tvSurgery.FindPieceNode('EDIT', 1, U, nil);
  if tmpNode = nil then
    begin
      tmpNode := tvSurgery.Items.AddObjectFirst(tvSurgery.Items.GetFirstNode, 'Note being edited',
                                              MakeCaseTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
    end
  else
    tmpNode.DeleteChildren;
  x := lstNotes.Items[lstNotes.ItemIndex];
  tmpNode.ImageIndex := IMG_SURG_TOP_LEVEL;
  tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeCaseTreeObject(x));
  TORTreeNode(tmpNode).StringData := x;
  if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
    tmpNode.ImageIndex := IMG_SURG_RPT_SINGLE
  else
    tmpNode.ImageIndex := IMG_SURG_ADDENDUM;
  tmpNode.SelectedIndex := tmpNode.ImageIndex;
  tvSurgery.Selected := tmpNode;
  tvSurgery.Items.EndUpdate;
  uChanging := False;

  uPCEEdit.NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  uPCEEdit.PCEForNote(lstNotes.ItemIEN, uPCEShow);
  FEditNote.NeedCPT := uPCEEdit.CPTRequired;
  txtSubject.Text := FEditNote.Subject;
  SetSubjectVisible(AskSubjectForNotes);
  cmdChangeClick(Self); // will set captions, sign state for Changes
  lstNotesClick(Self);  // will make pnlWrite visible
  if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
  memNewNote.SetFocus;
end;

procedure TfrmSurgery.SaveEditedNote(var Saved: Boolean);
{ validates fields and sends the updated note to the server }
var
  UpdatedNote: TCreatedDoc;
  x: string;
begin
  Saved := False;
  if (memNewNote.GetTextLen = 0) or (not ContainsVisibleChar(memNewNote.Text)) then
  begin
    lstNotes.ItemIndex := EditingIndex;
    x := lstNotes.ItemID;
    uChanging := True;
    with tvSurgery do Selected := FindPieceNode(x, 1, U, Items.GetFirstNode);
    uChanging := False;
    tvSurgeryChange(Self, tvSurgery.Selected);
    if FSilent or
       ((not FSilent) and
      (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_NOTE, TC_EMPTY_NOTE, MB_YESNO) = IDYES))
    then
      begin
        FConfirmed := True;
        mnuActDeleteClick(Self);
        Saved := True;
        FDeleted := True;
      end
    else
      FConfirmed := False;
    Exit;
  end;
  //ExpandTabsFilter(memNewNote.Lines, TAB_STOP_CHARS);
  FEditNote.Lines    := memNewNote.Lines;
  FEditNote.Subject  := txtSubject.Text;
  FEditNote.NeedCPT  := uPCEEdit.CPTRequired;
  timAutoSave.Enabled := False;
  try
    PutEditedNote(UpdatedNote, FEditNote, lstNotes.GetIEN(EditingIndex));
  finally
    timAutoSave.Enabled := True;
  end;
  // there's no unlocking here since the note is still in Changes after a save
  if UpdatedNote.IEN > 0 then
  begin
    if lstNotes.ItemIndex = EditingIndex then
    begin
      EditingIndex := -1;
      lstNotesClick(Self);
    end;
    EditingIndex := -1; // make sure EditingIndex reset even if not viewing edited note
    Saved := True;
    FChanged := False;
  end else
  begin
    if not FSilent then
      InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmSurgery.SaveCurrentNote(var Saved: Boolean);
{ called whenever a note should be saved - uses IEN to call appropriate save logic }
begin
  if EditingIndex < 0 then Exit;
  SaveEditedNote(Saved);
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmSurgery.cmdNewNoteClick(Sender: TObject);
{ maps 'New Note' button to the New Progress Note menu item }
begin
  inherited;
  mnuActNewClick(Self);
end;

procedure TfrmSurgery.cmdPCEClick(Sender: TObject);
var
  Refresh: boolean;
  ActionSts: TActionRec;
  AnIEN: integer;
  PCEObj: TPCEData;

begin
  inherited;
  cmdPCE.Enabled := False;
  if not FEditingNotePCEObj then
  begin
    PCEObj := nil;
    AnIEN := lstNotes.ItemIEN;
    if (AnIEN <> 0) and (memSurgery.Lines.Count > 0) then
    begin
      ActOnDocument(ActionSts, AnIEN, 'VIEW');
      if ActionSts.Success then
      begin
        uPCEShow.CopyPCEData(uPCEEdit);
        PCEObj := uPCEEdit;
      end;
    end;
    Refresh := EditPCEData(PCEObj);
  end
  else
  begin
    UpdatePCE(uPCEEdit);
    Refresh := TRUE;
  end;
  cmdPCE.Enabled := True;
  if Refresh and (not frmFrame.Closing) then
    DisplayPCE;
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmSurgery.mnuActChangeClick(Sender: TObject);
begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  cmdChangeClick(Sender);
end;

procedure TfrmSurgery.mnuActLoadBoilerClick(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
    QuickCopy(BoilerText, memNewNote);
    FChanged := False;
  end;

begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  BoilerText := TStringList.Create;
  try
    NoteEmpty := memNewNote.Text = '';
    LoadBoilerPlate(BoilerText, FEditNote.Title);
    if (BoilerText.Text <> '') or
       assigned(GetLinkedTemplate(IntToStr(FEditNote.Title), ltTitle)) then
    begin
      if NoteEmpty then AssignBoilerText else
      begin
        DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
        case QueryBoilerPlate(BoilerText) of
        0:  { do nothing } ;                         // ignore
        1: begin
             ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
             QuickAdd(BoilerText, memNewNote);  // append
           end;
        2: AssignBoilerText;                         // replace
        end;
      end;
    end else
    begin
      if Sender = mnuActLoadBoiler
        then InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
        else
        begin
          if not NoteEmpty then
            if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
              then memNewNote.Lines.Clear;
        end;
    end; {if BoilerText.Text <> ''}
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmSurgery.cmdChangeClick(Sender: TObject);
const
  IS_ID_CHILD = False;
var
  LastTitle: Integer;
  OKPressed: boolean;
  x, AClassName: string;
begin
  inherited;
  LastTitle   := FEditNote.Title;
  if IsNonORProcedure(FEditNote.PkgIEN) then AClassName := DCL_SURG_NON_OR else AClassName := DCL_SURG_OR;
  if Sender <> Self then OKPressed := ExecuteNoteProperties(FEditNote, CT_SURGERY, IS_ID_CHILD, IS_ID_CHILD, AClassName, 0)
    else OKPressed := True;
  if not OKPressed then Exit;
  // update display fields & uPCEEdit
  lblNewTitle.Caption := ' ' + FEditNote.TitleName + ' ';
  if (FEditNote.Addend > 0) and (CompareText(Copy(lblNewTitle.Caption, 2, 8), 'Addendum') <> 0)
    then lblNewTitle.Caption := ' Addendum to:' + lblNewTitle.Caption;
  with lblNewTitle do bvlNewTitle.SetBounds(Left - 1, Top - 1, Width + 2, Height + 2);
  lblRefDate.Caption := FormatFMDateTime('dddddd@hh:nn', FEditNote.DateTime);
  lblAuthor.Caption  := FEditNote.AuthorName;
  if uPCEEdit.Inpatient then x := 'Adm: ' else x := 'Vst: ';
  x := x + FormatFMDateTime('ddddd', FEditNote.VisitDate) + '  ' + FEditNote.LocationName;
  lblVisit.Caption   := x;
  if Length(FEditNote.CosignerName) > 0
    then lblCosigner.Caption := 'Expected Cosigner: ' + FEditNote.CosignerName
    else lblCosigner.Caption := '';
  uPCEEdit.NoteTitle  := FEditNote.Title;
  // modify signature requirements if author or cosigner changed
  if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner)
    then Changes.ReplaceSignState(CH_SUR, lstNotes.ItemID, CH_SIGN_NA)
    else Changes.ReplaceSignState(CH_SUR, lstNotes.ItemID, CH_SIGN_YES);
  x := lstNotes.Items[EditingIndex];
  SetPiece(x, U, 2, lblNewTitle.Caption);
  SetPiece(x, U, 3, FloatToStr(FEditNote.DateTime));
  tvSurgery.Selected.Text := MakeNoteDisplayText(x);
  TORTreeNode(tvSurgery.Selected).StringData := x;
  lstNotes.Items[EditingIndex] := x;
  Changes.ReplaceText(CH_SUR, lstNotes.ItemID, GetTitleText(EditingIndex));
  if LastTitle <> FEditNote.Title then mnuActLoadBoilerClick(Self);
end;

procedure TfrmSurgery.memNewNoteChange(Sender: TObject);
begin
  inherited;
  FChanged := True;
end;

procedure TfrmSurgery.pnlFieldsResize(Sender: TObject);
{ center the reference date on the panel }
begin
  inherited;
  lblRefDate.Left := (pnlFields.Width - lblRefDate.Width) div 2;
  if lblRefDate.Left < (lblNewTitle.Left + lblNewTitle.Width + 6)
    then lblRefDate.Left := (lblNewTitle.Left + lblNewTitle.Width);
end;

procedure TfrmSurgery.DoAutoSave(Suppress: integer = 1);
var
  ErrMsg: string;
begin
  if fFrame.frmFrame.DLLActive = true then Exit;  
  if (EditingIndex > -1) and FChanged then
  begin
    StatusText('Autosaving note...');
    //PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
    timAutoSave.Enabled := False;
    try
      SetText(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex), Suppress);
    finally
      timAutoSave.Enabled := True;
    end;
    FChanged := False;
    StatusText('');
  end;
  if ErrMsg <> '' then
    InfoBox(TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  //Assert(ErrMsg = '', 'AutoSave: ' + ErrMsg);
end;

procedure TfrmSurgery.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
end;

{ Action menu events ----------------------------------------------------------------------- }

function TfrmSurgery.StartNewEdit(NewNoteType: integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  Msg, CapMsg: string;
begin
  Result := True;
  if EditingIndex > -1 then
  begin
    case NewNoteType of
      NT_ACT_ADDENDUM:  begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE3;
                          CapMsg := TC_NEW_SAVE3;
                        end;
      NT_ACT_EDIT_NOTE: begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE4;
                          CapMsg := TC_NEW_SAVE4;
                        end;
    else
      begin
        Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE2;
        CapMsg := TC_NEW_SAVE2;
      end;
    end;
    if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then Result := False
    else
      begin
        SaveCurrentNote(Saved);
        if not Saved then Result := False else LoadSurgeryCases;
      end;
  end;
end;

procedure TfrmSurgery.mnuActNewClick(Sender: TObject);
const
  IS_ID_CHILD = False;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  if not StartNewEdit(NT_ACT_NEW_NOTE) then Exit;
  //LoadNotes;
  // make sure a visit (time & location) is available before creating the note
  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size, DfltTIULocation);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  InsertNewNote(IS_ID_CHILD, 0);
end;


procedure TfrmSurgery.mnuActAddendClick(Sender: TObject);
{ make an addendum to an existing note }
var
  ActionSts: TActionRec;
  ANoteID: string;
begin
  inherited;
  if lstNotes.ItemIEN <= 0 then Exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_ADDENDUM) then Exit;
  //LoadNotes;
  with tvSurgery do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  if lstNotes.ItemIndex = EditingIndex then
  begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstNotes do if TitleForNote(lstNotes.ItemIEN) = TYP_ADDENDUM then
  begin
    InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  InsertAddendum;
end;


procedure TfrmSurgery.mnuActSignListClick(Sender: TObject);
{ add the note to the Encounter object, see mnuActSignClick - copied}
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  ActionType, SignTitle: string;
  ActionSts: TActionRec;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then Exit;
  if lstNotes.ItemIndex = EditingIndex then Exit;  // already in signature list
  if not NoteHasText(lstNotes.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstNotes.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstNotes.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstNotes do Changes.Add(CH_SUR, ItemID, GetTitleText(ItemIndex), '', CH_SIGN_YES);
end;

procedure TfrmSurgery.RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
begin
  if IEN = NT_ADDENDUM then Exit;  // no PCE information entered for an addendum
  // do we need to call DeletePCE(AVisitStr), as was done with NT_NEW_NOTE (ien=-10)???
  if AVisitStr = '' then AVisitStr := VisitStrForNote(IEN);
  Changes.Remove(CH_PCE, 'V' + AVisitStr);
  Changes.Remove(CH_PCE, 'P' + AVisitStr);
  Changes.Remove(CH_PCE, 'D' + AVisitStr);
  Changes.Remove(CH_PCE, 'I' + AVisitStr);
  Changes.Remove(CH_PCE, 'S' + AVisitStr);
  Changes.Remove(CH_PCE, 'A' + AVisitStr);
  Changes.Remove(CH_PCE, 'H' + AVisitStr);
  Changes.Remove(CH_PCE, 'E' + AVisitStr);
  Changes.Remove(CH_PCE, 'T' + AVisitStr);
end;

procedure TfrmSurgery.mnuActDeleteClick(Sender: TObject);
{ delete the selected progress note & remove from the Encounter object if necessary }
var
  DeleteSts, ActionSts: TActionRec;
  SavedDocIEN: Integer;
  ReasonForDelete, AVisitStr, SavedDocID, ErrMsg: string;
  Saved: boolean;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then Exit;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'DELETE RECORD');
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(lstNotes.ItemIEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  if (Sender <> Self) and (InfoBox(MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]) + TX_DEL_OK,
    TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  // do the appropriate locking
  ErrMsg := '';
  LockDocument(lstNotes.ItemIEN, ErrMsg);
  if ErrMsg <> '' then
    begin
      InfoBox(ErrMsg, TC_NO_LOCK, MB_OK);
      Exit;
    end;
  // retraction notification message
  if JustifyDocumentDelete(lstNotes.ItemIEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocID := lstNotes.ItemID;
  SavedDocIEN := lstNotes.ItemIEN;
  if (EditingIndex > -1) and (not FConfirmed) and (lstNotes.ItemIndex <> EditingIndex) and (memNewNote.GetTextLen > 0) then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
  EditingIndex := -1;
  FConfirmed := False;
  // remove the note
  DeleteSts.Success := True;
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN) then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_SUR, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_SUR, SavedDocID);  // this will unlock the document if in Changes
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    LoadSurgeryCases;
      pnlWrite.Visible := False;
      pnlRead.Visible := True;
      UpdateReminderFinish;
      ShowPCEControls(False);
      frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
      ShowPCEButtons(FALSE);
    //end; {if ItemIndex}
  end {if DeleteSts}
  else InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
end;

procedure TfrmSurgery.mnuActEditClick(Sender: TObject);
{ load the selected progress note for editing }
var
  ActionSts: TActionRec;
  ANoteID: string;
begin
  inherited;
  if lstNotes.ItemIndex = EditingIndex then Exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_EDIT_NOTE) then Exit;
  //LoadNotes;
  with tvSurgery do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LoadForEdit;
end;

procedure TfrmSurgery.mnuActSaveClick(Sender: TObject);
{ saves the note that is currently being edited }
var
  Saved: Boolean;
  SavedDocID: string;
begin
  inherited;
  if EditingIndex > -1 then
    begin
      SavedDocID := Piece(lstNotes.Items[EditingIndex], U, 1);
      FLastNoteID := SavedDocID;
      SaveCurrentNote(Saved);
      if Saved and (EditingIndex < 0) and (not FDeleted) then
      //if Saved then
        begin
          LoadSurgeryCases;
          with tvSurgery do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
       end;
    end
  else InfoBox(TX_NO_NOTE, TX_SAVE_NOTE, MB_OK or MB_ICONWARNING);
end;

procedure TfrmSurgery.mnuActSignClick(Sender: TObject);
{ sign the currently selected note, save first if necessary }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  Saved, NoteUnlocked: Boolean;
  ActionType, ESCode, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  OK: boolean;
  SavedDocID, tmpItem: string;
  EditingID: string;                                         //v22.12 - RV
  tmpNode: TTreeNode;
begin
  inherited;
(*  if lstNotes.ItemIndex = EditingIndex then                //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentNote(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex];                 //v22.12 - RV
  SavedDocID := lstNotes.ItemID;*)                           //v22.12 - RV
  SavedDocID := lstNotes.ItemID;                             //v22.12 - RV
  FLastNoteID := SavedDocID;                                 //v22.12 - RV
  if lstNotes.ItemIndex = EditingIndex then                  //v22.12 - RV
  begin                                                      //v22.12 - RV
    SaveCurrentNote(Saved);                                  //v22.12 - RV
    if (not Saved) or FDeleted then Exit;                    //v22.12 - RV
  end                                                        //v22.12 - RV
  else if EditingIndex > -1 then                             //v22.12 - RV
  begin                                                      //v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex];                 //v22.12 - RV
    EditingID := Piece(tmpItem, U, 1);                       //v22.12 - RV
  end;                                                       //v22.12 - RV
  if not NoteHasText(lstNotes.ItemIEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      Exit;
    end;
  if not LastSaveClean(lstNotes.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then Exit;
  if CosignDocument(lstNotes.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  // no exits after things are locked
  NoteUnlocked := False;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if ActionSts.Success then
  begin
    OK := IsOK2Sign(uPCEShow, lstNotes.ItemIEN);
    if frmFrame.Closing then exit;
    if(uPCEShow.Updated) then
    begin
      uPCEShow.CopyPCEData(uPCEEdit);
      uPCEShow.Updated := FALSE;
      lstNotesClick(Self);
    end;
    if(OK) then
    begin
      //DisplayOpTop(lstNotes.ItemIEN);        v24.2 - RV
      with lstNotes do SignatureForItem(Font.Size, MakeNoteDisplayText(Items[ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_SUR, lstNotes.ItemID);
        Changes.Remove(CH_SUR, lstNotes.ItemID);  // this will unlock if in Changes
        if SignSts.Success then
        begin
          SendMessage(frmConsults.Handle, UM_NEWORDER, ORDER_SIGN, 0);      {*REV*}
          lstNotesClick(Self);
        end
        else InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if Length(ESCode)}
    end;
  end
  else InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not NoteUnlocked then UnlockDocument(lstNotes.ItemIEN);
  LoadSurgeryCases;
  //if EditingIndex > -1 then         //v22.12 - RV
  if (EditingID <> '') then           //v22.12 - RV
    begin
      lstNotes.Items.Insert(0, tmpItem);
      tmpNode := tvSurgery.Items.AddObjectFirst(tvSurgery.Items.GetFirstNode, 'Note being edited',
                 MakeCaseTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_SURG_TOP_LEVEL;
      tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(tmpItem), MakeCaseTreeObject(tmpItem));
      TORTreeNode(tmpNode).StringData := tmpItem;
      SetCaseTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext);
      EditingIndex := lstNotes.SelectByID(EditingID);                 //v22.12 - RV
    end;
  //with tvSurgery do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);  //v22.12 - RV
  with tvSurgery do                                                                  //v22.12 - RV
  begin                                                                              //v22.12 - RV
    Selected := FindPieceNode(FLastNoteID, U, Items.GetFirstNode);                   //v22.12 - RV
    if Selected <> nil then tvSurgeryChange(Self, Selected);                         //v22.12 - RV
  end;                                                                               //v22.12 - RV
end;

procedure TfrmSurgery.SaveSignItem(const ItemID, ESCode: string);
{ saves and optionally signs a progress note or addendum }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  AnIndex, IEN, i: Integer;
  Saved, ContinueSign: Boolean;  {*RAB* 8/26/99}
  ActionSts, SignSts: TActionRec;
  APCEObject: TPCEData;
  OK: boolean;
  ActionType, SignTitle: string;
begin
  AnIndex := -1;
  IEN := StrToIntDef(ItemID, 0);
  if IEN = 0 then Exit;
  if frmFrame.TimedOut and (EditingIndex <> -1) then FSilent := True;
  with lstNotes do for i := 0 to Items.Count - 1 do if lstNotes.GetIEN(i) = IEN then
  begin
    AnIndex := i;
    break;
  end;
  if (AnIndex > -1) and (AnIndex = EditingIndex) then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    if FDeleted then
      begin
        FDeleted := False;
        Exit;
      end;
    AnIndex := lstNotes.SelectByIEN(IEN);
    //IEN := lstNotes.GetIEN(AnIndex);                    // saving will change IEN
  end;
  if Length(ESCode) > 0 then
  begin
    if CosignDocument(IEN) then
    begin
      SignTitle := TX_COSIGN;
      ActionType := SIG_COSIGN;
    end else
    begin
      SignTitle := TX_SIGN;
      ActionType := SIG_SIGN;
    end;
    ActOnDocument(ActionSts, IEN, ActionType);
    if not ActionSts.Success then
      begin
        InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
        ContinueSign := False;
      end
    else if not NoteHasText(IEN) then
      begin
        InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
        ContinueSign := False;
      end
    else if not LastSaveClean(IEN) and
      (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES)
       then ContinueSign := False
    else ContinueSign := True;
    if ContinueSign then
    begin
      if (AnIndex >= 0) and (AnIndex = lstNotes.ItemIndex) then
        APCEObject := uPCEShow
      else
        APCEObject := nil;
      OK := IsOK2Sign(APCEObject, IEN);
      if frmFrame.Closing then exit;
      if(assigned(APCEObject)) and (uPCEShow.Updated) then
      begin
        uPCEShow.CopyPCEData(uPCEEdit);
        uPCEShow.Updated := FALSE;
        lstNotesClick(Self);
      end
      else
        uPCEEdit.Clear;
      if(OK) then
      begin
        //if not FSilent then DisplayOpTop(IEN);
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if OK}
    end; {if ContinueSign}
  end; {if Length(ESCode)}

  if (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then
    begin
      LoadSurgeryCases;                    //????????????????
      with tvSurgery do Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
    end;
end;

procedure TfrmSurgery.popNoteMemoPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteMemo) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popNoteMemo))
    else FEditCtrl := nil;
  if FEditCtrl <> nil then
  begin
    popNoteMemoCut.Enabled      := FEditCtrl.SelLength > 0;
    popNoteMemoCopy.Enabled     := popNoteMemoCut.Enabled;
    popNoteMemoPaste.Enabled    := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                   Clipboard.HasFormat(CF_TEXT);
    popNoteMemoTemplate.Enabled := frmDrawers.CanEditTemplates and popNoteMemoCut.Enabled;
    popNoteMemoFind.Enabled := FEditCtrl.GetTextLen > 0;
  end else
  begin
    popNoteMemoCut.Enabled      := False;
    popNoteMemoCopy.Enabled     := False;
    popNoteMemoPaste.Enabled    := False;
    popNoteMemoTemplate.Enabled := False;
  end;
  if pnlWrite.Visible then
  begin
    popNoteMemoSpell.Enabled    := True;
    popNoteMemoGrammar.Enabled  := True;
    popNoteMemoReformat.Enabled := True;
    popNoteMemoReplace.Enabled  := (FEditCtrl.GetTextLen > 0);
    popNoteMemoPreview.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popNoteMemoInsTemplate.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
  end else
  begin
    popNoteMemoSpell.Enabled    := False;
    popNoteMemoGrammar.Enabled  := False;
    popNoteMemoReformat.Enabled := False;
    popNoteMemoReplace.Enabled  := False;
    popNoteMemoPreview.Enabled  := False;
    popNoteMemoInsTemplate.Enabled  := False;
  end;
end;

procedure TfrmSurgery.popNoteMemoCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmSurgery.popNoteMemoCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmSurgery.popNoteMemoPasteClick(Sender: TObject);
begin
  inherited;
 // FEditCtrl.SelText := Clipboard.AsText; {*KCM*}
  ScrubTheClipboard;
  FEditCtrl.PasteFromClipboard;        // use AsText to prevent formatting
end;

procedure TfrmSurgery.popNoteMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memNewNote then Exit;
  ReformatMemoParagraph(memNewNote);
end;

procedure TfrmSurgery.popNoteMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmSurgery.popNoteMemoReplaceClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgReplaceText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      ReplaceText := '';
      Options := [frDown, frHideUpDown];
      Execute;
    end;
end;

procedure TfrmSurgery.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmSurgery.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmSurgery.popNoteMemoSpellClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    SpellCheckForControl(memNewNote);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmSurgery.popNoteMemoGrammarClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    GrammarCheckForControl(memNewNote);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmSurgery.mnuViewDetailClick(Sender: TObject);
var
  x: string;
begin
  inherited;
  with tvSurgery do
    begin
      if Selected = nil then exit;
      if not (Selected.ImageIndex in [IMG_SURG_TOP_LEVEL, IMG_SURG_GROUP_SHUT, IMG_SURG_GROUP_OPEN,
                                      IMG_SURG_NON_OR_CASE_EMPTY, IMG_SURG_NON_OR_CASE_SHUT, IMG_SURG_NON_OR_CASE_OPEN,
                                      IMG_SURG_CASE_EMPTY, IMG_SURG_CASE_SHUT, IMG_SURG_CASE_OPEN]) then
        begin
          mnuViewDetail.Checked := not mnuViewDetail.Checked;
          if mnuViewDetail.Checked then
            begin
              x := TORTreeNode(Selected).StringData;
              StatusText('Retrieving selected surgery report details...');
              pnlRead.Visible := True;
              pnlWrite.Visible := False;
              Screen.Cursor := crHourGlass;
              LoadSurgReportDetail(memSurgery.Lines, StrToIntDef(Piece(x, U, 1), 0));
              Screen.Cursor := crDefault;
              StatusText('');
              memSurgery.SelStart := 0;
              memSurgery.Repaint;
            end
          else
            tvSurgeryChange(Self, Selected);
        end;
    end;
  SendMessage(memSurgery.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmSurgery.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Saved: Boolean;
  IEN: Int64;
  ErrMsg: string;
  DeleteSts: TActionRec;
begin
  inherited;
  if frmFrame.TimedOut and (EditingIndex <> -1) then
  begin
    FSilent := True;
    if memNewNote.GetTextLen > 0 then SaveCurrentNote(Saved)
    else
    begin
      IEN := lstNotes.GetIEN(EditingIndex);
      if not LastSaveClean(IEN) then             // means note hasn't been committed yet
      begin
        LockDocument(IEN, ErrMsg);
        if ErrMsg = '' then
        begin
          DeleteDocument(DeleteSts, IEN, '');
          UnlockDocument(IEN);
        end; {if ErrMsg}
      end; {if not LastSaveClean}
    end; {else}
  end; {if frmFrame}
end;

procedure TfrmSurgery.mnuActIdentifyAddlSignersClick(Sender: TObject);
var
  Exclusions: TStrings;
  Saved, x, y: boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  SigAction: integer;
  SavedDocID: string;
  ARefDate: TFMDateTime;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if lstNotes.ItemIndex = EditingIndex then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
      LoadSurgeryCases;
      with tvSurgery do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    end;
  x := CanChangeCosigner(lstNotes.ItemIEN);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'IDENTIFY SIGNERS');
  y := ActionSts.Success;
  if x and not y then
    begin
      if InfoBox(ActionSts.Reason + CRLF + CRLF +
                 'Would you like to change the cosigner?',
                 TX_IN_AUTH, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES then
    	SigAction := SG_COSIGNER
      else
	Exit;
    end
  else if y and not x then SigAction := SG_ADDITIONAL
  else if x and y then SigAction := SG_BOTH
  else
    begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
      Exit;
    end;

  Exclusions := GetCurrentSigners(lstNotes.ItemIEN);
  ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  SelectAdditionalSigners(Font.Size, lstNotes.ItemIEN, SigAction, Exclusions, SignerList, CT_NOTES, ARefDate);
  with SignerList do
    begin
      case SigAction of
        SG_ADDITIONAL:  if Changed and (Signers <> nil) and (Signers.Count > 0) then
                          UpdateAdditionalSigners(lstNotes.ItemIEN, Signers);
        SG_COSIGNER:    if Changed then ChangeCosigner(lstNotes.ItemIEN, Cosigner);
        SG_BOTH:        if Changed then
                          begin
                            if (Signers <> nil) and (Signers.Count > 0) then
                              UpdateAdditionalSigners(lstNotes.ItemIEN, Signers);
                            ChangeCosigner(lstNotes.ItemIEN, Cosigner);
                          end;
      end;
      lstNotesClick(Self);
    end;
  UnlockDocument(lstNotes.ItemIEN);
end;

procedure TfrmSurgery.popNoteMemoAddlSignClick(Sender: TObject);
begin
  inherited;
  mnuActIdentifyAddlSignersClick(Self);
end;

procedure TfrmSurgery.ProcessNotifications;
var
  x: string;
  Saved: boolean;
  //tmpNode: TTreeNode;
  //AnObject: PCaseTreeObject;
  tmpList: TStringList;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  lblCases.Caption := Notifications.Text;
  tvSurgery.Caption := lblCases.Caption;
  EditingIndex := -1;
  lstNotes.Enabled := True ;
  pnlRead.BringToFront ;
  //  show ALL unsigned/uncosigned for a patient, not just the alerted one
  //  what about cosignature?  How to get correct list?  ORB FOLLOWUP TYPE = OR alerts only
  x := Notifications.AlertData;
  if StrToIntDef(Piece(x, U, 1), 0) = 0 then
    begin
      InfoBox(TX_NO_ALERT, TX_CAP_NO_ALERT, MB_OK);
      Exit;
    end;
  tmpList := TStringList.Create;
  try
    FCaseList.Clear;
    uChanging := True;
    tvSurgery.Items.BeginUpdate;
    lstNotes.Clear;
    KillCaseTreeObjects(tvSurgery);
    tvSurgery.Items.Clear;
    GetSingleCaseListItemWithDocs(tmpList, StrToIntDef(Piece(x, U, 1), 0));
    with FCurrentContext do CreateListItemsForCaseTree(FCaseList, tmpList, SR_ALL, GroupBy, TreeAscending);
    UpdateTreeView(FCaseList, tvSurgery);
    with tvSurgery do Selected := FindPieceNode(Piece(x, U, 1), 1, U, Items.GetFirstNode);
    (*  lstNotes.Items.Add(x);
    AnObject := MakeCaseTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
    tmpNode := tvSurgery.Items.AddObjectFirst(tvSurgery.Items.GetFirstNode, AnObject.NodeText, AnObject);
    TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
    tmpNode.ImageIndex := IMG_SURG_TOP_LEVEL;
    AnObject := MakeCaseTreeObject(x);
    tmpNode := tvSurgery.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText, AnObject);
    TORTreeNode(tmpNode).StringData := x;
    SetCaseTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext);
    tvSurgery.Selected := tmpNode;*)
    tvSurgery.Items.EndUpdate;
    uChanging := False;
    tvSurgeryChange(Self, tvSurgery.Selected);
    case Notifications.Followup of
      NF_SURGERY_UNSIGNED_NOTE:   ;  //Automatically deleted by sig action!!!
    end;
    if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then Notifications.Delete;
    if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then Notifications.Delete;
  finally
    tmpList.Free;
  end;
end;

procedure TfrmSurgery.mnuViewSaveAsDefaultClick(Sender: TObject);
begin
  inherited;
  if InfoBox('Replace current defaults?', 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      SaveCurrentSurgCaseContext(FCurrentContext);
      FDefaultContext := FCurrentContext;
      lblCases.Caption := 'Default List';
      tvSurgery.Caption := lblCases.Caption;
    end;
end;

procedure TfrmSurgery.mnuViewReturntoDefaultClick(Sender: TObject);
begin
  inherited;
  SetViewContext(FDefaultContext);
end;

procedure TfrmSurgery.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, FEditCtrl.SelText);
end;

procedure TfrmSurgery.popNoteListPopup(Sender: TObject);
begin
  inherited;
  N4.Visible                          := (popNoteList.PopupComponent is TORTreeView);
  popNoteListExpandAll.Visible        := N4.Visible;
  popNoteListExpandSelected.Visible   := N4.Visible;
  popNoteListCollapseAll.Visible      := N4.Visible;
  popNoteListCollapseSelected.Visible := N4.Visible;
end;

procedure TfrmSurgery.popNoteListExpandAllClick(Sender: TObject);
begin
  inherited;
  tvSurgery.FullExpand;
end;

procedure TfrmSurgery.popNoteListCollapseAllClick(Sender: TObject);
begin
  inherited;
  tvSurgery.Selected := nil;
  memSurgery.Clear;
  tvSurgery.FullCollapse;
  tvSurgery.Selected := tvSurgery.TopItem;
end;

procedure TfrmSurgery.popNoteListExpandSelectedClick(Sender: TObject);
begin
  inherited;
  if tvSurgery.Selected = nil then exit;
  with tvSurgery.Selected do if HasChildren then Expand(True);
end;

procedure TfrmSurgery.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvSurgery.Selected = nil then exit;
  with tvSurgery.Selected do if HasChildren then Collapse(True);
end;

procedure TfrmSurgery.mnuEditTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self);
end;

procedure TfrmSurgery.mnuNewTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE);
end;

procedure TfrmSurgery.mnuEditSharedTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, FALSE, '', TRUE);
end;

procedure TfrmSurgery.mnuNewSharedTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, '', TRUE);
end;

procedure TfrmSurgery.mnuOptionsClick(Sender: TObject);
begin
  inherited;
  mnuEditTemplates.Enabled := frmDrawers.CanEditTemplates;
  mnuNewTemplate.Enabled := frmDrawers.CanEditTemplates;
  mnuEditSharedTemplates.Enabled := frmDrawers.CanEditShared;
  mnuNewSharedTemplate.Enabled := frmDrawers.CanEditShared;
  mnuEditDialgFields.Enabled := CanEditTemplateFields;
end;

procedure TfrmSurgery.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if(FEditingIndex < 0) then
    KillReminderDialog(Self);
  if(assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

(*function TfrmSurgery.CanFinishReminder: boolean;
begin
  Result := False;
  if(EditingIndex < 0) then
    Result := FALSE
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;*)

procedure TfrmSurgery.AssignRemForm;
begin
(*  with RemForm do
  begin
    Form := Self;
    PCEObj := uPCEEdit;
    RightPanel := pnlRight;
    CanFinishProc := CanFinishReminder;
    DisplayPCEProc := DisplayPCE;
    Drawers := frmDrawers;
    NewNoteRE := memNewNote;
    NoteList := lstNotes;
  end;*)
end;

procedure TfrmSurgery.mnuEditDialgFieldsClick(Sender: TObject);
begin
  inherited;
  EditDialogFields;
end;


procedure TfrmSurgery.tvSurgeryClick(Sender: TObject);
begin
  if tvSurgery.Selected = nil then exit;
  if (tvSurgery.Selected.ImageIndex in [IMG_SURG_TOP_LEVEL, IMG_SURG_GROUP_OPEN, IMG_SURG_GROUP_SHUT]) then
    memSurgery.Clear;
end;

procedure TfrmSurgery.ShowPCEButtons(Editing: boolean);
begin
  FEditingNotePCEObj := Editing;
  if Editing or AnytimeEncounters then
  begin
    cmdPCE.Visible := TRUE;
    if Editing then
    begin
      cmdPCE.Enabled := CanEditPCE(uPCEEdit);
{ TODO -oRich V. -cSurgery/TIU : Uncomment if allow new notes from Surgery tab }
      //cmdNewNote.Visible := AnytimeEncounters;
      //cmdNewNote.Enabled := FALSE;
    end
    else
    begin
      cmdPCE.Enabled     := (GetAskPCE(0) <> apDisable);
{ TODO -oRich V. -cSurgery/TIU : Uncomment if allow new notes from Surgery tab }
      //cmdNewNote.Visible := TRUE;
      //cmdNewNote.Enabled := TRUE;
    end;
    if cmdNewNote.Visible then
      cmdPCE.Top := cmdNewNote.Top-cmdPCE.Height;
  end
  else
  begin
    cmdPCE.Enabled := FALSE;
    cmdPCE.Visible := FALSE;
{ TODO -oRich V. -cSurgery/TIU : Uncomment if allow new notes from Surgery tab }
    //cmdNewNote.Visible := TRUE;
    //cmdNewNote.Enabled := TRUE;
  end;
  if cmdPCE.Visible then
    lblSpace1.Top := cmdPCE.Top - lblSpace1.Height
  else
    lblSpace1.Top := cmdNewNote.Top - lblSpace1.Height;
  popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
  popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmSurgery.mnuIconLegendClick(Sender: TObject);
begin
  inherited;
  ShowIconLegend(ilSurgery);
end;

procedure TfrmSurgery.tvSurgeryChange(Sender: TObject;
  Node: TTreeNode);
var
  x: string;
  IsTIUDocument: boolean;
  //MsgString, HasImages: string;
  //ShowReport: boolean;
begin
  if uChanging then Exit;
  //This gives the change a chance to occur when keyboarding, so that WindowEyes
  //doesn't use the old value.
  Application.ProcessMessages;
  //ShowReport := True;
  with tvSurgery do
    begin
      if Selected = nil then Exit;
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      RedrawSuspend(memSurgery.Handle);
      memSurgery.Clear;
      if not (Selected.ImageIndex in [IMG_SURG_TOP_LEVEL, IMG_SURG_GROUP_OPEN, IMG_SURG_GROUP_SHUT]) then
        begin
          x := TORTreeNode(Selected).StringData;
          memSurgery.Clear;
          StatusText('Retrieving selected surgery report...');
          Screen.Cursor := crHourGlass;
          pnlRead.Visible := True;
          pnlWrite.Visible := False;
          //UpdateReminderFinish;
          IsTIUDocument := PCaseTreeObject(Selected.Data)^.PkgRef <> '';
          EnableDisableMenus(IsTIUDocument);
          if not IsTIUDocument then
            begin
              lblTitle.Caption := MakeSurgeryCaseDisplayText(x);
              lblTitle.Hint := lblTitle.Caption;
              //LoadOpTop(memSurgery.Lines, StrToIntDef(Piece(x, U, 1), 0), PCaseTreeObject(Selected.Data)^.IsNonORProc, ShowReport);
              //--------------------------------------------------------------------------------------------------------
              //  DON'T DO THIS UNTIL SURGERY API IS CHANGED - OTHERWISE WILL GIVE FALSE '0' COUNT FOR EVERY CASE  (RV)
(*              MsgString := 'SUR^' + Piece(x, U, 1);
              HasImages := BOOLCHAR[PCaseTreeObject(Selected.Data)^.ImageCount > 0];
              SetPiece(MsgString, U, 10, HasImages);
              NotifyOtherApps(NAE_REPORT, 'SUR^' + MsgString);*)
              //--------------------------------------------------------------------------------------------------------
              NotifyOtherApps(NAE_REPORT, 'SUR^' + Piece(x, U, 1));
              lstNotes.ItemIndex := -1;
            end
          else
            begin
              lstNotes.SelectByID(Piece(x, U, 1));
              lstNotesClick(Self);
            end;
          Screen.Cursor := crDefault;
          StatusText('');
          SendMessage(memSurgery.Handle, WM_VSCROLL, SB_TOP, 0);
        end
      else
        begin
          lblTitle.Caption := '';
          lblTitle.Hint := lblTitle.Caption;
          pnlWrite.Visible := False;
          pnlRead.Visible := True;
          //UpdateReminderFinish;
          ShowPCEControls(False);
          frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
          ShowPCEButtons(FALSE);
          memSurgery.Clear;
        end;
      if(assigned(frmReminderTree)) then
        frmReminderTree.EnableActions;
      DisplayPCE;
      pnlRight.Refresh;
      memNewNote.Repaint;
      memSurgery.Repaint;
      SendMessage(tvSurgery.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
      RedrawActivate(memSurgery.Handle);
    end;
end;

procedure TfrmSurgery.tvSurgeryExpanded(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_SURG_GROUP_SHUT, IMG_SURG_CASE_SHUT, IMG_SURG_NON_OR_CASE_SHUT]) then
        ImageIndex := ImageIndex + 1;
      if (SelectedIndex in [IMG_SURG_GROUP_SHUT, IMG_SURG_CASE_SHUT, IMG_SURG_NON_OR_CASE_SHUT]) then
        SelectedIndex := SelectedIndex + 1;
    end;
  SendMessage(tvSurgery.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
end;

procedure TfrmSurgery.tvSurgeryCollapsed(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_SURG_GROUP_OPEN, IMG_SURG_CASE_OPEN, IMG_SURG_NON_OR_CASE_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_SURG_GROUP_OPEN, IMG_SURG_CASE_OPEN, IMG_SURG_NON_OR_CASE_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmSurgery.LoadSurgeryCases;
var
  tmpList: TStringList;
  ANode: TORTreeNode;
begin
  tmpList := TStringList.Create;
  try
    FCaseList.Clear;
    uChanging := True;
    RedrawSuspend(memSurgery.Handle);
    tvSurgery.Items.BeginUpdate;
    KillCaseTreeObjects(tvSurgery);
    tvSurgery.Items.Clear;
    tvSurgery.Items.EndUpdate;
    lstNotes.Items.Clear;
    memSurgery.Clear;
    memSurgery.Invalidate;
    lblTitle.Caption := '';
    lblTitle.Hint := lblTitle.Caption;
    ShowPCEControls(FALSE);
    with FCurrentContext do
      begin
        GetSurgCaseList(tmpList, FMBeginDate, FMEndDate, SR_ALL, MaxDocs);
        CreateListItemsForCaseTree(FCaseList, tmpList, SR_ALL, GroupBy, TreeAscending);
        UpdateTreeView(FCaseList, tvSurgery);
      end;
    tmpList.Clear;
    FCaseList.Clear;
    with tvSurgery do
      begin
        uChanging := True;
        tvSurgery.Items.BeginUpdate;
        if FLastNoteID <> '' then
          Selected := FindPieceNode(FLastNoteID, 1, U, nil);
        if Selected = nil then
          begin
            if (uSurgeryContext.GroupBy <> '') then
              begin
                ANode := TORTreeNode(Items.GetFirstNode);
                while ANode <> nil do
                  begin
                    ANode.Expand(False);
                    Selected := ANode;
                    ANode := TORTreeNode(ANode.GetNextSibling);
                  end;
              end
            else
              begin
                ANode := tvSurgery.FindPieceNode(IntToStr(SR_ALL), 1, U, nil);
                if ANode <> nil then Selected := ANode.getFirstChild;
              end;
          end;
        memSurgery.Clear;
        RemoveParentsWithNoChildren(tvSurgery, uSurgeryContext);
        tvSurgery.Items.EndUpdate;
        uChanging := False;
        lblCases.Caption := SetSurgTreeLabel(FCurrentContext);
        tvSurgery.Caption := lblCases.Caption;
        SendMessage(tvSurgery.Handle, WM_VSCROLL, SB_TOP, 0);
        if Selected <> nil then tvSurgeryChange(Self, Selected);
      end;
  finally
    RedrawActivate(memSurgery.Handle);
    tmpList.Free;
  end;
end;

function TfrmSurgery.SetSurgTreeLabel(AContext: TSurgCaseContext): string;
var
  x: string;

  function SetDateRangeText(AContext: TSurgCaseContext): string;
  var
    x1: string;
  begin
    with AContext do
      if BeginDate <> '' then
        begin
          x1 := 'from ' + UpperCase(BeginDate);
          if EndDate <> '' then x1 := x1 + ' to ' + UpperCase(EndDate)
          else x1 := x1 + ' to TODAY';
        end;
    Result := x1;
  end;

begin
  with AContext do
    begin
      if MaxDocs > 0 then x := 'Last ' + IntToStr(MaxDocs) + ' ' else x := 'All ';
      case StrToIntDef(Status, 0) of
        SR_RECENT      : x := x + 'Surgery Cases';
        SR_ALL         : x := x + 'Surgery Cases';
        //SG_BY_SURGEON  : x := x + 'Surgery Cases for ' + ExternalName(Surgeon, 200) + SetDateRangeText(AContext);
        SR_BY_DATE     : x := x + 'Surgery Cases ' + SetDateRangeText(AContext);
      else
        x := 'Custom List';
      end;
    end;
  Result := x;
end;

procedure TfrmSurgery.lstNotesClick(Sender: TObject);
{ loads the text for the selected note or displays the editing panel for the selected note }
var
  x: string;
begin
  inherited;
  with lstNotes do if ItemIndex = -1 then Exit
  else if ItemIndex = EditingIndex then
  begin
    pnlWrite.Visible := True;
    pnlRead.Visible := False;
    mnuViewDetail.Enabled    := False;
    mnuActChange.Enabled     := True;
    mnuActLoadBoiler.Enabled := True;
  end else
  begin
    StatusText('Retrieving selected surgery report...');
    Screen.Cursor := crHourGlass;
    pnlRead.Visible := True;
    pnlWrite.Visible := False;
    //UpdateReminderFinish;
    lblTitle.Caption := MakeSurgeryReportDisplayText(Items[ItemIndex]);
    lblTitle.Hint := lblTitle.Caption;
    LoadSurgReportText(memSurgery.Lines, ItemIEN);
    mnuViewDetail.Enabled    := True;
    mnuViewDetail.Checked    := False;
    mnuActChange.Enabled     := False;
    mnuActLoadBoiler.Enabled := False;
    Screen.Cursor := crDefault;
    StatusText('');
  end;
  if(assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
  DisplayPCE;
  pnlRight.Refresh;
  memNewNote.Repaint;
  memSurgery.Repaint;
  x := 'TIU^' + lstNotes.ItemID;
  SetPiece(x, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
  NotifyOtherApps(NAE_REPORT, x);
end;

procedure TfrmSurgery.EnableDisableMenus(IsTIUDocument: boolean);
begin
{ TODO -oRich V. -cSurgery/TIU : Reset NewNoteMenu enabled if allow new notes from Surgery tab }
  mnuActNew.Enabled                 :=  False;
  mnuActAddend.Enabled              :=  IsTIUDocument;
  mnuActAddIDEntry.Enabled          :=  False;
  mnuActDetachFromIDParent.Enabled  :=  False;
  mnuActEdit.Enabled                :=  IsTIUDocument;
  mnuActDelete.Enabled              :=  IsTIUDocument;
  mnuActSign.Enabled                :=  IsTIUDocument;
  mnuActSignList.Enabled            :=  IsTIUDocument;
  mnuActSave.Enabled                :=  IsTIUDocument;
  mnuActIdentifyAddlSigners.Enabled := IsTIUDocument;
  mnuActChange.Enabled              := IsTIUDocument;
  mnuActLoadBoiler.Enabled          := IsTIUDocument;
  popNoteMemoSignList.Enabled       := IsTIUDocument;
  popNoteMemoSign.Enabled           := IsTIUDocument;
  popNoteMemoSave.Enabled           := IsTIUDocument;
  popNoteMemoEdit.Enabled           := IsTIUDocument;
  popNoteMemoDelete.Enabled         := IsTIUDocument;
  popNoteMemoAddlSign.Enabled       := IsTIUDocument;
  popNoteMemoAddend.Enabled         := IsTIUDocument;
  mnuViewDetail.Enabled             := IsTIUDocument;
  popNoteMemoPreview.Enabled        := IsTIUDocument and Assigned(frmDrawers.tvTemplates.Selected);
  popNoteMemoInsTemplate.Enabled    := IsTIUDocument and Assigned(frmDrawers.tvTemplates.Selected);
  if not IsTIUDocument then mnuViewDetail.Checked := False;
  frmFrame.mnuFilePrint.Enabled := IsTIUDocument;
end;

procedure TfrmSurgery.memNewNoteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
      Key := 0;
    end;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmSurgery.sptHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if pnlWrite.Visible then
     if NewSize > frmSurgery.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width then
        NewSize := frmSurgery.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width;
end;

procedure TfrmSurgery.popNoteMemoPreviewClick(Sender: TObject);
begin
  frmDrawers.mnuPreviewTemplateClick(Sender);
end;

procedure TfrmSurgery.popNoteMemoInsTemplateClick(Sender: TObject);
begin
  frmDrawers.mnuInsertTemplateClick(Sender);
end;

procedure TfrmSurgery.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmSurgery.mnuViewInformationClick(Sender: TObject);
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

initialization
  SpecifyFormIsNotADialog(TfrmSurgery);
  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;

finalization
  uPCEEdit.Free;
  uPCEShow.Free;

end.


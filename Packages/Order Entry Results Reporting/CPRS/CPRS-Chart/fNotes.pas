unit fNotes;
{$O-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, fDrawers, ImgList, rTIU, uTIU, uDocTree, fRptBox, fPrintList,
  fNoteST, ORNet, fNoteSTStop, fBase508Form, VA508AccessibilityManager,
  VA508ImageListLabeler, RichEdit;

type
  TfrmNotes = class(TfrmHSplit)
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
    lblNotes: TOROffsetLabel;
    pnlRead: TPanel;
    lblTitle: TOROffsetLabel;
    memNote: TRichEdit;
    pnlWrite: TPanel;
    memNewNote: TRichEdit;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewByAuthor: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewUncosigned: TMenuItem;
    mnuViewUnsigned: TMenuItem;
    mnuActSignList: TMenuItem;
    cmdNewNote: TORAlignButton;
    cmdPCE: TORAlignButton;
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
    popNoteListByAuthor: TMenuItem;
    popNoteListByDate: TMenuItem;
    popNoteListUncosigned: TMenuItem;
    popNoteListUnsigned: TMenuItem;
    sptVert: TSplitter;
    memPCEShow: TRichEdit;
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
    lstNotes: TORListBox;
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
    lblNewTitle: TStaticText;
    lblRefDate: TStaticText;
    lblAuthor: TStaticText;
    lblVisit: TStaticText;
    lblCosigner: TStaticText;
    cmdChange: TButton;
    lblSubject: TStaticText;
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
    tvNotes: TORTreeView;
    lvNotes: TCaptionListView;
    sptList: TSplitter;
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
    mnuChartSurgery: TMenuItem;
    mnuActAttachtoIDParent: TMenuItem;
    popNoteListAttachtoIDParent: TMenuItem;
    N8: TMenuItem;
    popNoteMemoPreview: TMenuItem;
    popNoteMemoInsTemplate: TMenuItem;
    popNoteMemoEncounter: TMenuItem;
    mnuSearchForText: TMenuItem;
    popSearchForText: TMenuItem;
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
    popNoteMemoViewCslt: TMenuItem;
    mnuEncounter: TMenuItem;
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    procedure mnuChartTabClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure cmdNewNoteClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure mnuActAddIDEntryClick(Sender: TObject);
    procedure mnuActSaveClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuActAddendClick(Sender: TObject);
    procedure mnuActDetachFromIDParentClick(Sender: TObject);
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
    procedure tvNotesChange(Sender: TObject; Node: TTreeNode);
    procedure tvNotesClick(Sender: TObject);
    procedure tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvNotesExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvNotesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvNotesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvNotesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure lvNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure popNoteListExpandAllClick(Sender: TObject);
    procedure popNoteListCollapseAllClick(Sender: TObject);
    procedure popNoteListExpandSelectedClick(Sender: TObject);
    procedure popNoteListCollapseSelectedClick(Sender: TObject);
    procedure popNoteListPopup(Sender: TObject);
    procedure lvNotesResize(Sender: TObject);
    procedure mnuIconLegendClick(Sender: TObject);
    procedure popNoteMemoFindClick(Sender: TObject);
    procedure dlgFindTextFind(Sender: TObject);
    procedure popNoteMemoReplaceClick(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure mnuActAttachtoIDParentClick(Sender: TObject);
    procedure memNewNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sptHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure popNoteMemoInsTemplateClick(Sender: TObject);
    procedure popNoteMemoPreviewClick(Sender: TObject);
    procedure tvNotesExit(Sender: TObject);
    procedure pnlReadExit(Sender: TObject);
    procedure cmdNewNoteExit(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure memNewNoteKeyPress(Sender: TObject; var Key: Char);
    procedure memNewNoteKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memPCEShowExit(Sender: TObject);
    procedure cmdChangeExit(Sender: TObject);
    procedure cmdPCEExit(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure popNoteMemoViewCsltClick(Sender: TObject);
  private
    FNavigatingTab : Boolean; //Currently Using tab to navigate
    FEditingIndex: Integer;                      // index of note being currently edited
    FChanged: Boolean;                           // true if any text has changed in the note
    FEditCtrl: TCustomEdit;
    FSilent: Boolean;
    FCurrentContext: TTIUContext;
    FDefaultContext: TTIUContext;
    FOrderID: string;
    FImageFlag: TBitmap;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FDocList: TStringList;
    FConfirmed: boolean;
    FLastNoteID: string;
    FNewIDChild: boolean;
    FEditingNotePCEObj: boolean;
    FDeleted: boolean;
    FOldFramePnlPatientExit: TNotifyEvent;
    FOldDrawerPnlTemplatesButtonExit: TNotifyEvent;
    FOldDrawerPnlEncounterButtonExit: TNotifyEvent;
    FOldDrawerEdtSearchExit: TNotifyEvent;
    FStarting: boolean;
    procedure frmFramePnlPatientExit(Sender: TObject);
    procedure frmDrawerPnlTemplatesButtonExit(Sender: TObject);
    procedure frmDrawerPnlEncounterButtonExit(Sender: TObject);
    procedure frmDrawerEdtSearchExit(Sender: TObject);
    procedure ClearEditControls;
    procedure DoAutoSave(Suppress: integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    procedure InsertAddendum;
    procedure InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
    function LacksRequiredForCreate: Boolean;
    procedure LoadForEdit;
    function LockConsultRequest(AConsult: Integer): Boolean;
    function LockConsultRequestAndNote(AnIEN: Int64): Boolean;
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedNote(var Saved: Boolean);
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetEditingIndex(const Value: Integer);
    procedure SetSubjectVisible(ShouldShow: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    function StartNewEdit(NewNoteType: integer): Boolean;
    procedure UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
    procedure ProcessNotifications;
    procedure SetViewContext(AContext: TTIUContext);
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    function GetDrawers: TFrmDrawers;
    function CanFinishReminder: boolean;
    procedure DisplayPCE;
    function VerifyNoteTitle: Boolean;
    //  added for treeview
    procedure LoadNotes;
    procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure  EnableDisableIDNotes;
    procedure ShowPCEButtons(Editing: boolean);
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function SetNoteTreeLabel(AContext: TTIUContext): string;
    procedure UpdateNoteAuthor(DocInfo: string);
  public
    function ActiveEditOf(AnIEN: Int64; ARequest: integer): Boolean;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure AssignRemForm;
    property  OrderID: string read FOrderID;
    procedure LstNotesToPrint;
    procedure UpdateFormForInput;
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
  end;

var
  frmNotes: TfrmNotes;
  SearchTextStopFlag: Boolean;   // Text Search CQ: HDS00002856

implementation

{$R *.DFM}

uses fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem, fEncounterFrame,
     rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners, fNoteDR, fConsults, uSpell,
     fTIUView, fTemplateEditor, uReminders, fReminderDialog, uOrders, rConsults, fReminderTree,
     fNoteProps, fNotesBP, fTemplateFieldEditor, dShared, rTemplates,
     FIconLegend, fPCEEdit, fNoteIDParents, rSurgery, uSurgery, uTemplates,
     fTemplateDialog, DateUtils, uInit, uVA508CPRSCompatibility, VA508AccessibilityRouter,
  VAUtils;
     
const

  NT_NEW_NOTE = -10;                             // Holder IEN for a new note
  NT_ADDENDUM = -20;                             // Holder IEN for a new addendum

  NT_ACT_NEW_NOTE  = 2;
  NT_ACT_ADDENDUM  = 3;
  NT_ACT_EDIT_NOTE = 4;
  NT_ACT_ID_ENTRY  = 5;

  TX_NEED_VISIT = 'A visit is required before creating a new progress note.';
  TX_CREATE_ERR = 'Error Creating Note';
  TX_UPDATE_ERR = 'Error Updating Note';
  TX_NO_NOTE    = 'No progress note is currently being edited';
  TX_SAVE_NOTE  = 'Save Progress Note';
  TX_ADDEND_NO  = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this progress note?';
  TX_DEL_ERR    = 'Unable to Delete Note';
  TX_SIGN       = 'Sign Note';
  TX_COSIGN     = 'Cosign Note';
  TX_SIGN_ERR   = 'Unable to Sign Note';
//  TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
//                  'answered.  The Encounter form will now be opened.  Please answer all '+
//                 'service connected questions.';
//  TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NONOTE     = 'No progress note is currently selected.';
  TX_NONOTE_CAP = 'No Note Selected';
  TX_NOPRT_NEW  = 'This progress note may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Progress Note';
  TX_NO_ALERT   = 'There is insufficient information to process this alert.' + CRLF +
                  'Either the alert has already been deleted, or it contained invalid data.' + CRLF + CRLF +
                  'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  TX_ORDER_LOCKED = 'This record is locked by an action underway on the Consults tab';
  TC_ORDER_LOCKED = 'Unable to access record';
  TX_NO_ORD_CHG   = 'The note is still associated with the previously selected request.' + CRLF +
                    'Finish the pending action on the consults tab, then try again.';
  TC_NO_ORD_CHG   = 'Locked Consult Request';
  TX_NEW_SAVE1    = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2    = CRLF + CRLF + 'Do you wish to save this note and begin a new one?';
  TX_NEW_SAVE3    = CRLF + CRLF + 'Do you wish to save this note and begin a new addendum?';
  TX_NEW_SAVE4    = CRLF + CRLF + 'Do you wish to save this note and edit the one selected?';
  TX_NEW_SAVE5    = CRLF + CRLF + 'Do you wish to save this note and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2    = 'Create New Note';
  TC_NEW_SAVE3    = 'Create New Addendum';
  TC_NEW_SAVE4    = 'Edit Different Note';
  TC_NEW_SAVE5    = 'Create New Interdisciplinary Entry';
  TX_EMPTY_NOTE   = CRLF + CRLF + 'This note contains no text and will not be saved.' + CRLF +
                    'Do you wish to delete this note?';
  TC_EMPTY_NOTE   = 'Empty Note';
  TX_EMPTY_NOTE1   = 'This note contains no text and can not be signed.';
  TC_NO_LOCK      = 'Unable to Lock Note';
  TX_ABSAVE       = 'It appears the session terminated abnormally when this' + CRLF +
                    'note was last edited. Some text may not have been saved.' + CRLF + CRLF +
                    'Do you wish to continue and sign the note?';
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
  TX_AUTH_SIGNED    = 'Author has not signed, are you SURE you want to sign.' +CRLF;
{
type
  //CQ8300
  ClipboardData = record
     Text: array[0..255] of char;
  end;
}
var
  uPCEShow, uPCEEdit:  TPCEData;
  ViewContext: Integer;
  frmDrawers: TfrmDrawers;
  uTIUContext: TTIUContext;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;
  uChanging: Boolean;
  uIDNotesActive: Boolean;
  NoteTotal: string;


{ TPage common methods --------------------------------------------------------------------- }
function TfrmNotes.AllowContextChange(var WhyNot: string): Boolean;
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
  if Assigned(frmRemDlg) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             WhyNot := 'All current reminder processing information will be discarded.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then
               begin
                 FSilent := True;
                 frmRemDlg.Silent := True;
                 frmRemDlg.btnCancelClick(Self);
               end;
             //agp fix for a problem with reminders not clearing out when switching patients
             if WhyNot = '' then
                begin
                 frmRemDlg.btnCancelClick(Self);
                 if assigned(frmRemDlg) then
                   begin
                     result := false;
                     exit;
                   end;
                end;
           end;
    end;
  if EditingIndex <> -1 then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1': begin
             if memNewNote.GetTextLen > 0 then
               WhyNot := WhyNot + 'A note in progress will be saved as unsigned.  '
             else
               WhyNot := WhyNot + 'An empty note in progress will be deleted.  ';
             Result := False;
           end;
      '0': begin
             if WhyNot = 'COMMIT' then FSilent := True;
             SaveCurrentNote(Result);
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

procedure TfrmNotes.LstNotesToPrint;       
var
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if not uIDNotesActive then exit;
  if lstNotes.ItemIEN = 0 then exit;           
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvNotes.Selected = nil then exit;
  AParentID := frmPrintList.SelectParentFromList(tvNotes,CT_NOTES);
  if AParentID = '' then exit;
  with tvNotes do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
end;

procedure TfrmNotes.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  uChanging := True;
  tvNotes.Items.BeginUpdate;
  KilldocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  tvNotes.Items.EndUpdate;
  lvNotes.Items.Clear;
  uChanging := False;
  lstNotes.Clear;
  memNote.Clear;
  memPCEShow.Clear;
  uPCEShow.Clear;
  uPCEEdit.Clear;
  frmDrawers.ResetTemplates;
  NoteTotal := sCallV('ORCNOTE GET TOTAL', [Patient.DFN]);
end;

procedure TfrmNotes.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_NOTES;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  frmFrame.mnuFilePrintSelectedItems.Enabled := True;
  if InitPage then
  begin
    EnableDisableIDNotes;
    FDefaultContext := GetCurrentTIUContext;
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

procedure TfrmNotes.RequestPrint;
var
  Saved: Boolean;
begin
  with lstNotes do
  begin
    if ItemIndex = EditingIndex then
    //if ItemIEN < 0 then
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

{for printing multiple notes}
procedure TfrmNotes.RequestMultiplePrint(AForm: TfrmPrintList);
var
  NoteIEN: int64;
  i: integer;
begin
  with AForm.lbIDParents do
  begin
    for i := 0 to Items.Count - 1 do
     begin
       if Selected[i] then
        begin
         AForm.lbIDParents.ItemIndex := i;
         NoteIEN := ItemIEN;  //StrToInt64def(Piece(TStringList(Items.Objects[i])[0],U,1),0);
         if NoteIEN > 0 then PrintNote(NoteIEN, DisplayText[i], TRUE) else
         begin
           if NoteIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
           if NoteIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
         end;
        end; {if selected}
     end; {for}
  end; {with}
end;

procedure TfrmNotes.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  frmDrawers.Font.Size  := NewFontSize;
  SetEqualTabStops(memNewNote);
  pnlWriteResize(Self);
end;

procedure TfrmNotes.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmNotes.ClearEditControls;
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
    PkgIEN       := 0;
    PkgPtr       := '';
    PkgRef       := '';
    NeedCPT      := False;
    Addend       := 0;
    {LastCosigner & LastCosignerName aren't cleared because they're used as default for next note.}
    Lines        := nil;
    PRF_IEN := 0;
    ActionIEN := '';
  end;
  // clear the editing controls (also clear the new labels?)
  txtSubject.Text := '';
  SearchTextStopFlag := false;
  if memNewNote <> nil then memNewNote.Clear; //CQ7012 Added test for nil
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
end;

procedure TfrmNotes.ShowPCEControls(ShouldShow: Boolean);
begin
  sptVert.Visible    := ShouldShow;
  memPCEShow.Visible := ShouldShow;
  if(ShouldShow) then
    sptVert.Top := memPCEShow.Top - sptVert.Height;
  memNote.Invalidate;
end;

procedure TfrmNotes.DisplayPCE;
{ displays PCE information if appropriate & enables/disabled editing of PCE data }
var
  EnableList, ShowList: TDrawers;
  VitalStr:   TStringlist;
  NoPCE:      boolean;
  ActionSts: TActionRec;
  AnIEN: integer;
begin
  memPCEShow.Clear;
  with lstNotes do if ItemIndex = EditingIndex then
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
      memPCEShow.SelStart := 0;

      if(InteractiveRemindersActive) then
      begin
        if(GetReminderStatus = rsNone) then
          EnableList := [odTemplates]
        else
          if FutureEncounter(uPCEEdit) then
            begin
              EnableList := [odTemplates];
              ShowList := [odTemplates];
            end
          else
            begin
              EnableList := [odTemplates, odReminders];
              ShowList := [odTemplates, odReminders];
            end;
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
        memPCEShow.SelStart := 0;
      end;
      StatusText('');
    end
    else
      ShowPCEControls(FALSE);
  end; {if ItemIndex}
  mnuEncounter.Enabled := cmdPCE.Visible;
end;

{ supporting calls for writing notes }

function TfrmNotes.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
begin
  with lstNotes do
    Result := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              '  ' + Piece(Items[AnIndex], U, 2) + ', ' + Piece(Items[AnIndex], U, 6) + ', ' +
              Piece(Piece(Items[AnIndex], U, 5), ';', 2)
end;

function TfrmNotes.LacksRequiredForCreate: Boolean;
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
    if IsConsultTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsSurgeryTitle(Title) and (PkgIEN = 0) then Result := True;
    if IsPRFTitle(Title) and (PRF_IEN = 0) and (not DocType = TYP_ADDENDUM) then Result := True;
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

function TfrmNotes.VerifyNoteTitle: Boolean;
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

procedure TfrmNotes.SetSubjectVisible(ShouldShow: Boolean);
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

{ consult request and note locking }

function TfrmNotes.LockConsultRequest(AConsult: Integer): Boolean;
{ returns true if consult successfully locked }
begin
  // *** I'm not sure about the FOrderID field - if the user is editing one note and
  //     deletes another, FOrderID will be for editing note, then delete note, then null
  Result := True;
  FOrderID := GetConsultOrderIEN(AConsult);
  if (FOrderID <> '') and (FOrderID = frmConsults.OrderID) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := False;
    Exit;
  end;
  if (FOrderId <> '') then
    if not OrderCanBeLocked(FOrderID) then Result := False;
  if not Result then FOrderID := '';
end;

function TfrmNotes.LockConsultRequestAndNote(AnIEN: Int64): Boolean;
{ returns true if note and associated request successfully locked }
var
  AConsult: Integer;
  LockMsg, x: string;
begin
  Result := True;
  AConsult := 0;
  if frmConsults.ActiveEditOf(AnIEN) then
    begin
      InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
      Result := False;
      Exit;
    end;
    if Changes.Exist(CH_DOC, IntToStr(AnIEN)) then Exit;  // already locked
  // try to lock the consult request first, if there is one
  if IsConsultTitle(TitleForNote(AnIEN)) then
  begin
    x := GetPackageRefForNote(lstNotes.ItemIEN);
    AConsult := StrToIntDef(Piece(x, ';', 1), 0);
    Result := LockConsultRequest(AConsult);
  end;
  // now try to lock the note
  if Result then
  begin
    LockDocument(AnIEN, LockMsg);
    if LockMsg <> '' then
    begin
      Result := False;
      // if can't lock the note, unlock the consult request that was just locked
      if AConsult > 0 then
      begin
        UnlockOrderIfAble(FOrderID);
        FOrderID := '';
      end;
      InfoBox(LockMsg, TC_NO_LOCK, MB_OK);
    end;
  end;
end;

procedure TfrmNotes.UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
(*var
  x: string;*)
begin
(*  if (AConsult = 0) and IsConsultTitle(TitleForNote(ANote)) then
    begin
      x := GetPackageRefForNote(ANote);
      AConsult := StrToIntDef(Piece(x, ';', 1), 0);
    end;
  if AConsult = 0 then Exit;*)
  if AConsult = 0 then AConsult := GetConsultIENForNote(ANote);
  if AConsult <= 0 then exit;
  FOrderID := GetConsultOrderIEN(AConsult);
  UnlockOrderIfAble(FOrderID);
  FOrderID := '';
end;

function TfrmNotes.ActiveEditOf(AnIEN: Int64; ARequest: integer): Boolean;
begin
  Result := False;
  if EditingIndex < 0 then Exit;
  if lstNotes.GetIEN(EditingIndex) = AnIEN then
    begin
      Result := True;
      Exit;
    end;
  with FEditNote do if (PkgIEN = ARequest) and (PkgPtr = PKG_CONSULTS) then Result := True;
end;

{ create, edit & save notes }

procedure TfrmNotes.InsertNewNote(IsIDChild: boolean; AnIDParent: integer);
{ creates the editing context for a new progress note & inserts stub into top of view list }
var
  EnableAutosave, HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  x, WhyNot, DocInfo: string;
begin
  if frmFrame.Timedout then Exit;

  FNewIDChild := IsIDChild;
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FillChar(FEditNote, SizeOf(FEditNote), 0);  //v15.7
    with FEditNote do
    begin
      DocType      := TYP_PROGRESS_NOTE;
      IsNewNote    := True;
      Title        := DfltNoteTitle;
      TitleName    := DfltNoteTitleName;
      if IsIDChild and (not CanTitleBeIDChild(Title, WhyNot)) then
        begin
          Title := 0;
          TitleName := '';
        end;
      if IsSurgeryTitle(Title) then    // Don't want surgery title sneaking in unchallenged
        begin
          Title := 0;
          TitleName := '';
        end;
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
    GetUnresolvedConsultsInfo;
    if LacksRequiredForCreate or VerifyNoteTitle or uUnresolvedConsults.UnresolvedConsultsExist
      then HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild, FNewIDChild, '', 0)
      else HaveRequired := True;
    // lock the consult request if there is a consult
    with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then HaveRequired := LockConsultRequest(PkgIEN);
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
          //Link Note to PRF Action
          if PRF_IEN <> 0 then
            if sCallV('TIU LINK TO FLAG', [CreatedNote.IEN,PRF_IEN,ActionIEN,Patient.DFN]) = '0' then
              ShowMsg('TIU LINK TO FLAG: FAILED');
        end;

        lstNotes.Items.Insert(0, x);
        uChanging := True;
        tvNotes.Items.BeginUpdate;
        if IsIDChild then
          begin
            tmpNode := tvNotes.FindPieceNode(IntToStr(AnIDParent), 1, U, tvNotes.Items.GetFirstNode);
            tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
            tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
            tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
            tmpNode.ImageIndex := IMG_ID_CHILD;
            tmpNode.SelectedIndex := IMG_ID_CHILD;
          end
        else
          begin
            tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'New Note in Progress',
                                                    MakeNoteTreeObject('NEW^New Note in Progress^^^^^^^^^^^%^0'));
            TORTreeNode(tmpNode).StringData := 'NEW^New Note in Progress^^^^^^^^^^^%^0';
            tmpNode.ImageIndex := IMG_TOP_LEVEL;
            tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
            tmpNode.ImageIndex := IMG_SINGLE;
            tmpNode.SelectedIndex := IMG_SINGLE;
          end;
        tmpNode.StateIndex := IMG_NO_IMAGES;
        TORTreeNode(tmpNode).StringData := x;
        tvNotes.Selected := tmpNode;
        tvNotes.Items.EndUpdate;
        uChanging := False;
        Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
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
        with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then UnlockConsultRequest(0, PkgIEN);
        InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
        HaveRequired := False;
      end; {if CreatedNote.IEN}
    end; {if HaveRequired}
    if not HaveRequired then
    begin
      ClearEditControls;
      ShowPCEButtons(False);
    end;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      QuickCopyWith508Msg(TmpBoilerPlate, memNewNote);
      UpdateNoteAuthor(DocInfo);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
  frmNotes.pnlWriteResize(Self);
end;

procedure TfrmNotes.InsertAddendum;
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
    IsNewNote    := False;
    Title        := TitleForNote(lstNotes.ItemIEN);
    TitleName    := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    if Copy(TitleName,1,1) = '+' then TitleName := Copy(TitleName, 3, 199);
    DateTime     := FMNow;
    Author       := User.DUZ;
    AuthorName   := User.Name;
    x            := GetPackageRefForNote(lstNotes.ItemIEN);
    if Piece(x, U, 1) <> '-1' then
      begin
        PkgRef       := GetPackageRefForNote(lstNotes.ItemIEN);
        PkgIEN       := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr       := Piece(PkgRef, ';', 2);
      end;
    Addend       := lstNotes.ItemIEN;
    //Lines        := memNewNote.Lines;
    // Cosigner, if needed, will be set by fNoteProps
    // Location info will be set after the encounter is loaded
  end;
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate
    then HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IS_ID_CHILD, False, '', 0)
    else HaveRequired := True;
  // lock the consult request if there is a consult
  if HaveRequired then
    with FEditNote do
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then HaveRequired := LockConsultRequest(PkgIEN);
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
               U + U + U + U + U + U + U;
        end;

      lstNotes.Items.Insert(0, x);
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'New Addendum in Progress',
                                              MakeNoteTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
      TORTreeNode(tmpNode).StringData := x;

      tmpNode.ImageIndex := IMG_ADDENDUM;
      tmpNode.SelectedIndex := IMG_ADDENDUM;
      tvNotes.Selected := tmpNode;
      tvNotes.Items.EndUpdate;
      uChanging := False;
      Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
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
      with FEditNote do if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS)  then UnlockConsultRequest(0, PkgIEN);
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
    end; {if CreatedNote.IEN}
  end; {if HaveRequired}
  if not HaveRequired then ClearEditControls;
end;

procedure TfrmNotes.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  x: string;
begin
  ClearEditControls;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  EditingIndex := lstNotes.ItemIndex;
  Changes.Add(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex), '', CH_SIGN_YES);
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
  tvNotes.Items.BeginUpdate;

  tmpNode := tvNotes.FindPieceNode('EDIT', 1, U, nil);
  if tmpNode = nil then
    begin
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'Note being edited',
                                              MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
    end
  else
    tmpNode.DeleteChildren;
  x := lstNotes.Items[lstNotes.ItemIndex];
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(x), MakeNoteTreeObject(x));
  TORTreeNode(tmpNode).StringData := x;
  if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
    tmpNode.ImageIndex := IMG_SINGLE
  else
    tmpNode.ImageIndex := IMG_ADDENDUM;
  tmpNode.SelectedIndex := tmpNode.ImageIndex;
  tvNotes.Selected := tmpNode;
  tvNotes.Items.EndUpdate;
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

procedure TfrmNotes.SaveEditedNote(var Saved: Boolean);
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
    tvNotes.Selected := tvNotes.FindPieceNode(x, 1, U, tvNotes.Items.GetFirstNode);
    uChanging := False;
    tvNotesChange(Self, tvNotes.Selected);
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
  //FEditNote.Lines:= SetLinesTo74ForSave(memNewNote.Lines, Self);
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
    FNewIDChild := False;
    FChanged := False;
  end else
  begin
    if not FSilent then
      InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmNotes.SaveCurrentNote(var Saved: Boolean);
{ called whenever a note should be saved - uses IEN to call appropriate save logic }
begin
  if EditingIndex < 0 then Exit;
  SaveEditedNote(Saved);
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmNotes.FormCreate(Sender: TObject);
begin
  inherited;
  PageID := CT_NOTES;
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
  FDocList := TStringList.Create;
end;

procedure TfrmNotes.pnlRightResize(Sender: TObject);
{ memNote (TRichEdit) doesn't repaint appropriately unless it's parent panel is refreshed }
begin
  inherited;
  pnlRight.Refresh;
  memNote.Repaint;
end;

procedure TfrmNotes.pnlWriteResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memNewNote, MAX_PROGRESSNOTE_WIDTH - 1);

  //CQ7012 Added test for nil
  if memNewNote <> nil then
     memNewNote.Constraints.MinWidth := TextWidthByFont(memNewNote.Font.Handle, StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;
  //CQ7012 Added test for nil
   if (Self <> nil) and (pnlLeft <> nil) and (pnlWrite <> nil) and (sptHorz <> nil) then
     pnlLeft.Width := self.ClientWidth - pnlWrite.Width - sptHorz.Width;
  UpdateFormForInput;
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmNotes.lstNotesClick(Sender: TObject);
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
    if (FEditNote.IDParent <> 0) and (not FNewIDChild) then
      mnuActChange.Enabled     := False
    else
      mnuActChange.Enabled     := True;
    mnuActLoadBoiler.Enabled := True;
    UpdateReminderFinish;
    UpdateFormForInput;
  end else
  begin
    StatusText('Retrieving selected progress note...');
    Screen.Cursor := crHourGlass;
    pnlRead.Visible := True;
    pnlWrite.Visible := False;
    UpdateReminderFinish;
    lblTitle.Caption := Piece(Piece(Items[ItemIndex], U, 8), ';', 1) + #9 + Piece(Items[ItemIndex], U, 2) + ', ' +
                        Piece(Items[ItemIndex], U, 6) + ', ' + Piece(Piece(Items[ItemIndex], U, 5), ';', 2) +
                        '  (' + FormatFMDateTime('mmm dd,yy@hh:nn', MakeFMDateTime(Piece(Items[ItemIndex], U, 3)))
                        + ')';
    lvNotes.Caption := lblTitle.Caption;
    LoadDocumentText(memNote.Lines, ItemIEN);
    memNote.SelStart := 0;
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
  memNote.Repaint;
  x := 'TIU^' + lstNotes.ItemID;
  SetPiece(x, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
  NotifyOtherApps(NAE_REPORT, x);
end;

procedure TfrmNotes.cmdNewNoteClick(Sender: TObject);
{ maps 'New Note' button to the New Progress Note menu item }
begin
  inherited;
  mnuActNewClick(Self);
end;

procedure TfrmNotes.cmdPCEClick(Sender: TObject);
var
  Refresh: boolean;
  ActionSts: TActionRec;
  AnIEN: integer;
  PCEObj, tmpPCEEdit: TPCEData;

  procedure UpdateEncounterInfo;
  begin
    if not FEditingNotePCEObj then
    begin
      PCEObj := nil;
      AnIEN := lstNotes.ItemIEN;
      if (AnIEN <> 0) and (memNote.Lines.Count > 0) then
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
    if Refresh and (not frmFrame.Closing) then
      DisplayPCE;
  end;

begin
  inherited;
  cmdPCE.Enabled := FALSE;
  if lstNotes.ItemIndex <> EditingIndex then
    // save uPCEEdit for note being edited, before updating current note's encounter, then restore  (RV - TAM-0801-31056)
    begin
      tmpPCEEdit := TPCEData.Create;
      try
        uPCEEdit.CopyPCEData(tmpPCEEdit);
        UpdateEncounterInfo;
        tmpPCEEdit.CopyPCEData(uPCEEdit);
      finally
        tmpPCEEdit.Free;
      end;
    end
  else
    // no other note being edited, so just proceed as before.
    UpdateEncounterInfo;
  if cmdPCE <> nil then
    cmdPCE.Enabled := TRUE
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmNotes.mnuActChangeClick(Sender: TObject);
begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  cmdChangeClick(Sender);
end;

procedure TfrmNotes.mnuActLoadBoilerClick(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
    QuickCopyWith508Msg(BoilerText, memNewNote);
    UpdateNoteAuthor(DocInfo);
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
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      if NoteEmpty then AssignBoilerText else
      begin
        case QueryBoilerPlate(BoilerText) of
        0:  { do nothing } ;                         // ignore
        1: begin
             ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
             QuickAddWith508Msg(BoilerText, memNewNote);  // append
             UpdateNoteAuthor(DocInfo);
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
//            if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
            if (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR,
                        MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = ID_YES)
              then memNewNote.Lines.Clear;
        end;
    end; {if BoilerText.Text <> ''}
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmNotes.cmdChangeClick(Sender: TObject);
var
  LastTitle, LastConsult: Integer;
  OKPressed, IsIDChild: Boolean;
  x: string;
  DisAssoText : String;
begin
  inherited;
  IsIDChild := uIDNotesActive and (FEditNote.IDParent > 0);
  LastTitle   := FEditNote.Title;
  FEditNote.IsNewNote := False;
  DisAssoText := '';
  if (FEditNote.PkgPtr = PKG_CONSULTS) then
    DisAssoText := 'Consults';
  if (FEditNote.PkgPtr = PKG_PRF) then
    DisAssoText := 'Patient Record Flags';
  if (DisAssoText <> '') and (Sender <> Self) then
    if InfoBox('If this title is changed, Any '+DisAssoText+' will be disassociated'+
               ' with this note',
               'Disassociate '+DisAssoText+'?',MB_OKCANCEL) = IDCANCEL	 then
      exit;
  if FEditNote.PkgPtr = PKG_CONSULTS then LastConsult := FEditNote.PkgIEN else LastConsult := 0;;
  if Sender <> Self then OKPressed := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild, FNewIDChild, '', 0)
    else OKPressed := True;
  if not OKPressed then Exit;
  // update display fields & uPCEEdit
  lblNewTitle.Caption := ' ' + FEditNote.TitleName + ' ';
  if (FEditNote.Addend > 0) and (CompareText(Copy(lblNewTitle.Caption, 2, 8), 'Addendum') <> 0)
    then lblNewTitle.Caption := ' Addendum to:' + lblNewTitle.Caption;
  with lblNewTitle do bvlNewTitle.SetBounds(Left - 1, Top - 1, Width + 2, Height + 2);
  lblRefDate.Caption := FormatFMDateTime('mmm dd,yyyy@hh:nn', FEditNote.DateTime);
  lblAuthor.Caption  := FEditNote.AuthorName;
  if uPCEEdit.Inpatient then x := 'Adm: ' else x := 'Vst: ';
  x := x + FormatFMDateTime('mm/dd/yy', FEditNote.VisitDate) + '  ' + FEditNote.LocationName;
  lblVisit.Caption   := x;
  if Length(FEditNote.CosignerName) > 0
    then lblCosigner.Caption := 'Expected Cosigner: ' + FEditNote.CosignerName
    else lblCosigner.Caption := '';
  uPCEEdit.NoteTitle  := FEditNote.Title;
  // modify signature requirements if author or cosigner changed
  if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner)
    then Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_NA)
    else Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_YES);
  x := lstNotes.Items[EditingIndex];
  SetPiece(x, U, 2, lblNewTitle.Caption);
  SetPiece(x, U, 3, FloatToStr(FEditNote.DateTime));
  tvNotes.Selected.Text := MakeNoteDisplayText(x);
  TORTreeNode(tvNotes.Selected).StringData := x;
  lstNotes.Items[EditingIndex] := x;
  Changes.ReplaceText(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex));
  with FEditNote do
  begin
  if (PkgPtr = PKG_CONSULTS) and (LastConsult <> PkgIEN) then
  begin
    // try to lock the new consult, reset to previous if unable
    if (PkgIEN > 0) and not LockConsultRequest(PkgIEN) then
    begin
      Infobox(TX_NO_ORD_CHG, TC_NO_ORD_CHG, MB_OK);
      PkgIEN := LastConsult;
    end else
    begin
      // unlock the previous consult
      if LastConsult > 0 then UnlockOrderIfAble(GetConsultOrderIEN(LastConsult));
      if PkgIEN = 0 then FOrderID := '';
    end;
  end;
  //Link Note to PRF Action
  if PRF_IEN <> 0 then
    if sCallV('TIU LINK TO FLAG', [lstNotes.ItemIEN,PRF_IEN,ActionIEN,Patient.DFN]) = '0' then
      ShowMsg('TIU LINK TO FLAG: FAILED');
  end;

  if LastTitle <> FEditNote.Title then mnuActLoadBoilerClick(Self);
end;

procedure TfrmNotes.memNewNoteChange(Sender: TObject);
begin
  inherited;
  FChanged := True;
end;

procedure TfrmNotes.pnlFieldsResize(Sender: TObject);
{ center the reference date on the panel }
begin
  inherited;
  lblRefDate.Left := (pnlFields.Width - lblRefDate.Width) div 2;
  if lblRefDate.Left < (lblNewTitle.Left + lblNewTitle.Width + 6)
    then lblRefDate.Left := (lblNewTitle.Left + lblNewTitle.Width);
  UpdateFormForInput;
end;

procedure TfrmNotes.DoAutoSave(Suppress: integer = 1);
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

procedure TfrmNotes.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmNotes.mnuViewClick(Sender: TObject);
{ changes the list of notes available for viewing }
var
  AuthCtxt: TAuthorContext;
  SearchCtxt: TSearchContext; // Text Search CQ: HDS00002856
  DateRange: TNoteDateRange;
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
  StatusText('Retrieving progress note list...');
  if Sender is TMenuItem then ViewContext := TMenuItem(Sender).Tag
    else if FCurrentContext.Status <> '' then ViewContext := NC_CUSTOM
    else ViewContext := NC_RECENT;
  case ViewContext of
  NC_RECENT:     begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   FCurrentContext.MaxDocs := ReturnMaxNotes;
                   LoadNotes;
                 end;
  NC_ALL:        begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'All Signed Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_UNSIGNED:   begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Unsigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_SEARCHTEXT: begin;
                   SearchTextStopFlag := False;
                   SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]) );
                   with SearchCtxt do if Changed then
                   begin
                     //FCurrentContext.Status := IntToStr(ViewContext);
                     frmSearchStop.Show;
                     lblNotes.Caption := 'Search: '+ SearchString;
                     frmSearchStop.lblSearchStatus.Caption := lblNotes.Caption;
                     FCurrentContext.SearchString := SearchString;
                     LoadNotes;
                   end;
                   // Only do LoadNotes if something changed 
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_UNCOSIGNED: begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   lblNotes.Caption := 'Uncosigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_BY_AUTHOR:  begin
                   SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
                   with AuthCtxt do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblNotes.Caption := AuthorName + ': Signed Notes';
                     FCurrentContext.Status := IntToStr(NC_BY_AUTHOR);
                     FCurrentContext.Author := Author;
                     FCurrentContext.TreeAscending := Ascending;
                     LoadNotes;
                   end;
                 end;
  NC_BY_DATE:    begin
                   SelectNoteDateRange(Font.Size, FCurrentContext, DateRange);
                   with DateRange do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblNotes.Caption := FormatFMDateTime('mmm dd,yy', FMBeginDate) + ' to ' +
                                         FormatFMDateTime('mmm dd,yy', FMEndDate) + ': Signed Notes';
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.TreeAscending := Ascending;
                     FCurrentContext.Status        := IntToStr(NC_BY_DATE);
                     LoadNotes;
                   end;
                 end;
  NC_CUSTOM:     begin
                   if Sender is TMenuItem then
                     begin
                       SelectTIUView(Font.Size, True, FCurrentContext, uTIUContext);
                       //lblNotes.Caption := 'Custom List';
                     end;
                   with uTIUContext do if Changed then
                   begin
                     //if not (Sender is TMenuItem) then lblNotes.Caption := 'Default List';
                     //if MaxDocs = 0 then MaxDocs   := ReturnMaxNotes;
                     FCurrentContext.BeginDate     := BeginDate;
                     FCurrentContext.EndDate       := EndDate;
                     FCurrentContext.FMBeginDate   := FMBeginDate;
                     FCurrentContext.FMEndDate     := FMEndDate;
                     FCurrentContext.Status        := Status;
                     FCurrentContext.Author        := Author;
                     FCurrentContext.MaxDocs       := MaxDocs;
                     FCurrentContext.ShowSubject   := ShowSubject;
                     // NEW PREFERENCES:
                     FCurrentContext.SortBy        := SortBy;
                     FCurrentContext.ListAscending := ListAscending;
                     FCurrentContext.GroupBy       := GroupBy;
                     FCurrentContext.TreeAscending := TreeAscending;
                     FCurrentContext.SearchField   := SearchField;
                     FCurrentContext.Keyword       := Keyword;
                     FCurrentContext.Filtered      := Filtered;
                     LoadNotes;
                   end;
                 end;
  end; {case}
  lblNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    lblNotes.Caption := lblNotes.Caption+', containing "'+FCurrentContext.SearchString+'"';
  If SearchTextStopFlag = True then begin;
    lblNotes.Caption := 'Search for "'+FCurrentContext.SearchString+'" was stopped!';
  end;
  //Clear the search text. We are done searching
  FCurrentContext.SearchString := '';
  frmSearchStop.Hide;
  // Text Search CQ: HDS00002856 --------------------
  lblNotes.Caption := lblNotes.Caption + ' (Total: ' + NoteTotal + ')'; 
  lblNotes.hint := lblNotes.Caption;
  tvNotes.Caption := lblNotes.Caption;
  StatusText('');
end;

{ Action menu events ----------------------------------------------------------------------- }

function TfrmNotes.StartNewEdit(NewNoteType: integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  Msg, CapMsg: string;
begin
  FStarting := False;
  Result := True;
  cmdNewNote.Enabled := False;
  if EditingIndex > -1 then
  begin
    FStarting := True;
    case NewNoteType of
      NT_ACT_ADDENDUM:  begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE3;
                          CapMsg := TC_NEW_SAVE3;
                        end;
      NT_ACT_EDIT_NOTE: begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE4;
                          CapMsg := TC_NEW_SAVE4;
                        end;
      NT_ACT_ID_ENTRY:  begin
                          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE5;
                          CapMsg := TC_NEW_SAVE5;
                        end;
    else
      begin
        Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE2;
        CapMsg := TC_NEW_SAVE2;
      end;
    end;
    if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then
    begin
      Result := False;
      FStarting := False;
    end
    else
      begin
        SaveCurrentNote(Saved);
        if not Saved then Result := False else LoadNotes;
        FStarting := False;
      end;
  end;
  cmdNewNote.Enabled := (Result = False) and (FStarting = False);
end;

procedure TfrmNotes.mnuActNewClick(Sender: TObject);
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
    ShowPCEButtons(False);
    Exit;
  end;
  InsertNewNote(IS_ID_CHILD, 0);
end;

procedure TfrmNotes.mnuActAddIDEntryClick(Sender: TObject);
const
  IS_ID_CHILD = True;
var
  AnIDParent: integer;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  AnIDParent := lstNotes.ItemIEN;
  if not StartNewEdit(NT_ACT_ID_ENTRY) then Exit;
  //LoadNotes;
  with tvNotes do Selected := FindPieceNode(IntToStr(AnIDParent), U, Items.GetFirstNode);
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
  InsertNewNote(IS_ID_CHILD, AnIDParent);
end;

procedure TfrmNotes.mnuActAddendClick(Sender: TObject);
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
  with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
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

procedure TfrmNotes.mnuActDetachFromIDParentClick(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: boolean;
  SavedDocID: string;
begin
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
      Exit;
    end;
  if (InfoBox('DETACH:   ' + tvNotes.Selected.Text + CRLF +  CRLF +
              '  FROM:   ' + tvNotes.Selected.Parent.Text + CRLF + CRLF +
              'Are you sure?', TX_DETACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
      then Exit;
  DocID := PDocTreeObject(tvNotes.Selected.Data)^.DocID;
  SavedDocID := PDocTreeObject(tvNotes.Selected.Parent.Data)^.DocID;
  if DetachEntryFromParent(DocID, WhyNot) then
    begin
      LoadNotes;
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
    end
  else
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
    end;
end;

procedure TfrmNotes.mnuActSignListClick(Sender: TObject);
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
  LockConsultRequestAndNote(lstNotes.ItemIEN);
  with lstNotes do Changes.Add(CH_DOC, ItemID, GetTitleText(ItemIndex), '', CH_SIGN_YES);
end;

procedure TfrmNotes.RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
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

procedure TfrmNotes.mnuActDeleteClick(Sender: TObject);
{ delete the selected progress note & remove from the Encounter object if necessary }
var
  DeleteSts, ActionSts: TActionRec;
  SaveConsult, SavedDocIEN: Integer;
  ReasonForDelete, AVisitStr, SavedDocID, x: string;
  Saved: boolean;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then Exit;
  if assigned(frmRemDlg) then
    begin
       frmRemDlg.btnCancelClick(Self);
       if assigned(frmRemDlg) then exit;
    end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'DELETE RECORD');
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then Exit;
  ReasonForDelete := SelectDeleteReason(lstNotes.ItemIEN);
  if ReasonForDelete = DR_CANCEL then Exit;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  if (Sender <> Self) and (InfoBox(MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]) + TX_DEL_OK,
    TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then Exit;
  // do the appropriate locking
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
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
  (*  if Saved then
    begin
      EditingIndex := -1;
      mnuViewClick(Self);
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
   end;*)
  // remove the note
  DeleteSts.Success := True;
  x := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN) then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_DOC, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_DOC, SavedDocID);  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);     // note has been deleted, so 1st param = 0
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    //ClearPtData;   WRONG - fixed in v15.10 - RV
    LoadNotes;
(*    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    if tvNotes.Selected <> nil then tvNotesChange(Self, tvNotes.Selected) else
    begin*)
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

procedure TfrmNotes.mnuActEditClick(Sender: TObject);
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
  with tvNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LoadForEdit;
end;

procedure TfrmNotes.mnuActSaveClick(Sender: TObject);
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
          LoadNotes;
          with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
       end;
    end
  else InfoBox(TX_NO_NOTE, TX_SAVE_NOTE, MB_OK or MB_ICONWARNING);
end;

procedure TfrmNotes.mnuActSignClick(Sender: TObject);
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
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
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
    if not AuthorSignedDocument(lstNotes.ItemIEN) then
    begin
      if (InfoBox(TX_AUTH_SIGNED +
          GetTitleText(lstNotes.ItemIndex),TX_SIGN ,MB_YESNO)= ID_NO) then exit;
    end;
    if(OK) then
    begin
      with lstNotes do SignatureForItem(Font.Size, MakeNoteDisplayText(Items[ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
        Changes.Remove(CH_DOC, lstNotes.ItemID);  // this will unlock if in Changes
        if SignSts.Success then
        begin
          SendMessage(frmConsults.Handle, UM_NEWORDER, ORDER_SIGN, 0);      {*REV*}
          lstNotesClick(Self);
        end
        else InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end  {if Length(ESCode)}
      else
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
    end;
  end
  else InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not NoteUnlocked then UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
  //SetViewContext(FCurrentContext);  //v22.12 - RV
  LoadNotes;                          //v22.12 - RV
  //if EditingIndex > -1 then         //v22.12 - RV
  if (EditingID <> '') then           //v22.12 - RV
    begin
      lstNotes.Items.Insert(0, tmpItem);
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, 'Note being edited',
                 MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(tmpItem), MakeNoteTreeObject(tmpItem));
      TORTreeNode(tmpNode).StringData := tmpItem;
      SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_NOTES);
      EditingIndex := lstNotes.SelectByID(EditingID);                 //v22.12 - RV
    end;
  //with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);  //v22.12 - RV
  with tvNotes do                                                                  //v22.12 - RV
  begin                                                                            //v22.12 - RV
    Selected := FindPieceNode(FLastNoteID, U, Items.GetFirstNode);                 //v22.12 - RV
    if Selected <> nil then
      tvNotesChange(Self, Selected)                                 //v22.12 - RV
    else
      tvNotes.Selected := tvNotes.Items[0]; //first Node in treeview
  end;                                                                             //v22.12 - RV
end;

procedure TfrmNotes.SaveSignItem(const ItemID, ESCode: string);
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
        //if ((not FSilent) and IsSurgeryTitle(TitleForNote(IEN))) then DisplayOpTop(IEN);
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if OK}
    end; {if ContinueSign}
  end; {if Length(ESCode)}

  UnlockConsultRequest(IEN);
  // GE 14926; added if (AnIndex> -1) to by pass LoadNotes when creating on narking Allerg Entered In error.
  if (AnIndex > -1) and (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then
    begin
      LoadNotes;
        with tvNotes do Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
    end;
end;

procedure TfrmNotes.popNoteMemoPopup(Sender: TObject);
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
    popNoteMemoViewCslt.Enabled := (FEditNote.PkgPtr = PKG_CONSULTS); // if editing consult title
  end else
  begin
    popNoteMemoSpell.Enabled    := False;
    popNoteMemoGrammar.Enabled  := False;
    popNoteMemoReformat.Enabled := False;
    popNoteMemoReplace.Enabled  := False;
    popNoteMemoPreview.Enabled  := False;
    popNoteMemoInsTemplate.Enabled  := False;
    popNoteMemoViewCslt.Enabled := FALSE;
  end;
end;

procedure TfrmNotes.popNoteMemoCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmNotes.popNoteMemoCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmNotes.popNoteMemoPasteClick(Sender: TObject);
begin
  inherited;
  Sendmessage(FEditCtrl.Handle,EM_PASTESPECIAL,CF_TEXT,0);
  frmNotes.pnlWriteResize(Self);
  //FEditCtrl.PasteFromClipboard;        // use AsText to prevent formatting
end;

procedure TfrmNotes.popNoteMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memNewNote then Exit;
  ReformatMemoParagraph(memNewNote);
end;

procedure TfrmNotes.popNoteMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmNotes.popNoteMemoFindClick(Sender: TObject);
//var
  //hData: THandle;  //CQ8300
  //pData: ^ClipboardData; //CQ8300
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgFindText do
    begin
      Position := Point(Application.MainForm.Left + pnlLeft.Width, Application.MainForm.Top);
      FindText := '';
      Options := [frDown, frHideUpDown];
{
      //CQ8300
      OpenClipboard(dlgFindText.Handle);
      hData := GetClipboardData(CF_TEXT);
      pData := GlobalLock(hData);
      FindText := pData^.Text;
      GlobalUnlock(hData);
      CloseClipboard;
      //end CQ8300
}
      Execute;
    end;
end;

procedure TfrmNotes.dlgFindTextFind(Sender: TObject);
begin
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoReplaceClick(Sender: TObject);
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

procedure TfrmNotes.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoSpellClick(Sender: TObject);
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

procedure TfrmNotes.popNoteMemoGrammarClick(Sender: TObject);
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

procedure TfrmNotes.popNoteMemoViewCsltClick(Sender: TObject);
var
  CsltIEN: integer ;
  ConsultDetail: TStringList;
  x: string;
begin
  inherited;
  if (Screen.ActiveControl <> memNewNote) or (FEditNote.PkgPtr <> PKG_CONSULTS) then Exit;
  CsltIEN := FEditNote.PkgIEN;
  x := FindConsult(CsltIEN);
  ConsultDetail := TStringList.Create;
  try
    LoadConsultDetail(ConsultDetail, CsltIEN) ;
    ReportBox(ConsultDetail, 'Consult Details: #' + IntToStr(CsltIEN) + ' - ' + Piece(x, U, 4), TRUE);
  finally
    ConsultDetail.Free;
  end;
end;

procedure TfrmNotes.mnuViewDetailClick(Sender: TObject);
begin
  inherited;
  if lstNotes.ItemIEN <= 0 then Exit;
  mnuViewDetail.Checked := not mnuViewDetail.Checked;
  if mnuViewDetail.Checked then
    begin
      StatusText('Retrieving progress note details...');
      Screen.Cursor := crHourGlass;
      LoadDetailText(memNote.Lines, lstNotes.ItemIEN);
      Screen.Cursor := crDefault;
      StatusText('');
      memNote.SelStart := 0;
      memNote.Repaint;
    end
  else
    lstNotesClick(Self);
  SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmNotes.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmNotes.mnuActIdentifyAddlSignersClick(Sender: TObject);
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
      LoadNotes;
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
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

  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
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
  UnlockConsultRequest(lstNotes.ItemIEN);
end;

procedure TfrmNotes.popNoteMemoAddlSignClick(Sender: TObject);
begin
  inherited;
  mnuActIdentifyAddlSignersClick(Self);
end;

procedure TfrmNotes.ProcessNotifications;
var
  x: string;
  Saved: boolean;
  tmpNode: TTreeNode;
  AnObject: PDocTreeObject;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  lblNotes.Caption := Notifications.Text;
  tvNotes.Caption := Notifications.Text;
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
  uChanging := True;
  tvNotes.Items.BeginUpdate;
  lstNotes.Clear;
  KillDocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  lstNotes.Items.Add(x);
  AnObject := MakeNoteTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
  tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  AnObject := MakeNoteTreeObject(x);
  tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := x;
  SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext, CT_NOTES);
  tvNotes.Selected := tmpNode;
  tvNotes.Items.EndUpdate;
  uChanging := False;
  tvNotesChange(Self, tvNotes.Selected);
  case Notifications.Followup of
    NF_NOTES_UNSIGNED_NOTE:   ;  //Automatically deleted by sig action!!!
  end;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then Notifications.Delete;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then Notifications.Delete;
end;

procedure TfrmNotes.SetViewContext(AContext: TTIUContext);
var
  Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FCurrentContext := AContext;
  EditingIndex := -1;
  tvNotes.Enabled := True ;
  pnlRead.BringToFront ;
  if FCurrentContext.Status <> '' then with uTIUContext do
    begin
      BeginDate      := FCurrentContext.BeginDate;
      EndDate        := FCurrentContext.EndDate;
      FMBeginDate    := FCurrentContext.FMBeginDate;
      FMEndDate      := FCurrentContext.FMEndDate;
      Status         := FCurrentContext.Status;
      Author         := FCurrentContext.Author;
      MaxDocs        := FCurrentContext.MaxDocs;
      ShowSubject    := FCurrentContext.ShowSubject;
      GroupBy        := FCurrentContext.GroupBy;
      SortBy         := FCurrentContext.SortBy;
      ListAscending  := FCurrentContext.ListAscending;
      TreeAscending  := FCurrentContext.TreeAscending;
      Keyword        := FCurrentContext.Keyword;
      SearchField    := FCurrentContext.SearchField;
      Filtered       := FCurrentContext.Filtered;
      Changed        := True;
      mnuViewClick(Self);
    end
  else
    begin
      ViewContext := NC_RECENT ;
      mnuViewClick(Self);
    end;
end;

procedure TfrmNotes.mnuViewSaveAsDefaultClick(Sender: TObject);
const
  TX_NO_MAX =  'You have not specified a maximum number of notes to be returned.' + CRLF +
               'If you save this preference, the result will be that ALL notes for every' + CRLF +
               'patient will be saved as your default view.' + CRLF + CRLF +
               'For patients with large numbers of notes, this could result in some lengthy' + CRLF +
               'delays in loading the list of notes.' + CRLF + CRLF +
               'Are you sure you mean to do this?';
  TX_REPLACE = 'Replace current defaults?';
begin
  inherited;
  if FCurrentContext.MaxDocs = 0 then
     if InfoBox(TX_NO_MAX,'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
       begin
         mnuViewClick(mnuViewCustom);
         Exit;
       end;
  if InfoBox(TX_REPLACE,'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      SaveCurrentTIUContext(FCurrentContext);
      FDefaultContext := FCurrentContext;
      //lblNotes.Caption := 'Default List';
    end;
end;

procedure TfrmNotes.mnuViewReturntoDefaultClick(Sender: TObject);
begin
  inherited;
  SetViewContext(FDefaultContext);
end;

procedure TfrmNotes.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, FEditCtrl.SelText);
end;

procedure TfrmNotes.popNoteListPopup(Sender: TObject);
begin
  inherited;
  N4.Visible                          := (popNoteList.PopupComponent is TORTreeView);
  popNoteListExpandAll.Visible        := N4.Visible;
  popNoteListExpandSelected.Visible   := N4.Visible;
  popNoteListCollapseAll.Visible      := N4.Visible;
  popNoteListCollapseSelected.Visible := N4.Visible;
end;

procedure TfrmNotes.popNoteListExpandAllClick(Sender: TObject);
begin
  inherited;
  tvNotes.FullExpand;
end;

procedure TfrmNotes.popNoteListCollapseAllClick(Sender: TObject);
begin
  inherited;
  tvNotes.Selected := nil;
  lvNotes.Items.Clear;
  memNote.Clear;
  tvNotes.FullCollapse;
  tvNotes.Selected := tvNotes.TopItem;
end;

procedure TfrmNotes.popNoteListExpandSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then exit;
  with tvNotes.Selected do if HasChildren then Expand(True);
end;

procedure TfrmNotes.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then exit;
  with tvNotes.Selected do if HasChildren then Collapse(True);
end;

procedure TfrmNotes.mnuEditTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self);
end;

procedure TfrmNotes.mnuNewTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE);
end;

procedure TfrmNotes.mnuEditSharedTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, FALSE, '', TRUE);
end;

procedure TfrmNotes.mnuNewSharedTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, '', TRUE);
end;

procedure TfrmNotes.mnuOptionsClick(Sender: TObject);
begin
  inherited;
  mnuEditTemplates.Enabled := frmDrawers.CanEditTemplates;
  mnuNewTemplate.Enabled := frmDrawers.CanEditTemplates;
  mnuEditSharedTemplates.Enabled := frmDrawers.CanEditShared;
  mnuNewSharedTemplate.Enabled := frmDrawers.CanEditShared;
  mnuEditDialgFields.Enabled := CanEditTemplateFields;
end;

procedure TfrmNotes.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if(FEditingIndex < 0) then
    KillReminderDialog(Self);
  if(assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

function TfrmNotes.CanFinishReminder: boolean;
begin
  if(EditingIndex < 0) then
    Result := FALSE
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmNotes.FormDestroy(Sender: TObject);
begin
  FDocList.Free;
  FImageFlag.Free;
  KillDocTreeObjects(tvNotes);
  inherited;
end;

function TfrmNotes.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers;
end;

procedure TfrmNotes.AssignRemForm;
begin
  with RemForm do
  begin
    Form := Self;
    PCEObj := uPCEEdit;
    RightPanel := pnlRight;
    CanFinishProc := CanFinishReminder;
    DisplayPCEProc := DisplayPCE;
    Drawers := frmDrawers;
    NewNoteRE := memNewNote;
    NoteList := lstNotes;
  end;
end;

procedure TfrmNotes.mnuEditDialgFieldsClick(Sender: TObject);
begin
  inherited;
  EditDialogFields;
end;

//===================  Added for sort/search enhancements ======================
procedure TfrmNotes.LoadNotes;
const
  INVALID_ID = -1;
  INFO_ID = 1;
var
  tmpList: TStringList;
  ANode: TORTreeNode;
  x,xx,noteId: integer;   // Text Search CQ: HDS00002856
  Dest: TStrings;  // Text Search CQ: HDS00002856
  KeepFlag: Boolean;  // Text Search CQ: HDS00002856
  NoteCount, NoteMatches: integer;  // Text Search CQ: HDS00002856
begin
  tmpList := TStringList.Create;
  try
    FDocList.Clear;
    uChanging := True;
    RedrawSuspend(memNote.Handle);
    RedrawSuspend(lvNotes.Handle);
    tvNotes.Items.BeginUpdate;
    lstNotes.Items.Clear;
    KillDocTreeObjects(tvNotes);
    tvNotes.Items.Clear;
    tvNotes.Items.EndUpdate;
    lvNotes.Items.Clear;
    memNote.Clear;
    memNote.Invalidate;
    lblTitle.Caption := '';
    lvNotes.Caption := '';
    with FCurrentContext do
      begin
        if Status <> IntToStr(NC_UNSIGNED) then
          begin
            ListNotesForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0, TreeAscending);
            if tmpList.Count > 0 then
              begin
                CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNSIGNED, GroupBy, TreeAscending, CT_NOTES);
                UpdateTreeView(FDocList, tvNotes);
              end;
            tmpList.Clear;
            FDocList.Clear;
          end;
        if Status <> IntToStr(NC_UNCOSIGNED) then
          begin
            ListNotesForTree(tmpList, NC_UNCOSIGNED, 0, 0, 0, 0, TreeAscending);
            if tmpList.Count > 0 then
              begin
                CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNCOSIGNED, GroupBy, TreeAscending, CT_NOTES);
                UpdateTreeView(FDocList, tvNotes);
              end;
            tmpList.Clear;
            FDocList.Clear;
          end;
        ListNotesForTree(tmpList, StrToIntDef(Status, 0), FMBeginDate, FMEndDate, Author, MaxDocs, TreeAscending);
        CreateListItemsforDocumentTree(FDocList, tmpList, StrToIntDef(Status, 0), GroupBy, TreeAscending, CT_NOTES);

        // Text Search CQ: HDS00002856 ---------------------------------------
        if FCurrentContext.SearchString<>''  then   // Text Search CQ: HDS00002856
          begin
            NoteMatches := 0;
            Dest:=TStringList.Create;
            NoteCount:=FDocList.Count-1;
            if FDocList.Count>0 then
              for x := FDocList.Count-1 downto 1 do begin;  // Don't do 0, because it's informational
                KeepFlag:=False;
                lblNotes.Caption:='Scanning '+IntToStr(NoteCount-x+1)+' of '+IntToStr(NoteCount)+', '+IntToStr(NoteMatches);
                If NoteMatches=1 then lblNotes.Caption:=lblNotes.Caption+' match' else
                                      lblNotes.Caption:=lblNotes.Caption+' matches';
                frmSearchStop.lblSearchStatus.Caption := lblNotes.Caption;
                frmSearchStop.lblSearchStatus.Repaint;
                lblNotes.Repaint;
                // Free up some ticks so they can click the "Stop" button
                application.processmessages;
                application.processmessages;
                application.processmessages;
                If SearchTextStopFlag = False then begin
                  noteId := StrToIntDef(Piece(FDocList.Strings[x],'^',1),-1);
                  if (noteId = INVALID_ID) or (noteId = INFO_ID) then
                    Continue;
                  CallV('TIU GET RECORD TEXT', [Piece(FDocList.Strings[x],'^',1)]);
                  FastAssign(RPCBrokerV.Results, Dest);
                  If Dest.Count > 0 then
                     for xx := 0 to Dest.Count-1 do
                     begin
                      //Dest.Strings[xx] := StringReplace(Dest.Strings[xx],'#13',' ',[rfReplaceAll, rfIgnoreCase]);
                      if Pos(Uppercase(FCurrentContext.SearchString),Uppercase(Dest.Strings[xx]))>0 then
                        keepflag:=true;
                     end;
                  If KeepFlag=False then begin;
                    if FDocList.Count >= x then
                      FDocList.Delete(x);
                    if (tmpList.Count >= x) and (x > 0) then
                      tmpList.Delete(x-1);
                  end else
                    Inc(NoteMatches);
                end;
              end;
            Dest.Free;
          end else
          //Reset the caption
          lblNotes.Caption := SetNoteTreeLabel(FCurrentContext);
          NoteTotal := sCallV('ORCNOTE GET TOTAL', [Patient.DFN]);
          lblNotes.Caption := lblNotes.Caption + ' (Total: ' + NoteTotal + ')';
        // Text Search CQ: HDS00002856 ---------------------------------------

        UpdateTreeView(FDocList, tvNotes);
      end;
    with tvNotes do
      begin
        uChanging := True;
        tvNotes.Items.BeginUpdate;
        RemoveParentsWithNoChildren(tvNotes, FCurrentContext);  // moved here in v15.9 (RV)
        if FLastNoteID <> '' then
          Selected := FindPieceNode(FLastNoteID, 1, U, nil);
        if Selected = nil then
          begin
            if (FCurrentContext.GroupBy <> '') or (FCurrentContext.Filtered) then
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
                ANode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                if ANode <> nil then ANode.Expand(False);
                ANode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), 1, U, nil);
                if ANode = nil then
                  ANode := tvNotes.FindPieceNode(IntToStr(NC_UNCOSIGNED), 1, U, nil);
                if ANode = nil then
                  ANode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                if ANode <> nil then
                  begin
                    if ANode.getFirstChild <> nil then
                      Selected := ANode.getFirstChild
                    else
                      Selected := ANode;
                  end;
              end;
          end;
        memNote.Clear;
        with lvNotes do
          begin
            Selected := nil;
            if FCurrentContext.SortBy <> '' then
              ColumnToSort := Pos(FCurrentContext.SortBy, 'RDSAL') - 1;
            if not FCurrentContext.ShowSubject then
              begin
                Columns[1].Width := 2 * (Width div 5);
                Columns[2].Width := 0;
              end
            else
              begin
                Columns[1].Width := Width div 5;
                Columns[2].Width := Columns[1].Width;
              end;
          end;
        //RemoveParentsWithNoChildren(tvNotes, FCurrentContext);  // moved FROM here in v15.9 (RV)
        tvNotes.Items.EndUpdate;
        uChanging := False;
        SendMessage(tvNotes.Handle, WM_VSCROLL, SB_TOP, 0);
        if Selected <> nil then tvNotesChange(Self, Selected);
      end;
  finally
    RedrawActivate(memNote.Handle);
    RedrawActivate(lvNotes.Handle);
    tmpList.Free;
  end;
end;

procedure TfrmNotes.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
begin
  with Tree do
    begin
      uChanging := True;
      Items.BeginUpdate;
      FastAddStrings(DocList, lstNotes.Items);
      BuildDocumentTree(DocList, '0', Tree, nil, FCurrentContext, CT_NOTES);
      Items.EndUpdate;
      uChanging := False;
    end;
end;

procedure TfrmNotes.tvNotesChange(Sender: TObject; Node: TTreeNode);
var
  x, MySearch, MyNodeID: string;
  i: integer;
  WhyNot: string;
begin
  if uChanging then Exit;
  //This gives the change a chance to occur when keyboarding, so that WindowEyes
  //doesn't use the old value.
  Application.ProcessMessages;
  with tvNotes do
    begin
      memNote.Clear;
      if Selected = nil then Exit;
      if uIDNotesActive then
        begin
          mnuActDetachFromIDParent.Enabled := (Selected.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
          popNoteListDetachFromIDParent.Enabled := mnuActDetachFromIDParent.Enabled;
          if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
            mnuActAttachtoIDParent.Enabled := CanBeAttached(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
          else
            mnuActAttachtoIDParent.Enabled := False;
          popNoteListAttachtoIDParent.Enabled := mnuActAttachtoIDParent.Enabled;
          if (Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                      IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                      IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
            mnuActAddIDEntry.Enabled := CanReceiveAttachment(PDocTreeObject(Selected.Data)^.DocID, WhyNot)
          else
            mnuActAddIDEntry.Enabled := False;
          popNoteListAddIDEntry.Enabled := mnuActAddIDEntry.Enabled
        end;
      RedrawSuspend(lvNotes.Handle);
      RedrawSuspend(memNote.Handle);
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      x := TORTreeNode(Selected).StringData;
      if (Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
        begin
          lvNotes.Visible := True;
          lvNotes.Items.Clear;
          lvNotes.Height := (2 * lvNotes.Parent.Height) div 5;
          with lblTitle do
            begin
              Caption := Trim(Selected.Text);
              if (FCurrentContext.SearchField <> '') and (FCurrentContext.Filtered) then
                begin
                  case FCurrentContext.SearchField[1] of
                    'T': MySearch := 'TITLE';
                    'S': MySearch := 'SUBJECT';
                    'B': MySearch := 'TITLE or SUBJECT';
                  end;
                  Caption := Caption + ' where ' + MySearch + ' contains "' + UpperCase(FCurrentContext.Keyword) + '"';
                end;
              lvNotes.Caption := Caption;
            end;

          if Selected.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected).StringData, U, 1)
          else if Selected.Parent.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected.Parent).StringData, U, 1)
          else if Selected.Parent.Parent.ImageIndex = IMG_TOP_LEVEL then
            MyNodeID := Piece(TORTreeNode(Selected.Parent.Parent).StringData, U, 1);

          uChanging := True;
          TraverseTree(tvNotes, lvNotes, Selected.GetFirstChild, MyNodeID, FCurrentContext);
          with lvNotes do
            begin
              for i := 0 to Columns.Count - 1 do
                Columns[i].ImageIndex := IMG_NONE;
              ColumnSortForward := FCurrentContext.ListAscending;
              if ColumnToSort = 5 then ColumnToSort := 0;
              if ColumnSortForward then
                Columns[ColumnToSort].ImageIndex := IMG_ASCENDING
              else
                Columns[ColumnToSort].ImageIndex := IMG_DESCENDING;
              if ColumnToSort = 0 then ColumnToSort := 5;
              AlphaSort;
              Columns[5].Width := 0;
              Columns[6].Width := 0;
            end;
          uChanging := False;
          with lvNotes do
            if Items.Count > 0 then
              begin
                Selected := Items[0];
                lvNotesSelectItem(Self, Selected, True);
              end
            else
              begin
                Selected := nil;
                lstNotes.ItemIndex := -1;
                memPCEShow.Clear;
                ShowPCEControls(False);
              end;
          pnlWrite.Visible := False;
          pnlRead.Visible := True;
          //  uncommented next 4 lines in v17.5  (RV)
          //-----------------------------
          UpdateReminderFinish;
          ShowPCEControls(False);
          frmDrawers.DisplayDrawers(TRUE, [odTemplates], [odTemplates]); //FALSE);
          ShowPCEButtons(FALSE);
          //-----------------------------
          //memNote.Clear;
        end
      else if StrToIntDef(Piece(x, U, 1), 0) > 0 then
        begin
          memNote.Clear;
          lvNotes.Visible := False;
          lstNotes.SelectByID(Piece(x, U, 1));
          lstNotesClick(Self);
          SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
        end;
      SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
      RedrawActivate(lvNotes.Handle);
      RedrawActivate(memNote.Handle);
    end;
end;

procedure TfrmNotes.tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmNotes.tvNotesExpanded(Sender: TObject; Node: TTreeNode);

  function SortByTitle(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by title
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
                                  PChar(PDocTreeObject(Node2.Data)^.DocTitle));
      end
  end;

  function SortByDate(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by document date
    BUT - addenda to parent document are always at the top of the sort, in date order}
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
       (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
      begin
        Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then Result := 1
    else
      begin
        if Data = 0 then
          Result :=  AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate))
        else
          Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
                                  PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
      end;
  end;

begin
  with Node do
    begin
      if Assigned(Data) then
        if (Pos('<', PDocTreeObject(Data)^.DocHasChildren) > 0) then
          begin
            if (PDocTreeObject(Node.Data)^.OrderByTitle) then
              CustomSort(@SortByTitle, 0)
            else
              CustomSort(@SortByDate, 0);
          end;
      if (ImageIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        ImageIndex := ImageIndex + 1;
      if (SelectedIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT]) then
        SelectedIndex := SelectedIndex + 1;
    end;
end;

procedure TfrmNotes.tvNotesClick(Sender: TObject);
begin
(*  if tvNotes.Selected = nil then exit;
  if (tvNotes.Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
    begin
      uChanging := True;
      lvNotes.Selected := nil;
      uChanging := False;
      memNote.Clear;
    end;*)
end;

procedure TfrmNotes.tvNotesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := False;
  if not uIDNotesActive then exit;
  AnItem := TORTreeNode(tvNotes.GetNodeAt(X, Y));
  if (AnItem = nil) or (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then Exit;
  with tvNotes.Selected do
    if (ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
      Accept := (AnItem.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                       IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                       IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT])
    else if (ImageIndex in [IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      Accept := (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL])
    else if (ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then
      Accept := False;
end;

procedure TfrmNotes.tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HT: THitTests;
  Saved: boolean;
  ADestNode: TORTreeNode;
begin
  if not uIDNotesActive then
    begin
      CancelDrag;
      exit;
    end;
  if tvNotes.Selected = nil then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  HT := tvNotes.GetHitTestInfoAt(X, Y);
  ADestNode := TORTreeNode(tvNotes.GetNodeAt(X, Y));
  DoAttachIDChild(TORTreeNode(tvNotes.Selected), ADestNode);
end;

procedure TfrmNotes.tvNotesStartDrag(Sender: TObject; var DragObject: TDragObject);
const
  TX_CAP_NO_DRAG = 'Item cannot be moved';
  TX_NO_EDIT_DRAG = 'Items can not be dragged while a note is being edited.';
var
  WhyNot: string;
  //Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    InfoBox(TX_NO_EDIT_DRAG, TX_CAP_NO_DRAG, MB_ICONERROR or MB_OK);
    CancelDrag;
    Exit;
  end;
  if (tvNotes.Selected.ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) or
     (not uIDNotesActive) or
     (lstNotes.ItemIEN = 0) then
    begin
      CancelDrag;
      Exit;
    end;
(*  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;*)
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      InfoBox(WhyNot, TX_CAP_NO_DRAG, MB_OK);
      CancelDrag;
    end;
end;

//=====================  Listview events  =================================

procedure TfrmNotes.lvNotesColumnClick(Sender: TObject; Column: TListColumn);
var
  i, ClickedColumn: Integer;
begin
  if Column.Index = 0 then ClickedColumn := 5 else ClickedColumn := Column.Index;
  if ClickedColumn = ColumnToSort then
    ColumnSortForward := not ColumnSortForward
  else
    ColumnSortForward := True;
  for i := 0 to lvNotes.Columns.Count - 1 do
    lvNotes.Columns[i].ImageIndex := IMG_NONE;
  if ColumnSortForward then lvNotes.Columns[Column.Index].ImageIndex := IMG_ASCENDING
  else lvNotes.Columns[Column.Index].ImageIndex := IMG_DESCENDING;
  ColumnToSort := ClickedColumn;
  case ColumnToSort of
    5:  FCurrentContext.SortBy := 'R';
    1:  FCurrentContext.SortBy := 'D';
    2:  FCurrentContext.SortBy := 'S';
    3:  FCurrentContext.SortBy := 'A';
    4:  FCurrentContext.SortBy := 'L';
  else
    FCurrentContext.SortBy := 'R';
  end;
  FCurrentContext.ListAscending := ColumnSortForward;
  (Sender as TCustomListView).AlphaSort;
  //with lvNotes do if Selected <> nil then Scroll(0,  Selected.Top - TopItem.Top);
end;

procedure TfrmNotes.lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
  if not ColumnSortForward then Compare := -Compare;
end;

procedure TfrmNotes.lvNotesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if uChanging or (not Selected) then Exit;
  with lvNotes do
    begin
      StatusText('Retrieving selected progress note...');
      lstNotes.SelectByID(Item.SubItems[5]);
      lstNotesClick(Self);
      SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
    end;
end;

procedure TfrmNotes.lvNotesResize(Sender: TObject);
begin
  inherited;
  with lvNotes do
    begin
      if not FCurrentContext.ShowSubject then
        begin
          Columns[1].Width := 2 * (Width div 5);
          Columns[2].Width := 0;
        end
      else
        begin
          Columns[1].Width := Width div 5;
          Columns[2].Width := Columns[1].Width;
        end;
    end;
end;

procedure TfrmNotes.EnableDisableIDNotes;
begin
  uIDNotesActive := IDNotesInstalled;
  mnuActDetachFromIDParent.Visible := uIDNotesActive;
  popNoteListDetachFromIDParent.Visible := uIDNotesActive;
  mnuActAddIDEntry.Visible := uIDNotesActive;
  popNoteListAddIDEntry.Visible := uIDNotesActive;
  mnuActAttachtoIDParent.Visible := uIDNotesActive;
  popNoteListAttachtoIDParent.Visible := uIDNotesActive;
  if uIDNotesActive then
    tvNotes.DragMode := dmAutomatic
  else
    tvNotes.DragMode := dmManual;
end;

procedure TfrmNotes.ShowPCEButtons(Editing: boolean);
begin
  if frmFrame.Timedout then Exit;

  FEditingNotePCEObj := Editing;
  if Editing or AnytimeEncounters then
  begin
    cmdPCE.Visible := TRUE;
    if Editing then
    begin
      cmdPCE.Enabled := CanEditPCE(uPCEEdit);
      cmdNewNote.Visible := AnytimeEncounters;
      cmdNewNote.Enabled := FALSE;
    end
    else
    begin
      cmdPCE.Enabled     := (GetAskPCE(0) <> apDisable);
      cmdNewNote.Visible := TRUE;
      cmdNewNote.Enabled := (FStarting = False); //TRUE;
    end;
    if cmdNewNote.Visible then
      cmdPCE.Top := cmdNewNote.Top-cmdPCE.Height;
  end
  else
  begin
    cmdPCE.Enabled := FALSE;
    cmdPCE.Visible := FALSE;
    cmdNewNote.Visible := TRUE;
    cmdNewNote.Enabled := (FStarting = False); //TRUE;
  end;
  if cmdPCE.Visible then
    lblSpace1.Top := cmdPCE.Top - lblSpace1.Height
  else
    lblSpace1.Top := cmdNewNote.Top - lblSpace1.Height;
  popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
  popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmNotes.mnuIconLegendClick(Sender: TObject);
begin
  inherited;
  ShowIconLegend(ilNotes);
end;

procedure TfrmNotes.mnuActAttachtoIDParentClick(Sender: TObject);
var
  AChildNode: TORTreeNode;
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if not uIDNotesActive then exit;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadNotes;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvNotes.Selected = nil then exit;
  AChildNode := TORTreeNode(tvNotes.Selected);
  AParentID := SelectParentNodeFromList(tvNotes);
  if AParentID = '' then exit;
  with tvNotes do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
  DoAttachIDChild(AChildNode, TORTreeNode(tvNotes.Selected));
end;

procedure TfrmNotes.DoAttachIDChild(AChild, AParent: TORTreeNode);
const
  TX_ATTACH_CNF     = 'Confirm Attachment';
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  ErrMsg, WhyNot: string;
  SavedDocID: string;
begin
  if (AChild = nil) or (AParent = nil) then exit;
  ErrMsg := '';
  if not CanBeAttached(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot + CRLF + CRLF;
  if not CanReceiveAttachment(PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot;
  if ErrMsg <> '' then
    begin
      InfoBox(ErrMsg, TX_ATTACH_FAILURE, MB_OK);
      Exit;
    end
  else
    begin
      WhyNot := '';
      if (InfoBox('ATTACH:   ' + AChild.Text + CRLF + CRLF +
                  '    TO:   ' + AParent.Text + CRLF + CRLF +
                  'Are you sure?', TX_ATTACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
          then Exit;
      SavedDocID := PDocTreeObject(AParent.Data)^.DocID;
    end;
  if AChild.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD] then
    begin
      if DetachEntryFromParent(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
        begin
          if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
            begin
              LoadNotes;
              with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
              if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
            end
          else
            InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
        end
      else
        begin
          WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
          WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
          InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
          Exit;
        end;
    end
  else
    begin
      if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID, PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
        begin
          LoadNotes;
          with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
          if tvNotes.Selected <> nil then tvNotes.Selected.Expand(False);
        end
      else
        InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
   end;
end;

function TfrmNotes.SetNoteTreeLabel(AContext: TTIUContext): string;
var
  x: string;

  function SetDateRangeText(AContext: TTIUContext): string;
  var
    x1: string;
  begin
    with AContext do
      if BeginDate <> '' then
        begin
          x1 := ' from ' + UpperCase(BeginDate);
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
        NC_ALL        : x := x + 'Signed Notes';
        NC_UNSIGNED   : begin
                          x := x + 'Unsigned Notes for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_UNCOSIGNED : begin
                          x := x + 'Uncosigned Notes for ';
                          if Author > 0 then x := x + ExternalName(Author, 200)
                          else x := x + User.Name;
                          x := x + SetDateRangeText(AContext);
                        end;
        NC_BY_AUTHOR  : x := x + 'Signed Notes for ' + ExternalName(Author, 200) + SetDateRangeText(AContext);
        NC_BY_DATE    : x := x + 'Signed Notes ' + SetDateRangeText(AContext);
      else
        x := 'Custom List';
      end;
    end;
  Result := x;
end;

procedure TfrmNotes.memNewNoteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FNavigatingTab := (Key = VK_TAB) and ([ssShift,ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmNotes.UpdateNoteAuthor(DocInfo: string);
const
  TX_INVALID_AUTHOR1 = 'The author returned by the template (';
  TX_INVALID_AUTHOR2 = ') is not valid.' + #13#10 + 'The note''s author will remain as ';
  TC_INVALID_AUTHOR  = 'Invalid Author';
  TX_COSIGNER_REQD   = ' requires a cosigner for this note.';
  TC_COSIGNER_REQD   = 'Cosigner Required';
var
  NewAuth, NewAuthName, AuthNameCheck, x: string;
  ADummySender: TObject;
begin
  if DocInfo = '' then Exit;
  NewAuth := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_IEN');
  if NewAuth = '' then Exit;
  AuthNameCheck := ExternalName(StrToInt64Def(NewAuth, 0), 200);
  if AuthNameCheck = '' then
  begin
    NewAuthName := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_NAME');
    InfoBox(TX_INVALID_AUTHOR1 + UpperCase(NewAuthName) +  TX_INVALID_AUTHOR2 + UpperCase(FEditNote.AuthorName),
            TC_INVALID_AUTHOR, MB_OK and MB_ICONERROR);
    Exit;
  end;
  with FEditNote do if StrToInt64Def(NewAuth, 0) <> Author then
  begin
    Author := StrToInt64Def(NewAuth, 0);
    AuthorName := AuthNameCheck;
    x := lstNotes.Items[EditingIndex];
    SetPiece(x, U, 5, NewAuth + ';' + AuthNameCheck);
    lstNotes.Items[EditingIndex] := x;
    if AskCosignerForTitle(Title, Author, DateTime) then
    begin
      InfoBox(UpperCase(AuthNameCheck) + TX_COSIGNER_REQD, TC_COSIGNER_REQD, MB_OK);
      //Cosigner := 0;   CosignerName := '';  // not sure about this yet
      ADummySender := TObject.Create;
      try
        cmdChangeClick(ADummySender);
      finally
        FreeAndNil(ADummySender);
      end;
    end
    else cmdChangeClick(Self);
  end;
end;

procedure TfrmNotes.sptHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if pnlWrite.Visible then
     if NewSize > frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width then
        NewSize := frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - sptHorz.Width;
end;

procedure TfrmNotes.popNoteMemoInsTemplateClick(Sender: TObject);
begin
  frmDrawers.mnuInsertTemplateClick(Sender);
end;

procedure TfrmNotes.popNoteMemoPreviewClick(Sender: TObject);
begin
  frmDrawers.mnuPreviewTemplateClick(Sender);
end;

{Tab Order tricks.  Need to change
  tvNotes

  frmDrawers.pnlTemplateButton
  frmDrawers.pnlEncounterButton
  cmdNewNote
  cmdPCE

  lvNotes
  memNote

to
  tvNotes

  lvNotes
  memNote

  frmDrawers.pnlTemplateButton
  frmDrawers.pnlEncounterButton
  cmdNewNote
  cmdPCE
}

procedure TfrmNotes.tvNotesExit(Sender: TObject);
begin
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = frmDrawers.pnlTemplatesButton) or
        (Screen.ActiveControl = frmDrawers.pnlEncounterButton) or
        (Screen.ActiveControl = cmdNewNote) or
        (Screen.ActiveControl = cmdPCE) then
      FindNextControl( cmdPCE, True, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.pnlReadExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = frmFrame.pnlPatient) then
      FindNextControl( tvNotes, True, True, False).SetFocus
    else
    if (Screen.ActiveControl = frmDrawers.pnlTemplatesButton) or
        (Screen.ActiveControl = frmDrawers.pnlEncounterButton) or
        (Screen.ActiveControl = cmdNewNote) or
        (Screen.ActiveControl = cmdPCE) then
      FindNextControl( frmDrawers.pnlTemplatesButton, False, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.cmdNewNoteExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = lvNotes) or
        (Screen.ActiveControl = memNote) then
      frmFrame.pnlPatient.SetFocus
    else
    if (Screen.ActiveControl = tvNotes) then
      FindNextControl( frmFrame.pnlPatient, False, True, False).SetFocus;
  end;
end;

procedure TfrmNotes.frmFramePnlPatientExit(Sender: TObject);
begin
  FOldFramePnlPatientExit(Sender);
  if TabIsPressed or ShiftTabIsPressed then
  begin
    if (Screen.ActiveControl = lvNotes) or
        (Screen.ActiveControl = memNote) then
      FindNextControl( lvNotes, False, True, False).SetFocus;
    if Screen.ActiveControl = memPCEShow then
      if cmdPCE.CanFocus then
        cmdPCE.SetFocus
      else if cmdNewNote.CanFocus then
        cmdNewNote.SetFocus;
  end;
end;

procedure TfrmNotes.FormHide(Sender: TObject);
begin
  inherited;
  frmFrame.pnlPatient.OnExit := FOldFramePnlPatientExit;
  frmDrawers.pnlTemplatesButton.OnExit := FOldDrawerPnlTemplatesButtonExit;
  frmDrawers.pnlEncounterButton.OnExit := FOldDrawerPnlEncounterButtonExit;
  frmDrawers.edtSearch.OnExit := FOldDrawerEdtSearchExit;
end;

procedure TfrmNotes.FormShow(Sender: TObject);
begin
  inherited;
  FOldFramePnlPatientExit := frmFrame.pnlPatient.OnExit;
  frmFrame.pnlPatient.OnExit := frmFramePnlPatientExit;
  FOldDrawerPnlTemplatesButtonExit := frmDrawers.pnlTemplatesButton.OnExit;
  frmDrawers.pnlTemplatesButton.OnExit := frmDrawerPnlTemplatesButtonExit;
  FOldDrawerPnlEncounterButtonExit := frmDrawers.pnlEncounterButton.OnExit;
  frmDrawers.pnlEncounterButton.OnExit := frmDrawerPnlEncounterButtonExit;
  FOldDrawerEdtSearchExit := frmDrawers.edtSearch.OnExit;
  frmDrawers.edtSearch.OnExit := frmDrawerEdtSearchExit;
end;

procedure TfrmNotes.frmDrawerEdtSearchExit(Sender: TObject);
begin
  FOldDrawerEdtSearchExit(Sender);
  cmdNewNoteExit(Sender);
end;

procedure TfrmNotes.frmDrawerPnlTemplatesButtonExit(Sender: TObject);
begin
  FOldDrawerPnlTemplatesButtonExit(Sender);
  if Boolean(Hi(GetKeyState(VK_TAB))) and  (memNewNote.CanFocus) and
     Boolean(Hi(GetKeyState(VK_SHIFT))) then
    memNewNote.SetFocus
  else
    cmdNewNoteExit(Sender);
end;

procedure TfrmNotes.frmDrawerPnlEncounterButtonExit(Sender: TObject);
begin
  FOldDrawerPnlEncounterButtonExit(Sender);
  cmdNewNoteExit(Sender);
end;

procedure TfrmNotes.memNewNoteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processinend;
end;

procedure TfrmNotes.memNewNoteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      if frmDrawers.pnlTemplatesButton.CanFocus then
        frmDrawers.pnlTemplatesButton.SetFocus
      else
        FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmNotes.memPCEShowExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if TabIsPressed then
    if frmDrawers.pnlTemplatesButton.CanFocus then
      frmDrawers.pnlTemplatesButton.SetFocus
end;

procedure TfrmNotes.cmdChangeExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if Boolean(Hi(GetKeyState(VK_TAB))) and
     Boolean(Hi(GetKeyState(VK_SHIFT))) then
    tvNotes.SetFocus;
end;

procedure TfrmNotes.cmdPCEExit(Sender: TObject);
begin
  inherited;
  //Fix the Tab Order  Make Drawers Buttons Accessible
  if TabIsPressed then
    if frmFrame.pnlPatient.CanFocus then
      frmFrame.pnlPatient.SetFocus;
end;

procedure TfrmNotes.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmNotes.mnuViewInformationClick(Sender: TObject);
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

procedure TfrmNotes.UpdateFormForInput;
var
  idx, offset: integer;

begin
  if (not pnlWrite.Visible) or uInit.TimedOut then exit;

  if (frmFrame.WindowState = wsMaximized) then
    idx := GetSystemMetrics(SM_CXFULLSCREEN)
  else
    idx := GetSystemMetrics(SM_CXSCREEN);
  if idx > frmFrame.Width then
    idx := frmFrame.Width;

  offset := 5;
  if(MainFontSize <> 8) then
    offset := ResizeWidth(BaseFont, Font, offset);
  dec(idx, offset + 10);
  dec(idx, pnlLeft.Width);
  dec(idx, sptHorz.Width);
  dec(idx, cmdChange.Width);

  cmdChange.Left := idx;
end;

initialization
  SpecifyFormIsNotADialog(TfrmNotes);
  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;

finalization
  if (uPCEEdit <> nil) then uPCEEdit.Free; //CQ7012 Added test for nil
  if (uPCEShow <> nil) then uPCEShow.Free; //CQ7012 Added test for nil
   
end.


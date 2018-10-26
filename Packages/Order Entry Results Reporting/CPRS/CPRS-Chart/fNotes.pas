unit fNotes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst, ORDtTm,
  uPCE, ORClasses, ImgList, rTIU, uTIU, uDocTree, fRptBox, fPrintList,
  rMisc, fNoteST, ORNet, fNoteSTStop, fBase508Form, VA508AccessibilityManager,
  uTemplates, VA508ImageListLabeler, RichEdit, mDrawers, ORSplitter, System.Actions,
  Vcl.ActnList, ORextensions;

type
  TfrmNotes = class(TfrmPage)
    fldAccessReminders: TVA508ComponentAccessibility;
    imgLblReminders: TVA508ImageListLabeler;
    imgLblTemplates: TVA508ImageListLabeler;
    fldAccessTemplates: TVA508ComponentAccessibility;
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    pnlReminder: TPanel;
    stNotes: TVA508StaticText;
    pnlWrite: TPanel;
    memNewNote: TRichEdit;
    pnlFields: TPanel;
    bvlNewTitle: TBevel;
    stRefDate: TStaticText;
    stAuthor: TStaticText;
    lblVisit: TStaticText;
    stCosigner: TStaticText;
    lblSubject: TStaticText;
    lblNewTitle: TStaticText;
    cmdChange: TButton;
    txtSubject: TCaptionEdit;
    stTitle: TVA508StaticText;
    tvNotes: TORTreeView;
    cmdNewNote: TORAlignButton;
    cmdPCE: TORAlignButton;
    lvNotes: TCaptionListView;
    memPCEShow: TRichEdit;
    lstNotes: TORListBox;
    mnuNotes: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartCover: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuViewInformation: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    mnuViewReminders: TMenuItem;
    mnuViewPostings: TMenuItem;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewByAuthor: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewUncosigned: TMenuItem;
    mnuViewUnsigned: TMenuItem;
    mnuViewCustom: TMenuItem;
    mnuSearchForText: TMenuItem;
    N1: TMenuItem;
    mnuViewSaveAsDefault: TMenuItem;
    mnuReturntoDefault: TMenuItem;
    Z1: TMenuItem;
    mnuViewDetail: TMenuItem;
    N6: TMenuItem;
    mnuIconLegend: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    mnuActAddend: TMenuItem;
    mnuActAddIDEntry: TMenuItem;
    mnuActAttachtoIDParent: TMenuItem;
    mnuActDetachFromIDParent: TMenuItem;
    mnuEncounter: TMenuItem;
    Z4: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActLoadBoiler: TMenuItem;
    Z2: TMenuItem;
    mnuActSignList: TMenuItem;
    mnuActDelete: TMenuItem;
    mnuActEdit: TMenuItem;
    mnuActSave: TMenuItem;
    mnuActSign: TMenuItem;
    mnuActIdentifyAddlSigners: TMenuItem;
    mnuOptions: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    N2: TMenuItem;
    mnuEditSharedTemplates: TMenuItem;
    mnuNewSharedTemplate: TMenuItem;
    N3: TMenuItem;
    mnuEditDialgFields: TMenuItem;
    timAutoSave: TTimer;
    dlgReplaceText: TReplaceDialog;
    dlgFindText: TFindDialog;
    popNoteList: TPopupMenu;
    popNoteListAll: TMenuItem;
    popNoteListByAuthor: TMenuItem;
    popNoteListByDate: TMenuItem;
    popNoteListUncosigned: TMenuItem;
    popNoteListUnsigned: TMenuItem;
    popNoteListCustom: TMenuItem;
    popSearchForText: TMenuItem;
    N4: TMenuItem;
    popNoteListExpandSelected: TMenuItem;
    popNoteListExpandAll: TMenuItem;
    popNoteListCollapseSelected: TMenuItem;
    popNoteListCollapseAll: TMenuItem;
    N5: TMenuItem;
    popNoteListAddIDEntry: TMenuItem;
    popNoteListAttachtoIDParent: TMenuItem;
    popNoteListDetachFromIDParent: TMenuItem;
    popNoteMemo: TPopupMenu;
    popNoteMemoCut: TMenuItem;
    popNoteMemoCopy: TMenuItem;
    popNoteMemoPaste: TMenuItem;
    popNoteMemoPaste2: TMenuItem;
    popNoteMemoReformat: TMenuItem;
    popNoteMemoSaveContinue: TMenuItem;
    Z11: TMenuItem;
    popNoteMemoFind: TMenuItem;
    popNoteMemoReplace: TMenuItem;
    N7: TMenuItem;
    popNoteMemoGrammar: TMenuItem;
    popNoteMemoSpell: TMenuItem;
    Z12: TMenuItem;
    popNoteMemoTemplate: TMenuItem;
    Z10: TMenuItem;
    popNoteMemoSignList: TMenuItem;
    popNoteMemoDelete: TMenuItem;
    popNoteMemoEdit: TMenuItem;
    popNoteMemoAddend: TMenuItem;
    popNoteMemoSave: TMenuItem;
    popNoteMemoSign: TMenuItem;
    popNoteMemoAddlSign: TMenuItem;
    N8: TMenuItem;
    popNoteMemoPreview: TMenuItem;
    popNoteMemoInsTemplate: TMenuItem;
    popNoteMemoEncounter: TMenuItem;
    popNoteMemoViewCslt: TMenuItem;
    ActionList: TActionList;
    acNewNote: TAction;
    acPCE: TAction;
    acAddendum: TAction;
    acAddNewEntryIDN: TAction;
    acAttachIDN: TAction;
    acDetachIDN: TAction;
    acChangeTitle: TAction;
    acReloadBoiler: TAction;
    acAddSignList: TAction;
    acDeleteNote: TAction;
    acEditNote: TAction;
    acSaveNoSig: TAction;
    acSign: TAction;
    acIDAddlSign: TAction;
    acViewDemo: TAction;
    acViewVisits: TAction;
    acViewPrimaryCare: TAction;
    acViewHealthEVet: TAction;
    acViewInsurance: TAction;
    acViewFlags: TAction;
    acViewRemote: TAction;
    acViewReminders: TAction;
    acViewPostings: TAction;
    acSignedAll: TAction;
    acSignedByAuthor: TAction;
    acSignedDate: TAction;
    acUncosigned: TAction;
    acUnsigned: TAction;
    acCustomView: TAction;
    acSearchWithin: TAction;
    acViewSaveDefault: TAction;
    acViewReturnDefault: TAction;
    acViewDetails: TAction;
    acIconLegend: TAction;
    acEditTemplate: TAction;
    acNewTemplate: TAction;
    acEditShared: TAction;
    acNewShared: TAction;
    acEditDialogFields: TAction;
    pnlLeft: TPanel;
    pnlDrawers: TPanel;
    frmDrawers: TfraDrawers;
    pnlNote: TPanel;
    memNote: TRichEdit;
    acChange: TAction;
    pnlLeftTop: TPanel;
    splDrawers: TSplitter;
    PnlRight: TPanel;
    splList: TSplitter;
    splVert: TSplitter;
    splHorz: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure fldAccessRemindersInstructionsQuery(Sender: TObject; var Text: string);
    procedure fldAccessRemindersStateQuery(Sender: TObject; var Text: string);
    procedure fldAccessTemplatesInstructionsQuery(Sender: TObject; var Text: string);
    procedure fldAccessTemplatesStateQuery(Sender: TObject; var Text: string);
    procedure mnuChartTabClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure tvNotesChange(Sender: TObject; Node: TTreeNode);
    procedure acNewNoteExecute(Sender: TObject);
    procedure memNewNoteChange(Sender: TObject);
//    procedure pnlFieldsResize(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure lvNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvNotesExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvNotesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvNotesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lvNotesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure memNewNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dlgFindTextFind(Sender: TObject);
    procedure popNoteMemoPopup(Sender: TObject);
    procedure popNoteMemoPreviewClick(Sender: TObject);
    procedure popNoteMemoCutClick(Sender: TObject);
    procedure popNoteMemoCopyClick(Sender: TObject);
    procedure popNoteMemoPasteClick(Sender: TObject);
    procedure popNoteMemoReformatClick(Sender: TObject);
    procedure popNoteMemoSaveContinueClick(Sender: TObject);
    procedure popNoteMemoFindClick(Sender: TObject);
    procedure popNoteMemoReplaceClick(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure popNoteMemoSpellClick(Sender: TObject);
    procedure popNoteMemoGrammarClick(Sender: TObject);
    procedure popNoteMemoInsTemplateClick(Sender: TObject);
    procedure popNoteMemoViewCsltClick(Sender: TObject);
    procedure acPCEExecute(Sender: TObject);
    procedure popNoteMemoTemplateClick(Sender: TObject);
    procedure acAddendumExecute(Sender: TObject);
    procedure acAddNewEntryIDNExecute(Sender: TObject);
    procedure acAttachIDNExecute(Sender: TObject);
    procedure acDetachIDNExecute(Sender: TObject);
    procedure acChangeTitleExecute(Sender: TObject);
    procedure acReloadBoilerExecute(Sender: TObject);
    procedure acAddSignListExecute(Sender: TObject);
    procedure acDeleteNoteExecute(Sender: TObject);
    procedure acEditNoteExecute(Sender: TObject);
    procedure acSaveNoSigExecute(Sender: TObject);
    procedure acSignExecute(Sender: TObject);
    procedure acIDAddlSignExecute(Sender: TObject);
    procedure acViewDemoUpdate(Sender: TObject);
    procedure acViewInfoExecute(Sender: TObject);
    procedure acViewVisitsUpdate(Sender: TObject);
    procedure acViewPrimaryCareUpdate(Sender: TObject);
    procedure acViewHealthEVetUpdate(Sender: TObject);
    procedure acViewInsuranceUpdate(Sender: TObject);
    procedure acViewFlagsUpdate(Sender: TObject);
    procedure acViewRemoteUpdate(Sender: TObject);
    procedure acViewRemindersUpdate(Sender: TObject);
    procedure acViewPostingsUpdate(Sender: TObject);
    procedure acSignedExecute(Sender: TObject);
    procedure acViewSaveDefaultExecute(Sender: TObject);
    procedure acViewReturnDefaultExecute(Sender: TObject);
    procedure acViewDetailsExecute(Sender: TObject);
    procedure acIconLegendExecute(Sender: TObject);
    procedure acEditTemplateExecute(Sender: TObject);
    procedure acNewTemplateExecute(Sender: TObject);
    procedure acEditSharedExecute(Sender: TObject);
    procedure acNewSharedExecute(Sender: TObject);
    procedure acEditDialogFieldsExecute(Sender: TObject);
    procedure popNoteListPopup(Sender: TObject);
    procedure popNoteListExpandSelectedClick(Sender: TObject);
    procedure popNoteListExpandAllClick(Sender: TObject);
    procedure popNoteListCollapseSelectedClick(Sender: TObject);
    procedure popNoteListCollapseAllClick(Sender: TObject);
    procedure acEditTemplateUpdate(Sender: TObject);
    procedure acNewTemplateUpdate(Sender: TObject);
    procedure acEditSharedUpdate(Sender: TObject);
    procedure acNewSharedUpdate(Sender: TObject);
    procedure acEditDialogFieldsUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure memNewNoteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure memNewNoteKeyPress(Sender: TObject; var Key: Char);
    procedure acNewNoteUpdate(Sender: TObject);
    procedure pnlDrawersResize(Sender: TObject);
    procedure acChangeExecute(Sender: TObject);
    procedure acChangeUpdate(Sender: TObject);
    procedure frmDrawersResize(Sender: TObject);
    procedure pnlWriteResize(Sender: TObject);
    procedure splHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure splDrawersCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
  private
    fExpandedDrawerHeight: integer;
    FEmptyNodeCount: Integer;
    FNavigatingTab: Boolean; // Currently using tab to navigate
    FEditingIndex: Integer; // index of note being currently edited
    FChanged: Boolean; // true if any text has changed in the note
    FEditCtrl: TCustomEdit;
    FSilent: Boolean;
    FCurrentContext: TTIUContext;
    FDefaultContext: TTIUContext;
    FOrderID: string;
    FImageFlag: TBitmap;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FDocList: TStringList;
    FConfirmed: Boolean;
    FLastNoteID: string;
    FNewIDChild: Boolean;
    FEditingNotePCEObj: Boolean;
    FDeleted: Boolean;
    FStarting: Boolean;
    FHasPersonalTemplates: Boolean;
    fReminderToggled: boolean;
    GlobalSearch: Boolean;
    GlobalSearchTerm: string;
    FormResizing: boolean;
    fPCEShowing: boolean;
    PatientToggled: boolean;
    DrawerConfiguration: TDrawerConfiguration;
    procedure DrawerButtonClicked(Sender: TObject);
    procedure ClearEditControls;
    procedure DoAutoSave(Suppress: Integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    procedure InsertAddendum;
    procedure InsertNewNote(IsIDChild: Boolean; AnIDParent: Integer);
    function LacksRequiredForCreate: Boolean;
    procedure LoadForEdit;
    function LockConsultRequest(AConsult: Integer): Boolean;
    function LockConsultRequestAndNote(AnIEN: Int64): Boolean;
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedNote(var Saved: Boolean);
    procedure SetSubjectVisible(ShouldShow: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    function StartNewEdit(NewNoteType: Integer): Boolean;
    procedure UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
    procedure ProcessNotifications;
    procedure SetViewContext(AContext: TTIUContext);
    function CanFinishReminder: Boolean;
    procedure DisplayPCE;
    procedure SetPCEParent();
    function VerifyNoteTitle: Boolean;
    // added for treeview
    procedure LoadNotes;
    procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure EnableDisableIDNotes;
    procedure ShowPCEButtons(Editing: Boolean);
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function SetNoteTreeLabel(AContext: TTIUContext): string;
    procedure UpdateNoteAuthor(DocInfo: string);
    procedure UpdatePersonalTemplates;
    procedure AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode = nil);
    procedure UpdateActMenu(DocID: String; ListComponent: TComponent );
    function GetReadVisible: boolean;
    procedure SetReadVisible(Value: boolean);
    procedure ReadToFront;
    function GetReminderToggled: boolean;
    procedure SetReminderToggled(const Value: boolean);
    function GetWriteShowing: boolean;
    procedure SetWriteShowing(const Value: boolean);
    procedure SetExpandedDrawerHeight(const Value: integer);
    function GetDrawers: TfraDrawers;
  protected
    property WriteShowing: boolean read GetWriteShowing write SetWriteShowing;
  public
    procedure EncounterLocationChanged(Sender: TObject);
    function ActiveEditOf(AnIEN: Int64; ARequest: Integer): Boolean;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure AssignRemForm;
    property OrderID: string read FOrderID;
    procedure LstNotesToPrint;
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetEditingIndex(const Value: Integer);
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    property ReadVisible: boolean read GetReadVisible write SetReadVisible;
    property ReminderToggled: boolean read GetReminderToggled write SetReminderToggled;
    property ExpandedDrawerHeight: integer read fExpandedDrawerHeight write SetExpandedDrawerHeight;
  published
    property Drawers: TfraDrawers read GetDrawers; // Keep Drawers published
  end;

const
  NoteSplitters = 'frmNotesSplitters';

var
  frmNotes: TfrmNotes;
  SearchTextStopFlag: Boolean; // Text Search CQ: HDS00002856

implementation


uses
  fFrame, fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem,
  fEncounterFrame, rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners,
  fNoteDR, fConsults, uSpell, fTIUView, fTemplateEditor, uReminders,
  fReminderDialog, uOrders, rConsults, fReminderTree, fNoteProps, fNotesBP,
  fTemplateFieldEditor, dShared, rTemplates, FIconLegend, fPCEEdit,
  fNoteIDParents, rSurgery, uSurgery, fTemplateDialog, DateUtils, uInit,
  uVA508CPRSCompatibility, VA508AccessibilityRouter, VAUtils, fFocusedControls,
  System.Types, rECS, TRPCB, uGlobalVar, System.UITypes;

const
  FormSpace = 3;
  NT_NEW_NOTE = -10; // Holder IEN for a new note
  NT_ADDENDUM = -20; // Holder IEN for a new addendum

  NT_ACT_NEW_NOTE = 2;
  NT_ACT_ADDENDUM = 3;
  NT_ACT_EDIT_NOTE = 4;
  NT_ACT_ID_ENTRY = 5;

  TX_NEED_VISIT = 'A visit is required before creating a new progress note.';
  TX_CREATE_ERR = 'Error Creating Note';
  TX_UPDATE_ERR = 'Error Updating Note';
  TX_NO_NOTE	= 'No progress note is currently being edited';
  TX_SAVE_NOTE  = 'Save Progress Note';
  TX_ADDEND_NO  = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this progress note?';
  TX_DEL_ERR = 'Unable to Delete Note';
  TX_SIGN = 'Sign Note';
  TX_COSIGN = 'Cosign Note';
  TX_SIGN_ERR = 'Unable to Sign Note';
  // TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
  // 'answered.  The Encounter form will now be opened.  Please answer all '+
  // 'service connected questions.';
  // TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NONOTE = 'No progress note is currently selected.';
  TX_NONOTE_CAP = 'No Note Selected';
  TX_NOPRT_NEW = 'This progress note may not be printed until it is saved';
  TX_NOPRT_NEW_CAP = 'Save Progress Note';
  TX_NO_ALERT = 'There is insufficient information to process this alert.' +
    CRLF + 'Either the alert has already been deleted, or it contained invalid data.'
    + CRLF + CRLF +
    'Click the NEXT button if you wish to continue processing more alerts.';
  TX_CAP_NO_ALERT = 'Unable to Process Alert';
  TX_ORDER_LOCKED =
    'This record is locked by an action underway on the Consults tab';
  TC_ORDER_LOCKED = 'Unable to access record';
  TX_NO_ORD_CHG =
    'The note is still associated with the previously selected request.' + CRLF
    + 'Finish the pending action on the consults tab, then try again.';
  TC_NO_ORD_CHG = 'Locked Consult Request';
  TX_NEW_SAVE1 = 'You are currently editing:' + CRLF + CRLF;
  TX_NEW_SAVE2 = CRLF + CRLF +
    'Do you wish to save this note and begin a new one?';
  TX_NEW_SAVE3 = CRLF + CRLF +
    'Do you wish to save this note and begin a new addendum?';
  TX_NEW_SAVE4 = CRLF + CRLF +
    'Do you wish to save this note and edit the one selected?';
  TX_NEW_SAVE5 = CRLF + CRLF +
    'Do you wish to save this note and begin a new Interdisciplinary entry?';
  TC_NEW_SAVE2 = 'Create New Note';
  TC_NEW_SAVE3 = 'Create New Addendum';
  TC_NEW_SAVE4 = 'Edit Different Note';
  TC_NEW_SAVE5 = 'Create New Interdisciplinary Entry';
  TX_EMPTY_NOTE = CRLF + CRLF +
    'This note contains no text and will not be saved.' + CRLF +
    'Do you wish to delete this note?';
  TC_EMPTY_NOTE = 'Empty Note';
  TX_EMPTY_NOTE1 = 'This note contains no text and can not be signed.';
  TC_NO_LOCK = 'Unable to Lock Note';
  TX_ABSAVE = 'It appears the session terminated abnormally when this' + CRLF +
    'note was last edited. Some text may not have been saved.' + CRLF + CRLF +
    'Do you wish to continue and sign the note?';
  TC_ABSAVE = 'Possible Missing Text';
  TX_NO_BOIL = 'There is no boilerplate text associated with this title.';
  TC_NO_BOIL = 'Load Boilerplate Text';
  TX_BLR_CLEAR = 'Do you want to clear the previously loaded boilerplate text?';
  TC_BLR_CLEAR = 'Clear Previous Boilerplate Text';
  TX_DETACH_CNF = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';
  TX_RETRACT_CAP = 'Retraction Notice';
  TX_RETRACT =
    'This document will now be RETRACTED.  As Such, it has been removed' + CRLF
    + ' from public view, and from typical Releases of Information,' + CRLF +
    ' but will remain indefinitely discoverable to HIMS.' + CRLF + CRLF;
  TX_AUTH_SIGNED =
    'Author has not signed, are you SURE you want to sign.' + CRLF;

  MIN_DRAWER_WIDTH = 150;
  MIN_PCE_HEIGHT = 70;

var
  uPCEShow, uPCEEdit: TPCEData;
  ViewContext: Integer;
  uTIUContext: TTIUContext;
  ColumnToSort: Integer;
  ColumnSortForward: boolean;
  uChanging: Boolean;
  uIDNotesActive: boolean;
  NoteTotal: string;
  NewNoteRunning: boolean;

{$R *.dfm}

{ TfrmNNotes }

function TfrmNotes.GetDrawers: TfraDrawers;
begin
  Result := frmDrawers;
end;

procedure TfrmNotes.SetReadVisible(Value: boolean);
begin
  pnlNote.Visible := Value;
 // splList.Visible := Value;
  WriteShowing := not Value;
end;

procedure TfrmNotes.SetReminderToggled(const Value: boolean);
begin
  fReminderToggled := Value;
  pnlReminder.Visible := Value;
  stTitle.Visible := not Value;
  splVert.Visible := not Value;
//  pnlNote.Visible := not Value;
  ReadVisible := not Value;
  WriteShowing := not Value;
//  pnlWrite.Visible := not Value;
//  splList.Visible := not Value;
  memPCEShow.Visible := not Value;
end;

function TfrmNotes.GetReadVisible;
begin
  Result := pnlNote.Visible;
end;

function TfrmNotes.GetReminderToggled: boolean;
begin
  Result := fReminderToggled;
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmNotes.mnuViewClick(Sender: TObject);
{ changes the list of notes available for viewing }
var
  AuthCtxt: TAuthorContext;
  SearchCtxt: TSearchContext; // Text Search CQ: HDS00002856
  DateRange: TNoteDateRange;
  Saved: Boolean;
  Style: TFontStyles;
  Format: CHARFORMAT2;
begin
  inherited;
  //clear the global search
  if GlobalSearch then begin
    memnote.SelStart := 0;
    memnote.SelLength := Length(TRichEdit(popNoteMemo.PopupComponent).Text);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := Memnote.Color;
    memnote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
    memnote.SelAttributes.Color := clWindowText;
    Style := [];
    memnote.SelAttributes.Style := Style;
  end;
  GlobalSearch := False;
  GlobalSearchTerm := '';
  // save note at EditingIndex?
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
  end;
  FLastNoteID := lstNotes.ItemID;
  mnuViewDetail.Checked := False;
  StatusText('Retrieving progress note list...');
  if (Sender is TMenuItem) or (Sender is TAction) then
    ViewContext := TMenuItem(Sender).Tag
  else if FCurrentContext.Status <> '' then
    ViewContext := NC_CUSTOM
  else
    ViewContext := NC_RECENT;
  case ViewContext of
  NC_RECENT:     begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   FCurrentContext.MaxDocs := ReturnMaxNotes;
                   LoadNotes;
                 end;
  NC_ALL:        begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'All Signed Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_UNSIGNED:   begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Unsigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_SEARCHTEXT: begin;
                   SearchTextStopFlag := False;
                   if (Sender is TMenuItem) then begin
                     SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]) );
                   end else if (Sender is TAction) then begin
                     SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TAction(Sender).Caption, '&', '', [rfReplaceAll]) );
                   end;
                   with SearchCtxt do if Changed then
                   begin
                     //FCurrentContext.Status := IntToStr(ViewContext);
                     frmSearchStop.Show;
                     stNotes.Caption := 'Search: '+ SearchString;
                     frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
                     FCurrentContext.SearchString := SearchString;
                     LoadNotes;
                     GlobalSearch := true;
                     GlobalSearchTerm := SearchString;
                     dlgFindText.FindText := GlobalSearchTerm;
                     dlgFindText.Options := [];
                     dmodShared.FindRichEditTextAll(Memnote, dlgFindText, clHighlight, [fsItalic, fsBold]);
                   end;
                   // Only do LoadNotes if something changed
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_UNCOSIGNED: begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Uncosigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_BY_AUTHOR:  begin
                   SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
                   with AuthCtxt do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     stNotes.Caption := AuthorName + ': Signed Notes';
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
                     stNotes.Caption := FormatFMDateTime('dddddd', FMBeginDate) + ' to ' +
                                         FormatFMDateTime('dddddd', FMEndDate) + ': Signed Notes';
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
                   if (Sender is TMenuItem) or (Sender is TAction) then
                     SelectTIUView(Font.Size, True, FCurrentContext, uTIUContext);
                   with uTIUContext do if Changed then
                   begin
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
  stNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    stNotes.Caption := stNotes.Caption + ', containing "' +
      FCurrentContext.SearchString + '"';
  If SearchTextStopFlag then begin
    stNotes.Caption := 'Search for "' + FCurrentContext.SearchString +
      '" was stopped!';
  end;
  // Clear the search text. We are done searching
  FCurrentContext.SearchString := '';
  frmSearchStop.Hide;
  // Text Search CQ: HDS00002856 --------------------
  stNotes.Caption := stNotes.Caption + ' (Total: ' + NoteTotal + ')';
  stNotes.hint := stNotes.Caption;
  // tvNotes.Caption := lblNotes.Caption;
  StatusText('');
end;

procedure TfrmNotes.fldAccessRemindersInstructionsQuery(Sender: TObject; var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odReminders then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmNotes.fldAccessRemindersStateQuery(Sender: TObject; var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odReminders then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmNotes.fldAccessTemplatesInstructionsQuery(Sender: TObject; var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odTemplates then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmNotes.fldAccessTemplatesStateQuery(Sender: TObject; var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odTemplates then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

  { Current tab order is based on this comment:

    Tab Order tricks.  Need to change
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

    fraDrawers.pnlTemplateButton                 (now btnTemplate)
    fraDrawers.pnlEncounterButton                (now btnEncounter)
    cmdNewNote
    cmdPCE
  }

procedure TfrmNotes.FormCreate(Sender: TObject);
begin
  inherited;
  NewNoteRunning := False;
  FormResizing := False;

  PatientToggled := False;
  PageID := CT_NOTES;
  EditingIndex := -1;
  FEditNote.LastCosigner := 0;
  FEditNote.LastCosignerName := '';
  FLastNoteID := '';
  Drawers.Init;
  Drawers.NewNoteButton := cmdNewNote;
  Drawers.RichEditControl := memNewNote;
  FImageFlag := TBitmap.Create;
  FDocList := TStringList.Create;
  splDrawers.Enabled := false;
  Drawers.SaveDrawerConfiguration(DrawerConfiguration);

  // Make sure the screen reader stops and reads these controls
  stTitle.TabStop := ScreenReaderActive;
  stNotes.TabStop := ScreenReaderActive;

  Drawers.OnDrawerButtonClick := DrawerButtonClicked;
  Drawers.OnUpdateVisualsEvent := DrawerButtonClicked;
  fExpandedDrawerHeight := 171; // gotten from largest default template drawer and 4x22 space buttons.
  Encounter.Notifier.NotifyWhenChanged(EncounterLocationChanged);
  fPCEShowing := False;
end;

procedure TfrmNotes.FormShow(Sender: TObject);
begin
  if PatientToggled then begin
    Drawers.LoadDrawerConfiguration(DrawerConfiguration);
    PatientToggled := False;
  end;
end;


procedure TfrmNotes.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

procedure TfrmNotes.acAddendumExecute(Sender: TObject);
{ make an addendum to an existing note }
var
  ActionSts: TActionRec;
  ANoteID: string;
begin
  inherited;
  if lstNotes.ItemIEN <= 0 then
    exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_ADDENDUM) then
    exit;
  // LoadNotes;
  with tvNotes do
    Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  if lstNotes.ItemIndex = EditingIndex then
  begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    exit;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;
  with lstNotes do
    if TitleForNote(lstNotes.ItemIEN) = TYP_ADDENDUM then
    begin
      InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
      exit;
    end;
  InsertAddendum;
end;

procedure TfrmNotes.acAddNewEntryIDNExecute(Sender: TObject);
const
  IS_ID_CHILD = True;
var
  AnIDParent: Integer;
  { switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  AnIDParent := lstNotes.ItemIEN;
  if not StartNewEdit(NT_ACT_ID_ENTRY) then
    exit;
  // LoadNotes;
  with tvNotes do
    Selected := FindPieceNode(IntToStr(AnIDParent), U, Items.GetFirstNode);
  // make sure a visit (time & location) is available before creating the note
  if Encounter.NeedVisit then
  begin
    UpdateVisit(Font.Size, DfltTIULocation);
    frmFrame.DisplayEncounterText;
  end;
  if Encounter.NeedVisit then
  begin
    InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
    exit;
  end;
  InsertNewNote(IS_ID_CHILD, AnIDParent);
end;

procedure TfrmNotes.acAddSignListExecute(Sender: TObject);
{ add the note to the Encounter object, see mnuActSignClick - copied }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN = 'SIGNATURE';
var
  ActionType, SignTitle: string;
  ActionSts: TActionRec;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then
    exit;
  if lstNotes.ItemIndex = EditingIndex then
    exit; // already in signature list
  if not NoteHasText(lstNotes.ItemIEN) then
  begin
    InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
    exit;
  end;
  if not LastSaveClean(lstNotes.ItemIEN) and
    (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING)
    <> IDYES) then
    exit;
  if CosignDocument(lstNotes.ItemIEN) then
  begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end
  else
  begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;
  LockConsultRequestAndNote(lstNotes.ItemIEN);
  with lstNotes do
    Changes.Add(CH_DOC, ItemID, GetTitleText(ItemIndex), '', CH_SIGN_YES);
end;

procedure TfrmNotes.acAttachIDNExecute(Sender: TObject);
var
  AChildNode: TORTreeNode;
  AParentID: string;
  SavedDocID: string;
  Saved: Boolean;
begin
  inherited;
  if not uIDNotesActive then
    exit;
  if lstNotes.ItemIEN = 0 then
    exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    LoadNotes;
    with tvNotes do
      Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvNotes.Selected = nil then
    exit;
  AChildNode := TORTreeNode(tvNotes.Selected);
  AParentID := SelectParentNodeFromList(tvNotes);
  if AParentID = '' then
    exit;
  with tvNotes do
    Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
  DoAttachIDChild(AChildNode, TORTreeNode(tvNotes.Selected));
end;

procedure TfrmNotes.acChangeExecute(Sender: TObject);
begin
  inherited;
  cmdChangeClick(Sender);
end;

procedure TfrmNotes.acChangeTitleExecute(Sender: TObject);
begin
  if (EditingIndex < 0) or (lstNotes.ItemIndex <> EditingIndex) then
    exit;
  cmdChangeClick(Sender);
end;

procedure TfrmNotes.acChangeUpdate(Sender: TObject);
begin
  inherited;
  acChange.Visible := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmNotes.acDeleteNoteExecute(Sender: TObject);
var
  DeleteSts, ActionSts: TActionRec;
  SaveConsult, SavedDocIEN: Integer;
  ReasonForDelete, AVisitStr, SavedDocID, X: string;
  Saved: Boolean;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then
    exit;
  if assigned(frmRemDlg) then
  begin
    frmRemDlg.btnCancelClick(Self);
    if Assigned(frmRemDlg) then
      exit;
  end;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'DELETE RECORD');
  if ShowMsgOn(not ActionSts.Success, ActionSts.Reason, TX_IN_AUTH) then
    exit;
  ReasonForDelete := SelectDeleteReason(lstNotes.ItemIEN);
  if ReasonForDelete = DR_CANCEL then
    exit;
  // suppress prompt for deletion when called from SaveEditedNote (Sender = Self)
  if (Sender <> Self) and
    (InfoBox(MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]) +
    TX_DEL_OK, TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <>
    IDYES) then
    exit;
  // do the appropriate locking
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  // retraction notification message
  if JustifyDocumentDelete(lstNotes.ItemIEN) then
    InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocID := lstNotes.ItemID;
  SavedDocIEN := lstNotes.ItemIEN;
  if (EditingIndex > -1) and (not FConfirmed) and
    (lstNotes.ItemIndex <> EditingIndex) and (memNewNote.GetTextLen > 0) then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
  end;
  EditingIndex := -1;
  FConfirmed := FALSE;
  // remove the note
  DeleteSts.Success := True;
  X := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(X, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN) then
    DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_DOC, SavedDocID) then
    UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_DOC, SavedDocID);
  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);
  // note has been deleted, so 1st param = 0
  // reset the display now that the note is gone
  if DeleteSts.Success then begin
    DeletePCE(AVisitStr);
    // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    LoadNotes;
//    pnlWrite.Visible := FALSE;
    ReadVisible := True;
    UpdateReminderFinish;
    ShowPCEControls(FALSE);
    Drawers.DisplayDrawers(True, Drawers.ActiveDrawer, [odTemplates], [odTemplates]);
    ShowPCEButtons(FALSE);
  end else { if DeleteSts }
    InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
end;

procedure TfrmNotes.acDetachIDNExecute(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: boolean;
  SavedDocID: string;
begin
  if lstNotes.ItemIEN = 0 then
    exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U, tvNotes.Items.GetFirstNode);
  end;
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot) then begin
    WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
    WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
    InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
    exit;
  end;
  if (InfoBox('DETACH:   ' + tvNotes.Selected.Text + CRLF + CRLF + '  FROM:   '
      + tvNotes.Selected.Parent.Text + CRLF + CRLF + 'Are you sure?',
      TX_DETACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then
    exit;
  DocID := PDocTreeObject(tvNotes.Selected.Data)^.DocID;
  SavedDocID := PDocTreeObject(tvNotes.Selected.Parent.Data)^.DocID;
  if DetachEntryFromParent(DocID, WhyNot) then begin
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U, tvNotes.Items.GetFirstNode);
    if tvNotes.Selected <> nil then
      tvNotes.Selected.Expand(FALSE);
  end else begin
    WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
    WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
    InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
  end;
end;

procedure TfrmNotes.acEditDialogFieldsExecute(Sender: TObject);
begin
  EditDialogFields;
end;

procedure TfrmNotes.acEditDialogFieldsUpdate(Sender: TObject);
begin
  acEditDialogFields.Enabled := CanEditTemplateFields;
end;

procedure TfrmNotes.acEditNoteExecute(Sender: TObject);
{ load the selected progress note for editing }
var
  ActionSts: TActionRec;
  ANoteID: string;
begin
  inherited;
  if lstNotes.ItemIndex = EditingIndex then
    exit;
  ANoteID := lstNotes.ItemID;
  if not StartNewEdit(NT_ACT_EDIT_NOTE) then
    exit;
  // LoadNotes;
  with tvNotes do
    Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;
  LoadForEdit;
end;

procedure TfrmNotes.acEditSharedExecute(Sender: TObject);
begin
  EditTemplates(Self, FALSE, '', True);
end;

procedure TfrmNotes.acEditSharedUpdate(Sender: TObject);
begin
  acEditShared.Enabled := Drawers.CanEditShared;
end;

procedure TfrmNotes.acEditTemplateExecute(Sender: TObject);
begin
  EditTemplates(Self);
end;

procedure TfrmNotes.acEditTemplateUpdate(Sender: TObject);
begin
  acEditTemplate.Enabled := Drawers.CanEditTemplates;
end;

procedure TfrmNotes.acIconLegendExecute(Sender: TObject);
begin
  ShowIconLegend(ilNotes);
end;

procedure TfrmNotes.acIDAddlSignExecute(Sender: TObject);
var
  Exclusions: TStrings;
  Saved, CanChgCos, ActSucc: Boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  SigAction: Integer;
  SavedDocID: string;
  ARefDate: TFMDateTime;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then
    exit;
  SavedDocID := lstNotes.ItemID;
  if lstNotes.ItemIndex = EditingIndex then begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U, tvNotes.Items.GetFirstNode);
  end;
  CanChgCos := CanChangeCosigner(lstNotes.ItemIEN);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'IDENTIFY SIGNERS');
  ActSucc := ActionSts.Success;
  if CanChgCos and (not ActSucc) then begin
    if InfoBox(ActionSts.Reason + CRLF + CRLF +
      'Would you like to change the cosigner?', TX_IN_AUTH,
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES then
      SigAction := SG_COSIGNER
    else
      exit;
  end else if ActSucc and (not CanChgCos) then
    SigAction := SG_ADDITIONAL
  else if CanChgCos and ActSucc then
    SigAction := SG_BOTH
  else begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;

  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  Exclusions := GetCurrentSigners(lstNotes.ItemIEN);
  ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  SelectAdditionalSigners(Font.Size, lstNotes.ItemIEN, SigAction, Exclusions,
    SignerList, CT_NOTES, ARefDate);
  case SigAction of
    SG_ADDITIONAL:
      if SignerList.Changed and (SignerList.Signers <> nil) and (SignerList.Signers.Count > 0) then
        UpdateAdditionalSigners(lstNotes.ItemIEN, SignerList.Signers);
    SG_COSIGNER:
      if SignerList.Changed then
        ChangeCosigner(lstNotes.ItemIEN, SignerList.Cosigner);
    SG_BOTH:
      if SignerList.Changed then
      begin
        if (SignerList.Signers <> nil) and (SignerList.Signers.Count > 0) then
          UpdateAdditionalSigners(lstNotes.ItemIEN, SignerList.Signers);
        ChangeCosigner(lstNotes.ItemIEN, SignerList.Cosigner);
      end;
  end;
  lstNotesClick(Self);
  UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
end;

procedure TfrmNotes.acNewNoteExecute(Sender: TObject);
const
  IS_ID_CHILD = FALSE;
  { switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  if not NewNoteRunning then begin
    NewNoteRunning := True;
    try
      if StartNewEdit(NT_ACT_NEW_NOTE) then begin
        // make sure a visit (time & location) is available before creating the note
        if Encounter.NeedVisit then
        begin
          UpdateVisit(Font.Size, DfltTIULocation);
          frmFrame.DisplayEncounterText;
        end;
        if Encounter.NeedVisit then
        begin
          InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
          ShowPCEButtons(FALSE);
        end else begin
          InsertNewNote(IS_ID_CHILD, 0);
        end;
      end;
    finally
      NewNoteRunning := False;
    end;
  end;
end;

procedure TfrmNotes.acNewNoteUpdate(Sender: TObject);
begin
  acNewNote.Enabled := (not pnlWrite.Visible) and (frmConsults.EditingIndex < 0);
end;

procedure TfrmNotes.acNewSharedExecute(Sender: TObject);
begin
  EditTemplates(Self, True, '', True);
end;

procedure TfrmNotes.acNewSharedUpdate(Sender: TObject);
begin
  acNewShared.Enabled := Drawers.CanEditShared;
end;

procedure TfrmNotes.acNewTemplateExecute(Sender: TObject);
begin
  EditTemplates(Self, True);
end;

procedure TfrmNotes.acNewTemplateUpdate(Sender: TObject);
begin
  acNewTemplate.Enabled := Drawers.CanEditTemplates;
end;

procedure TfrmNotes.acPCEExecute(Sender: TObject);
var
  Refresh: Boolean;
  ActionSts: TActionRec;
  AnIEN: Integer;
  PCEObj, tmpPCEEdit: TPCEData;

  procedure UpdateEncounterInfo;
  begin
    if not FEditingNotePCEObj then begin
      PCEObj := nil;
      AnIEN := lstNotes.ItemIEN;
      if (AnIEN <> 0) and (memNote.Lines.Count > 0) then begin
        ActOnDocument(ActionSts, AnIEN, 'VIEW');
        if ActionSts.Success then begin
          uPCEShow.CopyPCEData(uPCEEdit);
          PCEObj := uPCEEdit;
        end;
      end;
      Refresh := EditPCEData(PCEObj);
    end else begin
      UpdatePCE(uPCEEdit);
      Refresh := True;
    end;
    if Refresh and (not frmFrame.Closing) then
      DisplayPCE;
  end;

begin
  inherited;
  cmdPCE.Enabled := FALSE;
  try
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
    end else    // no other note being edited, so just proceed as before.
      UpdateEncounterInfo;
  finally
    if cmdPCE <> nil then
      cmdPCE.Enabled := True;
  end;
end;

procedure TfrmNotes.acViewPostingsUpdate(Sender: TObject);
begin
  acViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmNotes.acViewPrimaryCareUpdate(Sender: TObject);
begin
  acViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
end;

procedure TfrmNotes.acViewRemindersUpdate(Sender: TObject);
begin
  acViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
end;

procedure TfrmNotes.acViewRemoteUpdate(Sender: TObject);
begin
  acViewRemote.Enabled := frmFrame.lblCirn.Enabled;
end;

procedure TfrmNotes.acViewReturnDefaultExecute(Sender: TObject);
begin
  SetViewContext(FDefaultContext);
end;

procedure TfrmNotes.acViewSaveDefaultExecute(Sender: TObject);
const
  TX_NO_MAX = 'You have not specified a maximum number of notes to be returned.'
    + CRLF + 'If you save this preference, the result will be that ALL notes for every'
    + CRLF + 'patient will be saved as your default view.' + CRLF + CRLF +
    'For patients with large numbers of notes, this could result in some lengthy'
    + CRLF + 'delays in loading the list of notes.' + CRLF + CRLF +
    'Are you sure you mean to do this?';
  TX_REPLACE = 'Replace current defaults?';
begin
  inherited;
  if FCurrentContext.MaxDocs = 0 then
    if InfoBox(TX_NO_MAX, 'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
    begin
      mnuViewClick(mnuViewCustom);
      exit;
    end;
  if InfoBox(TX_REPLACE, 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES
  then
  begin
    SaveCurrentTIUContext(FCurrentContext);
    FDefaultContext := FCurrentContext;
    // lblNotes.Caption := 'Default List';
  end;
end;

procedure TfrmNotes.acReloadBoilerExecute(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
    memNewNote.Text := BoilerText.Text;
    SpeakStrings(BoilerText);
    UpdateNoteAuthor(DocInfo);
    FChanged := False;
  end;

begin
  inherited;
  if (EditingIndex < 0) or (lstNotes.ItemIndex <> EditingIndex) then Exit;
  BoilerText := TStringList.Create;
  try
    NoteEmpty := memNewNote.Text = '';
    LoadBoilerPlate(BoilerText, FEditNote.Title);
    if (BoilerText.Text <> '') or
       assigned(GetLinkedTemplate(IntToStr(FEditNote.Title), ltTitle)) then begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      if NoteEmpty then
        AssignBoilerText
      else begin
        case QueryBoilerPlate(BoilerText) of
        0:  { do nothing } ;                         // ignore
        1: begin
             ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
             memNewNote.Lines.AddStrings(BoilerText);
             SpeakStrings(BoilerText);
             UpdateNoteAuthor(DocInfo);
           end;
        2: AssignBoilerText;                         // replace
        end;
      end;
    end else begin
      if Sender = mnuActLoadBoiler then
        InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
      else begin
        if not NoteEmpty then
          // if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
          if (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_ICONQUESTION or MB_YESNO or
            MB_DEFBUTTON2) = ID_YES) then
            memNewNote.Lines.Clear;
      end;
    end; { if BoilerText.Text <> '' }
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmNotes.acSaveNoSigExecute(Sender: TObject);
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
    // if Saved then
    begin
      LoadNotes;
      with tvNotes do
        Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    end;
  end
  else
    InfoBox(TX_NO_NOTE, TX_SAVE_NOTE, MB_OK or MB_ICONWARNING);
end;

procedure TfrmNotes.acSignExecute(Sender: TObject);
{ sign the currently selected note, save first if necessary }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN = 'SIGNATURE';
var
  Saved, NoteUnlocked: Boolean;
  ActionType, ESCode, SignTitle: string;
  ActionSts, SignSts: TActionRec;
  OK: Boolean;
  SavedDocID, tmpItem: string;
  EditingID: string; // v22.12 - RV
  tmpNode: TTreeNode;
begin
  inherited;
  SavedDocID := lstNotes.ItemID; // v22.12 - RV
  FLastNoteID := SavedDocID; // v22.12 - RV
  if lstNotes.ItemIndex = EditingIndex then  begin // v22.12 - RV
    SaveCurrentNote(Saved); // v22.12 - RV
    if (not Saved) or FDeleted then
      exit; // v22.12 - RV
  end else if EditingIndex > -1 then begin // v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex]; // v22.12 - RV
    EditingID := Piece(tmpItem, U, 1); // v22.12 - RV
  end; // v22.12 - RV
  if not NoteHasText(lstNotes.ItemIEN) then begin
    InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
    exit;
  end;
  if not LastSaveClean(lstNotes.ItemIEN) and
     (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) <> IDYES) then
    exit;
  if CosignDocument(lstNotes.ItemIEN) then begin
    SignTitle := TX_COSIGN;
    ActionType := SIG_COSIGN;
  end else begin
    SignTitle := TX_SIGN;
    ActionType := SIG_SIGN;
  end;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  // no exits after things are locked
  NoteUnlocked := FALSE;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if ActionSts.Success then begin
    OK := IsOK2Sign(uPCEShow, lstNotes.ItemIEN);
    if frmFrame.Closing then
      exit;
    if (uPCEShow.Updated) then begin
      uPCEShow.CopyPCEData(uPCEEdit);
      uPCEShow.Updated := FALSE;
      lstNotesClick(Self);
    end;
    if not AuthorSignedDocument(lstNotes.ItemIEN) then begin
      if (InfoBox(TX_AUTH_SIGNED + GetTitleText(lstNotes.ItemIndex), TX_SIGN,
        MB_YESNO) = ID_NO) then
        exit;
    end;
    if (OK) then begin
      SignatureForItem(Font.Size, MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
        Changes.Remove(CH_DOC, lstNotes.ItemID);
        // this will unlock if in Changes
        if SignSts.Success then begin
          if frmConsults.EditingIndex = -1 then
           SendMessage(frmConsults.Handle, UM_NEWORDER, ORDER_SIGN, 0); { *REV* }
          lstNotesClick(Self);
        end else
          InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end { if Length(ESCode) } else
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
    end;
  end else
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not NoteUnlocked then
    UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
  LoadNotes; // v22.12 - RV
  if (EditingID <> '') then begin
    lstNotes.Items.Insert(0, tmpItem);
    tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode,
      'Note being edited',
      MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
    TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
    tmpNode.ImageIndex := IMG_TOP_LEVEL;
    tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode,
      MakeNoteDisplayText(tmpItem), MakeNoteTreeObject(tmpItem));
    TORTreeNode(tmpNode).StringData := tmpItem;
    SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext,
      CT_NOTES);
    EditingIndex := lstNotes.SelectByID(EditingID); // v22.12 - RV
  end;
  tvNotes.Selected := tvNotes.FindPieceNode(FLastNoteID, U, tvNotes.Items.GetFirstNode);
  if tvNotes.Selected <> nil then
    tvNotesChange(Self, tvNotes.Selected)
  else
    tvNotes.Selected := tvNotes.Items[0]; // first Node in treeview
end;



procedure TfrmNotes.AddTemplateNode(const tmpl: TTemplate; const Owner: TTreeNode);
begin
  dmodShared.AddTemplateNode(Drawers.tvTemplates, FEmptyNodeCount, tmpl, FALSE, Owner);
end;

{ TPage common methods --------------------------------------------------------------------- }
function TfrmNotes.AllowContextChange(var WhyNot: string): Boolean;
begin
  dlgFindText.CloseDialog;
  Result := inherited AllowContextChange(WhyNot); // sets result = true
  if Assigned(frmTemplateDialog) then begin
    if Screen.ActiveForm = frmTemplateDialog then begin
      // if (fsModal in frmTemplateDialog.FormState) then
      case BOOLCHAR[frmFrame.CCOWContextChanging] of
        '1': begin
               WhyNot := 'A template in progress will be aborted.  ';
               Result := FALSE;
             end;
        '0': begin
               if WhyNot = 'COMMIT' then begin
                 FSilent := True;
                 frmTemplateDialog.Silent := True;
                 frmTemplateDialog.ModalResult := mrCancel;
               end;
             end;
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
  if EditingIndex <> -1 then begin
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
  end;
  if assigned(frmEncounterFrame) then begin
    if Screen.ActiveForm = frmEncounterFrame then begin
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
    with tvNotes do
      Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
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
  KillDocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  tvNotes.Items.EndUpdate;
  lvNotes.Items.Clear;
  uChanging := False;
  lstNotes.Clear;
  memNote.Clear;
  memPCEShow.Clear;
  uPCEShow.Clear;
  uPCEEdit.Clear;
  Drawers.SaveDrawerConfiguration(DrawerConfiguration);
  PatientToggled := True;
  Drawers.ResetTemplates;
  NoteTotal := sCallV('ORCNOTE GET TOTAL', [Patient.DFN]);
end;

procedure TfrmNotes.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
 SendMessage(frmNotes.Handle, WM_SETREDRAW, 0, 0);
  try
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_NOTES;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  frmFrame.mnuFilePrintSelectedItems.Enabled := True;
  if InitPage then begin
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
  if InitPatient and not(CallingContext = CC_NOTIFICATION) then begin
    SetViewContext(FDefaultContext);
  end;
  case CallingContext of
    CC_INIT_PATIENT: if not InitPatient then begin
                       SetViewContext(FDefaultContext);
                     end;
    CC_NOTIFICATION: ProcessNotifications;
  end;
  finally
    SendMessage(frmNotes.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(frmNotes.Handle, nil, 0, RDW_ERASE or RDW_FRAME or
      RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

procedure TfrmNotes.RequestPrint;
var
  Saved: Boolean;
begin
  with lstNotes do
  begin
    if ItemIndex = EditingIndex then
    // if ItemIEN < 0 then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
    if ItemIEN > 0 then
      PrintNote(ItemIEN, MakeNoteDisplayText(Items[ItemIndex]))
    else begin
      if ItemIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
      if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

{ for printing multiple notes }
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
        NoteIEN := ItemIEN;
        // StrToInt64def(Piece(TStringList(Items.Objects[i])[0],U,1),0);
        if NoteIEN > 0 then
          PrintNote(NoteIEN, DisplayText[i], True)
        else
        begin
          if NoteIEN = 0 then
            InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
          if NoteIEN < 0 then
            InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
        end;
      end; { if selected }
    end; { for }
  end; { with }
end;

procedure TfrmNotes.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  SetEqualTabStops(memNewNote);
  memNote.Font.Size := NewFontSize;
  cmdChange.Font.Size := NewFontSize;
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
  // lblNotes.Caption := '';   CQ20356
  SearchTextStopFlag := FALSE;
  if memNewNote <> nil then
    memNewNote.Clear; // CQ7012 Added test for nil
  timAutoSave.Enabled := FALSE;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
end;

procedure TfrmNotes.ShowPCEControls(ShouldShow: Boolean);
begin
  fPCEShowing := ShouldShow;
end;

procedure TfrmNotes.splHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
begin
  if pnlWrite.Visible then
     if NewSize > frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - splHorz.Width then
     begin
        NewSize := frmNotes.ClientWidth - memNewNote.Constraints.MinWidth - splHorz.Width - 1;
        accept := false;
     end;
  inherited;
end;

procedure TfrmNotes.splDrawersCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
var
 Min_NoteList_Height: integer;
begin
  Min_NoteList_Height := tvNotes.Constraints.MinHeight + splDrawers.Height + 3;
  if pnlLeftTop.Height - NewSize < Min_NoteList_Height then
  begin
    pnlDrawers.Height := pnlDrawers.Height - (Min_NoteList_Height - tvNotes.Height);
    accept := false;
 end;
  inherited;
end;

procedure  TfrmNotes.SetPCEParent();
begin
 memPCEShow.Visible := fPCEShowing;
 SplVert.Visible :=  fPCEShowing;
 if pnlNote.Visible then
 begin
  memPCEShow.Parent := pnlNote;
  SplVert.Parent := pnlNote;
  SplVert.Top := memPCEShow.Top - 1;
 end else begin
  memPCEShow.Parent := pnlWrite;
  SplVert.Parent := pnlWrite;
  SplVert.Top := memPCEShow.Top - 1;
 end;
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
  with lstNotes do
    if ItemIndex = EditingIndex then begin
      with uPCEEdit do begin
        AddStrData(memPCEShow.Lines);
        NoPCE := (memPCEShow.Lines.Count = 0);
        VitalStr := TStringList.create;
        try
          GetVitalsFromDate(VitalStr, uPCEEdit);
          AddVitalData(VitalStr, memPCEShow.Lines);
        finally
          VitalStr.free;
        end;
        ShowPCEButtons(True);
        ShowPCEControls(cmdPCE.Enabled or (memPCEShow.Lines.Count > 0));
        if (NoPCE and memPCEShow.Visible) then
          memPCEShow.Lines.Insert(0, TX_NOPCE);
        memPCEShow.SelStart := 0;

        if (InteractiveRemindersActive) then begin
          if (GetReminderStatus = rsNone) then
            EnableList := [odTemplates]
          else if FutureEncounter(uPCEEdit) and (not SpansIntlDateLine) then begin
            EnableList := [odTemplates];
            ShowList := [odTemplates];
          end else begin
            EnableList := [odTemplates, odReminders];
            ShowList := [odTemplates, odReminders];
          end;
        end else begin
          EnableList := [odTemplates];
          ShowList := [odTemplates];
        end;
        Drawers.DisplayDrawers(True, Drawers.ActiveDrawer, EnableList, ShowList);
      end;
    end else begin
      ShowPCEButtons(FALSE);
      Drawers.DisplayDrawers(True, Drawers.ActiveDrawer, [odTemplates], [odTemplates]);
      AnIEN := lstNotes.ItemIEN;
      ActOnDocument(ActionSts, AnIEN, 'VIEW');
      if ActionSts.Success then begin
        StatusText('Retrieving encounter information...');
        with uPCEShow do begin
          NoteDateTime := MakeFMDateTime
            (Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
          PCEForNote(AnIEN, uPCEEdit);
          AddStrData(memPCEShow.Lines);
          NoPCE := (memPCEShow.Lines.Count = 0);
          VitalStr := TStringList.create;
          try
            GetVitalsFromNote(VitalStr, uPCEShow, AnIEN);
            AddVitalData(VitalStr, memPCEShow.Lines);
          finally
            VitalStr.free;
          end;
          ShowPCEControls(memPCEShow.Lines.Count > 0);
          if (NoPCE and memPCEShow.Visible) then
            memPCEShow.Lines.Insert(0, TX_NOPCE);
          memPCEShow.SelStart := 0;
        end;
        StatusText('');
      end else
        ShowPCEControls(FALSE);
    end; { if ItemIndex }
  mnuEncounter.Enabled := cmdPCE.Visible;
  SetPCEParent;
end;

{ supporting calls for writing notes }

function TfrmNotes.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
begin
  if (lstNotes.Items.Count > AnIndex) then begin
    Result := FormatFMDateTime('dddddd',
      MakeFMDateTime(Piece(lstNotes.Items[AnIndex], U, 3))) + '  ' +
      Piece(lstNotes.Items[AnIndex], U, 2) + ', ' + Piece(lstNotes.Items[AnIndex], U, 6) + ', ' +
      Piece(Piece(lstNotes.Items[AnIndex], U, 5), ';', 2);
  end else begin
    Result := '';
  end;
end;

function TfrmNotes.GetWriteShowing: boolean;
begin
  Result := pnlWrite.Visible;
end;

function TfrmNotes.LacksRequiredForCreate: Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
begin
  Result := FALSE;
  with FEditNote do
  begin
    if Title <= 0 then
      Result := True;
    if Author <= 0 then
      Result := True;
    if DateTime <= 0 then
      Result := True;
    if IsConsultTitle(Title) and (PkgIEN = 0) then
      Result := True;
    if IsSurgeryTitle(Title) and (PkgIEN = 0) then
      Result := True;
    if IsPRFTitle(Title) and (PRF_IEN = 0) and (not DocType = TYP_ADDENDUM) then
      Result := True;
    if (DocType = TYP_ADDENDUM) then
    begin
      if AskCosignerForDocument(Addend, Author, DateTime) and (Cosigner <= 0)
      then
        Result := True;
    end
    else
    begin
      if Title > 0 then
        CurTitle := Title
      else
        CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Author, DateTime) and (Cosigner <= 0)
      then
        Result := True;
    end;
  end;
end;

function TfrmNotes.VerifyNoteTitle: Boolean;
const
  VNT_UNKNOWN = 0;
  VNT_NO = 1;
  VNT_YES = 2;
var
  AParam: string;
begin
  if FVerifyNoteTitle = VNT_UNKNOWN then
  begin
    AParam := GetUserParam('ORWOR VERIFY NOTE TITLE');
    if AParam = '1' then
      FVerifyNoteTitle := VNT_YES
    else
      FVerifyNoteTitle := VNT_NO;
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
    pnlFields.Height := txtSubject.Top + txtSubject.Height + 6;
  end
  else
  begin
    lblSubject.Visible := FALSE;
    txtSubject.Visible := FALSE;
    pnlFields.Height := lblVisit.Top + lblVisit.Height + 6;
  end;
end;

{ consult request and note locking }

function TfrmNotes.LockConsultRequest(AConsult: Integer): Boolean;
{ returns true if consult successfully locked }
begin
  // *** I'm not sure about the FOrderID field - if the user is editing one note and
  // deletes another, FOrderID will be for editing note, then delete note, then null
  Result := True;
  FOrderID := GetConsultOrderIEN(AConsult);
  if (FOrderID <> '') and (FOrderID = frmConsults.OrderID) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := FALSE;
    exit;
  end;
  if (FOrderID <> '') then
    if not OrderCanBeLocked(FOrderID) then
      Result := FALSE;
  if not Result then
    FOrderID := '';
end;

function TfrmNotes.LockConsultRequestAndNote(AnIEN: Int64): Boolean;
{ returns true if note and associated request successfully locked }
var
  AConsult: Integer;
  LockMsg, X: string;
begin
  Result := True;
  AConsult := 0;
  if frmConsults.ActiveEditOf(AnIEN) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := FALSE;
    exit;
  end;
  if Changes.Exist(CH_DOC, IntToStr(AnIEN)) then
    exit; // already locked
  // try to lock the consult request first, if there is one
  if IsConsultTitle(TitleForNote(AnIEN)) then
  begin
    X := GetPackageRefForNote(lstNotes.ItemIEN);
    AConsult := StrToIntDef(Piece(X, ';', 1), 0);
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
begin
  if AConsult = 0 then AConsult := GetConsultIENForNote(ANote);
  if AConsult > 0 then begin
    FOrderID := GetConsultOrderIEN(AConsult);
    UnlockOrderIfAble(FOrderID);
    FOrderID := '';
  end;
end;

function TfrmNotes.ActiveEditOf(AnIEN: Int64; ARequest: integer): Boolean;
begin
  Result := False;
  if EditingIndex < 0 then Exit;
  if lstNotes.GetIEN(EditingIndex) = AnIEN then
  begin
    Result := True;
    exit;
  end;
  with FEditNote do
    if (PkgIEN = ARequest) and (PkgPtr = PKG_CONSULTS) then
      Result := True;
end;

procedure TfrmNotes.acViewInfoExecute(Sender: TObject);
begin
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmNotes.acViewInsuranceUpdate(Sender: TObject);
begin
  acViewInsurance.Enabled := not(Copy(frmFrame.laVAA2.hint, 1, 2) = 'No');
end;

procedure TfrmNotes.acViewVisitsUpdate(Sender: TObject);
begin
  acViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
end;

procedure TfrmNotes.acSignedExecute(Sender: TObject);             
{ changes the list of notes available for viewing }
var
  AuthCtxt: TAuthorContext;
  SearchCtxt: TSearchContext; // Text Search CQ: HDS00002856
  DateRange: TNoteDateRange;
  Saved: Boolean;
  Style: TFontStyles;
  Format: CHARFORMAT2;
begin
  inherited;
  //clear the global search
  If GlobalSearch then begin
    memnote.SelStart := 0;
    memnote.SelLength := Length(TRichEdit(popNoteMemo.PopupComponent).Text);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := Memnote.Color;
    memnote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
    memnote.SelAttributes.Color := clWindowText;
    Style := [];
    memnote.SelAttributes.Style := Style;
  end;
  GlobalSearch := False;
  GlobalSearchTerm := '';
  // save note at EditingIndex?
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
  end;
  FLastNoteID := lstNotes.ItemID;
  mnuViewDetail.Checked := False;
  StatusText('Retrieving progress note list...');

  if (Sender is TAction) then begin
    ViewContext := TAction(Sender).Tag;
  end else if (Sender is TMenuItem) then begin
    ViewContext := TMenuItem(Sender).Tag;
  end else if FCurrentContext.Status <> '' then begin
    ViewContext := NC_CUSTOM;
  end else begin
    ViewContext := NC_RECENT;
  end;

  case ViewContext of
  NC_RECENT:     begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   FCurrentContext.MaxDocs := ReturnMaxNotes;
                   LoadNotes;
                 end;
  NC_ALL:        begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'All Signed Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_UNSIGNED:   begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Unsigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_SEARCHTEXT: begin;
                   SearchTextStopFlag := False;
                   if (Sender is TMenuItem) then begin
                     SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]) );
                   end else if (Sender is TAction) then begin
                     SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt, StringReplace(TAction(Sender).Caption, '&', '', [rfReplaceAll]) );
                   end;
                   with SearchCtxt do if Changed then
                   begin
                     //FCurrentContext.Status := IntToStr(ViewContext);
                     frmSearchStop.Show;
                     stNotes.Caption := 'Search: '+ SearchString;
                     frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
                     FCurrentContext.SearchString := SearchString;
                     LoadNotes;
                     GlobalSearch := true;
                     GlobalSearchTerm := SearchString;
                     dlgFindText.FindText := GlobalSearchTerm;
                     dlgFindText.Options := [];
                     dmodShared.FindRichEditTextAll(Memnote, dlgFindText, clHighlight, [fsItalic, fsBold]);
                   end;
                   // Only do LoadNotes if something changed
                 end;
  // Text Search CQ: HDS00002856 --------------------
  NC_UNCOSIGNED: begin
                   FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                   stNotes.Caption := 'Uncosigned Notes';
                   FCurrentContext.Status := IntToStr(ViewContext);
                   LoadNotes;
                 end;
  NC_BY_AUTHOR:  begin
                   SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
                   with AuthCtxt do if Changed then
                   begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     stNotes.Caption := AuthorName + ': Signed Notes';
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
                     stNotes.Caption := FormatFMDateTime('dddddd', FMBeginDate) + ' to ' +
                                         FormatFMDateTime('dddddd', FMEndDate) + ': Signed Notes';
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
                   if (Sender is TMenuItem) or (Sender is TAction) then
                     begin
                       SelectTIUView(Font.Size, True, FCurrentContext, uTIUContext);
                       //lblNotes.Caption := 'Custom List';
                     end;
                   with uTIUContext do if Changed then
                   begin
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
  stNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    stNotes.Caption := stNotes.Caption + ', containing "' +
      FCurrentContext.SearchString + '"';
  If SearchTextStopFlag then begin
    stNotes.Caption := 'Search for "' + FCurrentContext.SearchString +
      '" was stopped!';
  end;
  // Clear the search text. We are done searching
  FCurrentContext.SearchString := '';
  frmSearchStop.Hide;
  // Text Search CQ: HDS00002856 --------------------
  stNotes.Caption := stNotes.Caption + ' (Total: ' + NoteTotal + ')';
  stNotes.hint := stNotes.Caption;
  // tvNotes.Caption := lblNotes.Caption;
  StatusText('');
end;

procedure TfrmNotes.acViewDemoUpdate(Sender: TObject);
begin
  acViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
end;

procedure TfrmNotes.acViewDetailsExecute(Sender: TObject);
begin
  inherited;
  if lstNotes.ItemIEN <= 0 then
    exit;
  mnuViewDetail.Checked := not mnuViewDetail.Checked;
  if mnuViewDetail.Checked then
  begin
    StatusText('Retrieving progress note details...');
    Screen.Cursor := crHourGlass;
    LoadDetailText(memNote.Lines, lstNotes.ItemIEN);
    // Find selected Text
    Screen.Cursor := crDefault;
    StatusText('');
    memNote.SelStart := 0;
    memNote.Repaint;
  end
  else
    lstNotesClick(Self);
  SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
end;

procedure TfrmNotes.acViewFlagsUpdate(Sender: TObject);
begin
  acViewFlags.Enabled := frmFrame.lblFlag.Enabled;
end;

procedure TfrmNotes.acViewHealthEVetUpdate(Sender: TObject);
begin
  acViewHealtheVet.Enabled := not(Copy(frmFrame.laMHV.hint, 1, 2) = 'No');
end;

{ create, edit & save notes }

procedure TfrmNotes.InsertNewNote(IsIDChild: Boolean; AnIDParent: Integer);
{ creates the editing context for a new progress note & inserts stub into top of view list }
var
  EnableAutosave, HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  X, WhyNot, DocInfo: string;
begin
  if frmFrame.TimedOut then
    exit;

  FNewIDChild := IsIDChild;
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FillChar(FEditNote, SizeOf(FEditNote), 0); // v15.7
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
      if IsSurgeryTitle(Title) then
      // Don't want surgery title sneaking in unchallenged
      begin
        Title := 0;
        TitleName := '';
      end;
      DateTime := FMNow;
      Author := User.DUZ;
      AuthorName := User.Name;
      Location := Encounter.Location;
      LocationName := Encounter.LocationName;
      VisitDate := Encounter.DateTime;
      if IsIDChild then
        IDParent := AnIDParent
      else
        IDParent := 0;
      // Cosigner & PkgRef, if needed, will be set by fNoteProps
    end;
    // check to see if interaction necessary to get required fields
    GetUnresolvedConsultsInfo;
    if LacksRequiredForCreate or VerifyNoteTitle or uUnresolvedConsults.UnresolvedConsultsExist
    then
      HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild,
        FNewIDChild, '', 0)
    else
      HaveRequired := True;
    // lock the consult request if there is a consult
    with FEditNote do
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
        HaveRequired := LockConsultRequest(PkgIEN);
    if HaveRequired then
    begin
      // set up uPCEEdit for entry of new note
      uPCEEdit.UseEncounter := True;
      uPCEEdit.NoteDateTime := FEditNote.DateTime;
      uPCEEdit.PCEForNote(USE_CURRENT_VISITSTR, uPCEShow);
      FEditNote.NeedCPT := uPCEEdit.CPTRequired;
      // create the note
      PutNewNote(CreatedNote, FEditNote);

      uPCEEdit.NoteIEN := CreatedNote.IEN;
      if CreatedNote.IEN > 0 then
        LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
      if CreatedNote.ErrorText = '' then
      begin
        // x := $$RESOLVE^TIUSRVLO formatted string
        // 7348^Note Title^3000913^NERD, YOURA  (N0165)^1329;Rich Vertigan;VERTIGAN,RICH^8E REHAB MED^complete^Adm: 11/05/98;2981105.095547^        ;^^0^^^2
        with FEditNote do
        begin
          X := IntToStr(CreatedNote.IEN) + U + TitleName + U +
            FloatToStr(FEditNote.DateTime) + U + Patient.Name + U +
            IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' +
            U + U + U + U + U + U + U + U;
          // Link Note to PRF Action
          if PRF_IEN <> 0 then
            if sCallV('TIU LINK TO FLAG', [CreatedNote.IEN, PRF_IEN, ActionIEN,
              Patient.DFN]) = '0' then
              ShowMsg('TIU LINK TO FLAG: FAILED');
        end;

        lstNotes.Items.Insert(0, X);
        uChanging := True;
        tvNotes.Items.BeginUpdate;
        if IsIDChild then
        begin
          tmpNode := tvNotes.FindPieceNode(IntToStr(AnIDParent), 1, U,
            tvNotes.Items.GetFirstNode);
          tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
          tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
          tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode,
            MakeNoteDisplayText(X), MakeNoteTreeObject(X));
          tmpNode.ImageIndex := IMG_ID_CHILD;
          tmpNode.SelectedIndex := IMG_ID_CHILD;
        end else begin
          tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode,
            'New Note in Progress',
            MakeNoteTreeObject('NEW^New Note in Progress^^^^^^^^^^^%^0'));
          TORTreeNode(tmpNode).StringData :=
            'NEW^New Note in Progress^^^^^^^^^^^%^0';
          tmpNode.ImageIndex := IMG_TOP_LEVEL;
          tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode,
            MakeNoteDisplayText(X), MakeNoteTreeObject(X));
          tmpNode.ImageIndex := IMG_SINGLE;
          tmpNode.SelectedIndex := IMG_SINGLE;
        end;
        tmpNode.StateIndex := IMG_NO_IMAGES;
        TORTreeNode(tmpNode).StringData := X;
        tvNotes.Selected := tmpNode;
        tvNotes.Items.EndUpdate;
        uChanging := FALSE;
        Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
        lstNotes.ItemIndex := 0;
        EditingIndex := 0;
        SetSubjectVisible(AskSubjectForNotes);
        if not assigned(TmpBoilerPlate) then
          TmpBoilerPlate := TStringList.Create;
        LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title);
        FChanged := FALSE;
        cmdChangeClick(Self); // will set captions, sign state for Changes
        lstNotesClick(Self); // will make pnlWrite visible
        if timAutoSave.Interval <> 0 then
          EnableAutosave := True;
        if txtSubject.Visible then
          txtSubject.SetFocus
        else
          memNewNote.SetFocus;
      end else begin
        // if note creation failed or failed to get note lock (both unlikely), unlock consult
        with FEditNote do
          if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
            UnlockConsultRequest(0, PkgIEN);
        InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
        HaveRequired := FALSE;
      end; { if CreatedNote.IEN }
    end; { if HaveRequired }
    if not HaveRequired then
    begin
      ClearEditControls;
      ShowPCEButtons(FALSE);
    end;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle,
        Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      memNewNote.Text := TmpBoilerPlate.Text;
      SpeakStrings(memNewNote);
      UpdateNoteAuthor(DocInfo);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
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
  X: string;
begin
  ClearEditControls;
  with FEditNote do
  begin
    DocType := TYP_ADDENDUM;
    IsNewNote := FALSE;
    Title := TitleForNote(lstNotes.ItemIEN);
    TitleName := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
    if Copy(TitleName, 1, 1) = '+' then
      TitleName := Copy(TitleName, 3, 199);
    DateTime := FMNow;
    Author := User.DUZ;
    AuthorName := User.Name;
    X := GetPackageRefForNote(lstNotes.ItemIEN);
    if Piece(X, U, 1) <> '-1' then
    begin
      PkgRef := GetPackageRefForNote(lstNotes.ItemIEN);
      PkgIEN := StrToIntDef(Piece(PkgRef, ';', 1), 0);
      PkgPtr := Piece(PkgRef, ';', 2);
    end;
    Addend := lstNotes.ItemIEN;
    // Lines        := memNewNote.Lines;
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
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
        HaveRequired := LockConsultRequest(PkgIEN);
  if HaveRequired then
  begin
    uPCEEdit.NoteDateTime := FEditNote.DateTime;
    uPCEEdit.PCEForNote(FEditNote.Addend, uPCEShow);
    FEditNote.Location := uPCEEdit.Location;
    FEditNote.LocationName := ExternalName(uPCEEdit.Location, 44);
    FEditNote.VisitDate := uPCEEdit.DateTime;
    PutAddendum(CreatedNote, FEditNote, FEditNote.Addend);

    uPCEEdit.NoteIEN := CreatedNote.IEN;
    if CreatedNote.IEN > 0 then
      LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
    if CreatedNote.ErrorText = '' then
    begin
      with FEditNote do
      begin
        X := IntToStr(CreatedNote.IEN) + U + 'Addendum to ' + TitleName + U +
          FloatToStr(DateTime) + U + Patient.Name + U + IntToStr(Author) + ';' +
          AuthorName + U + LocationName + U + 'new' + U + U + U + U + U +
          U + U + U;
      end;

      lstNotes.Items.Insert(0, X);
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode,
        'New Addendum in Progress',
        MakeNoteTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData :=
        'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode,
        MakeNoteDisplayText(X), MakeNoteTreeObject(X));
      TORTreeNode(tmpNode).StringData := X;

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
      lstNotesClick(Self); // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then
        timAutoSave.Enabled := True;
      memNewNote.SetFocus;
    end else begin
      // if note creation failed or failed to get note lock (both unlikely), unlock consult
      with FEditNote do
        if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
          UnlockConsultRequest(0, PkgIEN);
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := FALSE;
    end; { if CreatedNote.IEN }
  end; { if HaveRequired }
  if not HaveRequired then
    ClearEditControls;
end;

procedure TfrmNotes.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  X: string;
begin
  ClearEditControls;
  Drawers.RichEditControl := memNewNote; // added to fix problem with focused control when editing.  dlp 15Oct12
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
    if Copy(FEditNote.TitleName, 1, 1) = '+' then
      FEditNote.TitleName := Copy(FEditNote.TitleName, 3, 199);
    if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
      FEditNote.TitleName := FEditNote.TitleName + 'Addendum to ';
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
  X := lstNotes.Items[lstNotes.ItemIndex];
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

  uPCEEdit.NoteDateTime :=
    MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  uPCEEdit.PCEForNote(lstNotes.ItemIEN, uPCEShow);
  FEditNote.NeedCPT := uPCEEdit.CPTRequired;
  txtSubject.Text := FEditNote.Subject;
  SetSubjectVisible(AskSubjectForNotes);
  cmdChangeClick(Self); // will set captions, sign state for Changes
  lstNotesClick(Self); // will make pnlWrite visible
  if timAutoSave.Interval <> 0 then
    timAutoSave.Enabled := True;
  memNewNote.SetFocus;
end;

procedure TfrmNotes.SaveEditedNote(var Saved: Boolean);
{ validates fields and sends the updated note to the server }
var
  UpdatedNote: TCreatedDoc;
  X: string;
begin
  Saved := False;
  if (memNewNote.GetTextLen = 0) or (not ContainsVisibleChar(memNewNote.Text)) then begin
    lstNotes.ItemIndex := EditingIndex;
    X := lstNotes.ItemID;
    uChanging := True;
    tvNotes.Selected := tvNotes.FindPieceNode(x, 1, U, tvNotes.Items.GetFirstNode);
    uChanging := False;
    tvNotesChange(Self, tvNotes.Selected);
    if FSilent or ((not FSilent) and
      (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_NOTE, TC_EMPTY_NOTE,
      MB_YESNO) = IDYES)) then
    begin
      FConfirmed := True;
      acDeleteNoteExecute(Self);
      Saved := True;
      FDeleted := True;
    end
    else
      FConfirmed := False;
    Exit;
  end;
  // ExpandTabsFilter(memNewNote.Lines, TAB_STOP_CHARS);
  FEditNote.Lines := memNewNote.Lines;
  // FEditNote.Lines:= SetLinesTo74ForSave(memNewNote.Lines, Self);
  FEditNote.Subject := txtSubject.Text;
  FEditNote.NeedCPT := uPCEEdit.CPTRequired;
  timAutoSave.Enabled := FALSE;
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
      InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2,
        TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmNotes.SaveCurrentNote(var Saved: Boolean);
{ called whenever a note should be saved - uses IEN to call appropriate save logic }
begin
  if EditingIndex >= 0 then
    SaveEditedNote(Saved);
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmNotes.lstNotesClick(Sender: TObject);
{ loads the text for the selected note or displays the editing panel for the selected note }
var
  X: string;
begin
  inherited;
  with lstNotes do
    if ItemIndex = -1 then
      exit
    else if ItemIndex = EditingIndex then
    begin
//      pnlWrite.Visible := True;
      ReadVisible := False;
      mnuViewDetail.Enabled := False;
      mnuActChange.Enabled := not ((FEditNote.IDParent <> 0) and (not FNewIDChild));
      mnuActLoadBoiler.Enabled := True;
//      stTitle.Caption := '';
      UpdateReminderFinish;
    end
    else
    begin
      StatusText('Retrieving selected progress note...');
      Screen.Cursor := crHourGlass;
      ReadVisible := True;
//      pnlWrite.Visible := FALSE;
      UpdateReminderFinish;
      stTitle.Caption := Piece(Piece(Items[ItemIndex], U, 8), ';', 1) + #9 +
        Piece(Items[ItemIndex], U, 2) + ', ' + Piece(Items[ItemIndex], U, 6) +
        ', ' + Piece(Piece(Items[ItemIndex], U, 5), ';', 2) + '  (' +
        FormatFMDateTime('dddddd@hh:nn',
        MakeFMDateTime(Piece(Items[ItemIndex], U, 3))) + ')';
      LoadDocumentText(memNote.Lines, ItemIEN);
      memNote.SelStart := 0;
      mnuViewDetail.Enabled := True;
      mnuViewDetail.Checked := FALSE;
      mnuActChange.Enabled := FALSE;
      mnuActLoadBoiler.Enabled := FALSE;
      Screen.Cursor := crDefault;
      StatusText('');
      If GlobalSearch then begin
       dlgFindText.FindText := GlobalSearchTerm;
       dlgFindText.Options := [];
       dmodShared.FindRichEditTextAll(Memnote, dlgFindText, clHighlight, [fsItalic, fsBold]);
      end;
    end;
  if (Assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
  DisplayPCE;
  memNewNote.Repaint;
  memNote.Repaint;
  X := 'TIU^' + lstNotes.ItemID;
  SetPiece(X, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
  NotifyOtherApps(NAE_REPORT, X);
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmNotes.cmdChangeClick(Sender: TObject);
var
  LastTitle, LastConsult: Integer;
  OKPressed, IsIDChild: Boolean;
  X: string;
  DisAssoText: string;
begin
  inherited;
  IsIDChild := uIDNotesActive and (FEditNote.IDParent > 0);
  LastTitle := FEditNote.Title;
  FEditNote.IsNewNote := False;
  DisAssoText := '';
  if (FEditNote.PkgPtr = PKG_CONSULTS) then
    DisAssoText := 'Consults';
  if (FEditNote.PkgPtr = PKG_PRF) then
    DisAssoText := 'Patient Record Flags';
  if (DisAssoText <> '') and (Sender <> Self) then
    if InfoBox('If this title is changed, Any ' + DisAssoText +
      ' will be disassociated' + ' with this note',
      'Disassociate ' + DisAssoText + '?', MB_OKCANCEL) = IDCANCEL then
      exit;
  if FEditNote.PkgPtr = PKG_CONSULTS then
    LastConsult := FEditNote.PkgIEN
  else
    LastConsult := 0;;
  if Sender <> Self then
    OKPressed := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild,
      FNewIDChild, '', 0)
  else
    OKPressed := True;
  if not OKPressed then
    exit;
  // update display fields & uPCEEdit
  lblNewTitle.Caption := ' ' + FEditNote.TitleName + ' ';
  if (FEditNote.Addend > 0) and (CompareText(Copy(lblNewTitle.Caption, 2, 8), 'Addendum') <> 0) then
    lblNewTitle.Caption := ' Addendum to:' + lblNewTitle.Caption;
  with lblNewTitle do
    bvlNewTitle.SetBounds(Left - 1, Top - 1, Width + 2, Height + 2);
  stRefDate.Caption := FormatFMDateTime('dddddd@hh:nn', FEditNote.DateTime);
  stAuthor.Caption := FEditNote.AuthorName;
  if uPCEEdit.Inpatient then
    X := 'Adm: '
  else
    X := 'Vst: ';
  X := X + FormatFMDateTime('ddddd', FEditNote.VisitDate) + '  ' + FEditNote.LocationName;
  lblVisit.Caption := X;
  if Length(FEditNote.CosignerName) > 0 then
    stCosigner.Caption := 'Expected Cosigner: ' + FEditNote.CosignerName
  else
    stCosigner.Caption := '';

  stAuthor.Width := TextWidthByFont(stAuthor.Font.Handle, stAuthor.Caption);
  stAuthor.Left := cmdChange.Left - stAuthor.Width - 4;
  stCosigner.Width := TextWidthByFont(stCosigner.Font.Handle, stCosigner.Caption);
  stCosigner.Left := cmdChange.Left - stCosigner.Width - 4;

  uPCEEdit.NoteTitle := FEditNote.Title;
  // modify signature requirements if author or cosigner changed
  if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner) then
    Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_NA)
  else
    Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_YES);
  X := lstNotes.Items[EditingIndex];
  SetPiece(X, U, 2, lblNewTitle.Caption);
  SetPiece(X, U, 3, FloatToStr(FEditNote.DateTime));
  tvNotes.Selected.Text := MakeNoteDisplayText(X);
  TORTreeNode(tvNotes.Selected).StringData := X;
  lstNotes.Items[EditingIndex] := X;
  Changes.ReplaceText(CH_DOC, lstNotes.ItemID, GetTitleText(EditingIndex));
  with FEditNote do
  begin
    if (PkgPtr = PKG_CONSULTS) and (LastConsult <> PkgIEN) then
    begin
      // try to lock the new consult, reset to previous if unable
      if (PkgIEN > 0) and not LockConsultRequest(PkgIEN) then
      begin
        InfoBox(TX_NO_ORD_CHG, TC_NO_ORD_CHG, MB_OK);
        PkgIEN := LastConsult;
      end
      else
      begin
        // unlock the previous consult
        if LastConsult > 0 then
          UnlockOrderIfAble(GetConsultOrderIEN(LastConsult));
        if PkgIEN = 0 then
          FOrderID := '';
      end;
    end;
    // Link Note to PRF Action
    if PRF_IEN <> 0 then
      if sCallV('TIU LINK TO FLAG', [lstNotes.ItemIEN, PRF_IEN, ActionIEN,
        Patient.DFN]) = '0' then
        ShowMsg('TIU LINK TO FLAG: FAILED');
  end;

  if LastTitle <> FEditNote.Title then
    self.acReloadBoilerExecute(Self);
end;

procedure TfrmNotes.memNewNoteChange(Sender: TObject);
begin
  inherited;
  FChanged := True;
end;

(*procedure TfrmNotes.pnlFieldsResize(Sender: TObject);
{ center the reference date on the panel }
var
  ileft, iwidth, iright, ioffset, halfref: Integer;  // rpk 5/21/2013
begin
  inherited;
  lblRefDate.Left := (pnlFields.Width - lblRefDate.Width) div 2;
  // if lblRefDate.Left < (lblNewTitle.Left + lblNewTitle.Width + 6)
  // then lblRefDate.Left := (lblNewTitle.Left + lblNewTitle.Width);

  ileft := lblNewTitle.Left + lblNewTitle.Width + 6; // rpk 5/21/2013
  iright := lblAuthor.Left - 6; // rpk 5/21/2013
  halfref := lblRefDate.Width div 2; // rpk 5/21/2013
  iwidth := iright - ileft; // rpk 5/21/2013
  if iwidth > lblRefDate.Width then begin // rpk 5/21/2013
    ioffset := (iwidth div 2) - halfref; // rpk 5/21/2013
    if ioffset > 0 then // rpk 5/21/2013
      lblRefDate.Left := (ileft + ioffset); // rpk 5/21/2013
  end; // rpk 5/21/2013
 // UpdateFormForInput;
end;
  *)
procedure TfrmNotes.DoAutoSave(Suppress: Integer = 1);
var
  ErrMsg: string;
begin
  if fFrame.frmFrame.DLLActive then
    exit;
  if (EditingIndex > -1) and FChanged then
  begin
    StatusText('Autosaving note...');
    // PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
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
    InfoBox(TX_SAVE_ERROR1 + ErrMsg + TX_SAVE_ERROR2, TC_SAVE_ERROR,
      MB_OK or MB_ICONWARNING);
  // Assert(ErrMsg = '', 'AutoSave: ' + ErrMsg);
end;

procedure TfrmNotes.DrawerButtonClicked;
begin
  SendMessage(PnlLeft.Handle, WM_SETREDRAW, 0, 0);
  try
    if Drawers.DrawerButtonsVisible then
    begin
      pnlDrawers.Visible := true;
      pnlDrawers.Top := splDrawers.Top +1;
      splDrawers.Enabled := Drawers.DrawerIsOpen;
      if Drawers.DrawerIsOpen then
      begin
        if Drawers.LastOpenSize > Drawers.TotalButtonHeight then
          ExpandedDrawerHeight := Drawers.LastOpenSize;
        Drawers.Parent.Height := ExpandedDrawerHeight;
        Drawers.Parent.Constraints.MinHeight := 150;
      end
      else
      begin
        Drawers.Parent.Constraints.MinHeight := 0;
        Drawers.Parent.Height := Drawers.TotalButtonHeight;
        Drawers.Parent.Constraints.MinHeight := Drawers.TotalButtonHeight;
      end;
    end
    else
    begin
      pnlDrawers.Visible := False;
      splDrawers.Enabled := False;
    end;
  finally
    SendMessage(PnlLeft.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(PnlLeft.Handle, nil, 0, RDW_ERASE or RDW_FRAME or
      RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

procedure TfrmNotes.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
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
//  cmdNewNote.Enabled := False;
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
    if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then begin
      Result := False;
      FStarting := False;
    end else begin
      SaveCurrentNote(Saved);
      if not Saved then
        Result := FALSE
      else
        LoadNotes;
      FStarting := FALSE;
    end;
  end else begin
    //Consults section
    if frmConsults.EditingIndex > -1 then begin
      FStarting := True;
      case NewNoteType of
        NT_ACT_ADDENDUM: begin
            Msg := TX_NEW_SAVE1 +
                  MakeNoteDisplayText(frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
                  TX_NEW_SAVE3;
            CapMsg := TC_NEW_SAVE3;
          end;
        NT_ACT_EDIT_NOTE: begin
            Msg := TX_NEW_SAVE1 +
                   MakeNoteDisplayText(frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
          			   TX_NEW_SAVE4;
            CapMsg := TC_NEW_SAVE4;
          end;
        NT_ACT_ID_ENTRY: begin
            Msg := TX_NEW_SAVE1 +
                   MakeNoteDisplayText(frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
                   TX_NEW_SAVE5;
            CapMsg := TC_NEW_SAVE5;
          end;
      else begin
          Msg := TX_NEW_SAVE1 +
                 MakeNoteDisplayText(frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
                 TX_NEW_SAVE2;
         CapMsg := TC_NEW_SAVE2;
        end;
      end;
      if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then begin
        Result := False;
        FStarting := False;
      end else begin
        frmConsults.SaveCurrentNote(Saved);
        if not Saved then Result := False else LoadNotes;
        FStarting := False;
      end;
    end;
  end;
  //cmdNewNote.Enabled := (Result = FALSE) and (FStarting = FALSE);
  acNewNoteUpdate(nil);
end;

procedure TfrmNotes.ReadToFront;
begin
  lvNotes.BringToFront;
  splList.BringToFront;
  pnlNote.BringToFront;
end;

procedure TfrmNotes.RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
begin
  if IEN = NT_ADDENDUM then
    exit; // no PCE information entered for an addendum
  // do we need to call DeletePCE(AVisitStr), as was done with NT_NEW_NOTE (ien=-10)???
  if AVisitStr = '' then
    AVisitStr := VisitStrForNote(IEN);
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

procedure TfrmNotes.SaveSignItem(const ItemID, ESCode: string);
{ saves and optionally signs a progress note or addendum }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN = 'SIGNATURE';
var
  AnIndex, IEN, i: Integer;
  Saved, ContinueSign: Boolean; { *RAB* 8/26/99 }
  ActionSts, SignSts: TActionRec;
  APCEObject: TPCEData;
  OK: Boolean;
  ActionType, SignTitle: string;
begin
  AnIndex := -1;
  IEN := StrToIntDef(ItemID, 0);
  if IEN = 0 then
    exit;
  if frmFrame.TimedOut and (EditingIndex <> -1) then
    FSilent := True;
  with lstNotes do
    for i := 0 to Items.Count - 1 do
      if lstNotes.GetIEN(i) = IEN then
      begin
        AnIndex := i;
        break;
      end;
  if (AnIndex > -1) and (AnIndex = EditingIndex) then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    if FDeleted then
    begin
      FDeleted := FALSE;
      exit;
    end;
    AnIndex := lstNotes.SelectByIEN(IEN);
    // IEN := lstNotes.GetIEN(AnIndex);                    // saving will change IEN
  end;
  if Length(ESCode) > 0 then
  begin
    if CosignDocument(IEN) then
    begin
      SignTitle := TX_COSIGN;
      ActionType := SIG_COSIGN;
    end
    else
    begin
      SignTitle := TX_SIGN;
      ActionType := SIG_SIGN;
    end;
    ActOnDocument(ActionSts, IEN, ActionType);
    if not ActionSts.Success then
    begin
      InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
      ContinueSign := FALSE;
    end
    else if not NoteHasText(IEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      ContinueSign := FALSE;
    end
    else if not LastSaveClean(IEN) and
      (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or
      MB_ICONWARNING) <> IDYES) then
      ContinueSign := FALSE
    else
      ContinueSign := True;
    if ContinueSign then
    begin
      if (AnIndex >= 0) and (AnIndex = lstNotes.ItemIndex) then
        APCEObject := uPCEShow
      else
        APCEObject := nil;
      OK := IsOK2Sign(APCEObject, IEN);
      if frmFrame.Closing then
        exit;
      if (Assigned(APCEObject)) and (uPCEShow.Updated) then
      begin
        uPCEShow.CopyPCEData(uPCEEdit);
        uPCEShow.Updated := FALSE;
        lstNotesClick(Self);
      end
      else
        uPCEEdit.Clear;
      if (OK) then
      begin
        // if ((not FSilent) and IsSurgeryTitle(TitleForNote(IEN))) then DisplayOpTop(IEN);
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then
          InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; { if OK }
    end; { if ContinueSign }
  end; { if Length(ESCode) }

  UnlockConsultRequest(IEN);
  // GE 14926; added if (AnIndex> -1) to by pass LoadNotes when creating on narking Allerg Entered In error.
  if (AnIndex > -1) and (AnIndex = lstNotes.ItemIndex) and
    (not frmFrame.ContextChanging) then
  begin
    LoadNotes;
    with tvNotes do
      Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
  end;
end;

procedure TfrmNotes.popNoteMemoPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteMemo) is TCustomEdit then
    FEditCtrl := TCustomEdit(PopupComponent(Sender, popNoteMemo))
  else
    FEditCtrl := nil;
  if FEditCtrl <> nil then
  begin
    popNoteMemoCut.Enabled := FEditCtrl.SelLength > 0;
    popNoteMemoCopy.Enabled := popNoteMemoCut.Enabled;
    popNoteMemoPaste.Enabled := (not TORExposedCustomEdit(FEditCtrl).ReadOnly)
      and Clipboard.HasFormat(CF_TEXT);
    popNoteMemoTemplate.Enabled := Drawers.CanEditTemplates and
      popNoteMemoCut.Enabled;
    popNoteMemoFind.Enabled := FEditCtrl.GetTextLen > 0;
  end
  else
  begin
    popNoteMemoCut.Enabled := FALSE;
    popNoteMemoCopy.Enabled := FALSE;
    popNoteMemoPaste.Enabled := FALSE;
    popNoteMemoTemplate.Enabled := FALSE;
  end;
  if pnlWrite.Visible then
  begin
    popNoteMemoSpell.Enabled := True;
    popNoteMemoGrammar.Enabled := True;
    popNoteMemoReformat.Enabled := True;
    popNoteMemoReplace.Enabled := (FEditCtrl.GetTextLen > 0);
    popNoteMemoPreview.Enabled := (Drawers.ActiveDrawer = odTemplates) and
      Assigned(Drawers.tvTemplates.Selected);
    popNoteMemoInsTemplate.Enabled := (Drawers.ActiveDrawer = odTemplates) and
      Assigned(Drawers.tvTemplates.Selected);
    popNoteMemoViewCslt.Enabled := (FEditNote.PkgPtr = PKG_CONSULTS);
    // if editing consult title
  end
  else
  begin
    popNoteMemoSpell.Enabled := FALSE;
    popNoteMemoGrammar.Enabled := FALSE;
    popNoteMemoReformat.Enabled := FALSE;
    popNoteMemoReplace.Enabled := FALSE;
    popNoteMemoPreview.Enabled := FALSE;
    popNoteMemoInsTemplate.Enabled := FALSE;
    popNoteMemoViewCslt.Enabled := FALSE;
  end;
end;

procedure TfrmNotes.popNoteMemoPreviewClick(Sender: TObject);
begin
  inherited;
  Drawers.acPreviewTemplateExecute(Sender);
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
  ScrubTheClipboard;
  FEditCtrl.PasteFromClipboard; // use AsText to prevent formatting
end;

procedure TfrmNotes.popNoteMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memNewNote then
    exit;
  ReformatMemoParagraph(memNewNote);
end;

procedure TfrmNotes.popNoteMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmNotes.popNoteMemoFindClick(Sender: TObject);
// var
// hData: THandle;  //CQ8300
// pData: ^ClipboardData; //CQ8300
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL, SB_TOP, 0);
  with dlgFindText do
  begin
    Position := Point(Application.MainForm.Left + splHorz.Left + splHorz.Width, Application.MainForm.Top);
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
  dmodShared.FindRichEditText(dlgFindText,
    TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoReplaceClick(Sender: TObject);
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL,
    SB_TOP, 0);
  with dlgReplaceText do
  begin
    Position := Point(Application.MainForm.Left + splHorz.Left + splHorz.Width, Application.MainForm.Top);
    FindText := '';
    ReplaceText := '';
    Options := [frDown, frHideUpDown];
    Execute;
  end;
end;

procedure TfrmNotes.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText,
    TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText,
    TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmNotes.popNoteMemoSpellClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := FALSE;
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
  timAutoSave.Enabled := FALSE;
  try
    GrammarCheckForControl(memNewNote);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmNotes.popNoteMemoInsTemplateClick(Sender: TObject);
begin
  inherited;
  Drawers.acInsertTemplateExecute(Sender);
end;

procedure TfrmNotes.popNoteMemoViewCsltClick(Sender: TObject);
var
  CsltIEN: Integer;
  ConsultDetail: TStringList;
  X: string;
begin
  inherited;
  if (Screen.ActiveControl <> memNewNote) or (FEditNote.PkgPtr <> PKG_CONSULTS)
  then
    exit;
  CsltIEN := FEditNote.PkgIEN;
  X := FindConsult(CsltIEN);
  ConsultDetail := TStringList.create;
  try
    LoadConsultDetail(ConsultDetail, CsltIEN);
    ReportBox(ConsultDetail, 'Consult Details: #' + IntToStr(CsltIEN) + ' - ' +
      Piece(X, U, 4), True);
  finally
    ConsultDetail.free;
  end;
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
    if memNewNote.GetTextLen > 0 then
      SaveCurrentNote(Saved)
    else
    begin
      IEN := lstNotes.GetIEN(EditingIndex);
      if not LastSaveClean(IEN) then // means note hasn't been committed yet
      begin
        LockDocument(IEN, ErrMsg);
        if ErrMsg = '' then
        begin
          DeleteDocument(DeleteSts, IEN, '');
          UnlockDocument(IEN);
        end; { if ErrMsg }
      end; { if not LastSaveClean }
    end; { else }
  end; { if frmFrame }
end;

procedure TfrmNotes.ProcessNotifications;
var
  X: string;
  Saved: Boolean;
  tmpNode: TTreeNode;
  AnObject: PDocTreeObject;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
  end;
  stNotes.Caption := Notifications.Text;
  // tvNotes.Caption := Notifications.Text;
  EditingIndex := -1;
  lstNotes.Enabled := True;
  ReadToFront;
  // show ALL unsigned/uncosigned for a patient, not just the alerted one
  // what about cosignature?  How to get correct list?  ORB FOLLOWUP TYPE = OR alerts only
  X := Notifications.AlertData;
  if StrToIntDef(Piece(X, U, 1), 0) = 0 then
  begin
    InfoBox(TX_NO_ALERT, TX_CAP_NO_ALERT, MB_OK);
    exit;
  end;
  uChanging := True;
  tvNotes.Items.BeginUpdate;
  lstNotes.Clear;
  KillDocTreeObjects(tvNotes);
  tvNotes.Items.Clear;
  lstNotes.Items.Add(X);
  AnObject := MakeNoteTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
  tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode,
    AnObject.NodeText, AnObject);
  TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
  tmpNode.ImageIndex := IMG_TOP_LEVEL;
  AnObject := MakeNoteTreeObject(X);
  tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText,
    AnObject);
  TORTreeNode(tmpNode).StringData := X;
  SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentContext,
    CT_NOTES);
  tvNotes.Selected := tmpNode;
  tvNotes.Items.EndUpdate;
  uChanging := FALSE;
  tvNotesChange(Self, tvNotes.Selected);
  case Notifications.Followup of
    NF_NOTES_UNSIGNED_NOTE:
      ; // Automatically deleted by sig action!!!
  end;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then
    Notifications.Delete;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then
    Notifications.Delete;
end;

procedure TfrmNotes.SetViewContext(AContext: TTIUContext);
var
  Saved: Boolean;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
  end;
  FCurrentContext := AContext;
  EditingIndex := -1;
  tvNotes.Enabled := True;
  ReadToFront;
  if FCurrentContext.Status <> '' then
    with uTIUContext do
    begin
      BeginDate := FCurrentContext.BeginDate;
      EndDate := FCurrentContext.EndDate;
      FMBeginDate := FCurrentContext.FMBeginDate;
      FMEndDate := FCurrentContext.FMEndDate;
      Status := FCurrentContext.Status;
      Author := FCurrentContext.Author;
      MaxDocs := FCurrentContext.MaxDocs;
      ShowSubject := FCurrentContext.ShowSubject;
      GroupBy := FCurrentContext.GroupBy;
      SortBy := FCurrentContext.SortBy;
      ListAscending := FCurrentContext.ListAscending;
      TreeAscending := FCurrentContext.TreeAscending;
      Keyword := FCurrentContext.Keyword;
      SearchField := FCurrentContext.SearchField;
      Filtered := FCurrentContext.Filtered;
      Changed := True;
      mnuViewClick(Self);
    end
  else
  begin
    ViewContext := NC_RECENT;
    mnuViewClick(Self);
  end;
end;

procedure TfrmNotes.SetWriteShowing(const Value: boolean);
begin
  if Value <> pnlWrite.Visible then begin
    if not value then begin
      pnlWrite.Left := 0;
  //    pnlWrite.Width := 0;
      pnlWrite.Top := 0;
      pnlWrite.Height := 0;
    end;
    pnlWrite.Visible := Value;
  end;
end;

procedure TfrmNotes.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, True, FEditCtrl.SelText);
end;

procedure TfrmNotes.popNoteListPopup(Sender: TObject);
begin
  inherited;
  N4.Visible := (popNoteList.PopupComponent is TORTreeView);
  popNoteListExpandAll.Visible := N4.Visible;
  popNoteListExpandSelected.Visible := N4.Visible;
  popNoteListCollapseAll.Visible := N4.Visible;
  popNoteListCollapseSelected.Visible := N4.Visible;
end;

procedure TfrmNotes.popNoteListExpandAllClick(Sender: TObject);
begin
  inherited;
  tvNotes.FullExpand;
end;

procedure TfrmNotes.pnlDrawersResize(Sender: TObject);
begin
  inherited;
  Drawers.BaseHeight := pnlDrawers.Height;
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
   if (Self <> nil) and (pnlLeft <> nil) and (pnlWrite <> nil) and (splHorz <> nil) then
    if memNewNote.Width =  memNewNote.Constraints.MinWidth then
     pnlLeft.Width := self.ClientWidth - pnlWrite.Width - splHorz.Width;
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
  if tvNotes.Selected = nil then
    exit;
  with tvNotes.Selected do
    if HasChildren then
      Expand(True);
end;

procedure TfrmNotes.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then
    exit;
  with tvNotes.Selected do
    if HasChildren then
      Collapse(True);
end;

procedure TfrmNotes.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if (FEditingIndex < 0) then
    KillReminderDialog(Self);
  if (Assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

procedure TfrmNotes.SetExpandedDrawerHeight(const Value: integer);
begin
  if (Value <> fExpandedDrawerHeight) then begin
    fExpandedDrawerHeight := Value;
  end;
end;

function TfrmNotes.CanFinishReminder: Boolean;
begin
  if (EditingIndex < 0) then
    Result := FALSE
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmNotes.FormDestroy(Sender: TObject);
begin
  FDocList.free;
  FImageFlag.free;
  if assigned(Encounter) and assigned(Encounter.Notifier) then
    Encounter.Notifier.RemoveNotify(EncounterLocationChanged);
  KillDocTreeObjects(tvNotes);
  inherited;
end;

procedure TfrmNotes.AssignRemForm;
begin
  RemForm.Form := Self;
  RemForm.PCEObj := uPCEEdit;
  RemForm.RightPanel := pnlReminder;
  RemForm.CanFinishProc := CanFinishReminder;
  RemForm.DisplayPCEProc := DisplayPCE;
  RemForm.NewNoteRE := memNewNote;
  RemForm.NoteList := lstNotes;
  RemForm.DrawerReminderTV := Drawers.tvReminders;
  RemForm.DrawerReminderTreeChange := Drawers.NotifyWhenRemTreeChanges;
  RemForm.DrawerRemoveReminderTreeChange := Drawers.RemoveNotifyWhenRemTreeChanges;
end;

// ===================  Added for sort/search enhancements ======================
procedure TfrmNotes.LoadNotes;
const
  INVALID_ID = -1;
  INFO_ID = 1;
var
  tmpList: TStringList;
  ANode: TORTreeNode;
  X, xx, noteId: Integer; // Text Search CQ: HDS00002856
  Dest: TStrings; // Text Search CQ: HDS00002856
  KeepFlag: Boolean; // Text Search CQ: HDS00002856
  NoteCount, NoteMatches: Integer; // Text Search CQ: HDS00002856
begin
  tmpList := TStringList.create;
  try
    FDocList.Clear;
    uChanging := True;
    RedrawSuspend(memNote.Handle);
    RedrawSuspend(lvNotes.Handle);
    try
    tvNotes.Items.BeginUpdate;
    lstNotes.Items.Clear;
    KillDocTreeObjects(tvNotes);
    tvNotes.Items.Clear;
    tvNotes.Items.EndUpdate;
    lvNotes.Items.Clear;
    memNote.Clear;
    memNote.Invalidate;
    stTitle.Caption := '';
    with FCurrentContext do
    begin
      if Status <> IntToStr(NC_UNSIGNED) then
      begin
        ListNotesForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0, TreeAscending);
        if tmpList.Count > 0 then
        begin
          CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNSIGNED,
            GroupBy, TreeAscending, CT_NOTES);
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
          CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNCOSIGNED,
            GroupBy, TreeAscending, CT_NOTES);
          UpdateTreeView(FDocList, tvNotes);
        end;
        tmpList.Clear;
        FDocList.Clear;
      end;
      ListNotesForTree(tmpList, StrToIntDef(Status, 0), FMBeginDate, FMEndDate,
        Author, MaxDocs, TreeAscending);
      CreateListItemsforDocumentTree(FDocList, tmpList, StrToIntDef(Status, 0),
        GroupBy, TreeAscending, CT_NOTES);

      // Text Search CQ: HDS00002856 ---------------------------------------
      if FCurrentContext.SearchString <> '' then // Text Search CQ: HDS00002856
      begin
        NoteMatches := 0;
        Dest := TStringList.create;
        NoteCount := FDocList.Count - 1;
        if FDocList.Count > 0 then
          for X := FDocList.Count - 1 downto 1 do
          begin; // Don't do 0, because it's informational
            KeepFlag := FALSE;
            stNotes.Caption := 'Scanning ' + IntToStr(NoteCount - X + 1) +
              ' of ' + IntToStr(NoteCount) + ', ' + IntToStr(NoteMatches);
            If NoteMatches = 1 then
              stNotes.Caption := stNotes.Caption + ' match'
            else
              stNotes.Caption := stNotes.Caption + ' matches';
            frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
            frmSearchStop.lblSearchStatus.Repaint;
            stNotes.Repaint;
            // Free up some ticks so they can click the "Stop" button
            Application.processmessages;
            Application.processmessages;
            Application.processmessages;
            If SearchTextStopFlag = FALSE then
            begin
              noteId := StrToIntDef(Piece(FDocList.Strings[X], '^', 1), -1);
              if (noteId = INVALID_ID) or (noteId = INFO_ID) then
                Continue;
              Callv('TIU GET RECORD TEXT',
                [Piece(FDocList.Strings[X], '^', 1)]);
              Dest.Text := RPCBrokerV.Results.Text;
              If Dest.Count > 0 then
                for xx := 0 to Dest.Count - 1 do
                begin
                  // Dest.Strings[xx] := StringReplace(Dest.Strings[xx],'#13',' ',[rfReplaceAll, rfIgnoreCase]);
                  if Pos(Uppercase(FCurrentContext.SearchString),
                    Uppercase(Dest.Strings[xx])) > 0 then
                    KeepFlag := True;
                end;
              If KeepFlag = FALSE then
              begin;
                if FDocList.Count >= X then
                  FDocList.Delete(X);
                if (tmpList.Count >= X) and (X > 0) then
                  tmpList.Delete(X - 1);
              end
              else
                Inc(NoteMatches);
            end;
          end;
        Dest.free;
      end
      else
        // Reset the caption
        stNotes.Caption := SetNoteTreeLabel(FCurrentContext);

      // Text Search CQ: HDS00002856 ---------------------------------------

      UpdateTreeView(FDocList, tvNotes);
    end;
    with tvNotes do
    begin
      uChanging := True;
      tvNotes.Items.BeginUpdate;
      RemoveParentsWithNoChildren(tvNotes, FCurrentContext);
      // moved here in v15.9 (RV)
      if FLastNoteID <> '' then
        Selected := FindPieceNode(FLastNoteID, 1, U, nil);
      if Selected = nil then
      begin
        if (FCurrentContext.GroupBy <> '') or (FCurrentContext.Filtered) then
        begin
          ANode := TORTreeNode(Items.GetFirstNode);
          while ANode <> nil do
          begin
            ANode.Expand(FALSE);
            Selected := ANode;
            ANode := TORTreeNode(ANode.GetNextSibling);
          end;
        end
        else
        begin
          ANode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
          if ANode <> nil then
            ANode.Expand(FALSE);
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
      // RemoveParentsWithNoChildren(tvNotes, FCurrentContext);  // moved FROM here in v15.9 (RV)
      tvNotes.Items.EndUpdate;
      uChanging := FALSE;
      SendMessage(tvNotes.Handle, WM_VSCROLL, SB_TOP, 0);
      if Selected <> nil then
        tvNotesChange(Self, Selected);
    end;
  finally
    RedrawActivate(memNote.Handle);
    RedrawActivate(lvNotes.Handle);
  end;
  finally
   tmpList.free;
  end;
end;

procedure TfrmNotes.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
var
  ReturnCursor: Integer;
  CurrentActive: TDrawer;
begin
  Screen.Cursor := crHourGlass;
  try
    CurrentActive := Drawers.ActiveDrawer;
    Drawers.ActiveDrawer := odNone;
    with Tree do begin
      uChanging := True;
      Items.BeginUpdate;
      lstNotes.Items.AddStrings(DocList);
      ReturnCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        BuildDocumentTree2(DocList, Tree, FCurrentContext, CT_NOTES);
      finally
        Screen.Cursor := ReturnCursor;
      end;
      Items.EndUpdate;
      uChanging := FALSE;
    end;
    if CurrentActive = odTemplates then begin
      Drawers.ActiveDrawer := odTemplates;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmNotes.tvNotesChange(Sender: TObject; Node: TTreeNode);
var
  X, MySearch, MyNodeID: string;
  i, ReturnCursor: Integer;

  procedure SetLvNotesVisible(aValue: Boolean);
  begin
   lvNotes.Visible := aValue;
   splList.Visible := aValue;
   splList.Top := lvNotes.Top + 1;
  end;

begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    if uChanging then
      exit;
    // This gives the change a chance to occur when keyboarding, so that WindowEyes doesn't use the old value.
    Application.ProcessMessages;
    with tvNotes do begin
      memNote.Clear;
      if Selected = nil then
        exit;

      UpdateActMenu(PDocTreeObject(Selected.Data)^.DocID, tvNotes);
      RedrawSuspend(lvNotes.Handle);
      RedrawSuspend(memNote.Handle);
      try
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      X := TORTreeNode(Selected).StringData;
      if (Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then begin
        SetLvNotesVisible(True);
       // lvNotes.Visible := True;
        lvNotes.Items.Clear;
        lvNotes.Height := (2 * lvNotes.Parent.Height) div 5;


  (*          with stTitle do
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
    *)
        stTitle.Caption := Trim(Selected.Text);
        if (FCurrentContext.SearchField <> '') and (FCurrentContext.Filtered) then
        begin
          case FCurrentContext.SearchField[1] of
            'T':
              MySearch := 'TITLE';
            'S':
              MySearch := 'SUBJECT';
            'B':
              MySearch := 'TITLE or SUBJECT';
          end;
          stTitle.Caption := stTitle.Caption + ' where ' + MySearch +
            ' contains "' + Uppercase(FCurrentContext.Keyword) + '"';
          lvNotes.Caption := stTitle.Caption;
        end;

        if Selected.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected).StringData, U, 1)
        else if Selected.Parent.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected.Parent).StringData, U, 1)
        else if Selected.Parent.Parent.ImageIndex = IMG_TOP_LEVEL then
          MyNodeID := Piece(TORTreeNode(Selected.Parent.Parent).StringData, U, 1);

        uChanging := True;

        TraverseTree(tvNotes, lvNotes, Selected.getFirstChild, MyNodeID, FCurrentContext);

        with lvNotes do begin
          for i := 0 to Columns.Count - 1 do
            Columns[i].ImageIndex := IMG_NONE;
          ColumnSortForward := FCurrentContext.ListAscending;
          if ColumnToSort = 5 then
            ColumnToSort := 0;
          if ColumnSortForward then
            Columns[ColumnToSort].ImageIndex := IMG_ASCENDING
          else
            Columns[ColumnToSort].ImageIndex := IMG_DESCENDING;
          if ColumnToSort = 0 then
            ColumnToSort := 5;
          AlphaSort;
          Columns[5].Width := 0;
          Columns[6].Width := 0;
        end;
        uChanging := FALSE;
        with lvNotes do begin
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
            ShowPCEControls(FALSE);
          end;
        end;
  //      pnlWrite.Visible := FALSE;
        ReadVisible := True;
        UpdateReminderFinish;
        ShowPCEControls(FALSE);
        Drawers.DisplayDrawers(True, Drawers.ActiveDrawer, [odTemplates], [odTemplates]); // FALSE);
        ShowPCEButtons(FALSE);
      end
      else if StrToIntDef(Piece(X, U, 1), 0) > 0 then
      begin
        memNote.Clear;
        SetLvNotesVisible(False);
        //lvNotes.Visible := FALSE;
        lstNotes.SelectByID(Piece(X, U, 1));
        lstNotesClick(Self);
        SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
      end;

      //display orphaned warning
      if PDocTreeObject(Selected.Data)^.Orphaned then
       MessageDlg(ORPHANED_NOTE_TEXT, mtInformation, [mbOK], -1);

      SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
      finally
       RedrawActivate(lvNotes.Handle);
       RedrawActivate(memNote.Handle);
      end;
    end;
  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmNotes.tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
begin
  with Node do
  begin
    if (ImageIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN])
    then
      ImageIndex := ImageIndex - 1;
    if (SelectedIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN,
      IMG_IDPAR_ADDENDA_OPEN]) then
      SelectedIndex := SelectedIndex - 1;
  end;
end;

procedure TfrmNotes.tvNotesExpanded(Sender: TObject; Node: TTreeNode);

  function SortByTitle(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by title
      BUT - addenda to parent document are always at the top of the sort, in date order }
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
      (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
    begin
      Result := AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
        PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
    end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then
      Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then
      Result := 1
    else
    begin
      if Data = 0 then
        Result := AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
          PChar(PDocTreeObject(Node2.Data)^.DocTitle))
      else
        Result := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocTitle),
          PChar(PDocTreeObject(Node2.Data)^.DocTitle));
    end
  end;

  function SortByDate(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
  begin
    { Within an ID parent node, sorts in ascending order by document date
      BUT - addenda to parent document are always at the top of the sort, in date order }
    if (Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum') and
      (Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum') then
    begin
      Result := AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
        PChar(PDocTreeObject(Node2.Data)^.DocFMDate));
    end
    else if Copy(PDocTreeObject(Node1.Data)^.DocTitle, 1, 8) = 'Addendum' then
      Result := -1
    else if Copy(PDocTreeObject(Node2.Data)^.DocTitle, 1, 8) = 'Addendum' then
      Result := 1
    else
    begin
      if Data = 0 then
        Result := AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocFMDate),
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
    if (ImageIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_SHUT])
    then
      ImageIndex := ImageIndex + 1;
    if (SelectedIndex in [IMG_GROUP_SHUT, IMG_IDNOTE_SHUT,
      IMG_IDPAR_ADDENDA_SHUT]) then
      SelectedIndex := SelectedIndex + 1;
  end;
end;

procedure TfrmNotes.tvNotesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := FALSE;
  if not uIDNotesActive then
    exit;
  AnItem := TORTreeNode(tvNotes.GetNodeAt(X, Y));
  if (AnItem = nil) or (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT,
    IMG_TOP_LEVEL]) then
    exit;
  with tvNotes.Selected do
    if (ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD])
    then
      Accept := (AnItem.ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_IDNOTE_OPEN,
        IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT])
    else if (ImageIndex in [IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
      IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      Accept := (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT,
        IMG_TOP_LEVEL])
    else if (ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT,
      IMG_TOP_LEVEL]) then
      Accept := FALSE;
end;

procedure TfrmNotes.tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HT: THitTests;
  Saved: Boolean;
  ADestNode: TORTreeNode;
begin
  if not uIDNotesActive then
  begin
    CancelDrag;
    exit;
  end;
  if tvNotes.Selected = nil then
    exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
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
begin
  if EditingIndex <> -1 then
  begin
    InfoBox(TX_NO_EDIT_DRAG, TX_CAP_NO_DRAG, MB_ICONERROR or MB_OK);
    CancelDrag;
    exit;
  end;
  if (tvNotes.Selected.ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN,
    IMG_GROUP_SHUT, IMG_TOP_LEVEL]) or (not uIDNotesActive) or
    (lstNotes.ItemIEN = 0) then
  begin
    CancelDrag;
    exit;
  end;
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot)
  then
  begin
    InfoBox(WhyNot, TX_CAP_NO_DRAG, MB_OK);
    CancelDrag;
  end;
end;

// =====================  Listview events  =================================

procedure TfrmNotes.lvNotesColumnClick(Sender: TObject; Column: TListColumn);
var
  i, ClickedColumn: Integer;
begin
  if Column.Index = 0 then
    ClickedColumn := 5
  else
    ClickedColumn := Column.Index;
  if ClickedColumn = ColumnToSort then
    ColumnSortForward := not ColumnSortForward
  else
    ColumnSortForward := True;
  for i := 0 to lvNotes.Columns.Count - 1 do
    lvNotes.Columns[i].ImageIndex := IMG_NONE;
  if ColumnSortForward then
    lvNotes.Columns[Column.Index].ImageIndex := IMG_ASCENDING
  else
    lvNotes.Columns[Column.Index].ImageIndex := IMG_DESCENDING;
  ColumnToSort := ClickedColumn;
  case ColumnToSort of
    5:
      FCurrentContext.SortBy := 'R';
    1:
      FCurrentContext.SortBy := 'D';
    2:
      FCurrentContext.SortBy := 'S';
    3:
      FCurrentContext.SortBy := 'A';
    4:
      FCurrentContext.SortBy := 'L';
  else
    FCurrentContext.SortBy := 'R';
  end;
  FCurrentContext.ListAscending := ColumnSortForward;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TfrmNotes.lvNotesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
  begin
    ix := ColumnToSort - 1;
    Compare := CompareText(Item1.SubItems[ix], Item2.SubItems[ix]);
  end;
  if not ColumnSortForward then
    Compare := -Compare;
end;

procedure TfrmNotes.lvNotesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if uChanging or (not Selected) then
    exit;
  with lvNotes do
  begin
    StatusText('Retrieving selected progress note...');
    lstNotes.SelectByID(Item.SubItems[5]);
    UpdateActMenu(IntToStr(lstNotes.ItemIEN), lvNotes);
    lstNotesClick(Self);
    SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
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

procedure TfrmNotes.ShowPCEButtons(Editing: Boolean);
begin
  if frmFrame.TimedOut then
    exit;

  FEditingNotePCEObj := Editing;
  if Editing or AnytimeEncounters then begin
    acPCE.Visible := True;
    if Editing then begin
      acPCE.Enabled := CanEditPCE(uPCEEdit);
      acNewNote.Visible := AnytimeEncounters;
      acNewNote.Enabled := FALSE;
    end else begin
      acPCE.Enabled := (GetAskPCE(0) <> apDisable);
      acNewNote.Visible := True;
      acNewNote.Enabled := (FStarting = FALSE); // TRUE;
    end;
  end else begin
    acPCE.Enabled := FALSE;
    acPCE.Visible := FALSE;
    acNewNote.Visible := True;
    acNewNote.Enabled := (FStarting = FALSE); // TRUE;
  end;
//  popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
//  popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmNotes.DoAttachIDChild(AChild, AParent: TORTreeNode);
const
  TX_ATTACH_CNF = 'Confirm Attachment';
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  ErrMsg, WhyNot: string;
  SavedDocID: string;
begin
  if (AChild = nil) or (AParent = nil) then
    exit;
  ErrMsg := '';
  if not CanBeAttached(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot + CRLF + CRLF;
  if not CanReceiveAttachment(PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
    ErrMsg := ErrMsg + WhyNot;
  if ErrMsg <> '' then
  begin
    InfoBox(ErrMsg, TX_ATTACH_FAILURE, MB_OK);
    exit;
  end
  else
  begin
    WhyNot := '';
    if (InfoBox('ATTACH:   ' + AChild.Text + CRLF + CRLF + '    TO:   ' +
      AParent.Text + CRLF + CRLF + 'Are you sure?', TX_ATTACH_CNF,
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES) then
      exit;
    SavedDocID := PDocTreeObject(AParent.Data)^.DocID;
  end;
  if AChild.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD] then
  begin
    if DetachEntryFromParent(PDocTreeObject(AChild.Data)^.DocID, WhyNot) then
    begin
      if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID,
        PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
      begin
        LoadNotes;
        with tvNotes do
          Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
        if tvNotes.Selected <> nil then
          tvNotes.Selected.Expand(FALSE);
      end
      else
        InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
    end
    else
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
      exit;
    end;
  end
  else
  begin
    if AttachEntryToParent(PDocTreeObject(AChild.Data)^.DocID,
      PDocTreeObject(AParent.Data)^.DocID, WhyNot) then
    begin
      LoadNotes;
      with tvNotes do
        Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      if tvNotes.Selected <> nil then
        tvNotes.Selected.Expand(FALSE);
    end
    else
      InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
  end;
end;

function TfrmNotes.SetNoteTreeLabel(AContext: TTIUContext): string;
var
  X: string;

  function SetDateRangeText(AContext: TTIUContext): string;
  var
    x1: string;
  begin
    with AContext do
      if BeginDate <> '' then
      begin
        x1 := ' from ' + Uppercase(BeginDate);
        if EndDate <> '' then
          x1 := x1 + ' to ' + Uppercase(EndDate)
        else
          x1 := x1 + ' to TODAY';
      end;
    Result := x1;
  end;

begin
  with AContext do
  begin
    if MaxDocs > 0 then
      X := 'Last ' + IntToStr(MaxDocs) + ' '
    else
      X := 'All ';
    case StrToIntDef(Status, 0) of
      NC_ALL:
        X := X + 'Signed Notes';
      NC_UNSIGNED:
        begin
          X := X + 'Unsigned Notes for ';
          if Author > 0 then
            X := X + ExternalName(Author, 200)
          else
            X := X + User.Name;
          X := X + SetDateRangeText(AContext);
        end;
      NC_UNCOSIGNED:
        begin
          X := X + 'Uncosigned Notes for ';
          if Author > 0 then
            X := X + ExternalName(Author, 200)
          else
            X := X + User.Name;
          X := X + SetDateRangeText(AContext);
        end;
      NC_BY_AUTHOR:
        X := X + 'Signed Notes for ' + ExternalName(Author, 200) +
          SetDateRangeText(AContext);
      NC_BY_DATE:
        X := X + 'Signed Notes ' + SetDateRangeText(AContext);
    else
      X := 'Custom List';
    end;
  end;
  Result := X;
end;

procedure TfrmNotes.memNewNoteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  FNavigatingTab := (Key = VK_TAB) and ([ssShift, ssCtrl] * Shift <> []);
  if FNavigatingTab then
    Key := 0;
end;

procedure TfrmNotes.memNewNoteKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if FNavigatingTab then
    Key := #0;  //Disable shift-tab processinend;
end;

procedure TfrmNotes.memNewNoteKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus //previous control
    else if ssCtrl	in Shift then
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
    FNavigatingTab := False;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

procedure TfrmNotes.UpdateNoteAuthor(DocInfo: string);
const
  TX_INVALID_AUTHOR1 = 'The author returned by the template (';
  TX_INVALID_AUTHOR2 = ') is not valid.' + #13#10 +
    'The note''s author will remain as ';
  TC_INVALID_AUTHOR = 'Invalid Author';
  TX_COSIGNER_REQD = ' requires a cosigner for this note.';
  TC_COSIGNER_REQD = 'Cosigner Required';
var
  NewAuth, NewAuthName, AuthNameCheck, X: string;
  ADummySender: TObject;
begin
  if DocInfo = '' then
    exit;
  NewAuth := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_IEN');
  if NewAuth = '' then
    exit;
  AuthNameCheck := ExternalName(StrToInt64Def(NewAuth, 0), 200);
  if AuthNameCheck = '' then
  begin
    NewAuthName := GetXMLParamReturnValueTIU(DocInfo, 'AUTHOR_NAME');
    InfoBox(TX_INVALID_AUTHOR1 + Uppercase(NewAuthName) + TX_INVALID_AUTHOR2 +
      Uppercase(FEditNote.AuthorName), TC_INVALID_AUTHOR,
      MB_OK and MB_ICONERROR);
    exit;
  end;
  with FEditNote do
    if StrToInt64Def(NewAuth, 0) <> Author then
    begin
      Author := StrToInt64Def(NewAuth, 0);
      AuthorName := AuthNameCheck;
      X := lstNotes.Items[EditingIndex];
      SetPiece(X, U, 5, NewAuth + ';' + AuthNameCheck);
      lstNotes.Items[EditingIndex] := X;
      if AskCosignerForTitle(Title, Author, DateTime) then
      begin
        InfoBox(Uppercase(AuthNameCheck) + TX_COSIGNER_REQD,
          TC_COSIGNER_REQD, MB_OK);
        // Cosigner := 0;   CosignerName := '';  // not sure about this yet
        ADummySender := TObject.create;
        try
          cmdChangeClick(ADummySender);
        finally
          FreeAndNil(ADummySender);
        end;
      end
      else
        cmdChangeClick(Self);
    end;
end;

procedure TfrmNotes.UpdatePersonalTemplates;
var
  NeedPersonal: Boolean;
  Node: TTreeNode;

  function FindNode: TTreeNode;
  begin
    Result := Drawers.tvTemplates.Items.GetFirstNode;
    while Assigned(Result) do
    begin
      if (Result.Data = MyTemplate) then
        exit;
      Result := Result.GetNextSibling;
    end;
  end;

begin
  NeedPersonal := (UserTemplateAccessLevel <> taNone);
  if (NeedPersonal <> FHasPersonalTemplates) then
  begin
    if (NeedPersonal) then
    begin
      if (Assigned(MyTemplate)) and (MyTemplate.Children in [tcActive, tcBoth])
      then
      begin
        AddTemplateNode(MyTemplate);
        FHasPersonalTemplates := True;
        if (Assigned(MyTemplate)) then
        begin
          Node := FindNode;
          if (Assigned(Node)) then
            Node.MoveTo(nil, naAddFirst);
        end;
      end;
    end
    else
    begin
      if (Assigned(MyTemplate)) then
      begin
        Node := FindNode;
        if (Assigned(Node)) then
          Node.Delete;
      end;
      FHasPersonalTemplates := FALSE;
    end;
  end;
end;

procedure TfrmNotes.EncounterLocationChanged(Sender: TObject);
begin
  UpdatePersonalTemplates;
end;

procedure TfrmNotes.UpdateActMenu(DocID: String; ListComponent: TComponent );
Var
  WhyNot: string;
  SelectedImageIndex: System.UITypes.TImageIndex;
begin
   Application.ProcessMessages;

   If ListComponent is TORTreeView then begin
    if TORTreeView(ListComponent).Selected = nil then exit;
    SelectedImageIndex := TORTreeView(ListComponent).Selected.ImageIndex;
   end else begin
    if TCaptionListView(ListComponent).Selected = nil then exit;
    SelectedImageIndex := TCaptionListView(ListComponent).Selected.ImageIndex;
   end;

   if uIDNotesActive then
    begin
     mnuActDetachFromIDParent.Enabled := (SelectedImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
     popNoteListDetachFromIDParent.Enabled := mnuActDetachFromIDParent.Enabled;
     if (SelectedImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
      mnuActAttachtoIDParent.Enabled := CanBeAttached(DocID, WhyNot)
     else
      mnuActAttachtoIDParent.Enabled := False;
     popNoteListAttachtoIDParent.Enabled := mnuActAttachtoIDParent.Enabled;
     if (SelectedImageIndex in [IMG_SINGLE, IMG_PARENT,
                        IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                        IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      mnuActAddIDEntry.Enabled := CanReceiveAttachment(DocID, WhyNot)
     else
      mnuActAddIDEntry.Enabled := False;
     popNoteListAddIDEntry.Enabled := mnuActAddIDEntry.Enabled
    end;
end;


procedure TfrmNotes.frmDrawersResize(Sender: TObject);
begin
  inherited;
  if Drawers.DrawerIsOpen then
   Drawers.LastOpenSize := pnlDrawers.Height;
end;

initialization

SpecifyFormIsNotADialog(TfrmNotes);
uPCEEdit := TPCEData.create;
uPCEShow := TPCEData.create;

finalization

if (uPCEEdit <> nil) then
  uPCEEdit.free; // CQ7012 Added test for nil
if (uPCEShow <> nil) then
  uPCEShow.free; // CQ7012 Added test for nil

end.

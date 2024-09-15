unit fNotes;

interface

uses
  fFrame, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,
  dShared, fPage, StdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConst,
  ORDtTm,
  uPCE, ORClasses, ImgList, rTIU, uTIU, uDocTree, fRptBox, fPrintList,
  rMisc, fNoteST, ORNet, fNoteSTStop, fBase508Form, VA508AccessibilityManager,
  uTemplates, VA508ImageListLabeler, RichEdit, mDrawers, ORSplitter,
  System.Actions,
  Vcl.ActnList, ORextensions, U_CPTPasteDetails, Vcl.Grids, Vcl.ValEdit,
  system.Generics.Defaults, UResponsiveGUI;

type
  TProtectedWinControl = class(TWinControl);

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
    memNewNote: ORextensions.TRichEdit;
    stTitle: TVA508StaticText;
    tvNotes: TORTreeView;
    cmdNewNote: TORAlignButton;
    cmdPCE: TORAlignButton;
    lvNotes: TCaptionListView;
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
    memNote: ORextensions.TRichEdit;
    acChange: TAction;
    pnlLeftTop: TPanel;
    splDrawers: TSplitter;
    PnlRight: TPanel;
    splList: TSplitter;
    splHorz: TSplitter;
    CPMemNote: TCopyPasteDetails;
    spDetails: TSplitter;
    CPMemNewNote: TCopyPasteDetails;
    spEditDetails: TSplitter;
    memPCERead: ORExtensions.TRichEdit;
    splmemPCRead: TSplitter;
    memPCEWrite: ORExtensions.TRichEdit;
    splmemPCEWrite: TSplitter;
    grdPnl: TGridPanel;
    lblNewTitle: TStaticText;
    stAuthor: TStaticText;
    lblVisit: TStaticText;
    stRefDate: TStaticText;
    stCosigner: TStaticText;
    cmdChange: TButton;
    lblSubject: TStaticText;
    txtSubject: TCaptionEdit;
    procedure FormShow(Sender: TObject);
    procedure fldAccessRemindersInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessRemindersStateQuery(Sender: TObject; var Text: string);
    procedure fldAccessTemplatesInstructionsQuery(Sender: TObject;
      var Text: string);
    procedure fldAccessTemplatesStateQuery(Sender: TObject; var Text: string);
    procedure mnuChartTabClick(Sender: TObject);
//    procedure mnuViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure tvNotesChange(Sender: TObject; Node: TTreeNode);
    procedure acNewNoteExecute(Sender: TObject);
    procedure memNewNoteChange(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure lvNotesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tvNotesCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvNotesExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvNotesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvNotesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure lvNotesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvNotesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure memNewNoteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    procedure memNewNoteKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memNewNoteKeyPress(Sender: TObject; var Key: Char);
    procedure acNewNoteUpdate(Sender: TObject);
    procedure pnlDrawersResize(Sender: TObject);
    procedure acChangeExecute(Sender: TObject);
    procedure acChangeUpdate(Sender: TObject);
    procedure frmDrawersResize(Sender: TObject);
    procedure pnlWriteResize(Sender: TObject);
    procedure splHorzCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure splDrawersCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure LoadPastedText(Sender: TObject; LoadList: TStrings;
      var ProcessLoad, PreLoaded: Boolean);
    procedure PasteToMonitor(Sender: TObject; var AllowMonitor: Boolean);
    procedure SaveTheMonitor(Sender: TObject; SaveList: TStringList;
      var ReturnList: TStringList);
    procedure CPShow(Sender: TObject);
    procedure CPHide(Sender: TObject);
    procedure tvNotesExit(Sender: TObject);
    procedure pnlNoteExit(Sender: TObject);
    procedure cmdNewNoteExit(Sender: TObject);
    procedure frmFramePnlToolbarExit(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure memPCEWriteExit(Sender: TObject);
    procedure memPCEReadExit(Sender: TObject);
    procedure cmdChangeExit(Sender: TObject);
    procedure cmdPCEExit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure lvNotesClick(Sender: TObject);
    procedure lvNotesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvNotesHint(Sender: TObject; const Node: TTreeNode;
      var Hint: string);
    procedure tvNotesDblClick(Sender: TObject);
    procedure tvNotesCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure tvNotesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvNotesDblClick(Sender: TObject);
    procedure splmemPCEMoved(Sender: TObject);
    procedure grdPnlResize(Sender: TObject);
    procedure PnlRightExit(Sender: TObject);
    procedure frmDrawersExit(Sender: TObject);
    procedure pnlDrawersExit(Sender: TObject);
    procedure pnlLeftExit(Sender: TObject);
  private
    FPreviousControl: TWinControl; // used in ExitToNextControl;
    fExpandedDrawerHeight: Integer;
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
    fReminderToggled: Boolean;
    GlobalSearch: Boolean;
    GlobalSearchTerm: string;
    FormResizing: Boolean;
    PatientToggled: Boolean;
    DrawerConfiguration: TDrawerConfiguration;
    fOnExitSet: Boolean;
    FOldFramePnlToolbarExit: TNotifyEvent;
    FOldDrawerPnlTemplatesButtonExit: TNotifyEvent;
    FOldDrawerPnlEncounterButtonExit: TNotifyEvent;
    FOldDrawerEdtSearchExit: TNotifyEvent;
    fLastDocumentID: String;

    fAllSignedNotes: TStringList; // "All signed notes" cache
    fAllUnSignedNotes: TStringList; // "All unsigned notes" cache
    fAllUnCoSignedNotes: TStringList; // "All uncosigned notes" cache
    LastID: String; // Last selected node prior to "Show More" (fix 336188)
    slExpandStatus: TStringList; // Expand Status of lvNotes (fix 336188)
    FEditNoteIEN: Integer;  // Note IEN for note currently being edited

    FUpdateUnsigned: boolean; // used when clicking Show More when editing a new note
    procedure DrawerButtonClicked(Sender: TObject);
    procedure ClearEditControls;
    procedure DoAutoSave(Suppress: Integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    procedure InsertAddendum(aParentIEN: integer = -1; aParentTitle: string = ''; isSmart: Boolean =false);
    procedure InsertNewNote(IsIDChild: Boolean; AnIDParent: Integer; aNoteIEN: integer = -1; aNoteTitle: string = '');
    function LacksRequiredForCreate: Boolean;
    procedure LoadForEdit;
    function LockConsultRequest(AConsult: Integer): Boolean;
    function LockConsultRequestAndNote(AnIEN: Int64): Boolean;
    procedure RemovePCEFromChanges(IEN: Int64; AVisitStr: string = '');
    procedure SaveEditedNote(var Saved: Boolean);
    procedure SetSubjectVisible(aShow: Boolean);
    function ShowPCEControls(ShouldShow: Boolean): TRichEdit;
    function StartNewEdit(NewNoteType: Integer): Boolean;
    procedure UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
    procedure ProcessNotifications;
    procedure SetViewContext(AContext: TTIUContext);
    function CanFinishReminder: Boolean;
    procedure DisplayPCE;
    procedure ClearPCE;
    // procedure SetPCEParent();
    function VerifyNoteTitle: Boolean;
    // added for treeview

//    procedure LoadNotes(SignedOnly: Boolean = False);

    procedure UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure EnableDisableIDNotes;
    procedure ShowPCEButtons(Editing: Boolean);
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function SetNoteTreeLabel(AContext: TTIUContext): string;
    procedure UpdateNoteAuthor(DocInfo: string);
    procedure UpdatePersonalTemplates;
    procedure AddTemplateNode(const tmpl: TTemplate;
      const Owner: TTreeNode = nil);
    procedure UpdateActMenu(DocID: String; ListComponent: TComponent);
    function GetReadVisible: Boolean;
    procedure SetReadVisible(Value: Boolean);
    procedure ReadToFront;
    function GetReminderToggled: Boolean;
    procedure SetReminderToggled(const Value: Boolean);
    function GetWriteShowing: Boolean;
    procedure SetWriteShowing(const Value: Boolean);
    procedure SetExpandedDrawerHeight(const Value: Integer);
    function GetDrawers: TfraDrawers;
    procedure frmDrawerEdtSearchExit(Sender: TObject);
    procedure frmDrawerPnlTemplatesButtonExit(Sender: TObject);
    procedure frmDrawerPnlEncounterButtonExit(Sender: TObject);

    // procedure SelectNode(aNode:TTreeNode=nil);                   // NSR 20070817
    procedure DoSelect; // NSR 20070817
    procedure GetMoreDocuments(Sender: TObject = nil); // NSR 20070817
    procedure SetLvNotesVisible(aValue: Boolean); // NSR 20070817
    procedure SaveTreePosition; // (fix 336188)
    procedure SaveExpandStatus; // (fix 336188)
    procedure RestoreTreePosition(bStepForward: Boolean = False);
    // (fix 336188)
    procedure RestoreExpandStatus; // (fix 336188)
    function getNodeLocation(aNode: TTreeNode): String; // NSR 20070817
    Procedure UpdateConstraints;
    procedure ClearTVNotes;
  protected
    property WriteShowing: Boolean read GetWriteShowing write SetWriteShowing;
    procedure ExitToNextControl(Sender: TObject);
  public
    procedure LoadNotes(SignedOnly: Boolean = False);

    procedure UpdateNotesCaption(ReloadTotal: boolean = false); // NSR 20070817
    procedure SaveUserSplitterSettings(var posA, posB, posC, posD: Integer);
    procedure LoadUserSplitterSettings(posA, posB, posC, posD: Integer);
    procedure EncounterLocationChanged(Sender: TObject);
    function ActiveEditOf(AnIEN: Int64; ARequest: Integer): Boolean;
    function AllowContextChange(var WhyNot: string): Boolean; override;
    procedure currentlyEditingRecord(var editingText: string);
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure SetFontSize(aNewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure AssignRemForm;
    property OrderID: string read FOrderID;
    procedure LstNotesToPrint;
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetEditingIndex(const Value: Integer);
    procedure LimitEditableNote;
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
    property ReadVisible: Boolean read GetReadVisible write SetReadVisible;
    property ReminderToggled: Boolean read GetReminderToggled
      write SetReminderToggled;
    property ExpandedDrawerHeight: Integer read fExpandedDrawerHeight
      write SetExpandedDrawerHeight;
    function EditedNoteInfo:String;
    property Silent: Boolean read FSilent;

    property EditNoteIEN: Integer read  FEditNoteIEN;  // Note IEN for note currently being edited

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
  fVisit, fEncnt, rCore, uCore, fNoteBA, fNoteBD, fSignItem,
  fEncounterFrame, rPCE, Clipbrd, fNoteCslt, fNotePrt, rVitals, fAddlSigners,
  fNoteDR, fConsults, uSpell, fTIUView, fTemplateEditor, uReminders,
  fReminderDialog, uOrders, rConsults, fReminderTree, fNoteProps, fNotesBP,
  fTemplateFieldEditor, rTemplates, FIconLegend, fPCEEdit,
  fNoteIDParents, rSurgery, uSurgery, fTemplateDialog, DateUtils, uInit,
  uVA508CPRSCompatibility, VA508AccessibilityRouter, fFocusedControls,
  System.Types, rECS, TRPCB, uGlobalVar, System.UITypes, fNotificationProcessor,
  System.IniFiles, ORNetIntf, U_CPTEditMonitor, StrUtils, VAUtils,
  System.Variants, uMisc, uWriteAccess;

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
  TX_NO_NOTE = 'No progress note is currently being edited';
  TX_SAVE_NOTE = 'Save Progress Note';
  TX_ADDEND_NO = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK = CRLF + CRLF + 'Delete this progress note?';
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

  targetAllSignedNotes = 'All signed notes'; // NSR 20070817
  targetSignedByDateRange = 'Signed notes by date range'; // NSR 20070817

var
  uPCEMaster: TPCEData;
  ViewContext: Integer;
  uTIUContext: TTIUContext;
  ColumnToSort: Integer;
  ColumnSortForward: Boolean;
  uChanging: Boolean;
  uIDNotesActive: Boolean;
  NoteTotal: string;
  NewNoteRunning: Boolean;

{$R *.dfm}
  { TfrmNNotes }

function TfrmNotes.GetDrawers: TfraDrawers;
begin
  Result := frmDrawers;
end;

procedure TfrmNotes.SetReadVisible(Value: Boolean);
begin
  pnlNote.Visible := Value;
  // splList.Visible := Value;
  WriteShowing := not Value;
end;

procedure TfrmNotes.SetReminderToggled(const Value: Boolean);
begin
  fReminderToggled := Value;
  pnlReminder.Visible := Value;
  stTitle.Visible := not Value;
  // pnlNote.Visible := not Value;
  ReadVisible := not Value;
  WriteShowing := not Value;
  // pnlWrite.Visible := not Value;
  // splList.Visible := not Value;
  ShowPCEControls(not Value);
  // splVert.Visible := not Value;
  // memPCEShow.Visible := not Value;
end;

function TfrmNotes.GetReadVisible;
begin
  Result := pnlNote.Visible;
end;

function TfrmNotes.GetReminderToggled: Boolean;
begin
  Result := fReminderToggled;
end;

{ View menu events ------------------------------------------------------------------------- }
(* --- code is not used - replaced with action - commenting out ---- AA 20160906
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
  // clear the global search
  if GlobalSearch then
  begin
    memNote.SelStart := 0;
    memNote.SelLength := Length(TRichEdit(popNoteMemo.PopupComponent).Text);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := memNote.Color;
    memNote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
    memNote.SelAttributes.Color := clWindowText;
    Style := [];
    memNote.SelAttributes.Style := Style;
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
    NC_RECENT:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        FCurrentContext.MaxDocs := ReturnMaxNotes;
        LoadNotes;
      end;
    NC_ALL:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'All Signed Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    NC_UNSIGNED:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Unsigned Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    // Text Search CQ: HDS00002856 --------------------
    NC_SEARCHTEXT:
      begin;
        SearchTextStopFlag := False;
        if (Sender is TMenuItem) then
        begin
          SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt,
            StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]));
        end
        else if (Sender is TAction) then
        begin
          SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt,
            StringReplace(TAction(Sender).Caption, '&', '', [rfReplaceAll]));
        end;
        with SearchCtxt do
          if Changed then
          begin
            // FCurrentContext.Status := IntToStr(ViewContext);
            frmSearchStop.Show;
            stNotes.Caption := 'Search: ' + SearchString;
            frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
            FCurrentContext.SearchString := SearchString;
            LoadNotes;
            GlobalSearch := true;
            GlobalSearchTerm := SearchString;
            dlgFindText.FindText := GlobalSearchTerm;
            dlgFindText.Options := [];
            dmodShared.FindRichEditTextAll(memNote, dlgFindText, clHighlight,
              [fsItalic, fsBold]);
          end;
        // Only do LoadNotes if something changed
      end;
    // Text Search CQ: HDS00002856 --------------------
    NC_UNCOSIGNED:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Uncosigned Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    NC_BY_AUTHOR:
      begin
        SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
        with AuthCtxt do
          if Changed then
          begin
            FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
            stNotes.Caption := AuthorName + ': Signed Notes';
            FCurrentContext.Status := IntToStr(NC_BY_AUTHOR);
            FCurrentContext.Author := Author;
            FCurrentContext.TreeAscending := Ascending;
            LoadNotes;
          end;
      end;
    NC_BY_DATE:
      begin
        SelectNoteDateRange(Font.Size, FCurrentContext, DateRange);
        with DateRange do
          if Changed then
          begin
            FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
            stNotes.Caption := FormatFMDateTime('mmm dd,yy', FMBeginDate) +
              ' to ' + FormatFMDateTime('mmm dd,yy', FMEndDate) +
              ': Signed Notes';
            FCurrentContext.BeginDate := BeginDate;
            FCurrentContext.EndDate := EndDate;
            FCurrentContext.FMBeginDate := FMBeginDate;
            FCurrentContext.FMEndDate := FMEndDate;
            FCurrentContext.TreeAscending := Ascending;
            FCurrentContext.Status := IntToStr(NC_BY_DATE);
            LoadNotes;
          end;
      end;
    NC_CUSTOM:
      begin
        if (Sender is TMenuItem) or (Sender is TAction) then
          SelectTIUView(Font.Size, true, FCurrentContext, uTIUContext);
        with uTIUContext do
          if Changed then
          begin
            // if MaxDocs = 0 then MaxDocs   := ReturnMaxNotes;
            FCurrentContext.BeginDate := BeginDate;
            FCurrentContext.EndDate := EndDate;
            FCurrentContext.FMBeginDate := FMBeginDate;
            FCurrentContext.FMEndDate := FMEndDate;
            FCurrentContext.Status := Status;
            FCurrentContext.Author := Author;
            FCurrentContext.MaxDocs := MaxDocs;
            FCurrentContext.ShowSubject := ShowSubject;
            // NEW PREFERENCES:
            FCurrentContext.SortBy := SortBy;
            FCurrentContext.ListAscending := ListAscending;
            FCurrentContext.GroupBy := GroupBy;
            FCurrentContext.TreeAscending := TreeAscending;
            FCurrentContext.SearchField := SearchField;
            FCurrentContext.Keyword := Keyword;
            FCurrentContext.Filtered := Filtered;
            LoadNotes;
          end;
      end;
  end; { case }
  stNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    stNotes.Caption := stNotes.Caption + ', containing "' +
      FCurrentContext.SearchString + '"';
  If SearchTextStopFlag then
  begin
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
--- code is not used - replaced with action - commenting out ---- AA 20160906 *)

procedure TfrmNotes.fldAccessRemindersInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odReminders then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmNotes.fldAccessRemindersStateQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odReminders then
    Text := ', Drawer Open'
  else
    Text := ', Drawer Closed';
end;

procedure TfrmNotes.fldAccessTemplatesInstructionsQuery(Sender: TObject;
  var Text: string);
begin
  inherited;
  if Drawers.ActiveDrawer = odTemplates then
    Text := 'to close'
  else
    Text := 'to open';
  Text := Text + ' drawer press space bar';
end;

procedure TfrmNotes.fldAccessTemplatesStateQuery(Sender: TObject;
  var Text: string);
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
var
  i: Integer;
  act: TContainedAction;

begin
  inherited;
  for i := 0 to ActionList.ActionCount - 1 do
  begin
    act := ActionList.Actions[i];
    if (act.Category = 'Action') or (act = acNewNote) or (act = acChange) then
      act.Enabled := WriteAccess(waProgressNotes)
    else if act = acPCE then
      act.Enabled := WriteAccess(waEncounter);
  end;

  FUpdateUnsigned := False;
  acNewNote.Enabled := false;

  NewNoteRunning := False;
  FormResizing := False;

  PatientToggled := False;
  PageID := CT_NOTES;
  EditingIndex := -1;
  FEditNote.LastCosigner := 0;
  FEditNote.LastCosignerName := '';
  FLastNoteID := '';
  Drawers.Init;
  if not WriteAccess(waProgressNoteTemplates) then
  begin
    Drawers.TemplateState := dsDisabled;
    Drawers.ReminderState := dsDisabled;
  end;
  Drawers.NewNoteButton := cmdNewNote;
  Drawers.RichEditControl := memNewNote;
  FImageFlag := TBitmap.Create;
  FDocList := TStringList.Create;
  splDrawers.Enabled := False;
  Drawers.SaveDrawerConfiguration(DrawerConfiguration);
  Drawers.CopyMonitor := CPMemNewNote;
  Drawers.TemplateAccess := WriteAccess(waProgressNoteTemplates);

  // Make sure the screen reader stops and reads these controls
  stTitle.TabStop := ScreenReaderActive;
  stNotes.TabStop := ScreenReaderActive;

  Drawers.OnDrawerButtonClick := DrawerButtonClicked;
  Drawers.OnUpdateVisualsEvent := DrawerButtonClicked;
  fExpandedDrawerHeight := 171;
  // gotten from largest default template drawer and 4x22 space buttons.
  Encounter.Notifier.NotifyWhenChanged(EncounterLocationChanged);

  mnuIconLegend.Visible := not ScreenReaderActive;
  N6.Visible := not ScreenReaderActive;

  // safteynet
  CPMemNote.CopyMonitor := frmFrame.CPAppMon;
  CPMemNewNote.CopyMonitor := frmFrame.CPAppMon;
  // NSR#20070817 (CPRS Progress Notes Display Misleading)
  fLastDocumentID := '';
  fAllSignedNotes := TStringList.Create;
  fAllUnSignedNotes := TStringList.Create;
  fAllUnCoSignedNotes := TStringList.Create;

  fOnExitSet := False;
end;

procedure TfrmNotes.FormShow(Sender: TObject);

  Procedure SetupOnExitCalls(var ResetVar: TNotifyEvent;
    ExitControl: TWinControl; NewCall: TNotifyEvent);
  begin
    if not assigned(ExitControl) then
      raise Exception.Create
        ('Error in SetupOnExitCalls: Exit Controldoes not exist');

    ResetVar := TProtectedWinControl(ExitControl).OnExit;

    if not TEqualityComparer<TNotifyEvent>.
      Default.Equals(TProtectedWinControl(ExitControl).OnExit, NewCall) then
      TProtectedWinControl(ExitControl).OnExit := NewCall;
  end;

begin
  if PatientToggled then
  begin
    Drawers.LoadDrawerConfiguration(DrawerConfiguration);
    PatientToggled := false;
  end;

  if not fOnExitSet then
  begin
    fOnExitSet := True;
    SetupOnExitCalls(FOldFramePnlToolbarExit, frmFrame.pnlToolbar,
      frmFramePnlToolbarExit);
    SetupOnExitCalls(FOldDrawerPnlTemplatesButtonExit, frmDrawers.btnTemplate,
      frmDrawerPnlTemplatesButtonExit);
    SetupOnExitCalls(FOldDrawerPnlEncounterButtonExit, frmDrawers.btnEncounter,
      frmDrawerPnlEncounterButtonExit);
    SetupOnExitCalls(FOldDrawerEdtSearchExit, frmDrawers.edtSearch,
      frmDrawerEdtSearchExit);
  end;

  acNewNote.Enabled := WriteAccess(waProgressNotes);
end;

procedure TfrmNotes.frmDrawerEdtSearchExit(Sender: TObject);
begin
  if assigned(FOldDrawerEdtSearchExit) then
    FOldDrawerEdtSearchExit(Sender);

  ExitToNextControl(Sender);
end;

procedure TfrmNotes.frmDrawerPnlTemplatesButtonExit(Sender: TObject);
begin
  If assigned(FOldDrawerPnlTemplatesButtonExit) then
    FOldDrawerPnlTemplatesButtonExit(Sender);

  ExitToNextControl(Sender);
end;

procedure TfrmNotes.frmDrawerPnlEncounterButtonExit(Sender: TObject);
begin
  if assigned(FOldDrawerPnlEncounterButtonExit) then
    FOldDrawerPnlEncounterButtonExit(Sender);

  ExitToNextControl(Sender);
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
  IS_ID_CHILD = true;
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
    if assigned(frmRemDlg) then
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
    (InfoBox(MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex])
    + AncillaryPackageMessages(lstNotes.ItemIEN, 'DELETE')
    + TX_DEL_OK, TX_DEL_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <>
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
  FConfirmed := False;
  // remove the note
  DeleteSts.Success := true;
  X := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(X, ';', 1), 0);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN) then
    begin
      DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
      if DeleteSts.Success then SendMessage(Application.MainForm.Handle, UM_REMINDERS, 1, 1);
    end;
  if not Changes.Exist(CH_DOC, SavedDocID) then
    UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_DOC, SavedDocID);
  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);
  // note has been deleted, so 1st param = 0
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr, uPCEMaster.VisitIEN);
    // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    LoadNotes;
    // pnlWrite.Visible := FALSE;
    ReadVisible := true;
    UpdateReminderFinish;
    ShowPCEControls(False);
    Drawers.DisplayDrawers(WriteAccess(waProgressNoteTemplates),
      Drawers.ActiveDrawer, [odTemplates], [odTemplates]);
    ShowPCEButtons(False);
  end
  else { if DeleteSts }
    InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
end;

procedure TfrmNotes.acDetachIDNExecute(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: Boolean;
  SavedDocID: string;
begin
  if lstNotes.ItemIEN = 0 then
    exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U,
      tvNotes.Items.GetFirstNode);
  end;
  if (not AssignedAndHasData(tvNotes.Selected)) or
  (not AssignedAndHasData(tvNotes.Selected.Parent)) then
    exit;
  if not CanBeAttached(PDocTreeObject(tvNotes.Selected.Data)^.DocID, WhyNot)
  then
  begin
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
  if DetachEntryFromParent(DocID, WhyNot) then
  begin
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U,
      tvNotes.Items.GetFirstNode);
    if tvNotes.Selected <> nil then
      tvNotes.Selected.Expand(False);
  end
  else
  begin
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
  acEditDialogFields.Enabled := CanEditTemplateFields and
    WriteAccess(waProgressNoteTemplates);
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
  FEditNoteIEN := StrToIntDef(VarToStr(lstNotes.ItemID), 0);
  if not StartNewEdit(NT_ACT_EDIT_NOTE) then
    exit;
  // LoadNotes;
  with tvNotes do
    Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;
  LoadForEdit;
end;

procedure TfrmNotes.acEditSharedExecute(Sender: TObject);
begin
  EditTemplates(Self, False, '', true);
end;

procedure TfrmNotes.acEditSharedUpdate(Sender: TObject);
begin
  acEditShared.Enabled := Drawers.CanEditShared and
    WriteAccess(waProgressNoteTemplates);
end;

procedure TfrmNotes.acEditTemplateExecute(Sender: TObject);
begin
  EditTemplates(Self);
end;

procedure TfrmNotes.acEditTemplateUpdate(Sender: TObject);
begin
  acEditTemplate.Enabled := Drawers.CanEditTemplates and
    WriteAccess(waProgressNoteTemplates);
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
  if lstNotes.ItemIndex = EditingIndex then
  begin
    SaveCurrentNote(Saved);
    if not Saved then
      exit;
    LoadNotes;
    tvNotes.Selected := tvNotes.FindPieceNode(SavedDocID, U,
      tvNotes.Items.GetFirstNode);
  end;
  CanChgCos := CanChangeCosigner(lstNotes.ItemIEN);
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'IDENTIFY SIGNERS');
  ActSucc := ActionSts.Success;
  if CanChgCos and (not ActSucc) then
  begin
    if InfoBox(ActionSts.Reason + CRLF + CRLF +
      'Would you like to change the cosigner?', TX_IN_AUTH,
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = ID_YES then
      SigAction := SG_COSIGNER
    else
      exit;
  end
  else if ActSucc and (not CanChgCos) then
    SigAction := SG_ADDITIONAL
  else if CanChgCos and ActSucc then
    SigAction := SG_BOTH
  else
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    exit;
  end;

  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  Exclusions := TStringList.Create;
  try
    SetCurrentSigners(Exclusions, lstNotes.ItemIEN);

    ARefDate := StrToFloat(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
    SelectAdditionalSigners(Font.Size, lstNotes.ItemIEN, SigAction, Exclusions,
      SignerList, CT_NOTES, ARefDate);
  finally
    Exclusions.Free;
  end;
  case SigAction of
    SG_ADDITIONAL:
      if SignerList.Changed and (SignerList.Signers <> nil) and
        (SignerList.Signers.Count > 0) then
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
  IS_ID_CHILD = False;
  { switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
  if not NewNoteRunning then
  begin
    NewNoteRunning := true;
    try
      {
        BLJ 10 April 2018: The below SHOULD be

        if not (frmFrame.tabPage.TabIndex = CT_NOTES) then

        but somehow the tab order got out of sync with uConst.pas, and we don't have
        time to track down all the places those constants are used to ensure that,
        by fixing the naming, we're not breaking 4 bajillion other things.
      }
      if not (frmFrame.tabPage.TabIndex = CT_ORDERS) then
        exit;
      if StartNewEdit(NT_ACT_NEW_NOTE) then
      begin
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
        end
        else
        begin
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
  acNewNote.Enabled := WriteAccess(waProgressNotes) and
    (not pnlWrite.Visible) and Assigned(frmConsults) and
    (frmConsults.EditingIndex < 0);
end;

procedure TfrmNotes.acNewSharedExecute(Sender: TObject);
begin
  EditTemplates(Self, true, '', true);
end;

procedure TfrmNotes.acNewSharedUpdate(Sender: TObject);
begin
  acNewShared.Enabled := Drawers.CanEditShared and
    WriteAccess(waProgressNoteTemplates);
end;

procedure TfrmNotes.acNewTemplateExecute(Sender: TObject);
begin
  EditTemplates(Self, true);
end;

procedure TfrmNotes.acNewTemplateUpdate(Sender: TObject);
begin
  acNewTemplate.Enabled := Drawers.CanEditTemplates and
    WriteAccess(waProgressNoteTemplates);
end;

procedure TfrmNotes.acPCEExecute(Sender: TObject);
var
  Refresh: Boolean;
  ActionSts: TActionRec;
  AnIEN: Integer;
  PCEObj: TPCEData;

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
//          uPCEShow.CopyPCEData(uPCEEdit);
          PCEObj := uPCEMaster;
        end;
      end;
      Refresh := EditPCEData(PCEObj);
    end
    else
    begin
      UpdatePCE(uPCEMaster);
      Refresh := true;
    end;
    if Refresh and (not frmFrame.Closing) then
      DisplayPCE;
  end;

begin
  inherited;
  if cmdPCE = nil then exit;
  cmdPCE.Enabled := False;
  try
//    if lstNotes.ItemIndex = EditingIndex then
    UpdateEncounterInfo;
//    else
//    begin
//      tmpPCEEdit := TPCEData.Create;
//      try
//        uPCEMaster.CopyPCEData(tmpPCEEdit);
//        UpdateEncounterInfo;
//        tmpPCEEdit.CopyPCEData(uPCEMaster);
//      finally
//        tmpPCEEdit.Free;
//      end;
//    end
  finally
    if cmdPCE <> nil then    // CPRS may have timed out
      cmdPCE.Enabled := WriteAccess(waEncounter);
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
//      mnuViewClick(mnuViewCustom);
      acSignedExecute(mnuViewCustom); // replacing mnu event handler with action
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
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self,
      'Title: ' + FEditNote.TitleName, DocInfo, CPMemNewNote);
    memNewNote.Text := BoilerText.Text;
    //memNewNote.SelStart := Length(memNewNote.Lines.Text); // CQ: 16461
    SpeakStrings(BoilerText);
    UpdateNoteAuthor(DocInfo);
    FChanged := False;
  end;

begin
  inherited;
  if (EditingIndex < 0) or (lstNotes.ItemIndex <> EditingIndex) then
    exit;
  BoilerText := TStringList.Create;
  try
    NoteEmpty := memNewNote.Text = '';
    LoadBoilerPlate(BoilerText, FEditNote.Title, uPCEMaster.VisitString);
    if (BoilerText.Text <> '') or
      assigned(GetLinkedTemplate(IntToStr(FEditNote.Title), ltTitle)) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      if NoteEmpty then
        AssignBoilerText
      else
      begin
        case QueryBoilerPlate(BoilerText) of
          0: { do nothing }
            ; // ignore
          1:
            begin
              ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle,
                Self, 'Title: ' + FEditNote.TitleName, DocInfo, CPMemNewNote);
              memNewNote.Lines.AddStrings(BoilerText);
              SpeakStrings(BoilerText);
              UpdateNoteAuthor(DocInfo);
            end;
          2:
            AssignBoilerText; // replace
        end;
      end;
    end
    else
    begin
      if Sender = mnuActLoadBoiler then
        InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
      else
      begin
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
  needReload: boolean;
begin
  inherited;
  SavedDocID := lstNotes.ItemID; // v22.12 - RV
  FLastNoteID := SavedDocID; // v22.12 - RV
  if lstNotes.ItemIndex = EditingIndex then
  begin // v22.12 - RV
    FDeleted := False;      // incase we delete the not in SaveCurrentNote
    SaveCurrentNote(Saved); // v22.12 - RV
    if (not Saved) or FDeleted then
      exit; // v22.12 - RV
  end
  else if EditingIndex > -1 then
  begin // v22.12 - RV
    tmpItem := lstNotes.Items[EditingIndex]; // v22.12 - RV
    EditingID := Piece(tmpItem, U, 1); // v22.12 - RV
  end; // v22.12 - RV
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
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  // no exits after things are locked
  NoteUnlocked := False;
  needReload := True;
  ActOnDocument(ActionSts, lstNotes.ItemIEN, ActionType);
  if ActionSts.Success then
  begin
    OK := IsOK2Sign(uPCEMaster, lstNotes.ItemIEN);
    if frmFrame.Closing then
      exit;
    if (uPCEMaster.Updated) then
    begin
//      uPCEShow.CopyPCEData(uPCEEdit);
      uPCEMaster.Updated := False;
      lstNotesClick(Self);
    end;
    if not AuthorSignedDocument(lstNotes.ItemIEN) then
    begin
      if (InfoBox(TX_AUTH_SIGNED + GetTitleText(lstNotes.ItemIndex), TX_SIGN,
        MB_YESNO) = ID_NO) then
        exit;
    end;
    if (OK) then
    begin
      SignatureForItem(Font.Size,
        MakeNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]),
        SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
        Changes.Remove(CH_DOC, lstNotes.ItemID);
        // this will unlock if in Changes
        if SignSts.Success then
        begin
          if frmConsults.EditingIndex = -1 then
            SendMessage(frmConsults.Handle, UM_NEWORDER, ORDER_SIGN,
              0); { *REV* }
          lstNotesClick(Self);
        end
        else
          InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end { if Length(ESCode) }
      else
        NoteUnlocked := Changes.Exist(CH_DOC, lstNotes.ItemID);
    end;
  end
  else
  begin
    needReload := False;
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  end;
  if not NoteUnlocked then
    UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN);
  if needReload then
  begin
    LoadNotes; // v22.12 - RV
    if (EditingID <> '') then
    begin
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
    tvNotes.Selected := tvNotes.FindPieceNode(FLastNoteID, U,
      tvNotes.Items.GetFirstNode);
    if tvNotes.Selected <> nil then
      tvNotesChange(Self, tvNotes.Selected)
    else
      If tvNotes.Items.Count > 0 then
        tvNotes.Selected := tvNotes.Items[0]; // first Node in treeview
    updateNotesCaption(True);
  end;
end;

procedure TfrmNotes.AddTemplateNode(const tmpl: TTemplate;
  const Owner: TTreeNode);
begin
  dmodShared.AddTemplateNode(Drawers.tvTemplates, FEmptyNodeCount, tmpl,
    False, Owner);
end;

{ TPage common methods --------------------------------------------------------------------- }
function TfrmNotes.AllowContextChange(var WhyNot: string): Boolean;
begin
  dlgFindText.CloseDialog;
  Result := inherited AllowContextChange(WhyNot); // sets result = true
  if assigned(frmTemplateDialog) then
  begin
    if Screen.ActiveForm = frmTemplateDialog then
    begin
      // if (fsModal in frmTemplateDialog.FormState) then
      case BOOLCHAR[frmFrame.CCOWContextChanging] of
        '1':
          begin
            WhyNot := 'A template in progress will be aborted.  ';
            Result := False;
          end;
        '0':
          begin
            if WhyNot = 'COMMIT' then
            begin
              FSilent := true;
              frmTemplateDialog.Silent := true;
              frmTemplateDialog.ModalResult := mrCancel;
            end;
          end;
      end;
    end;
  end;
  if assigned(frmRemDlg) then
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1':
        begin
          WhyNot := 'All current reminder processing information will be discarded.  ';
          Result := False;
        end;
      '0':
        begin
          if WhyNot = 'COMMIT' then
          begin
            FSilent := true;
            frmRemDlg.Silent := true;
            frmRemDlg.btnCancelClick(Self);
          end;
          // agp fix for a problem with reminders not clearing out when switching patients
          if WhyNot = '' then
          begin
            frmRemDlg.btnCancelClick(Self);
            if assigned(frmRemDlg) then
            begin
              Result := False;
              exit;
            end;
          end;
        end;
    end;
  if EditingIndex <> -1 then
  begin
    case BOOLCHAR[frmFrame.CCOWContextChanging] of
      '1':
        begin
          if memNewNote.GetTextLen > 0 then
            WhyNot := WhyNot + 'A note in progress will be saved as unsigned.  '
          else
            WhyNot := WhyNot + 'An empty note in progress will be deleted.  ';
          Result := False;
        end;
      '0':
        begin
          if WhyNot = 'COMMIT' then
            FSilent := true;
          SaveCurrentNote(Result);
        end;
    end;
  end;
  if assigned(frmEncounterFrame) then
  begin
    if Screen.ActiveForm = frmEncounterFrame then
    begin
      case BOOLCHAR[frmFrame.CCOWContextChanging] of
        '1':
          begin
            WhyNot := WhyNot +
              'Encounter information being edited will not be saved';
            Result := False;
          end;
        '0':
          begin
            if WhyNot = 'COMMIT' then
            begin
              FSilent := true;
              frmEncounterFrame.Abort := False;
              frmEncounterFrame.Cancel := true;
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
  AParentID := frmPrintList.SelectParentFromList(tvNotes, CT_NOTES);
  if AParentID = '' then
    exit;
  with tvNotes do
    Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
end;

procedure TfrmNotes.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  uChanging := true;
  tvNotes.Items.BeginUpdate;
  try
    ClearTVNotes;
  finally
    tvNotes.Items.EndUpdate;
  end;
  lvNotes.Items.Clear;
  uChanging := False;
  lstNotes.Clear;
  memNote.Clear;
  ClearPCE;
  // memPCEShow.Clear;
  uPCEMaster.Clear;
  Drawers.SaveDrawerConfiguration(DrawerConfiguration);
  PatientToggled := true;
  Drawers.ResetTemplates;
  CallVistA('ORCNOTE GET TOTAL', [Patient.DFN], NoteTotal);
  CPMemNote.EditMonitor.ItemIEN := -1;
  CPMemNewNote.EditMonitor.ItemIEN := -1;
  fAllSignedNotes.Clear;
  fAllUnSignedNotes.Clear;
  fAllUnCoSignedNotes.Clear;
end;

procedure TfrmNotes.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  LockDrawing;
  try
    inherited DisplayPage;
    CurrentTabPCEObject := uPCEMaster;
    frmFrame.ShowHideChartTabMenus(mnuViewChart);
    frmFrame.mnuFilePrint.Tag := CT_NOTES;
    frmFrame.mnuFilePrint.Enabled := true;
    frmFrame.mnuFilePrintSetup.Enabled := true;
    frmFrame.mnuFilePrintSelectedItems.Enabled := true;
    if InitPage then
    begin
      EnableDisableIDNotes;
      FDefaultContext := GetCurrentTIUContext;
      FCurrentContext := FDefaultContext;
      popNoteMemoSpell.Visible := SpellCheckAvailable;
      popNoteMemoGrammar.Visible := popNoteMemoSpell.Visible;
      Z11.Visible := popNoteMemoSpell.Visible;
      timAutoSave.Interval := User.AutoSave * 1000;
      // convert seconds to milliseconds
      SetEqualTabStops(memNewNote);
    end;
    // to indent the right margin need to set Paragraph.RightIndent for each paragraph?
    if InitPatient and not(CallingContext = CC_NOTIFICATION) then
    begin
      SetViewContext(FDefaultContext);
    end;
    case CallingContext of
      CC_INIT_PATIENT:
        if not InitPatient then
        begin
          SetViewContext(FDefaultContext);
        end;
      CC_NOTIFICATION:
        ProcessNotifications;
    end;
  finally
    UnlockDrawing;
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
      if not Saved then
        exit;
    end;
    if ItemIEN > 0 then
      PrintNote(ItemIEN, MakeNoteDisplayText(Items[ItemIndex]))
    else
    begin
      if ItemIEN = 0 then
        InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
      if ItemIEN < 0 then
        InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

{ for printing multiple notes }
procedure TfrmNotes.RequestMultiplePrint(AForm: TfrmPrintList);
var
  NoteIEN: Int64;
  i: Integer;
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
          PrintNote(NoteIEN, DisplayText[i], true)
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

procedure TfrmNotes.SetFontSize(aNewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  //inherited SetFontSize(NewFontSize);
//  Self.Font.Assign(Screen.IconFont);
  Self.Font.Size := aNewFontSize;
  SetSubjectVisible(txtSubject.Visible);

  SetEqualTabStops(memNewNote);
  memNote.Font.Size := aNewFontSize;
  memNewNote.Font.Size := aNewFontSize;
  memPCEWrite.Font.Size := aNewFontSize;
  memPCERead.Font.Size := aNewFontSize;
  cmdChange.Font.Size := aNewFontSize;
  AutoSizeColumns(lvNotes, [0]);
  //Update the constraints based on the font
  UpdateConstraints;
end;

Procedure TfrmNotes.UpdateConstraints;
const
  LEFT_MARGIN = 4;
var
 MinWdth: Integer;
 SrcRich: TRichEdit;
begin

  //Maybe dot need this since the fonts should be the same
  if ReadVisible then
    SrcRich := memNote
  else
    SrcRich := memNewNote;

  //What is the min width these notes should be
  MinWdth := TextWidthByFont(SrcRich.Font.Handle, StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;

  //Set the minimum size
  PnlRight.Constraints.MinWidth := MinWdth;

  //Set the edit width based on the update
  LimitEditableNote;
end;

procedure TfrmNotes.ClearTVNotes;
begin
  // prevent calling OnChange while clearing the tree
  tvNotes.OnChange := nil;
  try
    KillDocTreeObjects(tvNotes);
    tvNotes.Items.Clear;
  finally
    tvNotes.OnChange := tvNotesChange;
  end;
end;

procedure TfrmNotes.LimitEditableNote;
begin
  //Adjust the editable rectange
  LimitEditWidth(memNewNote, MAX_PROGRESSNOTE_WIDTH - 1);
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmNotes.ClearEditControls;
{ resets controls used for entering a new progress note }
begin
  // clear FEditNote (should FEditNote be an object with a clear method?)
  with FEditNote do
  begin
    DocType := 0;
    Title := 0;
    TitleName := '';
    DateTime := 0;
    Author := 0;
    AuthorName := '';
    Cosigner := 0;
    CosignerName := '';
    Subject := '';
    Location := 0;
    LocationName := '';
    PkgIEN := 0;
    PkgPtr := '';
    PkgRef := '';
    NeedCPT := False;
    Addend := 0;
    { LastCosigner & LastCosignerName aren't cleared because they're used as default for next note. }
    Lines := nil;
    PRF_IEN := 0;
    ActionIEN := '';
  end;
  // clear the editing controls (also clear the new labels?)
  txtSubject.Text := '';
  // lblNotes.Caption := '';   CQ20356
  SearchTextStopFlag := False;
  if memNewNote <> nil then
    memNewNote.Clear; // CQ7012 Added test for nil
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  if assigned(uPCEMaster) then
    uPCEMaster.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  FChanged := False;
  CPMemNewNote.EditMonitor.ItemIEN := -1;
end;

function TfrmNotes.ShowPCEControls(ShouldShow: Boolean): TRichEdit;
begin
  if pnlWrite.Visible then
  begin
    Result := memPCEWrite;
    splmemPCEWrite.Visible := ShouldShow;
    memPCEWrite.Visible := ShouldShow;

    // stuff at the bottom
    memPCEWrite.Top := pnlWrite.Top + pnlWrite.height;
    splmemPCEWrite.Top := memPCEWrite.Top - 1;
    pnlWrite.Realign;
  end
  else
  begin
    Result := memPCERead;
    splmemPCRead.Visible := ShouldShow;
    memPCERead.Visible := ShouldShow;

    // stuff at the bottom
    memPCERead.Top := pnlNote.Top + pnlNote.height;
    splmemPCRead.Top := memPCERead.Top - 1;
    pnlNote.Realign;
  end;
end;

procedure TfrmNotes.splHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  if NewSize > frmNotes.ClientWidth - PnlRight.Constraints.MinWidth - splHorz.Width then
  begin
    NewSize := frmNotes.ClientWidth - PnlRight.Constraints.MinWidth - splHorz.Width - 1;
    accept := false;
  end;

  inherited;
end;

procedure TfrmNotes.splmemPCEMoved(Sender: TObject);
var
  ReturnEvt: TNotifyEvent;
begin
  inherited;
  ReturnEvt := TSplitter(Sender).OnMoved;
  TSplitter(Sender).OnMoved := nil;
  try
    if Sender = splmemPCEWrite then
      memPCERead.height := memPCEWrite.height
    else if Sender = splmemPCRead then
      memPCEWrite.height := memPCERead.height;
  finally
    TSplitter(Sender).OnMoved := ReturnEvt;
  end;
end;

procedure TfrmNotes.splDrawersCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
var
  Min_NoteList_Height: Integer;
begin
  Min_NoteList_Height := tvNotes.Constraints.MinHeight + splDrawers.height + 3;
  if pnlLeftTop.height - NewSize < Min_NoteList_Height then
  begin
    pnlDrawers.height := pnlDrawers.height -
      (Min_NoteList_Height - tvNotes.height);
    Accept := False;
  end;
  inherited;
end;

{
procedure TfrmNotes.SetPCEParent();
begin
  memPCEShow.Visible := fPCEShowing;
  SplVert.Visible := fPCEShowing;
  if pnlNote.Visible then
  begin
    memPCEShow.Parent := pnlNote;
    SplVert.Parent := pnlNote;
    if CPMemNote.Visible then
    begin
      SplVert.Top := CPMemNote.Top + CPMemNote.height + 1;
      // Under the copy/paste panel
      memPCEShow.Top := SplVert.Top + SplVert.height + 1; // under the splitter
    end
    else
    begin
      SplVert.Top := memNote.Top + memNote.height + 1;
      memPCEShow.Top := SplVert.height + SplVert.Top + 1;
    end;
  end
  else
  begin
    memPCEShow.Parent := pnlWrite;
    SplVert.Parent := pnlWrite;
    if CPMemNewNote.Visible then
    begin
      SplVert.Top := CPMemNote.Top + CPMemNote.height + 1;
      memPCEShow.Top := SplVert.height + SplVert.Top + 1;
    end
    else
    begin
      SplVert.Top := memNewNote.Top + memNewNote.height + 1;
      memPCEShow.Top := SplVert.height + SplVert.Top + 1;
    end;

  end;
end;
}
procedure TfrmNotes.ClearPCE;
begin
  //
  memPCERead.Clear;
  memPCEWrite.Clear;
end;

procedure TfrmNotes.DisplayPCE;
{ displays PCE information if appropriate & enables/disabled editing of PCE data }
var
  EnableList, ShowList: TDrawers;
  VitalStr: TStringList;
  NoPCE: Boolean;
  ActionSts: TActionRec;
  AnIEN: Integer;
  PCE2Use: TRichEdit;
  PCEList: TStringList;
begin
  ClearPCE;
  PCEList := TStringList.Create;
  try
    if lstNotes.ItemIndex = EditingIndex then
    begin
      uPCEMaster.NoteDateTime := FEditNote.DateTime;
      uPCEMaster.PCEForNote(FEditNoteIEN);
      uPCEMaster.AddStrData(PCEList);
      NoPCE := (PCEList.Count = 0);
      VitalStr := TStringList.Create;
      try
        GetVitalsFromDate(VitalStr, uPCEMaster);
        uPCEMaster.AddVitalData(VitalStr, PCEList);
      finally
        VitalStr.Free;
      end;
      ShowPCEButtons(true);
      PCE2Use := ShowPCEControls(cmdPCE.Enabled or (PCEList.Count > 0));

      if PCEList.Count > 0 then
        PCE2Use.Lines.AddStrings(PCEList);

      if (NoPCE and PCE2Use.Visible) then
        PCE2Use.Lines.Insert(0, TX_NOPCE);
      PCE2Use.SelStart := 0;
      PCE2Use.Perform(EM_LineScroll, 0, Low(Integer));
      if (InteractiveRemindersActive) then
      begin
        if (GetReminderStatus = rsNone) then
          EnableList := [odTemplates]
        else if FutureEncounter(uPCEMaster) and (not SpansIntlDateLine) then
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
      Drawers.DisplayDrawers(WriteAccess(waProgressNoteTemplates),
        Drawers.ActiveDrawer, EnableList, ShowList);
    end
    else
    begin
      ShowPCEButtons(False);
      Drawers.DisplayDrawers(WriteAccess(waProgressNoteTemplates),
        Drawers.ActiveDrawer, [odTemplates], [odTemplates]);
      AnIEN := lstNotes.ItemIEN;
      ActOnDocument(ActionSts, AnIEN, 'VIEW');
      if ActionSts.Success then
      begin
        StatusText('Retrieving encounter information...');

        if lstNotes.ItemIndex > -1 then
        begin
          uPCEMaster.NoteDateTime :=
            MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
        end else begin
          uPCEMaster.NoteDateTime := 0;
        end;

        uPCEMaster.PCEForNote(AnIEN);
        uPCEMaster.AddStrData(PCEList);
        NoPCE := (PCEList.Count = 0);
        VitalStr := TStringList.Create;
        try
          GetVitalsFromNote(VitalStr, uPCEMaster, AnIEN);
          uPCEMaster.AddVitalData(VitalStr, PCEList);
        finally
          VitalStr.Free;
        end;
        PCE2Use := ShowPCEControls(PCEList.Count > 0);

        if PCEList.Count > 0 then
          PCE2Use.Lines.AddStrings(PCEList);

        if (NoPCE and PCE2Use.Visible) then
          PCE2Use.Lines.Insert(0, TX_NOPCE);
        PCE2Use.SelStart := 0;
        PCE2Use.Perform(EM_LineScroll, 0, Low(Integer));
        StatusText('');
      end
      else
        ShowPCEControls(False);
    end;
    mnuEncounter.Enabled := WriteAccess(waEncounter) and cmdPCE.Visible;
    // SetPCEParent;
  finally
    PCEList.Free;
  end;
end;

{ supporting calls for writing notes }

function TfrmNotes.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
begin
  if (lstNotes.Items.Count > AnIndex) then
  begin
    Result := FormatFMDateTime('mmm dd,yy',
      MakeFMDateTime(Piece(lstNotes.Items[AnIndex], U, 3))) + '  ' +
      Piece(lstNotes.Items[AnIndex], U, 2) + ', ' +
      Piece(lstNotes.Items[AnIndex], U, 6) + ', ' +
      Piece(Piece(lstNotes.Items[AnIndex], U, 5), ';', 2);
  end
  else
  begin
    Result := '';
  end;
end;

function TfrmNotes.GetWriteShowing: Boolean;
begin
  Result := pnlWrite.Visible;
end;

procedure TfrmNotes.grdPnlResize(Sender: TObject);
begin
  inherited;
  SetSubjectVisible(txtSubject.Visible);
end;

function TfrmNotes.LacksRequiredForCreate: Boolean;
{ determines if the fields required to create the note are present }
var
  CurTitle: Integer;
begin
  Result := False;
  with FEditNote do
  begin
    if Title <= 0 then
      Result := true;
    if Author <= 0 then
      Result := true;
    if DateTime <= 0 then
      Result := true;
    if IsConsultTitle(Title) and (PkgIEN = 0) then
      Result := true;
    if IsSurgeryTitle(Title) and (PkgIEN = 0) then
      Result := true;
    if IsPRFTitle(Title) and (PRF_IEN = 0) and (not DocType = TYP_ADDENDUM) then
      Result := true;
    if (DocType = TYP_ADDENDUM) then
    begin
      if AskCosignerForDocument(Addend, Author, DateTime) and (Cosigner <= 0)
      then
        Result := true;
    end
    else
    begin
      if Title > 0 then
        CurTitle := Title
      else
        CurTitle := DocType;
      if AskCosignerForTitle(CurTitle, Author, DateTime) and (Cosigner <= 0)
      then
        Result := true;
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

procedure TfrmNotes.SetSubjectVisible(aShow: Boolean);
var
  r1, r2, r3, a1Row, a2Rows, aTextHeight: integer;

  function RowHeight(lbl: array of TStaticText): integer;
  var
    i: integer;

  begin
    Result := a1Row;
    for i := Low(lbl) to High(lbl) do
    begin
      if Canvas.TextWidth(lbl[i].Caption) > lbl[i].Width then
      begin
        Result := a2Rows;
        exit;
      end;
    end;
  end;

begin
  lblSubject.Visible := aShow;
  txtSubject.Visible := aShow;
  aTextHeight := Self.Canvas.TextHeight('|');
  a1Row := Trunc(aTextHeight * 1.4);
  a2Rows := a1Row + aTextHeight;
  inc(a1Row, 6);
  r1 := RowHeight([lblNewTitle, stAuthor]);
  r2 := RowHeight([lblVisit, stRefDate, stCosigner]);
  if aShow then
    r3 := a1Row
  else
    r3 := 0;

  if GrdPnl.ColumnCollection.Count > 4 then
  begin
    grdpnl.ColumnCollection.BeginUpdate;
    try
      if aShow then
      begin
        grdpnl.ColumnCollection[0].SizeStyle := ssAbsolute;
        grdpnl.ColumnCollection[0].Value := Trunc(Self.Canvas.TextWidth(lblSubject.Caption) * 1.1);
      end;
      grdpnl.ColumnCollection[4].SizeStyle := ssAbsolute;
      grdpnl.ColumnCollection[4].Value := Trunc(Self.Canvas.TextWidth(cmdChange.Caption) * 1.4);
    finally
      grdpnl.ColumnCollection.EndUpdate;
    end;
  end;

  if grdPnl.RowCollection.Count > 2 then
  begin
    grdpnl.RowCollection.BeginUpdate;
    try
      grdpnl.RowCollection[0].SizeStyle := ssAbsolute;
      grdpnl.RowCollection[0].Value := r1;
      grdpnl.RowCollection[1].SizeStyle := ssAbsolute;
      grdpnl.RowCollection[1].Value := r2;
      grdpnl.RowCollection[2].SizeStyle := ssAbsolute;
      grdpnl.RowCollection[2].Value := r3;
      grdpnl.Height := r1 + r2 + r3;
    finally
      grdpnl.RowCollection.EndUpdate;
    end;
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
    Result := False;
    exit;
  end;
  if (FOrderID <> '') then
    if not OrderCanBeLocked(FOrderID) then
      Result := False;
  if not Result then
    FOrderID := '';
end;

function TfrmNotes.LockConsultRequestAndNote(AnIEN: Int64): Boolean;
{ returns true if note and associated request successfully locked }
var
  AConsult: Integer;
  LockMsg, X: string;
begin
  Result := true;
  AConsult := 0;
  if frmConsults.ActiveEditOf(AnIEN) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := False;
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
  if AConsult = 0 then
    AConsult := GetConsultIENForNote(ANote);
  if AConsult > 0 then
  begin
    FOrderID := GetConsultOrderIEN(AConsult);
    UnlockOrderIfAble(FOrderID);
    FOrderID := '';
  end;
end;

function TfrmNotes.ActiveEditOf(AnIEN: Int64; ARequest: Integer): Boolean;
begin
  Result := False;
  if EditingIndex < 0 then
    exit;
  if lstNotes.GetIEN(EditingIndex) = AnIEN then
  begin
    Result := true;
    exit;
  end;
  with FEditNote do
    if (PkgIEN = ARequest) and (PkgPtr = PKG_CONSULTS) then
      Result := true;
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

procedure TfrmNotes.acSignedExecute(Sender: TObject);

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
  // clear the global search
  If GlobalSearch then
  begin
    memNote.SelStart := 0;
    memNote.SelLength := Length(TRichEdit(popNoteMemo.PopupComponent).Text);
    Format.cbSize := SizeOf(Format);
    Format.dwMask := CFM_BACKCOLOR;
    Format.crBackColor := memNote.Color;
    memNote.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
    memNote.SelAttributes.Color := clWindowText;
    Style := [];
    memNote.SelAttributes.Style := Style;
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

  if (Sender is TAction) then
  begin
    ViewContext := TAction(Sender).Tag;
  end
  else if (Sender is TMenuItem) then
  begin
    ViewContext := TMenuItem(Sender).Tag;
  end
  else if FCurrentContext.Status <> '' then
  begin
    ViewContext := NC_CUSTOM;
  end
  else
  begin
    ViewContext := NC_RECENT;
  end;

  case ViewContext of
    NC_RECENT:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Last ' + IntToStr(ReturnMaxNotes) + ' Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        FCurrentContext.MaxDocs := ReturnMaxNotes;
        LoadNotes;
      end;
    NC_ALL:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'All Signed Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    NC_UNSIGNED:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Unsigned Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    // Text Search CQ: HDS00002856 --------------------
    NC_SEARCHTEXT:
      begin;
        SearchTextStopFlag := False;
        if (Sender is TMenuItem) then
        begin
          SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt,
            StringReplace(TMenuItem(Sender).Caption, '&', '', [rfReplaceAll]));
        end
        else if (Sender is TAction) then
        begin
          SelectSearchText(Font.Size, FCurrentContext.SearchString, SearchCtxt,
            StringReplace(TAction(Sender).Caption, '&', '', [rfReplaceAll]));
        end;
        with SearchCtxt do
          if Changed then
          begin
            // FCurrentContext.Status := IntToStr(ViewContext);
            frmSearchStop.Show;
            stNotes.Caption := 'Search: ' + SearchString;
            frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
            FCurrentContext.SearchString := SearchString;
            LoadNotes;
            GlobalSearch := true;
            GlobalSearchTerm := SearchString;
            dlgFindText.FindText := GlobalSearchTerm;
            dlgFindText.Options := [];
            dmodShared.FindRichEditTextAll(memNote, dlgFindText, clHighlight,
              [fsItalic, fsBold]);
          end;
        // Only do LoadNotes if something changed
      end;
    // Text Search CQ: HDS00002856 --------------------
    NC_UNCOSIGNED:
      begin
        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
        stNotes.Caption := 'Uncosigned Notes';
        FCurrentContext.Status := IntToStr(ViewContext);
        LoadNotes;
      end;
    NC_BY_AUTHOR:
      begin
        SelectAuthor(Font.Size, FCurrentContext, AuthCtxt);
        with AuthCtxt do
          if Changed then
          begin
            FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
            stNotes.Caption := AuthorName + ': Signed Notes';
            FCurrentContext.Status := IntToStr(NC_BY_AUTHOR);
            FCurrentContext.Author := Author;
            FCurrentContext.TreeAscending := Ascending;
            LoadNotes;
          end;
      end;
    NC_BY_DATE:
      begin
        SelectNoteDateRange(Font.Size, FCurrentContext, DateRange);
        with DateRange do
          if Changed then
          begin
            FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
            stNotes.Caption := FormatFMDateTime('mmm dd,yy', FMBeginDate) +
              ' to ' + FormatFMDateTime('mmm dd,yy', FMEndDate) +
              ': Signed Notes';
            FCurrentContext.BeginDate := BeginDate;
            FCurrentContext.EndDate := EndDate;
            FCurrentContext.FMBeginDate := FMBeginDate;
            FCurrentContext.FMEndDate := FMEndDate;
            FCurrentContext.TreeAscending := Ascending;
            FCurrentContext.Status := IntToStr(NC_BY_DATE);
            LoadNotes;
          end;
      end;
    NC_CUSTOM:
      begin
        if (Sender is TMenuItem) or (Sender is TAction) then
        begin
          SelectTIUView(Font.Size, true, FCurrentContext, uTIUContext);
          // lblNotes.Caption := 'Custom List';
        end;
        with uTIUContext do
          if Changed then
          begin
            // if MaxDocs = 0 then MaxDocs   := ReturnMaxNotes;
            FCurrentContext.BeginDate := BeginDate;
            FCurrentContext.EndDate := EndDate;
            FCurrentContext.FMBeginDate := FMBeginDate;
            FCurrentContext.FMEndDate := FMEndDate;
            FCurrentContext.Status := Status;
            FCurrentContext.Author := Author;
            FCurrentContext.MaxDocs := MaxDocs;
            FCurrentContext.ShowSubject := ShowSubject;
            // NEW PREFERENCES:
            FCurrentContext.SortBy := SortBy;
            FCurrentContext.ListAscending := ListAscending;
            FCurrentContext.GroupBy := GroupBy;
            FCurrentContext.TreeAscending := TreeAscending;
            FCurrentContext.SearchField := SearchField;
            FCurrentContext.Keyword := Keyword;
            FCurrentContext.Filtered := Filtered;
            LoadNotes;
          end;
      end;
  end; { case }
  stNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  // Text Search CQ: HDS00002856 --------------------
  If FCurrentContext.SearchString <> '' then
    stNotes.Caption := stNotes.Caption + ', containing "' +
      FCurrentContext.SearchString + '"';
  If SearchTextStopFlag then
  begin
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
    CPMemNote.LoadPasteText();
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
  acViewHealthEVet.Enabled := not(Copy(frmFrame.laMHV.hint, 1, 2) = 'No');
end;

{ create, edit & save notes }

procedure TfrmNotes.InsertNewNote(IsIDChild: Boolean; AnIDParent: Integer;
  aNoteIEN: Integer = -1; aNoteTitle: string = '');
{ creates the editing context for a new progress note & inserts stub into top of view list }
var
  EnableAutosave, HaveRequired, RetryAction: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  tmpNode: TTreeNode;
  X, WhyNot, DocInfo: string;
  aStr: string;
  NoteErrorAction: TNoteErrorReturn;
begin
  if frmFrame.TimedOut then
    exit;
  FNewIDChild := IsIDChild;
  EnableAutosave := False;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    FillChar(FEditNote, SizeOf(FEditNote), 0); // v15.7
    with FEditNote do
    begin
      DocType := TYP_PROGRESS_NOTE;
      IsNewNote := true;
      If aNoteIEN > -1 then
      begin
        Title := aNoteIEN;
        TitleName := aNoteTitle
      end
      else
      begin
        Title := DfltNoteTitle;
        TitleName := DfltNoteTitleName;
      end;

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

    // if aNoteIEN was passed in, VerifyNoteTitle is overridden
    If LacksRequiredForCreate or (VerifyNoteTitle and (aNoteIEN < 0)) or
      uUnresolvedConsults.UnresolvedConsultsExist then
      HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IsIDChild,
        FNewIDChild, '', 0)
    else
      HaveRequired := true;

    // lock the consult request if there is a consult
    with FEditNote do
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
        HaveRequired := LockConsultRequest(PkgIEN);
    if HaveRequired then
    begin
      // set up uPCEMaster for entry of new note
      uPCEMaster.UseEncounter := true;
      uPCEMaster.NoteDateTime := FEditNote.DateTime;
      uPCEMaster.PCEForNote(USE_CURRENT_VISITSTR);
      FEditNote.NeedCPT := uPCEMaster.CPTRequired;
      repeat
        RetryAction := False;
        // create the note
        PutNewNote(CreatedNote, FEditNote);

        if CreatedNote.IEN = 0 then
        begin
          NoteErrorAction := ShowNewNoteError('note', CreatedNote.ErrorText,
            FEditNote.Lines, False, True);
          RetryAction := NoteErrorAction = neRetry;

          if NoteErrorAction = neAbort then
          begin
            // if note creation failed or failed to get note lock (both unlikely), unlock consult
            with FEditNote do
              if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
                UnlockConsultRequest(0, PkgIEN);
            InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
            HaveRequired := False;
          end;
        end;

      until not RetryAction;

      FEditNoteIEN := CreatedNote.IEN;
      uPCEMaster.NoteIEN := CreatedNote.IEN;
      if CreatedNote.IEN > 0 then
        LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
      if (CreatedNote.IEN > 0) and (CreatedNote.ErrorText = '') then
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
          begin
            CallVistA('TIU LINK TO FLAG', [CreatedNote.IEN, PRF_IEN, ActionIEN,
              Patient.DFN], aStr);
            if aStr = '0' then
              ShowMsg('TIU LINK TO FLAG: FAILED');
          end;
        end;

        lstNotes.Items.Insert(0, X);
        uChanging := true;
        tvNotes.Items.BeginUpdate;
        try
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
          end
          else
          begin
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
        finally
          tvNotes.Items.EndUpdate;
        end;
        uChanging := False;
        Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
        lstNotes.ItemIndex := 0;
        EditingIndex := 0;
        SetSubjectVisible(AskSubjectForNotes);
        if not assigned(TmpBoilerPlate) then
          TmpBoilerPlate := TStringList.Create;
        LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title, uPCEMaster.VisitString);
        FChanged := False;
        cmdChangeClick(Self); // will set captions, sign state for Changes
        lstNotesClick(Self); // will make pnlWrite visible
        if timAutoSave.Interval <> 0 then
          EnableAutosave := true;
        if txtSubject.Visible then
          txtSubject.SetFocus
        else if memNewNote.Visible then
               memNewNote.SetFocus;
      end;
    end; { if HaveRequired }
    if not HaveRequired then
    begin
      ClearEditControls;
      ShowPCEButtons(False);
    end;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      try
        DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
        ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle,
          Self, 'Title: ' + FEditNote.TitleName, DocInfo, CPMemNewNote);
        memNewNote.Text := TmpBoilerPlate.Text;
        //memNewNote.SelStart := Length(memNewNote.Lines.Text); // CQ: 16461
        SpeakStrings(memNewNote);
        UpdateNoteAuthor(DocInfo);
      finally
        TmpBoilerPlate.Free;
      end;
    end;
    if EnableAutosave then
    // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := true;
  end;
end;

procedure TfrmNotes.InsertAddendum(aParentIEN: integer = -1;
  aParentTitle: string = '';isSmart: Boolean =false);
{ sets up fields of pnlWrite to write an addendum for the selected note }
const
  AS_ADDENDUM = true;
  IS_ID_CHILD = False;
var
  HaveRequired, RetryAction: Boolean;
  CreatedNote: TCreatedDoc;
  tmpNode: TTreeNode;
  X, DocInfo: string;
  TmpBoilerPlate: TStringList;
  NoteErrorAction: TNoteErrorReturn;
begin
  ClearEditControls;
  TmpBoilerPlate := nil;
  try
  with FEditNote do
  begin
    DocType := TYP_ADDENDUM;
    IsNewNote := False;
    DateTime := FMNow;
    Author := User.DUZ;
    AuthorName := User.Name;

    If aParentIEN = -1 then // Called directly from UI
    begin
      Title := TitleForNote(lstNotes.ItemIEN);
      TitleName := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
      If Copy(TitleName, 1, 1) = '+' then
        TitleName := Copy(TitleName, 3, 199);

      X := GetPackageRefForNote(lstNotes.ItemIEN);
      If Piece(X, U, 1) <> '-1' then
      begin
        PkgRef := GetPackageRefForNote(lstNotes.ItemIEN);
        PkgIEN := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr := Piece(PkgRef, ';', 2);
      end;
      Addend := lstNotes.ItemIEN;
    end
    else // Called external to the UI aParentIEN is the IEN of the Note to addend
    begin
      Title := TitleForNote(aParentIEN);
      TitleName := aParentTitle;
      If Copy(TitleName, 1, 1) = '+' then
        TitleName := Copy(TitleName, 3, 199);

      X := GetPackageRefForNote(aParentIEN);
      If Piece(X, U, 1) <> '-1' then
      begin
        PkgRef := GetPackageRefForNote(aParentIEN);
        PkgIEN := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr := Piece(PkgRef, ';', 2);
      end;
      Addend := aParentIEN;
    end;
  end;
  { ** Remove later ;-)
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
  }
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate then
    HaveRequired := ExecuteNoteProperties(FEditNote, CT_NOTES, IS_ID_CHILD,
      False, '', 0)
  else
    HaveRequired := true;
  // lock the consult request if there is a consult
  if HaveRequired then
    with FEditNote do
      if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
        HaveRequired := LockConsultRequest(PkgIEN);
  if HaveRequired then
  begin
    uPCEMaster.NoteDateTime := FEditNote.DateTime;
    uPCEMaster.PCEForNote(FEditNote.Addend);
    FEditNote.Location := uPCEMaster.Location;
    FEditNote.LocationName := ExternalName(uPCEMaster.Location, 44);
    FEditNote.VisitDate := uPCEMaster.DateTime;
    repeat
        RetryAction := False;
        PutAddendum(CreatedNote, FEditNote, FEditNote.Addend);
        if CreatedNote.IEN = 0 then
        begin
          NoteErrorAction := ShowNewNoteError('addendum', CreatedNote.ErrorText,
            FEditNote.Lines, False, True);
          RetryAction := NoteErrorAction = neRetry;

          // Abort
          if NoteErrorAction = neAbort then
          begin
            // if note creation failed or failed to get note lock (both unlikely), unlock consult
            with FEditNote do
              if (PkgIEN > 0) and (PkgPtr = PKG_CONSULTS) then
                UnlockConsultRequest(0, PkgIEN);
            HaveRequired := False;
          end;
        end;
      until not RetryAction;
    // Save copied text here
    if (CreatedNote.IEN > 0) and (memNewNote.lines.Count > 0) and (CPMemNewNote.CopyPasteEnabled) then
      CPMemNewNote.SaveTheMonitor(CreatedNote.IEN);
    FEditNoteIEN := CreatedNote.IEN;
    uPCEMaster.NoteIEN := CreatedNote.IEN;
    if CreatedNote.IEN > 0 then
      LockDocument(CreatedNote.IEN, CreatedNote.ErrorText);
    if (CreatedNote.IEN > 0) and (CreatedNote.ErrorText = '') then
    begin
      with FEditNote do
      begin
        X := IntToStr(CreatedNote.IEN) + U + 'Addendum to ' + TitleName + U +
          FloatToStr(DateTime) + U + Patient.Name + U + IntToStr(Author) + ';' +
          AuthorName + U + LocationName + U + 'new' + U + U + U + U + U +
          U + U + U;
      end;

      lstNotes.Items.Insert(0, X);
      uChanging := true;
      tvNotes.Items.BeginUpdate;
      try
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
      finally
        tvNotes.Items.EndUpdate;
      end;
      uChanging := False;
      Changes.Add(CH_DOC, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
      lstNotes.ItemIndex := 0;
      EditingIndex := 0;
      SetSubjectVisible(AskSubjectForNotes);
      cmdChangeClick(Self); // will set captions, sign state for Changes
      lstNotesClick(Self); // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then
        timAutoSave.Enabled := true;
      if isSMART then
        begin
          if not assigned(TmpBoilerPlate) then
            TmpBoilerPlate := TStringList.Create;
          LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title, uPCEMaster.VisitString);
        end;
      memNewNote.SetFocus;
    end;
  end; { if HaveRequired }
  if not HaveRequired then
    ClearEditControls;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      try
        DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
        ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo, CPMemNewNote);
        memNewNote.Text := TmpBoilerPlate.Text;
        //memNewNote.SelStart := Length(memNewNote.Lines.Text); //CQ: 16461
        SpeakStrings(memNewNote);
        UpdateNoteAuthor(DocInfo);
      finally
        TmpBoilerPlate.Free;
      end;
    end;
  if timAutoSave.Interval <> 0 then
    timAutoSave.Enabled := True;
  end;

end;

procedure TfrmNotes.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  X: string;
begin
  if lstNotes.ItemIndex < 0 then
    Exit;
  ClearEditControls;
  Drawers.RichEditControl := memNewNote;
  // added to fix problem with focused control when editing.  dlp 15Oct12
  Drawers.CopyMonitor := CPMemNewNote;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then
    exit;
  EditingIndex := lstNotes.ItemIndex;
  if assigned(Changes) then
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

  uChanging := true;
  tvNotes.Items.BeginUpdate;
  try
    tmpNode := tvNotes.FindPieceNode('EDIT', 1, U, nil);
    if tmpNode = nil then
    begin
      tmpNode := tvNotes.Items.AddObjectFirst(tvNotes.Items.GetFirstNode,
        'Note being edited',
        MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
    end
    else
      tmpNode.DeleteChildren;
    X := lstNotes.Items[lstNotes.ItemIndex];
    tmpNode.ImageIndex := IMG_TOP_LEVEL;
    tmpNode := tvNotes.Items.AddChildObjectFirst(tmpNode, MakeNoteDisplayText(X),
      MakeNoteTreeObject(X));
    TORTreeNode(tmpNode).StringData := X;
    if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
      tmpNode.ImageIndex := IMG_SINGLE
    else
      tmpNode.ImageIndex := IMG_ADDENDUM;
    tmpNode.SelectedIndex := tmpNode.ImageIndex;
    tvNotes.Selected := tmpNode;
  finally
    tvNotes.Items.EndUpdate;
    uChanging := False;
  end;

  uPCEMaster.NoteDateTime :=
    MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
  uPCEMaster.PCEForNote(lstNotes.ItemIEN);
  FEditNote.NeedCPT := uPCEMaster.CPTRequired;
  txtSubject.Text := FEditNote.Subject;
  SetSubjectVisible(AskSubjectForNotes);
  cmdChangeClick(Self); // will set captions, sign state for Changes
  lstNotesClick(Self); // will make pnlWrite visible
  if timAutoSave.Interval <> 0 then
    timAutoSave.Enabled := true;
  memNewNote.SetFocus;
end;

procedure TfrmNotes.SaveEditedNote(var Saved: Boolean);
{ validates fields and sends the updated note to the server }

  procedure AfterSave;
  begin
    if LstNotes.ItemIndex = EditingIndex then
    begin
      EditingIndex := -1;
      LstNotesClick(Self);
    end;
    EditingIndex := -1;
    // make sure EditingIndex reset even if not viewing edited note
    Saved := True;
    FNewIDChild := False;
    FChanged := False;
  end;

var
  UpdatedNote: TCreatedDoc;
  X: string;
  RetryAction: Boolean;
  NoteErrorAction: TNoteErrorReturn;
begin
  Saved := False;
  if (MemNewNote.GetTextLen = 0) or (not ContainsVisibleChar(MemNewNote.Text))
  then
  begin
    LstNotes.ItemIndex := EditingIndex;
    X := LstNotes.ItemID;
    UChanging := True;
    TvNotes.Selected := TvNotes.FindPieceNode(X, 1, U,
      TvNotes.Items.GetFirstNode);
    UChanging := False;
    TvNotesChange(Self, TvNotes.Selected);
    if FSilent or ((not FSilent) and
      (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_NOTE, TC_EMPTY_NOTE,
      MB_YESNO) = IDYES)) then
    begin
      FConfirmed := True;
      AcDeleteNoteExecute(Self);
      Saved := True;
      FDeleted := True;
    end
    else
      FConfirmed := False;
    Exit;
  end;
  // ExpandTabsFilter(memNewNote.Lines, TAB_STOP_CHARS);
  FEditNote.Lines := MemNewNote.Lines;
  // FEditNote.Lines:= SetLinesTo74ForSave(memNewNote.Lines, Self);
  FEditNote.Subject := TxtSubject.Text;
  FEditNote.NeedCPT := UPCEMaster.CPTRequired;
  TimAutoSave.Enabled := False;
  try
    repeat
      RetryAction := False;
      PutEditedNote(UpdatedNote, FEditNote, LstNotes.GetIEN(EditingIndex));

      if UpdatedNote.IEN > 0 then
      begin
        MemNewNote.Clear;
        // Update the richedit for the copy paste (Formatting may have changed)
        // GetNoteForEdit(FEditNote, lstNotes.GetIEN(EditingIndex));
        // memNewNote.Lines.Assign(FEditNote.Lines);
        LoadDocumentText(MemNewNote.Lines, LstNotes.GetIEN(EditingIndex));

        // Save copied text here
        // CPMemNewNote.SaveTheMonitor(lstNotes.GetIEN(EditingIndex));
        if (MemNewNote.Lines.Count > 0) and (CPMemNewNote.CopyPasteEnabled) then
          CPMemNewNote.SaveTheMonitor(UpdatedNote.IEN);

        // there's no unlocking here since the note is still in Changes after a save
        AfterSave;
      end
      else
      begin
        if not FSilent then
        begin
          NoteErrorAction := ShowNoteError(UpdatedNote.ErrorText,
            FEditNote.Lines, False, True);

          RetryAction := NoteErrorAction = neRetry;

          if NoteErrorAction = neAbort then
            AfterSave;
        end;
      end;
    until not RetryAction;
  finally
    TimAutoSave.Enabled := True;
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
    if ItemIndex < 0 then
      exit
    else if ItemIndex = EditingIndex then
    begin
      // pnlWrite.Visible := True;
      ReadVisible := False;
      mnuViewDetail.Enabled := False;
      mnuActChange.Enabled := WriteAccess(waProgressNotes) and (not((FEditNote.IDParent <> 0) and
        (not FNewIDChild)));
      mnuActLoadBoiler.Enabled := WriteAccess(waProgressNotes);
      // stTitle.Caption := '';
      UpdateReminderFinish;
      CPMemNewNote.LoadPasteText();
    end
    else
    begin
      StatusText('Retrieving selected progress note...');
      Screen.Cursor := crHourGlass;
      ReadVisible := true;
      // pnlWrite.Visible := FALSE;
      UpdateReminderFinish;
      stTitle.Caption := Piece(Piece(Items[ItemIndex], U, 8), ';', 1) + #9 +
        Piece(Items[ItemIndex], U, 2) + ', ' + Piece(Items[ItemIndex], U, 6) +
        ', ' + Piece(Piece(Items[ItemIndex], U, 5), ';', 2) + '  (' +
        FormatFMDateTime('mmm dd,yy@hh:nn',
        MakeFMDateTime(Piece(Items[ItemIndex], U, 3))) + ')';

      LoadDocumentText(memNote.Lines, ItemIEN);
      memNote.SelStart := 0;
      mnuViewDetail.Enabled := true;
      mnuViewDetail.Checked := False;
      mnuActChange.Enabled := False;
      mnuActLoadBoiler.Enabled := False;
      Screen.Cursor := crDefault;
      StatusText('');
      If GlobalSearch then
      begin
        dlgFindText.FindText := GlobalSearchTerm;
        dlgFindText.Options := [];
        dmodShared.FindRichEditTextAll(memNote, dlgFindText, clHighlight,
          [fsItalic, fsBold]);
      end;
      CPMemNote.LoadPasteText();
    end;
  if (assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;

  DisplayPCE;
  memNewNote.Repaint;
  memNote.Repaint;
  if not ReadVisible then
    LimitEditableNote;
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
  aStr: String;
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
    OKPressed := true;
  if not OKPressed then
    exit;
  // update display fields & uPCEMaster
  lblNewTitle.Caption := ' ' + FEditNote.TitleName + ' ';
  if (FEditNote.Addend > 0) and (CompareText(Copy(lblNewTitle.Caption, 2, 8),
    'Addendum') <> 0) then
    lblNewTitle.Caption := ' Addendum to:' + lblNewTitle.Caption;
  stRefDate.Caption := FormatFMDateTime('mmm dd,yyyy@hh:nn', FEditNote.DateTime);
  stAuthor.Caption := FEditNote.AuthorName;
  if uPCEMaster.Inpatient then
    X := 'Adm: '
  else
    X := 'Vst: ';
  X := X + FormatFMDateTime('mm/dd/yy', FEditNote.VisitDate) + '  ' +
    FEditNote.LocationName;
  lblVisit.Caption := X;
  if Length(FEditNote.CosignerName) > 0 then
    stCosigner.Caption := 'Expected Cosigner: ' + FEditNote.CosignerName
  else
    stCosigner.Caption := '';

  stAuthor.Width := TextWidthByFont(stAuthor.Font.Handle, stAuthor.Caption);
  stAuthor.Left := cmdChange.Left - stAuthor.Width - 4;
  stCosigner.Width := TextWidthByFont(stCosigner.Font.Handle,
    stCosigner.Caption);
  stCosigner.Left := cmdChange.Left - stCosigner.Width - 4;

  uPCEMaster.NoteTitle := FEditNote.Title;
  // modify signature requirements if author or cosigner changed
  if (User.DUZ <> FEditNote.Author) and (User.DUZ <> FEditNote.Cosigner) then
    Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_NA)
  else
    Changes.ReplaceSignState(CH_DOC, lstNotes.ItemID, CH_SIGN_YES);
  X := lstNotes.Items[EditingIndex];
  SetPiece(X, U, 2, lblNewTitle.Caption);
  SetPiece(X, U, 3, FloatToStr(FEditNote.DateTime));
  if Assigned(tvNotes.Selected) then
  begin
    tvNotes.Selected.Text := MakeNoteDisplayText(X);
    TORTreeNode(tvNotes.Selected).StringData := X;
  end;
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
    begin
      CallVistA('TIU LINK TO FLAG', [lstNotes.ItemIEN, PRF_IEN, ActionIEN,
        Patient.DFN], aStr);
      if aStr = '0' then
        ShowMsg('TIU LINK TO FLAG: FAILED');
    end;
  end;

  if LastTitle <> FEditNote.Title then
    Self.acReloadBoilerExecute(Self);
end;

procedure TfrmNotes.cmdChangeExit(Sender: TObject);
begin
  inherited;
  // Fix the Tab Order  Make Drawers Buttons Accessible
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.cmdNewNoteExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.cmdPCEExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.CPHide(Sender: TObject);
begin
  inherited;
  if Sender is TCopyPasteDetails then
  begin
    if TCopyPasteDetails(Sender).Name = 'CPMemNote' then
      spDetails.Visible := False
    else
      spEditDetails.Visible := False;
  end;
end;

procedure TfrmNotes.CPShow(Sender: TObject);
begin
  inherited;
  if Sender is TCopyPasteDetails then
  begin
    TCopyPasteDetails(Sender).Top := TCopyPasteDetails(Sender)
      .VisualEdit.Top + 1;

    if TCopyPasteDetails(Sender).Name = 'CPMemNote' then
    begin
      spDetails.Visible := true;
      spDetails.Top := CPMemNote.Top - 1;
      pnlNote.Realign;
    end
    else
    begin
      spEditDetails.Visible := true;
      spEditDetails.Top := CPMemNewNote.Top - 1;
      pnlWrite.Realign;
    end;
  end;
end;

procedure TfrmNotes.currentlyEditingRecord(var editingText: string);
begin
  editingText := '';
  if EditingIndex <> -1 then
  begin
    editingText := 'Currently editing a note. Please either complete or save the note.'
  end;
  if assigned(frmTemplateDialog) then
    begin
      if Screen.ActiveForm = frmTemplateDialog then
        begin
          if editingText <> '' then editingText := editingText + CRLF +
            'A template is in process. Please either exit or complete the template.'
          else  editingText := 'A template is in process. Please either exit or complete the template.';
        end;
    end;
  if assigned(frmRemDlg) then
    begin
        if editingText <> '' then editingText := editingText + CRLF +
        'A reminder dialog is in process. Please exit the reminder dialog.'
        else editingText := 'A reminder dialog is in process. Please exit the reminder dialog.';
    end;
  if assigned(frmEncounterFrame) then
  begin
    if Screen.ActiveForm = frmEncounterFrame then
    begin
      editingText := 'Currently editing an encounter. Please complete the encounter.';
    end;
  end;
end;

procedure TfrmNotes.SaveTheMonitor(Sender: TObject; SaveList: TStringList;
  var ReturnList: TStringList);
var
  i, X, z, Total, LineCnt, SubCnt: Integer;
  DivisionID, aName, aValue: string;
  LookUpLst: THashedStringList;
  aList: iORNetMult;
begin
  inherited;
  Total := StrToIntDef(SaveList.values['TotalToSave'], -1);
  DivisionID := Piece(RPCBrokerV.User.Division, '^', 1);
  If Trim(DivisionID) = '' then
    DivisionID := GetDivisionID;
  if Total > 0 then
  begin
    LookUpLst := THashedStringList.Create;
    try
      LookUpLst.BeginUpdate;
      try
        LookUpLst.Assign(SaveList);
      finally
        LookUpLst.EndUpdate;
      end;
      neworNetMult(aList);
      for i := 1 to Total do
      begin
        aList.AddSubscript([i, 0], LookUpLst.values[IntToStr(i) + ',0']);
        LineCnt := StrToIntDef(LookUpLst.values[IntToStr(i) + ',-1'], -1);
        for X := 0 to LineCnt do
        begin
          aName := IntToStr(i) + ',' + IntToStr(X);
          aValue := FilteredString(LookUpLst.values[aName]);
          aList.AddSubscript([i, X], aValue);
        end;

        // Send in the original if needed
        LineCnt := StrToIntDef(LookUpLst.values[IntToStr(i) + ',Copy,-1'], -1);
        for X := 1 to LineCnt do
        begin
          aName := IntToStr(i) + ',Copy,' + IntToStr(X);
          aValue := FilteredString(LookUpLst.values[aName]);
          aList.AddSubscript([i, 0, X], aValue);
        end;

        // Send in the "Paste"
        if StrToIntDef(Piece(LookUpLst.values[IntToStr(i) + ',Paste,-1'], '^',
          2), 0) > (TCopyEditMonitor(Sender).CopyMonitor.SaveCutOff * 1000) then
        begin
          LineCnt := StrToIntDef
            (Piece(LookUpLst.values[IntToStr(i) + ',Paste,-1'], '^', 1), -1);
          for X := 1 to LineCnt do
          begin
            SubCnt := StrToIntDef(LookUpLst.values[IntToStr(i) + ',Paste,' +
              IntToStr(X) + ',-1'], -1);
            for z := 1 to SubCnt do
            begin
              aName := IntToStr(i) + ',Paste,' + IntToStr(X) + ',' +
                IntToStr(z);
              aValue := FilteredString(LookUpLst.values[aName]);
              aList.AddSubscript([i, 'Paste', X, z], aValue);
            end;
          end;
        end;

      end;

      CallVistA('ORWTIU SVPASTE', [aList, DivisionID], ReturnList);

    Finally
      LookUpLst.Free;
    End;
  end;
end;

procedure TfrmNotes.PasteToMonitor(Sender: TObject; var AllowMonitor: Boolean);
begin
  inherited;
  CPMemNewNote.EditMonitor.ItemIEN := lstNotes.ItemIEN;
  AllowMonitor := CPMemNewNote.CopyMonitor.ExcludedList.IndexOf(IntToStr(FEditNote.Title)) = -1;
  ClipboardFilemanSafe;
end;

procedure TfrmNotes.LoadPastedText(Sender: TObject; LoadList: TStrings;
  var ProcessLoad, PreLoaded: Boolean);
var
  DivId, ParamStr, tmpRtn: string;
  IsCoSigner: Boolean;
begin
  DivID := Piece(RPCBrokerV.User.Division, '^', 1);
  If Trim(DivID) = '' then
    DivID := GetDivisionID;
  CallVistA('ORWTIU VIEWCOPY', [User.DUZ, lstNotes.ItemIEN, DivId], tmpRtn);
  ProcessLoad := Not(Trim(tmpRtn) = '0');
  IsCoSigner := False;
  With TCopyPasteDetails(Sender) do
  begin
    // check for preload
    if ProcessLoad then
    begin
      IsCoSigner := UserIsCosigner(lstNotes.ItemIEN,IntToStr(User.DUZ));
      if IsCoSigner and (not EditMonitor.CopyMonitor.DisplayPaste) then
      begin
        // Setup default indication
        EditMonitor.CopyMonitor.MatchStyle := [fsBold];
        EditMonitor.CopyMonitor.MatchHighlight := true;
        EditMonitor.CopyMonitor.HighlightColor := clYellow;
      end
      else if not EditMonitor.CopyMonitor.DisplayPaste then
      begin
        EditMonitor.CopyMonitor.MatchStyle := [];
        EditMonitor.CopyMonitor.MatchHighlight := False;
        ProcessLoad := False;
      end;

    end;

    if ProcessLoad then
    begin
      PreLoaded := False;
      // Pre load off but make sure we need to actually reload

      if not EditMonitor.ReadyForLoadTransfer then
        PreLoaded := EditMonitor.ItemIEN = lstNotes.ItemIEN;

      EditMonitor.ItemIEN := lstNotes.ItemIEN;
      // If user is cosigner then show all paste actions
      ShowAllPaste := IsCoSigner;

      if not PreLoaded then
      begin
        ParamStr := IntToStr(EditMonitor.ItemIEN) + ';' +
          EditMonitor.RelatedPackage;
        LoadList.BeginUpdate;
        try
          CallVistA('ORWTIU GETPASTE', [ParamStr, DivId], LoadList);
        finally
          LoadList.EndUpdate;
        end;
      end;
    end;

    // Load has happened so no more transfers
    CPMemNewNote.DefaultSelectAll := IsCoSigner;
    CPMemNote.DefaultSelectAll := IsCoSigner;
    EditMonitor.ItemIEN := lstNotes.ItemIEN;
    CPMemNewNote.EditMonitor.ReadyForLoadTransfer := False;
    CPMemNote.EditMonitor.ReadyForLoadTransfer := False;
  end;

  inherited;
end;

procedure TfrmNotes.memNewNoteChange(Sender: TObject);
begin
  inherited;
  FChanged := true;
end;

procedure TfrmNotes.DoAutoSave(Suppress: Integer = 1);
var
  ErrMsg: string;
  RetryAction: Boolean;
  NoteErrorAction: TNoteErrorReturn;
begin
  if FFrame.FrmFrame.DLLActive then
    Exit;
  if (EditingIndex > -1) and FChanged then
  begin
    StatusText('Autosaving note...');
    // PutTextOnly(ErrMsg, memNewNote.Lines, lstNotes.GetIEN(EditingIndex));
    TimAutoSave.Enabled := False;
    try
      repeat
        RetryAction := False;
        SetText(ErrMsg, MemNewNote.Lines, LstNotes.GetIEN(EditingIndex),
          Suppress);
        if ErrMsg <> '' then
        begin
          NoteErrorAction := ShowNoteError(ErrMsg, MemNewNote.Lines,
            True, False);
          RetryAction := NoteErrorAction = neRetry;
        end;
      until not RetryAction;
      // Save copied text here
      if (MemNewNote.Lines.Count > 0) and (CPMemNewNote.CopyPasteEnabled) then
        CPMemNewNote.SaveTheMonitor(LstNotes.GetIEN(EditingIndex));

    finally
      TimAutoSave.Enabled := True;
    end;
    FChanged := False;
    StatusText('');
  end;
end;

procedure TfrmNotes.DrawerButtonClicked;
begin
  pnlLeft.LockDrawing;
  try
    if Drawers.DrawerButtonsVisible then
    begin
      pnlDrawers.Visible := true;
      pnlDrawers.Top := splDrawers.Top + 1;
      splDrawers.Enabled := Drawers.DrawerIsOpen;
      if Drawers.DrawerIsOpen then
      begin
        if Drawers.LastOpenSize >
            (pnlLeftTop.Height - tvNotes.Constraints.MinHeight) then
          Drawers.LastOpenSize := (pnlLeftTop.Height - tvNotes.Constraints.MinHeight);
        if Drawers.LastOpenSize > Drawers.TotalButtonHeight then
          ExpandedDrawerHeight := Drawers.LastOpenSize;
        Drawers.Parent.height := ExpandedDrawerHeight;
        Drawers.Parent.Constraints.MinHeight := 150;
      end
      else
      begin
        Drawers.Parent.Constraints.MinHeight := 0;
        Drawers.Parent.height := Drawers.TotalButtonHeight;
        Drawers.Parent.Constraints.MinHeight := Drawers.TotalButtonHeight;
      end;
    end
    else
    begin
      pnlDrawers.Visible := False;
      splDrawers.Enabled := False;
    end;
  finally
    pnlLeft.UnlockDrawing;
  end;
end;

procedure TfrmNotes.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
end;

procedure TfrmNotes.Timer1Timer(Sender: TObject);
begin

end;

{ Action menu events ----------------------------------------------------------------------- }

function TfrmNotes.StartNewEdit(NewNoteType: Integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  Msg, CapMsg: string;
begin
  FStarting := False;
  Result := true;
  // cmdNewNote.Enabled := False;
  if (EditingIndex > -1) and (EditingIndex < lstNotes.Count) then
  begin
    FStarting := true;
    case NewNoteType of
      NT_ACT_ADDENDUM:
        begin
          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]
            ) + TX_NEW_SAVE3;
          CapMsg := TC_NEW_SAVE3;
        end;
      NT_ACT_EDIT_NOTE:
        begin
          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]
            ) + TX_NEW_SAVE4;
          CapMsg := TC_NEW_SAVE4;
        end;
      NT_ACT_ID_ENTRY:
        begin
          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex]
            ) + TX_NEW_SAVE5;
          CapMsg := TC_NEW_SAVE5;
        end;
    else
      begin
        Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(lstNotes.Items[EditingIndex])
          + TX_NEW_SAVE2;
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
      if not Saved then
        Result := False
      else
        LoadNotes;
      FStarting := False;
    end;
  end
  else
  begin
    // Consults section
    if (frmConsults.EditingIndex > -1) and
      (frmConsults.EditingIndex < frmConsults.lstNotes.Count) then
    begin
      FStarting := true;
      case NewNoteType of
        NT_ACT_ADDENDUM:
          begin
            Msg := TX_NEW_SAVE1 + MakeNoteDisplayText
              (frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
              TX_NEW_SAVE3;
            CapMsg := TC_NEW_SAVE3;
          end;
        NT_ACT_EDIT_NOTE:
          begin
            Msg := TX_NEW_SAVE1 + MakeNoteDisplayText
              (frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
              TX_NEW_SAVE4;
            CapMsg := TC_NEW_SAVE4;
          end;
        NT_ACT_ID_ENTRY:
          begin
            Msg := TX_NEW_SAVE1 + MakeNoteDisplayText
              (frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
              TX_NEW_SAVE5;
            CapMsg := TC_NEW_SAVE5;
          end;
      else
        begin
          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText
            (frmConsults.lstNotes.Items[frmConsults.EditingIndex]) +
            TX_NEW_SAVE2;
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
        frmConsults.SaveCurrentNote(Saved);
        if not Saved then
          Result := False
        else
          LoadNotes;
        FStarting := False;
      end;
    end;
  end;
  // cmdNewNote.Enabled := (Result = FALSE) and (FStarting = FALSE);
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
    FSilent := true;
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
      FDeleted := False;
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
      ContinueSign := False;
    end
    else if not NoteHasText(IEN) then
    begin
      InfoBox(TX_EMPTY_NOTE1, TC_EMPTY_NOTE, MB_OK or MB_ICONERROR);
      ContinueSign := False;
    end
    else if not LastSaveClean(IEN) and
      (InfoBox(TX_ABSAVE, TC_ABSAVE, MB_YESNO or MB_DEFBUTTON2 or
      MB_ICONWARNING) <> IDYES) then
      ContinueSign := False
    else
      ContinueSign := true;
    if ContinueSign then
    begin
      if (AnIndex >= 0) and (AnIndex = lstNotes.ItemIndex) then
        APCEObject := uPCEMaster
      else
        APCEObject := nil;
      OK := IsOK2Sign(APCEObject, IEN);
      if frmFrame.Closing then
        exit;
      if (assigned(APCEObject)) and (uPCEMaster.Updated) then
      begin
//        uPCEShow.CopyPCEData(uPCEEdit);
        uPCEMaster.Updated := False;
        lstNotesClick(Self);
      end
      else
        uPCEMaster.Clear;
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
    popNoteMemoCut.Enabled := (FEditCtrl.SelLength > 0) and (not TORExposedCustomEdit(FEditCtrl).ReadOnly);
    popNoteMemoCopy.Enabled := FEditCtrl.SelLength > 0;
    popNoteMemoPaste.Enabled := (not TORExposedCustomEdit(FEditCtrl).ReadOnly)
      and Clipboard.HasFormat(CF_TEXT);
    popNoteMemoTemplate.Enabled := Drawers.CanEditTemplates and
      popNoteMemoCut.Enabled;
    popNoteMemoFind.Enabled := FEditCtrl.GetTextLen > 0;
  end
  else
  begin
    popNoteMemoCut.Enabled := False;
    popNoteMemoCopy.Enabled := False;
    popNoteMemoPaste.Enabled := False;
    popNoteMemoTemplate.Enabled := False;
  end;
  if pnlWrite.Visible then
  begin
    popNoteMemoSpell.Enabled := true;
    popNoteMemoGrammar.Enabled := true;
    popNoteMemoReformat.Enabled := true;
    popNoteMemoReplace.Enabled := (FEditCtrl.GetTextLen > 0);
    popNoteMemoPreview.Enabled := WriteAccess(waProgressNoteTemplates) and
      (Drawers.ActiveDrawer = odTemplates) and
      assigned(Drawers.tvTemplates.Selected);
    popNoteMemoInsTemplate.Enabled := WriteAccess(waProgressNoteTemplates) and
      (Drawers.ActiveDrawer = odTemplates) and
      assigned(Drawers.tvTemplates.Selected);
    popNoteMemoViewCslt.Enabled := (FEditNote.PkgPtr = PKG_CONSULTS);
    // if editing consult title
  end
  else
  begin
    popNoteMemoSpell.Enabled := False;
    popNoteMemoGrammar.Enabled := False;
    popNoteMemoReformat.Enabled := False;
    popNoteMemoReplace.Enabled := False;
    popNoteMemoPreview.Enabled := False;
    popNoteMemoInsTemplate.Enabled := False;
    popNoteMemoViewCslt.Enabled := False;
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
  // Seltext does not add to the undo buffer
  if (FEditCtrl = memNewNote) and (assigned(CPMemNewNote.EditMonitor)) and
    (assigned(CPMemNewNote.EditMonitor.CopyMonitor)) and
    (CPMemNewNote.EditMonitor.CopyMonitor.Enabled) then
  begin
    ClipboardFilemanSafe;
    FEditCtrl.PasteFromClipboard;
  end
  else begin
    //Ensure that we do not have any non fileman safe characters
    ClipboardFilemanSafe;

    If (FEditCtrl is TCustomRichEdit) then
      // We can not allow WM_Paste to be called on a richedit because RTF tags
      // should not be allowed into the control.
      // We also can not just use SelText since this does not add to the
      // undo buffer
      FEditCtrl.Perform(EM_REPLACESEL, WParam(True), LongInt(PChar(Clipboard.AsText)))
    else
      //Let WM_Paste take over
      FEditCtrl.PasteFromClipboard;
  end;
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
  FChanged := true;
  DoAutoSave;
end;

procedure TfrmNotes.popNoteMemoFindClick(Sender: TObject);
// var
// hData: THandle;  //CQ8300
// pData: ^ClipboardData; //CQ8300
begin
  inherited;
  SendMessage(TRichEdit(popNoteMemo.PopupComponent).Handle, WM_VSCROLL,
    SB_TOP, 0);
  with dlgFindText do
  begin
    Position := Point(Application.MainForm.Left + splHorz.Left + splHorz.Width,
      Application.MainForm.Top);
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
    Position := Point(Application.MainForm.Left + splHorz.Left + splHorz.Width,
      Application.MainForm.Top);
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
  timAutoSave.Enabled := False;
  try
    SpellCheckForControl(memNewNote);
  finally
    FChanged := true;
    DoAutoSave(0);
    timAutoSave.Enabled := true;
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
    FChanged := true;
    DoAutoSave(0);
    timAutoSave.Enabled := true;
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
  ConsultDetail := TStringList.Create;
  try
    LoadConsultDetail(ConsultDetail, CsltIEN);
    ReportBox(ConsultDetail, 'Consult Details: #' + IntToStr(CsltIEN) + ' - ' +
      Piece(X, U, 4), true);
  finally
    ConsultDetail.Free;
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
    FSilent := true;
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
          if DeleteSts.Success then SendMessage(Application.MainForm.Handle, UM_REMINDERS, 1, 1);
          UnlockDocument(IEN);
        end; { if ErrMsg }
      end; { if not LastSaveClean }
    end; { else }
  end; { if frmFrame }
end;

procedure TfrmNotes.ProcessNotifications;
var
  X, AlertDesc: string;
  i, idx: integer;
  Saved: Boolean;
  tmpNode: TTreeNode;
  AnObject: PDocTreeObject;
  aSmartParams: TStringList;
  aSMARTAction: TNotificationAction;
  docID: integer;
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
  lstNotes.Enabled := true;
  ReadToFront;
  // show ALL unsigned/uncosigned for a patient, not just the alerted one
  // what about cosignature?  How to get correct list?  ORB FOLLOWUP TYPE = OR alerts only

  // Handle SMART Alerts
  aSmartParams := TStringList.Create();
  try
    if assigned(Notifications.Data) then
      aSmartParams.Assign(Notifications.Data);
//    CallVistA('ORB3UTL GET NOTIFICATION', [Piece(Notifications.RecordID, '^', 2)], aSmartParams);
    If (aSmartParams.values['PROCESS AS SMART NOTIFICATION'] = '1') then
    begin
      idx := aSmartParams.IndexOf(SMART_ALERT_INFO);
      if idx > 0 then
      begin
        AlertDesc := '';
        for i := idx + 1 to aSmartParams.Count - 1 do
          AlertDesc := AlertDesc + aSmartParams[i] + CRLF;
        for i := aSmartParams.Count - 1 downto idx do
          aSmartParams.Delete(i);

        aSMARTAction := TfrmNotificationProcessor.Execute(aSmartParams,
          AlertDesc, True);

        if aSMARTAction = naNewNote then
          aSmartParams.Add('MAKE ADDENDUM=0')
        else if aSMARTAction = naAddendum then
          aSmartParams.Add('MAKE ADDENDUM=1');
      end;
      if (aSmartParams.values['MAKE ADDENDUM'] = '0') then
      begin
        If Encounter.NeedVisit then
        begin
          UpdateVisit(Font.Size, DfltTIULocation);
          frmFrame.DisplayEncounterText;
        end;

        If Encounter.NeedVisit then
        begin
          CallVistA('ORBSMART OUSMALRT', ['']);
          InfoBox(TX_NEED_VISIT, TX_NO_VISIT, MB_OK or MB_ICONWARNING);
          ShowPCEButtons(False);
          exit;
        end;

        if WriteAccess(waProgressNotes) then
        begin
          // VISTAOR-23034
          SetViewContext(FDefaultContext);
          InsertNewNote(False, 0, StrToInt(aSmartParams.values['NOTE TITLE IEN']),
            aSmartParams.values['NOTE TITLE']);
          // aSmartNoteIEN, aSmartNoteTitle);
        end
        else
          WriteAccessV.Error(waProgressNotes, 'Can''t create new note.');
      end
      else if (aSmartParams.values['MAKE ADDENDUM'] = '1') then
      begin
        if WriteAccess(waProgressNotes) then
        begin
          // VISTAOR-23034
          SetViewContext(FDefaultContext);

          InsertAddendum(StrToIntDef(aSmartParams.values['ADDEND NOTE IEN'], -1),
            aSmartParams.values['ADDEND NOTE TITLE'], true);
        end
        else
          WriteAccessV.Error(waProgressNotes, 'Can''t create new addendum.');
      end;
      exit;
    end
    else
      X := Notifications.AlertData;
  finally
    FreeAndNil(aSmartParams);
  end;

  if StrToIntDef(Piece(X, U, 1), 0) = 0 then
  begin
    InfoBox(TX_NO_ALERT, TX_CAP_NO_ALERT, MB_OK);
    exit;
  end;
  uChanging := true;
  tvNotes.Items.BeginUpdate;
  try
    lstNotes.Clear;
    ClearTVNotes;
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
  finally
    tvNotes.Items.EndUpdate;
  end;
  uChanging := False;
  tvNotesChange(Self, tvNotes.Selected);
  if Notifications.Processing then
  begin
    case Notifications.Followup of
      NF_NOTES_UNSIGNED_NOTE:
        begin
          // if the user doesn't need to sign the note, delete the notification
          docID := StrToIntDef(AnObject.DocID, -1);
          if docID <> -1 then
          begin
            if not NeedToSignDocument(docID) then
              Notifications.Delete
          end
          else
          begin
            if AnObject.Status = 'completed' then
              Notifications.Delete;
          end;
        end;
    end;
    if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then
      Notifications.Delete;
    if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then
      Notifications.Delete;
  end;
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
  tvNotes.Enabled := true;
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
      Changed := true;
//      mnuViewClick(Self); -- replacing mnu event handler with action
      acSignedExecute(Self);
    end
  else
  begin
    ViewContext := NC_RECENT;
//    mnuViewClick(Self); -- replacing mnu event handler with action
    acSignedExecute(Self);
  end;
end;

procedure TfrmNotes.SetWriteShowing(const Value: Boolean);
begin
  if Value <> pnlWrite.Visible then
  begin
    if not Value then
    begin
      pnlWrite.Left := 0;
      // pnlWrite.Width := 0;
      pnlWrite.Top := 0;
      pnlWrite.height := 0;
    end;
    pnlWrite.Visible := Value;
  end;
end;

procedure TfrmNotes.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, true, FEditCtrl.SelText);
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

procedure TfrmNotes.pnlDrawersExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.pnlDrawersResize(Sender: TObject);
begin
  inherited;
  Drawers.BaseHeight := pnlDrawers.height;
end;

procedure TfrmNotes.pnlLeftExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.pnlNoteExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.PnlRightExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.pnlWriteResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memNewNote, MAX_PROGRESSNOTE_WIDTH - 1);

  // CQ7012 Added test for nil
  if memNewNote <> nil then
    memNewNote.Constraints.MinWidth := TextWidthByFont(memNewNote.Font.Handle,
      StringOfChar('X', MAX_PROGRESSNOTE_WIDTH)) + (LEFT_MARGIN * 2) +
      ScrollBarWidth;
  // CQ7012 Added test for nil
  if (Self <> nil) and (pnlLeft <> nil) and (pnlWrite <> nil) and
    (splHorz <> nil) then
    if memNewNote.Width = memNewNote.Constraints.MinWidth then
      pnlLeft.Width := Self.ClientWidth - pnlWrite.Width - splHorz.Width;
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
      Expand(true);
end;

procedure TfrmNotes.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if tvNotes.Selected = nil then
    exit;
  with tvNotes.Selected do
    if HasChildren then
      Collapse(true);
end;

procedure TfrmNotes.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if (FEditingIndex < 0) then
    KillReminderDialog(Self);
  if (assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

procedure TfrmNotes.SetExpandedDrawerHeight(const Value: Integer);
begin
  if (Value <> fExpandedDrawerHeight) then
  begin
    fExpandedDrawerHeight := Value;
  end;
end;

function TfrmNotes.CanFinishReminder: Boolean;
begin
  if (EditingIndex < 0) then
    Result := False
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmNotes.FormDestroy(Sender: TObject);
begin
  // Free the objects created in the create
  fAllUnCoSignedNotes.Free;
  fAllUnSignedNotes.Free;
  fAllSignedNotes.Free;
  FDocList.Free;
  FImageFlag.Free;

  if assigned(Encounter) and assigned(Encounter.Notifier) then
    Encounter.Notifier.RemoveNotify(EncounterLocationChanged);
  KillDocTreeObjects(tvNotes);

  inherited;
end;

procedure TfrmNotes.FormHide(Sender: TObject);
begin
  inherited;
  acNewNote.Enabled := false;

  // Unwinding the bindings set up in the Show
  if  fOnExitSet then
  begin
    frmDrawers.edtSearch.OnExit := FOldDrawerEdtSearchExit;
    frmDrawers.btnEncounter.OnExit := FOldDrawerPnlEncounterButtonExit;
    frmDrawers.btnTemplate.OnExit := FOldDrawerPnlTemplatesButtonExit;
    frmFrame.pnlToolbar.OnExit := FOldFramePnlToolbarExit;
    fOnExitSet := false;
  end;
end;

procedure TfrmNotes.AssignRemForm;
begin
  RemForm.Form := Self;
  RemForm.PCEObj := uPCEMaster;
  RemForm.RightPanel := pnlReminder;
  RemForm.CanFinishProc := CanFinishReminder;
  RemForm.DisplayPCEProc := DisplayPCE;
  RemForm.NewNoteRE := memNewNote;
  RemForm.NoteList := lstNotes;
  RemForm.DrawerReminderTV := Drawers.tvReminders;
  RemForm.DrawerReminderTreeChange := Drawers.NotifyWhenRemTreeChanges;
  RemForm.DrawerRemoveReminderTreeChange :=
    Drawers.RemoveNotifyWhenRemTreeChanges;
end;


procedure TfrmNotes.UpdateTreeView(DocList: TStringList; Tree: TORTreeView);
var
  ReturnCursor: Integer;
  CurrentActive: TDrawer;
begin
  if not Assigned(Tree) then
    raise Exception.Create('Tree not assigned');
  Screen.Cursor := crHourGlass;
  try
    CurrentActive := Drawers.ActiveDrawer;
    Drawers.ActiveDrawer := odNone;
    with Tree do
    begin
      uChanging := true;
      Items.BeginUpdate;
      try
        lstNotes.Items.AddStrings(DocList);
        ReturnCursor := Screen.Cursor;
        Screen.Cursor := crHourGlass;
        try
          BuildDocumentTree(DocList, Tree, FCurrentContext, CT_NOTES);
        finally
          Screen.Cursor := ReturnCursor;
        end;
      finally
        Items.EndUpdate;
      end;
      uChanging := False;
    end;
    if CurrentActive = odTemplates then
    begin
      Drawers.ActiveDrawer := odTemplates;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmNotes.tvNotesChange(Sender: TObject; Node: TTreeNode);
var
  txt: string;

begin
  if (Self = nil) then
    exit;

  UpdateActMenu('', nil);
  if assigned(Node) and (not ShowMoreNode(Node.Text)) then
    SaveTreePosition; // saving position only if it is the TX_MORE node
  if (tvNotes.Selected <> nil) and (not ShowMoreNode(tvNotes.Selected.Text)) then
  begin
    DoSelect;
    SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
  end
  else
  begin
    SetLvNotesVisible(False);
    // stTitle.Caption := 'Select another document or double click the node "'+TX_MORE +'"';
    // memNote.Clear;
    stTitle.Caption := '';
    if (tvNotes.Selected <> nil) and
      (pos(TX_OLDER_NOTES_WITH_ADDENDA, tvNotes.Selected.Text) > 0) then
    begin
      if FCurrentContext.TreeAscending then
        txt := 'above'
      else
        txt := 'below';
      txt := 'The signed documents shown ' + txt +
        ' are outside the selected range of notes,' + CRLF +
        'but contain one or more addenda that falls within the selected range.';
    end
    else
      txt := 'Select another document or double click the node "' + TX_MORE + '"';
    memNote.Lines.Text := txt;
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

function SortByDate(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
begin
  if (not AssignedAndHasData(Node1)) or (not AssignedAndHasData(Node2)) then
    Result := 0
  else
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

procedure TfrmNotes.tvNotesCompare(Sender: TObject; Node1, Node2: TTreeNode;
  Data: Integer; var Compare: Integer);
var
  flip: boolean;

  procedure NormalCompare;
  begin
    if assigned(Node1.Data) and assigned(Node2.Data) then
      Compare := SortByDate(Node1, Node2, Data)
    else
    begin
      if Node1.Level = Node2.Level then
        Compare := 0
      else if Node1.Level < Node2.Level then
        Compare := -1
      else
        Compare := 1;
    end;
    if (Compare = 0) and (not ShowMoreNode(Node1.Text)) and
      (not ShowMoreNode(Node2.Text)) and (FCurrentContext.GroupBy <> '') then
    begin
      flip := False;
      if FCurrentContext.GroupBy = 'D' then
      begin
        if assigned(Node1.Data) and assigned(Node2.Data) then
        begin
          Compare := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocID),
            PChar(PDocTreeObject(Node2.Data)^.DocID));
          if FCurrentContext.TreeAscending then
            Compare := - Compare;
        end;
      end
      else
        Compare := AnsiCompareText(Node1.Text, Node2.Text);
    end;
  end;

  procedure SetCompare(Value: Integer);
  begin
    Compare := Value;
    if FCurrentContext.TreeAscending then
      Compare := -Compare;
  end;

begin
  inherited;
  if (not Assigned(Node1)) or (not Assigned(Node2)) then
  begin
    Compare := 0;
    exit;
  end;
  if (Node1.Level = 0) and (Node2.Level = 0) then
  begin
    if assigned(Node1.Data) and assigned(Node2.Data) then
      Compare := -AnsiStrIComp(PChar(PDocTreeObject(Node1.Data)^.DocID),
          PChar(PDocTreeObject(Node2.Data)^.DocID))
    else
      Compare := 0;
    exit;
  end;

  flip := True;
  if FCurrentContext.GroupBy <> '' then
  begin
    if (pos(TX_MORE, upperCase(Node1.Text)) > 0) then
      Compare := 1
    else if (pos(TX_MORE, upperCase(Node2.Text)) > 0) then
      Compare := -1
    else
    begin
      NormalCompare;
      if flip and (not FCurrentContext.TreeAscending) then
        Compare := -Compare;
    end;
  end
  else
  begin
    NormalCompare;
    if Compare = 0 then
    begin
      if (pos(TX_MORE, upperCase(Node1.Text)) > 0) then
      begin
        if pos(TX_OLDER_NOTES_WITH_ADDENDA, Node2.Text) > 0 then
          SetCompare(1)
        else
          SetCompare(-1);
      end
      else if (pos(TX_MORE, upperCase(Node2.Text)) > 0) then
      begin
        if pos(TX_OLDER_NOTES_WITH_ADDENDA, Node1.Text) > 0 then
          SetCompare(-1)
        else
          SetCompare(1);
      end
      else if pos(TX_OLDER_NOTES_WITH_ADDENDA, Node1.Text) > 0 then
        SetCompare(-1)
      else if pos(TX_OLDER_NOTES_WITH_ADDENDA, Node2.Text) > 0 then
        SetCompare(1);
    end;
    if flip and (not FCurrentContext.TreeAscending) then
      Compare := -Compare;
  end;
end;

procedure TfrmNotes.ExitToNextControl(Sender: TObject);
// The tab order on this form is special. This is where it's all determined
// Tab order:
//   all of frmFrame.pnlToolBar,
//   pnlLeft up to tvNotes,
//   then go to first on pnlRight, and do all of pnlRight (special code needed)
//   then return to pnlLeft, first control after tvNotes (special code needed)
//   after pnlRight return to frmFrame.pnlToolBar (special code needed)
// Reverse tab order, as above in reverse, with one exception:
//   frmDrawers.btnTemplate previous is memNewNote, if it can focus.
//   (This code was preexisting)
// For all other tab order, the form relies on regular tab order
var
  CurControl, NextControl: TWinControl; // used in ExitToNextControl
  GoForward, GoBack: Boolean;
begin
  GoForward := TabIsPressed;
  GoBack := ShiftTabIsPressed;
  if (GoForward or GoBack) and (Sender is TWinControl) then
  begin
    CurControl := TWinControl(Sender);
    try
      NextControl := nil;

      // Frame.pnlToolbar previous
      if (CurControl = frmFrame.pnlToolbar) and (not GoForward) then begin
        NextControl := FindNextControl(frmFrame.pnlToolbar, GoForward, true, false);
        while (NextControl <> CurControl) and (NextControl.Parent <> pnlLeft) do
          NextControl := FindNextControl(NextControl, GoForward, true, false);
        if NextControl = CurControl then
          NextControl := FindNextControl(frmFrame.pnlToolbar, GoForward, true, false);
      end

      // tvNotes Next
      else if (CurControl = tvNotes) and GoForward then
      begin
        NextControl := FindNextControl(PnlRight, GoForward, true, false);
      end

      // pnlRight next and previous
      else if CurControl = PnlRight then
      begin
        if GoForward then NextControl := FindNextControl(tvNotes, GoForward, true, false)
        else NextControl := FindNextControl(pnlDrawers, GoForward, true, false);
      end

      // frmDrawers.btnTemplate previous, an exception
      else if (CurControl = frmDrawers.btnTemplate) and GoBack then
      begin
        if memNewNote.CanFocus then
          NextControl := memNewNote
        else
          NextControl := FindNextControl(PnlWrite, False, True, False);
      end

      // pnlLeft next
      else if CurControl = pnlLeft then
      begin
        if GoForward and (FPreviousControl <> tvNotes) then
          NextControl := frmFrame.FindNextControl(frmFrame.pnlToolBar, GoForward, true, false);
      end;
    finally
      FPreviousControl := CurControl; // To check multiple OnExits
    end;
    if assigned(NextControl) then NextControl.SetFocus;
  end;
end;

procedure TfrmNotes.tvNotesExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

function SortByTitle(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
begin
  if (not AssignedAndHasData(Node1)) or (not AssignedAndHasData(Node2)) then
    Result := 0
  else
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

procedure TfrmNotes.tvNotesExpanded(Sender: TObject; Node: TTreeNode);
begin
  if not assigned(Node) then
    exit;
  with Node do
  begin
    if assigned(Data) then
      if (pos('<', PDocTreeObject(Data)^.DocHasChildren) > 0) then
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

procedure TfrmNotes.tvNotesHint(Sender: TObject; const Node: TTreeNode;
  var Hint: string);
begin
  inherited;
  if AnsiPos(TX_MORE, Node.Text) > 0 then
    Hint := 'Double Click to get more documents';
end;

procedure TfrmNotes.tvNotesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) and (tvNotes.Selected <> nil) and
    (AnsiPos(TX_MORE, tvNotes.Selected.Text) > 0) then
    GetMoreDocuments;
end;

procedure TfrmNotes.tvNotesDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := False;
  if (not uIDNotesActive) or (not Assigned(tvNotes.Selected)) then
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
      Accept := False;
end;

procedure TfrmNotes.tvNotesDblClick(Sender: TObject);
begin
  inherited;
  if (tvNotes.Selected <> nil) and (AnsiPos(TX_MORE, tvNotes.Selected.Text) > 0)
  then
    GetMoreDocuments;
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

procedure TfrmNotes.tvNotesStartDrag(Sender: TObject;
  var DragObject: TDragObject);
const
  TX_CAP_NO_DRAG = 'Item cannot be moved';
  TX_NO_EDIT_DRAG = 'Items can not be dragged while a note is being edited.';
var
  WhyNot: string;
begin
  if not AssignedAndHasData(tvNotes.Selected) then
    exit;
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

procedure TfrmNotes.lvNotesClick(Sender: TObject);
var
  tn: TTreeNode;
begin
  exit;
  // inherited;
  if lvNotes.Selected = nil then
    exit;
  if lvNotes.Selected.SubItems.Count < 0 then
    exit;

  if pos(TX_MORE, lvNotes.Selected.SubItems[0]) = 1 then
  begin
    tn := getNodeByName(targetAllSignedNotes, 0, tvNotes);
    if not assigned(tn) then
      tn := getNodeByName(targetSignedByDateRange, 0, tvNotes);

    if assigned(tn) then
    begin
      tn := tn.getFirstChild;
      while assigned(tn) do
      begin
        if pos(TX_MORE, tn.Text) > 0 then
          break
        else
          tn := tn.getNextSibling;
      end;
      if assigned(tn) then
        tvNotes.Selected := tn; // selecting TX_MORE node of the tree
      // will force to load more notes
    end;
  end;
  inherited;
end;

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
    ColumnSortForward := true;
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

procedure TfrmNotes.lvNotesCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if (pos(TX_MORE, upperCase(Item1.SubItems[0])) > 0) then
    Compare := 1
  else if (pos(TX_MORE, upperCase(Item2.SubItems[0])) > 0) then
    Compare := -1
  else
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
end;

procedure TfrmNotes.lvNotesDblClick(Sender: TObject);
begin
  inherited;
  if uChanging or (lvNotes.Selected = nil) then
    exit;
  if AnsiPos(TX_MORE, lvNotes.Selected.SubItems[0]) > 0 then
    GetMoreDocuments(lvNotes);
end;

procedure TfrmNotes.lvNotesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    if lvNotes.Selected = nil then
      exit;
    if lvNotes.Selected.SubItems.Count < 1 then
      exit;

    if pos(TX_MORE, lvNotes.Selected.SubItems[0]) = 1 then
      GetMoreDocuments(lvNotes);
  end;
end;

procedure TfrmNotes.lvNotesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if uChanging then
    exit;
  if (not Selected) then
    exit;

  UpdateActMenu('', nil);
  uChanging := true;
  with lvNotes do
    // Ensure that we still have the item and it has the required sub nodes
    // or if they are on the more item
    if (not assigned(Item)) or (Item.SubItems.Count < 6) or
      (AnsiPos(TX_MORE, Item.SubItems[0]) > 0) then
    begin
      // stTitle.Caption := 'Select another document or double click the node "'+TX_MORE +'"';
      // memNote.Clear;
      memNote.Lines.Text := 'Select another document or double click the line "'
        + TX_MORE + '"';
      stTitle.Caption := '';
      memPCERead.Clear;
    end
    else
    begin
      StatusText('Retrieving selected progress note...');
      lstNotes.SelectByID(Item.SubItems[5]);
      UpdateActMenu(IntToStr(lstNotes.ItemIEN), lvNotes);
      lstNotesClick(Self);
      SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
    end;
  uChanging := False;
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
  if Editing or AnytimeEncounters then
  begin
    acPCE.Visible := true;
    if Editing then
    begin
      acPCE.Enabled := WriteAccess(waEncounter) and CanEditPCE(uPCEMaster);
      acNewNote.Visible := AnytimeEncounters;
      acNewNote.Enabled := False;
    end
    else
    begin
      acPCE.Enabled := WriteAccess(waEncounter) and (GetAskPCE(0) <> apDisable);
      acNewNote.Visible := true;
      acNewNote.Enabled := WriteAccess(waProgressNotes) and (FStarting = False); // TRUE;
    end;
  end
  else
  begin
    acPCE.Enabled := False;
    acPCE.Visible := False;
    acNewNote.Visible := true;
    acNewNote.Enabled := WriteAccess(waProgressNotes) and (FStarting = False); // TRUE;
  end;
  // popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
  // popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmNotes.DoAttachIDChild(AChild, AParent: TORTreeNode);
const
  TX_ATTACH_CNF = 'Confirm Attachment';
  TX_ATTACH_FAILURE = 'Attachment failed';
var
  ErrMsg, WhyNot: string;
  SavedDocID: string;
begin
  if (not AssignedAndHasData(AChild)) or (not AssignedAndHasData(AParent)) then
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
          tvNotes.Selected.Expand(False);
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
        tvNotes.Selected.Expand(False);
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
        x1 := ' from ' + upperCase(BeginDate);
        if EndDate <> '' then
          x1 := x1 + ' to ' + upperCase(EndDate)
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

procedure TfrmNotes.memNewNoteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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
    Key := #0; // Disable shift-tab processinend;
end;

procedure TfrmNotes.memNewNoteKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FNavigatingTab then
  begin
    if ssShift in Shift then
      FindNextControl(Sender as TWinControl, False, true, False).SetFocus
      // previous control
    else if ssCtrl in Shift then
      FindNextControl(Sender as TWinControl, true, true, False).SetFocus;
    // next control
    FNavigatingTab := False;
  end;
  if (Key = VK_ESCAPE) then
  begin
    FindNextControl(Sender as TWinControl, False, true, False).SetFocus;
    // previous control
    Key := 0;
  end;
end;

procedure TfrmNotes.memPCEReadExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.memPCEWriteExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
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
    InfoBox(TX_INVALID_AUTHOR1 + upperCase(NewAuthName) + TX_INVALID_AUTHOR2 +
      upperCase(FEditNote.AuthorName), TC_INVALID_AUTHOR,
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
        InfoBox(upperCase(AuthNameCheck) + TX_COSIGNER_REQD,
          TC_COSIGNER_REQD, MB_OK);
        // Cosigner := 0;   CosignerName := '';  // not sure about this yet
        ADummySender := TObject.Create;
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
    while assigned(Result) do
    begin
      if (Result.Data = MyTemplate) then
        exit;
      Result := Result.getNextSibling;
    end;
  end;

begin
  NeedPersonal := (UserTemplateAccessLevel <> taNone);
  if (NeedPersonal <> FHasPersonalTemplates) then
  begin
    if (NeedPersonal) then
    begin
      if (assigned(MyTemplate)) and (MyTemplate.Children in [tcActive, tcBoth])
      then
      begin
        AddTemplateNode(MyTemplate);
        FHasPersonalTemplates := true;
        if (assigned(MyTemplate)) then
        begin
          Node := FindNode;
          if (assigned(Node)) then
            Node.MoveTo(nil, naAddFirst);
        end;
      end;
    end
    else
    begin
      if (assigned(MyTemplate)) then
      begin
        Node := FindNode;
        if (assigned(Node)) then
          Node.Delete;
      end;
      FHasPersonalTemplates := False;
    end;
  end;
end;

procedure TfrmNotes.EncounterLocationChanged(Sender: TObject);
begin
  UpdatePersonalTemplates;
end;

procedure TfrmNotes.UpdateActMenu(DocID: String; ListComponent: TComponent);
Var
  WhyNot: string;
  SelectedImageIndex: System.UITypes.TImageIndex;
  DisableAll: boolean;

begin
  if not WriteAccess(waProgressNotes) then
    exit;

  TResponsiveGUI.ProcessMessages;
  DisableAll := True;
  try
    If ListComponent is TORTreeView then
    begin
      if TORTreeView(ListComponent).Selected = nil then
        exit;
      SelectedImageIndex := TORTreeView(ListComponent).Selected.ImageIndex;
    end
    else if ListComponent is TCaptionListView then
    begin
      if TCaptionListView(ListComponent).Selected = nil then
        exit;
      SelectedImageIndex := TCaptionListView(ListComponent).Selected.ImageIndex;
    end
    else
      exit;

    DisableAll := False;
    if uIDNotesActive then
    begin
      mnuActDetachFromIDParent.Enabled :=
        (SelectedImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
      popNoteListDetachFromIDParent.Enabled := mnuActDetachFromIDParent.Enabled;
      if (SelectedImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD,
        IMG_ID_CHILD_ADD]) then
        mnuActAttachtoIDParent.Enabled := CanBeAttached(DocID, WhyNot)
      else
        mnuActAttachtoIDParent.Enabled := False;
      popNoteListAttachtoIDParent.Enabled := mnuActAttachtoIDParent.Enabled;
      if (SelectedImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_IDNOTE_OPEN,
        IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
        mnuActAddIDEntry.Enabled := CanReceiveAttachment(DocID, WhyNot)
      else
        mnuActAddIDEntry.Enabled := False;
      popNoteListAddIDEntry.Enabled := mnuActAddIDEntry.Enabled
    end;
  finally
    if DisableAll then
    begin
      mnuActDetachFromIDParent.Enabled := False;
      popNoteListDetachFromIDParent.Enabled := False;
      mnuActAttachtoIDParent.Enabled := False;
      popNoteListAttachtoIDParent.Enabled := False;
      mnuActAddIDEntry.Enabled := False;
      popNoteListAddIDEntry.Enabled := False;
    end;
  end;
end;

procedure TfrmNotes.frmDrawersExit(Sender: TObject);
begin
  ExitToNextControl(Sender);
end;

procedure TfrmNotes.frmDrawersResize(Sender: TObject);
begin
  inherited;
  if Drawers.DrawerIsOpen then
  begin
    Drawers.LastOpenSize := pnlDrawers.height;
    if Drawers.LastOpenSize >
        (pnlLeftTop.Height - tvNotes.Constraints.MinHeight) then
      Drawers.LastOpenSize := (pnlLeftTop.Height - tvNotes.Constraints.MinHeight);
  end;
end;

procedure TfrmNotes.frmFramePnlToolbarExit(Sender: TObject);
begin
  if assigned(FOldFramePnlToolbarExit) then
    FOldFramePnlToolbarExit(Sender);

  ExitToNextControl(Sender);
end;

procedure TfrmNotes.SaveUserSplitterSettings(var posA, posB, posC,
  posD: Integer);
begin
  posA := memPCERead.height; // memPCEWrite.Height
  posB := CPMemNote.height; // cpmemNewNote.height
  posC := lvNotes.height;
  posD := 0;
end;

function BoolToInt(aBool:Boolean):Integer;
begin
  if aBool then
    Result := 0
  else
    Result := 1;
end;

procedure TfrmNotes.LoadNotes(SignedOnly: Boolean = False);
const
  INVALID_ID = -1;
  INFO_ID = 1;
  lastSM = 1; //
  MAX_RETRIES = 3;

var
  bChanging, HasUpdateBegun: Boolean;
  tmpList: TStringList;
  aChildNode: TTreeNode;
  aNode: TORTreeNode;
  lastNode: TTreeNode;
  X, xx, noteId: Integer; // Text Search CQ: HDS00002856
  Dest: TStrings; // Text Search CQ: HDS00002856
  KeepFlag: Boolean; // Text Search CQ: HDS00002856
  NoteCount, NoteMatches: Integer; // Text Search CQ: HDS00002856
  sLastID, aTempLastID, SrchStr: String;
  RefreshUnsigned: boolean;
  RetryCount: integer;
  Done: boolean;

begin
  if not Assigned(Self) then
    raise Exception.Create('LoadNotes, but frmNotes does not exist.');
  aTempLastID := fLastDocumentID;
  RetryCount := 0;
  repeat
    Done := True;
    try
      RefreshUnsigned := FUpdateUnsigned;
      FUpdateUnsigned := False;

      bChanging := uChanging;
      uChanging := true;
      sLastID := '';
      tmpList := TStringList.Create;
      try
        FDocList.Clear;

        memNote.LockDrawing;
        lvNotes.LockDrawing;
        try
          HasUpdateBegun := not SignedOnly;
          if HasUpdateBegun then
            tvNotes.Items.BeginUpdate;
          try
            lstNotes.Items.Clear;
            ClearTVNotes;
            // tvNotes.Items.EndUpdate;
            lvNotes.Items.Clear;
            memNote.Clear;
            memNote.Invalidate;
            stTitle.Caption := '';

            if FCurrentContext.MaxDocs <> 0 then
              sLastID := aTempLastID;

            if FCurrentContext.Status <> IntToStr(NC_UNSIGNED) then
            begin
              if RefreshUnsigned or (Not SignedOnly) then
              begin
                sLastID := ListNotesForTree(tmpList, NC_UNSIGNED, 0, 0, 0, 0,
                  FCurrentContext.TreeAscending, lastSM, '' { sLastID } );
                // no starting ID for UNSIGNED notes
                if tmpList.Count > 0 then
                begin
                  CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNSIGNED,
                    FCurrentContext.GroupBy, FCurrentContext.TreeAscending,
                    CT_NOTES);
                  fAllUnSignedNotes.Assign(FDocList);
                  UpdateTreeView(FDocList, tvNotes);
                end;
                tmpList.Clear;
              end
              else
              begin
                FDocList.Assign(fAllUnSignedNotes);
                UpdateTreeView(FDocList, tvNotes);
              end;
              // tmpList.Clear;
              FDocList.Clear;
            end;

            if (FCurrentContext.Status <> IntToStr(NC_UNCOSIGNED)) then
            begin
              if Not SignedOnly then
              begin
                sLastID := ListNotesForTree(tmpList, NC_UNCOSIGNED, 0, 0, 0, 0,
                  FCurrentContext.TreeAscending, lastSM, '' { sLastID } );
                // no starting ID for UNCOSIGNED
                if tmpList.Count > 0 then
                begin
                  CreateListItemsforDocumentTree(FDocList, tmpList, NC_UNCOSIGNED,
                    FCurrentContext.GroupBy, FCurrentContext.TreeAscending,
                    CT_NOTES);
                  fAllUnCoSignedNotes.Assign(FDocList);
                  UpdateTreeView(FDocList, tvNotes);
                end;
                tmpList.Clear;
              end
              else
              begin
                FDocList.Assign(fAllUnCoSignedNotes);
                UpdateTreeView(FDocList, tvNotes);
              end;
              tmpList.Clear;
              FDocList.Clear;
            end;

            if (FCurrentContext.MaxDocs <> 0) and RefreshUnsigned then
              sLastID := aTempLastID;

            sLastID := ListNotesForTree(tmpList,
              StrToIntDef(FCurrentContext.Status, 0),
              FCurrentContext.FMBeginDate, FCurrentContext.FMEndDate,
              FCurrentContext.Author, FCurrentContext.MaxDocs,
              FCurrentContext.TreeAscending,
              lastSM, sLastID);
            CreateListItemsforDocumentTree(FDocList, tmpList,
              StrToIntDef(FCurrentContext.Status, 0), FCurrentContext.GroupBy,
              FCurrentContext.TreeAscending, CT_NOTES);
            if FCurrentContext.MaxDocs <> 0 then
              aTempLastID := sLastID; // save Last signed document ID

            // Text Search CQ: HDS00002856 ---------------------------------------
            if FCurrentContext.SearchString <> '' then
            // Text Search CQ: HDS00002856
            begin
              SrchStr := upperCase(FCurrentContext.SearchString);
              NoteMatches := 0;
              NoteCount := FDocList.Count - 1;
              if FDocList.Count > 0 then
                for X := FDocList.Count - 1 downto 1 do
                begin // Don't do 0, because it's informational
                  KeepFlag := False;
                  stNotes.Caption := 'Scanning ' + IntToStr(NoteCount - X + 1) +
                    ' of ' + IntToStr(NoteCount) + ', ' + IntToStr(NoteMatches);
                  if NoteMatches = 1 then
                    stNotes.Caption := stNotes.Caption + ' match'
                  else
                    stNotes.Caption := stNotes.Caption + ' matches';
                  frmSearchStop.lblSearchStatus.Caption := stNotes.Caption;
                  frmSearchStop.lblSearchStatus.Repaint;
                  stNotes.Repaint;
                  // Free up some ticks so they can click the "Stop" button
                  TResponsiveGUI.ProcessMessages(True);
                  TResponsiveGUI.ProcessMessages(True);
                  TResponsiveGUI.ProcessMessages(True);
                  if SearchTextStopFlag then
                    break
                  else
                  begin
                    noteId := StrToIntDef(Piece(FDocList.Strings[X], '^', 1), -1);
                    if (noteId = INVALID_ID) or (noteId = INFO_ID) then
                      Continue;
                    Dest := TStringList.Create;
                    try
                      CallVistA('TIU GET RECORD TEXT',
                        [Piece(FDocList.Strings[X], '^', 1)], Dest);
                      if Dest.Count > 0 then
                        for xx := 0 to Dest.Count - 1 do
                        begin
                          if pos(SrchStr, upperCase(Dest[xx])) > 0 then
                          begin
                            KeepFlag := true;
                            break;
                          end;
                        end;
                    finally
                      FreeAndNil(Dest);
                    end;
                    if KeepFlag = False then
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
            end
            else
              // Reset the caption
              stNotes.Caption := SetNoteTreeLabel(FCurrentContext);

            // Text Search CQ: HDS00002856 ---------------------------------------
            if SignedOnly then
            begin
              fAllSignedNotes.AddStrings(FDocList);
              FDocList.Assign(fAllSignedNotes);
            end
            else
            begin
              fAllSignedNotes.Assign(FDocList);
            end;

            RemoveDuplicates(FDocList);

            FDocList.Sorted := False;
            AdjustOrder(FDocList, FCurrentContext);

            UpdateTreeView(FDocList, tvNotes);

            if FCurrentContext.GroupBy = '' then
              xx := 0
            else
              xx := 1;
            for X := fAllSignedNotes.Count - 1 downto 0 do
            begin
              if ShowMoreNode(fAllSignedNotes.Strings[X]) then
              begin
                fAllSignedNotes.Delete(X);
                inc(xx);
                if xx > 1 then
                  break;
              end;
            end;

            uChanging := true;
            // tvNotes.Items.BeginUpdate;
            RemoveParentsWithNoChildren(tvNotes, FCurrentContext);
            // moved here in v15.9 (RV)

            if RefreshUnsigned or (not SignedOnly) then
            begin
              if FLastNoteID <> '' then
                tvNotes.Selected := tvNotes.FindPieceNode(FLastNoteID, 1, U, nil);
              if not SignedOnly then
              begin
                if tvNotes.Selected = nil then
                begin
                  if (FCurrentContext.GroupBy <> '') or (FCurrentContext.Filtered) then
                  begin
                    aNode := TORTreeNode(tvNotes.Items.GetFirstNode);
                    while aNode <> nil do
                    begin
                      aNode.Expand(False);
                      tvNotes.Selected := aNode;
                      aNode := TORTreeNode(aNode.getNextSibling);
                    end;
                  end
                  else if not SignedOnly then
                  // Signed notes expand status restored separately
                  begin
                    aNode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                    if aNode <> nil then
                      aNode.Expand(False);
                    aNode := tvNotes.FindPieceNode(IntToStr(NC_UNSIGNED), 1, U, nil);
                    if aNode = nil then
                      aNode := tvNotes.FindPieceNode(IntToStr(NC_UNCOSIGNED),
                        1, U, nil);
                    if aNode = nil then
                      aNode := tvNotes.FindPieceNode(FCurrentContext.Status, 1, U, nil);
                    if aNode <> nil then
                    begin
        //RTC 852914              uChanging := False;
                      aChildNode := aNode.getFirstChild;
                      if Assigned(aChildNode) then
                        tvNotes.Selected := aChildNode
                      else
                        tvNotes.Selected := aNode;
                      uChanging := False; // RTC852914 moving here to avoid invocation of
                                          // tvNoteChange on assigning Selected item
                    end;
                  end;
                end;
              end;
            end;

            with lvNotes do
            begin
              Selected := nil;
              if FCurrentContext.SortBy <> '' then
                ColumnToSort := pos(FCurrentContext.SortBy, 'RDSAL') - 1;
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
          finally
            if HasUpdateBegun then
              tvNotes.Items.EndUpdate;
          end;

          if not SignedOnly then
            SendMessage(tvNotes.Handle, WM_VSCROLL, SB_TOP, 0);

          RemapNode(tvNotes, TX_MORE, upperCase('All signed notes'));
          // patching position of the node
          tvNotes.AlphaSort; // let's sort it after load

          lastNode := getNodeByName(targetAllSignedNotes, 0, tvNotes);
          if not assigned(lastNode) then
            LastNode := getNodeByName(targetSignedByDateRange, 0, tvNotes);
          if assigned(lastNode) then
          begin
            if FCurrentContext.TreeAscending then
              lastNode := lastNode.getFirstChild
            else
              lastNode := lastNode.GetLastChild;
            if assigned(lastNode) and
              (pos(TX_OLDER_NOTES_WITH_ADDENDA, lastNode.Text) > 0) then
              tvNotes.items.Delete(lastNode);
          end;

          if tvNotes.Selected <> nil then
            tvNotesChange(Self, tvNotes.Selected);

        finally
          lvNotes.UnlockDrawing;
          memNote.UnlockDrawing;
        end;
      finally
        FreeAndNil(tmpList);
      end;

      uChanging := bChanging; // restoring the original status;
      SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
    except
      on Exception do
      begin
        inc(RetryCount);
        if RetryCount < MAX_RETRIES then
        begin
          aTempLastID := fLastDocumentID;
          Done := False;
        end
        else
          raise;
      end;
    end;
  until Done;
  fLastDocumentID := aTempLastID;
end;

{
procedure TfrmNotes.SelectNode(aNode: TTreeNode = nil);
var
  X: String;
  tn: TTreeNode;
begin
  tn := aNode;
  if tn = nil then
    tn := tvNotes.Selected;

  if tn <> nil then
  begin
    X := TORTreeNode(tn).StringData;
    if (StrToIntDef(Piece(X, U, 1), 0) > 0)
    // including cases of "or (pos(TX_MORE,UpperCase(X))>0)"
    then
    begin
      SetLvNotesVisible(False);
      lstNotes.SelectByID(Piece(X, U, 1));
      // selects lstNotes Item corresponding to selected node of the tree.
      // In case of "SHOW MPRE" the tree node points
      lstNotesClick(Self);
      SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0)
    end;
  end;
end;

}
procedure TfrmNotes.DoSelect;
{
  procedure UpdateLastIcon;
  begin
    if lvNotes.Items.Count > 0 then
    begin
      if lvNotes.Items[lvNotes.Items.Count - 1].SubItems.Count > 0 then
        if pos(TX_MORE, lvNotes.Items[lvNotes.Items.Count - 1].SubItems[0]) > 0
        then
          lvNotes.Items[lvNotes.Items.Count - 1].ImageIndex := IMG_NONE;
    end;
  end;
}
  function getMyNodeID: String;
  begin
    Result := '';
    with tvNotes do
      if assigned(Selected) then
      begin
        if Selected.ImageIndex = IMG_TOP_LEVEL then
          Result := Piece(TORTreeNode(Selected).StringData, U, 1)
        else if assigned(Selected.Parent) then
        begin
          if Selected.Parent.ImageIndex = IMG_TOP_LEVEL then
            Result := Piece(TORTreeNode(Selected.Parent).StringData, U, 1)
          else if assigned(Selected.Parent.Parent) and
            (Selected.Parent.Parent.ImageIndex = IMG_TOP_LEVEL) then
            Result := Piece(TORTreeNode(Selected.Parent.Parent)
              .StringData, U, 1);
        end;
      end;
  end;

  procedure lvNotesInitView(aText: String);
  var
    s: string;
  begin
    lvNotes.Items.BeginUpdate;
    try
      SetLvNotesVisible(true);
      lvNotes.Items.Clear;
      lvNotes.height := (2 * lvNotes.Parent.height) div 5;
    finally
      lvNotes.Items.EndUpdate;
    end;

    stTitle.Caption := Trim(aText);
    if (FCurrentContext.SearchField <> '') and (FCurrentContext.Filtered) then
    begin
      case FCurrentContext.SearchField[1] of
        'T':
          s := 'TITLE';
        'S':
          s := 'SUBJECT';
        'B':
          s := 'TITLE or SUBJECT';
      end;
      stTitle.Caption := stTitle.Caption + ' where ' + s + ' contains "' +
        upperCase(FCurrentContext.Keyword) + '"';
      lvNotes.Caption := stTitle.Caption;
    end;
  end;

  procedure lvNotesUpdateView;
  var
    i: Integer;

  begin
    with lvNotes do
    begin
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
    AutoSizeColumns(lvNotes, [0]);
    // UpdateLastIcon;  //KCH 8/27/2015 for NSR 20070817 removing icon for "SHOW MORE" line
  end;

var
  X: String;
  MyNodeID: string;
  ReturnCursor: Integer;
begin
  if (Self = nil) or (not HandleAllocated) or (tvNotes.Selected = nil) then
    exit;
  UpdateActMenu('', nil);

  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    // This gives the change a chance to occur when keyboarding, so that WindowEyes doesn't use the old value.
    TResponsiveGUI.ProcessMessages;
    with tvNotes do
    begin
      if (Self = nil) or (not HandleAllocated) or (Selected = nil) then
        exit;
      if assigned(Selected.Data) then
        UpdateActMenu(PDocTreeObject(Selected.Data)^.DocID, tvNotes);
      tvNotes.LockDrawing;
      lvNotes.LockDrawing;
      memNote.LockDrawing;
      try
        popNoteListExpandSelected.Enabled := Selected.HasChildren;
        popNoteListCollapseSelected.Enabled := Selected.HasChildren;
        X := TORTreeNode(Selected).StringData;

        if (Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN,
          IMG_GROUP_SHUT]) then
        begin
          lvNotesInitView(Selected.Text);
          MyNodeID := getMyNodeID;

          uChanging := true;
          TraverseTree(tvNotes, lvNotes, Selected.getFirstChild, MyNodeID,
            FCurrentContext);
          lvNotesUpdateView;
          // uChanging := FALSE;  <-- moved down to avoid duplicate server calls
          with lvNotes do
          begin
            if Items.Count > 0 then
            begin
              Selected := Items[0];
              uChanging := False;
              lvNotesSelectItem(Self, Selected, true);
            end
            else
            begin
              Selected := nil;
              lstNotes.ItemIndex := -1;
              CPMemNote.EditMonitor.ItemIEN := lstNotes.ItemIEN;
              ClearPCE;
              ShowPCEControls(False);
            end;
          end;
          uChanging := False; // <-- new position

          ReadVisible := true;
          UpdateReminderFinish;
          ShowPCEControls(False);
          Drawers.DisplayDrawers(WriteAccess(waProgressNoteTemplates),
            Drawers.ActiveDrawer, [odTemplates], [odTemplates]);
          ShowPCEButtons(False);
        end
        else
          // SelectNode;
          if StrToIntDef(Piece(X, U, 1), 0) > 0 then
          begin
            memNote.Clear;
            SetLvNotesVisible(False);
            // lvNotes.Visible := FALSE;
            lstNotes.SelectByID(Piece(X, U, 1));
            lstNotesClick(Self);
            SendMessage(memNote.Handle, WM_VSCROLL, SB_TOP, 0);
          end;

        // display orphaned warning
//        if assigned(Selected.Data) and PDocTreeObject(Selected.Data)^.Orphaned then
//          MessageDlg(ORPHANED_NOTE_TEXT, mtInformation, [mbOK], -1);
        if assigned(Selected) and assigned(Selected.Data) and
          PDocTreeObject(Selected.Data)^.Orphaned then
          MessageDlg(ORPHANED_NOTE_TEXT, mtInformation, [mbOK], -1);
      finally
        memNote.UnlockDrawing;
        lvNotes.UnlockDrawing;
        tvNotes.UnlockDrawing;
      end;
    end;
  finally
    Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmNotes.GetMoreDocuments(Sender: TObject = nil);
var
  tn: TTreeNode;
  i: Integer;
  TiuID: String;
  saved: boolean;
  SavedDocID: string;
  ChangeNode: boolean;

const
  posTiuID = 5;

  procedure savePosition;
  begin
    TiuID := '';
    if lvNotes.ItemIndex - 1 < 0 then
      exit;
    if lvNotes.Items[lvNotes.ItemIndex - 1].SubItems.Count < posTiuID then
      exit;
    TiuID := lvNotes.Items[lvNotes.ItemIndex - 1].SubItems[posTiuID];
  end;

  procedure restorePosition;
  var
    i: Integer;
  begin
    if TiuID = '' then
      lvNotes.ItemIndex := lvNotes.Items.Count - 1
    else
      for i := lvNotes.Items.Count - 1 downto 0 do
        if TiuID = lvNotes.Items[i].SubItems[posTiuID] then
        begin
          lvNotes.ItemIndex := i;
          lvNotes.Items[i].MakeVisible(False);
          break;
        end;
  end;

begin
  if (Self = nil) then
    exit;
  ChangeNode := True;
  if EditingIndex >= 0 then
  begin
    SavedDocID := Piece(lstNotes.Items[EditingIndex], U, 1);
    saved := True;
    SaveCurrentNote(saved);
    if not saved then
      exit;
    FLastNoteID := SavedDocID;
    FUpdateUnsigned := True;
    ChangeNode := False;
  end;
  if Sender = nil then
  begin
    SaveExpandStatus;
    tvNotes.Items.BeginUpdate;
    try
      LoadNotes(true); // load only signed notes
      updateNotesCaption;
      DoSelect;
    finally
      tvNotes.Items.EndUpdate;
    end;

    RestoreExpandStatus;
    tvNotes.SortType := stData; // sort tree nodes after re-load
    tvNotes.AlphaSort;
    SendMessage(tvNotes.Handle, WM_HSCROLL, SB_THUMBTRACK, 0);
    // tvNotes.ScrollBy(0,0); // < - commented out to avoid horizontal scroll
    if ChangeNode then
      RestoreTreePosition; // < - saved @ OnChanging
    // SelectNode;
  end
  else if Sender = lvNotes then
  begin
    // savePosition;
    SaveExpandStatus;
    lvNotes.LockDrawing;
    try
      LoadNotes(true); // load only signed notes
      RestoreExpandStatus;
      updateNotesCaption;
      tn := getNodeByName(targetAllSignedNotes, 0, tvNotes);
      tvNotes.Selected := tn;

      if lvNotes.Items.Count > 0 then
      begin
        // i := lvNotes.Items.Count - FCurrentContext.MaxDocs;
        i := lvNotes.Items.Count - 2;
        // 2016-07-15 always one line prior to "SHOW MORE"
        if i < 0 then
          i := 0;
        lvNotes.ItemIndex := i;
        lvNotes.Items[i].MakeVisible(False);
        // RestorePosition;
      end;
    finally
      lvNotes.UnlockDrawing;
    end;
  end;
end;

procedure TfrmNotes.SetLvNotesVisible(aValue: Boolean);
begin
  lvNotes.Visible := aValue;
  splList.Visible := aValue;
  splList.Top := lvNotes.Top + 1;
end;

procedure TfrmNotes.UpdateNotesCaption(ReloadTotal: boolean = false);
var
  i, lvl: Integer;
  lvl1notes: Integer;
  tmpstr: String;
  CntNodes: Boolean;
begin
  if ReloadTotal then
    CallVistA('ORCNOTE GET TOTAL', [Patient.DFN], NoteTotal);
  lvl1notes := 0;
  CntNodes := False;
  if FCurrentContext.GroupBy = 'D' then
    lvl := 3
  else if FCurrentContext.GroupBy = '' then
    lvl := 1
  else
    lvl := 2;
  for i := 0 to tvNotes.Items.Count - 1 do
  begin
    if (AnsiContainsText('All signed notes', tvNotes.Items[i].Text)) OR
      (AnsiContainsText('Signed notes by date range', tvNotes.Items[i].Text))
    then
      // ADD CODE HERE TO SAVE INDEX
      CntNodes := true;
    if (CntNodes) and (tvNotes.Items.Item[i].Level = lvl) and
      (not ShowMoreNode(tvNotes.Items.Item[i].Text)) then
      Inc(lvl1notes);
  end;

  stNotes.Caption := SetNoteTreeLabel(FCurrentContext);
  tmpstr := ' ' + IntToStr(FCurrentContext.MaxDocs) + ' ';
  if AnsiContainsStr(stNotes.Caption, tmpstr) then
    stNotes.Caption := StringReplace(stNotes.Caption,
      IntToStr(FCurrentContext.MaxDocs), IntToStr(lvl1notes),
      [rfReplaceAll, rfIgnoreCase]);

  if Not AnsiContainsStr(stNotes.Caption, 'Total:') then
    stNotes.Caption := StringReplace(stNotes.Caption, 'Signed Notes',
      'Signed Notes' + ' (Total: ' + NoteTotal + ')',
      [rfReplaceAll, rfIgnoreCase]);
  stNotes.Hint := stNotes.Caption;
end;

procedure TfrmNotes.SaveTreePosition; // (fix 336188)
begin
  if uChanging then // ignore if change is in progress
    exit;
  // saving the document ID along with the parent node caption
  // as the same document may fall in different categories
  LastID := '';
  if assigned(tvNotes.Selected) then
  begin
    LastID := getNodeLocation(tvNotes.Selected) + U;
    if assigned(tvNotes.Selected.Data) then
      LastID := LastID + PDocTreeObject(tvNotes.Selected.Data)^.DocID
    else
      LastID := LastID + tvNotes.Selected.Text;
  end;
end;

procedure TfrmNotes.SaveExpandStatus; // (fix 336188)
begin
  if assigned(slExpandStatus) and (slExpandStatus <> nil) then
    slExpandStatus.Free;
  slExpandStatus := getExpandStatus(tvNotes);
end;

procedure TfrmNotes.RestoreTreePosition(bStepForward: Boolean = False);
// (fix 336188)

  function findLastTreeID(anID: String): TTreeNode;
  var
    i: Integer;
    sID: String;
    b: Boolean;

  begin
    // searching for the the node containing the document with given ID
    // and having the same parent node
    b := uChanging;
    uChanging := true;
    Result := nil;
    for i := 0 to tvNotes.Items.Count - 1 do
    begin
      Result := tvNotes.Items[i];
      sID := getNodeLocation(Result) + U;
      if assigned(Result.Data) then
        sID := sID + PDocTreeObject(Result.Data)^.DocID;
      if sID = LastID then
        break;
    end;
    uChanging := b;
  end;

var
  tn: TTreeNode;
  // b:boolean;
begin
  tn := findLastTreeID(LastID);
  if assigned(tn) then
  begin
    // b := uChanging;
    // uChanging := true;
    if not bStepForward then
    begin
      tvNotes.Selected := nil; // keep this line
      tvNotes.Selected := tn;
    end
    else if tn.getNextSibling <> nil then
      tvNotes.Selected := tn.getNextSibling
    else
      tvNotes.Selected := tn;

    // uChanging := b;
  end;
end;

procedure TfrmNotes.RestoreExpandStatus; // (fix 336188)
begin
  if assigned(slExpandStatus) then
  begin
    setExpandStatus(tvNotes.Items, slExpandStatus);
    FreeAndNil(slExpandStatus);
  end;
end;

function TfrmNotes.getNodeLocation(aNode: TTreeNode): String;
begin
  Result := '';
  if not assigned(aNode) then
    exit;
  case aNode.Level of
    0:
      Result := aNode.Text;
    1:
      Result := aNode.Parent.Text;
    2:
      Result := aNode.Parent.Parent.Text;
  end;
end;

procedure TfrmNotes.LoadUserSplitterSettings(posA, posB, posC, posD: Integer);
begin
  if posA > 0 then
  begin
    memPCERead.height := posA;
    memPCEWrite.height := posA;
  end;
  if posB > 0 then
  begin
    CPMemNote.height := posB;
    CPMemNewNote.height := posB;
  end;
  if posC > 0 then
    lvNotes.height := posC;
end;

function TfrmNotes.EditedNoteInfo: String;
begin
  Result := '';
  if EditingIndex > -1 then
    Result := 'Progress note ' + MakeNoteDisplayText
      (lstNotes.Items[EditingIndex]);
end;

initialization
  SpecifyFormIsNotADialog(TfrmNotes);
  uPCEMaster := TPCEData.Create;

finalization
  FreeAndNil(uPCEMaster);

end.

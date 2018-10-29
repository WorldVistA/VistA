unit fConsults;
{Notes of Intent:
  Tab Order:
    The tab order has been custom coded to place the pnlRight in the Tab order
    right after the tvConsults.  
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ORDtTm,
  fHSplit, stdCtrls, ExtCtrls, Menus, ComCtrls, ORCtrls, ORFn, uConsults, rOrders, uPCE,
  ORClasses, uConst, fDrawers, rTIU, uTIU, uDocTree, RichEdit, fPrintList,
  VA508AccessibilityManager, fBase508Form, VA508ImageListLabeler, ORextensions;

type
  TfrmConsults = class(TfrmHSplit)
    mnuConsults: TMainMenu;
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
    mnuAct: TMenuItem;
    Z2: TMenuItem;
    pnlRead: TPanel;
    lblTitle: TOROffsetLabel;
    memConsult: TRichEdit;
    pnlAction: TPanel;
    cmdNewConsult: TORAlignButton;
    Z3: TMenuItem;
    mnuViewAll: TMenuItem;
    mnuViewByService: TMenuItem;
    mnuViewByDate: TMenuItem;
    mnuViewByStatus: TMenuItem;
    cmdNewProc: TORAlignButton;
    N1: TMenuItem;
    mnuActConsultRequest: TMenuItem;
    mnuActReceive: TMenuItem;
    mnuActDeny: TMenuItem;
    mnuActForward: TMenuItem;
    mnuActDiscontinue: TMenuItem;
    mnuActAddComment: TMenuItem;
    mnuActComplete: TMenuItem;
    mnuActNew: TMenuItem;
    mnuActNewConsultRequest: TMenuItem;
    mnuActNewProcedure: TMenuItem;
    mnuActSignatureList: TMenuItem;
    mnuActSignatureSave: TMenuItem;
    mnuActSignatureSign: TMenuItem;
    mnuActMakeAddendum: TMenuItem;
    mnuViewCustom: TMenuItem;
    pnlResults: TPanel;
    memResults: TRichEdit;
    mnuActNoteEdit: TMenuItem;
    mnuActNoteDelete: TMenuItem;
    sptVert: TSplitter;
    memPCEShow: TRichEdit;
    cmdEditResubmit: TORAlignButton;
    cmdPCE: TORAlignButton;
    mnuActConsultResults: TMenuItem;
    N2: TMenuItem;
    lstNotes: TORListBox;
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
    popConsultList: TPopupMenu;
    popConsultAll: TMenuItem;
    popConsultStatus: TMenuItem;
    popConsultService: TMenuItem;
    popConsultDates: TMenuItem;
    popConsultCustom: TMenuItem;
    mnuActPrintSF513: TMenuItem;
    N3: TMenuItem;
    mnuActDisplayDetails: TMenuItem;
    mnuActDisplayResults: TMenuItem;
    mnuActDisplaySF513: TMenuItem;
    mnuActSigFindings: TMenuItem;
    mnuActAdminComplete: TMenuItem;
    mnuActIdentifyAddlSigners: TMenuItem;
    popNoteMemoAddlSign: TMenuItem;
    Z11: TMenuItem;
    popNoteMemoSpell: TMenuItem;
    popNoteMemoGrammar: TMenuItem;
    mnuActEditResubmit: TMenuItem;
    N4: TMenuItem;
    mnuViewSaveAsDefault: TMenuItem;
    mnuViewReturntoDefault: TMenuItem;
    splDrawers: TSplitter;
    N5: TMenuItem;
    popNoteMemoTemplate: TMenuItem;
    mnuOptions: TMenuItem;
    mnuEditTemplates: TMenuItem;
    mnuNewTemplate: TMenuItem;
    splConsults: TSplitter;
    pnlConsultList: TPanel;
    lblConsults: TOROffsetLabel;
    lstConsults: TORListBox;
    N6: TMenuItem;
    mnuEditSharedTemplates: TMenuItem;
    mnuNewSharedTemplate: TMenuItem;
    popNoteMemoPrint: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    mnuActNotePrint: TMenuItem;
    timAutoSave: TTimer;
    pnlFields: TPanel;
    lblNewTitle: TStaticText;
    lblRefDate: TStaticText;
    lblAuthor: TStaticText;
    lblVisit: TStaticText;
    lblCosigner: TStaticText;
    lblSubject: TStaticText;
    cmdChange: TButton;
    txtSubject: TCaptionEdit;
    mnuActSchedule: TMenuItem;
    popNoteMemoPaste2: TMenuItem;
    popNoteMemoReformat: TMenuItem;
    N9: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActLoadBoiler: TMenuItem;
    bvlNewTitle: TBevel;
    popNoteMemoSaveContinue: TMenuItem;
    mnuActAttachMed: TMenuItem;
    mnuActRemoveMed: TMenuItem;
    N10: TMenuItem;
    mnuEditDialgFields: TMenuItem;
    tvCsltNotes: TORTreeView;
    popNoteList: TPopupMenu;
    popNoteListExpandSelected: TMenuItem;
    popNoteListExpandAll: TMenuItem;
    popNoteListCollapseSelected: TMenuItem;
    popNoteListCollapseAll: TMenuItem;
    N11: TMenuItem;
    popNoteListDetachFromIDParent: TMenuItem;
    N12: TMenuItem;
    mnuActDetachFromIDParent: TMenuItem;
    mnuActAddIDEntry: TMenuItem;
    tvConsults: TORTreeView;
    popNoteListAddIDEntry: TMenuItem;
    N13: TMenuItem;
    mnuIconLegend: TMenuItem;
    dlgFindText: TFindDialog;
    popNoteMemoFind: TMenuItem;
    dlgReplaceText: TReplaceDialog;
    N14: TMenuItem;
    popNoteMemoReplace: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuActAttachtoIDParent: TMenuItem;
    popNoteListAttachtoIDParent: TMenuItem;
    popNoteMemoAddend: TMenuItem;
    N15: TMenuItem;
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
    imgLblNotes: TVA508ImageListLabeler;
    imgLblImages: TVA508ImageListLabeler;
    imgLblConsults: TVA508ImageListLabeler;
    popNoteMemoViewCslt: TMenuItem;   //wat cq 17586
    procedure mnuChartTabClick(Sender: TObject);
    procedure lstConsultsClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure cmdNewConsultClick(Sender: TObject);
    procedure memResultChange(Sender: TObject);
    procedure mnuActCompleteClick(Sender: TObject);
    procedure mnuActAddIDEntryClick(Sender: TObject);
    procedure mnuActSignatureSaveClick(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure mnuActSignatureListClick(Sender: TObject);
    procedure mnuActSignatureSignClick(Sender: TObject);
    procedure mnuActMakeAddendumClick(Sender: TObject);
    procedure mnuActDetachFromIDParentClick(Sender: TObject);
    procedure mnuActAttachtoIDParentClick(Sender: TObject);
    procedure cmdPCEClick(Sender: TObject);
    procedure mnuActConsultClick(Sender: TObject);
    procedure mnuActNewConsultRequestClick(Sender: TObject);
    procedure mnuActNoteEditClick(Sender: TObject);
    procedure mnuActNoteDeleteClick(Sender: TObject);
    procedure lstNotesClick(Sender: TObject);
    procedure popNoteMemoCutClick(Sender: TObject);
    procedure popNoteMemoCopyClick(Sender: TObject);
    procedure popNoteMemoPasteClick(Sender: TObject);
    procedure popNoteMemoPopup(Sender: TObject);
    procedure NewPersonNeedData(Sender: TObject; const StartFrom: string;
       Direction, InsertAt: Integer);
    procedure cmdNewProcClick(Sender: TObject);
    procedure mnuActNewProcedureClick(Sender: TObject);
    procedure mnuActDisplayResultsClick(Sender: TObject);
    procedure mnuActDisplaySF513Click(Sender: TObject);
    procedure pnlResultsResize(Sender: TObject);
    procedure mnuActPrintSF513Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuActDisplayDetailsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuActIdentifyAddlSignersClick(Sender: TObject);
    procedure popNoteMemoAddlSignClick(Sender: TObject);
    procedure mnuActEditResubmitClick(Sender: TObject);
    procedure EnableDisableOrdering;
    procedure cmdEditResubmitClick(Sender: TObject);
    procedure popNoteMemoSpellClick(Sender: TObject);
    procedure popNoteMemoGrammarClick(Sender: TObject);
    procedure mnuViewSaveAsDefaultClick(Sender: TObject);
    procedure mnuViewReturntoDefaultClick(Sender: TObject);
    procedure popNoteMemoTemplateClick(Sender: TObject);
    procedure mnuEditTemplatesClick(Sender: TObject);
    procedure mnuNewTemplateClick(Sender: TObject);
    procedure pnlLeftResize(Sender: TObject);
    procedure mnuOptionsClick(Sender: TObject);
    procedure mnuEditSharedTemplatesClick(Sender: TObject);
    procedure mnuNewSharedTemplateClick(Sender: TObject);
    procedure popNoteMemoPrintClick(Sender: TObject);
    procedure mnuActNotePrintClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timAutoSaveTimer(Sender: TObject);
    procedure cmdChangeClick(Sender: TObject);
    procedure pnlFieldsResize(Sender: TObject);
    procedure popNoteMemoReformatClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActLoadBoilerClick(Sender: TObject);
    procedure popNoteMemoSaveContinueClick(Sender: TObject);
    procedure ProcessMedResults(ActionType: string);
    procedure mnuActAttachMedClick(Sender: TObject);
    procedure mnuActRemoveMedClick(Sender: TObject);
    procedure mnuEditDialgFieldsClick(Sender: TObject);
    procedure tvCsltNotesChange(Sender: TObject; Node: TTreeNode);
    procedure tvCsltNotesCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvCsltNotesExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvCsltNotesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure tvCsltNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvCsltNotesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure popNoteListExpandSelectedClick(Sender: TObject);
    procedure popNoteListExpandAllClick(Sender: TObject);
    procedure popNoteListCollapseSelectedClick(Sender: TObject);
    procedure popNoteListCollapseAllClick(Sender: TObject);
    procedure tvCsltNotesClick(Sender: TObject);
    procedure tvConsultsExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvConsultsCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvConsultsClick(Sender: TObject);
    procedure tvConsultsChange(Sender: TObject; Node: TTreeNode);
    procedure popNoteListPopup(Sender: TObject);
    procedure mnuIconLegendClick(Sender: TObject);
    procedure popNoteMemoFindClick(Sender: TObject);
    procedure dlgFindTextFind(Sender: TObject);
    procedure dlgReplaceTextFind(Sender: TObject);
    procedure dlgReplaceTextReplace(Sender: TObject);
    procedure popNoteMemoReplaceClick(Sender: TObject);
    procedure tvConsultsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memResultsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sptHorzCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
    procedure popNoteMemoPreviewClick(Sender: TObject);
    procedure popNoteMemoInsTemplateClick(Sender: TObject);
    procedure tvConsultsExit(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure pnlLeftExit(Sender: TObject);
    procedure pnlRightExit(Sender: TObject);
    procedure cmdEditResubmitExit(Sender: TObject);
    procedure cmdNewConsultExit(Sender: TObject);
    procedure popNoteMemoViewCsltClick(Sender: TObject);   //wat cq 17586
  private
    FocusToRightPanel : Boolean;
    FEditingIndex: Integer;      // TIU index of document being currently edited
    FChanged: Boolean;
    FActionType: integer ;
    FEditCtrl: TCustomEdit;
    FSilent: Boolean;
    FCurrentContext: TSelectContext;
    FDefaultContext: TSelectContext;
    FCurrentNoteContext: TTIUContext;
    FOrderID: string;
    FImageFlag: TBitmap;
    FEditNote: TEditNoteRec;
    FVerifyNoteTitle: Integer;
    FDocList: TStringList;
    FConfirmed: boolean;
    FCsltList: TStringList;
    FDeleted: boolean;
    FLastNoteID: string;
    FcmdChangeOKPressed: boolean;
    FNotifPending: boolean;
    FOldFramePnlPatientExit: TNotifyEvent;
    //FMousing: TDateTime;
    procedure DoLeftPanelCustomShiftTab;
    procedure frmFramePnlPatientExit(Sender: TObject);
    procedure DoAutoSave(Suppress: integer = 1);
    function GetTitleText(AnIndex: Integer): string;
    //function MakeTitleText(IsAddendum: Boolean = False): string;
    procedure ClearEditControls;
    procedure LoadForEdit ;
    function LacksRequiredForCreate: Boolean;
    function LacksClinProcFields(AnEditRec: TEditNoteRec; AMenuAccessRec: TMenuAccessRec; var ErrMsg: string): boolean;
    function LacksClinProcFieldsForSignature(NoteIEN: int64; var ErrMsg: string): boolean;
    procedure UpdateList;
    procedure DisplayPCE;
    procedure CompleteConsult(IsIDChild: boolean; AnIDParent: integer; UseClinProcTitles: boolean);
    procedure InsertAddendum;
    procedure SetSubjectVisible(ShouldShow: Boolean);
    procedure SaveEditedConsult(var Saved: Boolean);
    procedure ShowPCEControls(ShouldShow: Boolean);
    procedure SetActionMenus ;
    procedure SetResultMenus ;
    procedure RemovePCEFromChanges(IEN: Integer; AVisitStr: string = '');
    procedure ProcessNotifications;
    procedure UMNewOrder(var Message: TMessage);   message UM_NEWORDER;
    procedure SetViewContext(AContext: TSelectContext);
    function GetDrawers: TFrmDrawers;
    function LockConsultRequest(AConsult: Integer): Boolean;
    function LockConsultRequestAndNote(AnIEN: Int64): Boolean;
    function StartNewEdit(NewNoteType: integer): Boolean;
    procedure UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
    function CanFinishReminder: boolean;
    function VerifyNoteTitle: Boolean;
    procedure UpdateNoteTreeView(DocList: TStringList; Tree: TORTreeView; AContext: integer);
    procedure EnableDisableIDNotes;
    procedure LoadConsults;
    procedure UpdateConsultsTreeView(DocList: TStringList; Tree: TORTreeView);
    procedure DoAttachIDChild(AChild, AParent: TORTreeNode);
    function UserIsSigner(NoteIEN: integer): boolean;
  public
    property OrderID: string read FOrderID;
    function CustomCanFocus(Control: TWinControl): Boolean; //CB
    function LinesVisible(richedit: Trichedit): integer; //CB
    function ActiveEditOf(AnIEN: Int64): Boolean;
    function  AllowContextChange(var WhyNot: string): Boolean; override;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure SetFontSize(NewFontSize: Integer); override;
    procedure SaveSignItem(const ItemID, ESCode: string);
    procedure RequestPrint; override;
    procedure RequestMultiplePrint(AForm: TfrmPrintList);
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); override;
    function AuthorizedUser: Boolean;
    procedure AssignRemForm;
    procedure LstConsultsToPrint;
    procedure SaveCurrentNote(var Saved: Boolean);
    procedure SetEditingIndex(const Value: Integer);
    property EditingIndex: Integer read FEditingIndex write SetEditingIndex;
  published
    property Drawers: TFrmDrawers read GetDrawers; // Keep Drawers published
  end;


var
  frmConsults: TfrmConsults;

const
  CN_ACT_RECEIVE     =   1 ;
  CN_ACT_DENY        =   2 ;
  CN_ACT_DISCONTINUE =   3 ;
  CN_ACT_FORWARD     =   4 ;
  CN_ACT_ADD_CMT     =   5 ;
  CN_ACT_COMPLETE    =   6 ;
  CN_ACT_ADDENDUM    =   7 ;
  CN_ACT_SIGFIND     =   8 ;
  CN_ACT_ADMIN_COMPLETE = 9 ;
  CN_ACT_SCHEDULE       = 10;
  CN_ACT_CP_COMPLETE    = 11;

  ActionType: array[1..11] of string = ('Receive Consult','Cancel (Deny) Consult',
                'Discontinue Consult','Forward Consult','Add Comment to Consult',
                'Complete Consult', 'Make Addendum to Consult', 'Update Significant Findings',
                'Administratively Complete', 'Schedule Consult', 'Complete Clinical Procedure') ;

implementation

{$R *.DFM}

uses fVisit, rCore, uCore, rConsults, fConsultBS, fConsultBD, fSignItem,
     fConsultBSt, fConsultsView, fConsultAct, fEncnt, rPCE, fEncounterFrame,
     Clipbrd, rReports, fRptBox, fConsult513Prt, fODConsult, fODProc, fCsltNote, fAddlSigners,
     fOrders, rVitals, fFrame, fNoteDR, fEditProc, fEditConsult, uOrders, rODBase, uSpell, {*KCM*}
     fTemplateEditor, fNotePrt, fNotes, fNoteProps, fNotesBP, fReminderTree,
     fReminderDialog, uReminders, fConsMedRslt, fTemplateFieldEditor, System.Types,
     dShared, rTemplates, fIconLegend, fNoteIDParents, fNoteCPFields, rECS, ORNet, trpcb,
     uTemplates, fTemplateDialog, DateUtils, uVA508CPRSCompatibility, VA508AccessibilityRouter,
     System.UITypes;

const
  CT_ORDERS =   4;                               // ID for orders tab used by frmFrame
  EF_VISIT_TYPE = 10;
  EF_VITALS     = 200;
  EF_DIAGNOSES  = 20;
  EF_PROCEDURES = 30;
  EF_ORDERS     = 100;

  CA_CREATE     = 0;                             // create new consult result
  CA_SHOW       = 1;                             // show current note
  CA_SAVECREATE = 2;                             // save current then create
  CA_EDIT       = 3;                             // save current note, then edit an existing note
  CA_SAVEEDIT   = 4;

  CN_NEW_RESULT = -30;                           // Holder IEN for a new Consult Result
  CN_ADDENDUM   = -40;                           // Holder IEN for a new addendum

  NT_ACT_NEW_NOTE  = 2;
  NT_ACT_ADDENDUM  = 3;
  NT_ACT_EDIT_NOTE = 4;
  NT_ACT_ID_ENTRY  = 5;

  ST_DISCONTINUED    = 1  ;
  ST_COMPLETE        = 2  ;
  ST_HOLD            = 3  ;
  ST_FLAGGED         = 4  ;
  ST_PENDING         = 5  ;
  ST_ACTIVE          = 6  ;
  ST_EXPIRED         = 7  ;
  ST_SCHEDULED       = 8  ;
  ST_PARTIAL_RESULTS = 9  ;
  ST_DELAYED         = 10 ;
  ST_UNRELEASED      = 11 ;
  ST_CHANGED         = 12 ;
  ST_CANCELLED       = 13 ;
  ST_LAPSED          = 14 ;
  ST_RENEWED         = 15 ;
  ST_NO_STATUS       = 99 ;

  TYP_PROGRESS_NOTE = 3;
  TYP_ADDENDUM      = 81;
  TX_PROV_LOC   = 'A provider and location must be selected before entering orders.';
  TC_PROV_LOC   = 'Incomplete Information';

  TX_NEED_VISIT = 'A visit is required before creating a new consult result.';
  TX_NO_VISIT   = 'Insufficient Visit Information';
  TX_BOILERPLT  = 'You have modified the text of this note.  Changing the title will' +
                  ' discard the note text.' + CRLF + 'Do you wish to continue?';
  TX_NEWTITLE   = 'Change Consult Title';
  TX_REQD_CONSULT  = 'The following information is required to save a Consult Result - ' + CRLF;
  TX_REQD_ADDM  = 'The following information is required to save an addendum - ' + CRLF;
  TX_REQ2       = CRLF + CRLF +
                  'It is recommended that these fields be entered before continuing' + CRLF +
                  'to prevent losing the note should the application time out.';
  TX_CREATE_ERR = 'Error Creating Note';
  TX_UPDATE_ERR = 'Error Updating Note';
  TX_NO_CONSULT    = 'No note is currently being edited';
  TX_SAVE_CONSULT  = 'Save Note';
  TX_ADDEND_NO  = 'Cannot make an addendum to a note that is being edited';
  TX_DEL_OK     = CRLF + CRLF + 'Delete this note?';
  TX_DEL_ERR    = 'Unable to Delete note';
  TX_SIGN       = 'Sign Note';
  TX_COSIGN     = 'Cosign Note';
  TX_REQD_COSIG = CRLF + 'Expected Cosigner';
  TX_REQ_COSIGNER = 'A cosigner must be identified.';
  TX_SIGN_ERR   = 'Unable to Sign Note';
  TX_INVALID_CONSULT_CAP = 'Invalid consult record' ;
  TX_INVALID_CONSULT_TEXT = 'Unable to retrieve the information for this consult.' ;
  TX_SCREQD     = 'This progress note title requires the service connected questions to be '+
                  'answered.  The Encounter form will now be opened.  Please answer all '+
                  'service connected questions.';
  TX_SCREQD_T   = 'Response required for SC questions.';
  TX_NOPRT_NEW  = 'This consult may not be printed until the current note is saved';
  TX_NOPRT_NEW_CAP = 'Save Consult Result';
  TX_NOCONSULT     = 'No consult is currently selected.';
  TX_NOCSLT_CAP = 'No Consult Selected';
  TX_NONOTE     = 'No note is currently selected.';
  TX_NONOTE_CAP = 'No Note Selected';
  TX_NO_ORDER   = 'Ordering has been disabled.';
  TX_NO_ORDER_CAP = 'Unable to place order';
  TX_PROV_KEY   = 'The provider selected for this encounter must' + CRLF +
                  'hold the PROVIDER key to enter orders.';
  TC_PROV_KEY   = 'PROVIDER Key Required';
  TX_NOKEY   = 'You do not have the keys required to take this action.';
  TC_NOKEY   = 'Insufficient Authority';
  TX_BADKEYS = 'You have mutually exclusive order entry keys (ORES, ORELSE, or OREMAS).' +
               CRLF + 'This must be resolved before you can enter orders.';
  TC_BADKEYS = 'Multiple Keys';
  TX_NO_FUTURE_DT = 'A Reference Date/Time in the future is not allowed.';
  TX_ORDER_LOCKED = 'This record is locked by an action underway on the Notes tab';
  TC_ORDER_LOCKED = 'Unable to access record';
  TC_NO_RESUBMIT  = 'Unable to resubmit';
  TX_NO_ORD_CHG   = 'The note is still associated with the previously selected request.' + CRLF +
                    'Finish the pending action, then try again.';
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
  TX_CP_NO_RESULTS = 'This Clinical Procedure cannot be completed yet.' + CRLF +
                     'No results are available for interpretation.';
  TC_CP_NO_RESULTS = 'No Results Available';
  TX_CLIN_PROC     = 'A procedure summary code and valid date/time for the procedure must be entered.';
  TX_NO_AUTHOR     = 'An author must be entered for the note.';
  TC_CLIN_PROC     = 'Missing Information for Clinical Procedures Document';
  TX_DETACH_CNF     = 'Confirm Detachment';
  TX_DETACH_FAILURE = 'Detach failed';

  DLG_CONSULT = 'C';
  DLG_PROC    = 'P';
  TX_RETRACT_CAP    = 'Retraction Notice';
  TX_RETRACT        = 'This document will now be RETRACTED.  As Such, it has been removed' +CRLF +
                      ' from public view, and from typical Releases of Information,' +CRLF +
                      ' but will remain indefinitely discoverable to HIMS.' +CRLF +CRLF;
  TX_AUTH_SIGNED    = 'Author has not signed, are you SURE you want to sign.' +CRLF;

var
  ViewContext, CurrNotifIEN: integer ;
  SvcCtxt: TServiceContext;
  StsCtxt: TStatusContext ;
  DateRange: TConsultDateRange;
  uSelectContext: TSelectContext  ;
  uPCEShow, uPCEEdit:  TPCEData;
  frmDrawers: TfrmDrawers;
  MenuAccessRec: TMenuAccessRec;
  MedResult: TMedResultRec;
  uChanging: Boolean;
  uIDNotesActive: boolean;

{ TPage common methods --------------------------------------------------------------------- }

procedure TfrmConsults.SetEditingIndex(const Value: Integer);
begin
  FEditingIndex := Value;
  if(FEditingIndex < 0) then
    KillReminderDialog(Self);
  if(assigned(frmReminderTree)) then
    frmReminderTree.EnableActions;
end;

function TfrmConsults.AllowContextChange(var WhyNot: string): Boolean;
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
             if memResults.GetTextLen > 0 then
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

procedure TfrmConsults.ClearPtData;
{ clear all controls that contain patient specific information }
begin
  inherited ClearPtData;
  ClearEditControls;
  lstConsults.Clear;
  memConsult.Clear;
  memResults.Clear;
  uChanging := True;
  tvCsltNotes.Items.BeginUpdate;
  KillDocTreeObjects(tvCsltNotes);
  tvCsltNotes.Items.Clear;
  tvCsltNotes.Items.EndUpdate;
  tvConsults.Items.BeginUpdate;
  tvConsults.Items.Clear;
  tvConsults.Items.EndUpdate;
  uChanging := False;
  lstNotes.Clear ;
  memPCEShow.Clear;
  uPCEShow.Clear;
  frmDrawers.ResetTemplates;
  FOrderID := '';
end;

procedure TfrmConsults.SetViewContext(AContext: TSelectContext);
var
  Saved: boolean;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FCurrentContext := AContext;
  CurrNotifIEN := 0;
  EditingIndex := -1;
  pnlConsultList.Enabled := True; //CQ#15785
//  tvConsults.Enabled := True;
//  lstConsults.Enabled := True ;
  lstNotes.Enabled := True ;
  pnlRead.BringToFront ;
  memConsult.TabStop := True;
  with uSelectContext do
    begin
      BeginDate := FCurrentContext.BeginDate;
      EndDate   := FCurrentContext.EndDate;
      Status    := FCurrentContext.Status;
      Service   := FCurrentContext.Service;
      Ascending := FCurrentContext.Ascending;
      GroupBy   := FCurrentContext.GroupBy;
      Changed   := True;
      mnuViewClick(Self);
    end;
end;

procedure TfrmConsults.DisplayPage;
{ causes page to be visible and conditionally executes initialization code }
begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_CONSULTS;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  frmFrame.mnuFilePrintSelectedItems.Enabled := True;
  FNotifPending := False;
  if InitPage then
  begin
    FDefaultContext := GetCurrentContext;
    FCurrentContext := FDefaultContext;
    popNoteMemoSpell.Visible   := SpellCheckAvailable;
    popNoteMemoGrammar.Visible := popNoteMemoSpell.Visible;
    Z11.Visible                := popNoteMemoSpell.Visible;
    timAutoSave.Interval := User.AutoSave * 1000;  // convert seconds to milliseconds
    SetEqualTabStops(memResults);
  end;
  cmdEditResubmit.Visible := False;
  EnableDisableIDNotes;
  EnableDisableOrdering;
  if InitPage then SendMessage(memConsult.Handle, EM_SETMARGINS, EC_LEFTMARGIN, 4);
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
  //with tvConsults do if Selected <> nil then tvConsultsChange(Self, Selected);   
end;

procedure TfrmConsults.SetFontSize(NewFontSize: Integer);
{ adjusts the font size of any controls that don't have ParentFont = True }
begin
  inherited SetFontSize(NewFontSize);
  memConsult.Font.Size  := NewFontSize;
  memResults.Font.Size  := NewFontSize;
  lblTitle.Font.Size    := NewFontSize;
  frmDrawers.Font.Size  := NewFontSize;
  SetEqualTabStops(memResults);
  // adjust heights of pnlAction, pnlFields, and memPCEShow
end;

procedure TfrmConsults.mnuChartTabClick(Sender: TObject);
{ reroute to Chart Tab menu of the parent form: frmFrame }
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

{ General procedures ----------------------------------------------------------------------- }

procedure TfrmConsults.ClearEditControls;
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
    //Consult      := 0;
    PkgRef       := '';
    PkgIEN       := 0;
    PkgPtr       := '';
    NeedCPT      := False;
    Addend       := 0;
    Lines        := nil;
  end;
  // clear the editing controls (also clear the new labels?)
  txtSubject.Text := '';
  memResults.Clear;
  timAutoSave.Enabled := False;
  // clear the PCE object for editing
  uPCEEdit.Clear;
  // set the tracking variables to initial state
  EditingIndex := -1;
  frmConsults.ActiveControl := nil;
  ShowPCEControls(FALSE);
  FChanged := False;
end;

procedure TfrmConsults.CompleteConsult(IsIDChild: boolean; AnIDParent: integer; UseClinProcTitles: boolean);
{ creates the editing context for a new progress note & inserts stub into top of view list }
const
  USE_CURRENT_VISITSTR = -2;
var
  EnableAutosave, HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  TmpBoilerPlate: TStringList;
  x, WhyNot: string;
  tmpNode: TTreeNode;
  AClassName: string;
  DocInfo: string;
begin
  EnableAutosave := FALSE;
  TmpBoilerPlate := nil;
  try
    ClearEditControls;
    pnlConsultList.Enabled := False; //CQ#15785
//    tvConsults.Enabled := False;
//    lstConsults.Enabled := False ;
    FillChar(FEditNote, SizeOf(FEditNote), 0);  //v15.7
    with FEditNote do
    begin
      if UseClinProcTitles then
        begin
          DocType      := IdentifyClinProcClass;
          Title        := DfltClinProcTitle;
          TitleName    := DfltClinProcTitleName;
          AClassName   := DCL_CLINPROC;
        end
      else
        begin
          DocType      := TYP_PROGRESS_NOTE;
          Title        := DfltConsultTitle;
          TitleName    := DfltConsultTitleName;
          AClassName   := DCL_CONSULTS
        end;
      if IsIDChild and (not CanTitleBeIDChild(Title, WhyNot)) then
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
      PkgRef       := lstConsults.ItemID + ';' + PKG_CONSULTS;
      PkgIEN       := lstConsults.ItemIEN;
      PkgPtr       := PKG_CONSULTS;
      // Cosigner, if needed, will be set by fNoteProps
    end;
    // check to see if interaction necessary to get required fields
    if LacksRequiredForCreate or VerifyNoteTitle
      then HaveRequired := ExecuteNoteProperties(FEditNote, CT_CONSULTS, IsIDChild, False, AClassName,
                              MenuAccessRec.ClinProcFlag)
      else HaveRequired := True;
    // lock the consult request if there is a consult
    if FEditNote.PkgIEN > 0 then HaveRequired := HaveRequired and LockConsultRequest(FEditNote.PkgIEN);
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
            if lstNotes.DisplayText[0] = 'None' then
              begin
                uChanging := True;
                tvCsltNotes.Items.BeginUpdate;
                lstNotes.Items.Clear;
                KillDocTreeObjects(tvCsltNotes);
                tvCsltNotes.Items.Clear;
                tvCsltNotes.Items.EndUpdate;
                uChanging := False;
              end;
            with FEditNote do
              begin
                x := IntToStr(CreatedNote.IEN) + U + TitleName + U + FloatToStr(DateTime) + U +
                     Patient.Name + U + IntToStr(Author) + ';' + AuthorName + U + LocationName + U + 'new' + U +
                     'Adm: ' + FormatFMDateTime('dddddd', VisitDate) + ';' + FloatToStr(VisitDate) + U + U +
                     U + U + U + U + U + U;
              end;
            lstNotes.Items.Insert(0, x);
            uChanging := True;
            tvCsltNotes.Items.BeginUpdate;
            if IsIDChild then
              begin
                tmpNode := tvCsltNotes.FindPieceNode(IntToStr(AnIDParent), 1, U, tvCsltNotes.Items.GetFirstNode);
                tmpNode.ImageIndex := IMG_IDNOTE_OPEN;
                tmpNode.SelectedIndex := IMG_IDNOTE_OPEN;
                tmpNode := tvCsltNotes.Items.AddChildObjectFirst(tmpNode, MakeConsultNoteDisplayText(x), MakeNoteTreeObject(x));
                tmpNode.ImageIndex := IMG_ID_CHILD;
                tmpNode.SelectedIndex := IMG_ID_CHILD;
              end
            else
              begin
                tmpNode := tvCsltNotes.Items.AddObjectFirst(tvCsltNotes.Items.GetFirstNode, 'New Note in Progress',
                                                        MakeNoteTreeObject('NEW^New Note in Progress^^^^^^^^^^^%^0'));
                TORTreeNode(tmpNode).StringData := 'NEW^New Note in Progress^^^^^^^^^^^%^0';
                tmpNode.ImageIndex := IMG_TOP_LEVEL;
                tmpNode := tvCsltNotes.Items.AddChildObjectFirst(tmpNode, MakeConsultNoteDisplayText(x), MakeNoteTreeObject(x));
                tmpNode.ImageIndex := IMG_SINGLE;
                tmpNode.SelectedIndex := IMG_SINGLE;
              end;
            tmpNode.StateIndex := IMG_NO_IMAGES;
            TORTreeNode(tmpNode).StringData := x;
            tvCsltNotes.Selected := tmpNode;
            tvCsltNotes.Items.EndUpdate;
            uChanging := False;

            Changes.Add(CH_CON, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
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
            if txtSubject.Visible then txtSubject.SetFocus else memResults.SetFocus;
          end
        else  //  CreatedNote.ErrorText <> ''
          begin
            // if note creation failed or failed to get note lock (both unlikely), unlock consult
            if FEditNote.PkgIEN > 0 then UnlockConsultRequest(0, FEditNote.PkgIEN);
            //if FEditNote.Consult > 0 then UnlockConsultRequest(0, FEditNote.Consult);
            if CreatedNote.ErrorText <> '' then
              InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
            HaveRequired := False;
          end; {if CreatedNote.IEN}
      end; {if HaveRequired}
    if not HaveRequired then
      begin
        ClearEditControls;
        pnlConsultList.Enabled := True; //CQ#15785
//        lstConsults.Enabled := True;
//        tvConsults.Enabled := True;
      end;
    SetResultMenus ;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(CreatedNote.IEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      memResults.Lines.Text := TmpBoilerPlate.Text;
      SpeakStrings(TmpBoilerPlate);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
end;

procedure TfrmConsults.InsertAddendum;
{ sets up fields of pnlWrite to write an addendum for the selected note }
const
  AS_ADDENDUM = True;
  IS_ID_CHILD = False;
var
  HaveRequired: Boolean;
  CreatedNote: TCreatedDoc;
  x: string;
  tmpNode: TTreeNode;
  AClassName: string;
begin
  AClassName := DCL_CONSULTS;
  ClearEditControls;
  pnlConsultList.Enabled := False; //CQ#15785
//  lstConsults.Enabled := False ;
//  tvConsults.Enabled := False;
  with FEditNote do
  begin
    DocType      := TYP_ADDENDUM;
    Title        := TitleForNote(lstNotes.ItemIEN);
    TitleName    := Piece(lstNotes.Items[lstNotes.ItemIndex], U, 2);
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
    // Cosigner, if needed, will be set by fNoteProps
    // Location info will be set after the encounter is loaded
  end;
  // check to see if interaction necessary to get required fields
  if LacksRequiredForCreate
    then HaveRequired := ExecuteNoteProperties(FEditNote, CT_CONSULTS, IS_ID_CHILD,
                           False, AClassName, MenuAccessRec.ClinProcFlag)
    else HaveRequired := True;
  // lock the consult request if there is a consult
  if HaveRequired and (FEditNote.PkgIEN > 0) then
    HaveRequired := LockConsultRequest(FEditNote.PkgIEN);
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
               U + U + U + U + U + U + U + U;
        end;
      lstNotes.Items.Insert(0, x);

      uChanging := True;
      tvCsltNotes.Items.BeginUpdate;
      tmpNode := tvCsltNotes.Items.AddObjectFirst(tvCsltNotes.Items.GetFirstNode, 'New Addendum in Progress',
                                              MakeConsultsNoteTreeObject('ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0'));
      TORTreeNode(tmpNode).StringData := 'ADDENDUM^New Addendum in Progress^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := tvCsltNotes.Items.AddChildObjectFirst(tmpNode, MakeConsultNoteDisplayText(x), MakeConsultsNoteTreeObject(x));
      TORTreeNode(tmpNode).StringData := x;
      tmpNode.ImageIndex := IMG_ADDENDUM;
      tmpNode.SelectedIndex := IMG_ADDENDUM;
      tvCsltNotes.Selected := tmpNode;
      tvCsltNotes.Items.EndUpdate;
      uChanging := False;

      Changes.Add(CH_CON, IntToStr(CreatedNote.IEN), GetTitleText(0), '', CH_SIGN_YES);
      lstNotes.ItemIndex := 0;
      EditingIndex := 0;
      SetSubjectVisible(AskSubjectForNotes);
      cmdChangeClick(Self); // will set captions, sign state for Changes
      lstNotesClick(Self);  // will make pnlWrite visible
      if timAutoSave.Interval <> 0 then timAutoSave.Enabled := True;
      memResults.SetFocus;
    end else
    begin
      // if note creation failed or failed to get note lock (both unlikely), unlock consult
      if FEditNote.PkgIEN > 0 then UnlockConsultRequest(0, FEditNote.PkgIEN);
      //if FEditNote.Consult > 0 then UnlockConsultRequest(0, FEditNote.Consult);
      InfoBox(CreatedNote.ErrorText, TX_CREATE_ERR, MB_OK);
      HaveRequired := False;
      pnlConsultList.Enabled := True; //CQ#15785
//      lstConsults.Enabled := True;
//      tvConsults.Enabled := True;
    end; {if CreatedNote.IEN}
  end; {if HaveRequired}
  if not HaveRequired then ClearEditControls;
  SetResultMenus ;
end;

procedure TfrmConsults.LoadForEdit;
{ retrieves an existing note and places the data in the fields of pnlWrite }
var
  tmpNode: TTreeNode;
  x: string;
  ErrMsg: string;
  AnAuthor: int64;
  AProcSummCode: integer;
  AProcDate: TFMDateTime;
  tmpBoilerplate: TStringList;
  EnableAutoSave: boolean;
  DocInfo: string;
begin
  ClearEditControls;
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  EnableAutosave := FALSE;
  tmpBoilerplate := nil;
  try
    EditingIndex := lstNotes.ItemIndex;
    Changes.Add(CH_CON, lstNotes.ItemID, GetTitleText(EditingIndex), '', CH_SIGN_YES);
    GetNoteForEdit(FEditNote, lstNotes.ItemIEN);
    memResults.Lines.Assign(FEditNote.Lines);
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
    tvCsltNotes.Items.BeginUpdate;
    tmpNode := tvCsltNotes.FindPieceNode('EDIT', 1, U, nil);
    if tmpNode = nil then
      begin
        tmpNode := tvCsltNotes.Items.AddObjectFirst(tvCsltNotes.Items.GetFirstNode, 'Note being edited',
                                                MakeConsultsNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0'));
        TORTreeNode(tmpNode).StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
      end
    else
      tmpNode.DeleteChildren;
    x := lstNotes.Items[lstNotes.ItemIndex];
    tmpNode.ImageIndex := IMG_TOP_LEVEL;
    tmpNode := tvCsltNotes.Items.AddChildObjectFirst(tmpNode, MakeConsultNoteDisplayText(x), MakeConsultsNoteTreeObject(x));
    TORTreeNode(tmpNode).StringData := x;
    if CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0 then
      tmpNode.ImageIndex := IMG_SINGLE
    else
      tmpNode.ImageIndex := IMG_ADDENDUM;
    tmpNode.SelectedIndex := tmpNode.ImageIndex;
    tvCsltNotes.Selected := tmpNode;
    tvCsltNotes.Items.EndUpdate;
    uChanging := False;

    uPCEEdit.NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
    uPCEEdit.PCEForNote(lstNotes.ItemIEN, uPCEShow);
    FEditNote.NeedCPT := uPCEEdit.CPTRequired;
    txtSubject.Text := FEditNote.Subject;
    SetSubjectVisible(AskSubjectForNotes);
    if MenuAccessRec.IsClinicalProcedure and LacksClinProcFields(FEditNote, MenuAccessRec, ErrMsg) then
      begin
        // **** Collect Author, ClinProcSummCode, and ClinProcDate    ****
         AnAuthor := FEditNote.Author;
         AProcSummCode := FEditNote.ClinProcSummCode;
         AProcDate := FEditNote.ClinProcDateTime;
         EnterClinProcFields(MenuAccessRec.ClinProcFlag, ErrMsg, AProcSummCode, AProcDate, AnAuthor);
        // **** set values into FEditNote ****
         FEditNote.Author           := AnAuthor;
         FEditNote.ClinProcSummCode := AProcSummCode;
         FEditNote.ClinProcDateTime := AProcDate;
      end;
  (*  if LacksClinProcFields(ErrMsg) then
      begin
        // **** Collect Author, Cosigner (if required), ClinProcSummCode, and ClinProcDate    ****
        EnterClinProcFields(MenuAccessRec.ClinProcFlag, ErrMsg, FEditNote);
      end;*)
    if MenuAccessRec.IsClinicalProcedure and (memResults.Lines.Text = '') then
    begin
      if not assigned(TmpBoilerPlate) then
        TmpBoilerPlate := TStringList.Create;
      LoadBoilerPlate(TmpBoilerPlate, FEditNote.Title);
    end;
    if frmFrame.Closing then exit;
    cmdChangeClick(Self); // will set captions, sign state for Changes
    lstNotesClick(Self);  // will make pnlWrite visible
    if timAutoSave.Interval <> 0 then EnableAutosave := TRUE;
    memResults.SetFocus;
  finally
    if assigned(TmpBoilerPlate) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      ExecuteTemplateOrBoilerPlate(TmpBoilerPlate, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
      memResults.Lines.Text := TmpBoilerPlate.Text;
      SpeakStrings(TmpBoilerPlate);
      TmpBoilerPlate.Free;
    end;
    if EnableAutosave then // Don't enable autosave until after dialog fields have been resolved
      timAutoSave.Enabled := True;
  end;
end;

procedure TfrmConsults.SaveEditedConsult(var Saved: Boolean);
{ validates fields and sends the updated consult result to the server }
var
  UpdatedNote: TCreatedDoc;
  x, ErrMsg: string;
  ContinueSave: boolean;

  // this block executes for Clinical Procedures documents ONLY!!
  procedure SaveOrAbort(var AllowSave: boolean);
  begin
    // if no text, leave as undictated, saving nothing
    if (memResults.GetTextLen = 0) or (not ContainsVisibleChar(memResults.Text)) then
      begin
        if lstNotes.ItemIndex = EditingIndex then
          begin
            EditingIndex := -1;
            lstNotesClick(Self);
          end;
        EditingIndex := -1;
        Saved := True;    // (yes, though not actually saving, this is correct and necessary (RV))
        AllowSave := False;
      end
    // if text, stuff user as author, and allow save as unsigned
    else
      begin
        if FEditNote.Author <= 0 then FEditNote.Author := User.DUZ;
        AllowSave := True;
      end;
  end;

begin
  Saved := False;
  ContinueSave := True;
  if MenuAccessRec.IsClinicalProcedure and LacksClinProcFields(FEditNote, MenuAccessRec, ErrMsg) then
    // this block will execute for Clinical Procedures documents ONLY!!
    begin
      if not FSilent then                       //  if not timing out, then prompt for required fields
        begin
          InfoBox(ErrMsg, TC_CLIN_PROC, MB_OK);
          cmdChangeClick(mnuActConsultResults);
          if frmFrame.TimedOut then exit;
          if MenuAccessRec.IsClinicalProcedure and LacksClinProcFields(FEditNote, MenuAccessRec, ErrMsg) then   //  if still not entered, action depends on presence of text
            SaveOrAbort(ContinueSave);
        end
      else SaveOrAbort(ContinueSave);           //  if timing out, action depends on presence of text
      if not ContinueSave then exit;
    end
  else if (memResults.GetTextLen = 0) or (not ContainsVisibleChar(memResults.Text)) then
  // this block will NOT execute for Clinical Procedures documents!!
  begin
    lstNotes.ItemIndex := EditingIndex;
    x := lstNotes.ItemID;
    uChanging := True;
    tvCsltNotes.Selected := tvCsltNotes.FindPieceNode(x, 1, U, tvCsltNotes.Items.GetFirstNode);
    uChanging := False;
    tvCsltNotesChange(Self, tvCsltNotes.Selected);
    if FSilent or
       ((not FSilent) and
      (InfoBox(GetTitleText(EditingIndex) + TX_EMPTY_NOTE, TC_EMPTY_NOTE, MB_YESNO) = IDYES))
    then
    begin
      FConfirmed := True;
      mnuActNoteDeleteClick(Self);
      Saved := True;
      FDeleted := True;
    end
    else
      FConfirmed := False;
    Exit;
  end;
  //ExpandTabsFilter(memResults.Lines, TAB_STOP_CHARS);
  FEditNote.Lines    := memResults.Lines;
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
    EditingIndex := -1;
    Saved := True;
    FChanged := False;
  end else
  begin
    if not FSilent then
      InfoBox(TX_SAVE_ERROR1 + UpdatedNote.ErrorText + TX_SAVE_ERROR2, TC_SAVE_ERROR, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmConsults.SaveCurrentNote(var Saved: Boolean);
begin
  if EditingIndex < 0 then Exit;
  SaveEditedConsult(Saved);
end;


{ Form events -----------------------------------------------------------------}

procedure TfrmConsults.pnlRightExit(Sender: TObject);
begin
  inherited;
  if TabIsPressed then
    FindNextControl(tvConsults, True, True, False).SetFocus
  else if ShiftTabIsPressed then
    FindNextControl(pnlLeft, True, True, False).SetFocus;
end;

procedure TfrmConsults.pnlRightResize(Sender: TObject);
{ TRichEdit doesn't repaint appropriately unless its parent panel is refreshed }
begin
  inherited;
  pnlRight.Refresh;
  pnlAction.Invalidate;
  memConsult.Repaint;
  pnlResults.Invalidate;
  memResults.Repaint;
end;

{ Left panel (selector) events ------------------------------------------------------------- }

procedure TfrmConsults.lstConsultsClick(Sender: TObject);
{ loads the text for the selected Consult}
const
  RSLT_TIU_DOC = 1;
  RSLT_MED_RPT = 2;
var
  ANode: TTreeNode;
begin
  inherited;
  lstNotes.Items.Clear ;
  memConsult.Clear ;
  ClearEditControls ;
  if lstConsults.ItemIEN <= 0 then
   begin
      memConsult.Lines.Add('No consults were found which met the criteria specified: '
                               + #13#10#13#10 + lblConsults.Caption) ;
      memConsult.SelStart := 0;
      mnuAct.Enabled := False ;
      exit ;
   end
  else mnuAct.Enabled := True;
  pnlResults.Visible := False;
  pnlResults.SendToBack;
  Screen.Cursor := crHourglass ;
  StatusText('Retrieving selected consult...');
  cmdPCE.Enabled := False;
  popNoteMemoEncounter.Enabled := False;
  GetConsultRec(lstConsults.ItemIEN) ;
  FOrderID := '';
  //FOrderID := Piece(lstConsults.Items[lstConsults.ItemIndex], U, 6);
  if ConsultRec.EntryDate = -1 then
    begin
       memConsult.Lines.Add(TX_INVALID_CONSULT_TEXT) ;
       lblTitle.Caption :=  TX_INVALID_CONSULT_CAP ;
       lblTitle.Hint := lblTitle.Caption;
    end
  else
    begin
       lblTitle.Caption := lstConsults.DisplayText[lstConsults.ItemIndex] ;
       lblTitle.Hint := lblTitle.Caption;
       LoadConsultDetail(memConsult.Lines, lstConsults.ItemIEN) ;
       FDocList.Clear;
       lstNotes.Items.Clear;
       uChanging := True;
       tvCsltNotes.Items.BeginUpdate;
       KillDocTreeObjects(tvCsltNotes);
       tvCsltNotes.Items.Clear;
       if (ConsultRec.TIUDocuments.Count + ConsultRec.MedResults.Count) > 0 then
       begin
         with FCurrentNoteContext do
            begin
                if ConsultRec.TIUDocuments.Count > 0 then
                  begin
                    CreateListItemsForDocumentTree(FDocList, ConsultRec.TIUDocuments, RSLT_TIU_DOC, GroupBy, TreeAscending, CT_CONSULTS);
                    UpdateNoteTreeView(FDocList, tvCsltNotes, RSLT_TIU_DOC);
                  end;
                FDocList.Clear;
                if ConsultRec.MedResults.Count > 0 then
                  begin
                    CreateListItemsForDocumentTree(FDocList, ConsultRec.MedResults, RSLT_MED_RPT, GroupBy, TreeAscending, CT_CONSULTS);
                    UpdateNoteTreeView(FDocList, tvCsltNotes, RSLT_MED_RPT);
                  end;
            end;
         with tvCsltNotes do
           begin
             FullExpand;
             if Notifications.Active and FNotifPending then
               Selected := FindPieceNode(Piece(Notifications.AlertData, U, 1), 1, U, nil)
             else if FLastNoteID <> '' then
               Selected := FindPieceNode(FLastNoteID, 1, U, nil);
             if Selected <> nil then
               if Piece(PDocTreeObject(Selected)^.DocID, ';', 1) <> 'MCAR' then DisplayPCE ;
           end;
        end
       else
        begin
          ANode := tvCsltNotes.Items.AddFirst(tvCsltNotes.Items.GetFirstNode, 'No related documents found');
          TORTreeNode(ANode).StringData := '-1^No related documents found';
          lstNotes.Items.Add('-1^None') ;
          ShowPCEControls(False) ;
        end ;
       tvCsltNotes.Items.EndUpdate;
       uChanging := False;
       FLastNoteID := '';
       //FLastNoteID := lstNotes.ItemID;
   end ;
  SetActionMenus ;
  SetResultMenus ;
  StatusText('');
  pnlRight.Repaint ;
  memConsult.SelStart := 0;
  memConsult.Repaint;
  Screen.Cursor := crDefault ;
end;

procedure TfrmConsults.mnuActNewConsultRequestClick(Sender: TObject);
var
  DialogInfo: string;
  DelayEvent: TOrderDelayEvent;
begin
  inherited;
  DelayEvent.EventType := 'C';         // temporary, so can pass to CopyOrders
  DelayEvent.Specialty := 0;
  DelayEvent.Effective := 0;
  DelayEvent.EventIFN  := 0;
  DelayEvent.PtEventIFN := 0;
  if not ReadyForNewOrder(DelayEvent) then Exit;
  { get appropriate form, create the dialog form and show it }
  DialogInfo := GetNewDialog(DLG_CONSULT);   // DialogInfo = DlgIEN;FormID;DGroup
  case CharAt(Piece(DialogInfo, ';', 4), 1) of
  'A':      ActivateAction(     Piece(DialogInfo, ';', 1),             Self, 0);
  'D', 'Q': ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  'M':      ActivateOrderMenu(  Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  'O':      ActivateOrderSet(   Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  else InfoBox('Unsupported dialog type', 'Error', MB_OK);
  end; {case}
end;

procedure TfrmConsults.mnuActNewProcedureClick(Sender: TObject);
var
  DialogInfo: string;
  DelayEvent: TOrderDelayEvent;
begin
  inherited;
  DelayEvent.EventType := 'C';         // temporary, so can pass to CopyOrders
  DelayEvent.Specialty := 0;
  DelayEvent.Effective := 0;
  DelayEvent.EventIFN  := 0;
  DelayEvent.PtEventIFN := 0;
  
  if not ReadyForNewOrder(DelayEvent) then Exit;
  { get appropriate form, create the dialog form and show it }
  DialogInfo := GetNewDialog(DLG_PROC);   // DialogInfo = DlgIEN;FormID;DGroup
  case CharAt(Piece(DialogInfo, ';', 4), 1) of
  'D', 'Q': ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  'M':      ActivateOrderMenu(  Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  'O':      ActivateOrderSet(   Piece(DialogInfo, ';', 1), DelayEvent, Self, 0);
  else InfoBox('Unsupported dialog type', 'Error', MB_OK);
  end; {case}
end;

procedure TfrmConsults.cmdNewConsultClick(Sender: TObject);
{ maps 'New Consult' button to the New Consult menu item }
begin
  inherited;
  mnuActNewConsultRequestClick(Self);
end;

procedure TfrmConsults.cmdNewConsultExit(Sender: TObject);
begin
  inherited;
  if Not cmdEditResubmit.Visible then
    DoLeftPanelCustomShiftTab;
end;

procedure TfrmConsults.cmdNewProcClick(Sender: TObject);
begin
  inherited;
  mnuActNewProcedureClick(Self);
end;

{ Right panel (editor) events -------------------------------------------------------------- }

procedure TfrmConsults.NewPersonNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
begin
  inherited;
  (Sender as TORComboBox).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmConsults.memResultChange(Sender: TObject);
{ sets FChanged to record that the note has really been edited }
begin
  inherited;
  FChanged := True;
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmConsults.mnuViewClick(Sender: TObject);
{ changes the list of Consults available for viewing }
var
  NewView: boolean;
  Saved: Boolean;
  //tmpNode: TTreeNode;
begin
  inherited;
  // save note at FEditingIndex?
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  NewView := False ;
  if Sender is TMenuItem then
    begin
      ViewContext := TMenuItem(Sender).Tag ;
      case ViewContext of
        CC_BY_STATUS  :  NewView := SelectStatus(Font.Size, FCurrentContext, StsCtxt);
        CC_BY_SERVICE :  NewView := SelectService(Font.Size, FCurrentContext, SvcCtxt);
        CC_BY_DATE    :  NewView := SelectConsultDateRange(Font.Size, FCurrentContext, DateRange);
        CC_CUSTOM     :  begin
                           NewView := SelectConsultsView(Font.Size, FCurrentContext, uSelectContext) ;
                           if NewView then lblConsults.Caption := 'Custom List';
                         end;  
        CC_ALL        :  NewView := True ;
      end;
    end
  else with FCurrentContext do
    begin
      if ((BeginDate + EndDate + Status + Service + GroupBy) <> '') then
        begin
          ViewContext := CC_CUSTOM;
          NewView := True;
          lblConsults.Caption := 'Default List';
        end
      else
        begin
          ViewContext := CC_ALL;
          NewView := True;
          lblConsults.Caption := 'All Consults';
        end;
    end;
  tvConsults.Caption := lblConsults.Caption;
  if NewView then
    begin
      StatusText('Retrieving Consult list...');
      lblTitle.Caption := '';
      lblTitle.Hint := lblTitle.Caption;
      UpdateList ;
      StatusText('');
    end;
  tvConsultsClick(Self);
end;

{ Action menu events ----------------------------------------------------------------------- }

procedure TfrmConsults.mnuActCompleteClick(Sender: TObject);
const
  IS_ID_CHILD = False;
var
  NoteIEN: integer;
  ActionSts: TActionRec;
  UseClinProcTitles: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0  then exit;
  if MenuAccessRec.IsClinicalProcedure then
    begin
      case MenuAccessRec.ClinProcFlag of
        {1} CP_NO_INSTRUMENT    : FActionType := CN_ACT_CP_COMPLETE;
        {2} CP_INSTR_NO_STUB    : begin
                                InfoBox(TX_CP_NO_RESULTS, TC_CP_NO_RESULTS, MB_OK or MB_ICONERROR);
                                Exit;
                              end;
        {3} CP_INSTR_INCOMPLETE : FActionType := CN_ACT_CP_COMPLETE;
        {4} CP_INSTR_COMPLETE   : FActionType := CN_ACT_CP_COMPLETE;
      end;
    end
  else  // {0} not a clinical procedure
    FActionType := TMenuItem(Sender).Tag ;
  if not StartNewEdit(NT_ACT_NEW_NOTE) then Exit;

  SelectNoteForProcessing(Font.Size, FActionType, lstNotes.Items, NoteIEN, MenuAccessRec.ClinProcFlag);
  if NoteIEN > 0 then
    begin
      with tvCsltNotes do Selected := FindPieceNode(IntToStr(NoteIEN), 1, U, Items.GetFirstNode);
      if tvCsltNotes.Selected = nil then exit;
      ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
      if not ActionSts.Success then
        begin
          InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
          Exit;
        end ;
      mnuActNoteEditClick(Self);
    end
  else if NoteIEN = StrToInt(CN_NEW_CP_NOTE) then
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
        Exit;
      end;
      SetResultMenus ;
      UseClinProcTitles := True;
      CompleteConsult(IS_ID_CHILD, 0, UseClinProcTitles);
    end
  else if NoteIEN = StrToInt(CN_NEW_CSLT_NOTE) then
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
        Exit;
      end;
      SetResultMenus ;
      UseClinProcTitles := False;
      CompleteConsult(IS_ID_CHILD, 0, UseClinProcTitles);
    end
  else if NoteIEN = -1 then Exit
end;

//wat cq 17586
procedure TfrmConsults.popNoteMemoViewCsltClick(Sender: TObject);
var
  CsltIEN: integer ;
  ConsultDetail: TStringList;
  x: string;
begin
  inherited;
  if (Screen.ActiveControl <> memResults) or (FEditNote.PkgPtr <> PKG_CONSULTS) then Exit;
  CsltIEN := frmConsults.FEditNote.PkgIEN;
  x := FindConsult(CsltIEN);
  ConsultDetail := TStringList.Create;
  try
    LoadConsultDetail(ConsultDetail, CsltIEN) ;
    ReportBox(ConsultDetail, 'Consult Details: #' + IntToStr(CsltIEN) + ' - ' + Piece(x, U, 4), TRUE);
  finally
    ConsultDetail.Free;
  end;
end;  //END cq 17586

procedure TfrmConsults.mnuActAddIDEntryClick(Sender: TObject);
const
  IS_ID_CHILD = True;
  IS_CLIN_PROC = False;
var
  AnIDParent: integer;
  //AConsultID: string;
{ switches to current new note or creates a new note if none is being edited already }
begin
  inherited;
(*  AConsultID := lstConsults.ItemID;*)
  AnIDParent := lstNotes.ItemIEN;
  if not StartNewEdit(NT_ACT_ID_ENTRY) then Exit;
(*  with tvConsults do Selected := FindPieceNode(AConsultID, 1, U, Items.GetFirstNode);
  with tvCsltNotes do Selected := FindPieceNode(IntToStr(AnIDParent), 1, U, Items.GetFirstNode);*)

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
  CompleteConsult(IS_ID_CHILD, AnIDParent, IS_CLIN_PROC);
end;

procedure TfrmConsults.mnuActMakeAddendumClick(Sender: TObject);
var
  ActionSts: TActionRec;
  //ANoteID, AConsultID: string;
begin
  inherited;
  if lstConsults.ItemIEN = 0  then exit;
(*  // ====== REMOVED IN V14 - superfluous with treeview in v15 ===========
  FActionType := TMenuItem(Sender).Tag ;
  SelectNoteForProcessing(Font.Size, FActionType, lstNotes.Items, NoteIEN);
  if NoteIEN = -1 then exit;
  //lstNotes.SelectByIEN(NoteIEN);
  with tvCsltNotes do Selected := FindPieceNode(IntToStr(NoteIEN), 1, U, Items.GetFirstNode);
  if tvCsltNotes.Selected = nil then exit;
  // ========================================*)
  if lstNotes.ItemIEN <= 0 then Exit;
(*  AConsultID := lstConsults.ItemID;
  ANoteID := lstNotes.ItemID;*)
  if lstNotes.ItemIndex = EditingIndex then
  begin
    InfoBox(TX_ADDEND_NO, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  if not StartNewEdit(NT_ACT_ADDENDUM) then Exit;
(*  with tvConsults do Selected := FindPieceNode(AConsultID, 1, U, Items.GetFirstNode);
  with tvCsltNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);*)
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'MAKE ADDENDUM');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  with lstNotes do if TitleForNote(ItemIEN) = TYP_ADDENDUM then      //v17.5 RV
  //with lstNotes do if Copy(Piece(Items[ItemIndex], U, 2), 1, 8) = 'Addendum' then
  begin
    InfoBox(TX_ADDEND_AD, TX_ADDEND_MK, MB_OK);
    Exit;
  end;
  SetResultMenus ;
  InsertAddendum;
end;

procedure TfrmConsults.mnuActDetachFromIDParentClick(Sender: TObject);
var
  DocID, WhyNot: string;
  Saved: boolean;
  SavedDocID, SavedConsultID: string;
begin
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    with tvConsults do Selected := FindPieceNode(SavedConsultID, 1, U, Items.GetFirstNode);
    tvConsultsClick(Self);
    with tvCsltNotes do Selected := FindPieceNode(SavedDocID, 1, U, Items.GetFirstNode);
  end;
  if not CanBeAttached(PDocTreeObject(tvCsltNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
      Exit;
    end;
  if (InfoBox('DETACH:   ' + tvCsltNotes.Selected.Text + CRLF +  CRLF +
              '  FROM:   ' + tvCsltNotes.Selected.Parent.Text + CRLF + CRLF +
              'Are you sure?', TX_DETACH_CNF, MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) <> IDYES)
      then Exit;
  DocID := PDocTreeObject(tvCsltNotes.Selected.Data)^.DocID;
  SavedDocID := PDocTreeObject(tvCsltNotes.Selected.Parent.Data)^.DocID;
  if DetachEntryFromParent(DocID, WhyNot) then
    begin
      tvConsultsChange(Self, tvConsults.Selected);
      with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      if tvCsltNotes.Selected <> nil then tvCsltNotes.Selected.Expand(False);
    end
  else
    begin
      WhyNot := StringReplace(WhyNot, 'ATTACH', 'DETACH', [rfIgnoreCase]);
      WhyNot := StringReplace(WhyNot, 'to an ID', 'from an ID', [rfIgnoreCase]);
      InfoBox(WhyNot, TX_DETACH_FAILURE, MB_OK);
    end;
end;

procedure TfrmConsults.mnuActSignatureListClick(Sender: TObject);
{ add the note to the Encounter object, see mnuActSignatureSignClick - copied}
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  ActionType, SignTitle: string;
  ActionSts: TActionRec;
  ErrMsg: string;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then Exit;
  if lstNotes.ItemIndex = EditingIndex then Exit;  // already in signature list
  if LacksClinProcFieldsForSignature(lstNotes.ItemIEN, ErrMsg) then
     begin
       InfoBox(ErrMsg, TC_CLIN_PROC, MB_OK);
       Exit;
     end;
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
  with lstNotes do Changes.Add(CH_CON, ItemID, GetTitleText(ItemIndex), '', CH_SIGN_YES);
end;


procedure TfrmConsults.mnuActNoteDeleteClick(Sender: TObject);
{ delete the selected progress note & remove from the Encounter object if necessary }
var
  DeleteSts, ActionSts: TActionRec;
  SaveConsult, SavedDocIEN: Integer;
  ReasonForDelete, AVisitStr, SavedDocID, x: string;
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
  if not LockConsultRequestAndNote(lstNotes.ItemIEN) then Exit;
  if JustifyDocumentDelete(lstNotes.ItemIEN) then
     InfoBox(TX_RETRACT, TX_RETRACT_CAP, MB_OK);
  SavedDocID := lstNotes.ItemID;
  SavedDocIEN := lstNotes.ItemIEN;
  if (EditingIndex > -1) and (not FConfirmed) and (lstNotes.ItemIndex <> EditingIndex) and (memResults.GetTextLen > 0) then
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
      with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
   end;*)
  // remove the note
  DeleteSts.Success := True;
  x := GetPackageRefForNote(SavedDocIEN);
  SaveConsult := StrToIntDef(Piece(x, ';', 1), 0);
  //SaveConsult := GetConsultIENforNote(SavedDocIEN);
  AVisitStr := VisitStrForNote(SavedDocIEN);
  RemovePCEFromChanges(SavedDocIEN, AVisitStr);
  if (SavedDocIEN > 0) and (lstNotes.ItemIEN = SavedDocIEN)then DeleteDocument(DeleteSts, SavedDocIEN, ReasonForDelete);
  if not Changes.Exist(CH_CON, SavedDocID) then UnlockDocument(SavedDocIEN);
  Changes.Remove(CH_CON, SavedDocID);  // this will unlock the document if in Changes
  UnlockConsultRequest(0, SaveConsult);     // note has been deleted, so 1st param = 0
  // reset the display now that the note is gone
  if DeleteSts.Success then
  begin
    DeletePCE(AVisitStr);  // removes PCE data if this was the only note pointing to it
    ClearEditControls;
    //ClearPtData;   WRONG - fixed in v15.10 - RV
    cmdNewConsult.Visible := True;
    cmdNewProc.Top := cmdNewConsult.Top + cmdNewConsult.Height;
    cmdNewProc.Visible := True;
    pnlConsultList.Height := (pnlLeft.Height div 2);
(*    uChanging := True;
    with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
    uChanging := False;
    if tvCsltNotes.Selected <> nil then tvCsltNotesChange(Self, tvCsltNotes.Selected) else
    begin*)
      pnlResults.Visible := False;
      pnlResults.SendToBack;
      pnlRead.Visible := True;
      pnlRead.BringToFront ;
      memConsult.TabStop := True;
      UpdateReminderFinish;
      ShowPCEControls(False);
      frmDrawers.DisplayDrawers(FALSE);
      cmdPCE.Visible := FALSE;
      popNoteMemoEncounter.Visible := FALSE;
      UpdateList;
      pnlConsultList.Enabled := True; //CQ#15785
//      lstConsults.Enabled := True ;
//      tvConsults.Enabled := True;
      with tvConsults do Selected := FindPieceNode(IntToStr(SaveConsult), 1, U, Items.GetFirstNode);
      tvConsultsClick(Self);
(*      lstConsults.SelectByIEN(ConsultRec.IEN);
      if lstConsults.ItemIEN > 0 then
        lstConsultsClick(Self) ;*)
      lstNotes.Enabled := True;
(*      uChanging := True;
      with tvNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
      uChanging := False;
      if tvCsltNotes.Selected <> nil then tvCsltNotesChange(Self, tvCsltNotes.Selected);
    end; {if ItemIndex}*)
  end {if DeleteSts}
  else InfoBox(DeleteSts.Reason, TX_DEL_ERR, MB_OK or MB_ICONWARNING);
end;

procedure TfrmConsults.mnuActNoteEditClick(Sender: TObject);
{ load the selected progress note for editing }
var
  ActionSts: TActionRec;
  //AConsultID, ANoteID: string;
begin
  inherited;
  if lstNotes.ItemIndex = EditingIndex then Exit;
(*  AConsultID := lstConsults.ItemID;
  ANoteID := lstNotes.ItemID;*)
  if not StartNewEdit(NT_ACT_EDIT_NOTE) then Exit;
(*  with tvConsults do Selected := FindPieceNode(AConsultID, 1, U, Items.GetFirstNode);
  with tvCsltNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);*)
  ActOnDocument(ActionSts, lstNotes.ItemIEN, 'EDIT RECORD');
  if not ActionSts.Success then
  begin
    InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
    Exit;
  end;
  LoadForEdit;
end;

procedure TfrmConsults.mnuActSignatureSaveClick(Sender: TObject);
{ saves the Consult that is currently being edited }
var
  Saved: Boolean;
//  i: integer;
  SavedDocID, SavedCsltID, x: string;
  tmpNode: TORTreeNode;
begin
  inherited;
  if EditingIndex > -1 then
    begin
      SavedDocID := Piece(lstNotes.Items[EditingIndex], U, 1);
      FLastNoteID := SavedDocID;
      SavedCsltID := lstConsults.ItemID;
      SaveCurrentNote(Saved) ;
      if Saved and (EditingIndex < 0) and (not FDeleted) then
      //if Saved then
        begin
          pnlResults.Visible := False;
          pnlResults.SendToBack;
          pnlConsultList.Enabled := True; //CQ#15785
//          lstConsults.Enabled := True;
//          tvConsults.Enabled := True;
          if Notifications.Active then
            with tvConsults do
              begin
                uChanging := True;
                Selected := FindPieceNode(SavedCsltID, 1, U, Items.GetFirstNode);
                if Selected <> nil then Selected.Delete;
                x := FindConsult(StrToIntDef(SavedCsltID, 0));
                tmpNode := TORTreeNode(Items.AddChildFirst(Items.GetFirstNode, MakeConsultListDisplayText(x)));
                tmpNode.StringData := x;
                SetNodeImage(tmpNode, FCurrentContext);
                uChanging := False;
                Selected := tmpNode;
                tvConsultsClick(Self);
              end
          else
            begin
              UpdateList ;  {update consult list after success}
              with tvConsults do Selected := FindPieceNode(SavedCsltID, U, Items.GetFirstNode);
              tvConsultsClick(Self);
              with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
            end;
          pnlLeft.Refresh ;
        end;
    end
  else InfoBox(TX_NO_CONSULT, TX_SAVE_CONSULT, MB_OK or MB_ICONWARNING);
  if frmFrame.TimedOut then Exit;
  with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
end;

procedure TfrmConsults.mnuActSignatureSignClick(Sender: TObject);
{ sign the currently selected note, save first if necessary }
const
  SIG_COSIGN = 'COSIGNATURE';
  SIG_SIGN   = 'SIGNATURE';
var
  Saved, NoteUnlocked: Boolean;
  ActionType, ESCode, SignTitle, x: string;
  ActionSts, SignSts: TActionRec;
  OK: boolean;
  tmpNode: TORTreeNode;
  SavedDocID, SavedCsltID, tmpItem, ErrMsg: string;
  EditingID: string;                                         //v22.12 - RV
begin
  inherited;
(*  if lstNotes.ItemIndex = EditingIndex then
  begin
    SaveCurrentNote(Saved);
    if (not Saved) or FDeleted then Exit;
  end
  else if EditingIndex > -1 then
    tmpItem := lstNotes.Items[EditingIndex];
  SavedDocID := lstNotes.ItemID;*)
  SavedCsltID := lstConsults.ItemID;
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
  if LacksClinProcFieldsForSignature(lstNotes.ItemIEN, ErrMsg) then
     begin
       InfoBox(ErrMsg, TC_CLIN_PROC, MB_OK);
       Exit;
     end;
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
      with lstNotes do SignatureForItem(Font.Size, MakeConsultNoteDisplayText(Items[ItemIndex]), SignTitle, ESCode);
      if Length(ESCode) > 0 then
      begin
        SignDocument(SignSts, lstNotes.ItemIEN, ESCode);
        RemovePCEFromChanges(lstNotes.ItemIEN);
        NoteUnlocked := Changes.Exist(CH_CON, lstNotes.ItemID);
        Changes.Remove(CH_CON, lstNotes.ItemID);  // this will unlock if in Changes
        if SignSts.Success then
        begin
          pnlResults.Visible := False;
          pnlResults.SendToBack;
          pnlConsultList.Enabled := True; //CQ#15785
//          lstConsults.Enabled := True;
//          tvConsults.Enabled := True;
          if Notifications.Active then
            with tvConsults do
              begin
                uChanging := True;
                Selected := FindPieceNode(SavedCsltID, 1, U, Items.GetFirstNode);
                if Selected <> nil then Selected.Delete;
                x := FindConsult(StrToIntDef(SavedCsltID, 0));
                tmpNode := TORTreeNode(Items.AddChildFirst(Items.GetFirstNode, MakeConsultListDisplayText(x)));
                tmpNode.StringData := x;
                SetNodeImage(tmpNode, FCurrentContext);
                uChanging := False;
                Selected := tmpNode;
                //tvConsultsClick(Self);
              end
          else
            begin
              UpdateList ;  {update consult list after success}
              with tvConsults do Selected := FindPieceNode(SavedCsltID, U, Items.GetFirstNode);
              //tvConsultsClick(Self);
              //with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
            end;
        end
        else InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end {if Length(ESCode)}
      else
        NoteUnlocked := Changes.Exist(CH_CON, lstNotes.ItemID);
    end;
  end
  else InfoBox(ActionSts.Reason, TX_IN_AUTH, MB_OK);
  if not NoteUnlocked then UnlockDocument(lstNotes.ItemIEN);
  UnlockConsultRequest(lstNotes.ItemIEN, StrToIntDef(SavedCsltID, 0));  // v20.4  RV (unlocking problem)
  //UnlockConsultRequest(lstNotes.ItemIEN, ConsultRec.IEN);
  tvConsultsClick(Self);
  //if EditingIndex > -1 then         //v22.12 - RV
  if (EditingID <> '') then           //v22.12 - RV
    begin
      lstNotes.Items.Insert(0, tmpItem);
      tmpNode := TORTreeNode(tvCsltNotes.Items.AddObjectFirst(tvCsltNotes.Items.GetFirstNode, 'Note being edited',
                 MakeNoteTreeObject('EDIT^Note being edited^^^^^^^^^^^%^0')));
      tmpNode.StringData := 'EDIT^Note being edited^^^^^^^^^^^%^0';
      tmpNode.ImageIndex := IMG_TOP_LEVEL;
      tmpNode := TORTreeNode(tvCsltNotes.Items.AddChildObjectFirst(tmpNode, MakeConsultNoteDisplayText(tmpItem),
                 MakeConsultsNoteTreeObject(tmpItem)));
      tmpNode.StringData := tmpItem;
      SetTreeNodeImagesAndFormatting(TORTreeNode(tmpNode), FCurrentNoteContext, CT_CONSULTS);
      EditingIndex := lstNotes.SelectByID(EditingID);                 //v22.12 - RV
    end;
  //with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);  //v22.12 - RV
  with tvCsltNotes do                                                                  //v22.12 - RV
  begin                                                                                //v22.12 - RV
    Selected := FindPieceNode(FLastNoteID, U, Items.GetFirstNode);                     //v22.12 - RV
    if Selected <> nil then tvCsltNotesChange(Self, Selected);                         //v22.12 - RV
  end;
end;

procedure TfrmConsults.SaveSignItem(const ItemID, ESCode: string);
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
  SavedCsltID, x: string;
  tmpNode: TORTreeNode;
  ErrMsg: string;
  ActionType, SignTitle: string;
begin
  AnIndex := -1;
  IEN := StrToIntDef(ItemID, 0);
  if IEN = 0 then Exit;
  x := GetPackageRefForNote(IEN);
  SavedCsltID := Piece(x, ';', 1);
  //SavedCsltID := IntToStr(GetConsultIENForNote(IEN));
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
    else if LacksClinProcFieldsForSignature(IEN, ErrMsg) then
      begin
       InfoBox(ErrMsg, TC_CLIN_PROC, MB_OK);
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
        SignDocument(SignSts, IEN, ESCode);
        if not SignSts.Success then InfoBox(SignSts.Reason, TX_SIGN_ERR, MB_OK);
      end; {if OK}
    end; {if ContinueSign}
  end; {if Length(ESCode)}

  UnlockConsultRequest(IEN);
  UnlockDocument(IEN);
  if (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then lstNotesClick(Self);
  if Notifications.Active then
    with tvConsults do
      begin
        if (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then lstNotesClick(Self);
        uChanging := True;
        Selected := FindPieceNode(SavedCsltID, 1, U, Items.GetFirstNode);
        if Selected <> nil then Selected.Delete;
        x := FindConsult(StrToIntDef(SavedCsltID, 0));
        tmpNode := TORTreeNode(Items.AddChildFirst(Items.GetFirstNode, MakeConsultListDisplayText(x)));
        tmpNode.StringData := x;
        SetNodeImage(tmpNode, FCurrentContext);
        uChanging := False;
        Selected := tmpNode;
        tvConsultsClick(Self);
      end
  else
    begin
      UpdateList ;  {update consult list after success}
      if (AnIndex = lstNotes.ItemIndex) and (not frmFrame.ContextChanging) then lstNotesClick(Self);
      with tvConsults do Selected := FindPieceNode(SavedCsltID, U, Items.GetFirstNode);
      tvConsultsClick(Self);
      with tvCsltNotes do Selected := FindPieceNode(IntToStr(IEN), U, Items.GetFirstNode);
    end;
  pnlLeft.Refresh ;
end ;

procedure TfrmConsults.cmdPCEClick(Sender: TObject);
begin
  inherited;
  cmdPCE.Enabled := False;
  UpdatePCE(uPCEEdit);
  cmdPCE.Enabled := True;
  if frmFrame.Closing then exit;
  DisplayPCE;
end;

procedure TfrmConsults.mnuActConsultClick(Sender: TObject);
var
//  i:integer ;
  Saved, IsProcedure: boolean;
  SavedCsltID, x: string;
  tmpNode: TORTreeNode;
begin
  inherited;
  if lstConsults.ItemIEN = 0  then exit;
  SavedCsltID := lstConsults.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FOrderID := Piece(lstConsults.Items[lstConsults.ItemIndex], U, 6);
  if not LockConsultRequest(lstConsults.ItemIEN) then Exit;
  FActionType := TMenuItem(Sender).Tag ;
  ClearEditControls ;
  lstNotes.Enabled := False ;
  pnlConsultList.Enabled := False; //CQ#15785
//  lstConsults.Enabled  := False ;
//  tvConsults.Enabled := False;
  x := Piece(lstConsults.Items[lstConsults.ItemIndex], U, 12);
  if x <> '' then
    IsProcedure := CharInSet(x[1], ['P', 'M'])
  else
    IsProcedure := (Piece(lstConsults.Items[lstConsults.ItemIndex], U, 9) = 'Procedure');
  //if SetActionContext(Font.Size,FActionType, IsProcedure, ConsultRec.ConsultProcedure) then
   if SetActionContext(Font.Size,FActionType, IsProcedure, ConsultRec.ConsultProcedure, MenuAccessRec.UserLevel) then
    begin
      if Notifications.Active then
        with tvConsults do
          begin
            uChanging := True;
            Selected := FindPieceNode(SavedCsltID, 1, U, Items.GetFirstNode);
            if Selected <> nil then Selected.Delete;
            x := FindConsult(StrToIntDef(SavedCsltID, 0));
            tmpNode := TORTreeNode(Items.AddChildFirst(Items.GetFirstNode, MakeConsultListDisplayText(x)));
            tmpNode.StringData := x;
            SetNodeImage(tmpNode, FCurrentContext);
            uChanging := False;
            Selected := tmpNode;
            tvConsultsClick(Self);
          end
(*        with tvConsults do
          begin
            Selected := FindPieceNode(IntToStr(ConsultRec.IEN), 1, U, Items.GetFirstNode);
            if Selected <> nil then Selected.Delete;
            Items.AddFirst(nil, FindConsult(ConsultRec.IEN));
            Selected := FindPieceNode(IntToStr(ConsultRec.IEN), 1, U, Items.GetFirstNode);
          end*)
      else
        begin
          UpdateList ;  {update consult list after success}
          with tvConsults do Selected := FindPieceNode(SavedCsltID, U, Items.GetFirstNode);
          tvConsultsClick(Self);
        end;
    end;
  UnlockConsultRequest(lstNotes.ItemIEN, StrToIntDef(SavedCsltID, 0));  // v20.4  RV (unlocking problem)
  //UnlockConsultRequest(lstNotes.ItemIEN, lstConsults.ItemIEN);
  lstNotes.Enabled := True ;
  pnlConsultList.Enabled := True; //CQ#15785
//  lstConsults.Enabled := True ;
//  tvConsults.Enabled := True;
end;

procedure TfrmConsults.UpdateList;
begin
     { call this after performing some action on a consult that changes its status
       or its service  }
  case ViewContext of
    CC_ALL       : begin
                     FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                     lblConsults.Caption := 'All Consults' ;
                     FCurrentContext.Ascending := False;
                   end;
    CC_BY_STATUS : begin
                     with StsCtxt do if Changed then
                       begin
                         FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                         lblConsults.Caption := 'All ' + StatusName + ' Consults';
                         FCurrentContext.Status := Status;
                         FCurrentContext.Ascending := Ascending;
                       end;
                   end;
    CC_BY_SERVICE : begin
                      with SvcCtxt do if Changed then
                        begin
                          FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                          lblConsults.Caption := 'Consults to ' + ServiceName;
                          FCurrentContext.Service := Service;
                          FCurrentContext.Ascending := Ascending;
                        end;
                    end;
     CC_BY_DATE   : begin
                     with DateRange do if Changed then
                       begin
                        FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                        lblConsults.Caption := FormatFMDateTime('dddddd', StrToFMDateTime(BeginDate)) + ' to ' +
                                               FormatFMDateTime('dddddd', StrToFMDateTime(EndDate));
                        FCurrentContext.BeginDate := BeginDate;
                        FCurrentContext.EndDate   := EndDate;
                        FCurrentContext.Ascending := Ascending;
                       end;
                    end;
     CC_CUSTOM    : begin
                      with uSelectContext do if Changed then
                        begin
                          FillChar(FCurrentContext, SizeOf(FCurrentContext), 0);
                          with lblConsults do if Caption <> 'Default List' then Caption := 'Custom List' ;
                          FCurrentContext.BeginDate := BeginDate;
                          FCurrentContext.EndDate   := EndDate;
                          FCurrentContext.Status := Status;
                          FCurrentContext.Service := Service;
                          FCurrentContext.GroupBy := GroupBy;
                          FCurrentContext.Ascending := Ascending;
                        end ;
                      end ;
   end; {case}
   tvConsults.Caption := lblConsults.Caption;
   if not frmFrame.ContextChanging then LoadConsults;
end ;

procedure TfrmConsults.SetActionMenus ;
{Set available menu actions based on consult status and user access to consult's service}
var
   status: integer ;
begin

     FillChar(MenuAccessRec, SizeOf(MenuAccessRec), 0);
     if (lstConsults.ItemIndex < 0) then
      begin
        mnuAct.Enabled := False ;
        exit ;
      end
     else
      begin
       MenuAccessRec  := GetActionMenuLevel(ConsultRec.IEN) ;
       status  := ConsultRec.ORStatus ;
      end ;


     with MenuAccessRec do
       begin
          //     mnuAct.Enabled := (UserLevel > 1) ;    {'User Review'    menu level = 1 }
                                             {'Service Action' menu level = 2 }

         mnuActConsultRequest.Enabled :=  (lstConsults.ItemIEN > 0);
         mnuActReceive.Enabled        :=  (UserLevel > UL_REVIEW)
                                                          and (status=ST_PENDING);
         mnuActSchedule.Enabled       :=  (UserLevel > UL_REVIEW)
                                                          and ((status=ST_PENDING)
                                                          or   (status=ST_ACTIVE));
         mnuActDeny.Enabled           :=  (UserLevel > UL_REVIEW)
                                                          and ((status<>ST_DISCONTINUED)
                                                          and (status<>ST_COMPLETE)
                                                          and (status<>ST_CANCELLED)
                                                          and (status<>ST_PARTIAL_RESULTS))   ;
(*         mnuActEditResubmit.Enabled   :=  {(UserLevel > 1) and }(Notifications.Active)
            {if the user received the alert,}          and (lstConsults.ItemIEN = CurrNotifIEN)
            { this menu should be available }          and (status = ST_CANCELLED)
                                                       and (not User.NoOrdering);*)
        {if processing an alert - NO CHANGE HERE}
         if Notifications.Active and (lstConsults.ItemIEN = CurrNotifIEN) then
           mnuActEditResubmit.Enabled := (*(lstConsults.ItemIEN = CurrNotifIEN) and*)
                                         (status = ST_CANCELLED) and
                                         (not User.NoOrdering)
        {if not processing an alert, check other stuff}
         else
           mnuActEditResubmit.Enabled :=  AllowResubmit and
                                          (status = ST_CANCELLED) and
                                          (not User.NoOrdering);
         mnuActForward.Enabled        :=  (UserLevel > UL_REVIEW)
                                                       and ((status<>ST_DISCONTINUED)
                                                       and (status<>ST_COMPLETE)
                                                       and (status<>ST_CANCELLED))   ;
         mnuActDiscontinue.Enabled    :=  (UserLevel > UL_REVIEW)
                                                       and ((status<>ST_DISCONTINUED)
                                                       and (status<>ST_COMPLETE)
                                                       and (status<>ST_CANCELLED)
                                                       and (status<>ST_PARTIAL_RESULTS))   ;
         mnuActSigFindings.Enabled    :=  (UserLevel > UL_REVIEW)
                                                       and ((status<>ST_DISCONTINUED)
                                                       and (status<>ST_CANCELLED));
         mnuActAdminComplete.Enabled  :=  ((UserLevel = UL_ADMIN) or (UserLevel = UL_UPDATE_AND_ADMIN))
                                                       and ((status<>ST_DISCONTINUED)
                                                       and (status<>ST_COMPLETE)
                                                       and (status<>ST_CANCELLED));

         mnuActAddComment.Enabled     :=  True;
         mnuActDisplayDetails.Enabled :=  True;
         mnuActDisplayResults.Enabled :=  True;
         mnuActDisplaySF513.Enabled   :=  True;
         mnuActPrintSF513.Enabled     :=  True;
         mnuActConsultResults.Enabled :=  (lstConsults.ItemIEN > 0) and
                                          (((UserLevel = UL_UPDATE) or (UserLevel = UL_UPDATE_AND_ADMIN) or (UserLevel = UL_UNRESTRICTED)) and
                                          ((status<>ST_DISCONTINUED) and
                                           (status<>ST_CANCELLED)))
                                          or
                                           (lstConsults.ItemIEN > 0) and
                                          ((AllowMedResulting) and
                                          ((status<>ST_DISCONTINUED) and
                                           (status<>ST_CANCELLED)))
                                          or
                                           (lstConsults.ItemIEN > 0) and
                                          ((AllowMedDissociate) and
                                          ((status = ST_COMPLETE)))
                                          or
                                           ((Notifications.Active) and
                                           (lstConsults.ItemIEN = CurrNotifIEN) and
                                           (Notifications.FollowUp = NF_CONSULT_UNSIGNED_NOTE) and
                                           (lstNotes.ItemIndex > -1));
         cmdEditResubmit.Visible      :=  mnuActEditResubmit.Enabled;
       end;
end ;

procedure TfrmConsults.SetResultMenus ;
var
  WhyNot: string;
begin
  mnuActComplete.Enabled           :=   mnuActConsultResults.Enabled and
                                        ((MenuAccessRec.UserLevel = UL_UPDATE) or
                                        (MenuAccessRec.UserLevel = UL_UPDATE_AND_ADMIN) or
                                        (MenuAccessRec.UserLevel = UL_UNRESTRICTED))
                                        and
                                       ((ConsultRec.ORStatus=ST_PENDING) or
                                       (ConsultRec.ORStatus=ST_ACTIVE) or
                                       (ConsultRec.ORStatus=ST_SCHEDULED) or
                                       (ConsultRec.ORStatus=ST_PARTIAL_RESULTS) or
                                       (ConsultRec.ORStatus=ST_COMPLETE))   ;
  mnuActMakeAddendum.Enabled       :=  mnuActConsultResults.Enabled and
                                        ((MenuAccessRec.UserLevel = UL_UPDATE) or
                                        (MenuAccessRec.UserLevel = UL_UPDATE_AND_ADMIN) or
                                        (MenuAccessRec.UserLevel = UL_UNRESTRICTED))
                                        and
                                       ((lstNotes.ItemIndex > -1) and
                                       ((ConsultRec.TIUResultNarrative>0) or
                                       (lstNotes.ItemIEN > 0)));
  mnuActAddIDEntry.Enabled         :=   mnuActConsultResults.Enabled and
                                        uIDNotesActive and
                                        (tvCsltNotes.Selected <> nil) and
                                        (tvCsltNotes.Selected.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                        IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN,
                                        IMG_IDPAR_ADDENDA_SHUT]) and
                                        CanReceiveAttachment(PDocTreeObject(tvCsltNotes.Selected.Data)^.DocID, WhyNot);
  mnuActDetachFromIDParent.Enabled :=   mnuActConsultResults.Enabled and
                                        uIDNotesActive and
                                        (tvCsltNotes.Selected <> nil) and
                                        (tvCsltNotes.Selected.ImageIndex in [IMG_ID_CHILD, IMG_ID_CHILD_ADD]);
  mnuActAttachMed.Enabled          :=   mnuActConsultResults.Enabled and
                                        (((mnuActComplete.Enabled) or
                                        (MenuAccessRec.UserLevel = UL_ADMIN) or
                                        (MenuAccessRec.UserLevel = UL_UPDATE_AND_ADMIN)))
                                         and (MenuAccessRec.AllowMedResulting);
  mnuActRemoveMed.Enabled          :=   mnuActConsultResults.Enabled and
                                        ((ConsultRec.ORStatus=ST_COMPLETE) and (MenuAccessRec.AllowMedDissociate));
  mnuActNoteEdit.Enabled           :=   mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0) or
                                        (FActionType = CN_ACT_COMPLETE) or
                                        (FActionType = CN_ACT_ADDENDUM)));
  mnuActNoteDelete.Enabled         :=   mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0) or
                                        (FActionType = CN_ACT_COMPLETE) or
                                        (FActionType = CN_ACT_ADDENDUM)));
  mnuActSignatureSign.Enabled      :=   mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0) or
                                        (FActionType = CN_ACT_COMPLETE) or
                                        (FActionType = CN_ACT_ADDENDUM)))
                                        or
                                        ((Notifications.Active) and
                                        (lstConsults.ItemIEN = CurrNotifIEN) and
                                        (Notifications.FollowUp = NF_CONSULT_UNSIGNED_NOTE) and
                                        (lstNotes.ItemIndex > -1));
  mnuActSignatureList.Enabled      :=   mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0) or
                                        (FActionType = CN_ACT_COMPLETE) or
                                        (FActionType = CN_ACT_ADDENDUM)))
                                        or
                                        ((Notifications.Active) and
                                        (lstConsults.ItemIEN = CurrNotifIEN) and
                                        (Notifications.FollowUp = NF_CONSULT_UNSIGNED_NOTE) and
                                        (lstNotes.ItemIndex > -1));
  mnuActSignatureSave.Enabled      :=   mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0) or
                                        (FActionType = CN_ACT_COMPLETE) or
                                        (FActionType = CN_ACT_ADDENDUM)));
  mnuActIdentifyAddlSigners.Enabled :=  mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0)));
  mnuActNotePrint.Enabled           :=  mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and
                                        ((ConsultRec.TIUResultNarrative>0) or
                                        (lstNotes.ItemIEN > 0)));
  mnuActChange.Enabled              :=  mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and (lstNotes.ItemIndex = EditingIndex));
  mnuActLoadBoiler.Enabled          :=  mnuActConsultResults.Enabled and
                                        ((lstNotes.ItemIndex > -1) and (lstNotes.ItemIndex = EditingIndex));

  if ((lstNotes.ItemIndex > -1) and UserIsSigner(lstNotes.ItemIEN)) then
  begin
    mnuActSignatureList.Enabled := True;
    mnuActSignatureSign.Enabled := True;
    mnuActConsultResults.Enabled := True;
  end;

  popNoteMemoSignList.Enabled       :=  //(mnuActConsultResults.Enabled) and
                                        (mnuActSignatureList.Enabled) ;
  popNoteMemoSign.Enabled           :=  //(mnuActConsultResults.Enabled) and
                                        mnuActSignatureSign.Enabled ;
  popNoteMemoSave.Enabled           :=  //(mnuActConsultResults.Enabled) and
                                        mnuActSignatureSave.Enabled ;
  popNoteMemoEdit.Enabled           :=  //(mnuActConsultResults.Enabled) and
                                        mnuActNoteEdit.Enabled;
  popNoteMemoAddend.Enabled         :=  //(mnuActConsultResults.Enabled) and
                                        mnuActMakeAddendum.Enabled;
  popNoteMemoDelete.Enabled         :=  //(mnuActConsultResults.Enabled) and
                                        mnuActNoteDelete.Enabled;
  popNoteMemoAddlSign.Enabled       :=  //(mnuActConsultResults.Enabled) and
                                        mnuActIdentifyAddlSigners.Enabled;
  popNoteMemoPrint.Enabled          :=  (mnuActNotePrint.Enabled);
end;

procedure TfrmConsults.DisplayPCE;
{ displays PCE information if appropriate & enables/disables editing of PCE data }
var
  EnableList, ShowList: TDrawers;
  VitalStr:   TStringlist;
  NoPCE:      boolean;
  ActionSts: TActionRec;

begin
  if (lstNotes.ItemIndex=-1) or (lstNotes.Items.Count=0) then exit ;
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
      cmdPCE.Enabled := CanEditPCE(uPCEEdit);
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
      frmDrawers.Visible := True;
      frmDrawers.DisplayDrawers(TRUE, EnableList, ShowList);
      cmdNewConsult.Visible := False;
      cmdNewProc.Visible := False;
      pnlConsultList.Height := (pnlLeft.Height div 5);

      cmdPCE.Visible := TRUE;
    end;
  end else
  begin
    //VitalStr := TStringList.create;
    //VitalStr.clear;
    cmdPCE.Enabled := False;

    frmDrawers.Visible := False;
    frmDrawers.DisplayDrawers(FALSE);
    cmdPCE.Visible := FALSE;
    cmdNewConsult.Visible := True;
    cmdNewProc.Top := cmdNewConsult.Top + cmdNewConsult.Height;
    cmdNewProc.Visible := True;
    pnlConsultList.Height := (pnlLeft.Height div 2);
    //pnlConsultList.Height := 3 * (pnlLeft.Height div 5);

    ActOnDocument(ActionSts, lstNotes.ItemIEN, 'VIEW');
    if ActionSts.Success then
    begin
      StatusText('Retrieving encounter information...');
      with uPCEShow do
      begin
        NoteDateTime := MakeFMDateTime(Piece(lstNotes.Items[lstNotes.ItemIndex], U, 3));
        PCEForNote(lstNotes.ItemIEN, uPCEEdit);
        AddStrData(memPCEShow.Lines);
        NoPCE := (memPCEShow.Lines.Count = 0);
        VitalStr  := TStringList.create;
        try
          GetVitalsFromNote(VitalStr, uPCEShow, lstNotes.ItemIEN);
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
  memPCEShow.SelStart := 0;
  popNoteMemoEncounter.Enabled := cmdPCE.Enabled;
  popNoteMemoEncounter.Visible := cmdPCE.Visible;
end;

procedure TfrmConsults.ShowPCEControls(ShouldShow: Boolean);
begin
  sptVert.Visible    := ShouldShow;
  memPCEShow.Visible := ShouldShow;
  if(ShouldShow) then
    sptVert.Top := memPCEShow.Top - sptVert.Height;
  memResults.Invalidate;
end;

procedure TfrmConsults.RemovePCEFromChanges(IEN: Integer; AVisitStr: string = '');
begin
  if IEN = CN_ADDENDUM then Exit;  // no PCE information entered for an addendum
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

procedure TfrmConsults.lstNotesClick(Sender: TObject);
{ loads the text for the selected note or displays the editing panel for the selected note }
var
 x: string;
begin
  inherited;
  if (lstNotes.ItemIEN = -1) then exit ;
  with lstNotes do
   if ItemIndex = EditingIndex then
     begin
       pnlConsultList.Enabled := False; //CQ#15785
//       lstConsults.Enabled := False ;
//       tvConsults.Enabled := False;
       pnlResults.Visible := True;
       pnlResults.BringToFront;
       memConsult.TabStop := False;
       mnuActChange.Enabled     := True;
       mnuActLoadBoiler.Enabled := True;
       UpdateReminderFinish;
     end
   else
     begin
       StatusText('Retrieving selected item...');
       if EditingIndex = -1 then
         begin
           pnlConsultList.Enabled := True; //CQ#15785
//           lstConsults.Enabled := True ;
//           tvConsults.Enabled := True;
         end;
       lblTitle.Caption := MakeConsultNoteDisplayText(lstNotes.Items[lstNotes.ItemIndex]);
       lblTitle.Hint := lblTitle.Caption;
       lstNotes.Enabled := True ;
       pnlResults.Visible := False;
       UpdateReminderFinish;
       pnlRead.BringToFront;
       memConsult.TabStop := True;
       if Copy(Piece(lstNotes.ItemID, ';', 2), 1, 4)= 'MCAR' then
         begin
           QuickCopy(GetDetailedMedicineResults(lstNotes.ItemID), memConsult);
           x := Piece(Piece(Piece(lstNotes.ItemID, ';', 2), '(', 2), ',', 1) + ';' + Piece(lstNotes.ItemID, ';', 1);
           x := 'MED^' + x;
           SetPiece(x, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
           NotifyOtherApps(NAE_REPORT, x);
         end
       else
         begin
           LoadDocumentText(memConsult.Lines,ItemIEN) ;
           mnuActChange.Enabled     := False;
           mnuActLoadBoiler.Enabled := False;
           x := 'TIU^' + lstNotes.ItemID;
           SetPiece(x, U, 10, Piece(lstNotes.Items[lstNotes.ItemIndex], U, 11));
           NotifyOtherApps(NAE_REPORT, x);
         end;
       memConsult.SelStart := 0;
     end;
  if Copy(Piece(lstNotes.ItemID, ';', 2), 1, 4) <> 'MCAR' then
    begin
      if(assigned(frmReminderTree)) then frmReminderTree.EnableActions;
      DisplayPCE;
    end;
  pnlRight.Refresh;
  memConsult.Repaint;
  memResults.Repaint;
  SetResultMenus;
  StatusText('');
end;

procedure TfrmConsults.popNoteMemoPopup(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteMemo) is TCustomEdit
    then FEditCtrl := TCustomEdit(PopupComponent(Sender, popNoteMemo))
    else FEditCtrl := nil;
  if FEditCtrl <> nil then
   begin
    popNoteMemoCut.Enabled       := FEditCtrl.SelLength > 0;
    popNoteMemoCopy.Enabled      := popNoteMemoCut.Enabled;
    popNoteMemoPaste.Enabled     := (not TORExposedCustomEdit(FEditCtrl).ReadOnly) and
                                    Clipboard.HasFormat(CF_TEXT);
    popNoteMemoTemplate.Enabled  := frmDrawers.CanEditTemplates and popNoteMemoCut.Enabled;
    popNoteMemoFind.Enabled      := FEditCtrl.GetTextLen > 0;
   end
  else
   begin
    popNoteMemoCut.Enabled       := False;
    popNoteMemoCopy.Enabled      := False;
    popNoteMemoPaste.Enabled     := False;
    popNoteMemoTemplate.Enabled  := False;
   end;
  if pnlResults.Visible then
  begin
    popNoteMemoSpell.Enabled    := True;
    popNoteMemoGrammar.Enabled  := True;
    popNoteMemoReformat.Enabled := True;
    popNoteMemoReplace.Enabled  := (FEditCtrl.GetTextLen > 0);
    popNoteMemoPreview.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popNoteMemoInsTemplate.Enabled  := (frmDrawers.TheOpenDrawer = odTemplates) and Assigned(frmDrawers.tvTemplates.Selected);
    popNoteMemoViewCslt.Enabled := (FEditNote.PkgPtr = PKG_CONSULTS);  //wat cq 17586
  end else
  begin
    popNoteMemoSpell.Enabled    := False;
    popNoteMemoGrammar.Enabled  := False;
    popNoteMemoReformat.Enabled := False;
    popNoteMemoReplace.Enabled  := False;
    popNoteMemoPreview.Enabled  := False;
    popNoteMemoInsTemplate.Enabled := False;
    popNoteMemoViewCslt.Enabled := FALSE; //wat cq 17586
  end;
end;

procedure TfrmConsults.popNoteMemoCutClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CutToClipboard;
end;

procedure TfrmConsults.popNoteMemoCopyClick(Sender: TObject);
begin
  inherited;
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmConsults.popNoteMemoPasteClick(Sender: TObject);
begin
  inherited;
 // FEditCtrl.SelText := Clipboard.AsText; {*KCM*}
  ScrubTheClipboard;
  FEditCtrl.PasteFromClipboard;        // use AsText to prevent formatting
end;

procedure TfrmConsults.popNoteMemoReformatClick(Sender: TObject);
begin
  inherited;
  if Screen.ActiveControl <> memResults then Exit;
  ReformatMemoParagraph(memResults);
end;

procedure TfrmConsults.popNoteMemoFindClick(Sender: TObject);
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

procedure TfrmConsults.dlgFindTextFind(Sender: TObject);
begin
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmConsults.dlgReplaceTextFind(Sender: TObject);
begin
  inherited;
  dmodShared.FindRichEditText(dlgFindText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmConsults.dlgReplaceTextReplace(Sender: TObject);
begin
  inherited;
  dmodShared.ReplaceRichEditText(dlgReplaceText, TRichEdit(popNoteMemo.PopupComponent));
end;

procedure TfrmConsults.popNoteMemoReplaceClick(Sender: TObject);
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

procedure TfrmConsults.popNoteMemoSpellClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    SpellCheckForControl(memResults);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmConsults.popNoteMemoGrammarClick(Sender: TObject);
begin
  inherited;
  DoAutoSave(0);
  timAutoSave.Enabled := False;
  try
    GrammarCheckForControl(memResults);
  finally
    FChanged := True;
    DoAutoSave(0);
    timAutoSave.Enabled := True;
  end;
end;

procedure TfrmConsults.RequestPrint;
var
  Saved: boolean;
begin
  inherited;
  if lstNotes.ItemIEN = EditingIndex then  // !KCM! in response to WPB-0898-31166
  //if ItemIEN < 0 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  with lstConsults do
    if ItemIEN > 0 then PrintSF513(ItemIEN, DisplayText[ItemIndex]) else
     begin
      if ItemIEN = 0 then InfoBox(TX_NOCONSULT, TX_NOCSLT_CAP, MB_OK);
      if lstNotes.ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
     end;
end;

procedure TfrmConsults.RequestMultiplePrint(AForm: TfrmPrintList);
var
  NoteIEN: int64;
  i: integer;
begin
  inherited;
  with AForm.lbIDParents do
  begin
    for i := 0 to Items.Count - 1 do
     begin
       if Selected[i] then
        begin
         NoteIEN := ItemIEN;  //StrToInt64def(Piece(TStringList(Items.Objects[i])[0],U,1),0);
         if NoteIEN > 0 then PrintSF513(NoteIEN, DisplayText[i]) else
          begin
           if NoteIEN = 0 then InfoBox(TX_NOCONSULT, TX_NOCSLT_CAP, MB_OK);
           if NoteIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
          end;
        end; {if selected}
     end; {for}
  end; {with}
end;

procedure TfrmConsults.mnuActDisplayResultsClick(Sender: TObject);
var
  Saved: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0 then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  lstNotes.ItemIndex := -1 ;
  DisplayResults(memConsult.Lines, lstConsults.ItemIEN) ;
  memConsult.SelStart := 0;
  SetResultMenus;
  if memConsult.CanFocus then
    memConsult.SetFocus;
end;

procedure TfrmConsults.mnuActDisplaySF513Click(Sender: TObject);
var
  Saved: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0 then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  lstNotes.ItemIndex := -1 ;
  with lstConsults do
    if ItemIEN > 0 then ReportBox(ShowSF513(ItemIEN),DisplayText[ItemIndex], False)
    else
    begin
      if ItemIEN = 0 then InfoBox(TX_NOCONSULT, TX_NOCSLT_CAP, MB_OK);
      if lstNotes.ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  SetResultMenus;
end;

procedure TfrmConsults.pnlResultsResize(Sender: TObject);
const
  LEFT_MARGIN = 4;
begin
  inherited;
  LimitEditWidth(memResults, MAX_ENTRY_WIDTH - 1);
  memResults.Constraints.MinWidth := TextWidthByFont(memResults.Font.Handle, StringOfChar('X', MAX_ENTRY_WIDTH)) + (LEFT_MARGIN * 2) + ScrollBarWidth;
  //CQ13181	508 Consults--Splitter bar doesn't retain size
 //CQ13181  pnlLeft.Width := self.ClientWidth - pnlResults.Width - sptHorz.Width;
end;

procedure TfrmConsults.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);
var
  SavedCsltID: string;
begin
  if ViewContext = 0 then exit;     // form has not yet been displayed, so nothing to update
  if EditingIndex <> -1 then exit;  // do not rebuild list until after save
  with tvConsults do if Selected <> nil then SavedCsltID := lstConsults.ItemID;
  case OrderAction of
  ORDER_NEW:  UpdateList ;
  ORDER_SIGN: UpdateList{ sent by fReview, fOrderSign when orders signed, AnOrder=nil}
  end;
  if SavedCsltID <> '' then with tvConsults do
  begin
    Selected := FindPieceNode(SavedCsltID, U, Items.GetFirstNode);
    tvConsultsChange(Self, Selected);
  end;
end;

procedure TfrmConsults.mnuActPrintSF513Click(Sender: TObject);
var
  Saved: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0 then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  RequestPrint;
end;


function TfrmConsults.AuthorizedUser: Boolean;
begin
  Result := True;
  if User.NoOrdering then Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
end;

procedure TfrmConsults.FormCreate(Sender: TObject);
begin
  inherited;
  FocusToRightPanel := False;
  PageID := CT_CONSULTS;
  EditingIndex := -1;
  FLastNoteID := '';
  FEditNote.LastCosigner := 0;
  FEditNote.LastCosignerName := '';
  //pnlConsultList.Height := (pnlLeft.Height div 2);
  pnlConsultList.Height := 3 * (pnlLeft.Height div 5);
  frmDrawers := TfrmDrawers.CreateDrawers(Self, pnlAction, [],[]);
  frmDrawers.Align := alBottom;
  frmDrawers.RichEditControl := memResults;
  frmDrawers.Splitter := splDrawers;
  frmDrawers.DefTempPiece := 2;
  FImageFlag := TBitmap.Create;
  FDocList := TStringList.Create;
  with FCurrentNoteContext do
    begin
      GroupBy := '';
      TreeAscending := False;
      Status := IntToStr(NC_ALL);
    end;
  FCsltList := TStringList.Create;
end;

procedure TfrmConsults.mnuActDisplayDetailsClick(Sender: TObject);
var
  Saved: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0  then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  tvConsultsChange(Self, tvConsults.Selected);
  //lstConsultsClick(Self);
  if memConsult.CanFocus then
    memConsult.SetFocus;
end;

procedure TfrmConsults.FormClose(Sender: TObject; var Action: TCloseAction);
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
    if memResults.GetTextLen > 0 then SaveCurrentNote(Saved)
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

procedure TfrmConsults.mnuActIdentifyAddlSignersClick(Sender: TObject);
var
  Exclusions: TStrings;
  Saved, x, y: boolean;
  SignerList: TSignerList;
  ActionSts: TActionRec;
  SigAction: integer;
  SavedDocID, SavedCsltID: string;
  ARefDate: TFMDateTime;
begin
  inherited;
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  SavedCsltID := lstConsults.ItemID;
  if lstNotes.ItemIndex = EditingIndex then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
      tvConsultsChange(Self, tvConsults.Selected);
      with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
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

  with lstNotes do
    begin
      if not LockConsultRequestAndNote(ItemIEN) then Exit;
      Exclusions := GetCurrentSigners(ItemIEN);
      ARefDate := StrToFloat(Piece(Items[ItemIndex], U, 3));
      SelectAdditionalSigners(Font.Size, ItemIEN, SigAction, Exclusions, SignerList, CT_CONSULTS, ARefDate);
    end;
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
  UnlockConsultRequest(lstNotes.ItemIEN, StrToIntDef(SavedCsltID, 0));  // v20.4  RV (unlocking problem)
  //UnlockConsultRequest(lstNotes.ItemIEN, ConsultRec.IEN);
end;

procedure TfrmConsults.popNoteMemoAddlSignClick(Sender: TObject);
begin
  inherited;
  mnuActIdentifyAddlSignersClick(Self);
end;

procedure TfrmConsults.ProcessNotifications;
var
  ConsultIEN, NoteIEN: integer;
  x: string;
  Saved: boolean;
  AnObject: PDocTreeObject;
  tmpNode: TORTreeNode;
  I:Integer;
  CommentDate: String;
  Format: CHARFORMAT2;
  VisibleLineCount: integer;
begin
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  FNotifPending := True;
  NoteIEN := 0;
  CurrNotifIEN := 0;
  lblConsults.Caption := Notifications.Text;
  tvConsults.Caption := Notifications.Text;
  EditingIndex := -1;
  pnlConsultList.Enabled := True; //CQ#15785
//  lstConsults.Enabled := True ;
//  tvConsults.Enabled := True;
  lstNotes.Enabled := True ;
  pnlRead.BringToFront ;
  memConsult.TabStop := True;
  lstConsults.Clear;

  if Copy(Piece(Piece(Notifications.RecordID, U, 2),';',1),1,3) = 'TIU' then
    begin
      ConsultIEN := StrToIntDef(Piece(Piece(Notifications.RecordID, U, 4),';',2),0);
      NoteIEN := StrToIntDef(Piece(Notifications.AlertData, U, 1),0);
    end
  else if Notifications.Followup = NF_STAT_RESULTS then
    ConsultIEN := StrToIntDef(Piece(Piece(Piece(Notifications.AlertData, '|', 2), '@', 1), ';', 1), 0)
  else if Notifications.Followup = NF_CONSULT_PROC_INTERPRETATION then
    ConsultIEN := StrToIntDef(Piece(Notifications.AlertData, '|', 1), 0)
  else if ((Notifications.Followup = NF_CONSULT_REQUEST_RESOLUTION) and (Pos('Sig Findings', Notifications.RecordID) = 0)) then
    ConsultIEN := StrToIntDef(Piece(Notifications.AlertData, '|', 1), 0)
  else
    ConsultIEN := StrToIntDef(Notifications.AlertData, 0);
  x := FindConsult(ConsultIEN);
  CurrNotifIEN := ConsultIEN;
  lstConsults.Items.Add(x);
  uChanging := True;
  tvConsults.Items.BeginUpdate;
  tvConsults.Items.Clear;
  tmpNode := tvConsults.FindPieceNode('Alerted Consult', 2, U, nil);
  if tmpNode = nil then
    begin
      tmpNode := TORTreeNode(tvConsults.Items.AddFirst(tvConsults.Items.GetFirstNode, 'Alerted Consult'));
      tmpNode.StringData := '-1^Alerted Consult^^^^^^0';
    end
  else
    tmpNode.DeleteChildren;
  SetNodeImage(tmpNode, FCurrentContext);
  tmpNode := TORTreeNode(tvConsults.Items.AddChildFirst(tmpNode, MakeConsultListDisplayText(x)));
  tmpNode.StringData := x;
  SetNodeImage(tmpNode, FCurrentContext);
  with tvConsults do Selected := FindPieceNode(Piece(x, U, 1), U, Items.GetFirstNode);
  tvConsults.Items.EndUpdate;
  uChanging := False;
  tvConsultsChange(Self, tvConsults.Selected);
  if ((Notifications.Followup = NF_CONSULT_REQUEST_RESOLUTION) and (Pos('Sig Findings', Notifications.RecordID) = 0)) then
    begin
      //XQADATA = consult_ien|tiu_ien;TIU(8925,
      if Copy(Piece(Piece(Notifications.AlertData, '|', 2), ';', 2), 1, 3) = 'TIU' then
        NoteIEN := StrToIntDef(Piece(Piece(Notifications.AlertData, '|', 2), ';', 1), 0);
    end
  else if (Notifications.Followup = NF_CONSULT_PROC_INTERPRETATION) then
    begin
      NoteIEN := StrToIntDef(Piece(Piece(Notifications.AlertData, '|', 2), ';', 1), 0);
    end
  else if (Notifications.Followup = NF_STAT_RESULTS) then
    begin
      NoteIEN := 0;   // Note IEN not available for this alert - fall through to display all results - CURTIS?
    end;
  tvCsltNotes.FullExpand;
  if NoteIEN > 0 then with lstNotes do
    begin
      if SelectByIEN(NoteIEN) = -1 then
        begin
          x := Notifications.AlertData;
          uChanging := True;
          tvCsltNotes.Items.BeginUpdate;
          lstNotes.Clear;
          KillDocTreeObjects(tvCsltNotes);
          tvCsltNotes.Items.Clear;
          lstNotes.Items.Add(x);
          AnObject := MakeConsultsNoteTreeObject('ALERT^Alerted Note^^^^^^^^^^^%^0');
          tmpNode := TORTreeNode(tvCsltNotes.Items.AddObjectFirst(tvCsltNotes.Items.GetFirstNode, AnObject.NodeText, AnObject));
          TORTreeNode(tmpNode).StringData := 'ALERT^Alerted Note^^^^^^^^^^^%^0';
          tmpNode.ImageIndex := IMG_TOP_LEVEL;
          AnObject := MakeConsultsNoteTreeObject(x);
          tmpNode := TORTreeNode(tvCsltNotes.Items.AddChildObjectFirst(tmpNode, AnObject.NodeText, AnObject));
          tmpNode.StringData := x;
          SetTreeNodeImagesAndFormatting(tmpNode, FCurrentNoteContext, CT_CONSULTS);
          with tvCsltNotes do Selected := FindPieceNode(Piece(x, U, 1), U, Items.GetFirstNode);
          tvCsltNotes.Items.EndUpdate;
          uChanging := False;
        end
      else
        begin
          uChanging := True;
          with tvCsltNotes do Selected := FindPieceNode(IntToStr(NoteIEN), U , nil);
          uChanging := False;
        end;
      tvCsltNotesChange(Self, tvCsltNotes.Selected);
    end
  else if (ConsultRec.ORStatus = ST_COMPLETE) and ((ConsultRec.TIUDocuments.Count + ConsultRec.MedResults.Count) > 0)
  and (Pos(UpperCase('Comment added'), UpperCase(Notifications.Text)) = 0) then //CB
    mnuActDisplayResultsClick(Self);

  //CB
   If (Notifications.HighLightSection <> '') and (Pos(UpperCase('Comment added'), UpperCase(Notifications.Text)) > 0) then begin
   CommentDate := FormatDateTime('mm/dd/yy hh:mm', StrToDateTime(StringReplace(Notifications.HighLightSection, '@', ' ', [rfReplaceAll])) );
   for I := 0 to memConsult.Lines.Count - 1 do begin
     If (Pos(CommentDate, memConsult.Lines.Strings[i]) > 0) and (Pos(UpperCase('ADDED COMMENT'), UpperCase(memConsult.Lines.Strings[i])) > 0) then begin
      if CustomCanFocus(memconsult) then
        memConsult.SetFocus;
      memConsult.SelStart := memConsult.Perform(EM_LINEINDEX, i,0);
      memConsult.SelLength := Length(memConsult.Lines.Strings[i]);

      //Set the background color
      Format.cbSize := SizeOf(Format);
      Format.dwMask := CFM_BACKCOLOR;

      Format.crBackColor := clRed;
      memConsult.Perform(EM_SETCHARFORMAT, SCF_SELECTION, Longint(@Format));
          //Get visible Line Couunt
       VisibleLineCount := LinesVisible(memConsult);

      if (I + VisibleLineCount)>= memConsult.Lines.Count - 1 then
        memConsult.SelStart := memConsult.Perform(EM_LINEINDEX, memConsult.Lines.Count - 1,0)
      else memConsult.SelStart := memConsult.Perform(EM_LINEINDEX,I + VisibleLineCount - 1,0);

      memConsult.Perform($00B7, 0, 0);  //EM_SETCARRET DEFINED WRONG in Richedit.pas
      memConsult.SelLength := 0;
      break;
     end;
   end;
  end;

  case Notifications.Followup of
    NF_CONSULT_REQUEST_RESOLUTION   :  Notifications.Delete;
    NF_NEW_SERVICE_CONSULT_REQUEST  :  Notifications.Delete;
    NF_STAT_RESULTS                 :  Notifications.Delete;
    NF_CONSULT_REQUEST_CANCEL_HOLD  :  Notifications.Delete;
    NF_CONSULT_REQUEST_UPDATED      :  Notifications.Delete;
    NF_CONSULT_UNSIGNED_NOTE        :  {Will be automatically deleted by TIU sig action!!!} ;
    NF_CONSULT_PROC_INTERPRETATION  :  Notifications.Delete;      // not sure we want to do this yet,
                                                                  // but if not now, then when?
  end;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 6) = 'TIUADD' then Notifications.Delete;
  if Copy(Piece(Notifications.RecordID, U, 2), 1, 5) = 'TIUID' then Notifications.Delete;
  FNotifPending := False;
end;

// *****************************************************************
//                  Delphi's Can Focus has a bug.
//     Source: http://qc.embarcadero.com/wc/qcmain.aspx?d=11229
// *****************************************************************
function TfrmConsults.CustomCanFocus(Control: TWinControl): Boolean;
var
  Form: TCustomForm;
begin
  Result := False;
  Form := GetParentForm(Self);
  if Form <> nil then
  begin
    Control := Self;
    repeat
      if not (Control.Visible and Control.Enabled) then
       Exit;
      Control := Control.Parent;
    until Control = nil;
    Result := True;
  end;
end;

 function TfrmConsults.LinesVisible(richedit: Trichedit): integer;
    Var
      OldFont : HFont;
      Hand : THandle;
      TM : TTextMetric;
      Rect  : TRect;
      tempint : integer;
    begin
      Hand := GetDC(richedit.Handle);
      try
        OldFont := SelectObject(Hand, richedit.Font.Handle);
        try
          GetTextMetrics(Hand, TM);
          richedit.Perform(EM_GETRECT, 0, longint(@Rect));
          tempint := (Rect.Bottom - Rect.Top) div
             (TM.tmHeight + TM.tmExternalLeading);
        finally
          SelectObject(Hand, OldFont);
        end;
      finally
        ReleaseDC(richedit.Handle, Hand);
      end;
      Result := tempint;
    end;

procedure TfrmConsults.mnuActEditResubmitClick(Sender: TObject);
var
  Resubmitted: boolean;
  x: string;
  SavedConsultID: string;
begin
  inherited;
  if lstConsults.ItemIEN = 0  then exit;
  SavedConsultID := lstConsults.ItemID;
  x := ConsultCanBeResubmitted(lstConsults.ItemIEN);
  if Piece(x, U, 1) = '0' then
    begin
      InfoBox(Piece(x, U, 2), TC_NO_RESUBMIT, MB_OK);
      Exit;
    end;
  if ConsultRec.ConsultProcedure <> '' then
    Resubmitted := EditResubmitProcedure(Font.Size, lstConsults.ItemIEN)
  else
    Resubmitted := EditResubmitConsult(Font.Size, lstConsults.ItemIEN);
  if Resubmitted then
    begin
      LoadConsults;
      with tvConsults do Selected := FindPieceNode(SavedConsultID, 1, U, Items.GetFirstNode);
      tvConsultsClick(Self);
    (*      lstConsults.Clear;
      lstConsults.Items.Add(FindConsult(ConsultRec.IEN));
      lstConsults.SelectByIEN(ConsultRec.IEN);
      lstConsultsClick(Self);*)
    end;
end;

procedure TfrmConsults.EnableDisableOrdering;
begin
  if User.NoOrdering then
    begin
      cmdNewConsult.Enabled := False;
      cmdNewProc.Enabled := False;
      mnuActNew.Enabled  := False;
      Exit;
    end;
end;

procedure TfrmConsults.UMNewOrder(var Message: TMessage);
{ update consults list if progress note completes consult }
begin
  with Message do
  begin
    if ViewContext = 0 then exit;  // form has not yet been displayed, so nothing to update
    UpdateList;
  end;
end;

procedure TfrmConsults.cmdEditResubmitClick(Sender: TObject);
begin
  inherited;
  mnuActEditResubmitClick(Self);
end;

procedure TfrmConsults.cmdEditResubmitExit(Sender: TObject);
begin
  inherited;
  DoLeftPanelCustomShiftTab;
end;

procedure TfrmConsults.mnuViewSaveAsDefaultClick(Sender: TObject);
begin
  inherited;
  if InfoBox('Replace current defaults?','Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
    begin
      SaveCurrentContext(FCurrentContext);
      lblConsults.Caption := 'Default List';
      tvConsults.Caption := 'Default List';
      FDefaultContext := FCurrentContext;
    end;
end;

procedure TfrmConsults.mnuViewReturntoDefaultClick(Sender: TObject);
begin
  inherited;
  lblConsults.Caption := 'Default List';
  tvConsults.Caption := 'Default List';
  SetViewContext(FDefaultContext);
end;

procedure TfrmConsults.popNoteMemoTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, True, FEditCtrl.SelText);
end;

procedure TfrmConsults.mnuEditTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self);
end;

procedure TfrmConsults.mnuNewTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, True);
end;

procedure TfrmConsults.pnlLeftExit(Sender: TObject);
begin
  inherited;
  if (Not FocusToRightPanel) then
    if ShiftTabIsPressed then
      frmFrame.tabPage.SetFocus
    else if TabIsPressed then
      frmFrame.pnlPatient.SetFocus;

  if FocusToRightPanel then
    FocusToRightPanel := False;
end;

procedure TfrmConsults.pnlLeftResize(Sender: TObject);
begin
  inherited;
  if EditingIndex = -1 then
    pnlConsultList.Height := (pnlLeft.Height div 2)
    //pnlConsultList.Height := 3 * (pnlLeft.Height div 5)
  else
    pnlConsultList.Height := (pnlLeft.Height div 5);
  Self.Invalidate;
end;

procedure TfrmConsults.mnuOptionsClick(Sender: TObject);
begin
  inherited;
  mnuEditTemplates.Enabled := frmDrawers.CanEditTemplates;
  mnuNewTemplate.Enabled := frmDrawers.CanEditTemplates;
  mnuEditSharedTemplates.Enabled := frmDrawers.CanEditShared;
  mnuNewSharedTemplate.Enabled := frmDrawers.CanEditShared;
  mnuEditDialgFields.Enabled := CanEditTemplateFields;
end;

procedure TfrmConsults.mnuEditSharedTemplatesClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, FALSE, '', TRUE);
end;

procedure TfrmConsults.mnuNewSharedTemplateClick(Sender: TObject);
begin
  inherited;
  EditTemplates(Self, TRUE, '', TRUE);
end;

procedure TfrmConsults.mnuActNotePrintClick(Sender: TObject);
var
  Saved: Boolean;
begin
  inherited;
  with lstNotes do
  begin
    if ItemIndex = EditingIndex then
    begin
      SaveCurrentNote(Saved);
      if not Saved then Exit;
    end;
    if ItemIEN > 0 then PrintNote(ItemIEN, MakeConsultNoteDisplayText(Items[ItemIndex])) else
    begin
      if ItemIEN = 0 then InfoBox(TX_NONOTE, TX_NONOTE_CAP, MB_OK);
      if ItemIEN < 0 then InfoBox(TX_NOPRT_NEW, TX_NOPRT_NEW_CAP, MB_OK);
    end;
  end;
end;

procedure TfrmConsults.popNoteMemoPrintClick(Sender: TObject);
begin
  inherited;
  mnuActNotePrintClick(Self);
end;


//========================== leave these at end of file =============================

(*procedure TfrmConsults.lstNotesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
const
  STD_DATE = 'MMM DD,YY';
begin
  inherited;
	 with (Control as TORListBox).Canvas do  { draw on control canvas, not on the form }
    begin
      FImageFlag.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_1');
      x := (Control as TORListBox).Items[Index];
      (Control as TORListBox).ItemHeight := HigherOf(TextHeight(x), FImageFlag.Height);
      FillRect(Rect);       { clear the rectangle }
      if StrToIntDef(Piece(x, U, 7), 0) > 0 then
        begin
          if StrToIntDef(Piece(x, U, 7), 0) = 1 then
            FImageFlag.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_1')
          else if StrToIntDef(Piece(x, U, 7), 0) = 2 then
            FImageFlag.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_2')
          else if StrToIntDef(Piece(x, U, 7), 0) > 2 then
            FImageFlag.LoadFromResourceName(hInstance, 'BMP_IMAGEFLAG_3');
          BrushCopy(Bounds(Rect.Left, Rect.Top, FImageFlag.Width, FImageFlag.Height),
            FImageFlag, Bounds(0, 0, FImageFlag.Width, FImageFlag.Height), clRed); {render ImageFlag}
        end;
      TextOut(Rect.Left + FImageFlag.Width, Rect.Top, Piece(x, U, 2));
      TextOut(Rect.Left + FImageFlag.Width + TextWidth(STD_DATE), Rect.Top, Piece(x, U, 3));
    end;
end;
*)
procedure TfrmConsults.FormDestroy(Sender: TObject);
begin
  FDocList.Free;
  FCsltList.Free;
  FImageFlag.Free;
  KillDocTreeObjects(tvCsltNotes);
  inherited;
end;

function TfrmConsults.GetDrawers: TFrmDrawers;
begin
  Result := frmDrawers;
end;

function TfrmConsults.LockConsultRequest(AConsult: Integer): Boolean;
{ returns true if consult successfully locked }
begin
  // *** I'm not sure about the FOrderID field - if the user is editing one note and
  //     deletes another, FOrderID will be for editing note, then delete note, then null
  Result := True;
  FOrderID := GetConsultOrderIEN(AConsult);
  if frmNotes.ActiveEditOf(0, AConsult) then
    begin
      InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
      Result := False;
      FOrderID := '';
      Exit;
    end;
(*  if (FOrderID <> '') and (FOrderID = frmNotes.OrderID) then
  begin
    InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
    Result := False;
    FOrderID := '';
    Exit;
  end;*)
  if (FOrderId <> '') then
    if not OrderCanBeLocked(FOrderID) then Result := False;
  if not Result then FOrderID := '';
end;

function TfrmConsults.LockConsultRequestAndNote(AnIEN: Int64): Boolean;
{ returns true if note and associated request successfully locked }
var
  AConsult: Integer;
  LockMsg, x: string;
begin
  Result := True;
  AConsult := 0;
  if frmNotes.ActiveEditOf(AnIEN, lstConsults.ItemIEN) then
    begin
      InfoBox(TX_ORDER_LOCKED, TC_ORDER_LOCKED, MB_OK);
      Result := False;
      Exit;
    end;
  if Changes.Exist(CH_CON, IntToStr(AnIEN)) then Exit;  // already locked
  // try to lock the consult request first, if there is one
  if IsConsultTitle(TitleForNote(AnIEN)) then
  begin
    x := GetPackageRefForNote(lstNotes.ItemIEN);
    AConsult := StrToIntDef(Piece(x, ';', 1), 0);
    //AConsult := GetConsultIENforNote(lstNotes.ItemIEN);
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
  if not Result then FOrderID := '';
end;

procedure TfrmConsults.UnlockConsultRequest(ANote: Int64; AConsult: Integer = 0);
(*var
  x: string;*)
begin
(*  if (AConsult = 0) then
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

function TfrmConsults.ActiveEditOf(AnIEN: Int64): Boolean;
var
  ARequest: integer;
  x: string;
begin
  Result := False;
  if (lstNotes.ItemIEN = AnIEN) and (lstNotes.ItemIndex = EditingIndex) then
    begin
      Result := True;
      Exit;
    end;
  x := GetPackageRefForNote(AnIEN);
  ARequest := StrToIntDef(Piece(x, ';', 1), 0);
  //ARequest := GetConsultIENForNote(AnIEN);
  if (lstConsults.ItemIEN = ARequest) and (EditingIndex > -1) then Result := True;
end;

function TfrmConsults.StartNewEdit(NewNoteType: integer): Boolean;
{ if currently editing a note, returns TRUE if the user wants to start a new one }
var
  Saved: Boolean;
  AConsultID, ANoteID: string;
  Msg, CapMsg: string;
begin
  AConsultID := lstConsults.ItemID;
  ANoteID := lstNotes.ItemID;
  Result := True;
  if EditingIndex > -1 then
  begin
    case NewNoteType of
      NT_ACT_ADDENDUM:  begin
                          Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE3;
                          CapMsg := TC_NEW_SAVE3;
                        end;
      NT_ACT_EDIT_NOTE: begin
                          Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE4;
                          CapMsg := TC_NEW_SAVE4;
                        end;
      NT_ACT_ID_ENTRY:  begin
                          Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(lstNotes.Items[EditingIndex]) + TX_NEW_SAVE5;
                          CapMsg := TC_NEW_SAVE5;
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
        if not Saved then Result := False
        else
          begin
            with tvConsults do Selected := FindPieceNode(AConsultID, 1, U, Items.GetFirstNode);
            tvConsultsClick(Self);
            with tvCsltNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
          end;
      end;
  end else
    //notes section
    if frmNotes.EditingIndex > -1 then
    begin
      case NewNoteType of
        NT_ACT_ADDENDUM: begin
            Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(frmNotes.lstNotes.Items
              [frmNotes.EditingIndex]) + TX_NEW_SAVE3;
            CapMsg := TC_NEW_SAVE3;
          end;
        NT_ACT_EDIT_NOTE: begin
            Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(frmNotes.lstNotes.Items
              [frmNotes.EditingIndex]) + TX_NEW_SAVE4;
            CapMsg := TC_NEW_SAVE4;
          end;
        NT_ACT_ID_ENTRY: begin
            Msg := TX_NEW_SAVE1 + MakeConsultNoteDisplayText(frmNotes.lstNotes.Items
              [frmNotes.EditingIndex]) + TX_NEW_SAVE5;
            CapMsg := TC_NEW_SAVE5;
          end;
      else
        begin
          Msg := TX_NEW_SAVE1 + MakeNoteDisplayText(frmNotes.lstNotes.Items
            [frmNotes.EditingIndex]) + TX_NEW_SAVE2;
          CapMsg := TC_NEW_SAVE2;
        end;
      end;
      if InfoBox(Msg, CapMsg, MB_YESNO) = IDNO then Result := False
      else
      begin
        frmNotes.SaveCurrentNote(Saved);
        if not Saved then Result := False
        else
        begin
          with tvConsults do Selected := FindPieceNode(AConsultID, 1, U, Items.GetFirstNode);
          tvConsultsClick(Self);
          with tvCsltNotes do Selected := FindPieceNode(ANoteID, 1, U, Items.GetFirstNode);
        end;
      end;
    end;
end;

function TfrmConsults.LacksRequiredForCreate: Boolean;
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
    if MenuAccessRec.IsClinicalProcedure then
      begin
        if (IsClinProcTitle(Title) and (PkgIEN = 0)) then Result := True;
        //if (IsClinProcTitle(Title) and (Consult = 0)) then Result := True;
      end
    else
      if (IsConsultTitle(Title) and (PkgIEN = 0)) then Result := True;
      //if (IsConsultTitle(Title) and (Consult = 0)) then Result := True;
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

function TfrmConsults.LacksClinProcFields(AnEditRec: TEditNoteRec; AMenuAccessRec: TMenuAccessRec; var ErrMsg: string): boolean;
begin
  Result := False;
  if not AMenuAccessRec.IsClinicalProcedure then exit;
  with AnEditRec do
    begin
      if Author <= 0 then
        begin
          Result := True;
          ErrMsg := TX_NO_AUTHOR;
        end;
      if AskCosignerForTitle(Title, Author, DateTime) and (Cosigner = 0) then
        begin
          Result := True;
          ErrMsg := ErrMsg + CRLF + TX_REQ_COSIGNER;
        end;
      if (DocType <> TYP_ADDENDUM) and (AMenuAccessRec.ClinProcFlag = CP_INSTR_INCOMPLETE) then
        begin
          if (ClinProcSummCode = 0) or (ClinProcDateTime <= 0) then
            begin
              Result := True;
              ErrMsg := ErrMsg + CRLF + TX_CLIN_PROC;
            end;
        end;
    end;
end;

function TfrmConsults.LacksClinProcFieldsForSignature(NoteIEN: int64; var ErrMsg: string): boolean;
var
  CsltIEN: integer;
  CsltActionRec: TMenuAccessRec;
  SignRec: TEditNoteRec;
begin
  Result := False;
  CsltIEN := GetConsultIENForNote(NoteIEN);
  if CsltIEN <= 0 then exit;
  CsltActionRec := GetActionMenuLevel(CsltIEN);
  if not CsltActionRec.IsClinicalProcedure then exit;
  if not IsClinProcTitle(TitleForNote(NoteIEN)) then exit;
  SignRec := GetSavedCPFields(NoteIEN);
  Result := LacksClinProcFields(SignRec, CsltActionRec, ErrMsg);
end;

function TfrmConsults.GetTitleText(AnIndex: Integer): string;
{ returns non-tabbed text for the title of a note given the ItemIndex in lstNotes }
var
  x: string;
begin
  with lstNotes do
    x := MakeConsultNoteDisplayText(Items[AnIndex]);
(*    x := FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(Items[AnIndex], U, 3))) +
              ' ' + Piece(Items[AnIndex], U, 2);*)
  Result := x;
end;

(*function TfrmConsults.MakeTitleText(IsAddendum: Boolean = False): string;
{ returns display text for list box based on FEditNote }
begin
  Result := FormatFMDateTime('mmm dd,yy', FEditNote.DateTime) + U;
  if IsAddendum and (CompareText(Copy(FEditNote.TitleName, 1, 8), 'Addendum') <> 0)
    then Result := Result + 'Addendum to ';
  Result := Result + FEditNote.TitleName + ', ' + FEditNote.LocationName + ', ' +
            FEditNote.AuthorName;
end;*)

function TfrmConsults.VerifyNoteTitle: Boolean;
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

procedure TfrmConsults.SetSubjectVisible(ShouldShow: Boolean);
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


procedure TfrmConsults.timAutoSaveTimer(Sender: TObject);
begin
  inherited;
  DoAutoSave;
end;

procedure TfrmConsults.DoAutoSave(Suppress: integer = 1);
var
  ErrMsg: string;
begin
  if fFrame.frmFrame.DLLActive = True then Exit;  
  if (EditingIndex > -1) and FChanged then
  begin
    StatusText('Autosaving note...');
    //PutTextOnly(ErrMsg, memResults.Lines, lstNotes.GetIEN(EditingIndex));
    timAutoSave.Enabled := False;
    try
      SetText(ErrMsg, memResults.Lines, lstNotes.GetIEN(EditingIndex), Suppress);
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

procedure TfrmConsults.DoLeftPanelCustomShiftTab;
begin
  if ShiftTabIsPressed then begin
    FocusToRightPanel := True;
    FindNextControl(frmFrame.pnlPatient, False, True, False).SetFocus;
  end;
end;

procedure TfrmConsults.cmdChangeClick(Sender: TObject);
var
  LastTitle, LastConsult: Integer;
  (*OKPressed, *)IsIDChild, UseClinProcTitles: Boolean;
  x, AClassName: string;
begin
  inherited;
  FcmdChangeOKPressed := False;
  IsIDChild := uIDNotesActive and (FEditNote.IDParent > 0);
  LastTitle   := FEditNote.Title;
  LastConsult := FEditNote.PkgIEN;
  with MenuAccessRec do
    UseClinProcTitles := ((IsClinicalProcedure) and
                         (ClinProcFlag in [CP_NO_INSTRUMENT, CP_INSTR_INCOMPLETE, CP_INSTR_COMPLETE]));
  if UseClinProcTitles then AClassName := DCL_CLINPROC else AClassName := DCL_CONSULTS;
  if Sender <> Self then
    FcmdChangeOKPressed := ExecuteNoteProperties(FEditNote, CT_CONSULTS, IsIDChild, False, AClassName,
                              MenuAccessRec.ClinProcFlag)
  else FcmdChangeOKPressed := True;
  if not FcmdChangeOKPressed then Exit;
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
    then Changes.ReplaceSignState(CH_CON, lstNotes.ItemID, CH_SIGN_NA)
    else Changes.ReplaceSignState(CH_CON, lstNotes.ItemID, CH_SIGN_YES);
  x := lstNotes.Items[EditingIndex];
  SetPiece(x, U, 2, lblNewTitle.Caption);
  SetPiece(x, U, 3, FloatToStr(FEditNote.DateTime));
  tvCsltNotes.Selected.Text := MakeConsultNoteDisplayText(x);
  TORTreeNode(tvCsltNotes.Selected).StringData := x;
  lstNotes.Items[EditingIndex] := x;
  Changes.ReplaceText(CH_CON, lstNotes.ItemID, GetTitleText(EditingIndex));
  if LastConsult <> FEditNote.PkgIEN then
  //if LastConsult <> FEditNote.Consult then
  begin
    // try to lock the new consult, reset to previous if unable
    if (FEditNote.PkgIEN > 0) and not LockConsultRequest(FEditNote.PkgIEN) then
    //if (FEditNote.Consult > 0) and not LockConsultRequest(FEditNote.Consult) then
    begin
      Infobox(TX_NO_ORD_CHG, TC_NO_ORD_CHG, MB_OK);
      FEditNote.PkgIEN := LastConsult;
      //FEditNote.Consult := LastConsult;
    end else
    begin
      // unlock the previous consult
      if LastConsult > 0 then UnlockOrderIfAble(GetConsultOrderIEN(LastConsult));
      if FEditNote.PkgIEN = 0 then FOrderID := '';
      //if FEditNote.Consult = 0 then FOrderID := '';
    end;
  end;
  if LastTitle <> FEditNote.Title then mnuActLoadBoilerClick(Self);
end;

procedure TfrmConsults.pnlFieldsResize(Sender: TObject);
{ center the reference date on the panel }
begin
  inherited;
  lblRefDate.Left := (pnlFields.Width - lblRefDate.Width) div 2;
  if lblRefDate.Left < (lblNewTitle.Left + lblNewTitle.Width + 6)
    then lblRefDate.Left := (lblNewTitle.Left + lblNewTitle.Width);
end;


procedure TfrmConsults.AssignRemForm;
begin
  with RemForm do
  begin
    Form := Self;
    PCEObj := uPCEEdit;
    RightPanel := pnlRight;
    CanFinishProc := CanFinishReminder;
    DisplayPCEProc := DisplayPCE;

    DrawerReminderTV := Drawers.tvReminders;
    DrawerReminderTreeChange := Drawers.NotifyWhenRemTreeChanges;
    DrawerRemoveReminderTreeChange := Drawers.RemoveNotifyWhenRemTreeChanges;

    NewNoteRE := memResults;
    NoteList := lstNotes;
  end;
end;

function TfrmConsults.CanFinishReminder: boolean;
begin
  if(EditingIndex < 0) then
    Result := FALSE
  else
    Result := (lstNotes.ItemIndex = EditingIndex);
end;

procedure TfrmConsults.mnuActChangeClick(Sender: TObject);
begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  cmdChangeClick(Sender);
end;

procedure TfrmConsults.mnuActLoadBoilerClick(Sender: TObject);
var
  NoteEmpty: Boolean;
  BoilerText: TStringList;
  DocInfo: string;

  procedure AssignBoilerText;
  begin
    ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
    memResults.Lines.Text := BoilerText.Text;
    SpeakStrings(BoilerText);
    FChanged := False;
  end;

begin
  inherited;
  if (FEditingIndex < 0) or (lstNotes.ItemIndex <> FEditingIndex) then Exit;
  BoilerText := TStringList.Create;
  try
    NoteEmpty := memResults.Text = '';
    LoadBoilerPlate(BoilerText, FEditNote.Title);
    if (BoilerText.Text <> '') or
       assigned(GetLinkedTemplate(IntToStr(FEditNote.Title), ltTitle)) then
    begin
      DocInfo := MakeXMLParamTIU(IntToStr(lstNotes.ItemIEN), FEditNote);
      if NoteEmpty then AssignBoilerText else begin
        case QueryBoilerPlate(BoilerText) of
        0:  { do nothing } ;                         // ignore
        1:  begin // append
              ExecuteTemplateOrBoilerPlate(BoilerText, FEditNote.Title, ltTitle, Self, 'Title: ' + FEditNote.TitleName, DocInfo);
              memResults.Lines.AddStrings(BoilerText);
              SpeakStrings(BoilerText);
            end;
        2:  AssignBoilerText;                         // replace
        end;
      end;
    end else begin
      if Sender = mnuActLoadBoiler
        then InfoBox(TX_NO_BOIL, TC_NO_BOIL, MB_OK)
        else
        begin
          if not NoteEmpty then
            if not FChanged and (InfoBox(TX_BLR_CLEAR, TC_BLR_CLEAR, MB_YESNO) = ID_YES)
              then memResults.Lines.Clear;
        end;
    end; {if BoilerText.Text <> ''}
  finally
    BoilerText.Free;
  end;
end;

procedure TfrmConsults.popNoteMemoSaveContinueClick(Sender: TObject);
begin
  inherited;
  FChanged := True;
  DoAutoSave;
end;

procedure TfrmConsults.ProcessMedResults(ActionType: string);
var
  FormTitle, ErrMsg: string;
  (*i, *)AConsult: integer;
const
  TX_ATTACH = 'Attach Medicine Result to:  ';
  TX_REMOVE = 'Remove Medicine Result from:  ';
  TX_NO_ATTACH_RESULTS   = 'There are no results available to associate with this procedure.';
  TX_NO_REMOVE_RESULTS   = 'There are no medicine results currently associated with this procedure.';
  TC_NO_RESULTS   = 'No Results';
begin
  inherited;
  with lstConsults, MedResult do
    begin
      FillChar(MedResult, SizeOf(MedResult), 0);
      if ItemIEN = 0 then Exit;
      AConsult := ItemIEN;
      if not LockConsultRequest(AConsult) then Exit;
      lstNotes.Enabled := False ;
      pnlConsultList.Enabled := False; //CQ#15785
//      lstConsults.Enabled  := False ;
//      tvConsults.Enabled := False;
      if ActionType = 'ATTACH' then
        begin
          FormTitle := TX_ATTACH + Piece(DisplayText[ItemIndex], #9, 3);
          ErrMsg := TX_NO_ATTACH_RESULTS;
        end
      else if ActionType = 'REMOVE' then
        begin
          FormTitle := TX_REMOVE + Piece(DisplayText[ItemIndex], #9, 3);
          ErrMsg := TX_NO_REMOVE_RESULTS;
        end;
      Action := ActionType;
      if SelectMedicineResult(ItemIEN, FormTitle, MedResult) then
        begin
          if ResultPtr <> '' then
            begin
              if ActionType = 'ATTACH' then
                AttachMedicineResult(ItemIEN, ResultPtr, DateTimeofAction, ResponsiblePerson, AlertsTo.Recipients)
              else if ActionType = 'REMOVE' then
                RemoveMedicineResult(ItemIEN, ResultPtr, DateTimeofAction, ResponsiblePerson);
              UpdateList ;  {update consult list after success}
              ItemIndex := 0 ;
              {ItemIndex may have changed - need to look up by IEN}
              with tvConsults do Selected := FindPieceNode(IntToStr(AConsult), 1, U, Items.GetFirstNode);
              tvConsultsClick(Self);
            end
          else
            InfoBox(ErrMsg, TC_NO_RESULTS, MB_OK or MB_ICONWARNING);
        end;
    end;
  lstNotes.Enabled := True ;
  pnlConsultList.Enabled := True; //CQ#15785
//  lstConsults.Enabled  := True ;
//  tvConsults.Enabled := True;
  FOrderID := GetConsultOrderIEN(AConsult);
  UnlockOrderIfAble(FOrderID);
  FOrderID := '';
end;

procedure TfrmConsults.mnuActAttachMedClick(Sender: TObject);
begin
  inherited;
  ProcessMedResults('ATTACH');
end;

procedure TfrmConsults.mnuActRemoveMedClick(Sender: TObject);
begin
  inherited;
  ProcessMedResults('REMOVE');
end;

procedure TfrmConsults.mnuEditDialgFieldsClick(Sender: TObject);
begin
  inherited;
  EditDialogFields;
end;

procedure TfrmConsults.UpdateNoteTreeView(DocList: TStringList; Tree: TORTreeView; AContext: integer);
var
  ReturnCursor, I: Integer;
begin
  ReturnCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
  with Tree do
    begin
      uChanging := True;
      Items.BeginUpdate;
      for i := 0 to DocList.Count - 1 do
        begin
          if Piece(DocList[i], U, 14) = '0' then continue;       // v16.8 fix  RV
          //if Piece(DocList[i], U, 14) <> IntToStr(AContext) then continue;
          lstNotes.Items.Add(DocList[i]);
        end;
      FCurrentNoteContext.Status := IntToStr(AContext);
      BuildDocumentTree2(DocList, Tree, FCurrentNoteContext, CT_CONSULTS);
      Items.EndUpdate;
      uChanging := False;
    end;
  finally
   Screen.Cursor := ReturnCursor;
  end;
end;

procedure TfrmConsults.tvCsltNotesChange(Sender: TObject; Node: TTreeNode);
var
  x, WhyNot: string;
begin
  if uChanging then Exit;
  //This gives the change a chance to occur when keyboarding, so that WindowEyes
  //doesn't use the old value.
  Application.ProcessMessages;
  with tvCsltNotes do
    begin
      if (Selected = nil) then Exit;
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
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      if (Selected.ImageIndex = IMG_TOP_LEVEL) then
        begin
          pnlResults.Visible := False;
          pnlResults.SendToBack;
          pnlRead.Visible := True;
          pnlRead.BringToFront ;
          memConsult.TabStop := True;
          UpdateReminderFinish;
          ShowPCEControls(False);
          frmDrawers.DisplayDrawers(FALSE);
          cmdPCE.Visible := FALSE;
          popNoteMemoEncounter.Visible := FALSE;
          pnlConsultList.Enabled := True; //CQ#15785
//          lstConsults.Enabled := True ;
//          tvConsults.Enabled := True;
          lstNotes.Enabled := True;
          lblTitle.Caption := '';
          lblTitle.Hint := lblTitle.Caption;
          Exit;
        end;
      x := TORTreeNode(Selected).StringData;
      if StrToIntDef(Piece(Piece(x, U, 1), ';', 1), 0) > 0 then
        begin
          memConsult.Clear;
          lstNotes.SelectByID(Piece(x, U, 1));
          lstNotesClick(Self);
          SendMessage(memConsult.Handle, WM_VSCROLL, SB_TOP, 0);
        end;

     //display orphaned warning
     if PDocTreeObject(Selected.Data)^.Orphaned then
       MessageDlg(ORPHANED_NOTE_TEXT, mtInformation, [mbOK], -1);

    end;
end;

procedure TfrmConsults.tvCsltNotesCollapsed(Sender: TObject; Node: TTreeNode);
begin
  with Node do
    begin
      if (ImageIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_GROUP_OPEN, IMG_IDNOTE_OPEN, IMG_IDPAR_ADDENDA_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmConsults.tvCsltNotesExpanded(Sender: TObject; Node: TTreeNode);

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

procedure TfrmConsults.tvCsltNotesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  AnItem: TORTreeNode;
begin
  Accept := False;
  if not uIDNotesActive then exit;
  AnItem := TORTreeNode(tvCsltNotes.GetNodeAt(X, Y));
  if (AnItem = nil) or (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then Exit;
  with tvCsltNotes.Selected do
    if (ImageIndex in [IMG_SINGLE, IMG_PARENT, IMG_ID_CHILD, IMG_ID_CHILD_ADD]) then
      Accept := (AnItem.ImageIndex in [IMG_SINGLE, IMG_PARENT,
                                       IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT,
                                       IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT])
    else if (ImageIndex in [IMG_IDNOTE_OPEN, IMG_IDNOTE_SHUT, IMG_IDPAR_ADDENDA_OPEN, IMG_IDPAR_ADDENDA_SHUT]) then
      Accept := (AnItem.ImageIndex in [IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL])
    else if (ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) then
      Accept := False;
end;

procedure TfrmConsults.tvCsltNotesDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  HT: THitTests;
  ADestNode: TORTreeNode;
  Saved: boolean;
begin
  if not uIDNotesActive then
    begin
      CancelDrag;
      exit;
    end;
  if tvCsltNotes.Selected = nil then exit;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  HT := tvCsltNotes.GetHitTestInfoAt(X, Y);
  ADestNode := TORTreeNode(tvCsltNotes.GetNodeAt(X, Y));
  DoAttachIDChild(TORTreeNode(tvCsltNotes.Selected), ADestNode);
end;

procedure TfrmConsults.tvCsltNotesStartDrag(Sender: TObject;
  var DragObject: TDragObject);
const
  TX_CAP_NO_DRAG = 'Item cannot be moved';
  var
  WhyNot: string;
  Saved: boolean;
begin
  if (tvCsltNotes.Selected.ImageIndex in [IMG_ADDENDUM, IMG_GROUP_OPEN, IMG_GROUP_SHUT, IMG_TOP_LEVEL]) or
     (not uIDNotesActive) or
     (lstNotes.ItemIEN = 0) then
    begin
      CancelDrag;
      Exit;
    end;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
  end;
  if not CanBeAttached(PDocTreeObject(tvCsltNotes.Selected.Data)^.DocID, WhyNot) then
    begin
      InfoBox(WhyNot, TX_CAP_NO_DRAG, MB_OK);
      CancelDrag;
    end;
end;

procedure TfrmConsults.popNoteListExpandAllClick(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteList) is TTreeView then
    TTreeView(PopupComponent(Sender, popNoteList)).FullExpand;
end;

procedure TfrmConsults.popNoteListCollapseAllClick(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteList) is TTreeView then
    with TTreeView(PopupComponent(Sender, popNoteList)) do
      begin
        Selected := nil;
        FullCollapse;
        Selected := TopItem;
      end;
  lblTitle.Caption := '';
  lblTitle.Hint := lblTitle.Caption;
  memConsult.Clear;
end;

procedure TfrmConsults.popNoteListExpandSelectedClick(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteList) is TTreeView then
    with TTreeView(PopupComponent(Sender, popNoteList)) do
      begin
        if Selected = nil then exit;
        with Selected do if HasChildren then Expand(True);
      end;
end;

procedure TfrmConsults.popNoteListCollapseSelectedClick(Sender: TObject);
begin
  inherited;
  if PopupComponent(Sender, popNoteList) is TTreeView then
    with TTreeView(PopupComponent(Sender, popNoteList)) do
      begin
        if Selected = nil then exit;
        with Selected do if HasChildren then Collapse(True);
      end;
end;

procedure TfrmConsults.EnableDisableIDNotes;
begin
  uIDNotesActive := False;  //IDNotesInstalled;      {not for Consults in v15}
  mnuActDetachFromIDParent.Visible := uIDNotesActive;
  popNoteListDetachFromIDParent.Visible := uIDNotesActive;
  mnuActAddIDEntry.Visible := uIDNotesActive;
  popNoteListAddIDEntry.Visible := uIDNotesActive;
  mnuActAttachtoIDParent.Visible := uIDNotesActive;
  popNoteListAttachtoIDParent.Visible := uIDNotesActive;
  if uIDNotesActive then
    tvCsltNotes.DragMode := dmAutomatic
  else
    tvCsltNotes.DragMode := dmManual;
end;


procedure TfrmConsults.tvCsltNotesClick(Sender: TObject);
begin
  inherited;
  if tvCsltNotes.Selected = nil then exit;
  if (tvCsltNotes.Selected.ImageIndex in [IMG_TOP_LEVEL, IMG_GROUP_OPEN, IMG_GROUP_SHUT]) then
    begin
      lblTitle.Caption := '';
      lblTitle.Hint := lblTitle.Caption;
      memConsult.Clear;
    end;
end;

// =========================== Consults Treeview Code ==================================

procedure TfrmConsults.LoadConsults;
var
  tmpList: TStringList;
  ANode: TTreeNode;
begin
  tmpList := TStringList.Create;
  try

    FCsltList.Clear;
    uChanging := True;
    RedrawSuspend(memConsult.Handle);
    tvConsults.Items.BeginUpdate;
    lstConsults.Items.Clear;
    KillDocTreeObjects(tvConsults);
    tvConsults.Items.Clear;
    tvConsults.Items.EndUpdate;
    tvCsltNotes.Items.BeginUpdate;
    KillDocTreeObjects(tvCsltNotes);
    tvCsltNotes.Items.Clear;
    tvCsltNotes.Items.EndUpdate;
    lstNotes.Clear;
    memConsult.Clear;
    memConsult.Invalidate;
    lblTitle.Caption := '';
    lblTitle.Hint := lblTitle.Caption;
    with FCurrentContext do
      begin
        GetConsultsList(tmpList, StrToFMDateTime(BeginDate), StrToFMDateTime(EndDate), Service, Status, Ascending);
        CreateListItemsforConsultTree(FCsltList, tmpList, ViewContext, GroupBy, Ascending);
        UpdateConsultsTreeView(FCsltList, tvConsults);
        FastAssign(tmpList, lstConsults.Items);
      end;
    with tvConsults do
      begin
        uChanging := True;
        Items.BeginUpdate;
        ANode := Items.GetFirstNode;
        if ANode <> nil then Selected := ANode.getFirstChild;
        memConsult.Clear;
        //RemoveParentsWithNoChildren(tvConsults, FCurrentContext);
        Items.EndUpdate;
        uChanging := False;
        if (Self.Active) and (Selected <> nil) then tvConsultsChange(Self, Selected);
      end;
  finally
    RedrawActivate(memConsult.Handle);
    tmpList.Free;
  end;
end;

procedure TfrmConsults.UpdateConsultsTreeView(DocList: TStringList; Tree: TORTreeView);
begin
  with Tree do
    begin
      uChanging := True;
      Items.BeginUpdate;
      FastAddStrings(DocList, lstConsults.Items);
      BuildConsultsTree(Tree, DocList, '0', nil, FCurrentContext);
      Items.EndUpdate;
      uChanging := False;
    end;
end;

procedure TfrmConsults.tvConsultsExpanded(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  with Node do
    begin
      if (ImageIndex in [IMG_GMRC_GROUP_SHUT]) then
        ImageIndex := ImageIndex + 1;
      if (SelectedIndex in [IMG_GMRC_GROUP_SHUT]) then
        SelectedIndex := SelectedIndex + 1;
    end;
end;

procedure TfrmConsults.tvConsultsCollapsed(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  with Node do
    begin
      if (ImageIndex in [IMG_GMRC_GROUP_OPEN]) then
        ImageIndex := ImageIndex - 1;
      if (SelectedIndex in [IMG_GMRC_GROUP_OPEN]) then
        SelectedIndex := SelectedIndex - 1;
    end;
end;

procedure TfrmConsults.tvConsultsClick(Sender: TObject);
begin
  inherited;
  with tvConsults do
    begin
      if Selected = nil then exit;
      if (Selected.ImageIndex in [IMG_GMRC_TOP_LEVEL, IMG_GMRC_GROUP_OPEN, IMG_GMRC_GROUP_SHUT]) then
        begin
          lblTitle.Caption := '';
          lblTitle.Hint := lblTitle.Caption;
          memConsult.Clear;
          KillDocTreeObjects(tvCsltNotes);
          tvCsltNotes.Items.Clear;
          lstNotes.Items.Clear;
        end
      else
        tvConsultsChange(Self, Selected);
    end;
end;

procedure TfrmConsults.tvConsultsChange(Sender: TObject; Node: TTreeNode);
var
  x: string;
begin
  inherited;
  if uChanging then Exit;
  with tvConsults do
    begin
      if (Selected = nil) then Exit;
      if (tvConsults.Selected.ImageIndex in [IMG_GMRC_TOP_LEVEL, IMG_GMRC_GROUP_OPEN, IMG_GMRC_GROUP_SHUT]) then
        begin
          mnuActConsultRequest.Enabled := False;
          mnuActConsultResults.Enabled := False;
          frmFrame.mnuFilePrint.Enabled := False;
           frmFrame.mnuFilePrintSelectedItems.Enabled := False;
        end
      else
      begin
        frmFrame.mnuFilePrint.Enabled := True;
        frmFrame.mnuFilePrintSelectedItems.Enabled := True;
      end;
      popNoteListExpandSelected.Enabled := Selected.HasChildren;
      popNoteListCollapseSelected.Enabled := Selected.HasChildren;
      pnlConsultList.Enabled := True; //CQ#15785
//      lstConsults.Enabled := True ;
//      tvConsults.Enabled := True;
      lstNotes.Enabled := True;
      if (Selected.ImageIndex in [IMG_GMRC_TOP_LEVEL, IMG_GMRC_GROUP_OPEN, IMG_GMRC_GROUP_SHUT]) then
        begin
          pnlResults.Visible := False;
          pnlResults.SendToBack;
          pnlRead.Visible := True;
          pnlRead.BringToFront ;
          memConsult.TabStop := True;
          UpdateReminderFinish;
          ShowPCEControls(False);
          frmDrawers.DisplayDrawers(FALSE);
          cmdPCE.Visible := FALSE;
          popNoteMemoEncounter.Visible := FALSE;
          pnlConsultList.Enabled := True; //CQ#15785
//          lstConsults.Enabled := True ;
//          tvConsults.Enabled := True;
          KillDocTreeObjects(tvCsltNotes);
          tvCsltNotes.Items.Clear;
          lstNotes.Clear;
          lstNotes.Enabled := True;
          lblTitle.Caption := '';
          lblTitle.Hint := lblTitle.Caption;
          Exit;
        end;
      x := TORTreeNode(Selected).StringData;
      if StrToIntDef(Piece(x, U, 1), 0) > 0 then
        begin
          memConsult.Clear;
          lstConsults.SelectByID(Piece(x, U, 1));
          lstConsultsClick(Self);
          //tvConsults.SetFocus;
          SendMessage(memConsult.Handle, WM_VSCROLL, SB_TOP, 0);
        end;
    end;
end;

procedure TfrmConsults.popNoteListPopup(Sender: TObject);
var
  ShowIt: boolean;
begin
  inherited;
  ShowIt := uIDNotesActive and (PopupComponent(Sender, popNoteList) = tvCsltNotes);
  popNoteListDetachFromIDParent.Visible := ShowIt;
  popNoteListAddIDEntry.Visible         := ShowIt;
end;

procedure TfrmConsults.mnuIconLegendClick(Sender: TObject);
begin
  inherited;
  ShowIconLegend(ilConsults);
end;

procedure TfrmConsults.mnuActAttachtoIDParentClick(Sender: TObject);
var
  AChildNode: TORTreeNode;
  AParentID: string;
  Saved: boolean;
  SavedDocID, SavedConsultID: string;
begin
  if lstNotes.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    with tvConsults do Selected := FindPieceNode(SavedConsultID, 1, U, Items.GetFirstNode);
    tvConsultsClick(Self);
    with tvCsltNotes do Selected := FindPieceNode(SavedDocID, 1, U, Items.GetFirstNode);
  end;
  if tvCsltNotes.Selected = nil then exit;
  AChildNode := TORTreeNode(tvCsltNotes.Selected);
  AParentID := SelectParentNodeFromList(tvCsltNotes);
  if AParentID = '' then exit;
  with tvCsltNotes do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
  DoAttachIDChild(AChildNode, TORTreeNode(tvCsltNotes.Selected));
end;

procedure TfrmConsults.DoAttachIDChild(AChild, AParent: TORTreeNode);
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
              tvConsultsChange(Self, tvConsults.Selected);
              with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
              if tvCsltNotes.Selected <> nil then tvCsltNotes.Selected.Expand(False);
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
          tvConsultsChange(Self, tvConsults.Selected);
          with tvCsltNotes do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
          if tvCsltNotes.Selected <> nil then tvCsltNotes.Selected.Expand(False);
        end
      else
        InfoBox(WhyNot, TX_ATTACH_FAILURE, MB_OK);
   end;
end;

procedure TfrmConsults.tvConsultsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key in [VK_UP, VK_DOWN] then tvConsultsChange(Self, tvConsults.Selected);
end;

function TfrmConsults.UserIsSigner(NoteIEN: integer): boolean;
var
  Signers: TStringList;
  i: integer;
begin
  Result := False;
  if NoteIEN <= 0 then exit;
  Signers := TStringList.Create;
  try
    FastAssign(GetCurrentSigners(NoteIEN), Signers);
    for i := 0 to Signers.Count - 1 do
      if Piece(Signers[i], U, 1) = IntToStr(User.DUZ) then
        begin
          Result := True;
          break;
        end;
  finally
    Signers.Free;
  end;
end;

procedure TfrmConsults.memResultsKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmConsults.sptHorzCanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
begin
  inherited;
  if pnlResults.Visible then
     if NewSize > frmConsults.ClientWidth - memResults.Constraints.MinWidth - sptHorz.Width then
        NewSize := frmConsults.ClientWidth - memResults.Constraints.MinWidth - sptHorz.Width;
end;

procedure TfrmConsults.popNoteMemoPreviewClick(Sender: TObject);
begin
  frmDrawers.mnuPreviewTemplateClick(Sender);
end;

procedure TfrmConsults.popNoteMemoInsTemplateClick(Sender: TObject);
begin
  inherited;
  frmDrawers.mnuInsertTemplateClick(Sender);
end;

procedure TfrmConsults.lstConsultsToPrint;      
var
  AParentID: string;
  SavedDocID: string;
  Saved: boolean;
begin
  inherited;
  if lstConsults.ItemIEN = 0 then exit;
  SavedDocID := lstNotes.ItemID;
  if EditingIndex <> -1 then
  begin
    SaveCurrentNote(Saved);
    if not Saved then Exit;
    LoadConsults;
    with tvConsults do Selected := FindPieceNode(SavedDocID, U, Items.GetFirstNode);
  end;
  if tvConsults.Selected = nil then exit;
  AParentID := frmPrintList.SelectParentFromList(tvConsults,CT_CONSULTS);
  if AParentID = '' then exit;
  with tvConsults do Selected := FindPieceNode(AParentID, 1, U, Items.GetFirstNode);
end;

procedure TfrmConsults.tvConsultsExit(Sender: TObject);
begin
  inherited;
  FocusToRightPanel := True;
  if TabIsPressed then
    FindNextControl(pnlLeft, False, True, False).SetFocus;
end;

procedure TfrmConsults.frmFramePnlPatientExit(Sender: TObject);
begin
  FOldFramePnlPatientExit(Sender);
  if ShiftTabIsPressed then
    FindNextControl( pnlRight, False, True, False).SetFocus;
end;

procedure TfrmConsults.FormHide(Sender: TObject);
begin
  inherited;
  frmFrame.pnlPatient.OnExit := FOldFramePnlPatientExit;
end;

procedure TfrmConsults.FormShow(Sender: TObject);
var
  i : integer;
begin
  inherited;
  FOldFramePnlPatientExit := frmFrame.pnlPatient.OnExit;
  frmFrame.pnlPatient.OnExit := frmFramePnlPatientExit;
  {Below is a fix for ClearQuest Defect HDS0000948, Kind of Kloogy I looked
  and looked for side effects and a better solution and this was the best!}
  if (EditingIndex = -1) or (lstNotes.ItemIndex <> EditingIndex) then
    frmDrawers.Hide;
  {This TStaticText I am looking for doesn't have a Name! So
   I have to loop through the panel's controls and disable the TStaticText.}
  with pnlAction do begin
    for i := 0 to (ControlCount -1) do
    begin
      if Controls[i] is TStaticText then
        if (Controls[i] as TStaticText).Caption = 'Consult Notes' then
          (Controls[i] as TStaticText).Enabled := False;
    end;
  end
  {End of ClearQuest Defect HDS0000948 Fixes}
end;

procedure TfrmConsults.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmConsults.mnuViewInformationClick(Sender: TObject);
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
  SpecifyFormIsNotADialog(TfrmConsults);
  uPCEEdit := TPCEData.Create;
  uPCEShow := TPCEData.Create;

finalization
  uPCEEdit.Free;
  uPCEShow.Free;

end.

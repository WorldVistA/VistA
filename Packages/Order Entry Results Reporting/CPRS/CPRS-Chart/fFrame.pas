unit fFrame;
{ This is the main form for the CPRS GUI.  It provides a patient-encounter-user framework
  which all the other forms of the GUI use. }

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED
{$WARN SYMBOL_PLATFORM OFF}
{$DEFINE CCOWBROKER}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Tabs, ComCtrls,
  ExtCtrls, Menus, StdCtrls, Buttons, ORFn, fPage, uConst, ORCtrls, Trpcb, Contnrs,
  OleCtrls, VERGENCECONTEXTORLib_TLB, ComObj, AppEvnts, fBase508Form, oPKIEncryption,
  VA508AccessibilityManager, RichEdit, fDebugReport, StrUtils, vcl.ActnList,
  System.SyncObjs, U_CPTAppMonitor, ORNetIntf, system.JSON, Vcl.ExtDlgs, System.Actions,
  fPDMPMgr, uPDMP, uHelpManager, u508Button;

type
  TfrmFrame = class(TfrmBase508Form)
    pnlToolbar: TPanel;
    stsArea: TStatusBar;
    tabPage: TTabControl;
    pnlPage: TPanel;
    bvlPageTop: TBevel;
    bvlToolTop: TBevel;
    pnlPatient: TKeyClickPanel;
    lblPtName: TStaticText;
    lblPtInfo: TStaticText;
    pnlVisit: TKeyClickPanel;
    lblPtLocation: TStaticText;
    lblPtProvider: TStaticText;
    mnuFrame: TMainMenu;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuFileReview: TMenuItem;
    Z1: TMenuItem;
    mnuFilePrint: TMenuItem;
    mnuEdit: TMenuItem;
    mnuEditUndo: TMenuItem;
    Z3: TMenuItem;
    mnuEditCut: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditPaste: TMenuItem;
    Z4: TMenuItem;
    mnuEditPref: TMenuItem;
    Prefs1: TMenuItem;
    mnu14pt1: TMenuItem;
    mnu12pt1: TMenuItem;
    mnu10pt1: TMenuItem;
    mnu8pt: TMenuItem;
    mnuHelp: TMenuItem;
    mnuHelpContents: TMenuItem;
    mnuHelpTutor: TMenuItem;
    mnuDebugReport: TMenuItem;
    Z5: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuTools: TMenuItem;
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
    mnuHelpBroker: TMenuItem;
    mnuFileEncounter: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewPostings: TMenuItem;
    mnuHelpLists: TMenuItem;
    Z6: TMenuItem;
    mnuHelpSymbols: TMenuItem;
    mnuFileNext: TMenuItem;
    Z7: TMenuItem;
    mnuFileRefresh: TMenuItem;
    pnlPrimaryCare: TKeyClickPanel;
    lblPtCare: TStaticText;
    lblPtAttending: TStaticText;
    pnlReminders: TKeyClickPanel;
    imgReminder: TImage;
    mnuViewReminders: TMenuItem;
    anmtRemSearch: TAnimate;
    lstCIRNLocations: TORListBox;
    popCIRN: TPopupMenu;
    popCIRNSelectAll: TMenuItem;
    popCIRNSelectNone: TMenuItem;
    popCIRNClose: TMenuItem;
    mnuFilePrintSetup: TMenuItem;
    LabInfo1: TMenuItem;
    mnuFileNotifRemove: TMenuItem;
    Z8: TMenuItem;
    mnuToolsOptions: TMenuItem;
    mnuChartSurgery: TMenuItem;
    OROpenDlg: TOpenDialog;
    mnuFileResumeContext: TMenuItem;
    mnuFileResumeContextSet: TMenuItem;
    Useexistingcontext1: TMenuItem;
    mnuFileBreakContext: TMenuItem;
    pnlCCOW: TPanel;
    imgCCOW: TImage;
    pnlPatientSelected: TPanel;
    pnlNoPatientSelected: TPanel;
    pnlPostings: TKeyClickPanel;
    lblPtPostings: TStaticText;
    lblPtCWAD: TStaticText;
    mnuFilePrintSelectedItems: TMenuItem;
    popAlerts: TPopupMenu;
    mnuAlertContinue: TMenuItem;
    mnuAlertForward: TMenuItem;
    mnuAlertRenew: TMenuItem;
    AppEvents: TApplicationEvents;
    paVAA: TKeyClickPanel;
    mnuToolsGraphing: TMenuItem;
    laVAA2: u508Button.TButton;
    laMHV: u508Button.TButton;
    mnuViewInformation: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    compAccessTabPage: TVA508ComponentAccessibility;
    pnlCVnFlag: TPanel;
    btnCombatVet: TButton;
    pnlFlag: TKeyClickPanel;
    lblFlag: TLabel;
    pnlRemoteData: TKeyClickPanel;
    pnlVistaWeb: TKeyClickPanel;
    lblVistaWeb: TLabel;
    pnlCIRN: TKeyClickPanel;
    lblCIRN: TLabel;
    mnuEditRedo: TMenuItem;
    lblPtMHTC: TStaticText;
    DigitalSigningSetup1: TMenuItem;
    mnuFocusChanges: TMenuItem;
    txtCmdFlags: TVA508StaticText;
    mnuFileViewNotifications: TMenuItem;
    CPAppMon: TCopyApplicationMonitor;
    pnlOTHD: TKeyClickPanel;
    lblOTHDDtl: TStaticText;  // rpk 11/28/2017
    lblOTHDTitle: TStaticText;
    alPdmp: TActionList;
    N1: TMenuItem;
    acPDMPRequest: TAction;
    acPDMPReview: TAction;
    acPDMPCancel: TAction;
    RequestPDMPData1: TMenuItem;
    CancelPDMPRequest1: TMenuItem;
    ReviewPDMPData1: TMenuItem;
    PDMP1: TMenuItem;
    acPDMPOptions: TAction;
    acResetParams: TAction;
    ResetParams1: TMenuItem;  // rpk 11/28/2017
    pnlOtherInfo: TKeyClickPanel;
    N2: TMenuItem;
    mnuWAPermissions: TMenuItem;
    mnuShowActivityLog: TMenuItem;
    procedure tabPageChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pnlPatientMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPatientMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlVisitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlVisitMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuFileExitClick(Sender: TObject);
    procedure pnlPostingsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlPostingsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuFontSizeClick(Sender: TObject);
    procedure mnuChartTabClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuHelpBrokerClick(Sender: TObject);
    procedure mnuFileEncounterClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuFileReviewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuHelpListsClick(Sender: TObject);
    procedure ToolClick(Sender: TObject);
    procedure mnuEditClick(Sender: TObject);
    procedure mnuEditUndoClick(Sender: TObject);
    procedure mnuEditCutClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditPasteClick(Sender: TObject);
    procedure mnuHelpSymbolsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuGECStatusClick(Sender: TObject);
    procedure mnuFileNextClick(Sender: TObject);
    procedure pnlPrimaryCareMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlPrimaryCareMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlRemindersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlRemindersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlCIRNClick(Sender: TObject);
    procedure lstCIRNLocationsClick(Sender: TObject);
    procedure popCIRNCloseClick(Sender: TObject);
    procedure popCIRNSelectAllClick(Sender: TObject);
    procedure popCIRNSelectNoneClick(Sender: TObject);
    procedure mnuFilePrintSetupClick(Sender: TObject);
    procedure LabInfo1Click(Sender: TObject);
    procedure mnuFileNotifRemoveClick(Sender: TObject);
    procedure mnuToolsOptionsClick(Sender: TObject);
    procedure mnuFileRefreshClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure pnlPrimaryCareEnter(Sender: TObject);
    procedure pnlPrimaryCareExit(Sender: TObject);
    procedure pnlPatientClick(Sender: TObject);
    procedure pnlVisitClick(Sender: TObject);
    procedure pnlPrimaryCareClick(Sender: TObject);
    procedure pnlRemindersClick(Sender: TObject);
    procedure pnlPostingsClick(Sender: TObject);
    procedure ctxContextorCanceled(Sender: TObject);
    procedure ctxContextorCommitted(Sender: TObject);
    procedure ctxContextorPending(Sender: TObject;
      const aContextItemCollection: IDispatch);
    procedure mnuDebugReportClick(Sender: TObject);
    procedure mnuFileBreakContextClick(Sender: TObject);
    procedure mnuFileResumeContextGetClick(Sender: TObject);
    procedure mnuFileResumeContextSetClick(Sender: TObject);
    procedure pnlFlagMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlFlagMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlFlagClick(Sender: TObject);
    procedure mnuFilePrintSelectedItemsClick(Sender: TObject);
    procedure mnuAlertRenewClick(Sender: TObject);
    procedure mnuAlertForwardClick(Sender: TObject);
    procedure pnlFlagEnter(Sender: TObject);
    procedure pnlFlagExit(Sender: TObject);
    procedure tabPageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstCIRNLocationsExit(Sender: TObject);
    procedure AppEventsActivate(Sender: TObject);
    procedure ScreenActiveFormChange(Sender: TObject);
    procedure AppEventsShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure mnuToolsGraphingClick(Sender: TObject);
    procedure pnlCIRNMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlCIRNMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure laMHVClick(Sender: TObject);
    procedure laVAA2Click(Sender: TObject);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure compAccessTabPageCaptionQuery(Sender: TObject;
      var Text: string);
    procedure btnCombatVetClick(Sender: TObject);
    procedure pnlVistaWebClick(Sender: TObject);
    procedure pnlVistaWebMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlVistaWebMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnuEditRedoClick(Sender: TObject);
    procedure tabPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DigitalSigningSetup1Click(Sender: TObject);
    procedure mnuFocusChangesClick(Sender: TObject);
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure mnuFileViewNotificationsClick(Sender: TObject);
    procedure paVAAResize(Sender: TObject);
    procedure LoadBuffer(Sender: TObject; LoadList: TStrings; var ProcessLoad: Boolean);
    procedure LoadProperties(Sender: TObject);
    procedure SaveBuffer(Sender: TObject; SaveList: TStringList; var ReturnList: TStringList);
    procedure StartPollBuff(Sender: TObject; var Error: Boolean);
    procedure StopPollBuff(Sender: TObject; var Error: Boolean);
    procedure pnlOTHDEnter(Sender: TObject); // rpk 1/5/2018
    procedure pnlOTHDExit(Sender: TObject);  // rpk 1/5/2018
    procedure pnlOTHDClick(Sender: TObject);  // rpk 1/5/2018
    procedure pnlOTHDMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlOTHDMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acPDMPRequestExecute(Sender: TObject);
    procedure acPDMPReviewExecute(Sender: TObject);
    procedure acPDMPCancelExecute(Sender: TObject);
    procedure acResetParamsExecute(Sender: TObject);
    procedure pnlOtherInfoClick(Sender: TObject);
    procedure pnlOtherInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlOtherInfoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure mnuWAPermissionsClick(Sender: TObject);
    procedure mnuShowActivityLogClick(Sender: TObject);
  private
    FProccessingNextClick : boolean;
    FJustEnteredApp : boolean;
    FCCOWInstalled: boolean;
    FCCOWContextChanging: boolean;
    FCCOWIconName: string;
    FCCOWDrivedChange: boolean;
    FCCOWBusy: boolean;
    FCCOWError: boolean;
//    FCCOWJustJoined: boolean;
    FNoPatientSelected: boolean;
    FRefreshing: boolean;
    FClosing: boolean;
    FContextChanging: Boolean;
    FChangeSource: Integer;
    FCreateProgress: Integer;
    FEditCtrl: TCustomEdit;
    FLastPage: TForm;
    FNextButtonL: Integer;
    FNextButtonR: Integer;
    FNextButtonActive: Boolean;
    FNextButtonBitmap: TBitmap;
    FNextButton: TBitBtn;
    FTerminate: Boolean;
    FTabChanged: TNotifyEvent;
    FOldActivate: TNotifyEvent;
    FOldActiveFormChange: TNotifyEvent;
    FECSAuthUser: Boolean;
    FFixedStatusWidth: integer;
    FPrevInPatient: Boolean;
    FFirstLoad:    Boolean;
    FPrevPtID: string;
    FGraphFloatActive: boolean;
    FGraphContext: string;
    FDoNotChangeEncWindow: boolean;
    FOrderPrintForm: boolean;
    FReviewclick: boolean;
    FCtrlTabUsed: boolean;
    fPDMPMgr: TfrmPDMP;
    fotherPanelUseColor: boolean;
    fotherPanelType: string;
    fotherPanelShowReportBox: boolean;
    FCPRSClosing: boolean;
    FInitCPRSClose: boolean;
    FForceCloseTimer: TTimer;
    FPatientInfoCaption: String;
    FRPCExceptionLogSize: integer;
    procedure RefreshFixedStatusWidth;
    procedure FocusApplicationTopForm;
    procedure AppActivated(Sender: TObject);
    procedure AppDeActivated(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure AfterAppException(Sender: TObject; E: Exception);
    procedure CPRSExceptionDetails(var CustomDetails: TStringList);
    function checkOtherForms(var Reason: String): boolean;
    function AllowContextChangeAll(var Reason: string):  Boolean;
    procedure ClearPatient(Fully: boolean = False);
    procedure ChangeFont(NewFontSize: Integer);
    procedure CreateTab(ATabID: integer; ALabel: string);
    procedure DetermineNextTab;
    function ExpandCommand(x: string): string;
    procedure FitToolbar;
    procedure LoadSizesForUser;
    procedure SaveSizesForUser;
    procedure LoadUserPreferences;
    procedure SaveUserPreferences;
    procedure SwitchToPage(NewForm: TForm);
    function TabToPageID(Tab: Integer): Integer;
    function TimeoutCondition: boolean;
    function GetTimedOut: boolean;
    procedure TimeOutAction;
    procedure SetUserTools;
    procedure SetDebugMenu;
    procedure SetupPatient(AFlaggedList : TStringList = nil);
    procedure ReportsOnlyDisplay;
    procedure setOtherInfoPanel;
    procedure UMInitiate(var Message: TMessage);   message UM_INITIATE;
    procedure UMNewOrder(var Message: TMessage);   message UM_NEWORDER;
    procedure UMReminders(var Message: TMessage);  message UM_REMINDERS;
    procedure UMStatusText(var Message: TMessage); message UM_STATUSTEXT;
    procedure UMShowPage(var Message: TMessage);   message UM_SHOWPAGE;
    procedure WMSetFocus(var Message: TMessage);   message WM_SETFOCUS;
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure UMPAPI(var Message: TMessage); message UM_PAPI; // PaPI Test
    procedure WMMove(var Msg: TMessage); message WM_MOVE;
    procedure UMNOTELIMIT(var Message: TMessage);  message UM_NOTELIMIT;
    procedure UMEnableNext(var Message: TMessage);   message UM_ENABLENEXT;

    procedure UMPdmpLoading(var Message: TMessage); message UM_PDMP_Loading;
    procedure UMPdmpDone(var Message: TMessage); message UM_PDMP_Done;
    procedure UMPdmpReady(var Message: TMessage); message UM_PDMP_Ready;
    procedure UMPdmpError(var Message: TMessage); message UM_PDMP_Error;
    procedure UMPdmpNoteID(var Message: TMessage); message UM_PDMP_NOTE_ID;
    procedure UMPdmpAbort(var Message: TMessage); message UM_PDMP_ABORT;
    procedure UMPdmpReviewed(var Message: TMessage); message UM_PDMP_Reviewed;
    procedure UMPdmpDisable(var Message: TMessage); message UM_PDMP_Disable;
    procedure UMPdmpEnable(var Message: TMessage); message UM_PDMP_Enable;
    procedure UMTimeout(var Message: TMessage); message UM_TIMEOUT;
    procedure pdmpSetup(aPatientDFN:String = '');
    procedure pdmpAlign;

    procedure UpdateECSParameter(var CmdParameter: string);
    function  ValidECSUser: boolean;
    procedure StartCCOWContextor;
    function  AllowCCOWContextChange(var CCOWResponse: UserResponse; NewDFN: string): boolean;
    procedure UpdateCCOWContext;
    procedure CheckHyperlinkResponse(aContextItemCollection: IDispatch; var HyperlinkReason: string);
    procedure CheckForDifferentPatient(aContextItemCollection: IDispatch; var PtChanged: boolean);
{$IFDEF CCOWBROKER}
    procedure CheckForDifferentUser(aContextItemCollection: IDispatch; var UserChanged: boolean);
{$ENDIF}
    procedure HideEverything(AMessage: string = 'No patient is currently selected.');
    procedure ShowEverything;
    function FindBestCCOWDFN: string;
    procedure HandleCCOWError(AMessage: string);
    procedure SetUpNextButton;
    procedure NextButtonClick(Sender: TObject);
    procedure NextButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Procedure GetExcludedFromMixed();

    procedure setOTHD(aTitle,aDetails:String);
    procedure ClearOTHD;
    procedure updateOTHD;
    procedure ForceCloseTimer(Sender: TObject);
    function GetPatientInfoLabelDisplay: string;
  public
    EnduringPtSelSplitterPos, frmFrameHeight, pnlPatientSelectedHeight: integer;
    EnduringPtSelColumns: string;
    procedure SetBADxList;
    procedure SetActiveTab(PageID: Integer);
    procedure RefreshCWAD(Sender: TObject); // TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 11-20-2015
    procedure RemindersChanged(Sender: TObject);
    procedure UpdateVAAMHVButtons(Sender: TObject); // TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 01-02-2016
    function PageIDToTab(PageID: Integer): Integer;
    procedure ShowHideChartTabMenus(AMenuItem: TMenuItem);
    procedure UpdatePtInfoOnRefresh;
    function  TabExists(ATabID: integer): boolean;
    procedure DisplayEncounterText;
    function DLLActive: boolean;
    function FindNextControl(CurControl: TWinControl;
      GoForward, CheckTabStop, CheckParent: Boolean): TWinControl; reintroduce;
    property ChangeSource:    Integer read FChangeSource;
    property CCOWContextChanging: Boolean read FCCOWContextChanging;
    property CCOWDrivedChange: Boolean  read FCCOWDrivedChange;
    property CCOWBusy: Boolean    read FCCOWBusy  write FCCOWBusy;
    property ContextChanging: Boolean read FContextChanging;
    property TimedOut:        Boolean read GetTimedOut;
    property Closing:         Boolean read FClosing;
    property OnTabChanged:    TNotifyEvent read FTabChanged write FTabChanged;
    property GraphFloatActive: boolean read FGraphFloatActive write FGraphFloatActive;
    property GraphContext: string read FGraphContext write FGraphContext;
    procedure ToggleMenuItemChecked(Sender: TObject);
    procedure SetUpCIRN;
    property DoNotChangeEncWindow: boolean read FDoNotChangeEncWindow write FDoNotChangeEncWindow;
    property OrderPrintForm: boolean read FOrderPrintForm write FOrderPrintForm;

    property PDMPMgr: TfrmPDMP read fPDMPMgr;
    procedure pdmpRun(anAlign: TAlign);
    procedure pdmpCloseReport;


    function EditInProgress: String;
    function SaveEditInProgress(var ShowMessage: Boolean): Boolean;
    property PatientInfoLabelCaption: string read GetPatientInfoLabelDisplay;
  end;

  TRpcRecord = record
    RpcName: String;
    UCallListIndex: Integer;
    ResultListIndex: Integer;
    SearchIndex: Integer;
    RPCText: TStringList;
    RPCRunTime: string;
  end;

var
  frmFrame: TfrmFrame;
  uTabList: TStringList;
  uLabRemoteType, uRemoteType, uReportID, uLabRepID : string;
  FlaggedPTList: TStringList;
  ctxContextor : TContextorControl;
  NextTab, LastTab, ChangingTab: Integer;
  uUseVistaWeb: boolean;
  PTSwitchRefresh: boolean = False;  //flag for patient refresh or switch of patients
  ProbTabClicked: boolean = FALSE;
  TabCtrlClicked: Boolean = FALSE;
  DEAContext: Boolean = False;
  DelayReviewChanges: Boolean = False;
  WatchArray: Array of TRpcRecord;

const
  PASSCODE = '_gghwn7pghCrOJvOV61PtPvgdeEU2u5cRsGvpkVDjKT_H7SdKE_hqFYWsUIVT1H7JwT6Yz8oCtd2u2PALqWxibNXx3Yo8GPcTYsNaxW' + 'ZFo8OgT11D5TIvpu3cDQuZd3Yh_nV9jhkvb0ZBGdO9n-uNXPPEK7xfYWCI2Wp3Dsu9YDSd_EM34nvrgy64cqu9_jFJKJnGiXY96Lf1ecLiv4LT9qtmJ-BawYt7O9JZGAswi344BmmCbNxfgvgf0gfGZea';
  EM_SETZOOM = (WM_USER + 225);
  TX_OPTION     = 'OR CPRS GUI CHART';

implementation

{$R *.DFM}
{$R sBitmaps}
{$R sRemSrch}

uses
  ORNet, rCore, fPtSelMsg, fPtSel, fCoverSheet, fProbs, fMeds, fOrders, rOrders, fNotes, fConsults, fDCSumm,
  rMisc, Clipbrd, fLabs, fReports, rReports, fPtDemo, fEncnt, fPtCWAD, uCore, fAbout, fReview,
  uGN_RPCLog,// replaces  fxBroker,fxServer,
  fxLists, ORSystem, fRptBox, fSplash, rODAllergy, uInit, fLabTests, fLabInfo, uGlobalVar,
  uReminders, fReminderTree, ORClasses, fDeviceSelect, fDrawers, fReminderDialog, ShellAPI, rVitals,
  fOptions, fGraphs, fGraphData, rTemplates, fSurgery, rSurgery, uEventHooks, uSignItems,
  fDefaultEvent, rECS, fIconLegend, uOrders, DateUtils, uSpell, uOrPtf, fPatientFlagMulti,
  fAlertForward, UBAGlobals, fBAOptionsDiagnoses, UBACore, fOrdersSign, uVitals, fOrdersRenew, fMHTest, uFormMonitor
  {$IFDEF CCOWBROKER}
  , CCOW_const
  {$ENDIF}
  , VA508AccessibilityRouter, fOtherSchedule, VAUtils, uVA508CPRSCompatibility, fIVRoutes,
  fPrintLocation, fTemplateEditor, fTemplateDialog, fCombatVet, fFocusedControls,
  fViewNotifications, uPaPI, iCoverSheetIntf, AVCatcher, System.IniFiles, Wsockc, rOTH,
  uVersionCheck, uFormUtils
  , oPDMPData, rPDMP, fPDMPView
  , uInfoBoxWithBtnControls, uSimilarNames, fODBase, UExceptHook, ORExtensions,
  UResponsiveGUI, uWriteAccess, System.Math, UMHDll,
  ORCtrls.ActivityLog, ORCtrls.ActivityLogDisplay;

//PaPI =========================================================================
procedure SwitchToThisWindow(h1: hWnd; x: bool); stdcall;
  external user32 Name 'SwitchToThisWindow';
         {x = false: Size unchanged, x = true: normal size}
//PaPI =========================================================================

var
  IsRunExecuted: Boolean = FALSE;
  GraphFloat: TfrmGraphs;
  OTHDTitleCaptionStr, // OTHDTitle caption string
  OTHDTitleHintStr, // OTHDTitle hint string
  OTHDDtlCaptionStr,  // OTHD detail caption string
  OTHDDtlHintStr: String; // OTHD detail hint string
  OTHDDspList: TStringList; // rpk 4/2/2019
  inConstructor: boolean; // blj 21 July 2021 VISTAOR-21519


const
  FCP_UPDATE  = 10;                             // form create about to check auto-update
  FCP_SETHOOK = 20;                             // form create about to set timeout hooks
  FCP_SERVER  = 30;                             // form create about to connect to server
  FCP_CHKVER  = 40;                             // form create about to check version
  FCP_OBJECTS = 50;                             // form create about to create core objects
  FCP_FORMS   = 60;                             // form create about to create child forms
  FCP_PTSEL   = 70;                             // form create about to select patient
  FCP_FINISH  = 99;                             // form create finished successfully

  TX_IN_USE     = 'VistA CPRS in use by: ';     // use same as with CPRSInstances in fTimeout
  TX_ECSOPT     = 'EC GUI CONTEXT';
  TX_PTINQ      = 'Retrieving demographic information...';
  TX_NOTIF_STOP = 'Stop processing notifications?';
  TC_NOTIF_STOP = 'Currently Processing Notifications';
  TX_UNK_NOTIF  = 'Unable to process the follow up action for this notification';
  TC_UNK_NOTIF  = 'Follow Up Action Not Implemented';
  TX_NO_SURG_NOTIF = 'This notification must be processed using the Surgery tab, ' + CRLF +
                     'which is not currently available to you.';
  TC_NO_SURG_NOTIF = 'Surgery Tab Not Available';
{
  TX_VER1       = 'This is version ';
  TX_VER2       = ' of CPRSChart.exe.';
  TX_VER3       = CRLF + 'The running server version is ';
  TX_VER_REQ    = ' version server is required.';
  TX_VER_OLD    = CRLF + 'It is strongly recommended that you upgrade.';
  TX_VER_OLD2   = CRLF + 'The program cannot be run until the client is upgraded.';
  TX_VER_NEW    = CRLF + 'The program cannot be run until the server is upgraded.';
  TC_VER        = 'Server/Client Incompatibility';
  TC_CLIERR     = 'Client Specifications Mismatch';
}
  SHOW_NOTIFICATIONS = True;

  TC_DGSR_ERR    = 'Remote Data Error';
  TC_DGSR_SHOW   = 'Restricted Remote Record';
  TC_DGSR_DENY   = 'Remote Access Denied';
  TX_DGSR_YESNO  = CRLF + 'Do you want to continue accessing this remote patient record?';

  TX_CCOW_LINKED   = 'Clinical Link On';
  TX_CCOW_CHANGING = 'Clinical link changing';
  TX_CCOW_BROKEN   = 'Clinical link broken';
  TX_CCOW_ERROR    = 'CPRS was unable to communicate with the CCOW Context Vault' + CRLF +
                     'CCOW patient synchronization will be unavailable for the remainder of this session.';
  TC_CCOW_ERROR    = 'CCOW Error';

function TfrmFrame.TimeoutCondition: boolean;
begin
  Result := (FCreateProgress < FCP_PTSEL);
end;

function TfrmFrame.GetTimedOut: boolean;
begin
  Result := uInit.TimedOut;
end;

procedure TfrmFrame.TimeOutAction;
var
  ClosingCPRS, DllWindowsFound: boolean;

  procedure CloseDLLWindows;
  var
    i: Integer;
    WinList: TList;

    function FindThreadWindow(Window: HWND; var list: TList): BOOL; stdcall;
    const
      GCLP_HMODULE = -16;

    var
      module: HMODULE;

    begin
      module := GetClassLongPtr(window, GCLP_HMODULE);
      if (module <> MainInstance) and IsWindowVisible(window) then
        list.Add(Pointer(Window));
      Result := true;
    end;

  begin
    WinList := TList.Create;
    try
      EnumThreadWindows(GetCurrentThreadID, @FindThreadWindow, Integer(@WinList));
      for i := 0 to WinList.Count - 1 do
        PostMessage(HWND(WinList[i]), WM_CLOSE, 0, 0);
      DllWindowsFound := (WinList.Count > 0);
      if DllWindowsFound then
      begin
        TResponsiveGUI.ProcessMessages(True);
        FForceCloseTimer := TTimer.Create(Self);
        with FForceCloseTimer do
        begin
          interval := 15000; // 15 seconds
          OnTimer := ForceCloseTimer;
          Enabled := True;
        end;
      end;
    finally
      FreeAndNil(WinList);
    end;
  end;

  procedure CloseCPRS;
  begin
    if ClosingCPRS then
      halt;
    try
      ClosingCPRS := TRUE;
      Enabled := False;
      if DllWindowsFound then
        PostMessage(Handle, UM_TIMEOUT, 0, 0)
      else
        Close;
    except
      halt;
    end;
  end;

begin
  ClosingCPRS := FALSE;
  try
    if assigned(frmOtherSchedule) then frmOtherSchedule.Close;
    if assigned (frmIVRoutes) then frmIVRoutes.Close;
    CloseDLLWindows;
    CloseCPRS;
  except
    CloseCPRS;
  end;
end;

{ General Functions and Procedures }

procedure TfrmFrame.AppException(Sender: TObject; E: Exception);
var
  AnAddr: Pointer;
  ErrMsg: string;
begin
  Application.NormalizeTopMosts;
  try
    if (E is EIntError) then
    begin
      ErrMsg := E.Message + CRLF + 'CreateProgress: ' + IntToStr(FCreateProgress)
        + CRLF + 'RPC Info: ' + RPCLastCall;
      if EExternal(E).ExceptionRecord <> nil then
      begin
        AnAddr := EExternal(E).ExceptionRecord^.ExceptionAddress;
        ErrMsg := ErrMsg + CRLF + 'Address was ' + IntToStr(Integer(AnAddr));
      end;
      // Pass this message up
      E.Message := ErrMsg;
    end;

    if (E is EBrokerError) then
      E.Message := E.Message + CRLF + 'RPC Info: ' + RPCLastCall;
  finally
    Application.RestoreTopMosts;
  end;
end;

procedure TfrmFrame.AfterAppException(Sender: TObject; E: Exception);
var
  RtnCursor: Integer;
begin
  // Option for custom action
  if (E is EBrokerError) then
  begin
    if EBrokerError(E).Code = XWB_M_REJECT then
    begin
      if RPCBrokerV.Connected then
      begin
        RtnCursor := Screen.cursor;
        Screen.cursor := crHourGlass;
        try
          LogBrokerErrors(E.Message, 5);
        finally
          Screen.cursor := RtnCursor;
        end;
      end;
      // ExceptionLog.CustomButtonCaption := 'Debug';
      // ExceptionLog.OnCustomMethod := mnuDebugReportClick;
    end;
  end;

  if (E is EBrokerError) or (E is EOleException) then
  begin
    FCreateProgress := FCP_FORMS;
    // Tell the exception logger that we can't continue
    ExceptionLog.TerminateApp := True;
  end;

end;

procedure TfrmFrame.CPRSExceptionDetails(var CustomDetails: TStringList);
var
  Division, ParentDivision: string;

  procedure ShowRPCLog;
  var
    Text: string;
    i, Count, RPCCount: Integer;
  begin
    LockRPCCallList;
    try
      Count := FRPCExceptionLogSize;
      RPCCount := RetainedRPCCount;
      if Count > RPCCount then
        Count := RPCCount;
      if Count > 0 then
      begin
        ExceptionLog.AddSectionHeader(CustomDetails, 'RPC Log', soFirst);
        for i := 1 to Count do
        begin
          Text := RetrieveRPCName(RPCCount - i);
          if Text <> '' then
            CustomDetails.Add(Text);
        end;
      end;
    finally
      UnlockRPCCallList;
    end;
  end;

  procedure AddInfo(Caption: string; Component: TComponent);
  begin
    if Assigned(Component) then
      CustomDetails.Add(TORActivityLog.ComponentDescription(Component, Caption))
    else
      CustomDetails.Add(Caption + 'None;');
  end;

  procedure ShowLog(Log: TORActivityLog.TLogWrapper; LogName: string);
  var
    i: integer;
  begin
    if Log.Running and (Log.Count > 0) then
    begin
      ExceptionLog.AddSectionHeader(CustomDetails, LogName, soFirst);
      for i := Log.Count - 1 downto 0 do
        CustomDetails.Add(Log[i]);
    end;
  end;

begin
  Division := SystemParameters.AsTypeDef<string>('division.child', '');
  if Division = '' then
  begin
    Division := Piece(RPCBrokerV.User.Division, '^', 1);
    If (Trim(Division) = '') and (RPCBrokerV.Connected) then
      Division := GetDivisionID
    else
      Division := RPCBrokerV.User.Division;
    Division := Division.Replace('^', '  ');
  end;
  ExceptionLog.AddDetail(CustomDetails, 'Division', Division);
  ParentDivision := SystemParameters.AsTypeDef<string>('division.parent', '');
  if ParentDivision <> '' then
    CustomDetails.Add(StringOfChar(' ', TExceptionLogger.ErrorNamePadding + 2) +
    ParentDivision);

  if RPCBrokerV.Connected then
    Text := 'Connected'
  else
    Text := 'Disconnected';
  ExceptionLog.AddDetail(CustomDetails, 'Broker', Text);

  ExceptionLog.AddSectionHeader(CustomDetails, 'Current Control');
  if (tabPage.TabIndex < 0) or (tabPage.TabIndex >= tabPage.Tabs.Count) then
    Text := 'None'
  else
    Text := tabPage.Tabs[tabPage.TabIndex];
  CustomDetails.Add('Current Tab = ' + Text);
  if Assigned(Screen.ActiveControl) then
    AddInfo('Active Control = ', Screen.ActiveControl)
  else
    AddInfo('Active Form = ', Screen.ActiveForm);

  ShowRPCLog;

  ShowLog(TORActivityLog.ActivityLog, 'Activity Log');
  ShowLog(TORActivityLog.MessageLog, 'Windows Message Queue Log');
end;

procedure TfrmFrame.btnCombatVetClick(Sender: TObject);
begin
  inherited;
  frmCombatVet := TfrmCombatVet.Create(frmFrame);
  frmCombatVet.ShowModal;
  frmCombatVet.Free;
end;

function TfrmFrame.AllowContextChangeAll(var Reason: string): Boolean;
var
  Silent: Boolean;
begin
  // blj 21 July 2021 VISTAOR-21519
  // If inConstructor boolean flag still set, we need to bail - the system is
  // not yet at a state where we can support a context change.
  if inConstructor then
  begin
    Result := false;
    exit;
  end;

  if FTerminate or FClosing or (Patient.DFN = '') or pnlNoPatientSelected.Visible then
  begin
    Result := True;
    exit;
  end;
  FContextChanging := True;
  Result := True;
  if COMObjectActive or SpellCheckInProgress or DLLActive then
    begin
      Reason := 'COM_OBJECT_ACTIVE';
      Result:= False;
    end;

  if Result then Result := checkOtherForms(Reason);
  // frmCoverSheet will always AllowContextChange
  if Result then Result := frmProblems.AllowContextChange(Reason);
  if Result then Result := frmMeds.AllowContextChange(Reason);
  if Result then Result := frmOrders.AllowContextChange(Reason);
  if Result then Result := frmNotes.AllowContextChange(Reason);
  if Result then Result := frmConsults.AllowContextChange(Reason);
  if Result then Result := frmDCSumm.AllowContextChange(Reason);
  if Result then
    if Assigned(frmSurgery) then Result := frmSurgery.AllowContextChange(Reason);;
  if Result then Result := frmLabs.AllowContextChange(Reason);;
  if Result then Result := frmReports.AllowContextChange(Reason);
  if Result then Result := frmGraphData.AllowContextChange(Reason);
  if (not User.IsReportsOnly) then
    if Result and Changes.RequireReview then //Result := ReviewChanges(TimedOut);
      case BOOLCHAR[FCCOWContextChanging] of
        '1': begin
               if Changes.RequireReview then
                 begin
                   Reason := 'Items will be left unsigned.';
                   Result := False;
                 end
               else
                 Result := True;
             end;
        '0': begin
               Silent := (TimedOut) or (Reason = 'COMMIT');
               Result := ReviewChanges(Silent);
             end;
      end;
  FContextChanging := False;
end;

// TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 11-20-2015
// Added so the coversheet had a quick way to update.
procedure TfrmFrame.RefreshCWAD(Sender: TObject);
begin
  lblPtCWAD.Caption := GetCWADInfo(Patient.DFN);
  if Length(lblPtCWAD.Caption) > 0 then
    lblPtPostings.Caption := 'Postings'
  else
    lblPtPostings.Caption := 'No Postings';
  pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
end;

procedure TfrmFrame.ClearPatient(Fully: boolean = False);
{ call all pages to make sure patient related information is cleared (when switching patients) }
var
  aCPRSTab: ICPRSTab;
begin
  if FTerminate or FClosing then Exit;

  //Release any rogue locks
  UnlockAllLocks;

  //if frmFrame.Timedout then Exit; // added to correct Access Violation when "Refresh Patient Information" selected
  lblPtName.Caption     := '';
  lblPtInfo.Caption      := '';
  pnlPatient.Caption    := '';
  lblPtCWAD.Caption     := '';
  FPatientInfoCaption := '';

  clearOTHD;

  if DoNotChangeEncWindow = false then
     begin
      lblPtLocation.Caption := 'Visit Not Selected';
      lblPtProvider.Caption := 'Current Provider Not Selected';
      pnlVisit.Caption      := lblPtLocation.Caption + CRLF + lblPtProvider.Caption;
     end;
  lblPtCare.Caption     := 'Primary Care Team Unassigned';
  lblPtAttending.Caption := '';
  lblPtMHTC.Caption := '';
  pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption + ' ' + lblPtMHTC.Caption;
  if Supports(frmCoverSheet, ICPRSTab, aCPRSTab) then
    aCPRSTab.OnClearPtData(Self);
  frmProblems.ClearPtData;
  frmMeds.ClearPtData;
  frmOrders.ClearPtData;
  frmNotes.ClearPtData;
  frmConsults.ClearPtData;
  frmDCSumm.ClearPtData;
  if Assigned(frmSurgery) then frmSurgery.ClearPtData;
  frmLabs.ClearPtData;
  frmGraphData.ClearPtData;
  frmReports.ClearPtData;
  tabPage.TabIndex := PageIDToTab(CT_NOPAGE);       // to make sure DisplayPage gets called
  tabPageChange(tabPage);
  ClearReminderData;
  SigItems.Clear;
  Changes.Clear;
  lstCIRNLocations.Clear;
  ClearFlag;
  if Assigned(FlagList) then FlagList.Clear;
  HasFlag := False;
  HidePatientSelectMessages;
  if (GraphFloat <> nil) and GraphFloatActive then
  with GraphFloat do
  begin
    Initialize;
    DisplayData('top');
    DisplayData('bottom');
    Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
  end;
  if frmFrame.TimedOut then
  begin
    infoBox('CPRS has encountered a serious problem and is unable to display the selected patient''s data. '
            + 'To prevent patient safety issues, CPRS is shutting down. Shutting down and then restarting CPRS will correct the problem, and you may continue working in CPRS.'
             + CRLF + CRLF + 'Please report all occurrences of this problem by contacting your CPRS Help Desk.', 'CPRS Error', MB_OK);
    frmFrame.Close;
  end;
  if Fully then
  begin
    Patient.DFN := '';
    lblPtName.Caption := 'No Patient Selected';
    Encounter.Clear;
    HideEverything;
  end;
end;

procedure TfrmFrame.DigitalSigningSetup1Click(Sender: TObject);
var
  aPKIEncryptionEngine: IPKIEncryptionEngine;
  aDefaultMsg: string;
  aSuccessMsg: string;
  aResults: TStringList;
begin
  try
    // get PKI engine components ready
    NewPKIEncryptionEngine(RPCBrokerV, aPKIEncryptionEngine);

    aResults := TStringList.Create;
    try
      CallVistA('ORDEA LNKMSG', [], aResults);
      aSuccessMsg := aResults.Text;
    finally
      FreeAndNil(aResults);
    end;

    if not IsDigitalSignatureAvailable(aPKIEncryptionEngine, aDefaultMsg, aSuccessMsg) then
      ShowMsg('There was a problem linking your PIV card. Either the '
        + 'PIV card name does NOT match your VistA account name or the PIV card is already '
        + 'linked to another VistA account.  Ensure that the correct PIV card has '
        + 'been inserted for your VistA account. Please contact your PIV Card Coordinator '
        + 'if you continue to have problems.');
  except
    on E: Exception do
      ShowMsg('Problem during digital signing setup: ' + E.Message);
  end;
end;

procedure TfrmFrame.DisplayEncounterText;
{ updates the display in the header bar of encounter related information (location & provider) }
begin
  if DoNotChangeEncWindow = true then exit;
  with Encounter do
  begin
    if Length(LocationText) > 0
      then lblPtLocation.Caption := LocationText
      else lblPtLocation.Caption := 'Visit Not Selected';
    if Length(ProviderName) > 0
      then lblPtProvider.Caption := 'Provider:  ' + ProviderName
      else lblPtProvider.Caption := 'Current Provider Not Selected';
  end;
  pnlVisit.Caption := lblPtLocation.Caption + CRLF + lblPtProvider.Caption;
  FitToolBar;
end;

function TfrmFrame.DLLActive: boolean;
begin
  Result := (VitalsDLLHandle <> 0) or TMHDll.IsLoaded;
end;

{ Form Events (Create, Destroy) ----------------------------------------------------------- }


procedure TfrmFrame.RefreshFixedStatusWidth;
begin
  with stsArea do
    FFixedStatusWidth := Panels[0].Width + Panels[2].Width + Panels[3].Width + Panels[4].Width;
end;

procedure TfrmFrame.FormCreate(Sender: TObject);
{ connect to server, create tab pages, select a patient, & initialize core objects }
var
  SAN: string;
  bConnect: Boolean;

  Procedure LoadExceptionLogger;
  const
    Log = 'orCPRSExceptionLog.';
  var
    I: Integer;
  begin
    ExceptionLog.DaysToPurge := SystemParameters.AsTypeDef<Integer>
      (Log + 'daysToPurge', 60);
    {$IFDEF FASTMM}
    ExceptionLog.Enabled := FALSE;
    {$ELSE}
    ExceptionLog.Enabled := SystemParameters.AsTypeDef<Boolean>
      (Log + 'enabled', False);
    {$ENDIF}
    if ExceptionLog.Enabled then
    begin
      TORActivityLog.ActivityLog.MaxSize := SystemParameters.AsTypeDef<Integer>
        (Log + 'activityLogSize', 0);
      TORActivityLog.MessageLog.MaxSize := SystemParameters.AsTypeDef<Integer>
        (Log + 'winMessageLogSize', 0);
      FRPCExceptionLogSize := SystemParameters.AsTypeDef<Integer>
        (Log + 'RPCLogSize', 0);;
    end
    else
    begin
      TORActivityLog.ActivityLog.MaxSize := 0;
      TORActivityLog.MessageLog.MaxSize := 0;
      FRPCExceptionLogSize := 0;
    end;
    if (not ExceptionLog.Enabled) or ((TORActivityLog.ActivityLog.MaxSize = 0) and
      (TORActivityLog.MessageLog.MaxSize = 0)) then
      mnuShowActivityLog.Visible := False;

    ExceptionLog.IncludeModuleInfo := SystemParameters.AsTypeDef<Boolean>
      (Log + 'includeModuleInfo', False);

    for i := 0 to SystemParameters.CountItems(Log + 'email') - 1 do
      ExceptionLog.EmailTo.Add(SystemParameters.AsTypeDef<string>
        (Format('orCPRSExceptionLog.email[%d].Email', [i]), ''));

    ExceptionLog.OnAppException := AppException;
    ExceptionLog.OnAfterAppException := AfterAppException;
    ExceptionLog.OnCustomExceptionDetails := CPRSExceptionDetails;
  end;

begin
  //blj 21 July 2021 - VISTAOR-21519
  //Adding a flag to disable CCOW context changes if we're still in the main form
  // constructor.
  inConstructor := true;
  try

    {$IFDEF DEBUG}
      setRetainedRPCMax(500); // default 100 is now too small
    {$ENDIF}
      FJustEnteredApp := false;
      SizeHolder := TSizeHolder.Create;
      FOldActiveFormChange := Screen.OnActiveFormChange;
      Screen.OnActiveFormChange := ScreenActiveFormChange;
    //  FCCOWJustJoined := False;
      if not (ParamSearch('CCOW')='DISABLE') then
        try
          StartCCOWContextor;
    //      FCCOWJustJoined := True;
        except
          IsRunExecuted := False;
          FCCOWInstalled := False;
          pnlCCOW.Visible := False;
          mnuFileResumeContext.Visible := False;
          mnuFileBreakContext.Visible := False;
        end
      else
        begin
          IsRunExecuted := False;
          FCCOWInstalled := False;
          pnlCCOW.Visible := False;
          mnuFileResumeContext.Visible := False;
          mnuFileBreakContext.Visible := False;
        end;

      RefreshFixedStatusWidth;
      FTerminate := False;

      // setup initial timeout here so can timeout logon
      FCreateProgress := FCP_SETHOOK;
      InitTimeOut(TimeoutCondition, TimeOutAction);

      // connect to the server and create an option context
      FCreateProgress := FCP_SERVER;

    {$IFDEF CCOWBROKER}
      EnsureBroker;
      if ctxContextor <> nil then
      begin
        if ParamSearch('CCOW') = 'PATIENTONLY' then
          RPCBrokerV.Contextor := nil
        else
          RPCBrokerV.Contextor := ctxContextor;
      end
      else
        RPCBrokerV.Contextor := nil;
    {$ENDIF}
      try
        bConnect := ConnectToServer(TX_OPTION);
      except
        on E: Exception do
        begin
          bConnect := False;
          RPCBrokerV.RPCBError := E.Message;
          if assigned(RPCBrokerV) then
          begin
            SAN := RPCBrokerV.RPCBError;
            if pos('Option locked, ', SAN) > 0 then
              SAN := // SAN + CRLF + CRLF + // replacing original error message
                'CPRS GUI is currently unavailable due to a planned upgrade.' + CRLF
                + 'Please try again later';
            infoBox(SAN, 'Error', MB_OK or MB_ICONWARNING);
          end
          else
          begin
            SAN := 'RPC Broker is unavailable';
            infoBox(SAN, 'Error', MB_OK or MB_ICONERROR);
          end;
        end;
      end;

      if not bConnect then
        begin
          Close;
          exit;
        end;

      if ctxContextor <> nil then
      begin
        if not (ParamSearch('CCOW') = 'PATIENTONLY') then
          ctxContextor.NotificationFilter := ctxContextor.NotificationFilter + ';User';
      end;

      FECSAuthUser := ValidECSUser;
      uECSReport := TECSReport.Create;
      uECSReport.ECSPermit := FECSAuthUser;
      RPCBrokerV.CreateContext(TX_OPTION);

      FOldActivate := Application.OnActivate;
      Application.OnActivate := AppActivated;
      Application.OnDeActivate := AppDeActivated;

      // create initial core objects
      FCreateProgress := FCP_OBJECTS;

      // make sure we're using the matching server version
      FCreateProgress := FCP_CHKVER;

      if not IsCorrectVersion(TX_OPTION) then
    {$IFDEF DEBUG}
        if InfoBox('Version mismatch or error' + CRLF + CRLF +
          'Do you want to continue?', 'DEBUG',MB_YESNO) = mrNo  then
          begin
            Close;
            exit;
          end;
    {$ELSE}
        begin
          Close;
          Exit;
        end;
    {$ENDIF}
      User := TUser.Create;
//      getSysUserParameters(user.DUZ);
      LoadExceptionLogger;
      TResponsiveGUI.Enabled := SystemParameters.AsTypeDef<boolean>('ResponsiveGUI', True);
      CallVistA('XUS PKI GET UPN', [], SAN);
      if SAN='' then DigitalSigningSetup1.Visible := True
      else DigitalSigningSetup1.Visible := False;

      // Add future tabs here as they are created/implemented:
      if (
         (not User.HasCorTabs) and
         (not User.HasRptTab)
         )
      then
      begin
        InfoBox('No valid tabs assigned', 'Tab Access Problem', MB_OK);
        Close;
        Exit;
      end;
      if not SystemParameters.AsType<Boolean>('otherInfromationPanel.turnedOn') then
        begin
          pnlOtherInfo.Enabled := false;
          pnlOtherInfo.Visible := false;
        end
      else
        begin
          fotherPanelUseColor := SystemParameters.AsType<Boolean>('otherInfromationPanel.useColor');
          if fotherPanelUseColor then
            begin
              self.pnlOtherInfo.ParentBackground := false;
              self.pnlOtherInfo.ParentColor := false;
            end
          else
            begin
              pnlOtherInfo.Color := get508CompliantColor(clYellow);
              self.pnlOtherInfo.ParentBackground := true;
              self.pnlOtherInfo.ParentColor := true;
              self.pnlOtherInfo.Color := clBtnFace;
              self.pnlOtherInfo.Repaint;
            end;
          fotherPanelShowReportBox := SystemParameters.AsType<Boolean>('otherInfromationPanel.reportBoxOn');
          pnlOtherInfo.tabstop := screenReaderActive;
        end;

      // Global flags set by server
      IsLeJeuneActive := ServerHasPatch(CampLejeunePatch);
      SpansIntlDateLine := SiteSpansIntlDateLine;

      // create creating core objects
      Patient := TPatient.Create;
      Encounter := TEncounter.Create;
      Changes := TChanges.Create;
      Notifications := TNotifications.Create;
      RemoteSites := TRemoteSiteList.Create;
      RemoteReports := TRemoteReportList.Create;
      uTabList := TStringList.Create;
      FlaggedPTList := TStringList.Create;
      HasFlag  := False;
      FlagList := TStringList.Create;
      OTHDDspList := TStringList.Create;  // rpk 4/2/2019

      //Set the mix case exclusion event
      GetExcludedFromMixed;
      InitialOrderVariables; // needed before tab creation
      // set up structures specific to the user

      Caption := TX_IN_USE + MixedCase(User.Name) + '  (' + String(RPCBrokerV.Server) + ')'
    //    + '  ' + FileVersionValue(Application.ExeName, FILE_VER_DEBUG);
      ;
      SetDebugMenu;
      if InteractiveRemindersActive then
        NotifyWhenRemindersChange(RemindersChanged);
      // load all the tab pages
      FCreateProgress := FCP_FORMS;
      //CreateTab(TObject(frmProblems), TfrmProblems, CT_PROBLEMS, 'Problems');
      CreateTab(CT_PROBLEMS, 'Problems');
      CreateTab(CT_MEDS,     'Meds');
      CreateTab(CT_ORDERS,   'Orders');
      CreateTab(CT_NOTES,    'Notes');
      CreateTab(CT_CONSULTS, 'Consults');
      if ShowSurgeryTab then CreateTab(CT_SURGERY,  'Surgery');
      CreateTab(CT_DCSUMM,   'D/C Summ');
      CreateTab(CT_LABS,     'Labs');
      CreateTab(CT_REPORTS,  'Reports');
      CreateTab(CT_COVER,    'Cover Sheet');
      ShowHideChartTabMenus(mnuViewChart);
      //  We defer calling LoadUserPreferences to UMInitiate, so that the font sizing
      // routines recognize this as the application's main form (this hasn't been
      // set yet).
      FNextButtonBitmap := TBitmap.Create;
      FNextButtonBitmap.LoadFromResourceName(hInstance, 'BMP_HANDRIGHT');
      // set the timeout to DTIME now that there is a connection
      UpdateTimeOutInterval(User.DTIME * 1000);  // DTIME * 1000 mSec
      // get a patient
      HandleNeeded;                              // make sure handle is there for ORWPT SHARE call
      FCreateProgress := FCP_PTSEL;
      Enabled := False;
      FFirstLoad := True;                       // First time to initialize the fFrame
      FCreateProgress := FCP_FINISH;
      pnlReminders.Visible := InteractiveRemindersActive;
      GraphFloatActive := false;
      GraphContext := '';
      frmGraphData := TfrmGraphData.Create(self);        // form is only visible for testing
      GraphDataOnUser;
      uRemoteType := '';
      uLabRemoteType := '';
      uReportID := '';
      uLabRepID := '';
      FPrevPtID := '';
      SetUserTools;
      EnduringPtSelSplitterPos := 0;
      EnduringPtSelColumns := '';
      if User.IsReportsOnly then // Reports Only tab.
        ReportsOnlyDisplay; // Calls procedure to hide all components/menus not needed.

      pdmpGetParams; //PDMP Setup
    {$IFDEF DEBUG}
      ResetParams1.Visible := True;
    {$ENDIF}
      if assigned(PDMP1) then
        begin
          PDMP1.Visible := PDMP_ENABLED;
          N1.Visible := PDMP_ENABLED;
        end;


      PostMessage(Handle, UM_INITIATE, 0, 0);    // select patient after main form is created
      SetFormMonitoring(true);
      //Will load the copy/paste buffer
      CPAppMon.LoadTheProperties;
      CPAppMon.LoadTheBuffer;

      TSimilarNames.Enabled := Uppercase(Getuserparam('OR SIMILAR NAMES ENABLED')) = '1';
  finally
    inConstructor := false;
  end;
end;

procedure TfrmFrame.StartCCOWContextor;
begin
  try
    ctxContextor := TContextorControl.Create(Self);
    with ctxContextor do
      begin
        OnPending := ctxContextorPending;
        OnCommitted := ctxContextorCommitted;
        OnCanceled := ctxContextorCanceled;
      end;
    FCCOWBusy := False;
    FCCOWInstalled := True;
    FCCOWDrivedChange := False;
    ctxContextor.Run('CPRSChart', '', TRUE, 'Patient');
    IsRunExecuted := True;
  except
    on exc : EOleException do
    begin
      IsRunExecuted := False;
      FreeAndNil(ctxContextor);
      try
        ctxContextor := TContextorControl.Create(Self);
        with ctxContextor do
          begin
            OnPending := ctxContextorPending;
            OnCommitted := ctxContextorCommitted;
            OnCanceled := ctxContextorCanceled;
          end;
        FCCOWBusy := False;
        FCCOWInstalled := True;
        FCCOWDrivedChange := False;
        ctxContextor.Run('CPRSChart' + '#', '', TRUE, 'Patient');
        IsRunExecuted := True;
        if ParamSearch('CCOW') = 'FORCE' then
        begin
          mnuFileResumeContext.Enabled := False;
          mnuFileBreakContext.Visible := True;
          mnuFileBreakContext.Enabled := True;
        end
        else
        begin
          ctxContextor.Suspend;
          mnuFileResumeContext.Visible := True;
          mnuFileBreakContext.Visible := True;
          mnuFileBreakContext.Enabled := False;
        end;
      except
        IsRunExecuted := False;
        FCCOWInstalled := False;
        FreeAndNil(ctxContextor);
        pnlCCOW.Visible := False;
        mnuFileResumeContext.Visible := False;
        mnuFileBreakContext.Visible := False;
      end;
    end;
  end
end;

procedure TfrmFrame.UMInitiate(var Message: TMessage);
begin
  NotifyOtherApps(NAE_OPEN, IntToStr(User.DUZ));
  LoadUserPreferences;
  GetBAStatus(User.DUZ,Patient.DFN);
  Enabled := True; // PaPI. Moved before mnuFileOpenClick to enable main window
  mnuFileOpenClick(Self);
  //Enabled := True;
  // If TimedOut, Close has already been called.
  if not TimedOut and (Patient.DFN = '') then
    Close;
end;

procedure TfrmFrame.FormDestroy(Sender: TObject);
{ free core objects used by CPRS }
Var
 I:integer;
begin
  if Assigned(frmActivityLogDisplay) then
    FreeAndNil(frmActivityLogDisplay);
  Application.OnActivate := FOldActivate;
  Screen.OnActiveFormChange := FOldActiveFormChange;
  FNextButtonBitmap.Free;
  if FNextButton <> nil then FNextButton.Free;
  uTabList.Free;
  FlaggedPTList.Free;
  RemoteSites.Free;
  RemoteReports.Free;
  Notifications.Free;
  Changes.Free;
  Encounter.Free;
  Patient.Free;
  User.Free;
  ClearSystemParameters;
  SizeHolder.Free;
  ctxContextor.Free;
  frmDebugReport.Free;
  FreeAndNil(OTHDDspList);
  FreeAndNil(FlagList);

  for I := high(WatchArray) downto low(WatchArray) do
    WatchArray[I].RPCText.Free;
  SetLength(WatchArray, 0);
end;

procedure TfrmFrame.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ cancels close if the user cancels the ReviewChanges screen }
var
  Reason: string;
  I: integer;

begin
  if assigned(FForceCloseTimer) then
    FForceCloseTimer.OnTimer := FForceCloseTimer.OnTimer; // reset timer
  if FCPRSClosing then
    exit;
 //check for modal windows and close any that may exist
  if Application.ModalLevel > 0 then
  begin
    for i := Screen.FormCount - 1 downto 0 do
    begin
      if (fsModal in Screen.Forms[i].FormState) and
        (Screen.Forms[i] <> Application.MainForm) then
        Screen.Forms[i].Close();
    end;
  end;

  if (FCreateProgress < FCP_FINISH) then Exit;
  if User.IsReportsOnly then // Reports Only tab.
    exit;
  if TimedOut then
    begin
      if Changes.RequireReview then ReviewChanges(TimedOut);
      CanClose := True;
      FCPRSClosing := False;
//      Exit;
    end;
  if (not TimedOut) and (not AllowContextChangeAll(Reason)) then
    CanClose := False;
  if CanClose and (not FCPRSClosing) then
  begin
    CanClose := False;
    FCPRSClosing := True;
    FInitCPRSClose := True;
    Screen.Cursor := crHourGlass;
    Enabled := False;
  end;
end;

procedure TfrmFrame.SetUserTools;
var
  item, parent: TToolMenuItem;
  ok: boolean;
  index, i, idx, count: Integer;
  UserTool: TMenuItem;
  Menus: TStringList;
begin
  if User.IsReportsOnly then // Reports Only tab.
  begin
    mnuTools.Clear; // Remove all current items.
    UserTool := TMenuItem.Create(Self);
    UserTool.Caption := 'Options...';
    UserTool.Hint := 'Options';
    UserTool.OnClick := mnuToolsOptionsClick;
    mnuTools.Add(UserTool); // Add back the "Options" menu.
    exit;
  end;
  if User.GECStatus then
  begin
    UserTool := TMenuItem.Create(self);
    UserTool.Caption := 'GEC Referral Status Display';
    UserTool.Hint := 'GEC Referral Status Display';
    UserTool.OnClick := mnuGECStatusClick;
    mnuTools.Add(UserTool); // Add back the "Options" menu.
  end;
  GetToolMenu; // For all other users, proceed normally with creation of Tools menu:
  for i := uToolMenuItems.Count-1 downto 0 do
  begin
    item := TToolMenuItem(uToolMenuItems[i]);
    if (AnsiCompareText(item.Caption, 'Event Capture Interface') = 0 ) and
       (not uECSReport.ECSPermit) then
    begin
      uToolMenuItems.Delete(i);
      Break;
    end;
  end;
  Menus := TStringList.Create;
  try
    count := 0;
    idx := 0;
    index := 0;
    while count < uToolMenuItems.Count do
    begin
      for I := 0 to uToolMenuItems.Count - 1 do
      begin
        item := TToolMenuItem(uToolMenuItems[i]);
        if assigned(item.MenuItem) then continue;
        if item.SubMenuID = '' then
          ok := True
        else
        begin
          idx := Menus.IndexOf(item.SubMenuID);
          ok := (idx >= 0);
        end;
        if ok then
        begin
          inc(count);
          UserTool := TMenuItem.Create(Self);
          UserTool.Caption := Item.Caption;
          if Item.Action <> '' then
          begin
            UserTool.Hint := Item.Action;
            UserTool.OnClick := ToolClick;
          end;
          Item.MenuItem := UserTool;
          if item.SubMenuID = '' then
          begin
            mnuTools.Insert(Index,UserTool);
            inc(Index);
          end
          else
          begin
            parent := TToolMenuItem(Menus.Objects[idx]);
            parent.MenuItem.Add(UserTool);
          end;
          if item.MenuID <> '' then
            Menus.AddObject(item.MenuID, item);
        end;
      end;
    end;
  finally
    Menus.Free;
  end;
  FreeAndNil(uToolMenuItems);
end;

procedure TfrmFrame.UpdateECSParameter(var CmdParameter: string);  //ECS
var
  vstID,AccVer,Svr,SvrPort,VUser: string;
begin
  AccVer  := '';
  Svr     := '';
  SvrPort := '';
  VUser   := '';
  if RPCBrokerV <> nil then
  begin
    AccVer  := String(RPCBrokerV.AccessVerifyCodes);
    Svr     := String(RPCBrokerV.Server);
    SvrPort := IntToStr(RPCBrokerV.ListenerPort);
    VUser   := RPCBrokerV.User.DUZ;
  end;
  vstID := GetVisitID;
  CmdParameter :=' Svr=' +Svr
                 +' SvrPort='+SvrPort
                 +' VUser='+ VUser
                 +' PtIEN='+ Patient.DFN
                 +' PdIEN='+IntToStr(Encounter.Provider)
                 +' vstIEN='+vstID
                 +' locIEN='+IntToStr(Encounter.Location)
                 +' Date=0'
                 +' Division='+GetDivisionID;

end;

procedure TfrmFrame.compAccessTabPageCaptionQuery(Sender: TObject;
  var Text: string);
begin
  Text := GetTabText;
end;

function TfrmFrame.ValidECSUser: boolean;   //ECS
var
  isTrue: boolean;
begin
  Result := True;
  with RPCBrokerV do
  begin
    ShowErrorMsgs := semQuiet;
    Connected     := True;
   try
      isTrue := CreateContext(TX_ECSOPT);
      if not isTrue then
        Result := False;
      ShowErrorMsgs := semRaise;
    except
      on E: Exception do
      begin
        ShowErrorMsgs := semRaise;
        Result := False;
      end;
    end;
  end;
end;

procedure TfrmFrame.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Done: boolean;

  // Remove pending messages to prevent messages from trying to recreate
  // window handles after the form is destroyed. NOTE: WM_PAINT messages don't
  // get removed from the message queue and can cause an infinite loop trying
  // to remove them - which is why we filter them out and added a 500 count
  // (just in case there are any other messages that don't get removed).
  procedure ClearMessages(ctrl: TWinControl);
  const
   // all message types except QS_PAINT
    PM_QS_FILTER = (((QS_ALLINPUT or QS_ALLPOSTMESSAGE) and (not QS_PAINT)) shl 16) or PM_REMOVE;

  var
    i, count: Integer;
    Msg: TMsg;

  begin
    // Ensure the control hasn't been cleaned up already
    if not assigned(ctrl) then
      exit;

    for i := 0 to ctrl.ControlCount - 1 do
      if ctrl.Controls[i] is TWinControl then
        ClearMessages(TWinControl(ctrl.Controls[i]));
    if ctrl.HandleAllocated then
    begin
      count := 0;
      while PeekMessage(Msg, ctrl.Handle, 0, 0, PM_QS_FILTER) do
      begin
        inc(count);
        if count > 500 then
          break;
      end;
    end;
  end;

  procedure SafeClose(var aForm: TForm);
  begin
    if assigned(aForm) then
    begin
      if FLastPage = aForm then
        FLastPage := nil;
      aForm.ActiveControl := nil;
      ClearMessages(aForm);
      aForm.Close;
      aForm := nil;
    end;
  end;

begin
  FClosing := TRUE;
  FInitCPRSClose := False;

  TORActivityLog.ActivityLog.MaxSize := 0;
  TORActivityLog.MessageLog.MaxSize := 0;
  FreeAndNil(frmActivityLogDisplay);

  if assigned(FForceCloseTimer) then
    FForceCloseTimer.Enabled := False;
  SetFormMonitoring(false);
  If Assigned(Patient)
    and assigned(RPCBrokerV) and RPCBrokerV.Connected // AA
  then
   CPAppMon.SaveTheBuffer; //save the buffer

  //Release any rogue locks
  UnlockAllLocks;

  if FCreateProgress < FCP_FINISH then FTerminate := True;

  FlushNotifierBuffer;
  if FCreateProgress = FCP_FINISH then NotifyOtherApps(NAE_CLOSE, '');
  TerminateOtherAppNotification;

  if GraphFloat <> nil then
  begin
    if frmFrame.GraphFloatActive then
      GraphFloat.Close;
    GraphFloat.Release;
    GraphFloat := nil;
  end;

  // unhook the timeout hooks
  ShutDownTimeOut;
  // clearing changes will unlock notes
  if FCreateProgress = FCP_FINISH then Changes.Clear;
  // clear server side flag global tmp
  if FCreateProgress = FCP_FINISH then ClearFlag;
  // save user preferences
  if FCreateProgress = FCP_FINISH then SaveUserPreferences;
  // call close for each page in case there is any special processing
  if FCreateProgress > FCP_FORMS then
  begin
    StopExceptionStackMonitoring;
    mnuFrame.Merge(nil);
    Self.ActiveControl := nil;
    ClearMessages(Self);
    safeClose(TForm(frmCoverSheet));
    safeClose(TForm(frmProblems));   //frmProblems.Release;
    safeClose(TForm(frmMeds));       //frmMeds.Release;
    safeClose(TForm(frmOrders));     //frmOrders.Release;
    safeClose(TForm(frmNotes));      //frmNotes.Release;
    safeClose(TForm(frmConsults));   //frmConsults.Release;
    safeClose(TForm(frmDCSumm));     //frmDCSumm.Release;
    safeClose(TForm(frmSurgery));    //frmSurgery.Release;
    safeClose(TForm(frmLabs));       //frmLabs.Release;
    safeClose(TForm(frmReports));    //frmReports.Release;
    safeClose(TForm(frmGraphData));  //frmGraphData.Release;
    repeat
      Done := True;
      try
        TResponsiveGUI.ProcessMessages(True, True);
      except
        Done := False;
      end;
    until Done;
  end;

  RPCLogClose;

  // if < FCP_FINISH we came here from inside FormCreate, so need to call terminate
  if FCreateProgress < FCP_FINISH then
    begin
      Application.Terminate;
      TResponsiveGUI.ProcessMessages(True);
    end;
end;

procedure TfrmFrame.SetDebugMenu;
var
  IsProgrammer: Boolean;
begin
  IsProgrammer := User.HasKey('XUPROGMODE') or (ShowRPCList = True);
  mnuHelpLists.Visible    := IsProgrammer;
  mnuHelpSymbols.Visible  := IsProgrammer;
  mnuFocusChanges.Visible := IsProgrammer;  {added 10 May 2012  dlp see fFocusControls }
{$IFDEF DEBUG}
  RPCLog_SaveAvailable := isProgrammer;
{$ENDIF}
end;

procedure TfrmFrame.setOtherInfoPanel;
var
info: string;
begin
  pnlOtherInfo.Caption := '';

  if Patient.DFN= '' then
    exit;
  info := otherInformationPanel(Patient.DFN);
  pnlOtherInfo.Caption := Piece(info, u, 2);
  fotherPanelType := Piece(info, u, 1);
  if screenReaderActive then
    begin
      GetScreenReader.Speak(Piece(info, u, 2));

    end;
//  self.pnlOtherInfo.Refresh;
end;

{ Updates posted to MainForm --------------------------------------------------------------- }

procedure TfrmFrame.UMNewOrder(var Message: TMessage);
{ post a notice of change in orders to all TPages, wParam=OrderAction, lParam=TOrder }
var
  OrderAct: string;
begin
  if FTerminate or FClosing then Exit;
  with Message do
  begin
    CoverSheet.OnRefreshPanel(Self, CV_CPRS_ALLG);
    CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);
    frmProblems.NotifyOrder(WParam, TOrder(LParam));
    frmMeds.NotifyOrder(WParam, TOrder(LParam));
    frmOrders.NotifyOrder(WParam, TOrder(LParam));
    frmNotes.NotifyOrder(WParam, TOrder(LParam));
    frmConsults.NotifyOrder(WParam, TOrder(LParam));
    frmDCSumm.NotifyOrder(WParam, TOrder(LParam));
    if Assigned(frmSurgery) then frmSurgery.NotifyOrder(WParam, TOrder(LParam));
    frmLabs.NotifyOrder(WParam, TOrder(LParam));
    frmReports.NotifyOrder(WParam, TOrder(LParam));
    lblPtCWAD.Caption := GetCWADInfo(Patient.DFN);
    if Length(lblPtCWAD.Caption) > 0 then
      lblPtPostings.Caption := 'Postings'
    else
      lblPtPostings.Caption := 'No Postings';
    pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
    OrderAct := '';
    case WParam of
      ORDER_NEW:   OrderAct := 'NW';
      ORDER_DC:    OrderAct := 'DC';
      ORDER_RENEW: OrderAct := 'RN';
      ORDER_HOLD:  OrderAct := 'HD';
      ORDER_EDIT:  OrderAct := 'XX';
      ORDER_ACT:   OrderAct := 'AC';
    end;
    if Length(OrderAct) > 0 then NotifyOtherApps(NAE_ORDER, OrderAct + U + TOrder(LParam).ID);  // add FillerID
  end;
end;

procedure TfrmFrame.UMReminders(var Message: TMessage);
begin
  if SystemParameters.AsType<string>('reEvaluateReminders') = '1' then
    CoverSheet.onRefreshPanel(Self, CV_CPRS_RMND);

  CoverSheet.OnRefreshPanel(Self, CV_CPRS_WVHT);
  CoverSheet.OnRefreshPanel(Self, CV_CPRS_POST);

//  CoverSheet.OnRefreshCWAD(Self);
  lblPtCWAD.Caption := GetCWADInfo(Patient.DFN);
  if Length(lblPtCWAD.Caption) > 0 then
    lblPtPostings.Caption := 'Postings'
  else
    lblPtPostings.Caption := 'No Postings';
  pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
end;

procedure TfrmFrame.UMNOTELIMIT(var Message: TMessage);
begin
  if FTerminate or FClosing then Exit;
 //If active tab is notes then call the note's limit function
 if tabPage.TabIndex = frmFrame.PageIDToTab(CT_NOTES) then
    frmNotes.LimitEditableNote
 else if tabPage.TabIndex = frmFrame.PageIDToTab(CT_SURGERY) then
    frmSurgery.LimitEditableNote
 else if tabPage.TabIndex = frmFrame.PageIDToTab(CT_DCSUMM) then
    frmDCSumm.LimitEditableNote
 else if tabPage.TabIndex = frmFrame.PageIDToTab(CT_CONSULTS) then
    frmConsults.LimitEditableNote;
end;

procedure TfrmFrame.UMEnableNext(var Message: TMessage); // VISTAOR-31343
begin
  if assigned(FNextButton) then
    FNextButton.Enabled := True;

  mnuFileNext.Enabled := True;
end;

{ Tab Selection (navigate between pages) --------------------------------------------------- }

procedure TfrmFrame.WMSetFocus(var Message: TMessage);
var
  aCPRS508: ICPRS508;
begin
  if (FLastPage <> nil) and (not TimedOut) and
     (not (csDestroying in FLastPage.ComponentState)) and FLastPage.Visible then
     if FLastPage.InheritsFrom(TfrmPage) then
       TfrmPage(FLastPage).FocusFirstControl
     else if Supports(fLastPage, ICPRS508, aCPRS508) then
       aCPRS508.OnFocusFirstControl(Self);
end;

procedure TfrmFrame.WMMove(var Msg: TMessage);
var
  r, newBounds: TRect;
begin
  inherited;
  if HandleAllocated and Showing and (WindowState <> wsMaximized) then
  begin
    newBounds := BoundsRect;
    r := Screen.MonitorFromWindow(Self.Handle).WorkareaRect;
    if Height > r.Height then
      newBounds.Height := r.Height;
    if Top < r.Top then
      newBounds.Top := r.Top;
    BoundsRect := newBounds;
  end;
end;

procedure TfrmFrame.UMShowPage(var Message: TMessage);
{ shows a page when the UM_SHOWPAGE message is received }
var
  aCPRSTab: ICPRSTab;
begin
  if FTerminate or FClosing then Exit;
  if FCCOWDrivedChange then FCCOWDrivedChange := False;

  if FLastPage <> nil then
    if FLastPage.InheritsFrom(TfrmPage) then
      TfrmPage(FLastPage).DisplayPage
    else if Supports(fLastPage, ICPRSTab, aCPRSTab) then
      aCPRSTab.OnDisplayPage(Self, CC_CLICK);

  FChangeSource := CC_CLICK;  // reset to click so we're only dealing with exceptions to click
  if assigned(FTabChanged) then
    FTabChanged(Self);

  PostMessage(Handle, UM_ENABLENEXT, 0, 0);  // VISTAOR-31343
end;

procedure TfrmFrame.SwitchToPage(NewForm: TForm);
{ unmerge/merge menus, bring page to top of z-order, call form-specific OnDisplay code }
begin
  if FTerminate or FClosing then Exit;
  if FLastPage = NewForm then
    begin
      if Notifications.Active and Assigned(NewForm) then PostMessage(Handle, UM_SHOWPAGE, 0, 0);
      Exit;
    end;
  if (FLastPage <> nil) then
  begin
    mnuFrame.Unmerge(FLastPage.Menu);
    FLastPage.Hide;
  end;
  if Assigned(NewForm) then begin
    mnuFrame.Merge(NewForm.Menu);
    NewForm.Show;
    FormResize(Self);
  end;
  lstCIRNLocations.Visible := False;
  pnlCIRN.BevelOuter := bvRaised;
  lstCIRNLocations.SendToBack;
  mnuFilePrint.Enabled := False;           // let individual page enable this
  mnuFilePrintSetup.Enabled := False;      // let individual page enable this
  mnuFilePrintSelectedItems.Enabled := False;
  FLastPage := NewForm;
  if NewForm <> nil then
  begin
    if NewForm.Name = frmNotes.Name then frmNotes.Align := alClient
      else frmNotes.Align := alNone;
    if NewForm.Name = frmConsults.Name then frmConsults.Align := alClient
      else frmConsults.Align := alNone;
    if NewForm.Name = frmReports.Name then frmReports.Align := alClient
      else frmReports.Align := alNone;
    if NewForm.Name = frmDCSumm.Name then frmDCSumm.Align := alClient
      else frmDCSumm.Align := alNone;
    if Assigned(frmSurgery) then
      if NewForm.Name = frmSurgery.Name then frmSurgery.Align := alclient
        else frmSurgery.Align := alNone;
    NewForm.BringToFront;                    // to cause tab switch to happen immediately
    TResponsiveGUI.ProcessMessages;
    PostMessage(Handle, UM_SHOWPAGE, 0, 0);  // this calls DisplayPage for the form
  end;
end;

procedure TfrmFrame.mnuDebugReportClick(Sender: TObject);
begin
  inherited;
  if not Assigned(frmDebugReport) then frmDebugReport := TfrmDebugReport.Create(self);
   frmDebugReport.Show;
end;

procedure TfrmFrame.mnuChartTabClick(Sender: TObject);
{ use the Tag property of the menu item to switch to proper page }
begin
  with Sender as TMenuItem do tabPage.TabIndex := PageIDToTab(Tag);
  LastTab := TabToPageID(tabPage.TabIndex) ;
  tabPageChange(tabPage);
end;

procedure TfrmFrame.tabPageChange(Sender: TObject);
{ switches to form linked to NewTab }
var
  PageID : integer;
begin
  PageID := TabToPageID((sender as TTabControl).TabIndex);
  if (PageID <> CT_NOPAGE) and (TabPage.CanFocus) and Assigned(FLastPage) and
     (not TabPage.Focused) then
    TabPage.SetFocus;  //CQ: 14854
  if (not User.IsReportsOnly) then
  begin
    case PageID of
      CT_NOPAGE:   SwitchToPage(nil);
      CT_COVER:    SwitchToPage(frmCoverSheet);
      CT_PROBLEMS: SwitchToPage(frmProblems);
      CT_MEDS:     SwitchToPage(frmMeds);
      CT_ORDERS:   SwitchToPage(frmOrders);
      CT_NOTES:    SwitchToPage(frmNotes);
      CT_CONSULTS: SwitchToPage(frmConsults);
      CT_DCSUMM:   SwitchToPage(frmDCSumm);
      CT_SURGERY:  SwitchToPage(frmSurgery);
      CT_LABS:     SwitchToPage(frmLabs);
      CT_REPORTS:  SwitchToPage(frmReports);
    end; {case}
    if PageID <> CT_NOPAGE then
      NextTab := PageID;
  end
  else // Reports Only tab.
  begin
    SwitchToPage(frmReports);
    NextTab := CT_REPORTS;
  end;
  if ScreenReaderSystemActive and FCtrlTabUsed then
    SpeakPatient;
  ChangingTab := PageID;
end;

function TfrmFrame.PageIDToTab(PageID: Integer): Integer;
{ returns the tab index that corresponds to a given PageID }
VAR
  i: integer;
begin
  i :=  uTabList.IndexOf(IntToStr(PageID));
  Result := i;
end;

function TfrmFrame.TabToPageID(Tab: Integer): Integer;
{ returns the constant that identifies the page given a TabIndex }
begin
  if (Tab > -1) and (Tab < uTabList.Count) then
    Result := StrToIntDef(uTabList[Tab], CT_UNKNOWN)
  else
    Result := CT_NOPAGE;
end;

{ File Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.SetupPatient(AFlaggedList: TStringList);

  function DetermineStringWidth(AString: string; AFont: TFont): Integer;
  var
    Lbl: TLabel;
  begin
    Lbl := TLabel.Create(pnlPage);
    try
      Lbl.Parent := pnlPage;
      Lbl.Font.Assign(AFont);
      Result := Lbl.Canvas.TextWidth(AString);
    finally
      FreeAndNil(Lbl);
    end;
  end;

const
  PnlPatientHint = 'Click for more patient information.';
var
  AMsg, SelectMsg: string;
  InfoLen, NameLen: integer;
begin
  with Patient do
  begin
    ClearPatient;  // must be called to avoid leaving previous patient's information visible!
    btnCombatVet.Caption := 'CV '+ CombatVet.ExpirationDate;
    btnCombatVet.Visible := Patient.CombatVet.IsEligible;
    Visible := True;
    TResponsiveGUI.ProcessMessages;
    lblPtName.Caption := Name + Status; //CQ #17491: Allow for the display of the patient status indicator in header bar.

    lblPtInfo.Caption := PatientInfoLabelCaption;

    if Trim(Piece(SIGI, '/', 1)) = '' then
    begin
      pnlPatient.Hint := PnlPatientHint;
    end else begin
      pnlPatient.Hint := Format('%0:s'#13#10#13#10'%1:s',
        [PnlPatientHint, SigiHintLong(SystemParameters)]);
    end;

    //Name length + buffer
    NameLen := DetermineStringWidth(Trim(lblPtName.Caption), lblPtName.Font) + lblPtName.Left * 2 ;
    //Info length + buffer
    InfoLen := DetermineStringWidth(Trim(lblPtInfo.Caption), lblPtInfo.Font) +  lblPtInfo.Left * 2;

    pnlPatient.Width := Max(NameLen, InfoLen);

    // This is where the 508 reading for Jaws is determined
    if Trim(Piece(SIGI, '/', 1)) = '' then
    begin
      pnlPatient.Caption := Format('%0:s %1:s',
        [lblPtName.Caption, lblPtInfo.Caption]);
    end else begin
      pnlPatient.Caption := StringReplace(Format('%0:s %1:s %2:s.',
          [lblPtName.Caption, lblPtInfo.Caption, StringReplace(
            StringReplace(SIGI_HINTS[1], #9, ' is ', [rfReplaceAll]),
            #13#10, '. ', [rfReplaceAll])
          ]),
        ':', ' is ', [rfReplaceAll]);
    end;

    updateOTHD;

    if Length(CWAD) > 0
      then lblPtPostings.Caption := 'Postings'
      else lblPtPostings.Caption := 'No Postings';
    lblPtCWAD.Caption := CWAD;
    pnlPostings.Caption := lblPtPostings.Caption + ' ' + lblPtCWAD.Caption;
    if (Length(PrimaryTeam) > 0) or (Length(PrimaryProvider) > 0) then
    begin
      lblPtCare.Caption := PrimaryTeam;
      if PrimaryProvider <> '' then lblPtCare.Caption := lblPtCare.Caption + ' / ' + MixedCase(PrimaryProvider);
      if Length(Associate)>0 then lblPtCare.Caption :=  lblPtCare.Caption + ' / ' + MixedCase(Associate);
    end;
    if Length(Attending) > 0 then lblPtAttending.Caption := '(Inpatient) Attending:  ' + MixedCase(Attending);
    pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption;
    if Length(InProvider) > 0  then lblPtAttending.Caption := lblPtAttending.Caption + ' - (Inpatient) Provider: ' + MixedCase(InProvider);
    if Length(MHTC) > 0 then lblPtMHTC.Caption := 'MH Treatment Coordinator: ' + MixedCase(MHTC);
    if (Length(MHTC) = 0) and (Inpatient = True) and (SpecialtySvc = 'P') then
      lblPtMHTC.Caption := 'MH Treatment Coordinator Unassigned';
    pnlPrimaryCare.Caption := lblPtCare.Caption + ' ' + lblPtAttending.Caption + ' ' + lblPtMHTC.Caption;
    SetUpCIRN;
    DisplayEncounterText;
    SetShareNode(DFN, Handle);
    setOtherInfoPanel;
    with Patient do
      NotifyOtherApps(NAE_NEWPT, SSN + U + FloatToStr(DOB) + U + Name);
    SelectMsg := '';
    if MeansTestRequired(Patient.DFN, AMsg) then SelectMsg := AMsg;
    if HasLegacyData(Patient.DFN, AMsg) then
    begin
      if SelectMsg <> '' then
        SelectMsg := SelectMsg + CRLF;
      SelectMsg := SelectMsg + AMsg;
    end;

    HasActiveFlg(FlagList, HasFlag, Patient.DFN);
    if HasFlag then begin
      txtCmdFlags.Visible := false;
      pnlFlag.Enabled := True;
      lblFlag.Font.Color := Get508CompliantColor(clMaroon);
      lblFlag.Enabled := True;
      if (not FReFreshing) and (TriggerPRFPopUp(Patient.DFN)) then
        ShowFlags;
    end else begin
      txtCmdFlags.Visible := ScreenReaderSystemActive;
      pnlFlag.Enabled := False;
      lblFlag.Font.Color := clBtnFace;
      lblFlag.Enabled := False;
    end;
    FPrevPtID := patient.DFN;
    { frmCover.UpdateVAAButton; //VAA CQ7525  (moved here in v26.30 (RV))}
    UpdateVAAMHVButtons(nil);
    // ensure that buttons maintain alRight align
    pnlCVnFlag.Left    	:= pnlRemoteData.Left - pnlCVnFlag.Width;  // rpk 5/9/2019
    paVAA.Left          := pnlCVnFlag.Left - paVAA.Width;  // rpk 5/9/2019

    pnlOTHD.Left 		:= paVAA.Left - pnlOTHD.Width;  // reset OTH to left of VAA, rpk 8/3/2018

    ProcessPatientChangeEventHook;
    if Length(SelectMsg) > 0 then ShowPatientSelectMessages(SelectMsg);

    pdmpSetup(Patient.DFN);
    pdmpAlign;

  end;
end;  // SetupPatient

procedure TfrmFrame.mnuFileNextClick(Sender: TObject);
var
  SaveDFN, NewDFN: string; // *DFN*
  NextIndex, CurrentTab: Integer;
  Reason: string;
  CCOWResponse: UserResponse;
  AccessStatus: integer;
  LongTextBtns: TStringList;
  LongTextResult: integer;
  Next, Quit: boolean;

    procedure UpdatePatientInfoForAlert;
    begin
      if Patient.Inpatient then begin
        Encounter.Inpatient := True;
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
      if User.IsProvider then Encounter.Provider := User.DUZ;
      SetupPatient(FlaggedPTList);
      if (FlaggedPTList.IndexOf(Patient.DFN) < 0) then
        FlaggedPTList.Add(Patient.DFN);
    end;

    procedure reportNotificationFollowUpText;
    var
      sl: TStrings;
    begin
      sl := TStringList.Create;
      try
        setNotificationFollowUpText(sl, Patient.DFN, Notifications.FollowUp,
          Notifications.AlertData);
        ReportBox(sl, Pieces(Piece(Notifications.RecordID, U, 1), ':', 2,
          3), True);
      finally
        sl.Free;
      end;
    end;

begin
  DoNotChangeEncWindow := False;
  OrderPrintForm := False;
  mnuFile.Tag := 0;
  AccessStatus := -1;
  SaveDFN := Patient.DFN;
  Notifications.Next;
  if Notifications.Active then
  begin
    NewDFN := Notifications.DFN;
    if NewDFN = '' then
      ClearPatient(True)
    else if SaveDFN <> NewDFN then
    begin
      if assigned(fPDMPMgr) then  // canceling PDMP request (if any)
        fPDMPMgr.acCancel.Execute;

      // newdfn does not have new patient.co information for CCOW call
      if ((Sender = mnuFileOpen) or (AllowContextChangeAll(Reason)))
          and AllowAccessToSensitivePatient(NewDFN, AccessStatus) then
      begin
        RemindersStarted := FALSE;
        Patient.DFN := NewDFN;
        Encounter.Clear;
        Changes.Clear;
        if Assigned(FlagList) then
        begin
         FlagList.Clear;
         HasFlag := False;
         HasActiveFlg(FlagList, HasFlag, NewDFN);
        end;
        if FCCOWInstalled and (ctxContextor.State = csParticipating) then
          begin
            if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then
              UpdatePatientInfoForAlert
            else
              begin
                case CCOWResponse of
                  urCancel:
                    begin
                      Patient.DFN := SaveDFN;
                      Notifications.Prior;
                      Exit;
                    end;
                  urBreak:
                    begin
                      // do not revert to old DFN if context was manually broken by user - v26 (RV)
                      if (ctxContextor.State = csParticipating) then Patient.DFN := SaveDFN;
                      UpdatePatientInfoForAlert;
                    end;
                  else
                    UpdatePatientInfoForAlert;
                end;
              end;
          end
        else
          UpdatePatientInfoForAlert
      end else
      begin
        if AccessStatus in [DGSR_ASK, DGSR_DENY] then
        begin
          Notifications.Clear;
          // hide the 'next notification' button
          FNextButtonActive := False;
          FNextButton.Free;
          FNextButton := nil;
          mnuFileNext.Enabled := False;
          mnuFileNotifRemove.Enabled := False;
          Patient.DFN := '';
          mnuFileOpenClick(mnuFileNext);
          exit;
        end
        else
        if SaveDFN <> '' then
        begin
          Patient.DFN := SaveDFN;
          Notifications.Prior;
          Exit;
        end
        else
        begin
          Notifications.Clear;
          Patient.DFN := '';
          mnuFileOpenClick(mnuFileNext);
          exit;
        end;
      end;
    end;
    stsArea.Panels.Items[1].Text := Notifications.Text;
    if Notifications.FollowUp = NF_LONG_TEXT_ALERT then
      FChangeSource := CC_CLICK
    else
      FChangeSource := CC_NOTIFICATION;
    CurrentTab := tabPage.TabIndex;
    NextIndex := PageIDToTab(CT_COVER);
    tabPage.TabIndex := CT_NOPAGE;
    tabPageChange(tabPage);
    mnuFileNotifRemove.Enabled := Notifications.Followup in [NF_FLAGGED_ORDERS,
                                                             NF_ORDER_REQUIRES_ELEC_SIGNATURE,
                                                             NF_MEDICATIONS_EXPIRING_INPT,
                                                             NF_MEDICATIONS_EXPIRING_OUTPT,
                                                             NF_UNVERIFIED_MEDICATION_ORDER,
                                                             NF_UNVERIFIED_ORDER,
                                                             NF_FLAGGED_OI_EXP_INPT,
                                                             NF_FLAGGED_OI_EXP_OUTPT];
    case Notifications.FollowUp of
      NF_LONG_TEXT_ALERT:
        if NewDFN = '' then
          NextIndex := CT_NOPAGE
        else if User.UseLastTab then
        begin
          if (CurrentTab < 0) then
            NextIndex := PageIDToTab(User.InitialTab)
          else
            NextIndex := CurrentTab;
        end
        else
          NextIndex := PageIDToTab(User.InitialTab);
      NF_LAB_RESULTS                   : NextIndex := PageIDToTab(CT_LABS);
      NF_FLAGGED_ORDERS                : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDER_REQUIRES_ELEC_SIGNATURE : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ABNORMAL_LAB_RESULTS          : NextIndex := PageIDToTab(CT_LABS);
      NF_IMAGING_RESULTS               : NextIndex := PageIDToTab(CT_REPORTS);
      NF_CONSULT_REQUEST_RESOLUTION    : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_ABNORMAL_IMAGING_RESULTS      : NextIndex := PageIDToTab(CT_REPORTS);
      NF_IMAGING_REQUEST_CANCEL_HELD   : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NEW_SERVICE_CONSULT_REQUEST   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_CONSULT_REQUEST_CANCEL_HOLD   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_PROSTHETICS_REQUEST_UPDATED   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_SITE_FLAGGED_RESULTS          : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDERER_FLAGGED_RESULTS       : NextIndex := PageIDToTab(CT_ORDERS);
      NF_ORDER_REQUIRES_COSIGNATURE    : NextIndex := PageIDToTab(CT_ORDERS);
      NF_LAB_ORDER_CANCELED            : NextIndex := PageIDToTab(CT_ORDERS);
      NF_STAT_RESULTS                  :
        if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'LRCH' then
          NextIndex := PageIDToTab(CT_LABS)
        else if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'GMRC' then
          NextIndex := PageIDToTab(CT_CONSULTS)
        else if Piece(Piece(Notifications.AlertData, '|', 2), '@', 2) = 'RA' then
          NextIndex := PageIDToTab(CT_REPORTS);
      NF_DNR_EXPIRING                  : NextIndex := PageIDToTab(CT_ORDERS);
      NF_MEDICATIONS_EXPIRING_INPT     : NextIndex := PageIDToTab(CT_ORDERS);
      NF_MEDICATIONS_EXPIRING_OUTPT    : NextIndex := PageIDToTab(CT_ORDERS);
      NF_UNVERIFIED_MEDICATION_ORDER   : NextIndex := PageIDToTab(CT_ORDERS);
      NF_RX_RENEWAL_REQUEST            :
        begin
          if (Notifications.AlertData = '') then
          begin
            Notifications.Delete;
          end;
          NextIndex := PageIDToTab(CT_ORDERS);
        end;
      NF_LAPSED_ORDER                  : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NEW_ALLERGY_CONFLICT_ORDER    : NextIndex := PageIDToTab(CT_ORDERS); // NJC
      NF_HIRISK_ORDER                  : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NEW_ORDER                     : NextIndex := PageIDToTab(CT_ORDERS);
      NF_IMAGING_RESULTS_AMENDED       : NextIndex := PageIDToTab(CT_REPORTS);
      NF_CRITICAL_LAB_RESULTS          : NextIndex := PageIDToTab(CT_LABS);
      NF_UNVERIFIED_ORDER              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_RESULTS            : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_ORDER              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_ORDERS_COMMENTS       : NextIndex := PageIDToTab(CT_ORDERS); // NSR#20110719
      NF_DC_ORDER                      : NextIndex := PageIDToTab(CT_ORDERS);
      NF_DEA_AUTO_DC_CS_MED_ORDER      : NextIndex := PageIDToTab(CT_ORDERS);
      NF_DEA_CERT_REVOKED              : NextIndex := PageIDToTab(CT_ORDERS);
      NF_CONSULT_UNSIGNED_NOTE         : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_DCSUMM_UNSIGNED_NOTE          : NextIndex := PageIDToTab(CT_DCSUMM);
      NF_NOTES_UNSIGNED_NOTE           : NextIndex := PageIDToTab(CT_NOTES);
      NF_CONSULT_REQUEST_UPDATED       : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_FLAGGED_OI_EXP_INPT           : NextIndex := PageIDToTab(CT_ORDERS);
      NF_FLAGGED_OI_EXP_OUTPT          : NextIndex := PageIDToTab(CT_ORDERS);
      NF_CONSULT_PROC_INTERPRETATION   : NextIndex := PageIDToTab(CT_CONSULTS);
      NF_RTC_CANCEL_ORDERS             : NextIndex := PageIDToTab(CT_ORDERS);
      NF_NO_FLAG_ACTION_ORDER          : NextIndex := PageIDToTab(CT_ORDERS);
      NF_IMAGING_REQUEST_CHANGED       :
        begin
          ReportNotificationFollowUpText;
          Notifications.Delete;
        end;
      NF_LAB_THRESHOLD_EXCEEDED        : NextIndex := PageIDToTab(CT_LABS);
      NF_MAMMOGRAM_RESULTS             : NextIndex := PageIDToTab(CT_REPORTS);
      NF_PAP_SMEAR_RESULTS             : NextIndex := PageIDToTab(CT_REPORTS);
      NF_ANATOMIC_PATHOLOGY_RESULTS    : NextIndex := PageIDToTab(CT_REPORTS);
      NF_SURGERY_UNSIGNED_NOTE         : if TabExists(CT_SURGERY) then
                                           NextIndex := PageIDToTab(CT_SURGERY)
                                         else
                                           InfoBox(TX_NO_SURG_NOTIF, TC_NO_SURG_NOTIF, MB_OK);

    else
    begin
      if IsSmartAlert(Notifications.FollowUp) then NextIndex := PageIDToTab(CT_NOTES)
      else InfoBox(TX_UNK_NOTIF, TC_UNK_NOTIF, MB_OK);
    end;
    end; //case

    if NextIndex <> CT_NOPAGE then
    begin
      tabPage.TabIndex := NextIndex;
      tabPageChange(tabPage);
    end;

    if Notifications.FollowUp = NF_LONG_TEXT_ALERT then
    begin
      LongTextBtns := TStringList.Create();
      LongTextBtns.Add('Copy to Clipboard');
      LongTextBtns.Add('Dismiss Alert');
      LongTextBtns.Add('Keep Alert^true');

      LongTextResult := 0;
      while (LongTextResult=0) do
      begin
        LongTextResult := uInfoBoxWithBtnControls.DefMessageDlg(Notifications.Data.Text,
            mtConfirmation, LongTextBtns, Notifications.HighLightSection, false);
        if (LongTextResult = 0) then
          ClipBoard.astext := Notifications.Data.Text
      end;
      if (LongTextResult = 1) then
        DeleteAlert(Piece(Notifications.RecordID, U, 2));
      if NewDFN = '' then
      begin
        Quit := False;
        repeat
          Next := Notifications.IsLast;
          if not Next then Next := (ShowMsg('Process Next Alert?',
            'No Patient Selected', smiQuestion, smbYesNo) = smrYes);
          if not Next then
            Quit := (infoBox(TX_NOTIF_STOP, TC_NOTIF_STOP, MB_YESNO) = ID_YES);
        until Next or Quit;
        if Quit then
          Notifications.Clear;
        ShowEverything;
        mnuFileNextClick(Sender);
      end;
    end;
  end
  else mnuFileOpenClick(mnuFileNext); //case else
  if Patient.DFN = '' then
    Close;
end;

procedure TfrmFrame.SetBADxList;
var
  i: smallint;
begin
  if not Assigned(UBAGlobals.tempDxList) then
     begin
     UBAGlobals.tempDxList := TList.Create;
     UBAGlobals.tempDxList.Count := 0;
     TResponsiveGUI.ProcessMessages;
     end
  else
     begin
     //Kill the old Dx list
     for i := 0 to pred(UBAGlobals.tempDxList.Count) do
        TObject(UBAGlobals.tempDxList[i]).Free;

     UBAGlobals.tempDxList.Clear;
     TResponsiveGUI.ProcessMessages;

     //Create new Dx list for newly selected patient
      if not Assigned(UBAGlobals.tempDxList) then
         begin
         UBAGlobals.tempDxList := TList.Create;
         UBAGlobals.tempDxList.Count := 0;
         TResponsiveGUI.ProcessMessages;
         end;
     end;
end;

procedure TfrmFrame.mnuFileOpenClick(Sender: TObject);
{ select a new patient & update the header displays (patient id, encounter, postings) }
var
  SaveDFN, Reason: string;
  ok, OldRemindersStarted, PtSelCancelled: Boolean;
  CCOWResponse: UserResponse;
  ThisSessionChanges: TChanges;
  i: Integer;
  sl: TStrings;
begin
  pnlPatient.Enabled := FALSE;
  if (Sender = mnuFileOpen) or (FRefreshing) then
    PTSwitchRefresh := True
  else
    PTSwitchRefresh := FALSE; // part of a change to CQ #11529
  PtSelCancelled := FALSE;
  if not FRefreshing then
    mnuFile.Tag := 0
  else
    mnuFile.Tag := 1;
  pnlOtherInfo.Caption := '';
  pnlOtherInfo.Repaint;
  DetermineNextTab;
  // if Sender <> mnuFileNext then        //CQ 16273 & 16419 - Missing Review/Sign Changes dialog when clicking 'Next' button.
  ThisSessionChanges := TChanges.Create;
  try
    // Loop through and add in the documents
    for i := 0 to Changes.Documents.Count - 1 do
      begin
        ThisSessionChanges.Add(CH_DOC,
          TChangeItem(Changes.Documents.Items[i]).ID,
          TChangeItem(Changes.Documents.Items[i]).Text,
          TChangeItem(Changes.Documents.Items[i]).GroupName,
          TChangeItem(Changes.Documents.Items[i]).SignState,
          TChangeItem(Changes.Documents.Items[i]).WriteAccessType,
          TChangeItem(Changes.Documents.Items[i]).ParentID,
          TChangeItem(Changes.Documents.Items[i]).User,
          TChangeItem(Changes.Documents.Items[i]).OrderDGIEN,
          TChangeItem(Changes.Documents.Items[i]).OrderDG,
          TChangeItem(Changes.Documents.Items[i]).DCOrder,
          TChangeItem(Changes.Documents.Items[i]).Delay);
      end;
    // Loop through and add in the orders
    for i := 0 to Changes.Orders.Count - 1 do
      begin
        ThisSessionChanges.Add(CH_ORD,
          TChangeItem(Changes.Orders.Items[i]).ID,
          TChangeItem(Changes.Orders.Items[i]).Text,
          TChangeItem(Changes.Orders.Items[i]).GroupName,
          TChangeItem(Changes.Orders.Items[i]).SignState,
          TChangeItem(Changes.Orders.Items[i]).WriteAccessType,
          TChangeItem(Changes.Orders.Items[i]).ParentID,
          TChangeItem(Changes.Orders.Items[i]).User,
          TChangeItem(Changes.Orders.Items[i]).OrderDGIEN,
          TChangeItem(Changes.Orders.Items[i]).OrderDG,
          TChangeItem(Changes.Orders.Items[i]).DCOrder,
          TChangeItem(Changes.Orders.Items[i]).Delay);
      end;
    // Loop through and add in PCE
    for i := 0 to Changes.PCE.Count - 1 do
      begin
        ThisSessionChanges.Add(CH_PCE,
          TChangeItem(Changes.PCE.Items[i]).ID,
          TChangeItem(Changes.PCE.Items[i]).Text,
          TChangeItem(Changes.PCE.Items[i]).GroupName,
          TChangeItem(Changes.PCE.Items[i]).SignState,
          TChangeItem(Changes.PCE.Items[i]).WriteAccessType,
          TChangeItem(Changes.PCE.Items[i]).ParentID,
          TChangeItem(Changes.PCE.Items[i]).User,
          TChangeItem(Changes.PCE.Items[i]).OrderDGIEN,
          TChangeItem(Changes.PCE.Items[i]).OrderDG,
          TChangeItem(Changes.PCE.Items[i]).DCOrder,
          TChangeItem(Changes.PCE.Items[i]).Delay);
      end;
    if not AllowContextChangeAll(Reason) then
      begin
        pnlPatient.Enabled := True;
        // If this is cancelled then reload this sessions changes.
        Changes.Clear;
        // Loop through and add in the documents
        for i := 0 to ThisSessionChanges.Documents.Count - 1 do
          begin
            Changes.Add(CH_DOC,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).ID,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).Text,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).GroupName,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).SignState,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).WriteAccessType,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).ParentID,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).User,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).OrderDGIEN,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).OrderDG,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).DCOrder,
              TChangeItem(ThisSessionChanges.Documents.Items[i]).Delay);
          end;
        // Loop through and add in the orders
        for i := 0 to ThisSessionChanges.Orders.Count - 1 do
          begin
            Changes.Add(CH_ORD, TChangeItem(ThisSessionChanges.Orders.Items[i]).ID,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).Text,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).GroupName,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).SignState,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).WriteAccessType,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).ParentID,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).User,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).OrderDGIEN,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).OrderDG,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).DCOrder,
              TChangeItem(ThisSessionChanges.Orders.Items[i]).Delay);
          end;
        // Loop through and add in PCE
        for i := 0 to ThisSessionChanges.PCE.Count - 1 do
          begin
            Changes.Add(CH_PCE, TChangeItem(ThisSessionChanges.PCE.Items[i]).ID,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).Text,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).GroupName,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).SignState,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).WriteAccessType,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).ParentID,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).User,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).OrderDGIEN,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).OrderDG,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).DCOrder,
              TChangeItem(ThisSessionChanges.PCE.Items[i]).Delay);
          end;
        setOtherInfoPanel;
        exit;
      end;
  finally
    ThisSessionChanges.Clear;
    ThisSessionChanges.Free;
  end;
  // update status text here
  stsArea.Panels.Items[1].Text := '';
  if (not User.IsReportsOnly) then
    begin
      if not FRefreshing then
        begin
          Notifications.Next; // avoid prompt if no more alerts selected to process  {v14a RV}
          if Notifications.Active then
            begin
              if (infoBox(TX_NOTIF_STOP, TC_NOTIF_STOP, MB_YESNO) = ID_NO) then
                begin
                  Notifications.Prior;
                  pnlPatient.Enabled := True;
                  exit;
                end;
            end;
          if Notifications.Active then
            Notifications.Prior;
        end;
    end;

  if FNoPatientSelected then
    SaveDFN := ''
  else
    SaveDFN := Patient.DFN;

  OldRemindersStarted := RemindersStarted;
  RemindersStarted := FALSE;
  try
    if FRefreshing then
      begin
        UpdatePtInfoOnRefresh;
        ok := True;
      end
    else
      begin
        ok := FALSE;
        if (not User.IsReportsOnly) then
          begin
            if FCCOWInstalled and (ctxContextor.State = csParticipating) then
              begin
                UpdateCCOWContext;
                if not FCCOWError then
                  begin
                    FCCOWIconName := 'BMP_CCOW_LINKED';
                    pnlCCOW.Hint := TX_CCOW_LINKED;
                    imgCCOW.Picture.Bitmap.LoadFromResourceName(hInstance, FCCOWIconName);
                  end;
              end
            else
              begin
                FCCOWIconName := 'BMP_CCOW_BROKEN';
                pnlCCOW.Hint := TX_CCOW_BROKEN;
                imgCCOW.Picture.Bitmap.LoadFromResourceName(hInstance, FCCOWIconName);
              end;
            if (Patient.DFN = '') or (Sender = mnuFileOpen) or (Sender = mnuFileNext) or (Sender = mnuViewDemo) then
              SelectPatient(SHOW_NOTIFICATIONS, Font.Size, PtSelCancelled);
            if PtSelCancelled then
              begin
                pnlPatient.Enabled := True;
                exit;
              end;
            ShowEverything;
            // HideEverything('Retrieving information - please wait....');  //v27 (pending) RV
            DisplayEncounterText;
            FPrevInPatient := Patient.Inpatient;
            if Notifications.Active then
              begin
                // display 'next notification' button
                SetUpNextButton;
                FNextButtonActive := True;
                mnuFileNext.Enabled := True;
                mnuFileNextClick(mnuFileOpen);
              end
            else
              begin
                // hide the 'next notification' button
                FNextButtonActive := FALSE;
                FNextButton.Free;
                FNextButton := nil;
                mnuFileNext.Enabled := FALSE;
                mnuFileNotifRemove.Enabled := FALSE;
                //if Patient.DFN <> SaveDFN then
                // removed, too many things happening, just refresh the patient.
                ok := True;
              end
          end
        else
          begin
            Notifications.Clear;
            SelectPatient(FALSE, Font.Size, PtSelCancelled); // Call Pt. Sel. w/o notifications.
            if PtSelCancelled then
              exit;
            ShowEverything;
            DisplayEncounterText;
            FPrevInPatient := Patient.Inpatient;
            ok := True;
          end;
      end;
    if ok then
      begin
//        if FCCOWInstalled and (ctxContextor.State = csParticipating) and (not FRefreshing) and (not FCCOWJustJoined) then
        if FCCOWInstalled and (ctxContextor.State = csParticipating) and (not FRefreshing) then
          begin
            if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then
              begin
                SetupPatient;
                tabPage.TabIndex := PageIDToTab(NextTab);
                tabPageChange(tabPage);
              end
            else
              begin
                case CCOWResponse of
                  urCancel:
                    UpdateCCOWContext;
                  urBreak:
                    begin
                      // do not revert to old DFN if context was manually broken by user - v26 (RV)
                      if (ctxContextor.State = csParticipating) then
                        Patient.DFN := SaveDFN;
                      SetupPatient;
                      tabPage.TabIndex := PageIDToTab(NextTab);
                      tabPageChange(tabPage);
                    end;
                else
                  begin
                    SetupPatient;
                    tabPage.TabIndex := PageIDToTab(NextTab);
                    tabPageChange(tabPage);
                  end;
                end;
              end;
          end
        else
          begin
            SetupPatient;
            tabPage.TabIndex := PageIDToTab(NextTab);
            tabPageChange(tabPage);
//            FCCOWJustJoined := FALSE;
          end;
      end;
  finally
    if (not FRefreshing) and (Patient.DFN = SaveDFN) then
    begin
      RemindersStarted := OldRemindersStarted;
      SetOtherInfoPanel;
    end;
    FFirstLoad := FALSE;

    // canceling PDMP request (if any)
    if assigned(fPDMPMgr) and (Patient.DFN <> SaveDFN) then
    begin
      // Cancel if there is no cached data
      sl := TStringList.Create;
      try
        if not fPDMPMgr.CachedData then
          fPDMPMgr.doCancel(False); // Don't kill the background VistA task
      finally
        sl.Free;
      end;
    end;
  end;
  { Begin BillingAware }
  if BILLING_AWARE then
    frmFrame.SetBADxList; // end IsBillingAware
  { End BillingAware }
  if not FRefreshing then
    begin
      DoNotChangeEncWindow := FALSE;
      OrderPrintForm := FALSE;
      uCore.TempEncounterLoc := 0;
      uCore.TempEncounterLocName := '';
    end;
  pnlPatient.Enabled := True;
end;

procedure TfrmFrame.DetermineNextTab;
begin
  if (FRefreshing or User.UseLastTab) and (not FFirstLoad) then
    begin
      if (tabPage.TabIndex < 0) then
        NextTab := LastTab
      else
        NextTab := TabToPageID(tabPage.TabIndex);
    end
  else
    NextTab := User.InitialTab;
  if NextTab = CT_NOPAGE then
    NextTab := User.InitialTab;
  if User.IsReportsOnly then // Reports Only tab.
    NextTab := CT_REPORTS; // Only one tab should exist by this point in "REPORTS ONLY" mode.
  if not TabExists(NextTab) then
    NextTab := CT_COVER;
  if NextTab = CT_NOPAGE then
    NextTab := User.InitialTab;
  if NextTab = CT_ORDERS then
    if frmOrders <> nil then
      with frmOrders do
        begin
          if (lstSheets.ItemIndex > -1) and (TheCurrentView <> nil) and (TheCurrentView.EventDelay.PtEventIFN > 0) then
            PtEvtCompleted(TheCurrentView.EventDelay.PtEventIFN, TheCurrentView.EventDelay.EventName);
        end;
end;

procedure TfrmFrame.mnuFileEncounterClick(Sender: TObject);
{ displays encounter window and updates encounter display in case encounter was updated }
begin
  UpdateEncounter(NPF_ALL); {*KCM*}
  DisplayEncounterText;
end;

procedure TfrmFrame.mnuFileReviewClick(Sender: TObject);
{ displays the Review Changes window (which resets the Encounter object) }
var
  EventChanges: boolean;
  NameNeedLook: string;
begin
  FReviewClick := True;
  mnuFile.Tag := 1;
  EventChanges := False;
  NameNeedLook := '';
  //UpdatePtInfoOnRefresh;
  if Changes.Count > 0 then
  begin
   if (frmOrders <> nil) and (frmOrders.TheCurrentView <> nil) and ( frmOrders.TheCurrentView.EventDelay.EventIFN>0) then
   begin
     EventChanges := True;
     NameNeedLook := frmOrders.TheCurrentView.ViewName;
     frmOrders.PtEvtCompleted(frmOrders.TheCurrentView.EventDelay.PtEventIFN, frmOrders.TheCurrentView.EventDelay.EventName);
   end;
   ReviewChanges(TimedOut, EventChanges);
   if TabToPageID(tabPage.TabIndex)= CT_MEDS then
   begin
     frmOrders.InitOrderSheets2(NameNeedLook);
   end;
  end
  else InfoBox('No new changes to review/sign.', 'Review Changes', MB_OK);
  //CQ #17491: Moved UpdatePtInfoOnRefresh here to allow for the updating of the patient status indicator
  //in the header bar (after the Review Changes dialog closes) if the patient becomes admitted/discharged.
  UpdatePtInfoOnRefresh;
  FOrderPrintForm := false;
  FReviewClick := false;
end;

procedure TfrmFrame.mnuFileExitClick(Sender: TObject);
{ see the CloseQuery event }
var
  i: smallint;
begin
  try
     if  BILLING_AWARE then
         begin
         if Assigned(tempDxList) then
            for i := 0 to pred(UBAGlobals.tempDxList.Count) do
               TObject(UBAGlobals.tempDxList[i]).Free;

         UBAGlobals.tempDxList.Clear;
         TResponsiveGUI.ProcessMessages;
         end; //end IsBillingAware
  except
     on EAccessViolation do
        begin
        {$ifdef debug}ShowMessage('Access Violation in procedure TfrmFrame.mnuFileExitClick()');{$endif}
        raise;
        end;
     on E: Exception do
        begin
        {$ifdef debug}ShowMessage('Unhandled exception in procedure TfrmFrame.mnuFileExitClick()');{$endif}
        raise;
        end;
  end;

  Close;
end;

{ View Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.mnuWAPermissionsClick(Sender: TObject);
begin
  inherited;
  WriteAccessV.ShowPermissions(Sender);
end;

{ Tool Menu Events ------------------------------------------------------------------------- }

function TfrmFrame.ExpandCommand(x: string): string;
{ look for 'macros' on the command line and expand them using current context }

  procedure Substitute(const Key, Data: string);
  var
    Stop, Start: Integer;
  begin
    Stop  := Pos(Key, x) - 1;
    Start := Stop + Length(Key) + 1;
    x := Copy(x, 1, Stop) + Data + Copy(x, Start, Length(x));
  end;

begin
  if Pos('%MREF', x) > 0 then Substitute('%MREF',
    '^TMP(''ORWCHART'',' + User.JobNumber + ',''' + DottedIPStr + ''',' + IntToHex(Handle, 8) + ')');
  if Pos('%SRV',  x) > 0 then Substitute('%SRV',  String(RPCBrokerV.Server));
  if Pos('%PORT', x) > 0 then Substitute('%PORT', IntToStr(RPCBrokerV.ListenerPort));
  if Pos('%DFN',  x) > 0 then Substitute('%DFN',  Patient.DFN);  //*DFN*
  if Pos('%DUZ',  x) > 0 then Substitute('%DUZ',  IntToStr(User.DUZ));
  if Pos('%H', x) > 0  then Substitute('%H', String(RPCBrokerV.LogIn.LogInHandle));
  if Pos('%STATION', x) > 0 then Substitute('%STATION', copy(User.StationNumber, 1, 3));

  Result := x;
end;

procedure TfrmFrame.ToolClick(Sender: TObject);
{ executes the program associated with an item on the Tools menu, the command line is stored
  in the item's hint property }
const
  TXT_ECS_NOTFOUND = 'The ECS application is not found at the default directory,' + #13 + 'would you like manually search it?';
  TC_ECS_NOTFOUND = 'Application Not Found';
var
  x, AFile, Param, MenuCommand, ECSAppend, CapNm, curPath : string;
  IsECSInterface, CallHelp: boolean;

  function TakeOutAmps(AString: string): string;
  var
    S1,S2: string;
  begin
    if Pos('&',AString)=0 then
    begin
      Result := AString;
      Exit;
    end;
    S1 := Piece(AString,'&',1);
    S2 := Piece(AString,'&',2);
    Result := S1 + S2;
  end;

  function ExcuteEC(AFile,APara: string): boolean;
  begin
    if (ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL) > 32 ) then Result := True
    else
    begin
      if InfoBox(TXT_ECS_NOTFOUND, TC_ECS_NOTFOUND, MB_YESNO or MB_ICONERROR) = IDYES then
      begin
        if OROpenDlg.Execute then
        begin
           AFile := OROpenDlg.FileName;
           if Pos('ecs gui.exe',lowerCase(AFile))<1 then
           begin
             ShowMsg('This is not a valid ECS application.');
             Result := True;
           end else
           begin
             if (ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL)<32) then Result := False
             else Result := True;
           end;
        end
        else Result := True;
      end else Result := True;
    end;
  end;

  function ExcuteECS(AFile, APara: string; var currPath: string): boolean;
  var
    commandline,RPCHandle: string;
    StartupInfo: TStartupInfo;
    ProcessInfo: TProcessInformation;
  begin
    FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
    with StartupInfo do
    begin
      cb := SizeOf(TStartupInfo);
      dwFlags := STARTF_USESHOWWINDOW;
      wShowWindow := SW_SHOWNORMAL;
    end;
    commandline := AFile + Param;
    RPCHandle := GetAppHandle(RPCBrokerV);
    commandline := commandline + ' H=' + RPCHandle;
    if CreateProcess(nil, PChar(commandline), nil, nil, False,
      NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then Result := True
    else
    begin
      if InfoBox(TXT_ECS_NOTFOUND, TC_ECS_NOTFOUND, MB_YESNO or MB_ICONERROR) = IDYES then
      begin
        if OROpenDlg.Execute then
        begin
           AFile := OROpenDlg.FileName;
           if Pos('ecs gui.exe',lowerCase(AFile))<1 then
           begin
             ShowMsg('This is not a valid ECS application.');
             Result := True;
           end else
           begin
             SaveUserPath('Event Capture Interface='+AFile, currPath);
             FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
             with StartupInfo do
             begin
               cb := SizeOf(TStartupInfo);
               dwFlags := STARTF_USESHOWWINDOW;
               wShowWindow := SW_SHOWNORMAL;
             end;
             commandline := AFile + Param;
             RPCHandle := GetAppHandle(RPCBrokerV);
             commandline := commandline + ' H=' + RPCHandle;
             if not CreateProcess(nil, PChar(commandline), nil, nil, False,
                NORMAL_PRIORITY_CLASS, nil, nil,StartupInfo,ProcessInfo) then Result := False
             else Result := True;
           end;
        end
        else Result := True;
      end else Result := True;
    end;
  end;

begin
  MenuCommand := '';
  ECSAppend   := '';
  IsECSInterface := False;
  curPath := '';
  CapNm := LowerCase(TMenuItem(Sender).Caption);
  CapNm := TakeOutAmps(CapNm);
  if AnsiCompareText('event capture interface',CapNm)=0 then
  begin
    IsECSInterface := True;
    if FECSAuthUser then UpdateECSParameter(ECSAppend)
    else begin
      ShowMsg('You don''t have permission to use ECS.');
      exit;
    end;
  end;
  MenuCommand := TMenuItem(Sender).Hint + ECSAppend;
  x := ExpandCommand(MenuCommand);
  if CharAt(x, 1) = '"' then
  begin
    x     := Copy(x, 2, Length(x));
    AFile := Copy(x, 1, Pos('"',x)-1);
    Param := Copy(x, Pos('"',x)+1, Length(x));
  end else
  begin
    AFile := Piece(x, ' ', 1);
    Param := Copy(x, Length(AFile)+1, Length(x));
  end;
  if IsECSInterface then
  begin
    if not ExcuteECS(AFile,Param,curPath) then
      ExcuteECS(AFile,Param,curPath);
    if Length(curPath)>0 then
      TMenuItem(Sender).Hint := curPath;
  end
  else if (Pos('ecs',LowerCase(AFile))>0) and (not IsECSInterface) then
  begin
    if not ExcuteEC(AFile,Param) then
      ExcuteEC(AFile,Param);
  end else
  begin
     if ExtractFileExt(AFile) = '.chm' then
      THelpManager.GetInstance.ExecHelp(1, 0, CallHelp)
    else
      ShellExecute(Handle, 'open', PChar(AFile), PChar(Param), '', SW_NORMAL);
  end;
end;

{ Help Menu Events ------------------------------------------------------------------------- }

procedure TfrmFrame.mnuHelpBrokerClick(Sender: TObject);
{ used for debugging - shows last n broker calls }
begin
  uGN_RPCLog.ShowBroker;
end;

procedure TfrmFrame.mnuHelpListsClick(Sender: TObject);
{ used for debugging - shows internal contents of TORListBox }
begin
  if Screen.ActiveControl is TListBox
{$IFDEF DEBUG}
    then {uGN_RPCLog.}DebugListItems(TListBox(Screen.ActiveControl))
{$ELSE}
    then DebugListItems(TListBox(Screen.ActiveControl))
{$ENDIF}
    else InfoBox('Focus control is not a listbox', 'ListBox Data', MB_OK);
end;

procedure TfrmFrame.mnuHelpSymbolsClick(Sender: TObject);
{ used for debugging - shows current symbol table }
begin
  DebugShowServer;
end;

procedure TfrmFrame.mnuHelpAboutClick(Sender: TObject);
{ displays the about screen }
begin
  ShowAbout;
end;

{ Status Bar Methods }

procedure TfrmFrame.UMStatusText(var Message: TMessage);
{ displays status bar text (using the pointer to a text buffer passed in LParam) }
begin
  stsArea.Panels.Items[0].Text := StrPas(PChar(Message.LParam));
  stsArea.Refresh;
end;

procedure TfrmFrame.UMTimeout(var Message: TMessage);
begin
  Close;
end;

{ Toolbar Methods (make panels act like buttons) ------------------------------------------- }

procedure TfrmFrame.pnlPatientMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the patient identification panel }
begin
  if pnlPatient.BevelOuter = bvLowered then exit;
  pnlPatient.BevelOuter := bvLowered;
  with lblPtName do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtInfo  do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPatientMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate the button raising in the patient identification panel & call Patient Inquiry }
begin
  if pnlPatient.BevelOuter = bvRaised then exit;
  pnlPatient.BevelOuter := bvRaised;
  with lblPtName do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtInfo  do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlVisitMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the encounter panel }
begin
  if User.IsReportsOnly then
    exit;
  if pnlVisit.BevelOuter = bvLowered then exit;
  pnlVisit.BevelOuter := bvLowered;
  with lblPtLocation do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtProvider do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlVisitMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ emulate a button raising in the encounter panel and call Update Provider/Location }
begin
  if User.IsReportsOnly then
    exit;
  if pnlVisit.BevelOuter = bvRaised then exit;
  pnlVisit.BevelOuter := bvRaised;
  with lblPtLocation do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtProvider do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlVistaWebClick(Sender: TObject);
begin
  inherited;
  uUseVistaWeb := true;
  pnlCIRNClick(self);
  uUseVistaWeb := false;
end;

procedure TfrmFrame.pnlVistaWebMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlVistaWeb.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlVistaWebMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  pnlVistaWeb.BevelOuter := bvRaised;
end;

procedure TfrmFrame.pnlPrimaryCareMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pnlPrimaryCare.BevelOuter = bvLowered then exit;
  pnlPrimaryCare.BevelOuter := bvLowered;
  with lblPtCare      do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtAttending do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtMHTC do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPrimaryCareMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pnlPrimaryCare.BevelOuter = bvRaised then exit;
  pnlPrimaryCare.BevelOuter := bvRaised;
  with lblPtCare      do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtAttending do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtMHTC      do SetBounds(Left-2, Top-2, Width, Height);
end;

procedure TfrmFrame.pnlPostingsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ emulate a button press in the postings panel }
begin
  if pnlPostings.BevelOuter = bvLowered then exit;
  pnlPostings.BevelOuter := bvLowered;
  with lblPtPostings do SetBounds(Left+2, Top+2, Width, Height);
  with lblPtCWAD     do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlPostingsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{ emulate a button raising in the posting panel and call Postings }
begin
  if pnlPostings.BevelOuter = bvRaised then exit;
  pnlPostings.BevelOuter := bvRaised;
  with lblPtPostings do SetBounds(Left-2, Top-2, Width, Height);
  with lblPtCWAD     do SetBounds(Left-2, Top-2, Width, Height);
end;

{ Resize and Font-Change procedures -------------------------------------------------------- }

procedure TfrmFrame.LoadSizesForUser;
var
  s1, s2, s3, s4, Dummy: integer;
  panelBottom, panelMedIn, RestoreWidth, MinCnst : integer;

  procedure GetMinContraint(aControl: TWinControl; var LastMinWidth: Integer);
  var
   I: integer;
  begin
   if aControl.Constraints.MinWidth > LastMinWidth then
     LastMinWidth := aControl.Constraints.MinWidth;

   for I := 0 to aControl.ControlCount - 1 do
   begin
     if aControl.Controls[i] is TWinControl then
      GetMinContraint(TWinControl(aControl.Controls[i]), LastMinWidth);
   end;

  end;

begin
  ChangeFont(UserFontSize);
  CoverSheet.OnSetFontSize(Self, UserFontSize);
  CoverSheet.OnSetScreenReaderStatus(Self, ScreenReaderSystemActive);
  SetUserBounds(TControl(frmFrame));

  SetUserWidths(TControl(frmProblems.pnlLeft));
  SetUserWidths(TControl(frmOrders.pnlLeft));
  RestoreWidth := frmNotes.pnlLeft.Width;
  SetUserWidths(TControl(frmNotes.pnlLeft));
  MinCnst := 0;
  GetMinContraint(frmNotes.pnlLeft, MinCnst);
  if frmNotes.pnlLeft.Width < MinCnst then
   frmNotes.pnlLeft.Width := RestoreWidth;

  frmNotes.splHorz.Left := frmNotes.pnlLeft.left + 1;
  SetUserWidths(TControl(frmConsults.pnlLeft));
  SetUserWidths(TControl(frmDCSumm.pnlLeft));
  if Assigned(frmSurgery) then SetUserWidths(TControl(frmSurgery.pnlLeft));
  SetUserWidths(TControl(frmLabs.pnlLeft));
  SetUserWidths(TControl(frmReports.pnlLeft));
  SetUserColumns(TControl(frmOrders.hdrOrders));
  SetUserColumns(TControl(frmMeds.hdrMedsIn));  // still need conversion
  SetUserColumns(TControl(frmMeds.hdrMedsOut));
  SetUserString('frmPtSel.lstvAlerts',EnduringPtSelColumns);
  SetUserString(SpellCheckerSettingName, SpellCheckerSettings);
  SetUserBounds2(TemplateEditorSplitters, tmplEditorSplitterMiddle,
                 tmplEditorSplitterProperties, tmplEditorSplitterMain, tmplEditorSplitterBoil);
  SetUserBounds2(TemplateEditorSplitters2, tmplEditorSplitterNotes, Dummy, Dummy, Dummy);
  SetUserBounds2(ReminderTreeName, RemTreeDlgLeft, RemTreeDlgTop, RemTreeDlgWidth, RemTreeDlgHeight);
  SetUserBounds2(RemDlgName, RemDlgLeft, RemDlgTop, RemDlgWidth, RemDlgHeight);
  SetUserBounds2(RemDlgSplitters, RemDlgSpltr1, RemDlgSpltr2, Dummy ,Dummy);
  SetUserBounds2(DrawerSplitters,s1, s2, s3, S4);
  frmNotes.Drawers.LastOpenSize := s1;
  frmConsults.Drawers.LastOpenSize := s2;
  frmDCSumm.Drawers.LastOpenSize := s3;
  if Assigned(frmSurgery) then frmSurgery.Drawers.LastOpenSize := S4; //CQ7315

  SetUserBounds2(NoteSplitters,s1, s2, s3, s4);
  frmNotes.LoadUserSplitterSettings(s1, s2, s3, s4);

  SetUserBounds2(LabSplitters,s1, s2, s3, s4);
  frmLabs.LoadUserSettings(s1, s2, s3, s4);

  with frmMeds do
     begin
     SetUserBounds2(frmMeds.Name+'Split', panelBottom, panelMedIn, Dummy, Dummy);
     if (panelBottom > frmMeds.Height-50) then panelBottom := frmMeds.Height-50;
     if (panelMedIn > panelBottom-50) then panelMedIn := panelBottom-50;
     frmMeds.gdpOut.Height := panelBottom;
     frmMeds.gdpIn.Height := panelMedIn;
     //Meds Tab Non-VA meds columns
     SetUserColumns(TControl(hdrMedsNonVA)); //CQ7314
     end;

  if ParamSearch('rez') = '640' then SetBounds(Left, Top, 648, 488);  // for testing

end;

procedure TfrmFrame.SaveSizesForUser;
var
  SizeList: TStringList;
  SurgTempHt: integer;
  i, s1, s2, s3, s4: integer;
begin
  SaveUserFontSize(MainFontSize);
  SizeList := TStringList.Create;
  try
    with SizeList do
    begin
      Add(StrUserBounds(frmFrame));
      Add(StrUserWidth(frmProblems.pnlLeft));
      Add(StrUserWidth(frmOrders.pnlLeft));
      Add(StrUserWidth(frmNotes.pnlLeft));
      Add(StrUserWidth(frmConsults.pnlLeft));
      Add(StrUserWidth(frmDCSumm.pnlLeft));
      if Assigned(frmSurgery) then Add(StrUserWidth(frmSurgery.pnlLeft));
      Add(StrUserWidth(frmLabs.pnlLeft));
      Add(StrUserWidth(frmReports.pnlLeft));
      Add(StrUserColumns(frmOrders.hdrOrders));
      Add(StrUserColumns(frmMeds.hdrMedsIn));
      Add(StrUserColumns(frmMeds.hdrMedsOut));
      Add(StrUserString(SpellCheckerSettingName, SpellCheckerSettings));
      Add(StrUserBounds2(TemplateEditorSplitters, tmplEditorSplitterMiddle,
              tmplEditorSplitterProperties, tmplEditorSplitterMain, tmplEditorSplitterBoil));
      Add(StrUserBounds2(TemplateEditorSplitters2, tmplEditorSplitterNotes, 0, 0, 0));
      Add(StrUserBounds2(ReminderTreeName, RemTreeDlgLeft, RemTreeDlgTop, RemTreeDlgWidth, RemTreeDlgHeight));
      Add(StrUserBounds2(RemDlgName, RemDlgLeft, RemDlgTop, RemDlgWidth, RemDlgHeight));
      Add(StrUserBounds2(RemDlgSplitters, RemDlgSpltr1, RemDlgSpltr2, 0 ,0));

      // v26.47 - RV - access violation if Surgery Tab not enabled.  Set to designer height as default.
      if assigned(frmSurgery) and assigned(frmSurgery.Drawers) and
        assigned(frmSurgery.Drawers.pnlTemplates) then
        SurgTempHt := frmSurgery.Drawers.pnlTemplates.Height
      else
        SurgTempHt := 85;

      if assigned(frmNotes) and assigned(frmConsults) and assigned(frmDCSumm)
        and assigned(frmNotes.Drawers) and assigned(frmConsults.Drawers) and
        assigned(frmDCSumm.Drawers) then
      begin
        Add(StrUserBounds2(DrawerSplitters, frmNotes.Drawers.LastOpenSize,
          frmConsults.Drawers.LastOpenSize, frmDCSumm.Drawers.LastOpenSize,
          SurgTempHt)); // last parameter = CQ7315
        Add(StrUserBounds2(DrawerSplitters, frmNotes.Drawers.LastOpenSize,
          frmConsults.Drawers.LastOpenSize, frmDCSumm.Drawers.LastOpenSize,
          SurgTempHt));
      end;

      frmNotes.SaveUserSplitterSettings(s1, s2, s3, s4);
      Add(StrUserBounds2(NoteSplitters, s1, s2, s3, s4));

      frmLabs.SaveUserSettings(s1, s2, s3, s4);
      Add(StrUserBounds2(LabSplitters, s1, s2, s3, s4));

      //Meds Tab Splitters
      Add(StrUserBounds2(frmMeds.Name+'Split',frmMeds.gdpOut.Height,frmMeds.gdpIn.Height,0,0));

      //Meds Tab Non-VA meds columns
      Add(StrUserColumns(fMeds.frmMeds.hdrMedsNonVA)); //CQ7314

      //Orders Tab columns
      Add(StrUserColumns(fOrders.frmOrders.hdrOrders)); //CQ6328

      if EnduringPtSelSplitterPos <> 0 then
        Add(StrUserBounds2('frmPtSel.sptVert', EnduringPtSelSplitterPos, 0, 0, 0));
      if EnduringPtSelColumns <> '' then
        Add('C^frmPtSel.lstvAlerts^' + EnduringPtSelColumns);

      for i := Count - 1 downto 0 do
        if Strings[i] = '' then
          Delete(i);
      //**** Copy/Paste
//      Add(StrUserBounds2('frmNotes.ReadOnlyEditMonitor', frmNotes.ReadOnlyEditMonitor.Height, 0, 0, 0)); // Notes saving is done on the notes form.
    end;
    //Add sizes for forms that used SaveUserBounds() to save thier positions
    SizeHolder.AddSizesToStrList(SizeList);
    //Send the SizeList to the Database
    SaveUserSizes(SizeList);
  finally
    SizeList.Free;
  end;
end;

procedure TfrmFrame.FormResize(Sender: TObject);
{ need to resize tab forms specifically since they don't inherit resize event (because they
  are derived from TForm itself) }
var
  r, newBounds: TRect;

begin
  if FTerminate or FClosing then Exit;
  if csDestroying in ComponentState then Exit;
  // These MoveWindow methods can be phased out. TForm now has TAlign property that set to
  // alClient works perfectly well. TfrmCoverSheet update no longer uses it.
  //MoveWindow(frmCover.Handle,  0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmProblems.Handle, 0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmMeds.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmOrders.Handle,   0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmNotes.Handle,    0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmConsults.Handle, 0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmDCSumm.Handle,   0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  if Assigned(frmSurgery) then MoveWindow(frmSurgery.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmLabs.Handle,     0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  MoveWindow(frmReports.Handle,  0, 0, pnlPage.ClientWidth, pnlPage.ClientHeight, True);
  with stsArea do
  begin
    Panels[1].Width := stsArea.Width - FFixedStatusWidth;
    FNextButtonL := Panels[0].Width + Panels[1].Width;
    FNextButtonR := FNextButtonL + Panels[2].Width;
  end;
  if Notifications.Active then SetUpNextButton;
  lstCIRNLocations.Left  := FNextButtonL - ScrollBarWidth - 100;
  lstCIRNLocations.Width := ClientWidth - lstCIRNLocations.Left;
  //cq: 15641
  if frmFrame.FNextButtonActive then // keeps button aligned if cancel is pressed
  begin
    FNextButton.Left := FNextButtonL;
    FNextButton.Top := stsArea.Top;
  end;

  if Self.WindowState <> wsMaximized then
  begin
    newBounds := BoundsRect;
    r := Screen.MonitorFromWindow(Self.Handle).WorkareaRect;
    if newBounds.Height > r.Height then
      newBounds.Height := r.Height;
    if newBounds.Top < r.Top then
       newBounds.Top := r.Top;
    BoundsRect := newBounds;
  end;
  stsArea.Invalidate;
  Self.Repaint;
end;

procedure TfrmFrame.ChangeFont(NewFontSize: Integer);
{ Makes changes in all components whenever the font size is changed.  This is hardcoded and
  based on MS Sans Serif for now, as only the font size may be selected. Courier New is used
  wherever non-proportional fonts are required. }
const
  TAB_VOFFSET = 7;
var
  OldFont: TFont;
  OrdDlg: TfrmODBase;

begin
  if FTerminate or FClosing then Exit;
// Ho ho!  ResizeAnchoredFormToFont(self) doesn't work here because the
// Form size is aliased with MainFormSize.
  OldFont := TFont.Create;
  try
    DisableAlign;
    try
      OldFont.Assign(Font);
      with Self          do Font.Size := NewFontSize;
      with lblPtName     do Font.Size := NewFontSize;   // must change BOLDED labels by hand
      with lblPtInfo      do Font.Size := NewFontSize;
      with lblOTHDTitle  do Font.Size := NewFontSize;  // rpk 11/28/2017
      with lblOTHDDtl    do Font.Size := NewFontSize;  // rpk 11/28/2017
      with lblPtLocation do Font.Size := NewFontSize;
      with lblPtProvider do Font.Size := NewFontSize;
      with lblPtPostings do Font.Size := NewFontSize;
      with lblPtCare     do Font.Size := NewFontSize;
      with lblPtAttending do Font.Size := NewFontSize;
      with lblPtMHTC      do Font.Size := NewFontSize;
      with lblFlag       do Font.Size := NewFontSize;
      with lblPtCWAD     do Font.Size := NewFontSize;
      with lblCIRN       do Font.Size := NewFontSize;
      with lblVistaWeb   do Font.Size := NewFontSize;
      with lstCIRNLocations do
        begin
          Font.Size := NewFontSize;
          ItemHeight := NewFontSize + 6;
        end;
      with tabPage       do Font.Size := NewFontSize;
      with laMHV         do Font.Size := NewFontSize; //VAA
      with laVAA2        do Font.Size := NewFontSize; //VAA

      frmFrameHeight := frmFrame.Height;
      pnlPatientSelectedHeight := pnlPatientSelected.Height;
      tabPage.Height := MainFontHeight + TAB_VOFFSET;   // resize tab selector
      FitToolbar;                                       // resize toolbar
      stsArea.Font.Size := NewFontSize;
      stsArea.Height := MainFontHeight + TAB_VOFFSET;
      stsArea.Panels[0].Width := ResizeWidth( OldFont, Font, stsArea.Panels[0].Width);
      stsArea.Panels[2].Width := ResizeWidth( OldFont, Font, stsArea.Panels[2].Width);
      pnlOtherInfo.Font.Size := NewFontSize;
      RefreshFixedStatusWidth;
      FormResize( self );

//      RPCLogSetFontSize(NewFontSize);

    finally
      EnableAlign;
    end;
  finally
    OldFont.Free;
  end;

  case (NewFontSize) of
   8: mnu8pt.Checked := true;
  10: mnu10pt1.Checked := true;
  12: mnu12pt1.Checked := true;
  14: mnu14pt1.Checked := true;
  //18: mnu18pt1.Checked := true;
  end;

  if assigned(fPDMPMgr) then
    fPDMPMgr.updateFont;

  RPCLogSetFontSize(NewFontSize);

  //Now that the form elements are resized, the pages will know what size to take.

  //frmCoverSheet.Font.Size := NewFontSize;
  CoverSheet.OnSetFontSize(Self, NewFontSize);
  frmProblems.SetFontSize(NewFontSize);
  frmMeds.SetFontSize(NewFontSize);
  frmOrders.SetFontSize(NewFontSize);
  frmNotes.SetFontSize(NewFontSize);
  frmConsults.SetFontSize(NewFontSize);
  frmDCSumm.SetFontSize(NewFontSize);
  if Assigned(frmSurgery) then frmSurgery.SetFontSize(NewFontSize);
  frmLabs.SetFontSize(NewFontSize);
  frmReports.SetFontSize(NewFontSize);
  TfrmIconLegend.SetFontSize(NewFontSize);
  uOrders.SetFontSize(NewFontSize);
  if Assigned(frmRemDlg) then frmRemDlg.SetFontSize;
  //if (TfrmRemDlg.GetInstance <> nil) then TfrmRemDlg.GetInstance.SetFontSize;
  if Assigned(frmReminderTree) then frmReminderTree.SetFontSize(NewFontSize);
  if GraphFloat <> nil then ResizeAnchoredFormToFont(GraphFloat);

  OrdDlg := CurrentDialog;
  if assigned(OrdDlg) then
    OrdDlg.setFontSize(NewFontSize);

  if Assigned(frmActivityLogDisplay) then
    frmActivityLogDisplay.SetFontSize(NewFontSize);

//  if assigned(fPDMPMgr) then
//    fPDMPMgr.updateFont;
//
//  RPCLogSetFontSize(NewFontSize);
end;

procedure TfrmFrame.FitToolBar;
{ resizes and repositions the panels & labels used in the toolbar }
const
  PATIENT_WIDTH = 29;
  VISIT_WIDTH   = 57;
  POSTING_WIDTH = 11.5;
  FLAG_WIDTH    = 5;
  CV_WIDTH      = 15;
  CIRN_WIDTH    = 11;
  MHV_WIDTH     = 6;
  LINES_HIGH2    = 2;
  LINES_HIGH3    = 3;    //lblPtMHTC line change
  M_HORIZ       = 4;
  M_MIDDLE      = 2;
  M_NVERT       = 4;
  M_WVERT       = 6;
  TINY_MARGIN   = 2;
begin
  if lblPtMHTC.caption = '' then
  begin
    lblPtMHTC.Visible := false;
    pnlToolbar.Height  := (LINES_HIGH2 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_MIDDLE
  end
  else
  begin
    if (lblPtAttending.Caption <> '') and (lblPtAttending.Caption <> lblPtMHTC.Caption) then
    begin
      lblPtMHTC.Visible := true;
      pnlToolbar.Height  := (LINES_HIGH3 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_HORIZ;
    end;
    if lblPtAttending.Caption = '' then
    begin
      lblPtAttending.Caption := lblPtMHTC.Caption;
      lblPtMHTC.Visible := false;
      pnlToolbar.Height  := (LINES_HIGH2 * lblPtName.Height) + M_HORIZ + M_MIDDLE + M_HORIZ + M_MIDDLE;
    end;
  end;
  pnlPatient.Width   := HigherOf(PATIENT_WIDTH * MainFontWidth, Max(lblPtName.Width, lblPtInfo.Width) + (M_WVERT * 2));
  lblPtInfo.Top       := M_HORIZ + lblPtName.Height + M_MIDDLE;
////////////////////////////////////////////////////////////////////////////////
  lblOTHDDtl.Top        := lblPtInfo.Top; // rpk 12/6/2017
  pnlOTHD.Width      := HigherOf( (lblOTHDTitle.Width + (M_WVERT * 2)),
                          (lblOTHDDtl.Width + (M_WVERT * 2)) );  // rpk 12/6/2017

  // center OTH title and data text fields in pnlOTHD
  lblOTHDTitle.Left := (pnlOTHD.Width div 2) - (lblOTHDTitle.Width div 2);
  lblOTHDDtl.Left := (pnlOTHD.Width div 2) - (lblOTHDDtl.Width div 2);
////////////////////////////////////////////////////////////////////////////////

  pnlVisit.Width     := HigherOf(LowerOf(VISIT_WIDTH * MainFontWidth,
                                         HigherOf(lblPtProvider.Width + (M_WVERT * 2),
                                                  lblPtLocation.Width + (M_WVERT * 2))),
                                 PATIENT_WIDTH * MainFontWidth);
  lblPtProvider.Top  := lblPtInfo.Top;
  lblPtAttending.Top := lblPtInfo.Top;
  lblPtMHTC.Top       := M_MIDDLE + lblPtInfo.Height + lblPtInfo.Top;
  pnlPostings.Width  := Round(POSTING_WIDTH * MainFontWidth);
  if btnCombatVet.Visible then
   begin
    pnlCVnFlag.Width   := Round(CV_WIDTH * MainFontWidth);
    pnlFlag.Width      := Round(CV_WIDTH * MainFontWidth);
    btnCombatVet.Height := Round(pnlCVnFlag.Height div 2);
   end
  else
   begin
    pnlCVnFlag.Width   := Round(FLAG_WIDTH * MainFontWidth);
    pnlFlag.Width      := Round(FLAG_WIDTH * MainFontWidth);
   end;
  pnlRemoteData.Width := Round(CIRN_WIDTH * MainFontWidth) + M_WVERT;
  pnlVistaWeb.Height := pnlRemoteData.Height div 2;
  paVAA.Width        := Round(MHV_WIDTH * MainFontWidth) + M_WVERT + 2; // pt. insurance and MHV

  // ensure that buttons maintain alRight align
  pnlCVnFlag.Left    := pnlRemoteData.Left - pnlCVnFlag.Width;  // rpk 5/9/2019
  paVAA.Left          := pnlCVnFlag.Left - paVAA.Width;  // rpk 5/9/2019
  pnlOTHD.Left       := paVAA.Left - pnlOTHD.Width;  // rpk 3/30/2018

  with lblPtPostings do
    SetBounds(M_WVERT, M_HORIZ, pnlPostings.Width-M_WVERT-M_WVERT, lblPtName.Height);
  with lblPtCWAD     do
    SetBounds(M_WVERT, lblPtInfo.Top, lblPtPostings.Width, lblPtName.Height);
  //Low resolution handling: First, try to fit everything on by shrinking fields
  if pnlPrimaryCare.Width < HigherOf( lblPtCare.Left + lblPtCare.Width, HigherOf(lblPtAttending.Left + lblPtAttending.Width,lblPtMHTC.Left + lblPtMHTC.Width)) + TINY_MARGIN then
  //if pnlPrimaryCare.Width < HigherOf( lblPtCare.Left + lblPtCare.Width, lblPtAttending.Left + lblPtAttending.Width) + TINY_MARGIN then
  begin
    lblPtName.Left := TINY_MARGIN;
    lblPtInfo.Left := TINY_MARGIN;
    pnlPatient.Width := HigherOf( lblPtName.Left + lblPtName.Width, lblPtInfo.Left + lblPtInfo.Width)+ TINY_MARGIN;
    lblPtLocation.Left := TINY_MARGIN;
    lblPtProvider.Left := TINY_MARGIN;
    pnlVisit.Width := HigherOf( lblPtLocation.Left + lblPtLocation.Width, lblPtProvider.Left + lblPtProvider.Width)+ TINY_MARGIN;
  end;
  HorzScrollBar.Range := 0;

end;

{ Temporary Calls -------------------------------------------------------------------------- }

procedure TfrmFrame.ToggleMenuItemChecked(Sender: TObject);
begin
  TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked;
end;

{----------------------------------------------------------------------------------------}
{  mnuFocusChangesClick - toggles the Focused Controls window for forms that support it  }
{----------------------------------------------------------------------------------------}
procedure TfrmFrame.mnuFocusChangesClick(Sender: TObject);
begin
  inherited;
  ShowFocusedControlDialog := mnuFocusChanges.Checked;
end;

procedure TfrmFrame.mnuFontSizeClick(Sender: TObject);
begin
  if (frmRemDlg <> nil) then
    ShowMsg('Please close the reminder dialog before changing font sizes.')
  else if (dlgProbs <> nil) then
    ShowMsg('Font size cannot be changed while adding or editing a problem.')
  else begin
    with (Sender as TMenuItem) do begin
      ToggleMenuItemChecked(Sender);
      fMeds.oldFont := MainFontSize; //CQ9182
      ChangeFont(Tag);
    end;
  end;
end;

procedure TfrmFrame.mnuEditClick(Sender: TObject);
var
  IsReadOnly: Boolean;
begin
  FEditCtrl := nil;
  if Screen.ActiveControl is TCustomEdit then FEditCtrl := TCustomEdit(Screen.ActiveControl);
  if FEditCtrl <> nil then begin
    if      FEditCtrl is StdCtrls.TMemo     then IsReadOnly := StdCtrls.TMemo(FEditCtrl).ReadOnly
    else if FEditCtrl is StdCtrls.TEdit     then IsReadOnly := StdCtrls.TEdit(FEditCtrl).ReadOnly
    else if FEditCtrl is ComCtrls.TRichEdit then IsReadOnly := ComCtrls.TRichEdit(FEditCtrl).ReadOnly
    else IsReadOnly := True;

    mnuEditRedo.Enabled := FEditCtrl.Perform(EM_CANREDO, 0, 0) <> 0;
    mnuEditUndo.Enabled := (FEditCtrl.Perform(EM_CANUNDO, 0, 0) <> 0) and (FEditCtrl.Perform(EM_CANREDO, 0, 0) = 0);

    mnuEditCut.Enabled := FEditCtrl.SelLength > 0;
    mnuEditCopy.Enabled := mnuEditCut.Enabled;
    mnuEditPaste.Enabled := (IsReadOnly = False) and Clipboard.HasFormat(CF_TEXT);
  end else begin
    mnuEditUndo.Enabled  := False;
    mnuEditCut.Enabled   := False;
    mnuEditCopy.Enabled  := False;
    mnuEditPaste.Enabled := False;
  end;
end;

procedure TfrmFrame.mnuEditUndoClick(Sender: TObject);
begin
  FEditCtrl.Perform(EM_UNDO, 0, 0);
end;

procedure TfrmFrame.mnuEditRedoClick(Sender: TObject);
begin
  FEditCtrl.Perform(EM_REDO, 0, 0);
end;


procedure TfrmFrame.mnuEditCutClick(Sender: TObject);
begin
  FEditCtrl.CutToClipboard;
end;

procedure TfrmFrame.mnuEditCopyClick(Sender: TObject);
begin
  FEditCtrl.CopyToClipboard;
end;

procedure TfrmFrame.mnuEditPasteClick(Sender: TObject);
begin
  if (assigned(CPAppMon)) and (CPAppMon.Enabled) and CPAppMon.TrackedByCP(FEditCtrl)  then
    FEditCtrl.PasteFromClipboard
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

procedure TfrmFrame.mnuFilePrintClick(Sender: TObject);
begin
  if FTerminate or FClosing then Exit;
  case mnuFilePrint.Tag of
  CT_NOTES:    frmNotes.RequestPrint;
  CT_CONSULTS: frmConsults.RequestPrint;
  CT_DCSUMM:   frmDCSumm.RequestPrint;
  CT_REPORTS:  frmReports.RequestPrint;
  CT_LABS:     frmLabs.RequestPrint;
  CT_ORDERS:   frmOrders.RequestPrint;
  CT_PROBLEMS: frmProblems.RequestPrint;
  CT_SURGERY:  if Assigned(frmSurgery) then frmSurgery.RequestPrint;
  end;
end;

procedure TfrmFrame.WMSysCommand(var Message: TMessage);
begin
  case TabToPageID(tabPage.TabIndex) of
    CT_NOTES:
      if assigned(Screen.ActiveControl) and
        assigned(Screen.ActiveControl.parent) and
        (Screen.ActiveControl.parent.Name = 'cboCosigner') then
        with Message do
            begin
              SendMessage(frmNotes.Handle, Msg, WParam, LParam);
              Result := 0;
            end
        else
          inherited;
    CT_DCSUMM:
      if assigned(Screen.ActiveControl) and
        assigned(Screen.ActiveControl.parent) and
        (Screen.ActiveControl.parent.Name = 'cboAttending') then
        with Message do
            begin
              SendMessage(frmDCSumm.Handle, Msg, WParam, lParam);
              Result := 0;
            end
        else
          inherited;
    CT_CONSULTS:
      if assigned(Screen.ActiveControl) and
        assigned(Screen.ActiveControl.parent) and
        (Screen.ActiveControl.parent.Name = 'cboCosigner') then
        with Message do
            begin
              SendMessage(frmConsults.Handle, Msg, WParam, lParam);
              Result := 0;
            end
        else
          inherited;
  else
    inherited;
  end;
  if Message.WParam = SC_MAXIMIZE then
  begin
    // form becomes maximized;
    frmOrders.mnuOptimizeFieldsClick(self);
    frmProblems.mnuOptimizeFieldsClick(self);
    frmMeds.mnuOptimizeFieldsClick(self);
  end
  else if Message.WParam = SC_MINIMIZE then
  begin
    // form becomes maximized;
  end
  else if Message.WParam = SC_RESTORE then
  begin
    // form is restored (from maximized);
    frmOrders.mnuOptimizeFieldsClick(self);
    frmProblems.mnuOptimizeFieldsClick(self);
    frmMeds.mnuOptimizeFieldsClick(self);
  end;
end;

procedure TfrmFrame.RemindersChanged(Sender: TObject);
var
  ImgName: string;
begin
  pnlReminders.tag := HAVE_REMINDERS;
  pnlReminders.Hint := 'Click to display reminders';
  case GetReminderStatus of
    rsUnknown:
      begin
        ImgName := 'BMP_REMINDERS_UNKNOWN';
        pnlReminders.Caption := 'Reminders';
      end;
    rsDue:
      begin
        ImgName := 'BMP_REMINDERS_DUE';
        pnlReminders.Caption := 'Due Reminders';
      end;
    rsApplicable:
      begin
        ImgName := 'BMP_REMINDERS_APPLICABLE';
        pnlReminders.Caption := 'Applicable Reminders';
      end;
    rsNotApplicable:
      begin
        ImgName := 'BMP_REMINDERS_OTHER';
        pnlReminders.Caption := 'Other Reminders';
      end;
    else
      begin
        ImgName := 'BMP_REMINDERS_NONE';
        pnlReminders.Hint := 'There are currently no reminders available';
        pnlReminders.Caption := pnlReminders.Hint;
        pnlReminders.tag := NO_REMINDERS;
      end;
  end;
  if(RemindersEvaluatingInBackground) then
  begin
    if(anmtRemSearch.ResName = '') then
    begin
      TORExposedAnimate(anmtRemSearch).OnMouseDown := pnlRemindersMouseDown;
      TORExposedAnimate(anmtRemSearch).OnMouseUp   := pnlRemindersMouseUp;
      anmtRemSearch.ResHandle := 0;
      anmtRemSearch.ResName := 'REMSEARCHAVI';
    end;
    imgReminder.Visible := FALSE;
    anmtRemSearch.Active := TRUE;
    anmtRemSearch.Visible := TRUE;
    if(pnlReminders.Hint <> '') then
      pnlReminders.Hint := CRLF + pnlReminders.Hint + '.';
    pnlReminders.Hint := 'Evaluating Reminders...  ' + pnlReminders.Hint;
    pnlReminders.Caption := pnlReminders.Hint;
  end
  else
  begin
    anmtRemSearch.Visible := FALSE;
    imgReminder.Visible := TRUE;
    imgReminder.Picture.Bitmap.LoadFromResourceName(hInstance, ImgName);
    anmtRemSearch.Active := FALSE;
  end;
  mnuViewReminders.Enabled := (pnlReminders.tag = HAVE_REMINDERS);
end;

procedure TfrmFrame.pnlRemindersMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if(not InitialRemindersLoaded) then
    StartupReminders;
  if(pnlReminders.tag = HAVE_REMINDERS) then
    pnlReminders.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlRemindersMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlReminders.BevelOuter := bvRaised;
  if(pnlReminders.tag = HAVE_REMINDERS) then
    ViewInfo(mnuViewReminders);
end;

//--------------------- CIRN-related procedures --------------------------------

procedure TfrmFrame.SetUpCIRN;
var
  i: integer;
  iNwHIN, iRDVOnly: integer;
  aAutoQuery,aVistaWebLabel: string;
  ASite: TRemoteSite;
  item: TVA508AccessibilityItem;
  id: integer;
begin
  uUseVistaWeb := false;
  with RemoteSites do
  begin
    ChangePatient(Patient.DFN);
    lblCIRN.Caption := ' Remote Data';
    lblCIRN.Alignment := taCenter;
    aVistaWebLabel := GetVistaWeb_JLV_LabelName;
    if aVistaWebLabel = '' then aVistaWebLabel := 'VistAWeb';
    lblVistaWeb.Caption := aVistaWebLabel;
    pnlVistaWeb.BevelOuter := bvRaised;
    iNwHIN := 0;
    iRDVOnly := 0;
    for i := 0 to RemoteSites.Count - 1 do
      begin
        if not(LeftStr(TRemoteSite(RemoteSites.SiteList.Items[i]).SiteID, 4) = '200N') then
          begin
            iRDVOnly := 1;
            continue;
          end
        else
          iNwHIN := 1;
      end;

    if RemoteDataExists and ((iRDVOnly = 1) or (iNwHIN = 1)) and (RemoteSites.Count > 0) then
      begin
        if ScreenReaderSystemActive then
        begin
         item := amgrMain.AccessData.FindItem(pnlRemoteData, False);
         id:= item.INDEX;
         amgrMain.AccessData[id].AccessText := '';
        end;
        lblCIRN.Enabled     := True;
        pnlCIRN.TabStop     := True;
        lblCIRN.Font.Color  := Get508CompliantColor(clBlue);
        lstCIRNLocations.Font.Color  := Get508CompliantColor(clBlue);
        lblCIRN.Caption := 'Remote Data';
        pnlCIRN.Hint := 'Click to display other facilities having data for this patient.';
        lblVistaWeb.Font.Color := Get508CompliantColor(clBlue);
        pnlVistaWeb.Hint := 'Click to go to ' + aVistaWebLabel + ' to see data from other facilities for this patient.';
        if RemoteSites.Count > 0 then
          lstCIRNLocations.Items.Add('0' + U + 'All Available Sites');
        for i := 0 to RemoteSites.Count - 1 do
          begin
            ASite := TRemoteSite(SiteList[i]);
            lstCIRNLocations.Items.Add(ASite.SiteID + U + ASite.SiteName + U +
              FormatFMDateTime('mmm dd yyyy hh:nn', ASite.LastDate));
          end;
      end
    else
      begin
        if ScreenReaderSystemActive then
        begin
         item := amgrMain.AccessData.FindItem(pnlRemoteData, False);
         id:= item.INDEX;
         amgrMain.AccessData[id].AccessText := 'No remote data available';
        end;
        lblCIRN.Font.Color  := clWindowText;
        lblVistaWeb.Font.Color := clWindowText;
        lblCIRN.Enabled     := False;
        pnlCIRN.TabStop     := False;
        pnlCIRN.Hint := NoDataReason;
        if (iNwHIN = 1) and (iRDVOnly = 0) then
          begin
           lblVistaWeb.Font.Color := Get508CompliantColor(clBlue);
           pnlVistaWeb.Hint := 'Click to go to ' + aVistaWebLabel + ' to see data from other facilities for this patient (includes Non-VA data).';
          end;
      end;
    aAutoQuery := AutoRDV;        //Check to see if Remote Queries should be used for all available sites
    if (aAutoQuery = '1') and (lstCIRNLocations.Count > 0) then
      begin
        lstCIRNLocations.ItemIndex := 0;
        lstCIRNLocations.Checked[0] := true;
        lstCIRNLocationsClick(self);
      end;
  end;
end;

procedure TfrmFrame.paVAAResize(Sender: TObject);
begin
  laMHV.Height := paVAA.ClientHeight div 2;
end;

procedure TfrmFrame.pnlCIRNClick(Sender: TObject);
begin
  ViewInfo(mnuViewRemoteData);
end;

procedure TfrmFrame.lstCIRNLocationsClick(Sender: TObject);
var
  iIndex,j,iAll,iCur: integer;
  aMsg,s: string;
  AccessStatus: integer;
begin
  iAll := 1;
  AccessStatus := 0;
  iIndex := lstCIRNLocations.ItemIndex;
  if iIndex < 0 then
    exit;
  if not CheckHL7TCPLink then
    begin
      InfoBox('Local HL7 TCP Link is down.' + CRLF + 'Unable to retrieve remote data.', TC_DGSR_ERR, MB_OK);
      lstCIRNLocations.Checked[iIndex] := false;
      Exit;
    end;
  if lstCIRNLocations.Items.Count > 1 then
    if piece(lstCIRNLocations.Items[1],'^',1) = '0' then
      iAll := 2;
  with frmReports do
    if piece(uRemoteType,'^',2) = 'V' then
      begin
        lvReports.Items.BeginUpdate;
        lvReports.Items.Clear;
        lvReports.Columns.Clear;
        lvReports.Items.EndUpdate;
      end;
  uReportInstruction := '';
  frmReports.TabControl1.Tabs.Clear;
  frmLabs.TabControl1.Tabs.Clear;
  frmReports.TabControl1.Tabs.AddObject('Local',nil);
  frmLabs.TabControl1.Tabs.AddObject('Local',nil);
  StatusText('Checking Remote Sites...');
  if piece(lstCIRNLocations.Items[iIndex],'^',1) = '0' then // All sites have been clicked
    if lstCIRNLocations.Checked[iIndex] = false then // All selection is being turned off
      begin
        with RemoteSites.SiteList do
        for j := 0 to Count - 1 do
          if lstCIRNLocations.Checked[j+1] = true then
            begin
              lstCIRNLocations.Checked[j+1] := false;
              TRemoteSite(RemoteSites.SiteList[j]).Selected := false;
              TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
              TRemoteSite(RemoteSites.SiteList[j]).LabClear;
            end;
      end
    else
      begin
        with RemoteSites.SiteList do
        for j := 0 to Count - 1 do
            begin
              Screen.Cursor := crHourGlass;
              Screen.Cursor := crDefault;
              aMsg := aMsg + ' at site: ' + TRemoteSite(Items[j]).SiteName;
              s := lstCIRNLocations.Items[j+1];
              lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3);
              case AccessStatus of
              DGSR_FAIL: begin
                           if piece(aMsg,':',1) = 'RPC name not found at site' then //Allow for backward compatibility
                             begin
                               lstCIRNLocations.Checked[j+1] := true;
                               TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                               TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                               TRemoteSite(Items[j]).Selected := true;
                             end
                           else
                             begin
                               InfoBox(aMsg, TC_DGSR_ERR, MB_OK);
                               lstCIRNLocations.Checked[j+1] := false;
                               lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_ERR;
                               TRemoteSite(Items[j]).Selected := false;
                               Continue;
                             end;
                         end;
              DGSR_NONE: begin
                           lstCIRNLocations.Checked[j+1] := true;
                           TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                           TRemoteSite(Items[j]).Selected := true;
                         end;
              DGSR_SHOW: begin
                           InfoBox(AMsg, TC_DGSR_SHOW, MB_OK);
                           lstCIRNLocations.Checked[j+1] := true;
                           TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                           TRemoteSite(Items[j]).Selected := true;
                         end;
              DGSR_ASK:  if InfoBox(AMsg + TX_DGSR_YESNO, TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or
                           MB_DEFBUTTON2) = IDYES then
                           begin
                             lstCIRNLocations.Checked[j+1] := true;
                             TRemoteSite(RemoteSites.SiteList[j]).ReportClear;
                             TRemoteSite(RemoteSites.SiteList[j]).LabClear;
                             TRemoteSite(Items[j]).Selected := true;
                           end
                           else
                             begin
                               lstCIRNLocations.Checked[j+1] := false;
                               lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_SHOW;
                               TRemoteSite(Items[j]).Selected := false;
                               Continue;
                             end;
              else       begin
                           InfoBox(AMsg, TC_DGSR_DENY, MB_OK);
                           lstCIRNLocations.Checked[j+1] := false;
                           lstCIRNLocations.Items[j+1] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_DENY;
                           TRemoteSite(Items[j]).Selected := false;
                           Continue;
                         end;
              end;
            end;
      end
  else
    begin
      if iIndex > 0 then
        begin
          iCur := iIndex - iAll;
          TRemoteSite(RemoteSites.SiteList[iCur]).Selected :=
            lstCIRNLocations.Checked[iIndex];
          if lstCIRNLocations.Checked[iIndex] = true then
            with RemoteSites.SiteList do
            begin
              Screen.Cursor := crHourGlass;
              Screen.Cursor := crDefault;
              aMsg := aMsg + ' at site: ' + TRemoteSite(Items[iCur]).SiteName;
              s := lstCIRNLocations.Items[iIndex];
              lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3);
              case AccessStatus of
              DGSR_FAIL: begin
                           if piece(aMsg,':',1) = 'RPC name not found at site' then //Allow for backward compatibility
                             begin
                               lstCIRNLocations.Checked[iIndex] := true;
                               TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                               TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                               TRemoteSite(Items[iCur]).Selected := true;
                             end
                           else
                             begin
                               InfoBox(aMsg, TC_DGSR_ERR, MB_OK);
                               lstCIRNLocations.Checked[iIndex] := false;
                               lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_ERR;
                               TRemoteSite(Items[iCur]).Selected := false;
                             end;
                         end;
              DGSR_NONE: begin
                           lstCIRNLocations.Checked[iIndex] := true;
                           TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                           TRemoteSite(Items[iCur]).Selected := true;
                         end;
              DGSR_SHOW: begin
                           InfoBox(AMsg, TC_DGSR_SHOW, MB_OK);
                           lstCIRNLocations.Checked[iIndex] := true;
                           TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                           TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                           TRemoteSite(Items[iCur]).Selected := true;
                         end;
              DGSR_ASK:  if InfoBox(AMsg + TX_DGSR_YESNO, TC_DGSR_SHOW, MB_YESNO or MB_ICONWARNING or
                           MB_DEFBUTTON2) = IDYES then
                           begin
                             lstCIRNLocations.Checked[iIndex] := true;
                             TRemoteSite(RemoteSites.SiteList[iCur]).ReportClear;
                             TRemoteSite(RemoteSites.SiteList[iCur]).LabClear;
                             TRemoteSite(Items[iCur]).Selected := true;
                           end
                           else
                             begin
                               lstCIRNLocations.Checked[iIndex] := false;
                               lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_SHOW;
                             end;
              else       begin
                           InfoBox(AMsg, TC_DGSR_DENY, MB_OK);
                           lstCIRNLocations.Checked[iIndex] := false;
                           lstCIRNLocations.Items[iIndex] := pieces(s, '^', 1, 3) + '^' + TC_DGSR_DENY;
                           TRemoteSite(Items[iCur]).Selected := false;
                         end;
              end;
              with frmReports do
                if piece(uRemoteType,'^',1) = '1' then
                  if not(piece(uRemoteType,'^',2) = 'V') then
                    begin
                      TabControl1.Visible := true;
                      pnlRightTop.Height := lblTitle.Height + TabControl1.Height;
                    end;
              with frmLabs do
                if piece(uLabRemoteType,'^',1) = '1' then
                  if not(piece(uLabRemoteType,'^',2) = 'V') then
                    begin
                      TabControl1.Visible := true;
                      pnlRightTop.Height := lblTitle.Height + TabControl1.Height;
                    end;
            end;
        end;
    end;
  with RemoteSites.SiteList do
    for j := 0 to Count - 1 do
      if TRemoteSite(Items[j]).Selected
        and (not(LeftStr(TRemoteSite(Items[j]).SiteID ,4) = '200N'))  then
        begin
          frmReports.TabControl1.Tabs.AddObject(TRemoteSite(Items[j]).SiteName,
            TRemoteSite(Items[j]));
          frmLabs.TabControl1.Tabs.AddObject(TRemoteSite(Items[j]).SiteName,
            TRemoteSite(Items[j]));
        end;
  if not(Piece(uReportID,':',1) = 'OR_VWAL')
    and not(Piece(uReportID,':',1) = 'OR_VWRX')
    and not(Piece(uReportID,':',1) = 'OR_VWVS')
    and (frmReports.tvReports.SelectionCount > 0) then frmReports.tvReportsClick(self);
  if not(uLabRepID = '6:GRAPH') and not(uLabRepID = '5:WORKSHEET')
    and not(uLabRepID = '4:SELECTED TESTS BY DATE')
    and (frmLabs.tvReports.SelectionCount > 0) then frmLabs.tvReportsClick(self);
  StatusText('');
end;

procedure TfrmFrame.popCIRNCloseClick(Sender: TObject);
begin
  lstCIRNLocations.Visible := False;
  lstCirnLocations.SendToBack;
  pnlCIRN.BevelOuter := bvRaised;
end;

procedure TfrmFrame.popCIRNSelectAllClick(Sender: TObject);

begin
  if lstCIRNLocations.Count > 0 then
  begin
    lstCIRNLocations.ItemIndex := 0;
    lstCIRNLocations.Checked[0] := true;
    lstCIRNLocations.OnClick(Self);
  end;
end;

procedure TfrmFrame.popCIRNSelectNoneClick(Sender: TObject);

begin
  if lstCIRNLocations.Count > 0 then
  begin
    lstCIRNLocations.ItemIndex := 0;
    lstCIRNLocations.Checked[0] := false;
    lstCIRNLocations.OnClick(Self);
  end;
end;

procedure TfrmFrame.mnuFilePrintSetupClick(Sender: TObject);
var
  CurrPrt: string;
begin
  CurrPrt := SelectDevice(Self, Encounter.Location, True, 'Print Device Selection');
  User.CurrentPrinter := Piece(CurrPrt, U, 1);
end;

procedure TfrmFrame.LabInfo1Click(Sender: TObject);
begin
  ExecuteLabInfo;
end;

procedure TfrmFrame.mnuFileNotifRemoveClick(Sender: TObject);
const
  TC_REMOVE_ALERT  = 'Remove Current Alert';
  TX_REMOVE_ALERT1 = 'This action will delete the alert you are currently processing; the alert will ' + CRLF +
        'disappear automatically when all orders have been acted on, but this action may' + CRLF +
        'be used to remove the alert if some orders are to be left unchanged.' + CRLF + CRLF +
        'Your ';
  TX_REMOVE_ALERT2 = ' alert for ';
  TX_REMOVE_ALERT3 = ' will be deleted!' + CRLF + CRLF + 'Are you sure?';
var
  AlertMsg, AlertType: string;

  procedure StopProcessingNotifs;
    begin
      Notifications.Clear;
      FNextButtonActive := False;
      stsArea.Panels[2].Bevel := pbLowered;
      mnuFileNext.Enabled := False;
      mnuFileNotifRemove.Enabled := False;
    end;

begin
  if not Notifications.Active then Exit;
  case Notifications.Followup of
    NF_MEDICATIONS_EXPIRING_INPT    : AlertType := 'Expiring Medications';
    NF_MEDICATIONS_EXPIRING_OUTPT   : AlertType := 'Expiring Medications';
    NF_ORDER_REQUIRES_ELEC_SIGNATURE: AlertType := 'Unsigned Orders';
    NF_FLAGGED_ORDERS               : AlertType := 'Flagged Orders (for clarification)';
    NF_UNVERIFIED_MEDICATION_ORDER  : AlertType := 'Unverified Medication Order';
    NF_UNVERIFIED_ORDER             : AlertType := 'Unverified Order';
    NF_FLAGGED_OI_EXP_INPT          : AlertType := 'Flagged Orderable Item (INPT)';
    NF_FLAGGED_OI_EXP_OUTPT         : AlertType := 'Flagged Orderable Item (OUTPT)';
  else
    Exit;
  end;
  AlertMsg := TX_REMOVE_ALERT1 + AlertType + TX_REMOVE_ALERT2 + Patient.Name + TX_REMOVE_ALERT3;
  if InfoBox(AlertMsg, TC_REMOVE_ALERT, MB_YESNO) = ID_YES then
    begin
      Notifications.DeleteForCurrentUser;
      Notifications.Next;   // avoid prompt if no more alerts selected to process  {v14a RV}
      if Notifications.Active then
        begin
          if (InfoBox(TX_NOTIF_STOP, TC_NOTIF_STOP, MB_YESNO) = ID_NO) then
            begin
              Notifications.Prior;
              mnuFileNextClick(Self);
            end
          else
            StopProcessingNotifs;
        end
      else
        StopProcessingNotifs;
    end;
end;

procedure TfrmFrame.mnuToolsOptionsClick(Sender: TObject);
// personal preferences - changes may need to be applied to chart
var
  i: integer;
begin
  i := 0;
  DialogOptions(i);
end;

procedure TfrmFrame.LoadUserPreferences;
begin
  LoadSizesForUser;
  GetUserTemplateDefaults(TRUE);
end;

procedure TfrmFrame.SaveUserPreferences;
begin
  SaveSizesForUser;         // position & size settings
  SaveUserTemplateDefaults;
end;

procedure TfrmFrame.mnuFileRefreshClick(Sender: TObject);
begin
  FRefreshing := TRUE;
  try
    mnuFileOpenClick(Self);
  finally
    FRefreshing := FALSE;
    OrderPrintForm := FALSE;
  end;
end;

procedure TfrmFrame.AppActivated(Sender: TObject);
begin
  if assigned(FOldActivate) then
    FOldActivate(Sender);
  SetActiveWindow(Application.Handle);
  if ScreenReaderSystemActive and assigned(Patient) and (Patient.Name <> '') and (Patient.Status <> '') then
      SpeakTabAndPatient;
end;

// close Treatment Factor hint window if alt-tab pressed.
procedure TfrmFrame.AppDeActivated(Sender: TObject);
begin
  if FRVTFhintWindowActive then
  begin
     FRVTFHintWindow.ReleaseHandle;
     FRVTFHintWindowActive := False;
  end
  else
  if FOSTFHintWndActive then
  begin
     FOSTFhintWindow.ReleaseHandle;
     FOSTFHintWndActive := False ;
  end;
  if FHintWinActive then   // graphing - hints on values
  begin
    FHintWin.ReleaseHandle;
    FHintWinActive := false;
  end;
end;

procedure TfrmFrame.LoadBuffer(Sender: TObject; LoadList: TStrings; var ProcessLoad: Boolean);
Var
  IPAddr: string;
begin
  inherited;
  //Load the buffer
 CPAppMon.UserDuz := User.DUZ; //Current User's DUZ
 IPAddr := DottedIPStr;
 CallVistA('ORWTIU POLL', [User.DUZ, IPAddr, IntToHex(frmFrame.Handle, 8)], LoadList);
 if Piece(LoadList.Values['(0,0)'], '^', 1) = '-1' then
 begin
  ProcessLoad := false;
  CPAppMon.StopTheBuffer;
 end else
  ProcessLoad := true;
end;

procedure TfrmFrame.LoadProperties(Sender: TObject);
Var
 SavedStyles, DivID, Tmp: String;
 aTmpLst:TStringList;
begin
  //Load the parameters
  with CPAppMon do begin
   //Check if the buffer has alread loaded
   DivID := Piece(RPCBrokerV.User.Division, '^', 1);

   If Trim(DivID) = '' then
    DivID := GetDivisionID;

   CPAppMon.UserDuz := User.DUZ; //Current User's DUZ

   NumberOfWordsToBegin := SystemParameters.AsTypeDef<Double>('cpWordCopy', 0);
   PercentToVerify := SystemParameters.AsTypeDef<Double>('cpPercentCopy', 0) * 100;
   SuperUser := SystemParameters.AsType<string>('cpWordCopy') = '2';
   SavedStyles := SystemParameters.AsType<string>('cpIdentifiers');
   BufferEnabled := not SystemParameters.AsTypeDef<boolean>('cpCopyBufferDisable', True);

   aTmpLst := TStringList.Create;
   try
    aTmpLst.Text := SystemParameters.AsTypeDef<string>('cpExcludeApps','');
    for Tmp in aTmpLst do
      ExcludeApps.Add(Piece(Tmp, '=', 2));

    aTmpLst.Clear;
    aTmpLst.Text := SystemParameters.AsType<string>('cpExcludeNotes');
    for Tmp in aTmpLst do
      ExcludedList.Add(Piece(Tmp, '=', 2));

   finally
    aTmpLst.Free;
   end;

   DisplayPaste := Trim(SavedStyles) <> '-1;Visual Disable Override';
   CPAppMon.Enabled := Trim(SavedStyles) <> '-2';

   if DisplayPaste and CPAppMon.Enabled then begin
    if SavedStyles <> '' then begin
     if (Piece(SavedStyles, ',', 1) = '1') then
      MatchStyle := MatchStyle + [fsBold];
     if (Piece(SavedStyles, ',', 2) = '1') then
      MatchStyle := MatchStyle + [fsItalic];
     if (Piece(SavedStyles, ',', 3) = '1') then
      MatchStyle := MatchStyle + [fsUnderline];

     MatchHighlight :=  (Piece(SavedStyles, ',', 4) = '1');
     HighlightColor := StrToIntDef(Piece(SavedStyles, ',', 5), clYellow);

     //LCS
     LCSToggle := (Piece(SavedStyles, ',', 6) = '1');
     if (Piece(SavedStyles, ',', 7) = '1') then
      LCSTextStyle := LCSTextStyle + [fsBold];
     if (Piece(SavedStyles, ',', 8) = '1') then
      LCSTextStyle := LCSTextStyle + [fsItalic];
     if (Piece(SavedStyles, ',', 9) = '1') then
      LCSTextStyle := LCSTextStyle + [fsUnderline];

     LCSUseColor :=  (Piece(SavedStyles, ',', 10) = '1');
     LCSTextColor := StrToIntDef(Piece(SavedStyles, ',', 11), clRed);
     LCSCharLimit := StrToIntDef(Piece(SavedStyles, ',', 12), 0)
    end;
   end;

  end;
end;

procedure TfrmFrame.SaveBuffer(Sender: TObject; SaveList: TStringList;
  var ReturnList: TStringList);
var
  I, X, Z, TotalBuffer, LineCnt, SubLineCnt: Integer;
  DivisionID, aName, aValue: string;
  aList: iORNetMult;
  LookUpLst: THashedStringList;
begin
  inherited;
  TotalBuffer := StrToIntDef(SaveList.Values['TotalBufferToSave'], -1);
  DivisionID := Piece(RPCBrokerV.User.Division, '^', 1);
  If Trim(DivisionID) = '' then
    DivisionID := GetDivisionID;

  If TotalBuffer > -1 then
  begin
    LookUpLst := THashedStringList.Create;
    try
      LookUpLst.BeginUpdate;
      LookUpLst.Assign(SaveList);
      LookUpLst.EndUpdate;

      neworNetMult(aList);

      for I := 1 to TotalBuffer do
      begin
        aList.AddSubscript([I, 0], LookUpLst.Values[IntToStr(I) + ',0']);

        if not CPAppMon.HashBuffer then
        begin
          LineCnt := StrToIntDef(LookUpLst.Values[IntToStr(I) + ',-1'], -1);
          for X := 1 to LineCnt - 1 do
          begin
            SubLineCnt :=
              StrToIntDef(LookUpLst.Values[IntToStr(I) + ',' + IntToStr(X + 1) +
              ',-1'], -1);
            if SubLineCnt > -1 then
            begin
              for Z := 1 to SubLineCnt - 1 do
              begin
                aName := IntToStr(I) + ',' + IntToStr(X) + ',' +
                  IntToStr(Z);
                aValue := FilteredString(LookUpLst.Values[aName]);
                aList.AddSubscript([I,X,Z], aValue);
              end;
            end
            else
            begin
              aName := IntToStr(I) + ',' + IntToStr(X);
              aValue := FilteredString(LookUpLst.Values[aName]);
              aList.AddSubscript([I,X], aValue);
            end;
          end;
        end;
      end;

      CallVistA('ORWTIU SVCOPY', [aList, DivisionID], ReturnList);
    finally
      LookUpLst.Free;
    end;
  end;
end;

procedure TfrmFrame.StartPollBuff(Sender: TObject; var Error: Boolean);
Var
 DivID, IPAddr, TmpRtn: string;
begin
  inherited;
  DivID := Piece(RPCBrokerV.User.Division, '^', 1);
  If Trim(DivID) = '' then
    DivID := GetDivisionID;
  IPAddr := DottedIPStr;
  CallVistA('ORWTIU START',  [User.DUZ, DivID, IPAddr, IntToHex(frmFrame.Handle, 8)], TmpRtn);
  Error := TmpRtn = '0';
end;

procedure TfrmFrame.StopPollBuff(Sender: TObject; var Error: Boolean);
Var
 IPAddr, TmpRtn: string;
begin
  inherited;
  IPAddr := DottedIPStr;
  CallVistA('ORWTIU STOP', [User.DUZ, IPAddr, IntToHex(frmFrame.Handle, 8)], TmpRtn);
  Error := TmpRtn = '0';
end;

procedure TfrmFrame.CreateTab(ATabID: integer; ALabel: string);
begin
  //  old comment - try making owner self (instead of application) to see if solves TMenuItem.Insert bug
  case ATabID of
    CT_PROBLEMS : begin
                    frmProblems := TfrmProblems.Create(Self);
                    frmProblems.Parent := pnlPage;
                  end;
    CT_MEDS     : begin
                    frmMeds := TfrmMeds.Create(Self);
                    frmMeds.Parent := pnlPage;
                    frmMeds.InitfMedsSize;
                  end;
    CT_ORDERS   : begin
                    frmOrders := TfrmOrders.Create(Self);
                    frmOrders.Parent := pnlPage;
                  end;
    CT_HP       : begin
                    // not yet
                  end;
    CT_NOTES    : begin
                    frmNotes := TfrmNotes.Create(Self);
                    frmNotes.Parent := pnlPage;
                  end;
    CT_CONSULTS : begin
                    frmConsults := TfrmConsults.Create(Self);
                    frmConsults.Parent := pnlPage;
                  end;
    CT_DCSUMM   : begin
                    frmDCSumm := TfrmDCSumm.Create(Self);
                    frmDCSumm.Parent := pnlPage;
                  end;
    CT_LABS     : begin
                    frmLabs := TfrmLabs.Create(Self);
                    frmLabs.Parent := pnlPage;
                  end;
    CT_REPORTS  : begin
                    frmReports := TfrmReports.Create(Self);
                    frmReports.Parent := pnlPage;
                  end;
    CT_SURGERY  : begin
                    frmSurgery := TfrmSurgery.Create(Self);
                    frmSurgery.Parent := pnlPage;
                  end;
    CT_COVER    : begin
                    frmCoverSheet := TfrmCoverSheet.Create(Self);
                    frmCoverSheet.Parent := pnlPage;
                    CoverSheet.OnRefreshCWAD := RefreshCWAD;
                    CoverSheet.OnRefreshReminders := RemindersChanged;
                  end;
  else
    Exit;
  end;
  if ATabID = CT_COVER then
    begin
      uTabList.Insert(0, IntToStr(ATabID));
      tabPage.Tabs.Insert(0, ALabel);
      tabPage.TabIndex := 0;
    end
  else
    begin
      uTabList.Add(IntToStr(ATabID));
      tabPage.Tabs.Add(ALabel);
    end;
end;

procedure TfrmFrame.ShowHideChartTabMenus(AMenuItem: TMenuItem);
var
  i: integer;
begin
  for i := 0 to AMenuItem.Count - 1 do
    AMenuItem.Items[i].Visible := TabExists(AMenuItem.Items[i].Tag);
end;

function TfrmFrame.TabExists(ATabID: integer): boolean;
begin
  Result := (uTabList.IndexOf(IntToStr(ATabID)) > -1)
end;

procedure TfrmFrame.ReportsOnlyDisplay;
begin

// Configure "Edit" menu:
menuHideAllBut(mnuEdit, mnuEditPref);     // Hide everything under Edit menu except Preferences.
menuHideAllBut(mnuEditPref, Prefs1); // Hide everything under Preferences menu except Fonts.

// Remaining pull-down menus:
mnuView.visible := false;
mnuFileRefresh.visible := false;
mnuFileEncounter.visible := false;
mnuFileReview.visible := false;
mnuFileNext.visible := false;
mnuFileNotifRemove.visible := false;
mnuHelpBroker.visible := false;
mnuHelpLists.visible := false;
mnuHelpSymbols.visible := false;

// Top panel components:
pnlVisit.hint := 'Provider/Location';
pnlVisit.onMouseDown := nil;
pnlVisit.onMouseUp := nil;

// Forms for other tabs:
frmCoverSheet.visible := false;
frmProblems.visible := false;
frmMeds.visible := false;
frmOrders.visible := false;
frmNotes.visible := false;
frmConsults.visible := false;
frmDCSumm.visible := false;
if Assigned(frmSurgery) then
  frmSurgery.visible := false;
frmLabs.visible := false;

// Other tabs (so to speak):
tabPage.tabs.clear;
tabPage.tabs.add('Reports');

end;

procedure TfrmFrame.UpdatePtInfoOnRefresh;
var
  tmpDFN: string;
begin
  tmpDFN := Patient.DFN;
  Patient.Clear;
  Patient.DFN := tmpDFN;
  pnlOtherInfo.Caption := '';
  pnlOtherInfo.Repaint;
  uCore.TempEncounterLoc := 0;  //hds7591  Clinic/Ward movement.
  uCore.TempEncounterLocName := ''; //hds7591  Clinic/Ward movement.
  uCore.TempEncounterText := '';
  uCore.TempEncounterDateTime := 0;
  uCore.TempEncounterVistCat := #0;
  if (not FRefreshing) and (FReviewClick = false) then DoNotChangeEncWindow := false;
  if (FPrevInPatient and Patient.Inpatient) then                //transfering inside hospital
    begin
          if FReviewClick = True then
            begin
              ucore.TempEncounterLoc := Encounter.Location;
              uCore.TempEncounterLocName := Encounter.LocationName;
              uCore.TempEncounterText := Encounter.LocationText;
              uCore.TempEncounterDateTime := Encounter.DateTime;
              uCore.TempEncounterVistCat := Encounter.VisitCategory;
            end
          else if (patient.Location <> encounter.Location) and (OrderPrintForm = false) then
                begin
                  TfrmPrintLocation.SwitchEncounterLoction(Encounter.Location, Encounter.locationName, Encounter.LocationText,
                                                          Encounter.DateTime, Encounter.VisitCategory);
                  DisplayEncounterText;
                  exit;
                end
          else if (patient.Location <> encounter.Location) and (OrderPrintForm = True) then
            begin
              OrderPrintForm := false;
              Exit;
            end;
          if orderprintform = false then Encounter.Location := Patient.Location;
    end
  else if (FPrevInPatient and (not Patient.Inpatient)) then     //patient was discharged
  begin
    Encounter.Inpatient := False;
    Encounter.Location := 0;
    FPrevInPatient := False;
    lblPtName.Caption := '';
    lblPtName.Caption := Patient.Name + Patient.Status; //CQ #17491: Refresh patient status indicator in header bar on discharge.
  end
  else if ((not FPrevInPatient) and Patient.Inpatient) then     //patient was admitted
  begin
    Encounter.Inpatient := True;
    uCore.TempEncounterLoc := Encounter.Location;  //hds7591  Clinic/Ward movement.
    uCore.TempEncounterLocName := Encounter.LocationName; //hds7591  Clinic/Ward movement.
    uCore.TempEncounterText := Encounter.LocationText;
    uCore.TempEncounterDateTime := Encounter.DateTime;
    uCore.TempEncounterVistCat := Encounter.VisitCategory;
    lblPtName.Caption := '';
    lblPtName.Caption := Patient.Name + Patient.Status; //CQ #17491: Refresh patient status indicator in header bar on admission.
    if (FReviewClick = False) and (encounter.Location <> patient.Location) and (OrderPrintForm = false) then
        begin
          TfrmPrintLocation.SwitchEncounterLoction(Encounter.Location, Encounter.locationName, Encounter.LocationText,
                                                Encounter.DateTime, Encounter.VisitCategory);
          //agp values are reset depending on the user process
          uCore.TempEncounterLoc := 0;  //hds7591  Clinic/Ward movement.
          uCore.TempEncounterLocName := ''; //hds7591  Clinic/Ward movement.
          uCore.TempEncounterText := '';
          uCore.TempEncounterDateTime := 0;
          uCore.TempEncounterVistCat := #0;
        end
    else
    if OrderPrintForm = false then
      begin
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
    FPrevInPatient := True;
  end;
  DisplayEncounterText;
  frmNotes.UpdateNotesCaption(True);
  setOtherInfoPanel;
end;

procedure TfrmFrame.UpdateVAAMHVButtons(Sender: TObject);
begin
  Patient.RefreshVAAStatus;
  Patient.RefreshMHVStatus;

  if Patient.PtIsVAA then
    laVAA2.Hint := 'Patient has active insurance'
  else
    laVAA2.Hint := 'No active insurance';

  if Patient.PtIsMHV then
    laMHV.Hint := 'Patient has data in My HealtheVet'
  else
    laMHV.Hint := 'No MyHealthyVet data';

  if ScreenReaderActive then
  begin
    laVAA2.Caption := laVAA2.Hint;
    laMHV.Caption := laMHV.Hint;
    amgrMain.AccessText[laVAA2] := laVAA2.Hint;
    amgrMain.AccessText[laMHV] := laMHV.Hint;
  end;

  laMHV.Align := alTop;
  laMHV.Height := paVAA.ClientHeight div 2;
  laVAA2.Align := alClient;

  laMHV.Enabled := Patient.PtIsMHV;
  laVAA2.Enabled := Patient.PtIsVAA;

  paVAA.Visible := (Patient.PtIsVAA or Patient.PtIsMHV) or ScreenReaderActive;
end;

procedure TfrmFrame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewTabIndex: integer;
begin
  inherited;
  FCtrlTabUsed := FALSE;
  //CQ2844: Toggle Remote Data button using Alt+R
   case Key of
     82,114:  if (ssAlt in Shift) then
                 frmFrame.pnlCIRNClick(Sender);
     end;

  if (Key = VK_TAB) then
  begin
    if (ssCtrl in Shift) then
    begin
      FCtrlTabUsed := TRUE;
      if not (ActiveControl is TCustomMemo) or not TMemo(ActiveControl).WantTabs then begin
        NewTabIndex := tabPage.TabIndex;
        if ssShift in Shift then
          dec(NewTabIndex)
        else
          inc(NewTabIndex);
        if NewTabIndex >= tabPage.Tabs.Count then
          dec(NewTabIndex,tabPage.Tabs.Count)
        else if NewTabIndex < 0 then
          inc(NewTabIndex,tabPage.Tabs.Count);
        tabPage.TabIndex := NewTabIndex;
        tabPageChange(tabPage);
        Key := 0;
      end;
    end;
  end;
end;

type
  TMyApplication = class(TApplication);

procedure TfrmFrame.ForceCloseTimer(Sender: TObject);
const
  MAX_TRIES = 50;

var
  Msg: TMsg;
  i: integer;
  done: boolean;

begin
  FForceCloseTimer.Enabled := False;
  ForceCloseAllDLLs;
  Close;
  // Finish up any message processing before calling Idle
  i := 0;
  repeat
    Done := True;
    TResponsiveGUI.ProcessMessages(True);
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
    begin
      inc(i);
      if i < MAX_TRIES then
        done := False;
    end;
  until done;
  TMyApplication(Application).Idle(Msg);
  // Note that the halt here is REQUIRED because if this timer is called it will
  // most likely have been called by a DLL processing messages, not CPRS.
  // Because ForceCloseAllDLLs will terminate the DLL, returning from this
  // message will send the CPU into code that has been unloaded, resulting in
  // a runtime error.
  halt;
end;

procedure TfrmFrame.FormActivate(Sender: TObject);
var
  aCPRS508: ICPRS508;
begin
  if Assigned(FLastPage) then
    if FLastPage.InheritsFrom(TfrmPage) then
      TfrmPage(FLastPage).FocusFirstControl
    else if Supports(fLastPage, ICPRS508, aCPRS508) then
      aCPRS508.OnFocusFirstControl(Sender);;
end;

procedure TfrmFrame.pnlPrimaryCareEnter(Sender: TObject);
begin
  with Sender as TPanel do
    if (ControlCount > 0) and (Controls[0] is TSpeedButton) and (TSpeedButton(Controls[0]).Down)
    then
      BevelInner := bvLowered
    else
      BevelInner := bvRaised;
end;

procedure TfrmFrame.pnlPrimaryCareExit(Sender: TObject);
var
  ShiftIsDown,TabIsDown : boolean;
begin
  with Sender as TPanel do begin
    BevelInner := bvNone;
    //Make the lstCIRNLocations act as if between pnlCIRN & pnlReminders
    //in the Tab Order
    if (lstCIRNLocations.CanFocus) then
    begin
      ShiftIsDown := Boolean(Hi(GetKeyState(VK_SHIFT)));
      TabIsDown := Boolean(Hi(GetKeyState(VK_TAB)));
      if TabIsDown then
        if (ShiftIsDown) and (Name = 'pnlReminders') then
          lstCIRNLocations.SetFocus
        else if Not (ShiftIsDown) and (Name = 'pnlCIRN') then
          lstCIRNLocations.SetFocus;
    end;
  end;
end;

procedure TfrmFrame.pnlPatientClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass; //wat cq 18425 added hourglass and disabled mnuFileOpen
  mnuFileOpen.Enabled := False;
  try
  pnlPatient.Enabled := false;
  ViewInfo(mnuViewDemo);
  pnlPatient.Enabled := true;
  finally
    Screen.Cursor := crDefault;
    mnuFileOpen.Enabled := True;
  end;
end;

procedure TfrmFrame.pnlVisitClick(Sender: TObject);
begin
  ViewInfo(mnuViewVisits);
end;

procedure TfrmFrame.pnlPrimaryCareClick(Sender: TObject);
begin
  ViewInfo(mnuViewPrimaryCare);
end;

procedure TfrmFrame.pnlRemindersClick(Sender: TObject);
begin
  if(pnlReminders.tag = HAVE_REMINDERS) then
      ViewInfo(mnuViewReminders);

end;

procedure TfrmFrame.pnlPostingsClick(Sender: TObject);
begin
  ViewInfo(mnuViewPostings);
end;

//=========================== PDMP =============================================
procedure TfrmFrame.pdmpAlign;
var
  iLeft, aTabOrder: Integer;
begin
  if not assigned(fPDMPMgr) then
    exit;

  if not fPDMPMgr.Visible then
    exit;

  if pnlOTHD.Visible then
  begin
    iLeft := pnlOTHD.Left;
    aTabOrder := pnlOTHD.TabOrder;
  end else
  begin
    iLeft := paVAA.Left;
    aTabOrder := paVAA.TabOrder;
  end;

  fPDMPMgr.Left := iLeft - fPDMPMgr.Width;
  fPDMPMgr.TabOrder := aTabOrder;
  TResponsiveGUI.ProcessMessages;
end;

procedure TfrmFrame.pdmpCloseReport;
begin
  if assigned(pdmpNonModal) and pdmpNonModal.Visible then
  begin
    pdmpNonModal.Close;
    FreeAndNil(pdmpNonModal);
  end;
end;

procedure TfrmFrame.pdmpSetup(aPatientDFN: String = '');
var
  sl: TStrings;

begin
  pdmpGetParams;
  if not PDMP_ENABLED then
    exit;
  if not assigned(PDMP1) then
    exit; // no PDMP for R/O CPRS user

  if not assigned(fPDMPMgr) then
  begin
    Application.CreateForm(TfrmPDMP, fPDMPMgr);
    setFormParented(fPDMPMgr, pnlToolbar, alRight, PDMP_ShowButton = 'ALWAYS');
    fPDMPMgr.Status := 0;
    fPDMPMgr.updateFont;
  end;

  if assigned(fPDMPMgr.PDMPData) and (fPDMPMgr.PDMPData.PatIEN <> aPatientDFN)
  then
  begin
    fPDMPMgr.PDMPData.pdmpClearData; // No clearing on Pt refresh
    pdmpCloseReport; // closing Window with PDMP report
  end;

  if (aPatientDFN <> '') then
  begin
    sl := TStringList.Create;
    try
      fPDMPMgr.CachedData := pdmpGetCache(Patient.DFN, IntToStr(User.DUZ), sl);
      acPDMPReview.Enabled := fPDMPMgr.CachedData;
      acPDMPRequest.Enabled := not fPDMPMgr.CachedData;
      acPDMPCancel.Enabled := False; // not expecting to run the request
      if fPDMPMgr.CachedData then
        fPDMPMgr.doCache(Patient.DFN, sl)
      else if (not Assigned(fPDMPMgr.PDMPData)) or (fPDMPMgr.PDMPData.PatIEN <> aPatientDFN) then
        fPDMPMgr.getLastReviewDate(Patient.DFN);
    finally
      sl.Free;
    end;
  end
  else
    fPDMPMgr.getLastReviewDate('');

  fPDMPMgr.Visible := PDMP_ShowButton = 'ALWAYS';

  TResponsiveGUI.ProcessMessages;
end;

procedure TfrmFrame.acPDMPCancelExecute(Sender: TObject);
begin
  inherited;
  if assigned(fPDMPMgr) then
    fPDMPMgr.acCancel.Execute;

  if assigned(fPDMPMgr) then
    begin
      acPDMPRequest.Enabled := fPDMPMgr.Status = UM_PDMP_Done;
      acPDMPReview.Enabled := fPDMPMgr.Status = UM_PDMP_Ready;
      acPDMPCancel.Enabled := fPDMPMgr.Status = UM_PDMP_Loading;
    end;
  pdmpAlign;
end;

procedure TfrmFrame.acPDMPRequestExecute(Sender: TObject);
begin
  inherited;
  if not assigned(fPDMPMgr) then
  begin
    Application.CreateForm(TfrmPDMP, fPDMPMgr);
    setFormParented(fPDMPMgr, pnlToolbar, alRight);
  end;

  fPDMPMgr.Status := 0;
  fPDMPMgr.updateFont;
  fPDMPMgr.Requester := self;

  acPDMPRequest.Enabled := False;
  fPDMPMgr.acPDMPRequest.Execute;
  if assigned(fPDMPMgr) then
    acPDMPRequest.Enabled := fPDMPMgr.Status = UM_PDMP_Done;

  pdmpAlign;
end;

procedure TfrmFrame.acPDMPReviewExecute(Sender: TObject);
begin
  inherited;
  if assigned(fPDMPMgr) then
  begin
    fPDMPMgr.UseDefaultBrowser := PDMP_UseDefaultBrowser;
    acPDMPReview.Enabled := False;
    fPDMPMgr.acResults.Execute;
    fPDMPMgr.Requester := self;

    acPDMPReview.Enabled := fPDMPMgr.Status = UM_PDMP_Ready;
  end;
  pnlPrimaryCare.Invalidate; // redraw panel
  pdmpAlign;
end;

procedure TfrmFrame.pdmpRun(anAlign: TAlign);
begin
  if not assigned(fPDMPMgr) then
  begin
    Application.CreateForm(TfrmPDMP, fPDMPMgr);
    setFormParented(fPDMPMgr, pnlToolbar, alRight);

    fPDMPMgr.AlignView := anAlign;
    fPDMPMgr.ShowNow := True;
  end
  else
  begin
  end;
  case fPDMPMgr.Status of
    0, UM_PDMP_Done:
      fPDMPMgr.acPDMPRequestExecute(nil);
    UM_PDMP_Ready:
      fPDMPMgr.acResultsExecute(nil);
  else
    begin
      fPDMPMgr.ShowNow := False;
      fPDMPMgr.Requester := nil;
      infoBox('Wait for PDMP to finish the request', 'PDMP',
        MB_ICONINFORMATION or MB_OK);
    end;
  end;
end;

//======================================================================

procedure TfrmFrame.acResetParamsExecute(Sender: TObject);
begin
  inherited;
  ClearSystemParameters
end;

//=========================== CCOW main changes ========================

procedure TfrmFrame.HandleCCOWError(AMessage: string);
begin
  {$ifdef DEBUGCCOW}
    Show508Message(AMessage);
  {$endif}
  InfoBox(TX_CCOW_ERROR, TC_CCOW_ERROR, MB_ICONERROR or MB_OK);
  FCCOWInstalled := False;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_BROKEN');
  pnlCCOW.Hint := TX_CCOW_BROKEN;
  mnuFileResumeContext.Visible := True;
  mnuFileResumeContext.Enabled := False;
  mnuFileBreakContext.Visible := True;
  mnuFileBreakContext.Enabled := False;
  FCCOWError := True;
end;

function TfrmFrame.AllowCCOWContextChange(var CCOWResponse: UserResponse; NewDFN: string): boolean;
var
  PtData : IContextItemCollection;
  PtDataItem2, PtDataItem3, PtDataItem4 : IContextItem;
  response : UserResponse;
  StationNumber: string;
  IsProdAcct: boolean;
begin
  Result := False;
  response := 0;
  try
    // Start a context change transaction
    if FCCOWInstalled then
       begin
//          FCCOWJustJoined := False;
          FCCOWError := False;
          imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_CHANGING');
          pnlCCOW.Hint := TX_CCOW_CHANGING;
          try
            ctxContextor.StartContextChange();
          except
            on E: Exception do HandleCCOWError(E.Message);
          end;
          if FCCOWError then
          begin
            Result := False;
            Exit;
          end;
          // Set the new proposed context data.
          PtData := CoContextItemCollection.Create();
          StationNumber := User.StationNumber;
          IsProdAcct := User.IsProductionAccount;

          {$IFDEF CCOWBROKER}
          //IsProdAcct := RPCBrokerV.Login.IsProduction;  //not yet
          {$ENDIF}

          PtDataItem2 := CoContextItem.Create();
          PtDataItem2.Set_Name('Patient.co.PatientName');                // Patient.Name
          PtDataItem2.Set_Value(Piece(Patient.Name, ',', 1) + U + Piece(Patient.Name, ',', 2) + '^^^^');
          PtData.Add(PtDataItem2);

          PtDataItem3 := CoContextItem.Create();
          if not IsProdAcct then
            PtDataItem3.Set_Name('Patient.id.MRN.DFN_' + StationNumber + '_TEST')    // Patient.DFN
          else
            PtDataItem3.Set_Name('Patient.id.MRN.DFN_' + StationNumber);             // Patient.DFN
          PtDataItem3.Set_Value(Patient.DFN);
          PtData.Add(PtDataItem3);

          if Patient.ICN <> '' then
            begin
              PtDataItem4 := CoContextItem.Create();
              if not IsProdAcct then
                PtDataItem4.Set_Name('Patient.id.MRN.NationalIDNumber_TEST')   // Patient.ICN
              else
                PtDataItem4.Set_Name('Patient.id.MRN.NationalIDNumber');       // Patient.ICN
              PtDataItem4.Set_Value(Patient.ICN);
              PtData.Add(PtDataItem4);
            end;

          // End the context change transaction.
          FCCOWError := False;
          try
            response := ctxContextor.EndContextChange(true, PtData);
          except
            on E: Exception do HandleCCOWError(E.Message);
          end;
          if FCCOWError then
          begin
            HideEverything;
            Result := False;
            Exit;
          end;
       end
    else
      begin
        Result := True;
        Exit;
      end;

    CCOWResponse := response;
    if (response = UrCommit) then
    begin
      // New context is committed.
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
      FCCOWIconName := 'BMP_CCOW_LINKED';
      pnlCCOW.Hint := TX_CCOW_LINKED;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      Result := True;
    end
    else if (response = UrCancel) then
    begin
      // Proposed context change is canceled. Return to the current context.
      PtData.RemoveAll;
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      Result := False;
    end
    else if (response = UrBreak) then
    begin
      // The contextor has broken the link by suspending.  This app should
      // update the Clinical Link icon, enable the Resume menu item, and
      // disable the Suspend menu item.
      PtData.RemoveAll;
      mnuFileResumeContext.Enabled := True;
      mnuFileBreakContext.Enabled := False;
      FCCOWIconName := 'BMP_CCOW_BROKEN';
      pnlCCOW.Hint := TX_CCOW_BROKEN;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      if Patient.Inpatient then
      begin
        Encounter.Inpatient := True;
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
      if User.IsProvider then Encounter.Provider := User.DUZ;
      SetupPatient;
      tabPage.TabIndex := PageIDToTab(User.InitialTab);
      tabPageChange(tabPage);
      Result := False;
    end;
  except
    on exc : EOleException do
      ShowMsg('EOleException: ' + exc.Message);
  end;
end;

procedure TfrmFrame.ctxContextorCanceled(Sender: TObject);
begin
  // Application should maintain its state as the current (existing) context.
  // Icon will rest if there is something to reset to
  If Trim(FCCOWIconName) <> '' then
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
end;

procedure TfrmFrame.ctxContextorPending(Sender: TObject;
  const aContextItemCollection: IDispatch);
var
  Reason, HyperLinkReason: string;
  PtChanged: boolean;
{$IFDEF CCOWBROKER}
  UserChanged: boolean;
{$ENDIF}
begin
  // If the app would lose data, or have other problems changing context at
  // this time, it should return a message using SetSurveyReponse. Note that the
  // user may decide to commit the context change anyway.
  //
  // if (cannot-change-context-without-a-problem) then
  //   contextor.SetSurveyResponse('Conditional accept reason...');
  if FCCOWBusy then
  begin
    Sleep(10000);
  end;

  FCCOWError := False;
  try
    CheckForDifferentPatient(aContextItemCollection, PtChanged);
{$IFDEF CCOWBROKER}
    CheckForDifferentUser(aContextItemCollection, UserChanged);
{$ENDIF}
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then
  begin
    HideEverything;
    Exit;
  end;

{$IFDEF CCOWBROKER}
  if PtChanged or UserChanged then
{$ELSE}
  if PtChanged then
{$ENDIF}
    begin
      FCCOWContextChanging := True;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_CHANGING');
      pnlCCOW.Hint := TX_CCOW_CHANGING;
      AllowContextChangeAll(Reason);
    end;
  CheckHyperlinkResponse(aContextItemCollection, HyperlinkReason);
  Reason := HyperlinkReason + Reason;
  if Pos('COM_OBJECT_ACTIVE', Reason) > 0 then
    Sleep(12000)
  else if Length(Reason) > 0 then
    ctxContextor.SetSurveyResponse(Reason)
  else
    begin
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, 'BMP_CCOW_LINKED');
      pnlCCOW.Hint := TX_CCOW_LINKED;
    end;
  FCCOWContextChanging := False;
end;

procedure TfrmFrame.ctxContextorCommitted(Sender: TObject);
var
  Reason: string;
  PtChanged: boolean;
  i: integer;
begin
  // Application should now access the new context and update its state.
  FCCOWError := False;
  try
  {$IFDEF CCOWBROKER}
    with RPCBrokerV do if (WasUserDefined and IsUserCleared and (ctxContextor.CurrentContext.Present(CCOW_USER_NAME) = nil)) then    // RV 05/11/04
    begin
      Reason := 'COMMIT';
      if AllowContextChangeAll(Reason) then
      begin
        Close;
        Exit;
      end;
    end;
  {$ENDIF}
    CheckForDifferentPatient(ctxContextor.CurrentContext, PtChanged);
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then
  begin
    HideEverything;
    Exit;
  end;
  if not PtChanged then exit;
  FCCOWDrivedChange := True;
  i := 0;
  while Length(Screen.Forms[i].Name) > 0 do
  begin
    if fsModal in Screen.Forms[i].FormState then
    begin
      Screen.Forms[i].ModalResult := mrCancel;
      i := i + 1;
    end else  // the fsModal forms always sequenced prior to the none-fsModal forms
      Break;
  end;
  Reason := 'COMMIT';
  if AllowContextChangeAll(Reason) then UpdateCCOWContext;
  FCCOWIconName := 'BMP_CCOW_LINKED';
  pnlCCOW.Hint := TX_CCOW_LINKED;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
end;

function TfrmFrame.FindBestCCOWDFN: string;
var
  data: IContextItemCollection;
  anItem: IContextItem;
  StationNumber, tempDFN: string;
  IsProdAcct:  Boolean;

  procedure FindNextBestDFN;
  begin
    StationNumber := User.StationNumber;
    if IsProdAcct then
      anItem := data.Present('Patient.id.MRN.DFN_' + StationNumber)
    else
      anItem := data.Present('Patient.id.MRN.DFN_' + StationNumber + '_TEST');
    if anItem <>  nil then tempDFN := anItem.Get_Value();
  end;

begin
  if uCore.User = nil then
  begin
    Result := '';
    exit;
  end;
  IsProdAcct := User.IsProductionAccount;
  // Get an item collection of the current context
  FCCOWError := False;
  try
    data := ctxContextor.CurrentContext;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then
  begin
    HideEverything;
    Exit;
  end;
  // Retrieve the ContextItem name and value as strings
  if IsProdAcct then
    anItem := data.Present('Patient.id.MRN.NationalIDNumber')
  else
    anItem := data.Present('Patient.id.MRN.NationalIDNumber_TEST');
  if anItem <> nil then
    begin
      tempDFN := GetDFNFromICN(anItem.Get_Value());			 // "Public" RPC call
      if tempDFN = '-1' then FindNextBestDFN;
    end
  else
    FindNextBestDFN;
  Result := tempDFN;
  data := nil;
  anItem := nil;
end;

function TfrmFrame.FindNextControl(CurControl: TWinControl; GoForward,
  CheckTabStop, CheckParent: Boolean): TWinControl;
// Changing the visibility of this to public for frmFrame
begin
  Result := inherited FindNextControl(CurControl, GoForward,  CheckTabStop,
    CheckParent);
end;

procedure TfrmFrame.UpdateCCOWContext;
var
  PtDFN(*, PtName*): string;
begin
  if not FCCOWInstalled then exit;
  DoNotChangeEncWindow := false;
  PtDFN := FindBestCCOWDFN;
  if StrToInt64Def(PtDFN, 0) > 0 then
    begin
      // Select new patient based on context value
      if Patient.DFN = PtDFN then exit;
      Patient.DFN := PtDFN;
      if (Patient.Name = '-1') then
        begin
          HideEverything;
          exit;
        end
      else
        ShowEverything;
      Encounter.Clear;
      if Patient.Inpatient then
      begin
        Encounter.Inpatient := True;
        Encounter.Location := Patient.Location;
        Encounter.DateTime := Patient.AdmitTime;
        Encounter.VisitCategory := 'H';
      end;
      if User.IsProvider then Encounter.Provider := User.DUZ;
      if not FFirstLoad then SetupPatient;
      { frmCover.UpdateVAAButton; //VAA}
      UpdateVAAMHVButtons(nil);
      DetermineNextTab;
      tabPage.TabIndex := PageIDToTab(NextTab);
      tabPageChange(tabPage);
    end
  else
    HideEverything;
end;

procedure TfrmFrame.mnuFileBreakContextClick(Sender: TObject);
begin
  FCCOWError := False;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  try
    ctxContextor.Suspend;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  FCCOWIconName := 'BMP_CCOW_BROKEN';
  pnlCCOW.Hint := TX_CCOW_BROKEN;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  mnuFileResumeContext.Enabled := True;
  mnuFileBreakContext.Enabled := False;
end;

procedure TfrmFrame.mnuFileResumeContextGetClick(Sender: TObject);
var
  Reason: string;
begin
  Reason := '';
  if not AllowContextChangeAll(Reason) then exit;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  FCCOWError := False;
  try
    ctxContextor.Resume;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  UpdateCCOWContext;
  if not FNoPatientSelected then
  begin
    FCCOWIconName := 'BMP_CCOW_LINKED';
    pnlCCOW.Hint := TX_CCOW_LINKED;
    imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
    mnuFileResumeContext.Enabled := False;
    mnuFileBreakContext.Visible := True;
    mnuFileBreakContext.Enabled := True;
  end;
end;

procedure TfrmFrame.mnuFileResumeContextSetClick(Sender: TObject);
var
  CCOWResponse: UserResponse;
  Reason: string;
begin
  Reason := '';
  if not AllowContextChangeAll(Reason) then exit;
  FCCOWIconName := 'BMP_CCOW_CHANGING';
  pnlCCOW.Hint := TX_CCOW_CHANGING;
  imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
  FCCOWError := False;
  try
    ctxContextor.Resume;
  except
    on E: Exception do HandleCCOWError(E.Message);
  end;
  if FCCOWError then exit;
  if (AllowCCOWContextChange(CCOWResponse, Patient.DFN)) then
    begin
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Visible := True;
      mnuFileBreakContext.Enabled := True;
      FCCOWIconName := 'BMP_CCOW_LINKED';
      pnlCCOW.Hint := TX_CCOW_LINKED;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
    end
  else
    begin
      mnuFileResumeContext.Enabled := True;
      mnuFileBreakContext.Enabled := False;
      FCCOWIconName := 'BMP_CCOW_BROKEN';
      pnlCCOW.Hint := TX_CCOW_BROKEN;
      imgCCOW.Picture.BitMap.LoadFromResourceName(hInstance, FCCOWIconName);
      try
        if ctxContextor.State in [csParticipating] then ctxContextor.Suspend;
      except
        on E: Exception do HandleCCOWError(E.Message);
      end;
   end;
  SetupPatient;
  tabPage.TabIndex := PageIDToTab(User.InitialTab);
  tabPageChange(tabPage);
end;

procedure TfrmFrame.CheckForDifferentPatient(aContextItemCollection: IDispatch; var PtChanged: boolean);
var
  data : IContextItemCollection;
  anItem: IContextItem;
  PtDFN, PtName: string;
begin
  if uCore.Patient = nil then
  begin
    PtChanged := False;
    Exit;
  end;
  data := IContextItemCollection(aContextItemCollection) ;
  PtDFN := FindBestCCOWDFN;
  // Retrieve the ContextItem name and value as strings
  anItem := data.Present('Patient.co.PatientName');
  if anItem <> nil then PtName := anItem.Get_Value();
  PtChanged := not ((PtDFN = Patient.DFN) and (PtName = Piece(Patient.Name, ',', 1) + U + Piece(Patient.Name, ',', 2) + '^^^^'));
end;

{$IFDEF CCOWBROKER}
procedure TfrmFrame.CheckForDifferentUser(aContextItemCollection: IDispatch; var UserChanged: boolean);
var
  data : IContextItemCollection;
begin
  if uCore.User = nil then
  begin
    UserChanged := False;
    Exit;
  end;
  data := IContextItemCollection(aContextItemCollection) ;
  UserChanged := RPCBrokerV.IsUserContextPending(data);
end;
{$ENDIF}

procedure TfrmFrame.CheckHyperlinkResponse(aContextItemCollection: IDispatch; var HyperlinkReason: string);
var
  data : IContextItemCollection;
  anItem : IContextItem;
  itemvalue: string;
  PtSubject: string;
begin
  data := IContextItemCollection(aContextItemCollection) ;
  anItem := data.Present('[hds_domain.ext]request.id.name');
  // Retrieve the ContextItem name and value as strings
  if anItem <> nil then
    begin
      itemValue := anItem.Get_Value();
      if itemValue = 'GetWindowHandle' then
        begin
          PtSubject := 'patient.id.mrn.dfn_' + User.StationNumber;
          if not User.IsProductionAccount then PtSubject := PtSubject + '_test';
          if data.Present(PtSubject) <> nil then
            HyperlinkReason := '!@#$' + IntToStr(Self.Handle) + ':0:'
          else
            HyperlinkReason := '';
        end;
    end;
end;

function TfrmFrame.checkOtherForms(var Reason: String): boolean;
var
i: integer;
begin
  result := true;
  if not frmFrame.CCOWContextChanging then exit;
  for i := 0 to screen.FormCount - 1 do
    begin
      if (screen.Forms[i].Name = 'frmWVPregLacStatusUpdate') and
       (screen.Forms[i].Showing) then
        begin
          Reason := 'Pregnancy and Lactation Status Update in progress, documentation will be discarded.';
          result := false;
          exit;
        end;
      if (screen.Forms[i].Name = 'vimmMainForm') and
       (screen.Forms[i].Showing) then
        begin
          Reason := 'Immunization/Skin Test Update in progress, documentation will be discarded.';
          result := false;
          exit;
        end;
    end;
end;

procedure TfrmFrame.HideEverything(AMessage: string = 'No patient is currently selected.');
begin
  FNoPatientSelected := TRUE;
  pnlNoPatientSelected.Caption := AMessage;
  pnlNoPatientSelected.Visible := True;
  pnlNoPatientSelected.BringToFront;
  mnuFileReview.Enabled := False;
  mnuFilePrint.Enabled := False;
  mnuFilePrintSelectedItems.Enabled := False;
  mnuFileEncounter.Enabled := False;
  mnuFileNext.Enabled := False;
  mnuFileRefresh.Enabled := False;
  mnuFilePrintSetup.Enabled := False;
  mnuFilePrintSelectedItems.Enabled := False;
  mnuFileNotifRemove.Enabled := False;
  mnuFileResumeContext.Enabled := False;
  mnuFileBreakContext.Enabled := False;
  mnuEdit.Enabled := False;
  mnuView.Enabled := False;
  mnuTools.Enabled := False;
  if FNextButtonActive then FNextButton.Visible := False;
end;

procedure TfrmFrame.mnuShowActivityLogClick(Sender: TObject);
begin
  inherited;
  if not Assigned(frmActivityLogDisplay) then
    frmActivityLogDisplay := TfrmActivityLogDisplay.Create(Self);
  if frmActivityLogDisplay.WindowState = TWindowState.wsMinimized then
    frmActivityLogDisplay.WindowState := TWindowState.wsNormal;
  frmActivityLogDisplay.Show;
  frmActivityLogDisplay.BringToFront;
end;

procedure TfrmFrame.ShowEverything;
begin
  FNoPatientSelected := FALSE;
  pnlNoPatientSelected.Caption := '';
  pnlNoPatientSelected.Visible := False;
  pnlNoPatientSelected.SendToBack;
  mnuFileReview.Enabled := True;
  mnuFilePrint.Enabled := True;
  mnuFileEncounter.Enabled := True;
  mnuFileNext.Enabled := True;
  mnuFileRefresh.Enabled := True;
  mnuFilePrintSetup.Enabled := True;
  mnuFilePrintSelectedItems.Enabled := True;
  mnuFileNotifRemove.Enabled := True;
  if not FCCOWError then
  begin
    if FCCOWIconName= 'BMP_CCOW_BROKEN' then
    begin
      mnuFileResumeContext.Enabled := True;
      mnuFileBreakContext.Enabled := False;
    end else
    begin
      mnuFileResumeContext.Enabled := False;
      mnuFileBreakContext.Enabled := True;
    end;
  end;
  mnuEdit.Enabled := True;
  mnuView.Enabled := True;
  mnuTools.Enabled := True;
  if FNextButtonActive then FNextButton.Visible := True;
//  setOtherInfoPanel;
end;


procedure TfrmFrame.pnlFlagMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlFlag.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlFlagMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlFlag.BevelOuter := bvRaised;
end;

////////////////////////////////////////////////////////////////////////////////
// OTHD
////////////////////////////////////////////////////////////////////////////////

procedure TfrmFrame.ClearOTHD;
begin
  lblOTHDTitle.Caption  := '';  // rpk 3/27/2019
  lblOTHDDtl.Caption       := '';  // rpk 12/5/2017
  pnlOTHD.Hide;                 // rpk 12/6/2017
  pnlOTHD.Enabled       := False; // rpk 12/6/2017
  pnlOTHD.Color         := clBtnFace;  // rpk 4/12/2018
  lblOTHDDtl.Enabled       := False; // rpk 4/6/2018
  lblOTHDDtl.Color         := clBtnFace;  // rpk 4/12/2018
  lblOTHDDtl.Font.Color    := clWindowText; // rpk 4/12/2018
  lblOTHDDtl.Transparent   := True; // rpk 4/13/2018
  lblOTHDTitle.Enabled  := False; // rpk 12/6/2017
  lblOTHDTitle.Color    := clBtnFace; // rpk 4/13/2018
  lblOTHDTitle.Font.Color    := clInfoText;  // rpk 4/12/2018
  lblOTHDTitle.Transparent   := True; // rpk 4/13/2018
  OTHDTitleCaptionStr          := '';  // rpk 3/27/2019
  OTHDTitleHintStr          := '';  // rpk 3/27/2019
  OTHDDtlCaptionStr          := '';  // rpk 1/5/2018
  OTHDDtlHintStr          := '';  // rpk 1/5/2018
  if Assigned(OTHDDspList) then
    OTHDDspList.Clear;  // rpk 4/2/2019
end;

procedure TfrmFrame.updateOTHD;
var
  TitleCaptionStr,
  TitleHintStr,
  DtlCaptionStr,
  DtlHintStr: String;

const
  noOTHD = 'not available';

begin
{ removing comments to roll back changes introduced by v31.261 begin}
    //blj 20 June 2019: RTC task 1062900
    // OTH was commented out as it was not ready for prime time before the release
    // of 31B version 261.  We will need to re-enable at some point.

    pnlOTHD.Hide; //

    if getOTHD(Patient.DFN, Patient.Name, TitleCaptionStr, TitleHintStr,
      DtlCaptionStr, DtlHintStr, OTHDDspList)
      and (pos(noOTHD,TitleHintStr) = 0)
    then
    begin // rpk 1/2/2018
      pnlOTHD.Show; // rpk 12/6/2017
      pnlOTHD.Enabled := True; // rpk 12/6/2017
      pnlOTHD.TabStop := True; // rpk 1/18/2018
      pnlOTHD.Hint := TitleHintStr + CRLF + DtlHintStr;
      lblOTHDDtl.Enabled := True; // rpk 1/2/2018
      lblOTHDTitle.Enabled := True; // rpk 12/6/2017

      OTHDTitleCaptionStr := TitleCaptionStr; // rpk 3/27/2019
      OTHDTitleHintStr := TitleHintStr; // rpk 3/27/2019
      OTHDDtlCaptionStr := DtlCaptionStr;
      OTHDDtlHintStr := DtlHintStr;
      if ScreenReaderActive then
      begin // rpk 1/2/2018
        lblOTHDTitle.Caption := TitleHintStr;
        lblOTHDDtl.Caption := DtlHintStr;
      end
      else
      begin
        lblOTHDTitle.Caption := TitleCaptionStr; // rpk 3/27/2019
        lblOTHDTitle.Hint := TitleHintStr; // rpk 4/2/2019
        lblOTHDDtl.Caption := DtlCaptionStr; // rpk 12/6/2017
        lblOTHDDtl.Hint := DtlHintStr; // rpk 4/3/2019
      end;
    end; // rpk 1/2/2018
{ removing comments to roll back changes introduced by v31.261 end}
end;

procedure TfrmFrame.pnlOTHDClick(Sender: TObject); // rpk 1/5/2018
var
  TmpStr: String;
  I, icnt: Integer;
begin
  inherited;
  if Assigned(OTHDDspList) then begin
    icnt := OTHDDspList.Count;
    if icnt > 0 then begin
      tmpstr := OTHDDspList[0];
      for I := 1 to icnt - 1 do
        tmpstr := tmpstr + CRLF + OTHDDspList[i];
      InfoBox(tmpstr,'OTHD',MB_OK+MB_ICONINFORMATION);  // rpk 2/28/2018
    end;
  end;
end;

const
  M_WVERT = 6;

procedure TfrmFrame.setOTHD(aTitle,aDetails:String);
begin
  lblOTHDTitle.Caption := aTitle;
  lblOTHDDtl.Caption := aDetails;

  pnlOTHD.Width := HigherOf((lblOTHDTitle.Width + (M_WVERT * 2)),
    (lblOTHDDtl.Width + (M_WVERT * 2))); // rpk 12/6/2017
  // center OTH title and data text fields in pnlOTHD
  lblOTHDTitle.left := (pnlOTHD.Width div 2) - (lblOTHDTitle.Width div 2);
  lblOTHDDtl.left := (pnlOTHD.Width div 2) - (lblOTHDDtl.Width div 2);

  // ensure that buttons maintain alRight align
  pnlCVnFlag.left := pnlRemoteData.left - pnlCVnFlag.Width; // rpk 5/9/2019
  paVAA.left := pnlCVnFlag.left - paVAA.Width; // rpk 5/9/2019
  pnlOTHD.left := paVAA.left - pnlOTHD.Width; // rpk 1/4/2018
end;

procedure TfrmFrame.pnlOTHDEnter(Sender: TObject);  // rpk 1/5/2018
begin
  inherited;

  setOTHD(OTHDTitleHintStr,OTHDDtlHintStr);
  with Sender as TPanel do
    BevelInner := bvRaised;
end;

procedure TfrmFrame.pnlOTHDExit(Sender: TObject);  // rpk 1/5/2018
begin
  inherited;
  with Sender as TPanel do
    BevelInner := bvNone;
  setOTHD(OTHDTitleCaptionStr,OTHDDtlCaptionStr);

  lblPtCare.Refresh;
  lblPtAttending.Refresh;
  lblPtMHTC.Refresh;
end;


procedure TfrmFrame.pnlOTHDMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if pnlOTHD.BevelOuter = bvLowered then exit;
  pnlOTHD.BevelOuter := bvLowered;
  with lblOTHDTitle do SetBounds(Left+2, Top+2, Width, Height);
  with lblOTHDDtl   do SetBounds(Left+2, Top+2, Width, Height);
end;

procedure TfrmFrame.pnlOTHDMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if pnlOTHD.BevelOuter = bvRaised then exit;
  pnlOTHD.BevelOuter := bvRaised;
  with lblOTHDTitle do SetBounds(Left-2, Top-2, Width, Height);
  with lblOTHDDtl  do SetBounds(Left-2, Top-2, Width, Height);
end;

//////////////////////////////////////////////////////////////////////////////

procedure TfrmFrame.pnlOtherInfoClick(Sender: TObject);
var
details: TStrings;
begin
  inherited;
  if not fotherPanelShowReportBox then exit;
  details := TStringList.Create;
  try
    otherInformationPanelDetails(patient.DFN, fotherPanelType, details);
    ReportBox(details, self.pnlOtherInfo.Caption, True);
  finally
    FreeAndNil(details);
  end;
end;

procedure TfrmFrame.pnlOtherInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not fotherPanelShowReportBox then exit;
  pnlOtherInfo.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlOtherInfoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if not fotherPanelShowReportBox then exit;
  pnlOtherInfo.BevelOuter := bvRaised;
end;

procedure TfrmFrame.pnlFlagClick(Sender: TObject);
begin
  ViewInfo(mnuViewFlags);
end;

procedure TfrmFrame.mnuFilePrintSelectedItemsClick(Sender: TObject);
begin
    case TabToPageID(tabPage.TabIndex) of
      CT_NOTES:    frmNotes.LstNotesToPrint;
      CT_CONSULTS: frmConsults.LstConsultsToPrint;
      CT_DCSUMM:   frmDCSumm.LstSummsToPrint;
 end; {case}
end;

procedure TfrmFrame.mnuAlertRenewClick(Sender: TObject);
var XQAID: string;
begin
  XQAID := Piece(Notifications.RecordID, '^', 2);
  RenewAlert(XQAID);
end;

procedure TfrmFrame.mnuFileViewNotificationsClick(Sender: TObject);
begin
  ShowPatientNotifications(mnuFileNextClick);
end;

procedure TfrmFrame.mnuAlertForwardClick(Sender: TObject);
var
  XQAID, AlertMsg: string;
begin
  XQAID := Piece(Notifications.RecordID,'^', 2);
  AlertMsg := Piece(Notifications.RecordID, '^', 1);
  RenewAlert(XQAID);  // must renew/restore an alert before it can be forwarded
  ForwardAlertTo(XQAID + '^' + AlertMsg);
end;

procedure TfrmFrame.mnuGECStatusClick(Sender: TObject);
var
ans, Result,str,str1,title: string;
cnt,i: integer;
fin: boolean;

begin
//  Result := sCallV('ORQQPXRM GEC STATUS PROMPT', [Patient.DFN]);
  if CallVistA('ORQQPXRM GEC STATUS PROMPT', [Patient.DFN],Result) and
    (Piece(Result,U,1) <> '0') then
    begin
      title := Piece(Result,U,2);
        if pos('~',Piece(Result,U,1))>0 then
               begin
               str:='';
               str1 := Piece(Result,U,1);
               cnt := DelimCount(str1, '~');
               for i:=1 to cnt+1 do
                   begin
                   if i = 1 then str := Piece(str1,'~',i);
                   if i > 1 then str :=str+CRLF+Piece(str1,'~',i);
                   end;
             end
             else str := Piece(Result,U,1);
        if Piece(Result,U,3)='1' then
          begin
             fin := (InfoBox(str,title, MB_YESNO or MB_DEFBUTTON2)=IDYES);
             if fin = true then ans := '1';
             if fin = false then ans := '0';
//             CallV('ORQQPXRM GEC FINISHED?',[Patient.DFN,ans]);
             CallVistA('ORQQPXRM GEC FINISHED?',[Patient.DFN,ans]);
          end
        else
        InfoBox(str,title, MB_OK);
    end;
end;

procedure TfrmFrame.pnlFlagEnter(Sender: TObject);
begin
  pnlFlag.BevelInner := bvRaised;
  pnlFlag.BevelOuter := bvNone;
  pnlFlag.BevelWidth := 3;
end;

procedure TfrmFrame.pnlFlagExit(Sender: TObject);
begin
  pnlFlag.BevelWidth := 2;
  pnlFlag.BevelInner := bvNone;
  pnlFlag.BevelOuter := bvRaised;
end;

procedure TfrmFrame.tabPageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  TabCtrlClicked := True;
end;

procedure TfrmFrame.tabPageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LastTab := TabToPageID((sender as TTabControl).TabIndex);
end;

procedure TfrmFrame.lstCIRNLocationsExit(Sender: TObject);
begin
    //Make the lstCIRNLocations act as if between pnlCIRN & pnlReminders
    //in the Tab Order
  if Boolean(Hi(GetKeyState(VK_TAB))) then
    if Boolean(Hi(GetKeyState(VK_SHIFT))) then
      pnlCIRN.SetFocus
    else
      pnlReminders.SetFocus;
end;

procedure TfrmFrame.AppEventsActivate(Sender: TObject);
begin
  FJustEnteredApp := True;
end;

procedure TfrmFrame.AppEventsIdle(Sender: TObject; var Done: Boolean);
begin
  inherited;
  if FCPRSClosing and FInitCPRSClose then
  begin
    FInitCPRSClose := False;
    Close;
  end;
end;

procedure TfrmFrame.AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  Control: TComponent;
begin
  Handled := false;
  if (Msg.Message = WM_MOUSEWHEEL) and (GetKeyState(VK_LBUTTON) < 0) then
  begin
    Control := FindControl(Msg.hWnd);
    if not assigned(Control) then
      Handled := True
    else if (Control is ComCtrls.TRichEdit) then
    begin
      Handled := True;
      SendMessage(Self.Handle, EM_SETZOOM, 0, 0);
    end;
  end;
  if Msg.Message = UM_OBJDESTROY then
  begin
    if (Msg.WParam <> 0) and (TObject(Msg.WParam) is TComponent) and
      not (csDestroying in TComponent(Msg.WParam).ComponentState) then
      TComponent(Msg.WParam).Free;
    Handled := True;
  end;
  if FCPRSClosing and (Screen.Cursor <> crHourGlass) then
    Screen.Cursor := crHourGlass;
end;

procedure TfrmFrame.ScreenActiveFormChange(Sender: TObject);
begin
  if(assigned(FOldActiveFormChange)) then
    FOldActiveFormChange(Sender);
  //Focus the Form that Stays on Top after the Application Regains focus.
  if FJustEnteredApp then
    FocusApplicationTopForm;
  FJustEnteredApp := false;
end;

procedure TfrmFrame.FocusApplicationTopForm;
var
  I : integer;
  Temp: TList;

begin
  Temp := TList.Create;
  try
    for I := (Screen.FormCount-1) downto 0 do //Set the last one opened last
    begin
      with Screen.Forms[I] do
        if (FormStyle = fsStayOnTop) and (Enabled) and (Visible) then
        // do NOT call SetFocus here - SetFocus changes the order of the Sreen.Forms list.
          Temp.Add(Screen.Forms[I]);
    end;
    for I := 0 to Temp.Count-1 do
      TForm(Temp[I]).SetFocus;
  finally
    Temp.Free;
  end;
end;

procedure TfrmFrame.AppEventsShortCut(var Msg: TWMKey;
  var Handled: Boolean);
begin
  if ((Boolean(Hi(GetKeyState(VK_MENU{ALT})))) and (Msg.CharCode = VK_F1)) then
  begin
    FocusApplicationTopForm;
    Handled := True;
  end;
end;

procedure TfrmFrame.mnuToolsGraphingClick(Sender: TObject);
var
  contexthint: string;
begin
  Screen.Cursor := crHourGlass;
  contexthint := mnuToolsGraphing.Hint;
  if GraphFloat = nil then              // new graph
  begin
    GraphFloat := TfrmGraphs.Create(self);
    try
      with GraphFloat do
      begin
        if btnClose.Tag = 1 then
        begin
          Screen.Cursor := crDefault;
          exit;
        end;
        Initialize;
        Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
        BorderIcons := [biSystemMenu, biMaximize, biMinimize];
        BorderStyle := bsSizeable;
        BorderWidth := 1;
        // context sensitive       type (tabPage.TabIndex)  & [item]
        ResizeAnchoredFormToFont(GraphFloat);
        GraphFloat.pnlFooter.Hint := contexthint;   // context from lab most recent
        Show;
      end;
    finally
      if GraphFloat.btnClose.Tag = 1 then
      begin
        GraphFloatActive := false;
        GraphFloat.Free;
        GraphFloat := nil;
      end
      else
        GraphFloatActive := true;
    end;
  end
  else
  begin
    GraphFloat.Caption := 'CPRS Graphing - Patient: ' + MixedCase(Patient.Name);
    GraphFloat.pnlFooter.Hint := contexthint;   // context from lab most recent
    if GraphFloat.btnClose.Tag = 1 then
    begin
      Screen.Cursor := crDefault;
      exit;
    end
    else if GraphFloatActive and (frmGraphData.pnlData.Hint = Patient.DFN) then
    begin
      if length(GraphFloat.pnlFooter.Hint) > 1 then
      begin
        GraphFloat.Close;
        GraphFloatActive := true;
        GraphFloat.Show;
      end;
      GraphFloat.BringToFront;             // graph is active, same patient
    end
    else if frmGraphData.pnlData.Hint = Patient.DFN then
    begin                                 // graph is not active, same patient
      // context sensitive
      GraphFloat.Show;
      GraphFloatActive := true;
    end
    else
    //with GraphFloat do                    // new patient
    begin
      GraphFloat.InitialRetain;
      GraphFloatActive := false;
      GraphFloat.Free;
      GraphFloat := nil;
      mnuToolsGraphingClick(self);          // delete and recurse
    end;
  end;
  mnuToolsGraphing.Hint := '';
  Screen.Cursor := crDefault;
end;

procedure TfrmFrame.pnlCIRNMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlCIRN.BevelOuter := bvLowered;
end;

procedure TfrmFrame.pnlCIRNMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlCIRN.BevelOuter := bvRaised;
end;

procedure TfrmFrame.laMHVClick(Sender: TObject);
begin
  ViewInfo(mnuViewMyHealtheVet);
end;

procedure TfrmFrame.laVAA2Click(Sender: TObject);
begin
  ViewInfo(mnuInsurance);
end;

var
  uMHV_URL: string = '';

procedure TfrmFrame.ViewInfo(Sender: TObject);
var
  SelectNew: Boolean;
  { TODO 5 -oDanP -cNew CoverSheet : Need to finish the VAA button stuff ASAP! }
  aInsuranceSubscriberName: string;
  aReportText: TStringList;
  aAddress: string;
  ID: integer;
  aCPRS508: ICPRS508;
  sl: TStrings;
begin
  if Sender is TMenuItem then begin
    ID := TMenuItem(Sender).Tag;
  end else if Sender is TAction then begin
    ID := TAction(Sender).Tag;
  end else begin
    ID := -1;
  end;
  case ID of
    1:begin { displays patient inquiry report (which optionally allows new patient to be selected) }
        StatusText(TX_PTINQ);
        PatientInquiry(SelectNew);
        if Assigned(FLastPage) then
          if FLastPage.InheritsFrom(TfrmPage) then
            TfrmPage(FLastPage).FocusFirstControl
          else if Supports(fLastPage, ICPRS508, aCPRS508) then
            aCPRS508.OnFocusFirstControl(Sender);
        StatusText('');
        if SelectNew then mnuFileOpenClick(mnuViewDemo);
      end;
    2:begin
        if (not User.IsReportsOnly) then // Reports Only tab.
          mnuFileEncounterClick(Self);
      end;
    3:begin
        sl := TSTringList.Create;
        try
          setDetailPrimaryCare(sl,Patient.DFN);
          ReportBox(sl, 'Primary Care', True);
        finally
          sl.Free;
        end;
      end;
    4:begin
        if Patient.PtIsMHV then
        begin
          if uMHV_URL = '' then
            uMHV_URL := ExpandCommand(GetUserParam('OR MHV URL'));
          ShellExecute(laMHV.Handle, 'open', PChar(uMHV_URL), '', '', SW_NORMAL);
        end;
      end;
    5:begin
       if Patient.PtIsVAA then
         try
           aReportText := TStringList.Create;
           Patient.GetVAAInformation(aInsuranceSubscriberName, aReportText);
           ReportBox(aReportText, aInsuranceSubscriberName, True);
         finally
           FreeAndNil(aReportText);
         end;
      end;
    6:begin
        ShowFlags;
      end;
    7:begin
        if uUseVistaWeb = true then
          begin
            lblCIRN.Alignment := taCenter;
            lstCIRNLocations.Visible := false;
            lstCIRNLocations.SendToBack;
            aAddress := GetVistaWebAddress(Patient.DFN);
            ShellExecute(pnlCirn.Handle, 'open', PChar(aAddress), PChar(''), '', SW_NORMAL);
            pnlCIRN.BevelOuter := bvRaised;
            Exit;
          end;
        if not RemoteSites.RemoteDataExists then Exit;
        if (not lstCIRNLocations.Visible) then
          begin
            pnlCIRN.BevelOuter := bvLowered;
            lstCIRNLocations.Visible := True;
            lstCIRNLocations.BringToFront;
            lstCIRNLocations.SetFocus;
            pnlCIRN.Hint := 'Click to close list.';
          end
        else
          begin
            pnlCIRN.BevelOuter := bvRaised;
            lstCIRNLocations.Visible := False;
            lstCIRNLocations.SendToBack;
            pnlCIRN.Hint := 'Click to display other facilities having data for this patient.';
          end;
      end;
    8:begin
        ViewReminderTree;
      end;
    9:begin { displays the window that shows crisis notes, warnings, allergies, & advance directives }
        ShowCWAD;
      end;
  end;
end;

procedure TfrmFrame.mnuViewInformationClick(Sender: TObject);
begin
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

procedure TfrmFrame.SetActiveTab(PageID: Integer);
begin
  tabPage.TabIndex := frmFrame.PageIDToTab(PageID);
  tabPageChange(tabPage);
end;

procedure TfrmFrame.NextButtonClick(Sender: TObject);
begin
  if FProccessingNextClick then Exit;

  FProccessingNextClick := true;
  popAlerts.AutoPopup := TRUE;
//  mnuFileNext.Enabled := True;
  mnuFileNext.Enabled := False;   // VISTAOR-31343
  if assigned(FNextButton) then   // VISTAOR-31343
    FNextButton.Enabled := False; // VISTAOR-31343
  mnuFileNextClick(Self);
  FProccessingNextClick := false;
  mnuFileNext.Enabled := True;
end;

procedure TfrmFrame.NextButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
begin
   popAlerts.AutoPopup := TRUE;
end;

procedure TfrmFrame.SetUpNextButton;
var
  bEnabled: Boolean;
begin
  bEnabled := False;
  if FNextButton <> nil then
  begin
    bEnabled := FNextButton.Enabled; // VISTAOR-31343
    FNextButton.Free;
    FNextButton := nil;
  end;
  FNextButton := TBitBtn.Create(Self);
  FNextButton.parent := frmFrame;
  FNextButton.Glyph := FNextButtonBitmap;
  FNextButton.OnMouseDown := NextButtonMouseDown;
  FNextButton.OnClick := NextButtonClick;
  FNextButton.Caption := '&Next';
  FNextButton.PopupMenu := popAlerts;

  FNextButton.top := stsArea.top;
  FNextButton.left := FNextButtonL;
  FNextButton.Height := stsArea.Height;
  FNextButton.Width := stsArea.Panels[2].Width;
  FNextButton.tabstop := True;
  FNextButton.TabOrder := 1;
  FNextButton.Enabled := bEnabled; // VISTAOR-31343
  FNextButton.Show;
end;

Procedure TfrmFrame.GetExcludedFromMixed();
var
 VistaList: TStringList;
 I: integer;
begin
 VistaList := TStringList.Create;
 try
  GetUserListParam(VistaList, 'OR EXCLUDE FROM MIXCASE');
  if VistaList.Count > 0 then
  begin
    ExcludeFromMixed.Clear;
    for I := 0 to VistaList.Count - 1 do
      ExcludeFromMixed.Add(MixedCase(Piece(VistaList[I], U, 2), True));
  end;
 finally
  VistaList.Free;
 end;
end;

function TfrmFrame.GetPatientInfoLabelDisplay: string;
const
  GapSpaces = 3;
var
  SIGI, ProNoun, DOB, Gap, FullCaption: String;
  NameLenPixels, SpaceLenPixels, X: Integer;
begin
  if Trim(FPatientInfoCaption) = '' then
  begin
    // Length per Character on info
    SpaceLenPixels := TextWidthByFont(lblPtInfo.Font.Handle, ' ');

    // Length of name
    NameLenPixels := TextWidthByFont(lblPtName.Font.Handle, lblPtName.Caption);

    // Setup Gap
    Gap := Gap.PadLeft(GapSpaces);

    // Full text - Used for calculations
    FullCaption := Patient.SSN;

    SIGI := Trim(Piece(Patient.SIGI, '/', 1));
    if SIGI <> '' then
    begin
      SIGI := Gap + SIGI;
      FullCaption := FullCaption + SIGI;
    end;

    ProNoun := Trim(Patient.ProNoun);
    if ProNoun <> '' then
    begin
      ProNoun := Gap + ProNoun;
      FullCaption := FullCaption + ProNoun;
    end;

    DOB := Gap + FormatFMDateTime('mmm dd,yyyy', Patient.DOB) + ' (' +
      IntToStr(Patient.Age) + ')';

    // pixels currenlty used by text
    X := TextWidthByFont(lblPtInfo.Font.Handle, FullCaption);
    // remaining pixels between info text and name text
    X := (NameLenPixels - X) - TextWidthByFont(lblPtInfo.Font.Handle, DOB);
    // number of spaces by pixels
    X := X DIV SpaceLenPixels;
    // Pad spaces between current text and dob (right justified)
    DOB := DOB.PadLeft(X + Length(DOB));

    // Output result
    FPatientInfoCaption := Format('%0:s%1:s%2:s%3:s',
      [Patient.SSN, SIGI, ProNoun, DOB]);
  end;
  Result := FPatientInfoCaption;
end;

// PDMP Messages processing ====================================================
/// <summary> updating PDMP actions availability after PDMP Request was sent </summary>
procedure TfrmFrame.UMPdmpLoading(var Message: TMessage);
begin
  acPDMPRequest.Enabled := False;
  acPDMPCancel.Enabled := True;
  acPDMPReview.Enabled := False;
end;

/// <summary> updating PDMP actions availability after PDMP Request results were reviewed </summary>
procedure TfrmFrame.UMPdmpDone(var Message: TMessage);
begin
  acPDMPRequest.Enabled := True;
  acPDMPCancel.Enabled := False;
  acPDMPReview.Enabled := False;
  if assigned(fPDMPMgr) then
    begin
      fPDMPMgr.Visible := (PDMP_ShowButton = 'ALWAYS');
//      fPDMPMgr.ShowOptions := True; // resetting
    end;
end;

/// <summary> updating PDMP actions availability. Request results are ready for review </summary>
procedure TfrmFrame.UMPdmpReady(var Message: TMessage);
begin
  acPDMPRequest.Enabled := False;
  acPDMPCancel.Enabled := False;
  acPDMPReview.Enabled := True;
  if assigned(fPDMPMgr) then
    fPDMPMgr.Visible := (PDMP_ShowButton = 'ALWAYS') or
      (PDMP_ShowButton = 'RESULTS ONLY');
end;

/// <summary> updating PDMP actions availability. Request results are NOT ready for review </summary>
procedure TfrmFrame.UMPdmpError(var Message: TMessage);
begin
  if assigned(fPDMPMgr) then
    begin
      fPDMPMgr.Visible := PDMP_ShowButton = 'ALWAYS';
      if Message.LParam = 1 then // error on first call to get data
        begin
          ShowMessage(fPDMPMgr.PDMPData.LongMessage);
          fPDMPMgr.Status := 0;
          acPDMPRequest.Enabled := True;
          acPDMPCancel.Enabled := False;
          acPDMPReview.Enabled := False;
        end
      else
        begin // error on data polling - no error messages
          fPDMPMgr.Visible := fPDMPMgr.Visible or
            (PDMP_ShowButton = 'RESULTS ONLY');
          acPDMPRequest.Enabled := False;
          acPDMPCancel.Enabled := False;
          acPDMPReview.Enabled := True;
        end;
    end;
end;

/// <summary> Cancelation of the PDMP Request </summary>
procedure TfrmFrame.UMPdmpAbort(var Message: TMessage);
begin
  acPDMPRequest.Enabled := True;
  acPDMPCancel.Enabled := False;
  acPDMPReview.Enabled := False;
  fPDMPMgr.Visible := PDMP_ShowButton = 'ALWAYS';
end;

/// <summary> Results review ended in OK press </summary>
procedure TfrmFrame.UMPdmpReviewed(var Message: TMessage);
begin
  acPDMPRequest.Enabled := True;
  acPDMPCancel.Enabled := False;
  acPDMPReview.Enabled := False;
  if assigned(fPDMPMgr) then
    fPDMPMgr.Visible := PDMP_ShowButton = 'ALWAYS';
end;

/// <summary> Results review ended in OK press </summary>
procedure TfrmFrame.UMPdmpDisable(var Message: TMessage);
begin
  PDMP1.Enabled := False;
  if assigned(fPDMPMgr) then
    begin
      fPDMPMgr.Enabled := False;
      fPDMPMgr.bbCancel.Visible := False;
      fPDMPMgr.bbStart.Visible := False;
      fPDMPMgr.bbResults.Visible := False;
      fPDMPMgr.pnlPdmp.Caption := 'PDMP';
      fPDMPMgr.pnlPdmp.ShowCaption := true;
    end;
end;

/// <summary> Results review ended in OK press </summary>
procedure TfrmFrame.UMPdmpEnable(var Message: TMessage);
begin
  PDMP1.Enabled := True;
  if assigned(fPDMPMgr) then
    begin
      fPDMPMgr.Enabled := True;
      fPDMPMgr.bbCancel.Visible := True;
      fPDMPMgr.bbStart.Visible := True;
      fPDMPMgr.bbResults.Visible := True;
      fPDMPMgr.pnlPdmp.ShowCaption := False;
    end;
end;

function TfrmFrame.EditInProgress: String;
begin
  Result := '';
  if assigned(frmNotes) and (frmNotes.EditingIndex > -1) then
    Result := Result + frmNotes.EditedNoteInfo + CRLF;
(*
  if assigned(frmConsults) and (frmConsults.EditingIndex > -1) then
    Result := Result + 'Consult ' +
      frmConsults.GetTitleText(frmConsults.EditingIndex) + CRLF;

  if assigned(frmDCSumm) and (frmDCSumm.EditingIndex > -1) then
    Result := Result + frmDCSumm.EditedNoteInfo + CRLF;

  if assigned(frmSurgery) and (frmSurgery.EditingIndex > -1) then
    Result := Result + 'Surgery ' +
      frmSurgery.GetTitleText(frmSurgery.EditingIndex) + CRLF;
*)
end;

function TfrmFrame.SaveEditInProgress(var ShowMessage: Boolean): Boolean;
var
  b: Boolean;
begin
  Result := True;
  ShowMessage := False;
  if assigned(frmNotes) and (frmNotes.EditingIndex > -1) then
  begin
    frmNotes.SaveCurrentNote(b);
    Result := Result and b;
    if Result then
      frmNotes.LoadNotes;

    if not b and frmNotes.Silent  then
      ShowMessage := True;
  end;
(*
  if assigned(frmConsults) and (frmConsults.EditingIndex > -1) then
  begin
    frmConsults.SaveCurrentNote(b);
    Result := Result and b;
    if not b and frmConsults.Silent  then
      ShowMessage := True;
  end;

  if assigned(frmDCSumm) and (frmDCSumm.EditingIndex > -1) then
  begin
    frmDCSumm.SaveCurrentSumm(b);
    Result := Result and b;
    if not b and frmDCSumm.Silent  then
      ShowMessage := True;
  end;

  if assigned(frmSurgery) and (frmSurgery.EditingIndex > -1) then
  begin
    frmSurgery.SaveCurrentNote(b);
    Result := Result and b;
    if not b and frmSurgery.Silent  then
      ShowMessage := True;
  end;
*)
end;

/// <summary> Selection of the PDMP Review Registration note </summary>
procedure TfrmFrame.UMPdmpNoteID(var Message: TMessage);
var
  Saved, bShowMessage: Boolean;
  s: String;
begin
  bShowMessage := False;
  s := EditInProgress;
  if s <> '' then
    begin
      if InfoBox('You are currently editing:' + CRLF+CRLF + s + CRLF +
        'Do you wish to save this note and review PDMP report?','PDMP Warning',
         MB_YESNO or MB_ICONQUESTION) <> IDYES then
       exit
       else
         Saved := SaveEditInProgress(bShowMessage);
    end
  else
    Saved := true;

  if not Saved then
    begin
      if bShowMessage then
        InfoBox('Failed to save currently edited note', 'PDMP',MB_OK);
    end
  else  if assigned(frmNotes) then
    with frmNotes do
    begin
      s := IntToStr(Message.WParam);
      LoadNotes;
      tvNotes.Selected := tvNotes.FindPieceNode(s, u,
        tvNotes.Items.GetFirstNode);
    end;
end;

// PaPI ========================================================================
procedure TfrmFrame.UMPAPI(var Message: TMessage);

begin
  try
    tabPage.TabIndex := Message.WParam;
    tabPageChange(tabPage);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmFrame);

finalization

end.

{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit fOrders;

{------------------------------------------------------------------------------
Update History
    2016-05-17: NSR#20110719 (Order Flag Recommendations)
    2018-09-17: RTC 272867 (Replacing old server calls with CallVistA)
-------------------------------------------------------------------------------}

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fHSplit, StdCtrls,
  ExtCtrls, Menus, ORCtrls, ComCtrls, ORFn, rOrders, fODBase, uConst, uCore,
  uOrders, UBACore, fOrdersPark, fOrdersUnPark,
  UBAGlobals, VA508AccessibilityManager, fBase508Form, fOrdersPickEvent,
  uOrderFlag, System.Actions, Vcl.ActnList;

type
  TfrmOrders = class(TfrmHSplit)
    mnuOrders: TMainMenu;
    mnuAct: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActDC: TMenuItem;
    mnuActHold: TMenuItem;
    mnuActUnhold: TMenuItem;
    mnuActRenew: TMenuItem;
    Z4: TMenuItem;
    mnuActFlag: TMenuItem;
    mnuActUnflag: TMenuItem;
    Z5: TMenuItem;
    mnuActVerify: TMenuItem;
    mnuActRelease: TMenuItem;
    mnuActSign: TMenuItem;
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
    mnuViewActive: TMenuItem;
    mnuViewExpiring: TMenuItem;
    Z2: TMenuItem;
    mnuViewCustom: TMenuItem;
    Z3: TMenuItem;
    mnuViewDetail: TMenuItem;
    Z1: TMenuItem;
    OROffsetLabel1: TOROffsetLabel;
    hdrOrders: THeaderControl;
    lstOrders: TCaptionListBox;
    lblOrders: TOROffsetLabel;
    lstSheets: TORListBox;
    lstWrite: TORListBox;
    mnuViewUnsigned: TMenuItem;
    popOrder: TPopupMenu;
    popOrderChange: TMenuItem;
    popOrderDC: TMenuItem;
    popOrderRenew: TMenuItem;
    popOrderDetail: TMenuItem;
    N1: TMenuItem;
    mnuActCopy: TMenuItem;
    mnuActAlert: TMenuItem;
    mnuViewResult: TMenuItem;
    mnuActOnChart: TMenuItem;
    mnuActComplete: TMenuItem;
    sepOrderVerify: TMenuItem;
    popOrderVerify: TMenuItem;
    popOrderResult: TMenuItem;
    imgHide: TImage;
    mnuOpt: TMenuItem;
    mnuOptSaveQuick: TMenuItem;
    mnuOptEditCommon: TMenuItem;
    popOrderSign: TMenuItem;
    popOrderCopy: TMenuItem;
    mnuActChartRev: TMenuItem;
    popOrderChartRev: TMenuItem;
    Z6: TMenuItem;
    mnuViewDfltSave: TMenuItem;
    mnuViewDfltShow: TMenuItem;
    mnuViewCurrent: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuViewResultsHistory: TMenuItem;
    popResultsHistory: TMenuItem;
    btnDelayedOrder: TORAlignButton;
    mnuActChgEvnt: TMenuItem;
    popChgEvnt: TMenuItem;
    mnuActRel: TMenuItem;
    popOrderRel: TMenuItem;
    EventRealeasedOrder1: TMenuItem;
    lblWrite: TLabel;
    sptVert: TSplitter;
    mnuViewExpired: TMenuItem;
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
    Z7: TMenuItem;
    mnuActOneStep: TMenuItem;
    mnuActFlagComment: TMenuItem;
    mnuViewUAP: TMenuItem;
    mnuViewDM: TMenuItem;
    PopUAPOrder: TPopupMenu;
    MnuDetailsUAP: TMenuItem;
    MnuDashUAP: TMenuItem;
    MnuContinueUAP: TMenuItem;
    MnuChangeUAP: TMenuItem;
    MnuRenewUAP: TMenuItem;
    MnuDiscontinueUAP: TMenuItem;
    MnuDash2UAP: TMenuItem;
    MnuSignUAP: TMenuItem;
    N2: TMenuItem;
    popFlag: TMenuItem;
    popFlagComment: TMenuItem;
    popUnflag: TMenuItem;
    mnuAllowMultipleAssignment: TMenuItem;
    ActionList: TActionList;
    actPark: TAction;
    actUnpark: TAction;
    N3: TMenuItem;
    popPark: TMenuItem;
    popUnpark: TMenuItem;
    N4: TMenuItem;
    Park1: TMenuItem;
    UnparkGeneratesarequesttoFillRefill1: TMenuItem;
    procedure mnuChartTabClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      TheRect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure mnuViewActiveClick(Sender: TObject);
    procedure hdrOrdersSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure mnuViewCustomClick(Sender: TObject);
    procedure mnuViewExpiringClick(Sender: TObject);
    procedure mnuViewExpiredClick(Sender: TObject);
    procedure mnuViewUnsignedClick(Sender: TObject);
    procedure mnuViewDetailClick(Sender: TObject);
    procedure lstOrdersDblClick(Sender: TObject);
    procedure lstWriteClick(Sender: TObject);
    procedure mnuActHoldClick(Sender: TObject);
    procedure mnuActUnholdClick(Sender: TObject);
    procedure mnuActDCClick(Sender: TObject);
    procedure mnuActAlertClick(Sender: TObject);
    procedure mnuActFlagClick(Sender: TObject);
    procedure mnuActFlagCommentClick(Sender: TObject);
    procedure mnuActUnflagClick(Sender: TObject);
    procedure mnuActSignClick(Sender: TObject);
    procedure mnuActReleaseClick(Sender: TObject);
    procedure mnuActOnChartClick(Sender: TObject);
    procedure mnuActCompleteClick(Sender: TObject);
    procedure mnuActVerifyClick(Sender: TObject);
    procedure mnuViewResultClick(Sender: TObject);
    procedure mnuActCommentClick(Sender: TObject);
    procedure mnuOptSaveQuickClick(Sender: TObject);
    procedure mnuOptEditCommonClick(Sender: TObject);
    procedure mnuActCopyClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActRenewClick(Sender: TObject);
    procedure pnlRightResize(Sender: TObject);
    procedure lstSheetsClick(Sender: TObject);
    procedure mnuActChartRevClick(Sender: TObject);
    procedure mnuViewDfltShowClick(Sender: TObject);
    procedure mnuViewDfltSaveClick(Sender: TObject);
    procedure pickEvent(itemList: TStrings; var aReturn: Integer);
    procedure mnuViewCurrentClick(Sender: TObject);
    procedure mnuViewResultsHistoryClick(Sender: TObject);
    procedure btnDelayedOrderClick(Sender: TObject);
    procedure mnuActChgEvntClick(Sender: TObject);
    procedure mnuActRelClick(Sender: TObject);
    procedure EventRealeasedOrder1Click(Sender: TObject);
    procedure lblWriteMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure popOrderPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure hdrOrdersMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrOrdersMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure mnuOptimizeFieldsClick(Sender: TObject);
    procedure hdrOrdersSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure sptHorzMoved(Sender: TObject);
    procedure sptVertMoved(Sender: TObject);
    procedure mnuActOneStepClick(Sender: TObject);
    function GetIndexOfOID(AnOrderListBox: TCaptionListBox;
      AnOrderID: string): Integer;
    procedure mnuViewUAPClick(Sender: TObject);
    procedure mnuViewDMClick(Sender: TObject);
    procedure popOrderMarkClick(Sender: TObject);
    procedure MnuContinueUAPClick(Sender: TObject);
    procedure MnuDiscontinueUAPClick(Sender: TObject);
    procedure MnuChangeUAPClick(Sender: TObject);
    procedure PopUAPOrderPopup(Sender: TObject);
    procedure MnuRenewUAPClick(Sender: TObject);
    procedure SetOrderRevwCol(AnOrderList: TList);
    procedure mnuAllowMultipleAssignmentClick(Sender: TObject);
    procedure mnuActClick(Sender: TObject);
    procedure lstOrdersHintShow(var HintText: string; var CanShow: Boolean);
    procedure actParkExecute(Sender: TObject);
    procedure actUnparkExecute(Sender: TObject);
  private
    { Private declarations }
    OrderListClickProcessing: Boolean;
    FDfltSort: Integer;
    FCurrentView: TOrderView;
    FCompress: Boolean;
    FFromDCRelease: Boolean;
    FSendDelayOrders: Boolean;
    FNewEvent: Boolean;
    FAskForCancel: Boolean;
    FNeedShowModal: Boolean;
    FOrderViewForActiveOrders: TOrderView;
    FEventForCopyActiveOrders: TOrderDelayEvent;
    FEventDefaultOrder: string;
    FIsDefaultDlg: Boolean;
    FHighlightFromMedsTab: Integer;
    FCalledFromWDO: Boolean; // called from Write Delay Orders button
    FEvtOrderList: TStringlist;
    FEvtColWidth: Integer;
    FRightAfterWriteOrderBox: Boolean;
    FDontCheck: Boolean;
    FParentComplexOrderID: string;
    FHighContrast2Mode: Boolean;
    UAPContinue: Boolean; // rtw
    FRenewcancel2: Boolean; // rtw
    FOrderTitlecaption: string;
    FNoOrderingOrWriteAccess: boolean;
    FAllowAlertAction: boolean;
    FSigning: boolean;
    FRenewing: boolean;
    function CanChangeOrderView: Boolean;
    function GetEvtIFN(AnIndex: Integer): string;
    function DisplayDefaultDlgList(ADest: TORListBox;
      ADlgList: TStringlist): Boolean;
    procedure AddToListBox(AnOrderList: TList);
    procedure ExpandEventSection;
    procedure CompressEventSection;
    procedure ClearOrderSheets;
    procedure InitOrderSheets;
    procedure DfltViewForEvtDelay;
    procedure MakeSelectedList(AList: TList);
    function NoneSelected(const ErrMsg: string): Boolean;
    procedure ProcessNotifications;
    procedure PositionTopOrder(DGroup: Integer);
    procedure RedrawOrderList(KeepSelection: boolean = False);
    procedure RefreshOrderList(FromServer: Boolean; APtEvtID: string = '');
    procedure RetrieveVisibleOrders(AnIndex: Integer);
    procedure RemoveSelectedFromChanges(AList: TList);
    procedure SetOrderView(AFilter, ADGroup: Integer; const AViewName: string;
      NotifSort: Boolean; aDaysOverride: Integer = 0);
    procedure SetCannedView(AFilter, ADGroup: Integer; const AViewName: string;
      NotifSort: Boolean; aDaysOverride: Integer = 0);
    procedure OrderViewReset;
    // procedure SetEvtIFN(var AnEvtIFN: integer);
    procedure UseDefaultSort;
    procedure SynchListToOrders;
    procedure ActivateDeactiveRenew;
    procedure ValidateSelected(const AnAction, WarningMsg,
      WarningTitle: string);
    procedure ViewAlertedOrders(OrderIEN: string; Status: Integer;
      DispGrp: string; BySvc, InvDate: Boolean; Title: string;
      aDaysOverride: Integer = 0);
    procedure UMDestroy(var Message: TMessage); message UM_DESTROY;
    function GetStartStopText(StartTime: string; StopTime: string): string;
    function GetOrderText(AnOrder: TOrder; Index: Integer;
      Column: Integer): string;
    function MeasureColumnHeight(AnOrder: TOrder; Index: Integer;
      Column: Integer): Integer;
    function GetPlainText(AnOrder: TOrder; Index: Integer): string;
    // function PatientStatusChanged: boolean;
    procedure UMEventOccur(var Message: TMessage); message UM_EVENTOCCUR;
    function CheckOrderStatus: Boolean;
    procedure RightClickMessageHandler(var Msg: TMessage; var Handled: Boolean);
    procedure UMDeselectOrder(var Message: TMessage); message UM_ORDDESELECT;
    procedure FlagAction(AnAction: TActionMode);
    function SelCount: integer;
    procedure PaPI_GUIsetup;
  public
    function GetMenuString:string;
    procedure setSectionWidths; // CQ6170
    function getTotalSectionsWidth: Integer; // CQ6170
    function AllowContextChange(var WhyNot: string): Boolean; override;
    function PlaceOrderForDefaultDialog(ADlgInfo: string;
      IsDefaultDialog: Boolean; AEvent: TOrderDelayEvent): Boolean;
    function PtEvtCompleted(APtEvtID: Integer; APtEvtName: string;
      FromMeds: Boolean = False; Signing: Boolean = False): Boolean;
    procedure RefreshToFirstItem;
    procedure ChangesUpdate(APtEvtID: string);
    procedure GroupChangesUpdate(GrpName: string);
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure InitOrderSheetsForEvtDelay;
    procedure ResetOrderPage(AnEvent: TOrderDelayEvent; ADlgLst: TStringlist;
      IsRealeaseNow: Boolean);
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); override;
    procedure SaveSignOrders;
    procedure ClickLstSheet;
    procedure RequestPrint; override;
    procedure InitOrderSheets2(AnItem: string = '');
    procedure SetFontSize(FontSize: Integer); override;
    property IsDefaultDlg: Boolean read FIsDefaultDlg write FIsDefaultDlg;
    property SendDelayOrders: Boolean read FSendDelayOrders
      write FSendDelayOrders;
    property NewEvent: Boolean read FNewEvent write FNewEvent;
    property NeedShowModal: Boolean read FNeedShowModal write FNeedShowModal;
    property AskForCancel: Boolean read FAskForCancel write FAskForCancel;
    property EventDefaultOrder: string read FEventDefaultOrder
      write FEventDefaultOrder;
    property TheCurrentView: TOrderView read FCurrentView;
    property HighlightFromMedsTab: Integer read FHighlightFromMedsTab
      write FHighlightFromMedsTab;
    property CalledFromWDO: Boolean read FCalledFromWDO;
    property EvtOrderList: TStringlist read FEvtOrderList write FEvtOrderList;
    property FromDCRelease: Boolean read FFromDCRelease write FFromDCRelease;
    property EvtColWidth: Integer read FEvtColWidth write FEvtColWidth;
    property DontCheck: Boolean read FDontCheck write FDontCheck;
    property ParentComplexOrderID: string read FParentComplexOrderID
      write FParentComplexOrderID;
    property Renewcancel2: Boolean read FRenewcancel2 write FRenewcancel2;
    // rtw
  end;

type
  arOrigSecWidths = array [0 .. 10] of Integer; // CQ6170

var
  frmOrders: TfrmOrders;

  origWidths: arOrigSecWidths; // CQ6170

implementation

uses fFrame, fEncnt, fOrderVw, fRptBox, fLkUpLocation, fOrdersDC, fOrdersCV,
  fOrdersHold, fOrdersUnhold,
  fOrdersAlert, fOrderFlagEditor, fOrderListManager, fOrdersSign,
  fOrdersRelease, fOrdersOnChart, fOrdersEvntRelease,
  fOrdersComplete, fOrdersVerify, fOrderComment, fOrderSaveQuick, fOrdersRenew,
  fODReleaseEvent,
  fOMNavA, rCore, fOCSession, fOrdersPrint, fOrdersTS, fEffectDate, fODActive,
  fODChild,
  fOrdersCopy, fOMVerify, fODAuto, rODBase, uODBase, rMeds, fODValidateAction,
  fMeds, uInit, fBALocalDiagnoses,
  fODConsult, fClinicWardMeds, fActivateDeactivate, VA2006Utils, rodMeds,
  VA508AccessibilityRouter, VAUtils, System.Types, System.UITypes, uPaPI,
  ORNet, UResponsiveGUI, uWriteAccess;

{$R *.DFM}

const
  FROM_SELF = False;
  FROM_SERVER = True;
  OVS_CATINV = 0;
  OVS_CATFWD = 1;
  OVS_INVERSE = 2;
  OVS_FORWARD = 3;
  STS_ACTIVE = 2;
  STS_DISCONTINUED = 3;
  STS_COMPLETE = 4;
  STS_EXPIRING = 5;
  STS_RECENT = 6;
  STS_UNVERIFIED = 8;
  STS_UNVER_NURSE = 9;
  STS_UNSIGNED = 11;
  STS_FLAGGED = 12;
  STS_HELD = 18;
  STS_NEW = 19;
  STS_CURRENT = 23;
  STS_EXPIRED = 27;
  STS_FIXED = -1;
  FM_DATE_ONLY = 7;
  CT_ORDERS = 4; // chart tab - doctor's orders

  TX_NO_HOLD = CRLF + CRLF + '- cannot be placed on hold.' + CRLF + CRLF +
    'Reason:  ';
  TC_NO_HOLD = 'Unable to Hold';
  TX_NO_UNHOLD = CRLF + CRLF + '- cannot be released from hold.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_UNHOLD = 'Unable to Release from Hold';
  TX_NO_DC = CRLF + CRLF + '- cannot be discontinued.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_DC = 'Unable to Discontinue';
  TX_NO_CV = CRLF + 'The release event cannot be changed.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_CV = 'Unable to Change Release Event';
  TX_NO_ALERT = CRLF + CRLF + '- cannot be set to send an alert.' + CRLF + CRLF
    + 'Reason: ';
  TC_NO_ALERT = 'Unable to Set Alert';
  TX_NO_FLAG = CRLF + CRLF + '- cannot be flagged.' + CRLF + CRLF + 'Reason: ';
  TC_NO_FLAG = 'Unable to Flag Order';
  TX_NO_UNFLAG = CRLF + CRLF + '- cannot be unflagged.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_UNFLAG = 'Unable to Unflag Order';
  TX_NO_FLAGCOMMENT = CRLF + CRLF + '- flag cannot be commented.' + CRLF + CRLF +
    'Reason: ';
  TX_NO_SIGN = CRLF + CRLF + '- cannot be signed.' + CRLF + CRLF + 'Reason: ';
  TC_NO_SIGN = 'Unable to Sign Order';
  TX_NO_REL = CRLF + 'Cannot be released to the service(s).' + CRLF + CRLF +
    'Reason: ';
  TC_NO_REL = 'Unable to be Released to Service';
  TX_NO_CHART = CRLF + CRLF + '- cannot be marked "Signed on Chart".' + CRLF +
    CRLF + 'Reason: ';
  TC_NO_CHART = 'Unable to Release Orders';
  TX_NO_CPLT = CRLF + CRLF + '- cannot be completed.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_CPLT = 'Unable to Complete';
  TX_NO_VERIFY = CRLF + CRLF + '- cannot be verified.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_VERIFY = 'Unable to Verify';
  TX_NO_CMNT = CRLF + CRLF + '- cannot have comments edited.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_CMNT = 'Unable to Edit Comments';
  TX_NO_RENEW = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF + 'Reason: ';
  TC_NO_RENEW = 'Unable to Renew Order';
  TX_LOC_PRINT =
    'The selected location will be used to determine where orders are printed.';
  TX_PRINT_LOC = 'A location must be selected to print orders.';
  TX_REL_LOC = 'A location must be selected to release orders.';
  TX_CHART_LOC =
    'A location must be selected to mark orders "signed on chart".';
  TX_SIGN_LOC = 'A location must be selected to sign orders.';
  TC_REQ_LOC = 'Location Required';
  TX_NOSEL = 'No orders are highlighted.  Highlight the orders' + CRLF +
    'you wish to take action on.';
  TX_NOSEL_SIGN =
    'No orders are highlighted. Highlight orders you want to sign or' + CRLF +
    'use Review/Sign Changes (File menu) to sign all orders written' + CRLF +
    'in this session.';
  TC_NOSEL = 'No Orders Selected';
  TX_NOCHG_VIEW =
    'The view of orders may not be changed while an ordering dialog is' + CRLF +
    'active for an event-delayed order.';
  TC_NOCHG_VIEW = 'Order View Restriction';
  TX_DELAY1 = 'Now writing orders for ';
  TC_DELAY = 'Ordering Information';
  TX_BAD_TYPE =
    'This item is a type that is not supported in the graphical interface.';
  TC_BAD_TYPE = 'Unsupported Ordering Item';
  TC_VWSAVE = 'Save Default Order View';
  TX_VWSAVE1 = 'The current order view is: ' + CRLF + CRLF;
  TX_VWSAVE2 = CRLF + CRLF + 'Do you wish to save this as your default view?';
  TX_NO_COPY = CRLF + CRLF + '- cannot be copied.' + CRLF + CRLF + 'Reason: ';
  TC_NO_COPY = 'Unable to Copy Order';
  TX_NO_CHANGE = CRLF + CRLF + '- cannot be changed' + CRLF + CRLF + 'Reason: ';
  TC_NO_CHANGE = 'Unable to Change Order';
  TX_COMPLEX = 'You can not take this action on a complex medication.' + #13 +
    'You must enter a new order.';
  TX_CMPTEVT = ' occurred since you started writing delayed orders. ' +
    'The orders that were entered and signed have now been released. ' +
    'Any unsigned orders will be released immediately upon signature. ' + #13#13
    + 'To write new delayed orders for this event you need to click the write delayed orders button again and select the appropriate event. '
    + 'Orders delayed to this same event will remain delayed until the event occurs again.'
    + #13#13 +
    'The Orders tab will now be refreshed and switched to the Active Orders view. '
    + 'If you wish to continue to write active orders for this patient, ' +
    'close this message window and continue as usual.';
  TX_CMPTEVT_MEDSTAB = ' occurred since you started writing delayed orders. ' +
    'The orders that were entered and signed have now been released. ' +
    'Any unsigned orders will be released immediately upon signature. ' + #13#13
    + 'To write new delayed orders for this event you need to click the write delayed orders button on the orders tab and select the appropriate event. '
    + 'Orders delayed to this same event will remain delayed until the event occurs again.';
  TX_DEAFAIL =
    'Signing provider does not have a current, valid DEA# on record.';
  TX_SCHFAIL =
    'Signing provider is not authorized to prescribe medications in Federal Schedule ';
  TX_NO_DETOX =
    'Signing provider does not have a valid Detoxification/Maintenance ID number on record.';
  TX_EXP_DETOX =
    'Signing provider''s Detoxification/Maintenance ID number expired due to an expired DEA# on ';
  TX_EXP_DEA1 = 'Signing provider''s DEA# expired on ';
  TX_EXP_DEA2 = ' and no VA# is assigned.';

var
  uOrderList: TList;
  uEvtDCList, uEvtRLList: TList;
  ColIdx: Integer;

  { TPage common methods --------------------------------------------------------------------- }

function TfrmOrders.AllowContextChange(var WhyNot: string): Boolean;
begin
  Result := inherited AllowContextChange(WhyNot); // sets result = true
  case BOOLCHAR[frmFrame.CCOWContextChanging] of
    '1':
      if ActiveOrdering then
      begin
        WhyNot := 'Orders in progress will be discarded.';
        Result := False;
      end;
    '0':
      Result := CloseOrdering; // call in uOrders, should move to fFrame
  end;
end;

procedure TfrmOrders.mnuAllowMultipleAssignmentClick(Sender: TObject);
begin
  inherited;
  mnuAllowMultipleassignment.Checked := not mnuAllowMultipleAssignment.Checked;
end;

procedure TfrmOrders.ClearPtData;
begin
  inherited ClearPtData;
  lstOrders.Clear;
  ClearOrderSheets;
  ClearOrders(uOrderList);
  if uEvtDCList <> nil then
    uEvtDCList.Clear;
  if uEvtRLList <> nil then
    uEvtRLList.Clear;
  ClearFillerAppList;
end;

procedure TfrmOrders.DisplayPage;
var
  i: Integer;
  KeepSelections: boolean;

begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  frmFrame.mnuFilePrint.Tag := CT_ORDERS;
  frmFrame.mnuFilePrint.Enabled := True;
  frmFrame.mnuFilePrintSetup.Enabled := True;
  if InitPage then
  begin
    // set visibility according to order role
    mnuActComplete.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK) or (User.OrderRole = OR_PHYSICIAN);
    mnuActVerify.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    popOrderVerify.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    sepOrderVerify.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    mnuActChartRev.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    popOrderChartRev.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    mnuActRelease.Visible := User.OrderRole = OR_NURSE;
    mnuActOnChart.Visible := (User.OrderRole = OR_NURSE) or
      (User.OrderRole = OR_CLERK);
    mnuActSign.Visible := User.OrderRole = OR_PHYSICIAN;
    popOrderSign.Visible := User.OrderRole = OR_PHYSICIAN;
    mnuActRel.Visible := False;
    popOrderRel.Visible := False;
    // now set enabled/disabled according to parameters
    // popup items that apply to ordering have tag>0
    with mnuAct do
      for i := 0 to Pred(Count) do
        Items[i].Enabled := not FNoOrderingOrWriteAccess;
    mnuActAlert.Enabled := FAllowAlertAction;
    with popOrder.Items do
      for i := 0 to Pred(Count) do
        if Items[i].Tag > 0 then
          Items[i].Enabled := not FNoOrderingOrWriteAccess;
    // set nurse verification actions (may be enabled when ordering disabled)
    mnuActVerify.Enabled := User.EnableVerify;
    mnuActChartRev.Enabled := User.EnableVerify;
    popOrderVerify.Enabled := User.EnableVerify;
    popOrderChartRev.Enabled := User.EnableVerify;
    mnuActOneStep.Enabled := User.EnableActOneStep and (not FNoOrderingOrWriteAccess);
    if User.DisableHold then
    begin
      mnuActHold.Visible := False;
      mnuActUnhold.Visible := False;
    end;
  end;
  AskForCancel := True;
  if InitPatient then // for both CC_INIT_PATIENT and CC_NOTIFICATION
  begin
    if not User.NoOrdering then
      LoadWriteOrders(lstWrite.Items)
    else
      lstWrite.Clear;
    InitOrderSheets;
  end;
  KeepSelections := False;
  case CallingContext of
    CC_INIT_PATIENT:
      mnuViewDfltShowClick(Self);
      // when new patient but not doing notifications
    CC_NOTIFICATION:
      begin
        ProcessNotifications; // when new patient and doing notifications
        KeepSelections := True;
      end;
  end;
  {
    Force this page to re-assess column widths and text wrapping *AFTER* we
    call TResponsiveGUI.ProcessMessages so all the windows messages and other
    'things' we fired off will complete first.
  }
  TResponsiveGUI.ProcessMessages;
  RedrawOrderList(KeepSelections);
end;

procedure TfrmOrders.mnuChartTabClick(Sender: TObject);
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

procedure TfrmOrders.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);
var
  OrderForList: TOrder;
  IndexOfOrder, ReturnedType, CanSign, i: Integer;
  j: Integer;
  AChildList: TStringlist;
  CplxOrderID: string;
  DCNewOrder: Boolean;
  DCChangeItem: TChangeItem;

  procedure RemoveFromOrderList(ChildOrderID: string);
  var
    ij: Integer;
  begin
    for ij := uOrderList.Count - 1 downto 0 do
    begin
      if TOrder(uOrderList[ij]).ID = ChildOrderID then
        uOrderList.Remove(TOrder(uOrderList[ij]));
    end;
  end;

begin
  // if FCurrentView = nil then                                        {**REV**}
  // begin                                                           {**REV**}
  // FCurrentView := TOrderView.Create;                            {**REV**}
  // with FCurrentView do                                          {**REV**}
  // begin                                                        {**REV**}
  // InvChrono := True;                                          {**REV**}
  // ByService := True;                                          {**REV**}
  // end;                                                         {**REV**}
  // end;                                                            {**REV**}
  if (FCurrentView = nil) or (lstSheets.Count < 1) then
    Exit;
  case OrderAction of
    ORDER_NEW:
      if AnOrder.ID <> '' then
      begin
        OrderForList := TOrder.Create;
        OrderForList.Assign(AnOrder);
        uOrderList.Add(OrderForList);
        FCompress := True;
        RefreshOrderList(FROM_SELF);
        // PositionTopOrder(AnOrder.DGroup);
        PositionTopOrder(0); // puts new orders on top
        lstOrders.Invalidate;
      end;
    ORDER_DC:
      begin
        IndexOfOrder := -1;
        with lstOrders do
          for i := 0 to Items.Count - 1 do
            if TOrder(Items.Objects[i]).ID = AnOrder.ID then
              IndexOfOrder := i;
        if IndexOfOrder > -1 then
          OrderForList := TOrder(lstOrders.Items.Objects[IndexOfOrder])
        else
          OrderForList := AnOrder;
        if (Encounter.Provider = User.DUZ) and User.CanSignOrders then
          CanSign := CH_SIGN_YES
        else
          CanSign := CH_SIGN_NA;
        DCNewOrder := False;
        if Changes.Orders.Count > 0 then
        begin
          for j := 0 to Changes.Orders.Count - 1 do
          begin
            DCChangeItem := TChangeItem(Changes.Orders.Items[j]);
            if DCChangeItem.ID = OrderForList.ID then
            begin
              if (Pos('DC', OrderForList.ActionOn) = 0) then
                DCNewOrder := True;
              // else DCNewOrder := False;
            end;
          end;
        end;
        DCOrder(OrderForList, GetReqReason, DCNewOrder, ReturnedType);
        Changes.Add(CH_ORD, OrderForList.ID, OrderForList.Text, '', CanSign,
          waOrders, '', 0, OrderForList.DGroup);
        FCompress := True;
        SynchListToOrders;
      end;
    ORDER_EDIT:
      with lstOrders do
      begin
        IndexOfOrder := -1;
        for i := 0 to Items.Count - 1 do
          if TOrder(Items.Objects[i]).ID = AnOrder.EditOf then
            IndexOfOrder := i;
        if IndexOfOrder > -1 then
        begin
          TOrder(Items.Objects[IndexOfOrder]).Assign(AnOrder);
        end; { if IndexOfOrder }
        // RedrawOrderList;  {redraw here appears to clear selected}
      end; { with lstOrders }
    ORDER_ACT:
      begin
        if IsComplexOrder(AnOrder.ID) then
        begin
          RefreshOrderList(FROM_SERVER);
          Exit;
        end;
        with lstOrders do
        begin
          IndexOfOrder := -1;
          for i := 0 to Items.Count - 1 do
            if TOrder(Items.Objects[i]).ID = Piece(AnOrder.ActionOn, '=', 1)
            then
              IndexOfOrder := i;
          if (IndexOfOrder > -1) and (AnOrder <> Items.Objects[IndexOfOrder])
          then
          begin
            TOrder(Items.Objects[IndexOfOrder]).Assign(AnOrder);
          end; { if IndexOfOrder }
          FCompress := True;
          RedrawOrderList;
        end; { with lstOrders }
      end; // PSI-COMPLEX
    ORDER_CPLXRN:
      begin
        AChildList := TStringlist.Create;
        CplxOrderID := Piece(AnOrder.ActionOn, '=', 1);
        GetChildrenOfComplexOrder(CplxOrderID, Piece(CplxOrderID, ';', 2),
          AChildList);
        with lstOrders do
        begin
          for i := Items.Count - 1 downto 0 do
          begin
            for j := 0 to AChildList.Count - 1 do
            begin
              if TOrder(Items.Objects[i]).ID = AChildList[j] then
              begin
                RemoveFromOrderList(AChildList[j]);
                Items.Objects[i].Free;
                Items.Delete(i);
                Break;
              end;
            end;
          end;
          Items.InsertObject(0, AnOrder.Text, AnOrder);
          Items[0] := GetPlainText(AnOrder, 0);
          uOrderList.Insert(0, AnOrder);
        end;
        FCompress := True;
        RedrawOrderList;
        AChildList.Clear;
        AChildList.Free;
      end;
    ORDER_SIGN:
      begin
        FCompress := True;
        SaveSignOrders; // sent when orders signed, AnOrder=nil
      end;
  end; { case }
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmOrders.FormCreate(Sender: TObject);
var
  ORUAPOFF: Integer;
begin
  inherited;
  OrderListClickProcessing := False;
  FixHeaderControlDelphi2006Bug(hdrOrders);
  PageID := CT_ORDERS;
  uOrderList := TList.Create;
  uEvtDCList := TList.Create;
  uEvtRLList := TList.Create;
  FDfltSort := OVS_CATINV;
  FCompress := False;
  FFromDCRelease := False;
  FSendDelayOrders := False;
  FNewEvent := False;
  FNeedShowModal := False;
  FAskForCancel := True;
  FRightAfterWriteOrderBox := False;
  FEventForCopyActiveOrders.EventType := #0;
  FEventForCopyActiveOrders.EventIFN := 0;
  FHighlightFromMedsTab := 0;
  FCalledFromWDO := False;
  FEvtOrderList := TStringlist.Create;
  FEvtColWidth := 0;
  FDontCheck := False;
  FParentComplexOrderID := '';
  mnuViewUAP.Visible := False; // rtw
  mnuViewDM.Visible := False; // rtw
  UAPContinue := False; // rtw
  // 508 black color scheme that causes problems
  FHighContrast2Mode := BlackColorScheme and
    (ColorToRGB(clInfoBk) <> ColorToRGB(clBlack));
  AddMessageHandler(lstOrders, RightClickMessageHandler);
  Callvista('ORTO UAPOFF', [], ORUAPOFF);
  if ORUAPOFF = 1 then // rtw
    mnuViewUAP.Visible := True;
  if ORUAPOFF = 1 then
    mnuViewDM.Visible := True; // rtw
  if User.NoOrdering then
  begin
    FNoOrderingOrWriteAccess := True;
    FAllowAlertAction := False;
  end
  else if WriteAccess(waOrders) then
  begin
    FNoOrderingOrWriteAccess := False;
    FAllowAlertAction := True;
  end
  else
  begin
    FNoOrderingOrWriteAccess := True;
    FAllowAlertAction := not EHRActive;
  end;
  lstWrite.Enabled := WriteAccess(waOrders);
  mnuActAlert.Enabled := FAllowAlertAction;
  mnuAct.Enabled := FAllowAlertAction;
  btnDelayedOrder.Enabled := WriteAccess(waDelayedOrders);
end;

procedure TfrmOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  RemoveMessageHandler(lstOrders, RightClickMessageHandler);
  ClearOrders(uOrderList);
  uEvtDCList.Clear;
  uEvtRLList.Clear;
  ClearOrderSheets;
  FEvtOrderList.Free;
  uEvtDCList.Free;
  uEvtRLList.Free;
  uOrderList.Free;
  if FOrderViewForActiveOrders <> nil then
    FOrderViewForActiveOrders := nil;
  FEventForCopyActiveOrders.EventType := #0;
  FEventForCopyActiveOrders.EventIFN := 0;
  FEventForCopyActiveOrders.EventName := '';
end;

procedure TfrmOrders.UMDestroy(var Message: TMessage);
{ sent by ordering dialog when it is closing }
begin
  lstWrite.ItemIndex := -1;
  // UnlockIfAble;  // - already in uOrders
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmOrders.PopUAPOrderPopup(Sender: TObject);  //modified for portland rtwstart
 begin
  inherited;
  if FNoOrderingOrWriteAccess then
  begin
    MnuContinueUAP.Enabled := False;
    MnuChangeUAP.Enabled := False;
    MnuRenewUAP.Enabled := False;
    MnuDiscontinueUAP.Enabled := False;
    MnuSignUAP.Enabled := False;
    exit;
  end;
  if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).DGroupName = 'Inpt. Meds') then
  begin
    MnuContinueUAP.Enabled := True;
    MnuChangeUAP.Enabled := True;
    MnuRenewUAP.Enabled := False;
  end
  else if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).DGroupName = 'Infusion') then
  begin
    MnuContinueUAP.Enabled := False;
    MnuChangeUAP.Enabled := False;
    MnuRenewUAP.Enabled := False;
  end
  else
  begin
    // else make sure it is available
    MnuRenewUAP.Enabled := True;
    MnuContinueUAP.Enabled := True;
    MnuChangeUAP.Enabled := True;
  end;
end;  //rtw stop

procedure TfrmOrders.PositionTopOrder(DGroup: Integer);
const
  SORT_FWD = 0;
  SORT_REV = 1;
  SORT_GRP_FWD = 2;
  SORT_GRP_REV = 3;

var
  i, Seq: Integer;
  AnOrder: TOrder;
begin
  with lstOrders do
  begin
    case (Ord(FCurrentView.ByService) * 2) + Ord(FCurrentView.InvChrono) of
      SORT_FWD:
        TopIndex := Items.Count - 1;
      SORT_REV:
        TopIndex := 0;
      SORT_GRP_FWD:
        begin
          Seq := SeqOfDGroup(DGroup);
          for i := Items.Count - 1 downto 0 do
          begin
            AnOrder := TOrder(Items.Objects[i]);
            if AnOrder.DGroupSeq <= Seq then
              Break;
          end;
          TopIndex := i;
        end;
      SORT_GRP_REV:
        begin
          Seq := SeqOfDGroup(DGroup);
          for i := 0 to Items.Count - 1 do
          begin
            AnOrder := TOrder(Items.Objects[i]);
            if AnOrder.DGroupSeq >= Seq then
              Break;
          end;
          TopIndex := i;
        end;
    end; { case }
  end; { with }
end;

procedure TfrmOrders.RedrawOrderList(KeepSelection: boolean = False);
{ redraws the Orders list, compensates for changes in item height by re-adding everything }
var
  i, idx, SaveTop: Integer;
  AnOrder: TOrder;
  SelectedIDs: string;

begin
  with lstOrders do
  begin
    SelectedIDs := U;
    if KeepSelection then
      for i := 0 to Items.Count - 1 do
        if Selected[i] and (Items.Objects[i] is TOrder) then
          SelectedIDs := SelectedIDs + TOrder(Items.Objects[i]).ID + U;
    LockDrawing;
    try
      SaveTop := TopIndex;
      Clear;
      repaint;
      for i := 0 to uOrderList.Count - 1 do
      begin
        AnOrder := TOrder(uOrderList.Items[i]);
        if (AnOrder.OrderTime <= 0) then
          Continue;
        idx := Items.AddObject(AnOrder.ID, AnOrder);
        Items[idx] := GetPlainText(AnOrder, idx);
        if KeepSelection and (Pos(U + AnOrder.ID + U, SelectedIDs) > 0) then
          Selected[idx] := True;
      end;
      TopIndex := SaveTop;
    finally
      UnlockDrawing;
    end;
  end;
end;

procedure TfrmOrders.RefreshOrderList(FromServer: Boolean; APtEvtID: string);
var
  i: Integer;
  DGroupName: string;
begin
  with FCurrentView do
  begin
    if EventDelay.EventIFN > 0 then
      FCompress := False;
    lstOrders.LockDrawing;
    try
      lstOrders.Clear;
      if FromServer then
      begin
        StatusText('Retrieving orders list...');
        if not FFromDCRelease then
        begin
          if not Notifications.IndOrderDisplay then
          begin
            if FCurrentView.Filter = -1 then
            begin
              SetCannedView(STS_ACTIVE, DGroupAll,
                'Active Orders (includes Pending & Recent Activity) - ALL SERVICES',
                False);
            end;
            LoadOrdersAbbr(uOrderList, FCurrentView, APtEvtID)
          end
          else
          begin
            LoadOrdersAbbr(uOrderList, FCurrentView, APtEvtID,
              Piece(Notifications.RecordID, '^', 2));
            StatusText(Notifications.RecordID);
          end;
        end
        else
        begin
          ClearOrders(uOrderList);
          uEvtDCList.Clear;
          uEvtRLList.Clear;
          LoadOrdersAbbr(uEvtDCList, uEvtRLList, FCurrentView, APtEvtID);
        end;
      end;
      if ((Length(APtEvtID) > 0) or (FCurrentView.Filter in [15, 16, 17, 24]) or
        (FCurrentView.EventDelay.PtEventIFN > 0)) and
        ((not FCompress) or (lstSheets.ItemIndex < 0)) and (not FFromDCRelease)
      then
        ExpandEventSection
      else
        CompressEventSection;
      if not FFromDCRelease then
      begin
        if FRightAfterWriteOrderBox and (EventDelay.EventIFN > 0) then
        begin
          SortOrders(uOrderList, False, True);
          FRightAfterWriteOrderBox := False;
        end;
        Callvista('ORTO DGROUP', [DGroup], DGroupName);  //rtw
        if ((DGroupName = 'PHARMACY UAP') or (DGroupName = 'DISCHARGE MEDS')) then
        begin
          SetOrderRevwCol(uOrderList) ;
        end
        else
            SortOrders(uOrderList, ByService, InvChrono);
        AddToListBox(uOrderList);
      end;
      if FFromDCRelease then
      begin
        if uEvtRLList.Count > 0 then
        begin
          SortOrders(uEvtRLList, True, True);
          for i := 0 to uEvtRLList.Count - 1 do
            uOrderList.Add(TOrder(uEvtRLList[i]));
        end;
        if uEvtDCList.Count > 0 then
        begin
          SortOrders(uEvtDCList, True, True);
          for i := 0 to uEvtDCList.Count - 1 do
            uOrderList.Add(TOrder(uEvtDCList[i]));
        end;
        AddToListBox(uOrderList);
      end;
    finally
      lstOrders.UnlockDrawing;
    end;
    lblOrders.Caption := ViewName;
    lstOrders.Caption := ViewName;
    if ViewName = 'Medications, Expiring' then
      lblOrders.Font.Style := [fsbold]
    else
      lblOrders.Font.Style := [];
    imgHide.Visible := not((Filter in [1, 2]) and (DGroup = DGroupAll));
    StatusText('');
  end;
end;

procedure TfrmOrders.UseDefaultSort;
begin
  with FCurrentView do
    case FDfltSort of
      OVS_CATINV:
        begin
          InvChrono := True;
          ByService := True;
        end;
      OVS_CATFWD:
        begin
          InvChrono := False;
          ByService := True;
        end;
      OVS_INVERSE:
        begin
          InvChrono := True;
          ByService := False;
        end;
      OVS_FORWARD:
        begin
          InvChrono := False;
          ByService := False;
        end;
    end;
end;

function TfrmOrders.CanChangeOrderView: Boolean;
{ Disallows changing view while doing delayed release orders. }
begin
  Result := True;
  if (lstSheets.ItemIndex > 0) and ActiveOrdering then
  begin
    InfoBox(TX_NOCHG_VIEW, TC_NOCHG_VIEW, MB_OK);
    Result := False;
  end;
end;

procedure TfrmOrders.SetOrderView(AFilter, ADGroup: Integer;
  const AViewName: string; NotifSort: Boolean; aDaysOverride: Integer = 0);
begin
  if not CanChangeOrderView then
    Exit;
  SetCannedView(AFilter, ADGroup, AViewName, NotifSort, aDaysOverride);
  RefreshOrderList(FROM_SERVER);
end;

// UAP mode us not multiselect - when not multiselect selcount is -1
function TfrmOrders.SelCount: integer;
begin
  if lstOrders.MultiSelect then
    Result := lstOrders.SelCount
  else if lstOrders.ItemIndex < 0 then
    Result := 0
  else
    Result := 1;
end;

procedure TfrmOrders.SetCannedView(AFilter, ADGroup: Integer;
  const AViewName: string; NotifSort: Boolean; aDaysOverride: Integer = 0);
{ sets up a 'canned' order view, assumes the date range is never restricted }
var
  tmpDate: TDateTime;
begin
  if not CanChangeOrderView then
    Exit;
  if lstSheets.Items.Count <= 0 then lstSheets.Items.Add('C;0^' + AViewName);
  lstSheets.ItemIndex := 0;
  FCurrentView := TOrderView(lstSheets.Items.Objects[0]);
  if FCurrentView = nil then
    FCurrentView := TOrderView.Create;
  with FCurrentView do
  begin
    TimeFrom := 0;
    TimeThru := 0;
    if NotifSort then
    begin
      ByService := False;
      InvChrono := True;
      if AFilter = STS_RECENT then
      begin
        tmpDate :=
          Trunc(FMDateTimeToDateTime
          (StrToFMDateTime(Piece(Piece(Notifications.RecordID, U, 2),
          ';', 3))));
        TimeFrom := DateTimeToFMDateTime(tmpDate - 5);
        TimeThru := FMNow;
      end;
      if AFilter = STS_UNVERIFIED then
      begin
        if Patient.AdmitTime > 0 then
          tmpDate := Trunc(FMDateTimeToDateTime(Patient.AdmitTime))
        else
          tmpDate := Trunc(FMDateTimeToDateTime(FMNow)) - 30;
        TimeFrom := DateTimeToFMDateTime(tmpDate);
        TimeThru := FMNow;
      end;
    end
    else
      UseDefaultSort;
    if AFilter = STS_EXPIRED then
    begin
      TimeFrom := ExpiredOrdersStartDT;
      if TimeFrom < 0 then
        ShowMessage('Error searching for FM date/time to begin search for expired orders');
      TimeThru := FMNow;
    end;

    { Update date range if aDaysOverride > 0 }
    if aDaysOverride > 0 then
    begin
      TimeFrom := DateTimeToFMDateTime(Trunc(Now) - aDaysOverride);
      TimeThru := FMNow;
    end;

    Filter := AFilter;
    DGroup := ADGroup;
    CtxtTime := 0;
    TextView := 0;
    ViewName := AViewName;
    lstSheets.Items[0] := 'C;0^' + ViewName;
    EventDelay.EventType := 'C';
    EventDelay.Specialty := 0;
    EventDelay.Effective := 0;
    if AViewName = 'Unified Action Profile' Then
    begin
      lstOrders.PopupMenu := PopUAPOrder;
      lstOrders.MultiSelect := False;
      frmOrders.mnuAct.Enabled := False;
      Callvista('ORTO SET UAP FLAG', ['1']);
      UAPViewCalling := True;
    end
    else
    begin
      lstOrders.PopupMenu := popOrder;
      lstOrders.MultiSelect := True;
      frmOrders.mnuAct.Enabled := FAllowAlertAction;
      Callvista('ORTO SET UAP FLAG', ['0']);
      UAPViewCalling := False;
    end;
  end;
end;

procedure TfrmOrders.mnuViewActiveClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
  OrderViewReset;
  SetOrderView(STS_ACTIVE, DGroupAll,
    'Active Orders (includes Pending & Recent Activity) - ALL SERVICES', False);
end;

procedure TfrmOrders.mnuViewCurrentClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
  OrderViewReset;
  SetOrderView(STS_CURRENT, DGroupAll,
    'Current Orders (Active & Pending Status Only) - ALL SERVICES', False);
end;

procedure TfrmOrders.mnuViewExpiringClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
  OrderViewReset;
  SetOrderView(STS_EXPIRING, DGroupAll,
    'Expiring Orders - ALL SERVICES', False);
end;

procedure TfrmOrders.mnuViewExpiredClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
  OrderViewReset;
  SetOrderView(STS_EXPIRED, DGroupAll,
    'Recently Expired Orders - ALL SERVICES', False);
end;

procedure TfrmOrders.mnuViewUnsignedClick(Sender: TObject);
begin
  inherited;
  OrderViewReset;
  SetOrderView(STS_UNSIGNED, DGroupAll,
    'Unsigned Orders - ALL SERVICES', False);
end;

procedure TfrmOrders.mnuViewCustomClick(Sender: TObject);
var
  AnOrderView: TOrderView;
begin
  inherited;
  if not CanChangeOrderView then
    Exit;
  OrderViewReset;
  AnOrderView := TOrderView.Create;
  // - this starts fresh instead, since CPRS v22
  try
    AnOrderView.Assign(FCurrentView);
    // RV - v27.1 - preload form with current view params
    (* AnOrderView.Filter    := STS_ACTIVE;                    - CQ #11261
      AnOrderView.DGroup    := DGroupAll;
      AnOrderView.ViewName  := 'All Services, Active';
      AnOrderView.InvChrono := True;
      AnOrderView.ByService := True;
      AnOrderView.CtxtTime  := 0;
      AnOrderView.TextView  := 0;
      AnOrderView.EventDelay.EventType := 'C';
      AnOrderView.EventDelay.Specialty := 0;
      AnOrderView.EventDelay.Effective := 0;
      AnOrderView.EventDelay.EventIFN  := 0;
      AnOrderView.EventDelay.EventName := 'All Services, Active'; *)

    SelectOrderView(AnOrderView);
    with AnOrderView do
      if Changed then
      begin
        FCurrentView.Assign(AnOrderView);
        if FCurrentView.Filter in [15, 16, 17, 24] then
        begin
          FCompress := False;
          mnuActRel.Visible := True;
          popOrderRel.Visible := True;
        end
        else
        begin
          mnuActRel.Visible := False;
          popOrderRel.Visible := False;
        end;

        // lstSheets.ItemIndex := -1;
        lstSheets.Items[0] := 'C;0^' + FCurrentView.ViewName; // v27.5 - RV

        lblWrite.Caption := 'Write Orders';
        lstWrite.Clear;
        lstWrite.Caption := lblWrite.Caption;
        LoadWriteOrders(lstWrite.Items);
        RefreshOrderList(FROM_SERVER);

        if ByService then
        begin
          if InvChrono then
            FDfltSort := OVS_CATINV
          else
            FDfltSort := OVS_CATFWD;
        end
        else
        begin
          if InvChrono then
            FDfltSort := OVS_INVERSE
          else
            FDfltSort := OVS_FORWARD;
        end;
      end;
  finally
    AnOrderView.Free;
  end;
end;

procedure TfrmOrders.mnuViewDfltShowClick(Sender: TObject);
var
  eventIndex: Integer;
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
  if not CanChangeOrderView then
    Exit;
  OrderViewReset;
  if HighlightFromMedsTab > 0 then
    lstSheets.ItemIndex := lstSheets.SelectByIEN(HighlightFromMedsTab);
  if lstSheets.ItemIndex < 0 then
    lstSheets.ItemIndex := 0;
  FCurrentView := TOrderView(lstSheets.Items.Objects[lstSheets.ItemIndex]);
  LoadOrderViewDefault(TOrderView(lstSheets.Items.Objects[0]));
  lstSheets.Items[0] := 'C;0^' + TOrderView(lstSheets.Items.Objects[0])
    .ViewName;
  if lstSheets.Count > 1 then
  begin
    pickEvent(lstSheets.Items, eventIndex);
    lstSheets.ItemIndex := eventIndex;
  end;
  lstOrders.PopupMenu := popOrder;
  lstOrders.MultiSelect := True;
  frmOrders.mnuAct.Enabled := FAllowAlertAction;
  Callvista('ORTO SET UAP FLAG', ['0']);
  UAPViewCalling := False;
  if lstSheets.ItemIndex > 0 then
    lstSheetsClick(Application)
  else
    RefreshOrderList(FROM_SERVER);
  if HighlightFromMedsTab > 0 then
    HighlightFromMedsTab := 0;
end;

procedure TfrmOrders.mnuViewDMClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := ''; // rtw
//  SetOrderView(DGroupIEN('DISCHARGE MEDS'), DGroupIEN('DISCHARGE MEDS'),
  SetOrderView(STS_CURRENT, DGroupIEN('DISCHARGE MEDS'),
    'Discharge Meds Review - Active, Pending, Expired, & D/C''d <90 days',
    False);
end;

procedure TfrmOrders.pickEvent(itemList: TStrings; var aReturn: Integer);
begin
  aReturn := OrdersPickED(itemList);
end;

procedure TfrmOrders.mnuViewDfltSaveClick(Sender: TObject);
var
  X: string;
begin
  inherited;
  with FCurrentView do
  begin
    X := Piece(ViewName, '(', 1) + CRLF;
    if TimeFrom > 0 then
      X := X + 'From: ' + MakeRelativeDateTime(TimeFrom);
    if TimeThru > 0 then
      X := X + '  Thru: ' + MakeRelativeDateTime(TimeThru);
    if InvChrono then
      X := X + CRLF + 'Sort order dates in reverse chronological order'
    else
      X := X + CRLF + 'Sort order dates in chronological order';
    if ByService then
      X := X + CRLF + 'Group orders by service'
    else
      X := X + CRLF + 'Don''t group orders by service';
  end;
  if InfoBox(TX_VWSAVE1 + X + TX_VWSAVE2, TC_VWSAVE, MB_YESNO) = IDYES then
    SaveOrderViewDefault(FCurrentView);
end;

procedure TfrmOrders.mnuViewDetailClick(Sender: TObject);
var
  i, j, idx: Integer;
  tmpList: TStringlist;
  aTmpList: TStringlist;
  BigOrderID: string;
  AnOrderID: string;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  tmpList := TStringlist.Create;
  idx := 0;
  try
    with lstOrders do
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
        begin
          StatusText('Retrieving order details...');
          BigOrderID := TOrder(Items.Objects[i]).ID;
          AnOrderID := Piece(BigOrderID, ';', 1);
          if StrToFloatDef(AnOrderID, 0) = 0 then
            ShowMsg('Detail view is not available for selected order.')
          else
          begin
            getDetailOrder(BigOrderID, tmpList);
            if ((TOrder(Items.Objects[i]).DGroupName = 'Inpt. Meds') or
              (TOrder(Items.Objects[i]).DGroupName = 'Out. Meds') or
              (TOrder(Items.Objects[i]).DGroupName = 'Clinic Infusions') or
              (TOrder(Items.Objects[i]).DGroupName = 'Clinic Medications') or
              (TOrder(Items.Objects[i]).DGroupName = 'Infusion')) then
            begin
              tmpList.Add('');
              tmpList.Add(StringOfChar('=', 74));
              tmpList.Add('');
              aTmpList := TStringlist.Create;
              try
                MedAdminHistory(AnOrderID, aTmpList);
                FastAddStrings(aTmpList, tmpList);
              finally
                FreeAndNil(aTmpList);
              end;
            end;

            if CheckOrderGroup(AnOrderID) = 1 then // if it's UD group
            begin
              for j := 0 to tmpList.Count - 1 do
              begin
                if Pos('PICK UP', UpperCase(tmpList[j])) > 0 then
                begin
                  idx := j;
                  Break;
                end;
              end;
              if idx > 0 then
                tmpList.Delete(idx);
            end;
            ReportBox(tmpList, 'Order Details - ' + BigOrderID, True);
          end;
          StatusText('');
          if (frmFrame.TimedOut) or (frmFrame.CCOWDrivedChange) then
            Exit; // code added to correct access violation on timeout
          Selected[i] := False;
        end;
  finally
    tmpList.Free;
  end;
end;

procedure TfrmOrders.mnuViewResultClick(Sender: TObject);
var
  i: Integer;
  BigOrderID: string;
  sl: TSTrings;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        StatusText('Retrieving order results...');
        BigOrderID := TOrder(Items.Objects[i]).ID;
        if Length(Piece(BigOrderID, ';', 1)) > 0 then
          begin
            sl := TStringList.Create;
            try
              if ResultOrder(BigOrderID,sl) then
                ReportBox(sl, 'Order Results - ' + BigOrderID, True);
            finally
              sl.Free;
            end;
          end;
        Selected[i] := False;
        StatusText('');
      end;
end;

procedure TfrmOrders.mnuViewResultsHistoryClick(Sender: TObject);
var
  sl: TStrings;
  i: Integer;
  BigOrderID: string;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        StatusText('Retrieving order results...');
        BigOrderID := TOrder(Items.Objects[i]).ID;
        if Length(Piece(BigOrderID, ';', 1)) > 0 then
          begin
            sl := TStringList.Create;
            try
              if getResultOrderHistory(BigOrderID,sl) then
                ReportBox(sl, 'Order Results History- ' + BigOrderID, True)
              else
                ShowMessage('Error getting Result Order History');
            finally
              sl.Free;
            end;
          end;
        Selected[i] := False;
        StatusText('');
      end;
end;

procedure TfrmOrders.OrderViewReset();
begin
  if Notifications.Active then
  begin
// do NOT clear notifications here!!!
//    Notifications.Clear;
    frmFrame.stsArea.Panels.Items[1].Text := '';
  end;
end;

{ lstSheets events ------------------------------------------------------------------------- }

procedure TfrmOrders.ClearOrderSheets;
{ delete all order sheets & associated TOrderView objects, set current view to nil }
var
  I: Integer;
begin
  for I := 0 to lstSheets.Items.Count - 1 do
    TOrderView(lstSheets.Items.Objects[I]).Free;
  lstSheets.Clear;
  FCurrentView := nil;
end;

procedure TfrmOrders.InitOrderSheets;
{ sets up list of order sheets based on what orders are on the server in delayed status for pt }
var
  i: Integer;
  AnEventInfo: String;
  AnOrderView: TOrderView;
begin
  ClearOrderSheets;
  LoadOrderSheetsED(lstSheets.Items);
  // the 1st item in lstSheets should always be the 'Current' view
  if CharAt(lstSheets.Items[0], 1) <> 'C' then
    Exit;
  AnOrderView := TOrderView.Create;
  AnOrderView.Filter := STS_ACTIVE;
  AnOrderView.DGroup := DGroupAll;
  AnOrderView.ViewName := 'All Services, Active';
  AnOrderView.InvChrono := True;
  AnOrderView.ByService := True;
  AnOrderView.CtxtTime := 0;
  AnOrderView.TextView := 0;
  AnOrderView.EventDelay.EventType := 'C';
  AnOrderView.EventDelay.Specialty := 0;
  AnOrderView.EventDelay.Effective := 0;
  AnOrderView.EventDelay.EventIFN := 0;
  AnOrderView.EventDelay.EventName := 'All Services, Active';
  lstSheets.Items.Objects[0] := AnOrderView;
  FCurrentView := AnOrderView;
  FOrderViewForActiveOrders := AnOrderView;
  // now setup the event-delayed views in lstSheets, each with its own TOrderView object
  with lstSheets do
    for i := 1 to Items.Count - 1 do
    begin
      AnOrderView := TOrderView.Create;
      AnOrderView.DGroup := DGroupAll;
      AnEventInfo := EventInfo(Piece(Items[i], '^', 1));
      AnOrderView.EventDelay.EventType := CharAt(AnEventInfo, 1);
      AnOrderView.EventDelay.EventIFN := StrToInt(Piece(AnEventInfo, '^', 2));
      AnOrderView.EventDelay.EventName := Piece(AnEventInfo, '^', 3);
      AnOrderView.EventDelay.Specialty := 0;
      AnOrderView.EventDelay.Effective := 0;
      case AnOrderView.EventDelay.EventType of
        'A':
          AnOrderView.Filter := 15;
        'D':
          AnOrderView.Filter := 16;
        'T':
          AnOrderView.Filter := 17;
      end;
      AnOrderView.ViewName := DisplayText[i] + ' Orders';
      AnOrderView.InvChrono := FCurrentView.InvChrono;
      AnOrderView.ByService := FCurrentView.ByService;
      AnOrderView.CtxtTime := 0;
      AnOrderView.TextView := 0;
      Items.Objects[i] := AnOrderView;
    end; { for }
  lblWrite.Caption := 'Write Orders';
  lstWrite.Caption := lblWrite.Caption;
end;

procedure TfrmOrders.lstSheetsClick(Sender: TObject);
const
  TX_EVTDEL =
    'There are no orders tied to this event, would you like to cancel it?';
var
  AnOrderView: TOrderView;
  APtEvtID: string;
begin
  inherited;
  if not CloseOrdering then
    Exit;
  FCompress := True;
  if lstSheets.ItemIndex < 0 then
    Exit;
  with lstSheets do
  begin
    AnOrderView := TOrderView(Items.Objects[ItemIndex]);
    AnOrderView.EventDelay.PtEventIFN :=
      StrToIntDef(Piece(Items[lstSheets.ItemIndex], '^', 1), 0);
    if AnOrderView.EventDelay.PtEventIFN > 0 then
      FCompress := False;
  end;
  // CQ 18660 Orders for events should be modal. Orders for non-event should not be modal
  if AnOrderView.EventDelay.EventIFN = 0 then
    NeedShowModal := False
  else
    NeedShowModal := True;
  if (FCurrentView <> nil) and
    (AnOrderView.EventDelay.EventIFN <> FCurrentView.EventDelay.EventIFN) and
    (FCurrentView.EventDelay.EventIFN > 0) then
  begin
    APtEvtID := IntToStr(FCurrentView.EventDelay.PtEventIFN);
    if frmMeds.ActionOnMedsTab then
      Exit;
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName)) then
      Exit;
    if (not FDontCheck) and DeleteEmptyEvt(APtEvtID,
      FCurrentView.EventDelay.EventName) then
    begin
      ChangesUpdate(APtEvtID);
      FCompress := True;
      InitOrderSheetsForEvtDelay;
      lstSheets.ItemIndex := 0;
      lstSheetsClick(Self);
      Exit;
    end;
  end;

  if (FCurrentView = nil) or (AnOrderView <> FCurrentView) or
    ((AnOrderView = FCurrentView) and (FCurrentView.EventDelay.EventIFN > 0))
  then
  begin
    FCurrentView := AnOrderView;
    if FCurrentView.EventDelay.EventIFN > 0 then
    begin
      FCompress := False;
      lstWrite.Items.Clear;
      lblWrite.Caption := 'Write ' + FCurrentView.ViewName;
      lstWrite.Caption := lblWrite.Caption;
      lstWrite.Items.Clear;
      LoadWriteOrdersED(lstWrite.Items,
        IntToStr(AnOrderView.EventDelay.EventIFN));
      if lstWrite.Items.Count < 1 then
        LoadWriteOrders(lstWrite.Items);
      RefreshOrderList(FROM_SERVER,
        Piece(lstSheets.Items[lstSheets.ItemIndex], '^', 1));
      mnuActRel.Visible := True;
      popOrderRel.Visible := True;
      if (lstOrders.Items.Count = 0) and (not NewEvent) then
      begin
        if frmMeds.ActionOnMedsTab then
          Exit;
        if (FCurrentView.EventDelay.PtEventIFN > 0) and
          (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
          FCurrentView.EventDelay.EventName)) then
          Exit;
        if PtEvtEmpty(Piece(lstSheets.Items[lstSheets.ItemIndex], '^', 1)) then
        begin
          if (FAskForCancel) and
            (InfoBox(TX_EVTDEL, 'Confirmation', MB_YESNO or MB_ICONQUESTION)
            = IDYES) then
          begin
            DeletePtEvent(Piece(lstSheets.Items[lstSheets.ItemIndex], '^', 1));
            FCompress := True;
            lstSheets.Items.Objects[lstSheets.ItemIndex].Free;
            lstSheets.Items.Delete(lstSheets.ItemIndex);
            FCurrentView := TOrderView.Create;
            lstSheets.ItemIndex := 0;
            lstSheetsClick(Self);
            Exit;
          end;
        end;
      end;
      if NewEvent then
        NewEvent := False;
    end
    else
    begin
      NewEvent := False;
      mnuActRel.Visible := False;
      popOrderRel.Visible := False;
      lblWrite.Caption := 'Write Orders';
      lstWrite.Caption := lblWrite.Caption;
      LoadWriteOrders(lstWrite.Items);
      RefreshOrderList(FROM_SERVER);
    end;
  end
  else
  begin
    mnuActRel.Visible := False;
    popOrderRel.Visible := False;
    lblWrite.Caption := 'Write Orders';
    lstWrite.Caption := lblWrite.Caption;
    LoadWriteOrders(lstWrite.Items);
    RefreshOrderList(FROM_SERVER);
  end;
  FCompress := True;
end;

{ lstOrders events ------------------------------------------------------------------------- }

procedure TfrmOrders.RetrieveVisibleOrders(AnIndex: Integer);
var
  i: Integer;
  tmplst: TList;
  AnOrder: TOrder;
begin
  tmplst := TList.Create;
  try
    for i := AnIndex to AnIndex + 100 do
    begin
      if i >= uOrderList.Count then
        Break;
      AnOrder := TOrder(uOrderList.Items[i]);
      if not AnOrder.Retrieved then
        tmplst.Add(AnOrder);
    end;
    RetrieveOrderFields(tmplst, FCurrentView.TextView, FCurrentView.CtxtTime);
  finally
    tmplst.Free;
  end;
end;

procedure TfrmOrders.RightClickMessageHandler(var Msg: TMessage;
  var Handled: Boolean);
begin
  if Msg.Msg = WM_RBUTTONUP then
    lstOrders.RightClickSelect := (SelCount < 1);
end;

function TfrmOrders.GetPlainText(AnOrder: TOrder; Index: Integer): string;
var
  i: Integer;
  FirstColumnDisplayed: Integer;
  X: string;
begin
  Result := '';
  if hdrOrders.Sections[0].Text = 'Event' then
    FirstColumnDisplayed := 0
  else
    FirstColumnDisplayed := 1;
  for i := FirstColumnDisplayed to 10 do
  begin
    X := GetOrderText(AnOrder, index, i);
    if X <> '' then
      Result := Result + hdrOrders.Sections[i].Text + ': ' + X + CRLF;
  end;
end;

function TfrmOrders.MeasureColumnHeight(AnOrder: TOrder; Index: Integer;
  Column: Integer): Integer;
var
  ARect: TRect;
  X: string;
begin
  X := GetOrderText(AnOrder, Index, Column);
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := hdrOrders.Sections[Column].Width - 6;
  Result := WrappedTextHeightByFont(lstOrders.Canvas, lstOrders.Font, X, ARect);
end;

procedure TfrmOrders.lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
var
  AnOrder: TOrder;
  NewHeight: Integer;
begin
  NewHeight := AHeight;
  with lstOrders do
    if Index < Items.Count then
    begin
      AnOrder := TOrder(uOrderList.Items[Index]);
      if AnOrder <> nil then
        with AnOrder do
        begin
          if not AnOrder.Retrieved then
            RetrieveVisibleOrders(Index);
          Canvas.Font.Style := [];
          if Changes.Exist(CH_ORD, ID) then
            Canvas.Font.Style := [fsbold];
        end;
      { measure height of event delayed name }
      if hdrOrders.Sections[0].Text = 'Event' then
        NewHeight := HigherOf(AHeight, MeasureColumnHeight(AnOrder, Index, 0));
      { measure height of order text }
      NewHeight := HigherOf(NewHeight, MeasureColumnHeight(AnOrder, Index, 2));
      { measure height of start/stop times }
      NewHeight := HigherOf(NewHeight, MeasureColumnHeight(AnOrder, Index, 3));
      if NewHeight > 255 then
        NewHeight := 255; // This is maximum allowed by a Windows
      if NewHeight < 13 then
        NewHeight := 13;
    end;
  AHeight := NewHeight;
end;

function TfrmOrders.GetStartStopText(StartTime: string;
  StopTime: string): string;
var
  Y: string;
begin
  Result := FormatFMDateTimeStr('mm/dd/yy hh:nn', StartTime);
  if IsFMDateTime(StartTime) and (Length(StartTime) = FM_DATE_ONLY) then
    Result := Piece(Result, ' ', 1);
  if Length(Result) > 0 then
    Result := 'Start: ' + Result;
  Y := FormatFMDateTimeStr('mm/dd/yy hh:nn', StopTime);
  if IsFMDateTime(StopTime) and (Length(StopTime) = FM_DATE_ONLY) then
    Y := Piece(Y, ' ', 1);
  if Length(Y) > 0 then
    Result := Result + CRLF + 'Stop: ' + Y;
end;

function TfrmOrders.GetOrderText(AnOrder: TOrder; Index: Integer;
  Column: Integer): string;
begin
  if AnOrder <> nil then
    with AnOrder do
    begin
      case Column of
        0:
          begin
            Result := EventName;
            if (Index > 0) and
              (Result = TOrder(lstOrders.Items.Objects[Index - 1]).EventName)
            then
              Result := '';
          end;
        1:
          begin
            Result := DGroupName;
            if (Index > 0) and
              (Result = TOrder(lstOrders.Items.Objects[Index - 1]).DGroupName)
            then
              Result := '';
            if lstSheets.Items[0] = 'C;0^Unified Action Profile' then
              Result := DGroupName;
          end;
        2:
          begin
            Result := Text;
            if AnOrder.Flagged then
            begin
              if Notifications.Active and (not AnOrder.IsFlagTextLoaded) then
                LoadFlagReasons(uOrderList);
              if Trim(AnOrder.FlagText) <> '' then
              begin
                Result := Format('%s'#13#10'%s', [Result, AnOrder.FlagText]);
              end else begin
                Result := Result + '  *Flagged*';
              end;
            end;
          end;
        3:
          Result := GetStartStopText(StartTime, StopTime);
        4:
          begin
            Result := MixedCase(ProviderName);
            Result := Piece(Result, ',', 1) + ',' + Piece(Result, ',', 2);
          end;
        5:
          Result := VerNurse;
        6:
          Result := VerClerk;
        7:
          Result := ChartRev;
        8:
          if ParkedStatus <> '' then // NSR#20090509 AA 2015/09/29
            Result := ParkedStatus
          else
            Result := NameOfStatus(Status); // PaPI --?
        9:
          Result := MixedCase(AnOrder.OrderLocName);
        10:
          Result := ORUAPreviewresult;
      end;
    end;
end;

procedure TfrmOrders.lstOrdersDrawItem(Control: TWinControl; Index: Integer;
  TheRect: TRect; State: TOwnerDrawState);
var
  i, RightSide: Integer;
  FirstColumnDisplayed: Integer;
  X: string;
  ARect: TRect;
  AnOrder: TOrder;
  SaveColor: TColor;
begin
  inherited;
  with lstOrders do
  begin
    ARect := TheRect;
    if odSelected in State then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    RightSide := -2;
    for i := 0 to 9 do
    begin
      RightSide := RightSide + hdrOrders.Sections[i].Width;
      Canvas.MoveTo(RightSide, ARect.Bottom - 1);
      Canvas.LineTo(RightSide, ARect.Top);
    end;

    if Index < Items.Count then
    begin
      AnOrder := TOrder(Items.Objects[Index]);
      if hdrOrders.Sections[0].Text = 'Event' then
        FirstColumnDisplayed := 0
      else
        FirstColumnDisplayed := 1;
      if AnOrder <> nil then
        with AnOrder do
          for i := FirstColumnDisplayed to 10 do
          begin
            if i > FirstColumnDisplayed then
              ARect.Left := ARect.Right + 2
            else
              ARect.Left := 2;
            ARect.Right := ARect.Left + hdrOrders.Sections[i].Width - 6;
            X := GetOrderText(AnOrder, Index, i);

           if X = 'Non-VA Meds (Documentation)' then
              X := 'Non-VA Meds ' + #13#10 + '(Documentation)';

            SaveColor := Canvas.Brush.Color;
            if i = FirstColumnDisplayed then
            begin
              if Flagged then
              begin
                Canvas.Brush.Color := Get508CompliantColor(clRed);
                Canvas.FillRect(ARect);
              end;
            end;
            if i = 2 then
            begin
              Canvas.Font.Style := [];
              if Changes.Exist(CH_ORD, AnOrder.ID) then
                Canvas.Font.Style := [fsbold];
              if not(odSelected in State) and (AnOrder.Signature = OSS_UNSIGNED)
              then
              begin
                if FHighContrast2Mode then
                  Canvas.Font.Color := clBlue
                else
                  Canvas.Font.Color := Get508CompliantColor(clBlue);
              end;
            end;
            if (i = 2) or (i = 3) or (i = 0) then
              DrawText(Canvas.Handle, PChar(X), Length(X), ARect,
                DT_LEFT or DT_NOPREFIX or DT_WORDBREAK or DT_EXPANDTABS)
                // AA: DT_EXPANDTABS added to support text formatting
            else
              DrawText(Canvas.Handle, PChar(X), Length(X), ARect,
                DT_LEFT or DT_NOPREFIX);
            Canvas.Brush.Color := SaveColor;
            ARect.Right := ARect.Right + 4;
          end;
    end;
  end;
end;

procedure TfrmOrders.lstOrdersHintShow(var HintText: string;
  var CanShow: Boolean);
const
  oldidx: Longint = -1;
  oldColidx: Longint = -1;
var
  aHeader: THeaderControl;
  idx: Longint;
  iStart, iStop: Longint;
  aPoint: TPoint;

  function getHintString(AnItem: Integer): String;
  var
    AnOrder: TOrder;
  begin
    Result := '';
    AnOrder := TOrder(lstOrders.Items.Objects[AnItem]);
    if (AnOrder <> nil) and (pos('PSO', AnOrder.GetPackage) = 1) then
    begin
      Result := GetOrderText(AnOrder, AnItem, 8);
      Result := papiMedOrderStatusHint(Result);
    end;
  end;

begin
  aPoint := Mouse.CursorPos;
  aPoint := lstOrders.ScreenToClient(aPoint);
  aHeader := hdrOrders; //
  iStart := aHeader.Sections.Items[0].Width + aHeader.Sections.Items[1].Width
    + aHeader.Sections.Items[2].Width + aHeader.Sections.Items[3].Width +
    aHeader.Sections.Items[4].Width + aHeader.Sections.Items[5].Width +
    aHeader.Sections.Items[6].Width + aHeader.Sections.Items[7].Width + 7;
  iStop := iStart + aHeader.Sections.Items[8].Width;
  if (iStart > aPoint.X) or (aPoint.X > iStop) then
  begin
    CanShow := false;
    Exit;
  end
  else

  // TResponsiveGUI.ProcessMessages;

  idx := lstOrders.ItemAtPos(Point(aPoint.X, aPoint.Y), True);
  if (idx < 0) or (idx >= lstOrders.Items.Count) then
    exit;

 { if (idx < 0) or (idx = oldidx) then
    Exit;
  oldidx := idx;  }
 // TResponsiveGUI.ProcessMessages;
 // Application.CancelHint;

  HintText := getHintString(idx);
  if HintText = '' then
    CanShow := false;
end;

procedure TfrmOrders.hdrOrdersSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  FEvtColWidth := hdrOrders.Sections[0].Width;
  RedrawOrderList;
  lstOrders.Invalidate;
  pnlRight.Refresh;
  pnlLeft.Refresh;
end;

procedure TfrmOrders.lstOrdersDblClick(Sender: TObject);
begin
  inherited;
  mnuViewDetailClick(Self);
end;

{ Writing Orders }

procedure TfrmOrders.lstWriteClick(Sender: TObject);
{ ItemID = DlgIEN;FormID;DGroup;DlgType }
var
  Activated: Boolean;
  NextIndex: Integer;
  Try2Unlock: boolean;

begin
  if OrderListClickProcessing then
    Exit;
  OrderListClickProcessing := True;
  try
    // Make sure this gets set to false prior to exiting.
    // if PatientStatusChanged then exit;
    if BILLING_AWARE then // CQ5114
      fODConsult.displayDXCode := ''; // CQ5114

    inherited;
    // frmFrame.UpdatePtInfoOnRefresh;
    if not ActiveOrdering then
      SetConfirmEventDelay;
    NextIndex := lstWrite.ItemIndex;
    if (NextIndex < 0) then
      Exit;
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName)) then
      Exit;
    if not ReadyForNewOrder(FCurrentView.EventDelay) then
    begin
      lstWrite.ItemIndex := RefNumFor(Self);
      Exit;
    end;

    Try2Unlock := False;
    try
      // don't write delayed orders for non-VA meds:
      if (FCurrentView.EventDelay.EventIFN > 0) and
        (Piece(lstWrite.ItemID, ';', 2) = '145') then
      begin
        InfoBox('Delayed orders cannot be written for Non-VA Medications.',
          'Meds, Non-VA', MB_OK);
        Try2Unlock := True;
        Exit;
      end;

      if (FCurrentView <> nil) and (FCurrentView.EventDelay.EventIFN > 0) then
        FRightAfterWriteOrderBox := True;
      lstWrite.ItemIndex := NextIndex;
      // (ReadyForNewOrder may reset ItemIndex to -1)
      if FCurrentView <> nil then
        with FCurrentView.EventDelay do
          if (EventType = 'D') and (Effective = 0) then
            if not ObtainEffectiveDate(Effective) then
            begin
              lstWrite.ItemIndex := -1;
              Try2Unlock := True;
              Exit;
            end;
      if frmFrame.CCOWDrivedChange then
      begin
        Try2Unlock := True;
        Exit;
      end;
      PositionTopOrder(StrToIntDef(Piece(lstWrite.ItemID, ';', 3), 0));
      // position Display Group
      case CharAt(Piece(lstWrite.ItemID, ';', 4), 1) of
        'A':
          Activated := ActivateAction(Piece(lstWrite.ItemID, ';', 1), Self,
            lstWrite.ItemIndex);
        'D', 'Q':
          Activated := ActivateOrderDialog(Piece(lstWrite.ItemID, ';', 1),
            FCurrentView.EventDelay, Self, lstWrite.ItemIndex);
        'H':
          Activated := ActivateOrderHTML(Piece(lstWrite.ItemID, ';', 1),
            FCurrentView.EventDelay, Self, lstWrite.ItemIndex);
        'M':
          Activated := ActivateOrderMenu(Piece(lstWrite.ItemID, ';', 1),
            FCurrentView.EventDelay, Self, lstWrite.ItemIndex);
        'O':
          Activated := ActivateOrderSet(Piece(lstWrite.ItemID, ';', 1),
            FCurrentView.EventDelay, Self, lstWrite.ItemIndex);
      else
        Activated := not(InfoBox(TX_BAD_TYPE, TC_BAD_TYPE, MB_OK) = IDOK);
        Try2Unlock := True;
      end; { case }
      if not Activated then
      begin
        lstWrite.ItemIndex := -1;
        FRightAfterWriteOrderBox := False;
        Try2Unlock := True;
      end;
      if (lstSheets.ItemIndex > -1) and
        (Pos('EVT', Piece(lstSheets.Items[lstSheets.ItemIndex], '^', 1)) > 0) then
      begin
        InitOrderSheetsForEvtDelay;
        lstSheets.ItemIndex := 0;
        lstSheetsClick(Self);
      end;
      OrderListClickProcessing := False;
      if (FCurrentView <> nil) and (FCurrentView.EventDelay.PtEventIFN > 0) and
        (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
        FCurrentView.EventDelay.EventName)) then
        Exit;
    finally
      if Try2Unlock and (not ActiveOrdering) then
        UnlockIfAble;
    end;
  finally
    OrderListClickProcessing := False;
  end;
end;

procedure TfrmOrders.SaveSignOrders;
var
  SaveOrderID: string;
  i: Integer;
begin
  // unlock if able??
  if not PatientViewed then
    Exit;
  if not frmFrame.ContextChanging then
    with lstOrders do
    begin
      if (TopIndex < Items.Count) and (TopIndex > -1) then
        SaveOrderID := TOrder(Items.Objects[TopIndex]).ID
      else
        SaveOrderID := '';
      if lstSheets.ItemIndex > 0 then
        RefreshOrderList(FROM_SERVER,
          Piece(lstSheets.Items[lstSheets.ItemIndex], '^', 1))
      else
        RefreshOrderList(FROM_SERVER);
      if Length(SaveOrderID) > 0 then
        for i := 0 to Items.Count - 1 do
          if TOrder(Items.Objects[i]).ID = SaveOrderID then
            TopIndex := i;
    end;
end;

{ Action menu events ----------------------------------------------------------------------- }

procedure TfrmOrders.ValidateSelected(const AnAction, WarningMsg,
  WarningTitle: string);
{ loop to validate action on each selected order, deselect if not valid }
var
  i, ix, jx: Integer;
  AnOrder: TOrder;
  ErrMsg, AParentID, CplxOrderMsg, ParentOrderID, CurrentActID: string;
  GoodList,BadList, CheckedList, ChildList: TStringList;
  complexorder: Boolean;

begin
  GoodList := nil;
  BadList  := nil;
  CheckedList := nil;
  ChildList := nil;
  try
    GoodList := TStringList.Create;
    BadList  := TStringList.Create;
    CheckedList := TStringList.Create;
    ChildList := TStringList.Create;
    with lstOrders do
    begin
      WriteAccessV.BeginErrors;
      try
        for i := 0 to Items.Count - 1 do
          if Selected[i] then
          begin
            AnOrder := TOrder(Items.Objects[i]);
            if (not canWriteOrder(AnOrder, AnAction)) then
              Selected[i] := False;
          end;
      finally
        WriteAccessV.EndErrors(False);
      end;
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
        begin
          AnOrder := TOrder(Items.Objects[i]);
          if (AnAction = 'RN') and
            (AnOrder.DGroupName = 'Non-VA Meds (Documentation)') then
          begin
            Selected[i] := False;
            MessageDlg('Unable to renew documented NON-VA medication',
              mtWarning, [mbOK], 0);
            Renewcancel2 := True;
            Continue;
          end;

          if (AnAction = 'RN') and
            (PassDrugTest(StrToInt(Piece(AnOrder.ID, ';', 1)), 'E', True, True)
            = True) then
          begin
            ShowMsg('Cannot renew Clozapine orders.');
            Selected[i] := False;
            Continue;
          end;
          if (AnAction = 'RN') and (AnOrder.Status = 6) and
            (AnOrder.DGroupName = 'Inpt. Meds') and (Patient.inpatient) and
            (IsClinicLoc(Encounter.Location)) then
          begin
            Selected[i] := False;
            MessageDlg
              ('You cannot renew inpatient medication order on a clinic location for selected inpatient.',
              mtWarning, [mbOK], 0);
          end;
          if ((AnAction = 'RN') or (AnAction = 'EV')) and
            (AnOrder.EnteredInError = 0) then // AGP Changes PSI-04053
          begin
            if not IsValidSchedule(AnOrder.ID) then
            begin
              if (AnAction = 'RN') then
                ShowMsg('The order contains invalid schedule and can not be renewed.')
              else if (AnAction = 'EV') then
                ShowMsg('The order contains invalid schedule and can not be changed to event delayed order.');

              Selected[i] := False;
              Continue;
            end;
          end;
          // AGP CHANGE ORDER ENTERED IN ERROR TO ALLOW SIGNATURE AND VERIFY ACTIONS 26.23
          if ((AnOrder.EnteredInError = 1) and ((AnOrder.Status = 1) or
            (AnOrder.Status = 13))) and
            ((AnAction <> 'ES') and (AnAction <> 'VR') and (AnAction <> 'CR'))
          then
          begin
            InfoBox(AnOrder.Text + WarningMsg +
              'This order has been mark as Entered in error.',
              WarningTitle, MB_OK);
            Selected[i] := False;
            Continue;
          end;
          if ((AnAction <> OA_RELEASE) and (AnOrder.EnteredInError = 0)) or (((AnOrder.EnteredInError = 1) and ((AnOrder.Status = 1) or (AnOrder.Status = 13))) and
                (AnAction = 'ES')) then
             ValidateOrderAction(AnOrder.ID, AnAction, ErrMsg)
          //AGP END Changes
            else ErrMsg := '';
          case StrToIntDef(Piece(ErrMsg,U,1),0) of
              1:  ErrMsg := TX_DEAFAIL;  //prescriber has an invalid or no DEA#
              2:  ErrMsg := TX_SCHFAIL + Piece(ErrMsg,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
              3:  ErrMsg := TX_NO_DETOX;  //prescriber has an invalid or no Detox#
              4:  ErrMsg := TX_EXP_DEA1 + Piece(ErrMsg,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
              5:  ErrMsg := TX_EXP_DETOX + Piece(ErrMsg,U,2) + '.';  //valid detox#, but expired DEA#
          end;
          if (Length(ErrMsg)>0) and (Pos('COMPLEX-PSI',ErrMsg)<1) then
          begin
            InfoBox(AnOrder.Text + WarningMsg + ErrMsg, WarningTitle, MB_OK);
            Selected[i] := False;
            Continue;
          end;
          if (Length(ErrMsg)>0) and IsFirstDoseNowOrder(AnOrder.ID) and (AnAction <> 'RL') then
          begin
            InfoBox(AnOrder.Text + WarningMsg + ErrMsg, WarningTitle, MB_OK);
            Selected[i] := False;
            Continue;
          end;
          if (Length(ErrMsg)>0) and ( (AnAction = OA_CHGEVT) or (AnAction = OA_EDREL) ) then
          begin
            InfoBox(AnOrder.Text + WarningMsg + ErrMsg, WarningTitle, MB_OK);
            Selected[i] := False;
            Continue;
          end;
          AParentID := '';
          complexOrder := IsValidActionOnComplexOrder(AnOrder.ID, AnAction,TListBox(lstOrders),CheckedList,ErrMsg, AParentID);
          TOrder(Items.Objects[i]).ParentID := AParentID;
          if (Length(ErrMsg)=0) and (AnAction=OA_EDREL) then
             begin
               if (AnOrder.Signature = 2) and (not VerbTelPolicyOrder(AnOrder.ID)) then
                  begin
                    ErrMsg := 'Need to be signed first.';
                    Selected[i] := False;
                  end;
             end;

              if (AnAction = OA_CHGEVT) or (AnAction = OA_EDREL) then
              begin
                if Length(ErrMsg) > 0 then
                begin
                  Selected[i] := False;
                  BadList.Add(AnOrder.Text + '^' + ErrMsg);
                end
                else
                  GoodList.Add(AnOrder.Text);
              end;

              if (Length(ErrMsg) > 0) and (AnAction <> OA_CHGEVT) and
                (AnAction <> OA_EDREL) then
              begin
                if Pos('COMPLEX-PSI', ErrMsg) > 0 then
                  ErrMsg := TX_COMPLEX;
                InfoBox(AnOrder.Text + WarningMsg + ErrMsg, WarningTitle, MB_OK);
                Selected[i] := False;
              end;

          if Selected[i] then
          begin
            WarningOrderAction(AnOrder.ID, AnAction, ErrMsg);
            if (Piece(ErrMsg,U,1) = '1') and (InfoBox(AnOrder.Text +
                TitrationSafeText(WarningMsg, CRLF + Piece(ErrMsg,U,2)),
                'Warning', MB_YESNO or MB_ICONWARNING) = IDNO) then
              Selected[i] := False;
          end;
          //cvw 529181 the following block prevents discontinuation of complex orders if any
          //of the orders (parent or child) are locked.
          if Selected[i] and (not OrderIsLocked(AnOrder.ID, AnAction)) then
          begin
            Selected[i] := False;

            if (ComplexOrder) and (AnAction = OA_DC ) then
            begin
              CplxOrderMsg := '';
              ParentOrderID := '';
              CurrentActID := '';
              ValidateComplexOrderAct(AnOrder.ID, CplxOrderMsg);
              ParentOrderID := Piece(CplxOrderMsg, '^', 2);
              CurrentActID := Piece(AnOrder.ID, ';', 2);

              GetChildrenOfComplexOrder(ParentOrderID, CurrentActID, ChildList);

              for ix := 0 to ChildList.Count - 1 do
              begin
                for jx := 0 to lstOrders.Items.Count - 1 do
                begin
                  if TOrder(lstOrders.Items.Objects[jx]).ID = ChildList[ix] then
                  begin
                    TOrder(lstOrders.Items.Objects[jx]).ParentID := ParentOrderID;
                    lstOrders.Selected[jx] := False;
                  end;
                end;
              end;
            end;
          end;
          //end of 529181 block
        end;
    end;

    if ((AnAction = OA_CHGEVT) or (AnAction = OA_EDREL)) then
    begin
      if (BadList.Count = 1) and (GoodList.Count < 1) then
        InfoBox(Piece(BadList[0], '^', 1) + WarningMsg + Piece(BadList[0], '^',
          2), WarningTitle, MB_OK);
      if ((BadList.Count >= 1) and (GoodList.Count >= 1)) or (BadList.Count > 1)
      then
        DisplayOrdersForAction(BadList, GoodList, AnAction);
    end;
  finally
    FreeAndNil(ChildList);
    FreeAndNil(GoodList);
    FreeAndNil(BadList);
    FreeAndNil(CheckedList);
  end;
end;

procedure TfrmOrders.MakeSelectedList(AList: TList);
{ make a list of selected orders }
var
  i: Integer;
begin
  with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
        AList.Add(Items.Objects[i]);
end;

function TfrmOrders.NoneSelected(const ErrMsg: string): Boolean;
begin
  Result := True;
  if SelCount > 0 then
    Result := false;
  if Result then
    InfoBox(ErrMsg, TC_NOSEL, MB_OK);
end;

procedure TfrmOrders.RemoveSelectedFromChanges(AList: TList);
{ remove from Changes orders that were signed or released }
var
  i: Integer;
begin
  with AList do
    for i := 0 to Count - 1 do
      with TOrder(Items[i]) do
        Changes.Remove(CH_ORD, ID);
end;

procedure TfrmOrders.SynchListToOrders;
{ make sure lstOrders now reflects the current state of orders }
var
  i: Integer;
begin
  with lstOrders do
    for i := 0 to Items.Count - 1 do
    begin
      Items[i] := GetPlainText(TOrder(Items.Objects[i]), i);
      if Selected[i] then
        Selected[i] := False;
    end;
  lstOrders.Invalidate;
end;

procedure TfrmOrders.mnuActDCClick(Sender: TObject);
{ discontinue/cancel/delete the selected orders (as appropriate for each order }
var
  DelEvt: Boolean;
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not(FCurrentView.EventDelay.EventIFN > 0) then
    if not EncounterPresent then
      Exit; // make sure have provider & location
  if not LockedForOrdering then
    Exit;
  try
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName)) then
      Exit;
    SelectedList := TList.Create;
    try
      // if CheckOrderStatus = True then Exit;
      ValidateSelected(OA_DC, TX_NO_DC, TC_NO_DC);
      // validate DC action on each order
      ActivateDeactiveRenew;
      // AGP 26.53 TURN OFF UNTIL FINAL DECISION CAN BE MADE
      MakeSelectedList(SelectedList); // build list of orders that remain
      // updating the Changes object happens in ExecuteDCOrders, based on individual order
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, 'Unsigned ', '', [rfReplaceAll]);
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, '&', '', [rfReplaceAll]);
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, '...', '', [rfReplaceAll]);

      if ExecuteDCOrders(SelectedList, DelEvt, FOrderTitleCaption) then
        SynchListToOrders;
      UpdateUnsignedOrderAlerts(Patient.DFN);
      with Notifications do
        if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
          UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
      UpdateExpiringMedAlerts(Patient.DFN);
      UpdateUnverifiedMedAlerts(Patient.DFN);
      UpdateUnverifiedOrderAlerts(Patient.DFN);
    finally
      SelectedList.Free;
    end;
  finally
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.mnuActRelClick(Sender: TObject);
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL_SIGN) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not CanManualRelease then
  begin
    ShowMsg('You are not authorized to manual release delayed orders.');
    Exit;
  end;
  if not EncounterPresent(TX_REL_LOC) then
    Exit;

  if not LockedForOrdering then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_EDREL, TX_NO_REL, TC_NO_REL);
    // validate realease action on each order
    MakeSelectedList(SelectedList);
    if SelectedList.Count = 0 then
      Exit;
    // ExecuteReleaseOrderChecks(SelectedList);
    if not ExecuteReleaseEventOrders(SelectedList) then
      Exit;
    UpdateExpiringMedAlerts(Patient.DFN);
    UpdateUnverifiedMedAlerts(Patient.DFN);
    UpdateUnverifiedOrderAlerts(Patient.DFN);
    FCompress := True;
    SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
  finally
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.mnuActChgEvntClick(Sender: TObject);
var
  SelectedList: TList;
  DoesDestEvtOccur: Boolean;
  DestPtEvtID: Integer;
  DestPtEvtName: string;
begin
  inherited;
  if not EncounterPresentEDO then
    Exit;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not LockedForOrdering then
    Exit;
  try
    // if (FCurrentView.EventDelay.PtEventIFN>0) and (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN, FCurrentView.EventDelay.EventName)) then
    // Exit;
    DoesDestEvtOccur := False;
    DestPtEvtID := 0;
    DestPtEvtName := '';
    SelectedList := TList.Create;
    try
      if CheckOrderStatus = True then
        Exit;
      ValidateSelected(OA_CHGEVT, TX_NO_CV, TC_NO_CV);
      // validate Change Event action on each order
      MakeSelectedList(SelectedList); // build list of orders that remain
      if ExecuteChangeEvt(SelectedList, DoesDestEvtOccur, DestPtEvtID,
        DestPtEvtName) then
        SynchListToOrders
      else
        Exit;
      UpdateUnsignedOrderAlerts(Patient.DFN);
      with Notifications do
        if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
          UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
      UpdateExpiringMedAlerts(Patient.DFN);
      UpdateUnverifiedMedAlerts(Patient.DFN);
      UpdateUnverifiedOrderAlerts(Patient.DFN);
    finally
      SelectedList.Free;
    end;
  finally
    UnlockIfAble;
    if DoesDestEvtOccur then
      PtEvtCompleted(DestPtEvtID, DestPtEvtName);
  end;
end;

procedure TfrmOrders.mnuActHoldClick(Sender: TObject);
{ place the selected orders on hold, creates new orders }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not EncounterPresent then
    Exit; // make sure have provider & location
  if not LockedForOrdering then
    Exit;
  try
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName)) then
      Exit;
    SelectedList := TList.Create;
    try
      if CheckOrderStatus = True then
        Exit;
      ValidateSelected(OA_HOLD, TX_NO_HOLD, TC_NO_HOLD);
      // validate hold action on each order
      MakeSelectedList(SelectedList); // build list of orders that remain
      if ExecuteHoldOrders(SelectedList) then // confirm & perform hold
      begin
        AddSelectedToChanges(SelectedList); // send held orders to changes
        SynchListToOrders; // ensure ID's in lstOrders are correct
      end;
    finally
      SelectedList.Free;
    end;
  finally
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.mnuActUnholdClick(Sender: TObject);
{ release orders from hold, no signature required - no new orders created }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not EncounterPresent then
    Exit;
  if not LockedForOrdering then
    Exit;
  SelectedList := TList.Create;
  try
    if CheckOrderStatus = True then
      Exit;
    ValidateSelected(OA_UNHOLD, TX_NO_UNHOLD, TC_NO_UNHOLD);
    // validate release hold action
    MakeSelectedList(SelectedList); // build list of selected orders
    if ExecuteUnholdOrders(SelectedList) then
    begin
      AddSelectedToChanges(SelectedList);
      SynchListToOrders;
    end;
  finally
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.mnuActRenewClick(Sender: TObject);
{ renew the selected orders (as appropriate for each order }
var
  SelectedList: TList;
  ParntOrder: TOrder;
begin
  if FRenewing then
    Exit;
  FRenewing := True;
  try
    inherited;
    if NoneSelected(TX_NOSEL) then
      Exit;
    if not AuthorizedUser then
      Exit;
    if not EncounterPresent then
      Exit; // make sure have provider & location
    if not LockedForOrdering then
      Exit;
    SelectedList := TList.Create;
    try
      if CheckOrderStatus = True then
        Exit;
      ValidateSelected(OA_RENEW, TX_NO_RENEW, TC_NO_RENEW);
      // validate renew action for each
      MakeSelectedList(SelectedList); // build list of orders that remain
      if Length(FParentComplexOrderID) > 0 then
      begin
        ParntOrder := GetOrderByIFN(FParentComplexOrderID);
        if CharAt(ParntOrder.Text, 1) = '+' then
          ParntOrder.Text := Copy(ParntOrder.Text, 2, Length(ParntOrder.Text));
        if Pos('First Dose NOW', ParntOrder.Text) > 1 then
          Delete(ParntOrder.Text, Pos('First Dose NOW', ParntOrder.Text),
            Length('First Dose NOW'));
        SelectedList.Add(ParntOrder);
        FParentComplexOrderID := '';
      end;
      if ExecuteRenewOrders(SelectedList) then
      begin
        AddSelectedToChanges(SelectedList);
        // should this happen in ExecuteRenewOrders?
        SynchListToOrders;
      end;
      UpdateExpiringMedAlerts(Patient.DFN);
      if not uInit.TimedOut then
      begin
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
        if lstSheets.ItemIndex < 0 then
          lstSheets.ItemIndex := 0;
      end;
    finally
      SelectedList.Free;
      UnlockIfAble;
    end;
  finally
    FRenewing := False;
  end;
end;

procedure TfrmOrders.mnuActAlertClick(Sender: TObject);
{ set selected orders to send alerts when results are available, - no new orders created }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_ALERT, TX_NO_ALERT, TC_NO_ALERT);
    // validate release hold action
    MakeSelectedList(SelectedList); // build list of selected orders
    ExecuteAlertOrders(SelectedList);
  finally
    SelectedList.Free;
  end;
end;

// 20110719 -------------------------------------------------------------- begin
procedure TfrmOrders.FlagAction(AnAction: TActionMode);
var
  i: Integer;
  AnOrder: TOrder;
  ErrInfoMsg,
  ActionName, ErrMsg, ValidationAction, ValidationErrorMsg, ErrMsgLog: String;
  SLItem, // Order to process individually
  SL: TStringlist; // order list to process together

  // NSR 20090416 (#2) --------------------------------------------------- begin
  (*
    const
    rpcName = 'RPC TO RETURN RESULT of Validation';

    function NurseValidationCheck(AnOrderID: String): Boolean;
    var
    code, rpcResult: String;
    begin
    Result := False;
    ORNet.CallVistA(rpcName, [], rpcResult);
    code := Piece(rpcResult, U, 1);
    Result := code = '1';
    if not Result then
    ErrMsg := ErrMsg + CRLF + Piece(rpcResult, U, 2);
    end;
  *)
  // NSR 20090416 (#2) ----------------------------------------------------- end

  procedure setObjectSelection(anObject:TObject;aSelected:Boolean=False);
  var
    i: integer;
  begin
    for i := 0 to lstOrders.Items.Count - 1 do
      if lstOrders.Items.Objects[i] = anObject then
        begin
          lstOrders.Selected[i] := aSelected;
          break;
        end;
  end;

{  NSR 20110719.
   Authorization is check by ValidateOrderAction
  function IsUserAuthorized(anOrderID,anAction:String):String;
  var
    SL: TStrings;
    s: String;
  begin
    Result := '';
    if anAction = OA_UNFLAG then
      begin
        SL := TStringList.Create;
        getFlagComponents(SL,anOrderID,'UFAVAIL');
        if (SL.Count < 1 ) or (SL[0] <> '1') then
          Result := 'User is not authorized...';
        SL.Free;
      end;
  end;
}

var
  WereMultipleOrdersSelected: boolean;
  DialogButtons: TMsgDlgButtons;
  GenericError: string;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;

  case AnAction of
    amUnknown:
      begin
        ShowMessage('Unknown Action!');
        Exit;
      end;
    amAdd:
      begin
        if (FCurrentView.EventDelay.PtEventIFN > 0) and
          (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
          FCurrentView.EventDelay.EventName)) then
          Exit;
        ValidationAction := OA_FLAG;
        ValidationErrorMsg := TX_NO_FLAG;
        ActionName := 'Flag Order';
      end;
    amRemove:
      begin
        ValidationAction := OA_UNFLAG;
        ValidationErrorMsg := TX_NO_UNFLAG;
        ActionName := 'Unflag Order';
      end;
    amEdit:
      begin
        ValidationAction := OA_FLAGCOMMENT;
        ValidationErrorMsg := TX_NO_FLAGCOMMENT;
        ActionName := 'Flag Comment';
      end;
  end;

  GenericError := '';
  SL := TStringlist.Create;
  try
    WereMultipleOrdersSelected := lstOrders.SelCount > 1;
    with lstOrders do
    begin
      ErrMsgLog := '';
      Items.BeginUpdate;
      try
        WriteAccessV.BeginErrors;
        try
          for i := 0 to Items.Count - 1 do
            if Selected[i] then
            begin
              AnOrder := TOrder(Items.Objects[i]);
              if (not canWriteOrder(AnOrder, ValidationAction)) then
                Selected[i] := False;
            end;
        finally
          WriteAccessV.EndErrors(False);
        end;
        for i := 0 to Items.Count - 1 do
          if Selected[i] then
          begin
            AnOrder := TOrder(Items.Objects[i]);
            ValidateOrderAction(AnOrder.ID, ValidationAction, ErrMsg);
//          ErrMsg := ErrMsg + IsUserAuthorized(AnOrder.ID,ValidationAction);
            if (Length(ErrMsg) > 0) then
            begin
              // AA: Need confirmation the NurseValidationCheck is not applicable
              // or not NurseValidationCheck(AnOrder.ID)
              if GenericError = '' then GenericError := Trim(Piece(ErrMsg, U, 2));
              ErrMsgLog :=
                Trim(Format('%0:s'+ CRLF + CRLF +'%1:-40s' + CRLF +
                Char(VK_TAB) + ' -- %2:s',
                [ErrMsgLog, AnOrder.Text, Piece(ErrMsg, U, 1)]));
              Selected[i] := False;
            end
            else
              SL.AddObject(IntToStr(i), AnOrder);
          end;
      finally
        Items.EndUpdate;
      end;
      if GenericError <> '' then ErrMsgLog := GenericError + CRLF + CRLF + ErrMsgLog;
    end;
    if not WereMultipleOrdersSelected then
    begin
      ErrInfoMsg := 'The selected order is not eligible for the action "' +
          ActionName + '".' +
          CRLF + CRLF + ErrMsgLog + CRLF + CRLF +
          'Click "OK" to continue';
      DialogButtons := [mbOK];
    end else begin
      ErrInfoMsg := 'Some or all of the selected orders are not eligible for the action "' +
          ActionName + '". They will be removed from selection.' +
          CRLF + CRLF + ErrMsgLog + CRLF + CRLF +
          'Click "OK" to continue, or "Cancel" to abort "' + ActionName + '".';
      DialogButtons := mbOKCancel;
    end;

    if (ErrMsgLog = '') or
      (MessageDlg(ErrInfoMsg, mtWarning, DialogButtons, 0) = mrOK) then
      // (InfoBox(ErrInfoMsg, 'Confirmation', MB_ICONWARNING or MB_OKCANCEL) = mrOK) then
    begin
      if not mnuAllowMultipleAssignment.Checked then
      // add an option to let user select the processing mode
      begin // processing one by one
        SLItem := TStringlist.Create;
        try
          SLItem.Add('');
          for i := 0 to SL.Count - 1 do
          begin
            SLItem[0] := SL[i];
            SLItem.Objects[0] := SL.Objects[i];
            ProcessOrderList(SLItem, ActionName, // window caption
              'Provide the Order Flag details to ' + ActionName, // comments
              AnAction, // actioin mode
              Self); // parent window
            setObjectSelection(SL.Objects[i]);
          end;
        finally
          FreeAndNil(SLItem);
        end;
      end
      else // Processing the list
        begin
          ProcessOrderList(SL, ActionName, // window caption
            'Provide the Order Flag details to ' + ActionName, // comments
            AnAction, // actioin mode
            Self); // parent window
          for i := 0 to SL.Count - 1 do
            SetObjectSelection(SL.Objects[i]);
        end;
    end;
  finally
    FreeAndNil(SL);
  end;
  lstOrders.Ctl3D := True;  // AA: forcing to fire the MeasureItem call
  lstOrders.Invalidate;
  lstOrders.Ctl3D := False;
  if AnAction = amAdd then
    Exit; //
  if Notifications.Active then
    AutoUnflagAlertedOrders(Patient.DFN, Piece(Notifications.RecordID, U, 2));
end;

procedure TfrmOrders.mnuActFlagClick(Sender: TObject);
begin
  inherited;
  FlagAction(amAdd);
end;

procedure TfrmOrders.mnuActFlagCommentClick(Sender: TObject);
begin
  inherited;
  FlagAction(amEdit);
end;

procedure TfrmOrders.mnuActUnflagClick(Sender: TObject);
begin
  inherited;
  FlagAction(amRemove);
end;
// 20110719 ---------------------------------------------------------------- end

procedure TfrmOrders.mnuActCompleteClick(Sender: TObject);
{ complete generic orders, no signature required - no new orders created }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_COMPLETE, TX_NO_CPLT, TC_NO_CPLT);
    // validate completing of order
    MakeSelectedList(SelectedList); // build list of selected orders
    if ExecuteCompleteOrders(SelectedList) then
      SynchListToOrders;
  finally
    SelectedList.Free;
  end;
end;

procedure TfrmOrders.mnuActVerifyClick(Sender: TObject);
{ verify orders, signature required but no new orders created }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedToVerify then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_VERIFY, TX_NO_VERIFY, TC_NO_VERIFY);
    // make sure order can be verified
    MakeSelectedList(SelectedList); // build list of selected orders
    if ExecuteVerifyOrders(SelectedList, False) then
      SynchListToOrders;
  finally
    SelectedList.Free;
  end;
end;

procedure TfrmOrders.mnuActChartRevClick(Sender: TObject);
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedToVerify then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_CHART, TX_NO_VERIFY, TC_NO_VERIFY);
    // make sure order can be verified
    MakeSelectedList(SelectedList); // build list of selected orders
    if ExecuteVerifyOrders(SelectedList, True) then
      SynchListToOrders;
  finally
    SelectedList.Free;
  end;
end;

procedure TfrmOrders.mnuActCommentClick(Sender: TObject);
{ loop thru selected orders, allowing ward comments to be edited for each }
var
  i: Integer;
  AnOrder: TOrder;
  ErrMsg: string;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if (FCurrentView.EventDelay.PtEventIFN > 0) and
    (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
    FCurrentView.EventDelay.EventName)) then
    Exit;
  with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        AnOrder := TOrder(Items.Objects[i]);
        ValidateOrderAction(AnOrder.ID, OA_COMMENT, ErrMsg);
        if Length(ErrMsg) > 0 then
          InfoBox(AnOrder.Text + TX_NO_CMNT + ErrMsg, TC_NO_CMNT, MB_OK)
        else
          ExecuteWardComments(AnOrder);
        Selected[i] := False;
      end;
end;

procedure TfrmOrders.mnuActChangeClick(Sender: TObject);
{ loop thru selected orders, present ordering dialog for each with defaults to selected order }
var
  i: Integer;
  ChangeIFNList: TStringlist;
  ASourceOrderID: string;
begin

  inherited;
  if not EncounterPresentEDO then
    Exit;
  ChangeIFNList := TStringlist.Create;
  try
    if NoneSelected(TX_NOSEL) then
      Exit;
    if CheckOrderStatus = True then
      Exit;
    ValidateSelected(OA_CHANGE, TX_NO_CHANGE, TC_NO_CHANGE);
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName) then
      Exit;
    with lstOrders do
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
        begin
          ChangeIFNList.Add(TOrder(Items.Objects[i]).ID);
          ASourceOrderID := TOrder(lstOrders.Items.Objects[i]).ID;
        end;
    if ChangeIFNList.Count > 0 then
      ChangeOrders(ChangeIFNList, FCurrentView.EventDelay);
    // do we need to deselect the orders?
  finally
    ChangeIFNList.Free;
  end;
  if frmFrame.TimedOut then
    Exit;
  RedrawOrderList;
end;

procedure TfrmOrders.mnuActCopyClick(Sender: TObject);
{ loop thru selected orders, present ordering dialog for each with defaults to selected order }
var
  ThePtEvtID: string;
  i: Integer;
  IsNewEvent, needVerify, NewOrderCreated: Boolean;
  CopyIFNList: TStringlist;
  DestPtEvtID: Integer;
  DestPtEvtName: string;
  DoesDestEvtOccur: Boolean;
  TempEvent: TOrderDelayEvent;
begin
  inherited;
  if not EncounterPresentEDO then
    Exit;
  DestPtEvtID := 0;
  DestPtEvtName := '';
  DoesDestEvtOccur := False;
  needVerify := True;
  CopyIFNList := TStringlist.Create;
  try
    if NoneSelected(TX_NOSEL) then
      Exit;
    NewOrderCreated := False;
    if CheckOrderStatus = True then
      Exit;
    ValidateSelected(OA_COPY, TX_NO_COPY, TC_NO_COPY);
    if (FCurrentView.EventDelay.PtEventIFN > 0) and
      (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
      FCurrentView.EventDelay.EventName)) then
      Exit;
    with lstOrders do
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
          CopyIFNList.Add(TOrder(Items.Objects[i]).ID);

    IsNewEvent := False;
    // if not ShowMsgOn(CopyIFNList.Count = 0, TX_NOSEL, TC_NOSEL) then
    if CopyIFNList.Count > 0 then
      if SetViewForCopy(IsNewEvent, DoesDestEvtOccur, DestPtEvtID, DestPtEvtName) then
      begin
        if DoesDestEvtOccur then
        begin
          TempEvent.TheParent := TParentEvent.Create(0);
          TempEvent.EventIFN := 0;
          TempEvent.PtEventIFN := 0;
          TempEvent.EventType := #0;
          CopyOrders(CopyIFNList, TempEvent, DoesDestEvtOccur, needVerify);
          if ImmdCopyAct then
            ImmdCopyAct := False;
          PtEvtCompleted(DestPtEvtID, DestPtEvtName);
          Exit;
        end;
        FCurrentView.EventDelay.EventName := DestPtEvtName;
        if (FCurrentView.EventDelay.EventIFN > 0) and
          (FCurrentView.EventDelay.EventType <> 'D') then
        begin
          needVerify := False;
          uAutoAC := True;
        end;
        TempEvent.EventName := DestPtEvtName;
        // FCurrentView.EventDelay.EventName;
        TempEvent.PtEventIFN := DestPtEvtID;
        // FCurrentView.EventDelay.PtEventIFN;
        if (FCurrentView.EventDelay.EventType = 'D') or
          ((not Patient.inpatient) and (FCurrentView.EventDelay.EventType = 'T'))
        then
        begin
          if TransferOrders(CopyIFNList, FCurrentView.EventDelay,
            DoesDestEvtOccur, needVerify) then
            NewOrderCreated := True;
        end
        else if (not Patient.inpatient) and
          (FCurrentView.EventDelay.EventType = 'A') then
        begin
          if TransferOrders(CopyIFNList, FCurrentView.EventDelay,
            DoesDestEvtOccur, needVerify) then
            NewOrderCreated := True;
        end
        else
        begin
          if CopyOrders(CopyIFNList, FCurrentView.EventDelay, DoesDestEvtOccur,
            needVerify) then
            NewOrderCreated := True;
        end;
        if (not NewOrderCreated) and Assigned(FCurrentView) and
          (FCurrentView.EventDelay.EventIFN > 0) then
          if isExistedEvent(Patient.DFN,
            IntToStr(FCurrentView.EventDelay.EventIFN), ThePtEvtID) then
          begin
            if PtEvtEmpty(ThePtEvtID) then
            begin
              DeletePtEvent(ThePtEvtID);
              ChangesUpdate(ThePtEvtID);
              InitOrderSheetsForEvtDelay;
              lstSheets.ItemIndex := 0;
              lstSheetsClick(Self);
            end;
          end;
        if ImmdCopyAct then
          ImmdCopyAct := False;
        if DoesDestEvtOccur then
          PtEvtCompleted(DestPtEvtID, DestPtEvtName);
      end;
  finally
    uAutoAC := False;
    CopyIFNList.Free;
  end;

end;

procedure TfrmOrders.mnuActReleaseClick(Sender: TObject);
{ release orders to services without a signature, do appropriate prints }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not EncounterPresent(TX_REL_LOC) then
    Exit;

  if not LockedForOrdering then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_RELEASE, TX_NO_REL, TC_NO_REL);
    // validate release action on each order
    MakeSelectedList(SelectedList); // build list of orders that remain
    ExecuteReleaseOrderChecks(SelectedList); // call order checking
    if not uInit.TimedOut then
      if ExecuteReleaseOrders(SelectedList) then
      // confirm, then perform release
        RemoveSelectedFromChanges(SelectedList);
    // remove released orders from Changes
    // SaveSignOrders;
    UpdateUnsignedOrderAlerts(Patient.DFN);
    with Notifications do
      if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
        UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
    UpdateExpiringMedAlerts(Patient.DFN);
    UpdateUnverifiedMedAlerts(Patient.DFN);
    UpdateUnverifiedOrderAlerts(Patient.DFN);
    if not uInit.TimedOut then
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
  finally
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.mnuActOnChartClick(Sender: TObject);
{ mark orders orders as signed on chart, release to services, do appropriate prints }
var
  SelectedList: TList;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not EncounterPresent(TX_CHART_LOC) then
    Exit;

  if not LockedForOrdering then
    Exit;
  SelectedList := TList.Create;
  try
    ValidateSelected(OA_ONCHART, TX_NO_CHART, TC_NO_CHART);
    // validate sign on chart for each
    MakeSelectedList(SelectedList); // build list of orders that remain
    ExecuteReleaseOrderChecks(SelectedList); // call order checking
    if not uInit.TimedOut then
      if ExecuteOnChartOrders(SelectedList) then
      // confirm, then perform release
        RemoveSelectedFromChanges(SelectedList);
    // remove released orders from Changes
    UpdateUnsignedOrderAlerts(Patient.DFN);
    with Notifications do
      if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
        UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
    UpdateExpiringMedAlerts(Patient.DFN);
    UpdateUnverifiedMedAlerts(Patient.DFN);
    UpdateUnverifiedOrderAlerts(Patient.DFN);
    if not uInit.TimedOut then
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
  finally
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

// CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
procedure TfrmOrders.mnuActOneStepClick(Sender: TObject);
begin
  inherited;
  ShowOneStepAdmin;
end;

procedure TfrmOrders.mnuActSignClick(Sender: TObject);
{ obtain signature for orders, release them to services, do appropriate prints }
var
  SelectedList: TList;
  Delayed: Boolean;
begin
  if FSigning then
    Exit;
  FSigning := True;
  try
    Delayed := False;
    if NoneSelected(TX_NOSEL_SIGN) then
      Exit;
    if not AuthorizedUser then
      Exit;
    if (User.OrderRole <> 2) and (User.OrderRole <> 3) then
    begin
      ShowMsg('Sorry, You don''t have the permission to release selected orders manually');
      Exit;
    end;
    if not(FCurrentView.EventDelay.EventIFN > 0) then
    begin
      if not EncounterPresent(TX_SIGN_LOC) then
        Exit;
    end;
    if not LockedForOrdering then
      Exit;
    try
      // CQ 18392 and CQ 18121 Made changes to this code, PtEVTComplete function and the finally statement at the end to support the fix for these CQs
      if (FCurrentView.EventDelay.PtEventIFN > 0) then
        Delayed := (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
          FCurrentView.EventDelay.EventName, False, True));
      // if (FCurrentView.EventDelay.PtEventIFN>0) and (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN, FCurrentView.EventDelay.EventName)) then
      // Exit;

      SelectedList := TList.Create;
      try
        ValidateSelected(OA_SIGN, TX_NO_SIGN, TC_NO_SIGN);
        // validate sign action on each order
        MakeSelectedList(SelectedList);
        { billing Aware }
        if BILLING_AWARE then
        begin
          UBACore.rpcBuildSCIEList(SelectedList);
          // build list of orders and Billable Status
          UBACore.CompleteUnsignedBillingInfo
            (rpcGetUnsignedOrdersBillingData(OrderListSCEI));
        end;

        { billing Aware }
        ExecuteReleaseOrderChecks(SelectedList); // call order checking

        if not uInit.TimedOut then
          if ExecuteSignOrders(SelectedList) // confirm, sign & release
          then
            RemoveSelectedFromChanges(SelectedList);
        // remove signed orders from Changes
        UpdateUnsignedOrderAlerts(Patient.DFN);
        with Notifications do
          if Active and (FollowUp = NF_ORDER_REQUIRES_ELEC_SIGNATURE) then
            UnsignedOrderAlertFollowup(Piece(RecordID, U, 2));
        if Active then
        begin
          UpdateExpiringMedAlerts(Patient.DFN);
          UpdateUnverifiedMedAlerts(Patient.DFN);
          UpdateUnverifiedOrderAlerts(Patient.DFN);
        end;
        if not uInit.TimedOut then
        begin
          SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_SIGN, 0);
          if lstSheets.ItemIndex < 0 then
            lstSheets.ItemIndex := 0;
        end;
      finally
        SelectedList.Free;
      end;
    finally
      UnlockIfAble;
      // CQ #17491: Added UpdatePtInfoOnRefresh here to allow for the updating of the patient
      // status indicator in the header bar if the patient becomes admitted/discharged.
      frmFrame.UpdatePtInfoOnRefresh;
      if Delayed = True then
      begin
        InitOrderSheetsForEvtDelay;
        lstSheets.ItemIndex := 0;
        lstSheetsClick(Self);
        RefreshOrderList(True);
      end;
    end;
  finally
    FSigning := False;
  end;
end;

procedure TfrmOrders.mnuOptSaveQuickClick(Sender: TObject);
begin
  inherited;
  QuickOrderSave;
end;

procedure TfrmOrders.mnuOptEditCommonClick(Sender: TObject);
begin
  inherited;
  QuickOrderListEdit;
end;

procedure TfrmOrders.ProcessNotifications;
var
  OrderIEN, ErrMsg: string;
  BigOrderID: string;

  procedure ShowResults(anID:String);
  var
    sl: TStrings;
  begin
    sl := TSTringList.Create;
    try
      if ResultOrder(anID,sl) then
        ReportBox(sl, 'Order Results - ' + anID, True);
    finally
      sl.Free;
    end;
  end;

begin
  // if not User.NoOrdering then LoadWriteOrders(lstWrite.Items) else lstWrite.Clear; {**KCM**}
  OrderIEN := IntToStr(ExtractInteger(Notifications.AlertData));
  case Notifications.FollowUp of
    NF_FLAGGED_ORDERS:
      begin
        ViewAlertedOrders('', STS_FLAGGED, '', False, True,
          'All Services, Flagged');
          if Notifications.Processing then
            AutoUnflagAlertedOrders(Patient.DFN,
              Piece(Notifications.RecordID, U, 2));
      end;
    NF_FLAGGED_ORDERS_COMMENTS:  // AA  NSR#20110719  Order Flag Recommendations
      begin
        ViewAlertedOrders(OrderIEN, STS_FLAGGED, '', False, True,
          'All Services, Flagged-Commented');
//        mnuViewDetailClick(Self);    // Show Details of the Order
        if Notifications.Processing then
          Notifications.Delete;        // Delete Alert Notification
      end;
    NF_ORDER_REQUIRES_ELEC_SIGNATURE:
      begin
        ViewAlertedOrders('', STS_UNSIGNED, '', False, True,
          'All Services, Unsigned');
        if Notifications.Processing then
          UnsignedOrderAlertFollowup(Piece(Notifications.RecordID, U, 2));
      end;
    NF_IMAGING_REQUEST_CANCEL_HELD:
      if Pos('HELD', UpperCase(Notifications.Text)) > 0 then
      begin
        ViewAlertedOrders(OrderIEN, STS_HELD, 'IMAGING', False, True,
          'Imaging, On Hold');
        if Notifications.Processing then
          Notifications.Delete;
      end
      else
      begin
        ViewAlertedOrders(OrderIEN, STS_DISCONTINUED, 'IMAGING', False, True,
          'Imaging, Cancelled');
          if Notifications.Processing then
            Notifications.Delete;
      end;
    NF_SITE_FLAGGED_RESULTS:
      begin
        ViewAlertedOrders(OrderIEN, STS_COMPLETE, '', False, True,
          'All Services, Site-Flagged');
        with lstOrders do
          if Selected[ItemIndex] then
          begin
            BigOrderID := TOrder(Items.Objects[ItemIndex]).ID;
            if Length(Piece(BigOrderID, ';', 1)) > 0 then
            begin
                ShowResults(BigOrderID);
              Notifications.Delete;
            end;
          end;
      end;
    NF_ORDERER_FLAGGED_RESULTS:
      begin
        ViewAlertedOrders(OrderIEN, STS_COMPLETE, '', False, True,
          'All Services, Orderer-Flagged');
        if Notifications.Processing then
        with lstOrders do
          if Selected[ItemIndex] then
          begin
            BigOrderID := TOrder(Items.Objects[ItemIndex]).ID;
            if Length(Piece(BigOrderID, ';', 1)) > 0 then
            begin
              ShowResults(BigOrderID);
              Notifications.Delete;
            end;
          end;
      end;
    NF_ORDER_REQUIRES_COSIGNATURE:
      ViewAlertedOrders('', STS_UNSIGNED, '', False, True,
        'All Services, Unsigned');
    NF_LAB_ORDER_CANCELED:
      begin
        ViewAlertedOrders(OrderIEN, STS_DISCONTINUED, 'LABORATORY', False, True,
          'Lab, Cancelled');
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_DNR_EXPIRING:
      ViewAlertedOrders('', STS_EXPIRING, '', False, True,
        'All Services, Expiring');
    NF_MEDICATIONS_EXPIRING_INPT:
      begin
        ViewAlertedOrders('', STS_EXPIRING, 'PHARMACY', False, True,
          'Medications, Expiring');
      end;
    NF_MEDICATIONS_EXPIRING_OUTPT:
      begin
        ViewAlertedOrders('', STS_EXPIRING, 'PHARMACY', False, True,
          'Medications, Expiring');
      end;
    NF_UNVERIFIED_MEDICATION_ORDER:
      begin
        ViewAlertedOrders(OrderIEN, STS_UNVERIFIED, 'PHARMACY', False, True,
          'Medications, Unverified');
        if Notifications.Processing then
        begin
          if StrToIntDef(OrderIEN, 0) > 0 then { **REV** }
          begin // Delete alert if user can't verify
            ValidateOrderAction(OrderIEN, OA_VERIFY, ErrMsg);
            if Pos('COMPLEX-PSI', ErrMsg) > 0 then
              ErrMsg := TX_COMPLEX;
            if Length(ErrMsg) > 0 then
              Notifications.Delete;
          end;
          UpdateUnverifiedMedAlerts(Patient.DFN);
        end;
      end;
    NF_NEW_ORDER:
      begin
        ViewAlertedOrders(OrderIEN, STS_RECENT, '', False, True,
          'All Services, Recent Activity');
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_UNVERIFIED_ORDER:
      begin
        ViewAlertedOrders(OrderIEN, STS_UNVERIFIED, '', False, True,
          'All Services, Unverified');
        if Notifications.Processing then
        begin
          if StrToIntDef(OrderIEN, 0) > 0 then { **REV** }
          begin // Delete alert if user can't verify
            ValidateOrderAction(OrderIEN, OA_SIGN, ErrMsg);
            if Pos('COMPLEX-PSI', ErrMsg) > 0 then
              ErrMsg := TX_COMPLEX;
            if Length(ErrMsg) > 0 then
              Notifications.Delete;
          end;
          UpdateUnverifiedOrderAlerts(Patient.DFN);
        end;
      end;
    NF_FLAGGED_OI_RESULTS:
      begin
        ViewAlertedOrders(OrderIEN, STS_COMPLETE, '', False, True,
          'All Services, Orderable Item Flagged');
        if Notifications.Processing then
        begin
          with lstOrders do
            if Selected[ItemIndex] then
            begin
              BigOrderID := TOrder(Items.Objects[ItemIndex]).ID;
              if Length(Piece(BigOrderID, ';', 1)) > 0 then
              begin
                ShowResults(BigOrderID);
                Notifications.Delete;
              end;
            end;
        end;
      end;
    NF_DC_ORDER:
      begin
        ViewAlertedOrders(OrderIEN, STS_RECENT, '', False, True,
          'All Services, Recent Activity');
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_DEA_AUTO_DC_CS_MED_ORDER:
      begin
        ViewAlertedOrders(OrderIEN, STS_DISCONTINUED, 'PHARMACY', False, True,
          'Pharmacy, PKI Issues', 30);
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_DEA_CERT_REVOKED:
      begin
        ViewAlertedOrders(OrderIEN, STS_DISCONTINUED, 'PHARMACY', False, True,
          'Pharmacy, PKI Issues', 30);
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_FLAGGED_OI_EXP_INPT:
      begin
        ViewAlertedOrders('', STS_EXPIRING, '', False, True,
          'All Services, Expiring');
        if Notifications.Processing then
          UpdateExpiringFlaggedOIAlerts(Patient.DFN, NF_FLAGGED_OI_EXP_INPT);
      end;
    NF_FLAGGED_OI_EXP_OUTPT:
      begin
        ViewAlertedOrders('', STS_EXPIRING, '', False, True,
          'All Services, Expiring');
        if Notifications.Processing then
          UpdateExpiringFlaggedOIAlerts(Patient.DFN, NF_FLAGGED_OI_EXP_OUTPT);
      end;
    NF_CONSULT_REQUEST_CANCEL_HOLD:
      begin
        OrderIEN := GetConsultOrderNumber(Notifications.AlertData);
        ViewAlertedOrders(OrderIEN, STS_DISCONTINUED, 'CONSULTS', False, True,
          'Consults, Cancelled');
        if Notifications.Processing then
          with lstOrders do
            Selected[ItemIndex] := True;
      end;
    NF_RX_RENEWAL_REQUEST:
      begin
        if (Notifications.AlertData <> '') then
        begin
          Notifications.IndOrderDisplay := True;
          ViewAlertedOrders('', STS_FIXED, '', False, True,
            'Outpatient Medications');
        if Notifications.Processing then
            UpdateIndOrderAlerts()
        else
          Notifications.IndOrderDisplay := True;
        end
        else
        begin
          SetOrderView(STS_ACTIVE, DGroupAll,
            'Active Orders (includes Pending & Recent Activity) - ALL SERVICES',
            False);
        end;
      end;
    NF_LAPSED_ORDER:
      begin
        Notifications.IndOrderDisplay := True;
        ViewAlertedOrders('', STS_FIXED, '', False, True,
          'Lapsed (never processed) Orders - ALL SERVICES');
        if Notifications.Processing then
            UpdateIndOrderAlerts()
        else
          Notifications.IndOrderDisplay := True;
      end;
    NF_NEW_ALLERGY_CONFLICT_ORDER:
      begin
        Notifications.IndOrderDisplay := True;
        ViewAlertedOrders('', STS_FIXED, '', False, True,
          'New Allergy Conflict');
        if Notifications.Processing then
            UpdateIndOrderAlerts()
        else
          Notifications.IndOrderDisplay := True;
      end;
    NF_NO_FLAG_ACTION_ORDER:
      begin
        Notifications.IndOrderDisplay := True;
        ViewAlertedOrders('', STS_FIXED, '', False, True,
          'Flagged - No Action Taken');
        if Notifications.Processing then
            UpdateIndOrderAlerts()
        else
          Notifications.IndOrderDisplay := True;
      end;
    NF_RTC_CANCEL_ORDERS:
      begin
        ViewAlertedOrders('', STS_DISCONTINUED, 'CLINIC SCHEDULING', False,
          True, 'Cancel Appointment Request orders');
        if Notifications.Processing then
          Notifications.Delete;
      end;
    NF_HIRISK_ORDER:
      begin
        Notifications.IndOrderDisplay := True;
        ViewAlertedOrders('', STS_FIXED, '', False, True,
          'Potentially Harmful Orders - SINGLE SERVICE');
        if Notifications.Processing then
            UpdateIndOrderAlerts()
        else
          Notifications.IndOrderDisplay := True;
      end
  else
    mnuViewUnsignedClick(Self);
  end;
end;

procedure TfrmOrders.ViewAlertedOrders(OrderIEN: string; Status: Integer;
  DispGrp: string; BySvc, InvDate: Boolean; Title: string;
  aDaysOverride: Integer = 0); { **KCM** }
var
  i, ADGroup: Integer;
  DGroups: TStrings;
begin
  DGroups := TStringlist.Create;
  try
    ADGroup := DGroupAll;
    if Length(DispGrp) > 0 then
    begin
      ListDGroupAll(DGroups);
      for i := 0 to DGroups.Count - 1 do
        if Piece(DGroups.Strings[i], U, 2) = DispGrp then
          ADGroup := StrToIntDef(Piece(DGroups.Strings[i], U, 1), 0);
    end;
  finally
    DGroups.Free;
  end;
  SetOrderView(Status, ADGroup, Title, True, aDaysOverride);
  if Notifications.Processing then
  begin
    with lstOrders do
    begin
      if Length(OrderIEN) > 0 then
      begin
        for i := 0 to Items.Count - 1 do
          if Piece(TOrder(Items.Objects[i]).ID, ';', 1) = OrderIEN then
          begin
            ItemIndex := i;
            Selected[i] := True;
            Break;
          end;
      end
      else
        for i := 0 to Items.Count - 1 do
          if Piece(TOrder(Items.Objects[i]).ID, ';', 1) <> '0' then
            Selected[i] := True;
      if Self.SelCount = 0 then
        Notifications.Delete;
    end;
  end;
end;

procedure TfrmOrders.pnlRightResize(Sender: TObject);
begin
  inherited;
  imgHide.Left := pnlRight.Width - 19;
end;

procedure TfrmOrders.RequestPrint;
{ obtain print devices for selected orders, do appropriate prints }
const
  TX_NEW_LOC1 = 'The patient''s location has changed to ';
  TX_NEW_LOC2 = '.' + CRLF +
    'Should the orders be printed using the new location?';
  TC_NEW_LOC = 'New Patient Location';
var
  SelectedList: TStringlist;
  ALocation, i: Integer;
  AName, ASvc, DeviceInfo: string;
  Nature: char;
  PrintIt: Boolean;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  // if not AuthorizedUser then Exit;   removed in v17.1 (RV) SUX-0901-41044
  SelectedList := TStringlist.Create;
  Nature := #0;
  try
    with lstOrders do
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
          SelectedList.Add(Piece(TOrder(Items.Objects[i]).ID, U, 1));
    CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
    if (ALocation > 0) and (ALocation <> Encounter.Location) then
    begin
      // gary
      Encounter.Location := frmClinicWardMeds.ClinicOrWardLocation(ALocation);
      // if InfoBox(TX_NEW_LOC1 + AName + TX_NEW_LOC2, TC_NEW_LOC, MB_YESNO) = IDYES
      // then Encounter.Location := ALocation;
    end;
    if Encounter.Location = 0 then
      Encounter.Location := CommonLocationForOrders(SelectedList);
    if Encounter.Location = 0 then // location required for DEVINFO
    begin
      LookupLocation(ALocation, AName, LOC_ALL, TX_LOC_PRINT);
      if ALocation > 0 then
        Encounter.Location := ALocation;
    end;
    frmFrame.DisplayEncounterText;
    if Encounter.Location <> 0 then
    begin
      SetupOrdersPrint(SelectedList, DeviceInfo, Nature, False, PrintIt);
      if PrintIt then
        ExecutePrintOrders(SelectedList, DeviceInfo);
      SynchListToOrders;
    end
    else
      InfoBox(TX_PRINT_LOC, TC_REQ_LOC, MB_OK or MB_ICONWARNING);
  finally
    SelectedList.Free;
  end;
end;

procedure TfrmOrders.btnDelayedOrderClick(Sender: TObject);
const
  TX_DELAYCAP = '  Delay release of new order(s) until';
var
  AnEvent: TOrderDelayEvent;
  ADlgLst: TStringlist;
  IsRealeaseNow: Boolean;
begin
  inherited;
  if FNoOrderingOrWriteAccess then
    exit;
  mnuViewUAP.Enabled := True;
  if not EncounterPresentEDO then
    Exit;
  AnEvent.EventType := #0;
  AnEvent.TheParent := TParentEvent.Create(0);
  AnEvent.EventIFN := 0;
  AnEvent.PtEventIFN := 0;
  AnEvent.EventName := '';
  if not CloseOrdering then
    Exit;
  FCalledFromWDO := True;
  // frmFrame.UpdatePtInfoOnRefresh;
  IsRealeaseNow := False;
  FCompress := True; // treat as lstSheet click
  ADlgLst := TStringlist.Create;
  // SetEvtIFN(AnEvent.EventIFN);
  if ShowDelayedEventsTreatingSepecialty(TX_DELAYCAP, AnEvent, ADlgLst,
    IsRealeaseNow) then
  begin
    FEventForCopyActiveOrders := AnEvent;
    FAskForCancel := False;
    ResetOrderPage(AnEvent, ADlgLst, IsRealeaseNow);
  end;
  FCompress := False;
  FCalledFromWDO := False;
  if (FCurrentView <> nil) and (FCurrentView.EventDelay.PtEventIFN > 0) and
    (PtEvtCompleted(FCurrentView.EventDelay.PtEventIFN,
    FCurrentView.EventDelay.EventName)) then
    Exit;
end;

procedure TfrmOrders.CompressEventSection;
begin
  hdrOrders.Sections[0].MaxWidth := 0;
  hdrOrders.Sections[0].MinWidth := 0;
  hdrOrders.Sections[0].Width := 0;
  hdrOrders.Sections[0].Text := '';
end;

procedure TfrmOrders.ExpandEventSection;
begin
  hdrOrders.Sections[0].MaxWidth := 10000;
  hdrOrders.Sections[0].MinWidth := 50;
  if FEvtColWidth > 0 then
    hdrOrders.Sections[0].Width := EvtColWidth
  else
    hdrOrders.Sections[0].Width := 65;
  hdrOrders.Sections[0].Text := 'Event';
end;

{ procedure TfrmOrders.SetEvtIFN(var AnEvtIFN: integer);
  var
  APtEvntID,AnEvtInfo: string;
  begin
  if lstSheets.ItemIndex < 0 then
  APtEvntID := Piece(lstSheets.Items[0],'^',1)
  else
  APtEvntID := Piece(lstSheets.Items[lstSheets.ItemIndex],'^',1);
  if CharAt(APtEvntID,1) <> 'C' then
  begin
  if Pos('EVT',APtEvntID)>0 then
  AnEvtIFN  := StrToIntDef(Piece(APtEvntID,';',1),0)
  else
  begin
  AnEvtInfo := EventInfo(APtEvntID);
  AnEvtIFN  := StrToIntDef(Piece(AnEvtInfo,'^',2),0);
  end;
  end else
  AnEvtIFN := 0;
  end; }

procedure TfrmOrders.InitOrderSheetsForEvtDelay;
begin
  InitOrderSheets;
  DfltViewForEvtDelay;
end;

procedure TfrmOrders.DfltViewForEvtDelay;
begin
  inherited;
  if not CanChangeOrderView then
    Exit;
  lstSheets.ItemIndex := 0;
  FCurrentView := TOrderView(lstSheets.Items.Objects[0]);
  LoadOrderViewDefault(FCurrentView);
  lstSheets.Items[0] := 'C;0^' + FCurrentView.ViewName;
end;

procedure TfrmOrders.EventRealeasedOrder1Click(Sender: TObject);
var
  AnOrderView: TOrderView;
begin
  inherited;
  if not CanChangeOrderView then
    Exit;
  AnOrderView := TOrderView.Create;
  // DRM - I7546770FY16 - 2017/7/18 - fix memory leak
  try
    // DRM - I7546770FY16 ---
    AnOrderView.Filter := STS_ACTIVE;
    AnOrderView.DGroup := DGroupAll;
    AnOrderView.ViewName := 'All Services, Active';
    AnOrderView.InvChrono := True;
    AnOrderView.ByService := True;
    AnOrderView.CtxtTime := 0;
    AnOrderView.TextView := 0;
    AnOrderView.EventDelay.EventType := 'C';
    AnOrderView.EventDelay.Specialty := 0;
    AnOrderView.EventDelay.Effective := 0;
    AnOrderView.EventDelay.EventIFN := 0;
    AnOrderView.EventDelay.EventName := 'All Services, Active';
    // Clear the current view dates
    FCurrentView.TimeFrom := 0;
    FCurrentView.TimeThru := 0;
    SelectEvtReleasedOrders(AnOrderView);
    with AnOrderView do
      if Changed then
      begin
        // DRM - I7546770FY16 - 2017/7/18 - FCurrentView isn't being updated
        if AnOrderView.EventDelay.EventType = #0 then
          AnOrderView.EventDelay.EventType := 'C';
        OrderViewReset;
        FCurrentView.Assign(AnOrderView);
        // DRM - I7546770FY16 ---
        mnuActRel.Visible := False;
        popOrderRel.Visible := False;
        FCompress := True;
        // DRM - I7546770FY16 - 2017/7/18 - Reflect viewname in lstSheets
        // lstSheets.ItemIndex := -1;
        lstSheets.Items[0] := 'C;0^' + FCurrentView.ViewName;
        // DRM - I7546770FY16 ---
        lblWrite.Caption := 'Write Orders';
        lstWrite.Clear;
        LoadWriteOrders(lstWrite.Items);
        if AnOrderView.EventDelay.PtEventIFN > 0 then
          RefreshOrderList(FROM_SERVER,
            IntToStr(AnOrderView.EventDelay.PtEventIFN));
        lblOrders.Caption := AnOrderView.ViewName;
        if ByService then
        begin
          if InvChrono then
            FDfltSort := OVS_CATINV
          else
            FDfltSort := OVS_CATFWD;
        end
        else
        begin
          if InvChrono then
            FDfltSort := OVS_INVERSE
          else
            FDfltSort := OVS_FORWARD;
        end;
      end;
    // DRM - I7546770FY16 - 2017/7/18 - fix memory leak
  finally
    AnOrderView.Free;
  end;
  // DRM - I7546770FY16 ---  if FFromDCRelease then
  FFromDCRelease := False;
end;

procedure TfrmOrders.ResetOrderPage(AnEvent: TOrderDelayEvent;
  ADlgLst: TStringlist; IsRealeaseNow: Boolean);
var
  i, AnIndex, EFilter: Integer;
  APtEvtID: string; // ptr to #100.2
  theEvtID: string; // ptr to #100.5
  tmptPtEvtID: string;
  AnOrderView: TOrderView;
  AnDlgStr: string;
begin
  EFilter := 0;
  theEvtID := '';
  AnDlgStr := '';
  IsDefaultDlg := False;
  AnOrderView := TOrderView.Create;
  if FCurrentView = nil then
  begin
    FCurrentView := TOrderView.Create;
    with FCurrentView do
    begin
      InvChrono := True;
      ByService := True;
    end;
  end;
  if IsRealeaseNow then
    lstSheets.ItemIndex := 0;
  if AnEvent.EventIFN > 0 then
    with lstSheets do
    begin
      AnIndex := -1;
      for i := 0 to Items.Count - 1 do
      begin
        theEvtID := GetEvtIFN(i);
        if theEvtID = IntToStr(AnEvent.EventIFN) then
        begin
          AnIndex := i;
          theEvtID := '';
          Break;
        end;
        theEvtID := '';
      end;
      if AnIndex > -1 then
      begin
        NewEvent := False;
        ItemIndex := AnIndex;
        lstSheetsClick(Self);
      end
      else
      begin
        NewEvent := True;
        if TypeOfExistedEvent(Patient.DFN, AnEvent.EventIFN) = 2 then
        begin
          SaveEvtForOrder(Patient.DFN, AnEvent.EventIFN, '');
          AnEvent.IsNewEvent := False;
          if (ADlgLst.Count > 0) and (Piece(ADlgLst[0], '^', 2) <> 'SET') then
            ADlgLst.Delete(0);
        end;
        if (TypeOfExistedEvent(Patient.DFN, AnEvent.EventIFN) = 0) and
          (AnEvent.TheParent.ParentIFN > 0) then
        begin
          if ((ADlgLst.Count > 0) and (Piece(ADlgLst[0], '^', 2) = 'SET')) or
            (ADlgLst.Count = 0) then
          begin
            SaveEvtForOrder(Patient.DFN, AnEvent.TheParent.ParentIFN, '');
            SaveEvtForOrder(Patient.DFN, AnEvent.EventIFN, '');
            AnEvent.IsNewEvent := False;
          end;
        end;
        if (TypeOfExistedEvent(Patient.DFN, AnEvent.EventIFN) = 0) and
          (AnEvent.TheParent.ParentIFN = 0) then
        begin
          if ((ADlgLst.Count > 0) and (Piece(ADlgLst[0], '^', 2) = 'SET')) or
            (ADlgLst.Count = 0) then
          begin
            SaveEvtForOrder(Patient.DFN, AnEvent.EventIFN, '');
            AnEvent.IsNewEvent := False;
          end;
        end;
        if isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN), APtEvtID)
        then
        begin
          case AnEvent.EventType of
            'A':
              EFilter := 15;
            'D':
              EFilter := 16;
            'T':
              EFilter := 17;
          end;
          AnOrderView.DGroup := DGroupAll;
          AnOrderView.Filter := EFilter;
          AnOrderView.EventDelay := AnEvent;
          AnOrderView.CtxtTime := -1;
          AnOrderView.TextView := 0;
          AnOrderView.ViewName := 'Delayed ' + AnEvent.EventName + ' Orders';
          AnOrderView.InvChrono := FCurrentView.InvChrono;
          AnOrderView.ByService := FCurrentView.ByService;
          if ItemIndex >= 0 then
            Items.InsertObject(ItemIndex + 1,
              APtEvtID + U + AnOrderView.ViewName, AnOrderView)
          else
            Items.InsertObject(lstSheets.Items.Count,
              APtEvtID + U + AnOrderView.ViewName, AnOrderView);
          ItemIndex := lstSheets.Items.IndexOfObject(AnOrderView);
          FCurrentView := AnOrderView;
          lblWrite.Caption := 'Write ' + FCurrentView.ViewName;
          lstWrite.Caption := lblWrite.Caption;
          ClickLstSheet;
          NewEvent := True;
          if ADlgLst.Count > 0 then
            DisplayDefaultDlgList(lstWrite, ADlgLst)
          else
          begin
            if DispOrdersForEvent(IntToStr(FEventForCopyActiveOrders.EventIFN))
            then
            begin
              if isExistedEvent(Patient.DFN,
                IntToStr(FEventForCopyActiveOrders.EventIFN), tmptPtEvtID) then
              begin
                FEventForCopyActiveOrders.PtEventIFN :=
                  StrToIntDef(tmptPtEvtID, 0);
                FEventForCopyActiveOrders.IsNewEvent := False
              end;
              CopyActiveOrdersToEvent(FOrderViewForActiveOrders,
                FEventForCopyActiveOrders);
            end;
            FEventForCopyActiveOrders.EventIFN := 0;
          end;
        end
        else
        begin
          case AnEvent.EventType of
            'A':
              EFilter := 15;
            'D':
              EFilter := 16;
            'T':
              EFilter := 17;
          end;
          if ItemIndex < 0 then
            ItemIndex := 0;
          IsDefaultDlg := True;
          AnOrderView.DGroup := DGroupAll;
          AnOrderView.Filter := EFilter;
          AnOrderView.EventDelay := AnEvent;
          AnOrderView.CtxtTime := -1;
          AnOrderView.TextView := 0;
          AnOrderView.ViewName := 'Delayed ' + AnEvent.EventName + ' Orders';
          if FCurrentView <> nil then
          begin
            AnOrderView.InvChrono := FCurrentView.InvChrono;
            AnOrderView.ByService := FCurrentView.ByService;
          end;
          Items.InsertObject(ItemIndex + 1, IntToStr(AnEvent.EventIFN) + ';EVT'
            + U + AnOrderView.ViewName, AnOrderView);
          lstSheets.ItemIndex := lstSheets.Items.IndexOfObject(AnOrderView);
          FCurrentView := AnOrderView;
          lblWrite.Caption := 'Write ' + FCurrentView.ViewName;
          lstWrite.Caption := lblWrite.Caption;
          ClickLstSheet;
          NewEvent := True;
          if (NewEvent) and (ADlgLst.Count > 0) then
            DisplayDefaultDlgList(lstWrite, ADlgLst);
        end;
      end;
    end
  else
  begin
    lblWrite.Caption := 'Write Orders';
    lstWrite.Caption := lblWrite.Caption;
    RefreshOrderList(FROM_SERVER);
  end;
end;

function TfrmOrders.GetEvtIFN(AnIndex: Integer): string;
begin
  if AnIndex >= lstSheets.Items.Count then
  begin
    Result := '';
    Exit;
  end;
  with lstSheets do
  begin
    if Piece(Piece(Items[AnIndex], ';', 2), '^', 1) = 'EVT' then
      Result := Piece(Items[AnIndex], ';', 1)
    else
      Result := GetEventIFN(Piece(Items[AnIndex], U, 1));
  end;
end;

function TfrmOrders.PlaceOrderForDefaultDialog(ADlgInfo: string;
  IsDefaultDialog: Boolean; AEvent: TOrderDelayEvent): Boolean;
{ ADlgInfo = DlgIEN;FormID;DGroup;DlgType }
var
  Activated: Boolean;
  NextIndex, ix: Integer;
  APtEvtIdA: string;
  TheEvent: TOrderDelayEvent;
begin
  inherited;
  Result := False;

  if FCurrentView = nil then
  begin
    FCurrentView := TOrderView.Create;
    with FCurrentView do
    begin
      InvChrono := True;
      ByService := True;
    end;
  end;

  if AEvent.EventType = #0 then
    TheEvent := FCurrentView.EventDelay
  else
    TheEvent := AEvent;
  if not ActiveOrdering then
    SetConfirmEventDelay;
  NextIndex := lstWrite.ItemIndex;
  if not ReadyForNewOrder1(TheEvent) then
  begin
    lstWrite.ItemIndex := RefNumFor(Self);
    Exit;
  end;
  if AEvent.EventType <> #0 then
    lstWrite.ItemIndex := -1
  else
    lstWrite.ItemIndex := NextIndex;
  // (ReadyForNewOrder may reset ItemIndex to -1)

  with TheEvent do
    if (EventType = 'D') and (Effective = 0) then
      if not ObtainEffectiveDate(Effective) then
      begin
        lstWrite.ItemIndex := -1;
        Exit;
      end;
  PositionTopOrder(StrToIntDef(Piece(ADlgInfo, ';', 3), 0));
  case CharAt(Piece(ADlgInfo, ';', 4), 1) of
    'A':
      Activated := ActivateAction(Piece(ADlgInfo, ';', 1), Self,
        lstWrite.ItemIndex);
    'D', 'Q':
      Activated := ActivateOrderDialog(Piece(ADlgInfo, ';', 1), TheEvent, Self,
        lstWrite.ItemIndex);
    'H':
      Activated := ActivateOrderHTML(Piece(ADlgInfo, ';', 1), TheEvent, Self,
        lstWrite.ItemIndex);
    'M':
      Activated := ActivateOrderMenu(Piece(ADlgInfo, ';', 1), TheEvent, Self,
        lstWrite.ItemIndex);
    'O':
      Activated := ActivateOrderSet(Piece(ADlgInfo, ';', 1), TheEvent, Self,
        lstWrite.ItemIndex);
  else
    Activated := not(InfoBox(TX_BAD_TYPE, TC_BAD_TYPE, MB_OK) = IDOK);
  end;
  if (not Activated) and (IsDefaultDialog) then
  begin
    lstWrite.ItemIndex := -1;
    ix := lstSheets.ItemIndex;
    if lstSheets.ItemIndex < 0 then
      Exit;
    APtEvtIdA := Piece(lstSheets.Items[ix], '^', 1);
    if CharAt(APtEvtIdA, 1) <> 'C' then
    begin
      if Pos('EVT', APtEvtIdA) > 0 then
      begin
        lstSheets.Items.Objects[ix].Free;
        lstSheets.Items.Delete(ix);
        lstSheets.ItemIndex := 0;
        lstSheetsClick(Self);
        lblWrite.Caption := 'Write Orders';
        lstWrite.Caption := lblWrite.Caption;
        lblOrders.Caption := Piece(lstSheets.Items[0], U, 2);
        lstOrders.Caption := Piece(lstSheets.Items[0], U, 2);
        lstWrite.Clear;
        LoadWriteOrders(lstWrite.Items);
      end;
    end;
  end;
  Result := Activated;
end;

function TfrmOrders.DisplayDefaultDlgList(ADest: TORListBox;
  ADlgList: TStringlist): Boolean;
var
  i, j: Integer;
  AnDlgStr: string;
  AFillEvent: TOrderDelayEvent;
  APtEvtID, tmpPtEvtID: string;
begin
  AFillEvent.EventType := #0;
  AFillEvent.EventIFN := 0;
  AFillEvent.PtEventIFN := 0;
  AFillEvent.TheParent := TParentEvent.Create(0);

  Result := False;
  for i := 0 to ADlgList.Count - 1 do
  begin
    if i = 0 then
    begin
      if AnsiCompareText('Set', Piece(ADlgList[i], '^', 2)) = 0 then
        IsDefaultDlg := False;
    end;
    if i > 0 then
      IsDefaultDlg := False;

    ADest.ItemIndex := -1;
    for j := 0 to ADest.Items.Count - 1 do
    begin
      if Piece(ADest.Items[j], ';', 1) = Piece(ADlgList[i], '^', 1) then
      begin
        ADest.ItemIndex := j;
        Break;
      end;
    end;

    if ADest.ItemIndex < 0 then
      AnDlgStr := GetDlgData(Piece(ADlgList[i], '^', 1))
    else
      AnDlgStr := ADest.Items[ADest.ItemIndex];

    if IsDefaultDlg then
      NeedShowModal := True
    else
      FNeedShowModal := False;
    if not IsDefaultDlg then
    begin
      if FEventForCopyActiveOrders.EventIFN > 0 then
      begin
        if isExistedEvent(Patient.DFN,
          IntToStr(FEventForCopyActiveOrders.EventIFN), tmpPtEvtID) then
        begin
          FEventForCopyActiveOrders.PtEventIFN := StrToIntDef(tmpPtEvtID, 0);
          FEventForCopyActiveOrders.IsNewEvent := False
        end;
        if DispOrdersForEvent(IntToStr(FEventForCopyActiveOrders.EventIFN)) then
          CopyActiveOrdersToEvent(FOrderViewForActiveOrders,
            FEventForCopyActiveOrders);
      end;
      FEventForCopyActiveOrders.EventIFN := 0;
    end;

    if PlaceOrderForDefaultDialog(AnDlgStr, IsDefaultDlg, AFillEvent) then
    begin
      if isExistedEvent(Patient.DFN,
        IntToStr(FEventForCopyActiveOrders.EventIFN), APtEvtID) then
      begin
        FCurrentView.EventDelay.PtEventIFN := StrToIntDef(APtEvtID, 0);
        FCurrentView.EventDelay.IsNewEvent := False;
      end;
      if FEventForCopyActiveOrders.EventIFN > 0 then
      begin
        if isExistedEvent(Patient.DFN,
          IntToStr(FEventForCopyActiveOrders.EventIFN), tmpPtEvtID) then
        begin
          FEventForCopyActiveOrders.PtEventIFN := StrToIntDef(tmpPtEvtID, 0);
          FEventForCopyActiveOrders.IsNewEvent := False
        end;
        if DispOrdersForEvent(IntToStr(FEventForCopyActiveOrders.EventIFN)) then
          CopyActiveOrdersToEvent(FOrderViewForActiveOrders,
            FEventForCopyActiveOrders);
      end;
      { if isExistedEvent(Patient.DFN,IntToStr(FEventForCopyActiveOrders.EventIFN), APtEvtID) then
        begin
        FCurrentView.EventDelay.PtEventIFN := StrToIntDef(APtEvtID,0);
        FCurrentView.EventDelay.IsNewEvent := False;
        end; }
      EventDefaultOrder := '';
      FEventForCopyActiveOrders.EventIFN := 0;
      Result := IsDefaultDlg
    end
    else
      Break;
  end;
end;

procedure TfrmOrders.ClickLstSheet;
begin
  FAskForCancel := False;
  lstSheetsClick(Self);
  FAskForCancel := True;
end;

procedure TfrmOrders.lblWriteMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  lblWrite.Hint := lblWrite.Caption;
end;

procedure TfrmOrders.InitOrderSheets2(AnItem: string);
var
  i: Integer;
begin
  InitOrderSheets;
  LoadOrderViewDefault(TOrderView(lstSheets.Items.Objects[0]));
  lstSheets.Items[0] := 'C;0^' + TOrderView(lstSheets.Items.Objects[0])
    .ViewName;
  if Length(AnItem) > 0 then
  begin
    with lstSheets do
      for i := 0 to Items.Count - 1 do
      begin
        if AnsiCompareText(TOrderView(Items.Objects[i]).ViewName, AnItem) = 0
        then
        begin
          ItemIndex := i;
          FCurrentView := TOrderView(lstSheets.Items.Objects[i]);
          Break;
        end;
      end;
  end;
  if lstSheets.ItemIndex < -1 then
    lstSheets.ItemIndex := 0;
  lstSheetsClick(Self);
end;

procedure TfrmOrders.SetFontSize(FontSize: Integer);
begin
  inherited SetFontSize(FontSize);
  RedrawOrderList;
  mnuOptimizeFieldsClick(Self);
  lstSheets.repaint;
  lstWrite.repaint;
  btnDelayedOrder.repaint;
end;

// PaPI ////////////////////////////////////////////////////////////////////////
procedure TfrmOrders.PaPI_GUIsetup;

  function IsParked(const AOrderListRec: TObject): Boolean;
  begin       // Out patient or supply Only
    Result := ((TOrder(AOrderListRec).DGroup = OutptDisp) or
               (TOrder(AOrderListRec).DGroup = SupplyDisp)) and
              // Check that is active
              (TOrder(AOrderListRec).Status = 6) and
              // Cehck that is Parked
              (TOrder(AOrderListRec).ParkedStatus = 'active/parked'); // 'Active/Parked');
  end;

  function CanBeParked(const AOrderListRec: TObject): Boolean;
  begin       // Out patient or supply Only
    Result := ((TOrder(AOrderListRec).DGroup = OutptDisp) or
               (TOrder(AOrderListRec).DGroup = SupplyDisp)) and
             // Check that is active
             (TOrder(AOrderListRec).Status = 6) and // Active
             // Check that is not active/parked
             (TOrder(AOrderListRec).ParkedStatus <> 'active/parked'); // 'Active/Parked');
  end;

var
  I: Integer;
  HaveOnlyParked, HaveOnlyCanBeParked: Boolean;
begin
  if not WriteAccess(waOrders) then
  begin
    ActPark.Enabled := False;
    ActUnpark.Enabled := False;
    exit;
  end;
  HaveOnlyParked := PapiParkingAvailable and (not FNoOrderingOrWriteAccess) and (SelCount > 0);
  HaveOnlyCanBeParked := PapiParkingAvailable and (not FNoOrderingOrWriteAccess) and (SelCount > 0);
  if HaveOnlyParked or HaveOnlyCanBeParked then
  begin
    for I := 0 to lstOrders.Count - 1 do
    begin
      if lstOrders.Selected[I] then
      begin
        HaveOnlyParked := HaveOnlyParked and
          IsParked(lstOrders.Items.Objects[I]);
        HaveOnlyCanBeParked := HaveOnlyCanBeParked and
          CanBeParked(lstOrders.Items.Objects[I]);
        if (not HaveOnlyParked) and (not HaveOnlyCanBeParked) then
          Break;
        // As soon as we know we have a mismatch we can stop this
      end;
    end;
  end;
  ActPark.Enabled := HaveOnlyCanBeParked;
  ActUnpark.Enabled := HaveOnlyParked;
end;

procedure TfrmOrders.popOrderPopup(Sender: TObject);
begin
  inherited;
  if SelCount = 0 then
  begin
    PopOrderDC.Caption := '&Discontinue/Cancel Orders';
    PopOrderDC.Enabled := false;
  end
  else
  begin
    PopOrderDC.Enabled := not FNoOrderingOrWriteAccess;
    PopOrderDC.Caption := GetMenuString;
  end;
  PaPI_GUIsetup;
  if not WriteAccess(waOrders) then
  begin
    popOrderChange.Enabled := false;
    popOrderDC.Enabled := false;
    popOrderRenew.Enabled := false;
    popOrderVerify.Enabled := false;
    popOrderSign.Enabled := false;
    popOrderCopy.Enabled := false;
    popOrderChartRev.Enabled := false;
    popFlag.Enabled := false;
    popFlagComment.Enabled := false;
    popUnflag.Enabled := false;
  end;
  popOrderRel.Enabled := WriteAccess(waDelayedOrders);
  popChgEvnt.Enabled := WriteAccess(waDelayedOrders);
end;

procedure TfrmOrders.mnuActClick(Sender: TObject);
begin
  inherited;
  if SelCount = 0 then
  begin
    mnuActDC.Caption := '&Discontinue/Cancel Orders';
    mnuActDC.Enabled := false;
  end
  else
  begin
    mnuActDC.Enabled := not FNoOrderingOrWriteAccess;
    mnuActDC.Caption := GetMenuString;
  end;
  PaPI_GUIsetup;
end;

function TfrmOrders.GetMenuString:string;
var
  i, UE, OO: Integer;
begin
    UE := 0;
    OO := 0;
    for i := 0 to lstOrders.Items.Count - 1 do
    begin
      if lstOrders.Selected[i] then
      begin
        if TOrder(lstOrders.Items.Objects[i]).DGroup = NonVADisp then
        begin
          if TOrder(lstOrders.Items.Objects[i]).Status = 11 then
            inc(UE)
          else
            inc(OO);
        end else begin
          if TOrder(lstOrders.Items.Objects[i]).Signature = OSS_UNSIGNED then
            inc(UE)
          else
            inc(OO);
        end;
      end;
    end;
    if (OO = 0) and (UE = 1) then
      Result := '&Cancel Unsigned Order'
    else
    if (OO = 0) and (UE > 1) then
      Result := '&Cancel Unsigned Orders'
    else
    if (UE = 0) and (OO = 1) then
      Result := '&Discontinue Order'
    else
    if (UE = 0) and (OO > 1) then
      Result := '&Discontinue Orders'
    else
    if ((UE > 0) and (OO > 0)) or (UE + OO = 0) then
      Result := '&Discontinue/Cancel Orders';
    FOrderTitleCaption :=  StringReplace(Copy(Result, 2, 40), 'Unsigned ', '', [rfReplaceAll]);
end;

procedure TfrmOrders.actParkExecute(Sender: TObject);
// Park the selected med orders as appropriate for each order
// similar to action on fOrders

  function CheckRequirements: Boolean;
  begin
    Result := AuthorizedUser and EncounterPresent and LockedForOrdering;
  end;

var
  SelectedList: TList;
  ErrorString: String;
begin
  inherited;
  SelectedList := TList.Create;
  try
    ErrorString := '';
    if CheckRequirements then
    begin
      ValidateSelected(OA_PARK, TX_NO_PARK, TC_NO_PARK);
      MakeSelectedList(SelectedList);
      if ExecuteParkOrders(SelectedList) then
      begin
        ResetSelectedForList(lstOrders);
        RefreshOrderList(True);
        // Refresh the meds screen maybe?
//        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    lstOrders.SetFocus;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.actUnparkExecute(Sender: TObject);

  function CheckRequirements: Boolean;
  begin
    Result := AuthorizedUser and EncounterPresent and LockedForOrdering;
  end;

var
  SelectedList: TList;
  ErrorString: String;
begin
  inherited;
  SelectedList := TList.Create;
  try
    ErrorString := '';
    if CheckRequirements then
    begin
      ValidateSelected(OA_UNPARK, TX_NO_UNPARK, TC_NO_UNPARK);
      MakeSelectedList(SelectedList);
      if ExecuteUnParkOrders(SelectedList) then
      begin
        ResetSelectedForList(lstOrders);
        RefreshOrderList(True);
        // Refresh the meds screen maybe?
//        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    lstOrders.SetFocus;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmOrders.AddToListBox(AnOrderList: TList);
var
  idx: Integer;
  AnOrder: TOrder;
  i: Integer;
begin
  with AnOrderList do
    for idx := 0 to Count - 1 do
    begin
      AnOrder := TOrder(Items[idx]);
      if (AnOrder.OrderTime <= 0) then
        Continue;
      i := lstOrders.Items.AddObject(AnOrder.ID, AnOrder);
      lstOrders.Items[i] := GetPlainText(AnOrder, i);
    end;
end;

procedure TfrmOrders.ChangesUpdate(APtEvtID: string);
var
  jdx: Integer;
  APrtEvtId, tempEvtId, EvtOrderID: string;
begin
  APrtEvtId := TheParentPtEvt(APtEvtID);
  if Length(APrtEvtId) > 0 then
    tempEvtId := APrtEvtId
  else
    tempEvtId := APtEvtID;
  for jdx := EvtOrderList.Count - 1 downto 0 do
    if AnsiCompareStr(Piece(EvtOrderList[jdx], '^', 1), tempEvtId) = 0 then
    begin
      EvtOrderID := Piece(EvtOrderList[jdx], '^', 2);
      Changes.Remove(CH_ORD, EvtOrderID);
      EvtOrderList.Delete(jdx);
    end;
end;

function TfrmOrders.PtEvtCompleted(APtEvtID: Integer; APtEvtName: string;
  FromMeds: Boolean; Signing: Boolean): Boolean;
begin
  Result := False;
  if IsCompletedPtEvt(APtEvtID) then
  begin
    if FromMeds then
      InfoBox('The event "Delayed ' + APtEvtName + '" ' + TX_CMPTEVT_MEDSTAB,
        'Warning', MB_OK or MB_ICONWARNING)
    else
      InfoBox('The event "Delayed ' + APtEvtName + '" ' + TX_CMPTEVT, 'Warning',
        MB_OK or MB_ICONWARNING);
    GroupChangesUpdate('Delayed ' + APtEvtName);
    if Signing = True then
    begin
      Result := True;
      Exit;
    end;
    InitOrderSheetsForEvtDelay;
    lstSheets.ItemIndex := 0;
    lstSheetsClick(Self);
    RefreshOrderList(True);
    Result := True;
  end;
end;

procedure TfrmOrders.RefreshToFirstItem;
begin
  InitOrderSheetsForEvtDelay;
  lstSheets.ItemIndex := 0;
  RefreshOrderList(True);
end;

procedure TfrmOrders.GroupChangesUpdate(GrpName: string);
var
  ji: Integer;
  theChangeItem: TChangeItem;
begin
  Changes.ChangeOrderGrp(GrpName, '');
  for ji := 0 to Changes.Orders.Count - 1 do
  begin
    theChangeItem := TChangeItem(Changes.Orders.Items[ji]);
    if AnsiCompareText(theChangeItem.GroupName, GrpName) = 0 then
      Changes.ReplaceODGrpName(theChangeItem.ID, '');
  end;
end;

procedure TfrmOrders.UMEventOccur(var Message: TMessage);
begin
  InfoBox('The event "Delayed ' + FCurrentView.EventDelay.EventName + '" ' +
    TX_CMPTEVT, 'Warning', MB_OK or MB_ICONWARNING);
  GroupChangesUpdate('Delayed ' + frmOrders.TheCurrentView.EventDelay.
    EventName);
  InitOrderSheetsForEvtDelay;
  lstSheets.ItemIndex := 0;
  lstSheetsClick(Self);
  RefreshOrderList(True);
end;

procedure TfrmOrders.setSectionWidths;
var
  i: Integer;
begin
  for i := 0 to 10 do
    origWidths[i] := hdrOrders.Sections[i].Width;
end;

function TfrmOrders.getTotalSectionsWidth: Integer;
var
  i: Integer;
begin
  // CQ6170
  Result := 0;
  for i := 0 to hdrOrders.Sections.Count - 1 do
    Result := Result + hdrOrders.Sections[i].Width;
  // end CQ6170
end;

procedure TfrmOrders.FormShow(Sender: TObject);
begin
  inherited;
  // force horizontal scrollbar
  // lstOrders.ScrollWidth := lstOrders.ClientWidth+1000; //CQ6170

  //frmFrame.FormResize(frmFrame); // forces scroll bar if missing
end;

procedure TfrmOrders.hdrOrdersMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  totalSectionsWidth, originalwidth: Integer;
begin
exit;  // Resizing of the Header issue   RTC 679309
  inherited;
  // CQ6170
  totalSectionsWidth := getTotalSectionsWidth;
  if totalSectionsWidth > lstOrders.Width - 5 then
  begin
    originalwidth := 0;
    for i := 0 to hdrOrders.Sections.Count - 1 do
      originalwidth := originalwidth + origWidths[i];
    if originalwidth < totalSectionsWidth then
    begin
      for i := 0 to hdrOrders.Sections.Count - 1 do
        hdrOrders.Sections[i].Width := origWidths[i];
      lstOrders.Invalidate;
      RefreshOrderList(False);
    end;
  end;
  // end CQ6170
end;

procedure TfrmOrders.hdrOrdersMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  setSectionWidths; // CQ6170
end;

{ function TfrmOrders.PatientStatusChanged: boolean;
  const

  msgTxt1 = 'Patient status was changed from ';
  msgTxt2 = 'CPRS needs to refresh patient information to display patient latest record.';
  //GE CQ9537  - Change message text
  msgTxt3 = 'Patient has been admitted. ';
  msgTxt4 = CRLF + 'You will be prompted to sign your orders.  Any new orders subsequently' +
  CRLF +'entered and signed will be directed to the inpatient staff.';
  var
  PtSelect: TPtSelect;
  IsInpatientNow: boolean;
  ptSts: string;
  begin
  result := False;
  SelectPatient(Patient.DFN, PtSelect);
  IsInpatientNow := Length(PtSelect.Location) > 0;
  if Patient.Inpatient <> IsInpatientNow then
  begin
  if (not Patient.Inpatient) then   //GE CQ9537  - Change message text
  MessageDlg(msgTxt3 + msgTxt4, mtWarning, [mbOK], 0)
  else
  begin
  if Patient.Inpatient then ptSts := 'Inpatient to Outpatient.';
  MessageDlg(msgTxt1 + ptSts + #13#10#13 + msgTxt2, mtWarning, [mbOK], 0);
  end;
  frmFrame.mnuFileRefreshClick(Application);
  Result := True;
  end;
  end; }

function TfrmOrders.CheckOrderStatus: Boolean;
var
  i: Integer;
  AnOrder: TOrder;
  OrderArray: TStringlist;
begin
  Result := False;
  OrderArray := TStringlist.Create;
  with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        AnOrder := TOrder(Items.Objects[i]);
        OrderArray.Add(AnOrder.ID + U + IntToStr(AnOrder.Status));
      end;
  if (OrderArray <> nil) and (not DoesOrderStatusMatch(OrderArray)) then
  begin
    MessageDlg('The Order status has changed.' + #13#10#13 +
      'CPRS needs to refresh patient information to display the correct order status',
      mtWarning, [mbOK], 0);
    frmFrame.mnuFileRefreshClick(Application);
    Result := True;
  end;
  OrderArray.Free;
end;

procedure TfrmOrders.ActivateDeactiveRenew;
var
  i: Integer;
  AnOrder: TOrder;
  tmpArr: TStringlist;
begin
  tmpArr := TStringlist.Create;
  try
    with lstOrders do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        AnOrder := TOrder(Items.Objects[i]);
        if AnOrder.Status = 5 then
          tmpArr.Add(AnOrder.ID);
      end;
  if tmpArr.Count > 0 then
    frmActivateDeactive.fActivateDeactive(tmpArr);
  finally
    tmpArr.Free;
  end;
end;

procedure TfrmOrders.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmOrders.mnuViewInformationClick(Sender: TObject);
begin
  inherited;
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not(Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not(Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmOrders.mnuOptimizeFieldsClick(Sender: TObject);
var
  totalSectionsWidth, unitvalue: Integer;
begin
  totalSectionsWidth := pnlRight.Width - 3;
  if totalSectionsWidth < 16 then
    Exit;
  unitvalue := round(totalSectionsWidth / 16);
  with hdrOrders do
  begin
    Sections[1].Width := unitvalue;
    Sections[2].Width := pnlRight.Width - (unitvalue * 10) - 5;
    Sections[3].Width := unitvalue * 2;
    Sections[4].Width := unitvalue * 2;
    Sections[5].Width := unitvalue;
    Sections[6].Width := unitvalue;
    Sections[7].Width := unitvalue;
    Sections[8].Width := unitvalue;
    Sections[9].Width := unitvalue;
    Sections[10].Width := unitvalue;
  end;
  hdrOrdersSectionResize(hdrOrders, hdrOrders.Sections[0]);
  hdrOrders.repaint;
end;

procedure TfrmOrders.hdrOrdersSectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
var
  i: Integer;
  function CompareColVal(Item1, Item2: Pointer): Integer;
  var
    TmpResult: Integer;
    s1, s2: String;
  begin

    case ColIdx of // decide which column values to compare
      1: // Service column
        begin
          s1 := TOrder(Item1).DGroupName;
          s2 := TOrder(Item2).DGroupName;
        end;
      2: // Order column
        begin
          s1 := TOrder(Item1).Text;
          s2 := TOrder(Item2).Text;
        end;
      3: // Start/Stop column
        begin
          s1 := TOrder(Item1).StartTime;
          s2 := TOrder(Item2).StartTime;
        end;
      4: // Provider column
        begin
          s1 := TOrder(Item1).ProviderName;
          s2 := TOrder(Item2).ProviderName;
        end;
      5: // Nurse column
        begin
          s1 := TOrder(Item1).VerNurse;
          s2 := TOrder(Item2).VerNurse;
        end;
      6: // Clerk column
        begin
          s1 := TOrder(Item1).VerClerk;
          s2 := TOrder(Item2).VerClerk;
        end;
      7: // Chart column
        begin
          s1 := TOrder(Item1).ChartRev;
          s2 := TOrder(Item2).ChartRev;
        end;
      8: // Status column
        begin
          s1 := NameOfStatus(TOrder(Item1).Status);
          s2 := NameOfStatus(TOrder(Item2).Status);
        end;
      9: // Location column
        begin
          s1 := MixedCase(TOrder(Item1).OrderLocName);
          s2 := MixedCase(TOrder(Item2).OrderLocName);
        end;
      10: // Reviewed column
        begin
          s1 := TOrder(Item1).ORUAPreviewresult;
          s2 := TOrder(Item2).ORUAPreviewresult;
        end;
    else
      begin
        s1 := '';
        s2 := '';
      end;
    end; { Case ColIdx of }

    TmpResult := CompareText(s1, s2);

    Result := TmpResult;
    // Result := 1;

  end; { function CompareColVal }

begin
  inherited;
  ColIdx := 0;
  for i := 1 to 10 do
    if Section = hdrOrders.Sections[i] then
      ColIdx := i;
  uOrderList.Sort(@CompareColVal);
  uOrderList.Sort(@CompareColVal); // rtw
  RedrawOrderList;
  mnuOptimizeFieldsClick(Self);
end;

procedure TfrmOrders.sptHorzMoved(Sender: TObject);
begin
  inherited;
  mnuOptimizeFieldsClick(Self);
end;

procedure TfrmOrders.sptVertMoved(Sender: TObject);
begin
  inherited;
  if Self.sptVert.Top < Self.lstSheets.Constraints.MinHeight then
    Self.sptVert.Top := Self.lstSheets.Constraints.MinHeight + 1;

end;

function TfrmOrders.GetIndexOfOID(AnOrderListBox: TCaptionListBox;
  AnOrderID: string): Integer;
var
  idx: Integer;
begin
  Result := 0;
  with AnOrderListBox do
    for idx := 0 to Count - 1 do
      if TOrder(AnOrderListBox.Items.Objects[idx]).ID = AnOrderID then
        Result := idx;
end;

procedure TfrmOrders.mnuViewUAPClick(Sender: TObject);
begin
  inherited;
  hdrOrders.Sections[10].Text := 'Reviewed'; // rtw
  hdrOrders.Sections[10].WIDTH := 70;    //rtw
  SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
    'Unified Action Profile', False);
end;

procedure TfrmOrders.popOrderMarkClick(Sender: TObject);
var
  i: Integer;
  tmpList: TStringlist;
  BigOrderID: string;
  AnOrderID: string;
begin
  inherited;
  if NoneSelected(TX_NOSEL) then
    Exit;
  tmpList := TStringlist.Create;
  try
    with lstOrders do
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
        begin
          BigOrderID := TOrder(Items.Objects[i]).ID;
          AnOrderID := Piece(BigOrderID, ';', 1);
          Callvista('ORTO SETRVW', ['1', AnOrderID]);
          // lstOrders.Refresh;
        end;
  finally
    tmpList.Free;
    lstOrders.Refresh;
  end;
end;

procedure TfrmOrders.MnuContinueUAPClick(Sender: TObject);
// Continue choice
var
  ORTopIndex: Integer;
  ORTOID: string;
begin
  inherited;
  Callvista('ORTO SETRVW',
    ['C', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
    ';', 1)]);
  ORTOID := TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID;
  ORTopIndex := lstOrders.TopIndex;
  UAPContinue := True; // rtw
  if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') OR
    (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Infusion') then
  begin
    // continue Inpatient and IV Fluids done via CopyAnOrder
    mnuActCopyClick(Self);
  end
  else
  begin
    // continue Outpatient requires no action
  end;
  // this call allows the code to display the delayed orders view then return to the UAP view
  SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
    'Unified Action Profile', False);
  lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
  lstOrders.TopIndex := ORTopIndex;
  if ShouldCancelCopyorder and
    (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') then // rtw
  begin
    Callvista('ORTO SETRVW',
      ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID, ';',
      1)]); // rtw
    // this call is in the event the user cancels in mid process it sets the reviewed column to null
    SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
      'Unified Action Profile', False);
    lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
    lstOrders.TopIndex := ORTopIndex;
  end;
  if Shouldcancelchangeorder then
  begin
    if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
      .DGroupName = 'Inpt. Meds') and UAPContinue OR // rtw
      (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
      .DGroupName = 'Out. Meds') and not UAPContinue then // rtw
    begin
      Callvista('ORTO SETRVW',
        ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
        ';', 1)]); // rtw
      // this call is in the event the user cancels in mid process it sets the reviewed column to null
      SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
        'Unified Action Profile', False);
      lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
      lstOrders.TopIndex := ORTopIndex;
    end;
  end;
end; // Continue choice

procedure TfrmOrders.MnuChangeUAPClick(Sender: TObject);
// Change choice
var
  ORTopIndex: Integer;
  ORTOID: string;
begin
  inherited;
  Callvista('ORTO SETRVW',
    ['G', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
    ';', 1)]);
  ORTOID := TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID;
  ORTopIndex := lstOrders.TopIndex;
  //
  if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') then
  begin
    // change Inpatient and IV Fluids done via CopyAnOrder
    mnuActCopyClick(Self);
  end
  else
  begin
    // change Outpatient done via same old Change... option
    mnuActChangeClick(Self);
  end;
  // this call allows the code to display the delayed orders view then return to the UAP view
  SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
    'Unified Action Profile', False);
  lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
  lstOrders.TopIndex := ORTopIndex;
  if ShouldCancelCopyorder then // rtw
  begin
    Callvista('ORTO SETRVW',
      ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID, ';',
      1)]); // rtw
    // this call is in the event the user cancels in mid process it sets the reviewed column to null
    SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
      'Unified Action Profile', False);
    lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
    lstOrders.TopIndex := ORTopIndex;
  end;
  if Shouldcancelchangeorder then // rtw
  begin
    if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
      .DGroupName = 'Inpt. Meds') OR
      (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
      .DGroupName = 'Out. Meds') OR
      (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
      .DGroupName = 'Non-VA Meds (Documentation)') then
    begin
      Callvista('ORTO SETRVW',
        ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
        ';', 1)]);
      // this call is in the event the user cancels in mid process it sets the reviewed column to null
      SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
        'Unified Action Profile', False);
      lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
      lstOrders.TopIndex := ORTopIndex;
    end;
  end; // rtw
end;

procedure TfrmOrders.MnuDiscontinueUAPClick(Sender: TObject);
// Discontinue choice
var
  ORTopIndex: Integer;
  ORTOID: string;
begin
  inherited;
  Callvista('ORTO SETRVW',
    ['D', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
    ';', 1)]);
  ORTOID := TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID;
  ORTopIndex := lstOrders.TopIndex;
  //
  if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') OR
    (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Infusion') then
  begin
    // discontinue Inpatient or IV Fluids requires no action
  end
  else
  begin
    // discontinue Outpatient done via same old Discontinue... option
    mnuActDCClick(Self);
  end;
  SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
    'Unified Action Profile', False);
  lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
  lstOrders.TopIndex := ORTopIndex;
  if ShouldcancelDCOrder and
    not(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') then
  begin // rtw
    Callvista('ORTO SETRVW',
      ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID, ';',
      1)]); // rtw
    // this call is in the event the user cancels in mid process it sets the reviewed column to null
    SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
      'Unified Action Profile', False);
    lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
    lstOrders.TopIndex := ORTopIndex;
  end; // rtw
end; // Discontinue choice

procedure TfrmOrders.MnuRenewUAPClick(Sender: TObject);
// Renew choice
var
  ORTopIndex: Integer;
  ORTOID: string;
begin
  inherited;
  Callvista('ORTO SETRVW',
    ['R', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID,
    ';', 1)]);
  ORTOID := TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID;
  ORTopIndex := lstOrders.TopIndex;
  if (TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex])
    .DGroupName = 'Inpt. Meds') then

  begin
    // renew Inpatient or IV FLuids is invalid so do nothing
    // shouldn't even get here since option should
    // be grayed out on PopUAPOrder menu
    // if rt-clicking inpatient orders
  end
  else
  begin
    // renew Outpatient done via same old Renew... option
    mnuActRenewClick(Self);
  end;
  SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
    'Unified Action Profile', False);
  lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
  lstOrders.TopIndex := ORTopIndex;
  if Shouldcancelreneworder OR // rtw
    Renewcancel2 then
  begin // rtw
    Callvista('ORTO SETRVW',
      ['0', Piece(TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]).ID, ';',
      1)]); // rtw
    // this call is in the event the user cancels in mid process it sets the reviewed column to null
    SetOrderView(STS_CURRENT, DGroupIEN('PHARMACY UAP'),
      'Unified Action Profile', False);
    lstOrders.ItemIndex := GetIndexOfOID(lstOrders, ORTOID);
    lstOrders.TopIndex := ORTopIndex;
  end // rtw
end; // Renew choice

procedure TfrmOrders.SetOrderRevwCol(AnOrderList: TList);
var
  idx: Integer;
  AnOrder: TOrder;
  ORTemp: String;
begin
  with AnOrderList do
    for idx := 0 to Count - 1 do
    begin
      AnOrder := TOrder(Items[idx]);
      Callvista('ORTO GETRVW', [AnOrder.ID], ORTemp);
      AnOrder.ORUAPreviewresult := ORTemp;
    end;
end;

procedure TfrmOrders.UMDeselectOrder(var Message: TMessage);
var
  i: Integer;
begin
  i := Message.LParam;
  if (i > -1) and (i < lstOrders.Count - 1) then
    lstOrders.Selected[i] := False;
end;

initialization

SpecifyFormIsNotADialog(TfrmOrders);

end.

unit uConst;

interface

uses
  WinApi.Messages,
  VAShared.UJSONParameters,
  ORFn;

const

  { User defined messages used by CPRS }
//  UM_SHOWPAGE     = (WM_USER + 100);  // originally in fFrame
//  UM_NEWORDER     = (WM_USER + 101);  // originally in fODBase
//  UM_TAKEFOCUS    = (WM_USER + 102);  // in fProbEdt
//  UM_CLOSEPROBLEM = (WM_USER + 103);  // in fProbs
//  UM_PLFILTER     = (WM_USER + 104);  // in fProbs
//  UM_PLLEX        = (WM_USER + 105);  // in fProbs
//  UM_RESIZEPAGE   = (WM_USER + 107);  // originally in fPage
//  UM_DROPLIST     = (WM_USER + 108);  // originally in fODMedIn
//  UM_DESTROY      = (WM_USER + 109);  // used to notify owner when order dialog closes
//  UM_DELAYEVENT   = (WM_USER + 110);  // used with PostMessage to slightly delay an event

// PLEASE update AddCustomWindowMessages at the bottom when adding new messages
  UM_SHOWPAGE     = (WM_USER + 9236);  // originally in fFrame
  UM_NEWORDER     = (WM_USER + 9237);  // originally in fODBase
  UM_TAKEFOCUS    = (WM_USER + 9238);  // in fProbEdt
  UM_CLOSEPROBLEM = (WM_USER + 9239);  // in fProbs
  UM_PLFILTER     = (WM_USER + 9240);  // in fProbs
  UM_PLLEX        = (WM_USER + 9241);  // in fProbs
  UM_RESIZEPAGE   = (WM_USER + 9242);  // originally in fPage
  UM_DROPLIST     = (WM_USER + 9243);  // originally in fODMedIn
  UM_DESTROY      = (WM_USER + 9244);  // used to notify owner when order dialog closes
  UM_DELAYEVENT   = (WM_USER + 9245);  // used with PostMessage to slightly delay an event
  UM_INITIATE     = (WM_USER + 9246);  // used by fFrame to do initial stuff after FormCreate
  UM_RESYNCREM    = (WM_USER + 9247);  // used by fReminderDialog to update reminder controls
  UM_STILLDELAY   = (WM_USER + 9248);  // used by EDO related form fOrdersTS,fOrdersCopy,fMedsCopy
  UM_EVENTOCCUR   = (WM_USER + 9249);  // used by EDO for background occured event
  UM_NSSOTHER     = (WM_USER + 9250);  // used by NSS for auto-display schedule builder
  UM_MISC         = (WM_USER + 9251);  // used for misc stuff across forms
  UM_REMINDERS    = (WM_USER + 9252);  // in fReminderDialog
  UM_508          = (WM_USER + 9508);  // used for 508 messages at 508 base form level
  UM_ENCUPD       = (WM_USER + 9509);  // encounter update (PaPI)
  UM_PaPI         = (WM_USER + 9510);  // PaPI Test
  UM_SELECTPATIENT= (WM_USER + 9700);  // request to select a patient based on Processed Alerts record
  UM_ORDFLAGSTATUS= (WM_USER + 9710);  // request to update Processed list in case of flag status change (NSR#20110719)
  UM_ORDFLAGACTION= (WM_USER + 9711);  // request to update Processed list. (NSR#20110719)
  UM_ORDDESELECT  = (WM_USER + 9720);  // request to drop selection (NSR#20110719)
  UM_TIMEOUT      = (WM_USER + 9722);  // Timeout
  UM_ENABLENEXT   = (WM_USER + 9725);  // Enables "Next" button of the main form (VISTAOR-31343)

  UM_SELECT       = (WM_USER + 9800);  // test

  UM_UpdateRFN    = (WM_USER + 9900);  // resetting Required Fields Navigator (Template dialog)
  UM_OBJDESTROY   = (WM_USER + 9253);  // used in uOwnerWrapper & fFrame
  UM_NOTELIMIT    = (WM_USER + 9254);  // used to redraw the richedit's editable rect

  { Tab Indexes, moved from fFrame }
  CT_NOPAGE   = -1;                             // chart tab - none selected
  CT_UNKNOWN  =  0;                             // chart tab - unknown (shouldn't happen)
  CT_COVER    =  1;                             // chart tab - cover sheet
  CT_PROBLEMS =  2;                             // chart tab - problem list
  CT_MEDS     =  3;                             // chart tab - medications screen
  CT_ORDERS   =  4;                             // chart tab - doctor's orders
  CT_HP       =  5;                             // chart tab - history & physical
  CT_NOTES    =  6;                             // chart tab - progress notes
  CT_CONSULTS =  7;                             // chart tab - consults
  CT_DCSUMM   =  8;                             // chart tab - discharge summaries
  CT_LABS     =  9;                             // chart tab - laboratory results
  CT_REPORTS  = 10;                             // chart tab - reports
  CT_SURGERY  = 11;                             // chart tab - surgery

  { Changes object item types }
  CH_DOC = 10;                        // TIU documents (progress notes)
  CH_SUM = 12;                        // Discharge Summaries       {*REV*}
  CH_CON = 15;                        // Consults
  CH_SUR = 18;                        // Surgery reports
  CH_ORD = 20;                        // Orders
  CH_PCE = 30;                        // Encounter Form items

  { Changes object signature requirements }
  CH_SIGN_YES = 1;                    // Obtain signature (checkbox is checked)
  CH_SIGN_NO  = 2;                    // Don't obtain signature (checkbox is unchecked)
  CH_SIGN_NA  = 0;                    // Signature not applicable (checkbox is greyed)

  { Sign & release orders }
  SS_ONCHART  = '0';
  SS_ESIGNED  = '1';
  SS_UNSIGNED = '2';
  SS_NOTREQD  = '3';
  SS_DIGSIG   = '7';
  RS_HOLD     = '0';
  RS_RELEASE  = '1';
  NO_PROVIDER = 'E';
  NO_VERBAL   = 'V';
  NO_PHONE    = 'P';
  NO_POLICY   = 'I';
  NO_WRITTEN  = 'W';

  { Actions on orders }
  ORDER_NEW   = 0;
  ORDER_DC    = 1;
  ORDER_RENEW = 2;
  ORDER_HOLD  = 3;
  ORDER_EDIT  = 4;
  ORDER_COPY  = 5;
  ORDER_QUICK = 9;
  ORDER_ACT   = 10;
  ORDER_SIGN  = 11;
  ORDER_CPLXRN = 12;

  { Order action codes }
  // when adding new order actions, please update uWriteAccess.TActionType
  OA_COPY     = 'RW';
  OA_CHANGE   = 'XX';
  OA_RENEW    = 'RN';
  OA_HOLD     = 'HD';
  OA_DC       = 'DC';
  OA_UNHOLD   = 'RL';
  OA_FLAG     = 'FL';
  OA_FLAGCOMMENT = 'FC';
  OA_UNFLAG   = 'UF';
  OA_COMPLETE = 'CP';
  OA_ALERT    = 'AL';
  OA_REFILL   = 'RF';
  OA_VERIFY   = 'VR';
  OA_CHART    = 'CR';
  OA_RELEASE  = 'RS';
  OA_SIGN     = 'ES';
  OA_ONCHART  = 'OC';
  OA_COMMENT  = 'CM';
  OA_TRANSFER = 'XFR';
  OA_CHGEVT   = 'EV';
  OA_EDREL    = 'MN';
  OA_PARK     = 'PK'; // PaPI
  OA_UNPARK   = 'UP'; // PaPI

const
  { Ordering Dialog Form IDs }
  OD_ACTIVITY  = 100;
  OD_ALLERGY   = 105;
  OD_CONSULT   = 110;
  OD_PROCEDURE = 112;
  OD_DIET_TXT  = 115;
  OD_DIET      = 117;
  OD_LAB       = 120;
  OD_AP        = 121;
  OD_BB        = 125;
  OD_MEDINPT   = 130;
  OD_MEDS      = 135;
  OD_MEDOUTPT  = 140;
  OD_MEDNONVA  = 145;
  OD_NURSING   = 150;
  OD_MISC      = 151;
  OD_GENERIC   = 152;
  OD_IMAGING   = 160;
  OD_VITALS    = 171;  // use 170 for ORWD GENERIC VITALS, 171 for GMRVOR
  OD_RTC       = 175;
  OD_MEDIV     = 180;
  OD_TEXTONLY  = 999;
  OM_NAV       = 1001;
  OM_QUICK     = 1002;
  OM_TABBED    = 1003;
  OM_TREE      = 1004;
  OM_ALLERGY   = 1105;
  OM_HTML      = 1200;
  OD_AUTOACK   = 9999;
  OD_CLINICMED = 1444;
  OD_CLINICINF = 1555;

  { Ordering role }
  OR_NOKEY     = 0;
  OR_CLERK     = 1;
  OR_NURSE     = 2;
  OR_PHYSICIAN = 3;
  OR_STUDENT   = 4;
  OR_BADKEYS   = 5;

  { Quick Orders }
  QL_DIALOG = 0;
  QL_AUTO   = 1;
  QL_VERIFY = 2;
  QL_REJECT = 8;
  QL_CANCEL = 9;
  MAX_KEYVARS = 10;

  { Order Signature Statuses }
  OSS_UNSIGNED = 2;
  OSS_NOT_REQUIRE = 3;

  { Special Strings }
  TX_WPTYPE = '^WP^';                 // used to identify fields passed as word processing

  { Pharmacy Variables }
  PST_UNIT_DOSE  = 'U';
  PST_IV_FLUIDS  = 'F';
  PST_OUTPATIENT = 'O';

  { Status groups for medications }
  MED_ACTIVE     = 0;                 // status is an active status (active, hold, on call)
  MED_PENDING    = 1;                 // status is a pending status (non-verified)
  MED_NONACTIVE  = 2;                 // status is a non-active status (expired, dc'd, ...)

  { Actions for medications }
  MED_NONE       = 0;
  MED_NEW        = 1;
  MED_DC         = 2;
  MED_HOLD       = 3;
  MED_RENEW      = 4;
  MED_REFILL     = 5;

  { Validate Date/Times }
  DT_FUTURE   = 'F';
  DT_PAST     = 'P';
  DT_MMDDREQ  = 'E';
  DT_TIMEOPT  = 'T';
  DT_TIMEREQ  = 'R';

  { Change Context Types }
  CC_CLICK        = 0;
  CC_INIT_PATIENT = 1;
  CC_NOTIFICATION = 2;
  CC_REFRESH      = 3;
  CC_RESUME       = 4;

  SMART_ALERT_INFO = '<--- SMART ALERT INFO --->';

  { Notification Types }
  NF_LONG_TEXT_ALERT               = -101;
  NF_LAB_RESULTS                   = 3;
  NF_FLAGGED_ORDERS                = 6;
  NF_FLAGGED_ORDERS_COMMENTS       = 8; // NSR#20110719
  NF_ORDER_REQUIRES_ELEC_SIGNATURE = 12;
  NF_ABNORMAL_LAB_RESULTS          = 14;
  NF_IMAGING_RESULTS               = 22;
  NF_CONSULT_REQUEST_RESOLUTION    = 23;
  NF_ABNORMAL_IMAGING_RESULTS      = 25;
  NF_IMAGING_REQUEST_CANCEL_HELD   = 26;
  NF_NEW_SERVICE_CONSULT_REQUEST   = 27;
  NF_CONSULT_REQUEST_CANCEL_HOLD   = 30;
  NF_SITE_FLAGGED_RESULTS          = 32;
  NF_ORDERER_FLAGGED_RESULTS       = 33;
  NF_ORDER_REQUIRES_COSIGNATURE    = 37;
  NF_LAB_ORDER_CANCELED            = 42;
  NF_STAT_RESULTS                  = 44;
  NF_DNR_EXPIRING                  = 45;
  NF_MEDICATIONS_EXPIRING_INPT     = 47;
  NF_UNVERIFIED_MEDICATION_ORDER   = 48;
  NF_NEW_ORDER                     = 50;
  NF_IMAGING_RESULTS_AMENDED       = 53;
  NF_CRITICAL_LAB_RESULTS          = 57;
  NF_UNVERIFIED_ORDER              = 59;
  NF_FLAGGED_OI_RESULTS            = 60;
  NF_FLAGGED_OI_ORDER              = 61;
  NF_DC_ORDER                      = 62;
  NF_CONSULT_REQUEST_UPDATED       = 63;
  NF_FLAGGED_OI_EXP_INPT           = 64;
  NF_FLAGGED_OI_EXP_OUTPT          = 65;
  NF_CONSULT_PROC_INTERPRETATION   = 66;
  NF_IMAGING_REQUEST_CHANGED       = 67;
  NF_LAB_THRESHOLD_EXCEEDED        = 68;
  NF_MAMMOGRAM_RESULTS             = 69;
  NF_PAP_SMEAR_RESULTS             = 70;
  NF_ANATOMIC_PATHOLOGY_RESULTS    = 71;
  NF_MEDICATIONS_EXPIRING_OUTPT    = 72;
  NF_DEA_AUTO_DC_CS_MED_ORDER      = 74;
  NF_DEA_CERT_REVOKED              = 75;
  NF_RX_RENEWAL_REQUEST            = 73;
  NF_LAPSED_ORDER                  = 78;
  NF_HIRISK_ORDER                  = 79;
  NF_NEW_ALLERGY_CONFLICT_ORDER    = 88;
  NF_PROSTHETICS_REQUEST_UPDATED   = 89;
  NF_RTC_CANCEL_ORDERS             = 91;
  NF_NO_FLAG_ACTION_ORDER          = 98;
  NF_DCSUMM_UNSIGNED_NOTE          = 901;
  NF_CONSULT_UNSIGNED_NOTE         = 902;
  NF_NOTES_UNSIGNED_NOTE           = 903;
  NF_SURGERY_UNSIGNED_NOTE         = 904;

  { Notify Application Events }
  NAE_OPEN   = 'BEG';
  NAE_CLOSE  = 'END';
  NAE_NEWPT  = 'XPT';
  NAE_REPORT = 'RPT';
  NAE_ORDER  = 'ORD';

  { TIU Delete Document Reasons }
  DR_PRIVACY = 'P';
  DR_ADMIN   = 'A';
  DR_NOTREQ  = '';
  DR_CANCEL  = 'CANCEL';

  { TIU Document Types }
  TYP_PROGRESS_NOTE =   3;
  TYP_ADDENDUM      =  81;
  TYP_DC_SUMM       = 244;

  { TIU National Document Class Names }
  DCL_CONSULTS = 'CONSULTS';
  DCL_CLINPROC = 'CLINICAL PROCEDURES';
  DCL_SURG_OR  = 'SURGICAL REPORTS';
  DCL_SURG_NON_OR = 'PROCEDURE REPORT (NON-O.R.)';

  { TIU View Contexts }
  NC_RECENT     = 0;                             // Note context - last n signed notes
  NC_ALL        = 1;                             // Note context - all signed notes
  NC_UNSIGNED   = 2;                             // Note context - all unsigned notes
  NC_UNCOSIGNED = 3;                             // Note context - all uncosigned notes
  NC_BY_AUTHOR  = 4;                             // Note context - signed notes by author
  NC_BY_DATE    = 5;                             // Note context - signed notes by date range
  NC_CUSTOM     = 6;                             // Note Context - custom view
  //Text Search CQ: HDS00002856
  NC_SEARCHTEXT = 7;                             // Note Content - search for text

  { Surgery View Contexts }
  SR_RECENT     = 0;
  SR_ALL        = -1;
  SR_BY_DATE    = -5;
  SR_CUSTOM     = -6;

  { Surgery TreeView Icons }
  IMG_SURG_BLANK     = 0;
  IMG_SURG_TOP_LEVEL = 1;
  IMG_SURG_GROUP_SHUT = 2;
  IMG_SURG_GROUP_OPEN = 3;
  IMG_SURG_CASE_EMPTY = 4;
  IMG_SURG_CASE_SHUT  = 5;
  IMG_SURG_CASE_OPEN  = 6;
  IMG_SURG_RPT_SINGLE = 7;
  IMG_SURG_RPT_ADDM   = 8;
  IMG_SURG_ADDENDUM   = 9;
  IMG_SURG_NON_OR_CASE_EMPTY = 10;
  IMG_SURG_NON_OR_CASE_SHUT  = 11;
  IMG_SURG_NON_OR_CASE_OPEN  = 12;

  { TIU TreeView icons }
  IMG_TOP_LEVEL     = 0;
  IMG_GROUP_SHUT    = 1;
  IMG_GROUP_OPEN    = 2;
  IMG_SINGLE        = 3;
  IMG_PARENT        = 4;
  IMG_IDNOTE_SHUT   = 5;
  IMG_IDNOTE_OPEN   = 6;
  IMG_IDPAR_ADDENDA_SHUT = 7;
  IMG_IDPAR_ADDENDA_OPEN = 8;
  IMG_ID_CHILD      = 9;
  IMG_ID_CHILD_ADD  = 10;
  IMG_ADDENDUM      = 11;
  IMG_ORPHANED      = 15;

  { Consults Treeview Icons }
  IMG_GMRC_TOP_LEVEL     = 0;
  IMG_GMRC_GROUP_SHUT    = 1;
  IMG_GMRC_GROUP_OPEN    = 2;
  IMG_GMRC_CONSULT       = 3;
  IMG_GMRC_PROC          = 4;
  IMG_GMRC_CLINPROC      = 5;
  IMG_GMRC_ALL_PROC      = 6;
  IMG_GMRC_IFC_CONSULT   = 7;
  IMG_GMRC_IFC_PROC      = 8;


  { TIU Imaging icons }
  IMG_NO_IMAGES     = 6;
  IMG_1_IMAGE       = 1;
  IMG_2_IMAGES      = 2;
  IMG_MANY_IMAGES   = 3;
  IMG_CHILD_HAS_IMAGES = 4;
  IMG_IMAGES_HIDDEN = 5;


  { TIU ListView sort indicators }
  IMG_NONE       = -1;
  IMG_ASCENDING  =  12;
  IMG_DESCENDING =  13;
  IMG_BLANK      =  14;
  IMG_SHOWMORE   =  16;

  { TIU TreeView context strings}
  NC_TV_TEXT: array[CT_NOTES..CT_DCSUMM] of array[NC_RECENT..NC_BY_DATE] of string =
    (('Recent Signed Notes', 'All signed notes', 'All unsigned notes',
      'All uncosigned notes', 'Signed notes by author',
      'Signed notes by date range'),
     ('', 'Related Documents', 'Medicine Results', ' ', ' ', ' '),
     ('Recent Signed Summaries', 'All signed summaries',
      'All unsigned summaries', 'All uncosigned summaries',
      'Signed summaries by author', 'Signed summaries by date range'));
  TX_MORE = 'SHOW MORE';
  TX_OLDER_NOTES_WITH_ADDENDA = '--- Older signed notes with recent addenda ---';

  CC_ALL        = 1;                             // Consult context - all Consults
  CC_BY_STATUS  = 2;                             // Consult context - Consults by Status
  CC_BY_SERVICE = 4;                             // Consult context - Consults by Service
  CC_BY_DATE    = 5;                             // Consult context - Consults by date range
  CC_CUSTOM     = 6;                             // Custom consults list

  CC_TV_TEXT: array[CC_ALL..CC_CUSTOM] of string =
    ('All consults','Consults by Status', '', 'Consults by Service','Consults by Date Range','Custom List');

  PKG_CONSULTS = 'GMR(123,';
  PKG_SURGERY  = 'SRF(';
  PKG_PRF = 'PRF';

  { New Person Filters }
  NPF_ALL       = 0;
  NPF_PROVIDER  = 1;
//  NPF_ENCOUNTER = 2;
  NPF_SUPPRESS  = 9;

  { Location Types }
  LOC_ALL      = 0;
  LOC_OUTP     = 1;
  LOC_INP      = 2;

  // Used in Meds screen
  MedsTab_List_Tag_OUTPT = 1;  // Outpatient
  MedsTab_List_Tag_INPT = 2;   // Inpatient
  MedsTab_List_Tag_NONVA = 3;  // Non VA

  { File Numbers }
  FN_HOSPITAL_LOCATION = 44;
  FN_NEW_PERSON = 200;

  UpperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  LowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  Digits = '0123456789';

  MAX_ENTRY_WIDTH = 80;   //Change in 23.9 for D/S, Consult, and Surgery Notes AGP
  MAX_PROGRESSNOTE_WIDTH = 80;
  MAX_CONSULT_WIDTH = 74; //Added in v31.b for template wrapping in consult orders

  //Group Name
   NONVAMEDGROUP = 'Non-VA Meds';
   NONVAMEDTXT =   'Non-VA';

   DISCONTINUED_ORDER = '2';

   CaptionProperty = 'Caption';
   ShowAccelCharProperty = 'ShowAccelChar';
   DrawersProperty = 'Drawers';

   {Sensitive Patient Access}
    DGSR_FAIL = -1;
    DGSR_NONE =  0;
    DGSR_SHOW =  1;
    DGSR_ASK  =  2;
    DGSR_DENY =  3;

  //CQ #15813 added strings here, rather then being duplicated in numerous sections of code - JCS
  TX_SAVERR_PHARM_ORD_NUM = 'The changes to this order have not been saved.  You must contact Pharmacy to complete any action on this order.';
  TX_SAVERR_IMAGING_PROC = 'The order has not been saved.  You must contact the Imaging Department for help completing this order.';
  TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING = 'Invalid Pharmacy order number';
  TX_SAVERR_IMAGING_PROC_SEARCH_STRING = 'Invalid Procedure, Inactive, no Imaging Type or no Procedure Type';

  //DEA prescriber ineligibility text used in conjunction w/DEACheckFailed
  TX_DEAFAIL   = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider does not have a current, valid DEA# on record' + CRLF +
                 'and is ineligible to sign the order.';
  TX_SCHFAIL   = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider is not authorized to prescribe medications' + CRLF +
                 'in Federal Schedule ';
  TX_SCH_ONE   = 'Order for controlled substance could not be completed.' + CRLF +
                 'Electronic prescription of medications in Federal Schedule 1 is prohibited.' + CRLF + CRLF +
                 'Valid Schedule 1 investigational medications require paper prescription.';
  TX_NO_DETOX  = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider does not have a valid Detoxification/Maintenance ID' + CRLF +
                 'number on record and is ineligible to sign the order.';
  TX_EXP_DETOX1= 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider''s Detoxification/Maintenance ID number' + CRLF +
                 'expired due to an expired DEA# on ';
  TX_EXP_DETOX2= '.' + CRLF + 'Provider is ineligible to sign the order.';
  TX_EXP_DEA1  = 'Order for controlled substance could not be completed.' + CRLF +
                 'Provider''s DEA# expired on ';
  TX_EXP_DEA2  = ' and no VA# is' + CRLF +
                 'assigned. Provider is ineligible to sign the order.';
  TX_INSTRUCT  = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF + 'Click CANCEL to cancel the current order.';
  TC_DEAFAIL   = 'Order not completed';

  // Used in Meds and Orders tab for PARK
  /// //////////////////////////////////////////////////////////////////////// PaPI
  TX_NO_PARK = CRLF + CRLF + '- cannot be parked.' + CRLF + CRLF + 'Reason:  ';
  TC_NO_PARK = 'Unable to Park';
  TX_NO_UNPARK = CRLF + CRLF + '- cannot be unparked.' + CRLF + CRLF +
    'Reason:  ';
  TC_NO_UNPARK = 'Unable to Unpark';
  ////////////////////////////////////////////////////////////////////////////

  CampLejeunePatch = 'OR*3.0*407';

  ORPHANED_NOTE_TEXT = 'This note was linked to another note that is no longer available. There is no action required, this message is for informational purposes, only.';

  SIGI_HINT_TRIGGERS: TArray<string> = ['Birth Sex', 'SIGI',
    'Self-Identified Gender Identity'];
  SIGI_HINTS: TArray<string> = ['Birth Sex: Sex assigned at birth',
    'SIGI: Self-Identified Gender Identity', 'SIGI: Self-Identified Gender Identity'];

  function SigiHintLong(ASystemParameters: TJSONParameters): string;

var
  ScrollBarWidth: integer = 0;

implementation

uses
  System.SysUtils,
  WinApi.Windows,
  UWinMsgNames,
  ORCtrls,
  uPCE,
  uPDMP,
  mODAnatPathSpecimen,
  uReminders;

function SigiHintLong(ASystemParameters: TJSONParameters): string;
begin
  Result := SIGI_HINTS[2];
  if not Assigned(ASystemParameters) then Exit;
  for var I := 0 to ASystemParameters.CountItems('SelfIdentifiedGender') - 1 do
  begin
    Result := Result + #13#10'  ' + ASystemParameters.AsTypeDef<string>
      (Format('SelfIdentifiedGender[%0:d].Gender', [I]), '');
  end;
end;

procedure AddCustomWindowsMessages;
begin
  TWinMsgNames.Name[UM_SHOWPAGE] := 'UM_SHOWPAGE';
  TWinMsgNames.Name[UM_NEWORDER] := 'UM_NEWORDER';
  TWinMsgNames.Name[UM_TAKEFOCUS] := 'UM_TAKEFOCUS';
  TWinMsgNames.Name[UM_CLOSEPROBLEM] := 'UM_CLOSEPROBLEM';
  TWinMsgNames.Name[UM_PLFILTER] := 'UM_PLFILTER';
  TWinMsgNames.Name[UM_PLLEX] := 'UM_PLLEX';
  TWinMsgNames.Name[UM_RESIZEPAGE] := 'UM_RESIZEPAGE';
  TWinMsgNames.Name[UM_DROPLIST] := 'UM_DROPLIST';
  TWinMsgNames.Name[UM_DESTROY] := 'UM_DESTROY';
  TWinMsgNames.Name[UM_DELAYEVENT] := 'UM_DELAYEVENT';
  TWinMsgNames.Name[UM_INITIATE] := 'UM_INITIATE';
  TWinMsgNames.Name[UM_RESYNCREM] := 'UM_RESYNCREM';
  TWinMsgNames.Name[UM_STILLDELAY] := 'UM_STILLDELAY';
  TWinMsgNames.Name[UM_EVENTOCCUR] := 'UM_EVENTOCCUR';
  TWinMsgNames.Name[UM_NSSOTHER] := 'UM_NSSOTHER';
  TWinMsgNames.Name[UM_MISC] := 'UM_MISC';
  TWinMsgNames.Name[UM_REMINDERS] := 'UM_REMINDERS';
  TWinMsgNames.Name[UM_508] := 'UM_508';
  TWinMsgNames.Name[UM_ENCUPD] := 'UM_ENCUPD';
  TWinMsgNames.Name[UM_PaPI] := 'UM_PaPI';
  TWinMsgNames.Name[UM_SELECTPATIENT] := 'UM_SELECTPATIENT';
  TWinMsgNames.Name[UM_ORDFLAGSTATUS] := 'UM_ORDFLAGSTATUS';
  TWinMsgNames.Name[UM_ORDFLAGACTION] := 'UM_ORDFLAGACTION';
  TWinMsgNames.Name[UM_ORDDESELECT] := 'UM_ORDDESELECT';
  TWinMsgNames.Name[UM_TIMEOUT] := 'UM_TIMEOUT';
  TWinMsgNames.Name[UM_ENABLENEXT] := 'UM_ENABLENEXT';
  TWinMsgNames.Name[UM_SELECT] := 'UM_SELECT';
  TWinMsgNames.Name[UM_UpdateRFN] := 'UM_UpdateRFN';
  TWinMsgNames.Name[UM_OBJDESTROY] := 'UM_OBJDESTROY';
  TWinMsgNames.Name[UM_NOTELIMIT] := 'UM_NOTELIMIT';

  // Defined in uPCE
  TWinMsgNames.Name[UM_VALIDATE_MAG] := 'UM_VALIDATE_MAG';

  // Defined in uReminders
  TWinMsgNames.Name[UM_MESSAGEBOX] := 'UM_MESSAGEBOX';

  // Defined in mODAnatPathSpecimen
  TWinMsgNames.Name[WM_TRACK_DESC] := 'WM_TRACK_DESC';

  // Defined in uPDMP
  TWinMsgNames.Name[UM_PDMP] := 'UM_PDMP';
  TWinMsgNames.Name[UM_PDMP_Done] := 'UM_PDMP_Done';
  TWinMsgNames.Name[UM_PDMP_Reviewed] := 'UM_PDMP_Reviewed';
  TWinMsgNames.Name[UM_PDMP_Start] := 'UM_PDMP_Start';
  TWinMsgNames.Name[UM_PDMP_Loading] := 'UM_PDMP_Loading';
  TWinMsgNames.Name[UM_PDMP_Show] := 'UM_PDMP_Show';
  TWinMsgNames.Name[UM_PDMP_Ready] := 'UM_PDMP_Ready';
  TWinMsgNames.Name[UM_PDMP_Init] := 'UM_PDMP_Init';
  TWinMsgNames.Name[UM_PDMP_NOTE_ID] := 'UM_PDMP_NOTE_ID';
  TWinMsgNames.Name[UM_PDMP_ABORT] := 'UM_PDMP_ABORT';
  TWinMsgNames.Name[UM_PDMP_CANCEL] := 'UM_PDMP_CANCEL';
  TWinMsgNames.Name[UM_PDMP_Error] := 'UM_PDMP_Error';
  TWinMsgNames.Name[UM_PDMP_Options] := 'UM_PDMP_Options';
  TWinMsgNames.Name[UM_PDMP_WebError] := 'UM_PDMP_WebError';
  TWinMsgNames.Name[UM_PDMP_Refresh] := 'UM_PDMP_Refresh';
  TWinMsgNames.Name[UM_PDMP_Closed] := 'UM_PDMP_Closed';
  TWinMsgNames.Name[UM_PDMP_Disable] := 'UM_PDMP_Disable';
  TWinMsgNames.Name[UM_PDMP_Enable] := 'UM_PDMP_Enable';

  // Defined in ORFn and U_CPTCommon
  TWinMsgNames.Name[UM_STATUSTEXT] := 'UM_STATUSTEXT';
  // Defined in ORCtrls
  TWinMsgNames.Name[UM_SHOWTIP] := 'UM_SHOWTIP';
  TWinMsgNames.Name[UM_GOTFOCUS] := 'UM_GOTFOCUS';
end;

initialization
  ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
  AddCustomWindowsMessages;

end.

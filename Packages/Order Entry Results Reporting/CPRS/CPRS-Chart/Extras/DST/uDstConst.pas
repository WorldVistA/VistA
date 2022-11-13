unit uDstConst;

interface
const
  // button captions
  DST_BUTTON = 'Launch DST';
  CTB_BUTTON = 'Open Consult Toolbox';
  // JSON keys for consult action dialogs
  DST_CTB_SWITCH = 'dstCtbSwitch';
  CTB_ORDER_CONSULT = 'ctbOrderConsult';
  CTB_ENABLED = 'ctbEnabled';
  CTB_RECEIVE = 'ctbReceive';
  CTB_SCHEDULE = 'ctbSchedule';
  CTB_CANCEL = 'ctbCancel';
  CTB_EDITRES = 'ctbEditRes';
  CTB_DISCON = 'ctbDC';
  CTB_FORWARD = 'ctbForward';
  CTB_COMMENT = 'ctbComment';
  CTB_SIGFIND = 'ctbSigFind';
  CTB_ADMINCOMP = 'ctbAdminComp';
  // JSON keys for URLs
  DST_TEST_SERVER = 'dstTestUrl';
  DST_PROD_SERVER = 'dstProdUrl';
  CTB_UI_PATH = 'ctbPath';
  DST_UI_PATH = 'dstPath';
  // APIs
  DST_CONSULT_SAVE_API = 'dstSaveApi';
  DST_CONSULT_DECISION_API = 'dstDecisionApi';
  // JSON keys for api calls
  DST_ID = 'dst_id';
  DST_CONSULT_CONSULTSERVICE = 'consult_service';
  DST_CONSULT_CONSULTURGENCY = 'urgency';
  DST_CONSULT_DATE = 'cid';
  DST_CONSULT_NOTLATERTHAN = 'nltd';
  DST_CONSULT_PTFIRSTNAME = 'patient_first_name';
  DST_CONSULT_PTLASTNAME = 'patient_last_name';
  DST_CONSULT_PTMIDNAME = 'patient_middle_name';
  DST_CONSULT_PTDOB = 'patient_dob';
  DST_CONSULT_PTICN = 'patient_icn';
  DST_CONSULT_PTCLASS = 'outpatient';
  DST_CONSULT_SITEID = 'site_id';
  DST_CONSULT_PROVIDERKEY = 'provider_key';
  DST_CONSULT_WORKFLOWID = 'workflow';
  DST_CONSULT_HISTORY = 'consult_history'; // 20200902
  DST_CONSULT_USERID = 'user_id';          // 20200902
  DST_DATE_TIME_FORMAT = 'yyyy-mm-dd';
  // error messages
  DST_UNAVAIL = 'The Consult Toolbox is not available.';
  DST_TRY_LATER = 'Please try again later.';
  DST_PERSIST = 'If the problem continues, follow local help desk policy.';

implementation

end.

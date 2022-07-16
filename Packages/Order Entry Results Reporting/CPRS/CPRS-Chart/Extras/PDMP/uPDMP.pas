unit uPDMP;

interface

uses
  ORFn, Messages;

const
  UM_PDMP_BASE    = (WM_USER + 9300);
  UM_PDMP         = (UM_PDMP_BASE + 60);  // used by PDMP when results are loaded
  UM_PDMP_Done    = (UM_PDMP_BASE + 60);  // used by PDMP when results are loaded
  UM_PDMP_Reviewed= (UM_PDMP_BASE + 61);  // used by PDMP when results are loaded
  UM_PDMP_Start   = (UM_PDMP_BASE + 62);  // used by PDMP when process started
  UM_PDMP_Loading = (UM_PDMP_BASE + 64);  // used by PDMP when data is pulled
  UM_PDMP_Show    = (UM_PDMP_BASE + 66);  // used by PDMP to show results
  UM_PDMP_Ready   = (UM_PDMP_BASE + 68);  // used by PDMP to indicate results are ready
  UM_PDMP_Init    = (UM_PDMP_BASE + 70);  // used by PDMP to init window
  UM_PDMP_NOTE_ID = (UM_PDMP_BASE + 72);  // Note ID created by PDMP
  UM_PDMP_ABORT   = (UM_PDMP_BASE + 74);  // Aborting PDMP request processing
  UM_PDMP_CANCEL  = (UM_PDMP_BASE + 76);  // Canceling PDMP request processing
  UM_PDMP_Error   = (UM_PDMP_BASE + 78);  // PDMP Data Object Error
  UM_PDMP_Options = (UM_PDMP_BASE + 80);  // PDMP Options updated
  UM_PDMP_WebError= (UM_PDMP_BASE + 82);  // PDMP Web page failed to load
  UM_PDMP_Refresh = (UM_PDMP_BASE + 84);  // PDMP Review updated

  TX_COS_AUTH = CRLF + ' is not authorized to cosign this document.';

{$IFDEF DEBUG}
  PDMP_DEBUG_TASK_ID = '111';
{$ENDIF}
  PDMP_ConstraintsRatio = 4;
  TASK_ID_POS = 2; // ID position in result of 'ORPDMP STRTPDMP' RPC call

  PDMP_ERROR_NO_DATA = 'No data available for review';
  PDMP_ERROR_NO_JUSTIFICATION = 'No comments/justification provided';
  PDMP_NO_DATA_FOUND = 'No results returned for the patient';

  PDMP_MSG_DataRetrievingProblem: String = 'Problem retrieving PDMP results';
  PDMP_MSG_DataRetrievingAbort: String = 'Aborting PDMP Request processing';
  PDMP_MSG_NO_COSIGNER_SELECTED
    : String =
    'No user selected, either select an user or press the cancel button';
  PDMP_MSG_RPCReturnedNoData: String = 'RPC Returned no data';
  PDMP_MSG_Title: String = 'PDMP';

  PDMP_PARAM_RequiredCosigner: String = 'PDMP.requiresCosigner';

var
  // options loaded as part of the sysPreferences
  PDMP_ENABLED: Boolean = False;

  PDMP_UseDefaultBrowser: Boolean = False;
  PDMP_PollingInterval: Integer = 2 * 1000; // seconds between polling attempts
//  PDMP_KeepButton: Boolean = True;
  PDMP_ShowButton: String = 'ALWAYS';
  PDMP_Days: Integer = 90;
  PDMP_Polling_Timeout: Integer = 120;
  PDMP_RPC_Check: Boolean = False;
  PDMP_COMMENT_LIMIT: Integer = 250;
  PDMP_COMMENT_MIN: Integer = 3;
  PDMP_PASTE_ENABLED: Boolean = False;

  PDMP_REVIEW_OPTIONS: String = '';
  PDMP_NoteTitleID: Integer = -1;

{$IFDEF DEBUG}
  PDMP_Debug_MSG_Title: String = 'PDMP DEBUG';
{$ENDIF}

implementation

end.

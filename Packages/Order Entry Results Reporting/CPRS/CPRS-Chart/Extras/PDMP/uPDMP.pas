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
  UM_PDMP_Closed  = (UM_PDMP_BASE + 86);  // PDMP Review updated

  UM_PDMP_Disable = (UM_PDMP_BASE + 88);  // Disable PDMP menu
  UM_PDMP_Enable  = (UM_PDMP_BASE + 90);  // Disable PDMP menu

  TX_COS_AUTH = CRLF + ' is not authorized to cosign this document.';

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
  PDMP_ShowButton: String = 'ALWAYS';
  PDMP_Days: Integer = 90;
  PDMP_Polling_Timeout: Integer = 120;
  PDMP_RPC_Check: Boolean = False;
  PDMP_COMMENT_LIMIT: Integer = 250;
  PDMP_COMMENT_MIN: Integer = 3;
  PDMP_PASTE_ENABLED: Boolean = False;
  PDMP_REVIEW_OPTIONS: String = '';
  PDMP_NoteTitleID: Integer = -1;

  PDMP_Debug_MSG_Title: String = 'PDMP DEBUG';

function CanReview: integer;

implementation

uses
  fFrame, vcl.Controls, WinApi.Windows;

function CanReview: Integer;
var
  s: String;
  bResult,
  b: Boolean;
const
  cTab: Char = CHAR(VK_TAB);

begin
  s := frmFrame.EditInProgress;
  if s <> '' then
  begin
    Result := InfoBox('You are currently editing:' + CRLF + CRLF + s + CRLF +
      CRLF + 'Do you want to Save this note before opening PDMP report?' + CRLF
      + CRLF + 'Select:' + CRLF + CRLF +
      '"Yes"' + CHAR(VK_TAB) + ' to save this note and open PDMP report' + CRLF +
      '"No"' + CHAR(VK_TAB) +
      'to continue editing note without opening PDMP report', 'PDMP Warning',
      MB_YESNO or MB_ICONQUESTION);

    Case Result of
      IDYES:
        begin
          bResult := frmFrame.SaveEditInProgress(b);
          if not bResult and b then
            begin
              InfoBox('Failed to save currently edited note', 'PDMP',
                MB_OK + MB_ICONERROR);
              Result := IDCANCEL;
            end
          else if not bResult then
            Result := IDCANCEL;
        end;
      IDNO:
        exit;
    end;
  end
  else
    Result := IDYES;
end;
{
  function CanReview: Boolean;
  var
    s: String;
    b: Boolean;
  begin
    s := frmFrame.EditInProgress;
    Result := False;
    if s <> '' then
    begin
      if InfoBox('You are currently editing:' + CRLF + CRLF + s + CRLF + CRLF +
        'Do you wish to save this note and review PDMP report?', 'PDMP Warning',
        MB_YESNO or MB_ICONQUESTION) <> IDYES then
        exit
      else
      begin
        Result := frmFrame.SaveEditInProgress(b);
        if not Result and b then
          InfoBox('Failed to save currently edited note', 'PDMP', MB_OK);
      end;
    end
    else
      Result := True;
  end;
}
end.

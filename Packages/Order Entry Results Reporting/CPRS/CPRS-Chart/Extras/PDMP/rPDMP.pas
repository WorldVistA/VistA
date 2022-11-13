unit rPDMP;

interface

uses
  System.classes, ORNET, ORCtrls;

/// <summary> Function is called when the user finishes reviewing </summary?
/// <summary> the report to generate the note</summary>
/// <summary> Result format - the same as pieces 2-4 of the 0 node of STRTPDMP:</summary>
/// <summary> NOTE IEN^Change Log^Date/Time</summary>
function pdmpCreateNote(importList: TStrings; encDate, encLoc, vstr, patient,
  user, authorizedUser, error, VistATask: String; errorDescr: TStrings): string;

/// <summary> Gets values of various PDMP options </summary>
function pdmpGetParams: Integer;

/// <summary> Initial poll of PDMP data </summary>
function pdmpGetResults(PDMPList: TStrings; user, aDelegateOf, aVisitStr,
  patient: string): String;

/// <summary> PDMP data poll </summary>
function pdmpGetResultsPoll(PDMPList: TStrings;
  patient, aTaskID: string): String;

/// <summary> Returns list of users with DEA keys (to select as the provider)</summary>
function pdmpSetSubSetOfAuthorizedUsers(aORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer): Integer;

/// <summary> Kills VistA task by ID</summary>
function pdmpKillTask(aTaskID: String): Integer;

/// <summary> Gets values of PDMP REVIEW options based on USER parameters</summary>
function pdmpGetReviewOptions(aList: TStrings;
  aProvider: Boolean = true): Integer;

/// <summary> Reserved for registration access to the review dialog </summary>
/// <summary> Not implemented in Build 1</summary>
// function pdmpRegisterAccess(const aUserID, aComment: String): Integer;

/// <summary>Checks if the RPC are available on Server</summary>
function pdmpRPCCheck(const aReport: TStrings): Boolean;

/// <summary> Registration of the review results </summary>
/// <param name="aHndle"> - VistA background job polling the results</param>
/// <param name="aStatus">
/// "YES" - flashing Cache with "YES" option prior to review,
/// "ERROR" - error getting review data
/// "RCANCEL" - user cancels revie dialog
/// </param>
function pdmpRegisterReview(aHandle, aStatus, aNoteID: String;
  aComments: String = ''): String;

/// <summary> Returns TRUE is the note is still linked to the same </summary>
/// <summary> PDMP Note Title IEN, user, patient </summary>
/// <summary> use it to verify the note IEN was not reused while request for PDMP data was processed </summary>
// function pdmpIsNoteLinked(aNoteIEN, aPatientDFN, aUserDUZ: String): Boolean;

/// <summary> Returns results of the PDMP request if data is still in the cache. </summary>
/// <summary> Otherwise returns '0' </summary>
function pdmpGetCache(aPatient, aUser: String; const aReport: TStrings)
  : Boolean;

/// <summary> Returns day the last PDMP note was signed for the patient</summary>
function pdmpLastReviewDate(aPatient: String): String;

implementation

uses
  System.SysUtils, ORFn, oPDMPData, uPDMP,
//  uCore.SystemParameters
  uCore
  , uGN_RPCLog, uSimilarNames;

// Result format - the same as pieces 2-4 of the 0 node of STRTPDMP... NOTE:
//                 IEN^Change Log^Date/Time

function pdmpCreateNote(importList: TStrings; encDate, encLoc, vstr, patient,
  user, authorizedUser, error, VistATask: String; errorDescr: TStrings): string;
begin
  try
    CallVistA('ORPDMPNT MAKENOTE', [importList, // Text of the note
      encDate, // visit date
      encLoc, // visit location
      vstr, // visit string p1 = location, p2 = date, p3 = encounter type(?)
      patient, // patient DFN
      user, // author
      authorizedUser, // cosigner (authorized user with DEA)
      error, // '1' if there was an error
      errorDescr, // error description
      VistATask], Result);
  except
    on E: Exception do
      Result := '-100^' + E.Message;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
// ORPDMP STRTPDMP
// 1	Literal		User
// 2	Literal		Authorized user
// 3	Literal		Patient
// 4	lITERAL		Visit String (Visit location;Visit DT;Type)
// Returns:
// 1	ARRAY	  	PDMPList
// Array format:
// Line 1: RC^.....
// RC = "0" - Query kicked off in background task; 2nd piece will be Handle. Pass in that Handle to PRPDMP CHKTASK
// RC = "-1" - error code (PDMP down, or other reason that didn't even attempt to connect). No note is created. Lines 2…n should have message to display to the user.
// RC = "-2" - error code (eError connecting to PDMP server). No note is created. Lines 2…n should have message to display to the user.
// RC = "-3" - error code (Connected to PDMP, but error was returned by PDMP). Note is created. Lines 2…n should have message to display to the user.
// RC = "1" - successful Query.
// RC^Note IEN (optional)^Change List (Required if piece 2 is populated with Note IEN)^Change List Date/Time (Required if piece 2 is populated with Note IEN)
// Line 2 should be the report URL.
// Lines 3…b should be the info needed to create the review form (radio buttons/check list)

function pdmpGetResults(PDMPList: TStrings; user, aDelegateOf, aVisitStr,
  patient: string): String;
begin
  Result := '-1^No results found';
  PDMPList.Clear;
  if CallVistA('ORPDMP STRTPDMP', [user, aDelegateOf, patient, aVisitStr],
    PDMPList) then
    if PDMPList.Count > 0 then
      Result := Piece(PDMPList[0], U, TASK_ID_POS);
end;

function pdmpGetResultsPoll(PDMPList: TStrings;
  patient, aTaskID: string): String;
begin
  Result := '';
  CallVistA('ORPDMP CHCKTASK', [patient, aTaskID], PDMPList);
  if PDMPList.Count > 0 then
    Result := Piece(PDMPList[0], U, TASK_ID_POS);
end;

function pdmpSetSubSetOfAuthorizedUsers(aORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer): Integer;
begin
  SNCallVistA(aORComboBox, SN_ORWU_NEWPERS, [StartFrom, Direction, '', '', '', '', '1'], aDest);
  Result := aDest.Count;
end;

function pdmpKillTask(aTaskID: String): Integer;
begin
  Result := 0;
  if not CallVistA('ORPDMP STOPTASK', [aTaskID], Result) then
    Result := -1;
end;

function pdmpGetReviewOptions(aList: TStrings;
  aProvider: Boolean = true): Integer;
begin
  aList.Text := PDMP_REVIEW_OPTIONS;
  Result := aList.Count;
end;

function RPCCheckList(aRPC: TStrings; aDest: TStrings;
  anOption: String = 'all'): Boolean;
var
  sl: TStrings;
  s: String;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    CallVistA('XWB ARE RPCS AVAILABLE', ['L', aRPC], sl);
    Result := aRPC.Count = sl.Count;
    aDest.Clear;
    if Result then
      for i := 0 to sl.Count - 1 do
      begin
        if (sl[i] = '1') or (aRPC[i] = ' ') or (pos('---', aRPC[i]) = 1) then
          s := ' '
        else
          s := '?';
        if (anOption = 'all') then
          aDest.Add(sl[i] + ' ' + s + ' ' + aRPC[i])
        else if (s = '?') then
          aDest.Add(aRPC[i]);
      end;
  finally
    sl.Free;
  end;
end;

function pdmpRPCCheck(const aReport: TStrings): Boolean;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    sl.Add('ORWU SYSPARAM'); // RPC returns user parameters
    sl.Add(SN_ORWU_NEWPERS);
    sl.Add('ORPDMP STRTPDMP');
    sl.Add('ORPDMP CHCKTASK');
    sl.Add('ORPDMP STOPTASK');
    sl.Add('ORPDMPNT MAKENOTE');
    sl.Add('ORPDMP GETCACHE');
    sl.Add('ORPDMPNT CHECK');
    sl.Add('ORPDMP VIEWEDREPORT');
    sl.Add('ORPDMPNT RECNTNOTE');
    if not RPCCheckList(sl, aReport, 'missing') then
      aReport.Add('Error running "XWB ARE RPCS AVAILABLE"');
    Result := aReport.Count = 0
  finally
    sl.Free;
  end;
end;

function pdmpGetParams: Integer;
begin
  Result := 0;
  PDMP_ENABLED := SystemParameters.AsType<string>('PDMP.turnedOn') = '1';

{$IFDEF DEBUG}
  PDMP_UseDefaultBrowser := False;
{$ELSE}
  PDMP_UseDefaultBrowser := SystemParameters.AsType<string>('PDMP.useDefaultBrowser') = '1';
{$ENDIF}
  PDMP_COMMENT_LIMIT := StrToIntDef(SystemParameters.AsType<string>('PDMP.commentLimit'), 250);
  PDMP_Days := StrToIntDef(SystemParameters.AsType<string>('PDMP.daysBetweenReview'), 90);
  PDMP_PollingInterval :=
    StrToIntDef(SystemParameters.AsType<string>('PDMP.pollingInterval'), 2) * 1000;

  PDMP_ShowButton := SystemParameters.AsType<string>('PDMP.showButton');
  PDMP_PASTE_ENABLED := SystemParameters.AsType<string>('PDMP.pasteEnabled') = '1';

  PDMP_NoteTitleID := StrToIntDef(SystemParameters.AsType<string>('PDMP.noteTitle'), 90);

{$IFDEF DEBUG}
  AddLogLine('PDMP.turnedOn = ' + SystemParameters.AsType<string>('PDMP.turnedOn')
    + #13#10 + 'PDMP.useDefaultBrowser = ' + SystemParameters.AsType<string>('PDMP.useDefaultBrowser') + #13#10 + 'PDMP.commentLimit = ' +
    SystemParameters.AsType<string>('PDMP.commentLimit') + #13#10 +
    'PDMP.daysBetweenReview = ' + SystemParameters.AsType<string>('PDMP.daysBetweenReview') + #13#10 +
    'PDMP.pollingInterval = ' + SystemParameters.AsType<string>('PDMP.pollingInterval') + #13#10 +
    'PDMP.pasteEnabled = ' + SystemParameters.AsType<string>('PDMP.pasteEnabled') +
    #13#10 + 'PDMP.noteTitle = ' + SystemParameters.AsType<string>('PDMP.noteTitle') + #13#10 +
    'PDMP.showButton = ' + SystemParameters.AsType<string>('PDMP.showButton') + #13#10,
    'PDMP Parameters');
{$ENDIF}
end;

function pdmpRegisterReview(aHandle, aStatus, aNoteID: String;
  aComments: String = ''): String;
var
  s: String;
  sl: TStrings;
  b: Boolean;
begin
  sl := TStringList.Create;
  sl.Text := aComments;
  try
    if aComments = '' then
      b := CallVistA('ORPDMP VIEWEDREPORT', [aHandle, aStatus, aNoteID], s)
    else
      b := CallVistA('ORPDMP VIEWEDREPORT', [aHandle, aStatus, aNoteID, sl], s);

    if b then
      Result := s
    else
      Result := 'Error calling RPC "ORPDMP VIEWREPORT"' + CRLF + 'Handle: ' +
        aHandle + CRLF + 'Status: ' + aStatus + CRLF + 'Comments: ' + CRLF +
        aComments;
  finally
    sl.Free;
  end;
end;

{
  function pdmpIsNoteLinked(aNoteIEN, aPatientDFN, aUserDUZ: String): Boolean;
  var
  s: String;
  begin
  Result := False;
  if CallVistA('ORPDMPNT CHECK', [aNoteIEN, aPatientDFN, aUserDUZ], s) then
  Result := s = '1';
  end;
}
function pdmpGetCache(aPatient, aUser: String; const aReport: TStrings)
  : Boolean;
begin
  Result := CallVistA('ORPDMP GETCACHE', [aPatient, aUser], aReport);
  if Result then
    Result := (aReport.Count > 1) and (aReport[0] <> '0');
end;

function pdmpLastReviewDate(aPatient: String): String;
var
  dt: Double;
begin
  Result := 'Unknown';
  if CallVistA('ORPDMPNT RECNTNOTE', [aPatient], dt) and (dt > 3200000.0) then
    Result := formatDateTime('mmm dd, yyyy', FMDateTimeToDateTime(dt));
end;

end.

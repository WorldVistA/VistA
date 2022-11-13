unit rOptions;
{------------------------------------------------------------------------------
Update History
    2015/11/30: NSR#20071216 (Update Surrogate Management Functionality within CPRS GUI )
    2016/02/15: NSR#20081008 (CPRS Notification Alert Processing Improvement)
-------------------------------------------------------------------------------}

interface

uses SysUtils, Classes, ORNet, ORFn, uCore, rCore, rTIU, rConsults, ORCtrls;

procedure rpcGetNotifications(aResults: TStrings);
procedure rpcGetOrderChecks(aResults: TStrings);
function rpcGetNotificationDefaults: String;
function rpcGetSurrogateInfo: String;
procedure rpcCheckSurrogate(surrogate: Int64; var ok: boolean; var msg: string);
//procedure rpcSetSurrogateInfo(aString: String);
procedure rpcSetSurrogateInfo(aString: String; var ok: boolean; var msg: string);
procedure rpcClearNotifications;
procedure rpcSetNotifications(aList: TStringList);
procedure rpcSetOrderChecks(aList: TStringList);
procedure rpcSetOtherStuff(aString: String);
procedure rpcSetCopyPaste(aString: String);
function rpcGetCopyPaste: String;
procedure rpcGetOtherTabs(aResults: TStrings);
function rpcGetOther: String;
procedure rpcSetOther(info: String);
procedure rpcGetCosigners(AORComboBox: TORComboBox; const StartFrom: string;
  Direction: Integer; aResults: TStrings);
function rpcGetDefaultCosigner: String;
procedure rpcSetDefaultCosigner(value: Int64);
function rpcGetSubject: boolean;
procedure rpcSetSubject(value: boolean);
procedure rpcGetClasses(aResults: TStrings);
procedure rpcGetTitlesForClass(value: integer; const StartFrom: string; Direction: Integer; aResults: TStrings);
procedure rpcGetTitlesForUser(value: integer; aResults: TStrings);
function rpcGetTitleDefault(value: integer): integer;
procedure rpcSaveDocumentDefaults(classvalue, titledefault: integer; aList: TStrings);

procedure rpcGetLabDays(var InpatientDays: integer; var OutpatientDays: integer);
procedure rpcGetLabUserDays(var InpatientDays: integer; var OutpatientDays: integer);
procedure rpcGetApptDays(var StartDays: integer; var StopDays: integer);
procedure rpcGetApptUserDays(var StartDays: integer; var StopDays: integer);
procedure rpcSetDays(InpatientDays, OutpatientDays, StartDays, StopDays: integer);
procedure rpcGetImagingDays(var MaxNum: integer; var StartDays: integer; var StopDays: integer);
procedure rpcGetImagingUserDays(var MaxNum: integer; var StartDays: integer; var StopDays: integer);
procedure rpcSetImagingDays(MaxNum, StartDays, StopDays: integer);

procedure rpcGetReminders(Dest: TStrings);
procedure rpcSetReminders(aList: TStringList);

function rpcGetListOrder: Char;
procedure rpcGetClinicUserDays(var StartDays: integer; var StopDays: integer);
procedure rpcGetClinicDefaults(var mon, tues, wed, thurs, fri, sat, sun: integer);
procedure rpcGetListSourceDefaults(var provider, treating, list, ward, pcmm: integer);
procedure rpcSetClinicDefaults(StartDays, StopDays, mon, tues, wed, thurs, fri, sat, sun: integer);
procedure rpcSetPtListDefaults(PLSource: string; PLSort: Char; prov, spec, team, ward, pcmm: integer);

procedure rpcGetPersonalLists(Dest: TStrings);
procedure rpcGetAllTeams(Dest: TStrings);
procedure rpcGetTeams(Dest: TStrings);
procedure rpcGetATeams(Dest: TStrings);
procedure rpcGetPcmmTeams(Dest: TStrings);
procedure rpcDeleteList(aString: String);
function rpcNewList(aString: String; Visibility: integer): String;
procedure rpcSaveListChanges(aList: TStrings; aListIEN, aListVisibility: integer);
procedure rpcListUsersByTeam(Dest: TStrings; teamid: integer);
procedure rpcListUsersByPcmmTeam(Dest: TStrings; teamid: integer);
procedure rpcRemoveList(aListIEN: integer);
procedure rpcAddList(aListIEN: integer);

procedure rpcGetCombo(aResults: TStrings);
procedure rpcSetCombo(aList: TStrings);

procedure rpcGetDefaultReportsSetting(var int1: integer; var int2: integer; var int3: integer);
procedure rpcDeleteUserLevelReportsSetting;
procedure rpcActiveDefaultSetting;
procedure rpcSetDefaultReportsSetting(aString: string);
procedure rpcSetIndividualReportSetting(aString1:string; aString2:string);
procedure rpcRetrieveDefaultSetting(var int1: integer; var int2: integer; var int3: integer; var msg: string);

procedure rpcGetRangeForMeds(var startDt, stopDt: TFMDateTime);
procedure rpcPutRangeForMeds(TheVal: string);
procedure rpcGetRangeForMedsIn(var startDt, stopDt: TFMDateTime);
procedure rpcPutRangeForMedsIn(TheVal: string);
procedure rpcGetRangeForMedsOp(var startDt, stopDt: TFMDateTime);
procedure rpcPutRangeForMedsOp(TheVal: string);
procedure rpcGetRangeForEncs(var StartDays, StopDays: integer; DefaultParams: Boolean);
procedure rpcPutRangeForEncs(StartDays, StopDays: string);
procedure rpcGetEncFutureDays(var FutureDays: string);


/// <summary>Loads/Saves Required fields processing preferences
/// <para>Supported actions:</para><para><c>LDPREF</c> - loading preferences from server</para>
/// <para><c>SVPREF</c> - saving preferences to server</para>
/// </summary>
///  <returns><c>RC^Message</c> - Positive RC indicates successful execution.
///  Error Message is returned for negative RC only.</returns>
/// <remarks>
/// Use blank value of <c>aData</c> with <c>LDPREF</c> action
/// </remarks>
function rpcGetSetRequiredFieldsPreferences(anAction,aData:String):String; // NSR20100706 AA 2015/10/08

/// <summary>Provides surrogates info for current user.
/// </summary>
/// <remarks>
///  First line is returned as:
///    <c>RC^Message</c> - Positive RC indicates # of returent records.
///  The rest of the list includes surrogates descriptors as:
///    <c>DFN^Name^FromDate^UntilDate</c>
///
///  NOTE: Dates are returned in FileMan format
/// </remarks>
procedure rpcGetSurrogateInfoList(const aResult:TStrings);

/// <summary>Provides number of days prior to purge the processed alert
/// </summary>
/// <remarks>
///  No parameters needed. The default value returned is 30 (days)
/// </remarks>
function rpcGetDaysBeforeAlertPurge:Integer;

/// <summary>Provides Surrogate Editor parameters
/// </summary>
/// <remarks>
///  Format: X^YY
///     X - if "1" use Surrogate editor populates Star and Stop fields with values
///     YY - default period for a surrogate (7 days)
/// </remarks>
function rpcGetSurrogateParams(var aValue:String):Boolean;
/// <summary>Saves Surrogate Editor parameters on server
/// </summary>
/// <remarks>
///  Format: X^YY
///     X - if "1" use Surrogate editor populates Star and Stop fields with values
///     YY - default period for a surrogate (7 days)
/// </remarks>
function rpcSetSurrogateParams(aValue:String):Boolean;


implementation

//..............................................................................


uses uSimilarNames;
procedure rpcGetNotifications(aResults: TStrings);
begin
  CallVistA('ORWTPP GETNOT', [nil], aResults);
  MixedCaseList(aResults);
end;

procedure rpcGetOrderChecks(aResults: TStrings);
begin
  CallVistA('ORWTPP GETOC', [nil], aResults);
  MixedCaseList(aResults);
end;

function rpcGetNotificationDefaults: String;
begin
  CallVistA('ORWTPP GETNOTO', [nil], Result);
end;

function rpcGetSurrogateInfo: String;
begin
  CallVistA('ORWTPP GETSURR', [nil], Result);
  Result := MixedCase(Result);
end;

procedure rpcCheckSurrogate(surrogate: Int64; var ok: boolean; var msg: string);
var
  value: string;
begin
  CallVistA('ORWTPP CHKSURR', [surrogate], value);
  ok := Piece(value, '^', 1) = '1';
  msg := Piece(value, '^', 2);
end;

procedure rpcSetSurrogateInfo(aString: String; var ok: boolean; var msg: string);
var
  value: string;
begin
  CallVistA('ORWTPP SAVESURR', [aString], value);
  ok := Piece(value, '^', 1) = '1';
  msg := Piece(value, '^', 2);
end;

procedure rpcClearNotifications;
begin
  CallVistA('ORWTPP CLEARNOT', [nil]);
end;

procedure rpcSetNotifications(aList: TStringList);
begin
  CallVistA('ORWTPP SAVENOT', [aList]);
end;

procedure rpcSetOrderChecks(aList: TStringList);
begin
  CallVistA('ORWTPP SAVEOC', [aList]);
end;

procedure rpcSetOtherStuff(aString: String);
begin
  CallVistA('ORWTPP SAVENOTO', [aString]);
end;

procedure rpcSetCopyPaste(aString: String);
begin
  CallVistA('ORWTIU SVCPIDNT', [aString]);
end;

//..............................................................................

function rpcGetCopyPaste: String;
begin
  CallVistA('ORWTIU LDCPIDNT', [nil], Result);
end;

procedure rpcGetOtherTabs(aResults: TStrings);
begin
  CallVistA('ORWTPO GETTABS', [nil], aResults);
  MixedCaseList(aResults);
end;

function rpcGetOther: String;
begin
  CallVistA('ORWTPP GETOTHER', [nil], Result);
end;

procedure rpcSetOther(info: String);
begin
  CallVistA('ORWTPP SETOTHER', [info]);
end;

procedure rpcGetCosigners(AORComboBox: TORComboBox; const StartFrom: string;
  Direction: Integer; aResults: TStrings);
begin
  SNCallVistA(AORComboBox, SN_ORWTPP_GETCOS, [StartFrom, Direction], aResults);
  MixedCaseList(aResults);
end;

function rpcGetDefaultCosigner: String;
begin
  CallVistA('ORWTPP GETDCOS', [nil], Result);
end;

procedure rpcSetDefaultCosigner(value: Int64);
begin
  CallVistA('ORWTPP SETDCOS', [value])
end;

function rpcGetSubject: boolean;
var
  value: string;
begin
  CallVistA('ORWTPP GETSUB', [nil], value);
  Result := (value = '1');
end;

procedure rpcSetSubject(value: boolean);
begin
  CallVistA('ORWTPP SETSUB', [value])
end;

procedure rpcGetClasses(aResults: TStrings);
begin
  CallVistA('ORWTPN GETCLASS', [nil], aResults);
  MixedCaseList(aResults);
end;

procedure rpcGetTitlesForClass(value: integer; const StartFrom: string; Direction: Integer; aResults: TStrings);
begin
  CallVistA('TIU LONG LIST OF TITLES', [value, StartFrom, Direction], aResults);
end;

procedure rpcGetTitlesForUser(value: integer; aResults: TStrings);
begin
  CallVistA('ORWTPP GETTU', [value], aResults);
end;

function rpcGetTitleDefault(value: integer): integer;
begin
  CallVistA('ORWTPP GETTD', [value], Result, -1);
end;

procedure rpcSaveDocumentDefaults(classvalue, titledefault: integer; aList: TStrings);
begin
  CallVistA('ORWTPP SAVET', [classvalue, titledefault, aList]);
end;

//..............................................................................

procedure rpcGetLabDays(var InpatientDays: integer; var OutpatientDays:integer);
var
  values: string;
begin
  CallVistA('ORWTPO CSLABD', [nil], values);
  InpatientDays := strtointdef(Piece(values, '^', 1), 0);
  OutpatientDays := strtointdef(Piece(values, '^', 2), 0);
end;

procedure rpcGetLabUserDays(var InpatientDays: integer; var OutpatientDays: integer);
var
  values: string;
begin
  CallVistA('ORWTPP CSLAB', [nil], values);
  InpatientDays := -strtointdef(Piece(values, '^', 1), 0);
  OutpatientDays := -strtointdef(Piece(values, '^', 2), 0);
end;

procedure rpcGetApptDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  CallVistA('ORWTPD1 GETCSDEF', [nil], values);
  start := Piece(values, '^', 1);
  stop  := Piece(values, '^', 2);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
end;

procedure rpcGetApptUserDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  CallVistA('ORWTPD1 GETCSRNG', [nil], values);
  start := Piece(values, '^', 1);
  stop  := Piece(values, '^', 2);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
end;

procedure rpcSetDays(InpatientDays, OutpatientDays, StartDays, StopDays: integer);
var
  values: string;
begin
  values := '';
  values := values + inttostr(InpatientDays) + '^';
  values := values + inttostr(OutpatientDays) + '^';
  values := values + inttostr(StartDays) + '^';
  values := values + inttostr(StopDays) + '^';
  CallVistA('ORWTPD1 PUTCSRNG', [values]);
end;

procedure rpcGetImagingDays(var MaxNum: integer; var StartDays: integer; var StopDays: integer);
var
  values, max, start, stop: string;
begin
  CallVistA('ORWTPO GETIMGD', [nil], values);
  //values := 'T-120;T;;;100';
  start := Piece(values, ';', 1);
  stop  := Piece(values, ';', 2);
  max  := Piece(values, ';', 5);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
  MaxNum  := strtointdef(max, 0);
end;

procedure rpcGetImagingUserDays(var MaxNum: integer; var StartDays: integer; var StopDays: integer);
var
  values, max, start, stop: string;
begin
  CallVistA('ORWTPP GETIMG', [nil], values);
  //values := 'T-180;T;;;15';
  start := Piece(values, ';', 1);
  stop  := Piece(values, ';', 2);
  max  := Piece(values, ';', 5);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
  MaxNum  := strtointdef(max, 0);
end;

procedure rpcSetImagingDays(MaxNum, StartDays, StopDays: integer);
begin
  CallVistA('ORWTPP SETIMG', [MaxNum, StartDays, StopDays]);
end;

//..............................................................................

procedure rpcGetReminders(Dest: TStrings);
begin
  CallVistA('ORWTPP GETREM', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcSetReminders(aList: TStringList);
begin
  CallVistA('ORWTPP SETREM', [aList]);
end;

//..............................................................................

function rpcGetListOrder: Char;
var
  aResult: String;
begin
  CallVistA('ORWTPP SORTDEF', [nil], aResult);
  Result := CharAt(aResult, 1);
end;

procedure rpcGetClinicUserDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  CallVistA('ORWTPP CLRANGE', [nil], values);
  start := Piece(values, '^', 1);
  stop  := Piece(values, '^', 2);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
end;

procedure rpcGetClinicDefaults(var mon, tues, wed, thurs, fri, sat, sun: integer);
var
  values: string;
begin
  CallVistA('ORWTPP CLDAYS', [nil], values);
  mon    := strtointdef(Piece(values, '^', 1), 0);
  tues   := strtointdef(Piece(values, '^', 2), 0);
  wed    := strtointdef(Piece(values, '^', 3), 0);
  thurs  := strtointdef(Piece(values, '^', 4), 0);
  fri    := strtointdef(Piece(values, '^', 5), 0);
  sat    := strtointdef(Piece(values, '^', 6), 0);
  sun    := strtointdef(Piece(values, '^', 7), 0);
end;

procedure rpcGetListSourceDefaults(var provider, treating, list, ward, pcmm: integer);
var
  values: string;
begin
  CallVistA('ORWTPP LSDEF', [nil], values);
  provider := strtointdef(Piece(values, '^', 1), 0);
  treating := strtointdef(Piece(values, '^', 2), 0);
  list     := strtointdef(Piece(values, '^', 3), 0);
  ward     := strtointdef(Piece(values, '^', 4), 0);
  pcmm     := strtointdef(Piece(values, '^', 6), 0);
end;

procedure rpcSetClinicDefaults(StartDays, StopDays, mon, tues, wed, thurs, fri, sat, sun: integer);
var
  values: string;
begin
  values := '';
  values := values + inttostr(StartDays) + '^';
  values := values + inttostr(StopDays) + '^';
  values := values + inttostr(mon) + '^';
  values := values + inttostr(tues) + '^';
  values := values + inttostr(wed) + '^';
  values := values + inttostr(thurs) + '^';
  values := values + inttostr(fri) + '^';
  values := values + inttostr(sat) + '^';
  values := values + inttostr(sun) + '^';
  CallVistA('ORWTPP SAVECD', [values]);
end;

procedure rpcSetPtListDefaults(PLSource: string; PLSort: Char; prov, spec, team, ward, pcmm: integer);
// TDP - Modified 5/27/2014 - Changed PLSource to string and added pcmm input
var
  values: string;
begin
  values := '';
  values := values + PLSource + '^';
  values := values + PLSort + '^';
  values := values + inttostr(prov) + '^';
  values := values + inttostr(spec) + '^';
  values := values + inttostr(team) + '^';
  values := values + inttostr(ward) + '^';
  values := values + inttostr(pcmm) + '^'; // TDP - Added 5/27/2014
  CallVistA('ORWTPP SAVEPLD', [values]);
end;

//..............................................................................

procedure rpcGetPersonalLists(Dest: TStrings);
begin
  CallVistA('ORWTPP PLISTS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcGetAllTeams(Dest: TStrings);
begin
  CallVistA('ORWTPP PLTEAMS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcGetTeams(Dest: TStrings);
begin
  CallVistA('ORWTPP TEAMS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcGetATeams(Dest: TStrings);
begin
  CallVistA('ORWTPT ATEAMS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcGetPcmmTeams(Dest: TStrings);
begin
  CallVistA('ORWTPP PCMTEAMS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure rpcDeleteList(aString: String);
begin
  CallVistA('ORWTPP DELLIST', [aString]);
end;

function rpcNewList(aString: String; Visibility: integer): String;
begin
  CallVistA('ORWTPP NEWLIST', [aString, Visibility], Result);
  Result := MixedCase(Result);
end;

procedure rpcSaveListChanges(aList: TStrings; aListIEN, aListVisibility: integer);
begin
  CallVistA('ORWTPP SAVELIST', [aList, aListIEN, aListVisibility]);
end;

procedure rpcListUsersByTeam(Dest: TStrings; teamid: integer);
begin
  CallVistA('ORWTPT GETTEAM', [teamid], Dest);
  MixedCaseList(Dest);
end;

procedure rpcListUsersByPcmmTeam(Dest: TStrings; teamid: integer);
begin
  CallVistA('ORWTPT GETPTEAM', [teamid], Dest);
  MixedCaseList(Dest);
end;

procedure rpcRemoveList(aListIEN: integer);
begin
  CallVistA('ORWTPP REMLIST', [aListIEN]);
end;

procedure rpcAddList(aListIEN: integer);
begin
  CallVistA('ORWTPP ADDLIST', [aListIEN]);
end;

//..............................................................................

procedure rpcGetCombo(aResults: TStrings);
begin
  CallVistA('ORWTPP GETCOMBO', [nil], aResults);
  MixedCaseList(aResults);
end;

procedure rpcSetCombo(aList: TStrings);
begin
  CallVistA('ORWTPP SETCOMBO', [aList]);
end;

//..............................................................................

procedure rpcGetDefaultReportsSetting(var int1: integer; var int2: integer; var int3: integer);
var
  values: string;
  startoffset,stopoffset: string;
begin
  CallVistA('ORWTPD GETDFLT', [nil], values);
  if length(values)=0 then
    exit;
  startoffset := Piece(values,';',1);
  delete(startoffset,1,1);
  stopoffset := Piece(values,';',2);
  delete(stopoffset,1,1);
  int1 := strtointdef(startoffset,0);
  int2 := strtointdef(stopoffset,0);
  int3:= strtointdef(Piece(values, ';', 3), 100);  // max occurences
end;

procedure rpcDeleteUserLevelReportsSetting;
begin
  CallVistA('ORWTPD DELDFLT',[nil]);
end;

procedure rpcActiveDefaultSetting;
begin
  CallVistA('ORWTPD ACTDF',[nil]);
end;

procedure rpcSetDefaultReportsSetting(aString: string);
begin
  CallVistA('ORWTPD SUDF',[aString]);
end;

procedure rpcSetIndividualReportSetting(aString1:string; aString2:string);
begin
  CallVistA('ORWTPD SUINDV',[aString1,aString2]);
end;

procedure rpcRetrieveDefaultSetting(var int1: integer; var int2: integer; var int3: integer; var msg: string);
var
  values: string;
  startoffset,stopoffset: string;
begin
  CallVistA('ORWTPD RSDFLT',[nil], values);
  if length(values)=0 then
    begin
      msg := 'NODEFAULT';
      exit;
    end;
  startoffset := Piece(values,';',1);
  delete(startoffset,1,1);
  stopoffset := Piece(values,';',2);
  delete(stopoffset,1,1);
  int1 := strtointdef(startoffset,0);
  int2 := strtointdef(stopoffset,0);
  int3:= strtointdef(Piece(values, ';', 3), 100);  // max occurences
end;

procedure rpcGetRangeForMeds(var startDt, stopDt: TFMDateTime);
var
  rst,sDt,eDt: string;
  td: TFMDateTime;
begin
  CallVistA('ORWTPD GETOCM', [nil], rst);
  sDt := Piece(rst,';',1);
  if lowerCase(sDt) <> 't' then
    Delete(sDt,1,1);
  eDt := Piece(rst,';',2);
  if lowerCase(eDt) <> 't' then
    Delete(eDt,1,1);
  td := FMToday;
  if Length(sDt)>0 then
    startDt := FMDateTimeOffsetBy(td, StrToIntDef(sDt,0));
  if Length(eDt)>0 then
    stopDt  := FMDateTimeOffsetBy(td, StrToIntDef(eDt,0));
end;

procedure rpcPutRangeForMeds(TheVal: string);
begin
  CallVistA('ORWTPD PUTOCM',[TheVal]);
end;

procedure rpcGetRangeForMedsIn(var startDt, stopDt: TFMDateTime);
var
  rst,sDt,eDt: string;
  td: TFMDateTime;
begin
  CallVistA('ORWTPD GETOCMIN', [nil], rst);
  sDt := Piece(rst,';',1);
  if lowerCase(sDt) <> 't' then
    Delete(sDt,1,1);
  eDt := Piece(rst,';',2);
  if lowerCase(eDt) <> 't' then
    Delete(eDt,1,1);
  td := FMToday;
  if Length(sDt)>0 then
    startDt := FMDateTimeOffsetBy(td, StrToIntDef(sDt,0));
  if Length(eDt)>0 then
    stopDt  := FMDateTimeOffsetBy(td, StrToIntDef(eDt,0));
end;

procedure rpcPutRangeForMedsIn(TheVal: string);
begin
  CallVistA('ORWTPD PUTOCMIN',[TheVal]);
end;

procedure rpcGetRangeForMedsOp(var startDt, stopDt: TFMDateTime);
var
  rst,sDt,eDt: string;
  td: TFMDateTime;
begin
  CallVistA('ORWTPD GETOCMOP', [nil], rst);
  sDt := Piece(rst,';',1);
  if lowerCase(sDt) <> 't' then
    Delete(sDt,1,1);
  eDt := Piece(rst,';',2);
  if lowerCase(eDt) <> 't' then
    Delete(eDt,1,1);
  td := FMToday;
  if Length(sDt)>0 then
    startDt := FMDateTimeOffsetBy(td, StrToIntDef(sDt,0));
  if Length(eDt)>0 then
    stopDt  := FMDateTimeOffsetBy(td, StrToIntDef(eDt,0));
end;

procedure rpcPutRangeForMedsOp(TheVal: string);
begin
  CallVistA('ORWTPD PUTOCMOP',[TheVal]);
end;

procedure rpcGetRangeForEncs(var StartDays, StopDays: integer; DefaultParams: Boolean);
var
  Start, Stop, Values: string;
begin
  if DefaultParams then
    CallVistA('ORWTPD1 GETEFDAT', [nil], Values)
  else
    CallVistA('ORWTPD1 GETEDATS', [nil], Values);
  Start := Piece(Values, '^', 1);
  Stop  := Piece(Values, '^', 2);
  StartDays := StrToIntDef(Start, 0);
  StopDays  := StrToIntDef(Stop, 0);
end;

procedure rpcPutRangeForEncs(StartDays, StopDays: string);
var
  values: string;
begin
  values := '';
  values := values + StartDays + '^';
  values := values + StopDays;
  CallVistA('ORWTPD1 PUTEDATS',[values]);
end;

procedure rpcGetEncFutureDays(var FutureDays: string);
begin
  CallVistA('ORWTPD1 GETEAFL', [nil], FutureDays);
end;

// NSR20100706 AA 2015/10/08 --------------------------------------------- begin
function rpcGetSetRequiredFieldsPreferences(anAction,aData:String):String;
const
  rpcName = 'ORWTIU TEMPLATE PREFERENCES';
begin
  try
    if anAction = 'LDPREF' then
      CallVistA(rpcName, [anAction],Result)
    else if anAction = 'SVPREF' then
      CallVistA(rpcName, [anAction,aData], Result)
    else
      Result := '-2^Unsupported Acton "'+anAction+'"';
  except
    on E: Exception do
      Result := '-3^Error executing RPC "'+E.Message+'"';
  end;
end;
// NSR20100706 AA 2015/10/08 ----------------------------------------------- end

// NSR20071216 AA 2015/11/30 ----------------------------------------------- begin
//NSR20071216 mnj- RPC 'ORWTPP GETSURRS' addded to return multiple Surrogates.
//                 Ty created new RCP from RPC 'ORWTPP GETSURR'
procedure rpcGetSurrogateInfoList(const aResult:TStrings);
begin
  if not assigned(aResult) then
    exit;
  try
    CallVistA('ORWTPP GETSURRS', [nil],aResult);
    MixedCaseList(aResult);
  except
    on E: Exception do
      aResult.Clear;
  end;
end;
// NSR20071216 AA 2015/11/30 ----------------------------------------------- end
const
  RPC_SURROGATE_DEFAULTS = 'ORWTPP SURRDFLT';
// NSR20071216 AA 2017/11/15 --------------------------------------------- begin
function rpcGetSurrogateParams(var aValue:String):Boolean;
begin
  Result := CallVistA(RPC_SURROGATE_DEFAULTS, ['GET',{IntToStr(User.DUZ)}''],aValue);
end;

function rpcSetSurrogateParams(aValue:String):Boolean;
begin
  Result := CallVistA(RPC_SURROGATE_DEFAULTS, ['SAVE',{IntToStr(User.DUZ)+'^'+}aValue]);
end;
// NSR20071216 AA 2017/11/15 ----------------------------------------------- end

function rpcGetDaysBeforeAlertPurge:Integer;
var
 sResult:String;
begin
  CallVistA('ORWTPR GETARCHP',[],sResult);
  Result := StrToIntDef(sResult, 30);
end;

end.

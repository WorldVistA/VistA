unit rOptions;

interface

uses SysUtils, Classes, ORNet, ORFn, uCore, rCore, rTIU, rConsults;

function rpcGetNotifications: TStrings;
function rpcGetOrderChecks: TStrings;
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
function rpcGetOtherTabs: TStrings;
function rpcGetOther: String;
procedure rpcSetOther(info: String);
function rpcGetCosigners(const StartFrom: string; Direction: Integer): TStrings;
function rpcGetDefaultCosigner: String;
procedure rpcSetDefaultCosigner(value: Int64);
function rpcGetSubject: boolean;
procedure rpcSetSubject(value: boolean);
function rpcGetClasses: TStrings;
function rpcGetTitlesForClass(value: integer; const StartFrom: string; Direction: Integer): TStrings;
function rpcGetTitlesForUser(value: integer): TStrings;
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
procedure rpcGetListSourceDefaults(var provider, treating, list, ward: integer);
procedure rpcSetClinicDefaults(StartDays, StopDays, mon, tues, wed, thurs, fri, sat, sun: integer);
procedure rpcSetPtListDefaults(PLSource, PLSort: Char; prov, spec, team, ward: integer);

procedure rpcGetPersonalLists(Dest: TStrings);
procedure rpcGetAllTeams(Dest: TStrings);
procedure rpcGetTeams(Dest: TStrings);
procedure rpcGetATeams(Dest: TStrings);
procedure rpcDeleteList(aString: String);
function rpcNewList(aString: String; Visibility: integer): String;
procedure rpcSaveListChanges(aList: TStrings; aListIEN, aListVisibility: integer);
procedure rpcListUsersByTeam(Dest: TStrings; teamid: integer);
procedure rpcRemoveList(aListIEN: integer);
procedure rpcAddList(aListIEN: integer);

function rpcGetCombo: TStrings;
procedure rpcSetCombo(aList: TStrings);

procedure rpcGetDefaultReportsSetting(var int1: integer; var int2: integer; var int3: integer);
procedure rpcDeleteUserLevelReportsSetting;
procedure rpcActiveDefaultSetting;
procedure rpcSetDefaultReportsSetting(aString: string);
procedure rpcSetIndividualReportSetting(aString1:string; aString2:string);
procedure rpcRetrieveDefaultSetting(var int1: integer; var int2: integer; var int3: integer; var msg: string);

procedure rpcGetRangeForMeds(var startDt, stopDt: TFMDateTime);
procedure rpcPutRangeForMeds(TheVal: string);
procedure rpcGetRangeForEncs(var StartDays, StopDays: integer; DefaultParams: Boolean);
procedure rpcPutRangeForEncs(StartDays, StopDays: string);
procedure rpcGetEncFutureDays(var FutureDays: string);

implementation

//..............................................................................

function rpcGetNotifications: TStrings;
begin
  CallV('ORWTPP GETNOT', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetOrderChecks: TStrings;
begin
  CallV('ORWTPP GETOC', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetNotificationDefaults: String;
begin
  result := sCallV('ORWTPP GETNOTO', [nil]);
end;

function rpcGetSurrogateInfo: String;
begin
  result := MixedCase(sCallV('ORWTPP GETSURR', [nil]));
end;

procedure rpcCheckSurrogate(surrogate: Int64; var ok: boolean; var msg: string);
var
  value: string;
begin
  value := sCallV('ORWTPP CHKSURR', [surrogate]);
  ok := Piece(value, '^', 1) = '1';
  msg := Piece(value, '^', 2);
end;

(*procedure rpcSetSurrogateInfo(aString: String);
begin
  CallV('ORWTPP SAVESURR', [aString]);
end;*)

procedure rpcSetSurrogateInfo(aString: String; var ok: boolean; var msg: string);
var
  value: string;
begin
  value := sCallV('ORWTPP SAVESURR', [aString]);
  ok := Piece(value, '^', 1) = '1';
  msg := Piece(value, '^', 2);
end;


procedure rpcClearNotifications;
begin
  CallV('ORWTPP CLEARNOT', [nil]);
end;

procedure rpcSetNotifications(aList: TStringList);
begin
  CallV('ORWTPP SAVENOT', [aList]);
end;

procedure rpcSetOrderChecks(aList: TStringList);
begin
  CallV('ORWTPP SAVEOC', [aList]);
end;

procedure rpcSetOtherStuff(aString: String);
begin
  CallV('ORWTPP SAVENOTO', [aString]);
end;

procedure rpcSetCopyPaste(aString: String);
begin
  CallV('ORWTIU SVCPIDNT', [aString]);
end;

//..............................................................................

function rpcGetCopyPaste: String;
begin
 Result := sCallV('ORWTIU LDCPIDNT', [nil]);
end;

function rpcGetOtherTabs: TStrings;
begin
  CallV('ORWTPO GETTABS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetOther: String;
begin
  result := sCallV('ORWTPP GETOTHER', [nil]);
end;

procedure rpcSetOther(info: String);
begin
  CallV('ORWTPP SETOTHER', [info]);
end;

function rpcGetCosigners(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('ORWTPP GETCOS', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function rpcGetDefaultCosigner: String;
begin
  result := sCallV('ORWTPP GETDCOS', [nil]);
end;

procedure rpcSetDefaultCosigner(value: Int64);
begin
  CallV('ORWTPP SETDCOS', [value])
end;

function rpcGetSubject: boolean;
var
  value: string;
begin
  value := sCallV('ORWTPP GETSUB', [nil]);
  if value = '1' then result := true
  else result := false;
end;

procedure rpcSetSubject(value: boolean);
begin
  CallV('ORWTPP SETSUB', [value])
end;

function rpcGetClasses: TStrings;
begin
  CallV('ORWTPN GETCLASS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetTitlesForClass(value: integer; const StartFrom: string; Direction: Integer): TStrings;
begin
(*  case value of
    CLS_PROGRESS_NOTES: CallV('TIU LONG LIST OF TITLES', [value, StartFrom, Direction]);
  else
    CallV('ORWTPN GETTC', [value, StartFrom, Direction]);   //****** original
  end;*)
  CallV('TIU LONG LIST OF TITLES', [value, StartFrom, Direction]);
  //MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetTitlesForUser(value: integer): TStrings;
begin
  CallV('ORWTPP GETTU', [value]);
  //MixedCaseList(RPCBrokerV.Results);
  result :=RPCBrokerV.Results;
end;

function rpcGetTitleDefault(value: integer): integer;
begin
  result := strtointdef(sCallV('ORWTPP GETTD', [value]), -1);
end;

procedure rpcSaveDocumentDefaults(classvalue, titledefault: integer; aList: TStrings);
begin
  CallV('ORWTPP SAVET', [classvalue, titledefault, aList]);
end;

//..............................................................................

procedure rpcGetLabDays(var InpatientDays: integer; var OutpatientDays:integer);
var
  values: string;
begin
  values := sCallV('ORWTPO CSLABD', [nil]);
  InpatientDays := strtointdef(Piece(values, '^', 1), 0);
  OutpatientDays := strtointdef(Piece(values, '^', 2), 0);
end;

procedure rpcGetLabUserDays(var InpatientDays: integer; var OutpatientDays: integer);
var
  values: string;
begin
  values := sCallV('ORWTPP CSLAB', [nil]);
  InpatientDays := -strtointdef(Piece(values, '^', 1), 0);
  OutpatientDays := -strtointdef(Piece(values, '^', 2), 0);
end;

procedure rpcGetApptDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  values := sCallV('ORWTPD1 GETCSDEF', [nil]);
  start := Piece(values, '^', 1);
  stop  := Piece(values, '^', 2);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
end;

procedure rpcGetApptUserDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  values := sCallV('ORWTPD1 GETCSRNG', [nil]);
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
  CallV('ORWTPD1 PUTCSRNG', [values]);
end;

procedure rpcGetImagingDays(var MaxNum: integer; var StartDays: integer; var StopDays: integer);
var
  values, max, start, stop: string;
begin
  values := sCallV('ORWTPO GETIMGD', [nil]);
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
  values := sCallV('ORWTPP GETIMG', [nil]);
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
  CallV('ORWTPP SETIMG', [MaxNum, StartDays, StopDays]);
end;

//..............................................................................

procedure rpcGetReminders(Dest: TStrings);
begin
  CallV('ORWTPP GETREM', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcSetReminders(aList: TStringList);
begin
  CallV('ORWTPP SETREM', [aList]);
end;

//..............................................................................

function rpcGetListOrder: Char;
begin
  result := CharAt(sCallV('ORWTPP SORTDEF', [nil]), 1);
end;

procedure rpcGetClinicUserDays(var StartDays: integer; var StopDays: integer);
var
  values, start, stop: string;
begin
  values := sCallV('ORWTPP CLRANGE', [nil]);
  start := Piece(values, '^', 1);
  stop  := Piece(values, '^', 2);
  StartDays := strtointdef(Piece(start, 'T', 2), 0);
  StopDays  := strtointdef(Piece(stop, 'T', 2), 0);
end;

procedure rpcGetClinicDefaults(var mon, tues, wed, thurs, fri, sat, sun: integer);
var
  values: string;
begin
  values := sCallV('ORWTPP CLDAYS', [nil]);
  mon    := strtointdef(Piece(values, '^', 1), 0);
  tues   := strtointdef(Piece(values, '^', 2), 0);
  wed    := strtointdef(Piece(values, '^', 3), 0);
  thurs  := strtointdef(Piece(values, '^', 4), 0);
  fri    := strtointdef(Piece(values, '^', 5), 0);
  sat    := strtointdef(Piece(values, '^', 6), 0);
  sun    := strtointdef(Piece(values, '^', 7), 0);
end;

procedure rpcGetListSourceDefaults(var provider, treating, list, ward: integer);
var
  values: string;
begin
  values := sCallV('ORWTPP LSDEF', [nil]);
  provider := strtointdef(Piece(values, '^', 1), 0);
  treating := strtointdef(Piece(values, '^', 2), 0);
  list     := strtointdef(Piece(values, '^', 3), 0);
  ward     := strtointdef(Piece(values, '^', 4), 0);
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
  CallV('ORWTPP SAVECD', [values]);
end;

procedure rpcSetPtListDefaults(PLSource, PLSort: Char; prov, spec, team, ward: integer);
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
  CallV('ORWTPP SAVEPLD', [values]);
end;

//..............................................................................

procedure rpcGetPersonalLists(Dest: TStrings);
begin
  CallV('ORWTPP PLISTS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcGetAllTeams(Dest: TStrings);
begin
  CallV('ORWTPP PLTEAMS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcGetTeams(Dest: TStrings);
begin
  CallV('ORWTPP TEAMS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcGetATeams(Dest: TStrings);
begin
  CallV('ORWTPT ATEAMS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcDeleteList(aString: String);
begin
  CallV('ORWTPP DELLIST', [aString]);
end;

function rpcNewList(aString: String; Visibility: integer): String;
begin
  result := sCallV('ORWTPP NEWLIST', [aString, Visibility]);
  result := MixedCase(result);
end;

procedure rpcSaveListChanges(aList: TStrings; aListIEN, aListVisibility: integer);
begin
  CallV('ORWTPP SAVELIST', [aList, aListIEN, aListVisibility]);
end;

procedure rpcListUsersByTeam(Dest: TStrings; teamid: integer);
begin
  CallV('ORWTPT GETTEAM', [teamid]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure rpcRemoveList(aListIEN: integer);
begin
  CallV('ORWTPP REMLIST', [aListIEN]);
end;

procedure rpcAddList(aListIEN: integer);
begin
  CallV('ORWTPP ADDLIST', [aListIEN]);
end;

//..............................................................................

function rpcGetCombo: TStrings;
begin
  CallV('ORWTPP GETCOMBO', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  result := RPCBrokerV.Results;
end;

procedure rpcSetCombo(aList: TStrings);
begin
  CallV('ORWTPP SETCOMBO', [aList]);
end;

//..............................................................................

procedure rpcGetDefaultReportsSetting(var int1: integer; var int2: integer; var int3: integer);
var
  values: string;
  startoffset,stopoffset: string;
begin
  values := sCallV('ORWTPD GETDFLT', [nil]);
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
  sCallV('ORWTPD DELDFLT',[nil]);
end;

procedure rpcActiveDefaultSetting;
begin
  sCallV('ORWTPD ACTDF',[nil]);
end;

procedure rpcSetDefaultReportsSetting(aString: string);
begin
  sCallV('ORWTPD SUDF',[aString]);
end;

procedure rpcSetIndividualReportSetting(aString1:string; aString2:string);
begin
  sCallV('ORWTPD SUINDV',[aString1,aString2]);
end;

procedure rpcRetrieveDefaultSetting(var int1: integer; var int2: integer; var int3: integer; var msg: string);
var
  values: string;
  startoffset,stopoffset: string;
begin
  values :=  sCallV('ORWTPD RSDFLT',[nil]);
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
  rst := SCallV('ORWTPD GETOCM',[nil]);
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
  SCallV('ORWTPD PUTOCM',[TheVal]);
end;

procedure rpcGetRangeForEncs(var StartDays, StopDays: integer; DefaultParams: Boolean);
var
  Start, Stop, Values: string;
begin
  if DefaultParams then
    Values := SCallV('ORWTPD1 GETEFDAT',[nil])
  else
    Values := SCallV('ORWTPD1 GETEDATS',[nil]);
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
  CallV('ORWTPD1 PUTEDATS',[values]);
end;

procedure rpcGetEncFutureDays(var FutureDays: string);
begin
  FutureDays := SCallV('ORWTPD1 GETEAFL',[nil]);
end;

end.

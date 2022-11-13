unit rGraphs;

interface

uses SysUtils, Classes, Controls, Forms, ORNet, ORFn, Graphics;

function rpcPublicEdit: Boolean;
function rpcReportParams(ien: integer): String;

procedure onoff(x: integer);

function rpcTestGroups(aDest:TStrings; user: int64): Integer;
function rpcATest(aDest:TStrings; test: integer): Integer;

//function rpcATestGroup(testgroup: Integer; user: int64): TStrings; deprecated;
function rpcATestGroup(aDest:TStrings; testgroup: Integer; user: int64): Integer;

//function rpcClass(itemtype: string): TStrings; deprecated;
function rpcClass(aDest: TStrings; itemtype: string): Integer;

//function rpcTaxonomy(alltax: boolean; taxonomies: TStrings): TStrings; deprecated;
function rpcTaxonomy(aDest: TStrings; alltax: boolean; taxonomies: TStrings): Integer;

procedure rpcDetailDay(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  ATypeItem: string; complete: boolean);  //*DFN*

//function rpcDetailSelected(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
//  tests: TStringList; complete: boolean): TStrings; deprecated;  //*DFN*
function rpcDetailSelected(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  tests: TStringList; complete: boolean): Integer;  //*DFN*

procedure rpcFastData(const PatientDFN: string; alldata: TStrings; var ok: boolean);
procedure rpcFastItems(const PatientDFN: string; allitems: TStrings; var ok: boolean);
procedure rpcFastLabs(const PatientDFN: string; alllabs: TStrings; var ok: boolean);
function rpcFastTask(const PatientDFN, oldDFN: string): string;

//function rpcGetAllItems(const PatientDFN: string): TStrings; deprecated;
function rpcGetAllItems(aDest:TStrings; const PatientDFN: string): Integer;

//function rpcGetItems(typeitem: string; const PatientDFN: string): TStrings; deprecated;
function rpcGetItems(aDest:TStrings; typeitem: string; const PatientDFN: string): Integer;

//function rpcGetItemData(itemdata, timestamp: string; const PatientDFN: string): TStrings; deprecated;
function rpcGetItemData(aDest: TStrings; itemdata, timestamp: string; const PatientDFN: string): Integer;

//function rpcGetTypes(const PatientDFN: string; subtypes: boolean): TStrings; deprecated;
function rpcGetTypes(aDest:TStrings; const PatientDFN: string; subtypes: boolean): Integer;

//function rpcGetTestSpec: TStrings; deprecated;
function rpcGetTestSpec(aDest: TStrings): Integer;

//function rpcTesting: TStrings; deprecated;
function rpcTesting(aDest: TStrings): Integer;

//function rpcGetViews(vtype: string; user: int64): TStrings; deprecated;
function rpcGetViews(aDest: TStrings; vtype: string; user: int64): Integer;

//function rpcGetGraphDateRange(reportid: string): TStrings; deprecated;
function rpcGetGraphDateRange(aDest: TStrings; reportid: string): Integer;

//function rpcGetGraphSettings: TStrings; deprecated
function rpcGetGraphSettings(aDest: TStrings): Integer;

procedure rpcSetGraphSettings(paramsetting, permission: string);

//function rpcGetGraphSizing: TStrings; deprecated;
function rpcGetGraphSizing(aDest: TStrings): Integer;

procedure rpcSetGraphSizing(values: TStrings);

//function rpcGetGraphProfiles(profiles, permission: string; ext: integer; userx: int64): TStrings; deprecated;
function rpcGetGraphProfiles(aDest: TStrings; profiles, permission: string; ext: integer; userx: int64): Integer;

procedure rpcSetGraphProfile(paramname, permission: string; paramvalues: TStrings);
procedure rpcDeleteGraphProfile(paramname, permission: string);

//function rpcLookupItems(const filename, startfrom: string; direction: integer): TStrings; deprecated;
function rpcLookupItems(aDest: TStrings; const filename, StartFrom: string; Direction: integer): Integer;


//function rpcDateItem(oldestdate, newestdate: double; filenum: string; const PatientDFN: string): TStrings; deprecated;
function rpcDateItem(aDest: TStrings; oldestdate, newestdate: double;
  filenum: string; const PatientDFN: string): integer;

implementation

function getRpcResults(aRPC:String;aParam: array of const;aDest:TStrings; aConvert:Boolean = False):Integer;
begin
  if CallVistA(aRPC,aParam,aDest) and aConvert then
    MixedCaseList(aDest);
  Result := aDest.Count;
end;

//-------- RPCs copied from rLabs -------------
function rpcTestGroups(aDest:TStrings; user: int64): Integer;
//function rpcTestGroups(user: int64): TStrings;
begin
//  CallV('ORWLRR TG', [user]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;
{
  CallVistA('ORWLRR TG', [user], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
}
  Result := getRPCResults('ORWLRR TG',[user],aDest, True);
end;

//function rpcATest(test: integer): TStrings;
function rpcATest(aDest:TStrings; test: integer): Integer;
begin
//  CallV('ORWLRR ATESTS', [test]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;
{
  CallVistA('ORWLRR ATESTS', [test], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
}
  Result := getRPCResults('ORWLRR ATESTS', [test], aDest, True);
end;

//function rpcATestGroup(testgroup: Integer; user: int64): TStrings;
function rpcATestGroup(aDest:TStrings; testgroup: Integer; user: int64): Integer;
begin
//  CallV('ORWLRR ATG', [testgroup, user]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  Result := getRPCResults('ORWLRR ATG', [testgroup, user], aDest, True);
end;
//------------------------------------------

function rpcPublicEdit: Boolean;
var
  s: String;
begin
  onoff(1);
  Result := CallVistA('ORWGRPC PUBLIC', [nil], s) and (s = '1');
  //Result := false;  //************* for testing turn on
  onoff(0);
end;

function rpcReportParams(ien: integer): String;
begin
  onoff(1);
  CallVistA('ORWGRPC RPTPARAM', [ien], Result);
  onoff(0);
end;

procedure rpcDetailDay(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  ATypeItem: string; complete: boolean);  //*DFN*
var
  includecomplete: string;
begin
  if complete then includecomplete := '1' else includecomplete := '0';
  onoff(1);
  CallVistA('ORWGRPC DETAILS', [PatientDFN, ADate1, ADate2, ATypeItem, includecomplete], Dest);
  onoff(0);
end;

//function rpcDetailSelected(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
//  tests: TStringList; complete: boolean): TStrings;  //*DFN*
function rpcDetailSelected(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  tests: TStringList; complete: boolean): Integer;  //*DFN*
var
  includecomplete: string;
begin
  if complete then includecomplete := '1' else includecomplete := '0';
  Result := getRPCResults('ORWGRPC DETAIL', [PatientDFN, ADate1, ADate2, tests, includecomplete], aDest, FALSE);

end;

procedure rpcFastData(const PatientDFN: string; alldata: TStrings; var ok: boolean);
begin
  onoff(1);
  CallVistA('ORWGRPC FASTDATA', [PatientDFN], allData);
  onoff(0);
  ok := alldata.Count > 0;
end;

procedure rpcFastItems(const PatientDFN: string; allitems: TStrings; var ok: boolean);
begin
  onoff(1);
  CallVistA('ORWGRPC FASTITEM', [PatientDFN]);
  onoff(0);
  MixedCaseList(allItems);
  ok := allitems.Count > 0;
end;

procedure rpcFastLabs(const PatientDFN: string; alllabs: TStrings; var ok: boolean);
begin
  onoff(1);
  CallVistA('ORWGRPC FASTLABS', [PatientDFN], allLabs);
  onoff(0);
  ok := alllabs.Count > 0;
end;

function rpcFastTask(const PatientDFN, oldDFN: string): string;
begin
  onoff(1);
  CallVistA('ORWGRPC FASTTASK', [PatientDFN, oldDFN], Result);
  onoff(0);
end;

function rpcGetAllItems(aDest:TStrings; const PatientDFN: string): Integer;
begin
  Result := getRPCResults('ORWGRPC ALLITEMS', [PatientDFN], aDest, True);
end;

function rpcGetTypes(aDest:TStrings; const PatientDFN: string; subtypes: boolean): Integer;
var
  includesubtypes: string;
begin
  if subtypes then includesubtypes := '1' else includesubtypes := '0';
  Result := getRPCResults('ORWGRPC TYPES', [PatientDFN, includesubtypes], aDest, True);
end;

function rpcGetItems(aDest:TStrings; typeitem: string; const PatientDFN: string): Integer;
begin
  Result := getRPCResults('ORWGRPC ITEMS', [PatientDFN, typeitem], aDest, True);
end;

function rpcClass(aDest: TStrings; itemtype: string): Integer;
begin
  Result := getRPCResults('ORWGRPC CLASS', [itemtype], aDest, True);
end;

function rpcTaxonomy(aDest: TStrings; alltax: boolean; taxonomies: TStrings): Integer;
var
  getall: string;
begin
  Result := getRPCResults('ORWGRPC TAX', [getall, taxonomies], aDest, True);
end;

function rpcGetItemData(aDest: TStrings; itemdata, timestamp: string; const PatientDFN: string): Integer;
begin
  Result := getRPCResults('ORWGRPC ITEMDATA', [itemdata, timestamp, PatientDFN], aDest, True);
end;

function rpcGetGraphDateRange(aDest: TStrings; reportid: string): Integer;
begin
  Result := getRPCResults('ORWGRPC GETDATES', [reportid], aDest, FALSE);
end;

{
function rpcGetGraphSettings: TStrings;
begin
  onoff(1);
  CallV('ORWGRPC GETPREF', [nil]);
  onoff(0);
  Result := RPCBrokerV.Results;
end;
}
function rpcGetGraphSettings(aDest: TStrings): Integer;
begin
  onoff(1);
  CallVistA('ORWGRPC GETPREF', [nil], aDest);
  onoff(0);
  Result := aDest.Count;
end;

procedure rpcSetGraphSettings(paramsetting, permission: string);
begin
  onoff(1);
  CallVistA('ORWGRPC SETPREF', [paramsetting, permission]);
  onoff(0);
end;

function rpcGetGraphSizing(aDest: TStrings): Integer;
begin
  Result := getRPCResults('ORWGRPC GETSIZE', [nil], aDest, FALSE);
end;

procedure rpcSetGraphSizing(values: TStrings);
begin
  onoff(1);
  CallVistA('ORWGRPC SETSIZE', [values]);
  onoff(0);
end;

function rpcGetGraphProfiles(aDest: TStrings; profiles, permission: string; ext: integer; userx: int64): Integer;
var
  b: Boolean;
begin
  b := (profiles = '1') or (ext = 1);
  Result := getRPCResults('ORWGRPC GETVIEWS', [profiles, permission, ext, userx], aDest, b);
end;

procedure rpcSetGraphProfile(paramname, permission: string; paramvalues: TStrings);
begin
  onoff(1);
  CallVistA('ORWGRPC SETVIEWS', [paramname, permission, paramvalues]);
  onoff(0);
end;

procedure rpcDeleteGraphProfile(paramname, permission: string);
begin
  onoff(1);
  CallVistA('ORWGRPC DELVIEWS', [paramname, permission]);
  onoff(0);
end;

function rpcGetTestSpec(aDest: TStrings): Integer;
begin
  Result := getRPCResults('ORWGRPC TESTSPEC', [], aDest, FALSE);
end;

function rpcTesting(aDest: TStrings): Integer;
begin
  Result := getRPCResults('ORWGRPC TESTING', [], aDest, FALSE);
end;

function rpcGetViews(aDest: TStrings; vtype: string; user: int64): Integer;
var
  tmpList: TStringList;

begin
  tmpList := TStringList.Create;
  try
    Result := getRPCResults('ORWGRPC ALLVIEWS', [vtype, user], tmpList, True);
    FastAddStrings(tmpList, aDest);
  finally
    tmpList.Free;
  end;
end;

function rpcLookupItems(aDest: TStrings; const filename, StartFrom: string; Direction: integer): Integer;
begin
  Result := getRPCResults('ORWGRPC LOOKUP', [filename, StartFrom, Direction], aDest, True);
end;

function rpcDateItem(aDest: TStrings; oldestdate, newestdate: double;
  filenum: string; const PatientDFN: string): integer;
begin
  Result := getRpcResults('ORWGRPC DATEITEM', [oldestdate, newestdate, filenum,
    PatientDFN], aDest, True);
end;

procedure onoff(x: integer);
begin
  if x = 1 then
  begin
    //beep;
    //Screen.Cursor := crHourGlass;
  end
  else
  begin
    //sleep(3000);
    //Screen.Cursor := crDefault;
    //sleep(1000);
  end;
end;

end.

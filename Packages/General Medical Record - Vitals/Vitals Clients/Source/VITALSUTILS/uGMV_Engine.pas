unit uGMV_Engine;
{
================================================================================
*
*       Application:  Vitals
*       Revision:     $Revision: 1 $  $Modtime: 5/05/09 1:44p $
*       Developer:    andrey.andriyevskiy@domain
*       Site:         Hines OIFO
*
*       Description:  This unit isolates VistA RPC
*
*       Notes:
*
================================================================================
*       $Archive: /Vitals/5.0 (Version 5.0)/5.0.23 (Patch 23)/VITALS_5_0_23_8/Source/VITALSUTILS/uGMV_Engine.pas $
*
*       $ History: uGMV_Engine.pas $
*
*       2007-07-12,16,17 zzzzzzandria
*               Parameter verification
*               Formatting of the source code
}
interface

uses
{$IFDEF REDIRECTOR}
  uHEVDR_PCall
{$ELSE}
  fROR_PCall
{$ENDIF}
  , Classes
  , SysUtils
  ;
function getStationInfo: string;
function getEXEInfo(anEXEName: string): string;
function getDLLInfo(anEXEName: string): string;
function getALLPatientData(aPatient, aFrom, aTo: string): TStringList;

// Date and Time
function getCurrentDateTime: string; // uGMV_DateTime
function convertMDate(aValue: string): string; // uGMVMDateTime
function getServerWDateTime: TDateTime;
function getServerWDelay: TDateTime;
function getServerWDateTimeString: string;

function getUserParameter: string; // uGMV_User
function getUserSignOnInfo: TStringList;
function getUserSettings(aName: string): string;
function setUserSettings(aName, aValue: string): string;
function getUserDUZString: string;

// System parameters
function getSystemParameterByName(aName: string): string; // fGMV_Manager
function getWebLinkAddress: string;

// Qualifiers
function getVitalQualifierList(aVital: string): TStringList; // fGMV_Qualifiers
function getQualifiers(aVital, aCategory: string): TStringList; // uGMV_QualifyBox
function getCategoryQualifiers(aVital: string): TStringList; // mGMV_EditTemplate

function addQualifier(aVitalID, aCategoryID, aQualifierID: string): string;
function delQualifier(aVitalID, aCategoryID, aQualifierID: string): string;
function addNewQualifier(aName: string): string;

function validateQualifierName(aFDD, aIEN, aField, aName: string): string;
function setQualifierName(aFDD, aIEN, aField, aName: string): string;

//Patients
{$IFNDEF DLL}
function getPatientList(aTarget: string): TStringList;
{$ENDIF}
// Files and Fields
function getFileEntries(aFile: string): TStringList; // uGMV_FileEntry
function getFileField(aFile, aField, anIEN: string): string;

// Vitals
function getVitalsIDList: TStringList;

function getVitalTypeIEN(aVital: string): string; // fGMV_SupO2
function getVitalCategoryIEN(aCategory: string): string;

function getTemplateList: TStringList; // fGMV_InputTemp
function addVM(aValue: string): string;

function getPatientInfo(aPatient: string): TStringList;
function getPatientHeader(aPatient: string): TStringList;
//procedure logPatientAccess(aPatient:String);// fGMV_PtSelect
function logPatientAccess(aPatient: string): string;

function getNursingUnitPatients(aUnit: string): TStringList; // mGMV_PtLookup
function getWardPatients(aWard: string): TStringList;
function getTeamPatients(aTeam: string): TStringList;
function getClinicPatients(aClinic, aDate: string): TStringList;

function getLookupEntries(aFile, aTarget: string): TStringList; // mGMV_Lookup

function newTemplate(aCategory, aName, aValue: string): string;

procedure setTemplate(anID, aName, aValue: string);
function renameTemplate(anID, aName, aNewName: string): string;
function getTemplateValue(anID, aName: string): string;
function setDefaultTemplate(anID, aName: string): string;
function getDefaultTemplateByID(anID: string): string;
function getDefaultTemplateList: TStringList;
function getTemplateListByID(anID: string): TStringList;
function createUserTemplateByName(aName: string): string;
function deleteUserTemplate(aName: string): string;

function deleteTemplate(aCategory, aName: string): string;

function createContext(aContext: string): Boolean; // uGMV_User
function EngineReady: Boolean;

function getLatestVitalsByDFN(aDFN: string; aSilent: Boolean): TStringList;
function getHospitalLocationByID(anID: string): string;
function getWardLocations(anOption: string = ''): TStringList;
function getRoomBedByWard(aWard: string): TStringList;

function getProcedureResult(aProc, aParam: string): string;
function getGMVRecord(aParam: string): TStringList;
function setGMVErrorRecord(aParam: string): TStringList;

function getPatientINQInfo(aINQ, aDFN: string): TStringList; // ?????
function getPatientAllergies(aDFN: string): TStringList;

//// Manager ///////////////////////////////////////////////////////////////////
//
// Manager calls are not used in the DLL
// so we will include them in this module later some time...
//
function printQualifierTable(aX, aY: string): string;
function getGUIVersionList: TStringList;
function setSystemParameter(aName, aValue, anOption: string): string;

function getVitalHiLo(aVitalType: string): string;
function setVitalHiLo(aVitalType, aValue: string): string;

function getDeviceList(aTarget, aMargin: string; Direction: Integer = 1): string;

function getLocationsByName(aTarget: string): string;
function getLocationsByAppt(aDFN, aFrom, aTo, aFlag: string): string;
function getLocationsByAdmit(aDFN: string): string;
//function getClinicsByName(aStartFrom,aCount,aDirection:String):String;
function getClinicFileEntriesByName(aStartFrom, aCount, aDirection: string): TStringList; // zzzzzzandria 060810

function getClosestReading(aDFN, aDate, aType, aDirection: string): String;

var
  ServerDelay: TDateTime;
  CheckBrokerFlag: Boolean;

implementation

uses
  Dialogs,
  uGMV_Common
  , uGMV_Const
  , fGMV_RPCLog
  , uGMV_FileEntry, uGMV_VersionInfo, uGMV_RPC_Names, uGMV_Log
  ;

////////////////////////////////////////////////////////////////////////////////

function CallRPC(RemoteProcedure: string;
  Parameters: array of string; MultList: TStringList = nil;
  RPCMode: TRPCMode = []; RetList: TStrings = nil): Boolean;
var
  anItem: TRPCEventItem;
  aStart, aStop: TDateTime;
  aList: TStrings;
  iLimit: Integer;
  i: integer;
  SL: TStringList;
begin
  aStart := Now;
  Result :=
    CallRemoteProc(RPCBroker, RemoteProcedure, Parameters, MultList, RPCMode, RetList);
  aStop := Now;

  if RetList = nil then aList := RPCBroker.Results
  else aList := RetList;

  anItem := getRPCEventItem(aStart, aStop,
    RemoteProcedure,
    Parameters,
    MultList,
    RPCMode,
    aList
    );

  SL := TStringList.Create;
  for i := Low(parameters) to High(Parameters) do
    SL.Add(Parameters[i]);

  Inc(RPCCount);
  RPCLog.InsertObject(0,
    Format('%10.10d ', [RPCCount]) +
    FormatDateTime('hh:mm:ss.zzz', aStart) + '   ' + RemoteProcedure
    + ' (' + SL.CommaText + ')' // zzzzzzandria 060724
    ,
    anItem);
  SL.Free;

  iLimit := 300;
  if assigned(frmGMV_RPCLog) then
    iLimit := StrToIntDef(frmGMV_RPCLog.ComboBox1.Text, iLimit);

  while RPCLog.Count > iLimit do
  begin
    if RPCLog.Objects[RPCLog.Count - 1] <> nil then
      TRPCEventItem(RPCLog.Objects[RPCLog.Count - 1]).Free;
    RPCLog.Delete(RPCLog.Count - 1);
  end;

  if assigned(frmGMV_RPCLog) then
  begin
    frmGMV_RPCLog.lbLog.Items.Assign(RPCLog);
    frmGMV_RPCLog.lbLog.ItemIndex := 0;
    frmGMV_RPCLog.lbLogClick(nil);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function getRPCResultStringList(aProcedure: string; ParamLST: array of string;
  RPCMode: TRPCMode = []): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aProcedure, ParamLST, nil, RPCMode, SL);
  Result := SL;
end;

function getRPCResultString(aProcedure: string; ParamLST: array of string;
  RPCMode: TRPCMode = []): string;
var
  SL: TStringList;
begin
  try
    SL := getRPCResultStringList(aProcedure, ParamLST, RPCMode);
    Result := SL.Text;
  except
    Result := '-1^Error';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//  The next RPC is used to retrieve Patient information.
//  It is used only once in module fGMV_PtInfo (see line 51).
//  By default aINQ is equal to RPC_PATIENTINFO = 'ORWPT PTINQ';
//  the user settings could overwrite the default value.
////////////////////////////////////////////////////////////////////////////////

function getPatientINQInfo(aINQ, aDFN: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aINQ, [aDFN], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

(*
function getProcedureResultList(aProc,aParam:String):TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(aProc, [aParam], nil,[rpcNoResChk,rpcSilent],SL);
  Result := SL;
end;
*)

function getGMVRecord(aParam: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_GMV_RECORD, [aParam], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

function setGMVErrorRecord(aParam: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_GMV_MARK_ERROR, [aParam], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

//==============================================================================

function getGUIVersionList: TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_PARAMETER, ['GETLST', 'SYS', 'GMV GUI VERSION'], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

function getEXEInfo(anEXEName: string): string;
begin
  CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV GUI VERSION', anExeName], nil);
  Result := RPCBroker.Results[0];
end;

function getDLLInfo(anEXEName: string): string;
begin
  CallRPC(RPC_DLL_VERSION, [anExeName], nil);
  Result := RPCBroker.Results[0];
end;

function getALLPatientData(aPatient, aFrom, aTo: string): TStringList;
var
  i: Integer;
  SL: TStringList;
begin
  SL := TStringList.Create;

  CallRPC(RPC_PATIENT_VITALS_ALL, [aPatient + '^' + aFrom + '^' + aTo + '^0'], nil, []);
  if RPCBroker.Results.Count > 4 then
    for i := RPCBroker.Results.Count - 1 downto 4 do
      SL.Add(RPCBroker.Results[i]);

  Result := SL;
end;

function getCurrentDateTime: string;
begin
  // TEST FOR PARAMETERS
  // Formally the next RPC does not require parameters.
  // But without parameters it generates error in some environments
//  if CallRPC(RPC_CurrentTime, [], nil,[rpcSilent,rpcNoResChk]) then
  if CallRPC(RPC_CurrentTime, ['1'], nil, [rpcSilent, rpcNoResChk]) then // dummy parameter
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function convertMDate(aValue: string): string;
begin
  if CallRPC(RPC_DATE_CONVERT, [aValue], nil, []) and
    (RPCBroker.Results.Count > 0) then
    Result := Piece(RPCBroker.Results[0], '^', 1)
  else
    Result := '';
end;

function getStationInfo: string;
var
  s: string;
begin
  s := '';
  if CallRPC(RPC_PATIENT_SELECT, ['CCOW'], nil, []) then
    s := RPCBroker.Results[0];
  Result := s;
end;

function getPatientList(aTarget: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_PATIENT_SELECT, ['PTLKUP', '', aTarget], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

function logPatientAccess(aPatient: string): string;
begin
  Result := '';
// 060929 zzzzzzandria LOGSECURITY or LOGSEC ?
//  CallRPC(RPC_PATIENT_SELECT, ['LOGSEC', aPatient, 'RPCCALL^Clinical Procedure GUI v1'],
  CallRPC(RPC_PATIENT_SELECT,
    ['LOGSEC', aPatient, RPC_CREATECONTEXT + '^' + CurrentExeNameAndVersion],
    nil, [rpcSilent, rpcNoResChk]);
// 2008-03-10 zzzzzzandria LOGSECURITY was used before fix
//  CallRPC(RPC_PATIENT_SELECT, ['LOGSECURITY', aPatient, 'RPCCALL^Clinical Procedure GUI v1'],
//    nil, [rpcSilent, rpcNoResChk]);
  Result := RPCBroker.Results[0]
end;

function getPatientInfo(aPatient: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_PATIENT_SELECT, ['SELECT', aPatient], nil, [rpcSilent, rpcNoresChk], SL);
  Result := SL;
end;

function getPatientHeader(aPatient: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_PATIENT_SELECT, ['PTHDR', aPatient], nil, [rpcSilent, rpcNoresChk], SL);
  Result := SL;
end;

function getServerWDateTime: TDateTime;
begin
  try
    Result := FMDateTimeToWindowsDateTime(StrToFloat(getCurrentDateTime));
  except
    on E: Exception do
      Result := 0;
  end;
end;

function getServerWDateTimeString: string;
begin
  try
    Result := FormatDateTime(GMV_DateTimeFormat, FMDateTimeToWindowsDateTime(StrToFloat(getCurrentDateTime)));
  except
    on E: Exception do
      Result := '';
  end;
end;

function getServerWDelay: TDateTime;
begin
  Result := getServerWDateTime - Now;
end;
////////////////////////////////////////////////////////////////////////////////
// System Parameters
////////////////////////////////////////////////////////////////////////////////

function getSystemParameterByName(aName: string): string; // fGMV_Manager
begin
  if CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', aName], nil, [rpcSilent, rpcNoResChk]) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getWebLinkAddress: string;
begin
  Result := getSystemParameterByName('GMV WEBLINK');
end;

function setSystemParameter(aName, aValue, anOption: string): string;
begin
  CallRPC(RPC_PARAMETER, ['SETPAR', 'SYS', aName, aValue, anOption], nil, []);
  Result := RPCBroker.Results[0];
end;

function getUserParameter: string; // uGMV_User
begin
  if CallRPC(RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV ALLOW USER TEMPLATES'], nil, [], nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getUserSignOnInfo: TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_USER, ['SIGNON', ''], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

function getUserDUZString: string;
var
  SL: TStringList;
begin
  SL := getUserSignOnInfo;
  if SL.Count > 0 then
    Result := SL[0]
  else
    Result := '';
  SL.Free;
end;

function getUserSettings(aName: string): string;
begin
(*

  ..  ABNORMALBGCOLOR            15
    ABNORMALBOLD               OFF
    ABNORMALQUALIFIERS         OFF
    ABNORMALTEXTCOLOR          9
    CLINIC_INDEX               -1
    CPRSMetricStyle            VitalsMetricStyle
    CloseInputWindowAfterSave  DoNotCloseInputWindow
    ConversionWarningStatus    ON
    DefaultTemplate            114;DIC(4.2,|WARD
    GRAPH OPTIONS VISIBLE      1
    GRAPHCOLOR                 -2147483643
    GRAPHOPTIONS               ON
    GRAPHOPTIONS-1             OFF
    GRAPHOPTIONS-2             OFF
    GRAPHOPTIONS-3             ON
    GRAPHOPTIONS-4             ON
    GRAPH_INDEX                8
    GRIDSIZE                   314
    GridDateRange              15
    LastVitalsListHeight       144
    NORMALBGCOLOR              15
    NORMALBOLD                 OFF
    NORMALQUALIFIERS           OFF
    NORMALTEXTCOLOR            0
    OneUnavailableBox          ManyUnavailableBoxes
    ParamTreeWidth             165
    RefuseStatus               ON
    SELECTOR_TAB               4
    SearchDelay                1.0
    ShowLastVitals             NoLatestVitals
    ShowTemplates              NoTemplates
    TEAM_INDEX                 -1
    TfrmGMV_InputLite          1024;768;360;0;640;480;0
    UNIT_INDEX                 -1
    UnavailableStatus          ON
    VIEW-HEIGHT                519
    VIEW-LEFT                  363
    VIEW-TOP                   7
    VIEW-WIDTH                 640
    VitalsLite                 1024;768;361;34;640;480;0
    WARD_INDEX                 -1
*)

  try
    if CallRPC(RPC_USER, ['GETPAR', aName], nil, [rpcSilent, rpcNoResChk]) then
      Result := RPCBroker.Results[0]
    else
      Result := '';
  except
    on E: Exception do
      Result := '';
  end;
end;

function setUserSettings(aName, aValue: string): string;
begin
  if CallRPC(RPC_USER, ['SETPAR', aName + '^' + aValue], nil, [rpcSilent, rpcNoResChk]) then
    Result := RPCBroker.Results[0]
  else
    Result := '-1^Unknown Error';
end;

function getVitalQualifierList(aVital: string): TStringList;
var
  SL: TStringList;
begin
  // ?
  SL := TStringList.Create;
  CallRPC(RPC_VITALS_QUALIFIERS, [aVital], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL
end;

function getQualifiers(aVital, aCategory: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETQUAL', aVital + ';' + aCategory], nil, [], SL);
  Result := SL;
end;

function getCategoryQualifiers(aVital: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETCATS', aVital], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

function getFileEntries(aFile: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETLIST', aFile], nil, [], SL);
  Result := SL;
end;

function getFileField(aFile, aField, anIEN: string): string;
begin
  if CallRPC(RPC_MANAGER, ['GETDATA', aFile + '^' + anIEN + '^' + aField], nil, [rpcSilent, rpcNoResChk], nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getLookupEntries(aFile, aTarget: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['LOOKUP', aFile + '^' + aTarget], nil, [rpcSilent, rpcNoResChk], SL);
  Result := SL;
end;

function getVitalsIDList: TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['VT', ''], nil, [rpcNoResChk], SL);
  Result := SL;
end;


function getVitalTypeIEN(aVital: string): string;
begin
 // ?
  if CallRPC(RPC_VITAL_TYPE_IEN, [aVital], nil, [rpcSilent, rpcNoResChk], nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;

function getVitalCategoryIEN(aCategory: string): string;
begin
  if CallRPC(RPC_VITAL_CATEGORY_IEN, [aCategory], nil, [], nil) then
    Result := RPCBroker.Results[0]
  else
    Result := '';
end;


function getTemplateList: TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETTEMP'], nil, [rpcSilent, rpcNoresChk], SL);
  Result := SL;
end;

function addVM(aValue: string): string;
begin
  if CallRPC(RPC_VITAL_ADD_VALUE, [aValue], nil, [rpcSilent, rpcNoresChk]) then
    Result := ''
  else
    Result := RPCBroker.Results.Text;
end;

function getNursingUnitPatients(aUnit: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_NUR_UNIT_PATIENTS, [aUnit], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

function getWardPatients(aWard: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_WARD_PATIENTS, [aWard], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

function getTeamPatients(aTeam: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_TEAM_PATIENTS, [aTeam], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

function getClinicPatients(aClinic, aDate: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_CLINIC_PATIENTS, [aClinic, aDate], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

//==============================================================================

function newTemplate(aCategory, aName, aValue: string): string;
begin
  CallRPC(RPC_MANAGER, ['NEWTEMP', aCategory + '^' + aName + '^' + aValue], nil, []);
  Result := RPCBroker.Results[0]
end;

procedure setTemplate(anID, aName, aValue: string);
begin
  CallRPC(RPC_MANAGER, ['SETTEMP', anID + '^' + aName + '^' + aValue], nil, []);
end;

function renameTemplate(anID, aName, aNewName: string): string;
begin
  CallRPC(RPC_MANAGER, ['RENTEMP', anID + '^' + aName + '^' + aNewname], nil, [rpcNoResChk, rpcSilent]); //zzzzzzandria 051229
  Result := RPCBroker.Results[0];
end;

function getTemplateValue(anID, aName: string): string;
begin
  try
    if CallRPC(RPC_MANAGER, ['GETTEMP', anID + '^' + aName], nil, []) then
      Result := RPCBroker.Results[1]
    else
      Result := '';
  except
    Result := '';
  end;
end;

function setDefaultTemplate(anID, aName: string): string;
begin
  if CallRPC(RPC_MANAGER, ['SETDEF', anID + '^' + aName], nil, []) then
    Result := RPCBroker.Results[0]
  else
    Result := '-1';
end;

function getDefaultTemplateByID(anID: string): string;
begin
  try
    if CallRPC(RPC_MANAGER, ['GETDEF', anID], nil, []) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1';
  except
    Result := '-1';
  end;
end;

function getDefaultTemplateList: TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_MANAGER, ['GETDEF'], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL;
end;

function getTemplateListByID(anID: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  if anID <> '' then
    CallRPC(RPC_MANAGER, ['GETTEMP', anID], nil, [], SL)
  else
    CallRPC(RPC_MANAGER, ['GETTEMP'], nil, [], SL);
  Result := SL;
end;

function createUserTemplateByName(aName: string): string;
begin
  try
    if CallRPC(RPC_MANAGER, ['NEWTEMP', 'USR^' + aName + '^No Description'], nil, [rpcNoResChk]) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1';
  except
    Result := '-1';
  end;
end;

function deleteTemplate(aCategory, aName: string): string;
begin
  try
    if CallRPC(RPC_MANAGER, ['DELTEMP', aCategory + '^' + aName], nil, []) then
      Result := RPCBroker.Results[0]
    else
      Result := '-1^Unknown Error';
  except
    Result := '-1^Unknown Error';
  end;
end;

function deleteUserTemplate(aName: string): string;
begin
  Result := deleteTemplate('USR', aName);
end;

////////////////////////////////////////////////////////////////////////////////

function createContext(aContext: string): Boolean;
begin
  Result := RPCBroker.CreateContext(aContext);
end;

function EngineReady: Boolean;
begin
  Result := Assigned(RPCBroker);
end;

function getLatestVitalsByDFN(aDFN: string; aSilent: Boolean): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    if aSilent then
      CallRPC(RPC_PATIENT_LATEST_VITALS, [aDFN], nil, [rpcNoResChk, rpcSilent], SL)
    else
      CallRPC(RPC_PATIENT_LATEST_VITALS, [aDFN], nil, [], SL);
  except
  end;
  Result := SL;
end;

function getHospitalLocationByID(anID: string): string;
begin
// zzzzzzandria 2007-07-17 ----------------------------------------------- Begin
  Result := '';
  if trim(anID) = '' then
    Exit;
// zzzzzzandria 2007-07-17 -----------------------------------------------   End
  try
    if CallRPC(RPC_PATIENT_SELECT, ['HOSPLOC', anID], nil, [rpcNoResChk, rpcSilent]) then
      Result := RPCBroker.Results[0]
    else
      Result := '';
  except
    Result := '';
  end;
end;

function getWardLocations(anOption: string = ''): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_WARD_LOCATION, [anOption], nil, [], SL);
  Result := SL;
end;

function getRoomBedByWard(aWard: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_ROOM_BED, [aWard], nil, [], SL);
  Result := SL;
end;

function getProcedureResult(aProc, aParam: string): string;
begin
  try
    if CallRPC(aProc, [aParam], nil, [rpcNoResChk, rpcSilent]) then
      Result := RPCBroker.Results[0]
    else
      Result := 'Procedure ' + aProc + '(' + aParam + ') Failed';
  except
    Result := 'Procedure ' + aProc + '(' + aParam + ') Failed';
  end;
end;

function getPatientAllergies(aDFN: string): TStringList;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_PATIENT_ALLERGIES, [aDFN], nil, [], SL);
  Result := SL;
end;

////////////////////////////////////////////////////////////////////////////////

function printQualifierTable(aX, aY: string): string;
begin
  CallRPC(RPC_QUALIFIER_TABLE, ['^^^^' + aX + '^^' + aY], nil);
  Result := RPCBroker.Results[0]
end;


function addQualifier(aVitalID, aCategoryID, aQualifierID: string): string;
begin
  CallRPC(RPC_MANAGER, ['ADDQUAL', aVitalID + ';' + aCategoryID + ';' + aQualifierID], nil);
  Result := RPCBroker.Results[0]
end;

function delQualifier(aVitalID, aCategoryID, aQualifierID: string): string;
begin
  CallRPC(RPC_MANAGER, ['DELQUAL', aVitalID + ';' + aCategoryID + ';' + aQualifierID], nil);
  Result := RPCBroker.Results[0]
end;

function AddNewQualifier(aName: string): string;
begin
  CallRPC(RPC_MANAGER, ['NEWQUAL', aName], nil);
  Result := RPCBroker.Results[0]
end;

function validateQualifierName(aFDD, aIEN, aField, aName: string): string;
begin
  CallRPC(RPC_MANAGER, ['VALID', aFDD + '^' + aIEN + '^' + aField + '^' + aName], nil, []);
  Result := RPCBroker.Results[0];
end;

function setQualifierName(aFDD, aIEN, aField, aName: string): string;
begin
  CallRPC(RPC_MANAGER, ['SETDATA', aFDD + '^' + aIEN + '^' + aField + '^' + aName], nil, []);
  Result := RPCBroker.Results[0];
end;

function getVitalHiLo(aVitalType: string): string;
begin
  if aVitalType = '6.2' then // 6.2 - min CVP value could be below 0
    CallRPC(RPC_MANAGER, ['GETHILO', aVitalType], nil, [rpcSilent])
  else
    CallRPC(RPC_MANAGER, ['GETHILO', aVitalType], nil, []);
  Result := RPCBroker.Results[0];
end;

function setVitalHiLo(aVitalType, aValue: string): string;
begin
  CallRPC(RPC_MANAGER, ['SETHILO', aVitalType + '^' + aValue], nil, []);
  Result := RPCBroker.Results[0];
end;

function getDeviceList(aTarget, aMargin: string; Direction: Integer = 1): string;
begin
  CallRPC(RPC_CHECK_DEVICE, [aTarget, IntToStr(Direction), aMargin], nil, [rpcNoResChk, rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getLocationsByName(aTarget: string): string;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  CallRPC(RPC_LOCATION_SELECT, ['NAME', aTarget], nil, [rpcNoResChk, rpcSilent], SL);
  Result := SL.Text;
  SL.Free;
end;

function getLocationsByAppt(aDFN, aFrom, aTo, aFlag: string): string;
begin
// zzzzzzandria 2007-07-16 ----------------------------------------------- Begin
  Result := '';
  if trim(aDFN) = '' then
    Exit;
// zzzzzzandria 2007-07-16 -----------------------------------------------   End
  CallRPC(RPC_LOCATION_SELECT, ['APPT', aDFN + '^' + aFrom + '^' + aTo + '^' + aFlag], nil, [rpcNoResChk, rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getLocationsByAdmit(aDFN: string): string;
begin
  Result := '';
  if trim(aDFN) = '' then
    Exit;
  CallRPC(RPC_LOCATION_SELECT, ['ADMIT', aDFN], nil, [rpcNoResChk, rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getClinicsByName(aStartFrom, aCount, aDirection: string): string;
begin
  CallRPC(RPC_LOCATION_SELECT, ['CLINIC', aStartFrom + '^' + aCount + '^' + aDirection], nil, [rpcNoResChk, rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

function getClinicFileEntriesByName(aStartFrom, aCount, aDirection: string): TStringList;
var
  SL: TStringList;
  i: Integer;
  fe: TGMV_FileEntry;
begin
  CallRPC(RPC_LOCATION_SELECT, ['CLINIC', aStartFrom + '^' + aCount + '^' + aDirection], nil, [rpcNoResChk, rpcSilent]);
  if copy(RPCBroker.Results.Text, 1, 1) = '-' then
  begin
    Result := nil;
    Exit;
  end;
  SL := TStringList.Create;
  for i := 1 to RPCBroker.Results.Count - 1 do
  begin
    fe := TGMV_FileEntry.CreateFromRPC(RPCBroker.Results[i]);
//    SL.AddObject(fe.CaptionConverted, fe); // zzzzzzandria 2008-04-17
    SL.AddObject(fe.Caption, fe);
  end;

  Result := SL;
end;

function getClosestReading(aDFN, aDate, aType, aDirection: string): String;
begin
  Result := '';
  if trim(aDFN) = '' then
    Exit;
  CallRPC(RPC_CLOSEST_READING, [aDFN, aDate,aType,aDirection], nil, [rpcNoResChk, rpcSilent]);
  Result := RPCBroker.Results.Text;
end;

initialization
  CheckBrokerFlag := False;
end.


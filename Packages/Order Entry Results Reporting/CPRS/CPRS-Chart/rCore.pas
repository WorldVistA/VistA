unit rCore;
{ ------------------------------------------------------------------------------
  Update History

  2016-02-15: NSR#20081008 (CPRS Notification Alert Processing Improvement)
  2016-02-26: NSR#20110606 (Confirm Provider Similar Names)
  2018-08-13: RTC#272867 (Replacement of CallV,sCallV, tCallV with CallVistA)
  ------------------------------------------------------------------------------- }

interface

uses
  SysUtils,
  Classes,
  Forms,
  ORNet,
  ORFn,
  ORClasses,
  system.JSON,
  ORCtrls,
  UORJSONParameters;

{ record types used to return data from the RPC's.  Generally, the delimited strings returned
  by the RPC are mapped into the records defined below. }

const
  UC_UNKNOWN = 0; // user class unknown
  UC_CLERK = 1; // user class clerk
  UC_NURSE = 2; // user class nurse
  UC_PHYSICIAN = 3; // user class physician

type
  TUserInfo = record // record for ORWU USERINFO
    DUZ: Int64;
    Name: string;
    UserClass: Integer;
    CanSignOrders: Boolean;
    IsProvider: Boolean;
    OrderRole: Integer;
    NoOrdering: Boolean;
    DTIME: Integer;
    CountDown: Integer;
    EnableVerify: Boolean;
    NotifyAppsWM: Boolean;
    PtMsgHang: Integer;
    Domain: string;
    Service: Integer;
    AutoSave: Integer;
    InitialTab: Integer;
    UseLastTab: Boolean;
    EnableActOneStep: Boolean;
    WebAccess: Boolean;
    IsRPL: string;
    RPLList: string;
    HasCorTabs: Boolean;
    HasRptTab: Boolean;
    IsReportsOnly: Boolean;
    ToolsRptEdit: Boolean;
    DisableHold: Boolean;
    GECStatusCheck: Boolean;
    StationNumber: string;
    IsProductionAccount: Boolean;
    JobNumber: string;
    EvaluateRemCoverSheetOnDialogFinish: BOOLEAN;
  end;

  TPtIDInfo = record // record for ORWPT IDINFO
    Name: string;
    SSN: string;
    DOB: string;
    Age: string;
    Sex: string;
    SCSts: string;
    Vet: string;
    Location: string;
    RoomBed: string;
    SIGI: string; // NSR#20130305
    Attending: string;
    PrimaryCareProvider: string;      // NSR 20131005 SDS July 2017
    PrimaryInpatientProvider: string; // NSR 20131005 SDS July 2017
    LastVisitLocation: string;        // NSR 20131005 SDS July 2017
    LastVisitDate: string;            // NSR 20131005 SDS July 2017
  end;

  TPtSelect = record // record for ORWPT SELECT
    Name: string;
    ICN: string;
    FullICN: string;                              //added via ORWPT GET FULL ICN
    SSN: string;
    DOB: TFMDateTime;
    Age: Integer;
    Sex: Char;
    LocationIEN: Integer;
    Location: string;
    WardService: string;
    RoomBed: string;
    SpecialtyIEN: Integer;
    SpecialtySvc: string;
    CWAD: string;
    Restricted: Boolean;
    AdmitTime: TFMDateTime;
    ServiceConnected: Boolean;
    SCPercent: Integer;
    PrimaryTeam: string;
    PrimaryProvider: string;
    MHTC: string;
    Attending: string;
    Associate: string;
    InProvider: string;
    SIGI: String; // NSR#20130305
    Pronoun: string;
  end;

  TEncounterText = record // record for ORWPT ENCTITL
    LocationName: string;
    LocationAbbr: string;
    RoomBed: string;
    ProviderName: string;
  end;

  { Date/Time functions - right now these make server calls to use server time }

function FMToday: TFMDateTime;
function FMNow: TFMDateTime;
function MakeRelativeDateTime(FMDateTime: TFMDateTime): string;
function StrToFMDateTime(const AString: string): TFMDateTime;
function ValidDateTimeStr(const AString, Flags: string): TFMDateTime;
procedure ListDateRangeClinic(Dest: TStrings);
function IsDateMoreRecent(Date1: TDateTime; Date2: TDateTime): Boolean;

{ General calls }

function ExternalName(IEN: Int64; FileNumber: Double): string; overload;
function ExternalName(IEN: string; FileNumber: Double): string; overload;
function PersonHasKey(APerson: Int64; const AKey: string): Boolean;
function GlobalRefForFile(const FileID: string): string;
// function SubsetOfGeneric(const StartFrom: string; Direction: Integer; const GlobalRef: string): TStrings;

function setSubsetOfDevices(var aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function setSubSetOfPersons(AORComboBox: TORComboBox; var aDest: TStrings;
  const StartFrom: string; Direction: Integer; ExcludeClass: Boolean = False): Integer;

function setSubSetOfActiveAndInactivePersons(AORComboBox: TORComboBox;
  var aDest: TStrings; const StartFrom: string; Direction: Integer): Integer;

function SubsetOfPatientsWithSimilarSSNs(aDest:TStrings; aDFN: String): Integer;
function GetDefaultPrinter(DUZ: Int64; Location: Integer): string;
function CreateSysUserParameters(DUZ: Int64): TORJSONParameters;

{ User specific calls }

function GetUserInfo: TUserInfo;
function GetUserParam(const AParamName: string): string;
procedure GetUserListParam(Dest: TStrings; const AParamName: string);
function HasSecurityKey(const KeyName: string): Boolean;
function HasMenuOptionAccess(const OptionName: string): Boolean;
function ValidESCode(const ACode: string): Boolean;
//function otherInformationPanelControls: string;

{ Notifications calls }

procedure LoadNotifications(Dest: TStrings);
procedure LoadProcessedNotifications(var Dest: TStrings;
  DateFrom, DateTo, MaxNumber, ProcessedOnly: String);
function LoadNotificationLongText(AlertID: string): string;
function IsSmartAlert(notIEN: Integer): Boolean;
procedure DeleteAlert(XQAID: string);
procedure DeleteAlertForUser(XQAID: string);
function GetXQAData(XQAID: string;  pFlag: string = ''): string;
function GetTIUAlertInfo(XQAID: string): string;
procedure UpdateUnsignedOrderAlerts(PatientDFN: string);
function UnsignedOrderAlertFollowup(XQAID: string): string;
procedure UpdateExpiringMedAlerts(PatientDFN: string);
procedure UpdateExpiringFlaggedOIAlerts(PatientDFN: string; FollowUp: Integer);
procedure AutoUnflagAlertedOrders(PatientDFN, XQAID: string);
procedure UpdateUnverifiedMedAlerts(PatientDFN: string);
procedure UpdateUnverifiedOrderAlerts(PatientDFN: string);

function setNotificationFollowUpText(aDest: TStrings; PatientDFN: string;
  Notification: Integer; XQADATA: string): Integer;

procedure ForwardAlert(XQAID: string; Recip: string; FWDtype: string;
  Comment: string);
procedure RenewAlert(XQAID: string);
function GetSortMethod: string;
procedure SetSortMethod(Sort: string; Direction: string);
procedure UpdateIndOrderAlerts();

{ Patient List calls }

function DfltPtList: string;
function DfltPtListSrc: Char;
function DefltPtListSrc: string;
procedure SavePtListDflt(const x: string);
procedure ListSpecialtyAll(Dest: TStrings);
procedure ListTeamAll(Dest: TStrings);
procedure ListPcmmAll(Dest: TStrings);
procedure ListWardAll(Dest: TStrings);

function setSubSetOfProviders(aComponent: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer): Integer;

function setSubSetOfCosigners(AORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer; Date: TFMDateTime;
  ATitle: Integer; ADocType: Integer): Integer;

procedure ListClinicTop(Dest: TStrings);

function setSubSetOfClinics(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function GetDfltSort: string;
procedure ResetDfltSort;
procedure ListPtByDflt(Dest: TStrings);
procedure ListPtByProvider(Dest: TStrings; ProviderIEN: Int64);
procedure ListPtByTeam(Dest: TStrings; TeamIEN: Integer);
procedure ListPtByPcmmTeam(Dest: TStrings; TeamIEN: Integer);
procedure ListPtBySpecialty(Dest: TStrings; SpecialtyIEN: Integer);
procedure ListPtByClinic(Dest: TStrings; ClinicIEN: Integer;
  FirstDt, LastDt: string);
procedure ListPtByWard(Dest: TStrings; WardIEN: Integer);
procedure ListPtByLast5(Dest: TStrings; const Last5: string);
procedure ListPtByRPLLast5(Dest: TStrings; const Last5: string);
procedure ListPtByFullSSN(Dest: TStrings; const FullSSN: string);
procedure ListPtByRPLFullSSN(Dest: TStrings; const FullSSN: string);
procedure ListPtTop(Dest: TStrings);

function setSubSetOfPatients(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function DfltDateRangeClinic: string;
function MakeRPLPtList(RPLList: string): string;

function setRPLPtList(aDest: TStrings; RPLJobNumber: string;
  const StartFrom: string; Direction: Integer): Integer;
procedure KillRPLPtList(RPLJobNumber: string);

{ Patient specific calls }

function CalcAge(BirthDate, DeathDate: TFMDateTime): Integer;
procedure CheckSensitiveRecordAccess(const DFN: string;
  var AccessStatus: Integer; var MessageText: string);
procedure CheckRemotePatient(var Dest: string; Patient, ASite: string;
  var AccessStatus: Integer);
procedure CurrentLocationForPatient(const DFN: string; var ALocation: Integer;
  var AName: string; var ASvc: string);
function DateOfDeath(const DFN: string): TFMDateTime;
function GetPtIDInfo(const DFN: string): TPtIDInfo;
function HasLegacyData(const DFN: string; var AMsg: string): Boolean;
function LogSensitiveRecordAccess(const DFN: string): Boolean;
function MeansTestRequired(const DFN: string; var AMsg: string): Boolean;
function RestrictedPtRec(const DFN: string): Boolean;
procedure SelectPatient(const DFN: string; var PtSelect: TPtSelect);
function SimilarRecordsFound(const DFN: string; var AMsg: string): Boolean;
function GetDFNFromICN(AnICN: string): string;
function GetVAAData(const DFN: string; aList: TStrings): Boolean;
function GetMHVData(const DFN: string; aList: TStrings): Boolean;
function otherInformationPanel(const DFN: string): string;
procedure otherInformationPanelDetails(const DFN: string; valueType: string; var details: TStrings);

{ Encounter specific calls }

function GetEncounterText(const DFN: string; Location: Integer; Provider: Int64)
  : TEncounterText; // *DFN*
function GetActiveICDVersion(ADate: TFMDateTime = 0): String;
function GetICD10ImplementationDate: TFMDateTime;
procedure ListApptAll(Dest: TStrings; const DFN: string; From: TFMDateTime = 0;
  Thru: TFMDateTime = 0);
procedure ListAdmitAll(Dest: TStrings; const DFN: string);

function setSubSetOfLocations(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function setSubSetOfNewLocs(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function setSubSetOfInpatientLocations(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;

function setSubSetOfUsersWithClass(AORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer; DateTime: string): Integer;

{ Remote Data Access calls }
function HasRemoteData(const DFN: string; var ALocations: TStringList): Boolean;
function CheckHL7TCPLink: Boolean;
function GetVistaWebAddress(value: string): string;
function GetVistaWeb_JLV_LabelName: string;

implementation

uses
  XWBHash,
  uCore,
  ShlObj,
  Windows,
  VAUtils,
  uSimilarNames;

var
  uPtListDfltSort: string = '';
  // Current user's patient selection list default sort order.

  { private calls }

function FormatSSN(const x: string): string;
{ places the dashes in a social security number }
begin
  if Length(x) > 8 then
    Result := Copy(x, 1, 3) + '-' + Copy(x, 4, 2) + '-' + Copy(x, 6, Length(x))
  else
    Result := x;
end;

function IsSSN(const x: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (Length(x) < 9) or (Length(x) > 10) then
    Exit;
  for i := 1 to 9 do
    if not CharInSet(x[i], ['0' .. '9']) then
      Exit;
  Result := True;
end;

function IsFMDate(const x: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Length(x) <> 7 then
    Exit;
  for i := 1 to 7 do
    if not CharInSet(x[i], ['0' .. '9']) then
      Exit;
  Result := True;
end;

{ Date/Time functions - not in ORFn because they make server calls to use server time }

function FMToday: TFMDateTime;
{ return the current date in Fileman format }
begin
  Result := Int(FMNow);
end;

function FMNow: TFMDateTime;
{ return the current date/time in Fileman format }
//var
//  x: string;
begin
  Result := GetFMNow;
//  CallVistA('ORWU DT', ['NOW'], x);
//  Result := StrToFloatDef(x, 0.0);
end;

function MakeRelativeDateTime(FMDateTime: TFMDateTime): string;
var
  Offset: Integer;
  h, n, s, l: Word;
  ADateTime: TDateTime;
  ATime: string;
begin
  Result := '';
  if FMDateTime <= 0 then
    Exit;
  ADateTime := FMDateTimeToDateTime(FMDateTime);
  Offset := Trunc(Int(ADateTime) - Int(FMDateTimeToDateTime(FMToday)));
  if Offset < 0 then
    Result := 'T' + IntToStr(Offset)
  else if Offset = 0 then
    Result := 'T'
  else
    Result := 'T+' + IntToStr(Offset);
  DecodeTime(ADateTime, h, n, s, l);
  ATime := Format('@%.2d:%.2d', [h, n]);
  if ATime <> '@00:00' then
    Result := Result + ATime;
end;

function StrToFMDateTime(const AString: string): TFMDateTime;
{ use %DT the validate and convert a string to Fileman format (accepts T, T-1, NOW, etc.) }
//var
//  x: string;
begin
  Result := GetFMDT(aString);
//  CallVistA('ORWU DT', [AString], x);
//  Result := StrToFloat(x);
end;

function ValidDateTimeStr(const AString, Flags: string): TFMDateTime;
{ use %DT to validate & convert a string to Fileman format, accepts %DT flags }
var
  x: string;
begin
  CallVistA('ORWU VALDT', [AString, Flags], x);
  Result := StrToFloatDef(x, -1);
end;

procedure ListDateRangeClinic(Dest: TStrings);
{ returns date ranges for displaying clinic appointments in patient lookup }
begin
  CallVistA('ORWPT CLINRNG', [nil], Dest);
end;

function IsDateMoreRecent(Date1: TDateTime; Date2: TDateTime): Boolean;
{ is Date1 more recent than Date2 }
begin
  if Date1 > Date2 then
    Result := True
  else
    Result := False;
end;

function DfltDateRangeClinic;
{ returns current default date range settings for displaying clinic appointments in patient lookup }
begin
  CallVistA('ORQPT DEFAULT CLINIC DATE RANG', [nil], Result);
end;

{ General calls }

function ExternalName(IEN: Int64; FileNumber: Double): string;
{ returns the external name of the IEN within a file }
begin
  if not CallVistA('ORWU EXTNAME', [IEN, FileNumber], Result) then
    Result := IntToStr(IEN);
end;

function ExternalName(IEN: String; FileNumber: Double): string;
{ returns the external name of the IEN within a file }

begin
//  Result := sCallV('ORWU EXTNAME', [IEN, FileNumber]);
  CallVistA('ORWU EXTNAME', [IEN, FileNumber], Result);
end;

function PersonHasKey(APerson: Int64; const AKey: string): Boolean;
var
  x: String;
begin
  Result := CallVistA('ORWU NPHASKEY', [APerson, AKey], x) and (x = '1');
end;

function GlobalRefForFile(const FileID: string): string;
begin
  CallVistA('ORWU GBLREF', [FileID], Result);
end;

{ RTC 272867
  function SubsetOfGeneric(const StartFrom: string; Direction: Integer; const GlobalRef: string): TStrings;
  begin
    CallV('ORWU GENERIC', [StartFrom, Direction, GlobalRef]);
    Result := RPCBrokerV.Results;
  end;
}
function setSubsetOfDevices(var aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ returns a pointer to a list of devices (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORWU DEVICE', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

function setSubSetOfPersons(AORComboBox: TORComboBox; var aDest: TStrings;
  const StartFrom: string; Direction: Integer; ExcludeClass: Boolean = False): Integer;
begin
  SNCallVistA(AORComboBox, SN_ORWU_NEWPERS,
    [StartFrom, Direction,'','','','','','',ExcludeClass], aDest);
  Result := aDest.Count;
end;

function GetUserInfo: TUserInfo;
{ returns a record of user information,
  Pieces: DUZ^NAME^USRCLS^CANSIGN^ISPROVIDER^ORDERROLE^NOORDER^DTIME^CNTDN^VERORD^NOTIFYAPPS^
  MSGHANG^DOMAIN^SERVICE^AUTOSAVE^INITTAB^LASTTAB^WEBACCESS^ALLOWHOLD^ISRPL^RPLLIST^
  CORTABS^RPTTAB^STATION#^GECStatus^Production account? }
var
  x: string;
begin
  CallVistA('ORWU USERINFO', [nil], x);
  with Result do
  begin
    DUZ := StrToInt64Def(Piece(x, U, 1), 0);
    Name := Piece(x, U, 2);
    UserClass := StrToIntDef(Piece(x, U, 3), 0);
    CanSignOrders := Piece(x, U, 4) = '1';
    IsProvider := Piece(x, U, 5) = '1';
    OrderRole := StrToIntDef(Piece(x, U, 6), 0);
    NoOrdering := Piece(x, U, 7) = '1';
    DTIME := StrToIntDef(Piece(x, U, 8), 300);
    CountDown := StrToIntDef(Piece(x, U, 9), 10);
    EnableVerify := Piece(x, U, 10) = '1';
    EnableActOneStep := Piece(x, U, 27) = '0';
    NotifyAppsWM := Piece(x, U, 11) = '1';
    PtMsgHang := StrToIntDef(Piece(x, U, 12), 5);
    Domain := Piece(x, U, 13);
    Service := StrToIntDef(Piece(x, U, 14), 0);
    AutoSave := StrToIntDef(Piece(x, U, 15), 180);
    InitialTab := StrToIntDef(Piece(x, U, 16), 1);
    UseLastTab := Piece(x, U, 17) = '1';
    WebAccess := Piece(x, U, 18) <> '1';
    DisableHold := Piece(x, U, 19) = '1';
    IsRPL := Piece(x, U, 20);
    RPLList := Piece(x, U, 21);
    HasCorTabs := Piece(x, U, 22) = '1';
    HasRptTab := Piece(x, U, 23) = '1';
    StationNumber := Piece(x, U, 24);
    GECStatusCheck := Piece(x, U, 25) = '1';
    IsProductionAccount := Piece(x, U, 26) = '1';
    IsReportsOnly := False;
    if ((HasRptTab) and (not HasCorTabs)) then
      IsReportsOnly := True;
    // Remove next if and nested if should an "override" later be provided for RPL users,etc.:
    if HasCorTabs then
      if (IsRPL = '1') then
      begin
        IsRPL := '0'; // Hard set for now.
        IsReportsOnly := False;
      end;
    // Following hard set to TRUE per VHA mgt decision:
    ToolsRptEdit := True;
    // x := GetUserParam('ORWT TOOLS RPT SETTINGS OFF');
    // if x = '1' then
    // ToolsRptEdit := false;
    JobNumber := Piece(x, U, 28);
  end;
end;

function GetUserParam(const AParamName: string): string;
begin
  CallVistA('ORWU PARAM', [AParamName], Result);
end;

procedure GetUserListParam(Dest: TStrings; const AParamName: string);
begin
  CallVistA('ORWU PARAMS', [AParamName], Dest);
end;

function HasSecurityKey(const KeyName: string): Boolean;
{ returns true if the currently logged in user has a given security key }
var
  x: string;
begin
  Result := CallVistA('ORWU HASKEY', [KeyName], x) and (x = '1');
end;

function HasMenuOptionAccess(const OptionName: string): Boolean;
var
  x: string;
begin
  Result := CallVistA('ORWU HAS OPTION ACCESS', [OptionName], x) and (x = '1');
end;

function ValidESCode(const ACode: string): Boolean;
{ returns true if the electronic signature code in ACode is valid }
var
  x: string;
begin
  Result := CallVistA('ORWU VALIDSIG', [Encrypt(ACode)], x) and (x = '1');
end;

//function otherInformationPanelControls: string;
//begin
//  Result := sCallV('ORWOTHER SHWOTHER', [USER.DUZ]);
//end;

{ Notifications Calls }

procedure LoadNotifications(Dest: TStrings);
begin
  CallVistA('ORWORB FASTUSER', [nil], Dest);
end;

function LoadNotificationLongText(AlertID: string): string;
var
  temp: TStringList;
  i: Integer;
begin
  temp := TStringList.Create();
  try
    CallVistA('ORWORB GETLTXT', [AlertID], temp);
    Result := ''; // CRLF
    for i := 0 to temp.Count - 1 do
      Result := Result + temp[i] + CRLF;
  finally
    temp.Free;
  end;
end;

procedure LoadProcessedNotifications(var Dest: TStrings;
  DateFrom, DateTo, MaxNumber, ProcessedOnly: String);
begin
  // UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
  CallVistA('ORWORB PROUSER', [DateFrom, DateTo, MaxNumber,
    ProcessedOnly], Dest);
end;

function IsSmartAlert(notIEN: Integer): Boolean;
var
  temp: string;
begin
  Result := CallVistA('ORBSMART ISSMNOT', [notIEN], temp) and (temp = '1');
end;

procedure UpdateUnsignedOrderAlerts(PatientDFN: string);
begin
  CallVistA('ORWORB KILL UNSIG ORDERS ALERT', [PatientDFN]);
end;

function UnsignedOrderAlertFollowup(XQAID: string): string;
begin
  CallVistA('ORWORB UNSIG ORDERS FOLLOWUP', [XQAID], Result);
end;

procedure UpdateIndOrderAlerts();
begin
  if Notifications.IndOrderDisplay then
  begin
    Notifications.IndOrderDisplay := False;
    Notifications.Delete;
  end;
end;

procedure UpdateExpiringMedAlerts(PatientDFN: string);
begin
  CallVistA('ORWORB KILL EXPIR MED ALERT', [PatientDFN]);
end;

procedure UpdateExpiringFlaggedOIAlerts(PatientDFN: string; FollowUp: Integer);
begin
  CallVistA('ORWORB KILL EXPIR OI ALERT', [PatientDFN, FollowUp]);
end;

procedure UpdateUnverifiedMedAlerts(PatientDFN: string);
begin
  CallVistA('ORWORB KILL UNVER MEDS ALERT', [PatientDFN]);
end;

procedure UpdateUnverifiedOrderAlerts(PatientDFN: string);
begin
  CallVistA('ORWORB KILL UNVER ORDERS ALERT', [PatientDFN]);
end;

procedure AutoUnflagAlertedOrders(PatientDFN, XQAID: string);
begin
  CallVistA('ORWORB AUTOUNFLAG ORDERS', [PatientDFN, XQAID]);
end;

procedure DeleteAlert(XQAID: string);
// deletes an alert
begin
  CallVistA('ORB DELETE ALERT', [XQAID]);
end;

procedure DeleteAlertForUser(XQAID: string);
// deletes an alert
begin
  CallVistA('ORB DELETE ALERT', [XQAID, True]);
end;

procedure ForwardAlert(XQAID: string; Recip: string; FWDtype: string;
  Comment: string);
// Forwards an alert with comment to Recip[ient]
begin
  CallVistA('ORB FORWARD ALERT', [XQAID, Recip, FWDtype, Comment]);
end;

procedure RenewAlert(XQAID: string);
// Restores/renews an alert
begin
  CallVistA('ORB RENEW ALERT', [XQAID]);
end;

function GetSortMethod: string;
// Returns alert sort method
begin
  CallVistA('ORWORB GETSORT', [nil], Result);
end;

procedure SetSortMethod(Sort: string; Direction: string);
// Sets alert sort method for user
begin
  CallVistA('ORWORB SETSORT', [Sort, Direction]);
end;

function GetXQAData(XQAID: string; pFlag: string = ''): string;
// Returns data associated with an alert
begin
  CallVistA('ORWORB GETDATA', [XQAID, pFlag], Result);
end;

function GetTIUAlertInfo(XQAID: string): string;
// Returns DFN and document type associated with a TIU alert
begin
  CallVistA('TIU GET ALERT INFO', [XQAID], Result);
end;

function setNotificationFollowUpText(aDest: TStrings; PatientDFN: string;
  Notification: Integer; XQADATA: string): Integer;
// Returns follow-up text for an alert
begin
  CallVistA('ORWORB TEXT FOLLOWUP', [PatientDFN, Notification, XQADATA], aDest);
  Result := aDest.Count;
end;

{ Patient List Calls }

function DfltPtList: string;
{ returns the name of the current user's default patient list, null if none is defined
  Pieces: Ptr to Source File^Source Name^Source Type }
begin
  if CallVistA('ORQPT DEFAULT LIST SOURCE', [nil], Result) and
    (Length(Result) > 0) then
    Result := Pieces(Result, U, 2, 3);
end;

function DfltPtListSrc: Char;
var
  x: String;
begin
  CallVistA('ORWPT DFLTSRC', [nil], x);
  Result := CharAt(x, 1);
end;

function DefltPtListSrc: string;
{ returns the default pastient list source as string }
// TDP - ADDED 5/28/2014 to handle new possible "E" default list source
begin
  CallVistA('ORWPT DFLTSRC', [nil], Result);
end;

procedure SavePtListDflt(const x: string);
begin
  CallVistA('ORWPT SAVDFLT', [x]);
end;

procedure ListSpecialtyAll(Dest: TStrings);
{ lists all treating specialties: IEN^Treating Specialty Name }
begin
  CallVistA('ORQPT SPECIALTIES', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure ListTeamAll(Dest: TStrings);
{ lists all patient care teams: IEN^Team Name }
begin
  CallVistA('ORQPT TEAMS', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure ListPcmmAll(Dest: TStrings);
{ lists all patient care teams: IEN^Team Name }
// TDP - Added 5/27/2014 as part of PCMMR mods
begin
  CallVistA('ORQPT PTEAMPR', [nil], Dest);
  MixedCaseList(Dest);
end;

procedure ListWardAll(Dest: TStrings);
{ lists all active inpatient wards: IEN^Ward Name }
begin
  CallVistA('ORQPT WARDS', [nil], Dest);
end;

procedure ListProviderTop(Dest: TStrings);
{ checks parameters for list of commonly selected providers }
begin
end;

function setSubSetOfProviders(aComponent: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer): Integer;
begin
  SNCallVistA(aComponent, SN_ORWU_NEWPERS, [StartFrom, Direction, 'PROVIDER'], aDest);
  Result := aDest.Count;
end;

function setSubSetOfCosigners(AORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer; Date: TFMDateTime;
  ATitle: Integer; ADocType: Integer): Integer;
begin
  if ATitle > 0 then
    ADocType := 0;
  SNCallVistA(AORComboBox, SN_ORWU2_COSIGNER, [StartFrom, Direction, Date,
    ADocType, ATitle], aDest);
  Result := aDest.Count;
end;

function setSubSetOfUsersWithClass(AORComboBox: TORComboBox; aDest: TStrings;
  const StartFrom: string; Direction: Integer; DateTime: string): Integer;
begin
  SNCallVistA(AORComboBox, SN_ORWU_NEWPERS, [StartFrom, Direction, '', DateTime], aDest);
  Result := aDest.Count;
end;

function setSubSetOfActiveAndInactivePersons(AORComboBox: TORComboBox;
  var aDest: TStrings; const StartFrom: string; Direction: Integer): Integer;
begin
  SNCallVistA(AORComboBox, SN_ORWU_NEWPERS, [StartFrom, Direction, '', '', '', True], aDest);
  // TRUE = return all active and inactive users
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function SubsetOfPatientsWithSimilarSSNs(aDFN: Int64): TStrings;
function SubsetOfPatientsWithSimilarSSNs(aDest: TStrings;aDFN: String): Integer;
{ returns a pointer to a list of patients that has similar SSNs }
begin
  CallVistA('ORWPT2 LOOKUP', [aDFN], aDest);
  Result := aDest.Count;
end;

procedure ListClinicTop(Dest: TStrings);
{ checks parameters for list of commonly selected clinics }
begin
end;

function setSubSetOfClinics(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ returns a pointer to a list of clinics (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORWU CLINLOC', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

function GetDfltSort: string;
{ Assigns uPtLstDfltSort to user's default patient list sort order (string character). }
begin
  CallVistA('ORQPT DEFAULT LIST SORT', [nil], uPtListDfltSort);
  if uPtListDfltSort = '' then
    uPtListDfltSort := 'A'; // Default is always "A" for alpha.
  Result := uPtListDfltSort;
end;

procedure ResetDfltSort;
begin
  uPtListDfltSort := '';
end;

procedure ListPtByDflt(Dest: TStrings);
{ loads the default patient list into Dest, Pieces: DFN^PATIENT NAME, ETC. }
var
  i, SourceType: Integer;
  ATime, APlace, Sort, Source, x: string;
  tmplst: TORStringList;
begin
  Sort := GetDfltSort();
  tmplst := TORStringList.Create;
  try
    CallVistA('ORQPT DEFAULT PATIENT LIST', [nil], tmplst);
    // Source := sCallV('ORWPT DFLTSRC', [nil]);
    CallVistA('ORWPT DFLTSRC', [nil], Source);
    if Source = 'C' then // Clinics.
    begin
      if Sort = 'P' then // "Appointments" sort.
        SortByPiece(tmplst, U, 4)
      else
        SortByPiece(tmplst, U, 2);
      for i := 0 to tmplst.Count - 1 do
      begin
        x := tmplst[i];
        ATime := Piece(x, U, 4);
        APlace := Piece(x, U, 3);
        ATime := FormatFMDateTime('hh:nn  mmm dd, yyyy', MakeFMDateTime(ATime));
        SetPiece(x, U, 3, ATime);
        x := x + U + APlace;
        tmplst[i] := x;
      end;
    end
    else
    begin
      SourceType := 0; // Default.
      if Source = 'M' then
        SourceType := 1; // Combinations.
      if Source = 'W' then
        SourceType := 2; // Wards.
      case SourceType of
        1:
          if Sort = 'S' then
            tmplst.SortByPieces([3, 8, 2]) // "Source" sort.
          else if Sort = 'P' then
            tmplst.SortByPieces([8, 2]) // "Appointment" sort.
          else if Sort = 'T' then
            SortByPiece(tmplst, U, 5) // "Terminal Digit" sort.
          else
            SortByPiece(tmplst, U, 2);
        // "Alphabetical" (also the default) sort.
        2:
          if Sort = 'R' then
            tmplst.SortByPieces([3, 2])
          else
            SortByPiece(tmplst, U, 2);
      else
        SortByPiece(tmplst, U, 2);
      end;
    end;
    MixedCaseList(tmplst);
    FastAssign(tmplst, Dest);
  finally
    tmplst.Free;
  end;
end;

procedure ListPtByProvider(Dest: TStrings; ProviderIEN: Int64);
{ lists all patients associated with a given provider: DFN^Patient Name }
begin
  CallVistA('ORQPT PROVIDER PATIENTS', [ProviderIEN], Dest);
  SortByPiece(Dest, U, 2);
  MixedCaseList(Dest);
end;

procedure ListPtByTeam(Dest: TStrings; TeamIEN: Integer);
{ lists all patients associated with a given team: DFN^Patient Name }
begin
  CallVistA('ORQPT TEAM PATIENTS', [TeamIEN], Dest);
  SortByPiece(Dest, U, 2);
  MixedCaseList(Dest);
end;

procedure ListPtByPcmmTeam(Dest: TStrings; TeamIEN: Integer);
{ lists all patients associated with a given PCMM team: DFN^Patient Name }
// TDP - Added 5/23/2014
begin
  CallVistA('ORQPT PTEAM PATIENTS', [TeamIEN], Dest);
  SortByPiece(Dest, U, 2);
  MixedCaseList(Dest);
end;

procedure ListPtBySpecialty(Dest: TStrings; SpecialtyIEN: Integer);
{ lists all patients associated with a given specialty: DFN^Patient Name }
begin
  CallVistA('ORQPT SPECIALTY PATIENTS', [SpecialtyIEN], Dest);
  SortByPiece(Dest, U, 2);
  MixedCaseList(Dest);
end;

procedure ListPtByClinic(Dest: TStrings; ClinicIEN: Integer;
  FirstDt, LastDt: string); // TFMDateTime);
{ lists all patients associated with a given clinic: DFN^Patient Name^App't }
var
  i: Integer;
  x, ATime, APlace, Sort: string;
  slAppts: TStringList;
begin
  Sort := GetDfltSort();
  CallVistA('ORQPT CLINIC PATIENTS', [ClinicIEN, FirstDt, LastDt], Dest);
  slAppts := TStringList.Create;
  try
    slAppts.Assign(Dest);
    if Sort = 'P' then
      SortByPiece(slAppts, U, 4)
    else
      SortByPiece(slAppts, U, 2);
    for i := 0 to slAppts.Count - 1 do
    begin
      x := slAppts[i];
      ATime := Piece(x, U, 4);
      APlace := Piece(x, U, 3);
      ATime := FormatFMDateTime('hh:nn  mmm dd, yyyy', MakeFMDateTime(ATime));
      SetPiece(x, U, 3, ATime);
      x := x + U + APlace;
      slAppts[i] := x;
    end;
    MixedCaseList(slAppts);
    Dest.Assign(slAppts);
  finally
    slAppts.Free;
  end;
end;

procedure ListPtByWard(Dest: TStrings; WardIEN: Integer);
{ lists all patients associated with a given ward: DFN^Patient Name^Room/Bed }
var
  Sort: string;
  i: Integer;
begin
  Sort := GetDfltSort();
  CallVistA('ORWPT BYWARD', [WardIEN], Dest);
  // if Sort = 'R' then
  // SortByPiece(TStringList(RPCBrokerV.Results), U, 3)
  // else
  // SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  if Sort = 'R' then
    i := 3
  else
    i := 2;
  // SortByPiece(TStringList(Dest), U, i);
  SortByPiece(Dest, U, i);

  MixedCaseList(Dest);
end;

procedure ListPtByLast5(Dest: TStrings; const Last5: string);
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
  { Lists all patients found in the BS and BS5 xrefs that match Last5: DFN^Patient Name }
  CallVistA('ORWPT LAST5', [UpperCase(Last5)], Dest);
  // SortByPiece(TStringList({RPCBrokerV.Results}Dest), U, 2);
  SortByPiece(Dest, U, 2);
  for i := 0 to Dest.Count - 1 do
  begin
    x := Dest[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then
      ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN) then
      AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Dest[i] := x;
  end;
  MixedCaseList(Dest);
end;

procedure ListPtByRPLLast5(Dest: TStrings; const Last5: string);
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
  { Lists patients from RPL list that match Last5: DFN^Patient Name }
  CallVistA('ORWPT LAST5 RPL', [UpperCase(Last5)], Dest);
  // SortByPiece(TStringList({RPCBrokerV.Results}Dest), U, 2);
  SortByPiece(Dest, U, 2);
  for i := 0 to Dest.Count - 1 do
  begin
    x := Dest[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then
      ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN) then
      AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Dest[i] := x;
  end;
  MixedCaseList(Dest);
end;

procedure ListPtByFullSSN(Dest: TStrings; const FullSSN: string);
{ lists all patients found in the SSN xref that match FullSSN: DFN^Patient Name }
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
  x := FullSSN;
  i := Pos('-', x);
  while i > 0 do
  begin
    x := Copy(x, 1, i - 1) + Copy(x, i + 1, 12);
    i := Pos('-', x);
  end;
  CallVistA('ORWPT FULLSSN', [UpperCase(x)], Dest);
  // SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  // SortByPiece(TStringList(Dest), U, 2);
  SortByPiece(Dest, U, 2);
  { with RPCBrokerV do } for i := 0 to { Results } Dest.Count - 1 do
  begin
    x := Dest[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then
      ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN) then
      AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Dest[i] := x;
  end;
  MixedCaseList(Dest);
end;

procedure ListPtByRPLFullSSN(Dest: TStrings; const FullSSN: string);
{ lists all patients found in the SSN xref that match FullSSN: DFN^Patient Name }
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
  x := FullSSN;
  i := Pos('-', x);
  while i > 0 do
  begin
    x := Copy(x, 1, i - 1) + Copy(x, i + 1, 12);
    i := Pos('-', x);
  end;
  CallVistA('ORWPT FULLSSN RPL', [UpperCase(x)], Dest);
  // SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  // SortByPiece(TStringList(Dest), U, 2);
  SortByPiece(Dest, U, 2);
  for i := 0 to Dest.Count - 1 do
  begin
    x := Dest[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then
      ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN) then
      AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Dest[i] := x;
  end;
  MixedCaseList(Dest);
end;

procedure ListPtTop(Dest: TStrings);
{ currently returns the last patient selected }
begin
  CallVistA('ORWPT TOP', [nil], Dest);
  MixedCaseList(Dest);
end;

function setSubSetOfPatients(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ returns a pointer to a list of patients (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORWPT LIST ALL', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

function MakeRPLPtList(RPLList: string): string;
{ Creates "RPL" Restricted Patient List based on Team List info in user's record. }
begin
  // RTC 272867 result := sCallV('ORQPT MAKE RPL', [RPLList]);
  CallVistA('ORQPT MAKE RPL', [RPLList], Result);
end;

function setRPLPtList(aDest: TStrings; RPLJobNumber: string;
  const StartFrom: string; Direction: Integer): Integer;
{ returns a pointer to a list of patients (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORQPT READ RPL', [RPLJobNumber, StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

procedure KillRPLPtList(RPLJobNumber: string);
begin
  CallVistA('ORQPT KILL RPL', [RPLJobNumber]);
end;

{ Patient Specific Calls }

function CalcAge(BirthDate, DeathDate: TFMDateTime): Integer;
{ calculates age based on today's date and a birthdate (in Fileman format) }
begin
  if (DeathDate > BirthDate) then
    Result := Trunc(DeathDate - BirthDate) div 10000
  else
    Result := Trunc(FMToday - BirthDate) div 10000
end;

procedure CheckSensitiveRecordAccess(const DFN: string;
  var AccessStatus: Integer; var MessageText: string);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    CallVistA('DG SENSITIVE RECORD ACCESS', [DFN], Results);
    AccessStatus := -1;
    MessageText := '';
    // RTC 272867    with RPCBrokerV do
    begin
      if Results.Count > 0 then
      begin
        AccessStatus := StrToIntDef(Results[0], -1);
        Results.Delete(0);
        if Results.Count > 0 then
          MessageText := Results.Text;
      end;
    end;
  finally
    Results.Free;
  end;
end;

procedure CheckRemotePatient(var Dest: string; Patient, ASite: string;
  var AccessStatus: Integer);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    CallVistA('XWB DIRECT RPC', [ASite, 'ORWCIRN RESTRICT', 0,
      Patient], Results);
    AccessStatus := -1;
    Dest := '';
    begin
      if Results.Count > 0 then
      begin
        if Results[0] = '' then
          Results.Delete(0);
      end;
      if Results.Count > 0 then
      begin
        if (Length(Piece(Results[0], '^', 2)) > 0) and
          ((StrToIntDef(Piece(Results[0], '^', 1), 0) = -1)) then
        begin
          AccessStatus := -1;
          Dest := Piece(Results[0], '^', 2);
        end
        else
        begin
          AccessStatus := StrToIntDef(Results[0], -1);
          Results.Delete(0);
          if Results.Count > 0 then
            Dest := Results.Text;
        end;
      end;
    end;
  finally
    Results.Free;
  end;
end;

procedure CurrentLocationForPatient(const DFN: string; var ALocation: Integer;
  var AName: string; var ASvc: string);
var
  x: string;
begin
  CallVistA('ORWPT INPLOC', [DFN], x);
  ALocation := StrToIntDef(Piece(x, U, 1), 0);
  AName := Piece(x, U, 2);
  ASvc := Piece(x, U, 3);
end;

function DateOfDeath(const DFN: string): TFMDateTime;
{ returns 0 or the date a patient died }
var
  x: String;
begin
  CallVistA('ORWPT DIEDON', [DFN], x);
  Result := MakeFMDateTime(x);
end;

function GetPtIDInfo(const DFN: string): TPtIDInfo; // *DFN*
{ returns the identifiers displayed upon patient selection
  Pieces: SSN[1]^DOB[2]^SEX[3]^VET[4]^SC%[5]^WARD[6]^RM-BED[7]^NAME[8] }
var
  S: string;
begin
  // First, do the legacy RPC
  CallVistA('ORWPT ID INFO', [DFN], S);
  // map string into TPtIDInfo record
  Result.Name := MixedCase(Piece(S, U, 8)); // Name
  Result.SSN := Piece(S, U, 1);
  Result.DOB := Piece(S, U, 2);
  Result.Age := '';
  if IsSSN(Result.SSN) then
    Result.SSN := FormatSSN(Result.SSN); // SSN (PID)
  if IsFMDate(Result.DOB) then
    Result.DOB := FormatFMDateTimeStr('mmm dd,yyyy', Result.DOB); // Date of Birth
  Result.Sex := Piece(S, U, 3); // Sex
  if Length(Result.Sex) = 0 then
    Result.Sex := 'U';
  case Result.Sex[1] of
    'F', 'f': Result.Sex := 'Female';
    'M', 'm': Result.Sex := 'Male';
  else Result.Sex := 'Unknown';
  end;
  if Piece(S, U, 4) = 'Y' then
    Result.Vet := 'Veteran'
  else
    Result.Vet := ''; // Veteran?
  if Length(Piece(S, U, 5)) > 0 // % Service Connected
  then
    Result.SCSts := Piece(S, U, 5) + '% Service Connected'
  else
    Result.SCSts := '';
  Result.Location := Piece(S, U, 6); // Inpatient Location
  Result.RoomBed := Piece(S, U, 7); // Inpatient Room-Bed
  Result.SIGI := Piece(S, U, 9); // NSR#20130305
  Result.Attending := Piece(S, U, 10); // Attending Physician
  // NSR 20131005 SDS July 2017
  // Second, run a new RPC that returns additional info requested by Patient Safety
  // M developer explained a second call was the cleanest way to safely obtain data
  CallVistA('ORWPT2 ID INFO', [DFN], S);            // NSR 20131005 SDS July 2017
  Result.PrimaryInpatientProvider:= Piece(S, U, 1); // NSR 20131005 SDS July 2017
  Result.PrimaryCareProvider:= Piece(S, U, 2);      // NSR 20131005 SDS July 2017
  Result.LastVisitLocation:= Piece(S, U, 3);        // NSR 20131005 SDS July 2017
  Result.LastVisitDate:= Piece(S, U, 4);            // NSR 20131005 SDS July 2017
end;

function HasLegacyData(const DFN: string; var AMsg: string): Boolean;
var
  sl: TStrings;
  i: Integer;
begin
  Result := False;
  AMsg := '';
  if DFN <> '' then // RTC Defect 596428
  begin
    sl := TStringList.Create;
    try
      CallVistA('ORWPT LEGACY', [DFN], sl);
      if sl.Count > 0 then
      begin
        Result := sl[0] = '1';
        for i := 1 to sl.Count - 1 do
          AMsg := AMsg + sl[i] + CRLF;
      end;
    finally
      sl.Free;
    end;
  end;
end;

function LogSensitiveRecordAccess(const DFN: string): Boolean;
var
  x: String;
begin
  Result := CallVistA('DG SENSITIVE RECORD BULLETIN', [DFN], x) and (x = '1');
end;

function MeansTestRequired(const DFN: string; var AMsg: string): Boolean;
var
  i: Integer;
  sl: TStrings;
begin
  Result := False;
  AMsg := '';
  sl := TStringList.Create;
  try
    CallVistA('DG CHK PAT/DIV MEANS TEST', [DFN], sl);
    // with RPCBrokerV do if Results.Count > 0 then
    if sl.Count > 0 then
    begin
      Result := sl[0] = '1';
      for i := 1 to sl.Count - 1 do
        AMsg := AMsg + sl[i] + CRLF;
    end;
  finally
    sl.Free;
  end;
end;

function RestrictedPtRec(const DFN: string): Boolean;
var
  x: String; // *DFN*
  { returns true if the record for a patient identified by DFN is restricted }
begin
  Result := CallVistA('ORWPT SELCHK', [DFN], x) and (Piece(x, U, 1) = '1');
end;

procedure SelectPatient(const DFN: string; var PtSelect: TPtSelect); // *DFN*
{ selects the patient (updates DISV, calls Pt Select actions) & returns key fields
  Pieces: NAME[1]^SEX[2]^DOB[3]^SSN[4]^LOCIEN[5]^LOCNAME[6]^ROOMBED[7]^CWAD[8]^SENSITIVE[9]^
  ADMITTIME[10]^CONVERTED[11]^SVCONN[12]^SC%[13]^ICN[14]^Age[15]^TreatSpec[16]^
  SpecialtySvc[17]^SIGI[18]^ProNoun[19] }
var
  x: string;
begin
  CallVistA('ORWPT SELECT', [DFN], x);
  uAllergyCacheCreated := False;
  with PtSelect do
  begin
    Name := Piece(x, U, 1);
    ICN := Piece(x, U, 14);
    SSN := FormatSSN(Piece(x, U, 4));
    DOB := MakeFMDateTime(Piece(x, U, 3));
    Age := StrToIntDef(Piece(x, U, 15), 0);
    // Age := CalcAge(DOB, DateOfDeath(DFN));
    SIGI := Piece(x, U, 18); // NSR#20130305
    Pronoun := Piece(x, U, 19);
    if Length(Piece(x, U, 2)) > 0 then
      Sex := Piece(x, U, 2)[1]
    else
      Sex := 'U';
    LocationIEN := StrToIntDef(Piece(x, U, 5), 0);
    Location := Piece(x, U, 6);
    RoomBed := Piece(x, U, 7);
    SpecialtyIEN := StrToIntDef(Piece(x, U, 16), 0);
    SpecialtySvc := Piece(x, U, 17);
    CWAD := Piece(x, U, 8);
    Restricted := Piece(x, U, 9) = '1';
    AdmitTime := MakeFMDateTime(Piece(x, U, 10));
    ServiceConnected := Piece(x, U, 12) = '1';
    SCPercent := StrToIntDef(Piece(x, U, 13), 0);
  end;
  CallVistA('ORWPT1 PRCARE', [DFN], x);
  with PtSelect do
  begin
    PrimaryTeam := Piece(x, U, 1);
    PrimaryProvider := Piece(x, U, 2);
    Associate := Piece(x, U, 4);
    MHTC := Piece(x, U, 5);
    if Length(Location) > 0 then
    begin
      Attending := Piece(x, U, 3);
      InProvider := Piece(x, U, 6);
      CallVistA('ORWPT INPLOC', [DFN], x);
      WardService := Piece(x, U, 3);
    end;
  end;
  with PtSelect do
  begin
    if CallVistA('ORWPT GET FULL ICN', [DFN], FullICN) then
    begin
      if Piece(FullICN, U, 1) = '-1' then
        FullICN := '';
    end
    else
      FullICN := '';
  end;
end;

function GetVAAData(const DFN: string; aList: TStrings): Boolean;
begin
  aList.Clear;
  Result := CallVistA('ORVAA VAA', [DFN], aList);
end;

function GetMHVData(const DFN: string; aList: TStrings): Boolean;
begin
  aList.Clear;
  Result := CallVistA('ORWMHV MHV', [DFN], aList);
end;

function SimilarRecordsFound(const DFN: string; var AMsg: string): Boolean;
var
  sl: TStrings;
begin
  Result := False;
  AMsg := '';
  // CallV('DG CHK BS5 XREF Y/N', [DFN]);
  sl := TStringList.Create;
  try
    CallVistA('DG CHK BS5 XREF Y/N', [DFN], sl);
    // with RPCBrokerV do if Results.Count > 0 then
    if sl.Count > 0 then
    begin
      Result := sl[0] = '1';
      sl.Delete(0);
      AMsg := sl.Text;
    end;
  finally
    sl.Free;
  end;
end;

function GetDFNFromICN(AnICN: string): string;
begin
  CallVistA('VAFCTFU CONVERT ICN TO DFN', [AnICN], Result);
  Result := Piece(Result, U, 1);
end;

function otherInformationPanel(const DFN: string): string;
begin
//  result := sCallV('ORWPT2 COVID', [DFN]);
  CallVistA('ORWPT2 COVID', [DFN], result);
end;

procedure otherInformationPanelDetails(const DFN: string; valueType: string; var details: TStrings);
begin
  CallVistA('ORWOTHER DETAIL', [dfn, valueType], details);
//  FastAssign(RPCBrokerV.Results, details);
end;
{ Encounter specific calls }

function GetEncounterText(const DFN: string; Location: Integer; Provider: Int64)
  : TEncounterText; // *DFN*
{ returns resolved external values  Pieces: LOCNAME[1]^PROVNAME[2]^ROOMBED[3] }
var
  x: string;
begin
  CallVistA('ORWPT ENCTITL', [DFN, Location, Provider], x);
  with Result do
  begin
    LocationName := Piece(x, U, 1);
    LocationAbbr := Piece(x, U, 2);
    RoomBed := Piece(x, U, 3);
    ProviderName := Piece(x, U, 4);
    // ProviderName := sCallV('ORWU1 NAMECVT', [Provider]);
  end;
end;

function GetActiveICDVersion(ADate: TFMDateTime = 0): String;
begin
  CallVistA('ORWPCE ICDVER', [ADate], Result);
end;

function GetICD10ImplementationDate: TFMDateTime;
var
  impDt: String;
begin
  CallVistA('ORWPCE I10IMPDT', [nil], impDt);
  if impDt <> '' then
    Result := StrToFMDateTime(impDt)
  else
    Result := 3141001; // Default to 10/01/2014
end;

procedure ListApptAll(Dest: TStrings; const DFN: string; From: TFMDateTime = 0;
  Thru: TFMDateTime = 0);
{ lists appts/visits for a patient (uses same call as cover sheet)
  V|A;DateTime;LocIEN^DateTime^LocName^Status }
const
  SKIP_ADMITS = 1;
begin
  CallVistA('ORWCV VST', [Patient.DFN, From, Thru, SKIP_ADMITS], Dest);
  InvertStringList(Dest);
  MixedCaseList(Dest);
  // SetListFMDateTime('mmm dd,yyyy hh:nn', TStringList(Dest), U, 2);
  SetListFMDateTime('mmm dd,yyyy hh:nn', Dest, U, 2);
end;

procedure ListAdmitAll(Dest: TStrings; const DFN: string); // *DFN*
{ lists all admissions for a patient: MovementTime^LocIEN^LocName^Type }
var
  i: Integer;
  ATime, x: string;
begin
  CallVistA('ORWPT ADMITLST', [DFN], Dest);
  begin
    for i := 0 to Dest.Count - 1 do
    begin
      x := Dest[i];
      ATime := Piece(x, U, 1);
      ATime := FormatFMDateTime('mmm dd, yyyy hh:nn', MakeFMDateTime(ATime));
      SetPiece(x, U, 5, ATime);
      Dest[i] := x;
    end;
  end;
end;

function setSubSetOfLocations(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ returns a pointer to a list of locations (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORWU HOSPLOC', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

function setSubSetOfNewLocs(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ Returns a pointer to a list of locations (for use in a long list box) -  the return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call!
  Filtered by C, W, and Z types - i.e., Clinics, Wards, and "Other" type locations. }
begin
  CallVistA('ORWU1 NEWLOC', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

function setSubSetOfInpatientLocations(aDest: TStrings; const StartFrom: string;
  Direction: Integer): Integer;
{ returns a pointer to a list of locations (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallVistA('ORWU INPLOC', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

{ Remote Data Access calls }

function HasRemoteData(const DFN: string; var ALocations: TStringList): Boolean;
begin
  CallVistA('ORWCIRN FACLIST', [DFN], ALocations);
  if ALocations.Count = 0 then
    ALocations.Add('-1');
  Result := not(Piece(ALocations[0], U, 1) = '-1')

  // '-1^NO DFN'
  // '-1^PATIENT NOT IN DATABASE'
  // '-1^NO MPI Node'
  // '-1^NO ICN'
  // '-1^Parameter missing.'
  // '-1^No patient DFN.'
  // '-1^Could not find Treating Facilities'
  // '-1^Remote access not allowed'     <===parameter ORWCIRN REMOTE DATA ALLOW
end;

function CheckHL7TCPLink: Boolean;
var
  x: String;
begin
  Result := CallVistA('ORWCIRN CHECKLINK', [nil], x) and (x = '1');
end;

function GetVistaWebAddress(value: string): string;
begin
  // RPC description states the result type is "SINGLE VALUE"
  CallVistA('ORWCIRN WEBADDR', [value], Result);
end;

function GetVistaWeb_JLV_LabelName: string;
begin
  CallVistA('ORWCIRN JLV LABEL', [nil], Result);
end;

function GetDefaultPrinter(DUZ: Int64; Location: Integer): string;
begin
  CallVistA('ORWRP GET DEFAULT PRINTER', [DUZ, Location], Result);
end;

function CreateSysUserParameters(DUZ: Int64): TORJSONParameters;
var
  AReturn: string;
begin
  CallVistA('ORWU SYSPARAM', [DUZ], AReturn);
  Result := TORJSONParameters.Create(AReturn);
end;

end.

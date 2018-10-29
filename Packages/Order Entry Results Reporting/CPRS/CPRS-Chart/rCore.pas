unit rCore;

interface

uses SysUtils, Classes, Forms, ORNet, ORFn, ORClasses;

{ record types used to return data from the RPC's.  Generally, the delimited strings returned
  by the RPC are mapped into the records defined below. }

const
  UC_UNKNOWN   = 0;                               // user class unknown
  UC_CLERK     = 1;                               // user class clerk
  UC_NURSE     = 2;                               // user class nurse
  UC_PHYSICIAN = 3;                               // user class physician

type
  TUserInfo = record                              // record for ORWU USERINFO
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
    IsProductionAccount: boolean;
  end;

  TPtIDInfo = record                              // record for ORWPT IDINFO
    Name: string;
    SSN: string;
    DOB: string;
    Age: string;
    Sex: string;
    SCSts: string;
    Vet: string;
    Location: string;
    RoomBed: string;
  end;

  TPtSelect = record                              // record for ORWPT SELECT
    Name: string;
    ICN: string;
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
  end;

  TEncounterText = record                         // record for ORWPT ENCTITL
    LocationName: string;
    LocationAbbr: string;
    RoomBed: string;
    ProviderName: string;
  end;

{ Date/Time functions - right now these make server calls to use server time}

function FMToday: TFMDateTime;
function FMNow: TFMDateTime;
function MakeRelativeDateTime(FMDateTime: TFMDateTime): string;
function StrToFMDateTime(const AString: string): TFMDateTime;
function ValidDateTimeStr(const AString, Flags: string): TFMDateTime;
procedure ListDateRangeClinic(Dest: TStrings);

{ General calls }

function ExternalName(IEN: Int64; FileNumber: Double): string;
function PersonHasKey(APerson: Int64; const AKey: string): Boolean;
function GlobalRefForFile(const FileID: string): string;
function SubsetOfGeneric(const StartFrom: string; Direction: Integer; const GlobalRef: string): TStrings;
function SubsetOfDevices(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfPersons(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfActiveAndInactivePersons(const StartFrom: string; Direction: Integer): TStrings;
function GetDefaultPrinter(DUZ: Int64; Location: integer): string;

{ User specific calls }

function GetUserInfo: TUserInfo;
function GetUserParam(const AParamName: string): string;
procedure GetUserListParam(Dest: TStrings; const AParamName: string);
function HasSecurityKey(const KeyName: string): Boolean;
function HasMenuOptionAccess(const OptionName: string): Boolean;
function ValidESCode(const ACode: string): Boolean;

{ Notifications calls }

procedure LoadNotifications(Dest: TStrings);
procedure DeleteAlert(XQAID: string);
procedure DeleteAlertForUser(XQAID: string);
function  GetXQAData(XQAID: string): string;
function  GetTIUAlertInfo(XQAID: string): string;
procedure UpdateUnsignedOrderAlerts(PatientDFN: string);
function UnsignedOrderAlertFollowup(XQAID: string): string;
procedure UpdateExpiringMedAlerts(PatientDFN: string);
procedure UpdateExpiringFlaggedOIAlerts(PatientDFN: string; FollowUp: integer);
procedure AutoUnflagAlertedOrders(PatientDFN, XQAID: string);
procedure UpdateUnverifiedMedAlerts(PatientDFN: string);
procedure UpdateUnverifiedOrderAlerts(PatientDFN: string);
function GetNotificationFollowUpText(PatientDFN: string; Notification: integer; XQADATA: string): TStrings;
procedure ForwardAlert(XQAID: string; Recip: string; FWDtype: string; Comment: string);
procedure RenewAlert(XQAID: string);
function GetSortMethod: string;
procedure SetSortMethod(Sort: string; Direction: string);
procedure UpdateIndOrderAlerts();

{ Patient List calls }

function DfltPtList: string;
function DfltPtListSrc: Char;
procedure SavePtListDflt(const x: string);
procedure ListSpecialtyAll(Dest: TStrings);
procedure ListTeamAll(Dest: TStrings);
procedure ListWardAll(Dest: TStrings);
procedure ListProviderTop(Dest: TStrings);
function SubSetOfProviders(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfCosigners(const StartFrom: string; Direction: Integer; Date: TFMDateTime;
  ATitle: integer; ADocType: integer): TStrings;
procedure ListClinicTop(Dest: TStrings);
function SubSetOfClinics(const StartFrom: string; Direction: Integer): TStrings;
function GetDfltSort: string;
procedure ResetDfltSort;
procedure ListPtByDflt(Dest: TStrings);
procedure ListPtByProvider(Dest: TStrings; ProviderIEN: Int64);
procedure ListPtByTeam(Dest: TStrings; TeamIEN: Integer);
procedure ListPtBySpecialty(Dest: TStrings; SpecialtyIEN: Integer);
procedure ListPtByClinic(Dest: TStrings; ClinicIEN: Integer; FirstDt, LastDt: string);
procedure ListPtByWard(Dest: TStrings; WardIEN: Integer);
procedure ListPtByLast5(Dest: TStrings; const Last5: string);
procedure ListPtByRPLLast5(Dest: TStrings; const Last5: string);
procedure ListPtByFullSSN(Dest: TStrings; const FullSSN: string);
procedure ListPtByRPLFullSSN(Dest: TStrings; const FullSSN: string);
procedure ListPtTop(Dest: TStrings);
function SubSetOfPatients(const StartFrom: string; Direction: Integer): TStrings;
function DfltDateRangeClinic: string;
function MakeRPLPtList(RPLList: string): string;
function ReadRPLPtList(RPLJobNumber: string; const StartFrom: string; Direction: Integer) : TStrings;
procedure KillRPLPtList(RPLJobNumber: string);

{ Patient specific calls }

function CalcAge(BirthDate, DeathDate: TFMDateTime): Integer;
procedure CheckSensitiveRecordAccess(const DFN: string; var AccessStatus: Integer;
  var MessageText: string);
procedure CheckRemotePatient(var Dest: string; Patient, ASite: string; var AccessStatus: Integer);
procedure CurrentLocationForPatient(const DFN: string; var ALocation: Integer; var AName: string; var ASvc: string);
function DateOfDeath(const DFN: string): TFMDateTime;
function GetPtIDInfo(const DFN: string): TPtIDInfo;
function HasLegacyData(const DFN: string; var AMsg: string): Boolean;
function LogSensitiveRecordAccess(const DFN: string): Boolean;
function MeansTestRequired(const DFN: string; var AMsg: string): Boolean;
function RestrictedPtRec(const DFN: string): Boolean;
procedure SelectPatient(const DFN: string; var PtSelect: TPtSelect);
function SimilarRecordsFound(const DFN: string; var AMsg: string): Boolean;
function GetDFNFromICN(AnICN: string): string;

{ Encounter specific calls }

function GetEncounterText(const DFN: string; Location: integer; Provider: Int64): TEncounterText;  //*DFN*
function GetActiveICDVersion(ADate: TFMDateTime = 0): String;
function GetICD10ImplementationDate: TFMDateTime;
procedure ListApptAll(Dest: TStrings; const DFN: string; From: TFMDateTime = 0;
                                                         Thru: TFMDateTime = 0);
procedure ListAdmitAll(Dest: TStrings; const DFN: string);
function SubSetOfLocations(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfNewLocs(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfInpatientLocations(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfProvWithClass(const StartFrom: string; Direction: Integer; DateTime: string): TStrings;
function SubSetOfUsersWithClass(const StartFrom: string; Direction: Integer; DateTime: string): TStrings;

{ Remote Data Access calls }
function HasRemoteData(const DFN: string; var ALocations: TStringList): Boolean;
function CheckHL7TCPLink: Boolean;
function GetVistaWebAddress(value: string): string;
function GetVistaWeb_JLV_LabelName: string;

implementation

uses XWBHash, uCore, ShlObj, Windows;

var
  uPtListDfltSort: string = '';                  // Current user's patient selection list default sort order.

{ private calls }

function FormatSSN(const x: string): string;
{ places the dashes in a social security number }
begin
  if Length(x) > 8
    then Result := Copy(x,1,3) + '-' + Copy(x,4,2) + '-' + Copy(x,6,Length(x))
    else Result := x;
end;

function IsSSN(const x: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (Length(x) < 9) or (Length(x) > 10) then Exit;
  for i := 1 to 9 do if not CharInSet(x[i], ['0'..'9']) then Exit;
  Result := True;
end;

function IsFMDate(const x: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Length(x) <> 7 then Exit;
  for i := 1 to 7 do if not CharInSet(x[i], ['0'..'9']) then Exit;
  Result := True;
end;

{ Date/Time functions - not in ORFn because they make server calls to use server time}

function FMToday: TFMDateTime;
{ return the current date in Fileman format }
begin
  Result := Int(FMNow);
end;

function FMNow: TFMDateTime;
{ return the current date/time in Fileman format }
var
  x: string;
begin
  x := sCallV('ORWU DT', ['NOW']);
  Result := StrToFloatDef(x, 0.0);
end;

function MakeRelativeDateTime(FMDateTime: TFMDateTime): string;
var
  Offset: Integer;
  h,n,s,l: Word;
  ADateTime: TDateTime;
  ATime: string;
begin
  Result := '';
  if FMDateTime <= 0 then Exit;
  ADateTime := FMDateTimeToDateTime(FMDateTime);
  Offset := Trunc(Int(ADateTime) - Int(FMDateTimeToDateTime(FMToday)));
  if Offset < 0 then Result := 'T' + IntToStr(Offset)
  else if Offset = 0 then Result := 'T'
  else Result := 'T+' + IntToStr(Offset);
  DecodeTime(ADateTime, h, n, s, l);
  ATime := Format('@%.2d:%.2d', [h, n]);
  if ATime <> '@00:00' then Result := Result + ATime;
end;

function StrToFMDateTime(const AString: string): TFMDateTime;
{ use %DT the validate and convert a string to Fileman format (accepts T, T-1, NOW, etc.) }
var
  x: string;
begin
  x := sCallV('ORWU DT', [AString]);
  Result := StrToFloat(x);
end;

function ValidDateTimeStr(const AString, Flags: string): TFMDateTime;
{ use %DT to validate & convert a string to Fileman format, accepts %DT flags }
begin
  Result := StrToFloat(sCallV('ORWU VALDT', [AString, Flags]));
end;

procedure ListDateRangeClinic(Dest: TStrings);
{ returns date ranges for displaying clinic appointments in patient lookup }
begin
  CallV('ORWPT CLINRNG', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function DfltDateRangeClinic;
{ returns current default date range settings for displaying clinic appointments in patient lookup }
begin
  Result := sCallV('ORQPT DEFAULT CLINIC DATE RANG', [nil]);
end;

{ General calls }

function ExternalName(IEN: Int64; FileNumber: Double): string;
{ returns the external name of the IEN within a file }
begin
  Result := sCallV('ORWU EXTNAME', [IEN, FileNumber]);
end;

function PersonHasKey(APerson: Int64; const AKey: string): Boolean;
begin
  Result := sCallV('ORWU NPHASKEY', [APerson, AKey]) = '1';
end;

function GlobalRefForFile(const FileID: string): string;
begin
  Result := sCallV('ORWU GBLREF', [FileID]);
end;

function SubsetOfGeneric(const StartFrom: string; Direction: Integer; const GlobalRef: string): TStrings;
begin
  CallV('ORWU GENERIC', [StartFrom, Direction, GlobalRef]);
  Result := RPCBrokerV.Results;
end;

function SubsetOfDevices(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of devices (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU DEVICE', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfPersons(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of persons (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

{ User specific calls }

function GetUserInfo: TUserInfo;
{ returns a record of user information,
  Pieces: DUZ^NAME^USRCLS^CANSIGN^ISPROVIDER^ORDERROLE^NOORDER^DTIME^CNTDN^VERORD^NOTIFYAPPS^
          MSGHANG^DOMAIN^SERVICE^AUTOSAVE^INITTAB^LASTTAB^WEBACCESS^ALLOWHOLD^ISRPL^RPLLIST^
          CORTABS^RPTTAB^STATION#^GECStatus^Production account?}
var
  x: string;
begin
  x := sCallV('ORWU USERINFO', [nil]);
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
    IsReportsOnly := false;
    if ((HasRptTab) and (not HasCorTabs)) then
      IsReportsOnly := true;
    // Remove next if and nested if should an "override" later be provided for RPL users,etc.:
    if HasCorTabs then
      if (IsRPL = '1') then
        begin
          IsRPL := '0'; // Hard set for now.
          IsReportsOnly := false;
        end;
    // Following hard set to TRUE per VHA mgt decision:
    ToolsRptEdit := true;
     //    x := GetUserParam('ORWT TOOLS RPT SETTINGS OFF');
     //    if x = '1' then
    //      ToolsRptEdit := false;
  end;
end;

function GetUserParam(const AParamName: string): string;
begin
  Result := sCallV('ORWU PARAM', [AParamName]);
end;

procedure GetUserListParam(Dest: TStrings; const AParamName: string);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
  try
    tCallV(tmplst, 'ORWU PARAMS', [AParamName]);
    FastAssign(tmplst, Dest);
  finally
    tmplst.Free;
  end;
end;

function HasSecurityKey(const KeyName: string): Boolean;
{ returns true if the currently logged in user has a given security key }
var
  x: string;
begin
  Result := False;
  x := sCallV('ORWU HASKEY', [KeyName]);
  if x = '1' then Result := True;
end;

function HasMenuOptionAccess(const OptionName: string): Boolean;
begin
  Result := (sCallV('ORWU HAS OPTION ACCESS', [OptionName]) = '1');
end;

function ValidESCode(const ACode: string): Boolean;
{ returns true if the electronic signature code in ACode is valid }
begin
  Result := sCallV('ORWU VALIDSIG', [Encrypt(ACode)]) = '1';
end;

{ Notifications Calls }

procedure LoadNotifications(Dest: TStrings);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
  try
    //UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
    tCallV(tmplst, 'ORWORB FASTUSER', [nil]);
    FastAssign(tmplst, Dest);
  finally
    tmplst.Free;
  end;
end;

procedure UpdateUnsignedOrderAlerts(PatientDFN: string);
begin
  CallV('ORWORB KILL UNSIG ORDERS ALERT',[PatientDFN]);
end;

function UnsignedOrderAlertFollowup(XQAID: string): string;
begin
  Result := sCallV('ORWORB UNSIG ORDERS FOLLOWUP',[XQAID]);
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
  CallV('ORWORB KILL EXPIR MED ALERT',[PatientDFN]);
end;

procedure UpdateExpiringFlaggedOIAlerts(PatientDFN: string; FollowUp: integer);
begin
  CallV('ORWORB KILL EXPIR OI ALERT',[PatientDFN, FollowUp]);
end;

procedure UpdateUnverifiedMedAlerts(PatientDFN: string);
begin
  CallV('ORWORB KILL UNVER MEDS ALERT',[PatientDFN]);
end;

procedure UpdateUnverifiedOrderAlerts(PatientDFN: string);
begin
  CallV('ORWORB KILL UNVER ORDERS ALERT',[PatientDFN]);
end;

procedure AutoUnflagAlertedOrders(PatientDFN, XQAID: string);
begin
  CallV('ORWORB AUTOUNFLAG ORDERS',[PatientDFN, XQAID]);
end;

procedure DeleteAlert(XQAID: string);
//deletes an alert
begin
  CallV('ORB DELETE ALERT',[XQAID]);
end;

procedure DeleteAlertForUser(XQAID: string);
//deletes an alert
begin
  CallV('ORB DELETE ALERT',[XQAID, True]);
end;

procedure ForwardAlert(XQAID: string; Recip: string; FWDtype: string; Comment: string);
// Forwards an alert with comment to Recip[ient]
begin
   CallV('ORB FORWARD ALERT', [XQAID, Recip, FWDtype, Comment]);
end;

procedure RenewAlert(XQAID: string);
// Restores/renews an alert
begin
   CallV('ORB RENEW ALERT', [XQAID]);
end;

function GetSortMethod: string;
// Returns alert sort method
begin
  Result := sCallV('ORWORB GETSORT',[nil]);
end;

procedure SetSortMethod(Sort: string; Direction: string);
// Sets alert sort method for user
begin
   CallV('ORWORB SETSORT', [Sort, Direction]);
end;

function GetXQAData(XQAID: string): string;
// Returns data associated with an alert
begin
  Result := sCallV('ORWORB GETDATA',[XQAID]);
end;

function  GetTIUAlertInfo(XQAID: string): string;
// Returns DFN and document type associated with a TIU alert
begin
  Result := sCallV('TIU GET ALERT INFO',[XQAID]);
end;

function GetNotificationFollowUpText(PatientDFN: string; Notification: integer; XQADATA: string): TStrings;
// Returns follow-up text for an alert
begin
   CallV('ORWORB TEXT FOLLOWUP', [PatientDFN, Notification, XQADATA]);
   Result := RPCBrokerV.Results;
end;

{ Patient List Calls }

function DfltPtList: string;
{ returns the name of the current user's default patient list, null if none is defined
  Pieces: Ptr to Source File^Source Name^Source Type }
begin
  Result := sCallV('ORQPT DEFAULT LIST SOURCE', [nil]);
  if Length(Result) > 0 then Result := Pieces(Result, U, 2, 3);
end;

function DfltPtListSrc: Char;
begin
  Result := CharAt(sCallV('ORWPT DFLTSRC', [nil]), 1);
end;

procedure SavePtListDflt(const x: string);
begin
  CallV('ORWPT SAVDFLT', [x]);
end;

procedure ListSpecialtyAll(Dest: TStrings);
{ lists all treating specialties: IEN^Treating Specialty Name }
begin
  CallV('ORQPT SPECIALTIES', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListTeamAll(Dest: TStrings);
{ lists all patient care teams: IEN^Team Name }
begin
  CallV('ORQPT TEAMS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListWardAll(Dest: TStrings);
{ lists all active inpatient wards: IEN^Ward Name }
begin
  CallV('ORQPT WARDS', [nil]);
  //MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListProviderTop(Dest: TStrings);
{ checks parameters for list of commonly selected providers }
begin
end;

function SubSetOfProviders(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of providers (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction, 'PROVIDER']);
//  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function SubSetOfCosigners(const StartFrom: string; Direction: Integer; Date: TFMDateTime;
  ATitle: integer; ADocType: integer): TStrings;
{ returns a pointer to a list of cosigners (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  if ATitle > 0 then ADocType := 0;
  // CQ #17218 - Correcting order of parameters for this call - jcs
  //CallV('ORWU2 COSIGNER', [StartFrom, Direction, Date, ATitle, ADocType]);
  CallV('ORWU2 COSIGNER', [StartFrom, Direction, Date, ADocType, ATitle]);

  //  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function SubSetOfProvWithClass(const StartFrom: string; Direction: Integer; DateTime: string): TStrings;
{ returns a pointer to a list of providers (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction, 'PROVIDER', DateTime]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function SubSetOfUsersWithClass(const StartFrom: string; Direction: Integer; DateTime: string): TStrings;
{ returns a pointer to a list of users (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction, '', DateTime]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function SubSetOfActiveAndInactivePersons(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of users (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call!}
begin
  CallV('ORWU NEWPERS', [StartFrom, Direction, '', '', '', True]);  //TRUE = return all active and inactive users
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;


procedure ListClinicTop(Dest: TStrings);
{ checks parameters for list of commonly selected clinics }
begin
end;

function SubSetOfClinics(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of clinics (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU CLINLOC', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function GetDfltSort: string;
{ Assigns uPtLstDfltSort to user's default patient list sort order (string character).}
begin
  uPtListDfltSort := sCallV('ORQPT DEFAULT LIST SORT', [nil]);
  if uPtListDfltSort = '' then uPtListDfltSort := 'A'; // Default is always "A" for alpha.
  result := uPtListDfltSort;
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
    tCallV(tmplst, 'ORQPT DEFAULT PATIENT LIST', [nil]);
    Source := sCallV('ORWPT DFLTSRC', [nil]);
    if Source = 'C' then                    // Clinics.
    begin
      if Sort = 'P' then                    // "Appointments" sort.
        SortByPiece(tmplst, U, 4)
      else
        SortByPiece(tmplst, U, 2);
      for i := 0 to tmplst.Count - 1 do
      begin
        x := tmplst[i];
        ATime := Piece(x, U, 4);
        APlace := Piece(x, U, 3);
        ATime := FormatFMDateTime('hh:nn  dddddd', MakeFMDateTime(ATime));
        SetPiece(x, U, 3, ATime);
        x := x + U + APlace;
        tmplst[i] := x;
      end;
    end
    else
    begin
      SourceType := 0;                      // Default.
      if Source = 'M' then SourceType := 1; // Combinations.
      if Source = 'W' then SourceType := 2; // Wards.
      case SourceType of
        1 : if Sort = 'S' then tmplst.SortByPieces([3, 8, 2]) // "Source" sort.
            else if Sort = 'P' then tmplst.SortByPieces([8, 2]) // "Appointment" sort.
                 else if Sort = 'T' then SortByPiece(tmplst, U, 5) // "Terminal Digit" sort.
                      else SortByPiece(tmplst, U, 2); // "Alphabetical" (also the default) sort.
        2 : if Sort = 'R' then tmplst.SortByPieces([3, 2])
            else SortByPiece(tmplst, U, 2);
      else SortByPiece(tmplst, U, 2);
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
  CallV('ORQPT PROVIDER PATIENTS', [ProviderIEN]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByTeam(Dest: TStrings; TeamIEN: Integer);
{ lists all patients associated with a given team: DFN^Patient Name }
begin
  CallV('ORQPT TEAM PATIENTS', [TeamIEN]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtBySpecialty(Dest: TStrings; SpecialtyIEN: Integer);
{ lists all patients associated with a given specialty: DFN^Patient Name }
begin
  CallV('ORQPT SPECIALTY PATIENTS', [SpecialtyIEN]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByClinic(Dest: TStrings; ClinicIEN: Integer; FirstDt, LastDt: string); //TFMDateTime);
{ lists all patients associated with a given clinic: DFN^Patient Name^App't }
var
  i: Integer;
  x, ATime, APlace, Sort: string;
begin
  Sort := GetDfltSort();
  CallV('ORQPT CLINIC PATIENTS', [ClinicIEN, FirstDt, LastDt]);
  with RPCBrokerV do
  begin
    if Sort = 'P' then
      SortByPiece(TStringList(Results), U, 4)
    else
      SortByPiece(TStringList(Results), U, 2);
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      ATime := Piece(x, U, 4);
      APlace := Piece(x, U, 3);
      ATime := FormatFMDateTime('hh:nn  dddddd', MakeFMDateTime(ATime));
      SetPiece(x, U, 3, ATime);
      x := x + U + APlace;
      Results[i] := x;
    end;
    MixedCaseList(Results);
    FastAssign(Results, Dest);
  end;
end;

procedure ListPtByWard(Dest: TStrings; WardIEN: Integer);
{ lists all patients associated with a given ward: DFN^Patient Name^Room/Bed }
var
  Sort: string;
begin
  Sort := GetDfltSort();
  CallV('ORWPT BYWARD', [WardIEN]);
  if Sort = 'R' then
    SortByPiece(TStringList(RPCBrokerV.Results), U, 3)
  else
    SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByLast5(Dest: TStrings; const Last5: string);
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
{ Lists all patients found in the BS and BS5 xrefs that match Last5: DFN^Patient Name }
  CallV('ORWPT LAST5', [UpperCase(Last5)]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
  begin
    x := Results[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN)    then AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Results[i] := x;
  end;
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByRPLLast5(Dest: TStrings; const Last5: string);
var
  i: Integer;
  x, ADate, AnSSN: string;
begin
{ Lists patients from RPL list that match Last5: DFN^Patient Name }
  CallV('ORWPT LAST5 RPL', [UpperCase(Last5)]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
  begin
    x := Results[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN)    then AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Results[i] := x;
  end;
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByFullSSN(Dest: TStrings; const FullSSN: string);
{ lists all patients found in the SSN xref that match FullSSN: DFN^Patient Name }
var
  i: integer;
  x, ADate, AnSSN: string;
begin
  x := FullSSN;
  i := Pos('-', x);
  while i > 0 do
  begin
    x := Copy(x, 1, i-1) + Copy(x, i+1, 12);
    i := Pos('-', x);
  end;
  CallV('ORWPT FULLSSN', [UpperCase(x)]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
  begin
    x := Results[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN)    then AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Results[i] := x;
  end;
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtByRPLFullSSN(Dest: TStrings; const FullSSN: string);
{ lists all patients found in the SSN xref that match FullSSN: DFN^Patient Name }
var
  i: integer;
  x, ADate, AnSSN: string;
begin
  x := FullSSN;
  i := Pos('-', x);
  while i > 0 do
  begin
    x := Copy(x, 1, i-1) + Copy(x, i+1, 12);
    i := Pos('-', x);
  end;
  CallV('ORWPT FULLSSN RPL', [UpperCase(x)]);
  SortByPiece(TStringList(RPCBrokerV.Results), U, 2);
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
  begin
    x := Results[i];
    ADate := Piece(x, U, 3);
    AnSSN := Piece(x, U, 4);
    if IsFMDate(ADate) then ADate := FormatFMDateTimeStr('mmm d, yyyy', ADate);
    if IsSSN(AnSSN)    then AnSSN := FormatSSN(AnSSN);
    SetPiece(x, U, 3, AnSSN + '   ' + ADate);
    Results[i] := x;
  end;
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPtTop(Dest: TStrings);
{ currently returns the last patient selected }
begin
  CallV('ORWPT TOP', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function SubSetOfPatients(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of patients (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWPT LIST ALL', [StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function MakeRPLPtList(RPLList: string): string;
{ Creates "RPL" Restricted Patient List based on Team List info in user's record. }
begin
  result := sCallV('ORQPT MAKE RPL', [RPLList]);
end;

function ReadRPLPtList(RPLJobNumber: string; const StartFrom: string; Direction: Integer) : TStrings;
{ returns a pointer to a list of patients (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORQPT READ RPL', [RPLJobNumber, StartFrom, Direction]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

procedure KillRPLPtList(RPLJobNumber: string);
begin
  CallV('ORQPT KILL RPL', [RPLJobNumber]);
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

procedure CheckSensitiveRecordAccess(const DFN: string; var AccessStatus: Integer;
  var MessageText: string);
begin
  CallV('DG SENSITIVE RECORD ACCESS', [DFN]);
  AccessStatus := -1;
  MessageText := '';
  with RPCBrokerV do
  begin
    if Results.Count > 0 then
    begin
      AccessStatus := StrToIntDef(Results[0], -1);
      Results.Delete(0);
      if Results.Count > 0 then MessageText := Results.Text;
    end;
  end;
end;

procedure CheckRemotePatient(var Dest: string; Patient, ASite: string; var AccessStatus: Integer);

begin
  CallV('XWB DIRECT RPC', [ASite, 'ORWCIRN RESTRICT', 0, Patient]);
  AccessStatus := -1;
  Dest := '';
  with RPCBrokerV do
  begin
    if Results.Count > 0 then
      begin
        if Results[0] = '' then Results.Delete(0);
      end;
    if Results.Count > 0 then
      begin
        if (length(piece(Results[0],'^',2)) > 0) and ((StrToIntDef(piece(Results[0],'^',1),0) = -1)) then
          begin
            AccessStatus := -1;
            Dest := piece(Results[0],'^',2);
          end
        else
          begin
            AccessStatus := StrToIntDef(Results[0], -1);
            Results.Delete(0);
            if Results.Count > 0 then Dest := Results.Text;
          end;
      end;
  end;
end;

procedure CurrentLocationForPatient(const DFN: string; var ALocation: Integer; var AName: string; var ASvc: string);
var
  x: string;
begin
  x := sCallV('ORWPT INPLOC', [DFN]);
  ALocation := StrToIntDef(Piece(x, U, 1), 0);
  AName := Piece(x, U, 2);
  ASvc := Piece(x, U, 3);
end;

function DateOfDeath(const DFN: string): TFMDateTime;
{ returns 0 or the date a patient died }
begin
  Result := MakeFMDateTime(sCallV('ORWPT DIEDON', [DFN]));
end;

function GetPtIDInfo(const DFN: string): TPtIDInfo;  //*DFN*
{ returns the identifiers displayed upon patient selection
  Pieces: SSN[1]^DOB[2]^SEX[3]^VET[4]^SC%[5]^WARD[6]^RM-BED[7]^NAME[8] }
var
  x: string;
begin
  x := sCallV('ORWPT ID INFO', [DFN]);
  with Result do                                    // map string into TPtIDInfo record
  begin
    Name := MixedCase(Piece(x, U, 8));                                  // Name
    SSN  := Piece(x, U, 1);
    DOB  := Piece(x, U, 2);
    Age  := '';
    if IsSSN(SSN)    then SSN := FormatSSN(Piece(x, U, 1));                // SSN (PID)
    if IsFMDate(DOB) then DOB := FormatFMDateTimeStr('dddddd', DOB);  // Date of Birth
    //Age := IntToStr(CalcAge(MakeFMDateTime(Piece(x, U, 2))));            // Age
    Sex := Piece(x, U, 3);                                                 // Sex
    if Length(Sex) = 0 then Sex := 'U';
    case Sex[1] of
    'F','f': Sex := 'Female';
    'M','m': Sex := 'Male';
    else     Sex := 'Unknown';
    end;
    if Piece(x, U, 4) = 'Y' then Vet := 'Veteran' else Vet := '';       // Veteran?
    if Length(Piece(x, U, 5)) > 0                                       // % Service Connected
      then SCSts := Piece(x, U, 5) + '% Service Connected'
      else SCSts := '';
    Location := Piece(x, U, 6);                                         // Inpatient Location
    RoomBed  := Piece(x, U, 7);                                         // Inpatient Room-Bed
  end;
end;

function HasLegacyData(const DFN: string; var AMsg: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  AMsg := '';
  CallV('ORWPT LEGACY', [DFN]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    Result := Results[0] = '1';
    for i := 1 to Results.Count - 1 do AMsg := AMsg + Results[i] + CRLF;
  end;
end;

function LogSensitiveRecordAccess(const DFN: string): Boolean;
begin
  Result := sCallV('DG SENSITIVE RECORD BULLETIN', [DFN]) = '1';
end;

function MeansTestRequired(const DFN: string; var AMsg: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  AMsg := '';
  CallV('DG CHK PAT/DIV MEANS TEST', [DFN]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    Result := Results[0] = '1';
    for i := 1 to Results.Count - 1 do AMsg := AMsg + Results[i] + CRLF;
  end;
end;

function RestrictedPtRec(const DFN: string): Boolean;  //*DFN*
{ returns true if the record for a patient identified by DFN is restricted }
begin
  Result := Piece(sCallV('ORWPT SELCHK', [DFN]), U, 1) = '1';
end;

procedure SelectPatient(const DFN: string; var PtSelect: TPtSelect);   //*DFN*
{ selects the patient (updates DISV, calls Pt Select actions) & returns key fields
  Pieces: NAME[1]^SEX[2]^DOB[3]^SSN[4]^LOCIEN[5]^LOCNAME[6]^ROOMBED[7]^CWAD[8]^SENSITIVE[9]^
          ADMITTIME[10]^CONVERTED[11]^SVCONN[12]^SC%[13]^ICN[14]^Age[15]^TreatSpec[16] }
var
  x: string;
begin
  x := sCallV('ORWPT SELECT', [DFN]);
  with PtSelect do
  begin
    Name := Piece(x, U, 1);
    ICN := Piece(x, U, 14);
    SSN := FormatSSN(Piece(x, U, 4));
    DOB := MakeFMDateTime(Piece(x, U, 3));
    Age := StrToIntDef(Piece(x, U, 15), 0);
    //Age := CalcAge(DOB, DateOfDeath(DFN));
    if Length(Piece(x, U, 2)) > 0 then Sex := Piece(x, U, 2)[1] else Sex := 'U';
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
  x := sCallV('ORWPT1 PRCARE', [DFN]);
  with PtSelect do
  begin
    PrimaryTeam     := Piece(x, U, 1);
    PrimaryProvider := Piece(x, U, 2);
    Associate := Piece(x, U, 4);
    MHTC := Piece(x, U, 5);
    if Length(Location) > 0 then
      begin
        Attending := Piece(x, U, 3);
        InProvider := Piece(x, U, 6);
        x := sCallV('ORWPT INPLOC', [DFN]);
        WardService := Piece(x, U, 3);
      end;
  end;
end;

function SimilarRecordsFound(const DFN: string; var AMsg: string): Boolean;
begin
  Result := False;
  AMsg := '';
  CallV('DG CHK BS5 XREF Y/N', [DFN]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    Result := Results[0] = '1';
    Results.Delete(0);
    AMsg := Results.Text;
  end;
  (*
  CallV('DG CHK BS5 XREF ARRAY', [DFN]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    Result := Results[0] = '1';
    for i := 1 to Results.Count - 1 do
    begin
      if Piece(Results[i], U, 1) = '0' then AMsg := AMsg + Copy(Results[i], 3, Length(Results[i])) + CRLF;
      if Piece(Results[i], U, 1) = '1' then AMsg := AMsg + Piece(Results[i], U, 3) + #9 +
        FormatFMDateTimeStr('mmm dd,yyyy', Piece(Results[i], U, 4)) + #9 + Piece(Results[i], U, 5) + CRLF;
    end;
  end;
  *)
end;

function GetDFNFromICN(AnICN: string): string;
begin
  Result := Piece(sCallV('VAFCTFU CONVERT ICN TO DFN', [AnICN]), U, 1);
end;

{ Encounter specific calls }

function GetEncounterText(const DFN: string; Location: integer; Provider: Int64): TEncounterText;  //*DFN*
{ returns resolved external values  Pieces: LOCNAME[1]^PROVNAME[2]^ROOMBED[3] }
var
  x: string;
begin
  x := sCallV('ORWPT ENCTITL', [DFN, Location, Provider]);
  with Result do
  begin
    LocationName := Piece(x, U, 1);
    LocationAbbr := Piece(x, U, 2);
    RoomBed      := Piece(x, U, 3);
    ProviderName := Piece(x, U, 4);    
//    ProviderName := sCallV('ORWU1 NAMECVT', [Provider]);
 end;
end;

function  GetActiveICDVersion(ADate: TFMDateTime = 0): String;
begin
  Result := sCallV('ORWPCE ICDVER', [ADate]);
end;

function GetICD10ImplementationDate: TFMDateTime;
var
  impDt: String;
begin
  impDt := sCallV('ORWPCE I10IMPDT', [nil]);
  if impDt <> '' then
    Result := StrToFMDateTime(impDt)
  else
    Result := 0;
end;

procedure ListApptAll(Dest: TStrings; const DFN: string; From: TFMDateTime = 0;
                                                         Thru: TFMDateTime = 0);
{ lists appts/visits for a patient (uses same call as cover sheet)
  V|A;DateTime;LocIEN^DateTime^LocName^Status }
const
  SKIP_ADMITS = 1;
begin
  CallV('ORWCV VST', [Patient.DFN, From, Thru, SKIP_ADMITS]);
  with RPCBrokerV do
  begin
    InvertStringList(TStringList(Results));
    MixedCaseList(Results);
    SetListFMDateTime('dddddd hh:nn', TStringList(Results), U, 2);
    FastAssign(Results, Dest);
  end;
  (*
  CallV('ORWPT APPTLST', [DFN]);
  with RPCBrokerV do
  begin
    SortByPiece(TStringList(Results), U, 1);
    InvertStringList(TStringList(Results));
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      ATime := Piece(x, U, 1);
      ATime := FormatFMDateTime('mmm dd, yyyy hh:nn', MakeFMDateTime(ATime));
      SetPiece(x, U, 5, ATime);
      Results[i] := x;
    end;
    FastAssign(Results, Dest);
  end;
  *)
end;

procedure ListAdmitAll(Dest: TStrings; const DFN: string);  //*DFN*
{ lists all admissions for a patient: MovementTime^LocIEN^LocName^Type }
var
  i: Integer;
  ATime, x: string;
begin
  CallV('ORWPT ADMITLST', [DFN]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      ATime := Piece(x, U, 1);
      ATime := FormatFMDateTime('dddddd hh:nn', MakeFMDateTime(ATime));
      SetPiece(x, U, 5, ATime);
      Results[i] := x;
    end;
    FastAssign(Results, Dest);
  end;
end;

function SubSetOfLocations(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of locations (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU HOSPLOC', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfNewLocs(const StartFrom: string; Direction: Integer): TStrings;
{ Returns a pointer to a list of locations (for use in a long list box) -  the return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call!
  Filtered by C, W, and Z types - i.e., Clinics, Wards, and "Other" type locations.}
begin
  CallV('ORWU1 NEWLOC', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfInpatientLocations(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of locations (for use in a long list box) -  The return value is
  a pointer to RPCBrokerV.Results, so the data must be used BEFORE the next broker call! }
begin
  CallV('ORWU INPLOC', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

{ Remote Data Access calls }

function HasRemoteData(const DFN: string; var ALocations: TStringList): Boolean;
begin
  CallV('ORWCIRN FACLIST', [DFN]);
  FastAssign(RPCBrokerV.Results, ALocations);
  Result := not (Piece(RPCBrokerV.Results[0], U, 1) = '-1');

//   '-1^NO DFN'
//   '-1^PATIENT NOT IN DATABASE'
//   '-1^NO MPI Node'
//   '-1^NO ICN'
//   '-1^Parameter missing.'
//   '-1^No patient DFN.'
//   '-1^Could not find Treating Facilities'
//   '-1^Remote access not allowed'     <===parameter ORWCIRN REMOTE DATA ALLOW
end;

function CheckHL7TCPLink: Boolean;
 begin
   CallV('ORWCIRN CHECKLINK',[nil]);
   Result := RPCBrokerV.Results[0] = '1';
 end;

function GetVistaWebAddress(value: string): string;
begin
  CallV('ORWCIRN WEBADDR', [value]);
  result := RPCBrokerV.Results[0];
end;

function GetVistaWeb_JLV_LabelName: string;
begin
  result := sCallV('ORWCIRN JLV LABEL', [nil]);
end;

function GetDefaultPrinter(DUZ: Int64; Location: integer): string;
begin
  Result := sCallV('ORWRP GET DEFAULT PRINTER', [DUZ, Location]) ;
end;

end.

unit rODMeds;

interface

uses SysUtils, Classes, ORNet, ORFn, uCore, uConst, Windows;

type
   TAdminTimeHelpText = record
    HelpText: string;
  end;

  TInpatientClozapineText = record
    dispText: string;
  end;

  TDrugHasMaxData = record
    CaptureMaxData: boolean;
    MaxSupply: integer;
    MaxQuantity: integer;
    MaxRefills: integer;
  end;

function DEACheckFailed(AnOI: Integer; ForInpatient: Boolean): string;
function DEACheckFailedAtSignature(AnOI: Integer; ForInpatient: Boolean): string;
function DEACheckFailedForIVOnOutPatient(AnOI: Integer; AnOIType: Char): string;
procedure ListForOrderable(var AListIEN, ACount: Integer; const DGrpNm: string);
procedure SubsetOfOrderable(Dest: TStringList; Append: Boolean; ListIEN, First, Last: Integer);
function IndexOfOrderable(ListIEN: Integer; From: string): Integer;
procedure IsActivateOI(var AMsg: string; theOI: integer);
procedure ListForQuickOrders(var AListIEN, ACount: Integer; const DGrpNm: string);
procedure SubsetOfQuickOrders(Dest: TStringList; AListIEN, First, Last: Integer);
function IndexOfQuickOrder(AListIEN: Integer; From: string): Integer;
procedure LoadFormularyAltOI(AList: TStringList; AnIEN: Integer; ForInpatient: Boolean);
procedure LoadFormularyAltDose(AList: TStringList; DispDrug, OI: Integer; ForInpatient: Boolean);
procedure LoadAdminInfo(const Schedule: string; OrdItem: Integer; var StartText: string;
  var AdminTime: TFMDateTime; var Duration: string; Admin: string = '');
function GetAdminTime(const StartText, Schedule: string; OrdItem: Integer): TFMDateTime;
procedure LoadSchedules(Dest: TStrings; IsInptDlg: boolean = False);
procedure LoadDOWSchedules(Dest: TStrings);
procedure LoadAllIVRoutes(Dest: TStrings);
procedure LoadDosageFormIVRoutes(Dest: TStrings; OrderIDs: TStringList);
function GetDefaultAddFreq(OID: integer): string;
function QtyToDays(Quantity: Double;   const UnitsPerDose, Schedule, Duration, Drug: string): Integer;
function DaysToQty(DaysSupply: Integer; const UnitsPerDose, Schedule, Duration, Drug: string): Integer;
function DurToQty(DaysSupply: Integer; const UnitStr, SchedStr: string): Integer;
function DefaultDays(const ADrug, UnitStr, SchedStr: string; OI : Integer): Integer;
function CalcMaxRefills(const Drug: string; Days, OrdItem: Integer; Discharge: Boolean): Integer;
function ScheduleRequired(OrdItem: Integer; const ARoute, ADrug: string): Boolean;
function ODForMedsIn: TStrings;
function ODForMedsOut: TStrings;
function OIForMed(AnIEN: Integer; ForInpatient: Boolean; HavePI: boolean = True; PKIActive: Boolean = False): TStrings;
function GetPickupForLocation(const Loc: string): string;
function QOHasRouteDefined(AQOID: integer): boolean;
procedure CheckExistingPI(AOrderId: string; var APtI: string);
function PassDrugTest(OI: integer; OrderType: string; InptOrder: boolean; CheckForClozapineOnly: boolean = false): boolean;
function AdminTimeHelpText(): string;
//function ValidateDaySupplyandQuantity(DaySupply, Quantity: integer): boolean;
//function ValidateMaxQuantity(Quantity: integer): boolean;
function ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur: string; OI, tempSupply, tempRefills: integer; tempQuantity: Double): boolean;
function ValidateDaySupplyandQuantityErrorMsg(DaySupply, quantity: integer): String;
procedure ClearMaxData;
function DifferentOrderLocations(ID: string; Loc: integer): boolean;
function IsClozapineOrder: boolean;
//function ValidateQuantityErrorMsg(Quantity: integer): String;
function GetQOOrderableItem(DialogIEN: string): integer;


implementation
 var
  uAdminTimeHelpText: TAdminTimeHelpText;
  uDrugHasMaxData: TDrugHasMaxData;
  uInpatientClozapineText : TInpatientClozapineText;

function DEACheckFailed(AnOI: Integer; ForInpatient: Boolean): string;
var
  PtType: Char;
begin
  if ForInpatient then PtType := 'I' else PtType := 'O';
  Result := sCallV('ORWDPS1 FAILDEA', [AnOI, Encounter.Provider, PtType]);
end;

function DEACheckFailedAtSignature(AnOI: Integer; ForInpatient: Boolean): string;
var
  PtType: Char;
begin
  if ForInpatient then PtType := 'I' else PtType := 'O';
  Result := sCallV('ORWDPS1 FAILDEA', [AnOI, User.DUZ, PtType]);
end;

function DEACheckFailedForIVOnOutPatient(AnOI: Integer; AnOIType: Char): string;
begin
  Result := sCallV('ORWDPS1 IVDEA',[AnOI,AnOIType,Encounter.Provider]);
end;

procedure ListForOrderable(var AListIEN, ACount: Integer; const DGrpNm: string);
begin
  CallV('ORWUL FV4DG', [DGrpNm]);
  AListIEN := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 1), 0);
  ACount   := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 2), 0);
end;

procedure SubsetOfOrderable(Dest: TStringList; Append: Boolean; ListIEN, First, Last: Integer);
var
  i: Integer;
begin
  CallV('ORWUL FVSUB', [ListIEN, First+1, Last+1]);  // M side not 0-based
  if Append then FastAddStrings(RPCBrokerV.Results, Dest) else
  begin
    for i := Pred(RPCBrokerV.Results.Count) downto 0 do Dest.Insert(0, RPCBrokerV.Results[i]);
  end;
end;

function IndexOfOrderable(ListIEN: Integer; From: string): Integer;
var
  x: string;
begin
  Result := -1;
  if From = '' then Exit;
  // decrement last char & concat '~' for $ORDER on M side, limit string length
  x := UpperCase(Copy(From, 1, 220));
  x := Copy(x, 1, Length(x) - 1) + Pred(x[Length(x)]) + '~';
  x := sCallV('ORWUL FVIDX', [ListIEN, x]);
  // use Pred to make the index 0-based (first value = 1 on M side)
  if CompareText(Copy(Piece(x, U, 2), 1, Length(From)), From) = 0
    then Result := Pred(StrToIntDef(Piece(x, U, 1), 0));
end;

procedure IsActivateOI(var AMsg: string; theOI: integer);
begin
  AMsg := SCallV('ORWDXA ISACTOI', [theOI]);
end;

procedure ListForQuickOrders(var AListIEN, ACount: Integer; const DGrpNm: string);
begin
  CallV('ORWUL QV4DG', [DGrpNm]);
  AListIEN := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 1), 0);
  ACount   := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 2), 0);
end;

procedure SubsetOfQuickOrders(Dest: TStringList; AListIEN, First, Last: Integer);
var
  i: Integer;
begin
 CallV('ORWUL QVSUB', [AListIEN,'','']);
 for i := 0 to RPCBrokerV.Results.Count -1 do
   Dest.Add(RPCBrokerV.Results[i]);
end;

function IndexOfQuickOrder(AListIEN: Integer; From: string): Integer;
var
  x: string;
begin
  Result := -1;
  if From = '' then Exit;
  // decrement last char & concat '~' for $ORDER on M side, limit string length
  x := UpperCase(Copy(From, 1, 220));
  x := Copy(x, 1, Length(x) - 1) + Pred(x[Length(x)]) + '~';
  x := sCallV('ORWUL QVIDX', [AListIEN, x]);
  // use Pred to made the index 0-based (first value = 1 on M side)
  if CompareText(Copy(Piece(x, U, 2), 1, Length(From)), From) = 0
    then Result := Pred(StrToIntDef(Piece(x, U, 1), 0));
end;

procedure LoadFormularyAltOI(AList: TStringList; AnIEN: Integer; ForInpatient: Boolean);
var
  PtType: Char;
begin
  if ForInpatient then PtType := 'I' else PtType := 'O';
  CallV('ORWDPS1 FORMALT', [AnIEN, PtType]);
  FastAssign(RPCBrokerV.Results, AList);
end;

procedure LoadFormularyAltDose(AList: TStringList; DispDrug, OI: Integer; ForInpatient: Boolean);
var
  PtType: Char;
begin
  if ForInpatient then PtType := 'I' else PtType := 'O';
  CallV('ORWDPS1 DOSEALT', [DispDrug, OI, PtType]);
  FastAssign(RPCBrokerV.Results, AList);
end;

procedure LoadAdminInfo(const Schedule: string; OrdItem: Integer; var StartText: string;
  var AdminTime: TFMDateTime; var Duration: string; Admin: string = '');
var
  x: string;
begin
  x := sCallV('ORWDPS2 ADMIN', [Patient.DFN, Schedule, OrdItem, Encounter.Location, Admin]);
  StartText := Piece(x, U, 1);
  AdminTime := MakeFMDateTime(Piece(x, U, 4));
  Duration  := Piece(x, U, 3);
end;

function GetAdminTime(const StartText, Schedule: string; OrdItem: Integer): TFMDateTime;
var
  x: string;
begin
  x := sCallV('ORWDPS2 REQST', [Patient.DFN, Schedule, OrdItem, Encounter.Location, StartText]);
  Result := MakeFMDateTime(x);
end;

procedure LoadSchedules(Dest: TStrings; IsInptDlg: boolean);
begin
  // if uMedSchedules = nil then CallV('ORWDPS ALLSCHD', [nil]); uMedSchedules.Assign(...);
  CallV('ORWDPS1 SCHALL', [patient.dfn, patient.location]);
  FastAssign(RPCBrokerV.Results, Dest);
  If (Dest.IndexOfName('OTHER') < 0) and IsInptDlg then
    Dest.Add('OTHER');
end;

procedure LoadAllIVRoutes(Dest: TStrings);
begin
  CallV('ORWDPS32 ALLIVRTE', []);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadDosageFormIVRoutes(Dest: TStrings; OrderIDs: TStringList);
begin
  CallV('ORWDPS33 IVDOSFRM', [OrderIDs, False]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function GetDefaultAddFreq(OID: integer): string;
begin
  result := sCallV('ORWDPS33 GETADDFR', [OID]);
end;

procedure LoadDOWSchedules(Dest: TStrings);
begin
  // if uMedSchedules = nil then CallV('ORWDPS ALLSCHD', [nil]); uMedSchedules.Assign(...);
  CallV('ORWDPS1 DOWSCH', [patient.dfn, patient.location]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function QtyToDays(Quantity: Double;   const UnitsPerDose, Schedule, Duration, Drug: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDPS2 QTY2DAY',
    [Quantity,   UnitsPerDose, Schedule, Duration, Patient.DFN, Drug]), 0);
end;

function DaysToQty(DaysSupply: Integer; const UnitsPerDose, Schedule, Duration, Drug: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDPS2 DAY2QTY',
    [DaysSupply, UnitsPerDose, Schedule, Duration, Patient.DFN, Drug]), 0);
  if uDrugHasMaxData.CaptureMaxData = True then uDrugHasMaxData.MaxQuantity := Result;
end;

function DurToQty(DaysSupply: Integer; const UnitStr, SchedStr: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDPS2 DAY2QTY', [DaysSupply, UnitStr, SchedStr]), 0);
end;

function DefaultDays(const ADrug, UnitStr, SchedStr: string; OI : Integer): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDPS1 DFLTSPLY', [UnitStr, SchedStr, Patient.DFN, ADrug, OI]), 0);
  if uDrugHasMaxData.CaptureMaxData = True then uDrugHasMaxData.MaxSupply := Result;
end;

function CalcMaxRefills(const Drug: string; Days, OrdItem: Integer; Discharge: Boolean): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDPS2 MAXREF', [Patient.DFN, Drug, Days, OrdItem, Discharge]), 0);
  if uDrugHasMaxData.CaptureMaxData = True then uDrugHasMaxData.MaxRefills := Result;
end;

function ScheduleRequired(OrdItem: Integer; const ARoute, ADrug: string): Boolean;
begin
  Result := sCallV('ORWDPS2 SCHREQ', [OrdItem, ARoute, ADrug]) = '1';
end;

function ODForMedsIn: TStrings;
{ Returns init values for inpatient meds dialog.  The results must be used immediately. }
begin
  CallV('ORWDPS1 ODSLCT', [PST_UNIT_DOSE, Patient.DFN, Encounter.Location]);
  Result := RPCBrokerV.Results;
end;

function ODForMedsOut: TStrings;
{ Returns init values for outpatient meds dialog.  The results must be used immediately. }
begin
  CallV('ORWDPS1 ODSLCT', [PST_OUTPATIENT, Patient.DFN, Encounter.Location]);
  Result := RPCBrokerV.Results;
end;

function OIForMed(AnIEN: Integer; ForInpatient: Boolean; HavePI: Boolean; PKIActive: Boolean): TStrings;
var
  PtType: Char;
  NeedPI: Char;
  IsPKIActive: Char;
begin
  if HavePI then NeedPI := 'Y' else NeedPI := 'N';
  if ForInpatient then PtType := 'U' else PtType := 'O';
  if PKIActive then IsPKIActive := 'Y' else IsPKIActive := 'N';
  CallV('ORWDPS2 OISLCT', [AnIEN, PtType, Patient.DFN, NeedPI, IsPKIActive]);
  Result := RPCBrokerV.Results;
end;

function GetPickupForLocation(const Loc: string): string;
begin
  Result := sCallV('ORWDPS1 LOCPICK',[Loc]);
end;

function QOHasRouteDefined(AQOID: integer): boolean;
begin
  Result := False;
  if ( sCallV('ORWDPS1 HASROUTE',[AQOID])='1' ) then
    Result := True;
end;

procedure CheckExistingPI(AOrderId: string; var APtI: string);
begin
  APtI := sCallV('ORWDPS2 CHKPI', [AOrderId]);
end;

function PassDrugTest(OI: integer; OrderType: string; InptOrder: boolean; CheckForClozapineOnly: boolean = false): boolean;
var
MessCap, MessText: string;
i: integer;
begin
  result := false;
  MessText := '';
  uDrugHasMaxData.CaptureMaxData := false;
  uDrugHasMaxData.MaxSupply := 0;
  uDrugHasMaxData.MaxQuantity := 0;
  uDrugHasMaxData.MaxRefills := 0;
  CallV('ORALWORD ALLWORD', [Patient.DFN, OI, OrderType, Encounter.Provider]);
  for i := 0 to RPCBrokerV.Results.Count -1 do
    begin
      if i = 0 then
        begin
          MessCap := Piece(RPCBrokerV.Results.strings[i],U,1);
          if Piece(RPCBrokerV.Results.strings[i],U,2) = '1' then uDrugHasMaxData.CaptureMaxData := True;
        end;
      if i >0 then MessText := MessText + RPCBrokerV.Results.Strings[i] + CRLF;
    end;
  if CheckForClozapineOnly = True then
    begin
      Result := uDrugHasMaxData.CaptureMaxData = True;
      Exit;
    end;
  if (MessText = '') and (MessCap = '') then
    begin
      Result := True;
      if (InptOrder = true) and (uDrugHasMaxData.CaptureMaxData = true) then
        begin
          uDrugHasMaxData.CaptureMaxData := false;
          if uInpatientClozapineText.dispText = '' then
            begin
              CallV('ORDDPAPI CLOZMSG', []);
              for i := 0 to RPCBrokerV.Results.Count -1 do
                 if i = 0 then uInpatientClozapineText.dispText := RPCBrokerV.Results.Strings[i]
                 else uInpatientClozapineText.dispText := uInpatientClozapineText.dispText + CRLF + RPCBrokerV.Results.Strings[i];
            end;
          if uInpatientClozapineText.dispText <> '' then infoBox(uInpatientClozapineText.dispText, 'Inpatient Drug Warning', MB_OK);
        end;
      exit;
    end;
  infoBox(MessText, MessCap,MB_OK);
end;

function AdminTimeHelpText(): string;
var
i: integer;
begin
      if uAdminTimeHelpText.HelpText = '' then
       begin
          CallV('ORDDPAPI ADMTIME',[]);
          for I := 0 to RPCBrokerV.Results.Count - 1 do
            if I = 0 then uAdminTimeHelpText.HelpText := RPCBrokerV.Results.Strings[i]
            else uAdminTimeHelpText.HelpText := uAdminTimeHelpText.HelpText + CRLF +RPCBrokerV.Results.Strings[i];
       end;
   Result := uAdminTimeHelpText.helpText
end;

function ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur: string; OI, tempSupply, tempRefills: integer; tempQuantity: Double): boolean;
var
daySupply, Refills: integer;
Quantity: Double;
begin
  Result := True;
  if uDrugHasMaxData.CaptureMaxData = false then exit;
  daySupply := DefaultDays(tempDrug, tempUnit, tempSch, OI);
  if (tempSupply > daySupply) and (uDrugHasMaxData.MaxSupply > 0) then
    begin
      infoBox('For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxSupply), 'Cannot Save Error', MB_OK);
      Result := false;
      uDrugHasMaxData.CaptureMaxData := false;
      Exit;
    end;
  Quantity := DaysToQty(daySupply, tempUnit, tempSch, tempDur, tempDrug);
  if (tempQuantity > Quantity) and (uDrugHasMaxData.MaxQuantity > 0) then
    begin
      infoBox('For this medication Quantity cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity), 'Cannot Save Error', MB_OK);
      Result := false;
      uDrugHasMaxData.CaptureMaxData := false;
      Exit;
    end;
  Refills := CalcMaxRefills(tempDrug, daySupply, OI, false);
  if tempRefills > Refills then
    begin
      infoBox('For this medication Quantity cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxRefills), 'Cannot Save Error', MB_OK);
      Result := false;
      uDrugHasMaxData.CaptureMaxData := false;
      Exit;
    end;
end;

function ValidateDaySupplyandQuantity(DaySupply, Quantity: integer): boolean;
var
str: string;
begin
  Result := True;
  str := '';
  if uDrugHasMaxData.CaptureMaxData = false then exit;
  if (daySupply > uDrugHasMaxData.MaxSupply) and (uDrugHasMaxData.MaxSupply > 0) then
    begin
      str := 'For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxSupply);
      Result := false;
    end;
  if (Quantity > uDrugHasMaxData.MaxQuantity) and (uDrugHasMaxData.MaxQuantity > 0) then
    begin
      if str <> '' then str := str + CRLF + 'For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity)
      else str := 'For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity);
      result := false;
    end;
 if str <> '' then infoBox(str, 'Cannot Save Error', MB_OK);
 //uDrugHasMaxData.CaptureMaxData := false;
end;

function ValidateMaxQuantity(Quantity: integer): boolean;
begin
  Result := True;
  if uDrugHasMaxData.CaptureMaxData = false then exit;
  if uDrugHasMaxData.MaxQuantity = 0 then exit;
  if Quantity > uDrugHasMaxData.MaxQuantity then
    begin
      infoBox('For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity), 'Cannot Save Error', MB_OK);
      Result := false;
    end;
end;

function ValidateDaySupplyandQuantityErrorMsg(DaySupply, quantity: integer): String;
begin
  Result := '';
  if uDrugHasMaxData.CaptureMaxData = false then exit;
  if (daySupply > uDrugHasMaxData.MaxSupply) and (uDrugHasMaxData.MaxSupply > 0) then
    begin
      Result := 'For this medication Day Supply cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxSupply);
    end;
  if (Quantity > uDrugHasMaxData.MaxQuantity) and (uDrugHasMaxData.MaxQuantity > 0) then
    begin
      if Result <> '' then Result := Result + CRLF + 'For this medication Quantity cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity)
      else Result := 'For this medication Quantity cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity);
    end;
  //uDrugHasMaxData.CaptureMaxData := false;
end;

function ValidateQuantityErrorMsg(Quantity: integer): String;
begin
  Result := '';
  if uDrugHasMaxData.CaptureMaxData = false then exit;
  if uDrugHasMaxData.MaxQuantity = 0 then exit;
  if Quantity > uDrugHasMaxData.MaxQuantity then
    begin
      Result := 'For this medication Quantity cannot be greater then ' + InttoStr(uDrugHasMaxData.MaxQuantity);
    end;
end;

procedure ClearMaxData;
begin
  uDrugHasMaxData.CaptureMaxData := false;
end;

function DifferentOrderLocations(ID: string; Loc: integer): boolean;
begin
   Result := (sCallV('ORWDPS33 COMPLOC', [ID, Loc])='1');
end;

function IsClozapineOrder: boolean;
begin
   if uDrugHasMaxData.CaptureMaxData = true then result := true
   else result := false;
end;

function GetQOOrderableItem(DialogIEN: string): integer;
begin
  Result := StrtoInt(SCallV('ORWDPS1 QOMEDALT',[DialogIEN]))
end;

end.

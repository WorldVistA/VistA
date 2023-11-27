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
    MaxQuantity: Double;
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
procedure LoadInfusionIndications(Dest: TStrings; OrderIDs: TStringList);
function GetDefaultAddFreq(OID: integer): string;
function QtyToDays(Quantity: Double;   const UnitsPerDose, Schedule, Duration, Drug: string): Integer;
function DaysToQty(DaysSupply: Integer; const UnitsPerDose, Schedule, Duration, Drug: string): Double;
function DurToQty(DaysSupply: Integer; const UnitStr, SchedStr: string): Integer;
function DefaultDays(const ADrug, UnitStr, SchedStr: string; OI : Integer): Integer;
function CalcMaxRefills(Drug: string; Days, OrdItem: Integer;
                  Discharge: boolean; Titration: boolean): integer;
procedure ClearOutPtMedsRPCCache;
function ScheduleRequired(OrdItem: Integer; const ARoute, ADrug: string): Boolean;
function ODForMedsIn(aReturn: TStrings): integer;
function ODForMedsOut(aReturn: TStrings): integer;
function OIForMed(aReturn: TStrings; AnIEN: Integer; ForInpatient: Boolean; HavePI: boolean = True; PKIActive: Boolean = False): integer;
function GetPickupForLocation(const Loc: string): string;
function QOHasRouteDefined(AQOID: integer): boolean;
procedure CheckExistingPI(AOrderId: string; var APtI: string);
function PassDrugTest(OI: integer; OrderType: string; InptOrder: boolean; CheckForClozapineOnly: boolean = false): boolean;
function AdminTimeHelpText(): string;
function ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur: string;
  OI, tempSupply, tempRefills: integer; tempQuantity: string;
  Titration: boolean; OrderText: string; var EditOrder: Boolean): boolean;
procedure UpdateSupplyQtyRefillErrorMsg(var ErrorMessage: string;
  DaySupply, Refills: integer; Quantity, Drug, Units, Schedule,
  Duration: string; Titration: boolean; OrderableItem: integer;
  IncludeRefillCheck: boolean);
procedure ClearMaxData;
function DifferentOrderLocations(ID: string; Loc: integer): boolean;
function IsClozapineOrder: boolean;
function GetMaxDS(OrderableIEN: string; DrugIEN: string): integer;
function GetQOOrderableItem(DialogIEN: string): integer;


implementation

uses uOrders, rODBase;
 var
  uAdminTimeHelpText: TAdminTimeHelpText;
  uDrugHasMaxData: TDrugHasMaxData;
  uInpatientClozapineText : TInpatientClozapineText;

function DEACheckFailed(AnOI: integer; ForInpatient: boolean): string;
var
  PtType: Char;
begin
  if ForInpatient then
    PtType := 'I'
  else
    PtType := 'O';
  CallVistA('ORWDPS1 FAILDEA', [AnOI, Encounter.Provider, PtType], Result);
end;

function DEACheckFailedAtSignature(AnOI: integer; ForInpatient: boolean): string;
var
  PtType: Char;
begin
  if ForInpatient then
    PtType := 'I'
  else
    PtType := 'O';
  CallVistA('ORWDPS1 FAILDEA', [AnOI, User.DUZ, PtType], Result);
end;

function DEACheckFailedForIVOnOutPatient(AnOI: integer; AnOIType: Char): string;
begin
  CallVistA('ORWDPS1 IVDEA', [AnOI, AnOIType, Encounter.Provider], Result);
end;

procedure ListForOrderable(var AListIEN, ACount: integer; const DGrpNm: string);
var
  aStr: string;
begin
  CallVistA('ORWUL FV4DG', [DGrpNm], aStr);
  AListIEN := StrToIntDef(Piece(aStr, U, 1), 0);
  ACount := StrToIntDef(Piece(aStr, U, 2), 0);
end;

procedure SubsetOfOrderable(Dest: TStringList; Append: boolean; ListIEN, First, Last: integer);
var
  i: integer;
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWUL FVSUB', [ListIEN, First + 1, Last + 1], aLst); // M side not 0-based
    if Append then
      FastAddStrings(aLst, Dest)
    else
  begin
        for i := Pred(aLst.Count) downto 0 do
          Dest.Insert(0, aLst[i]);
  end;
  finally
    FreeAndNil(aLst);
end;
end;

function IndexOfOrderable(ListIEN: integer; From: string): integer;
var
  x: string;
begin
  Result := -1;
  if From = '' then
    Exit;
  // decrement last char & concat '~' for $ORDER on M side, limit string length
  x := UpperCase(Copy(From, 1, 220));
  x := Copy(x, 1, Length(x) - 1) + Pred(x[Length(x)]) + '~';
  CallVistA('ORWUL FVIDX', [ListIEN, x], x);
  // use Pred to make the index 0-based (first value = 1 on M side)
  if CompareText(Copy(Piece(x, U, 2), 1, Length(From)), From) = 0 then
    Result := Pred(StrToIntDef(Piece(x, U, 1), 0));
end;

procedure IsActivateOI(var AMsg: string; theOI: integer);
begin
  CallVistA('ORWDXA ISACTOI', [theOI], aMsg);
end;

procedure ListForQuickOrders(var AListIEN, ACount: Integer; const DGrpNm: string);
var
  aStr: string;
begin
  CallVistA('ORWUL QV4DG', [DGrpNm], aStr);
  AListIEN := StrToIntDef(Piece(aStr, U, 1), 0);
  ACount   := StrToIntDef(Piece(aStr, U, 2), 0);
end;

procedure SubsetOfQuickOrders(Dest: TStringList; AListIEN, First, Last: integer);
var
  i: integer;
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWUL QVSUB', [AListIEN, '', ''], aLst);
    for i := 0 to aLst.Count - 1 do
      Dest.Add(aLst[i]);
  finally
    FreeAndNil(aLst);
end;
end;

function IndexOfQuickOrder(AListIEN: integer; From: string): integer;
var
  x: string;
begin
  Result := -1;
  if From = '' then
    Exit;
  // decrement last char & concat '~' for $ORDER on M side, limit string length
  x := UpperCase(Copy(From, 1, 220));
  x := Copy(x, 1, Length(x) - 1) + Pred(x[Length(x)]) + '~';
  CallVistA('ORWUL QVIDX', [AListIEN, x], x);
  // use Pred to made the index 0-based (first value = 1 on M side)
  if CompareText(Copy(Piece(x, U, 2), 1, Length(From)), From) = 0 then
    Result := Pred(StrToIntDef(Piece(x, U, 1), 0));
end;

procedure LoadFormularyAltOI(AList: TStringList; AnIEN: integer; ForInpatient: boolean);
var
  PtType: Char;
begin
  if ForInpatient then
    PtType := 'I'
  else
    PtType := 'O';
  CallVistA('ORWDPS1 FORMALT', [AnIEN, PtType], AList);
end;

procedure LoadFormularyAltDose(AList: TStringList; DispDrug, OI: integer; ForInpatient: boolean);
var
  PtType: Char;
begin
  if ForInpatient then
    PtType := 'I'
  else
    PtType := 'O';
  CallVistA('ORWDPS1 DOSEALT', [DispDrug, OI, PtType], AList);
end;

procedure LoadAdminInfo(const Schedule: string; OrdItem: Integer; var StartText: string;
  var AdminTime: TFMDateTime; var Duration: string; Admin: string = '');
var
  x: string;
begin
  CallVistA('ORWDPS2 ADMIN', [Patient.DFN, Schedule, OrdItem, Encounter.Location, Admin], x);
  StartText := Piece(x, U, 1);
  AdminTime := MakeFMDateTime(Piece(x, U, 4));
  Duration  := Piece(x, U, 3);
end;

function GetAdminTime(const StartText, Schedule: string; OrdItem: integer): TFMDateTime;
var
  x: string;
begin
  CallVistA('ORWDPS2 REQST', [Patient.DFN, Schedule, OrdItem, Encounter.Location, StartText], x);
  Result := MakeFMDateTime(x);
end;

procedure LoadSchedules(Dest: TStrings; IsInptDlg: boolean);
begin
  // if uMedSchedules = nil then CallV('ORWDPS ALLSCHD', [nil]); uMedSchedules.Assign(...);
  CallVistA('ORWDPS1 SCHALL', [patient.dfn, patient.location], Dest);
  If (Dest.IndexOfName('OTHER') < 0) and IsInptDlg then
    Dest.Add('OTHER');
end;

procedure LoadAllIVRoutes(Dest: TStrings);
begin
  CallVistA('ORWDPS32 ALLIVRTE', [], Dest);
end;

procedure LoadDosageFormIVRoutes(Dest: TStrings; OrderIDs: TStringList);
begin
  CallVistA('ORWDPS33 IVDOSFRM', [OrderIDs, False], Dest);
end;

procedure LoadInfusionIndications(Dest: TStrings; OrderIDs: TStringList);
begin
  CallVistA('ORWDPS33 IVIND', [OrderIDs], Dest);
end;

function GetDefaultAddFreq(OID: integer): string;
begin
  CallVistA('ORWDPS33 GETADDFR', [OID], Result);
end;

procedure LoadDOWSchedules(Dest: TStrings);
begin
  // if uMedSchedules = nil then CallV('ORWDPS ALLSCHD', [nil]); uMedSchedules.Assign(...);
  CallVistA('ORWDPS1 DOWSCH', [patient.dfn, patient.location], Dest);
end;

function QtyToDays(Quantity: Double; const UnitsPerDose, Schedule, Duration, Drug: string): integer;
begin
  CallVistA('ORWDPS2 QTY2DAY', [Quantity, UnitsPerDose, Schedule, Duration, Patient.DFN, Drug], Result, 0);
end;

type
  TDaysToQtyData = record
    LastPatientDFN: string;
    LastDaysSupply: integer;
    LastUnitsPerDose: string;
    LastSchedule: string;
    LastDuration: string;
    LastDrug: string;
    LastResult: Double;
  end;

var
  uLastDaysToQtyData: TDaysToQtyData;

function DaysToQty(DaysSupply: integer; const UnitsPerDose, Schedule, Duration, Drug: string): Double;
begin
  with uLastDaysToQtyData do
  begin
    if (Patient.DFN = LastPatientDFN) and (DaysSupply = LastDaysSupply) and
      (UnitsPerDose = LastUnitsPerDose) and (Schedule = LastSchedule) and
      (Duration = LastDuration) and (Drug = LastDrug) then
      Result := LastResult
    else
    begin
      LastPatientDFN := Patient.DFN;
      LastDaysSupply := DaysSupply;
      LastUnitsPerDose := UnitsPerDose;
      LastSchedule := Schedule;
      LastDuration := Duration;
      LastDrug := Drug;
      CallVistA('ORWDPS2 DAY2QTY', [DaysSupply, UnitsPerDose, Schedule, Duration, Patient.DFN, Drug], Result, 0);
      LastResult := Result;
    end;
    if uDrugHasMaxData.CaptureMaxData = True then
      uDrugHasMaxData.MaxQuantity := Result;
  end;
end;

function DurToQty(DaysSupply: integer; const UnitStr, SchedStr: string): integer;
begin
  CallVistA('ORWDPS2 DAY2QTY', [DaysSupply, UnitStr, SchedStr], Result, 0);
end;

type
  TDefaultDaysData = record
    LastPatientDFN: string;
    LastDrug: string;
    LastUnitStr: string;
    LastSchedStr: string;
    LastOI: integer;
    LastResult: integer;
  end;

var
  uLastDaysSupplyData: TDefaultDaysData;

function DefaultDays(const ADrug, UnitStr, SchedStr: string; OI: integer): integer;
begin
  with uLastDaysSupplyData do
  begin
    if (Patient.DFN = LastPatientDFN) and (ADrug = LastDrug) and
      (UnitStr = LastUnitStr) and (SchedStr = LastSchedStr) and (OI = LastOI) then
      Result := LastResult
    else
    begin
      LastPatientDFN := Patient.DFN;
      LastDrug := ADrug;
      LastUnitStr := UnitStr;
      LastSchedStr := SchedStr;
      LastOI := OI;
      CallVistA('ORWDPS1 DFLTSPLY', [UnitStr, SchedStr, Patient.DFN, ADrug, OI], Result, 0);
      LastResult := Result;
    end;
    if uDrugHasMaxData.CaptureMaxData = True then
      uDrugHasMaxData.MaxSupply := Result;
  end;
end;

type
  TMaxRefillData = record
    LastPatientDFN: string;
    LastDrug: string;
    LastDaysSupply: integer;
    LastOrderableItem: integer;
    LastDischarge: boolean;
    LastTitration: boolean;
    LastResult: Integer;
  end;

var
  uMaxRefillData: TMaxRefillData;

function CalcMaxRefills(Drug: string; Days, OrdItem: integer;
                  Discharge: boolean; Titration: boolean): integer;
begin
  Drug := Piece(Drug, U, 1);
  with uMaxRefillData do
  begin
    if (Patient.DFN = LastPatientDFN) and (Drug = LastDrug) and
      (Days = LastDaysSupply) and (OrdItem = LastOrderableItem) and
      (Discharge = LastDischarge) and (Titration = LastTitration) then
      Result := LastResult
    else
    begin
      LastPatientDFN := Patient.DFN;
      LastDrug := Drug;
      LastDaysSupply := Days;
      LastOrderableItem := OrdItem;
      LastDischarge := Discharge;
      LastTitration := Titration;
      CallVistA('ORWDPS2 MAXREF', [Patient.DFN, Drug, Days, OrdItem, Discharge,
        BOOLCHAR[Titration]], Result, 0);
      LastResult := Result;
    end;
  end;
  if uDrugHasMaxData.CaptureMaxData = True then
    uDrugHasMaxData.MaxRefills := Result;
end;

procedure ClearOutPtMedsRPCCache;
begin
  uLastDaysToQtyData.LastPatientDFN := '';
  uLastDaysSupplyData.LastPatientDFN := '';
  uMaxRefillData.LastPatientDFN := '';
end;

function ScheduleRequired(OrdItem: Integer; const ARoute, ADrug: string): Boolean;
var
  aStr: string;
begin
  CallVistA('ORWDPS2 SCHREQ', [OrdItem, ARoute, ADrug], aStr);
  Result := aStr = '1';
end;

function ODForMedsIn(aReturn: TStrings): integer;
{ Returns init values for inpatient meds dialog. }
begin
  CallVistA('ORWDPS1 ODSLCT', [PST_UNIT_DOSE, Patient.DFN, Encounter.Location], aReturn);
  Result := aReturn.Count;
end;

function ODForMedsOut(aReturn: TStrings): integer;
{ Returns init values for outpatient meds dialog. }
begin
  CallVistA('ORWDPS1 ODSLCT', [PST_OUTPATIENT, Patient.DFN, Encounter.Location], aReturn);
  Result := aReturn.Count;
end;

function OIForMed(aReturn: TStrings; AnIEN: Integer; ForInpatient: Boolean; HavePI: Boolean; PKIActive: Boolean): integer;
var
  PtType: Char;
  NeedPI: Char;
  IsPKIActive: Char;
begin
  if HavePI then NeedPI := 'Y' else NeedPI := 'N';
  if ForInpatient then PtType := 'U' else PtType := 'O';
  if PKIActive then IsPKIActive := 'Y' else IsPKIActive := 'N';
  CallVistA('ORWDPS2 OISLCT', [AnIEN, PtType, Patient.DFN, NeedPI, IsPKIActive], aReturn);
  Result := aReturn.Count;
end;

function GetPickupForLocation(const Loc: string): string;
begin
  CallVistA('ORWDPS1 LOCPICK',[Loc], Result);
end;

function QOHasRouteDefined(AQOID: integer): boolean;
var
  aStr: string;
begin
  if CallVistA('ORWDPS1 HASROUTE', [AQOID], aStr) then
    Result := (aStr = '1')
  else
  Result := False;
end;

procedure CheckExistingPI(AOrderId: string; var APtI: string);
begin
  CallVistA('ORWDPS2 CHKPI', [AOrderId], APtI);
end;

function PassDrugTest(OI: integer; OrderType: string; InptOrder: boolean; CheckForClozapineOnly: boolean = false): boolean;
var
  MessCap: string;
  MessText: string;
i: integer;
  aLst: TStringList;
begin
  result := false;
  MessText := '';
  uDrugHasMaxData.CaptureMaxData := false;
  uDrugHasMaxData.MaxSupply := 0;
  uDrugHasMaxData.MaxQuantity := 0;
  uDrugHasMaxData.MaxRefills := 0;
  aLst := TStringList.Create;
  try
    CallVistA('ORALWORD ALLWORD', [Patient.DFN, OI, OrderType, Encounter.Provider], aLst);
    for i := 0 to aLst.Count - 1 do
    begin
      if i = 0 then
        begin
            MessCap := Piece(aLst[i], U, 1);
            if Piece(aLst[i], U, 2) = '1' then
              uDrugHasMaxData.CaptureMaxData := True;
        end;
        if i > 0 then
          MessText := MessText + aLst[i] + CRLF;
    end;
  finally
    FreeAndNil(aLst);
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
              aLst := TStringList.Create;
              try
                CallVistA('ORDDPAPI CLOZMSG', [], aLst);
                for i := 0 to aLst.Count - 1 do
                  if i = 0 then
                    uInpatientClozapineText.dispText := aLst[i]
                  else uInpatientClozapineText.dispText := uInpatientClozapineText.dispText + CRLF + aLst[i];
              finally
                FreeAndNil(aLst);
              end;
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
  aLst: TStringList;
begin
      if uAdminTimeHelpText.HelpText = '' then
       begin
      aLst := TStringList.Create;
      try
        CallVistA('ORDDPAPI ADMTIME', [], aLst);
        for i := 0 to aLst.Count - 1 do
          if i = 0 then
            uAdminTimeHelpText.HelpText := aLst[i]
          else
            uAdminTimeHelpText.HelpText := uAdminTimeHelpText.HelpText + CRLF + aLst[i];
      finally
        FreeAndNil(aLst);
       end;
    end;
  Result := uAdminTimeHelpText.HelpText
end;

function ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur: string;
  OI, tempSupply, tempRefills: integer; tempQuantity: string;
  Titration: boolean; OrderText: string; var EditOrder: Boolean): boolean;
var
  ErrorMessage: string;

begin
  ErrorMessage := '';
  UpdateSupplyQtyRefillErrorMsg(ErrorMessage, tempSupply, tempRefills,
    tempQuantity, tempDrug, tempUnit, tempSch, tempDur, Titration, OI, False);
  Result := (ErrorMessage = '');
  if not Result then
  begin
    if OrderText <> '' then
      ErrorMessage := OrderText + CRLF + CRLF + ErrorMessage;
    ErrorMessage := ErrorMessage + CRLF + CRLF + 'Do you want to edit this order?';
    if infoBox(ErrorMessage, 'Cannot Save Error',
      MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = IDYES then
    begin
      Result := True;
      EditOrder := True;
    end
    else
    begin
      Result := false;
      uDrugHasMaxData.CaptureMaxData := false;
    end;
  end;
end;

procedure UpdateSupplyQtyRefillErrorMsg(var ErrorMessage: string;
  DaySupply, Refills: integer; Quantity, Drug, Units, Schedule,
  Duration: string; Titration: boolean; OrderableItem: integer;
  IncludeRefillCheck: boolean);

var
  CheckClozapine, CheckValues, MaxDaysSupplyError: boolean;
  maxDS, maxRefills: integer;
  maxQty: Double;
  msg: string;

  procedure SetError(const x: string);
  begin
    if Length(ErrorMessage) > 0 then
      ErrorMessage := ErrorMessage + CRLF;
    ErrorMessage := ErrorMessage + x;
  end;

begin
  Drug := Piece(Drug, U, 1);
  CheckValues := True;
  if (DaySupply < 1) then
  begin
    SetError(TX_SUPPLY_LIM1);
    CheckValues := False;
  end;
  if not ValidQuantity(Quantity) then
  begin
    SetError(TX_QTY_NV);
    CheckValues := False;
  end;
  if CheckValues then
  begin
    CheckClozapine := IsClozapineOrder;
    MaxDaysSupplyError := False;
    if CheckClozapine then
      maxDS := DefaultDays(Drug, Units, Schedule, OrderableItem)
    else
      maxDS := GetMaxDS(IntToStr(OrderableItem), Drug);
    if (maxDS > 0) and (DaySupply > maxDS) then
      MaxDaysSupplyError := True;
    if CheckClozapine then
    begin
      CallVistA('ORWDPS33 CLZDS', [Patient.DFN, Drug, DaySupply,
        OrderableItem], msg);
      if Piece(msg, U, 1) = '0' then
      begin
        SetError(Piece(msg, U, 2));
        CheckClozapine := False;
        MaxDaysSupplyError := False;
      end;
    end;
    if MaxDaysSupplyError then
      SetError(TX_SUPPLY_LIM + IntToStr(maxDS) + '.');
    if CheckClozapine then
    begin
      maxQty := DaysToQty(DaySupply, Units, Schedule, Duration, Drug);
      if (maxQty > 0) and (StrToFloatDef(Quantity, 0) > maxQty) then
        SetError(TX_QTY_LIM + FloatToStr(maxQty) + '.');
    end;
  end;

  if IncludeRefillCheck and (Refills > 0) then
  begin
    maxRefills := CalcMaxRefills(Drug, DaySupply, OrderableItem, False,
      Titration);
    if Refills > maxRefills then
      SetError(TX_ERR_REFILL + IntToStr(maxRefills));
  end;
end;

procedure ClearMaxData;
begin
  uDrugHasMaxData.CaptureMaxData := false;
end;

function DifferentOrderLocations(ID: string; Loc: integer): boolean;
var
  aStr: string;
begin
  CallVistA('ORWDPS33 COMPLOC', [ID, Loc], aStr);
  Result := (aStr = '1');
end;

function IsClozapineOrder: boolean;
begin
  Result := uDrugHasMaxData.CaptureMaxData;
end;

function GetMaxDS(OrderableIEN: string; DrugIEN: string): integer;
begin
  CallVistA('ORWDPS1 MAXDS', [OrderableIEN, DrugIEN], Result, 0);
end;

function GetQOOrderableItem(DialogIEN: string): integer;
begin
  CallVistA('ORWDPS1 QOMEDALT', [DialogIEN], Result, 0);
end;

end.

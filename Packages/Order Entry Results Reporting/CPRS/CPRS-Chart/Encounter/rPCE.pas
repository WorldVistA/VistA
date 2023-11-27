unit rPCE;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses SysUtils, Classes, ORNet, ORFn, uPCE, UBACore, ORClasses, windows;

const
  LX_SC   = 4;  //Standard Codes
  LX_ICD  = 12;
  LX_CPT  = 13;
  LX_SCT  = 14;

  LX_Threshold = 15;

  PCE_IMM = 20;
  PCE_SK  = 21;
  PCE_PED = 22;
  PCE_HF  = 23;
  PCE_XAM = 24;
  PCE_TRT = 25;

  SCC_YES =  1;
  SCC_NO  =  0;
  SCC_NA  = -1;

var
  uEncLocation: integer;
//  uEncDateTime: TFMDateTime;

type
  TSCConditions = record
    SCAllow:  Boolean;        // prompt for service connected
    SCDflt:   Boolean;        // default if prompting service connected
    AOAllow:  Boolean;        // prompt for agent orange exposure
    AODflt:   Boolean;        // default if prompting agent orange exposure
    IRAllow:  Boolean;        // prompt for ionizing radiation exposure
    IRDflt:   Boolean;        // default if prompting ionizing radiation
    ECAllow:  Boolean;        // prompt for environmental conditions
    ECDflt:   Boolean;        // default if prompting environmental cond.
    MSTAllow: Boolean;        // prompt for military sexual trauma
    MSTDflt:  Boolean;        // default if prompting military sexual trauma
    HNCAllow: Boolean;        // prompt for Head or Neck Cancer
    HNCDflt:  Boolean;        // default if prompting Head or Neck Cancer
    CVAllow:  Boolean;        // prompt for Combat Veteran Related
    CVDflt:   Boolean;        // default if prompting Comabt Veteran
    SHDAllow: Boolean;        // prompt for Shipboard Hazard and Defense
    SHDDflt:  Boolean;        // default if prompting Shipboard Hazard and Defense
    CLAllow:  Boolean;        // prompt for camp lejeune
    CLDflt:   Boolean;        // default if propmpting camp lejeune
  end;

  TPCEListCodesProc = procedure(Dest: TStrings; SectionIndex: Integer);

  TAskPCE = (apPrimaryNeeded, apPrimaryOutpatient, apPrimaryAlways,
             apNeeded, apOutpatient, apAlways, apNever, apDisable);

function GetVisitCat(InitialCat: char; Location: integer; Inpatient: boolean): char;
function GetDiagnosisText(Narrative: String; Code: String): String;
function GetFreqOfText(SearchStr: String): integer;

// Used for secondary visit date
function GetNoteDate(NoteIEN: Integer): TFMDateTime;
function GetNoteLocation(NoteIEN: Integer): Integer;

{assign and read values from fPCEData}
//function SetRPCEncouterInfo(PCEData: TPCEData): boolean;
function SetRPCEncLocation(Loc: Integer): boolean;
//function SetRPCEncDateTime(DT: TFMDateTime): boolean;

function PCERPCEncLocation: integer;
//function PCERPCEncDateTime: TFMDateTime;
function GetLocSecondaryVisitCode(Loc: integer): char;

{check for active person class on provider}
function CheckActivePerson(provider:string;DateTime:TFMDateTime): boolean;
function ForcePCEEntry(Loc: integer): boolean;

{"Other" form PCE calls}
procedure LoadcboOther(Dest: TStrings; Location, fOtherApp: Integer);

procedure RemTaxWCodes(Dest: TStrings);
procedure TaxCodes(Dest: TStrings; Taxonomy: integer; Date: TFMDateTime);
{ Lexicon Lookup Calls }
function  LexiconToCode(IEN, LexApp: Integer; ADate: TFMDateTime = 0): string;
procedure ListLexicon(Dest: TStrings; const x: string; LexApp: Integer; ADate: TFMDateTime = 0; AExtend: Boolean = False; AI10Active: Boolean = False);
//procedure GetI10Alternatives(Dest: TStrings; SCTCode: string);
function  IsActiveICDCode(ACode: string; ADate: TFMDateTime = 0): boolean;
function  IsActiveCPTCode(ACode: string; ADate: TFMDateTime = 0): boolean;
function  IsActiveSCTCode(ACode: string; ADate: TFMDateTime = 0): boolean;
function  IsActiveCode(ACode: string; LexApp: integer; ADate: TFMDateTime = 0): boolean;
function  GetICDVersion(ADate: TFMDateTime = 0): String;

{ Encounter Form Elements }
procedure DeletePCE(const AVisitStr: string; visit: integer);
function EligbleConditions(PCEData: TPCEData): TSCConditions;

procedure ListVisitTypeSections(Dest: TStrings);
procedure ListVisitTypeCodes(Dest: TStrings; SectionIndex: Integer);
procedure ListVisitTypeByLoc(Dest: TStrings; Location: Integer; ADateTime: TFMDateTime = 0);
function AutoSelectVisit(Location: integer): boolean;
function UpdateVisitTypeModifierList(Dest: TStrings; Index: integer): string;

procedure ListDiagnosisSections(Dest: TStrings);
procedure ListDiagnosisCodes(Dest: TStrings; SectionIndex: Integer);
procedure UpdateDiagnosisObj(CodeNarr: String; ItemIndex: Integer);

procedure ListExamsSections(Dest: TStrings);
procedure ListExamsCodes(Dest: TStrings; SectionIndex: Integer);

procedure ListHealthSections(Dest: TStrings);
procedure ListHealthCodes(Dest: TStrings; SectionIndex: Integer);

procedure ListImmunizSections(Dest: TStrings);
procedure ListImmunizCodes(Dest: TStrings; SectionIndex: Integer);

procedure ListPatientSections(Dest: TStrings);
procedure ListPatientCodes(Dest: TStrings; SectionIndex: Integer);

procedure ListProcedureSections(Dest: TStrings);
procedure ListProcedureCodes(Dest: TStrings; SectionIndex: Integer);
function ModifierList(CPTCode: string): string;
procedure ListCPTModifiers(Dest: TStrings; CPTCodes, NeededModifiers: string);
function ModifierName(ModIEN: string): string;
function ModifierCode(ModIEN: string): string;
function UpdateModifierList(Dest: TStrings; Index: integer): string;

procedure ListSkinSections(Dest: TStrings);
procedure ListSkinCodes(Dest: TStrings; SectionIndex: Integer);

function ListUCUMCodes(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;

procedure ListSCDisabilities(Dest: TStrings);
procedure LoadPCEDataForNote(Dest: TStrings; ANoteIEN: Integer; VStr: string);
function GetVisitIEN(NoteIEN: Integer): string;
//function SavePCEData(PCEList: TStringList; ANoteIEN, ALocation: integer; var VisitID: integer): boolean;
function SavePCEData(PCEList: TStringList; ANoteIEN, ALocation: integer; var isLock: boolean): boolean;

function DataHasCPTCodes(AList: TStrings): boolean;
function GetAskPCE(Loc: integer): TAskPCE;
function HasVisit(const ANoteIEN, ALocation: integer; const AVisitDate: TFMDateTime): Integer;

procedure LoadImmSeriesItems(Dest: TStrings);
procedure LoadImmReactionItems(Dest: TStrings);
procedure LoadSkResultsItems(Dest: TStrings);
procedure LoadPEDLevelItems(Dest: TStrings);
procedure LoadHFLevelItems(Dest: TStrings);
procedure LoadXAMResultsItems(Dest: TStrings);
procedure LoadHistLocations(Dest: TStrings);
procedure AddProbsToDiagnoses;
procedure RefreshPLDiagnoses;

//GAF
function GAFOK: boolean;
function MHClinic(const Location: integer): boolean;
procedure RecentGAFScores(aDest: TStrings; const Limit: integer);
function SaveGAFScore(const Score: integer; GAFDate: TFMDateTime; Staff: Int64): boolean;
function GAFURL: string;
function MHTestsOK: boolean;
function MHTestAuthorized(Test: string): boolean;

function AnytimeEncounters: boolean;
function AutoCheckout(Loc: integer): boolean;

{ Encounter }
//function RequireExposures(ANote: Integer): Boolean;      {RAB}
function RequireExposures(ANote, ATitle: Integer): Boolean;
function PromptForWorkload(ANote, ATitle: Integer; VisitCat: Char; StandAlone: boolean): Boolean;
function DefaultProvider(ALocation: integer; AUser: Int64; ADate: TFMDateTime;
                                             ANoteIEN: integer): string;
function IsUserAProvider(AUser: Int64; ADate: TFMDateTime): boolean;
function IsUserAUSRProvider(AUser: Int64; ADate: TFMDateTime): boolean;
function IsCancelOrNoShow(ANote: integer): boolean;
function IsNonCountClinic(ALocation: integer): boolean;
function CheckDailyHospitalization(APCEObject: TPCEData): Boolean;
function GetUCUMInfo(DataType: string; Code: string): TUCUMInfo;
procedure UpdateUCUMInfo(DataType, Code, Value: string);
function GetMagUCUMData(DataType: string; Code: string): string;
procedure UpdateMagUCUMData(DataType, Code, Value: string);

// HNC Flag
//function HNCOK: boolean;

implementation

uses uGlobalVar, TRPCB, rCore, uCore, uConst, fEncounterFrame, UBAGlobals, UBAConst, rMisc, fDiagnoses, ORNetIntf;

var
  uLastLocation:  Integer;
  uLastDFN:       String;
  uLastEncDt:     TFMDateTime;
  uVTypeLastLoc:  Integer;
  uVTypeLastDate: double = 0;
  uMagData:       TStringList;
  uDiagnoses:     TStringList;
  uExams:         TStringList;
  uHealthFactors: TStringList;
  uImmunizations: TStringList;
  uPatientEds:    TStringList;
  uProcedures:    TStringList;
  uSkinTests:     TStringList;
  uVisitTypes:    TStringList;
  uVTypeForLoc:   TStringList;
  uProblems:      TStringList;
  uModifiers:     TORStringList = nil;
  uGAFOK:         boolean;
  uGAFOKCalled:   boolean = FALSE;
  uLastForceLoc:  integer = -1;
  uLastForce:     boolean;
  uHasCPT:        TStringList = nil;
  uGAFURL:        string;
  uGAFURLChecked: boolean = FALSE;
  uMHOK:          boolean;
  uMHOKChecked:   boolean = FALSE;
  uVCInitialCat:  char = #0;
  uVCLocation:    integer = -2;
  uVCInpatient:   boolean = FALSE;
  uVCResult:      char;
  uAPUser:        Int64 = -1;
  uAPLoc:         integer = -2;
  uAPAsk:         TAskPCE;
  uAnytimeEnc:    integer = -1;
  UAutoSelLoc:    integer = -1;
  UAutoSelVal:    boolean;
  uLastChkOut:    boolean;
  uLastChkOutLoc: integer = -2;
  uLastIsClinicLoc: integer = 0;
  uLastIsClinic: boolean = FALSE;
  uDiagnosesTextList: TStringList;
//  uHNCOK:         integer = -1;

function GetEncounterDateTime: TFMDateTime;
begin
  if assigned(uEncPCEData) then
    Result := uEncPCEData.VisitDateTime
  else
    Result := Encounter.DateTime;
end;

function GetEncounterICDVersion: string;
begin
  if assigned(uEncPCEData) then
    Result := uEncPCEData.GetICDVersion
  else
    Result := Encounter.GetICDVersion;
end;

function GetEncounterVisitCategory: Char;
begin
  if assigned(uEncPCEData) then
    Result := uEncPCEData.VisitCategory
  else
    Result := Encounter.VisitCategory;
end;

function GetEncounterProvider: Int64;
begin
  if assigned(uEncPCEData) then
    Result := uEncPCEData.Providers.PCEProviderForce
  else
    Result := Encounter.Provider;
end;

function GetEncounterVisitString: string;
begin
  if assigned(uEncPCEData) then
    Result := uEncPCEData.VisitString
  else
    Result := Encounter.VisitStr;
end;

function GetVisitCat(InitialCat: char; Location: integer; Inpatient: boolean): char;
var
  tmp: string;

begin
  if(InitialCat <> uVCInitialCat) or (Location <> uVCLocation) or
    (Inpatient <> uVCInpatient) then
  begin
    uVCInitialCat := InitialCat;
    uVCLocation := Location;
    uVCInpatient := Inpatient;
//    tmp := sCallV('ORWPCE GETSVC', [InitialCat, Location, BOOLCHAR[Inpatient]]);
    CallVistA('ORWPCE GETSVC', [InitialCat, Location, BOOLCHAR[Inpatient]], tmp);
    if(tmp <> '') then
      uVCResult := tmp[1]
    else
      uVCResult := InitialCat;
  end;
  Result := uVCResult
end;

function GetDiagnosisText(Narrative: String; Code: String): String;
var
i: integer;
node: string;
begin
//  Result := sCallV('ORWPCE GET DX TEXT', [Narrative, Code]);

  for i := 0 to uDiagnosesTextList.Count - 1 do
    begin
       node := uDiagnosesTextList.Strings[i];
       if Pieces(node, U, 1, 2) = Code + U + Narrative then
        result := Piece(node, U, 3);
    end;
  if result <> '' then exit;

  CallVistA('ORWPCE GET DX TEXT', [Narrative, Code], Result);
  uDiagnosesTextList.Add(Code + U + Narrative + U + Result);
end;

function GetFreqOfText(SearchStr: String): integer;
begin
//  Result := StrToInt(sCallV('ORWLEX GETFREQ', [SearchStr]));
  CallVistA('ORWLEX GETFREQ', [SearchStr],Result);
end;

function GetNoteDate(NoteIEN: integer): TFMDateTime;
begin
  CallVistA('ORWPCE5 NOTEDATE', [NoteIEN], Result);
end;

function GetNoteLocation(NoteIEN: Integer): Integer;
begin
  CallVistA('ORWPCE5 NOTELOC', [NoteIEN], Result);
end;

{ Lexicon Lookup Calls }

function LexiconToCode(IEN, LexApp: Integer; ADate: TFMDateTime = 0): string;
var
  CodeSys: string;
begin
  case LexApp of
  LX_SC:  CodeSys := 'SCT';
  LX_ICD: CodeSys := 'ICD';
  LX_CPT: CodeSys := 'CHP';
  LX_SCT: CodeSys := 'GMPX';
  end;
//  Result := Piece(sCallV('ORWPCE LEXCODE', [IEN, CodeSys, ADate]), U, 1);
  CallVistA('ORWPCE LEXCODE', [IEN, CodeSys, ADate], Result);
  Result := Piece(Result, U, 1);
end;

procedure ListLexicon(Dest: TStrings; const x: string; LexApp: Integer; ADate: TFMDateTime = 0; AExtend: Boolean = False; AI10Active: Boolean = False);
var
  CodeSys: string;
  ExtInt: integer;
begin

  case LexApp of
    LX_SC:  CodeSys := 'SCT';
    LX_ICD: CodeSys := 'ICD';
    LX_CPT: CodeSys := 'CHP';
    LX_SCT: CodeSys := 'GMPX';
  end;
  if AExtend then
    ExtInt := 1
  else
    ExtInt := 0;
  if (LexApp = LX_ICD) and AExtend and AI10Active then
    CallVistA('ORWLEX GETI10DX', [x, ADate], Dest)
  else if LexApp = LX_SC then
    CallVistA('ORWPCE4 STDCODES', [x, CodeSys, ADate], Dest)
  else
    CallVistA('ORWPCE4 LEX', [x, CodeSys, ADate, ExtInt, True], Dest);
end;

//TODO: Code for I10 mapped alternatives - remove if not reinstated as requirement
{procedure GetI10Alternatives(Dest: TStrings; SCTCode: string);
begin
  CallV('ORWLEX GETALTS', [SCTCode, 'SCT']);
  FastAssign(RPCBrokerV.Results, Dest);
end;}

function  IsActiveICDCode(ACode: string; ADate: TFMDateTime = 0): boolean;
begin
  Result := IsActiveCode(ACode, LX_ICD, ADate);
end;

function  IsActiveCPTCode(ACode: string; ADate: TFMDateTime = 0): boolean;
begin
  Result := IsActiveCode(ACode, LX_CPT, ADate);
end;

function  IsActiveSCTCode(ACode: string; ADate: TFMDateTime = 0): boolean;
begin
  Result := IsActiveCode(ACode, LX_SCT, ADate);
end;

function  IsActiveCode(ACode: string; LexApp: integer; ADate: TFMDateTime = 0): boolean;
var
  s,
  CodeSys: string;
begin
  case LexApp of
  LX_SC:  CodeSys := 'SCT';
  LX_ICD: CodeSys := 'ICD';
  LX_CPT: CodeSys := 'CHP';
  LX_SCT: CodeSys := 'GMPX';
  end;
//  Result := (sCallV('ORWPCE ACTIVE CODE',[ACode, CodeSys, ADate]) = '1');
  Result := CallVistA('ORWPCE ACTIVE CODE',[ACode, CodeSys, ADate], s) and (s = '1');
end;

function  GetICDVersion(ADate: TFMDateTime = 0): String;
begin
//  Result := sCallV('ORWPCE ICDVER', [ADate]);
  CallVistA('ORWPCE ICDVER', [ADate], Result);
end;

{ Encounter Form Elements ------------------------------------------------------------------ }

procedure DeletePCE(const AVisitStr: string; visit: integer);
begin
  CallVistA('ORWPCE DELETE', [AVisitStr, Patient.DFN, visit]);
end;

procedure LoadEncounterForm;
{ load the major coding lists that are used by the encounter form for a given location }
var
  i: integer;
  uTempList: TStringList;
  EncDt: TFMDateTime;
begin
  uLastLocation := uEncLocation;
  if GetEncounterVisitCategory <> 'E' then
    EncDt := Trunc(GetEncounterDateTime)
  else
    EncDt := Trunc(FMNow);
  uLastEncDt := EncDt;
  EncLoadDateTime := Now;

  //add problems to the top of diagnoses.
  uTempList := TstringList.Create;

  if UBAGlobals.BILLING_AWARE then //BAPHII 1.3.10
    UBACore.BADxList := TStringList.Create;

  try
    uDiagnoses.clear;

    if BILLING_AWARE then
     begin
        UBACore.BADxList.Clear; //BAPHII 1.3.10
     end;

    CallVistA('ORWPCE DIAG', [uEncLocation, EncDT, Patient.DFN], uTempList);
    if utemplist.Count > 0 then
      uDiagnoses.add(utemplist.strings[0]);  //BAPHII 1.3.10
    AddProbsToDiagnoses;  //BAPHII 1.3.10
   // BA 25  AddProviderPatientDaysDx(uDxLst, IntToStr(Encounter.Provider), Patient.DFN);
    for i := 1 to (uTempList.Count-1) do  //BAPHII 1.3.10
      uDiagnoses.add(uTemplist.strings[i]);  //BAPHII 1.3.10

  finally
    uTempList.free;
  end;
  CallVistA('ORWPCE VISIT', [uEncLocation, EncDt],uVisitTypes );
  CallVistA('ORWPCE PROC',  [uEncLocation, EncDt],uProcedures );
  CallVistA('ORWPCE IMM',   [uEncLocation],uImmunizations );
  CallVistA('ORWPCE SK',    [uEncLocation],uSkinTests );
  CallVistA('ORWPCE PED',   [uEncLocation],uPatientEds );
  CallVistA('ORWPCE HF',    [uEncLocation],uHealthFactors );
  CallVistA('ORWPCE XAM',   [uEncLocation],uExams );

  if uVisitTypes.Count > 0    then uVisitTypes.Delete(0);             // discard counts
  if uDiagnoses.Count  > 0    then uDiagnoses.Delete(0);
  if uProcedures.Count > 0    then uProcedures.Delete(0);
  if uImmunizations.Count > 0 then uImmunizations.Delete(0);
  if uSkinTests.Count > 0     then uSkinTests.Delete(0);
  if uPatientEds.Count > 0    then uPatientEds.Delete(0);
  if uHealthFactors.Count > 0 then uHealthFactors.Delete(0);
  if uExams.Count > 0         then uExams.Delete(0);

  if (uVisitTypes.Count > 0) and (CharAt(uVisitTypes[0], 1) <> U) then uVisitTypes.Insert(0, U);
  if (uDiagnoses.Count > 0)  and (CharAt(uDiagnoses[0], 1)  <> U) then uDiagnoses.Insert(0,  U);
  if (uProcedures.Count > 0) and (CharAt(uProcedures[0], 1) <> U) then uProcedures.Insert(0, U);
  if (uImmunizations.Count > 0) and (CharAt(uImmunizations[0], 1) <> U) then uImmunizations.Insert(0, U);
  if (uSkinTests.Count > 0) and (CharAt(uSkinTests[0], 1) <> U) then uSkinTests.Insert(0, U);
  if (uPatientEds.Count > 0) and (CharAt(uPatientEds[0], 1) <> U) then uPatientEds.Insert(0, U);
  if (uHealthFactors.Count > 0) and (CharAt(uHealthFactors[0], 1) <> U) then uHealthFactors.Insert(0, U);
  if (uExams.Count > 0) and (CharAt(uExams[0], 1) <> U) then uExams.Insert(0, U);

end;

{Visit Types-------------------------------------------------------------------}
procedure ListVisitTypeSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uVisitTypes.Count - 1 do if CharAt(uVisitTypes[i], 1) = U then
  begin
    x := Piece(uVisitTypes[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uVisitTypes[i], U, 2) + U + x);
  end;
end;

procedure ListVisitTypeCodes(Dest: TStrings; SectionIndex: Integer);
{ return visit types in format: visit type <TAB> amount of time <TAB> CPT code <TAB> CPT code }
var
  i: Integer;
  s: string;

  function InsertTab(x: string): string;
  { turn the white space between the name and the number of minutes into a single tab }
  begin
    if CharAt(x, 20) = ' '
      then Result := Trim(Copy(x, 1, 20)) + U + Trim(Copy(x, 21, Length(x)))
      else Result := Trim(x) + U;
  end;

begin {ListVisitTypeCodes}
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uVisitTypes.Count) and (CharAt(uVisitTypes[i], 1) <> U) do
  begin
    s := Pieces(uVisitTypes[i], U, 1, 2) + U + InsertTab(Piece(uVisitTypes[i], U, 2)) + U + Piece(uVisitTypes[i], U, 1) +
         U + IntToStr(i);
    Dest.Add(s);
    Inc(i);
  end;
end;

procedure ListVisitTypeByLoc(Dest: TStrings; Location: integer;
  ADateTime: TFMDateTime = 0);
var
  Results: TStrings;
  i: integer;
  x, SectionName: string;
  EncDt: TFMDateTime;
begin
  EncDt := Trunc(ADateTime);
  if (uVTypeLastLoc <> Location) or (uVTypeLastDate <> EncDt) then
  begin
    uVTypeForLoc.clear;
    if Location = 0 then
      Exit;
    SectionName := '';
    Results := TStringList.Create;
    try
      CallVistA('ORWPCE VISIT', [Location, EncDt], Results);
      // with RPCBrokerV do
      for i := 0 to Results.Count - 1 do
      begin
        x := Results[i];
        if CharAt(x, 1) = U then
          SectionName := Piece(x, U, 2)
        else
          uVTypeForLoc.add(Piece(x, U, 1) + U + SectionName + U +
            Piece(x, U, 2));
      end;
    finally
      Results.free;
    end;
    uVTypeLastLoc := Location;
    uVTypeLastDate := EncDt;
  end;
  FastAssign(uVTypeForLoc, Dest);
end;

function AutoSelectVisit(Location: integer): boolean;
var
  s: String;
begin
  if UAutoSelLoc <> Location then
  begin
    UAutoSelVal := CallVistA('ORWPCE AUTO VISIT TYPE SELECT', [Location], s) and (s = '1');
    UAutoSelLoc := Location;
  end;
  Result := UAutoSelVal;
end;

{Diagnosis---------------------------------------------------------------------}
procedure ListDiagnosisSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;

begin
  if (uLastLocation <> uEncLocation) or (uLastDFN <> patient.DFN) or (uLastEncDt <> Trunc(GetEncounterDateTime))
  or PLUpdated or IsDateMoreRecent(PLUpdateDateTime, EncLoadDateTime) then RefreshPLDiagnoses;
  if PLUpdated then PLUpdated := False;
  for i := 0 to uDiagnoses.Count - 1 do if CharAt(uDiagnoses[i], 1) = U then
  begin
    x := Piece(uDiagnoses[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uDiagnoses[i], U, 2) + U + x);
  end;
end;

procedure ListDiagnosisCodes(Dest: TStrings; SectionIndex: Integer);
{ return diagnoses within section in format:
    diagnosis <TAB> ICDInteger <TAB> .ICDDecimal <TAB> ICD Code }
var
  i: Integer;
  t, c, f, p, ICDCSYS: string;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uDiagnoses.Count) and (CharAt(uDiagnoses[i], 1) <> U) do
  begin
    c := Piece(uDiagnoses[i], U, 1);
    t := Piece(uDiagnoses[i], U, 2);
    f := Piece(uDiagnoses[i], U, 3);
    p := Piece(uDiagnoses[i], U, 4);
    ICDCSYS := Piece(uDiagnoses[i], U, 5);
    //identify inactive codes.
    if (Pos('#', f) > 0) or (Pos('$', f) > 0) then
      t := '#  ' + t;
    Dest.Add(c + U + t + U + c + U + f + U + p + U + ICDCSYS);

    Inc(i);
  end;
end;

procedure AddProbsToDiagnoses;
var
  i: integer;                 //loop index
  EncDT: TFMDateTime;
  ICDVersion: String;
begin
  //get problem list
  EncDT := Trunc(GetEncounterDateTime);
  uLastDFN := patient.DFN;
  ICDVersion := piece(GetEncounterICDVersion, U, 1);
  CallVistA('ORWPCE ACTPROB', [Patient.DFN, EncDT],uProblems);
  if uProblems.count > 0 then
  begin
    //add category to udiagnoses
    uDiagnoses.add(U + DX_PROBLEM_LIST_TXT);
    for i := 1 to (uProblems.count-1) do //start with 1 because strings[0] is the count of elements.
    begin
      //filter out 799.9 and inactive codes when ICD-9 is active
       if (ICDVersion = 'ICD') and ((piece(uProblems.Strings[i],U,3) = '799.9') or (piece(uProblems.Strings[i],U,13) = '#')) then continue;
      // otherwise add all active problems (including 799.9, R69, and inactive codes) to udiagnosis
      uDiagnoses.add(piece(uProblems.Strings[i], U, 3) + U + piece(uProblems.Strings[i], U, 2) + U +
                       piece(uProblems.Strings[i], U, 13) + U + piece(uProblems.Strings[i], U, 1) + U +
                       piece(uProblems.Strings[i], U, 14));
    end;

    //1.3.10
    if BILLING_AWARE then
     begin
        //  add New Section and dx codes to Encounter Diagnosis Section and Code List.
        //  Diagnoses  ->  Provider/Patient/24 hrs
        uDiagnoses.add(UBAConst.ENCOUNTER_TODAYS_DX); //BAPHII 1.3.10
        //BADxList := AddProviderPatientDaysDx(UBACore.uDxLst, IntToStr(Encounter.Provider), Patient.DFN); //BAPHII 1.3.10
        rpcGetProviderPatientDaysDx(IntToStr(GetEncounterProvider), Patient.DFN); //BAPHII 1.3.10

        for i := 0 to (UBACore.uDxLst.Count-1) do //BAPHII 1.3.10
           uDiagnoses.add(UBACore.uDxLst[i]); //BAPHII 1.3.10
        //  Code added after presentation.....
        //  Add Personal Diagnoses Section and Codes to Encounter Diagnosis Section and Code List.
        UBACore.uDxLst.Clear;
        uDiagnoses.Add(UBAConst.ENCOUNTER_PERSONAL_DX);
        UBACore.uDxLst := rpcGetPersonalDxList(User.DUZ);
        for i := 0 to (UBACore.uDxLst.Count -1) do
        begin
            uDiagnoses.Add(UBACore.uDxLst.Strings[i]);
        end;
     end;

  end;
end;

procedure RefreshPLDiagnoses;
var
  i: integer;
  uDiagList: TStringList;
  EncDt: TFMDateTime;
begin
  EncDt := Trunc(GetEncounterDateTime);
  if GetEncounterVisitCategory = 'E' then
    EncDt := Trunc(FMNow);

  //add problems to the top of diagnoses.
  uDiagList := TStringList.Create;
  try
    uDiagnoses.clear;
    CallVistA('ORWPCE DIAG', [uEncLocation, EncDT, Patient.DFN], uDiagList);
    if uDiaglist.Count > 0 then
      uDiagnoses.add(uDiaglist.Strings[0]);
    AddProbsToDiagnoses;
    for i := 1 to (uDiagList.Count-1) do
      uDiagnoses.add(uDiaglist.Strings[i]);

  finally
    uDiagList.free;
  end;
end;

procedure UpdateDiagnosisObj(CodeNarr: String; ItemIndex: Integer);
//CodeNarr format = ICD-9/10 code ^ Narrative ^ ICD-9/10 code ^ # and/or $ ^ Problem IEN ^ ICD coding system (10D or ICD)
var
  i: Integer;
begin
  i := ItemIndex + 1;
  uDiagnoses[i] := Pieces(CodeNarr, U, 1, 2) + U + U + Piece(CodeNarr, U, 5) + U + Piece(CodeNarr, U, 6);
end;

{Immunizations-----------------------------------------------------------------}
procedure LoadImmReactionItems(Dest: TStrings);
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.11','.06','1'],Dest);
end;

procedure LoadImmSeriesItems(Dest: TStrings);
{loads items into combo box on Immunixation screen}
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.11','.04','1'],Dest);
end;

procedure ListImmunizSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uImmunizations.Count - 1 do if CharAt(uImmunizations[i], 1) = U then
  begin
    x := Piece(uImmunizations[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uImmunizations[i], U, 2) + U + x);
  end;
end;

procedure ListImmunizCodes(Dest: TStrings; SectionIndex: Integer);
{ return procedures within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uImmunizations.Count) and (CharAt(uImmunizations[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uImmunizations[i], U, 1, 2));
    Inc(i);
  end;
end;


{Procedures--------------------------------------------------------------------}
procedure ListProcedureSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uProcedures.Count - 1 do if CharAt(uProcedures[i], 1) = U then
  begin
    x := Piece(uProcedures[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uProcedures[i], U, 2) + U + x);
  end;
end;

procedure ListProcedureCodes(Dest: TStrings; SectionIndex: Integer);
{ return procedures within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
//Piece 12 are CPT Modifiers, Piece 13 is a flag indicating conversion of Piece 12 from
//modifier code to modifier IEN (updated in UpdateModifierList routine)
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uProcedures.Count) and (CharAt(uProcedures[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uProcedures[i], U, 1, 2) + U + Piece(uProcedures[i], U, 1) + U +
             Piece(uProcedures[i], U, 12) + U + Piece(uProcedures[i], U, 13) + U +
             IntToStr(i) + U + Piece(uProcedures[i], U, 3));
    Inc(i);
  end;
end;

function MixedCaseModifier(const inStr: string): string;
begin
  Result := inStr;
  SetPiece(Result, U, 2, MixedCase(Trim(Piece(Result, U, 2))));
end;

function ModifierIdx(ModIEN: string): integer;
var
  s: String;
  EncDt: TFMDateTime;
begin
  Result := uModifiers.IndexOfPiece(ModIEN);
  if(Result < 0) then
    begin
      EncDT := Trunc(GetEncounterDateTime);
      if EncDT = 0 then
        EncDT := FMToday;
      CallVistA('ORWPCE GETMOD', [ModIEN, EncDt], s);
      Result := uModifiers.Add(MixedCaseModifier(s));
    end;
end;

function ModifierList(CPTCode: string): string;
// uModifiers list contains <@>CPTCode;ModCount;^Mod1Index^Mod2Index^...^ModNIndex
//    or                    MODIEN^MODDescription^ModCode
const
  CPTCodeHeader = '<@>';
var
  i, idx: integer;
  s, ModIEN: string;
  EncDt: TFMDateTime;
  Results: TStrings;
begin
  EncDT := Trunc(GetEncounterDateTime);
  idx := uModifiers.IndexOfPiece(CPTCodeHeader + CPTCode, ';', 1);
  if(idx < 0) then
  begin
    Results := TStringList.Create;
    try
      CallVistA('ORWPCE CPTMODS', [CPTCode, EncDt], Results);
      s := CPTCodeHeader + CPTCode + ';' + IntToStr({RPCBrokerV.}Results.Count)
        + ';' + U;
      for i := 0 to Results.Count - 1 do
      begin
        ModIEN := Piece(Results[i], U, 1);
        idx := uModifiers.IndexOfPiece(ModIEN);
        if (idx < 0) then
          idx := uModifiers.add(MixedCaseModifier({RPCBrokerV.}Results[i]));
        s := s + IntToStr(idx) + U;
      end;
    finally
      Results.free;
    end;
    idx := uModifiers.Add(s);
  end;
  Result := uModifiers[idx];
end;

procedure ListCPTModifiers(Dest: TStrings; CPTCodes, NeededModifiers: string);
//CPTCodes expected in the format of code^code^code
//NeededModifiers in format of ModIEN1;ModIEN2;ModIEN3
var
  TmpSL: TStringList;
  i, j, idx, cnt, found: integer;
  s, Code: string;
begin
  if(not assigned(uModifiers)) then uModifiers := TORStringList.Create;
  if(copy(CPTCodes, length(CPTCodes), 1) <> U) then
    CPTCodes := CPTCodes + U;
  if(copy(NeededModifiers, length(NeededModifiers), 1) <> ';') then
    NeededModifiers := NeededModifiers + ';';

  TmpSL := TStringList.Create;
  try
    repeat
      i := pos(U, CPTCodes);
      if(i > 0) then
      begin
        Code := copy(CPTCodes, 1, i-1);
        delete(CPTCodes,1,i);
        if(Code <> '') then
          TmpSL.Add(ModifierList(Code));
        i := pos(U, CPTCodes);
      end;
    until(i = 0);
    if(TmpSL.Count = 0) then
      s := ';0;'
    else
    if(TmpSL.Count = 1) then
      s := TmpSL[0]
    else
    begin
      s := '';
      found := 0;
      cnt := StrToIntDef(piece(TmpSL[0], ';', 2), 0);
      for i := 1 to cnt do
      begin
        Code := U + Piece(TmpSL[0], U, i+1);
        for j := 1 to TmpSL.Count-1 do
        begin
          if(pos(Code + U, TmpSL[j]) = 0) then
          begin
            Code := '';
            break;
          end;
        end;
        if(Code <> '') then
        begin
          s := s + Code;
          inc(found);
        end;
      end;
      s := s + U;
      SetPiece(s , U, 1, ';' + IntToStr(Found) + ';');
    end;
  finally
    TmpSL.Free;
  end;

  Dest.Clear;
  cnt := StrToIntDef(piece(s, ';', 2), 0);
  if(NeededModifiers <> '') then
  begin
    found := cnt;
    repeat
      i := pos(';',NeededModifiers);
      if(i > 0) then
      begin
        idx := StrToIntDef(copy(NeededModifiers,1,i-1),0);
        if(idx > 0) then
        begin
          Code := IntToStr(ModifierIdx(IntToStr(idx))) + U;
          if(pos(U+Code, s) = 0) then
          begin
            s := s + Code;
            inc(cnt);
          end;
        end;
        delete(NeededModifiers,1,i);
      end;
    until(i = 0);
    if(found <> cnt) then
      SetPiece(s , ';', 2, IntToStr(cnt));
  end;
  for i := 1 to cnt do
  begin
    idx := StrToIntDef(piece(s, U, i + 1), -1);
    if(idx >= 0) then
      Dest.Add(uModifiers[idx]);
  end;
end;

function ModifierName(ModIEN: string): string;
begin
  if(not assigned(uModifiers)) then uModifiers := TORStringList.Create;
  Result := piece(uModifiers[ModifierIdx(ModIEN)], U, 2);
end;

function ModifierCode(ModIEN: string): string;
begin
  if(not assigned(uModifiers)) then uModifiers := TORStringList.Create;
  Result := piece(uModifiers[ModifierIdx(ModIEN)], U, 3);
end;

function UpdateModifierList(Dest: TStrings; Index: integer): string;
var
  i, idx, LastIdx: integer;
  Tmp, OKMods, Code: string;
  OK: boolean;

begin
  if(Piece(Dest[Index], U, 5) = '1') then
    Result := Piece(Dest[Index],U,4)
  else
  begin
    Tmp := Piece(Dest[Index], U, 4);
    Result := '';
    OKMods := ModifierList(Piece(Dest[Index], U, 1))+U;
    i := 1;
    repeat
      Code := Piece(Tmp,';',i);
      if(Code <> '') then
      begin
        LastIdx := -1;
        OK := FALSE;
        repeat
          idx := uModifiers.IndexOfPiece(Code, U, 3, LastIdx);
          if(idx >= 0) then
          begin
            if(pos(U + IntToStr(idx) + U, OKMods)>0) then
            begin
              Result := Result + piece(uModifiers[idx],U,1) + ';';
              OK := TRUE;
            end
            else
              LastIdx := Idx;
          end;
        until(idx < 0) or OK;
        inc(i);
      end
    until(Code = '');
    Tmp := Dest[Index];
    SetPiece(Tmp,U,4,Result);
    SetPiece(Tmp,U,5,'1');
    Dest[Index] := Tmp;
    idx := StrToIntDef(piece(Tmp,U,6),-1);
    if(idx >= 0) then
    begin
      Tmp := uProcedures[idx];
      SetPiece(Tmp,U,12,Result);
      SetPiece(Tmp,U,13,'1');
      uProcedures[idx] := Tmp;
    end;
  end;
end;

function UpdateVisitTypeModifierList(Dest: TStrings; Index: integer): string;
var
  i, idx, LastIdx: integer;
  Tmp, OKMods, Code: string;
  OK: boolean;

begin
  if(Piece(Dest[Index], U, 7) = '1') then
    Result := Piece(Dest[Index],U,6)
  else
  begin
    Tmp := Piece(Dest[Index], U, 6);
    Result := '';
    OKMods := ModifierList(Piece(Dest[Index], U, 1))+U;
    i := 1;
    repeat
      Code := Piece(Tmp,';',i);
      if(Code <> '') then
      begin
        LastIdx := -1;
        OK := FALSE;
        repeat
          idx := uModifiers.IndexOfPiece(Code, U, 3, LastIdx);
          if(idx >= 0) then
          begin
            if(pos(U + IntToStr(idx) + U, OKMods)>0) then
            begin
              Result := Result + piece(uModifiers[idx],U,1) + ';';
              OK := TRUE;
            end
            else
              LastIdx := Idx;
          end;
        until(idx < 0) or OK;
        inc(i);
      end
    until(Code = '');
    Tmp := Dest[Index];
    SetPiece(Tmp,U,6,Result);
    SetPiece(Tmp,U,7,'1');
    Dest[Index] := Tmp;
    idx := StrToIntDef(piece(Tmp,U,8),-1);
    if(idx >= 0) then
    begin
      Tmp := uProcedures[idx];
      SetPiece(Tmp,U,12,Result);
      SetPiece(Tmp,U,13,'1');
      uProcedures[idx] := Tmp;
    end;
  end;
end;


{SkinTests---------------------------------------------------------------------}
procedure LoadSkResultsItems(Dest: TStrings);
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.12','.04','1'],Dest);
end;

procedure ListSkinSections(Dest: TStrings);
{ return section names in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uSkinTests.Count - 1 do if CharAt(uSkinTests[i], 1) = U then
  begin
    x := Piece(uSkinTests[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uSkinTests[i], U, 2) + U + x);
  end;
end;


procedure ListSkinCodes(Dest: TStrings; SectionIndex: Integer);
{ return procedures within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uSkinTests.Count) and (CharAt(uSkinTests[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uSkinTests[i], U, 1, 2));
    Inc(i);
  end;
end;

{Standared Codes---------------------------------------------------------------}
function ListUCUMCodes(const StartFrom: string; Direction: integer; aLst: TStrings): boolean;
begin
  Result := CallVistA('ORWPCE5 UCUMLIST', [StartFrom, Direction], aLst);
end;

{Patient Education-------------------------------------------------------------}
procedure LoadPEDLevelItems(Dest: TStrings);
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.16','.06','1'],Dest);
end;

procedure ListPatientSections(Dest: TStrings);
{ return Sections in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uPatientEds.Count - 1 do if CharAt(uPatientEds[i], 1) = U then
  begin
    x := Piece(uPatientEds[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uPatientEds[i], U, 2) + U + x);
  end;
end;


procedure ListPatientCodes(Dest: TStrings; SectionIndex: Integer);
{ return PatientEds within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uPatientEds.Count) and (CharAt(uPatientEds[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uPatientEds[i], U, 1, 2));
    Inc(i);
  end;
end;



{HealthFactors-------------------------------------------------------------}
procedure LoadHFLevelItems(Dest: TStrings);
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.23','.04','1'],Dest);
end;

procedure ListHealthSections(Dest: TStrings);
{ return Sections in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uHealthFactors.Count - 1 do if CharAt(uHealthFactors[i], 1) = U then
  begin
    x := Piece(uHealthFactors[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uHealthFactors[i], U, 2) + U + x);
  end;
end;


procedure ListHealthCodes(Dest: TStrings; SectionIndex: Integer);
{ return PatientEds within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uHealthFactors.Count) and (CharAt(uHealthFactors[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uHealthFactors[i], U, 1, 2));
    Inc(i);
  end;
end;



{Exams-------------------------------------------------------------------------}
procedure LoadXAMResultsItems(Dest: TStrings);
begin
  CallVistA('ORWPCE GET SET OF CODES',['9000010.13','.04','1'],Dest);
end;

procedure LoadHistLocations(Dest: TStrings);
var
  i, j, tlen: integer;
  tmp: string;

begin
  CallVistA('ORQQPX GET HIST LOCATIONS',[],Dest);
  for i := 0 to (Dest.Count - 1) do
  begin
    tmp := MixedCase(dest[i]);
    j := pos(', ',tmp);
    tlen := length(tmp);
    if(j > 0) and (j < (tlen - 2)) and (pos(tmp[j+2],UpperCaseLetters) > 0) and
      (pos(tmp[j+3],LowerCaseLetters)>0) and ((j = (tlen-3)) or (pos(tmp[j+4],LowerCaseLetters)=0)) then
      tmp[j+3] := UpCase(tmp[j+3]);
    if(tlen > 1) then
    begin
      if(pos(tmp[tlen],Digits) > 0) and (pos(tmp[tlen-1],Digits)=0) then
        insert(' ',tmp, tlen);
    end;
    dest[i] := tmp;
  end;
end;

procedure ListExamsSections(Dest: TStrings);
{ return Sections in format: ListIndex^SectionName (sections begin with '^') }
var
  i: Integer;
  x: string;
begin
  if (uLastLocation <> uEncLocation) then LoadEncounterForm;
  for i := 0 to uExams.Count - 1 do if CharAt(uExams[i], 1) = U then
  begin
    x := Piece(uExams[i], U, 2);
    if Length(x) = 0 then x := '<No Section Name>';
    Dest.Add(IntToStr(i) + U + Piece(uExams[i], U, 2) + U + x);
  end;
end;


procedure ListExamsCodes(Dest: TStrings; SectionIndex: Integer);
{ return PatientEds within section in format: procedure <TAB> CPT code <TAB><TAB> CPT code}
var
  i: Integer;
begin
  Dest.Clear;
  i := SectionIndex + 1;           // first line after the section name
  while (i < uExams.Count) and (CharAt(uExams[i], 1) <> U) do
  begin
    Dest.Add(Pieces(uExams[i], U, 1, 2));
    Inc(i);
  end;
end;

{------------------------------------------------------------------------------}
function EligbleConditions(PCEData: TPCEData): TSCConditions;
{ return a record listing the conditions for which a patient is eligible }
var
  x: string;
  dt: TFMDateTime;
  loc, visit: Integer;

begin
  dt := Encounter.DateTime;
  visit := 0;
  loc := uEncLocation;
  if assigned(PCEData) then
  begin
    visit := PCEData.VisitIEN;
    if PCEData.Location > 0 then
      loc := PCEData.Location;
    if PCEData.VisitCategory = 'E' then
      dt := FMNow
    else
      dt := PCEData.VisitDateTime;
  end;
  if visit > 0 then
    CallVistA('ORWPCE SCSEL', [Patient.DFN, dt, loc, visit], x)
  else
    CallVistA('ORWPCE SCSEL', [Patient.DFN, dt, loc], x);
  with Result do
  begin
    SCAllow  := Piece(Piece(x, ';', 1), U, 1) = '1';
    SCDflt   := Piece(Piece(x, ';', 1), U, 2) = '1';
    AOAllow  := Piece(Piece(x, ';', 2), U, 1) = '1';
    AODflt   := Piece(Piece(x, ';', 2), U, 2) = '1';
    IRAllow  := Piece(Piece(x, ';', 3), U, 1) = '1';
    IRDflt   := Piece(Piece(x, ';', 3), U, 2) = '1';
    ECAllow  := Piece(Piece(x, ';', 4), U, 1) = '1';
    ECDflt   := Piece(Piece(x, ';', 4), U, 2) = '1';
    MSTAllow := Piece(Piece(x, ';', 5), U, 1) = '1';
    MSTDflt  := Piece(Piece(x, ';', 5), U, 2) = '1';
    HNCAllow := Piece(Piece(x, ';', 6), U, 1) = '1';
    HNCDflt  := Piece(Piece(x, ';', 6), U, 2) = '1';
    CVAllow  := Piece(Piece(x, ';', 7), U, 1) = '1';
    CVDflt   := Piece(Piece(x, ';', 7), U, 2) = '1';
    SHDAllow := Piece(Piece(x, ';', 8), U, 1) = '1';
    SHDDflt  := Piece(Piece(x, ';', 8), U, 2) = '1';
    // Camp Lejeune
    if IsLejeuneActive then
    begin
     CLAllow := Piece(Piece(x, ';', 9), U, 1) = '1';
     CLDflt  := Piece(Piece(x, ';', 9), U, 2) = '1';
    end;
  end;
end;

procedure ListSCDisabilities(Dest: TStrings);
{ return text listing a patient's rated disabilities and % service connected }
begin
  CallVistA('ORWPCE SCDIS', [Patient.DFN], Dest);
end;

procedure LoadPCEDataForNote(Dest: TStrings; ANoteIEN: Integer; VStr: string);
begin
  if(ANoteIEN < 1) then
    CallVistA('ORWPCE PCE4NOTE', [ANoteIEN, Patient.DFN, VStr], Dest)
  else
    CallVistA('ORWPCE PCE4NOTE', [ANoteIEN], Dest);
end;

function GetVisitIEN(NoteIEN: Integer): string;
begin
  if(NoteIEN < 1) then
    CallVistA('ORWPCE GET VISIT', [NoteIEN, Patient.DFN, GetEncounterVisitString], Result, '0')
  else
    CallVistA('ORWPCE GET VISIT', [NoteIEN], Result, '0');
  if Result = '' then
    Result := '0';
end;

//function SavePCEData(PCEList: TStringList; ANoteIEN, ALocation: integer; var VisitID: integer): boolean;
function SavePCEData(PCEList: TStringList; ANoteIEN, ALocation: integer; var isLock: boolean): boolean;
var
  alist: TStrings;
  i: integer;
  tmp, warn: string;
begin
  result := true;
  aList := TStringList.create;
  try
    isLock := false;
    CallVistA('ORWPCE SAVE', [PCEList, ANoteIEN, ALocation], alist);
    if aList.Count <= 0 then Exit;
    if Piece(alist[0], u, 1) = '1' then exit;
    if Piece(alist[0], u, 1) = '-4' then
      begin
        warn := 'The encounter record is currently locked.';
        isLock := true;
      end
    else warn := 'An error occurred saving encounter data.';
    result := false;
    tmp := '';
    for i := 1 to alist.Count - 1 do
      tmp := tmp + alist[i] + CRLF;
    infoBox(warn + CRLF + CRLF + tmp, 'Error saving data', MB_OK);
  finally
    FreeAndNil(aList);
  end;
end;

{-----------------------------------------------------------------------------}

function DataHasCPTCodes(AList: TStrings): boolean;
var
  i: integer;
  vl: string;
  sl: TStrings;
  iList: iORNetMult;
begin
  if(not assigned(uHasCPT)) then
    uHasCPT := TStringList.Create;
  Result := FALSE;
  i := 0;
  while(i < AList.Count) do
  begin
    vl := uHasCPT.Values[AList[i]];
    if(vl = '1') then
    begin
      Result := TRUE;
      exit;
    end
    else
    if(vl = '0') then
      AList.Delete(i)
    else
      inc(i);
  end;
  if(AList.Count > 0) then
  begin
    NewORNetMult(iList);
    for i := 0 to AList.Count-1 do
      iList.AddSubscript([inttostr(i+1)], AList[i]);
    sl := TStringList.Create;
    try
      CallVistA('ORWPCE HASCPT',[iList],sl);
      for i := 0 to sl.Count-1 do
      begin
        if(Piece(sl[i],'=',2) = '1') then
        begin
          Result := TRUE;
          break;
        end;
      end;
      FastAddStrings(sl, uHasCPT);

    finally
      sl.Free;
    end;
  end;
end;

function GetAskPCE(Loc: integer): TAskPCE;
var
  i: Integer;
begin
  if(uAPUser <> User.DUZ) or (uAPLoc <> Loc) then
  begin
    uAPUser := User.DUZ;
    uAPLoc := Loc;
    CallVistA('ORWPCE ASKPCE', [User.DUZ, Loc], i);
    uAPAsk := TAskPCE(i);
  end;
  Result := uAPAsk;
end;

function HasVisit(const ANoteIEN, ALocation: integer; const AVisitDate: TFMDateTime): Integer;
begin
  CallVistA('ORWPCE HASVISIT', [ANoteIEN, Patient.DFN, ALocation, AVisitDate], Result, -1);
end;

{-----------------------------------------------------------------------------}
function CheckActivePerson(provider:String;DateTime:TFMDateTime): boolean;
var
  RetVal: String;
begin
  CallVistA('ORWPCE ACTIVE PROV',[provider,FloatToStr(DateTime)], RetVal);
  Result := RetVal = '1';
end;

function ForcePCEEntry(Loc: integer): boolean;
var
  s: String;
begin
  if(Loc <> uLastForceLoc) then
  begin
    uLastForce := CallVistA('ORWPCE FORCE', [User.DUZ, Loc], s) and (s = '1');
    uLastForceLoc := Loc;
  end;
  Result := uLastForce;
end;

procedure LoadcboOther(Dest: TStrings; Location, fOtherApp: integer);
{ loads items into combo box on Immunization screen }
var
  IEN, RPC: string;
  TmpSL: TORStringList;
  i, j, idx, typ: integer;
  Results: TStrings;
begin
  TmpSL := TORStringList.Create;
  try
    idx := 0;
    case fOtherApp of
      PCE_IMM:
        begin
          typ := 1;
          RPC := 'ORWPCE GET IMMUNIZATION TYPE';
        end;
      PCE_SK:
        begin
          typ := 2;
          RPC := 'ORWPCE GET SKIN TEST TYPE';
        end;
      PCE_PED:
        begin
          typ := 3;
          RPC := 'ORWPCE GET EDUCATION TOPICS';
        end;
      PCE_HF:
        begin
          typ := 4;
          RPC := 'ORWPCE GET HEALTH FACTORS TY';
          idx := 1;
        end;
      PCE_XAM:
        begin
          typ := 5;
          RPC := 'ORWPCE GET EXAM TYPE';
        end;
    else
      begin
        typ := 0;
        RPC := '';
      end;
    end;
    if typ > 0 then
    begin
      if idx = 0 then
      begin
        if (typ = 1) or (typ = 2) then
          CallVistA(RPC, [GetEncounterDateTime], TmpSL)
        else
          CallVistA(RPC, [nil], TmpSL);
      end
      else
        CallVistA(RPC, [idx], TmpSL);

      Results := TStringList.Create;
      try
        CallVistA('ORWPCE GET EXCLUDED', [Location, typ], Results);
        for i := 0 to Results.Count - 1 do
        begin
          IEN := Piece(Results[i], U, 2);
          idx := TmpSL.IndexOfPiece(IEN);
          if idx >= 0 then
          begin
            TmpSL.Delete(idx);
            if fOtherApp = PCE_HF then
            begin
              j := 0;
              while (j < TmpSL.Count) do
              begin
                if IEN = Piece(TmpSL[j], U, 4) then
                  TmpSL.Delete(j)
                else
                  Inc(j);
              end;
            end;
          end;
        end;
      finally
        Results.free;
      end;

    end;
    FastAssign(TmpSL, Dest);
  finally
    TmpSL.free;
  end;
end;

procedure RemTaxWCodes(Dest: TStrings);
begin
  CallVistA('ORWPCE5 REMTAX', [], Dest);
end;

procedure TaxCodes(Dest: TStrings; Taxonomy: integer; Date: TFMDateTime);
begin
  CallVistA('ORWPCE5 TAXCODES', [Taxonomy, Date], Dest);
end;

{
function SetRPCEncouterInfo(PCEData: TPCEData): boolean;
begin
  if (SetRPCEncLocation(PCEData.location) = False) or (SetRPCEncDateTime(PCEData.DateTime) = False) then
    result := False
  else result := True;
end;
}

function SetRPCEncLocation(Loc: Integer): boolean;
begin
  uEncLocation := Loc;
  Result := (uEncLocation <> 0);
end;

{
function SetRPCEncDateTime(DT: TFMDateTime): boolean;
begin
  uEncDateTime := 0.0;
  result := False;
  uEncDateTime := DT;
  if uEncDateTime > 0.0 then result := true;
end;
}

function PCERPCEncLocation: integer;
begin
  result := uEncLocation;
end;

{
function PCERPCEncDateTime: TFMDateTime;
begin
  result := uEncDateTime;
end;
}

function GetLocSecondaryVisitCode(Loc: integer): char;
var
  s: String;
begin
  if (Loc <> uLastIsClinicLoc) then
  begin
    uLastIsClinicLoc := Loc;
    uLastIsClinic := CallVistA('ORWPCE ISCLINIC', [Loc], s) and ( s = '1');
  end;
  if uLastIsClinic then
    Result := 'I'
  else
    Result := 'D';
end;

function GAFOK: boolean;
var
  s: String;
begin
  if(not uGAFOKCalled) then
  begin
    uGAFOK := CallVistA('ORWPCE GAFOK', [], s) and ( s = '1');
    uGAFOKCalled := TRUE;
  end;
  Result := uGAFOK;
end;

function MHClinic(const Location: integer): boolean;
var
  s: String;
begin
  if GAFOK then
    Result := CallVistA('ORWPCE MHCLINIC', [Location], s) and (s = '1')
  else
    Result := FALSE;
end;

procedure RecentGAFScores(aDest: TStrings; const Limit: integer);
var
  aList: iORNetMult;
begin
  if(GAFOK) then
  begin
    newOrNetMult(aList);
    aList.AddSubscript(['DFN'], Patient.DFN);
    aList.AddSubscript(['LIMIT'], Limit);
    CallVistA('ORWPCE LOADGAF',[aList], aDest);
  end;
end;

function SaveGAFScore(const Score: integer; GAFDate: TFMDateTime; Staff: Int64): boolean;
var
  sl:TStrings;
  aList: IORNetMult;
begin
  Result := FALSE;
  if(GAFOK) then
  begin
    NewORNetMult(aList);
    aList.AddSubscript(['DFN'],Patient.DFN);
    aList.AddSubscript(['GAF'], Score);
    aList.AddSubscript(['DATE'], GAFDate);
    aList.AddSubscript(['STAFF'], Staff);
    sl := TSTringList.Create;
    try
      CallVistA('ORWPCE SAVEGAF',[aList],sl);
      Result := (sl.Count > 0) and (sl[0]='1');
    finally
      sl.Free;
    end;
  end;
end;

function GAFURL: string;
begin
  if(not uGAFURLChecked) then
  begin
    CallVistA('ORWPCE GAFURL', [], uGAFURL);
    uGAFURLChecked  := TRUE;
  end;
  Result := uGAFURL;
end;

function MHTestsOK: boolean;
var
  s: String;
begin
  if(not uMHOKChecked) then
  begin
    uMHOK := CallVistA('ORWPCE MHTESTOK', [], s) and (s = '1');
    uMHOKChecked := TRUE;
  end;
  Result := uMHOK;
end;

function MHTestAuthorized(Test: string): boolean;
var
  s: String;
begin
  Result := CallVistA('ORWPCE MH TEST AUTHORIZED', [Test, User.DUZ], s) and (s = '1');
end;

function AnytimeEncounters: Boolean;
var
  s: String;
begin
  if uAnytimeEnc < 0 then
  begin
    CallVistA('ORWPCE ANYTIME', [], s);
    uAnytimeEnc := ord(s = '1');
  end;
  Result := Boolean(uAnytimeEnc);
end;

function AutoCheckout(Loc: integer): Boolean;
var
  s: String;
begin
  if (uLastChkOutLoc <> Loc) then
  begin
    uLastChkOutLoc := Loc;
    uLastChkOut := CallVistA('ORWPCE ALWAYS CHECKOUT', [Loc], s) and
      (s = '1');
  end;
  Result := uLastChkOut;
end;

{ encounter capture functions ------------------------------------------------ }

function RequireExposures(ANote, ATitle: integer): Boolean;
{ *RAB 3/22/99* }
{ returns true if a progress note should require the expossure questions to be answered }
var
  s: String;
begin
  // if ANote <= 0
  // then Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', ['0', ATitle]), U, 15) = '1'
  // else Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [ANote]), U, 15) = '1';

  if ANote <= 0 then
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', ['0', ATitle], s)
  else
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote], s);

  Result := Result and (Piece(s, U, 15) = '1');
end;

function PromptForWorkload(ANote, ATitle: Integer; VisitCat: Char; StandAlone: boolean): Boolean;
{ returns true if a progress note should prompt for capture of encounter }
var
  X: string;

begin
  Result := FALSE;
  if (VisitCat <> 'A') and (VisitCat <> 'I') and (VisitCat <> 'T') then exit;
  if ANote <= 0 then
    CallVistA('TIU GET DOCUMENT PARAMETERS', ['0', ATitle], x)
  else
    CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote], x);

  if(Piece(X, U, 14) = '1') then exit; // Suppress DX/CPT  param is TRUE - don't ask
  if StandAlone then
    Result := TRUE
  else
    Result := (Piece(X, U, 16) = '1'); // Check  Ask DX/CPT  param
end;

function IsCancelOrNoShow(ANote: integer): boolean;
var
  s: String;
begin
  Result := CallVistA('ORWPCE CXNOSHOW', [ANote], s) and (s = '0');
end;

function IsNonCountClinic(ALocation: integer): boolean;
var
  s: String;
begin
  Result := CallVistA('ORWPCE1 NONCOUNT', [ALocation], s) and (s = '1');
end;

function CheckDailyHospitalization(APCEObject: TPCEData): Boolean;
var
  returnValue, FileCat, FileDate, visitString: string;
begin
  Result := True;
  if APCEObject.IsSecondaryVisit then
  begin
    FileCat := GetLocSecondaryVisitCode(APCEObject.Location);
    FileDate := FloatToStr(APCEObject.NoteDateTime);
    visitString :=  IntToStr(APCEObject.Location) + ';' + FileDate + ';' + FileCat;
  end
  else exit;
  CallVistA('TIU LINK SECONDARY VISIT',[Patient.DFN, APCEObject.NoteIEN, visitString], returnValue);
  if Piece(returnValue, U, 1) = '0' then
  begin
     Result := False;
     InfoBox(Piece(returnValue, U, 2), 'Document Linking Error', MB_OK or MB_ICONERROR);
  end;
end;

function DefaultProvider(ALocation: integer; AUser: Int64; ADate: TFMDateTime;
                                             ANoteIEN: integer): string;
begin
  CallVistA('TIU GET DEFAULT PROVIDER', [ALocation, AUser, ADate, ANoteIEN], Result);
end;

function IsUserAProvider(AUser: Int64; ADate: TFMDateTime): boolean;
var
  s: String;
begin
  Result := CallVistA('TIU IS USER A PROVIDER?', [AUser, ADate], s) and (s = '1');
end;

function IsUserAUSRProvider(AUser: Int64; ADate: TFMDateTime): boolean;
var
  s: String;
begin
  Result := CallVistA('TIU IS USER A USR PROVIDER', [AUser, ADate], s) and (s = '1');
end;

function GetUCUMInfo(DataType: string; Code: string): TUCUMInfo;
var
  key, data: string;
  idx: integer;

begin
  if (DataType = '') or (Code = '') then
    exit(nil);
  key := DataType + U + Code;
  idx := uMagData.IndexOfName(key);
  if idx >= 0 then
    Result := TUCUMInfo(uMagData.Objects[idx])
  else
  begin
    CallVistA('ORWPCE5 MAGDAT', [DataType, Code], data);
    if data = '' then
      Result := nil
    else
      Result := TUCUMInfo.Create(data);
    uMagData.AddPair(key, data, Result);
  end;
end;

procedure UpdateUCUMInfo(DataType, Code, Value: string);
var
  key, temp: string;
  idx: integer;
  info: TUCUMInfo;

begin
  if (DataType = '') or (Code = '') then
    exit;
  key := DataType + U + Code;
  if Strip(Value, U) = '' then
    Value := '';
  idx := uMagData.IndexOfName(key);
  if idx >= 0 then
  begin
    if uMagData.ValueFromIndex[idx] <> Value then
    begin
      info := TUCUMInfo(uMagData.Objects[idx]);
      CallVistA('ORWPCE5 MAGDAT', [DataType, Code], temp);
      uMagData.ValueFromIndex[idx] := temp;
      if temp = '' then
      begin
        if assigned(info) then
        begin
          info.Free;
          uMagData.Objects[idx] := nil;
        end;
      end
      else if assigned(info) then
        info.Update(temp)
      else
        uMagData.Objects[idx] := TUCUMInfo.Create(Value);
    end;
  end
  else
    uMagData.AddPair(key, Value, TUCUMInfo.Create(Value));
end;

procedure UpdateMagUCUMData(DataType, Code, Value: string);
begin

end;

function GetMagUCUMData(DataType: string; Code: string): string;
begin
  Result := '';
end;

//function HNCOK: boolean;
//begin
//  if uHNCOK < 0 then
//    uHNCOK := ord(sCallV('ORWPCE HNCOK', []) = '1');
//  Result := boolean(uHNCOK);
//end;

initialization
  uLastLocation := 0;
  uLastEncDt    := 0;
  uVTypeLastLoc := 0;
  uVTypeLastDate := 0;
  uMagData       := TStringList.Create;
  uDiagnoses     := TStringList.Create;
  uExams         := TStringList.Create;
  uHealthFactors := TStringList.Create;
  uImmunizations := TStringList.Create;
  uPatientEds    := TStringList.Create;
  uProcedures    := TStringList.Create;
  uSkinTests     := TStringList.Create;
  uVisitTypes    := TStringList.Create;
  uVTypeForLoc   := TStringList.Create;
  uProblems      := TStringList.Create;
  uDiagnosesTextList := TStringList.Create;

finalization
  KillObj(@uMagData, True);
  uDiagnoses.Free;
  uExams.Free;
  uHealthFactors.Free;
  uImmunizations.Free;
  uPatientEds.Free;
  uProcedures.Free;
  uSkinTests.free;
  uVisitTypes.Free;
  uVTypeForLoc.Free;
  uProblems.Free;
  uDiagnosesTextList.Free;
  KillObj(@uModifiers);
  KillObj(@uHasCPT);
end.

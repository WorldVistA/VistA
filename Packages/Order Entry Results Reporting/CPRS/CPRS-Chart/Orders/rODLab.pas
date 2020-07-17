unit rODLab;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs ;

     { Laboratory Ordering Calls }
function  ODForLab(aReturn: TStrings; Location: integer; Division: integer = 0): integer;
procedure LoadLabTestData(LoadData: TStringList; LabTestIEN: string) ;
procedure LoadSamples(LoadList: TStringList) ;
procedure LoadSpecimens(SpecimenList: TStringList) ;
function SubsetOfSpecimens(aReturn: TStrings; const StartFrom: string; Direction: Integer): integer;
function  CalcStopDate(Text: string): string ;
function  MaxDays(Location, Schedule: integer): integer;
function  IsLabCollectTime(ADateTime: TFMDateTime; Location: integer): boolean;
function  ImmediateCollectTimes(aReturn: TStrings): integer;
function  LabCollectFutureDays(Location: integer; Division: integer = 0): integer;
function  GetDefaultImmCollTime: TFMDateTime;
function  ValidImmCollTime(CollTime: TFMDateTime): string;
function  GetOneCollSamp(aReturn: TStrings; LRFSAMP: integer): integer;
function  GetOneSpecimen(LRFSPEC: integer): string;
procedure GetLabTimesForDate(Dest: TStrings; LabDate: TFMDateTime; Location: integer);
function  GetLastCollectionTime: string;
procedure GetPatientBBInfo(Dest: TStrings; PatientID: string; Loc: integer);
procedure ListForQuickOrders(var AListIEN, ACount: Integer; const DGrpNm: string);
procedure SubsetOfQuickOrders(Dest: TStringList; AListIEN, First, Last: Integer);
procedure GetPatientBloodResults(Dest: TStrings; PatientID: string; ATests: TStringList);
procedure GetPatientBloodResultsRaw(Dest: TStrings; PatientID: string; ATests: TStringList);
function  StatAllowed(PatientID: string): boolean;
function  RemoveCollTimeDefault: boolean;
function  GetDiagnosticPanelLocation: boolean;
procedure GetBloodComponents(Dest: TStrings);
procedure GetDiagnosticTests(Dest: TStrings);
function  NursAdminSuppress: boolean;
function  GetSubtype(TestName: string): string;
function  TNSDaysBack: integer;
procedure CheckForChangeFromLCtoWCOnAccept(Dest: TStrings; ALocation: integer; AStartDate, ACollType, ASchedule, ADuration: string);
procedure CheckForChangeFromLCtoWCOnRelease(Dest: TStrings; ALocation: integer; OrderList: TStringList);
function  GetLCtoWCInstructions(Alocation: integer): string;
procedure FormatLCtoWCDisplayTextOnAccept(InputList, OutputList: TStrings);
procedure FormatLCtoWCDisplayTextOnRelease(InputList, OutputList: TStrings);

const
  TX0 = 'The following Lab orders will be changed to Ward Collect:';
  TX2 = 'Order Date' + #9 +#9 + 'Reason Changed to Ward Collect';
  TX5 = 'Please contact the ward staff to insure the specimen is collected.';
  TX6 = 'You can print this screen for reference.';
  TX_BLANK = '';

implementation

uses  rODBase;

procedure GetBloodComponents(Dest: TStrings);
begin
  CallVistA('ORWDXVB COMPORD', [], Dest);
end;

procedure GetDiagnosticTests(Dest: TStrings);
begin
  CallVistA('ORWDXVB3 DIAGORD', [], Dest);
end;

function NursAdminSuppress: boolean;
var
  aInt: integer;
begin
  CallVistA('ORWDXVB NURSADMN',[nil], aInt);
  Result := (aInt < 1);
end;

function  StatAllowed(PatientID: string): boolean;
var
  aInt: integer;
begin
  CallVistA('ORWDXVB STATALOW',[PatientID], aInt);
  Result := (aInt > 0);
end;

function  RemoveCollTimeDefault: boolean;
var
  aInt: integer;
begin
  CallVistA('ORWDXVB3 COLLTIM',[nil], aInt);
  Result := (aInt > 0);
end;

function  GetDiagnosticPanelLocation: boolean;
var
  aInt: integer;
begin
  CallVistA('ORWDXVB3 SWPANEL',[nil], aInt);
  Result := (aInt > 0);
end;

procedure GetPatientBloodResultsRaw(Dest: TStrings; PatientID: string; ATests: TStringList);
begin
  CallVistA('ORWDXVB RAW', [PatientID, ATests], Dest);
end;

procedure GetPatientBloodResults(Dest: TStrings; PatientID: string; ATests: TStringList);
begin
  CallVistA('ORWDXVB RESULTS', [PatientID, ATests], Dest);
end;

procedure GetPatientBBInfo(Dest: TStrings; PatientID: string; Loc: integer);
begin
  CallVistA('ORWDXVB GETALL', [PatientID, Loc], Dest);
end;

function GetSubtype(TestName: string): string;
begin
  CallVistA('ORWDXVB SUBCHK', [TestName], Result);
end;

function TNSDaysBack: integer;
begin
  CallVistA('ORWDXVB VBTNS', [nil], Result, 3);
end;

procedure ListForQuickOrders(var AListIEN, ACount: Integer; const DGrpNm: string);
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWUL QV4DG', [DGrpNm], aLst);
    AListIEN := StrToIntDef(Piece(aLst[0], U, 1), 0);
    ACount   := StrToIntDef(Piece(aLst[0], U, 2), 0);
  finally
    FreeAndNil(aLst);
  end;
end;

procedure SubsetOfQuickOrders(Dest: TStringList; AListIEN, First, Last: Integer);
var
  i: Integer;
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWUL QVSUB', [AListIEN, '', ''], aLst);
    for i := 0 to aLst.Count -1 do
      Dest.Add(aLst[i]);
   finally
     FreeAndNil(aLst);
   end;
end;

function  ODForLab(aReturn: TStrings; Location: integer; Division: integer = 0): integer;
begin
  CallVistA('ORWDLR32 DEF', [Location,Division], aReturn);
  Result := aReturn.Count;
end;

procedure LoadLabTestData(LoadData: TStringList; LabTestIEN: string) ;
begin
  CallVistA('ORWDLR32 LOAD', [LabTestIEN], LoadData);
end;

procedure LoadSamples(LoadList: TStringList) ;
begin
  CallVistA('ORWDLR32 ALLSAMP', [nil], LoadList);
end;

function SubsetOfSpecimens(aReturn: TStrings; const StartFrom: string; Direction: Integer): integer;
begin
  CallVistA('ORWDLR32 ALLSPEC',[StartFrom, Direction], aReturn);
  Result := aReturn.Count;
end;

procedure LoadSpecimens(SpecimenList: TStringList) ;
begin
  CallVistA('ORWDLR32 ABBSPEC', [nil], SpecimenList);
end;

function CalcStopDate(Text: string): string ;
begin
  CallVistA('ORWDLR32 STOP', [Text], Result);
end ;

function MaxDays(Location, Schedule: integer): integer;
begin
  CallVistA('ORWDLR32 MAXDAYS',[Location, Schedule], Result);
end;

function IsLabCollectTime(ADateTime: TFMDateTime; Location: integer): boolean;
var
  aInt: integer;
begin
  CallVistA('ORWDLR32 LAB COLL TIME',[ADateTime,Location], aInt);
  Result := (aInt > 0);
end;

function  LabCollectFutureDays(Location: integer; Division: integer): integer;
begin
  CallVistA('ORWDLR33 FUTURE LAB COLLECTS', [Location, Division], Result);
end;

function  ImmediateCollectTimes(aReturn: TStrings): integer;
begin
  CallVistA('ORWDLR32 IMMED COLLECT', [nil], aReturn);
  Result := aReturn.Count;
end;

function  GetDefaultImmCollTime: TFMDateTime;
var
  aStr: string;
begin
  CallVistA('ORWDLR32 IC DEFAULT', [nil], aStr);
  Result := StrToFloat(Piece(aStr, U, 1));
end;

function  ValidImmCollTime(CollTime: TFMDateTime): string;
begin
  CallVistA('ORWDLR32 IC VALID', [CollTime], Result);
end;

function  GetOneCollSamp(aReturn: TStrings; LRFSAMP: integer): integer;
begin
  CallVistA('ORWDLR32 ONE SAMPLE', [LRFSAMP], aReturn);
  Result := aReturn.Count;
end;

function  GetOneSpecimen(LRFSPEC: integer): string;
begin
  CallVistA('ORWDLR32 ONE SPECIMEN', [LRFSPEC], Result);
end;

function  GetLastCollectionTime: string;
begin
  CallVistA('ORWDLR33 LASTTIME', [nil], Result);
end;

procedure GetLabTimesForDate(Dest: TStrings; LabDate: TFMDateTime; Location: integer);
var
  Prefix: string;
  i: integer;
begin
  CallVistA('ORWDLR32 GET LAB TIMES', [LabDate, Location], Dest);
  with Dest do
    if (Count > 0) and (Piece(Strings[0], U, 1) <> '-1') then
      for i := 0 to Count - 1 do
        begin
          if Strings[i] > '1159' then Prefix := 'PM Collection:  ' else Prefix := 'AM Collection:  ';
          Strings[i] := Strings[i] + U + Prefix + Copy(Strings[i], 1, 2) + ':' + Copy(Strings[i], 3, 2);
        end;
end;

procedure CheckForChangeFromLCtoWCOnAccept(Dest: TStrings; ALocation: integer; AStartDate, ACollType, ASchedule, ADuration: string);
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    CallVistA('ORCDLR2 CHECK ONE LC TO WC', [ALocation, '', AStartDate, ACollType, ASchedule, ADuration], AList);
    FormatLCtoWCDisplayTextOnAccept(AList, Dest);
  finally
    AList.Free;
  end;
end;

procedure CheckForChangeFromLCtoWCOnRelease(Dest: TStrings; ALocation: integer; OrderList: TStringList);
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    CallVistA('ORCDLR2 CHECK ALL LC TO WC', [ALocation, OrderList], AList);
    FormatLCtoWCDisplayTextOnRelease(AList, Dest);
  finally
    AList.Free;
  end;
end;

procedure FormatLCtoWCDisplayTextOnAccept(InputList, OutputList: TStrings);
var
  i: integer;
  x: string;
begin
  OutputList.Clear;
  for i := InputList.Count - 1 downto 0 do
    if Piece(InputList[i], U, 2) = '1' then InputList.Delete(i);
  if InputList.Count > 0 then
  begin
    SetListFMDateTime('mmm dd, yyyy@hh:nn', TStringList(InputList), U, 1);
    with OutputList do
    begin
      Add(TX0);
      Add(TX_BLANK);
      Add('Patient :' + #9 + Patient.Name);
      Add('SSN     :' + #9 + Patient.SSN);
      Add('Location:' + #9 + Encounter.LocationName + CRLF);
      for i := 0 to InputList.Count - 1 do
        Add(Piece(InputList[i], U, 1) + #9 + Piece(InputList[i], U, 3));
      Add(TX_BLANK);
      x := GetLCtoWCInstructions(Encounter.Location);
      if x = '' then x := TX5;
      Add(x);
      Add(TX6);
    end;
  end;
end;

procedure FormatLCtoWCDisplayTextOnRelease(InputList, OutputList: TStrings);
var
  i, j, k, Changed: integer;
  AList: TStringlist;
  x: string;
begin
  OutputList.Clear;
  Changed := StrToIntDef(ExtractDefault(InputList, 'COUNT'), 0);
  if Changed > 0 then
  begin
    AList := TStringList.Create;
    try
      with OutputList do
      begin
        Add(TX0);
        Add(TX_BLANK);
        Add('Patient :' + #9 + Patient.Name);
        Add('SSN     :' + #9 + Patient.SSN);
        Add('Location:' + #9 + Encounter.LocationName);
        for i := 1 to Changed do
        begin
          Add(TX_BLANK);
          AList.Clear;
          ExtractText(AList, InputList, 'ORDER_' + IntToStr(i));
          Add('Order   :' + #9 + AList[0]);
          k := Length(OutputList[Count-1]);
          if AList.Count > 1 then
            for j := 1 to AList.Count - 1 do
            begin
              Add(StringOfChar(' ', 9) + #9 + AList[j]);
              k := HigherOf(k, Length(OutputList[Count - 1]));
            end;
          Add(StringOfChar('-', k + 4));
          AList.Clear;
          ExtractItems(AList, InputList, 'ORDER_' + IntToStr(i));
          SetListFMDateTime('mmm dd, yyyy@hh:nn', AList, U, 1);
          for j := 0 to AList.Count - 1 do
            OutputList.Add(Piece(AList[j], U, 1) + #9 + Piece(AList[j], U, 3));
        end;
        Add(TX_BLANK);
        x := GetLCtoWCInstructions(Encounter.Location);
        if x = '' then x := TX5;
        Add(x);
        Add(TX6);
      end;
    finally
      AList.Free;
    end;
  end;
end;

function GetLCtoWCInstructions(Alocation: integer): string;
begin
  CallVistA('ORWDLR33 LC TO WC', [Encounter.Location], Result);
end;

end.



unit rODLab;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs ;

     { Laboratory Ordering Calls }
function  ODForLab(Location: integer; Division: integer = 0): TStrings;
procedure LoadLabTestData(LoadData: TStringList; LabTestIEN: string) ;
procedure LoadSamples(LoadList: TStringList) ;
procedure LoadSpecimens(SpecimenList: TStringList) ;
function  SubsetOfSpecimens(const StartFrom: string; Direction: Integer): TStrings;
function  CalcStopDate(Text: string): string ;
function  MaxDays(Location, Schedule: integer): integer;
function  IsLabCollectTime(ADateTime: TFMDateTime; Location: integer): boolean;
function  ImmediateCollectTimes: TStrings;
function  LabCollectFutureDays(Location: integer; Division: integer = 0): integer;
function  GetDefaultImmCollTime: TFMDateTime;
function  ValidImmCollTime(CollTime: TFMDateTime): string;
function  GetOneCollSamp(LRFSAMP: integer): TStrings;
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
  tCallV(Dest, 'ORWDXVB COMPORD', []);
end;

procedure GetDiagnosticTests(Dest: TStrings);
begin
  tCallV(Dest, 'ORWDXVB3 DIAGORD', []);
end;

function NursAdminSuppress: boolean;
begin
  Result := (StrToInt(sCallV('ORWDXVB NURSADMN',[nil])) < 1);
end;

function  StatAllowed(PatientID: string): boolean;
begin
  Result := (StrToInt(sCallV('ORWDXVB STATALOW',[PatientID])) > 0);
end;

function  RemoveCollTimeDefault: boolean;
begin
  Result := (StrToInt(sCallV('ORWDXVB3 COLLTIM',[nil])) > 0);
end;

function  GetDiagnosticPanelLocation: boolean;
begin
  Result := (StrToInt(sCallV('ORWDXVB3 SWPANEL',[nil])) > 0);
end;

procedure GetPatientBloodResultsRaw(Dest: TStrings; PatientID: string; ATests: TStringList);
begin
  tCallV(Dest, 'ORWDXVB RAW', [PatientID, ATests]);
end;

procedure GetPatientBloodResults(Dest: TStrings; PatientID: string; ATests: TStringList);
begin
  tCallV(Dest, 'ORWDXVB RESULTS', [PatientID, ATests]);
end;

procedure GetPatientBBInfo(Dest: TStrings; PatientID: string; Loc: integer);
begin
  tCallV(Dest, 'ORWDXVB GETALL', [PatientID, Loc]);
end;

function GetSubtype(TestName: string): string;
begin
  Result := sCallV('ORWDXVB SUBCHK', [TestName]);
end;

function TNSDaysBack: integer;
begin
  Result := StrToIntDef(sCallV('ORWDXVB VBTNS', [nil]),3);
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

function ODForLab(Location, Division: integer): TStrings;
{ Returns init values for laboratory dialog.  The results must be used immediately. }
begin
  CallV('ORWDLR32 DEF', [Location,Division]);
  Result := RPCBrokerV.Results;
end;

procedure LoadLabTestData(LoadData: TStringList; LabTestIEN: string) ;
begin
    tCallV(LoadData, 'ORWDLR32 LOAD', [LabTestIEN]);
end ;

procedure LoadSamples(LoadList: TStringList) ;
begin
    tCallV(LoadList, 'ORWDLR32 ALLSAMP', [nil]);
end ;

function SubsetOfSpecimens(const StartFrom: string; Direction: Integer): TStrings;
begin
  Callv('ORWDLR32 ALLSPEC',[StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end ;

procedure LoadSpecimens(SpecimenList: TStringList) ;
begin
  tCallV(SpecimenList, 'ORWDLR32 ABBSPEC', [nil]);
end ;

function CalcStopDate(Text: string): string ;
begin
  Result := sCallV('ORWDLR32 STOP', [Text]);
end ;

function MaxDays(Location, Schedule: integer): integer;
begin
  Result := StrToInt(sCallV('ORWDLR32 MAXDAYS',[Location, Schedule]));
end;

function IsLabCollectTime(ADateTime: TFMDateTime; Location: integer): boolean;
begin
  Result := (StrToInt(sCallV('ORWDLR32 LAB COLL TIME',[ADateTime,Location])) > 0);
end;

function  LabCollectFutureDays(Location: integer; Division: integer): integer;
begin
  Result := StrToInt(sCallV('ORWDLR33 FUTURE LAB COLLECTS',[Location, Division]));
end;

function  ImmediateCollectTimes: TStrings;
begin
  CallV('ORWDLR32 IMMED COLLECT',[nil]);
  Result := RPCBrokerV.Results;
end;

function  GetDefaultImmCollTime: TFMDateTime;
begin
  CallV('ORWDLR32 IC DEFAULT',[nil]);
  Result := StrToFloat(Piece(RPCBrokerV.Results[0], U, 1));
end;

function  ValidImmCollTime(CollTime: TFMDateTime): string;
begin
  CallV('ORWDLR32 IC VALID',[CollTime]);
  Result := RPCBrokerV.Results[0];
end;

function  GetOneCollSamp(LRFSAMP: integer): TStrings;
begin
  CallV('ORWDLR32 ONE SAMPLE', [LRFSAMP]);
  Result := RPCBrokerV.Results;
end;

function  GetOneSpecimen(LRFSPEC: integer): string;
begin
  Result := sCallV('ORWDLR32 ONE SPECIMEN', [LRFSPEC]);
end;

function  GetLastCollectionTime: string;
begin
  Result := sCallV('ORWDLR33 LASTTIME', [nil]);
end
;
procedure GetLabTimesForDate(Dest: TStrings; LabDate: TFMDateTime; Location: integer);
var
  Prefix: string;
  i: integer;
begin
  CallV('ORWDLR32 GET LAB TIMES', [LabDate, Location]);
  with Dest do
    begin
      Assign(RPCBrokerV.Results);
      if (Count > 0) and (Piece(Strings[0], U, 1) <> '-1') then
        for i := 0 to Count - 1 do
          begin
            if Strings[i] > '1159' then Prefix := 'PM Collection:  ' else Prefix := 'AM Collection:  ';
            Strings[i] := Strings[i] + U + Prefix + Copy(Strings[i], 1, 2) + ':' + Copy(Strings[i], 3, 2);
          end;
    end;
end;

procedure CheckForChangeFromLCtoWCOnAccept(Dest: TStrings; ALocation: integer; AStartDate, ACollType, ASchedule, ADuration: string);
var
  AList: TStringList;
begin
  AList := TStringList.Create;
  try
    CallV('ORCDLR2 CHECK ONE LC TO WC', [ALocation, '', AStartDate, ACollType, ASchedule, ADuration]);
    FastAssign(RPCBrokerV.Results, AList);
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
    CallV('ORCDLR2 CHECK ALL LC TO WC', [ALocation, OrderList]);
    FastAssign(RPCBrokerV.Results, AList);
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
    SetListFMDateTime('dddddd@hh:nn', TStringList(InputList), U, 1);
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
          SetListFMDateTime('dddddd@hh:nn', AList, U, 1);
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
  Result := sCallV('ORWDLR33 LC TO WC', [Encounter.Location]);
end;

end.



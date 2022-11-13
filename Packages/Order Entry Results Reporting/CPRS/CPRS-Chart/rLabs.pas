unit rLabs;

interface

uses SysUtils, Classes, ORNet, ORFn;

type

  TLabPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;


//function AtomicTests(const StartFrom: string; Direction: Integer): TStrings;
function setAtomicTests(aDest:TStrings;const StartFrom: string; Direction: Integer): Integer;

//function Specimens(const StartFrom: string; Direction: Integer): TStrings;
function setSpecimens(aDest:TStrings;const StartFrom: string; Direction: Integer): Integer;

//function AllTests(const StartFrom: string; Direction: Integer): TStrings;
function setAllTests(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;

//function ChemTest(const StartFrom: string; Direction: Integer): TStrings;
function setChemTest(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;

//function Users(const StartFrom: string; Direction: Integer): TStrings;
function setUsers(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;

//function TestGroups(user: int64): TStrings;
function setTestGroups(aDest: TStrings;user: int64): Integer;

//function ATest(test: integer): TStrings;
function setATest(aDest: TStrings;test: integer): Integer;

//function ATestGroup(testgroup: Integer; user: int64): TStrings;
function setATestGroup(aDest: TStrings;testgroup: Integer; user: int64): Integer;

procedure UTGAdd(tests: TStrings);

procedure UTGReplace(tests: TStrings; testgroup: integer);
procedure UTGDelete(testgroup: integer);
procedure SpecimenDefaults(var blood, urine, serum, plasma: string);
procedure Cumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ARpc: string);
procedure RemoteLabCumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure Interim(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabInterim(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure Micro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabMicro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);

//function InterimSelect(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
//  tests: TStrings): TStrings;  //*DFN*
function setInterimSelect(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  tests: TStrings): Integer;  //*DFN*

//function InterimGrid(const PatientDFN: string; ADate1: TFMDateTime;
//  direction, format: integer): TStrings;  //*DFN*
function setInterimGrid(aDest: TStrings; const PatientDFN: string; ADate1: TFMDateTime;
  direction, format: integer): Integer;  //*DFN*

//function Worksheet(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
//  spec: string; tests: TStrings): TStrings;  //*DFN*
function setWorksheet(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  spec: string; tests: TStrings): Integer;  //*DFN*

procedure Reports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ARpc: string);  //*DFN*
procedure RemoteLabReports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure RemoteLab(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
procedure GetNewestOldest(const PatientDFN: string; var newest, oldest: string);  //*DFN*

//function GetChart(const PatientDFN: string; ADate1, ADate2: TFMDateTime;
//  spec, test: string): TStrings;  //*DFN*
function setGetChart(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  spec, test: string): Integer;  //*DFN*

procedure PrintLabsToDevice(AReport: string; ADaysBack: Integer;
  const PatientDFN, ADevice: string; ATests: TStrings;
  var ErrMsg: string; ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string);
//function GetFormattedLabReport(AReport: string; ADaysBack: Integer; const PatientDFN: string;
//  ATests: TStrings; ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string): TStrings;
function setFormattedLabReport(aDest: TStrings; AReport: String; ADaysBack: Integer;
  const PatientDFN: string; ATests: TStrings; ADate1, ADate2: TFMDateTime;
  ARemoteSiteID, ARemoteQuery: string): Integer;

//function TestInfo(Test: String): TStrings;
function setTestInfo(aDest: TStrings;Test: String): Integer;

function LabPatchInstalled: boolean;
function UseRadioButtons: Boolean;

implementation

uses rCore, uCore, graphics, rMisc;

const
  PSI_05_118 = 'LR*5.2*364';
var
  uLabPatchInstalled: TLabPatchInstalled;


//function AtomicTests(const StartFrom: string; Direction: Integer): TStrings;
function setAtomicTests(aDest:TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
//  CallV('ORWLRR ATOMICS', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;
  CallVista('ORWLRR ATOMICS', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function Specimens(const StartFrom: string; Direction: Integer): TStrings;
function setSpecimens(aDest:TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
//  CallV('ORWLRR SPEC', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR SPEC', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function AllTests(const StartFrom: string; Direction: Integer): TStrings;
function setAllTests(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
//  CallV('ORWLRR ALLTESTS', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR ALLTESTS', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function ChemTest(const StartFrom: string; Direction: Integer): TStrings;
function setChemTest(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
//  CallV('ORWLRR CHEMTEST', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR CHEMTEST', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function Users(const StartFrom: string; Direction: Integer): TStrings;
function setUsers(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
//  CallV('ORWLRR USERS', [StartFrom, Direction]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR USERS', [StartFrom, Direction], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function TestGroups(user: int64): TStrings;
function setTestGroups(aDest: TStrings;user: int64): Integer;
begin
//  CallV('ORWLRR TG', [user]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR TG', [user], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function ATest(test: integer): TStrings;
function setATest(aDest: TStrings;test: integer): Integer;
begin
//  CallV('ORWLRR ATESTS', [test]);
//  MixedCaseList(RPCBrokerV.Results);
//  Result := RPCBrokerV.Results;

  CallVistA('ORWLRR ATESTS', [test], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

//function ATestGroup(testgroup: Integer; user: int64): TStrings;
function setATestGroup(aDest: TStrings;testgroup: Integer; user: int64): Integer;
begin
  CallVistA('ORWLRR ATG', [testgroup, user], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

procedure UTGAdd(tests: TStrings);
begin
  CallVistA('ORWLRR UTGA', [tests]);
end;

procedure UTGReplace(tests: TStrings; testgroup: integer);
begin
  CallVistA('ORWLRR UTGR', [tests, testgroup]);
end;

procedure UTGDelete(testgroup: integer);
begin
  CallVistA('ORWLRR UTGD', [testgroup]);
end;

procedure SpecimenDefaults(var blood, urine, serum, plasma: string);
var
  s: String;
begin
  CallVistA('ORWLRR PARAM', [nil],s);
  blood := Piece(s, '^', 1);
  urine := Piece(s, '^', 2);
  serum := Piece(s, '^', 3);
  plasma := Piece(s, '^', 4);
end;

procedure Cumulative(Dest: TStrings; const PatientDFN: string; daysback: integer; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallVistA(ARpc, [PatientDFN, daysback, ADate1, ADate2], Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabCumulative(Dest: TStrings; const PatientDFN: string;
  daysback: integer; ADate1, ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallVistA('XWB REMOTE RPC', [ASite, ARemoteRPC, 0, PatientDFN, daysback, Adate1, Adate2], Dest);
end;

procedure Interim(Dest: TStrings; const PatientDFN: string;
  ADate1, ADate2: TFMDateTime; ARpc: string); // *DFN*
begin
  if Length(ARpc) > 0 then
  begin
    CallVista(ARpc, [PatientDFN, ADate1, ADate2], Dest);
  end
  else
  begin
    Dest.Add('RPC is missing from report definition (file 101.24).');
    Dest.Add('Please contact Technical Support.');
  end;
end;

procedure RemoteLabInterim(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallVistA('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN, Adate1, Adate2], Dest);
end;

procedure Micro(Dest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallVistA(ARpc, [PatientDFN, ADate1, ADate2], Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabMicro(Dest: TStrings; const PatientDFN: string; ADate1,
  ADate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallVistA('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN, Adate1, Adate2],Dest);
end;

function setInterimSelect(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  tests: TStrings): Integer;  //*DFN*
begin
  CallVistA('ORWLRR INTERIMS', [PatientDFN, ADate1, ADate2, tests],aDest);
  Result := aDest.Count;
end;

function setInterimGrid(aDest: TStrings; const PatientDFN: string; ADate1: TFMDateTime;
  direction, format: integer): Integer;  //*DFN*
begin
  CallVistA('ORWLRR INTERIMG', [PatientDFN, ADate1, direction, format], aDest);
  Result := aDest.Count;
end;

function setWorksheet(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime;
  spec: string; tests: TStrings): Integer;  //*DFN*
begin
  CallVistA('ORWLRR GRID', [PatientDFN, ADate1, ADate2, spec, tests],aDest);
  Result := aDest.Count;
end;

procedure Reports(Dest: TStrings; const PatientDFN: string; reportid, hstype, ADate, section: string; Adate1, Adate2: TFMDateTime; ARpc: string);  //*DFN*
begin
  if Length(ARpc) > 0 then
    begin
      CallVistA(ARpc, [PatientDFN, reportid, hstype, ADate, section, Adate2, Adate1],Dest);
    end
  else
    begin
      Dest.Add('RPC is missing from report definition (file 101.24).');
      Dest.Add('Please contact Technical Support.');
    end;
end;

procedure RemoteLabReports(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallVistA('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN,
        reportid + ';1', hstype, ADate, section, Adate2, Adate1], Dest);
end;

procedure RemoteLab(Dest: TStrings; const PatientDFN: string; reportid, hstype,
  ADate, section: string; Adate1, Adate2: TFMDateTime; ASite, ARemoteRPC: String);
begin
  CallVistA('XWB REMOTE RPC',[ASite, ARemoteRPC, 0, PatientDFN,
        reportid + ';1', hstype, ADate, section, Adate2, Adate1], Dest);
end;

procedure GetNewestOldest(const PatientDFN: string; var newest, oldest: string);  //*DFN*
var
  s: String;
begin
  CallVistA('ORWLRR NEWOLD', [PatientDFN],s);
  newest := Piece(s, '^', 1);
  oldest := Piece(s, '^', 2);
end;

function setGetChart(aDest: TStrings; const PatientDFN: string; ADate1, ADate2: TFMDateTime; spec, test: string): Integer;  //*DFN*
begin
  CallVistA('ORWLRR CHART', [PatientDFN, ADate1, ADate2, spec, test], aDest);
  Result := aDest.Count;
end;

procedure PrintLabsToDevice(AReport: string; ADaysBack: Integer;
 const PatientDFN, ADevice: string; ATests: TStrings; var ErrMsg: string;
 ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string);
{ prints a report on the selected device }
var
  j: integer;
  RemoteHandle,Report: string;
  aHandles: TStringlist;
begin
  aHandles := TStringList.Create;
  if Length(ARemoteSiteID) > 0 then
    begin
      RemoteHandle := '';
      for j := 0 to RemoteReports.Count - 1 do
        begin
          Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
          if Report = ARemoteQuery then
            begin
              RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
                + '^' + Pieces(Report,'^',9,10);
              break;
            end;
        end;
      if Length(RemoteHandle) > 1 then
        with RemoteSites.SiteList do
            aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
    end;
  if aHandles.Count > 0 then
    begin
      CallVistA('ORWRP PRINT LAB REMOTE',[ADevice, PatientDFN, AReport, aHandles],ErrMsg);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end
  else
    begin
      CallVistA('ORWRP PRINT LAB REPORTS',[ADevice, PatientDFN, AReport,
        ADaysBack, ATests, ADate2, ADate1], ErrMsg);
      if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
    end;
  aHandles.Clear;
  aHandles.Free;
end;

// function GetFormattedLabReport(AReport: String; ADaysBack: Integer;
// const PatientDFN: string; ATests: TStrings; ADate1, ADate2: TFMDateTime;
// ARemoteSiteID, ARemoteQuery: string): TStrings;
function setFormattedLabReport(aDest: TStrings; AReport: String;
  ADaysBack: Integer; const PatientDFN: string; ATests: TStrings;
  ADate1, ADate2: TFMDateTime; ARemoteSiteID, ARemoteQuery: string): Integer;
{ prints a report on the selected Windows device }
var
  j: Integer;
  RemoteHandle, Report: string;
  aHandles: TStringlist;
begin
  aHandles := TStringlist.Create;
  if Length(ARemoteSiteID) > 0 then
  begin
    RemoteHandle := '';
    for j := 0 to RemoteReports.Count - 1 do
    begin
      Report := TRemoteReport(RemoteReports.ReportList.Items[j]).Report;
      if Report = ARemoteQuery then
      begin
        RemoteHandle := TRemoteReport(RemoteReports.ReportList.Items[j]).Handle
          + '^' + Pieces(Report, '^', 9, 10);
        break;
      end;
    end;
    if Length(RemoteHandle) > 1 then
      with RemoteSites.SiteList do
        aHandles.Add(ARemoteSiteID + '^' + RemoteHandle);
  end;
  if aHandles.Count > 0 then
    CallVista('ORWRP PRINT WINDOWS LAB REMOTE',
      [PatientDFN, AReport, aHandles], aDest)
  else
    CallVista('ORWRP WINPRINT LAB REPORTS', [PatientDFN, AReport, ADaysBack,
      ATests, ADate2, ADate1], aDest);
  Result := aDest.Count;
  aHandles.Clear;
  aHandles.Free;
end;

//function TestInfo(Test: String): TStrings;
function setTestInfo(aDest: TStrings;Test: String): Integer;
begin
  CallVistA('ORWLRR INFO',[Test],aDest);
  Result := aDest.Count;
end;

function LabPatchInstalled: boolean;
begin
  with uLabPatchInstalled do
    if not PatchChecked then
      begin
        PatchInstalled := ServerHasPatch(PSI_05_118);
        PatchChecked := True;
      end;
  Result := uLabPatchInstalled.PatchInstalled;
end;

function UseRadioButtons: boolean;
var
  aStr: string;
begin
  if not RPCCheck('ORWRP1A RADIO') then
    raise Exception.Create('RPC ORWRP1A RADIO does not exist on the server');

  CallVista('ORWRP1A RADIO', [], aStr);
  Result := CompareStr(aStr, '1') = 0;
end;

end.

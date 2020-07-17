unit rODRad;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs;

{ Radiology Ordering Calls }
function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer)
  : TStrings; // *DFN*
function IsRadProcsLongList(ImagingType: integer): boolean;
function SubsetOfRadProcs(ImagingType: integer; const StartFrom: string;
  Direction: integer): TStringList;
function ImagingMessage(AnIEN: integer): string;
function PatientOnIsolationProcedures(const PatientDFN: string): boolean;
// *DFN*
function SubsetOfRadiologists: TStrings;
function SubsetOfImagingTypes: TStrings;
function SubsetOfRadSources(SrcType: string): TStrings;
function LocationType(Location: integer): string;
function ReasonForStudyCarryOn: boolean;

implementation

uses rODBase;
(* fODBase, rODBase, fODRad; *)

function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer)
  : TStrings; // *DFN*
{ Returns init values for radiology dialog.  The results must be used immediately. }
begin
  { 276867
    //  CallV('ORWDRA32 DEF', [PatientDFN, AnEventDiv, ImagingType]);
    //  Result := RPCBrokerV.Results;
  }
  Result := TSTringList.Create;
  if not CallVistA('ORWDRA32 DEF', [PatientDFN, AnEventDiv, ImagingType],
    Result) then
    Result.Clear;
end;

function IsRadProcsLongList(ImagingType: integer): boolean;
var
  s: string;
begin
  CallVistA('ORWDRA32 RADLONG', [ImagingType],s);
  Result := (s = '1');
end;

function SubsetOfRadProcs(ImagingType: integer; const StartFrom: string;
  Direction: integer): TStringList;
// Needed separate call because of 'RA REQUIRE DETAILED' divisional parameter.
// Screens out 'Broad' procedures if parameter true.
begin
  Result := TStringList.Create;
  // Callv('ORWDRA32 RAORDITM',[StartFrom, Direction, ImagingType]);
  // Result := RPCBrokerV.Results;
  if not CallVistA('ORWDRA32 RAORDITM', [StartFrom, Direction, ImagingType],
    Result) then
    Result.Clear;
end;

function ImagingMessage(AnIEN: integer): string;
var
//  x: string;
//  i: integer;
  sl: TStrings;
begin
  sl := TStringList.Create;
//  CallV('ORWDRA32 PROCMSG', [AnIEN]);
//  for i := 0 to RPCBrokerV.Results.Count - 1 do
//    x := x + RPCBrokerV.Results[i] + #13#10;
//  Result := x;
  if not CallVistA('ORWDRA32 PROCMSG', [AnIEN],sl) then
    sl.Clear;
  Result := sl.Text;
  sl.Free;
end;

function PatientOnIsolationProcedures(const PatientDFN: string): boolean;
var
  s: String;
begin
  // RTC 272867
  // Result := (StrToInt(Piece(sCallV('ORWDRA32 ISOLATN', [PatientDFN]),U,1)) > 0) ;
  Result := CallVistA('ORWDRA32 ISOLATN', [PatientDFN], s) and
    (StrToIntDef(Piece(s, U, 1), -1) > 0);
end;

function SubsetOfRadiologists: TStrings;
begin
  { 272867
    //  Callv('ORWDRA32 APPROVAL',['']);
    //  Result := RPCBrokerV.Results ;
  }
  Result := TSTringList.Create;
  if not CallVistA('ORWDRA32 APPROVAL', [''], Result) then
    Result.Clear;
end;

function SubsetOfImagingTypes: TStrings;
begin
  { 272867
    Callv('ORWDRA32 IMTYPSEL',['']);
    Result := RPCBrokerV.Results ;
  }
  Result := TSTringList.Create;
  if not CallVistA('ORWDRA32 IMTYPSEL', [''], Result) then
    Result.Clear;
end;

function SubsetOfRadSources(SrcType: string): TStrings;
begin
  { 272867
    Callv('ORWDRA32 RADSRC',[SrcType]);
    Result := RPCBrokerV.Results ;
  }
  Result := TSTringList.Create;
  if not CallVistA('ORWDRA32 RADSRC', [SrcType], Result) then
    Result.Clear;
end;

function LocationType(Location: integer): string;
begin
  // RTC 272867
  // Result := sCallV('ORWDRA32 LOCTYPE',[Location]);
  if not CallVistA('ORWDRA32 LOCTYPE', [Location], Result) then
    Result := '';
end;

function ReasonForStudyCarryOn: boolean;
var
  s: String;
begin
  // RTC 272867
  // Result := sCallV('ORWDXM1 SVRPC',['']) = '1';
  Result := CallVistA('ORWDXM1 SVRPC', [''], s) and (s = '1');
end;

end.

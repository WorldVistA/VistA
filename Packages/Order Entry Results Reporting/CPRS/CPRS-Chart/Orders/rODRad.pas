unit rODRad;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs;

{ Radiology Ordering Calls }
//function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer)
//  : TStrings; // *DFN*
procedure ODForRad(sl: TStrings; const PatientDFN, AnEventDiv: string; ImagingType: integer);
function IsRadProcsLongList(ImagingType: integer): boolean;
function SubsetOfRadProcs(ImagingType: integer; const StartFrom: string;
  Direction: integer): TStringList;
function ImagingMessage(AnIEN: integer): string;
function PatientOnIsolationProcedures(const PatientDFN: string): boolean;
// *DFN*
procedure SubsetOfRadiologists(Dest: TStrings);
procedure SubsetOfImagingTypes(Dest: TStrings; CheckWriteAccess: boolean = True);
procedure SubsetOfRadSources(Dest: TStrings; SrcType: string);
function LocationType(Location: integer): string;
function ReasonForStudyCarryOn: boolean;

implementation

uses rODBase, uOrders;
(* fODBase, rODBase, fODRad; *)

//function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer)
procedure ODForRad(sl: TStrings; const PatientDFN, AnEventDiv: string; ImagingType: integer);
{ Returns init values for radiology dialog.  The results must be used immediately. }
begin
  { 276867
    //  CallV('ORWDRA32 DEF', [PatientDFN, AnEventDiv, ImagingType]);
    //  Result := RPCBrokerV.Results;
  }
  try
    if not CallVistA('ORWDRA32 DEF', [PatientDFN, AnEventDiv, ImagingType], sl) then
      sl.Clear;
  except
    on E: Exception do
      sl.Clear;
  end;
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
  try
    if not CallVistA('ORWDRA32 RAORDITM', [StartFrom, Direction, ImagingType],
      Result) then
      Result.Clear;
  except
    on E: Exception do
      Result.Clear;
  end;
end;

function ImagingMessage(AnIEN: integer): string;
var
  sl: TStrings;
//  x: string;
  i: integer;
begin
  // CallV('ORWDRA32 PROCMSG', [AnIEN]);
  // for i := 0 to RPCBrokerV.Results.Count - 1 do
  // x := x + RPCBrokerV.Results[i] + #13#10;
  // Result := x;
  Result := '';
  sl := TSTringList.Create;
  try
    if CallVistA('ORWDRA32 PROCMSG', [AnIEN], sl) then
      for i := 0 to sl.Count - 1 do
        Result := Result + sl[i] + CRLF;
  finally
    sl.Free;
  end;
end;

function PatientOnIsolationProcedures(const PatientDFN: string): boolean;
var
  s: String;
begin
  try
    Result := CallVistA('ORWDRA32 ISOLATN', [PatientDFN], s);
    if Result then
      Result := StrToIntDef(Piece(s, U, 1), -1) > 0;
  except
    On E: Exception do
      Result := false;
  end;
end;

procedure SubsetOfRadiologists(Dest: TStrings);
begin
  { 272867
    //  Callv('ORWDRA32 APPROVAL',['']);
    //  Result := RPCBrokerV.Results ;
  }
  CallVistA('ORWDRA32 APPROVAL', [''], Dest);
end;

procedure SubsetOfImagingTypes(Dest: TStrings; CheckWriteAccess: boolean = True);
var
  i, DGroup: Integer;

begin
  CallVistA('ORWDRA32 IMTYPSEL', [''], Dest);
  if CheckWriteAccess then
    for i := Dest.Count - 1 downto 0 do
    begin
      DGroup := StrToIntDef(Piece(Dest[i], u, 4), 0);
      if not canWriteOrder(DGroup) then
        Dest.Delete(i);
    end;
end;

procedure SubsetOfRadSources(Dest: TStrings; SrcType: string);
begin
  { 272867
    Callv('ORWDRA32 RADSRC',[SrcType]);
    Result := RPCBrokerV.Results ;
  }
  CallVistA('ORWDRA32 RADSRC', [SrcType], Dest);
end;

function LocationType(Location: integer): string;
begin
  // RTC 272867
  // Result := sCallV('ORWDRA32 LOCTYPE',[Location]);
  CallVistA('ORWDRA32 LOCTYPE', [Location], Result);
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

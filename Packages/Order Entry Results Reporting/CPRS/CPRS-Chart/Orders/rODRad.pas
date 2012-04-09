unit rODRad;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs ;

     { Radiology Ordering Calls }
function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer): TStrings;  //*DFN*
function SubsetOfRadProcs(ImagingType: integer; const StartFrom: string; Direction: Integer): TStrings;
function ImagingMessage(AnIEN: Integer): string;
function PatientOnIsolationProcedures(const PatientDFN: string): boolean ;  //*DFN*
function SubsetOfRadiologists: TStrings;
function SubsetOfImagingTypes: TStrings;
function SubsetOfRadSources(SrcType: string): TStrings;
function LocationType(Location: integer): string;
function ReasonForStudyCarryOn: Boolean;

implementation

uses   rODBase;
(*    fODBase, rODBase, fODRad;*)


function ODForRad(const PatientDFN, AnEventDiv: string; ImagingType: integer): TStrings;  //*DFN*
{ Returns init values for radiology dialog.  The results must be used immediately. }
begin
  CallV('ORWDRA32 DEF', [PatientDFN, AnEventDiv, ImagingType]);
  Result := RPCBrokerV.Results;
end;

function SubsetOfRadProcs(ImagingType: integer; const StartFrom: string; Direction: Integer): TStrings;
  // Needed separate call because of 'RA REQUIRE DETAILED' divisional parameter.
  // Screens out 'Broad' procedures if parameter true.
begin
  Callv('ORWDRA32 RAORDITM',[StartFrom, Direction, ImagingType]);
  Result := RPCBrokerV.Results;
end ;

function ImagingMessage(AnIEN: Integer): string;
var
   x: string ;
   i: integer ;
begin
    CallV('ORWDRA32 PROCMSG', [AnIEN]);
    for i := 0 to RPCBrokerV.Results.Count-1 do
       x := x + RPCBrokerV.Results[i] + #13#10 ;
    Result := x ;
end;

function PatientOnIsolationProcedures(const PatientDFN: string): boolean ;  //*DFN*
begin
  Result := (StrToInt(Piece(sCallV('ORWDRA32 ISOLATN', [PatientDFN]),U,1)) > 0) ;
end ;

function SubsetOfRadiologists: TStrings;
begin
  Callv('ORWDRA32 APPROVAL',['']);
  Result := RPCBrokerV.Results ;
end ;

function SubsetOfImagingTypes: TStrings;
begin
  Callv('ORWDRA32 IMTYPSEL',['']);
  Result := RPCBrokerV.Results ;
end ;

function SubsetOfRadSources(SrcType: string): TStrings;
begin
  Callv('ORWDRA32 RADSRC',[SrcType]);
  Result := RPCBrokerV.Results ;
end ;

function LocationType(Location: integer): string;
begin
  Result := sCallV('ORWDRA32 LOCTYPE',[Location]);
end;

function ReasonForStudyCarryOn: Boolean;
begin
  Result := sCallV('ORWDXM1 SVRPC',['']) = '1';
end;

end.

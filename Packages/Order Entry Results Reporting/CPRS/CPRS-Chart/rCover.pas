unit rCover;

interface

uses
  SysUtils,
  Windows,
  Classes;

function DetailProblem(IEN: Integer): TStrings;
{ 1 reference in fProbs.pas / move function to rProbs.pas or build a TProblemController }
function DetailAllergy(IEN: Integer): TStrings;
{ 3 refs in fPtCWAD (2 commented out), 1 ref in fAllgyBox should really build TAllergyController }
function DetailPosting(ID: string): TStrings;
{ 2 refs in fPtCWAD, 1 ref in fPatientFLagMulti, 1 ref in fARTallgy need a TPostingController as well }
procedure ListAllergies(Dest: TStrings);
{ 1 ref fPtCWAD, 1 ref fARTAllgy, 1 ref fODAllgy need TAllergyController again }
procedure ListPostings(Dest: TStrings);
{ 1 ref fPtCWAD need TPostingController would be nice here }
procedure LoadDemographics(Dest: TStrings);
{ 1 ref fPtDemo / move function to TPatient or rCore or... TPatientController }

implementation

uses
  uCore,
  ORNet,
  ORFn;

function DetailProblem(IEN: Integer): TStrings;
begin
  Result := TStringList.Create;
  CallVistA('ORQQPL DETAIL', [Patient.DFN + '^' + FloatToStr(Encounter.DateTime), IEN, ''], Result);
end;

function DetailAllergy(IEN: Integer): TStrings;
begin
  Result := TStringList.Create;
  CallVistA('ORQQAL DETAIL', [Patient.DFN, IEN, ''], Result);
end;

function DetailPosting(ID: string): TStrings;
begin
  Result := TStringList.Create;
  if ID = 'A' then
    CallVistA('ORQQAL LIST REPORT', [Patient.DFN], Result)
  else if Copy(ID,1,3) = 'WH^' then // TDrugs Patch OR*3*377 and WV*1*24 - DanP@SLC 11-20-2015
    CallVistA('WVRPCOR POSTREP', [Patient.DFN, Copy(ID,4,1)], Result)
  else if Length(ID) > 0 then
    CallVistA('TIU GET RECORD TEXT', [ID], Result);
end;

procedure ListAllergies(Dest: TStrings);
begin
  CallVistA('ORQQAL LIST', [Patient.DFN], Dest);
  MixedCaseList(Dest);
end;

procedure ListPostings(Dest: TStrings);
begin
  CallVistA('ORQQPP LIST', [Patient.DFN], Dest);
  MixedCaseList(Dest);
//  SetListFMDateTime('mmm dd,yy', TStringList(Dest), U, 3);
  SetListFMDateTime('mmm dd,yy', Dest, U, 3);
end;

procedure LoadDemographics(Dest: TStrings);
begin
  CallVistA('ORWPT PTINQ', [Patient.DFN], Dest);
end;

end.

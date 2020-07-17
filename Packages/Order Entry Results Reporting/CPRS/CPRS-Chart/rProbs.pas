unit rProbs;

interface

uses SysUtils, Classes, ORNet, ORFn, uCore;

function AddSave(PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String; aReturn: TStrings): integer;
function AuditHistory(ProblemIFN: string; aReturn: TStrings): integer;
function ClinicFilterList(LocList: TStringList; aReturn: TStrings): integer;
function ClinicSearch(DummyArg: string; aReturn: TStrings): integer;
function ProblemDelete(ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string; aReturn: TStrings): integer;
{function ProblemDetail}
function EditLoad(ProblemIFN: string; aReturn: TStrings): integer;
function EditSave(ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String; aReturn: TStrings): integer;
function InitPt(const PatientDFN: string; aReturn: TStrings): integer;  //*DFN*
function InitUser(ProviderID: int64; aReturn: TStrings): integer;
function PatientProviders(const PatientDFN: string; aReturn: TStrings): integer;  //*DFN*
function ProblemList(const PatientDFN: string; Status:string; ADate: TFMDateTime; aReturn: TStrings): integer;  //*DFN*
function ProblemLexiconSearch(aReturn: TStrings; SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): integer;
function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
function ProviderFilterList(ProvList: TStringList; aReturn: TStrings): integer;
function ProviderList(Flag: string; Number: integer; From: string; Part: string; aReturn: TStrings): integer;
function ProblemReplace(ProblemIFN: string; aReturn: TStrings): integer;
function ServiceFilterList(LocList: TStringList; aReturn: TStrings): integer;
function ServiceSearch(aReturn: TStrings; const StartFrom: string; Direction: Integer; All: boolean = FALSE): integer;
function ProblemUpdate(AltProbFile: TStringList; aReturn: TStrings): integer;
function UserProblemCategories(Provider: int64; Location: integer; aReturn: TStrings): integer;
function UserProblemList(CategoryIEN: string; aReturn: TStrings): integer;
function ProblemVerify(ProblemIFN: string; aReturn: TStrings): integer;
function GetProblemComments(ProblemIFN: string; aReturn: TStrings): integer;
procedure SaveViewPreferences(ViewPref: string);
function CheckForDuplicateProblem(TermIEN, TermText: string): string;

implementation

function AddSave(PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL ADD SAVE',[PatientInfo, ProviderID, ptVAMC, ProbFile, SearchString], aReturn);
  Result := aReturn.Count;
end ;

function AuditHistory(ProblemIFN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL AUDIT HIST', [ProblemIFN], aReturn);
  Result := aReturn.Count;
end ;

function ClinicFilterList(LocList: TStringList; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL CLIN FILTER LIST', [LocList], aReturn);
  MixedCaseList(aReturn);
  Result := aReturn.Count;
end;

function ClinicSearch(DummyArg: string; aReturn: TStrings): integer;
begin
   CallVistA('ORQQPL CLIN SRCH', [DummyArg], aReturn);
   Result := aReturn.Count;
end;

function ProblemDelete(ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL DELETE',[ProblemIFN, ProviderID, ptVAMC, Comment], aReturn);
  Result := aReturn.Count;
end;

function EditLoad(ProblemIFN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL EDIT LOAD', [ProblemIFN], aReturn);
  Result := aReturn.Count;
end;

function EditSave(ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL EDIT SAVE',[ProblemIFN, ProviderID, ptVAMC, PrimUser, ProbFile, SearchString], aReturn);
  Result := aReturn.Count;
end ;

function InitPt(const PatientDFN: string; aReturn: TStrings): integer;  //*DFN*
begin
  CallVistA('ORQQPL INIT PT', [PatientDFN], aReturn);
  Result := aReturn.Count;
end ;

function InitUser(ProviderID: int64; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL INIT USER', [ProviderID], aReturn);
  Result := aReturn.Count;
end ;

function PatientProviders(const PatientDFN: string; aReturn: TStrings): integer;  //*DFN*
begin
  CallVistA('ORQPT PATIENT TEAM PROVIDERS', [PatientDFN], aReturn);
  Result := aReturn.Count;
end ;

function ProblemLexiconSearch(aReturn: TStrings; SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): integer;
var
  View: String;
begin
  if Extend then
    View := 'CLF'
  else
    View := 'PLS';
  CallVistA('ORQQPL4 LEX', [SearchFor, VIEW, ADate, True], aReturn);
  Result := aReturn.Count;
end ;

function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
begin
  CallVistA('ORQQPL PROBLEM NTRT BULLETIN', [term, ProviderID, PatientID, comment], Result);
end ;

function ProblemList(const PatientDFN: string; Status:string; ADate: TFMDateTime; aReturn: TStrings): integer;  //*DFN*
begin
  CallVistA('ORQQPL PROBLEM LIST', [PatientDFN, Status, ADate], aReturn);
  Result := aReturn.Count;
end ;

function ProviderFilterList(ProvList: TStringList; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL PROV FILTER LIST', [ProvList], aReturn);
  Result := aReturn.Count;
end ;

function ProviderList(Flag: string; Number: integer; From: string; Part: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL PROVIDER LIST', [Flag,Number,From,Part], aReturn);
  Result := aReturn.Count;
end ;

function ProblemReplace(ProblemIFN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL REPLACE', [ProblemIFN], aReturn);
  Result := aReturn.Count;
end ;

function ServiceFilterList(LocList: TStringList; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL SERV FILTER LIST', [LocList], aReturn);
  MixedCaseList(aReturn);
  Result := aReturn.Count;
end ;

function ServiceSearch(aReturn: TStrings; const StartFrom: string; Direction: Integer; All: boolean = FALSE): integer;
begin
  CallVistA('ORQQPL SRVC SRCH',[StartFrom, Direction, BoolChar[All]], aReturn);
  MixedCaseList(aReturn);
  Result := aReturn.Count;
end ;

function ProblemUpdate(AltProbFile: TStringList; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL UPDATE', [AltProbFile], aReturn);
  Result := aReturn.Count;
end ;

function ProblemVerify(ProblemIFN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL VERIFY', [ProblemIFN], aReturn);
  Result := aReturn.Count;
end ;

function UserProblemCategories(Provider: int64; Location: integer; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL USER PROB CATS', [Provider, Location], aReturn);
  Result := aReturn.Count;
end ;

function UserProblemList(CategoryIEN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL USER PROB LIST', [CategoryIEN], aReturn);
  Result := aReturn.Count;
end ;

function GetProblemComments(ProblemIFN: string; aReturn: TStrings): integer;
begin
  CallVistA('ORQQPL PROB COMMENTS', [ProblemIFN], aReturn);
  Result := aReturn.Count;
end;

procedure SaveViewPreferences(ViewPref: string);
begin
  CallVistA('ORQQPL SAVEVIEW',[ViewPref]);
end;

function CheckForDuplicateProblem(TermIEN, TermText: string): string;
begin
  CallVistA('ORQQPL CHECK DUP',[Patient.DFN, TermIEN, TermText], Result);
end;

end.

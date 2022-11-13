unit rProbs;

interface

uses SysUtils, Classes, ORNet, ORFn, uCore;
(* 
function AddSave(PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
function AuditHistory(ProblemIFN: string): TStrings ;
function ClinicFilterList(LocList: TStringList): TStrings ;
function ClinicSearch(DummyArg:string): TStrings ;
function ProblemDelete(ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string): TStrings ;
{function ProblemDetail}
function EditLoad(ProblemIFN: string): TStrings ;
function EditSave(ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String): TStrings ;
function InitPt(const PatientDFN: string): TStrings ;  //*DFN*
function InitUser(ProviderID: int64): TStrings ;
function PatientProviders(const PatientDFN: string): TStrings ;  //*DFN*
function ProblemList(const PatientDFN: string; Status:string; ADate: TFMDateTime): TStrings ;  //*DFN*
function ProblemLexiconSearch(SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): TStrings ;
function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
function ProviderFilterList(ProvList: TStringList): TStrings ;
function ProviderList(Flag:string; Number:integer; From,Part: string): TStrings ;
function ProblemReplace(ProblemIFN: string): TStrings ;
function ServiceFilterList(LocList: TStringList): TStrings ;
function ServiceSearch(const StartFrom: string; Direction: Integer; All: boolean = FALSE): TStrings;
function ProblemUpdate(AltProbFile: TStringList): TStrings ;
function UserProblemCategories(Provider: int64; Location: integer): TStrings ;
function UserProblemList(CategoryIEN: string): TStrings ;
function ProblemVerify(ProblemIFN: string): TStrings ;
function GetProblemComments(ProblemIFN: string): TStrings;
procedure SaveViewPreferences(ViewPref: string);
function CheckForDuplicateProblem(TermIEN, TermText: string): string;
*)
function AddSave(Dest:TStrings;PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String): Integer;
function AuditHistory(Dest:TStrings;ProblemIFN: string): Integer;
function ClinicFilterList(Dest:TStrings;LocList: TStringList): Integer;
function ClinicSearch(Dest:TStrings;DummyArg:string): Integer;
function ProblemDelete(Dest:TStrings;ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string): Integer;
{function ProblemDetail}
function EditLoad(Dest:TStrings;ProblemIFN: string): Integer;
function EditSave(Dest:TStrings;ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String): Integer;
function InitPt(Dest:TStrings;const PatientDFN: string): Integer;  //*DFN*
function InitUser(Dest:TStrings;ProviderID: int64): Integer;
function PatientProviders(Dest:TStrings;const PatientDFN: string): Integer;  //*DFN*
function ProblemList(Dest:TStrings;const PatientDFN: string; Status:string; ADate: TFMDateTime): Integer;  //*DFN*
function ProblemLexiconSearch(Dest:TStrings;SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): Integer;
function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
function ProviderFilterList(Dest:TStrings;ProvList: TStringList): Integer;
function ProviderList(Dest:TStrings;Flag:string; Number:integer; From,Part: string): Integer;
function ProblemReplace(Dest:TStrings;ProblemIFN: string): Integer;
function ServiceFilterList(Dest:TStrings;LocList: TStringList): Integer;
function ServiceSearch(Dest:TStrings;const StartFrom: string; Direction: Integer; All: boolean = FALSE): Integer;
function ProblemUpdate(Dest:TStrings;AltProbFile: TStringList): Integer;
function UserProblemCategories(Dest:TStrings;Provider: int64; Location: integer): Integer;
function UserProblemList(Dest:TStrings;CategoryIEN: string): Integer;
function ProblemVerify(Dest:TStrings;ProblemIFN: string): Integer;
function GetProblemComments(Dest:TStrings;ProblemIFN: string): Integer;
procedure SaveViewPreferences(ViewPref: string);
function CheckForDuplicateProblem(TermIEN, TermText: string): string;

implementation

function AddSave(Dest:TStrings;PatientInfo: string; ProviderID: int64; ptVAMC: string;
           ProbFile: TStringList; SearchString: String): Integer;
begin
   CallVistA('ORQQPL ADD SAVE',[PatientInfo, ProviderID, ptVAMC, ProbFile, SearchString],Dest);
   Result := Dest.Count;
end ;

function AuditHistory(Dest:TStrings;ProblemIFN: string): Integer;
begin
   CallVistA('ORQQPL AUDIT HIST',[ProblemIFN],Dest);
   Result := Dest.Count;
end ;

function ClinicFilterList(Dest:TStrings;LocList: TStringList): Integer;
begin
   CallVistA('ORQQPL CLIN FILTER LIST',[LocList],Dest);
   MixedCaseList(Dest) ;
   Result := Dest.Count;
end ;

function ClinicSearch(Dest:TStrings;DummyArg:string): Integer;
begin
   CallVistA('ORQQPL CLIN SRCH',[DummyArg],Dest);
   Result := Dest.Count;
end ;

function ProblemDelete(Dest:TStrings;ProblemIFN: string; ProviderID: int64; ptVAMC, Comment: string): Integer;
begin
   CallVistA('ORQQPL DELETE',[ProblemIFN, ProviderID, ptVAMC, Comment],Dest);
   Result := Dest.Count;
end ;

function EditLoad(Dest:TStrings;ProblemIFN: string): Integer;
begin
   CallVistA('ORQQPL EDIT LOAD',[ProblemIFN],Dest);
   Result := Dest.Count;
end ;

function EditSave(Dest:TStrings;ProblemIFN: string; ProviderID: int64; ptVAMC, PrimUser: string;
           ProbFile: TStringList; SearchString: String): Integer;
begin
   CallVistA('ORQQPL EDIT SAVE',[ProblemIFN, ProviderID, ptVAMC, PrimUser, ProbFile, SearchString],Dest);
   Result := Dest.Count;
end ;

function InitPt(Dest:TStrings;const PatientDFN: string): Integer;  //*DFN*begin
begin
   CallVistA('ORQQPL INIT PT',[PatientDFN],Dest);
   Result := Dest.Count;
end ;

function InitUser(Dest:TStrings;ProviderID: int64): Integer;
begin
   CallVistA('ORQQPL INIT USER',[ProviderID],Dest);
   Result := Dest.Count;
end ;

function PatientProviders(Dest:TStrings;const PatientDFN: string): Integer;  //*DFN*
begin
   CallVistA('ORQPT PATIENT TEAM PROVIDERS',[PatientDFN],Dest);
   Result := Dest.Count;
end ;

function ProblemLexiconSearch(Dest:TStrings;SearchFor: string; ADate: TFMDateTime = 0; Extend: Boolean = False): Integer;
var
  View: String;
begin
  if Extend then
    View := 'CLF'
  else
    View := 'PLS';
  CallVistA('ORQQPL4 LEX',[SearchFor, VIEW, ADate, True],Dest);
  Result := Dest.Count ;
end ;

function ProblemNTRTBulletin(term: String; ProviderID: String; PatientID: String; comment: String): String;
begin
  CallVistA('ORQQPL PROBLEM NTRT BULLETIN', [term, ProviderID, PatientID, comment],Result);
end ;

function ProblemList(Dest:TStrings;const PatientDFN: string; Status:string; ADate: TFMDateTime): Integer;  //*DFN*
begin
   CallVistA('ORQQPL PROBLEM LIST',[PatientDFN, Status, ADate],Dest);
  result := Dest.Count;
end ;

function ProviderFilterList(Dest:TStrings;ProvList: TStringList): Integer;
begin
   CallVistA('ORQQPL PROV FILTER LIST',[ProvList],Dest);
  result := Dest.Count;
end ;

function ProviderList(Dest:TStrings;Flag:string; Number:integer; From,Part: string): Integer;
begin
   CallVistA('ORQQPL PROVIDER LIST',[Flag,Number,From,Part],Dest);
  result := Dest.Count;
end ;

function ProblemReplace(Dest:TStrings;ProblemIFN: string): Integer;
begin
   CallVistA('ORQQPL REPLACE',[ProblemIFN],Dest);
  result := Dest.Count;
end ;

function ServiceFilterList(Dest:TStrings;LocList: TStringList): Integer;
begin
   CallVistA('ORQQPL SERV FILTER LIST',[LocList],Dest);
   MixedCaseList(Dest) ;
  result := Dest.Count;
end ;

function ServiceSearch(Dest:TStrings;const StartFrom: string; Direction: Integer; All: boolean = FALSE): Integer;
begin
   CallVistA('ORQQPL SRVC SRCH',[StartFrom, Direction, BoolChar[All]],Dest);
   MixedCaseList(Dest) ;
  result := Dest.Count;
end ;

function ProblemUpdate(Dest:TStrings;AltProbFile: TStringList): Integer;
begin
   CallVistA('ORQQPL UPDATE',[AltProbFile],Dest);
  result := Dest.Count;
end ;

function ProblemVerify(Dest:TStrings;ProblemIFN: string): Integer;
begin
   CallVistA('ORQQPL VERIFY',[ProblemIFN],Dest);
  result := Dest.Count;
end ;

function UserProblemCategories(Dest:TStrings;Provider: int64; Location: integer): Integer;
begin
   CallVistA('ORQQPL USER PROB CATS',[Provider, Location],Dest);
  result := Dest.Count;
end ;

function UserProblemList(Dest:TStrings;CategoryIEN: string): Integer;
begin
   CallVistA('ORQQPL USER PROB LIST',[CategoryIEN],Dest);
  result := Dest.Count;
end ;

function GetProblemComments(Dest:TStrings;ProblemIFN: string): Integer;
begin
   CallVistA('ORQQPL PROB COMMENTS',[ProblemIFN],Dest);
  result := Dest.Count;
end;

procedure SaveViewPreferences(ViewPref: string);
begin
  CallVistA('ORQQPL SAVEVIEW',[ViewPref]);
end;

function CheckForDuplicateProblem(TermIEN, TermText: string): string;
begin
  CallVistA('ORQQPL CHECK DUP',[Patient.DFN, TermIEN, TermText],Result);
end;

end.

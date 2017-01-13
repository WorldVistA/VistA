unit rConsults;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs, uConsults, rTIU, uTIU;

type

  TUnresolvedConsults = record
    UnresolvedConsultsExist: boolean;
    ShowNagScreen: boolean;
  end;

{Consult Titles }
function  DfltConsultTitle: integer;
function  DfltConsultTitleName: string;
function  DfltClinProcTitle: integer;
function  DfltClinProcTitleName: string;
function  IdentifyConsultsClass: integer;
function  IdentifyClinProcClass: integer;
procedure ListConsultTitlesShort(Dest: TStrings);
procedure ListClinProcTitlesShort(Dest: TStrings);
function SubSetOfConsultTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;
function SubSetOfClinProcTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;
procedure ResetConsultTitles;
procedure ResetClinProcTitles;

{ Data Retrieval }
procedure GetConsultsList(Dest: TStrings; Early, Late: double;
  Service, Status: string; SortAscending: Boolean);
procedure LoadConsultDetail(Dest: TStrings; IEN: integer) ;
function  GetCurrentContext: TSelectContext;
procedure SaveCurrentContext(AContext: TSelectContext) ;
procedure DisplayResults(Dest: TStrings; IEN: integer) ;
procedure GetConsultRec(IEN: integer) ;
function  ShowSF513(ConsultIEN: integer): TStrings ;
procedure PrintSF513ToDevice(AConsult: Integer; const ADevice: string; ChartCopy: string;
  var ErrMsg: string);
function GetFormattedSF513(AConsult: Integer; ChartCopy: string): TStrings;
function UnresolvedConsultsExist: boolean;
procedure GetUnresolvedConsultsInfo;

{list box fillers}
function  SubSetOfStatus: TStrings;
function  SubSetOfUrgencies(ConsultIEN: integer): TStrings;
function  LoadServiceList(Purpose: integer): TStrings ; overload ;
function  LoadServiceList(ShowSynonyms: Boolean; StartService, Purpose: integer; ConsultIEN: integer = -1): TStrings ; overload;
function  LoadServiceListWithSynonyms(Purpose: integer): TStrings ; overload;
function  LoadServiceListWithSynonyms(Purpose, ConsultIEN: integer): TStrings ; overload;
function  SubSetOfServices(const StartFrom: string; Direction: Integer): TStrings;
function  FindConsult(ConsultIEN: integer): string ;

{user access level functions}
function  ConsultServiceUser(ServiceIEN: integer; DUZ: int64): boolean ;
function GetActionMenuLevel(ConsultIEN: integer): TMenuAccessRec ;

{consult result functions}
function  GetAssignableMedResults(ConsultIEN: integer): TStrings;
function  GetRemovableMedResults(ConsultIEN: integer): TStrings;
function  GetDetailedMedicineResults(ResultID: string): TStrings;
procedure AttachMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64; AlertTo: string);
procedure RemoveMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64);

{Consult Request Actions}
procedure ReceiveConsult(Dest: TStrings; IEN: integer; ReceivedBy: int64; RcptDate: TFMDateTime; Comments: TStrings);
procedure ScheduleConsult(Dest: TStrings; IEN: integer; ScheduledBy: Int64; SchdDate: TFMDateTime; Alert: integer;
     AlertTo: string; Comments: TStrings);
procedure DiscontinueConsult(Dest: TStrings; IEN: integer; DiscontinuedBy: int64;
     DiscontinueDate: TFMDateTime; Comments: TStrings);
procedure DenyConsult(Dest: TStrings; IEN: integer; DeniedBy: int64;
     DenialDate: TFMDateTime; Comments: TStrings);
procedure ForwardConsult(Dest: TStrings; IEN, ToService: integer; Forwarder, AttentionOf: int64;
     Urgency: integer; ActionDate: TFMDateTime; Comments: TStrings);
procedure AddComment(Dest: TStrings; IEN: integer; Comments: TStrings; ActionDate: TFMDateTime; Alert: integer;
     AlertTo: string) ;
procedure SigFindings(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings;  ActionDate: TFMDateTime;Alert: integer;
     AlertTo: string) ;
procedure AdminComplete(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings;
          RespProv: Int64; ActionDate: TFMDateTime; Alert: integer; AlertTo: string) ;

     { Consults Ordering Calls }
function ODForConsults: TStrings;
function ODForProcedures: TStrings;
function ConsultMessage(AnIEN: Integer): string;
function LoadConsultsQuickList: TStrings ;
function GetProcedureServices(ProcIEN: integer): TStrings;
function ConsultCanBeResubmitted(ConsultIEN: integer): string;
function LoadConsultForEdit(ConsultIEN: integer): TEditResubmitRec;
function ResubmitConsult(EditResubmitRec: TEditResubmitRec): string;
function SubSetOfProcedures(const StartFrom: string; Direction: Integer): TStrings;
function GetDefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
function ReasonForRequestEditable(Service: string): string;
function GetNewDialog(OrderType: string): string;
function GetServiceIEN(ORIEN: string): string;
function GetProcedureIEN(ORIEN: string): string;
function GetConsultOrderIEN(ConsultIEN: integer): string;
function GetServicePrerequisites(Service: string): TStrings;
procedure GetProvDxMode(var ProvDx: TProvisionalDiagnosis; SvcIEN: string);
function IsProstheticsService(SvcIen: int64) : string;
function GetServiceUserLevel(ServiceIEN, UserDUZ: integer): String ;

{ Clinical Procedures Specific}
function GetSavedCPFields(NoteIEN: integer): TEditNoteRec;

var
  uConsultsClass: integer;
  uConsultTitles: TConsultTitles;
  uClinProcClass: integer;
  uClinProcTitles: TClinProcTitles;
  uUnresolvedConsults: TUnresolvedConsults;

implementation

uses  rODBase;

var
  uLastOrderedIEN: Integer;
  uLastOrderMsg: string;

{ -------------------------- Consult Titles --------------------------------- }

function IdentifyConsultsClass: integer;
begin
  if uConsultsClass = 0 then
    uConsultsClass := StrToIntDef(sCallV('TIU IDENTIFY CONSULTS CLASS',[nil]), 0)  ;
  Result := uConsultsClass;
end;

procedure LoadConsultTitles;
{ private - called one time to set up the uConsultTitles object }
var
  x: string;
begin
  if uConsultTitles <> nil then Exit;
  CallV('TIU PERSONAL TITLE LIST', [User.DUZ, IdentifyConsultsClass]);
  RPCBrokerV.Results.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
  uConsultTitles := TConsultTitles.Create;
  ExtractItems(uConsultTitles.ShortList, RPCBrokerV.Results, 'SHORT LIST');
  x := ExtractDefault(RPCBrokerV.Results, 'SHORT LIST');
  uConsultTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
  uConsultTitles.DfltTitleName := Piece(x, U, 2);
end;

procedure ResetConsultTitles;
begin
  if uConsultTitles <> nil then
    begin
      uConsultTitles.Free;
      uConsultTitles := nil;
      LoadConsultTitles;
    end;
end;

function DfltConsultTitle: integer;
{ returns the user defined default Consult title (if any) }
begin
  if uConsultTitles = nil then LoadConsultTitles;
  Result := uConsultTitles.DfltTitle;
end;

function DfltConsultTitleName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uConsultTitles = nil then LoadConsultTitles;
  Result := uConsultTitles.DfltTitleName;
end;

procedure ListConsultTitlesShort(Dest: TStrings);
{ returns the user defined list (short list) of Consult titles }
begin
  if uConsultTitles = nil then LoadConsultTitles;
  Dest.AddStrings(uConsultTitles.ShortList);
  if uConsultTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

function SubSetOfConsultTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;
{ returns a pointer to a list of consults progress note titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
(*  if IDNoteTitlesOnly then        //  This RPC not changed for initial ID Notes release
    CallV('TIU LONG LIST CONSULT TITLES', [StartFrom, Direction, IDNoteTitlesOnly])
  else*)
    CallV('TIU LONG LIST CONSULT TITLES', [StartFrom, Direction]);
  //MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;


{ -------------------------- Clinical Procedures Titles --------------------------------- }
function IdentifyClinProcClass: integer;
begin
  if uClinProcClass = 0 then
    uClinProcClass := StrToIntDef(sCallV('TIU IDENTIFY CLINPROC CLASS',[nil]), 0)  ;
  Result := uClinProcClass;
end;

procedure LoadClinProcTitles;
{ private - called one time to set up the uConsultTitles object }
var
  x: string;
begin
  if uClinProcTitles <> nil then Exit;
  CallV('TIU PERSONAL TITLE LIST', [User.DUZ, IdentifyClinProcClass]);
  RPCBrokerV.Results.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
  uClinProcTitles := TClinProcTitles.Create;
  ExtractItems(uClinProcTitles.ShortList, RPCBrokerV.Results, 'SHORT LIST');
  x := ExtractDefault(RPCBrokerV.Results, 'SHORT LIST');
  uClinProcTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
  uClinProcTitles.DfltTitleName := Piece(x, U, 2);
end;

procedure ResetClinProcTitles;
begin
  if uClinProcTitles <> nil then
    begin
      uClinProcTitles.Free;
      uClinProcTitles := nil;
      LoadClinProcTitles;
    end;
end;

function DfltClinProcTitle: integer;
{ returns the user defined default ClinProc title (if any) }
begin
  if uClinProcTitles = nil then LoadClinProcTitles;
  Result := uClinProcTitles.DfltTitle;
end;

function DfltClinProcTitleName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uClinProcTitles = nil then LoadClinProcTitles;
  Result := uClinProcTitles.DfltTitleName;
end;

procedure ListClinProcTitlesShort(Dest: TStrings);
{ returns the user defined list (short list) of ClinProc titles }
begin
  if uClinProcTitles = nil then LoadClinProcTitles;
  Dest.AddStrings(uClinProcTitles.ShortList);
  if uClinProcTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

function SubSetOfClinProcTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;
{ returns a pointer to a list of clinical procedures titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
(*  if IDNoteTitlesOnly then        //  This RPC not changed for initial ID Notes release
    CallV('TIU LONG LIST CLINPROC TITLES', [StartFrom, Direction, IDNoteTitlesOnly])
  else*)
    CallV('TIU LONG LIST CLINPROC TITLES', [StartFrom, Direction]);
  //MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

{--------------- data retrieval ------------------------------------------}

procedure GetConsultsList(Dest: TStrings; Early, Late: double;
  Service, Status: string; SortAscending: Boolean);
{ returns a list of consults for a patient, based on selected dates, service, status, or ALL}
var
  i: Integer;
  x, date1, date2: string;
begin
  if Early <= 0 then date1 := '' else date1 := FloatToStr(Early) ;
  if Late  <= 0 then date2 := '' else date2 := FloatToStr(Late)  ;
  CallV('ORQQCN LIST', [Patient.DFN, date1, date2, Service, Status]);
  with RPCBrokerV do
   begin
    if Copy(Results[0],1,1) <> '<' then
      begin
       SortByPiece(TStringList(Results), U, 2);
       if not SortAscending then InvertStringList(TStringList(Results));
       //SetListFMDateTime('mmm dd,yy', TStringList(Results), U, 2);
       for i := 0 to Results.Count - 1 do
         begin
           x := MakeConsultListItem(Results[i]);
           Results[i] := x;
         end;
       FastAssign(Results, Dest);
     end
    else
     begin
       Dest.Clear ;
       Dest.Add('-1^No Matches') ;
     end ;
  end;
end;

procedure LoadConsultDetail(Dest: TStrings; IEN: integer) ;
{ returns the detail of a consult }
begin
  CallV('ORQQCN DETAIL', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure DisplayResults(Dest: TStrings; IEN: integer) ;
{ returns the results for a consult }
begin
  CallV('ORQQCN MED RESULTS', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure GetConsultRec(IEN: integer);
{returns zero node from file 123, plus a list of all related TIU documents, if any}
const
  SHOW_ADDENDA = True;
var
   alist: TStrings;
   x: string ;
   i: integer;
{           1    2    3     4     5     6    7    8   9    10   11  12   13     14    15
{ Pieces: EntDt^Pat^OrIFN^PtLoc^ToSvc^From^ReqDt^Typ^Urg^Place^Attn^Sts^LstAct^SndPrv^Rslt^
    16      17     18    19     20     21      22
 ^EntMode^ReqTyp^InOut^SigFnd^TIUPtr^OrdFac^FrgnCslt}
begin
  FillChar(ConsultRec, SizeOf(ConsultRec), 0);
  CallV('ORQQCN GET CONSULT', [IEN, SHOW_ADDENDA]);
  ConsultRec.IEN := IEN ;
  alist := TStringList.Create ;
 try
  FastAssign(RPCBrokerV.Results, aList);
  x := alist[0] ;
  if Piece(x,u,1) <> '-1' then
    with ConsultRec do
     begin
      EntryDate             := MakeFMDateTime(Piece(x, U, 1));
      ORFileNumber          := StrToIntDef(Piece(x, U, 3),0);
      PatientLocation       := StrToIntDef(Piece(x, U, 4),0);
      OrderingFacility      := StrToIntDef(Piece(x, U, 21),0);
      ForeignConsultFileNum := StrToIntDef(Piece(x, U, 22),0);
      ToService             := StrToIntDef(Piece(x, U, 5),0);
      From                  := StrToIntDef(Piece(x, U, 6),0);
      RequestDate           := MakeFMDateTime(Piece(x, U, 7));
      ConsultProcedure      := Piece(x, U, 8)  ;
      Urgency               := StrToIntDef(Piece(x, U, 9),0);
      PlaceOfConsult        := StrToIntDef(Piece(x, U, 10),0);
      Attention             := StrToInt64Def(Piece(x, U, 11),0);
      ORStatus              := StrToIntDef(Piece(x, U, 12),0);
      LastAction            := StrToIntDef(Piece(x, U, 13),0);
      SendingProvider       := StrToInt64Def(Piece(Piece(x, U, 14),';',1),0);
      SendingProviderName   := Piece(Piece(x, U, 14),';',2)   ;
      Result                := Piece(x, U, 15)  ;
      ModeOfEntry           := Piece(x, U, 16)  ;
      RequestType           := StrToIntDef(Piece(x, U, 17),0);
      InOut                 := Piece(x, U, 18)  ;
      Findings              := Piece(x, U, 19)  ;
      TIUResultNarrative    := StrToIntDef(Piece(x, U, 20),0);
      ClinicallyIndicatedDate          := StrToFloatDef(Piece(x, U, 98), 0);
      //ProvDiagnosis         := Piece(x, U, 23);  NO!!!!! Up to 180 Characters!!!!
      alist.delete(0) ;
      TIUDocuments := TStringList.Create ;
      MedResults := TStringList.Create;
      if alist.count > 0 then
        begin
          SortByPiece(TStringList(alist), U, 3);
          for i := 0 to alist.Count - 1 do
            if Copy(Piece(Piece(alist[i], U, 1), ';', 2), 1, 4) = 'MCAR' then
              MedResults.Add(alist[i])
            else
              TIUDocuments.Add(alist[i]);
        end;
     end  {ConsultRec}
  else
   ConsultRec.EntryDate := -1 ;
 finally
   alist.free ;
 end ;
end ;

{---------------- list box fillers -----------------------------------}

function SubSetOfStatus: TStrings;
{ returns a pointer to a list of stati (for use in a list box) }
begin
  CallV('ORQQCN STATUS', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function SubSetOfUrgencies(ConsultIEN: integer): TStrings;
{ returns a pointer to a list of urgencies  }
begin
  CallV('ORQQCN URGENCIES',[ConsultIEN]) ;
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function FindConsult(ConsultIEN: integer): string ;
var
  x: string;
begin
  x := sCallV('ORQQCN FIND CONSULT',[ConsultIEN]);
  Result := MakeConsultListItem(x);
end;

{-----------------consult result functions-----------------------------------}
function GetAssignableMedResults(ConsultIEN: integer): TStrings;
begin
  CallV('ORQQCN ASSIGNABLE MED RESULTS', [ConsultIEN]);
  Result := RPCBrokerV.Results;
end;

function GetRemovableMedResults(ConsultIEN: integer): TStrings;
begin
  CallV('ORQQCN REMOVABLE MED RESULTS', [ConsultIEN]);
  Result := RPCBrokerV.Results;
end;

function GetDetailedMedicineResults(ResultID: string): TStrings;
begin
  CallV('ORQQCN GET MED RESULT DETAILS', [ResultID]);
  Result := RPCBrokerV.Results;
end;

procedure AttachMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64; AlertTo: string);
begin
  CallV('ORQQCN ATTACH MED RESULTS', [ConsultIEN, ResultID, DateTime, ResponsiblePerson, AlertTo]);
end;

procedure RemoveMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64);
begin
  CallV('ORQQCN REMOVE MED RESULTS', [ConsultIEN, ResultID, DateTime, ResponsiblePerson]);
end;
{-------------- user access level functions ---------------------------------}

function ConsultServiceUser(ServiceIEN: integer; DUZ: int64): boolean ;
var
  i: integer ;
begin
  Result := False ;
  CallV('ORWU GENERIC', ['',1,'^GMR(123.5,'+IntToStr(ServiceIEN)+',123.3,"B")']) ;
  for i:=0 to RPCBrokerV.Results.Count-1 do
      if StrToInt64(Piece(RPCBrokerV.Results[i],u,2))=DUZ then result := True  ;
end ;

function GetActionMenuLevel(ConsultIEN: integer): TMenuAccessRec ;
var
  x: string;
begin
  x := sCallV('ORQQCN SET ACT MENUS', [ConsultIEN]) ;
  Result.UserLevel := StrToIntDef(Piece(x, U, 1), 1);
  Result.AllowMedResulting := (Piece(x, U, 4) = '1');
  Result.AllowMedDissociate := (Piece(x, U, 5) = '1');
  Result.AllowResubmit := (Piece(x, U, 6) = '1') and (Piece(ConsultCanBeResubmitted(ConsultIEN), U, 1) <> '0');
  Result.ClinProcFlag := StrToIntDef(Piece(x, U, 7), CP_NOT_CLINPROC);
  Result.IsClinicalProcedure := (Result.ClinProcFlag > CP_NOT_CLINPROC);
end ;

{------------------- Consult request actions -------------------------------}

procedure ReceiveConsult(Dest: TStrings; IEN: integer; ReceivedBy: int64; RcptDate: TFMDateTime; Comments: TStrings);
begin
  CallV('ORQQCN RECEIVE', [IEN, ReceivedBy, RcptDate, Comments]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end;

procedure ScheduleConsult(Dest: TStrings; IEN: integer; ScheduledBy: Int64; SchdDate: TFMDateTime; Alert: integer;
     AlertTo: string; Comments: TStrings);
begin
  CallV('ORQQCN2 SCHEDULE CONSULT', [IEN, ScheduledBy, SchdDate, Alert, AlertTo, Comments]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end;

procedure DenyConsult(Dest: TStrings; IEN: integer; DeniedBy: int64;
            DenialDate: TFMDateTime; Comments: TStrings);
begin
  CallV('ORQQCN DISCONTINUE', [IEN, DeniedBy, DenialDate,'DY',Comments]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end;

procedure DiscontinueConsult(Dest: TStrings; IEN: integer; DiscontinuedBy: int64;
            DiscontinueDate: TFMDateTime; Comments: TStrings);
begin
  CallV('ORQQCN DISCONTINUE', [IEN, DiscontinuedBy, DiscontinueDate,'DC',Comments]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end;

procedure ForwardConsult(Dest: TStrings; IEN, ToService: integer; Forwarder, AttentionOf: int64; Urgency: integer;
     ActionDate: TFMDateTime; Comments: TStrings);
begin
  CallV('ORQQCN FORWARD', [IEN, ToService, Forwarder, AttentionOf, Urgency, ActionDate, Comments]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end ;

procedure AddComment(Dest: TStrings; IEN: integer; Comments: TStrings; ActionDate: TFMDateTime; Alert: integer;
AlertTo: string) ;
begin
  CallV('ORQQCN ADDCMT', [IEN, Comments, Alert, AlertTo, ActionDate]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end ;

procedure AdminComplete(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings;
          RespProv: Int64; ActionDate: TFMDateTime; Alert: integer; AlertTo: string) ;
begin
  CallV('ORQQCN ADMIN COMPLETE', [IEN, SigFindingsFlag, Comments, RespProv, Alert, AlertTo, ActionDate]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end ;

procedure SigFindings(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings; ActionDate: TFMDateTime; Alert: integer;
AlertTo: string) ;
begin
  CallV('ORQQCN SIGFIND', [IEN, SigFindingsFlag, Comments, Alert, AlertTo, ActionDate]);
  FastAssign(RPCBrokerV.Results, Dest);   {1^Error message' or '0'}
end ;

//==================  Ordering functions   ===================================
function ODForConsults: TStrings;
{ Returns init values for consults dialog.  The results must be used immediately. }
begin
  CallV('ORWDCN32 DEF', ['C']);
  Result := RPCBrokerV.Results;
end;

function ODForProcedures: TStrings;
{ Returns init values for procedures dialog.  The results must be used immediately. }
begin
  CallV('ORWDCN32 DEF', ['P']);
  Result := RPCBrokerV.Results;
end;

function SubSetOfProcedures(const StartFrom: string; Direction: Integer): TStrings;
begin
begin
  CallV('ORWDCN32 PROCEDURES', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;
end;

function LoadServiceList(Purpose: integer): TStrings ;
// Purpose:  0=display all services, 1=forward or order from possible services
begin
  Callv('ORQQCN SVCTREE',[Purpose]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end ;

function LoadServiceList(ShowSynonyms: Boolean; StartService, Purpose: Integer; ConsultIEN: integer = -1): TStrings ;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
// Param 4 = Consult IEN
begin
  if ConsultIEN > -1 then
   Callv('ORQQCN SVC W/SYNONYMS',[StartService, Purpose, ShowSynonyms, ConsultIEN])
  else
   Callv('ORQQCN SVC W/SYNONYMS',[StartService, Purpose, ShowSynonyms]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end ;

function LoadServiceListWithSynonyms(Purpose: integer): TStrings ;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
begin
  Callv('ORQQCN SVC W/SYNONYMS',[1, Purpose, True]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end ;

function LoadServiceListWithSynonyms(Purpose, ConsultIEN: integer): TStrings ;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
// Param 4 = Consult IEN
begin
  Callv('ORQQCN SVC W/SYNONYMS',[1, Purpose, True, ConsultIEN]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end ;

function SubSetOfServices(const StartFrom: string; Direction: Integer): TStrings;
//  used only on consults order dialog for service long combo box, which needs to include quick orders
begin
  CallV('ORQQCN SVCLIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function LoadConsultsQuickList: TStrings ;
begin
  Callv('ORWDXQ GETQLST',['CSLT', 'Q']) ;
  Result := RPCBrokerV.Results;
end ;

function ShowSF513(ConsultIEN: integer): TStrings ;
var
  x: string;
  i: integer;
begin
  CallV('ORQQCN SHOW SF513',[ConsultIEN]) ;
  if RPCBrokerV.Results.Count > 0 then
    begin
      x := RPCBrokerV.Results[0];
      i := Pos('-', x);
      x := Copy(x, i, 999);
      RPCBrokerV.Results[0] := x;
    end;
  Result := RPCBrokerV.Results;
end ;

procedure PrintSF513ToDevice(AConsult: Integer; const ADevice: string; ChartCopy: string;
  var ErrMsg: string);
{ prints a SF 513 on the selected device }
begin
  ErrMsg := sCallV('ORQQCN PRINT SF513', [AConsult, ChartCopy, ADevice]);
//  if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

function GetFormattedSF513(AConsult: Integer; ChartCopy: string): TStrings;
begin
  CallV('ORQQCN SF513 WINDOWS PRINT',[AConsult, ChartCopy]);
  Result := RPCBrokerV.Results;
end;

function UnresolvedConsultsExist: boolean;
begin
  Result := (sCallV('ORQQCN UNRESOLVED', [Patient.DFN]) = '1');
end;

procedure GetUnresolvedConsultsInfo;
var
  x: string;
begin
  x := sCallV('ORQQCN UNRESOLVED', [Patient.DFN]);
  with uUnresolvedConsults do
  begin
    UnresolvedConsultsExist := (Piece(x, U, 1) = '1');
    ShowNagScreen := (Piece(x, U, 2) = '1');
  end;
end;

function ConsultMessage(AnIEN: Integer): string;
begin
  if AnIEN = uLastOrderedIEN then Result := uLastOrderMsg else
  begin
    Result := sCallV('ORWDCN32 ORDRMSG', [AnIEN]);
    uLastOrderedIEN := AnIEN;
    uLastOrderMsg := Result;
  end;
end;

function GetProcedureIEN(ORIEN: string): string;
begin
  Result := sCallV('ORQQCN GET PROC IEN', [ORIEN]);
end;

function GetProcedureServices(ProcIEN: integer): TStrings;
begin
  CallV('ORQQCN GET PROC SVCS',[ProcIEN]) ;
  Result := RPCBrokerV.Results;
end;

function ConsultCanBeResubmitted(ConsultIEN: integer): string;
begin
  Result := sCallV('ORQQCN CANEDIT', [ConsultIEN]);
end;

function LoadConsultForEdit(ConsultIEN: integer): TEditResubmitRec;
var
  Dest: TStringList;
  EditRec: TEditResubmitRec;
begin
  Dest := TStringList.Create;
  try
    tCallV(Dest, 'ORQQCN LOAD FOR EDIT',[ConsultIEN]) ;
    with EditRec do
      begin
         Changed         := False;
         IEN             := ConsultIEN;
         ToService       := StrToIntDef(Piece(ExtractDefault(Dest, 'SERVICE'), U, 2), 0);
         RequestType     := Piece(ExtractDefault(Dest, 'TYPE'), U, 3);
         OrderableItem   := StrToIntDef(Piece(ExtractDefault(Dest, 'PROCEDURE'), U, 1), 0);
         ConsultProc     := Piece(ExtractDefault(Dest, 'PROCEDURE'), U, 3);
         ConsultProcName := Piece(ExtractDefault(Dest, 'PROCEDURE'), U, 2);
         Urgency         := StrToIntDef(Piece(ExtractDefault(Dest, 'URGENCY'), U, 3), 0);
         UrgencyName     := Piece(ExtractDefault(Dest, 'URGENCY'), U, 2);
         ClinicallyIndicatedDate    := StrToFloatDef(Piece(ExtractDefault(Dest, 'CLINICALLY'), U, 2), 0);
         Place           := Piece(ExtractDefault(Dest, 'PLACE'), U, 1);
         PlaceName       := Piece(ExtractDefault(Dest, 'PLACE'), U, 2);
         Attention       := StrToInt64Def(Piece(ExtractDefault(Dest, 'ATTENTION'), U, 1), 0);
         AttnName        := Piece(ExtractDefault(Dest, 'ATTENTION'), U, 2);
         InpOutp         := Piece(ExtractDefault(Dest, 'CATEGORY'), U, 1);
         ProvDiagnosis      := Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 1);
         ProvDxCode         := Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 2);
         ProvDxCodeInactive := (Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 3) = '1');
         RequestReason   := TStringList.Create;
         ExtractText(RequestReason, Dest, 'REASON');
         LimitStringLength(RequestReason, 74);
         DenyComments    := TStringList.Create;
         ExtractText(DenyComments, Dest, 'DENY COMMENT');
         OtherComments   := TStringList.Create;
         ExtractText(OtherComments, Dest, 'ADDED COMMENT');
         NewComments     := TStringList.Create;
      end;
    Result := EditRec;
  finally
    Dest.Free;
  end;
end;

function ResubmitConsult(EditResubmitRec: TEditResubmitRec): string;
var
  i: integer;
begin
  with RPCBrokerV, EditResubmitRec do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORQQCN RESUBMIT';
      Param[0].PType := literal;
      Param[0].Value := IntToStr(IEN);
      Param[1].PType := list;
      with Param[1] do
        begin
          if ToService > 0 then
            Mult['1']  := 'GMRCSS^'   + IntToStr(ToService);
          if ConsultProc <> '' then
            Mult['2']  := 'GMRCPROC^' + ConsultProc ;
          if Urgency > 0 then
            Mult['3']  := 'GMRCURG^'  + IntToStr(Urgency);
          if Length(Place) > 0 then
            Mult['4']  := 'GMRCPL^'   + Place;
          if Attention > 0 then
            Mult['5']  := 'GMRCATN^'  + IntToStr(Attention)
          else if Attention = -1 then
            Mult['5']  := 'GMRCATN^'  + '@';
          if RequestType <> '' then
            Mult['6']  := 'GMRCRQT^'  + RequestType;
          if Length(InpOutP) > 0 then
            Mult['7']  := 'GMRCION^'  + InpOutp;
          if Length(ProvDiagnosis) > 0 then
            Mult['8']  := 'GMRCDIAG^' + ProvDiagnosis + U + ProvDxCode;
          if RequestReason.Count > 0 then
            begin
              Mult['9']  := 'GMRCRFQ^20';
              for i := 0 to RequestReason.Count - 1 do
                Mult['9,' + IntToStr(i+1)]  := RequestReason.Strings[i];
            end;
          if NewComments.Count > 0 then
            begin
              Mult['10'] := 'COMMENT^';
              for i := 0 to NewComments.Count - 1 do
                Mult['10,' + IntToStr(i+1)] := NewComments.Strings[i];
            end;
          if ClinicallyIndicatedDate > 0 then
             Mult['11']  := 'GMRCERDT^'  + FloatToStr(ClinicallyIndicatedDate);  //wat renamed v28
        end;
      CallBroker;
      Result := '0';
      //Result := Results[0];
    end;
end;

function  GetCurrentContext: TSelectContext;
var
  x: string;
  AContext: TSelectContext;
begin
  x := sCallV('ORQQCN2 GET CONTEXT', [User.DUZ]) ;
  with AContext do
    begin
      Changed       := True;
      BeginDate     := Piece(x, ';', 1);
      EndDate       := Piece(x, ';', 2);
      Status        := Piece(x, ';', 3);
      Service       := Piece(x, ';', 4);
      GroupBy       := Piece(x, ';', 5);
      Ascending     := (Piece(x, ';', 6) = '1');
    end;
  Result := AContext;
end;

procedure SaveCurrentContext(AContext: TSelectContext) ;
var
  x: string;
begin
  with AContext do
    begin
      SetPiece(x, ';', 1, BeginDate);
      SetPiece(x, ';', 2, EndDate);
      SetPiece(x, ';', 3, Status);
      SetPiece(x, ';', 4, Service);
      SetPiece(x, ';', 5, GroupBy);
      SetPiece(x, ';', 6, BOOLCHAR[Ascending]);
    end;
  CallV('ORQQCN2 SAVE CONTEXT', [x]);
end;

function GetDefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
begin
  CallV('ORQQCN DEFAULT REQUEST REASON',[Service, Patient.DFN, Resolve]) ;
  Result := RPCBrokerV.Results;
end;

function ReasonForRequestEditable(Service: string): string;
begin
  Result := sCallV('ORQQCN EDIT DEFAULT REASON', [Service]);
end;

function GetServicePrerequisites(Service: string): TStrings;
begin
  CallV('ORQQCN2 GET PREREQUISITE',[Service, Patient.DFN]) ;
  Result := RPCBrokerV.Results;
end;

function GetNewDialog(OrderType: string): string;
{ get dialog for new consults}
begin
  Result := sCallV('ORWDCN32 NEWDLG', [OrderType, Encounter.Location]);
end;

function GetServiceIEN(ORIEN: string): string;
begin
  Result := sCallV('ORQQCN GET SERVICE IEN', [ORIEN]);
end;

procedure GetProvDxMode(var ProvDx: TProvisionalDiagnosis; SvcIEN: string);
var
  x: string;
begin
  x := sCallV('ORQQCN PROVDX', [SvcIEN]);
  ProvDx.Reqd := Piece(x, U, 1);
  ProvDx.PromptMode := Piece(x, U, 2);
end;

function GetConsultOrderIEN(ConsultIEN: integer): string;
begin
  Result := sCallV('ORQQCN GET ORDER NUMBER', [ConsultIEN]); 
end;

function GetSavedCPFields(NoteIEN: integer): TEditNoteRec;
var
  x: string;
  AnEditRec: TEditNoteRec;
begin
  x := sCallV('ORWTIU GET SAVED CP FIELDS', [NoteIEN]);
  with AnEditRec do
    begin
      Author := StrToInt64Def(Piece(x, U, 1), 0);
      Cosigner := StrToInt64Def(Piece(x, U, 2), 0);
      ClinProcSummCode := StrToIntDef(Piece(x, U, 3), 0);
      ClinProcDateTime := StrToFMDateTime(Piece(x, U, 4));
      Title := StrToIntDef(Piece(x, U, 5), 0);
      DateTime := StrToFloatDef(Piece(x, U, 6), 0);
    end;
  Result := AnEditRec;
end;

function IsProstheticsService(SvcIen : int64) : string;  //wat v28
 begin
   Result := sCallV('ORQQCN ISPROSVC', [SvcIen]);
 end;

function GetServiceUserLevel(ServiceIEN, UserDUZ: integer): String ;
// Param 1 = IEN of service
// Param 2 = Users DUZ (currently can be null)
begin
Result := sCallV('ORQQCN GET USER AUTH',[ServiceIEN]) ;
end;

initialization
  uLastOrderedIEN := 0;
  uLastOrderMsg := '';
  uConsultsClass := 0;
  uClinProcClass := 0;

finalization
  if uConsultTitles <> nil then uConsultTitles.Free;
  if uClinProcTitles <> nil then uClinProcTitles.Free;

end.

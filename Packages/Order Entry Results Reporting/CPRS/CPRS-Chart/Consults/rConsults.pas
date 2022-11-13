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
function SubSetOfConsultTitles(aResults: TStrings; const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): Integer;
function SubSetOfClinProcTitles(aResults: TStrings; const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): Integer;
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
function setSF513(aDest:TStrings;ConsultIEN: integer): Integer;
procedure PrintSF513ToDevice(AConsult: Integer; const ADevice: string; ChartCopy: string;
  var ErrMsg: string);

//function GetFormattedSF513(AConsult: Integer; ChartCopy: string): TStrings; deprecated;
function setFormattedSF513(aDest:TStrings;AConsult: Integer; ChartCopy: string): Integer;

function UnresolvedConsultsExist: boolean;
procedure GetUnresolvedConsultsInfo;

{list box fillers}
function  setSubSetOfStatus(aDest: TStrings):Integer;
function  setSubSetOfUrgencies(aDest:TStrings;ConsultIEN: integer): Integer;
//function  LoadServiceList(Purpose: integer): TStrings ; overload ;deprecated;
function setServiceList(aDest: Tstrings;Purpose: integer): Integer; overload;

//function  LoadServiceList(ShowSynonyms: Boolean; StartService, Purpose: integer; ConsultIEN: integer = -1): TStrings ; overload; deprecated;
function  setServiceList(aDest:TStrings; ShowSynonyms: Boolean; StartService, Purpose: integer; ConsultIEN: integer = -1): Integer; overload;

//function  LoadServiceListWithSynonyms(Purpose: integer): TStrings ; overload; deprecated;
function setServiceListWithSynonyms(aDest:TStrings; Purpose: integer): Integer; overload;

//function  LoadServiceListWithSynonyms(Purpose, ConsultIEN: integer): TStrings ; overload;deprecated;
function  setServiceListWithSynonyms(aDest:TStrings; Purpose, ConsultIEN: integer): Integer; overload;

{ Not used?
function  SubSetOfServices(const StartFrom: string; Direction: Integer): TStrings; deprecated;
function setSubSetOfServices(aDest: TStrings; const StartFrom: string; Direction: Integer): Integer;
}

function  FindConsult(ConsultIEN: integer): string ;

{user access level functions}
function  ConsultServiceUser(ServiceIEN: integer; DUZ: int64): boolean ;
function GetActionMenuLevel(ConsultIEN: integer): TMenuAccessRec ;

{consult result functions}
function  setAssignableMedResults(aDest:TStrings; ConsultIEN: integer): Integer;
function  setRemovableMedResults(aDest:TStrings; ConsultIEN: integer): Integer;
function  setDetailedMedicineResults(aDest:TStrings; ResultID: string): Integer;
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
//function ODForConsults: TStrings; deprecated;
function setODForConsults(aDest: TStrings): Integer;

//function ODForProcedures: TStrings; deprecated;
function setODForProcedures(aDest: TStrings): Integer;

function ConsultMessage(AnIEN: Integer): string;

{ Not used?
function LoadConsultsQuickList: TStrings ;
function setConsultsQuickList(aDest: TStrings): Integer ;
}
//function GetProcedureServices(ProcIEN: integer): TStrings; deprecated
function setProcedureServices(aDest:TStrings; ProcIEN: integer): Integer;

function ConsultCanBeResubmitted(ConsultIEN: integer): string;

function LoadConsultForEdit(ConsultIEN: integer): TEditResubmitRec;

function ResubmitConsult(EditResubmitRec: TEditResubmitRec): string;

//function SubSetOfProcedures(const StartFrom: string; Direction: Integer): TStrings; deprecated;
function setSubSetOfProcedures(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;

//function GetDefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings; deprecated;
function setDefaultReasonForRequest(aDest: TStrings;Service: string; Resolve: Boolean): Integer;

function ReasonForRequestEditable(Service: string): string;
function GetNewDialog(OrderType: string): string;
function GetServiceIEN(ORIEN: string): string;
function GetProcedureIEN(ORIEN: string): string;
function GetConsultOrderIEN(ConsultIEN: integer): string;

//function GetServicePrerequisites(Service: string): TStrings; deprecated;
function setServicePrerequisites(aDest: TStrings;Service: string): Integer;

procedure GetProvDxMode(var ProvDx: TProvisionalDiagnosis; SvcIEN: string);
function IsProstheticsService(SvcIen: int64) : Boolean;
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

uses  ORNetIntf, uMisc;

var
  uLastOrderedIEN: Integer;
  uLastOrderMsg: string;

{ -------------------------- Consult Titles --------------------------------- }

function IdentifyConsultsClass: integer;
begin
  if uConsultsClass = 0 then
    CallVistA('TIU IDENTIFY CONSULTS CLASS',[nil],uConsultsClass, 0);
  Result := uConsultsClass;
end;

procedure LoadConsultTitles;
{ private - called one time to set up the uConsultTitles object }
var
  x: string;
  Results: TStrings;
begin
  if uConsultTitles <> nil then
    Exit;
  // CallV('TIU PERSONAL TITLE LIST', [User.DUZ, IdentifyConsultsClass]);
  Results := TSTringList.Create;
  try
    CallVistA('TIU PERSONAL TITLE LIST',
      [User.DUZ, IdentifyConsultsClass], Results);
    {RPCBrokerV.} Results.Insert(0, '~SHORT LIST');
    // insert so can call ExtractItems
    uConsultTitles := TConsultTitles.Create;
    ExtractItems(uConsultTitles.ShortList, {RPCBrokerV. } Results,
      'SHORT LIST');
    x := ExtractDefault({RPCBrokerV.} Results, 'SHORT LIST');
    uConsultTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
    uConsultTitles.DfltTitleName := Piece(x, U, 2);
  finally
    Results.Free;
  end;
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

function SubSetOfConsultTitles(aResults: TStrings; const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): Integer;
{ returns a pointer to a list of consults progress note titles (for use in a long list box)}
begin
  CallVistA('TIU LONG LIST CONSULT TITLES', [StartFrom, Direction], aResults);
  Result := aResults.Count;
end;


{ -------------------------- Clinical Procedures Titles --------------------------------- }
function IdentifyClinProcClass: integer;
begin
  if uClinProcClass = 0 then
//    uClinProcClass := StrToIntDef(sCallV('TIU IDENTIFY CLINPROC CLASS',[nil]), 0)  ;
    CallVistA('TIU IDENTIFY CLINPROC CLASS',[nil], uClinProcClass, 0)  ;
  Result := uClinProcClass;
end;

procedure LoadClinProcTitles;
{ private - called one time to set up the uConsultTitles object }
var
  x: string;
  Results: TStrings;
begin
  if uClinProcTitles <> nil then
    Exit;
  Results := TSTringList.Create;
  try
    CallVistA('TIU PERSONAL TITLE LIST',
      [User.DUZ, IdentifyClinProcClass], Results);
    {RPCBrokerV.}Results.Insert(0, '~SHORT LIST');
    // insert so can call ExtractItems
    uClinProcTitles := TClinProcTitles.Create;
    ExtractItems(uClinProcTitles.ShortList, { RPCBrokerV. } Results,
      'SHORT LIST');
    x := ExtractDefault( { RPCBrokerV. } Results, 'SHORT LIST');
    uClinProcTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
    uClinProcTitles.DfltTitleName := Piece(x, U, 2);
  finally
    Results.Free;
  end;
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

function SubSetOfClinProcTitles(aResults: TStrings; const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): Integer;
{ returns a pointer to a list of clinical procedures titles (for use in a long list box)}
begin
  CallVistA('TIU LONG LIST CLINPROC TITLES', [StartFrom, Direction], aResults);
  result := aResults.Count;
end;

{--------------- data retrieval ------------------------------------------}

procedure GetConsultsList(Dest: TStrings; Early, Late: double;
  Service, Status: string; SortAscending: Boolean);
{ returns a list of consults for a patient, based on selected dates, service, status, or ALL}
var
  Results: TStrings;
  i: Integer;
  x, date1, date2: string;
begin
  if Early <= 0 then date1 := '' else date1 := FloatToStr(Early) ;
  if Late  <= 0 then date2 := '' else date2 := FloatToStr(Late)  ;
  Results := TStringList.Create;
  try
    CallVistA('ORQQCN LIST', [Patient.DFN, date1, date2, Service, Status], Results);
    Dest.Clear;
    if Results.Count > 0 then
    begin
      if Copy(Results[0],1,1) <> '<' then
      begin
        SortByPiece(Results, U, 2);
        if not SortAscending then
          InvertStringList(Results);
       //SetListFMDateTime('mmm dd,yy', TStringList(Results), U, 2);
        for i := 0 to Results.Count - 1 do
        begin
          x := MakeConsultListItem(Results[i]);
          Results[i] := x;
        end;
        FastAssign(Results, Dest);
      end
      else
        Dest.Add('-1^No Matches') ;
    end
    else
      Dest.Add('-1^No Matches') ;
  finally
    Results.Free;
  end;
end;

procedure LoadConsultDetail(Dest: TStrings; IEN: integer) ;
{ returns the detail of a consult }
begin
  CallVistA('ORQQCN DETAIL', [IEN], Dest);
end;

procedure DisplayResults(Dest: TStrings; IEN: integer) ;
{ returns the results for a consult }
begin
  CallVistA('ORQQCN MED RESULTS', [IEN], Dest);
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
  ConsultRec.Clear;
  FillChar(ConsultRec, SizeOf(ConsultRec), 0);
  ConsultRec.IEN := IEN;
  alist := TSTringList.Create;
  try
    CallVistA('ORQQCN GET CONSULT', [IEN, SHOW_ADDENDA], alist);
    ConsultRec.EntryDate := -1;
    if alist.Count > 0 then
    begin
      x := alist[0];
      if Piece(x, U, 1) <> '-1' then
        with ConsultRec do
        begin
          EntryDate               := MakeFMDateTime(Piece(x, U, 1));
          ORFileNumber            := StrToIntDef(Piece(x, U, 3), 0);
          PatientLocation         := StrToIntDef(Piece(x, U, 4), 0);
          OrderingFacility        := StrToIntDef(Piece(x, U, 21), 0);
          ForeignConsultFileNum   := StrToIntDef(Piece(x, U, 22), 0);
          ToService               := StrToIntDef(Piece(x, U, 5), 0);
          From                    := StrToIntDef(Piece(x, U, 6), 0);
          RequestDate             := MakeFMDateTime(Piece(x, U, 7));
          ConsultProcedure        := Piece(x, U, 8);
          Urgency                 := StrToIntDef(Piece(x, U, 9), 0);
          PlaceOfConsult          := StrToIntDef(Piece(x, U, 10), 0);
          Attention               := StrToInt64Def(Piece(x, U, 11), 0);
          ORStatus                := StrToIntDef(Piece(x, U, 12), 0);
          LastAction              := StrToIntDef(Piece(x, U, 13), 0);
          SendingProvider         := StrToInt64Def(Piece(Piece(x, U, 14), ';', 1), 0);
          SendingProviderName     := Piece(Piece(x, U, 14), ';', 2);
          Result                  := Piece(x, U, 15);
          ModeOfEntry             := Piece(x, U, 16);
          RequestType             := StrToIntDef(Piece(x, U, 17), 0);
          InOut                   := Piece(x, U, 18);
          Findings                := Piece(x, U, 19);
          TIUResultNarrative      := StrToIntDef(Piece(x, U, 20), 0);
          ClinicallyIndicatedDate := StrToFloatDef(Piece(x, U, 24), 0);
          NoLaterThanDate         := StrToFloatDef(Piece(x, U, 25), 0);
          DstId                   := Piece(x, U, 26);
          // ProvDiagnosis         := Piece(x, U, 23);  NO!!!!! Up to 180 Characters!!!!
          alist.delete(0);
          InitSL(TIUDocuments);
          InitSL(MedResults);
          if alist.Count > 0 then
          begin
            SortByPiece(alist, U, 3);
            for i := 0 to alist.Count - 1 do
              if Copy(Piece(Piece(alist[i], U, 1), ';', 2), 1, 4) = 'MCAR' then
                MedResults.Add(alist[i])
              else
                TIUDocuments.Add(alist[i]);
          end;
        end { ConsultRec }
    end;
  finally
    alist.Free;
  end;
end;

{---------------- list box fillers -----------------------------------}
function setSubSetOfStatus(aDest: TStrings): Integer;
{ returns a pointer to a list of stati (for use in a list box) }
begin
  CallVistA('ORQQCN STATUS', [nil], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

function setSubSetOfUrgencies(aDest: TStrings; ConsultIEN: integer): Integer;
{ returns a pointer to a list of urgencies  }
begin
  CallVistA('ORQQCN URGENCIES',[ConsultIEN], aDest) ;
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

function FindConsult(ConsultIEN: integer): string ;
var
  x: string;
begin
  CallVistA('ORQQCN FIND CONSULT',[ConsultIEN], x);
  Result := MakeConsultListItem(x);
end;

{-----------------consult result functions-----------------------------------}
function setAssignableMedResults(aDest: TStrings; ConsultIEN: integer): Integer;
begin
  CallVistA('ORQQCN ASSIGNABLE MED RESULTS', [ConsultIEN], aDest);
  Result := aDest.Count;
end;

function setRemovableMedResults(aDest: TStrings; ConsultIEN: integer): Integer;
begin
  CallVistA('ORQQCN REMOVABLE MED RESULTS', [ConsultIEN], aDest);
  Result := aDest.Count;
end;

function  setDetailedMedicineResults(aDest:TStrings; ResultID: string): Integer;
begin
  CallVistA('ORQQCN GET MED RESULT DETAILS', [ResultID], aDest);
  Result := aDest.Count;
end;

procedure AttachMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64; AlertTo: string);
begin
  CallVistA('ORQQCN ATTACH MED RESULTS', [ConsultIEN, ResultID, DateTime, ResponsiblePerson, AlertTo]);
end;

procedure RemoveMedicineResult(ConsultIEN: integer; ResultID: string; DateTime: TFMDateTime; ResponsiblePerson: int64);
begin
  CallVistA('ORQQCN REMOVE MED RESULTS', [ConsultIEN, ResultID, DateTime, ResponsiblePerson]);
end;
{-------------- user access level functions ---------------------------------}

function ConsultServiceUser(ServiceIEN: integer; DUZ: int64): boolean;
var
  i: integer;
  Results: TStrings;
begin
  Result := False;
  Results := TSTringList.Create;
  try
    CallVistA('ORWU GENERIC', ['', 1, '^GMR(123.5,' + IntToStr(ServiceIEN) +
      ',123.3,"B")'], Results);
    for i := 0 to Results.Count - 1 do
      if StrToInt64(Piece(Results[i], U, 2)) = DUZ then
        Result := True;
  finally
    Results.Free;
  end;
end;

function GetActionMenuLevel(ConsultIEN: integer): TMenuAccessRec ;
var
  x: string;
begin
  CallVistA('ORQQCN SET ACT MENUS', [ConsultIEN], x) ;
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
  CallVistA('ORQQCN RECEIVE', [IEN, ReceivedBy, RcptDate, Comments], Dest);
end;

procedure ScheduleConsult(Dest: TStrings; IEN: integer; ScheduledBy: Int64; SchdDate: TFMDateTime; Alert: integer;
     AlertTo: string; Comments: TStrings);
begin
  CallVistA('ORQQCN2 SCHEDULE CONSULT', [IEN, ScheduledBy, SchdDate, Alert, AlertTo, Comments], Dest);
end;

procedure DenyConsult(Dest: TStrings; IEN: integer; DeniedBy: int64;
            DenialDate: TFMDateTime; Comments: TStrings);
begin
  CallVistA('ORQQCN DISCONTINUE', [IEN, DeniedBy, DenialDate,'DY',Comments], Dest);
end;

procedure DiscontinueConsult(Dest: TStrings; IEN: integer; DiscontinuedBy: int64;
            DiscontinueDate: TFMDateTime; Comments: TStrings);
begin
  CallVistA('ORQQCN DISCONTINUE', [IEN, DiscontinuedBy, DiscontinueDate,'DC',Comments], Dest);
end;

procedure ForwardConsult(Dest: TStrings; IEN, ToService: integer; Forwarder, AttentionOf: int64; Urgency: integer;
     ActionDate: TFMDateTime; Comments: TStrings);
begin
  CallVistA('ORQQCN FORWARD', [IEN, ToService, Forwarder, AttentionOf, Urgency, ActionDate, Comments],Dest);
end;

procedure AddComment(Dest: TStrings; IEN: integer; Comments: TStrings; ActionDate: TFMDateTime; Alert: integer;
AlertTo: string) ;
begin
  CallVistA('ORQQCN ADDCMT', [IEN, Comments, Alert, AlertTo, ActionDate], Dest);
end ;

procedure AdminComplete(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings;
          RespProv: Int64; ActionDate: TFMDateTime; Alert: integer; AlertTo: string) ;
begin
  CallVistA('ORQQCN ADMIN COMPLETE', [IEN, SigFindingsFlag, Comments, RespProv, Alert, AlertTo, ActionDate], Dest);
end ;

procedure SigFindings(Dest: TStrings; IEN: integer; SigFindingsFlag: string; Comments: TStrings; ActionDate: TFMDateTime; Alert: integer;
AlertTo: string) ;
begin
  CallVistA('ORQQCN SIGFIND', [IEN, SigFindingsFlag, Comments, Alert, AlertTo, ActionDate], Dest);
end ;

//==================  Ordering functions   ===================================
//function ODForConsults: TStrings;
{ Returns init values for consults dialog.  The results must be used immediately. }
//begin
//  CallV('ORWDCN32 DEF', ['C']);
//  Result := RPCBrokerV.Results;
//end;

function setODForConsults(aDest: TStrings): Integer;
{ Returns init values for consults dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDCN32 DEF', ['C'], aDest);
  Result := aDest.Count;
end;

//function ODForProcedures: TStrings;
{ Returns init values for procedures dialog.  The results must be used immediately. }
//begin
//  CallV('ORWDCN32 DEF', ['P']);
//  Result := RPCBrokerV.Results;
//end;

function setODForProcedures(aDest: TStrings): Integer;
{ Returns init values for procedures dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDCN32 DEF', ['P'], aDest);
  Result := aDest.Count;
end;

//function SubSetOfProcedures(const StartFrom: string; Direction: Integer): TStrings;
//begin
//  CallV('ORWDCN32 PROCEDURES', [StartFrom, Direction]);
//  Result := RPCBrokerV.Results;
//end;

function setSubSetOfProcedures(aDest: TStrings;const StartFrom: string; Direction: Integer): Integer;
begin
  CallVistA('ORWDCN32 PROCEDURES', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

//function LoadServiceList(Purpose: integer): TStrings ;
// Purpose:  0=display all services, 1=forward or order from possible services
//begin
//  Callv('ORQQCN SVCTREE',[Purpose]) ;
//  MixedCaseList(RPCBrokerV.Results) ;
//  Result := RPCBrokerV.Results;
//end ;

function setServiceList(aDest: Tstrings;Purpose: integer): Integer;
// Purpose:  0=display all services, 1=forward or order from possible services
begin
  CallVistA('ORQQCN SVCTREE',[Purpose], aDest) ;
  MixedCaseList(aDest) ;
  Result := aDest.Count;
end ;
{
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
}
function setServiceList(aDest: TStrings;ShowSynonyms: Boolean; StartService, Purpose: Integer; ConsultIEN: integer = -1): Integer;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
// Param 4 = Consult IEN
begin
  if ConsultIEN > -1 then
   CallVistA('ORQQCN SVC W/SYNONYMS',[StartService, Purpose, ShowSynonyms, ConsultIEN], aDest)
  else
   CallVistA('ORQQCN SVC W/SYNONYMS',[StartService, Purpose, ShowSynonyms], aDest) ;
  MixedCaseList(aDest);
  Result := aDest.Count;
end ;
{
function LoadServiceListWithSynonyms(Purpose: integer): TStrings ;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
begin
  Callv('ORQQCN SVC W/SYNONYMS',[1, Purpose, True]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end;
}
function setServiceListWithSynonyms(aDest:TStrings; Purpose: integer): Integer;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
begin
  CallVistA('ORQQCN SVC W/SYNONYMS',[1, Purpose, True],aDest) ;
  MixedCaseList(aDest) ;
  Result := aDest.Count;
end ;
{
function LoadServiceListWithSynonyms(Purpose, ConsultIEN: integer): TStrings ;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
// Param 4 = Consult IEN
begin
  Callv('ORQQCN SVC W/SYNONYMS',[1, Purpose, True, ConsultIEN]) ;
  MixedCaseList(RPCBrokerV.Results) ;
  Result := RPCBrokerV.Results;
end;
}
function setServiceListWithSynonyms(aDest:TStrings; Purpose, ConsultIEN: integer): Integer;
// Param 1 = Starting service (1=All Services)
// Param 2 = Purpose:  0=display all services, 1=forward or order from possible services
// Param 3 = Show synonyms
// Param 4 = Consult IEN
begin
  CallVistA('ORQQCN SVC W/SYNONYMS',[1, Purpose, True, ConsultIEN], aDest) ;
  MixedCaseList(aDest) ;
  Result := aDest.Count;
end ;

{ Not Used?
function SubSetOfServices(const StartFrom: string; Direction: Integer): TStrings;
//  used only on consults order dialog for service long combo box, which needs to include quick orders
begin
  CallV('ORQQCN SVCLIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;
function setSubSetOfServices(aDest: TStrings; const StartFrom: string; Direction: Integer): Integer;
//  used only on consults order dialog for service long combo box, which needs to include quick orders
begin
  CallVistA('ORQQCN SVCLIST', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

function LoadConsultsQuickList: TStrings ;
begin
  Callv('ORWDXQ GETQLST',['CSLT', 'Q']) ;
  Result := RPCBrokerV.Results;
end;
function setConsultsQuickList(aDest: TStrings): Integer ;
begin
  CallvistA('ORWDXQ GETQLST',['CSLT', 'Q'], aDest) ;
  Result := aDest.Count;
end ;
}

function setSF513(aDest:TStrings;ConsultIEN: integer): Integer;
var
  x: string;
  i: integer;
begin
  CallVistA('ORQQCN SHOW SF513',[ConsultIEN], aDest) ;
  if aDest.Count > 0 then
    begin
      x := aDest[0];
      i := Pos('-', x);
      x := Copy(x, i, 999);
      aDest[0] := x;
    end;
  Result := aDest.Count;
end ;

procedure PrintSF513ToDevice(AConsult: Integer; const ADevice: string; ChartCopy: string;
  var ErrMsg: string);
{ prints a SF 513 on the selected device }
begin
  CallVistA('ORQQCN PRINT SF513', [AConsult, ChartCopy, ADevice], ErrMsg);
//  if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

//function GetFormattedSF513(AConsult: Integer; ChartCopy: string): TStrings;
//begin
//  CallV('ORQQCN SF513 WINDOWS PRINT',[AConsult, ChartCopy]);
//  Result := RPCBrokerV.Results;
//end;
function setFormattedSF513(aDest:TStrings;AConsult: Integer; ChartCopy: string): Integer;
begin
  CallVistA('ORQQCN SF513 WINDOWS PRINT',[AConsult, ChartCopy],aDest);
  Result := aDest.Count;
end;

function UnresolvedConsultsExist: boolean;
var
  s: String;
begin
  Result := CallVistA('ORQQCN UNRESOLVED', [Patient.DFN], s) and (s = '1');
end;

procedure GetUnresolvedConsultsInfo;
var
  x: string;
begin
  CallVistA('ORQQCN UNRESOLVED', [Patient.DFN], x);
  with uUnresolvedConsults do
  begin
    UnresolvedConsultsExist := (Piece(x, U, 1) = '1');
    ShowNagScreen := (Piece(x, U, 2) = '1');
  end;
end;

function ConsultMessage(AnIEN: Integer): string;
var
  sl: TStringList;

begin
  if AnIEN = uLastOrderedIEN then Result := uLastOrderMsg else
  begin
    sl := TStringList.Create;
    try
      CallVistA('ORWDCN32 ORDRMSG', [AnIEN], sl);
      Result := sl.Text;
      uLastOrderedIEN := AnIEN;
      uLastOrderMsg := Result;
    finally
      sl.Free;
    end;
  end;
end;

function GetProcedureIEN(ORIEN: string): string;
begin
  CallVistA('ORQQCN GET PROC IEN', [ORIEN], Result);
end;

//function GetProcedureServices(ProcIEN: integer): TStrings;
//begin
//  CallV('ORQQCN GET PROC SVCS',[ProcIEN]) ;
//  Result := RPCBrokerV.Results;
//end;

function setProcedureServices(aDest:TStrings; ProcIEN: integer): Integer;
begin
  CallVistA('ORQQCN GET PROC SVCS',[ProcIEN], aDest) ;
  Result := aDest.Count;
end;

function ConsultCanBeResubmitted(ConsultIEN: integer): string;
begin
  CallVistA('ORQQCN CANEDIT', [ConsultIEN], Result);
end;

function LoadConsultForEdit(ConsultIEN: integer): TEditResubmitRec;
var
  Dest: TStringList;
  EditRec: TEditResubmitRec;
begin
  Dest := TStringList.Create;
  try
    CallVistA('ORQQCN LOAD FOR EDIT',[ConsultIEN],Dest) ;
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
         NoLaterThanDate            := StrToFloatDef(Piece(ExtractDefault(Dest, 'NLTD'), U, 2), 0);
         Place           := Piece(ExtractDefault(Dest, 'PLACE'), U, 1);
         PlaceName       := Piece(ExtractDefault(Dest, 'PLACE'), U, 2);
         Attention       := StrToInt64Def(Piece(ExtractDefault(Dest, 'ATTENTION'), U, 1), 0);
         AttnName        := Piece(ExtractDefault(Dest, 'ATTENTION'), U, 2);
         InpOutp         := Piece(ExtractDefault(Dest, 'CATEGORY'), U, 1);
         ProvDiagnosis      := Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 1);
         ProvDxCode         := Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 2);
         ProvDxCodeInactive := (Piece(ExtractDefault(Dest, 'DIAGNOSIS'), U, 3) = '1');
         InitSL(RequestReason);
         ExtractText(RequestReason, Dest, 'REASON');
         LimitStringLength(RequestReason, 74);
         InitSL(DenyComments);
         ExtractText(DenyComments, Dest, 'DENY COMMENT');
         InitSL(OtherComments);
         ExtractText(OtherComments, Dest, 'ADDED COMMENT');
         InitSL(NewComments);
         EditRec.DstId           := Piece(ExtractDefault(Dest, 'DSTID'), U, 2);
      end;
    Result := EditRec;
  finally
    Dest.Free;
  end;
end;

function ResubmitConsult(EditResubmitRec: TEditResubmitRec): string;
var
  i: integer;
  aList: iORNetMult;
begin
  neworNetMult(aList);
  with EditResubmitRec do
    begin
          if ToService > 0 then
            aList.AddSubscript(['1'], 'GMRCSS^'   + IntToStr(ToService));
          if ConsultProc <> '' then
            aList.AddSubscript(['2'], 'GMRCPROC^' + ConsultProc);
          if Urgency > 0 then
            aList.AddSubscript(['3'], 'GMRCURG^'  + IntToStr(Urgency));
          if Length(Place) > 0 then
            aList.AddSubscript(['4'], 'GMRCPL^'   + Place);
          if Attention > 0 then
            aList.AddSubscript(['5'], 'GMRCATN^'  + IntToStr(Attention))
          else if Attention = -1 then
            aList.AddSubscript(['5'], 'GMRCATN^'  + '@');
          if RequestType <> '' then
            aList.AddSubscript(['6'], 'GMRCRQT^'  + RequestType);
          if Length(InpOutP) > 0 then
            aList.AddSubscript(['7'], 'GMRCION^'  + InpOutp);
          if Length(ProvDiagnosis) > 0 then
            aList.AddSubscript(['8'], 'GMRCDIAG^' + ProvDiagnosis + U + ProvDxCode);
          if RequestReason.Count > 0 then
            begin
              aList.AddSubscript(['9'], 'GMRCRFQ^20');
              for i := 0 to RequestReason.Count - 1 do
                aList.AddSubscript(['9', IntToStr(i+1)],RequestReason.Strings[i]);
            end;
          if NewComments.Count > 0 then
            begin
              aList.AddSubscript(['10'], 'COMMENT^');
              for i := 0 to NewComments.Count - 1 do
                aList.AddSubscript(['10', IntToStr(i+1)], NewComments.Strings[i]);
            end;
          if ClinicallyIndicatedDate > 0 then
             aList.AddSubscript(['11'], 'GMRCERDT^'  + FloatToStr(ClinicallyIndicatedDate));  //wat renamed v28
          if NoLaterThanDate > 0 then
             aList.AddSubscript(['12'],'GMRCNLTD^'  + FloatToStr(NoLaterThanDate));
          if DstId <> '' then
             aList.AddSubscript(['13'],'GMRCDSID^' + DstId);
    end;
  CallVistA('ORQQCN RESUBMIT',[EditResubmitRec.IEN,aList]);
  Result := '0';
end;

function  GetCurrentContext: TSelectContext;
var
  x: string;
  AContext: TSelectContext;
begin
  CallVistA('ORQQCN2 GET CONTEXT', [User.DUZ], x) ;
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
  CallVistA('ORQQCN2 SAVE CONTEXT', [x]);
end;

//function GetDefaultReasonForRequest(Service: string; Resolve: Boolean): TStrings;
//begin
//  CallV('ORQQCN DEFAULT REQUEST REASON',[Service, Patient.DFN, Resolve]) ;
//  Result := RPCBrokerV.Results;
//end;
function setDefaultReasonForRequest(aDest: TStrings;Service: string; Resolve: Boolean): Integer;
begin
  CallVistA('ORQQCN DEFAULT REQUEST REASON',[Service, Patient.DFN, Resolve], aDest) ;
  Result := aDest.Count;
end;

function ReasonForRequestEditable(Service: string): string;
begin
  CallVistA('ORQQCN EDIT DEFAULT REASON', [Service], Result);
end;

//function GetServicePrerequisites(Service: string): TStrings;
//begin
//  CallV('ORQQCN2 GET PREREQUISITE',[Service, Patient.DFN]) ;
//  Result := RPCBrokerV.Results;
//end;
function setServicePrerequisites(aDest: TStrings;Service: string): Integer;
begin
  CallVistA('ORQQCN2 GET PREREQUISITE',[Service, Patient.DFN], aDest) ;
  Result := aDest.Count;
end;

function GetNewDialog(OrderType: string): string;
{ get dialog for new consults}
begin
  CallVistA('ORWDCN32 NEWDLG', [OrderType, Encounter.Location], Result);
end;

function GetServiceIEN(ORIEN: string): string;
begin
  CallVistA('ORQQCN GET SERVICE IEN', [ORIEN], Result);
end;

procedure GetProvDxMode(var ProvDx: TProvisionalDiagnosis; SvcIEN: string);
var
  x: string;
begin
  CallVistA('ORQQCN PROVDX', [SvcIEN], x);
  ProvDx.Reqd := Piece(x, U, 1);
  ProvDx.PromptMode := Piece(x, U, 2);
end;

function GetConsultOrderIEN(ConsultIEN: integer): string;
begin
  CallVistA('ORQQCN GET ORDER NUMBER', [ConsultIEN], Result);
end;

function GetSavedCPFields(NoteIEN: integer): TEditNoteRec;
var
  x: string;
  AnEditRec: TEditNoteRec;
begin
  CallVistA('ORWTIU GET SAVED CP FIELDS', [NoteIEN], x);
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

function IsProstheticsService(SvcIen : int64) : Boolean;  //wat v28
var
  s: String;
begin
  CallVistA('ORQQCN ISPROSVC', [SvcIEN], s);
  Result := s = '1';
end;

function GetServiceUserLevel(ServiceIEN, UserDUZ: integer): String;
// Param 1 = IEN of service
// Param 2 = Users DUZ (currently can be null)
begin
  // Result := sCallV('ORQQCN GET USER AUTH',[ServiceIEN]) ;
  CallVistA('ORQQCN GET USER AUTH', [ServiceIEN], Result);
end;

initialization
  uLastOrderedIEN := 0;
  uLastOrderMsg := '';
  uConsultsClass := 0;
  uClinProcClass := 0;

finalization
  KillObj(@uConsultTitles);
  KillObj(@uClinProcTitles);

end.

unit rSurgery;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, dialogs, uSurgery;

type
  TSurgCaseContext = record
    Changed: Boolean;
    OpProc:  string;
    BeginDate: string;
    FMBeginDate: TFMDateTime;
    EndDate: string;
    FMEndDate: TFMDateTime;
    MaxDocs: integer;
    Status: string;
    GroupBy: string;
    TreeAscending: Boolean;
  end ;

  TShowSurgeryTab = record
    Evaluated: boolean;
    ShowIt:     boolean;
  end;

  TShowOpTop = record
    Evaluated: boolean;
    ShowIt:    integer;
  end;

{Surgery Titles }
function  DfltSurgeryTitle(AClassName: string): integer;
function  DfltSurgeryTitleName(AClassName: string): string;
procedure ListSurgeryTitlesShort(Dest: TStrings; AClassName: string);
function SubSetOfSurgeryTitles(const StartFrom: string; Direction: Integer; AClassName: string): TStrings;
function IsSurgeryTitle(TitleIEN: Integer): Boolean;
procedure ResetSurgeryTitles;

{ Data Retrieval }
procedure GetSurgCaseList(Dest: TStrings; Early, Late: double; Context, Max: integer);
procedure ListSurgeryCases(Dest: TStrings);
procedure GetSingleCaseListItemWithDocs(Dest: TStrings; NoteIEN: integer);
function GetSingleCaseListItemWithoutDocs(NoteIEN: integer): string;
//procedure LoadOpTop(Dest: TStrings; ACaseIEN: integer; IsNonORProc, ShowReport: boolean) ;
procedure LoadSurgReportText(Dest: TStrings; IEN: integer) ;
procedure LoadSurgReportDetail(Dest: TStrings; IEN: integer) ;
function  GetCurrentSurgCaseContext: TSurgCaseContext;
procedure SaveCurrentSurgCaseContext(AContext: TSurgCaseContext) ;
function  GetSurgCaseRefForNote(NoteIEN: integer): string;
//function  ShowOpTopOnSignature(ACaseIEN: integer): integer;
function ShowSurgeryTab: boolean;
function IsNonORProcedure(ACaseIEN: integer): boolean;

implementation

var
  uSurgeryTitles: TSurgeryTitles;
  uShowSurgeryTab: TShowSurgeryTab;
  //uShowOpTop: TShowOpTop;

function ShowSurgeryTab: boolean;
begin
  with uShowSurgeryTab do
    begin
      if not Evaluated then
        begin
          ShowIt := sCallV('ORWSR SHOW SURG TAB', [nil]) = '1';
          Evaluated := True;
        end;
      Result := ShowIt;
    end;
end;
{ -------------------------- Surgery Titles --------------------------------- }

procedure LoadSurgeryTitles(AClassName: string);
{ private - called to set up the uSurgeryTitles object }
var
  SurgeryClass: integer;
  x: string;
begin
  if uSurgeryTitles <> nil then
  begin
    if uSurgeryTitles.Classname = AClassName then exit;
    uSurgeryTitles.Free;
    uSurgeryTitles := nil;
  end;
  // pass in class name to return OR/non-OR class, depending on selected case
  SurgeryClass := StrToInt(sCallV('TIU IDENTIFY SURGERY CLASS',[AClassName]))  ;
  CallV('TIU PERSONAL TITLE LIST', [User.DUZ, SurgeryClass]);
  RPCBrokerV.Results.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
  uSurgeryTitles := TSurgeryTitles.Create;
  ExtractItems(uSurgeryTitles.ShortList, RPCBrokerV.Results, 'SHORT LIST');
  x := ExtractDefault(RPCBrokerV.Results, 'SHORT LIST');
  uSurgeryTitles.ClassName := AClassName;
  uSurgeryTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
  uSurgeryTitles.DfltTitleName := Piece(x, U, 2);
end;

procedure ResetSurgeryTitles;
begin
  if uSurgeryTitles <> nil then
    begin
      uSurgeryTitles.Free;
      uSurgeryTitles := nil;
    end;
end;

function DfltSurgeryTitle(AClassName: string): integer;
{ returns the user defined default Surgery title (if any) }
begin
  if AClassName <> uSurgeryTitles.ClassName then LoadSurgeryTitles(AClassName);
  Result := uSurgeryTitles.DfltTitle;
end;

function DfltSurgeryTitleName(AClassName: string): string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if AClassName <> uSurgeryTitles.ClassName then LoadSurgeryTitles(AClassName);
  Result := uSurgeryTitles.DfltTitleName;
end;

procedure ListSurgeryTitlesShort(Dest: TStrings; AClassName: string);
{ returns the user defined list (short list) of Surgery titles }
begin
  if (uSurgeryTitles = nil) or (AClassName <> uSurgeryTitles.ClassName) then LoadSurgeryTitles(AClassName);
  FastAddStrings(uSurgeryTitles.ShortList, Dest);
  if uSurgeryTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

function SubSetOfSurgeryTitles(const StartFrom: string; Direction: Integer; AClassName: string): TStrings;
{ returns a pointer to a list of Surgery progress note titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
   // pass in class name based on OR/non-OR
   CallV('TIU LONG LIST SURGERY TITLES', [StartFrom, Direction, AClassName]);
  //MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

function IsSurgeryTitle(TitleIEN: Integer): Boolean;
begin
  Result := False;
  if not ShowSurgeryTab then exit;
  if TitleIEN <= 0 then Exit;
  Result := sCallV('TIU IS THIS A SURGERY?', [TitleIEN]) = '1';
end;

{--------------- data retrieval ------------------------------------------}

procedure GetSurgCaseList(Dest: TStrings; Early, Late: double; Context, Max: integer);
{ returns a list of surgery cases for a patient, based on selected dates, service, status, or ALL}
(*
CASE #^Operative Procedure^Date/Time of Operation^Surgeon;Surgeon name^^^^^^^^^+^Context*)
var
  date1, date2: string;
begin
  if Early <= 0 then date1 := '' else date1 := FloatToStr(Early) ;
  if Late  <= 0 then date2 := '' else date2 := FloatToStr(Late)  ;
  CallV('ORWSR LIST', [Patient.DFN, date1, date2, Context, Max]);
  with RPCBrokerV do
   begin
    if Results.Count > 0 then
      begin
       SortByPiece(TStringList(Results), U, 2);
       InvertStringList(TStringList(Results));
       FastAssign(Results, Dest);
     end
    else
     begin
       Dest.Clear ;
       Dest.Add('-1^No Matches') ;
     end ;
  end;
end;

procedure ListSurgeryCases(Dest: TStrings);
{ returns a list of surgery cases for a patient, without documents, for fNoteProps case selection}
//CASE #^Operative Procedure^Date/Time of Operation^Surgeon;Surgeon name)
begin
  CallV('ORWSR CASELIST', [Patient.DFN]);
  with RPCBrokerV do
   begin
    if Results.Count > 0 then
      begin
       SortByPiece(TStringList(Results), U, 3);
       InvertStringList(TStringList(Results));
       SetListFMDateTime('dddddd hh:nn', TStringList(Results), U, 3);
       FastAssign(Results, Dest);
     end
    else
     begin
       Dest.Clear ;
       Dest.Add('-1^No Cases Found') ;
     end ;
  end;
end;


procedure LoadSurgReportText(Dest: TStrings; IEN: integer) ;
{ returns the text of a surgery report }
begin
  CallV('TIU GET RECORD TEXT', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadSurgReportDetail(Dest: TStrings; IEN: integer) ;
{ returns the detail of a surgery report }
begin
  CallV('TIU DETAILED DISPLAY', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

(*procedure LoadOpTop(Dest: TStrings; ACaseIEN: integer; IsNonORProc, ShowReport: boolean) ;
{ returns the OpTop for a surgical case }
begin
  if IsNonORProc then
    CallV('ORWSR OPTOP NON-OR', [ACaseIEN, ShowReport])
  else
    CallV('ORWSR OPTOP', [ACaseIEN, ShowReport]);
  with RPCBrokerV do
    begin
      //if Results.Count > 0 then Results.Delete(0);   //This is the value of the ShowOpTopOnSignature site parameter.
      FastAssign(Results, Dest);
    end;
end;*)

function GetCurrentSurgCaseContext: TSurgCaseContext;
var
  x: string;
  AContext: TSurgCaseContext;
begin
  x := sCallV('ORWSR GET SURG CONTEXT', [User.DUZ]) ;
  with AContext do
    begin
      Changed       := True;
      BeginDate     := Piece(x, ';', 1);
      FMBeginDate   := StrToFMDateTime(BeginDate);
      EndDate       := Piece(x, ';', 2);
      FMEndDate     := StrToFMDateTime(EndDate);
      Status        := Piece(x, ';', 3);
      GroupBy       := Piece(x, ';', 4);
      MaxDocs       := StrToIntDef(Piece(x, ';', 5), 0);
      TreeAscending     := (Piece(x, ';', 6) = '1');
    end;
  Result := AContext;
end ;

procedure SaveCurrentSurgCaseContext(AContext: TSurgCaseContext) ;
var
  x: string;
begin
  with AContext do
    begin
      SetPiece(x, ';', 1, BeginDate);
      SetPiece(x, ';', 2, EndDate);
      SetPiece(x, ';', 3, Status);
      SetPiece(x, ';', 4, GroupBy);
      SetPiece(x, ';', 5, IntToStr(MaxDocs));
      SetPiece(x, ';', 6, BOOLCHAR[TreeAscending]);
    end;
  CallV('ORWSR SAVE SURG CONTEXT', [x]);
end;                                                                                 

function GetSurgCaseRefForNote(NoteIEN: integer): string;
var
  x: string;
begin
  x := sCallV('TIU GET REQUEST', [NoteIEN]);
  if Piece(x, ';', 2) <> 'SRF(' then
    Result := '-1'
  else
    Result := x
end;

procedure GetSingleCaseListItemWithDocs(Dest: TStrings; NoteIEN: integer);
begin
  CallV('ORWSR ONECASE', [NoteIEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function GetSingleCaseListItemWithoutDocs(NoteIEN: integer): string;
begin
  CallV('ORWSR ONECASE', [NoteIEN]);
  if RPCBrokerV.Results.Count > 0 then Result := RPCBrokerV.Results[0];
end;

(*function  ShowOpTopOnSignature(ACaseIEN: integer): integer;
begin
  with uShowOpTop do
    begin
      if not Evaluated then
        begin
          ShowIt := StrToIntDef(sCallV('ORWSR SHOW OPTOP WHEN SIGNING', [ACaseIEN]), 0);
          Evaluated := True;
        end;
      Result := ShowIt;
    end;
end;*)

function IsNonORProcedure(ACaseIEN: integer): boolean;
begin
  Result := sCallV('ORWSR IS NON-OR PROCEDURE', [ACaseIEN]) = '1';
end;

initialization

finalization
  if uSurgeryTitles <> nil then uSurgeryTitles.Free;

end.

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
function SubSetOfSurgeryTitles(const StartFrom: string; Direction: Integer; AClassName: string; aResults: TStrings): integer;
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
var
  aStr: String;
begin
  with uShowSurgeryTab do
    begin
      if not Evaluated then
        begin
          CallVistA('ORWSR SHOW SURG TAB', [nil], aStr);
          ShowIt := (aStr = '1');
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
  aLst: TStringList;
begin
  if uSurgeryTitles <> nil then
  begin
    if uSurgeryTitles.Classname = AClassName then exit;
    uSurgeryTitles.Free;
    uSurgeryTitles := nil;
  end;
  // pass in class name to return OR/non-OR class, depending on selected case
  CallVistA('TIU IDENTIFY SURGERY CLASS', [AClassName], SurgeryClass);

  aLst := TStringList.Create;
  try
    CallVistA('TIU PERSONAL TITLE LIST', [User.DUZ, SurgeryClass], aLst);
    aLst.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
    uSurgeryTitles := TSurgeryTitles.Create;
    ExtractItems(uSurgeryTitles.ShortList, aLst, 'SHORT LIST');
    x := ExtractDefault(aLst, 'SHORT LIST');
    uSurgeryTitles.ClassName := AClassName;
    uSurgeryTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
    uSurgeryTitles.DfltTitleName := Piece(x, U, 2);
  finally
    FreeAndNil(aLst);
  end;
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

function SubSetOfSurgeryTitles(const StartFrom: string; Direction: integer; AClassName: string; aResults: TStrings): integer;
begin
  // pass in class name based on OR/non-OR
  CallVistA('TIU LONG LIST SURGERY TITLES', [StartFrom, Direction, AClassName], aResults);
  Result := aResults.Count;
end;

function IsSurgeryTitle(TitleIEN: Integer): Boolean;
var
  aStr: String;
begin
  if ShowSurgeryTab and (TitleIEN > 0) then
    begin
      CallVistA('TIU IS THIS A SURGERY?', [TitleIEN], aStr);
      Result := (aStr = '1');
    end
  else
    Result := False;
end;

{--------------- data retrieval ------------------------------------------}

procedure GetSurgCaseList(Dest: TStrings; Early, Late: double; Context, Max: integer);
{ returns a list of surgery cases for a patient, based on selected dates, service, status, or ALL }
(*
  CASE #^Operative Procedure^Date/Time of Operation^Surgeon;Surgeon name^^^^^^^^^+^Context *)
var
  date1, date2: string;
begin
  if Early <= 0 then
    date1 := ''
  else
    date1 := FloatToStr(Early);
  if Late <= 0 then
    date2 := ''
  else
    date2 := FloatToStr(Late);

  CallVistA('ORWSR LIST', [Patient.DFN, date1, date2, Context, Max], Dest);
  if Dest.Count > 0 then
    begin
//      SortByPiece(TStringList(Dest), U, 2);
      SortByPiece(Dest, U, 2);
      InvertStringList(TStringList(Dest));
    end
  else
    Dest.Add('-1^No Matches');
end;

procedure ListSurgeryCases(Dest: TStrings);
{ returns a list of surgery cases for a patient, without documents, for fNoteProps case selection }
// CASE #^Operative Procedure^Date/Time of Operation^Surgeon;Surgeon name)
begin
  CallVistA('ORWSR CASELIST', [Patient.DFN], Dest);
  if Dest.Count > 0 then
    begin
//      SortByPiece(TStringList(Dest), U, 3);
      SortByPiece(Dest, U, 3);
      InvertStringList(TStringList(Dest));
//      SetListFMDateTime('mmm dd,yy hh:nn', TStringList(Dest), U, 3);
      SetListFMDateTime('mmm dd,yy hh:nn', Dest, U, 3);
    end
  else
    Dest.Add('-1^No Cases Found');
end;


procedure LoadSurgReportText(Dest: TStrings; IEN: integer) ;
{ returns the text of a surgery report }
begin
  CallVistA('TIU GET RECORD TEXT', [IEN], Dest);
end;

procedure LoadSurgReportDetail(Dest: TStrings; IEN: integer) ;
{ returns the detail of a surgery report }
begin
  CallVistA('TIU DETAILED DISPLAY', [IEN], Dest);
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
  CallVistA('ORWSR GET SURG CONTEXT', [User.DUZ], x);
  with AContext do
    begin
      Changed := True;
      BeginDate := Piece(x, ';', 1);
      FMBeginDate := StrToFMDateTime(BeginDate);
      EndDate := Piece(x, ';', 2);
      FMEndDate := StrToFMDateTime(EndDate);
      Status := Piece(x, ';', 3);
      GroupBy := Piece(x, ';', 4);
      MaxDocs := StrToIntDef(Piece(x, ';', 5), 0);
      TreeAscending := (Piece(x, ';', 6) = '1');
    end;
  Result := AContext;
end;

procedure SaveCurrentSurgCaseContext(AContext: TSurgCaseContext);
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
  CallVistA('ORWSR SAVE SURG CONTEXT', [x]);
end;

function GetSurgCaseRefForNote(NoteIEN: integer): string;
var
  x: string;
begin
  CallVistA('TIU GET REQUEST', [NoteIEN], x);
  if Piece(x, ';', 2) <> 'SRF(' then
    Result := '-1'
  else
    Result := x
end;

procedure GetSingleCaseListItemWithDocs(Dest: TStrings; NoteIEN: integer);
begin
  CallVistA('ORWSR ONECASE', [NoteIEN], Dest);
end;

function GetSingleCaseListItemWithoutDocs(NoteIEN: integer): string;
begin
  CallVistA('ORWSR ONECASE', [NoteIEN], Result);
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
var
  aStr: string;
begin
  CallVistA('ORWSR IS NON-OR PROCEDURE', [ACaseIEN], aStr);
  Result := (aStr = '1');
end;

initialization

finalization
  if uSurgeryTitles <> nil then uSurgeryTitles.Free;

end.

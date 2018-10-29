unit rTIU;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU;

type
  TPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;

{ Progress Note Titles }
function DfltNoteTitle: Integer;
function DfltNoteTitleName: string;
procedure ResetNoteTitles;
function IsConsultTitle(TitleIEN: Integer): Boolean;
function IsPRFTitle(TitleIEN: Integer): Boolean;
function IsClinProcTitle(TitleIEN: Integer): Boolean;
procedure ListNoteTitlesShort(Dest: TStrings);
procedure LoadBoilerPlate(Dest: TStrings; Title: Integer);
function PrintNameForTitle(TitleIEN: Integer): string;
function SubSetOfNoteTitles(const StartFrom: string; Direction: Integer; IDNotesOnly: boolean): TStrings;

{ TIU Preferences }
procedure ResetTIUPreferences;
function AskCosignerForNotes: Boolean;
function AskCosignerForDocument(ADocument: Integer; AnAuthor: Int64; ADate: TFMDateTime): Boolean;
function AskCosignerForTitle(ATitle: integer; AnAuthor: Int64; ADate: TFMDateTime): Boolean;
function AskSubjectForNotes: Boolean;
function CanCosign(ATitle, ADocType: integer; AUser: Int64; ADate: TFMDateTime): Boolean;
function CanChangeCosigner(IEN: integer): boolean;
procedure DefaultCosigner(var IEN: Int64; var Name: string);
function ReturnMaxNotes: Integer;
function SortNotesAscending: Boolean;
function GetCurrentTIUContext: TTIUContext;
procedure SaveCurrentTIUContext(AContext: TTIUContext) ;
function TIUSiteParams: string;
function DfltTIULocation: Integer;
function DfltTIULocationName: string;

{ Data Retrieval }
procedure ActOnDocument(var AuthSts: TActionRec; IEN: Integer; const ActionName: string);
function AuthorSignedDocument(IEN: Integer): boolean;
function CosignDocument(IEN: Integer): Boolean;
//function CPTRequiredForNote(IEN: Integer): Boolean;
procedure ListNotes(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
procedure ListNotesForTree(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
procedure ListConsultRequests(Dest: TStrings);
procedure ListDCSumm(Dest: TStrings);
procedure LoadDetailText(Dest: TStrings; IEN: Integer);    //**KCM**
procedure LoadDocumentText(Dest: TStrings; IEN: Integer);
procedure GetNoteForEdit(var EditRec: TEditNoteRec; IEN: Integer);
function VisitStrForNote(IEN: Integer): string;
function GetCurrentSigners(IEN: integer): TStrings;
function TitleForNote(IEN: Int64): Integer;
function GetConsultIENforNote(NoteIEN: integer): Integer;
function GetPackageRefForNote(NoteIEN: integer): string;
procedure LockDocument(IEN: Int64; var AnErrMsg: string);
procedure UnlockDocument(IEN: Int64);
function LastSaveClean(IEN: Int64): Boolean;
function NoteHasText(NoteIEN: integer): boolean;
function GetTIUListItem(IEN: Int64): string;

{ Data Storage }
//procedure ClearCPTRequired(IEN: Integer);
procedure DeleteDocument(var DeleteSts: TActionRec; IEN: Integer; const Reason: string);
function JustifyDocumentDelete(IEN: Integer): Boolean;
procedure SignDocument(var SignSts: TActionRec; IEN: Integer; const ESCode: string);
procedure PutNewNote(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec);
procedure PutAddendum(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec; AddendumTo: Integer);
procedure PutEditedNote(var UpdatedDoc: TCreatedDoc; const NoteRec: TNoteRec; NoteIEN: Integer);
procedure PutTextOnly(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64);
procedure SetText(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64; Suppress: Integer);
procedure InitParams(NoteIEN: Int64; Suppress: Integer);
procedure UpdateAdditionalSigners(IEN: integer; Signers: TStrings);
procedure ChangeCosigner(IEN: integer; Cosigner: int64);

{ Printing }
function AllowPrintOfNote(ANote: Integer): string;
function AllowChartPrintForNote(ANote: Integer): Boolean;
procedure PrintNoteToDevice(ANote: Integer; const ADevice: string; ChartCopy: Boolean;
  var ErrMsg: string);
function GetFormattedNote(ANote: Integer; ChartCopy: Boolean): TStrings;

//  Interdisciplinary Notes
function IDNotesInstalled: boolean;
function CanTitleBeIDChild(Title: integer; var WhyNot: string): boolean;
function CanReceiveAttachment(DocID: string; var WhyNot: string): boolean;
function CanBeAttached(DocID: string; var WhyNot: string): boolean;
function DetachEntryFromParent(DocID: string; var WhyNot: string): boolean;
function AttachEntryToParent(DocID, ParentDocID: string; var WhyNot: string): boolean;
function OneNotePerVisit(NoteEIN: Integer; DFN: String;VisitStr: String): boolean;


//User Classes
function SubSetOfUserClasses(const StartFrom: string; Direction: Integer): TStrings;
function UserDivClassInfo(User: Int64): TStrings;
function UserInactive(EIN: String): boolean;

//Miscellaneous
function TIUPatch175Installed: boolean;

const
  CLS_PROGRESS_NOTES = 3;

implementation

uses rMisc;

var
  uTIUSiteParams: string;
  uTIUSiteParamsLoaded: boolean = FALSE;
  uNoteTitles: TNoteTitles;
  uTIUPrefs: TTIUPrefs;
  uPatch175Installed: TPatchInstalled;


{ Progress Note Titles  -------------------------------------------------------------------- }

procedure LoadNoteTitles;
{ private - called one time to set up the uNoteTitles object }
const
  CLASS_PROGRESS_NOTES = 3;
var
  x: string;
begin
  if uNoteTitles <> nil then Exit;
  CallV('TIU PERSONAL TITLE LIST', [User.DUZ, CLS_PROGRESS_NOTES]);
  RPCBrokerV.Results.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
  uNoteTitles := TNoteTitles.Create;
  ExtractItems(uNoteTitles.ShortList, RPCBrokerV.Results, 'SHORT LIST');
  x := ExtractDefault(RPCBrokerV.Results, 'SHORT LIST');
  uNoteTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
  uNoteTitles.DfltTitleName := Piece(x, U, 2);
end;

procedure ResetNoteTitles;
begin
  if uNoteTitles <> nil then
    begin
      uNoteTitles.Free;
      uNoteTitles := nil;
      LoadNoteTitles;
    end;
end;

function DfltNoteTitle: Integer;
{ returns the IEN of the user defined default progress note title (if any) }
begin
  if uNoteTitles = nil then LoadNoteTitles;
  Result := uNoteTitles.DfltTitle;
end;

function DfltNoteTitleName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uNoteTitles = nil then LoadNoteTitles;
  Result := uNoteTitles.DfltTitleName;
end;

function IsConsultTitle(TitleIEN: Integer): Boolean;
begin
  Result := False;
  if TitleIEN <= 0 then Exit;
  Result := sCallV('TIU IS THIS A CONSULT?', [TitleIEN]) = '1';
end;

function IsPRFTitle(TitleIEN: Integer): Boolean;
begin
  Result := False;
  if TitleIEN <= 0 then Exit;
  Result := sCallV('TIU ISPRF', [TitleIEN]) = '1'; 
end;

function IsClinProcTitle(TitleIEN: Integer): Boolean;
begin
  Result := False;
  if TitleIEN <= 0 then Exit;
  Result := sCallV('TIU IS THIS A CLINPROC?', [TitleIEN]) = '1';
end;

procedure ListNoteTitlesShort(Dest: TStrings);
{ returns the user defined list (short list) of progress note titles }
begin
  if uNoteTitles = nil then LoadNoteTitles;
  Dest.AddStrings(uNoteTitles.Shortlist);
  //FastAddStrings(uNoteTitles.ShortList, Dest);  // backed out from v27.27 - CQ #14619 - RV
  if uNoteTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

procedure LoadBoilerPlate(Dest: TStrings; Title: Integer);
{ returns the boilerplate text (if any) for a given progress note title }
begin
  CallV('TIU LOAD BOILERPLATE TEXT', [Title, Patient.DFN, Encounter.VisitStr]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function PrintNameForTitle(TitleIEN: Integer): string;
begin
  Result := sCallV('TIU GET PRINT NAME', [TitleIEN]);
end;

function SubSetOfNoteTitles(const StartFrom: string; Direction: Integer; IDNotesOnly: boolean): TStrings;
{ returns a pointer to a list of progress note titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
  if IDNotesOnly then
    CallV('TIU LONG LIST OF TITLES', [CLS_PROGRESS_NOTES, StartFrom, Direction, IDNotesOnly])
  else
    CallV('TIU LONG LIST OF TITLES', [CLS_PROGRESS_NOTES, StartFrom, Direction]);
  //MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
end;

{ TIU Preferences  ------------------------------------------------------------------------- }

procedure LoadTIUPrefs;
{ private - creates TIUPrefs object for reference throughout the session }
var
  x: string;
begin
  uTIUPrefs := TTIUPrefs.Create;
  with uTIUPrefs do
  begin
    x := sCallV('TIU GET PERSONAL PREFERENCES', [User.DUZ]);
    DfltLoc := StrToIntDef(Piece(x, U, 2), 0);
    DfltLocName := ExternalName(DfltLoc, FN_HOSPITAL_LOCATION);
    SortAscending := Piece(x, U, 4) = 'A';
    SortBy := Piece(x, U, 3);
    AskNoteSubject := Piece(x, U, 8) = '1';
    DfltCosigner := StrToInt64Def(Piece(x, U, 9), 0);
    DfltCosignerName := ExternalName(DfltCosigner, FN_NEW_PERSON);
    MaxNotes := StrToIntDef(Piece(x, U, 10), 0);
    x := sCallV('TIU REQUIRES COSIGNATURE', [TYP_PROGRESS_NOTE, 0, User.DUZ]);
    AskCosigner := Piece(x, U, 1) = '1';
  end;
end;

procedure ResetTIUPreferences;
begin
  if uTIUPrefs <> nil then
    begin
      uTIUPrefs.Free;
      uTIUPrefs := nil;
      LoadTIUPrefs;
    end;
end;

function AskCosignerForDocument(ADocument: Integer; AnAuthor: Int64; ADate: TFMDateTime): Boolean;
begin
  if TIUPatch175Installed then
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [0, ADocument, AnAuthor, ADate]), U, 1) = '1'
  else
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [0, ADocument, AnAuthor]), U, 1) = '1';
end;

function AskCosignerForTitle(ATitle: integer; AnAuthor: Int64; ADate: TFMDateTime): Boolean;
{ returns TRUE if a cosignature is required for a document title and author }
begin
  if TIUPatch175Installed then
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [ATitle, 0, AnAuthor, ADate]), U, 1) = '1'
  else
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [ATitle, 0, AnAuthor]), U, 1) = '1';
end;

function AskCosignerForNotes: Boolean;
{ returns true if cosigner should be asked when creating a new progress note }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.AskCosigner;
end;

function AskSubjectForNotes: Boolean;
{ returns true if subject should be asked when creating a new progress note }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.AskNoteSubject;
end;

function CanCosign(ATitle, ADocType: integer; AUser: Int64; ADate: TFMDateTime): Boolean;
begin
  if ATitle > 0 then ADocType := 0;
  if TIUPatch175Installed and (ADocType = 0) then
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [ATitle, ADocType, AUser, ADate]), U, 1) <> '1'
  else
    Result := Piece(sCallV('TIU REQUIRES COSIGNATURE', [ATitle, ADocType, AUser]), U, 1) <> '1';
end;

procedure DefaultCosigner(var IEN: Int64; var Name: string);
{ returns the IEN (from the New Person file) and Name of this user's default cosigner }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  IEN := uTIUPrefs.DfltCosigner;
  Name := uTIUPrefs.DfltCosignerName;
end;

function ReturnMaxNotes: Integer;
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.MaxNotes;
  if Result = 0 then Result := 100;
end;

function SortNotesAscending: Boolean;
{ returns true if progress notes should be sorted from oldest to newest (chronological) }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.SortAscending;
end;

function DfltTIULocation: Integer;
{ returns the IEN of the user defined default progress note title (if any) }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.DfltLoc;
end;

function DfltTIULocationName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uTIUPrefs = nil then LoadTIUPrefs;
  Result := uTIUPrefs.DfltLocName;
end;

{ Data Retrieval --------------------------------------------------------------------------- }

procedure ActOnDocument(var AuthSts: TActionRec; IEN: Integer; const ActionName: string);
var
  x: string;
begin
  if not (IEN > 0) then
  begin
    AuthSts.Success := True;
    AuthSts.Reason := '';
    Exit;
  end;
  x := sCallV('TIU AUTHORIZATION', [IEN, ActionName]);
  AuthSts.Success := Piece(x, U, 1) = '1';
  AuthSts.Reason  := Piece(x, U, 2);
end;

function AuthorSignedDocument(IEN: Integer): boolean;
begin
  Result := SCallV('TIU HAS AUTHOR SIGNED?', [IEN, User.DUZ]) = '1'; 
end;

function CosignDocument(IEN: Integer): Boolean;
var
  x: string;
begin
  x := sCallV('TIU WHICH SIGNATURE ACTION', [IEN]);
  Result := x = 'COSIGNATURE';
end;

(*function CPTRequiredForNote(IEN: Integer): Boolean;
begin
  If IEN > 0 then
    Result := sCallV('ORWPCE CPTREQD', [IEN]) = '1'
  else
    Result := False;
end;*)

procedure ListConsultRequests(Dest: TStrings);
{ lists outstanding consult requests for a patient: IEN^Request D/T^Service^Procedure }
begin
  CallV('GMRC LIST CONSULT REQUESTS', [Patient.DFN]);
  //MixedCaseList(RPCBrokerV.Results);
  { remove first returned string, it is just a count }
  if RPCBrokerV.Results.Count > 0 then RPCBrokerV.Results.Delete(0);
  SetListFMDateTime('dddddd hh:nn', TStringList(RPCBrokerV.Results), U, 2);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListNotes(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
{ retrieves existing progress notes for a patient according to the parameters passed in
  Pieces: IEN^Title^FMDateOfNote^Patient^Author^Location^Status^Visit
  Return: IEN^ExDateOfNote^Title, Location, Author^ImageCount^Visit }
var
  i: Integer;
  x: string;
  SortSeq: Char;
begin
  if SortAscending then SortSeq := 'A' else SortSeq := 'D';
  //if OccLim = 0 then OccLim := MaxNotesReturned;
  CallV('TIU DOCUMENTS BY CONTEXT',
         [3, Context, Patient.DFN, Early, Late, Person, OccLim, SortSeq]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      x := Piece(x, U, 1) + U + FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3))) +
           U + Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2) +
           U + Piece(x, U, 11) + U + Piece(x, U, 8) + U + Piece(x, U, 3);
      Results[i] := x;
    end; {for}
    FastAssign(RPCBrokerV.Results, Dest);
  end; {with}
end;

procedure ListNotesForTree(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
{ retrieves existing progress notes for a patient according to the parameters passed in
  Pieces: IEN^Title^FMDateOfNote^Patient^Author^Location^Status^Visit
  Return: IEN^ExDateOfNote^Title, Location, Author^ImageCount^Visit }
var
  SortSeq: Char;
const
  SHOW_ADDENDA = True;
begin
  if SortAscending then SortSeq := 'A' else SortSeq := 'D';
  if Context > 0 then
    begin
      CallV('TIU DOCUMENTS BY CONTEXT', [3, Context, Patient.DFN, Early, Late, Person, OccLim, SortSeq, SHOW_ADDENDA]);
      FastAssign(RPCBrokerV.Results, Dest);
    end;
end;


procedure ListDCSumm(Dest: TStrings);
{ returns the list of discharge summaries for a patient - see ListNotes for pieces }
var
  i: Integer;
  x: string;
begin
  CallV('TIU SUMMARIES', [Patient.DFN]);
  with RPCBrokerV do
  begin
    SortByPiece(TStringList(Results), U, 3);     // sort on date/time of summary
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      x := Piece(x, U, 1) + U + FormatFMDateTime('dddddd', MakeFMDateTime(Piece(x, U, 3)))
           + U + Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2);
      Results[i] := x;
    end; {for}
    FastAssign(RPCBrokerV.Results, Dest);
  end; {with}
end;

procedure LoadDocumentText(Dest: TStrings; IEN: Integer);
{ returns the text of a document (progress note, discharge summary, etc.) }
begin
  CallV('TIU GET RECORD TEXT', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadDetailText(Dest: TStrings; IEN: Integer);    //**KCM**
begin
  CallV('TIU DETAILED DISPLAY', [IEN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure GetNoteForEdit(var EditRec: TEditNoteRec; IEN: Integer);
{ retrieves internal/external values for progress note fields & loads them into EditRec
  Fields: Title:.01, RefDate:1301, Author:1204, Cosigner:1208, Subject:1701, Location:1205 }
var
  i, j: Integer;
  //x: string;

  function FindDT(const FieldID: string): TFMDateTime;
  var
    i: Integer;
  begin
    Result := 0;
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 1) = FieldID then
      begin
        Result := MakeFMDateTime(Piece(Results[i], U, 2));
        Break;
      end;
  end;

  function FindExt(const FieldID: string): string;
  var
    i: Integer;
  begin
    Result := '';
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 1) = FieldID then
      begin
        Result := Piece(Results[i], U, 3);
        Break;
      end;
  end;

  function FindInt(const FieldID: string): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 1) = FieldID then
      begin
        Result := StrToIntDef(Piece(Results[i], U, 2), 0);
        Break;
      end;
  end;

  function FindInt64(const FieldID: string): Int64;
  var
    i: Integer;
  begin
    Result := 0;
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 1) = FieldID then
      begin
        Result := StrToInt64Def(Piece(Results[i], U, 2), 0);
        Break;
      end;
  end;

  function FindVal(const FieldID: string): string;
  var
    i: Integer;
  begin
    Result := '';
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 1) = FieldID then
      begin
        Result := Piece(Results[i], U, 2);
        Break;
      end;
  end;

begin
  CallV('TIU LOAD RECORD FOR EDIT', [IEN, '.01;.06;.07;1301;1204;1208;1701;1205;1405;2101;70201;70202']);
  FillChar(EditRec, SizeOf(EditRec), 0);
  with EditRec do
  begin
    Title        := FindInt('.01');
    TitleName    := FindExt('.01');
    DateTime     := FindDT('1301');
    Author       := FindInt64('1204');
    AuthorName   := FindExt('1204');
    Cosigner     := FindInt64('1208');
    CosignerName := FindExt('1208');
    Subject      := FindExt('1701');
    Location     := FindInt('1205');
    LocationName := FindExt('1205');
    IDParent     := FindInt('2101');
    ClinProcSummCode := FindInt('70201');
    ClinProcDateTime := FindDT('70202');
    VisitDate    := FindDT('.07');
    PkgRef       := FindVal('1405');
    PkgIEN       := StrToIntDef(Piece(PkgRef, ';', 1), 0);
    PkgPtr       := Piece(PkgRef, ';', 2);
    if Title = TYP_ADDENDUM then Addend := FindInt('.06');
    with RPCBrokerV do
    begin
      for i := 0 to Results.Count - 1 do if Results[i] = '$TXT' then break;
      for j := i downto 0 do Results.Delete(j);
      // -------------------- v19.1 (RV) LOST NOTES?----------------------------
      //Lines := Results;   'Lines' is being overwritten by subsequent Broker calls
      if not Assigned(Lines) then Lines := TStringList.Create;
      FastAssign(RPCBrokerV.Results, Lines);
      // -----------------------------------------------------------------------
    end;
  end;
end;

function VisitStrForNote(IEN: Integer): string;
begin
  Result := sCallV('ORWPCE NOTEVSTR', [IEN]);
end;

function TitleForNote(IEN: Int64): Integer;
begin
  Result := StrToIntDef(sCallV('TIU GET DOCUMENT TITLE', [IEN]), 3);
//  with RPCBrokerV do
//  begin
//    ClearParameters := True;
//    RemoteProcedure := 'XWB GET VARIABLE VALUE';
//    Param[0].PType := reference;
//    Param[0].Value := '$G(^TIU(8925,' + IntToStr(IEN) + ',0))';
//    CallBroker;
//    Result := StrToIntDef(Piece(Results[0], U, 1), 3);
//  end;
end;

function GetPackageRefForNote(NoteIEN: integer): string;
begin
  Result := sCallV('TIU GET REQUEST', [NoteIEN]);
end;

function GetConsultIENforNote(NoteIEN: integer): Integer;
var
  x: string;
begin
  x := sCallV('TIU GET REQUEST', [NoteIEN]);
  if Piece(x, ';', 2) <> PKG_CONSULTS then
    Result := -1
  else
    Result := StrTOIntDef(Piece(x, ';', 1), -1);
end;

procedure LockDocument(IEN: Int64; var AnErrMsg: string);
var
  x: string;
begin
  x := sCallV('TIU LOCK RECORD', [IEN]);
  if CharAt(x, 1) = '0' then AnErrMsg := '' else AnErrMsg := Piece(x, U, 2);
end;

procedure UnlockDocument(IEN: Int64);
begin
  CallV('TIU UNLOCK RECORD', [IEN]);
end;

function LastSaveClean(IEN: Int64): Boolean;
begin
  Result := sCallV('TIU WAS THIS SAVED?', [IEN]) = '1';
end;

function GetTIUListItem(IEN: Int64): string;
begin
  Result := sCallV('ORWTIU GET LISTBOX ITEM', [IEN]);
end;

{ Data Updates ----------------------------------------------------------------------------- }

(*procedure ClearCPTRequired(IEN: Integer);
{ sets CREDIT STOP CODE ON COMPLETION to NO when no more need to get encounter information }
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;                     
    Param[0].Value := IntToStr(IEN);
    Param[1].PType := list;
    with Param[1] do Mult['.11']  := '0';          //  **** block removed in v19.1  {RV} ****
    CallBroker;
  end;
end;*)

procedure DeleteDocument(var DeleteSts: TActionRec; IEN: Integer; const Reason: string);
{ delete a TIU document given the internal entry number, return reason if unable to delete }
var
  x: string;
begin
  x := sCallV('TIU DELETE RECORD', [IEN, Reason]);
  DeleteSts.Success := Piece(x, U, 1) = '0';
  DeleteSts.Reason  := Piece(x, U, 2);
end;

function JustifyDocumentDelete(IEN: Integer): Boolean;
begin
  Result := sCallV('TIU JUSTIFY DELETE?', [IEN]) = '1';
end;

procedure SignDocument(var SignSts: TActionRec; IEN: Integer; const ESCode: string);
{ update signed status of a TIU document, return reason if signature is not accepted }
var
  x: string;
begin
(*  with RPCBrokerV do                           // temp - to insure sign doesn't go interactive
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;                           
    Param[0].Value := IntToStr(IEN);
    Param[1].PType := list;
    with Param[1] do Mult['.11']  := '0';                 //  **** block removed in v19.1  {RV} ****
    CallBroker;
  end;                                         // temp - end*)
  x := sCallV('TIU SIGN RECORD', [IEN, ESCode]);
  SignSts.Success := Piece(x, U, 1) = '0';
  SignSts.Reason  := Piece(x, U, 2);
end;

procedure PutNewNote(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec);
{ create a new progress note with the data in NoteRec and return its internal entry number
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU CREATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := Patient.DFN;  //*DFN*
    Param[1].PType := literal;
    Param[1].Value := IntToStr(NoteRec.Title);
    Param[2].PType := literal;
    Param[2].Value := ''; //FloatToStr(Encounter.DateTime);
    Param[3].PType := literal;
    Param[3].Value := ''; //IntToStr(Encounter.Location);
    Param[4].PType := literal;
    Param[4].Value := '';
    Param[5].PType := list;
    with Param[5] do
    begin
      //Mult['.11'] := BOOLCHAR[NoteRec.NeedCPT];  //  **** removed in v19.1  {RV} ****
      Mult['1202'] := IntToStr(NoteRec.Author);
      Mult['1301'] := FloatToStr(NoteRec.DateTime);
      Mult['1205'] := IntToStr(Encounter.Location);
      if NoteRec.Cosigner > 0 then Mult['1208'] := IntToStr(NoteRec.Cosigner);
      if NoteRec.PkgRef <> '' then Mult['1405'] := NoteRec.PkgRef;
      Mult['1701'] := FilteredString(Copy(NoteRec.Subject, 1, 80));
      if NoteRec.IDParent > 0 then Mult['2101'] := IntToStr(NoteRec.IDParent);
(*      if NoteRec.Lines <> nil then
        for i := 0 to NoteRec.Lines.Count - 1 do
          Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(NoteRec.Lines[i]);*)
    end;
    Param[6].PType := literal;
    Param[6].Value := Encounter.VisitStr;
    Param[7].PType := literal;
    Param[7].Value := '1';  // suppress commit logic
    CallBroker;
    CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
    CreatedDoc.ErrorText := Piece(Results[0], U, 2);
  end;
  if ( NoteRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
  begin
    SetText(ErrMsg, NoteRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
  end;
end;

procedure PutAddendum(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec; AddendumTo: Integer);
{ create a new addendum for note identified in AddendumTo, returns IEN of new document
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU CREATE ADDENDUM RECORD';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(AddendumTo);
    Param[1].PType := list;
    with Param[1] do
    begin
      Mult['1202'] := IntToStr(NoteRec.Author);
      Mult['1301'] := FloatToStr(NoteRec.DateTime);
      if NoteRec.Cosigner > 0 then Mult['1208'] := IntToStr(NoteRec.Cosigner);
(*      if NoteRec.Lines <> nil then
        for i := 0 to NoteRec.Lines.Count - 1 do
          Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(NoteRec.Lines[i]);*)
    end;
    Param[2].PType := literal;
    Param[2].Value := '1';  // suppress commit logic
    CallBroker;
    CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
    CreatedDoc.ErrorText := Piece(Results[0], U, 2);
  end;
  if ( NoteRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
  begin
    SetText(ErrMsg, NoteRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
  end;
end;

procedure PutEditedNote(var UpdatedDoc: TCreatedDoc; const NoteRec: TNoteRec; NoteIEN: Integer);
{ update the fields and content of the note identified in NoteIEN, returns 1 if successful
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
begin
  // First, file field data
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(NoteIEN);
    Param[1].PType := list;
    with Param[1] do
    begin
      if NoteRec.Addend = 0 then
        begin
          Mult['.01']  := IntToStr(NoteRec.Title);
          //Mult['.11']  := BOOLCHAR[NoteRec.NeedCPT];  //  **** removed in v19.1  {RV} ****
        end;
      Mult['1202'] := IntToStr(NoteRec.Author);
      if NoteRec.Cosigner > 0 then Mult['1208'] := IntToStr(NoteRec.Cosigner);
      if NoteRec.PkgRef <> '' then Mult['1405'] := NoteRec.PkgRef;
      Mult['1301'] := FloatToStr(NoteRec.DateTime);
      Mult['1701'] := FilteredString(Copy(NoteRec.Subject, 1, 80));
      if NoteRec.ClinProcSummCode > 0 then Mult['70201'] := IntToStr(NoteRec.ClinProcSummCode);
      if NoteRec.ClinProcDateTime > 0 then Mult['70202'] := FloatToStr(NoteRec.ClinProcDateTime);
(*      for i := 0 to NoteRec.Lines.Count - 1 do
        Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(NoteRec.Lines[i]);*)
    end;
    CallBroker;
    UpdatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
    UpdatedDoc.ErrorText := Piece(Results[0], U, 2);
  end;

  if UpdatedDoc.IEN <= 0 then              //v22.12 - RV
  //if UpdatedDoc.ErrorText <> '' then    //v22.5 - RV
    begin
      UpdatedDoc.ErrorText := UpdatedDoc.ErrorText + #13#10 + #13#10 + 'Document #:  ' + IntToStr(NoteIEN);
      exit;  
    end;

  // next, if no error, file document body
  SetText(ErrMsg, NoteRec.Lines, NoteIEN, 0);
  if ErrMsg <> '' then
  begin
    UpdatedDoc.IEN := 0;
    UpdatedDoc.ErrorText := ErrMsg;
  end;
end;

procedure PutTextOnly(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64);
var
  i: Integer;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(NoteIEN);
    Param[1].PType := list;
    for i := 0 to Pred(NoteText.Count) do
      Param[1].Mult['"TEXT",' + IntToStr(Succ(i)) + ',0'] := FilteredString(NoteText[i]);
    Param[2].PType := literal;
    Param[2].Value :='1';  // suppress commit code
    CallBroker;
    if Piece(Results[0], U, 1) = '0' then ErrMsg := Piece(Results[0], U, 2) else ErrMsg := '';
  end;
end;

procedure SetText(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64; Suppress: Integer);
const
  DOCUMENT_PAGE_SIZE = 300;
  TX_SERVER_ERROR = 'An error occurred on the server.' ;
var
  i, j, page, pages: Integer;
begin
  // Compute pages, initialize Params
  pages := ( NoteText.Count div DOCUMENT_PAGE_SIZE );
  if (NoteText.Count mod DOCUMENT_PAGE_SIZE) > 0 then pages := pages + 1;
  page := 1;
  InitParams( NoteIEN, Suppress );
  // Loop through NoteRec.Lines
  for i := 0 to NoteText.Count - 1 do
  begin
    j := i + 1;
    //Add each successive line to Param[1].Mult...
    RPCBrokerV.Param[1].Mult['"TEXT",' + IntToStr(j) + ',0'] := FilteredString(NoteText[i]);
    // When current page is filled, call broker, increment page, itialize params,
    // and continue...
    if ( j mod DOCUMENT_PAGE_SIZE ) = 0 then
    begin
      RPCBrokerV.Param[1].Mult['"HDR"'] := IntToStr(page) + U + IntToStr(pages);
      CallBroker;
      if RPCBrokerV.Results.Count > 0 then
        ErrMsg := Piece(RPCBrokerV.Results[0], U, 4)
      else
        ErrMsg := TX_SERVER_ERROR;
      if ErrMsg <> '' then Exit;
      page := page + 1;
      InitParams( NoteIEN, Suppress );
    end; // if
  end;   // for
  // finally, file any remaining partial page
  if ( NoteText.Count mod DOCUMENT_PAGE_SIZE ) <> 0 then
  begin
    RPCBrokerV.Param[1].Mult['"HDR"'] := IntToStr(page) + U + IntToStr(pages);
    CallBroker;
    if RPCBrokerV.Results.Count > 0 then
      ErrMsg := Piece(RPCBrokerV.Results[0], U, 4)
    else
      ErrMsg := TX_SERVER_ERROR;
  end;
end;

procedure InitParams( NoteIEN: Int64; Suppress: Integer );
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU SET DOCUMENT TEXT';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(NoteIEN);
    Param[1].PType := list;
    Param[2].PType := literal;
    Param[2].Value := IntToStr(Suppress);
  end;
end;

{ Printing --------------------------------------------------------------------------------- }

function AllowPrintOfNote(ANote: Integer): string;
{ returns
          0 message Can't print at all (fails bus rules)
          1 Can print work copy only
          2 Can print work or chart copy (Param=1 or user is MAS)
 }
 begin
   Result := sCallV('TIU CAN PRINT WORK/CHART COPY', [ANote]);
 end;

function AllowChartPrintForNote(ANote: Integer): Boolean;
{ returns true if a progress note may be printed outside of MAS }
begin
  Result := (Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [ANote]), U, 9) = '1')
            or (sCallV('TIU AUTHORIZATION', [ANote , 'PRINT RECORD']) = '1');
  //        or (sCallV('TIU USER IS MEMBER OF CLASS', [User.DUZ, 'MEDICAL INFORMATION SECTION']) = '1');
  //         (V16? - RV)  New TIU RPC required, per discussion on NOIS MAR-0900-21265
end;

procedure PrintNoteToDevice(ANote: Integer; const ADevice: string; ChartCopy: Boolean;
  var ErrMsg: string);
{ prints a progress note on the selected device }
begin
  ErrMsg := sCallV('TIU PRINT RECORD', [ANote, ADevice, ChartCopy]);
  if Piece(ErrMsg, U, 1) = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

function GetFormattedNote(ANote: Integer; ChartCopy: Boolean): TStrings;
begin
  CallV('ORWTIU WINPRINT NOTE',[ANote, ChartCopy]);
  Result := RPCBrokerV.Results;
end;

function GetCurrentSigners(IEN: integer): TStrings;
begin
  CallV('TIU GET ADDITIONAL SIGNERS', [IEN]);
  MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results ;
end;

procedure UpdateAdditionalSigners(IEN: integer; Signers: TStrings);
begin
  CallV('TIU UPDATE ADDITIONAL SIGNERS', [IEN, Signers]);
end;

function CanChangeCosigner(IEN: integer): boolean;
begin
  Result := Piece(sCallV('TIU CAN CHANGE COSIGNER?', [IEN]), U, 1) = '1';
end;

procedure ChangeCosigner(IEN: integer; Cosigner: int64);
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(IEN);
    Param[1].PType := list;
    with Param[1] do
      if Cosigner > 0 then
        Mult['1208']  := IntToStr(Cosigner)
      else
        Mult['1208']  := '@';
    CallBroker;
  end;
end;

// Determine if given note title is allowed more than once per visit.    12/2002-GRE
function OneNotePerVisit(NoteEIN: Integer; DFN: String; VisitStr: String):boolean;
var x: string;
begin
    x := sCallV('TIU ONE VISIT NOTE?', [IntToStr(NoteEIN),DFN,VisitStr]);
    if StrToInt(x) > 0 then
       Result := True  //Only one per visit
    else
       Result := False;
end;

function GetCurrentTIUContext: TTIUContext;
var
  x: string;
  AContext: TTIUContext;
begin
  x := sCallV('ORWTIU GET TIU CONTEXT', [User.DUZ]) ;
  with AContext do
    begin
      Changed       := True;
      BeginDate     := Piece(x, ';', 1);
      FMBeginDate   := StrToFMDateTime(BeginDate);
      EndDate       := Piece(x, ';', 2);
      FMEndDate     := StrToFMDateTime(EndDate);
      Status        := Piece(x, ';', 3);
      if (StrToIntDef(Status, 0) < 1) or (StrToIntDef(Status, 0) > 5) then Status := '1';
      Author        := StrToInt64Def(Piece(x, ';', 4), 0);
      MaxDocs       := StrToIntDef(Piece(x, ';', 5), 0);
      ShowSubject   := StrToIntDef(Piece(x, ';', 6), 0) > 0;   //TIU PREFERENCE??
      SortBy        := Piece(x, ';', 7);                       //TIU PREFERENCE??
      ListAscending := StrToIntDef(Piece(x, ';', 8), 0) > 0;
      TreeAscending := StrToIntDef(Piece(x, ';', 9), 0) > 0;   //TIU PREFERENCE??
      GroupBy       := Piece(x, ';', 10);
      SearchField   := Piece(x, ';', 11);
      KeyWord       := Piece(x, ';', 12);
      Filtered      := (Keyword <> '');
    end;
  Result := AContext;
end;

procedure SaveCurrentTIUContext(AContext: TTIUContext) ;
var
  x: string;
begin
  with AContext do
    begin
      SetPiece(x, ';', 1, BeginDate);
      SetPiece(x, ';', 2, EndDate);
      SetPiece(x, ';', 3, Status);
      if Author > 0 then
        SetPiece(x, ';', 4, IntToStr(Author))
      else
        SetPiece(x, ';', 4, '');
      SetPiece(x, ';', 5, IntToStr(MaxDocs));
      SetPiece(x, ';', 6, BOOLCHAR[ShowSubject]);       //TIU PREFERENCE??
      SetPiece(x, ';', 7, SortBy);                      //TIU PREFERENCE??
      SetPiece(x, ';', 8, BOOLCHAR[ListAscending]);
      SetPiece(x, ';', 9, BOOLCHAR[TreeAscending]);     //TIU PREFERENCE??
      SetPiece(x, ';', 10, GroupBy);
      SetPiece(x, ';', 11, SearchField);
      SetPiece(x, ';', 12, KeyWord);
    end;
  CallV('ORWTIU SAVE TIU CONTEXT', [x]);
end;

function TIUSiteParams: string;
begin
  if(not uTIUSiteParamsLoaded) then
  begin
    uTIUSiteParams := sCallV('TIU GET SITE PARAMETERS', []) ;
    uTIUSiteParamsLoaded := TRUE;
  end;
  Result := uTIUSiteParams;
end;

//  ===================Interdisciplinary Notes RPCs =====================

function IDNotesInstalled: boolean;
begin
  Result := True;   // old patch check no longer called
end;

function CanTitleBeIDChild(Title: integer; var WhyNot: string): boolean;
var
  x: string;
begin
  Result := False;
  x := sCallV('ORWTIU CANLINK', [Title]);
  if Piece(x, U, 1) = '1' then
    Result := True
  else if Piece(x, U, 1) = '0' then
    begin
      Result := False;
      WhyNot := Piece(x, U, 2);
    end;
end;

function CanBeAttached(DocID: string; var WhyNot: string): boolean;
var
  x: string;
const
  TX_NO_ATTACH = 'This note appears to be an interdisciplinary parent.  Please drag the child note you wish to ' + CRLF +
                 'attach instead of attempting to drag the parent, or check with IRM or your' + CRLF +
                 'clinical coordinator.';
begin
  Result := False;
  if StrToIntDef(DocID, 0) = 0 then exit;
  x := sCallV('TIU ID CAN ATTACH', [DocID]);
  if Piece(x, U, 1) = '1' then
    Result := True
  else if Piece(x, U, 1) = '0' then
    begin
      Result := False;
      WhyNot := Piece(x, U, 2);
    end
  else if Piece(x, U, 1) = '-1' then
    begin
      Result := False;
      WhyNot := TX_NO_ATTACH;
    end;
end;

function CanReceiveAttachment(DocID: string; var WhyNot: string): boolean;
var
  x: string;
begin
  x := sCallV('TIU ID CAN RECEIVE', [DocID]);
  if Piece(x, U, 1) = '1' then
    Result := True
  else
    begin
      Result := False;
      WhyNot := Piece(x, U, 2);
    end;
end;

function AttachEntryToParent(DocID, ParentDocID: string; var WhyNot: string): boolean;
var
  x: string;
begin
  x := sCallV('TIU ID ATTACH ENTRY', [DocID, ParentDocID]);
  if StrToIntDef(Piece(x, U, 1), 0) > 0 then
    Result := True
  else
    begin
      Result := False;
      WhyNot := Piece(x, U, 2);
    end;
end;

function DetachEntryFromParent(DocID: string; var WhyNot: string): boolean;
var
  x: string;
begin
  x := sCallV('TIU ID DETACH ENTRY', [DocID]);
  if StrToIntDef(Piece(x, U, 1), 0) > 0 then
    Result := True
  else
    begin
      Result := False;
      WhyNot := Piece(x, U, 2);
    end;
end;

function SubSetOfUserClasses(const StartFrom: string; Direction: Integer): TStrings;
begin
  CallV('TIU USER CLASS LONG LIST', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function UserDivClassInfo(User: Int64): TStrings;
begin
  CallV('TIU DIV AND CLASS INFO', [User]);
  Result := RPCBrokerV.Results;
end;

function UserInactive(EIN: String): boolean;
var x: string;
begin
   x:= sCallv('TIU USER INACTIVE?', [EIN]) ;
   if (StrToInt(x) > 0) then
    Result := True
  else
     Result := False;
end;

function TIUPatch175Installed: boolean;
begin
  with uPatch175Installed do
    if not PatchChecked then
      begin
        PatchInstalled := ServerHasPatch('TIU*1.0*175');
        PatchChecked := True;
      end;
  Result := uPatch175Installed.PatchInstalled;
end;

function NoteHasText(NoteIEN: integer): boolean;
begin
  Result := (StrToIntDef(sCallV('ORWTIU CHKTXT', [NoteIEN]), 0) > 0);
end;


initialization
  // nothing for now

finalization
  if uNoteTitles <> nil then uNoteTitles.Free;
  if uTIUPrefs <> nil then uTIUPrefs.Free;

end.

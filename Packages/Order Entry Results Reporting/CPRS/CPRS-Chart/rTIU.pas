unit rTIU;

{ ------------------------------------------------------------------------------
  Update History
  2016-06-28: NSR#20070817 (CPRS Progress Notes Display Misleading)
  ------------------------------------------------------------------------------- }
interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, uConst, TRPCB, uTIU, Dialogs,
  UITypes;

type
  TPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;

  { Progress Note Titles }
function DfltNoteTitle: Integer;
function DfltNoteTitleName: string;
procedure ResetNoteTitles;
function IsConsultTitle(TitleIEN: Integer): boolean;
function IsPRFTitle(TitleIEN: Integer): boolean;
function IsClinProcTitle(TitleIEN: Integer): boolean;
procedure ListNoteTitlesShort(Dest: TStrings);
procedure LoadBoilerPlate(Dest: TStrings; Title: Integer; VisitStr: string);
function PrintNameForTitle(TitleIEN: Integer): string;
function SubSetOfNoteTitles(aResults: TStrings; const StartFrom: string;
  Direction: Integer; IDNotesOnly: boolean): Integer;

{ TIU Preferences }
procedure ResetTIUPreferences;
function AskCosignerForNotes: boolean;
function AskCosignerForDocument(ADocument: Integer; AnAuthor: Int64;
  ADate: TFMDateTime): boolean;
function AskCosignerForTitle(ATitle: Integer; AnAuthor: Int64;
  ADate: TFMDateTime): boolean;
function AskSubjectForNotes: boolean;
function CanCosign(ATitle, ADocType: Integer; AUser: Int64;
  ADate: TFMDateTime): boolean;
function CanChangeCosigner(IEN: Integer): boolean;
procedure DefaultCosigner(var IEN: Int64; var Name: string);
function ReturnMaxNotes: Integer;
function SortNotesAscending: boolean;
function GetCurrentTIUContext: TTIUContext;
procedure SaveCurrentTIUContext(AContext: TTIUContext);
function TIUSiteParams: string;
function DfltTIULocation: Integer;
function DfltTIULocationName: string;

{ Data Retrieval }
procedure ActOnDocument(var AuthSts: TActionRec; IEN: Integer;
  const ActionName: string);
function AuthorSignedDocument(IEN: Integer): boolean;
function CosignDocument(IEN: Integer): boolean;
function NeedToSignDocument(IEN: integer): boolean;
// function CPTRequiredForNote(IEN: Integer): Boolean;
// procedure ListNotes(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
// Person: int64; OccLim: Integer; SortAscending: Boolean);
function ListNotesForTree(Dest: TStrings; Context: Integer;
  Early, Late: TFMDateTime; Person: Int64; OccLim: Integer;
  SortAscending: boolean; MRFlag: Integer; IEN: String): String;
procedure ListConsultRequests(Dest: TStrings);
//procedure ListDCSumm(Dest: TStrings);
procedure LoadDetailText(Dest: TStrings; IEN: Integer); // **KCM**
procedure LoadDocumentText(Dest: TStrings; IEN: Integer);
procedure GetNoteForEdit(var EditRec: TEditNoteRec; IEN: Integer);
procedure GetNoteEditTextOnly(ResultList: TStrings; IEN: Integer);
function VisitStrForNote(IEN: Integer): string;
function setCurrentSigners(aDest:TStrings;IEN: Integer): Integer;
function TitleForNote(IEN: Int64): Integer;
function GetConsultIENforNote(NoteIEN: Integer): Integer;
function GetPackageRefForNote(NoteIEN: Integer): string;
procedure LockDocument(IEN: Int64; var AnErrMsg: string);
procedure UnlockDocument(IEN: Int64);
function LastSaveClean(IEN: Int64): boolean;
function NoteHasText(NoteIEN: Integer): boolean;
function GetTIUListItem(IEN: Int64): string;

{ Data Storage }
// procedure ClearCPTRequired(IEN: Integer);
procedure DeleteDocument(var DeleteSts: TActionRec; IEN: Integer;
  const Reason: string);
function AncillaryPackageMessages(IEN: Integer; const Action: string): string;
function JustifyDocumentDelete(IEN: Integer): boolean;
procedure SignDocument(var SignSts: TActionRec; IEN: Integer;
  const ESCode: string);
procedure PutNewNote(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec);
procedure PutAddendum(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec;
  AddendumTo: Integer);
procedure PutEditedNote(var UpdatedDoc: TCreatedDoc; const NoteRec: TNoteRec;
  NoteIEN: Integer);
procedure PutTextOnly(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64);
procedure SetText(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64;
  Suppress: Integer);
procedure UpdateAdditionalSigners(IEN: Integer; Signers: TStrings);
procedure ChangeCosigner(IEN: Integer; Cosigner: Int64);

{ Printing }
function AllowPrintOfNote(ANote: Integer): string;
function AllowChartPrintForNote(ANote: Integer): boolean;
procedure PrintNoteToDevice(ANote: Integer; const ADevice: string;
  ChartCopy: boolean; var ErrMsg: string);
function GetFormattedNote(aDest:TStrings;ANote: Integer; ChartCopy: boolean): Integer;

// Interdisciplinary Notes
function IDNotesInstalled: boolean;
function CanTitleBeIDChild(Title: Integer; var WhyNot: string): boolean;
function CanReceiveAttachment(DocID: string; var WhyNot: string): boolean;
function CanBeAttached(DocID: string; var WhyNot: string): boolean;
function DetachEntryFromParent(DocID: string; var WhyNot: string): boolean;
function AttachEntryToParent(DocID, ParentDocID: string;
  var WhyNot: string): boolean;
function OneNotePerVisit(NoteEIN: Integer; DFN: String;
  VisitStr: String): boolean;

// User Classes
function setSubSetOfUserClasses(aDest: TStrings;const StartFrom: string; Direction: Integer)
  : Integer;
function setUserDivClassInfo(aDest:TStrings;User: Int64): Integer;
function UserInactive(EIN: String): boolean;

// Miscellaneous
function TIUPatch175Installed: boolean;

const
  CLS_PROGRESS_NOTES = 3;

implementation

uses rMisc, ORNetIntf;

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
  Results: TStrings;
  x: string;
begin
  if uNoteTitles <> nil then
    Exit;
  Results := TSTringList.Create;
  try
    CallVistA('TIU PERSONAL TITLE LIST',
      [User.DUZ, CLS_PROGRESS_NOTES], Results);
    Results.Insert(0, '~SHORT LIST');
    // insert so can call ExtractItems
    uNoteTitles := TNoteTitles.Create;
    ExtractItems(uNoteTitles.ShortList, { RPCBrokerV. } Results, 'SHORT LIST');
    x := ExtractDefault( { RPCBrokerV. } Results, 'SHORT LIST');
    uNoteTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
    uNoteTitles.DfltTitleName := Piece(x, U, 2);
  finally
    Results.Free;
  end;
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
  if uNoteTitles = nil then
    LoadNoteTitles;
  Result := uNoteTitles.DfltTitle;
end;

function DfltNoteTitleName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uNoteTitles = nil then
    LoadNoteTitles;
  Result := uNoteTitles.DfltTitleName;
end;

function IsConsultTitle(TitleIEN: Integer): boolean;
var
  x: String;
begin
  Result := FALSE;
  if TitleIEN <= 0 then
    Exit;
  Result := CallVistA('TIU IS THIS A CONSULT?', [TitleIEN], x) and (x = '1');
end;

function IsPRFTitle(TitleIEN: Integer): boolean;
var
  x: String;
begin
  Result := FALSE;
  if TitleIEN <= 0 then
    Exit;
  Result := CallVistA('TIU ISPRF', [TitleIEN], x) and (x = '1');
end;

function IsClinProcTitle(TitleIEN: Integer): boolean;
var
  x: String;
begin
  Result := FALSE;
  if TitleIEN <= 0 then
    Exit;
  Result := CallVistA('TIU IS THIS A CLINPROC?', [TitleIEN], x) and (x = '1');
end;

procedure ListNoteTitlesShort(Dest: TStrings);
{ returns the user defined list (short list) of progress note titles }
begin
  if uNoteTitles = nil then
    LoadNoteTitles;
  Dest.AddStrings(uNoteTitles.ShortList);
  // FastAddStrings(uNoteTitles.ShortList, Dest);  // backed out from v27.27 - CQ #14619 - RV
  if uNoteTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

procedure LoadBoilerPlate(Dest: TStrings; Title: Integer; VisitStr: string);
{ returns the boilerplate text (if any) for a given progress note title }
begin
  CallVistA('TIU LOAD BOILERPLATE TEXT', [Title, Patient.DFN, VisitStr], Dest);
end;

function PrintNameForTitle(TitleIEN: Integer): string;
begin
  CallVistA('TIU GET PRINT NAME', [TitleIEN], Result);
end;

function SubSetOfNoteTitles(aResults: TStrings; const StartFrom: string;
  Direction: Integer; IDNotesOnly: boolean): Integer;
{ returns a pointer to a list of progress note titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
  if IDNotesOnly then
    CallVistA('TIU LONG LIST OF TITLES', [CLS_PROGRESS_NOTES, StartFrom,
      Direction, IDNotesOnly], aResults)
  else
    CallVistA('TIU LONG LIST OF TITLES', [CLS_PROGRESS_NOTES, StartFrom,
      Direction], aResults);
  Result := aResults.Count;
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
    CallVistA('TIU GET PERSONAL PREFERENCES', [User.DUZ], x);
    DfltLoc := StrToIntDef(Piece(x, U, 2), 0);
    DfltLocName := ExternalName(DfltLoc, FN_HOSPITAL_LOCATION);
    SortAscending := Piece(x, U, 4) = 'A';
    SortBy := Piece(x, U, 3);
    AskNoteSubject := Piece(x, U, 8) = '1';
    DfltCosigner := StrToInt64Def(Piece(x, U, 9), 0);
    DfltCosignerName := ExternalName(DfltCosigner, FN_NEW_PERSON);
    MaxNotes := StrToIntDef(Piece(x, U, 10), 0);
    CallVistA('TIU REQUIRES COSIGNATURE', [TYP_PROGRESS_NOTE, 0, User.DUZ], x);
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

function AskCosignerForDocument(ADocument: Integer; AnAuthor: Int64;
  ADate: TFMDateTime): boolean;
var
  x: String;
begin
  if TIUPatch175Installed then
    Result := CallVistA('TIU REQUIRES COSIGNATURE',
      [0, ADocument, AnAuthor, ADate], x)
  else
    Result := CallVistA('TIU REQUIRES COSIGNATURE',
      [0, ADocument, AnAuthor], x);

  Result := Result and (Piece(x, U, 1) = '1');

end;

function AskCosignerForTitle(ATitle: Integer; AnAuthor: Int64;
  ADate: TFMDateTime): boolean;
{ returns TRUE if a cosignature is required for a document title and author }
var
  x: String;
begin
  if TIUPatch175Installed then
    Result := CallVistA('TIU REQUIRES COSIGNATURE',
      [ATitle, 0, AnAuthor, ADate], x)
  else
    Result := CallVistA('TIU REQUIRES COSIGNATURE', [ATitle, 0, AnAuthor], x);

  Result := Result and (Piece(x, U, 1) = '1');

end;

function AskCosignerForNotes: boolean;
{ returns true if cosigner should be asked when creating a new progress note }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.AskCosigner;
end;

function AskSubjectForNotes: boolean;
{ returns true if subject should be asked when creating a new progress note }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.AskNoteSubject;
end;

function CanCosign(ATitle, ADocType: Integer; AUser: Int64;
  ADate: TFMDateTime): boolean;
var
  x: String;
begin
  if ATitle > 0 then
    ADocType := 0;
  if TIUPatch175Installed and (ADocType = 0) then
    Result := CallVistA('TIU REQUIRES COSIGNATURE',
      [ATitle, ADocType, AUser, ADate], x)
  else
    Result := CallVistA('TIU REQUIRES COSIGNATURE',
      [ATitle, ADocType, AUser], x);

  Result := Result and (Piece(x, U, 1) <> '1');

end;

procedure DefaultCosigner(var IEN: Int64; var Name: string);
{ returns the IEN (from the New Person file) and Name of this user's default cosigner }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  IEN := uTIUPrefs.DfltCosigner;
  Name := uTIUPrefs.DfltCosignerName;
end;

function ReturnMaxNotes: Integer;
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.MaxNotes;
  if Result = 0 then
    Result := 100;
end;

function SortNotesAscending: boolean;
{ returns true if progress notes should be sorted from oldest to newest (chronological) }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.SortAscending;
end;

function DfltTIULocation: Integer;
{ returns the IEN of the user defined default progress note title (if any) }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.DfltLoc;
end;

function DfltTIULocationName: string;
{ returns the name of the user defined default progress note title (if any) }
begin
  if uTIUPrefs = nil then
    LoadTIUPrefs;
  Result := uTIUPrefs.DfltLocName;
end;

{ Data Retrieval --------------------------------------------------------------------------- }

procedure ActOnDocument(var AuthSts: TActionRec; IEN: Integer;
  const ActionName: string);
var
  x: string;
begin
  if not(IEN > 0) then
  begin
    AuthSts.Success := True;
    AuthSts.Reason := '';
    Exit;
  end;
  CallVistA('TIU AUTHORIZATION', [IEN, ActionName], x);
  AuthSts.Success := Piece(x, U, 1) = '1';
  AuthSts.Reason := Piece(x, U, 2);
end;

function AuthorSignedDocument(IEN: Integer): boolean;
var
  x: string;
begin
  Result := CallVistA('TIU HAS AUTHOR SIGNED?', [IEN, User.DUZ], x) and
    (x = '1');
end;

function CosignDocument(IEN: Integer): boolean;
var
  x: string;
begin
  CallVistA('TIU WHICH SIGNATURE ACTION', [IEN], x);
  Result := x = 'COSIGNATURE';
end;

function NeedToSignDocument(IEN: integer): boolean;
var
  x: string;
begin
  Result := CallVistA('TIU NEED TO SIGN?', [IEN], x) and (x = '1');
end;

(* function CPTRequiredForNote(IEN: Integer): Boolean;
  begin
  If IEN > 0 then
  Result := sCallV('ORWPCE CPTREQD', [IEN]) = '1'
  else
  Result := False;
  end; *)

procedure ListConsultRequests(Dest: TStrings);
{ lists outstanding consult requests for a patient: IEN^Request D/T^Service^Procedure }
begin
  CallVistA('GMRC LIST CONSULT REQUESTS', [Patient.DFN], Dest);
  // MixedCaseList(RPCBrokerV.Results);
  { remove first returned string, it is just a count }
  if Dest.Count > 0 then
    Dest.Delete(0);
//  SetListFMDateTime('mmm dd,yy hh:nn', TSTringList(Dest), U, 2);
  SetListFMDateTime('mmm dd,yy hh:nn', Dest, U, 2);
end;

(*
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
  x := Piece(x, U, 1) + U + FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3))) +
  U + Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2) +
  U + Piece(x, U, 11) + U + Piece(x, U, 8) + U + Piece(x, U, 3);
  Results[i] := x;
  end; {for}
  FastAssign(RPCBrokerV.Results, Dest);
  end; {with}
  end;
*)
function ListNotesForTree(Dest: TStrings; Context: Integer;
  Early, Late: TFMDateTime; Person: Int64; OccLim: Integer;
  SortAscending: boolean; MRFlag: Integer; IEN: String): String;
{ retrieves existing progress notes for a patient according to the parameters passed in
  Pieces: IEN^Title^FMDateOfNote^Patient^Author^Location^Status^Visit
  Return: IEN^ExDateOfNote^Title, Location, Author^ImageCount^Visit }
var
  SortSeq: Char;
  i: Integer;
const
  SHOW_ADDENDA = True;
begin
  Result := '';
  if SortAscending then
    SortSeq := 'A'
  else
    SortSeq := 'D';
  if Context > 0 then
  begin
    CallVistA('TIU DOCUMENTS BY CONTEXT', [3, Context, Patient.DFN, Early, Late,
      Person, OccLim, SortSeq, SHOW_ADDENDA, 0, MRFlag, String(IEN)], Dest);
    if Dest.Count > 0 then // NSR 20070817
    begin
      i := 0;
      while i < Dest.Count do
      begin
        if trim(Dest[i]) = '' then
          Dest.Delete(i)
        else
        begin
          if AnsiPos(TX_MORE, Dest[i]) > 0 then
            Result := Piece(Dest[i], U, 1);
          inc(i);
        end;
      end;
    end;
  end;
end;
(*
procedure ListDCSumm(Dest: TStrings);
{ returns the list of discharge summaries for a patient - see ListNotes for pieces }
var
  i: Integer;
  x: string;
begin
  // RTC 272867 CallV('TIU SUMMARIES', [Patient.DFN]);
  CallVistA('TIU SUMMARIES', [Patient.DFN], Dest);
  // with RPCBrokerV do
  begin
    SortByPiece(TSTringList(Dest), U, 3); // sort on date/time of summary
    for i := 0 to Dest.Count - 1 do
    begin
      x := Dest[i];
      x := Piece(x, U, 1) + U + FormatFMDateTime('mmm dd,yy',
        MakeFMDateTime(Piece(x, U, 3))) + U + Piece(x, U, 2) + ', ' +
        Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2);
      Dest[i] := x;
    end; { for }
    // RTC 272867 FastAssign(RPCBrokerV.Results, Dest);
  end; { with }
end;
*)
procedure LoadDocumentText(Dest: TStrings; IEN: Integer);
{ returns the text of a document (progress note, discharge summary, etc.) }
begin
  CallVistA('TIU GET RECORD TEXT', [IEN], Dest);
end;

procedure LoadDetailText(Dest: TStrings; IEN: Integer); // **KCM**
begin
  CallVistA('TIU DETAILED DISPLAY', [IEN], Dest);
end;

procedure GetNoteForEdit(var EditRec: TEditNoteRec; IEN: Integer);
{ retrieves internal/external values for progress note fields & loads them into EditRec
  Fields: Title:.01, RefDate:1301, Author:1204, Cosigner:1208, Subject:1701, Location:1205 }
var
  i, TxtIndx: Integer;
  sl: TSTrings;

begin
  sl := TSTringList.Create;
  try
    if CallVistA('TIU LOAD RECORD FOR EDIT',
      [IEN, '.01;.06;.07;1301;1204;1208;1701;1205;1405;2101;70201;70202'], sl)
    then
    begin
      FillChar(EditRec, SizeOf(EditRec), 0);
      with EditRec do
      begin
        Title :=        FindInt(sl,'.01',2);  //FindInt('.01');
        TitleName :=    FindExt(sl,'.01',3);  //FindExt('.01');
        DateTime :=     FindDT(sl,'1301',2);  //FindDT('1301');
        Author :=       FindInt64(sl,'1204',2);//FindInt64('1204');
        AuthorName :=   FindExt(sl,'1204',3);//FindExt('1204');
        Cosigner :=     FindInt64(sl,'1208',2);//FindInt64('1208');
        CosignerName := FindExt(sl,'1208',3);//FindExt('1208');
        Subject :=      FindExt(sl,'1701',3);//FindExt('1701');
        Location :=     FindInt(sl,'1205',2);//FindInt('1205');
        LocationName := FindExt(sl,'1205',3);//FindExt('1205');
        IDParent :=     FindInt(sl,'2101',2);//;FindInt('2101');
        ClinProcSummCode := FindInt(sl,'70201',2);//FindInt('70201');
        ClinProcDateTime := FindDT(sl,'70202',2);//FindDT('70202');
        VisitDate :=    FindDT(sl,'.07',2);//FindDT('.07');
        PkgRef :=       FindVal(sl,'1405',2);//FindVal('1405');
        PkgIEN := StrToIntDef(Piece(PkgRef, ';', 1), 0);
        PkgPtr := Piece(PkgRef, ';', 2);
        if Title = TYP_ADDENDUM then
          Addend := FindInt(sl,'.06',2);//FindInt('.06');

        begin
          // -------------------- v19.1 (RV) LOST NOTES?----------------------------
          // Lines := Results;   'Lines' is being overwritten by subsequent Broker calls
          if not Assigned(Lines) then
            Lines := TSTringList.Create;
          // load the text if present
          TxtIndx := {Results}sl.IndexOf('$TXT');
          if TxtIndx > 0 then
          begin
            for i := TxtIndx + 1 to sl.Count - 1 do
              Lines.Add(sl[i]);
          end;

          // -----------------------------------------------------------------------
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure GetNoteEditTextOnly(ResultList: TStrings; IEN: Integer);
var
  RtnLst: TSTringList;
begin
  RtnLst := TSTringList.Create;
  try
    CallVistA('TIU LOAD RECORD TEXT', [IEN], RtnLst);

    if RtnLst.Count > 0 then
    begin
      if RtnLst[0] = '$TXT' then
      begin

        // Remove the indicator
        RtnLst.Delete(0);

        // assign the remaining
        ResultList.Assign(RtnLst);

      end;
    end;

  finally
    RtnLst.Free;
  end;
end;

function VisitStrForNote(IEN: Integer): string;
begin
  CallVistA('ORWPCE NOTEVSTR', [IEN], Result);
end;

function TitleForNote(IEN: Int64): Integer;
begin
  CallVistA('TIU GET DOCUMENT TITLE', [IEN], Result, 3);
end;

function GetPackageRefForNote(NoteIEN: Integer): string;
begin
  CallVistA('TIU GET REQUEST', [NoteIEN], Result);
end;

function GetConsultIENforNote(NoteIEN: Integer): Integer;
var
  x: string;
begin
  if CallVistA('TIU GET REQUEST', [NoteIEN], x) then
    begin
    if Piece(x, ';', 2) <> PKG_CONSULTS then
      Result := -1
    else
      Result := StrToIntDef(Piece(x, ';', 1), -1)
    end
  else
    Result := -1;
end;

procedure LockDocument(IEN: Int64; var AnErrMsg: string);
var
  x: string;
begin
  CallVistA('TIU LOCK RECORD', [IEN], x);
  if CharAt(x, 1) = '0' then
    AnErrMsg := ''
  else
    AnErrMsg := Piece(x, U, 2);
end;

procedure UnlockDocument(IEN: Int64);
begin
  CallVistA('TIU UNLOCK RECORD', [IEN]);
end;

function LastSaveClean(IEN: Int64): boolean;
var
  x: String;
begin
  Result := CallVistA('TIU WAS THIS SAVED?', [IEN], x) and (x = '1');
end;

function GetTIUListItem(IEN: Int64): string;
begin
  CallVistA('ORWTIU GET LISTBOX ITEM', [IEN], Result);
end;

{ Data Updates ----------------------------------------------------------------------------- }

(* procedure ClearCPTRequired(IEN: Integer);
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
  end; *)

procedure DeleteDocument(var DeleteSts: TActionRec; IEN: Integer;
  const Reason: string);
{ delete a TIU document given the internal entry number, return reason if unable to delete }
var
  Return: TStrings;
begin
  Return := TSTringList.Create;
  CallVistA('TIU DELETE RECORD', [IEN, Reason], Return);
  if (Return.Count > 0) then
  begin
    DeleteSts.Success := Piece(Return.Strings[0], U, 1) = '0';
    DeleteSts.Reason := Piece(Return.Strings[0], U, 2);
  end
  else
  begin
    DeleteSts.Success := FALSE;
    DeleteSts.Reason := 'The server did not return a status.';
  end;
  Return.Destroy;
end;

function AncillaryPackageMessages(IEN: Integer; const Action: string): string;
var
  Return: TStrings;
  Line: Integer;
begin
  Return := TSTringList.Create;
  CallVistA('TIU ANCILLARY PACKAGE MESSAGE', [IEN, Action], Return);
  Result := '';
  if (Return.Count > 0) then
  begin
    for Line := 0 to Return.Count - 1 do
    begin
      if (Piece(Return.Strings[Line], U, 1) = '~NPKG') then
      begin
        Result := Result + CRLF + CRLF + Piece(Return.Strings[Line], U, 2);
      end
      else
      begin
        Result := Result + ' ' + Return.Strings[Line];
      end;
    end;
  end;
  Return.Destroy;
end;

function JustifyDocumentDelete(IEN: Integer): boolean;
var
  x: String;
begin
  Result := CallVistA('TIU JUSTIFY DELETE?', [IEN], x) and (x = '1');
end;

procedure SignDocument(var SignSts: TActionRec; IEN: Integer;
  const ESCode: string);
{ update signed status of a TIU document, return reason if signature is not accepted }
var
  x: string;
begin
  CallVistA('TIU SIGN RECORD', [IEN, ESCode], x);
  SignSts.Success := Piece(x, U, 1) = '0';
  SignSts.Reason := Piece(x, U, 2);
end;

procedure PutNewNote(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec);
{ create a new progress note with the data in NoteRec and return its internal entry number
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
var
  ErrMsg: string;
  aList: iORNetMult;
  Results: TStrings;
begin
  neworNetMult(aList);
  aList.AddSubscript(['1202'], NoteRec.Author);
  aList.AddSubscript(['1301'], NoteRec.DateTime);
  aList.AddSubscript(['1205'], Encounter.Location);
  if NoteRec.Cosigner > 0 then
    aList.AddSubscript(['1208'], NoteRec.Cosigner);
  if NoteRec.PkgRef <> '' then
    aList.AddSubscript(['1405'], NoteRec.PkgRef);
  aList.AddSubscript(['1701'], FilteredString(Copy(NoteRec.Subject, 1, 80)));
  if NoteRec.IDParent > 0 then
    aList.AddSubscript(['2101'], NoteRec.IDParent);

  Results := TSTringList.Create;
  try
    // Do NOT set CallVistA's RequireResults parameter to True or it could
    // create multiple blank documents.
    CallVistA('TIU CREATE RECORD', [Patient.DFN, IntToStr(NoteRec.Title), '',
      '', '', aList, Encounter.VisitStr, '1'], Results);
    if Results.Count > 0 then
    begin
      CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
      CreatedDoc.ErrorText := Piece(Results[0], U, 2);
    end
    else
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := '';
    end;
  finally
    Results.Free;
  end;
  
  if (NoteRec.Lines <> nil) and (CreatedDoc.IEN <> 0) then
  begin
    SetText(ErrMsg, NoteRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
  end;
end;

procedure PutAddendum(var CreatedDoc: TCreatedDoc; const NoteRec: TNoteRec;
  AddendumTo: Integer);
{ create a new addendum for note identified in AddendumTo, returns IEN of new document
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
var
  aList: iORNetMult;
  Results: TStrings;
  ErrMsg: string;
begin
  neworNetMult(aList);
  aList.AddSubscript(['1202'], NoteRec.Author);
  aList.AddSubscript(['1301'], NoteRec.DateTime);
  if NoteRec.Cosigner > 0 then
    aList.AddSubscript(['1208'], NoteRec.Cosigner);
  Results := TStringList.Create;
  try
    // Do NOT set CallVistA's RequireResults parameter to True or it could
    // create multiple blank addenda.
    CallVistA('TIU CREATE ADDENDUM RECORD', [AddendumTo, aList, '1'], Results);
    if Results.Count > 0 then
    begin
      CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
      CreatedDoc.ErrorText := Piece(Results[0], U, 2);
    end
    else
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := '';
    end;
  finally
    Results.Free;
  end;
  if (NoteRec.Lines <> nil) and (CreatedDoc.IEN <> 0) then
  begin
    SetText(ErrMsg, NoteRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
  end;
end;

procedure PutEditedNote(var UpdatedDoc: TCreatedDoc; const NoteRec: TNoteRec;
  NoteIEN: Integer);
{ update the fields and content of the note identified in NoteIEN, returns 1 if successful
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
var
  ErrMsg: string;
  aList: iORNetMult;
  Results: TStrings;
begin
  // First, file field data
  neworNetMult(aList);
  if NoteRec.Addend = 0 then
    aList.AddSubscript(['.01'], NoteRec.Title);

  aList.AddSubscript(['1202'], NoteRec.Author);
  if NoteRec.Cosigner > 0 then
    aList.AddSubscript(['1208'], NoteRec.Cosigner);
  if NoteRec.PkgRef <> '' then
    aList.AddSubscript(['1405'], NoteRec.PkgRef);
  aList.AddSubscript(['1301'], NoteRec.DateTime);
  aList.AddSubscript(['1701'], FilteredString(Copy(NoteRec.Subject, 1, 80)));
  if NoteRec.ClinProcSummCode > 0 then
    aList.AddSubscript(['70201'], NoteRec.ClinProcSummCode);
  if NoteRec.ClinProcDateTime > 0 then
    aList.AddSubscript(['70202'], NoteRec.ClinProcDateTime);

  Results := TStringList.Create;
  try
    CallVistA('TIU UPDATE RECORD', [NoteIEN, aList], Results, True);
    if Results.Count > 0 then
    begin
      UpdatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
      UpdatedDoc.ErrorText := Piece(Results[0], U, 2);
    end
    else
    begin
      UpdatedDoc.IEN := NoteIEN;
      UpdatedDoc.ErrorText := '';
    end;
  finally
    Results.Free;
  end;

  if UpdatedDoc.IEN <= 0 then // v22.12 - RV
  // if UpdatedDoc.ErrorText <> '' then    //v22.5 - RV
  begin
    UpdatedDoc.ErrorText := UpdatedDoc.ErrorText + #13#10 + #13#10 +
      'Document #:  ' + IntToStr(NoteIEN);
    Exit;
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
  aList: iORNetMult;
  Results: TStrings;

begin
  neworNetMult(aList);
  for i := 0 to Pred(NoteText.Count) do
    aList.AddSubscript(['TEXT',IntToStr(Succ(i)),'0'],
      FilteredString(NoteText[i]));

  Results := TSTringList.Create;
  try
    CallVistA('TIU UPDATE RECORD', [NoteIEN, aList, '1'], Results, True);
    if Results.Count > 0 then
    begin
      if Piece(Results[0], U, 1) = '0' then
        ErrMsg := Piece(Results[0], U, 2)
      else
        ErrMsg := '';
    end
    else
      ErrMsg := '';
  finally
    Results.Free;
  end;
end;


procedure SetText(var ErrMsg: string; NoteText: TStrings; NoteIEN: Int64;
  Suppress: Integer);
const
  DOCUMENT_PAGE_SIZE = 300;
  TX_SERVER_ERROR = 'An error occurred on the server.';
var
  i, j, page, pages: Integer;
  aList: iORNetMult;

  function Submit: String;
  var
    sl: TStrings;
    Retry: boolean;

  begin
    sl := TStringList.Create;
    try
      // Do not retry if there is a failure when not suppressing (saving text
      // to the final note record), more than one page is sent, and you are
      // sending the last page.  The last page call clears the temp buffer
      // holding the text from the prior page calls, so the prior pages text
      // could be lost if retrying.
      if Suppress = 1 then
        Retry := True
      else
        Retry := ((pages = 1) or (page < pages));
      CallVistA('TIU SET DOCUMENT TEXT', [NoteIEN, aList, Suppress], sl, Retry);
      if sl.Count > 0 then
        Result := Piece(sl[0], U, 4)
      else
        Result := TX_SERVER_ERROR;
    finally
      sl.Free;
    end;
  end;

begin
  // Compute pages, initialize Params
  pages := (NoteText.Count div DOCUMENT_PAGE_SIZE);
  if (NoteText.Count mod DOCUMENT_PAGE_SIZE) > 0 then
    pages := pages + 1;
  page := 1;
  LockBroker;
  try
    neworNetMult(aList);
    // Loop through NoteRec.Lines
    for i := 0 to NoteText.Count - 1 do
    begin
      j := i + 1;
      // Add each successive line to Param[1].Mult...
      aList.AddSubscript(['TEXT',IntToStr(j),'0'], FilteredString(NoteText[i]));
      // When current page is filled, call broker, increment page, itialize params,
      // and continue...
      if (j mod DOCUMENT_PAGE_SIZE) = 0 then
      begin
        aList.AddSubscript('HDR', IntToStr(page) + U + IntToStr(pages));
        ErrMsg := Submit;
        if ErrMsg <> '' then
          Exit;
        page := page + 1;
        neworNetMult(aList);
      end; // if
    end; // for
    // finally, file any remaining partial page
    if (NoteText.Count mod DOCUMENT_PAGE_SIZE) <> 0 then
    begin
      aList.AddSubscript(['HDR'], IntToStr(page) + U + IntToStr(pages));
      ErrMsg := Submit;
    end;
  finally
    UnlockBroker;
  end;  
end;

{ Printin --------------------------------------------------------------------------------- }

function AllowPrintOfNote(ANote: Integer): string;
{ returns
  0 message Can't print at all (fails bus rules)
  1 Can print work copy only
  2 Can print work or chart copy (Param=1 or user is MAS)
}
begin
  CallVistA('TIU CAN PRINT WORK/CHART COPY', [ANote], Result); // sCallV('TIU CAN PRINT WORK/CHART COPY', [ANote]);
end;

function AllowChartPrintForNote(ANote: Integer): boolean;
{ returns true if a progress note may be printed outside of MAS }
var
  x: String;
begin
  Result := (CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote], x) and
    (Piece(x, U, 9) = '1'));
  Result := Result or (CallVistA('TIU AUTHORIZATION', [ANote, 'PRINT RECORD'],
    x) and (x = '1'));
end;

procedure PrintNoteToDevice(ANote: Integer; const ADevice: string;
  ChartCopy: boolean; var ErrMsg: string);
{ prints a progress note on the selected device }
begin
  CallVistA('TIU PRINT RECORD', [ANote, ADevice, ChartCopy], ErrMsg);
  if Piece(ErrMsg, U, 1) = '0' then
    ErrMsg := ''
  else
    ErrMsg := Piece(ErrMsg, U, 2);
end;

function GetFormattedNote(aDest:TStrings;ANote: Integer; ChartCopy: boolean): Integer;
begin
  CallVistA('ORWTIU WINPRINT NOTE', [ANote, ChartCopy],aDest);
  Result := aDest.Count;
end;

function setCurrentSigners(aDest:TStrings;IEN: Integer): Integer;
begin
  CallVistA('TIU GET ADDITIONAL SIGNERS', [IEN], aDest);
  MixedCaseList(aDest);
  Result := aDest.Count;
end;

procedure UpdateAdditionalSigners(IEN: Integer; Signers: TStrings);
begin
  CallVistA('TIU UPDATE ADDITIONAL SIGNERS', [IEN, Signers]);
end;

function CanChangeCosigner(IEN: Integer): boolean;
var
  x: String;
begin
  Result := CallVistA('TIU CAN CHANGE COSIGNER?', [IEN], x) and
    (Piece(x, U, 1) = '1');
end;

procedure ChangeCosigner(IEN: Integer; Cosigner: Int64);
var
  aList: iORNetMult;
begin
  neworNetMult(aList);
  if Cosigner > 0 then
    aList.AddSubscript(['1208'], Cosigner)
  else
    aList.AddSubscript(['1208'], '@');
  CallVistA('TIU UPDATE RECORD', [IEN, aList], True);
end;

// Determine if given note title is allowed more than once per visit.    12/2002-GRE
function OneNotePerVisit(NoteEIN: Integer; DFN: String;
  VisitStr: String): boolean;
var
  x: string;
begin
  CallVistA('TIU ONE VISIT NOTE?', [IntToStr(NoteEIN), DFN, VisitStr], x);
  if StrToInt(x) > 0 then
    Result := True // Only one per visit
  else
    Result := FALSE;
end;

function GetCurrentTIUContext: TTIUContext;
var
  x: string;
  AContext: TTIUContext;
begin
  CallVistA('ORWTIU GET TIU CONTEXT', [User.DUZ], x);
  with AContext do
  begin
    Changed := True;
    BeginDate := Piece(x, ';', 1);
    FMBeginDate := StrToFMDateTime(BeginDate);
    EndDate := Piece(x, ';', 2);
    FMEndDate := StrToFMDateTime(EndDate);
    Status := Piece(x, ';', 3);
    if (StrToIntDef(Status, 0) < 1) or (StrToIntDef(Status, 0) > 5) then
      Status := '1';
    Author := StrToInt64Def(Piece(x, ';', 4), 0);
    MaxDocs := StrToIntDef(Piece(x, ';', 5), 0);
    ShowSubject := StrToIntDef(Piece(x, ';', 6), 0) > 0; // TIU PREFERENCE??
    SortBy := Piece(x, ';', 7); // TIU PREFERENCE??
    ListAscending := StrToIntDef(Piece(x, ';', 8), 0) > 0;
    TreeAscending := StrToIntDef(Piece(x, ';', 9), 0) > 0; // TIU PREFERENCE??
    GroupBy := Piece(x, ';', 10);
    SearchField := Piece(x, ';', 11);
    KeyWord := Piece(x, ';', 12);
    Filtered := (KeyWord <> '');
  end;
  Result := AContext;
end;

procedure SaveCurrentTIUContext(AContext: TTIUContext);
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
    SetPiece(x, ';', 6, BOOLCHAR[ShowSubject]); // TIU PREFERENCE??
    SetPiece(x, ';', 7, SortBy); // TIU PREFERENCE??
    SetPiece(x, ';', 8, BOOLCHAR[ListAscending]);
    SetPiece(x, ';', 9, BOOLCHAR[TreeAscending]); // TIU PREFERENCE??
    SetPiece(x, ';', 10, GroupBy);
    SetPiece(x, ';', 11, SearchField);
    SetPiece(x, ';', 12, KeyWord);
  end;
  CallVistA('ORWTIU SAVE TIU CONTEXT', [x]);
end;

function TIUSiteParams: string;
begin
  if (not uTIUSiteParamsLoaded) then
  begin
    CallVistA('TIU GET SITE PARAMETERS', [], uTIUSiteParams);
    uTIUSiteParamsLoaded := True;

    // I guess the next is better but... keeping the original logic for now
    // uTIUSiteParamsLoaded := CallVistA('TIU GET SITE PARAMETERS', [], uTIUSiteParams);

  end;
  Result := uTIUSiteParams;
end;

// ===================Interdisciplinary Notes RPCs =====================

function IDNotesInstalled: boolean;
begin
  Result := True; // old patch check no longer called
end;

function CanTitleBeIDChild(Title: Integer; var WhyNot: string): boolean;
var
  x: string;
begin
  Result := FALSE;
  CallVistA('ORWTIU CANLINK', [Title], x);
  if Piece(x, U, 1) = '1' then
    Result := True
  else if Piece(x, U, 1) = '0' then
  begin
    Result := FALSE;
    WhyNot := Piece(x, U, 2);
  end;
end;

function CanBeAttached(DocID: string; var WhyNot: string): boolean;
var
  x: string;
const
  TX_NO_ATTACH =
    'This note appears to be an interdisciplinary parent.  Please drag the child note you wish to '
    + CRLF + 'attach instead of attempting to drag the parent, or check with IRM or your'
    + CRLF + 'clinical coordinator.';
begin
  Result := FALSE;
  if StrToIntDef(DocID, 0) = 0 then
    Exit;
  CallVistA('TIU ID CAN ATTACH', [DocID], x);
  if Piece(x, U, 1) = '1' then
    Result := True
  else if Piece(x, U, 1) = '0' then
  begin
    Result := FALSE;
    WhyNot := Piece(x, U, 2);
  end
  else if Piece(x, U, 1) = '-1' then
  begin
    Result := FALSE;
    WhyNot := TX_NO_ATTACH;
  end;
end;

function CanReceiveAttachment(DocID: string; var WhyNot: string): boolean;
var
  x: string;
begin
  CallVistA('TIU ID CAN RECEIVE', [DocID], x);
  if Piece(x, U, 1) = '1' then
    Result := True
  else
  begin
    Result := FALSE;
    WhyNot := Piece(x, U, 2);
  end;
end;

function AttachEntryToParent(DocID, ParentDocID: string;
  var WhyNot: string): boolean;
var
  x: string;
begin
  CallVistA('TIU ID ATTACH ENTRY', [DocID, ParentDocID], x);
  if StrToIntDef(Piece(x, U, 1), 0) > 0 then
    Result := True
  else
  begin
    Result := FALSE;
    WhyNot := Piece(x, U, 2);
  end;
end;

function DetachEntryFromParent(DocID: string; var WhyNot: string): boolean;
var
  x: string;
begin
  CallVistA('TIU ID DETACH ENTRY', [DocID], x);
  if StrToIntDef(Piece(x, U, 1), 0) > 0 then
    Result := True
  else
  begin
    Result := FALSE;
    WhyNot := Piece(x, U, 2);
  end;
end;

function setSubSetOfUserClasses(aDest:TStrings;const StartFrom: string; Direction: Integer)
  : Integer;
begin
  CallVistA('TIU USER CLASS LONG LIST', [StartFrom, Direction], aDest);
  Result := aDest.Count;
end;

function setUserDivClassInfo(aDest:TStrings;User: Int64): Integer;
begin
  CallVistA('TIU DIV AND CLASS INFO', [User], aDest);
  Result := aDest.Count;
end;

function UserInactive(EIN: String): boolean;
var
  i: Integer;
begin
  Result := CallVistA('TIU USER INACTIVE?', [EIN], i) and (i > 0);
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

function NoteHasText(NoteIEN: Integer): boolean;
var
  i: Integer;
begin
  Result := CallVistA('ORWTIU CHKTXT', [NoteIEN], i) and (i > 0);
end;

initialization

// nothing for now

finalization

if uNoteTitles <> nil then
  uNoteTitles.Free;
if uTIUPrefs <> nil then
  uTIUPrefs.Free;

end.

unit rDCSumm;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, rTIU, uConst, uTIU, uDCSumm
  ;


{ Discharge Summary Titles }

/// <summary>Reloads Summary titles with current data from VistA</summary>
procedure ResetDCSummTitles;
/// <summary>returns the IEN of the user defined default Discharge Summary title (if any)</summary>
function  DfltDCSummTitle: Integer;
/// <summary>returns the Name of the user defined default Discharge Summary title (if any)</summary>
function  DfltDCSummTitleName: string;
/// <summary>returns the user defined list (short list) of Discharge Summary titles</summary>
procedure ListDCSummTitlesShort(Dest: TStrings);
/// <summary>
/// const <c>sl</c> returns a pointer to a list of Discharge Summary titles (for use in a long list box) -
/// NOTE: the list should be freed after use.
/// ( RTC 272867 - removing dependence on RPCBrokerV.Results )
///  </summary>
///  <returns>True is the VistA call was succesful</returns>
function SubSetOfDCSummTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean; const sl:TStrings): Boolean;

{ TIU Preferences }

/// <summary>Resets <c>uDCSummPrefs</c> with value pulled from VistA</summary>
procedure ResetDCSummPreferences;
/// <summary>(Re)Loads <c>uDCSummPrefs</c> and returns value of <c>uDCSummPrefs.MaxSumms</c>.
///  if <c>uDCSummPrefs.MaxSumms</c> is 0 returns 100 </summary>
function  ReturnMaxDCSumms: Integer;
/// <summary>(Re)Loads <c>uDCSummPrefs</c> and returns true if
/// Discharge Summarys should be sorted from oldest to newest (chronological)
/// </summary>
function  SortDCSummsAscending: Boolean;
/// <summary>Loads TIUContext from VistA ('ORWTIU GET DCSUMM CONTEXT')</summary>
function  GetCurrentDCSummContext: TTIUContext;
/// <summary>Saves TIUContext in VistA ('ORWTIU SAVE DCSUMM CONTEXT')
/// </summary>
procedure SaveCurrentDCSummContext(AContext: TTIUContext) ;

{ Data Retrieval }
procedure ActOnDCDocument(var AuthSts: TActionRec; IEN: Integer; const ActionName: string);
(*procedure ListDischargeSummaries(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);*)
procedure ListSummsForTree(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
procedure GetDCSummForEdit(var EditRec: TEditDCSummRec; IEN: Integer);
procedure GetCSummEditTextOnly(ResultList: TStrings; IEN: Integer);

/// <summary>
/// Data to populate "Urgencies" list of the fDCSummProps form
/// </summary>
/// <remarks>Function result should be freed after usage. </remarks>
//function  LoadDCUrgencies: TStrings;
procedure  LoadDCUrgencies(aTarget:TStrings);
function  GetAttending(const DFN: string): string;  //*DFN*
function  GetDischargeDate(const DFN: string; AdmitDateTime: string): string;  //*DFN*
function RequireRelease(ANote, AType: Integer): Boolean;
function RequireMASVerification(ANote, AType: Integer): Boolean;
function AllowMultipleSummsPerAdmission(ANote, AType: Integer): Boolean;

{ Data Storage }
procedure DeleteDCDocument(var DeleteSts: TActionRec; IEN: Integer; const Reason: string);
procedure SignDCDocument(var SignSts: TActionRec; IEN: Integer; const ESCode: string);
procedure PutNewDCSumm(var CreatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec);
procedure PutDCAddendum(var CreatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec; AddendumTo:
Integer);
procedure PutEditedDCSumm(var UpdatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec; NoteIEN:
Integer);
procedure ChangeAttending(IEN: integer; AnAttending: int64);

const
  CLS_DC_SUMM = 244;
  FN_HOSPITAL_LOCATION = 44;
  FN_NEW_PERSON = 200;
  TIU_ST_UNREL = 3;
  TIU_ST_UNVER = 4;
  TIU_ST_UNSIG = 5;

implementation
uses
  rMisc, ORNetIntf;

var
  uDCSummTitles: TDCSummTitles;
  uDCSummPrefs: TDCSummPrefs;

{ Discharge Summary Titles  -------------------------------------------------------------------- }
/// <summary>private - called one time to set up the uNoteTitles object</summary>
procedure LoadDCSummTitles;
{ private - called one time to set up the uNoteTitles object }
var
  x: string;
  sl: TStringList;
begin
  if uDCSummTitles <> nil then
    Exit;
  uDCSummTitles := TDCSummTitles.Create;
  sl := TStringList.Create;
  try
    if not CallVistA('TIU PERSONAL TITLE LIST', [User.DUZ, CLS_DC_SUMM],sl) then
      sl.Clear
    else
      begin
        sl.Insert(0,'~SHORT LIST');
        ExtractItems(uDCSummTitles.ShortList, sl, 'SHORT LIST');
        x := ExtractDefault(sl, 'SHORT LIST');
        uDCSummTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
        uDCSummTitles.DfltTitleName := Piece(x, U, 2);
      end;
  finally
    sl.Free;
  end;
end;

procedure ResetDCSummTitles;
begin
  if uDCSummTitles <> nil then
    begin
      uDCSummTitles.Free;
      uDCSummTitles := nil;
      LoadDCSummTitles;
    end;
end;

function DfltDCSummTitle: Integer;
{ returns the IEN of the user defined default Discharge Summary title (if any) }
begin
  if uDCSummTitles = nil then LoadDCSummTitles;
  Result := uDCSummTitles.DfltTitle;
end;

function DfltDCSummTitleName: string;
{ returns the name of the user defined default Discharge Summary title (if any) }
begin
  if uDCSummTitles = nil then LoadDCSummTitles;
  Result := uDCSummTitles.DfltTitleName;
end;

procedure ListDCSummTitlesShort(Dest: TStrings);
{ returns the user defined list (short list) of Discharge Summary titles }
begin
  if uDCSummTitles = nil then LoadDCSummTitles;
  FastAddStrings(uDCSummTitles.ShortList, Dest);
  if uDCSummTitles.ShortList.Count > 0 then
  begin
    Dest.Add('0^________________________________________________________________________');
    Dest.Add('0^ ');
  end;
end;

function SubSetOfDCSummTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean; const sl:TStrings): Boolean;
begin
  if not assigned(sl) then
    Result := false
  else
    begin
      if IDNoteTitlesOnly then
        Result := CallVistA('TIU LONG LIST OF TITLES',
          [CLS_DC_SUMM, StartFrom, Direction, IDNoteTitlesOnly], sl)
      else
        Result := CallVistA('TIU LONG LIST OF TITLES',
          [CLS_DC_SUMM, StartFrom, Direction], sl);
      if not Result then
        sl.Clear;
    end;
end;

{ TIU Preferences  ------------------------------------------------------------------------- }

procedure LoadDCSummPrefs;
{ private - creates DCSummPrefs object for reference throughout the session }
var
  x: string;
begin
  uDCSummPrefs := TDCSummPrefs.Create;
  with uDCSummPrefs do
  begin
    if not CallVistA('TIU GET PERSONAL PREFERENCES', [User.DUZ],x) then
      x := '';
    DfltLoc := StrToIntDef(Piece(x, U, 2), 0);
    DfltLocName := ExternalName(DfltLoc, FN_HOSPITAL_LOCATION);
    SortAscending := Piece(x, U, 4) = 'A';
    MaxSumms := StrToIntDef(Piece(x, U, 10), 0);
    x := GetAttending(Patient.DFN);
    DfltCosigner := StrToInt64Def(Piece(x, U, 1), 0);
    DfltCosignerName := ExternalName(DfltCosigner, FN_NEW_PERSON);
    AskCosigner := User.DUZ <> DfltCosigner;
  end;
end;

procedure ResetDCSummPreferences;
begin
  if uDCSummPrefs <> nil then
    begin
      uDCSummPrefs.Free;
      uDCSummPrefs := nil;
      LoadDCSummPrefs;
    end;
end;

function ReturnMaxDCSumms: Integer;
begin
  if uDCSummPrefs = nil then LoadDCSummPrefs;
  Result := uDCSummPrefs.MaxSumms;
  if Result = 0 then Result := 100;
end;

function SortDCSummsAscending: Boolean;
{ returns true if Discharge Summarys should be sorted from oldest to newest (chronological) }
begin
  if uDCSummPrefs = nil then LoadDCSummPrefs;
  Result := uDCSummPrefs.SortAscending;
end;

{ Data Retrieval --------------------------------------------------------------------------- }

procedure ActOnDCDocument(var AuthSts: TActionRec; IEN: Integer;
  const ActionName: string);
var
  x: string;
begin
  // if not (IEN > 0) then
  if IEN <= 0 then
  begin
    AuthSts.Success := True;
    AuthSts.Reason := '';
//    Exit;
  end
  else
  begin
    if not CallVistA('TIU AUTHORIZATION', [IEN, ActionName], x) then
      x := '';
    AuthSts.Success := Piece(x, U, 1) = '1';
    AuthSts.Reason := Piece(x, U, 2);
  end;
end;

(*
procedure ListDischargeSummaries(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
{ retrieves existing progress notes for a patient according to the parameters passed in
  Pieces: IEN^Title^FMDateOfNote^Patient^Author^Location^Status^Visit
  Return: IEN^ExDateOfNote^Title, Location, Author }
var
  i: Integer;
  x: string;
  SortSeq: Char;
begin
  if SortAscending then SortSeq := 'A' else SortSeq := 'D';
  //if OccLim = 0 then OccLim := MaxSummsReturned;
  CallV('TIU DOCUMENTS BY CONTEXT',
         [CLS_DC_SUMM, Context, Patient.DFN, Early, Late, Person, OccLim, SortSeq]);
  with RPCBrokerV do
  begin
    for i := 0 to Results.Count - 1 do
    begin
      x := Results[i];
      if Copy(Piece(x, U, 9), 1, 4) = '    ' then SetPiece(x, U, 9, 'Dis: ');
      x := Piece(x, U, 1) + U + FormatFMDateTime('mmm dd,yy', MakeFMDateTime(Piece(x, U, 3)))
        + U + Piece(x, U, 2) + ', ' + Piece(x, U, 6) + ', ' + Piece(Piece(x, U, 5), ';', 2) +
        '  (' + Piece(x,U,7) + '), ' + Piece(x, U, 8) + ', ' + Piece(x, U, 9) +
        U + Piece(x, U, 3) + U + Piece(x, U, 11);
      Results[i] := x;
    end; {for}
    FastAssign(RPCBrokerV.Results, Dest);
  end; {with}
end;*)

procedure ListSummsForTree(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
{ retrieves existing discharge summaries for a patient according to the parameters passed in}
var
  SortSeq: Char;
  sl: TStrings;
const
  SHOW_ADDENDA = True;
begin
  if SortAscending then SortSeq := 'A' else SortSeq := 'D';
  if Context > 0 then
    begin
      sl := TStringList.Create;
      try
        if not CallVistA('TIU DOCUMENTS BY CONTEXT',
          [CLS_DC_SUMM, Context, Patient.DFN, Early, Late, Person, OccLim,
          SortSeq, SHOW_ADDENDA],sl) then
          sl.Clear;
        Dest.Assign(sl);
      finally
        sl.Free;
      end;
    end;
end;

procedure GetDCSummForEdit(var EditRec: TEditDCSummRec; IEN: Integer);
{ retrieves internal/external values for Discharge Summary fields & loads them into EditRec
  Fields: Title:.01, RefDate:1301, Author:1204, Cosigner:1208, Subject:1701, Location:1205 }
var
  sl: TStringList;
  i, j: Integer;

begin
  FillChar(EditRec, SizeOf(EditRec), 0);
  sl := TStringList.Create;
  if CallVistA('TIU LOAD RECORD FOR EDIT',
    [IEN, '.01;.06;.07;.09;1202;1205;1208;1209;1301;1302;1307;1701'], sl) then
    with EditRec do
    begin
      Title :=                    FindInt(sl,'.01',2); //FindInt('.01');
      TitleName :=                FindExt(sl,'.01',3); //FindExt('.01');
      AdmitDateTime :=            FindDT(sl,'.07',2);  //FindDT('.07');
      DischargeDateTime :=        FindDT(sl,'1301',2); //FindDT('1301');
      UrgencyName :=              FindExt(sl,'.09',3); //FindExt('.09');
      Urgency := Copy(UrgencyName, 1, 1);
      Dictator :=                 FindInt64(sl,'1202',2); //FindInt64('1202');
      DictatorName :=             FindExt(sl,'1202',3); //FindExt('1202');
      Cosigner :=                 FindInt64(sl,'1208',2); //FindInt64('1208');
      CosignerName :=             FindExt(sl,'1208',3); //FindExt('1208');
      DictDateTime :=             FindDT(sl,'1307',2);  //FindDT('1307');
      Attending :=                FindInt64(sl,'1209',2); //FindInt64('1209');
      AttendingName :=            FindExt(sl,'1209',3); //FindExt('1209');
      Transcriptionist :=         FindInt64(sl,'1302',2); //FindInt64('1302');
      TranscriptionistName :=     FindExt(sl,'1302',3); //FindExt('1302');
      Location :=                 FindInt(sl,'1205',2); //FindInt('1205');
      LocationName :=             FindExt(sl,'1205',3); //FindExt('1205');
      if Title = TYP_ADDENDUM then
        Addend :=                 FindInt(sl,'.06',2);  //FindInt('.06');
      for i := 0 to sl.Count - 1 do
        if sl[i] = '$TXT' then
          break;
      for j := i downto 0 do
        sl.Delete(j);

      if not assigned(Lines) then
        Lines := sl
      else
      begin
        FastAssign(sl, Lines);
        sl.Free;
      end;
    end
  else
  begin
    // if not Assigned(EditRec.Lines) then EditRec.Lines := TStringList.Create
    if not assigned(EditRec.Lines) then
      EditRec.Lines := sl;
    EditRec.Lines.Clear;
  end;
end;

procedure GetCSummEditTextOnly(ResultList: TStrings; IEN: Integer);
var
  RtnLst: TStringList;
begin
 RtnLst := TStringList.Create;
 try
  CallVistA('TIU LOAD RECORD TEXT', [IEN], RtnLst);
  if (RtnLst.Count > 0) and (RtnLst[0] = '$TXT') then
  begin
    //Remove the indicator
    RtnLst.Delete(0);
    //assign the remaining
    ResultList.Assign(RtnLst);
  end;
  finally
    RtnLst.Free;
  end;
end;

//function LoadDCUrgencies: TStrings;
procedure  LoadDCUrgencies(aTarget:TStrings);
var
  sl: TStrings;
  i: integer;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('TIU GET DS URGENCIES',[nil],sl) then
      sl.Clear
    else
      for i := 0 to sl.Count - 1 do
        sl[i] := MixedCase(UpperCase(sl[i]));
    FastAssign(sl,aTarget);
  finally
    sl.Free;
  end;
end;

{ Data Updates ----------------------------------------------------------------------------- }

procedure DeleteDCDocument(var DeleteSts: TActionRec; IEN: Integer; const Reason: string);
{ delete a TIU document given the internal entry number, return reason if unable to delete }
begin
  DeleteDocument(DeleteSts, IEN, Reason);
end;

procedure SignDCDocument(var SignSts: TActionRec; IEN: Integer; const ESCode: string);
{ update signed status of a TIU document, return reason if signature is not accepted }
var
  x: string;
begin
  if CallVistA('TIU SIGN RECORD', [IEN, ESCode],x) then
    begin
      SignSts.Success := Piece(x, U, 1) = '0';
      SignSts.Reason  := Piece(x, U, 2);
    end;
end;

procedure PutNewDCSumm(var CreatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec);
{ create a new discharge summary with the data in DCSummRec and return its internal entry number
  load broker directly since there isn't a good way to set up multiple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
  aList: iORNetMult;
  sl: TStrings;
begin
  newORNetMult(aList);
  begin
    aList.AddSubscript(['.07'], DCSummRec.AdmitDateTime);
    aList.AddSubscript(['.09'], DCSummRec.Urgency);
    aList.AddSubscript(['1202'], DCSummRec.Dictator);
    aList.AddSubscript(['1205'], Encounter.Location);
    aList.AddSubscript(['1301'], DCSummRec.DischargeDateTime);
    aList.AddSubscript(['1307'], DCSummRec.DictDateTime);
    if DCSummRec.Cosigner > 0 then
    begin
      aList.AddSubscript(['1208'], DCSummRec.Cosigner);
      aList.AddSubscript(['1506'], '1');
    end
    else
    begin
      aList.AddSubscript(['1208'], '');
      aList.AddSubscript(['1506'], '0');
    end;
    aList.AddSubscript(['1209'], DCSummRec.Attending);
    aList.AddSubscript(['1302'], DCSummRec.Transcriptionist);
    if DCSummRec.IDParent > 0 then
      aList.AddSubscript(['2101'], DCSummRec.IDParent);
  end;

  sl := TStringList.Create;
  try
    // Do NOT set CallVistA's RequireResults parameter to True or it could
    // create multiple blank documents.
    CallVistA('TIU CREATE RECORD', [Patient.DFN, DCSummRec.Title, '', '', '',
      aList, DCSummRec.VisitStr, '1'], sl);
    if sl.Count > 0 then
    begin
      CreatedDoc.IEN := StrToIntDef(Piece(sl[0], U, 1), 0);
      CreatedDoc.ErrorText := Piece(sl[0], U, 2);
    end
    else
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := '';
    end;
  finally
    sl.Free;
  end;

  if ( DCSummRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
    SetText(ErrMsg, DCSummRec.Lines, CreatedDoc.IEN, 1);
  if ErrMsg <> '' then
  begin
    CreatedDoc.IEN := 0;
    CreatedDoc.ErrorText := ErrMsg;
  end;
end;

procedure PutDCAddendum(var CreatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec; AddendumTo:
Integer);
{ create a new addendum for note identified in AddendumTo, returns IEN of new document
  load broker directly since there isn't a good way to set up multiple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
  aList: iORNetMult;
  sl: TStrings;
begin
  newORNetMult(aList);
  aList.AddSubscript(['.09'], DCSummRec.Urgency);
  aList.AddSubscript(['1202'], DCSummRec.Dictator);
  aList.AddSubscript(['1301'], DCSummRec.DischargeDateTime);
  aList.AddSubscript(['1307'], DCSummRec.DictDateTime);
  if DCSummRec.Cosigner > 0 then
  begin
    aList.AddSubscript(['1208'], DCSummRec.Cosigner);
    aList.AddSubscript(['1506'], '1');
  end
  else
  begin
    aList.AddSubscript(['1208'], '');
    aList.AddSubscript(['1506'], '0');
  end;
  sl := TStringList.Create;
  try
    // Do NOT set CallVistA's RequireResults parameter to True or it could
    // create multiple blank documents.
    CallVistA('TIU CREATE ADDENDUM RECORD', [AddendumTo, aList, '1'], sl);
    if sl.Count > 0 then
    begin
      CreatedDoc.IEN := StrToIntDef(Piece(sl[0], U, 1), 0);
      CreatedDoc.ErrorText := Piece(sl[0], U, 2);
    end
    else
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := '';
    end;
  finally
    sl.Free;
  end;
  if ( DCSummRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
    SetText(ErrMsg, DCSummRec.Lines, CreatedDoc.IEN, 1);
  if ErrMsg <> '' then
  begin
    CreatedDoc.IEN := 0;
    CreatedDoc.ErrorText := ErrMsg;
  end;
end;

procedure PutEditedDCSumm(var UpdatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec; NoteIEN:
Integer);
{ update the fields and content of the note identified in NoteIEN, returns 1 if successful
  load broker directly since there isn't a good way to set up mutilple subscript arrays }
(*var
  i: Integer;*)
var
  ErrMsg: string;
  sl: TSTrings;
  aList: iORNetMult;
begin
  // First, file field data
  newORNetMult(aList);

  if DCSummRec.Addend = 0 then
    aList.AddSubscript(['.01'], DCSummRec.Title);
  if (DCSummRec.Status in [TIU_ST_UNREL (* , TIU_ST_UNVER *) ]) then
    aList.AddSubscript(['.05'], DCSummRec.Status);
  aList.AddSubscript(['1202'], DCSummRec.Dictator);
  aList.AddSubscript(['1209'], DCSummRec.Attending);
  aList.AddSubscript(['1301'], DCSummRec.DischargeDateTime);
  if DCSummRec.Cosigner > 0 then
  begin
    aList.AddSubscript(['1208'], DCSummRec.Cosigner);
    aList.AddSubscript(['1506'], '1');
  end
  else
  begin
    aList.AddSubscript(['1208'], '');
    aList.AddSubscript(['1506'], '0');
  end;

  sl := TStringList.Create;
  try
    CallVistA('TIU UPDATE RECORD', [NoteIEN, aList], sl, True);
    if sl.Count > 0 then
    begin
      UpdatedDoc.IEN := StrToIntDef(Piece(sl[0], U, 1), 0);
      UpdatedDoc.ErrorText := Piece(sl[0], U, 2);
    end
    else
    begin
      UpdatedDoc.IEN := NoteIEN;
      UpdatedDoc.ErrorText := '';
    end;
  finally
    sl.Free;
  end;

  if UpdatedDoc.IEN <= 0 then              //v22.12 - RV
  //if UpdatedDoc.ErrorText <> '' then    //v22.5 - RV
    begin
      UpdatedDoc.ErrorText := UpdatedDoc.ErrorText + #13#10 + #13#10 + 'Document #:  ' + IntToStr(NoteIEN);
      exit;
    end;

    // next, if no error, file document body
  SetText(ErrMsg, DCSummRec.Lines, NoteIEN, 0);
  if ErrMsg <> '' then
  begin
    UpdatedDoc.IEN := 0;
    UpdatedDoc.ErrorText := ErrMsg;
  end;
end;

function GetAttending(const DFN: string): string;  //*DFN*
var
  s: String;
begin
  if not CallVistA('ORQPT ATTENDING/PRIMARY',[DFN],s) then
    s := '';
  Result := Piece(s,';',1);
end;

function GetDischargeDate(const DFN: string; AdmitDateTime: string): string;  //*DFN*
begin
  if not CallVistA('ORWPT DISCHARGE',[DFN, AdmitDateTime],Result) then
    Result := '';
end;

function RequireRelease(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be released }
var
  s: String;
begin
  if ANote > 0 then
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote],s)
  else
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', [0,aType],s);

  Result := Result and (Piece(s, U, 2) = '1');
end;

function RequireMASVerification(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be verified }
var
  AValue: integer;
  b: Boolean;
  s: String;
begin
  try
    if ANote > 0 then
      b := CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote],s)
    else
      b := CallVistA('TIU GET DOCUMENT PARAMETERS', [0,aType],s);
  except
    on E: Exception do
      b := False;
  end;

  if b then
    aValue := StrToIntDef(Piece(s,U,3),0)
  else
    aValue := -1;

  case AValue of
    0:  Result := False;   //  NO
    1:  Result := True;    //  ALWAYS
    2:  Result := False;   //  UPLOAD ONLY
    3:  Result := True;    //  DIRECT ENTRY ONLY
  else
    Result := False;
  end;
end;

function AllowMultipleSummsPerAdmission(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be released }
{ returns False if an error occurs while checking }
var
  s: String;
begin
  if ANote > 0 then
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', [ANote],s)
  else
    Result := CallVistA('TIU GET DOCUMENT PARAMETERS', [0, AType],s);

  Result := Result and ( Piece(s,U,10)='1');
end;

procedure ChangeAttending(IEN: Integer; AnAttending: int64);
var
  AttendingIsNotCurrentUser: boolean;
  aList: iORNetMult;
begin
  AttendingIsNotCurrentUser := (AnAttending <> User.DUZ);
  newORNetMult(aList);
  aList.AddSubscript(['1209'], AnAttending);
      if AttendingIsNotCurrentUser then
      begin
        aList.AddSubscript(['1208'], AnAttending);
        aList.AddSubscript(['1506'], '1');
      end
      else
      begin
        aList.AddSubscript(['1208'], '');
        aList.AddSubscript(['1506'], '0');
      end;
  CallVistA('TIU UPDATE RECORD',[IEN, aList], True);
end;

function GetCurrentDCSummContext: TTIUContext;
var
  x: string;
  AContext: TTIUContext;
begin
  if CallVistA('ORWTIU GET DCSUMM CONTEXT', [User.DUZ],x)  then
  with AContext do
    begin
      Changed       := True;
      BeginDate     := Piece(x, ';', 1);
      EndDate       := Piece(x, ';', 2);
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

procedure SaveCurrentDCSummContext(AContext: TTIUContext) ;
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
  CallVistA('ORWTIU SAVE DCSUMM CONTEXT', [x]);
end;

initialization
  // nothing for now

finalization
  if uDCSummTitles <> nil then uDCSummTitles.Free;
  if uDCSummPrefs <> nil then uDCSummPrefs.Free;
end.

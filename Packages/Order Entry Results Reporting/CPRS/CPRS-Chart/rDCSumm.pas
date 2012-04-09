unit rDCSumm;

interface

uses SysUtils, Classes, ORNet, ORFn, rCore, uCore, TRPCB, rTIU, uConst, uTIU, uDCSumm;


{ Discharge Summary Titles }
procedure ResetDCSummTitles;
function  DfltDCSummTitle: Integer;
function  DfltDCSummTitleName: string;
procedure ListDCSummTitlesShort(Dest: TStrings);
function SubSetOfDCSummTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;

{ TIU Preferences }
procedure ResetDCSummPreferences;
function  ReturnMaxDCSumms: Integer;
function  SortDCSummsAscending: Boolean;
function  GetCurrentDCSummContext: TTIUContext;
procedure SaveCurrentDCSummContext(AContext: TTIUContext) ;

{ Data Retrieval }
procedure ActOnDCDocument(var AuthSts: TActionRec; IEN: Integer; const ActionName: string);
(*procedure ListDischargeSummaries(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);*)
procedure ListSummsForTree(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
  Person: int64; OccLim: Integer; SortAscending: Boolean);
procedure GetDCSummForEdit(var EditRec: TEditDCSummRec; IEN: Integer);
function  LoadDCUrgencies: TStrings;
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

var
  uDCSummTitles: TDCSummTitles;
  uDCSummPrefs: TDCSummPrefs;

{ Discharge Summary Titles  -------------------------------------------------------------------- }
procedure LoadDCSummTitles;
{ private - called one time to set up the uNoteTitles object }
var
  x: string;
begin
  if uDCSummTitles <> nil then Exit;
  CallV('TIU PERSONAL TITLE LIST', [User.DUZ, CLS_DC_SUMM]);
  RPCBrokerV.Results.Insert(0, '~SHORT LIST');  // insert so can call ExtractItems
  uDCSummTitles := TDCSummTitles.Create;
  ExtractItems(uDCSummTitles.ShortList, RPCBrokerV.Results, 'SHORT LIST');
  x := ExtractDefault(RPCBrokerV.Results, 'SHORT LIST');
  uDCSummTitles.DfltTitle := StrToIntDef(Piece(x, U, 1), 0);
  uDCSummTitles.DfltTitleName := Piece(x, U, 2);
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

function SubSetOfDCSummTitles(const StartFrom: string; Direction: Integer; IDNoteTitlesOnly: boolean): TStrings;
{ returns a pointer to a list of Discharge Summary titles (for use in a long list box) -
  The return value is a pointer to RPCBrokerV.Results, so the data must be used BEFORE
  the next broker call! }
begin
  if IDNoteTitlesOnly then
    CallV('TIU LONG LIST OF TITLES', [CLS_DC_SUMM, StartFrom, Direction, IDNoteTitlesOnly])
  else
    CallV('TIU LONG LIST OF TITLES', [CLS_DC_SUMM, StartFrom, Direction]);
  //MixedCaseList(RPCBrokerV.Results);
  Result := RPCBrokerV.Results;
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
    x := sCallV('TIU GET PERSONAL PREFERENCES', [User.DUZ]);
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

procedure ActOnDCDocument(var AuthSts: TActionRec; IEN: Integer; const ActionName: string);
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

(*procedure ListDischargeSummaries(Dest: TStrings; Context: Integer; Early, Late: TFMDateTime;
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
const
  SHOW_ADDENDA = True;
begin
  if SortAscending then SortSeq := 'A' else SortSeq := 'D';
  if Context > 0 then
    begin
      CallV('TIU DOCUMENTS BY CONTEXT', [CLS_DC_SUMM, Context, Patient.DFN, Early, Late, Person, OccLim, SortSeq, SHOW_ADDENDA]);
      FastAssign(RPCBrokerV.Results, Dest);
    end;
end;

procedure GetDCSummForEdit(var EditRec: TEditDCSummRec; IEN: Integer);
{ retrieves internal/external values for Discharge Summary fields & loads them into EditRec
  Fields: Title:.01, RefDate:1301, Author:1204, Cosigner:1208, Subject:1701, Location:1205 }
var
  i, j: Integer;

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


begin
  CallV('TIU LOAD RECORD FOR EDIT', [IEN, '.01;.06;.07;.09;1202;1205;1208;1209;1301;1302;1307;1701']);
  FillChar(EditRec, SizeOf(EditRec), 0);
  with EditRec do
  begin
    Title                 := FindInt('.01');
    TitleName             := FindExt('.01');
    AdmitDateTime         := FindDT('.07');
    DischargeDateTime     := FindDT('1301');
    UrgencyName           := FindExt('.09');
    Urgency               := Copy(UrgencyName,1,1);
    Dictator              := FindInt64('1202');
    DictatorName          := FindExt('1202');
    Cosigner              := FindInt64('1208');
    CosignerName          := FindExt('1208');
    DictDateTime          := FindDT('1307');
    Attending             := FindInt64('1209');
    AttendingName         := FindExt('1209');
    Transcriptionist      := FindInt64('1302');
    TranscriptionistName  := FindExt('1302');
    Location              := FindInt('1205');
    LocationName          := FindExt('1205');
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

function LoadDCUrgencies: TStrings;
var
  i: integer;
begin
  CallV('TIU GET DS URGENCIES',[nil]);
  with RPCBrokerV do
    for i := 0 to Results.Count-1 do
      Results[i] := MixedCase(UpperCase(Results[i]));
  Result := RPCBrokerV.Results;
end;

{ Data Updates ----------------------------------------------------------------------------- }

procedure DeleteDCDocument(var DeleteSts: TActionRec; IEN: Integer; const Reason: string);
{ delete a TIU document given the internal entry number, return reason if unable to delete }
var
  x: string;
begin
  x := sCallV('TIU DELETE RECORD', [IEN, Reason]);
  DeleteSts.Success := Piece(x, U, 1) = '0';
  DeleteSts.Reason  := Piece(x, U, 2);
end;

procedure SignDCDocument(var SignSts: TActionRec; IEN: Integer; const ESCode: string);
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
    with Param[1] do Mult['.11']  := '0';       // **** block removed in v19.1 - {RV} ****
    CallBroker;
  end;                                         // temp - end*)
  x := sCallV('TIU SIGN RECORD', [IEN, ESCode]);
  SignSts.Success := Piece(x, U, 1) = '0';
  SignSts.Reason  := Piece(x, U, 2);
end;

procedure PutNewDCSumm(var CreatedDoc: TCreatedDoc; const DCSummRec: TDCSummRec);
{ create a new discharge summary with the data in DCSummRec and return its internal entry number
  load broker directly since there isn't a good way to set up multiple subscript arrays }
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
    Param[1].Value := IntToStr(DCSummRec.Title);
    Param[2].PType := literal;
    Param[2].Value := '';
    Param[3].PType := literal;
    Param[3].Value := '';
    Param[4].PType := literal;
    Param[4].Value := '';
    Param[5].PType := list;
    with Param[5] do
    begin
      Mult['.07']    := FloatToStr(DCSummRec.AdmitDateTime);
      Mult['.09']    := DCSummRec.Urgency;
      Mult['1202']   := IntToStr(DCSummRec.Dictator);
      Mult['1205']   := IntToStr(Encounter.Location);
      Mult['1301']   := FloatToStr(DCSummRec.DischargeDateTime);
      Mult['1307']   := FloatToStr(DCSummRec.DictDateTime);
      if DCSummRec.Cosigner > 0 then
        begin
          Mult['1208'] := IntToStr(DCSummRec.Cosigner);
          Mult['1506'] := '1';
        end
      else
        begin
          Mult['1208'] := '';
          Mult['1506'] := '0';
        end  ;
      Mult['1209']   := IntToStr(DCSummRec.Attending);
      Mult['1302']   := IntToStr(DCSummRec.Transcriptionist);
      if DCSummRec.IDParent > 0 then Mult['2101'] := IntToStr(DCSummRec.IDParent);
(*      if DCSummRec.Lines <> nil then
        for i := 0 to DCSummRec.Lines.Count - 1 do
          Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(DCSummRec.Lines[i]);*)
    end;
    Param[6].PType := literal;
    Param[6].Value := DCSummRec.VisitStr;
    Param[7].PType := literal;
    Param[7].Value := '1';  // suppress commit logic
    CallBroker;
    CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
    CreatedDoc.ErrorText := Piece(Results[0], U, 2);
  end;
  if ( DCSummRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
  begin
    SetText(ErrMsg, DCSummRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
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
      Mult['.09']    := DCSummRec.Urgency;
      Mult['1202']   := IntToStr(DCSummRec.Dictator);
      Mult['1301']   := FloatToStr(DCSummRec.DischargeDateTime);
      Mult['1307']   := FloatToStr(DCSummRec.DictDateTime);
      if DCSummRec.Cosigner > 0 then
        begin
          Mult['1208'] := IntToStr(DCSummRec.Cosigner);
          Mult['1506'] := '1';
        end
      else
        begin
          Mult['1208'] := '';
          Mult['1506'] := '0';
        end  ;
(*      if DCSummRec.Lines <> nil then
        for i := 0 to DCSummRec.Lines.Count - 1 do
          Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(DCSummRec.Lines[i]);*)
    end;
    Param[2].PType := literal;
    Param[2].Value := '1';  // suppress commit logic
    CallBroker;
    CreatedDoc.IEN := StrToIntDef(Piece(Results[0], U, 1), 0);
    CreatedDoc.ErrorText := Piece(Results[0], U, 2);
  end;
  if ( DCSummRec.Lines <> nil ) and ( CreatedDoc.IEN <> 0 ) then
  begin
    SetText(ErrMsg, DCSummRec.Lines, CreatedDoc.IEN, 1);
    if ErrMsg <> '' then
    begin
      CreatedDoc.IEN := 0;
      CreatedDoc.ErrorText := ErrMsg;
    end;
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
      if DCSummRec.Addend = 0 then
        begin
          Mult['.01']  := IntToStr(DCSummRec.Title);
          //Mult['.11']  := BOOLCHAR[DCSummRec.NeedCPT];  //  **** removed in v19.1  {RV} ****
        end;
      if (DCSummRec.Status in [TIU_ST_UNREL(*, TIU_ST_UNVER*)]) then Mult['.05'] := IntToStr(DCSummRec.Status);
      Mult['1202']   := IntToStr(DCSummRec.Dictator);
      Mult['1209']   := IntToStr(DCSummRec.Attending);
      Mult['1301']   := FloatToStr(DCSummRec.DischargeDateTime);  
      if DCSummRec.Cosigner > 0 then
        begin
          Mult['1208'] := IntToStr(DCSummRec.Cosigner);
          Mult['1506'] := '1';
        end
      else
        begin
          Mult['1208'] := '';
          Mult['1506'] := '0';
        end  ;
(*      for i := 0 to DCSummRec.Lines.Count - 1 do
        Mult['"TEXT",' + IntToStr(i+1) + ',0'] := FilteredString(DCSummRec.Lines[i]);*)
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
  SetText(ErrMsg, DCSummRec.Lines, NoteIEN, 0);
  if ErrMsg <> '' then
  begin
    UpdatedDoc.IEN := 0;
    UpdatedDoc.ErrorText := ErrMsg;
  end;
end;

function GetAttending(const DFN: string): string;  //*DFN*
begin
  CallV('ORQPT ATTENDING/PRIMARY',[DFN]);
  Result := Piece(RPCBrokerV.Results[0],';',1);
end;

function GetDischargeDate(const DFN: string; AdmitDateTime: string): string;  //*DFN*
begin
  CallV('ORWPT DISCHARGE',[DFN, AdmitDateTime]);
  Result := RPCBrokerV.Results[0];
end;

function RequireRelease(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be released }
begin
  if ANote > 0 then
    Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [ANote]), U, 2) = '1'
  else
    Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [0, AType]), U, 2) = '1';
end;

function RequireMASVerification(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be verified }
var
  AValue: integer;
begin
  Result := False;
  if ANote > 0 then
    AValue := StrToIntDef(Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [ANote]), U, 3), 0)
  else
    AValue := StrToIntDef(Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [0, AType]), U, 3), 0);
  case AValue of
    0:  Result := False;   //  NO
    1:  Result := True;    //  ALWAYS
    2:  Result := False;   //  UPLOAD ONLY
    3:  Result := True;    //  DIRECT ENTRY ONLY
  end;
end;

function AllowMultipleSummsPerAdmission(ANote, AType: Integer): Boolean;
{ returns true if a discharge summary must be released }
begin
  if ANote > 0 then
    Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [ANote]), U, 10) = '1'
  else
    Result := Piece(sCallV('TIU GET DOCUMENT PARAMETERS', [0, AType]), U, 10) = '1';
end;

procedure ChangeAttending(IEN: integer; AnAttending: int64);
var
  AttendingIsNotCurrentUser: boolean;
begin
  AttendingIsNotCurrentUser := (AnAttending <> User.DUZ);
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'TIU UPDATE RECORD';
    Param[0].PType := literal;
    Param[0].Value := IntToStr(IEN);
    Param[1].PType := list;
    with Param[1] do
      begin
        Mult['1209']   := IntToStr(AnAttending);
        if AttendingIsNotCurrentUser then
        begin
          Mult['1208'] := IntToStr(AnAttending);
          Mult['1506'] := '1';
        end
      else
        begin
          Mult['1208'] := '';
          Mult['1506'] := '0';
        end  ;
      end;
    CallBroker;
  end;
end;

function GetCurrentDCSummContext: TTIUContext;
var
  x: string;
  AContext: TTIUContext;
begin
  x := sCallV('ORWTIU GET DCSUMM CONTEXT', [User.DUZ]) ;
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
  CallV('ORWTIU SAVE DCSUMM CONTEXT', [x]);
end;

initialization
  // nothing for now

finalization
  if uDCSummTitles <> nil then uDCSummTitles.Free;
  if uDCSummPrefs <> nil then uDCSummPrefs.Free;

end.

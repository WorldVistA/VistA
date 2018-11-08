unit rCover;

interface

uses SysUtils, Windows, Classes, ORNet, ORFn, uConst, extctrls, ORCtrls, fFrame;

type
  TCoverSheetList = class(TObject)
  private
    FPanel: TList;
    FLabel: TList;
    FListBox: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(APanel: TPanel; ALabel: TOROffsetLabel; AListBox: TORListBox);
    function CVpln(index: integer): TPanel;
    function CVlbl(index: integer): TOROffsetLabel;
    function CVlst(index: integer): TORListBox;
  end;

function DetailGeneric(IEN: integer; ID, aRPC: string): TStrings;
function DetailProblem(IEN: Integer): TStrings;
function DetailAllergy(IEN: Integer): TStrings;
function DetailPosting(ID: string): TStrings;
function DetailMed(ID: string): TStrings;
procedure LoadCoverSheetList(Dest: TStrings);
procedure ListGeneric(Dest: TStrings; ARpc: String; ACase, AInvert: Boolean;
  ADatePiece: integer; ADateFormat, AParam1, ADetail, AID: String);
procedure ListActiveProblems(Dest: TStrings);
procedure ListAllergies(Dest: TStrings);
procedure ListPostings(Dest: TStrings);
procedure ListReminders(Dest: TStrings);
procedure ListActiveMeds(Dest: TStrings);
procedure ListRecentLabs(Dest: TStrings);
procedure ListVitals(Dest: TStrings);
procedure ListVisits(Dest: TStrings);
procedure LoadDemographics(Dest: TStrings);

function StartCoverSheet(const IPAddress: string; const AHandle: HWND;
                         const DontDo: string; const NewReminders: boolean): string;
procedure StopCoverSheet(const ADFN, IPAddress: string; AHandle: HWND);  //*DFN*
procedure ListAllBackGround(var Done: Boolean; DestProb, DestCWAD, DestMeds, DestRmnd, DestLabs,
  DestVitl, DestVsit: TStrings; const IPAddr: string; AHandle: HWND);
function NoDataText(Reminders: boolean): string;

implementation

uses rCore, uCore, rMeds, uReminders;

procedure TCoverSheetList.Add(APanel: TPanel; ALabel: TOROffsetLabel; AListBox: TORListBox);
begin
  FPanel.Add(APanel);
  FLabel.Add(ALabel);
  FListBox.Add(AListBox);
end;

constructor TCoverSheetList.Create;
begin
  FPanel := TList.Create;
  FLabel := TList.Create;
  FListBox := TList.Create;
end;

destructor TCoverSheetList.Destroy;
begin
  FPanel.Free;
  FLabel.Free;
  FListBox.Free;
  inherited;
end;

function TCoverSheetList.CVpln(index: integer): TPanel;
begin
  Result := TPanel(FPanel[index]);
end;

function TCoverSheetList.CVlbl(index: integer): TOROffsetLabel;
begin
  Result := TOROffsetLabel(FLabel[index]);
end;

function TCoverSheetList.CVlst(index: integer): TORListBox;
begin
  Result := TORListBox(FListBox[index]);
end;

function DetailGeneric(IEN: integer; ID, aRPC: string): TStrings;
var
  dfn: String;
begin
  dfn := Patient.DFN;
  if (aRPC = 'ORQQPL DETAIL') then
    dfn := dfn + U + FloatToStr(Encounter.DateTime);
  CallV(aRPC, [dfn, IEN, ID]);
  Result := RPCBrokerV.Results;
end;

function DetailProblem(IEN: Integer): TStrings;
begin
  CallV('ORQQPL DETAIL', [Patient.DFN + U + FloatToStr(Encounter.DateTime), IEN, '']);
  Result := RPCBrokerV.Results;
end;

function DetailAllergy(IEN: Integer): TStrings;
begin
  CallV('ORQQAL DETAIL', [Patient.DFN, IEN, '']);
  Result := RPCBrokerV.Results;
end;

function DetailPosting(ID: string): TStrings;
begin
  if ID = 'A' then CallV('ORQQAL LIST REPORT', [Patient.DFN])
  else if Length(ID) > 0 then CallV('TIU GET RECORD TEXT', [ID])
  else RPCBrokerV.Results.Clear;
  Result := RPCBrokerV.Results;
end;

function DetailMed(ID: string): TStrings;
begin
  (*
  CallV('ORQQPS DETAIL', [Patient.DFN, UpperCase(ID)]);
  Result := RPCBrokerV.Results;
  *)
  Result := DetailMedLM(ID);  // from rMeds
end;

procedure LoadCoverSheetList(Dest: TStrings);
begin
  CallV('ORWCV1 COVERSHEET LIST', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ExtractActiveMeds(Dest: TStrings; Src: TStringList);
const
  MED_TYPE: array[boolean] of string = ('INPT', 'OUTPT');
var
  i: Integer;
  MedType, NonVA, x: string;
  MarkForDelete: Boolean;
begin
  NonVA := 'N;';
  if Patient.Inpatient then
    begin
      if Patient.WardService = 'D' then MedType := 'IO'     //  Inpatient - DOM - show both
      else MedType := 'I';                                  //  Inpatient non-DOM
    end
  else
    MedType := 'O';                                         //  Outpatient
  for i := Src.Count - 1 downto 0 do
  begin
    MarkForDelete := False;
    // clear outpt meds if inpt, inpt meds if outpt.  Keep all for DOM patients.
    if (Pos(Piece(Piece(Src[i], U, 1), ';', 2), MedType) = 0)
       and (Piece(Src[i], U, 5)<> 'C') then MarkForDelete := True;
    if Pos(NonVA, Piece(Src[i], U, 1)) > 0 then    // Non-VA Med
      begin
        MarkForDelete := False;                    // always display non-VA meds
        x := Src[i];
        SetPiece(x, U, 2, 'Non-VA  ' + Piece(x, U, 2));
        Src[i] := x;
      end;
    if (Piece(Src[i], U, 5)='C') then  // Clin Meds
    begin
       MarkForDelete := False;                    // always display non-VA meds
       x := Src[i];
       SetPiece(x, U, 2, 'Clin Meds  ' + Piece(x, U, 2));
       Src[i] := x;
    end;
    // clear non-active meds   (SHOULD THIS INCLUDE PENDING ORDERS?)
    if MedStatusGroup(Piece(Src[i], U, 4)) = MED_NONACTIVE then MarkForDelete := True;
    if MarkForDelete then Src.Delete(i)
    else if MedType = 'IO' then   // for DOM patients only, distinguish between inpatient/outpatient meds
      begin
        x := Src[i];
        SetPiece(x, U, 2, MED_TYPE[Piece(Piece(x, U, 1), ';', 2)='O'] + ' - ' + Piece(x, U, 2));
        Src[i] := x;
      end;
  end;
  InvertStringList(Src);        // makes inverse chronological by order time
  MixedCaseList(Src);
  if Src.Count = 0 then Src.Add('0^No active medications found');
  FastAssign(Src, Dest);
end;

procedure ListGeneric(Dest: TStrings; ARpc: String; ACase, AInvert: Boolean;
  ADatePiece: integer; ADateFormat, AParam1, ADetail, AID: String);
var
  Param: array[0..1] of string;
  i: integer;
  s, x0, x2: string;
  tmplist: TStringList;
begin
  Param[0] := Patient.DFN;
  Param[1] := '';
  // v30 - for Problem List, concatenate Enc Date/Time as 2nd '^'-piece of Param[0]
  if (AID = '10') and (Encounter.DateTime <> 0) then
    Param[0] := Param[0] + U + FloatToStr(Encounter.DateTime);

  if AID = '50' then
    begin
      if (InteractiveRemindersActive) then  //special path for Reminders
          CallV('ORQQPXRM REMINDERS APPLICABLE', [Patient.DFN, Encounter.Location])
      else
        begin
          CallV('ORQQPX REMINDERS LIST', [Patient.DFN]);
          SetListFMDateTime('dddddd', TStringList(RPCBrokerV.Results), U, 3, TRUE);
        end;
        FastAssign(RPCBrokerV.Results, Dest);
      exit;
    end;
  tmplist := TStringList.Create;
  try
    tmplist.Clear;
    if Length(AParam1) > 0 then
      begin
        Param[1] := AParam1;
        CallV(ARpc, [Param[0], Param[1]]);
      end
    else
      CallV(ARpc, [Param[0]]);
    if AID = '40' then
      ExtractActiveMeds(TStringList(tmplist), TStringList(RPCBrokerV.Results))
    else
      FastAssign(RPCBrokerV.Results, tmpList);
    if ACase = TRUE then MixedCaseList(tmplist);
    if AID = '10' then for i := 0 to tmplist.Count - 1 do    // capitalize SC exposures for problems
    begin
      x0 := tmplist[i];
      x2 := Piece(x0, U, 2);
      if Pos('(', x2) > 0 then SetPiece(x2, '(', 2, UpperCase(Piece(x2, '(', 2)));
      if Piece(x0, U, 17)='1' then SetPiece(x2, '-', 1, UpperCase(Piece(x2, '-', 1)));
      SetPiece(x0, U, 2, x2);
      tmplist[i] := x0;
    end;
    if AInvert = TRUE then InvertStringList(TStringList(tmplist));
    if ADatePiece > 0 then
      begin
        if ADateFormat = 'D' then
          SetListFMDateTime('dddddd', TStringList(tmplist), U, ADatePiece, TRUE)
        else
          SetListFMDateTime('dddddd hh:nn', TStringList(tmplist), U, ADatePiece, TRUE);
      end;
    if Length(ADetail) > 0 then
      begin
        for i := 0 to tmplist.Count - 1 do
          begin
            s := tmplist[i];
            SetPiece(s, U, 12, ADetail);
            tmplist[i] := s
          end;
      end;
    FastAssign(tmplist, Dest);
  finally
    tmplist.Free;
  end;
end;

procedure ListActiveProblems(Dest: TStrings);
{ lists active problems, format: IEN^ProblemText^ICD^onset^last modified^SC^SpExp }
const
  ACTIVE_PROBLEMS = 'A';
var
  i: integer;
  x0, x2: string;
begin
  CallV('ORQQPL LIST', [Patient.DFN + U + FloatToStr(Encounter.DateTime), ACTIVE_PROBLEMS]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
  for i := 0 to Dest.Count - 1 do
    begin
      x0 := Dest[i];
      x2 := Piece(x0, U, 2);
      if Pos('(', x2) > 0 then SetPiece(x2, '(', 2, UpperCase(Piece(x2, '(', 2)));
      SetPiece(x0, U, 2, x2);
      Dest[i] := x0;
    end;
end;

procedure ListAllergies(Dest: TStrings);
{ lists allergies, format: }
begin
  CallV('ORQQAL LIST', [Patient.DFN]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListPostings(Dest: TStrings);
begin
  CallV('ORQQPP LIST', [Patient.DFN]);
  with RPCBrokerV do
  begin
    MixedCaseList(Results);
    SetListFMDateTime('dddddd', TStringList(Results), U, 3);
    FastAssign(Results, Dest);
  end;
end;

procedure ListReminders(Dest: TStrings);
begin
  with RPCBrokerV do
  begin
    if(InteractiveRemindersActive) then
      CallV('ORQQPXRM REMINDERS APPLICABLE', [Patient.DFN, Encounter.Location])
    else
    begin
      CallV('ORQQPX REMINDERS LIST', [Patient.DFN]);
      SetListFMDateTime('dddddd', TStringList(Results), U, 3, TRUE);
    end;
//    MixedCaseList(Results);
    FastAssign(Results, Dest);
  end;
end;

procedure ListActiveMeds(Dest: TStrings);
begin
  CallV('ORWPS COVER', [Patient.DFN, '1']);  // PharmID^DrugName^OrderID^StatusName
  ExtractActiveMeds(Dest, TStringList(RPCBrokerV.Results));
end;

procedure ListRecentLabs(Dest: TStrings);
begin
  CallV('ORWCV LAB', [Patient.DFN]);
  with RPCBrokerV do
  begin
    MixedCaseList(Results);
    SetListFMDateTime('dddddd', TStringList(Results), U, 3);
    FastAssign(Results, Dest);
  end;
end;

procedure ListVitals(Dest: TStrings);
begin
  CallV('ORQQVI VITALS', [Patient.DFN]);            // nulls are start/stop dates
  with RPCBrokerV do
  begin
    SetListFMDateTime('dddddd', TStringList(Results), U, 4);
    if Results.Count = 0 then Results.Add('0^No vitals found');
    FastAssign(Results, Dest);
  end;
end;

procedure ListVisits(Dest: TStrings);
begin
  CallV('ORWCV VST', [Patient.DFN]);
  with RPCBrokerV do
  begin
    InvertStringList(TStringList(Results));
    MixedCaseList(Results);
    SetListFMDateTime('dddddd hh:nn', TStringList(Results), U, 2);
    FastAssign(Results, Dest);
  end;
end;

procedure ListAllBackGround(var Done: Boolean; DestProb, DestCWAD, DestMeds, DestRmnd, DestLabs,
  DestVitl, DestVsit: TStrings; const IPAddr: string; AHandle: HWND);
var
  tmplst: TStringList;

  function SubListPresent(const AName: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    with RPCBrokerV do for i := 0 to Results.Count - 1 do
      if Results[i] = AName then
      begin
        Result := True;
        break;
      end;
  end;

  procedure AssignList(DestList: TStrings; const SectionID: string);
  var
    i: integer;
    x0, x2: string;
  begin
    tmplst.Clear;
    ExtractItems(tmplst, RPCBrokerV.Results, SectionID);
    if SectionID  = 'VSIT' then InvertStringList(tmplst);
    if(SectionID <> 'VITL') and (SectionID <> 'RMND') then MixedCaseList(tmplst);
    if SectionID <> 'PROB' then
    begin
      if SectionID = 'VSIT' then SetListFMDateTime('dddddd hh:nn', tmplst, U, 2)
      else if SectionID = 'VITL' then SetListFMDateTime('dddddd hh:nn', tmplst, U, 4)
      else if (SectionID <> 'RMND') or (not InteractiveRemindersActive) then
        SetListFMDateTime('dddddd', tmplst, U, 3, (SectionID = 'RMND'));
    end
    else for i := 0 to tmplst.Count - 1 do    // capitalize SC exposures for problems
    begin
      x0 := tmplst[i];
      x2 := Piece(x0, U, 2);
      if Pos('(', x2) > 0 then SetPiece(x2, '(', 2, UpperCase(Piece(x2, '(', 2)));
      SetPiece(x0, U, 2, x2);
      tmplst[i] := x0;
    end;
    if tmplst.Count = 0 then
      tmplst.Add(NoDataText(SectionID = 'RMND'));
    FastAssign(tmplst, DestList);
  end;

begin
  if frmFrame.DLLActive = true then exit;  
  CallV('ORWCV POLL', [Patient.DFN, IPAddr, IntToHex(AHandle, 8)]);
  with RPCBrokerV do
  begin
    tmplst := TStringList.Create;
    try
      Done := Results.Values['~Done'] = '1';
      if SubListPresent('~PROB') then AssignList(DestProb, 'PROB');
      if SubListPresent('~CWAD') then AssignList(DestCWAD, 'CWAD');
      if SubListPresent('~MEDS') then
      begin
        tmplst.Clear;
        ExtractItems(tmplst, Results, 'MEDS');
        ExtractActiveMeds(DestMeds, tmplst);
      end;
      if SubListPresent('~RMND') then
        AssignList(DestRmnd, 'RMND');
      if SubListPresent('~LABS') then AssignList(DestLabs, 'LABS');
      if SubListPresent('~VITL') then AssignList(DestVitl, 'VITL');
      if SubListPresent('~VSIT') then AssignList(DestVsit, 'VSIT');
    finally
      tmplst.Free;
    end;
  end;
end;

function NoDataText(Reminders: boolean): string;
begin
  if(Reminders) then
    Result := '0^No reminders due'
  else
    Result := '0^No data found';
end;

procedure LoadDemographics(Dest: TStrings);
begin
  CallV('ORWPT PTINQ', [Patient.DFN]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function StartCoverSheet(const IPAddress: string; const AHandle: HWND;
                         const DontDo: string; const NewReminders: boolean): string;
begin
  Result := sCallV('ORWCV START', [Patient.DFN, IPAddress, IntToHex(AHandle, 8),
                                   Encounter.Location, DontDo, NewReminders]);
end;

procedure StopCoverSheet(const ADFN, IPAddress: string; AHandle: HWND);  //*DFN*
begin
  CallV('ORWCV STOP', [ADFN, IPAddress, IntToHex(AHandle, 8)]);
end;

end.


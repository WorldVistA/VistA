unit rMeds;

{$O-}

interface

uses SysUtils, Classes, ORFn, ORNet, uCore, uConst;

type
  TMedListRec = class
  public
    PharmID:   string;
    OrderID:   string;
    Instruct:  string;
    StartDate: TFMDateTime;
    StopDate:  TFMDateTime;
    Status:    string;
    Refills:   string;
    Inpatient: Boolean;
    NonVAMed:  Boolean;
    IVFluid:   Boolean;
    SrvSeq:    Integer;
    LastFill:  TFMDateTime;
    Location:   String;
    Drug:      String;
    //Action:    Integer;
  end;

procedure ClearMedList(AList: TList);
function DetailMedLM(ID: string): TStrings;
function MedAdminHistory(OrderID: string): TStrings;
function MedStatusGroup(const s: string): Integer;
procedure LoadActiveMedLists(InPtMeds, OutPtMeds, NonVAMeds: TList; var view: integer; var DateRange: string);
function GetNewDialog: string;
function PickUpDefault: string;
procedure Refill(AnOrderID, PickUpAt: string);
function IsFirstDoseNowOrder(OrderID: string): boolean;
function GetMedStatus(MedID: TStringList): boolean;

implementation

procedure ClearMedList(AList: TList);
var
  i: Integer;
begin
  if Assigned(AList) then with AList do
  begin
    for i := 0 to Count - 1 do
      if Assigned(Items[i]) then TMedListRec(Items[i]).Free;
    Clear;
  end;
  //with AList do for i := 0 to Count - 1 do with TMedListRec(Items[i]) do Free;
  //AList.Clear;
end;

function DetailMedLM(ID: string): TStrings;
begin
  CallV('ORWPS DETAIL', [Patient.DFN, UpperCase(ID)]);
  Result := RPCBrokerV.Results;
end;

function MedAdminHistory(OrderID: string): TStrings;
begin
  CallV('ORWPS MEDHIST', [Patient.DFN, OrderID]);
  Result := RPCBrokerV.Results;
end;

function MedStatusGroup(const s: string): Integer;
const
  MG_ACTIVE  = '^ACTIVE^REFILL^HOLD^SUSPENDED^PROVIDER HOLD^ON CALL^';
  MG_PENDING = '^NON-VERIFIED^DRUG INTERACTIONS^INCOMPLETE^PENDING^';
  MG_NONACT  = '^DONE^EXPIRED^DISCONTINUED^DELETED^DISCONTINUED BY PROVIDER' +
               '^DISCONTINUED (EDIT)^REINSTATED^RENEWED^';
begin
  Result := MED_ACTIVE;
  if Pos(U+UpperCase(s)+U, MG_PENDING) > 0 then Result := MED_PENDING;
  if Pos(U+UpperCase(s)+U, MG_NONACT)  > 0 then Result := MED_NONACTIVE;
end;

procedure SetMedFields(AMed: TMedListRec; const x, y: string);
{          1     2      3     4       5     6       7       8        9      10     11
{ Pieces: Typ^PharmID^Drug^InfRate^StopDt^RefRem^TotDose^UnitDose^OrderID^Status^LastFill  }
begin
  with AMed do
  begin
    PharmID   := Piece(x, U, 2);
    OrderID   := Piece(x, U, 9);
    Instruct  := TrimRight(y);
    StopDate  := MakeFMDateTime(Piece(x, U, 5));
    Status    := MixedCase(Piece(x, U, 10));
    Refills   := Piece(x, U, 6);
   if ( Piece(Piece(x, U, 2), ';', 2) = 'I' )
       or (Piece(Piece(x, U, 2), ';', 2) = 'C') then
         Inpatient := True
     else
       Inpatient := False;
    NonVAMed  := Piece(x, U, 1) = '~NV';
    if NonVAMed then
        Instruct := 'Non-VA  ' + Instruct;
    IVFluid   := Piece(x, U, 1) = '~IV';
    SrvSeq    := 0;
    LastFill  := MakeFMDateTime(Piece(x, U, 11));
    Location  := Piece(Piece(x,U,1),':',2);
    //LocationID := StrToIntDef(Piece(Piece(x,U,1),':',3),0);
  end;
end;

function ByStatusThenStop(Item1, Item2: Pointer): Integer;
{ < 0 if Item1 is less and Item2, 0 if they are equal and > 0 if Item1 is greater than Item2 }
var
  Status1, Status2: Integer;
  loc1, loc2: string;
  Med1, Med2: TMedListRec;
begin
  Med1 := TMedListRec(Item1);
  Med2 := TMedListRec(Item2);
  loc1 := Med1.Location;
  loc2 := Med2.Location;
  Status1 := MedStatusGroup(Med1.Status);
  Status2 := MedStatusGroup(Med2.Status);
  if ( compareText(loc1,loc2)>0 ) then Result := -1
  else if ( compareText(loc1,loc2)<0 ) then Result := 1
  else if Status1 < Status2 then Result := -1
  else if Status1 > Status2 then Result := 1
  else if Med1.StopDate > Med2.StopDate then Result := -1
  else if Med1.StopDate < Med2.StopDate then Result := 1
  else if Med1.SrvSeq < Med2.SrvSeq then Result := -1
  else if Med1.SrvSeq > Med2.SrvSeq then Result := 1
  else Result := 0;
end;

function ByStatusThenLocation(Item1, Item2: Pointer): Integer;
{ < 0 if Item1 is less and Item2, 0 if they are equal and > 0 if Item1 is greater than Item2 }
var
  //Status1, Status2: Integer;
  loc1, loc2: string;
  Med1, Med2: TMedListRec;
begin
  Med1 := TMedListRec(Item1);
  Med2 := TMedListRec(Item2);
  loc1 := Med1.Location;
  loc2 := Med2.Location;
  //Status1 := MedStatusGroup(Med1.Status);
  //Status2 := MedStatusGroup(Med2.Status);
  if (compareText(Med1.Status,Med2.Status) >0) then Result := 1
  else if (compareText(Med1.Status,Med2.Status) <0) then Result := -1
  else if ( compareText(loc1,loc2)>0 ) then Result := -1
  else if ( compareText(loc1,loc2)<0 ) then Result := 1
  else if (compareText(Med1.Drug,Med2.Drug) >0) then Result := 1
  else if (compareText(Med1.Drug,Med2.Drug) <0) then Result := -1
  //else if Med1.StopDate > Med2.StopDate then Result := -1
  //else if Med1.StopDate < Med2.StopDate then Result := 1
  //else if Med1.SrvSeq < Med2.SrvSeq then Result := -1
  //else if Med1.SrvSeq > Med2.SrvSeq then Result := 1
  else Result := 0;
end;

procedure LoadActiveMedLists(InPtMeds, OutPtMeds, NonVAMeds: TList; var view: integer; var DateRange: string);
var
  idx, ASeq: Integer;
  x, y: string;
  ClinMeds, tmpInPtMeds: TList;
  AMed: TMedListRec;
begin
  //Check for CQ 9814 this should prevent an M error is DFn is not defined.
  if patient=nil then exit;
  if patient.DFN='' then exit;
  ClinMeds := TList.Create;           //IMO new
  tmpInPtMeds := TList.Create;        //IMO new
  ClearMedList(InPtMeds);
  ClearMedList(OutPtMeds);
  ClearMedList(NonVAMeds);
  CallV('ORWPS ACTIVE', [Patient.DFN, User.DUZ, view, '1']);
  ASeq := 0;
  if (view = 0) and (RPCBrokerV.Results.Count > 0) then
    view := StrToIntDef(Piece(RPCBrokerV.Results.Strings[0], U, 1), 0);
  DateRange := Piece(RPCBrokerV.Results.Strings[0], U, 2);
  with RPCBrokerV do while Results.Count > 0 do
  begin
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then Continue;        // only happens if out of synch
    y := '';
    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') do
    begin
      if CharAt(Results[0], 1) = '\' then y := y + CRLF;
      y := y + Copy(Results[0], 2, Length(Results[0])) + ' ';
      Results.Delete(0);
    end;
    AMed := TMedListRec.Create;
    SetMedFields(AMed, x, y);
    Inc(ASeq);
    AMed.SrvSeq := ASeq;
    if (AMed.Inpatient) then
    begin
      tmpInPtMeds.Add(AMed);
      //if (Copy(x,2,2)='CP') then tmpInPtMeds.Add(AMed);
     // if (Copy(x,2,2)='CP') and ((view = 2) or (view = 0)) then ClinMeds.Add(AMed)
     // else tmpInPtMeds.Add(AMed);
    end
    else
    if  AMed.NonVAMed then
        NonVAMeds.Add(AMed)
    else
       OutPtMeds.Add(AMed);
  end;
 // 12-4 if view <> 1 then ClinMeds.Sort(ByStatusThenStop);
 // 12-4 if view = 1 then tmpInPtMeds.Sort(ByStatusThenLocation)
 // 12-4 else tmpInPtMeds.Sort(ByStatusThenStop);
  //tmpInPtMeds.Sort(ByStatusThenStop);                           //IMO
 //12-4 if view <> 1 then InPtMeds.Assign(ClinMeds);
  for idx := 0 to tmpInPtMeds.Count - 1 do
    InPtMeds.Add(TMedListRec(tmpInPtMeds.Items[idx]));
  //if view <> 1 then OutPtMeds.Sort(ByStatusThenStop)
  //else OutPtMeds.Sort(ByStatusThenLocation);
 //12-4 if view <> 1 then NonVAMeds.Sort(ByStatusThenStop)
 //12-4 else NonVAMeds.Sort(ByStatusThenLocation);
  if Assigned(ClinMeds) then FreeAndNil(ClinMeds);
  if Assigned(tmpInPtMeds) then FreeAndNil(tmpInPtMeds);
end;

function GetNewDialog: string;
{ get dialog for new medications depending on patient being inpatient or outpatient }
begin
  Result := sCallV('ORWPS1 NEWDLG', [Patient.Inpatient]);
end;

function PickUpDefault: string;
{ returns 'C', 'W', or 'M' for location to pickup refill }
begin
  Result := sCallV('ORWPS1 PICKUP', [nil]);
end;

procedure Refill(AnOrderID, PickUpAt: string);
{ sends request for refill to pharmacy }
begin
  CallV('ORWPS1 REFILL', [AnOrderID, PickUpAt, Patient.DFN, Encounter.Provider, Encounter.Location]);
end;

function IsFirstDoseNowOrder(OrderID: string): boolean;
begin
  Result := SCallV('ORWDXR ISNOW',[OrderID])= '1';
end;

function GetMedStatus(MedID: TStringList): boolean;
begin
 Result := SCallV('ORWDX1 STCHANGE',[Patient.DFN, MedID])= '1';
end;

end.

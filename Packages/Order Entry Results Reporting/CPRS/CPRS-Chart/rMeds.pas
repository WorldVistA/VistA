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
    Location:  String;
    Drug:      String;
    DGroupIEN: integer;
    //Action:    Integer;
  end;

procedure ClearMedList(AList: TList);
function DetailMedLM(ID: string; aReturn: TStrings): integer;
procedure ExtractActiveMeds(Dest: TStrings; Src: TStrings);
function MedAdminHistory(OrderID: string; aReturn: TStrings): integer;
function MedStatusGroup(const s: string): Integer;
procedure LoadActiveMedLists(InPtMeds, OutPtMeds, NonVAMeds: TList; var view: integer; var DateRange: string; var DateRangeIp: string; var DateRangeOp: string);
function GetNewDialog: string;
function GetNewNonVADialog: string;
function PickUpDefault: string;
procedure Refill(AnOrderID, PickUpAt: string);
function IsFirstDoseNowOrder(OrderID: string): boolean;
function GetMedStatus(MedID: TStringList): boolean;

/////////////////////////////////////////////////////////////////////////// PaPI
function ParkOrder(AnOrderID:String):String;
function UnParkOrder(AnOrderID,PickupAt: String):String;
/////////////////////////////////////////////////////////////////////////// PaPI

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

function DetailMedLM(ID: string; aReturn: TStrings): Integer;
begin
  CallVistA('ORWPS DETAIL', [Patient.DFN, UpperCase(ID)], aReturn);
  Result := aReturn.Count;
end;

procedure ExtractActiveMeds(Dest: TStrings; Src: TStrings);
const
  MED_TYPE: array [boolean] of string = ('INPT', 'OUTPT');
var
  i: Integer;
  MedType, NonVA, x: string;
  MarkForDelete: boolean;
begin
  NonVA := 'N;';
  if Patient.Inpatient then
    begin
      if Patient.WardService = 'D' then
        MedType := 'IO' // Inpatient - DOM - show both
      else
        MedType := 'I'; // Inpatient non-DOM
    end
  else
    MedType := 'O'; // Outpatient

  for i := Src.Count - 1 downto 0 do
    begin
      MarkForDelete := False;

      // clear outpt meds if inpt, inpt meds if outpt.  Keep all for DOM patients.
      if (Pos(Piece(Piece(Src[i], U, 1), ';', 2), MedType) = 0)
        and (Piece(Src[i], U, 5) <> 'C') then
        MarkForDelete := True;

      // Non-VA Med
      if Pos(NonVA, Piece(Src[i], U, 1)) > 0 then
        begin
          MarkForDelete := False; // always display non-VA meds
          x := Src[i];
          SetPiece(x, U, 2, 'Non-VA  ' + Piece(x, U, 2));
          Src[i] := x;
        end;

      // Clin Meds
      if (Piece(Src[i], U, 5) = 'C') then
        begin
          MarkForDelete := False; // always display non-VA meds
          x := Src[i];
          SetPiece(x, U, 2, 'Clin Meds  ' + Piece(x, U, 2));
          Src[i] := x;
        end;

      // clear non-active meds   (SHOULD THIS INCLUDE PENDING ORDERS?)
      if MedStatusGroup(Piece(Src[i], U, 4)) = MED_NONACTIVE then
        MarkForDelete := True;
      if MarkForDelete then
        Src.Delete(i)
      else if MedType = 'IO' then // for DOM patients only, distinguish between inpatient/outpatient meds
        begin
          x := Src[i];
          SetPiece(x, U, 2, MED_TYPE[Piece(Piece(x, U, 1), ';', 2) = 'O'] + ' - ' + Piece(x, U, 2));
          Src[i] := x;
        end;
    end;

  if Src.Count = 0 then
    Src.Add('0^No active medications found');
  FastAssign(Src, Dest);
end;

function MedAdminHistory(OrderID: string; aReturn: TStrings): Integer;
begin
  CallVistA('ORWPS MEDHIST', [Patient.DFN, OrderID], aReturn);
  Result := aReturn.Count;
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
    DGroupIEN := StrToIntDef(Piece(x, U, 20), 0);
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

procedure LoadActiveMedLists(InPtMeds, OutPtMeds, NonVAMeds: TList;
  var view: Integer; var DateRange: string; var DateRangeIp: string;
  var DateRangeOp: string);
var
  ASeq: Integer;
  x, y: string;
  AMed: TMedListRec;
  aTmpList: TStringList;
begin
  // Check for CQ 9814 this should prevent an M error if DFN is not defined.
  if (not assigned(Patient)) or (Patient.DFN = '') then
    exit;

  ClearMedList(InPtMeds);
  ClearMedList(OutPtMeds);
  ClearMedList(NonVAMeds);

  aTmpList := TStringList.Create;
  try
    CallVistA('ORWPS ACTIVE', [Patient.DFN, User.DUZ, view, '1', 1], aTmpList);
    if aTmpList.Count > 0 then
    begin
      ASeq := 0;
      if (view = 0) then
        view := StrToIntDef(Piece(aTmpList[0], U, 1), 0);
      DateRange := Piece(aTmpList[0], U, 2);
      DateRangeIp := Piece(aTmpList[0], U, 3);
      DateRangeOp := Piece(aTmpList[0], U, 4);
      while aTmpList.Count > 0 do
      begin
        x := aTmpList[0];
        aTmpList.Delete(0);
        if CharAt(x, 1) <> '~' then
          Continue; // only happens if out of synch
        y := '';
        while (aTmpList.Count > 0) and (CharAt(aTmpList[0], 1) <> '~') do
        begin
          if CharAt(aTmpList[0], 1) = '\' then
            y := y + CRLF;
          y := y + Copy(aTmpList[0], 2, Length(aTmpList[0])) + ' ';
          aTmpList.Delete(0);
        end;
        AMed := TMedListRec.Create;
        SetMedFields(AMed, x, y);
        Inc(ASeq);
        AMed.SrvSeq := ASeq;
        if (AMed.Inpatient) then
          InPtMeds.Add(AMed)
        else if AMed.NonVAMed then
          NonVAMeds.Add(AMed)
        else
          OutPtMeds.Add(AMed);
      end;
    end;
  finally
    FreeAndNil(aTmpList);
  end;
end;

function GetNewDialog: string;
{ get dialog for new medications depending on patient being inpatient or outpatient }
begin
  CallVistA('ORWPS1 NEWDLG', [Patient.Inpatient], Result);
end;

function GetNewNonVADialog: string;
begin
  CallVista('ORWPS1 NVADLG',[], Result);
end;

function PickUpDefault: string;
{ returns 'C', 'W', or 'M' for location to pickup refill }
begin
  CallVistA('ORWPS1 PICKUP', [nil], Result);
end;

procedure Refill(AnOrderID, PickUpAt: string);
{ sends request for refill to pharmacy }
begin
  CallVistA('ORWPS1 REFILL', [AnOrderID, PickUpAt, Patient.DFN, Encounter.Provider, Encounter.Location]);
end;

function IsFirstDoseNowOrder(OrderID: string): Boolean;
var
  aStr: string;
begin
  CallVistA('ORWDXR ISNOW', [OrderID], aStr);
  Result := (aStr = '1');
end;

function GetMedStatus(MedID: TStringList): Boolean;
var
  aStr: string;
begin
  CallVistA('ORWDX1 STCHANGE', [Patient.DFN, MedID], aStr);
  Result := (aStr = '1');
end;

/////////////////////////////////////////////////////////////////////////// PaPI

function ParkOrder(AnOrderID: string): String;
var
  sl: TStringList;
  { sends request for Park to pharmacy }
begin
  // CallV('PSORPC', ['PARK',AnOrderID, 'PickUpAt', Patient.DFN, Encounter.Provider, Encounter.Location]);
  // Result := RPCBrokerV.Results.Text;
  sl := TStringList.Create;

  try
    if not CallVistA('PSORPC', ['PARK', AnOrderID, 'PickUpAt', Patient.DFN,
      Encounter.Provider, Encounter.Location], sl) then
      sl.Clear;
  except
    on E: Exception do
      sl.Clear;
  end;
  Result := {RPCBrokerV.Results} sl.Text;
  sl.Free;
end;

function UnParkOrder(AnOrderID, PickUpAt: string): String;
var
  Results: TStringList;
  { sends request for UnPark to pharmacy }
begin
  // CallV('PSORPC', ['UNPARK',AnOrderID, PickUpAt, Patient.DFN, Encounter.Provider, Encounter.Location]);
  // Result := RPCBrokerV.Results.Text;
  Results := TStringList.Create;
  try
    if not CallVistA('PSORPC', ['UNPARK', AnOrderID, PickUpAt, Patient.DFN,
      Encounter.Provider, Encounter.Location], Results) then
      Results.Clear;
  except
    on E: Exception do
      Results.Clear;
  end;
  Result := {RPCBrokerV.} Results.Text;
  Results.Free;
end;

end.

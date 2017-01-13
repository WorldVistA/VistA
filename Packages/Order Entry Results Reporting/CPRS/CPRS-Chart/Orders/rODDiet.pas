unit rODDiet;

interface

uses SysUtils, Windows, Classes, ORNet, ORFn, uCore, uConst, rOrders;

type
  TOutpatientPatchInstalled = record
    PatchInstalled: boolean;
    PatchChecked: boolean;
  end;

  TUserHasFHAUTHKey = record
    UserHasKey: boolean;
    KeyChecked: boolean;
  end;

  TDietParams = record
    Tray: Boolean;
    Cafeteria: Boolean;
    DiningRm: Boolean;
    Bagged: Boolean;
    RegIEN: Integer;
    NPOIEN: Integer;
    EarlyIEN: string;
    LateIEN: string;
    CurTF:  string;
    BTimes: string;
    NTimes: string;
    ETimes: string;
    Alarms: string;
    OPMaxDays: integer;
    OPDefaultDiet: integer;
  end;

function CurrentDietText: string;
function DietAttributes(OI: Integer): string;
function ExpandedQuantity(Product, Strength: Integer; const Qty: string): string;
procedure LoadDietParams(var DietParams: TDietParams; ALocation: string);
procedure AppendTFProducts(Dest: TStrings);
function SubSetOfDiets(const StartFrom: string; Direction: Integer): TStrings;
function SubSetOfOPDiets: TStrings;
procedure OrderLateTray(NewOrder: TOrder; Meal: Char; const MealTime: string; Bagged: Boolean);
function IsolationID: string;
function CurrentIsolation: string;
procedure LoadIsolations(Dest: TStrings);
procedure LoadDietQuickList(Dest: TStrings; const GroupID: string);
function DietDialogType(GroupIEN: Integer): Char;
function OutpatientPatchInstalled: boolean;
function UserHasFHAUTHKey: boolean;
procedure GetCurrentRecurringOPMeals(Dest: TStrings; MealType: string = '');
function OutpatientLocationConfigured(ALocation: string): boolean;
procedure CheckForDelayedDietOrders(var OutPutText: String; CurrentView: TOrderView; DispGrp: integer);

implementation

uses TRPCB, rMisc, rCore;

var
  uOutpatientPatchInstalled: TOutpatientPatchInstalled;
  uUserHasFHAUTHKey: TUserHasFHAUTHKey;

function DietAttributes(OI: Integer): string;
begin
  CallV('ORWDFH ATTR', [OI]);
  Result := RPCBrokerV.Results[0];
end;

procedure LoadDietParams(var DietParams: TDietParams; ALocation: string);
begin
  CallV('ORWDFH PARAM', [Patient.DFN, ALocation]);
  with RPCBrokerV, DietParams do
  begin
    if Results.Count > 0 then
    begin
      BTimes := Pieces(Results[0], U,  1,  6);
      NTimes := Pieces(Results[0], U,  7, 12);
      ETimes := Pieces(Results[0], U, 13, 18);
    end;
    if Results.Count > 1 then
    begin
      Alarms := Pieces(Results[1], U, 1, 6);
      Bagged := Piece(Results[1], U, 10) = 'Y';
    end;
    if Results.Count > 2 then
    begin
      Tray      := Pos('T', Results[2]) > 0;
      Cafeteria := Pos('C', Results[2]) > 0;
      DiningRm  := Pos('D', Results[2]) > 0;
      RegIEN    := StrToIntDef(Piece(Results[2], U, 2), 0);
      NPOIEN    := StrToIntDef(Piece(Results[2], U, 3), 0);
      EarlyIEN  := Piece(Results[2], U, 4);
      LateIEN   := Piece(Results[2], U, 5);
      CurTF     := Piece(Results[2], U, 6);
    end;
    if (not Tray) and (not Cafeteria) and (not DiningRm) then Tray := True;
    if Results.Count > 3 then
      OPMaxDays := StrToIntDef(Results[3], 30)
    else
      OPMaxDays := 30;
    if Results.Count > 4 then
      OPDefaultDiet := StrToIntDef(Results[4], 0)
  end;
end;

function CurrentDietText: string;
begin
  CallV('ORWDFH TXT', [Patient.DFN]);
  Result := RPCBrokerV.Results.Text;
end;

function CurrentTFText(const IENStr: string): string;
begin
end;

procedure AppendTFProducts(Dest: TStrings);
begin
  CallV('ORWDFH TFPROD', [nil]);
  FastAddStrings(RPCBrokerV.Results, Dest);
end;

function ExpandedQuantity(Product, Strength: Integer; const Qty: string): string;
begin
  Result := '';
  if (Product = 0) or (Strength = 0) or (Length(Qty) = 0) then Exit;
  Result := sCallV('ORWDFH QTY2CC', [Product, Strength, Qty]);
end;

function SubSetOfDiets(const StartFrom: string; Direction: Integer): TStrings;
{ returns a pointer to a list of orderable items matching an S.xxx cross reference (for use in
  a long list box) -  The return value is  a pointer to RPCBrokerV.Results, so the data must
  be used BEFORE the next broker call! }
begin
  CallV('ORWDFH DIETS', [StartFrom, Direction]);
  Result := RPCBrokerV.Results;
end;

function SubSetOfOPDiets: TStrings;
begin
  CallV('ORWDFH OPDIETS', [nil]);
  Result := RPCBrokerV.Results;
end;

procedure OrderLateTray(NewOrder: TOrder; Meal: Char; const MealTime: string; Bagged: Boolean);
begin
  CallV('ORWDFH ADDLATE', [Patient.DFN, Encounter.Provider, Encounter.Location, Meal, MealTime, Bagged]);
  SetOrderFromResults(NewOrder);
end;

function IsolationID: string;
begin
  Result := sCallV('ORWDFH ISOIEN', [nil]);
end;

function CurrentIsolation: string;
begin
  Result := sCallV('ORWDFH CURISO', [Patient.DFN]);
end;

procedure LoadIsolations(Dest: TStrings);
begin
  CallV('ORWDFH ISOLIST', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadDietQuickList(Dest: TStrings; const GroupID: string);
begin
  CallV('ORWDXQ GETQLST', [GroupID, 'Q']);
  FastAssign(RPCBrokerV.Results, Dest);
end;

function DietDialogType(GroupIEN: Integer): Char;
begin
  Result := CharAt(sCallV('ORWDFH FINDTYP', [GroupIEN]), 1);
  if not CharInSet(Result, ['A', 'D', 'E', 'N', 'P', 'T', 'M']) then Result := 'D';
end;

function OutpatientPatchInstalled: boolean;
begin
  with uOutpatientPatchInstalled do
    if not PatchChecked then
      begin
        //PatchInstalled := True;
        { TODO -oRich V. -cOutpatient Meals : Uncomment when available }
        PatchInstalled := (PackageVersion('FH') >= '5.5');
        PatchChecked := True;
      end;
  Result := uOutpatientPatchInstalled.PatchInstalled;
end;

function UserHasFHAUTHKey: boolean;
begin
  with uUserHasFHAUTHKey do
    if not KeyChecked then
      begin
        UserHasKey := HasSecurityKey('FHAUTH');
        KeyChecked := True;
      end;
  Result := uUserHasFHAUTHKey.UserHasKey;
end;

procedure GetCurrentRecurringOPMeals(Dest: TStrings; MealType: string = '');
begin
  CallV('ORWDFH CURRENT MEALS', [Patient.DFN, MealType]);
  FastAssign(RPCBrokerV.Results, Dest);
  MixedCaseList(Dest);
end;

function OutpatientLocationConfigured(ALocation: string): boolean;
begin
  Result := (sCallV('ORWDFH NFSLOC READY', [ALocation]) = '1');
end;

procedure CheckForDelayedDietOrders(var OutPutText: String; CurrentView: TOrderView; DispGrp: integer);
Var
 i, Z: Integer;
 AList: TList;
 EventList: TstringList;
 x, PtEvtIFN, PtEvtName: string;
const
  TX_DEL = 'There are diet orders in future events which will not be affected by this action.';
begin
  CallV('OREVNTX PAT', [Patient.DFN]);
  if RPCBrokerV.Results.Count > 1 then
  begin
   AList := TList.Create;
   EventList := TStringList.Create;
    try
     for i := 1 to RPCbrokerV.Results.Count - 1 do EventList.Add(RPCBrokerV.Results.Strings[i]);
     For i := 0 to EventList.Count - 1 do begin
      PtEvtIFN := Piece(EventList.Strings[i], '^', 1);
      PtEvtName := Piece(EventList.Strings[i], '^', 2);
      LoadOrdersAbbr(AList, CurrentView, PtEvtIFN);
      for Z := AList.Count - 1 downto 0 do
      begin
        if TOrder(Alist.Items[Z]).DGroup <> DispGrp then
        begin
          TOrder(AList.Items[Z]).Free;
          AList.Delete(Z);
        end;
      end;
      if AList.Count > 0 then
      begin
        x := '';
        RetrieveOrderFields(AList, 0, 0);
        OutPutText := OutPutText + CRLF + 'Delayed event: ' + PtEvtName;
        for Z := 0 to AList.Count - 1 do
          with TOrder(AList.Items[Z]) do
          begin
            x := x + #9 +  StringReplace(Text, #13#10, #13#10#9, [rfReplaceAll, rfIgnoreCase]) + CRLF;
          end;
        OutPutText := OutPutText + CRLF + x;
       end;
     end;
     If OutPutText > '' then OutputText := TX_DEL + CRLF + OutputText;
    finally
      EventList.Free;
      with AList do for i := 0 to Count - 1 do TOrder(Items[i]).Free;
      AList.Free;
    end;
  end;
end;


end.

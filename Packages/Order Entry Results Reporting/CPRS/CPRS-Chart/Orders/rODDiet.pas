unit rODDiet;

interface

uses SysUtils, Windows, Classes, ORNet, ORFn, uCore, uConst, rOrders, ComCtrls,
  uOrders, uWriteAccess;

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

  TDietTabInfo = record
    TabSheet: TTabSheet;
    Access: TWriteAccess.TDGWriteAccessDietetics;
  end;

  TDietTab = (dtDiet, dtOutpatientMeals, dtTubeFeeding, dtEarlyLateTray,
    dtIsolationsPrecautions, dtAdditionalOrder);

  TDietTabs = set of TDietTab;
  TDietTabArray = array [TDietTab] of TDietTabInfo;

const
  dtNone = TDietTab(-1);

function CurrentDietText: string;
function DietAttributes(OI: Integer): string;
function ExpandedQuantity(Product, Strength: Integer; const Qty: string): string;
procedure LoadDietParams(var DietParams: TDietParams; ALocation: string);
procedure AppendTFProducts(Dest: TStrings);
function SubSetOfDiets(aReturn: TStrings; const StartFrom: string; Direction: Integer): integer;
function SubSetOfOPDiets(aReturn: TStrings): integer;
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
  CallVistA('ORWDFH ATTR', [OI], Result);
end;

procedure LoadDietParams(var DietParams: TDietParams; ALocation: string);
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWDFH PARAM', [Patient.DFN, ALocation], aLst);

    if aLst.Count > 0 then
  begin
        DietParams.BTimes := Pieces(aLst[0], U, 1, 6);
        DietParams.NTimes := Pieces(aLst[0], U, 7, 12);
        DietParams.ETimes := Pieces(aLst[0], U, 13, 18);
    end;

    if aLst.Count > 1 then
    begin
        DietParams.Alarms := Pieces(aLst[1], U, 1, 6);
        DietParams.Bagged := Piece(aLst[1], U, 10) = 'Y';
    end;

    if aLst.Count > 2 then
    begin
        DietParams.Tray := Pos('T', aLst[2]) > 0;
        DietParams.Cafeteria := Pos('C', aLst[2]) > 0;
        DietParams.DiningRm := Pos('D', aLst[2]) > 0;
        DietParams.RegIEN := StrToIntDef(Piece(aLst[2], U, 2), 0);
        DietParams.NPOIEN := StrToIntDef(Piece(aLst[2], U, 3), 0);
        DietParams.EarlyIEN := Piece(aLst[2], U, 4);
        DietParams.LateIEN := Piece(aLst[2], U, 5);
        DietParams.CurTF := Piece(aLst[2], U, 6);
    end;

    if (not DietParams.Tray) and (not DietParams.Cafeteria) and (not DietParams.DiningRm) then
      DietParams.Tray := True;

    if aLst.Count > 3 then
      DietParams.OPMaxDays := StrToIntDef(aLst[3], 30)
    else
      DietParams.OPMaxDays := 30;

    if aLst.Count > 4 then
      DietParams.OPDefaultDiet := StrToIntDef(aLst[4], 0)
  finally
    FreeAndNil(aLst);
  end;
end;

function CurrentDietText: string;
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWDFH TXT', [Patient.DFN], aLst);
    Result := aLst.Text;
  finally
    FreeAndNil(aLst);
end;
end;

function CurrentTFText(const IENStr: string): string;
begin
end;

procedure AppendTFProducts(Dest: TStrings);
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    CallVistA('ORWDFH TFPROD', [nil], aLst);
    Dest.AddStrings(aLst);
  finally
    FreeAndNil(aLst);
end;
end;

function ExpandedQuantity(Product, Strength: Integer; const Qty: string): string;
begin
  if (Product = 0) or (Strength = 0) or (Length(Qty) = 0) then
    Result := ''
  else
    CallVistA('ORWDFH QTY2CC', [Product, Strength, Qty], Result);
end;

function SubSetOfDiets(aReturn: TStrings; const StartFrom: string; Direction: Integer): integer;
{ returns a list of orderable items matching an S.xxx cross reference (for use in a long list box) }
begin
  CallVistA('ORWDFH DIETS', [StartFrom, Direction], aReturn);
  Result := aReturn.Count;
end;

function SubSetOfOPDiets(aReturn: TStrings): integer;
begin
  CallVistA('ORWDFH OPDIETS', [nil], aReturn);
  Result := aReturn.Count;
end;

procedure OrderLateTray(NewOrder: TOrder; Meal: Char; const MealTime: string;
  Bagged: boolean);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('ORWDFH ADDLATE', [Patient.DFN, Encounter.Provider,
      Encounter.Location, Meal, MealTime, Bagged], sl) then
      sl.Clear

  except
    on E: Exception do
      sl.Clear;
  end;
  SetOrderFromResults(NewOrder, sl);
  sl.Free;
end;

function IsolationID: string;
begin
  CallVistA('ORWDFH ISOIEN', [nil], Result);
end;

function CurrentIsolation: string;
begin
  CallVistA('ORWDFH CURISO', [Patient.DFN], Result);
end;

procedure LoadIsolations(Dest: TStrings);
begin
  CallVistA('ORWDFH ISOLIST', [nil], Dest);
end;

procedure LoadDietQuickList(Dest: TStrings; const GroupID: string);
begin
  CallVistA('ORWDXQ GETQLST', [GroupID, 'Q'], Dest);
end;

function DietDialogType(GroupIEN: Integer): Char;
var
  aStr: string;
begin
  CallVistA('ORWDFH FINDTYP', [GroupIEN], aStr);
  Result := CharAt(aStr, 1);
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
  CallVistA('ORWDFH CURRENT MEALS', [Patient.DFN, MealType], Dest);
  MixedCaseList(Dest);
end;

function OutpatientLocationConfigured(ALocation: string): boolean;
var
  aStr: string;
begin
  CallVistA('ORWDFH NFSLOC READY', [ALocation], aStr);
  Result := (aStr = '1');
end;

procedure CheckForDelayedDietOrders(var OutPutText: string; CurrentView: TOrderView; DispGrp: Integer);
var
 i, Z: Integer;
 AList: TList;
  EventList: TStringList;
 x, PtEvtIFN, PtEvtName: string;
  aReturn: TStringList;
const
  TX_DEL = 'There are diet orders in future events which will not be affected by this action.';
begin
  aReturn := TStringList.Create;
  try
    CallVistA('OREVNTX PAT', [Patient.DFN], aReturn);
    if aReturn.Count > 1 then
  begin
   AList := TList.Create;
   EventList := TStringList.Create;
    try
          for i := 1 to aReturn.Count - 1 do EventList.Add(aReturn[i]);
          for i := 0 to EventList.Count - 1 do
            begin
      PtEvtIFN := Piece(EventList.Strings[i], '^', 1);
      PtEvtName := Piece(EventList.Strings[i], '^', 2);
      LoadOrdersAbbr(AList, CurrentView, PtEvtIFN);
      for Z := AList.Count - 1 downto 0 do
      begin
                  if TOrder(AList.Items[Z]).DGroup <> DispGrp then
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
          if OutPutText > '' then OutPutText := TX_DEL + CRLF + OutPutText;
    finally
      EventList.Free;
          with AList do
            for i := 0 to Count - 1 do TOrder(Items[i]).Free;
      AList.Free;
    end;
  end;
  finally
    FreeAndNil(aReturn);
end;
end;

end.

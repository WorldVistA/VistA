unit rODBase;

interface

uses SysUtils, Windows, Classes, ORNet, ORFn, uCore, uConst, rOrders;

type
  TPrompt = class
  public
    ID:        string;
    IEN:       Integer;
    Sequence:  Double;
    FmtCode:   string;
    Omit:      string;
    Leading:   string;
    Trailing:  string;
    NewLine:   Boolean;
    WrapWP:    Boolean;
    Children:  string;
    IsChild:   Boolean;
  end;

  TResponse = class
  public
    PromptIEN: Integer;
    PromptID:  string;
    Instance:  Integer;
    IValue:    string;
    EValue:    string;
  end;

  TDialogItem = class
  public
    ID:        string;
    Required:  Boolean;
    Hidden:    Boolean;
    Prompt:    string;
    DataType:  Char;
    Domain:    string;
    EDefault:  string;
    IDefault:  string;
    HelpText:  string;
    CrossRef:  string;
    ScreenRef: string;
  end;

  TDialogNames = record
    Internal: string;
    Display:  string;
    BaseIEN:  Integer;
    BaseName: string;
  end;

  TConstructOrder = record
    DialogName: string;
    LeadText:   string;
    TrailText:  string;
    DGroup:     Integer;
    OrderItem:  Integer;
    DelayEvent: Char;
    PTEventPtr: String;  // ptr to #100.2
    EventPtr:   String;  // ptr to #100.5
    Specialty:  Integer;
    Effective:  TFMDateTime;
    LogTime:    TFMDateTime;
    OCList: TStringList;
    DigSig:       string;
    ResponseList: TList;
    IsIMODialog:  boolean;  //imo
    IsEventDefaultOR: Integer;
  end;

  TPFSSActive = record
    PFSSActive: boolean;
    PFSSChecked: boolean;
  end;

{ General Calls }
function AskAnotherOrder(ADialog: Integer): Boolean;
function DisplayGroupByName(const AName: string): Integer;
function DisplayGroupForDialog(const DialogName: string): Integer;
procedure IdentifyDialog(var DialogNames: TDialogNames; ADialog: Integer);
procedure LoadDialogDefinition(Dest: TList; const DialogName: string);
procedure LoadOrderPrompting(Dest: TList; ADialog: Integer);
procedure LoadResponses(Dest: TList; const OrderID: string; var HasObjects: boolean;IsTitration: boolean = False);
//Modified for NSR 20071211 by KCH on 09/04/2015
procedure PutNewOrder(var AnOrder: TOrder; ConstructOrder: TConstructOrder; OrderSource: string);
//procedure PutNewOrderAuto(var AnOrder: TOrder; ADialog: Integer); // no longer used
function OIMessage(IEN: Integer): string;
function OrderMenuStyle: Integer;
function ResolveScreenRef(const ARef: string): string;
function setSubsetOfEntries(aDest:TSTrings;const StartFrom: string; Direction: Integer;
  const XRef, GblRef, ScreenRef: string): Integer;

function setSubSetOfOrderItems(aDest:TStrings;const StartFrom: string; Direction: Integer;
  const XRef: string; QuickOrderDlgIen: Integer; AccessData: string = ''): Integer;

function GetDefaultCopay(AnOrderID: string): String;
procedure SetDefaultCoPayToNewOrder(AnOrderID, CoPayInfo:string);
procedure ValidateNumericStr(const x, Dom: string; var ErrMsg: string);
function IsPFSSActive: boolean;

{ Quick Order Calls }
//function DisplayNameForOD(const InternalName: string): string;
function GetQuickName(const CRC: string): string;
procedure LoadQuickListForOD(Dest: TStrings; DGroup: Integer);
procedure SaveQuickListForOD(Src: TStrings;  DGroup: Integer);
//procedure PutQuickName(DialogIEN: Integer; const DisplayName: string);
procedure PutQuickOrder(var NewIEN: Integer; const CRC, DisplayName: string; DGroup: Integer;
  ResponseList: TList);

{ Medication Calls }
function AmountsForIVFluid(AnIEN: Integer; FluidType: Char): string;
procedure AppendMedRoutes(Dest: TStrings);

//CQ 21724 - Nurses should be able to order supplies - jcs
procedure CheckAuthForMeds(var x: string; dlgID: string = '');
function DispenseMessage(AnIEN: Integer): string;
procedure LookupRoute(const AName: string; var ID, Abbreviation: string);
function MedIsSupply(AnIEN: Integer): Boolean;
function QuantityMessage(AnIEN: Integer): string;
function RequiresCopay(DispenseDrug: Integer): Boolean;
procedure LoadFormularyAlt(AList: TStringList; AnIEN: Integer; PSType: Char);
function MedTypeIsIV(AnIEN: Integer): Boolean;
function setODForMedIn(aDest:TStrings): Integer;
function setOIForMedIn(aDest:TSTrings;AnIEN: Integer): Integer;
//function ODForIVFluids: TStrings;
function setODForIVFluids(aDest: TStrings):Integer;
//function ODForMedOut: TStrings;
function setODForMedOut(aDest: TStrings): Integer;
function setOIForMedOut(aDest:TStrings;AnIEN: Integer): Integer;
function setODForSD(aDest: TStrings): Integer;
function RatedDisabilities: string;
procedure ValidateIVRate(var x: string);
function ValidSchedule(const x: string; PSType: Char = 'I'): Integer;
function ValidQuantity(const x: string): Boolean;

{ Vitals Calls }
function setODForVitals(aDest: TStrings): Integer;

implementation

uses TRPCB, uOrders, uODBase, fODBase
  , ORNetIntf
  ;

var
  uLastDispenseIEN: Integer;
  uLastDispenseMsg: string;
  uLastQuantityMsg: string;
  uMedRoutes: TStringList;
  uPFSSActive: TPFSSActive;

{ Common Internal Calls }

procedure SetupORDIALOG(aList:iORNetMult; ResponseList: TList; IsIV: boolean = False);
const
  MAX_STR_LEN = 74;
var
  i,j,ALine,odIdx,piIdx : Integer;
  Subs, x, ODtxt, thePI: string;
  WPStrings: TStringList;
  IVDuration, IVDurVal: string;
begin
  piIdx := 0;
  odIdx := 0;
  IVDuration := '';
  IVDurVal := '';
  for j := 0 to ResponseList.Count - 1 do
  begin
    if TResponse(ResponseList.Items[j]).PromptID = 'SIG' then
    begin
      ODtxt := TResponse(ResponseList.Items[j]).EValue;
      odIdx := j;
    end;
    if TResponse(ResponseList.Items[j]).PromptID = 'PI' then
      thePI := TResponse(ResponseList.Items[j]).EValue;
    if Length(Trim(thePI)) > 0 then
      piIdx := Pos(thePI, ODtxt);
    if piIdx > 0 then
    begin
      Delete(ODtxt,piIdx,Length(thePI));
      TResponse(ResponseList.Items[odIdx]).EValue := ODtxt;
    end;
    if (IsIV and (TResponse(ResponseList.Items[j]).PromptID = 'DAYS')) then
    begin
      IVDuration := TResponse(ResponseList.Items[j]).EValue;
      if (Length(IVDuration) > 1) then
      begin
        if (Pos('TOTAL',upperCase(IVDuration))>0) or (Pos('FOR',upperCase(IVDuration))>0) then continue;
        if (Pos('H',upperCase(IVDuration))>0)  then
        begin
          IVDurVal := Copy(IVDuration,1,length(IVDuration)-1);
          TResponse(ResponseList.Items[j]).IValue := 'for ' + IVDurVal + ' hours';
        end
        else if (Pos('D',upperCase(IVDuration))>0) then
        begin
          if Pos('DOSES', upperCase(IVDuration)) > 0 then
            begin
              IVDurVal := Copy(IVDuration, 1, length(IVDuration)-5);
              TResponse(ResponseList.Items[j]).IValue := 'for a total of ' + IVDurVal + ' doses';
            end
          else
            begin
              IVDurVal := Copy(IVDuration,1,length(IVDuration)-1);
              TResponse(ResponseList.Items[j]).IValue := 'for ' + IVDurVal + ' days';
            end;
        end
        else if ((Pos('ML',upperCase(IVDuration))>0) or (Pos('CC',upperCase(IVDuration))>0)) then
        begin
          IVDurVal := Copy(IVDuration,1,length(IVDuration)-2);
          TResponse(ResponseList.Items[j]).IValue := 'with total volume ' + IVDurVal + 'ml';
        end
        else if (Pos('L',upperCase(IVDuration))>0) then
        begin
          IVDurVal := Copy(IVDuration,0,length(IVDuration)-1);
          TResponse(ResponseList.Items[j]).IValue := 'with total volume ' + IVDurVal + 'L';
        end;
      end;
    end;
  end;

  with ResponseList do for i := 0 to Count - 1 do
  begin
    with TResponse(Items[i]) do
    begin
      Subs := IntToStr(PromptIEN) + ',' + IntToStr(Instance);
      if IValue = TX_WPTYPE then
      begin
        WPStrings := TStringList.Create;
        try
          WPStrings.Text := EValue;
          LimitStringLength(WPStrings, MAX_STR_LEN);
          x := 'ORDIALOG("WP",' + Subs + ')';
          aList.AddSubscript([PromptIEN,Instance], x);
          for ALine := 0 to WPStrings.Count - 1 do
          begin
            aList.AddSubscript(['WP', PromptIEN, Instance, ALine+1, 0], WPStrings[ALine]);
          end; {for}
        finally
          WPStrings.Free;
        end; {try}
      end
      else aList.AddSubscript([PromptIEN,Instance], IValue);
    end; {with TResponse}
  end; {with AParam}
end;

{ Quick Order Calls }

//function DisplayNameForOD(const InternalName: string): string;
//begin
//  Result := sCallV('ORWDXQ DLGNAME', [InternalName]);
//end;

function GetQuickName(const CRC: string): string;
begin
  CallVistA('ORWDXQ GETQNAM', [CRC], Result);
end;

procedure LoadQuickListForOD(Dest: TStrings; DGroup: Integer);
begin
  CallVistA('ORWDXQ GETQLST', [DGroup],Dest);
end;

procedure SaveQuickListForOD(Src: TStrings;  DGroup: Integer);
begin
  CallVistA('ORWDXQ PUTQLST', [DGroup, Src]);
end;

//procedure PutQuickName(DialogIEN: Integer; const DisplayName: string);
//begin
//  CallV('ORWDXQ PUTQNAM', [DialogIEN, DisplayName]);
//  // ignore return value for now
//end;

procedure PutQuickOrder(var NewIEN: Integer; const CRC, DisplayName: string; DGroup: Integer;
  ResponseList: TList);
var
  sl: TStrings;
  aList: iORNetMult;
begin
  newORNetMult(AList);
  SetupORDIALOG(AList, ResponseList);
  sl := TStringList.Create;
  try
    CallVistA('ORWDXQ DLGSAVE', [CRC, DisplayName, DGroup, AList], sl);
    if sl.Count <> 0 then
      NewIEN := StrToIntDef(sl[0], 0);
  finally
    sl.Free;
  end;
end;

{ General Calls }

function AskAnotherOrder(ADialog: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDX AGAIN', [ADialog], s) and (s = '1');
end;

function DisplayGroupByName(const AName: string): Integer;
begin
  CallVistA('ORWDX DGNM', [AName], Result);
end;

function DisplayGroupForDialog(const DialogName: string): Integer;
begin
  CallVistA('ORWDX DGRP', [DialogName], Result);
end;

procedure IdentifyDialog(var DialogNames: TDialogNames; ADialog: Integer);
var
  x: string;
begin
  CallVistA('ORWDXM DLGNAME', [ADialog], x);
  with DialogNames do
  begin
    Internal := Piece(x, U, 1);
    Display  := Piece(x, U, 2);
    BaseIEN  := StrToIntDef(Piece(x, U, 3), 0);
    BaseName := Piece(x, U, 4);
  end;
end;

procedure LoadDialogDefinition(Dest: TList; const DialogName: string);
{ loads a list of TPrompt records
  Pieces: PromptID[1]^PromptIEN[2]^FmtSeq[3]^Fmt[4]^Omit[5]^Lead[6]^Trail[7]^NwLn[8]^Wrap[9]^Children[10]^IsChild[11] }
var
  i: Integer;
  APrompt: TPrompt;
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    CallVistA('ORWDX DLGDEF', [DialogName], Results);
    for i := 0 to Results.Count - 1 do
    begin
      APrompt := TPrompt.Create;
      with APrompt do
      begin
        ID := Piece(Results[i], U, 1);
        IEN := StrToIntDef(Piece(Results[i], U, 2), 0);
        if Length(Piece(Results[i], U, 3)) > 0 then
          Sequence := StrToFloat(Piece(Results[i], U, 3))
        else
          Sequence := 0;
        FmtCode := Piece(Results[i], U, 4);
        Omit := Piece(Results[i], U, 5);
        Leading := Piece(Results[i], U, 6);
        Trailing := Piece(Results[i], U, 7);
        NewLine := Piece(Results[i], U, 8) = '1';
        WrapWP := Piece(Results[i], U, 9) = '1';
        Children := Piece(Results[i], U, 10);
        IsChild := Piece(Results[i], U, 11) = '1';
      end;
      Dest.Add(APrompt);
    end;

  finally
    Results.Free;
  end;
end;

procedure LoadOrderPrompting(Dest: TList; ADialog: Integer);
// ID^REQ^HID^PROMPT^TYPE^DOMAIN^DEFAULT^IDFLT^HELP
var
  i: Integer;
  DialogItem: TDialogItem;
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    CallVistA('ORWDXM PROMPTS', [ADialog], Results);
    DialogItem := nil;
    for i := 0 to Results.Count - 1 do
    begin
      if CharAt(Results[i], 1) = '~' then
      begin
        DialogItem := TDialogItem.Create; // create a new dialog item
        with DialogItem do
        begin
          Results[i] := Copy(Results[i], 2, Length(Results[i]));
          ID := Piece(Results[i], U, 1);
          Required := Piece(Results[i], U, 2) = '1';
          Hidden := Piece(Results[i], U, 3) = '1';
          Prompt := Piece(Results[i], U, 4);
          DataType := CharAt(Piece(Results[i], U, 5), 1);
          Domain := Piece(Results[i], U, 6);
          EDefault := Piece(Results[i], U, 7);
          IDefault := Piece(Results[i], U, 8);
          HelpText := Piece(Results[i], U, 9);
          CrossRef := Piece(Results[i], U, 10);
          ScreenRef := Piece(Results[i], U, 11);
          if Hidden then
            DataType := 'H'; // if hidden, use 'Hidden' type
        end;
        Dest.Add(DialogItem);
      end;
      if (CharAt(Results[i], 1) = 't') and (DialogItem <> nil) then
      // use last DialogItem
        with DialogItem do
          EDefault := EDefault + Copy(Results[i], 2, Length(Results[i])) + CRLF;
    end;
  finally
    Results.Free;
  end;
end;

procedure ExtractToResponses(TempBroker: TStrings; Dest: TList; var HasObjects: boolean);
{ load a list with TResponse records, assumes source strings are in RPCBrokerV.Results }
var
  i: Integer;
  AResponse: TResponse;
  WPContainsObjects, TxContainsObjects: boolean;
begin
  i := 0;
  HasObjects := FALSE;
  with TempBroker do while i < Count do
  begin
    if CharAt(Strings[i], 1) = '~' then
    begin
      AResponse := TResponse.Create;
      with AResponse do
      begin
        PromptIEN := StrToIntDef(Piece(Copy(Strings[i], 2, 255), U, 1), 0);
        Instance := StrToIntDef(Piece(Strings[i], U, 2), 0);
        PromptID := Piece(Strings[i], U, 3);
        Inc(i);
        while (i < Count) and (CharAt(Strings[i], 1) <> '~') do
        begin
          if CharAt(Strings[i], 1) = 'i' then IValue := Copy(Strings[i], 2, 255);
          if CharAt(Strings[i], 1) = 'e' then EValue := Copy(Strings[i], 2, 255);
          if CharAt(Strings[i], 1) = 't' then
          begin
            if Length(EValue) > 0 then EValue := EValue + CRLF;
            EValue := EValue + Copy(Strings[i], 2, 255);
            IValue := TX_WPTYPE;  // signals that this is a word processing field
          end;
          Inc(i);
        end; {while i}
        if IValue <> TX_WPTYPE then ExpandOrderObjects(IValue, TxContainsObjects);
        ExpandOrderObjects(EValue, WPContainsObjects);
        HasObjects := HasObjects or WPContainsObjects or TxContainsObjects;
        if Assigned(frmODBase) then begin
          if AResponse.PromptID = 'OVERRIDE' then frmODBase.Responses.Reason := EValue;
          if AResponse.PromptID = 'ORREMCOMMENT' then frmODBase.Responses.RemComment := EValue;
        end;
        Dest.Add(AResponse);
      end; {with AResponse}
    end; {if CharAt}
  end; {With RPCBrokerV}
end;

procedure LoadResponses(Dest: TList; const OrderID: string; var HasObjects: boolean;
                        IsTitration: boolean = False);
var
  Transfer: Boolean;
  sl: TStrings;
begin
  if ((XferOuttoInOnMeds = True) or (XfInToOutNow = True)) and
    (CharAt(OrderID, 1) = 'C') then
    Transfer := True
  else
    Transfer := False;
  sl := TStringList.Create;
  try
    CallVistA('ORWDX LOADRSP', [OrderID, Transfer, IsTitration.ToInteger], sl);
    ExtractToResponses(sl, Dest, HasObjects);
  finally
    sl.Free;
  end;
end;

//Modified for NSR 20071211 by KCH on 09/04/2015
procedure PutNewOrder(var AnOrder: TOrder; ConstructOrder: TConstructOrder; OrderSource: string);
var
  inc, len, numLoop, remain: Integer;
  ocStr, tmpStr, x, y, z, p1, p3: string;

  sTime:String;
  aList: iORNetMult;
  Results: TStrings;

  procedure setListParam;
  var
    i: Integer;
  begin
    if Length(ConstructOrder.LeadText)  > 0
      then aList.AddSubscript(['ORLEAD'], ConstructOrder.LeadText);
    if Length(ConstructOrder.TrailText) > 0
      then aList.AddSubscript(['ORTRAIL'], ConstructOrder.TrailText);
    aList.AddSubscript(['ORCHECK'], ConstructOrder.OCList.Count);
    with ConstructOrder do for i := 0 to OCList.Count - 1 do
    begin
      // put quotes around everything to prevent broker from choking
//      y := '"ORCHECK","' + Piece(OCList[i], U, 1) + '","' + Piece(OCList[i], U, 3) +
//        '","' + IntToStr(i+1) + '"';
      p1 := Piece(OCList[i], U, 1);
      p3 := Piece(OCList[i], U, 3);
      OCStr :=  Pieces(OCList[i], U, 2, 4);
      len := Length(OCStr);
      if len > 255 then
        begin
          numLoop := len div 255;
          remain := len mod 255;
          inc := 0;
          while inc <= numLoop do
            begin
              tmpStr := Copy(OCStr, 1, 255);
              OCStr := Copy(OCStr, 256, Length(OcStr));
              aList.AddSubscript(['ORCHECK',p1,p3,i+1, inc], tmpStr);
              inc := inc +1;
            end;
          if remain > 0 then  aList.AddSubscript(['ORCHECK',p1,p3, i+1, inc], OCStr);
        end
      else
       aList.AddSubscript(['ORCHECK',p1,p3, i+1], OCStr); //Modified for NSR 20071211 by KCH on 09/04/2015
    end;
    if CharInSet(ConstructOrder.DelayEvent, ['A','D','T','M','O']) then
      aList.AddSubscript(['OREVENT'], ConstructOrder.PTEventPtr);
    if ConstructOrder.LogTime > 0
      then aList.AddSubscript(['ORSLOG'], ConstructOrder.LogTime);
    aList.AddSubscript(['ORTS'], Patient.Specialty);  // pass in treating specialty for ORTS
    aList.AddSubscript(['OVERRIDE'], frmODBase.Responses.Reason);  //for NSR 20071211 10/08/2015 KCH See if we can make this work
    aList.AddSubscript(['ORREMCOMMENT'], frmODBase.Responses.RemComment);  //for NSR 20071211 10/08/2015 KCH See if we can make this work
  end;

begin
  NewORNetMult(aList);
  if (ConstructOrder.DGroup = IVDisp) or (ConstructOrder.DGroup = ClinIVDisp) or (ConstructOrder.DialogName = 'PSJI OR PAT FLUID OE') then
    SetupORDIALOG(aList, ConstructOrder.ResponseList, True)
  else
    SetupORDIALOG(aList, ConstructOrder.ResponseList);
  setListParam;
  sTime := '';
  if (Constructorder.IsIMODialog) or
    (ConstructOrder.DGroup = ClinDisp) or (ConstructOrder.DGroup = ClinIVDisp) then
    sTime := FloatToStr(Encounter.DateTime);

  Results := TStringList.Create;
  try
    if CallVistA('ORWDX SAVE', [Patient.DFN, Encounter.Provider,
      Encounter.Location, ConstructOrder.DialogName, ConstructOrder.DGroup,
      ConstructOrder.OrderItem, AnOrder.EditOf, AList, ConstructOrder.DigSig,
      sTime, OrderSource, ConstructOrder.IsEventDefaultOR], Results) then
      uAllergyCacheCreated := False;

    if Results.Count = 0 then
      Exit; // error creating order
    x := Results[0];
    Results.Delete(0);
    y := '';

    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and
      (CharAt(Results[0], 1) <> '|') do
    begin
      y := y + Copy(Results[0], 2, Length(Results[0])) + CRLF;
      Results.Delete(0);
    end;
    if Length(y) > 0 then
      y := Copy(y, 1, Length(y) - 2); // take off last CRLF
    z := '';
    if (Results.Count > 0) and (Results[0] = '|') then
    begin
      Results.Delete(0);
      while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and
        (CharAt(Results[0], 1) <> '|') do
      begin
        z := z + Copy(Results[0], 2, Length(Results[0]));
        Results.Delete(0);
      end;
    end;
    SetOrderFields(AnOrder, x, y, z);
  finally
    Results.Free;
  end;
end;

{ no longer used -
procedure PutNewOrderAuto(var AnOrder: TOrder; ADialog: Integer);
var
  i: Integer;
  y: string;
begin
  CallV('ORWDXM AUTOACK', [Patient.DFN, Encounter.Provider, Encounter.Location, ADialog]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    y := '';
    for i := 1 to Results.Count - 1 do
      y := y + Copy(Results[i], 2, Length(Results[i])) + CRLF;
    if Length(y) > 0 then y := Copy(y, 1, Length(y) - 2);  // take off last CRLF
    SetOrderFields(AnOrder, Results[0], y);
  end;
end;
}

function OIMessage(IEN: Integer): string;
var
  sl: TSTrings;
begin
  sl := TSTringList.Create;
  try
    CallVistA('ORWDX MSG', [IEN], sl);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function OrderMenuStyle: Integer;
begin
  CallVistA('ORWDXM MSTYLE', [nil], Result);
end;

function ResolveScreenRef(const ARef: string): string;
begin
  CallVistA('ORWDXM RSCRN', [ARef], Result);
end;

function setSubSetOfOrderItems(aDest:TStrings;const StartFrom: string; Direction: Integer;
  const XRef: string; QuickOrderDlgIen: Integer; AccessData: string = ''): Integer;
{ returns a pointer to a list of orderable items matching an S.xxx cross reference (for use in
  a long list box) -  The return value is  a pointer to RPCBrokerV.Results, so the data must
  be used BEFORE the next broker call! }
begin
  CallVistA('ORWDX ORDITM', [StartFrom, Direction, XRef, QuickOrderDlgIen, AccessData], aDest);
  Result := aDest.Count;
end;

function GetDefaultCopay(AnOrderID: string): String;
var
  aList: iORNetMult;
  sl: TStrings;
begin
  newORNetMult(aList);
  sl := TSTringList.Create;
  try
    aList.AddSubscript(['1'], AnOrderID);
    CallVistA('ORWDPS4 CPLST',[Patient.DFN,aList],sl);
    if sl.Count > 0 then
      Result := sl[0]
    else
      Result := '';
  finally
    sl.Free;
  end;
end;

procedure SetDefaultCoPayToNewOrder(AnOrderID, CoPayInfo:string);
var
  temp,CPExems: string;
  CoPayValue: array [1..7] of Char;
  i: integer;
begin
  // SC AO IR EC MST HNC CV
  CoPayValue[1] := 'N';
  CoPayValue[2] := 'N';
  CoPayValue[3] := 'N';
  CoPayValue[4] := 'N';
  CoPayValue[5] := 'N';
  CoPayValue[6] := 'N';
  CoPayValue[7] := 'N';
  temp := Pieces(CoPayInfo,'^',2,6);
  i := 1;
  while Length(Piece(temp,'^',i))>0 do
  begin
    if Piece(Piece(temp,'^',i),';',1) = 'SC' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[1] := 'C'
      else
        CopayValue[1] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'AO' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[2] := 'C'
      else
        CopayValue[2] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'IR' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[3] := 'C'
      else
        CopayValue[3] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'EC' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[4] := 'C'
      else
        CopayValue[4] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'MST' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[5] := 'C'
      else
        CopayValue[5] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'HNC' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[6] := 'C'
      else
        CopayValue[6] := 'U';
    end;
    if Piece(Piece(temp,'^',i),';',1) = 'CV' then
    begin
      if Piece( Piece(temp,'^',i),';',2) = '1' then
        CoPayValue[7] := 'C'
      else
        CopayValue[7] := 'U';
    end;
    i := i + 1;
  end;
  CPExems := CoPayValue[1] + CoPayValue[2] + CoPayValue[3] + CoPayValue[4]
           + CoPayValue[5] + CoPayValue[6] + CoPayValue[7];
  CPExems := AnOrderId + '^' + CPExems;
  LockBroker;
  try
    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORWDPS4 CPINFO';
      Param[0].PType := list;
      Param[0].Mult['1'] := CPExems;
      CallBroker;
    end;
  finally
    UnlockBroker;
  end;  
end;

function setSubsetOfEntries(aDest:TStrings;const StartFrom: string; Direction: Integer;
  const XRef, GblRef, ScreenRef: string): Integer;
{ returns a pointer to a list of file entries (for use in a long list box) -
  The return value is  a pointer to RPCBrokerV.Results, so the data must
  be used BEFORE the next broker call! }
begin
  CallVistA('ORWDOR LKSCRN', [StartFrom, Direction, XRef, GblRef, ScreenRef],aDest);
  Result := aDest.Count;
end;

procedure ValidateNumericStr(const x, Dom: string; var ErrMsg: string);
begin
  CallVistA('ORWDOR VALNUM', [x, Dom], ErrMsg);
  if ErrMsg = '0' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

function IsPFSSActive: boolean;
var
  s: String;
begin
  with uPFSSActive do
    if not PFSSChecked then
      begin
        PFSSActive := CallVistA('ORWPFSS IS PFSS ACTIVE?', [nil], s) and (s = '1');
        PFSSChecked := True;
      end;
  Result := uPFSSActive.PFSSActive
end;

{ Medication Calls }

procedure AppendMedRoutes(Dest: TStrings);
var
  i: Integer;
  x: string;
  Results: TStrings;
begin
  if uMedRoutes = nil then
  begin
    Results := TStringList.Create;
    try
      CallVistA('ORWDPS32 ALLROUTE', [nil], Results);
      uMedRoutes := TStringList.Create;
      FastAssign(Results, uMedRoutes);
      for i := 0 to Results.Count - 1 do if Length(Piece(Results[i], U, 3)) > 0 then
      begin
        x := Piece(Results[i], U, 1) + U + Piece(Results[i], U, 3) +
             ' (' + Piece(Results[i], U, 2) + ')' + U + Piece(Results[i], U, 3);
        uMedRoutes.Add(x);
      end; {if Length}
      SortByPiece(uMedRoutes, U, 2);
    finally
      Results.Free;
    end;
  end; {if uMedRoutes}
  FastAddStrings(uMedRoutes, Dest);
end;

procedure CheckAuthForMeds(var x: string; dlgID: string = '');
begin
  //CQ 21724 - Nurses should be able to order supplies, pass in dlgID
  //from fODMeds - jcs
  CallVistA('ORWDPS32 AUTH', [Encounter.Provider, dlgID],x);
  x := Piece(x, U, 2);
end;

function DispenseMessage(AnIEN: Integer): string;
var
  x: string;
begin
  if AnIEN = uLastDispenseIEN then Result := uLastDispenseMsg else
  begin
    CallVistA('ORWDPS32 DRUGMSG', [AnIEN], x);
    uLastDispenseIEN := AnIEN;
    uLastDispenseMsg := Piece(x, U, 1);
    uLastQuantityMsg := Piece(x, U, 2);
    Result := uLastDispenseMsg;
  end;
end;

function QuantityMessage(AnIEN: Integer): string;
var
  x: string;
begin
  if AnIEN = uLastDispenseIEN then Result := uLastQuantityMsg else
  begin
    CallVistA('ORWDPS32 DRUGMSG', [AnIEN], x);
    uLastDispenseIEN := AnIEN;
    uLastDispenseMsg := Piece(x, U, 1);
    uLastQuantityMsg := Piece(x, U, 2);
    Result := uLastQuantityMsg;
  end;
end;

function RequiresCopay(DispenseDrug: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS32 SCSTS', [Patient.DFN, DispenseDrug],s) and (s = '1');
end;

procedure LoadFormularyAlt(AList: TStringList; AnIEN: Integer; PSType: Char);
begin
  CallVistA('ORWDPS32 FORMALT', [AnIEN, PSType], aList);
end;

procedure LookupRoute(const AName: string; var ID, Abbreviation: string);
var
  x: string;
begin
  CallVistA('ORWDPS32 VALROUTE', [AName], x);
  ID := Piece(x, U, 1);
  Abbreviation := Piece(x, U, 2);
end;

function MedIsSupply(AnIEN: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS32 ISSPLY', [AnIEN], s) and (s = '1');
end;

function MedTypeIsIV(AnIEN: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS32 MEDISIV', [AnIEN], s) and (s = '1');
end;

function setODForMedIn(aDest:TStrings): Integer;
{ Returns init values for inpatient meds dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDPS32 DLGSLCT', [PST_UNIT_DOSE, patient.dfn, patient.location], aDest);
  Result := aDest.Count;
end;

function setODForIVFluids(aDest: TStrings): Integer;
{ Returns init values for IV Fluids dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDPS32 DLGSLCT', [PST_IV_FLUIDS, patient.dfn, patient.location],aDest);
  Result := aDest.Count;
end;

function AmountsForIVFluid(AnIEN: Integer; FluidType: Char): string;
begin
  CallVistA('ORWDPS32 IVAMT', [AnIEN, FluidType], Result);
end;

function setODForMedOut(aDest: TStrings): Integer;
{ Returns init values for outpatient meds dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDPS32 DLGSLCT', [PST_OUTPATIENT, patient.dfn, patient.location],aDest);
  Result := aDest.Count;
end;

function setOIForMedIn(aDest:TStrings;AnIEN: Integer): Integer;
{ Returns init values for inpatient meds order item.  The results must be used immediately. }
begin
  CallVistA('ORWDPS32 OISLCT', [AnIEN, PST_UNIT_DOSE, Patient.DFN],aDest);
  Result := aDest.Count;
end;

function setOIForMedOut(aDest: TSTrings; AnIEN: Integer): Integer;
{ Returns init values for outpatient meds order item.  The results must be used immediately. }
begin
  CallVistA('ORWDPS32 OISLCT', [AnIEN, PST_OUTPATIENT, Patient.DFN],aDest);
  Result := aDest.Count;
end;

function setODForSD(aDest: TStrings):Integer;
begin
  CallVistA('ORWDSD1 ODSLCT', [PATIENT.DFN, Encounter.Location],aDest);
  Result := aDest.Count;
end;

function RatedDisabilities: string;
{ Returns a list of rated disabilities, if any, for a patient }
var
  sl:TSTrings;
begin
  sl := TSTringList.Create;
  try
    CallVistA('ORWPCE SCDIS', [Patient.DFN], sl);
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

procedure ValidateIVRate(var x: string);
begin
  CallVistA('ORWDPS32 VALRATE', [x], x);
end;

//function ValidIVRate(const x: string): Boolean;
//{ returns true if the text entered as the IV rate is valid }
//begin
//  Result := sCallV('ORWDPS32 VALRATE', [x]) = '1';
//end;

function ValidSchedule(const x: string; PSType: Char = 'I'): Integer;
{ returns 1 if schedule is valid, 0 if schedule is not valid, -1 pharmacy routine not there }
begin
  CallVistA('ORWDPS32 VALSCH', [x, PSType], Result, -1);
end;

function ValidQuantity(const x: string): Boolean;
var
  s: String;
{ returns true if the text entered as the quantity is valid }
begin
  Result := CallVistA('ORWDPS32 VALQTY', [Trim(x)], s) and (s = '1');
end;

//function ODForVitals: TStrings;
function setODForVitals(aDest: TStrings): Integer;
{ Returns init values for vitals dialog.  The results must be used immediately. }
begin
  CallVistA('ORWDOR VMSLCT', [nil], aDest);
  Result := aDest.Count;
end;

initialization
  uLastDispenseIEN := 0;
  uLastDispenseMsg := '';

finalization
  if uMedRoutes <> nil then uMedRoutes.Free;

end.

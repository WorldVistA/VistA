unit rOrders;
{$OPTIMIZATION OFF}
interface

uses SysUtils, Classes, ORFn, ORNet, uCore, Dialogs, Controls;

type
  TOrder = class
  public
    ICD9Code:      string;
    ID:           string;
    DGroup:       Integer;
    OrderTime:    TFMDateTime;
    StartTime:    string;
    StopTime:     string;
    Status:       Integer;
    Signature:    Integer;
    VerNurse:     string;
    VerClerk:     string;
    ChartRev:     string;
    Provider:     Int64;
    ProviderName: string;
    ProviderDEA:  string;
    ProviderVa:   string;
    DigSigReq:    string;
    XMLText:      string;
    Text:         string;
    DGroupSeq:    Integer;
    DGroupName:   string;
    Flagged:      Boolean;
    Retrieved:    Boolean;
    EditOf:       string;
    ActionOn:     string;
    EventPtr:     string; //ptr to #100.2
    EventName:    string; //Event name in #100.5
    OrderLocIEN:  string; //imo
    OrderLocName: string; //imo
    ParentID    : string;
    LinkObject:   TObject;
    EnteredInError:     Integer; //AGP Changes 26.12 PSI-04-053
    DCOriginalOrder: boolean;
    IsOrderPendDC: boolean;
    IsDelayOrder: boolean;
    IsControlledSubstance: boolean;
    IsDetox       : boolean;
    procedure Assign(Source: TOrder);
    procedure Clear;
  end;

  TParentEvent = class
  public
    ParentIFN:  integer;
    ParentName: string;
    ParentType: Char;
    ParentDlg:  string;
    constructor Create;
    procedure Assign(AnEvtID: string);
  end;

  TOrderDelayEvent = record
    EventType: Char;             // A=admit, T=transfer, D=discharge, C=current
    TheParent: TParentEvent;     // Parent Event
    EventIFN : Integer;          // Pointer to OE/RR EVENTS file (#100.5)
    EventName: String;           // Event name from OR/RR EVENTS file (#100.5)
    PtEventIFN: Integer;         // Patient event IFN ptr to #100.2
    Specialty: Integer;          // pointer to facility treating specialty file
    Effective: TFMDateTime;      // effective date/time (estimated start time)
    IsNewEvent: Boolean;         // is new event for an patient
  end;

  TOrderDialogResolved = record
    InputID: string;             // can be dialog IEN or '#ORIFN'
    QuickLevel: Integer;         // 0=dialog,1=auto,2=verify,8=reject,9=cancel
    ResponseID: string;          // DialogID + ';' + $H
    DialogIEN: Integer;          // pointer to 101.41 for dialog (may be quick order IEN)
    DialogType: Char;            // type of dialog (Q or D)
    FormID: Integer;             // windows form to display
    DisplayGroup: Integer;       // pointer to 100.98, display group for dialog
    ShowText: string;            // text to show for verify or rejection
    QOKeyVars: string;           // from entry action of quick order
  end;

  TNextMoveRec = record
    NextStep:     Integer;
    LastIndex:    Integer;
  end;

  TOrderMenu = class
    IEN: Integer;
    NumCols: Integer;
    Title: string;
    KeyVars: string;
    MenuItems: TList; {of TOrderMenuItem}
  end;

  TOrderMenuItem = class
    IEN: Integer;
    Row: Integer;
    Col: Integer;
    DlgType: Char;
    FormID: Integer;
    AutoAck: Boolean;
    ItemText: string;
    Mnemonic: string;
    Display: Integer;
    Selected: Boolean;
  end;

  TSelectedOrder = class
  public
    Position: Integer;
    Order: TOrder;
  end;

  TOrderRenewFields = class
  public
    BaseType:  Integer;
    StartTime: string;
    StopTime:  string;
    Refills:   Integer;
    Pickup:    string;
    Comments:  string;
    NewText:   string;
  end;

  TPrintParams = record
    PromptForChartCopy    :  char;
    ChartCopyDevice       :  string;
    PromptForLabels       :  char;
    LabelDevice           :  string;
    PromptForRequisitions :  char;
    RequisitionDevice     :  string;
    PromptForWorkCopy     :  char;
    WorkCopyDevice        :  string;
    AnyPrompts            :  boolean;
//    OrdersToPrint         :  TStringList; {*KCM*}
  end;

  TOrderView = class
    Changed:    Boolean;                         // true when view has been modified
    DGroup:     Integer;                         // display group (pointer value)
    Filter:     Integer;                         // FLGS parameter passed to ORQ
    InvChrono:  Boolean;                         // true for inverse chronological order
    ByService:  Boolean;                         // true for grouping orders by service
    TimeFrom:   TFMDateTime;                     // beginning time for orders in list
    TimeThru:   TFMDateTime;                     // ending time for orders in list
    CtxtTime:   TFMDateTime;                     // set by server, context hours begin time
    TextView:   Integer;                         // set by server, 0 if mult views of same order
    ViewName:   string;                          // display name for the view
    EventDelay: TOrderDelayEvent;                // fields for event delay view
  public
    procedure Assign(Src: TOrderView);

  end;

{ Order List functions }
function DetailOrder(const ID: string): TStrings;
function ResultOrder(const ID: string): TStrings;
function ResultOrderHistory(const ID: string): TStrings;
function NameOfStatus(IEN: Integer): string;
function GetOrderStatus(AnOrderId: string): integer;
function ExpiredOrdersStartDT: TFMDateTime;
procedure ClearOrders(AList: TList);
procedure LoadOrders(Dest: TList; Filter, Groups: Integer);
procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; APtEvtID: string); overload;
procedure LoadOrdersAbbr(DestDC,DestRL: TList; AView: TOrderView; APtEvtID: string); overload;
procedure LoadOrdersAbbr(Dest:Tlist; AView: TOrderView; AptEvtID: string; AlertID: string); overload;
procedure LoadOrderSheets(Dest: TStrings);
procedure LoadOrderSheetsED(Dest: TStrings);
procedure LoadOrderViewDefault(AView: TOrderView);
procedure LoadUnsignedOrders(IDList, HaveList: TStrings);
procedure SaveOrderViewDefault(AView: TOrderView);
procedure RetrieveOrderFields(OrderList: TList; ATextView: Integer; ACtxtTime: TFMDateTime);
procedure SetOrderFields(AnOrder: TOrder; const x, y, z: string);
procedure SetOrderFromResults(AnOrder: TOrder);
procedure SortOrders(AList: TList; ByGroup, InvChron: Boolean);
procedure ConvertOrders(Dest: TList; AView: TOrderView);

{ Display Group & List functions }
function DGroupAll: Integer;
function DGroupIEN(AName: string): Integer;
procedure ListDGroupAll(Dest: TStrings);
procedure ListSpecialties(Dest: TStrings);
procedure ListSpecialtiesED(AType: Char; Dest: TStrings);
procedure ListOrderFilters(Dest: TStrings);
procedure ListOrderFiltersAll(Dest: TStrings);
function NameOfDGroup(IEN: Integer): string;
function ShortNameOfDGroup(IEN: Integer): string;
function SeqOfDGroup(IEN: Integer): Integer;
function CheckOrderGroup(AOrderID: string): integer;
function CheckQOGroup(AQOId:string): Boolean;

{ Write Orders }
procedure BuildResponses(var ResolvedDialog: TOrderDialogResolved; const KeyVars: string;
  AnEvent: TOrderDelayEvent; ForIMO: boolean = False);
procedure ClearOrderRecall;
function CommonLocationForOrders(OrderList: TStringList): Integer;
function FormIDForDialog(IEN: Integer): Integer;
function DlgIENForName(DlgName: string): Integer;
procedure LoadOrderMenu(AnOrderMenu: TOrderMenu; AMenuIEN: Integer);
procedure LoadOrderSet(SetItems: TStrings; AnIEN: Integer; var KeyVars, ACaption: string);
procedure LoadWriteOrders(Dest: TStrings);
procedure LoadWriteOrdersED(Dest: TStrings; EvtID: string);
function OrderDisabledMessage(DlgIEN: Integer): string;
procedure SendOrders(OrderList: TStringList; const ESCode: string);
procedure SendReleaseOrders(OrderList: TStringList);
procedure SendAndPrintOrders(OrderList, ErrList: TStrings; const ESCode: string; const DeviceInfo: string);
procedure ExecutePrintOrders(SelectedList: TStringList; const DeviceInfo: string);
procedure PrintOrdersOnReview(OrderList: TStringList; const DeviceInfo: string; PrintLoc: Integer = 0);  {*KCM*}
procedure PrintServiceCopies(OrderList: TStringList; PrintLoc: Integer = 0);  {*REV*}
procedure OrderPrintDeviceInfo(OrderList: TStringList; var PrintParams: TPrintParams; Nature: Char; PrintLoc: Integer = 0); {*KCM*}
function UseNewMedDialogs: Boolean;

{ Order Actions }
function DialogForOrder(const ID: string): Integer;
procedure LockPatient(var ErrMsg: string);
procedure UnlockPatient;
procedure LockOrder(OrderID: string; var ErrMsg: string);
procedure UnlockOrder(OrderID: string);
function FormIDForOrder(const ID: string): Integer;
procedure ValidateOrderAction(const ID, Action: string; var ErrMsg: string);
procedure ValidateOrderActionNature(const ID, Action, Nature: string; var ErrMsg: string);
procedure IsLatestAction(const ID: string; var ErrList: TStringList);
procedure ChangeOrder(AnOrder: TOrder; ResponseList: TList);
procedure RenewOrder(AnOrder: TOrder; RenewFields: TOrderRenewFields; IsComplex: integer;
  AnIMOOrderAppt: double; OCList: TStringList);
procedure HoldOrder(AnOrder: TOrder);
procedure ListDCReasons(Dest: TStrings; var DefaultIEN: Integer);
function GetREQReason: Integer;
procedure DCOrder(AnOrder: TOrder; AReason: Integer; NewOrder: boolean; var DCType: Integer);
procedure ReleaseOrderHold(AnOrder: TOrder);
procedure AlertOrder(AnOrder: TOrder; AlertRecip: Int64);
procedure FlagOrder(AnOrder: TOrder; const FlagReason: string; AlertRecip: Int64);
procedure UnflagOrder(AnOrder: TOrder; const AComment: string);
procedure LoadFlagReason(Dest: TStrings; const ID: string);
procedure LoadWardComments(Dest: TStrings; const ID: string);
procedure PutWardComments(Src: TStrings; const ID: string; var ErrMsg: string);
procedure CompleteOrder(AnOrder: TOrder; const ESCode: string);
procedure VerifyOrder(AnOrder: TOrder; const ESCode: string);
procedure VerifyOrderChartReview(AnOrder: TOrder; const ESCode: string);
function GetOrderableIen(AnOrderId:string): integer;
procedure StoreDigitalSig(AID, AHash: string; AProvider: Int64; ASig, ACrlUrl, DFN: string; var AError: string);
procedure UpdateOrderDGIfNeeded(AnID: string);
function CanEditSuchRenewedOrder(AnID: string; IsTxtOrder: integer): boolean;
function IsPSOSupplyDlg(DlgID, QODlg: integer): boolean;
procedure SaveChangesOnRenewOrder(var AnOrder: TOrder; AnID, TheRefills, ThePickup: string; IsTxtOrder: integer);
function DoesOrderStatusMatch(OrderArray: TStringList): boolean;
//function GetPromptandDeviceParameters(Location: integer; OrderList: TStringList; Nature: string): TPrintParams;

{ Order Information }
procedure LoadRenewFields(RenewFields: TOrderRenewFields; const ID: string);
procedure GetChildrenOfComplexOrder(AnParentID,CurrAct: string; var ChildList: TStringList); //PSI-COMPLEX
procedure LESValidationForChangedLabOrder(var RejectedReason: TStringList; AnOrderInfo: string);
procedure ValidateComplexOrderAct(AnOrderID: string; var ErrMsg: string); //PSI-COMPLEX
function IsRenewableComplexOrder(AnParentID: string): boolean; //PSI-COMPLEX
function IsComplexOrder(AnOrderID: string): boolean; //PSI-COMPLEX
function GetDlgData(ADlgID: string): string;
function OrderIsReleased(const ID: string): Boolean;
function TextForOrder(const ID: string): string;
function GetConsultOrderNumber(ConsultIEN: string): string;
function GetOrderByIFN(const ID: string): TOrder;
function GetPackageByOrderID(const OrderID: string): string;
function AnyOrdersRequireSignature(OrderList: TStringList): Boolean;
function OrderRequiresSignature(const ID: string): Boolean;
function OrderRequiresDigitalSignature(const ID: string): Boolean;
function GetDrugSchedule(const ID: string): string;
function GetExternalText(const ID: string): string;
function SetExternalText(const ID: string; ADrugSch: string; AUser: Int64): string;
function GetDEA(const ID: string): string;
function GetDigitalSignature(const ID: string): string;
function GetPKIUse: Boolean;
function GetPKISite: Boolean;
function DoesOIPIInSigForQO(AnQOID: integer): integer;
function GetDispGroupForLES: string;
function GetOrderPtEvtID(AnOrderID: string): string;
function VerbTelPolicyOrder(AnOrderID: string): boolean;
function ForIVandUD(AnOrderID: string): boolean;

{Event Delay Enhancement}
function DeleteEmptyEvt(APtEvntID: string; var APtEvntName: string; Ask: boolean = True): boolean;
function DispOrdersForEvent(AEvtId: string): boolean;
function EventInfo(APtEvtID: string): string; // ptr to #100.2
function EventInfo1(AnEvtID: string): string; // ptr to #100.5
function EventExist(APtDFN:string; AEvt: integer): integer;
function CompleteEvt(APtEvntID: string; APtEvntName: string; Ask: boolean = True): boolean;
function PtEvtEmpty(APtEvtID: string): Boolean;
function GetEventIFN(const AEvntID: string): string;
function GetEventName(const AEvntID: string): string;
function GetEventLoc(const APtEvntID: string): string;
function GetEventLoc1(const AnEvntID: string): string;
function GetEventDiv(const APtEvntID: string): string;
function GetEventDiv1(const AnEvntID: string): string;
function GetCurrentSpec(const APtIFN: string): string;
function GetDefaultEvt(const AProviderIFN: string): string;
function isExistedEvent(const APtDFN: string; const AEvtID: string; var APtEvtID: string): Boolean;
function TypeOfExistedEvent(APtDFN: string; AEvtID: Integer): Integer;
function isMatchedEvent(const APtDFN: string; const AEvtID: string; var ATs: string): Boolean;
function isDCedOrder(const AnOrderID: string): Boolean;
function isOnholdMedOrder(AnOrderID: string): Boolean;
function SetDefaultEvent(var AErrMsg: string; EvtID: string): Boolean;
function GetEventPromptID: integer;
function GetDefaultTSForEvt(AnEvtID: integer): string;
function GetPromptIDs: string;
function GetEventDefaultDlg(AEvtID: integer): string;
function CanManualRelease: boolean;
function TheParentPtEvt(APtEvt: string): string;
function IsCompletedPtEvt(APtEvtID: integer): boolean;
function IsPassEvt(APtEvtID: integer; APtEvtType: char): boolean;
function IsPassEvt1(AnEvtID: integer; AnEvtType: char): boolean;
procedure DeleteDefaultEvt;
procedure TerminatePtEvt(APtEvtID: integer);
procedure ChangeEvent(AnOrderList: TStringList; APtEvtId: string);
procedure DeletePtEvent(APtEvtID: string);
procedure SaveEvtForOrder(APtDFN: string; AEvt: integer; AnOrderID: string);
procedure SetPtEvtList(Dest: TStrings; APtDFN: string; var ATotal: integer);
procedure GetTSListForEvt(Dest: TStrings; AnEvtID:integer);
procedure GetChildEvent(var AChildList: TStringList; APtEvtID: string);

{ Order Checking }
function IsMonograph(): Boolean; 
procedure DeleteMonograph();
procedure GetMonographList(ListOfMonographs: TStringList);
procedure GetMonograph(Monograph: TStringList; x: Integer);
procedure GetXtraTxt(OCText: TStringList; x: String; y: String);
function FillerIDForDialog(IEN: Integer): string;
function OrderChecksEnabled: Boolean;
function OrderChecksOnDisplay(const FillerID: string): string;
procedure OrderChecksOnAccept(ListOfChecks: TStringList; const FillerID, StartDtTm: string;
  OIList: TStringList; DupORIFN: string; Renewal: string);
procedure OrderChecksOnDelay(ListOfChecks: TStringList; const FillerID, StartDtTm: string;
  OIList: TStringList);
procedure OrderChecksForSession(ListOfChecks, OrderList: TStringList);
procedure SaveOrderChecksForSession(const AReason: string; ListOfChecks: TStringList);
function DeleteCheckedOrder(const OrderID: string): Boolean;
function DataForOrderCheck(const OrderID: string): string;

{ Copay }
procedure GetCoPay4Orders;
procedure SaveCoPayStatus(AList: TStrings);

{IMO: inpatient medication for outpatient}
function LocationType(Location: integer): string;
function IsValidIMOLoc(LocID: integer; PatientID: string): boolean;   //IMO
function IsIMOOrder(OrderID: string): boolean;
function IsInptQO(DlgID: integer): boolean;
function IsIVQO(DlgID: integer): boolean;
function IsClinicLoc(ALoc: integer): boolean;

{None-standard Schedule} //nss
function IsValidSchedule(AnOrderID: string): boolean; //NSS
function IsValidQOSch(QOID: string): string; //NSS
function IsValidSchStr(ASchStr: string): boolean;

function IsPendingHold(OrderID: string): boolean;

implementation

uses Windows, rCore, uConst, TRPCB, ORCtrls, UBAGlobals, UBACore, VAUtils;

var
  uDGroupMap: TStringList;          // each string is DGroupIEN=Sequence^TopName^Name
  uDGroupAll: Integer;
  uOrderChecksOn: Char;

{ TOrderView methods }

procedure TOrderView.Assign(Src: TOrderView);
begin
  Self.Changed   := Src.Changed;
  Self.DGroup    := Src.DGroup;
  Self.Filter    := Src.Filter;
  Self.InvChrono := Src.InvChrono;
  Self.ByService := Src.ByService;
  Self.TimeFrom  := Src.TimeFrom;
  Self.TimeThru  := Src.TimeThru;
  Self.CtxtTime  := Src.CtxtTime;
  Self.TextView  := Src.TextView;
  Self.ViewName  := Src.ViewName;
  Self.EventDelay.EventIFN   := Src.EventDelay.EventIFN;
  Self.EventDelay.EventName  := Src.EventDelay.EventName;
  Self.EventDelay.EventType  := Src.EventDelay.EventType;
  Self.EventDelay.Specialty  := Src.EventDelay.Specialty;
  Self.EventDelay.Effective  := Src.EventDelay.Effective;
end;

{ TOrder methods }

procedure TOrder.Assign(Source: TOrder);
begin
  ID           := Source.ID;
  DGroup       := Source.DGroup;
  OrderTime    := Source.OrderTime;
  StartTime    := Source.StartTime;
  StopTime     := Source.StopTime;
  Status       := Source.Status;
  Signature    := Source.Signature;
  VerNurse     := Source.VerNurse;
  VerClerk     := Source.VerClerk;
  ChartRev     := Source.ChartRev;
  Provider     := Source.Provider;
  ProviderName := Source.ProviderName;
  ProviderDEA  := Source.ProviderDEA;
  ProviderVA   := Source.ProviderVA;
  DigSigReq    := Source.DigSigReq;
  XMLText      := Source.XMLText;
  Text         := Source.Text;
  DGroupSeq    := Source.DGroupSeq;
  DGroupName   := Source.DGroupName;
  Flagged      := Source.Flagged;
  Retrieved    := Source.Retrieved;
  EditOf       := Source.EditOf;
  ActionOn     := Source.ActionOn;
  EventPtr     := Source.EventPtr;
  EventName    := Source.EventName;
  OrderLocIEN  := Source.OrderLocIEN;
  OrderLocName := Source.OrderLocName;
  ParentID     := Source.ParentID;  
  LinkObject   := Source.LinkObject;
  IsControlledSubstance   := Source.IsControlledSubstance;
  IsDetox   := Source.IsDetox;
end;

procedure TOrder.Clear;
begin
  ID           := '';
  DGroup       := 0;
  OrderTime    := 0;
  StartTime    := '';
  StopTime     := '';
  Status       := 0;
  Signature    := 0;
  VerNurse     := '';
  VerClerk     := '';
  ChartRev     := '';
  Provider     := 0;
  ProviderName := '';
  ProviderDEA  := '';
  ProviderVA   :='';
  DigSigReq    :='';
  XMLText      := '';
  Text         := '';
  DGroupSeq    := 0;
  DGroupName   := '';
  Flagged      := False;
  Retrieved    := False;
  EditOf       := '';
  ActionOn     := '';
  OrderLocIEN  := '';         //imo
  OrderLocName := '';         //imo
  ParentID     := '';
  LinkObject   := nil;
  IsControlledSubstance := False;
  IsDetox := False;
end;

{ Order List functions }

function DetailOrder(const ID: string): TStrings;
begin
  CallV('ORQOR DETAIL', [ID, Patient.DFN]);
  Result := RPCBrokerV.Results;
end;

function ResultOrder(const ID: string): TStrings;
begin
  CallV('ORWOR RESULT', [Patient.DFN,ID,ID]);
  Result := RPCBrokerV.Results;
end;

function ResultOrderHistory(const ID: string): TStrings;
begin
 CallV('ORWOR RESULT HISTORY', [Patient.DFN,ID,ID]);
 Result := RPCBrokerV.Results;
end;

procedure LoadDGroupMap;
begin
  if uDGroupMap = nil then
  begin
    uDGroupMap := TStringList.Create;
    tCallV(uDGroupMap, 'ORWORDG MAPSEQ', [nil]);
  end;
end;

function NameOfStatus(IEN: Integer): string;
begin
  case IEN of
     0: Result := 'error';
     1: Result := 'discontinued';
     2: Result := 'complete';
     3: Result := 'hold';
     4: Result := 'flagged';
     5: Result := 'pending';
     6: Result := 'active';
     7: Result := 'expired';
     8: Result := 'scheduled';
     9: Result := 'partial results';
    10: Result := 'delayed';
    11: Result := 'unreleased';
    12: Result := 'dc/edit';
    13: Result := 'cancelled';
    14: Result := 'lapsed';
    15: Result := 'renewed';
    97: Result := '';                  { null status, used for 'No Orders Found.' }
    98: Result := 'new';
    99: Result := 'no status';
  end;
end;

function GetOrderStatus(AnOrderId: string): integer;
begin
  Result := StrToIntDef(SCallV('OREVNTX1 GETSTS',[AnOrderId]),0);
end;

function ExpiredOrdersStartDT: TFMDateTime;
//Return FM date/time to begin search for expired orders
begin
  Result := MakeFMDateTime(sCallV('ORWOR EXPIRED', [nil]));
end;

function DispOrdersForEvent(AEvtId: string): boolean;
var
  theResult: integer;
begin
  Result := False;
  theResult := StrToIntDef(SCallV('OREVNTX1 CPACT',[AEvtId]),0);
  if theResult > 0 then
    Result := True;
end;

function EventInfo(APtEvtID: string): string;
begin
  Result := SCallV('OREVNTX1 GTEVT', [APtEvtID]);
end;

function EventInfo1(AnEvtID: string): string;
begin
  Result := SCallV('OREVNTX1 GTEVT1', [AnEvtID]);
end;

function NameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 3);
end;

function ShortNameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 4);
end;

function SeqOfDGroup(IEN: Integer): Integer;
var
  x: string;
begin
  if uDGroupMap = nil then LoadDGroupMap;
  x := uDGroupMap.Values[IntToStr(IEN)];
  Result := StrToIntDef(Piece(x, U, 1), 0);
end;

function CheckOrderGroup(AOrderID: string): integer;
begin
  // Result = 1     Inpatient Medication Display Group;
  // Result = 2     OutPatient Medication Display Group;
  // Result = 0     None of In or Out patient display group;
  Result := StrToInt(SCallV('ORWDPS2 CHKGRP',[AOrderID]));
end;

function CheckQOGroup(AQOId:string): Boolean;
var
  rst: integer;
begin
  rst := StrToInt(SCallV('ORWDPS2 QOGRP',[AQOId]));
  Result := False;
  if rst > 0 then
    Result := True;
end;

function TopNameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 2);
end;

procedure ClearOrders(AList: TList);
var
  i: Integer;
begin
  with AList do for i := 0 to Count - 1 do with TOrder(Items[i]) do Free;
  AList.Clear;
end;

procedure SetOrderFields(AnOrder: TOrder; const x, y, z: string);
{           1   2    3     4      5     6   7   8   9    10    11    12    13    14     15     16  17    18    19     20         21          22              23               24
{ Pieces: ~IFN^Grp^ActTm^StrtTm^StopTm^Sts^Sig^Nrs^Clk^PrvID^PrvNam^ActDA^Flag^DCType^ChrtRev^DEA#^VA#^DigSig^IMO^DCOrigOrder^ISDCOrder^IsDelayOrder^IsControlledSubstance^IsDetox}
begin
  with AnOrder do
  begin
    Clear;
    ID := Copy(Piece(x, U, 1), 2, Length(Piece(x, U, 1)));
    DGroup := StrToIntDef(Piece(x, U, 2), 0);
    OrderTime := MakeFMDateTime(Piece(x, U, 3));
    StartTime := Piece(x, U, 4);
    StopTime  := Piece(x, U, 5);
    Status    := StrToIntDef(Piece(x, U, 6), 0);
    Signature := StrToIntDef(Piece(x, U, 7), 0);
    VerNurse  := Piece(x, U, 8);
    VerClerk  := Piece(x, U, 9);
    ChartRev  := Piece(x, U, 15);
    Provider  := StrToInt64Def(Piece(x, U, 10), 0);
    ProviderName := Piece(x, U, 11);
    ProviderDEA  := Piece(x, U, 16);
    ProviderVA   := Piece(x, U, 17);
    DigSigReq    := Piece(x, U, 18);
    Flagged   := Piece(x, U, 13) = '1';
    Retrieved := True;
    OrderLocIEN  := Piece(Piece(x,U,19),':',2);   //imo
    if Piece(Piece(x,U,19),':',1) = '0;SC(' then OrderLocName := 'Unknown'
    else OrderLocName := Piece(Piece(x,U,19),':',1);   //imo
    Text := y;
    XMLText := z;
    DGroupSeq  := SeqOfDGroup(DGroup);
    DGroupName := TopNameOfDGroup(DGroup);
    //AGP Changes 26.15 PSI-04-063
    if (pos('Entered in error',Text)>0) then AnOrder.EnteredInError := 1
    else AnOrder.EnteredInError := 0;
    //if DGroupName = 'Non-VA Meds' then Text := 'Non-VA  ' + Text;
    if Piece(x,U,20) = '1' then DCOriginalOrder := True
    else DCOriginalOrder := False;
    if Piece(X,u,21) = '1' then  IsOrderPendDC := True
    else IsOrderPendDC := False;
    if Piece(x,u,22) = '1' then IsDelayOrder := True
    else IsDelayOrder := False;
    if Piece(x,u,23) = '1' then IsControlledSubstance := True
    else IsControlledSubstance := False;
    if Piece(x,u,24) = '1' then IsDetox := True
    else IsDetox := False;
  end;
end;

procedure LoadOrders(Dest: TList; Filter, Groups: Integer);
var
  x, y, z: string;
  AnOrder: TOrder;
begin
  ClearOrders(Dest);
  if uDGroupMap = nil then LoadDGroupMap;  // to make sure broker not called while looping thru Results
  CallV('ORWORR GET', [Patient.DFN, Filter, Groups]);
  with RPCBrokerV do while Results.Count > 0 do
  begin
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then Continue;        // only happens if out of synch
    y := '';
    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
    begin
      y := y + Copy(Results[0], 2, Length(Results[0])) + CRLF;
      Results.Delete(0);
    end;
    if Length(y) > 0 then y := Copy(y, 1, Length(y) - 2);  // take off last CRLF
    z := '';
    if (Results.Count > 0) and (Results[0] = '|') then
      begin
        Results.Delete(0);
        while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
          begin
            z := z + Copy(Results[0], 2, Length(Results[0]));
            Results.Delete(0);
          end;
      end;
    AnOrder := TOrder.Create;
    SetOrderFields(AnOrder, x, y, z);
    Dest.Add(AnOrder);
  end;
end;

procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; APtEvtID: string);
//Filter, Specialty, Groups: Integer; var TextView: Integer;
//  var CtxtTime: TFMDateTime);
var
  FilterTS: string;
  AlertedUserOnly: boolean;
begin
  ClearOrders(Dest);
  if uDGroupMap = nil then LoadDGroupMap;  // to make sure broker not called while looping thru Results
  FilterTS := IntToStr(AView.Filter) + U + IntToStr(AView.EventDelay.Specialty);
  AlertedUserOnly := (Notifications.Active and (AView.Filter = 12));
  CallV('ORWORR AGET', [Patient.DFN, FilterTS, AView.DGroup, AView.TimeFrom, AView.TimeThru, APtEvtID, AlertedUserOnly]);
  if ((Piece(RPCBrokerV.Results[0], U, 1) = '0') or (Piece(RPCBrokerV.Results[0], U, 1) = '')) and (AView.Filter = 5) then      // if no expiring orders found display expired orders)
  begin
    CallV('ORWORR AGET', [Patient.DFN, '27^0', AView.DGroup, ExpiredOrdersStartDT, FMNow, APtEvtID]);
    AView.ViewName := 'Recently Expired Orders (No Expiring Orders Found) -' + Piece(AView.ViewName, '-', 2);
  end;
  {if (Piece(RPCBrokerV.Results[0], U, 1) = '0') or (Piece(RPCBrokerV.Results[0], U, 1) = '') then      // if no orders found (0 element is count)
  begin
    AnOrder := TOrder.Create;
    with AnOrder do
    begin
      ID := '0';
      DGroup := 0;
      OrderTime := FMNow;
      Status := 97;
      Text := 'No orders found.';
      Retrieved := True;
    end;
    Dest.Add(AnOrder);
    Exit;
  end;}
  ConvertOrders(Dest, AView);
end;

procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; AptEvtID: string; AlertID: string);
begin
  ClearOrders(Dest);
  if uDGroupMap = nil then LoadDGroupMap;  // to make sure broker not called while looping thru Results
  CallV('ORB FOLLOW-UP ARRAY', [AlertID]);
  ConvertOrders(Dest, AView);
end;

procedure ConvertOrders(Dest: TList; AView: TOrderView);
var
  i: Integer;
  AnOrder: TOrder;
begin
  AView.TextView := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 2), 0);
  AView.CtxtTime := MakeFMDateTime(Piece(RPCBrokerV.Results[0], U, 3));
  with RPCBrokerV do for i := 1 to Results.Count - 1 do   // if orders found (skip 0 element)
  begin
    if (Piece(RPCBrokerV.Results[i], U, 1) = '0') or (Piece(RPCBrokerV.Results[i], U, 1) = '') then Continue;  
    if (DelimCount(Results[i],U) = 2) then Continue;  
    AnOrder := TOrder.Create;
    with AnOrder do
    begin
      ID := Piece(Results[i], U, 1);
      DGroup := StrToIntDef(Piece(Results[i], U, 2), 0);
      OrderTime := MakeFMDateTime(Piece(Results[i], U, 3));
      EventPtr  := Piece(Results[i],U,4);
      EventName := Piece(Results[i],U,5);
      DGroupSeq  := SeqOfDGroup(DGroup);
    end;
    Dest.Add(AnOrder);
  end;
end;

procedure LoadOrdersAbbr(DestDC,DestRL: TList; AView: TOrderView; APtEvtID: string);
var
  i: Integer;
  AnOrder: TOrder;
  FilterTS: string;
  DCStart: boolean;
begin
  DCStart := False;
  if uDGroupMap = nil then LoadDGroupMap;
  FilterTS := IntToStr(AView.Filter) + U + IntToStr(AView.EventDelay.Specialty);
  CallV('ORWORR RGET', [Patient.DFN, FilterTS, AView.DGroup, AView.TimeFrom, AView.TimeThru, APtEvtID]);
  if RPCBrokerV.Results[0] = '0' then   // if no orders found (0 element is count)
  begin
    AnOrder := TOrder.Create;
    with AnOrder do
    begin
      ID := '0';
      DGroup := 0;
      OrderTime := FMNow;
      Status := 97;
      Text := 'No orders found.';
      Retrieved := True;
    end;
    DestDC.Add(AnOrder);
    Exit;
  end;
  AView.TextView := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 2), 0);
  AView.CtxtTime := MakeFMDateTime(Piece(RPCBrokerV.Results[0], U, 3));
  with RPCBrokerV do for i := 1 to Results.Count - 1 do   // if orders found (skip 0 element)
  begin
    if AnsiCompareText('DC START', Results[i]) = 0 then
    begin
      DCStart := True;
      Continue;
    end;
    AnOrder := TOrder.Create;
    with AnOrder do
    begin
      ID := Piece(Results[i], U, 1);
      DGroup := StrToIntDef(Piece(Results[i], U, 2), 0);
      OrderTime := MakeFMDateTime(Piece(Results[i], U, 3));
      EventPtr  := Piece(Results[i],U,4);
      EventName := Piece(Results[i],U,5);
      DGroupSeq  := SeqOfDGroup(DGroup);
    end;
    if DCStart then
      DestDC.Add(AnOrder)
    else
      DestRL.Add(AnOrder);
  end;
end;

procedure LoadOrderSheets(Dest: TStrings);
begin
  CallV('ORWOR SHEETS', [Patient.DFN]);
  MixedCaseByPiece(RPCBrokerV.Results, U, 2);
  FastAssign(RPCBrokerV.Results, Dest);
 end;

procedure LoadOrderSheetsED(Dest: TStrings);
var
  i: integer;
begin
  CallV('OREVNTX PAT', [Patient.DFN]);
  MixedCaseByPiece(RPCBrokerV.Results, U, 2);
  Dest.Add('C;O^Current View');
  if RPCBrokerV.Results.Count > 1 then
  begin
    RPCBrokerV.Results.Delete(0);
    for i := 0 to RPCbrokerV.Results.Count - 1 do
      RPCBrokerV.Results[i] := RPCBrokerV.Results[i] + ' Orders';
    Dest.AddStrings(RPCBrokerV.Results);
  end;
end;

procedure LoadOrderViewDefault(AView: TOrderView);
var
  x: string;
begin
  x := sCallV('ORWOR VWGET', [nil]);
  with AView do
  begin
    Changed   := False;
    DGroup    := StrToIntDef(Piece(x, ';', 4), 0);
    Filter    := StrToIntDef(Piece(x, ';', 3), 0);
    InvChrono := Piece(x, ';', 6) = 'R';
    ByService := Piece(x, ';', 7) = '1';
    TimeFrom  := StrToFloat(Piece(x, ';', 1));
    TimeThru  := StrToFloat(Piece(x, ';', 2));
    CtxtTime  := 0;
    TextView  := 0;
    ViewName  := Piece(x, ';', 8);
    EventDelay.EventType := 'C';
    EventDelay.Specialty := 0;
    EventDelay.Effective := 0;
  end;
end;

procedure LoadUnsignedOrders(IDList, HaveList: TStrings);
var
  i: Integer;
begin
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := 'ORWOR UNSIGN';
    Param[0].PType := literal;
    Param[0].Value := Patient.DFN;
    Param[1].PType := list;
    Param[1].Mult['0'] := '';  // (to prevent broker from hanging if empty list)
    for i := 0 to Pred(HaveList.Count) do Param[1].Mult['"' + HaveList[i] + '"'] := '';
    CallBroker;
    FastAssign(RPCBrokerV.Results,IDList);
  end;
end;

procedure RetrieveOrderFields(OrderList: TList; ATextView: Integer; ACtxtTime: TFMDateTime);
var
  i, OrderIndex: Integer;
  x, y, z: string;
  AnOrder: TOrder;
  IDList: TStringList;
begin
  IDList := TStringList.Create;
  try
    with OrderList do for i := 0 to Count - 1 do IDList.Add(TOrder(Items[i]).ID);
    CallV('ORWORR GET4LST', [ATextView, ACtxtTime, IDList]);
  finally
    IDList.Free;
  end;
  OrderIndex := -1;
  with RPCBrokerV do while Results.Count > 0 do
  begin
    Inc(OrderIndex);
    if (OrderIndex >= OrderList.Count) then
    begin
      Results.Delete(0);
      Continue;
    end;
    AnOrder := TOrder(OrderList.Items[OrderIndex]);
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then Continue;                  // only happens if out of synch
    if Piece(x, U, 1) <> '~' + AnOrder.ID then Continue;   // only happens if out of synch
    y := '';
    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
    begin
      y := y + Copy(Results[0], 2, Length(Results[0])) + CRLF;
      Results.Delete(0);
    end;
    if Length(y) > 0 then y := Copy(y, 1, Length(y) - 2);  // take off last CRLF
    z := '';
    if (Results.Count > 0) and (Results[0] = '|') then
      begin
        Results.Delete(0);
        while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
          begin
            z := z + Copy(Results[0], 2, Length(Results[0]));
            Results.Delete(0);
          end;
      end;
    SetOrderFields(AnOrder, x, y, z);
  end;
end;

procedure SaveOrderViewDefault(AView: TOrderView);
var
  x: string;
begin
  with AView do
  begin
    x := MakeRelativeDateTime(TimeFrom) + ';' +            // 1
         MakeRelativeDateTime(TimeThru) + ';' +            // 2
         IntToStr(Filter)               + ';' +            // 3
         IntToStr(DGroup)               + ';;';            // 4, skip 5
    if InvChrono then x := x + 'R;' else x := x + 'F;';    // 6
    if ByService then x := x + '1'  else x := x + '0';     // 7
    CallV('ORWOR VWSET', [x]);
  end;
end;

{ MOVE THESE FUNCTIONS INTO UORDERS??? }

{ < 0 if Item1 is less and Item2, 0 if they are equal and > 0 if Item1 is greater than Item2 }
function InverseByGroup(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  DSeq1, DSeq2, IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if ( (Piece(Order1.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order1.ID)) )
    and ( StrToIntDef(Order1.EventPtr,0) = 0 ) then
      DSeq1 := 0
    else DSeq1 := Order1.DGroupSeq;
  if ((Piece(Order2.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order2.ID)))
    and ( StrToIntDef(Order1.EventPtr,0) = 0 ) then
      DSeq2 := 0
    else DSeq2 := Order2.DGroupSeq;
  if DSeq1 = DSeq2 then
  begin
    if Order1.OrderTime > Order2.OrderTime then Result := -1
    else if Order1.OrderTime < Order2.OrderTime then Result := 1
    else Result := 0;
    if Result = 0 then
    begin
      IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
      IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
      if IFN1 < IFN2 then Result := -1;
      if IFN1 > IFN2 then Result := 1;
    end;
  end
  else if DSeq1 < DSeq2 then Result := -1
  else Result := 1;
end;

function ForwardByGroup(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  DSeq1, DSeq2, IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if (Piece(Order1.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order1.ID))
    then DSeq1 := 0
    else DSeq1 := Order1.DGroupSeq;
  if (Piece(Order2.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order2.ID))
    then DSeq2 := 0
    else DSeq2 := Order2.DGroupSeq;
  if DSeq1 = DSeq2 then
  begin
    if Order1.OrderTime < Order2.OrderTime then Result := -1
    else if Order1.OrderTime > Order2.OrderTime then Result := 1
    else Result := 0;
    if Result = 0 then
    begin
      IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
      IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
      if IFN1 < IFN2 then Result := -1;
      if IFN1 > IFN2 then Result := 1;
    end;
  end
  else if DSeq1 < DSeq2 then Result := -1
  else Result := 1;
end;

function InverseChrono(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if Order1.OrderTime > Order2.OrderTime then Result := -1
  else if Order1.OrderTime < Order2.OrderTime then Result := 1
  else Result := 0;
  if Result = 0 then
  begin
    IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
    IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
    if IFN1 < IFN2 then Result := -1;
    if IFN1 > IFN2 then Result := 1;
  end;
end;

function ForwardChrono(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if Order1.OrderTime < Order2.OrderTime then Result := -1
  else if Order1.OrderTime > Order2.OrderTime then Result := 1
  else Result := 0;
  if Result = 0 then
  begin
    IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
    IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
    if IFN1 < IFN2 then Result := -1;
    if IFN1 > IFN2 then Result := 1;
  end;
end;

procedure SortOrders(AList: TList; ByGroup, InvChron: Boolean);
begin
  if ByGroup then
  begin
    if InvChron then AList.Sort(InverseByGroup) else AList.Sort(ForwardByGroup);
  end else
  begin
    if InvChron then AList.Sort(InverseChrono)  else AList.Sort(ForwardChrono);
  end;
end;

function DGroupAll: Integer;
var
  x: string;
begin
  if uDGroupAll = 0 then
  begin
    x := sCallV('ORWORDG IEN', ['ALL']);
    uDGroupAll := StrToIntDef(x, 1);
  end;
  Result := uDGroupAll;
end;

function DGroupIEN(AName: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWORDG IEN', [AName]), 0);
end;

procedure ListDGroupAll(Dest: TStrings);
begin
  CallV('ORWORDG ALLTREE', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListSpecialties(Dest: TStrings);
begin
  CallV('ORWOR TSALL', [nil]);
  MixedCaseList(RPCBrokerV.Results);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure ListSpecialtiesED(AType: Char; Dest: TStrings);
var
  i :integer;
  Currloc: integer;
  admitEvts: TStringList;
  otherEvts: TStringList;
  commonList: TStringList;
  IsObservation: boolean;
begin
  if Encounter <> nil then
    Currloc := Encounter.Location
  else
    Currloc := 0;
  IsObservation := (Piece(GetCurrentSpec(Patient.DFN), U, 3) = '1');
  commonList := TStringList.Create;
  CallV('OREVNTX1 CMEVTS',[Currloc]);
  //MixedCaseList(RPCBrokerV.Results);
  if RPCBrokerV.Results.Count > 0 then with RPCBrokerV do for i := 0 to Results.Count - 1 do
  begin
    if AType = 'D' then
    begin
      if AType = Piece(Results[i],'^',3) then
        commonList.Add(Results[i]);
    end
    else if AType = 'A' then
    begin
      if (Piece(Results[i],'^',3) = 'T') or (Piece(Results[i],'^',3) = 'D') then
        Continue;
      commonList.Add(Results[i]);
    end
    else if IsObservation then
    begin
      if (Piece(Results[i],'^',3) = 'T') then
        Continue;
      commonList.Add(Results[i]);
    end
    else
    begin
     if Length(Results[i])> 0 then
      commonList.Add(Results[i]);
    end;
  end;
  if commonList.Count > 0 then
  begin
    Dest.AddStrings(commonList);
    Dest.Add('^^^^^^^^___________________________________________________________________________________________');
    Dest.Add(LLS_SPACE);
  end;
  if AType = #0 then
  begin
    admitEvts := TStringList.Create;
    otherEvts := TSTringList.Create;
    CallV('OREVNTX ACTIVE',['A']);
    //MixedCaseList(RPCBrokerV.Results);
    if RPCBrokerV.Results.Count > 0 then
    begin
      RPCBrokerV.Results.Delete(0);
      admitEvts.AddStrings(RPCBrokerV.Results);
    end;
    if IsObservation then
      CallV('OREVNTX ACTIVE',['O^M^D'])
    else
      CallV('OREVNTX ACTIVE',['T^O^M^D']);
    //MixedCaseList(RPCBrokerV.Results);
    if RPCBrokerV.Results.Count > 0 then
    begin
      RPCBrokerV.Results.Delete(0);
      otherEvts.AddStrings(RPCBrokerV.Results);
    end;
    Dest.AddStrings(otherEvts);
    Dest.Add('^^^^^^^^_____________________________________________________________________________________________');
    Dest.Add(LLS_SPACE);
    Dest.AddStrings(admitEvts);
    admitEvts.Free;
    otherEvts.Free;
  end
  else if AType = 'A' then
  begin
    CallV('OREVNTX ACTIVE',['A^O^M']);
    //MixedCaseList(RPCBrokerV.Results);
    if RPCBrokerV.Results.Count > 0 then
      RPCBrokerV.Results.Delete(0);
    Dest.AddStrings(RPCBrokerV.Results);
  end
  else
  begin
    CallV('OREVNTX ACTIVE',[AType]);
    //MixedCaseList(RPCBrokerV.Results);
    if RPCBrokerV.Results.Count > 0 then
      RPCBrokerV.Results.Delete(0);
    Dest.AddStrings(RPCBrokerV.Results);
  end;
end;

procedure ListOrderFilters(Dest: TStrings);
begin
  CallV('ORWORDG REVSTS', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;


procedure ListOrderFiltersAll(Dest: TStrings);
begin
  CallV('ORWORDG REVSTS', [nil]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

{ Write Orders }

procedure BuildResponses(var ResolvedDialog: TOrderDialogResolved; const KeyVars: string;
  AnEvent: TOrderDelayEvent; ForIMO: boolean);
const
  BoolChars: array[Boolean] of Char = ('0', '1');
  RESERVED_PIECE = '';
var
  DelayEvent, x, TheOrder: string;
  Idx, tmpOrderGroup, PickupIdx, ForIMOResponses: integer;
  IfUDGrp: Boolean;
  IfUDGrpForQO: Boolean;
  temp: string;
begin
  ForIMOResponses := 0;
  tmpOrderGroup := 0;
  temp := '';
  if ForIMO then ForIMOResponses := 1;
  PickupIdx := 0;
  IfUDGrp := False;
  TheOrder := ResolvedDialog.InputID;
  IfUDGrpForQO := CheckQOGroup(TheOrder);
  if CharInSet(CharAt(TheOrder,1), ['C','T']) then
  begin
    Delete(TheOrder,1,1);
    tmpOrderGroup := CheckOrderGroup(TheOrder);
    if tmpOrderGroup = 1 then IfUDGrp := True else IfUDGrp := False;
  end;
  if (not IfUDGrp) and CharInSet(AnEvent.EventType, ['A','T']) then
    IfUDGrp := True;
  //FLDS=DFN^LOC^ORNP^INPT^SEX^AGE^EVENT^SC%^^^Key Variables
  if (Patient.Inpatient = true) and (tmpOrderGroup = 2) then temp := '0';
  if temp <> '0' then temp := BoolChars[Patient.Inpatient];
  with AnEvent do
  begin
    if isNewEvent then
      DelayEvent := '0;'+ EventType + ';' + IntToStr(Specialty) + ';' + FloatToStr(Effective)
    else
      DelayEvent := IntToStr(AnEvent.PtEventIFN) + ';' + EventType + ';' + IntToStr(Specialty) + ';' + FloatToStr(Effective);
  end;
  x := Patient.DFN                  + U +   // 1
       IntToStr(Encounter.Location) + U +   // 2
       IntToStr(Encounter.Provider) + U +   // 3
       BoolChars[Patient.Inpatient] + U +   // 4
       Patient.Sex                  + U +   // 5
       IntToStr(Patient.Age)        + U +   // 6
       DelayEvent                   + U +   // 7 (for OREVENT)
       IntToStr(Patient.SCPercent)  + U +   // 8
       RESERVED_PIECE               + U +   // 9
       RESERVED_PIECE               + U +   // 10
       KeyVars;
  CallV('ORWDXM1 BLDQRSP', [ResolvedDialog.InputID, x, ForIMOResponses, Encounter.Location]);
  // LST(0)=QuickLevel^ResponseID(ORIT;$H)^Dialog^Type^FormID^DGrp
  with RPCBrokerV do
  begin
    x := Results[0];
    with ResolvedDialog do
    begin
      QuickLevel   := StrToIntDef(Piece(x, U, 1), 0);
      ResponseID   := Piece(x, U, 2);
      DialogIEN    := StrToIntDef(Piece(x, U, 3), 0);
      DialogType   := CharAt(Piece(x, U, 4), 1);
      FormID       := StrToIntDef(Piece(x, U, 5), 0);
      DisplayGroup := StrToIntDef(Piece(x, U, 6), 0);
      QOKeyVars    := Pieces(x, U, 7, 7 + MAX_KEYVARS);
      Results.Delete(0);
      if Results.Count > 0 then
      begin
        if (IfUDGrp) or (IfUDGrpForQO) then
        begin
          for Idx := 0 to Results.Count - 1 do
          begin
            if(Pos('PICK UP',UpperCase(Results[idx])) > 0) or (Pos('PICK-UP',UpperCase(Results[idx])) > 0) then
            begin
              PickupIdx := Idx;
              Break;
            end;
          end;
        end;
        if PickupIdx > 0 then
          Results.Delete(PickupIdx);
        SetString(ShowText, Results.GetText, StrLen(Results.GetText));
      end;
    end;
  end;
end;

procedure ClearOrderRecall;
begin
  CallV('ORWDXM2 CLRRCL', [nil]);
end;

function CommonLocationForOrders(OrderList: TStringList): Integer;
begin
  Result := StrToIntDef(sCallV('ORWD1 COMLOC', [OrderList]), 0);
end;

function FormIDForDialog(IEN: Integer): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDXM FORMID', [IEN]), 0);
end;

function DlgIENForName(DlgName: string): Integer;
begin
  Result := StrToIntDef(sCallV('OREVNTX1 DLGIEN',[DlgName]),0);
end;

procedure LoadOrderMenu(AnOrderMenu: TOrderMenu; AMenuIEN: Integer);
var
  OrderMenuItem: TOrderMenuItem;
  i: Integer;
  OrderTitle: String;
begin
  CallV('ORWDXM MENU', [AMenuIEN]);
  with RPCBrokerV do if Results.Count > 0 then
  begin
    // Results[0] = Name^Cols^PathSwitch^^^LRFZX^LRFSAMP^LRFSPEC^LRFDATE^LRFURG^LRFSCH^PSJNPOC^
    //              GMRCNOPD^GMRCNOAT^GMRCREAF^^^^^
   OrderTitle := Piece(Results[0], U, 1);
   if (Pos('&', OrderTitle) > 0) and
   (Copy(OrderTitle, Pos('&', OrderTitle) + 1, 1) <> '&') then
   OrderTitle := Copy(OrderTitle, 1, Pos('&', OrderTitle)) + '&' + Copy(OrderTitle, Pos('&', OrderTitle) + 1, Length(OrderTitle));

    AnOrderMenu.Title   := OrderTitle;
    AnOrderMenu.NumCols := StrToIntDef(Piece(Results[0], U, 2), 1);
    AnOrderMenu.KeyVars := Pieces(Results[0], U, 6, 6 + MAX_KEYVARS);
    for i := 1 to Results.Count - 1 do
    begin
      OrderMenuItem := TOrderMenuItem.Create;
      with OrderMenuItem do
      begin
        Col      := StrToIntDef(Piece(Results[i], U, 1), 0) - 1;
        Row      := StrToIntDef(Piece(Results[i], U, 2), 0) - 1;
        DlgType  := CharAt(Piece(Results[i], U, 3), 1);
        IEN      := StrToIntDef(Piece(Results[i], U, 4), 0);
        FormID   := StrToIntDef(Piece(Results[i], U, 5), 0);
        AutoAck  := Piece(Results[i], U, 6) = '1';
        ItemText := Piece(Results[i], U, 7);
        Mnemonic := Piece(Results[i], U, 8);
        Display  := StrToIntDef(Piece(Results[i], U, 9), 0);
      end; {with OrderItem}
      AnOrderMenu.MenuItems.Add(OrderMenuItem);
    end; {for i}
  end; {with RPCBrokerV}
end;

procedure LoadOrderSet(SetItems: TStrings; AnIEN: Integer; var KeyVars, ACaption: string);
var
  x: string;
begin
  CallV('ORWDXM LOADSET', [AnIEN]);
  KeyVars := '';
  ACaption := '';
  if RPCBrokerV.Results.Count > 0 then
  begin
    x := RPCBrokerV.Results[0];
    ACaption := Piece(x, U, 1);
    KeyVars  := Copy(x, Pos(U, x) + 1, Length(x));
    RPCBrokerV.Results.Delete(0);
  end;
  FastAssign(RPCBrokerV.Results, SetItems);
end;

procedure LoadWriteOrders(Dest: TStrings);
begin
  CallV('ORWDX WRLST', [Encounter.Location]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure LoadWriteOrdersED(Dest: TStrings; EvtID: string);
begin
  CallV('OREVNTX1 WRLSTED', [Encounter.Location,EvtID]);
  if RPCBrokerV.Results.count > 0 then
  begin
    Dest.Clear;
  FastAssign(RPCBrokerV.Results, Dest);
  end
end;

function OrderDisabledMessage(DlgIEN: Integer): string;
begin
  Result := sCallV('ORWDX DISMSG', [DlgIEN]);
end;

procedure SendOrders(OrderList: TStringList; const ESCode: string);
var
  i: Integer;
begin
  { prepending the space to ESCode is temporary way to keep broker from crashing }
  CallV('ORWDX SEND', [Patient.DFN, Encounter.Provider, Encounter.Location, ' ' + ESCode, OrderList]);
  { this is a stop gap way to prevent an undesired error message when user chooses not to sign }
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
    if Piece(Results[i], U, 4) = 'This order requires a signature.'
      then Results[i] := Piece(Results[i], U, 1);
  OrderList.Clear;
  FastAssign(RPCBrokerV.Results, OrderList);
end;

procedure SendReleaseOrders(OrderList: TStringList);
var
  loc: string;
  CurrTS: Integer;
  PtTS: string;
begin
  PtTS := Piece(GetCurrentSpec(Patient.DFN),'^',2);
  CurrTS := StrToIntDef(PtTS,0);
  Loc := IntToStr(Encounter.Location);
  CallV('ORWDX SENDED',[OrderList,CurrTS,Loc]);
  OrderList.Clear;
  FastAssign(RPCBrokerV.Results, OrderList);
end;

procedure SendAndPrintOrders(OrderList, ErrList: TStrings; const ESCode: string; const DeviceInfo: string);
var
  i: Integer;
begin
  { prepending the space to ESCode is temporary way to keep broker from crashing }
  CallV('ORWDX SENDP', [Patient.DFN, Encounter.Provider, Encounter.Location, ' ' + ESCode, DeviceInfo, OrderList]);
  { this is a stop gap way to prevent an undesired error message when user chooses not to sign }
  with RPCBrokerV do for i := 0 to Results.Count - 1 do
    if Piece(Results[i], U, 3) <> 'This order requires a signature.'
      then ErrList.Add(Results[i]);
end;

procedure PrintOrdersOnReview(OrderList: TStringList; const DeviceInfo: string; PrintLoc: Integer = 0);
var
Loc: Integer;
begin
  if (PrintLoc > 0) and (PrintLoc <> Encounter.Location) then Loc := PrintLoc
  else Loc := Encounter.Location;
  CallV('ORWD1 RVPRINT',  [Loc, DeviceInfo, OrderList]);
end;

procedure PrintServiceCopies(OrderList: TStringList; PrintLoc: Integer = 0);  {*REV*}
var
Loc: Integer;
begin
  if (PrintLoc > 0) and (PrintLoc <> Encounter.Location) then Loc := PrintLoc
  else Loc := Encounter.Location;
  CallV('ORWD1 SVONLY',  [Loc, OrderList]);
end;

procedure ExecutePrintOrders(SelectedList: TStringList; const DeviceInfo: string);
begin
  CallV('ORWD1 PRINTGUI', [Encounter.Location, DeviceInfo, SelectedList]);
end;

{ Order Actions }

function DialogForOrder(const ID: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDX DLGID', [ID]), 0);
end;

function FormIDForOrder(const ID: string): Integer;
begin
  Result := StrToIntDef(sCallV('ORWDX FORMID', [ID]), 0);
end;

procedure SetOrderFromResults(AnOrder: TOrder);
var
  x, y, z: string;
begin
  with RPCBrokerV do while Results.Count > 0 do
  begin
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then Continue;        // only happens if out of synch
    y := '';
    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
    begin
      y := y + Copy(Results[0], 2, Length(Results[0])) + CRLF;
      Results.Delete(0);
    end;
    if Length(y) > 0 then y := Copy(y, 1, Length(y) - 2);  // take off last CRLF
    z := '';
    if (Results.Count > 0) and (Results[0] = '|') then
      begin
        Results.Delete(0);
        while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
          begin
            z := z + Copy(Results[0], 2, Length(Results[0])); //PKI Change
            Results.Delete(0);
          end;
      end;
    SetOrderFields(AnOrder, x, y, z);
  end;
end;

procedure LockPatient(var ErrMsg: string);
begin
  ErrMsg := sCallV('ORWDX LOCK', [Patient.DFN]);
  if Piece(ErrMsg, U, 1) = '1' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

procedure UnlockPatient;
begin
  sCallV('ORWDX UNLOCK', [Patient.DFN]);
end;

procedure LockOrder(OrderID: string; var ErrMsg: string);
begin
  ErrMsg := sCallV('ORWDX LOCK ORDER', [OrderID]);
  if Piece(ErrMsg, U, 1) = '1' then ErrMsg := '' else ErrMsg := Piece(ErrMsg, U, 2);
end;

procedure UnlockOrder(OrderID: string);
begin
  sCallV('ORWDX UNLOCK ORDER', [OrderID]);
end;

procedure ValidateOrderAction(const ID, Action: string; var ErrMsg: string);
begin
  if Action = OA_SIGN then ErrMsg := sCallV('ORWDXA VALID', [ID, Action, User.DUZ])
  else ErrMsg := sCallV('ORWDXA VALID', [ID, Action, Encounter.Provider]);
end;

procedure ValidateOrderActionNature(const ID, Action, Nature: string; var ErrMsg: string);
begin
  ErrMsg := sCallV('ORWDXA VALID', [ID, Action, Encounter.Provider, Nature]);
end;

procedure IsLatestAction(const ID: string; var ErrList: TStringList);
begin
  CallV('ORWOR ACTION TEXT',[ID]);
  if RPCBrokerV.Results.Count > 0 then
    FastAssign(RPCBrokerV.Results, Errlist);
end;

procedure ChangeOrder(AnOrder: TOrder; ResponseList: TList);
begin
end;

procedure RenewOrder(AnOrder: TOrder; RenewFields: TOrderRenewFields; IsComplex: integer; AnIMOOrderAppt: double; OCList: TStringList);
{ put RenewFields into tmplst[0]=BaseType^Start^Stop^Refills^Pickup, tmplst[n]=comments }
var
  tmplst: TStringList;
  i: integer;
  y: string;
begin

  tmplst := TStringList.Create;

  {Begin Billing Aware}
  UBAGlobals.SourceOrderID := AnOrder.ID;
  {End Billing Aware}

  try
    with RenewFields do
       begin
       tmplst.SetText(PChar(Comments));
       tmplst.Insert(0, IntToStr(BaseType) + U + StartTime + U + StopTime + U + IntToStr(Refills) + U + Pickup);
       end;

    with RPCBrokerV do
    begin
      ClearParameters := True;
      RemoteProcedure := 'ORWDXR RENEW';
      Param[0].PType := literal;
      Param[0].Value := AnOrder.ID;
      Param[1].PType := literal;
      Param[1].Value := Patient.DFN;
      Param[2].PType := literal;
      Param[2].Value := IntToStr(Encounter.Provider);
      Param[3].PType := literal;
      Param[3].Value := IntToStr(Encounter.Location);
      Param[4].PType := list;
      for i := 0 to tmplst.Count - 1 do
        Param[4].Mult[IntToStr(i+1)] := tmplst[i];
      Param[4].Mult['"ORCHECK"'] := IntToStr(OCList.Count);
      for i := 0 to OCList.Count - 1 do
      begin
      // put quotes around everything to prevent broker from choking
      y := '"ORCHECK","' + Piece(OCList[i], U, 1) + '","' + Piece(OCList[i], U, 3) +
        '","' + IntToStr(i+1) + '"';
      Param[4].Mult[y] := Pieces(OCList[i], U, 2, 4);
    end;
    Param[5].PType := literal;
    Param[5].Value := IntToStr(IsComplex);
    Param[6].PType := literal;
    Param[6].Value := FloatToStr(AnIMOOrderAppt);
    CallBroker;
    SetOrderFromResults(AnOrder);

     {Begin Billing Aware}
       UBAGlobals.TargetOrderID := AnOrder.ID; //the ID of the renewed order
       UBAGlobals.CopyTreatmentFactorsDxsToRenewedOrder;
     {End Billing Aware}

  end;
  finally
    tmplst.Free;
  end;
end;

procedure HoldOrder(AnOrder: TOrder);
begin
  CallV('ORWDXA HOLD', [AnOrder.ID, Encounter.Provider]);
  SetOrderFromResults(AnOrder);
end;

procedure ReleaseOrderHold(AnOrder: TOrder);
begin
  CallV('ORWDXA UNHOLD', [AnOrder.ID, Encounter.Provider]);
  SetOrderFromResults(AnOrder);
end;

procedure ListDCReasons(Dest: TStrings; var DefaultIEN: Integer);
begin
  CallV('ORWDX2 DCREASON', [nil]);
  ExtractItems(Dest, RPCBrokerV.Results, 'DCReason');
  //AGP Change 26.15 for PSI-04-63
  //DefaultIEN := StrToIntDef(Piece(ExtractDefault(RPCBrokerV.Results, 'DCReason'), U, 1), 0);
end;

function GetREQReason: Integer;
begin
  Result := StrToIntDef(sCallV('ORWDXA DCREQIEN', [nil]), 0);
end;

procedure DCOrder(AnOrder: TOrder; AReason: Integer; NewOrder: boolean; var DCType: Integer);
var
  AParentID, DCOrigOrder: string;
begin
  AParentID := AnOrder.ParentID;
  if AnOrder.DCOriginalOrder = true then DCOrigOrder := '1'
  else DCOrigOrder := '0';
  CallV('ORWDXA DC', [AnOrder.ID, Encounter.Provider, Encounter.Location, AReason, DCOrigOrder, NewOrder]);
  UBACore.DeleteDCOrdersFromCopiedList(AnOrder.ID);
  DCType := StrToIntDef(Piece(RPCBrokerV.Results[0], U, 14), 0);
  SetOrderFromResults(AnOrder);
  AnOrder.ParentID := AParentID;
end;

procedure AlertOrder(AnOrder: TOrder; AlertRecip: Int64);
begin
  CallV('ORWDXA ALERT', [AnOrder.ID, AlertRecip]);
  // don't worry about results
end;

procedure FlagOrder(AnOrder: TOrder; const FlagReason: string; AlertRecip: Int64);
begin
  CallV('ORWDXA FLAG', [AnOrder.ID, FlagReason, AlertRecip]);
  SetOrderFromResults(AnOrder);
end;

procedure LoadFlagReason(Dest: TStrings; const ID: string);
begin
  CallV('ORWDXA FLAGTXT', [ID]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure UnflagOrder(AnOrder: TOrder; const AComment: string);
begin
  CallV('ORWDXA UNFLAG', [AnOrder.ID, AComment]);
  SetOrderFromResults(AnOrder);
end;

procedure LoadWardComments(Dest: TStrings; const ID: string);
begin
  CallV('ORWDXA WCGET', [ID]);
  FastAssign(RPCBrokerV.Results, Dest);
end;

procedure PutWardComments(Src: TStrings; const ID: string; var ErrMsg: string);
begin
  ErrMsg := sCallV('ORWDXA WCPUT', [ID, Src]);
end;

procedure CompleteOrder(AnOrder: TOrder; const ESCode: string);
begin
  CallV('ORWDXA COMPLETE', [AnOrder.ID, ESCode]);
  SetOrderFromResults(AnOrder);
end;

procedure VerifyOrder(AnOrder: TOrder; const ESCode: string);
begin
  CallV('ORWDXA VERIFY', [AnOrder.ID, ESCode]);
  SetOrderFromResults(AnOrder);
end;

procedure VerifyOrderChartReview(AnOrder: TOrder; const ESCode: string);
begin
  CallV('ORWDXA VERIFY', [AnOrder.ID, ESCode, 'R']);
  SetOrderFromResults(AnOrder);
end;

function GetOrderableIen(AnOrderId:string): integer;
begin
  Result := StrToIntDef(sCallV('ORWDXR GTORITM', [AnOrderId]),0);
end;

procedure StoreDigitalSig(AID, AHash: string; AProvider: Int64; ASig, ACrlUrl, DFN: string; var AError: string);
var
  len, ix: integer;
  ASigAray: TStringList;
begin
  ASigAray := TStringList.Create;
  ix := 1;
  len := length(ASig);
  while len >= ix do
    begin
        ASigAray.Add(copy(ASig, ix, 240));
        inc(ix, 240);
    end;   //while
  try
    CallV('ORWOR1 SIG', [AID, AHash, len, '100', AProvider, ASigAray, ACrlUrl, DFN]);
    with RPCBrokerV do
      if piece(Results[0],'^',1) = '-1' then
        begin
          ShowMsg('Storage of Digital Signature FAILED: ' + piece(Results[0],'^',2) + CRLF + CRLF +
            'This error will prevent this order from being sent to the service for processing. Please cancel the order and try again.' + CRLF + CRLF +
            'If this problem persists, then there is a problem in the CPRS PKI interface, and it needs to be reported through the proper channels, to the developer Cary Malmrose.');
          AError := '1';
        end;
  finally
    ASigAray.Free;
  end;
end;

procedure UpdateOrderDGIfNeeded(AnID: string);
var
  NeedUpdate: boolean;
  tmpDFN: string;
begin
  tmpDFN := Patient.DFN;
  Patient.Clear;
  Patient.DFN := tmpDFN;
  NeedUpdate := SCallV('ORWDPS4 IPOD4OP', [AnID]) = '1';
  if Patient.Inpatient and needUpdate then
    SCallV('ORWDPS4 UPDTDG',[AnID]);
end;

function CanEditSuchRenewedOrder(AnID: string; IsTxtOrder: integer): boolean;
begin
  Result := SCallV('ORWDXR01 CANCHG',[AnID,IsTxtOrder]) = '1';
end;

function IsPSOSupplyDlg(DlgID, QODlg: integer): boolean;
begin
  Result := SCallV('ORWDXR01 ISSPLY',[DlgID,QODlg])='1';
end;

procedure SaveChangesOnRenewOrder(var AnOrder: TOrder; AnID, TheRefills, ThePickup: string; IsTxtOrder: integer);
begin
  SCallV('ORWDXR01 SAVCHG',[AnID,TheRefills,ThePickup,IsTxtOrder]);
  SetOrderFromResults(AnOrder);
end;

function DoesOrderStatusMatch(OrderArray: TStringList): boolean;
begin
 Result := StrtoIntDef(SCallV('ORWDX1 ORDMATCH',[Patient.DFN, OrderArray]),0)=1;
end;

{ Order Information }

function OrderIsReleased(const ID: string): Boolean;
begin
  Result := sCallV('ORWDXR ISREL', [ID]) = '1';
end;

procedure LoadRenewFields(RenewFields: TOrderRenewFields; const ID: string);
var
  i: Integer;
begin
  CallV('ORWDXR RNWFLDS', [ID]);
  with RPCBrokerV, RenewFields do
  begin
    BaseType  := StrToIntDef(Piece(Results[0], U, 1), 0);
    StartTime := Piece(Results[0], U, 2);
    StopTime  := Piece(Results[0], U, 3);
    Refills   := StrToIntDef(Piece(Results[0], U, 4), 0);
    Pickup    := Piece(Results[0], U, 5);
    Comments  := '';
    for i := 1 to Results.Count - 1 do Comments := Comments + CRLF + Results[i];
    if Copy(Comments, 1, 2) = CRLF then Delete(Comments, 1, 2);
  end;
end;

procedure GetChildrenOfComplexOrder(AnParentID,CurrAct: string; var ChildList: TStringList); //PSI-COMPLEX
var
  i: integer;
begin
 CallV('ORWDXR ORCPLX',[AnParentID,CurrAct]);
 if RPCBrokerV.Results.Count = 0 then Exit;
 With RPCBrokerV do
 begin
   for i := 0 to Results.Count - 1 do
   begin
     if (Piece(Results[i],'^',1) <> 'E') and (Length(Results[i])>0) then
       ChildList.Add(Results[i]);
   end;
 end;
end;

procedure LESValidationForChangedLabOrder(var RejectedReason: TStringList; AnOrderInfo: string);
begin
  CallV('ORWDPS5 LESAPI',[AnOrderInfo]);
  if RPCBrokerV.Results.Count > 0 then
    FastAssign(RPCBrokerV.Results, RejectedReason);
end;

procedure ChangeEvent(AnOrderList: TStringList; APtEvtId: string);
begin
  SCallV('OREVNTX1 CHGEVT', [APtEvtId,AnOrderList]);
end;

procedure DeletePtEvent(APtEvtID: string);
begin
  SCallV('OREVNTX1 DELPTEVT',[APtEvtID]);
end;

function IsRenewableComplexOrder(AnParentID: string): boolean; //PSI-COMPLEX
var
  rst: integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('ORWDXR CANRN',[AnParentID]),0);
  if rst>0 then
    Result := True;
end;

function IsComplexOrder(AnOrderID: string): boolean; //PSI-COMPLEX
var
  rst: integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('ORWDXR ISCPLX',[AnOrderID]),0);
  if rst > 0 then
    Result := True;
end;

procedure ValidateComplexOrderAct(AnOrderID: string; var ErrMsg: string); //PSI-COMPLEX
begin
  ErrMsg := SCallV('ORWDXA OFCPLX',[AnOrderID]);
end;

function GetDlgData(ADlgID: string): string;
begin
  Result := SCallV('OREVNTX1 GETDLG',[ADlgID]);
end;

function PtEvtEmpty(APtEvtID: string): Boolean;
begin
  Result := False;
  if StrToIntDef(SCallV('OREVNTX1 EMPTY',[APtEvtID]),0)>0 then
    Result := True;
end;


function TextForOrder(const ID: string): string;
begin
  CallV('ORWORR GETTXT', [ID]);
  Result := RPCBrokerV.Results.Text;
end;

function GetConsultOrderNumber(ConsultIEN: string): string;
begin
  Result := sCallv('ORQQCN GET ORDER NUMBER',[ConsultIEN]);
end;

function GetOrderByIFN(const ID: string): TOrder;
var
  x, y, z: string;
  AnOrder: TOrder;
begin
  AnOrder := TOrder.Create;
  CallV('ORWORR GETBYIFN', [ID]);
  with RPCBrokerV do while Results.Count > 0 do
  begin
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then Continue;        // only happens if out of synch
    y := '';
    while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
    begin
      y := y + Copy(Results[0], 2, Length(Results[0])) + CRLF;
      Results.Delete(0);
    end;
    if Length(y) > 0 then y := Copy(y, 1, Length(y) - 2);  // take off last CRLF
    z := '';
    if (Results.Count > 0) and (Results[0] = '|') then
      begin
        Results.Delete(0);
        while (Results.Count > 0) and (CharAt(Results[0], 1) <> '~') and (CharAt(Results[0], 1) <> '|') do
          begin
            z := z + Copy(Results[0], 2, Length(Results[0])); //PKI Change
            Results.Delete(0);
          end;
      end;
    SetOrderFields(AnOrder, x, y, z);
  end;
  Result := AnOrder;
end;

function GetPackageByOrderID(const OrderID: string): string;
begin
  Result := SCallV('ORWDXR GETPKG',[OrderID]);
end;

function AnyOrdersRequireSignature(OrderList: TStringList): Boolean;
begin
  Result := sCallV('ORWD1 SIG4ANY', [OrderList]) = '1';
end;

function OrderRequiresSignature(const ID: string): Boolean;
begin
  Result := sCallV('ORWD1 SIG4ONE', [ID]) = '1';
end;

function OrderRequiresDigitalSignature(const ID: string): Boolean;
begin
  Result := sCallV('ORWOR1 CHKDIG', [ID]) = '1';
end;

function GetDrugSchedule(const ID: string): string;
begin
  Result := sCallV('ORWOR1 GETDSCH', [ID]);
end;

function GetExternalText(const ID: string): string;
var
  x,y: string;
begin
  CallV('ORWOR1 GETDTEXT', [ID]);
  y := '';
  with RPCBrokerV do while Results.Count > 0 do
    begin
      x := Results[0];
      Results.Delete(0);
      y := y + x;
    end;
  Result := y;
end;

function SetExternalText(const ID: string; ADrugSch: string; AUser: Int64): string;
var
  x,y: string;
begin
  CallV('ORWOR1 SETDTEXT', [ID, ADrugSch, AUser]);
  y := '';
  with RPCBrokerV do while Results.Count > 0 do
    begin
      x := Results[0];
      Results.Delete(0);
      y := y + x;
    end;
  Result := y;
end;

function GetDigitalSignature(const ID: string): string;
begin
  CallV('ORWORR GETDSIG', [ID]);
  Result := RPCBrokerV.Results.Text;
end;

function GetDEA(const ID: string): string;
begin
  CallV('ORWORR GETDEA', [ID]);
  Result := RPCBrokerV.Results.Text;
end;

function GetPKISite: Boolean;
begin
  Result := sCallV('ORWOR PKISITE', [nil]) = '1';
end;

function GetPKIUse: Boolean;
begin
  Result := sCallV('ORWOR PKIUSE', [nil]) = '1';
end;

function DoesOIPIInSigForQO(AnQOID: integer): integer;
begin
  Result := StrToIntDef(SCallV('ORWDPS1 HASOIPI',[AnQOID]),0);
end;

function GetDispGroupForLES: string;
begin
  Result := SCallV('ORWDPS5 LESGRP',[nil]);  
end;

function GetOrderPtEvtID(AnOrderID: string): string;
begin
  Result := SCallV('OREVNTX1 ODPTEVID',[AnOrderID]);
end;

function VerbTelPolicyOrder(AnOrderID: string): boolean;
begin
  Result := SCallV('ORWDPS5 ISVTP',[AnOrderID]) = '1';
end;

function ForIVandUD(AnOrderID: string): boolean;
begin
  Result := SCallV('ORWDPS4 ISUDIV',[AnOrderID]) = '1';
end;

function GetEventIFN(const AEvntID: string): string;
begin
  Result := sCallV('OREVNTX1 EVT',[AEvntID]);
end;

function GetEventName(const AEvntID: string): string;
begin
  Result := sCallV('OREVNTX1 NAME',[AEvntID]);
end;

function GetEventLoc(const APtEvntID: string): string;
begin
  Result := SCallV('OREVNTX1 LOC', [APtEvntID]);
end;

function GetEventLoc1(const AnEvntID: string): string;
begin
  Result := SCallV('OREVNTX1 LOC1', [AnEvntID]);
end;

function GetEventDiv(const APtEvntID: string): string;
begin
  Result := SCallV('OREVNTX1 DIV',[APtEvntID]);
end;

function GetEventDiv1(const AnEvntID: string): string;
begin
  Result := SCallV('OREVNTX1 DIV1',[AnEvntID]);
end;

function GetCurrentSpec(const APtIFN: string): string;
begin
  Result := SCallV('OREVNTX1 CURSPE', [APtIFN]);
end;

function GetDefaultEvt(const AProviderIFN: string): string;
begin
  Result := SCallV('OREVNTX1 DFLTEVT',[AProviderIFN]);
end;

procedure DeleteDefaultEvt;
begin
  SCallV('OREVNTX1 DELDFLT',[User.DUZ]);
end;

function isExistedEvent(const APtDFN: string; const AEvtID: string; var APtEvtID: string): Boolean;
begin
  Result := False;
  APtEvtID := SCallV('OREVNTX1 EXISTS', [APtDFN,AEvtID]);
  if StrToIntDef(APtEvtID,0) > 0 then
   Result := True;
end;

function TypeOfExistedEvent(APtDFN: string; AEvtID: Integer): Integer;
begin
  Result := StrToIntDef(SCallV('OREVNTX1 TYPEXT', [APtDFN,AEvtID]),0);
end;

function isMatchedEvent(const APtDFN: string; const AEvtID: string; var ATs:string): Boolean;
var
  rst: string;
begin
  Result := False;
  rst := SCallV('OREVNTX1 MATCH',[APtDFN,AEvtID]);
  if StrToIntDef(Piece(rst,'^',1),0)>0 then
  begin
    ATs := Piece(rst,'^',2);
    Result := True;
  end;
end;

function isDCedOrder(const AnOrderID: string): Boolean;
var
  rst: string;
begin
  Result := False;
  rst := SCAllV('OREVNTX1 ISDCOD',[AnOrderID]);
  if STrToIntDef(rst,0)>0 then
    Result := True;
end;

function isOnholdMedOrder(AnOrderID: string): Boolean;
var
  rst: string;
begin
  Result := False;
  rst := SCAllV('OREVNTX1 ISHDORD',[AnOrderID]);
  if StrToIntDef(rst,0)>0 then
    Result := True;
end;

function SetDefaultEvent(var AErrMsg: string; EvtID: string): Boolean;
begin
  AErrMsg := SCallV('OREVNTX1 SETDFLT',[EvtID]);
  Result := True;
end;

function GetEventPromptID: integer;
var
  evtPrompt: string;
begin
  evtPrompt := SCallV('OREVNTX1 PRMPTID',[nil]);
  Result := StrToIntDef(evtPrompt,0);
end;

function GetDefaultTSForEvt(AnEvtID: integer): string;
begin
  Result := SCallV('OREVNTX1 DEFLTS',[AnEvtID]);
end;

function GetPromptIDs: string;
begin
  Result := SCallV('OREVNTX1 PROMPT IDS',[nil]);
end;

function GetEventDefaultDlg(AEvtID: integer): string;
begin
  Result := SCallV('OREVNTX1 DFLTDLG',[AEvtID]);
end;

function CanManualRelease: boolean;
var
  rst: integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('OREVNTX1 AUTHMREL',[nil]),0);
  if rst > 0 then
    Result := True;
end;

function TheParentPtEvt(APtEvt: string): string;
begin
  Result := SCallV('OREVNTX1 HAVEPRT',[APtEvt]);
end;

function IsCompletedPtEvt(APtEvtID: integer): boolean;
var
  rst : integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('OREVNTX1 COMP',[APtEvtID]),0);
  if rst > 0 then
    Result := True;
end;

function IsPassEvt(APtEvtID: integer; APtEvtType: char): boolean;
var
  rst: integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('OREVNTX1 ISPASS',[APtEvtID, APtEvtType]),0);
  if rst = 1 then
    Result := True;
end;

function IsPassEvt1(AnEvtID: integer; AnEvtType: char): boolean;
var
  rst: integer;
begin
  Result := False;
  rst := StrToIntDef(SCallV('OREVNTX1 ISPASS1',[AnEvtID, AnEvtType]),0);
  if rst = 1 then
    Result := True;
end;

procedure TerminatePtEvt(APtEvtID: integer);
begin
  SCallV('OREVNTX1 DONE',[APtEvtID]);
end;

procedure SetPtEvtList(Dest: TStrings; APtDFN: string; var ATotal: Integer);
begin
  CallV('OREVNTX LIST',[APtDFN]);
  if RPCBrokerV.Results.Count > 0 then
  begin
    ATotal := StrToIntDef(RPCBrokerV.Results[0],0);
    if ATotal > 0 then
    begin
      MixedCaseList( RPCBrokerV.Results );
      RPCBrokerV.Results.Delete(0);
      FastAssign(RPCBrokerV.Results, Dest);
    end;
  end;
end;

procedure GetTSListForEvt(Dest: TStrings; AnEvtID:integer);
begin
  CallV('OREVNTX1 MULTS',[AnEvtID]);
  if RPCBrokerV.Results.Count > 0 then
  begin
    SortByPiece(TStringList(RPCBrokerV.Results),'^',2);
    FastAssign(RPCBrokerV.Results, Dest);
  end;
end;

procedure GetChildEvent(var AChildList: TStringList; APtEvtID: string);
begin
//
end;

function DeleteEmptyEvt(APtEvntID: string; var APtEvntName: string; Ask: boolean): boolean;
const
  TX_EVTDEL1 = 'There are no orders tied to ';
  TX_EVTDEL2 = ', Would you like to cancel it?';
begin
  Result := false;
  if APtEvntID = '0' then
  begin
    Result := True;
    Exit;
  end;
  if PtEvtEmpty(APtEvntID) then
  begin
    if Length(APtEvntName)=0 then
      APtEvntName := GetEventName(APtEvntID);
    if Ask then
    begin
      if InfoBox(TX_EVTDEL1 + APtEvntName + TX_EVTDEL2, 'Confirmation', MB_YESNO or MB_ICONQUESTION) = IDYES then
      begin
        DeletePtEvent(APtEvntID);
        Result := True;
      end;
    end;
    if not Ask then
    begin
      DeletePtEvent(APtEvntID);
      Result := True;
    end;

  end;
end;

function CompleteEvt(APtEvntID: string; APtEvntName: string; Ask: boolean): boolean;
const
  TX_EVTFIN1 = 'All of the orders tied to ';
  TX_EVTFIN2 = ' have been released to a service, ' + #13 + 'Would you like to terminate this event?';
var
  ThePtEvtName: string;
begin
  Result := false;
  if APtEvntID = '0' then
  begin
    Result := True;
    Exit;
  end;
  if PtEvtEmpty(APtEvntID) then
  begin
    if Length(APtEvntName)=0 then
      ThePtEvtName := GetEventName(APtEvntID)
    else
      ThePtEvtName := APtEvntName;
    if Ask then
    begin
      if InfoBox(TX_EVTFIN1 + ThePtEvtName + TX_EVTFIN2, 'Confirmation', MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
      begin
        SCallV('OREVNTX1 DONE',[APtEvntID]);
        Result := True;
      end;
    end else
    begin
      SCallV('OREVNTX1 DONE',[APtEvntID]);
      Result := True;
    end;
  end;
end;

{ Order Checking }

function FillerIDForDialog(IEN: Integer): string;
begin
  Result := sCallV('ORWDXC FILLID', [IEN]);
end;  
function IsMonograph(): Boolean;
var ret: string;
begin
  ret := CharAt(sCallV('ORCHECK ISMONO', [nil]), 1);
  Result := ret = '1';
end;

procedure GetMonographList(ListOfMonographs: TStringList);
begin
  CallV('ORCHECK GETMONOL', []);
  FastAssign(RPCBrokerV.Results, ListOfMonographs);
end;

procedure GetMonograph(Monograph: TStringList; x: Integer);
begin
  CallV('ORCHECK GETMONO', [x]);
  FastAssign(RPCBrokerV.Results, Monograph);
end;

procedure DeleteMonograph();
begin
  CallV('ORCHECK DELMONO', []);
end;  

procedure GetXtraTxt(OCText: TStringList; x: String; y: String);
begin
  CallV('ORCHECK GETXTRA', [x,y]);
  FastAssign(RPCBrokerV.Results, OCText);
end;

function OrderChecksEnabled: Boolean;
begin
  if uOrderChecksOn = #0 then uOrderChecksOn := CharAt(sCallV('ORWDXC ON', [nil]), 1);
  Result := uOrderChecksOn = 'E';
end;

function OrderChecksOnDisplay(const FillerID: string): string;
begin
  CallV('ORWDXC DISPLAY', [Patient.DFN, FillerID]);
  with RPCBrokerV.Results do SetString(Result, GetText, Length(Text));
end;

procedure OrderChecksOnAccept(ListOfChecks: TStringList; const FillerID, StartDtTm: string;
  OIList: TStringList; DupORIFN: string; Renewal: string);
begin
  // don't pass OIList if no items, since broker pauses 5 seconds per order
  if OIList.Count > 0
    then CallV('ORWDXC ACCEPT', [Patient.DFN, FillerID, StartDtTm, Encounter.Location, OIList, DupORIFN, Renewal])
    else CallV('ORWDXC ACCEPT', [Patient.DFN, FillerID, StartDtTm, Encounter.Location]);
  FastAssign(RPCBrokerV.Results, ListOfChecks);
end;

procedure OrderChecksOnDelay(ListOfChecks: TStringList; const FillerID, StartDtTm: string;
  OIList: TStringList);
begin
  // don't pass OIList if no items, since broker pauses 5 seconds per order
  if OIList.Count > 0
    then CallV('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm, Encounter.Location, OIList])
    else CallV('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm, Encounter.Location]);
  FastAssign(RPCBrokerV.Results, ListOfChecks);
end;

procedure OrderChecksForSession(ListOfChecks, OrderList: TStringList);
begin
  CallV('ORWDXC SESSION', [Patient.DFN, OrderList]);
  FastAssign(RPCBrokerV.Results, ListOfChecks);
end;

procedure SaveOrderChecksForSession(const AReason: string; ListOfChecks: TStringList);
var
 i, inc, len, numLoop, remain: integer;
 OCStr, TmpStr: string;
begin
  //CallV('ORWDXC SAVECHK', [Patient.DFN, AReason, ListOfChecks]);
  { no result used currently }
  RPCBrokerV.ClearParameters := True;
  RPCBrokerV.RemoteProcedure := 'ORWDXC SAVECHK';
  RPCBrokerV.Param[0].PType := literal;
  RPCBrokerV.Param[0].Value := Patient.DFN;  //*DFN*
  RPCBrokerV.Param[1].PType := literal;
  RPCBrokerV.Param[1].Value := AReason;
  RPCBrokerV.Param[2].PType := list;
  RPCBrokerV.Param[2].Mult['"ORCHECKS"'] := IntToStr(ListOfChecks.count);
  for i := 0 to ListOfChecks.Count - 1 do
    begin
       OCStr := ListofChecks.Strings[i];
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
              RPCBrokerV.Param[2].Mult['"ORCHECKS",' + InttoStr(i) + ',' + InttoStr(inc)] := tmpStr;
              inc := inc +1;
            end;
          if remain > 0 then  RPCBrokerV.Param[2].Mult['"ORCHECKS",' + InttoStr(i) + ',' + inttoStr(inc)] := OCStr;

        end
      else
       RPCBrokerV.Param[2].Mult['"ORCHECKS",' + InttoStr(i)] := OCStr;
    end;
   CallBroker;
end;

function DeleteCheckedOrder(const OrderID: string): Boolean;
begin
  Result := sCallV('ORWDXC DELORD', [OrderID]) = '1';
end;

function DataForOrderCheck(const OrderID: string): string;
begin
  Result := sCallV('ORWDXR01 OXDATA',[OrderID]);
end;

(*
  TEMPORARILY COMMENTED OUT WHILE TESTING
function GetPromptandDeviceParameters(Location: integer; OrderList: TStringList; Nature: string): TPrintParams;
var
  TempParams: TPrintParams;
  x: string;
begin
  tempParams.OrdersToPrint := TStringList.Create;
  try
    CallV('ORWD1 PARAM', [Location, Nature, OrderList]);
    x := RPCBrokerV.Results[0];
    with TempParams do
      begin
        PromptForChartCopy    := CharAt(Piece(x, U, 1),1);
        if Piece(x, U, 5) <> '' then
          ChartCopyDevice     := Piece(Piece(x, U, 5),';',1) + '^' + Piece(Piece(x, U, 5),';',2);
        PromptForLabels       := CharAt(Piece(x, U, 2),1);
        if Piece(x, U, 6) <> '' then
          LabelDevice         := Piece(Piece(x, U, 6),';',1) + '^' + Piece(Piece(x, U, 6),';',2);
        PromptForRequisitions := CharAt(Piece(x, U, 3),1);
        if Piece(x, U, 7) <> '' then
          RequisitionDevice   := Piece(Piece(x, U, 7),';',1) + '^' + Piece(Piece(x, U, 7),';',2);
        PromptForWorkCopy     := CharAt(Piece(x, U, 4),1);
        if Piece(x, U, 8) <> '' then
          WorkCopyDevice      := Piece(Piece(x, U, 8),';',1) + '^' + Piece(Piece(x, U, 8),';',2);
        AnyPrompts            := ((PromptForChartCopy    in ['1','2']) or
                                  (PromptForLabels       in ['1','2']) or
                                  (PromptForRequisitions in ['1','2']) or
                                  (PromptForWorkCopy     in ['1','2']));
        RPCBrokerV.Results.Delete(0);
        FastAssign(RPCBrokerV.Results, OrdersToPrint);
      end;
    Result := TempParams;
  finally
    tempParams.OrdersToPrint.Free;
  end;
end;
*)

procedure OrderPrintDeviceInfo(OrderList: TStringList; var PrintParams: TPrintParams; Nature: Char; PrintLoc: Integer = 0);
var
  x: string;
begin
  if Nature <> #0 then
    begin
       if PrintLoc > 0 then CallV('ORWD2 DEVINFO', [PrintLoc, Nature, OrderList])
       else CallV('ORWD2 DEVINFO', [Encounter.Location, Nature, OrderList]);
    end
  else
    begin
      if PrintLoc > 0 then CallV('ORWD2 MANUAL', [PrintLoc, OrderList])
      else CallV('ORWD2 MANUAL', [Encounter.Location, OrderList]);
    end;
  x := RPCBrokerV.Results[0];
  FillChar(PrintParams, SizeOf(PrintParams), #0);
  with PrintParams do
  begin
    PromptForChartCopy    := CharAt(Piece(x, U, 1),1);
    if Piece(x, U, 5) <> '' then
      ChartCopyDevice     := Piece(Piece(x, U, 5),';',1) + '^' + Piece(Piece(x, U, 5),';',2);
    PromptForLabels       := CharAt(Piece(x, U, 2),1);
    if Piece(x, U, 6) <> '' then
      LabelDevice         := Piece(Piece(x, U, 6),';',1) + '^' + Piece(Piece(x, U, 6),';',2);
    PromptForRequisitions := CharAt(Piece(x, U, 3),1);
    if Piece(x, U, 7) <> '' then
      RequisitionDevice   := Piece(Piece(x, U, 7),';',1) + '^' + Piece(Piece(x, U, 7),';',2);
    PromptForWorkCopy     := CharAt(Piece(x, U, 4),1);
    if Piece(x, U, 8) <> '' then
    WorkCopyDevice      := Piece(Piece(x, U, 8),';',1) + '^' + Piece(Piece(x, U, 8),';',2);
    AnyPrompts            := (CharInSet(PromptForChartCopy,    ['1','2']) or
                              CharInSet(PromptForLabels,       ['1','2']) or
                              CharInSet(PromptForRequisitions, ['1','2']) or
                              CharInSet(PromptForWorkCopy,     ['1','2']));
  end;
  if Nature <> #0 then
    begin
      RPCBrokerV.Results.Delete(0);
      OrderList.Clear;
      FastAssign(RPCBrokerV.Results, OrderList);
    end;
end;

procedure SaveEvtForOrder(APtDFN: string; AEvt: integer; AnOrderID: string);
var
  TheEventID: string;
begin
  TheEventID :=  SCallV('OREVNTX1 PUTEVNT',[APtDFN,IntToStr(AEvt),AnOrderID]);
end;

function EventExist(APtDFN:string; AEvt: integer): integer;
var
  AOutCome: string;
begin
  AOutCome := SCallV('OREVNTX1 EXISTS', [APtDFN,IntToStr(AEvt)]);
  if AOutCome = '' then
    Result := 0
  else
    Result := StrToInt(AOutCome);
end;

function UseNewMedDialogs: Boolean;
begin
  Result := sCallV('ORWDPS1 CHK94', [nil]) = '1';
end;

{ Copay }
procedure GetCoPay4Orders;
begin
  RPCBrokerV.RemoteProcedure := 'ORWDPS4 CPLST';
  RPCBrokerV.Param[0].PType := literal;
  RPCBrokerV.Param[0].Value := Patient.DFN;
  CallBroker;
end;

procedure SaveCoPayStatus(AList: TStrings);
var
  i: integer;

begin
  if AList.Count > 0 then
  begin
    RPCBrokerV.ClearParameters := True;
    RPCBrokerV.RemoteProcedure := 'ORWDPS4 CPINFO';
    RPCBrokerV.Param[0].PType := list;
    for i := 0 to AList.Count-1 do
      RPCBrokerV.Param[0].Mult[IntToStr(i+1)] := AList[i];
    CallBroker;
  end;
end;

function LocationType(Location: integer): string;
begin
  Result := sCallV('ORWDRA32 LOCTYPE',[Location]);
end;

function IsValidIMOLoc(LocID: integer; PatientID: string): boolean;   //IMO
var
  rst: string;
begin
//  Result := IsCliniCloc(LocID);
  rst := SCallV('ORIMO IMOLOC',[LocID, PatientID]);
  Result := StrToIntDef(rst,-1) > -1;
end;

function IsIMOOrder(OrderID: string): boolean;          //IMO
begin
  Result := SCallV('ORIMO IMOOD',[OrderId])='1';
end;

function IsInptQO(DlgID: integer): boolean;
begin
  Result := SCallV('ORWDXM3 ISUDQO', [DlgID]) = '1';
end;

function IsIVQO(DlgID: integer): boolean;
begin
  Result := SCallV('ORIMO ISIVQO', [DlgID]) = '1';
end;

function IsClinicLoc(ALoc: integer): boolean;
begin
  Result := SCallV('ORIMO ISCLOC', [ALoc]) = '1';
end;

function IsValidSchedule(AnOrderID: string): boolean; //nss
begin
  result := SCallV('ORWNSS VALSCH', [AnOrderID]) = '1';
end;

function IsValidQOSch(QOID: string): string;  //nss
begin
  Result := SCallV('ORWNSS QOSCH',[QOID]);
end;

function IsValidSchStr(ASchStr: string): boolean;
begin
  Result := SCallV('ORWNSS CHKSCH',[ASchStr]) = '1';
end;

function IsPendingHold(OrderID: string): boolean;
var
  ret: string;
begin
  ret := sCallV('ORDEA PNDHLD', [OrderID]);
  if ret = '1' then Result :=  True
  else Result := False;
end;

{ TParentEvent }

procedure TParentEvent.Assign(AnEvtID: string);
var
  evtInfo: string;
begin
// ORY = EVTTYPE_U_EVT_U_EVTNAME_U_EVTDISP_U_EVTDLG
  evtInfo := EventInfo1(AnEvtID);
  ParentIFN := StrToInt(AnEvtID);
  if Length(Piece(evtInfo,'^',4)) < 1 then
    ParentName := Piece(evtInfo,'^',3)
  else
    ParentName := Piece(evtInfo,'^',4);
  ParentType := CharAt(Piece(evtInfo,'^',1),1);
  ParentDlg := Piece(evtInfo,'^',5);
end;

constructor TParentEvent.Create;
begin
  ParentIFN  := 0;
  ParentName := '';
  ParentType := #0;
  ParentDlg  := '0';
end;

initialization
  uDGroupAll := 0;
  uOrderChecksOn := #0;

finalization
  if uDGroupMap <> nil then uDGroupMap.Free;

end.


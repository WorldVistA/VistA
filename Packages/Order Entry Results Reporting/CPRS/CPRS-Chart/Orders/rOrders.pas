unit rOrders;
{ ------------------------------------------------------------------------------
  Update History

  2016-09-23: NSR#20101203 (Critical/High Order Checks)
  2018-07-27: RTC 272867 (Replacing old server calls with CallVistA)
  ---------------------------------------------------------------------------- }
{$OPTIMIZATION OFF}

interface

uses SysUtils, Classes, ORFn, ORNet, uCore, Dialogs, Controls;

type
  TOrder = class
  // WARNING: When adding or removing fields on TOrder, make sure to update the
  // Assign and Clear methods too!
  private
    FPackage: string;
  public
    ICD9Code: string;
    ID: string;
    DGroup: Integer;
    OrderTime: TFMDateTime;
    StartTime: string;
    StopTime: string;
    Status: Integer;
    Signature: Integer;
    VerNurse: string;
    VerClerk: string;
    ChartRev: string;
    Provider: Int64;
    ProviderName: string;
    ProviderDEA: string;
    ProviderVa: string;
    DigSigReq: string;
    XMLText: string;
    Text: string;
    DGroupSeq: Integer;
    DGroupName: string;
    Flagged: Boolean;
    Retrieved: Boolean;
    EditOf: string;
    ActionOn: string;
    EventPtr: string; // ptr to #100.2
    EventName: string; // Event name in #100.5
    OrderLocIEN: string; // imo
    OrderLocName: string; // imo
    ParentID: string;
    ParkedStatus: String; // PaPI NSR#20090509 AA 2015/09/29
    LinkObject: TObject;
    EnteredInError: Integer; // AGP Changes 26.12 PSI-04-053
    ORUAPreviewresult:      string;
    DCOriginalOrder: Boolean;
    IsOrderPendDC: Boolean;
    IsDelayOrder: Boolean;
    IsControlledSubstance: Boolean;
    IsDetox: Boolean;
    FlagText: string;
    IsFlagTextLoaded: boolean;
    procedure Assign(Source: TOrder);
    function GetPackage: string;
    procedure Clear;
  end;

  TParentEvent = record //class
  public
    ParentIFN: Integer;
    ParentName: string;
    ParentType: Char;
    ParentDlg: string;
    constructor Create(Nothing: integer);
    procedure Assign(AnEvtID: string);
  end;

  TOrderDelayEvent = record
    EventType: Char; // A=admit, T=transfer, D=discharge, C=current
    TheParent: TParentEvent; // Parent Event
    EventIFN: Integer; // Pointer to OE/RR EVENTS file (#100.5)
    EventName: String; // Event name from OR/RR EVENTS file (#100.5)
    PtEventIFN: Integer; // Patient event IFN ptr to #100.2
    Specialty: Integer; // pointer to facility treating specialty file
    Effective: TFMDateTime; // effective date/time (estimated start time)
    IsNewEvent: Boolean; // is new event for an patient
  end;

  TOrderDialogResolved = record
    InputID: string; // can be dialog IEN or '#ORIFN'
    QuickLevel: Integer; // 0=dialog,1=auto,2=verify,8=reject,9=cancel
    ResponseID: string; // DialogID + ';' + $H
    DialogIEN: Integer; // pointer to 101.41 for dialog (may be quick order IEN)
    DialogType: Char; // type of dialog (Q or D)
    FormID: Integer; // windows form to display
    DisplayGroup: Integer; // pointer to 100.98, display group for dialog
    ShowText: string; // text to show for verify or rejection
    QOKeyVars: string; // from entry action of quick order
  end;

  TNextMoveRec = record
    NextStep: Integer;
    LastIndex: Integer;
  end;

  TOrderMenu = class
    IEN: Integer;
    NumCols: Integer;
    Title: string;
    KeyVars: string;
    MenuItems: TList; { of TOrderMenuItem }
  end;

  TOrderMenuItem = class
  public
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
    BaseType: Integer;
    StartTime: string;
    StopTime: string;
    Refills: Integer;
    Pickup: string;
    DaysSupply: Integer;
    Quantity: string;
    DispUnit: string;
    Comments: string;
    NewText: string;
    TitrationMsg: string;
  end;

  TPrintParams = record
    PromptForChartCopy: Char;
    ChartCopyDevice: string;
    PromptForLabels: Char;
    LabelDevice: string;
    PromptForRequisitions: Char;
    RequisitionDevice: string;
    PromptForWorkCopy: Char;
    WorkCopyDevice: string;
    AnyPrompts: Boolean;
    // OrdersToPrint         :  TStringList; {*KCM*}
  end;

  TOrderView = class
  public
    Changed: Boolean; // true when view has been modified
    DGroup: Integer; // display group (pointer value)
    Filter: Integer; // FLGS parameter passed to ORQ
    InvChrono: Boolean; // true for inverse chronological order
    ByService: Boolean; // true for grouping orders by service
    TimeFrom: TFMDateTime; // beginning time for orders in list
    TimeThru: TFMDateTime; // ending time for orders in list
    CtxtTime: TFMDateTime; // set by server, context hours begin time
    TextView: Integer; // set by server, 0 if mult views of same order
    ViewName: string; // display name for the view
    EventDelay: TOrderDelayEvent; // fields for event delay view
  public
    procedure Assign(Src: TOrderView);

  end;

  { Order List functions }
function getDetailOrder(const ID: string;aList: TStrings):Boolean;
function ResultOrder(const ID: string;aList: TStrings):Boolean;
function getResultOrderHistory(const ID: string;aList: TStrings):Boolean;
function NameOfStatus(IEN: Integer): string;
function GetOrderStatus(AnOrderId: string): Integer;
function ExpiredOrdersStartDT: TFMDateTime;
procedure ClearOrders(AList: TList);
procedure LoadOrders(Dest: TList; Filter, Groups: Integer);
procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView;
  APtEvtID: string); overload;
procedure LoadOrdersAbbr(DestDC, DestRL: TList; AView: TOrderView;
  APtEvtID: string); overload;
procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; APtEvtID: string;
  AlertID: string); overload;
procedure LoadOrderSheets(Dest: TStrings);
procedure LoadOrderSheetsED(Dest: TStrings);
procedure LoadOrderViewDefault(AView: TOrderView);
procedure LoadUnsignedOrders(IDList, HaveList: TStrings);
procedure SaveOrderViewDefault(AView: TOrderView);
procedure RetrieveOrderFields(OrderList: TList; ATextView: Integer;
  ACtxtTime: TFMDateTime);
procedure SetOrderFields(AnOrder: TOrder; const x, y, z: string);
procedure SetOrderFromResults(AnOrder: TOrder; Results: TStrings); overload;
procedure SortOrders(AList: TList; ByGroup, InvChron: Boolean);
//procedure ConvertOrders(Dest: TList; AView: TOrderView);

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
function CheckOrderGroup(AOrderID: string): Integer;
function CheckQOGroup(AQOId: string): Boolean;

{ Write Orders }
procedure BuildResponses(var ResolvedDialog: TOrderDialogResolved;
  const KeyVars: string; AnEvent: TOrderDelayEvent; ForIMO: Boolean = False);
procedure ClearOrderRecall;
function CommonLocationForOrders(OrderList: TStringList): Integer;
function FormIDForDialog(IEN: Integer): Integer;
function DlgIENForName(DlgName: string): Integer;
procedure LoadOrderMenu(AnOrderMenu: TOrderMenu; AMenuIEN: Integer);
procedure LoadOrderSet(SetItems: TStrings; AnIEN: Integer;
  var KeyVars, ACaption: string);
procedure LoadWriteOrders(Dest: TStrings);
procedure LoadWriteOrdersED(Dest: TStrings; EvtID: string);
function OrderDisabledMessage(DlgIEN: Integer): string;
procedure SendOrders(OrderList: TStringList; const ESCode: string);
procedure SendReleaseOrders(OrderList: TStringList);
procedure SendAndPrintOrders(OrderList, ErrList: TStrings; const ESCode: string;
  const DeviceInfo: string);
procedure ExecutePrintOrders(SelectedList: TStringList;
  const DeviceInfo: string);
procedure PrintOrdersOnReview(OrderList: TStringList; const DeviceInfo: string;
  PrintLoc: Integer = 0); { *KCM* }
procedure PrintServiceCopies(OrderList: TStringList;
  PrintLoc: Integer = 0); { *REV* }
procedure OrderPrintDeviceInfo(OrderList: TStringList;
  var PrintParams: TPrintParams; Nature: Char; PrintLoc: Integer = 0); { *KCM* }
function UseNewMedDialogs: Boolean;

{ Order Actions }
function DialogForOrder(const ID: string): Integer;
procedure LockPatient(var ErrMsg: string);
procedure UnlockPatient;
procedure LockOrder(OrderID: string; var ErrMsg: string; const AnAction: string = '');
procedure UnlockOrder(OrderID: string);
procedure UnlockAllOrders();
procedure UnlockAllOrdersByAction(AnAction: string);
procedure UnlockAllLocks();
procedure UnlockAllPatientLocks();
function FormIDForOrder(const ID: string): Integer;
procedure WarningOrderAction(const ID, Action: string; var ErrMsg: string);
procedure ValidateOrderAction(const ID, Action: string; var ErrMsg: string);
procedure ValidateOrderActionNature(const ID, Action, Nature: string;
  var ErrMsg: string);
procedure IsLatestAction(const ID: string; var ErrList: TStringList);
//procedure ChangeOrder(AnOrder: TOrder; ResponseList: TList);
procedure RenewOrder(AnOrder: TOrder; RenewFields: TOrderRenewFields;
  IsComplex: Integer; AnIMOOrderAppt: double; OCList: TStringList);
procedure HoldOrder(AnOrder: TOrder);
procedure ListDCReasons(Dest: TStrings; var DefaultIEN: Integer);
function GetREQReason: Integer;
procedure DCOrder(AnOrder: TOrder; AReason: Integer; NewOrder: Boolean;
  var DCType: Integer);
procedure ReleaseOrderHold(AnOrder: TOrder);
procedure AlertOrder(AnOrder: TOrder; AlertRecip: Int64);

// NSR #20110719  -- begin
function UnflagOrder(AnOrder: TOrder; const AComment: String; var ErrMsg:String):TStrings;
function getFlagOrderResults(AnOrder: TOrder; const FlagReason,ExpireDate: String;
  AlertRecip: TStrings; Results:TStrings):Boolean;

procedure getFlagComponents(Dest: TStrings; const anID,aType: string);
function setFlagComments(const anID: String;aComments,aRecipients: TStrings;Results: TStrings):Boolean;
// NSR #20110719 -- end

procedure LoadFlagReason(Dest: TStrings; const ID: string);
procedure LoadFlagReasons(AOrderList: TList);

procedure LoadWardComments(Dest: TStrings; const ID: string);
procedure PutWardComments(Src: TStrings; const ID: string; var ErrMsg: string);
procedure CompleteOrder(AnOrder: TOrder; const ESCode: string);
procedure VerifyOrder(AnOrder: TOrder; const ESCode: string);
procedure VerifyOrderChartReview(AnOrder: TOrder; const ESCode: string);
function GetOrderableIen(AnOrderId: string): Integer;
procedure StoreDigitalSig(AID, AHash: string; AProvider: Int64;
  ASig, ACrlUrl, DFN: string; var AError: string);
procedure UpdateOrderDGIfNeeded(AnID: string);
function CanEditSuchRenewedOrder(AnID: string; IsTxtOrder: Integer): Boolean;
function IsPSOSupplyDlg(DlgID: string; QODlg: Integer): Boolean;
procedure SaveChangesOnRenewOrder(var AnOrder: TOrder;
  AnID, TheRefills, ThePickup: string; IsTxtOrder: Integer;
        DaysSupply, Quantity: string);
function DoesOrderStatusMatch(OrderArray: TStringList): Boolean;
// function GetPromptandDeviceParameters(Location: integer; OrderList: TStringList; Nature: string): TPrintParams;

{ Order Information }
procedure LoadRenewFields(RenewFields: TOrderRenewFields; const ID: string);
procedure GetChildrenOfComplexOrder(AnParentID, CurrAct: string;
  var ChildList: TStringList); // PSI-COMPLEX
procedure LESValidationForChangedLabOrder(var RejectedReason: TStringList;
  AnOrderInfo: string);
procedure ValidateComplexOrderAct(AnOrderId: string; var ErrMsg: string);
// PSI-COMPLEX
function IsRenewableComplexOrder(AnParentID: string): Boolean; // PSI-COMPLEX
function IsComplexOrder(AnOrderId: string): Boolean; // PSI-COMPLEX
function GetDlgData(ADlgID: string): string;
function OrderIsReleased(const ID: string): Boolean;
function TextForOrder(const ID: string): string;
function GetConsultOrderNumber(ConsultIEN: string): string;
function GetOrderByIFN(const ID: string): TOrder;
function GetPackageByOrderID(const OrderID: string): string;
function AnyOrdersRequireSignature(OrderList: TStringList): Boolean;
function OrderRequiresSignature(const ID: string): Boolean;
function OrderRequiresDigitalSignature(const ID: string): Boolean;
function GetDrugSchedule(const ID: string;Default:String = ''): string;
//function GetExternalText(const ID: string;Default:String = ''): string;
//function SetExternalText(const ID: string; ADrugSch: string;
//  AUser: Int64): string;
function GetDEA(const ID: string): string;
function GetDigitalSignature(const ID: string): string;
function GetPKIUse: Boolean;
function GetPKISite: Boolean;
function DoesOIPIInSigForQO(AnQOID: Integer): Integer;
function GetDispGroupForLES: string;
function GetOrderPtEvtID(AnOrderId: string): string;
function VerbTelPolicyOrder(AnOrderId: string): Boolean;
function ForIVandUD(AnOrderId: string): Boolean;

{ Event Delay Enhancement }
function DeleteEmptyEvt(APtEvntID: string; var APtEvntName: string;
  Ask: Boolean = True): Boolean;
function DispOrdersForEvent(AEvtId: string): Boolean;
function EventInfo(APtEvtID: string): string; // ptr to #100.2
function EventInfo1(AnEvtID: string): string; // ptr to #100.5
function EventExist(APtDFN: string; AEvt: Integer): Integer;
function CompleteEvt(APtEvntID: string; APtEvntName: string;
  Ask: Boolean = True): Boolean;
function PtEvtEmpty(APtEvtID: string): Boolean;
function GetEventIFN(const AEvntID: string): string;
function GetEventName(const AEvntID: string): string;
function GetEventLoc(const APtEvntID: string): string;
function GetEventLoc1(const AnEvntID: string): string;
function GetEventDiv(const APtEvntID: string): string;
function GetEventDiv1(const AnEvntID: string): string;
function GetCurrentSpec(const APtIFN: string): string;
function GetDefaultEvt(const AProviderIFN: string): string;
function isExistedEvent(const APtDFN: string; const AEvtId: string;
  var APtEvtID: string): Boolean;
function TypeOfExistedEvent(APtDFN: string; AEvtId: Integer): Integer;
function isMatchedEvent(const APtDFN: string; const AEvtId: string;
  var ATs: string): Boolean;
function isDCedOrder(const AnOrderId: string): Boolean;
function isOnholdMedOrder(AnOrderId: string): Boolean;
function SetDefaultEvent(var AErrMsg: string; EvtID: string): Boolean;
function GetEventPromptID: Integer;
function GetDefaultTSForEvt(AnEvtID: Integer): string;
function GetPromptIDs: string;
function GetEventDefaultDlg(AEvtId: Integer): string;
function CanManualRelease: Boolean;
function TheParentPtEvt(APtEvt: string): string;
function IsCompletedPtEvt(APtEvtID: Integer): Boolean;
function IsPassEvt(APtEvtID: Integer; APtEvtType: Char): Boolean;
function IsPassEvt1(AnEvtID: Integer; AnEvtType: Char): Boolean;
procedure DeleteDefaultEvt;
procedure TerminatePtEvt(APtEvtID: Integer);
procedure ChangeEvent(AnOrderList: TStringList; APtEvtID: string);
procedure DeletePtEvent(APtEvtID: string);
procedure SaveEvtForOrder(APtDFN: string; AEvt: Integer; AnOrderId: string);
procedure SetPtEvtList(Dest: TStrings; APtDFN: string; var ATotal: Integer);
procedure GetTSListForEvt(Dest: TStrings; AnEvtID: Integer);
//procedure GetChildEvent(var AChildList: TStringList; APtEvtID: string);

{ Order Checking }
function IsMonograph(): Boolean;
procedure DeleteMonograph();
procedure GetMonographList(ListOfMonographs: TStringList);
procedure GetMonograph(Monograph: TStringList; x: Integer);
procedure GetXtraTxt(OCText: TStringList; x: String; y: String);
function FillerIDForDialog(IEN: Integer): string;
function OrderChecksEnabled: Boolean;
function OrderChecksOnDisplay(const FillerID: string): string;
procedure OrderChecksOnAccept(ListOfChecks: TStringList;
  const FillerID, StartDtTm: string; OIList: TStringList; DupORIFN: string;
  Renewal: string; Fields: string; IncludeAllergyChecks: boolean = False);
procedure GetAllergyReasonList(aList: TStrings; Item1: Integer; AFlag: String);
procedure OrderChecksOnMedicationSelect(ListOfChecks: TStringList;
  const FillerID: String; Item1: Integer; OrderNum: string = '');
procedure ClearAllergyOrderCheckCache;
procedure OrderChecksOnDelay(ListOfChecks: TStringList;
  const FillerID, StartDtTm: string; OIList: TStringList);
procedure OrderChecksForSession(ListOfChecks, OrderList: TStringList);
procedure SaveOrderChecksForSession(const AReason: string;
  ListOfChecks: TStringList);
procedure SaveMultiOrderChecksForSession(ListOfChecks, ListOfReasons, ListOfComments: TStringList);
function DeleteCheckedOrder(const OrderID: string): Boolean;
function DataForOrderCheck(const OrderID: string): string;
function IsValidOverrideReason(const Reason: string): boolean;

{ Copay }
procedure SaveCoPayStatus(AList: TStrings);

{ IMO: inpatient medication for outpatient }
function LocationType(Location: Integer): string;
function IsValidIMOLoc(LocID: Integer; PatientID: string): Boolean; // IMO
function IsValidIMOLocOrderCom(LocID: Integer; PatientID: string): Boolean;
// IMO
function IsIMOOrder(OrderID: string): Boolean;
function IsInptQO(DlgID: Integer): Boolean;
function IsIVQO(DlgID: Integer): Boolean;
function IsClinicLoc(ALoc: Integer): Boolean;

{ None-standard Schedule } // nss
function IsValidSchedule(AnOrderId: string): Boolean; // NSS
function IsValidQOSch(QOID: string): string; // NSS
function IsValidSchStr(ASchStr: string): Boolean;

function IsPendingHold(OrderID: string): Boolean;

//procedure SetOrderRevwCol(AnOrder: TOrder);
function SetOrderRevwCol(AnOrder: TOrder):String;

function SafeEventType(CurrentEventType: Char): Char;

type TOrderableItemInfoType = (oitNone, oitLabService);

procedure GetOrderableItemInfo(Dest: TStrings; InfoNeeded: TOrderableItemInfoType);
function GetGroupsUsedByXRef(XREF: string): string;
procedure GetDieteticsGroupInfo(Dest: TStrings);

var
  UAPViewCalling: Boolean;

implementation

uses Windows, rCore, uConst, TRPCB, ORCtrls, UBAGlobals, UBACore, VAUtils
  , ORNetIntf // NSR#20101203
  , System.Generics.Collections;

type
  TLockType = (ltPatient, ltOrder);

  TLock = class
  private
    FID: String;
    FAction: string;
    FLockType: TLockType;
  public
    property ID: string read FID write FID;
    property Action: string read FAction write FAction;
    property LockType: TLockType read FLockType write FLockType;
  end;

  TLockList = Class(TObjectList<TLock>)
  public
    destructor Destroy; override;
    procedure AddLock(AID, AAction: string; ALockType: TLockType);
    procedure DeleteLock(AID: string; ALockType: TLockType);
    procedure ClearAllLocks;
    procedure ClearLockByID(AID: string; ALockType: TLockType);
    procedure ClearLocksByAction(AnAction: string);
    procedure ClearLocksByType(ALockType: TLockType);
  end;

var
  uDGroupMap: TStringList; // each string is DGroupIEN=Sequence^TopName^Name
  uDGroupAll: Integer;
  uOrderChecksOn: Char;
  LockList: TLockList;

  { TOrderView methods }

procedure TOrderView.Assign(Src: TOrderView);
begin
  Self.Changed := Src.Changed;
  Self.DGroup := Src.DGroup;
  Self.Filter := Src.Filter;
  Self.InvChrono := Src.InvChrono;
  Self.ByService := Src.ByService;
  Self.TimeFrom := Src.TimeFrom;
  Self.TimeThru := Src.TimeThru;
  Self.CtxtTime := Src.CtxtTime;
  Self.TextView := Src.TextView;
  Self.ViewName := Src.ViewName;
  Self.EventDelay.EventIFN := Src.EventDelay.EventIFN;
  Self.EventDelay.EventName := Src.EventDelay.EventName;
  Self.EventDelay.EventType := Src.EventDelay.EventType;
  Self.EventDelay.Specialty := Src.EventDelay.Specialty;
  Self.EventDelay.Effective := Src.EventDelay.Effective;
end;

{ TOrder methods }

procedure TOrder.Assign(Source: TOrder);
// When updating the Assign method, please keep fields in order as they are
// defined on the TOrder object!!!
begin
  FPackage := Source.FPackage;
  ICD9Code := Source.ICD9Code;
  ID := Source.ID;
  DGroup := Source.DGroup;
  OrderTime := Source.OrderTime;
  StartTime := Source.StartTime;
  StopTime := Source.StopTime;
  Status := Source.Status;
  Signature := Source.Signature;
  VerNurse := Source.VerNurse;
  VerClerk := Source.VerClerk;
  ChartRev := Source.ChartRev;
  Provider := Source.Provider;
  ProviderName := Source.ProviderName;
  ProviderDEA := Source.ProviderDEA;
  ProviderVa := Source.ProviderVa;
  DigSigReq := Source.DigSigReq;
  XMLText := Source.XMLText;
  Text := Source.Text;
  DGroupSeq := Source.DGroupSeq;
  DGroupName := Source.DGroupName;
  Flagged := Source.Flagged;
  Retrieved := Source.Retrieved;
  EditOf := Source.EditOf;
  ActionOn := Source.ActionOn;
  EventPtr := Source.EventPtr;
  EventName := Source.EventName;
  OrderLocIEN := Source.OrderLocIEN;
  OrderLocName := Source.OrderLocName;
  ParentID := Source.ParentID;
  ParkedStatus := Source.ParkedStatus; // PaPI NSR#20090509 AA 2015/09/29
  LinkObject := Source.LinkObject;
  EnteredInError := Source.EnteredInError;
  ORUAPreviewresult := Source.ORUAPreviewresult;
  DCOriginalOrder := Source.DCOriginalOrder;
  IsOrderPendDC:= Source.IsOrderPendDC;
  IsDelayOrder := Source.IsDelayOrder;
  IsControlledSubstance := Source.IsControlledSubstance;
  IsDetox := Source.IsDetox;
  FlagText := Source.FlagText;
  IsFlagTextLoaded := Source.IsFlagTextLoaded;
end;

procedure TOrder.Clear;
// When updating the Clear method, please keep fields in order as they are
// defined on the TOrder object!!!
begin
  FPackage := '';
  ICD9Code := '';
  ID := '';
  DGroup := 0;
  OrderTime := 0;
  StartTime := '';
  StopTime := '';
  Status := 0;
  Signature := 0;
  VerNurse := '';
  VerClerk := '';
  ChartRev := '';
  Provider := 0;
  ProviderName := '';
  ProviderDEA := '';
  ProviderVa := '';
  DigSigReq := '';
  XMLText := '';
  Text := '';
  DGroupSeq := 0;
  DGroupName := '';
  Flagged := False;
  Retrieved := False;
  EditOf := '';
  ActionOn := '';
  OrderLocIEN := ''; // imo
  OrderLocName := ''; // imo
  ParentID := '';
  ParkedStatus := '';
  LinkObject := nil;
  EnteredInError := 0;
  ORUAPreviewresult := '';
  DCOriginalOrder := False;
  IsOrderPendDC := False;
  IsDelayOrder := False;
  IsControlledSubstance := False;
  IsDetox := False;
  FlagText := '';
  IsFlagTextLoaded := False;
end;

function TOrder.GetPackage: string;
begin
  if FPackage = '' then
    FPackage := GetPackageByOrderID(ID);
  Result := FPackage;
end;

{ Order List functions }

function getDetailOrder(const ID: string;aList: TStrings):Boolean;
begin
  Result := CallVistA('ORQOR DETAIL', [ID, Patient.DFN],aList);
end;

function ResultOrder(const ID: string;aList: TStrings):Boolean;
begin
  Result := CallVistA('ORWOR RESULT', [Patient.DFN, ID, ID],aList);
end;

function getResultOrderHistory(const ID: string;aList: TStrings):Boolean;
begin
  Result := CallVistA('ORWOR RESULT HISTORY', [Patient.DFN, ID, ID],aList);
end;

procedure LoadDGroupMap;
begin
  if uDGroupMap = nil then
  begin
    uDGroupMap := TStringList.Create;
    CallVistA('ORWORDG MAPSEQ', [nil],uDGroupMap);
  end;
end;

function NameOfStatus(IEN: Integer): string;
begin
  case IEN of
    0:
      Result := 'error';
    1:
      Result := 'discontinued';
    2:
      Result := 'complete';
    3:
      Result := 'hold';
    4:
      Result := 'flagged';
    5:
      Result := 'pending';
    6:
      Result := 'active';
    7:
      Result := 'expired';
    8:
      Result := 'scheduled';
    9:
      Result := 'partial results';
    10:
      Result := 'delayed';
    11:
      Result := 'unreleased';
    12:
      Result := 'dc/edit';
    13:
      Result := 'cancelled';
    14:
      Result := 'lapsed';
    15:
      Result := 'renewed';
    97:
      Result := ''; { null status, used for 'No Orders Found.' }
    98:
      Result := 'new';
    99:
      Result := 'no status';
  end;
end;

function GetOrderStatus(AnOrderId: string): Integer;
begin
  if not CallVistA('OREVNTX1 GETSTS', [AnOrderId],Result) then
    Result := 0;
end;

function ExpiredOrdersStartDT: TFMDateTime;
//  Returns FM date/time to begin search for expired orders
var
  s: String;
begin
  if CallVistA('ORWOR EXPIRED', [nil],s) then
    Result := MakeFMDateTime(s)
  else
    Result := -1;
end;

function DispOrdersForEvent(AEvtId: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('OREVNTX1 CPACT', [AEvtId], s) and
      (StrToIntDef(s, -1) > 0);
end;

function EventInfo(APtEvtID: string): string;
begin
  CallVistA('OREVNTX1 GTEVT', [APtEvtID],Result)
end;

function EventInfo1(AnEvtID: string): string;
begin
  CallVistA('OREVNTX1 GTEVT1', [AnEvtID],Result);
end;

function NameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then
    LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 3);
end;

function ShortNameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then
    LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 4);
end;

function SeqOfDGroup(IEN: Integer): Integer;
var
  x: string;
begin
  if uDGroupMap = nil then
    LoadDGroupMap;
  x := uDGroupMap.Values[IntToStr(IEN)];
  Result := StrToIntDef(Piece(x, U, 1), 0);
end;

function CheckOrderGroup(AOrderID: string): Integer;
begin
  // Result = 1     Inpatient Medication Display Group;
  // Result = 2     OutPatient Medication Display Group;
  // Result = 0     None of In or Out patient display group;

  if not CallVistA('ORWDPS2 CHKGRP', [AOrderID],Result) then
      Result := -1;
end;

function CheckQOGroup(AQOId: string): Boolean;
var
  rst: Integer;
begin
  Result := CallVistA('ORWDPS2 QOGRP', [AQOId],rst) and (rst>0);
end;

function TopNameOfDGroup(IEN: Integer): string;
begin
  if uDGroupMap = nil then
    LoadDGroupMap;
  Result := uDGroupMap.Values[IntToStr(IEN)];
  Result := Piece(Result, U, 2);
end;

procedure ClearOrders(AList: TList);
var
  i: Integer;
begin
  with AList do
    for i := 0 to Count - 1 do
      with TOrder(Items[i]) do
        Free;
  AList.Clear;
end;

function SetOrderRevwCol(AnOrder: TOrder):String;
begin
  CallVistA('ORTO GETRVW', [AnOrder.ID],Result);
  AnOrder.ORUAPreviewresult := Result;
end;

procedure SetOrderFields(AnOrder: TOrder; const x, y, z: string);
{ 1   2    3     4      5     6   7   8   9    10    11    12    13    14     15     16  17    18    19     20         21          22              23               24
  { Pieces: ~IFN^Grp^ActTm^StrtTm^StopTm^Sts^Sig^Nrs^Clk^PrvID^PrvNam^ActDA^Flag^DCType^ChrtRev^DEA#^VA#^DigSig^IMO^DCOrigOrder^ISDCOrder^IsDelayOrder^IsControlledSubstance^IsDetox }
begin
  with AnOrder do
  begin
    Clear;
    ID := Copy(Piece(x, U, 1), 2, Length(Piece(x, U, 1)));
    DGroup := StrToIntDef(Piece(x, U, 2), 0);
    OrderTime := MakeFMDateTime(Piece(x, U, 3));
    StartTime := Piece(x, U, 4);
    StopTime := Piece(x, U, 5);
    Status := StrToIntDef(Piece(x, U, 6), 0);
    Signature := StrToIntDef(Piece(x, U, 7), 0);
    VerNurse := Piece(x, U, 8);
    VerClerk := Piece(x, U, 9);
    ChartRev := Piece(x, U, 15);
    Provider := StrToInt64Def(Piece(x, U, 10), 0);
    ProviderName := Piece(x, U, 11);
    ProviderDEA := Piece(x, U, 16);
    ProviderVa := Piece(x, U, 17);
    DigSigReq := Piece(x, U, 18);
    Flagged := Piece(x, U, 13) = '1';
    Retrieved := True;
    OrderLocIEN := Piece(Piece(x, U, 19), ':', 2); // imo
    if Piece(Piece(x, U, 19), ':', 1) = '0;SC(' then
      OrderLocName := 'Unknown'
    else
      OrderLocName := Piece(Piece(x, U, 19), ':', 1); // imo
    Text := y;
    XMLText := z;
    DGroupSeq := SeqOfDGroup(DGroup);
    DGroupName := TopNameOfDGroup(DGroup);
    // AGP Changes 26.15 PSI-04-063
    if (pos('Entered in error', Text) > 0) then
      AnOrder.EnteredInError := 1
    else
      AnOrder.EnteredInError := 0;
    // if DGroupName = 'Non-VA Meds' then Text := 'Non-VA  ' + Text;
    if UAPViewCalling then
      SetOrderRevwCol(AnOrder);
    if Piece(x, U, 20) = '1' then
      DCOriginalOrder := True
    else
      DCOriginalOrder := False;
    if Piece(x, U, 21) = '1' then
      IsOrderPendDC := True
    else
      IsOrderPendDC := False;
    if Piece(x, U, 22) = '1' then
      IsDelayOrder := True
    else
      IsDelayOrder := False;
    if Piece(x, U, 23) = '1' then
      IsControlledSubstance := True
    else
      IsControlledSubstance := False;
    if Piece(x, U, 24) = '1' then
      IsDetox := True
    else
      IsDetox := False;
    ParkedStatus := Piece(x, U, 25); // PaPI NSR#20090509 AA 2015/09/29
    FPackage := Piece(x, U, 26);
    FlagText := '';
    IsFlagTextLoaded := False;
  end;
end;

procedure LoadOrders(Dest: TList; Filter, Groups: Integer);
var
  Results: TStringList;
  x, y, z: string;
  AnOrder: TOrder;
begin
  ClearOrders(Dest);
  if uDGroupMap = nil then
    LoadDGroupMap; // to make sure broker not called while looping thru Results
  Results := TStringList.Create;
  try
    if not CallVistA('ORWORR GET', [Patient.DFN, Filter, Groups], Results) then
    begin
      // Add error processing if needed //      Results.Clear;
    end;
    while Results.Count > 0 do
    begin
      x := Results[0];
      Results.Delete(0);
      if CharAt(x, 1) <> '~' then
        Continue; // only happens if out of synch
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
      AnOrder := TOrder.Create;
      SetOrderFields(AnOrder, x, y, z);
      Dest.Add(AnOrder);
    end;
  finally
    Results.Free;
  end;
end;

procedure ConvertOrders(Dest: TList; AView: TOrderView; Results:TStrings);
var
  i: Integer;
  AnOrder: TOrder;
begin
  if Results.Count < 1 then
    exit;
  AView.TextView := StrToIntDef(Piece(Results[0], U, 2), 0);
  AView.CtxtTime := MakeFMDateTime(Piece(Results[0], U, 3));
    for i := 1 to Results.Count - 1 do // if orders found (skip 0 element)
    begin
      if (Piece(Results[i], U, 1) = '0') or
        (Piece(Results[i], U, 1) = '') then
        Continue;
      if (DelimCount(Results[i], U) = 2) then
        Continue;
      AnOrder := TOrder.Create;
      with AnOrder do
      begin
        ID := Piece(Results[i], U, 1);
        DGroup := StrToIntDef(Piece(Results[i], U, 2), 0);
        OrderTime := MakeFMDateTime(Piece(Results[i], U, 3));
        EventPtr := Piece(Results[i], U, 4);
        EventName := Piece(Results[i], U, 5);
        DGroupSeq := SeqOfDGroup(DGroup);
      end;
      Dest.Add(AnOrder);
    end;
end;

procedure RefreshOrders(AOrigList, ADestList: TList);
// Refreshes all order in ADestList, adds any orders from AOrigList that are
// not in ADestList, and removes orders in ADestList that are not in
// AOrigList. In the end, the ADestList contain the data to from
// AOrigList, in the order from AOrigList, but the objects in ADestList were
// refreshed, and NOT destroyed, where possible!
// All objects in AOrigLists will be either freed or transfered!
var
  AFreeList: TObjectList<TObject>;

  procedure MarkFree(AObject: TObject);
  begin
    try
      AFreeList.Add(AObject);
    except
      AObject.Free;
      raise;
    end;
  end;

var
  I: Integer;
  AOrig: TObject;
  AOrder: TOrder;
  AOrderList: TObjectList<TOrder>;
  Found: Boolean;
begin
  AOrderList := TObjectList<TOrder>.Create(False);
  try
    AFreeList := TObjectList<TObject>.Create(True);
    try
      for I := 0 to ADestList.Count - 1 do
        if TObject(ADestList[I]) is TOrder then
          AOrderList.Add(TOrder(ADestList[I]))
        else
          AFreeList.Add(TObject(ADestList[I]));

      try
        ADestList.Clear;
        for I := 0 to AOrigList.Count - 1 do
        begin
          AOrig := TObject(AOrigList[I]);
          Found := False;
          if not(AOrig is TOrder) then
          begin
            MarkFree(AOrig);
          end else begin
            for AOrder in AOrderList do
            begin
              if AOrder.ID = TOrder(AOrig).ID then
              begin
                // Update an order found in AOrderList
                Found := True;
                AOrder.Assign(TOrder(AOrig)); // RDD: Need to check Assign!!!!
                ADestList.Add(AOrder);
                try
                  AOrderList.Remove(AOrder);
                except
                  ADestList.Delete(ADestList.Count - 1);
                  raise;
                end;
                MarkFree(AOrig);
                Break;
              end;
            end;
            if not Found then
            begin
              // Add an order not found in AOrderList
              ADestList.Add(AOrig);
            end;
          end
        end;
      except
        for AOrder in AOrderList do
          ADestList.Add(AOrder); // add unprocessed orders back to ADestList
        raise;
      end;
      AOrderList.OwnsObjects := True; // Won't get called if error is raised
    finally
      FreeAndNil(AFreeList); // This frees all the items in it
    end;
  finally
    FreeAndNil(AOrderList);
  end;
end;

procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; APtEvtID: string);
// Filter, Specialty, Groups: Integer; var TextView: Integer;
// var CtxtTime: TFMDateTime);
var
  FMD: TFMDateTime;
  sl: TStrings;
  FilterTS: string;
  AlertedUserOnly: Boolean;
  AOrderList: TList;
begin
  if uDGroupMap = nil then
    LoadDGroupMap; // to make sure broker not called while looping thru Results
  FilterTS := IntToStr(AView.Filter) + U + IntToStr(AView.EventDelay.Specialty);
  AlertedUserOnly := (Notifications.Active and (AView.Filter = 12));

  sl := TStringList.Create;
  try
    if not CallVistA('ORWORR AGET', [Patient.DFN, FilterTS, AView.DGroup,
      AView.TimeFrom, AView.TimeThru, APtEvtID, AlertedUserOnly], sl) then
      ; // add error processing here // sl.Clear;
    if (sl.Count <= 0) then
    begin
      ClearOrders(Dest);
    end else begin
      if ((Piece(sl[0], U, 1) = '0') or (Piece(sl[0], U, 1) = '')) and
        (AView.Filter = 5) then
      begin // if no expiring orders found display expired orders)
        sl.Clear;
        FMD := ExpiredOrdersStartDT;
        if FMD < 0 then
          ShowMessage
            ('ERROR searching for FM date/time to begin search for expired orders')
        else if not CallVistA('ORWORR AGET', [Patient.DFN, '27^0', AView.DGroup,
          FMD, FMNow, APtEvtID], sl) then
          sl.Clear;
        AView.ViewName := 'Recently Expired Orders (No Expiring Orders Found) -'
          + Piece(AView.ViewName, '-', 2);
      end;

      AOrderList := TList.Create;
      try
        ConvertOrders(AOrderList, AView, sl);
        RefreshOrders(AOrderList, Dest);
      finally
        FreeAndNil(AOrderList);
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure LoadOrdersAbbr(Dest: TList; AView: TOrderView; APtEvtID: string;
  AlertID: string);
var
  sl: TStrings;
  AOrderList: TList;
begin
  if uDGroupMap = nil then
    LoadDGroupMap; // to make sure broker not called while looping thru Results
  sl := TStringList.Create;
  try
    if not CallVistA('ORB FOLLOW-UP ARRAY', [AlertID], sl) then;
    // add error processing here // sl.Clear;
    AOrderList := TList.Create;
    try
      ConvertOrders(AOrderList, AView, sl);
      RefreshOrders(AOrderList, Dest);
    finally
      FreeAndNil(AOrderList);
    end;
  finally
    sl.Free;
  end;
end;

procedure LoadOrdersAbbr(DestDC, DestRL: TList; AView: TOrderView;
  APtEvtID: string);
var
  i: Integer;
  AnOrder: TOrder;
  FilterTS: string;
  DCStart: Boolean;
  sl: TStringList;
  AOrderListDC, AOrderListRL: TList;
begin
  DCStart := False;
  if uDGroupMap = nil then
    LoadDGroupMap;
  FilterTS := IntToStr(AView.Filter) + U + IntToStr(AView.EventDelay.Specialty);

  sl := TStringList.Create;
  try
    if not CallVistA('ORWORR RGET', [Patient.DFN, FilterTS, AView.DGroup,
      AView.TimeFrom, AView.TimeThru, APtEvtID], sl) then;
    // add error processing here //sl.Clear;

    AOrderListDC := nil;
    AOrderListRL := nil;
    try
      AOrderListDC := TList.Create;
      AOrderListRL := TList.Create;

      if (sl.Count < 1) or (sl[0] = '0') then // if no orders found (0 element is count)
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
        AOrderListDC.Add(AnOrder);
      end
      else
      begin
        AView.TextView := StrToIntDef(Piece(sl[0], U, 2), 0);
        AView.CtxtTime := MakeFMDateTime(Piece(sl[0], U, 3));
        for i := 1 to sl.Count - 1 do // if orders found (skip 0 element)
        begin
          if AnsiCompareText('DC START', sl[i]) = 0 then
          begin
            DCStart := True;
            Continue;
          end;
          AnOrder := TOrder.Create;
          with AnOrder do
          begin
            ID := Piece(sl[i], U, 1);
            DGroup := StrToIntDef(Piece(sl[i], U, 2), 0);
            OrderTime := MakeFMDateTime(Piece(sl[i], U, 3));
            EventPtr := Piece(sl[i], U, 4);
            EventName := Piece(sl[i], U, 5);
            DGroupSeq := SeqOfDGroup(DGroup);
          end;
          if DCStart then
            AOrderListDC.Add(AnOrder)
          else
            AOrderListRL.Add(AnOrder);
        end;
      end;
      RefreshOrders(AOrderListDC, DestDC);
      RefreshOrders(AOrderListRL, DestRL);
    finally
      FreeAndNil(AOrderListRL);
      FreeAndNil(AOrderListDC);
    end;
  finally
    sl.Free;
  end;
end;

procedure LoadOrderSheets(Dest: TStrings);
begin
  if CallVistA('ORWOR SHEETS', [Patient.DFN],Dest) then
    MixedCaseByPiece(Dest, U, 2)
  else
  ; // add error processing if needed //  Dest.Clear;
end;

procedure LoadOrderSheetsED(Dest: TStrings);
var
  i: Integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('OREVNTX PAT', [Patient.DFN], sl) then
      ; // add error processing if needed // sl.Clear;
    MixedCaseByPiece(sl, U, 2);
    Dest.Add('C;O^Current View');
    if sl.Count > 1 then
    begin
      sl.Delete(0);
      for i := 0 to sl.Count - 1 do
        sl[i] := sl[i] + ' Orders';
      Dest.AddStrings(sl);
    end;
  finally
    sl.Free;
  end;
end;

procedure LoadOrderViewDefault(AView: TOrderView);
var
  x: string;
begin
  if not CallVistA('ORWOR VWGET', [nil],x) then
    x := '';
  with AView do
  begin
    Changed := False;
    DGroup := StrToIntDef(Piece(x, ';', 4), 0);
    Filter := StrToIntDef(Piece(x, ';', 3), 0);
    InvChrono := Piece(x, ';', 6) = 'R';
    ByService := Piece(x, ';', 7) = '1';
    TimeFrom := StrToFloat(Piece(x, ';', 1));
    TimeThru := StrToFloat(Piece(x, ';', 2));
    CtxtTime := 0;
    TextView := 0;
    ViewName := Piece(x, ';', 8);
    EventDelay.EventType := 'C';
    EventDelay.Specialty := 0;
    EventDelay.Effective := 0;
  end;
end;

procedure LoadUnsignedOrders(IDList, HaveList: TStrings);
var
  i: Integer;
  aList: iORNetMult;
begin
  newOrNetMult(aList);
  aList.AddSubscript(['0'],''); // (to prevent broker from hanging if empty list)
    for i := 0 to Pred(HaveList.Count) do
      aList.AddSubscript([HaveList[i]], '');
  CallVistA('ORWOR UNSIGN',[Patient.DFN,aList], IDList);
end;

procedure LoadFlagReasons(AOrderList: TList);

  function FindOrder(const AOrderID: string): TOrder;
  var
    P: Pointer;
  begin
    for P in AOrderList do begin
      if Piece(TOrder(P).ID, ';', 1) = AOrderID then begin
        Result := TOrder(P);
        Exit;
      end;
    end;
    Result := nil;
  end;

  procedure AddFlagTextToOrder(S: string);
  var
    AOrder: TOrder;
  begin
    if S <> '' then
    begin
      if Copy(S, 1, 1) = '~' then S := Copy(S, 2, Length(S));
      AOrder := FindOrder(Piece(S, U, 1));
      if Assigned(AOrder) then begin
        AOrder.IsFlagTextLoaded := True;
        AOrder.FlagText := Piece(S, U, 2);
      end;
    end;
  end;

var
  I: Integer;
  S, AResult: string;
  AOrder: TOrder;
  AIDList, AResults: TStringList;
begin
  AResults := TStringList.Create;
  try
    AIDList := TStringList.Create;
    try
      for I := 0 to AOrderList.Count - 1 do
      begin
        AOrder := TOrder(AOrderList.Items[I]);
        if AOrder.Flagged and (not AOrder.IsFlagTextLoaded) then //
          AIDList.Add(AOrder.ID);
      end;
      CallVistA('ORWDXA1 FLAGTXTS', [AIDList], AResults);
    finally
      FreeAndNil(AIDList);
    end;

    AResult := '';
    for S in AResults do begin
      if Copy(S, 1, 1) = '~' then begin
        // Reached a new record. We need to process the pevious record
        AddFlagTextToOrder(AResult);
        AResult := '';
      end;
      if AResult = '' then begin
        AResult := S
      end else begin
        AResult := Format('%s'#13#10'%s', [AResult, S]);
      end;
    end;
    AddFlagTextToOrder(AResult);
  finally
    FreeAndNil(AResults);
  end;
end;

procedure RetrieveOrderFields(OrderList: TList; ATextView: Integer;
  ACtxtTime: TFMDateTime);
var
  i, OrderIndex: Integer;
  x, y, z: string;
  AnOrder: TOrder;
  Results: TStrings;
  IDList: TStringList;
begin
  Results := TStringList.Create;
  try
    IDList := TStringList.Create;
    try
      with OrderList do
        for i := 0 to Count - 1 do
          IDList.Add(TOrder(Items[i]).ID);
      if not CallVistA('ORWORR GET4LST', [ATextView, ACtxtTime, IDList], Results) then
        Results.Clear;
    finally
      IDList.Free;
    end;
    OrderIndex := -1;
    while Results.Count > 0 do
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
      if CharAt(x, 1) <> '~' then
        Continue; // only happens if out of synch
      if Piece(x, U, 1) <> '~' + AnOrder.ID then
        Continue; // only happens if out of synch
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
    end;
    if Notifications.Active then LoadFlagReasons(OrderList);
  finally
    Results.Free;
  end;
end;

procedure SaveOrderViewDefault(AView: TOrderView);
var
  x: string;
begin
  with AView do
  begin
    x := MakeRelativeDateTime(TimeFrom) + ';' + // 1
      MakeRelativeDateTime(TimeThru) + ';' + // 2
      IntToStr(Filter) + ';' + // 3
      IntToStr(DGroup) + ';;'; // 4, skip 5
    if InvChrono then
      x := x + 'R;'
    else
      x := x + 'F;'; // 6
    if ByService then
      x := x + '1'
    else
      x := x + '0'; // 7
    CallVistA('ORWOR VWSET', [x]);
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
  if ((Piece(Order1.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order1.ID)))
    and (StrToIntDef(Order1.EventPtr, 0) = 0) then
    DSeq1 := 0
  else
    DSeq1 := Order1.DGroupSeq;
  if ((Piece(Order2.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order2.ID)))
    and (StrToIntDef(Order1.EventPtr, 0) = 0) then
    DSeq2 := 0
  else
    DSeq2 := Order2.DGroupSeq;
  if DSeq1 = DSeq2 then
  begin
    if Order1.OrderTime > Order2.OrderTime then
      Result := -1
    else if Order1.OrderTime < Order2.OrderTime then
      Result := 1
    else
      Result := 0;
    if Result = 0 then
    begin
      IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
      IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
      if IFN1 < IFN2 then
        Result := -1;
      if IFN1 > IFN2 then
        Result := 1;
    end;
  end
  else if DSeq1 < DSeq2 then
    Result := -1
  else
    Result := 1;
end;

function ForwardByGroup(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  DSeq1, DSeq2, IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if (Piece(Order1.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order1.ID))
  then
    DSeq1 := 0
  else
    DSeq1 := Order1.DGroupSeq;
  if (Piece(Order2.ID, ';', 2) = '1') and (Changes.Exist(CH_ORD, Order2.ID))
  then
    DSeq2 := 0
  else
    DSeq2 := Order2.DGroupSeq;
  if DSeq1 = DSeq2 then
  begin
    if Order1.OrderTime < Order2.OrderTime then
      Result := -1
    else if Order1.OrderTime > Order2.OrderTime then
      Result := 1
    else
      Result := 0;
    if Result = 0 then
    begin
      IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
      IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
      if IFN1 < IFN2 then
        Result := -1;
      if IFN1 > IFN2 then
        Result := 1;
    end;
  end
  else if DSeq1 < DSeq2 then
    Result := -1
  else
    Result := 1;
end;

function InverseChrono(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if Order1.OrderTime > Order2.OrderTime then
    Result := -1
  else if Order1.OrderTime < Order2.OrderTime then
    Result := 1
  else
    Result := 0;
  if Result = 0 then
  begin
    IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
    IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
    if IFN1 < IFN2 then
      Result := -1;
    if IFN1 > IFN2 then
      Result := 1;
  end;
end;

function ForwardChrono(Item1, Item2: Pointer): Integer;
var
  Order1, Order2: TOrder;
  IFN1, IFN2: Integer;
begin
  Order1 := TOrder(Item1);
  Order2 := TOrder(Item2);
  if Order1.OrderTime < Order2.OrderTime then
    Result := -1
  else if Order1.OrderTime > Order2.OrderTime then
    Result := 1
  else
    Result := 0;
  if Result = 0 then
  begin
    IFN1 := StrToIntDef(Piece(Order1.ID, ';', 1), 0);
    IFN2 := StrToIntDef(Piece(Order2.ID, ';', 1), 0);
    if IFN1 < IFN2 then
      Result := -1;
    if IFN1 > IFN2 then
      Result := 1;
  end;
end;

procedure SortOrders(AList: TList; ByGroup, InvChron: Boolean);
begin
  if ByGroup then
  begin
    if InvChron then
      AList.Sort(InverseByGroup)
    else
      AList.Sort(ForwardByGroup);
  end
  else
  begin
    if InvChron then
      AList.Sort(InverseChrono)
    else
      AList.Sort(ForwardChrono);
  end;
end;

function DGroupAll: Integer;
var
  x: string;
begin
  if uDGroupAll = 0 then
  begin
    if not CallVistA('ORWORDG IEN', ['ALL'],x) then
      x := '';
    uDGroupAll := StrToIntDef(x, 1);
  end;
  Result := uDGroupAll;
end;

function DGroupIEN(AName: string): Integer;
begin
  if not CallVistA('ORWORDG IEN', [AName],Result) then
    Result := 0;
end;

procedure ListDGroupAll(Dest: TStrings);
begin
  CallVistA('ORWORDG ALLTREE', [nil],Dest);
end;

procedure ListSpecialties(Dest: TStrings);
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('ORWOR TSALL', [nil], sl) then
      sl.Clear;
    MixedCaseList(sl);
    FastAssign(sl, Dest);
  finally
    sl.Free;
  end;
end;

procedure ListSpecialtiesED(AType: Char; Dest: TStrings);
var
  i: Integer;
  Currloc: Integer;
  admitEvts: TStringList;
  otherEvts: TStringList;
  commonList: TStringList;
  IsObservation: Boolean;
  Results: TSTrings;
  sParam:String;
begin
  if Encounter <> nil then
    Currloc := Encounter.Location
  else
    Currloc := 0;
  IsObservation := (Piece(GetCurrentSpec(Patient.DFN), U, 3) = '1');
  commonList := TStringList.Create;
  Results := TStringList.Create;
  if not CallVistA('OREVNTX1 CMEVTS', [Currloc],Results) then
    Results.Clear;

  if Results.Count > 0 then
    for i := 0 to Results.Count - 1 do
    begin
      if AType = 'D' then
      begin
        if AType = Piece(Results[i], '^', 3) then
          commonList.Add(Results[i]);
      end
      else if AType = 'A' then
      begin
        if (Piece(Results[i], '^', 3) = 'T') or
          (Piece(Results[i], '^', 3) = 'D') then
          Continue;
        commonList.Add(Results[i]);
      end
      else if IsObservation then
      begin
        if (Piece(Results[i], '^', 3) = 'T') then
          Continue;
        commonList.Add(Results[i]);
      end
      else
      begin
        if Length(Results[i]) > 0 then
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
    otherEvts := TStringList.Create;
    if not CallVistA('OREVNTX ACTIVE', ['A'],Results) then
      Results.Clear;
    // MixedCaseList(RPCBrokerV.Results);
    if Results.Count > 0 then
    begin
      Results.Delete(0);
      admitEvts.AddStrings(Results);
    end;
    sParam := 'O^M^D';
    if not IsObservation then
      sParam := 'T^' + sParam;
    if not CallVistA('OREVNTX ACTIVE', [sParam], Results) then
      Results.Clear;
    // MixedCaseList(RPCBrokerV.Results);
    if Results.Count > 0 then
    begin
      Results.Delete(0);
      otherEvts.AddStrings(Results);
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
    Results.Clear;
      if not CallVistA('OREVNTX ACTIVE', ['A^O^M'],Results) then
        Results.Clear;
    // MixedCaseList(RPCBrokerV.Results);
    if Results.Count > 0 then
      Results.Delete(0);
    Dest.AddStrings(Results);
  end
  else
  begin
    Results.Clear;
      if not CallVistA('OREVNTX ACTIVE', [AType],Results) then
        Results.Clear;
    // MixedCaseList(RPCBrokerV.Results);
    if Results.Count > 0 then
      Results.Delete(0);
    Dest.AddStrings(Results);
  end;
  Results.Free;
end;

procedure ListOrderFilters(Dest: TStrings);
begin
  CallVistA('ORWORDG REVSTS', [nil], Dest);
end;

procedure ListOrderFiltersAll(Dest: TStrings);
begin
  CallVistA('ORWORDG REVSTS', [nil], Dest);
end;

{ Write Orders }

procedure BuildResponses(var ResolvedDialog: TOrderDialogResolved;
  const KeyVars: string; AnEvent: TOrderDelayEvent; ForIMO: Boolean);
const
  BoolChars: array [Boolean] of Char = ('0', '1');
  RESERVED_PIECE = '';
var
  DelayEvent, x, TheOrder: string;
  Idx, tmpOrderGroup, PickupIdx, ForIMOResponses: Integer;
  IfUDGrp: Boolean;
  IfUDGrpForQO: Boolean;
  temp: string;
  Results: TStringList;
begin
  ForIMOResponses := 0;
  tmpOrderGroup := 0;
  temp := '';
  if ForIMO then
    ForIMOResponses := 1;
  PickupIdx := 0;
  IfUDGrp := False;
  TheOrder := ResolvedDialog.InputID;
  IfUDGrpForQO := CheckQOGroup(TheOrder);
  if CharInSet(CharAt(TheOrder, 1), ['C', 'T']) then
  begin
    Delete(TheOrder, 1, 1);
    tmpOrderGroup := CheckOrderGroup(TheOrder);
    if tmpOrderGroup = 1 then
      IfUDGrp := True
    else
      IfUDGrp := False;
  end;
  if (not IfUDGrp) and CharInSet(AnEvent.EventType, ['A', 'T']) then
    IfUDGrp := True;
  // FLDS=DFN^LOC^ORNP^INPT^SEX^AGE^EVENT^SC%^^^Key Variables
  if (Patient.Inpatient = True) and (tmpOrderGroup = 2) then
    temp := '0';
  if temp <> '0' then
    temp := BoolChars[Patient.Inpatient];
  with AnEvent do
  begin
    if IsNewEvent then
      DelayEvent := '0;' + SafeEventType(EventType) + ';' + IntToStr(Specialty) + ';' +
        FloatToStr(Effective)
    else
      DelayEvent := IntToStr(AnEvent.PtEventIFN) + ';' + SafeEventType(EventType) + ';' +
        IntToStr(Specialty) + ';' + FloatToStr(Effective);
  end;
  x := Patient.DFN + U + // 1
    IntToStr(Encounter.Location) + U + // 2
    IntToStr(Encounter.Provider) + U + // 3
    BoolChars[Patient.Inpatient] + U + // 4
    Patient.Sex + U + // 5
    IntToStr(Patient.Age) + U + // 6
    DelayEvent + U + // 7 (for OREVENT)
    IntToStr(Patient.SCPercent) + U + // 8
    RESERVED_PIECE + U + // 9
    RESERVED_PIECE + U + // 10
    KeyVars;

  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXM1 BLDQRSP', [ResolvedDialog.InputID, x,
      ForIMOResponses, Encounter.Location], Results) then
      Results.Clear;

    // LST(0)=QuickLevel^ResponseID(ORIT;$H)^Dialog^Type^FormID^DGrp
    if Results.Count > 0 then
      x := Results[0]
    else
      x := '';
    with ResolvedDialog do
    begin
      QuickLevel := StrToIntDef(Piece(x, U, 1), 0);
      ResponseID := Piece(x, U, 2);
      DialogIEN := StrToIntDef(Piece(x, U, 3), 0);
      DialogType := CharAt(Piece(x, U, 4), 1);
      FormID := StrToIntDef(Piece(x, U, 5), 0);
      DisplayGroup := StrToIntDef(Piece(x, U, 6), 0);
      QOKeyVars := Pieces(x, U, 7, 7 + MAX_KEYVARS);
      if Results.Count > 0 then
        Results.Delete(0);
      if Results.Count > 0 then
      begin
        if (IfUDGrp) or (IfUDGrpForQO) then
        begin
          for Idx := 0 to Results.Count - 1 do
          begin
            if (pos('PICK UP', UpperCase(Results[Idx])) > 0) or
              (pos('PICK-UP', UpperCase(Results[Idx])) > 0) then
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

  finally
    Results.Free;
  end;
end;

procedure ClearOrderRecall;
begin
  CallVistA('ORWDXM2 CLRRCL', [nil]);
end;

function CommonLocationForOrders(OrderList: TStringList): Integer;
begin
  if not CallVistA('ORWD1 COMLOC', [OrderList], Result) then
    Result := 0;
end;

function FormIDForDialog(IEN: Integer): Integer;
begin
  if not CallVistA('ORWDXM FORMID', [IEN], Result) then
    Result := 0;
end;

function DlgIENForName(DlgName: string): Integer;
begin
  if not CallVistA('OREVNTX1 DLGIEN', [DlgName], Result) then
    Result := 0;
end;

procedure LoadOrderMenu(AnOrderMenu: TOrderMenu; AMenuIEN: Integer);
var
  OrderMenuItem: TOrderMenuItem;
  i: Integer;
  OrderTitle: String;
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXM MENU', [AMenuIEN], Results) then
      Results.Clear;
  if Results.Count > 0 then
  begin
    // Results[0] = Name^Cols^PathSwitch^^^LRFZX^LRFSAMP^LRFSPEC^LRFDATE^LRFURG^LRFSCH^PSJNPOC^
    // GMRCNOPD^GMRCNOAT^GMRCREAF^^^^^
    OrderTitle := Piece(Results[0], U, 1);
    if (pos('&', OrderTitle) > 0) and
      (Copy(OrderTitle, pos('&', OrderTitle) + 1, 1) <> '&') then
      OrderTitle := Copy(OrderTitle, 1, pos('&', OrderTitle)) + '&' +
        Copy(OrderTitle, pos('&', OrderTitle) + 1, Length(OrderTitle));

    AnOrderMenu.Title := OrderTitle;
    AnOrderMenu.NumCols := StrToIntDef(Piece(Results[0], U, 2), 1);
    AnOrderMenu.KeyVars := Pieces(Results[0], U, 6, 6 + MAX_KEYVARS);
    for i := 1 to Results.Count - 1 do
    begin
      OrderMenuItem := TOrderMenuItem.Create;
      with OrderMenuItem do
      begin
        Col := StrToIntDef(Piece(Results[i], U, 1), 0) - 1;
        Row := StrToIntDef(Piece(Results[i], U, 2), 0) - 1;
        DlgType := CharAt(Piece(Results[i], U, 3), 1);
        IEN := StrToIntDef(Piece(Results[i], U, 4), 0);
        FormID := StrToIntDef(Piece(Results[i], U, 5), 0);
        AutoAck := Piece(Results[i], U, 6) = '1';
        ItemText := Piece(Results[i], U, 7);
        Mnemonic := Piece(Results[i], U, 8);
        Display := StrToIntDef(Piece(Results[i], U, 9), 0);
      end; { with OrderItem }
      AnOrderMenu.MenuItems.Add(OrderMenuItem);
    end; { for i }
  end;
  finally
    Results.Free;
  end;
end;

procedure LoadOrderSet(SetItems: TStrings; AnIEN: Integer;
  var KeyVars, ACaption: string);
var
  x: string;
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXM LOADSET', [AnIEN], Results) then
      Results.Clear;

    KeyVars := '';
    ACaption := '';
    if Results.Count > 0 then
    begin
      x := Results[0];
      ACaption := Piece(x, U, 1);
      KeyVars := Copy(x, pos(U, x) + 1, Length(x));
      Results.Delete(0);
    end;
    FastAssign(Results, SetItems);
  finally
    Results.Free;
  end;
end;

procedure LoadWriteOrders(Dest: TStrings);
begin
  if User.NoOrdering then
  begin
    Dest.Clear;
    exit;
  end;
  CallVistA('ORWDX WRLST', [Encounter.Location], Dest);
end;

procedure LoadWriteOrdersED(Dest: TStrings; EvtID: string);
var
  Results: TStrings;
begin
  if User.NoOrdering then
  begin
    Dest.Clear;
    exit;
  end;
  Results := TStringList.Create;
  try
    if not CallVistA('OREVNTX1 WRLSTED', [Encounter.Location, EvtID], Results)
    then
      Results.Clear;

    if Results.Count > 0 then
    begin
      Dest.Clear;
      FastAssign(Results, Dest);
    end;
  finally
    Results.Free;
  end;
end;

function OrderDisabledMessage(DlgIEN: Integer): string;
begin
  if not CallVistA('ORWDX DISMSG', [DlgIEN], Result) then
    Result := '';
end;

procedure SendOrders(OrderList: TStringList; const ESCode: string);
var
  i: Integer;
  Results: TStrings;
begin
  { prepending the space to ESCode is temporary way to keep broker from crashing }
  Results := TStringList.Create;

  try
    if not CallVistA('ORWDX SEND', [Patient.DFN, Encounter.Provider,
      Encounter.Location, ' ' + ESCode, OrderList], Results) then
      Results.Clear;

    { this is a stop gap way to prevent an undesired error message when user chooses not to sign }
    for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 4) = 'This order requires a signature.' then
        Results[i] := Piece(Results[i], U, 1);
    OrderList.Clear;
    FastAssign(Results, OrderList);

  finally
    Results.Free;
  end;
end;

procedure SendReleaseOrders(OrderList: TStringList);
var
  loc: string;
  CurrTS: Integer;
  PtTS: string;
  Results: TStrings;
begin
  PtTS := Piece(GetCurrentSpec(Patient.DFN), '^', 2);
  CurrTS := StrToIntDef(PtTS, 0);
  loc := IntToStr(Encounter.Location);
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDX SENDED', [OrderList, CurrTS, loc], Results) then
      Results.Clear;
    OrderList.Clear;
    FastAssign(Results, OrderList);
  finally
    Results.Free;
  end;
end;

procedure SendAndPrintOrders(OrderList, ErrList: TStrings; const ESCode: string;
  const DeviceInfo: string);
var
  i: Integer;
  Results: TStrings;
begin
  { prepending the space to ESCode is temporary way to keep broker from crashing }
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDX SENDP', [Patient.DFN, Encounter.Provider,
      Encounter.Location, ' ' + ESCode, DeviceInfo, OrderList], Results) then
      Results.Clear;
    { this is a stop gap way to prevent an undesired error message when user chooses not to sign }
    for i := 0 to Results.Count - 1 do
      if Piece(Results[i], U, 3) <> 'This order requires a signature.' then
        ErrList.Add(Results[i]);
  finally
    Results.Free;
  end;
end;

procedure PrintOrdersOnReview(OrderList: TStringList; const DeviceInfo: string;
  PrintLoc: Integer = 0);
var
  loc: Integer;
begin
  if (PrintLoc > 0) and (PrintLoc <> Encounter.Location) then
    loc := PrintLoc
  else
    loc := Encounter.Location;
  CallVistA('ORWD1 RVPRINT', [loc, DeviceInfo, OrderList]);
end;

procedure PrintServiceCopies(OrderList: TStringList;
  PrintLoc: Integer = 0); { *REV* }
var
  loc: Integer;
begin
  if (PrintLoc > 0) and (PrintLoc <> Encounter.Location) then
    loc := PrintLoc
  else
    loc := Encounter.Location;
  CallVistA('ORWD1 SVONLY', [loc, OrderList]);
end;

procedure ExecutePrintOrders(SelectedList: TStringList;
  const DeviceInfo: string);
begin
  CallVistA('ORWD1 PRINTGUI', [Encounter.Location, DeviceInfo, SelectedList]);
end;

{ Order Actions }

function DialogForOrder(const ID: string): Integer;
begin
  if not CallVistA('ORWDX DLGID', [ID], Result) then;
    Result := 0;
end;

function FormIDForOrder(const ID: string): Integer;
begin
  if not CallVistA('ORWDX FORMID', [ID], Result) then;
    Result := 0;
end;
{
procedure SetOrderFromResults(AnOrder: TOrder);
begin
  SetOrderFromResults(AnOrder, RPCBrokerV.Results);
end;
}
procedure SetOrderFromResults(AnOrder: TOrder; Results: TStrings);
var
  x, y, z: string;
begin
  while Results.Count > 0 do
  begin
    x := Results[0];
    Results.Delete(0);
    if CharAt(x, 1) <> '~' then
      Continue; // only happens if out of synch
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
        z := z + Copy(Results[0], 2, Length(Results[0])); // PKI Change
        Results.Delete(0);
      end;
    end;
    SetOrderFields(AnOrder, x, y, z);
  end;
end;

procedure LockPatient(var ErrMsg: string);
begin
  if not CallVistA('ORWDX LOCK', [Patient.DFN], ErrMsg) then
    ErrMsg := '3^Error caling "ORWDX LOC"';
  if Piece(ErrMsg, U, 1) = '1' then
    ErrMsg := ''
  else
    ErrMsg := Piece(ErrMsg, U, 2);

  If Length(ErrMsg) = 0 then
    LockList.AddLock(Patient.DFN, '', ltPatient);
end;

procedure UnlockPatient;
begin
  CallVistA('ORWDX UNLOCK', [Patient.DFN]);
  LockList.DeleteLock(Patient.DFN, ltPatient);
end;

procedure LockOrder(OrderID: string; var ErrMsg: string; const AnAction: string = '');
begin
if not CallVistA('ORWDX LOCK ORDER', [OrderID], ErrMsg) then
      ErrMsg := '3^Error caling "ORWDX LOCK ORDER"';
  if Piece(ErrMsg, U, 1) = '1' then
    ErrMsg := ''
  else
    ErrMsg := Piece(ErrMsg, U, 2);

  If Length(ErrMsg) = 0 then
    LockList.AddLock(OrderID, AnAction, ltOrder);
end;

procedure UnlockOrder(OrderID: string);
begin
  CallVistA('ORWDX UNLOCK ORDER', [OrderID]);
  LockList.DeleteLock(OrderID, ltOrder);
end;

procedure UnlockAllOrders();
begin
  LockList.ClearLocksByType(ltOrder);
end;

procedure UnlockAllOrdersByAction(AnAction: string);
begin
  LockList.ClearLocksByAction(AnAction);
end;

procedure UnlockAllLocks();
begin
  LockList.ClearAllLocks;
end;

procedure UnlockAllPatientLocks();
begin
  LockList.ClearLocksByType(ltPatient);
end;

procedure WarningOrderAction(const ID, Action: string; var ErrMsg: string);
begin
  CallVistA('ORWDXR01 WARN', [ID, Action], ErrMsg);
end;

procedure ValidateOrderAction(const ID, Action: string; var ErrMsg: string);
var
  Item: Int64;
begin
  if Action = OA_SIGN then
    Item := User.DUZ
  else
    Item := Encounter.Provider;

  CallVistA('ORWDXA VALID', [ID, Action, Item], ErrMsg);
end;

procedure ValidateOrderActionNature(const ID, Action, Nature: string;
  var ErrMsg: string);
begin
  CallVistA('ORWDXA VALID', [ID, Action, Encounter.Provider, Nature], ErrMsg);
end;

procedure IsLatestAction(const ID: string; var ErrList: TStringList);
begin
  CallVistA('ORWOR ACTION TEXT', [ID], ErrList);
end;
{
procedure ChangeOrder(AnOrder: TOrder; ResponseList: TList);
begin
end;
}
procedure RenewOrder(AnOrder: TOrder; RenewFields: TOrderRenewFields;
  IsComplex: Integer; AnIMOOrderAppt: double; OCList: TStringList);
{ put RenewFields into tmplst[0]=BaseType^Start^Stop^Refills^Pickup, tmplst[n]=comments }
var
  tmplst: TStringList;
  i: Integer;
  aList: iORNetMult;
  sl: TStrings;
begin

  tmplst := TStringList.Create;

  { Begin Billing Aware }
  UBAGlobals.SourceOrderID := AnOrder.ID;
  { End Billing Aware }

  try
    with RenewFields do
    begin
      tmplst.SetText(PChar(Comments));
      tmplst.Insert(0, IntToStr(BaseType) + U + StartTime + U + StopTime + U +
        IntToStr(Refills) + U + Pickup + U + DaysSupply.ToString + U + Quantity);
    end;
    newORNetMult(aList);
    for i := 0 to tmplst.Count - 1 do
      aList.AddSubscript([IntToStr(i + 1)], tmplst[i]);
    aList.AddSubscript(['ORCHECK'], OCList.Count);
    for i := 0 to OCList.Count - 1 do
    begin
      aList.AddSubscript(['ORCHECK', Piece(OCList[i], U, 1),Piece(OCList[i], U, 3), i + 1],
                          Pieces(OCList[i], U, 2, 4));
    end;

    sl := TSTringList.Create;
    try
    CallVistA('ORWDXR RENEW',
      [AnOrder.ID, Patient.DFN, Encounter.Provider, Encounter.Location, aList, IsComplex,AnIMOOrderAppt], sl);
      SetOrderFromResults(AnOrder,sl);
    finally
      sl.Free;
    end;
    { Begin Billing Aware }
    UBAGlobals.TargetOrderID := AnOrder.ID; // the ID of the renewed order
    UBAGlobals.CopyTreatmentFactorsDxsToRenewedOrder;
    { End Billing Aware }

  finally
    tmplst.Free;
  end;
end;

procedure HoldOrder(AnOrder: TOrder);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXA HOLD', [AnOrder.ID, Encounter.Provider], Results)
    then
      Results.Clear;

    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

procedure ReleaseOrderHold(AnOrder: TOrder);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXA UNHOLD', [AnOrder.ID, Encounter.Provider], Results)
    then
      Results.Clear;
    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

procedure ListDCReasons(Dest: TStrings; var DefaultIEN: Integer);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDX2 DCREASON', [nil], Results) then
      Results.Clear;
    ExtractItems(Dest, { RPCBrokerV. } Results, 'DCReason');
  finally
    Results.Free;
  end;
  // AGP Change 26.15 for PSI-04-63
  // DefaultIEN := StrToIntDef(Piece(ExtractDefault(RPCBrokerV.Results, 'DCReason'), U, 1), 0);
end;

function GetREQReason: Integer;
begin
  if not CallVistA('ORWDXA DCREQIEN', [nil], Result) then
    Result := 0;
end;

procedure DCOrder(AnOrder: TOrder; AReason: Integer; NewOrder: Boolean;
  var DCType: Integer);
var
  AParentID, DCOrigOrder: string;
  Results: TStrings;
begin
  AParentID := AnOrder.ParentID;
  if AnOrder.DCOriginalOrder = True then
    DCOrigOrder := '1'
  else
    DCOrigOrder := '0';
  Results := TStringList.Create;
  try
    if not  CallVistA('ORWDXA DC', [AnOrder.ID, Encounter.Provider, Encounter.Location,
      AReason, DCOrigOrder, NewOrder],Results) then
        Results.Clear;
    UBACore.DeleteDCOrdersFromCopiedList(AnOrder.ID);
    if Results.Count > 0 then
      DCType := StrToIntDef(Piece({RPCBrokerV.}Results[0], U, 14), 0)
    else
      DCType := 0;
    SetOrderFromResults(AnOrder,Results);
    AnOrder.ParentID := AParentID;
  finally
    Results.Free;
  end;
end;

procedure AlertOrder(AnOrder: TOrder; AlertRecip: Int64);
begin
  CallVistA('ORWDXA ALERT', [AnOrder.ID, AlertRecip]);
  // don't worry about results
end;

// NSR #20110719 - adding Recipients list
function getFlagOrderResults(AnOrder: TOrder;
  const FlagReason, ExpireDate: String; AlertRecip: TStrings;
  Results: TStrings): Boolean;
begin
  Result := CallVistA('ORWDXA FLAG', [AnOrder.ID, FlagReason, '', ExpireDate,
    AlertRecip], Results);
  if not Result then
    Results.Clear;
end;

procedure LoadFlagReason(Dest: TStrings; const ID: string);
begin
  if not CallVistA('ORWDXA FLAGTXT', [ID], Dest) then
    Dest.Clear;
end;

function UnflagOrder(AnOrder: TOrder; const AComment: String;var ErrMsg:String):TStrings;
begin
  Result := TSTringList.Create;
  ErrMsg := '';
  if not CallVistA('ORWDXA UNFLAG', [AnOrder.ID, AComment],Result) then
    ErrMsg := 'Error unflagging Order :'+anOrder.ID;
end;

// getGlagComments NSR #20110719
procedure getFlagComponents(Dest: TStrings; const anID,aType: string);
begin
  CallVistA('ORWDXA1 FLAGACT', [anID,aType], Dest);
end;

// getGlagComments NSR #20110719
function setFlagComments(const anID: String;aComments,aRecipients: TStrings;Results:TStrings):Boolean;
var
  i: integer;
  aListComments: iORNetMult;
  aListRecipients: iORNetMult;
begin
  neworNetMult(aListComments);
  neworNetMult(aListRecipients);

  for i := 0 to aComments.Count - 1 do
    aListComments.AddSubscript(i+1,aComments[i]);
  for i := 0 to aRecipients.Count - 1 do
    aListRecipients.AddSubscript(i+1,Piece(aRecipients[i],U,1));

  Result := CallVistA('ORWDXA1 FLAGCOM', [anID,aListComments,aListRecipients],Results);
  if not Result then
    Results.Clear;

end;

procedure LoadWardComments(Dest: TStrings; const ID: string);
begin
  CallVistA('ORWDXA WCGET', [ID], Dest);
end;

procedure PutWardComments(Src: TStrings; const ID: string; var ErrMsg: string);
begin
  if not CallVistA('ORWDXA WCPUT', [ID, Src], ErrMsg) then
    ErrMsg := 'Error calling RPC "ORWDXA WCPUT"'
end;

procedure CompleteOrder(AnOrder: TOrder; const ESCode: string);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXA COMPLETE', [AnOrder.ID, ESCode], Results) then
      Results.Clear;
    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

procedure VerifyOrder(AnOrder: TOrder; const ESCode: string);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXA VERIFY', [AnOrder.ID, ESCode], Results) then
      Results.Clear;
    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

procedure VerifyOrderChartReview(AnOrder: TOrder; const ESCode: string);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXA VERIFY', [AnOrder.ID, ESCode, 'R'], Results) then
      Results.Clear;
    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

function GetOrderableIen(AnOrderId: string): Integer;
begin
  if not CallVistA('ORWDXR GTORITM', [AnOrderId], Result) then
    Result := 0;
end;

procedure StoreDigitalSig(AID, AHash: string; AProvider: Int64;
  ASig, ACrlUrl, DFN: string; var AError: string);
var
  len, ix: Integer;
  ASigAray: TStringList;
  Results: TStrings;
  errLine: string;
begin
  ASigAray := TStringList.Create;
  ix := 1;
  len := Length(ASig);
  while len >= ix do
  begin
    ASigAray.Add(Copy(ASig, ix, 240));
    Inc(ix, 240);
  end; // while
  Results := TStringList.Create;
  try
    if CallVistA('ORWOR1 SIG', [AID, AHash, len, '100', AProvider, ASigAray,
      ACrlUrl, DFN], Results) then
      if (Results.Count < 1) or (piece(Results[0],'^',1) = '-1') then
        begin
          if Results.Count > 0 then
            errLine := piece(Results[0],'^',2)
          else
            errLine := 'No data retrieved from ORWOR1 SIG';
          ShowMsg('Storage of Digital Signature FAILED: ' + errLine + CRLF + CRLF +
          'This error will prevent this order from being sent to the service for processing. Please cancel the order and try again.'
          + CRLF + CRLF +
          'If this problem persists, then there is a problem in the CPRS PKI interface, and it needs to be reported through the proper channels, to the developer Cary Malmrose.');
        AError := '1';
      end;
  finally
    ASigAray.Free;
    Results.Free;
  end;
end;

procedure UpdateOrderDGIfNeeded(AnID: string);
var
  NeedUpdate: Boolean;
  sNeedUpdate,
  tmpDFN: string;
begin
  tmpDFN := Patient.DFN;
  Patient.Clear;
  Patient.DFN := tmpDFN;
  NeedUpdate := CallVistA('ORWDPS4 IPOD4OP', [AnID],sNeedUpdate) and
    (sNeedUpdate = '1');

  if Patient.Inpatient and NeedUpdate then
    CallVistA('ORWDPS4 UPDTDG', [AnID]);
end;

function CanEditSuchRenewedOrder(AnID: string; IsTxtOrder: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDXR01 CANCHG', [AnID, IsTxtOrder],s) and (s = '1');
end;

function IsPSOSupplyDlg(DlgID: string; QODlg: Integer): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDXR01 ISSPLY', [DlgID, QODlg],s) and (s = '1');
end;

procedure SaveChangesOnRenewOrder(var AnOrder: TOrder;
  anID, TheRefills, ThePickup: string; IsTxtOrder: Integer;
  DaysSupply, Quantity: string);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXR01 SAVCHG', [anID, TheRefills, ThePickup,
      IsTxtOrder, DaysSupply, Quantity], Results) then
      Results.Clear;
    SetOrderFromResults(AnOrder, Results);
  finally
    Results.Free;
  end;
end;

function DoesOrderStatusMatch(OrderArray: TStringList): Boolean;
var
  i: Integer;
begin
  Result := CallVistA('ORWDX1 ORDMATCH', [Patient.DFN, OrderArray], i)
    and (i = 1);
end;

{ Order Information }

function OrderIsReleased(const ID: string): Boolean;
var
  i: Integer;
begin
  Result := CallVistA('ORWDXR ISREL', [ID], i) and (i = 1);
end;

procedure LoadRenewFields(RenewFields: TOrderRenewFields; const ID: string);
var
  i: Integer;
  x, x2: string;
  IsComment: boolean;
  Results: TStrings;
  data: string;

  procedure AddX(var txt: string);
  begin
    if (length(txt) > 0) then
      txt := txt + CRLF;
    txt := txt + x;
  end;

begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXR RNWFLDS', [ID], Results) then
      Results.Clear;
    with RenewFields do
    begin
      if Results.Count > 0 then
        data := Results[0]
      else
        data := '';
      BaseType  := StrToIntDef(Piece(data, U, 1), 0);
      StartTime := Piece(data, U, 2);
      StopTime  := Piece(data, U, 3);
      Refills   := StrToIntDef(Piece(data, U, 4), 0);
      Pickup    := Piece(data, U, 5);
      DaysSupply := StrToIntDef(Piece(data, U, 6), 0);
      Quantity := Piece(Results[0], U, 7);
      DispUnit := Piece(data, U, 8);
      Comments := '';
      NewText := '';
      TitrationMsg := '';
      for i := 1 to Results.Count - 1 do
      begin
        IsComment := True;
        x := Results[i];
        if ((Length(x) > 0) and (x[1] = '~')) then
        begin
          IsComment := False;
          if (Length(x) > 1) then
          begin
            x2 := x[2];
            x := Copy(x, 3, 999);
            if (x2 = 't') then
              AddX(NewText)
            else if (x2 = 'T') then
              AddX(TitrationMsg);
          end;
        end;
        if IsComment then
          AddX(Comments);
      end;
    end;
    finally
      Results.Free;
    end;
  end;

procedure GetChildrenOfComplexOrder(AnParentID, CurrAct: string;
  var ChildList: TStringList); // PSI-COMPLEX
var
  i: Integer;
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if not CallVistA('ORWDXR ORCPLX', [AnParentID, CurrAct], Results) then
      Results.Clear;
    if  Results.Count = 0 then
      Exit;

    for i := 0 to Results.Count - 1 do
    begin
      if (Piece(Results[i], '^', 1) <> 'E') and (Length(Results[i]) > 0) then
        ChildList.Add(Results[i]);
    end;
  finally
    Results.Free;
  end;
end;

procedure LESValidationForChangedLabOrder(var RejectedReason: TStringList;
  AnOrderInfo: string);
begin
  if not CallVistA('ORWDPS5 LESAPI', [AnOrderInfo],RejectedReason) then
    RejectedReason.Clear;
end;

procedure ChangeEvent(AnOrderList: TStringList; APtEvtID: string);
var
  sl: TStringList;
  i: integer;

begin
  sl := TStringList.Create;
  try
    for i := 0 to AnOrderList.Count - 1 do
      sl.Add(Piece(AnOrderList[i], U, 1));
    CallVistA('OREVNTX1 CHGEVT', [APtEvtID, sl]);
  finally
    sl.Free;
  end;
end;

procedure DeletePtEvent(APtEvtID: string);
begin
  CallVistA('OREVNTX1 DELPTEVT', [APtEvtID]);
end;

function IsRenewableComplexOrder(AnParentID: string): Boolean; // PSI-COMPLEX
var
  rst: Integer;
begin
  Result := CallVistA('ORWDXR CANRN', [AnParentID],rst) and (rst > 0);
end;

function IsComplexOrder(AnOrderId: string): Boolean; // PSI-COMPLEX
var
  rst: Integer;
begin
  Result := CallVistA('ORWDXR ISCPLX', [AnOrderId],rst) and (rst > 0);
end;

procedure ValidateComplexOrderAct(AnOrderId: string; var ErrMsg: string);
// PSI-COMPLEX
begin
  if not CallVistA('ORWDXA OFCPLX', [AnOrderId],ErrMsg) then
    ErrMsg := 'ERROR calling "ORWDXA OFCPLX"';
end;

function GetDlgData(ADlgID: string): string;
begin
  if not CallVistA('OREVNTX1 GETDLG', [ADlgID],Result) then
    Result := 'ERROR calling "OREVNTX1 GETDLG"';
end;

function PtEvtEmpty(APtEvtID: string): Boolean;
var
  i: Integer;
begin
  Result := CallVistA('OREVNTX1 EMPTY', [APtEvtID],i) and (i > 0);
end;

function TextForOrder(const ID: string): string;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if CallVistA('ORWORR GETTXT', [ID], sl) then
      Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function GetConsultOrderNumber(ConsultIEN: string): string;
begin
  if not CallVistA('ORQQCN GET ORDER NUMBER', [ConsultIEN],Result) then
    Result := '';
end;

function GetOrderByIFN(const ID: string): TOrder;
var
  x, y, z: string;
  AnOrder: TOrder;
  Results: TStrings;
begin
  AnOrder := TOrder.Create;
  Results := TStringList.Create;
  try
    if CallVistA('ORWORR GETBYIFN', [ID], Results) then
      while Results.Count > 0 do
      begin
        x := Results[0];
        Results.Delete(0);
        if CharAt(x, 1) <> '~' then
          Continue; // only happens if out of synch
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
            z := z + Copy(Results[0], 2, Length(Results[0])); // PKI Change
            Results.Delete(0);
          end;
        end;
        SetOrderFields(AnOrder, x, y, z);
      end;
  finally
    Results.Free;
  end;
  Result := AnOrder;
end;

function GetPackageByOrderID(const OrderID: string): string;
begin
  if not CallVistA('ORWDXR GETPKG', [OrderID],Result) then
    Result := '';
end;

function AnyOrdersRequireSignature(OrderList: TStringList): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWD1 SIG4ANY', [OrderList],s) and (s = '1');
end;

function OrderRequiresSignature(const ID: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWD1 SIG4ONE', [ID],s) and (s = '1');
end;

function OrderRequiresDigitalSignature(const ID: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWOR1 CHKDIG', [ID],s) and (s = '1');
end;

function GetDrugSchedule(const ID: string;Default:String = ''): string;
begin
  if not CallVistA('ORWOR1 GETDSCH', [ID],Result) then
    Result := Default;
end;
{
function GetExternalText(const ID: string; Default: String = ''): string;
var
  x, y: string;
  sl: TStrings;
begin
  // CallV('ORWOR1 GETDTEXT', [ID]);
  sl := TStringList.Create;
  try
    if not CallVistA('ORWOR1 GETDTEXT', [ID], sl) then
      Result := Default
    else
    begin
      y := '';
      while sl.Count > 0 do
      begin
        x := sl[0];
        sl.Delete(0);
        y := y + x;
      end;
      Result := y;
    end;
  finally
    sl.Free;
  end;
end;

function SetExternalText(const ID: string; ADrugSch: string;
  AUser: Int64): string;
var
  x, y: string;
begin
  CallV('ORWOR1 SETDTEXT', [ID, ADrugSch, AUser]);
  y := '';
  with RPCBrokerV do
    while Results.Count > 0 do
    begin
      x := Results[0];
      Results.Delete(0);
      y := y + x;
    end;
  Result := y;
end;
}

function GetDigitalSignature(const ID: string): string;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('ORWORR GETDSIG', [ID], sl) then
      Result := ''
    else
      Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function GetDEA(const ID: string): string;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if not CallVistA('ORWORR GETDEA', [ID], sl) then
      Result := ''
    else
      Result := sl.Text;
  finally
    sl.Free;
  end;
end;

function GetPKISite: Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWOR PKISITE', [nil],s) and (s = '1');
end;

function GetPKIUse: Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWOR PKIUSE', [nil],s) and (s = '1');
end;

function DoesOIPIInSigForQO(AnQOID: Integer): Integer;
begin
  if not CallVistA('ORWDPS1 HASOIPI', [AnQOID],Result) then
    Result := 0;
end;

function GetDispGroupForLES: string;
begin
  if not CallVistA('ORWDPS5 LESGRP', [nil],Result) then
    Result := '';
end;

function GetOrderPtEvtID(AnOrderId: string): string;
begin
  if not CallVistA('OREVNTX1 ODPTEVID', [AnOrderId],Result) then
    Result := '';
end;

function VerbTelPolicyOrder(AnOrderId: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS5 ISVTP', [AnOrderId],s) and (s = '1');
end;

function ForIVandUD(AnOrderId: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS4 ISUDIV', [AnOrderId],s) and (s = '1');
end;

function GetEventIFN(const AEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 EVT', [AEvntID], Result) then
    Result := '';
end;

function GetEventName(const AEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 NAME', [AEvntID],Result) then
    Result := '';
end;

function GetEventLoc(const APtEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 LOC', [APtEvntID],Result)
    then Result := '';
end;

function GetEventLoc1(const AnEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 LOC1', [AnEvntID],Result)
    then Result := '';
end;

function GetEventDiv(const APtEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 DIV', [APtEvntID],Result) then
    Result := '';
end;

function GetEventDiv1(const AnEvntID: string): string;
begin
  if not CallVistA('OREVNTX1 DIV1', [AnEvntID],Result) then
    Result := '';
end;

function GetCurrentSpec(const APtIFN: string): string;
begin
  if not CallVistA('OREVNTX1 CURSPE', [APtIFN],Result) then
    Result := '';
end;

function GetDefaultEvt(const AProviderIFN: string): string;
begin
  if not CallVistA('OREVNTX1 DFLTEVT', [AProviderIFN], Result) then
    Result := '';
end;

procedure DeleteDefaultEvt;
begin
  CallVistA('OREVNTX1 DELDFLT', [User.DUZ]);
end;

function isExistedEvent(const APtDFN: string; const AEvtId: string;
  var APtEvtID: string): Boolean;
begin
  Result := False;
  if CallVistA('OREVNTX1 EXISTS', [APtDFN, AEvtId],APtEvtID) then
    Result := StrToIntDef(APtEvtID, 0) > 0;
end;

function TypeOfExistedEvent(APtDFN: string; AEvtId: Integer): Integer;
begin
  if not CallVistA('OREVNTX1 TYPEXT', [APtDFN, AEvtId],Result) then
    Result := 0;
end;

function isMatchedEvent(const APtDFN: string; const AEvtId: string;
  var ATs: string): Boolean;
var
  rst: string;
begin
  Result := False;
  if CallVistA('OREVNTX1 MATCH', [APtDFN, AEvtId], rst) then
    if StrToIntDef(Piece(rst, '^', 1), 0) > 0 then
    begin
      ATs := Piece(rst, '^', 2);
      Result := True;
    end;
end;

function isDCedOrder(const AnOrderId: string): Boolean;
var
  rst: integer;
begin
  Result := CallVistA('OREVNTX1 ISDCOD', [AnOrderId],rst) and
    (rst > 0);
end;

function isOnholdMedOrder(AnOrderId: string): Boolean;
var
  rst: integer;
begin
  Result := CallVistA('OREVNTX1 ISHDORD', [AnOrderId],rst) and
    (rst > 0);
end;

function SetDefaultEvent(var AErrMsg: string; EvtID: string): Boolean;
begin
  CallVistA('OREVNTX1 SETDFLT', [EvtID],AErrMsg);
  Result := True;
end;

function GetEventPromptID: Integer;
begin
  if not CallVistA('OREVNTX1 PRMPTID', [nil],Result) then
    Result := 0;
end;

function GetDefaultTSForEvt(AnEvtID: Integer): string;
begin
  if not CallVistA('OREVNTX1 DEFLTS', [AnEvtID],Result) then
    Result := '';
end;

function GetPromptIDs: string;
begin
  if not CallVistA('OREVNTX1 PROMPT IDS', [nil],Result) then
    Result := '';
end;

function GetEventDefaultDlg(AEvtId: Integer): string;
begin
  if not CallVistA('OREVNTX1 DFLTDLG', [AEvtId],Result) then
    Result := '';
end;

function CanManualRelease: Boolean;
var
  rst: Integer;
begin
  Result := False;
  if CallVistA('OREVNTX1 AUTHMREL', [nil],rst) then
    Result := rst > 0;
end;

function TheParentPtEvt(APtEvt: string): string;
begin
  if not CallVistA('OREVNTX1 HAVEPRT', [APtEvt], Result) then
    Result := '';
end;

function IsCompletedPtEvt(APtEvtID: Integer): Boolean;
var
  rst: Integer;
begin
  Result := CallVistA('OREVNTX1 COMP', [APtEvtID], rst) and (rst > 0);
end;

function IsPassEvt(APtEvtID: Integer; APtEvtType: Char): Boolean;
var
  rst: Integer;
begin
  Result := CallVistA('OREVNTX1 ISPASS', [APtEvtID, SafeEventType(APtEvtType)],rst) and (rst = 1);
end;

function IsPassEvt1(AnEvtID: Integer; AnEvtType: Char): Boolean;
var
  rst: Integer;
begin
  Result := CallVistA('OREVNTX1 ISPASS1', [AnEvtID, SafeEventType(AnEvtType)],rst) and (rst = 1);
end;

procedure TerminatePtEvt(APtEvtID: Integer);
begin
  CallVistA('OREVNTX1 DONE', [APtEvtID]);
end;

procedure SetPtEvtList(Dest: TStrings; APtDFN: string; var ATotal: Integer);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    ATotal := 0;
    Dest.Clear;
    if CallVistA('OREVNTX LIST', [APtDFN], Results) then
      if Results.Count > 0 then
      begin
        ATotal := StrToIntDef(Results[0], 0);
        if ATotal > 0 then
        begin
          MixedCaseList(Results);
          Results.Delete(0);
          FastAssign(Results, Dest);
        end;
      end;
  finally
    Results.Free;
  end;
end;

procedure GetTSListForEvt(Dest: TStrings; AnEvtID: Integer);
var
  Results: TStrings;
begin
  Results := TStringList.Create;
  try
    if CallVistA('OREVNTX1 MULTS', [AnEvtID],Results) and (Results.Count > 0) then
    begin
      SortByPiece(Results, '^', 2);
      FastAssign(Results, Dest);
    end;
  finally
    Results.Free;
  end;
end;

//procedure GetChildEvent(var AChildList: TStringList; APtEvtID: string);
//begin
//end;

function DeleteEmptyEvt(APtEvntID: string; var APtEvntName: string;
  Ask: Boolean): Boolean;
const
  TX_EVTDEL1 = 'There are no orders tied to ';
  TX_EVTDEL2 = ', Would you like to cancel it?';
begin
  Result := False;
  if APtEvntID = '0' then
  begin
    Result := True;
    Exit;
  end;
  if PtEvtEmpty(APtEvntID) then
  begin
    if Length(APtEvntName) = 0 then
      APtEvntName := GetEventName(APtEvntID);
    if Ask then
    begin
      if InfoBox(TX_EVTDEL1 + APtEvntName + TX_EVTDEL2, 'Confirmation',
        MB_YESNO or MB_ICONQUESTION) = IDYES then
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

function CompleteEvt(APtEvntID: string; APtEvntName: string;
  Ask: Boolean): Boolean;
const
  TX_EVTFIN1 = 'All of the orders tied to ';
  TX_EVTFIN2 = ' have been released to a service, ' + #13 +
    'Would you like to terminate this event?';
var
  ThePtEvtName: string;
begin
  Result := False;
  if APtEvntID = '0' then
    Result := True
  else
  if PtEvtEmpty(APtEvntID) then
  begin
    if Length(APtEvntName) = 0 then
      ThePtEvtName := GetEventName(APtEvntID)
    else
      ThePtEvtName := APtEvntName;
{
    if Ask then
    begin
      if InfoBox(TX_EVTFIN1 + ThePtEvtName + TX_EVTFIN2, 'Confirmation',
        MB_OKCANCEL or MB_ICONQUESTION) = IDOK then
      begin
        SCallV('OREVNTX1 DONE', [APtEvntID]);
        Result := True;
      end;
    end
    else
    begin
      SCallV('OREVNTX1 DONE', [APtEvntID]);
      Result := True;
    end;
  end;
}
    if not Ask or (InfoBox(TX_EVTFIN1 + ThePtEvtName + TX_EVTFIN2,
      'Confirmation', MB_OKCANCEL or MB_ICONQUESTION) = IDOK) then
      Result := CallVistA('OREVNTX1 DONE', [APtEvntID]);
  end;
end;

{ Order Checking }

function FillerIDForDialog(IEN: Integer): string;
begin
  if not CallVistA('ORWDXC FILLID', [IEN],Result) then
    Result := '';
end;

function IsMonograph(): Boolean;
var
  ret: string;
begin
  Result := CallVistA('ORCHECK ISMONO', [nil],ret) and
    (copy(ret,1,1)='1');
end;

procedure GetMonographList(ListOfMonographs: TStringList);
begin
  CallVistA('ORCHECK GETMONOL', [], ListOfMonographs);
end;

procedure GetMonograph(Monograph: TStringList; x: Integer);
begin
  CallVistA('ORCHECK GETMONO', [x], Monograph);
end;

procedure DeleteMonograph();
begin
  CallVistA('ORCHECK DELMONO', []);
end;

procedure GetXtraTxt(OCText: TStringList; x: String; y: String);
begin
  if not CallVistA('ORCHECK GETXTRA', [x, y], OCText) then
    OCText.Clear;
end;

function OrderChecksEnabled: Boolean;
var
  s: String;
begin
  if uOrderChecksOn = #0 then
    if CallVistA('ORWDXC ON', [nil],s) then
      uOrderChecksOn := CharAt(s,1);

  Result := uOrderChecksOn = 'E';
end;

function OrderChecksOnDisplay(const FillerID: string): string;
var
  sl: TStrings;
begin
  sl := TStringList.Create;
  try
    if CallVistA('ORWDXC DISPLAY', [Patient.DFN, FillerID], sl) then
      Result := sl.Text
    else
      Result := '';
  finally
    sl.Free;
  end;
end;

procedure OrderChecksOnAccept(ListOfChecks: TStringList;
  const FillerID, StartDtTm: string; OIList: TStringList; DupORIFN: string;
  Renewal: string; Fields: string; IncludeAllergyChecks: boolean = False);
var
  Results: TStrings;
begin
  // don't pass OIList if no items, since broker pauses 5 seconds per order
  Results := TStringList.Create;
  try
    uAllergyCacheCreated := True;
    if (not IncludeAllergyChecks) and uAllergiesChanged then
      IncludeAllergyChecks := True;
    if OIList.Count > 0 then
    begin
      if not CallVistA('ORWDXC ACCEPT', [Patient.DFN, FillerID, StartDtTm,
        Encounter.Location, OIList, DupORIFN, Renewal, Fields,
        IncludeAllergyChecks], Results) then
          Results.Clear;
    end else begin
      if not CallVistA('ORWDXC ACCEPT', [Patient.DFN, FillerID, StartDtTm,
        Encounter.Location, nil, '', '', Fields, IncludeAllergyChecks],
        Results) then
          Results.Clear;
    end;
    FastAssign(Results, ListOfChecks);
  finally
    Results.Free;
  end;
end;

procedure GetAllergyReasonList(aList: TStrings; Item1: Integer; AFlag: String);
begin
  CallVistA('ORWDXC REASON', [AFlag, Patient.DFN, Item1], aList);
end;

procedure OrderChecksOnMedicationSelect(ListOfChecks: TStringList;
  const FillerID: String; Item1: Integer; OrderNum: string = '');
begin
  uAllergyCacheCreated := True;
  uAllergiesChanged := False;
  CallVistA('ORWDXC ALLERGY', [Patient.DFN, FillerID, Item1, OrderNum,
    Encounter.Location], ListOfChecks);
end;

procedure ClearAllergyOrderCheckCache;
begin
  if uAllergyCacheCreated then
  begin
    CallVistA('ORWDXC CLRALLGY', [Patient.DFN]);
    uAllergyCacheCreated := False;
  end;
end;

procedure OrderChecksOnDelay(ListOfChecks: TStringList;
  const FillerID, StartDtTm: string; OIList: TStringList);
var
  Results: TStrings;
begin
  // don't pass OIList if no items, since broker pauses 5 seconds per order
  {
    if OIList.Count > 0 then
    CallV('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm,
    Encounter.Location, OIList])
    else
    CallV('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm,
    Encounter.Location]);
    FastAssign(RPCBrokerV.Results, ListOfChecks);
  }
  Results := TStringList.Create;
  try
    if OIList.Count > 0 then
    begin
      if not CallVistA('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm,
        Encounter.Location, OIList], Results) then
        Results.Clear;
    end
    else if not CallVistA('ORWDXC DELAY', [Patient.DFN, FillerID, StartDtTm,
      Encounter.Location], Results) then
      Results.Clear;
    FastAssign(Results, ListOfChecks);
  finally
    Results.Free;
  end;
end;

procedure OrderChecksForSession(ListOfChecks, OrderList: TStringList);
begin
  CallVistA('ORWDXC SESSION', [Patient.DFN, OrderList], ListOfChecks);
end;

procedure SaveOrderChecksForSession(const AReason: string;
  ListOfChecks: TStringList);
var
  i, Inc, len, numLoop, remain: Integer;
  OCStr, TmpStr: string;
  aList: iORNetMult;
begin
  newORNetMult(aList);
  aList.AddSubscript(['ORCHECKS'], ListOfChecks.Count);
  for i := 0 to ListOfChecks.Count - 1 do
  begin
    OCStr := ListOfChecks.Strings[i];
    len := Length(OCStr);
    if len > 255 then
    begin
      numLoop := len div 255;
      remain := len mod 255;
      Inc := 0;
      while Inc <= numLoop do
      begin
        TmpStr := Copy(OCStr, 1, 255);
        OCStr := Copy(OCStr, 256, Length(OCStr));
        aList.AddSubscript(['ORCHECKS' , i, Inc], TmpStr);
        Inc := Inc + 1;
      end;
      if remain > 0 then
        aList.AddSubscript(['ORCHECKS' , i,Inc], OCStr);
    end
    else
      aList.AddSubscript(['ORCHECKS',i], OCStr);
  end;

  CallVistA('ORWDXC SAVECHK',[Patient.DFN, aReason,aList]);
end;

// NSR 20101203 --------------------------------------------------------------------------begin
procedure SaveMultiOrderChecksForSession(ListOfChecks, ListOfReasons, ListOfComments: TStringList);
var
  i, Inc, len, numLoop, remain: Integer;
  CStr, OCStr, RStr, TmpStr: string;
  AList: iORNetMult;
begin
  neworNetMult(AList);
  AList.AddSubscript('ORCHECKS', IntToStr(ListOfChecks.Count));
  AList.AddSubscript('ORREASONS', IntToStr(ListOfReasons.Count));
  AList.AddSubscript('ORCOMMENTS', IntToStr(ListOfComments.Count));

  for i := 0 to ListOfChecks.Count - 1 do
  begin
    OCStr := ListOfChecks.Strings[i];
    len := Length(OCStr);
    if len > 255 then
    begin
      numLoop := len div 255;
      remain := len mod 255;
      Inc := 0;
      while Inc <= numLoop do
      begin
        TmpStr := Copy(OCStr, 1, 255);
        OCStr := Copy(OCStr, 256, Length(OCStr));
        AList.AddSubscript(['ORCHECKS', i, Inc], TmpStr);
        Inc := Inc + 1;
      end;
      if remain > 0 then
        AList.AddSubscript(['ORCHECKS', i, Inc], OCStr);

    end
    else
      AList.AddSubscript(['ORCHECKS', i], OCStr);
  end;

  for i := 0 to ListOfReasons.Count - 1 do
  begin
    RStr := ListOfReasons.Strings[i];
    {len := Length(OCStr);
    if len > 255 then
    begin
      numLoop := len div 255;
      remain := len mod 255;
      Inc := 0;
      while Inc <= numLoop do
      begin
        TmpStr := Copy(OCStr, 1, 255);
        OCStr := Copy(OCStr, 256, Length(OCStr));
        AList.AddSubscript(['ORCHECKS', i, Inc], TmpStr);
        Inc := Inc + 1;
      end;
      if remain > 0 then
        AList.AddSubscript(['ORCHECKS', i, Inc], OCStr);

    end
    else}
    AList.AddSubscript(['ORREASONS', i], RStr);
  end;

  for i := 0 to ListOfComments.Count - 1 do
  begin
    CStr := ListOfComments.Strings[i];
    {len := Length(OCStr);
    if len > 255 then
    begin
      numLoop := len div 255;
      remain := len mod 255;
      Inc := 0;
      while Inc <= numLoop do
      begin
        TmpStr := Copy(OCStr, 1, 255);
        OCStr := Copy(OCStr, 256, Length(OCStr));
        AList.AddSubscript(['ORCHECKS', i, Inc], TmpStr);
        Inc := Inc + 1;
      end;
      if remain > 0 then
        AList.AddSubscript(['ORCHECKS', i, Inc], OCStr);

    end
    else}
    AList.AddSubscript(['ORCOMMENTS', i], CStr);
  end;

  CallVistA('ORWDXC SAVEMCHK', [Patient.DFN, AList]);

  { RPCBrokerV.ClearParameters := True;
    RPCBrokerV.RemoteProcedure := 'ORWDXC SAVECHK';
    RPCBrokerV.Param[0].PType := literal;
    RPCBrokerV.Param[0].Value := Patient.DFN;  //*DFN*
    RPCBrokerV.Param[1].PType := list;
    RPCBrokerV.Param[1].Mult['"ORCHECKS"'] := IntToStr(ListOfChecks.count);

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
    RPCBrokerV.Param[1].Mult['"ORCHECKS",' + InttoStr(i) + ',' + InttoStr(inc)] := tmpStr;
    inc := inc +1;
    end;
    if remain > 0 then
    RPCBrokerV.Param[1].Mult['"ORCHECKS",' + InttoStr(i) + ',' + inttoStr(inc)] := OCStr;
    end
    else
    RPCBrokerV.Param[1].Mult['"ORCHECKS",' + InttoStr(i)] := OCStr;
    end;

    CallBroker; }
end;
// NSR 20101203 ----------------------------------------------------------------------------end

function DeleteCheckedOrder(const OrderID: string): Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDXC DELORD', [OrderID],s) and (s = '1');
end;

function DataForOrderCheck(const OrderID: string): string;
begin
  if not CallVistA('ORWDXR01 OXDATA', [OrderID],Result) then
    Result := '';
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

function IsValidOverrideReason(const Reason: string): boolean;
// This checks the minimum length of the override reason, and makes sure that
// there are no upcarrots
const
  MIN_OVERRIDE_LENGTH = 4;
  NO_REASON = 'NO OVERRIDE REASON GIVEN';

begin
  Result := (Length(trim(Reason)) >= MIN_OVERRIDE_LENGTH) and
    not ContainsUpCarretChar(Reason) and (pos(NO_REASON, UpperCase(Reason)) = 0);
end;

procedure OrderPrintDeviceInfo(OrderList: TStringList;
  var PrintParams: TPrintParams; Nature: Char; PrintLoc: Integer = 0);
var
  x: string;
  Results: TStrings;

  function getDevInfo: TStrings;
  var
    b: Boolean;
  begin
    Result := TStringList.Create;
    try
      if Nature <> #0 then
      begin
        if PrintLoc > 0 then
          b := CallVistA('ORWD2 DEVINFO', [PrintLoc, Nature, OrderList], Result)
        else
          b := CallVistA('ORWD2 DEVINFO', [Encounter.Location, Nature, OrderList], Result);
        if not b then
          raise Exception.Create('Unable to obtain Printer Settings');
      end
      else
      begin
        if PrintLoc > 0 then
          b := CallVistA('ORWD2 MANUAL', [PrintLoc, OrderList], Result)
        else
          b := CallVistA('ORWD2 MANUAL', [Encounter.Location, OrderList], Result);
        if not b then
          raise Exception.Create('Unable to obtain Printer Settings for manual prints');
      end;
      if not b then
        Result.Clear;
    except
      FreeAndNil(Result);
      raise;
    end;
  end;

begin
  Results := getDevInfo;
  try
    FillChar(PrintParams, SizeOf(PrintParams), #0);
    if Results.Count <= 0 then begin
      raise Exception.Create('Unable to obtain Device Info'); // If this ever gets raised, we need to investigate the M side
    end else begin
      x := Results[0];
      with PrintParams do
      begin
        PromptForChartCopy := CharAt(Piece(x, U, 1), 1);
        if Piece(x, U, 5) <> '' then
          ChartCopyDevice := Piece(Piece(x, U, 5), ';', 1) + '^' +
            Piece(Piece(x, U, 5), ';', 2);
        PromptForLabels := CharAt(Piece(x, U, 2), 1);
        if Piece(x, U, 6) <> '' then
          LabelDevice := Piece(Piece(x, U, 6), ';', 1) + '^' +
            Piece(Piece(x, U, 6), ';', 2);
        PromptForRequisitions := CharAt(Piece(x, U, 3), 1);
        if Piece(x, U, 7) <> '' then
          RequisitionDevice := Piece(Piece(x, U, 7), ';', 1) + '^' +
            Piece(Piece(x, U, 7), ';', 2);
        PromptForWorkCopy := CharAt(Piece(x, U, 4), 1);
        if Piece(x, U, 8) <> '' then
          WorkCopyDevice := Piece(Piece(x, U, 8), ';', 1) + '^' +
            Piece(Piece(x, U, 8), ';', 2);
        AnyPrompts := (CharInSet(PromptForChartCopy, ['1', '2']) or
          CharInSet(PromptForLabels, ['1', '2']) or
          CharInSet(PromptForRequisitions, ['1', '2']) or
          CharInSet(PromptForWorkCopy, ['1', '2']));
      end;

      if Nature <> #0 then
      begin
        Results.Delete(0);
        OrderList.Clear;
        FastAssign(Results, OrderList);
      end;
    end;
  finally
    Results.Free;
  end;
end;

procedure SaveEvtForOrder(APtDFN: string; AEvt: Integer; AnOrderId: string);
begin
  CallVistA('OREVNTX1 PUTEVNT', [APtDFN, IntToStr(AEvt), AnOrderId]);
end;

function EventExist(APtDFN: string; AEvt: Integer): Integer;
var
  AOutCome: string;
begin
  Result := 0;
  if CallVistA('OREVNTX1 EXISTS', [APtDFN, IntToStr(AEvt)],AOutCome) then
    Result := StrToIntDef(AOutCome,0);
end;

function UseNewMedDialogs: Boolean;
var
  s: String;
begin
  Result := CallVistA('ORWDPS1 CHK94', [nil],s) and (s = '1');
end;

{ Copay }
(* RTC 272867 ------------------------------------------------------------------
procedure GetCoPay4Orders; -- not used in the project?
begin
  LockBroker;
  try
    RPCBrokerV.RemoteProcedure := 'ORWDPS4 CPLST';
    RPCBrokerV.Param[0].PType := literal;
    RPCBrokerV.Param[0].Value := Patient.DFN;
    CallBroker;
  finally
    UnlockBroker;
  end;
end;
------------------------------------------------------------------------------*)
procedure SaveCoPayStatus(AList: TStrings);
var
  i: Integer;
  iList: iORNetMult;
begin
  if aList.Count > 0 then
  begin
    newOrNetMult(iList);
    for i := 0 to aList.Count - 1 do
      iList.AddSubscript([IntToStr(i + 1)], aList[i]);
    CallVistA('ORWDPS4 CPINFO', [iList]);
  end;
end;

function LocationType(Location: Integer): string;
begin
  CallVistA('ORWDRA32 LOCTYPE', [Location], Result);
end;

function IsValidIMOLoc(LocID: Integer; PatientID: string): Boolean; // IMO
var
  rst: string;
begin
  Result := CallVistA('ORIMO IMOLOC', [LocID, PatientID], rst) and
    (StrToIntDef(rst, -1) > -1);
end;

function IsValidIMOLocOrderCom(LocID: Integer; PatientID: string): Boolean;
// IMO
var
  rst: string;
begin
  Result := CallVistA('ORIMO IMOLOC', [LocID, PatientID, 1], rst) and
    (StrToIntDef(rst, -1) > -1);
end;

function IsIMOOrder(OrderID: string): Boolean; // IMO
var
  ret: String;
begin
  Result := CallVistA('ORIMO IMOOD', [OrderID], ret) and (ret = '1');
end;

function IsInptQO(DlgID: Integer): Boolean;
var
  ret: String;
begin
  Result := CallVistA('ORWDXM3 ISUDQO', [DlgID], ret) and (ret = '1');
end;

function IsIVQO(DlgID: Integer): Boolean;
var
  ret: String;
begin
  Result := CallVistA('ORIMO ISIVQO', [DlgID], ret) and (ret = '1');
end;

function IsClinicLoc(ALoc: Integer): Boolean;
var
  ret: String;
begin
  Result := CallVistA('ORIMO ISCLOC', [ALoc], ret) and (ret = '1');
end;

function IsValidSchedule(AnOrderId: string): Boolean; // nss
var
  ret: String;
begin
  Result := CallVistA('ORWNSS VALSCH', [AnOrderId], ret) and (ret = '1');
end;

function IsValidQOSch(QOID: string): string; // nss
begin
  CallVistA('ORWNSS QOSCH', [QOID], Result);
end;

function IsValidSchStr(ASchStr: string): Boolean;
var
  ret: String;
begin
  Result := CallVistA('ORWNSS CHKSCH', [ASchStr], ret) and (ret = '1');
end;

function IsPendingHold(OrderID: string): Boolean;
var
  ret: string;
begin
  Result := CallVistA('ORDEA PNDHLD', [OrderID], ret) and (ret = '1');
end;

{ TParentEvent }

procedure TParentEvent.Assign(AnEvtID: string);
var
  evtInfo: string;
begin
  // ORY = EVTTYPE_U_EVT_U_EVTNAME_U_EVTDISP_U_EVTDLG
  evtInfo := EventInfo1(AnEvtID);
  ParentIFN := StrToInt(AnEvtID);
  if Length(Piece(evtInfo, '^', 4)) < 1 then
    ParentName := Piece(evtInfo, '^', 3)
  else
    ParentName := Piece(evtInfo, '^', 4);
  ParentType := CharAt(Piece(evtInfo, '^', 1), 1);
  ParentDlg := Piece(evtInfo, '^', 5);
end;

constructor TParentEvent.Create(Nothing: integer);
begin
  ParentIFN := 0;
  ParentName := '';
  ParentType := #0;
  ParentDlg := '0';
end;

function SafeEventType(CurrentEventType: Char): Char;
begin
  if CurrentEventType = #0 then
    Result := 'C'
  else
    Result := CurrentEventType;
end;

procedure GetOrderableItemInfo(Dest: TStrings; InfoNeeded: TOrderableItemInfoType);
begin
  CallVistA('ORACCES2 DLGOIINFO', [Dest, ord(InfoNeeded)], Dest);
end;

function GetGroupsUsedByXRef(XREF: string): string;
begin
  CallVistA('ORACCES2 LABSBYXREF', [XREF], Result);
end;

procedure GetDieteticsGroupInfo(Dest: TStrings);
begin
  CallVistA('ORACCES2 DIETINFO', [], Dest);
end;

{ TLockedList }

procedure TLockList.AddLock(AID, AAction: string; ALockType: TLockType);
var
  LockObj: TLock;
begin
  LockObj := TLock.Create;
  try
    LockObj.ID := AID;
    LockObj.Action := AAction;
    LockObj.LockType := ALockType;
    Self.Add(LockObj);
  except
    FreeAndNil(LockObj);
    raise;
  end;
end;

procedure TLockList.ClearAllLocks;
var
  i: Integer;
begin
  For i := Self.Count - 1 downto 0 do
  begin
    Self.ClearLockByID(Self[i].ID, Self[i].LockType);
  end;
end;

procedure TLockList.ClearLocksByAction(AnAction: string);
var
  i: Integer;
begin
  For i := Self.Count - 1 downto 0 do
  begin
    If (Self[i].Action = AnAction) then
      Self.ClearLockByID(Self[i].ID, Self[i].LockType);
  end;
end;

procedure TLockList.ClearLockByID(AID: String; ALockType: TLockType);
begin
  Case ALockType of
    ltPatient:
      UnlockPatient;
    ltOrder:
      UnlockOrder(AID);
  End;
end;

procedure TLockList.ClearLocksByType(ALockType: TLockType);
var
  i: Integer;
begin
  For i := Self.Count - 1 downto 0 do
  begin
    If (Self[i].LockType = ALockType) then
      Self.ClearLockByID(Self[i].ID, Self[i].LockType);
  end;
end;

procedure TLockList.DeleteLock(AID: String; ALockType: TLockType);
var
  i: Integer;
begin
  for i := 0 to Self.Count - 1 do
  begin
    If (Self[i].ID = AID) and (Self[i].LockType = ALockType) then
    begin
      Self.Delete(i);
      Break;
    end;
  end;
end;

destructor TLockList.Destroy;
begin
  ClearAllLocks;
  inherited;
end;

initialization
  uDGroupAll := 0;
  uOrderChecksOn := #0;
  LockList := TLockList.Create(True);

finalization
  if uDGroupMap <> nil then
    uDGroupMap.Free;
  FreeAndNil(LockList);

end.

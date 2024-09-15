unit uOrders;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, uConst, rConsults,
  rOrders, ORFn, Dialogs, ORCtrls, stdCtrls, strUtils, fODBase, fODMedOIFA,
  VA508AccessibilityRouter, VA508AccessibilityManager, ORNet, DateUtils, TRPCb,
  rMisc, Vcl.ComCtrls, rODBase, system.JSON, System.Character,
  uWriteAccess;

type
  EOrderDlgFail = class(Exception);
  TLoadMOBProc = procedure(aConnectParams: WideString; aRunParams: WideString;
    var aResult: longBool);

  { Ordering Environment }
function AuthorizedUser: Boolean;
function AuthorizedToVerify: Boolean;
function EncounterPresent(ErrorMsg: String = ''): Boolean;
function EncounterPresentEDO: Boolean;
function LockedForOrdering: Boolean;
function IsValidActionOnComplexOrder(AnOrderID, AnAction: string;
  AListBox: TListBox; var CheckedList: TStringList; var ErrMsg: string;
  var ParentOrderID: string): Boolean; // PSI-COMPLEX
procedure UnlockIfAble;
function OrderCanBeLocked(OrderID: string): Boolean;
procedure UnlockOrderIfAble(OrderID: string);
procedure AddSelectedToChanges(AList: TList);
procedure ResetDialogProperties(const AnID: string; AnEvent: TOrderDelayEvent;
  var ResolvedDialog: TOrderDialogResolved);
function IsInvalidActionWarning(const AnOrderText, AnOrderID: String): Boolean;
procedure InitialOrderVariables;
procedure BuildResponseVarsForOutpatient(AResponses: TObject; var AUnits,
  ASchedule, ADuration, ADrug: String; NoPRN: boolean);

{ Write Orders }
function ActivateAction(const AnID: string; AnOwner: TComponent;
  ARefNum: Integer): Boolean;
function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent;
  const AnOwner: TComponent; const ARefNum: Integer;
  const ANeedVerify: Boolean = True; const ForceEdit: Boolean = False): Boolean;
function RetrieveOrderText(AnOrderID: string): string;
function ActivateOrderHTML(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderMenu(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderSet(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderList(AList: TStringList; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer;
  const KeyVarStr, ACaption: string): Boolean;
function ActiveOrdering: Boolean;
function CloseOrdering: Boolean;
function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
function ReadyForNewOrder1(AnEvent: TOrderDelayEvent): Boolean;
function ChangeOrdersEvt(AnOrderID: string; AnEvent: TOrderDelayEvent): Boolean;
function CopyOrders(AList: TStringList; AnEvent: TOrderDelayEvent;
  var DoesEventOccur: Boolean; ANeedVerify: Boolean = True): Boolean;
function TransferOrders(AList: TStringList; AnEvent: TOrderDelayEvent;
  var DoesEventOccur: Boolean; ANeedVerify: Boolean = True): Boolean;
procedure SetConfirmEventDelay;
procedure ChangeOrders(AList: TStringList; AnEvent: TOrderDelayEvent);
procedure DestroyingOrderAction;
procedure DestroyingOrderDialog;
procedure DestroyingOrderHTML;
procedure DestroyingOrderMenu;
procedure DestroyingOrderSet;
function OrderIsLocked(const AnOrderID, AnAction: string): Boolean;
procedure PopLastMenu;
procedure QuickOrderSave;
procedure QuickOrderListEdit;
function RefNumFor(AnOwner: TComponent): Integer;
procedure PrintOrdersOnSignReleaseMult(OrderList, ClinicLst,
  WardLst: TStringList; Nature: Char; EncLoc, WardLoc: Integer;
  EncLocName, WardLocName: string);
procedure PrintOrdersOnSignRelease(OrderList: TStringList; Nature: Char;
  PrintLoc: Integer = 0; PrintName: string = '');
procedure SetFontSize(FontSize: Integer);
procedure NextMove(var NMRec: TNextMoveRec; LastIndex: Integer;
  NewIndex: Integer);
// function GetQOAltOI: integer;

{ Inpatient medication for Outpatient / Clinic Medications }
function IsIMODialog(DlgID: Integer): Boolean;
function AllowActionOnIMO(AnEvtTyp: Char): Boolean;
function IMOActionValidation(AnID: string; var IsIMOOD: Boolean; var x: string;
  AnEventType: Char): Boolean;
function IMOTimeFrame: TFMDateTime;
procedure ShowOneStepAdmin;
function LoadMOBDLL: TDllRtnRec;
procedure UnloadMOBDLL;
function TitrationSafeText(Text1, Text2: string): string;

function canWriteOrder(DGIEN: Integer): Boolean; overload;
function canWriteOrder(DGIEN: Integer; DGName: String;
  Action: String; ShowError: Boolean = False; ErrorText: String = '';
  RequireChildAccess: Boolean = False): Boolean; overload;
function canWriteOrder(DGIEN: Integer; DGName: String;
  Action: TActionType; ShowError: Boolean = False; ErrorText: String = '';
  RequireChildAccess: Boolean = False): Boolean; overload;
function canWriteOrder(ResolvedDialog: TOrderDialogResolved): boolean; overload;
function canWriteOrder(AnOrder: TOrder; Action: TActionType): boolean; overload;
function canWriteOrder(AnOrder: TOrder; Action: string): boolean; overload;

function HasDaysSupplyComplexDoseConflict(AResponses: TObject;
  CurSupply: integer; OrderText: string; var EditOrder: Boolean): Boolean;

type
  TResponsesAdapter = class
  private
    FResponses: TResponses;
    FResponseList: TList;
    FIsRespObj :boolean;
    function GetEventType: Char;
  public
    procedure Assign(Adaptee: TObject);
    function IValueFor(const APromptID: string; AnInstance: Integer): string;
    function EValueFor(const APromptID: string; AnInstance: Integer): string;
    function InstanceCount(const APromptID: string): Integer;
    function NextInstance(const APromptID: string; LastInstance: Integer): Integer;
    procedure Update(const APromptID: string; AnInstance: Integer;
                                const AnIValue, AnEValue: string);
    function FindResponseByName(const APromptID: string; AnInstance: Integer): TResponse;
    property EventType: Char read GetEventType;
  end;

  TUpdateStartExpiresProc = procedure(const CurSchedule: string) of object;

function ResponsesAdapter: TResponsesAdapter;

procedure UpdateRefills(Responses: TObject; const CurDispDrug: string;
  CurSupply: Integer; AEvtForPassDischarge: Char; txtRefills: TCaptionEdit;
  spnRefills: TUpDown; var AUpdated: boolean);

procedure CheckChanges(Responses: TObject; AIsQuickOrder, AInptDlg, AIsComplex: boolean;
            AQOInitial, AIsClozapineOrder: boolean; AEvtForPassDischarge: Char;
            DosageText: string; AScheduleChanged, ANoZERO: boolean;
            var AChanging, AUpdated: boolean;
            var ALastUnits, ALastSchedule, ALastDuration, ALastInstruct, ALastDispDrug: string;
            var ALastTitration: boolean; var ALastQuantity: Double; var ALastSupply: Integer;
            txtQuantity, txtSupply, txtRefills: TCaptionEdit;
            spnSupply, spnQuantity, spnRefills: TUpDown; lblAdminTime: TVA508StaticText;
            UpdateStartExpiresProc: TUpdateStartExpiresProc);

function currentDialog: TfrmODBase;

var
  uAutoAc: Boolean;
  InptDisp: Integer;
  OutptDisp: Integer;
  SupplyDisp: Integer;
  MedsDisp: Integer;
  ClinDisp: Integer; // IMO
  ClinOrdDisp: Integer;
  ClinIVDisp: Integer;
  ClinSchDisp: Integer;
  NurDisp: Integer;
  IVDisp: Integer;
  CsltDisp: Integer;
  ProcDisp: Integer;
  ImgDisp: Integer;
  DietDisp: Integer;
  NonVADisp: Integer;
  LabDisp: Integer;
  MedsInDlgIen: Integer;
  ClinMedsDlgIen: Integer;
  ClinIVDlgIen: Integer;
  MedsOutDlgIen: Integer;
  MedsNVADlgIen: Integer;
  MedsInDlgFormId: Integer;
  MedsOutDlgFormId: Integer;
  MedsNVADlgFormID: Integer;
  MedsIVDlgIen: Integer;
  MedsIVDlgFormID: Integer;
  ClinIVDlgFormID: Integer;
  NSSchedule: Boolean;
  OriginalMedsOutHeight: Integer;
  OriginalMedsInHeight: Integer;
  OriginalNonVAMedsHeight: Integer;
  PassDrugTstCall: Boolean;

const
  TX_QTY_NV = 'Unable to validate quantity.';
  TX_QTY_LIM = 'For this medication Quantity cannot be greater then ';
  TX_SUPPLY_NINT = 'Days Supply is an invalid number.';
  TX_SUPPLY_LIM = 'Days Supply may not be greater than ';
  TX_SUPPLY_LIM1 = 'Days Supply may not be less than 1.';
  TX_ERR_REFILL = 'The number of refills must be in the range of 0 through ';
  TX_NO_RENEW_END = ':' + CRLF + CRLF;
  TX_INVALID_NO_MESSAGE = '^TX_INVALID_NO_MESSAGE^';
  TX_NO_WRITE_ACCESS = 'you do not have write-access to %s.';
  TX_NO_VALID_GROUPS = 'there are no active orderable items for this order dialog.';

implementation

uses fODDiet, fODMisc, fODGen, fODMedIn, fODMedOut, fODText, fODConsult,
  fODProc, fODRad, uODBase,
  fODLab, fODAnatPath, fodBBank, fODMeds, fODMedIV, fODVitals,
  fODAuto, (*fODAllgy,*) fOMNavA, rCore, uCore, fFrame,
  fEncnt, fEffectDate, fOMVerify, fOrderSaveQuick, fOMSet, rODMeds,
  fLkUpLocation, fOrdersPrint, fOMAction, fAllgyAR, fOMHTML, fOrders,
  fODChild, fMeds, rMeds, rPCE, frptBox, fODMedNVA, fODChangeUnreleasedRenew,
  rODAllergy,
  UBAGlobals, fClinicWardMeds, uTemplateFields, VAUtils, System.UITypes, rTIU,
  ORSystem, RpcConf1, uInit,
  fODRTC, fODAllergyCheck, uOwnerWrapper, uInfoBoxWithBtnControls,
  ORClasses, rODRad, UResponsiveGUI;

var
  uPatientLocked: Boolean;
  uKeepLock: Boolean;
  uOrderAction: TfrmOMAction;
  uOrderDialog: TfrmODBase;
  uOrderHTML: TfrmOMHTML;
  uOrderMenu: TfrmOMNavA;
  uOrderSet: TfrmOMSet;
  uOrderSetClinMedMsg: Boolean;
  uLastConfirm: string;
  uOrderSetTime: TFMDateTime;
  uNewMedDialog: Integer;
  MOBDLLHandle : THandle = 0;
  MOBDLLName : string = 'OrderCom.dll';

const
  TX_PROV_LOC =
    'A provider and location must be selected before entering orders.';
  TC_PROV_LOC = 'Incomplete Information';
  TX_PROV_KEY = 'The provider selected for this encounter must' + CRLF +
    'hold the PROVIDER key to enter orders.';
  TC_PROV_KEY = 'PROVIDER Key Required';
  TX_NOKEY = 'You do not have the keys required to take this action.';
  TC_NOKEY = 'Insufficient Authority';
  TX_BADKEYS =
    'You have mutually exclusive order entry keys (ORES, ORELSE, or OREMAS).' +
    CRLF + 'This must be resolved before you can take actions on orders.';
  TC_BADKEYS = 'Multiple Keys';
  TC_NO_LOCK = 'Unable to Lock';
  TC_DISABLED = 'Item Disabled';
  TX_DELAY = 'Now writing orders for ';
  TX_DELAY1 = CRLF + CRLF +
    '(To write orders for current release rather than delayed release,' + CRLF +
    'close the next window and select Active Orders from the View Orders pane.)';
  TC_DELAY = 'Ordering Information';
  TX_STOP_SET = 'Do you want to stop entering the current set of orders?';
  TC_STOP_SET = 'Interupt order set';
  TC_DLG_REJECT = 'Unable to Order';
  TX_NOFORM = 'This selection does not have an associated windows form.';
  TC_NOFORM = 'Missing Form ID';
  TC_DLG_ERR = 'Dialog Error';
  TX_NO_SAVE_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_SAVE_QO = 'Save as Quick Order';
  TX_NO_EDIT_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_EDIT_QO = 'Edit Common List';
  TX_NO_QUICK = 'This ordering dialog does not support quick orders.';
  TC_NO_QUICK = 'Save/Edit Quick Orders';
  TX_CANT_SAVE_QO =
    'This order contains TIU objects, which may result in patient-specific' +
    CRLF + 'information being included in the order.  For this reason, it may not'
    + CRLF + 'be saved as a personal quick order for later reuse.';
  TX_NO_COPY = CRLF + CRLF + '- cannot be copied.' + CRLF + CRLF + 'Reason: ';
  TC_NO_COPY = 'Unable to Copy Order';
  TX_NO_CHANGE = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_CHANGE = 'Unable to Change Order';
  TC_NO_XFER = 'Unable to Transfer Order';
  TC_NOLOCK = 'Unable to Lock Order';
  TX_ONHOLD =
    'The following order has been put on-hold, do you still want to continue?';
  TX_COMPLEX = 'You can not take this action on a complex medication.' + #13 +
    'You must enter a new order.';
  STEP_FORWARD = 1;
  STEP_BACK = -1;
  TX_NOINPT =
    ': You cannot place inpatient medication orders from a clinic location for selected patient.';
  TX_CLDELAYED =
    'You cannot place a clinic medication order during a delayed ordering session.';
  TX_IMO_WARNING1 = 'You are ';
  TX_IMO_WARNING2 =
    ' Clinic Medications. The New orders will be saved as Clinic Medications and MAY NOT be available in BCMA';
  TX_PAST_DATE =
    'If this medication has been already administered by the clinician then go to the One Step Clinic Med Admin option.'
    + CRLF + CRLF + 'OR' + CRLF + CRLF +
    'If you are a nurse and need to document a clinic medication that has been previously administered greater than 23 hours in the past you need to go to BCMA.';
  TX_DAYS_CONFLICT = 'WARNING - Days supply (%d) does not match duration ' +
    'specified in complex dose (%d).' + CRLF + CRLF;

  LoadMOBProc: TLoadMOBProc = nil;

function currentDialog: TfrmODBase;
begin
  Result := uOrderDialog;
end;

function CreateOrderDialog(Sender: TComponent; FormID: Integer;
  AnEvent: TOrderDelayEvent; ODEvtID: Integer = 0): TfrmODBase;
{ creates an order dialog based on the FormID and returns a pointer to it }
type
  TDialogClass = class of TfrmODBase;
var
  DialogClass: TDialogClass;
begin
  Result := nil;
  // allows the FormCreate to check event under which dialog is created
  if CharInSet(AnEvent.EventType, ['A', 'D', 'T', 'M', 'O']) then
  begin
    SetOrderEventTypeOnCreate(AnEvent.EventType);
    SetOrderEventIDOnCreate(AnEvent.EventIFN);
  end
  else
  begin
    SetOrderEventTypeOnCreate(#0);
    SetOrderEventIDOnCreate(0);
  end;
  SetOrderFormIDOnCreate(FormID);
  // check to see if we should use the new med dialogs
  if uNewMedDialog = 0 then
  begin
    if UseNewMedDialogs then
      uNewMedDialog := 1
    else
      uNewMedDialog := -1;
  end;
  if (uNewMedDialog > 0) and ((FormID = OD_MEDOUTPT) or (FormID = OD_MEDINPT) or
    (FormID = OD_CLINICMED)) then
    FormID := OD_MEDS;
  // create the form for a given ordering dialog
  case FormID of
    OD_MEDIV:
      DialogClass := TfrmODMedIV;
    OD_MEDINPT:
      DialogClass := TfrmODMedIn;
    OD_CLINICMED:
      DialogClass := TfrmODMedIn;
    OD_CLINICINF:
      DialogClass := TfrmODMedIV;
    OD_MEDS:
      DialogClass := TfrmODMeds;
    OD_MEDOUTPT:
      DialogClass := TfrmODMedOut;
    OD_MEDNONVA:
      DialogClass := TfrmODMedNVA;
    OD_MISC:
      DialogClass := TfrmODMisc;
    OD_RTC:
      DialogClass := TfrmODRTC;
    OD_GENERIC:
      begin
        if ODEvtID > 0 then
          SetOrderEventIDOnCreate(ODEvtID);
        DialogClass := TfrmODGen;
      end;
    OD_IMAGING:
      DialogClass := TfrmODRad;
    OD_DIET:
      DialogClass := TfrmODDiet;
    OD_LAB:
      DialogClass := TfrmODLab;
    OD_AP:
      DialogClass := TfrmODAnatPath;
    OD_BB:
      DialogClass := TfrmODBBank;
    OD_CONSULT:
      DialogClass := TfrmODCslt;
    OD_PROCEDURE:
      DialogClass := TfrmODProc;
    OD_TEXTONLY:
      DialogClass := TfrmODText;
    OD_VITALS:
      DialogClass := TfrmODVitals;
    // OD_ALLERGY:   DialogClass := TfrmODAllergy;
    OD_AUTOACK:
      DialogClass := TfrmODAuto;
  else
    Exit;
  end;
  if Sender = nil then
    Sender := Application;
  Result := CreateWrappedComponent(Sender, DialogClass) as TfrmODBase;
  if Result <> nil then
    Result.CallOnExit := DestroyingOrderDialog;
  SetOrderEventTypeOnCreate(#0);
  SetOrderEventIDOnCreate(0);
  SetOrderFormIDOnCreate(0);
end;

function AuthorizedUser: Boolean;
begin
  Result := True;
  if User.NoOrdering then
    Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
end;

function AuthorizedToVerify: Boolean;
begin
  Result := True;
  if not User.EnableVerify then
    Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
end;

function EncounterPresent(ErrorMsg: String = ''): Boolean;
{ make sure a location and provider are selected, returns false if not }
begin
  Result := True;
  // If ErrorMsg was not passed in then use the default
  If ErrorMsg = '' then
    ErrorMsg := TX_PROV_LOC;

  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider,
    'PROVIDER') then
    InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
  if (Encounter.Provider = 0) or (Encounter.Location = 0) or
    ((Encounter.Provider > 0) and (not PersonHasKey(Encounter.Provider,
    'PROVIDER'))) then
  begin
    // don't prompt provider if current user has ORES and is the provider
    if (User.OrderRole = OR_PHYSICIAN) and (Encounter.Provider = User.DUZ) and
      (User.IsProvider) then
      UpdateEncounter(NPF_SUPPRESS)
    else
      UpdateEncounter(NPF_PROVIDER);
    frmFrame.DisplayEncounterText;
  end;
  if (Encounter.Provider = 0) or (Encounter.Location = 0) then
  begin
    if not frmFrame.CCOWDrivedChange then // jdccow
      InfoBox(ErrorMsg, TC_PROV_LOC, MB_OK or MB_ICONWARNING); { !!! }
    Result := False;
  end;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider,
    'PROVIDER') then
  begin
    if not frmFrame.CCOWDrivedChange then // jdccow
      InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
    Result := False;
  end;
end;

function EncounterPresentEDO: Boolean;
begin
  Result := True;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider,
    'PROVIDER') then
    InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
  if (Encounter.Provider = 0) or
    ((Encounter.Provider > 0) and (not PersonHasKey(Encounter.Provider,
    'PROVIDER'))) then
  begin
    UpdateEncounter(NPF_PROVIDER, 0, 0, True);
    frmFrame.DisplayEncounterText;
  end;
  if (Encounter.Provider = 0) then
  begin
    InfoBox(TX_PROV_LOC, TC_PROV_LOC, MB_OK or MB_ICONWARNING); { !!! }
    Result := False;
  end;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider,
    'PROVIDER') then
  begin
    InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
    Result := False;
  end;
end;

function LockedForOrdering: Boolean;
var
  ErrMsg: string;
begin
  if uPatientLocked then
    Result := True
  else
  begin
    LockPatient(ErrMsg);
    if ErrMsg = '' then
    begin
      Result := True;
      uPatientLocked := True;
      frmFrame.stsArea.Panels.Items[4].Text := 'LOCK';
    end
    else
    begin
      Result := False;
      InfoBox(ErrMsg, TC_NO_LOCK, MB_OK);
    end;
  end;
end;

procedure UnlockIfAble;
begin
  if (Changes.Orders.Count = 0) and not uKeepLock then
  begin
    UnlockPatient;
    uPatientLocked := False;
    frmFrame.stsArea.Panels.Items[4].Text := '';
  end;
end;

function OrderCanBeLocked(OrderID: string): Boolean;
var
  ErrMsg: string;
begin
  LockOrder(OrderID, ErrMsg);
  if ErrMsg = '' then
  begin
    Result := True;
    frmFrame.stsArea.Panels.Items[4].Text := 'LOCK';
  end
  else
  begin
    Result := False;
    InfoBox(ErrMsg, TC_NO_LOCK, MB_OK);
  end;
end;

procedure UnlockOrderIfAble(OrderID: string);
begin
  UnlockOrder(OrderID);
  frmFrame.stsArea.Panels.Items[4].Text := '';
end;

procedure AddSelectedToChanges(AList: TList);
{ update Changes with orders that were created by taking actions }
var
  i, CanSign: Integer;
  AnOrder: TOrder;
begin
  if (Encounter.Provider = User.DUZ) and User.CanSignOrders then
    CanSign := CH_SIGN_YES
  else
    CanSign := CH_SIGN_NA;
  with AList do
    for i := 0 to Count - 1 do
    begin
      AnOrder := TOrder(Items[i]);
      with AnOrder do
        Changes.Add(CH_ORD, ID, Text, '', CanSign, waOrders, '', 0, DGroup);
      if (Length(AnOrder.ActionOn) > 0) and not Changes.ExistForOrder
        (Piece(AnOrder.ActionOn, ';', 1)) then
        UnlockOrder(AnOrder.ActionOn);
    end;
end;

procedure ResetDialogProperties(const AnID: string; AnEvent: TOrderDelayEvent;
  var ResolvedDialog: TOrderDialogResolved);
begin
  if StrToIntDef(AnID, 0) > 0 then
    Exit;
  if XfInToOutNow then
  begin
    ResolvedDialog.DisplayGroup := OutptDisp;
    ResolvedDialog.DialogIEN := MedsOutDlgIen;
    ResolvedDialog.FormID := MedsOutDlgFormId;
    ResolvedDialog.QuickLevel := 0;
    Exit;
  end;
  // if ResolvedDialog.DisplayGroup in [MedsDisp, OutptDisp, InptDisp, NonVADisp, ClinDisp] then
  if (ResolvedDialog.DisplayGroup = InptDisp) or
    (ResolvedDialog.DisplayGroup = OutptDisp) or
    (ResolvedDialog.DisplayGroup = MedsDisp) or
    (ResolvedDialog.DisplayGroup = NonVADisp) or
    (ResolvedDialog.DisplayGroup = ClinDisp) or
    (ResolvedDialog.DisplayGroup = ClinIVDisp) then
  begin
    if (AnEvent.EventType <> 'D') and (AnEvent.EventIFN > 0) then
    begin
      if (AnEvent.EventType = 'T') and IsPassEvt(AnEvent.PtEventIFN, 'T') then
      begin
        ResolvedDialog.DisplayGroup := OutptDisp;
        ResolvedDialog.DialogIEN := MedsOutDlgIen;
        ResolvedDialog.FormID := MedsOutDlgFormId;
        ResolvedDialog.QuickLevel := 0;
      end
      else
      begin
        // AGP changes to handle IMO INV Dialog opening the unit dose dialog.
        if (ResolvedDialog.DisplayGroup = ClinDisp) and
          (ResolvedDialog.DialogIEN = MedsIVDlgIen) and
          (ResolvedDialog.FormID = MedsIVDlgFormID) then
        begin
          ResolvedDialog.DisplayGroup := IVDisp;
          ResolvedDialog.DialogIEN := MedsIVDlgIen;
          ResolvedDialog.FormID := MedsIVDlgFormID;
        end
        else if (ResolvedDialog.DisplayGroup = ClinIVDisp) and
          (ResolvedDialog.DialogIEN = ClinIVDlgIen) and
          (ResolvedDialog.FormID = ClinIVDlgFormID) then
        begin
          ResolvedDialog.DisplayGroup := IVDisp;
          ResolvedDialog.DialogIEN := MedsIVDlgIen;
          ResolvedDialog.FormID := MedsIVDlgFormID;
        end
        else
        begin
          ResolvedDialog.DisplayGroup := InptDisp;
          ResolvedDialog.DialogIEN := MedsInDlgIen;
          ResolvedDialog.FormID := MedsInDlgFormId;
        end;
        if Length(ResolvedDialog.ShowText) > 0 then
          ResolvedDialog.QuickLevel := 2;
      end;
    end
    else if (AnEvent.EventType = 'D') and (AnEvent.EventIFN > 0) then
    begin
      ResolvedDialog.DisplayGroup := OutptDisp;
      ResolvedDialog.DialogIEN := MedsOutDlgIen;
      ResolvedDialog.FormID := MedsOutDlgFormId;
      ResolvedDialog.QuickLevel := 0;
    end;

    if XferOutToInOnMeds then
    begin
      ResolvedDialog.DisplayGroup := InptDisp;
      ResolvedDialog.DialogIEN := MedsInDlgIen;
      ResolvedDialog.FormID := MedsInDlgFormId;
      ResolvedDialog.QuickLevel := 0;
    end;
  end;
  if ResolvedDialog.DisplayGroup = IVDisp then
  begin
    if Length(ResolvedDialog.ShowText) > 0 then
      ResolvedDialog.QuickLevel := 2;
  end;
  if (CharAt(AnID, 1) = 'C') and
    (ResolvedDialog.DisplayGroup in [CsltDisp, ProcDisp]) then
    ResolvedDialog.QuickLevel := 0;
  // CSV - force dialog, to validate ICD code being copied into new order {RV}
end;

function IsInvalidActionWarning(const AnOrderText, AnOrderID: String): Boolean;
var
  AnErrLst, tmpList: TStringList;
begin
  Result := False;
  AnErrLst := TStringList.Create;
  IsLatestAction(AnOrderID, AnErrLst);
  if AnErrLst.Count > 0 then
  begin
    tmpList := TStringList.Create;
    PiecesToList(AnsiReplaceStr(AnOrderText, '#D#A', '^'), '^', tmpList);
    tmpList.Add(' ');
    tmpList.Add
      ('Cannot be released to service(s) because of the following happened action(s):');
    tmpList.Add(' ');
    FastAddStrings(TStrings(AnErrLst), tmpList);
    ReportBox(tmpList, 'Cannot be released to service(s)', False);
    tmpList.Free;
    AnErrLst.Free;
    Result := True;
  end;
end;

procedure InitialOrderVariables;
begin
  InptDisp := DisplayGroupByName('UD RX');
  OutptDisp := DisplayGroupByName('O RX');
  SupplyDisp := DisplayGroupByName('SPLY');
  MedsDisp := DisplayGroupByName('RX');
  IVDisp := DisplayGroupByName('IV RX');
  ClinDisp := DisplayGroupByName('C RX');
  ClinOrdDisp := DisplayGroupByName('CLINIC ORDERS');
  ClinIVDisp := DisplayGroupByName('CI RX');
  ClinSchDisp := DisplayGroupByName('CLINIC SCHEDULING');
  NurDisp := DisplayGroupByName('NURS');
  CsltDisp := DisplayGroupByName('CSLT');
  ProcDisp := DisplayGroupByName('PROC');
  ImgDisp := DisplayGroupByName('XRAY');
  DietDisp := DisplayGroupByName('DO');
  NonVADisp := DisplayGroupByName('NV RX');
  LabDisp := DisplayGroupByName('LAB');
  ClinMedsDlgIen := DlgIENForName('PSJ OR CLINIC OE');
  ClinIVDlgIen := DlgIENForName('CLINIC OR PAT FLUID OE');
  MedsInDlgIen := DlgIENForName('PSJ OR PAT OE');
  MedsOutDlgIen := DlgIENForName('PSO OERR');
  MedsNVADlgIen := DlgIENForName('PSH OERR');
  MedsIVDlgIen := DlgIENForName('PSJI OR PAT FLUID OE');
  MedsInDlgFormId := FormIDForDialog(MedsInDlgIen);
  MedsOutDlgFormId := FormIDForDialog(MedsOutDlgIen);
  MedsNVADlgFormID := FormIDForDialog(MedsNVADlgIen);
  MedsIVDlgFormID := FormIDForDialog(MedsIVDlgIen);
  ClinIVDlgFormID := FormIDForDialog(ClinIVDlgIen);
  If WriteAccess(waOrders) then
    WriteAccessV.InitCPRSDisplayGroups;
end;

function canWriteOrder(obj: TWriteAccess.TDGWriteAccess; Action: TActionType;
  ShowError: Boolean = False; ErrorText: String = '';
  RequireChildAccess: Boolean = False): Boolean; overload;
begin
  Result := WriteAccessV.OrderAccess(obj, Action, ShowError, ErrorText, RequireChildAccess);
end;

function canWriteOrder(DGIEN: Integer): Boolean; overload;
begin
  Result := canWriteOrder(WriteAccessV.DGWriteAccess(DGIEN), atNone);
end;

function canWriteOrder(DGIEN: Integer; DGName: String;
  Action: String; ShowError: Boolean = False; ErrorText: String = '';
  RequireChildAccess: Boolean = False): Boolean; overload;
var
  obj: TWriteAccess.TDGWriteAccess;

begin
  if DGIEN > 0 then
    obj := WriteAccessV.DGWriteAccess(DGIEN)
  else
    obj := WriteAccessV.DGWriteAccess(DGName);
  Result := canWriteOrder(obj, WriteAccessV.ActionType(Action), ShowError, ErrorText,
    RequireChildAccess);
end;

function canWriteOrder(DGIEN: Integer; DGName: String;
  Action: TActionType; ShowError: Boolean = False; ErrorText: String = '';
  RequireChildAccess: Boolean = False): Boolean; overload;
var
  obj: TWriteAccess.TDGWriteAccess;

begin
  if DGIEN > 0 then
    obj := WriteAccessV.DGWriteAccess(DGIEN)
  else
    obj := WriteAccessV.DGWriteAccess(DGName);
  Result := canWriteOrder(obj, Action, ShowError, ErrorText,
    RequireChildAccess);
end;

function canWriteOrder(ResolvedDialog: TOrderDialogResolved): Boolean; overload;
const
  ChildDialogs: array of Integer = [OD_IMAGING, OD_DIET, OD_LAB, OD_AP];
var
  i: integer;
  NeedChildren: Boolean;
begin
  NeedChildren := False;
  for i := low(ChildDialogs) to high(ChildDialogs) do
    if ResolvedDialog.FormID = ChildDialogs[i] then
    begin
      NeedChildren := True;
      break;
    end;
  Result := canWriteOrder(WriteAccessV.DGWriteAccess(ResolvedDialog.DisplayGroup),
    atWrite, True, '', NeedChildren);
end;

function canWriteOrder(AnOrder: TOrder; Action: TActionType): boolean; overload;
begin
  Result := canWriteOrder(WriteAccessV.DGWriteAccess(AnOrder.DGroup), Action,
    True, AnOrder.Text);
end;

function canWriteOrder(AnOrder: TOrder; Action: string): Boolean; overload;
begin
  Result := canWriteOrder(AnOrder.DGroup, '', Action, True, AnOrder.Text);
end;

function canWriteOrder(id, DisplayGroupName: string; Action: TActionType): Boolean; overload;
begin
  Result := canWriteOrder(WriteAccessV.DGWriteAccess(DisplayGroupName), Action,
   True, RetrieveOrderText(id));
end;

function GMRCCanCloseDialog(dialog: TfrmODBase): Boolean;
begin
  // wat-added 'GMRC' to name to show only applies to GMRC order dialogs
  // other dialogs could be added in the future as needed w/name updated accordingly
  Result := True;
  if uOrderDialog.FillerID = 'GMRC' then
    Result := fODConsult.CanFreeConsultDialog(dialog) or
      fODProc.CanFreeProcDialog(dialog);
end;

function IsValidActionOnComplexOrder(AnOrderID, AnAction: string;
  AListBox: TListBox; var CheckedList: TStringList; var ErrMsg: string;
  var ParentOrderID: string): Boolean; // PSI-COMPLEX
const
  COMPLEX_SIGN =
    'You have requested to sign a medication order which was entered as part of a complex order.'
    + 'The following are the orders associated with the same complex order.';
  COMPLEX_SIGN1 = ' Do you want to sign all of these orders?';

  COMPLEX_DC =
    'You have requested to discontinue a medication order which was entered as part of a complex order.'
    + ' The following are all of the associated orders.';
  COMPLEX_DC1 = ' Do you want to discontinue all of them?';

  COMPLEX_HD =
    'You have requested to hold a medication order which was entered as part of a complex order.'
    + ' The following are all of the associated orders.';
  COMPLEX_HD1 = ' Do you want to hold all of them?';

  COMPLEX_UNHD =
    'You have requested to release the hold of a medication order which was entered as part of a complex order.'
    + ' The following are all of the associated orders.';
  COMPLEX_UNHD1 = ' Do you want to release all of them?';

  COMPLEX_RENEW =
    'You can not take the renew action on a complex medication which has the following associated orders.';
  COMPLEX_RENEW1 = ' You must enter a new order.';

  COMPLEX_VERIFY =
    'You have requested to verify a medication order which was entered as part of a complex order.'
    + ' The following are all of the associated orders.';
  COMPLEX_VERIFY1 = ' Do you want to verify all of them?';

  COMPLEX_OTHER =
    'You can not take this action on a complex medication which has the following associated orders.'
    + ' You must enter a new order.';

  COMPLEX_CANRENEW1 = 'The selected order for renew: ';
  COMPLEX_CANRENEW2 = ' is a part of a complex order.';
  COMPLEX_CANRENEW3 = 'The following whole complex order will be renewed.';
var
  CurrentActID, POrderTxt, AChildOrderTxt, CplxOrderMsg: string;
  ChildList, ChildIdxList, ChildTxtList, CategoryList: TStringList;
  ShowCancelButton: Boolean;
  procedure RetrieveOrderTextPSI(AOrderList: TStringList;
    var AODTextList, AnIdxList: TStringList; TheAction: string;
    AParentID: string = '');
  var
    ix, jx: Integer;
    tempid: string;
  begin
    for ix := 0 to AOrderList.Count - 1 do
    begin
      if AListBox.Name = 'lstOrders' then
        with AListBox do
        begin
          for jx := 0 to Items.Count - 1 do
            if TOrder(Items.Objects[jx]).ID = AOrderList[ix] then
            begin
              TOrder(Items.Objects[jx]).ParentID := AParentID;
              if CategoryList.IndexOf(TheAction) > -1 then
                Selected[jx] := True;
              AODTextList.Add(TOrder(Items.Objects[jx]).ID + '^' +
                TOrder(Items.Objects[jx]).Text);
              if AnIdxList.IndexOf(IntToStr(jx)) > -1 then
                continue;
              AnIdxList.Add(IntToStr(jx));
            end;
        end
      else if (AListBox.Name = 'lstMedsOut') or (AListBox.Name = 'lstMedsIn') or
        (AListBox.Name = 'lstMedsNonVA') then
        with AListBox do
        begin
          for jx := 0 to Items.Count - 1 do
          begin
            tempid := TMedListRec(AListBox.Items.Objects[jx]).OrderID;
            if tempid = AOrderList[ix] then
            begin
              if CategoryList.IndexOf(TheAction) > -1 then
                Selected[jx] := True;
              AODTextList.Add(tempid + '^' + Items[jx]);
              AnIdxList.Add(IntToStr(jx));
            end;
          end;
        end;
    end;
  end;

  procedure DeselectChild(AnIdxList: TStringList);
  var
    dix: Integer;
  begin
    for dix := 0 to AnIdxList.Count - 1 do
    begin
      try
        if StrToInt(AnIdxList[dix]) < AListBox.Items.Count then
          AListBox.Selected[StrToInt(AnIdxList[dix])] := False;
      except
        // do nothing
      end;
    end;
  end;

  function MakeMessage(ErrMsg1, ErrMsg2, ErrMsg3: string): string;
  begin
    if Length(ErrMsg1) > 0 then
      Result := ErrMsg1 + ErrMsg2
    else
      Result := ErrMsg2 + ErrMsg3;
  end;

begin
  Result := True;
  if AnAction = OA_COPY then
    Exit;
  CurrentActID := Piece(AnOrderID, ';', 2);
  CplxOrderMsg := '';
  CategoryList := TStringList.Create;
  CategoryList.Add('DC');
  CategoryList.Add('HD');
  CategoryList.Add('RL');
  CategoryList.Add('VR');
  CategoryList.Add('ES');
  ShowCancelButton := False;

  if Length(ErrMsg) > 0 then
    ErrMsg := ErrMsg + #13#13;
  ValidateComplexOrderAct(AnOrderID, CplxOrderMsg);
  if Pos('COMPLEX-PSI', CplxOrderMsg) > 0 then
  begin
    ParentOrderID := Piece(CplxOrderMsg, '^', 2);
    if CheckedList.IndexOf(ParentOrderID) >= 0 then
    begin
      ErrMsg := '';
      Exit;
    end;
    if CheckedList.Count = 0 then
      CheckedList.Add(ParentOrderID)
    else
    begin
      if CheckedList.IndexOf(ParentOrderID) < 0 then
        CheckedList.Add(ParentOrderID);
    end;
    ChildList := TStringList.Create;
    GetChildrenOfComplexOrder(ParentOrderID, CurrentActID, ChildList);
    ChildTxtList := TStringList.Create;
    ChildIdxList := TStringList.Create;
    RetrieveOrderTextPSI(ChildList, ChildTxtList, ChildIdxList, AnAction,
      ParentOrderID);
    if ChildTxtList.Count > 0 then
    begin
      if (AnAction = 'RN') or (AnAction = 'EV') then
      begin
        if not IsValidSchedule(ParentOrderID) then
        begin
          POrderTxt := RetrieveOrderText(ParentOrderID);
          if CharAt(POrderTxt, 1) = '+' then
            POrderTxt := Copy(POrderTxt, 2, Length(POrderTxt));
          if Pos('First Dose NOW', POrderTxt) > 1 then
            Delete(POrderTxt, Pos('First Dose NOW', POrderTxt),
              Length('First Dose Now'));
          InfoBox('Invalid schedule!' + #13#13 +
            'The selected order is a part of a complex order:' + #13 + POrderTxt
            + #13#13 + ' It contains an invalid schedule.', 'Warning',
            MB_OK or MB_ICONWARNING);
          DeselectChild(ChildIdxList);
          Result := False;
          ErrMsg := '';
          ChildTxtList.Free;
          ChildList.Clear;
          ChildList.Free;
          CategoryList.Clear;
          Exit;
        end;
      end;
      if AnAction = OA_DC then
      begin
        if not ActionOnComplexOrder(ChildTxtList,
          MakeMessage(ErrMsg, COMPLEX_DC, COMPLEX_DC1), True) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_SIGN then
      begin
        if not ActionOnComplexOrder(ChildTxtList,
          MakeMessage(ErrMsg, COMPLEX_SIGN, COMPLEX_SIGN1), True) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_HOLD then
      begin
        if Length(ErrMsg) < 1 then
          ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildTxtList,
          MakeMessage(ErrMsg, COMPLEX_HD, COMPLEX_HD1), ShowCancelButton) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_UNHOLD then
      begin
        if Length(ErrMsg) < 1 then
          ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildTxtList,
          MakeMessage(ErrMsg, COMPLEX_UNHD, COMPLEX_UNHD1), ShowCancelButton)
        then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_VERIFY then
      begin
        if Length(ErrMsg) < 1 then
          ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildTxtList,
          MakeMessage(ErrMsg, COMPLEX_VERIFY, COMPLEX_VERIFY1), ShowCancelButton)
        then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_RENEW then
      begin
        if not IsRenewableComplexOrder(ParentOrderID) then
        begin
          if not ActionOnComplexOrder(ChildTxtList,
            MakeMessage(ErrMsg, COMPLEX_RENEW, COMPLEX_RENEW1), False) then
          begin
            DeselectChild(ChildIdxList);
            Result := False;
          end;
        end
        else
        begin
          POrderTxt := RetrieveOrderText(ParentOrderID);
          if CharAt(POrderTxt, 1) = '+' then
            POrderTxt := Copy(POrderTxt, 2, Length(POrderTxt));
          if Pos('First Dose NOW', POrderTxt) > 1 then
            Delete(POrderTxt, Pos('First Dose NOW', POrderTxt),
              Length('First Dose Now'));
          AChildOrderTxt := RetrieveOrderText(AnOrderID);
          if InfoBox(COMPLEX_CANRENEW1 + #13 + AChildOrderTxt +
            COMPLEX_CANRENEW2 + #13#13 + COMPLEX_CANRENEW3 + #13 + POrderTxt,
            'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
          begin
            if AListBox.Name = 'lstOrders' then
              frmOrders.ParentComplexOrderID := ParentOrderID;
            if (AListBox.Name = 'lstMedsOut') or (AListBox.Name = 'lstMedsIn')
            then
              frmMeds.ParentComplexOrderID := ParentOrderID;
          end;
          DeselectChild(ChildIdxList);
        end;
      end;
    end;
    ErrMsg := '';
    ChildTxtList.Free;
    ChildList.Clear;
    ChildList.Free;
  end;
  CategoryList.Clear;
end;

{ Write New Orders }

function ActivateAction(const AnID: string; AnOwner: TComponent;
  ARefNum: Integer): Boolean;
// AnID: DlgIEN {;FormID;DGroup}
type
  TDialogClass = class of TfrmOMAction;
var
  DialogClass: TDialogClass;
  AFormID: Integer;
begin
  Result := False;
  AFormID := FormIDForDialog(StrToIntDef(Piece(AnID, ';', 1), 0));
  if AFormID > 0 then
  begin
    case AFormID of
      OM_ALLERGY:
        if ARTPatchInstalled then
        begin
          // DialogClass := TfrmARTAllergy;
          EnterEditAllergy(0, True, False, AnOwner, ARefNum);
          Result := True;
          // uOrderMenu.Close;
          Exit;
        end
        else
        begin
          Result := False;
          Exit;
        end;
      OM_HTML:
        DialogClass := TfrmOMHTML;
      999999:
        DialogClass := TfrmOMAction; // for testing!!!
    else
      Exit;
    end;
    if AnOwner = nil then
      AnOwner := Application;
    uOrderAction := DialogClass.Create(AnOwner);
    if (uOrderAction <> nil) (* and (not uOrderAction.AbortAction) *) then
    begin
      uOrderAction.CallOnExit := DestroyingOrderAction;
      uOrderAction.RefNum := ARefNum;
      uOrderAction.OrderDialog := StrToIntDef(Piece(AnID, ';', 1), 0);
      Result := True;
      if (not uOrderAction.AbortAction) then
        uOrderAction.ShowModal;
    end;
  end
  else
  begin
    // Show508Message('Order Dialogs of type "Action" are available in List Manager only.');
    Result := False;
  end;
end;

procedure BuildResponseVarsForOutpatient(AResponses: TObject; var AUnits,
  ASchedule, ADuration, ADrug: String; NoPRN: boolean);
var
  i, p: integer;
  Responses: TResponsesAdapter;
  NewAdapter, InsideAnd: Boolean;
  X, DayText, LastDayText: string;

begin
  AUnits := '';
  ASchedule := '';
  ADuration := '';
  ADrug := '';
  InsideAnd := False;
  LastDayText := '';

  NewAdapter := not (AResponses is TResponsesAdapter);
  if NewAdapter then
    Responses := TResponsesAdapter.Create
  else
    Responses := TResponsesAdapter(AResponses);
  try
    if NewAdapter then
      Responses.Assign(AResponses);
    i := Responses.NextInstance('DOSE', 0);
    while i > 0 do
    begin
      X := Responses.IValueFor('DOSE', i);
      X := Piece(X, '&', 3);
      AUnits := AUnits + X + U;
      X := Responses.IValueFor('SCHEDULE', i);
      if NoPRN then
      begin
        repeat
          p := pos('PRN',X);
          if p > 0 then
          begin
            delete(X, p, 3);
            x := Trim(x);
          end;
        until (p = 0);
      end;
      ASchedule := ASchedule + X + U;
      X := Responses.IValueFor('DAYS', i);
      if (X = '') and InsideAnd then
        X := LastDayText;
      DayText := X;
      ADuration := ADuration + X + '~';
      X := Responses.IValueFor('CONJ', i);
      ADuration := ADuration + X + U;
      InsideAnd := (X = 'A');
      if not InsideAnd then
        LastDayText := ''
      else if (DayText <> '') then
        LastDayText := DayText;
      X := Responses.IValueFor('DRUG', i);
      ADrug := ADrug + X + U;
      i := Responses.NextInstance('DOSE', i);
    end;
  finally
    if NewAdapter then
      Responses.Free
  end;
end;

var
  Activating: boolean = false;

function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent;
  const AnOwner: TComponent; const ARefNum: Integer;
  const ANeedVerify: Boolean = True; const ForceEdit: Boolean = False): Boolean;
const
  TX_DEAFAIL1 = 'Order for controlled substance,' + CRLF;
  TX_DEAFAIL2 = CRLF + 'could not be completed. Provider does not have a' + CRLF
    + 'current, valid DEA# on record and is ineligible' + CRLF +
    'to sign the order.';
  TX_SCHFAIL = CRLF + 'could not be completed. Provider is not authorized' +
    CRLF + 'to prescribe medications in Federal Schedule ';
  TX_SCH_ONE = CRLF +
    'could not be completed. Electronic prescription of medications in' + CRLF +
    'Federal Schedule 1 is prohibited.' + CRLF + CRLF +
    'Valid Schedule 1 investigational medications require paper prescription.';
  TX_NO_DETOX = CRLF + 'could not be completed. Provider does not have a' + CRLF
    + 'valid Detoxification/Maintenance ID number on' + CRLF +
    'record and is ineligible to sign the order.';
  TX_EXP_DETOX1 = CRLF +
    'could not be completed. Provider''s Detoxification/Maintenance' + CRLF +
    'ID number expired due to an expired DEA# on ';
  TX_EXP_DETOX2 = '.' + CRLF + 'Provider is ineligible to sign the order.';
  TX_EXP_DEA1 = CRLF + 'could not be completed. Provider''s DEA# expired on ';
  TX_EXP_DEA2 = CRLF +
    'and no VA# is assigned. Provider is ineligible to sign the order.';
  TX_INSTRUCT = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF +
    'Click CANCEL to cancel the current order.';
  TC_DEAFAIL = 'Order not completed';
  TC_IMO_ERROR = 'Unable to order';
//    'Inpatient medication order on outpatient authorization required';
  TX_EVTDEL_DIET_CONFLICT = 'Have you done either of the above?';
  TC_EVTDEL_DIET_CONFLICT = 'Possible delayed order conflict';
  TX_INACTIVE_SVC =
    'This consult service is currently inactive and not receiving requests.' +
    CRLF + 'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TX_INACTIVE_SVC_CAP = 'Inactive Service';
  TX_NO_SVC =
    'The order or quick order you have selected does not specify a consult service.'
    + CRLF + 'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TC_NO_SVC = 'No service specified';
  TX_CLIN_NEEDED =
    'For this type of order a clinic location must be selected. You may also want to choose a current date and time (not older than 24 hours).  Would you like to continue?';
  TX_NO_CLIN_SELECTED =
    'A clinic location was not selected. Switching back to original location and aborting order process.';
  TX_PAST_DATE_SELECTED =
    'You currently have a past date selected for this visit. Do you want to select a current date?';
  TX_NOT_VALID_IMO =
    'You have selected a location that has not been designated for Clinic Medications; this medication may not be ordered for the current location. Please contact Pharmacy Service if you feel that this is not correct.';
var
  ResolvedDialog: TOrderDialogResolved;
  x, EditedOrder, chkCopay, OrderID, PkgInfo, OrderPtEvtID, OrderEvtID, NssErr,
    tempUnit, tempSupply, tempDrug, tempSch: string;
  temp, tempDur, tempQuantity, tempRefills: string;
  i, p, ODItem, tempOI, ALTOI, rLevel, tmpDialogIEN, tmpDisplayGroup: Integer;
  DrugCheck, InptDlg, IsAnIMOOrder, DrugTestDlgType, ShowClinOrdMsg: Boolean;
  IsRadiology, // VISTAOR-23041
  IsPsoSupply, IsDischargeOrPass, IsPharmacyOrder, IsConsultOrder, ForIMO,
    IsNewOrder, Titration: Boolean;
  isRTCOrder, EditAutoAcceptOrder: Boolean;
  tmpResp: TResponse;
  CxMsg: string;
  AButton: TButton;
  SvcIEN: string;
  // CsltFrmID: integer;
  FirstNumericPos: Integer;
  DEAFailStr, TX_INFO: string;
  ClinicLocationMsg, toDisplayGroup: string;
  tmpOrder: TOrder;
  OriginalEvent: TOrderDelayEvent;

  function GetClinicLocation(): Boolean;
  // returning true means clinic location not selected or it was cancelled
  var
    yesterday: TDateTime;
    // chooseCurrentDate : boolean;
  begin
    // init
    rLevel := rLevel + 1;
    Result := False;
    yesterday := subtractMinutesFromDateTime(date(), 1440);

    // get a clinic location otherwise return true
    if (LocationType(Encounter.Location) = 'W') or (Encounter.NeedVisit) then
    begin
      if InfoBox(TX_CLIN_NEEDED, TC_PROV_LOC, MB_YESNO or MB_DEFBUTTON2 or
        MB_ICONQUESTION) = IDYES then
      begin
        if rLevel = 1 then
          Encounter.CreateSaved
            ('Switching back to location prior to Clinic Medications session');
        UpdateVisit((AnOwner as TForm).Font.Size, DfltTIULocation);
        if Encounter.NeedVisit then
        begin
          Result := True;
          Exit;
        end
        else if (LocationType(Encounter.Location) = 'W') then
        begin
          InfoBox(TX_NO_CLIN_SELECTED, TC_PROV_LOC, MB_OK or MB_ICONWARNING);
          Encounter.SwitchToSaved(False);
          Result := True;
          Exit;
        end;
      end
      else
      begin
        Result := True;
        Exit;
      end;
    end;
    // check if location is marked for clinic orders
    if not(IsValidIMOLoc(Encounter.Location, Patient.DFN)) then
    begin
      InfoBox(TX_NOT_VALID_IMO, TC_PROV_LOC, MB_OK or MB_ICONWARNING);
      Encounter.SwitchToSaved(False);
      Result := True;
      Exit;
    end;

    // try to get a current date but don't force it
    if comparedate(FMDateTimeToDateTime(Encounter.DateTime), yesterday) <= 0
    then
    begin
      if InfoBox(TX_PAST_DATE_SELECTED, TC_PROV_LOC,
        MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION) = IDYES then
      begin
        UpdateVisit((AnOwner as TForm).Font.Size, DfltTIULocation);
        Result := GetClinicLocation();
      end
      else
      begin
        InfoBox(TX_PAST_DATE, 'Clinic Order', MB_OK or MB_ICONWARNING);
        // If past date selected, ask If this medication has been already administered by the clinician, then go to the One Step Clinic Med Admin option.
        // OR If you are a nurse and need to document a clinic medication that has been previously administered greater than 23 hours in the past,
        // you need to go to BCMA.�
      end;

    end;
  end;

  function IsCheckForAllergyOK: Boolean;
  begin
    Result := True;
    if (ResolvedDialog.DialogType = 'Q') and
      Assigned(uOrderDialog) and (uOrderDialog is TfrmODMeds) then
      Result := TfrmODMeds(uOrderDialog).IsAllergyCheckOK(
        TfrmODMeds(uOrderDialog).txtMed.Tag);
  end;

begin
  Result := False;
  if Activating then
    Exit;
  Activating := True;
  try
  OriginalEvent := AnEvent;
  rLevel := 0;
  IsPsoSupply := False;
  IsDischargeOrPass := False;
  IsAnIMOOrder := False;
  ForIMO := False;
  IsNewOrder := True;
  PassDrugTstCall := False;
  DrugCheck := False;
  DrugTestDlgType := False;
  InptDlg := False;
  // We need to get the first numeric postion
  for FirstNumericPos := 1 to Length(AnID) do
  begin
    if CharInSet(AnID[FirstNumericPos], ['0' .. '9']) then
      break;
  end;

  if uOrderDialog <> nil then
    uOrderDialog.Close;

  TResponsiveGUI.ProcessMessages(False, True); // Important - call should be after Close statement above
                                  // or can cause duplicate order dialogs at the same time
  if (uOrderDialog <> nil) then
  begin
    uOrderDialog.BringToFront;
    Exit;
  end;

  if CharAt(AnID, 1) = 'X' then
  begin
    IsNewOrder := False;
    // if PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E')=false then Exit;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_CHANGE, x);
    if (Length(x) < 1) and not(AnEvent.EventIFN > 0) then
      ValidateComplexOrderAct(Copy(AnID, 2, Length(AnID)), x);
    if (Pos('COMPLEX-PSI', x) > 0) then
      x := TX_COMPLEX;
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_CHANGE) then
      Exit;
    DrugCheck := True;
  end;
  if CharAt(AnID, 1) = 'C' then
  begin
    tmpOrder := getOrderByIFN(copy(AnId, 2, MaxInt));
    try
    if not canWriteOrder(tmpOrder, atCopy) then
      exit;
    finally
      tmpOrder.Free;
    end;
    IsNewOrder := False;
    // if PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E')=false then Exit;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_COPY, x);
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_COPY) then
      Exit;

    DrugCheck := True;
  end;
  if CharAt(AnID, 1) = 'T' then
  begin
    IsNewOrder := False;
    if (XfInToOutNow = True) and
      (PassDrugTest(StrToInt(Copy(AnID, FirstNumericPos,
      (Pos(';', AnID) - FirstNumericPos))), 'E', False) = False) then
      Exit;
    if (XfInToOutNow = False) then
    begin
      if (XferOutToInOnMeds = True) and
        (PassDrugTest(StrToInt(Copy(AnID, FirstNumericPos,
        (Pos(';', AnID) - FirstNumericPos))), 'E', True) = False) then
        Exit;
      if (XferOutToInOnMeds = False) and
        (PassDrugTest(StrToInt(Copy(AnID, FirstNumericPos,
        (Pos(';', AnID) - FirstNumericPos))), 'E', False) = False) then
        Exit;
      if XferOutToInOnMeds then
            toDisplayGroup := 'UNIT DOSE MEDICATIONS'
        else if XfInToOutNow then
          toDisplayGroup := 'OUTPATIENT MEDICATIONS'
        else if (AnEvent.EventType = 'D') then
          toDisplayGroup := 'OUTPATIENT MEDICATIONS'
        else if (AnEvent.EventType <> 'D') then
            toDisplayGroup := 'UNIT DOSE MEDICATIONS'
        else toDisplayGroup := '';
        if (toDisplayGroup <> '') and
          (not canWriteOrder(Copy(AnID, 2, Length(AnID)), toDisplayGroup, atTransfer)) then
          Exit;
    end;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_TRANSFER, x);
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_XFER) then
      Exit;
  end;
  if not IMOActionValidation(AnID, IsAnIMOOrder, x, AnEvent.EventType) then
  begin
    ShowMsgOn(Length(x) > 0, x, TC_IMO_ERROR);
    Exit;
  end;
  if ((StrToIntDef(AnID, 0) > 0) and (AnEvent.EventIFN <= 0)) then
    ForIMO := IsIMODialog(StrToInt(AnID))
  else if ((IsAnIMOOrder) and (AnEvent.EventIFN <= 0)) then
    ForIMO := True;
  OrderPtEvtID := GetOrderPtEvtID(Copy(AnID, 2, Length(AnID)));
  OrderEvtID := Piece(EventInfo(OrderPtEvtID), '^', 2);
  // CQ 18660 Orders for events should be modal. Orders for non-event should not be modal
  if AnEvent.EventIFN > 0 then
    frmOrders.NeedShowModal := True
  else
    frmOrders.NeedShowModal := False;
  // evaluate order dialog, build response list & see what form should be presented
  FillChar(ResolvedDialog, SizeOf(ResolvedDialog), #0);
  ResolvedDialog.InputID := AnID;
  BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
  if ForceEdit then
    ResolvedDialog.QuickLevel := QL_DIALOG;
  if (ResolvedDialog.DisplayGroup = InptDisp) or
    (ResolvedDialog.DisplayGroup = ClinDisp) then
    DrugTestDlgType := True;
  if (DrugCheck = True) and (ResolvedDialog.DisplayGroup = OutptDisp) and
    (PassDrugTest(StrToInt(Copy(AnID, FirstNumericPos,
    (Pos(';', AnID) - FirstNumericPos))), 'E', False) = False) then
    Exit;
  if (DrugCheck = True) and (DrugTestDlgType = True) and
    (PassDrugTest(StrToInt(Copy(AnID, FirstNumericPos,
    (Pos(';', AnID) - FirstNumericPos))), 'E', True) = False) then
    Exit;
  if (IsNewOrder = True) and (ResolvedDialog.DialogType = 'Q') and
    ((ResolvedDialog.DisplayGroup = OutptDisp) or (DrugTestDlgType = True)) then
  begin
    if (PassDrugTest(ResolvedDialog.DialogIEN, 'Q', DrugTestDlgType) = False)
    then
      Exit
    else
      PassDrugTstCall := True;
  end;

  tmpDialogIEN := ResolvedDialog.DialogIEN;
  tmpDisplayGroup := ResolvedDialog.DisplayGroup;

  // clinic medication logic
  if (AnEvent.EventType = 'C') and not(LocationType(Encounter.Location) = '')
    and IsValidIMOLoc(Encounter.Location, Patient.DFN) then
  begin
    if ((ResolvedDialog.DialogIEN = MedsInDlgIen) and
      (not(Patient.Inpatient) or not(LocationType(Encounter.Location) = 'W')))
    then
    begin
      if (ResolvedDialog.DialogType = 'C') or (ResolvedDialog.DialogType = 'X')
      then
        ResolvedDialog.FormID := OD_CLINICMED
      else
      begin
        // change dialog to the clinic orders dialog
        ResolvedDialog.InputID := IntToStr(ClinMedsDlgIen);
        ResolvedDialog.DisplayGroup := ClinDisp;
        BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
      end;
    end
    else if ((ResolvedDialog.DialogIEN = MedsIVDlgIen) and
      (not(Patient.Inpatient) or not(LocationType(Encounter.Location) = 'W')))
    then
    begin
      if (ResolvedDialog.DialogType = 'C') or (ResolvedDialog.DialogType = 'X')
      then
        ResolvedDialog.FormID := OD_CLINICINF
      else
      begin
        // change dialog to the clinic infusions dialog
        ResolvedDialog.InputID := IntToStr(ClinIVDlgIen);
        ResolvedDialog.DisplayGroup := ClinIVDisp;
        BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
      end;
    end
    else if ((ResolvedDialog.DisplayGroup = InptDisp) and
      (not(Patient.Inpatient) or not(LocationType(Encounter.Location) = 'W')))
    then
    begin
      if (ResolvedDialog.DialogType = 'C') or (ResolvedDialog.DialogType = 'X')
      then
        ResolvedDialog.FormID := OD_CLINICMED
      else
      begin
        BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
        ResolvedDialog.DisplayGroup := ClinDisp;
        ResolvedDialog.FormID := OD_CLINICMED;
      end;
    end
    else if ((ResolvedDialog.DisplayGroup = IVDisp) and
      (not(Patient.Inpatient) or not(LocationType(Encounter.Location) = 'W')))
    then
    begin
      if (ResolvedDialog.DialogType = 'C') or (ResolvedDialog.DialogType = 'X')
      then
        ResolvedDialog.FormID := OD_CLINICINF
      else
      begin
        BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
        ResolvedDialog.DisplayGroup := ClinIVDisp;
        ResolvedDialog.FormID := OD_CLINICINF;
      end;
    end
    else
  end;
  ClinicLocationMsg := 'You are about to enter a Clinic ';
  if (ResolvedDialog.DialogIEN = ClinMedsDlgIen) or
    (ResolvedDialog.DialogIEN = MedsInDlgIen) or
    (ResolvedDialog.FormID = OD_CLINICMED) then
  begin
    ClinicLocationMsg := ClinicLocationMsg + 'Medication';
  end
  else if (ResolvedDialog.DialogIEN = ClinIVDlgIen) or
    (ResolvedDialog.DialogIEN = MedsIVDlgIen) or
    (ResolvedDialog.FormID = OD_CLINICINF) then
  begin
    ClinicLocationMsg := ClinicLocationMsg + 'Infusion';
  end;
  ClinicLocationMsg := ClinicLocationMsg +
    ' order.  Are you sure this is what you want to do?';

  ResetDialogProperties(AnID, AnEvent, ResolvedDialog);
  if not canWriteOrder(ResolvedDialog) then exit;

  if ((ResolvedDialog.DisplayGroup = ClinDisp) or
    (ResolvedDialog.DisplayGroup = ClinIVDisp)) then
  begin
    if not(AnEvent.EventType = 'C') then
    begin
      InfoBox(TX_CLDELAYED, 'Clinic Medication', MB_OK or MB_ICONWARNING);
      Exit;
    end;

    ShowClinOrdMsg := True;
    if not(Patient.Inpatient) and ((tmpDialogIEN = ClinMedsDlgIen) or
      (tmpDialogIEN = ClinIVDlgIen) or (tmpDisplayGroup = ClinDisp) or
      (tmpDisplayGroup = ClinIVDisp)) then
      ShowClinOrdMsg := False;

    if ((uOrderSet = nil) or (not(uOrderSet = nil) and not(uOrderSetClinMedMsg))
      ) and ShowClinOrdMsg then
    begin
      uOrderSetClinMedMsg := True;
      if ((InfoBox(ClinicLocationMsg, 'Clinic Location',
        MB_YESNO or MB_DEFBUTTON1 or MB_ICONQUESTION) = ID_NO)) then
      begin
        uOrderSetClinMedMsg := False;
        Exit;
      end;
    end;

    // if GetClinicLocation() returns true then cancel the order process
    if GetClinicLocation() then
      Exit;
  end;

  if (ResolvedDialog.DisplayGroup = InptDisp) or
    (ResolvedDialog.DisplayGroup = OutptDisp) or
    (ResolvedDialog.DisplayGroup = MedsDisp) or
    (ResolvedDialog.DisplayGroup = IVDisp) or
    (ResolvedDialog.DisplayGroup = NonVADisp) or
    (ResolvedDialog.DisplayGroup = ClinIVDisp) or
    (ResolvedDialog.DisplayGroup = ClinDisp) then
    IsPharmacyOrder := True
  else
    IsPharmacyOrder := False;
  (* IsPharmacyOrder := ResolvedDialog.DisplayGroup in [InptDisp, OutptDisp,
    MedsDisp,IVDisp, NonVADisp, ClinDisp]; *)   // v25.27 range check error - RV
  IsConsultOrder := ResolvedDialog.DisplayGroup in [CsltDisp, ProcDisp];
  IsRTCOrder := (ResolvedDialog.DisplayGroup = ClinSchDisp) and (ResolvedDialog.FormID = OD_RTC);
  // VISTAOR-23041
  IsRadiology := (ResolvedDialog.DisplayGroup = ImgDisp) and (ResolvedDialog.FormID = OD_IMAGING);
  if (uAutoAC) and (not (ResolvedDialog.QuickLevel in [QL_REJECT,QL_CANCEL]))
    and (not IsPharmacyOrder) and (not IsConsultOrder) and (not IsRTCOrder)
    and (not IsRadiology) // VISTAOR-23041
    then
    ResolvedDialog.QuickLevel := QL_AUTO;
  if (ResolvedDialog.DialogType = 'Q') and
    (ResolvedDialog.DisplayGroup = InptDisp) then
  begin
    NssErr := IsValidQOSch(ResolvedDialog.InputID);
    if (Length(NssErr) > 1) then
    begin
      if (NssErr <> 'OTHER') and (NssErr <> 'schedule is not defined.') then
        ShowMsg('The order contains invalid non-standard schedule.');
      NSSchedule := True;
      ResolvedDialog.QuickLevel := 0;
    end;
  end;
  if ResolvedDialog.DisplayGroup = InptDisp then // nss
  begin
    if (CharAt(AnID, 1) = 'C') or (CharAt(AnID, 1) = 'T') or
      (CharAt(AnID, 1) = 'X') then
    begin
      if not IsValidSchedule(Copy(AnID, 2, Length(AnID))) then
      begin
        ShowMsg('The order contains invalid non-standard schedule.');
        NSSchedule := True;
      end;
    end;
    if NSSchedule then
      ResolvedDialog.QuickLevel := 0;
  end;
  (* if (ResolvedDialog.DialogType = 'Q') and ((ResolvedDialog.FormID = OD_MEDINPT) or (ResolvedDialog.FormID = OD_MEDOUTPT)) then
    begin
    temp := '';
    tempOI := GetQOOrderableItem(ResolvedDialog.InputID);
    if tempOI >0 then
    begin
    ALTOI := tempOI;
    CheckFormularyOI(AltOI,temp,True);
    if ALTOI <> tempOI then
    begin
    ResolvedDialog.QuickLevel := 0;
    QOAltOI.OI := ALTOI;
    end;
    end;
    end; *)
  // ((ResolvedDialog.DisplayGroup = InptDisp) or (ResolvedDialog.DisplayGroup = OutptDisp) or (ResolvedDialog.DisplayGroup = MedsDisp)) then
  // ResolvedDialog.QuickLevel := 0;
  with ResolvedDialog do
    if (QuickLevel = QL_VERIFY) and (HasTemplateField(ShowText)) then
      QuickLevel := QL_DIALOG;

  // Check for potential conflicting auto-accept delayed-release diet orders (CQ #10946 - v27.36 - RV)
  with ResolvedDialog do
    if (QuickLevel = QL_AUTO) and (DisplayGroup = DietDisp) and
      (AnEvent.EventType <> 'C') then
    begin
      AButton := TButton.Create(Application);
      try
        CheckForAutoDCDietOrders(AnEvent.EventIFN, DisplayGroup, '',
          CxMsg, AButton);
        if CxMsg <> '' then
        begin
          if InfoBox(CxMsg + CRLF + CRLF + TX_EVTDEL_DIET_CONFLICT,
            TC_EVTDEL_DIET_CONFLICT, MB_ICONWARNING or MB_YESNO) = ID_NO then
            QuickLevel := QL_DIALOG;
        end;
      finally
        AButton.Free;
      end;
    end;

  with ResolvedDialog do
  begin
    if QuickLevel = QL_REJECT then
      InfoBox(ShowText, TC_DLG_REJECT, MB_OK);
    if (QuickLevel = QL_VERIFY) and (IsPharmacyOrder or ANeedVerify) then
      ShowVerifyText(QuickLevel, ShowText, DisplayGroup = InptDisp);
    if QuickLevel = QL_AUTO then
    begin
      // CsltFrmID := FormID;
      FormID := OD_AUTOACK;
    end;
    if (QuickLevel = QL_REJECT) or (QuickLevel = QL_CANCEL) then
      Exit;
    PushKeyVars(ResolvedDialog.QOKeyVars);
  end;
  if ShowMsgOn(not(ResolvedDialog.FormID > 0), TX_NOFORM, TC_NOFORM) then
    Exit;
  with ResolvedDialog do
    if DialogType = 'X' then
    begin
      EditedOrder := Copy(Piece(ResponseID, '-', 1), 2, Length(ResponseID));
    end
    else
      EditedOrder := '';
  if XfInToOutNow then
  begin
    // if Transfer an order to outpatient and release immediately
    // then changing the Eventtype to 'C' instead of 'D'
    IsDischargeOrPass := True;
    AnEvent.EventType := 'C';
    AnEvent.Effective := 0;
  end;
  // CQ 20854 - Display Supplies Only - JCS
  SetOrderFormDlgIDOnCreate(AnID);
  uOrderDialog := CreateOrderDialog(AnOwner, ResolvedDialog.FormID, AnEvent,
    StrToIntDef(OrderEvtID, 0));
  if Not Assigned(uOrderDialog) then
  begin
    ClearOrderRecall;
    UnlockIfAble;
    Exit;
  end;

  uOrderDialog.IsSupply := IsPsoSupply;

  { For copy, change, transfer actions on an None-IMO order, the new order should not be treated as IMO order
    although the IMO criteria could be met. }
  // if (uOrderDialog.IsIMO) and (CharAt(AnID, 1) in ['X','C','T']) then
  if not uOrderDialog.IsIMO then
    uOrderDialog.IsIMO := ForIMO;

  if (ResolvedDialog.DialogType = 'Q') and
    (  // #72 Issue Tracker fix: "in" fails if one of the array members is too big
{    (ResolvedDialog.DisplayGroup
     in [MedsDisp, OutptDisp, InptDisp, ClinDisp, ClinOrdDisp, ClinIVDisp]) or  }
    (ResolvedDialog.DisplayGroup = MedsDisp) or
    (ResolvedDialog.DisplayGroup = OutptDisp) or
    (ResolvedDialog.DisplayGroup = InptDisp) or
    (ResolvedDialog.DisplayGroup = ClinDisp) or
    (ResolvedDialog.DisplayGroup = ClinOrdDisp) or
    (ResolvedDialog.DisplayGroup = ClinIVDisp) or

    (IsPSOSupplyDlg(IntTOStr(ResolvedDialog.DialogIEN),1))
    ) then
     begin
    if DoesOIPIInSigForQO(StrToInt(ResolvedDialog.InputID)) = 1 then
      uOrderDialog.IncludeOIPI := True
    else
      uOrderDialog.IncludeOIPI := False;
  end;

  if (uOrderDialog <> nil) and not uOrderDialog.Closing then
    with uOrderDialog do
    begin
      SetKeyVariables(GetKeyVars);

      if IsDischargeOrPass then
        EvtForPassDischarge := 'D'
      else
        EvtForPassDischarge := #0;

      Responses.SetEventDelay(AnEvent);
      Responses.LogTime := uOrderSetTime;
      DisplayGroup := ResolvedDialog.DisplayGroup; // used to pass ORTO
      DialogIEN := ResolvedDialog.DialogIEN; // used to pass ORIT
      RefNum := ARefNum;

      case ResolvedDialog.DialogType of
        'C':
          SetupDialog(ORDER_COPY, ResolvedDialog.ResponseID);
        'D':
          SetupDialog(ORDER_NEW, '');
        'X':
          begin
            SetupDialog(ORDER_EDIT, ResolvedDialog.ResponseID);
            OrderID := Copy(ResolvedDialog.ResponseID, 2,
              Length(ResolvedDialog.ResponseID));
            // IsInpatient := OrderForInpatient;
            ODItem := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
            PkgInfo := '';
            DEAFailStr := '';
            if Length(OrderID) > 0 then
              PkgInfo := GetPackageByOrderID(OrderID);
            if Pos('PS', PkgInfo) = 1 then
            begin
              if PkgInfo = 'PSO' then
                InptDlg := False
              else if PkgInfo = 'PSJ' then
                InptDlg := True;
              DEAFailStr := DEACheckFailed(ODItem, InptDlg);
              while (StrToIntDef(Piece(DEAFailStr, U, 1), 0) in [1 .. 6]) and
                (uOrderDialog.FillerID <> 'PSH') do
              begin
                case StrToIntDef(Piece(DEAFailStr, U, 1), 0) of
                  1:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_DEAFAIL2; // prescriber has an invalid or no DEA#
                  2:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_SCHFAIL + Piece(DEAFailStr, U, 2) + '.';
                    // prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                  3:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_NO_DETOX; // prescriber has an invalid or no Detox#
                  4:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_EXP_DEA1 + Piece(DEAFailStr, U, 2) + TX_EXP_DEA2;
                    // prescriber's DEA# expired and no VA# is assigned
                  5:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_EXP_DETOX1 + Piece(DEAFailStr, U, 2) + TX_EXP_DETOX2;
                    // valid detox#, but expired DEA#
                  6:
                    TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 +
                      TX_SCH_ONE;
                    // schedule 1's are prohibited from electronic prescription
                end;
                if StrToIntDef(Piece(DEAFailStr, U, 1), 0) = 6 then
                begin
                  InfoBox(TX_INFO, TC_DEAFAIL, MB_OK);
                  if (ResolvedDialog.DialogType = 'X') and
                    not Changes.ExistForOrder(EditedOrder) then
                    UnlockOrder(EditedOrder);
                  uOrderDialog.Close;
                  Exit;
                end;
                if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY
                then
                begin
                  DEAContext := True;
                  fFrame.frmFrame.mnuFileEncounterClick(uOrderDialog);
                  DEAFailStr := '';
                  DEAFailStr := DEACheckFailed(ODItem, InptDlg);
                end
                else
                begin
                  if (ResolvedDialog.DialogType = 'X') and
                    not Changes.ExistForOrder(EditedOrder) then
                    UnlockOrder(EditedOrder);
                  uOrderDialog.Close;
                  Exit;
                end;
              end;
            end;
          end;
        'Q':
          begin
            if IsPSOSupplyDlg(IntToStr(ResolvedDialog.DialogIEN), 1) then
              uOrderDialog.IsSupply := True;
            SetupDialog(ORDER_QUICK, ResolvedDialog.ResponseID);
            { if ((ResolvedDialog.DisplayGroup = CsltDisp)
              and (ResolvedDialog.QuickLevel = QL_AUTO)) then
              TfrmODCslt.SetupDialog(ORDER_QUICK, ResolvedDialog.ResponseID); }
            if not IsCheckForAllergyOK then
            begin
              Close;
              uOrderDialog.Destroy;
              Exit;
            end;
          end;
      end;

      if Assigned(uOrderDialog) then
        with uOrderDialog do
          begin
            if
//              not IsCheckForAllergyOK(tmpDialogIEN) or
              (AbortOrder and GMRCCanCloseDialog(uOrderDialog)) then
            begin
              Close;
              FreeAndNil(uOrderDialog); // force the order dialog to just go away
              Exit;
            end;
          end;

      if CharAt(AnID, 1) = 'T' then
      begin
        if ARefNum = -2 then
          Responses.TransferOrder := '';
        if ARefNum = -1 then
          Responses.TransferOrder := AnID;
      end;

      if CharAt(AnID, 1) = 'C' then
      /// /////////////////////////////////////////////////////////////////////
      begin
        chkCopay := Copy(AnID, 2, Length(AnID));
        // STRIP prepended C, T, or X from first position in order ID.
        SetDefaultCoPay(chkCopay);
      end;
      /// /////////////////////////////////////////////////////////////////////'

      if IsConsultOrder and (CharAt(AnID, 1) = 'C') then
      begin
        tmpResp := uOrderDialog.Responses.FindResponseByName('CODE', 1);
        if (tmpResp <> nil) then
        begin
          if IsActiveICDCode(tmpResp.EValue) then
            ResolvedDialog.QuickLevel := QL_AUTO
          else
            ResolvedDialog.QuickLevel := QL_DIALOG;
        end
        else
          ResolvedDialog.QuickLevel := QL_AUTO
      end;

      if ResolvedDialog.QuickLevel <> QL_AUTO then
      begin
        if CharInSet(CharAt(AnID, 1), ['C', 'T', 'X']) then
        begin
          Position := poScreenCenter;
          FormStyle := fsNormal;
          ShowModal;
          Result := AcceptOK;
        end
        else
        begin
          SetBounds(frmFrame.Left + 112, frmFrame.Top + frmFrame.Height -
            Height, Width, Height);
          SetFormPosition(uOrderDialog);
          FormStyle := fsStayOnTop;
          if frmOrders.NeedShowModal then
          begin
            ShowModal;
            Result := AcceptOK;
            uOrderDialog.Destroy;
            uOrderDialog := nil;
          end
          else
          begin
            Show;
            Result := True;
          end;
          if Assigned(uOrderDialog) then
            BringToFront;
        end;
      end
      else
      begin
        LockOwnerWrapper(uOrderDialog);
        try
          if uOrderDialog.DisplayGroup = OutptDisp then
          begin
            tmpResp := uOrderDialog.Responses.FindResponseByName('SUPPLY', 1);
            if tmpResp = nil then
              tempSupply := '0'
            else
              tempSupply := tmpResp.EValue;
            tmpResp := uOrderDialog.Responses.FindResponseByName('QTY', 1);
            if tmpResp = nil then
              tempQuantity := '0'
            else
              tempQuantity := tmpResp.EValue;
            tmpResp := uOrderDialog.Responses.FindResponseByName('REFILLS', 1);
            if tmpResp = nil then
              tempRefills := '0'
            else
              tempRefills := tmpResp.EValue;
            tmpResp := uOrderDialog.Responses.FindResponseByName('TITR', 1);
            if tmpResp = nil then
              Titration := False
            else
              Titration := (tmpResp.IValue = '1');
            tmpResp := uOrderDialog.Responses.FindResponseByName('ORDERABLE', 1);
            tempOI := StrToIntDef(tmpResp.IValue, 0);

            temp := uOrderDialog.Responses.OrderText;
            if StrToIntDef(tempSupply, 0) > 0 then
            begin
              p := pos('Quantity:', temp);
              if p = 0 then
                temp := temp + CRLF + 'Days Supply: ' + tempSupply
              else
                insert('Days Supply: ' + tempSupply + CRLF, temp, p);
            end;
            EditAutoAcceptOrder := False;
            BuildResponseVarsForOutpatient(uOrderDialog.Responses, tempUnit,
              tempSch, tempDur, tempDrug, True);
            if ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur,
              tempOI, StrToIntDef(tempSupply, 0), StrToIntDef(tempRefills, 0),
              tempQuantity, Titration, temp, EditAutoAcceptOrder) = False then
              Exit
            else if (not EditAutoAcceptOrder) and
              HasDaysSupplyComplexDoseConflict(uOrderDialog.Responses,
              StrToIntDef(tempSupply, 0), temp, EditAutoAcceptOrder) then
              Exit;
            if EditAutoAcceptOrder then
            begin
              Activating := False;
              Result := ActivateOrderDialog(AnID, OriginalEvent, AnOwner,
                ARefNum, ANeedVerify, True);
              Exit;
            end;
          end;
          if ((ResolvedDialog.DisplayGroup = CsltDisp) and
            (ResolvedDialog.QuickLevel = QL_AUTO)) then
          begin
            with Responses do
            begin
              Changing := True;
              tmpResp := TResponse(FindResponseByName('ORDERABLE', 1));
              if tmpResp <> nil then
                SvcIEN := GetServiceIEN(tmpResp.IValue)
              else
              begin
                InfoBox(TX_NO_SVC, TC_NO_SVC, MB_ICONERROR or MB_OK);
                // AbortOrder := True;
                // Close;
                Exit;
              end;
              if SvcIEN = '-1' then
              begin
                InfoBox(TX_INACTIVE_SVC, TX_INACTIVE_SVC_CAP, MB_OK);
                // AbortOrder := True;
                // Close;
                Exit;
              end;
            end;
          end;
          cmdAcceptClick(Application); // auto-accept order
          Result := AcceptOK;
          if (Result = True) and (ScreenReaderActive) then
            GetScreenReader.Speak('Auto Accept Quick Order ' +
              Responses.DialogDisplayName + ' placed.');

          // BAPHII 1.3.2
          // Show508Message('DEBUG: About to copy BA CI''s to copied order from Order: '+AnID+'#13'+' in uOrders.ActivateOrderDialog()');

          // End BAPHII 1.3.2

        finally
          UnlockOwnerWrapper(uOrderDialog);
        end;

        if Assigned(uOrderDialog) then
          uOrderDialog.Destroy;
      end;

    end
  else
  begin
    if assigned(uOrderDialog) then
    begin
      uOrderDialog.Release;
      uOrderDialog := nil;
    end;
    Result := False;
    // TResponsiveGUI.ProcessMessages;       // to allow dialog to finish closing
    // Exit;                              // so result is not returned true
  end;

  if NSSchedule then
    NSSchedule := False;

  if (ResolvedDialog.DialogType = 'X') and not Changes.ExistForOrder(EditedOrder)
  then
    UnlockOrder(EditedOrder);
  // QOAltOI.OI := 0;
  finally
    Activating := false;
  end;
end;

function RetrieveOrderText(AnOrderID: string): string;
var
  OrdList: TList;
  theOrder: TOrder;
  // i: integer;
begin
  // if Assigned(OrdList) then
  // begin
  // for i := 0 to pred(OrdList.Count) do
  // TObject(OrdList[i]).Free;
  // UBAGlobals.tempDxList := nil;
  // end;
  OrdList := TList.Create;
  theOrder := TOrder.Create;
  try
    theOrder.ID := AnOrderID;
    OrdList.Add(theOrder);
    RetrieveOrderFields(OrdList, 0, 0);
    Result := TOrder(OrdList.Items[0]).Text;
  finally
    theOrder.Free;
    OrdList.Free;
  end;
end;

function ActivateOrderHTML(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
var
  DialogIEN: Integer;
  x: string;
  ASetList: TStringList;
begin
  Result := False;
  DialogIEN := StrToIntDef(AnID, 0);
  x := OrderDisabledMessage(DialogIEN);
  if ShowMsgOn(Length(x) > 0, x, TC_DISABLED) then
    Exit;
  if uOrderHTML = nil then
  begin
    uOrderHTML := TfrmOMHTML.Create(AnOwner);
    with uOrderHTML do
    begin
      SetBounds(frmFrame.Left + 112, frmFrame.Top + frmFrame.Height - Height,
        Width, Height);
      SetFormPosition(uOrderHTML);
      FormStyle := fsStayOnTop;
      SetEventDelay(AnEvent);
    end;
  end;
  uOrderHTML.dialog := DialogIEN;
  uOrderHTML.RefNum := ARefNum;
  uOrderHTML.OwnedBy := AnOwner;
  uOrderHTML.ShowModal;
  ASetList := TStringList.Create;
  FastAssign(uOrderHTML.SetList, ASetList);
  uOrderHTML.Release;
  uOrderHTML := nil;
  if ASetList.Count = 0 then
    Exit;
  Result := ActivateOrderList(ASetList, AnEvent, AnOwner, ARefNum, '', '');
end;

function ActivateOrderMenu(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
var
  MenuIEN: Integer;
  x: string;
  keep: TRect;

begin
  Result := False;
  MenuIEN := StrToIntDef(AnID, 0);
  x := OrderDisabledMessage(MenuIEN);
  if ShowMsgOn(Length(x) > 0, x, TC_DISABLED) then Exit;
  if uOrderMenu = nil then
  begin
    uOrderMenu := TfrmOMNavA.Create(AnOwner);
    with uOrderMenu do
    begin
      SetBounds(frmFrame.Left + 112, frmFrame.Top + frmFrame.Height - Height, Width, Height);
      SetFormPosition(uOrderMenu, AnID);
      MainFormID := AnID;
      keep := BoundsRect;
      FormStyle := fsStayOnTop;
      SetEventDelay(AnEvent);
    end;
  end
  else
    keep.Width := 0;
  uOrderMenu.SetNewMenu(MenuIEN, AnOwner, ARefNum);
  if not uOrderMenu.Showing then
  begin
    uOrderMenu.Show;
    if keep.Width > 0 then
      uOrderMenu.BoundsRect := keep;
  end
  else
    uOrderMenu.BringToFront;
  Result := True;
end;

function ActivateOrderSet(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
var
  x, ACaption, KeyVarStr: string;
  SetList: TStringList;
  EvtDefaultDlg, PtEvtID: string;

  function TakeoutDuplicateDlg(var AdlgList: TStringList;
    ANeedle: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 0 to AdlgList.Count - 1 do
    begin
      if Piece(AdlgList[i], '^', 1) = ANeedle then
      begin
        AdlgList.Delete(i);
        Result := True;
        break;
      end;
    end;
  end;

begin
  Result := False;
  x := OrderDisabledMessage(StrToIntDef(AnID, 0));
  if ShowMsgOn(Length(x) > 0, x, TC_DISABLED) then
    Exit;
  SetList := TStringList.Create;
  try
    if uOrderSetTime = 0 then
      uOrderSetTime := FMNow;
    LoadOrderSet(SetList, StrToIntDef(AnID, 0), KeyVarStr, ACaption);
    if (AnEvent.EventIFN > 0) and isExistedEvent(Patient.DFN,
      IntToStr(AnEvent.EventIFN), PtEvtID) then
    begin
      EvtDefaultDlg := GetEventDefaultDlg(AnEvent.EventIFN);
      while TakeoutDuplicateDlg(SetList, EvtDefaultDlg) do
        TakeoutDuplicateDlg(SetList, EvtDefaultDlg);
    end;
    Result := ActivateOrderList(SetList, AnEvent, AnOwner, ARefNum, KeyVarStr,
      ACaption);
  finally
    SetList.Free;
  end;
end;

function ActivateOrderList(AList: TStringList; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer;
  const KeyVarStr, ACaption: string): Boolean;
var
  InitialCall: Boolean;
  i: Integer;
  str: string;
begin
  InitialCall := False;
  uOrderSetClinMedMsg := False;
  if ScreenReaderActive then
  begin
    for i := 0 to AList.Count - 1 do
    begin
      if Piece(AList.Strings[i], U, 2) = 'Q' then
        str := str + CRLF + 'Quick Order ' + Piece(AList.Strings[i], U, 3)
      else if Piece(AList.Strings[i], U, 2) = 'S' then
        str := str + CRLF + 'Order Set ' + Piece(AList.Strings[i], U, 3)
      else if Piece(AList.Strings[i], U, 2) = 'M' then
        str := str + CRLF + 'Order Menu ' + Piece(AList.Strings[i], U, 3)
      else if Piece(AList.Strings[i], U, 2) = 'A' then
        str := str + CRLF + 'Order Action ' + Piece(AList.Strings[i], U, 3)
      else
        str := str + CRLF + 'Order Dialog ' + Piece(AList.Strings[i], U, 3);
    end;
    if InfoBox('This order set contains the following items:' + CRLF + str +
      CRLF + CRLF + 'Select the OK button to start this order set.' +
      'To stop the order set while it is in process, press �Alt +F6� to navigate to the order set dialog, and select the Stop Order Set Button.',
      'Starting Order Set', MB_OKCANCEL) = IDCANCEL then
    begin
      Result := False;
      Exit;
    end;
  end;
  if uOrderSet = nil then
  begin
    uOrderSet := TfrmOMSet.Create(AnOwner);
    uOrderSet.SetEventDelay(AnEvent);
    uOrderSet.RefNum := ARefNum;
    InitialCall := True;
  end;
  if InitialCall then
    with uOrderSet do
    begin
      if Length(ACaption) > 0 then
        Caption := ACaption;
      SetBounds(frmFrame.Left, frmFrame.Top + frmFrame.Height - Height,
        Width, Height);
      SetFormPosition(uOrderSet);
      Show;
    end;
  uOrderSet.InsertList(AList, AnOwner, ARefNum, KeyVarStr, AnEvent.EventType);
  TResponsiveGUI.ProcessMessages;
  Result := uOrderSet <> nil;
end;

function ActiveOrdering: Boolean;
begin
  if (uOrderDialog = nil) and (uOrderMenu = nil) and (uOrderSet = nil) and
    (uOrderAction = nil) and (uOrderHTML = nil) then
    Result := False
  else
    Result := True;
end;

function CloseOrdering: Boolean;
begin
  Result := False;
  { if an order set is being processed, see if want to interupt }
  if uOrderSet <> nil then
  begin
    uOrderSet.Close;
    TResponsiveGUI.ProcessMessages(False, True);
    if (uOrderSet <> nil) and not(fsModal in uOrderSet.FormState) then
      Exit;
  end;
  { if another ordering dialog is showing, make sure it is closed first }
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    TResponsiveGUI.ProcessMessages(False, True); // allow close to finish
    if (uOrderDialog <> nil) and not(fsModal in uOrderDialog.FormState) then
      Exit;
  end;
  if uOrderHTML <> nil then
  begin
    uOrderHTML.Close;
    TResponsiveGUI.ProcessMessages(False, True); // allow browser to close
    Assert(uOrderHTML = nil);
  end;
  { close any open ordering menu }
  if uOrderMenu <> nil then
  begin
    uOrderMenu.Close;
    TResponsiveGUI.ProcessMessages(False, True); // allow menu to close
    Assert(uOrderMenu = nil);
  end;
  if uOrderAction <> nil then
  begin
    uOrderAction.Close;
    TResponsiveGUI.ProcessMessages(False, True);
    if (uOrderAction <> nil) and not(fsModal in uOrderAction.FormState) then
      Exit;
  end;
  if frmARTAllergy <> nil then // SMT Add to account for allergies.
  begin
    frmARTAllergy.Close;
    TResponsiveGUI.ProcessMessages(False, True);
    if frmARTAllergy <> nil then
      Exit;
  end;

  Result := True;
end;

function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
var
  x, tmpPtEvt: string;
begin
  Result := False;
  { make sure a location and provider are selected before ordering }
  if not AuthorizedUser then
    Exit;
  // Added to force users without the Provider or ORES key to select an a provider when adding new orders to existing delay orders
  if (not Patient.Inpatient) and (AnEvent.EventIFN > 0) then
  begin
    if (User.OrderRole = OR_PHYSICIAN) and (Encounter.Provider = User.DUZ) and
      (User.IsProvider) then
      x := ''
    else if not EncounterPresentEDO then
      Exit;
    x := '';
  end
  else
  begin
    if not EncounterPresent then
      Exit;
  end;
  { then try to lock the patient (provider & encounter checked first to not leave lock) }
  if not LockedForOrdering then
    Exit;
  try
    { make sure any current ordering process has completed, but don't drop patient lock }
    uKeepLock := True;
    if not CloseOrdering then
      Exit;
    uKeepLock := False;
    { get the delay event for this order (if applicable) }
    if CharInSet(AnEvent.EventType, ['A', 'D', 'T', 'M', 'O']) then
    begin
      if (AnEvent.EventName = '') and (AnEvent.EventType <> 'D') then
        Exit;
      x := SafeEventType(AnEvent.EventType) + IntToStr(AnEvent.Specialty);
      if (uLastConfirm <> x) and (not XfInToOutNow) then
      begin
        uLastConfirm := x;
        case AnEvent.EventType of
          'A', 'M', 'O', 'T':
            x := AnEvent.EventName;
          'D':
            x := 'Discharge';
        end;
        if isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN), tmpPtEvt)
        then
          if PtEvtEmpty(tmpPtEvt) then
            InfoBox(TX_DELAY + x + TX_DELAY1, TC_DELAY,
              MB_OK or MB_ICONWARNING);
      end;
    end
    else
      uLastConfirm := '';
    Result := True;
  Except
    UnlockIfAble;
  end;
end;

function ReadyForNewOrder1(AnEvent: TOrderDelayEvent): Boolean;
var
  x: string;
begin
  Result := False;
  { make sure a location and provider are selected before ordering }
  if not AuthorizedUser then
    Exit;
  if (not Patient.Inpatient) and (AnEvent.EventIFN > 0) then
    x := ''
  else
  begin
    if not EncounterPresent then
      Exit;
  end;
  { then try to lock the patient (provider & encounter checked first to not leave lock) }
  if not LockedForOrdering then
    Exit;
  try
    { make sure any current ordering process has completed, but don't drop patient lock }
    uKeepLock := True;
    if not CloseOrdering then
      Exit;
    uKeepLock := False;
    { get the delay event for this order (if applicable) }
    if CharInSet(AnEvent.EventType, ['A', 'D', 'T', 'M', 'O']) then
    begin
      x := SafeEventType(AnEvent.EventType) + IntToStr(AnEvent.Specialty);
      if (uLastConfirm <> x) and (not XfInToOutNow) then
      begin
        uLastConfirm := x;
        case AnEvent.EventType of
          'A', 'M', 'T', 'O':
            x := AnEvent.EventName;
          'D':
            x := AnEvent.EventName; // 'D': x := 'Discharge';
        end;
      end;
    end
    else
      uLastConfirm := '';
    Result := True;
  Except
    UnlockIfAble;
  end;
end;

procedure SetConfirmEventDelay;
begin
  uLastConfirm := '';
end;

procedure ChangeOrders(AList: TStringList; AnEvent: TOrderDelayEvent);
var
  i, txtOrder: Integer;
  FieldsForEditRenewOrder: TOrderRenewFields;
  param1, param2, param3, param4: string;
  OrSts: Integer;
  AnOrder: TOrder;
begin
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    TResponsiveGUI.ProcessMessages(False, True); // allow close to finish
  end;

  if not ActiveOrdering then // allow change while entering new
    if not ReadyForNewOrder(AnEvent) then
      Exit;
  for i := 0 to AList.Count - 1 do
  begin
    // if it's for unreleased renewed orders, then go to fODChangeUnreleasedRenew and continue
    txtOrder := 0;
    FieldsForEditRenewOrder := TOrderRenewFields.Create;
    try
      LoadRenewFields(FieldsForEditRenewOrder, AList[i]);
      if FieldsForEditRenewOrder.BaseType = OD_TEXTONLY then
        txtOrder := 1;
      if CanEditSuchRenewedOrder(AList[i], txtOrder) then
      begin
        param1 := '0';
        if txtOrder = 0 then
        begin
          param1 := IntToStr(FieldsForEditRenewOrder.Refills);
          param2 := FieldsForEditRenewOrder.Pickup;
          param3 := IntToStr(FieldsForEditRenewOrder.DaysSupply);
          param4 := FieldsForEditRenewOrder.Quantity;
        end
        else if txtOrder = 1 then
        begin
          param1 := FieldsForEditRenewOrder.StartTime;
          param2 := FieldsForEditRenewOrder.StopTime;
          param3 := '';
          param4 := '';
        end;
        UBAGlobals.SourceOrderID := AList[i]; // hds6265 added
        ExecuteChangeRenewedOrder(AList[i], param1, param2, param3, param4, txtOrder,
                                  AnEvent, FieldsForEditRenewOrder.TitrationMsg <> '');
        AnOrder := TOrder.Create;
        SaveChangesOnRenewOrder(AnOrder, AList[i], param1, param2, txtOrder, param3, param4);
        AnOrder.ActionOn := AnOrder.ID + '=RN';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT,
          Integer(AnOrder));
        TResponsiveGUI.ProcessMessages;
        continue;
      end;
    finally
      FieldsForEditRenewOrder.Free;
    end;

    OrSts := GetOrderStatus(AList[i]);
    if (AnsiCompareText(NameOfStatus(OrSts), 'active') = 0) and
      (AnEvent.PtEventIFN > 0) then
      EventDefaultOD := 1;
    ActivateOrderDialog('X' + AList[i], AnEvent, Application, -1);
    // X + ORIFN for change
    if EventDefaultOD = 1 then
      EventDefaultOD := 0;
    TResponsiveGUI.ProcessMessages(False, True); // give uOrderDialog a chance to go back to nil
    if BILLING_AWARE then // hds6265
    begin // hds6265
      UBAGlobals.SourceOrderID := AList[i]; // hds6265
      UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID,
        UBAGlobals.TargetOrderID); // hds6265
    end;
  end;
  UnlockIfAble;
end;

function ChangeOrdersEvt(AnOrderID: string; AnEvent: TOrderDelayEvent): Boolean;
begin
  Result := False;
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    TResponsiveGUI.ProcessMessages(False, True);
  end;
  if not ActiveOrdering then
    if not ReadyForNewOrder(AnEvent) then
      Exit;
  Result := ActivateOrderDialog('X' + AnOrderID, AnEvent, Application, -1);
  TResponsiveGUI.ProcessMessages(False, True);
  UnlockIfAble;
end;

function CopyOrders(AList: TStringList; AnEvent: TOrderDelayEvent;
  var DoesEventOccur: Boolean; ANeedVerify: Boolean = True): Boolean;
var
  i: Integer;
  xx: string;
  IsIMOOD, ForIVAlso: Boolean;
begin
  Result := False;
  if not ReadyForNewOrder(AnEvent) then
    Exit; // no copy while entering new
  for i := 0 to AList.Count - 1 do
  begin
    if (not DoesEventOccur) and (AnEvent.PtEventIFN > 0) and
      IsCompletedPtEvt(AnEvent.PtEventIFN) then
    begin
      DoesEventOccur := True;
      AnEvent.EventType := #0;
      AnEvent.TheParent := TParentEvent.Create(0);
      AnEvent.EventIFN := 0;
      AnEvent.EventName := '';
      AnEvent.PtEventIFN := 0;
    end;

    if CheckOrderGroup(AList[i]) = 1 then
      IsUDGroup := True
    else
      IsUDGroup := False;

    if (AnEvent.EventIFN > 0) and isOnholdMedOrder(AList[i]) then
    begin
      xx := RetrieveOrderText(AList[i]);
      if InfoBox(TX_ONHOLD + #13#13 + xx, 'Warning', MB_YESNO or MB_ICONWARNING)
        = IDNO then
        continue;
    end;

    DEASig := GetDrugSchedule(AList[i]);
    ForIVAlso := ForIVandUD(AList[i]);
    IsIMOOD := IsIMOOrder(AList[i]);
    if (IsUDGroup) and (ImmdCopyAct) and (not Patient.Inpatient) and
      (AnEvent.EventType = 'C') and (not IsIMOOD) and (not ForIVAlso) then
      XfInToOutNow := True;

    OrderSource := 'C';

    if ActivateOrderDialog('C' + AList[i], AnEvent, Application, -1, ANeedVerify)
    then
      Result := True;

    TResponsiveGUI.ProcessMessages(False, True); // give uOrderDialog a chance to go back to nil
    OrderSource := '';

    if (not DoesEventOccur) and (AnEvent.PtEventIFN > 0) and
      IsCompletedPtEvt(AnEvent.PtEventIFN) then
      DoesEventOccur := True;

    if IsUDGroup then
      IsUDGroup := False;
    if XfInToOutNow then
      XfInToOutNow := False;

    if BILLING_AWARE then
    begin
      UBAGlobals.SourceOrderID := AList[i]; // BAPHII 1.3.2
      UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID,
        UBAGlobals.TargetOrderID);
    end;
  end; // for

  UnlockIfAble;
end;

function TransferOrders(AList: TStringList; AnEvent: TOrderDelayEvent;
  var DoesEventOccur: Boolean; ANeedVerify: Boolean = True): Boolean;
var
  i, CountOfTfOrders: Integer;
  xx: string;
  // DoesEventOccur: boolean;
  // OccuredEvtID: integer;
  // OccuredEvtName: string;
begin
  // DoesEventOccur := False;
  // OccuredEvtID := 0;
  Result := False;
  if not ReadyForNewOrder(AnEvent) then
    Exit; // no xfer while entering new
  CountOfTfOrders := AList.Count;
  for i := 0 to CountOfTfOrders - 1 do
  begin
    if (not DoesEventOccur) and (AnEvent.PtEventIFN > 0) and
      IsCompletedPtEvt(AnEvent.PtEventIFN) then
    begin
      DoesEventOccur := True;
      // OccuredEvtID := AnEvent.PtEventIFN;
      // OccuredEvtName := AnEvent.EventName;
      AnEvent.EventType := #0;
      AnEvent.TheParent := TParentEvent.Create(0);
      AnEvent.EventIFN := 0;
      AnEvent.EventName := '';
      AnEvent.PtEventIFN := 0;
    end;
    if i = CountOfTfOrders - 1 then
    begin
      if (AnEvent.EventIFN > 0) and isOnholdMedOrder(AList[i]) then
      begin
        xx := RetrieveOrderText(AList[i]);
        if InfoBox(TX_ONHOLD + #13#13 + xx, 'Warning',
          MB_YESNO or MB_ICONWARNING) = IDNO then
          continue;
      end;
      OrderSource := 'X';
      if ActivateOrderDialog('T' + AList[i], AnEvent, Application, -2,
        ANeedVerify) then
        Result := True;
    end
    else
    begin
      if (AnEvent.EventIFN > 0) and isOnholdMedOrder(AList[i]) then
      begin
        xx := RetrieveOrderText(AList[i]);
        if InfoBox(TX_ONHOLD + #13#13 + xx, 'Warning',
          MB_YESNO or MB_ICONWARNING) = IDNO then
          continue;
      end;
      OrderSource := 'X';
      if ActivateOrderDialog('T' + AList[i], AnEvent, Application, -1,
        ANeedVerify) then
        Result := True;
    end;
    TResponsiveGUI.ProcessMessages(False, True); // give uOrderDialog a chance to go back to nil
    OrderSource := '';
    if (not DoesEventOccur) and (AnEvent.PtEventIFN > 0) and
      IsCompletedPtEvt(AnEvent.PtEventIFN) then
      DoesEventOccur := True;

    UBAGlobals.SourceOrderID := AList[i];
    UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID,
      UBAGlobals.TargetOrderID);

  end;
  UnlockIfAble;

end;

procedure DestroyingOrderAction;
begin
  uOrderAction := nil;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

procedure DestroyingOrderDialog;
begin
  uOrderDialog := nil;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

procedure DestroyingOrderHTML;
begin
  uOrderHTML := nil;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

procedure DestroyingOrderMenu;
begin
  uOrderMenu := nil;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

procedure DestroyingOrderSet;
begin
  uOrderSet := nil;
  uOrderSetClinMedMsg := False;
  uOrderSetTime := 0;
  if not ActiveOrdering then
  begin
    ClearOrderRecall;
    UnlockIfAble;
  end;
end;

function OrderIsLocked(const AnOrderID, AnAction: string): Boolean;
var
  ErrorMsg: string;
begin
  Result := True;
  if (AnAction = OA_COPY) then
    Exit;
  if ((AnAction = OA_HOLD) or (AnAction = OA_UNHOLD) or (AnAction = OA_RENEW) or
    (AnAction = OA_DC) or (AnAction = OA_CHANGE)) and
    Changes.ExistForOrder(AnOrderID) then
    Exit;
  LockOrder(AnOrderID, ErrorMsg);
  if Length(ErrorMsg) > 0 then
  begin
    Result := False;
    InfoBox(ErrorMsg + CRLF + CRLF + TextForOrder(AnOrderID), TC_NOLOCK, MB_OK);
  end;
end;

procedure PopLastMenu;
{ always called from fOMSet }
begin
  if uOrderMenu <> nil then
    uOrderMenu.cmdDoneClick(uOrderSet);
end;

procedure QuickOrderSave;
begin
  // would be better to prompt for dialog
  if uOrderDialog = nil then
  begin
    InfoBox(TX_NO_SAVE_QO, TC_NO_SAVE_QO, MB_OK);
    Exit;
  end;
  with uOrderDialog do
  begin
    if not AllowQuickOrder then
    begin
      InfoBox(TX_NO_QUICK, TC_NO_QUICK, MB_OK);
      Exit;
    end;
    if Responses.OrderContainsObjects then
    begin
      InfoBox(TX_CANT_SAVE_QO, TC_NO_QUICK, MB_ICONERROR or MB_OK);
      Exit;
    end;
    SaveAsQuickOrder(Responses);
  end;
end;

procedure QuickOrderListEdit;
begin
  // would be better to prompt for dialog
  if uOrderDialog = nil then
  begin
    InfoBox(TX_NO_EDIT_QO, TC_NO_EDIT_QO, MB_OK);
    Exit;
  end;
  with uOrderDialog do
  begin
    if not AllowQuickOrder then
    begin
      InfoBox(TX_NO_QUICK, TC_NO_QUICK, MB_OK);
      Exit;
    end;
    EditCommonList(DisplayGroup);
  end;
end;

function RefNumFor(AnOwner: TComponent): Integer;
begin
  if (uOrderDialog <> nil) and (UnwrappedOwner(uOrderDialog) = AnOwner)
    then Result := uOrderDialog.RefNum
  else if (uOrderMenu <> nil) and (uOrderMenu.Owner = AnOwner)
    then Result := uOrderMenu.RefNum
  else if (uOrderHTML <> nil) and (uOrderHTML.Owner = AnOwner)
    then Result := uOrderHTML.RefNum
  else if (uOrderSet <> nil) and (uOrderSet.Owner = AnOwner)
    then Result := uOrderSet.RefNum
  else Result := -1;
end;

procedure PrintOrdersOnSignReleaseMult(OrderList, ClinicLst,
  WardLst: TStringList; Nature: Char; EncLoc, WardLoc: Integer;
  EncLocName, WardLocName: string);
var
  i, j: Integer;
  tempOrder: string;
  tempOrderList: TStringList;
begin
  tempOrderList := TStringList.Create;
  if (ClinicLst <> nil) and (ClinicLst.Count > 0) then
  begin
    for i := 0 to ClinicLst.Count - 1 do
    begin
      tempOrder := ClinicLst.Strings[i];
      for j := 0 to OrderList.Count - 1 do
        if Piece(OrderList.Strings[j], U, 1) = tempOrder then
          tempOrderList.Add(OrderList.Strings[j]);
    end;
    if tempOrderList.Count > 0 then
      PrintOrdersOnSignRelease(tempOrderList, Nature, EncLoc, EncLocName);
  end;
  if (WardLst <> nil) and (WardLst.Count > 0) then
  begin
    if tempOrderList.Count > 0 then
    begin
      tempOrderList.Free;
      tempOrderList := TStringList.Create;
    end;
    for i := 0 to WardLst.Count - 1 do
    begin
      tempOrder := WardLst.Strings[i];
      for j := 0 to OrderList.Count - 1 do
        if Piece(OrderList.Strings[j], U, 1) = tempOrder then
          tempOrderList.Add(OrderList.Strings[j]);
    end;
    if tempOrderList.Count > 0 then
      PrintOrdersOnSignRelease(tempOrderList, Nature, WardLoc, WardLocName);
  end;
  tempOrderList.Free;
end;

procedure PrintOrdersOnSignRelease(OrderList: TStringList; Nature: Char;
  PrintLoc: Integer = 0; PrintName: string = '');
const
  TX_NEW_LOC1 = 'The patient''s location has changed to ';
  TX_NEW_LOC2 = '.' + CRLF +
    'Should the orders be printed using the new location?';
  TC_NEW_LOC = 'New Patient Location';
  TX_SIGN_LOC = 'No location was selected.  Orders could not be printed!';
  TC_REQ_LOC = 'Orders Not Printed';
  TX_LOC_PRINT =
    'The selected location will be used to determine where orders are printed.';
var
  ALocation: Integer;
  AName, ASvc, DeviceInfo: string;
  PrintIt: Boolean;
begin
  if PrintLoc = 0 then
  begin
    CurrentLocationForPatient(Patient.DFN, ALocation, AName, ASvc);
    if (ALocation > 0) and (ALocation <> Encounter.Location) then
    begin
      if InfoBox(TX_NEW_LOC1 + AName + TX_NEW_LOC2, TC_NEW_LOC, MB_YESNO) = IDYES
      then
        Encounter.Location := ALocation;
    end;
  end;
  // else
  // Encounter.Location := PrintLoc;
  if (PrintLoc = 0) and (Encounter.Location > 0) then
    PrintLoc := Encounter.Location;
  if PrintLoc = 0 then
    PrintLoc := CommonLocationForOrders(OrderList);
  if PrintLoc = 0 then // location required for DEVINFO
  begin
    LookupLocation(ALocation, AName, LOC_ALL, TX_LOC_PRINT);
    if ALocation > 0 then
    begin
      PrintLoc := ALocation;
      Encounter.Location := ALocation;
    end;
  end;
  if PrintLoc = 0 then
    frmFrame.DisplayEncounterText;
  if PrintLoc <> 0 then
  begin
    SetupOrdersPrint(OrderList, DeviceInfo, Nature, False, PrintIt, PrintName,
      PrintLoc);
    if PrintIt then
      PrintOrdersOnReview(OrderList, DeviceInfo, PrintLoc)
    else
      PrintServiceCopies(OrderList, PrintLoc);
  end
  else
    InfoBox(TX_SIGN_LOC, TC_REQ_LOC, MB_OK or MB_ICONWARNING);
end;

procedure SetFontSize(FontSize: Integer);
begin
  if uOrderDialog <> nil then
    uOrderDialog.SetFontSize(FontSize);
  if uOrderMenu <> nil then
    uOrderMenu.ResizeFont;
end;

procedure NextMove(var NMRec: TNextMoveRec; LastIndex: Integer;
  NewIndex: Integer);
begin
  if LastIndex = 0 then
    LastIndex := NewIndex;
  if (LastIndex - NewIndex) <= 0 then
    NMRec.NextStep := STEP_FORWARD
  else
    NMRec.NextStep := STEP_BACK;
  NMRec.LastIndex := NewIndex;
end;

(* function GetQOAltOI: integer;
  begin
  Result := QOAltOI.OI;
  end; *)

function IsIMODialog(DlgID: Integer): Boolean; // IMO
var
  IsInptDlg, IsIMOLocation: Boolean;
  Td: TFMDateTime;
begin
  Result := False;
  IsInptDlg := False;
  // CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
  // Td := FMToday;
  Td := IMOTimeFrame;
  if ((DlgID = MedsInDlgIen) or (DlgID = MedsIVDlgIen) or (IsInptQO(DlgID)) or
    (IsIVQO(DlgID))) then
    IsInptDlg := True;
  IsIMOLocation := IsValidIMOLoc(Encounter.Location, Patient.DFN);
  if (IsInptDlg or IsInptQO(DlgID)) and (not Patient.Inpatient) and
    IsIMOLocation and (Encounter.DateTime > Td) then
    Result := True;
end;

function AllowActionOnIMO(AnEvtTyp: Char): Boolean;
var
  Td: TFMDateTime;
begin
  Result := False;
  if (Patient.Inpatient) then
  begin
    Td := FMToday;
    if IsValidIMOLoc(Encounter.Location, Patient.DFN) and
      (Encounter.DateTime > Td) then
      Result := True;
  end
  else
  begin
    // CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
    // Td := FMToday;
    Td := IMOTimeFrame;
    if IsValidIMOLoc(Encounter.Location, Patient.DFN) and
      (Encounter.DateTime > Td) then
      Result := True
    else if CharInSet(AnEvtTyp, ['A', 'T']) then
      Result := True;
  end;
end;

function IMOActionValidation(AnID: string; var IsIMOOD: Boolean; var x: string;
  AnEventType: Char): Boolean;
var
  actName: string;
begin
  // jd imo change
  Result := True;
  if CharInSet(CharAt(AnID, 1), ['X', 'C']) then
  // transfer IMO order doesn't need check
  begin
    IsIMOOD := IsIMOOrder(Copy(AnID, 2, Length(AnID)));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        if CharAt(AnID, 1) = 'X' then
          actName := 'change';
        if CharAt(AnID, 1) = 'C' then
          actName := 'copy';
        x := 'You cannot ' + actName + ' the clinical medication order.';
        x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#13#10 + x;
        UnlockOrder(Copy(AnID, 2, Length(AnID)));
        Result := False;
      end
      else
      begin
        if Patient.Inpatient then
        begin
          if CharAt(AnID, 1) = 'X' then
            actName := 'changing';
          if CharAt(AnID, 1) = 'C' then
            actName := 'copying';
          if MessageDlg(TX_IMO_WARNING1 + actName + TX_IMO_WARNING2 + #13#13#10
            + x, mtWarning, [mbOK, mbCancel], 0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            Result := False;
          end;
        end;
      end;
    end;
  end;
  if Piece(AnID, '^', 1) = 'RENEW' then
  begin
    IsIMOOD := IsIMOOrder(Piece(AnID, '^', 2));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        x := 'You cannot renew the clinical medication order.';
        x := RetrieveOrderText(Piece(AnID, '^', 2)) + #13#13#10 + x;
        UnlockOrder(Piece(AnID, '^', 2));
        Result := False;
      end
      else
      begin
        if Patient.Inpatient then
        begin
          if MessageDlg(TX_IMO_WARNING1 + 'renewing' + TX_IMO_WARNING2,
            mtWarning, [mbOK, mbCancel], 0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            Result := False;
          end;
        end;
      end;
    end;
  end;
end;

// CQ #15188 - New function to allow IMO functionality 23 hours after encounter date/time - TDP
function IMOTimeFrame: TFMDateTime;
begin
  Result := DateTimeToFMDateTime(FMDateTimeToDateTime(FMNow) - (23 / 24));
end;

// CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
procedure ShowOneStepAdmin;
const
  TX_NOT_VALID_IMO =
    'You have selected a location that has not been designated for One Step Clinic Admin; this action may not be taken for the current location. Please contact Pharmacy Service if you feel that this is not correct.';
var
  aAppHandle, jobNumber: string;
  Result: longBool;
  aConnectionParams, aFunctionParams: WideString;
  tmpRtnRec: TDllRtnRec;
begin
  try
    try
      // CQ 21753 - Suppress provider selection when encounter form is called - jcs
      if Encounter.Location = 0 then
        UpdateEncounter(NPF_SUPPRESS);
      frmFrame.DisplayEncounterText;

      // check if location is marked for clinic orders
      if not(IsValidIMOLocOrderCom(Encounter.Location, Patient.DFN)) then
      begin
        InfoBox(TX_NOT_VALID_IMO, TC_PROV_LOC, MB_OK or MB_ICONWARNING);
        Exit;
      end;

      if Encounter.Location = 0 then
      begin
        InfoBox('An enounter location must be selected',
          'Encounter Location Required!', MB_OK);
        Exit;
      end;

      SuspendTimeout;
      tmpRtnRec := LoadMOBDLL;
      case tmpRtnRec.Return_Type of
        DLL_Success:
          begin
            aAppHandle := TRPCb.GetAppHandle(RPCBrokerV);
            CallVistA('ORBCMA5 JOB', [NIL],jobNumber);
            @LoadMOBProc := GetProcAddress(MOBDLLHandle,
              PAnsiChar(AnsiString('LaunchMOB')));
            if Assigned(LoadMOBProc) then
            begin
              aConnectionParams := aAppHandle + '^' +
                GetServerIP(RPCBrokerV.Server) + '^' +
                IntToStr(RPCBrokerV.ListenerPort) + '^' +
                Piece(RPCBrokerV.User.Division, U, 3);
              aFunctionParams := Patient.DFN + '^' + 'CPRS' + '^' +
                IntToStr(User.DUZ) + '^' + '' + '^' +
                IntToStr(Encounter.Location) + '^' + jobNumber;

              LoadMOBProc(PWideChar(aConnectionParams),
                PWideChar(aFunctionParams), Result);
              if Result then
                frmFrame.mnuFileRefreshClick(Application);
            end
            else
              MessageDlg('Can''t find function "' + 'LaunchMOB' + '".', mtError,
                [mbOK], 0);
          end;
        DLL_Missing:
          TaskMessageDlg('File Missing or Invalid', tmpRtnRec.Return_Message,
            mtError, [mbOK], 0);
        DLL_VersionErr:
          TaskMessageDlg('Incorrect Version Found', tmpRtnRec.Return_Message,
            mtError, [mbOK], 0);

      end;
    except
      on E: Exception do
      begin
        InfoBox('Error Executing ' + MOBDLLName + '. Error Message: ' +
          E.Message, 'Error Executing DLL', MB_OK);
      end;
    end;
  finally
    ResumeTimeout;
    @LoadMOBProc := nil;
    UnloadMOBDLL;
  end;
end;

// CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
function LoadMOBDLL: TDllRtnRec;
begin
  if MOBDLLHandle = 0 then
  begin
    MOBDLLName := GetMOBDLLName();
    Result := LoadDll(MOBDLLName, nil);
    MOBDLLHandle := Result.DLL_HWND;
  end;
end;

// CQ 15530 - Add BCMA Med Order Button Functionality as part of Clinic Orders - JCS
procedure UnloadMOBDLL;
begin
  if MOBDLLHandle <> 0 then
  begin
    FreeLibrary(MOBDLLHandle);
    MOBDLLHandle := 0;
  end;
end;

var
  uRespAdapterSingleton: TResponsesAdapter = nil;

function ResponsesAdapter: TResponsesAdapter;
begin
  if not assigned(uRespAdapterSingleton) then
    uRespAdapterSingleton := TResponsesAdapter.Create;
  Result := uRespAdapterSingleton;
end;

procedure UpdateRefills(Responses: TObject; const CurDispDrug: string;
  CurSupply: Integer; AEvtForPassDischarge: Char; txtRefills: TCaptionEdit;
  spnRefills: TUpDown; var AUpdated: boolean);
var
  oi: Integer;
  Titr: boolean;
begin
  ResponsesAdapter.Assign(Responses);
  oi := StrToIntDef(ResponsesAdapter.IValueFor('ORDERABLE', 1), 0);
  titr := (ResponsesAdapter.IValueFor('TITR', 1) = '1');
  if AEvtForPassDischarge = 'D' then
    spnRefills.Max := CalcMaxRefills(CurDispDrug, CurSupply, oi, TRUE, titr)
  else
    spnRefills.Max := CalcMaxRefills(CurDispDrug, CurSupply, oi,
                                     ResponsesAdapter.EventType = 'D', titr);
  if (StrToIntDef(txtRefills.Text, 0) > spnRefills.Max) then
  begin
    txtRefills.Text := IntToStr(spnRefills.Max);
    spnRefills.Position := spnRefills.Max;
    AUpdated := TRUE;
  end;
end;

function CalcDurationToDays(Responses: TResponsesAdapter; CurSupply: Integer;
  UpdateDuration: boolean; var AllRowsHaveDuration: boolean;
  var CalculatedDuration: string): Integer;
var
  i, DoseMinutes, AndMinutes, TotalMinutes, Count, LastThenIdx: Integer;
  InsideAnd, Updating: Boolean;
  Days: Extended;
  X, DayTxt, LastDayTxt, Conj, RemainderDays: string;

begin
  InsideAnd := False;
  AllRowsHaveDuration := True;

  Count := Responses.InstanceCount('DOSE');
  CalculatedDuration := '';
  LastDayTxt := '';
  RemainderDays := '';
  Updating := True;
  LastThenIdx := 0;
  for i := Count downto 1 do
    if Responses.EValueFor('CONJ', i) = 'THEN' then
    begin
      LastThenIdx := i;
      break;
    end;
  AndMinutes := 0;
  TotalMinutes := 0;
  for i := 1 to Count do
  begin
    x := Responses.IValueFor('INSTR', i);
    if x <> '' then
    begin
      DayTxt := Responses.EValueFor('DAYS', i);
      if InsideAnd and (DayTxt = '') then
        DayTxt := LastDayTxt;
      Conj := Responses.IValueFor('CONJ', i);
      if UpdateDuration then
      begin
        if (i > LastThenIdx) and Updating then
        begin
          if DayTxt = '' then
          begin
            if RemainderDays = '' then
            begin
              Days := TotalMinutes / 1440;
              if Days > Int(Days) then
                Days := Days + 1;
              Days := Trunc(Days);
              if CurSupply > Days then
                RemainderDays := IntToStr(CurSupply - Trunc(Days)) + ' DAYS'
              else
                Updating := False;
            end;
            if Updating then
              DayTxt := RemainderDays;
          end
          else
            Updating := False;
        end;
        CalculatedDuration := CalculatedDuration + DayTxt + '~' + Conj + U;
      end;
      InsideAnd := (Conj = 'A');
      if InsideAnd then
      begin
        if (DayTxt <> '') then
          LastDayTxt := DayTxt;
      end
      else
        LastDayTxt := '';
      if (DayTxt = '') then
        AllRowsHaveDuration := False
      else
      begin
        x := DayTxt;
        DoseMinutes := 0;
        if Piece(x, ' ', 2) = 'MONTHS' then
          DoseMinutes := ExtractInteger(x) * 43200;
        if Piece(x, ' ', 2) = 'WEEKS' then
          DoseMinutes := ExtractInteger(x) * 10080;
        if Pos('DAY', Piece(x, ' ', 2)) > 0 then
          DoseMinutes := ExtractInteger(x) * 1440;
        if Piece(x, ' ', 2) = 'HOURS' then
          DoseMinutes := ExtractInteger(x) * 60;
        if Piece(x, ' ', 2) = 'MINUTES' then
          DoseMinutes := ExtractInteger(x);
        // Determine how TotalMinutes should be calculated based on conjunction
        x := Conj;
        if x <> 'A' then
        begin
          if AndMinutes = 0 then
            TotalMinutes := TotalMinutes + DoseMinutes;
          if AndMinutes > 0 then
          begin
            if AndMinutes < DoseMinutes then
              AndMinutes := DoseMinutes;
            TotalMinutes := TotalMinutes + AndMinutes;
            AndMinutes := 0;
          end;
          // if ValFor(COL_SEQUENCE, i) = 'EXCEPT' then
          if x = 'EXCEPT' then
            break; // quit out of For Loop to stop counting TotalMinutes
          // if (ValFor(COL_SEQUENCE, i) = 'AND') then
        end;
        if x = 'A' then
          if AndMinutes < DoseMinutes then
            AndMinutes := DoseMinutes;
      end;
    end;
  end;
  if AndMinutes > 0 then
    TotalMinutes := TotalMinutes + AndMinutes;

  Days := TotalMinutes / 1440;
  if Days > Int(Days) then
    Days := Days + 1;
  Result := Trunc(Days);
end;

procedure CheckChanges(Responses: TObject; AIsQuickOrder, AInptDlg, AIsComplex: boolean;
            AQOInitial, AIsClozapineOrder: boolean; AEvtForPassDischarge: Char;
            DosageText: string; AScheduleChanged, ANoZERO: boolean;
            var AChanging, AUpdated: boolean;
            var ALastUnits, ALastSchedule, ALastDuration, ALastInstruct, ALastDispDrug: string;
            var ALastTitration: boolean; var ALastQuantity: Double; var ALastSupply: Integer;
            txtQuantity, txtSupply, txtRefills: TCaptionEdit;
            spnSupply, spnQuantity, spnRefills: TUpDown; lblAdminTime: TVA508StaticText;
            UpdateStartExpiresProc: TUpdateStartExpiresProc);
var
  CurUnits, CurSchedule, CurInstruct, CurDispDrug, CurDuration, TmpSchedule,
            CurScheduleIN, CurScheduleOut: string;
  X, x1, FirstDispDrug: string;
  CurSupply, i, pNum, j, OrderableItem: Integer;
  CurQuantity: Double;
  LackQtyInfo, CurTitration, HasFreeTextDose: boolean;

  function DurationToDays(var AllRowsHaveDuration: boolean): Integer;
  var
    tmpDur: string;

  begin
    Result := CalcDurationToDays(ResponsesAdapter, CurSupply, False,
    AllRowsHaveDuration, tmpDur);
  end;

  function DurationWithRemainder: string;
  var
    AllRows: boolean;

  begin
    if AIsComplex then
      CalcDurationToDays(ResponsesAdapter, CurSupply, True, AllRows, Result)
    else
      Result := CurDuration;
  end;

  procedure UpdateDefaultSupply(const CurUnits, CurSchedule,
    CurDuration, CurDispDrug: string; var CurSupply: Integer;
    var CurQuantity: Double);
  var
    DoUpdate, CalculateQuantity, AllRowsHaveDuration: boolean;
    tmpSupply: Integer;

  begin
    DoUpdate := False;
    CalculateQuantity := False;
    if (not HasFreeTextDose) then
    begin
      DoUpdate := (CurInstruct <> ALastInstruct);
      if not DoUpdate then
        DoUpdate := (CurDuration <> ALastDuration) and (txtSupply.Tag = 0) and
          (txtQuantity.Tag = 0);
      if not DoUpdate then
        DoUpdate := (CurSupply = 0) and (txtQuantity.Tag = 0) and
          (Screen.ActiveControl <> txtSupply);
      if DoUpdate then
      begin
        DoUpdate := (StrToFloatDef(txtQuantity.Text, 0.0) < 0.00000001) and
          (StrToIntDef(txtSupply.Text, 0) = 0) and (txtQuantity.Tag = 0) and
          (txtSupply.Tag = 0) and (DosageText <> '');
        if not DoUpdate then
          DoUpdate := AIsComplex and (not AIsQuickOrder);
      end;
    end;
    if DoUpdate then
    begin
      CurSupply := DefaultDays(FirstDispDrug, CurUnits, CurSchedule, OrderableItem);
      if CurSupply > 0 then
      begin
        spnSupply.Position := CurSupply;
        txtSupply.Text := IntToStr(CurSupply);
        spnSupply.Position := CurSupply;
        txtSupply.Tag := 0;
        if (AIsQuickOrder) and (AQOInitial) and (AIsClozapineOrder = false) then
        begin
          if StrToFloatDef(txtSupply.Text, 0) > 0 then
          begin
            Exit;
          end;
        end;
        CalculateQuantity := True;
      end;
    end;
    if (AIsComplex) and (txtSupply.Tag = 0) and (txtQuantity.Tag = 0) then
    begin
      // set days supply based on durations
      tmpSupply := DurationToDays(AllRowsHaveDuration);
      if AllRowsHaveDuration and (tmpSupply > 0) and (CurSupply <> tmpSupply) then
      begin
        CurSupply := tmpSupply;
        txtSupply.Text := IntToStr(CurSupply);
        spnSupply.Position := CurSupply;
        CalculateQuantity := True;
      end;
    end;
(* moved to validate on accept order
    if AIsClozapineOrder and (FirstDispDrug <> '') then
    begin
      tmpSupply := DefaultDays(FirstDispDrug, CurUnits, CurSchedule, OrderableItem);
      if (tmpSupply > 0) and (CurSupply > tmpSupply) then
      begin
        CurSupply := tmpSupply;
        txtSupply.Text := IntToStr(CurSupply);
        txtSupply.Tag := 0;
        txtQuantity.Tag := 0;
        CalculateQuantity := True;
      end;
    end;
*)
    if CalculateQuantity then
    begin
      CurQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
        DurationWithRemainder, FirstDispDrug);
      if CurQuantity >= 0 then
      begin
        txtQuantity.Text := FloatToStr(CurQuantity);
        if CurQuantity = trunc(CurQuantity) then
          spnQuantity.Position := trunc(CurQuantity);
        txtQuantity.Tag := 0;
      end;
      LackQtyInfo := True;
      AScheduleChanged := False;
    end;
  end;

  procedure UpdateSupplyQuantity(const CurUnits, CurSchedule, CurDuration, CurDispDrug, CurInstruct: string;
            var CurSupply: Integer; var CurQuantity: Double);
  const
    UPD_NONE = 0;
    UPD_QUANTITY = 1;
    UPD_SUPPLY = 2;
    UPD_COMPLEX = 3;
    UPD_BOTH = 4;
  var
    UpdateControl: Integer;
    tmpQuantity: Double;

  begin
    // exit if not enough fields to calculation supply or quantity
    if (CurQuantity = 0) and (CurSupply = 0) then
      Exit;
    // exit if nothing has changed
    if (CurUnits = ALastUnits) and (CurSchedule = ALastSchedule) and
      (CurDuration = ALastDuration) and (CurQuantity = ALastQuantity) and
      (CurSupply = ALastSupply) and (CurInstruct = ALastInstruct) then
      Exit;
    // exit if supply & quantity have both been directly edited
    if (txtSupply.Tag > 0) and (txtQuantity.Tag > 0) then
      Exit;
    // figure out which control to update
    UpdateControl := UPD_NONE;

    if (CurSupply <> ALastSupply) and (txtQuantity.Tag = 0) and
      (CurQuantity <> ALastQuantity) and (txtSupply.Tag = 0) then
      UpdateControl := UPD_BOTH
    else if (CurSupply <> ALastSupply) and (txtQuantity.Tag = 0) then
      UpdateControl := UPD_QUANTITY
    else if (CurQuantity <> ALastQuantity) and (txtSupply.Tag = 0) then
      UpdateControl := UPD_SUPPLY;
    if (UpdateControl = UPD_NONE) and
      (((CurUnits <> ALastUnits) or (CurInstruct <> ALastInstruct)) or
      (CurSchedule <> ALastSchedule)) then
    begin
      if txtQuantity.Tag = 0 then
        UpdateControl := UPD_QUANTITY
      else if txtSupply.Tag = 0 then
        UpdateControl := UPD_SUPPLY;
    end;
    if (CurDuration <> ALastDuration) then
      UpdateControl := UPD_BOTH; // *SMT if Duration changed, update both.

    case UpdateControl of
      UPD_QUANTITY:
        begin
          if AIsQuickOrder and (CurQuantity > 0) and AQOInitial then
          begin
            txtQuantity.Text := FloatToStr(CurQuantity);
            if CurQuantity = trunc(CurQuantity) then
              spnQuantity.Position := trunc(CurQuantity);
            Exit;
          end;
          CurQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
            DurationWithRemainder, FirstDispDrug);
          if (CurQuantity >= 0) then
          begin
            txtQuantity.Text := FloatToStr(CurQuantity);
            if CurQuantity = trunc(CurQuantity) then
              spnQuantity.Position := trunc(CurQuantity);
          end;
        end;
      UPD_SUPPLY:
        begin
          CurSupply := QtyToDays(CurQuantity, CurUnits, CurSchedule,
            CurDuration, FirstDispDrug); // NOT DurationWithRemainder
          if CurSupply > 0 then
            txtSupply.Text := IntToStr(CurSupply);
        end;
      UPD_BOTH:
        begin
          txtSupply.Text := IntToStr(CurSupply);
          spnSupply.Position := StrToIntDef(txtSupply.Text, 0);
          tmpQuantity := DaysToQty(CurSupply, CurUnits, CurSchedule,
            DurationWithRemainder, FirstDispDrug);
          if AIsQuickOrder and (CurQuantity > 0) and AQOInitial then
          begin
            txtQuantity.Text := FloatToStr(CurQuantity);
            if CurQuantity = trunc(CurQuantity) then
              spnQuantity.Position := trunc(CurQuantity);
            Exit;
          end;
          (* if FIsQuickOrder and (CurQuantity > 0) and (tmpQuantity = 0) and FQOInitial then
            begin
            txtQuantity.Text := FloatToStr(CurQuantity);
            Exit;
            end; *)
          // CurQuantity := DaysToQty(CurSupply,   CurUnits, CurSchedule, CurDuration, FirstDispDrug);
          CurQuantity := tmpQuantity;
          if CurQuantity >= 0 then
          begin
            txtQuantity.Text := FloatToStr(CurQuantity);
            if CurQuantity = trunc(CurQuantity) then
              spnQuantity.Position := trunc(CurQuantity);
          end;
        end;
    end;
    if UpdateControl > UPD_NONE then
      AUpdated := TRUE;
  end;

begin
  ResponsesAdapter.Assign(Responses);
  LackQtyInfo := FALSE;
  HasFreeTextDose := False;
  OrderableItem := StrToIntDef(ResponsesAdapter.IValueFor('ORDERABLE', 1), 0);
  BuildResponseVarsForOutpatient(ResponsesAdapter, CurUnits, CurScheduleOut,
    CurDuration, CurDispDrug, False);

  i := ResponsesAdapter.NextInstance('DOSE', 0);
  while i > 0 do
  begin
    X := ResponsesAdapter.IValueFor('DOSE', i);
    if X = '' then
      HasFreeTextDose := True;
    X := Piece(X, '&', 3);
    if (X = '') and (not AIsQuickOrder) then
      LackQtyInfo := TRUE // StrToIntDef(x, 0) = 0
    else if (X = '') and AIsQuickOrder and (StrToFloatDef(txtQuantity.Text, 0.0) > 0.00000001) then
      LackQtyInfo := FALSE;
    X := ResponsesAdapter.IValueFor('SCHEDULE', i);
    if Length(X) = 0 then
      LackQtyInfo := TRUE;
    x1 := ResponsesAdapter.IValueFor('CONJ', i);
    if Length(x1) > 0 then
    begin
      x1 := CharAt(x1, 1);
      CurScheduleIN := CurScheduleIN + x1 + ';' + X + U;
    end
    else
      CurScheduleIN := CurScheduleIN + ';' + X + U;
    X := ResponsesAdapter.IValueFor('INSTR', i);
     CurInstruct := CurInstruct + X + U; // AGP CHANGE 26.19 FOR CQ 7465
    i := ResponsesAdapter.NextInstance('DOSE', i);
  end;

  TmpSchedule := '';
  pNum := 1;
  while Length(Piece(CurScheduleIN, U, pNum)) > 0 do
    pNum := pNum + 1;
  if Length(Piece(CurScheduleIN, U, pNum)) < 1 then
    for j := 1 to pNum - 1 do
    begin
      if j = pNum - 1 then
        TmpSchedule := TmpSchedule + ';' +
          Piece(Piece(CurScheduleIN, U, j), ';', 2)
      else
        TmpSchedule := TmpSchedule + Piece(CurScheduleIN, U, j) + U
    end;
  CurScheduleIN := TmpSchedule;
//  CurQuantity := StrToFloatDef(ValueOfResponse(FLD_QUANTITY), 0);
  CurQuantity := StrToFloatDef(ResponsesAdapter.IValueFor('QTY',1), 0);
//  CurSupply := StrToIntDef(ValueOfResponse(FLD_SUPPLY), 0);
  CurSupply := StrToIntDef(ResponsesAdapter.IValueFor('SUPPLY',1), 0);
  CurTitration := (ResponsesAdapter.IValueFor('TITR',1) = '1');
  // CurRefill  := StrToIntDef(ValueOfResponse(FLD_REFILLS) , 0);
  FirstDispDrug := Piece(CurDispDrug, U, 1);
  if AInptDlg then
  begin
    CurSchedule := CurScheduleIN;
    if assigned(lblAdminTime) and (Pos('^', CurSchedule) > 0) then
    begin
      if Pos('PRN', Piece(CurSchedule, '^', 1)) > 0 then
        if lblAdminTime.Visible then
          lblAdminTime.Caption := '';
    end;
//    if (Self.tabDose.TabIndex = TI_DOSE) and (CurSchedule <> FLastSchedule)
    if (not AIsComplex) and (CurSchedule <> ALastSchedule) then
    begin
      if assigned(UpdateStartExpiresProc) then
        UpdateStartExpiresProc(CurSchedule);
    end;
    if assigned(lblAdminTime) and
       CharInSet(ResponsesAdapter.EventType, ['A', 'D', 'T', 'M', 'O']) then
      lblAdminTime.Visible := FALSE;
  end;
  if not AInptDlg then
  begin
    CurSchedule := CurScheduleOut;
    UpdateDefaultSupply(CurUnits, CurSchedule, CurDuration, CurDispDrug,
      CurSupply, CurQuantity);
    if LackQtyInfo then
    begin
      if AScheduleChanged then
      begin
        txtQuantity.Text := '0';
        spnQuantity.Position := 0;
        txtQuantity.Tag := 0;
      end;
    end
    else
      UpdateSupplyQuantity(CurUnits, CurSchedule, CurDuration, CurDispDrug,
        CurInstruct, CurSupply, CurQuantity);
    if ((CurDispDrug <> ALastDispDrug) or (CurSupply <> ALastSupply) or
        (CurTitration <> ALastTitration)) and
      (CurDispDrug <> '') and (CurSupply > 0) then
      UpdateRefills(Responses, CurDispDrug, CurSupply, AEvtForPassDischarge,
                    txtRefills, spnRefills, AUpdated);
  end;

  ALastUnits := CurUnits;
  ALastSchedule := CurSchedule;
  ALastDuration := CurDuration;
  ALastInstruct := CurInstruct;
  ALastDispDrug := CurDispDrug;
  ALastQuantity := CurQuantity;
  ALastSupply := CurSupply;
  ALastTitration := CurTitration;

  if (not ANoZERO) and (txtQuantity.Text = '') and (ALastQuantity = 0) then
  begin
    txtQuantity.Text := FloatToStr(ALastQuantity);
    if ALastQuantity = trunc(ALastQuantity) then
      spnQuantity.Position := trunc(ALastQuantity);
  end;
  if (not ANoZERO) and (txtSupply.Text = '') and (ALastSupply = 0) then
  begin
    txtSupply.Text := IntToStr(ALastSupply);
    spnSupply.Position := StrToIntDef(txtSupply.Text, 0);
  end;
end;

{ TRespAdapter }

procedure TResponsesAdapter.Assign(Adaptee: TObject);
begin
  FIsRespObj := Adaptee is TResponses;
  if FIsRespObj then
  begin
    FResponses := TResponses(Adaptee);
    FResponseList := nil;
  end
  else if Adaptee is TList then
  begin
    FResponses := nil;
    FResponseList := TList(Adaptee)
  end
  else
    raise Exception.Create('Invalid TResponseAdapter Assignment');
end;

function TResponsesAdapter.EValueFor(const APromptID: string;
  AnInstance: Integer): string;
var
  i: Integer;
begin
  if FIsRespObj then
    Result := FResponses.EValueFor(APromptID, AnInstance)
  else
  begin
    Result := '';
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
      if (PromptID = APromptID) and (Instance = AnInstance) then
      begin
        Result := EValue;
        break;
      end;
  end;
end;

function TResponsesAdapter.FindResponseByName(const APromptID: string;
  AnInstance: Integer): TResponse;
var
  i: Integer;

begin
  if FIsRespObj then
    Result := FResponses.FindResponseByName(APromptID, AnInstance)
  else
  begin
    Result := nil;
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
      if (PromptID = APromptID) and (Instance = AnInstance) then
      begin
        Result := TResponse(Items[i]);
        break;
      end;
  end;
end;

function TResponsesAdapter.GetEventType: Char;
begin
  if FIsRespObj then
    Result := FResponses.EventType
  else
  begin
    Result := #0;
  end;
end;

function TResponsesAdapter.InstanceCount(const APromptID: string): Integer;
var
  i: Integer;
begin
  if FIsRespObj then
    Result := FResponses.InstanceCount(APromptID)
  else
  begin
    Result := 0;
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
      if (PromptID = APromptID) then Inc(Result);
  end;
end;

function TResponsesAdapter.IValueFor(const APromptID: string;
  AnInstance: Integer): string;
var
  i: Integer;
begin
  if FIsRespObj then
    Result := FResponses.IValueFor(APromptID, AnInstance)
  else
  begin
    Result := '';
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
      if (PromptID = APromptID) and (Instance = AnInstance) then
      begin
        Result := IValue;
        break;
      end;
  end;
end;

function TResponsesAdapter.NextInstance(const APromptID: string;
  LastInstance: Integer): Integer;
var
  i: Integer;
begin
  if FIsRespObj then
    Result := FResponses.NextInstance(APromptID, LastInstance)
  else
  begin
    Result := 0;
    with FResponseList do for i := 0 to Count - 1 do with TResponse(Items[i]) do
      if (PromptID = APromptID) and (Instance > LastInstance) and
        ((Result = 0) or ((Result > 0) and (Instance < Result))) then Result := Instance;
  end;
end;

procedure TResponsesAdapter.Update(const APromptID: string; AnInstance: Integer;
  const AnIValue, AnEValue: string);
var
  AResponse: TResponse;
begin
  if FIsRespObj then
    FResponses.Update(APromptID, AnInstance, AnIValue, AnEValue)
  else
  begin
    AResponse := FindResponseByName(APromptID, AnInstance);
    if AResponse = nil then
    begin
      AResponse := TResponse.Create;
      AResponse.PromptID := APromptID;
  //    AResponse.PromptIEN := IENForPrompt(APromptID);
      AResponse.Instance := AnInstance;
      FResponseList.Add(AResponse);
    end;
    AResponse.IValue := AnIValue;
    AResponse.EValue := AnEValue;
  end;
end;

function TitrationSafeText(Text1, Text2: string): string;
begin
  if pos('titration order',Text2) > 0 then
    Result := CRLF + Text2
  else
    Result := Text1 + Text2;
end;

function HasDaysSupplyComplexDoseConflict(AResponses: TObject;
  CurSupply: integer; OrderText: string; var EditOrder: Boolean): Boolean;
var
  Responses: TResponsesAdapter;
  CalcDays, BtnResult: Integer;
  NewAdapter, AllRowsHaveDuration: Boolean;
  tmpDur, MessageText: string;
  list: TStringList;

begin
  NewAdapter := not (AResponses is TResponsesAdapter);
  if NewAdapter then
    Responses := TResponsesAdapter.Create
  else
    Responses := TResponsesAdapter(AResponses);
  try
    if NewAdapter then
      Responses.Assign(AResponses);
    Result := False;
    CalcDays := CalcDurationToDays(Responses, CurSupply, False,
      AllRowsHaveDuration, tmpDur);
    if AllRowsHaveDuration and (CalcDays > 0) and (CurSupply <> CalcDays) then
    begin
      if OrderText = '' then
        MessageText := ''
      else
        MessageText := OrderText + CRLF + CRLF;
      MessageText := MessageText + Format(TX_DAYS_CONFLICT, [CurSupply, CalcDays]);
      if OrderText = '' then
      begin
        MessageText := MessageText + 'Are you sure you want to accept this order?';
        if InfoBox(MessageText, TC_PROV_LOC,
          MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING) = IDNO then
          Result := True;
      end
      else
      begin
        list := TStringList.Create;
        try
          MessageText := MessageText + 'Do you want to Accept this order, ' +
            'Edit this order, or Cancel?';
          list.Add('Accept Order');
          list.Add(' Edit Order ');
          list.Add('Cancel Order');
          BtnResult := uInfoBoxWithBtnControls.DefMessageDlG(MessageText,
            mtWarning, list, TC_PROV_LOC, True);
          case BtnResult of
            0: ;
            1: EditOrder := True;
            else Result := True;
          end;
        finally
          list.Free;
        end;
      end;
    end;
  finally
    if NewAdapter then
      Responses.Free;
  end;
end;

initialization

uPatientLocked := False;
uKeepLock := False;
uLastConfirm := '';
uOrderSetTime := 0;
uNewMedDialog := 0;
uOrderAction := nil;
uOrderDialog := nil;
uOrderHTML := nil;
uOrderMenu := nil;
uOrderSet := nil;
NSSchedule := False;
OriginalMedsOutHeight := 0;
OriginalMedsInHeight := 0;
OriginalNonVAMedsHeight := 0;

finalization
  if assigned(uRespAdapterSingleton) then
    uRespAdapterSingleton.free;

end.

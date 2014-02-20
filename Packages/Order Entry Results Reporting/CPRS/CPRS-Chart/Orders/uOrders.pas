unit uOrders;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, uConst, rConsults,
  rOrders, ORFn, Dialogs, ORCtrls, stdCtrls, strUtils, fODBase, fODMedOIFA,
  VA508AccessibilityRouter, XUDsigS, ORNet;

type
  EOrderDlgFail = class(Exception);

  //FQOAltOI = record
  //OI: integer;
  //end;

{ Ordering Environment }
function AuthorizedUser: Boolean;
function AuthorizedToVerify: Boolean;
function EncounterPresent(ErrorMsg: String = ''): Boolean;
function EncounterPresentEDO: Boolean;
function LockedForOrdering: Boolean;
function IsValidActionOnComplexOrder(AnOrderID, AnAction: string;
    AListBox: TListBox; var CheckedList: TStringList; var ErrMsg: string; var ParentOrderID: string): boolean;  //PSI-COMPLEX
procedure UnlockIfAble;
function SetSAN(Self: TComponent): string;
function OrderCanBeLocked(OrderID: string): Boolean;
procedure UnlockOrderIfAble(OrderID: string);
procedure AddSelectedToChanges(AList: TList);
procedure ResetDialogProperties(const AnID: string; AnEvent: TOrderDelayEvent; var ResolvedDialog: TOrderDialogResolved);
function IsInvalidActionWarning(const AnOrderText,AnOrderID: String): boolean;
procedure InitialOrderVariables;

{ Write Orders }
function ActivateAction(const AnID: string; AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer; ANeedVerify: boolean = True): Boolean;
function RetrieveOrderText(AnOrderID: string): string;
function ActivateOrderHTML(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderMenu(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderSet(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
function ActivateOrderList(AList: TStringList; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer; const KeyVarStr, ACaption: string): Boolean;
function ActiveOrdering: Boolean;
function CloseOrdering: Boolean;
function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
function ReadyForNewOrder1(AnEvent: TOrderDelayEvent): Boolean;
function ChangeOrdersEvt(AnOrderID: string; AnEvent: TOrderDelayEvent): boolean;
function CopyOrders(AList: TStringList; AnEvent: TOrderDelayEvent; var DoesEventOccur: boolean; ANeedVerify: boolean = True): boolean;
function TransferOrders(AList: TStringList; AnEvent: TOrderDelayEvent; var DoesEventOccur: boolean; ANeedVerify: boolean = True): boolean;
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
procedure PrintOrdersOnSignReleaseMult(OrderList, ClinicLst, WardLst: TStringList; Nature: Char; EncLoc, WardLoc: integer; EncLocName, WardLocName: string);
procedure PrintOrdersOnSignRelease(OrderList: TStringList; Nature: Char; PrintLoc : Integer =0; PrintName: string = '');
procedure SetFontSize( FontSize: integer);
procedure NextMove(var NMRec: TNextMoveRec; LastIndex: Integer; NewIndex: Integer);
//function GetQOAltOI: integer;

{ Inpatient medication for Outpatient}
function IsIMODialog(DlgID: integer): boolean;
function AllowActionOnIMO(AnEvtTyp: char): boolean;
function IMOActionValidation(AnId: string; var IsIMOOD: boolean; var x: string; AnEventType: char): boolean;
function IMOTimeFrame: TFMDateTime;


var
uAutoAc: Boolean;
InptDisp : Integer;
OutptDisp: Integer;
MedsDisp : Integer;
ClinDisp : Integer; //IMO
NurDisp  : Integer;
IVDisp   : Integer;
CsltDisp : Integer;
ProcDisp : Integer;
ImgDisp  : Integer;
DietDisp : Integer;
NonVADisp: Integer;
MedsInDlgIen  : Integer;
MedsOutDlgIen : Integer;
MedsNVADlgIen : Integer;
MedsInDlgFormId  : Integer;
MedsOutDlgFormId : Integer;
MedsNVADlgFormID : Integer;
MedsIVDlgIen: Integer;
MedsIVDlgFormID: Integer;
NSSchedule: boolean;
OriginalMedsOutHeight: Integer;
OriginalMedsInHeight: Integer;
OriginalNonVAMedsHeight: Integer;
PassDrugTstCall: boolean;

implementation

uses fODDiet, fODMisc, fODGen, fODMedIn, fODMedOut, fODText, fODConsult, fODProc, fODRad,
     fODLab, fodBBank, fODMeds, fODMedIV, fODVitals, fODAuto, (*fODAllgy,*) fOMNavA, rCore, uCore, fFrame,
     fEncnt, fEffectDate, fOMVerify, fOrderSaveQuick, fOMSet, rMisc, uODBase, rODMeds,
     fLkUpLocation, fOrdersPrint, fOMAction, fARTAllgy, fOMHTML, fOrders, rODBase,
     fODChild, fMeds, rMeds, rPCE, frptBox, fODMedNVA, fODChangeUnreleasedRenew, rODAllergy,
     UBAGlobals, fClinicWardMeds, uTemplateFields, VAUtils;

var
  uPatientLocked: Boolean;
  uKeepLock: Boolean;
  uOrderAction: TfrmOMAction;
  uOrderDialog: TfrmODBase;
  uOrderHTML: TfrmOMHTML;
  uOrderMenu: TfrmOMNavA;
  uOrderSet: TfrmOMSet;
  uLastConfirm: string;
  uOrderSetTime: TFMDateTime;
  uNewMedDialog: Integer;
  //QOALTOI: FQOAltOI;

const
  TX_PROV_LOC   = 'A provider and location must be selected before entering orders.';
  TC_PROV_LOC   = 'Incomplete Information';
  TX_PROV_KEY   = 'The provider selected for this encounter must' + CRLF +
                  'hold the PROVIDER key to enter orders.';
  TC_PROV_KEY   = 'PROVIDER Key Required';
  TX_NOKEY      = 'You do not have the keys required to take this action.';
  TC_NOKEY      = 'Insufficient Authority';
  TX_BADKEYS    = 'You have mutually exclusive order entry keys (ORES, ORELSE, or OREMAS).' +
                   CRLF + 'This must be resolved before you can take actions on orders.';
  TC_BADKEYS    = 'Multiple Keys';
  TC_NO_LOCK    = 'Unable to Lock';
  TC_DISABLED   = 'Item Disabled';
  TX_DELAY      = 'Now writing orders for ';
  TX_DELAY1     = CRLF + CRLF + '(To write orders for current release rather than delayed release,' + CRLF +
                                 'close the next window and select Active Orders from the View Orders pane.)';
  TC_DELAY      = 'Ordering Information';
  TX_STOP_SET   = 'Do you want to stop entering the current set of orders?';
  TC_STOP_SET   = 'Interupt order set';
  TC_DLG_REJECT = 'Unable to Order';
  TX_NOFORM     = 'This selection does not have an associated windows form.';
  TC_NOFORM     = 'Missing Form ID';
  TX_DLG_ERR    = 'Error in activating order dialog.';
  TC_DLG_ERR    = 'Dialog Error';
  TX_NO_SAVE_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_SAVE_QO = 'Save as Quick Order';
  TX_NO_EDIT_QO = 'An ordering dialog must be active to use this action.';
  TC_NO_EDIT_QO = 'Edit Common List';
  TX_NO_QUICK   = 'This ordering dialog does not support quick orders.';
  TC_NO_QUICK   = 'Save/Edit Quick Orders';
  TX_CANT_SAVE_QO = 'This order contains TIU objects, which may result in patient-specific' + CRLF +
                    'information being included in the order.  For this reason, it may not' + CRLF +
                    'be saved as a personal quick order for later reuse.';
  TX_NO_COPY    = CRLF + CRLF + '- cannot be copied.' + CRLF + CRLF + 'Reason: ';
  TC_NO_COPY    = 'Unable to Copy Order';
  TX_NO_CHANGE  = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF + 'Reason: ';
  TC_NO_CHANGE  = 'Unable to Change Order';
  TC_NO_XFER    = 'Unable to Transfer Order';
  TC_NOLOCK     = 'Unable to Lock Order';
  TX_ONHOLD     = 'The following order has been put on-hold, do you still want to continue?';
  TX_COMPLEX    = 'You can not take this action on a complex medication.' + #13 + 'You must enter a new order.';
  STEP_FORWARD  = 1;
  STEP_BACK     = -1;
  TX_NOINPT     = ': You cannot place inpatient medication orders from a clinic location for selected patient.';
  TX_IMO_WARNING1 = 'You are ';
  TX_IMO_WARNING2 = ' Clinic Orders. The New orders will be saved as Clinic Orders and MAY NOT be available in BCMA';


function CreateOrderDialog(Sender: TComponent; FormID: integer; AnEvent: TOrderDelayEvent; ODEvtID: integer = 0): TfrmODBase;
{ creates an order dialog based on the FormID and returns a pointer to it }
type
  TDialogClass = class of TfrmODBase;
var
  DialogClass: TDialogClass;
begin
  Result := nil;
  // allows the FormCreate to check event under which dialog is created
  if AnEvent.EventType in ['A','D','T','M','O'] then
  begin
   SetOrderEventTypeOnCreate(AnEvent.EventType);
   SetOrderEventIDOnCreate(AnEvent.EventIFN);
  end else
  begin
   SetOrderEventTypeOnCreate(#0);
   SetOrderEventIDOnCreate(0);
  end;
  SetOrderFormIDOnCreate(FormID);  
  // check to see if we should use the new med dialogs
  if uNewMedDialog = 0 then
  begin
    if UseNewMedDialogs then uNewMedDialog := 1 else uNewMedDialog := -1;
  end;
  if (uNewMedDialog > 0) and ((FormID = OD_MEDOUTPT) or (FormID = OD_MEDINPT)) then
      FormID := OD_MEDS;
  // create the form for a given ordering dialog
  case FormID of
  OD_MEDIV:     DialogClass := TfrmODMedIV;
  OD_MEDINPT:   DialogClass := TfrmODMedIn;
  OD_MEDS:      DialogClass := TfrmODMeds;
  OD_MEDOUTPT:  DialogClass := TfrmODMedOut;
  OD_MEDNONVA:  DialogClass := TfrmODMedNVA;
  OD_MISC:      DialogClass := TfrmODMisc;
  OD_GENERIC:
     begin
      if ODEvtID>0 then
       SetOrderEventIDOnCreate(ODEvtID);
      DialogClass := TfrmODGen;
     end;
  OD_IMAGING:   DialogClass := TfrmODRad;
  OD_DIET:      DialogClass := TfrmODDiet;
  OD_LAB:       DialogClass := TfrmODLab;
  OD_BB:        DialogClass := TfrmODBBank;
  OD_CONSULT:   DialogClass := TfrmODCslt;
  OD_PROCEDURE: DialogClass := TfrmODProc;
  OD_TEXTONLY:  DialogClass := TfrmODText;
  OD_VITALS:    DialogClass := TfrmODVitals;
  //OD_ALLERGY:   DialogClass := TfrmODAllergy;
  OD_AUTOACK:   DialogClass := TfrmODAuto;
  else Exit;
  end;
  if Sender = nil then Sender := Application;
  Result := DialogClass.Create(Sender);
  if Result <> nil then Result.CallOnExit := DestroyingOrderDialog;
  SetOrderEventTypeOnCreate(#0);
  SetOrderEventIDOnCreate(0);
  SetOrderFormIDOnCreate(0);
end;

function SetSAN(Self: TComponent): string;
var
  crypto: TCryptography;
  i: Integer;
  setUPN, successMsg: string;
begin
    Result := '';
    if InfoBox(
      '        '
      + User.name
      + CRLF
      + 'Your VistA account has not been linked to a PIV card.'
      + CRLF
      + 'CPRS will now attempt to retrieve some information'
      + CRLF
      + 'from your PIV card in order for you to digitally sign orders.'
      + CRLF
      + 'This will require entry of the PIN associated with your PIV card.'
      + CRLF
      + 'Would you like to continue?',
      'Digital Signing Setup',MB_YESNO or MB_ICONQUESTION) = IDYES then
      begin
        crypto := TCryptography.Create();
        crypto.VistaUserName := RPCBrokerV.User.Name;
        Result := getSANFromCard(Self,crypto);
        if Result='' then ShowMsg('CPRS was not able to link your VistA account to a PIV card.')
        else
        begin
          setUPN := sCallV('XUS PKI SET UPN', [Result]);
          if setUPN = '1' then
          begin
            fFrame.frmFrame.DigitalSigningSetup1.Visible := False;
            successMsg :=
              '        '
              + User.name
              + CRLF
              + 'Your PIV card (' + Result + ') has been successfully linked'
              + CRLF
              + 'to this VistA account, which will allow you to digitally sign orders.'
              + CRLF
              + 'This process does not however provide you the authorization to place'
              + CRLF
              + 'controlled substance prescription orders.'
              + CRLF;
            CallV('ORDEA LNKMSG',[]);
            for i := 0 to RPCBrokerV.Results.Count - 1 do
            begin
              successMsg := successMsg + CRLF + RPCBrokerV.Results.Strings[i];
            end;
            ShowMsg(successMsg);
            end
          else begin
            ShowMsg(
              '        '
              + User.name
              + CRLF
              + 'CPRS was not able to link your VistA account to a PIV card.'
              + CRLF
              + 'One possible cause is that your card is already linked to another VistA account.');
              Result:='';
          end;
        end;
        crypto.Free;
      end;
end; 

function AuthorizedUser: Boolean;
begin
  Result := True;
  if User.NoOrdering then Result := False;
  if User.OrderRole = OR_BADKEYS then
  begin
    InfoBox(TX_BADKEYS, TC_BADKEYS, MB_OK);
    Result := False;
  end;
end;

function AuthorizedToVerify: Boolean;
begin
  Result := True;
  if not User.EnableVerify then Result := False;
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
   //If ErrorMsg was not passed in then use the default
  If ErrorMsg = '' then ErrorMsg := TX_PROV_LOC;

  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider, 'PROVIDER')
    then InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
  if (Encounter.Provider = 0) or (Encounter.Location = 0) or
    ((Encounter.Provider > 0) and (not PersonHasKey(Encounter.Provider, 'PROVIDER'))) then
  begin
    // don't prompt provider if current user has ORES and is the provider
    if (User.OrderRole = OR_PHYSICIAN) and (Encounter.Provider = User.DUZ) and (User.IsProvider)
      then UpdateEncounter(NPF_SUPPRESS)
      else UpdateEncounter(NPF_PROVIDER);
    frmFrame.DisplayEncounterText;
  end;
  if (Encounter.Provider = 0) or (Encounter.Location = 0) then
  begin
    if not frmFrame.CCOWDrivedChange then   //jdccow
      InfoBox(ErrorMsg, TC_PROV_LOC, MB_OK or MB_ICONWARNING);  {!!!}
    Result := False;
  end;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider, 'PROVIDER') then
  begin
    if not frmFrame.CCOWDrivedChange then   //jdccow
      InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
    Result := False;
  end;
end;

function EncounterPresentEDO: Boolean;
begin
  Result := True;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider, 'PROVIDER')
    then InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
  if (Encounter.Provider = 0) or
    ((Encounter.Provider > 0) and (not PersonHasKey(Encounter.Provider, 'PROVIDER'))) then
  begin
    UpdateEncounter(NPF_PROVIDER, 0, 0, True);
    frmFrame.DisplayEncounterText;
  end;
  if (Encounter.Provider = 0) then
  begin
    InfoBox(TX_PROV_LOC, TC_PROV_LOC, MB_OK or MB_ICONWARNING);  {!!!}
    Result := False;
  end;
  if (Encounter.Provider > 0) and not PersonHasKey(Encounter.Provider, 'PROVIDER') then
  begin
    InfoBox(TX_PROV_KEY, TC_PROV_KEY, MB_OK);
    Result := False;
  end;
end;

function LockedForOrdering: Boolean;
var
  ErrMsg: string;
begin
  if uPatientLocked then Result := True else
  begin
    LockPatient(ErrMsg);
    if ErrMsg = '' then
    begin
      Result := True;
      uPatientLocked := True;
      frmFrame.stsArea.Panels.Items[4].Text := 'LOCK';
    end else
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
  end else
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
  if (Encounter.Provider = User.DUZ) and User.CanSignOrders
    then CanSign := CH_SIGN_YES
    else CanSign := CH_SIGN_NA;
  with AList do for i := 0 to Count - 1 do
  begin
    AnOrder := TOrder(Items[i]);
    with AnOrder do Changes.Add(CH_ORD, ID, Text, '', CanSign);
    if (Length(AnOrder.ActionOn) > 0)
      and not Changes.ExistForOrder(Piece(AnOrder.ActionOn, ';', 1))
      then UnlockOrder(AnOrder.ActionOn);
  end;
end;

procedure ResetDialogProperties(const AnID: string; AnEvent: TOrderDelayEvent; var ResolvedDialog: TOrderDialogResolved);
begin
  if StrToIntDef(AnID,0)>0 then
    Exit;
  if XfInToOutNow then
  begin
    ResolvedDialog.DisplayGroup := OutptDisp;
    ResolvedDialog.DialogIEN    := MedsOutDlgIen;
    ResolvedDialog.FormID       := MedsOutDlgFormID;
    ResolvedDialog.QuickLevel   := 0;
    Exit;
  end;
  //if ResolvedDialog.DisplayGroup in [MedsDisp, OutptDisp, InptDisp, NonVADisp, ClinDisp] then
  if (ResolvedDialog.DisplayGroup = InptDisp) or
    (ResolvedDialog.DisplayGroup = OutptDisp) or
    (ResolvedDialog.DisplayGroup = MedsDisp) or
    (ResolvedDialog.DisplayGroup =  NonVADisp) or
    (ResolvedDialog.DisplayGroup =  ClinDisp) then
  begin
    if (AnEvent.EventType <> 'D') and (AnEvent.EventIFN > 0) then
    begin
      if (AnEvent.EventType = 'T') and IsPassEvt(AnEvent.PtEventIFN,'T') then
      begin
        ResolvedDialog.DisplayGroup := OutptDisp;
        ResolvedDialog.DialogIEN    := MedsOutDlgIen;
        ResolvedDialog.FormID       := MedsOutDlgFormID;
        ResolvedDialog.QuickLevel   := 0;
      end
      else
      begin
        //AGP changes to handle IMO INV Dialog opening the unit dose dialog.
        if (ResolvedDialog.DisplayGroup = ClinDisp) and (Resolveddialog.DialogIEN = MedsIVDlgIEN) and (ResolvedDialog.FormID = MedsIVDlgFormId) then
          begin
            ResolvedDialog.DisplayGroup := IVDisp;
            ResolvedDialog.DialogIEN    := MedsIVDlgIen;
            ResolvedDialog.FormID       := MedsIVDlgFormId;
          end
        else
          begin
            ResolvedDialog.DisplayGroup := InptDisp;
            ResolvedDialog.DialogIEN    := MedsInDlgIen;
            ResolvedDialog.FormID       := MedsInDlgFormId;
          end;
        if Length(ResolvedDialog.ShowText)>0 then
          ResolvedDialog.QuickLevel   := 2;
      end;
    end
    else if (AnEvent.EventType = 'D') and (AnEvent.EventIFN > 0) then
    begin
      ResolvedDialog.DisplayGroup := OutptDisp;
      ResolvedDialog.DialogIEN    := MedsOutDlgIen;
      ResolvedDialog.FormID       := MedsOutDlgFormID;
      ResolvedDialog.QuickLevel   := 0;
    end;

    if XferOutToInOnMeds then
    begin
      ResolvedDialog.DisplayGroup := InptDisp;
      ResolvedDialog.DialogIEN    := MedsInDlgIen;
      ResolvedDialog.FormID       := MedsInDlgFormId;
      ResolvedDialog.QuickLevel := 0;
    end;
  end;
  if ResolvedDialog.DisplayGroup = IVDisp then
  begin
    if Length(ResolvedDialog.ShowText)>0 then
      ResolvedDialog.QuickLevel   := 2;
  end;
  if (CharAt(AnID,1) = 'C') and (ResolvedDialog.DisplayGroup in [CsltDisp, ProcDisp]) then
    ResolvedDialog.QuickLevel   := 0;  // CSV - force dialog, to validate ICD code being copied into new order {RV}
end;

function IsInvalidActionWarning(const AnOrderText,AnOrderID: String): boolean;
var
  AnErrLst, tmpList: TStringList;
begin
  Result := False;
  AnErrlst := TStringList.Create;
  IsLatestAction(AnOrderID,AnErrLst);
  if AnErrLst.Count > 0 then
  begin
    tmpList := TStringList.Create;
    PiecesToList(AnsiReplaceStr(AnOrderText,'#D#A','^'),'^',tmpList);
    tmpList.Add(' ');
    tmpList.Add('Cannot be released to service(s) because of the following happened action(s):');
    tmpList.Add(' ');
    FastAddStrings(TStrings(AnErrLst), tmpList);
    ReportBox(tmpList,'Cannot be released to service(s)',False);
    tmpList.Free;
    AnErrLst.Free;
    Result := True;
  end;
end;

procedure InitialOrderVariables;
begin
  InptDisp := DisplayGroupByName('UD RX');
  OutptDisp := DisplayGroupByName('O RX');
  MedsDisp := DisplayGroupByName('RX');
  IVDisp   := DisplayGroupByName('IV RX');
  ClinDisp := DisplayGroupByName('C RX');
  NurDisp  := DisplayGroupByName('NURS');
  CsltDisp := DisplayGroupByName('CSLT');
  ProcDisp := DisplayGroupByName('PROC');
  ImgDisp  := DisplayGroupByName('XRAY');
  DietDisp := DisplayGroupByName('DO');
  NonVADisp := DisplayGroupByName('NV RX');
  MedsInDlgIen  := DlgIENForName('PSJ OR PAT OE');
  MedsOutDlgIen := DlgIENForName('PSO OERR');
  MedsNVADlgIen := DlgIENForName('PSH OERR');
  MedsIVDlgIen := DlgIENForName('PSJI OR PAT FLUID OE');
  MedsInDlgFormId  := FormIDForDialog(MedsInDlgIen);
  MedsOutDlgFormId := FormIDForDialog(MedsOutDlgIen);
  MedsNVADlgFormID := FormIDForDialog(MedsNVADlgIen);
  MedsIVDlgFormID := FormIDForDialog(MedsIVDlgIen);
end;

function GMRCCanCloseDialog(dialog : TfrmODBase) : Boolean;
begin
  //wat-added 'GMRC' to name to show only applies to GMRC order dialogs
  //other dialogs could be added in the future as needed w/name updated accordingly
  result := True;
  if uOrderDialog.FillerID = 'GMRC' then
    result := fODConsult.CanFreeConsultDialog(dialog)
            or fODProc.CanFreeProcDialog(dialog);
end;

function IsValidActionOnComplexOrder(AnOrderID, AnAction: string;
    AListBox: TListBox; var CheckedList: TStringList; var ErrMsg: string; var ParentOrderID: string): boolean;  //PSI-COMPLEX
const
  COMPLEX_SIGN  = 'You have requested to sign a medication order which was entered as part of a complex order.' +
    'The following are the orders associated with the same complex order.';
  COMPLEX_SIGN1 = ' Do you want to sign all of these orders?';

  COMPLEX_DC  = 'You have requested to discontinue a medication order which was entered as part of a complex order.' +
    ' The following are all of the associated orders.';
  COMPLEX_DC1 =' Do you want to dicscontinue all of them?';

  COMPLEX_HD  = 'You have requested to hold a medication order which was entered as part of a complex order.' +
    ' The following are all of the associated orders.';
  COMPLEX_HD1 = ' Do you want to hold all of them?';

  COMPLEX_UNHD  = 'You have requested to release the hold of a medication order which was entered as part of a complex order.' +
    ' The following are all of the associated orders.';
  COMPLEX_UNHD1 = ' Do you want to release all of them?';

  COMPLEX_RENEW = 'You can not take the renew action on a complex medication which has the following associated orders.';
  COMPLEX_RENEW1 = ' You must enter a new order.';

  COMPLEX_VERIFY ='You have requested to verify a medication order which was entered as part of a complex order.' +
    ' The following are all of the associated orders.';
  COMPLEX_VERIFY1 =' Do you want to verify all of them?';

  COMPLEX_OTHER = 'You can not take this action on a complex medication which has the following associated orders.'
    + ' You must enter a new order.';

  COMPLEX_CANRENEW1 = 'The selected order for renew: ';
  COMPLEX_CANRENEW2 = ' is a part of a complex order.';
  COMPLEX_CANRENEW3 = 'The following whole complex order will be renewed.';
var
  CurrentActID, POrderTxt, AChildOrderTxt, CplxOrderMsg: string;
  ChildList,ChildIdxList,ChildTxtList, CategoryList: TStringList;
  ShowCancelButton: boolean;
  procedure RetrieveOrderTextPSI(AOrderList: TStringList; var AODTextList, AnIdxList: TStringList;
    TheAction: string; AParentID: string = '');
  var
    ix,jx: integer;
    tempid: string;
  begin
    for ix := 0 to AOrderList.count - 1  do
    begin
      if AListBox.Name = 'lstOrders' then  with AListBox do
      begin
        for jx := 0 to Items.Count - 1 do
          if TOrder(Items.Objects[jx]).ID = AOrderList[ix] then
          begin
            TOrder(Items.Objects[jx]).ParentID := AParentID;
            if CategoryList.IndexOf(TheAction)>-1 then
              Selected[jx] := True;
            AODTextList.Add(TOrder(Items.Objects[jx]).ID + '^' + TOrder(Items.Objects[jx]).Text);
            if AnIdxList.IndexOf(IntToStr(jx)) > -1 then
              continue;
            AnIdxList.Add(IntToStr(jx));
          end;
      end
      else if (AListBox.Name = 'lstMedsOut' ) or (AListBox.Name = 'lstMedsIn')
              or (AListBox.Name = 'lstMedsNonVA') then with AListBox do
      begin
         for jx := 0 to Items.Count - 1 do
         begin
          tempid := TMedListRec(AListBox.Items.Objects[jx]).OrderID;
          if tempid = AOrderList[ix] then
          begin
            if CategoryList.IndexOf(TheAction)>-1 then
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
    dix: integer;
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

  function MakeMessage(ErrMsg1,ErrMsg2,ErrMsg3: string): string;
  begin
    if Length(ErrMsg1)>0 then
      Result := ErrMsg1 + ErrMsg2
    else
      Result := ErrMsg2 + ErrMsg3;
  end;

begin
  Result := True;
  if AnAction = OA_COPY then Exit;
  CurrentActID := Piece(AnOrderID,';',2);
  CplxOrderMsg := '';
  CategoryList := TStringList.Create;
  CategoryList.Add('DC');
  CategoryList.Add('HD');
  CategoryList.Add('RL');
  CategoryList.Add('VR');
  CategoryList.Add('ES');
  ShowCancelButton := False;

  if Length(ErrMsg)>0 then ErrMsg := ErrMsg + #13#13;
  ValidateComplexOrderAct(AnOrderID,CplxOrderMsg);
  if Pos('COMPLEX-PSI',CplxOrderMsg)>0 then
  begin
    ParentOrderID := Piece(CplxOrderMsg,'^',2);
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
    GetChildrenOfComplexOrder(ParentOrderID,CurrentActID,ChildList);
    ChildtxtList := TStringList.Create;
    ChildIdxList := TStringList.Create;
    RetrieveOrderTextPSI(ChildList,ChildtxtList,ChildIdxList,AnAction,ParentOrderID);
    if ChildtxtList.Count > 0 then
    begin
      if (AnAction = 'RN') or (AnAction = 'EV') then
      begin
        if not IsValidSchedule(ParentOrderID) then
        begin
          POrderTxt := RetrieveOrderText(ParentOrderID);
          if CharAt(POrderTxt,1)='+' then
            POrderTxt := Copy(POrderTxt,2,Length(POrderTxt));
          if Pos('First Dose NOW',POrderTxt)>1 then
            Delete(POrderTxt, Pos('First Dose NOW',POrderTxt), Length('First Dose Now'));
          InfoBox('Invalid schedule!' + #13#13 + 'The selected order is a part of a complex order:' + #13
            + POrderTxt + #13#13 + ' It contains an invalid schedule.',
            'Warning', MB_OK or MB_ICONWARNING);
          DeselectChild(ChildIdxList);
          Result := False;
          ErrMsg := '';
          ChildtxtList.Free;
          ChildList.Clear;
          ChildList.Free;
          CategoryList.Clear;
          Exit;
        end;
      end;
      if AnAction = OA_DC then
      begin
        if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_DC,COMPLEX_DC1),True) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_SIGN then
      begin
        if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_SIGN,COMPLEX_SIGN1),True) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_HOLD then
      begin
        if Length(ErrMsg) < 1 then ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_HD,COMPLEX_HD1),ShowCancelButton) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_UNHOLD then
      begin
        if Length(ErrMsg) < 1 then ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_UNHD,COMPLEX_UNHD1),ShowCancelButton) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_VERIFY then
      begin
        if Length(ErrMsg) < 1 then ShowCancelButton := True;
        if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_VERIFY,COMPLEX_VERIFY1),ShowCancelButton) then
        begin
          DeselectChild(ChildIdxList);
          Result := False;
        end;
      end
      else if AnAction = OA_RENEW then
      begin
        if not IsRenewableComplexOrder(ParentOrderID) then
        begin
          if not ActionOnComplexOrder(ChildtxtList,MakeMessage(ErrMsg,COMPLEX_RENEW,COMPLEX_RENEW1),False) then
          begin
            DeselectChild(ChildIdxList);
            Result := False;
          end;
        end
        else
        begin
          POrderTxt := RetrieveOrderText(ParentOrderID);
          if CharAt(POrderTxt,1)='+' then
            POrderTxt := Copy(POrderTxt,2,Length(POrderTxt));
          if Pos('First Dose NOW',POrderTxt)>1 then
            Delete(POrderTxt, Pos('First Dose NOW',POrderTxt), Length('First Dose Now'));
          AChildOrderTxt := RetrieveOrderText(AnOrderID);
          if InfoBox(COMPLEX_CANRENEW1 + #13 + AChildOrderTxt
            + COMPLEX_CANRENEW2 + #13#13
            + COMPLEX_CANRENEW3 + #13 +  POrderTxt,
            'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDOK then
          begin
            if AListBox.Name = 'lstOrders' then
              frmOrders.ParentComplexOrderID := ParentOrderID;
            if (AListBox.Name = 'lstMedsOut' ) or (AListBox.Name = 'lstMedsIn') then
              frmMeds.ParentComplexOrderID := ParentOrderID;
          end;
          DeselectChild(ChildIdxList);
        end;
      end;
    end;
    ErrMsg := '';
    ChildtxtList.Free;
    ChildList.Clear;
    ChildList.Free;
  end;
  CategoryList.Clear;
end;

{ Write New Orders }

function ActivateAction(const AnID: string; AnOwner: TComponent; ARefNum: Integer): Boolean;
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
      OM_ALLERGY:     if ARTPatchInstalled then
                      begin
//                        DialogClass := TfrmARTAllergy;
                          EnterEditAllergy(0, TRUE, FALSE, AnOwner, ARefNum);
                          Result := True;
//                          uOrderMenu.Close;
                          Exit;
                      end
                      else
                        begin
                          Result := False;
                          Exit;
                        end;
      OM_HTML:        DialogClass := TfrmOMHTML;
      999999:         DialogClass := TfrmOMAction;  // for testing!!!
    else
      Exit;
    end;
    if AnOwner = nil then AnOwner := Application;
    uOrderAction := DialogClass.Create(AnOwner);
    if (uOrderAction <> nil) (*and (not uOrderAction.AbortAction) *)then
    begin
      uOrderAction.CallOnExit := DestroyingOrderAction;
      uOrderAction.RefNum := ARefNum;
      uOrderAction.OrderDialog := StrToIntDef(Piece(AnID, ';', 1), 0);
      Result := True;
      if (not uOrderAction.AbortAction) then uOrderAction.ShowModal;
    end;
  end else
  begin
    //Show508Message('Order Dialogs of type "Action" are available in List Manager only.');
    Result := False;
  end;
end;

function ActivateOrderDialog(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer; ANeedVerify: boolean = True): Boolean;
const
  TX_DEAFAIL1   = 'Order for controlled substance,' + CRLF;
  TX_DEAFAIL2   = CRLF + 'could not be completed. Provider does not have a' + CRLF +
                  'current, valid DEA# on record and is ineligible' + CRLF + 'to sign the order.';
  TX_SCHFAIL    = CRLF + 'could not be completed. Provider is not authorized' + CRLF +
                  'to prescribe medications in Federal Schedule ';
  TX_NO_DETOX   = CRLF + 'could not be completed. Provider does not have a' + CRLF +
                  'valid Detoxification/Maintenance ID number on' + CRLF +
                  'record and is ineligible to sign the order.';
  TX_EXP_DETOX1 = CRLF + 'could not be completed. Provider''s Detoxification/Maintenance' + CRLF +
                  'ID number expired due to an expired DEA# on ';
  TX_EXP_DETOX2 = '.' + CRLF + 'Provider is ineligible to sign the order.';
  TX_EXP_DEA1   = CRLF + 'could not be completed. Provider''s DEA# expired on ';
  TX_EXP_DEA2   = CRLF + 'and no VA# is assigned. Provider is ineligible to sign the order.';
  TX_INSTRUCT   = CRLF + CRLF + 'Click RETRY to select another provider.' + CRLF + 'Click CANCEL to cancel the current order.';
  TC_DEAFAIL    = 'Order not completed';
  TC_IMO_ERROR  = 'Inpatient medication order on outpatient authorization required';
  TX_EVTDEL_DIET_CONFLICT = 'Have you done either of the above?';
  TC_EVTDEL_DIET_CONFLICT = 'Possible delayed order conflict';
  TX_INACTIVE_SVC = 'This consult service is currently inactive and not receiving requests.' + CRLF +
                    'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TX_INACTIVE_SVC_CAP = 'Inactive Service';
  TX_NO_SVC = 'The order or quick order you have selected does not specify a consult service.' + CRLF +
              'Please contact your Clinical Coordinator/IRM staff to fix this order.';
  TC_NO_SVC = 'No service specified';
var
  ResolvedDialog: TOrderDialogResolved;
  x, EditedOrder, chkCopay, OrderID, PkgInfo,OrderPtEvtID,OrderEvtID,NssErr, tempUnit, tempSupply, tempDrug, tempSch: string;
  temp,tempDur,tempQuantity, tempRefills: string;
  i, ODItem, tempOI, ALTOI: integer;
  DrugCheck, InptDlg, IsAnIMOOrder, DrugTestDlgType: boolean;
  IsPsoSupply,IsDischargeOrPass,IsPharmacyOrder,IsConsultOrder,ForIMO, IsNewOrder: boolean;
  tmpResp: TResponse;
  CxMsg: string;
  AButton: TButton;
  SvcIEN: string;
  //CsltFrmID: integer;
  FirstNumericPos: Integer;
  DEAFailStr, TX_INFO: string;

begin
  IsPsoSupply := False;
  Result := False;
  IsDischargeOrPass := False;
  IsAnIMOOrder  := False;
  ForIMO := False;
  IsNewOrder := True;
  PassDrugTstCall := False;
  DrugCheck := false;
  DrugTestDlgType := false;
  InptDlg := False;
  //We need to get the first numeric postion
  for FirstNumericPos := 1 to Length(AnID) do begin
   if AnID[FirstNumericPos] in ['0'..'9'] then break;
  end;

  //QOAltOI.OI := 0;
  Application.ProcessMessages;
  // double check environment before continuing with order
  if uOrderDialog <> nil then uOrderDialog.Close; // then x := uOrderDialog.Name else x := '';
  //if ShowMsgOn(uOrderDialog <> nil, TX_DLG_ERR + CRLF + x, TC_DLG_ERR) then Exit;

  if CharAt(AnID, 1) = 'X' then
  begin
    IsNewOrder := False;
   // if PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E')=false then Exit;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_CHANGE,   x);
    if ( Length(x)<1 ) and not (AnEvent.EventIFN > 0) then
      ValidateComplexOrderAct(Copy(AnID, 2, Length(AnID)),x);
    if (Pos('COMPLEX-PSI',x)>0) then
      x := TX_COMPLEX;
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_CHANGE) then Exit;
    DrugCheck := true;
  end;
  if CharAt(AnID, 1) = 'C' then
  begin
    IsNewOrder := False;
    //if PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E')=false then Exit;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_COPY,     x);
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_COPY) then Exit;
    DrugCheck := true;
 end;
  if CharAt(AnID, 1) = 'T' then
  begin
    IsNewOrder := False;
    if (XfInToOutNow = true) and (PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E', false)=false) then Exit;
    if (XfInToOutNow = false) then
      begin
       if (XferOuttoInOnMeds = True) and (PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E', true)=false) then Exit;
       if (XferOuttoInOnMeds = False) and (PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E', False)=false) then Exit;
      end;
    ValidateOrderAction(Copy(AnID, 2, Length(AnID)), OA_TRANSFER, x);
    if Length(x) > 0 then
      x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#10 + x;
    if ShowMsgOn(Length(x) > 0, x, TC_NO_XFER) then Exit;
  end;
  if not IMOActionValidation(AnID, IsAnIMOOrder, x, AnEvent.EventType) then
  begin
    ShowMsgOn(Length(x) > 0, x, TC_IMO_ERROR);
    Exit;
  end;
  if ( (StrToIntDef(AnId,0)>0) and (AnEvent.EventIFN <= 0) ) then
    ForIMO := IsIMODialog(StrToInt(AnId))
  else if ( (IsAnIMOOrder) and (AnEvent.EventIFN <= 0) ) then
    ForIMO := True;
  OrderPtEvtID := GetOrderPtEvtID(Copy(AnID, 2, Length(AnID)));
  OrderEvtID := Piece(EventInfo(OrderPtEvtID),'^',2);
  //CQ 18660 Orders for events should be modal. Orders for non-event should not be modal
  if AnEvent.EventIFN > 0 then frmOrders.NeedShowModal := true
  else frmOrders.NeedShowModal := false;
  // evaluate order dialog, build response list & see what form should be presented
  FillChar(ResolvedDialog, SizeOf(ResolvedDialog), #0);
  ResolvedDialog.InputID := AnID;
  BuildResponses(ResolvedDialog, GetKeyVars, AnEvent, ForIMO);
  if (ResolvedDialog.DisplayGroup = InPtDisp) or (ResolvedDialog.DisplayGroup = ClinDisp) then DrugTestDlgType := true;
  if (DrugCheck = true) and (ResolvedDialog.DisplayGroup = OutPtDisp) and
  (PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E', false)=false) then Exit;
  if (DrugCheck = true) and (DrugTestDlgType = true) and (PassDrugTest(StrtoINT(Copy(AnID, FirstNumericPos, (Pos(';', AnID) - FirstNumericPos))), 'E', true)=false) then Exit;
  if (IsNewOrder = True) and (ResolvedDialog.DialogType = 'Q') and
     ((ResolvedDialog.DisplayGroup = OutptDisp) or (DrugTestDlgType = true)) then
    begin
      if (PassDrugTest(ResolvedDialog.DialogIEN, 'Q', DrugTestDlgType)=false) then Exit
      else PassDrugTstCall := True;
    end;
  if (ForIMO and ( (ResolvedDialog.DialogIEN = MedsInDlgIen)
    or (ResolvedDialog.DialogIEN = MedsIVDlgIen)) ) then
    ResolvedDialog.DisplayGroup := ClinDisp;
  ResetDialogProperties(AnID, AnEvent, ResolvedDialog);
 {* AGP CHANGE 26.20 Remove restriction to allowed for ordering of inpatient medication for an inpatient from an outpatient location
   //jd imo change
   if (ResolvedDialog.DisplayGroup = InptDisp) and (Patient.Inpatient) and (AnEvent.EventIFN < 1) then
   begin
     if IsClinicLoc(Encounter.Location) then
     begin
       MessageDlg(TX_NOINPT, mtWarning, [mbOK], 0);
       Exit;
     end;
   end;
   //jd imo change end  *}
   if (ResolvedDialog.DisplayGroup = InptDisp) or
      (ResolvedDialog.DisplayGroup = OutptDisp) or
      (ResolvedDialog.DisplayGroup = MedsDisp) or
      (ResolvedDialog.DisplayGroup = IVDisp) or
      (ResolvedDialog.DisplayGroup =  NonVADisp) or
      (ResolvedDialog.DisplayGroup =  ClinDisp) then  IsPharmacyOrder := True
   else
      IsPharmacyOrder := False;
   (*  IsPharmacyOrder := ResolvedDialog.DisplayGroup in [InptDisp, OutptDisp,
        MedsDisp,IVDisp, NonVADisp, ClinDisp];*)   //v25.27 range check error - RV
  IsConsultOrder := ResolvedDialog.DisplayGroup in [CsltDisp,ProcDisp];
  if (uAutoAC) and (not (ResolvedDialog.QuickLevel in [QL_REJECT,QL_CANCEL]))
    and (not IsPharmacyOrder) and (not IsConsultOrder) then
    ResolvedDialog.QuickLevel := QL_AUTO;
  if (ResolvedDialog.DialogType = 'Q')
    and (ResolvedDialog.DisplayGroup = InptDisp) then
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
  if ResolvedDialog.DisplayGroup = InptDisp then       //nss
  begin
    if (CharAt(AnID, 1) = 'C') or (CharAt(AnID, 1) = 'T') or (CharAt(AnID, 1) = 'X') then
    begin
      if not IsValidSchedule(Copy(AnID, 2, Length(AnID))) then
      begin
        ShowMsg('The order contains invalid non-standard schedule.');
        NSSchedule := True;
      end;
    end;
    if NSSchedule then ResolvedDialog.QuickLevel := 0;
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
  //   ((ResolvedDialog.DisplayGroup = InptDisp) or (ResolvedDialog.DisplayGroup = OutptDisp) or (ResolvedDialog.DisplayGroup = MedsDisp)) then
 //    ResolvedDialog.QuickLevel := 0;
  with ResolvedDialog do if (QuickLevel = QL_VERIFY) and (HasTemplateField(ShowText)) then QuickLevel := QL_DIALOG;

  // Check for potential conflicting auto-accept delayed-release diet orders (CQ #10946 - v27.36 - RV)
  with ResolvedDialog do if (QuickLevel = QL_AUTO) and (DisplayGroup = DietDisp) and (AnEvent.EventType <> 'C') then
  begin
    AButton := TButton.Create(Application);
    try
      CheckForAutoDCDietOrders(AnEvent.EventIFN, DisplayGroup, '', CxMsg, AButton);
      if CxMsg <> '' then
      begin
        if InfoBox(CxMsg + CRLF + CRLF + TX_EVTDEL_DIET_CONFLICT,
           TC_EVTDEL_DIET_CONFLICT,
           MB_ICONWARNING or MB_YESNO) = ID_NO
           then QuickLevel := QL_DIALOG;
      end;
    finally
      AButton.Free;
    end;
  end;

  with ResolvedDialog do
  begin
    if QuickLevel = QL_REJECT then InfoBox(ShowText, TC_DLG_REJECT, MB_OK);
    if (QuickLevel = QL_VERIFY) and (IsPharmacyOrder or ANeedVerify) then  ShowVerifyText(QuickLevel, ShowText, DisplayGroup=InptDisp);
    if QuickLevel = QL_AUTO then
    begin
      //CsltFrmID := FormID;
      FormID := OD_AUTOACK;
    end;
    if (QuickLevel = QL_REJECT) or (QuickLevel = QL_CANCEL) then Exit;
    PushKeyVars(ResolvedDialog.QOKeyVars);
  end;
  if ShowMsgOn(not (ResolvedDialog.FormID > 0), TX_NOFORM, TC_NOFORM) then Exit;
  with ResolvedDialog do if DialogType = 'X' then
  begin
    EditedOrder := Copy(Piece(ResponseID, '-', 1), 2, Length(ResponseID));
  end
  else EditedOrder := '';
  if XfInToOutNow then
  begin
     //if Transfer an order to outpatient and release immediately
     // then changing the Eventtype to 'C' instead of 'D'
     IsDischargeOrPass := True;
     AnEvent.EventType := 'C';
     AnEvent.Effective := 0;
  end;
  uOrderDialog := CreateOrderDialog(AnOwner, ResolvedDialog.FormID, AnEvent, StrToIntDef(OrderEvtID,0));
  uOrderDialog.IsSupply := IsPsoSupply;

  {For copy, change, transfer actions on an None-IMO order, the new order should not be treated as IMO order
   although the IMO criteria could be met. }
  //if (uOrderDialog.IsIMO) and (CharAt(AnID, 1) in ['X','C','T']) then
  if not uOrderDialog.IsIMO then
    uOrderDialog.IsIMO := ForIMO;

  if (ResolvedDialog.DialogType = 'Q') and (ResolvedDialog.DisplayGroup in [MedsDisp, OutptDisp, InptDisp]) then
     begin
       if DoesOIPIInSigForQO(StrToInt(ResolvedDialog.InputID))=1 then
         uOrderDialog.IncludeOIPI := True
       else
         uOrderDialog.IncludeOIPI := False;
     end;

  if (uOrderDialog <> nil) and not uOrderDialog.Closing then with uOrderDialog do
        begin
          SetKeyVariables(GetKeyVars);

          if IsDischargeOrPass then
            EvtForPassDischarge  := 'D'
          else
            EvtForPassDischarge  := #0;

          Responses.SetEventDelay(AnEvent);
          Responses.LogTime := uOrderSetTime;
          DisplayGroup := ResolvedDialog.DisplayGroup;  // used to pass ORTO
          DialogIEN    := ResolvedDialog.DialogIEN;     // used to pass ORIT
          RefNum := ARefNum;

          case ResolvedDialog.DialogType of
          'C': SetupDialog(ORDER_COPY,  ResolvedDialog.ResponseID);
          'D': SetupDialog(ORDER_NEW,   '');
          'X':
                begin
                   SetupDialog(ORDER_EDIT,  ResolvedDialog.ResponseID);
                   OrderID := Copy(ResolvedDialog.ResponseID,2,Length(ResolvedDialog.ResponseID));
                   //IsInpatient := OrderForInpatient;
                   ODItem := StrToIntDef(Responses.IValueFor('ORDERABLE', 1), 0);
                   PkgInfo := '';
                   DEAFailStr := '';
                   if Length(OrderID)>0 then
                     PkgInfo := GetPackageByOrderID(OrderID);
                   if Pos('PS',PkgInfo)=1 then
                   begin
                     if PkgInfo = 'PSO' then InptDlg := False
                     else if PkgInfo = 'PSJ' then InptDlg := True;
                     DEAFailStr := DEACheckFailed(ODItem, InptDlg);
                     while (StrToIntDef(Piece(DEAFailStr,U,1),0) in [1..5]) and (uOrderDialog.FillerID <> 'PSH') do
                     begin
                       case StrToIntDef(Piece(DEAFailStr,U,1),0) of
                         1: TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 + TX_DEAFAIL2;  //prescriber has an invalid or no DEA#
                         2: TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 + TX_SCHFAIL + Piece(DEAFailStr,U,2) + '.';  //prescriber has no schedule privileges in 2,2N,3,3N,4, or 5
                         3: TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 + TX_NO_DETOX;  //prescriber has an invalid or no Detox#
                         4: TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 + TX_EXP_DEA1 + Piece(DEAFailStr,U,2) + TX_EXP_DEA2;  //prescriber's DEA# expired and no VA# is assigned
                         5: TX_INFO := TX_DEAFAIL1 + #13 + Responses.OrderText + #13 + TX_EXP_DETOX1 + Piece(DEAFailStr,U,2) + TX_EXP_DETOX2;  //valid detox#, but expired DEA#
                       end;
                       if InfoBox(TX_INFO + TX_INSTRUCT, TC_DEAFAIL, MB_RETRYCANCEL) = IDRETRY then
                         begin
                           DEAContext := True;
                           fFrame.frmFrame.mnuFileEncounterClick(uOrderDialog);
                           DEAFailStr := '';
                           DEAFailStr := DEACheckFailed(ODItem, InptDlg);
                         end
                       else
                         begin
                           if (ResolvedDialog.DialogType = 'X') and not Changes.ExistForOrder(EditedOrder)
                           then UnlockOrder(EditedOrder);
                           uOrderDialog.Close;
                           Exit;
                         end;
                     end;
                   end;
                end;
          'Q':
                begin
                  if IsPSOSupplyDlg(ResolvedDialog.DialogIEN,1) then
                    uOrderDialog.IsSupply := True;
                  SetupDialog(ORDER_QUICK, ResolvedDialog.ResponseID);
                  {if ((ResolvedDialog.DisplayGroup = CsltDisp)
                    and (ResolvedDialog.QuickLevel = QL_AUTO)) then
                    TfrmODCslt.SetupDialog(ORDER_QUICK, ResolvedDialog.ResponseID);}
                end;
          end;

           if Assigned(uOrderDialog) then
            with uOrderDialog do
              if AbortOrder and GMRCCanCloseDialog(uOrderDialog) then
                begin
                  Close;
                  if Assigned(uOrderDialog) then
                    uOrderDialog.Destroy;
                  Exit;
                end;

          if CharAt(AnID, 1) = 'T' then
             begin
               if ARefNum = -2 then
                 Responses.TransferOrder := '';
               if ARefNum = -1 then
                 Responses.TransferOrder := AnID;
             end;

          if CharAt(AnID,1) = 'C' then            ////////////////////////////////////////////////////////////////////////
             begin
               chkCopay := Copy(AnID,2,length(AnID)); //STRIP prepended C, T, or X from first position in order ID.
               SetDefaultCoPay(chkCopay);
             end;                                    ////////////////////////////////////////////////////////////////////////'

          if IsConsultOrder and (CharAt(AnID,1) = 'C') then
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
               if CharAt(AnID, 1) in ['C','T','X'] then
                  begin
                  Position := poScreenCenter;
                  FormStyle := fsNormal;
                  ShowModal;
                  Result := uOrderDialog.AcceptOK;
                  end
               else
                  begin
                    SetBounds(frmFrame.Left + 112, frmFrame.Top + frmFrame.Height - Height, Width, Height);
                    SetFormPosition(uOrderDialog);
                    FormStyle := fsStayOnTop;
                    if frmOrders.NeedShowModal then
                       begin
                       ShowModal;
                       Result := uOrderDialog.AcceptOK;
                       uOrderDialog.Destroy;
                       end
                    else
                       begin
                       Show;
                       Result := True;
                       end;
                 end;
             end
          else
             begin
             if uOrderDialog.DisplayGroup = OutptDisp then
               begin
                 tempUnit := '';
                 tempSupply := '';
                 tempDrug := '';
                 tempSch := '';
                 tempDur := '';
                 tmpResp := uOrderDialog.Responses.FindResponseByName('SUPPLY', 1);
                 if tmpResp = nil then tempSupply := '0'
                 else tempSupply := tmpResp.EValue;
                 tmpResp := uOrderDialog.Responses.FindResponseByName('QTY', 1);
                 if tmpResp = nil then tempQuantity := '0'
                 else tempQuantity := tmpResp.EValue;
                 tmpResp := uOrderDialog.Responses.FindResponseByName('REFILLS', 1);
                 if tmpResp = nil then tempRefills := '0'
                 else tempRefills := tmpResp.EValue;
                 tmpResp := uOrderDialog.Responses.FindResponseByName('ORDERABLE', 1);
                 tempOI := StrToIntDef(tmpResp.IValue,0);
                 i := uORderDialog.Responses.NextInstance('DOSE',0);
                 while i > 0 do
                   begin
                      x := Piece(uOrderDialog.Responses.IValueFor('DOSE',i), '&', 3);
                      tempUnit := tempUnit + X + U;
                      x := uOrderDialog.Responses.IValueFor('SCHEDULE',i);
                      tempSch := tempSch + x + U;
                      x := uOrderDialog.Responses.IValueFor('DRUG', i);
                      tempDrug := Piece(x, U, 1);
                      i := Responses.NextInstance('DOSE', i);
                      x := UORderDialog.Responses.IValueFor('DAYS', i);
                      tempDur := tempDur + x + '~';
                      x := uOrderDialog.Responses.IValueFor('CONJ', i);
                      tempDur := tempDur + x + U;
                   end;
                 if ValidateDrugAutoAccept(tempDrug, tempUnit, tempSch, tempDur, tempOI, StrtoInt(tempSupply), StrtoInt(tempRefills), StrToFloat(tempQuantity)) = false then Exit;
               end;
             if ((ResolvedDialog.DisplayGroup = CsltDisp) and (ResolvedDialog.QuickLevel = QL_AUTO)) then
             begin
               with Responses do
               begin
                 Changing := True;
                 tmpResp := TResponse(FindResponseByName('ORDERABLE',1));
                 if tmpResp <> nil then
                   SvcIEN := GetServiceIEN(tmpResp.IValue)
                 else
                 begin
                   InfoBox(TX_NO_SVC, TC_NO_SVC, MB_ICONERROR or MB_OK);
                   //AbortOrder := True;
                   //Close;
                   Exit;
                 end;
                 if SvcIEN = '-1' then
                 begin
                   InfoBox(TX_INACTIVE_SVC, TX_INACTIVE_SVC_CAP, MB_OK);
                   //AbortOrder := True;
                   //Close;
                   Exit;
                 end;
               end;
             end;
             cmdAcceptClick(Application);  // auto-accept order
             Result := uOrderDialog.AcceptOK;
             if (result = true) and (ScreenReaderActive) then
               GetScreenReader.Speak('Auto Accept Quick Order '+ Responses.DialogDisplayName + ' placed.');

             //BAPHII 1.3.2
             //Show508Message('DEBUG: About to copy BA CI''s to copied order from Order: '+AnID+'#13'+' in uOrders.ActivateOrderDialog()');

             //End BAPHII 1.3.2

             if Assigned(uOrderDialog) then
               uOrderDialog.Destroy;
             end;

        end
  else
     begin
       uOrderDialog.Release;
       Result := False;
     //Application.ProcessMessages;       // to allow dialog to finish closing
     //Exit;                              // so result is not returned true
     end;

  if NSSchedule then
    NSSchedule := False;

  if (ResolvedDialog.DialogType = 'X') and not Changes.ExistForOrder(EditedOrder)
    then UnlockOrder(EditedOrder);
  //QOAltOI.OI := 0;
end;

function RetrieveOrderText(AnOrderID: string): string;
var
  OrdList: TList;
  theOrder: TOrder;
 // i: integer;
begin
 // if Assigned(OrdList) then
 // begin
 //    for i := 0 to pred(OrdList.Count) do
 //       TObject(OrdList[i]).Free;
  //   UBAGlobals.tempDxList := nil;
 // end;
  OrdList := TList.Create;
  theOrder := TOrder.Create;
  theOrder.ID := AnOrderID;
  OrdList.Add(theOrder);
  RetrieveOrderFields(OrdList, 0, 0);
  Result := TOrder(OrdList.Items[0]).Text;
  if Assigned(OrdList) then OrdList.Free; //CQ:7554
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
  if ShowMsgOn(Length(x) > 0, x, TC_DISABLED) then Exit;
  if uOrderHTML = nil then
  begin
    uOrderHTML := TfrmOMHTML.Create(AnOwner);
    with uOrderHTML do
    begin
      SetBounds(frmFrame.Left + 112, frmFrame.Top + frmFrame.Height - Height, Width, Height);
      SetFormPosition(uOrderHTML);
      FormStyle := fsStayOnTop;
      SetEventDelay(AnEvent);
    end;
  end;
  uOrderHTML.Dialog  := DialogIEN;
  uOrderHTML.RefNum  := ARefNum;
  uOrderHTML.OwnedBy := AnOwner;
  uOrderHTML.ShowModal;
  ASetList := TStringList.Create;
  FastAssign(uOrderHTML.SetList, ASetList);
  uOrderHTML.Release;
  if ASetList.Count = 0 then Exit;
  Result := ActivateOrderList(ASetList, AnEvent, AnOwner, ARefNum, '', '');
end;

function ActivateOrderMenu(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
var
  MenuIEN: Integer;
  x: string;
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
      SetFormPosition(uOrderMenu);
      FormStyle := fsStayOnTop;
      SetEventDelay(AnEvent);
    end;
  end;
  uOrderMenu.SetNewMenu(MenuIEN, AnOwner, ARefNum);
  if not uOrderMenu.Showing then uOrderMenu.Show else uOrderMenu.BringToFront;
  Result := True;
end;

function ActivateOrderSet(const AnID: string; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer): Boolean;
var
  x, ACaption, KeyVarStr: string;
  SetList: TStringList;
  EvtDefaultDlg, PtEvtID: string;

  function TakeoutDuplicateDlg(var AdlgList: TStringList; ANeedle: string): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to AdlgList.Count - 1 do
    begin
      if Piece(AdlgList[i],'^',1)=ANeedle then
      begin
        ADlgList.Delete(i);
        Result := True;
        Break;
      end;
    end;
  end;

begin
  Result := False;
  x := OrderDisabledMessage(StrToIntDef(AnID, 0));
  if ShowMsgOn(Length(x) > 0, x, TC_DISABLED) then Exit;
  SetList := TStringList.Create;
  try
    if uOrderSetTime = 0 then uOrderSetTime := FMNow;
    LoadOrderSet(SetList, StrToIntDef(AnID, 0), KeyVarStr, ACaption);
    if (AnEvent.EventIFN>0) and isExistedEvent(Patient.DFN, IntToStr(AnEvent.EventIFN), PtEvtID) then
    begin
      EvtDefaultDlg := GetEventDefaultDlg(AnEvent.EventIFN);
      while TakeoutDuplicateDlg(SetList,EvtDefaultDlg) do
        TakeoutDuplicateDlg(SetList,EvtDefaultDlg);
    end;
    Result := ActivateOrderList(SetList, AnEvent, AnOwner, ARefNum, KeyVarStr, ACaption);
  finally
    SetList.Free;
  end;
end;

function ActivateOrderList(AList: TStringList; AnEvent: TOrderDelayEvent;
  AnOwner: TComponent; ARefNum: Integer; const KeyVarStr, ACaption: string): Boolean;
var
  InitialCall: Boolean;
  i: integer;
  str: string;
begin
  InitialCall := False;
  if ScreenReaderActive then
    begin
      for i := 0 to AList.Count - 1 do
         begin
           if Piece(Alist.Strings[i],U,2) = 'Q' then str := str + CRLF + 'Quick Order ' + Piece(Alist.Strings[i],U,3)
           else if Piece(Alist.Strings[i],U,2) = 'S' then str := str + CRLF + 'Order Set ' + Piece(Alist.Strings[i],U,3)
           else if Piece(Alist.Strings[i],U,2) = 'M' then str := str + CRLF + 'Order Menu ' + Piece(Alist.Strings[i],U,3)
           else if Piece(Alist.Strings[i],U,2) = 'A' then str := str + CRLF + 'Order Action ' + Piece(Alist.Strings[i],U,3)
           else str := str + CRLF + 'Order Dialog ' + Piece(Alist.Strings[i],U,3);
         end;
      if infoBox('This order set contains the following items:'+ CRLF + str + CRLF+ CRLF + 'Select the OK button to start this order set.' +
                 'To stop the order set while it is in process, press “Alt +F6” to navigate to the order set dialog, and select the Stop Order Set Button.', 'Starting Order Set'  ,MB_OKCANCEL) = IDCANCEL then
        begin
          Result := False;
          exit;
        end;
    end;
  if uOrderSet = nil then
  begin
    uOrderSet := TfrmOMSet.Create(AnOwner);
    uOrderSet.SetEventDelay(AnEvent);
    uOrderSet.RefNum := ARefNum;
    InitialCall := True;
  end;
  if InitialCall then with uOrderSet do
  begin
    if Length(ACaption) > 0 then Caption := ACaption;
    SetBounds(frmFrame.Left, frmFrame.Top + frmFrame.Height - Height, Width, Height);
    SetFormPosition(uOrderSet);
    Show;
  end;
  uOrderSet.InsertList(AList, AnOwner, ARefNum, KeyVarStr, AnEvent.EventType);
  Application.ProcessMessages;
  Result := uOrderSet <> nil;
end;

function ActiveOrdering: Boolean;
begin
  if (uOrderDialog = nil) and (uOrderMenu = nil) and (uOrderSet = nil) and
     (uOrderAction = nil) and (uOrderHTML = nil)
    then Result := False
    else Result := True;
end;

function CloseOrdering: Boolean;
begin
  Result := False;
  { if an order set is being processed, see if want to interupt }
  if uOrderSet <> nil then
  begin
    uOrderSet.Close;
    Application.ProcessMessages;
    if uOrderSet <> nil then Exit;
  end;
  { if another ordering dialog is showing, make sure it is closed first }
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    Application.ProcessMessages;  // allow close to finish
    if uOrderDialog <> nil then Exit;
  end;
  if uOrderHTML <> nil then
  begin
    uOrderHTML.Close;
    Application.ProcessMessages;  // allow browser to close
    Assert(uOrderHTML = nil);
  end;
  { close any open ordering menu }
  if uOrderMenu <> nil then
  begin
    uOrderMenu.Close;
    Application.ProcessMessages;  // allow menu to close
    Assert(uOrderMenu = nil);
  end;
  if uOrderAction <> nil then
  begin
    uOrderAction.Close;
    Application.ProcessMessages;
    if uOrderAction <> nil then Exit;
  end;
  if frmARTAllergy <> nil then   //SMT Add to account for allergies.
  begin
    frmARTAllergy.Close;
    Application.ProcessMessages;
    if frmARTAllergy <> nil then Exit;
  end;

  Result := True;
end;

function ReadyForNewOrder(AnEvent: TOrderDelayEvent): Boolean;
var
  x,tmpPtEvt: string;
begin
  Result := False;
  { make sure a location and provider are selected before ordering }
  if not AuthorizedUser then Exit;
  //Added to force users without the Provider or ORES key to select an a provider when adding new orders to existing delay orders
  if (not Patient.Inpatient) and (AnEvent.EventIFN > 0 ) then
    begin
      if (User.OrderRole = OR_PHYSICIAN) and (Encounter.Provider = User.DUZ) and (User.IsProvider) then
        x := ''
      else if not EncounterPresentEDO then Exit;
      x := '';
    end
  else
  begin
    if not EncounterPresent then Exit;
  end;
  { then try to lock the patient (provider & encounter checked first to not leave lock) }
  if not LockedForOrdering then Exit;
  { make sure any current ordering process has completed, but don't drop patient lock }
  uKeepLock := True;
  if not CloseOrdering then Exit;
  uKeepLock := False;
  { get the delay event for this order (if applicable) }
  if AnEvent.EventType in ['A','D','T','M','O'] then
  begin
    if (AnEvent.EventName = '') and (AnEvent.EventType <> 'D') then
      Exit;
    x := AnEvent.EventType + IntToStr(AnEvent.Specialty);
    if (uLastConfirm <> x ) and (not XfInToOutNow) then
    begin
      uLastConfirm := x;
      case AnEvent.EventType of
      'A','M','O','T': x := AnEvent.EventName;
      'D': x := 'Discharge';
      end;
      if isExistedEvent(Patient.DFN,IntToStr(AnEvent.EventIFN),tmpPtEvt) then
        if PtEvtEmpty(tmpPtEvt)then
          InfoBox(TX_DELAY + x + TX_DELAY1, TC_DELAY, MB_OK or MB_ICONWARNING);
    end;
  end
  else uLastConfirm := '';
  Result := True;
end;

function ReadyForNewOrder1(AnEvent: TOrderDelayEvent): Boolean;
var
  x: string;
begin
  Result := False;
  { make sure a location and provider are selected before ordering }
  if not AuthorizedUser then Exit;
  if (not Patient.Inpatient) and (AnEvent.EventIFN > 0 ) then x := ''
  else
  begin
    if not EncounterPresent then Exit;
  end;
  { then try to lock the patient (provider & encounter checked first to not leave lock) }
  if not LockedForOrdering then Exit;
  { make sure any current ordering process has completed, but don't drop patient lock }
  uKeepLock := True;
  if not CloseOrdering then Exit;
  uKeepLock := False;
  { get the delay event for this order (if applicable) }
  if AnEvent.EventType in ['A','D','T','M','O'] then
  begin
    x := AnEvent.EventType + IntToStr(AnEvent.Specialty);
    if (uLastConfirm <> x ) and (not XfInToOutNow) then
    begin
      uLastConfirm := x;
      case AnEvent.EventType of
      'A','M','T','O': x := AnEvent.EventName;
      'D': x := AnEvent.EventName;  //'D': x := 'Discharge';
      end;
    end;
  end
  else uLastConfirm := '';
  Result := True;
end;

procedure SetConfirmEventDelay;
begin
  uLastConfirm := '';
end;

procedure ChangeOrders(AList: TStringList; AnEvent: TOrderDelayEvent);
var
  i,txtOrder: Integer;
  FieldsForEditRenewOrder: TOrderRenewFields;
  param1, param2 : string;
  OrSts: integer;
  AnOrder: TOrder;
begin
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    Application.ProcessMessages;  // allow close to finish
  end;

  if not ActiveOrdering then      // allow change while entering new
    if not ReadyForNewOrder(AnEvent) then Exit;
  for i := 0 to AList.Count - 1 do
  begin
    //if it's for unreleased renewed orders, then go to fODChangeUnreleasedRenew and continue
    txtOrder := 0;
    FieldsForEditRenewOrder := TOrderRenewFields.Create;
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
      end else if txtOrder = 1 then
      begin
        param1 := FieldsForEditRenewOrder.StartTime;
        param2 := FieldsForEditRenewOrder.StopTime;
      end;
      UBAGlobals.SourceOrderID := AList[i]; //hds6265 added
      ExecuteChangeRenewedOrder(AList[i], param1, param2, txtOrder, AnEvent);
      AnOrder := TOrder.Create;
      SaveChangesOnRenewOrder(AnOrder, AList[i], param1, param2, txtOrder);
      AnOrder.ActionOn := AnOrder.ID + '=RN';
      SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(AnOrder));
      Application.ProcessMessages;
      Continue;
    end else FieldsForEditRenewOrder.Free;

    OrSts := GetOrderStatus(AList[i]);
    if ( AnsiCompareText(NameOfStatus(OrSts),'active') = 0 ) and (AnEvent.PtEventIFN > 0) then
      EventDefaultOD := 1;
    ActivateOrderDialog('X' + AList[i], AnEvent, Application, -1);  // X + ORIFN for change
    if EventDefaultOD = 1 then
      EventDefaultOD := 0;
    Application.ProcessMessages;  // give uOrderDialog a chance to go back to nil
    if BILLING_AWARE then //hds6265
    begin              //hds6265
      UBAGlobals.SourceOrderID := AList[i]; //hds6265
      UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID,UBAGLobals.TargetOrderID); //hds6265
    end;
  end;
  UnlockIfAble;
end;

function ChangeOrdersEvt(AnOrderID: string; AnEvent: TOrderDelayEvent): boolean;
begin
  Result := False;
  if uOrderDialog <> nil then
  begin
    uOrderDialog.Close;
    Application.ProcessMessages;
  end;
  if not ActiveOrdering then
    if not ReadyForNewOrder(AnEvent) then Exit;
  Result := ActivateOrderDialog('X' + AnOrderID, AnEvent, Application, -1);
  Application.ProcessMessages;
  UnlockIfAble;
end;

function CopyOrders(AList: TStringList; AnEvent: TOrderDelayEvent; var DoesEventOccur: boolean; ANeedVerify: boolean = True): boolean;
var
  i: Integer;
  xx: string;
  IsIMOOD,ForIVAlso: boolean;
begin
  Result := False;
  if not ReadyForNewOrder(AnEvent) then Exit;              // no copy while entering new
  for i := 0 to AList.Count - 1 do
     begin
       if (not DoesEventOccur) and (AnEvent.PtEventIFN>0) and IsCompletedPtEvt(AnEvent.PtEventIFN) then
          begin
            DoesEventOccur := True;
            AnEvent.EventType := #0;
            AnEvent.TheParent := TParentEvent.Create;
            AnEvent.EventIFN  := 0;
            AnEvent.EventName := '';
            AnEvent.PtEventIFN := 0;
          end;

       if CheckOrderGroup(AList[i])=1 then IsUDGroup := True
       else IsUDGroup := False;

       if (AnEvent.EventIFN>0) and isOnholdMedOrder(AList[i]) then
          begin
            xx := RetrieveOrderText(AList[i]);
            if InfoBox(TX_ONHOLD+#13#13+xx, 'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
              Continue;
          end;

       DEASig := GetDrugSchedule(AList[i]);
       ForIVAlso := ForIVandUD(AList[i]);
       IsIMOOD := IsIMOOrder(AList[i]);
       if (IsUDGroup) and (ImmdCopyAct) and (not Patient.Inpatient) and (AnEvent.EventType = 'C') and (not IsIMOOD) and (not ForIVAlso) then
            XfInToOutNow := True;

       OrderSource := 'C';

       if ActivateOrderDialog('C' + AList[i], AnEvent, Application, -1, ANeedVerify) then
         Result := True;

       Application.ProcessMessages;  // give uOrderDialog a chance to go back to nil
       OrderSource := '';

       if (not DoesEventOccur) and (AnEvent.PtEventIFN>0) and IsCompletedPtEvt(AnEvent.PtEventIFN) then
         DoesEventOccur := True;

       if IsUDGroup then IsUDGroup := False;
       if XfInToOutNOw then XfInToOutNow := False;

       if BILLING_AWARE then
       begin
          UBAGlobals.SourceOrderID := AList[i]; //BAPHII 1.3.2
          UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID,UBAGLobals.TargetOrderID);
       end;
     end; //for

  UnlockIfAble;
end;

function TransferOrders(AList: TStringList; AnEvent: TOrderDelayEvent; var DoesEventOccur: boolean; ANeedVerify: boolean = True): boolean;
var
  i, CountOfTfOrders: Integer;
  xx: string;
  //DoesEventOccur: boolean;
  //OccuredEvtID: integer;
  //OccuredEvtName: string;
begin
  //DoesEventOccur := False;
  //OccuredEvtID := 0;
  Result := False;
  if not ReadyForNewOrder(AnEvent) then Exit;              // no xfer while entering new
  CountOfTfOrders := AList.Count;
  for i := 0 to CountOfTfOrders - 1 do
  begin
    if (not DoesEventOccur) and (AnEvent.PtEventIFN>0) and IsCompletedPtEvt(AnEvent.PtEventIFN) then
    begin
      DoesEventOccur := True;
      //OccuredEvtID := AnEvent.PtEventIFN;
      //OccuredEvtName := AnEvent.EventName;
      AnEvent.EventType := #0;
      AnEvent.TheParent := TParentEvent.Create;
      AnEvent.EventIFN  := 0;
      AnEvent.EventName := '';
      AnEvent.PtEventIFN := 0;
    end;
    if i = CountOfTfOrders - 1 then
    begin
      if (AnEvent.EventIFN>0) and isOnholdMedOrder(AList[i]) then
      begin
        xx := RetrieveOrderText(AList[i]);
        if InfoBox(TX_ONHOLD+#13#13+xx, 'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
          Continue;
      end;
      OrderSource := 'X';
      if ActivateOrderDialog('T' + AList[i], AnEvent, Application, -2, ANeedVerify) then
        Result := True;
    end  else
    begin
      if (AnEvent.EventIFN>0) and isOnholdMedOrder(AList[i]) then
      begin
        xx := RetrieveOrderText(AList[i]);
        if InfoBox(TX_ONHOLD+#13#13+xx, 'Warning', MB_YESNO or MB_ICONWARNING) = IDNO then
          Continue;
      end;
      OrderSource := 'X';
      if ActivateOrderDialog('T' + AList[i], AnEvent, Application, -1, ANeedVerify) then
        Result := True;
    end;
    Application.ProcessMessages;  // give uOrderDialog a chance to go back to nil
    OrderSource := '';
    if (not DoesEventOccur) and (AnEvent.PtEventIFN>0) and IsCompletedPtEvt(AnEvent.PtEventIFN) then
      DoesEventOccur := True;

   UBAGlobals.SourceOrderID := AList[i];
   UBAGlobals.CopyTreatmentFactorsDxsToCopiedOrder(UBAGlobals.SourceOrderID, UBAGLobals.TargetOrderID);

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
  if ((AnAction = OA_HOLD) or (AnAction = OA_UNHOLD) or (AnAction = OA_RENEW)  or
      (AnAction = OA_DC) or (AnAction = OA_CHANGE)) and Changes.ExistForOrder(AnOrderID)
      then Exit;
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
  if uOrderMenu <> nil then uOrderMenu.cmdDoneClick(uOrderSet);
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
  if (uOrderDialog <> nil) and (uOrderDialog.Owner = AnOwner)
    then Result := uOrderDialog.RefNum
  else if (uOrderMenu <> nil) and (uOrderMenu.Owner = AnOwner)
    then Result := uOrderMenu.RefNum
  else if (uOrderHTML <> nil) and (uOrderHTML.Owner = AnOwner)
    then Result := uOrderHTML.RefNum
  else if (uOrderSet <> nil) and (uOrderSet.Owner = AnOwner)
    then Result := uOrderSet.RefNum
  else Result := -1;
end;

procedure PrintOrdersOnSignReleaseMult(OrderList, ClinicLst, WardLst: TStringList; Nature: Char; EncLoc, WardLoc: integer;
EncLocName, WardLocName: string);
var
i,j: integer;
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
            if Piece(OrderList.Strings[j], U,1) = tempOrder then tempOrderList.Add(OrderList.Strings[j]);
        end;
      if tempOrderList.Count > 0 then PrintOrdersOnSignRelease(tempOrderList, Nature, EncLoc, EncLocName);
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
            if Piece(OrderList.Strings[j], U,1) = tempOrder then tempOrderList.Add(OrderList.Strings[j]);
        end;
      if tempOrderList.Count > 0 then PrintOrdersOnSignRelease(tempOrderList, Nature, WardLoc, WardLocName);
    end;
    tempOrderList.Free;
end;

procedure PrintOrdersOnSignRelease(OrderList: TStringList; Nature: Char; PrintLoc : Integer =0; PrintName: string = '');
const
  TX_NEW_LOC1   = 'The patient''s location has changed to ';
  TX_NEW_LOC2   = '.' + CRLF + 'Should the orders be printed using the new location?';
  TC_NEW_LOC    = 'New Patient Location';
  TX_SIGN_LOC   = 'No location was selected.  Orders could not be printed!';
  TC_REQ_LOC    = 'Orders Not Printed';
  TX_LOC_PRINT  = 'The selected location will be used to determine where orders are printed.';
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
          then Encounter.Location := ALocation;
        end;
    end;
  //else
  //Encounter.Location := PrintLoc;
  if (PrintLoc = 0) and (Encounter.Location > 0) then PrintLoc := Encounter.Location;
  if PrintLoc = 0
    then PrintLoc := CommonLocationForOrders(OrderList);
  if PrintLoc = 0 then                      // location required for DEVINFO
  begin
    LookupLocation(ALocation, AName, LOC_ALL, TX_LOC_PRINT);
    if ALocation > 0 then
      begin
        PrintLoc := ALocation;
        Encounter.Location := ALocation;
      end;
  end;
  if printLoc = 0 then frmFrame.DisplayEncounterText;
  if PrintLoc <> 0 then
  begin
    SetupOrdersPrint(OrderList, DeviceInfo, Nature, False, PrintIt, PrintName, PrintLoc);
    if PrintIt then
      PrintOrdersOnReview(OrderList, DeviceInfo, PrintLoc)
    else
      PrintServiceCopies(OrderList, PrintLoc);
  end
  else InfoBox(TX_SIGN_LOC, TC_REQ_LOC, MB_OK or MB_ICONWARNING);
end;

procedure SetFontSize( FontSize: integer);
begin
  if uOrderDialog <> nil then
    uOrderDialog.SetFontSize( FontSize);
  if uOrderMenu <> nil then
    uOrderMenu.ResizeFont;
end;

procedure NextMove(var NMRec: TNextMoveRec; LastIndex: Integer; NewIndex: Integer);
begin
   if LastIndex = 0 then
      LastIndex  := NewIndex;
   if (LastIndex - NewIndex) <= 0 then
       NMRec.NextStep := STEP_FORWARD
   else
       NMRec.NextStep := STEP_BACK;
   NMRec.LastIndex := NewIndex;
end;

(*function GetQOAltOI: integer;
begin
  Result := QOAltOI.OI;
end; *)

function IsIMODialog(DlgID: integer): boolean; //IMO
var
  IsInptDlg, IsIMOLocation: boolean;
  Td: TFMDateTime;
begin
  result := False;
  IsInptDlg := False;
  //CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
  //Td := FMToday;
  Td := IMOTimeFrame;
  if ( (DlgID = MedsInDlgIen) or (DlgID = MedsIVDlgIen) or (IsInptQO(dlgId)) or (IsIVQO(dlgId))) then IsInptDlg := TRUE;
  IsIMOLocation := IsValidIMOLoc(Encounter.Location,Patient.DFN);
  if (IsInptDlg or IsInptQO(DlgID)) and (not Patient.Inpatient) and IsIMOLocation and (Encounter.DateTime > Td) then
    result := True;
end;

function AllowActionOnIMO(AnEvtTyp: char): boolean;
var
  Td: TFMDateTime;
begin
  Result := False;
  if (Patient.Inpatient) then
  begin
    Td := FMToday;
    if IsValidIMOLoc(Encounter.Location,Patient.DFN) and (Encounter.DateTime > Td) then
      Result := True;
  end
  else
  begin
    //CQ #15188 - allow IMO functionality 23 hours after encounter date/time - TDP
    //Td := FMToday;
    Td := IMOTimeFrame;
    if IsValidIMOLoc(Encounter.Location,Patient.DFN) and (Encounter.DateTime > Td) then
      Result := True
    else if AnEvtTyp in ['A','T'] then
      Result := True;
  end;
end;

function IMOActionValidation(AnId: string; var IsIMOOD: boolean; var x: string; AnEventType: char): boolean;
var
  actName: string;
begin
  // jd imo change
  Result := True;
  if CharAt(AnID, 1) in ['X','C'] then  // transfer IMO order doesn't need check
  begin
    IsIMOOD := IsIMOOrder(Copy(AnID, 2, Length(AnID)));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        if CharAt(AnID,1) = 'X' then actName := 'change';
        if CharAt(AnID,1) = 'C' then actName := 'copy';
        x := 'You cannot ' + actName + ' the clinical medication order.';
        x := RetrieveOrderText(Copy(AnID, 2, Length(AnID))) + #13#13#10 + x;
        UnlockOrder(Copy(AnID, 2, Length(AnID)));
        result := False;
      end
      else
      begin
        if patient.Inpatient then
        begin
          if CharAt(AnID,1) = 'X' then actName := 'changing';
          if CharAt(AnID,1) = 'C' then actName := 'copying';
          if MessageDlg(TX_IMO_WARNING1 + actName +  TX_IMO_WARNING2 + #13#13#10 + x, mtWarning,[mbOK,mbCancel],0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            result := False;
          end;
        end;
      end;
    end;
  end;
  if Piece(AnId,'^',1)='RENEW' then
  begin
    IsIMOOD := IsIMOOrder(Piece(AnID,'^',2));
    If IsIMOOD then
    begin
      if (not AllowActionOnIMO(AnEventType)) then
      begin
        x := 'You cannot renew the clinical medication order.';
        x := RetrieveOrderText(Piece(AnID,'^',2)) + #13#13#10 + x;
        UnlockOrder(Piece(AnID,'^',2));
        result := False;
      end
      else
      begin
        if Patient.Inpatient then
        begin
          if MessageDlg(TX_IMO_WARNING1 + 'renewing' + TX_IMO_WARNING2, mtWarning,[mbOK,mbCancel],0) = mrCancel then
          begin
            UnlockOrder(Copy(AnID, 2, Length(AnID)));
            result := False;
          end;
        end;
      end;
    end;
  end;
end;

//CQ #15188 - New function to allow IMO functionality 23 hours after encounter date/time - TDP
function IMOTimeFrame: TFMDateTime;
begin
  Result := DateTimeToFMDateTime(FMDateTimeToDateTime(FMNow) - (23/24));
end;

initialization
  uPatientLocked := False;
  uKeepLock      := False;
  uLastConfirm   := '';
  uOrderSetTime  := 0;
  uNewMedDialog  := 0;
  uOrderAction   := nil;
  uOrderDialog   := nil;
  uOrderHTML     := nil;
  uOrderMenu     := nil;
  uOrderSet      := nil;
  NSSchedule     := False;
  OriginalMedsOutHeight   := 0;
  OriginalMedsInHeight    := 0;
  OriginalNonVAMedsHeight := 0;

end.

unit fMeds;

{$OPTIMIZATION OFF}                              // REMOVE AFTER UNIT IS DEBUGGED

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPage, StdCtrls, Menus, ORCtrls, ORFn, ExtCtrls, ComCtrls, rOrders, uConst,
  rMeds, ORNet, fBase508Form, VA508AccessibilityManager, System.Actions,
  Vcl.ActnList;

type
  TChildOD = class
  public
    ChildID: string;
    ParentID: string;
    constructor Create;
  end;

  TfrmMeds = class(TfrmPage)
    mnuMeds: TMainMenu;
    mnuView: TMenuItem;
    mnuViewChart: TMenuItem;
    mnuChartReports: TMenuItem;
    mnuChartLabs: TMenuItem;
    mnuChartDCSumm: TMenuItem;
    mnuChartCslts: TMenuItem;
    mnuChartNotes: TMenuItem;
    mnuChartOrders: TMenuItem;
    mnuChartMeds: TMenuItem;
    mnuChartProbs: TMenuItem;
    mnuChartCover: TMenuItem;
    mnuAct: TMenuItem;
    mnuActNew: TMenuItem;
    Z1: TMenuItem;
    mnuActChange: TMenuItem;
    mnuActDC: TMenuItem;
    mnuActHold: TMenuItem;
    mnuActRenew: TMenuItem;
    Z2: TMenuItem;
    mnuViewActive: TMenuItem;
    mnuViewExpiring: TMenuItem;
    Z3: TMenuItem;
    mnuViewSortClass: TMenuItem;
    mnuViewSortName: TMenuItem;
    Z4: TMenuItem;
    mnuViewDetail: TMenuItem;
    popMed: TPopupMenu;
    popMedDetails: TMenuItem;
    N1: TMenuItem;
    popMedChange: TMenuItem;
    popMedDC: TMenuItem;
    popMedRenew: TMenuItem;
    N2: TMenuItem;
    popMedNew: TMenuItem;
    mnuActCopy: TMenuItem;
    mnuActRefill: TMenuItem;
    mnuActTransfer: TMenuItem;
    popMedRefill: TMenuItem;
    mnuChartSurgery: TMenuItem;
    mnuViewHistory: TMenuItem;
    popMedHistory: TMenuItem;
    splitTop: TSplitter;
    mnuViewInformation: TMenuItem;
    mnuViewDemo: TMenuItem;
    mnuViewVisits: TMenuItem;
    mnuViewPrimaryCare: TMenuItem;
    mnuViewMyHealtheVet: TMenuItem;
    mnuInsurance: TMenuItem;
    mnuViewFlags: TMenuItem;
    mnuViewReminders: TMenuItem;
    mnuViewRemoteData: TMenuItem;
    mnuViewPostings: TMenuItem;
    mnuOptimizeFields: TMenuItem;
    SortbyStatusthenLocation1: TMenuItem;
    SortbyClinicOrderthenStatusthenStopDate1: TMenuItem;
    SortbyDrugalphabeticallystatusactivestatusrecentexpired1: TMenuItem;
    N3: TMenuItem;
    mnuActUnhold: TMenuItem;
    Z5: TMenuItem;
    mnuActOneStep: TMenuItem;
    gdpSort: TGridPanel;
    txtView: TVA508StaticText;
    gdpOut: TGridPanel;
    txtDateRangeOp: TVA508StaticText;
    hdrMedsOut: THeaderControl;
    lstMedsOut: TCaptionListBox;
    gdpNon: TGridPanel;
    txtDateRangeNon: TVA508StaticText;
    hdrMedsNonVA: THeaderControl;
    lstMedsNonVA: TCaptionListBox;
    splitBottom: TSplitter;
    gdpIn: TGridPanel;
    txtDateRangeIp: TVA508StaticText;
    hdrMedsIn: THeaderControl;
    lstMedsIn: TCaptionListBox;
    mnuActPark: TMenuItem;
    mnuActUnpark: TMenuItem;
    Z6: TMenuItem;
    popDivPark: TMenuItem;
    popPark: TMenuItem;
    popUnpark: TMenuItem;
    DocumentNonVAMeds1: TMenuItem;
    DocumentNonVAMeds2: TMenuItem;
    ActionList1: TActionList;
    actPark: TAction;
    actUnpark: TAction;
    procedure mnuChartTabClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstMedsMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure lstMedsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure mnuViewDetailClick(Sender: TObject);
    procedure lstMedsExit(Sender: TObject);
    procedure lstMedsDblClick(Sender: TObject);
    procedure lstMedsInClick(Sender: TObject);
    procedure lstMedsOutClick(Sender: TObject);
    procedure hdrMedsOutSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure hdrMedsInSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure mnuActDCClick(Sender: TObject);
    procedure mnuActHoldClick(Sender: TObject);
    procedure mnuActRenewClick(Sender: TObject);
    procedure mnuActChangeClick(Sender: TObject);
    procedure mnuActCopyClick(Sender: TObject);
    procedure mnuActNewClick(Sender: TObject);
    procedure mnuActRefillClick(Sender: TObject);
    procedure mnuActClick(Sender: TObject);
    procedure mnuViewHistoryClick(Sender: TObject);
    procedure popMedPopup(Sender: TObject);
    procedure mnuViewClick(Sender: TObject);
    procedure lstMedsNonVAClick(Sender: TObject);
    procedure lstMedsNonVADblClick(Sender: TObject);
    procedure lstMedsNonVAExit(Sender: TObject);
    procedure hdrMedsNonVASectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure FormResize(Sender: TObject);
    procedure hdrMedsOutResize(Sender: TObject);
    procedure hdrMedsNonVAResize(Sender: TObject);
    procedure hdrMedsInResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure splitBottomMoved(Sender: TObject);
    procedure splitTopMoved(Sender: TObject);
    procedure hdrMedsOutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrMedsNonVAMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrMedsInMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrMedsOutMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrMedsNonVAMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure hdrMedsInMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ActivateDeactiveRenew(AListBox: TListBox);
    procedure ViewInfo(Sender: TObject);
    procedure mnuViewInformationClick(Sender: TObject);
    procedure mnuOptimizeFieldsClick(Sender: TObject);
    procedure hdrMedsOutSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure hdrMedsNonVASectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure hdrMedsInSectionClick(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure SortbyStatusthenLocation1Click(Sender: TObject);
    procedure SortbyClinicOrderthenStatusthenStopDate1Click(Sender: TObject);
    procedure SortbyDrugalphabeticallystatusactivestatusrecentexpired1Click
      (Sender: TObject);
    procedure mnuActUnholdClick(Sender: TObject);
    procedure mnuActOneStepClick(Sender: TObject);
    procedure DocumentNonVAMeds1Click(Sender: TObject);
    procedure lstMedsOutHintShow(var HintText: string; var CanShow: Boolean);
    procedure actParkExecute(Sender: TObject);
    procedure actUnparkExecute(Sender: TObject);
  private
    FIterating: Boolean;
    FActionOnMedsTab: Boolean;
    FParentComplexOrderID: string;
    FPrevInPatient: Boolean;
    uMedListIn: TList;
    uMedListOut: TList;
    uMedListNonVA: TList;
    uPendingChanges: TStringList;
    uDGrp: array [0 .. 6] of Integer;
    uPharmacyOrdersIn: TStringList;
    uPharmacyOrdersOut: TStringList;
    uNonVAOrdersOut: TStringList;
    ChildODList: TStringList;
    FSortView: Integer;
    FOrderTitlecaption: string;
    FRenewing: boolean;
    function ListSelected(const ErrMsg: string): TListBox;
    procedure ValidateSelected(AListBox: TListBox;
      const AnAction, WarningMsg, WarningTitle: string);
    procedure MakeSelectedList(AListBox: TListBox; AList: TList;
      ActName: String = '');
    procedure SynchListToOrders(AListBox: TListBox; AList: TList);
    function GetActionText(const AMed: TMedListRec): string;
    function GetInstructText(const AMed: TMedListRec;
      var Detail: string): string;
    function GetListText(const AMed: TMedListRec; Column: Integer;
      var Detail: string): string;
    function GetPlainText(Control: TWinControl; Index: Integer): string;
    function GetHeader(Control: TWinControl): THeaderControl;
    function GetMedList(Control: TWinControl): TList;
    function GetPharmacyOrders(Control: TWinControl): TStringList;
    // function PatientStatusChanged: boolean;
    procedure ClearChildODList;
    procedure SetViewCaption(Caption: String);
    procedure lstMedsInRightClickHandler(var Msg: TMessage;
      var Handled: Boolean);
    procedure lstMedsNonVARightClickHandler(var Msg: TMessage;
      var Handled: Boolean);
    procedure lstMedsOutRightClickHandler(var Msg: TMessage;
      var Handled: Boolean);
    function GetOrderStatus: string;
    function SomethingSelected: boolean;
    procedure lstMedsHintShow(Sender: TCaptionListBox; var HintText: string; var CanShow: Boolean);
  public
    procedure RefreshMedLists;
    procedure ClearPtData; override;
    procedure DisplayPage; override;
    procedure NotifyOrder(OrderAction: Integer; AnOrder: TOrder); override;
    procedure SetFontSize(FontSize: Integer); override;
    property ActionOnMedsTab: Boolean read FActionOnMedsTab;
    property ParentComplexOrderID: string read FParentComplexOrderID
      write FParentComplexOrderID;
    procedure InitfMedsSize;
    procedure SetSectionWidths(Sender: TObject);
    function GetTotalSectionsWidth(Sender: TObject): Integer;
    function CheckMedStatus(ActiveList: TListBox): Boolean;
    procedure PaPI_GUIsetup; // PaPI
    property SortView: Integer read FSortView write FSortView;
  end;

type
  arOrigOutPtSecWidths = array [0 .. 6] of Integer; // CQ7586
  arOrigInPtSecWidths = array [0 .. 4] of Integer; // CQ7586
  arOrigNonVASecWidths = array [0 .. 3] of Integer; // CQ7586

var
  frmMeds: TfrmMeds;

  OrigOutPtSecWidths: arOrigOutPtSecWidths; // CQ7586
  OrigInPtSecWidths: arOrigInPtSecWidths; // CQ7586
  OrigNonVASecWidths: arOrigNonVASecWidths; // CQ7586

  MedOutSize: double;
  LargePanelSize: Integer;
  SmallPanelSize: Integer;
  MedNonVAPanelSize: Integer;

  totalHeight: Integer;

  resizedTotalHeight: Integer;
  resizedMedOutPanelHeight: Extended;
  resizedNonVAPanelHeight: Extended;
  resizedMedInPanelHeight: Extended;

  splitterTop: TSplitter;
  splitterBottom: TSplitter;

  oldFont: Integer; // CQ9182

  const
    PSPO_1157 = 'OR*3.0*498'; //Check for required patch to enable PSPO 1157 functionality. Can be removed once 498 is released

implementation

uses uCore, rCore, fFrame, fRptBox, uOrders, fODBase, fOrdersDC, fOrdersHold,
  fOrdersUnhold,
  fOrdersRenew, fOMNavA, fOrdersRefill, fMedCopy, fOrders, fODChild, rODBase,
  StrUtils, fActivateDeactivate, VA2006Utils, VA508AccessibilityRouter,
  VAUtils, System.UITypes, System.Types, uPaPI, fOrdersPark, fOrdersUnPark,
  rODMeds, rMisc, uWriteAccess;  //rMisc added for Patch Check of OR*3.0*498 // PaPI

{$R *.DFM}

const
  SMALL_PANEL = 20;
  LARGE_PANEL = 60;
  COL_MEDNAME = 1;
  DG_OUT = 0;
  DG_IN = 1;
  DG_UD = 2;
  DG_IV = 3;
  DG_TPN = 4;
  DG_NVA = 5;
  DG_IMO = 6;
  FMT_INDENT = 12;

  TX_NOSEL = 'No orders are highlighted.  Highlight the orders' + CRLF +
    'you wish to take action on.';
  TC_NOSEL = 'No Orders Selected';
  TX_NO_DC = CRLF + CRLF + '- cannot be discontinued.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_DC = 'Unable to Discontinue';
  TX_NO_RENEW = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF + 'Reason: ';
  TC_NO_RENEW   = 'Unable to Renew Order';
  TX_NO_HOLD = CRLF + CRLF + '- cannot be placed on hold.' + CRLF + CRLF +
    'Reason:  ';
  TC_NO_HOLD = 'Unable to Hold';
  TX_NO_UNHOLD = CRLF + CRLF + '- cannot be released from hold.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_UNHOLD = 'Unable to Release from Hold';
  TX_NO_COPY = CRLF + CRLF + '- cannot be copied.' + CRLF + CRLF + 'Reason: ';
  TC_NO_COPY = 'Unable to Copy Order';
  TX_NO_CHANGE = CRLF + CRLF + '- cannot be changed.' + CRLF + CRLF +
    'Reason: ';
  TC_NO_CHANGE = 'Unable to Change Order';
  TX_NO_REFILL = CRLF + CRLF + '- cannot be refilled.' + CRLF + CRLF +
    'Reason: ';

  TC_NO_REFILL  = 'Unable to Refill Order';
  MEDS_SPLIT_FORM = 'frmMedsSplit';

  { TPage common methods --------------------------------------------------------------------- }

procedure TfrmMeds.ClearPtData;
begin
  inherited ClearPtData;
  ClearChildODList;
  lstMedsIn.Clear;
  lstMedsOut.Clear;
  lstMedsNonVA.Clear;
  ClearMedList(uMedListIn);
  ClearMedList(uMedListOut);
  ClearMedList(uMedListNonVA);
  uPendingChanges.Clear;
  uPharmacyOrdersIn.Clear;
  uPharmacyOrdersOut.Clear;
  uMedListNonVA.Clear;
  totalHeight := 0;

end;

procedure TfrmMeds.DisplayPage;
const
  RATIO_SMALL = 0.13; // 0.1866;

begin
  inherited DisplayPage;
  frmFrame.ShowHideChartTabMenus(mnuViewChart);
  if InitPage then
  begin
    mnuActOneStep.Enabled := User.EnableActOneStep;
    FPrevInPatient := Patient.Inpatient;
  end;

  if InitPage and User.NoOrdering then
  begin
    mnuAct.Enabled := False;
    popMedChange.Enabled := False;
    popMedDC.Enabled := False;
    popMedRenew.Enabled := False;
    popMedNew.Enabled := False;

  end;

  // Swap Inpatient/Outpatient list display positions depending in inpatient/outpatient status
  if InitPage and User.DisableHold then
  begin
    mnuActHold.Visible := False;
    mnuActUnhold.Visible := False;
  end;

  if Patient.Inpatient then
  begin
    if (not FPrevInPatient) or InitPage then
    begin
      gdpIn.Align := alNone;
      splitBottom.Align := alNone;
      gdpNon.Align := alNone;
      splitTop.Align := alNone;
      gdpOut.Align := alNone;

      gdpIn.Align := alTop;
      splitTop.Align := alTop;
      gdpNon.Align := alClient;

      gdpOut.Align := alBottom;
      splitBottom.Align := alBottom;

      gdpIn.Repaint;
      splitTop.Repaint;
      gdpNon.Repaint;
      splitBottom.Repaint;
      gdpOut.Repaint;
    end;

    if txtDateRangeOp.Font.Size > 12 then
    begin
      gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 3);
      gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 3);
      gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 3);
      gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 3);
      gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 3);
      gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 3);
    end
    else
    begin
      gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 1);
      gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 1);
      gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 1);
      gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 1);
      gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 1);
      gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 1);
    end;
  end
  else // Outpatient
  begin
    if FPrevInPatient then
    begin
      gdpOut.Align := alNone;
      splitBottom.Align := alNone;
      gdpNon.Align := alNone;
      splitTop.Align := alNone;
      gdpIn.Align := alNone;

      gdpOut.Align := alTop;
      gdpOut.Repaint;
      splitTop.Align := alTop;
      splitTop.Repaint;
      gdpNon.Align := alClient;
      gdpNon.Repaint;

      gdpIn.Align := alBottom;
      gdpIn.Repaint;
      splitBottom.Align := alBottom;
      splitBottom.Repaint;
    end;

    if txtDateRangeOp.Font.Size > 12 then
    begin
      gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 3);
      gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 3);
      gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 3);
      gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 3);
      gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 3);
      gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 3);
    end
    else
    begin
      gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 1);
      gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 1);
      gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 1);
      gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 1);
      gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 1);
      gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 1);
    end;
  end;
  RefreshMedLists;
  FPrevInPatient := Patient.Inpatient;
end;

procedure TfrmMeds.DocumentNonVAMeds1Click(Sender: TObject);
{ new med orders dependent on order dialog for inpatient or outpatient }
{ similar to lstWriteClick on fOrders }
var
  DialogInfo: string;
  DelayEvent: TOrderDelayEvent;
begin
  inherited;
  DelayEvent.EventType := 'C'; // temporary, so can pass to CopyOrders
  DelayEvent.Specialty := 0;
  DelayEvent.EventIFN := 0;
  DelayEvent.Effective := 0;
  frmOrders.DontCheck := True;
  frmOrders.lstSheets.ItemIndex := 0;
  frmOrders.lstSheetsClick(self);
  frmOrders.DontCheck := False;
  if not ReadyForNewOrder(DelayEvent) then
    Exit;
  frmOrders.DontCheck := True;
  frmOrders.lstSheets.ItemIndex := 0;
  frmOrders.lstSheetsClick(self);
  frmOrders.DontCheck := False;
  { get appropriate form, create the dialog form and show it }
  DialogInfo := GetNewNonVADialog; // DialogInfo = DlgIEN;FormID;DGroup
  if Copy(DialogInfo, 1, 11) = '-1^PSH OERR' then
    InfoBox('Non VA Medications (Documentation)) dialog does not exist',
      'Error', MB_OK)
  else
    case CharAt(Piece(DialogInfo, ';', 4), 1) of
      'A':
        ActivateAction(Piece(DialogInfo, ';', 1), self, 0);
      'D', 'Q':
        ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
      'M':
        ActivateOrderMenu(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
      'O':
        ActivateOrderSet(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
    else
      InfoBox('Unsupported dialog type', 'Error', MB_OK);
    end; { case }
end;

procedure TfrmMeds.mnuChartTabClick(Sender: TObject);
begin
  inherited;
  frmFrame.mnuChartTabClick(Sender);
end;

procedure TfrmMeds.NotifyOrder(OrderAction: Integer; AnOrder: TOrder);
var
  AMedList: TList;
  AStringList: TStringList;
  NewMedRec: TMedListRec;
  i, Match: Integer;
  j: Integer;
  AChildList: TStringList;
  CplxOrderID, action: string;

  procedure SetCurrentOrderID;
  var
    i: Integer;
    AMedRec: TMedListRec;
  begin
    with AMedList do
      for i := 0 to Count - 1 do
      begin
        AMedRec := TMedListRec(AMedList[i]);
        if Piece(AMedRec.OrderID, ';', 1) = Piece(AnOrder.ActionOn, ';', 1) then
        begin
        end;
      end;
  end;

  function IndexForCurrentID(const AnID: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to uPendingChanges.Count - 1 do
      if Piece(uPendingChanges[i], U, 2) = AnID then
        Result := i;
    if Result < 0 then
      for i := 0 to uPendingChanges.Count - 1 do
        if Piece(uPendingChanges[i], '=', 1) = Piece(AnID, ';', 1) then
          Result := i;
  end;

begin
  AMedList := nil;
  if AnOrder <> nil then
  begin
    // AGP Change 26.24 CQ 7150 fixes the problem with non-va meds initially showing up in the inpatient section
    if uDGrp[DG_OUT] = AnOrder.DGroup then
      AMedList := uMedListOut;
    If uDGrp[DG_NVA] = AnOrder.DGroup then
      AMedList := uMedListNonVA;
    if (AMedList <> uMedListOut) and (AMedList <> uMedListNonVA) then
      for i := 1 to 6 do
        if uDGrp[i] = AnOrder.DGroup then
          AMedList := uMedListIn;
  end;
  case OrderAction of
    ORDER_NEW: { sent by accept order on new order }
      if AMedList <> nil then
      begin
        // check this out carefully!!
        NewMedRec := TMedListRec.Create;
        NewMedRec.OrderID := AnOrder.ID;
        NewMedRec.Instruct := AnOrder.Text;
        NewMedRec.Inpatient := AMedList = uMedListIn;
        NewMedRec.DGroupIEN := AnOrder.DGroup;
        AMedList.Insert(0, NewMedRec);
        if AMedList = uMedListIn then
        begin
          lstMedsIn.Items.InsertObject(0, GetPlainText(lstMedsIn, 0), NewMedRec);
          uPharmacyOrdersIn.Insert(0, U + AnOrder.ID);
        end
        else
        begin
          if AMedList = uMedListOut then
          begin
            lstMedsOut.Items.InsertObject(0, GetPlainText(lstMedsOut, 0), NewMedRec);
            uPharmacyOrdersOut.Insert(0, U + AnOrder.ID);
          end
          else
          begin
            if AMedList = uMedListNonVA then
            begin
              lstMedsNonVA.Items.InsertObject(0, GetPlainText(lstMedsNonVA, 0), NewMedRec);
              uNonVAOrdersOut.Insert(0, U + AnOrder.ID);
            end;
          end;
        end;
        uPendingChanges.Add(Piece(AnOrder.ID, ';', 1) + '=NW^' + AnOrder.ID);
      end;
    ORDER_DC: { sent by a diet to cancel a tubefeeding - do nothing }
      ;
    ORDER_EDIT: { sent by accept on edit order }
      if AMedList <> nil then
      begin
        Match := IndexForCurrentID(AnOrder.EditOf);
        if Match < 0
        { add a new pending change if there is no existing change that matches EditOf }
        then
          uPendingChanges.Add(Piece(AnOrder.EditOf, ';', 1) + '=XX' + U +
            AnOrder.ID + U + AnOrder.Text + U + AnOrder.OrderLocName)
          { leave 1st piece (original ID) intact, while changing text & current ID }
        else
          uPendingChanges[Match] := Piece(uPendingChanges[Match], '=', 1) +
            '=XX' + U + AnOrder.ID + U + AnOrder.Text + U +
            AnOrder.OrderLocName;
      end;
    ORDER_ACT: { sent by DC, Hold, & Renew actions }
      if AMedList <> nil then
      begin
//        if Piece(AnOrder.ActionOn, '=', 2) = 'CA' then
//        begin
//          // cancel action, remove from PendingChanges
//          for idx := uPendingChanges.Count - 1 downto 0 do
//          begin
//            Match := IndexForCurrentID(Piece(AnOrder.ActionOn, '=', 1));
//            if Match > -1 then
//              uPendingChanges.Delete(Match);
//          end;
//        end
//        else if Piece(AnOrder.ActionOn, '=', 2) = 'DL' then
      action := Piece(AnOrder.ActionOn, '=', 2);
      if (action = 'CA') or (action = 'DL') then
        begin
          // delete action, show as deleted (set OrderID's to 0 so not confused with next order)
          Match := IndexForCurrentID(Piece(AnOrder.ActionOn, '=', 1));
          if Match > -1 then
            uPendingChanges[Match] := '0=' + action;
          if AMedList = uMedListIn then
            AStringList := uPharmacyOrdersIn
          else if AMedList = uMedListOut then
            AStringList := uPharmacyOrdersOut
          else
            AStringList := uNonVAOrdersOut;
          with AStringList do
            for i := 0 to Count - 1 do
              if (U + Piece(AnOrder.ActionOn, '=', 1)) = Strings[i] then
                Strings[i] := '^0';
          Match := -1;
          with AMedList do
            for i := 0 to Count - 1 do
              if TMedListRec(Items[i]).OrderID = Piece(AnOrder.ActionOn, '=', 1)
              then
                Match := i;
          if Match > -1 then
            TMedListRec(AMedList.Items[Match]).OrderID := '0';
        end
        else if Piece(AnOrder.ActionOn, '=', 2) = 'PK' then // PaPI ============
        begin
          RefreshMedLists; // recreates list and updates status of the order
        end
        else if Piece(AnOrder.ActionOn, '=', 2) = 'UP' then // PaPI ============
        begin
          RefreshMedLists; // recreates list and updates status of the order
        end
        else
          uPendingChanges.Add(Piece(AnOrder.ActionOn, ';', 1) + '=' +
            Piece(AnOrder.ActionOn, '=', 2) + U + AnOrder.ID + '^^' +
            AnOrder.OrderLocName);

      end; { if AMedList }
    ORDER_CPLXRN:
      begin
        AChildList := TStringList.Create;
        CplxOrderID := Piece(AnOrder.ActionOn, '=', 1);
        GetChildrenOfComplexOrder(CplxOrderID, Piece(CplxOrderID, ';', 2),
          AChildList);
        if AMedList = uMedListIn then
          with AMedList do
          begin
            for i := Count - 1 downto 0 do
            begin
              for j := 0 to AChildList.Count - 1 do
              begin
                if (TMedListRec(Items[i]).OrderID = AChildList[j]) then
                begin
                  { Delete(i);
                    Break; }
                  if not IsFirstDoseNowOrder(TMedListRec(Items[i]).OrderID) then
                  begin
                    uPendingChanges.Add(Piece(TMedListRec(Items[i]).OrderID,
                      ';', 1) + '=' + Piece(AnOrder.ActionOn, '=', 2) + U +
                      AnOrder.ID);
                    Break;
                  end;
                end;
              end;
            end;
          end;
        AChildList.Clear;
        AChildList.Free;
      end;
    ORDER_SIGN: { sent by fReview, fOrderSign when orders signed, AnOrder=nil }
      begin
        // ** only if tab has been visited?
        uPendingChanges.Clear;
        RefreshMedLists;
      end;
  end; { case }
end;

procedure TfrmMeds.SetFontSize(FontSize: Integer);
begin
  inherited SetFontSize(FontSize);
  mnuOptimizeFieldsClick(self);
  if Patient.DFN <> '' then
    RefreshMedLists;
end;

{ Form events ------------------------------------------------------------------------------ }

procedure TfrmMeds.FormCreate(Sender: TObject);
var
  medsSplitFnd: Boolean;
  retList: TStringList;
  i: Integer;
  X: string;
begin
  inherited;
  FixHeaderControlDelphi2006Bug(hdrMedsIn);
  FixHeaderControlDelphi2006Bug(hdrMedsOut);
  FixHeaderControlDelphi2006Bug(hdrMedsNonVA);
  PageID := CT_MEDS;
  uMedListIn := TList.Create;
  uMedListOut := TList.Create;
  uMedListNonVA := TList.Create;
  uPendingChanges := TStringList.Create;
  uDGrp[DG_OUT] := DGroupIEN('O RX');
  uDGrp[DG_IN] := DGroupIEN('I RX');
  uDGrp[DG_UD] := DGroupIEN('UD RX');
  uDGrp[DG_IV] := DGroupIEN('IV RX');
  uDGrp[DG_TPN] := DGroupIEN('TPN');
  uDGrp[DG_NVA] := DGroupIEN('NV RX');
  uDGrp[DG_IMO] := DGroupIEN('C RX');
  uPharmacyOrdersIn := TStringList.Create;
  uPharmacyOrdersOut := TStringList.Create;
  uNonVAOrdersOut := TStringList.Create;
  FActionOnMedsTab := False;
  FParentComplexOrderID := '';
  ChildODList := TStringList.Create;
  FOrderTitlecaption := '';

  // DETECT 1st TIME USER.
  // If first time user (medSplitFound=false), then manually set panel heights.
  // if NOT first time user (medSplitFound=true), then set Meds tab windows to saved settings.
  medsSplitFnd := False;
  if Assigned(frmMeds) then
  begin
    retList := TStringList.Create;
    try
      CallVistA('ORWCH LOADALL', [nil], retList);
      for i := 0 to retList.Count - 1 do
      begin
        X := retList[i];
        if strPos(PChar(X), PChar(MEDS_SPLIT_FORM)) <> nil then
        begin
          medsSplitFnd := False; // TRUE;
          Break;
        end;
      end;
    finally
      FreeAndNil(retList);
    end;

    if not medsSplitFnd then
    begin
      gdpIn.Height := frmMeds.Height div 2;
      gdpOut.Height := gdpIn.Height div 2;
    end;
  end;

  // CQ9622
  if hdrMedsIn.Sections[1].Width < 100 then
  begin
    hdrMedsIn.Sections[1].Width := 100;
    hdrMedsIn.Refresh;
  end;
  if hdrMedsNonVA.Sections[1].Width < 100 then
  begin
    hdrMedsNonVA.Sections[1].Width := 100;
    lstMedsNonVA.Refresh;
  end;
  if hdrMedsOut.Sections[1].Width < 100 then
  begin
    hdrMedsOut.Sections[1].Width := 100;
    hdrMedsOut.Refresh;
  end;
  // end CQ9622
  AddMessageHandler(lstMedsIn, lstMedsInRightClickHandler);
  AddMessageHandler(lstMedsNonVA, lstMedsNonVARightClickHandler);
  AddMessageHandler(lstMedsOut, lstMedsOutRightClickHandler);
  // PaPI ======================================================================
  Application.HintHidePause := 10000; // increasing the default Hide value to 10 sec.
  if not WriteAccess(waMeds) then
  begin
    mnuAct.Enabled := False;
    DocumentNonVAMeds1.Enabled := False;
    DocumentNonVAMeds2.Enabled := False;
  end
  else begin
    if not WriteAccess(waDelayedOrders) then
      mnuActTransfer.Enabled := False;
    DocumentNonVAMeds1.Enabled := canWriteOrder(NonVADisp);
    DocumentNonVAMeds2.Enabled := DocumentNonVAMeds1.Enabled;
  end;
end;

procedure TfrmMeds.FormDestroy(Sender: TObject);
begin
  inherited;
  RemoveMessageHandler(lstMedsOut, lstMedsOutRightClickHandler);
  RemoveMessageHandler(lstMedsNonVA, lstMedsNonVARightClickHandler);
  RemoveMessageHandler(lstMedsIn, lstMedsInRightClickHandler);
  ClearChildODList;
  ClearMedList(uMedListIn);
  ClearMedList(uMedListOut);
  ClearMedList(uMedListNonVA);
  uMedListIn.Free;
  uMedListOut.Free;
  uMedListNonVA.Free;
  uPendingChanges.Free;
  uPharmacyOrdersIn.Free;
  uPharmacyOrdersOut.Free;
  uNonVAOrdersOut.Free;
  ChildODList.Free;
end;

{ View menu events ------------------------------------------------------------------------- }

procedure TfrmMeds.mnuViewDetailClick(Sender: TObject);
var
  AnID, ATitle, AnOrder: string;
  AListBox: TListBox;
  i, j, idx: Integer;
  tmpList: TStringList;
  aTmpList: TStringList;
begin
  inherited;
  tmpList := TStringList.Create;
  try
    idx := 0;
    AListBox := ListSelected(TX_NOSEL);
    if AListBox = nil then
      Exit
    else if AListBox = lstMedsOut then
      ATitle := 'Outpatient Medication Details'
    else if AListBox = lstMedsNonVA then
      ATitle := 'Non VA Medication Details'
    else
      ATitle := 'Inpatient Medication Details';
    FIterating := True;
    with GetPharmacyOrders(AListBox) do
      for i := 0 to Count - 1 do
        if AListBox.Selected[i] then
        begin
          AnID := Piece(Strings[i], U, 1);
          if AnID <> '' then
          begin
            DetailMedLM(AnID, tmpList);
          end;
          AnOrder := Piece(Strings[i], U, 2);
          if AnOrder <> '' then
          begin
            tmpList.Add('');
            tmpList.Add(StringOfChar('=', 74));
            tmpList.Add('');
            aTmpList := TStringList.Create;
            try
              MedAdminHistory(AnOrder, aTmpList);
              FastAddStrings(aTmpList, tmpList);
            finally
              FreeAndNil(aTmpList);
            end;
          end;
          if CheckOrderGroup(AnOrder) = 1 then // if it's UD group
          begin
            for j := 0 to tmpList.Count - 1 do
            begin
              if Pos('PICK UP', UpperCase(tmpList[j])) > 0 then
              begin
                idx := j;
                Break;
              end;
            end;
            if idx > 0 then
              tmpList.Delete(idx);
          end;
          if tmpList.Count > 0 then
            ReportBox(tmpList, ATitle, True);
          if (frmFrame.TimedOut) or (frmFrame.CCOWDrivedChange) then
            Exit; // code added to correct access violation on timeout
          Exit;
        end;
    FIterating := False;
    ResetSelectedForList(AListBox);
    AListBox.SetFocus;
  finally
    tmpList.Free;
  end;
end;

procedure TfrmMeds.mnuViewHistoryClick(Sender: TObject);
var
  ATitle, AnOrder: string;
  AListBox: TListBox;
  i: Integer;
  aTmpList: TStringList;
begin
  inherited;
  AListBox := ListSelected(TX_NOSEL);
  if AListBox = nil then
    Exit
  else if AListBox = lstMedsOut then
    ATitle := 'Outpatient Medication Administration History'
  else if AListBox = lstMedsNonVA then
    ATitle := 'Non VA Medication Documentation History'
  else
    ATitle := 'Inpatient Medication Administration History';
  FIterating := True;
  with GetPharmacyOrders(AListBox) do
    for i := 0 to Count - 1 do
      if AListBox.Selected[i] then
      begin
        AnOrder := Piece(Strings[i], U, 2);
        if AnOrder <> '' then
        begin
          aTmpList := TStringList.Create;
          try
            MedAdminHistory(AnOrder, aTmpList);
            ReportBox(aTmpList, ATitle, True);
          finally
            FreeAndNil(aTmpList);
          end;
        end;
      end;
  FIterating := False;
  ResetSelectedForList(AListBox);
  AListBox.SetFocus;
end;

{ Listbox events --------------------------------------------------------------------------- }

procedure TfrmMeds.RefreshMedLists;
var
  i, view: Integer;
  AMed: TMedListRec;
  DateRange: string;
  DateRangeIp: string;
  DateRangeOp: string;
  PatchInstalled: boolean;    //All code in fMeds related to this patch check for OR*3*498 can be removed in the future after patch 498 is released
begin
  if frmFrame.TimedOut then
    Exit;
  lstMedsIn.Clear;
  lstMedsOut.Clear;
  lstMedsNonVA.Clear;
  txtDateRangeOp.Caption := '';
  txtDateRangeIp.Caption := '';
  txtDateRangeNon.Caption := '';
  DateRange := '';
  DateRangeIp := '';
  DateRangeOp := '';
  StatusText('Retrieving active medications...');
  view := self.FSortView;
  PatchInstalled := ServerHasPatch(PSPO_1157);  // OR*3*498 Related
  // AGP Fix for CQ 10410 added view arguement to control Meds Tab sort criteria
  LoadActiveMedLists(uMedListIn, uMedListOut, uMedListNonVA, view, DateRange,
    DateRangeIp, DateRangeOp);
  self.FSortView := view;
  if view = 1 then
  begin
    self.SortbyStatusthenLocation1.Checked := True;
    SetViewCaption(SortbyStatusthenLocation1.Caption);
    self.SortbyClinicOrderthenStatusthenStopDate1.Checked := False;
    self.SortbyDrugalphabeticallystatusactivestatusrecentexpired1.
      Checked := False;
    if not(PatchInstalled) then SetViewCaption(SortbyStatusthenLocation1.Caption + ' ' + DateRange);  // OR*3*498 Related

  end
  else if view = 2 then
  begin
    self.SortbyStatusthenLocation1.Checked := False;
    self.SortbyClinicOrderthenStatusthenStopDate1.Checked := True;
    SetViewCaption(SortbyClinicOrderthenStatusthenStopDate1.Caption);
    self.SortbyDrugalphabeticallystatusactivestatusrecentexpired1.
      Checked := False;
    if not(PatchInstalled) then SetViewCaption(SortbyClinicOrderthenStatusthenStopDate1.Caption + ' ' + DateRange); // OR*3*498 Related
  end
  else if view = 3 then
  begin
    self.SortbyStatusthenLocation1.Checked := False;
    self.SortbyClinicOrderthenStatusthenStopDate1.Checked := False;
    self.SortbyDrugalphabeticallystatusactivestatusrecentexpired1.
      Checked := True;
    SetViewCaption
      (SortbyDrugalphabeticallystatusactivestatusrecentexpired1.Caption);
    if not(PatchInstalled) then SetViewCaption(SortbyDrugalphabeticallystatusactivestatusrecentexpired1.Caption + ' ' + DateRange);  // OR*3*498 Related
  end;
  if PatchInstalled then    // OR*3*498 Related
    begin
      txtDateRangeOp.Caption := '            Outpatient Medications Date Range: ' +
        DateRangeOp;
      txtDateRangeIp.Caption := '            Inpatient Medications Date Range: ' +
        DateRangeIp;
      txtDateRangeNon.Caption := '           Non-VA Medications Date Range: ' +
        DateRangeOp; // non-VA Meds uses same date range as Outpatient Meds
    end;
  uPharmacyOrdersIn.Clear;
  uPharmacyOrdersOut.Clear;
  uNonVAOrdersOut.Clear;
  with uMedListIn do
    for i := 0 to Count - 1 do
    begin
      AMed := TMedListRec(Items[i]);
      uPharmacyOrdersIn.Add(AMed.PharmID + U + AMed.OrderID);
      lstMedsIn.Items.AddObject(GetPlainText(lstMedsIn, i), AMed);
    end;

  with uMedListNonVA do
  for i := 0 to Count - 1 do
  begin
    AMed := TMedListRec(Items[i]);
    uNonVAOrdersOut.Add(AMed.PharmID + U + AMed.OrderID);
    lstMedsNonVA.Items.AddObject(GetPlainText(lstMedsNonVA, i), AMed);
  end;

  with uMedListOut do
  for i := 0 to Count - 1 do
  begin
    AMed := TMedListRec(Items[i]);
    uPharmacyOrdersOut.Add(AMed.PharmID + U + AMed.OrderID);
    lstMedsOut.Items.AddObject(GetPlainText(lstMedsOut, i), AMed);
  end;

  StatusText('');
end;

function TfrmMeds.GetActionText(const AMed: TMedListRec): string;
var
  AnAction: string;
  Abbreviation: string;
begin
  AnAction := uPendingChanges.Values[Piece(AMed.OrderID, ';', 1)];
  Abbreviation := Piece(AnAction, U, 1);
  Result := '';
  if Length(Abbreviation) > 0 then
  begin
    if CharAt(Abbreviation, 1) = 'X' then
      Result := 'Change'
    else if Abbreviation = 'NW' then
      Result := 'New'
    else if Abbreviation = 'RN' then
      Result := 'Renew'
    else if Abbreviation = 'RF' then
      Result := 'Refill'
    else if Abbreviation = 'HD' then
      Result := 'Hold'
    else if Abbreviation = 'DL' then
      Result := 'Deleted'
    else if Abbreviation = 'CA' then
      Result := 'Canceled'
    else if Abbreviation = 'DC' then
      Result := 'DC'
    else if Abbreviation = 'UH' then
      Result := 'Unhold'
    else if Abbreviation = 'UP' then
      Result := 'Un-Park' // PaPI
    else if Abbreviation = 'PK' then
      Result := 'Park' // PaPI

    else
      Result := Abbreviation;
  end;
end;

function TfrmMeds.GetInstructText(const AMed: TMedListRec;
  var Detail: string): string;
var
  AnAction: string;
  Indent: Integer;
begin
  AnAction := uPendingChanges.Values[Piece(AMed.OrderID, ';', 1)];
  Result := AMed.Instruct;
  // replace pharmacy text with order text if this is a change
  if CharAt(AnAction, 1) = 'X' then
    Result := Piece(AnAction, U, 3);
  if AMed.IVFluid then
    Indent := Pos(CRLF + 'in ', Result)
  else
    Indent := Pos(#13, Result);
  if Indent > 0 then
  begin
    if AMed.IVFluid then
    begin
      Detail := Copy(Result, Indent + Length(CRLF), Length(Result));
      Result := Copy(Result, 1, Indent - 1);
    end
    else
    begin
      Detail := Copy(Result, Indent + 2, Length(Result));
      Result := Copy(Result, 1, Indent - 1);
    end;
  end;
end;

function TfrmMeds.GetListText(const AMed: TMedListRec; Column: Integer;
  var Detail: string): string;
begin
  Result := '';
  Detail := '';
  if AMed.Status = 'Suspended' then
    AMed.Status := 'Active/Susp'; // HDS00007547	PSI-03-033 Interim Solution.
  case Column of
    0:
      Result := GetActionText(AMed);
    1:
      Result := GetInstructText(AMed, Detail);
    2:
      Result := FormatFMDateTime('mm/dd/yy', AMed.StopDate);
    3:
      Result := AMed.Status;
    4:
      begin
        if AMed.Inpatient then
          Result := MixedCase(AMed.Location)
        else
          Result := FormatFMDateTime('mmm dd,yy', AMed.LastFill);
      end;
    5:
      Result := AMed.Refills;
  else
  end;
end;

function TfrmMeds.GetPlainText(Control: TWinControl; Index: Integer): string;
var
  AMed: TMedListRec;
  AHeader: THeaderControl;
  i: Integer;
  X, Y: string;
begin
  Result := '';
  var aMedList := GetMedList(Control);
  if aMedList = nil then
    Exit;
  AMed := TMedListRec(aMedList[Index]);
  AHeader := GetHeader(Control);
  if AHeader = nil then
    Exit;
  for i := 0 to AHeader.Sections.Count - 1 do
  begin
    X := GetListText (AMed, i, Y);
    if (X <> '') or (Y <> '') then
      Result := Result + AHeader.Sections[i].Text + ': ' + X + ' ' + Y + CRLF;
  end;
  Result := Trim(Result);
end;

function TfrmMeds.GetHeader(Control: TWinControl): THeaderControl;
begin
  case Control.Tag of
    MedsTab_List_Tag_OUTPT:
      Result := hdrMedsOut;
    MedsTab_List_Tag_NONVA:
      Result := hdrMedsNonVA;
    MedsTab_List_Tag_INPT:
      Result := hdrMedsIn;
  else
    Result := nil;
  end;
end;

function TfrmMeds.GetMedList(Control: TWinControl): TList;
begin
  case Control.Tag of
    MedsTab_List_Tag_OUTPT:
      Result := uMedListOut;
    MedsTab_List_Tag_NONVA:
      Result := uMedListNonVA;
    MedsTab_List_Tag_INPT:
      Result := uMedListIn;
  else
    Result := nil;
  end;
end;

function TfrmMeds.GetPharmacyOrders(Control: TWinControl): TStringList;
begin
  case Control.Tag of
    MedsTab_List_Tag_OUTPT:
      Result := uPharmacyOrdersOut;
    MedsTab_List_Tag_NONVA:
      Result := uNonVAOrdersOut;
    MedsTab_List_Tag_INPT:
      Result := uPharmacyOrdersIn;
  else
    Result := nil;
  end;
end;

procedure TfrmMeds.lstMedsMeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
var
  NewHeight, RecRight: Integer;
  AMed: TMedListRec;
  AHeader: THeaderControl;
  AMedList: TList;
  ARect: TRect;
  X, Y, AnAction: string;
begin
  inherited;
  NewHeight := AHeight;
  AHeader := GetHeader(Control);
  AMedList := GetMedList(Control);
  if (AHeader <> nil) and (AMedList <> nil) then
  begin
    with Control as TListBox do
      if Index < Items.Count then
      begin
        AMed := TMedListRec(AMedList[Index]);
        // can't use Items.Objects here - its not there yet
        if AMed <> nil then
        begin
          ARect := ItemRect(Index);
          ARect.Left := AHeader.Sections[0].Width + 2;
          ARect.Right := ARect.Left + AHeader.Sections[1].Width - 6;
          AnAction := uPendingChanges.Values[Piece(AMed.OrderID, ';', 1)];
          if Length(AnAction) > 0 then
            Canvas.Font.Style := [fsBold];
          X := GetInstructText(AMed, Y);
          RecRight := ARect.Right;
          NewHeight := WrappedTextHeightByFont(Canvas, Font, X, ARect);
          if (Length(Y) > 0) then
          begin
            ARect.Left := AHeader.Sections[0].Width + FMT_INDENT;
            ARect.Right := RecRight; // Draw Text alters ARect.
            inc(NewHeight, WrappedTextHeightByFont(Canvas, Font, Y, ARect));
          end;
          if NewHeight > 255 then
            NewHeight := 255; // windows appears to only look at 8 bits *KCM*
          if NewHeight < 13 then
            NewHeight := 13; // show at least one line                 *KCM*
        end; { if AMed }
      end; { if Index }
  end;
  AHeight := NewHeight;
end;

procedure TfrmMeds.lstMedsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ReturnHt: Integer;
  X, Y, AnAction: string;
  AMed: TMedListRec;
  AMedList: TList;
  AHeader: THeaderControl;
  ARect: TRect;
  i: Integer;
  RectLeft: Integer;
begin
  inherited;
  AHeader := GetHeader(Control);
  AMedList := GetMedList(Control);
  if (AHeader = nil) or (AMedList = nil) then
    Exit;
  ListGridDrawLines(TListBox(Control), AHeader, Index, State);
  with Control as TListBox do
    if Index < Items.Count then
    begin
      AMed := TMedListRec(AMedList[Index]);
      // can't use Items.Objects here - its not there yet
      if AMed <> nil then
      begin
        AnAction := uPendingChanges.Values[Piece(AMed.OrderID, ';', 1)];
        if Length(AnAction) > 0 then
        begin
          Canvas.Font.Style := [fsBold];
          // AGP Change 26.29 CQ #8188 Fix for highlighted new meds displaying blue font with a blue background.
          if odSelected in State then
          begin
            Canvas.Brush.Color := clHighlight;
            Canvas.Font.Color := clHighlightText;
            // Canvas.FillRect(ARect);
            Canvas.Font.Color := Get508CompliantColor(clWhite);
          end;
          if (Canvas.Font.Color <> Get508CompliantColor(clWhite)) then
            Canvas.Font.Color := Get508CompliantColor(clBlue);
          if (Length(Piece(AnAction, '^', 4)) > 0) then
            AMed.Location := Piece(AnAction, '^', 4);
        end;
        RectLeft := 0;
        for i := 0 to AHeader.Sections.Count - 1 do
        begin
          X := GetListText(AMed, i, Y);
          if Length(Y) > 0 then
          begin
            ARect := ItemRect(Index);
            ARect.Left := RectLeft + 2;
            ARect.Right := (ARect.Left + AHeader.Sections[i].Width - 6);

            // if ((ARect.Right - ARect.Left) < 100) then
            // ARect.Right := ARect.Right + (100 - (ARect.Left + AHeader.Sections[i].Width - 6));

            ReturnHt := DrawText(Canvas.Handle, PChar(X), Length(X), ARect,
              DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
            ARect.Left := RectLeft + FMT_INDENT;
            ARect.Top := ARect.Top + ReturnHt;
            DrawText(Canvas.Handle, PChar(Y), Length(Y), ARect,
              DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
          end
          else
            ListGridDrawCell(TListBox(Control), AHeader, Index, i, X, i = 1);
          inc(RectLeft, AHeader.Sections[i].Width);
        end;
      end; { if AMed }
    end; { if Index }
end;

procedure TfrmMeds.lstMedsExit(Sender: TObject);
begin
  inherited;
  if not FIterating then
    ResetSelectedForList(TListBox(Sender));
end;

procedure TfrmMeds.lstMedsDblClick(Sender: TObject);
begin
  inherited;
  mnuViewDetailClick(self);
end;

procedure TfrmMeds.lstMedsInClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;

  // if PatientStatusChanged then exit;
  with lstMedsOut do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
  with lstMedsNonVA do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
end;

procedure TfrmMeds.lstMedsInRightClickHandler(var Msg: TMessage;
  var Handled: Boolean);
begin
  if Msg.Msg = WM_RBUTTONUP then
  begin
    lstMedsIn.RightClickSelect := (lstMedsIn.SelCount < 1);
    lstMedsInClick(lstMedsIn);
  end;
end;

procedure TfrmMeds.lstMedsOutClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  // if PatientStatusChanged then exit;
  with lstMedsIn do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
  with lstMedsNonVA do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
end;

procedure TfrmMeds.lstMedsOutHintShow(var HintText: string;
  var CanShow: Boolean);
begin
  lstMedsHintShow(lstMedsOut, HintText, CanShow);
end;

procedure TfrmMeds.lstMedsHintShow(Sender: TCaptionListBox; var HintText: string;
  var CanShow: Boolean);
const
  oldidx: Longint = -1;
var
  aHeader: THeaderControl;
  idx: Longint;
  iStart, iStop: Longint;
  aPoint: TPoint;
  AMedList: TList;

  function getHintString(anItem: Integer): String;
  var
    AMed: TMedListRec;
  begin
    AMed := TMedListRec(AMedList[anItem]);
    if AMed <> nil then
      Result := papiMedOrderStatusHint(AMed.Status)
    else
      Result := '';
  end;

begin
  AHeader := GetHeader(Sender);
  AMedList := GetMedList(Sender);
  if (AHeader = nil) or (AMedList = nil) then
    Exit;
  aPoint := Mouse.CursorPos;
  aPoint := Sender.ScreenToClient(aPoint);
  iStart := AHeader.Sections.Items[0].Width + AHeader.Sections.Items[1].Width
    + AHeader.Sections.Items[2].Width + 3;
  iStop := iStart + AHeader.Sections.Items[3].Width;
  if (apoint.X <= iStart) or (iStop <= apoint.X) then
    CanShow := False
  else
  begin
    idx := Sender.ItemAtPos(Point(apoint.X, apoint.Y), True);
    if (idx < 0) or (idx = oldidx) then
      Exit;
    oldidx := idx;
    HintText := getHintString(idx);
    if HintText = '' then
      CanShow := False;
  end;
end;

procedure TfrmMeds.lstMedsOutRightClickHandler(var Msg: TMessage;
  var Handled: Boolean);
begin
  if Msg.Msg = WM_RBUTTONUP then
  begin
    lstMedsOut.RightClickSelect := (lstMedsOut.SelCount < 1);
    lstMedsOutClick(lstMedsOut);
  end;
end;

procedure TfrmMeds.hdrMedsOutSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  LockDrawing;
  try
    with lstMedsOut do
    begin
      IntegralHeight := not IntegralHeight;
      // both lines are necessary, this forces the
      IntegralHeight := not IntegralHeight; // listbox window to be recreated
    end;
  finally
    UnlockDrawing;
  end;
  lstMedsOut.Invalidate;
  Refresh;
end;

procedure TfrmMeds.hdrMedsInSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  LockDrawing;
  try
    with lstMedsIn do
    begin
      IntegralHeight := not IntegralHeight;
      // both lines are necessary, this forces the
      IntegralHeight := not IntegralHeight; // listbox window to be recreated
    end;
  finally
    UnlockDrawing;
  end;
  lstMedsIn.Invalidate;
  Refresh;
end;

{ Action menu events ---------------------------------------------------------------------- }
procedure TfrmMeds.mnuActClick(Sender: TObject);
var
  AllowTransfer: boolean;

begin
  inherited;
  PaPI_GUIsetup;
  if SomethingSelected then
  begin
    mnuActRenew.Enabled := True;
    mnuActRefill.Enabled := True;
    if lstMedsNonVA.SelCount > 0 then
    begin
      mnuActRenew.Enabled := False;
      mnuActRefill.Enabled := False;
    end;
  end;

  AllowTransfer := WriteAccess(waDelayedOrders);
  if AllowTransfer then
  begin
    if lstMedsOut.SelCount > 0 then
    begin
      mnuActTransfer.Caption := 'Transfer to Inpatient...';
      mnuActTransfer.Enabled := True;
    end
    else if lstMedsIn.SelCount > 0 then
    begin
      mnuActTransfer.Caption := 'Transfer to Outpatient...';
      mnuActTransfer.Enabled := True;
    end
    else
      AllowTransfer := False;
  end;
  if not AllowTransfer then
  begin
    mnuActTransfer.Caption := 'Transfer to...';
    mnuActTransfer.Enabled := False;
  end;
  mnuActDC.Caption := GetOrderStatus;
  mnuActDC.Enabled := SomethingSelected;
end;

function TfrmMeds.GetOrderStatus: string;

  procedure CountStatus(const ABox: TCaptionListBox;
    var ACancelledCount, ADiscontinuedCount: Integer);
  // Increases the pased in ACancelledCount and ADiscontinuedCount by the
  // number of cancelled and discontinued from the selected items in
  // the ABox (using the previously existing logic.)

    function IsPending(MedObj: TMedListRec): Boolean;
    begin
      Result := uPendingChanges.Values[Piece(MedObj.OrderID, ';', 1)] <> '';
    end;

  var
    i: Integer;
  begin
    if Assigned(ABox) then
    begin
      if ABox.SelCount > 0 then
      begin
        for i := 0 to ABox.Count - 1 do
        begin
          if ABox.Selected[i] then
          begin
            if (Assigned(ABox.Items.Objects[i])) and
              (ABox.Items.Objects[i] is TMedListRec) and
              (not IsPending(TMedListRec(ABox.Items.Objects[i]))) then
              inc(ADiscontinuedCount)
            else
              inc(ACancelledCount);
          end;
        end;
      end;
    end;
  end;

var
  ACancelledCount, ADiscontinuedCount: Integer;
begin
  Result := '&Discontinue/Cancel Orders';
  ACancelledCount := 0;
  ADiscontinuedCount := 0;
  CountStatus(LstMedsIn, ACancelledCount, ADiscontinuedCount);
  CountStatus(LstMedsOut, ACancelledCount, ADiscontinuedCount);
  CountStatus(LstMedsNonVA, ACancelledCount, ADiscontinuedCount);
  if (ACancelledCount > 0) and (ADiscontinuedCount = 0) then
      Result := Pluralize(ACancelledCount, '&Cancel Unsigned Order...',
      '&Cancel Unsigned Orders...')
  else if (ACancelledCount = 0) and (ADiscontinuedCount > 0) then
      Result := Pluralize(ADiscontinuedCount, '&Discontinue Order...',
      '&Discontinue Orders...')
  else if (ACancelledCount > 0) and (ADiscontinuedCount > 0) then
      Result := '&Discontinue / Cancel Orders...';
  FOrderTitleCaption := Result;
end;

procedure TfrmMeds.mnuActDCClick(Sender: TObject);
{ discontinue/cancel/delete the selected med orders as appropriate for each order }
{ similar to action on fOrders }
var
  ActiveList: TListBox;
  SelectedList: TList;
  DelEvt: Boolean;
begin
  inherited;
  DelEvt := False;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  SelectedList := TList.Create;
  try
    FIterating := True;
    if AuthorizedUser and EncounterPresent and LockedForOrdering then
    begin
      ValidateSelected(ActiveList, OA_DC, TX_NO_DC, TC_NO_DC);
      ActivateDeactiveRenew(ActiveList);
      // AGP 26.53 TURN OFF UNTIL FINAL DECISION CAN BE MADE
      MakeSelectedList(ActiveList, SelectedList);
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, 'Unsigned ', '', [rfReplaceAll]);
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, '&', '', [rfReplaceAll]);
      FOrderTitleCaption := StringReplace(FOrderTitleCaption, '...', '', [rfReplaceAll]);

      if ExecuteDCOrders(SelectedList, DelEvt, FOrderTitlecaption) then
      begin
        ResetSelectedForList(ActiveList);
        SynchListToOrders(ActiveList, SelectedList);
      end;
      if DelEvt then
        frmFrame.mnuFileRefreshClick(self);
    end;
  finally
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmMeds.mnuActHoldClick(Sender: TObject);
{ hold the selected med orders as appropriate for each order }
{ similar to action on fOrders }
var
  ActiveList: TListBox;
  SelectedList: TList;
begin
  inherited;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  SelectedList := TList.Create;
  if CheckMedStatus(ActiveList) = True then
    Exit;
  try
    FIterating := True;
    if AuthorizedUser and EncounterPresent and LockedForOrdering then
    begin
      ValidateSelected(ActiveList, OA_HOLD, TX_NO_HOLD, TC_NO_HOLD);
      MakeSelectedList(ActiveList, SelectedList);
      if ExecuteHoldOrders(SelectedList) then
      begin
        AddSelectedToChanges(SelectedList);
        ResetSelectedForList(ActiveList);
        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    ActiveList.SetFocus;
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmMeds.mnuActRenewClick(Sender: TObject);
{ renew the selected med orders as appropriate for each order }
{ similar to action on fOrders }
var
  ActiveList: TListBox;
  SelectedList: TList;
  ParntOrder: TOrder;
begin
  if FRenewing then
    Exit;
  FRenewing := True;
  try
    inherited;
    ActiveList := ListSelected(TX_NOSEL);
    if ActiveList = nil then
      Exit;
    SelectedList := TList.Create;
    try
      FIterating := True;
      if CheckMedStatus(ActiveList) = True then
        Exit;
      if AuthorizedUser and EncounterPresent and LockedForOrdering then
      begin
        ValidateSelected(ActiveList, OA_RENEW, TX_NO_RENEW, TC_NO_RENEW);
        MakeSelectedList(ActiveList, SelectedList);
        if Length(FParentComplexOrderID) > 0 then
        begin
          ParntOrder := GetOrderByIFN(FParentComplexOrderID);
          if CharAt(ParntOrder.Text, 1) = '+' then
            ParntOrder.Text := Copy(ParntOrder.Text, 2, Length(ParntOrder.Text));
          if Pos('First Dose NOW', ParntOrder.Text) > 1 then
            Delete(ParntOrder.Text, Pos('First Dose NOW', ParntOrder.Text),
              Length('First Dose NOW'));
          SelectedList.Add(ParntOrder);
          FParentComplexOrderID := '';
        end;
        if ExecuteRenewOrders(SelectedList) then
        begin
          AddSelectedToChanges(SelectedList);
          ResetSelectedForList(ActiveList);
          SynchListToOrders(ActiveList, SelectedList);
        end;
      end;
    finally
      ActiveList.SetFocus;
      FIterating := False;
      SelectedList.Free;
      UnlockIfAble;
    end;
  finally
    FRenewing := False;
  end;
end;

procedure TfrmMeds.mnuActUnholdClick(Sender: TObject);
var
  ActiveList: TListBox;
  SelectedList: TList;
begin
  inherited;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  if not AuthorizedUser then
    Exit;
  if not EncounterPresent then
    Exit;
  if not LockedForOrdering then
    Exit;
  SelectedList := TList.Create;
  try
    if CheckMedStatus(ActiveList) = True then
      Exit;
    ValidateSelected(ActiveList, OA_UNHOLD, TX_NO_UNHOLD, TC_NO_UNHOLD);
    // validate release hold action
    MakeSelectedList(ActiveList, SelectedList); // build list of selected orders
    if ExecuteUnholdOrders(SelectedList) then
    begin
      AddSelectedToChanges(SelectedList);
      ResetSelectedForList(ActiveList);
      SynchListToOrders(ActiveList, SelectedList);
    end;
  finally
    ActiveList.SetFocus;
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmMeds.mnuActChangeClick(Sender: TObject);
{ loop thru selected med orders, present ordering dialog for each with defaults to selected order }
{ similar to action on fOrders }
var
  i: Integer;
  ActiveList: TListBox;
  SelectedList: TList;
  ChangeIFNList: TStringList;
  DelayEvent: TOrderDelayEvent;
begin
  inherited;
  if not EncounterPresentEDO then
    Exit;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  DelayEvent.EventType := 'C'; // temporary, so can pass to ChangeOrders
  DelayEvent.Specialty := 0;
  DelayEvent.Effective := 0;
  DelayEvent.EventIFN := 0;
  SelectedList := TList.Create;
  // temporary until able to create ChangeIFNList directly
  ChangeIFNList := TStringList.Create;
  try
    FIterating := True;
    if CheckMedStatus(ActiveList) = True then
      Exit;
    ValidateSelected(ActiveList, OA_CHANGE, TX_NO_CHANGE, TC_NO_CHANGE);
    MakeSelectedList(ActiveList, SelectedList);
    with SelectedList do
      for i := 0 to Count - 1 do
        ChangeIFNList.Add(TOrder(Items[i]).ID);
    if not ShowMsgOn(ChangeIFNList.Count = 0, TX_NOSEL, TC_NOSEL) then
      ChangeOrders(ChangeIFNList, DelayEvent);
    SynchListToOrders(ActiveList, SelectedList); // rehighlights
    ActiveList.SetFocus;
  finally
    SelectedList.Free;
    ChangeIFNList.Free;
  end;
end;

procedure TfrmMeds.mnuActCopyClick(Sender: TObject);
{ loop thru selected med orders, present ordering dialog for each with defaults to selected order }
{ similar to action on fOrders }
const
  CP_TXT = 'copied';
  XF_TXT = 'transferred';
var
  i: Integer;
  LimitEvent: Char;
  ActiveList: TListBox;
  SelectedList: TList;
  CopyIFNList: TStringList;
  TempEvent, DelayEvent: TOrderDelayEvent;
  ActName, radTxt, thePtEvtID, AuthErr: string;
  IsNewEvent, needVerify, NewOrderCreated, DoesDestEvtOccur: Boolean;

begin
  inherited;
  AuthErr := '';
  ActName := '';
  if not EncounterPresentEDO then
    Exit;
  CheckAuthForMeds(AuthErr);
  if (Length(AuthErr) > 0) then
  begin
    ShowMsg(AuthErr);
    if not EncounterPresent then
      Exit;
  end;
  if not FActionOnMedsTab then
    FActionOnMedsTab := True;
  DelayEvent.EventType := #0;
  DelayEvent.EventIFN := 0;
  DelayEvent.EventName := '';
  DelayEvent.Specialty := 0;
  DelayEvent.Effective := 0;
  DelayEvent.PtEventIFN := 0;
  DelayEvent.TheParent := TParentEvent.Create(0);
  DelayEvent.IsNewEvent := False;
  TempEvent := DelayEvent;
  DoesDestEvtOccur := False;
  ActiveList := ListSelected(TX_NOSEL);
  if not Assigned(ActiveList) then
    Exit;
  if CheckMedStatus(ActiveList) = True then
    Exit;
  FIterating := true;
  ValidateSelected(ActiveList, OA_COPY, TX_NO_COPY, TC_NO_COPY);
  try
    NewOrderCreated := False;
    if frmOrders.lstSheets.ItemIndex >= 0 then
    begin
      frmOrders.lstSheets.ItemIndex := 0;
      frmOrders.lstSheetsClick(Application);
    end;
    LimitEvent := #0;
    if TComponent(Sender).Name = 'mnuActTransfer' then
    begin
      ActName := 'Transfer';
      IsTransferAction := True;
      radTxt := XF_TXT;
      if ActiveList = lstMedsOut then
      begin
        if Patient.Inpatient then
          LimitEvent := 'C'
        else
          LimitEvent := 'A';
        XferOutToInOnMeds := True;
      end;
      if ActiveList = lstMedsIn then
      begin
        if Patient.Inpatient then
          LimitEvent := 'D'
        else
        begin
          LimitEvent := 'C';
          XfInToOutNow := True;
        end;
        XferOutToInOnMeds := False;
      end;
    end
    else
      radTxt := CP_TXT;
    if (LimitEvent = 'A') and (not WriteAccess(waDelayedOrders, True)) then
      exit;
    SelectedList := TList.Create;
    // temporary until able to create CopyIFNList directly
    CopyIFNList := TStringList.Create;
    try
      MakeSelectedList(ActiveList, SelectedList, ActName);
      { if (CopyIFNList.Count = 0) and (ActName = 'Transfer') then
        Exit; }
      with SelectedList do
        for i := 0 to Count - 1 do
          CopyIFNList.Add(TOrder(Items[i]).ID);
      if CopyIFNList.Count > 0 then
      begin
        IsNewEvent := False;
        if SetDelayEventForMed(radTxt, DelayEvent, IsNewEvent, LimitEvent) then
        begin
          if (ActiveList = lstMedsOut) and (DelayEvent.EventIFN > 0) then
            XferOutToInOnMeds := True;
          TempEvent.PtEventIFN := DelayEvent.PtEventIFN;
          TempEvent.EventName := DelayEvent.EventName;
          if (DelayEvent.PtEventIFN > 0) and
            IsCompletedPtEvt(DelayEvent.PtEventIFN) then
          begin
            DelayEvent.EventType := 'C';
            DelayEvent.PtEventIFN := 0;
            DelayEvent.EventName := '';
            DelayEvent.EventIFN := 0;
            DelayEvent.TheParent := TParentEvent.Create(0);
            DoesDestEvtOccur := True;
            needVerify := False;
            CopyOrders(CopyIFNList, DelayEvent, DoesDestEvtOccur, needVerify);
            if XferOutToInOnMeds then
              XferOutToInOnMeds := False;
            if frmOrders <> nil then
              frmOrders.PtEvtCompleted(TempEvent.PtEventIFN, TempEvent.EventName);
            Exit;
          end;
          if (DelayEvent.EventIFN > 0) and (DelayEvent.EventType <> 'D') then
          begin
            needVerify := False;
            uAutoAC := True;
          end
          else
          begin
            needVerify := True;
            uAutoAC := False;
          end;
          if LimitEvent = #0 then
          begin
            if CopyOrders(CopyIFNList, DelayEvent, DoesDestEvtOccur, needVerify)
            then
              NewOrderCreated := True;
            if ImmdCopyAct then
              ImmdCopyAct := False;
          end
          else
          begin
            if TransferOrders(CopyIFNList, DelayEvent, DoesDestEvtOccur,
              needVerify) then
              NewOrderCreated := True;
          end;
          if XferOutToInOnMeds then
            XferOutToInOnMeds := False;
          if (DelayEvent.EventIFN > 0) and
            (isExistedEvent(Patient.DFN, IntToStr(DelayEvent.EventIFN),
            thePtEvtID)) then
            frmOrders.HighlightFromMedsTab := StrToIntDef(thePtEvtID, 0);
          if (not NewOrderCreated) and (DelayEvent.EventIFN > 0) then
            if isExistedEvent(Patient.DFN, IntToStr(DelayEvent.EventIFN),
              thePtEvtID) then
            begin
              if PtEvtEmpty(thePtEvtID) then
              begin
                DeletePtEvent(thePtEvtID);
                frmOrders.ChangesUpdate(thePtEvtID);
                frmOrders.EventDefaultOrder := '';
                frmOrders.InitOrderSheetsForEvtDelay;
                if frmOrders.lstSheets.ItemIndex <> 0 then
                  frmOrders.lstSheets.ItemIndex := 0;
                frmOrders.lstSheetsClick(self);
              end;
            end;
        end;
      end;
      SynchListToOrders(ActiveList, SelectedList); // rehighlights
      if IsTransferAction then
        IsTransferAction := False;
      if XferOutToInOnMeds then
        XferOutToInOnMeds := False;
      if XfInToOutNow then
        XfInToOutNow := False;
      frmOrders.PtEvtCompleted(TempEvent.PtEventIFN, TempEvent.EventName, True);
    finally
      ActiveList.SetFocus;
      FActionOnMedsTab := False;
      uAutoAC := False;
      SelectedList.Free;
      CopyIFNList.Free;
    end;
  finally
    FIterating := false;
  end;
end;

procedure TfrmMeds.mnuActNewClick(Sender: TObject);
{ new med orders dependent on order dialog for inpatient or outpatient }
{ similar to lstWriteClick on fOrders }
var
  DialogInfo: string;
  DelayEvent: TOrderDelayEvent;
begin
  inherited;
  DelayEvent.EventType := 'C'; // temporary, so can pass to CopyOrders
  DelayEvent.Specialty := 0;
  DelayEvent.EventIFN := 0;
  DelayEvent.Effective := 0;
  frmOrders.DontCheck := True;
  frmOrders.lstSheets.ItemIndex := 0;
  frmOrders.lstSheetsClick(self);
  frmOrders.DontCheck := False;
  if not ReadyForNewOrder(DelayEvent) then
    Exit;
  frmOrders.DontCheck := True;
  frmOrders.lstSheets.ItemIndex := 0;
  frmOrders.lstSheetsClick(self);
  frmOrders.DontCheck := False;
  { get appropriate form, create the dialog form and show it }
  DialogInfo := GetNewDialog; // DialogInfo = DlgIEN;FormID;DGroup
  case CharAt(Piece(DialogInfo, ';', 4), 1) of
    'A':
      ActivateAction(Piece(DialogInfo, ';', 1), self, 0);
    'D', 'Q':
      ActivateOrderDialog(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
    'M':
      ActivateOrderMenu(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
    'O':
      ActivateOrderSet(Piece(DialogInfo, ';', 1), DelayEvent, self, 0);
  else
    InfoBox('Unsupported dialog type', 'Error', MB_OK);
  end; { case }
end;

procedure TfrmMeds.mnuActOneStepClick(Sender: TObject);
begin
  inherited;
  ShowOneStepAdmin;
end;

procedure TfrmMeds.actParkExecute(Sender: TObject);
// Park the selected med orders as appropriate for each order
// similar to action on fOrders

  function CheckRequirements: Boolean;
  begin
    Result := AuthorizedUser and EncounterPresent and LockedForOrdering;
  end;

var
  ActiveList: TListBox;
  SelectedList: TList;
  ErrorString: String;
begin
  inherited;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  SelectedList := TList.Create;
  if CheckMedStatus(ActiveList) = True then
    Exit;
  try
    FIterating := True;
    ErrorString := '';
    if CheckRequirements then
    begin
      ValidateSelected(ActiveList, OA_PARK, TX_NO_PARK, TC_NO_PARK);
      MakeSelectedList(ActiveList, SelectedList);
      if ExecuteParkOrders(SelectedList) then
      begin
        // if bPaPIParkSignature then // enables review and signature // This was NEVER true
        //   AddSelectedToChanges(SelectedList); // modifies Change list
        ResetSelectedForList(ActiveList);
        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    ActiveList.SetFocus;
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmMeds.actUnparkExecute(Sender: TObject);

  function CheckRequirements: Boolean;
  begin
    Result := AuthorizedUser and EncounterPresent and LockedForOrdering;
  end;

var
  ActiveList: TListBox;
  SelectedList: TList;
  ErrorString: String;
begin
  inherited;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  SelectedList := TList.Create;
  if CheckMedStatus(ActiveList) = True then
    Exit;
  try
    FIterating := True;
    ErrorString := '';
    if CheckRequirements then
    begin
      ValidateSelected(ActiveList, OA_UNPARK, TX_NO_UNPARK, TC_NO_UNPARK);
      MakeSelectedList(ActiveList, SelectedList);
      if ExecuteUnParkOrders(SelectedList) then
      begin
        // if bPaPIParkSignature then // enables review and signature // This was NEVER true
        //   AddSelectedToChanges(SelectedList); // modifies Change list
        ResetSelectedForList(ActiveList);
        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    ActiveList.SetFocus;
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

procedure TfrmMeds.mnuActRefillClick(Sender: TObject);
{ for selected orders, present refill dialog }
var
  ActiveList: TListBox;
  SelectedList: TList;
begin
  inherited;
  ActiveList := ListSelected(TX_NOSEL);
  if ActiveList = nil then
    Exit;
  if CheckMedStatus(ActiveList) = True then
    Exit;
  SelectedList := TList.Create;
  try
    FIterating := True;
    if AuthorizedUser and EncounterPresent and LockedForOrdering then
    begin
      ValidateSelected(ActiveList, OA_REFILL, TX_NO_REFILL, TC_NO_REFILL);
      MakeSelectedList(ActiveList, SelectedList);
      if ExecuteRefillOrders(SelectedList) then
      begin
        ResetSelectedForList(ActiveList);
        SynchListToOrders(ActiveList, SelectedList);
      end;
    end;
  finally
    ActiveList.SetFocus;
    FIterating := False;
    SelectedList.Free;
    UnlockIfAble;
  end;
end;

{ Action utilities --------------------------------------------------------------------------- }

function TfrmMeds.ListSelected(const ErrMsg: string): TListBox;
{ return selected listbox - inpatient or outpatient }
begin
  Result := nil;
  if lstMedsOut.SelCount > 0 then
    Result := lstMedsOut
  else if lstMedsIn.SelCount > 0 then
    Result := lstMedsIn
  else if lstMedsNonVA.SelCount > 0 then
    Result := lstMedsNonVA;
  if Result = nil then
    InfoBox(ErrMsg, TC_NOSEL, MB_OK);
end;

procedure TfrmMeds.ValidateSelected(AListBox: TListBox;
  const AnAction, WarningMsg, WarningTitle: string);
{ loop to validate action on each selected med order, deselect if not valid }
var
  i: Integer;
  OrderText, CurID: string;
  ErrMsg, AParentID: string;
  CheckedList, SomePharmacyOrders: TStringList;
  ChildOrder: TChildOD;
  AMed: TMedListRec;
begin
  CheckedList := TStringList.Create;
  SomePharmacyOrders := GetPharmacyOrders(AListBox);
  with AListBox do
  begin
    WriteAccessV.BeginErrors;
    try
      for i := 0 to Items.Count - 1 do
        if Selected[i] then
        begin
          AMed := TMedListRec(GetMedList(AListBox)[i]);
          if not canWriteOrder(AMed.DGroupIEN, '', AnAction, True, AMed.Instruct) then
          begin
            Selected[i] := false;
            continue;
          end;
        end;
    finally
      WriteAccessV.EndErrors(False);
    end;
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        if (AnAction = 'RN') and
          (PassDrugTest(StrtoINT(Piece(Piece(SomePharmacyOrders[i], U, 2), ';',
          1)), 'E', True, True) = True) then
        begin
          ShowMsg('Cannot renew Clozapine orders.');
          Selected[i] := False;
          CONTINUE;
        end;
        if (AnAction = 'RN') and (Pos('Active', AListBox.Items[i]) > 0) and
          (AListBox.Name = 'lstMedsIn') and (Patient.Inpatient) and
          (IsClinicLoc(Encounter.Location)) then
        begin
          Selected[i] := False;
          MessageDlg
            ('You cannot renew inpatient medication orders from a clinic location for selected patient.',
            mtWarning, [mbOK], 0);
        end;

        CurID := uPendingChanges.Values
          [Piece(Piece(SomePharmacyOrders[i], U, 2), ';', 1)];
        if Length(CurID) > 0 then
          CurID := Piece(CurID, U, 2)
        else
          CurID := Piece(SomePharmacyOrders[i], U, 2);
        ValidateOrderAction(CurID, AnAction, ErrMsg);
        if (Length(ErrMsg) > 0) and IsFirstDoseNowOrder(CurID) then
        begin
          InfoBox(AListBox.Items[i] + #13 + WarningMsg + ErrMsg,
            WarningTitle, MB_OK);
          Selected[i] := False;
          CONTINUE;
        end;
        if Length(ErrMsg) = 0 then
        begin
          WarningOrderAction(CurID, AnAction, ErrMsg);
          if (Piece(ErrMsg, U, 1) = '1') then
          begin
            if (InfoBox(AListBox.Items[i] + CRLF + CRLF + Piece(ErrMsg, U, 2),
              'Warning', MB_YESNO or MB_ICONWARNING) = IDNO) then
            begin
              Selected[i] := False;
              CONTINUE;
            end
            else
              ErrMsg := '';
          end
          else
            ErrMsg := '';
        end;
        AParentID := '';
        if not IsValidActionOnComplexOrder(CurID, AnAction, AListBox,
          CheckedList, ErrMsg, AParentID) then
          Selected[i] := False;
        if Length(AParentID) > 0 then
        begin
          if ChildODList.IndexOf(CurID) < 0 then
          begin
            ChildOrder := TChildOD.Create;
            ChildOrder.ChildID := CurID;
            ChildOrder.ParentID := AParentID;
            ChildODList.AddObject(CurID, ChildOrder);
          end;
        end;
        if Length(ErrMsg) > 0 then
        begin
          OrderText := TextForOrder(Piece(SomePharmacyOrders[i], U, 2));
          InfoBox(OrderText + WarningMsg + ErrMsg, WarningTitle, MB_OK);
          Selected[i] := False;
        end;
        if Selected[i] and (not OrderIsLocked(CurID, AnAction)) then
          Selected[i] := False;
      end;
  end;
end;

procedure TfrmMeds.MakeSelectedList(AListBox: TListBox; AList: TList;
  ActName: string);
{ make a list of selected med orders }
var
  i, idx: Integer;
  AnOrder: TOrder;
  CurID, X: string;
  SomePharmacyOrders: TStringList;
  TempList: TStringList;
begin
  SomePharmacyOrders := GetPharmacyOrders(AListBox);
  TempList := TStringList.Create;
  AList.Clear;
  with AListBox do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        CurID := uPendingChanges.Values
          [Piece(Piece(SomePharmacyOrders[i], U, 2), ';', 1)];
        if Length(CurID) > 0 then
          CurID := Piece(CurID, U, 2)
        else
          CurID := Piece(SomePharmacyOrders[i], U, 2);
        AnOrder := GetOrderByIFN(CurID);
        if ActName = 'Transfer' then // imo
        begin
          if (AnOrder.DGroup = ClinDisp) then // imo
          begin
            X := AnOrder.Text + #13#10 +
              'Clinic medication orders can not be transferred';
            if ShowMsgOn(Length(X) > 0, X, 'Unable to transfer.') then
            begin
              AListBox.Selected[i] := False;
              CONTINUE;
            end
          end;
        end;
        idx := ChildODList.IndexOf(AnOrder.ID);
        if idx > -1 then
          AnOrder.ParentID := TChildOD(ChildODList.Objects[idx]).ParentID;
        if TempList.IndexOf(AnOrder.ID) = -1 then
        begin
          AList.Add(AnOrder);
          TempList.Add(AnOrder.ID);
        end;
      end;
  TempList.Clear;
end;

procedure TfrmMeds.SynchListToOrders(AListBox: TListBox; AList: TList);
begin
  AListBox.Invalidate;
end;

procedure TfrmMeds.popMedPopup(Sender: TObject);
begin
  inherited;
  if not WriteAccess(waMeds) then
  begin
    actPark.Enabled := False;
    actUnpark.Enabled := False;
    mnuActRenew.Enabled := False;
    mnuActRefill.Enabled := False;
    popMedRefill.Enabled := False;
    popMedRenew.Enabled := False;
    popMedDC.Enabled := False;
    popMedChange.Enabled := False;
    popMedNew.Enabled := False;
    DocumentNonVAMeds2.Enabled := False;
    exit;
  end;

  if User.NoOrdering then
  begin
    actPark.Enabled := False;
    actUnpark.Enabled := False;
    mnuActRenew.Enabled := False;
    mnuActRefill.Enabled := False;
    popMedRefill.Enabled := False;
    popMedRenew.Enabled := False;
    popMedDC.Enabled := False;
    DocumentNonVAMeds2.Enabled := False;
    exit;
  end;
  PaPI_GUIsetup;

  if lstMedsNonVA.SelCount > 0 then
  begin
    mnuActRenew.Enabled := False;
    mnuActRefill.Enabled := False;
    popMedRefill.Enabled := False;
    popMedRenew.Enabled := False;
  end
  else
  begin
    mnuActRenew.Enabled := True;
    mnuActRefill.Enabled := True;
    popMedRefill.Enabled := True;
    popMedRenew.Enabled := True;
  end;
  popMedDC.Enabled := SomethingSelected;
  popMedDC.Caption := GetOrderStatus;
end;

function TfrmMeds.SomethingSelected: boolean;
begin
  Result := lstMedsOut.SelCount + lstMedsIn.SelCount + lstMedsNonVA.SelCount > 0;
end;

procedure TfrmMeds.mnuViewClick(Sender: TObject);
begin
  inherited;
  // if PatientStatusChanged then exit;
end;

procedure TfrmMeds.lstMedsNonVAClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  // if PatientStatusChanged then exit;
  with lstMedsIn do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
  with lstMedsOut do
    for i := 0 to Items.Count - 1 do
      Selected[i] := False;
end;

procedure TfrmMeds.lstMedsNonVADblClick(Sender: TObject);
begin
  inherited;
  mnuViewDetailClick(self);
end;

procedure TfrmMeds.lstMedsNonVAExit(Sender: TObject);
begin
  inherited;
  if not FIterating then
    ResetSelectedForList(TListBox(Sender));
end;

procedure TfrmMeds.lstMedsNonVARightClickHandler(var Msg: TMessage;
  var Handled: Boolean);
begin
  if Msg.Msg = WM_RBUTTONUP then
  begin
    lstMedsNonVA.RightClickSelect := (lstMedsNonVA.SelCount < 1);
    lstMedsNonVAClick(lstMedsNonVA);
  end;
end;

procedure TfrmMeds.hdrMedsNonVASectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  LockDrawing;
  try
    with lstMedsNonVA do
    begin
      IntegralHeight := not IntegralHeight;
      // both lines are necessary, this forces the
      IntegralHeight := not IntegralHeight; // listbox window to be recreated
    end;
  finally
    UnlockDrawing;
  end;
  lstMedsNonVA.Invalidate;
  Refresh;
end;

function FontChanged: Boolean;
// CQ9182:  SEE ALSO procedure TfrmFrame.mnuFontSizeClick()
begin
  Result := False;
  if Assigned(frmMeds) then
  begin
    if fMeds.oldFont = 0 then
      Result := False
    else if (fMeds.oldFont <> MainFontSize) then
      Result := True;
  end;
end;

procedure TfrmMeds.FormResize(Sender: TObject);
var
  maxPanelHeight: Integer;

begin
  inherited;
  if Assigned(frmMeds) then
  begin
    // CQ9522 v26.51 Make sure all three panels are visible regardless of font size
    if Assigned(self.Parent) then
    begin
      if self.Height > Parent.ClientHeight then
        self.Height := Parent.ClientHeight;
      maxPanelHeight := round((Parent.ClientHeight - 20) / 3);
      if gdpOut.Height + gdpIn.Height + gdpNon.Height > Parent.ClientHeight then
      begin
        // gdpIn.Height := maxPanelHeight*2;
        gdpIn.Height := maxPanelHeight;
        gdpNon.Height := maxPanelHeight;
        gdpOut.Height := maxPanelHeight;
      end;
    end; // assigned(self.parent)
  end;
end;

{ TChildOD }

constructor TChildOD.Create;
begin
  ChildID := '';
  ParentID := '';
end;

procedure TfrmMeds.hdrMedsOutResize(Sender: TObject);
begin
  inherited;
  with hdrMedsOut do
  begin
    Height := TextHeightByFont(Font.Handle, Sections[0].Text);
    Invalidate;
  end;
end;

procedure TfrmMeds.hdrMedsNonVAResize(Sender: TObject);
begin
  inherited;
  with hdrMedsNonVA do
  begin
    Height := TextHeightByFont(Font.Handle, Sections[0].Text);
    Invalidate;
  end;
end;

procedure TfrmMeds.hdrMedsInResize(Sender: TObject);
begin
  inherited;
  with hdrMedsIn do
  begin
    Height := TextHeightByFont(Font.Handle, Sections[0].Text);
    Invalidate;
  end;
end;

procedure TfrmMeds.FormShow(Sender: TObject);
begin
  inherited;
  frmMeds.FormResize(Sender);
end;

procedure TfrmMeds.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  frmMeds.FormResize(Sender);
end;

procedure TfrmMeds.splitBottomMoved(Sender: TObject);
begin
  inherited;
  splitBottom.Height := 5;
  splitBottom.Repaint;
end;

procedure TfrmMeds.splitTopMoved(Sender: TObject);
begin
  inherited;
  splitTop.Height := 5;
  splitTop.Repaint;
end;

procedure TfrmMeds.InitfMedsSize;
var
  retList: TStringList;
  strSizeFlds, X: string;
  i: Integer;
  medsSplitFnd: Boolean;
  panelBottom, panelMedIn: Integer;
begin
  // CQ3229
  // DETECT 1st TIME USER.
  // If first time user (medSplitFound=false), then manually set panel heights.
  // if NOT first time user (medSplitFound=true), then set Meds tab windows to saved settings.
  medsSplitFnd := False;
  if Assigned(frmMeds) then
  begin
    retList := TStringList.Create;
    try
      CallVistA('ORWCH LOADALL', [nil], retList);
      for i := 0 to retList.Count - 1 do
      begin
        X := retList.Strings[i];
        if strPos(PChar(X), PChar(MEDS_SPLIT_FORM)) <> nil then
        begin
          medsSplitFnd := True;
          Break;
        end;
      end;
    finally
      FreeAndNil(retList);
    end;
    if not medsSplitFnd then
    begin
      gdpIn.Height := frmMeds.Height div 2;
      gdpIn.Height := gdpIn.Height div 2;
      panelBottom := gdpIn.Height;
      panelMedIn := gdpIn.Height;
      strSizeFlds := IntToStr(panelBottom) + ',' + IntToStr(panelMedIn) + ',' +
        '0' + ',' + '0';
      CallVistA('ORWCH SAVESIZ', [MEDS_SPLIT_FORM, strSizeFlds]);
    end;
  end;
end;

{ function TfrmMeds.PatientStatusChanged: boolean;
  const

  msgTxt1 = 'Patient status was changed from ';
  msgTxt2 = 'CPRS needs to refresh patient information to display patient latest record.';
  //GE CQ9537  - Change message text
  msgTxt3 = 'Patient has been admitted.';
  msgTxt4 = CRLF +'You will be prompted to sign your orders.  Any new orders subsequently' +
  CRLF + 'entered and signed will be directed to the inpatient staff.';

  var
  PtSelect: TPtSelect;
  IsInpatientNow: boolean;
  ptSts: string;
  begin
  result := False;
  SelectPatient(Patient.DFN, PtSelect);
  IsInpatientNow := Length(PtSelect.Location) > 0;
  //GE CQ9537  - Change message text
  if Patient.Inpatient <> IsInpatientNow then
  begin
  if (not Patient.Inpatient) then MessageDlg(msgTxt3 + msgTxt4, mtWarning, [mbOK], 0);
  if Patient.Inpatient then ptSts := 'Inpatient to Outpatient.';
  MessageDlg(msgTxt1 + ptSts + #13#10#13 + msgTxt2, mtWarning, [mbOK], 0);
  frmFrame.mnuFileRefreshClick(Application);
  Result := True;
  end;
  end; }

function TfrmMeds.GetTotalSectionsWidth(Sender: TObject): Integer;
// CQ7586
// Return stored values of column widths
var
  i: Integer;
begin
  Result := 0;

  if (Sender as THeaderControl).Name = 'hdrMedsOut' then
    for i := 0 to hdrMedsOut.Sections.Count - 1 do
      Result := Result + hdrMedsOut.Sections[i].Width;

  if (Sender as THeaderControl).Name = 'hdrMedsIn' then
    for i := 0 to hdrMedsIn.Sections.Count - 1 do
      Result := Result + hdrMedsIn.Sections[i].Width;

  if (Sender as THeaderControl).Name = 'hdrMedsNonVA' then
    for i := 0 to hdrMedsNonVA.Sections.Count - 1 do
      Result := Result + hdrMedsNonVA.Sections[i].Width;
end;

procedure TfrmMeds.SetSectionWidths(Sender: TObject);
// CQ7586
// Copy values of column widths into array variables.
var
  i: Integer;
begin
  if (Sender as THeaderControl).Name = 'hdrMedsOut' then
    for i := 0 to hdrMedsOut.Sections.Count - 1 do
      OrigOutPtSecWidths[i] := hdrMedsOut.Sections[i].Width;

  if (Sender as THeaderControl).Name = 'hdrMedsIn' then
    for i := 0 to hdrMedsIn.Sections.Count - 1 do
      OrigInPtSecWidths[i] := hdrMedsIn.Sections[i].Width;

  if (Sender as THeaderControl).Name = 'hdrMedsNonVA' then
    for i := 0 to hdrMedsNonVA.Sections.Count - 1 do
      OrigNonVASecWidths[i] := hdrMedsNonVA.Sections[i].Width;
end;

procedure TfrmMeds.SetViewCaption(Caption: String);
begin
  txtView.Caption := StringReplace(Caption, '&', '', [rfReplaceAll]);
end;

procedure TfrmMeds.hdrMedsOutMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  self.SetSectionWidths(Sender); // CQ7586
end;

procedure TfrmMeds.hdrMedsNonVAMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  self.SetSectionWidths(Sender); // CQ7586
end;

procedure TfrmMeds.hdrMedsInMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  self.SetSectionWidths(Sender); // CQ7586
end;

procedure TfrmMeds.hdrMedsOutMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// CQ7586
var
  i: Integer;
  totalSectionsWidth, originalwidth: Integer;
begin
  inherited;
  totalSectionsWidth := self.GetTotalSectionsWidth(Sender);
  if totalSectionsWidth > lstMedsOut.Width - 5 then
  // could used any of the three list boxes here, since all are same width
  begin
    originalwidth := 0;
    for i := 0 to hdrMedsOut.Sections.Count - 1 do
      originalwidth := originalwidth + OrigOutPtSecWidths[i];
    if originalwidth < totalSectionsWidth then
    begin
      for i := 0 to hdrMedsOut.Sections.Count - 1 do
        hdrMedsOut.Sections[i].Width := OrigOutPtSecWidths[i];
      lstMedsOut.Invalidate;
    end;
  end;
  // CQ9622
  if hdrMedsOut.Sections[1].Width < 100 then
  begin
    hdrMedsOut.Sections[1].Width := 100;
    lstMedsOut.Refresh;
  end;
  // end CQ9622
  gdpOut.Height := gdpOut.Height - 1; // forces autopanel resize
  gdpOut.Height := gdpOut.Height + 1; // forces autopanel resize
end;

procedure TfrmMeds.hdrMedsNonVAMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// CQ7586
var
  i: Integer;
  totalSectionsWidth, originalwidth: Integer;
begin
  inherited;
  totalSectionsWidth := self.GetTotalSectionsWidth(Sender);
  if totalSectionsWidth > lstMedsNonVA.Width - 5 then
  // could used any of the three list boxes here, since all are same width
  begin
    originalwidth := 0;
    for i := 0 to hdrMedsNonVA.Sections.Count - 1 do
      originalwidth := originalwidth + OrigNonVASecWidths[i];
    if originalwidth < totalSectionsWidth then
    begin
      for i := 0 to hdrMedsNonVA.Sections.Count - 1 do
        hdrMedsNonVA.Sections[i].Width := OrigNonVASecWidths[i];
      lstMedsNonVA.Invalidate;
    end;
  end;
  // CQ9622
  if hdrMedsNonVA.Sections[1].Width < 100 then
  begin
    hdrMedsNonVA.Sections[1].Width := 100;
    lstMedsNonVA.Refresh;
  end;
  // end CQ9622
  gdpNon.Height := gdpNon.Height - 1; // forces autopanel resize
  gdpNon.Height := gdpNon.Height + 1; // forces autopanel resize
end;

procedure TfrmMeds.hdrMedsInMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// CQ7586
var
  i: Integer;
  totalSectionsWidth, originalwidth: Integer;
begin
  inherited;
  totalSectionsWidth := self.GetTotalSectionsWidth(Sender);
  if totalSectionsWidth > lstMedsIn.Width - 5 then
  // could used any of the three list boxes here, since all are same width
  begin
    originalwidth := 0;
    for i := 0 to hdrMedsIn.Sections.Count - 1 do
      originalwidth := originalwidth + OrigInPtSecWidths[i];
    if originalwidth < totalSectionsWidth then
    begin
      for i := 0 to hdrMedsIn.Sections.Count - 1 do
        hdrMedsIn.Sections[i].Width := OrigInPtSecWidths[i];
      lstMedsIn.Invalidate;
    end;
  end;
  // CQ9622
  if hdrMedsIn.Sections[1].Width < 100 then
  begin
    hdrMedsIn.Sections[1].Width := 100;
    lstMedsIn.Refresh;
  end;
  // end CQ9622
  gdpIn.Height := gdpIn.Height - 1; // forces autopanel resize
  gdpIn.Height := gdpIn.Height + 1; // forces autopanel resize
end;

procedure TfrmMeds.ClearChildODList;
var
  i: Integer;
begin
  for i := 0 to ChildODList.Count - 1 do
    if (Assigned(ChildODList.Objects[i])) then
      ChildODList.Objects[i].Free;
  ChildODList.Clear;
end;

function TfrmMeds.CheckMedStatus(ActiveList: TListBox): Boolean;
var
  i: Integer;
  tmpList: TStringList;
  Str: string;
  AMed: TMedListRec;
  AMedList: TList;
begin
  Result := False;
  tmpList := TStringList.Create;
  AMedList := GetMedList(ActiveList);
  if AMedList = nil then
    Exit;
  for i := 0 to ActiveList.Count - 1 do
    if ActiveList.Selected[i] then
    begin
      AMed := TMedListRec(AMedList[i]);
      Str := AMed.PharmID + U + AMed.Status;
      tmpList.Add(Str);
    end;
  if tmpList <> nil then
  begin
    Result := GetMedStatus(tmpList);
    tmpList.Free;
  end;
  if Result = True then
  begin
    MessageDlg('The Medication status has changed.' + #13#10#13 +
      'CPRS needs to refresh patient information to display the correct medication status',
      mtWarning, [mbOK], 0);
    frmFrame.mnuFileRefreshClick(Application);
  end;
end;

procedure TfrmMeds.ActivateDeactiveRenew(AListBox: TListBox);
var
  i: Integer;
  CurID: string;
  SomePharmacyOrders: TStringList;
  tmpArr: TStringList;
begin
  tmpArr := TStringList.Create;
  SomePharmacyOrders := GetPharmacyOrders(AListBox);
  with AListBox do
    for i := 0 to Items.Count - 1 do
      if Selected[i] then
      begin
        CurID := uPendingChanges.Values
          [Piece(Piece(SomePharmacyOrders[i], U, 2), ';', 1)];
        if Length(CurID) > 0 then
          CurID := Piece(CurID, U, 2)
        else
          CurID := Piece(SomePharmacyOrders[i], U, 2);
        tmpArr.Add(CurID);
      end;
  if tmpArr <> nil then
    frmActivateDeactive.fActivateDeactive(tmpArr, AListBox);
end;

procedure TfrmMeds.ViewInfo(Sender: TObject);
begin
  inherited;
  frmFrame.ViewInfo(Sender);
end;

procedure TfrmMeds.mnuViewInformationClick(Sender: TObject);
begin
  inherited;
  mnuViewDemo.Enabled := frmFrame.pnlPatient.Enabled;
  mnuViewVisits.Enabled := frmFrame.pnlVisit.Enabled;
  mnuViewPrimaryCare.Enabled := frmFrame.pnlPrimaryCare.Enabled;
  mnuViewMyHealtheVet.Enabled := not(Copy(frmFrame.laMHV.Hint, 1, 2) = 'No');
  mnuInsurance.Enabled := not(Copy(frmFrame.laVAA2.Hint, 1, 2) = 'No');
  mnuViewFlags.Enabled := frmFrame.lblFlag.Enabled;
  mnuViewRemoteData.Enabled := frmFrame.lblCirn.Enabled;
  mnuViewReminders.Enabled := frmFrame.pnlReminders.Enabled;
  mnuViewPostings.Enabled := frmFrame.pnlPostings.Enabled;
end;

procedure TfrmMeds.mnuOptimizeFieldsClick(Sender: TObject);
var
  totalSectionsWidth, unit1, unit2, unit8: Integer;
begin
  totalSectionsWidth := gdpOut.Width - 5;
  if totalSectionsWidth < 16 then
    Exit;
  unit1 := (totalSectionsWidth div 16) - 1;
  unit2 := unit1 * 2;
  unit8 := unit1 * 8;

  with hdrMedsNonVA do
  begin
    Sections[0].Width := unit1;
    Sections[1].Width := unit8;
    Sections[2].Width := unit2;
    Sections[3].Width := unit2;
  end;
  hdrMedsNonVASectionResize(hdrMedsNonVA, hdrMedsNonVA.Sections[0]);
  hdrMedsNonVA.Repaint;

  with hdrMedsIn do
  begin
    Sections[0].Width := unit1;
    Sections[1].Width := unit8;
    Sections[2].Width := unit2;
    Sections[3].Width := unit2;
    Sections[4].Width := unit2;
  end;
  hdrMedsInSectionResize(hdrMedsIn, hdrMedsIn.Sections[0]);
  hdrMedsIn.Repaint;

  with hdrMedsOut do
  begin
    Sections[0].Width := unit1;
    Sections[1].Width := unit8;
    Sections[2].Width := unit2;
    Sections[3].Width := unit2;
    Sections[4].Width := unit2;
    Sections[5].Width := unit1;
  end;
  hdrMedsOutSectionResize(hdrMedsOut, hdrMedsOut.Sections[0]);
  hdrMedsOut.Repaint;

  if txtDateRangeOp.Font.Size > 12 then
  begin
    gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 3);
    gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 3);
    gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 3);
    gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 3);
    gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 3);
    gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 3);
  end
  else
  begin
    gdpOut.RowCollection[0].Value := (txtDateRangeOp.Height + 1);
    gdpOut.RowCollection[1].Value := (hdrMedsOut.Height + 1);
    gdpIn.RowCollection[0].Value := (txtDateRangeIp.Height + 1);
    gdpIn.RowCollection[1].Value := (hdrMedsIn.Height + 1);
    gdpNon.RowCollection[0].Value := (txtDateRangeNon.Height + 1);
    gdpNon.RowCollection[1].Value := (hdrMedsNonVA.Height + 1);
  end;
  gdpOut.Repaint;
  gdpIn.Repaint;
  gdpNon.Repaint;
end;

procedure TfrmMeds.hdrMedsOutSectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  // if Section = hdrMedsOut.Sections[1] then
  mnuOptimizeFieldsClick(self);
end;

procedure TfrmMeds.hdrMedsNonVASectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  // if Section = hdrMedsNonVA.Sections[1] then
  mnuOptimizeFieldsClick(self);
end;

procedure TfrmMeds.hdrMedsInSectionClick(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  inherited;
  // if Section = hdrMedsIn.Sections[1] then
  mnuOptimizeFieldsClick(self);
end;

procedure TfrmMeds.SortbyStatusthenLocation1Click(Sender: TObject);
begin
  inherited;
  self.FSortView := 1;
  self.RefreshMedLists;
end;

procedure TfrmMeds.SortbyClinicOrderthenStatusthenStopDate1Click
  (Sender: TObject);
begin
  inherited;
  self.FSortView := 2;
  self.RefreshMedLists;
end;

procedure TfrmMeds.SortbyDrugalphabeticallystatusactivestatusrecentexpired1Click
  (Sender: TObject);
begin
  inherited;
  self.FSortView := 3;
  self.RefreshMedLists;
end;

// PaPI ////////////////////////////////////////////////////////////////////////
procedure TfrmMeds.PaPI_GUIsetup;

  procedure EnablePark(const ABox: TCaptionListBox);
  // This enables and disables Park and Unpark

    function IsParked(const AMedListRec: TObject): Boolean;
    begin
      Result := Assigned(AMedListRec) and (AMedListRec is TMedListRec) and
        (TMedListRec(AMedListRec).Status = 'Active/Parked');
    end;

    function CanBeParked(const AMedListRec: TObject): Boolean;
    begin
      Result := Assigned(AMedListRec) and (AMedListRec is TMedListRec) and
       ((Pos('Active/Susp',TMedListRec(AMedListRec).Status) > 0) or (TMedListRec(AMedListRec).Status = 'Active'));
    end;

  var
    I: Integer;
    HaveOnlyParked, HaveOnlyCanBeParked: Boolean;
  begin
    if Assigned(ABox) then
    begin
      if (ABox = lstMedsIn) or (ABox = lstMedsNonVA) or (ABox.SelCount <= 0) then
      begin
        ActPark.Enabled := False;
        ActUnpark.Enabled := False;
      end
      else
      begin
        // Determine if all can be parked, or all can be unparked
        HaveOnlyParked := True;
        HaveOnlyCanBeParked := True;
        for I := 0 to ABox.Count - 1 do
        begin
          if ABox.Selected[I] then
          begin
            HaveOnlyParked := HaveOnlyParked and
              IsParked(ABox.Items.Objects[I]);
            HaveOnlyCanBeParked := HaveOnlyCanBeParked and
              CanBeParked(ABox.Items.Objects[I]);
            if (not HaveOnlyParked) and (not HaveOnlyCanBeParked) then
              Break;
            // As soon as we know we have a mismatch we can stop this
          end;
        end;

        // Set the actions enabled or disabled, and couple the correct action to
        // the menu items.
        ActPark.Enabled := PapiParkingAvailable and HaveOnlyCanBeParked;
        ActUnpark.Enabled := PapiParkingAvailable and HaveOnlyParked;
      end;
    end;
  end;

begin
  if not PapiParkingAvailable then
  begin
    // If Parking is hidden, hide everything, UNLESS the screenreader is active
    ActPark.Visible := ScreenReaderActive;
    ActPark.Enabled := False;
    ActUnpark.Visible := ScreenReaderActive;
    ActUnpark.Enabled := False;
  end
  else
  begin
    ActPark.Visible := True;
    ActUnpark.Visible := True;

    // for each of the boxes, determine if there are selected items. If there
    // are, enable parking or unparking. A user cannot select items in two boxes
    // simultaneously.
    if LstMedsOut.SelCount > 0 then EnablePark(LstMedsOut)
    else if LstMedsNonVA.SelCount > 0 then EnablePark(LstMedsNonVA)
    else if LstMedsIn.SelCount > 0 then EnablePark(LstMedsIn)
    else
    begin
      // if non of the boxes have selected items, turn it all off
      ActPark.Enabled := False;
      ActUnpark.Enabled := False;
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////PaPI

initialization

SpecifyFormIsNotADialog(TfrmMeds);

end.

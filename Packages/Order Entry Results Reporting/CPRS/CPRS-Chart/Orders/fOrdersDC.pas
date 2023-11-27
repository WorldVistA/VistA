unit fOrdersDC;

{ ------------------------------------------------------------------------------
  Update History

  2016-??-??: NSR#20080226
  ------------------------------------------------------------------------------- }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fBase508Form,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, ORNet, VA508AccessibilityManager,
  rMisc,
  System.UITypes;

type
  TfrmDCOrders = class(TfrmBase508Form)
    DetailsPanel: TPanel;
    CancelPanel: TPanel;
    cnlOrders: TCaptionListBox;
    pnlMain: TPanel;
    LblDiscontinue: TLabel;
    lstOrders: TCaptionListBox;
    MemDetail: TMemo;
    pnlReason: TORListBox;
    lblReason: TLabel;
    LblCancel: TLabel;
    RootPanel: TPanel;
    SplVert: TSplitter;
    BtnPanel: TPanel;
    cmdCancel: TButton;
    cmdOK: TButton;
    SplHoriz: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pnlMainResize(Sender: TObject);
    procedure cnlOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cnlOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure cnlOrdersChange(Sender: TObject);
    procedure lstOrdersChange(Sender: TObject);
  private
    DCReason: Integer;
    DCReasonTxt: string; // NSR20080226 Ty
    function MeasureColumnHeight(TheOrderText: string; Index: Integer;
      Control: TCaptionListBox): Integer;
  public
    OrderIDArr: TStringList;
    procedure unMarkedOrignalOrderDC(OrderArr: TStringList);
  end;

function ExecuteDCOrders(SelectedList: TList; var DelEvt: Boolean; aCustomCaption:string = ''): Boolean;
function ShouldcancelDCorder: Boolean; // rtw

implementation

{$R *.DFM}

/// /NSR20080226 Ty - added fArtAllgy to uses.
uses rOrders, uCore, uConst, fOrders, fAllgyAR, frmDCOrdersAllrgsCrrnt, fFrame,
  uWriteAccess;

var // rtw
  dcordercancel: Boolean; // rtw
  CancellingDiscontinue: Boolean = false;

const
  DCT_NEWORDER = 1;
  DCT_DELETION = 2;
  DCT_NEWSTATUS = 3;
  DCT_CHKVALUE = 'Allergy/Adverse Drug Reaction';

  TX_REASON_REQ = 'A reason for discontinue must be selected.';
  TC_REASON_REQ = 'Missing Discontinue Reason';

  TX_Warning =
    'You are cancelling an unsigned �Discontinued� Order (s) as indicated by *** in the Selected Orders list. The Original Order (s) will remain in their current status.';

function ShouldcancelDCorder: Boolean; // rtw
begin
  result := dcordercancel;
end; // rtw

// NSR20080226 mnj
procedure unLockDC(aList: TList);
var
  i: Integer;
begin
  with aList do
    for i := 0 to Count - 1 do
      UnlockOrder(TOrder(Items[i]).ID);
end;

procedure TfrmDCOrders.lstOrdersChange(Sender: TObject);
var
  tmp: TOrder;
begin
  inherited;
  if lstOrders.itemIndex = -1 then
    Exit;
  tmp := TOrder(lstOrders.Items.Objects[lstOrders.ItemIndex]);
  MemDetail.Lines.Clear;
  MemDetail.Font.Style := [];
  getDetailOrder(tmp.ID, MemDetail.Lines);
  MemDetail.WordWrap := false;
  MemDetail.Scrollbars := ssBoth;
  cnlOrders.ClearSelection;
end;

procedure TfrmDCOrders.cnlOrdersChange(Sender: TObject);
var
  tmp: TOrder;
begin
  inherited;
  if cnlOrders.itemIndex = -1 then
    Exit;
  tmp := TOrder(cnlOrders.Items.Objects[cnlOrders.ItemIndex]);
  MemDetail.Lines.Clear;
  MemDetail.Font.Style := [];
  getDetailOrder(tmp.ID, MemDetail.Lines);
  lstOrders.ClearSelection;
  MemDetail.WordWrap := false;
  MemDetail.Scrollbars := ssBoth;
end;

function DescendSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  First: string;
  Second: string;
begin
  First := List[Index1];
  Second := List[Index2];
  result := CompareText(Second, First);
end;

function ExecuteDCOrders(SelectedList: TList; var DelEvt: Boolean; aCustomCaption:string = ''): Boolean;
var
  frmDCOrders: TfrmDCOrders;
  AnOrder: TOrder;
  i, j, CanSign, DCType: Integer;
  NeedReason, NeedRefresh, OnCurrent, DCNewOrder, Ask2AddAllergy: Boolean;
  OriginalID, APtEvtID, APtEvtName, AnEvtInfo, tmpPtEvt: string;
  PtEvtList, Descend, ListOfChecks: TStringList;
  DCChangeItem: TChangeItem;
begin
  result := false;
  DelEvt := false;
  OnCurrent := false;
  NeedRefresh := false;
  DCNewOrder := false;
  PtEvtList := TStringList.Create;
  if SelectedList.Count = 0 then
    Exit;
  frmDCOrders := TfrmDCOrders.Create(Application);
  try
    if aCustomCaption <> '' then
      frmDCOrders.Caption := aCustomCaption;
    ResizeFormToFont(TForm(frmDCOrders));
    SetFormPosition(frmDCOrders);
    NeedReason := false;
    Descend := TStringList.Create;
    try
      with SelectedList do
        for i := 0 to Count - 1 do
        begin
          AnOrder := TOrder(Items[i]);
          if AnOrder.Signature = 2 then
          begin
            if Pos('Discontinue', AnOrder.Text) > 0 then
            begin
              CancellingDiscontinue := true;
              Descend.AddObject('***' + AnOrder.Text, AnOrder);
            end
            else
              Descend.AddObject(AnOrder.Text, AnOrder);
          end
          else
            frmDCOrders.lstOrders.Items.AddObject(AnOrder.Text, AnOrder);
          frmDCOrders.OrderIDArr.Add(AnOrder.ID);
          if not NeedReason then
          begin
            if not((AnOrder.Status = 11) and (AnOrder.Signature = 2)) then
              NeedReason := true;
            if (NeedReason = true) and (AnOrder.Status = 10) and
              (AnOrder.Signature = 2) then
              NeedReason := false;
          end;
        end;
      Descend.Customsort(DescendSort);
      frmDCOrders.cnlOrders.Items.Assign(Descend);
    finally
      Descend.Free;
    end;
    frmDCOrders.pnlMain.Visible := false;
    frmDCOrders.CancelPanel.Visible := false;
    if frmDCOrders.cnlOrders.Count > 0 then
    begin
      frmDCOrders.CancelPanel.Visible := true;
      if CancellingDiscontinue then
        frmDCOrders.MemDetail.Text := TX_Warning;
      frmDCOrders.MemDetail.Font.Style := [fsBold];
      frmDCOrders.CancelPanel.Visible := true;
    end;
    if frmDCOrders.lstOrders.Count > 0 then
    begin
      frmDCOrders.pnlMain.Visible := true;
      frmDCOrders.pnlReason.Visible := NeedReason;
    end
    else if (frmDCOrders.cnlOrders.Count = 0) then
    begin
      frmDCOrders.pnlMain.Align := alClient;
      frmDCOrders.lstOrders.Align := alClient;
    end
    else
      frmDCOrders.CancelPanel.Align := alClient;
    if frmDCOrders.pnlMain.Visible and frmDCOrders.CancelPanel.Visible then else
      frmDCOrders.SplHoriz.Visible := false;

    if frmDCOrders.ShowModal = mrOK then
    begin
      if (frmDCOrders.DCReasonTxt = DCT_CHKVALUE) then
      begin
        Ask2AddAllergy := false;
        ListOfChecks := TStringList.Create;
        try
          for i := 0 to SelectedList.Count - 1 do
          begin
            AnOrder := TOrder(SelectedList.Items[i]);
            if Assigned(AnOrder) then
            begin
              OrderChecksOnMedicationSelect(ListOfChecks, AnOrder.GetPackage, 0, AnOrder.ID);
              if ListOfChecks.Count = 0 then
              begin
                Ask2AddAllergy := True;
                break;
              end;
            end;
          end;
        finally
          ListOfChecks.Free;
          ClearAllergyOrderCheckCache;
        end;
        if Ask2AddAllergy and IsAllergyARRegistrationNeeded then
        begin
          if assigned(uAllergyOrdersCurrentlyBeingDiscontinued) then
            uAllergyOrdersCurrentlyBeingDiscontinued.Clear
          else
            uAllergyOrdersCurrentlyBeingDiscontinued := TStringList.Create;
          for i := 0 to SelectedList.Count - 1 do
            uAllergyOrdersCurrentlyBeingDiscontinued.Add(Piece(TOrder(SelectedList.Items[i]).ID, ';', 1));
          EnterEditAllergy(0, true, false);
        end;
      end;

      if (Encounter.Provider = User.DUZ) and User.CanSignOrders then
        CanSign := CH_SIGN_YES
      else
        CanSign := CH_SIGN_NA;

      with SelectedList do
        for i := 0 to Count - 1 do
        begin
          AnOrder := TOrder(Items[i]);
          OriginalID := AnOrder.ID;
          PtEvtList.Add(AnOrder.EventPtr + '^' + AnOrder.EventName);
          if Changes.Orders.Count = 0 then
            DCNewOrder := false
          else
          begin
            for j := 0 to Changes.Orders.Count - 1 do
            begin
              DCChangeItem := TChangeItem(Changes.Orders.Items[j]);
              if DCChangeItem.ID = AnOrder.ID then
              begin
                if (Pos('DC', AnOrder.ActionOn) = 0) then
                  DCNewOrder := true
                else
                  DCNewOrder := false;
              end;
            end;
          end;
          DCOrder(AnOrder, frmDCOrders.DCReason, DCNewOrder, DCType);
          case DCType of
            DCT_NEWORDER:
              begin
                Changes.Add(CH_ORD, AnOrder.ID, AnOrder.Text, '', CanSign, waOrders,
                  AnOrder.ParentID, User.DUZ, AnOrder.DGroup, AnOrder.DGroupName, true);
                AnOrder.ActionOn := OriginalID + '=DC';
              end;
            DCT_DELETION:
              begin
                Changes.Remove(CH_ORD, OriginalID);
                if (AnOrder.ID = '0') or (AnOrder.ID = '') then
                  AnOrder.ActionOn := OriginalID + '=DL' // delete order
                else
                  AnOrder.ActionOn := OriginalID + '=CA'; // cancel action
                // else AnOrder.ActionOn := AnOrder.ID + '=CA'; // - caused cancel from meds to not update orders }
                UnlockOrder(OriginalID); // for deletion of unsigned DC
              end;
            DCT_NEWSTATUS:
              begin
                AnOrder.ActionOn := OriginalID + '=DC';
                UnlockOrder(OriginalID);
              end;
          else
            UnlockOrder(OriginalID);
          end;
          SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT,
            Integer(AnOrder));
        end;
      if frmOrders.lstSheets.ItemIndex > -1 then
        if CharAt(frmOrders.lstSheets.Items[frmOrders.lstSheets.ItemIndex], 1) = 'C'
        then
          OnCurrent := true;
      if not OnCurrent then
      begin
        for i := 0 to PtEvtList.Count - 1 do
        begin
          if Length(PtEvtList[i]) > 1 then
          begin
            APtEvtID := Piece(PtEvtList[i], '^', 1);
            APtEvtName := Piece(PtEvtList[i], '^', 2);
            AnEvtInfo := EventInfo(APtEvtID);
            if isExistedEvent(Patient.DFN, Piece(AnEvtInfo, '^', 2), tmpPtEvt)
              and (DeleteEmptyEvt(APtEvtID, APtEvtName, false)) then
            begin
              NeedRefresh := true;
              frmOrders.ChangesUpdate(APtEvtID);
            end;
          end;
        end;
        if NeedRefresh then
        begin
          frmOrders.InitOrderSheetsForEvtDelay;
          frmOrders.lstSheets.ItemIndex := 0;
          frmOrders.lstSheetsClick(nil);
          DelEvt := true;
        end;
      end;
      result := true;
    end // End of - if frmDCOrders.OKPressed then
    else // with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    begin
      CallVistA('ORWDX1 UNDCORIG', [frmDCOrders.OrderIDArr]);
      unLockDC(SelectedList);
      /// /NSR20080226 mnj
    end;

    SaveUserBounds(frmDCOrders);
  finally
    frmDCOrders.Free;
  end;
end;

procedure TfrmDCOrders.cnlOrdersDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with cnlOrders do
  begin
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(0, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := Items[Index];
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect,
        DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmDCOrders.cnlOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x: string;
begin
  inherited;
  with cnlOrders do
    if Index < Items.Count then
    begin
      x := Items[index];
      AHeight := MeasureColumnHeight(x, Index, cnlOrders);
    end;
end;

procedure TfrmDCOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x: string;
begin
  inherited;
  with lstOrders do
    if Index < Items.Count then
    begin
      x := Items[index];
      AHeight := MeasureColumnHeight(x, Index, lstOrders);
    end;
end;

function TfrmDCOrders.MeasureColumnHeight(TheOrderText: string; Index: Integer;
  Control: TCaptionListBox): Integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := Control.Width - 6;
  result := WrappedTextHeightByFont(Control.Canvas, Control.Font, TheOrderText,
    ARect) + 6;
end;

procedure TfrmDCOrders.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  dcordercancel := false; // rtw
  inherited;
  if ModalResult = mrCancel then
  begin
    dcordercancel := true; // rtw
    Exit;
  end;
  if (pnlMain.Visible) then
    if (pnlReason.ItemIEN < 1) then
    begin
      CanClose := false;
      InfoBox(TX_REASON_REQ, TC_REASON_REQ, MB_OK);
    end
    else
    begin
      DCReason := pnlReason.ItemIEN;
      DCReasonTxt := Piece(pnlReason.MItems[pnlReason.ItemIndex], '^', 2);
      // NSR20080226 Ty
    end;
end;

procedure TfrmDCOrders.FormCreate(Sender: TObject);
var
  DefaultIEN: Integer;
begin
  inherited;
  OrderIDArr := TStringList.Create;
  ListDCReasons(pnlReason.Items, DefaultIEN);
  pnlReason.SelectByIEN(DefaultIEN);
end;

procedure TfrmDCOrders.lstOrdersDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with lstOrders do
  begin
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(0, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := Items[Index];
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect,
        DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmDCOrders.pnlMainResize(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  // the following code forces measureitem calls in list box
  for i := 0 to lstOrders.Count - 1 do
    lstOrders.Items[i] := lstOrders.Items[i];
end;

procedure TfrmDCOrders.FormDestroy(Sender: TObject);
begin
  OrderIDArr.Free;
  inherited;
end;

procedure TfrmDCOrders.unMarkedOrignalOrderDC(OrderArr: TStringList);
begin
  CallVistA('ORWDX1 UNDCORIG', [OrderArr]);
end;

end.

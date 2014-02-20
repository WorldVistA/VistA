unit fOrdersDC;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, fBase508Form,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, ORNet, VA508AccessibilityManager, rMisc;

type
  TfrmDCOrders = class(TfrmBase508Form)
    Label1: TLabel;
    Panel1: TPanel;
    lstOrders: TCaptionListBox;
    Panel2: TPanel;
    lblReason: TLabel;
    lstReason: TORListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure unMarkedOrignalOrderDC(OrderArr: TStringList);
  private
    OKPressed: Boolean;
    DCReason: Integer;
    function MeasureColumnHeight(TheOrderText: string; Index: Integer):integer;
  public
    OrderIDArr: TStringList;
  end;

function ExecuteDCOrders(SelectedList: TList; var DelEvt: boolean): Boolean;

implementation

{$R *.DFM}

uses rOrders, uCore, uConst, fOrders;

function ExecuteDCOrders(SelectedList: TList; var DelEvt: boolean): Boolean;
const
  DCT_NEWORDER  = 1;
  DCT_DELETION  = 2;
  DCT_NEWSTATUS = 3;
var
  frmDCOrders: TfrmDCOrders;
  AnOrder: TOrder;
  i, j, CanSign, DCType: Integer;
  NeedReason,NeedRefresh,OnCurrent, DCNewOrder: Boolean;
  OriginalID,APtEvtID,APtEvtName,AnEvtInfo,tmpPtEvt:  string;
  PtEvtList: TStringList;
  DCChangeItem: TChangeItem;
begin
  Result := False;
  DelEvt := False;
  OnCurrent := False;
  NeedRefresh := False;
  DCNewOrder := false;
  PtEvtList := TStringList.Create;
  if SelectedList.Count = 0 then Exit;
  frmDCOrders := TfrmDCOrders.Create(Application);
  try
    SetFormPosition(frmDCOrders);
    ResizeFormToFont(TForm(frmDCOrders));
    NeedReason := False;
    with SelectedList do for i := 0 to Count - 1 do
    begin
      AnOrder    := TOrder(Items[i]);
      frmDCOrders.lstOrders.Items.Add(AnOrder.Text);
      frmDCOrders.OrderIDArr.Add(AnOrder.ID);
      if not ((AnOrder.Status = 11) and (AnOrder.Signature = 2)) then NeedReason := True;
      if (NeedReason = True) and (AnOrder.Status = 10) and (AnOrder.Signature = 2) then  NeedReason := False;
      
    end;
    if NeedReason then
    begin
      frmDCOrders.lblReason.Visible := True;
      frmDCOrders.lstReason.Visible := True;
      frmDCOrders.lstReason.ScrollWidth := 10;
    end else
    begin
      frmDCOrders.lblReason.Visible := False;
      frmDCOrders.lstReason.Visible := False;
    end;
    frmDCOrders.ShowModal;
    if frmDCOrders.OKPressed then
    begin
      if (Encounter.Provider = User.DUZ) and User.CanSignOrders
        then CanSign := CH_SIGN_YES
        else CanSign := CH_SIGN_NA;
      with SelectedList do for i := 0 to Count - 1 do
      begin
        AnOrder := TOrder(Items[i]);
        OriginalID := AnOrder.ID;
        PtEvtList.Add(AnOrder.EventPtr + '^' + AnOrder.EventName);
        if Changes.Orders.Count = 0 then DCNewOrder := false
        else
          begin
            for j := 0 to Changes.Orders.Count - 1 do
              begin
                DCChangeItem := TChangeItem(Changes.Orders.Items[j]);
                if DCChangeItem.ID = AnOrder.ID then
                  begin
                    if (Pos('DC', AnOrder.ActionOn) = 0) then
                       DCNewOrder := True
                    else DCNewOrder := False;
                  end;
              end;
          end;
        DCOrder(AnOrder, frmDCOrders.DCReason, DCNewOrder, DCType);
        case DCType of
        DCT_NEWORDER:  begin
                         Changes.Add(CH_ORD, AnOrder.ID, AnOrder.Text, '', CanSign, AnOrder.ParentID, user.DUZ, AnOrder.DGroupName, True);
                         AnOrder.ActionOn := OriginalID + '=DC';
                       end;
        DCT_DELETION:  begin
                         Changes.Remove(CH_ORD, OriginalID);
                         if (AnOrder.ID = '0') or (AnOrder.ID = '')
                           then AnOrder.ActionOn := OriginalID + '=DL'    // delete order
                           else AnOrder.ActionOn := OriginalID + '=CA';   // cancel action
                          {else AnOrder.ActionOn := AnOrder.ID + '=CA';  - caused cancel from meds to not update orders}
                         UnlockOrder(OriginalID);  // for deletion of unsigned DC
                       end;
        DCT_NEWSTATUS: begin
                         AnOrder.ActionOn := OriginalID + '=DC';
                         UnlockOrder(OriginalID);
                       end;
        else UnlockOrder(OriginalID);
        end;
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(AnOrder));
      end;
      if frmOrders.lstSheets.ItemIndex > -1 then
        if CharAt(frmOrders.lstSheets.Items[frmOrders.lstSheets.ItemIndex],1)='C' then
          OnCurrent := True;
      if not OnCurrent then
      begin
        for i := 0 to PtEvtList.Count - 1 do
        begin
          if Length(PtEvtList[i])>1  then
          begin
            APtEvtID   := Piece(PtEvtList[i],'^',1);
            APtEvtName := Piece(PtEvtList[i],'^',2);
            AnEvtInfo := EventInfo(APtEvtID);
            if isExistedEvent(Patient.DFN,Piece(AnEvtInfo,'^',2),tmpPtEvt) and (DeleteEmptyEvt(APtEvtID,APtEvtName,False)) then
            begin
              NeedRefresh := True;
              frmOrders.ChangesUpdate(APtEvtID);
            end;
          end;
        end;
        if NeedRefresh then
        begin
          frmOrders.InitOrderSheetsForEvtDelay;
          frmOrders.lstSheets.ItemIndex := 0;
          frmOrders.lstSheetsClick(nil);
          DelEvt := True;
        end;
      end;
      Result := True;
    end
    else with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    SaveUserBounds(frmDCOrders);
  finally
    frmDCOrders.Release;
  end;
end;

procedure TfrmDCOrders.FormCreate(Sender: TObject);
var
  DefaultIEN: Integer;
begin
  inherited;
  OKPressed := False;
  OrderIDArr := TStringList.Create;
  ListDCReasons(lstReason.Items, DefaultIEN);
  lstReason.SelectByIEN(DefaultIEN);
  { the following commented out so that providers can enter DC reasons }
//  if Encounter.Provider = User.DUZ then
//  begin
//    lblReason.Visible := False;
//    lstReason.Visible := False;
//  end;
end;

procedure TfrmDCOrders.cmdOKClick(Sender: TObject);
const
  TX_REASON_REQ = 'A reason for discontinue must be selected.';
  TC_REASON_REQ = 'Missing Discontinue Reason';
begin
  inherited;
  if (lstReason.Visible) and (not (lstReason.ItemIEN > 0)) then
  begin
    InfoBox(TX_REASON_REQ, TC_REASON_REQ, MB_OK);
    Exit;
  end;
  OKPressed := True;
  DCReason := lstReason.ItemIEN;
  Close;
end;

procedure TfrmDCOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  unMarkedOrignalOrderDC(Self.OrderIDArr);
  Close;
end;

procedure TfrmDCOrders.lstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
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
      DrawText(Canvas.handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmDCOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
begin
  inherited;
  with lstOrders do if Index < Items.Count then
  begin
    x := Items[index];
    AHeight := MeasureColumnHeight(x, Index);
  end;
end;

function TfrmDCOrders.MeasureColumnHeight(TheOrderText: string;
  Index: Integer): integer;
var
  ARect: TRect;
begin
  ARect.Left := 0;
  ARect.Top := 0;
  ARect.Bottom := 0;
  ARect.Right := lstOrders.Width - 6;
  Result := WrappedTextHeightByFont(lstOrders.Canvas,lstOrders.Font,TheOrderText,ARect);
end;

procedure TfrmDCOrders.FormDestroy(Sender: TObject);
begin
  inherited;
  if self.OrderIDArr <> nil then self.OrderIDArr.Free;
end;

procedure TfrmDCOrders.unMarkedOrignalOrderDC(OrderArr: TStringList);
begin
 CallV('ORWDX1 UNDCORIG', [OrderArr]);
end;

end.

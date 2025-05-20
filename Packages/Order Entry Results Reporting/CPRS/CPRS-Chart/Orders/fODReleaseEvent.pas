unit fODReleaseEvent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORFn, CheckLst, ORCtrls, fAutoSz, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmOrdersReleaseEvent = class(TfrmBase508Form)
    pnlMiddle: TPanel;
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    cklstOrders: TCaptionCheckListBox;
    lblRelease: TLabel;
    pnlButtons: TPanel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cklstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure cklstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cklstOrdersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    OKPressed: boolean;
    FLastHintItem: integer;
    FOldHintPause: integer;
    FOldHintHidePause: integer;
    FComplete: boolean;
    FCurrTS: string;
  public
    { Public declarations }
    property CurrTS: string       read FCurrTS    write FCurrTS;
  end;

//procedure ExecuteReleaseEventOrders(AnOrderList: TList);
function ExecuteReleaseEventOrders(AnOrderList: TList): boolean;

implementation
{$R *.DFM}

uses rCore, rOrders, uConst, fOrdersPrint, uCore, uOrders, fOrders, rODLab, fRptBox,
  VAUtils, System.Types;

const
  TX_SAVERR1 = 'The error, ';
  TX_SAVERR2 = ', occurred while trying to release:' + CRLF + CRLF;
  TC_SAVERR  = 'Error Saving Order';

//procedure ExecuteReleaseEventOrders(AnOrderList: TList);
function ExecuteReleaseEventOrders(AnOrderList: TList): boolean;
const
  TXT_RELEASE = #13 + #13 + '  The following orders will be released to service:';
var
  i,j,idx: integer;
  AOrder: TOrder;
  OrdersLst: TStringlist;
  OrderText, LastCheckedPtEvt, SpeCap: string;
  frmOrdersReleaseEvent: TfrmOrdersReleaseEvent;
  AList: TStringList;

  function FindOrderText(const AnID: string): string;
  var
    i: Integer;
  begin
    Result := '';
    with AnOrderList do for i := 0 to Count - 1 do
      with TOrder(Items[i]) do if ID = AnID then
      begin
        Result := Text;
        Break;
      end;
  end;

begin
  frmOrdersReleaseEvent := TfrmOrdersReleaseEvent.Create(Application);
  try
    frmOrdersReleaseEvent.CurrTS := Piece(GetCurrentSpec(Patient.DFN),'^',1);
    if Length(frmOrdersReleaseEvent.CurrTS)>0 then
      SpeCap := #13 + '  The current treating specialty is ' + frmOrdersReleaseEvent.CurrTS
    else
      SpeCap := #13 + '  No treating specialty is available.';
    ResizeFormToFont(TForm(frmOrdersReleaseEvent));
    if Patient.Inpatient then
      frmOrdersReleaseEvent.lblRelease.Caption := '  ' + Patient.Name + ' is currently admitted to '
         + Encounter.LocationName + SpeCap + TXT_RELEASE
    else
    begin
      if Encounter.Location > 0 then
        frmOrdersReleaseEvent.lblRelease.Caption := '  ' + Patient.Name + ' is currently at '
          + Encounter.LocationName + SpeCap + TXT_RELEASE
      else
        frmOrdersReleaseEvent.lblRelease.Caption := '  ' + Patient.Name + ' is currently an outpatient.' + SpeCap + TXT_RELEASE;
    end;
    with frmOrdersReleaseEvent do
      cklstOrders.Caption := lblRelease.Caption;
    with  AnOrderList do for i := 0 to Count - 1 do
    begin
      AOrder := TOrder(Items[i]);
      idx := frmOrdersReleaseEvent.cklstOrders.Items.AddObject(AOrder.Text,AOrder);
      frmOrdersReleaseEvent.cklstOrders.Checked[idx] := True;
    end;
    frmOrdersReleaseEvent.ShowModal;
    if frmOrdersReleaseEvent.OKPressed then
    begin
      OrdersLst := TStringList.Create;
      for j := 0 to frmOrdersReleaseEvent.cklstOrders.Items.Count - 1 do
      begin
        if frmOrdersReleaseEvent.cklstOrders.Checked[j] then
          OrdersLst.Add(TOrder(frmOrdersReleaseEvent.cklstOrders.Items.Objects[j]).ID);
      end;
      StatusText('Releasing Orders to Service...');
      SendReleaseOrders(OrdersLst);
      LastCheckedPtEvt := '';

      //CQ #15813 Modired code to look for error string mentioned in CQ and change strings to conts - JCS
      with OrdersLst do if Count > 0 then for i := 0 to Count - 1 do
      begin
        if Pos('E', Piece(OrdersLst[i], U, 2)) > 0 then
        begin
          OrderText := FindOrderText(Piece(OrdersLst[i], U, 1));
          if Piece(OrdersLst[i],U,4) = TX_SAVERR_PHARM_ORD_NUM_SEARCH_STRING then
          InfoBox(TX_SAVERR1 + Piece(OrdersLst[i], U, 4) + TX_SAVERR2 + OrderText + CRLF + CRLF +
                  TX_SAVERR_PHARM_ORD_NUM, TC_SAVERR, MB_OK)
          else if Piece(OrdersLst[i],U,4) = TX_SAVERR_IMAGING_PROC_SEARCH_STRING then
          InfoBox(TX_SAVERR1 + Piece(OrdersLst[i], U, 4) + TX_SAVERR2 + OrderText + CRLF + CRLF +
                  TX_SAVERR_IMAGING_PROC, TC_SAVERR, MB_OK)
          else
          InfoBox(TX_SAVERR1 + Piece(OrdersLst[i], U, 4) + TX_SAVERR2 + OrderText,
                  TC_SAVERR, MB_OK);
        end;
      end;
      //  CQ 10226, PSI-05-048 - advise of auto-change from LC to WC on lab orders
      AList := TStringList.Create;
      try
        CheckForChangeFromLCtoWCOnRelease(AList, Encounter.Location, OrdersLst);
        if AList.Text <> '' then
          ReportBox(AList, 'Changed Orders', TRUE);
      finally
        AList.Free;
      end;
      PrintOrdersOnSignRelease(OrdersLst, NO_PROVIDER);

      with AnOrderList do for i := 0 to Count - 1 do with TOrder(Items[i]) do
      begin
        if EventPtr <> LastCheckedPtEvt then
        begin
          LastCheckedPtEvt := EventPtr;
          if CompleteEvt(EventPtr,EventName,False) then
            frmOrdersReleaseEvent.FComplete := True;
        end;
      end;
      StatusText('');
      ordersLst.Free;
      with AnOrderList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
      if frmOrdersReleaseEvent.FComplete then
      begin
        frmOrders.InitOrderSheetsForEvtDelay;
        frmOrders.ClickLstSheet;
      end;
      frmOrdersReleaseEvent.FComplete := False;
      Result := True;
    end else
      Result := False;
  Except
    on E: exception do
      Result := false;
  end;
  {finally
    with AnOrderList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    if frmOrdersReleaseEvent.FComplete then
    begin
      frmOrders.InitOrderSheetsForEvtDelay;
      frmOrders.ClickLstSheet;
    end;
    frmOrdersReleaseEvent.FComplete := False;
  end;}
end;

procedure TfrmOrdersReleaseEvent.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrdersReleaseEvent.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  FLastHintItem := -1;
  FComplete  := False;
  FOldHintPause := Application.HintPause;
  FCurrTS := '';
  Application.HintPause := 250;
  FOldHintHidePause := Application.HintHidePause;
  Application.HintHidePause := 30000;
end;

procedure TfrmOrdersReleaseEvent.btnOKClick(Sender: TObject);
var
  i: integer;
  beSelected: boolean;
begin
  beSelected := False;
  for i := 0 to cklstOrders.Items.Count - 1 do
  begin
    if cklstOrders.Checked[i] then
    begin
      beSelected := True;
      Break;
    end;
  end;
  if not beSelected then
  begin
    ShowMsg('You have to select at least one order!');
    Exit;
  end;
  OKPressed := True;
  Close;
end;

procedure TfrmOrdersReleaseEvent.FormDestroy(Sender: TObject);
begin
  inherited;
  Application.HintPause := FOldHintPause;
  Application.HintHidePause := FOldHintHidePause;
end;

procedure TfrmOrdersReleaseEvent.cklstOrdersMeasureItem(
  Control: TWinControl; Index: Integer; var AHeight: Integer);
var
  x:string;
  ARect: TRect;
begin
  inherited;
  AHeight := MainFontHeight + 2;
  with cklstOrders do if Index < Items.Count then
  begin
    x := FilteredString(Items[Index]);
    ARect := ItemRect(Index);
    AHeight := WrappedTextHeightByFont( cklstOrders.Canvas, Font, x, ARect);
    if AHeight > 255 then AHeight := 255;
    if AHeight <  13 then AHeight := 13;
  end;
end;

procedure TfrmOrdersReleaseEvent.cklstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with cklstOrders do
  begin
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(0, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      X := FilteredString(Items[Index]);
      DrawText(Canvas.handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmOrdersReleaseEvent.cklstOrdersMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Itm: integer;
begin
  inherited;
  Itm := cklstOrders.ItemAtPos(Point(X, Y), TRUE);
  if (Itm >= 0) then
  begin
    if (Itm <> FLastHintItem) then
    begin
      Application.CancelHint;
      cklstOrders.Hint := TrimRight(cklstOrders.Items[Itm]);
      FLastHintItem := Itm;
      Application.ActivateHint(Point(X, Y));
    end;
  end else
  begin
    cklstOrders.Hint := '';
    FLastHintItem := -1;
    Application.CancelHint;
  end;
end;

end.

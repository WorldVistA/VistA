unit fOrdersRefill;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmRefillOrders = class(TfrmAutoSz)
    pnlBottom: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    grbPickUp: TGroupBox;
    radWindow: TRadioButton;
    radMail: TRadioButton;
    pnlClient: TPanel;
    lstOrders: TCaptionListBox;
    lblOrders: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var aHeight: Integer);
  private
    OKPressed: Boolean;
    PickupAt: string;
    function MeasureColumnHeight(TheOrderText: string;
      Index: Integer): integer;
  end;

function ExecuteRefillOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, rMeds, uCore, uConst, rMisc, uPaPI;

function ExecuteRefillOrders(SelectedList: TList): Boolean;
var
  frmRefillOrders: TfrmRefillOrders;
  AnOrder: TOrder;
  OriginalID: string;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmRefillOrders := TfrmRefillOrders.Create(Application);
  try
    ResizeAnchoredFormToFont(frmRefillOrders);
    frmRefillOrders.Left := (Screen.WorkAreaWidth - frmRefillOrders.Width) div 2;
    frmRefillOrders.Top := (Screen.WorkAreaHeight - frmRefillOrders.Height) div 2;
    with SelectedList do for i := 0 to Count - 1 do
      frmRefillOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmRefillOrders.ShowModal;
    if frmRefillOrders.OKPressed then
    begin
      StatusText('Requesting Refill...');
      with SelectedList do for i := 0 to Count - 1 do
      begin
        AnOrder := TOrder(Items[i]);
        OriginalID := AnOrder.ID;
        Refill(OriginalID, frmRefillOrders.PickupAt);
        AnOrder.ActionOn := OriginalID + '=RF';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(Items[i]));
      end;
      Result := True;
      StatusText('');
    end;
  finally
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    frmRefillOrders.Release;
  end;
end;

procedure TfrmRefillOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  PickupAt := PickUpDefault;
  if PickupAt = 'M' then
    radMail.Checked := true
  else
  begin
    PickupAt := 'W';
    radWindow.Checked := true;
  end;
end;

procedure TfrmRefillOrders.cmdOKClick(Sender: TObject);
const
  TX_LOCATION_REQ = 'A location for the refill must be selected.';
  TC_LOCATION_REQ = 'Missing Refill Location';
begin
  inherited;
  if not (radWindow.Checked or radMail.Checked) then
  begin
    InfoBox(TX_LOCATION_REQ, TC_LOCATION_REQ, MB_OK);
    Exit;
  end;
  OKPressed := True;
  if radWindow.Checked then PickupAt := 'W'
  else if radMail.Checked then PickupAt := 'M'
  //  else if radPark.Checked then PickupAt := 'P' // PaPI
  else PickupAt := 'W';
  Close;
end;

procedure TfrmRefillOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmRefillOrders.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self);
end;

procedure TfrmRefillOrders.FormShow(Sender: TObject);
begin
  SetFormPosition(Self);
end;

procedure TfrmRefillOrders.lstOrdersDrawItem(Control: TWinControl;
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
  end;end;

procedure TfrmRefillOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var aHeight: Integer);
var
  x:string;
begin
  inherited;
  with lstOrders do if Index < Items.Count then
  begin
    x := Items[index];
    aHeight := MeasureColumnHeight(x, Index);
  end;
end;

function TfrmRefillOrders.MeasureColumnHeight(TheOrderText: string;
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

end.

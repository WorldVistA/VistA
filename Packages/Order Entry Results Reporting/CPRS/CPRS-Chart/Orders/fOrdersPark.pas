unit fOrdersPark;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmParkOrders = class(TfrmAutoSz)
    lstOrders: TCaptionListBox;
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var aHeight: Integer);
  private
    OKPressed: Boolean;
    function MeasureColumnHeight(TheOrderText: string;
      Index: Integer): integer;
  end;

function ExecuteParkOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uConst, uCore, uPaPI, rMeds;

// Execute Park Orders - copy of Execute Refill ================================
function ExecuteParkOrders(SelectedList: TList): Boolean;
var
  frmParkOrders: TfrmParkOrders;
  AnOrder: TOrder;
  OriginalID: string;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmParkOrders := TfrmParkOrders.Create(Application);
  try
    ResizeAnchoredFormToFont(frmParkOrders);
    frmParkOrders.Left := (Screen.WorkAreaWidth - frmParkOrders.Width) div 2;
    frmPARKOrders.Top := (Screen.WorkAreaHeight - frmParkOrders.Height) div 2;
    with SelectedList do for i := 0 to Count - 1 do
      frmParkOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmParkOrders.ShowModal;
    if frmParkOrders.OKPressed then
    begin
      StatusText('Requesting Park...');
      with SelectedList do for i := 0 to Count - 1 do
      begin
        AnOrder := TOrder(Items[i]);
        OriginalID := AnOrder.ID;
        ParkOrder(OriginalID);
        AnOrder.ActionOn := OriginalID + '=PK';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(Items[i]));
      end;
      Result := True;
      StatusText('');
    end;
  finally
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    frmParkOrders.Release;
  end;
end;

procedure TfrmParkOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmParkOrders.lstOrdersDrawItem(Control: TWinControl; Index: Integer;
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
      DrawText(Canvas.handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
    end;
  end;
end;

procedure TfrmParkOrders.lstOrdersMeasureItem(Control: TWinControl;
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


function TfrmParkOrders.MeasureColumnHeight(TheOrderText: string;
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

procedure TfrmParkOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmParkOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

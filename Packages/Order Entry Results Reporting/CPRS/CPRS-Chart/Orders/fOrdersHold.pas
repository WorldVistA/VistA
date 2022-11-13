unit fOrdersHold;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmHoldOrders = class(TfrmAutoSz)
    lstOrders: TCaptionListBox;
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer; // PaPI
      var aHeight: Integer);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer; // PaPI
      Rect: TRect; State: TOwnerDrawState);
  private
    OKPressed: Boolean;
  function MeasureColumnHeight(TheOrderText: string;  // PaPI
      Index: Integer): integer;
  end;

function ExecuteHoldOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uConst, uCore;

function ExecuteHoldOrders(SelectedList: TList): Boolean;
var
  frmHoldOrders: TfrmHoldOrders;
  OriginalID: string;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmHoldOrders := TfrmHoldOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmHoldOrders));
    with SelectedList do for i := 0 to Count - 1 do
      frmHoldOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmHoldOrders.ShowModal;
    if frmHoldOrders.OKPressed then
    begin
      with SelectedList do for i := 0 to Count - 1 do
      begin
        OriginalID := TOrder(Items[i]).ID;
        HoldOrder(TOrder(Items[i]));
        TOrder(Items[i]).ActionOn := OriginalID + '=HD';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(Items[i]));
      end;
      Result := True;
    end
    else with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  finally
    frmHoldOrders.Release;
  end;
end;

procedure TfrmHoldOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

// PaPI
procedure TfrmHoldOrders.lstOrdersDrawItem(Control: TWinControl; Index: Integer;
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

procedure TfrmHoldOrders.lstOrdersMeasureItem(Control: TWinControl;
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
// PaPI

procedure TfrmHoldOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmHoldOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

// PaPI
function TfrmHoldOrders.MeasureColumnHeight(TheOrderText: string;
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
// PaPI

end.

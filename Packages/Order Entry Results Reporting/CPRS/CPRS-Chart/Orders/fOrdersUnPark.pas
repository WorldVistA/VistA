unit fOrdersUnPark;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmUnParkOrders = class(TfrmAutoSz)
    lstOrders: TCaptionListBox;
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var aHeight: Integer);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    OKPressed: Boolean;
    function MeasureColumnHeight(TheOrderText: string;
      Index: Integer): integer;
  end;

function ExecuteUnParkOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uConst, uCore, rMeds, fMeds;

function ExecuteUnParkOrders(SelectedList: TList): Boolean;
var
  frmUnParkOrders: TfrmUnParkOrders;
  AnOrder: TOrder;
  sError, OriginalID: string;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmUnParkOrders := TfrmUnParkOrders.Create(Application);
  try //   ResizeFormToFont(TForm(frmUnParkOrders));
    ResizeAnchoredFormToFont(frmUnParkOrders);
    frmUnParkOrders.Left := (Screen.WorkAreaWidth - frmUnParkOrders.Width) div 2;
    frmUnPARKOrders.Top := (Screen.WorkAreaHeight - frmUnParkOrders.Height) div 2;
    with SelectedList do for i := 0 to Count - 1 do
      frmUnParkOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmUnParkOrders.ShowModal;
    if frmUnParkOrders.OKPressed then
    begin
      StatusText('Requesting Un-Park...');
      with SelectedList do for i := 0 to Count - 1 do
      begin
        AnOrder := TOrder(Items[i]);
        OriginalID := AnOrder.ID;
        sError := UnParkOrder(OriginalID,'PickupAt');
        if sError <> '' then
          InfoBox(sError,'Un-Park Warning', MB_OK);
        AnOrder.ActionOn := OriginalID + '=UP';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(Items[i]));
      end;
      Result := True;
      StatusText('');
    end;
  finally
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
    frmUnParkOrders.Release;
  end;
end;

procedure TfrmUnParkOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmUnParkOrders.lstOrdersDrawItem(Control: TWinControl;
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

procedure TfrmUnParkOrders.lstOrdersMeasureItem(Control: TWinControl;
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

procedure TfrmUnParkOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmUnParkOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

function TfrmUnParkOrders.MeasureColumnHeight(TheOrderText: string;
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

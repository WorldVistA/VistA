unit fODChangeEvtDisp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ExtCtrls, ORCtrls, VA508AccessibilityManager;

type
  TfrmChangeEventDisp = class(TfrmAutoSz)
    lblTop: TMemo;
    pnlTop: TPanel;
    lstCVOrders: TCaptionListBox;
    pnlBottom: TPanel;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure lstCVOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstCVOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FOKPressed: boolean;
  public
    { Public declarations }
  end;

function DispOrdersForEventChange(AnOrderList: TList; ACap: string): boolean;

implementation

{$R *.DFM}
uses rOrders;

function DispOrdersForEventChange(AnOrderList: TList; ACap: string): boolean;
var
  frmChangeEventDisp: TfrmChangeEventDisp;
  i: integer;
  AnOrder: TOrder;
begin
  frmChangeEventDisp := TFrmChangeEventDisp.Create(Application);
  frmChangeEventDisp.lblTop.Text := ACap;
  frmChangeEventDisp.lstCVOrders.Caption := ACap;
  for i := 0 to AnOrderList.Count - 1 do
  begin
    AnOrder := TOrder(AnOrderList[i]);
    frmChangeEventDisp.lstCVOrders.Items.Add(AnOrder.Text);
  end;
  frmChangeEventDisp.ShowModal;
  Result := frmChangeEventDisp.FOKPressed;
end;

procedure TfrmChangeEventDisp.lstCVOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  x := '';
  ARect := Rect;
  with lstCVOrders do
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


procedure TfrmChangeEventDisp.lstCVOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x:string;
  ARect: TRect;
begin
  inherited;
  AHeight := MainFontHeight + 3;
  with lstCVOrders do if Index < Items.Count then
  begin
    x := Items[index];
    ARect := ItemRect(Index);
    AHeight  := DrawText(Canvas.Handle, PChar(x), Length(x), ARect,
          DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_WORDBREAK) + 2;
    if AHeight > 255 then AHeight := 255;
    if AHeight <  13 then AHeight := 13;
  end;
end;

procedure TfrmChangeEventDisp.cmdOKClick(Sender: TObject);
begin
  inherited;
  FOKPressed := True;
  Close;
end;

procedure TfrmChangeEventDisp.cmdCancelClick(Sender: TObject);
begin
  inherited;
  FOKPressed := False;
  Close;
end;

end.

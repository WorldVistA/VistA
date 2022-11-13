unit fOrdersVerify;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmVerifyOrders = class(TfrmAutoSz)
    Panel1: TPanel;
    lblVerify: TLabel;
    lstOrders: TCaptionListBox;
    Panel2: TPanel;
    lblESCode: TLabel;
    txtESCode: TCaptionEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure lstOrdersMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
    procedure lstOrdersDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Panel1Resize(Sender: TObject);
  private
    OKPressed: Boolean;
    ESCode: string;
  end;

function ExecuteVerifyOrders(SelectedList: TList; ChartReview: Boolean): Boolean;

implementation

{$R *.DFM}

uses
  XWBHash, rCore, rOrders, System.UITypes, VAUtils;

const
  TX_CHART_REVIEW = 'The following orders will be marked as reviewed -';

function ExecuteVerifyOrders(SelectedList: TList; ChartReview: Boolean): Boolean;
var
  frmVerifyOrders: TfrmVerifyOrders;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmVerifyOrders := TfrmVerifyOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmVerifyOrders));
    if ChartReview then
    begin
      frmVerifyOrders.lblVerify.Caption := TX_CHART_REVIEW;
      frmVerifyOrders.Caption := 'Chart Review';
    end;
    with SelectedList do for i := 0 to Count - 1 do
      frmVerifyOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmVerifyOrders.ShowModal;
    if frmVerifyOrders.OKPressed then
    begin
      with SelectedList do for i := 0 to Count - 1 do
      begin
        if ChartReview
          then VerifyOrderChartReview(TOrder(Items[i]), frmVerifyOrders.ESCode)
          else VerifyOrder(TOrder(Items[i]), frmVerifyOrders.ESCode);
      end;
      Result := True;
    end;
  finally
    frmVerifyOrders.Release;
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmVerifyOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmVerifyOrders.cmdOKClick(Sender: TObject);
const
  TX_NO_CODE  = 'An electronic signature code must be entered to verify orders.';
  TC_NO_CODE  = 'Electronic Signature Code Required';
  TX_BAD_CODE = 'The electronic signature code entered is not valid.';
  TC_BAD_CODE = 'Invalid Electronic Signature Code';
begin
  inherited;
  if Length(txtESCode.Text) = 0 then
  begin
    InfoBox(TX_NO_CODE, TC_NO_CODE, MB_OK);
    Exit;
  end;
  if not ValidESCode(txtESCode.Text) then
  begin
    InfoBox(TX_BAD_CODE, TC_BAD_CODE, MB_OK);
    txtESCode.SetFocus;
    txtESCode.SelectAll;
    Exit;
  end;
  ESCode := Encrypt(txtESCode.Text);
  OKPressed := True;
  Close;
end;

procedure TfrmVerifyOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmVerifyOrders.lstOrdersMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
var
  x: string;
  ARect: TRect;
begin
  inherited;
  with lstOrders do if Index < Items.Count then
  begin
    ARect := ItemRect(Index);
    Canvas.FillRect(ARect);
    x := FilteredString(Items[Index]);
    AHeight := WrappedTextHeightByFont(Canvas, Font, x, ARect);
    if AHeight <  13 then AHeight := 15;
  end;
end;

procedure TfrmVerifyOrders.lstOrdersDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
  SaveColor: TColor;
begin
  inherited;
  with lstOrders do
  begin
    ARect := Rect;
    ARect.Left := ARect.Left + 2;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    SaveColor := Canvas.Brush.Color;
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := FilteredString(Items[Index]);
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
      Canvas.Brush.Color := SaveColor;
      ARect.Right := ARect.Right + 4;
    end;
  end;
end;

procedure TfrmVerifyOrders.Panel1Resize(Sender: TObject);
begin
  inherited;
  lstOrders.Invalidate;
end;

end.

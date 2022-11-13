unit fOrdersComplete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmCompleteOrders = class(TfrmAutoSz)
    Label1: TLabel;
    lstOrders: TCaptionListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblESCode: TLabel;
    txtESCode: TCaptionEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
    ESCode: string;
  end;

function ExecuteCompleteOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses
 XWBHash, rCore, rOrders, VAUtils;

function ExecuteCompleteOrders(SelectedList: TList): Boolean;
var
  frmCompleteOrders: TfrmCompleteOrders;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmCompleteOrders := TfrmCompleteOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmCompleteOrders));
    with SelectedList do for i := 0 to Count - 1 do
      frmCompleteOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmCompleteOrders.ShowModal;
    if frmCompleteOrders.OKPressed then
    begin
      with SelectedList do
        for i := 0 to Count - 1 do CompleteOrder(TOrder(Items[i]), frmCompleteOrders.ESCode);
      Result := True;
    end;
  finally
    frmCompleteOrders.Release;
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmCompleteOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmCompleteOrders.cmdOKClick(Sender: TObject);
const
  TX_NO_CODE  = 'An electronic signature code must be entered to complete orders.';
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

procedure TfrmCompleteOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

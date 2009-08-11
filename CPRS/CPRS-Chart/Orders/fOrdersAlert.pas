unit fOrdersAlert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmAlertOrders = class(TfrmAutoSz)
    Label1: TLabel;
    lstOrders: TCaptionListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblAlertRecipient: TLabel;
    cboAlertRecipient: TORComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboAlertRecipientNeedData(Sender: TObject; const StartFrom: String; Direction, InsertAt: Integer);
    procedure cboOnExit(Sender: TObject);

  private
    OKPressed: Boolean;
  end;

function ExecuteAlertOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uCore, rCore;

var
    AlertRecip: Int64;
    Provider: String;


function ExecuteAlertOrders(SelectedList: TList): Boolean;
var
  frmAlertOrders: TfrmAlertOrders;
  i: Integer;
  AnOrder: TOrder;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  with SelectedList do
     AnOrder := TOrder(Items[0]);    //use first order's provider
     Provider := AnOrder.ProviderName;
     AlertRecip := AnOrder.Provider;
  frmAlertOrders := TfrmAlertOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmAlertOrders));
    //AlertRecip := User.DUZ;
    with SelectedList do for i := 0 to Count - 1 do
       frmAlertOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmAlertOrders.ShowModal;
    if frmAlertOrders.OKPressed then
    begin
      with SelectedList do for i := 0 to Count - 1 do AlertOrder(TOrder(Items[i]),AlertRecip);
      Result := True;
    end;
  finally
    frmAlertOrders.Release;
    with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  end;
end;

procedure TfrmAlertOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
  cboAlertRecipient.InitLongList(Provider);
  cboAlertRecipient.SelectByIEN(AlertRecip);
end;

procedure TfrmAlertOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  cmdOK.SetFocus;     //make sure cbo exit events fire
  OKPressed := True;
  Close;
end;

procedure TfrmAlertOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmAlertOrders.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  cboAlertRecipient.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmAlertOrders.cboOnExit(Sender: TObject);
begin
  with cboAlertRecipient do
    if (ItemIndex = -1) or (Text = '') then
    begin
      AlertRecip := -1;
      ItemIndex := -1;
      Text := '';
    end
    else
    begin
      AlertRecip := ItemIEN;
    end;
end;

end.

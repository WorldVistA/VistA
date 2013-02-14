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
    radClinic: TRadioButton;
    pnlClient: TPanel;
    lstOrders: TCaptionListBox;
    lblOrders: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    OKPressed: Boolean;
    PickupAt: string;
  end;

function ExecuteRefillOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, rMeds, uCore, uConst, rMisc;

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
  if PickupAt = 'C' then
    radClinic.Checked := true
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
  if not (radWindow.Checked or radMail.Checked or radClinic.Checked) then
  begin
    InfoBox(TX_LOCATION_REQ, TC_LOCATION_REQ, MB_OK);
    Exit;
  end;
  OKPressed := True;
  if radWindow.Checked then PickupAt := 'W'
  else if radMail.Checked then PickupAt := 'M'
  else PickupAt := 'C';
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

end.

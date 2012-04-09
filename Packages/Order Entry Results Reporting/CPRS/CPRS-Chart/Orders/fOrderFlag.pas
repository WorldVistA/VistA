unit fOrderFlag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, ORCtrls, VA508AccessibilityManager;

type
  TfrmFlagOrder = class(TfrmAutoSz)
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    memOrder: TMemo;
    lblAlertRecipient: TLabel;
    cboAlertRecipient: TORComboBox;
    cboFlagReason: TORComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboOnExit(Sender: TObject);
    procedure cboAlertRecipientNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
  private
    OKPressed: Boolean;
  end;

function ExecuteFlagOrder(AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

uses uCore, rCore;

var AlertRecip: Int64;

function ExecuteFlagOrder(AnOrder: TOrder): Boolean;
var
  frmFlagOrder: TfrmFlagOrder;
begin
  Result := False;
  frmFlagOrder := TfrmFlagOrder.Create(Application);
  try
    ResizeFormToFont(TForm(frmFlagOrder));
    //AlertRecip := User.DUZ;
    with frmFlagOrder do
    begin
      memOrder.SetTextBuf(PChar(AnOrder.Text));
      ShowModal;
      if OKPressed then
      begin
        FlagOrder(AnOrder, cboFlagReason.Text, AlertRecip);
        Result := True;
      end;
    end;
  finally
    frmFlagOrder.Release;
    AlertRecip := 0;
  end;
end;

procedure TfrmFlagOrder.FormCreate(Sender: TObject);
var
  tmpList: TStringList;
begin
  inherited;
  OKPressed := False;
  tmpList := TStringList.Create;
  try
    GetUserListParam(tmpList, 'OR FLAGGED ORD REASONS');
    FastAssign(tmpList, cboFlagReason.Items);
  finally
    tmpList.Free;
  end;
  cboAlertRecipient.InitLongList('');
  //cboAlertRecipient.SelectByIEN(User.DUZ);
end;

procedure TfrmFlagOrder.cmdOKClick(Sender: TObject);
const
  TX_REASON_REQ = 'A reason must be entered to flag an order.';
  TC_REASON_REQ = 'Reason Required';
begin
  inherited;
  if cboFlagReason.Text = '' then
  //if txtReason.Text = '' then
  begin
    InfoBox(TX_REASON_REQ, TC_REASON_REQ, MB_OK);
    Exit;
  end;
  cmdOK.SetFocus;
  OKPressed := True;
  Close;
end;

procedure TfrmFlagOrder.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmFlagOrder.cboOnExit(Sender: TObject);
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

procedure TfrmFlagOrder.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
   cboAlertRecipient.ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

end.

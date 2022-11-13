unit fOrderFlag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, ORCtrls, VA508AccessibilityManager,
  ORDtTm;

type
  TfrmFlagOrder = class(TfrmAutoSz)
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    memOrder: TMemo;
    lblAlertRecipient: TLabel;
    cboFlagReason: TORComboBox;
    cboAlertRecipient: TORComboBox;
    orSelectedRecipients: TORListBox;
    dtFlagExpire: TORDateBox;
    Label2: TLabel;
    btnRemoveRecipients: TButton;
    btnRemoveAllRecipients: TButton;
    btnAddRecipient: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cboOnExit(Sender: TObject);
    procedure cboAlertRecipientNeedData(Sender: TObject;
      const StartFrom: string; Direction, InsertAt: Integer);
    procedure btnRemoveRecipientsClick(Sender: TObject);
    procedure btnAddRecipientClick(Sender: TObject);
    procedure btnRemoveAllRecipientsClick(Sender: TObject);
    procedure cboAlertRecipientChange(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteFlagOrder(AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

uses uCore, rCore, uSimilarNames, VAUtils;

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
//        FlagOrder(AnOrder, cboFlagReason.Text, AlertRecip);
//Line below Added by KCH 05/18/2015 for NSR #20110719
        FlagOrder4(AnOrder, cboFlagReason.Text, orSelectedRecipients.Items, dtFlagExpire.Text);
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

procedure TfrmFlagOrder.btnAddRecipientClick(Sender: TObject);
var
  DUZ: Int64;

begin
  if cboAlertRecipient.ItemIndex = -1 then
    Exit;

  if (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) <> -1) then
    Exit;

  // verify if filtering by PROVIDER key is needed!
  DUZ := getProviderIdCheckedForSimilarName(cboAlertRecipient.ItemID,
    'PROVIDER', orSelectedRecipients.Items);
  if DUZ > 0 then
  begin
    orSelectedRecipients.Items.Add(cboAlertRecipient.Items
      [cboAlertRecipient.ItemIndex]);
    btnRemoveRecipients.Enabled := orSelectedRecipients.SelCount > 0;
    btnRemoveAllRecipients.Enabled := orSelectedRecipients.Items.Count > 0;
  end;
end;

procedure TfrmFlagOrder.btnRemoveAllRecipientsClick(Sender: TObject);
begin
  inherited;
  orSelectedRecipients.SelectAll;
  btnRemoveRecipientsClick(self);
end;

procedure TfrmFlagOrder.btnRemoveRecipientsClick(Sender: TObject);
var
  i: integer;
begin
  with orSelectedRecipients do
    begin
      if ItemIndex = -1 then exit ;
      for i := Items.Count-1 downto 0 do
        if Selected[i] then
          begin
            Items.Delete(i) ;
          end;
    end;
end;

procedure TfrmFlagOrder.cboAlertRecipientChange(Sender: TObject);
begin
  inherited;
  btnAddRecipient.Enabled := cboAlertRecipient.ItemIndex > -1;

  if (orSelectedRecipients.SelectByID(cboAlertRecipient.ItemID) <> -1) then
    btnAddRecipient.Enabled := false;
end;

procedure TfrmFlagOrder.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: string; Direction, InsertAt: Integer);
begin
  TORComboBox(Sender).ForDataUse(SubSetOfPersons(StartFrom, Direction));
end;

procedure TfrmFlagOrder.cboOnExit(Sender: TObject);
//var i : Integer;
//
begin
  with cboAlertRecipient do
//   for i := 0 to Items.Count - 1 do
//    begin
    if (ItemIndex = -1) or (Text = '') then
    begin
      AlertRecip := -1;
      ItemIndex := -1;
      Text := '';
    end
    else
    begin
      AlertRecip := ItemIEN;
//      orSelectedRecipients.Items.Add(Items[i]);
    end;
//    end;
end;

end.

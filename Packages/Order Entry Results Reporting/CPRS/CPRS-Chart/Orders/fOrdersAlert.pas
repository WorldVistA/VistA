unit fOrdersAlert;

{ ------------------------------------------------------------------------------
  Update History

  2016-02-25: NSR#20110606 (Similar Provider/Cosigner names)
  ------------------------------------------------------------------------------- }

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
    procedure cboAlertRecipientNeedData(Sender: TObject;
      const StartFrom: String; Direction, InsertAt: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    procedure SetUp(aList: TList);
  end;

function ExecuteAlertOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uCore, rCore, uORLists, uSimilarNames, VAUtils;

function ExecuteAlertOrders(SelectedList: TList): Boolean;
var
  frmAlertOrders: TfrmAlertOrders;
  i: Integer;
  AlertRecip: Int64;
begin
  Result := False;
  if SelectedList.Count = 0 then
    Exit;
  frmAlertOrders := TfrmAlertOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmAlertOrders));
    frmAlertOrders.SetUp(SelectedList);
    if frmAlertOrders.ShowModal = mrOK then
    begin

      AlertRecip := frmAlertOrders.cboAlertRecipient.ItemIEN;
      for i := 0 to SelectedList.Count - 1 do
        AlertOrder(TOrder(SelectedList.Items[i]), AlertRecip);
      Result := True;
    end;
  finally
    frmAlertOrders.Release;
    for i := 0 to SelectedList.Count - 1 do
      UnlockOrder(TOrder(SelectedList.Items[i]).ID);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure TfrmAlertOrders.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  ErrMsg: String;
begin
  inherited;
  if ModalResult <> mrOk then
    exit;
  if not CheckForSimilarName(cboAlertRecipient, ErrMsg, sPr) then
  begin
   ShowMsgOn(ErrMsg <> '', ErrMsg, 'Validation Error');
   CanClose := false;
  end;
end;

procedure TfrmAlertOrders.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmAlertOrders.cboAlertRecipientNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
  setPersonList(cboAlertRecipient, StartFrom, Direction);
end;

procedure TfrmAlertOrders.SetUp(aList: TList);
var
  i: Integer;
  AnOrder: TOrder;
  AlertRecip: Int64;
  Provider: String;
begin
  if (not assigned(aList)) or (aList.Count < 1) then
    Exit;

  AnOrder := TOrder(aList.Items[0]); // use first order's provider
  Provider := AnOrder.ProviderName;
  AlertRecip := AnOrder.Provider;
  cboAlertRecipient.InitLongList(Provider);
  cboAlertRecipient.SelectByIEN(AlertRecip);
  TSimilarNames.RegORComboBox(cboAlertRecipient);

  for i := 0 to aList.Count - 1 do
    lstOrders.Items.Add(TOrder(aList.Items[i]).Text);

end;

end.

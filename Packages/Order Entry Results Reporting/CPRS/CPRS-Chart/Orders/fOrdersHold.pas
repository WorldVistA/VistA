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
  private
    OKPressed: Boolean;
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

end.

unit fOrdersUnhold;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ORFn, ORCtrls, VA508AccessibilityManager;

type
  TfrmUnholdOrders = class(TfrmAutoSz)
    Label1: TLabel;
    lstOrders: TCaptionListBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteUnholdOrders(SelectedList: TList): Boolean;

implementation

{$R *.DFM}

uses rOrders, uConst, uCore;

function ExecuteUnholdOrders(SelectedList: TList): Boolean;
var
  frmUnholdOrders: TfrmUnholdOrders;
  OriginalID: string;
  i: Integer;
begin
  Result := False;
  if SelectedList.Count = 0 then Exit;
  frmUnholdOrders := TfrmUnholdOrders.Create(Application);
  try
    ResizeFormToFont(TForm(frmUnholdOrders));
    with SelectedList do for i := 0 to Count - 1 do
      frmUnholdOrders.lstOrders.Items.Add(TOrder(Items[i]).Text);
    frmUnholdOrders.ShowModal;
    if frmUnholdOrders.OKPressed then
    begin
      with SelectedList do for i := 0 to Count - 1 do
      begin
        OriginalID := TOrder(Items[i]).ID;
        ReleaseOrderHold(TOrder(Items[i]));   
        TOrder(Items[i]).ActionOn := OriginalID + '=UH';
        SendMessage(Application.MainForm.Handle, UM_NEWORDER, ORDER_ACT, Integer(Items[i]));
      end;
      Result := True;
    end
    else with SelectedList do for i := 0 to Count - 1 do UnlockOrder(TOrder(Items[i]).ID);
  finally
    frmUnholdOrders.Release;
  end;
end;

procedure TfrmUnholdOrders.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmUnholdOrders.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmUnholdOrders.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

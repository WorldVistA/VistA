unit fOrderUnflag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, ORCtrls, VA508AccessibilityManager;

type
  TfrmUnflagOrder = class(TfrmAutoSz)
    txtComment: TCaptionEdit;
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    memReason: TMemo;
    memOrder: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteUnflagOrder(AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

function ExecuteUnflagOrder(AnOrder: TOrder): Boolean;
var
  frmUnflagOrder: TfrmUnflagOrder;
begin
  Result := False;
  frmUnflagOrder := TfrmUnflagOrder.Create(Application);
  try
    ResizeFormToFont(TForm(frmUnflagOrder));
    with frmUnflagOrder do
    begin
      memOrder.SetTextBuf(PChar(AnOrder.Text));
      LoadFlagReason(memReason.Lines, AnOrder.ID);
      ShowModal;
      if OKPressed then
      begin
        UnflagOrder(AnOrder, txtComment.Text);
        Result := True;
      end;
    end;
  finally
    frmUnflagOrder.Release;
  end;
end;

procedure TfrmUnflagOrder.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmUnflagOrder.cmdOKClick(Sender: TObject);
const
  TX_REASON_REQ = 'A reason must be entered to Unflag an order.';
  TC_REASON_REQ = 'Reason Required';
// Added by KCH on 05/20/2015 for NSR #20071103
//  TX_MESSAGE = 'The Unflag Checkbox must be checked to perform this action.';
//  TC_MESSAGE = 'Unflag Checkbox Status';

begin
  inherited;
  if txtComment.Text = '' then
  begin
    InfoBox(TX_REASON_REQ, TC_REASON_REQ, MB_OK);
    Exit;
  end;

  OKPressed := True;
  Close;
end;

procedure TfrmUnflagOrder.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

unit fOrderFlagComment;
//Added by KCH on 6/19/2015 for NSR#20110719

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, ORCtrls, VA508AccessibilityManager;

type
  TfrmFlagComment = class(TfrmAutoSz)
    txtComment: TCaptionEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    memReason: TMemo;
    lblNewComment: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
  private
    OKPressed: Boolean;
  end;

function ExecuteAddFlagComment(AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

function ExecuteAddFlagComment(AnOrder: TOrder): Boolean;
var
  frmFlagComment: TfrmFlagComment;
begin
  Result := False;
  frmFlagComment := TfrmFlagComment.Create(Application);

  try
    ResizeFormToFont(TForm(frmFlagComment));
    with frmFlagComment do
    begin
//      LoadFlagComments(memReason.Lines, AnOrder.ID);  //Added by KCH on 06/10/2015 for NSR #20071103
      LoadFlagReason(memReason.Lines, AnOrder.ID);
      ShowModal;
      if OKPressed then
      begin
(*
        PutFlagComment(AnOrder, txtComment.Text);
*)
        Result := True;
      end;
    end;
  finally
    frmFlagComment.Release;
  end;
end;

procedure TfrmFlagComment.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmFlagComment.cmdOKClick(Sender: TObject);
const
  TX_REASON_REQ = 'A reason must be entered to Unflag an order.';
  TC_REASON_REQ = 'Reason Required';

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

end.

unit fOrderComment;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ComCtrls, ORFn, rOrders, VA508AccessibilityManager;

type
  TfrmWardComments = class(TfrmAutoSz)
    Label1: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    memOrder: TMemo;
    memComments: ORExtensions.TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure memCommentsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    OKPressed: Boolean;
  end;

function ExecuteWardComments(AnOrder: TOrder): Boolean;

implementation

{$R *.DFM}

uses
  VAUtils;

const
  TC_PUT_ERR = 'Unable to Save Comments';

function ExecuteWardComments(AnOrder: TOrder): Boolean;
var
  frmWardComments: TfrmWardComments;
  ErrMsg: string;
begin
  Result := False;
  frmWardComments := TfrmWardComments.Create(Application);
  try
    ResizeFormToFont(TForm(frmWardComments));
    with frmWardComments do
    begin
      memOrder.SetTextBuf(PChar(AnOrder.Text));
      LoadWardComments(memComments.Lines, AnOrder.ID);
      ShowModal;
      if OKPressed then
      begin
        PutWardComments(memComments.Lines, AnOrder.ID, ErrMsg);
        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TC_PUT_ERR, MB_OK);
        Result := True;
      end;
    end;
  finally
    frmWardComments.Release;
  end;
end;

procedure TfrmWardComments.FormCreate(Sender: TObject);
begin
  inherited;
  OKPressed := False;
end;

procedure TfrmWardComments.cmdOKClick(Sender: TObject);
begin
  inherited;
  OKPressed := True;
  Close;
end;

procedure TfrmWardComments.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmWardComments.memCommentsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_TAB) then
  begin
    if ssShift in Shift then
    begin
      FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
      Key := 0;
    end
    else if ssCtrl	in Shift then
    begin
      FindNextControl(Sender as TWinControl, True, True, False).SetFocus; //next control
      Key := 0;
    end;
  end;
  if (key = VK_ESCAPE) then begin
    FindNextControl(Sender as TWinControl, False, True, False).SetFocus; //previous control
    key := 0;
  end;
end;

end.

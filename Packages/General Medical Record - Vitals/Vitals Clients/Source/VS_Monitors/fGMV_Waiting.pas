unit fGMV_Waiting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmWaiting = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lblPort: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWaiting: TfrmWaiting;

function newWaiting: TfrmWaiting;
procedure updateWaiting(aMessage:String);
implementation

{$R *.dfm}
function newWaiting: TfrmWaiting;
begin
  if not assigned(frmWaiting) then
    begin
      Application.CreateForm(TfrmWaiting,frmWaiting);
  frmWaiting.Show;
    end;
  Result := frmWaiting;
end;

procedure updateWaiting(aMessage:String);
begin
  NewWaiting;
  if Assigned(frmWaiting) then
    frmWaiting.lblPort.Caption := aMessage;
  Application.ProcessMessages;
end;

end.

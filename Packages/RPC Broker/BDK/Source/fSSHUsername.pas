unit fSSHUsername;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSSHUsername = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SSHUsername: TSSHUsername;

implementation

{$R *.DFM}

procedure TSSHUsername.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

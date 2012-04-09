unit fPlinkpw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfPlinkPassword = class(TForm)
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
  fPlinkPassword: TfPlinkPassword;

implementation

{$R *.DFM}

procedure TfPlinkPassword.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

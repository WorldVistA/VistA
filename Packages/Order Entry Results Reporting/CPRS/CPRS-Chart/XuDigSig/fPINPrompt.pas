unit fPINPrompt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmPINPrompt = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    edtPINValue: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TPINResultVal = (pinOK, pinCancel, pinLocked);

var
  frmPINPrompt: TfrmPINPrompt;
  PINValue: String;

implementation

{$R *.dfm}

procedure TfrmPINPrompt.btnOKClick(Sender: TObject);
begin
  PINValue := edtPINValue.Text;
end;

procedure TfrmPINPrompt.FormShow(Sender: TObject);
begin
  edtPINValue.SetFocus;
end;

end.

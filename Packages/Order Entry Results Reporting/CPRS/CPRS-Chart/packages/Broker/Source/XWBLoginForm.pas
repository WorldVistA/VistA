unit XWBLoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.Buttons;

type
  TXWBLoginForm = class(TForm)
    LabelOr: TLabel;
    PanelLeft: TPanel;
    LabelPIVCard: TLabel;
    PanelRight: TPanel;
    LabelNetworkID: TLabel;
    LabelUsername: TLabel;
    LabelPassword: TLabel;
    LabelDeactivated: TLabel;
    EditUsername: TEdit;
    EditPassword: TEdit;
    ButtonSignIn: TButton;
    ButtonCancelSignIn: TButton;
    PIVCardImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    procedure ButtonCancelSignInClick(Sender: TObject);
    procedure ButtonSignInClick(Sender: TObject);
    procedure PIVCardImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PIVCardImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure EditPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    UserName, Password, CloseResult: String;
    { Public declarations }
  end;

var
  LoginForm: TXWBLoginForm;

implementation

{$R *.dfm}

procedure TXWBLoginForm.ButtonCancelSignInClick(Sender: TObject);
begin
  CloseResult := 'Cancel';
  Self.Close();
end;

procedure TXWBLoginForm.ButtonSignInClick(Sender: TObject);
begin
  if (EditUsername.Text = 'Enter your network username') or
    (EditPassword.Text = 'Enter your network password') then
  begin
    ShowMessage('You must enter valid values');
    EditUsername.SetFocus;
    exit;
  end;
  if EditUsername.Text <> 'Enter your network username' then
    UserName := EditUsername.Text
  else
    UserName := '';
  if EditPassword.Text <> 'Enter your network password' then
    Password := EditPassword.Text
  else
    Password := '';
  CloseResult := 'ADLogin';
  Self.Close();
end;

procedure TXWBLoginForm.EditPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    ButtonSignIn.Click;
    Key := #0;
  end;
  if EditPassword.Text = 'Enter your network password' then
  begin
    EditPassword.Text := '';
  end;
  EditPassword.PasswordChar := '*';
end;

procedure TXWBLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CloseResult = '' then
    CloseResult := 'Cancel';
end;

procedure TXWBLoginForm.FormShow(Sender: TObject);
begin
  EditUsername.SetFocus;
end;

procedure TXWBLoginForm.PIVCardImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PIVCardImage.Proportional := true;
  PIVCardImage.Center := true;
end;

procedure TXWBLoginForm.PIVCardImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PIVCardImage.Proportional := false;
  PIVCardImage.Center := false;
  PIVCardImage.Refresh;
  CloseResult := 'PIVLogin';
  Self.Close();
end;

procedure TXWBLoginForm.SpeedButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Application.ShowHint := false;
  EditPassword.PasswordChar := #0
end;

procedure TXWBLoginForm.SpeedButton1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Application.ShowHint := true;
  EditPassword.PasswordChar := '*';
end;

end.

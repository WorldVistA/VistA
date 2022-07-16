{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: SSH tunneling for Attachmate Reflection.
  Unit: fSSHUsername
	Current Release: Version 1.1 Patch 65
*************************************************************** }

{ **************************************************
  Changes in v1.1.65 (HGW 08/05/2013) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 09/11/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 06/24/2008) XWB*1.1*50
  1. Adding use of SSH tunneling as command line option (or property). It
     appears that tunneling with Attachmate Reflection will be used within
     the VA.  However, code for the use of Plink.exe for SSH tunneling is
     also provided to permit secure connections for those using VistA
     outside of the VA.
************************************************** }
unit fSSHUsername;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {Vcl}
  Graphics, Controls, Forms, Dialogs, StdCtrls;

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

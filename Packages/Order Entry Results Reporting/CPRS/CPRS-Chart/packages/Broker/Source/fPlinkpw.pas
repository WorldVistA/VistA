{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Joel Ivey
  Description: SSH tunneling for Plink.exe.
  Unit: fPlinkpw
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
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
unit fPlinkpw;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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

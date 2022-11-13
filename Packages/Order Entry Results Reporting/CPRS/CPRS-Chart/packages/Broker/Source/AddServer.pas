{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: AddServer adds server to list of personal servers
  for selection.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in v1.1.71 (RGG 10/18/2018) XWB*1.1*71
  1. Changed current version 71

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 05/08/2014) XWB*1.1*60
  1. Added field to store SSH host name for site to use SSH connection.

  Changes in v1.1.50 (JLI 9/1/2011) XWB*1.1*50
  1. None
  ************************************************** }
unit AddServer;

interface

uses
  {System}
  SysUtils, Classes,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  {WinApi}
  Windows, Messages;

type
  TfrmAddServer = class(TForm)
    lblAddress: TLabel;
    lblPortNumber: TLabel;
    edtAddress: TEdit;
    edtPortNumber: TEdit;
    bbtnOK: TBitBtn;
    bbtnCancel: TBitBtn;
    edtSSHusername: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddServer: TfrmAddServer;

implementation

{$R *.DFM}
{ See the following code in Rpcconf1:

  procedure TrpcConfig.btnNewClick(Sender: TObject);

}

end.

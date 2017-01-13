{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Add Server to list of personal servers for
	             selection.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit AddServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmAddServer = class(TForm)
    lblAddress: TLabel;
    lblPortNumber: TLabel;
    edtAddress: TEdit;
    edtPortNumber: TEdit;
    bbtnOK: TBitBtn;
    bbtnCancel: TBitBtn;
  private
    function GetAddress: string;
    function GetPort: string;
    procedure SetAddress(const Value: string);
    procedure SetPort(const Value: string);
    { Private declarations }
  public
    property Address: string read GetAddress write SetAddress;
    property Port: string read GetPort write SetPort;
  end;

var
  frmAddServer: TfrmAddServer;

implementation

{$R *.DFM}

{ TfrmAddServer }

function TfrmAddServer.GetAddress: string;
begin
  Result := edtAddress.Text;
end;

function TfrmAddServer.GetPort: string;
begin
  Result := edtPortNumber.Text;
end;

procedure TfrmAddServer.SetAddress(const Value: string);
begin
  edtAddress.Text := Value;
end;

procedure TfrmAddServer.SetPort(const Value: string);
begin
  edtPortNumber.Text := Value;
end;

end.

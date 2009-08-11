{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Add Server to list of personal servers for
	             selection.
	Current Release: Version 1.1 Patch 47 (February 7, 2007))
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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddServer: TfrmAddServer;

implementation

{$R *.DFM}

end.

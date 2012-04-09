{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Displays message from server after user signon.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit frmSignonMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, XWBRich20;

type
  TfrmSignonMsg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    mmoMsg: TXWBRichEdit;
    procedure Panel2Resize(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignonMsg: TfrmSignonMsg;
                                                  
implementation

{$R *.DFM}

procedure TfrmSignonMsg.Panel2Resize(Sender: TObject);
begin
  BitBtn1.Left := (Panel2.Width - BitBtn1.Width) div 2;
end;

procedure TfrmSignonMsg.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

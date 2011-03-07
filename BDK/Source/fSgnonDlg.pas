{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Signon Dialog for Initial ESSO Signon.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit fSgnonDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmSignonDialog = class(TForm)
    btnOK: TBitBtn;
    btnNO: TBitBtn;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignonDialog: TfrmSignonDialog;

implementation

{$R *.DFM}

end.

{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Contains TRPCBroker and related components.
  Unit: fSgnonDlg Signon Dialog for Initial ESSO Signon.
	Current Release: Version 1.1 Patch 65
*************************************************************** }

{ **************************************************
  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
************************************************** }
unit fSgnonDlg;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {Vcl}
  Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons;

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

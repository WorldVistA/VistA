{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Contains TRPCBroker and related components.
  Unit: fDebugInfo displays information for debug mode.
	Current Release: Version 1.1 Patch 65
*************************************************************** }

{ **************************************************
  Changes in v1.1.65 (HGW 09/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 09/01/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
************************************************** }
unit fDebugInfo;

interface

uses
  {System}
  SysUtils, Classes,
  {WinApi}
  Windows, Messages,
  {Vcl}
  Graphics, Controls, Forms, Dialogs, StdCtrls;

type
   TfrmDebugInfo = class(TForm)
      lblDebugInfo: TLabel;
      btnOK: TButton;
   private
      { Private declarations }
   public
      { Public declarations }
end;

var
   frmDebugInfo: TfrmDebugInfo;

implementation

{$R *.DFM}

end.

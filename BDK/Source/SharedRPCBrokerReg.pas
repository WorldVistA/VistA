{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Registers TSharedRPCBroker.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }


unit SharedRPCBrokerReg;

{$I IISBase.inc}

interface

procedure Register;

implementation

uses Classes,
  {$IFDEF D6_OR_HIGHER}
  DesignIntf, DesignEditors, DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
     ExptIntf, //Delphi units
{$IFDEF D5_OR_HIGHER}
     RPCSharedBrokerSessionMgr1_TLB,             //Broker units
{$ENDIF}
     SharedRPCBroker;


procedure Register;
begin

{$IFDEF D5_OR_HIGHER}
  RegisterComponents('Kernel',[TSharedRPCBroker, TSharedBroker]);
{$ELSE}
  RegisterComponents('Kernel',[TSharedRPCBroker]);
{$ENDIF}

end;

end.
 
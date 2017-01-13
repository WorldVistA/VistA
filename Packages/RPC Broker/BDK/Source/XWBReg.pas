{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Registers components and property editors.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit XWBReg;

{$I IISBase.inc}

interface

procedure Register;

implementation

uses Classes,
  DesignIntf, DesignEditors, DesignMenus,
  Trpcb, {CCOWRPCBroker,}
  RpcbEdtr, XWBRich20,             //Broker units
  VergenceContextorLib_TLB;

procedure Register;
begin
  RegisterComponents('Kernel',[TRPCBroker, {TCCOWRPCBroker,} TXWBRichEdit, TContextorControl]);

  RegisterPropertyEditor(TypeInfo(TRemoteProc),nil,'',TRemoteProcProperty);
  RegisterPropertyEditor(TypeInfo(TServer),nil,'',TServerProperty);
  //RegisterPropertyEditor(TypeInfo(TRpcVersion),nil,'',TRpcVersionProperty);
end;

end.

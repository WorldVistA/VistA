{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Registers components and property editors.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in V1.1.71 (RGG 10/18/2018) XWB*1.1*71
  1. None
  
  Changes in v1.1.65 (HGW 03/22/2016) XWB*1.1*65
  1. Added new component TXWBSSOiToken. This component is not needed for
  TRPCBroker or TCCOWRPCBroker as the attributes are set internally,
  but needs to be explicitely exposed as an external interface for
  the BAPI32.DLL so that non-RPCbroker applications (Attachmate Reflections)
  can call to obtain an STS token.

  Changes in v1.1.60 (HGW 03/27/2014) XWB*1.1*60
  1. None

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None
  ************************************************** }

unit XWBReg;

{$I IISBase.inc}

interface

procedure Register;

implementation

uses
  {System}
  System.Classes,
  {?}
  DesignIntf, DesignEditors, DesignMenus,
  {VA}
  Trpcb, CCOWRPCBroker, XWBSSOi,
  RpcbEdtr, XWBRich20,
  VergenceContextorLib_TLB;

procedure Register;
begin
  RegisterComponents('Kernel', [TRPCBroker, TCCOWRPCBroker, TXWBRichEdit,
    TContextorControl, TXWBSSOiToken]);

  RegisterPropertyEditor(TypeInfo(TRemoteProc), TRPCBroker, 'RemoteProcedure', TRemoteProcProperty);
  RegisterPropertyEditor(TypeInfo(TServer), TRPCBroker, 'Server', TServerProperty);
  RegisterPropertyEditor(TypeInfo(TRpcVersion), TRPCBroker, 'RpcVersion', TRpcVersionProperty);

end;

end.

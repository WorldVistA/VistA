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
  {$IFDEF D6_OR_HIGHER}
  DesignIntf, DesignEditors, DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
     ExptIntf, //Delphi units
     Trpcb, CCOWRPCBroker,
     RpcbEdtr, XWBRich20,             //Broker units
//{$IFDEF VER130}
//    VERGENCECONTEXTORLib_TLB_D50;
//{$ENDIF}
//{$IFDEF VER140}
//  VERGENCECONTEXTORLib_TLB_D60; //CCOW
//ENDIF}
    VergenceContextorLib_TLB;

procedure Register;
begin
  RegisterComponents('Kernel',[TRPCBroker, TCCOWRPCBroker, TXWBRichEdit, TContextorControl]);

  RegisterPropertyEditor(TypeInfo(TRemoteProc),nil,'',TRemoteProcProperty);
  RegisterPropertyEditor(TypeInfo(TServer),nil,'',TServerProperty);
  RegisterPropertyEditor(TypeInfo(TRpcVersion),nil,'',TRpcVersionProperty);
end;

end.

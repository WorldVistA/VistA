{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Type library for use with uSharedBroker1 in
	             building RPCSharedBrokerSessionMgr1.exe.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit RPCSharedBrokerSessionMgr1_TLB_SRB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 1/24/2002 12:39:11 PM from Type Library described below.

// ************************************************************************ //
// Type Lib: D:\Development\RPCSharedBroker\Exe1\RPCSharedBrokerSessionMgr1.tlb (1)
// IID\LCID: {1F7D1EB0-E54F-46F0-B485-2D56743EBB70}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, {OleServer,} OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  RPCSharedBrokerSessionMgr1MajorVersion = 1;
  RPCSharedBrokerSessionMgr1MinorVersion = 0;

  LIBID_RPCSharedBrokerSessionMgr1: TGUID = '{1F7D1EB0-E54F-46F0-B485-2D56743EBB70}';

  IID_ISharedBroker: TGUID = '{E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}';
  DIID_ISharedBrokerEvents: TGUID = '{CBEA7167-4F9B-465A-B82E-4CEBDF933C35}';
  CLASS_SharedBroker: TGUID = '{EB44A5CD-1871-429F-A5BC-19C71B722182}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum ISharedBrokerErrorCode
type
  ISharedBrokerErrorCode = TOleEnum;
const
  GeneralFailure = $00000000;
  Success = $00000001;
  UniqueRpcIdDoesNotExist = $00000002;
  UniqueClientIdDoesNotExist = $00000003;
  RpcHistoryIndexOutOfRange = $00000004;
  RpcHistoryNotEnabled = $00000005;
  CouldNotSetContext = $00000006;
  CouldNotConnect = $00000007;
  ClientIndexOutOfRange = $00000008;
  NilClientPointer = $00000009;
  ConnectionIndexOutOfRange = $0000000A;

// Constants for enum IRegistryRootEnum
type
  IRegistryRootEnum = TOleEnum;
const
  HKCR = $00000000;
  HKCU = $00000001;
  HKLM = $00000002;
  HKU = $00000003;
  HKCC = $00000004;
  HKDD = $00000005;

// Constants for enum ISharedBrokerConnection
type
  ISharedBrokerConnection = TOleEnum;
const
  Failed = $00000000;
  New = $00000001;
  Shared = $00000002;
  Debug = $00000003;

// Constants for enum ISharedBrokerClient
type
  ISharedBrokerClient = TOleEnum;
const
  BrokerClient = $00000000;
  DebuggerClient = $00000001;

// Constants for enum ISharedBrokerShowErrorMsgs
type
  ISharedBrokerShowErrorMsgs = TOleEnum;
const
  isemRaise = $00000000;
  isemQuiet = $00000001;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ISharedBroker = interface;
  ISharedBrokerDisp = dispinterface;
  ISharedBrokerEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  SharedBroker = ISharedBroker;


// *********************************************************************//
// Interface: ISharedBroker
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}
// *********************************************************************//
  ISharedBroker = interface(IDispatch)
    ['{E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}']
    function  BrokerConnect(const ClientName: WideString; ConnectionType: ISharedBrokerClient; 
                            const ServerPort: WideString; WantDebug: WordBool; 
                            AllowShared: WordBool; KernelLogin: WordBool; 
                            ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT; 
                            var LoginStr: WideString; out UniqueClientIId: SYSINT; 
                            out ErrorMsg: WideString): ISharedBrokerErrorCode; safecall;
    function  BrokerDisconnect: ISharedBrokerErrorCode; safecall;
    function  BrokerSetContext(const OptionName: WideString): ISharedBrokerErrorCode; safecall;
    function  BrokerCall(const RpcName: WideString; const RpcParams: WideString; 
                         RpcTimeLimit: Integer; out RpcResults: WideString; 
                         out UniqueRpcCallId: Integer): ISharedBrokerErrorCode; safecall;
    function  ReadRegDataDefault(Root: IRegistryRootEnum; const Key: WideString; 
                                 const Name: WideString; const Default: WideString; 
                                 out RegResult: WideString): ISharedBrokerErrorCode; safecall;
    function  Get_RpcVersion: WideString; safecall;
    procedure Set_RpcVersion(const version: WideString); safecall;
    function  Get_RpcHistoryEnabled: WordBool; safecall;
    procedure Set_RpcHistoryEnabled(enabled: WordBool); safecall;
    function  Get_PerClientRpcHistoryLimit: Integer; safecall;
    procedure Set_PerClientRpcHistoryLimit(limit: Integer); safecall;
    function  GetRpcHistoryCountForClient(UniqueClientId: Integer; out rpcHistoryCount: Integer): ISharedBrokerErrorCode; safecall;
    function  GetClientIdAndNameFromIndex(clientIndex: Integer; out UniqueClientId: Integer; 
                                          out ClientName: WideString): ISharedBrokerErrorCode; safecall;
    function  LogoutConnectedClients(logoutTimeLimit: Integer): ISharedBrokerErrorCode; safecall;
    function  GetClientNameFromUniqueClientId(UniqueClientId: Integer; out ClientName: WideString): ISharedBrokerErrorCode; safecall;
    function  GetActiveBrokerConnectionIndexCount(out connectionIndexCount: Integer): ISharedBrokerErrorCode; safecall;
    function  GetActiveBrokerConnectionInfo(connectionIndex: Integer; 
                                            out connectedServerIp: WideString; 
                                            out connectedServerPort: Integer; 
                                            out lastContext: WideString): ISharedBrokerErrorCode; safecall;
    function  GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer; 
                                                               out connectionIndex: Integer): ISharedBrokerErrorCode; safecall;
    function  GetRpcCallFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                    out brokerContext: WideString; out RpcName: WideString; 
                                    out RpcParams: WideString; out rpcResult: WideString; 
                                    out rpcStartDateTime: Double; out rpcDuration: Integer): ISharedBrokerErrorCode; safecall;
    function  GetRpcCallFromHistoryIndex(UniqueClientId: Integer; rpcCallIndex: Integer; 
                                         out uniqueRpcId: Integer; out brokerContext: WideString; 
                                         out RpcName: WideString; out RpcParams: WideString; 
                                         out rpcResult: WideString; out rpcStartDateTime: Double; 
                                         out rpcDuration: Integer): ISharedBrokerErrorCode; safecall;
    function  GetRpcClientIdFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                        out ClientName: WideString): ISharedBrokerErrorCode; safecall;
    function  GetConnectedClientCount(out connectedClientCount: Integer): ISharedBrokerErrorCode; safecall;
    function  Get_CurrentContext: WideString; safecall;
    function  Get_User: WideString; safecall;
    function  Get_Login: WideString; safecall;
    procedure Set_Login(const Value: WideString); safecall;
    function  Get_RpcbError: WideString; safecall;
    function  Get_Socket: Integer; safecall;
    function  Get_KernelLogin: WordBool; safecall;
    procedure Set_KernelLogin(Value: WordBool); safecall;
    function  Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs; safecall;
    procedure Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs); safecall;
    property RpcVersion: WideString read Get_RpcVersion write Set_RpcVersion;
    property RpcHistoryEnabled: WordBool read Get_RpcHistoryEnabled write Set_RpcHistoryEnabled;
    property PerClientRpcHistoryLimit: Integer read Get_PerClientRpcHistoryLimit write Set_PerClientRpcHistoryLimit;
    property CurrentContext: WideString read Get_CurrentContext;
    property User: WideString read Get_User;
    property Login: WideString read Get_Login write Set_Login;
    property RpcbError: WideString read Get_RpcbError;
    property Socket: Integer read Get_Socket;
    property KernelLogin: WordBool read Get_KernelLogin write Set_KernelLogin;
    property ShowErrorMsgs: ISharedBrokerShowErrorMsgs read Get_ShowErrorMsgs write Set_ShowErrorMsgs;
  end;

// *********************************************************************//
// DispIntf:  ISharedBrokerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}
// *********************************************************************//
  ISharedBrokerDisp = dispinterface
    ['{E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}']
    function  BrokerConnect(const ClientName: WideString; ConnectionType: ISharedBrokerClient; 
                            const ServerPort: WideString; WantDebug: WordBool; 
                            AllowShared: WordBool; KernelLogin: WordBool; 
                            ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT; 
                            var LoginStr: WideString; out UniqueClientIId: SYSINT; 
                            out ErrorMsg: WideString): ISharedBrokerErrorCode; dispid 1;
    function  BrokerDisconnect: ISharedBrokerErrorCode; dispid 2;
    function  BrokerSetContext(const OptionName: WideString): ISharedBrokerErrorCode; dispid 3;
    function  BrokerCall(const RpcName: WideString; const RpcParams: WideString; 
                         RpcTimeLimit: Integer; out RpcResults: WideString; 
                         out UniqueRpcCallId: Integer): ISharedBrokerErrorCode; dispid 4;
    function  ReadRegDataDefault(Root: IRegistryRootEnum; const Key: WideString; 
                                 const Name: WideString; const Default: WideString; 
                                 out RegResult: WideString): ISharedBrokerErrorCode; dispid 5;
    property RpcVersion: WideString dispid 7;
    property RpcHistoryEnabled: WordBool dispid 6;
    property PerClientRpcHistoryLimit: Integer dispid 8;
    function  GetRpcHistoryCountForClient(UniqueClientId: Integer; out rpcHistoryCount: Integer): ISharedBrokerErrorCode; dispid 10;
    function  GetClientIdAndNameFromIndex(clientIndex: Integer; out UniqueClientId: Integer; 
                                          out ClientName: WideString): ISharedBrokerErrorCode; dispid 11;
    function  LogoutConnectedClients(logoutTimeLimit: Integer): ISharedBrokerErrorCode; dispid 12;
    function  GetClientNameFromUniqueClientId(UniqueClientId: Integer; out ClientName: WideString): ISharedBrokerErrorCode; dispid 13;
    function  GetActiveBrokerConnectionIndexCount(out connectionIndexCount: Integer): ISharedBrokerErrorCode; dispid 14;
    function  GetActiveBrokerConnectionInfo(connectionIndex: Integer; 
                                            out connectedServerIp: WideString; 
                                            out connectedServerPort: Integer; 
                                            out lastContext: WideString): ISharedBrokerErrorCode; dispid 15;
    function  GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer; 
                                                               out connectionIndex: Integer): ISharedBrokerErrorCode; dispid 16;
    function  GetRpcCallFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                    out brokerContext: WideString; out RpcName: WideString; 
                                    out RpcParams: WideString; out rpcResult: WideString; 
                                    out rpcStartDateTime: Double; out rpcDuration: Integer): ISharedBrokerErrorCode; dispid 17;
    function  GetRpcCallFromHistoryIndex(UniqueClientId: Integer; rpcCallIndex: Integer; 
                                         out uniqueRpcId: Integer; out brokerContext: WideString; 
                                         out RpcName: WideString; out RpcParams: WideString; 
                                         out rpcResult: WideString; out rpcStartDateTime: Double; 
                                         out rpcDuration: Integer): ISharedBrokerErrorCode; dispid 18;
    function  GetRpcClientIdFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                        out ClientName: WideString): ISharedBrokerErrorCode; dispid 19;
    function  GetConnectedClientCount(out connectedClientCount: Integer): ISharedBrokerErrorCode; dispid 20;
    property CurrentContext: WideString readonly dispid 9;
    property User: WideString readonly dispid 22;
    property Login: WideString dispid 23;
    property RpcbError: WideString readonly dispid 24;
    property Socket: Integer readonly dispid 25;
    property KernelLogin: WordBool dispid 26;
    property ShowErrorMsgs: ISharedBrokerShowErrorMsgs dispid 27;
  end;

// *********************************************************************//
// DispIntf:  ISharedBrokerEvents
// Flags:     (4096) Dispatchable
// GUID:      {CBEA7167-4F9B-465A-B82E-4CEBDF933C35}
// *********************************************************************//
  ISharedBrokerEvents = dispinterface
    ['{CBEA7167-4F9B-465A-B82E-4CEBDF933C35}']
    procedure OnLogout; dispid 1;
    procedure OnRpcCallRecorded(uniqueRpcId: SYSINT); dispid 2;
    procedure OnClientConnect(UniqueClientId: SYSINT; Connection: ISharedBrokerConnection); dispid 3;
    procedure OnClientDisconnect(UniqueClientId: SYSINT); dispid 4;
    procedure OnContextChanged(connectionIndex: SYSINT; const NewContext: WideString); dispid 5;
    procedure OnRPCBFailure(const ErrorText: WideString); dispid 6;
    procedure OnLoginError(const ErrorText: WideString); dispid 7;
    procedure OnConnectionDropped(ConnectionIndex: SYSINT; const ErrorText: WideString); dispid 8;
  end;

// *********************************************************************//
// The Class CoSharedBroker provides a Create and CreateRemote method to          
// create instances of the default interface ISharedBroker exposed by              
// the CoClass SharedBroker. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSharedBroker = class
    class function Create: ISharedBroker;
    class function CreateRemote(const MachineName: string): ISharedBroker;
  end;

implementation

uses ComObj;

class function CoSharedBroker.Create: ISharedBroker;
begin
  Result := CreateComObject(CLASS_SharedBroker) as ISharedBroker;
end;

class function CoSharedBroker.CreateRemote(const MachineName: string): ISharedBroker;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SharedBroker) as ISharedBroker;
end;

end.

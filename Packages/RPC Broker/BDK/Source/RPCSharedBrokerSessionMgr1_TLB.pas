{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Joel Ivey
	Description: Type library for use with SharedRPCBroker.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit RPCSharedBrokerSessionMgr1_TLB;

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
// File generated on 1/25/2002 11:58:49 AM from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: D:\Development\RPCSharedBroker\Exe1\RPCSharedBrokerSessionMgr1.exe (1)
// IID\LCID: {1F7D1EB0-E54F-46F0-B485-2D56743EBB70}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Error creating palette bitmap of (TSharedBroker) : Invalid GUID format
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

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
    procedure OnConnectionDropped(connectionIndex: SYSINT; const ErrorText: WideString); dispid 8;
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

  TSharedBrokerOnRpcCallRecorded = procedure(Sender: TObject; uniqueRpcId: SYSINT) of object;
  TSharedBrokerOnClientConnect = procedure(Sender: TObject; UniqueClientId: SYSINT; 
                                                            Connection: ISharedBrokerConnection) of object;
  TSharedBrokerOnClientDisconnect = procedure(Sender: TObject; UniqueClientId: SYSINT) of object;
  TSharedBrokerOnContextChanged = procedure(Sender: TObject; connectionIndex: SYSINT; 
                                                             var NewContext: OleVariant) of object;
  TSharedBrokerOnRPCBFailure = procedure(Sender: TObject; var ErrorText: OleVariant) of object;
  TSharedBrokerOnLoginError = procedure(Sender: TObject; var ErrorText: OleVariant) of object;
  TSharedBrokerOnConnectionDropped = procedure(Sender: TObject; connectionIndex: SYSINT; 
                                                                var ErrorText: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TSharedBroker
// Help String      : SharedBroker Object
// Default Interface: ISharedBroker
// Def. Intf. DISP? : No
// Event   Interface: ISharedBrokerEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSharedBrokerProperties= class;
{$ENDIF}
  TSharedBroker = class(TOleServer)
  private
    FOnLogout: TNotifyEvent;
    FOnRpcCallRecorded: TSharedBrokerOnRpcCallRecorded;
    FOnClientConnect: TSharedBrokerOnClientConnect;
    FOnClientDisconnect: TSharedBrokerOnClientDisconnect;
    FOnContextChanged: TSharedBrokerOnContextChanged;
    FOnRPCBFailure: TSharedBrokerOnRPCBFailure;
    FOnLoginError: TSharedBrokerOnLoginError;
    FOnConnectionDropped: TSharedBrokerOnConnectionDropped;
    FIntf:        ISharedBroker;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSharedBrokerProperties;
    function      GetServerProperties: TSharedBrokerProperties;
{$ENDIF}
    function      GetDefaultInterface: ISharedBroker;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function  Get_RpcVersion: WideString;
    procedure Set_RpcVersion(const version: WideString);
    function  Get_RpcHistoryEnabled: WordBool;
    procedure Set_RpcHistoryEnabled(enabled: WordBool);
    function  Get_PerClientRpcHistoryLimit: Integer;
    procedure Set_PerClientRpcHistoryLimit(limit: Integer);
    function  Get_CurrentContext: WideString;
    function  Get_User: WideString;
    function  Get_Login: WideString;
    procedure Set_Login(const Value: WideString);
    function  Get_RpcbError: WideString;
    function  Get_Socket: Integer;
    function  Get_KernelLogin: WordBool;
    procedure Set_KernelLogin(Value: WordBool);
    function  Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs;
    procedure Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISharedBroker);
    procedure Disconnect; override;
    function  BrokerConnect(const ClientName: WideString; ConnectionType: ISharedBrokerClient; 
                            const ServerPort: WideString; WantDebug: WordBool; 
                            AllowShared: WordBool; KernelLogin: WordBool; 
                            ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT; 
                            var LoginStr: WideString; out UniqueClientIId: SYSINT; 
                            out ErrorMsg: WideString): ISharedBrokerErrorCode;
    function  BrokerDisconnect: ISharedBrokerErrorCode;
    function  BrokerSetContext(const OptionName: WideString): ISharedBrokerErrorCode;
    function  BrokerCall(const RpcName: WideString; const RpcParams: WideString; 
                         RpcTimeLimit: Integer; out RpcResults: WideString; 
                         out UniqueRpcCallId: Integer): ISharedBrokerErrorCode;
    function  ReadRegDataDefault(Root: IRegistryRootEnum; const Key: WideString; 
                                 const Name: WideString; const Default: WideString; 
                                 out RegResult: WideString): ISharedBrokerErrorCode;
    function  GetRpcHistoryCountForClient(UniqueClientId: Integer; out rpcHistoryCount: Integer): ISharedBrokerErrorCode;
    function  GetClientIdAndNameFromIndex(clientIndex: Integer; out UniqueClientId: Integer; 
                                          out ClientName: WideString): ISharedBrokerErrorCode;
    function  LogoutConnectedClients(logoutTimeLimit: Integer): ISharedBrokerErrorCode;
    function  GetClientNameFromUniqueClientId(UniqueClientId: Integer; out ClientName: WideString): ISharedBrokerErrorCode;
    function  GetActiveBrokerConnectionIndexCount(out connectionIndexCount: Integer): ISharedBrokerErrorCode;
    function  GetActiveBrokerConnectionInfo(connectionIndex: Integer; 
                                            out connectedServerIp: WideString; 
                                            out connectedServerPort: Integer; 
                                            out lastContext: WideString): ISharedBrokerErrorCode;
    function  GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer; 
                                                               out connectionIndex: Integer): ISharedBrokerErrorCode;
    function  GetRpcCallFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                    out brokerContext: WideString; out RpcName: WideString; 
                                    out RpcParams: WideString; out rpcResult: WideString; 
                                    out rpcStartDateTime: Double; out rpcDuration: Integer): ISharedBrokerErrorCode;
    function  GetRpcCallFromHistoryIndex(UniqueClientId: Integer; rpcCallIndex: Integer; 
                                         out uniqueRpcId: Integer; out brokerContext: WideString; 
                                         out RpcName: WideString; out RpcParams: WideString; 
                                         out rpcResult: WideString; out rpcStartDateTime: Double; 
                                         out rpcDuration: Integer): ISharedBrokerErrorCode;
    function  GetRpcClientIdFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                        out ClientName: WideString): ISharedBrokerErrorCode;
    function  GetConnectedClientCount(out connectedClientCount: Integer): ISharedBrokerErrorCode;
    property  DefaultInterface: ISharedBroker read GetDefaultInterface;
    property CurrentContext: WideString read Get_CurrentContext;
    property User: WideString read Get_User;
    property RpcbError: WideString read Get_RpcbError;
    property Socket: Integer read Get_Socket;
    property RpcVersion: WideString read Get_RpcVersion write Set_RpcVersion;
    property RpcHistoryEnabled: WordBool read Get_RpcHistoryEnabled write Set_RpcHistoryEnabled;
    property PerClientRpcHistoryLimit: Integer read Get_PerClientRpcHistoryLimit write Set_PerClientRpcHistoryLimit;
    property Login: WideString read Get_Login write Set_Login;
    property KernelLogin: WordBool read Get_KernelLogin write Set_KernelLogin;
    property ShowErrorMsgs: ISharedBrokerShowErrorMsgs read Get_ShowErrorMsgs write Set_ShowErrorMsgs;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSharedBrokerProperties read GetServerProperties;
{$ENDIF}
    property OnLogout: TNotifyEvent read FOnLogout write FOnLogout;
    property OnRpcCallRecorded: TSharedBrokerOnRpcCallRecorded read FOnRpcCallRecorded write FOnRpcCallRecorded;
    property OnClientConnect: TSharedBrokerOnClientConnect read FOnClientConnect write FOnClientConnect;
    property OnClientDisconnect: TSharedBrokerOnClientDisconnect read FOnClientDisconnect write FOnClientDisconnect;
    property OnContextChanged: TSharedBrokerOnContextChanged read FOnContextChanged write FOnContextChanged;
    property OnRPCBFailure: TSharedBrokerOnRPCBFailure read FOnRPCBFailure write FOnRPCBFailure;
    property OnLoginError: TSharedBrokerOnLoginError read FOnLoginError write FOnLoginError;
    property OnConnectionDropped: TSharedBrokerOnConnectionDropped read FOnConnectionDropped write FOnConnectionDropped;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TSharedBroker
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TSharedBrokerProperties = class(TPersistent)
  private
    FServer:    TSharedBroker;
    function    GetDefaultInterface: ISharedBroker;
    constructor Create(AServer: TSharedBroker);
  protected
    function  Get_RpcVersion: WideString;
    procedure Set_RpcVersion(const version: WideString);
    function  Get_RpcHistoryEnabled: WordBool;
    procedure Set_RpcHistoryEnabled(enabled: WordBool);
    function  Get_PerClientRpcHistoryLimit: Integer;
    procedure Set_PerClientRpcHistoryLimit(limit: Integer);
    function  Get_CurrentContext: WideString;
    function  Get_User: WideString;
    function  Get_Login: WideString;
    procedure Set_Login(const Value: WideString);
    function  Get_RpcbError: WideString;
    function  Get_Socket: Integer;
    function  Get_KernelLogin: WordBool;
    procedure Set_KernelLogin(Value: WordBool);
    function  Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs;
    procedure Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs);
  public
    property DefaultInterface: ISharedBroker read GetDefaultInterface;
  published
    property RpcVersion: WideString read Get_RpcVersion write Set_RpcVersion;
    property RpcHistoryEnabled: WordBool read Get_RpcHistoryEnabled write Set_RpcHistoryEnabled;
    property PerClientRpcHistoryLimit: Integer read Get_PerClientRpcHistoryLimit write Set_PerClientRpcHistoryLimit;
    property Login: WideString read Get_Login write Set_Login;
    property KernelLogin: WordBool read Get_KernelLogin write Set_KernelLogin;
    property ShowErrorMsgs: ISharedBrokerShowErrorMsgs read Get_ShowErrorMsgs write Set_ShowErrorMsgs;
  end;
{$ENDIF}


// procedure Register;

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

procedure TSharedBroker.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{EB44A5CD-1871-429F-A5BC-19C71B722182}';
    IntfIID:   '{E1D9A5E6-B7C6-40AD-AC34-6A3E12BDC328}';
    EventIID:  '{CBEA7167-4F9B-465A-B82E-4CEBDF933C35}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSharedBroker.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as ISharedBroker;
  end;
end;

procedure TSharedBroker.ConnectTo(svrIntf: ISharedBroker);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TSharedBroker.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TSharedBroker.GetDefaultInterface: ISharedBroker;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TSharedBroker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSharedBrokerProperties.Create(Self);
{$ENDIF}
end;

destructor TSharedBroker.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSharedBroker.GetServerProperties: TSharedBrokerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TSharedBroker.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   1: if Assigned(FOnLogout) then
            FOnLogout(Self);
   2: if Assigned(FOnRpcCallRecorded) then
            FOnRpcCallRecorded(Self, Params[0] {SYSINT});
   3: if Assigned(FOnClientConnect) then
            FOnClientConnect(Self, Params[0] {SYSINT}, Params[1] {ISharedBrokerConnection});
   4: if Assigned(FOnClientDisconnect) then
            FOnClientDisconnect(Self, Params[0] {SYSINT});
   5: if Assigned(FOnContextChanged) then
            FOnContextChanged(Self, Params[0] {SYSINT}, Params[1] {const WideString});
   6: if Assigned(FOnRPCBFailure) then
            FOnRPCBFailure(Self, Params[0] {const WideString});
   7: if Assigned(FOnLoginError) then
            FOnLoginError(Self, Params[0] {const WideString});
   8: if Assigned(FOnConnectionDropped) then
            FOnConnectionDropped(Self, Params[0] {SYSINT}, Params[1] {const WideString});
  end; {case DispID}
end;

function  TSharedBroker.Get_RpcVersion: WideString;
begin
  Result := DefaultInterface.Get_RpcVersion;
end;

procedure TSharedBroker.Set_RpcVersion(const version: WideString);
begin
  DefaultInterface.Set_RpcVersion(version);
end;

function  TSharedBroker.Get_RpcHistoryEnabled: WordBool;
begin
  Result := DefaultInterface.Get_RpcHistoryEnabled;
end;

procedure TSharedBroker.Set_RpcHistoryEnabled(enabled: WordBool);
begin
  DefaultInterface.Set_RpcHistoryEnabled(enabled);
end;

function  TSharedBroker.Get_PerClientRpcHistoryLimit: Integer;
begin
  Result := DefaultInterface.Get_PerClientRpcHistoryLimit;
end;

procedure TSharedBroker.Set_PerClientRpcHistoryLimit(limit: Integer);
begin
  DefaultInterface.Set_PerClientRpcHistoryLimit(limit);
end;

function  TSharedBroker.Get_CurrentContext: WideString;
begin
  Result := DefaultInterface.Get_CurrentContext;
end;

function  TSharedBroker.Get_User: WideString;
begin
  Result := DefaultInterface.Get_User;
end;

function  TSharedBroker.Get_Login: WideString;
begin
  Result := DefaultInterface.Get_Login;
end;

procedure TSharedBroker.Set_Login(const Value: WideString);
begin
  DefaultInterface.Set_Login(Value);
end;

function  TSharedBroker.Get_RpcbError: WideString;
begin
  Result := DefaultInterface.Get_RpcbError;
end;

function  TSharedBroker.Get_Socket: Integer;
begin
  Result := DefaultInterface.Get_Socket;
end;

function  TSharedBroker.Get_KernelLogin: WordBool;
begin
  Result := DefaultInterface.Get_KernelLogin;
end;

procedure TSharedBroker.Set_KernelLogin(Value: WordBool);
begin
  DefaultInterface.Set_KernelLogin(Value);
end;

function  TSharedBroker.Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs;
begin
  Result := DefaultInterface.Get_ShowErrorMsgs;
end;

procedure TSharedBroker.Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs);
begin
  DefaultInterface.Set_ShowErrorMsgs(Value);
end;

function  TSharedBroker.BrokerConnect(const ClientName: WideString; 
                                      ConnectionType: ISharedBrokerClient; 
                                      const ServerPort: WideString; WantDebug: WordBool; 
                                      AllowShared: WordBool; KernelLogin: WordBool; 
                                      ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT; 
                                      var LoginStr: WideString; out UniqueClientIId: SYSINT; 
                                      out ErrorMsg: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.BrokerConnect(ClientName, ConnectionType, ServerPort, WantDebug, 
                                           AllowShared, KernelLogin, ShowErrMsgs, RpcTimeLim, 
                                           LoginStr, UniqueClientIId, ErrorMsg);
end;

function  TSharedBroker.BrokerDisconnect: ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.BrokerDisconnect;
end;

function  TSharedBroker.BrokerSetContext(const OptionName: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.BrokerSetContext(OptionName);
end;

function  TSharedBroker.BrokerCall(const RpcName: WideString; const RpcParams: WideString; 
                                   RpcTimeLimit: Integer; out RpcResults: WideString; 
                                   out UniqueRpcCallId: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.BrokerCall(RpcName, RpcParams, RpcTimeLimit, RpcResults, 
                                        UniqueRpcCallId);
end;

function  TSharedBroker.ReadRegDataDefault(Root: IRegistryRootEnum; const Key: WideString; 
                                           const Name: WideString; const Default: WideString; 
                                           out RegResult: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.ReadRegDataDefault(Root, Key, Name, Default, RegResult);
end;

function  TSharedBroker.GetRpcHistoryCountForClient(UniqueClientId: Integer; 
                                                    out rpcHistoryCount: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetRpcHistoryCountForClient(UniqueClientId, rpcHistoryCount);
end;

function  TSharedBroker.GetClientIdAndNameFromIndex(clientIndex: Integer; 
                                                    out UniqueClientId: Integer; 
                                                    out ClientName: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetClientIdAndNameFromIndex(clientIndex, UniqueClientId, ClientName);
end;

function  TSharedBroker.LogoutConnectedClients(logoutTimeLimit: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.LogoutConnectedClients(logoutTimeLimit);
end;

function  TSharedBroker.GetClientNameFromUniqueClientId(UniqueClientId: Integer; 
                                                        out ClientName: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetClientNameFromUniqueClientId(UniqueClientId, ClientName);
end;

function  TSharedBroker.GetActiveBrokerConnectionIndexCount(out connectionIndexCount: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetActiveBrokerConnectionIndexCount(connectionIndexCount);
end;

function  TSharedBroker.GetActiveBrokerConnectionInfo(connectionIndex: Integer; 
                                                      out connectedServerIp: WideString; 
                                                      out connectedServerPort: Integer; 
                                                      out lastContext: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetActiveBrokerConnectionInfo(connectionIndex, connectedServerIp, 
                                                           connectedServerPort, lastContext);
end;

function  TSharedBroker.GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer; 
                                                                         out connectionIndex: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId, 
                                                                              connectionIndex);
end;

function  TSharedBroker.GetRpcCallFromHistory(uniqueRpcId: Integer; out UniqueClientId: Integer; 
                                              out brokerContext: WideString; 
                                              out RpcName: WideString; out RpcParams: WideString; 
                                              out rpcResult: WideString; 
                                              out rpcStartDateTime: Double; out rpcDuration: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetRpcCallFromHistory(uniqueRpcId, UniqueClientId, brokerContext, 
                                                   RpcName, RpcParams, rpcResult, rpcStartDateTime, 
                                                   rpcDuration);
end;

function  TSharedBroker.GetRpcCallFromHistoryIndex(UniqueClientId: Integer; rpcCallIndex: Integer; 
                                                   out uniqueRpcId: Integer; 
                                                   out brokerContext: WideString; 
                                                   out RpcName: WideString; 
                                                   out RpcParams: WideString; 
                                                   out rpcResult: WideString; 
                                                   out rpcStartDateTime: Double; 
                                                   out rpcDuration: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetRpcCallFromHistoryIndex(UniqueClientId, rpcCallIndex, uniqueRpcId, 
                                                        brokerContext, RpcName, RpcParams, 
                                                        rpcResult, rpcStartDateTime, rpcDuration);
end;

function  TSharedBroker.GetRpcClientIdFromHistory(uniqueRpcId: Integer; 
                                                  out UniqueClientId: Integer; 
                                                  out ClientName: WideString): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetRpcClientIdFromHistory(uniqueRpcId, UniqueClientId, ClientName);
end;

function  TSharedBroker.GetConnectedClientCount(out connectedClientCount: Integer): ISharedBrokerErrorCode;
begin
  Result := DefaultInterface.GetConnectedClientCount(connectedClientCount);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSharedBrokerProperties.Create(AServer: TSharedBroker);
begin
  inherited Create;
  FServer := AServer;
end;

function TSharedBrokerProperties.GetDefaultInterface: ISharedBroker;
begin
  Result := FServer.DefaultInterface;
end;

function  TSharedBrokerProperties.Get_RpcVersion: WideString;
begin
  Result := DefaultInterface.Get_RpcVersion;
end;

procedure TSharedBrokerProperties.Set_RpcVersion(const version: WideString);
begin
  DefaultInterface.Set_RpcVersion(version);
end;

function  TSharedBrokerProperties.Get_RpcHistoryEnabled: WordBool;
begin
  Result := DefaultInterface.Get_RpcHistoryEnabled;
end;

procedure TSharedBrokerProperties.Set_RpcHistoryEnabled(enabled: WordBool);
begin
  DefaultInterface.Set_RpcHistoryEnabled(enabled);
end;

function  TSharedBrokerProperties.Get_PerClientRpcHistoryLimit: Integer;
begin
  Result := DefaultInterface.Get_PerClientRpcHistoryLimit;
end;

procedure TSharedBrokerProperties.Set_PerClientRpcHistoryLimit(limit: Integer);
begin
  DefaultInterface.Set_PerClientRpcHistoryLimit(limit);
end;

function  TSharedBrokerProperties.Get_CurrentContext: WideString;
begin
  Result := DefaultInterface.Get_CurrentContext;
end;

function  TSharedBrokerProperties.Get_User: WideString;
begin
  Result := DefaultInterface.Get_User;
end;

function  TSharedBrokerProperties.Get_Login: WideString;
begin
  Result := DefaultInterface.Get_Login;
end;

procedure TSharedBrokerProperties.Set_Login(const Value: WideString);
begin
  DefaultInterface.Set_Login(Value);
end;

function  TSharedBrokerProperties.Get_RpcbError: WideString;
begin
  Result := DefaultInterface.Get_RpcbError;
end;

function  TSharedBrokerProperties.Get_Socket: Integer;
begin
  Result := DefaultInterface.Get_Socket;
end;

function  TSharedBrokerProperties.Get_KernelLogin: WordBool;
begin
  Result := DefaultInterface.Get_KernelLogin;
end;

procedure TSharedBrokerProperties.Set_KernelLogin(Value: WordBool);
begin
  DefaultInterface.Set_KernelLogin(Value);
end;

function  TSharedBrokerProperties.Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs;
begin
  Result := DefaultInterface.Get_ShowErrorMsgs;
end;

procedure TSharedBrokerProperties.Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs);
begin
  DefaultInterface.Set_ShowErrorMsgs(Value);
end;

{$ENDIF}
{
procedure Register;
begin
  RegisterComponents('Kernel',[TSharedBroker]);
end;
}
end.

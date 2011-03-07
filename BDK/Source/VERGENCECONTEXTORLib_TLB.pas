unit VERGENCECONTEXTORLib_TLB;
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }


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
// File generated on 2/9/2004 9:12:53 AM from Type Library described below.

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
// Type Lib: D:\Development\BDK32_p40\Source\VergenceContextor.dll (1)
// IID\LCID: {30AFBABD-5FD3-11D3-8727-0060B0B5E137}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Hint: Member 'Set' of 'IResponseDialogAccessor' changed to 'Set_'
//   Error creating palette bitmap of (TContextor) : Invalid GUID format
//   Error creating palette bitmap of (TContextItemCollection) : Invalid GUID format
//   Error creating palette bitmap of (TContextItem) : Invalid GUID format
//   Error creating palette bitmap of (TResponseDialog) : Invalid GUID format
//   Error creating palette bitmap of (TContextorParticipant) : Invalid GUID format
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
  VERGENCECONTEXTORLibMajorVersion = 1;
  VERGENCECONTEXTORLibMinorVersion = 0;

  LIBID_VERGENCECONTEXTORLib: TGUID = '{30AFBABD-5FD3-11D3-8727-0060B0B5E137}';

  DIID__IContextChangesSink: TGUID = '{6BED8971-B3DD-11D3-8736-0060B0B5E137}';
  IID_IContextor: TGUID = '{8D879F5D-5FE6-11D3-8727-0060B0B5E137}';
  IID_IContextParticipant: TGUID = '{3E3DD272-998E-11D0-808D-00A0240943E4}';
  IID_IContextItemCollection: TGUID = '{AC4C0271-615A-11D3-84B5-0000861FDD4F}';
  IID_IContextItem: TGUID = '{AC4C0273-615A-11D3-84B5-0000861FDD4F}';
  IID_IResponseContextChange: TGUID = '{CBC6D968-9F6D-416A-8AA7-99172E588DF0}';
  IID_IResponseDialogAccessor: TGUID = '{86592071-F3BA-11D3-8181-005004A0F801}';
  IID_IContextChangesSink: TGUID = '{0B437E31-620E-11D3-84B6-0000861FDD4F}';
  IID_IResponseDialog: TGUID = '{9D33ECF1-8277-11D3-8525-0000861FDD4F}';
  CLASS_Contextor: TGUID = '{D5C9CC98-5FDB-11D3-8727-0060B0B5E137}';
  CLASS_ContextorControl: TGUID = '{8778ACF7-5CA9-11D3-8727-0060B0B5E137}';
  CLASS_ContextItemCollection: TGUID = '{AC4C0272-615A-11D3-84B5-0000861FDD4F}';
  CLASS_ContextItem: TGUID = '{AC4C0274-615A-11D3-84B5-0000861FDD4F}';
  CLASS_ResponseDialog: TGUID = '{9D33ECF2-8277-11D3-8525-0000861FDD4F}';
  IID_ISetHook: TGUID = '{8D879FDD-5FE6-11D3-8727-0060B0B5E137}';
  CLASS_ContextorParticipant: TGUID = '{4BA034A2-D0FA-11D3-818B-0050049598B2}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0000_0002
type
  __MIDL___MIDL_itf_VergenceContextor_0000_0002 = TOleEnum;
const
  CsNotRunning = $00000001;
  CsParticipating = $00000002;
  CsSuspended = $00000003;

// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0000_0001
type
  __MIDL___MIDL_itf_VergenceContextor_0000_0001 = TOleEnum;
const
  ApNone = $00000001;
  ApGet = $00000002;
  ApSet = $00000003;

// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0000_0003
type
  __MIDL___MIDL_itf_VergenceContextor_0000_0003 = TOleEnum;
const
  UrCommit = $00000001;
  UrCancel = $00000002;
  UrBreak = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IContextChangesSink = dispinterface;
  IContextor = interface;
  IContextorDisp = dispinterface;
  IContextParticipant = interface;
  IContextParticipantDisp = dispinterface;
  IContextItemCollection = interface;
  IContextItemCollectionDisp = dispinterface;
  IContextItem = interface;
  IContextItemDisp = dispinterface;
  IResponseContextChange = interface;
  IResponseContextChangeDisp = dispinterface;
  IResponseDialogAccessor = interface;
  IResponseDialogAccessorDisp = dispinterface;
  IContextChangesSink = interface;
  IContextChangesSinkDisp = dispinterface;
  IResponseDialog = interface;
  IResponseDialogDisp = dispinterface;
  ISetHook = interface;
  ISetHookDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Contextor = IContextor;
  ContextorControl = IContextor;
  ContextItemCollection = IContextItemCollection;
  ContextItem = IContextItem;
  ResponseDialog = IResponseDialog;
  ContextorParticipant = IContextParticipant;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  ContextorState = __MIDL___MIDL_itf_VergenceContextor_0000_0002; 
  AccessPrivilege = __MIDL___MIDL_itf_VergenceContextor_0000_0001; 
  UserResponse = __MIDL___MIDL_itf_VergenceContextor_0000_0003; 

// *********************************************************************//
// DispIntf:  _IContextChangesSink
// Flags:     (4096) Dispatchable
// GUID:      {6BED8971-B3DD-11D3-8736-0060B0B5E137}
// *********************************************************************//
  _IContextChangesSink = dispinterface
    ['{6BED8971-B3DD-11D3-8736-0060B0B5E137}']
    procedure Pending(const aContextItemCollection: IDispatch); dispid 1;
    procedure Committed; dispid 2;
    procedure Canceled; dispid 3;
  end;

// *********************************************************************//
// Interface: IContextor
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D879F5D-5FE6-11D3-8727-0060B0B5E137}
// *********************************************************************//
  IContextor = interface(IDispatch)
    ['{8D879F5D-5FE6-11D3-8727-0060B0B5E137}']
    procedure Run(const applicationLabel: WideString; const passcode: WideString; survey: WordBool; 
                  const initialNotificationFilter: WideString); safecall;
    procedure Suspend; safecall;
    procedure Resume; safecall;
    function  Get_State: ContextorState; safecall;
    function  GetPrivilege(const subj: WideString): AccessPrivilege; safecall;
    function  Get_CurrentContext: IContextItemCollection; safecall;
    procedure StartContextChange; safecall;
    function  EndContextChange(commit: WordBool; 
                               const aContextItemCollection: IContextItemCollection): UserResponse; safecall;
    procedure SetSurveyResponse(const reason: WideString); safecall;
    function  Get_NotificationFilter: WideString; safecall;
    procedure Set_NotificationFilter(const filter: WideString); safecall;
    function  Get_Name: WideString; safecall;
    property State: ContextorState read Get_State;
    property CurrentContext: IContextItemCollection read Get_CurrentContext;
    property NotificationFilter: WideString read Get_NotificationFilter write Set_NotificationFilter;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  IContextorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8D879F5D-5FE6-11D3-8727-0060B0B5E137}
// *********************************************************************//
  IContextorDisp = dispinterface
    ['{8D879F5D-5FE6-11D3-8727-0060B0B5E137}']
    procedure Run(const applicationLabel: WideString; const passcode: WideString; survey: WordBool; 
                  const initialNotificationFilter: WideString); dispid 1;
    procedure Suspend; dispid 2;
    procedure Resume; dispid 3;
    property State: ContextorState readonly dispid 4;
    function  GetPrivilege(const subj: WideString): AccessPrivilege; dispid 5;
    property CurrentContext: IContextItemCollection readonly dispid 6;
    procedure StartContextChange; dispid 7;
    function  EndContextChange(commit: WordBool; 
                               const aContextItemCollection: IContextItemCollection): UserResponse; dispid 8;
    procedure SetSurveyResponse(const reason: WideString); dispid 9;
    property NotificationFilter: WideString dispid 10;
    property Name: WideString readonly dispid 11;
  end;

// *********************************************************************//
// Interface: IContextParticipant
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E3DD272-998E-11D0-808D-00A0240943E4}
// *********************************************************************//
  IContextParticipant = interface(IDispatch)
    ['{3E3DD272-998E-11D0-808D-00A0240943E4}']
    function  ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString; safecall;
    procedure ContextChangesAccepted(contextCoupon: Integer); safecall;
    procedure ContextChangesCanceled(contextCoupon: Integer); safecall;
    procedure CommonContextTerminated; safecall;
    procedure Ping; safecall;
  end;

// *********************************************************************//
// DispIntf:  IContextParticipantDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E3DD272-998E-11D0-808D-00A0240943E4}
// *********************************************************************//
  IContextParticipantDisp = dispinterface
    ['{3E3DD272-998E-11D0-808D-00A0240943E4}']
    function  ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString; dispid 1610743808;
    procedure ContextChangesAccepted(contextCoupon: Integer); dispid 1610743809;
    procedure ContextChangesCanceled(contextCoupon: Integer); dispid 1610743810;
    procedure CommonContextTerminated; dispid 1610743811;
    procedure Ping; dispid 1610743812;
  end;

// *********************************************************************//
// Interface: IContextItemCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0271-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItemCollection = interface(IDispatch)
    ['{AC4C0271-615A-11D3-84B5-0000861FDD4F}']
    function  Count: Integer; safecall;
    procedure Add(const aContextItem: IContextItem); safecall;
    procedure Remove(const contextItemName: WideString); safecall;
    procedure RemoveAll; safecall;
    function  Present(key: OleVariant): IContextItem; safecall;
    function  Get__NewEnum: IUnknown; safecall;
    function  Item(key: OleVariant): IContextItem; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IContextItemCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0271-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItemCollectionDisp = dispinterface
    ['{AC4C0271-615A-11D3-84B5-0000861FDD4F}']
    function  Count: Integer; dispid 1;
    procedure Add(const aContextItem: IContextItem); dispid 2;
    procedure Remove(const contextItemName: WideString); dispid 3;
    procedure RemoveAll; dispid 4;
    function  Present(key: OleVariant): IContextItem; dispid 5;
    property _NewEnum: IUnknown readonly dispid -4;
    function  Item(key: OleVariant): IContextItem; dispid 0;
  end;

// *********************************************************************//
// Interface: IContextItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0273-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItem = interface(IDispatch)
    ['{AC4C0273-615A-11D3-84B5-0000861FDD4F}']
    function  Get_Subject: WideString; safecall;
    procedure Set_Subject(const pVal: WideString); safecall;
    function  Get_Role: WideString; safecall;
    procedure Set_Role(const pVal: WideString); safecall;
    function  Get_Prefix: WideString; safecall;
    procedure Set_Prefix(const pVal: WideString); safecall;
    function  Get_Suffix: WideString; safecall;
    procedure Set_Suffix(const pVal: WideString); safecall;
    function  Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function  Get_Value: WideString; safecall;
    procedure Set_Value(const pVal: WideString); safecall;
    function  Clone: IContextItem; safecall;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Role: WideString read Get_Role write Set_Role;
    property Prefix: WideString read Get_Prefix write Set_Prefix;
    property Suffix: WideString read Get_Suffix write Set_Suffix;
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  end;

// *********************************************************************//
// DispIntf:  IContextItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0273-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItemDisp = dispinterface
    ['{AC4C0273-615A-11D3-84B5-0000861FDD4F}']
    property Subject: WideString dispid 1;
    property Role: WideString dispid 2;
    property Prefix: WideString dispid 3;
    property Suffix: WideString dispid 4;
    property Name: WideString dispid 5;
    property Value: WideString dispid 6;
    function  Clone: IContextItem; dispid 7;
  end;

// *********************************************************************//
// Interface: IResponseContextChange
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CBC6D968-9F6D-416A-8AA7-99172E588DF0}
// *********************************************************************//
  IResponseContextChange = interface(IDispatch)
    ['{CBC6D968-9F6D-416A-8AA7-99172E588DF0}']
    procedure StartResponseContextChange; safecall;
    function  EndResponseContextChange(commit: WordBool; 
                                       const aContextItemCollection: IContextItemCollection; 
                                       var noContinue: WordBool): OleVariant; safecall;
    procedure CommitContextChange; safecall;
    procedure CancelContextChange; safecall;
  end;

// *********************************************************************//
// DispIntf:  IResponseContextChangeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CBC6D968-9F6D-416A-8AA7-99172E588DF0}
// *********************************************************************//
  IResponseContextChangeDisp = dispinterface
    ['{CBC6D968-9F6D-416A-8AA7-99172E588DF0}']
    procedure StartResponseContextChange; dispid 1;
    function  EndResponseContextChange(commit: WordBool; 
                                       const aContextItemCollection: IContextItemCollection; 
                                       var noContinue: WordBool): OleVariant; dispid 2;
    procedure CommitContextChange; dispid 3;
    procedure CancelContextChange; dispid 4;
  end;

// *********************************************************************//
// Interface: IResponseDialogAccessor
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {86592071-F3BA-11D3-8181-005004A0F801}
// *********************************************************************//
  IResponseDialogAccessor = interface(IDispatch)
    ['{86592071-F3BA-11D3-8181-005004A0F801}']
    procedure Reset; safecall;
    procedure Set_(const aResponseDialog: IResponseDialog); safecall;
  end;

// *********************************************************************//
// DispIntf:  IResponseDialogAccessorDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {86592071-F3BA-11D3-8181-005004A0F801}
// *********************************************************************//
  IResponseDialogAccessorDisp = dispinterface
    ['{86592071-F3BA-11D3-8181-005004A0F801}']
    procedure Reset; dispid 1;
    procedure Set_(const aResponseDialog: IResponseDialog); dispid 2;
  end;

// *********************************************************************//
// Interface: IContextChangesSink
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B437E31-620E-11D3-84B6-0000861FDD4F}
// *********************************************************************//
  IContextChangesSink = interface(IDispatch)
    ['{0B437E31-620E-11D3-84B6-0000861FDD4F}']
    procedure Pending(const aContextItemCollection: IDispatch); safecall;
    procedure Committed; safecall;
    procedure Canceled; safecall;
  end;

// *********************************************************************//
// DispIntf:  IContextChangesSinkDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0B437E31-620E-11D3-84B6-0000861FDD4F}
// *********************************************************************//
  IContextChangesSinkDisp = dispinterface
    ['{0B437E31-620E-11D3-84B6-0000861FDD4F}']
    procedure Pending(const aContextItemCollection: IDispatch); dispid 1;
    procedure Committed; dispid 2;
    procedure Canceled; dispid 3;
  end;

// *********************************************************************//
// Interface: IResponseDialog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD4F}
// *********************************************************************//
  IResponseDialog = interface(IDispatch)
    ['{9D33ECF1-8277-11D3-8525-0000861FDD4F}']
    function  ProcessSurveyResults(responses: OleVariant; noContinue: WordBool): UserResponse; safecall;
  end;

// *********************************************************************//
// DispIntf:  IResponseDialogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD4F}
// *********************************************************************//
  IResponseDialogDisp = dispinterface
    ['{9D33ECF1-8277-11D3-8525-0000861FDD4F}']
    function  ProcessSurveyResults(responses: OleVariant; noContinue: WordBool): UserResponse; dispid 1;
  end;

// *********************************************************************//
// Interface: ISetHook
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {8D879FDD-5FE6-11D3-8727-0060B0B5E137}
// *********************************************************************//
  ISetHook = interface(IDispatch)
    ['{8D879FDD-5FE6-11D3-8727-0060B0B5E137}']
    procedure SetParticipant(const aContextParticipant: IContextParticipant); safecall;
  end;

// *********************************************************************//
// DispIntf:  ISetHookDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {8D879FDD-5FE6-11D3-8727-0060B0B5E137}
// *********************************************************************//
  ISetHookDisp = dispinterface
    ['{8D879FDD-5FE6-11D3-8727-0060B0B5E137}']
    procedure SetParticipant(const aContextParticipant: IContextParticipant); dispid 1;
  end;

// *********************************************************************//
// The Class CoContextor provides a Create and CreateRemote method to          
// create instances of the default interface IContextor exposed by              
// the CoClass Contextor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoContextor = class
    class function Create: IContextor;
    class function CreateRemote(const MachineName: string): IContextor;
  end;

  TContextorPending = procedure(Sender: TObject; var aContextItemCollection: OleVariant) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TContextor
// Help String      : Vergence Contextor
// Default Interface: IContextor
// Def. Intf. DISP? : No
// Event   Interface: _IContextChangesSink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TContextorProperties= class;
{$ENDIF}
  TContextor = class(TOleServer)
  private
    FOnPending: TContextorPending;
    FOnCommitted: TNotifyEvent;
    FOnCanceled: TNotifyEvent;
    FIntf:        IContextor;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TContextorProperties;
    function      GetServerProperties: TContextorProperties;
{$ENDIF}
    function      GetDefaultInterface: IContextor;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function  Get_State: ContextorState;
    function  Get_CurrentContext: IContextItemCollection;
    function  Get_NotificationFilter: WideString;
    procedure Set_NotificationFilter(const filter: WideString);
    function  Get_Name: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextor);
    procedure Disconnect; override;
    procedure Run(const applicationLabel: WideString; const passcode: WideString; survey: WordBool; 
                  const initialNotificationFilter: WideString);
    procedure Suspend;
    procedure Resume;
    function  GetPrivilege(const subj: WideString): AccessPrivilege;
    procedure StartContextChange;
    function  EndContextChange(commit: WordBool; 
                               const aContextItemCollection: IContextItemCollection): UserResponse;
    procedure SetSurveyResponse(const reason: WideString);
    property  DefaultInterface: IContextor read GetDefaultInterface;
    property State: ContextorState read Get_State;
    property CurrentContext: IContextItemCollection read Get_CurrentContext;
    property Name: WideString read Get_Name;
    property NotificationFilter: WideString read Get_NotificationFilter write Set_NotificationFilter;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TContextorProperties read GetServerProperties;
{$ENDIF}
    property OnPending: TContextorPending read FOnPending write FOnPending;
    property OnCommitted: TNotifyEvent read FOnCommitted write FOnCommitted;
    property OnCanceled: TNotifyEvent read FOnCanceled write FOnCanceled;
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TContextor
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TContextorProperties = class(TPersistent)
  private
    FServer:    TContextor;
    function    GetDefaultInterface: IContextor;
    constructor Create(AServer: TContextor);
  protected
    function  Get_State: ContextorState;
    function  Get_CurrentContext: IContextItemCollection;
    function  Get_NotificationFilter: WideString;
    procedure Set_NotificationFilter(const filter: WideString);
    function  Get_Name: WideString;
  public
    property DefaultInterface: IContextor read GetDefaultInterface;
  published
    property NotificationFilter: WideString read Get_NotificationFilter write Set_NotificationFilter;
  end;
{$ENDIF}



// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TContextorControl
// Help String      : Vergence ContextorControl
// Default Interface: IContextor
// Def. Intf. DISP? : No
// Event   Interface: _IContextChangesSink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TContextorControlPending = procedure(Sender: TObject; const aContextItemCollection: IDispatch) of object;

  TContextorControl = class(TOleControl)
  private
    FOnPending: TContextorControlPending;
    FOnCommitted: TNotifyEvent;
    FOnCanceled: TNotifyEvent;
    FIntf: IContextor;
    function  GetControlInterface: IContextor;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function  Get_CurrentContext: IContextItemCollection;
  public
    procedure Run(const applicationLabel: WideString; const passcode: WideString; survey: WordBool; 
                  const initialNotificationFilter: WideString);
    procedure Suspend;
    procedure Resume;
    function  GetPrivilege(const subj: WideString): AccessPrivilege;
    procedure StartContextChange;
    function  EndContextChange(commit: WordBool; 
                               const aContextItemCollection: IContextItemCollection): UserResponse;
    procedure SetSurveyResponse(const reason: WideString);
    property  ControlInterface: IContextor read GetControlInterface;
    property  DefaultInterface: IContextor read GetControlInterface;
    property State: TOleEnum index 4 read GetTOleEnumProp;
    property CurrentContext: IContextItemCollection read Get_CurrentContext;
    property Name: WideString index 11 read GetWideStringProp;
  published
    property NotificationFilter: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property OnPending: TContextorControlPending read FOnPending write FOnPending;
    property OnCommitted: TNotifyEvent read FOnCommitted write FOnCommitted;
    property OnCanceled: TNotifyEvent read FOnCanceled write FOnCanceled;
  end;

// *********************************************************************//
// The Class CoContextItemCollection provides a Create and CreateRemote method to          
// create instances of the default interface IContextItemCollection exposed by              
// the CoClass ContextItemCollection. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoContextItemCollection = class
    class function Create: IContextItemCollection;
    class function CreateRemote(const MachineName: string): IContextItemCollection;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TContextItemCollection
// Help String      : Vergence ContextItemCollection
// Default Interface: IContextItemCollection
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TContextItemCollectionProperties= class;
{$ENDIF}
  TContextItemCollection = class(TOleServer)
  private
    FIntf:        IContextItemCollection;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TContextItemCollectionProperties;
    function      GetServerProperties: TContextItemCollectionProperties;
{$ENDIF}
    function      GetDefaultInterface: IContextItemCollection;
  protected
    procedure InitServerData; override;
    function  Get__NewEnum: IUnknown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextItemCollection);
    procedure Disconnect; override;
    function  Count: Integer;
    procedure Add(const aContextItem: IContextItem);
    procedure Remove(const contextItemName: WideString);
    procedure RemoveAll;
    function  Present(key: OleVariant): IContextItem;
    function  Item(key: OleVariant): IContextItem;
    property  DefaultInterface: IContextItemCollection read GetDefaultInterface;
    property _NewEnum: IUnknown read Get__NewEnum;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TContextItemCollectionProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TContextItemCollection
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TContextItemCollectionProperties = class(TPersistent)
  private
    FServer:    TContextItemCollection;
    function    GetDefaultInterface: IContextItemCollection;
    constructor Create(AServer: TContextItemCollection);
  protected
    function  Get__NewEnum: IUnknown;
  public
    property DefaultInterface: IContextItemCollection read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoContextItem provides a Create and CreateRemote method to          
// create instances of the default interface IContextItem exposed by              
// the CoClass ContextItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoContextItem = class
    class function Create: IContextItem;
    class function CreateRemote(const MachineName: string): IContextItem;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TContextItem
// Help String      : Vergence ContextItem
// Default Interface: IContextItem
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TContextItemProperties= class;
{$ENDIF}
  TContextItem = class(TOleServer)
  private
    FIntf:        IContextItem;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TContextItemProperties;
    function      GetServerProperties: TContextItemProperties;
{$ENDIF}
    function      GetDefaultInterface: IContextItem;
  protected
    procedure InitServerData; override;
    function  Get_Subject: WideString;
    procedure Set_Subject(const pVal: WideString);
    function  Get_Role: WideString;
    procedure Set_Role(const pVal: WideString);
    function  Get_Prefix: WideString;
    procedure Set_Prefix(const pVal: WideString);
    function  Get_Suffix: WideString;
    procedure Set_Suffix(const pVal: WideString);
    function  Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function  Get_Value: WideString;
    procedure Set_Value(const pVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextItem);
    procedure Disconnect; override;
    function  Clone: IContextItem;
    property  DefaultInterface: IContextItem read GetDefaultInterface;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Role: WideString read Get_Role write Set_Role;
    property Prefix: WideString read Get_Prefix write Set_Prefix;
    property Suffix: WideString read Get_Suffix write Set_Suffix;
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TContextItemProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TContextItem
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TContextItemProperties = class(TPersistent)
  private
    FServer:    TContextItem;
    function    GetDefaultInterface: IContextItem;
    constructor Create(AServer: TContextItem);
  protected
    function  Get_Subject: WideString;
    procedure Set_Subject(const pVal: WideString);
    function  Get_Role: WideString;
    procedure Set_Role(const pVal: WideString);
    function  Get_Prefix: WideString;
    procedure Set_Prefix(const pVal: WideString);
    function  Get_Suffix: WideString;
    procedure Set_Suffix(const pVal: WideString);
    function  Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function  Get_Value: WideString;
    procedure Set_Value(const pVal: WideString);
  public
    property DefaultInterface: IContextItem read GetDefaultInterface;
  published
    property Subject: WideString read Get_Subject write Set_Subject;
    property Role: WideString read Get_Role write Set_Role;
    property Prefix: WideString read Get_Prefix write Set_Prefix;
    property Suffix: WideString read Get_Suffix write Set_Suffix;
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoResponseDialog provides a Create and CreateRemote method to          
// create instances of the default interface IResponseDialog exposed by              
// the CoClass ResponseDialog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoResponseDialog = class
    class function Create: IResponseDialog;
    class function CreateRemote(const MachineName: string): IResponseDialog;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TResponseDialog
// Help String      : Vergence ResponseDialog
// Default Interface: IResponseDialog
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TResponseDialogProperties= class;
{$ENDIF}
  TResponseDialog = class(TOleServer)
  private
    FIntf:        IResponseDialog;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TResponseDialogProperties;
    function      GetServerProperties: TResponseDialogProperties;
{$ENDIF}
    function      GetDefaultInterface: IResponseDialog;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IResponseDialog);
    procedure Disconnect; override;
    function  ProcessSurveyResults(responses: OleVariant; noContinue: WordBool): UserResponse;
    property  DefaultInterface: IResponseDialog read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TResponseDialogProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TResponseDialog
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TResponseDialogProperties = class(TPersistent)
  private
    FServer:    TResponseDialog;
    function    GetDefaultInterface: IResponseDialog;
    constructor Create(AServer: TResponseDialog);
  protected
  public
    property DefaultInterface: IResponseDialog read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoContextorParticipant provides a Create and CreateRemote method to          
// create instances of the default interface IContextParticipant exposed by              
// the CoClass ContextorParticipant. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoContextorParticipant = class
    class function Create: IContextParticipant;
    class function CreateRemote(const MachineName: string): IContextParticipant;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TContextorParticipant
// Help String      : ContextorParticipant Class
// Default Interface: IContextParticipant
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TContextorParticipantProperties= class;
{$ENDIF}
  TContextorParticipant = class(TOleServer)
  private
    FIntf:        IContextParticipant;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TContextorParticipantProperties;
    function      GetServerProperties: TContextorParticipantProperties;
{$ENDIF}
    function      GetDefaultInterface: IContextParticipant;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextParticipant);
    procedure Disconnect; override;
    function  ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString;
    procedure ContextChangesAccepted(contextCoupon: Integer);
    procedure ContextChangesCanceled(contextCoupon: Integer);
    procedure CommonContextTerminated;
    procedure Ping;
    property  DefaultInterface: IContextParticipant read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TContextorParticipantProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TContextorParticipant
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TContextorParticipantProperties = class(TPersistent)
  private
    FServer:    TContextorParticipant;
    function    GetDefaultInterface: IContextParticipant;
    constructor Create(AServer: TContextorParticipant);
  protected
  public
    property DefaultInterface: IContextParticipant read GetDefaultInterface;
  published
  end;
{$ENDIF}

{
procedure Register;
}
implementation

uses ComObj;

class function CoContextor.Create: IContextor;
begin
  Result := CreateComObject(CLASS_Contextor) as IContextor;
end;

class function CoContextor.CreateRemote(const MachineName: string): IContextor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Contextor) as IContextor;
end;

procedure TContextor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D5C9CC98-5FDB-11D3-8727-0060B0B5E137}';
    IntfIID:   '{8D879F5D-5FE6-11D3-8727-0060B0B5E137}';
    EventIID:  '{6BED8971-B3DD-11D3-8736-0060B0B5E137}';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TContextor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    ConnectEvents(punk);
    Fintf:= punk as IContextor;
  end;
end;

procedure TContextor.ConnectTo(svrIntf: IContextor);
begin
  Disconnect;
  FIntf := svrIntf;
  ConnectEvents(FIntf);
end;

procedure TContextor.DisConnect;
begin
  if Fintf <> nil then
  begin
    DisconnectEvents(FIntf);
    FIntf := nil;
  end;
end;

function TContextor.GetDefaultInterface: IContextor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TContextor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TContextorProperties.Create(Self);
{$ENDIF}
end;

destructor TContextor.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TContextor.GetServerProperties: TContextorProperties;
begin
  Result := FProps;
end;
{$ENDIF}

procedure TContextor.InvokeEvent(DispID: TDispID; var Params: TVariantArray);
begin
  case DispID of
    -1: Exit;  // DISPID_UNKNOWN
   1: if Assigned(FOnPending) then
            FOnPending(Self, Params[0] {const IDispatch});
   2: if Assigned(FOnCommitted) then
            FOnCommitted(Self);
   3: if Assigned(FOnCanceled) then
            FOnCanceled(Self);
  end; {case DispID}
end;

function  TContextor.Get_State: ContextorState;
begin
  Result := DefaultInterface.Get_State;
end;

function  TContextor.Get_CurrentContext: IContextItemCollection;
begin
  Result := DefaultInterface.Get_CurrentContext;
end;

function  TContextor.Get_NotificationFilter: WideString;
begin
  Result := DefaultInterface.Get_NotificationFilter;
end;

procedure TContextor.Set_NotificationFilter(const filter: WideString);
begin
  DefaultInterface.Set_NotificationFilter(filter);
end;

function  TContextor.Get_Name: WideString;
begin
  Result := DefaultInterface.Get_Name;
end;

procedure TContextor.Run(const applicationLabel: WideString; const passcode: WideString; 
                         survey: WordBool; const initialNotificationFilter: WideString);
begin
  DefaultInterface.Run(applicationLabel, passcode, survey, initialNotificationFilter);
end;

procedure TContextor.Suspend;
begin
  DefaultInterface.Suspend;
end;

procedure TContextor.Resume;
begin
  DefaultInterface.Resume;
end;

function  TContextor.GetPrivilege(const subj: WideString): AccessPrivilege;
begin
  Result := DefaultInterface.GetPrivilege(subj);
end;

procedure TContextor.StartContextChange;
begin
  DefaultInterface.StartContextChange;
end;

function  TContextor.EndContextChange(commit: WordBool; 
                                      const aContextItemCollection: IContextItemCollection): UserResponse;
begin
  Result := DefaultInterface.EndContextChange(commit, aContextItemCollection);
end;

procedure TContextor.SetSurveyResponse(const reason: WideString);
begin
  DefaultInterface.SetSurveyResponse(reason);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TContextorProperties.Create(AServer: TContextor);
begin
  inherited Create;
  FServer := AServer;
end;

function TContextorProperties.GetDefaultInterface: IContextor;
begin
  Result := FServer.DefaultInterface;
end;

function  TContextorProperties.Get_State: ContextorState;
begin
  Result := DefaultInterface.Get_State;
end;

function  TContextorProperties.Get_CurrentContext: IContextItemCollection;
begin
  Result := DefaultInterface.Get_CurrentContext;
end;

function  TContextorProperties.Get_NotificationFilter: WideString;
begin
  Result := DefaultInterface.Get_NotificationFilter;
end;

procedure TContextorProperties.Set_NotificationFilter(const filter: WideString);
begin
  DefaultInterface.Set_NotificationFilter(filter);
end;

function  TContextorProperties.Get_Name: WideString;
begin
  Result := DefaultInterface.Get_Name;
end;

{$ENDIF}

procedure TContextorControl.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID: '{8778ACF7-5CA9-11D3-8727-0060B0B5E137}';
    EventIID: '{6BED8971-B3DD-11D3-8736-0060B0B5E137}';
    EventCount: 3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
//  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnPending) - Cardinal(Self);
end;

procedure TContextorControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IContextor;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TContextorControl.GetControlInterface: IContextor;
begin
  CreateControl;
  Result := FIntf;
end;

function  TContextorControl.Get_CurrentContext: IContextItemCollection;
begin
  Result := DefaultInterface.Get_CurrentContext;
end;

procedure TContextorControl.Run(const applicationLabel: WideString; const passcode: WideString; 
                                survey: WordBool; const initialNotificationFilter: WideString);
begin
  DefaultInterface.Run(applicationLabel, passcode, survey, initialNotificationFilter);
end;

procedure TContextorControl.Suspend;
begin
  DefaultInterface.Suspend;
end;

procedure TContextorControl.Resume;
begin
  DefaultInterface.Resume;
end;

function  TContextorControl.GetPrivilege(const subj: WideString): AccessPrivilege;
begin
  Result := DefaultInterface.GetPrivilege(subj);
end;

procedure TContextorControl.StartContextChange;
begin
  DefaultInterface.StartContextChange;
end;

function  TContextorControl.EndContextChange(commit: WordBool; 
                                             const aContextItemCollection: IContextItemCollection): UserResponse;
begin
  Result := DefaultInterface.EndContextChange(commit, aContextItemCollection);
end;

procedure TContextorControl.SetSurveyResponse(const reason: WideString);
begin
  DefaultInterface.SetSurveyResponse(reason);
end;

class function CoContextItemCollection.Create: IContextItemCollection;
begin
  Result := CreateComObject(CLASS_ContextItemCollection) as IContextItemCollection;
end;

class function CoContextItemCollection.CreateRemote(const MachineName: string): IContextItemCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ContextItemCollection) as IContextItemCollection;
end;

procedure TContextItemCollection.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AC4C0272-615A-11D3-84B5-0000861FDD4F}';
    IntfIID:   '{AC4C0271-615A-11D3-84B5-0000861FDD4F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TContextItemCollection.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IContextItemCollection;
  end;
end;

procedure TContextItemCollection.ConnectTo(svrIntf: IContextItemCollection);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TContextItemCollection.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TContextItemCollection.GetDefaultInterface: IContextItemCollection;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TContextItemCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TContextItemCollectionProperties.Create(Self);
{$ENDIF}
end;

destructor TContextItemCollection.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TContextItemCollection.GetServerProperties: TContextItemCollectionProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TContextItemCollection.Get__NewEnum: IUnknown;
begin
  Result := DefaultInterface.Get__NewEnum;
end;

function  TContextItemCollection.Count: Integer;
begin
  Result := DefaultInterface.Count;
end;

procedure TContextItemCollection.Add(const aContextItem: IContextItem);
begin
  DefaultInterface.Add(aContextItem);
end;

procedure TContextItemCollection.Remove(const contextItemName: WideString);
begin
  DefaultInterface.Remove(contextItemName);
end;

procedure TContextItemCollection.RemoveAll;
begin
  DefaultInterface.RemoveAll;
end;

function  TContextItemCollection.Present(key: OleVariant): IContextItem;
begin
  Result := DefaultInterface.Present(key);
end;

function  TContextItemCollection.Item(key: OleVariant): IContextItem;
begin
  Result := DefaultInterface.Item(key);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TContextItemCollectionProperties.Create(AServer: TContextItemCollection);
begin
  inherited Create;
  FServer := AServer;
end;

function TContextItemCollectionProperties.GetDefaultInterface: IContextItemCollection;
begin
  Result := FServer.DefaultInterface;
end;

function  TContextItemCollectionProperties.Get__NewEnum: IUnknown;
begin
  Result := DefaultInterface.Get__NewEnum;
end;

{$ENDIF}

class function CoContextItem.Create: IContextItem;
begin
  Result := CreateComObject(CLASS_ContextItem) as IContextItem;
end;

class function CoContextItem.CreateRemote(const MachineName: string): IContextItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ContextItem) as IContextItem;
end;

procedure TContextItem.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{AC4C0274-615A-11D3-84B5-0000861FDD4F}';
    IntfIID:   '{AC4C0273-615A-11D3-84B5-0000861FDD4F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TContextItem.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IContextItem;
  end;
end;

procedure TContextItem.ConnectTo(svrIntf: IContextItem);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TContextItem.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TContextItem.GetDefaultInterface: IContextItem;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TContextItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TContextItemProperties.Create(Self);
{$ENDIF}
end;

destructor TContextItem.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TContextItem.GetServerProperties: TContextItemProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TContextItem.Get_Subject: WideString;
begin
  Result := DefaultInterface.Get_Subject;
end;

procedure TContextItem.Set_Subject(const pVal: WideString);
begin
  DefaultInterface.Set_Subject(pVal);
end;

function  TContextItem.Get_Role: WideString;
begin
  Result := DefaultInterface.Get_Role;
end;

procedure TContextItem.Set_Role(const pVal: WideString);
begin
  DefaultInterface.Set_Role(pVal);
end;

function  TContextItem.Get_Prefix: WideString;
begin
  Result := DefaultInterface.Get_Prefix;
end;

procedure TContextItem.Set_Prefix(const pVal: WideString);
begin
  DefaultInterface.Set_Prefix(pVal);
end;

function  TContextItem.Get_Suffix: WideString;
begin
  Result := DefaultInterface.Get_Suffix;
end;

procedure TContextItem.Set_Suffix(const pVal: WideString);
begin
  DefaultInterface.Set_Suffix(pVal);
end;

function  TContextItem.Get_Name: WideString;
begin
  Result := DefaultInterface.Get_Name;
end;

procedure TContextItem.Set_Name(const pVal: WideString);
begin
  DefaultInterface.Set_Name(pVal);
end;

function  TContextItem.Get_Value: WideString;
begin
  Result := DefaultInterface.Get_Value;
end;

procedure TContextItem.Set_Value(const pVal: WideString);
begin
  DefaultInterface.Set_Value(pVal);
end;

function  TContextItem.Clone: IContextItem;
begin
  Result := DefaultInterface.Clone;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TContextItemProperties.Create(AServer: TContextItem);
begin
  inherited Create;
  FServer := AServer;
end;

function TContextItemProperties.GetDefaultInterface: IContextItem;
begin
  Result := FServer.DefaultInterface;
end;

function  TContextItemProperties.Get_Subject: WideString;
begin
  Result := DefaultInterface.Get_Subject;
end;

procedure TContextItemProperties.Set_Subject(const pVal: WideString);
begin
  DefaultInterface.Set_Subject(pVal);
end;

function  TContextItemProperties.Get_Role: WideString;
begin
  Result := DefaultInterface.Get_Role;
end;

procedure TContextItemProperties.Set_Role(const pVal: WideString);
begin
  DefaultInterface.Set_Role(pVal);
end;

function  TContextItemProperties.Get_Prefix: WideString;
begin
  Result := DefaultInterface.Get_Prefix;
end;

procedure TContextItemProperties.Set_Prefix(const pVal: WideString);
begin
  DefaultInterface.Set_Prefix(pVal);
end;

function  TContextItemProperties.Get_Suffix: WideString;
begin
  Result := DefaultInterface.Get_Suffix;
end;

procedure TContextItemProperties.Set_Suffix(const pVal: WideString);
begin
  DefaultInterface.Set_Suffix(pVal);
end;

function  TContextItemProperties.Get_Name: WideString;
begin
  Result := DefaultInterface.Get_Name;
end;

procedure TContextItemProperties.Set_Name(const pVal: WideString);
begin
  DefaultInterface.Set_Name(pVal);
end;

function  TContextItemProperties.Get_Value: WideString;
begin
  Result := DefaultInterface.Get_Value;
end;

procedure TContextItemProperties.Set_Value(const pVal: WideString);
begin
  DefaultInterface.Set_Value(pVal);
end;

{$ENDIF}

class function CoResponseDialog.Create: IResponseDialog;
begin
  Result := CreateComObject(CLASS_ResponseDialog) as IResponseDialog;
end;

class function CoResponseDialog.CreateRemote(const MachineName: string): IResponseDialog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ResponseDialog) as IResponseDialog;
end;

procedure TResponseDialog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9D33ECF2-8277-11D3-8525-0000861FDD4F}';
    IntfIID:   '{9D33ECF1-8277-11D3-8525-0000861FDD4F}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TResponseDialog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IResponseDialog;
  end;
end;

procedure TResponseDialog.ConnectTo(svrIntf: IResponseDialog);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TResponseDialog.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TResponseDialog.GetDefaultInterface: IResponseDialog;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TResponseDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TResponseDialogProperties.Create(Self);
{$ENDIF}
end;

destructor TResponseDialog.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TResponseDialog.GetServerProperties: TResponseDialogProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TResponseDialog.ProcessSurveyResults(responses: OleVariant; noContinue: WordBool): UserResponse;
begin
  Result := DefaultInterface.ProcessSurveyResults(responses, noContinue);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TResponseDialogProperties.Create(AServer: TResponseDialog);
begin
  inherited Create;
  FServer := AServer;
end;

function TResponseDialogProperties.GetDefaultInterface: IResponseDialog;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoContextorParticipant.Create: IContextParticipant;
begin
  Result := CreateComObject(CLASS_ContextorParticipant) as IContextParticipant;
end;

class function CoContextorParticipant.CreateRemote(const MachineName: string): IContextParticipant;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ContextorParticipant) as IContextParticipant;
end;

procedure TContextorParticipant.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{4BA034A2-D0FA-11D3-818B-0050049598B2}';
    IntfIID:   '{3E3DD272-998E-11D0-808D-00A0240943E4}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TContextorParticipant.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IContextParticipant;
  end;
end;

procedure TContextorParticipant.ConnectTo(svrIntf: IContextParticipant);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TContextorParticipant.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TContextorParticipant.GetDefaultInterface: IContextParticipant;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TContextorParticipant.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TContextorParticipantProperties.Create(Self);
{$ENDIF}
end;

destructor TContextorParticipant.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TContextorParticipant.GetServerProperties: TContextorParticipantProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TContextorParticipant.ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString;
begin
  Result := DefaultInterface.ContextChangesPending(contextCoupon, reason);
end;

procedure TContextorParticipant.ContextChangesAccepted(contextCoupon: Integer);
begin
  DefaultInterface.ContextChangesAccepted(contextCoupon);
end;

procedure TContextorParticipant.ContextChangesCanceled(contextCoupon: Integer);
begin
  DefaultInterface.ContextChangesCanceled(contextCoupon);
end;

procedure TContextorParticipant.CommonContextTerminated;
begin
  DefaultInterface.CommonContextTerminated;
end;

procedure TContextorParticipant.Ping;
begin
  DefaultInterface.Ping;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TContextorParticipantProperties.Create(AServer: TContextorParticipant);
begin
  inherited Create;
  FServer := AServer;
end;

function TContextorParticipantProperties.GetDefaultInterface: IContextParticipant;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}
{
procedure Register;
begin
  RegisterComponents('Kernel',[TContextorControl]);
  RegisterComponents('Kernel',[TContextor, TContextItemCollection, TContextItem, TResponseDialog,
    TContextorParticipant]);
end;
}
end.

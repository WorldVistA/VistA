unit VERGENCECONTEXTORLib_TLB;

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

// $Rev: 52393 $
// File generated on 3/13/2017 2:24:31 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\SysWOW64\VergenceContextor.dll (1)
// LIBID: {30AFBABD-5FD3-11D3-8727-0060B0B5E137}
// LCID: 0
// Helpfile: 
// HelpString: Sentillion Vergence Contextor 1.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// Errors:
//   Hint: Member 'Set' of 'IResponseDialogAccessor' changed to 'Set_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleCtrls, Vcl.OleServer, Winapi.ActiveX;
  


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
  IID_IWebSecure: TGUID = '{1A6D9D3D-B36F-42CB-BB0D-1BCB06C6F996}';
  IID_IResponseDialog: TGUID = '{9D33ECF1-8277-11D3-8525-0000861FDD4F}';
  IID_IContextorDialog: TGUID = '{F4D14825-367F-43DB-BF69-1B4440A043A8}';
  IID_IBridge: TGUID = '{78280F9B-0AF5-4786-BD2A-78845C9164D7}';
  IID_IBridge2: TGUID = '{C3BEA4FD-041C-4A08-AC56-0F0129C254A0}';
  IID_IContextChangesSink: TGUID = '{0B437E31-620E-11D3-84B6-0000861FDD4F}';
  CLASS_Contextor: TGUID = '{D5C9CC98-5FDB-11D3-8727-0060B0B5E137}';
  CLASS_ContextorControl: TGUID = '{8778ACF7-5CA9-11D3-8727-0060B0B5E137}';
  CLASS_ContextItemCollection: TGUID = '{AC4C0272-615A-11D3-84B5-0000861FDD4F}';
  CLASS_ContextItem: TGUID = '{AC4C0274-615A-11D3-84B5-0000861FDD4F}';
  CLASS_ResponseDialog: TGUID = '{9D33ECF2-8277-11D3-8525-0000861FDD4F}';
  IID_IPasswordDialog: TGUID = '{9D33ECF1-8277-11D3-8525-0000861FDD5E}';
  CLASS_PasswordDialog: TGUID = '{9D33ECF2-8277-11D3-8525-0000861FDD5E}';
  IID_ISetHook: TGUID = '{8D879FDD-5FE6-11D3-8727-0060B0B5E137}';
  CLASS_ContextorParticipant: TGUID = '{4BA034A2-D0FA-11D3-818B-0050049598B2}';
  IID_IDispatchAccessor: TGUID = '{C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}';
  CLASS_DispatchAccessor: TGUID = '{5F9C5135-FA94-4091-B1A9-B55294259118}';

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

// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0225_0001
type
  __MIDL___MIDL_itf_VergenceContextor_0225_0001 = TOleEnum;
const
  BRIDGE_LOG_TYPE_ALL = $00000000;
  BRIDGE_LOG_TYPE_AUDIT = $00000001;
  BRIDGE_LOG_TYPE_FINEST = $00000002;
  BRIDGE_LOG_TYPE_FINER = $00000003;
  BRIDGE_LOG_TYPE_FINE = $00000004;
  BRIDGE_LOG_TYPE_CONFIG = $00000005;
  BRIDGE_LOG_TYPE_INFO = $00000006;
  BRIDGE_LOG_TYPE_PROTOCOL_ERR = $00000007;
  BRIDGE_LOG_TYPE_WARNING = $00000008;
  BRIDGE_LOG_TYPE_SEVERE = $00000009;
  BRIDGE_LOG_TYPE_OFF = $0000000A;

// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0226_0002
type
  __MIDL___MIDL_itf_VergenceContextor_0226_0002 = TOleEnum;
const
  VERGENCE_OK_BUTTON = $00000001;
  VERGENCE_CANCEL_BUTTON = $00000002;
  VERGENCE_BREAK_LINK_BUTTON = $00000004;

// Constants for enum __MIDL___MIDL_itf_VergenceContextor_0226_0004
type
  __MIDL___MIDL_itf_VergenceContextor_0226_0004 = TOleEnum;
const
  CUSTOM_TEXT = $00000000;
  PASSWORD_DOES_NOT_EXIST = $00000001;
  PASSWORD_INCORRECT = $00000002;
  PASSWORD_EXPIRED = $00000003;
  PASSWORD_USER_CHANGE = $00000004;
  PASSWORD_LEARNING_LOGON_FAILED = $00000005;
  ACQUIRE_CREDENTIALS = $00000010;
  ACQUIRE_CREDENTIALS_LOGON_FAILED = $00000020;

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
  IWebSecure = interface;
  IWebSecureDisp = dispinterface;
  IResponseDialog = interface;
  IResponseDialogDisp = dispinterface;
  IContextorDialog = interface;
  IContextorDialogDisp = dispinterface;
  IBridge = interface;
  IBridgeDisp = dispinterface;
  IBridge2 = interface;
  IBridge2Disp = dispinterface;
  IContextChangesSink = interface;
  IContextChangesSinkDisp = dispinterface;
  IPasswordDialog = interface;
  IPasswordDialogDisp = dispinterface;
  ISetHook = interface;
  ISetHookDisp = dispinterface;
  IDispatchAccessor = interface;
  IDispatchAccessorDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Contextor = IContextor;
  ContextorControl = IContextor;
  ContextItemCollection = IContextItemCollection;
  ContextItem = IContextItem;
  ResponseDialog = IResponseDialog;
  PasswordDialog = IPasswordDialog;
  ContextorParticipant = IContextParticipant;
  DispatchAccessor = IDispatchAccessor;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//

  ContextorState = __MIDL___MIDL_itf_VergenceContextor_0000_0002; 
  AccessPrivilege = __MIDL___MIDL_itf_VergenceContextor_0000_0001; 
  UserResponse = __MIDL___MIDL_itf_VergenceContextor_0000_0003; 
  VaultLogLevel = __MIDL___MIDL_itf_VergenceContextor_0225_0001; 
  VERGENCE_DIALOG_BUTTON_ID = __MIDL___MIDL_itf_VergenceContextor_0226_0002; 
  VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE = __MIDL___MIDL_itf_VergenceContextor_0226_0004; 

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
    function Get_State: ContextorState; safecall;
    function GetPrivilege(const subj: WideString): AccessPrivilege; safecall;
    function Get_CurrentContext: IContextItemCollection; safecall;
    procedure StartContextChange; safecall;
    function EndContextChange(commit: WordBool; const aContextItemCollection: IContextItemCollection): UserResponse; safecall;
    procedure SetSurveyResponse(const reason: WideString); safecall;
    function Get_NotificationFilter: WideString; safecall;
    procedure Set_NotificationFilter(const filter: WideString); safecall;
    function Get_Name: WideString; safecall;
    function Perform(const inputContextItemCollection: IContextItemCollection; 
                     isSecureAction: WordBool): IContextItemCollection; safecall;
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
    function GetPrivilege(const subj: WideString): AccessPrivilege; dispid 5;
    property CurrentContext: IContextItemCollection readonly dispid 6;
    procedure StartContextChange; dispid 7;
    function EndContextChange(commit: WordBool; const aContextItemCollection: IContextItemCollection): UserResponse; dispid 8;
    procedure SetSurveyResponse(const reason: WideString); dispid 9;
    property NotificationFilter: WideString dispid 10;
    property Name: WideString readonly dispid 11;
    function Perform(const inputContextItemCollection: IContextItemCollection; 
                     isSecureAction: WordBool): IContextItemCollection; dispid 12;
  end;

// *********************************************************************//
// Interface: IContextParticipant
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {3E3DD272-998E-11D0-808D-00A0240943E4}
// *********************************************************************//
  IContextParticipant = interface(IDispatch)
    ['{3E3DD272-998E-11D0-808D-00A0240943E4}']
    function ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString; safecall;
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
    function ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString; dispid 1610743808;
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
    function Count: Integer; safecall;
    procedure Add(const aContextItem: IContextItem); safecall;
    procedure Remove(const contextItemName: WideString); safecall;
    procedure RemoveAll; safecall;
    function Present(key: OleVariant): IContextItem; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(key: OleVariant): IContextItem; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IContextItemCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0271-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItemCollectionDisp = dispinterface
    ['{AC4C0271-615A-11D3-84B5-0000861FDD4F}']
    function Count: Integer; dispid 1;
    procedure Add(const aContextItem: IContextItem); dispid 2;
    procedure Remove(const contextItemName: WideString); dispid 3;
    procedure RemoveAll; dispid 4;
    function Present(key: OleVariant): IContextItem; dispid 5;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(key: OleVariant): IContextItem; dispid 0;
  end;

// *********************************************************************//
// Interface: IContextItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AC4C0273-615A-11D3-84B5-0000861FDD4F}
// *********************************************************************//
  IContextItem = interface(IDispatch)
    ['{AC4C0273-615A-11D3-84B5-0000861FDD4F}']
    function Get_Subject: WideString; safecall;
    procedure Set_Subject(const pVal: WideString); safecall;
    function Get_Role: WideString; safecall;
    procedure Set_Role(const pVal: WideString); safecall;
    function Get_Prefix: WideString; safecall;
    procedure Set_Prefix(const pVal: WideString); safecall;
    function Get_Suffix: WideString; safecall;
    procedure Set_Suffix(const pVal: WideString); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pVal: WideString); safecall;
    function Get_Value: WideString; safecall;
    procedure Set_Value(const pVal: WideString); safecall;
    function Clone: IContextItem; safecall;
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
    function Clone: IContextItem; dispid 7;
  end;

// *********************************************************************//
// Interface: IResponseContextChange
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CBC6D968-9F6D-416A-8AA7-99172E588DF0}
// *********************************************************************//
  IResponseContextChange = interface(IDispatch)
    ['{CBC6D968-9F6D-416A-8AA7-99172E588DF0}']
    procedure StartResponseContextChange; safecall;
    function EndResponseContextChange(commit: WordBool; 
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
    function EndResponseContextChange(commit: WordBool; 
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
// Interface: IWebSecure
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1A6D9D3D-B36F-42CB-BB0D-1BCB06C6F996}
// *********************************************************************//
  IWebSecure = interface(IDispatch)
    ['{1A6D9D3D-B36F-42CB-BB0D-1BCB06C6F996}']
    function GetContextManagerUrl: WideString; safecall;
    function GetSiteInformation: WideString; safecall;
    function GetParticipantCoupon: WideString; safecall;
    function GetCurrentContextCoupon: WideString; safecall;
    function StartSecureContextChange: WideString; safecall;
    function EndSecureContextChangeContextorDialog(commit: WordBool; 
                                                   const aContextItemCollection: IContextItemCollection; 
                                                   const applicationSignature: WideString): UserResponse; safecall;
    function EndSecureContextChangeCustomDialog(commit: WordBool; 
                                                const aContextItemCollection: IContextItemCollection; 
                                                const applicationSignature: WideString): WordBool; safecall;
    function GetSurveyResponses: OleVariant; safecall;
    procedure CommitSecureContextChange; safecall;
    procedure CancelSecureContextChange; safecall;
  end;

// *********************************************************************//
// DispIntf:  IWebSecureDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1A6D9D3D-B36F-42CB-BB0D-1BCB06C6F996}
// *********************************************************************//
  IWebSecureDisp = dispinterface
    ['{1A6D9D3D-B36F-42CB-BB0D-1BCB06C6F996}']
    function GetContextManagerUrl: WideString; dispid 1;
    function GetSiteInformation: WideString; dispid 2;
    function GetParticipantCoupon: WideString; dispid 3;
    function GetCurrentContextCoupon: WideString; dispid 4;
    function StartSecureContextChange: WideString; dispid 5;
    function EndSecureContextChangeContextorDialog(commit: WordBool; 
                                                   const aContextItemCollection: IContextItemCollection; 
                                                   const applicationSignature: WideString): UserResponse; dispid 6;
    function EndSecureContextChangeCustomDialog(commit: WordBool; 
                                                const aContextItemCollection: IContextItemCollection; 
                                                const applicationSignature: WideString): WordBool; dispid 7;
    function GetSurveyResponses: OleVariant; dispid 8;
    procedure CommitSecureContextChange; dispid 9;
    procedure CancelSecureContextChange; dispid 10;
  end;

// *********************************************************************//
// Interface: IResponseDialog
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD4F}
// *********************************************************************//
  IResponseDialog = interface(IDispatch)
    ['{9D33ECF1-8277-11D3-8525-0000861FDD4F}']
    function ProcessSurveyResults(surveyResponses: OleVariant; noContinue: WordBool): UserResponse; safecall;
    function ProcessSurveyResults2(surveyResponses: OleVariant; enableOK: WordBool; 
                                   enableCancel: WordBool; enableBreakLink: WordBool): UserResponse; safecall;
  end;

// *********************************************************************//
// DispIntf:  IResponseDialogDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD4F}
// *********************************************************************//
  IResponseDialogDisp = dispinterface
    ['{9D33ECF1-8277-11D3-8525-0000861FDD4F}']
    function ProcessSurveyResults(surveyResponses: OleVariant; noContinue: WordBool): UserResponse; dispid 1;
    function ProcessSurveyResults2(surveyResponses: OleVariant; enableOK: WordBool; 
                                   enableCancel: WordBool; enableBreakLink: WordBool): UserResponse; dispid 2;
  end;

// *********************************************************************//
// Interface: IContextorDialog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4D14825-367F-43DB-BF69-1B4440A043A8}
// *********************************************************************//
  IContextorDialog = interface(IDispatch)
    ['{F4D14825-367F-43DB-BF69-1B4440A043A8}']
    function DisplayContextorDialog(surveyResponses: OleVariant; enableOK: WordBool; 
                                    enableCancel: WordBool; enableBreakLink: WordBool): UserResponse; safecall;
  end;

// *********************************************************************//
// DispIntf:  IContextorDialogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F4D14825-367F-43DB-BF69-1B4440A043A8}
// *********************************************************************//
  IContextorDialogDisp = dispinterface
    ['{F4D14825-367F-43DB-BF69-1B4440A043A8}']
    function DisplayContextorDialog(surveyResponses: OleVariant; enableOK: WordBool; 
                                    enableCancel: WordBool; enableBreakLink: WordBool): UserResponse; dispid 1;
  end;

// *********************************************************************//
// Interface: IBridge
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78280F9B-0AF5-4786-BD2A-78845C9164D7}
// *********************************************************************//
  IBridge = interface(IDispatch)
    ['{78280F9B-0AF5-4786-BD2A-78845C9164D7}']
    function DecryptUserPassword(const encryptedPwd: WideString): WideString; safecall;
    function SetUserIdAndPassword(const userID: WideString; const plainTextOldPwd: WideString; 
                                  const plainTextNewPwd: WideString): SYSINT; safecall;
    procedure SetPasswordUsingDialog(HWNDToOverlay: SYSINT; AllowUserIDChange: SYSINT; 
                                     const userIDIn: WideString; out userIDOut: WideString; 
                                     out plainTextOldPwd: WideString; 
                                     out plainTextNewPwd: WideString; out resultCode: SYSINT); safecall;
    function GetBridgeConfiguration(const BridgeApplicationConfigurationIdentifier: WideString): IContextItemCollection; safecall;
    function AddLogEntry(aLogLevel: VaultLogLevel; const LogEntry: WideString): SYSINT; safecall;
    function GenerateNewPassword: SYSINT; safecall;
    procedure SetPasswordUsingDialogEx(HWNDToOverlay: SYSINT; updateVault: Integer; 
                                       oldPassword: Integer; const plainTextBitmapPath: WideString; 
                                       const userName: WideString; 
                                       const plainTextTitleName: WideString; 
                                       const plainTextDescription: WideString; 
                                       out plainTextNewPwd: WideString; 
                                       out plainTextOldPwd: WideString; out resultCode: SYSINT); safecall;
    procedure CloseDialogEx(dialogID: SYSINT); safecall;
    function GetSecureItemValues(itemNames: OleVariant): IContextItemCollection; safecall;
    function AddLogEntry2(aLogLevel: VaultLogLevel; const componentName: WideString; 
                          const LogEntry: WideString): SYSINT; safecall;
    function SetUserIdAndPasswordEx(const userID: WideString; const plainTextOldPwd: WideString; 
                                    const plainTextNewPwd: WideString; const appName: WideString): SYSINT; safecall;
  end;

// *********************************************************************//
// DispIntf:  IBridgeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {78280F9B-0AF5-4786-BD2A-78845C9164D7}
// *********************************************************************//
  IBridgeDisp = dispinterface
    ['{78280F9B-0AF5-4786-BD2A-78845C9164D7}']
    function DecryptUserPassword(const encryptedPwd: WideString): WideString; dispid 1;
    function SetUserIdAndPassword(const userID: WideString; const plainTextOldPwd: WideString; 
                                  const plainTextNewPwd: WideString): SYSINT; dispid 2;
    procedure SetPasswordUsingDialog(HWNDToOverlay: SYSINT; AllowUserIDChange: SYSINT; 
                                     const userIDIn: WideString; out userIDOut: WideString; 
                                     out plainTextOldPwd: WideString; 
                                     out plainTextNewPwd: WideString; out resultCode: SYSINT); dispid 3;
    function GetBridgeConfiguration(const BridgeApplicationConfigurationIdentifier: WideString): IContextItemCollection; dispid 4;
    function AddLogEntry(aLogLevel: VaultLogLevel; const LogEntry: WideString): SYSINT; dispid 5;
    function GenerateNewPassword: SYSINT; dispid 6;
    procedure SetPasswordUsingDialogEx(HWNDToOverlay: SYSINT; updateVault: Integer; 
                                       oldPassword: Integer; const plainTextBitmapPath: WideString; 
                                       const userName: WideString; 
                                       const plainTextTitleName: WideString; 
                                       const plainTextDescription: WideString; 
                                       out plainTextNewPwd: WideString; 
                                       out plainTextOldPwd: WideString; out resultCode: SYSINT); dispid 7;
    procedure CloseDialogEx(dialogID: SYSINT); dispid 8;
    function GetSecureItemValues(itemNames: OleVariant): IContextItemCollection; dispid 9;
    function AddLogEntry2(aLogLevel: VaultLogLevel; const componentName: WideString; 
                          const LogEntry: WideString): SYSINT; dispid 10;
    function SetUserIdAndPasswordEx(const userID: WideString; const plainTextOldPwd: WideString; 
                                    const plainTextNewPwd: WideString; const appName: WideString): SYSINT; dispid 11;
  end;

// *********************************************************************//
// Interface: IBridge2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3BEA4FD-041C-4A08-AC56-0F0129C254A0}
// *********************************************************************//
  IBridge2 = interface(IBridge)
    ['{C3BEA4FD-041C-4A08-AC56-0F0129C254A0}']
    function GetVersion: WideString; safecall;
    procedure CloseDialogEx2(DialogTypeIDs: SYSINT; DialogInstanceKey: SYSINT); safecall;
    function DisplayContextChangeResponseDialog(ParentHWND: SYSINT; 
                                                ApplicationMessages: OleVariant; 
                                                DialogFlags: SYSINT; DialogInstanceKey: SYSINT): VERGENCE_DIALOG_BUTTON_ID; safecall;
    function AcquirePassword(ParentHWND: SYSINT; 
                             DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                             const ApplicationNameOrDialogText: WideString; 
                             const userName: WideString; DialogFlags: SYSINT; 
                             DialogInstanceKey: SYSINT): WideString; safecall;
    function AcquirePasswordEx(ParentHWND: SYSINT; 
                               DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                               const ApplicationNameOrDialogText: WideString; 
                               const userName: WideString; const DialogTitle: WideString; 
                               const Reserved: WideString; DialogFlags: SYSINT; 
                               DialogInstanceKey: SYSINT): WideString; safecall;
    procedure AcquireCredentials(ParentHWND: SYSINT; 
                                 DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                                 const ApplicationNameOrDialogText: WideString; 
                                 const userName: WideString; const DialogTitle: WideString; 
                                 const Reserved: WideString; DialogFlags: SYSINT; 
                                 DialogInstanceKey: SYSINT; out pNewUsername: WideString; 
                                 out pNewPassword: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IBridge2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C3BEA4FD-041C-4A08-AC56-0F0129C254A0}
// *********************************************************************//
  IBridge2Disp = dispinterface
    ['{C3BEA4FD-041C-4A08-AC56-0F0129C254A0}']
    function GetVersion: WideString; dispid 12;
    procedure CloseDialogEx2(DialogTypeIDs: SYSINT; DialogInstanceKey: SYSINT); dispid 13;
    function DisplayContextChangeResponseDialog(ParentHWND: SYSINT; 
                                                ApplicationMessages: OleVariant; 
                                                DialogFlags: SYSINT; DialogInstanceKey: SYSINT): VERGENCE_DIALOG_BUTTON_ID; dispid 14;
    function AcquirePassword(ParentHWND: SYSINT; 
                             DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                             const ApplicationNameOrDialogText: WideString; 
                             const userName: WideString; DialogFlags: SYSINT; 
                             DialogInstanceKey: SYSINT): WideString; dispid 15;
    function AcquirePasswordEx(ParentHWND: SYSINT; 
                               DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                               const ApplicationNameOrDialogText: WideString; 
                               const userName: WideString; const DialogTitle: WideString; 
                               const Reserved: WideString; DialogFlags: SYSINT; 
                               DialogInstanceKey: SYSINT): WideString; dispid 16;
    procedure AcquireCredentials(ParentHWND: SYSINT; 
                                 DialogPurpose: VERGENCE_DIALOG_ACQUIRE_PASSWORD_PURPOSE; 
                                 const ApplicationNameOrDialogText: WideString; 
                                 const userName: WideString; const DialogTitle: WideString; 
                                 const Reserved: WideString; DialogFlags: SYSINT; 
                                 DialogInstanceKey: SYSINT; out pNewUsername: WideString; 
                                 out pNewPassword: WideString); dispid 17;
    function DecryptUserPassword(const encryptedPwd: WideString): WideString; dispid 1;
    function SetUserIdAndPassword(const userID: WideString; const plainTextOldPwd: WideString; 
                                  const plainTextNewPwd: WideString): SYSINT; dispid 2;
    procedure SetPasswordUsingDialog(HWNDToOverlay: SYSINT; AllowUserIDChange: SYSINT; 
                                     const userIDIn: WideString; out userIDOut: WideString; 
                                     out plainTextOldPwd: WideString; 
                                     out plainTextNewPwd: WideString; out resultCode: SYSINT); dispid 3;
    function GetBridgeConfiguration(const BridgeApplicationConfigurationIdentifier: WideString): IContextItemCollection; dispid 4;
    function AddLogEntry(aLogLevel: VaultLogLevel; const LogEntry: WideString): SYSINT; dispid 5;
    function GenerateNewPassword: SYSINT; dispid 6;
    procedure SetPasswordUsingDialogEx(HWNDToOverlay: SYSINT; updateVault: Integer; 
                                       oldPassword: Integer; const plainTextBitmapPath: WideString; 
                                       const userName: WideString; 
                                       const plainTextTitleName: WideString; 
                                       const plainTextDescription: WideString; 
                                       out plainTextNewPwd: WideString; 
                                       out plainTextOldPwd: WideString; out resultCode: SYSINT); dispid 7;
    procedure CloseDialogEx(dialogID: SYSINT); dispid 8;
    function GetSecureItemValues(itemNames: OleVariant): IContextItemCollection; dispid 9;
    function AddLogEntry2(aLogLevel: VaultLogLevel; const componentName: WideString; 
                          const LogEntry: WideString): SYSINT; dispid 10;
    function SetUserIdAndPasswordEx(const userID: WideString; const plainTextOldPwd: WideString; 
                                    const plainTextNewPwd: WideString; const appName: WideString): SYSINT; dispid 11;
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
// Interface: IPasswordDialog
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD5E}
// *********************************************************************//
  IPasswordDialog = interface(IDispatch)
    ['{9D33ECF1-8277-11D3-8525-0000861FDD5E}']
    function GetPasswordChangeInformation(var userID: WideString; var oldPassword: WideString; 
                                          var newPassword: WideString): SYSINT; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPasswordDialogDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9D33ECF1-8277-11D3-8525-0000861FDD5E}
// *********************************************************************//
  IPasswordDialogDisp = dispinterface
    ['{9D33ECF1-8277-11D3-8525-0000861FDD5E}']
    function GetPasswordChangeInformation(var userID: WideString; var oldPassword: WideString; 
                                          var newPassword: WideString): SYSINT; dispid 1;
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
// Interface: IDispatchAccessor
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}
// *********************************************************************//
  IDispatchAccessor = interface(IDispatch)
    ['{C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}']
    function GetInterface(const sourceInterface: IDispatch; const interfaceName: WideString): IDispatch; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDispatchAccessorDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}
// *********************************************************************//
  IDispatchAccessorDisp = dispinterface
    ['{C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}']
    function GetInterface(const sourceInterface: IDispatch; const interfaceName: WideString): IDispatch; dispid 1;
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

  TContextorPending = procedure(ASender: TObject; const aContextItemCollection: IDispatch) of object;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TContextor
// Help String      : Vergence Contextor
// Default Interface: IContextor
// Def. Intf. DISP? : No
// Event   Interface: _IContextChangesSink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TContextor = class(TOleServer)
  private
    FOnPending: TContextorPending;
    FOnCommitted: TNotifyEvent;
    FOnCanceled: TNotifyEvent;
    FIntf: IContextor;
    function GetDefaultInterface: IContextor;
  protected
    procedure InitServerData; override;
    procedure InvokeEvent(DispID: TDispID; var Params: TVariantArray); override;
    function Get_State: ContextorState;
    function Get_CurrentContext: IContextItemCollection;
    function Get_NotificationFilter: WideString;
    procedure Set_NotificationFilter(const filter: WideString);
    function Get_Name: WideString;
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
    function GetPrivilege(const subj: WideString): AccessPrivilege;
    procedure StartContextChange;
    function EndContextChange(commit: WordBool; const aContextItemCollection: IContextItemCollection): UserResponse;
    procedure SetSurveyResponse(const reason: WideString);
    function Perform(const inputContextItemCollection: IContextItemCollection; 
                     isSecureAction: WordBool): IContextItemCollection;
    property DefaultInterface: IContextor read GetDefaultInterface;
    property State: ContextorState read Get_State;
    property CurrentContext: IContextItemCollection read Get_CurrentContext;
    property Name: WideString read Get_Name;
    property NotificationFilter: WideString read Get_NotificationFilter write Set_NotificationFilter;
  published
    property OnPending: TContextorPending read FOnPending write FOnPending;
    property OnCommitted: TNotifyEvent read FOnCommitted write FOnCommitted;
    property OnCanceled: TNotifyEvent read FOnCanceled write FOnCanceled;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TContextorControl
// Help String      : Vergence ContextorControl
// Default Interface: IContextor
// Def. Intf. DISP? : No
// Event   Interface: _IContextChangesSink
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TContextorControlPending = procedure(ASender: TObject; const aContextItemCollection: IDispatch) of object;

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
    function Get_CurrentContext: IContextItemCollection;
  public
    procedure Run(const applicationLabel: WideString; const passcode: WideString; survey: WordBool; 
                  const initialNotificationFilter: WideString);
    procedure Suspend;
    procedure Resume;
    function GetPrivilege(const subj: WideString): AccessPrivilege;
    procedure StartContextChange;
    function EndContextChange(commit: WordBool; const aContextItemCollection: IContextItemCollection): UserResponse;
    procedure SetSurveyResponse(const reason: WideString);
    function Perform(const inputContextItemCollection: IContextItemCollection; 
                     isSecureAction: WordBool): IContextItemCollection;
    property  ControlInterface: IContextor read GetControlInterface;
    property  DefaultInterface: IContextor read GetControlInterface;
    property State: TOleEnum index 4 read GetTOleEnumProp;
    property CurrentContext: IContextItemCollection read Get_CurrentContext;
    property Name: WideString index 11 read GetWideStringProp;
  published
    property Anchors;
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
  TContextItemCollection = class(TOleServer)
  private
    FIntf: IContextItemCollection;
    function GetDefaultInterface: IContextItemCollection;
  protected
    procedure InitServerData; override;
    function Get__NewEnum: IUnknown;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextItemCollection);
    procedure Disconnect; override;
    function Count: Integer;
    procedure Add(const aContextItem: IContextItem);
    procedure Remove(const contextItemName: WideString);
    procedure RemoveAll;
    function Present(key: OleVariant): IContextItem;
    function Item(key: OleVariant): IContextItem;
    property DefaultInterface: IContextItemCollection read GetDefaultInterface;
    property _NewEnum: IUnknown read Get__NewEnum;
  published
  end;

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
  TContextItem = class(TOleServer)
  private
    FIntf: IContextItem;
    function GetDefaultInterface: IContextItem;
  protected
    procedure InitServerData; override;
    function Get_Subject: WideString;
    procedure Set_Subject(const pVal: WideString);
    function Get_Role: WideString;
    procedure Set_Role(const pVal: WideString);
    function Get_Prefix: WideString;
    procedure Set_Prefix(const pVal: WideString);
    function Get_Suffix: WideString;
    procedure Set_Suffix(const pVal: WideString);
    function Get_Name: WideString;
    procedure Set_Name(const pVal: WideString);
    function Get_Value: WideString;
    procedure Set_Value(const pVal: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextItem);
    procedure Disconnect; override;
    function Clone: IContextItem;
    property DefaultInterface: IContextItem read GetDefaultInterface;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Role: WideString read Get_Role write Set_Role;
    property Prefix: WideString read Get_Prefix write Set_Prefix;
    property Suffix: WideString read Get_Suffix write Set_Suffix;
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  published
  end;

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
  TResponseDialog = class(TOleServer)
  private
    FIntf: IResponseDialog;
    function GetDefaultInterface: IResponseDialog;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IResponseDialog);
    procedure Disconnect; override;
    function ProcessSurveyResults(surveyResponses: OleVariant; noContinue: WordBool): UserResponse;
    function ProcessSurveyResults2(surveyResponses: OleVariant; enableOK: WordBool; 
                                   enableCancel: WordBool; enableBreakLink: WordBool): UserResponse;
    property DefaultInterface: IResponseDialog read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoPasswordDialog provides a Create and CreateRemote method to          
// create instances of the default interface IPasswordDialog exposed by              
// the CoClass PasswordDialog. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPasswordDialog = class
    class function Create: IPasswordDialog;
    class function CreateRemote(const MachineName: string): IPasswordDialog;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TPasswordDialog
// Help String      : Vergence PasswordDialog
// Default Interface: IPasswordDialog
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TPasswordDialog = class(TOleServer)
  private
    FIntf: IPasswordDialog;
    function GetDefaultInterface: IPasswordDialog;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IPasswordDialog);
    procedure Disconnect; override;
    function GetPasswordChangeInformation(var userID: WideString; var oldPassword: WideString; 
                                          var newPassword: WideString): SYSINT;
    property DefaultInterface: IPasswordDialog read GetDefaultInterface;
  published
  end;

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
  TContextorParticipant = class(TOleServer)
  private
    FIntf: IContextParticipant;
    function GetDefaultInterface: IContextParticipant;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IContextParticipant);
    procedure Disconnect; override;
    function ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString;
    procedure ContextChangesAccepted(contextCoupon: Integer);
    procedure ContextChangesCanceled(contextCoupon: Integer);
    procedure CommonContextTerminated;
    procedure Ping;
    property DefaultInterface: IContextParticipant read GetDefaultInterface;
  published
  end;

// *********************************************************************//
// The Class CoDispatchAccessor provides a Create and CreateRemote method to          
// create instances of the default interface IDispatchAccessor exposed by              
// the CoClass DispatchAccessor. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDispatchAccessor = class
    class function Create: IDispatchAccessor;
    class function CreateRemote(const MachineName: string): IDispatchAccessor;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDispatchAccessor
// Help String      : DispatchAccessor Class
// Default Interface: IDispatchAccessor
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TDispatchAccessor = class(TOleServer)
  private
    FIntf: IDispatchAccessor;
    function GetDefaultInterface: IDispatchAccessor;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDispatchAccessor);
    procedure Disconnect; override;
    function GetInterface(const sourceInterface: IDispatch; const interfaceName: WideString): IDispatch;
    property DefaultInterface: IDispatchAccessor read GetDefaultInterface;
  published
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses System.Win.ComObj;

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
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TContextor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TContextor.Destroy;
begin
  inherited Destroy;
end;

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

function TContextor.Get_State: ContextorState;
begin
  Result := DefaultInterface.State;
end;

function TContextor.Get_CurrentContext: IContextItemCollection;
begin
  Result := DefaultInterface.CurrentContext;
end;

function TContextor.Get_NotificationFilter: WideString;
begin
  Result := DefaultInterface.NotificationFilter;
end;

procedure TContextor.Set_NotificationFilter(const filter: WideString);
begin
  DefaultInterface.NotificationFilter := filter;
end;

function TContextor.Get_Name: WideString;
begin
  Result := DefaultInterface.Name;
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

function TContextor.GetPrivilege(const subj: WideString): AccessPrivilege;
begin
  Result := DefaultInterface.GetPrivilege(subj);
end;

procedure TContextor.StartContextChange;
begin
  DefaultInterface.StartContextChange;
end;

function TContextor.EndContextChange(commit: WordBool; 
                                     const aContextItemCollection: IContextItemCollection): UserResponse;
begin
  Result := DefaultInterface.EndContextChange(commit, aContextItemCollection);
end;

procedure TContextor.SetSurveyResponse(const reason: WideString);
begin
  DefaultInterface.SetSurveyResponse(reason);
end;

function TContextor.Perform(const inputContextItemCollection: IContextItemCollection; 
                            isSecureAction: WordBool): IContextItemCollection;
begin
  Result := DefaultInterface.Perform(inputContextItemCollection, isSecureAction);
end;

procedure TContextorControl.InitControlData;
const
  CEventDispIDs: array [0..2] of DWORD = (
    $00000001, $00000002, $00000003);
  CControlData: TControlData2 = (
    ClassID:      '{8778ACF7-5CA9-11D3-8727-0060B0B5E137}';
    EventIID:     '{6BED8971-B3DD-11D3-8736-0060B0B5E137}';
    EventCount:   3;
    EventDispIDs: @CEventDispIDs;
    LicenseKey:   nil (*HR:$80004002*);
    Flags:        $00000000;
    Version:      500);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := UIntPtr(@@FOnPending) - UIntPtr(Self);
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

function TContextorControl.Get_CurrentContext: IContextItemCollection;
begin
  Result := DefaultInterface.CurrentContext;
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

function TContextorControl.GetPrivilege(const subj: WideString): AccessPrivilege;
begin
  Result := DefaultInterface.GetPrivilege(subj);
end;

procedure TContextorControl.StartContextChange;
begin
  DefaultInterface.StartContextChange;
end;

function TContextorControl.EndContextChange(commit: WordBool; 
                                            const aContextItemCollection: IContextItemCollection): UserResponse;
begin
  Result := DefaultInterface.EndContextChange(commit, aContextItemCollection);
end;

procedure TContextorControl.SetSurveyResponse(const reason: WideString);
begin
  DefaultInterface.SetSurveyResponse(reason);
end;

function TContextorControl.Perform(const inputContextItemCollection: IContextItemCollection; 
                                   isSecureAction: WordBool): IContextItemCollection;
begin
  Result := DefaultInterface.Perform(inputContextItemCollection, isSecureAction);
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
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TContextItemCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TContextItemCollection.Destroy;
begin
  inherited Destroy;
end;

function TContextItemCollection.Get__NewEnum: IUnknown;
begin
  Result := DefaultInterface._NewEnum;
end;

function TContextItemCollection.Count: Integer;
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

function TContextItemCollection.Present(key: OleVariant): IContextItem;
begin
  Result := DefaultInterface.Present(key);
end;

function TContextItemCollection.Item(key: OleVariant): IContextItem;
begin
  Result := DefaultInterface.Item(key);
end;

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
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TContextItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TContextItem.Destroy;
begin
  inherited Destroy;
end;

function TContextItem.Get_Subject: WideString;
begin
  Result := DefaultInterface.Subject;
end;

procedure TContextItem.Set_Subject(const pVal: WideString);
begin
  DefaultInterface.Subject := pVal;
end;

function TContextItem.Get_Role: WideString;
begin
  Result := DefaultInterface.Role;
end;

procedure TContextItem.Set_Role(const pVal: WideString);
begin
  DefaultInterface.Role := pVal;
end;

function TContextItem.Get_Prefix: WideString;
begin
  Result := DefaultInterface.Prefix;
end;

procedure TContextItem.Set_Prefix(const pVal: WideString);
begin
  DefaultInterface.Prefix := pVal;
end;

function TContextItem.Get_Suffix: WideString;
begin
  Result := DefaultInterface.Suffix;
end;

procedure TContextItem.Set_Suffix(const pVal: WideString);
begin
  DefaultInterface.Suffix := pVal;
end;

function TContextItem.Get_Name: WideString;
begin
  Result := DefaultInterface.Name;
end;

procedure TContextItem.Set_Name(const pVal: WideString);
begin
  DefaultInterface.Name := pVal;
end;

function TContextItem.Get_Value: WideString;
begin
  Result := DefaultInterface.Value;
end;

procedure TContextItem.Set_Value(const pVal: WideString);
begin
  DefaultInterface.Value := pVal;
end;

function TContextItem.Clone: IContextItem;
begin
  Result := DefaultInterface.Clone;
end;

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
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TResponseDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TResponseDialog.Destroy;
begin
  inherited Destroy;
end;

function TResponseDialog.ProcessSurveyResults(surveyResponses: OleVariant; noContinue: WordBool): UserResponse;
begin
  Result := DefaultInterface.ProcessSurveyResults(surveyResponses, noContinue);
end;

function TResponseDialog.ProcessSurveyResults2(surveyResponses: OleVariant; enableOK: WordBool; 
                                               enableCancel: WordBool; enableBreakLink: WordBool): UserResponse;
begin
  Result := DefaultInterface.ProcessSurveyResults2(surveyResponses, enableOK, enableCancel, 
                                                   enableBreakLink);
end;

class function CoPasswordDialog.Create: IPasswordDialog;
begin
  Result := CreateComObject(CLASS_PasswordDialog) as IPasswordDialog;
end;

class function CoPasswordDialog.CreateRemote(const MachineName: string): IPasswordDialog;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PasswordDialog) as IPasswordDialog;
end;

procedure TPasswordDialog.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{9D33ECF2-8277-11D3-8525-0000861FDD5E}';
    IntfIID:   '{9D33ECF1-8277-11D3-8525-0000861FDD5E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TPasswordDialog.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IPasswordDialog;
  end;
end;

procedure TPasswordDialog.ConnectTo(svrIntf: IPasswordDialog);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TPasswordDialog.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TPasswordDialog.GetDefaultInterface: IPasswordDialog;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TPasswordDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPasswordDialog.Destroy;
begin
  inherited Destroy;
end;

function TPasswordDialog.GetPasswordChangeInformation(var userID: WideString; 
                                                      var oldPassword: WideString; 
                                                      var newPassword: WideString): SYSINT;
begin
  Result := DefaultInterface.GetPasswordChangeInformation(userID, oldPassword, newPassword);
end;

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
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TContextorParticipant.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TContextorParticipant.Destroy;
begin
  inherited Destroy;
end;

function TContextorParticipant.ContextChangesPending(contextCoupon: Integer; var reason: WideString): WideString;
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

class function CoDispatchAccessor.Create: IDispatchAccessor;
begin
  Result := CreateComObject(CLASS_DispatchAccessor) as IDispatchAccessor;
end;

class function CoDispatchAccessor.CreateRemote(const MachineName: string): IDispatchAccessor;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DispatchAccessor) as IDispatchAccessor;
end;

procedure TDispatchAccessor.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{5F9C5135-FA94-4091-B1A9-B55294259118}';
    IntfIID:   '{C3AC74F6-6C5D-4ED9-8838-2EF5777226E2}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDispatchAccessor.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDispatchAccessor;
  end;
end;

procedure TDispatchAccessor.ConnectTo(svrIntf: IDispatchAccessor);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDispatchAccessor.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDispatchAccessor.GetDefaultInterface: IDispatchAccessor;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TDispatchAccessor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TDispatchAccessor.Destroy;
begin
  inherited Destroy;
end;

function TDispatchAccessor.GetInterface(const sourceInterface: IDispatch; 
                                        const interfaceName: WideString): IDispatch;
begin
  Result := DefaultInterface.GetInterface(sourceInterface, interfaceName);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TContextorControl]);
  RegisterComponents(dtlServerPage, [TContextor, TContextItemCollection, TContextItem, TResponseDialog, 
    TPasswordDialog, TContextorParticipant, TDispatchAccessor]);
end;

end.

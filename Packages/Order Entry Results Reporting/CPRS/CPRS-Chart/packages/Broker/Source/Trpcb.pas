{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Raul Mendoza, Joel Ivey,
  Herlan Westra, Roy Gaber
  Description: Contains TRPCBroker and related components.
  Unit: Tbrpc RPC broker.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in v1.1.71 (RGG 03/11/2019) XWB*1.1*71
  1. Updated CURRENT_RPC_VERSION to version XWB*1.1*71
  2. Corrected an issue reported in I18491582FY18 where context creation
  after an RPC call fails due to VistA clearing the application context
  upon RPC error.  The issue involves unattended connections to VistA
  when there is a need to reconnect automatically upon failure, in
  an unattended fashion. See I18491582FY18 -  BDK 65 Silent login not working
  3. Corrected an issue where the dialog for an invalid Access/Verify code
  pair is hidden behind the login window, leaving users thinking they needed
  to terminate the application they were running, this only happens after the
  dialog is presented initially, which is correctly diaplayed, in subsequent
  login failures, the error dialog is hidden.
  4. Corrected an issue with the Broker Security Enhancement (BSE) not
  working correctly.  Users were being prompted for their credentials
  when they are connecting to a remote VistA site via the BSE token
  method.
  5. Addressed some warning messages regarding type casts when the BDK is
  compiled.
  6. Removed support for versions of RAD Studio XE4, XE5, XE6, and XE7.  All
  of these released are no longer supported by Embarcadero, developers who
  do not have RAD Studio XE8 or higher will have to upgrade their IDE.

  Changes in v1.1.65 (HGW 01/11/2017) XWB*1.1*65
  1. Corrected CURRENT_RPC_VERSION to version XWB*1.1*65
  2. In TRPCBroker.SetConnected, added call to get an Identity and Access
  Management (IAM) Secure Token Service (STS) SAML Token for Single
  Sign-On internal (SSOi). The token is used to set SSOiToken, SSOiSECID,
  SSOiADUPN, and SSOiLogonName properties for the TRPCBroker connection.
  3. In AuthenticateUser, used SSOiToken property to authenticate the user
  (new silent Login Mode: lmSSOi)
  4. Removed several short string type castings.
  5. After authenticating user with Access/Verify codes, if SecID is
  populated, then call binding RPC (on test/development systems only) so
  that future authentication will be 2-factor using STS token.
  6. User binding (IAM SecID to VistA NEW PERSON file) enabled for test
  accounts only. Production accounts will use 'IAM Link My Account'
  application.
  7. Enable SSH-2 tunneling for Micro Focus Reflection, which replaces
  Attachmate Reflection. Some command line changes needed to be made to
  support both products and higher levels of encryption.
  8. Added code to 'create context' after an RPC call errors out due to VistA
  clearing the application context upon an error.

  Changes in v1.1.60 (HGW 10/08/2014) XWB*1.1*60
  1. Corrected CURRENT_RPC_VERSION to version XWB*1.1*60
  2. Deprecated old-style broker which called back to client on a different
  port. This has problems on the VistA side using IPv6. The code will not
  be removed from the VistA routines until all client applications have
  migrated to new-style broker (as of this patch, BCMA is still compiled
  with an older BDK that does not support the new-style broker).
  3. In TRPCBroker.StartSecureConnection, provided alternative command line
  syntax for opening Attachmate Reflection or Plink.exe when the server is
  an IPv6 address instead of a FQDN.
  4. Changed delimiter in BrokerConnections and BrokerAllConnections list from
  ':' to '/' when storing server/port due to instances when the server is
  an IPv6 address instead of a FQDN.

  Changes in v1.1.50 (JLI 6/24/2008) XWB*1.1*50
  1. Adding use of SSH tunneling as command line option (or property). It
  appears that tunneling with Attachmate Reflection will be used within
  the VA.  However, code for the use of Plink.exe for SSH tunneling is
  also provided to permit secure connections for those using VistA
  outside of the VA.
  2. Correct RPC Version to version 50.

  Changes in v1.1.31 (DCM ) XWB*1.1*31
  1. Added new read only property BrokerVersion to TRPCBroker which should
  contain the version number for the RPCBroker (or SharedRPCBroker) in
  use.

  Changes in v1.1.13 (JLI 4/24/2001) XWB*1.1*13
  1. More silent login code; deleted obsolete lines

  Changes in v1.1.8 (REM 7/13/1999) XWB*1.1*8
  1. Check for Multi-Division users.

  Changes in v1.1.6 (DPC 4/99) XWB*1.1*6
  1. Polling to support terminating orphaned server jobs.

  Changes in v1.1.4 (DCM 10/22/98) XWB*1.1*4
  1. Silent Login changes.
  ************************************************** }
unit Trpcb;

// TODO - (future patch) Enable TLS secure TCP connection, then deprecate all
// references to Plink and SSH tunneling here and in other units.

interface

{$I IISBase.inc}

uses
  {System}
  Classes, SysUtils, StrUtils, ComObj,
  {WinApi}
  Messages, WinProcs, WinTypes, Windows, ActiveX,
  {VA}
  XWBut1, MFunStr, XWBHash, VERGENCECONTEXTORLib_TLB, XWBSSOi,
  {Vcl}
  Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.Graphics, Vcl.OleCtrls,
  Vcl.ExtCtrls;

const
  NoMore: boolean = False;
  MIN_RPCTIMELIMIT: integer = 30;
  CURRENT_RPC_VERSION: String = 'XWB*1.1*73';

type
  TParamType = (literal, reference, list, global, empty, stream, undefined);
  TAccessVerifyCodes = String;
  // to use TAccessVerifyCodesProperty editor use this type
  TRemoteProc = String; // to use TRemoteProcProperty editor use this type
  TServer = String; // to use TServerProperty editor use this type
  TRpcVersion = String; // to use TRpcVersionProperty editor use this type
  TRPCBroker = class;
  TVistaLogin = class;
  TLoginMode = (lmAVCodes, lmAppHandle, lmSSOi);
  TShowErrorMsgs = (semRaise, semQuiet);
  TOnLoginFailure = procedure(VistaLogin: TVistaLogin) of object;
  TOnRPCBFailure = procedure(RPCBroker: TRPCBroker) of object;
  TOnPulseError = procedure(RPCBroker: TRPCBroker; ErrorText: String) of object;
  TSecure = (secureNone, secureAttachmate, securePlink);

  { ------ EBrokerError ------ }
  EBrokerError = class(Exception)
  public
    Action: string;
    Code: integer;
    Mnemonic: string;
  end;

  { ------ TString ------ }
  TString = class(TObject)
    Str: string;
  end;

  { ------ TMult ------ }
  { :This component defines the multiple field of a parameter.  The multiple
    field is used to pass string-subscripted array of data in a parameter. }
  TMult = class(TComponent)
  private
    FMultiple: TStringList;
    procedure ClearAll;
    function GetCount: Word;
    function GetFirst: string;
    function GetLast: string;
    function GetFMultiple(Index: string): string;
    function GetSorted: boolean;
    procedure SetFMultiple(Index: string; value: string);
    procedure SetSorted(value: boolean);
  protected
  public
    constructor Create(AOwner: TComponent); override; { 1.1T8 }
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Order(const StartSubscript: string; Direction: integer): string;
    function Position(const Subscript: string): longint;
    function Subscript(const Position: longint): string;
    property Count: Word read GetCount;
    property First: string read GetFirst;
    property Last: string read GetLast;
    property MultArray[I: string]: string read GetFMultiple
      write SetFMultiple; default;
    property Sorted: boolean read GetSorted write SetSorted;
  end;

  { ------ TParamRecord ------ }
  { :This component defines all the fields that comprise a parameter. }

  TParamRecord = class(TComponent)
  private
    FMult: TMult;
    FValue: string;
    FPType: TParamType;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property value: string read FValue write FValue;
    property PType: TParamType read FPType write FPType;
    property Mult: TMult read FMult write FMult;
  end;

  { ------ TParams ------ }
  { :This component is really a collection of parameters.  Simple inclusion
    of this component in the Broker component provides access to all of the
    parameters that may be needed when calling a remote procedure. }
  TParams = class(TComponent)
  private
    FParameters: TList;
    function GetCount: Word;
    function GetParameter(Index: integer): TParamRecord;
    procedure SetParameter(Index: integer; Parameter: TParamRecord);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property Count: Word read GetCount;
    property ParamArray[I: integer]: TParamRecord read GetParameter
      write SetParameter; default;
  end;

  { ------ TVistaLogin ------ }     // p13
  TVistaLogin = class(TPersistent)
  private
    FLogInHandle: string;
    FNTToken: string;
    FAccessCode: string;
    FVerifyCode: string;
    FDivision: string;
    FMode: TLoginMode;
    FDivLst: TStrings;
    FOnFailedLogin: TOnLoginFailure;
    FMultiDivision: boolean;
    FDUZ: string;
    FErrorText: string;
    FPromptDiv: boolean;
    FIsProductionAccount: boolean;
    FDomainName: string;
    procedure SetAccessCode(const value: String);
    procedure SetLogInHandle(const value: String);
    procedure SetNTToken(const value: String);
    procedure SetVerifyCode(const value: String);
    procedure SetDivision(const value: String);
    procedure SetMode(const value: TLoginMode);
    procedure SetMultiDivision(value: boolean);
    procedure SetDuz(const value: string);
    procedure SetErrorText(const value: string);
    procedure SetPromptDiv(const value: boolean);
  protected
    procedure FailedLogin(Sender: TObject); dynamic;
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    property LogInHandle: String read FLogInHandle write SetLogInHandle;
    // for use by a secondary VistA login
    property NTToken: String read FNTToken write SetNTToken;
    property DivList: TStrings read FDivLst;
    property OnFailedLogin: TOnLoginFailure read FOnFailedLogin
      write FOnFailedLogin;
    property MultiDivision: boolean read FMultiDivision write SetMultiDivision;
    property DUZ: string read FDUZ write SetDuz;
    property ErrorText: string read FErrorText write SetErrorText;
    property IsProductionAccount: boolean read FIsProductionAccount
      write FIsProductionAccount;
    property DomainName: string read FDomainName write FDomainName;
  published
    property AccessCode: String read FAccessCode write SetAccessCode;
    property VerifyCode: String read FVerifyCode write SetVerifyCode;
    property Mode: TLoginMode read FMode write SetMode;
    property Division: String read FDivision write SetDivision;
    property PromptDivision: boolean read FPromptDiv write SetPromptDiv;

  end;

  { ------ TVistaUser ------ }   // holds 'generic' user attributes {p13}
  TVistaUser = class(TObject)
  private
    FDUZ: string;
    FName: string;
    FStandardName: string;
    FDivision: String;
    FVerifyCodeChngd: boolean;
    FTitle: string;
    FServiceSection: string;
    FLanguage: string;
    FDtime: string;
    FVpid: String;
    procedure SetDivision(const value: String);
    procedure SetDuz(const value: String);
    procedure SetName(const value: String);
    procedure SetVerifyCodeChngd(const value: boolean);
    procedure SetStandardName(const value: String);
    procedure SetTitle(const value: string);
    procedure SetDTime(const value: string);
    procedure SetLanguage(const value: string);
    procedure SetServiceSection(const value: string);
  public
    property DUZ: String read FDUZ write SetDuz;
    property Name: String read FName write SetName;
    property StandardName: String read FStandardName write SetStandardName;
    property Division: String read FDivision write SetDivision;
    property VerifyCodeChngd: boolean read FVerifyCodeChngd
      write SetVerifyCodeChngd;
    property Title: string read FTitle write SetTitle;
    property ServiceSection: string read FServiceSection
      write SetServiceSection;
    property Language: string read FLanguage write SetLanguage;
    property DTime: string read FDtime write SetDTime;
    property Vpid: string read FVpid write FVpid;
  end;

  { ------ TRPCBroker ------ }
  { :This component, when placed on a form, allows design-time and run-time
    connection to the server by simply toggling the Connected property.
    Once connected you can access server data. }
  TRPCBroker = class(TComponent)
  private
  protected
    FShowCertDialog: boolean; //p73
    FBrokerVersion: String;
    FAccessVerifyCodes: TAccessVerifyCodes;
    FClearParameters: boolean;
    FClearResults: boolean;
    FConnected: boolean;
    FConnecting: boolean;
    FCurrentContext: String;
    FDebugMode: boolean;
    FListenerPort: integer;
    FParams: TParams;
    FResults: TStrings;
    FOnCallResultStr: String;
    FRemoteProcedure: TRemoteProc;
    FRpcVersion: TRpcVersion;
    FServer: TServer;
    FSocket: integer;
    FRPCTimeLimit: integer; // for adjusting client RPC duration timeouts
    FPulse: TTimer; // P6
    FKernelLogIn: boolean; // p13
    FLogIn: TVistaLogin; // p13
    FUser: TVistaUser; // p13
    FOnRPCBFailure: TOnRPCBFailure;
    FShowErrorMsgs: TShowErrorMsgs;
    FRPCBError: String;
    FOnPulseError: TOnPulseError;
    FSecurityPhrase: String; // BSE JLI 060130
    // Added from CCOWRPCBroker
    FCCOWLogonIDName: String;
    FCCOWLogonIDValue: String;
    FCCOWLogonName: String;
    FCCOWLogonNameValue: String;
    FContextor: TContextorControl; // CCOW
    FCCOWtoken: string; // CCOW
    FVistaDomain: String;
    FCCOWLogonVpid: String;
    FCCOWLogonVpidValue: String;
    FWasUserDefined: boolean;
    FOnRPCCall: TNotifyEvent;
    // end of values from CCOWRPCBroker
    // values for handling SSH tunnels
    FUseSecureConnection: TSecure;
    FSSHPort: String;
    FSSHUser: String;
    FSSHpw: String;
    FSSHhide: boolean;
    FLastServer: String;
    FLastPort: integer;
    // end SSH tunnel values
    // values for handling IAM STS tokens
    FSSOiTokenValue: String;
    FSSOiSECIDValue: String;
    FSSOiADUPNValue: String;
    FSSOiLogonNameValue: String;
    // end STS token values
    FIPsecSecurity: integer;
    FIPprotocol: integer;
    function GetCCOWHandle(ConnectedBroker: TRPCBroker): string;
    procedure CCOWsetUser(Uname, token, Domain, Vpid: string;
      Contextor: TContextorControl);
    function GetCCOWduz(Contextor: TContextorControl): string;
    procedure SetClearParameters(value: boolean); virtual;
    procedure SetClearResults(value: boolean); virtual;
    procedure SetConnected(value: boolean); virtual;
    procedure SetResults(value: TStrings); virtual;
    procedure SetServer(value: TServer); virtual;
    procedure SetRPCTimeLimit(value: integer); virtual;
    // Screen changes to timeout.
    procedure DoPulseOnTimer(Sender: TObject); virtual; // p6
    procedure SetKernelLogIn(const value: boolean); virtual;
    procedure SetUser(const value: TVistaUser); virtual;
    procedure CheckSSH;
    function getSSHPassWord: string;
    function getSSHUsername: string;
    function StartSecureConnection(var PseudoServer,
      PseudoPort: String): boolean;
  public
    XWBWinsock: TObject;
    property AccessVerifyCodes: TAccessVerifyCodes read FAccessVerifyCodes
      write FAccessVerifyCodes;
    property Param: TParams read FParams write FParams;
    property Socket: integer read FSocket;
    property RPCTimeLimit: integer read FRPCTimeLimit write SetRPCTimeLimit;
    destructor Destroy; override;
    procedure Call; virtual;
    procedure Loaded; override;
    procedure lstCall(OutputBuffer: TStrings); virtual;
    function pchCall: PChar; virtual;
    function strCall: string; virtual;
    function CreateContext(strContext: string): boolean; virtual;
    property CurrentContext: String read FCurrentContext;
    property User: TVistaUser read FUser write SetUser;
    property OnRPCBFailure: TOnRPCBFailure read FOnRPCBFailure
      write FOnRPCBFailure;
    property RPCBError: String read FRPCBError write FRPCBError;
    property OnPulseError: TOnPulseError read FOnPulseError write FOnPulseError;
    property BrokerVersion: String read FBrokerVersion;
    property SecurityPhrase: String read FSecurityPhrase write FSecurityPhrase;
    // BSE JLI 060130
    property OnCallResultStr: String read FOnCallResultStr;
    // brought in from CCOWRPCBroker
    function GetCCOWtoken(Contextor: TContextorControl): string;
    function IsUserCleared: boolean;
    function WasUserDefined: boolean;
    function IsUserContextPending(aContextItemCollection
      : IContextItemCollection): boolean;
    property Contextor: TContextorControl read FContextor write FContextor;
    // CCOW
    property CCOWLogonIDName: String read FCCOWLogonIDName;
    property CCOWLogonIDValue: String read FCCOWLogonIDValue;
    property CCOWLogonName: String read FCCOWLogonName;
    property CCOWLogonNameValue: String read FCCOWLogonNameValue;
    property CCOWLogonVpid: String read FCCOWLogonVpid;
    property CCOWLogonVpidValue: String read FCCOWLogonVpidValue;
    // added for secure connection via SSH
    property SSHport: String read FSSHPort write FSSHPort;
    property SSHUser: String read FSSHUser write FSSHUser;
    property SSHpw: String read FSSHpw write FSSHpw;
    property IPsecSecurity: integer read FIPsecSecurity write FIPsecSecurity;
    property IPprotocol: integer read FIPprotocol write FIPprotocol;
    // added for Single Sign-On with Identity and Access Management STS token
    property SSOiToken: String read FSSOiTokenValue write FSSOiTokenValue;
    property SSOiSECID: String read FSSOiSECIDValue write FSSOiSECIDValue;
    property SSOiADUPN: String read FSSOiADUPNValue write FSSOiADUPNValue;
    property SSOiLogonName: String read FSSOiLogonNameValue
      write FSSOiLogonNameValue;
  published
    constructor Create(AOwner: TComponent); override;
    property ShowCertDialog: boolean read FShowCertDialog
      write FShowCertDialog; //p73
    property ClearParameters: boolean read FClearParameters
      write SetClearParameters;
    property ClearResults: boolean read FClearResults write SetClearResults;
    property Connected: boolean read FConnected write SetConnected;
    property DebugMode: boolean read FDebugMode write FDebugMode default False;
    property ListenerPort: integer read FListenerPort write FListenerPort;
    property Results: TStrings read FResults write SetResults;
    property RemoteProcedure: TRemoteProc read FRemoteProcedure
      write FRemoteProcedure;
    property RpcVersion: TRpcVersion read FRpcVersion write FRpcVersion;
    property Server: TServer read FServer write SetServer;
    property KernelLogIn: boolean read FKernelLogIn write SetKernelLogIn;
    property ShowErrorMsgs: TShowErrorMsgs read FShowErrorMsgs
      write FShowErrorMsgs default semRaise;
    property LogIn: TVistaLogin read FLogIn write FLogIn; // SetLogIn;
    property OnRPCCall: TNotifyEvent read FOnRPCCall write FOnRPCCall;
    // added for secure connection via SSH
    property UseSecureConnection: TSecure read FUseSecureConnection
      write FUseSecureConnection;
    property SSHHide: boolean read FSSHhide write FSSHhide;
  end;

  { procedure Register; }  // P14 --pack split
procedure StoreConnection(Broker: TRPCBroker);
function RemoveConnection(Broker: TRPCBroker): boolean;
function DisconnectAll(Server: String; ListenerPort: integer): boolean;
function ExistingSocket(Broker: TRPCBroker): integer;
procedure AuthenticateUser(ConnectingBroker: TRPCBroker);
procedure GetBrokerInfo(ConnectedBroker: TRPCBroker); // P6
function NoSignOnNeeded: boolean;
function ProcessExecute(Command: String; cShow: Word): integer;
function GetAppHandle(ConnectedBroker: TRPCBroker): String;
function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;
procedure SSOiBindUser(ConnectedBroker: TRPCBroker);

var
  DebugData: string;
  BrokerConnections: TStringList;
  { this list stores all connections by socket number }
  BrokerAllConnections: TStringList;
  { this list stores all connections to all of
    the servers, by an application.  It's used in DisconnectAll }
  // The following 2 variables added to handle closing of command box for SSH
  CommandBoxProcessHandle: THandle;
  CommandBoxThreadHandle: THandle;

implementation

uses
  {VA}
  Loginfrm, RpcbErr, SelDiv, RpcSLogin, fRPCBErrMsg, Wsockc,
  CCOW_const, fPlinkpw, fSSHUsername, frmSignonMessage;

// This "include" file contains encrypted IAM_Binding pass phrase, IAM server URL,
// and SOAP message template
{$I IAMBase.inc}

var
  CCOWToken: String;
  Domain: String;
  PassCode1: String;
  PassCode2: String;

const
  DEFAULT_PULSE: integer = 81000; // P6 default = 45% of 3 minutes.
  MINIMUM_TIMEOUT: integer = 14; // P6 shortest allowable timeout in secs.
  PULSE_PERCENTAGE: integer = 45; // P6 % of timeout for pulse frequency.

  { -------------------------- TMult.Create --------------------------
    ------------------------------------------------------------------ }
constructor TMult.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMultiple := TStringList.Create;
end; // constructor TMult.Create

{ ------------------------- TMult.Destroy --------------------------
  ------------------------------------------------------------------ }
destructor TMult.Destroy;
begin
  ClearAll;
  FMultiple.Free;
  FMultiple := nil;
  inherited Destroy;
end; // destructor TMult.Destroy

{ -------------------------- TMult.Assign --------------------------
  All of the items from source object are copied one by one into the
  target.  So if the source is later destroyed, target object will continue
  to hold the copy of all elements, completely unaffected.
  ------------------------------------------------------------------ }
procedure TMult.Assign(Source: TPersistent);
var
  I: integer;
  SourceStrings: TStrings;
  S: TString;
  SourceMult: TMult;
begin
  ClearAll;
  if Source is TMult then
  begin
    SourceMult := Source as TMult;
    try
      for I := 0 to SourceMult.FMultiple.Count - 1 do
      begin
        S := TString.Create;
        S.Str := (SourceMult.FMultiple.Objects[I] as TString).Str;
        Self.FMultiple.AddObject(SourceMult.FMultiple[I], S);
      end; // for
    except
    end; // try
  end // if
  else
  begin
    SourceStrings := Source as TStrings;
    for I := 0 to SourceStrings.Count - 1 do
      Self[IntToStr(I)] := SourceStrings[I];
  end; // else
end; // procedure TMult.Assign

{ ------------------------- TMult.ClearAll -------------------------
  One by one, all Mult items are freed.
  ------------------------------------------------------------------ }
procedure TMult.ClearAll;
var
  I: integer;
begin
  for I := 0 to FMultiple.Count - 1 do
  begin
    FMultiple.Objects[I].Free;
    FMultiple.Objects[I] := nil;
  end; // for
  FMultiple.Clear;
end; // procedure TMult.ClearAll

{ ------------------------- TMult.GetCount -------------------------
  Returns the number of elements in the multiple
  ------------------------------------------------------------------ }
function TMult.GetCount: Word;
begin
  Result := FMultiple.Count;
end; // function TMult.GetCount

{ ------------------------- TMult.GetFirst -------------------------
  Returns the subscript of the first element in the multiple
  ------------------------------------------------------------------ }
function TMult.GetFirst: string;
begin
  if FMultiple.Count > 0 then
    Result := FMultiple[0]
  else
    Result := '';
end; // function TMult.GetFirst

{ ------------------------- TMult.GetLast --------------------------
  Returns the subscript of the last element in the multiple
  ------------------------------------------------------------------ }
function TMult.GetLast: string;
begin
  if FMultiple.Count > 0 then
    Result := FMultiple[FMultiple.Count - 1]
  else
    Result := '';
end; // function TMult.GetLast

{ ---------------------- TMult.GetFMultiple ------------------------
  Returns the VALUE of the element whose subscript is passed.
  ------------------------------------------------------------------ }
function TMult.GetFMultiple(Index: string): string;
var
  S: TString;
  BrokerComponent, ParamRecord: TComponent;
  I: integer;
  strError: string;
begin
  try
    S := TString(FMultiple.Objects[FMultiple.IndexOf(Index)]);
  except
    on EListError do
    begin
      { build appropriate error message }
      strError := iff(Self.Name <> '', Self.Name, 'TMult_instance');
      strError := strError + '[' + Index + ']' + #13#10 + 'is undefined';
      try
        ParamRecord := Self.Owner;
        BrokerComponent := Self.Owner.Owner.Owner;
        if (ParamRecord is TParamRecord) and (BrokerComponent is TRPCBroker)
        then
        begin
          I := 0;
          { if there is an easier way to figure out which array element points to
            this instance of a multiple, use it }   // p13
          while TRPCBroker(BrokerComponent).Param[I] <> ParamRecord do
            inc(I);
          strError := '.Param[' + IntToStr(I) + '].' + strError;
          strError := iff(BrokerComponent.Name <> '', BrokerComponent.Name,
            'TRPCBroker_instance') + strError;
        end; // if
      except
      end; // try
      raise Exception.Create(strError);
    end; // on EListError do
  end; // try
  Result := S.Str;
end; // function TMult.GetFMultiple

{ ---------------------- TMult.SetGetSorted ------------------------
  ------------------------------------------------------------------ }
function TMult.GetSorted: boolean;
begin
  Result := FMultiple.Sorted;
end; // function TMult.GetSorted

{ ---------------------- TMult.SetFMultiple ------------------------
  Stores a new element in the multiple.  FMultiple (TStringList) is the
  structure, which is used to hold the subscript and value pair.  Subscript
  is stored as the String, value is stored as an object of the string.
  ------------------------------------------------------------------ }
procedure TMult.SetFMultiple(Index: string; value: string);
var
  S: TString;
  Pos: integer;
begin
  Pos := FMultiple.IndexOf(Index); { see if this subscript already exists }
  if Pos = -1 then
  begin { if subscript is new }
    S := TString.Create; { create string object }
    S.Str := value; { put value in it }
    FMultiple.AddObject(Index, S); { add it }
  end // if
  else
    TString(FMultiple.Objects[Pos]).Str := value;
  { otherwise replace the value }
end; // procedure TMult.SetFMultiple

{ ---------------------- TMult.SetSorted ------------------------
  ------------------------------------------------------------------ }
procedure TMult.SetSorted(value: boolean);
begin
  FMultiple.Sorted := value;
end; // procedure TMult.GetSorted

{ -------------------------- TMult.Order --------------------------
  Returns the subscript string of the next or previous element from the
  StartSubscript.  This is very similar to the $O function available in M.
  Null string ('') is returned when reaching beyong the first or last
  element, or when list is empty.
  Note: A major difference between the M $O and this function is that
  in this function StartSubscript must identify a valid subscript
  in the list.
  ------------------------------------------------------------------ }
function TMult.Order(const StartSubscript: string; Direction: integer): string;
var
  Index: longint;
begin
  Result := '';
  if StartSubscript = '' then
    if Direction > 0 then
      Result := First
    else
      Result := Last
  else
  begin
    Index := Position(StartSubscript);
    if Index > -1 then
      if (Index < (Count - 1)) and (Direction > 0) then
        Result := FMultiple[Index + 1]
      else if (Index > 0) and (Direction < 0) then
        Result := FMultiple[Index - 1];
  end // else
end; // function TMult.Order

{ ------------------------- TMult.Position -------------------------
  Returns the long integer value which is the index position of the
  element in the list.  Opposite of TMult.Subscript().  Remember that
  the list is 0 based!
  ------------------------------------------------------------------ }
function TMult.Position(const Subscript: string): longint;
begin
  Result := FMultiple.IndexOf(Subscript);
end; // TMult.Position

{ ------------------------ TMult.Subscript -------------------------
  Returns the string subscript of the element whose position in the list
  is passed in.  Opposite of TMult.Position().  Remember that the list is 0 based!
  ------------------------------------------------------------------ }
function TMult.Subscript(const Position: longint): string;
begin
  Result := '';
  if (Position > -1) and (Position < Count) then
    Result := FMultiple[Position];
end; // function TMult.Subscript

{ ---------------------- TParamRecord.Create -----------------------
  Creates TParamRecord instance and automatically creates TMult.  The
  name of Mult is also set in case it may be need if exception will be raised.
  ------------------------------------------------------------------ }
constructor TParamRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMult := TMult.Create(Self);
  FMult.Name := 'Mult';
  { note: FMult is destroyed in the SetClearParameters method }
end; // constructor TParamRecord.Create

{ ------------------------- TParamRecord.Destroy -------------------------
  ------------------------------------------------------------------ }
destructor TParamRecord.Destroy;
begin
  FMult.Free;
  FMult := nil;
  inherited;
end; // destructor TParamRecord.Destroy

{ ------------------------- TParams.Create -------------------------
  ------------------------------------------------------------------ }
constructor TParams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParameters := TList.Create; { for now, empty list }
end; // constructor TParams.Create

{ ------------------------ TParams.Destroy -------------------------
  ------------------------------------------------------------------ }
destructor TParams.Destroy;
begin
  Clear; { clear the Multiple first! }
  FreeAndNil(FParameters);
  inherited;
end; // destructor TParams.Destroy

{ ------------------------- TParams.Assign -------------------------
  ------------------------------------------------------------------ }
procedure TParams.Assign(Source: TPersistent);
var
  I: integer;
  SourceParams: TParams;
begin
  Self.Clear;
  SourceParams := Source as TParams;
  for I := 0 to SourceParams.Count - 1 do
  begin
    Self[I].value := SourceParams[I].value;
    Self[I].PType := SourceParams[I].PType;
    Self[I].Mult.Assign(SourceParams[I].Mult);
  end // for
end; // procedure TParams.Assign

{ ------------------------- TParams.Clear --------------------------
  ------------------------------------------------------------------ }
procedure TParams.Clear;
var
  ParamRecord: TParamRecord;
  I: integer;
begin
  if FParameters <> nil then
  begin
    for I := 0 to FParameters.Count - 1 do
    begin
      ParamRecord := TParamRecord(FParameters.Items[I]);
      if ParamRecord <> nil then
      begin // could be nil if params were skipped by developer
        ParamRecord.FMult.Free;
        ParamRecord.FMult := nil;
        ParamRecord.Free;
      end; // if
    end; // for
    FParameters.Clear; { release FParameters TList }
  end; // if
end; // procedure TParams.Clear

{ ------------------------ TParams.GetCount ------------------------
  ------------------------------------------------------------------ }
function TParams.GetCount: Word;
begin
  if FParameters = nil then
    Result := 0
  else
    Result := FParameters.Count;
end; // function TParams.GetCount

{ ---------------------- TParams.GetParameter ----------------------
  ------------------------------------------------------------------ }
function TParams.GetParameter(Index: integer): TParamRecord;
begin
  if Index >= FParameters.Count then { if element out of bounds, }
    while FParameters.Count <= Index do
      FParameters.Add(nil); { setup place holders }
  if FParameters.Items[Index] = nil then
  begin { if just a place holder, }
    { point it to new memory block }
    FParameters.Items[Index] := TParamRecord.Create(Self);
    TParamRecord(FParameters.Items[Index]).PType := undefined; { initialize }
  end; // if
  Result := FParameters.Items[Index]; { return requested parameter }
end; // function TParams.GetParameter

{ ---------------------- TParams.SetParameter ----------------------
  ------------------------------------------------------------------ }
procedure TParams.SetParameter(Index: integer; Parameter: TParamRecord);
begin
  if Index >= FParameters.Count then { if element out of bounds, }
    while FParameters.Count <= Index do
      FParameters.Add(nil); { setup place holders }
  if FParameters.Items[Index] = nil then { if just a place holder, }
    FParameters.Items[Index] := Parameter; { point it to passed parameter }
end; // procedure TParams.SetParameter

{ ------------------------ TRPCBroker.Create -----------------------
  ------------------------------------------------------------------ }
constructor TRPCBroker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { set defaults }
  // This constant defined in the interface section needs to be updated for each release
  FBrokerVersion := CURRENT_RPC_VERSION;
  FClearParameters := boolean(StrToInt(ReadRegDataDefault(HKLM, REG_BROKER,
    'ClearParameters', '1')));
  FClearResults := boolean(StrToInt(ReadRegDataDefault(HKLM, REG_BROKER,
    'ClearResults', '1')));
  FDebugMode := False;
  FParams := TParams.Create(Self);
  FResults := TStringList.Create;
  FServer := ReadRegDataDefault(HKLM, REG_BROKER, 'Server', 'BROKERSERVER');
  FPulse := TTimer.Create(Self); // P6
  FListenerPort := StrToInt(ReadRegDataDefault(HKLM, REG_BROKER,
    'ListenerPort', '9200'));
  FRpcVersion := '0';
  FRPCTimeLimit := MIN_RPCTIMELIMIT;
  with FPulse do
  /// P6
  begin
    Enabled := False; // P6
    Interval := DEFAULT_PULSE; // P6
    OnTimer := DoPulseOnTimer; // P6
  end; // with
  FLogIn := TVistaLogin.Create(Application); // p13
  FKernelLogIn := True; // p13
  FUser := TVistaUser.Create; // p13
  FShowErrorMsgs := semRaise; // p13
  XWBWinsock := TXWBWinsock.Create;
  Application.ProcessMessages;
end; // constructor TRPCBroker.Create

{ ----------------------- TRPCBroker.Destroy -----------------------
  ------------------------------------------------------------------ }
destructor TRPCBroker.Destroy;
begin
  Connected := False;
  if XWBWinsock <> nil then
    FreeAndNil(XWBWinsock);
  FreeAndNil(FParams);
  FreeAndNil(FResults);
  FreeAndNil(FPulse); // P6
  FreeAndNil(FUser);
  FreeAndNil(FLogIn);
  inherited;
end; // destructor TRPCBroker.Destroy

{ --------------------- TRPCBroker.CreateContext -------------------
  This function is part of the overall Broker security.
  The passed context string is essentially a Client/Server type option
  on the server.  The server sets up MenuMan environment variables for this
  context which will later be used to screen RPCs.  Only those RPCs which are
  in the multiple field of this context option will be permitted to run.
  ------------------------------------------------------------------ }
function TRPCBroker.CreateContext(strContext: string): boolean;
var
  InternalBroker: TRPCBroker; { use separate component }
  Str: String;
begin
  // Result := False;
  Connected := True;
  InternalBroker := nil;
  try
    InternalBroker := TRPCBroker.Create(Application);
    InternalBroker.FSocket := Self.Socket;
    // p13 -- permits multiple broker connections to same server/port
    with InternalBroker do
    begin
      Tag := 1234;
      ShowErrorMsgs := Self.ShowErrorMsgs;
      Server := Self.Server; { inherit application server }
      ListenerPort := Self.ListenerPort; { inherit listener port }
      DebugMode := Self.DebugMode; { inherit debug mode property }
      RemoteProcedure := 'XWB CREATE CONTEXT'; { set up RPC }
      Param[0].PType := literal;
      Param[0].value := Encrypt(strContext);
      try
        Str := strCall;
        if Str = '1' then
        begin // make the call  // p13
          Result := True; // p13
          Self.FCurrentContext := strContext; // p13
        end // if                                    // p13
        else
        begin
          Result := False;
          Self.FCurrentContext := '';
        end; // else
      except // Code added to return False if User doesn't have access
        on e: EBrokerError do
        begin
          Self.FCurrentContext := '';
          if Pos('does not have access to option', e.Message) > 0 then
          begin
            Result := False
          end // if
          else
            Raise;
        end; // on e: EBrokerError do
      end; // try
      if RPCBError <> '' then
        Self.RPCBError := RPCBError;
    end; // with InternalBroker do
  finally
    // InternalBroker.XWBWinsock := nil;
    FreeAndNil(InternalBroker); { release memory }
  end; // try
end; // function TRPCBroker.CreateContext

{ ------------------------ TRPCBroker.Loaded -----------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.Loaded;
begin
  inherited Loaded;
end; // procedure TRPCBroker.Loaded

{ ------------------------- TRPCBroker.Call ------------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.Call;
var
  ResultBuffer: TStrings;
begin
  ResultBuffer := TStringList.Create;
  try
    if ClearResults then
      ClearResults := True;
    lstCall(ResultBuffer);
    Self.Results.AddStrings(ResultBuffer);
  finally
    FreeAndNil(ResultBuffer);
  end; // try
end; // procedure TRPCBroker.Call

{ ----------------------- TRPCBroker.lstCall -----------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.lstCall(OutputBuffer: TStrings);
var
  ManyStrings: PChar;
begin
  ManyStrings := pchCall; { make the call }
  OutputBuffer.SetText(ManyStrings); { parse result of call, format as list }
  StrDispose(ManyStrings); { raw result no longer needed, get back mem }
end; // procedure TRPCBroker.1stCall

{ ----------------------- TRPCBroker.strCall -----------------------
  ------------------------------------------------------------------ }
function TRPCBroker.strCall: string;
var
  ResultString: PChar;
begin
  ResultString := pchCall; { make the call }
  Result := StrPas(ResultString); { convert and present as Pascal string }
  StrDispose(ResultString); { raw result no longer needed, get back mem }
end; // function TRPCBroker.strCall

{ --------------------- TRPCBroker.SetConnected --------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetConnected(value: boolean);
var
  thisOwner: TComponent;
  RPCBContextor: TContextorControl;
  thisParent: TForm;
  // BrokerDir, Str1, Str2, Str3 :string;
  Str1, Str2, Str3: string;
  PseudoPort: integer;
  PseudoServer, PseudoPortStr: String;
begin
  RPCBError := '';
  LogIn.ErrorText := '';
  if (Connected <> value) and not(csReading in ComponentState) then
  begin
    if value and (FConnecting <> value) then
    begin { connect }
      // if change servers, clear STS token values (refresh token)
      if not(FLastServer = '') then
      begin
        if (not(FLastServer = Server)) or (not(FLastPort = ListenerPort)) then
        begin
          SSOiToken := '';
          SSOiSECID := '';
          SSOiADUPN := '';
          SSOiLogonName := '';
          IPsecSecurity := 0;
          IPprotocol := 0;
        end; // if
      end; // if
      FLastServer := Server;
      FLastPort := ListenerPort;
      FSocket := ExistingSocket(Self);
      FConnecting := True; // FConnected := True;
      try
        if FSocket = 0 then
        begin
          if DebugMode then
          begin
            Str1 := 'Control of debugging has been moved from the client to the server. To start a Debug session, do the following:'
              + #13#10#13#10;
            Str2 := '1. On the server, set initial breakpoints where desired.' +
              #13#10 + '2. DO DEBUG^XWBTCPM.' + #13#10 +
              '3. Enter a unique Listener port number (i.e., a port number not in general use).'
              + #13#10;
            Str3 := '4. Connect the client application using the port number entered in Step #3.';
            ShowMessage(Str1 + Str2 + Str3);
          end; // if
          // TODO - CheckSSH and FUseSecureConnection will be obsolete when NetworkConnect uses best security method
          CheckSSH;
          if not(FUseSecureConnection = secureNone) then
          begin
            if not StartSecureConnection(PseudoServer, PseudoPortStr) then
              exit;
            PseudoPort := StrToInt(PseudoPortStr);
          end // if
          else
          begin
            PseudoPort := ListenerPort;
            PseudoServer := Server;
          end; // else
          // TODO - Implement native SSL/TLS using Windows SChannel in Wsockc.NetworkConnect
          // Should I back up to above and initialize SSPI in StartSecureConnection?
          FSocket := TXWBWinsock(XWBWinsock).NetworkConnect(DebugMode,
            PseudoServer, PseudoPort, FRPCTimeLimit);
          // TODO - Code appears to continue at this point even if connection fails. Should there be an "if" here?
          AuthenticateUser(Self);
          StoreConnection(Self); // MUST store connection before CreateContext()
          SSOiToken := '';
          // Clear SSOiToken so a new one must be obtained for subsequent logins
          // CCOW start
          if (FContextor <> nil) and (length(CCOWToken) = 0) then
          begin
            // Get new CCOW token
            CCOWToken := GetCCOWHandle(Self);
            if length(CCOWToken) > 0 then
            begin
              try
                RPCBContextor := TContextorControl.Create(Application);
                RPCBContextor.Run('BrokerLoginModule#', PassCode1 + PassCode2,
                  True, '*');
                CCOWsetUser(User.Name, CCOWToken, Domain, User.Vpid,
                  RPCBContextor); // Clear token
                FCCOWLogonIDName := CCOW_LOGON_ID;
                FCCOWLogonIDValue := Domain;
                FCCOWLogonName := CCOW_LOGON_NAME;
                FCCOWLogonNameValue := User.Name;
                if User.Name <> '' then
                  FWasUserDefined := True;
                FCCOWLogonVpid := CCOW_LOGON_VPID;
                FCCOWLogonVpidValue := User.Vpid;
                RPCBContextor.Free;
                RPCBContextor := nil;
              except
                ShowMessage('Problem with Contextor.Run');
                FreeAndNil(RPCBContextor);
              end; // try
            end; // if Length(CCOWToken) > 0
          end; // if
          // CCOW end
          FPulse.Enabled := True; // P6 Start heartbeat.
          CreateContext(''); // Closes XUS SIGNON context.
        end // if FSocket = 0
        else
        begin // p13
          StoreConnection(Self);
          FPulse.Enabled := True; // p13
        end; // else                     //p13
        FConnected := True; // jli mod 12/17/01
        FConnecting := False;
        // 080620 If connected via SSH, With no command box
        // visible, should let users know they have it.
        if not(CommandBoxProcessHandle = 0) then
        begin
          thisOwner := Self.Owner;
          if (thisOwner is TForm) then
          begin
            thisParent := TForm(Self.Owner);
            if not(Pos('(SSH Secure connection)', thisParent.Caption) > 0) then
              thisParent.Caption := thisParent.Caption +
                ' (SSH Secure connection)';
          end; // if
        end; // if
      except
        on e: EBrokerError do
        begin
          if e.Code = XWB_BadSignOn then
            TXWBWinsock(XWBWinsock).NetworkDisconnect(FSocket);
          FSocket := 0;
          FConnected := False;
          FConnecting := False;
          if not(CommandBoxProcessHandle = 0) then
            TerminateProcess(CommandBoxProcessHandle, 10);
          FRPCBError := e.Message; // p13  handle errors as specified
          if LogIn.ErrorText <> '' then
            FRPCBError := e.Message + chr(10) + LogIn.ErrorText;
          if Assigned(FOnRPCBFailure) then // p13
            FOnRPCBFailure(Self) // p13
          else if ShowErrorMsgs = semRaise then
            raise; // this is where I would do OnNetError
        end; // on
      end; // try
    end // if
    else if not value then
    begin // p13
      FConnected := False; // p13
      FPulse.Enabled := False; // p13
      if RemoveConnection(Self) = NoMore then
      begin
        { FPulse.Enabled := False;  ///P6;p13 }
        TXWBWinsock(XWBWinsock).NetworkDisconnect(Socket);
        { actually disconnect from server }
        FSocket := 0; { store internal }
        // FConnected := False;      //p13
        // 080618 following added to close command box if SSH is being used
        if not(CommandBoxProcessHandle = 0) then
        begin
          TerminateProcess(CommandBoxProcessHandle, 10);
          thisOwner := Self.Owner;
          if (thisOwner is TForm) then
          begin
            thisParent := TForm(Self.Owner);
            if (Pos('(SSH Secure connection)', thisParent.Caption) > 0) then
            begin
              // 080620 remove ' (SSH Secure connection)' on disconnection
              thisParent.Caption := Copy(thisParent.Caption, 1,
                length(thisParent.Caption) - 24);
            end; // if
          end; // if
        end; // if
      end; // if
    end; // else
  end; // if
end; // procedure TRPCBroker.SetConnected

{ ----------------- TRPCBroker.SetClearParameters ------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetClearParameters(value: boolean);
begin
  if value then
    FParams.Clear;
  FClearParameters := value;
end; // procedure TRPCBroker.SetClearParameters

{ ------------------- TRPCBroker.SetClearResults -------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetClearResults(value: boolean);
begin
  if value then
  begin { if True }
    FResults.Clear;
  end;
  FClearResults := value;
end; // procedure TRPCBroker.SetClearResults

{ ---------------------- TRPCBroker.SetResults ---------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetResults(value: TStrings);
begin
  FResults.Assign(value);
end; // procedure TRPCBroker.SetResults

{ ----------------------- TRPCBroker.SetRPCTimeLimit -----------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetRPCTimeLimit(value: integer);
begin
  if value <> FRPCTimeLimit then
    if value > MIN_RPCTIMELIMIT then
      FRPCTimeLimit := value
    else
      FRPCTimeLimit := MIN_RPCTIMELIMIT;
end; // procedure TRPCBroker.SetRPCTimeLimit

{ ----------------------- TRPCBroker.SetServer ---------------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetServer(value: TServer);
begin
  { if changing the name of the server, make sure to disconnect first }
  if (value <> FServer) and Connected then
  begin
    Connected := False;
  end; // if
  FServer := value;
end; // procedure TRPCBroker.SetServer

{ --------------------- TRPCBroker.pchCall ----------------------
  Lowest level remote procedure call that a TRPCBroker component can make.
  1. Returns PChar.
  2. Converts Remote Procedure to PChar internally.
  ------------------------------------------------------------------ }
function TRPCBroker.pchCall: PChar;
var
  value, Sec, App: PChar;
  BrokerError: EBrokerError;
  blnRestartPulse: boolean; // P6
begin
  RPCBError := '';
  Connected := True;
  BrokerError := nil;
  value := nil;
  blnRestartPulse := False; // P6
  Sec := StrAlloc(255);
  App := StrAlloc(255);
  try
    if FPulse.Enabled then // P6 If Broker was sending pulse,
    begin
      FPulse.Enabled := False; // Stop pulse &
      blnRestartPulse := True; // Set flag to restart pulse after RPC.
    end; // if
    try
      value := TXWBWinsock(XWBWinsock).tCall(Socket, RemoteProcedure,
        RpcVersion, Param, Sec, App, FRPCTimeLimit);
      if (StrLen(Sec) > 0) then
      begin
        BrokerError := EBrokerError.Create(StrPas(Sec));
        BrokerError.Code := 0;
        BrokerError.Action := 'Error Returned';
      end; // if
    except
      on Etemp: EBrokerError do
        with Etemp do
        begin // save copy of error
          BrokerError := EBrokerError.Create(message); // field by field
          BrokerError.Action := Action;
          BrokerError.Code := Code;
          BrokerError.Mnemonic := Mnemonic;
          if value <> nil then
            StrDispose(value);
          value := StrNew('');
          // TODO - Develop function to test the link
          { if severe error, mark connection as closed.  Per Enrique, we should
            replace this check with some function, yet to be developed, which
            will test the link. }
          if ((Code >= 10050) and (Code <= 10058)) or
            (Action = 'connection lost') then
          begin
            Connected := False;
            blnRestartPulse := False; // P6
          end; // if
        end; // with
    end; // try
  finally
    StrDispose(Sec); { do something with these }
    Sec := nil;
    StrDispose(App);
    App := nil;
    if Assigned(FOnRPCCall) then
    begin
      Result := value;
      if Result = nil then
        Result := StrNew('');
      Self.FOnCallResultStr := Result;
      FOnRPCCall(Self);
    end; // if
    if ClearParameters then
      ClearParameters := True; // prepare for next call
  end; // try
  Result := value;
  if Result = nil then
    Result := StrNew(''); // return empty string
  if blnRestartPulse then
    FPulse.Enabled := True; // Restart pulse. (P6)
  if BrokerError <> nil then
  begin
    FRPCBError := BrokerError.Message; // p13  handle errors as specified
    if LogIn.ErrorText <> '' then
      FRPCBError := BrokerError.Message + chr(10) + LogIn.ErrorText;
    if Assigned(FOnRPCBFailure) then // p13
    begin
      FOnRPCBFailure(Self);
      StrDispose(Result);
      // if CurrentContext <> '' then         //p65 reset context if RPC errors out (context gets cleared in VistA)
      // p71 the above code prevented unattended reconnects, adding and connected allows applications like
      // VistA Imaging Background Processor to reconnect without intervention while preserving the
      // original intent of the p65 code
      if ((CurrentContext <> '') and Connected) then // p71 added and connected)
        CreateContext(CurrentContext);
    end
    else if FShowErrorMsgs = semRaise then
    begin
      StrDispose(Result); // return memory we won't use - caused a memory leak
      raise BrokerError; // p13
    end // if
    else // silent, just return error message in FRPCBError
      BrokerError.Free;
    // return memory in BrokerError - otherwise is a memory leak
    // raise;   //this is where I would do OnNetError?
  end; // if BrokerError <> nil
end; // function TRPCBroker.pchCall

{ -------------------------- DisconnectAll -------------------------
  Find all connections in BrokerAllConnections list for the passed in
  server/listenerport combination and disconnect them. If at least one
  connection to the server/listenerport is found, then it and all other
  Brokers to the same server/listenerport will be disconnected; True
  will be returned.  Otherwise False will return.
  ------------------------------------------------------------------ }
function DisconnectAll(Server: string; ListenerPort: integer): boolean;
var
  Index: integer;
begin
  Result := False;
  while (Assigned(BrokerAllConnections) and
    (BrokerAllConnections.Find(Server + '/' + IntToStr(ListenerPort),
    Index))) do
  begin
    Result := True;
    TRPCBroker(BrokerAllConnections.Objects[Index]).Connected := False;
    { if the call above disconnected the last connection in the list, then
      the whole list will be destroyed, making it necessary to check if it's
      still assigned. }
  end; // while
end; // function DisconnectAll

{ ------------------------- StoreConnection ------------------------
  Each broker connection is stored in BrokerConnections list.
  ------------------------------------------------------------------ }
procedure StoreConnection(Broker: TRPCBroker);
begin
  if BrokerConnections = nil then { list is created when 1st entry is added }
    try
      BrokerConnections := TStringList.Create;
      BrokerConnections.Sorted := True;
      BrokerConnections.Duplicates := dupAccept; { store every connection }
      BrokerAllConnections := TStringList.Create;
      BrokerAllConnections.Sorted := True;
      BrokerAllConnections.Duplicates := dupAccept;
    except
      TXWBWinsock(Broker.XWBWinsock).NetError('store connection',
        XWB_BldConnectList)
    end; // try
  BrokerAllConnections.AddObject(Broker.Server + '/' +
    IntToStr(Broker.ListenerPort), Broker);
  BrokerConnections.AddObject(IntToStr(Broker.Socket), Broker);
end; // procedure StoreConnection

{ ------------------------ RemoveConnection ------------------------
  Result of this function will be False, if there are no more connections
  to the same server/listenerport as the passed in Broker.  If at least
  one other connection is found to the same server:listenerport, then Result
  will be True.
  ------------------------------------------------------------------ }
function RemoveConnection(Broker: TRPCBroker): boolean;
var
  Index: integer;
begin
  Result := False;
  if Assigned(BrokerConnections) then
  begin
    { remove connection record of passed in Broker component }
    BrokerConnections.Delete(BrokerConnections.IndexOfObject(Broker));
    { look for one other connection to the same server/port }
    Result := BrokerConnections.Find(IntToStr(Broker.Socket), Index);
    if BrokerConnections.Count = 0 then
    begin { if last entry removed, }
      BrokerConnections.Free; { destroy whole list structure }
      BrokerConnections := nil;
    end; // if
  end; // if Assigned(BrokerConnections)
  if Assigned(BrokerAllConnections) then
  begin
    BrokerAllConnections.Delete(BrokerAllConnections.IndexOfObject(Broker));
    if BrokerAllConnections.Count = 0 then
    begin
      FreeAndNil(BrokerAllConnections);
    end; // if
  end; // if Assigned(BrokerAllConnections)
end; // function RemoveConnection

{ ------------------------- ExistingSocket -------------------------
  ------------------------------------------------------------------ }
function ExistingSocket(Broker: TRPCBroker): integer;
begin
  Result := Broker.Socket;
end; // function ExistingSocket

{ ------------------------ AuthenticateUser ------------------------
  ------------------------------------------------------------------ }
procedure AuthenticateUser(ConnectingBroker: TRPCBroker);
var
  SaveClearParmeters, SaveClearResults: boolean;
  SaveParam: TParams;
  SaveRemoteProcedure, SaveRpcVersion: string;
  SaveResults: TStrings;
  blnSignedOn: boolean;
  SaveKernelLogin: boolean;
  SaveVistaLogin: TVistaLogin;
  OldExceptionHandler: TExceptionEvent;
  OldHandle: THandle;
  thisSSOiToken: TXWBSSOiToken;
  currentSSOiToken: String;
begin
  with ConnectingBroker do
  begin
    SaveParam := TParams.Create(nil);
    SaveParam.Assign(Param); // save off settings
    SaveRemoteProcedure := RemoteProcedure;
    SaveRpcVersion := RpcVersion;
    SaveResults := Results;
    SaveClearParmeters := ClearParameters;
    SaveClearResults := ClearResults;
    ClearParameters := True; // set'em as I need'em
    ClearResults := True;
    SaveKernelLogin := KernelLogIn; // p13
    SaveVistaLogin := FLogIn; // p13
  end; // with
  try
    currentSSOiToken := '';
    blnSignedOn := False; // Initialize to bad sign-on
    // Silent AV Code start
    if ConnectingBroker.AccessVerifyCodes <> '' then
    begin
      ConnectingBroker.LogIn.AccessCode :=
        Piece(ConnectingBroker.AccessVerifyCodes, ';', 1);
      ConnectingBroker.LogIn.VerifyCode :=
        Piece(ConnectingBroker.AccessVerifyCodes, ';', 2);
      ConnectingBroker.LogIn.Mode := lmAVCodes;
      ConnectingBroker.KernelLogIn := False;
    end;
    // Silent AV Code end
    // CCOW start
    if ConnectingBroker.KernelLogIn and (not(ConnectingBroker.Contextor = nil))
    then
    begin
      CCOWToken := ConnectingBroker.GetCCOWtoken(ConnectingBroker.Contextor);
      if length(CCOWToken) > 0 then
      begin
        ConnectingBroker.LogIn.LogInHandle := CCOWToken;
        ConnectingBroker.LogIn.Mode := lmAppHandle;
        ConnectingBroker.KernelLogIn := False;
      end;
    end;
    // CCOW end
    // Try a silent login
    if not ConnectingBroker.KernelLogIn then
    begin
      if ConnectingBroker.FLogIn <> nil then
        blnSignedOn := SilentLogin(ConnectingBroker);
      // SilentLogin in RpcSLogin unit
      if not blnSignedOn then // Fail over to SSOi
      begin
        ConnectingBroker.KernelLogIn := True;
        ConnectingBroker.LogIn.Mode := lmSSOi;
        ConnectingBroker.Contextor := nil;
        // Set Contextor nil so it won't try to set token
      end // if not blnSignedOn
      else // if blnSignedOn
        GetBrokerInfo(ConnectingBroker);
    end; // if not ConnectingBroker.FKernelLogIn (silent login)
    // SSOi start
    // TODO - Login.Mode is set to lmAVCodes before it gets here for all connections. Not sure why. Should give developers a choice.
    // if (not blnsignedon) and (ConnectingBroker.KernelLogin) and (not (ConnectingBroker.Login.Mode = lmAVCodes)) then
    // if (not blnsignedon) and (ConnectingBroker.KernelLogIn = True) then
    // p71 the code above was preventing BSE connections from working properly, users were being
    // promoted for their credentials on the remote VistA connection, adding another check to the code
    // allows the BSE login to work properly,  Added and (ConnectingBroker.SecurityPhrase = '')
    if (not blnSignedOn) and (ConnectingBroker.KernelLogIn = True) and
      (ConnectingBroker.SecurityPhrase = '') then
    // p71 added and (ConnectingBroker.SecurityPhrase = '') in line above
    begin
      // Set SSOi token values (get token from IAM).
      try
        XWBSSOi.ShowCertDialog := ConnectingBroker.ShowCertDialog;
        thisSSOiToken := TXWBSSOiToken.Create(Application);
        currentSSOiToken := thisSSOiToken.SSOiToken;
        ConnectingBroker.SSOiToken := currentSSOiToken;
        ConnectingBroker.SSOiSECID := thisSSOiToken.SSOiSECID;
        ConnectingBroker.SSOiADUPN := thisSSOiToken.SSOiADUPN;
        ConnectingBroker.SSOiLogonName := thisSSOiToken.SSOiLogonName;
        FreeAndNil(thisSSOiToken);
      finally
        if currentSSOiToken <> '' then
        begin
          ConnectingBroker.LogIn.LogInHandle := ConnectingBroker.SSOiToken;
          ConnectingBroker.LogIn.Mode := lmSSOi;
          ConnectingBroker.KernelLogIn := False;
        end;
      end; // try
      // Try a silent login for SSOi
      if (ConnectingBroker.LogIn.Mode = lmSSOi) and
        (ConnectingBroker.KernelLogIn = False) then
      begin
        if ConnectingBroker.FLogIn <> nil then
          blnSignedOn := SilentLogin(ConnectingBroker);
        // SilentLogin in RpcSLogin unit
        if not blnSignedOn then // Fail over to Access/Verify Codes
        begin
          ConnectingBroker.KernelLogIn := True;
          ConnectingBroker.LogIn.Mode := lmAVCodes;
          ConnectingBroker.Contextor := nil;
          // Set Contextor nil so it won't try to set token
        end // if not blnSignedOn
        else // if blnSignedOn
        begin
          GetBrokerInfo(ConnectingBroker);
          // Create in frmSignonMessage unit
          frmSignonMsg := TfrmSignonMsg.Create(Application);
          try
            // ShowApplicationAndFocusOK(Application);
            OldHandle := GetForegroundWindow;
            SetForegroundWindow(frmSignonMsg.Handle);
            PrepareSignonMessage(ConnectingBroker);
            if SetUpMessage then // SetUpMessage in frmSignonMessage unit
            begin // True if Message should be displayed
              frmSignonMsg.ShowModal;
              //FreeAndNil(frmSignonMsg);
              // Show Sign-on Message (VA Handbook 6500 requirement)
            end;
          finally
            FreeAndNil(frmSignonMsg);
            ShowApplicationAndFocusOK(Application);
          end; // try
          if not SelDiv.ChooseDiv('', ConnectingBroker) then
          begin
            blnSignedOn := False;
            ConnectingBroker.KernelLogIn := False;
            // Do not fail over to A/V codes
            ConnectingBroker.LogIn.ErrorText := 'Failed to select Division';
            // p13 set some text indicating problem
          end;
          SetForegroundWindow(OldHandle);
        end; // if blnSignedOn
      end; // if not ConnectingBroker.FKernelLogIn (silent login)
    end;
    // SSOi end
    // Fall back to Access/Verify code login (prompted login)
    if (not blnSignedOn) and (ConnectingBroker.KernelLogIn = True) then
    begin // p13
      CCOWToken := ''; // Didn't sign on with Token; clear it so can get new one
      if Assigned(Application.OnException) then
        OldExceptionHandler := Application.OnException
      else
        OldExceptionHandler := nil;
      Application.OnException := TfrmErrMsg.RPCBShowException;
        frmSignon := TfrmSignon.Create(Nil); // Create in Loginfrm unit
      try
        ShowApplicationAndFocusOK(Application);
        OldHandle := GetForegroundWindow;
        SetForegroundWindow(frmSignon.Handle);
        PrepareSignonForm(ConnectingBroker);
        if SetUpSignOn then // SetUpSignOn in Loginfrm unit.
        begin // True if signon needed
          frmSignon.ShowModal; // do interactive logon   // p13
          if frmSignon.Tag = 1 then // Tag=1 for good logon
            blnSignedOn := True; // Successful logon
        end // if SetUpSignOn
        else
          // blnSignedOn := False;
          // p71 the code above was preventing BSE logins from working properly, setting blnSignedOn to
          // true will allow the connection to the remote VistA site
          blnSignedOn := True; // p71 set to true to allow BSE to work properly
        if blnSignedOn then // If logged on, retrieve user info.
        begin
          GetBrokerInfo(ConnectingBroker);
          if not SelDiv.ChooseDiv('', ConnectingBroker) then
          begin
            blnSignedOn := False;
            ConnectingBroker.LogIn.ErrorText := 'Failed to select Division';
            // Set some text indicating problem
          end; // if
        end; // if blnSignedOn
        SetForegroundWindow(OldHandle);
      finally
          FreeAndNil(frmSignOn);
        ShowApplicationAndFocusOK(Application);
      end; // try
      if Assigned(OldExceptionHandler) then
        Application.OnException := OldExceptionHandler;
      // Bind user to Active Directory for test accounts only
      if (currentSSOiToken <> '') and
        (ConnectingBroker.LogIn.IsProductionAccount = False) then
        SSOiBindUser(ConnectingBroker);
    end; // if ConnectingBroker.FKernelLogIn
  finally
    // reset the Broker
    with ConnectingBroker do
    begin
      ClearParameters := SaveClearParmeters;
      ClearResults := SaveClearResults;
      Param.Assign(SaveParam); // restore settings
      FreeAndNil(SaveParam);
      RemoteProcedure := SaveRemoteProcedure;
      RpcVersion := SaveRpcVersion;
      Results := SaveResults;
      FKernelLogIn := SaveKernelLogin; // p13
      FLogIn := SaveVistaLogin; // p13
    end; // with
  end; // try
  if not blnSignedOn then // Flag for unsuccessful signon.
  begin
    TXWBWinsock(ConnectingBroker.XWBWinsock).NetworkDisconnect
      (ConnectingBroker.FSocket);
    TXWBWinsock(ConnectingBroker.XWBWinsock).NetError('', XWB_BadSignOn);
    // Will raise error.
  end;
end; // procedure AuthenticateUser

{ ------------------------ GetBrokerInfo --------------------------
  P6  Retrieve information about user with XWB GET BROKER INFO
  RPC. For now, only Timeout value is retrieved in Results[0].
  P65 Also saves IPprotocol information for ConnectedBroker.
  ------------------------------------------------------------------ }
procedure GetBrokerInfo(ConnectedBroker: TRPCBroker);
begin
  GetUserInfo(ConnectedBroker);
  // p13  Get User info into User property (TVistaUser object)
  with ConnectedBroker do // (dcm) Use one of objects below
  begin // and skip this RPC? or make this and
    ConnectedBroker.IPprotocol := TXWBWinsock(ConnectedBroker.XWBWinsock)
      .IPprotocol;
    RemoteProcedure := 'XWB GET BROKER INFO'; // others below as components
    try
      Call;
      if Results.Count > 0 then
        if StrToInt(Results[0]) > MINIMUM_TIMEOUT then
          FPulse.Interval := (StrToInt(Results[0]) * 10 * PULSE_PERCENTAGE);
    except
      on e: EBrokerError do
        ShowMessage('A problem was encountered getting Broker information.  ' +
          e.Message); // TODO
    end; // try
  end; // with
end; // procedure GetBrokerInfo

{ ------------------------ NoSignOnNeeded ------------------------
  Currently a placeholder for actions that may be needed in connection
  with authenticating a user who needn't sign on (Single Sign on feature).
  Returns True if no signon is needed
  False if signon is needed.
  ------------------------------------------------------------------ }
function NoSignOnNeeded: boolean;
begin
  Result := True;
end; // function NoSignOnNeeded

{ ------------------------- ProcessExecute -------------------------
  This function is borrowed from "Delphi 2 Developer's Guide" by Pacheco & Teixera.
  See chapter 11, page 406.  It encapsulates and simplifies use of
  Windows CreateProcess function.
  ------------------------------------------------------------------ }
function ProcessExecute(Command: string; cShow: Word): integer;
{ This method encapsulates the call to CreateProcess() which creates
  a new process and its primary thread. This is the method used in
  Win32 to execute another application, This method requires the use
  of the TStartInfo and TProcessInformation structures. These structures
  are not documented as part of the Delphi 2.0 online help but rather
  the Win32 help as STARTUPINFO and PROCESS_INFORMATION.

  The CommandLine paremeter specifies the pathname of the file to
  execute.

  The cShow paremeter specifies one of the SW_XXXX constants which
  specifies how to display the window. This value is assigned to the
  sShowWindow field of the TStartupInfo structure. }
var
  Rslt: LongBool;
  StartUpInfo: TStartUpInfo; // documented as STARTUPINFO
  ProcessInfo: TProcessInformation; // documented as PROCESS_INFORMATION
begin
  { Clear the StartupInfo structure }
  FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
  { Initialize the StartupInfo structure with required data.
    Here, we assign the SW_XXXX constant to the wShowWindow field
    of StartupInfo. When specifing a value to this field the
    STARTF_USESSHOWWINDOW flag must be set in the dwFlags field.
    Additional information on the TStartupInfo is provided in the Win32
    online help under STARTUPINFO. }
  with StartUpInfo do
  begin
    cb := SizeOf(TStartUpInfo); // Specify size of structure
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    wShowWindow := cShow
  end; // with
  { Create the process by calling CreateProcess(). This function
    fills the ProcessInfo structure with information about the new
    process and its primary thread. Detailed information is provided
    in the Win32 online help for the TProcessInfo structure under
    PROCESS_INFORMATION. }
  Rslt := CreateProcess(PChar(Command), nil, nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartUpInfo, ProcessInfo);
  { If Rslt is true, then the CreateProcess call was successful.
    Otherwise, GetLastError will return an error code representing the
    error which occurred. }
  if Rslt then
    with ProcessInfo do
    begin
      { Wait until the process is in idle. }
      WaitForInputIdle(hProcess, INFINITE);
      CloseHandle(hThread); // Free the hThread  handle
      CloseHandle(hProcess); // Free the hProcess handle
      Result := 0; // Set Result to 0, meaning successful
    end // with
  else
    Result := GetLastError; // Set result to the error code.
end; // function ProcessExecute

{ ----------------------- GetAppHandle --------------------------
  Library function to return an Application Handle from the server
  which can be passed as a command line argument to an application
  the current application is starting.  The new application can use
  this AppHandle to perform a silent login via the lmAppHandle mode
  ---------------------------------------------------------------- }
function GetAppHandle(ConnectedBroker: TRPCBroker): String; // p13
begin
  Result := '';
  with ConnectedBroker do
  begin
    RemoteProcedure := 'XUS GET TOKEN';
    Call;
    Result := Results[0];
  end; // with
end; // function GetAppHandle

{ ----------------------- TRPCBroker.DoPulseOnTimer-----------------
  Called from the OnTimer event of the Pulse property.
  Broker environment should be the same after the procedure as before.
  Note: Results is not changed by strCall; so, Results needn't be saved.
  ------------------------------------------------------------------ }
procedure TRPCBroker.DoPulseOnTimer(Sender: TObject); // P6
var
  SaveClearParameters: boolean;
  SaveParam: TParams;
  SaveRemoteProcedure, SaveRpcVersion: string;
begin
  SaveClearParameters := ClearParameters; // Save existing properties
  SaveParam := TParams.Create(nil);
  SaveParam.Assign(Param);
  SaveRemoteProcedure := RemoteProcedure;
  SaveRpcVersion := RpcVersion;
  RemoteProcedure := 'XWB IM HERE'; // Set Properties for IM HERE
  ClearParameters := True; // Erase existing PARAMs
  RpcVersion := '1.106';
  try
    try
      strCall; // Make the call
    except
      on e: EBrokerError do
      begin
        // Connected := False;                // set the connection as disconnected
        if Assigned(FOnPulseError) then
          FOnPulseError(Self, e.Message)
        else
          raise e;
      end; // on
    end; // try
  finally
    ClearParameters := SaveClearParameters; // Restore pre-existing properties.
    Param.Assign(SaveParam);
    SaveParam.Free;
    RemoteProcedure := SaveRemoteProcedure;
    RpcVersion := SaveRpcVersion;
  end; // try
end; // procedure TRPCBroker.DoPulseOnTimer

{ ----------------------- TRPCBroker.SetKernelLogIn -----------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetKernelLogIn(const value: boolean); // p13
begin
  FKernelLogIn := value;
end; // procedure TRPCBroker.SetKernelLogIn

{ ----------------------- TRPCBroker.SetUser -----------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.SetUser(const value: TVistaUser); // p13
begin
  FUser := value;
end; // procedure TRPCBroker.SetUser

{ ----------------------- TVistaLogin.Create -----------------
  ------------------------------------------------------------------ }
constructor TVistaLogin.Create(AOwner: TComponent); // p13
begin
  inherited Create;
  FDivLst := TStringList.Create;
end; // constructor TVistaLogin.Create

{ ----------------------- TVistaLogin.Destroy -----------------
  ------------------------------------------------------------------ }
destructor TVistaLogin.Destroy; // p13
begin
  FDivLst.Free;
  FDivLst := nil;
  inherited;
end; // destructor TVistaLogin.Destroy

{ ----------------------- TVistaLogin.FailedLogin -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.FailedLogin(Sender: TObject); // p13
begin
  if Assigned(FOnFailedLogin) then
    FOnFailedLogin(Self)
  else
    TXWBWinsock(TRPCBroker(Sender).XWBWinsock).NetError('', XWB_BadSignOn);
end; // procedure TVistaLogin.FailedLogin

{ ----------------------- TVistaLogin.SetAccessCode -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetAccessCode(const value: String); // p13
begin
  FAccessCode := value;
end; // procedure TVistaLogin.SetAccessCode

{ ----------------------- TVistaLogin.SetDivision -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetDivision(const value: String); // p13
begin
  FDivision := value;
end; // procedure TVistaLogin.SetDivision

{ ----------------------- TVistaLogin.SetDuz -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetDuz(const value: string); // p13
begin
  FDUZ := value;
end; // procedure TVistaLogin.SetDuz

{ ----------------------- TVistaLogin.SetErrorTex -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetErrorText(const value: string); // p13
begin
  FErrorText := value;
end; // procedure TVistaLogin.SetErrorTex

{ ----------------------- TVistaLogin.SetLogInHandle -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetLogInHandle(const value: String); // p13
begin
  FLogInHandle := value;
end; // procedure TVistaLogin.SetLogInHandle

{ ----------------------- TVistaLogin.SetMode -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetMode(const value: TLoginMode); // p13
begin
  FMode := value;
end; // procedure TVistaLogin.SetMode

{ ----------------------- TVistaLogin.SetMultiDivision -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetMultiDivision(value: boolean); // p13
begin
  FMultiDivision := value;
end; // procedure TVistaLogin.SetMultiDivision

{ ----------------------- TVistaLogin.SetNTToken -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetNTToken(const value: String); // p13
begin
  FNTToken := value;
end; // procedure TVistaLogin.SetNTToken

{ ----------------------- TVistaLogin.SetPromptDiv -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetPromptDiv(const value: boolean); // p13
begin
  FPromptDiv := value;
end; // procedure TVistaLogin.SetPromptDiv

{ ----------------------- TVistaLogin.SetVerifyCode -----------------
  ------------------------------------------------------------------ }
procedure TVistaLogin.SetVerifyCode(const value: String); // p13
begin
  FVerifyCode := value;
end; // procedure TVistaLogin.SetVerifyCode

{ ----------------------- TVistaUser.SetDivision -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetDivision(const value: String); // p13
begin
  FDivision := value;
end; // procedure TVistaUser.SetDivision

{ ----------------------- TVistaUser.SetDTime -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetDTime(const value: string); // p13
begin
  FDtime := value;
end; // procedure TVistaUser.SetDTime

{ ----------------------- TVistaUser.SetDUZ -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetDuz(const value: String); // p13
begin
  FDUZ := value;
end; // procedure TVistaUser.SetDUZ

{ ----------------------- TVistaUser.SetLanguage -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetLanguage(const value: string); // p13
begin
  FLanguage := value;
end; // procedure TVistaUser.SetLanguage

{ ----------------------- TVistaUser.SetName -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetName(const value: String); // p13
begin
  FName := value;
end; // procedure TVistaUser.SetName

{ ----------------------- TVistaUser.SetServiceSection -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetServiceSection(const value: string); // p13
begin
  FServiceSection := value;
end; // procedure TVistaUser.SetServiceSection

{ ----------------------- TVistaUser.SetStandardName -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetStandardName(const value: String); // p13
begin
  FStandardName := value;
end; // procedure TVistaUser.SetStandardName

{ ----------------------- TVistaUser.SetTitle -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetTitle(const value: string); // p13
begin
  FTitle := value;
end; // procedure TVistaUser.SetTitle

{ ----------------------- TVistaUser.SetVerifyCodeChngd -----------------
  ------------------------------------------------------------------ }
procedure TVistaUser.SetVerifyCodeChngd(const value: boolean); // p13
begin
  FVerifyCodeChngd := value;
end; // procedure TVistaUser.SetVerifyCodeChngd

{ ----------------------- ShowApplicationAndFocusOK -----------------
  ------------------------------------------------------------------ }
function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;
var
  j: integer;
  Stat2: set of (sWinVisForm, sWinVisApp, sIconized);
  hFGWnd: THandle;
begin
  Stat2 := []; { sWinVisForm,sWinVisApp,sIconized }
  if anApplication.MainForm <> nil then
    if IsWindowVisible(anApplication.MainForm.Handle) then
      Stat2 := Stat2 + [sWinVisForm];
  if IsWindowVisible(anApplication.Handle) then
    Stat2 := Stat2 + [sWinVisApp];
  if IsIconic(anApplication.Handle) then
    Stat2 := Stat2 + [sIconized];
  Result := True;
  if sIconized in Stat2 then
  begin { A }
    j := SendMessage(anApplication.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
    Result := j <> 0;
  end; // if
  if Stat2 * [sWinVisForm, sIconized] = [] then
  begin { S }
    if anApplication.MainForm <> nil then
      anApplication.MainForm.Show;
  end; // if
  if (Stat2 * [sWinVisForm, sIconized] <> []) or (sWinVisApp in Stat2) then
  begin { G }
    hFGWnd := GetForegroundWindow;
    try
      AttachThreadInput(GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, True);
      Result := SetForegroundWindow(anApplication.Handle);
    finally
      AttachThreadInput(GetWindowThreadProcessId(hFGWnd, nil),
        GetCurrentThreadId, False);
    end; // try
  end; // if sIconized
end; // function ShowApplicationAndFocusOK

{ ----------------------- TRPCBroker.WasUserDefined -----------------
  ------------------------------------------------------------------ }
function TRPCBroker.WasUserDefined: boolean;
begin
  Result := FWasUserDefined;
end; // function TRPCBroker.WasUserDefined

{ ----------------------- TRPCBroker.IsUserCleared -----------------
  ------------------------------------------------------------------ }
function TRPCBroker.IsUserCleared: boolean;
var
  CCOWcontextItem: IContextItemCollection; // CCOW
  CCOWdataItem1: IContextItem; // CCOW
  Name: String;
begin
  Result := False;
  Name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
    try
      // See if context contains the ID item
      CCOWcontextItem := Contextor.CurrentContext;
      CCOWdataItem1 := CCOWcontextItem.Present(Name);
      if (CCOWdataItem1 <> nil) then // 1
      begin
        if CCOWdataItem1.value = '' then
          Result := True
        else
          FWasUserDefined := True;
      end // if
      else
        Result := True;
    finally
    end; // try
end; // function TRPCBroker.IsUserCleared

{ ----------------------- GetCCOWHandle --------------------------
  Private function to return a special CCOW Handle from the server
  which is set into the CCOW context.
  The Broker of a new application can get the CCOWHandle from the context
  and use it to do a ImAPPHandle Sign-on.
  ---------------------------------------------------------------- }
function TRPCBroker.GetCCOWHandle(ConnectedBroker: TRPCBroker): String; // p13
begin
  Result := '';
  with ConnectedBroker do
    try // to permit it to work correctly if CCOW is not installed on the server.
      RemoteProcedure := 'XUS GET CCOW TOKEN';
      Call;
      Result := Results[0];
      Domain := Results[1];
      RemoteProcedure := 'XUS CCOW VAULT PARAM';
      Call;
      PassCode1 := Results[0];
      PassCode2 := Results[1];
    except
      Result := '';
    end; // try
end; // function TRPCBroker.GetCCOWHandle

{ ----------------------- TRPCBroker.CCOWsetUser -----------------
  ------------------------------------------------------------------ }
procedure TRPCBroker.CCOWsetUser(Uname, token, Domain, Vpid: string;
  Contextor: TContextorControl);
var
  CCOWdata: IContextItemCollection; // CCOW
  CCOWdataItem1, CCOWdataItem2, CCOWdataItem3: IContextItem;
  CCOWdataItem4, CCOWdataItem5: IContextItem; // CCOW
  Cname: string;
begin
  if Contextor <> nil then
    try
      // Part 1
      Contextor.StartContextChange;
      // Part 2 Set the new proposed context data
      CCOWdata := CoContextItemCollection.Create;
      CCOWdataItem1 := CoContextItem.Create;
      Cname := CCOW_LOGON_ID;
      CCOWdataItem1.Name := Cname;
      CCOWdataItem1.value := Domain;
      CCOWdata.Add(CCOWdataItem1);
      CCOWdataItem2 := CoContextItem.Create;
      Cname := CCOW_LOGON_TOKEN;
      CCOWdataItem2.Name := Cname;
      CCOWdataItem2.value := token;
      CCOWdata.Add(CCOWdataItem2);
      CCOWdataItem3 := CoContextItem.Create;
      Cname := CCOW_LOGON_NAME;
      CCOWdataItem3.Name := Cname;
      CCOWdataItem3.value := Uname;
      CCOWdata.Add(CCOWdataItem3);
      //
      CCOWdataItem4 := CoContextItem.Create;
      Cname := CCOW_LOGON_VPID;
      CCOWdataItem4.Name := Cname;
      CCOWdataItem4.value := Vpid;
      CCOWdata.Add(CCOWdataItem4);
      //
      CCOWdataItem5 := CoContextItem.Create;
      Cname := CCOW_USER_NAME;
      CCOWdataItem5.Name := Cname;
      CCOWdataItem5.value := Uname;
      CCOWdata.Add(CCOWdataItem5);
      // Part 3 Make change
      Contextor.EndContextChange(True, CCOWdata);
      // We don't need to check CCOWresponce
    finally
    end; // try
end; // procedure TRPCBroker.CCOWsetUser

{ ----------------------- TRPCBroker.GetCCOWtoken -----------------
  Get Token from CCOW context
  ------------------------------------------------------------------ }
function TRPCBroker.GetCCOWtoken(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem; // CCOW
  CCOWcontextItem: IContextItemCollection; // CCOW
  Name: string;
begin
  Result := '';
  name := CCOW_LOGON_TOKEN;
  if (Contextor <> nil) then
    try
      CCOWcontextItem := Contextor.CurrentContext;
      // See if context contains the ID item
      CCOWdataItem1 := CCOWcontextItem.Present(name);
      if (CCOWdataItem1 <> nil) then // 1
      begin
        Result := CCOWdataItem1.value;
        if not(Result = '') then
          FWasUserDefined := True;
      end; // if
      FCCOWLogonIDName := CCOW_LOGON_ID;
      FCCOWLogonName := CCOW_LOGON_NAME;
      FCCOWLogonVpid := CCOW_LOGON_VPID;
      CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_ID);
      if CCOWdataItem1 <> nil then
        FCCOWLogonIDValue := CCOWdataItem1.value;
      CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_NAME);
      if CCOWdataItem1 <> nil then
        FCCOWLogonNameValue := CCOWdataItem1.value;
      CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_VPID);
      if CCOWdataItem1 <> nil then
        FCCOWLogonVpidValue := CCOWdataItem1.value;
    finally
    end; // try
end; // function TRPCBroker.GetCCOWtoken

{ ----------------------- TRPCBroker.GetCCOWduz -----------------
  Get Name from CCOW context
  ------------------------------------------------------------------ }
function TRPCBroker.GetCCOWduz(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem; // CCOW
  CCOWcontextItem: IContextItemCollection; // CCOW
  Name: string;
begin
  Result := '';
  name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
    try
      CCOWcontextItem := Contextor.CurrentContext;
      // See if context contains the ID item
      CCOWdataItem1 := CCOWcontextItem.Present(name);
      if (CCOWdataItem1 <> nil) then // 1
      begin
        Result := CCOWdataItem1.value;
        if Result <> '' then
          FWasUserDefined := True;
      end; // if
    finally
    end; // try
end; // function TRPCBroker.GetCCOWduz

{ ----------------------- TRPCBroker.IsUserContextPending -----------------
  ------------------------------------------------------------------ }
function TRPCBroker.IsUserContextPending(aContextItemCollection
  : IContextItemCollection): boolean;
var
  CCOWdataItem1: IContextItem; // CCOW
  Val1: String;
begin
  Result := False;
  if WasUserDefined() then // indicates data was defined
  begin
    Val1 := ''; // look for any USER Context items defined
    Result := True;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.value = FCCOWLogonIDValue) then
        Val1 := '^' + CCOWdataItem1.value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.value = FCCOWLogonNameValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.value = FCCOWLogonVpidValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_USER_NAME);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.value = User.Name) then
        Val1 := Val1 + '^' + CCOWdataItem1.value;
    //
    if Val1 = '' then
      // nothing defined or all matches, so not user context change
      Result := False;
  end; // if
end; // function TRPCBroker.IsUserContextPending

{ ----------------------- TRpcBroker.CheckSSH -----------------
  procedure CheckSSH was extracted to remove duplicate code
  in the SetConnected method of Trpcb and derived classes
  ------------------------------------------------------------------ }
procedure TRPCBroker.CheckSSH;
var
  ParamNum: integer;
  ParamVal: String;
  ParamValNormal: String;
begin
  FIPsecSecurity := 0;
  ParamNum := 1;
  while (not(ParamStr(ParamNum) = '')) do
  begin
    ParamValNormal := ParamStr(ParamNum);
    ParamVal := UpperCase(ParamValNormal);
    // check for command line specifiction of connection
    // method if not set as a property
    if FUseSecureConnection = secureNone then
    begin
      if ParamVal = 'SSH' then
        FUseSecureConnection := secureAttachmate;
      if ParamVal = 'PLINK' then
        FUseSecureConnection := securePlink;
    end; // if FUseSecureConnection
    // check for SSH specifications on command line
    if Pos('SSHPORT=', ParamVal) = 1 then
      FSSHPort := Copy(ParamVal, 9, length(ParamVal));
    if Pos('SSHUSER=', ParamVal) = 1 then
      FSSHUser := Copy(ParamValNormal, 9, length(ParamVal));
    if Pos('SSHPW=', ParamVal) = 1 then
      FSSHpw := Copy(ParamValNormal, 7, length(ParamVal));
    if ParamVal = 'SSHHIDE' then
      FSSHhide := True;
    ParamNum := ParamNum + 1;
  end; // while
end; // procedure TRpcBroker.CheckSSH

{ ----------------------- TRPCBroker.getSSHUsername -----------------
  ------------------------------------------------------------------ }
function TRPCBroker.getSSHUsername: string;
var
  UsernameEntry: TSSHUsername;
begin
  UsernameEntry := TSSHUsername.Create(Self);
  UsernameEntry.ShowModal;
  Result := UsernameEntry.Edit1.Text;
  UsernameEntry.Free;
end; // function TRPCBroker.getSSHUsername

{ ----------------------- TRPCBroker.getSSHPassWord -----------------
  ------------------------------------------------------------------ }
function TRPCBroker.getSSHPassWord: string;
var
  PasswordEntry: TfPlinkPassword;
begin
  PasswordEntry := TfPlinkPassword.Create(Self);
  PasswordEntry.ShowModal;
  Result := PasswordEntry.Edit1.Text;
  PasswordEntry.Free;
end; // function TRPCBroker.getSSHPassWord

{ ----------------------- TRPCBroker.StartSecureConnection -----------------
  Use Micro Focus (formerly Attachmate) Reflection or Plink tunneling for encrypted connection

  Reflection Usage: ssh2 [options] [user@]host[#port] [command]

  Options:
  -A            Enable authentication agent forwarding.
  -a            Disable authentication agent forwarding (default).
  -b            Local IP address.
  -c cipher[,cipher]   Select encryption algorithms (comma separated list).
  -C            Enable compression.
  -D port       Enable dynamic application-level port forwarding via SOCKS4/5
  -e char       Set escape character; ``none'' = disable (default: ~).
  -E prov       Use 'prov' as the external key provider.
  -f            Places client in background just before command execution.
  -F file       Read an alternative configuration file.
  -g            Allow remote hosts to connect to forwarded ports.
  -H scheme     Use the specified scheme name in the config file.
  -i keyfile    Identity file for public key authentication.
  -k dir        Custom configuration dir where config file, hostkeys and
  userkeys are located.
  -l user       Log in using this user name.
  -L [FTP/|TCP/]listen-port:host:port   Forward local port to remote address.
  These cause ssh to listen for connections on a port, and
  forward them to the other side by connecting to host:port.
  -m macs       Specify MAC algorithms for protocol version 2.
  -n            Redirect stdin from null.
  -N            Do not execute a shell or command.
  -o "option"   Sets any option supported in the ssh configuration file.
  -p port       Connect to this port.  Server must be on the same port.
  -q            Quiet; don't display any warning messages.
  -R listen-port:host:port   Forward remote port to local address
  -S            Do not execute a shell.
  -t            Tty; allocate a tty even if command is given.
  -T            Do not allocate a tty.
  -v[vv]        Verbose, debug level; display verbose debugging messages.
  Multiple v's increases verbosity.
  -V            Display version number only.
  -X            Enable X11 connection forwarding UNTRUSTED.
  -x            Disable X11 connection forwarding (default).
  -1            Force protocol version 1.
  -2            Force protocol version 2.
  -4            Use IPv4 only.
  -6            Use IPv6 only.
  -?            Display this usage help

  Command can be either:
  remote_command [arguments] ...    Run command in remote host.
  -s service                        Enable a service in remote server.

  Default ciphers in FIPS mode:
  aes128-ctr,aes128-cbc,aes192-ctr,aes192-cbc,aes256-ctr,aes256-cbc,3des-cbc

  Default MAC algorithms in FIPS mode:
  hmac-sha1,hmac-sha256,hmac-sha512
  ------------------------------------------------------------------ }
function TRPCBroker.StartSecureConnection(var PseudoServer,
  PseudoPort: String): boolean;
var
  CmndLine: String;
  TunnelConn: String;
begin
  FIPsecSecurity := 0;
  PseudoPort := FSSHPort;
  if FSSHPort = '' then
    PseudoPort := IntToStr(ListenerPort);
  PseudoServer := Server;
  if FSSHUser = '' then
    FSSHUser := getSSHUsername;
  if FUseSecureConnection = secureAttachmate then
  begin
    if AnsiContainsText(FServer, ':') then
      TunnelConn := PseudoPort + '/' + FServer + '/' + IntToStr(ListenerPort)
      // Alternative syntax for IPv6 address
    else
      TunnelConn := PseudoPort + ':' + FServer + ':' + IntToStr(ListenerPort);
    CmndLine := 'SSH -L ' + TunnelConn + ' -S -o "TryEmptyPassword yes"' +
      ' -o "FipsMode yes"' +
      ' -o "StrictHostKeyChecking no" -o "connectionReuse no" ' + FSSHUser +
      '@' + Server
  end; // if
  if FUseSecureConnection = securePlink then
  begin
    if FSSHpw = '' then
      FSSHpw := getSSHPassWord;
    TunnelConn := PseudoPort + ':' + PseudoServer + ':' +
      IntToStr(ListenerPort);
    CmndLine := 'plink.exe -L ' + TunnelConn + ' ' + FSSHUser + '@' + FServer +
      ' -pw ' + FSSHpw;
  end; // if
  if FSSHhide then
    StartProgSLogin(CmndLine, nil, SW_HIDE)
  else
    StartProgSLogin(CmndLine, nil, SW_SHOWMINIMIZED);
  Sleep(5000);
  if FSSHUser <> '' then
    FIPsecSecurity := 2;
  Result := True;
end; // function TRPCBroker.StartSecureConnection

{ ----------------------- SSOiBindUser --------------------------
  Procedure to Bind an Active Directory account to a VistA user
  using the attributes in an Identity and Access Management STS SAML token.
  ---------------------------------------------------------------- }
procedure SSOiBindUser(ConnectedBroker: TRPCBroker); // p65
begin
  with ConnectedBroker do
    if SSOiSECID <> '' then
      try
        RemoteProcedure := 'XUS IAM BIND USER';
        Param[0].PType := literal;
        Param[0].value := SSOiSECID;
        Param[1].PType := literal;
        Param[1].value := Decrypt(IAM_Binding);
        if SSOiADUPN <> '' then // optional parameter
        begin
          Param[2].PType := literal;
          Param[2].value := SSOiADUPN;
        end;
        Call;
      except
      end; // try
end; // function TRPCBroker.SSOiBindUser

end.

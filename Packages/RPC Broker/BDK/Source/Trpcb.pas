{$WARN UNSAFE_CAST OFF}
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

{*
  Adding use of SSH tunneling as command line option (or property)
     It appears that tunneling with Attachmate Reflection will be
     used within the VA.  However, code for the use of Plink.exe
     for ssh tunneling is also provided to permit secure connections
     for those using VistA outside of the VA.

  for SSH Tunneling using Attachmate Reflection
    SSH set as commandline option or as a property
           (set to Attachmate Reflection) will
           also be set to true if either of the following
           command line parameters are set.
    SSHPort=portnumber to specify a particular port number
                       if not specified, it will use the port
                       number for the remote server.
    SSHUser=username for remote server
                         if not specified, user will be prompted



  for SSH tunneling with Plink.exe
    UsePlink set as command line option or as a property
           (set to Plink).
    SSHPort=portnumber
*}

{**************************************************
This is the hierarchy of things:
   TRPCBroker contains
      TParams, which contains
         array of TParamRecord each of which contains
                  TMult

v1.1*4 Silent Login changes (DCM) 10/22/98

1.1*6 Polling to support terminating orphaned server jobs. (P6)
      == DPC 4/99

1.1*8 Check for Multi-Division users. (P8) - REM 7/13/99

1.1*13 More silent login code; deleted obsolete lines (DCM) 9/10/99  // p13
LAST UPDATED: 5/24/2001   // p13  JLI

1.1*31 Added new read only property BrokerVersion to TRPCBroker which
       should contain the version number for the RPCBroker
       (or SharedRPCBroker) in use.
**************************************************}
unit Trpcb;

interface

{$I IISBase.inc}

uses
  {Delphi standard}
  Classes, Controls, Dialogs, {DsgnIntf,} Forms, Graphics, Messages, SysUtils,
  WinProcs, WinTypes, Windows,
  extctrls, {P6}
  {VA}
  XWBut1, MFunStr, Hash, //P14 -- pack split
  ComObj, ActiveX, OleCtrls, VERGENCECONTEXTORLib_TLB;

const
  NoMore: boolean = False;
  MIN_RPCTIMELIMIT: integer = 30;
  CURRENT_RPC_VERSION: String = 'XWB*1.1*50';

type

TParamType = (literal, reference, list, global, empty, stream, undefined);  // 030107 JLI Modified for new message protocol

//P14 -- pack split -- Types moved from RpcbEdtr.pas.
TAccessVerifyCodes = string;  //to use TAccessVerifyCodesProperty editor use this type
TRemoteProc = string;         //to use TRemoteProcProperty editor use this type
TServer = string;             //to use TServerProperty editor use this type
TRpcVersion = string;         //to use TRpcVersionProperty editor use this type

TRPCBroker = class;
TVistaLogin = class;
// p13 
TLoginMode = (lmAVCodes, lmAppHandle, lmNTToken);
TShowErrorMsgs = (semRaise, semQuiet);  // p13
TOnLoginFailure = procedure (VistaLogin: TVistaLogin) of object; //p13
TOnRPCBFailure = procedure (RPCBroker: TRPCBroker) of object; //p13
TOnPulseError = procedure(RPCBroker: TRPCBroker; ErrorText: String) of object;
TSecure = (secureNone, secureAttachmate, securePlink);

{------ EBrokerError ------}
EBrokerError = class(Exception)
public
  Action: string;
  Code: integer;
  Mnemonic: string;
end;

{------ TString ------}

TString = class(TObject)
  Str: string;
end;

{------ TMult ------}
{:This component defines the multiple field of a parameter.  The multiple
 field is used to pass string-subscripted array of data in a parameter.}

TMult = class(TComponent)
private
  FMultiple: TStringList;
  procedure ClearAll;
  function  GetCount: Word;
  function  GetFirst: string;
  function  GetLast: string;
  function  GetFMultiple(Index: string): string;
  function  GetSorted: boolean;
  procedure SetFMultiple(Index: string; value: string);
  procedure SetSorted(Value: boolean);
protected
public
  constructor Create(AOwner: TComponent); override;      {1.1T8}
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  function Order(const StartSubscript: string; Direction: integer): string;
  function Position(const Subscript: string): longint;
  function Subscript(const Position: longint): string;
  property Count: Word read GetCount;
  property First: string read GetFirst;
  property Last: string read GetLast;
  property MultArray[I: string]: string read GetFMultiple write SetFMultiple; default;
  property Sorted: boolean read GetSorted write SetSorted;
end;

{------ TParamRecord ------}
{:This component defines all the fields that comprise a parameter.}

TParamRecord = class(TComponent)
private
  FMult: TMult;
  FValue: string;
  FPType: TParamType;
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property Value: string read FValue write FValue;
  property PType: TParamType read FPType write FPType;
  property Mult: TMult read FMult write FMult;
end;

{------ TParams ------}
{:This component is really a collection of parameters.  Simple inclusion
  of this component in the Broker component provides access to all of the
  parameters that may be needed when calling a remote procedure.}

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
  property ParamArray[I: integer]: TParamRecord
                      read GetParameter write SetParameter; default;
end;


{------ TVistaLogin ------}     //p13
TVistaLogin = class(TPersistent)
private
  FLogInHandle : string;
  FNTToken : string;
  FAccessCode : string;
  FVerifyCode : string;
  FDivision   : string;
  FMode: TLoginMode;
  FDivLst: TStrings;
  FOnFailedLogin: TOnLoginFailure;
  FMultiDivision : boolean;
  FDUZ: string;
  FErrorText : string;
  FPromptDiv : boolean;
  FIsProductionAccount: Boolean;
  FDomainName: string;
  procedure SetAccessCode(const Value: String);
  procedure SetLogInHandle(const Value: String);
  procedure SetNTToken(const Value: String);
  procedure SetVerifyCode(const Value: String);
  procedure SetDivision(const Value: String);
  procedure SetMode(const Value: TLoginMode);
  procedure SetMultiDivision(Value: Boolean);
  procedure SetDuz(const Value: string);
  procedure SetErrorText(const Value: string);
  procedure SetPromptDiv(const Value: boolean);
protected
  procedure FailedLogin(Sender: TObject); dynamic;
public
  constructor Create(AOwner: TComponent); virtual;
  destructor Destroy; override;
  property LogInHandle: String read FLogInHandle write SetLogInHandle;  //for use by a 2ndary DHCP login OR ESSO login
  property NTToken: String read FNTToken write SetNTToken;
  property DivList: TStrings read FDivLst;
  property OnFailedLogin: TOnLoginFailure read FOnFailedLogin write FOnFailedLogin;
  property MultiDivision: Boolean read FMultiDivision write SetMultiDivision;
  property DUZ: string read FDUZ write SetDuz;
  property ErrorText: string read FErrorText write SetErrorText;
  property IsProductionAccount: Boolean read FIsProductionAccount write
      FIsProductionAccount;
  property DomainName: string read FDomainName write FDomainName;
published
  property AccessCode: String read FAccessCode write SetAccessCode;
  property VerifyCode: String read FVerifyCode write SetVerifyCode;
  property Mode: TLoginMode read FMode write SetMode;
  property Division: String read FDivision write SetDivision;
  property PromptDivision: boolean read FPromptDiv write SetPromptDiv;

end;

{------ TVistaUser ------}   //holds 'generic' user attributes {p13}
TVistaUser = class(TObject)
private
  FDUZ: string;
  FName: string;
  FStandardName: string;
  FDivision: String;
  FVerifyCodeChngd: Boolean;
  FTitle: string;
  FServiceSection: string;
  FLanguage: string;
  FDtime: string;
  FVpid: String;
  procedure SetDivision(const Value: String);
  procedure SetDUZ(const Value: String);
  procedure SetName(const Value: String);
  procedure SetVerifyCodeChngd(const Value: Boolean);
  procedure SetStandardName(const Value: String);
  procedure SetTitle(const Value: string);
  procedure SetDTime(const Value: string);
  procedure SetLanguage(const Value: string);
  procedure SetServiceSection(const Value: string);
public
  property DUZ: String read FDUZ write SetDUZ;
  property Name: String read FName write SetName;
  property StandardName: String read FStandardName write SetStandardName;
  property Division: String read FDivision write SetDivision;
  property VerifyCodeChngd: Boolean read FVerifyCodeChngd write SetVerifyCodeChngd;
  property Title: string read FTitle write SetTitle;
  property ServiceSection: string read FServiceSection write SetServiceSection;
  property Language: string read FLanguage write SetLanguage;
  property DTime: string read FDTime write SetDTime;
  property Vpid: string read FVpid write FVpid;
end;

{------ TRPCBroker ------}
{:This component, when placed on a form, allows design-time and run-time
  connection to the server by simply toggling the Connected property.
  Once connected you can access server data.}

TRPCBroker = class(TComponent)
private
  IsVisual: boolean; //Show graphics (default true)
protected
  FBrokerVersion: String;
  FIsBackwardCompatibleConnection: Boolean;
  FIsNewStyleConnection: Boolean;
  FOldConnectionOnly: Boolean;
  FAccessVerifyCodes: TAccessVerifyCodes;
  FClearParameters: Boolean;
  FClearResults: Boolean;
  FConnected: Boolean;
  FConnecting: Boolean;
  FCurrentContext: String;
  FDebugMode: Boolean;
  FListenerPort: integer;
  FParams: TParams;
  FResults: TStrings;
  FOnCallResultStr: String;
  FRemoteProcedure: TRemoteProc;
  FRpcVersion: TRpcVersion;
  FServer: TServer;
  FSocket: integer;
  FRPCTimeLimit : integer;    //for adjusting client RPC duration timeouts
  FPulse        : TTimer;     //P6
  FKernelLogIn  : Boolean;    //p13
  FLogIn: TVistaLogIn;    //p13
  FUser: TVistaUser; //p13
  FOnRPCBFailure: TOnRPCBFailure;
  FShowErrorMsgs: TShowErrorMsgs;
  FRPCBError:     String;
  FOnPulseError: TOnPulseError;
  FSecurityPhrase: String;     // BSE JLI 060130
  FCCOWLogonIDName: String;
  FCCOWLogonIDValue: String;
  FCCOWLogonName: String;
  FCCOWLogonNameValue: String;
  FContextor: TContextorControl;  //CCOW
  FCCOWtoken: string;              //CCOW
  FVistaDomain: String;
  FCCOWLogonVpid: String;
  FCCOWLogonVpidValue: String;
  FWasUserDefined: Boolean;
  FOnRPCCall: TNotifyEvent;
  // end of values from CCOWRPCBroker
  // values for handling SSH tunnels
  FUseSecureConnection: TSecure;
  FSSHPort: String;
  FSSHUser: String;
  FSSHpw: String;
  FSSHhide: Boolean;
  FLastServer: String;
  FLastPort: Integer;
  // end SSH tunnel values
  function  GetCCOWHandle(ConnectedBroker: TRPCBroker): string;
  procedure CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor:
    TContextorControl);
  function  GetCCOWduz( Contextor: TContextorControl): string;
protected
  procedure   SetClearParameters(Value: Boolean); virtual;
  procedure   SetClearResults(Value: Boolean); virtual;
  procedure   SetConnected(Value: Boolean); virtual;
  procedure   SetResults(Value: TStrings); virtual;
  procedure   SetServer(Value: TServer); virtual;
  procedure   SetRPCTimeLimit(Value: integer); virtual;  //Screen changes to timeout.
  procedure   DoPulseOnTimer(Sender: TObject); virtual;  //p6
  procedure   SetKernelLogIn(const Value: Boolean); virtual;
//  procedure   SetLogIn(const Value: TVistaLogIn); virtual;
  procedure   SetUser(const Value: TVistaUser); virtual;
  procedure   CheckSSH;
  function    getSSHPassWord: string;
  function    getSSHUsername: string;
  function    StartSecureConnection(var PseudoServer, PseudoPort: String): Boolean;
public
  XWBWinsock: TObject;
  // 060919 added for multiple brokers with both old and new
  Prefix: String;
  property    AccessVerifyCodes: TAccessVerifyCodes read FAccessVerifyCodes write FAccessVerifyCodes;
  property    Param: TParams read FParams write FParams;
  property    Socket: integer read FSocket;
  property    RPCTimeLimit : integer read FRPCTimeLimit write SetRPCTimeLimit;
  destructor  Destroy; override;
  procedure   Call; virtual;
  procedure   Loaded; override;
  procedure   lstCall(OutputBuffer: TStrings); virtual;
  function    pchCall: PChar; virtual;
  function    strCall: string; virtual;
  function    CreateContext(strContext: string): boolean; virtual;
  property    CurrentContext: String read FCurrentContext;
  property    User: TVistaUser read FUser write SetUser;
  property    OnRPCBFailure: TOnRPCBFailure read FOnRPCBFailure write FOnRPCBFailure;
  property    RPCBError: String read FRPCBError write FRPCBError;
  property    OnPulseError: TOnPulseError read FOnPulseError write FOnPulseError;
  property    BrokerVersion: String read FBrokerVersion;
  property IsNewStyleConnection: Boolean read FIsNewStyleConnection;
  property    SecurityPhrase: String read FSecurityPhrase write FSecurityPhrase;  // BSE JLI 060130
  property    OnCallResultStr: String read FOnCallResultStr;
  // brought in from CCOWRPCBroker
  function GetCCOWtoken(Contextor: TContextorControl): string;
  function IsUserCleared: Boolean;
  function WasUserDefined: Boolean;
  function IsUserContextPending(aContextItemCollection: IContextItemCollection):
      Boolean;
  property   Contextor: TContextorControl
                          read Fcontextor write FContextor;  //CCOW
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
published
  constructor Create(AOwner: TComponent); override;
  property    ClearParameters: boolean read FClearParameters
              write SetClearParameters;
  property    ClearResults: boolean read FClearResults write SetClearResults;
  property    Connected: boolean read FConnected write SetConnected;
  property    DebugMode: boolean read FDebugMode write FDebugMode default False;
  property    ListenerPort: integer read FListenerPort write FListenerPort;
  property    Results: TStrings read FResults write SetResults;
  property    RemoteProcedure: TRemoteProc read FRemoteProcedure
              write FRemoteProcedure;
  property    RpcVersion: TRpcVersion read FRpcVersion write FRpcVersion;
  property    Server: TServer read FServer write SetServer;
  property    KernelLogIn: Boolean read FKernelLogIn write SetKernelLogIn;
  property    ShowErrorMsgs: TShowErrorMsgs read FShowErrorMsgs write FShowErrorMsgs default semRaise;
  property    LogIn: TVistaLogIn read FLogIn write FLogin; // SetLogIn;
  property    IsBackwardCompatibleConnection: Boolean read
      FIsBackwardCompatibleConnection write FIsBackwardCompatibleConnection 
      default True;
  property    OldConnectionOnly: Boolean read FOldConnectionOnly write 
      FOldConnectionOnly;
  property    OnRPCCall: TNotifyEvent read FOnRPCCall write FOnRPCCall;
  // 080624 added property to permit app to set secure connection if desired
   property UseSecureConnection: TSecure read FUseSecureConnection write
        FUSeSecureConnection;
   property SSHHide: Boolean read FSSHHide write FSSHHide;
end;

{------ TRPCThreadBroker ------}
{:Extended class to ignore the visual elemenets when borker is threaded}
TRPCThreadBroker = Class(TRpcBroker)
  published
   constructor Create(AOwner: TComponent); override;
End;


{procedure Register;}  //P14 --pack split
procedure StoreConnection(Broker: TRPCBroker);
function  RemoveConnection(Broker: TRPCBroker): boolean;
function  DisconnectAll(Server: string; ListenerPort: integer): boolean;
function  ExistingSocket(Broker: TRPCBroker): integer;
procedure AuthenticateUser(ConnectingBroker: TRPCBroker);
procedure GetBrokerInfo(ConnectedBroker : TRPCBroker);  //P6
function  NoSignOnNeeded : Boolean;
function  ProcessExecute(Command: string; cShow: Word): Integer;
function  GetAppHandle(ConnectedBroker : TRPCBroker): String;
function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;


var
  DebugData: string;
  BrokerConnections: TStringList;   {this list stores all connections by socket number}
  BrokerAllConnections: TStringList; {this list stores all connections to all of
                the servers, by an application.  It's used in DisconnectAll}
  // 080618 following 2 variables added to handle closing of command box for SSH
  CommandBoxProcessHandle: THandle;
  CommandBoxThreadHandle: THandle;

implementation

uses
  Loginfrm, RpcbErr, SelDiv{p8}, RpcSLogin{p13}, fRPCBErrMsg, Wsockc,
  CCOW_const, fPlinkpw, fSSHUsername;

var
  CCOWToken: String;
  Domain: String;
  PassCode1: String;
  PassCode2: String;

const
  DEFAULT_PULSE    : integer = 81000; //P6 default = 45% of 3 minutes.
  MINIMUM_TIMEOUT  : integer = 14;    //P6 shortest allowable timeout in secs.
  PULSE_PERCENTAGE : integer = 45;    //P6 % of timeout for pulse frequency.

{-------------------------- TMult.Create --------------------------
------------------------------------------------------------------}
constructor TMult.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMultiple := TStringList.Create;
end;

{------------------------- TMult.Destroy --------------------------
------------------------------------------------------------------}
destructor TMult.Destroy;
begin
  ClearAll;
  FMultiple.Free;
  FMultiple := nil;
  inherited Destroy;
end;

{-------------------------- TMult.Assign --------------------------
All of the items from source object are copied one by one into the
target.  So if the source is later destroyed, target object will continue
to hold the copy of all elements, completely unaffected.
------------------------------------------------------------------}
procedure TMult.Assign(Source: TPersistent);
var
  I: integer;
  SourceStrings: TStrings;
  S: TString;
  SourceMult: TMult;
begin
  ClearAll;
  if Source is TMult then begin
    SourceMult := Source as TMult;
     try
      for I := 0 to SourceMult.FMultiple.Count - 1 do begin
        S := TString.Create;
        S.Str := (SourceMult.FMultiple.Objects[I] as TString).Str;
        Self.FMultiple.AddObject(SourceMult.FMultiple[I], S);
      end;
    except
    end;
  end

  else begin
    SourceStrings := Source as TStrings;
    for I := 0 to SourceStrings.Count - 1 do
      Self[IntToStr(I)] := SourceStrings[I];
  end;
end;

{------------------------- TMult.ClearAll -------------------------
  One by one, all Mult items are freed.
------------------------------------------------------------------}
procedure TMult.ClearAll;
var
  I: integer;
begin
  for I := 0 to FMultiple.Count - 1 do begin
    FMultiple.Objects[I].Free;
    FMultiple.Objects[I] := nil;
  end;
  FMultiple.Clear;
end;

{------------------------- TMult.GetCount -------------------------
  Returns the number of elements in the multiple
------------------------------------------------------------------}
function TMult.GetCount: Word;
begin
  Result := FMultiple.Count;
end;

{------------------------- TMult.GetFirst -------------------------
Returns the subscript of the first element in the multiple
------------------------------------------------------------------}
function TMult.GetFirst: string;
begin
  if FMultiple.Count > 0 then Result := FMultiple[0]
  else Result := '';
end;

{------------------------- TMult.GetLast --------------------------
Returns the subscript of the last element in the multiple
------------------------------------------------------------------}
function TMult.GetLast: string;
begin
  if FMultiple.Count > 0 then Result := FMultiple[FMultiple.Count - 1]
  else Result := '';
end;

{---------------------- TMult.GetFMultiple ------------------------
Returns the VALUE of the element whose subscript is passed.
------------------------------------------------------------------}
function TMult.GetFMultiple(Index: string): string;
var
  S: TString;
  BrokerComponent,ParamRecord: TComponent;
  I: integer;
  strError: string;
begin
  try
    S := TString(FMultiple.Objects[FMultiple.IndexOf(Index)]);
  except
    on EListError do begin
      {build appropriate error message}
      strError := iff(Self.Name <> '', Self.Name, 'TMult_instance');
      strError := strError + '[' + Index + ']' + #13#10 + 'is undefined';
      try
        ParamRecord := Self.Owner;
        BrokerComponent := Self.Owner.Owner.Owner;
        if (ParamRecord is TParamRecord) and (BrokerComponent is TRPCBroker) then begin
          I := 0;
          {if there is an easier way to figure out which array element points
          to this instance of a multiple, use it}   // p13
          while TRPCBroker(BrokerComponent).Param[I] <> ParamRecord do inc(I);
          strError := '.Param[' + IntToStr(I) + '].' + strError;
          strError := iff(BrokerComponent.Name <> '', BrokerComponent.Name,
                          'TRPCBroker_instance') + strError;
        end;
      except
      end;
      raise Exception.Create(strError);
    end;
  end;
  Result := S.Str;
end;

{---------------------- TMult.SetGetSorted ------------------------
------------------------------------------------------------------}
function  TMult.GetSorted: boolean;
begin
  Result := FMultiple.Sorted;
end;

{---------------------- TMult.SetFMultiple ------------------------
Stores a new element in the multiple.  FMultiple (TStringList) is the
structure, which is used to hold the subscript and value pair.  Subscript
is stored as the String, value is stored as an object of the string.
------------------------------------------------------------------}
procedure TMult.SetFMultiple(Index: string; Value: string);
var
  S: TString;
  Pos: integer;
begin
  Pos := FMultiple.IndexOf(Index);       {see if this subscript already exists}
  if Pos = -1 then begin                 {if subscript is new}
    S := TString.Create;                {create string object}
    S.Str := Value;                     {put value in it}
    FMultiple.AddObject(Index, S);      {add it}
  end else
    TString(FMultiple.Objects[Pos]).Str := Value; { otherwise replace the value}
end;

{---------------------- TMult.SetSorted ------------------------
------------------------------------------------------------------}
procedure TMult.SetSorted(Value: boolean);
begin
  FMultiple.Sorted := Value;
end;

{-------------------------- TMult.Order --------------------------
Returns the subscript string of the next or previous element from the
StartSubscript.  This is very similar to the $O function available in M.
Null string ('') is returned when reaching beyong the first or last
element, or when list is empty.
Note: A major difference between the M $O and this function is that
      in this function StartSubscript must identify a valid subscript
      in the list.
------------------------------------------------------------------}
function TMult.Order(const StartSubscript: string; Direction: integer): string;
var
  Index: longint;
begin
  Result := '';
  if StartSubscript = '' then
    if Direction > 0 then Result := First
    else Result := Last
  else begin
    Index := Position(StartSubscript);
    if Index > -1 then
      if (Index < (Count - 1)) and (Direction > 0) then
        Result := FMultiple[Index + 1]
      else if (Index > 0) and (Direction < 0) then
        Result := FMultiple[Index - 1];
  end
end;

{------------------------- TMult.Position -------------------------
Returns the long integer value which is the index position of the
element in the list.  Opposite of TMult.Subscript().  Remember that
the list is 0 based!
------------------------------------------------------------------}
function TMult.Position(const Subscript: string): longint;
begin
  Result := FMultiple.IndexOf(Subscript);
end;

{------------------------ TMult.Subscript -------------------------
Returns the string subscript of the element whose position in the list
is passed in.  Opposite of TMult.Position().  Remember that the list is 0 based!
------------------------------------------------------------------}
function TMult.Subscript(const Position: longint): string;
begin
  Result := '';
  if (Position > -1) and (Position < Count) then
    Result := FMultiple[Position];
end;

{---------------------- TParamRecord.Create -----------------------
Creates TParamRecord instance and automatically creates TMult.  The
name of Mult is also set in case it may be need if exception will be raised.
------------------------------------------------------------------}
constructor TParamRecord.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMult := TMult.Create(Self);
  FMult.Name := 'Mult';
  {note: FMult is destroyed in the SetClearParameters method}
end;

destructor TParamRecord.Destroy;
begin
  FMult.Free;
  FMult := nil;
  inherited;
end;

{------------------------- TParams.Create -------------------------
------------------------------------------------------------------}
constructor TParams.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParameters := TList.Create;   {for now, empty list}
end;

{------------------------ TParams.Destroy -------------------------
------------------------------------------------------------------}
destructor TParams.Destroy;
begin
  Clear;                         {clear the Multiple first!}
  FParameters.Free;
  FParameters := nil;
  inherited Destroy;
end;

{------------------------- TParams.Assign -------------------------
------------------------------------------------------------------}
procedure TParams.Assign(Source: TPersistent);
var
  I: integer;
  SourceParams: TParams;
begin
  Self.Clear;
  SourceParams := Source as TParams;
  for I := 0 to SourceParams.Count - 1 do begin
    Self[I].Value := SourceParams[I].Value;
    Self[I].PType := SourceParams[I].PType;
    Self[I].Mult.Assign(SourceParams[I].Mult);
  end
end;

{------------------------- TParams.Clear --------------------------
------------------------------------------------------------------}
procedure TParams.Clear;
var
  ParamRecord: TParamRecord;
  I: integer;
begin
  if FParameters <> nil then begin
    for I := 0 to FParameters.Count - 1 do begin
      ParamRecord := TParamRecord(FParameters.Items[I]);
      if ParamRecord <> nil then begin  //could be nil if params were skipped by developer
        ParamRecord.FMult.Free;
        ParamRecord.FMult := nil;
        ParamRecord.Free;
      end;
    end;
    FParameters.Clear;             {release FParameters TList}
  end;
end;

{------------------------ TParams.GetCount ------------------------
------------------------------------------------------------------}
function TParams.GetCount: Word;
begin
  if FParameters = nil then Result := 0
  else Result := FParameters.Count;
end;

{---------------------- TParams.GetParameter ----------------------
------------------------------------------------------------------}
function TParams.GetParameter(Index: integer): TParamRecord;
begin
  if Index >= FParameters.Count then             {if element out of bounds,}
    while FParameters.Count <= Index do
      FParameters.Add(nil);                     {setup place holders}
  if FParameters.Items[Index] = nil then begin   {if just a place holder,}
    {point it to new memory block}
    FParameters.Items[Index] := TParamRecord.Create(Self);
    TParamRecord(FParameters.Items[Index]).PType := undefined; {initialize}
  end;
  Result := FParameters.Items[Index];            {return requested parameter}
end;

{---------------------- TParams.SetParameter ----------------------
------------------------------------------------------------------}
procedure TParams.SetParameter(Index: integer; Parameter: TParamRecord);
begin
  if Index >= FParameters.Count then             {if element out of bounds,}
    while FParameters.Count <= Index do
      FParameters.Add(nil);                     {setup place holders}
  if FParameters.Items[Index] = nil then         {if just a place holder,}
    FParameters.Items[Index] := Parameter;      {point it to passed parameter}
end;

{------------------------ TRPCBroker.Create -----------------------
------------------------------------------------------------------}
constructor TRPCBroker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {set defaults}

// This constant defined in the interface section needs to be updated for each release
  FBrokerVersion := CURRENT_RPC_VERSION;

  FClearParameters := boolean(StrToInt
                   (ReadRegDataDefault(HKCU,REG_BROKER,'ClearParameters','1')));
//                   (ReadRegDataDefault(HKLM,REG_BROKER,'ClearParameters','1')));
  FClearResults := boolean(StrToInt
                   (ReadRegDataDefault(HKCU,REG_BROKER,'ClearResults','1')));
//                   (ReadRegDataDefault(HKLM,REG_BROKER,'ClearResults','1')));
  FDebugMode := False;
  FParams := TParams.Create(Self);
  FResults := TStringList.Create;
  FServer := ReadRegDataDefault(HKCU,REG_BROKER,'Server','BROKERSERVER');
//  FServer := ReadRegDataDefault(HKLM,REG_BROKER,'Server','BROKERSERVER');
  FPulse  := TTimer.Create(Self);  //P6
  FListenerPort := StrToInt
                  (ReadRegDataDefault(HKCU,REG_BROKER,'ListenerPort','9200'));
//                  (ReadRegDataDefault(HKLM,REG_BROKER,'ListenerPort','9200'));
  FRpcVersion := '0';
  FRPCTimeLimit := MIN_RPCTIMELIMIT;
  with FPulse do ///P6
  begin
    Enabled := False;  //P6
    Interval := DEFAULT_PULSE; //P6
    OnTimer  := DoPulseOnTimer;  //P6
  end;
  FLogin := TVistaLogin.Create(Self);  //p13
  FKernelLogin := True;  //p13
  FUser := TVistaUser.Create; //p13
  FShowErrorMsgs := semRaise; //p13
  XWBWinsock := TXWBWinsock.Create;

  FIsBackwardCompatibleConnection := True;  // default

  IsVisual := True; //default

  Application.ProcessMessages;
end;

{----------------------- TRPCBroker.Destroy -----------------------
------------------------------------------------------------------}
destructor TRPCBroker.Destroy;
begin
  Connected := False;
  TXWBWinsock(XWBWinsock).Free;
  FParams.Free;
  FParams := nil;
  FResults.Free;
  FResults := nil;
  FPulse.Free; //P6
  FPulse := nil;
  FUser.Free;
  FUser := nil;
  FLogin.Free;
  FLogin := nil;
  inherited Destroy;
end;

{--------------------- TRPCBroker.CreateContext -------------------
This function is part of the overall Broker security.
The passed context string is essentially a Client/Server type option
on the server.  The server sets up MenuMan environment variables for this
context which will later be used to screen RPCs.  Only those RPCs which are
in the multiple field of this context option will be permitted to run.
------------------------------------------------------------------}
function TRPCBroker.CreateContext(strContext: string): boolean;
var
  InternalBroker: TRPCBroker;                       {use separate component}
  S: String;
begin
  Result := False;
  Connected := True;
  InternalBroker := nil;
  try
    InternalBroker := TRPCBroker.Create(Self);
    InternalBroker.FSocket := Self.Socket;   // p13 -- permits multiple broker connections to same server/port
    with InternalBroker do begin
{
      TXWBWinsock(InternalBroker.XWBWinsock).IsBackwardsCompatible := TXWBWinsock(Self.XWBWinsock).IsBackwardsCompatible;
      TXWBWinsock(InternalBroker.XWBWinsock).OriginalConnectionOnly := TXWBWinsock(Self.XWBWinsock).OriginalConnectionOnly;
}
      Tag := 1234;
      // 060919 added to support multiple brokers with both old and new connections
      Prefix := Self.Prefix;  // type of connection
      TXWBWinsock(InternalBroker.XWBWinsock).Prefix := Prefix;
      // 060919 end of addition
      ShowErrorMsgs := Self.ShowerrorMsgs;
      Server := Self.Server;                   {inherit application server}
      ListenerPort := Self.ListenerPort;       {inherit listener port}
      DebugMode := Self.DebugMode;             {inherit debug mode property}
      RemoteProcedure := 'XWB CREATE CONTEXT'; {set up RPC}
      Param[0].PType := literal;
      Param[0].Value := Encrypt(strContext);
      try
        S := strCall;
        if S = '1' then begin                   // make the call  // p13
          Result := True;                       // p13
          self.FCurrentContext := strContext;        // p13
        end else begin
          Result := False;
          self.FCurrentContext := '';
        end;
      except            // Code added to return False if User doesn't have access
        on e: EBrokerError do begin
          self.FCurrentContext := '';
          if Pos('does not have access to option',e.Message) > 0 then begin
            Result := False
          end else
            Raise;
        end;
      end;
      if RPCBError <> '' then
        self.RPCBError := RPCBError;
    end;
  finally
    InternalBroker.XWBWinsock := nil;
    InternalBroker.Free;                            {release memory}
  end;
end;

{------------------------ TRPCBroker.Loaded -----------------------
------------------------------------------------------------------}
procedure TRPCBroker.Loaded;
begin
  inherited Loaded;
end;

{------------------------- TRPCBroker.Call ------------------------
------------------------------------------------------------------}
procedure TRPCBroker.Call;
var
  ResultBuffer: TStrings;
begin
  ResultBuffer := TStringList.Create;
  try
    if ClearResults then ClearResults := True;
    lstCall(ResultBuffer);
    Self.Results.AddStrings(ResultBuffer);
  finally
    ResultBuffer.Clear;
    ResultBuffer.Free;
  end;
end;

{----------------------- TRPCBroker.lstCall -----------------------
------------------------------------------------------------------}
procedure TRPCBroker.lstCall(OutputBuffer: TStrings);
var
  ManyStrings: PChar;
begin
  ManyStrings := pchCall;            {make the call}
  OutputBuffer.SetText(ManyStrings); {parse result of call, format as list}
  StrDispose(ManyStrings);           {raw result no longer needed, get back mem}
end;

{----------------------- TRPCBroker.strCall -----------------------
------------------------------------------------------------------}
function TRPCBroker.strCall: string;
var
  ResultString: PChar;
begin
  ResultString := pchCall;           {make the call}
  Result := StrPas(ResultString);    {convert and present as Pascal string}
  StrDispose(ResultString);          {raw result no longer needed, get back mem}
end;

{--------------------- TRPCBroker.SetConnected --------------------
------------------------------------------------------------------}
procedure TRPCBroker.SetConnected(Value: Boolean);
var
  thisOwner: TComponent;
  RPCBContextor: TContextorControl;
  thisParent: TForm;
  BrokerDir, Str1, Str2, Str3 :string;
  // 060920  added to support SSH connection
  PseudoPort: Integer;
  PseudoServer, PseudoPortStr: String;
begin
  RPCBError := '';
  Login.ErrorText := '';
  if (Connected <> Value) and not(csReading in ComponentState) then begin
    if Value and (FConnecting <> Value) then begin                 {connect}
      // if change servers, remove SSH port, username, pw
      if not (FLastServer = '') then begin
        if (not (FLastServer = Server)) or (not (FLastPort = ListenerPort)) then begin
          SSHport := '';
          SSHUser := '';
          SSHpw := '';
        end;
      end;
      FLastServer := Server;
      FLastPort := ListenerPort;
      //
      FSocket := ExistingSocket(Self);
      FConnecting := True; // FConnected := True;
      try
        if FSocket = 0  then begin
          {Execute Client Agent from directory in Registry.}
          BrokerDir := ReadRegData(HKCU, REG_BROKER, 'BrokerDr');
//          BrokerDir := ReadRegData(HKLM, REG_BROKER, 'BrokerDr');
          if BrokerDir <> '' then
            ProcessExecute(BrokerDir + '\ClAgent.Exe', sw_ShowNoActivate)
          else
            ProcessExecute('ClAgent.Exe', sw_ShowNoActivate);

          if DebugMode and (not OldConnectionOnly) then begin
            Str1 := 'Control of debugging has been moved from the client to the server. To start a Debug session, do the following:'+#13#10#13#10;
            Str2 := '1. On the server, set initial breakpoints where desired.'+#13#10+'2. DO DEBUG^XWBTCPM.'+#13#10+'3. Enter a unique Listener port number (i.e., a port number not in general use).'+#13#10;
            Str3 := '4. Connect the client application using the port number entered in Step #3.';
            ShowMessage(Str1 + Str2 + Str3);
          end;

          CheckSSH;
          if not (FUseSecureConnection = secureNone) then begin
            if not StartSecureConnection(PseudoServer, PseudoPortStr) then
              exit;
            // Val(PseudoPortStr,PseudoPort,Code)
            PseudoPort := StrToInt(PseudoPortStr);
          end else begin
            PseudoPort := ListenerPort;
            PseudoServer := Server;
          end;
          TXWBWinsock(XWBWinsock).IsBackwardsCompatible := FIsBackwardCompatibleConnection;
          TXWBWinsock(XWBWinsock).OldConnectionOnly := FOldConnectionOnly;
          FSocket := TXWBWinsock(XWBWinsock).NetworkConnect(DebugMode, PseudoServer, // FServer,
                                PseudoPort, FRPCTimeLimit);
          Prefix := TXWBWinsock(XWBWinsock).Prefix;
          FIsNewStyleConnection := TXWBWinsock(XWBWinsock).IsNewStyle;
          AuthenticateUser(Self);
          StoreConnection(Self);  //MUST store connection before CreateContext()
          //CCOW start
          if (FContextor <> nil) and (length(CCOWtoken) = 0) then begin
          //Get new CCOW token
            CCOWToken := GetCCOWHandle(Self);
            if Length(CCOWToken) > 0 then begin
              try
                RPCBContextor := TContextorControl.Create(Application);
                RPCBContextor.Run('BrokerLoginModule#', PassCode1+PassCode2, TRUE, '*');
                CCOWsetUser(user.name, CCOWToken, Domain, user.Vpid, RPCBContextor);  //Clear token
                FCCOWLogonIDName := CCOW_LOGON_ID;
                FCCOWLogonIdValue := Domain;
                FCCOWLogonName := CCOW_LOGON_NAME;
                FCCOWLogonNameValue := user.name;
                if user.name <> '' then
                  FWasUserDefined := True;
                FCCOWLogonVpid := CCOW_LOGON_VPID;
                FCCOWLogonVpidValue := user.Vpid;
                RPCBContextor.Free;
                RPCBContextor := nil;
              except
                ShowMessage('Problem with Contextor.Run');
                FreeAndNil(RPCBContextor);
              end;
            end;   // if Length(CCOWToken) > 0
          end;  //if
          //CCOW end
          FPulse.Enabled := True; //P6 Start heartbeat.
          CreateContext('');      //Closes XUS SIGNON context.
        end else begin                     //p13
          StoreConnection(Self);
          FPulse.Enabled := True; //p13
        end;                      //p13
        FConnected := True;         // jli mod 12/17/01
        FConnecting := False;
        // 080620 if connected via SSH, With no command box
        //        visible, should let users know they have it.
        if not (CommandBoxProcessHandle = 0) then begin
          thisOwner := self.Owner;
          if (thisOwner is TForm) then begin
            thisParent := TForm(self.Owner);
            if not (Pos('(SSH Secure connection)',thisParent.Caption) > 0) then
              thisParent.Caption := thisParent.Caption + ' (SSH Secure connection)';
          end;
        end;
      except
        on E: EBrokerError do begin
          if E.Code = XWB_BadSignOn then
            TXWBWinsock(XWBWinsock).NetworkDisconnect(FSocket);
          FSocket := 0;
          FConnected := False;
          FConnecting := False;
          if not (CommandBoxProcessHandle = 0) then
            TerminateProcess(CommandBoxProcessHandle,10);
          FRPCBError := E.Message;               // p13  handle errors as specified
          if Login.ErrorText <> '' then
            FRPCBError := E.Message + chr(10) + Login.ErrorText;
          if Assigned(FOnRPCBFailure) then       // p13
            FOnRPCBFailure(Self)                 // p13
          else if ShowErrorMsgs = semRaise then
            Raise;                               // p13 //          raise;   {this is where I would do OnNetError}
        end{on};
      end{try};
    end{if}
    else if not Value then begin                           //p13
      FConnected := False;          //p13
      FPulse.Enabled := False;      //p13
      if RemoveConnection(Self) = NoMore then begin
        {FPulse.Enabled := False;  ///P6;p13 }
        TXWBWinsock(XWBWinsock).NetworkDisconnect(Socket);   {actually disconnect from server}
        FSocket := 0;                {store internal}
        //FConnected := False;      //p13
        // 080618 following added to close command box if SSH is being used
        if not (CommandBoxProcessHandle = 0) then begin
          TerminateProcess(CommandBoxProcessHandle,10);
          thisOwner := self.Owner;
          if (thisOwner is TForm) then begin
            thisParent := TForm(self.Owner);
            if (Pos('(SSH Secure connection)',thisParent.Caption) > 0) then begin
              // 080620 remove ' (SSH Secure connection)' on disconnection
              thisParent.Caption := Copy(thisParent.Caption,1,Length(thisParent.Caption)-24);
            end;
          end;
        end;
      end{if};
    end; {else}
  end{if};
end;

{----------------- TRPCBroker.SetClearParameters ------------------
------------------------------------------------------------------}
procedure TRPCBroker.SetClearParameters(Value: Boolean);
begin
  if Value then FParams.Clear;
  FClearParameters := Value;
end;

{------------------- TRPCBroker.SetClearResults -------------------
------------------------------------------------------------------}
procedure TRPCBroker.SetClearResults(Value: Boolean);
begin
  if Value then begin   {if True}
    FResults.Clear;
  end;
  FClearResults := Value;
end;

{---------------------- TRPCBroker.SetResults ---------------------
------------------------------------------------------------------}
procedure TRPCBroker.SetResults(Value: TStrings);
begin
  FResults.Assign(Value);
end;

{----------------------- TRPCBroker.SetRPCTimeLimit -----------------
------------------------------------------------------------------}
procedure   TRPCBroker.SetRPCTimeLimit(Value: integer);
begin
  if Value <> FRPCTimeLimit then begin
    if Value > MIN_RPCTIMELIMIT then
      FRPCTimeLimit := Value
    else
      FRPCTimeLimit := MIN_RPCTIMELIMIT;
  end;
end;

{----------------------- TRPCBroker.SetServer ---------------------
------------------------------------------------------------------}
procedure TRPCBroker.SetServer(Value: TServer);
begin
  {if changing the name of the server, make sure to disconnect first}
  if (Value <> FServer) and Connected then begin
    Connected := False;
  end;
  FServer := Value;
end;

{--------------------- TRPCBroker.pchCall ----------------------
Lowest level remote procedure call that a TRPCBroker component can make.
1. Returns PChar.
2. Converts Remote Procedure to PChar internally.
------------------------------------------------------------------}
function TRPCBroker.pchCall: PChar;
var
  Value, Sec, App: PChar;
  BrokerError: EBrokerError;
  blnRestartPulse : boolean;   //P6
begin
  RPCBError := '';
  Connected := True;
  BrokerError := nil;
  Value := nil;
  blnRestartPulse := False;   //P6

  Sec := StrAlloc(255);
  App := StrAlloc(255);

  try
    if FPulse.Enabled then          ///P6 if Broker was sending pulse,
    begin
      FPulse.Enabled := False;      ///   Stop pulse &
      blnRestartPulse := True;     //   Set flag to restart pulse after RPC.
    end;
{
    if Assigned(FOnRPCCall) then
    begin
      FOnRPCCall(Self, 1, RemoteProcedure, CurrentContext, RpcVersion, Param, FRPCTimeLimit, '', '', '', Now);
    end;
}
    try
      Value := TXWBWinsock(XWBWinsock).tCall(Socket, RemoteProcedure, RpcVersion, Param,
                      Sec, App,FRPCTimeLimit);
{
      if Assigned(FOnRPCCall) then
      begin
        FOnRPCCall(Self, 2, RemoteProcedure, CurrentContext, RpcVersion, Param, FRPCTimeLimit, Result, Sec, App, Now);
      end;
}
      if (StrLen(Sec) > 0) then
      begin
        BrokerError := EBrokerError.Create(StrPas(Sec));
        BrokerError.Code := 0;
        BrokerError.Action := 'Error Returned';
      end;
    except
      on Etemp: EBrokerError do
        with Etemp do
        begin                             //save copy of error
          BrokerError := EBrokerError.Create(message);  //field by field
          BrokerError.Action := Action;
          BrokerError.Code := Code;
          BrokerError.Mnemonic := Mnemonic;
          if Value <> nil then
            StrDispose(Value);
          Value := StrNew('');
          {if severe error, mark connection as closed.  Per Enrique, we should
          replace this check with some function, yet to be developed, which
          will test the link.}
          if ((Code >= 10050)and(Code <=10058))or(Action = 'connection lost') then
          begin
            Connected := False;
            blnRestartPulse := False;  //P6
          end;
        end;
    end;
  finally
    StrDispose(Sec); {do something with these}
    Sec := nil;
    StrDispose(App);
    App := nil;
    if assigned(FOnRPCCall) then
    begin
    	Result := Value;
    	if Result = nil then Result := StrNew('');
        self.FOnCallResultStr := Result;
    	FOnRPCCall(self);
    end;
    if ClearParameters then ClearParameters := True;    //prepare for next call
  end;
  Result := Value;
  if Result = nil then Result := StrNew('');            //return empty string
  if blnRestartPulse then FPulse.Enabled := True;       //Restart pulse. (P6)
  if BrokerError <> nil then
  begin
    FRPCBError := BrokerError.Message;               // p13  handle errors as specified
    if Login.ErrorText <> '' then
      FRPCBError := BrokerError.Message + chr(10) + Login.ErrorText;
    if Assigned(FOnRPCBFailure) then begin      // p13
      FOnRPCBFailure(Self);
      StrDispose(Result);
    end else if FShowErrorMsgs = semRaise then begin
      StrDispose(Result);                 // return memory we won't use - caused a memory leak
      Raise BrokerError;                               // p13
    end else   // silent, just return error message in FRPCBError
      BrokerError.Free;   // return memory in BrokerError - otherwise is a memory leak
//          raise;   {this is where I would do OnNetError}
  end;  // if BrokerError <> nil
end;

{------------------------ TRPCThreadBroker.Create -----------------------
------------------------------------------------------------------}
constructor TRPCThreadBroker.Create(AOwner: TComponent);
begin
 Inherited Create(AOwner);
 if assigned(XWBWinsock) then
  XWBWinsock.Free;
 XWBWinsock := TXWBThreadWinsock.Create;
 IsVisual := False;
end;

{-------------------------- DisconnectAll -------------------------
Find all connections in BrokerAllConnections list for the passed in
server:listenerport combination and disconnect them. if at least one
connection to the server:listenerport is found, then it and all other
Brokers to the same server:listenerport will be disconnected; True
will be returned.  Otherwise False will return.
------------------------------------------------------------------}
function DisconnectAll(Server: string; ListenerPort: integer): boolean;
var
  Index: integer;
begin
  Result := False;
  while (Assigned(BrokerAllConnections) and
        (BrokerAllConnections.Find(Server + ':' + IntToStr(ListenerPort), Index))) do begin
    Result := True;
    TRPCBroker(BrokerAllConnections.Objects[Index]).Connected := False;
    {if the call above disconnected the last connection in the list, then
    the whole list will be destroyed, making it necessary to check if it's
    still assigned.}
  end;
end;

{------------------------- StoreConnection ------------------------
Each broker connection is stored in BrokerConnections list.
------------------------------------------------------------------}
procedure StoreConnection(Broker: TRPCBroker);
begin
  if BrokerConnections = nil then {list is created when 1st entry is added}
    try
      BrokerConnections := TStringList.Create;
      BrokerConnections.Sorted := True;
      BrokerConnections.Duplicates := dupAccept;  {store every connection}
      BrokerAllConnections := TStringList.Create;
      BrokerAllConnections.Sorted := True;
      BrokerAllConnections.Duplicates := dupAccept;
    except
      TXWBWinsock(Broker.XWBWinsock).NetError('store connection',XWB_BldConnectList)
    end;
  BrokerAllConnections.AddObject(Broker.Server + ':' +
                              IntToStr(Broker.ListenerPort), Broker);
  BrokerConnections.AddObject(IntToStr(Broker.Socket), Broker);
end;

{------------------------ RemoveConnection ------------------------
Result of this function will be False, if there are no more connections
to the same server:listenerport as the passed in Broker.  if at least
one other connection is found to the same server:listenerport, then Result
will be True.
------------------------------------------------------------------}
function RemoveConnection(Broker: TRPCBroker): boolean;
var
  Index: integer;
begin
  Result := False;
  if Assigned(BrokerConnections) then begin
    {remove connection record of passed in Broker component}
    BrokerConnections.Delete(BrokerConnections.IndexOfObject(Broker));
    {look for one other connection to the same server:port}
//    Result := BrokerConnections.Find(Broker.Server + ':' + IntToStr(Broker.ListenerPort), Index);
    Result := BrokerConnections.Find(IntToStr(Broker.Socket), Index);
    if BrokerConnections.Count = 0 then begin {if last entry removed,}
      BrokerConnections.Free;                 {destroy whole list structure}
      BrokerConnections := nil;
    end;
  end;  // if Assigned(BrokerConnections)
  if Assigned(BrokerAllConnections) then begin
    BrokerAllConnections.Delete(BrokerAllConnections.IndexOfObject(Broker));
    if BrokerAllConnections.Count = 0 then begin
      BrokerAllConnections.Free;
      BrokerAllConnections := nil;
    end;
  end;   // if Assigned(BrokerAllConnections)
end;

{------------------------- ExistingSocket -------------------------
------------------------------------------------------------------}
function ExistingSocket(Broker: TRPCBroker): integer;
// var
//   Index: integer;
begin
  Result := Broker.Socket;
{  Result := 0;                        // p13 to permit multiple Broker connections

  if Assigned(BrokerConnections) and
     BrokerConnections.Find(Broker.Server + ':' + IntToStr(Broker.ListenerPort), Index) then
    Result := TRPCBroker(BrokerConnections.Objects[Index]).Socket;
}
end;

{------------------------ AuthenticateUser ------------------------
------------------------------------------------------------------}
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
begin
  with ConnectingBroker do
  begin
    SaveParam := TParams.Create(nil);
    SaveParam.Assign(Param);                  //save off settings
    SaveRemoteProcedure := RemoteProcedure;
    SaveRpcVersion := RpcVersion;
    SaveResults := Results;
    SaveClearParmeters := ClearParameters;
    SaveClearResults := ClearResults;
    ClearParameters := True;                  //set'em as I need'em
    ClearResults := True;
    SaveKernelLogin := FKernelLogin;     //  p13
    SaveVistaLogin := FLogin;            //  p13
  end;
  try
    blnSignedOn := False;                       //initialize to bad sign-on

    if ConnectingBroker.AccessVerifyCodes <> '' then   // p13 handle as AVCode single signon
    begin
      ConnectingBroker.Login.AccessCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 1);
      ConnectingBroker.Login.VerifyCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 2);
      ConnectingBroker.Login.Mode := lmAVCodes;
      ConnectingBroker.FKernelLogIn := False;
    end;

    //CCOW start
    if ConnectingBroker.KernelLogIn and (not (ConnectingBroker.Contextor = nil)) then begin
      CCOWtoken := ConnectingBroker.GetCCOWtoken(ConnectingBroker.Contextor);
      if length(CCOWtoken)>0 then begin
        ConnectingBroker.FKernelLogIn := false;
        ConnectingBroker.Login.Mode := lmAppHandle;
        ConnectingBroker.Login.LogInHandle := CCOWtoken;
      end;
     end;
     //CCOW end

    if not ConnectingBroker.FKernelLogIn then
    begin
      if ConnectingBroker.FLogin <> nil then     //the user.  vistalogin contains login info
        blnsignedon := SilentLogin(ConnectingBroker);    // RpcSLogin unit
      if not blnSignedOn then
      begin
        if not (ConnectingBroker.Contextor = nil) then begin     //Switch back to Kernel Login
          ConnectingBroker.FKernelLogIn := true;
          ConnectingBroker.Login.Mode := lmAVCodes;
          // set Contextor in Broker nil so it won't try to set token, etc.
          ConnectingBroker.Contextor := nil;
        end else begin
          TXWBWinsock(ConnectingBroker.XWBWinsock).NetworkDisconnect(ConnectingBroker.FSocket);
        end;
      end else
        GetBrokerInfo(ConnectingBroker);
    end;

    if ConnectingBroker.FKernelLogIn then
    begin   //p13
      CCOWToken := '';  //  061201 JLI if can't sign on with Token clear it so can get new one
      if Assigned(Application.OnException) then
         OldExceptionHandler := Application.OnException
      else
        OldExceptionHandler := nil;
      Application.OnException := TfrmErrMsg.RPCBShowException;
      frmSignon := TfrmSignon.Create(Application);
      try

    //    ShowApplicationAndFocusOK(Application);
        OldHandle := GetForegroundWindow;
        SetForegroundWindow(frmSignon.Handle);
        PrepareSignonForm(ConnectingBroker);
        if SetUpSignOn then begin                      //SetUpSignOn in loginfrm unit.
          if frmSignOn.lblServer.Caption <> '' then begin                                    //True if signon needed
            frmSignOn.ShowModal;                    //do interactive logon   // p13
            if frmSignOn.Tag = 1 then               //Tag=1 for good logon
              blnSignedOn := True;                   //Successfull logon
          end end else                                      //False when no logon needed
            blnSignedOn := NoSignOnNeeded;          //Returns True always (for now!)
        if blnSignedOn then begin                      //P6 if logged on, retrieve user info.
          GetBrokerInfo(ConnectingBroker);
          if not SelDiv.ChooseDiv('',ConnectingBroker) then begin
            blnSignedOn := False;//P8
            {Select division if multi-division user.  First parameter is 'userid'
            (DUZ or username) for future use. (P8)}
            ConnectingBroker.Login.ErrorText := 'Failed to select Division';  // p13 set some text indicating problem
          end;
        end;
        SetForegroundWindow(OldHandle);
      finally
        frmSignon.Free;
//      frmSignon.Release;                        //get rid of signon form

//      if ConnectingBroker.Owner is TForm then
//        SetForegroundWindow(TForm(ConnectingBroker.Owner).Handle)
//      else
//        SetForegroundWindow(ActiveWindow);
        ShowApplicationAndFocusOK(Application);
      end ; //try
      if Assigned(OldExceptionHandler) then
        Application.OnException := OldExceptionHandler;
    end;   //if kernellogin
                                                 // p13  following section for silent signon
  finally
    //reset the Broker
    with ConnectingBroker do
    begin
      ClearParameters := SaveClearParmeters;
      ClearResults := SaveClearResults;
      Param.Assign(SaveParam);                  //restore settings
      SaveParam.Free;
      RemoteProcedure := SaveRemoteProcedure;
      RpcVersion := SaveRpcVersion;
      Results := SaveResults;
      FKernelLogin := SaveKernelLogin;         // p13
      FLogin := SaveVistaLogin;                // p13
    end;
  end;

  if not blnSignedOn then                     //Flag for unsuccessful signon.
    TXWBWinsock(ConnectingBroker.XWBWinsock).NetError('',XWB_BadSignOn);               //Will raise error.

end;


{------------------------ GetBrokerInfo ------------------------
P6  Retrieve information about user with XWB GET BROKER INFO
    RPC. For now, only Timeout value is retrieved in Results[0].
------------------------------------------------------------------}
procedure GetBrokerInfo(ConnectedBroker: TRPCBroker);
begin
  GetUserInfo(ConnectedBroker);  //  p13  Get User info into User property (TVistaUser object)
  with ConnectedBroker do        //(dcm) Use one of objects below
  begin                          // and skip this RPC? or make this and
    RemoteProcedure := 'XWB GET BROKER INFO';   // others below as components
    try
      Call;
      if Results.Count > 0 then
        if StrToInt(Results[0]) > MINIMUM_TIMEOUT then
          FPulse.Interval := (StrToInt(Results[0]) * 10 * PULSE_PERCENTAGE);
    except
      on e: EBrokerError do
        ShowMessage('A problem was encountered getting Broker information.  '+e.Message);  //TODO
    end;
  end;
end;

{------------------------ NoSignOnNeeded ------------------------
------------------------------------------------------------------}
{Currently a placeholder for actions that may be needed in connection
with authenticating a user who needn't sign on (Single Sign on feature).
Returns True if no signon is needed
        False if signon is needed.}
function  NoSignOnNeeded : Boolean;
begin
  Result := True;
end;

{------------------------- ProcessExecute -------------------------
This function is borrowed from "Delphi 2 Developer's Guide" by Pacheco & Teixera.
See chapter 11, page 406.  It encapsulates and simplifies use of
Windows CreateProcess function.
------------------------------------------------------------------}
function ProcessExecute(Command: string; cShow: Word): Integer;
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
  StartUpInfo: TStartUpInfo;  // documented as STARTUPINFO
  ProcessInfo: TProcessInformation; // documented as PROCESS_INFORMATION
begin
  { Clear the StartupInfo structure }
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  { Initialize the StartupInfo structure with required data.
    Here, we assign the SW_XXXX constant to the wShowWindow field
    of StartupInfo. When specifing a value to this field the
    STARTF_USESSHOWWINDOW flag must be set in the dwFlags field.
    Additional information on the TStartupInfo is provided in the Win32
    online help under STARTUPINFO. }
  with StartupInfo do begin
    cb := SizeOf(TStartupInfo); // Specify size of structure
    dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    wShowWindow := cShow
  end;

  { Create the process by calling CreateProcess(). This function
    fills the ProcessInfo structure with information about the new
    process and its primary thread. Detailed information is provided
    in the Win32 online help for the TProcessInfo structure under
    PROCESS_INFORMATION. }
  Rslt := CreateProcess(PChar(Command), nil, nil, nil, False,
    NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  { if Rslt is true, then the CreateProcess call was successful.
    Otherwise, GetLastError will return an error code representing the
    error which occurred. }
  if Rslt then
    with ProcessInfo do begin
      { Wait until the process is in idle. }
      WaitForInputIdle(hProcess, INFINITE);
      CloseHandle(hThread); // Free the hThread  handle
      CloseHandle(hProcess);// Free the hProcess handle
      Result := 0;          // Set Result to 0, meaning successful
    end
  else Result := GetLastError; // Set result to the error code.
end;


{----------------------- GetAppHandle --------------------------
Library function to return an Application Handle from the server
which can be passed as a command line argument to an application
the current application is starting.  The new application can use
this AppHandle to perform a silent login via the lmAppHandle mode
----------------------------------------------------------------}
function  GetAppHandle(ConnectedBroker : TRPCBroker): String;   // p13
begin
  Result := '';
  with ConnectedBroker do begin
    RemoteProcedure := 'XUS GET TOKEN';
    Call;
    Result := Results[0];
  end;
end;

{----------------------- TRPCBroker.DoPulseOnTimer-----------------
Called from the OnTimer event of the Pulse property.
Broker environment should be the same after the procedure as before.
Note: Results is not changed by strCall; so, Results needn't be saved.
------------------------------------------------------------------}
procedure TRPCBroker.DoPulseOnTimer(Sender: TObject);  //P6
var
  SaveClearParameters : Boolean;
  SaveParam : TParams;
  SaveRemoteProcedure, SaveRPCVersion : string;
begin
  SaveClearParameters := ClearParameters;  //Save existing properties
  SaveParam := TParams.Create(nil);
  SaveParam.Assign(Param);
  SaveRemoteProcedure := RemoteProcedure;
  SaveRPCVersion      := RPCVersion;
  RemoteProcedure := 'XWB IM HERE';       //Set Properties for IM HERE
  ClearParameters  := True;               //Erase existing PARAMs
  RPCVersion      := '1.106';
  try
    try
      strCall;                                //Make the call
    except 
      on e: EBrokerError do begin
//        Connected := False;                // set the connection as disconnected
        if Assigned(FOnPulseError) then
          FOnPulseError(Self, e.Message)
        else
          raise e;
      end;
    end;
  finally
    ClearParameters := SaveClearParameters;  //Restore pre-existing properties.
    Param.Assign(SaveParam);
    SaveParam.Free;
    RemoteProcedure := SaveRemoteProcedure;
    RPCVersion      := SaveRPCVersion;
  end;
end;

procedure TRPCBroker.SetKernelLogIn(const Value: Boolean);   // p13
begin
  FKernelLogIn := Value;
end;
{
procedure TRPCBroker.SetLogIn(const Value: TVistaLogIn);     // p13
begin
  FLogIn := Value;
end;
}
procedure TRPCBroker.SetUser(const Value: TVistaUser);       // p13
begin
  FUser := Value;
end;


{*****TVistaLogin***** p13}

constructor TVistaLogin.Create(AOwner: TComponent);           // p13
begin
  inherited create;
  FDivLst := TStringList.Create;
end;

destructor TVistaLogin.Destroy;                              // p13
begin
  FDivLst.Free;
  FDivLst := nil;
  inherited;
end;

procedure TVistaLogin.FailedLogin(Sender: TObject);         // p13
begin
  if Assigned(FOnFailedLogin) then 
    FOnFailedLogin(Self)
  else 
    TXWBWinsock(TRPCBroker(Sender).XWBWinsock).NetError('',XWB_BadSignOn);
end;

procedure TVistaLogin.SetAccessCode(const Value: String);   // p13
begin
  FAccessCode := Value;
end;

procedure TVistaLogin.SetDivision(const Value: String);     // p13
begin
  FDivision := Value;
end;

procedure TVistaLogin.SetDuz(const Value: string);          // p13
begin
  FDUZ := Value;
end;

procedure TVistaLogin.SetErrorText(const Value: string);    // p13
begin
  FErrorText := Value;
end;

procedure TVistaLogin.SetLogInHandle(const Value: String);   // p13
begin
  FLogInHandle := Value;
end;

procedure TVistaLogin.SetMode(const Value: TLoginMode);      // p13
begin
  FMode := Value;
end;

procedure TVistaLogin.SetMultiDivision(Value: Boolean);      // p13
begin
  FMultiDivision := Value;
end;

procedure TVistaLogin.SetNTToken(const Value: String);       // p13
begin
end;

procedure TVistaLogin.SetPromptDiv(const Value: boolean);    // p13
begin
  FPromptDiv := Value;
end;

procedure TVistaLogin.SetVerifyCode(const Value: String);    // p13
begin
  FVerifyCode := Value;
end;

{***** TVistaUser ***** p13 }

procedure TVistaUser.SetDivision(const Value: String);       // p13
begin
  FDivision := Value;
end;

procedure TVistaUser.SetDTime(const Value: string);          // p13
begin
  FDTime := Value;
end;

procedure TVistaUser.SetDUZ(const Value: String);             // p13
begin
  FDUZ := Value;
end;

procedure TVistaUser.SetLanguage(const Value: string);       // p13
begin
  FLanguage := Value;
end;

procedure TVistaUser.SetName(const Value: String);           // p13
begin
  FName := Value;
end;

procedure TVistaUser.SetServiceSection(const Value: string);  // p13
begin
  FServiceSection := Value;
end;

procedure TVistaUser.SetStandardName(const Value: String);    // p13
begin
  FStandardName := Value;
end;

procedure TVistaUser.SetTitle(const Value: string);           // p13
begin
  FTitle := Value;
end;

procedure TVistaUser.SetVerifyCodeChngd(const Value: Boolean);   // p13
begin
  FVerifyCodeChngd := Value;
end;

Function ShowApplicationAndFocusOK(anApplication: TApplication): boolean;
var
  j: integer;
  Stat2: set of (sWinVisForm,sWinVisApp,sIconized);
begin
  Stat2 := []; {sWinVisForm,sWinVisApp,sIconized}

  if anApplication.MainForm <> nil then
    if IsWindowVisible(anApplication.MainForm.Handle)
      then Stat2 := Stat2 + [sWinVisForm];

  if IsWindowVisible(anApplication.Handle)
    then Stat2 := Stat2 + [sWinVisApp];

  if IsIconic(anApplication.Handle)
    then Stat2 := Stat2 + [sIconized];

  Result := true;
  if sIconized in Stat2 then begin {A}
    j := SendMessage(anApplication.Handle,WM_SYSCOMMAND,SC_RESTORE,0);
    Result := j<>0;
  end;
  if Stat2 * [sWinVisForm,sIconized] = [] then begin {S}
    if anApplication.MainForm <> nil then
      anApplication.MainForm.Show;
  end;
  if (Stat2 * [sWinVisForm,sIconized] <> []) or
     (sWinVisApp in Stat2) then begin {G}
(*{$IFNDEF D6_OR_HIGHER}
    hFGWnd := GetForegroundWindow;
    try
      AttachThreadInput(
          GetWindowThreadProcessId(hFGWnd, nil),
          GetCurrentThreadId,True);
      Result := SetForegroundWindow(anApplication.Handle);
    finally
      AttachThreadInput(
          GetWindowThreadProcessId(hFGWnd, nil),
          GetCurrentThreadId, False);
    end;
{$ENDIF}*)
  end;
end;

function TRPCBroker.WasUserDefined: Boolean;
begin
  Result := FWasUserDefined;
end;

function TRPCBroker.IsUserCleared: Boolean;
var
  CCOWcontextItem: IContextItemCollection;      //CCOW
  CCOWdataItem1: IContextItem;                  //CCOW
  Name: String;
begin
  Result := False;
  Name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
  try
    //See if context contains the ID item
    CCOWcontextItem := Contextor.CurrentContext;
    CCOWDataItem1 := CCowContextItem.Present(Name);
    if (CCOWdataItem1 <> nil) then    //1
    begin
      if CCOWdataItem1.Value = '' then
        Result := True
      else
        FWasUserDefined := True;
    end else
      Result := True;
  finally
  end; //try
end;


{----------------------- GetCCOWHandle --------------------------
Private function to return a special CCOW Handle from the server
which is set into the CCOW context.
The Broker of a new application can get the CCOWHandle from the context
and use it to do a ImAPPHandle Sign-on.
----------------------------------------------------------------}
function  TRPCBroker.GetCCOWHandle(ConnectedBroker : TRPCBroker): String;   // p13
begin
  Result := '';
  with ConnectedBroker do
  try                          // to permit it to work correctly if CCOW is not installed on the server.
    begin
      RemoteProcedure := 'XUS GET CCOW TOKEN';
      Call;
      Result := Results[0];
      Domain := Results[1];
      RemoteProcedure := 'XUS CCOW VAULT PARAM';
      Call;
      PassCode1 := Results[0];
      PassCode2 := Results[1];
    end;
  except
    Result := '';
  end;
end;

//CCOW start
procedure TRPCBroker.CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor: TContextorControl);
var
  CCOWdata: IContextItemCollection;             //CCOW
  CCOWdataItem1,CCOWdataItem2,CCOWdataItem3: IContextItem;
  CCOWdataItem4,CCOWdataItem5: IContextItem;    //CCOW
  Cname: string;
begin
  if Contextor <> nil then
  begin
    try
      //Part 1
      Contextor.StartContextChange;
      //Part 2 Set the new proposed context data
      CCOWdata := CoContextItemCollection.Create;
      CCOWdataItem1 := CoContextItem.Create;
      Cname := CCOW_LOGON_ID;
      CCOWdataItem1.Name := Cname;
      CCOWdataItem1.Value := domain;
      CCOWData.Add(CCOWdataItem1);
      CCOWdataItem2 := CoContextItem.Create;
      Cname := CCOW_LOGON_TOKEN;
      CCOWdataItem2.Name := Cname;
      CCOWdataItem2.Value := token;
      CCOWdata.Add(CCOWdataItem2);
      CCOWdataItem3 := CoContextItem.Create;
      Cname := CCOW_LOGON_NAME;
      CCOWdataItem3.Name := Cname;
      CCOWdataItem3.Value := Uname;
      CCOWdata.Add(CCOWdataItem3);
      //
      CCOWdataItem4 := CoContextItem.Create;
      Cname := CCOW_LOGON_VPID;
      CCOWdataItem4.Name := Cname;
      CCOWdataItem4.Value := Vpid;
      CCOWdata.Add(CCOWdataItem4);
      //
      CCOWdataItem5 := CoContextItem.Create;
      Cname := CCOW_USER_NAME;
      CCOWdataItem5.Name := Cname;
      CCOWdataItem5.Value := Uname;
      CCOWdata.Add(CCOWdataItem5);
      //Part 3 Make change
      Contextor.EndContextChange(true, CCOWdata);
      //We don't need to check CCOWresponce
    finally
    end;  //try
  end; //if
end;

//Get Token from CCOW context
function TRPCBroker.GetCCOWtoken(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem;                 //CCOW
  CCOWcontextItem: IContextItemCollection;      //CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_TOKEN;
  if (Contextor <> nil) then
  try
    CCOWcontextItem := Contextor.CurrentContext;
    //See if context contains the ID item
    CCOWdataItem1 := CCOWcontextItem.Present(name);
    if (CCOWdataItem1 <> nil) then    //1
    begin
      result := CCOWdataItem1.Value;
      if not (result = '') then
        FWasUserDefined := True;
    end;
    FCCOWLogonIDName := CCOW_LOGON_ID;
    FCCOWLogonName := CCOW_LOGON_NAME;
    FCCOWLogonVpid := CCOW_LOGON_VPID;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      FCCOWLogonIdValue := CCOWdataItem1.Value;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      FCCOWLogonNameValue := CCOWdataItem1.Value;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      FCCOWLogonVpidValue := CCOWdataItem1.Value;
    finally
  end; //try
end;

//Get Name from CCOW context
function TRPCBroker.GetCCOWduz(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem;                  //CCOW
  CCOWcontextItem: IContextItemCollection;      //CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
  try
    CCOWcontextItem := Contextor.CurrentContext;
    //See if context contains the ID item
    CCOWdataItem1 := CCOWcontextItem.Present(name);
    if (CCOWdataItem1 <> nil) then    //1
    begin
    result := CCOWdataItem1.Value;
    if result <> '' then
      FWasUserDefined := True;
    end;
  finally
  end; //try
end;

function TRPCBroker.IsUserContextPending(aContextItemCollection: IContextItemCollection): Boolean;
var
  CCOWdataItem1: IContextItem;                  //CCOW
  Val1: String;
begin
  result := false;
  if WasUserDefined() then // indicates data was defined
  begin
    Val1 := '';  // look for any USER Context items defined
    result := True;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonIDValue) then
        Val1 := '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonNameValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonVpidValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_USER_NAME);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = user.Name) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    if Val1 = '' then    // nothing defined or all matches, so not user context change
      result := False;
  end;
end;

{*
   procedure CheckSSH was extracted to remove duplicate code
   in the SetConnected method of Trpcb and derived classes
*}
procedure TRpcBroker.CheckSSH;
var
  ParamNum: Integer;
  ParamVal: String;
  ParamValNormal: String;
begin
  ParamNum := 1;
  while (not (ParamStr(ParamNum) = '')) do
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
    end;
    // check for SSH specifications on command line
    if Pos('SSHPORT=',ParamVal) = 1 then
      FSSHPort := Copy(ParamVal,9,Length(ParamVal));
    if Pos('SSHUSER=',ParamVal) = 1 then
      FSSHUser := Copy(ParamValNormal,9,Length(ParamVal));
    if Pos('SSHPW=',ParamVal) = 1 then
      FSSHpw := Copy(ParamValNormal,7,Length(ParamVal));
    if ParamVal = 'SSHHIDE' then
      FSSHhide := true;
    ParamNum := ParamNum + 1;
  end;
end;

function TRPCBroker.getSSHUsername: string;
var
  UsernameEntry: TSSHUsername;
begin
  UsernameEntry := TSSHUsername.Create(Self);
  UsernameEntry.ShowModal;
  Result := UsernameEntry.Edit1.Text;
  UsernameEntry.Free;
end;

function TRPCBroker.getSSHPassWord: string;
var
  PasswordEntry: TfPlinkPassword;
begin
  PasswordEntry := TfPlinkPassword.Create(Self);
  PasswordEntry.ShowModal;
  Result := PasswordEntry.Edit1.Text;
  PasswordEntry.Free;
end;

function TRPCBroker.StartSecureConnection(var PseudoServer, PseudoPort: String): Boolean;
var
  CmndLine: String;
begin
  // PseudoPort := NewSocket();
  PseudoPort := FSSHPort;
  if FSSHPort = '' then
    PseudoPort := IntToStr(ListenerPort);
  PseudoServer := '127.0.0.1';
  if (FSSHUser = '') then
  begin
    FSSHUser := getSSHUsername;
  end;
  if FUseSecureConnection = secureAttachmate then
  begin
    CmndLine := 'SSH2 -L '+PseudoPort+':'+FServer+':'+IntToStr(ListenerPort)+' -S -o "TryEmptyPassword yes" -o "MACs=hmac-sha1" -o "FipsMode yes" -o "StrictHostKeyChecking no" -o "connectionReuse no" '+FSSHUser+'@'+Server;
  end;
  if FUseSecureConnection = securePlink then
  begin
    if FSSHpw = '' then
    begin
      FSSHpw := getSSHPassWord
    end;
    CmndLine := 'plink.exe -L '+PseudoPort    // -v
         +':'+PseudoServer+':'+
        IntToStr(ListenerPort)+' '+FSSHUser+'@'+FServer +' -pw '+ FSSHpw;
      // IntToStr(ListenerPort)+' '+FSSHUser+'@'+FServer+' -pw 914Qemu5';
  end;
  if FSSHhide then
    StartProgSLogin(CmndLine, nil, SW_HIDE)
  else
    StartProgSLogin(CmndLine, nil, SW_SHOWMINIMIZED);
  Sleep(5000);
  result := true;
end;
{$WARN UNSAFE_CAST ON}

end.


{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Kevin Meldrum, Travis Hilton, Joel Ivey
	Description: Describes TSharedRPCBroker class.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit SharedRPCBroker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPCSharedBrokerSessionMgr1_TLB_SRB, Trpcb, ActiveX, Extctrls;
  // TRPCB is only used for data classes like TParams. There is no TRPCBroker dependency.


type
  TLogout = procedure () of object;

  TOnConnectionDropped = procedure (ConnectionIndex: Integer; ErrorText: WideString) of object;
{
  TOnClientConnected =  procedure (uniqueClientId: Integer) of object;
  TOnClientDisconnected =  procedure (uniqueClientId: Integer) of object;
}

// TSharedBrokerDataCollector is a data container class that collects all RPC call parameters BEFORE
// an RPC call is made. When the actual RPC call is made all of the parameters are turned into a WideString
// and passed through the Out-of-process COM interface to the TSharedBroker class found in VistASessionMgr.exe.
// After the call the results are put back into Results which is a TStrings class like in TRPCBroker.
// The parameters are stored in a local TParams member just like in TRPCBroker.
// All Connections to the backend Mumps server are done through TSharedBroker which actually instantiates a real
// TRPCBroker and uses it for the connection.

// Thus this class becomes a Delphi Component that wraps all of the data and keeps performance as high as possible.
// If these calls were to be moved into the VistASessionMgr.exe then there would be two major problems
//      1. Performance suffers when marshaling data across an out-of-process COM connection
//      2. It is impossible to keeps the same Params and Results access interface that exists in TRPCBroker
//         since the COM interface will not support structured data.

{
  Modified 11/27/2001 jli to TSharedRPCBroker from TSharedBrokerDataCollector,
  and changed as derived from TRPCBroker instead of TComponent, since other
  components have properties which are of Type TRPCBroker and the
  TSharedBrokerDataCollector derived from TComponent can't be used as a value
  for those properties.
}


//  TSharedBrokerDataCollector = class(TComponent)
  TSharedRPCBroker = class(TRPCBroker)
  private
{    FAccessVerifyCodes: TAccessVerifyCodes;
    FClearParameters: Boolean;
    FClearResults: Boolean;
    FConnected: Boolean;
    FConnecting: Boolean;
    FCurrentContext: String;
    FDebugMode: Boolean;
    FListenerPort: integer;
    FParams: TParams;
    FResults: TStrings;
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
}
    FAllowShared:     Boolean;
    FVistaSession:    ISharedBroker; // TSharedBroker;
    FCurrRPCVersion:  TRpcVersion;
//    FOnLogout:        TNotifyEvent;
    FOnLogout:        TLogout;
    FOnConnectionDropped: TOnConnectionDropped;
{
    FOnClientConnected: TOnClientConnected;
    FOnClientDisconnected: TOnClientDisconnected;
}
    FSinkCookie: LongInt;
    FKernelLogin: Boolean;
    FRPCTimeLimit: integer;
    FSocket: Integer;
    FRPCBError: String;
    FOnRPCBFailure: TOnRPCBFailure;
    FLogin: TVistaLogin;
    FUser: TVistaUser;
  protected
    procedure SetLoginStr(Str: string); virtual;
    procedure SetUserStr(Str: String);
    procedure      SetConnected(Value: Boolean); override;
    function       GetConnected: Boolean;
    procedure      SetResults(Value: TStrings); override;
    procedure      SetClearParameters(Value: Boolean); override;
    procedure      SetClearResults(Value: Boolean); override;
    procedure      SetRPCTimeLimit(Value: integer); override;  //Screen changes to timeout.
//    procedure      SetOnLogout(EventHandler: TNotifyEvent);
    procedure      SetOnLogout(EventHandler: TLogout);
    function       GetRpcVersion:TRpcVersion;
    procedure      SetRpcVersion(version: TRpcVersion);
    function   LoginStr: String;
{
    procedure      SetRPC(Value: TRemoteProc);
    function       GetRPC: TRemoteProc;
}
  public
    constructor    Create(AOwner: TComponent); override;
    destructor     Destroy; override;
//    procedure      OnLogoutEventHandlerDefault(Sender: TObject); virtual;
    procedure      OnLogoutEventHandlerDefault; virtual;
    procedure      OnConnectionDroppedHandler(ConnectionIndex: Integer; ErrorText: WideString); virtual;
    function       GetBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer): Integer;

    property    RPCBError: String read FRPCBError write FRPCBError;
    property    OnRPCBFailure: TOnRPCBFailure read FOnRPCBFailure write FOnRPCBFailure;

    property User: TVistaUser read FUser write FUser;  // jli
    property Login: TVistaLogin read FLogin write FLogin;  // jli
    property OnConnectionDropped: TOnConnectionDropped read FOnConnectionDropped write FOnConnectionDropped;
{
    property OnClientConnected: TOnClientConnected read FOnClientConnected write FOnClientConnected;
    property OnClientDisconnected: TOnClientDisconnected read FOnClientDisconnected write FOnClientDisconnected;
}
  published
    // Call is he invocation entry point of the RPC call.
    // The RPC Name, params, server and listener port must all be set up before
    // making this call
    procedure      Call; override;

    // lstCall is similar to the method Call, but puts Results in OutputBuffer
    // lstCall actually calls Call so it is really more efficient to use the
    // Call method and get the results from the Results property
    procedure      lstCall(OutputBuffer: TStrings); override;

    // pchCall makes an RPC call and returns the results in a PChar;
    // pchCall actually calls the Call method and then converts the results
    // to PChar before returning.
    // Making a call to Call and then using the Results property to get
    // results is more efficient
    function       pchCall: PChar; override;

    // strCall makes an RPC call and returns the results in a string;
    // strCall actually calls the Call method and then converts the results
    // to a string before returning.
    // Making a call to Call and then using the Results property to get
    // results is more efficient
    function       strCall: string; override;

    // CreateContext sets up the context for the RPC call on the M server
    function       CreateContext(strContext: string): boolean; override;


{
    // Server sets the server name or direct IP address
    // Must be set BEFORE making the connection or the default on the system
    // will be used
    property       Server: TServer read FServer write FServer;
}
    // AllowShared allows this connection to share with and existing one
    // Must be set BEFORE making a connection
    property       AllowShared: Boolean read FAllowShared write FAllowShared;
{
    // DebugMode turns the debug mode on or off.
    // Must be set BEFORE making an RPC Call
    property       DebugMode: boolean read FDebugMode write FDebugMode default False;

    // ListenerPort sets the listener port on the server
    // Must be set BEFORE making a connection
    property       ListenerPort: integer read FListenerPort write FListenerPort;

    // Param accesses the parameters for the RPC call.
    // Set them BEFORE making the RPC call
    property       Param: TParams read FParams write FParams;

    // Results contains the results of the most recent RPC call
    property       Results: TStrings read FResults write SetResults;

    // RemoteProcedure sets the name of the RPC to be made
    // Set this BEFORE making the Call
    property       RemoteProcedure: TRemoteProc read FRemoteProcedure1 write FRemoteProcedure1;
//    property       RemoteProcedure: TRemoteProc read GetRPC write SetRPC;

    // The RpcVersion property is used to tell the M server on the other end of the RPCBroker connection
    // which version of the RPC call it is expecting the M server to service. This is for the  Client
    // to specify.
    // Note: This is NOT the version of the RPCBroker!
    property       RpcVersion: TRpcVersion read GetRpcVersion write SetRpcVersion;

    // ClearParameters clears out the params data if set to true so one can start over easily with
    // new parameters
    property       ClearParameters: boolean read FClearParameters write SetClearParameters;

    // ClearResults clears out the Results data if set to true. This is from legacy code. In
    // the current implementation the Results from a recent call overwrite the current Results anyway.
    property       ClearResults: boolean read FClearResults write SetClearResults;
}
    // If Connected is set to True then it makes a BrokerConnection call to the VistASessionMgr.
//    property       Connected: boolean read FConnected write SetConnected;
    property        Connected: boolean  read GetConnected write SetConnected default False;

    // RPCTimeLimit allows the application to change the network operation timeout prior to a call.
    // This may be useful during times when it is known that a certain RPC, by its nature,
    // can take a significant amount of time to execute. The value of this property is an
    // integer that can not be less than 30 seconds nor greater that 32767 seconds.
    // Care should be taken when altering this value, since the network operation will block
    // the application until the operation finishes or the timeout is triggered.
    property       RPCTimeLimit : integer read FRPCTimeLimit write SetRPCTimeLimit;

    // OnLogout sets/gets the OnLogout event handler to be called whenever the VistASessionMgr
    // logs out.
//    property       OnLogout: TNotifyEvent read FOnLogout write SetOnLogout;
    property       OnLogout: TLogout read FOnLogout write SetOnLogout;

    property       Socket: Integer  read FSocket;

    property KernelLogin: Boolean read FKernelLogin write FKernelLogin default True;  // jli

  end;

implementation

uses ComObj, MfunStr, SharedRPCBrokerSink, fRPCBErrMsg;

const
  {Keys}
  REG_BROKER = 'Software\Vista\Broker';
  REG_VISTA  = 'Software\Vista';
  REG_SIGNON = 'Software\Vista\Signon';
  REG_SERVERS = 'Software\Vista\Broker\Servers';


procedure TSharedRPCBroker.SetLoginStr(Str: string);

   function TorF(Value: String): Boolean;
   begin
     Result := False;
     if Value = '1' then
       Result := True;
   end;
const
  SEP_FS = #28;
  SEP_GS = #29;
var
  DivStr: String;
  StrFS: String;
  StrGS: String;
  ModeVal: String;
  I: Integer;
  DivisionList: TStringList;
begin
  StrFS := SEP_FS;
  StrGS := SEP_GS;
  with FLogin do
  begin
    LoginHandle := Piece(Str,StrFS,1);
    NTToken := Piece(Str,StrFS,2);
    AccessCode := Piece(Str,StrFS,3);
    VerifyCode := Piece(Str,StrFS,4);
    Division := Piece(Str,StrFS,5);
    ModeVal := Piece(Str,StrFS,6);
    DivStr := Piece(Str,StrFS,7);
    MultiDivision := TorF(Piece(Str,StrFS,8));
    DUZ := Piece(Str,StrFS,9);
    PromptDivision := TorF(Piece(Str,StrFS,10));
    ErrorText := Piece(Str,StrFS,11);
    if ModeVal = '1' then
      Mode := lmAVCodes
    else if ModeVal = '2' then
      Mode := lmAppHandle
    else if ModeVal = '3' then
      Mode := lmNTToken;
    if DivStr <> '' then
    begin
      DivisionList := TStringList.Create;
      try
        I := 1;
        while Piece(DivStr,StrGS,I) <> '' do
        begin
          DivisionList.Add(Piece(DivStr,StrGS,I));
          Inc(I);
        end;    // while
        DivList.Assign(DivisionList);
      finally
        DivisionList.Free;
      end;
    end;
  end;  // with
end;

procedure TSharedRPCBroker.SetUserStr(Str: String);
const
  SEP_FS = #28;
var
  VC: String;
  StrFS: String;
begin
  StrFS := SEP_FS;
   with User do
   begin
     DUZ := Piece(Str,StrFS,1);
     Name := Piece(Str,StrFS,2);
     StandardName := Piece(Str,StrFS,3);
     Division := Piece(Str,StrFS,4);
     VC := Piece(Str,StrFS,5);
     Title := Piece(Str,StrFS,6);
     ServiceSection := Piece(Str,StrFS,7);
     Language := Piece(Str,StrFS,8);
     DTime := Piece(Str,StrFS,9);
     if VC = '0' then
       VerifyCodeChngd := False
     else if VC = '1' then
       VerifyCodeChngd := True;
   end;    // with
end;
  
function   TSharedRPCBroker.LoginStr: string;
   function TorF1(Value: Boolean): String;
   begin
     Result := '0';
     if Value then
       Result := '1';
   end;
   
const
  SEP_FS = #28;
  SEP_GS = #29;
var
  Str: String;
  ModeVal: String;
  DivLst: String;
  MultiDiv: String;
  PromptDiv: String;
  StrFS, StrGS: String;
begin
  Str := '';
    with FLogin do
    begin
      StrFS := SEP_FS;
      StrGS := SEP_GS;
      ModeVal := '';
      if Mode = lmAVCodes then
        ModeVal := '1'
      else if Mode = lmAppHandle then
        ModeVal := '2'
      else if Mode = lmNTToken then
        ModeVal := '3';
      DivLst := '';
      MultiDiv := TorF1(MultiDivision);
      PromptDiv := TorF1(PromptDivision);
      Str := LoginHandle + StrFS + NTToken + StrFS + AccessCode + StrFS;
      Str := Str + VerifyCode + StrFS + Division + StrFS + ModeVal + StrFS;
      Str := Str + DivLst + StrFS + MultiDiv + StrFS + DUZ + StrFS;
      Str := Str + PromptDiv + StrFS + ErrorText + StrFS;
    end;  // with
  Result := Str;
end;
  // Constructor and Destructor implemented here
constructor TSharedRPCBroker.Create(AOwner: TComponent);
const
  ProgID = 'RPCSharedBrokerSessionMgr.Application';
//var
//  brokerError: ISharedBrokerErrorCode;
//  regResult: WideString;
begin
  inherited Create(AOwner);
  FConnected := False;
  DebugMode := False;
  FParams := TParams.Create(Self);
//  FResults := TStringList.Create;
  RpcVersion := '0';
  FCurrRpcVersion := '0';
  FRPCTimeLimit := MIN_RPCTIMELIMIT;                   // MIN_RPCTIMELIMIT comes from TRPCBroker (30 seconds)
//  FAllowShared := False;
  FOnLogout := OnLogoutEventHandlerDefault;            // Supply this one incase the application doesn't
  FOnConnectionDropped := OnConnectionDroppedHandler;
  Server := '';
  ListenerPort := 0;

  FKernelLogin := True;            // jli
  FUser := TVistaUser.Create;  // jli
  FLogin := TVistaLogin.Create(Self);  // jli

//  CoInitialize(nil);
{  try
    if not (CoInitialize(nil) = S_OK) then
      ShowMessage('CoInitialize Problem!');
  except
  end;
}
end;

destructor TSharedRPCBroker.Destroy;
begin
  if Connected then  // FConnected
  begin
    Connected := False;
    FConnected := False;
  end;
  FParams.Free;
  FParams := nil;
{
  FResults.Free;
  FResults := nil;
}
  if FVistaSession <> nil then
  begin
//    FVistaSession.Free;
    FVistaSession := nil;
  end;
{
  FUser.Free;
  FLogin.Free;
}
  inherited;
end;

//procedure TSharedRPCBroker.OnLogoutEventHandlerDefault(Sender: TObject);
procedure TSharedRPCBroker.OnLogoutEventHandlerDefault;
begin
  // This event handler will get called if the application that uses
  // this component does not supply one.
  SendMessage(Application.MainForm.Handle,WM_CLOSE,0,0);
end;

procedure TSharedRPCBroker.OnConnectionDroppedHandler(ConnectionIndex: Integer; ErrorText: WideString);
var
  Str: String;
//  BrokerError: EBrokerError;
begin
  Str := ErrorText;
  RPCBShowErrMsg(ErrorText);
//  FConnected := False;
  // Raising an error here returns an error 'The Server Threw an exception' back into the server
//  BrokerError := EBrokerError.Create(Str);
//  raise BrokerError;
end;

// Published Methods implemented here
procedure TSharedRPCBroker.Call;
const
  SEP_FS = #28;
  SEP_GS = #29;
  SEP_US = #30;
  SEP_RS = #31;
var
  i, j, ErrCode: Integer;
  rpcParams, ASub, AVal: string;
  ReturnedResults: WideString;
  AnError: EBrokerError;
  ErrCode1: ISharedBrokerErrorCode;
begin
  try
  rpcParams := '';
  if not Connected then Connected := True;
  for i := 0 to Pred(Param.Count) do
  begin
    case Param[i].PType of
      literal: rpcParams := rpcParams + 'L' + SEP_FS;
    reference: rpcParams := rpcParams + 'R' + SEP_FS;
         list: rpcParams := rpcParams + 'M' + SEP_FS;
    else       rpcParams := rpcParams + 'U' + SEP_FS;
    end; {case}
    if Param[i].PType = list then
    begin
      for j := 0 to Pred(Param[i].Mult.Count) do
      begin
        ASub := Param[i].Mult.Subscript(j);
        AVal := Param[i].Mult[ASub];
        rpcParams := rpcParams + ASub + SEP_US + AVal + SEP_RS;
      end;
      rpcParams := rpcParams + SEP_GS;
    end else
    begin
      rpcParams := rpcParams + Param[i].Value + SEP_GS;
    end; {if Param[i]...else}
  end; {for i}
  if RpcVersion <> FCurrRpcVersion then
    FVistaSession.Set_RPCVersion(RPCVersion);

  RPCBError := '';
  
  ErrCode1 := FVistaSession.BrokerCall(RemoteProcedure, rpcParams, RPCTimeLimit, ReturnedResults, ErrCode);

  if ClearParameters = true then
    Param.Clear;

  if ErrCode1 = Success then
    Results.Text := ReturnedResults
  else
  begin
    Results.Text := '';
    RPCBError := FVistaSession.RpcbError;
    if Assigned(FOnRPCBFailure) then       // p13
      FOnRPCBFailure(Self)                 // p13
    else if ShowErrorMsgs = semRaise then
    begin
      AnError := EBrokerError.Create(FRPCBError);
      raise AnError;
    end
    else
      exit;
  end; {if ErrCode...else}
  except
    on e: Exception do
    begin
      AnError := EBrokerError.Create('Error: ' + e.Message);
      raise AnError;
    end;
  end;
end;

function TSharedRPCBroker.CreateContext(strContext: string): boolean;
var
  Intval: Integer;
begin
  // hides the RPCBroker CreateContext
  if not Connected then SetConnected(TRUE);  // FConnected

  Intval := FVistaSession.BrokerSetContext(strContext);
  Result := Intval = 1;
end;

procedure TSharedRPCBroker.lstCall(OutputBuffer: TStrings);
begin
  Call;
  OutputBuffer.Text := Results.Text;
end;

function TSharedRPCBroker.pchCall: PChar;
begin
  Call;
  Result := Results.GetText;
end;

function TSharedRPCBroker.strCall: string;
begin
  Call;
  Result := Results.Text;
end;

procedure TSharedRPCBroker.SetConnected(Value: Boolean);
var
  uniqueClientId: Integer;
  brokerError: ISharedBrokerErrorCode;
  regResult: WideString;
  CurrWindow: HWND;
  AnError: EBrokerError;
  UserStr: String;
  RPCError: WideString;
  BrokerErrorVal: EBrokerError;
  ShowErrMsgs: ISharedBrokerShowErrorMsgs;
  LoginStrX: WideString;
  SBSink: TSharedRPCBrokerSink;
begin
  try
  { call connect method for VistaSession }
  if Value then
  begin
    if FVistaSession = nil then
    begin
      FVistaSession := CreateComObject(CLASS_SharedBroker) as ISharedBroker;  // TSharedBroker.Create(self);
//      FVistaSession.Connect;
  //No need to keep hold of event sink. It will be destroyed
  //through interface reference counting when the client
  //disconnects from the server in the form's OnDestroy event handler
      SBSink := TSharedRPCBrokerSink.Create;
      SBSink.Broker := Self;
      InterfaceConnect(FVistaSession, ISharedBrokerEvents, SBSink, FSinkCookie);

//      ConnectEvents(FVistaSession);
{      If Assigned(FOnLogout) then
        FVistaSession.OnLogout := FOnLogout;
      if Assigned(FOnConnectionDropped) then
        FVistaSession.OnConnectionDropped := OnConnectionDroppedHandler;
}
      regResult := '';
      brokerError := FVistaSession.ReadRegDataDefault(HKLM,REG_BROKER,'ClearParameters','1',regResult);
      Assert(brokerError = Success);

      ClearParameters := boolean(StrToInt(regResult));  // FClearParameters

      brokerError := FVistaSession.ReadRegDataDefault(HKLM,REG_BROKER,'ClearResults','1',regResult);
      Assert(brokerError = Success);
      ClearResults := boolean(StrToInt(regResult));  // FClearResults

//      DebugMode := False;
//     FParams := TParams.Create(Self);
//      FResults := TStringList.Create;  ???

      if Server = '' then
      begin
        brokerError := FVistaSession.ReadRegDataDefault(HKLM,REG_BROKER,'Server','BROKERSERVER',regResult);
        Assert(brokerError = Success);
        Server := regResult;
      end;

      if ListenerPort = 0 then
      begin
        brokerError := FVistaSession.ReadRegDataDefault(HKLM,REG_BROKER,'ListenerPort','9000',regResult);
        Assert(brokerError = Success);
        ListenerPort := StrToInt(regResult);
      end;

      RpcVersion := '0';  // TODO: Remove this when the property is remove. It is UESLESS!

//      FRPCTimeLimit := MIN_RPCTIMELIMIT; //  MIN_RPCTIMELIMIT comes from TRPCBroker (30 seconds)
//      AllowShared := True;
    end;

    if FConnected <> True then  // FConnected
    begin
     // Connect to the M server through the COm Server
      CurrWindow := GetActiveWindow;
      if AccessVerifyCodes <> '' then   // p13 handle as AVCode single signon
      begin
        Login.AccessCode := Piece(AccessVerifyCodes, ';', 1);
        Login.VerifyCode := Piece(AccessVerifyCodes, ';', 2);
        Login.Mode := lmAVCodes;
        FKernelLogIn := False;
      end;
      if ShowErrorMsgs = semRaise then
        ShowErrMsgs := isemRaise
      else
        ShowErrMsgs := isemQuiet;
      BrokerError := GeneralFailure;
      LoginStrX := WideString(LoginStr);
      try
        brokerError := FVistaSession.BrokerConnect(ParamStr(0),BrokerClient,Server + ':' + IntToStr(ListenerPort),
                                                 DebugMode, FAllowShared, FKernelLogin, ShowErrMsgs, RPCTimeLimit, LoginStrX, uniqueClientId, RPCError);
      except
      end;
      FRPCBError := RPCError;
      SetLoginStr(LoginStrX);
      ShowApplicationAndFocusOK(Application);
      SetForegroundWindow(CurrWindow);
      if brokerError = Success then
      begin
        FConnected := True;  // FConnected
        FSocket := 1;  // temporarily handle socket until it can be pulled from Shared Broker;
        UserStr := FVistaSession.User;
        SetUserStr(UserStr);
      end
      else
      begin
        if Assigned(FOnRPCBFailure) then       // p13
            FOnRPCBFailure(Self)                 // p13
        else if ShowErrorMsgs = semRaise then
        begin
          BrokerErrorVal := EBrokerError.Create(FRPCBError);
          raise BrokerErrorVal;
        end;
      end;
    end;

  end else
  begin
    if FVistaSession<>nil then
    begin
      if FConnected = true then  // FConnected
      begin
        // Lets make the OnLogout event handler nil to eliminate
        // circularity problems before we do the disconnects.
        OnLogout := nil;

        FVistaSession.BrokerDisconnect;  // Disconnect from the Broker
//        FVistaSession.Disconnect;        // Disconnect from the COM server
        FSocket := 0;   // temporarily handle socket until it can be pulled from Shared Broker
      end;
//      FVistaSession.Free;
      InterfaceDisconnect(FVistaSession, ISharedBrokerEvents, FSinkCookie);
      FVistaSession := nil;
    end;
    FConnected := False; // FConnected
  end;
  except
    on e: Exception do
    begin
      AnError := EBrokerError.Create('Error: ' + e.Message);
      raise AnError;
    end;
  end;
end;

procedure TSharedRPCBroker.SetResults(Value: TStrings);
begin
  Results.Assign(Value);  // FResults
end;

procedure TSharedRPCBroker.SetClearParameters(Value: Boolean);
begin
  if Value then Param.Clear;  // FParams
  FClearParameters := Value;  // FClearParameters
end;

procedure TSharedRPCBroker.SetClearResults(Value: Boolean);
begin
  if Value then Results.Clear;  // FResults
  FClearResults := Value; // FClearResults
end;

procedure TSharedRPCBroker.SetRPCTimeLimit(Value: integer);
begin
  if Value <> RPCTimeLimit then  // FRPCTimeLimit
    if Value > MIN_RPCTIMELIMIT then
      FRPCTimeLimit := Value  // FRPCTimeLimit
    else
      FRPCTimeLimit := MIN_RPCTIMELIMIT;  // FRPCTimeLimit
end;

//procedure TSharedRPCBroker.SetOnLogout(EventHandler: TNotifyEvent);
procedure TSharedRPCBroker.SetOnLogout(EventHandler: TLogout);
begin
  FOnLogout := EventHandler;
//  if FVistaSession <> nil then
//    FVistaSession.OnLogout := FOnLogout;
end;

function  TSharedRPCBroker.GetRpcVersion: TRpcVersion;
begin
  if FVistaSession <> nil then Result := FVistaSession.RPCVersion else Result := '0';
end;

procedure  TSharedRPCBroker.SetRpcVersion(version: TRpcVersion);
begin
  if FVistaSession <> nil then FVistaSession.RPCVersion:= version;
end;

function TSharedRPCBroker.GetConnected: Boolean;
begin
  Result := FConnected;
end;

{
procedure TSharedRPCBroker.SetRPC(Value: TRemoteProc);
begin
  RemoteProcedure := Value;
end;

function TSharedRPCBroker.GetRPC: TRemoteProc;
begin
  Result := FRemoteProcedure1;
end;
}
{
procedure Register;
begin
  RegisterComponents('Kernel', [TSharedBrokerDataCollector]);
end;
}

function TSharedRPCBroker.GetBrokerConnectionIndexFromUniqueClientId(UniqueClientId: Integer): Integer;
var
  ConnectionIndex: Integer;
begin
  ConnectionIndex := -1;
  if FVistaSession <> nil then
    FVistaSession.GetActiveBrokerConnectionIndexFromUniqueClientId(UniqueClientId, ConnectionIndex);
  Result := ConnectionIndex;
end;

end.

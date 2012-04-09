{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Kevin Meldrum, Travis Hilton, Joel Ivey
	Description: SharedBroker functionality for the 
	             RPCSharedBrokerSessionMgr1.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit uSharedBroker1;

interface

uses
  Windows, ComObj, ActiveX, AxCtrls, Classes, RPCSharedBrokerSessionMgr1_TLB, StdVcl,
  Trpcb;

const
  kMilliSecondScale: double = 1000;
  kCloseAllClientsWaitTimeDefault: double = 10 * 1000; // In milliseconds
  kMillisecondTicksPerSecond: Extended = 1000;

type
  // RPCCallHistoryEntry contains the call name, params, results and other
  // info regarding a single rpc call. It is using in passing rpc info
  // around the history
  RPCCallHistoryEntry = class
  private
    FBrokerContext:   WideString;    // Context in which the RPC call was made
    FRpcName:         WideString;    // M name of the RPC call
    FParams:          WideString;    // M parameters to the RPC call
    FResults:         WideString;    // results of the call
    FStartDateTime:   Double;        // time/date just before the call was made
    FDurationInMS:    Longword;      // duration of the RPC in milliseconds
    FUniqueRPCCallId: Longword;      // Unique RPC call id
    FUniqueClientId:  Integer;       // The client that made the RPC

  public
    constructor Create; overload;
    constructor Create(context:WideString;
                       name:WideString;
                       params:WideString;
                       results:WideString;
                       startDateTime:Double;
                       durationInMS:Longword;
                       clientId:Integer); overload;

    property CallContext:WideString        read FBrokerContext   write FBrokerContext;
    property CallName:WideString           read FRpcName         write FRpcName;
    property CallParams:WideString         read FParams          write FParams;
    property CallResults:WideString        read FResults         write FResults;
    property CallStartDateTime:Double      read FStartDateTime   write FStartDateTime;
    property CallDurationInMS:Longword     read FDurationInMS    write FDurationInMS;
    property UniqueRPCCallId:longword      read FUniqueRPCCallId write FUniqueRPCCallId;
    property BrokerUniqueClientId:Integer  read FUniqueClientId  write FUniqueClientId;
  end;

  RPCCallHistoryEntryPointer = ^RPCCallHistoryEntry;

  // RPCCallHistory keeps track of RPCs and their Results. The end data/time and
  // duration of the call in milliseconds is recorded. The uniqueRPCId of the
  // call is recorded as well.
  RPCCallHistory = class(TList)
    constructor Create; overload;
  private
    FEnabled: boolean;

  public
    function    Add(entry: RPCCallHistoryEntry): Integer; reintroduce; overload;
    property    Enabled: boolean read FEnabled write FEnabled;
    function    GetRPCCallEntryPtr(uniqueRpcId:Longword;
                                   out rpcEntryPtr:RPCCallHistoryEntryPointer)
                                   : ISharedBrokerErrorCode;
    function    GetRPCCallEntryPtrFromIndex(rpcCallIndex:Integer;
                                   out rpcEntryPtr:RPCCallHistoryEntryPointer)
                                   : ISharedBrokerErrorCode;
    function    GetRPCCallClientId(uniqueRpcId:Integer;
                                   out uniqueClientId:Integer)
                                   : ISharedBrokerErrorCode;
  end;

  // Every TSharedBroker contains a reference to a TBrokerConnection.
  // The TBrokerConnection contains an actual instance to to a TRPCBroker
  // This is where the connection sharing takes place
  TBrokerConnection = class
  private
    FBroker:            TRPCBroker;
    FShared:            Boolean;
    FServerIP:          string;
    FServer:            string;
    FPort:              Integer;
    FRefCount:          Integer;
    FLastContext:       WideString;
    FConnectionIndex:   Integer;
  end;

  TSharedBroker = class(TAutoObject, IConnectionPointContainer, ISharedBroker)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
//    FConnectionPoint: TConnectionPoint;
//    FSinkList: TList;
    FEvents: ISharedBrokerEvents;

    FBrokerConnection:    TBrokerConnection;
    FBrokerContext:       WideString;
    FClientName:          WideString;
    FUniqueClientId:      Longword;
    FRpcCallHistory:      RPCCallHistory;
    FConnectType:         ISharedBrokerClient;
    FInGeneralClientList: Boolean;
//    FShowErrorMsgs:       ISharedBrokerShowErrorMsgs;

    procedure DoDisconnect;

  public
    Destructor Destroy; override;
    procedure Initialize; override;
    function GetEnumerator: IEnumConnections;
    function GetConnectionIndex: Integer;
  public
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function BrokerConnect(const ClientName: WideString;
      ConnectionType: ISharedBrokerClient; const ServerPort: WideString;
      WantDebug, AllowShared, KernelLoginVal: WordBool;
      ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT;
      var LoginStr: WideString; out UniqueClientIId: SYSINT;
      out ErrorMsg: WideString): ISharedBrokerErrorCode; safecall;
    function BrokerCall(const RpcName, RpcParams: WideString;
      RpcTimeLimit: Integer; out RpcResults: WideString;
      out UniqueRpcCallId: Integer): ISharedBrokerErrorCode; safecall;
    function BrokerDisconnect: ISharedBrokerErrorCode; safecall;
    function BrokerSetContext(
      const OptionName: WideString): ISharedBrokerErrorCode; safecall;
    function ReadRegDataDefault(Root: IRegistryRootEnum; const Key, Name,
      Default: WideString;
      out RegResult: WideString): ISharedBrokerErrorCode; safecall;
    function Get_PerClientRpcHistoryLimit: Integer; safecall;
    function Get_RpcHistoryEnabled: WordBool; safecall;
    function Get_RpcVersion: WideString; safecall;
    procedure Set_PerClientRpcHistoryLimit(limit: Integer); safecall;
    procedure Set_RpcHistoryEnabled(enabled: WordBool); safecall;
    procedure Set_RpcVersion(const version: WideString); safecall;
    function GetActiveBrokerConnectionIndexCount(
      out connectionIndexCount: Integer): ISharedBrokerErrorCode; safecall;
    function GetActiveBrokerConnectionIndexFromUniqueClientId(
      uniqueClientId: Integer;
      out connectionIndex: Integer): ISharedBrokerErrorCode; safecall;
    function GetActiveBrokerConnectionInfo(connectionIndex: Integer;
      out connectedServerIp: WideString; out connectedServerPort: Integer;
      out lastContext: WideString): ISharedBrokerErrorCode; safecall;
    function GetClientIdAndNameFromIndex(clientIndex: Integer;
      out uniqueClientId: Integer;
      out clientName: WideString): ISharedBrokerErrorCode; safecall;
    function GetClientNameFromUniqueClientId(uniqueClientId: Integer;
      out clientName: WideString): ISharedBrokerErrorCode; safecall;
    function GetRpcHistoryCountForClient(uniqueClientId: Integer;
      out rpcHistoryCount: Integer): ISharedBrokerErrorCode; safecall;
    function LogoutConnectedClients(
      logoutTimeLimit: Integer): ISharedBrokerErrorCode; safecall;
    function GetRpcCallFromHistoryIndex(uniqueClientId, rpcCallIndex: Integer;
      out uniqueRpcId: Integer; out brokerContext, rpcName, rpcParams,
      rpcResult: WideString; out rpcStartDateTime: Double;
      out rpcDuration: Integer): ISharedBrokerErrorCode; safecall;
    function GetRpcClientIdFromHistory(uniqueRpcId: Integer;
      out uniqueClientId: Integer;
      out clientName: WideString): ISharedBrokerErrorCode; safecall;
    function GetConnectedClientCount(
      out connectedClientCount: Integer): ISharedBrokerErrorCode; safecall;
    function GetRpcCallFromHistory(uniqueRpcId: Integer;
      out uniqueClientId: Integer; out brokerContext, rpcName, rpcParams,
      rpcResult: WideString; out rpcStartDateTime: Double;
      out rpcDuration: Integer): ISharedBrokerErrorCode; safecall;
    function Get_CurrentContext: WideString; safecall;
    function Get_KernelLogin: WordBool; safecall;
    function Get_Login: WideString; safecall;
    function Get_RpcbError: WideString; safecall;
    function Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs; safecall;
    function Get_Socket: Integer; safecall;
    function Get_User: WideString; safecall;
    procedure Set_KernelLogin(Value: WordBool); safecall;
    procedure Set_Login(const Value: WideString); safecall;
    procedure Set_ShowErrorMsgs(Value: ISharedBrokerShowErrorMsgs); safecall;

    property ClientName: WideString read FClientName write FClientName;
    property BrokerUniqueClientId: Longword read FUniqueClientId write FUniqueClientId;
    property RpcHistory: RPCCallHistory read FRpcCallHistory ;
    property ConnectType: ISharedBrokerClient read FConnectType write FConnectType;
    property BrokerConnectionIndex: Integer read GetConnectionIndex;
  end;

  // TSharedBrokerClientMgr is used as a global container to manage all of the clients of the shared broker
  // There is a single global instance of this class allocated below called ClientMgr;
  // Other classes within the RPCSharedBrokerSessionMgr can get at the client information through ClientMgr;
  // All new Send event methods should be implemented here.
  TSharedBrokerClientMgr = class
  private
    FAllConnections: TList;             // The list of unique ServerPort/Shared actual connections
    FAllConnectedClients: TList;        // All Clients connected through a broker connection
                                        // are added to this list
    FAllClients: TList;                 // Any TSharedBroker is added to this list
    FNextRpcUniqueId: Longword;
    FRpcCallHistoryEnabled: boolean;
    FPerClientRpcHistoryLimit: integer;
    FNoClientsHaveConnectedYet: boolean;
    FInProcessOfLoggingOutClients: boolean;
    FCloseAllClientsWaitTime : Double;
    FKillClientsStartedTime : Int64;
    FKillClientsCountdownStarted : boolean;

    procedure SetRpcCallHistoryEnabled(enabled: boolean);

  public
    constructor Create;
    destructor  Destroy; override;

    // event procedures
    // SendOnLogout sends the OnLogout event to all attached event controllers.
    // Messages are sent to both DebuggerClient and BrokerClient types
    procedure SendOnLogout;

    // SendOnRpcCallRecorded is only sent to DebuggerClient type connections
    // when any RPC call completes. The unique RPC id of the RPC is sent
    // as a parameter
    procedure SendOnRpcCallRecorded(uniqueRpcId: Longword);

    // SendOnClientConnect is only sent to DebuggerClient type connections
    // when any client successfully connects. The unique Id of that
    // client is passed as a parameter
    procedure SendOnClientConnect(uniqueClientId: Integer; connection: ISharedBrokerConnection);

    // SendOnClientDisconnect is only sent to DebuggerClient type connections
    // when any client disconnects. The unique Id of that
    // client is passed as a parameter
    procedure SendOnClientDisconnect(uniqueClientId: Integer);

    // SendOnContextChanged calls the OnContextChanged event handlers on DebbugerClient type
    // connections.
    procedure SendOnContextChanged(connectionIndex: Integer; newContext: WideString);

    // SendOnConnectionDropped (or other WSA___ error) calls the OnConnectionDropped event
    // handlers for DebuggerClient type and for BrokerClient types on the connection that encountered the error.
    procedure SendOnConnectionDropped(RPCBroker: TRPCBroker; ErrorText: String);

    // Connected Client management mmethods
    procedure CloseAllClients(maxWaitTime: Integer); // Wait time is in seconds
    procedure CheckDisconnectWaitTimeAndShutdownClients;
    procedure ListAllConnectedClients(AList: TStrings);
    procedure AddConnectedBrokerClient(broker: TSharedBroker);
    procedure RemoveConnectedBrokerClient(broker: TSharedBroker);
    function  ConnectedClientCount : integer;

    // General Client management methods
    procedure AddToGeneralClientList(broker: TSharedBroker);
    procedure RemoveFromGeneralClientList(broker: TSharedBroker);
    function  GeneralClientCount:Integer;

    property AllConnections: TList read FAllConnections write FAllConnections;
    property NoClientsHaveConnectedYet: Boolean read FNoClientsHaveConnectedYet write FNoClientsHaveConnectedYet;

    // General Methods
    function Piece(const S: string; Delim: char; PieceNum: Integer): string;

    // Methods for RPC history
    function GetNextRpcUniqueId: Longword;
    property RpcCallHistoryEnabled: boolean read FRpcCallHistoryEnabled write SetRpcCallHistoryEnabled;
    property PerClientRpcHistoryLimit: integer read FPerClientRpcHistoryLimit write FPerClientRpcHistoryLimit;

    function GetRpcCallEntryPtrFromHistory(uniqueRpcId: Longword;
                                 out rpcEntryPtr: RPCCallHistoryEntryPointer)
                                 : ISharedBrokerErrorCode;

    function GetRpcCallEntryPtrFromHistoryIndex(uniqueClientId: Longword;
                                 rpcCallIndex: Integer;
                                 out rpcEntryPtr: RPCCallHistoryEntryPointer)
                                 : ISharedBrokerErrorCode;

    function GetRpcClientIdFromHistory(uniqueRpcId: Integer;
                                 out uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;

    function GetRpcHistoryCountForClient(uniqueClientId: Integer;
                                 out rpcCount: Integer)
                                 : ISharedBrokerErrorCode;

    function GetClientIdAndNameFromIndex(clientIndex: Integer;
                                 out uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;

    function GetClientNameFromUniqueClientId(uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;

    function GetActiveBrokerConnectionIndexFromUniqueClientId(uniqueClientId: Integer;
                                 out connectionIndex: Integer)
                                 : ISharedBrokerErrorCode;

    procedure OnIdleEventHandler(Sender: TObject; var Done: Boolean);

    property InProcessOfLoggingOutClients: boolean read FInProcessOfLoggingOutClients write FInProcessOfLoggingOutClients;
    property CloseAllClientsWaitTime: Double read FCloseAllClientsWaitTime write FCloseAllClientsWaitTime;
    
  end;

  function GetPerformanceCounterTimeInMS: Int64;


var
  ClientMgr: TSharedBrokerClientMgr;

implementation

//uses ComServ;
uses Messages, ComServ, SysUtils, Forms, {lmdnonvs,} Math, XWBut1,
     syncobjs, Rpcconf1, MfunStr;

const
  kUniqueClientIdDefault: Longword = 0;
  kClientNameDefault: string = 'UNNAMED';
  kNextRpcUniqueIdInitialValue: Longword = 1; // Start numbering at 1
  kRpcCallHistoryEnabledDefault: boolean = false;
  kPerClientRpcHistoryLimitDefault: integer = 10;
  kUnassignedString: string = 'UNASSIGNED';
  kNoneString: string = 'NONE';

procedure SetBrokerLogin(Str: String; Broker: TRPCBroker);
const
  SEP_FS = #28;
  SEP_GS = #29;
var
  StrFS, StrGS: String;
  DivLst: String;
  ModeVal: String;

  function TorF(Value: String): Boolean;
  begin
    Result := False;
    if Value = '1' then
      Result := True;
  end;

begin
    with Broker.Login do
    begin
      StrFS := SEP_FS;
      StrGS := SEP_GS;
      LoginHandle := Piece(Str,StrFS,1);
      NTToken := Piece(Str,StrFS,2);
      AccessCode := Piece(Str,StrFS,3);
      VerifyCode := Piece(Str,StrFS,4);
      Division := Piece(Str,StrFS,5);
      ModeVal := Piece(Str,StrFS,6);
      DivLst := Piece(Str,StrFS,7);
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
    end;  // with
end;

function GetBrokerLogin(Broker: TRPCBroker): WideString;

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
  I: Integer;
  Str: String;
  ModeVal: String;
  DivLst: String;
  MultiDiv: String;
  PromptDiv: String;
  StrFS, StrGS: String;
begin
  Str := '';
    with Broker.Login do
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
      for i := 0 to Pred(DivList.Count) do
        DivLst := DivLst + DivList[i] + SEP_GS;
      MultiDiv := TorF1(MultiDivision);
      PromptDiv := TorF1(PromptDivision);
      Str := LoginHandle + StrFS + NTToken + StrFS + AccessCode + StrFS;
      Str := Str + VerifyCode + StrFS + Division + StrFS + ModeVal + StrFS;
      Str := Str + DivLst + StrFS + MultiDiv + StrFS + DUZ + StrFS;
      Str := Str + PromptDiv + StrFS + ErrorText + StrFS;
    end;  // with
  Result := Str;
end;


function GetPerformanceCounterTimeInMS: Int64;
var
  frequency: Int64;
  performanceCount: Int64;
  useNonPerformanceCounter: boolean;
begin
  useNonPerformanceCounter := false;
  Result := 0;

  if QueryPerformanceFrequency(frequency) then
  begin
    if frequency >= kMillisecondTicksPerSecond then
    begin
      if QueryPerformanceCounter(performanceCount) then
      begin
        Result := Trunc((performanceCount* kMillisecondTicksPerSecond)/frequency);
      end else
      begin
        useNonPerformanceCounter := true;
      end;
    end else
    begin
      useNonPerformanceCounter := true;
    end;
  end else
  begin
    useNonPerformanceCounter := true;
  end;

  if useNonPerformanceCounter = true then
    Result := GetTickCount;
end;


procedure TSharedBroker.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ISharedBrokerEvents;
end;

function TSharedBroker.GetEnumerator: IEnumConnections;
var
  Container: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;
begin
  OleCheck(QueryInterface(IConnectionPointContainer,Container));
  OleCheck(Container.FindConnectionPoint(AutoFactory.EventIID,ConnectionPoint));
  ConnectionPoint.EnumConnections(Result);
end;

procedure TSharedBroker.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  FUniqueClientId := kUniqueClientIdDefault;
  FClientName := kClientNameDefault;
  FRpcCallHistory := RPCCallHistory.Create();

  // Use this for multiple client connections to this server
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckMulti, EventConnect);

  // add both connected and non connected clients to the general client list
  ClientMgr.AddToGeneralClientList(self);
  FInGeneralClientList := true;

end;


destructor TSharedBroker.Destroy;
begin
  DoDisconnect;

  FRpcCallHistory.Free;
  FRpcCallHistory := nil;

  inherited Destroy;

  // Remove self from the general client list
  if FInGeneralClientList = true then
  begin
    ClientMgr.RemoveFromGeneralClientList(self);
    FInGeneralClientList := False;
  end;
end;

{
function TSharedBroker.BrokerConnect(const clientName: WideString;
  connectionType: ISharedBrokerClient; const serverPort: WideString;
  wantDebug, allowShared: WordBool; rpcTimeLimit: SYSINT;
  out uniqueClientIId: SYSINT): ISharedBrokerErrorCode;
}
function TSharedBroker.BrokerConnect(const ClientName: WideString;
  ConnectionType: ISharedBrokerClient; const ServerPort: WideString;
  WantDebug, AllowShared, KernelLoginVal: WordBool;
  ShowErrMsgs: ISharedBrokerShowErrorMsgs; RpcTimeLim: SYSINT;
  var LoginStr: WideString; out UniqueClientIId: SYSINT;
  out ErrorMsg: WideString): ISharedBrokerErrorCode;
safecall;
var
  aBrokerConnection: TBrokerConnection;
  i: Integer;
  connectMessage : ISharedBrokerConnection;
  serverIP,serverStr: string;
  port: Integer;
begin
  Result := CouldNotConnect;
  ErrorMsg := '';
  connectMessage := Failed;

  if connectionType = BrokerClient then
  begin
    // First separate out the server/port param into server and port strings
    // next look up the serverIP from the server name.
    // If valid proceed otherwise error.
    serverStr := ClientMgr.Piece(serverPort, ':', 1);
    // use a default for the port in case it is not sent in
    port := StrToIntDef(ClientMgr.Piece(ServerPort, ':', 2), 9200);

    serverIP := GetServerIP(serverStr);

    aBrokerConnection := nil;
    if AllowShared then
      for i := 0 to Pred(ClientMgr.AllConnections.Count) do
        // Compare against the server IP and the port since a server name
        // is not unique.
        if (TBrokerConnection(ClientMgr.AllConnections.Items[i]).FServerIP = serverIP) and
//        if (TBrokerConnection(ClientMgr.AllConnections.Items[i]).FServerIP = serverStr) and
           (TBrokerConnection(ClientMgr.AllConnections.Items[i]).FPort = port) and
            TBrokerConnection(ClientMgr.AllConnections.Items[i]).FShared then
              aBrokerConnection := TBrokerConnection(ClientMgr.AllConnections.Items[i]);

    if aBrokerConnection = nil then
    begin

      aBrokerConnection := TBrokerConnection.Create;
      aBrokerConnection.FBroker := TRPCBroker.Create(Application);
      ConnectType := BrokerClient;

      with aBrokerConnection.FBroker do
      begin
        ClearParameters := True;
        ClearResults    := True;
        DebugMode       := wantDebug;
//        Server          := serverIP;
        Server          := serverStr;
        ListenerPort    := port;
        RPCTimeLimit    := rpcTimeLim;
        KernelLogin     := KernelLoginVal;
        OnPulseError    := ClientMgr.SendOnConnectionDropped;
        SetBrokerLogin(LoginStr, aBrokerConnection.FBroker);
        if ShowErrMsgs = isemRaise then
          ShowErrorMsgs := semRaise
        else
          ShowErrorMsgs := semQuiet; 
        try
          Connected       := True;
          ErrorMsg := RPCBError;
        except
          ErrorMsg := RPCBError;
        end;
      end;

      LoginStr := GetBrokerLogin(aBrokerConnection.FBroker);
      aBrokerConnection.FShared          := allowShared;
      aBrokerConnection.FServer          := serverStr;
      aBrokerConnection.FPort            := port;
      aBrokerConnection.FServerIP        := serverIP;
      aBrokerConnection.FConnectionIndex := ClientMgr.AllConnections.Count;

      if aBrokerConnection.FBroker.Connected = true then
      begin
        ClientMgr.AllConnections.Add(aBrokerConnection);
        if aBrokerConnection.FShared then       // Set up for cleaning between RPC calls
        begin
          aBrokerConnection.FBroker.RemoteProcedure := 'XUS SET SHARED';
          aBrokerConnection.FBroker.Param.Clear;
          aBrokerConnection.FBroker.Call;
        end;
      end;

      connectMessage := New;
    end else
    begin
      connectMessage := Shared;
    end;

    if aBrokerConnection.FBroker.Connected then
    begin
      Result := Success;
      Inc(aBrokerConnection.FRefCount);
      FBrokerConnection     := aBrokerConnection;
    end else
    begin
      connectMessage := Failed;
      Result := CouldNotConnect;
    end;
    Set_RpcHistoryEnabled(ClientMgr.RpcCallHistoryEnabled);
  end
  else if connectionType = DebuggerClient then
  begin
    ConnectType := DebuggerClient;

    // Debugger clients enable RPC history for Al clients by default
    Set_RpcHistoryEnabled(true);

    connectMessage := Debug;
    Result := Success;
  end;

  FBrokerContext        := '';


  FClientName           := clientName;          // The name passed in should be the name
                                                // of the executable
  BrokerUniqueClientId  := Longword(self);      // The self pointer is unique and could
                                                // be dereference later on so use it.
                                                // store it locally for quick access
  uniqueClientIId       := BrokerUniqueClientId;// Put the unique client id back in
                                                // the out param as well.

  // Only add connected clients to the connected broker client list
  if (Result = Success) and (ConnectType <> DebuggerClient)then
  begin
    ClientMgr.AddConnectedBrokerClient(self);

    // Be sure to send the OnClientConnect message to any
    // debugger clients
    ClientMgr.SendOnClientConnect(BrokerUniqueClientId,connectMessage);
  end;
end;

function TSharedBroker.BrokerSetContext(
  const optionName: WideString): ISharedBrokerErrorCode;
begin
  // So don't set the context if it is already the same on
  // on the current connection. Also store the new context
  // in the connection.
  Result := Success;
  if FBrokerConnection.FLastContext <> optionName then
  begin
    if FBrokerConnection.FBroker.CreateContext(optionName) then
    begin
      FBrokerConnection.FLastContext := optionName;
      FBrokerContext := optionName;
      Result := Success;
      ClientMgr.SendOnContextChanged(FBrokerConnection.FConnectionIndex,optionName);
    end else
    begin
      Result := CouldNotSetContext;
      FBrokerConnection.FLastContext := '';
      FBrokerContext := '';
    end;
  end;
end;

function TSharedBroker.BrokerCall(const rpcName, rpcParams: WideString;
  rpcTimeLimit: Integer; out rpcResults: WideString;
  out uniqueRpcCallId: Integer): ISharedBrokerErrorCode;
const
  SEP_FS = #28;
  SEP_GS = #29;
  SEP_US = #30;
  SEP_RS = #31;
var
  i, curStart, lengthOfrpcParams, endOfSegment: Integer;
  aRef, aVal: string;
  startTimeMS, timeElapsedMS: Int64;
  currentDateTime: TDateTime;
  rpcEntry: RPCCallHistoryEntry;

  function PosNext(aChar: WideChar; startPos: Integer): Integer;
  begin
    Result := 0;
    while (Result = 0) and (StartPos <= lengthOfrpcParams) do
    begin
      if rpcParams[StartPos] = aChar then Result := startPos;
      Inc(startPos);
    end;
  end;

begin
  Result := Success;
  rpcResults := '';
  startTimeMS := 0;
  currentDateTime := 0;

  BrokerSetContext(FBrokerContext);

  if Result <> Success then Exit;

  // setup and make the RPC call
  FBrokerConnection.FBroker.ClearParameters := True;
  FBrokerConnection.FBroker.RemoteProcedure := rpcName;

  // Set RPC timeout
  FBrokerConnection.FBroker.RPCTimeLimit := rpcTimeLimit;

  curStart := 1;
  i := 0;
  lengthOfrpcParams := Length(rpcParams);
  while curStart < lengthOfrpcParams do
  begin
    case rpcParams[curStart] of
    'L': FBrokerConnection.FBroker.Param[i].PType := literal;
    'R': FBrokerConnection.FBroker.Param[i].PType := reference;
    'M': FBrokerConnection.FBroker.Param[i].PType := list;
    else FBrokerConnection.FBroker.Param[i].PType := undefined;
    end;
    Inc(curStart, 2);
    if FBrokerConnection.FBroker.Param[i].PType = list then
    begin
//      endOfSegment := 0;
      while rpcParams[curStart] <> SEP_GS do
      begin
        endOfSegment := PosNext(SEP_US, curStart);
        aRef := Copy(rpcParams, curStart, endOfSegment - curStart);
        curStart := endOfSegment + 1;
        endOfSegment := PosNext(SEP_RS, curStart);
        aVal := Copy(rpcParams, curStart, endOfSegment - curStart);
        curStart := endOfSegment + 1;
        FBrokerConnection.FBroker.Param[i].Mult[aRef] := aVal;
      end; {while rpcParams}
      {if endOfSegment = 0 then} endOfSegment := PosNext(SEP_GS, curStart);
      curStart := endOfSegment + 1;
    end else
    begin
      endOfSegment := PosNext(SEP_GS, curStart);
      FBrokerConnection.FBroker.Param[i].Value :=
        Copy(rpcParams, curStart, endOfSegment - curStart);
      curStart := endOfSegment + 1;
    end; {if Param[i].PType ... else}
    Inc(i);
  end; {while curStart}

  if Get_RpcHistoryEnabled = true then
  begin
  // Get the current time and date of this call
  // start the millisecond counter
    startTimeMS := GetPerformanceCounterTimeInMS;
    currentDateTime := Date;
  end;

  FBrokerConnection.FBroker.Call;

  RPCResults := FBrokerConnection.FBroker.Results.Text;

  if FBrokerConnection.FBroker.RPCBError <> '' then
    Result := GeneralFailure;

  if ClientMgr.RpcCallHistoryEnabled then
  begin
    timeElapsedMS := GetPerformanceCounterTimeInMS - startTimeMS;

    rpcEntry :=  RPCCallHistoryEntry.Create(
        FBrokerContext,
        rpcName,
        rpcParams,
        RPCResults,
        Double(currentDateTime),
        Longword(timeElapsedMS),
        BrokerUniqueClientId
      );

    RpcHistory.Add(rpcEntry);

    // Now fire the event so any debugger connected can
    // read it
    ClientMgr.SendOnRpcCallRecorded(rpcEntry.UniqueRPCCallId);
  end;
end;

procedure TSharedBroker.DoDisconnect;
begin
  if FBrokerConnection<>nil then
  begin
    Dec(FBrokerConnection.FRefCount);
    if FBrokerConnection.FRefCount = 0 then
    begin
      if ConnectType = BrokerClient then
        FBrokerConnection.FBroker.Destroy;

      if ClientMgr <> nil then
        ClientMgr.AllConnections.Remove(FBrokerConnection);

      FBrokerConnection.Free;
    end;

   FBrokerConnection := nil;
   FBrokerContext    := '';

   if ConnectType <> DebuggerClient then
   begin
     ClientMgr.RemoveConnectedBrokerClient(Self);
     // Send a message to all debugger clients that
     // a non-debugger client has disconnected
     ClientMgr.SendOnClientDisconnect(BrokerUniqueClientId);
   end;
 end;
end;

function TSharedBroker.BrokerDisconnect: ISharedBrokerErrorCode;
begin
  DoDisconnect;
  Result := Success;
end;

function TSharedBroker.ReadRegDataDefault(Root: IRegistryRootEnum;
  const Key, Name, Default: WideString;
  out RegResult: WideString): ISharedBrokerErrorCode;
var
  marshalledRoot: LongWord;
begin
  // do a little data marshaling here
  case Root of
    IRegistryRootEnum(HKCR) : marshalledRoot := HKCR;
    IRegistryRootEnum(HKCU) : marshalledRoot := HKCU;
    IRegistryRootEnum(HKLM) : marshalledRoot := HKLM;
    IRegistryRootEnum(HKU)  : marshalledRoot := HKU;
    IRegistryRootEnum(HKCC) : marshalledRoot := HKCC;
  else
    marshalledRoot := HKDD;
  end;

  regResult := XWBut1.ReadRegDataDefault(marshalledRoot,key,name,default);
  Result := Success;
end;

function TSharedBroker.Get_RpcVersion: WideString;
begin
  if FBrokerConnection <> nil then
  begin
    Result := FBrokerConnection.FBroker.RpcVersion;
  end else
  begin
    // Don't know what else to make this if we don't actually have a TRPCBroker to ask
    Result := '0';
  end;
end;

procedure TSharedBroker.Set_RpcVersion(const version: WideString);
begin
  if FBrokerConnection <> nil then
  begin
    FBrokerConnection.FBroker.RpcVersion := version;
  end
end;

function TSharedBroker.Get_PerClientRpcHistoryLimit: Integer;
begin
  Result := ClientMgr.PerClientRpcHistoryLimit;
end;

function TSharedBroker.Get_RpcHistoryEnabled: WordBool;
begin
  // If debugger client then operate on all of the clients
  // else just operate on this one
  if ConnectType = DebuggerClient then
    Result := ClientMgr.RpcCallHistoryEnabled
  else
    Result := RpcHistory.Enabled;
end;

function TSharedBroker.GetConnectedClientCount(
  out connectedClientCount: Integer): ISharedBrokerErrorCode;
begin
  connectedClientCount := ClientMgr.ConnectedClientCount;

  Result := Success;
end;

function TSharedBroker.GetRpcCallFromHistory(uniqueRpcId: Integer;
  out uniqueClientId: Integer; out brokerContext, rpcName, rpcParams,
  rpcResult: WideString; out rpcStartDateTime: Double;
  out rpcDuration: Integer): ISharedBrokerErrorCode;
var
  rpcEntryPtr: RPCCallHistoryEntryPointer;
begin
  Result := ClientMgr.GetRPCCallEntryPtrFromHistory(uniqueRpcId,rpcEntryPtr);

  if Result = Success then
  begin
    uniqueClientId   := rpcEntryPtr^.BrokerUniqueClientId;
    brokerContext    := rpcEntryPtr^.CallContext;
    rpcName          := rpcEntryPtr^.CallName;
    rpcParams        := rpcEntryPtr^.CallParams;
    rpcResult        := rpcEntryPtr^.CallResults;
    rpcStartDateTime := rpcEntryPtr^.CallStartDateTime;
    rpcDuration      := rpcEntryPtr^.CallDurationInMS;
  end else
  begin
    uniqueClientId   := 0;
    brokerContext    := '';
    rpcName          := '';
    rpcParams        := '';
    rpcResult        := '';
    rpcStartDateTime := 0;
    rpcDuration      := 0;
  end;
end;

function TSharedBroker.GetRpcCallFromHistoryIndex(uniqueClientId,
  rpcCallIndex: Integer; out uniqueRpcId: Integer; out brokerContext,
  rpcName, rpcParams, rpcResult: WideString; out rpcStartDateTime: Double;
  out rpcDuration: Integer): ISharedBrokerErrorCode;
var
  rpcEntryPtr: RPCCallHistoryEntryPointer;
begin
  Result := ClientMgr.GetRPCCallEntryPtrFromHistoryIndex(uniqueClientId,rpcCallIndex,rpcEntryPtr);

  if Result = Success then
  begin
    uniqueRpcId      := rpcEntryPtr^.UniqueRPCCallId;
    brokerContext    := rpcEntryPtr^.CallContext;
    rpcName          := rpcEntryPtr^.CallName;
    rpcParams        := rpcEntryPtr^.CallParams;
    rpcResult        := rpcEntryPtr^.CallResults;
    rpcStartDateTime := rpcEntryPtr^.CallStartDateTime;
    rpcDuration      := rpcEntryPtr^.CallDurationInMS;
  end else
  begin
    uniqueRpcId      := 0;
    brokerContext    := '';
    rpcName          := '';
    rpcParams        := '';
    rpcResult        := '';
    rpcStartDateTime := 0;
    rpcDuration      := 0;
  end;
end;


function TSharedBroker.GetClientIdAndNameFromIndex(clientIndex: Integer;
  out uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin
  Result := ClientMgr.GetClientIdAndNameFromIndex(clientIndex,uniqueClientId,clientName);
  // Failure defaults are taken care of by ClientMgr.
end;

function TSharedBroker.GetRpcClientIdFromHistory(uniqueRpcId: Integer;
  out uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin
  Result := ClientMgr.GetRPCClientIdFromHistory(uniqueRpcId,uniqueClientId,clientName);

  if Result <> Success then
  begin
     uniqueClientId := 0;
     clientName := '';
  end;
end;

function TSharedBroker.GetRpcHistoryCountForClient(uniqueClientId: Integer;
  out rpcHistoryCount: Integer): ISharedBrokerErrorCode;
begin
  Result := ClientMgr.GetRpcHistoryCountForClient(uniqueClientId,rpcHistoryCount);

  if Result <> Success then
    rpcHistoryCount := 0;
end;

procedure TSharedBroker.Set_PerClientRpcHistoryLimit(limit: Integer);
begin
  ClientMgr.PerClientRpcHistoryLimit := limit;
end;

procedure TSharedBroker.Set_RpcHistoryEnabled(enabled: WordBool);
begin
  // If debugger client then operate on all of the clients
  // else just operate on this one
  if ConnectType = DebuggerClient then
    ClientMgr.RpcCallHistoryEnabled := enabled
  else
    RpcHistory.Enabled := enabled;
end;

function TSharedBroker.LogoutConnectedClients(
  logoutTimeLimit: Integer): ISharedBrokerErrorCode;
begin
  ClientMgr.CloseAllClients(logoutTimeLimit);
  ClientMgr.InProcessOfLoggingOutClients := true;
  Result := Success;
end;

function TSharedBroker.GetClientNameFromUniqueClientId(
  uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin
  Result := ClientMgr.GetClientNameFromUniqueClientId(uniqueClientId,clientName);
end;

function TSharedBroker.GetActiveBrokerConnectionIndexCount(
  out connectionIndexCount: Integer): ISharedBrokerErrorCode;
begin
  connectionIndexCount := ClientMgr.AllConnections.Count;
  Result := Success;
end;

function TSharedBroker.GetActiveBrokerConnectionIndexFromUniqueClientId(
  uniqueClientId: Integer;
  out connectionIndex: Integer): ISharedBrokerErrorCode;
begin
  Result := ClientMgr.GetActiveBrokerConnectionIndexFromUniqueClientId(uniqueClientId,connectionIndex);
end;

function TSharedBroker.GetActiveBrokerConnectionInfo(connectionIndex: Integer;
  out connectedServerIp: WideString; out connectedServerPort: Integer;
  out lastContext: WideString): ISharedBrokerErrorCode;
begin
  Result := ConnectionIndexOutOfRange;

  if (connectionIndex >= 0) and (connectionIndex < ClientMgr.AllConnections.Count) then
  begin
    with TBrokerConnection(ClientMgr.AllConnections.Items[connectionIndex]) do
      begin
        connectedServerIp := FServerIP;
        connectedServerPort := FPort;
        lastContext := FLastContext;
        Result := Success;
      end;
  end;
end;

function TSharedBroker.GetConnectionIndex: Integer;
begin
  Result := FBrokerConnection.FConnectionIndex;
end;

constructor TSharedBrokerClientMgr.Create;
begin
  inherited;
  FAllConnections              := TList.Create;
  FAllConnectedClients         := TList.Create;
  FAllClients                  := TList.Create;
  FNoClientsHaveConnectedYet   := True;

  FNextRpcUniqueId             := kNextRpcUniqueIdInitialValue;
  RpcCallHistoryEnabled        := kRpcCallHistoryEnabledDefault;
  PerClientRpcHistoryLimit     := kPerClientRpcHistoryLimitDefault;
  InProcessOfLoggingOutClients := false;
  CloseAllClientsWaitTime      := kCloseAllClientsWaitTimeDefault;

  FKillClientsStartedTime      := 0;
  FKillClientsCountdownStarted := false;
end;

destructor  TSharedBrokerClientMgr.Destroy;
begin
  FAllConnections.Free;
  FAllConnectedClients.Free;
  FAllClients.Free;
  inherited;
end;

procedure TSharedBrokerClientMgr.SendOnLogout;
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;
begin
  for i := Pred(FAllClients.Count) downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      Enum := aBrokerClient.GetEnumerator;
      if Enum <> nil then
      begin

        while Enum.Next(1,ConnectData, @Fetched) = S_OK do
        begin
          if ConnectData.pUnk <> nil then
            try
              (ConnectData.pUnk as ISharedBrokerEvents).OnLogout;
            except
            end;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SendOnRpcCallRecorded(uniqueRpcId: Longword);
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;

begin
  for i := Pred(FAllClients.Count) downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      // only send these events to Debugger type clients
      if aBrokerClient.ConnectType = DebuggerClient then
      begin
        Enum := aBrokerClient.GetEnumerator;
        if Enum <> nil then
        begin
          while Enum.Next(1,ConnectData, @Fetched) = S_OK do
            if ConnectData.pUnk <> nil then
              try
                (ConnectData.pUnk as ISharedBrokerEvents).OnRpcCallRecorded(uniqueRpcId);
              except
              end;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SendOnClientConnect(uniqueClientId: Integer;connection: ISharedBrokerConnection);
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;

begin
  for i := Pred(FAllClients.Count) downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      // only send these events to Debugger type clients
      if aBrokerClient.ConnectType = DebuggerClient then
      begin
        Enum := aBrokerClient.GetEnumerator;
        if Enum <> nil then
        begin
          while Enum.Next(1,ConnectData, @Fetched) = S_OK do
            if ConnectData.pUnk <> nil then
              try
                (ConnectData.pUnk as ISharedBrokerEvents).OnClientConnect(uniqueClientId,connection);
              except
              end;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SendOnClientDisconnect(uniqueClientId: Integer);
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;

begin
  if FAllClients <> nil then
  for i := Pred(FAllClients.Count) downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      // only send these events to Debugger type clients
      if aBrokerClient.ConnectType = DebuggerClient then
      begin
        Enum := aBrokerClient.GetEnumerator;
        if Enum <> nil then
        begin
          while Enum.Next(1,ConnectData, @Fetched) = S_OK do
            if ConnectData.pUnk <> nil then
              try
                (ConnectData.pUnk as ISharedBrokerEvents).OnClientDisconnect(uniqueClientId);
              except
              end;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SendOnContextChanged(connectionIndex: Integer; newContext: WideString);
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;

begin
  if FAllClients <> nil then
  for i := Pred(FAllClients.Count) downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      // only send these events to Debugger type clients
      if aBrokerClient.ConnectType = DebuggerClient then
      begin
        Enum := aBrokerClient.GetEnumerator;
        if Enum <> nil then
        begin
          while Enum.Next(1,ConnectData, @Fetched) = S_OK do
            if ConnectData.pUnk <> nil then
              try
                (ConnectData.pUnk as ISharedBrokerEvents).OnContextChanged(connectionIndex,newContext);
              except
              end;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SendOnConnectionDropped(RPCBroker: TRPCBroker; ErrorText: String);
var
  Enum: IEnumConnections;
  ConnectData: TConnectData;
  Fetched: Cardinal;
  aBrokerClient: TSharedBroker;
  i: Integer;
  IsRightConnection: Boolean;
  ConnectionIndex: Integer;
begin
    ConnectionIndex := 0;
    // first pass -- get BrokerClients and identify ConnectionIndex's
    if FAllClients <> nil then
    for i := Pred(FAllClients.Count) downto 0 do
    begin
      aBrokerClient := TSharedBroker(FAllClients.Items[i]);
      if aBrokerClient <> nil then
      begin
        IsRightConnection := False;
        if ABrokerClient.ConnectType <> DebuggerClient then
        begin
          if ABrokerClient.FBrokerConnection.FBroker = RPCBroker then
          begin
            IsRightConnection := True;
            ConnectionIndex := ABrokerClient.FBrokerConnection.FConnectionIndex;
          end;
          if IsRightConnection then
          begin
            Enum := aBrokerClient.GetEnumerator;
            if Enum <> nil then
            begin
              while Enum.Next(1,ConnectData, @Fetched) = S_OK do
                if ConnectData.pUnk <> nil then
                  try
                    (ConnectData.pUnk as ISharedBrokerEvents).OnConnectionDropped(ConnectionIndex,ErrorText);
                  except
                  end;
            end;
          end;
        end;
      end;
    end;
    // Now get Debuggers
    if FAllClients <> nil then
    for i := Pred(FAllClients.Count) downto 0 do
    begin
      aBrokerClient := TSharedBroker(FAllClients.Items[i]);
      if aBrokerClient <> nil then
      begin
        // only send these events to Debugger type clients
        if aBrokerClient.ConnectType = DebuggerClient then
        begin
          Enum := aBrokerClient.GetEnumerator;
          if Enum <> nil then
          begin
            while Enum.Next(1,ConnectData, @Fetched) = S_OK do
              if ConnectData.pUnk <> nil then
                try
                  (ConnectData.pUnk as ISharedBrokerEvents).OnConnectionDropped(ConnectionIndex,ErrorText);
                except
                end;
          end;
        end;
      end;
    end;
end;


procedure TSharedBrokerClientMgr.CloseAllClients(maxWaitTime: Integer);
begin
  if maxWaitTime > 0 then
    // Since maxWaitTime is in seconds we need to scale by 1000ms/sec
    CloseAllClientsWaitTime := maxWaitTime * kMilliSecondScale
  else
    CloseAllClientsWaitTime := kCloseAllClientsWaitTimeDefault;

  // Be sure to send the OnLogout message to all clients
  ClientMgr.SendOnLogout;
  FKillClientsCountdownStarted := true;
  FKillClientsStartedTime := GetTickCount; // use MS calculations
end;

procedure TSharedBrokerClientMgr.CheckDisconnectWaitTimeAndShutdownClients;
var
  ABrokerClient: TSharedBroker;
  i: Integer;
  timeElapsedMS: Double;
begin
  if FKillClientsCountdownStarted = true then
  begin
    if FAllClients.Count > 0 then
    begin
      timeElapsedMS := GetTickCount - FKillClientsStartedTime;
      if timeElapsedMS > CloseAllClientsWaitTime then
      begin
        // Put up a warning dialog that all RPC connections will now be terminated
        Application.MessageBox('All client connections will now be terminated!','RPCSharedBrokerSessionMgr Warning',MB_ICONWARNING);
        for i := Pred(FAllClients.Count) downto 0 do
        begin
          ABrokerClient := TSharedBroker(FAllClients.Items[i]);
          if ABrokerClient <> nil then ABrokerClient.DoDisconnect;
        end;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.ListAllConnectedClients(AList: TStrings);
var
  aBrokerClient: TSharedBroker;
  i: Integer;
begin
  for i := 0 to Pred(ConnectedClientCount) do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);
    AList.Add(ABrokerClient.FBrokerConnection.FServer+':'+
              ABrokerClient.FBrokerConnection.FServerIP+':'+
              IntToStr(ABrokerClient.FBrokerConnection.FPort)+'> <'+
              ABrokerClient.ClientName+'> '+
              ABrokerClient.FBrokerContext);
  end;
end;

procedure TSharedBrokerClientMgr.AddConnectedBrokerClient(broker: TSharedBroker);
begin
  if broker <> nil then
    FAllConnectedClients.Add(broker);
end;

procedure TSharedBrokerClientMgr.RemoveConnectedBrokerClient(broker: TSharedBroker);
begin
  if broker <> nil then
    FAllConnectedClients.Remove(broker);
end;

procedure TSharedBrokerClientMgr.AddToGeneralClientList(broker: TSharedBroker);
begin
  if broker <> nil then
  begin
    FAllClients.Add(broker);
    NoClientsHaveConnectedYet := false;
  end;
end;

procedure TSharedBrokerClientMgr.RemoveFromGeneralClientList(broker: TSharedBroker);
begin
  if broker <> nil then
    FAllClients.Remove(broker);
end;

function TSharedBrokerClientMgr.ConnectedClientCount : integer;
begin
  Result := FAllConnectedClients.Count;
end;

function TSharedBrokerClientMgr.GetNextRpcUniqueId: Longword;
begin
  FNextRpcUniqueId := FNextRpcUniqueId + 1;  // Let this wrap it should be ok.
  Result := FNextRpcUniqueId;
end;

function TSharedBrokerClientMgr.GetRPCCallEntryPtrFromHistory(uniqueRpcId: Longword;
                                 out rpcEntryPtr: RPCCallHistoryEntryPointer)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  count :=  Pred(ConnectedClientCount);

  Result := UniqueRPCIdDoesNotExist;

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      Result := aBrokerClient.RpcHistory.GetRPCCallEntryPtr(uniqueRpcId,rpcEntryPtr);
      if Result = Success then
        Exit;
    end;
  end;
end;

function TSharedBrokerClientMgr.GetRPCCallEntryPtrFromHistoryIndex(uniqueClientId:Longword;
                                 rpcCallIndex: Integer;
                                 out rpcEntryPtr: RPCCallHistoryEntryPointer)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  count :=  Pred(ConnectedClientCount);

  Result := UniqueClientIdDoesNotExist;

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);

    if aBrokerClient <> nil then
    begin
      if (aBrokerClient.BrokerUniqueClientId = uniqueClientId) then
      begin
        Result := aBrokerClient.RpcHistory.GetRPCCallEntryPtrFromIndex(rpcCallIndex,rpcEntryPtr);
        Exit;
      end;
    end;
  end;
end;

function TSharedBrokerClientMgr.GetRPCClientIdFromHistory(uniqueRpcId: Integer;
                                 out uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  count :=  Pred(ConnectedClientCount);

  Result := UniqueRPCIdDoesNotExist;

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);

    if aBrokerClient <> nil then
    begin
      Result := aBrokerClient.RpcHistory.GetRPCCallClientId(uniqueRpcId,uniqueClientId);
      if Result = Success then
      begin
        clientName := aBrokerClient.ClientName;
        Exit;
      end;
    end;
  end;
end;

function TSharedBrokerClientMgr.GetRPCHistoryCountForClient(uniqueClientId: Integer;
                                 out rpcCount: Integer)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  count :=  Pred(ConnectedClientCount);

  Result := UniqueClientIdDoesNotExist;

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);

    if aBrokerClient <> nil then
    begin
      if Integer(aBrokerClient.BrokerUniqueClientId) = Integer(uniqueClientId) then
      begin
        rpcCount := aBrokerClient.RpcHistory.Count;
        Result := Success;
        Exit;
      end;
    end;
  end;
end;

function TSharedBrokerClientMgr.GetClientIdAndNameFromIndex(clientIndex: Integer;
                                 out uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
begin
  if (clientIndex >= 0) and (clientIndex < FAllConnectedClients.Count) then
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[clientIndex]);
    if aBrokerClient <> nil then
    begin
      uniqueClientId := aBrokerClient.BrokerUniqueClientId;
      clientName := aBrokerClient.ClientName;
      Result := Success;
    end else
      Result := NilClientPointer;
  end else
    Result := ClientIndexOutOfRange;

  if Result <> Success then
  begin
    uniqueClientId := 0;
    clientName := '';
  end;
end;

function TSharedBrokerClientMgr.GetClientNameFromUniqueClientId(uniqueClientId: Integer;
                                 out clientName: WideString)
                                 : ISharedBrokerErrorCode;
var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  count :=  Pred(ConnectedClientCount);

  Result := UniqueClientIdDoesNotExist;

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);

    if aBrokerClient <> nil then
    begin
      if Integer(aBrokerClient.BrokerUniqueClientId) = Integer(uniqueClientId) then
      begin
        clientName := aBrokerClient.ClientName;
        Result := Success;
        Exit;
      end;
    end;
  end;
end;

function TSharedBrokerClientMgr.GetActiveBrokerConnectionIndexFromUniqueClientId(uniqueClientId: Integer;
                                 out connectionIndex: Integer)
                                 : ISharedBrokerErrorCode;

var
  aBrokerClient: TSharedBroker;
  i,count: Integer;
begin
  count :=  Pred(ConnectedClientCount);
  Result := UniqueClientIdDoesNotExist;
  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);

    if aBrokerClient <> nil then
    begin
      if Integer(aBrokerClient.BrokerUniqueClientId) = Integer(uniqueClientId) then
      begin
        connectionIndex := aBrokerClient.BrokerConnectionIndex;
        Result := Success;
        Exit;
      end;
    end;
  end;
end;

procedure TSharedBrokerClientMgr.SetRpcCallHistoryEnabled(enabled: boolean);

var
  aBrokerClient: TSharedBroker;
  i,count: Integer;

begin
  // be sure to set the local state
  FRpcCallHistoryEnabled := enabled;

  count :=  Pred(ConnectedClientCount);

  for i := count downto 0 do
  begin
    aBrokerClient := TSharedBroker(FAllConnectedClients.Items[i]);
    if aBrokerClient <> nil then
    begin
      // Set the RpcCallHistory for all of the broker connections
      aBrokerClient.RpcHistory.Enabled := enabled;
    end;
  end;

end;

function TSharedBrokerClientMgr.GeneralClientCount:Integer;
begin
  if FAllClients <> nil then
    Result:= FAllClients.Count
  else
    Result:= 0;
end;

procedure TSharedBrokerClientMgr.OnIdleEventHandler(Sender: TObject; var Done: Boolean);
begin
  // Shut me down any time the client count goes to zero
  // Since this server is non visual it has to be able to shut
  // down automatically.
  // It is started up automatically any time a client tries
  // to connect
  if (ClientMgr.InProcessOfLoggingOutClients = true) then
    ClientMgr.CheckDisconnectWaitTimeAndShutdownClients;

  if (GeneralClientCount = 0) and (NoClientsHaveConnectedYet = false)then
  begin
   Application.Terminate;
//   SendMessage(Application.MainForm.Handle,WM_CLOSE,0,0);
  end;
end;

// Global Function Implementation
function TSharedBrokerClientMgr.Piece(const S: string; Delim: char; PieceNum: Integer): string;
{ returns the Nth piece (PieceNum) of a string delimited by Delim }
var
  i: Integer;
  Strt, Next: PChar;
begin
  i := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (i < PieceNum) and (Next <> nil) do
  begin
    Inc(i);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then Next := StrEnd(Strt);
  if i < PieceNum then Result := '' else SetString(Result, Strt, Next - Strt);
end;

constructor RPCCallHistoryEntry.Create;
begin
  CallName := kNoneString;
  CallParams := kNoneString;
  CallResults := kNoneString;
  CallStartDateTime := 0;
  CallDurationInMS := 0;
end;


constructor RPCCallHistoryEntry.Create(context:WideString;
                                       name:WideString;
                                       params:WideString;
                                       results:WideString;
                                       startDateTime:Double;
                                       durationInMS:Longword;
                                       clientId:Integer);
begin;
  CallContext := context;
  CallName := name;
  CallParams := params;
  CallResults := results;
  CallStartDateTime := startDateTime;
  CallDurationInMS := durationInMS;

  UniqueRPCCallId := ClientMgr.GetNextRpcUniqueId;

  BrokerUniqueClientId := clientId;
end;

constructor RPCCallHistory.Create;
begin
  inherited;
  FEnabled := kRpcCallHistoryEnabledDefault;
end;

function RPCCallHistory.Add(entry: RPCCallHistoryEntry): Integer;
var
  diff,i,limit: integer;
begin
  // Don't put critical sections around these ClientMgr accesses since
  // this call is most often nested
  Result := -1;
  if (Enabled = True) then
  begin
    limit := ClientMgr.PerClientRpcHistoryLimit;
    if (Count > limit ) then
    begin
      // This could happen since a client may reduce the max number
      // of history entries on the fly and it may be less than what is
      // already recorded.
      diff := ClientMgr.PerClientRpcHistoryLimit - Count;
      for i:=1 to diff do Delete(Count-1);  // Delete the extras
    end else if (Count <= limit) then
    begin
      // If the history is full then delete the first one.
      // The latest is added to the back
      if (Count = limit) and (limit > 0) then Delete(0);

      Result := Add(Pointer(entry));
      Assert(Result <> -1);
    end;
  end;
end;

function RPCCallHistory.GetRPCCallEntryPtr(uniqueRpcId:Longword;
                  out rpcEntryPtr:RPCCallHistoryEntryPointer)
                  : ISharedBrokerErrorCode;
var
  i,entryCount:integer;
  item: RPCCallHistoryEntry;
begin
  Result := UniqueRPCIdDoesNotExist;
  rpcEntryPtr := nil;

  entryCount := Pred(Count);

  for i:=0 to entryCount do
  begin
    item := RPCCallHistoryEntry(self[i]);
    if item <> nil then
    begin
      if item.UniqueRPCCallId = uniqueRpcId then
      begin
        rpcEntryPtr := @item;
        Result := Success;
        // We found one so exit the routine
        Exit;
      end;
    end;
  end;
end;

function RPCCallHistory.GetRPCCallEntryPtrFromIndex(rpcCallIndex:Integer;
                                   out rpcEntryPtr:RPCCallHistoryEntryPointer)
                                   : ISharedBrokerErrorCode;
begin
  rpcEntryPtr := nil;
  Result := RPCHistoryIndexOutOfRange;

  if (rpcCallIndex > 0) and (rpcCallIndex <= Count) then
  begin
    rpcEntryPtr := self[rpcCallIndex];
    Result := Success;
  end;
end;

function RPCCallHistory.GetRPCCallClientId(uniqueRpcId:Integer;
                                   out uniqueClientId:Integer)
                                   : ISharedBrokerErrorCode;
var
  rpcEntryPtr : RPCCallHistoryEntryPointer;
begin
  Result := GetRPCCallEntryPtr(uniqueRpcId,rpcEntryPtr);
  if (Result = Success) and (rpcEntryPtr <> nil)then
    uniqueClientId := rpcEntryPtr^.BrokerUniqueClientId
  else
    uniqueClientId := 0;
end;


{
procedure TSharedBroker.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as ISharedBrokerEvents;
  if FConnectionPoint <> nil then
     FSinkList := FConnectionPoint.SinkList;
end;

procedure TSharedBroker.Initialize;
begin
  inherited Initialize;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;


function TSharedBroker.BrokerConnect(const ClientName: WideString;
  ConnectionType: ISharedBrokerClient; const ServerPort: WideString;
  WantDebug, AllowShared: WordBool; RpcTimeLimit: SYSINT;
  out UniqueClientId: SYSINT): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.BrokerCall(const RpcName, RpcParams: WideString;
  RpcTimeLimit: Integer; out RpcResults: WideString;
  out UniqueRpcCallId: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.BrokerDisconnect: ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.BrokerSetContext(
  const OptionName: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.ReadRegDataDefault(const Root, Key, Name,
  Default: WideString; out RegResult: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.Get_PerClientRpcHistoryLimit: Integer;
begin

end;

function TSharedBroker.Get_RpcHistoryEnabled: WordBool;
begin

end;

function TSharedBroker.Get_RpcVersion: WideString;
begin

end;

procedure TSharedBroker.Set_PerClientRpcHistoryLimit(limit: Integer);
begin

end;

procedure TSharedBroker.Set_RpcHistoryEnabled(enabled: WordBool);
begin

end;

procedure TSharedBroker.Set_RpcVersion(const version: WideString);
begin

end;

function TSharedBroker.GetActiveBrokerConnectionIndexCount(
  out connectionIndexCount: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetActiveBrokerConnectionIndexFromUniqueClientId(
  uniqueClientId: Integer;
  out connectionIndex: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetActiveBrokerConnectionInfo(
  connectionIndex: Integer; out connectedServerIp: WideString;
  out connectedServerPort: Integer;
  out lastContext: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetClientIdAndNameFromIndex(clientIndex: Integer;
  out uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetClientNameFromUniqueClientId(
  uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetRpcHistoryCountForClient(uniqueClientId: Integer;
  out rpcHistoryCount: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.LogoutConnectedClients(
  logoutTimeLimit: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetRpcCallFromHistoryIndex(uniqueClientId,
  rpcCallIndex: Integer; out uniqueRpcId: Integer; out brokerContext,
  rpcName, rpcParams, rpcResult: WideString; out rpcStartDateTime: Double;
  out rpcDuration: Integer): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetRpcClientIdFromHistory(uniqueRpcId: Integer;
  out uniqueClientId: Integer;
  out clientName: WideString): ISharedBrokerErrorCode;
begin

end;

function TSharedBroker.GetConnectedClientCount(
  out connectedClientCount: Integer): ISharedBrokerErrorCode;
begin

end;
}

{
function TSharedBroker.GetRpcCallFromHistory(uniqueRpcId: Integer;
  out uniqueClientId: Integer; out brokerContext, rpcName, rpcParams,
  rpcResult: WideString; out rpcStartDateTime: Double;
  out rpcDuration: Integer): ISharedBrokerErrorCode;
begin
 //
end;
}
function TSharedBroker.Get_CurrentContext: WideString;
begin
  if FBrokerConnection <> nil then
  begin
    Result := FBrokerConnection.FBroker.CurrentContext;
  end else
  begin
    // Don't know what else to make this if we don't actually have a TRPCBroker to ask
    Result := '';
  end;
end;

function TSharedBroker.Get_KernelLogin: WordBool;
begin
  if FBrokerConnection <> nil then
  begin
    Result := FBrokerConnection.FBroker.KernelLogin;
  end else
  begin
    // Don't know what else to make this if we don't actually have a TRPCBroker to ask
    Result := True;
  end;
end;

function TSharedBroker.Get_Login: WideString;

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
  I: Integer;
  Str: String;
  ModeVal: String;
  DivLst: String;
  MultiDiv: String;
  PromptDiv: String;
  StrFS, StrGS: String;
begin
  //TODO
  if FBrokerConnection <> nil then
    with FBrokerConnection.FBroker.Login do
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
      for i := 0 to Pred(DivList.Count) do
        DivLst := DivLst + DivList[i] + SEP_GS;
      MultiDiv := TorF1(MultiDivision);
      PromptDiv := TorF1(PromptDivision);
      Str := LoginHandle + StrFS + NTToken + StrFS + AccessCode + StrFS;
      Str := Str + VerifyCode + StrFS + Division + StrFS + ModeVal + StrFS;
      Str := Str + DivLst + StrFS + MultiDiv + StrFS + DUZ + StrFS;
      Str := Str + PromptDiv + StrFS;
    end;  // with
end;

function TSharedBroker.Get_RpcbError: WideString;
begin
  if FBrokerConnection <> nil then
  begin
    Result := FBrokerConnection.FBroker.RPCBError;
  end else
  begin
    // Don't know what else to make this if we don't actually have a TRPCBroker to ask
    Result := '';
  end;
end;

function TSharedBroker.Get_ShowErrorMsgs: ISharedBrokerShowErrorMsgs;
begin
  Result := isemRaise;
  if FBrokerConnection <> nil then
    if FBrokerConnection.FBroker.ShowErrorMsgs = semQuiet then
      Result := isemQuiet;
end;

function TSharedBroker.Get_Socket: Integer;
begin
  Result := 0;
  if FBrokerConnection <> nil then
    Result := FBrokerConnection.FBroker.Socket;
end;

function TSharedBroker.Get_User: WideString;
const
  SEP_FS = #28;
var
  Str: String;
begin
  Str := '';
  if FBrokerConnection <> nil then
  begin
    with FBrokerConnection.FBroker.User do
    begin
      Str := DUZ + SEP_FS + Name + SEP_FS + StandardName + SEP_FS;
      Str := Str + Division + SEP_FS;
      if VerifyCodeChngd then
        Str := Str + '1' + SEP_FS
      else
        Str := Str + '0' + SEP_FS;
      Str := Str + Title + SEP_FS + ServiceSection + SEP_FS;
      Str := Str + Language + SEP_FS + DTime + SEP_FS;
    end;    // with
  end;
  Result := WideString(Str);
end;

procedure TSharedBroker.Set_KernelLogin(Value: WordBool);
begin
  if FBrokerConnection <> nil then
    FBrokerConnection.FBroker.KernelLogin := Value;
end;

procedure TSharedBroker.Set_Login(const Value: WideString);
const
  SEP_FS = #28;
  SEP_GS = #29;
var
  Str: String;
  StrFS, StrGS: String;
  DivLst: String;
  ModeVal: String;

  function TorF(Value: String): Boolean;
  begin
    Result := False;
    if Value = '1' then
      Result := True;
  end;

begin
  Str := Value;
  if FBrokerConnection <> nil then
    with FBrokerConnection.FBroker.Login do
    begin
      StrFS := SEP_FS;
      StrGS := SEP_GS;
      LoginHandle := Piece(Str,StrFS,1);
      NTToken := Piece(Str,StrFS,2);
      AccessCode := Piece(Str,StrFS,3);
      VerifyCode := Piece(Str,StrFS,4);
      Division := Piece(Str,StrFS,5);
      ModeVal := Piece(Str,StrFS,6);
      DivLst := Piece(Str,StrFS,7);
      MultiDivision := TorF(Piece(Str,StrFS,8));
      DUZ := Piece(Str,StrFS,9);
      PromptDivision := TorF(Piece(Str,StrFS,10));
      if ModeVal = '1' then
        Mode := lmAVCodes
      else if ModeVal = '2' then
        Mode := lmAppHandle
      else if ModeVal = '3' then
        Mode := lmNTToken;
    end;  // with
end;

procedure TSharedBroker.Set_ShowErrorMsgs(
  Value: ISharedBrokerShowErrorMsgs);
begin
  if FBrokerConnection <> nil then
  begin
    if Value = isemRaise then
      FBrokerConnection.FBroker.ShowErrorMsgs := semRaise
    else
      FBrokerConnection.FBroker.ShowErrorMsgs := semQuiet;
  end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TSharedBroker, Class_SharedBroker,
    ciMultiInstance, tmApartment);
  ClientMgr := TSharedBrokerClientMgr.Create();
  Application.OnIdle := ClientMgr.OnIdleEventHandler;

finalization
  ClientMgr.Free;
  ClientMgr := nil;
end.

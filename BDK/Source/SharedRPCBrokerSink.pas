{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Kevin Meldrum, Travis Hilton, Joel Ivey
	Description: Provides Event Sink for 
	             RPCSharedBrokerSessionMgr1.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit SharedRPCBrokerSink;

interface
uses
  ComObj, SharedRPCBroker;

type
  TSharedRPCBrokerSink = class(TInterfacedObject, IUnknown, IDispatch)
  private
    FBroker: TSharedRPCBroker;
  public
    //IUnknown
    //Method resolution clause to allow QueryInterface to be redefined
    function IUnknown.QueryInterface = QueryInterface;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    //IDispatch
    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  public
    property Broker: TSharedRPCBroker read FBroker write FBroker;
  end;

implementation

uses
  Windows, ActiveX, RPCSharedBrokerSessionMgr1_TLB_SRB;

function TSharedRPCBrokerSink.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := E_NOINTERFACE;
  //If events interface requested, return IDispatch
  if IsEqualIID(IID, DIID_ISharedBrokerEvents) then
  begin
    if GetInterface(IDispatch, Obj) then
      Result := S_OK
  end
  else
    //Handle other interface requests normally

    if GetInterface(IID, Obj) then
      Result := S_OK
end;

function TSharedRPCBrokerSink.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL
end;

function TSharedRPCBrokerSink.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result := E_NOTIMPL
end;

function TSharedRPCBrokerSink.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Count := 0;
  Result := S_OK
end;

function TSharedRPCBrokerSink.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
var
  Args: PVariantArgList;
  ASharedBroker: ISharedBroker;
  ConnectionIndex: Integer;
  ErrorText: WideString;
//  UniqueClientID: Integer;
//  BrokerConnectionType: ISharedBrokerConnection;
begin
  Result := S_OK;
  ConnectionIndex := 0;
  // UniqueClientID := -1;

  //This is called to trigger an event interface method, if implemented
  //We need to check which one it is (by DispID) and do something sensible if we
  //support the triggered event

  //Both event methods happen to have the same parameters,
  //so we can extract them just once to save duplication
  Args := TDispParams(Params).rgvarg;
  //Params are in reverse order:
  //Last parameter is at pos. 0
  //First parameter is at pos. cArgs - 1
  If DispID = 1 then
    ASharedBroker := IUnknown(OleVariant(Args^[0])) as ISharedBroker;
  If DispID = 3 then
  begin
    // UniqueClientID := OleVariant(Args^[1]);
    // BrokerConnectionType := OleVariant(Args^[0]);
  end;
  if DispID = 4 then
  begin
    // UniqueClientID := OleVariant(Args^[0]);
  end;
  If DispId = 8 then
  begin
    ConnectionIndex := OleVariant(Args^[1]);
    ErrorText := OleVariant(Args^[0]);
  end;
  //This is called to trigger an event interface method, if implemented
  //We need to check which one it is (by DispID) and do something sensible if we
  //support the triggered event
    case DispID of
      1:  if Assigned(FBroker.OnLogout) then
            FBroker.OnLogout;
{
      3:  if Assigned(FBroker.OnClientConnected) then
            FBroker.OnClientConnected(UniqueClientID);
      4:  if Assigned(FBroker.OnClientDisconnected) then
            FBroker.OnClientDisconnected(UniqueClientID);
}
      8:  if Assigned(FBroker.OnConnectionDropped) then
            FBroker.OnConnectionDropped(ConnectionIndex, ErrorText);
    else
      //Ignore other events
    end
end;

end.

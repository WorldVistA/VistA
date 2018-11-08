unit uEventHooks;

interface

uses SysUtils, Classes, Windows, Dialogs, Forms, ComObj, ActiveX,
     CPRSChart_TLB, ORNet, ORFn, uCore;

type
  TCPRSExtensionData = record
    Data1: string;
    Data2: string;
  end;

procedure RegisterCPRSTypeLibrary;
procedure ProcessPatientChangeEventHook;
function ProcessOrderAcceptEventHook(OrderID: string; DisplayGroup: integer): boolean;
procedure GetCOMObjectText(COMObject: integer; const Param2, Param3: string;
                           var Data1, Data2: string);
function COMObjectOK(COMObject: integer): boolean;
function COMObjectActive: boolean;

implementation

uses
  Trpcb, rEventHooks, VAUtils;

type
  ICPRSBrokerInitializer = interface(ICPRSBroker)
    procedure Initialize;
  end;

  TCPRSBroker = class(TAutoIntfObject, ICPRSBrokerInitializer)
  private
    FContext: string;
    FRPCVersion: string;
    FClearParameters: boolean;
    FClearResults: boolean;
    FResults: string;
    FParam: TParams;
    FEmptyParams: TParams;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function  SetContext(const Context: WideString): WordBool; safecall;
    function  Server: WideString; safecall;
    function  Port: Integer; safecall;
    function  DebugMode: WordBool; safecall;
    function  Get_RPCVersion: WideString; safecall;
    procedure Set_RPCVersion(const Value: WideString); safecall;
    function  Get_ClearParameters: WordBool; safecall;
    procedure Set_ClearParameters(Value: WordBool); safecall;
    function  Get_ClearResults: WordBool; safecall;
    procedure Set_ClearResults(Value: WordBool); safecall;
    procedure CallRPC(const RPCName: WideString); safecall;
    function  Get_Results: WideString; safecall;
    procedure Set_Results(const Value: WideString); safecall;
    function  Get_Param(Index: Integer): WideString; safecall;
    procedure Set_Param(Index: Integer; const Value: WideString); safecall;
    function  Get_ParamType(Index: Integer): BrokerParamType; safecall;
    procedure Set_ParamType(Index: Integer; Value: BrokerParamType); safecall;
    function  Get_ParamList(Index: Integer; const Node: WideString): WideString; safecall;
    procedure Set_ParamList(Index: Integer; const Node: WideString; const Value: WideString); safecall;
    function  ParamCount: Integer; safecall;
    function  ParamListCount(Index: Integer): Integer; safecall;
    property RPCVersion: WideString read Get_RPCVersion write Set_RPCVersion;
    property ClearParameters: WordBool read Get_ClearParameters write Set_ClearParameters;
    property ClearResults: WordBool read Get_ClearResults write Set_ClearResults;
    property Results: WideString read Get_Results write Set_Results;
    property Param[Index: Integer]: WideString read Get_Param write Set_Param;
    property ParamType[Index: Integer]: BrokerParamType read Get_ParamType write Set_ParamType;
    property ParamList[Index: Integer; const Node: WideString]: WideString read Get_ParamList write Set_ParamList;
  end;

  TCPRSState = class(TAutoIntfObject, ICPRSState)
  private
    FHandle: string;
  public
    constructor Create;
    function  Handle: WideString; safecall;
    function  UserDUZ: WideString; safecall;
    function  UserName: WideString; safecall;
    function  PatientDFN: WideString; safecall;
    function  PatientName: WideString; safecall;
    function  PatientDOB: WideString; safecall;
    function  PatientSSN: WideString; safecall;
    function  LocationIEN: Integer; safecall;
    function  LocationName: WideString; safecall;
  end;

  TCPRSEventHookManager = class(TObject)
  private
    FCPRSBroker: ICPRSBrokerInitializer;
    FCPRSState: ICPRSState;
    FErrors: TStringList;
    FLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    function ProcessComObject(const GUIDString: string;
                              const AParam2, AParam3: string;
                               var Data1, Data2: WideString): boolean;
    procedure EnterCriticalSection;
    procedure LeaveCriticalSection;
  end;

  
var
  uCPRSEventHookManager: TCPRSEventHookManager = nil;
  uCOMObjectActive: boolean = False;

procedure EnsureEventHookObjects;
begin
  if not assigned(uCPRSEventHookManager) then
    uCPRSEventHookManager := TCPRSEventHookManager.Create;
end;

{ TCPRSBroker }

constructor TCPRSBroker.Create;
var
  CPRSLib: ITypeLib;

begin
  FParam := TParams.Create(nil);
  FEmptyParams := TParams.Create(nil);
  OleCheck(LoadRegTypeLib(LIBID_CPRSChart, 1, 0, 0, CPRSLib));
  inherited Create(CPRSLib, ICPRSBroker);
  EnsureBroker;
end;

procedure TCPRSBroker.CallRPC(const RPCName: WideString);
var
  err: boolean;
  tmpRPCVersion: string;
  tmpClearParameters: boolean;
  tmpClearResults: boolean;
  tmpResults: string;
  tmpParam: TParams;

begin
  EnsureEventHookObjects;
  uCPRSEventHookManager.EnterCriticalSection;
  try
    err := (FContext = '');
    if(not err) then
      err := not UpdateContext(FContext);
    if (not err) then
      err := IsBaseContext;
    if err then
      raise EOleException.Create('Invalid Broker Context', OLE_E_FIRST, Application.ExeName ,'', 0)
    else
    begin
      if RPCName <> '' then
      begin
        tmpRPCVersion := String(RPCBrokerV.RpcVersion);
        tmpClearParameters := RPCBrokerV.ClearParameters;
        tmpClearResults := RPCBrokerV.ClearResults;
        tmpResults := RPCBrokerV.Results.Text;
        tmpParam := TParams.Create(nil);
        try
          RPCBrokerV.RemoteProcedure := RPCName;
          RPCBrokerV.RpcVersion := FRPCVersion;
          RPCBrokerV.ClearParameters := FClearParameters;
          RPCBrokerV.ClearResults := FClearResults;
          RPCBrokerV.Param.Assign(FParam);
          CallBrokerInContext;
          FParam.Assign(RPCBrokerV.Param);
          FResults := RPCBrokerV.Results.Text;
        finally
          RPCBrokerV.RpcVersion := tmpRPCVersion;
          RPCBrokerV.ClearParameters := tmpClearParameters;
          RPCBrokerV.ClearResults := tmpClearResults;
          RPCBrokerV.Results.Text := tmpResults;
          RPCBrokerV.Param.Assign(tmpParam);
          tmpParam.Free;
        end;
      end
      else
      begin
        RPCBrokerV.Results.Clear;
        FResults := '';
      end;
    end;
  finally
    uCPRSEventHookManager.LeaveCriticalSection;
  end;
end;

function TCPRSBroker.DebugMode: WordBool;
begin
  Result := RPCBrokerV.DebugMode;
end;

function TCPRSBroker.Get_ClearParameters: WordBool;
begin
  Result := FClearParameters;
end;

function TCPRSBroker.Get_ClearResults: WordBool;
begin
  Result := FClearResults;
end;

function TCPRSBroker.Get_Param(Index: Integer): WideString;
begin
  Result := FParam[Index].Value;
end;

function TCPRSBroker.Get_ParamList(Index: Integer;
  const Node: WideString): WideString;
begin
  Result := FParam[Index].Mult[Node];
end;

function TCPRSBroker.Get_ParamType(Index: Integer): BrokerParamType;
begin
  case FParam[Index].PType of
    literal:   Result := bptLiteral;
    reference: Result := bptReference;
    list:      Result := bptList;
    else       Result := bptUndefined;
  end;
end;

function TCPRSBroker.Get_Results: WideString;
begin
  Result := FResults;
end;

function TCPRSBroker.Get_RPCVersion: WideString;
begin
  Result := FRPCVersion;
end;

function TCPRSBroker.ParamCount: Integer;
begin
  Result := FParam.Count;
end;

function TCPRSBroker.ParamListCount(Index: Integer): Integer;
begin
  Result := FParam[Index].Mult.Count;
end;

function TCPRSBroker.Port: Integer;
begin
  Result := RPCBrokerV.ListenerPort;
end;

function TCPRSBroker.Server: WideString;
begin
  Result := WideString(RPCBrokerV.Server);
end;

procedure TCPRSBroker.Set_ClearParameters(Value: WordBool);
begin
  FClearParameters := Value;
end;

procedure TCPRSBroker.Set_ClearResults(Value: WordBool);
begin
  FClearResults := Value;
end;

procedure TCPRSBroker.Set_Param(Index: Integer; const Value: WideString);
begin
  FParam[Index].Value := Value;
end;

procedure TCPRSBroker.Set_ParamList(Index: Integer; const Node,
  Value: WideString);
begin
  FParam[Index].Mult[Node] := Value;
end;

procedure TCPRSBroker.Set_ParamType(Index: Integer;
  Value: BrokerParamType);
begin
  case Value of
    bptLiteral:   FParam[Index].PType := literal;
    bptReference: FParam[Index].PType := reference;
    bptList:      FParam[Index].PType := list;
    else          FParam[Index].PType := undefined;
  end;
end;

procedure TCPRSBroker.Set_Results(const Value: WideString);
begin
  FResults := Value;
end;

procedure TCPRSBroker.Set_RPCVersion(const Value: WideString);
begin
  FRPCVersion := Value;
end;

function TCPRSBroker.SetContext(const Context: WideString): WordBool;
begin
  FContext := Context;
  Result := UpdateContext(FContext);
end;

procedure TCPRSBroker.Initialize;
begin
  FContext := '';
  FRPCVersion := String(RPCBrokerV.RpcVersion);
  FClearParameters := RPCBrokerV.ClearParameters;
  FClearResults := RPCBrokerV.ClearResults;
  FResults := '';
  FParam.Assign(FEmptyParams);
end;

destructor TCPRSBroker.Destroy;
begin
  FParam.Free;
  FEmptyParams.Free;
  inherited;
end;

{ TCPRSState }

constructor TCPRSState.Create;
var
  CPRSLib: ITypeLib;

begin
  OleCheck(LoadRegTypeLib(LIBID_CPRSChart, 1, 0, 0, CPRSLib));
  inherited Create(CPRSLib, ICPRSState);
  FHandle := DottedIPStr + 'x' + IntToHex(Application.Handle,8);
end;

function TCPRSState.Handle: WideString;
begin
  Result := FHandle;
end;

function TCPRSState.LocationIEN: Integer;
begin
  Result := Encounter.Location;
end;

function TCPRSState.LocationName: WideString;
begin
  Result := Encounter.LocationName;
end;

function TCPRSState.PatientDFN: WideString;
begin
  Result := Patient.DFN;
end;

function TCPRSState.PatientDOB: WideString;
begin
  Result := FormatFMDateTime('ddddd', Patient.DOB);
end;

function TCPRSState.PatientName: WideString;
begin
  Result := Patient.Name;
end;

function TCPRSState.PatientSSN: WideString;
begin
  Result := Patient.SSN;
end;

function TCPRSState.UserDUZ: WideString;
begin
  Result := IntToStr(User.DUZ);
end;

function TCPRSState.UserName: WideString;
begin
  Result := User.Name;
end;

{ TCPRSEventHookManager }

constructor TCPRSEventHookManager.Create;
begin
  inherited;
  FCPRSBroker := TCPRSBroker.Create;
  FCPRSState := TCPRSState.Create;
end;

destructor TCPRSEventHookManager.Destroy;
begin
  FCPRSState := nil;
  FCPRSBroker := nil;
  if assigned(FErrors) then
    FErrors.Free;
  inherited;
end;

procedure TCPRSEventHookManager.EnterCriticalSection;
begin
  Windows.EnterCriticalSection(FLock);
end;

procedure TCPRSEventHookManager.LeaveCriticalSection;
begin
  Windows.LeaveCriticalSection(FLock);
end;

function TCPRSEventHookManager.ProcessComObject(const GUIDString: string;
                               const AParam2, AParam3: string;
                               var Data1, Data2: WideString): boolean;
var
  ObjIEN, ObjName, ObjGUIDStr, err, AParam1: string;
  ObjGUID: TGUID;
  ObjIntf: IUnknown;
  Obj: ICPRSExtension;

begin
  Result := FALSE;
  ObjIEN := Piece(GUIDString,U,1);
  if assigned(FErrors) and (FErrors.IndexOf(ObjIEN) >= 0) then exit;
  ObjName := Piece(GUIDString,U,2);
  ObjGUIDStr := Piece(GUIDString,U,3);
  if (ObjGUIDStr <> '') then
  begin
    try
      ObjGUID := StringToGUID(ObjGUIDStr);
      try
        ObjIntf := CreateComObject(ObjGUID);
        if assigned(ObjIntf) then
        begin
          try
            ObjIntf.QueryInterface(IID_ICPRSExtension, Obj);
            if assigned(Obj) then
            begin
              AParam1 := Piece(GUIDString,U,5);
              InitializeCriticalSection(FLock);
              try
                FCPRSBroker.Initialize;
                uCOMObjectActive := True;
                Result := Obj.Execute(FCPRSBroker, FCPRSState,
                                      AParam1, AParam2, AParam3, Data1, Data2);
              finally
                DeleteCriticalSection(FLock);
                uCOMObjectActive := False;
              end;
            end
            else
              err := 'COM Object ' + ObjName + ' does not support ICPRSExtension';
          except
            err := 'Error executing ' + ObjName;
          end;
        end;
      except
        err := 'COM Object ' + ObjName + ' not found on this workstation.';
      end;
    except
      err := 'COM Object ' + ObjName + ' has an invalid GUID' + CRLF + ObjGUIDStr;
    end;
    if err <> '' then
    begin
      if not assigned(FErrors) then
        FErrors := TStringList.Create;
      if FErrors.IndexOf(ObjIEN) < 0 then
        FErrors.Add(ObjIEN);
      ShowMsg(err);
    end;
  end;
end;

procedure FreeEventHookObjects;
begin
  FreeAndNil(uCPRSEventHookManager);
end;

// External Calls

procedure RegisterCPRSTypeLibrary;
type
  TUnregisterProc = function(const GUID: TGUID; VerMajor, VerMinor: Word;
    LCID: TLCID; SysKind: TSysKind): HResult stdcall;

var
  Unregister: boolean;
  CPRSLib: ITypeLib;
  DoHalt: boolean;
  ModuleName: string;
  HelpPath: WideString;
  Buffer: array[0..261] of Char;
  Handle: THandle;
  UnregisterProc: TUnregisterProc;
  LibAttr: PTLibAttr;

begin
  DoHalt := TRUE;
  if FindCmdLineSwitch('UNREGSERVER', ['-', '/'], True) then
    Unregister := TRUE
  else
  begin
    Unregister := FALSE;
    if not FindCmdLineSwitch('REGSERVER', ['-', '/'], True) then
      DoHalt := FALSE;
  end;

  try
    SetString(ModuleName, Buffer, Windows.GetModuleFileName(HInstance, Buffer, SizeOf(Buffer)));
    if ModuleName <> '' then
    begin
      OleCheck(LoadTypeLib(PWideChar(WideString(ModuleName)), CPRSLib)); // will register if needed
      if assigned(CPRSLib) then
      begin
        if Unregister then
        begin
          Handle := GetModuleHandle('OLEAUT32.DLL');
          if Handle <> 0 then
          begin
            @UnregisterProc := GetProcAddress(Handle, 'UnRegisterTypeLib');
            if @UnregisterProc <> nil then
            begin
              OleCheck(CPRSLib.GetLibAttr(LibAttr));
              try
                with LibAttr^ do
                  UnregisterProc(guid, wMajorVerNum, wMinorVerNum, lcid, syskind);
              finally
                CPRSLib.ReleaseTLibAttr(LibAttr);
              end;
            end;
          end;
        end
        else
        begin
          HelpPath := ExtractFilePath(ModuleName);
          OleCheck(RegisterTypeLib(CPRSLib, PWideChar(WideString(ModuleName)), PWideChar(HelpPath)));
        end;
      end;
    end;
  except
// ignore any errors   
  end;
  if DoHalt then Halt;
end;

procedure ProcessPatientChangeEventHook;
var
  d1, d2: WideString;
  COMObj: string;

begin
  COMObj := GetPatientChangeGUIDs;
  if(COMObj <> '') and (COMObj <> '0') then
  begin
    EnsureEventHookObjects;
    d1 := '';
    d2 := '';
    uCPRSEventHookManager.ProcessComObject(COMObj, 'P=' + Patient.DFN, '', d1, d2);
  end;
end;

function ProcessOrderAcceptEventHook(OrderID: string; DisplayGroup: integer): boolean;
var
  d1, d2: WideString;
  COMObj: string;

begin
  Result := False;
  COMObj := GetOrderAcceptGUIDs(DisplayGroup);
  if(COMObj <> '') and (COMObj <> '0') then
  begin
    EnsureEventHookObjects;
    d1 := '';
    d2 := '';
    //Result will be set to True by Com object if the order is deleted by LES
    Result := uCPRSEventHookManager.ProcessComObject(COMObj, 'O=' + OrderID, '', d1, d2);
  end;
end;

procedure GetCOMObjectText(COMObject: integer; const Param2, Param3: string;
                           var Data1, Data2: string);
var
  d1, d2: WideString;
  COMObj: string;

begin
  if COMObject > 0 then
  begin
    COMObj := GetCOMObjectDetails(COMObject);
    if(COMObj <> '') and (COMObj <> '0') then
    begin
      EnsureEventHookObjects;
      d1 := Data1;
      d2 := Data2;
      if uCPRSEventHookManager.ProcessComObject(COMObj, Param2, Param3, d1, d2) then
      begin
        Data1 := d1;
        Data2 := d2;
      end;
    end;
  end;
end;

function COMObjectOK(COMObject: integer): boolean;
begin
  if assigned(uCPRSEventHookManager) and assigned(uCPRSEventHookManager.FErrors) then
    Result := (uCPRSEventHookManager.FErrors.IndexOf(IntToStr(COMObject)) < 0)
  else
    Result := TRUE;
end;

function COMObjectActive: boolean;
begin
  Result := uCOMObjectActive;
end;

initialization

finalization
  FreeEventHookObjects;

end.

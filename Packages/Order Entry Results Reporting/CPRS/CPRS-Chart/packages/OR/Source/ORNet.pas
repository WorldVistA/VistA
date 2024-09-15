unit ORNet;

interface

uses
  SysUtils,
  Windows,
  Classes,
  Forms,
  Controls,
  ORFn,
  TRPCB,
  RPCConf1;

procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: boolean);
function AuthorizedOption(const OptionName: string): boolean;
function ConnectToServer(const OptionName: string): boolean;
function MRef(glvn: string): string;
procedure CallV(const RPCName: string; const aParam: array of const); deprecated 'use CallVistA';
function sCallV(const RPCName: string; const aParam: array of const): string; deprecated 'use CallVistA';
procedure tCallV(ReturnData: TStrings; const RPCName: string; const aParam: array of const); deprecated 'use CallVistA';
function UpdateContext(NewContext: string): boolean;
function IsBaseContext: boolean;
function CallBrokerInContext(aReturn: TStrings = nil; RequireResults: boolean = False): Boolean;
function CallBroker(aReturn: TStrings = nil; RequireResults: boolean = False): Boolean;
function RetainedRPCCount: Integer;
procedure SetRetainedRPCMax(Value: Integer);
function GetRPCMax: Integer;
procedure LoadRPCData(Dest: TStrings; ID: Integer);
function RetrieveRPCName(ID: Integer): string;
function DottedIPStr: string;
procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: string);
function ShowRPCList: boolean;
procedure EnsureBroker;
procedure LockBroker;
procedure UnlockBroker;
procedure LockRPCCallList;
procedure UnlockRPCCallList;

// =========== Backward Compatiable Code ===========//
procedure SetRPCFlaged(Value: string);
function GetRPCFlaged: string;
// ================================================//

function CallVistA(const aRPCName: string; const aParam: array of const;
  RequireResults: boolean = False): boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Integer; RequireResults: boolean = False; aDefault: Integer = 0)
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Integer; aDefault: Integer; RequireResults: boolean = False)
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Double; RequireResults: boolean = False; aDefault: Double = 0.0)
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Double; aDefault: Double; RequireResults: boolean = False)
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: string; RequireResults: boolean = False; aDefault: string = '')
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: string; aDefault: string; RequireResults: boolean = False)
  : boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const;
  aReturn: TStrings; RequireResults: boolean = False): boolean; overload;

function GetFMNow: TFMDateTime;
function GetFMDT(const aString: string; const aParams: string = ''): TFMDateTime;

var
  RPCBrokerV: TRPCBroker;
  RPCLastCall: string;
  AppStartedCursorForm: TForm = nil;

type
  TAfterRPCEvent = procedure() of object;

  tPulseObject = class
  private
    FInPulseErrorCount: integer;
    FInPulseError: boolean;
    procedure PulseError(RPCBroker: TRPCBroker; ErrorText: String);
  end;

var
  PulseObject: tPulseObject;

procedure SetAfterRPCEvent(Value: TAfterRPCEvent);

implementation

uses
  System.Generics.Collections,
  System.SyncObjs,
  ORNetIntf,
  Winsock,
  DateUtils,
  uLockBroker,
  ORUnitTesting,
  UResponsiveGUI;

const
  // *** these are constants from RPCBErr.pas, will broker document them????
  XWB_M_REJECT = 20000 + 2; // M error
  XWB_BadSignOn = 20000 + 4; // SignOn 'Error' (happens when cancel pressed)
  RPCBROKER_MUTEX_NAME = 'RPCBroker Mutex';
  PARAM_RETRY_TEST = 'RPCRETRYTEST';
  PARAM_RETRY_FAIL = 'RPCRETRYFAIL';
  PARAM_SHOW_CERTS = 'SHOWCERTS';
  MAX_RPC_TRIES = 3;

type
  TCallList = class(TObject)
  private
    FList: TObjectList<TStringList>;
    FLock: TCriticalSection;
    function GetItems(Index: integer): TStringList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Item: TStringList);
    procedure Delete(Index: Integer);
    procedure Lock;
    procedure Unlock;
    property Count: Integer read GetCount;
    property Items[Index: integer]: TStringList read GetItems; default;
  end;

var
  uCallList: TCallList;
  uMaxCalls: Integer;
  uShowRPCs: boolean;
  uBaseContext: string = '';
  AfterRPCEvent: TAfterRPCEvent;
  RPCTestRetry: boolean = False;
  RPCTestFail: boolean = False;

  // =========== Backward Compatiable Code ===========//
  fRPCFlaged: string;
  // ================================================//

  { private procedures and functions ---------------------------------------------------------- }

procedure LockBroker;  // OK to nest calls as long as always paired with UnlockBroker calls
begin
  uLockBroker.LockBroker;
end;

procedure UnlockBroker;
begin
  uLockBroker.UnlockBroker;
end;

procedure LockRPCCallList;
begin
  uCallList.Lock;
end;

procedure UnlockRPCCallList;
begin
  uCallList.Unlock;
end;

type
  TRPCBrokerNotifier = class(TComponent)
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

procedure TRPCBrokerNotifier.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = RPCBrokerV) and (Operation = opRemove) then
    RPCBrokerV := nil;
end;

procedure EnsureBroker;
{ ensures that a broker object has been created - creates & initializes it if necessary }
begin
  if RPCBrokerV = nil then
    begin
      RPCBrokerV := TRPCBroker.Create(Application);
      with RPCBrokerV do
        begin
          FreeNotification(TRPCBrokerNotifier.Create(RPCBrokerV));
          KernelLogIn := True;
          Login.Mode := lmAppHandle;
          ClearParameters := True;
          ClearResults := True;
          DebugMode := False;
          AfterRPCEvent := nil;
          OnPulseError := PulseObject.PulseError;
        end;
    end;
end;

procedure SetList(AStringList: TStrings; ParamIndex: Integer);
{ places TStrings into RPCBrokerV.Mult[n], where n is a 1-based (not 0-based) index }
var
  i: Integer;
  aStr: string;
begin
  with RPCBrokerV.Param[ParamIndex] do
  begin
    PType := list;
    i := 1;
    if Assigned(AStringList) then for aStr in AStringList do
    begin
      Mult[IntToStr(i)] := NullStrippedString(aStr);
      inc(i);
    end;
  end;
end;

procedure SetParams(const RPCName: string; const aParam: array of const);
{ takes the params (array of const) passed to xCallV and sets them into RPCBrokerV.Param[i] }
const
  BoolChar: array [boolean] of char = ('0', '1');
var
  i: Integer;
  TmpExt: Extended;
  aORNetParam: IORNetParam;
begin
  RPCLastCall := RPCName + ' (SetParam begin)';
  if Length(RPCName) = 0 then raise Exception.Create('No RPC Name');
  EnsureBroker;
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPCName;
    for i := 0 to high(aParam) do
      with aParam[i] do
      begin
        Param[i].PType := literal;
        case VType of
          vtInteger: Param[i].Value := IntToStr(VInteger);
          vtBoolean: Param[i].Value := BoolChar[VBoolean];
          vtChar: if VChar = #0 then
              Param[i].Value := ''
            else
              Param[i].Value := string(VChar);
          vtExtended:
            begin
              TmpExt := VExtended^;
              if (abs(TmpExt) < 0.0000000000001) then TmpExt := 0;
              Param[i].Value := FloatToStr(TmpExt);
            end;
          vtString: with Param[i] do
            begin
              Value := NullStrippedString(string(VString^));
              if (Length(Value) > 0) and (Value[1] = #1) then
              begin
                Value := Copy(Value, 2, Length(Value));
                PType := reference;
              end;
            end;
          vtPointer: if VPointer = nil then
            begin
              if i=0 then
                ClearParameters := True
              else
                Param[i].PType := empty;
            end
            else
              raise Exception.Create('Pointer type must be nil.');
          vtPChar: Param[i].Value := NullStrippedString(string(AnsiChar(VPChar)));

          vtInterface:
            if IInterface(VInterface).QueryInterface(IORNetParam, aORNetParam) = 0 then
              aORNetParam.AssignToParamRecord(Param[i]);

          vtObject:
            begin
              if VObject is TStrings or (not Assigned(VObject)) then
                SetList(TStrings(VObject), i)
              else if VObject.GetInterface(IORNetParam, aORNetParam) then
                aORNetParam.AssignToParamRecord(Param[i]);
            end;

          vtWideChar: if VChar = #0 then
              Param[i].Value := ''
            else
              Param[i].Value := string(VWideChar);
          vtAnsiString: with Param[i] do
            begin
              Value := NullStrippedString(string(VAnsiString));
              if (Length(Value) > 0) and (Value[1] = #1) then
              begin
                Value := Copy(Value, 2, Length(Value));
                PType := reference;
              end;
            end;
          vtInt64: Param[i].Value := IntToStr(VInt64^);
          vtUnicodeString: with Param[i] do
            begin
              Value := NullStrippedString(string(VUnicodeString));
              if (Length(Value) > 0) and (Value[1] = #1) then
              begin
                Value := Copy(Value, 2, Length(Value));
                PType := reference;
              end;
            end;
        else
          raise Exception.Create('RPC: ' + string(RemoteProcedure) + ' Unable to pass parameter type ' + IntToStr(VType) + ' to Broker.');
        end; { case }
      end; { for }
  end; { with }
  RPCLastCall := RPCName + ' (SetParam end)';
end;

function AbortRPCCall: boolean;
begin
  Result := Application.Terminated or ((not UnitTestingActive) and
     ((not assigned(RPCBrokerV)) or (not RPCBrokerV.Connected)));
end;

{ public procedures and functions ----------------------------------------------------------- }

function CallVistA(const aRPCName: string; const aParam: array of const;
  RequireResults: boolean = False): boolean; overload;
{ Call Broker, no results. i.e. POST }
var
  aLst: TStringList;

begin
  aLst := TStringList.Create;
  try
    Result := CallVistA(aRPCName, aParam, aLst, RequireResults);
  finally
    FreeAndNil(aLst);
  end;
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Integer; RequireResults: boolean = False; aDefault: Integer = 0)
  : boolean; overload;
{ Call Broker, Result[0] in aReturn as integer }
var
  aStr: string;

begin
  if CallVistA(aRPCName, aParam, aStr, RequireResults) then
  begin
    aReturn := StrToIntDef(aStr, aDefault);
    Result := True;
  end
  else
    Result := False;
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Integer; aDefault: Integer; RequireResults: boolean = False)
  : boolean; overload;
begin
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Double; RequireResults: boolean = False; aDefault: Double = 0.0)
  : boolean; overload;
{ Call Broker, Result[0] in aReturn as Double }
var
  aStr: string;

begin
  if CallVistA(aRPCName, aParam, aStr, RequireResults) then
  begin
    aReturn := StrToFloatDef(aStr, aDefault);
    Result := True;
  end
  else
    Result := False;
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: Double; aDefault: Double; RequireResults: boolean = False)
  : boolean; overload;
begin
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: string; RequireResults: boolean = False; aDefault: string = '')
  : boolean; overload;
{ Call Broker, Result[0] in aReturn as string }
var
  aLst: TStringList;

begin
  aLst := TStringList.Create;
  try
    Result := CallVistA(aRPCName, aParam, aLst, RequireResults);
    if aLst.Count > 0 then
      aReturn := aLst[0]
    else
      aReturn := '';
    if aReturn = '' then
      aReturn := aDefault;
  finally
    FreeAndNil(aLst);
  end;
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  var aReturn: string; aDefault: string; RequireResults: boolean = False)
  : boolean; overload;
begin
  Result := CallVistA(aRPCName, aParam, aReturn, RequireResults, aDefault);
end;

function CallVistA(const aRPCName: string; const aParam: array of const;
  aReturn: TStrings; RequireResults: boolean = False): boolean; overload;
{ Call Broker, full results in aReturn }
begin
  if AbortRPCCall then
  begin
    if Assigned(aReturn) then aReturn.Clear;
    Result := False;
    Exit;
  end;
  LockBroker;
  try
    SetParams(aRPCName, aParam);
    if Assigned(aReturn) then aReturn.Clear;
    Result := CallBroker(aReturn, RequireResults);
  finally
    try
      RPCBrokerV.Results.Clear;
      RPCBrokerV.Param.Clear;
    finally
      UnlockBroker;
    end;
  end;
end;

function UpdateContext(NewContext: string): boolean;
const
  Max_Tries = 5;

var
  tmpRPCVersion: string;
  tmpRPCName: string;
  tmpClearParameters: boolean;
  tmpClearResults: boolean;
  tmpParam: TParams;
  tries: integer;

begin
  if NewContext = RPCBrokerV.CurrentContext then
    Result := True
  else
  begin
    { RPCBrokerV.CreateContext ends up calling Application.ProcessMessages,
      which will fire off any waiting WM_TIMER events.  If any of these
      timers fire off an RPC call it will wipe out the existing parameters
      and even the RPC Name, and may even reset the context, calling this
      code recursively.  To fix this potential timing problem we save off the
      state of the broker before the context change and restore it afterwards.}
    tmpRPCVersion := RPCBrokerV.RpcVersion;
    tmpRPCName := RPCBrokerV.RemoteProcedure;
    tmpClearParameters := RPCBrokerV.ClearParameters;
    tmpClearResults := RPCBrokerV.ClearResults;
    tmpParam := TParams.Create(nil);
    tmpParam.Assign(RPCBrokerV.Param);
    try
      tries := 0;
      repeat
        Result := RPCBrokerV.CreateContext(NewContext);
        if RPCBrokerV.CurrentContext = NewContext then
          tries := Max_Tries
        else
          inc(tries);
      until tries >= Max_Tries;
    finally
      RPCBrokerV.RpcVersion := tmpRPCVersion;
      RPCBrokerV.RemoteProcedure := tmpRPCName;
      RPCBrokerV.ClearParameters := tmpClearParameters;
      RPCBrokerV.ClearResults := tmpClearResults;
      RPCBrokerV.Param.Assign(tmpParam);
      tmpParam.Free;
    end;
  end;
end;

function IsBaseContext: boolean;
begin
  Result := ((RPCBrokerV.CurrentContext = uBaseContext) or (RPCBrokerV.CurrentContext = ''));
end;

function CallBrokerInContext(aReturn: TStrings = nil; RequireResults: boolean = False): Boolean;
var
  AStringList: TStringList;
  i, j, attempt, RunLine: Integer;
  x, y, RunString: string;
  RPCStart, RPCStop, fFrequency: TLargeInteger;
  dt: TDateTime;
  mRPC: TMockRPC;
  msg: string;
  ReturnList: TStrings;
  Retry, ClrParams: boolean;

begin
  Result := True;
  LockBroker;
  try
    if Assigned(aReturn) then
      ReturnList := aReturn
    else
      ReturnList := RPCBrokerV.Results;
    ReturnList.Clear;
    if UnitTestingActive then
    begin
      mRPC := FindMockRPC(RPCBrokerV.RemoteProcedure, RPCBrokerV.Param);
      if not assigned(mRPC) then
      begin
        Msg := 'No Mock "' + RPCBrokerV.RemoteProcedure +
          '" RPC with parameters:' + ParamToStr(RPCBrokerV.Param, True);
        raise EUnitTestException.Create(Msg);
      end;
      ReturnList.Assign(mRPC.Results);
      mRPC.CallCount := mRPC.CallCount + 1;
      exit;
    end;

    attempt := 1;
    if RequireResults then
    begin
      ClrParams := RPCBrokerV.ClearParameters;
      if ClrParams then
        RPCBrokerV.ClearParameters := False;
    end
    else
      ClrParams := False;
    try
      repeat
        RunLine := 1;
        RPCLastCall := string(RPCBrokerV.RemoteProcedure) + ' (CallBroker begin)';
        if uShowRPCs then StatusText(string(RPCBrokerV.RemoteProcedure));
        with RPCBrokerV do
          if not Connected then // happens if broker connection is lost
            begin
              ClearResults := True;
              Exit;
            end;
        uCallList.Lock;
        try
          while uCallList.Count >= uMaxCalls do
            uCallList.Delete(0);
        finally
          uCallList.Unlock;
        end;
        AStringList := TStringList.Create;
        try
          AStringList.Add(string(RPCBrokerV.RemoteProcedure));
          if RequireResults and (attempt > 1) then
          begin
            x := '  (Return Data Required, attempt #' + IntToStr(attempt);
            if RPCTestRetry or RPCTestFail then
            begin
              x := x + ' *** Testing RPC Retry';
              if RPCTestFail then
                x := x + ' Until Fail';
              x := x + ' ***';
            end;
            x := x + ')';
            AStringList.Add(x);
            inc(RunLine);
          end;
          AStringList.Add(''); // add to the second line
          if RPCBrokerV.CurrentContext <> uBaseContext then
            AStringList.Add('Context: ' + RPCBrokerV.CurrentContext);
          AStringList.Add(' ');
          AStringList.Add('Params ------------------------------------------------------------------');
          with RPCBrokerV do
            for i := 0 to Param.Count - 1 do
              begin
                case Param[i].PType of
                  list:      x := 'list';
                  literal:   x := 'literal';
                  reference: x := 'reference';
                  undefined: x := 'undefined';
                  global:    x := 'global';
                  empty:     x := 'empty';
                  stream:    x := 'stream';
                  else       x := 'unknown';
                end;
                AStringList.Add(x + #9 + Param[i].Value);
                if Param[i].PType = list then
                  begin
                    for j := 0 to Param[i].Mult.Count - 1 do
                      begin
                        x := Param[i].Mult.Subscript(j);
                        y := Param[i].Mult[x];
                        AStringList.Add(#9 + '(' + x + ')=' + y);
                      end;
                  end;
              end; { with...for }
          // RPCBrokerV.Call;

          try
            QueryPerformanceCounter(RPCStart);
            if aReturn <> nil then
              RPCBrokerV.lstCall(aReturn)
            else
              RPCBrokerV.Call;
            QueryPerformanceCounter(RPCStop);
          except
            on E: EBrokerError do
              begin
                //Add to log
                AStringList[RunLine] := 'Ran at:' + FormatDateTime('hh:nn:ss.z a/p', now);
                AStringList.Add(' ');
                AStringList.Add('BROKER ERROR ------------------------------------------------------------');
                AStringList.Add(e.Message);

                if not RPCBrokerV.Connected then
                  begin
                    Application.MessageBox('Application must shutdown due to lost VistA Connection.', 'Server Error', MB_OK);
                    Application.Terminate; // This just posts WM_QUIT
                    TResponsiveGUI.ProcessMessages(True); // This will see the WM_QUIT and set Application.Terminated to TRUE;
                    Exit;
                  end
                else
                  raise; // Still have connectivity, let the app try and sort it out :-)
              end;
            else
              raise;
          end;

          RunString := 'Ran at:' + FormatDateTime('hh:nn:ss.z a/p', now);
          QueryPerformanceFrequency(fFrequency);
          dt := ((MSecsPerSec * (RPCStop - RPCStart)) div fFrequency) / MSecsPerSec / SecsPerDay;
          RunString := RunString + #13#10 + 'Run time:' + FormatDateTime('hh:nn:ss.z', dt);
          AStringList[RunLine] := RunString;
          AStringList.Add(' ');
          AStringList.Add('Results -----------------------------------------------------------------');
          FastAddStrings(ReturnList, AStringList)
        finally
          uCallList.Add(AStringList);
          if Assigned(AfterRPCEvent) then
            AfterRPCEvent();
        end;
        if uShowRPCs then StatusText('');
        RPCLastCall := string(RPCBrokerV.RemoteProcedure) + ' (completed)';

        if RequireResults then
        begin
          if RPCTestRetry or RPCTestFail then
            Retry := True
          else
            Retry := (ReturnList.Count = 0);
          if Retry then
          begin
            inc(attempt);
            if RPCTestRetry and (attempt > 2) and (ReturnList.Count > 0) then
              Retry := False
            else
            begin
              ReturnList.Clear;
              if (attempt > MAX_RPC_TRIES) then
              begin
                Retry := False;
                Result := False;
              end;
            end;
          end;
        end
        else
          Retry := False;
      until (not Retry);
    finally
      if ClrParams then
        RPCBrokerV.ClearParameters := True;
    end;
  finally
    UnlockBroker;
  end;
end;

function CallBroker(aReturn: TStrings = nil; RequireResults: boolean = False): Boolean;
begin
  LockBroker;
  try
    UpdateContext(uBaseContext);
    Result := CallBrokerInContext(aReturn, RequireResults);
  finally
    UnlockBroker;
  end;
end;

procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: boolean);
{ makes the initial connection to a server }
begin
  EnsureBroker;
  with RPCBrokerV do
    begin
      Server := AName;
      if APort > 0 then ListenerPort := APort;
      DebugMode := WantDebug;
      Connected := True;
    end;
end;

function AuthorizedOption(const OptionName: string): boolean;
{ checks to see if the user is authorized to use this application }
begin
  EnsureBroker;
  Result := RPCBrokerV.CreateContext(OptionName);
  if Result then
  begin
    if (uBaseContext = '') then
      uBaseContext := OptionName;
  end;
end;

function ConnectToServer(const OptionName: string): boolean;
{ establish initial connection to server using optional command line parameters and check that
  this application (option) is allowed for this user }
var
  WantDebug, ShowCerts: boolean;
  AServer, APort, x, pStr: string;
  i, ModalResult: Integer;

begin
  Result := False;
  RPCTestRetry := False;
  RPCTestFail := False;
  WantDebug := False;
  ShowCerts := False;
  AServer := '';
  APort := '';
  for i := 1 to ParamCount do // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
    begin
      pStr := UpperCase(ParamStr(i));
      if pStr = PARAM_RETRY_TEST then RPCTestRetry := True;
      if pStr = PARAM_RETRY_FAIL then RPCTestFail := True;
      if pStr = 'DEBUG' then WantDebug := True;
      if pStr = 'SHOWRPCS' then uShowRPCs := True;
      if pStr = PARAM_SHOW_CERTS then ShowCerts := true;
      x := Piece(pStr, '=', 1);
      if (x = 'S') or (x = 'SERVER') then AServer := Piece(ParamStr(i), '=', 2);
      if (x = 'P') or (x = 'PORT') then APort := Piece(ParamStr(i), '=', 2);
    end;
  if (AServer = '') or (APort = '') then
    begin
      ModalResult := GetServerInfo(AServer, APort);
      if ModalResult = mrCancel then Exit;
    end;
  // use try..except to work around errors in the Broker SignOn screen
  try
    EnsureBroker;
    RPCBrokerV.ShowCertDialog := ShowCerts;
    SetBrokerServer(AServer, StrToIntDef(APort, 9200), WantDebug);
    Result := AuthorizedOption(OptionName);
    if Result then Result := RPCBrokerV.Connected;
    RPCBrokerV.RPCTimeLimit := 300;
  except
    on E: EBrokerError do
      begin
        Result := False;
        if Pos('does not hold the key', E.Message) > 0 then
          begin
            Raise;
          end else
        if E.Code <> XWB_BadSignOn then InfoBox(E.Message, 'Error', MB_OK or MB_ICONERROR);
      end;
  end;
end;

function MRef(glvn: string): string;
{ prepends ASCII 1 to string, allows SetParams to interpret as an M reference }
begin
  Result := #1 + glvn;
end;

function GetRPCCursor: TCursor;
var
  pt: TPoint;
begin
  Result := crHourGlass;
  if Assigned(AppStartedCursorForm) and (AppStartedCursorForm.Visible) then
    begin
      pt := Mouse.CursorPos;
      if PtInRect(AppStartedCursorForm.BoundsRect, pt) then
        Result := crAppStart;
    end;
end;

procedure CallV(const RPCName: string; const aParam: array of const);
{ calls the broker leaving results in results property which must be read by caller }
var
  SavedCursor: TCursor;
begin
  if AbortRPCCall then
    exit;
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  LockBroker;
  try
    SetParams(RPCName, aParam);
    CallBroker; // RPCBrokerV.Call;
  finally
    UnlockBroker;
  end;
  Screen.Cursor := SavedCursor;
end;

function sCallV(const RPCName: string; const aParam: array of const): string;
{ calls the broker and returns a scalar value. }
var
  SavedCursor: TCursor;
begin
  Result := '';
  if AbortRPCCall then
    exit;
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  LockBroker;
  try
    SetParams(RPCName, aParam);
    CallBroker; // RPCBrokerV.Call;
    if RPCBrokerV.Results.Count > 0 then Result := RPCBrokerV.Results[0];
  finally
    UnlockBroker;
  end;
  Screen.Cursor := SavedCursor;
end;

procedure tCallV(ReturnData: TStrings; const RPCName: string; const aParam: array of const);
{ calls the broker and returns TStrings data }
var
  SavedCursor: TCursor;
begin
  if ReturnData = nil then raise Exception.Create('TString not created');
  if AbortRPCCall then
  begin
    ReturnData.Clear;
    exit;
  end;
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  LockBroker;
  try
    SetParams(RPCName, aParam);
    ReturnData.Clear;
    CallBroker; // RPCBrokerV.Call;
    FastAssign(RPCBrokerV.Results, ReturnData);
  finally
    UnlockBroker;
  end;
  Screen.Cursor := SavedCursor;
end;

(* uncomment if these are needed -

  function pCallV(const RPCName: string; const AParam: array of const): PChar;
  { Calls the Broker.  Result is a PChar containing raw Broker data. }
  { -- Caller must dispose the string that is returned -- }
  var
  SavedCursor: TCursor;
  begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  RPCBrokerV.Call;
  pCallV := StrNew(RPCBrokerV.Results.GetText);
  Screen.Cursor := SavedCursor;
  end;

  procedure wCallV(AControl: TControl; const RPCName: string; const AParam: array of const);
  { Calls the Broker.  Places data into control (wrapped). }
  var
  BufPtr: PChar;
  begin
  BufPtr := pCallV(RPCName, AParam);
  WrapWP(BufPtr);
  AControl.SetTextBuf(BufPtr);
  StrDispose(BufPtr);
  end;

  procedure WrapWP(Buf: pChar);
  { Iterates through Buf and wraps text in the same way that FM wraps text. }
  var
  PSub: PChar;
  begin
  PSub := StrScan(Buf, #13);
  while PSub <> nil do
  begin
  if Ord(PSub[2]) > 32 then
  begin
  StrMove(PSub, PSub + SizeOf(Char), StrLen(PSub));
  PSub[0] := #32;
  end
  else repeat Inc(PSub, SizeOf(Char)) until (Ord(PSub[0]) > 32) or (PSub = StrEnd(PSub));
  PSub := StrScan(PSub, #13);
  end;
  end;

*)

function RetainedRPCCount: Integer;
begin
  Result := uCallList.Count;
end;

procedure SetRetainedRPCMax(Value: Integer);
begin
  if Value > 0 then uMaxCalls := Value;
end;

function GetRPCMax: Integer;
begin
  Result := uMaxCalls;
end;

procedure SetAfterRPCEvent(Value: TAfterRPCEvent);
begin
  AfterRPCEvent := Value;
end;

procedure LoadRPCData(Dest: TStrings; ID: Integer);
begin
  uCallList.Lock;
  try
    if (ID > -1) and (ID < uCallList.Count) then
      Dest.Assign(uCallList.Items[ID]);
  finally
    uCallList.Unlock;
  end;
end;

function RetrieveRPCName(ID: Integer): string;
begin
  uCallList.Lock;
  try
    Result := '';
    if (ID > -1) and (ID < uCallList.Count) then
    begin
      // the first line of the RPC Broker data the RPC Name
      if uCallList.Items[ID].Count > 0 then
        Result := uCallList.Items[ID][0];
    end;
  finally
    uCallList.Unlock;
  end;
end;

function DottedIPStr: string;
{ return the IP address of the local machine as a string in dotted form: nnn.nnn.nnn.nnn }
const
  WINSOCK1_1 = $0101; // minimum required version of WinSock
  SUCCESS = 0; // value returned by WinSock functions if no error
var
  // WSAData: TWSAData;       // structure to hold startup information
  HostEnt: PHostEnt; // pointer to Host Info structure (see WinSock 1.1, page 60)
  IPAddr: PInAddr; // pointer to IP address in network order (4 bytes)
  LocalName: array [0 .. 255] of AnsiChar; // buffer for the name of the client machine
begin
  Result := 'No IP Address';
  // ensure the Winsock DLL has been loaded (should be if there is a broker connection)
  // if WSAStartup(WINSOCK1_1, WSAData) <> SUCCESS then Exit;
  // try
  // get the name of the client machine
  if gethostname(@LocalName, SizeOf(LocalName) - 1) <> SUCCESS then Exit;
  // get information about the client machine (contained in a record of type THostEnt)
  HostEnt := gethostbyname(@LocalName);
  if HostEnt = nil then Exit;
  // get a pointer to the four bytes that contain the IP address
  // Dereference HostEnt to get the THostEnt record.  In turn, dereference the h_addr_list
  // field to get a pointer to the IP address.  The pointer to the IP address is type PChar,
  // so it needs to be typecast as PInAddr in order to make the call to inet_ntoa.
  IPAddr := PInAddr(HostEnt^.h_addr_list^);
  // Dereference IPAddr (which is a PChar typecast as PInAddr) to get the 4 bytes that need
  // to be passed to inet_ntoa.  A string with the IP address in dotted format is returned.
  Result := string(AnsiString(inet_ntoa(IPAddr^)));
  // finally
  // causes the reference counter in Winsock (set by WSAStartup, above) to be decremented
  // WSACleanup;
  // end;
end;

procedure RPCIdleCallDone(Msg: string);
begin
  RPCBrokerV.ClearResults := True;
end;

procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: string);
begin
  CallWhenIdleNotifyWhenDone(CallProc, RPCIdleCallDone, Msg);
end;

function ShowRPCList: boolean;
begin
  if uShowRPCs then Result := True
  else Result := False;
end;

// =========== Backward Compatiable Code ===========//
procedure SetRPCFlaged(Value: string);
begin
  fRPCFlaged := Value;
end;

function GetRPCFlaged: string;
begin
  Result := fRPCFlaged;
end;
// ===============================================//


// ORWU DT Optimization Routines

function GetFMNow: TFMDateTime;
begin
  Result := GetFMDT('NOW');
end;

var
  uLastHour: word = 99;
  uServerOffset: TDateTime = 0.0;
  uLastDTS: TDateTime = 88.88;
  uDTList: TStringList;

function GetFMDT(const aString: string; const aParams: string = ''): TFMDateTime;
var
  str, tstr, param: string;
  dt, dts: TDateTime;
  hour, min, sec, msec: word;
  idx: integer;
  sync: boolean;

  function GetServerDT: TFMDateTime;
  begin
    if aParams = '' then
      CallVistA('ORWU DT', [param], Result) // do not pass '' as 2nd param
    else
      CallVistA('ORWU DT', [param, aParams], Result);
  end;

begin
  if UnitTestingActive then
  begin
    param := aString;
    Result := GetServerDT
  end
  else if ((RPCBrokerV <> nil) and RPCBrokerV.Connected) then
  begin
    str := UpperCase(aString);
    tstr := Trim(str);
    if (tstr = '') or (tstr <> str) then
    begin
      Result := -1;
      exit;
    end;
    dt := now;
    dts := dt + uServerOffset;
    sync := (DateOf(uLastDTS) <> DateOf(dts));
    if not sync then
    begin
      DecodeTime(dts, hour, min, sec, msec);
      sync := (uLastHour <> hour);
    end;
    if not sync then
      sync := (dts < uLastDTS); // can be true on daylight savings time
    if sync then   // resync with server every hour
    begin
      param := 'NOW';
      Result := GetServerDT;
      dts := FMDateTimeToDateTime(Result);
      uServerOffset := dts - dt;
      uLastDTS := dts;
      DecodeTime(dts, uLastHour, min, sec, msec);
      uDTList.Clear;  // cached values such as T-7 will change when the day changes.
      if IsNow(str) then
        exit;
    end;
    if IsNow(str) then
      Result := DateTimeToFMDateTime(dts)
    else if (str = 'T') or (str = 'TODAY') then
      Result := Trunc(DateTimeToFMDateTime(dts))
    else
    begin
      param := str;
      if str.StartsWith('NOW') or str.StartsWith('N+') or str.StartsWith('N-') then
        Result := GetServerDT
      else
      begin
        str := str + '/' + aParams;
        idx := uDTList.IndexOfName(str);
        if idx < 0 then
        begin
          Result := GetServerDT;
          // Add check for greater than XE8
          {$IF CompilerVersion > 29.0}
          uDTList.AddPair(str, FloatToStr(Result));
          {$ELSE}
          uDTList.Add(str + uDTList.NameValueSeparator + FloatToStr(Result));
          {$ENDIF}
        end
        else
          Result := StrToFloatDef(uDTList.ValueFromIndex[idx], 0.0);
      end;
    end;
  end
  else
    Result := 0.0;
end;

type
  TMyRPCBroker = class(Trpcb.TRPCBroker);

procedure tPulseObject.PulseError(RPCBroker: TRPCBroker; ErrorText: String);
var
  DoError: boolean;
begin
  if Application.Terminated then
    Exit;
  if RPCBroker.Connected then
  begin
    DoError := False;
    if FInPulseError then
    begin
      inc(FInPulseErrorCount);
      if FInPulseErrorCount > MAX_RPC_TRIES then
      begin
        DoError := True;
        RPCBroker.Connected := False;
      end
      else
        TMyRPCBroker(RPCBroker).DoPulseOnTimer(RPCBroker);
    end
    else
    begin
      FInPulseError := True;
      FInPulseErrorCount := 1;
      try
        TMyRPCBroker(RPCBroker).DoPulseOnTimer(RPCBroker);
      finally
        FInPulseError := False;
      end;
    end;
  end
  else
    DoError := True;

  if DoError Then
  begin
    Application.MessageBox('Application must shutdown due to lost VistA Connection.', 'Server Error', MB_OK);
    Application.Terminate;       // This just posts WM_QUIT
    TResponsiveGUI.ProcessMessages(True); // This will see the WM_QUIT and set Application.Terminated to TRUE;
  end;
end;

{ TCallList }

procedure TCallList.Add(Item: TStringList);
begin
  Lock;
  try
    FList.Add(Item);
  finally
    Unlock;
  end;
end;

constructor TCallList.Create;
begin
  inherited;
  FList := TObjectList<TStringList>.Create;
  FLock := TCriticalSection.Create;
end;

procedure TCallList.Delete(Index: Integer);
begin
  Lock;
  try
    FList.Delete(Index);
  finally
    Unlock;
  end;
end;

destructor TCallList.Destroy;
begin
  FreeAndNil(FLock);
  FreeAndNil(FList);
  inherited;
end;

function TCallList.GetCount: Integer;
begin
  Lock;
  try
    Result := FList.Count;
  finally
    Unlock;
  end;
end;

function TCallList.GetItems(Index: integer): TStringList;
begin
  Lock;
  try
    Result := FList[Index];
  finally
    Unlock;
  end;
end;

procedure TCallList.Lock;
begin
  FLock.Acquire;
end;

procedure TCallList.Unlock;
begin
  FLock.Release;
end;

initialization
  RPCBrokerV := nil;
  RPCLastCall := 'No RPCs called';
  uCallList := TCallList.Create;
  uMaxCalls := 100;
  uShowRPCs := False;
  uDTList := TStringList.Create;
  PulseObject := tPulseObject.Create;

finalization
  FreeAndNil(uCallList);
  uDTList.Free;
  PulseObject.Free;

end.

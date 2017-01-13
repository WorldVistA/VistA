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
procedure CallV(const RPCName: string; const aParam: array of const);
function sCallV(const RPCName: string; const aParam: array of const): string;
procedure tCallV(ReturnData: TStrings; const RPCName: string; const aParam: array of const);
function UpdateContext(NewContext: string): boolean;
function IsBaseContext: boolean;
procedure CallBrokerInContext(aReturn: TStrings = nil);
procedure CallBroker(aReturn: TStrings = nil);
function RetainedRPCCount: Integer;
procedure SetRetainedRPCMax(Value: Integer);
function GetRPCMax: Integer;
procedure LoadRPCData(Dest: TStrings; ID: Integer);
function DottedIPStr: string;
procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: string);
function ShowRPCList: boolean;
procedure EnsureBroker;

// =========== Backward Compatiable Code ===========//
procedure SetRPCFlaged(Value: string);
function GetRPCFlaged: string;
// ================================================//

function CallVistA(const aRPCName: string; const aParam: array of const): boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const; aReturn: TStrings): boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: string; aDefault: string = ''): boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: Double; aDefault: Double = 0.0): boolean; overload;
function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: Integer; aDefault: Integer = 0): boolean; overload;

var
  RPCBrokerV: TRPCBroker;
  RPCLastCall: string;
  AppStartedCursorForm: TForm = nil;

type
  TAfterRPCEvent = procedure() of object;

procedure SetAfterRPCEvent(Value: TAfterRPCEvent);

implementation

uses
  ORNetIntf,
  Winsock;

const
  // *** these are constants from RPCBErr.pas, will broker document them????
  XWB_M_REJECT = 20000 + 2; // M error
  XWB_BadSignOn = 20000 + 4; // SignOn 'Error' (happens when cancel pressed)
  RPCBROKER_MUTEX_NAME = 'RPCBroker Mutex';

var
  uCallList: TList;
  uMaxCalls: Integer;
  uShowRPCs: boolean;
  uBaseContext: string = '';
  uCurrentContext: string = '';
  AfterRPCEvent: TAfterRPCEvent;

  // =========== Backward Compatiable Code ===========//
  fRPCFlaged: string;
  // ================================================//

  { private procedures and functions ---------------------------------------------------------- }

procedure EnsureBroker;
{ ensures that a broker object has been created - creates & initializes it if necessary }
begin
  if RPCBrokerV = nil then
    begin
      RPCBrokerV := TRPCBroker.Create(Application);
      with RPCBrokerV do
        begin
          KernelLogIn := True;
          Login.Mode := lmAppHandle;
          ClearParameters := True;
          ClearResults := True;
          DebugMode := False;
          AfterRPCEvent := nil;
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
      for aStr in AStringList do
        begin
          Mult[IntToStr(i)] := aStr;
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
                    Value := string(VString^);
                    if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                  end;
              vtPointer: if VPointer = nil then
                  ClearParameters := True { Param[i].PType := null }
                else
                  raise Exception.Create('Pointer type must be nil.');
              vtPChar: Param[i].Value := string(AnsiChar(VPChar));

              vtInterface:
                if IInterface(VInterface).QueryInterface(IORNetParam, aORNetParam) = 0 then
                  aORNetParam.AssignToParamRecord(Param[i]);

              vtObject:
                begin
                  if VObject is TStrings then
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
                    Value := string(VAnsiString);
                    if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                  end;
              vtInt64: Param[i].Value := IntToStr(VInt64^);
              vtUnicodeString: with Param[i] do
                  begin
                    Value := string(VUnicodeString);
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

{ public procedures and functions ----------------------------------------------------------- }

function CallVistA(const aRPCName: string; const aParam: array of const): boolean; overload;
{ Call Broker, no results. i.e. POST }
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    Result := CallVistA(aRPCName, aParam, aLst);
  finally
    FreeAndNil(aLst);
  end;
end;

function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: Integer; aDefault: Integer = 0): boolean; overload;
{ Call Broker, Result[0] in aReturn as integer }
var
  aStr: string;
begin
  if CallVistA(aRPCName, aParam, aStr) then
    begin
      aReturn := StrToIntDef(aStr, aDefault);
      Result := True;
    end
  else
    Result := False;
end;

function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: Double; aDefault: Double = 0.0): boolean; overload;
{ Call Broker, Result[0] in aReturn as Double }
var
  aStr: string;
begin
  if CallVistA(aRPCName, aParam, aStr) then
    begin
      aReturn := StrToFloatDef(aStr, aDefault);
      Result := True;
    end
  else
    Result := False;
end;

function CallVistA(const aRPCName: string; const aParam: array of const; var aReturn: string; aDefault: string = ''): boolean; overload;
{ Call Broker, Result[0] in aReturn as string }
var
  aLst: TStringList;
begin
  aLst := TStringList.Create;
  try
    Result := CallVistA(aRPCName, aParam, aLst);
    if aLst.Count > 0 then
      aReturn := aLst[0]
    else
      aReturn := '';
    Result := True;
  finally
    FreeAndNil(aLst);
  end;
end;

function CallVistA(const aRPCName: string; const aParam: array of const; aReturn: TStrings): boolean; overload;
{ Call Broker, full results in aReturn }
var
  aMutex: Integer;
begin
  repeat
    aMutex := CreateMutex(nil, True, RPCBROKER_MUTEX_NAME);
  until (aMutex <> 0) and (GetLastError <> ERROR_ALREADY_EXISTS);

  try
    try
      Result := False;
      SetParams(aRPCName, aParam);
      aReturn.Clear;
      CallBroker(aReturn);
      Result := True;
    finally
      RPCBrokerV.Results.Clear;
      RPCBrokerV.Param.Clear;
    end;
  finally
    CloseHandle(aMutex);
  end;
end;

function UpdateContext(NewContext: string): boolean;
begin
  if NewContext = uCurrentContext then
    Result := True
  else
    begin
      Result := RPCBrokerV.CreateContext(NewContext);
      if Result then
        uCurrentContext := NewContext
      else
      if (NewContext <> uBaseContext) and RPCBrokerV.CreateContext(uBaseContext) then
        uCurrentContext := uBaseContext
      else
        uCurrentContext := '';
    end;
end;

function IsBaseContext: boolean;
begin
  Result := ((uCurrentContext = uBaseContext) or (uCurrentContext = ''));
end;

procedure CallBrokerInContext(aReturn: TStrings = nil);
var
  AStringList: TStringList;
  i, j: Integer;
  x, y, RunString: string;
  RPCStart, RPCStop, fFrequency: TLargeInteger;
  dt: TDateTime;
begin
  RPCLastCall := string(RPCBrokerV.RemoteProcedure) + ' (CallBroker begin)';
  if uShowRPCs then StatusText(string(RPCBrokerV.RemoteProcedure));
  with RPCBrokerV do
    if not Connected then // happens if broker connection is lost
      begin
        ClearResults := True;
        Exit;
      end;
  if uCallList.Count = uMaxCalls then
    begin
      AStringList := uCallList.Items[0];
      AStringList.Free;
      uCallList.Delete(0);
    end;
  AStringList := TStringList.Create;
  AStringList.Add(string(RPCBrokerV.RemoteProcedure));
  AStringList.Add(''); // add to the second line
  if uCurrentContext <> uBaseContext then
    AStringList.Add('Context: ' + uCurrentContext);
  AStringList.Add(' ');
  AStringList.Add('Params ------------------------------------------------------------------');
  with RPCBrokerV do
    for i := 0 to Param.Count - 1 do
      begin
        case Param[i].PType of
          // global:    x := 'global';
          list: x := 'list';
          literal: x := 'literal';
          // null:      x := 'null';
          reference: x := 'reference';
          undefined: x := 'undefined';
          // wordproc:  x := 'wordproc';
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
    // The broker erroneously sets connected to false if there is any error (including an
    // error on the M side). It should only set connection to false if there is no connection.
    on E: EBrokerError do
      begin
        if E.Code = XWB_M_REJECT then
          begin
            x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
            Application.MessageBox(PChar(x), 'Server Error', MB_OK);
          end
        else raise;
        (*
          case E.Code of
          XWB_M_REJECT:  begin
          x := 'An error occurred on the server.' + CRLF + CRLF + E.Action;
          Application.MessageBox(PChar(x), 'Server Error', MB_OK);
          end;
          else           begin
          x := 'An error occurred with the network connection.' + CRLF +
          'Action was: ' + E.Action + CRLF + 'Code was: ' + E.Mnemonic +
          CRLF + CRLF + 'Application cannot continue.';
          Application.MessageBox(PChar(x), 'Network Error', MB_OK);
          end;
          end;
        *)
        // make optional later...
        if not RPCBrokerV.Connected then Application.Terminate;
      end;
  end;
  RunString := 'Ran at:' + FormatDateTime('hh:nn:ss.z a/p', now);
  QueryPerformanceFrequency(fFrequency);
  dt := ((MSecsPerSec * (RPCStop - RPCStart)) div fFrequency) / MSecsPerSec / SecsPerDay;
  RunString := RunString + #13#10 + 'Run time:' + FormatDateTime('hh:nn:ss.z', dt);
  AStringList[1] := RunString;
  AStringList.Add(' ');
  AStringList.Add('Results -----------------------------------------------------------------');
  FastAddStrings(RPCBrokerV.Results, AStringList);
  uCallList.Add(AStringList);
  if uShowRPCs then StatusText('');
  RPCLastCall := string(RPCBrokerV.RemoteProcedure) + ' (completed)';

  if Assigned(AfterRPCEvent) then
    AfterRPCEvent();

end;

procedure CallBroker(aReturn: TStrings = nil);
begin
  UpdateContext(uBaseContext);
  CallBrokerInContext(aReturn);
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
      uCurrentContext := OptionName;
    end;
end;

function ConnectToServer(const OptionName: string): boolean;
{ establish initial connection to server using optional command line parameters and check that
  this application (option) is allowed for this user }
var
  WantDebug: boolean;
  AServer, APort, x: string;
  i, ModalResult: Integer;
begin
  Result := False;
  WantDebug := False;
  AServer := '';
  APort := '';
  for i := 1 to ParamCount do // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
    begin
      if UpperCase(ParamStr(i)) = 'DEBUG' then WantDebug := True;
      if UpperCase(ParamStr(i)) = 'SHOWRPCS' then uShowRPCs := True;
      x := UpperCase(Piece(ParamStr(i), '=', 1));
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
    SetBrokerServer(AServer, StrToIntDef(APort, 9200), WantDebug);
    Result := AuthorizedOption(OptionName);
    if Result then Result := RPCBrokerV.Connected;
    RPCBrokerV.RPCTimeLimit := 300;
  except
    on E: EBrokerError do
      begin
        if E.Code <> XWB_BadSignOn then InfoBox(E.Message, 'Error', MB_OK or MB_ICONERROR);
        Result := False;
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
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, aParam);
  CallBroker; // RPCBrokerV.Call;
  Screen.Cursor := SavedCursor;
end;

function sCallV(const RPCName: string; const aParam: array of const): string;
{ calls the broker and returns a scalar value. }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, aParam);
  CallBroker; // RPCBrokerV.Call;
  if RPCBrokerV.Results.Count > 0 then Result := RPCBrokerV.Results[0]
  else Result := '';
  Screen.Cursor := SavedCursor;
end;

procedure tCallV(ReturnData: TStrings; const RPCName: string; const aParam: array of const);
{ calls the broker and returns TStrings data }
var
  SavedCursor: TCursor;
begin
  if ReturnData = nil then raise Exception.Create('TString not created');
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, aParam);
  CallBroker; // RPCBrokerV.Call;
  FastAssign(RPCBrokerV.Results, ReturnData);
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
  if (ID > -1) and (ID < uCallList.Count) then FastAssign(TStringList(uCallList.Items[ID]), Dest);
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

initialization

RPCBrokerV := nil;
RPCLastCall := 'No RPCs called';
uCallList := TList.Create;
uMaxCalls := 100;
uShowRPCs := False;

finalization

while uCallList.Count > 0 do
  begin
    TStringList(uCallList.Items[0]).Free;
    uCallList.Delete(0);
  end;
uCallList.Free;

end.

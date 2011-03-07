unit ORNet;

//{$DEFINE CCOWBROKER}

interface

uses SysUtils, Windows, Classes, Forms, Controls, ORFn, TRPCB, RPCConf1, Dialogs
      ;  //, SharedRPCBroker;


procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: Boolean);
function AuthorizedOption(const OptionName: string): Boolean;
function ConnectToServer(const OptionName: string): Boolean;
function MRef(glvn: string): string;
procedure CallV(const RPCName: string; const AParam: array of const);
function sCallV(const RPCName: string; const AParam: array of const): string;
procedure tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
function UpdateContext(NewContext: string): boolean;
function IsBaseContext: boolean;
procedure CallBrokerInContext;
procedure CallBroker;
function RetainedRPCCount: Integer;
procedure SetRetainedRPCMax(Value: Integer);
function GetRPCMax: integer;
procedure LoadRPCData(Dest: TStrings; ID: Integer);
function DottedIPStr: string;
procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: String);
function ShowRPCList: Boolean;

procedure EnsureBroker;

(*
function pCallV(const RPCName: string; const AParam: array of const): PChar;
procedure wCallV(AControl: TControl; const RPCName: string; const AParam: array of const);
procedure WrapWP(Buf: pChar);
*)

var
  RPCBrokerV: TRPCBroker;
  RPCLastCall: string;

  AppStartedCursorForm: TForm = nil;

implementation

uses Winsock;

const
  // *** these are constants from RPCBErr.pas, will broker document them????
  XWB_M_REJECT =  20000 + 2;  // M error
  XWB_BadSignOn = 20000 + 4;  // SignOn 'Error' (happens when cancel pressed)

var
  uCallList: TList;
  uMaxCalls: Integer;
  uShowRPCs: Boolean;
  uBaseContext: string = '';
  uCurrentContext: string = '';

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
      Login.Mode  := lmAppHandle;
      ClearParameters := True;
      ClearResults := True;
      DebugMode := False;
    end;
  end;
end;

procedure SetList(AStringList: TStrings; ParamIndex: Integer);
{ places TStrings into RPCBrokerV.Mult[n], where n is a 1-based (not 0-based) index }
var
  i: Integer;
begin
  with RPCBrokerV.Param[ParamIndex] do
  begin
    PType := list;
    with AStringList do for i := 0 to Count - 1 do Mult[IntToStr(i+1)] := Strings[i];
  end;
end;

procedure SetParams(const RPCName: string; const AParam: array of const);
{ takes the params (array of const) passed to xCallV and sets them into RPCBrokerV.Param[i] }
const
  BoolChar: array[boolean] of char = ('0', '1');
var
  i: integer;
  TmpExt: Extended;
begin
  RPCLastCall := RPCName + ' (SetParam begin)';
  if Length(RPCName) = 0 then raise Exception.Create('No RPC Name');
  EnsureBroker;
  with RPCBrokerV do
  begin
    ClearParameters := True;
    RemoteProcedure := RPCName;
    for i := 0 to High(AParam) do with AParam[i] do
    begin
      Param[i].PType := literal;
      case VType of
      vtInteger:    Param[i].Value := IntToStr(VInteger);
      vtBoolean:    Param[i].Value := BoolChar[VBoolean];
      vtChar:       if VChar = #0 then
                      Param[i].Value := ''
                    else
                      Param[i].Value := VChar;
      //vtExtended:   Param[i].Value := FloatToStr(VExtended^);
      vtExtended:   begin
                      TmpExt := VExtended^;
                      if(abs(TmpExt) < 0.0000000000001) then TmpExt := 0;
                      Param[i].Value := FloatToStr(TmpExt);
                    end;
      vtString:     with Param[i] do
                    begin
                      Value := VString^;
                      if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                    end;
      vtPChar:      Param[i].Value := StrPas(VPChar);
      vtPointer:    if VPointer = nil
                      then ClearParameters := True {Param[i].PType := null}
                      else raise Exception.Create('Pointer type must be nil.');
      vtObject:     if VObject is TStrings then SetList(TStrings(VObject), i);
      vtAnsiString: with Param[i] do
                    begin
                      Value := string(VAnsiString);
                      if (Length(Value) > 0) and (Value[1] = #1) then
                      begin
                        Value := Copy(Value, 2, Length(Value));
                        PType := reference;
                      end;
                    end;
      vtInt64:      Param[i].Value := IntToStr(VInt64^);
        else raise Exception.Create('Unable to pass parameter type to Broker.');
      end; {case}
    end; {for}
  end; {with}
  RPCLastCall := RPCName + ' (SetParam end)';
end;

{ public procedures and functions ----------------------------------------------------------- }

function UpdateContext(NewContext: string): boolean;
begin
  if NewContext = uCurrentContext then
    Result := TRUE
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

procedure CallBrokerInContext;
var
  AStringList: TStringList;
  i, j: Integer;
  x, y: string;
begin
  RPCLastCall := RPCBrokerV.RemoteProcedure + ' (CallBroker begin)';
  if uShowRPCs then StatusText(RPCBrokerV.RemoteProcedure);
  with RPCBrokerV do if not Connected then  // happens if broker connection is lost
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
  AStringList.Add(RPCBrokerV.RemoteProcedure);
  if uCurrentContext <> uBaseContext then
    AStringList.Add('Context: ' + uCurrentContext);
  AStringList.Add(' ');
  AStringList.Add('Params ------------------------------------------------------------------');
  with RPCBrokerV do for i := 0 to Param.Count - 1 do
  begin
    case Param[i].PType of
    //global:    x := 'global';
    list:      x := 'list';
    literal:   x := 'literal';
    //null:      x := 'null';
    reference: x := 'reference';
    undefined: x := 'undefined';
    //wordproc:  x := 'wordproc';
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
  end; {with...for}
  //RPCBrokerV.Call;
  try
    RPCBrokerV.Call;
  except
    // The broker erroneously sets connected to false if there is any error (including an
    // error on the M side). It should only set connection to false if there is no connection.
    on E:EBrokerError do
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
  AStringList.Add(' ');
  AStringList.Add('Results -----------------------------------------------------------------');
  FastAddStrings(RPCBrokerV.Results, AStringList);
  uCallList.Add(AStringList);
  if uShowRPCs then StatusText('');
  RPCLastCall := RPCBrokerV.RemoteProcedure + ' (completed)';
end;

procedure CallBroker;
begin
  UpdateContext(uBaseContext);
  CallBrokerInContext;
end;

procedure SetBrokerServer(const AName: string; APort: Integer; WantDebug: Boolean);
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

function AuthorizedOption(const OptionName: string): Boolean;
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

function ConnectToServer(const OptionName: string): Boolean;
{ establish initial connection to server using optional command line parameters and check that
  this application (option) is allowed for this user }
var
  WantDebug: Boolean;
  AServer, APort, x: string;
  i, ModalResult: Integer;
begin
  Result := False;
  WantDebug := False;
  AServer := '';
  APort := '';
  for i := 1 to ParamCount do            // params may be: S[ERVER]=hostname P[ORT]=port DEBUG
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
    on E:EBrokerError do
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
  if assigned(AppStartedCursorForm) and (AppStartedCursorForm.Visible) then
  begin
    pt := Mouse.CursorPos;
    if PtInRect(AppStartedCursorForm.BoundsRect, pt) then
      Result := crAppStart;    
  end;
end;

procedure CallV(const RPCName: string; const AParam: array of const);
{ calls the broker leaving results in results property which must be read by caller }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  Screen.Cursor := SavedCursor;
end;

function sCallV(const RPCName: string; const AParam: array of const): string;
{ calls the broker and returns a scalar value. }
var
  SavedCursor: TCursor;
begin
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  if RPCBrokerV.Results.Count > 0 then Result := RPCBrokerV.Results[0] else Result := '';
  Screen.Cursor := SavedCursor;
end;

procedure tCallV(ReturnData: TStrings; const RPCName: string; const AParam: array of const);
{ calls the broker and returns TStrings data }
var
  SavedCursor: TCursor;
begin
  if ReturnData = nil then raise Exception.Create('TString not created');
  SavedCursor := Screen.Cursor;
  Screen.Cursor := GetRPCCursor;
  SetParams(RPCName, AParam);
  CallBroker;  //RPCBrokerV.Call;
  FastAssign(RPCBrokerV.Results, ReturnData);
  Screen.Cursor := SavedCursor;
end;

(*  uncomment if these are needed -

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

function GetRPCMax: integer;
begin
  Result := uMaxCalls;
end;

procedure LoadRPCData(Dest: TStrings; ID: Integer);
begin
  if (ID > -1) and (ID < uCallList.Count) then FastAssign(TStringList(uCallList.Items[ID]), Dest);
end;

function DottedIPStr: string;
{ return the IP address of the local machine as a string in dotted form: nnn.nnn.nnn.nnn }
const
  WINSOCK1_1 = $0101;      // minimum required version of WinSock
  SUCCESS = 0;             // value returned by WinSock functions if no error
var
  //WSAData: TWSAData;       // structure to hold startup information
  HostEnt: PHostEnt;       // pointer to Host Info structure (see WinSock 1.1, page 60)
  IPAddr: PInAddr;         // pointer to IP address in network order (4 bytes)
  LocalName: array[0..255] of Char;  // buffer for the name of the client machine
begin
  Result := 'No IP Address';
  // ensure the Winsock DLL has been loaded (should be if there is a broker connection)
  //if WSAStartup(WINSOCK1_1, WSAData) <> SUCCESS then Exit;
  //try
    // get the name of the client machine
    if gethostname(LocalName, SizeOf(LocalName) - 1) <> SUCCESS then Exit;
    // get information about the client machine (contained in a record of type THostEnt)
    HostEnt := gethostbyname(LocalName);
    if HostEnt = nil then Exit;
    // get a pointer to the four bytes that contain the IP address
    // Dereference HostEnt to get the THostEnt record.  In turn, dereference the h_addr_list
    // field to get a pointer to the IP address.  The pointer to the IP address is type PChar,
    // so it needs to be typecast as PInAddr in order to make the call to inet_ntoa.
    IPAddr := PInAddr(HostEnt^.h_addr_list^);
    // Dereference IPAddr (which is a PChar typecast as PInAddr) to get the 4 bytes that need
    // to be passed to inet_ntoa.  A string with the IP address in dotted format is returned.
    Result := inet_ntoa(IPAddr^);
  //finally
    // causes the reference counter in Winsock (set by WSAStartup, above) to be decremented
    //WSACleanup;
  //end;
end;

procedure RPCIdleCallDone(Msg: string);
begin
  RPCBrokerV.ClearResults := True; 
end;

procedure CallRPCWhenIdle(CallProc: TORIdleCallProc; Msg: String);
begin
  CallWhenIdleNotifyWhenDone(CallProc, RPCIdleCallDone, Msg);
end;

function ShowRPCList: Boolean;
begin
  if uShowRPCS then Result := True
  else Result := False;
end;


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

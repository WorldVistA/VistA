{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: manages Winsock connections and creates/parses
	             messages
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008)
*************************************************************** }

unit Wsockc;
{
  Changes in v1.1.13 (JLI -- 8/23/00) -- XWB*1.1*13
    Made changes to cursor dependent on current cursor being crDefault so
       that the application can set it to a different cursor for long or
       repeated processes without the cursor 'flashing' repeatedly.

  Changes in v1.1.8 (REM -- 6/18/99) -- XWB*1.1*8
    Update version 'BrokerVer'.

  Changes in v1.1.6 (DPC -- 6/7/99) -- XWB*1.1*6
    In tCall function, made changing cursor to hourglass conditional:
    don't do it if XWB IM HERE  RPC is being invoked.

  Changes in V1.1.4 (DCM - 9/18/98)-XWB*1.1*4
  1.  Changed the ff line in NetStart from:
      if inet_addr(PChar(Server)) <> INADDR_NONE then
      to
      if inet_addr(PChar(Server)) <> longint(INADDR_NONE) then
  Reason:  true 64 bit types in Delphi 4
  2.  Changed the ff line in NetStart from:
      $else
      hSocket := accept(hSocketListen, DHCPHost, AddrLen);{ -- returns new socket
      to
      $else
      hSocket := accept(hSocketListen, @DHCPHost, @AddrLen);{ -- returns new socket
  Reason:  Incompatible types when recompiling
  3. In NetStop, if socket <= 0, restore the default cursor.
  Reason:  Gave the impression of a busy process after the Kernel login
      process timesout.

  Changes in V1.1T3  [Feb 5, 1997]
  1. Connect string now includes workstation name. This is used by kernel
     security.
  2. Code is 32bit compliant for Delphi 2.0
  3. A great majority of PChars changed to default string (ansi-string)
  4. Reading is done in 32k chunks during a loop.  Intermediate data is
     buffered into a string.  At the end, a PChar is allocated and
     returned to maintain compatibility with the original broker interface.
     It is expected that shortly this will change once the broker component
     changes its usage of tcall to expect a string return.  Total read
     can now exceed 32K up to workstation OS limits.
  5. Creation of Hostent and Address structures has been streamlined.

  Changes in V1.0T12
  1. Inclusion of hSocket as a parameter on most API calls


  Changes in V1.0T11
  1. Reference parameter type is included. i.e. $J will be evaluated rather
  than sending "$J".
  2. Fully integrated with the TRPCB component interface.
  3. This low level module is now called from an intermediate DLL.

  Changes in V1.0T10
  1. Fixed various memory leaks.

  Changes in V1.0T9
  1. Supports word processing fields.
  2. Added a new exception type EBrokerError.  This is raised when errors occur
  in NetCall, NetworkConnect, and NetworkDisconnect

  Changes in V1.0T8
  1. Fix a problem in BuildPar in the case of a single list parameter with many
     entries.
  2. List parameters (arrays) can be large up to 65520 bytes
  3. Introduction of sCallV and tCallV which use the Delphi Pascal open array
     syntax (sCallFV and tCallV developed by Kevin Meldrum)
  4. A new brokerDataRec type, null has been introduced to represent M calls
     with no parameters, i.e. D FUN^LIB().
  5. if you want to send a null parameter "", i.e. D FUN^LIB(""), Value
  should be set to ''.
  6. Fixed bug where a single ^ passed to sCall would generate error (confused
  as a global reference.
  7. Fixed a bug where a first position dot (.) in a literal parameter would
  cause an error at the server end.
  8. Fixed a bug where null strings (as white space in a memo box for example)
  would not be correctly received at the server.

  Changes in V1.0T7
  1. Procedure NetworkConnect has been changed to Function NetworkConnect
     returning BOOL
  2. global variable IsConnected (BOOL) can be used to determine connection
     state
  3. Function cRight has been fixed to preserve head pointer to input PChar
     string
  4. New message format which includes length calculations for input parameters

   *******************************************************************
  A 32-bit high level interface to the Winsock API in Delphi Pascal.

  This implementation allows communications between Delphi forms and
  DHCP back end servers through the use of the DHCP Request Broker.

  Usage: Put wsock in your Uses clause of your Delphi form.  See additional
  specs for Request Broker message formats, etc.
  Programmer: Enrique Gomez - VA San Francisco ISC - April 1995
}


interface

uses
  SysUtils, winsock, xwbut1, WinProcs, Wintypes, Classes, Dialogs, 
  Forms, Controls, StdCtrls, ClipBrd, Trpcb, RpcbErr;

type
  TXWBWinsock = class(TObject)
  private
    FCountWidth: Integer;
    FIsBackwardsCompatible: Boolean;
    FOldConnectionOnly: Boolean;
    IsVisual: boolean; //Show graphics (default true)
  public
    XNetCallPending, xFlush: boolean;
    SocketError, XHookTimeOut: integer;
    XNetTimerStart: TDateTime;
    BROKERSERVER: string;
    SecuritySegment, ApplicationSegment: string;
    IsConnected: Boolean;
    IsNewStyle: Boolean;
    // 060919 added to support multiple brokers with both old and new type connections
    Prefix: String;
//    NetBlockingHookVar: Function(): Bool; export;
//    function NetCall(hSocket: integer; imsg: AnsiString): PChar; // JLI O90705
    function NetCall(hSocket: integer; imsg: String): PChar; // JLI O90705
    function tCall(hSocket: integer; api, apVer: String; Parameters: TParams;
             var Sec, App: PChar; TimeOut: integer): PChar;
    function cRight( z: PChar;  n: longint): PChar;
    function cLeft( z: PChar; n: longint): PChar;
    function BuildApi ( n,p: string; f: longint): string;
    function BuildHdr ( wkid: string; winh: string; prch: string;
             wish: string): string;
    function BuildPar(hSocket: integer; api, RPCVer: string;
             const Parameters: TParams): string;
    function StrPack ( n: string; p: integer): string;
    function VarPack(n: string): string;
    function NetStart(ForegroundM: boolean; Server: string; ListenerPort: integer;
                  var hSocket: integer): integer;
    function NetworkConnect(ForegroundM: boolean; Server: string; ListenerPort, 
        TimeOut: integer): Integer;
    function libSynGetHostIP(s: string): string;
    function libNetCreate (lpWSData : TWSAData) : integer;
    function libNetDestroy: integer;
    function GetServerPacket(hSocket: integer): string;
//    function NetBlockingHook: BOOL; export;

    procedure NetworkDisconnect(hSocket: integer);
    procedure NetStop(hSocket: integer);
    procedure CloseSockSystem(hSocket: integer; s: string);
    constructor Create;

    procedure NetError(Action: string; ErrType: integer);
    function NetStart1(ForegroundM: boolean; Server: string; ListenerPort: integer;
    var hSocket: integer): Integer; virtual;
    function BuildPar1(hSocket: integer; api, RPCVer: string; const Parameters: 
        TParams): String; virtual;
    property CountWidth: Integer read FCountWidth write FCountWidth;
    property IsBackwardsCompatible: Boolean read FIsBackwardsCompatible write 
        FIsBackwardsCompatible;
    property OldConnectionOnly: Boolean read FOldConnectionOnly write
        FOldConnectionOnly;
  end;

  TXWBThreadWinsock = class(TXWBWinsock)
  Public
    constructor Create;
  end;


function LPack(S: string; NDigits: Integer): string;

function SPack(S: string): string;

function NetBlockingHook: BOOL; export;
// 080619 function to get socket port number
function NewSocket(): Integer;

var
  HookTimeOut: Integer;
  NetCallPending: Boolean;
  NetTimerStart: TDateTime;

const
  WINSOCK1_1 = $0101;
  DHCP_NAME = 'BROKERSERVER';
  M_DEBUG = True;
  M_NORMAL = False;
  BrokerVer = '1.108';
  Buffer64K = 65520;
  Buffer32K = 32767;
  Buffer24K = 24576;
  Buffer16K = 16384;
  Buffer8K = 8192;
  Buffer4K = 4096;
  DefBuffer = 256;
  DebugOn: boolean = False;
  XWBBASEERR = {WSABASEERR + 1} 20000;

{Broker Application Error Constants}
  XWB_NO_HEAP    = XWBBASEERR + 1;
  XWB_M_REJECT   = XWBBASEERR + 2;
  XWB_BadSignOn  = XWBBASEERR + 4;
  XWB_BadReads   = XWBBASEERR + 8;
  XWB_ExeNoMem   = XWBBASEERR + 100;
  XWB_ExeNoFile  = XWB_ExeNoMem +  2;
  XWB_ExeNoPath  = XWB_ExeNoMem +  3;
  XWB_ExeShare   = XWB_ExeNoMem +  5;
  XWB_ExeSepSeg  = XWB_ExeNoMem +  6;
  XWB_ExeLoMem   = XWB_ExeNoMem +  8;
  XWB_ExeWinVer  = XWB_ExeNoMem + 10;
  XWB_ExeBadExe  = XWB_ExeNoMem + 11;
  XWB_ExeDifOS   = XWB_ExeNoMem + 12;
  XWB_RpcNotReg  = XWBBASEERR + 201;

implementation

uses 
  fDebugInfo; {P36} //, TRPCB;

    // 060919 removed to support multiple brokers with both old and new type connections
//var
//  Prefix: String;
    // 060919 end of removal
{
  function LPack
  Prepends the length of the string in NDigits characters to the value of Str

  e.g., LPack('DataValue',4)
  returns   '0009DataValue'
}
function LPack(S: string; NDigits: Integer): string;
var
  r: Integer;
  t: String;
  Width: Integer;
  Ex1: Exception;
begin
  r := Length(S);
  // check for enough space in NDigits characters
  t := IntToStr(r);
  Width := Length(t);
  if NDigits < Width then begin
    Ex1 := Exception.Create('In generation of message to server, call to LPack where Length of string of '+IntToStr(Width)+' chars exceeds number of chars for output length ('+IntToStr(NDigits)+')');
    Raise Ex1;
  end;
  t := '000000000' + IntToStr(r);               {eg 11-1-96}
  Result := Copy(t, length(t)-(NDigits-1),length(t)) + S;
end;

{
  function SPack
  Prepends the length of the string in one byte to the value of Str, thus Str must be less than 256 characters.

  e.g., SPack('DataValue')
  returns   #9 + 'DataValue'
}
function SPack(S: string): string;
var
  r: Integer;
  Ex1: Exception;
begin
  r := Length(S);
  // check for enough space in one byte
  if r > 255 then begin
    Ex1 := Exception.Create('In generation of message to server, call to SPack with Length of string of '+IntToStr(r)+' chars which exceeds max of 255 chars');
    Raise Ex1;
  end;
//  t := Byte(r);
  Result := Char(r) + S;
end;


function TXWBWinsock.libNetCreate (lpWSData : TWSAData) : integer;
begin
  Result := WSAStartup(WINSOCK1_1, lpWSData); {hard coded for Winsock version 1.1}
end;

function TXWBWinsock.libNetDestroy :integer;
begin
  WSAUnhookBlockingHook;      { -- restore the default mechanism};
  WSACleanup;                 { -- shutdown TCP API};
  Result := 1;
end;

function TXWBWinsock.libSynGetHostIP(s: string): string;
var
//   HostName: PChar;   // JLI 090804
  HostName: PAnsiChar;   // JLI 090804
  HostAddr: TSockAddr;
  TCPResult: PHostEnt;
  test: longint;
  ChangeCursor: Boolean;
begin
  { -- set up a hook for blocking calls so there is no automatic DoEvents
       in the background }
  xFlush := False;
  NetTimerStart := Now;
  NetCallPending := True;
  HookTimeOut := XHookTimeOut;
  WSASetBlockingHook(@NetBlockingHook);

  if (Screen.Cursor = crDefault) and (IsVisual) then
    ChangeCursor := True
  else
    ChangeCursor := False;


  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  HostName := StrNew(PAnsiChar(AnsiString(s)));
  test := inet_addr(HostName);
  if test > INADDR_ANY then begin
    Result := s;
    StrDispose(Hostname);
    if ChangeCursor then
      Screen.Cursor := crDefault;
    Exit;
  end;

  try
    TCPResult := gethostbyname(HostName);
    if TCPResult = nil then begin
      if ChangeCursor then
        Screen.Cursor := crDefault;
      WSAUnhookBlockingHook;
      Result := '';
      StrDispose(HostName);
      Exit;
    end;

    HostAddr.sin_addr.S_addr := longint(plongint(TCPResult^.h_addr_list^)^);

  except on EInvalidPointer do begin
      Result := '';
      if IsVisual then Screen.Cursor := crDefault;
      StrDispose(HostName);
      exit;
    end;
  end;
  if ChangeCursor then
    Screen.Cursor := crDefault;
  WSAUnhookBlockingHook;
  Result := string(inet_ntoa(HostAddr.sin_addr));
  StrDispose(HostName);
end;

function TXWBWinsock.cRight;
var
  i, t: longint;
begin
  t := strlen(z);
  if n < t then begin
    for i := 0 to n do
      z[i] := z[t-n+i];
    z[n] := chr(0);
  end;
  cRight := z;
end;

function TXWBWinsock.cLeft;
var
  t: longint;
begin
  t := strlen(z);
  if n > t then n := t;
  z[n] := chr(0);
  cLeft := z;
end;

function TXWBWinsock.BuildApi ( n,p: string; f: longint): string;
var
  x, s: string;
begin
  //str(f,x);xe3
  x := IntToStr(f);
  s := StrPack(p,5);
  result := StrPack(x + n + '^' + s,5);
end;

function TXWBWinsock.NetworkConnect(ForegroundM: boolean; Server: string; ListenerPort, TimeOut: integer): Integer;
var
  status: integer;
  hSocket: integer;
  BrokerError: EBrokerError;
begin
  Prefix := '[XWB]';
  IsNewStyle := true;
  xFlush := False;
  IsConnected := False;
  XHookTimeOut := TimeOut;
  if not OldConnectionOnly then begin
    try
      status := NetStart(ForeGroundM, server, ListenerPort, hSocket);
    except
      on E: EBrokerError do begin
        if IsBackwardsCompatible then begin // remove DSM specific error message, and just go with any error
          status := NetStart1(ForeGroundM, server, ListenerPort, hSocket);
        end else if ((Pos('connection lost',E.Message) > 0) or //  DSM
                    ((Pos('recv',E.Message) > 0) and (Pos('WSAECONNRESET',E.Message) > 0))) then begin // Cache
          BrokerError := EBrokerError.Create('Broker requires a UCX or single connection protocol and this port uses the callback protocol.'+'  The application is specified to be non-backwards compatible.  Installing patch XWB*1.1*35 and activating this port number for UCX connections will correct the problem.');
          raise BrokerError;
        end else begin
          raise;
        end;
      end;
    end;
  end else begin // OldConnectionOnly
    status := NetStart1(ForeGroundM, server, ListenerPort, hSocket);
  end;

  if status = 0 then IsConnected := True;
  Result := hSocket;                  {return the newly established socket}
end;

procedure TXWBWinsock.NetworkDisconnect(hSocket: integer);
begin
  xFlush := False;
  if IsConnected then begin
    try
      NetStop(hSocket);
    except 
      on EBrokerError do begin
        SocketError := WSAUnhookBlockingHook;     { -- rest deflt mechanism}
        SocketError := WSACleanup;                { -- shutdown TCP API}
      end;
    end;
  end;
end;

function TXWBWinsock.BuildHdr ( wkid: string; winh: string; prch: string; wish: string): string;
var
  t: string;
begin
  t := wkid + ';' + winh + ';' + prch + ';' + wish + ';';
  Result := StrPack(t,3);
end;

function TXWBWinsock.BuildPar(hSocket: integer; api, RPCVer: string;
         const Parameters: TParams): string;
var
  i, ParamCount: integer;
  param: string;
  tResult: string;
  subscript: string;
  IsSeen: Boolean;
  BrokerError: EBrokerError;
  S: string;
begin
  param := '5';
  if Parameters = nil then ParamCount := 0
  else ParamCount := Parameters.Count;
  for i := 0 to ParamCount - 1 do
  begin
    if Parameters[i].PType <> undefined then
    begin
       // Make sure that new parameter types are only used with non-callback server.
      if IsBackwardsCompatible and ((Parameters[i].PType = global) or (Parameters[i].PType = empty) or (Parameters[i].PType = stream)) then
      begin
        if Parameters[i].PType = global then
          S := 'global'
        else if Parameters[i].PType = empty then
          S := 'empty'
        else
          S := 'stream';
        BrokerError := EBrokerError.Create('Use of ' + S + ' parameter type requires setting the TRPCBroker IsBackwardsCompatible property to FALSE');
        raise BrokerError;
      end;
      with Parameters[i] do
      begin
//        if PType= null then
//          param:='';

        if PType = literal then
          param := param + '0'+LPack(Value,CountWidth)+'f';      // 030107 new message protocol

        if PType = reference then
          param := param + '1'+LPack(Value,CountWidth)+'f';     // 030107 new message protocol

        if PType = empty then
          param := param + '4f';

        if (PType = list) or (PType = global) then
        begin
          if PType = list then      // 030107 new message protocol
            param := param + '2'
          else
            param := param + '3';
          IsSeen := False;
          subscript := Mult.First;
          while subscript <> '' do
          begin
            if IsSeen then
              param := param + 't';
            if Mult[subscript] = '' then
              Mult[subscript] := #1;
            param := param + LPack(subscript,CountWidth)+LPack(Mult[subscript],CountWidth);
            IsSeen := True;
            subscript := Mult.Order(subscript,1);
          end;  // while subscript <> ''
          if not IsSeen then         // 040922 added to take care of list/global parameters with no values
            param := param + LPack('',CountWidth);
          param := param + 'f';
        end;
        if PType = stream then
        begin
          param := param + '5' + LPack(Value,CountWidth) + 'f';
        end;
      end;  // with Parameters[i] do
    end;  // if Parameters[i].PType <> undefined
  end; // for i := 0
  if param = '5' then
    param := param + '4f';

  tresult := Prefix + '11' + IntToStr(CountWidth) + '0' + '2' + SPack(RPCVer) + SPack(api) + param + #4;

//  Application.ProcessMessages;  // removed 040716 jli not needed and may impact some programs

  Result := tresult;
end;
{                   // previous message protocol
  sin := TStringList.Create;
  sin.clear;
  x := '';
  param := '';
  arr := 0;
  if Parameters = nil then ParamCount := 0
  else ParamCount := Parameters.Count;
  for i := 0 to ParamCount - 1 do
    if Parameters[i].PType <> undefined then begin
      with Parameters[i] do begin

//        if PType= null then
//          param:='';

        if PType = literal then
          param := param + strpack('0' + Value,3);
        if PType = reference then
          param := param + strpack('1' + Value,3);
        if (PType = list) or (PType = global) then begin
          Value := '.x';
          param := param + strpack('2' + Value,3);
          if Pos('.',Value) >0 then
            x := Copy(Value,2,length(Value));
//            if PType = wordproc then dec(last);
            subscript := Mult.First;
            while subscript <> '' do begin
              if Mult[subscript] = '' then Mult[subscript] := #1;
              sin.Add(StrPack(subscript,3) + StrPack(Mult[subscript],3));
              subscript := Mult.Order(subscript,1);
            end;  // while
            sin.Add('000');
            arr := 1;
        end;  // if
      end;  // with
    end;  // if

param := Copy(param,1,Length(param));
tsize := 0;

tResult := '';
tout := '';

hdr := BuildHdr('XWB','','','');
strout := strpack(hdr + BuildApi(api,param,arr),5);
num :=0;

RPCVersion := '';
RPCVersion := VarPack(RPCVer);

if sin.Count-1 > 0 then num := sin.Count-1;

if num > 0 then
   begin
        for i := 0 to num do
          tsize := tsize + length(sin.strings[i]);
        x := '00000' + IntToStr(tsize + length(strout)+ length(RPCVersion));
   end;
if num = 0 then
   begin
        x := '00000' + IntToStr(length(strout)+ length(RPCVersion));
   end;

psize := x;
psize := Copy(psize,length(psize)-5,5);
tResult := psize;
tResult := ConCat(tResult, RPCVersion);
tout := strout;
tResult := ConCat(tResult, tout);

if num > 0 then
   begin
        for i := 0 to num do
            tResult := ConCat(tResult, sin.strings[i]);
   end;

sin.free;

frmBrokerExample.Edit1.Text := tResult;

Result := tResult;  // return result
end;
}

function TXWBWinsock.StrPack(n: string; p: integer): String;
var
  s, l: integer;
  t, x, zero, y: string;
begin
  s := Length(n);
  zero := StringOfChar('0', p);
  x := IntToStr(s);
  
//    s := Length(n);
//    fillchar(zero,p+1, '0');
//    SetLength(zero, p);
//    str(s,x);
  t := zero + x;
  l := length(x)+1;
  y := Copy(t, l , p);
  y := y + n;
  Result := y;
end;

function TXWBWinsock.VarPack(n: string): string;
var
  s: integer;
begin
  if n = '' then
    n := '0';
  s := Length(n);
  SetLength(Result, s+2);
  Result := '|' + chr(s) + n;
end;

const
  OneSecond = 0.000011574;

function NetBlockingHook: BOOL;
var
  TimeOut: double;
     //TimeOut = 30 * OneSecond;

begin
  if HookTimeOut > 0 then
    TimeOut := HookTimeOut * OneSecond
  else
    TimeOut := OneSecond / 20;
  Result := False;
  if NetCallPending then
    if Now > (NetTimerStart + TimeOut) then WSACancelBlockingCall;
end;

function TXWBWinsock.NetCall(hSocket: integer; imsg: String): PChar; // JLI 090805
var
//  I: Integer;
//  BufSend, BufRecv, BufPtr: PChar;
  BufSend, BufRecv, BufPtr: PAnsiChar;
  sBuf: string;
  OldTimeOut: integer;
  BytesRead, BytesLeft, BytesTotal: longint;
  TryNumber: Integer;
  BadXfer: Boolean;
  xString: String;
begin

  { -- clear receive buffer prior to sending rpc }
  if xFlush = True then begin
    OldTimeOut := HookTimeOut;
    HookTimeOut := 0;
    WSASetBlockingHook(@NetBlockingHook);
    NetCallPending := True;
    BufRecv := PAnsiChar(StrAlloc(Buffer32k));
    NetTimerStart := Now;
    BytesRead := recv(hSocket, BufRecv^, Buffer32k, 0);
    if BytesRead > 0 then
      while BufRecv[BytesRead-1] <> #4 do begin
        BytesRead := recv(hSocket, BufRecv^, Buffer32k, 0);
      end;
    StrDispose(BufRecv);
    xFlush := False;
    //Buf := nil;    //P14
    HookTimeOut := OldTimeOut;
  end;
  { -- provide variables for blocking hook }

  TryNumber := 0;
  BadXfer := True;


  { -- send message length + message to server }

//  BufRecv := StrAlloc(Buffer32k);  // JLI 090805
  BufRecv := PAnsiChar(StrAlloc(Buffer32k));
  try    // BufRecv
//    if Prefix = '[XWB]' then
//      BufSend := StrNew(PChar({Prefix +} imsg))  //;     //moved in P14
//      BufSend := StrNew(PAnsiChar({Prefix +} imsg))  //;     //moved in P14
      BufSend := StrNew(PAnsiChar(AnsiString(imsg)));
    try  // BufSend
      Result := PChar('');
      while BadXfer and (TryNumber < 4) do
      begin
        NetCallPending := True;
        NetTimerStart := Now;
        TryNumber := TryNumber + 1;
        BadXfer := False;
//        SocketError := send(hSocket, BufSend^, StrLen(BufSend), 0);
        SocketError := send(hSocket, BufSend^,StrLen(BufSend),0);
        if SocketError = SOCKET_ERROR then
          NetError('send', 0);
        BufRecv[0] := #0;
        try
          BufPtr := BufRecv;
          BytesLeft := Buffer32k;
          BytesTotal := 0;

          {Get Security and Application packets}
          SecuritySegment := GetServerPacket(hSocket);
          ApplicationSegment := GetServerPacket(hSocket);
          sBuf := '';
          { -- loop reading TCP buffer until server is finished sending reply }

          repeat
            BytesRead := recv(hSocket, BufPtr^, BytesLeft, 0);

            if BytesRead > 0 then begin
              if BufPtr[BytesRead-1] = #4 then begin
//                sBuf := ConCat(sBuf, BufPtr);xe3
                sBuf := sBuf + string(BufPtr);
              end else begin
                BufPtr[BytesRead] := #0;
//                sBuf := ConCat(sBuf, BufPtr);
                sBuf := sBuf + string(BufPtr);
              end;
              Inc(BytesTotal, BytesRead);
            end;

            if BytesRead <= 0 then begin
              if BytesRead = SOCKET_ERROR then
                NetError('recv', 0)
              else
                NetError('connection lost', 0);
              break;
            end;
          until BufPtr[BytesRead-1] = #4;
          sBuf := Copy(sBuf, 1, BytesTotal - 1);
  {
          StrDispose(BufRecv);
          BufRecv := StrAlloc(BytesTotal+1);   // cause of many memory leaks
          StrCopy(BufRecv, PChar(sBuf));
          Result := BufRecv;
  }
          Result := StrAlloc(BytesTotal+1);
          StrCopy(Result, PChar(sBuf));
          if ApplicationSegment = 'U411' then
            BadXfer := True;
          NetCallPending := False;
        finally
          sBuf := '';
        end;
      end;
    finally     // BufSend
      StrDispose(BufSend);
    end;

    if BadXfer then
    begin
//      StrDispose(BufRecv);
      NetError(StrPas('Repeated Incomplete Reads on the server'), XWB_BadReads);
      Result := StrNew('');
    end;

    { -- if there was on error on the server, display the error code }

    if AnsiChar(Result[0]) = #24 then
    begin
//      xString := StrPas(@Result[1]);     // JLI 090804
      xString := String(Result);           // JLI 090804
      xString := Copy(xString,2,Length(xString)); // JLI 090804
//      StrDispose(BufRecv);
      NetError(xString, XWB_M_REJECT);
  //    NetCall := #0;
      Result := StrNew('');
    end;
  finally
    StrDispose(BufRecv);
  end;
end;

function TXWBWinsock.tCall(hSocket: integer; api, apVer: String; Parameters: TParams;
         var Sec , App: PChar; TimeOut: integer ): PChar;
var
  tmp: string;
  ChangeCursor: Boolean;
begin
  HookTimeOut := TimeOut;
  if (IsVisual) and (string(Api) <> 'XWB IM HERE') and (Screen.Cursor = crDefault) then
    ChangeCursor  := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass;  //P6

  if Prefix = '[XWB]' then
    tmp := BuildPar(hSocket, api, apVer, Parameters)
  else
    tmp := BuildPar1(hSocket, api, apVer, Parameters);

  //     xFlush := True;     // Have it clear input buffers prior to call
  Result := NetCall(hSocket, tmp);
  StrPCopy(Sec, SecuritySegment);
  StrPCopy(App, ApplicationSegment);
  if ChangeCursor then
    Screen.Cursor := crDefault;
end;


function TXWBWinsock.NetStart (ForegroundM: boolean; Server: string;
                   ListenerPort: integer; var hSocket: integer): integer;
var
  WinSockData: TWSADATA;
  LocalHost, DHCPHost: TSockAddr;
  LocalName, workstation, pDHCPName: string;
  y, tmp, upArrow, rAccept, rLost: string;
  tmpPchar: PChar;
//  pLocalname: array [0..255] of char;  // JLI 090804
  pLocalname: array [0..255] of AnsiChar;  // JLI 090804
  r: integer;
  HostBuf,DHCPBuf: PHostEnt;
  lin: TLinger;
//  s_lin: array [0..3] of char absolute lin;  // JLI 090804
  s_lin: array [0..3] of AnsiChar absolute lin;  // JLI 090804
  ChangeCursor: Boolean;
//  IntegerVal: Integer;
//  AnsiServer: AnsiString;
//  LengthCount: Integer;
begin
{ ForegroundM is a boolean value, TRUE means the M handling process is
  running interactively a pointer rather than passing address length
  by value) }

  { -- initialize Windows Sockets API for this task }
  if (Screen.Cursor = crDefault) and (IsVisual) then
    ChangeCursor := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  upArrow := string('^');
  rAccept := string('accept');
  rLost := string('(connection lost)');

  SocketError := WSAStartup(WINSOCK1_1, WinSockData);
  if SocketError > 0 then
    NetError( 'WSAStartup',0);

  { -- set up a hook for blocking calls so there is no automatic DoEvents
   in the background }
  NetCallPending := False;
  if ForeGroundM = False then if WSASetBlockingHook(@NetBlockingHook) = nil
     then NetError('WSASetBlockingHook',0);

  { -- establish HostEnt and Address structure for local machine}
  SocketError := gethostname(pLocalName, 255); { -- name of local system}
  if SocketError > 0 Then
     NetError ('gethostname (local)',0);
  HostBuf := gethostbyname(pLocalName); { -- info for local name}
  if HostBuf = nil Then
     NetError( 'gethostbyname',0);
  LocalHost.sin_addr.S_addr := longint(plongint(HostBuf^.h_addr_list^)^);
  LocalName := string(inet_ntoa(LocalHost.sin_addr));
  workstation := string(HostBuf.h_name);

    { -- establish HostEnt and Address structure for remote machine }
//    if inet_addr(PChar(Server)) <> longint(INADDR_NONE) then   // JLI 090804
  if inet_addr(PAnsiChar(AnsiString(Server))) <> longint(INADDR_NONE) then  // debug JLI 090805
  begin
    DHCPHost.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Server)));
    DHCPBuf := gethostbyaddr(@DHCPHost.sin_addr.S_addr,sizeof(DHCPHost),PF_INET);
  end else
  //        DHCPBuf := gethostbyname(PChar(Server)); { --  info for DHCP system}  // JLI 090804
    DHCPBuf := gethostbyname(PAnsiChar(AnsiString(Server))); { --  info for DHCP system}  // JLI 090804


  if DHCPBuf = nil then begin
      { modification to take care of problems with 10-dot addresses that weren't registered - solution found by Shawn Hardenbrook }
  //            NetError ('Error Identifying Remote Host ' + Server,0);
  //            NetStart := 10001;
  //            exit;
  //      DHCPHost.sin_addr.S_addr := inet_addr(PChar(Server));  // JLI 090804
    DHCPHost.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Server)));  // JLI 090804
    pDHCPName := 'UNKNOWN';
  end else begin
    DHCPHost.sin_addr.S_addr := longint(plongint(DHCPBuf^.h_addr_list^)^);
    pDHCPName := string(inet_ntoa(DHCPHost.sin_addr));
  end;
  DHCPHost.sin_family := PF_INET;                 { -- internet address type}
  DHCPHost.sin_port := htons(ListenerPort);        { -- port to connect to}

  { -- make connection to DHCP }
  hSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  if hSocket = INVALID_SOCKET then
    NetError( 'socket',0);

  SocketError := connect(hSocket, DHCPHost, SizeOf(DHCPHost));
  if SocketError = SOCKET_ERROR then
    NetError( 'connect',0);
  HookTimeOut := 30;

       { -- remove setup of hSocketListen

//    establish local IP now that connection is done
    AddrLen := SizeOf(LocalHost);
    SocketError := getsockname(hSocket, LocalHost, AddrLen);
    if SocketError = SOCKET_ERROR then
       NetError ('getsockname',0);
    LocalName := inet_ntoa(LocalHost.sin_addr);

//   -- set up listening socket for DHCP return connect
    hSocketListen := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP); // --  new socket
    if hSocketListen = INVALID_SOCKET Then
      NetError ('socket (listening)',0);

    LocalHost.sin_family := PF_INET;            // -- internet address type
    LocalHost.sin_port := 0;                    // -- local listening port
    SocketError := bind(hSocketListen, LocalHost,
                SizeOf(LocalHost)); // -- bind socket to address
    if SocketError = SOCKET_ERROR Then
      NetError( 'bind',0);

    AddrLen := sizeof(LocalHost);
    SocketError := getsockname(hSocketListen, LocalHost,
                AddrLen);  // -- get listening port #
    if SocketError = SOCKET_ERROR Then
       NetError( 'getsockname',0);
    LocalPort := ntohs(LocalHost.sin_port);    // -- put in proper byte order

    SocketError := listen(hSocketListen, 1);   // -- put socket in listen mode
    if SocketError = SOCKET_ERROR Then
            NetError( 'listen',0);
}
    { -- send IP address + port + workstation name and wait for OK : eg 1-30-97}
{
    RPCVersion := VarPack(BrokerVer);              //   eg 11-1-96
    x := string('TCPconnect^');
    x := ConCat(x, LocalName, upArrow);            //   local ip address
    t := IntToStr(LocalPort);                         // callback port
    x := ConCat(x, t, upArrow, workstation, upArrow); // workstation name
    r := length(x) + length(RPCVersion) + 5;
    t := string('00000') + IntToStr(r);               // eg 11-1-96
    y := Copy(t, length(t)-4,length(t));
    y := ConCat(y, RPCVersion, StrPack(x,5));         // rpc version
}
    { new protocol 030107 }

//    y := '[XWB]10' +IntToStr(CountWidth)+ '0' + '4'+#$A+'TCPConnect50'+ LPack(LocalName,CountWidth)+'f0'+LPack(IntToStr(LocalPort),CountWidth)+'f0'+LPack(workstation,CountWidth)+'f'+#4;
  y := Prefix + '10' +IntToStr(CountWidth)+ '0' + '4'+#$A +'TCPConnect50'+ LPack(LocalName,CountWidth)+'f0'+LPack(IntToStr(0),CountWidth)+'f0'+LPack(workstation,CountWidth)+'f'+#4;

{  // need to remove selecting port etc from client, since it will now be handled on the server P36

    if ForeGroundM = True then
    begin
         if ChangeCursor then
           Screen.Cursor := crDefault;
         t := 'Start M job D EN^XWBTCP' + #13 + #10 + 'Addr = ' +
           LocalName + #13 + #10 + 'Port = ' + IntToStr(LocalPort);

         frmDebugInfo := TfrmDebugInfo.Create(Application.MainForm);
         try
           frmDebugInfo.lblDebugInfo.Caption := t;
           ShowApplicationAndFocusOK(Application);
           frmDebugInfo.ShowModal;
         finally
           frmDebugInfo.Free
         end;

//         ShowMessage(t);  //TODO
    end;
}  // remove debug mode from client

//    tmpPChar := NetCall(hSocket, PChar(y));                {eg 11-1-96} // JLI 090805
//    tmpPChar := NetCall(hSocket, PAnsiChar(AnsiString(y)));
  tmpPChar := NetCall(hSocket, y);
  tmp := tmpPchar;
  StrDispose(tmpPchar);
  if CompareStr(tmp, rlost) = 0 then begin
    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR then
      NetError( 'setsockopt (connect)',0);

    closesocket(hSocket);
    WSACleanup;
    Result := 10002;
    exit;
  end;
  r := CompareStr(tmp, rAccept);
  if r <> 0 then
    NetError ('NetCall',XWB_M_REJECT);
{  // JLI 021217 remove disconnect and reconnect code -- use UCX connection directly.
    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER,
                s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR Then
       NetError( 'setsockopt (connect)',0);
    SocketError := closesocket(hSocket);          { -- done with this socket
    if SocketError > 0 Then
            NetError( 'closesocket',0);

    { -- wait for connect from DHCP and accept it - (uses blocking call)
    AddrLen := SizeOf(DHCPHost);
    hSocket := accept(hSocketListen, @DHCPHost, @AddrLen);{ -- returns new socket
    if hSocket = INVALID_SOCKET Then
       begin
            NetError( 'accept',0);
       end;

    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocketListen, SOL_SOCKET, SO_LINGER,
                s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR Then
       NetError( 'setsockopt (connect)',0);

    SocketError := closesocket(hSocketListen);   // -- done with listen skt

    if SocketError > 0 Then
       begin
            NetError ('closesocket (listening)',0);
       end;
}             // JLI 12/17/02  end of section commented out

  if ChangeCursor then
    Screen.Cursor := crDefault;
  NetStart := 0;
{ -- connection established, socket handle now in:  hSocket
        ifrmWinSock.txtStatus := 'socket obtained' *** }
end;

function TXWBWinsock.NetStart1(ForegroundM: boolean; Server: string;
    ListenerPort: integer; var hSocket: integer): Integer;
var
  WinSockData: TWSADATA;
  LocalHost, DHCPHost: TSockAddr;
  LocalName, t, workstation, pDHCPName: string;
  x, y, tmp,RPCVersion, upArrow, rAccept, rLost: string;
  tmpPchar: PChar;
//  pLocalname: array [0..255] of char;  // JLI 090804
  pLocalname: array [0..255] of AnsiChar;  // JLI 090804
  LocalPort, AddrLen, hSocketListen,r: integer;
  HostBuf,DHCPBuf: PHostEnt;
  lin: TLinger;
//  s_lin: array [0..3] of char absolute lin;  // JLI 090804
  s_lin: array [0..3] of AnsiChar absolute lin;  // JLI 090804
  ChangeCursor: Boolean;
begin
  Prefix := '{XWB}';
  IsNewStyle := false;
{ ForegroundM is a boolean value, TRUE means the M handling process is
  running interactively a pointer rather than passing address length
  by value) }

    { -- initialize Windows Sockets API for this task }
  ChangeCursor := (Screen.Cursor = crDefault) and (IsVisual);
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  upArrow := string('^');
  rAccept := string('accept');
  rLost := string('(connection lost)');

  SocketError := WSAStartup(WINSOCK1_1, WinSockData);
  if SocketError >0 then
    NetError( 'WSAStartup',0);

  { -- set up a hook for blocking calls so there is no automatic DoEvents
   in the background }
  NetCallPending := False;
  if not ForeGroundM then 
    if WSASetBlockingHook(@NetBlockingHook) = nil then 
      NetError('WSASetBlockingHook',0);

  { -- establish HostEnt and Address structure for local machine}
  SocketError := gethostname(pLocalName, 255); { -- name of local system}
  if SocketError >0 then
    NetError ('gethostname (local)',0);
  HostBuf := gethostbyname(pLocalName); { -- info for local name}
  if HostBuf = nil then
    NetError( 'gethostbyname',0);
  LocalHost.sin_addr.S_addr := longint(plongint(HostBuf^.h_addr_list^)^);
  LocalName := string(inet_ntoa(LocalHost.sin_addr));
  workstation := string(HostBuf.h_name);

  { -- establish HostEnt and Address structure for remote machine }
//    if inet_addr(PChar(Server)) <> longint(INADDR_NONE) then   // JLI 090804
  if inet_addr(PAnsiChar(AnsiString(Server))) <> longint(INADDR_NONE) then begin // JLI 090804
//      DHCPHost.sin_addr.S_addr := inet_addr(PChar(Server));   // JLI 090804
    DHCPHost.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Server)));  // JLI 090804
    DHCPBuf := gethostbyaddr(@DHCPHost.sin_addr.S_addr,sizeof(DHCPHost),PF_INET);
  end else begin
//        DHCPBuf := gethostbyname(PChar(Server)); { --  info for DHCP system}  // JLI 090804
    DHCPBuf := gethostbyname(PAnsiChar(AnsiString(Server))); { --  info for DHCP system}  // JLI 090804
  end;

  if DHCPBuf = nil then begin
      { modification to take care of problems with 10-dot addresses that weren't registered - solution found by Shawn Hardenbrook }
//            NetError ('Error Identifying Remote Host ' + Server,0);
//            NetStart := 10001;
//            exit;
//      DHCPHost.sin_addr.S_addr := inet_addr(PChar(Server));  // JLI 090804
    DHCPHost.sin_addr.S_addr := inet_addr(PAnsiChar(AnsiString(Server)));  // JLI 090804
    pDHCPName := 'UNKNOWN';
  end else begin
    DHCPHost.sin_addr.S_addr := longint(plongint(DHCPBuf^.h_addr_list^)^);
    pDHCPName := string(inet_ntoa(DHCPHost.sin_addr));
  end;
  DHCPHost.sin_family := PF_INET;                 { -- internet address type}
  DHCPHost.sin_port := htons(ListenerPort);        { -- port to connect to}

  { -- make connection to DHCP }
  hSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  if hSocket = INVALID_SOCKET then
    NetError( 'socket',0);

  SocketError := connect(hSocket, DHCPHost, SizeOf(DHCPHost));
  if SocketError = SOCKET_ERROR then
    NetError( 'connect',0);

  {establish local IP now that connection is done}
  AddrLen := SizeOf(LocalHost);
  SocketError := getsockname(hSocket, LocalHost, AddrLen);
  if SocketError = SOCKET_ERROR then
    NetError ('getsockname',0);
  LocalName := string(inet_ntoa(LocalHost.sin_addr));

//    { -- set up listening socket for DHCP return connect }
  hSocketListen := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP); // --  new socket
  if hSocketListen = INVALID_SOCKET then
    NetError ('socket (listening)',0);

  LocalHost.sin_family := PF_INET;            // -- internet address type
  LocalHost.sin_port := 0;                    // -- local listening port
  SocketError := bind(hSocketListen, LocalHost, SizeOf(LocalHost)); // -- bind socket to address
  if SocketError = SOCKET_ERROR Then
    NetError( 'bind',0);

  AddrLen := sizeof(LocalHost);
  SocketError := getsockname(hSocketListen, LocalHost,
              AddrLen);  // -- get listening port #
  if SocketError = SOCKET_ERROR then
    NetError( 'getsockname',0);
  LocalPort := ntohs(LocalHost.sin_port);    // -- put in proper byte order

  SocketError := listen(hSocketListen, 1);   // -- put socket in listen mode
  if SocketError = SOCKET_ERROR then
    NetError( 'listen',0);

  { -- send IP address + port + workstation name and wait for OK : eg 1-30-97}

  RPCVersion := VarPack(BrokerVer);              //   eg 11-1-96
  x := string('TCPconnect^');
  x := ConCat(x, LocalName, upArrow);            //   local ip address
  t := IntToStr(LocalPort);                         // callback port
  x := ConCat(x, t, upArrow, workstation, upArrow); // workstation name
  r := length(x) + length(RPCVersion) + 5;
  t := string('00000') + IntToStr(r);               // eg 11-1-96
  y := Copy(t, length(t)-4,length(t));
  y := ConCat(y, RPCVersion, StrPack(x,5));         // rpc version
  y := Prefix + y;
  { new protocol 030107 }

//    y := '[XWB]10' +IntToStr(CountWidth)+ '0' + '4'+#$A+'TCPConnect50'+ LPack(LocalName,CountWidth)+'f0'+LPack(IntToStr(LocalPort),CountWidth)+'f0'+LPack(workstation,CountWidth)+'f'+#4;
//    y := '[XWB]10' +IntToStr(CountWidth)+ '0' + '4'+#$A+'TCPConnect50'+ LPack(LocalName,CountWidth)+'f0'+LPack(IntToStr(0),CountWidth)+'f0'+LPack(workstation,CountWidth)+'f'+#4;

// need to remove selecting port etc from client, since it will now be handled on the server P36

  if ForeGroundM then begin
    if ChangeCursor then
      Screen.Cursor := crDefault;
    t := 'Start M job D EN^XWBTCP' + #13 + #10 + 'Addr = ' + 
         LocalName + #13 + #10 + 'Port = ' + IntToStr(LocalPort);

    frmDebugInfo := TfrmDebugInfo.Create(Application.MainForm);
    try
      frmDebugInfo.lblDebugInfo.Caption := t;
      ShowApplicationAndFocusOK(Application);
      frmDebugInfo.ShowModal;
    finally
      frmDebugInfo.Free
    end;
//         ShowMessage(t);  //TODO
  end;
// remove debug mode from client

  tmpPChar := NetCall(hSocket, PChar(y));                {eg 11-1-96}
  tmp := tmpPchar;
  StrDispose(tmpPchar);
  if CompareStr(tmp, rlost) = 0 then begin
    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR then
      NetError( 'setsockopt (connect)',0);

    closesocket(hSocket);
    WSACleanup;
    Result := 10002;
    Exit;
  end;
  r := CompareStr(tmp, rAccept);
  if r <> 0 then
    NetError ('NetCall',XWB_M_REJECT);
// JLI 021217 remove disconnect and reconnect code -- use UCX connection directly.
  lin.l_onoff := 1;
  lin.l_linger := 0;

  SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin, sizeof(lin));
  if SocketError = SOCKET_ERROR then
    NetError( 'setsockopt (connect)',0);
  SocketError := closesocket(hSocket);          // -- done with this socket
  if SocketError > 0 then
    NetError( 'closesocket',0);

  // -- wait for connect from DHCP and accept it - (uses blocking call)
  AddrLen := SizeOf(DHCPHost);
  hSocket := accept(hSocketListen, @DHCPHost, @AddrLen); // -- returns new socket
  if hSocket = INVALID_SOCKET then
    NetError( 'accept',0);

  lin.l_onoff := 1;
  lin.l_linger := 0;

  SocketError := setsockopt(hSocketListen, SOL_SOCKET, SO_LINGER, s_lin, sizeof(lin));
  if SocketError = SOCKET_ERROR then
    NetError( 'setsockopt (connect)',0);

  SocketError := closesocket(hSocketListen);   // -- done with listen skt

  if SocketError > 0 then
    NetError ('closesocket (listening)',0);
           // JLI 12/17/02  end of section commented out

  if ChangeCursor then
    Screen.Cursor := crDefault;
  NetStart1 := 0;
{ -- connection established, socket handle now in:  hSocket
      ifrmWinSock.txtStatus := 'socket obtained' *** }
end;


procedure TXWBWinsock.NetStop(hSocket: integer);
var
  tmp: string;
  lin: TLinger;
//  s_lin: array [0..3] of char absolute lin;  // JLI 090804
  s_lin: array [0..3] of AnsiChar absolute lin;  // JLI 090804
  ChangeCursor: Boolean;
  tmpPChar: PChar;
  S: String;
  x: array [0..15] of Char;
begin
  if not IsConnected then exit;
  ChangeCursor := (Screen.Cursor = crDefault) and (IsVisual);
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  if hSocket <= 0 then begin
    if ChangeCursor then
      screen.cursor := crDefault;
    exit;
  end;

  StrPcopy(x, StrPack(StrPack('#BYE#',5),5));

  { convert to new message protocol 030107 }
  if Prefix = '[XWB]' then
    S := Prefix + '10'+IntToStr(CountWidth)+'0' +'4'+#5+'#BYE#'+#4
  else
    S := Prefix + x;
  if hSocket <> INVALID_SOCKET then begin
    tmpPChar := NetCall(hSocket,S);
    //   	  tmpPChar := NetCall(hSocket, x);
    tmp := tmpPChar;
    StrDispose(tmpPChar);
    lin.l_onoff := 1;                    { -- shut down the M handler};
    lin.l_linger := 0;

    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER,
    s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR then
      NetError( 'setsockopt (connect)',0);

    SocketError := closesocket(hSocket);  { -- close the socket}
  end;

  SocketError := WSAUnhookBlockingHook;     { -- restore the default mechanism}
  SocketError := WSACleanup;                { -- shutdown TCP API}
  if SocketError > 0 then
    NetError( 'WSACleanup',0);             { -- check blocking calls, etc.}
  if ChangeCursor then
    Screen.Cursor := crDefault;
  IsConnected := False;
end;


procedure TXWBWinsock.CloseSockSystem(hSocket: integer; s: string);
var
  lin: TLinger;
//   s_lin: array [0..3] of char absolute lin;  // JLI 090804
   s_lin: array [0..3] of AnsiChar absolute lin;  // JLI 090804
begin
  lin.l_onoff := 1;
  lin.l_linger := 0;

  SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin, sizeof(lin));
  if SocketError = SOCKET_ERROR then
    NetError( 'setsockopt (connect)',0);

  closesocket(hSocket);
  WSACleanup;
  ShowMessage(s);  //TODO
  halt(1);
end;

function TXWBWinsock.GetServerPacket(hSocket: integer): string;
var
  s, sb: PAnsiChar;
  buflen: integer;
begin
  s := AnsiStrAlloc(1);
  s[0] := #0;
  buflen := recv(hSocket, s^, 1, 0); {get length of segment}
  if buflen = SOCKET_ERROR then begin  // 040720 code added to check for the timing problem if initial attempt to read during connection fails
    sleep(100);
    buflen := recv(hSocket, s^, 1, 0);
  end;
  if buflen = SOCKET_ERROR then
    NetError( 'recv',0);
  buflen := ord(s[0]);
  sb := AnsiStrAlloc(buflen+1);
  sb[0] := #0;
  buflen := recv(hSocket, sb^, buflen, 0); {get security segment}
  if buflen = SOCKET_ERROR then
    NetError( 'recv',0);
  sb[buflen] := #0;
  Result := string(sb);
  StrDispose(sb);
  StrDispose(s);
end;

constructor TXWBWinsock.Create;
begin
  inherited;
//  NetBlockingHookVar := NetBlockingHook;
  CountWidth := 3;
  IsVisual := true; //default
end;

procedure TXWBWinsock.NetError(Action: string; ErrType: integer);
var
  x, s: string;
  r: integer;
  BrokerError: EBrokerError;
  TimeOut: Double;
begin
  if (IsVisual) then Screen.Cursor := crDefault;
  r := 0;
  if ErrType > 0 then r := ErrType;
  if ErrType = 0 then begin
    // P36
    // code added to indicate WSAETIMEDOUT error instead of WSAEINTR
    // when time out period exceeded.  WSAEINTR error is misleading
    // since the server is still active, but took too long
    if NetcallPending then begin
      if HookTimeOut > 0 then begin
        TimeOut := HookTimeOut * OneSecond;
        if Now > (NetTimerStart + TimeOut) then
          r := WSAETIMEDOUT;
      end;
    end;
    if r = 0 then
      r := WSAGetLastError;
    if (r = WSAEINTR) or (r = WSAETIMEDOUT) then xFlush := True;
    if WSAIsBlocking = True then WSACancelBlockingCall;  // JLI 021210
  end;
  case r of
    WSAEINTR           : x := 'WSAEINTR';
    WSAEBADF           : x := 'WSAEINTR';
    WSAEFAULT          : x := 'WSAEFAULT';
    WSAEINVAL          : x := 'WSAEINVAL';
    WSAEMFILE          : x := 'WSAEMFILE';
    WSAEWOULDBLOCK     : x := 'WSAEWOULDBLOCK';
    WSAEINPROGRESS     : x := 'WSAEINPROGRESS';
    WSAEALREADY        : x := 'WSAEALREADY';
    WSAENOTSOCK        : x := 'WSAENOTSOCK';
    WSAEDESTADDRREQ    : x := 'WSAEDESTADDRREQ';
    WSAEMSGSIZE        : x := 'WSAEMSGSIZE';
    WSAEPROTOTYPE      : x := 'WSAEPROTOTYPE';
    WSAENOPROTOOPT     : x := 'WSAENOPROTOOPT';
    WSAEPROTONOSUPPORT : x := 'WSAEPROTONOSUPPORT';
    WSAESOCKTNOSUPPORT : x := 'WSAESOCKTNOSUPPORT';
    WSAEOPNOTSUPP      : x := 'WSAEOPNOTSUPP';
    WSAEPFNOSUPPORT    : x := 'WSAEPFNOSUPPORT';
    WSAEAFNOSUPPORT    : x := 'WSAEAFNOSUPPORT';
    WSAEADDRINUSE      : x := 'WSAEADDRINUSE';
    WSAEADDRNOTAVAIL   : x := 'WSAEADDRNOTAVAIL';
    WSAENETDOWN        : x := 'WSAENETDOWN';
    WSAENETUNREACH     : x := 'WSAENETUNREACH';
    WSAENETRESET       : x := 'WSAENETRESET';
    WSAECONNABORTED    : x := 'WSAECONNABORTED';
    WSAECONNRESET      : x := 'WSAECONNRESET';
    WSAENOBUFS         : x := 'WSAENOBUFS';
    WSAEISCONN         : x := 'WSAEISCONN';
    WSAENOTCONN        : x := 'WSAENOTCONN';
    WSAESHUTDOWN       : x := 'WSAESHUTDOWN';
    WSAETOOMANYREFS    : x := 'WSAETOOMANYREFS';
    WSAETIMEDOUT       : x := 'WSAETIMEDOUT';
    WSAECONNREFUSED    : x := 'WSAECONNREFUSED';
    WSAELOOP           : x := 'WSAELOOP';
    WSAENAMETOOLONG    : x := 'WSAENAMETOOLONG';
    WSAEHOSTDOWN       : x := 'WSAEHOSTDOWN';
    WSAEHOSTUNREACH    : x := 'WSAEHOSTUNREACH';
    WSAENOTEMPTY       : x := 'WSAENOTEMPTY';
    WSAEPROCLIM        : x := 'WSAEPROCLIM';
    WSAEUSERS          : x := 'WSAEUSERS';
    WSAEDQUOT          : x := 'WSAEDQUOT';
    WSAESTALE          : x := 'WSAESTALE';
    WSAEREMOTE         : x := 'WSAEREMOTE';
    WSASYSNOTREADY     : x := 'WSASYSNOTREADY';
    WSAVERNOTSUPPORTED : x := 'WSAVERNOTSUPPORTED';
    WSANOTINITIALISED  : x := 'WSANOTINITIALISED';
    WSAHOST_NOT_FOUND  : x := 'WSAHOST_NOT_FOUND';
    WSATRY_AGAIN       : x := 'WSATRY_AGAIN';
    WSANO_RECOVERY     : x := 'WSANO_RECOVERY';
    WSANO_DATA         : x := 'WSANO_DATA';

    XWB_NO_HEAP        : x := 'Insufficient Heap';
    XWB_M_REJECT       : x := 'M Error - Use ^XTER';
    XWB_BadReads       : x := 'Server unable to read input data correctly.';
    XWB_BadSignOn      : x := 'Sign-on was not completed.';
    XWB_ExeNoMem       : x := 'System was out of memory, executable file was corrupt, or relocations were invalid.';
    XWB_ExeNoFile      : x := 'File was not found.';
    XWB_ExeNoPath      : x := 'Path was not found.';
    XWB_ExeShare       : x := 'Attempt was made to dynamically link to a task,' +
                              ' or there was a sharing or network-protection error.';
    XWB_ExeSepSeg      : x := 'Library required separate data segments for each task.';
    XWB_ExeLoMem       : x := 'There was insufficient memory to start the application.';
    XWB_ExeWinVer      : x := 'Windows version was incorrect.';
    XWB_ExeBadExe      : x := 'Executable file was invalid.' +
                              ' Either it was not a Windows application or there was an error in the .EXE image.';
    XWB_ExeDifOS       : x := 'Application was designed for a different operating system.';
    XWB_RpcNotReg      : X := 'Remote procedure not registered to application.';
    XWB_BldConnectList : x := 'BrokerConnections list could not be created';
    XWB_NullRpcVer     : x := 'RpcVersion cannot be empty.' + #13 + 'Default is 0 (zero).';
  else 
    x := IntToStr(r);
  end;
  s := 'Error encountered.' + chr(13)+chr(10) + 'Function was: ' + Action + chr(13)+chr(10) + 'Error was: ' + x;
  BrokerError := EBrokerError.Create(s);
  BrokerError.Action := Action;
  BrokerError.Code := r;
  BrokerError.Mnemonic := x;
  raise BrokerError;
end;

function TXWBWinsock.BuildPar1(hSocket: integer; api, RPCVer: string; const Parameters: TParams): String;
var
  i,ParamCount: integer;
  num: integer;
  tsize: longint;
  arr: LongInt;
  param,x,hdr,strout: string;
  tout,psize,tResult,RPCVersion: string;
  sin: TStringList;
  subscript: string;
begin
  sin := TStringList.Create;
  try
    sin.clear;
    x := '';
    param := '';
    arr := 0;
    if Parameters = nil then ParamCount := 0
    else ParamCount := Parameters.Count;
    for i := 0 to ParamCount - 1 do
      if Parameters[i].PType <> undefined then begin
        with Parameters[i] do begin

          {if PType= null then
            param:='';}

          if PType = literal then
            param := param + strpack('0' + Value,3);

          if PType = reference then
            param := param + strpack('1' + Value,3);

          if (PType = list) {or (PType = wordproc)} then begin
            Value := '.x';
            param := param + strpack('2' + Value,3);
            if Pos('.',Value) >0 then
              x := Copy(Value,2,length(Value));
              {if PType = wordproc then dec(last);}
              subscript := Mult.First;
              while subscript <> '' do begin
                if Mult[subscript] = '' then Mult[subscript] := #1;
                sin.Add(StrPack(subscript,3) + StrPack(Mult[subscript],3));
                subscript := Mult.Order(subscript,1);
              end{while};
              sin.Add('000');
              arr := 1;
          end{if};
        end{with};
      end{if};

    param := Copy(param,1,Length(param));
    tsize := 0;

    tResult := '';
    tout := '';

    hdr := BuildHdr('XWB','','','');
    strout := strpack(hdr + BuildApi(api,param,arr),5);
  //  num :=0;   //  JLI 040608 to correct handling of empty arrays

    RPCVersion := '';
    RPCVersion := VarPack(RPCVer);

    num := sin.Count-1;   //  JLI 040608 to correct handling of empty arrays
  //  if sin.Count-1 > 0 then num := sin.Count-1;
    

    if sin.Count > 0 then begin    //  JLI 040608 to correct handling of empty arrays
  //  if num > 0 then
      for i := 0 to num do
        tsize := tsize + length(sin.strings[i]);
      x := '00000' + IntToStr(tsize + length(strout)+ length(RPCVersion));
    end;
    if sin.Count = 0 then begin  //  JLI 040608 to correct handling of empty arrays
  //   if num = 0 then
      x := '00000' + IntToStr(length(strout)+ length(RPCVersion));
    end;

    psize := x;
    psize := Copy(psize,length(psize)-5,5);
    tResult := psize;
    tResult := ConCat(tResult, RPCVersion);
    tout := strout;
    tResult := ConCat(tResult, tout);

    if sin.Count > 0 then begin  //  JLI 040608 to correct handling of empty arrays
  //   if num > 0 then
      for i := 0 to num do
        tResult := ConCat(tResult, sin.strings[i]);
    end;

  finally
    sin.free;
  end;

  Result := Prefix + tResult;  {return result}
end;

constructor TXWBThreadWinsock.Create;
begin
 Inherited;
 IsVisual := False;
end;


function NewSocket(): Integer;
var
  WinSockData: TWSADATA;
  LocalHost: TSockAddr;
  LocalName, workstation: string;
  upArrow, rAccept, rLost: string;
  pLocalname: array [0..255] of Ansichar;
  LocalPort, AddrLen, hSocketListen: integer;
  HostBuf: PHostEnt;
  lin: TLinger;
  s_lin: array [0..3] of char absolute lin;
  ChangeCursor: Boolean;
  SocketError: Integer;
  hSocket: Integer;
begin
  { -- initialize Windows Sockets API for this task }
  ChangeCursor := (Screen.Cursor = crDefault);
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  upArrow := string('^');
  rAccept := string('accept');
  rLost := string('(connection lost)');

  SocketError := WSAStartup(WINSOCK1_1, WinSockData);
  if SocketError > 0 then
    NetError( 'WSAStartup',0);

  { -- set up a hook for blocking calls so there is no automatic DoEvents
   in the background }
  NetCallPending := False;
//  if ForeGroundM = False then if WSASetBlockingHook(@NetBlockingHook) = nil
//     then NetError('WSASetBlockingHook',0);

  { -- establish HostEnt and Address structure for local machine}
  SocketError := gethostname(pLocalName, 255); { -- name of local system}
  if SocketError >0 Then
    NetError ('gethostname (local)',0);
  HostBuf := gethostbyname(pLocalName); { -- info for local name}
  if HostBuf = nil Then
    NetError( 'gethostbyname',0);
  LocalHost.sin_addr.S_addr := longint(plongint(HostBuf^.h_addr_list^)^);
  LocalName := string(inet_ntoa(LocalHost.sin_addr));
  workstation := string(HostBuf.h_name);

  { -- make connection to DHCP }
  hSocket := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
  if hSocket = INVALID_SOCKET Then
    NetError( 'socket',0);

    {establish local IP now that connection is done}
{    AddrLen := SizeOf(LocalHost);
    SocketError := getsockname(hSocket, LocalHost, AddrLen);
    if SocketError = SOCKET_ERROR then
       NetError ('getsockname',0);
    LocalName := inet_ntoa(LocalHost.sin_addr);
}
//    { -- set up listening socket for DHCP return connect }
    hSocketListen := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP); // --  new socket
    if hSocketListen = INVALID_SOCKET Then
      NetError ('socket (listening)',0);

    LocalHost.sin_family := PF_INET;            // -- internet address type
    LocalHost.sin_port := 0;                    // -- local listening port
    SocketError := bind(hSocketListen, LocalHost, SizeOf(LocalHost)); // -- bind socket to address
    if SocketError = SOCKET_ERROR Then
      NetError( 'bind',0);

    AddrLen := sizeof(LocalHost);
    SocketError := getsockname(hSocketListen, LocalHost, AddrLen);  // -- get listening port #
    if SocketError = SOCKET_ERROR Then
       NetError( 'getsockname',0);
    LocalPort := ntohs(LocalHost.sin_port);    // -- put in proper byte order
    NewSocket := LocalPort;
{
    SocketError := listen(hSocketListen, 1);   // -- put socket in listen mode
    if SocketError = SOCKET_ERROR Then
            NetError( 'listen',0);

//         ShowMessage(t);  //TODO
    end;
  // remove debug mode from client

    tmpPChar := NetCall(hSocket, PChar(y));                {eg 11-1-96}
{    tmp := tmpPchar;
    StrDispose(tmpPchar);
    if CompareStr(tmp, rlost) = 0 then
       begin
            lin.l_onoff := 1;
            lin.l_linger := 0;

            SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER,
                        s_lin, sizeof(lin));
            if SocketError = SOCKET_ERROR Then
               NetError( 'setsockopt (connect)',0);

          closesocket(hSocket);
          WSACleanup;
          Result := 10002;
          exit;
       end;
    r := CompareStr(tmp, rAccept);
    if r <> 0 Then
       NetError ('NetCall',XWB_M_REJECT);
  // JLI 021217 remove disconnect and reconnect code -- use UCX connection directly.
    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER,
                s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR Then
       NetError( 'setsockopt (connect)',0);
    SocketError := closesocket(hSocket);          // -- done with this socket
    if SocketError > 0 Then
            NetError( 'closesocket',0);

    // -- wait for connect from DHCP and accept it - (uses blocking call)
    AddrLen := SizeOf(DHCPHost);
    hSocket := accept(hSocketListen, @DHCPHost, @AddrLen); // -- returns new socket
    if hSocket = INVALID_SOCKET Then
       begin
            NetError( 'accept',0);
       end;

    lin.l_onoff := 1;
    lin.l_linger := 0;

    SocketError := setsockopt(hSocketListen, SOL_SOCKET, SO_LINGER,
                s_lin, sizeof(lin));
    if SocketError = SOCKET_ERROR Then
       NetError( 'setsockopt (connect)',0);

    SocketError := closesocket(hSocketListen);   // -- done with listen skt

    if SocketError > 0 Then
       begin
            NetError ('closesocket (listening)',0);
       end;
             // JLI 12/17/02  end of section commented out

    if ChangeCursor then
      Screen.Cursor := crDefault;
    NetStart1 := 0;
{ -- connection established, socket handle now in:  hSocket
        ifrmWinSock.txtStatus := 'socket obtained' *** }
  if ChangeCursor then
    Screen.Cursor := crDefault;
end;

{$WARN UNSAFE_CAST ON}
{$WARN UNSAFE_CODE ON}
end.




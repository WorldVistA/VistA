{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Raul Mendoza, Joel Ivey,
  Herlan Westra, Roy Gaber, Vadim Dubinsky
  Description: Contains TRPCBroker and related components.
  Unit: Wsockc manages WinSock connections and creates/parses messages.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 04/19/2019) XWB*1.1*71
  1. Updated RPC Version to version 71.
  2. Fixed an old error surrounding boundary of 999 character
  string lengths passed to LPack, CountWidth, defined in the TXWBWinsock
  Create constructor is the determinant of the length of a string passed to
  the LPack function, being set to 3 allows for string lengths of 999,
  increasing it to 5 allows for lengths of 99999.

  Changes in v1.1.65 (HGW 06/23/2016) XWB*1.1*65
  1. Added error XWB_BadToken for SSOi testing.
  2. Replaced some AnsiString variables with String variables to resolve
  type casting warnings.

  Changes in v1.1.60 (HGW 11/19/2014) XWB*1.1*60
  1. Fixed data type for variable pLocalname
  2. Updated version 'BrokerVer'
  3. Updated error text for WinSock messages
  4. Symbol 'AnsiStrAlloc' is deprecated in Delphi XE4, moved to the AnsiStrings
  unit.
  5. Symbol 'StrDispose' is deprecated in Delphi XE4, moved to the AnsiStrings
  unit.
  6. Symbol 'StrLen' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  7. Symbol 'StrNew' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  8. Symbol 'StrPas' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  9. Upgraded from WinSock 1.1 to WinSock 2.2
  10. Removed blocking hook functions not supported in WinSock 2.2
  11. Combined redundant code in NetStart and NetStart1 into single function
  NetStart for IPv4/IPv6-dual stack connections.
  12. Added data structures and function definitions missing or incomplete for
  Delphi XE4 and XE5 implementation of WinSock 2.2 and IPv6.
  13. Wrapped a number of Windows APIs to be used with the updated data
  structures. Calling them from Delphi Winapi.Winsock2 RTL caused error for
  format of passed parameters.
  14. Made IPv6 changes in NetStart required by Microsoft:
  a. Used WSAConnectByName to establish a connection to a VistA server given
  a host name and port. IPv6 was not working with Delphi Winsock2 RTL due
  to variable type definitions. Wrapper function FWSAConnectByName created.
  b. Replaced gethostbyname function calls with calls to getaddrinfo Windows
  Sockets function. Not included in Delphi Winsock2 RTL. Wrapper function
  FGetAddrInfo created.
  15. Deprecated old-style broker which called back to client on a different
  port. VistA will continue to support the old-style broker for legacy
  applications, but it is no longer supported in new versions of the BDK.
  16. Resolved various compiler warnings regarding data type casting to
  prevent buffer overruns (potential security issue).

  Changes in v1.1.50 (JLI 6/24/2008) XWB*1.1*50
  1. Remedy ticket INC886661 fix returned error text that was illegible with
  changes to function TXWBWinsock.GetServerPacket (Remedy ticket documentation
  included in patch 60 patch description).

  Changes in v1.1.13 (JLI 8/23/2000) XWB*1.1*13
  1. Made changes to cursor dependent on current curson being crDefault so
  that the application can set it to a different cursor for long or
  repeated processes without the cursor 'flashing' repeatedly.

  Changes in v1.1.8 (REM 6/18/1999) XWB*1.1*8
  1. Update version 'BrokerVer'

  Changes in v1.1.6 (DPC 6/7/1999) XWB*1.1*6
  1. In tCall function, made changing cursor to hourglass conditional:
  don't do it if XWB IM HERE  RPC is being invoked.

  Changes in v1.1.4 (DCM 9/18/1998) XWB*1.1*4
  1. Changed the inet_addr line in NetStart to longint. Reason: true 64 bit
  types in Delphi 4
  2. Changed the hSocket line in NetStart to @. Reason: incompatible types
  when recompiling
  3. In NetStop, if socket <= 0, restore the default cursor. Reason: gave the
  impression of a busy process after the Kernel login process times out.
  ************************************************** }

unit Wsockc;
{ *******************************************************************
  This implementation allows communications between Delphi forms and
  VistA servers through the use of the VistA RPC Broker.

  Usage: Put Wsockc in your Uses clause of your Delphi form.  See additional
  specs for RPC Broker message formats.
  Programmer: Enrique Gomez - VA San Francisco ISC - April 1995
  ******************************************************************* }

// p60 - Explicitly define minimum Windows version, required by Windows API getaddrinfo
{$DEFINE MINWINXP}

interface

uses
  {System}
  AnsiStrings, SysUtils, Classes, StrUtils,
  {WinApi}
  Windows, WinTypes, WinProcs, WinSock2,
  // p60 Upgraded from WinSock 1.1 to WinSock 2.2
  {VA}
  XWBut1, Trpcb, RpcbErr,
  {Vcl}
  Vcl.Dialogs, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ClipBrd;

const
  OneSecond = 0.000011574;
  WS2_32_LIB = 'ws2_32.dll'; // Windows Winsock 2.2 API source
  WinSockVer = $0202; // WinSock Version = 2.2
  AI_PASSIVE = $00000001; // Socket address will be used in bind() call
  AI_CANONNAME = $00000002; // Return canonical name in first ai_canonname
  AI_NUMERICHOST = $00000004; // Nodename must be a numeric address string
  AI_NUMERICSERV = $00000008; // Servicename must be a numeric port number
  AI_ALL = $00000100; // Query both IPv6 and IPv4 with AI_V4MAPPED
  AI_FQDN = $00020000; // Return the FQDN in ai_canonname
  AF_UNSPEC = 0; // IP version unspecified
  AF_INET = 2; // IPv4
  AF_INET6 = 23; // IPv6
  PF_INET = AF_INET; // IPv4 protocol
  PF_INET6 = AF_INET6; // IPv6 protocol
  IPV6_V6ONLY = 27; // Used to setsockopt for IPv4/IPv6 dual-stack
  DHCP_NAME = 'BROKERSERVER';
  M_DEBUG = True;
  M_NORMAL = False;
  BrokerVer = '1.160';
  Buffer64K = 65520;
  Buffer32K = 32767;
  Buffer24K = 24576;
  Buffer16K = 16384;
  Buffer8K = 8192;
  Buffer4K = 4096;
  DefBuffer = 256;
  DebugOn: boolean = False;
  XWBBASEERR = { WSABASEERR + 1 } 20000;
  // Broker Application Error Constants
  XWB_NO_HEAP = XWBBASEERR + 1;
  XWB_M_REJECT = XWBBASEERR + 2;
  XWB_BadSignOn = XWBBASEERR + 4;
  XWB_BadReads = XWBBASEERR + 8;
  XWB_ExeNoMem = XWBBASEERR + 100;
  XWB_ExeNoFile = XWB_ExeNoMem + 2;
  XWB_ExeNoPath = XWB_ExeNoMem + 3;
  XWB_ExeShare = XWB_ExeNoMem + 5;
  XWB_ExeSepSeg = XWB_ExeNoMem + 6;
  XWB_ExeLoMem = XWB_ExeNoMem + 8;
  XWB_ExeWinVer = XWB_ExeNoMem + 10;
  XWB_ExeBadExe = XWB_ExeNoMem + 11;
  XWB_ExeDifOS = XWB_ExeNoMem + 12;
  XWB_RpcNotReg = XWBBASEERR + 201;

type
  // WinSock2 IPv4/IPv6 data types that are inadequately or incompletely
  // defined in Delphi XE4 and XE5 Winapi.Winsock2 Run Time Library.
  TSocket = Cardinal;

  in6_addr = record // in6_addr (IPv6)
    case Byte of
      0:
        (u6_addr8: array [0 .. 15] of Byte);
      1:
        (u6_addr16: array [0 .. 7] of Word);
  end;

  TIn6_Addr = in6_addr;
  PIn6_Addr = ^in6_addr;

  // Structured type definition sockaddr storage for IPv4 or IPv6
  SockAddr = record
    case u_short of // u_short is a Word boundary (2-byte integer SmallInt)
      0:
        (sa_family: u_short; // generic sockaddr structure
          sa_data: array [0 .. 13] of AnsiChar);
      1:
        (sin_family: short; // IPv4 sockaddr_in structure
          sin_port: u_short;
          sin_addr: in_addr;
          sin_zero: array [0 .. 7] of AnsiChar);
      2:
        (sin6_family: short; // IPv6 sockaddr_in6 structure
          sin6_port: u_short;
          sin6_flowinfo: u_long;
          sin6_addr: in6_addr;
          sin6_scope_id: u_long);
  end;

  TSockAddr = SockAddr;
  PSockAddr = ^TSockAddr;
  LPSOCKADDR = ^TSockAddr;
  PAddrInfo = ^TAddrInfo; // to support function FGetAddrInfo

  TAddrInfo = record
    ai_flags: Integer;
    ai_family: Integer;
    ai_socktype: Integer;
    ai_protocol: Integer;
    ai_addrlen: Cardinal;
    AI_CANONNAME: PAnsiChar;
    ai_addr: PSockAddr;
    ai_next: PAddrInfo;
  end;

  TXWBWinsock = class(TObject)
  private
    FCountWidth: Integer;
  public
    XNetCallPending: boolean;
    xFlush: boolean;
    SocketError: Integer;
    XHookTimeOut: Integer;
    XNetTimerStart: TDateTime;
    BROKERSERVER: String;
    SecuritySegment: String;
    ApplicationSegment: String;
    IsConnected: boolean;
    IPprotocol: Integer; // p65 - IPv4=4, IPv6=6, default=0
    function NetCall(hSocket: TSocket; imsg: String): PChar;
    function tCall(hSocket: TSocket; api, apVer: String; Parameters: TParams;
      var Sec, App: PChar; TimeOut: Integer): PChar;
    function cRight(z: PChar; n: longint): PChar;
    function cLeft(z: PChar; n: longint): PChar;
    function BuildApi(n, p: string; f: longint): string;
    function BuildHdr(wkid: string; winh: string; prch: string;
      wish: string): string;
    function BuildPar(hSocket: TSocket; api, RPCVer: string;
      const Parameters: TParams): string;
    function StrPack(n: string; p: Integer): string;
    function VarPack(n: string): string;
    function NetStart(ForegroundM: boolean; Server: string;
      ListenerPort: Integer; var hSocket: TSocket): Integer;
    function NetworkConnect(ForegroundM: boolean; Server: string;
      ListenerPort, TimeOut: Integer): Integer;
    function libNetCreate(lpWSData: TWSAData): Integer;
    function libNetDestroy: Integer;
    function GetServerPacket(hSocket: TSocket): string;
    procedure NetworkDisconnect(hSocket: TSocket);
    procedure NetStop(hSocket: TSocket);
    procedure CloseSockSystem(hSocket: TSocket; s: string);
    procedure NetError(Action: string; ErrType: Integer);
    constructor Create;
    destructor Destroy; override;
    property CountWidth: Integer read FCountWidth write FCountWidth;
  end;

function LPack(Str: String; NDigits: Integer): String;
function SPack(Str: String): String;
function FAddrToString(Addr: TSockAddr): String;
function FGetAddrInfo(nodename, servname: PAnsiChar; phints: PAddrInfo;
  out res: PAddrInfo): Integer; stdcall; external WS2_32_LIB name 'getaddrinfo';
// p60 Windows function wrapper
function FWSAConnectByName(const s: TSocket; nodename, ServiceName: PAnsiChar;
  var LocalAddressLength: Cardinal; var LocalAddress: TSockAddr;
  var RemoteAddressLength: Cardinal; var RemoteAddress: TSockAddr;
  const TimeOut: timeval; Reserved: LPWSAOVERLAPPED): LongBool; stdcall;
  external WS2_32_LIB name 'WSAConnectByNameA'; // p60 Windows function wrapper
function Fconnect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;
  stdcall; external WS2_32_LIB name 'connect'; // p60 Windows function wrapper
function Fgetsockname(s: TSocket; var name: TSockAddr; var namelen: Integer)
  : Integer; stdcall; external WS2_32_LIB name 'getsockname';
// p60 Windows function wrapper
function Fbind(s: TSocket; var name: TSockAddr; namelen: Integer): Integer;
  stdcall; external WS2_32_LIB name 'bind'; // p60 Windows function wrapper

var
  HookTimeOut: Integer;
  NetCallPending: boolean;
  NetTimerStart: TDateTime;

implementation

uses
  {VA}
  fDebugInfo;

{ -----------------------LPack ---------------------------------
  ---------------------------------------------------------------- }
function LPack(Str: String; NDigits: Integer): String;
var
  r: Integer;
  t: String;
  Width: Integer;
  Ex1: Exception;
begin
  r := Length(Str);
  // check for enough space in NDigits characters
  t := IntToStr(r);
  Width := Length(t);
  if NDigits < Width then
  begin
    Ex1 := Exception.Create
      ('In generation of message to server, call to LPack where Length of string of '
      + IntToStr(Width) + ' chars exceeds number of chars for output length (' +
      IntToStr(NDigits) + ')');
    Raise Ex1;
  end; // if
  t := '000000000' + IntToStr(r); { eg 11-1-96 }
  Result := Copy(t, Length(t) - (NDigits - 1), Length(t)) + Str;
end; // function LPack

{ ----------------------- SPack ---------------------------------
  Prepends the length of the string in one byte to the value of Str,
  thus Str must be less than 256 characters.
  e.g., SPack('DataValue')
  returns   #9 + 'DataValue'
  ---------------------------------------------------------------- }
function SPack(Str: String): String;
var
  r: Integer;
  Ex1: Exception;
begin
  r := Length(Str);
  // check for enough space in one byte
  if r > 255 then
  begin
    Ex1 := Exception.Create
      ('In generation of message to server, call to SPack with Length of string of '
      + IntToStr(r) + ' chars which exceeds max of 255 chars');
    Raise Ex1;
  end; // if
  Result := Char(r) + Str;
end; // function SPack

{ ----------------------- FAddrToString -------------------------
  Take IP address in TSockAddr structure and return IPv4 or IPv6
  address in string format.
  ---------------------------------------------------------------- }
function FAddrToString(Addr: TSockAddr): String;
var
  Str: String;
  I: Integer;
begin
  Str := '';
  if Addr.sa_family = AF_INET6 then // address is IPv6
  begin
    for I := 0 to 15 do
    begin
      Str := Str + IntToHex(Addr.sin6_addr.u6_addr8[I], 2);
      if (Frac(I / 2) > 0) and (I < 15) then
        Str := Str + ':';
    end;
    // if IPv6 string is IPv4-mapped then set string to dotted decimal IPv4
    if AnsiCompareText(AnsiLeftStr(Str, 29), '0000:0000:0000:0000:0000:FFFF') = 0
    then
    begin
      Str := '';
      for I := 12 to 15 do
      begin
        Str := Str + IntToStr(Addr.sin6_addr.u6_addr8[I]);
        if I < 15 then
          Str := Str + '.';
      end;
    end; // if address is IPv4-mapped
  end // if address is IPv6
  else // if address is IPv4
  begin
    Str := IntToStr(Addr.sin_addr.S_un_b.s_b1) + '.' +
      IntToStr(Addr.sin_addr.S_un_b.s_b2) + '.' +
      IntToStr(Addr.sin_addr.S_un_b.s_b3) + '.' +
      IntToStr(Addr.sin_addr.S_un_b.s_b4);
  end; // if address is IPv4
  Result := Str;
end; // function FAddrToString

{ ----------------------- TXWBWinsock.libNetCreate --------------
  ---------------------------------------------------------------- }
function TXWBWinsock.libNetCreate(lpWSData: TWSAData): Integer;
begin
  Result := WSAStartup(WinSockVer, lpWSData);
end; // function TXWBWinsock.libNetCreat

{ ----------------------- TXWBWinsock.libNetDestroy -------------
  ---------------------------------------------------------------- }
function TXWBWinsock.libNetDestroy: Integer;
begin
  WSACleanup; { -- shutdown TCP API };
  Result := 1;
end; // TXWBWinsock.libNetDestroy

{ ----------------------- TXWBWinsock.cRight --------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.cRight;
var
  I, t: longint;
begin
  t := strlen(z);
  if n < t then
  begin
    for I := 0 to n do
      z[I] := z[t - n + I];
    z[n] := chr(0);
  end; // if
  cRight := z;
end; // function TXWBWinsock.cRight

{ ----------------------- TXWBWinsock.cLeft ---------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.cLeft;
var
  t: longint;
begin
  t := strlen(z);
  if n > t then
    n := t;
  z[n] := chr(0);
  cLeft := z;
end; // function TXBWinsock.cLeft

{ ----------------------- TXWBWinsock.BuildApi ------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.BuildApi(n, p: String; f: longint): String;
var
  x, s: String;
begin
  x := IntToStr(f);
  s := StrPack(p, 5);
  Result := StrPack(x + n + '^' + s, 5);
end; // function TXWBWinsock.BuildApi

{ ----------------------- TXWBWinsock.NetworkConnect ------------
  ---------------------------------------------------------------- }
function TXWBWinsock.NetworkConnect(ForegroundM: boolean; Server: string;
  ListenerPort, TimeOut: Integer): Integer;
var
  status: Integer;
  hSocket: TSocket;
begin
  xFlush := False;
  IsConnected := False;
  XHookTimeOut := TimeOut;
  try
    begin
      // TODO - Implement native SSL/TLS using Windows SChannel in Wsockc.NetStart
      status := NetStart(ForegroundM, Server, ListenerPort, hSocket);
    end; // try
  except
    on E: EBrokerError do
    begin
      raise;
    end // do
  end; // except
  if status = 0 then
    IsConnected := True;
  Result := hSocket; // return the newly established socket
end; // function TXWBWinsock.NetworkConnect

{ ----------------------- TXWBWinsock.NetworkDisconnect ---------
  ---------------------------------------------------------------- }
procedure TXWBWinsock.NetworkDisconnect(hSocket: TSocket);
begin
  xFlush := False;
  if IsConnected then
    try
      NetStop(hSocket);
    except
      on EBrokerError do
        SocketError := WSACleanup; // -- shutdown TCP API
    end; // if
end; // procedure TXWBWinsock.NetworkDisconnect

{ ----------------------- TXWBWinsock.BuildHdr ------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.BuildHdr(wkid: string; winh: string; prch: string;
  wish: string): string;
var
  t: string;
begin
  t := wkid + ';' + winh + ';' + prch + ';' + wish + ';';
  Result := StrPack(t, 3);
end; // function TXWBWinsock.BuildHdr

{ ----------------------- TXWBWinsock.BuildPar ------------------
  Builds the RPC Broker call to be sent to the VistA server.
  ---------------------------------------------------------------- }
function TXWBWinsock.BuildPar(hSocket: TSocket; api, RPCVer: string;
  const Parameters: TParams): string;
var
  I, ParamCount: Integer;
  param: string;
  tResult: string;
  subscript: string;
  IsSeen: boolean;
begin
  param := '5';
  if Parameters = nil then
    ParamCount := 0
  else
    ParamCount := Parameters.Count;
  for I := 0 to ParamCount - 1 do
  begin
    if Parameters[I].PType <> undefined then
    begin
      with Parameters[I] do
      begin
        if PType = literal then
          param := param + '0' + LPack(Value, CountWidth) + 'f';
        // 030107 new message protocol
        if PType = reference then
          param := param + '1' + LPack(Value, CountWidth) + 'f';
        // 030107 new message protocol
        if PType = empty then
          param := param + '4f';
        if (PType = list) or (PType = global) then
        begin
          if PType = list then // 030107 new message protocol
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
            param := param + LPack(subscript, CountWidth) +
              LPack(Mult[subscript], CountWidth);
            IsSeen := True;
            subscript := Mult.Order(subscript, 1);
          end; // while subscript <> ''
          if not IsSeen then
            // 040922 added to take care of list/global parameters with no values
            param := param + LPack('', CountWidth);
          param := param + 'f';
        end; // if (PType = list) or (PType = global)
        if PType = stream then
        begin
          param := param + '5' + LPack(Value, CountWidth) + 'f';
        end; // if PType = stream
      end; // with Parameters[i] do
    end; // if Parameters[i].PType <> undefined
  end; // for i := 0
  if param = '5' then
    param := param + '4f';
   tResult := '[XWB]' + '11' + IntToStr(CountWidth) + '0' + '2' + SPack(RPCVer) +
   SPack(api) + param + #4;
  Result := tResult;
end; // function TXWBWinsock.BuildPar

{ ----------------------- TXWBWinsock.StrPack -------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.StrPack(n: String; p: Integer): String;
var
  s, l: Integer;
  t, x, zero: shortstring;
  y: string;
begin
  s := Length(n);
  fillchar(zero, p + 1, '0');
  SetLength(zero, p);
  Str(s, x);
  t := zero + x;
  l := Length(x) + 1;
  y := Copy(String(t), l, p);
  y := y + n;
  Result := y;
end; // function TXWBWinsock.StrPack

{ ----------------------- TXWBWinsock.VarPack -------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.VarPack(n: string): string;
var
  s: Integer;
begin
  if n = '' then
    n := '0';
  s := Length(n);
  SetLength(Result, s + 2);
  Result := '|' + chr(s) + n;
end; // function TXWBWinsock.VarPack

{ ----------------------- TXWBWinsock.NetCall -------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.NetCall(hSocket: TSocket; imsg: String): PChar;
// JLI 090805
var
  BufSend, BufRecv, BufPtr: PAnsiChar;
  sBuf: string;
  OldTimeOut: Integer;
  BytesRead, BytesLeft, BytesTotal: longint;
  TryNumber: Integer;
  BadXfer: boolean;
  xString: String;
begin
  { -- clear receive buffer prior to sending rpc }
  if xFlush = True then
  begin
    OldTimeOut := HookTimeOut;
    HookTimeOut := 0;
    NetCallPending := True;
    BufRecv := PAnsiChar(StrAlloc(Buffer32K));
    NetTimerStart := Now;
    BytesRead := recv(hSocket, BufRecv^, Buffer32K, 0);
    if BytesRead > 0 then
      while BufRecv[BytesRead - 1] <> #4 do
      begin
        BytesRead := recv(hSocket, BufRecv^, Buffer32K, 0);
      end; // while
    AnsiStrings.StrDispose(BufRecv); // p60
    xFlush := False;
    HookTimeOut := OldTimeOut;
  end; // if
  TryNumber := 0;
  BadXfer := True;
  { -- send message length + message to server }
  BufRecv := PAnsiChar(StrAlloc(Buffer32K));
  try // BufRecv
    BufSend := AnsiStrings.StrNew(PAnsiChar(AnsiString(imsg))); // p60
    try // BufSend
      Result := PChar('');
      while BadXfer and (TryNumber < 4) do
      begin
        NetCallPending := True;
        NetTimerStart := Now;
        TryNumber := TryNumber + 1;
        BadXfer := False;
        SocketError := send(hSocket, BufSend^, AnsiStrings.strlen(BufSend), 0);
        // p60
        if SocketError = SOCKET_ERROR then
          NetError('send', 0);
        BufRecv[0] := #0;
        try
          BufPtr := BufRecv;
          BytesLeft := Buffer32K;
          BytesTotal := 0;
          { Get Security and Application packets }
          SecuritySegment := GetServerPacket(hSocket);
          ApplicationSegment := GetServerPacket(hSocket);
          sBuf := '';
          { -- loop reading TCP buffer until server is finished sending reply }
          repeat
            BytesRead := recv(hSocket, BufPtr^, BytesLeft, 0);
            if BytesRead > 0 then
            begin
              if BufPtr[BytesRead - 1] = #4 then
              begin
                sBuf := String(sBuf) + String(BufPtr);
              end // if BufPtr
              else
              begin
                BufPtr[BytesRead] := #0;
                sBuf := String(sBuf) + String(BufPtr);
              end; // else BufPtr
              Inc(BytesTotal, BytesRead);
            end; // if BytesRead > 0
            if BytesRead <= 0 then
            begin
              if BytesRead = SOCKET_ERROR then
                NetError('recv', 0)
              else
                NetError('connection lost', 0);
              break;
            end; // if BytesRead <= 0
          until BufPtr[BytesRead - 1] = #4; // repeat
          sBuf := Copy(sBuf, 1, BytesTotal - 1);
          Result := StrAlloc(BytesTotal + 1);
          StrCopy(Result, PChar(sBuf));
          if ApplicationSegment = 'U411' then
            BadXfer := True;
          NetCallPending := False;
        finally // try
          sBuf := '';
        end; // try
      end;
    finally // try BufSend
      AnsiStrings.StrDispose(BufSend); // p60
    end; // try BufSend
    if BadXfer then
    begin
      NetError(String('Repeated Incomplete Reads on the server'),
        XWB_BadReads); // p60
      Result := StrNew('');
    end; // if BadXfer
    { -- if there was on error on the server, display the error code }
    if AnsiChar(Result[0]) = #24 then
    begin
      xString := String(Result); // JLI 090804
      xString := Copy(xString, 2, Length(xString)); // JLI 090804
      NetError(xString, XWB_M_REJECT);
      Result := StrNew('');
    end; // if AnsiChar(Result[0]) = #24
  finally // try BufRecv
    AnsiStrings.StrDispose(BufRecv); // p60
  end; // try BufRecv
end; // function TXWBWinsock.NetCall

{ ----------------------- TXWBWinsock.tCall ---------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.tCall(hSocket: TSocket; api, apVer: String;
  Parameters: TParams; var Sec, App: PChar; TimeOut: Integer): PChar;
var
  tmp: string;
  ChangeCursor: boolean;
begin
  HookTimeOut := TimeOut;
  if (string(api) <> 'XWB IM HERE') and (Screen.Cursor = crDefault) then
    ChangeCursor := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass; // P6
  tmp := BuildPar(hSocket, api, apVer, Parameters);
  Result := NetCall(hSocket, tmp);
  StrPCopy(Sec, SecuritySegment);
  StrPCopy(App, ApplicationSegment);
  if ChangeCursor then
    Screen.Cursor := crDefault;
end; // function TXWBWinsock.tCall

{ ----------------------- TXWBWinsock.NetStart ------------------
  p60 Rewrote NetStart to support IPv4/IPv6 dual-stack connections.
  ---------------------------------------------------------------- }
function TXWBWinsock.NetStart(ForegroundM: boolean; Server: string;
  ListenerPort: Integer; var hSocket: TSocket): Integer;
var
  WinSockData: wsaData; // WinSock 2.2 info for Windows APIs
  ChangeCursor: boolean;
  pLocalName, pVistAName, pListenerPort: PAnsiChar;
  pHint, pLocalResult, pVistAResult: PAddrInfo; // DNS lookup in getaddrinfo
  DNSLookup: Integer; // Success/fail for DNS lookup in getaddrinfo
  Connected: boolean;
  LocalAddress, VistAAddress: TSockAddr;
  LocalAddressString, VistAAddressString: string;
  LocalAddressLength, VistAAddressLength: DWORD;
  TimeOut: timeval;
  ipv6only: DWORD;
  y, tmp, upArrow, rAccept, rLost: string;
  tmpPchar: PChar;
  r: Integer;
  lin: TLinger;
  s_lin: array [0 .. 3] of AnsiChar absolute lin;
begin
  if Screen.Cursor = crDefault then
    ChangeCursor := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  ipv6only := 0; // WinSock defaults to IPv6-only. We want both IPv4 and IPv6.
  IPprotocol := 0;
  upArrow := string('^');
  rAccept := string('accept');
  rLost := string('(connection lost)');
  // Set timeout value seconds.milliseconds to wait for a response from the server before aborting.
  // Per MSDN, value may be NULL. This might not be needed, or set it to NIL.
  TimeOut.tv_sec := 5; // Seconds
  TimeOut.tv_usec := 0; // Milliseconds
  // TODO - Implement native SSL/TLS using Windows SChannel SSPI before WinSock is initialized
  // Initiate Windows WinSock DLL
  SocketError := WSAStartup(WinSockVer, WinSockData);
  if SocketError > 0 then
    NetError('WSAStartup', 0);
  NetCallPending := False;
  // Identify the VistA host (Server) by FQDN, IPv4 address, or IPv6 address
  pVistAName := PAnsiChar(AnsiString(Server));
  New(pHint);
  pHint.ai_flags := AI_CANONNAME + AI_ALL;
  pHint.ai_family := AF_UNSPEC;
  pHint.ai_socktype := SOCK_STREAM;
  pHint.ai_protocol := IPPROTO_TCP;
  pHint.ai_addrlen := 0;
  pHint.AI_CANONNAME := NIL;
  pHint.ai_addr := NIL;
  pHint.ai_next := NIL;
  // Get canonical name for VistA (Server)
  DNSLookup := FGetAddrInfo(pVistAName, NIL, pHint, pVistAResult);
  if DNSLookup <> 0 then
    NetError('getaddrinfo (Server)', 0);
  pVistAName := pVistAResult.AI_CANONNAME;
  // Replace Server name with canonical name of server
  // Using AF_INET6 returns a dual-stack socket that can be used for both IPv4 and IPv6
  hSocket := socket(AF_INET6, SOCK_STREAM, IPPROTO_TCP);
  if hSocket = INVALID_SOCKET then
    NetError('socket', 0);
  // Disable the IPV6_V6ONLY socket option to support IPv4/IPv6 dual-stack
  SocketError := setsockopt(hSocket, IPPROTO_IPV6, IPV6_V6ONLY,
    PAnsiChar(@ipv6only), SizeOf(ipv6only));
  if SocketError = SOCKET_ERROR then
    NetError('setsocketopt (Local)', 0);
  // Set address space sufficient for IPv4 or IPv6
  LocalAddressLength := SizeOf(SOCKADDR_STORAGE);
  VistAAddressLength := SizeOf(SOCKADDR_STORAGE);
  // Use WSAConnectByName to make the initial broker connection, trying all possible combinations.
  pListenerPort := PAnsiChar(AnsiString(IntToStr(ListenerPort)));
  Connected := FWSAConnectByName(hSocket, pVistAName, pListenerPort,
    LocalAddressLength, LocalAddress, VistAAddressLength, VistAAddress,
    TimeOut, NIL);
  if not Connected then
    NetError('WSAConnectByName', 0);
  VistAAddressString := FAddrToString(VistAAddress);
  if AnsiContainsStr(VistAAddressString, ':') then
    IPprotocol := 6 // IPv6
  else
    IPprotocol := 4; // IPv4
  // Get address of local system that was used to make connection
  LocalAddressString := FAddrToString(LocalAddress);
  // Get canonical name for local host (Client) for that address
  DNSLookup := FGetAddrInfo(PAnsiChar(AnsiString(LocalAddressString)), NIL,
    pHint, pLocalResult);
  if DNSLookup <> 0 then
    NetError('getaddrinfo (Client)', 0);
  pLocalName := pLocalResult.AI_CANONNAME;
  // Don't send an IPv6 address as a host name due to VistA x-ref "AS2" in SIGN-ON LOG
  if AnsiContainsStr(String(pLocalName), ':') then
  begin
    DNSLookup := gethostname(pLocalName, 255); // get name of local system
    if DNSLookup > 0 then
      NetError('gethostname (local)', 0);
  end;
  y := '[XWB]' + '10' + IntToStr(CountWidth) + '0' + '4' + #$A + 'TCPConnect50'
    + LPack(LocalAddressString, CountWidth) + 'f0' +
    LPack(IntToStr(0), CountWidth) + 'f0' + LPack(String(pLocalName),
    CountWidth) + 'f' + #4;
  HookTimeOut := 30;
  tmpPchar := NetCall(hSocket, PChar(y));
  tmp := tmpPchar;
  StrDispose(tmpPchar);
  if CompareStr(tmp, rLost) = 0 then
  begin
    lin.l_onoff := 1;
    lin.l_linger := 0;
    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin,
      SizeOf(lin));
    if SocketError = SOCKET_ERROR then
      NetError('setsockopt (connect)', 0);
    closesocket(hSocket);
    WSACleanup;
    Result := 10002;
    exit;
  end; // if CompareStr
  r := CompareStr(tmp, rAccept);
  if r <> 0 then
    NetError('NetCall', XWB_M_REJECT);
  if ChangeCursor then
    Screen.Cursor := crDefault;
  Dispose(pHint);
  NetStart := 0;
  // -- connection established, socket handle now in:  hSocket
end; // function TXWBWinsock.NetStart

{ ----------------------- TXWBWinsock.NetStop -------------------
  ---------------------------------------------------------------- }
procedure TXWBWinsock.NetStop(hSocket: TSocket);
var
  tmp: string;
  lin: TLinger;
  s_lin: array [0 .. 3] of AnsiChar absolute lin;
  ChangeCursor: boolean;
  tmpPchar: PChar;
  Str: String;
  x: array [0 .. 15] of Char;
begin
  if not IsConnected then
    exit;
  if Screen.Cursor = crDefault then
    ChangeCursor := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass;
  if hSocket <= 0 then
  begin
    if ChangeCursor then
      Screen.Cursor := crDefault;
    exit;
  end; // if hSocket <= 0
  StrPCopy(x, StrPack(StrPack('#BYE#', 5), 5));
  Str := '[XWB]' + '10' + IntToStr(CountWidth) + '0' + '4' + #5 + '#BYE#' + #4;
  if hSocket <> INVALID_SOCKET then
  begin
    tmpPchar := NetCall(hSocket, Str);
    tmp := tmpPchar;
    StrDispose(tmpPchar);
    lin.l_onoff := 1; { -- shut down the M handler };
    lin.l_linger := 0;
    SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin,
      SizeOf(lin));
    if SocketError = SOCKET_ERROR then
      NetError('setsockopt (connect)', 0);
    SocketError := closesocket(hSocket); { -- close the socket }
  end;
  SocketError := WSAUnhookBlockingHook; { -- restore the default mechanism }
  SocketError := WSACleanup; { -- shutdown TCP API }
  if SocketError > 0 then
    NetError('WSACleanup', 0); { -- check blocking calls, etc. }
  if ChangeCursor then
    Screen.Cursor := crDefault;
  IsConnected := False;
end; // procedure TXWBWinsock.NetStop

{ ----------------------- TXWBWinsock.CloseSockSystem --------------------------
  ---------------------------------------------------------------- }
procedure TXWBWinsock.CloseSockSystem(hSocket: TSocket; s: string);
var
  lin: TLinger;
  s_lin: array [0 .. 3] of AnsiChar absolute lin;
begin
  lin.l_onoff := 1;
  lin.l_linger := 0;
  SocketError := setsockopt(hSocket, SOL_SOCKET, SO_LINGER, s_lin, SizeOf(lin));
  if SocketError = SOCKET_ERROR then
    NetError('setsockopt (connect)', 0);
  closesocket(hSocket);
  WSACleanup;
  ShowMessage(s); // TODO See NetStop for SocketError := WSACleanup;
  halt(1);
end; // procedure TXWBWinsock.CloseSockSystem

{ ----------------------- TXWBWinsock.GetServerPacket --------------------------
  ---------------------------------------------------------------- }
function TXWBWinsock.GetServerPacket(hSocket: TSocket): string;
var
  s, sb: PAnsiChar;
  buflen: Integer;
begin
  s := AnsiStrings.AnsiStrAlloc(1); // p60
  s[0] := #0;
  buflen := recv(hSocket, s^, 1, 0); // get length of segment
  if buflen = SOCKET_ERROR then
  // check for timing problem if initial attempt to read during connection fails
  begin
    sleep(100);
    buflen := recv(hSocket, s^, 1, 0);
  end; // if
  if buflen = SOCKET_ERROR then
    NetError('recv', 0);
  buflen := ord(s[0]);
  sb := AnsiStrings.AnsiStrAlloc(buflen + 1); // p60
  sb[0] := #0;
  buflen := recv(hSocket, sb^, buflen, 0); { get security segment }
  if buflen = SOCKET_ERROR then
    NetError('recv', 0);
  sb[buflen] := #0;
  Result := String(sb); // p60
  AnsiStrings.StrDispose(sb); // p60
  AnsiStrings.StrDispose(s); // p60
end; // function TXWBWinsock.GetServerPacket

{ ----------------------- TXWBWinsock.Create --------------------
  ---------------------------------------------------------------- }

constructor TXWBWinsock.Create;
begin
  inherited;
  // CountWidth := 3;  //this makes the boundary 999
  CountWidth := 5; // this makes the boundary 99999   p71
end; // constructor TXWBWinsock.Create


{ ----------------------- TXWBWinsock.Destroy --------------------
  ---------------------------------------------------------------- }

destructor TXWBWinsock.Destroy;
begin
  CountWidth := 0;
  inherited;
end; // destructor TXWBWinsock.Destroy

{ ----------------------- TXWBWinsock.NetError ------------------
  ---------------------------------------------------------------- }



procedure TXWBWinsock.NetError(Action: string; ErrType: Integer);
var
  x, s: string;
  r: Integer;
  BrokerError: EBrokerError;
  TimeOut: Double;
begin
  Screen.Cursor := crDefault;
  r := 0;
  if ErrType > 0 then
    r := ErrType;
  if ErrType = 0 then
  begin
    if NetCallPending then
    begin
      // Indicate WSAETIMEDOUT error instead of WSAEINTR when time out period expires
      if HookTimeOut > 0 then
      begin
        TimeOut := HookTimeOut * OneSecond;
        if Now > (NetTimerStart + TimeOut) then
          r := WSAETIMEDOUT;
      end; // if HookTimeOut >0
    end; // if NetcallPending
    if r = 0 then
      r := WSAGetLastError;
    if (r = WSAEINTR) or (r = WSAETIMEDOUT) then
      xFlush := True;
  end; // if ErrType = 0
  case r of
    WSAEINTR:
      x := 'WSAEINTR - Interrupted function call.';
    WSAEBADF:
      x := 'WSAEBADF - File handle is not valid.';
    WSAEACCES:
      x := 'WXAEACCES - Permission denied.';
    WSAEFAULT:
      x := 'WSAEFAULT - Bad address.';
    WSAEINVAL:
      x := 'WSAEINVAL - Invalid argument.';
    WSAEMFILE:
      x := 'WSAEMFILE - Too many open files.';
    WSAEWOULDBLOCK:
      x := 'WSAEWOULDBLOCK - Resource temporarily unavailable.';
    WSAEINPROGRESS:
      x := 'WSAEINPROGRESS - Operation now in progress.';
    WSAEALREADY:
      x := 'WSAEALREADY - Operation already in progress.';
    WSAENOTSOCK:
      x := 'WSAENOTSOCK - Socket operation on nonsocket.';
    WSAEDESTADDRREQ:
      x := 'WSAEDESTADDRREQ - Destination address required.';
    WSAEMSGSIZE:
      x := 'WSAEMSGSIZE - Message too long.';
    WSAEPROTOTYPE:
      x := 'WSAEPROTOTYPE - Protocol wrong type for socket.';
    WSAENOPROTOOPT:
      x := 'WSAENOPROTOOPT - Bad protocol option.';
    WSAEPROTONOSUPPORT:
      x := 'WSAEPROTONOSUPPORT - Protocol not supported.';
    WSAESOCKTNOSUPPORT:
      x := 'WSAESOCKTNOSUPPORT - Socket type not supported.';
    WSAEOPNOTSUPP:
      x := 'WSAEOPNOTSUPP - Operation not supported.';
    WSAEPFNOSUPPORT:
      x := 'WSAEPFNOSUPPORT - Protocol family not supported.';
    WSAEAFNOSUPPORT:
      x := 'WSAEAFNOSUPPORT - Address family not supported by protocol family.';
    WSAEADDRINUSE:
      x := 'WSAEADDRINUSE - Address already in use.';
    WSAEADDRNOTAVAIL:
      x := 'WSAEADDRNOTAVAIL - Cannot assign requested address.';
    WSAENETDOWN:
      x := 'WSAENETDOWN - Network is down.';
    WSAENETUNREACH:
      x := 'WSAENETUNREACH - Network is unreachable.';
    WSAENETRESET:
      x := 'WSAENETRESET - Network dropped connection on reset.';
    WSAECONNABORTED:
      x := 'WSAECONNABORTED - Software caused connection abort.';
    WSAECONNRESET:
      x := 'WSAECONNRESET - Connection reset by peer.';
    WSAENOBUFS:
      x := 'WSAENOBUFS - No buffer space available.';
    WSAEISCONN:
      x := 'WSAEISCONN - Socket is already connected.';
    WSAENOTCONN:
      x := 'WSAENOTCONN - Socket is not connected.';
    WSAESHUTDOWN:
      x := 'WSAESHUTDOWN - Cannot send after socket shutdown.';
    WSAETOOMANYREFS:
      x := 'WSAETOOMANYREFS - Too many references.';
    WSAETIMEDOUT:
      x := 'WSAETIMEDOUT - Connection timed out.';
    WSAECONNREFUSED:
      x := 'WSAECONNREFUSED - Connection refused.';
    WSAELOOP:
      x := 'WSAELOOP - Cannot translate name.';
    WSAENAMETOOLONG:
      x := 'WSAENAMETOOLONG - Name too long.';
    WSAEHOSTDOWN:
      x := 'WSAEHOSTDOWN - Host is down.';
    WSAEHOSTUNREACH:
      x := 'WSAEHOSTUNREACH - No route to host.';
    WSAENOTEMPTY:
      x := 'WSAENOTEMPTY - Directory not empty.';
    WSAEPROCLIM:
      x := 'WSAEPROCLIM - Too many processes.';
    WSAEUSERS:
      x := 'WSAEUSERS - User quota exceeded.';
    WSAEDQUOT:
      x := 'WSAEDQUOT - Disk quota exceeded.';
    WSAESTALE:
      x := 'WSAESTALE - Stale file handle reference.';
    WSAEREMOTE:
      x := 'WSAEREMOTE - Item is remote.';
    WSASYSNOTREADY:
      x := 'WSASYSNOTREADY - Network subsystem is unavailable.';
    WSAVERNOTSUPPORTED:
      x := 'WSAVERNOTSUPPORTED - Winsock.dll version out of range.';
    WSANOTINITIALISED:
      x := 'WSANOTINITIALISED - Successful WSAStartup not yet performed.';
    WSATYPE_NOT_FOUND:
      x := 'WSATYPE_NOT_FOUND - Class type not found.';
    WSAHOST_NOT_FOUND:
      x := 'WSAHOST_NOT_FOUND - Host not found.';
    WSATRY_AGAIN:
      x := 'WSATRY_AGAIN - Nonauthoritative host not found.';
    WSANO_RECOVERY:
      x := 'WSANO_RECOVERY - This is a nonrecoverable error.';
    WSANO_DATA:
      x := 'WSANO_DATA - Valid name, no data record of requested type.';

    XWB_NO_HEAP:
      x := 'Insufficient Heap';
    XWB_M_REJECT:
      x := 'M Error - Use ^XTER';
    XWB_BadReads:
      x := 'Server unable to read input data correctly.';
    XWB_BadSignOn:
      x := 'Sign-on was not completed.';
    XWB_ExeNoMem:
      x := 'System was out of memory, executable file was corrupt, or relocations were invalid.';
    XWB_ExeNoFile:
      x := 'File was not found.';
    XWB_ExeNoPath:
      x := 'Path was not found.';
    XWB_ExeShare:
      x := 'Attempt was made to dynamically link to a task,' +
        ' or there was a sharing or network-protection error.';
    XWB_ExeSepSeg:
      x := 'Library required separate data segments for each task.';
    XWB_ExeLoMem:
      x := 'There was insufficient memory to start the application.';
    XWB_ExeWinVer:
      x := 'Windows version was incorrect.';
    XWB_ExeBadExe:
      x := 'Executable file was invalid.' +
        ' Either it was not a Windows application or there was an error in the .EXE image.';
    XWB_ExeDifOS:
      x := 'Application was designed for a different operating system.';
    XWB_RpcNotReg:
      x := 'Remote procedure not registered to application.';
    XWB_BldConnectList:
      x := 'BrokerConnections list could not be created';
    XWB_NullRpcVer:
      x := 'RpcVersion cannot be empty.' + #13 + 'Default is 0 (zero).';
    XWB_BadToken:
      x := 'Could not log on using STS token.';
  else
    x := IntToStr(r);
  end;
  if r = 0 then
    x := 'No error code returned';
  s := 'Error encountered.' + chr(13) + chr(10) + 'Function was: ' + Action +
    chr(13) + chr(10) + 'Error was: ' + x;
  BrokerError := EBrokerError.Create(s);
  BrokerError.Action := Action;
  BrokerError.Code := r;
  BrokerError.Mnemonic := x;
  raise BrokerError;
end; // procedure TXWBWinsock.NetError

end.

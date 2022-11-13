{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: Rpcnet winsock utilities.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 08/05/2015) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 07/16/2013) XWB*1.1*60
  1. Symbol 'StrDispose' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  2. Symbol 'StrPas' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  3. Upgraded from WinSock 1.1 to WinSock 2.2
  4. //TODO - Replace uses winsock with uses winsock2 and fix errors.
  5. //TODO - IPv6 changes required by Microsoft:
  a. Replace gethostbyname function calls with calls to one of the new getaddrinfo
  Windows Sockets functions. The getaddrinfo function with support for the IPv6
  protocol is available on Windows XP and later. The IPv6 protocol is also supported
  on Windows 2000 when the IPv6 Technology Preview for Windows 2000 is installed.

  Changes in v1.1.13 (JLI 08/23/2000) XWB*1.1*13
  1. Made changes to cursor dependent on current cursor being crDefault
  so that the application can set it to a different cursor for long or
  repeated processes without the cursor 'flashing' repeatedly.
  ************************************************** }
unit Rpcnet;

interface

uses
  {System}
  AnsiStrings, SysUtils, Classes,
  {WinApi}
  WinTypes, WinProcs, Messages, Winsock,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

Const
  XWB_GHIP = WM_USER + 10000;

  // Upgrade from WinSock 1.1 to WinSock 2.2
  // Const WinSockVer = $0101;
Const
  WinSockVer = $0202;

Const
  PF_INET = 2;

Const
  SOCK_STREAM = 1;

Const
  IPPROTO_TCP = 6;

Const
  INVALID_SOCKET = -1;

Const
  SOCKET_ERROR = -1;

Const
  FIONREAD = $4004667F;

Const
  ActiveConnection: boolean = False;

type
  EchatError = class(Exception);

type
  TRPCFRM1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure XWBGHIP(var msgSock: TMessage);
    // procedure xwbSelect(var msgSock: TMessage);           //P14
    procedure WndProc(var Message: TMessage); reintroduce; // P14
  end;

type
  WinTaskRec = record
    InUse: boolean;
    pTCPResult: Pointer;
    strTemp: string; { generic output string for async calls }
    chrTemp: PAnsiChar; { generic out PChar for async calls }  // JLI 090804
    hTCP: THandle; { pseudo handle for async calls }
    hWin: hWnd; { handle for owner window }
    CallWait: boolean;
    CallAbort: boolean;
    RPCFRM1: TRPCFRM1;
  end;

var
  WRec: array [1 .. 128] of WinTaskRec;
  Hash: array [0 .. 159] of char;

  { Windows OS abstraction functions.  Should be taken over by VA Kernel }

function libGetCurrentProcess: word;

{ Socket functions using library RPCLIB.DLL, in this case called locally }

function libGetHostIP1(inst: integer; HostName: PAnsiChar; // JLI 090804
  var outcome: PAnsiChar): integer; export; // JLI 090804
function libGetLocalIP(inst: integer; var outcome: PAnsiChar): integer; export;
// JLI 090804
procedure libClose(inst: integer); export;
function libOpen: integer; export;

function GetTCPError: string;

{ Secure Hash Algorithm functions, library SHA.DLL and local interfaces }

function libGetLocalModule: PChar; export;
function GetFileHash(fn: PAnsiChar): longint; export; // JLI 090804

implementation

uses
  {VA}
  Rpcconf1;

{$R *.DFM}

function libGetCurrentProcess: word;
begin
  Result := GetCurrentProcess;
end;

function libGetLocalIP(inst: integer; var outcome: PAnsiChar): integer;
var
  local: PAnsiChar;
begin
  local := PAnsiChar(StrAlloc(255));
  gethostname(local, 255);
  Result := libGetHostIP1(inst, local, outcome);
  AnsiStrings.StrDispose(local); // p60
end;

function libGetLocalModule: PChar;
var
  tsk: THandle;
  name: PChar;
begin
  tsk := GetCurrentProcess;
  name := StrAlloc(1024);
  GetModuleFilename(tsk, name, 1024);
  Result := name;

end;

function GetFileHash(fn: PAnsiChar): longint;
var
  hFn: integer;
  finfo: TOFSTRUCT;
  bytesRead, status: longint;
  tBuf: PChar;

begin
  tBuf := StrAlloc(160);
  hFn := OpenFile(fn, finfo, OF_READ);
  bytesRead := 0;
  status := _lread(hFn, tBuf, sizeof(tBuf));
  while status <> 0 do
  begin
    status := _lread(hFn, tBuf, sizeof(tBuf));
    inc(bytesRead, status);
  end;
  _lclose(hFn);
  StrDispose(tBuf);
  Result := bytesRead;
end;

function libOpen: integer;
var
  inst: integer;
  WSData: TWSADATA;
  RPCFRM1: TRPCFRM1;
begin
  inst := 1; { in this case, no DLL so instance is always 1 }
  RPCFRM1 := TRPCFRM1.Create(nil); // P14
  with WRec[inst] do
  begin
    hWin := AllocateHWnd(RPCFRM1.WndProc);

    WSAStartUp(WinSockVer, WSData);
    WSAUnhookBlockingHook;

    Result := inst;
    InUse := True;
  end;
  RPCFRM1.Release; // P14
end;

procedure libClose(inst: integer);
begin

  with WRec[inst] do
  begin
    InUse := False;
    WSACleanup;
    DeallocateHWnd(hWin);
  end;
end;

function libGetHostIP1(inst: integer; HostName: PAnsiChar;
  var outcome: PAnsiChar): integer;
var
  ChangeCursor: boolean;

begin

  outcome[0] := #0;

  if Screen.Cursor = crDefault then
    ChangeCursor := True
  else
    ChangeCursor := False;
  if ChangeCursor then
    Screen.Cursor := crHourGlass;

  with WRec[inst] do
  begin

    if HostName[0] = #0 then
    begin
      AnsiStrings.StrCat(outcome, 'No Name to Resolve!'); // p60
      Result := -1;
      exit;
    end;

    if CallWait = True then
    begin
      outcome[0] := #0;
      AnsiStrings.StrCat(outcome, 'Call in Progress'); // p60
      Result := -1;
      exit;
    end;

    if inet_addr(HostName) > INADDR_ANY then
    begin
      outcome := HostName;
      Result := 0;
      if ChangeCursor then
        Screen.Cursor := crDefault;
      WSACleanup;
      exit;
    end;

    GetMem(pTCPResult, MAXGETHOSTSTRUCT + 1);
    try
      begin
        CallWait := True;
        CallAbort := False;
        PHostEnt(pTCPResult)^.h_name := nil;
        // TODO - Replace gethostbyname function calls with calls to one of the new getaddrinfo Windows Sockets functions.
        hTCP := WSAAsyncGetHostByName(hWin, XWB_GHIP, HostName, pTCPResult,
          MAXGETHOSTSTRUCT);
        { loop while CallWait is True }
        CallAbort := False;
        while CallWait = True do
          Application.ProcessMessages;
      end;
    except
      on EInValidPointer do
      begin
        AnsiStrings.StrCat(outcome, 'Error in GetHostByName'); // p60
        if ChangeCursor then
          Screen.Cursor := crDefault;
      end;

    end;

    FreeMem(pTCPResult, MAXGETHOSTSTRUCT + 1);
    AnsiStrings.StrCopy(outcome, chrTemp); // p60
    Result := 0;
    if ChangeCursor then
      Screen.Cursor := crDefault;
  end;
end;

procedure TRPCFRM1.WndProc(var Message: TMessage);
begin
  with Message do
    case Msg of
      { XWB_SELECT : xwbSelect(Message); }    // P14
      XWB_GHIP:
        XWBGHIP(Message);
    else
      DefWindowProc(WRec[1].hWin, Msg, wParam, lParam);
      { Inherited WndProc(Message); }
    end;
end;

procedure TRPCFRM1.XWBGHIP(var msgSock: TMessage);
var
  TCPResult: PHostEnt;
  WSAError: integer;
  HostAddr: TSockaddr;
  inst: integer;

begin
  inst := 1; { local case is always 1 }

  with WRec[inst] do
  begin

    hTCP := msgSock.wParam;

    chrTemp := PAnsiChar(StrAlloc(512)); // JLI 090804

    CallWait := False;
    If CallAbort = True then { User aborted call }
    begin
      AnsiStrings.StrCopy(chrTemp, 'Abort!'); // p60
      exit;
    end;

    WSAError := WSAGetAsyncError(hTCP); { in case async call failed }
    If WSAError < 0 then
    begin
      AnsiStrings.StrPCopy(chrTemp, AnsiString(IntToStr(WSAError))); // p60
      exit;
    end;

    try
      begin
        TCPResult := PHostEnt(pTCPResult);
        strTemp := '';
        if TCPResult^.h_name = nil then
        begin
          AnsiStrings.StrCopy(chrTemp, 'Unknown!'); // p60
          if rpcconfig <> nil then
            rpcconfig.pnlAddress.Caption := String(chrTemp); // p60
          exit;
        end;
        { success, return resolved address }
        HostAddr.sin_addr.S_addr := longint(plongint(TCPResult^.h_addr_list^)^);
        chrTemp := inet_ntoa(HostAddr.sin_addr);
      end;
    except
      on EInValidPointer do
        AnsiStrings.StrCat(chrTemp, 'Error in GetHostByName'); // p60
    end;
  end;
end;

// TODO -- Can this be replaced with a call to similar function in Wsockc.pas?
function GetTCPError: string;
var
  x: string;
  r: integer;

begin
  r := WSAGetLastError;
  Case r of
    WSAEINTR:
      x := 'WSAEINTR';
    WSAEBADF:
      x := 'WSAEINTR';
    WSAEFAULT:
      x := 'WSAEFAULT';
    WSAEINVAL:
      x := 'WSAEINVAL';
    WSAEMFILE:
      x := 'WSAEMFILE';
    WSAEWOULDBLOCK:
      x := 'WSAEWOULDBLOCK';
    WSAEINPROGRESS:
      x := 'WSAEINPROGRESS';
    WSAEALREADY:
      x := 'WSAEALREADY';
    WSAENOTSOCK:
      x := 'WSAENOTSOCK';
    WSAEDESTADDRREQ:
      x := 'WSAEDESTADDRREQ';
    WSAEMSGSIZE:
      x := 'WSAEMSGSIZE';
    WSAEPROTOTYPE:
      x := 'WSAEPROTOTYPE';
    WSAENOPROTOOPT:
      x := 'WSAENOPROTOOPT';
    WSAEPROTONOSUPPORT:
      x := 'WSAEPROTONOSUPPORT';
    WSAESOCKTNOSUPPORT:
      x := 'WSAESOCKTNOSUPPORT';
    WSAEOPNOTSUPP:
      x := 'WSAEOPNOTSUPP';
    WSAEPFNOSUPPORT:
      x := 'WSAEPFNOSUPPORT';
    WSAEAFNOSUPPORT:
      x := 'WSAEAFNOSUPPORT';
    WSAEADDRINUSE:
      x := 'WSAEADDRINUSE';
    WSAEADDRNOTAVAIL:
      x := 'WSAEADDRNOTAVAIL';
    WSAENETDOWN:
      x := 'WSAENETDOWN';
    WSAENETUNREACH:
      x := 'WSAENETUNREACH';
    WSAENETRESET:
      x := 'WSAENETRESET';
    WSAECONNABORTED:
      x := 'WSAECONNABORTED';
    WSAECONNRESET:
      x := 'WSAECONNRESET';
    WSAENOBUFS:
      x := 'WSAENOBUFS';
    WSAEISCONN:
      x := 'WSAEISCONN';
    WSAENOTCONN:
      x := 'WSAENOTCONN';
    WSAESHUTDOWN:
      x := 'WSAESHUTDOWN';
    WSAETOOMANYREFS:
      x := 'WSAETOOMANYREFS';
    WSAETIMEDOUT:
      x := 'WSAETIMEDOUT';
    WSAECONNREFUSED:
      x := 'WSAECONNREFUSED';
    WSAELOOP:
      x := 'WSAELOOP';
    WSAENAMETOOLONG:
      x := 'WSAENAMETOOLONG';
    WSAEHOSTDOWN:
      x := 'WSAEHOSTDOWN';
    WSAEHOSTUNREACH:
      x := 'WSAEHOSTUNREACH';
    WSAENOTEMPTY:
      x := 'WSAENOTEMPTY';
    WSAEPROCLIM:
      x := 'WSAEPROCLIM';
    WSAEUSERS:
      x := 'WSAEUSERS';
    WSAEDQUOT:
      x := 'WSAEDQUOT';
    WSAESTALE:
      x := 'WSAESTALE';
    WSAEREMOTE:
      x := 'WSAEREMOTE';
    WSASYSNOTREADY:
      x := 'WSASYSNOTREADY';
    WSAVERNOTSUPPORTED:
      x := 'WSAVERNOTSUPPORTED';
    WSANOTINITIALISED:
      x := 'WSANOTINITIALISED';
    WSAHOST_NOT_FOUND:
      x := 'WSAHOST_NOT_FOUND';
    WSATRY_AGAIN:
      x := 'WSATRY_AGAIN';
    WSANO_RECOVERY:
      x := 'WSANO_RECOVERY';
    WSANO_DATA:
      x := 'WSANO_DATA';

  else
    x := 'Unknown Error';
  end;
  Result := x + ' (' + IntToStr(r) + ')';
end;

end.

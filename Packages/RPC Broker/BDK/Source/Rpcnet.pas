{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: winsock utilities.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }


unit RpcNet ;
{
  Changes in v1.1.13 (JLI -- 8/23/00) -- XWB*1.1*13
    Made changes to cursor dependent on current cursor being crDefault so
       that the application can set it to a different cursor for long or
       repeated processes without the cursor 'flashing' repeatedly.
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, winsock;

Const XWB_GHIP = WM_USER + 10000;
//Const XWB_SELECT = WM_USER + 10001;

Const WINSOCK1_1 = $0101;
Const PF_INET = 2;
Const SOCK_STREAM = 1;
Const IPPROTO_TCP = 6;
Const INVALID_SOCKET = -1;
Const SOCKET_ERROR = -1;
Const FIONREAD = $4004667F;
Const ActiveConnection: boolean = False;

type EchatError = class(Exception);

type
  TRPCFRM1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure XWBGHIP(var msgSock: TMessage);
    //procedure xwbSelect(var msgSock: TMessage);           //P14
    procedure WndProc(var Message : TMessage); reintroduce; //P14
end;

type
  WinTaskRec = record
     InUse: boolean;
     pTCPResult: Pointer;
     strTemp: string; {generic output string for async calls}
     chrTemp: PChar; {generic out PChar for async calls}
     hTCP: THandle; {pseudo handle for async calls}
     hWin: hWnd; {handle for owner window}
     CallWait: boolean;
     CallAbort: boolean;
     RPCFRM1: TRPCFRM1;
  end;

var
   WRec: array[1..128] of WinTaskRec;
   Hash: array[0..159] of char;

{Windows OS abstraction functions.  Should be taken over by VA Kernel}

function libGetCurrentProcess: word;

{Socket functions using library RPCLIB.DLL, in this case called locally}

//function  libAbortCall(inst: integer): integer; export;   //P14
function  libGetHostIP1(inst: integer; HostName: PChar;
          var outcome: PChar): integer; export;
function  libGetLocalIP(inst: integer; var outcome: PChar): integer; export;
procedure libClose(inst: integer); export;
function  libOpen:integer; export;

function GetTCPError:string;

{Secure Hash Algorithm functions, library SHA.DLL and local interfaces}

function libGetLocalModule: PChar; export;
function GetFileHash(fn: PChar): longint; export;

implementation

uses rpcconf1;

{function shsTest: integer; far; external 'SHA';
procedure shsHash(plain: PChar; size: integer;
          Hash: PChar); far; external 'SHA';}    //Removed in P14

{$R *.DFM}



function libGetCurrentProcess: word;
begin
  Result := GetCurrentProcess;
end;

function libGetLocalIP(inst: integer; var outcome: PChar): integer;
var
   local: PChar;
begin
     local := StrAlloc(255);
     gethostname( local, 255);
     Result := libGetHostIP1(inst, local, outcome);
     StrDispose(local);
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

function GetFileHash(fn: PChar): longint;
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
          inc(bytesRead,status);
     end;
     _lclose(hFn);
     StrDispose(tBuf);
     Result := bytesRead;
end;

function libOpen:integer;
var
   inst: integer;
   WSData: TWSADATA;
   RPCFRM1: TRPCFRM1;
begin
     inst := 1; {in this case, no DLL so instance is always 1}
     RPCFRM1 := TRPCFRM1.Create(nil);    //P14
     with WRec[inst] do
     begin
     hWin := AllocateHWnd(RPCFRM1.wndproc);

     WSAStartUp(WINSOCK1_1, WSData);
     WSAUnhookBlockingHook;

     Result := inst;
     InUse := True;
     end;
     RPCFRM1.Release;                    //P14
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

function libGetHostIP1(inst: integer; HostName: PChar;
         var outcome: PChar): integer;
var
   //RPCFRM1: TRPCFRM1; {P14}
   //wMsg: TMSG;        {P14}
   //hWnd: THandle;     {P14}
   ChangeCursor: Boolean;

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
        StrCat(outcome,'No Name to Resolve!');
        Result := -1;
        exit;
   end;

   if CallWait = True then
   begin
        outcome[0] := #0;
        StrCat(outcome, 'Call in Progress');
        Result := -1;
        exit;
   end;

   if inet_addr(HostName) > INADDR_ANY then
   begin
        outcome := Hostname;
        Result := 0;
        if ChangeCursor then
          Screen.Cursor := crDefault;
        WSACleanup;
        exit;
   end;

   GetMem(pTCPResult, MAXGETHOSTSTRUCT+1);
   try
      begin
           CallWait := True;
           CallAbort := False;
           PHostEnt(pTCPResult)^.h_name := nil;
           hTCP := WSAAsyncGetHostByName(hWin, XWB_GHIP, HostName,
                pTCPResult, MAXGETHOSTSTRUCT );
           { loop while CallWait is True }
           CallAbort := False;
           while CallWait = True do
                 Application.ProcessMessages;
      end;
   except on EInValidPointer do
     begin
        StrCat(outcome,'Error in GetHostByName');
        if ChangeCursor then
          Screen.Cursor := crDefault;
     end;

   end;

   FreeMem(pTCPResult, MAXGETHOSTSTRUCT+1);
   StrCopy(outcome,chrTemp);
   Result := 0;
   if ChangeCursor then
     Screen.Cursor := crDefault;
   end;
   end;

(*procedure TRPCFRM1.XWBSELECT(var msgSock: TMessage);
var
   noop: integer;
begin
     case msgSock.lparam of
       FD_ACCEPT: {connection arrived}
          begin
               noop := 1;
          end;
       FD_CONNECT: {connection initiated}
          begin
               noop := 1;
          end;
       FD_READ:    {data received, put in display}
          begin
               noop := 1;
          end;
       FD_CLOSE:   {disconnection of accepted socket}
          begin
               noop := 1;
          end;
       else
              noop := 1;
       end;
end;*)     //Procedure removed in P14.

procedure TRPCFRM1.WndProc(var Message : TMessage);
begin
  with Message do
       case Msg of
            {XWB_SELECT : xwbSelect(Message);}    //P14
            XWB_GHIP: xwbghip(Message);
       else
           DefWindowProc(WRec[1].hWin, Msg, wParam, lParam);
           {Inherited WndProc(Message);}
       end;
end;

procedure TRPCFRM1.XWBGHIP(var msgSock: TMessage);
var
   TCPResult: PHostEnt;
   WSAError: integer;
   HostAddr: TSockaddr;
   inst: integer;

begin
   inst := 1; {local case is always 1}


   with WRec[inst] do
   begin

   hTCP := msgSock.WParam;
   
   chrTemp := StrAlloc(512);

   CallWait := False;
   If CallAbort = True then  { User aborted call }
   begin
        StrCopy(ChrTemp,'Abort!');
        exit;
   end;

   WSAError := WSAGetAsyncError(hTCP); { in case async call failed }
   If  WSAError < 0 then
   begin
        StrPCopy(chrTemp,IntToStr(WSAError));
        exit;
   end;

   try
   begin
      TCPResult := PHostEnt(pTCPResult);
      StrTemp := '';
       if TCPResult^.h_name = nil then
         begin
              StrCopy(chrTemp, 'Unknown!');
              if rpcconfig <> nil then
                rpcconfig.panel4.Caption := StrPas(chrTemp);
              exit;
         end;
      {success, return resolved address}
      HostAddr.sin_addr.S_addr := longint(plongint(TCPResult^.h_addr_list^)^);
      chrTemp := inet_ntoa(HostAddr.sin_addr);
   end;
   except on EInValidPointer do StrCat(chrTemp, 'Error in GetHostByName');
   end;
end;
end;

(*function libAbortCall(inst: integer): integer;
var
   WSAError: integer;
begin

   with WRec[inst] do
   begin

   WSAError := WSACancelAsyncRequest(hTCP);
   if WSAError = Socket_Error then
   begin
        WSAError := WSAGetLastError;
        CallWait := False;
        CallAbort := True;
        Result := WSAError;
   end;

   CallAbort := True;
   CallWait := False;
   Result := WSAError;

   end;

end; *)    //Removed in P14

function GetTCPError:string;
var
   x: string;
   r: integer;

begin
      r := WSAGetLastError;
      Case r of
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

        else x := 'Unknown Error';
  end;
  Result := x + ' (' + IntToStr(r) + ')';
end;


end.

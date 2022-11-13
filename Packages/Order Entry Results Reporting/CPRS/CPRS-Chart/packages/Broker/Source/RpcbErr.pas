{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: RpcbErr error handling for TRPC Broker.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 06/23/2016) XWB*1.1*65
  1. Added error XWB_BadToken for SSOi testing.

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
  ************************************************** }
unit RpcbErr;

interface

uses
  {System}
  Classes, SysUtils,
  {WinApi}
  Winsock2, WinProcs,
  {VA}
  Trpcb,
  {Vcl}
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Graphics;

type
  TfrmRpcbError = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    Symbol: TImage;
    Label2: TLabel;
    Label3: TLabel;
    lblAction: TLabel;
    lblCode: TLabel;
    lblMessage: TLabel;
    procedure FormCreate(Sender: TObject);
  end;

var
  frmRpcbError: TfrmRpcbError;

procedure ShowBrokerError(BrokerError: EBrokerError);
procedure NetError(Action: string; ErrType: integer);

const
  XWBBASEERR = { WSABASEERR + 1 } 20000;

  { Broker Application Error Constants }
  XWB_NO_HEAP = XWBBASEERR + 1;
  XWB_M_REJECT = XWBBASEERR + 2;
  XWB_BadSignOn = XWBBASEERR + 4;
  XWB_BldConnectList = XWBBASEERR + 5;
  XWB_NullRpcVer = XWBBASEERR + 6;
  XWB_BadToken = XWBBASEERR + 7;
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

implementation

uses
  {VA}
  Wsockc;
{$R *.DFM}

procedure ShowBrokerError(BrokerError: EBrokerError);
begin
  try
    Application.CreateForm(TfrmRpcbError, frmRpcbError);
    with frmRpcbError do
    begin
      lblAction.Caption := BrokerError.Action;
      lblCode.Caption := IntToStr(BrokerError.Code);
      lblMessage.Caption := BrokerError.Mnemonic;
      ShowModal;
    end
  finally
    frmRpcbError.Release;
  end;
end;

procedure TfrmRpcbError.FormCreate(Sender: TObject);
var
  FIcon: TIcon;
begin
  FIcon := TIcon.Create;
  try
    FIcon.Handle := LoadIcon(0, IDI_HAND);
    Symbol.Picture.Graphic := FIcon;
    Symbol.BoundsRect := Bounds(Symbol.Left, Symbol.Top, FIcon.Width,
      FIcon.Height);
  finally
    FIcon.Free;
  end;
end;

// Can this be redone to use the procedure TXWBWinsock.NetError in Wsockc.pas and remove redundant code?
procedure NetError(Action: String; ErrType: integer);
var
  x, s: string;
  r: integer;
  BrokerError: EBrokerError;
begin
  Screen.Cursor := crDefault;
  r := 0;
  if ErrType > 0 then
    r := ErrType;
  if ErrType = 0 then
  begin
    r := WSAGetLastError;
    // if r = WSAEINTR then xFlush := True;
    // if WSAIsBlocking = True then WSACancelBlockingCall;
  end;
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

    XWB_NO_HEAP:
      x := 'Insufficient Heap';
    XWB_M_REJECT:
      x := 'M Error - Use ^XTER';
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
  s := 'Error encountered.' + chr(13) + chr(10) + 'Function was: ' + Action +
    chr(13) + chr(10) + 'Error was: ' + x;
  BrokerError := EBrokerError.Create(s);
  BrokerError.Action := Action;
  BrokerError.Code := r;
  BrokerError.Mnemonic := x;
  raise BrokerError;
end;

end.

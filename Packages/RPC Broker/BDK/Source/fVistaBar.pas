{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Kevin Meldrum, Travis Hilton, Joel Ivey
	Description: Basic form for RPCSharedBrokerSessionMgr1.exe.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit fVistaBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Menus, ShellAPI;
  
const
  {Support SysTray}
  wm_IconNotification =  wm_User + 100; //System Tray Msg Handle
  ICON_OFF = 100;                       //IconId for not connected icon
  ICON_ON  = 101;                       //IconId for connected icon
  ICON_OFF_TIP = 'RPCSharedBrokerSessionMgr: no connections';     //Tip when not connected
  ICON_ON_TIP  = 'RPCSharedBrokerSessionMgr';  //Tip when connected



type
  TfrmVistABar = class(TForm)
    pmnSysTray: TPopupMenu;
    About1: TMenuItem;

    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function AddTrayIcon(iconId : UINT; icon : THandle; tip : string)
             : Boolean;
    function DeleteTrayIcon(iconId : UINT) : Boolean;
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    NotifyIconData : TNOTIFYICONDATA;
    TrayIconId     : UINT;
    TrayIcon       : HICON;
    TrayTip        : string;
  protected
    procedure WMIconNotification(var Msg : TMessage);
              message wm_IconNotification;
    procedure  wmQueryEndSession(var Msg : TMessage);
              message wm_QueryEndSession;
  public
    { Public declarations }
  end;

var
  frmVistABar: TfrmVistABar;

implementation

uses uSharedBroker1, frmVistAAbout;

{$R *.DFM}
{$R *.RES}

procedure TfrmVistABar.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  Top := 0;
  Left := (Screen.Width - Width) div 2;

  // Is there a better way to hide this window?
  // Visible := false;  // doesn't work
  // TODO
  // Find a way to make the main form non visible
  Width := 0;
  Height := 0;

end;

procedure TfrmVistABar.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 1 to ParamCount do    // Iterate
    if UpperCase(ParamStr(I)) = 'REGISTER' then
      Halt;
  {Setup NotifyIconData fields that won't change}
  NotifyIconData.cbSize := SizeOf(TNOTIFYICONDATA);
  NotifyIconData.Wnd := Handle;
  NotifyIconData.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  NotifyIconData.uCallbackMessage := wm_IconNotification;

  {Setup initial icon (= NotConnected) and add it!}
  TrayIconId := ICON_ON;
  TrayIcon   := LoadIcon(HInstance, 'ICON_ON');   //Loads icon from resource.
  TrayTip    := ICON_ON_TIP;
  AddTrayIcon(TrayIconId, TrayIcon, TrayTip);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  //ShowWindow(Application.Handle, SW_HIDE);
end;

function TfrmVistaBar.AddTrayIcon(iconId : UINT; icon : THandle; tip : string)
             : Boolean;
begin
  NotifyIconData.uID := IconID;
  NotifyIconData.HIcon := icon;
  if tip <> '' then
    StrLCopy(NotifyIconData.szTip, PChar(tip), SizeOf(NotifyIconData.szTip))
  else
    NotifyIconData.szTip := #0;
  Result := Shell_NotifyIcon(NIM_ADD, @NotifyIconData);
end;

{Processes messages to the icon in the System Tray.}
procedure TfrmVistaBar.WMIconNotification(var Msg : TMessage);
var
  MouseMsg : LongInt;
  Pt: TPoint;
begin
  MouseMsg := Msg.LParam;

  case MouseMsg of
    wm_LButtonDown :
      ;
    wm_RButtonUp :
    begin
      GetCursorPos(Pt);               //Used to locate pop-up menu
      pmnSysTray.PopUp(Pt.X, Pt.Y);   //Displays menu
    end;
    wm_LButtonDblClk :               //DoubleClick displays form.
//      mitShowClick(Self);
  end;
end;

{Event handler sets flag used in FormCloseQuery so that user is }
procedure TfrmVistaBar.wmQueryEndSession(var Msg : TMessage);
begin
//  CanAutoClose := True;
  Msg.Result := 1;
end;

function TfrmVistaBar.DeleteTrayIcon(iconId : UINT) : Boolean;
begin
  NotifyIconData.uID := IconID;
  Result := Shell_NotifyIcon(NIM_DELETE, @ NotifyIconData);
  Application.ProcessMessages;
end;



procedure TfrmVistABar.FormDestroy(Sender: TObject);
begin
  DeleteTrayIcon(TrayIconId);
end;

procedure TfrmVistABar.Exit1Click(Sender: TObject);
begin
  ShowMessage('If the system warns against closing this Application - DON''T CLOSE IT.#13#10Closing this when it shouldn''t be will cause any applications using it to crash');
  Halt;
end;

procedure TfrmVistABar.About1Click(Sender: TObject);
begin
  ShowAboutBox;
end;

end.

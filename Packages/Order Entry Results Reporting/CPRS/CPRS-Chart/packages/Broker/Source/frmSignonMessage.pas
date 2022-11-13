{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Joel Ivey, Herlan Westra, Roy Gaber
  Description: Contains TRPCBroker and related components.
  Unit: frmSignonMessage displays message from server after user
  signon.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 11/10/2016) XWB*1.1*65
  1. Added code to set up and assign form to current broker session to
  display a sign-on message upon connecting to a server. This is a VA
  Handbook Appendix F requirement (AC-8: System Use Notification).
  2. Added lblConnection to bottom of form with:
  "Secured connection to ____ using IPv4"
  "Encrypted connection to ____ using IPv6"
  "Unsecured connection to ____ using IPv4"

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. None.
  ************************************************** }
unit frmSignonMessage;

{
  VA Handbook Appendix F, AC-8: System Use Notification
  NIST SP 800-53
  The information system:
  * Displays an approved system use notification message or banner before
  granting access to the system that provides privacy and security notices
  consistent with applicable Federal laws, Executive Orders, policies,
  regulations, standards, and guidance and states that: (i) users are
  accessing a U.S. Government information system; (ii) system usage may be
  monitored, recorded, and subject to audit; (iii) unauthorized use of the
  system is prohibited and subject to criminal and civil penalties; and (iv)
  use of the system indicates consent to monitoring and recording;
  * Retains the notification message or banner on the screen until users take
  explicit actions to log on to or further access the information system; and
  * For publicly accessible systems: (i) displays the system use information when
  appropriate, before granting further access; (ii) displays references, if
  any, to monitoring, recording, or auditing that are consistent with privacy
  accommodations for such systems that generally prohibit those activities;
  and (iii) includes in the notice given to public users of the information
  system, a description of the authorized uses of the system.
}

interface

uses
  {System}
  Classes, SysUtils, UITypes,
  {WinApi}
  Messages, ShellApi, Windows,
  {VA}
  fRPCBErrMsg, MFunStr, SgnonCnf, Trpcb, XWBut1,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  XWBRich20;

type
  TfrmSignonMsg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    lblConnection: TLabel;
    RPCbiBroker: TRPCBroker;
    mmoMsg: TXWBRichEdit;
    procedure Panel2Resize(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure introTextURLClick(Sender: TObject; URL: String);
  private
    DefaultSignonConfiguration: TSignonValues;
    SignonConfiguration: TSignonConfiguration;
    OrigHelp: String; // Help filename of calling application.
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  public
  end;

procedure PrepareSignonMessage(AppBroker: TRPCBroker);
function SetUpMessage: Boolean; overload;

var
  MessagefrmSignOnBroker: TRPCBroker;
  frmSignonMsg: TfrmSignonMsg;

const
  SC_Configure = 1;
  SC_About = 2;

implementation

var
  SysMenu: HMenu;

{$R *.DFM}

  { --------------------- TfrmSignonMsg.PrepareSignonMessage --------
    Assigns a TRPCBroker component to this session
    ------------------------------------------------------------------ }
procedure PrepareSignonMessage(AppBroker: TRPCBroker);
begin
  MessagefrmSignOnBroker := AppBroker;
end;

{ --------------------- TfrmSignonMsg.SetUpMessage ----------------
  Set up Message form.
  ------------------------------------------------------------------ }
function SetUpMessage: Boolean;
var
  ConnectedUser: String;
  ConnectedSecurity: String;
  ConnectedServer: String;
  ConnectedIPprotocol: String;
begin
  // MessagefrmSignonBroker supersedes RpcbiBroker
  if MessagefrmSignOnBroker = nil then
    MessagefrmSignOnBroker := frmSignonMsg.RPCbiBroker;
  with frmSignonMsg do
  begin
    ConnectedUser := '';
    ConnectedSecurity := '';
    ConnectedServer := '';
    ConnectedIPprotocol := '';
    try
      with frmSignonMsg do
      begin
        if MessagefrmSignOnBroker.RPCBError = '' then
        begin
          if MessagefrmSignOnBroker.SSOiLogonName <> '' then
            ConnectedUser := MessagefrmSignOnBroker.SSOiLogonName + ' has ';
          if MessagefrmSignOnBroker.IPsecSecurity = 1 then
            ConnectedSecurity := 'a secure connection to ';
          if MessagefrmSignOnBroker.IPsecSecurity = 2 then
            ConnectedSecurity := 'an encrypted connection to ';
          if ConnectedSecurity = '' then
            ConnectedSecurity := 'a connection to ';
          ConnectedServer := MessagefrmSignOnBroker.Login.DomainName +
            ' using ';
          if MessagefrmSignOnBroker.IPprotocol = 4 then
            ConnectedIPprotocol := 'IPv4.';
          if MessagefrmSignOnBroker.IPprotocol = 6 then
            ConnectedIPprotocol := 'IPv6.';
          if not(ConnectedUser = '') then
            frmSignonMsg.lblConnection.Caption := ConnectedUser +
              ConnectedSecurity + ConnectedServer + ConnectedIPprotocol;
        end;
      end;
    except
    end;
  end;
  Result := True;
  // By default Message is displayed (VA Handbook 6500 requirement).
end;

{ --------------------- TfrmSignonMsg.FormClose -------------------
  Close frmSignonMessage Form
  ------------------------------------------------------------------ }
procedure TfrmSignonMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Piece(strSize, U, 1) = '2' then
  begin
    strSize := '2^' + IntToStr(Width) + U + IntToStr(Height);
    WriteRegData(HKCU, REG_SIGNON, 'SignonSiz', strSize);
  end;

  if Piece(strPosition, U, 1) = '2' then
  begin
    strPosition := '2^' + IntToStr(Top) + U + IntToStr(Left);
    WriteRegData(HKCU, REG_SIGNON, 'SignonPos', strPosition);
  end;
  Application.HelpFile := OrigHelp; // Restore helpfile.
  If Assigned(SignonConfiguration) then
    FreeAndNil(SignonConfiguration);
  If Assigned(DefaultSignonConfiguration) then
    FreeAndNil(DefaultSignonConfiguration);
end;

{ --------------------- TfrmSignonMsg.FormCreate ------------------
  Instantiate frmSignonMessage Form
  ------------------------------------------------------------------ }
procedure TfrmSignonMsg.FormCreate(Sender: TObject);
begin
  if (Pos('LARGE', UpperCase(ReadRegDataDefault(HKCU,
    'Control Panel\Appearance', 'Current', ''))) > 0) or (Screen.Width < 800)
  then
  begin
    WindowState := wsMaximized;
    with Screen do
    begin
      if Width < 700 then // 640
        mmoMsg.Font.Size := 9
      else if Width < 750 then // 720
        mmoMsg.Font.Size := 10
      else if Width < 900 then // 800
        mmoMsg.Font.Size := 11
      else if Width < 1100 then // 1024
        mmoMsg.Font.Size := 15
      else if Width < 1200 then // 1152
        mmoMsg.Font.Size := 16
      else if Width < 1900 then
        mmoMsg.Font.Size := 19 // 1280
      else
        mmoMsg.Font.Size := 28; // 1920
    end; // with
  end;
  FormStyle := fsStayOnTop;
  // make form stay on top of others so it can be found
  { adjust appearance per user's preferences }
  try
    SignonConfiguration := TSignonConfiguration.Create;
    DefaultSignonConfiguration := TSignonValues.Create;
    DefaultSignonConfiguration.BackColor := mmoMsg.Color;
    DefaultSignonConfiguration.Height := Height;
    DefaultSignonConfiguration.Width := Width;
    DefaultSignonConfiguration.Position := '0';
    DefaultSignonConfiguration.Size := '0';
    DefaultSignonConfiguration.Left := Left;
    DefaultSignonConfiguration.Top := Top;
    DefaultSignonConfiguration.Font := mmoMsg.Font;
    DefaultSignonConfiguration.TextColor := mmoMsg.Font.Color;
    DefaultSignonConfiguration.FontStyles := mmoMsg.Font.Style;
    SignonDefaults.SetEqual(DefaultSignonConfiguration);
    SignonConfiguration.ReadRegistrySettings;
    if InitialValues.Size = '0' then
    begin { restore defaults }
      Width := DefaultSignonConfiguration.Width;
      Height := DefaultSignonConfiguration.Height;
    end
    else
    begin
      try
        Position := poDesigned;
        Width := StrToInt(Piece(strSize, U, 2));
        Height := StrToInt(Piece(strSize, U, 3));
      except
        Width := DefaultSignonConfiguration.Width;
        Height := DefaultSignonConfiguration.Height;
      end;
    end;
    if InitialValues.Position = '0' then { restore defaults }
      Position := poScreenCenter
    else
    begin
      try
        Top := StrToInt(Piece(strPosition, U, 2));
        Left := StrToInt(Piece(strPosition, U, 3));
      except
        Position := poScreenCenter
      end;
    end;
    if InitialValues.BackColor <> 0 then
      mmoMsg.Color := InitialValues.BackColor
    else
      mmoMsg.Color := clWindow;
    mmoMsg.Font := InitialValues.Font;
  finally
  end;
end;

{ --------------------- TfrmSignonMsg.FormShow -------------------
  Show frmSignonMessage Form
  ------------------------------------------------------------------ }
procedure TfrmSignonMsg.FormShow(Sender: TObject);
var
  Str: String;
begin
  Str := 'RPCBroker';
  { add Configure... to system menu }
  SysMenu := GetSystemMenu(Handle, False);
  AppendMenu(SysMenu, MF_Enabled + MF_String + MF_Unchecked, SC_Configure,
    '&Properties...');
  AppendMenu(SysMenu, MF_Enabled + MF_String + MF_Unchecked, SC_About,
    PChar('&About ' + Str));
  with MessagefrmSignOnBroker do
  begin
    RemoteProcedure := 'XUS INTRO MSG';
    lstCall(mmoMsg.Lines);
  end;
  OrigHelp := Application.HelpFile; // Save original helpfile.
  Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
    '\clagent.hlp'; // Identify ConnectTo helpfile.
  with mmoMsg do
  begin
    // Move to 3rd line, Character 3:
    SelStart := Perform(EM_LINEINDEX, 0, 0) + 0;
    mmoMsg.SelLength := 0;
    Perform(EM_SCROLLCARET, 0, 0);
    mmoMsg.Repaint;
    mmoMsg.SetFocus;
    // Application.ProcessMessages;
  end;
end;

procedure TfrmSignonMsg.Panel2Resize(Sender: TObject);
begin
  BitBtn1.Left := (Panel2.Width - BitBtn1.Width) div 2;
end;

procedure TfrmSignonMsg.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

{ --------------------- TfrmSignonMsg.introTextURLClick -----------
  Implement 'click' on a URL in the introText box
  ------------------------------------------------------------------ }
procedure TfrmSignonMsg.introTextURLClick(Sender: TObject; URL: String);
begin
  // URL := TIdURI.URLEncode(URL);         //Indy IdURI unit
  ShellExecute(Application.Handle, 'open', PChar(URL), nil, nil, SW_NORMAL);
end;

{ --------------------- TfrmSignonMsg.WMSysCommand -------------------
  'Configure' or 'About' popup box (system commands)
  ------------------------------------------------------------------ }
procedure TfrmSignonMsg.WMSysCommand(var Message: TWMSysCommand);
var
  Str: String;
  SignonConfiguration: TSignonConfiguration;
  frmErrMsg: TfrmErrMsg;
begin
  if Message.CmdType = SC_Configure then
  begin
    SignonConfiguration := TSignonConfiguration.Create;
    try
      ShowApplicationAndFocusOK(Application);
      SignonConfiguration.ShowModal;
    finally
      FreeAndNil(SignonConfiguration);
      Self.WindowState := wsNormal;
    end;
  end
  else if Message.CmdType = SC_About then
  begin
    frmErrMsg := TfrmErrMsg.Create(Application);
    try
      frmErrMsg.Caption := 'About RPCBroker';
      Str := 'RPCBroker Version is ' + RPCbiBroker.BrokerVersion;
      frmErrMsg.mmoErrorMessage.Lines.Add(Str);
      ShowApplicationAndFocusOK(Application);
      frmErrMsg.ShowModal;
    finally
      FreeAndNil(frmErrMsg);
    end;
  end
  else
    inherited;
end;

end.

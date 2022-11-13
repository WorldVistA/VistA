{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey, Herlan Westra
  Description: Contains TRPCBroker and related components.
  Unit: Loginfrm code supporting Login form.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.
  2. Replaced RichEdit component with new XWBRichEdit component

  Changes in v1.1.65 (HGW 11/17/2015) XWB*1.1*65
  1. Fixed form where Port number was not being displayed properly (showed value
  of $I). It is a change in Cache, part of a Linux fix. Now displaying the
  port number assigned when making the connection to VistA (in Delphi).
  2. In SetUpSignOn, disabled callback to Client Agent. Auto Sign-On is
  deprecated for 2-factor authentication, and will not work consistently
  with IPv6 (multiple IP addresses assigned to a workstation).

  Changes in v1.1.60 (HGW 4/15/2015) XWB*1.1*60
  1. Changed form format to permit longer server and volume names.
  2. Split verifyCode.text from accessCode.text if entered in a single string
  (accessCode;verifyCode). This will enable old verify code to be passed to
  VCEdit.pas when changing a verify code.
  3. Identified possible changes needed for next version to support Single
  Sign-On Internal (SSOi) using Identity and Access Management (IAM) STS
  SAML Token (see procedure TfrmSignon.btnOkClick).

  Changes in v1.1.50 (JLI 9/1/2011) XWB*1.1*50
  1. None.

  Changes in v1.1.47 (JLI 6/17/2008) XWB*1.1*47
  1. Changes to LoginfrmSignonBroker to resolve authentication errors.

  Changes in v1.1.11 (DCM 9/13/1999) XWB*1.1*11
  1. Deleted obsolete code.

  Changes in v1.1.4 (DCM 1/6/1999) XWB*1.1*4
  1. Added a try-except block in SetUpSignOn to close
  login form when the server job times out.  Also added a
  try-except block in btnOkClick to cancel the action if the
  server job times out.
  ************************************************** }
unit Loginfrm;

interface

uses
  {System}
  AnsiStrings, Classes, SysUtils, UITypes,
  {WinApi}
  WinTypes, WinProcs, Messages, ShellApi, Windows,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Buttons,
  {VA}
  XWBHash, MFunStr, Trpcb, SgnonCnf, XWBut1, frmSignonMessage, XWBRich20,
  Vcl.ComCtrls, Vcl.Menus;

type
  TfrmSignon = class(TForm)
    Panel1: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    verifyCode: TEdit;
    accessCode: TEdit;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    lblServer: TLabel;
    lblVolume: TLabel;
    lblUCI: TLabel;
    lblPort: TLabel;
    cbxChangeVerifyCode: TCheckBox;
    RpcbiBroker: TRPCBroker;
    introText: TXWBRichEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure introTextURLClick(Sender: TObject; URL: String);
    procedure Image1Click(Sender: TObject);
  private
    FChngVerify: Boolean;
    // indicates whether user has requested changing verify code
    OrigHelp: String; // Help filename of calling application.
    function DoVerify: Boolean;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  public
    DefaultSignonConfiguration: TSignonValues;
  end;

procedure PrepareSignonForm(AppBroker: TRPCBroker);
function SetUpSignOn: Boolean; overload;

var
  frmSignon: TfrmSignon;
  intDeviceLock: integer;
  LoginfrmSignOnBroker: TRPCBroker;

const
  SC_Configure = 1;
  SC_About = 2;

implementation

uses
  RpcSlogin, VCEdit, fRPCBErrMsg, RpcConf1, XlfSid;

var
  SysMenu: HMenu;

{$R *.DFM}

  { --------------------- TfrmSignon.PrepareSignonForm --------------
    Assigns a TRPCBroker component to this session
    ------------------------------------------------------------------ }
procedure PrepareSignonForm(AppBroker: TRPCBroker);
begin
  LoginfrmSignOnBroker := AppBroker;
end;

{ --------------------- TfrmSignon.SetUpSignOn --------------------
  Calls 'XUS SIGNON SETUP' to set up the environment for this session
  ------------------------------------------------------------------ }
function SetUpSignOn: Boolean;
begin
  Result := True; // By default Signon is needed.
  if LoginfrmSignOnBroker = nil then
    LoginfrmSignOnBroker := frmSignon.RpcbiBroker;
  { SignonBroker supersedes RpcbiBroker }
  with frmSignon do
  begin
    try
      with LoginfrmSignOnBroker do
      begin
        if not(LoginfrmSignOnBroker.SecurityPhrase = '') then
        begin
          with Param[0] do // start BSE
          begin
            Value := '-35^' + Encrypt(LoginfrmSignOnBroker.SecurityPhrase);
            PType := literal;
          end; // with               // end BSE
        end
        else
          with Param[0] do
          begin
            PType := literal;
            Value := Encrypt(GetNTLogonSid);
          end;
        Param[1].Value := '1'; // Disable Client Agent callback (p65)
        Param[1].PType := literal;
        RemoteProcedure := 'XUS SIGNON SETUP';
        Call;
      end;
    except
      on error: Exception do
      begin
        // ShowMessage('Exception: '+error.message);
        Raise;
        // exit;
      end;
    end; // try
    if LoginfrmSignOnBroker.RPCBError = '' then
    begin
      lblServer.Caption := LoginfrmSignOnBroker.Results[0];
      lblVolume.Caption := LoginfrmSignOnBroker.Results[1];
      lblUCI.Caption := LoginfrmSignOnBroker.Results[2];
      // lblPort.Caption   := LoginfrmSignonBroker.Results[3];  //Use local information instead of VistA returned value
      lblPort.Caption := IntToStr(LoginfrmSignOnBroker.ListenerPort);
      intDeviceLock := 0;
      if LoginfrmSignOnBroker.Results.Count > 5 then
        // Server sent single signon info.
        if LoginfrmSignOnBroker.Results[5] = '1' then // Signon not needed
          Result := False
        else
          Result := True;
      LoginfrmSignOnBroker.Login.IsProductionAccount := False;
      LoginfrmSignOnBroker.Login.DomainName := '';
      if LoginfrmSignOnBroker.Results.Count > 7 then
      begin
        LoginfrmSignOnBroker.Login.DomainName :=
          LoginfrmSignOnBroker.Results[6];
        if LoginfrmSignOnBroker.Results[7] = '1' then
          LoginfrmSignOnBroker.Login.IsProductionAccount := True;
      end;
    end;
  end;
end;

{ --------------------- TfrmSignon.btnOkClick ---------------------
  This gets called when user presses OK button on the login form.
  Access and verify codes are transmitted as access;verify to the server.
  Server responds with a multi-purpose array where each node has some
  special meaning, which may change periodically and should be revised.
  SignonBroker.Results[0] -  DUZ (0 if unsuccessful signon)
  SignonBroker.Results[1] -  0=OK  1=device lock (too many bad tries)
  SignonBroker.Results[2] -  0=verify doesn't need to be changed
  1=verify needs changing
  SignonBroker.Results[3] -  message (i.e. signon inhibited, etc.)
  SignonBroker.Results[4] -  reserved
  SignonBroker.Results[5] -  number of lines in greeting message
  (currently hard set to 0) to suppress msg display
  SignonBroker.Results[6-n] - greeting message
  ------------------------------------------------------------------ }
procedure TfrmSignon.btnOkClick(Sender: TObject);
var
  I: integer;
  EntryString: TStringList; // p60
begin
  EntryString := TStringList.Create; // p60
  EntryString.Delimiter := ';'; // p60
  frmSignon.Tag := 0; { initialize signon flag }
  try // P4
    with LoginfrmSignOnBroker do
    begin
      with Param[0] do
      begin
        // p60 Split verifyCode.text from accessCode.text if entered in a single string (accessCode;verifyCode)
        if verifyCode.text = '' then
        begin
          EntryString.DelimitedText := accessCode.text;
          accessCode.text := EntryString[0];
          verifyCode.text := EntryString[1];
        end;
        Value := Encrypt(accessCode.text + ';' + verifyCode.text);
        PType := literal;
      end;
      RemoteProcedure := 'XUS AV CODE';
      Call;
      { Device is locked -- too many failures }
      if Results[1] = '1' then
      begin
        RPCBShowErrMsg(Results[3]);
        Close;
      end
      { Verify code must change }
      else if Results[2] = '1' then
      begin
        MessageDlg('You must change your VERIFY CODE at this time.', mtWarning,
          [mbOK], 0); // Notify that VC must change.
        if DoVerify then
          frmSignon.Tag := 1; // VC changed -> OK
        Close;
        { Note: if VC change necessary and it wasn't made,
          Tag remains 0 meaning unsuccessful signon. }
      end
      { Signon failed for some other reason }
      else if Results[0] = '0' then
      begin
        accessCode.text := '';
        verifyCode.text := '';
        RPCBShowErrMsg(Results[3]);
        accessCode.SetFocus; // Try again.
      end
      { Signon succeeded. }
      else
      begin
        frmSignon.Tag := 1; { set flag that signon was good }
        { display any server greeting messages }
        if cbxChangeVerifyCode.Checked then
        begin
          frmSignon.Enabled := False; // p65
          DoVerify;
          frmSignon.Enabled := True; // p65
        end;
        if Results.Count > 5 then
        begin
          if Results[5] <> '0' then
          begin
            frmSignon.Enabled := False; // p65
            frmSignonMsg := TfrmSignonMsg.Create(Self);
            frmSignonMsg.RpcbiBroker := LoginfrmSignOnBroker;
            try
              with frmSignonMsg do
              begin
                mmoMsg.Lines.Clear;
                for I := 1 to StrToInt(Results[5]) do
                  mmoMsg.Lines.Add(Results[5 + I]);
                ShowApplicationAndFocusOK(Application);
                // ShowModal;                                        //Causes memory error
              end;
            finally
              FreeAndNil(EntryString);
              FreeAndNil(frmSignonMsg);
              frmSignon.Enabled := True; // p65
            end;
          end;
        end;
        Close;
        FreeAndNil(EntryString);
      end;
    end;
  except // P4
    btnCancelClick(Self); // P4
  end; // P4
end;

{ --------------------- TfrmSignon.btnCancelClick -----------------
  Implement Cancel button
  ------------------------------------------------------------------ }
procedure TfrmSignon.btnCancelClick(Sender: TObject);
begin
  LoginfrmSignOnBroker.Login.ErrorText := 'User Cancelled Login Process';
  Close;
end;

{ --------------------- TfrmSignon.FormShow -----------------------
  Show Loginfrm Form
  ------------------------------------------------------------------ }
procedure TfrmSignon.FormShow(Sender: TObject);
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
  with LoginfrmSignOnBroker do
  begin
    RemoteProcedure := 'XUS INTRO MSG';
    lstCall(introText.Lines);
  end;
  OrigHelp := Application.HelpFile; // Save original helpfile.
  Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
    '\clagent.hlp'; // Identify ConnectTo helpfile.
end;

procedure TfrmSignon.Image1Click(Sender: TObject);
begin

end;

{ --------------------- TfrmSignon.FormCreate ---------------------
  Instantiate Loginfrm Form
  ------------------------------------------------------------------ }
procedure TfrmSignon.FormCreate(Sender: TObject);
var
  SignonConfiguration: TSignonConfiguration;
begin
  if (Pos('LARGE', UpperCase(ReadRegDataDefault(HKCU,
    'Control Panel\Appearance', 'Current', ''))) > 0) or (Screen.Width < 800)
  then
  begin
    WindowState := wsMaximized;
    with Screen do
    begin
      if Width < 700 then // 640
        introText.Font.Size := 9
      else if Width < 750 then // 720
        introText.Font.Size := 10
      else if Width < 900 then // 800
        introText.Font.Size := 11
      else if Width < 1100 then // 1024
        introText.Font.Size := 15
      else if Width < 1200 then // 1152
        introText.Font.Size := 16
      else if Width < 1900 then
        introText.Font.Size := 19 // 1280
      else
        introText.Font.Size := 28; // 1920
    end; // with
  end;
  FormStyle := fsStayOnTop;
  // make form stay on top of others so it can be found
  { adjust appearance per user's preferences }
  SignonConfiguration := TSignonConfiguration.Create;
  try
    DefaultSignonConfiguration := TSignonValues.Create;
    DefaultSignonConfiguration.BackColor := introText.Color;
    DefaultSignonConfiguration.Height := Height;
    DefaultSignonConfiguration.Width := Width;
    DefaultSignonConfiguration.Position := '0';
    DefaultSignonConfiguration.Size := '0';
    DefaultSignonConfiguration.Left := Left;
    DefaultSignonConfiguration.Top := Top;
    DefaultSignonConfiguration.Font := introText.Font;
    DefaultSignonConfiguration.TextColor := introText.Font.Color;
    DefaultSignonConfiguration.FontStyles := introText.Font.Style;
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
      introText.Color := InitialValues.BackColor
    else
      introText.Color := clWindow;
    introText.Font := InitialValues.Font;
  finally
    //p73 change from FreeAndNil to CleanupInstance
    SignonConfiguration.CleanupInstance;        //p73
    DefaultSignonConfiguration.CleanupInstance; //p73
  end;
  FChngVerify := False;
end;

{ --------------------- TfrmSignon.WMSysCommand -------------------
  'Configure' or 'About' popup box (system commands)
  ------------------------------------------------------------------ }
procedure TfrmSignon.WMSysCommand(var Message: TWMSysCommand);
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
      SignonConfiguration.Free;
      Self.WindowState := wsNormal;
    end;
  end
  else if Message.CmdType = SC_About then
  begin
    frmErrMsg := TfrmErrMsg.Create(Application);
    try
      frmErrMsg.Caption := 'About RPCBroker';
      Str := 'RPCBroker Version is ' + RpcbiBroker.BrokerVersion;
      frmErrMsg.mmoErrorMessage.Lines.Add(Str);
      ShowApplicationAndFocusOK(Application);
      frmErrMsg.ShowModal;
    finally
      FreeAndNil(frmErrMsg);
      FreeAndNil(SignonConfiguration);
    end;
  end
  else
    inherited;
end;

{ --------------------- TfrmSignon.FormClose ----------------------
  Close Loginfrm Form
  ------------------------------------------------------------------ }
procedure TfrmSignon.FormClose(Sender: TObject; var Action: TCloseAction);
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
end;

{ --------------------- TfrmSignon.introTextURLClick --------------
  Implement 'click' on a URL in the introText box
  ------------------------------------------------------------------ }
procedure TfrmSignon.introTextURLClick(Sender: TObject; URL: String);
begin
  // URL := TIdURI.URLEncode(URL);         //Indy IdURI unit
  ShellExecute(Application.Handle, 'open', PChar(URL), nil, nil, SW_NORMAL);
end;

{ --------------------- TfrmSignon.DoVerify -----------------------
  Invoke VCEdit form if Change Verify Code box is checked
  ------------------------------------------------------------------ }
function TfrmSignon.DoVerify: Boolean;
var
  VCEdit1: TVCEdit;
begin
  VCEdit1 := TVCEdit.Create(Self);
  try
    VCEdit1.RPCBroker := LoginfrmSignOnBroker;
    Result := VCEdit1.ChangeVCKnowOldVC(verifyCode.text); // invoke VCEdit form.
  finally
    VCEdit1.Free;
  end;
end;

end.

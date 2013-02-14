{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Code supportin Login form.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

{**************************************************
ver. 1.1.4  1/6/99 (DCM)

XWB*1.1*4 adds a  try-except block in SetUpSignOn to close
login form when the server job times out.  Also adds a try-
except block in btnOkClick in order to cancel the action
if the server job times out. Danila

ver. 1.1.11 9/13/99
XWB*1.1*11 deleted obsolete code.  DCM (9/13/99)
**********************************************************}
unit Loginfrm;

interface          

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, XWBut1, ExtCtrls, Buttons,
  Hash, MFunStr, Trpcb, SgnonCnf, frmSignonMessage, ShellApi,
   Windows, XWBRich20{, ActiveX}; //, {OleServer;}

{ TODO : remove units from directory:  APi, xuesap_TLB, fRPCBTimer, fConfirmMapping,  fESSOConf }

type       
  TfrmSignon = class(TForm)
    Panel1: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    verifyCode: TEdit;
    accessCode: TEdit;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Image1: TImage;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblServer: TLabel;
    lblVolume: TLabel;
    lblUCI: TLabel;
    lblPort: TLabel;
    introText: TXWBRichEdit;
    cbxChangeVerifyCode: TCheckBox;
    RpcbiBroker: TRPCBroker;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure introTextURLClick(Sender: TObject; URL: String);
   private
     FChngVerify: Boolean;     // indicates whether user has requested changing verify code
     OrigHelp : String;        //Help filename of calling application.
     function DoVerify: Boolean;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
   public
     DefaultSignonConfiguration: TSignonValues;
public
end;

procedure PrepareSignonForm(AppBroker: TRPCBroker);
function  SetUpSignOn : Boolean; overload;

var
  frmSignon: TfrmSignon;
  intDeviceLock: integer;
  LoginfrmSignOnBroker: TRPCBroker;

Const
  SC_Configure = 1;
  SC_About = 2;

implementation


uses
  RpcSlogin, VCEdit, fRPCBErrMsg, RpcConf1, XlfSid;  // XlfSid added 051219  JLI

var
  SysMenu: HMenu;

{$R *.DFM}

procedure PrepareSignonForm(AppBroker: TRPCBroker);
begin
  LoginfrmSignonBroker := AppBroker;
end;

function SetUpSignOn: Boolean;
begin
  Result := True;       //By default Signon is needed.
  if LoginfrmSignonBroker = nil then LoginfrmSignonBroker := frmSignon.RpcbiBroker;
  {SignonBroker superseeds RpcbiBroker}
  with frmSignon do
  begin
    try
    with LoginfrmSignonBroker do
    begin
      if not (LoginfrmSignonBroker.SecurityPhrase = '') then
      begin
        with Param[0] do              // start BSE JLI 060130
        begin
          Value := '-35^' + Encrypt(LoginfrmSignonBroker.SecurityPhrase);
          PType := literal;
        end;    // with               //  end BSE  JLI 060130
      end
           //  following lines added 051219  JLI
      else with Param[0] do
      begin
        Ptype := literal;
        Value := Encrypt(GetNTLogonSid);
      end;
      RemoteProcedure := 'XUS SIGNON SETUP';
           //   end of addition 051219  JLI
      Call;
    end;
    except                  {P4}
      frmSignon.Free;    {P4}  // Release  jli 041104
      exit;                 {P4}
    end;                    {P4}
    lblServer.Caption := LoginfrmSignonBroker.Results[0];
    lblVolume.Caption := LoginfrmSignonBroker.Results[1];
    lblUCI.Caption    := LoginfrmSignonBroker.Results[2];
    lblPort.Caption   := LoginfrmSignonBroker.Results[3];
    intDeviceLock   := 0;
    if LoginfrmSignonBroker.Results.Count > 5 then    //Server sent single signon info.
      if LoginfrmSignonBroker.Results[5] = '1' then   //Signon not needed
        Result := False
      else
        Result := True;
    LoginfrmSignonBroker.Login.IsProductionAccount := False;
    LoginfrmSignonBroker.Login.DomainName := '';
    if LoginfrmSignonBroker.Results.Count > 7 then
    begin
      LoginfrmSignonBroker.Login.DomainName := LoginfrmSignonBroker.Results[6];
      if LoginfrmSignonBroker.Results[7] = '1' then
        LoginfrmSignonBroker.Login.IsProductionAccount := True;
    end;
  end;
end;

{--------------------- TfrmSignon.btnOkClick ---------------------
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
------------------------------------------------------------------}
procedure TfrmSignon.btnOkClick(Sender: TObject);
var
  I: integer;
begin
  frmSignon.Tag := 0;          {initialize signon flag}
  try    //P4
  with LoginfrmSignonBroker do begin
    with Param[0] do begin
      Value := Encrypt(accessCode.text + ';' + verifyCode.text);
      PType := literal;
    end;
    RemoteProcedure := 'XUS AV CODE';
    Call;

    {Device is locked -- too many failures}
    if Results[1] = '1' then
    begin
      RPCBShowErrMsg(Results[3]);
      Close;
    end

    {Verify code must change}
    else if Results[2] = '1' then
    begin
      MessageDlg('You must change your VERIFY CODE at this time.',
                   mtWarning, [mbOK], 0);         //Notify that VC must change.
      if DoVerify then
        frmSignon.Tag := 1;                               //VC changed -> OK
      Close;
         {Note: if VC change necessary and it wasn't made,
               Tag remains 0 meaning unsuccessful signon.}
    end

    {Signon failed for some other reason}
    else if Results[0] = '0' then
    begin
      accessCode.text := '';
      verifyCode.text := '';
      RPCBShowErrMsg(Results[3]);
      accessCode.SetFocus;                        //Try again.
    end

    {Signon succeeded.}
    else
    begin
      frmSignon.Tag := 1;    {set flag that signon was good}
          {display any server greeting messages}

      if cbxChangeVerifyCode.Checked then
        DoVerify;
      if Results.Count > 5 then
      begin
        if Results[5] <> '0' then
        begin
          frmSignonMsg := TfrmSignonMsg.Create(Self);
          try
            with frmSignonMsg do begin
              for I := 1 to StrToInt(Results[5]) do
                mmoMsg.Lines.Add(Results[5+I]);
              ShowApplicationAndFocusOK(Application);
              ShowModal;
            end;
          finally
            frmSignonMsg.Free;  // Release;  jli 041104
          end;
        end;
      end;
      Close;
    end;
   end;
  except                   //P4
    btnCancelClick(self);  //P4
  end;                     //P4
end;

procedure TfrmSignon.btnCancelClick(Sender: TObject);
begin
  LoginfrmSignOnBroker.Login.ErrorText := 'User Cancelled Login Process';
  Close;
end;

procedure TfrmSignon.FormShow(Sender: TObject);
var
  Str: String;
begin
  Str := 'RPCBroker';
  {add Configure... to system menu}
  SysMenu := GetSystemMenu(Handle, False);
  AppendMenu(SysMenu, MF_Enabled + MF_String + MF_Unchecked, SC_Configure,
             '&Properties...');
  AppendMenu(SysMenu, MF_Enabled + MF_String + MF_Unchecked, SC_About,PChar('&About '+Str));
  with LoginfrmSignonBroker do begin
    RemoteProcedure := 'XUS INTRO MSG';
    lstCall(introText.Lines);
  end;
  OrigHelp := Application.HelpFile;             // Save original helpfile.
  Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
                           '\clagent.hlp';      // Identify ConnectTo helpfile.
end;

procedure TfrmSignon.FormCreate(Sender: TObject);
var
  SignonConfiguration: TSignonConfiguration;
begin
  if Pos('RPCSharedBrokerSessionMgr',ParamStr(0)) > 0 then
    IsSharedBroker := True;

  if (Pos('LARGE',UpperCase(ReadRegDataDefault(HKCU, 'Control Panel\Appearance', 'Current',''))) > 0) or
     (Screen.Width < 800) then
  begin
    WindowState := wsMaximized;
    with Screen do
    begin
      if Width < 700 then              // 640
        IntroText.Font.Size := 9
      else if Width < 750 then         // 720
        IntroText.Font.Size := 10
      else if Width < 900 then         // 800
        IntroText.Font.Size := 11
      else if Width < 1100 then        // 1024
        IntroText.Font.Size := 15
      else if Width < 1200 then        // 1152
        IntroText.Font.Size := 16
      else
        IntroText.Font.Size := 19;     // 1280
    end;    // with
  end;

  FormStyle := fsStayOnTop;   // make form stay on top of others so it can be found
  {adjust appearance per user's preferences}
  SignonConfiguration := TSignonConfiguration.Create;
  try
    DefaultSignonConfiguration := TSignOnValues.Create;
    DefaultSignonConfiguration.BackColor := IntroText.Color;
    DefaultSignonConfiguration.Height := Height;
    DefaultSignonConfiguration.Width := Width;
    DefaultSignonConfiguration.Position := '0';
    DefaultSignonConfiguration.Size := '0';
    DefaultSignonConfiguration.Left := Left;
    DefaultSignonConfiguration.Top := Top;
    DefaultSignonConfiguration.Font := IntroText.Font;
    DefaultSignonConfiguration.TextColor := IntroText.Font.Color;
    DefaultSignonConfiguration.FontStyles := IntroText.Font.Style;
    SignonDefaults.SetEqual(DefaultSignonConfiguration);


    SignonConfiguration.ReadRegistrySettings;
    if InitialValues.Size = '0' then
    begin  {restore defaults}
      Width:= DefaultSignonConfiguration.Width;
      Height := DefaultSignonConfiguration.Height;
    end
    else begin
      try
        Position := poDesigned;
        Width := StrToInt(Piece(strSize,U,2));
        Height := StrToInt(Piece(strSize,U,3));
      except
        Width:= DefaultSignonConfiguration.Width;
        Height := DefaultSignonConfiguration.Height;
      end;
    end;

    if InitialValues.Position = '0' then {restore defaults}
      Position := poScreenCenter
    else begin
      try
        Top:= StrToInt(Piece(strPosition,U,2));
        Left := StrToInt(Piece(strPosition,U,3));
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
    SignonConfiguration.Free;
  end;
  FChngVerify := False;
end;

procedure TfrmSignon.WMSysCommand(var Message: TWMSysCommand);
var
  Str: String;
  SignonConfiguration: TSignonConfiguration;
  frmErrMsg: TfrmErrMsg;
begin
  if Message.CmdType = SC_Configure then
  begin
    if IsSharedBroker then
      Self.WindowState := wsMinimized;
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
      Str := 'RPCBroker Version is '+RpcbiBroker.BrokerVersion;
      frmErrMsg.mmoErrorMessage.Lines.Add(Str);
      ShowApplicationAndFocusOK(Application);
      frmErrMsg.ShowModal;
    finally
      frmErrMsg.Free;
    end;
  end
  else inherited;
end;

procedure TfrmSignon.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Piece(strSize,U,1) = '2' then begin
    strSize := '2^'+IntToStr(Width)+ U + IntToStr(Height);
    WriteRegData(HKCU, REG_SIGNON, 'SignonSiz', strSize);
  end;

  if Piece(strPosition,U,1) = '2' then begin
    strPosition := '2^'+IntToStr(Top)+ U + IntToStr(Left);
    WriteRegData(HKCU, REG_SIGNON, 'SignonPos', strPosition);
  end;
  Application.HelpFile := OrigHelp;  // Restore helpfile.
end;

procedure TfrmSignon.introTextURLClick(Sender: TObject; URL: String);
begin
  ShellExecute(Application.Handle,'open',PChar(URL),nil,nil,SW_NORMAL);
end;

function TfrmSignon.DoVerify: Boolean;
var
  VCEdit1: TVCEdit;
begin
  VCEdit1 := TVCEdit.Create(Self);
  try
    VCEdit1.RPCBroker := LoginfrmSignonBroker;
    Result := VCEdit1.ChangeVCKnowOldVC(VerifyCode.Text);  //invoke VCEdit form.
  finally
    VCEdit1.Free;
  end;
end;

end.


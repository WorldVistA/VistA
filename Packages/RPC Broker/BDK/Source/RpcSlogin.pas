{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Joel Ivey
	Description: Silent Login functionality.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit RpcSLogin;

interface

Uses
Sysutils, Classes, Messages, WinProcs, IniFiles,
Dialogs, Registry,
trpcb{, ccowrpcbroker};


{------ TVistaSession------}     //hold attributes of a session {p13}
{TVistaSession = class(TObject)
private
  FServerIPAddress: string;
  FDateTimeLogin: String;
  FPollingInterval: integer;
public
  property ServerIPAddresss: String;
  property DateTimeLogin: String;
  property PollingInterval (BAT): integer;
  procedure CreateHandle;
  function  ValidateHandle;
end; }

function SilentLogIn(SLBroker: TRPCBroker): boolean;
procedure GetUserInfo(ConnectedBroker: TRPCBroker);
procedure GetSessionInfo(ConnectedBroker: TRPCBroker);
// 080620 added WindowType argument to StartProgSLogin with SW_NORMAL as default
// to allow SSH startup to specify a minimized window
//procedure StartProgSLogin(const ProgLine: String; ConnectedBroker: TRPCBroker);
procedure StartProgSLogin(const ProgLine: String; ConnectedBroker: TRPCBroker; WindowType: Integer = SW_SHOWNORMAL);
function CheckCmdLine(SLBroker: TRPCBroker): Boolean;

implementation

uses wsockc, loginfrm, rpcberr, seldiv, hash;

//validate a/v codes
function ValidAVCodes(SLBroker: TRPCBroker): boolean;
begin
  try
    with SLBroker do
    begin
      Param[0].Value := Encrypt(LogIn.AccessCode + ';' + LogIn.VerifyCode);
      Param[0].PType := literal;
      RemoteProcedure := 'XUS AV CODE';
      Call;
      if Results[0] > '0' then
      begin
        Login.DUZ := Results[0];
        Result := True;
      end
      else
      begin
        Result := False;
        if Results[2] = '1' then Login.ErrorText := 'Expired Verify Code' //vcode needs changing;
        else if Results[0] = '0' then Login.ErrorText :='Invalid Access/Verify Codes' //no valid DUZ returned;
        else Login.ErrorText := Results[3];
      end;
    end;
  except
    raise
  end;
end;

//validate application Handle
function ValidAppHandle(SLBroker: TRPCBroker): boolean;
begin
  Result := False;
  try
    with SLBroker do
    begin
      Param[0].Value := SLBroker.Login.LogInHandle;
      Param[0].PType := literal;
      RemoteProcedure := 'XUS AV CODE';
      Call;
//      if StrToInt(SLBroker.Results[0]) > 0 then // JLI 050510
//      if Pos(SLBroker.Results[0][1],'123456789') > 0 then
      if Pos(Copy(SLBroker.Results[0],1,1),'123456789') > 0 then
      begin
        Login.DUZ := Results[0];
        Result := True;
      end
      else if Results[2] = '1' then Login.ErrorText := 'Expired Verify Code' //vcode needs changing;
      else if Results[0] = '0' then Login.ErrorText :='Invalid Access/Verify Codes' //no valid DUZ returned;
      else Login.ErrorText := Results[3];
    end;
  except
    raise
  end;
end;

function ValidNTToken(SLBroker: TRPCBroker): boolean;
begin
  Result := False;
end;

{IF 2, PASS CONTROL TO AUTHENTICATION PROXY - WHAT DOES IT NEED? }

{:
This function is used to initiate a silent login with the RPCBroker.  It uses the information
stored in the Login property of the TRPCBroker to make the connection.
}
function SilentLogIn(SLBroker: TRPCBroker): boolean;
begin
  Result := False;
  //determine if signon is needed
  try
    with SLBroker do begin
      RemoteProcedure := 'XUS SIGNON SETUP';
      Call;
      SLBroker.Login.IsProductionAccount := False;
      SLBroker.Login.DomainName := '';
      if SLBroker.Results.Count > 7 then
      begin
        SLBroker.Login.DomainName := SLBroker.Results[6];
        if SLBroker.Results[7] = '1' then
          SLBroker.Login.IsProductionAccount := True;
      end;
      if Results.Count > 5 then    //Server sent auto signon info.
        if SLBroker.Results[5] = '1' then   //User already logged in
        begin
          Result := True;
          GetUserInfo(SLBroker);
          exit;
        end;
      if Login.Mode = lmAVCodes then //Access & Verify codes authentication
        if ValidAVCodes(SLBroker) then Result := True;
      if Login.Mode = lmAppHandle then
        if ValidAppHandle(SLBroker)then Result := True;
      if Login.Mode = lmNTToken then
          if ValidNTToken(SLBroker) then Result := True;
//      if Result and (not (SLBroker is TCCOWRPCBroker)) then
      IF Result and (SLBroker.Contextor = nil) then
      begin
        //determine if user is multidivisional - makes calls to Seldiv.
        LogIn.MultiDivision := MultDiv(SLBroker);
        if not LogIn.MultiDivision then
          begin
          Result := True;
          exit;
          end;
        if LogIn.PromptDivision then
          Result := SelectDivision(LogIn.DivList, SLBroker)
        else if Login.Division <> '' then
          Result := SetDiv(Login.Division, SLBroker)
        else
        begin
          Result := False;
          Login.ErrorText := 'No Division Selected';
        end;
        if not Result then
          exit;
      end;
      if Result then
        GetUserInfo(SLBroker);
    end;
  except
    exit;
  end;
end;

procedure GetUserInfo(ConnectedBroker: TRPCBroker); //get info for TVistaUser;
begin
  with ConnectedBroker do
  begin
    try
    RemoteProcedure := 'XUS GET USER INFO';
    Call;
    if Results.Count > 0 then
      with ConnectedBroker.User do
        begin
        DUZ := Results[0];
        Name := Results[1];
        StandardName := Results[2];
        Division := Results[3];
        Title := Results[4];
        ServiceSection := Results[5];
        Language := Results[6];
        DTime := Results[7];
        if Results.Count > 8 then
          Vpid := Results[8]
         else
          Vpid := '';
        end;
    except
    end;
  end;
end;

procedure GetSessionInfo(ConnectedBroker: TRPCBroker); //get info for TVistaSession;
begin
  with ConnectedBroker do   //get info for TVistaSession;
  begin
    try
    RemoteProcedure := 'XWB GET SESSION INFO';
    Call;
    if Results.Count > 0 then
      begin
      {VistaSession.Create;
      with VistaSession do
        begin
        DUZ := Results[0]
        //other properties follow
        end;}
      end;
    except
    end;
    end;
end;

{:
This procedure can be used to start a second application and pass on the command line the data
which would be needed to initiate a silent login using a LoginHandle value.  It is assumed that
the command line would be read using the CheckCmdLine procedure or one similar to it as the form
for the new application was loaded.  This procedure can also be used to start a non-RPCBroker 
application. If the value for ConnectedBroker is nil, the application specified in ProgLine 
will be started and any command line included in ProgLine will be passed to the application.
}
procedure StartProgSLogin(const ProgLine: String; ConnectedBroker: TRPCBroker; WindowType: Integer = SW_SHOWNORMAL);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppHandle: String;
  CmndLine: String;
  //
  currHandle1: THandle;
begin
  currHandle1 := GetCurrentProcess;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
// 080620 - removed code specific to SSH, replaced with new
//          parameter to specify window type with default of
//          SW_SHOWNORMAL
{  
    wShowWindow := SW_SHOWNORMAL;
    // 080618 following added to minimize SSH command box
    if (Pos('SSH2',ProgLine) = 1) then
      wShowWindow := SW_SHOWMINIMIZED;
}
    WShowWindow := WindowType;
  end;
  CmndLine := ProgLine;
  if ConnectedBroker <> nil then
  begin
    AppHandle := GetAppHandle(ConnectedBroker);
    CmndLine := CmndLine + ' s='+ConnectedBroker.Server + ' p='
                         + IntToStr(ConnectedBroker.ListenerPort) + ' h=' 
                         + AppHandle + ' d=' + ConnectedBroker.User.Division;
  end;
  CreateProcess(nil, PChar(CmndLine), nil, nil, False,
      NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo);
  // 080618 following added to handle closing of command box for SSH
  CommandBoxProcessHandle := ProcessInfo.hProcess;
  CommandBoxThreadHandle := ProcessInfo.hThread;
  // 080618 make broker window active again, so user can type immediately
  SetActiveWindow(currHandle1);
end;

{:
This procedure can be used to check whether the command line contains information on the broker 
settings and can setup for a Silent Login using the LoginHandle value passed from another application.  
This procedure would normally be called within the code associated with FormCreate event.  It assumes
the Server, ListenerPort, Division, and LoginHandle values (if present) are indicated by s=, p=, d=, and
h=, respectively.  The argument is a reference to the TRPCBroker instance to be used.
}
function CheckCmdLine(SLBroker: TRPCBroker): Boolean;
var
 j: Integer;
begin
  with SLBroker do
  begin
    for j := 1 to ParamCount do    // Iterate through possible command line arguments
    begin
      if Pos('p=',ParamStr(j)) > 0 then
        ListenerPort := StrToInt(Copy(ParamStr(j),
                         (Pos('=',ParamStr(j))+1),length(ParamStr(j))));
      if Pos('s=',ParamStr(j)) > 0 then
        Server := Copy(ParamStr(j),
                         (Pos('=',ParamStr(j))+1),length(ParamStr(j)));
      if Pos('h=',ParamStr(j)) > 0 then
      begin
        Login.LoginHandle := Copy(ParamStr(j),
                         (Pos('=',ParamStr(j))+1),length(ParamStr(j)));
        if Login.LoginHandle <> '' then
        begin
          KernelLogin := False;
          Login.Mode := lmAppHandle;
        end;
      end;
      if Pos('d=',ParamStr(j)) > 0 then
        Login.Division := Copy(ParamStr(j),
                         (Pos('=',ParamStr(j))+1),length(ParamStr(j)));
    end;    // for
    if Login.Mode = lmAppHandle then
      Connected := True;      // Go ahead and make the connection
    Result := False;
    if Connected then
      Result := True;
  end;    // with SLBroker
end;


end.



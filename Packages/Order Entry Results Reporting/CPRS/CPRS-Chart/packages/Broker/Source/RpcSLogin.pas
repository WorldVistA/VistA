{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: RpcSLogin Silent Login functionality.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 11/17/2016) XWB*1.1*65
  1. Added new Silent Login mode for Identity and Access Management (IAM)
  Single Sign-On (lmSSOi).
  2. In function SilentLogin, ASOSKIP (Param[1]) is set to 1 to disable
  Client Agent (ClAgent.exe) callback (deprecated).
  3. Commented out (but did not yet remove) login mode lmNTToken, as it
  was not fully implemented.

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. None.

  Changes in v1.1.50 (JLI 09/01/2011) XWB*1.1*50
  1. Updates to support SSH.
  ************************************************** }
unit RpcSLogin;

interface

{$I IISBase.inc}

uses
  {System}
  SysUtils, Classes, IniFiles, Registry, AnsiStrings,
  {WinApi}
  Messages, WinProcs,
  {VA}
  Trpcb,
  {Vcl}
  Vcl.Dialogs;

function SilentLogIn(SLBroker: TRPCBroker): boolean;
procedure GetUserInfo(ConnectedBroker: TRPCBroker);
procedure GetSessionInfo(ConnectedBroker: TRPCBroker);
procedure StartProgSLogin(const ProgLine: String; ConnectedBroker: TRPCBroker;
  WindowType: Integer = SW_SHOWNORMAL);
function CheckCmdLine(SLBroker: TRPCBroker): boolean;

implementation

uses
  {VA}
  Wsockc, Loginfrm, RpcbErr, SelDiv, XWBHash;

{ ------------------------ ValidAVCodes ---------------------------
  Authenticate user with Access/Verify Codes or ASO token using
  an RPC call to 'XUS AV CODE'
  ------------------------------------------------------------------ }
function ValidAVCodes(SLBroker: TRPCBroker): boolean;
begin
  //Result := False;
  try
    with SLBroker do
    begin
      Param[0].Value := Encrypt(LogIn.AccessCode + ';' + LogIn.VerifyCode);
      Param[0].PType := literal;
      RemoteProcedure := 'XUS AV CODE';
      Call;
      if Results[0] > '0' then
      begin
        LogIn.DUZ := Results[0];
        LogIn.PromptDivision := True;
        Result := True;
      end
      else
      begin
        Result := False;
        if Results[2] = '1' then
          LogIn.ErrorText := 'Expired Verify Code' // vcode needs changing;
        else if Results[0] = '0' then
          LogIn.ErrorText := 'Invalid Access/Verify Codes'
          // no valid DUZ returned;
        else
          LogIn.ErrorText := Results[3];
      end;
    end;
  except
    raise
  end;
end; // function ValidAVCodes

{ ------------------------ ValidAppHandle -------------------------
  Authenticate user with Application Handle (CCOW Token)
  using an RPC call to 'XUS AV CODE'
  ------------------------------------------------------------------ }
function ValidAppHandle(SLBroker: TRPCBroker): boolean;
begin
  Result := False;
  try
    with SLBroker do
    begin
      Param[0].Value := SLBroker.LogIn.LogInHandle;
      Param[0].PType := literal;
      RemoteProcedure := 'XUS AV CODE';
      Call;
      if Pos(Copy(SLBroker.Results[0], 1, 1), '123456789') > 0 then
      begin
        LogIn.DUZ := Results[0];
        LogIn.PromptDivision := False;
        Result := True;
      end
      else if Results[2] = '1' then
        LogIn.ErrorText := 'Expired Verify Code' // vcode needs changing;
      else if Results[0] = '0' then
        LogIn.ErrorText := 'Invalid Access/Verify Codes'
        // no valid DUZ returned;
      else
        LogIn.ErrorText := Results[3];
    end;
  except
    raise
  end;
end; // function ValidAppHandle

{ ------------------------ ValidNTToken ---------------------------
  Authenticate user with NT Kerberos token (not implemented)
  ------------------------------------------------------------------ }
// function ValidNTToken(SLBroker: TRPCBroker): boolean;
// begin
// Result := False;
// end; //function ValidNTToken

{ ------------------------ ValidSSOiToken -------------------------
  Authenticate user with STS SAML Token from IAM using
  an RPC call to 'XUS ESSO VALIDATE'
  ------------------------------------------------------------------ }
function ValidSSOiToken(SLBroker: TRPCBroker): boolean;
var
  I, iStart, iEnd: Integer;
  uToken: String;
  iTokenLength: Integer;
begin
  //Result := False;
  try
    with SLBroker do
    begin
      uToken := LogIn.LogInHandle;
      iTokenLength := Length(uToken);
      RemoteProcedure := 'XUS ESSO VALIDATE';
      Param[0].PType := global;
      with Param[0] do
      begin
        I := 0;
        iEnd := 0;
        while (iEnd < iTokenLength) do
        begin
          // Build Param[0] global, 200 chars per node
          iStart := (I * 200) + 1;
          iEnd := iStart + 199;
          Mult[IntToStr(I)] := Copy(uToken, iStart, 200);
          I := I + 1;
        end;
      end;
      Call;
      if Results[0] > '0' then
      begin
        LogIn.DUZ := Results[0];
        LogIn.PromptDivision := True;
        Result := True;
      end
      else
      begin
        Result := False;
        if Results[2] = '1' then
          LogIn.ErrorText := 'Expired Verify Code' // vcode needs changing;
        else if Results[0] = '0' then
          LogIn.ErrorText := 'Invalid 2-Factor Authentication'
          // no valid DUZ returned;
        else
          LogIn.ErrorText := Results[3];
      end;
    end;
  except
    raise
  end;
end; // function ValidSSOiToken

{ ------------------------ SilentLogIn -------------------------
  Authenticate user with credentials passed as parameters.
  ------------------------------------------------------------------ }
function SilentLogIn(SLBroker: TRPCBroker): boolean;
begin
  Result := False;
  // determine if signon is needed
  try
    with SLBroker do
    begin
      RemoteProcedure := 'XUS SIGNON SETUP';
      Param[0].Value := ''; // No AppHandle for silent login
      Param[0].PType := literal;
      Param[1].Value := '1'; // Disable Client Agent callback
      Param[1].PType := literal;
      Call;
      SLBroker.LogIn.IsProductionAccount := False;
      SLBroker.LogIn.DomainName := '';
      if SLBroker.Results.Count > 7 then
      begin
        SLBroker.LogIn.DomainName := SLBroker.Results[6];
        if SLBroker.Results[7] = '1' then
          SLBroker.LogIn.IsProductionAccount := True;
      end;
      if Results.Count > 5 then // Server sent auto signon info.
        if SLBroker.Results[5] = '1' then // User already logged in
        begin
          Result := True;
          GetUserInfo(SLBroker);
          exit;
        end;
      if LogIn.Mode = lmSSOi then // STS SAML token authentication
        if ValidSSOiToken(SLBroker) then
          Result := True;
      if LogIn.Mode = lmAVCodes then // Access & Verify codes authentication
        if ValidAVCodes(SLBroker) then
          Result := True;
      if LogIn.Mode = lmAppHandle then
        if ValidAppHandle(SLBroker) then
          Result := True;
      if Result and (SLBroker.Contextor = nil) and not(LogIn.Mode = lmSSOi) then
      begin
        // determine if user is multidivisional - makes calls to Seldiv.
        LogIn.MultiDivision := MultDiv(SLBroker);
        if not LogIn.MultiDivision then
        begin
          Result := True;
          exit;
        end;
        if LogIn.PromptDivision then
          Result := SelectDivision(LogIn.DivList, SLBroker)
        else if LogIn.Division <> '' then
          Result := SetDiv(LogIn.Division, SLBroker)
        else
        begin
          Result := False;
          LogIn.ErrorText := 'No Division Selected';
        end;
        if not Result then
          exit;
      end;
    end;
  except
    exit;
  end;
end; // function SilentLogIn

{ ------------------------ GetUserInfo -------------------------
  Get information for TVistaUser class (Tobject) using
  RPC 'XUS GET USER INFO'
  ------------------------------------------------------------------ }
procedure GetUserInfo(ConnectedBroker: TRPCBroker);
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
end; // procedure GetUserInfo

{ ------------------------ GetSessionInfo -------------------------
  Get information for TVistaSession class (Tobject) using
  RPC 'XUS GET SESSION INFO'
  ------------------------------------------------------------------ }
procedure GetSessionInfo(ConnectedBroker: TRPCBroker);
begin
  with ConnectedBroker do
  begin
    try
      RemoteProcedure := 'XWB GET SESSION INFO';
      Call;
      if Results.Count > 0 then
      begin
        { VistaSession.Create;
          with VistaSession do
          begin
          DUZ := Results[0]
          //other properties follow
          end; }
      end;
    except
    end;
  end;
end; // procedure GetSessionInfo

{ ------------------------ StartProgSLogin -------------------------
  This procedure can be used to start a second application and pass on the
  command line the data which would be needed to initiate a silent login
  using a LoginHandle value.  It is assumed that the command line would be
  read using the CheckCmdLine procedure or one similar to it as the form
  for the new application was loaded.  This procedure can also be used to
  start a non-RPCBroker application. If the value for ConnectedBroker is nil,
  the application specified in ProgLine will be started and any command line
  included in ProgLine will be passed to the application.
  ------------------------------------------------------------------ }
procedure StartProgSLogin(const ProgLine: String; ConnectedBroker: TRPCBroker;
  WindowType: Integer = SW_SHOWNORMAL);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  AppHandle: String;
  CmndLine: String;
  currHandle1: THandle;
begin
  currHandle1 := GetCurrentProcess;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    WShowWindow := WindowType;
  end;
  CmndLine := ProgLine;
  if ConnectedBroker <> nil then
  begin
    AppHandle := GetAppHandle(ConnectedBroker);
    CmndLine := CmndLine + ' s=' + ConnectedBroker.Server + ' p=' +
      IntToStr(ConnectedBroker.ListenerPort) + ' h=' + AppHandle + ' d=' +
      ConnectedBroker.User.Division;
  end;
  CreateProcess(nil, PChar(CmndLine), nil, nil, False, NORMAL_PRIORITY_CLASS,
    nil, nil, StartupInfo, ProcessInfo);
  CommandBoxProcessHandle := ProcessInfo.hProcess;
  CommandBoxThreadHandle := ProcessInfo.hThread;
  SetActiveWindow(currHandle1);
end; // procedure StartProgSLogin

{ ------------------------ CheckCmdLine --------------------------
  This function can be used to check whether the command line contains
  information on the broker settings and can setup for a Silent Login using
  the LoginHandle value passed from another application. This procedure
  would normally be called within the code associated with FormCreate event.
  It assumes the Server, ListenerPort, Division, and LoginHandle values
  (if present) are indicated by s=, p=, d=, and h=, respectively.  The
  argument is a reference to the TRPCBroker instance to be used.
  ------------------------------------------------------------------ }
function CheckCmdLine(SLBroker: TRPCBroker): boolean;
var
  j: Integer;
begin
  with SLBroker do
  begin
    for j := 1 to ParamCount do
    // Iterate through possible command line arguments
    begin
      if Pos('p=', ParamStr(j)) > 0 then
        ListenerPort := StrToInt(Copy(ParamStr(j), (Pos('=', ParamStr(j)) + 1),
          Length(ParamStr(j))));
      if Pos('s=', ParamStr(j)) > 0 then
        Server := Copy(ParamStr(j), (Pos('=', ParamStr(j)) + 1),
          Length(ParamStr(j)));
      if Pos('h=', ParamStr(j)) > 0 then
      begin
        LogIn.LogInHandle := Copy(ParamStr(j), (Pos('=', ParamStr(j)) + 1),
          Length(ParamStr(j)));
        if LogIn.LogInHandle <> '' then
        begin
          KernelLogin := False;
          LogIn.Mode := lmAppHandle;
        end;
      end;
      if Pos('d=', ParamStr(j)) > 0 then
        LogIn.Division := Copy(ParamStr(j), (Pos('=', ParamStr(j)) + 1),
          Length(ParamStr(j)));
    end; // for
    if LogIn.Mode = lmAppHandle then
      Connected := True; // Go ahead and make the connection
    Result := False;
    if Connected then
      Result := True;
  end; // with SLBroker
end; // function CheckCmdLine

end.

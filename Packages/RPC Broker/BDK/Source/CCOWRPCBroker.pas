{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Contains TRPCBroker and related components.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008)
*************************************************************** }

{**************************************************
This is the hierarchy of things:
   TRPCBroker contains
      TParams, which contains
         array of TParamRecord each of which contains
                  TMult

v1.1*4 Silent Login changes (DCM) 10/22/98

1.1*6 Polling to support terminating arphaned server jobs. (P6)
      == DPC 4/99

1.1*8 Check for Multi-Division users. (P8) - REM 7/13/99

1.1*13 More silent login code; deleted obsolete lines (DCM) 9/10/99  // p13
LAST UPDATED: 5/24/2001   // p13  JLI

1.1*31 Added new read only property BrokerVersion to TRPCBroker which
       should contain the version number for the RPCBroker
       (or SharedRPCBroker) in use.
**************************************************}
unit CCOWRPCBroker;

interface

{$I IISBase.inc}

uses
  {Delphi standard}
  Classes, Controls, Dialogs, {DsgnIntf,} Forms, Graphics, Messages, SysUtils,
  WinProcs, WinTypes, Windows,
  extctrls, {P6}
  {VA}
  XWBut1, {RpcbEdtr,} MFunStr, Hash,
  ComObj, ActiveX, OleCtrls, trpcb,
    VERGENCECONTEXTORLib_TLB;

const
  NoMore: boolean = False;
  MIN_RPCTIMELIMIT: integer = 30;
  CURRENT_RPC_VERSION: String = 'XWB*1.1*36T1';

type

TCCOWRPCBroker = class(TRPCBroker)
private
protected
  FCCOWLogonIDName: String;
  FCCOWLogonIDValue: String;
  FCCOWLogonName: String;
  FCCOWLogonNameValue: String;
  FContextor: TContextorControl;  //CCOW
  FCCOWtoken: string;              //CCOW
  FVistaDomain: String;
  FCCOWLogonVpid: String;
  FCCOWLogonVpidValue: String;
  FWasUserDefined: Boolean;
//  procedure   SetConnected(Value: Boolean); override;
  function  GetCCOWHandle(ConnectedBroker: TCCOWRPCBroker): string;
  procedure CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor:
    TContextorControl);
  function  GetCCOWduz( Contextor: TContextorControl): string;
public
  function GetCCOWtoken(Contextor: TContextorControl): string;
  function IsUserCleared: Boolean;
  function WasUserDefined: Boolean;
  function IsUserContextPending(aContextItemCollection: IContextItemCollection):
      Boolean;
  property   Contextor: TContextorControl
                          read Fcontextor write FContextor;  //CCOW
  property CCOWLogonIDName: String read FCCOWLogonIDName;
  property CCOWLogonIDValue: String read FCCOWLogonIDValue;
  property CCOWLogonName: String read FCCOWLogonName;
  property CCOWLogonNameValue: String read FCCOWLogonNameValue;
  property CCOWLogonVpid: String read FCCOWLogonVpid;
  property CCOWLogonVpidValue: String read FCCOWLogonVpidValue;
published
  property    Connected: boolean read FConnected write SetConnected;
 end;

procedure AuthenticateUser(ConnectingBroker: TCCOWRPCBroker);

implementation

uses
  Loginfrm, RpcbErr, WSockc, SelDiv{p8}, RpcSLogin{p13}, fRPCBErrMsg,
  CCOW_const;

var
  CCOWToken: String;
  Domain: String;
  PassCode1: String;
  PassCode2: String;


{--------------------- TCCOWRPCBroker.SetConnected --------------------
------------------------------------------------------------------
procedure TCCOWRPCBroker.SetConnected(Value: Boolean);
var
  BrokerDir, Str1, Str2, Str3 :string;
  RPCBContextor: TContextorControl;
  UseSSH: TSecure;
  ParamVal: String;
  ParamNum: Integer;
  PseudoServer: String;
  PseudoPortStr: String;
  PseudoPort: Integer;
begin
  RPCBError := '';
  Login.ErrorText := '';
  if (Connected <> Value) and not(csReading in ComponentState) then begin
    if Value and (FConnecting <> Value) then begin                 {connect
      FSocket := ExistingSocket(Self);
      FConnecting := True; // FConnected := True;
      try
        if FSocket = 0  then
        begin
          {Execute Client Agent from directory in Registry.
          BrokerDir := ReadRegData(HKLM, REG_BROKER, 'BrokerDr');
          if BrokerDir <> '' then
            ProcessExecute(BrokerDir + '\ClAgent.Exe', sw_ShowNoActivate)
          else
            ProcessExecute('ClAgent.Exe', sw_ShowNoActivate);
          if DebugMode and (not OldConnectionOnly) then
          begin
            Str1 := 'Control of debugging FOR UCX OR NON-CALLBACK CONNECTIONS has been moved from the client to the server. To start a Debug session, do the following:'+#13#10#13#10;
            Str2 := '1. On the server, set initial breakpoints where desired.'+#13#10+'2. DO DEBUG^XWBTCPM.'+#13#10+'3. Enter a unique Listener port number (i.e., a port number not in general use).'+#13#10;
            Str3 := '4. Connect the client application using the port number entered in Step #3.';
            ShowMessage(Str1 + Str2 + Str3);
          end;

          CheckSSH;
          if not (FUseSecureConnection = secureNone) then
          begin
            if not StartSecureConnection(PseudoServer, PseudoPortStr) then
              exit;
            //Val(PseudoPortStr,PseudoPort,Code)
            PseudoPort := StrToInt(PseudoPortStr);
          end
          else
          begin
            PseudoPort := ListenerPort;
            PseudoServer := Server;
          end;
            // 060920  end of addition
          TXWBWinsock(XWBWinsock).IsBackwardsCompatible := IsBackwardCompatibleConnection;
          TXWBWinsock(XWBWinsock).OldConnectionOnly := OldConnectionOnly;
          FSocket := TXWBWinsock(XWBWinsock).NetworkConnect(DebugMode, PseudoServer, // {FServer,
                                    PseudoPort {ListenerPort, FRPCTimeLimit);
              //  060919 Prefix added to handle multiple brokers including old and new
{              Prefix := TXWBWinsock(XWBWinsock).Prefix;
              FIsNewStyleConnection := TXWBWinsock(XWBWinsock).IsNewStyle;
          AuthenticateUser(Self);
          StoreConnection(Self);  //MUST store connection before CreateContext()
          //CCOW start
          if (FContextor <> nil) and (length(CCOWtoken) = 0) then
          begin
          //Get new CCOW token
            CCOWToken := GetCCOWHandle(Self);
            if Length(CCOWToken) > 0 then
            begin
              try
                RPCBContextor := TContextorControl.Create(Application);
                RPCBContextor.Run('BrokerLoginModule#', PassCode1+PassCode2, TRUE, '*');
                CCOWsetUser(user.name, CCOWToken, Domain, user.Vpid, RPCBContextor);  //Clear token
                FCCOWLogonIDName := CCOW_LOGON_ID;
                FCCOWLogonIdValue := Domain;
                FCCOWLogonName := CCOW_LOGON_NAME;
                FCCOWLogonNameValue := user.name;
                if user.name <> '' then
                  FWasUserDefined := True;
                FCCOWLogonVpid := CCOW_LOGON_VPID;
                FCCOWLogonVpidValue := user.Vpid;
                RPCBContextor.Free;
                RPCBContextor := nil;
              except
                ShowMessage('Problem with Contextor.Run');
                FreeAndNil(RPCBContextor);
              end;
            end;   // if Length(CCOWToken) > 0
          end;  //if
          //CCOW end
          FPulse.Enabled := True; //P6 Start heartbeat.
          CreateContext('');      //Closes XUS SIGNON context.
        end
        else
        begin                     //p13
          StoreConnection(Self);
          FPulse.Enabled := True; //p13
        end;                      //p13
        FConnected := True;         // jli mod 12/17/01
        FConnecting := False;
        // 080620 If connected via SSH, With no command box
        //        visible, should let users know they have it.
        if not (CommandBoxProcessHandle = 0) then
        begin
          thisOwner := self.Owner;
          if (thisOwner is TForm) then
          begin
            thisParent := TForm(self.Owner);
            if not (Pos('(SSH Secure connection)',thisParent.Caption) > 0) then
              thisParent.Caption := thisParent.Caption + ' (SSH Secure connection)';
          end;
        end;
      except
        on E: EBrokerError do begin
          if E.Code = XWB_BadSignOn then
            TXWBWinsock(XWBWinsock).NetworkDisconnect(FSocket);
          FSocket := 0;
          FConnected := False;
          FConnecting := False;
          if not (CommandBoxProcessHandle = 0) then
                TerminateProcess(CommandBoxProcessHandle,10);
          FRPCBError := E.Message;               // p13  handle errors as specified
          if Login.ErrorText <> '' then
            FRPCBError := E.Message + chr(10) + Login.ErrorText;
          if Assigned(FOnRPCBFailure) then       // p13
            FOnRPCBFailure(Self)                 // p13
          else if ShowErrorMsgs = semRaise then
            Raise;                               // p13
//          raise;   {this is where I would do OnNetError
        end{on;
      end{try;
    end{if
    else if not Value then
    begin                           //p13
      FConnected := False;          //p13
      FPulse.Enabled := False;      //p13
      if RemoveConnection(Self) = NoMore then begin
        {FPulse.Enabled := False;  ///P6;p13
        TXWBWinsock(XWBWinsock).NetworkDisconnect(Socket);   {actually disconnect from server
        FSocket := 0;                {store internal
        //FConnected := False;      //p13
        // 080618 following added to close command box if SSH is being used
        if not (CommandBoxProcessHandle = 0) then
        begin
          TerminateProcess(CommandBoxProcessHandle,10);
          thisOwner := self.Owner;
          if (thisOwner is TForm) then
          begin
            thisParent := TForm(self.Owner);
            if (Pos('(SSH Secure connection)',thisParent.Caption) > 0) then
            begin
              // 080620 remove ' (SSH Secure connection)' on disconnection
              thisParent.Caption := Copy(thisParent.Caption,1,Length(thisParent.Caption)-24);
            end;
          end;
        end;
      end{if;
    end; {else
  end{if;
end;
}
function TCCOWRPCBroker.WasUserDefined: Boolean;
begin
  Result := FWasUserDefined;
end;

function TCCOWRPCBroker.IsUserCleared: Boolean;
var
  CCOWcontextItem: IContextItemCollection;      //CCOW
  CCOWdataItem1: IContextItem;                  //CCOW
  Name: String;
begin
  Result := False;
  Name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
  try
    //See if context contains the ID item
    CCOWcontextItem := Contextor.CurrentContext;
    CCOWDataItem1 := CCowContextItem.Present(Name);
    if (CCOWdataItem1 <> nil) then    //1
    begin
      If CCOWdataItem1.Value = '' then
        Result := True
      else
        FWasUserDefined := True;
    end
    else
      Result := True;
  finally
  end; //try
end;

{------------------------ AuthenticateUser ------------------------
------------------------------------------------------------------}
procedure AuthenticateUser(ConnectingBroker: TCCOWRPCBroker);
var
  SaveClearParmeters, SaveClearResults: boolean;
  SaveParam: TParams;
  SaveRemoteProcedure, SaveRpcVersion: string;
  SaveResults: TStrings;
  blnSignedOn: boolean;
  SaveKernelLogin: boolean;
  SaveVistaLogin: TVistaLogin;
  OldExceptionHandler: TExceptionEvent;
  OldHandle: THandle;
begin
  With ConnectingBroker do
  begin
    SaveParam := TParams.Create(nil);
    SaveParam.Assign(Param);                  //save off settings
    SaveRemoteProcedure := RemoteProcedure;
    SaveRpcVersion := RpcVersion;
    SaveResults := Results;
    SaveClearParmeters := ClearParameters;
    SaveClearResults := ClearResults;
    ClearParameters := True;                  //set'em as I need'em
    ClearResults := True;
    SaveKernelLogin := KernelLogin;     //  p13
    SaveVistaLogin := Login;            //  p13
  end;

  blnSignedOn := False;                       //initialize to bad sign-on
  
  if ConnectingBroker.AccessVerifyCodes <> '' then   // p13 handle as AVCode single signon
  begin
    ConnectingBroker.Login.AccessCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 1);
    ConnectingBroker.Login.VerifyCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 2);
    ConnectingBroker.Login.Mode := lmAVCodes;
    ConnectingBroker.KernelLogIn := False;
  end;

    //CCOW start
    if ConnectingBroker.KernelLogIn and (not (ConnectingBroker.Contextor = nil)) then
    begin
      CCOWtoken := ConnectingBroker.GetCCOWtoken(ConnectingBroker.Contextor);
      if length(CCOWtoken)>0 then
        begin
          ConnectingBroker.FKernelLogIn := false;
          ConnectingBroker.Login.Mode := lmAppHandle;
          ConnectingBroker.Login.LogInHandle := CCOWtoken;
        end;
     end;
     //CCOW end
   //CCOW Start                                // p13  following section for silent signon
  if not ConnectingBroker.FKernelLogIn then
    if ConnectingBroker.FLogin <> nil then     //the user.  vistalogin contains login info
    begin
      blnsignedon := SilentLogin(ConnectingBroker);    // RpcSLogin unit
      if not blnSignedOn then
      begin     //Switch back to Kernel Login
        ConnectingBroker.FKernelLogIn := true;
        ConnectingBroker.Login.Mode := lmAVCodes;
      end;
    end;
   //CCOW end

  if ConnectingBroker.FKernelLogIn then
  begin   //p13
    CCOWToken := '';  //  061201 JLI if can't sign on with Token clear it so can get new one
    if Assigned(Application.OnException) then
      OldExceptionHandler := Application.OnException
    else
      OldExceptionHandler := nil;
    Application.OnException := TfrmErrMsg.RPCBShowException;
    frmSignon := TfrmSignon.Create(Application);
    try

  //    ShowApplicationAndFocusOK(Application);
      OldHandle := GetForegroundWindow;
      SetForegroundWindow(frmSignon.Handle);
      PrepareSignonForm(ConnectingBroker);
      if SetUpSignOn then                       //SetUpSignOn in loginfrm unit.
      begin                                     //True if signon needed

        if frmSignOn.lblServer.Caption <> '' then
        begin
          frmSignOn.ShowModal;                    //do interactive logon   // p13
          if frmSignOn.Tag = 1 then               //Tag=1 for good logon
            blnSignedOn := True;                   //Successfull logon
        end
      end
      else                                      //False when no logon needed
        blnSignedOn := NoSignOnNeeded;          //Returns True always (for now!)
      if blnSignedOn then                       //P6 If logged on, retrieve user info.
      begin
        GetBrokerInfo(ConnectingBroker);
        if not SelDiv.ChooseDiv('',ConnectingBroker) then
        begin
          blnSignedOn := False;//P8
          {Select division if multi-division user.  First parameter is 'userid'
          (DUZ or username) for future use. (P8)}
          ConnectingBroker.Login.ErrorText := 'Failed to select Division';  // p13 set some text indicating problem
        end;
      end;
      SetForegroundWindow(OldHandle);
    finally
      frmSignon.Free;
//      frmSignon.Release;                        //get rid of signon form

//      if ConnectingBroker.Owner is TForm then
//        SetForegroundWindow(TForm(ConnectingBroker.Owner).Handle)
//      else
//        SetForegroundWindow(ActiveWindow);
        ShowApplicationAndFocusOK(Application);
    end ; //try
    if Assigned(OldExceptionHandler) then
      Application.OnException := OldExceptionHandler;
   end;   //if kernellogin
                                                 // p13  following section for silent signon
  if (not ConnectingBroker.KernelLogIn) and (not blnsignedon) then     // was doing the signon twice if already true
    if ConnectingBroker.Login <> nil then     //the user.  vistalogin contains login info
      blnsignedon := SilentLogin(ConnectingBroker);    // RpcSLogin unit
  if not blnsignedon then
  begin
//    ConnectingBroker.Login.FailedLogin(ConnectingBroker.Login);
    TXWBWinsock(ConnectingBroker.XWBWinsock).NetworkDisconnect(ConnectingBroker.Socket);
  end
  else
    GetBrokerInfo(ConnectingBroker);

  //reset the Broker
  with ConnectingBroker do
  begin
    ClearParameters := SaveClearParmeters;
    ClearResults := SaveClearResults;
    Param.Assign(SaveParam);                  //restore settings
    SaveParam.Free;
    RemoteProcedure := SaveRemoteProcedure;
    RpcVersion := SaveRpcVersion;
    Results := SaveResults;
    FKernelLogin := SaveKernelLogin;         // p13
    FLogin := SaveVistaLogin;                // p13
  end;

  if not blnSignedOn then                     //Flag for unsuccessful signon.
    TXWBWinsock(ConnectingBroker.XWBWinsock).NetError('',XWB_BadSignOn);               //Will raise error.

end;

{----------------------- GetCCOWHandle --------------------------
Private function to return a special CCOW Handle from the server
which is set into the CCOW context.
The Broker of a new application can get the CCOWHandle from the context
and use it to do a ImAPPHandle Sign-on.
----------------------------------------------------------------}
function  TCCOWRPCBroker.GetCCOWHandle(ConnectedBroker : TCCOWRPCBroker): String;   // p13
begin
  Result := '';
  with ConnectedBroker do
  try                          // to permit it to work correctly if CCOW is not installed on the server.
    begin
      RemoteProcedure := 'XUS GET CCOW TOKEN';
      Call;
      Result := Results[0];
      Domain := Results[1];
      RemoteProcedure := 'XUS CCOW VAULT PARAM';
      Call;
      PassCode1 := Results[0];
      PassCode2 := Results[1];
    end;
  except
    Result := '';
  end;
end;

//CCOW start
procedure TCCOWRPCBroker.CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor:
    TContextorControl);
var
  CCOWdata: IContextItemCollection;             //CCOW
  CCOWdataItem1,CCOWdataItem2,CCOWdataItem3: IContextItem;
  CCOWdataItem4,CCOWdataItem5: IContextItem;    //CCOW
  Cname: string;
begin
    if Contextor <> nil then
    begin
      try
         //Part 1
         Contextor.StartContextChange;
         //Part 2 Set the new proposed context data
         CCOWdata := CoContextItemCollection.Create;
         CCOWdataItem1 := CoContextItem.Create;
         Cname := CCOW_LOGON_ID;
         CCOWdataItem1.Name := Cname;
         CCOWdataItem1.Value := domain;
         CCOWData.Add(CCOWdataItem1);
         CCOWdataItem2 := CoContextItem.Create;
         Cname := CCOW_LOGON_TOKEN;
         CCOWdataItem2.Name := Cname;
         CCOWdataItem2.Value := token;
         CCOWdata.Add(CCOWdataItem2);
         CCOWdataItem3 := CoContextItem.Create;
         Cname := CCOW_LOGON_NAME;
         CCOWdataItem3.Name := Cname;
         CCOWdataItem3.Value := Uname;
         CCOWdata.Add(CCOWdataItem3);
         //
         CCOWdataItem4 := CoContextItem.Create;
         Cname := CCOW_LOGON_VPID;
         CCOWdataItem4.Name := Cname;
         CCOWdataItem4.Value := Vpid;
         CCOWdata.Add(CCOWdataItem4);
         //
         CCOWdataItem5 := CoContextItem.Create;
         Cname := CCOW_USER_NAME;
         CCOWdataItem5.Name := Cname;
         CCOWdataItem5.Value := Uname;
         CCOWdata.Add(CCOWdataItem5);
         //Part 3 Make change
         Contextor.EndContextChange(true, CCOWdata);
         //We don't need to check CCOWresponce
       finally
       end;  //try
    end; //if
end;

//Get Token from CCOW context
function TCCOWRPCBroker.GetCCOWtoken(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem;                 //CCOW
  CCOWcontextItem: IContextItemCollection;      //CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_TOKEN;
  if (Contextor <> nil) then
  try
    CCOWcontextItem := Contextor.CurrentContext;
    //See if context contains the ID item
    CCOWdataItem1 := CCOWcontextItem.Present(name);
    if (CCOWdataItem1 <> nil) then    //1
    begin
      result := CCOWdataItem1.Value;
      if not (result = '') then
        FWasUserDefined := True;
    end;
    FCCOWLogonIDName := CCOW_LOGON_ID;
    FCCOWLogonName := CCOW_LOGON_NAME;
    FCCOWLogonVpid := CCOW_LOGON_VPID;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      FCCOWLogonIdValue := CCOWdataItem1.Value;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      FCCOWLogonNameValue := CCOWdataItem1.Value;
    CCOWdataItem1 := CCOWcontextItem.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      FCCOWLogonVpidValue := CCOWdataItem1.Value;
    finally
  end; //try
end;

//Get Name from CCOW context
function TCCOWRPCBroker.GetCCOWduz(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem;                  //CCOW
  CCOWcontextItem: IContextItemCollection;      //CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
  try
      CCOWcontextItem := Contextor.CurrentContext;
      //See if context contains the ID item
      CCOWdataItem1 := CCOWcontextItem.Present(name);
      if (CCOWdataItem1 <> nil) then    //1
      begin
           result := CCOWdataItem1.Value;
           if result <> '' then
             FWasUserDefined := True;
      end;
  finally
  end; //try
end;

function TCCOWRPCBroker.IsUserContextPending(aContextItemCollection: 
    IContextItemCollection): Boolean;
var
  CCOWdataItem1: IContextItem;                  //CCOW
  Val1: String;
begin
  result := false;
  if WasUserDefined() then // indicates data was defined
  begin
    Val1 := '';  // look for any USER Context items defined
    result := True;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonIDValue) then
        Val1 := '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonNameValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = FCCOWLogonVpidValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_USER_NAME);
    if CCOWdataItem1 <> nil then
      if not (CCOWdataItem1.Value = user.Name) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    if Val1 = '' then    // nothing defined or all matches, so not user context change
      result := False;
  end;
end;

end.


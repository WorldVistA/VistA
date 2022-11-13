{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey, Herlan Westra
  Description: Contains TRPCBroker and related components.
  Unit: CCOWRPCBroker Authenticates user using CCOW
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 07/19/2016) XWB*1.1*65
  1. Updated RPC Version to version 65.
  2. Note that the use of CCOW RPC Broker to authenticate the user does NOT
  use 2-factor authentication and does not comply with the anticipated
  future security policy of the VA. This code may be deprecated in a
  future release.

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. Updated RPC Version to version 60
  2. Reformated indentations and comments to make code more readable

  Changes in v1.1.31 (DCM ) XWB*1.1*31
  1. Added new read only property BrokerVersion to TRPCBroker which
  should contain the version number for the RPCBroker
  (or SharedRPCBroker) in use.

  Changes in v1.1.13 (JLI  5/24/2001) XWB*1.1*13
  1. More silent login code; deleted obsolete lines (DCM 9/10/99)

  Changes in v1.1.8 (REM 7/13/1999) XWB*1.1*8
  1. Check for Multi-Division users.

  Changes in v1.1.6 (DPC 4/1999) XWB*1.1*6
  1. Polling to support terminating orphaned server jobs.
  ************************************************** }
unit CCOWRPCBroker;

interface

{$I IISBase.inc}

uses
  {System}
  Classes, SysUtils, ComObj,
  {Vcl}
  Controls, Dialogs, Forms, Graphics, extctrls, OleCtrls,
  {VA}
  XWBut1, MFunStr, XWBHash, Trpcb, VERGENCECONTEXTORLib_TLB,
  {WinApi}
  Messages, WinProcs, WinTypes, Windows, ActiveX;

const
  NoMore: boolean = False;
  MIN_RPCTIMELIMIT: integer = 30;
  CURRENT_RPC_VERSION: String = 'XWB*1.1*65';

type
  TCCOWRPCBroker = class(TRPCBroker)
  private
    { Private declarations }
  protected
    FCCOWLogonIDName: String;
    FCCOWLogonIDValue: String;
    FCCOWLogonName: String;
    FCCOWLogonNameValue: String;
    FContextor: TContextorControl; // CCOW
    FCCOWtoken: string; // CCOW
    FVistaDomain: String;
    FCCOWLogonVpid: String;
    FCCOWLogonVpidValue: String;
    FWasUserDefined: Boolean;
    function GetCCOWHandle(ConnectedBroker: TCCOWRPCBroker): string;
    function GetCCOWduz(Contextor: TContextorControl): string;
    procedure CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor: TContextorControl);
  public
    { Public declarations }
    function GetCCOWtoken(Contextor: TContextorControl): string;
    function IsUserCleared: Boolean;
    function WasUserDefined: Boolean;
    function IsUserContextPending(aContextItemCollection: IContextItemCollection):Boolean;
    property Contextor: TContextorControl read Fcontextor write FContextor;  //CCOW
    property CCOWLogonIDName: String read FCCOWLogonIDName;
    property CCOWLogonIDValue: String read FCCOWLogonIDValue;
    property CCOWLogonName: String read FCCOWLogonName;
    property CCOWLogonNameValue: String read FCCOWLogonNameValue;
    property CCOWLogonVpid: String read FCCOWLogonVpid;
    property CCOWLogonVpidValue: String read FCCOWLogonVpidValue;
  published
    property Connected: boolean read FConnected write SetConnected;
  end;

procedure AuthenticateUser(ConnectingBroker: TCCOWRPCBroker);

implementation

uses
  {VA}
  Loginfrm, RpcbErr, WSockc, SelDiv, RpcSLogin, fRPCBErrMsg, CCOW_const;

var
  CCOWToken: String;
  Domain: String;
  PassCode1: String;
  PassCode2: String;


function TCCOWRPCBroker.WasUserDefined: Boolean;
begin
  Result := FWasUserDefined;
end; // function TCCOWRPCBroker.WasUserDefined


function TCCOWRPCBroker.IsUserCleared: Boolean;
var
  CCOWcontextItem: IContextItemCollection; // CCOW
  CCOWdataItem1: IContextItem; // CCOW
  Name: String;
begin
  Result := False;
  Name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
    try
      // See if context contains the ID item
      CCOWcontextItem := Contextor.CurrentContext;
      CCOWDataItem1 := CCowContextItem.Present(Name);
      if (CCOWdataItem1 <> nil) then
      begin
        if CCOWdataItem1.Value = '' then
          Result := True
        else
          FWasUserDefined := True;
      end // if
      else
        Result := True;
    finally
    end; // try
end; // function TCCOWRPCBroker.IsUserCleared

{ ------------------------ AuthenticateUser ------------------------
  ------------------------------------------------------------------ }
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
  with ConnectingBroker do
  begin
    SaveParam := TParams.Create(nil);
    SaveParam.Assign(Param); // save off settings
    SaveRemoteProcedure := RemoteProcedure;
    SaveRpcVersion := RpcVersion;
    SaveResults := Results;
    SaveClearParmeters := ClearParameters;
    SaveClearResults := ClearResults;
    ClearParameters := True; // set'em as I need'em
    ClearResults := True;
    SaveKernelLogin := KernelLogin; // p13
    SaveVistaLogin := Login; // p13
  end; // with
  blnSignedOn := False; // initialize to bad sign-on
  if ConnectingBroker.AccessVerifyCodes <> '' then   // p13 handle as AVCode single signon
  begin
    ConnectingBroker.Login.AccessCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 1);
    ConnectingBroker.Login.VerifyCode := Piece(ConnectingBroker.AccessVerifyCodes, ';', 2);
    ConnectingBroker.Login.Mode := lmAVCodes;
    ConnectingBroker.KernelLogIn := False;
  end; // if
  // CCOW start
  if ConnectingBroker.KernelLogIn and (not (ConnectingBroker.Contextor = nil)) then
  begin
    CCOWtoken := ConnectingBroker.GetCCOWtoken(ConnectingBroker.Contextor);
    if length(CCOWtoken)>0 then
    begin
      ConnectingBroker.FKernelLogIn := false;
      ConnectingBroker.Login.Mode := lmAppHandle;
      ConnectingBroker.Login.LogInHandle := CCOWtoken;
    end; // if
  end; // if
  if not ConnectingBroker.FKernelLogIn then
    if ConnectingBroker.FLogin <> nil then     //the user.  vistalogin contains login info
    begin
      blnsignedon := SilentLogin(ConnectingBroker);    // RpcSLogin unit
      if not blnSignedOn then
      begin // Switch back to Kernel Login
        ConnectingBroker.FKernelLogIn := true;
        ConnectingBroker.Login.Mode := lmAVCodes;
      end; // if
    end; // if
  // CCOW end
  if ConnectingBroker.FKernelLogIn then
  begin // p13
    CCOWToken := ''; // if can't sign on with Token clear it so can get new one
    if Assigned(Application.OnException) then
      OldExceptionHandler := Application.OnException
    else
      OldExceptionHandler := nil;
    Application.OnException := TfrmErrMsg.RPCBShowException;
    frmSignon := TfrmSignon.Create(Application);
    try
      // ShowApplicationAndFocusOK(Application);
      OldHandle := GetForegroundWindow;
      SetForegroundWindow(frmSignon.Handle);
      PrepareSignonForm(ConnectingBroker);
      if SetUpSignOn then // SetUpSignOn in loginfrm unit.
      begin // True if signon needed
         if frmSignOn.lblServer.Caption <> '' then
        begin
           frmSignOn.ShowModal;                    //do interactive logon   // p13
           if frmSignOn.Tag = 1 then               //Tag=1 for good logon
            blnSignedOn := True; // Successfull logon
        end // if
      end // if
      else // False when no logon needed
        blnSignedOn := NoSignOnNeeded; // Returns True always (for now!)
      if blnSignedOn then // P6 If logged on, retrieve user info.
      begin
        GetBrokerInfo(ConnectingBroker);
        if not ChooseDiv('', ConnectingBroker) then
        begin
          blnSignedOn := False; // P8
          { Select division if multi-division user.  First parameter is 'userid'
            (DUZ or username) for future use. (P8) }
           ConnectingBroker.Login.ErrorText := 'Failed to select Division';  // p13 set some text indicating problem
        end; // if
      end; // if
      SetForegroundWindow(OldHandle);
    finally
      frmSignon.Free;
      ShowApplicationAndFocusOK(Application);
    end; // try
    if Assigned(OldExceptionHandler) then
      Application.OnException := OldExceptionHandler;
  end; // if ConnectingBroker.FKernelLogIn
  // p13  following section for silent signon
   if (not ConnectingBroker.KernelLogIn) and (not blnsignedon) then     // was doing the signon twice if already true
     if ConnectingBroker.Login <> nil then     //the user.  vistalogin contains login info
       blnsignedon := SilentLogin(ConnectingBroker);    // RpcSLogin unit
   if not blnsignedon then
  begin
     TXWBWinsock(ConnectingBroker.XWBWinsock).NetworkDisconnect(ConnectingBroker.Socket);
  end // if
  else
    GetBrokerInfo(ConnectingBroker);
  // reset the Broker
  with ConnectingBroker do
  begin
    ClearParameters := SaveClearParmeters;
    ClearResults := SaveClearResults;
    Param.Assign(SaveParam); // restore settings
    SaveParam.Free;
    RemoteProcedure := SaveRemoteProcedure;
    RpcVersion := SaveRpcVersion;
    Results := SaveResults;
     FKernelLogin := SaveKernelLogin;         // p13
    FLogin := SaveVistaLogin; // p13
  end; // with
  if not blnSignedOn then // Flag for unsuccessful signon.
     TXWBWinsock(ConnectingBroker.XWBWinsock).NetError('',XWB_BadSignOn);    //Will raise error.
end; // procedure AuthenticateUser

{ ----------------------- GetCCOWHandle --------------------------
  Private function to return a special CCOW Handle from the server
  which is set into the CCOW context.
  The Broker of a new application can get the CCOWHandle from the context
  and use it to do a ImAPPHandle Sign-on.
  ---------------------------------------------------------------- }
function TCCOWRPCBroker.GetCCOWHandle(ConnectedBroker : TCCOWRPCBroker): String;   // p13
begin
  Result := '';
  with ConnectedBroker do
    try // to permit it to work correctly if CCOW is not installed on the server.
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
    end; // try
end; // function TCCOWRPCBroker.GetCCOWHandle

{ ----------------------- CCOWsetUser --------------------------
  CCOW Start
  ---------------------------------------------------------------- }
procedure TCCOWRPCBroker.CCOWsetUser(Uname, token, Domain, Vpid: string; Contextor: TContextorControl);
var
  CCOWdata: IContextItemCollection; // CCOW
  CCOWdataItem1, CCOWdataItem2, CCOWdataItem3: IContextItem;
  CCOWdataItem4, CCOWdataItem5: IContextItem; // CCOW
  Cname: string;
begin
  if Contextor <> nil then
  begin
    try
      // Part 1
      Contextor.StartContextChange;
      // Part 2 Set the new proposed context data
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
      // Part 3 Make change
      Contextor.EndContextChange(true, CCOWdata);
      // We don't need to check CCOWresponce
    finally
    end; // try
  end; // if
end; // procedure TCCOWRPCBroker.CCOWsetUser

{ ----------------------- GetCCOWtoken --------------------------
  Get Token from CCOW context
  ---------------------------------------------------------------- }
function TCCOWRPCBroker.GetCCOWtoken(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem; // CCOW
  CCOWcontextItem: IContextItemCollection; // CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_TOKEN;
  if (Contextor <> nil) then
    try
      CCOWcontextItem := Contextor.CurrentContext;
      // See if context contains the ID item
      CCOWdataItem1 := CCOWcontextItem.Present(name);
      if (CCOWdataItem1 <> nil) then // 1
      begin
        result := CCOWdataItem1.Value;
        if not (result = '') then
          FWasUserDefined := True;
      end; // if
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
    end; // try
end; // function TCCOWRPCBroker.GetCCOWtoken

{ ----------------------- GetCCOWduz --------------------------
  Get Name from CCOW context
  ---------------------------------------------------------------- }
function TCCOWRPCBroker.GetCCOWduz(Contextor: TContextorControl): string;
var
  CCOWdataItem1: IContextItem; // CCOW
  CCOWcontextItem: IContextItemCollection; // CCOW
  name: string;
begin
  result := '';
  name := CCOW_LOGON_ID;
  if (Contextor <> nil) then
    try
      CCOWcontextItem := Contextor.CurrentContext;
      // See if context contains the ID item
      CCOWdataItem1 := CCOWcontextItem.Present(name);
      if (CCOWdataItem1 <> nil) then // 1
      begin
        result := CCOWdataItem1.Value;
        if result <> '' then
          FWasUserDefined := True;
      end; // if
    finally
    end; // try
end; // function TCCOWRPCBroker.GetCCOWduz

{ ----------------------- IsUserContextPending --------------------------
  ---------------------------------------------------------------- }
function TCCOWRPCBroker.IsUserContextPending(aContextItemCollection: IContextItemCollection): Boolean;
var
  CCOWdataItem1: IContextItem; // CCOW
  Val1: String;
begin
  result := false;
  if WasUserDefined() then // indicates data was defined
  begin
    Val1 := ''; // look for any USER Context items defined
    result := True;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_ID);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.Value = FCCOWLogonIDValue) then
        Val1 := '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_NAME);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.Value = FCCOWLogonNameValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_LOGON_VPID);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.Value = FCCOWLogonVpidValue) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    CCOWdataItem1 := aContextItemCollection.Present(CCOW_USER_NAME);
    if CCOWdataItem1 <> nil then
      if not(CCOWdataItem1.Value = user.Name) then
        Val1 := Val1 + '^' + CCOWdataItem1.Value;
    //
    if Val1 = '' then    // nothing defined or all matches, so not user context change
      result := False;
  end; // if
end; // function TCCOWRPCBroker.IsUserContextPending

end.

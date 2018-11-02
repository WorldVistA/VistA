unit uROR_RPCBroker;
{
================================================================================
*
*       Package:        ROR - Clinical Case Registries
*       Date Created:   $Revision: 1 $  $Modtime: 2/27/09 9:38a $
*       Site:           Hines OIFO
*       Developers:     dddddomain.user@domain.ext
*
*       Description:    RPC call and RPC Error Window
*
*       Notes:
*
================================================================================
*       $ Archive: /Vitals GUI 2007/Vitals-5-0-18/ROR/uROR_RPCBroker.pas $
*
* $ History: uROR_RPCBroker.pas $
*
================================================================================
}
interface

uses
  SysUtils, Classes
  , Controls
  , TRPCB
  , CCOWRPCBroker
  , RpcConf1
  , VERGENCECONTEXTORLib_TLB
  , Dialogs
  , Forms
  ;

function SelectBroker(Context: String; aContextor: TContextorControl = nil): TCCOWRPCBroker;
function getBroker(aContext: String): TRPCBroker;

implementation

uses uGMV_Common, uGMV_Engine, fROR_PCall, uGMV_RPC_Names, uGMV_Log, System.UITypes;

type
  TRPCBrokerParams = record
    Server: String; //BROKERSERVER;
    ListenerPort: Integer;//9200;
    ClearResults: Boolean; //True;
    ClearParameters: Boolean; //True;
    AccessVerifyCodes: String; //
    DebugMode: Boolean;
  end;

var
  BrokerParams: TRPCBrokerParams;

function GetBrokerParameters(var ParamRecord: TRPCBrokerParams): boolean;
var
  sUser:String;
  UseServerList : Boolean;
  i: Integer;
  SLServer, SLPort: string;
begin
  ParamRecord.Server := 'BROKERSERVER';
  ParamRecord.ListenerPort := 9200;
  ParamRecord.ClearParameters := True;
  ParamRecord.ClearResults := True;

  sUser := '';
  UseServerList := True;
  for i := 1 to ParamCount do
    begin
      if InString(ParamStr(i), ['s='], False) or
         InString(ParamStr(i), ['/server=', '-server='], False)
      then
        begin
          ParamRecord.Server := Piece(ParamStr(i), '=', 2);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['p='], False) or
         InString(ParamStr(i), ['/port=', '-port='], False)
      then
        begin
          ParamRecord.ListenerPort := StrToIntDef(Piece(ParamStr(i), '=', 2), 9200);
          UseServerList := False;
        end;

      if InString(ParamStr(i), ['/debug', '-debug'], False) then
        ParamRecord.DebugMode := True;

      if InString(ParamStr(i), ['/demo', '-demo'], False) then
        begin
          UseServerList := False;
          if MessageDlg(
            'This is a demo version of the' + #13 +
            ExtractFileName(Application.Exename) + ' program.' + #13#13 +
            'It will attempt connection to the' + #13 +
            'Hines OIFO Development server at' + #13#13 +
            'IP Address: 127.000.0.1' + #13 +
            'Listener Port: 9100' + #13 + #13 +
            'Do you wish to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            begin
              ParamRecord.Server := '127.000.0.1';
              ParamRecord.ListenerPort := 9100;
            end
        end;
(**)
   end;
   if UseServerList then
     begin
      if GetServerInfo(SLServer, SLPort) <> 1 then
        begin
          MessageDlg('Sign-On Cancelled while setting connection parameters', mtInformation, [mbok], 0);
          Result := False;
          Exit;
        end
      else
        begin
          ParamRecord.Server := SLServer;
          ParamRecord.ListenerPort := StrToIntDef(SLPort, 9200);
          Application.ProcessMessages; {Refresh screen prior to connecting}
        end;
     end;
  Result := True;
end;

function SetBrokerParameters(ParamRecord: TRPCBrokerParams; var RPCB: TCCOWRPCBroker; var ErrorString:String): boolean;
begin
  RPCB.Server := ParamRecord.Server;
  RPCB.ListenerPort := ParamRecord.ListenerPort;
  RPCB.ClearParameters := ParamRecord.ClearParameters;
  RPCB.ClearResults := ParamRecord.ClearResults;
  RPCB.AccessVerifyCodes := ParamRecord.AccessVerifyCodes;
  RPCB.DebugMode := ParamRecord.DebugMode;

  ErrorString := '';

  if RPCB.Socket > 0 then // ???
    begin
      Result := True;
      exit;
    end;

  try
    RPCB.Connected := True;
    Application.ProcessMessages;
    Result := True;
  except
    on E: EBrokerError do
      begin
        ErrorString := E.Message;
        Result := False;
        Exit;
      end;
  else
    raise;
  end;

end;

function SelectBroker(Context:String; aContextor: TContextorControl): TCCOWRPCBroker;
var
  s: String;
  RPCB:TCCOWRPCBroker;
  NewAttempt:Boolean;
  AttemptCount: Integer;
  aTime: TDateTime;
  b: Boolean;
const
  AttemptLimit = 3;

  procedure ErrorReport;
  begin
    MessageDlg('Error Encountered' + #13 + #13 +
      'User Sign-on is not complete.' + #13 +
      'Attempted connection using the following:' + #13 +
      'VistA Server: ' + RPCB.Server + #13 +
      'Listener Port: ' + IntToStr(RPCB.ListenerPort) + #13 +
      'Error Message: ' + #13 + s,
      mtError,
      [mbok],
      0);
  end;

begin
  if not GetBrokerParameters(BrokerParams) then// process parameter string
    begin
      Result := nil;
      Exit;
    end;

  AttemptCount := 0;
  repeat
    NewAttempt := False;
    {
    if i <= ParamCount then // force use of nonshared broker
      begin
        RPCB := TCCOWRPCBroker.Create(Application);
        if not SetBrokerParameters(BrokerParams,RPCB,s) then
          begin
            ErrorReport;
            FreeAndNil(RPCB);
          end;
      end
    else //try shared broker first
      begin
          RPCB := TSharedRPCBroker.Create(Application);
          TSharedRPCBroker(RPCB).AllowShared := True;
          if not SetBrokerParameters(BrokerParams,RPCB,s) then
            if (pos('Class not registered',s)<>0) then // shared broker is not available
              begin
               FreeAndNil(RPCB);
               RPCB := TRPCBroker.Create(Application); // try nonshared broker
               if not SetBrokerParameters(BrokerParams,RPCB,s) then
                 begin
                   ErrorReport;
                   FreeAndNil(RPCB);
                 end;
              end
            else // unknown error type - just report and stop
              begin
                ErrorReport;
                FreeAndNil(RPCB);
              end;
      end;
      }
      aTime := Now;
      RPCB := TCCOWRPCBroker.Create(Application);
      EventAdd('Create Broker Object','',aTime);

      aTime := Now;
      RPCB.Contextor := aContextor;
      EventAdd('Assign Contextor','',aTime);
      if not SetBrokerParameters(BrokerParams, RPCB, s) then
        begin
          ErrorReport;
          FreeAndNil(RPCB);
        end;

      if RPCB <> nil then
        try
          aTime := Now;
          b := RPCB.CreateContext(Context);
          EventAdd('Create Context','',aTime);
          if not b then
            begin
              MessageDlg('Sorry, but you need the "'+Context+'" option.'+#13#10+
                'Please contact your IRM.',mtInformation,[mbOK],0);
              FreeAndNil(RPCB);
            end;
        except
          on E: Exception do
            begin
              FreeAndNil(RPCB);
              Inc(AttemptCount);
              if AttemptCount > AttemptLimit then
                MessageDlg(
                  'You exceeded the limit of connection attempts.' +
                  #13+#13+ 'Try again later.',
                  mtError, [mbok], 0)
              else
                NewAttempt := MessageDlg(
                  'User Sign-on is not complete.' + #13 + #13+
                  'Error Message: ' + #13 + E.Message+#13+#13+
                  'Do you want to repeat the attempt?',
                  mtError, [mbok,mbCancel], 0) = mrOK;
            end;
        end

    until (RPCB <> nil) or (AttemptCount > AttemptLimit) or not NewAttempt;

  Result := RPCB;
end;

function getBroker(aContext: String): TRPCBroker;
begin
//  Result := nil;
  if Assigned(RPCBroker) then
    begin
      { Disconnect and destroy the RPC Broker }
      RPCBroker.Connected := False;
      FreeAndNil(RPCBroker);
    end;

  if CmdLineSwitch(['/NOCCOW']) then
    begin
//      ccrContextor.Enabled := False;
      RPCBroker := SelectBroker(RPC_CREATECONTEXT, nil);
    end
  else
    begin
//      ccrContextor.Enabled := True;
//      if CmdLineSwitch(['CCOW=PATIENTONLY','/PATIENTONLY']) then
        RPCBroker := SelectBroker(RPC_CREATECONTEXT, nil)
//      else
//        RPCBroker := SelectBroker(RPC_CREATECONTEXT, ccrContextor.Contextor);
    end;
  Result := RPCBroker;
end;

end.

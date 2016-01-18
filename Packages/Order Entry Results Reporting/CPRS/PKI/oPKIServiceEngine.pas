unit oPKIServiceEngine;

interface

uses
  System.Classes,
  System.SysUtils,
  oPKIEncryption,
  IdStack,
  IdContext,
  IdTCPServer;

type
  TPKIServiceEngine = class(TIdTCPServer)
  private
    fQuitSendsFinal220: boolean;
    fOnPKIEncryptionLogEvent: TPKIEncryptionLogEvent;
    fPKIEncryptionEngine: IPKIEncryptionEngine;
    fBackwardsCompatibility: boolean;

    function getIPAddress: string;

    procedure setBackwardsCompatibility(const aValue: boolean);
    procedure setOnPKIEncryptionLogEvent(const aOnPKIEncryptionLogEvent: TPKIEncryptionLogEvent);
    procedure fPKIServiceEngineNotify(const aMessage: string);

    procedure verifyBuffer(aBuffer: TStrings);

    procedure connect(AContext: TIdContext);
    procedure execute(AContext: TIdContext);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start(aPort: Word);
    procedure Stop;

    property QuitSendsFinal220: boolean read fQuitSendsFinal220 write fQuitSendsFinal220;
    property OnPKIServiceEngineNotify: TPKIEncryptionLogEvent read fOnPKIEncryptionLogEvent write setOnPKIEncryptionLogEvent;
    property ServerIPAdress: string read getIPAddress;
    property BackwardsCompatibility: boolean read fBackwardsCompatibility write setBackwardsCompatibility;
  end;

const
  PKI_BACKWARDS_COMPATIBILITY_FLAG = '-bc'; // Used to start the server in Backwards Comaptibility Mode

  PKI_SERVER_LISTENER_PORT = 10265;

implementation

const
  CMD_LIST = '\HELO\QUIT\SERV\DATA\TURN\NOOP\';
  CMD_TIMEOUT = (30 * 1000); // 30 seconds, 30000 milliseconds

  { TPKIServiceEngine }

constructor TPKIServiceEngine.Create;
begin
  inherited Create;
  OnConnect := connect;
  OnExecute := execute;

  fQuitSendsFinal220 := False;
  fBackwardsCompatibility := False;
  fOnPKIEncryptionLogEvent := fPKIServiceEngineNotify;
  NewPKIEncryptionEngine(nil, fPKIEncryptionEngine); // Service engine does not use the broker at this time.
end;

destructor TPKIServiceEngine.Destroy;
begin
  fOnPKIEncryptionLogEvent := nil;
  fPKIEncryptionEngine := nil;
  inherited;
end;

function TPKIServiceEngine.getIPAddress: string;
begin
  Result := GStack.LocalAddress;
end;

procedure TPKIServiceEngine.Start(aPort: Word);
begin
  if not Active then
    try
      fOnPKIEncryptionLogEvent('Starting PKI Service Engine...');
      DefaultPort := aPort;
      Active := True;

      if Active then
        begin
          fOnPKIEncryptionLogEvent('PKI Service Engine Started');
          fOnPKIEncryptionLogEvent('IP Address: ' + ServerIPAdress);
          fOnPKIEncryptionLogEvent('Port Number: ' + IntToStr(DefaultPort));
        end
      else
        fOnPKIEncryptionLogEvent('PKI Service Engine Failed to Start');
    except
      on E: Exception do
        fOnPKIEncryptionLogEvent(E.Message);
    end
  else
    fOnPKIEncryptionLogEvent('Service Engine already started');
end;

procedure TPKIServiceEngine.Stop;
begin
  if Active then
    try
      fOnPKIEncryptionLogEvent('Stopping PKI Service Engine...');
      Active := False;
      if Active then
        raise Exception.Create('Service did NOT stop as expected');
      fOnPKIEncryptionLogEvent('PKI Service Engine Stopped');
    except
      on E: Exception do
        fOnPKIEncryptionLogEvent(E.Message);
    end
  else
    fOnPKIEncryptionLogEvent('Service Engine already stopped');
end;

procedure TPKIServiceEngine.verifyBuffer(aBuffer: TStrings); // var aResult: string);
(*
  This method is the primary driver. If it completes without an exception being
  raised then the signature has been verified. Any issue found or error discovered
  will be returned to the execute method inside of the DATA case element. This is
  then captured and returned to the client that has called the service.
*)
var
  aDataString: string;
  aSignature: string;
  aDateTimeSigned: string;
  aBlock: integer;
  aText: string;
  aPKIEncryptionSignature: IPKIEncryptionSignature;
begin
  try
    fOnPKIEncryptionLogEvent('Entering verifyBuffer');
    aDataString := '';
    aSignature := '';
    aDateTimeSigned := '';
    aBlock := 0;

    // Unload the text from the TCPIP call and create an IPKIEncryptionSignature
    for aText in aBuffer do
      if AnsiCompareText(aText, '') = 0 then
        inc(aBlock)
      else
        case aBlock of
          0:
            aDataString := aDataString + aText;
          1:
            aSignature := aSignature + aText;
          2:
            aDateTimeSigned := aDateTimeSigned + aText;
        else
          raise EPKIEncryptionError.Create(DLG_89802036 + 'Invalid Buffer Contents: Block Index@' + IntToStr(aBlock));
        end;

    fOnPKIEncryptionLogEvent('DataString = ' + aDataString);
    fOnPKIEncryptionLogEvent('Signature = ' + aSignature);
    fOnPKIEncryptionLogEvent('DateTimeSigned = ' + aDateTimeSigned);

    if aDataString = '89802050' then
      raise EPKIEncryptionError.CreateFmt(
        '%s %s@%s Backwards Compatibility Mode =%s',
        [DLG_89802050, ServerIPAdress, IntToStr(DefaultPort), BoolToStr(fBackwardsCompatibility, True)]); // This will send the status back to the client

    NewPKIEncryptionSignature(aPKIEncryptionSignature);
    aPKIEncryptionSignature.DataString := aDataString;
    aPKIEncryptionSignature.Signature := aSignature;
    aPKIEncryptionSignature.DateTimeSigned := aDateTimeSigned;

    // Send the signature off to the IPKIEncryptionEngine for validation
    fOnPKIEncryptionLogEvent('Sending the signature off for verification');
    fPKIEncryptionEngine.ValidateSignature(aPKIEncryptionSignature);
  except
    raise;
  end;
end;

procedure TPKIServiceEngine.connect(AContext: TIdContext);
begin
  with AContext.Connection.IOHandler do
    try
      AContext.Connection.IOHandler.ReadTimeout := 30000; // CMD_TIMEOUT;
      fOnPKIEncryptionLogEvent('Sending Welcome');
      AContext.Connection.IOHandler.WriteLn('230 Welcome to the PKI Verify Server');
      AContext.Connection.IOHandler.WriteLn('230 Server CRC: ' + '{CB2F2B20-D003-447A-94F0-3ABC4932CB26}');
      fOnPKIEncryptionLogEvent('Welcome Sent');
    except
      on E: Exception do
        fOnPKIEncryptionLogEvent('Error sending welcome: ' + E.Message);
    end;
end;

procedure TPKIServiceEngine.execute(AContext: TIdContext);
var
  aMsg: string;
  aCmd: string;
  aTxt: string;
  aLen: integer;
  aStatus: string;
  aBuffer: TStringList;
  i: integer;
  x: string;
begin
  aBuffer := TStringList.Create; { Used as the data buffer }
  while AContext.Connection.Connected do
    try
      aMsg := AContext.Connection.IOHandler.ReadLn;
      aCmd := '\' + UpperCase(Copy(aMsg, 1, 4)) + '\';
      fOnPKIEncryptionLogEvent(Format('%s executing %s', [Self.ClassName, aMsg]));
      i := Pos(aCmd, CMD_LIST);
      case i of
        1: // HELO
          begin
            AContext.Connection.IOHandler.WriteLn('220 Howdy-' + Copy(aMsg, 5, Length(aMsg)));
          end;
        6: // QUIT
          try
            if fQuitSendsFinal220 then
              begin
                fOnPKIEncryptionLogEvent('Sending final 220 Quit');
                AContext.Connection.IOHandler.WriteLn('220 Quit');
              end
            else
              begin
                fOnPKIEncryptionLogEvent('Did NOT send final 220 Quit');
              end;
            AContext.Connection.Disconnect;
          except
            on E: Exception do
              begin
                fOnPKIEncryptionLogEvent('Exception raised in command QUIT: ' + E.Message);
                raise;
              end;
          end;
        11: // SERV
          begin
            // Not used
          end;
        16: // DATA
          try
            aBuffer.Clear;
            aLen := 0;
            while aLen >= 0 do
              begin
                aTxt := AContext.Connection.IOHandler.ReadString(3);
                aLen := StrToIntDef(aTxt, 0);
                if aTxt = '000' then
                  begin
                    aBuffer.Add('');
                    fOnPKIEncryptionLogEvent(Format('%s', [aTxt]));
                  end
                else if aLen > 0 then
                  begin
                    aTxt := AContext.Connection.IOHandler.ReadString(aLen);
                    aBuffer.Add(aTxt);
                    fOnPKIEncryptionLogEvent(Format('%.3d%s', [aLen, aTxt]));
                  end;
              end;
            verifyBuffer(aBuffer); // aStatus will be sent back on the next TURN
            aStatus := 'OK'; // If no exceptions in the verifyBuffer method then it's all OK
            AContext.Connection.IOHandler.WriteLn('220 Data');
          except
            on E: EPKIEncryptionError do
              begin // if we are here we need to capture the exception for the TURN command
                fOnPKIEncryptionLogEvent('EPKIEncryptionError raised in command DATA: ' + E.Message);
                aStatus := E.Message; // '-1^'+E.Message; // The exception is caught here and readied for the TURN
                if fBackwardsCompatibility then
                  aStatus := '-1^' + aStatus;
                AContext.Connection.IOHandler.WriteLn('220 Data'); // We have to let the client turn
              end;
            on E: Exception do
              raise; // if we are here, something really bad happened and we need to just close out
          end;
        21: { TURN }
          try
            AContext.Connection.IOHandler.WriteLn('220 TURN');
            AContext.Connection.IOHandler.WriteLn('DATA ');
            // This next one is the LengthOfaStatus+aStatus+-10
            AContext.Connection.IOHandler.WriteLn(Format('%.3d%s-10', [Length(aStatus), aStatus]));
            x := AContext.Connection.IOHandler.ReadLn;
            fOnPKIEncryptionLogEvent('Done in TURN, client says: ' + x);
          except
            on E: Exception do
              begin
                fOnPKIEncryptionLogEvent('Exception raised in command TURN: ' + E.Message);
                raise;
              end;
          end;
        26: { NOOP }
          try
            AContext.Connection.IOHandler.WriteLn('220 NOOP');
          except
            on E: Exception do
              begin
                fOnPKIEncryptionLogEvent('Exception raised in command NOOP: ' + E.Message);
                raise;
              end;
          end;
      else
        try
          fOnPKIEncryptionLogEvent('Unknown command NOOP: ' + aMsg);
          AContext.Connection.IOHandler.WriteLn('440 Unknown command "' + aMsg + '"');
        except
          on E: Exception do
            begin
              fOnPKIEncryptionLogEvent('Exception raised with unknown command ' + aMsg + ': ' + E.Message);
              raise;
            end;
        end;
      end;
      fOnPKIEncryptionLogEvent('Execute ' + aMsg + ' done, connection state active: ' + BoolToStr(AContext.Connection.Connected, True));
    except
      on Exception do
        begin // This is when something bad happened. Let's disconnect and wait for the next client.
          FreeAndNil(aBuffer);
          AContext.Connection.Disconnect;
        end
    end;
  fOnPKIEncryptionLogEvent('Connection Closed');
end;

procedure TPKIServiceEngine.setBackwardsCompatibility(const aValue: boolean);
begin
  fBackwardsCompatibility := aValue;
  fOnPKIEncryptionLogEvent('Backwards Compatibility Error Mode set to ' + BoolToStr(aValue, True));
end;

procedure TPKIServiceEngine.setOnPKIEncryptionLogEvent(const aOnPKIEncryptionLogEvent: TPKIEncryptionLogEvent);
begin
  if Assigned(aOnPKIEncryptionLogEvent) then
    begin
      fOnPKIEncryptionLogEvent := aOnPKIEncryptionLogEvent;
      fPKIEncryptionEngine.OnLogEvent := aOnPKIEncryptionLogEvent;
    end
  else
    begin
      fOnPKIEncryptionLogEvent := fPKIServiceEngineNotify;
      fPKIEncryptionEngine.OnLogEvent := fPKIServiceEngineNotify;
    end;
end;

procedure TPKIServiceEngine.fPKIServiceEngineNotify(const aMessage: string);
begin
  { This is here to prevent nil pointers in the event that no logging mechanism is attached }
end;

end.

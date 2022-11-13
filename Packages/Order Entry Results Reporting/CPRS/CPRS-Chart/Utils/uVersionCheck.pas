unit uVersionCheck;

interface

uses
  ORSystem, rMisc;

function IsCorrectVersion(anOption: String; bDebug: Boolean = False): Boolean;

implementation

uses
  ORNet, ORFn, Windows, VAUtils, Forms, System.SysUtils;

const
  TX_VER1 = 'This is version ';
  TX_VER2 = ' of CPRSChart.exe.';
  TX_VER3 = CRLF + 'The running server version is ';
  TX_VER_REQ = ' version server is required.';
  TX_VER_OLD = CRLF + 'It is strongly recommended that you upgrade.';
  TX_VER_OLD2 = CRLF +
    'The program cannot be run until the client is upgraded.';
  TX_VER_NEW = CRLF + 'The program cannot be run until the server is upgraded.';
  TC_VER = 'Server/Client Incompatibility';
  TC_CLIERR = 'Client Specifications Mismatch';
  TX_CLIENT_MISMATCH = 'Server newer than Client';

function IsCorrectVersion(anOption: String; bDebug: Boolean = False): Boolean;
var
  ClientVer, ServerVer, ServerReq, IsDefault: string;

begin
  Result := bDebug;

  ClientVer := ClientVersion(Application.ExeName);
  ServerVer := ServerVersion(anOPTION, ClientVer);
  if (ServerVer = '0.0.0.0') then
  begin
    InfoBox('Unable to determine current version of server.', anOPTION, MB_OK);
    Exit;
  end;
  ServerReq := Piece(FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME), ' ', 1);
  if (ClientVer <> ServerReq) then
  begin
    InfoBox('Client "version" does not match client "required" server.', TC_CLIERR, MB_OK);
    Exit;
  end;

  if (CompareVersion(ServerVer, ServerReq) <> 0) then
  begin
//    if (sCallV('ORWU DEFAULT DIVISION', [nil]) = '1') then
    CallVistA('ORWU DEFAULT DIVISION', [nil], IsDefault);
    if (IsDefault = '1') then
    begin
      if (InfoBox('Proceed with mismatched Client and Server versions?', TC_CLIERR, MB_YESNO) = ID_NO) then
      begin
        Exit;
      end;
    end
    else
    begin
      if (CompareVersion(ServerVer, ServerReq) > 0) then // Server newer than Required
      begin
        // NEXT LINE COMMENTED OUT - CHANGED FOR VERSION 19.16, PATCH OR*3*155:
        //      if GetUserParam('ORWOR REQUIRE CURRENT CLIENT') = '1' then
        if (true) then // "True" statement guarantees "required" current version client.
        begin
          InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_OLD2, TC_VER, MB_OK);
          Exit;
        end;
      end
      else InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_OLD, TC_VER, MB_OK);
    end;

    if (CompareVersion(ServerVer, ServerReq) < 0) then // Server older then Required
    begin
      InfoBox(TX_VER1 + ClientVer + TX_VER2 + CRLF + ServerReq + TX_VER_REQ + TX_VER3 + ServerVer + '.' + TX_VER_NEW, TC_VER, MB_OK);
      Exit;
    end;
  end;
  Result := True;

end;

end.

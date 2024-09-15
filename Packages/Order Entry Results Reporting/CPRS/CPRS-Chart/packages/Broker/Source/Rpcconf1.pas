{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Raul Mendoza, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: Rpcconf1 server selection dialog. Reads from registry entries
  HKEY_LOCAL_MACHINE and HKEY_CURRENT_USER, and saves new entries to
  HKEY_CURRENT_USER.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 11/21/2016) XWB*1.1*65
  1. None.

  Changes in v1.1.60 (HGW 05/14/2014) XWB*1.1*60
  1. Symbol 'StrDispose' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  2. Symbol 'StrPas' is deprecated in Delphi XE4, moved to the AnsiStrings unit.
  3. Fixed read/write from/to Windows registry and added SSHUsername information
  to value saved in registry.
  4. Replaced uses WinSock with uses WinSock2.
  5. Create overload version of function GetServerInfo for backward compatibility.
  New version has third argument of SSHUsername.

  Changes in v1.1.50 (JLI 09/08/2004) XWB*1.1*50
  1. Update string types for host and outcome

  Changes in v1.1.13 (REM 04/25/2000) XWB*1.1*13
  1. Added an OnDestroy event to release the help file.
  ************************************************** }

// TODO - Deprecate and replace documented function GetServerIP
// with IPv4/IPv6 dual-stack, as multiple IP addresses will be returned (list).
// (Create overload version for backward compatibility?)
// TODO - Add a delete button to delete a server registry entry? Function is at
// bottom of this unit, but button does not exist.
// TODO - Improve function IsIPAddress. See Indy IdGlobal unit for possibilities.

unit Rpcconf1;

interface

uses
  {System}
  AnsiStrings, SysUtils, Classes,
  {WinApi}
  WinTypes, WinProcs, Messages, WinSock2,
  {VA}
  XWBut1, Rpcnet, MFunStr,
  {Vcl}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TrpcConfig = class(TForm)
    cboServer: TComboBox;
    TPanelAddress: TPanel;
    Panel3: TPanel;
    pnlPort: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Panel1: TPanel;
    pnlAddress: TPanel;
    btnHelp: TBitBtn;
    btnNew: TButton;
    TPanelSSHUsername: TPanel;
    Panel2: TPanel;
    pnlSSHUsername: TPanel;
    procedure cboServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure butCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cboServerExit(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure pnlPortClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);

  private
    { Private declarations }
    OrigHelp: String; // Help filename of calling application.

  public
    { Public declarations }
    ServerPairs: TStringList;
  end;

function GetServerInfo(var Server, Port: string): integer; overload;
// p60 backward compatibility
function GetServerInfo(var Server, Port, SSHUsername: string): integer;
  overload; // p60 new version
function GetServerIP(ServerName: String): String;

var
  rpcConfig: TrpcConfig;
  ButtonStatus, Instance: integer;
  rServer, rPort, rSSHUsername: string;
  TaskInstance: integer;

implementation

uses
  {VA}
  AddServer;

{$R *.DFM}

function IsIPAddress(Val: String): Boolean;
// TODO - Need a better way to verify an IP address (IPv4 and IPv6)
var
  I: integer;
  C: Char;
begin
  Result := True;
  for I := 1 to Length(Val) do // Iterate
  begin
    C := Val[I];
    if not(CharInSet(C, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A',
      'B', 'C', 'D', 'E', 'F', '.', ':'])) then
    begin
      Result := False;
      Break;
    end;
  end; // for
end;

{ : Library function to obtain an IP address, given a server name }
// Assumes single IP address for server, which could be incorrect!!!
function GetServerIP(ServerName: String): String;
var
  host, outcome: PAnsiChar; // JLI 090804
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then
  begin
    outcome := PAnsiChar(StrAlloc(256)); // JLI 090804
    host := PAnsiChar(StrAlloc(Length(ServerName) + 1)); // JLI 090804
    AnsiStrings.StrPCopy(host, AnsiString(ServerName)); // p60
    LibGetHostIP1(TaskInstance, host, outcome);
    Result := String(outcome); // p60
    AnsiStrings.StrDispose(outcome); // p60
    AnsiStrings.StrDispose(host); // p60
  end
  else
    Result := ServerName;
  LibClose(TaskInstance);
end;

procedure TrpcConfig.cboServerClick(Sender: TObject);
var
  index: integer;
begin
  { Based on selection, set Port, Server and SSHUsername variables }
  index := cboServer.ItemIndex;
  rPort := Piece(Piece(ServerPairs[index], '=', 1), ',', 2);
  pnlPort.Caption := rPort;
  rSSHUsername := Piece(ServerPairs[index], '=', 2);
  pnlSSHUsername.Caption := rSSHUsername;
  rServer := Piece(ServerPairs[index], ',', 1);
  btnOk.Enabled := True;
  // btnDelete.Enabled := True;
  { Based on Server, get IP addresss. }
  pnlAddress.Caption := GetServerIP(rServer);
end;

procedure TrpcConfig.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
  OrigHelp := Application.HelpFile; // Save original helpfile.
  Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
    '\clagent.hlp'; // Identify ConnectTo helpfile.
  ServerPairs := TStringList.Create;
end;

procedure TrpcConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  cboServer.Clear;
  pnlPort.Caption := '';
  pnlSSHUsername.Caption := '';
  ServerPairs.Free;
  Application.HelpFile := OrigHelp; // Restore helpfile.
end;

// Overload old version of GetServerInfo for backward compatibility (p60)
function GetServerInfo(var Server, Port: string): integer;
var
  rSSHUsername: string;
begin
  Result := GetServerInfo(Server, Port, rSSHUsername);
end;

// Overload new version of GetServerInfo including SSHUsername (p60)
function GetServerInfo(var Server, Port, SSHUsername: string): integer;
var
  index: integer;
  tmpServerPairs: TStringList; // Format: SERVER,port#
  TextStr: String;
begin
  rpcConfig := TrpcConfig.Create(Application);
  TaskInstance := LibOpen;
  // For Windows 7:
  // HKEY_LOCAL_MACHINE\Software\Wow6432Node\Vista\Broker\Servers
  // HKEY_CURRENT_USER\Software\Vista\Broker\Servers
  // server.site.domain.ext,19300 REG_SZ xxxvista
  with rpcConfig do
  begin
    tmpServerPairs := TStringList.Create;
    ReadRegValues(HKLM, REG_SERVERS, tmpServerPairs);
    ServerPairs.Assign(tmpServerPairs);
    tmpServerPairs.Clear;
    ReadRegValues(HKCU, REG_SERVERS, tmpServerPairs);
    for index := 0 to (tmpServerPairs.Count - 1) do
    begin
      TextStr := tmpServerPairs[index];
      if ServerPairs.IndexOf(TextStr) < 0 then
        ServerPairs.Add(TextStr);
    end;
    ButtonStatus := mrOk;
    if ServerPairs.Count < 1 then
    begin
      WriteRegData(HKCU, REG_SERVERS, 'BROKERSERVER,9200', '');
      ServerPairs.Add('BROKERSERVER,9200');
    end;
    if ServerPairs.Count > 1 then // P31                     //need to show form
    begin
      // Initialize form.
      for index := 0 to (ServerPairs.Count - 1) do // Load combobox
        cboServer.Items.Add(ServerPairs[index]);
      cboServer.ItemIndex := 0;
      rServer := Piece(ServerPairs[0], ',', 1);
      rPort := Piece(Piece(ServerPairs[0], '=', 1), ',', 2);
      pnlPort.Caption := rPort;
      rSSHUsername := Piece(ServerPairs[0], '=', 2);
      pnlSSHUsername.Caption := rSSHUsername;
      // Get and display IP address.
      pnlAddress.Caption := GetServerIP(rServer);
      ShowModal; // Display form
    end
    else // One choice: form not shown, value returned.
    begin
      rServer := Piece(ServerPairs[0], ',', 1);
      rPort := Piece(Piece(ServerPairs[0], '=', 1), ',', 2);
      rSSHUsername := Piece(ServerPairs[0], '=', 2);
    end;
    if ButtonStatus = mrOk then
    begin
      Server := rServer;
      Port := rPort;
      SSHUsername := rSSHUsername;
    end;
    Result := ButtonStatus;
    tmpServerPairs.Free;
    LibClose(TaskInstance);
    Release;
  end;
end;

procedure TrpcConfig.btnOkClick(Sender: TObject);
begin
  ButtonStatus := mrOk;
  rServer := Piece(cboServer.Text, ',', 1);
  rPort := pnlPort.Caption;
  rSSHUsername := pnlSSHUsername.Caption;
  rpcConfig.close;
end;

procedure TrpcConfig.butCancelClick(Sender: TObject);
begin
  ButtonStatus := mrCancel;
  rServer := cboServer.Text;
  rPort := pnlPort.Caption;
  rSSHUsername := pnlSSHUsername.Caption;
  rpcConfig.close;
end;

procedure TrpcConfig.FormDestroy(Sender: TObject);
begin
  ServerPairs := TStringList.Create; // {p13 - REM}
  ServerPairs.Free; // Release Help File.
  Application.HelpFile := OrigHelp; //
end;

procedure TrpcConfig.pnlPortClick(Sender: TObject);
begin
  //
end;

procedure TrpcConfig.cboServerExit(Sender: TObject);
begin
  //
end;

procedure TrpcConfig.btnHelpClick(Sender: TObject);
begin
  //
end;

// On Windows 7, btnNewClick writes to:
// HKEY_CURRENT_USER\Software\Vista\Broker\Servers
// server.site.domain.ext,19300 REG_SZ xxxvista
procedure TrpcConfig.btnNewClick(Sender: TObject);
var
  I: integer;
  ServerForm: TfrmAddServer;
  strServer, strName, strPort, strSSHUsername: String;
begin
  ServerForm := TfrmAddServer.Create(Self);
  if ServerForm.ShowModal <> mrCancel then
  begin
    strServer := ServerForm.edtAddress.Text;
    strPort := ServerForm.edtPortNumber.Text;
    strSSHUsername := ServerForm.edtSSHusername.Text;
    ServerForm.edtPortNumber.Text := strPort;
    strName := strServer + ',' + strPort;
    WriteRegData(HKCU, REG_SERVERS, strName, strSSHUsername);
    ServerPairs.Add(strName);
    strName := ServerPairs[ServerPairs.Count - 1];
    cboServer.Items.Add(strName);
    for I := 0 to cboServer.Items.Count - 1 do // Iterate
    begin
      if cboServer.Items[I] = strName then
        cboServer.ItemIndex := I;
    end; // for
    // cboServer.Text := strServer;
    // pnlPort.Caption := strPort;
    cboServerClick(Self);
  end;
  ServerForm.Free;
end;

{ ******************************
  btnDeleteClick
  - remove selected server,port combination from registry
  - added 10/17/2006
  ******************************* }
procedure TrpcConfig.btnDeleteClick(Sender: TObject);
var
  index: integer;
  Text: String;
begin
  { Based on selction, get Text value }
  index := cboServer.ItemIndex;
  Text := cboServer.Items[index];
  // now delete from both locations it could be stored
  DeleteRegData(HKLM, REG_SERVERS, Text);
  DeleteRegData(HKCU, REG_SERVERS, Text);
  // and update both cboServer and ServerPairs entries
  cboServer.Items.Delete(index);
  ServerPairs.Delete(index);
  // and set buttons dependent on selection back to disabled
  btnOk.Enabled := False;
  // btnDelete.Enabled := False;
end;

end.

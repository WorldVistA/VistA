{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Raul Mendoza, Joel Ivey
	Description: Contains TRPCBroker and related components.
  Unit: Rpcconf1 server selection dialog. Reads from registry entries
        HKEY_LOCAL_MACHINE and HKEY_CURRENT_USER, and saves new entries to
        HKEY_CURRENT_USER.
	Current Release: Version 1.1 Patch 65
*************************************************************** }
{
  Most of Code is Public Domain.
  Portions modified by OSEHRA/Sam Habiel (OSE/SMH) for Plan VI (c) Sam Habiel 2018
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

{ **************************************************
  Changes in v1.1.10001 (SMH 2018-09-13) XWB*1.1*10001
  1. Fix compiler warnings in IsIPAddress and GetServerIP
  2. GetServerInfo seems to have been broken in v1.1.60 -- it never showed up --
     there were multiple fixes required to the fuction to behave properly. In any
     case, due to common use cases, I always decided to show the form. I.e, if you
     don't want this to show, specify s and p on the command line.

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

//TODO - Deprecate and replace documented function GetServerIP
//       with IPv4/IPv6 dual-stack, as multiple IP addresses will be returned (list).
//       (Create overload version for backward compatibility?)
//TODO - Add a delete button to delete a server registry entry? Function is at
//       bottom of this unit, but button does not exist.
//TODO - Improve function IsIPAddress. See Indy IdGlobal unit for possibilities.

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
  Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

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
    btnDelete: TButton;
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
    OrigHelp : String;   //Help filename of calling application.

  public
    { Public declarations }
    ServerPairs : TStringList;
  end;

function GetServerInfo(var Server,Port: string): integer; overload;  //p60 backward compatibility
function GetServerInfo(var Server,Port,SSHUsername: string): integer; overload;  //p60 new version
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
//TODO - Need a better way to verify an IP address (IPv4 and IPv6)
var
  I: Integer;
  C: Char;
begin
  Result := True;
  for I := 1 to Length(Val) do    // Iterate
  begin
    C := Val[I];
    if not CharInSet(C, ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','.',':']) then
    begin
      Result := False;
      Break;
    end;
  end;    // for
end;

{: Library function to obtain an IP address, given a server name }
//Assumes single IP address for server, which could be incorrect!!!
function GetServerIP(ServerName: String): String;
var
  host,outcome: PAnsiChar;  // JLI 090804
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then
  begin
    outcome := PAnsiChar(StrAlloc(256));  // JLI 090804
    host := PAnsiChar(AnsiString(ServerName)); //p60
    LibGetHostIP1(TaskInstance, host, outcome);
    Result := String(AnsiString(outcome));    //p60
    AnsiStrings.StrDispose(outcome);        //p60
  end
  else
    Result := ServerName;
  LibClose(TaskInstance);
end;

procedure TrpcConfig.cboServerClick(Sender: TObject);
var
  index: integer;
begin
  {Based on selection, set Port, Server and SSHUsername variables}
  index := cboServer.ItemIndex;
  rPort := Piece(Piece(ServerPairs[index], '=', 1), ',', 2);
  pnlPort.Caption := rPort;
  rSSHUsername := Piece(ServerPairs[index], '=', 2);
  pnlSSHUsername.Caption := rSSHUsername;
  rServer := Piece(ServerPairs[index], ',', 1);
  btnOk.Enabled := True;
  //btnDelete.Enabled := True;
  {Based on Server, get IP addresss.}
  pnlAddress.Caption := GetServerIP(rServer);
end;

procedure TrpcConfig.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
  OrigHelp := Application.HelpFile;             // Save original helpfile.
  Application.HelpFile := ReadRegData(HKLM, REG_BROKER, 'BrokerDr') +
                           '\clagent.hlp';      // Identify ConnectTo helpfile.
  ServerPairs := TStringList.Create;
end;

procedure TrpcConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  cboServer.Clear;
  pnlPort.Caption := '';
  pnlSSHUsername.Caption := '';
  ServerPairs.Free;
  Application.HelpFile := OrigHelp;  // Restore helpfile.
end;

//Overload old version of GetServerInfo for backward compatibility (p60)
function GetServerInfo(var Server,Port: string): integer;
var
  rSSHUsername : string;
begin
  Result := GetServerInfo(Server, Port, rSSHUsername);
end;

//Overload new version of GetServerInfo including SSHUsername (p60)
function GetServerInfo(var Server,Port,SSHUsername: string): integer;
var
  index: integer;
  originalCount: integer;
  tmpServerPairs : TStringList;      //Format: SERVER,port#
  TextStr: String;
begin
  rpcconfig := Trpcconfig.Create(Application);
  TaskInstance := LibOpen;
  //For Windows 7:
  //       HKEY_LOCAL_MACHINE\Software\Wow6432Node\Vista\Broker\Servers
  //       HKEY_CURRENT_USER\Software\Vista\Broker\Servers
  //       server.site.domain.ext,19300 REG_SZ xxxvista
  with rpcConfig do
  begin
    tmpServerPairs := TStringList.Create;

    // Read HKLM and add entries if they are not empty.
    ReadRegValues(HKLM, REG_SERVERS, tmpServerPairs);
    for index := 0 to (tmpServerPairs.Count-1) do
    begin
      TextStr := tmpServerPairs[index];
      if (TextStr <> '') then
        ServerPairs.Add(TextStr);
    end;
    tmpServerPairs.Clear;

    // Read HKCU and add entries if they are not empty and haven't been already added.
    ReadRegValues(HKCU, REG_SERVERS, tmpServerPairs);
    for index := 0 to (tmpServerPairs.Count-1) do
    begin
      TextStr := tmpServerPairs[index];
      if (TextStr <> '') and (ServerPairs.IndexOf(TextStr) < 0) then
        ServerPairs.Add(TextStr);
    end;

    ButtonStatus := mrOk;

    // Keep track of the original count as we add "BROKERSERVER" aNd that may be CONFUSING.
    originalCount := ServerPairs.Count;
    if originalCount < 1 then
    begin
      // BAD! OSE/SMH  --> This BROKERSERVER is generally meaningless. A user can choose it below if they are inside of the VA.
      // WriteRegData(HKCU, REG_SERVERS, 'BROKERSERVER,9200', '');
      ServerPairs.Add('BROKERSERVER,9200');
    end;

    //Initialize form.
    for index := 0 to (ServerPairs.Count -1) do     //Load combobox
      cboServer.Items.Add(ServerPairs[index]);
    cboServer.ItemIndex := 0;
    rServer := Piece(ServerPairs[0], ',', 1);
    rPort := Piece(Piece(ServerPairs[0], '=', 1), ',', 2);
    pnlPort.Caption := rPort;
    rSSHUsername := Piece(ServerPairs[0], '=', 2);
    pnlSSHUsername.Caption := rSSHUsername;
    //Get and display IP address.
    pnlAddress.Caption := GetServerIP(rServer);
    ShowModal;                           //Display form

    if ButtonStatus = mrOk then
    begin
      Server := rServer;
      Port := rPort;
      SSHUsername := rSSHUsername;
    end;

    Result := ButtonStatus;
    tmpServerPairs.Free;
    libClose(TaskInstance);
    Release;
  end;
end;

procedure TrpcConfig.btnOkClick(Sender: TObject);
begin
  ButtonStatus := mrOk;
  rServer := Piece(cboServer.Text,',',1);
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
  ServerPairs.Free;                  //   Release Help File.
  Application.HelpFile := OrigHelp;  //
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

//On Windows 7, btnNewClick writes to:
//       HKEY_CURRENT_USER\Software\Vista\Broker\Servers
//       server.site.domain.ext,19300 REG_SZ xxxvista
procedure TrpcConfig.btnNewClick(Sender: TObject);
var
  I: Integer;
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
    strName := ServerPairs[ServerPairs.Count-1];
    cboServer.Items.Add(strName);
    for I := 0 to cboServer.Items.Count-1 do    // Iterate
    begin
      if cboServer.Items[I] = strName then
        cboServer.ItemIndex := I;
    end;    // for
//    cboServer.Text := strServer;
//    pnlPort.Caption := strPort;
    cboServerClick(Self);
  end;
  ServerForm.Free;
end;

{******************************
btnDeleteClick
  - remove selected server,port combination from registry
  - added 10/17/2006
*******************************}
procedure TrpcConfig.btnDeleteClick(Sender: TObject);
var
   index: integer;
   Text: String;
begin
     {Based on selction, get Text value}
     index := cboServer.ItemIndex;
     if index < 0  then exit;
     
     Text := cboServer.Items[index];
     Text := Text.Split(['='])[0];

     // now delete from both locations it could be stored
     // DeleteRegData(HKLM, REG_SERVERS, Text); SMH -- user doesn't have access to that as a normal user.
     DeleteRegData(HKCU, REG_SERVERS, Text);
     // and update both cboServer and ServerPairs entries
     cboServer.Items.Delete(index);
     cboServer.Refresh;
     ServerPairs.Delete(index);
     // and set buttons dependent on selection back to disabled
     btnOK.Enabled := False;
     //btnDelete.Enabled := False;
end;

end.


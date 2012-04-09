{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Raul Mendoza, Joel Ivey
	Description: Server selection dialog.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

{**************************************************
 p13 - added an OnDestroy event to release the
        help file.  - REM (4/25/00)
**************************************************}
unit Rpcconf1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Xwbut1,
  WinSock, rpcnet, MFunStr;

type
  TrpcConfig = class(TForm)
    cboServer: TComboBox;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlPort: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Panel1: TPanel;
    Panel4: TPanel;
    btnHelp: TBitBtn;
    btnNew: TButton;
    procedure cboServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure butCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cboServerExit(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);

  private
    { Private declarations }
    OrigHelp : String;   //Help filename of calling application.

  public
    { Public declarations }
    ServerPairs : TStringList;
  end;

function GetServerInfo(var Server,Port: string): integer;
function GetServerIP(ServerName: String): String;

var
  rpcConfig: TrpcConfig;
  ButtonStatus, Instance: integer;
  rServer, rPort: string;
  TaskInstance: integer;

implementation

uses AddServer;

{$R *.DFM}


function IsIPAddress(Val: String): Boolean;
var
  I: Integer;
  C: Char;
begin
  Result := True;
  for I := 1 to Length(Val) do    // Iterate
  begin
    C := Val[I];
    if not (C in ['0','1','2','3','4','5','6','7','8','9','.']) then
    begin
      Result := False;
      Break;
    end;
  end;    // for
end;

{: Library function to obtain an IP address, given a server name }
function GetServerIP(ServerName: String): String;
var
   host,outcome: PChar;
begin
  TaskInstance := LibOpen;
  if not IsIPAddress(ServerName) then
  begin
    outcome := StrAlloc(256);
    host := StrAlloc(length(ServerName) + 1);
    StrPCopy(host, ServerName);
    LibGetHostIP1(TaskInstance, host, outcome);
    Result := StrPas(outcome);
    StrDispose(outcome);
    StrDispose(host);
  end
  else
    Result := ServerName;
  LibClose(TaskInstance);
end;


procedure TrpcConfig.cboServerClick(Sender: TObject);
var
   index: integer;
begin
     {Based on selction, set port and server variable}
     index := cboServer.ItemIndex;
     rPort := Piece(ServerPairs[index], ',', 2);
     pnlPort.Caption := rPort;
     rServer := Piece(ServerPairs[index], ',', 1);
     btnOk.Enabled := True;
     //btnDelete.Enabled := True;

     {Based on Server, get IP addresss.}
     Panel4.Caption := GetServerIP(rServer);
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
     ServerPairs.Free;
     Application.HelpFile := OrigHelp;  // Restore helpfile.
end;

function GetServerInfo(var Server,Port: string): integer;
var
   index: integer;
   //tmp,fname,: string;  {P14}
   tmpServerPairs : TStringList;      //Format: SERVER,port#
   TextStr: String;

begin
     rpcconfig := Trpcconfig.Create(Application);
     TaskInstance := LibOpen;

     with rpcConfig do
     begin
       tmpServerPairs := TStringList.Create;
       ReadRegValueNames(HKLM, REG_SERVERS, tmpServerPairs);
       ServerPairs.Assign(tmpServerPairs);
       tmpServerPairs.Clear;
       ReadRegValueNames(HKCU, REG_SERVERS, tmpServerPairs);
       for index := 0 to (tmpServerPairs.Count-1) do
       begin
         TextStr := tmpServerPairs[index];
         if ServerPairs.IndexOf(TextStr) < 0 then
           ServerPairs.Add(TextStr);
       end;

       ButtonStatus := mrOk;

       if ServerPairs.Count < 1 then
       begin
         WriteRegData(HKLM, REG_SERVERS, 'BROKERSERVER,9200', '');
         ServerPairs.Add('BROKERSERVER,9200');
       end;


       if ServerPairs.Count > 1 then  // P31                     //need to show form
       begin
         //Initialize form.
         for index := 0 to (ServerPairs.Count -1) do     //Load combobox
           cboServer.Items.Add(ServerPairs[index]);
//           cboServer.Items.Add(Piece(ServerPairs[index], ',', 1));
         cboServer.ItemIndex := 0;
         rServer := Piece(ServerPairs[0], ',', 1);
         pnlPort.Caption := Piece(ServerPairs[0], ',', 2);
         rPort := Piece(ServerPairs[0], ',', 2);

         //Get and display IP address.
         panel4.Caption := GetServerIP(rServer);
         ShowModal;                           //Display form
       end
       else                //One choice: form not shown, value returned.
       begin
         rServer := Piece(ServerPairs[0], ',', 1);
         rPort   := Piece(ServerPairs[0], ',', 2);
     end;

       if ButtonStatus = mrOk then
          begin
            Server := rServer;
            Port := rPort;
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
     rpcConfig.close;
end;

procedure TrpcConfig.butCancelClick(Sender: TObject);
begin
     ButtonStatus := mrCancel;
     rServer := cboServer.Text;
     rPort := pnlPort.Caption;
     rpcConfig.close;
end;

procedure TrpcConfig.FormDestroy(Sender: TObject);
begin
        ServerPairs := TStringList.Create; // {p13 - REM}
        ServerPairs.Free;                  //   Release Help File.
        Application.HelpFile := OrigHelp;  //
end;

procedure TrpcConfig.cboServerExit(Sender: TObject);
begin
  //
end;

procedure TrpcConfig.btnNewClick(Sender: TObject);
var
  I: Integer;
  ServerForm: TfrmAddServer;
  strServer, strName, strPort: String;
begin
  ServerForm := TfrmAddServer.Create(Self);
  if ServerForm.ShowModal <> mrCancel then
  begin
    strServer := ServerForm.edtAddress.Text;
    strPort := ServerForm.edtPortNumber.Text;
    ServerForm.edtPortNumber.Text := strPort;
    strName := strServer + ',' + strPort;
    WriteRegData(HKCU, REG_SERVERS, strName, '');
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
     Text := cboServer.Items[index];
     // now delete from both locations it could be stored
     DeleteRegData(HKLM, REG_SERVERS, Text);
     DeleteRegData(HKCU, REG_SERVERS, Text);
     // and update both cboServer and ServerPairs entries
     cboServer.Items.Delete(index);
     ServerPairs.Delete(index);
     // and set buttons dependent on selection back to disabled
     btnOK.Enabled := False;
     //btnDelete.Enabled := False;
end;

end.


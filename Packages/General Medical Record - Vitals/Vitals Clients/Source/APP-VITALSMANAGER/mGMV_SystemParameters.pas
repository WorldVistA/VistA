unit mGMV_SystemParameters;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
//  TRPCB,
  StdCtrls,
  CheckLst,
  ExtCtrls
//  ,  u_Common
  ;

type
  TfraSystemParameters = class(TFrame)
    Panel1: TPanel;
    pnlBottom: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    clbxVersions: TCheckListBox;
    pnlMain: TPanel;
    Label2: TLabel;
    edtWebLink: TEdit;
    cbxAllowUserTemplates: TCheckBox;
    pnlHeader: TPanel;
    procedure pnlMainResize(Sender: TObject);
  private
    { Private declarations }
  public
//    procedure LoadParameters(Broker: TRPCBroker);
//    procedure SaveParameters(Broker: TRPCBroker);
    procedure LoadParameters;
    procedure SaveParameters;
    { Public declarations }
  end;

implementation

uses uGMV_Const
//, fROR_PCall
, uGMV_Engine, uGMV_Common;

{$R *.DFM}

//procedure TfraSystemParameters.LoadParameters(Broker: TRPCBroker);
procedure TfraSystemParameters.LoadParameters;
var
  lstVersions: TStringList;
  sWebLink: string;
  sUserTemplates: string;
  i: integer;
begin
  clbxVersions.Items.Clear;
//  lstVersions := TStringList.Create;
  try
//    CallRemoteProc(Broker, RPC_PARAMETER, ['GETLST', 'SYS', 'GMV GUI VERSION'], nil,[rpcSilent,rpcNoResChk], lstVersions);
    lstVersions := getGUIVersionList;
//    CallRemoteProc(Broker, RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV WEBLINK'], nil);
//    sWebLink := Broker.Results[0];
    sWebLink := getWebLinkAddress;

//    CallRemoteProc(Broker, RPC_PARAMETER, ['GETPAR', 'SYS', 'GMV ALLOW USER TEMPLATES'], nil);
//    sUserTemplates := Broker.Results[0];
    sUserTemplates := getSystemParameterByName('GMV ALLOW USER TEMPLATES');

    cbxAllowUserTemplates.Checked := (Pos('Y', sUserTemplates) > 0);
    edtWebLink.Text := sWebLink;
    for i := 1 to lstVersions.Count - 1 do
      clbxVersions.Checked[clbxVersions.Items.Add(Piece(lstVersions[i], '^', 1))] := (Pos('Y', Piece(lstVersions[i], '^', 2)) > 0);
  finally
    FreeAndNil(lstVersions);
  end;
end;

//procedure TfraSystemParameters.SaveParameters(Broker: TRPCBroker);
procedure TfraSystemParameters.SaveParameters;
var
  i: integer;
begin
  for i := 0 to clbxVersions.Items.Count - 1 do
//    if clbxVersions.Checked[i] then
//      CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV GUI VERSION', clbxVersions.Items[i], '1'], nil)
//    else
//      CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV GUI VERSION', clbxVersions.Items[i], '0'], nil);
    if clbxVersions.Checked[i] then
      setSystemParameter('GMV GUI VERSION', clbxVersions.Items[i], '1')
    else
      setSystemParameter('GMV GUI VERSION', clbxVersions.Items[i], '0');

//  if cbxAllowUserTemplates.Checked then
//    CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV ALLOW USER TEMPLATES', '1', '1'], nil)
//  else
//    CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV ALLOW USER TEMPLATES', '1', '0'], nil);
  if cbxAllowUserTemplates.Checked then
    setSystemParameter('GMV ALLOW USER TEMPLATES', '1', '1')
  else
    setSystemParameter('GMV ALLOW USER TEMPLATES', '1', '0');

//  CallRemoteProc(Broker, RPC_PARAMETER, ['SETPAR', 'SYS', 'GMV WEBLINK', '1', edtWebLink.Text], nil);
  setSystemParameter('GMV WEBLINK', '1', edtWebLink.Text);
end;

procedure TfraSystemParameters.pnlMainResize(Sender: TObject);
begin
  edtWebLink.Width := pnlMain.Width - (edtWebLink.Left * 2);
end;

end.


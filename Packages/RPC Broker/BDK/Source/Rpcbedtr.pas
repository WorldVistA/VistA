{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Property Editors for TRPCBroker component.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit RpcbEdtr;

{$I IISBase.inc}

interface

uses
  {Delphi standard}
  Classes, Controls, Dialogs,
  {$IFDEF D6_OR_HIGHER}
  DesignIntf, DesignEditors, DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  Forms, Graphics, Messages, SysUtils,
  WinProcs, WinTypes,
  Trpcb; //P14 -- pack split


type

{------ TRemoteProc property editor ------}
   {This property editor gets a list of remote procedures from the API file.}

TRemoteProcProperty = class(TStringProperty)
private
  { Private declarations }
protected
  { Protected declarations }
public
  { Public declarations }
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
  procedure SetValue(const Value: string); override;
end;


{------ TServerProperty property editor ------}
   {This property editor gets a list of servers from the C:\WINDOWS\HOSTS file}

TServerProperty = class(TStringProperty)
private
  { Private declarations }
protected
  { Protected declarations }
public
  { Public declarations }
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
  function GetValue: string; override;
  procedure SetValue(const Value: string); override;
end;


{------ TRpcVersion property editor ------}
   {This property editor checks to make sure that RpcVersion is not eimpty.
    If it is, it stuffs '0' (default).}

TRpcVersionProperty = class(TStringProperty)
private
  { Private declarations }
protected
  { Protected declarations }
public
  { Public declarations }
  procedure SetValue(const Value: string); override;
end;


procedure Register;


implementation


uses
  XWBut1, MFunStr, {TRPCB,} Hash, RpcbErr; //P14 -- pack split

function TRemoteProcProperty.GetAttributes;
begin
  Result := [paAutoUpdate,paValueList];
end;

procedure TRemoteProcProperty.GetValues(Proc: TGetStrProc);
var
  RpcbEdited, RPCBTemp: TRPCBroker;
  I: integer;
begin
  RPCBTemp := nil;
  RpcbEdited := GetComponent(0) as TRPCBroker;
  try
    RPCBTemp := TRPCBroker.Create(RpcbEdited);
    with RpcbTemp do begin
      ShowErrorMsgs := RpcbEdited.ShowErrorMsgs;
      Server := RpcbEdited.Server;
      ListenerPort := RpcbEdited.ListenerPort;
      ClearParameters := True;
      ClearResults := True;
      RemoteProcedure := 'XWB RPC LIST';
      Param[0].Value := GetValue;
      Param[0].PType := literal;
      Call;
      for I := 0 to Results.Count - 1 do Proc(Results[I]);
    end;
  finally
    RPCBTemp.Free;
  end;
end;

procedure TRemoteProcProperty.SetValue(const Value: string);
begin
  SetStrValue(UpperCase(Piece(Value,'   [',1)));  {convert user entry all to upper case}
end;

function TServerProperty.GetAttributes;
begin
  Result := [paAutoUpdate,paValueList];
end;

function TServerProperty.GetValue: string;
begin
  Result := Piece(GetStrValue,'   [',1);  {get just the  name}
end;

procedure TServerProperty.GetValues(Proc: TGetStrProc);
var
  ServerList: TStringList;
  I: integer;
begin
  ServerList := TStringList.Create;
  GetHostList(ServerList);
  for I := 0 to ServerList.Count - 1 do Proc(ServerList[I]);
  ServerList.Free;
end;

procedure TServerProperty.SetValue(const Value: string);
begin
  SetStrValue(Piece(Value,'   [',1));  {get just the  name}
end;

procedure TRpcVersionProperty.SetValue(const Value: string);
begin
{
  try
    if Value = '' then NetError('Configure',XWB_NullRpcVer)
    else SetStrValue(Value);
  except
    on E: EBrokerError do begin
      ShowBrokerError(E);
      SetStrValue('0');
    end;
  end;
}
  if Value <> '' then SetStrValue(Value)
  else begin
    ShowMessage('RPCVersion cannot be empty.  Default is 0 (zero).');
    SetStrValue('0');
  end;
end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TRemoteProc),nil,'',TRemoteProcProperty);
  RegisterPropertyEditor(TypeInfo(TServer),nil,'',TServerProperty);
  RegisterPropertyEditor(TypeInfo(TRpcVersion),nil,'',TRpcVersionProperty);
end;

end.

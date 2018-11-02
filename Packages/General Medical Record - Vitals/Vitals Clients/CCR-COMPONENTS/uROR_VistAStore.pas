unit uROR_VistAStore;
{$I Components.inc}

interface

uses
  SysUtils, Classes, Forms, OvcStore, TRPCB;

type

  TRPCStringList = class(TStringList)
  protected
    fRPCBroker: TRPCBroker;
    fRPCLoadParams: String;
    fRPCSaveParams: String;

  public
    constructor Create(const aLoadParamsRPC: String; const aSaveParamsRPC: String);
    destructor  Destroy; override;

    procedure LoadFromFile(const FileName: String); override;
    procedure SaveToFile(const FileName: String); override;

    property RPCBroker: TRPCBRoker read fRPCBroker write fRPCBroker;

  end;

  TCCRVistAStore = class(TO32XMLFileStore)
  protected
    fLocked:        Boolean;
    fOnAfterOpen:   TNotifyEvent;
    fOnBeforeClose: TNotifyEvent;
    fOnBeforeOpen:  TNotifyEvent;
    fOptimization:  Boolean;
    fRPCBroker:     TRPCBroker;
    fRPCLoadParams: String;
    fRPCSaveParams: String;

  protected
    procedure DoClose; override;
    procedure DoOpen; override;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Close;

    property XMLText: TStringList        read FStore;

  published
    property OnAfterOpen: TNotifyEvent   read fOnAfterOpen   write fOnAfterOpen;
    property OnBeforeClose: TNotifyEvent read fOnBeforeClose write fOnBeforeClose;
    property OnBeforeOpen: TNotifyEvent  read fOnBeforeOpen  write fOnBeforeOpen;
    property Optimization: Boolean       read fOptimization  write fOptimization;
    property RPCBroker: TRPCBRoker       read fRPCBroker     write fRPCBroker;
    property RPCLoadParams: String       read fRPCLoadParams write fRPCLoadParams;
    property RPCSaveParams: String       read fRPCSaveParams write fRPCSaveParams;

  end;

implementation

uses
  fROR_PCall, uROR_Utilities;

///////////////////////////////// TRPCStringList \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TRPCStringList.Create(const aLoadParamsRPC: String; const aSaveParamsRPC: String);
begin
  inherited Create;
  fRPCBroker := nil;
  fRPCLoadParams := aLoadParamsRPC;
  fRPCSaveParams := aSaveParamsRPC;
end;

destructor TRPCStringList.Destroy;
begin
  fRPCBroker := nil;
  inherited;
end;

procedure TRPCStringList.LoadFromFile(const FileName: String);
var
  prmName: String;
begin
  if not Assigned(RPCBroker) or (fRPCLoadParams = '') then
    begin
      Clear;
      Exit;
    end;

  prmName := ExtractFileName(FileName);
  try
    CallRemoteProc(RPCBroker, fRPCLoadParams,
      [prmName, 'USR'], nil, [rpcSilent], self);
  except
  end;
  if Count > 0 then Delete(0);
end;

procedure TRPCStringList.SaveToFile(const FileName: String);
var
  prmName: String;
begin
  if not Assigned(RPCBroker) or (fRPCSaveParams = '') then Exit;

  prmName := ExtractFileName(FileName);
  try
    if Count > 0 then
      CallRemoteProc(RPCBroker, fRPCSaveParams,
        [prmName, 'USR'], Self, [rpcSilent])
    else
      CallRemoteProc(RPCBroker, fRPCSaveParams,
        [prmName, 'USR', '@'], nil, [rpcSilent]);
  except
  end;
end;

///////////////////////////////// TCCRVistAStore \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRVistAStore.Create(anOwner: TComponent);
begin
  inherited;
  fRPCBroker := nil;
end;

destructor TCCRVistAStore.Destroy;
begin
  if fOptimization then Close;
  fRPCBroker := nil;
  inherited;
end;

procedure TCCRVistAStore.Close;
begin
  try
    fLocked := False;
    if Assigned(FStore) then
      inherited Close;
  except
  end;
end;

procedure TCCRVistAStore.DoClose;
begin
  if not fLocked then
    begin
      if Assigned(OnBeforeClose) then OnBeforeClose(self);
      inherited;
    end;
end;

procedure TCCRVistAStore.DoOpen;
begin
  if not fLocked then
    begin
      if Assigned(OnBeforeOpen) then OnBeforeOpen(self);
      FStore := TRPCStringList.Create(RPCLoadParams, RPCSaveParams);
      TRPCStringList(FStore).RPCBroker := RPCBroker;
      FStore.LoadFromFile(XMLFileName);
      try
        xsInitialize;
      except
        FStore.Clear;
        xsInitialize;
      end;
      if fOptimization then fLocked := True;
      if Assigned(OnAfterOpen) then OnAfterOpen(self);
    end;
end;

end.

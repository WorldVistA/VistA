unit uMessageAdapterManager;

interface

uses
  System.JSON,
  Vcl.Forms,
  VAShared.UDataTracker,
  VAShared.GenericStringList;

const
  DelphiMessageStr = 'delphiMessage';

type
  TDataRetriever = function(Name: string): string of object;

  TMessageAdapter = class(TObject)
  private
    FDataRetriever: TDataRetriever;
    FDelphiMessage: TJSONObject;
    FMessageType: string;
    FPath: string;
  protected
    function RetrieveData(Name: string): string;
    procedure Update(Form: TForm; JSON: TJSONObject); virtual; abstract;
    property DelphiMessage: TJSONObject read FDelphiMessage;
    property MessageType: string read FMessageType;
    property Path: string read FPath;
  public
    procedure UpdateMessage(Form: TForm; JSON: TJSONObject;
      ADataRetriever: TDataRetriever);
  end;

  TMessageAdapterManager = class
  private
    class var FAdapters: TStringList<TMessageAdapter>;
    class destructor Destroy;
    class function GetAdapter(Message: string): TMessageAdapter; static;
  public
    class procedure RegisterAdapter(Messages: array of string;
      Adapter: TMessageAdapter);
    class property Adapter[Message: string]: TMessageAdapter read GetAdapter;
  end;

implementation

uses
  System.SysUtils,
  VAShared.UJSONValueHelper,
  ORFn;

{ TMessageAdapterManager }

class destructor TMessageAdapterManager.Destroy;
begin
  if Assigned(FAdapters) then
    FreeAndNil(FAdapters);
end;

class function TMessageAdapterManager.GetAdapter(Message: string)
  : TMessageAdapter;
var
  Name: string;
begin
  Result := nil;
  if Assigned(FAdapters) then
  begin
    Name := U + Message + U;
    for var I := 0 to FAdapters.Count - 1 do
      if FAdapters[I].Contains(Name) then
        Exit(FAdapters.Objects[I]);
  end;
end;

class procedure TMessageAdapterManager.RegisterAdapter
  (Messages: array of string; Adapter: TMessageAdapter);
var
  Name: string;
begin
  Name := U;
  for var I := 0 to Length(Messages) - 1 do
    if Messages[I].Trim <> '' then
      Name := Name + Messages[I].Trim + U;
  if Name <> U then
  begin
    if not Assigned(FAdapters) then
    begin
      FAdapters := TStringList<TMessageAdapter>.Create;
      FAdapters.CaseSensitive := True;
    end;
    if FAdapters.IndexOfObject(Adapter) < 0 then
      FAdapters.AddObject(Name, Adapter);
  end;
end;

{ TMessageAdapter }

function TMessageAdapter.RetrieveData(Name: string): string;
begin
  if Assigned(FDataRetriever) then
    Result := FDataRetriever(Name)
  else
    Result := '';
end;

procedure TMessageAdapter.UpdateMessage(Form: TForm; JSON: TJSONObject;
  ADataRetriever: TDataRetriever);
begin
  FDataRetriever := ADataRetriever;
  FDelphiMessage := JSON.AsTypeDef<TJSONObject>(DelphiMessageStr, nil);
  if not Assigned(FDelphiMessage) then
    raise EArgumentException.Create('JSON sent to ' + ClassName + ' has no ' +
      DelphiMessageStr + ' field.');
  FMessageType := FDelphiMessage.AsTypeDef<string>('type', '');
  FPath := FDelphiMessage.AsTypeDef<string>('path', '');
  Update(Form, JSON);
end;

end.

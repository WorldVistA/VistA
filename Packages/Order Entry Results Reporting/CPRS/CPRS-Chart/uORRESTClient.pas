unit uORRESTClient;

interface

uses
  System.SysUtils, System.Classes, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  TORRESTException = class(Exception);

  TORRESTClient = class(TObject)
  private
    FClient: TNetHTTPClient;
    FRequest: TNetHTTPRequest;
    FHeader: TNameValuePair;
    FAPIKey: TNameValuePair;
    FServer: String;
    FPath: String;
  protected
    procedure SetServer(AURI: string);
    procedure SetPath(AURI: string);
  public
    function Post(AURI: string; APayload: string): string; overload;
    function Post(APayload: string): string; overload;
    function Get(anID: String): string;
    constructor Create;
    destructor Destroy; override;

    property Server: string read FServer write SetServer;
    property Path: string read FPath write SetPath;
  end;

implementation
uses
  uGN_RPCLog;

const
  HEADER_CONTENT_TYPE = 'Content-Type';
  HEADER_APPLICATION_JSON = 'application/json';

  // For authentication to the DST web services portal.
  HEADER_APIKEY_NAME = 'APIKEY';
  HEADER_APIKEY_VALUE = 'MjU3YmNlNDgtOWFjOS00NGVhLTg4NzItOWUxYTgwMzJjMDZj';

{ TORRESTClient }

constructor TORRESTClient.Create;
begin
  FClient := TNetHTTPClient.Create(nil);
  FRequest := TNetHTTPRequest.Create(nil);
  FRequest.Client := FClient;
  FHeader.Name := HEADER_CONTENT_TYPE;
  FHeader.Value := HEADER_APPLICATION_JSON;
  FAPIKey.Name := HEADER_APIKEY_NAME;
  FAPIKey.Value := HEADER_APIKEY_VALUE;
end;

destructor TORRESTClient.Destroy;
begin
  FreeAndNil(FRequest);
  FreeAndNil(FClient);
  inherited;
end;

function TORRESTClient.Get(anID: string): string;
var
  ClientStream: TStringStream;
  AResponse: IHTTPResponse;
  StatusText: string;
begin
  ClientStream := TStringStream.Create();
  try
    try

      AResponse := FRequest.Get(FServer + FPath + anID, ClientStream,
        [FHeader, FAPIKey]);

    except
      on E: Exception do
        raise TORRESTException.Create(E.Message);
    end;

    result := AResponse.ContentAsString();

    StatusText := AResponse.StatusText;
    if AResponse.StatusCode > 399 then
      raise TORRESTException.Create('Status Code: ' +
        IntToStr(AResponse.StatusCode) + #13#10 + AResponse.StatusText + #13#10
        + result);
  finally
    addLogLine(anID + #13#10 + result, '--DST GET--');
    FreeAndNil(ClientStream);

  end;
end;

function TORRESTClient.Post(APayload: string): string;
var
  AURI: string;
begin
  if (FServer = '') then
    raise TORRESTException.Create('No server set in TORRestClient.Post');

  if (FPath = '') then
    raise TORRESTException.Create('No path set in TORRestClient.Post');

  AURI := FServer + FPath;

  result := Post(AURI, APayload);
end;

function TORRESTClient.Post(AURI, APayload: string): string;
var
  ClientStream: TStringStream;
  AResponse : IHTTPResponse;
  StatusText: string;
begin
  ClientStream := TStringStream.Create(APayload);
  try
    try
      AResponse := FRequest.Post(AURI, ClientStream ,nil,[FHeader,FAPIKey]);

    except on E:Exception do
      raise TORRESTException.Create(E.Message);
    end;

    result := AResponse.ContentAsString();

    StatusText := AResponse.StatusText;
    if AResponse.StatusCode > 399 then
      raise TORRESTException.Create('Status Code: ' + IntToStr(AResponse.StatusCode) + #13#10 +
        AResponse.StatusText + #13#10 + result);
  finally
    addLogLine(aPayload,'--DST POST--');
    FreeAndNil(ClientStream);

  end;
end;

procedure TORRESTClient.SetPath(AURI: string);
begin
  FPath := AURI;
  if (length(FPath) > 1) and (FPath[1] = '/') then
    FPath := Copy(FPath, 2, length(FPath));
end;

procedure TORRESTClient.SetServer(AURI: string);
begin
  FServer := AURI;
  // Annoyingly, there's nothing like IncludeTrailingPathDelimiter that will let
  // me append a forward slash.
  if (length(FServer) > 0) and (FServer[length(FServer)] <> '/') then
    FServer := FServer + '/';
end;

end.

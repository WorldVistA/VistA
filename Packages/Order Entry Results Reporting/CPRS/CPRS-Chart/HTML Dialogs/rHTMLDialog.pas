unit rHTMLDialog;

interface

uses
  System.JSON;

function CreateWebContentJSON(AContentName: string; out AError: string;
  ASystem: Boolean = False): TJSONObject;
function GetRecordCount(AFileNumber: string): Integer;

implementation

uses
  System.SysUtils,
  ORNet;

function CreateWebContentJSON(AContentName: string; out AError: string;
  ASystem: Boolean = False): TJSONObject;
var
  InputJSON: TJSONObject;
begin
  InputJSON := TJSONObject.Create;
  try
    if AContentName <> '' then
      InputJSON.AddPair('contentName', AContentName);
    if ASystem then
      InputJSON.AddPair('system', True);
    Result := CreateJSONFromVistACall('ORWEB GETWEBCONTENT', AError, InputJSON)
      as TJSONObject;
  finally
    FreeAndNil(InputJSON);
  end;
end;

function GetRecordCount(AFileNumber: string): Integer;
begin
  CallVistA('ORWEB GETFILEINFO', [AFileNumber], Result);
end;

end.

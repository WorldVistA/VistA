unit rPtInfo;

interface

uses
  System.Classes,
  System.JSON,
  System.SysUtils,
  Vcl.Forms,
  ORNet,
  ORFn,
  uPtInfoCommon,
  uPtInfoCore,
  uCore;

function CreatePtInfoData(AOwner: TPtInfoSplitViewBase; out Error: string)
  : TPtInfoData;
function CreateJSONFromPanelClick(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
function CreateJSONfromEditorSave(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
function CreateJSONfromLongList(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
function CreateJSONfromHTMLEditorSave(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;

implementation

uses
  UJSONValueHelper,
  VAUtils,
  uConst;

function CreatePtInfoData(AOwner: TPtInfoSplitViewBase; out Error: string)
  : TPtInfoData;
var
  JSON: TJSONValue;
  InputJSON: TJSONObject;
begin
  Result := nil;
  Error := '';
  InputJSON := TJSONObject.Create;
  try
    InputJSON.AddPair('patientId', Patient.DFN);
    InputJSON.AddPair('package', VISTA_PACKAGE);
    JSON := CreateJSONFromVistACall('ORIRPC GETPANELS', Error, InputJSON,
      'While loading patient information panels');
    try
      if (Error = '') and Assigned(JSON) then
        try
          Result := TPtInfoDataConverter.ToObject<TPtInfoData,
            TPtInfoSplitViewBase>(JSON, AOwner);
        except
          on E: Exception do
            Error := E.ClassName + ' error ' + E.Message +
              'converting JSON to TPtInfoData object' + CRLF + CRLF +
              JSON.Format(3);
        end;
    finally
      FreeAndNil(JSON);
    end;
  finally
    FreeAndNil(InputJSON);
  end;
end;

function CreateJSONFromRPCCall(RPC, Text: string; InputJSON: TJSONValue;
  out Error: string): TJSONValue;
begin
  if Assigned(InputJSON) then
    Text := Text + ' for Panel ID :' + InputJSON.AsTypeDef<string>('id',
      'Unknown');
  Result := CreateJSONFromVistACall(RPC, Error, InputJSON, Text);
end;

function CreateJSONFromPanelClick(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
begin
  Result := CreateJSONFromRPCCall('ORIRPCCL GETCLICK',
    'While retrieving patient information', InputJSON, Error);
end;

function CreateJSONfromEditorSave(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
begin
  Result := CreateJSONFromRPCCall('OREDITOR SAVE', 'While saving data',
    InputJSON, Error);
end;

function CreateJSONfromLongList(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
begin
  Result := CreateJSONFromRPCCall('OREDITOR LONGLIST',
    'While loading long-list data', InputJSON, Error);
end;

function CreateJSONfromHTMLEditorSave(InputJSON: TJSONValue; out Error: string)
  : TJSONValue;
begin
  Result := CreateJSONFromRPCCall('ORHEDITOR SAVE', 'While saving data',
    InputJSON, Error);
end;

end.

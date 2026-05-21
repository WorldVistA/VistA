unit uComboBoxMessageAdapter;

interface

uses
  System.Classes,
  System.Generics.Collections,
  System.Rtti,
  System.JSON,
  System.JSON.Serializers,
  System.JSON.Converters,
  Vcl.Forms,
  Vcl.StdCtrls,
  ORCtrls,
  ORCheckComboBox,
  uMessageAdapterManager;

type
  TComboBoxMessageType = (mtComboBoxCreate, mtComboBoxInputChange,
    mtComboBoxCheckBox, mtComboBoxItemSelect, mtComboBoxQueryIndex);

  [JsonSerialize(TJsonMemberSerialization.Public)]
  TComboBoxUpdateMessage = class(TObject)
  private
    Fchecked: Boolean;
    FdisplayText: string;
    FitemCount: Integer;
    FitemIndex: Integer;
    FselectionStart: Integer;
    FselectionEnd: Integer;
    Fstate: string;
    FtopIndex: Integer;
    FUpdateType: TComboBoxMessageType;
  public
    destructor Destroy; override;
    property checked: Boolean read Fchecked write Fchecked;
    property displayText: string read FdisplayText write FdisplayText;
    property itemCount: Integer read FitemCount write FitemCount;
    property itemIndex: Integer read FitemIndex write FitemIndex;
    property selectionStart: Integer read FselectionStart write FselectionStart;
    property selectionEnd: Integer read FselectionEnd write FselectionEnd;
    property state: string read Fstate write Fstate;
    property topIndex: Integer read FtopIndex write FtopIndex;
    [JsonIgnore]
    property UpdateType: TComboBoxMessageType read FUpdateType
      write FUpdateType;
  end;

  TComboBoxMessageAdapter = class(TMessageAdapter)
  private
//    FComboBox: THTMLComboBox;
    FComboBoxUpdateMessage: TComboBoxUpdateMessage;
    FXParams: TJSONObject;
    function GetRPCBooleanPropertyValue(Data: TJSONValue; PropertyName: string): Boolean;
    function GetRPCPropertyValue(Data: TJSONValue; PropertyName: string): string;
//    procedure AddPropertiesToArray(Data: TJSONValue; ParametersArray: TJSONArray);
    function CreateParameterObject(Data: TJSONValue): TJSONObject;
  protected
//    property ComboBox: THTMLComboBox read FComboBox;
    property ComboBoxUpdateMessage: TComboBoxUpdateMessage
      read FComboBoxUpdateMessage write FComboBoxUpdateMessage;
    property XParams: TJSONObject read FXParams;
  public
    procedure Update(Form: TForm; JSON: TJSONObject); override;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.Generics.Defaults,
  Winapi.Messages,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.ExtCtrls,
  ORFn,
  ORNet,
  VAShared.RttiUtils,
  VAShared.UJSONValueHelper,
  fFrame,
  uORLists,
  fHTMLDialog,
  rHTMLDialog;

function TComboBoxMessageAdapter.CreateParameterObject(Data: TJSONValue): TJSONObject;
var
  ButtonClick: Boolean;
  ParameterObject: TJSONObject;
begin
  ButtonClick := GetRPCBooleanPropertyValue(Data, 'buttonClick');

  ParameterObject := TJSONObject.Create;
  try
    ParameterObject.AddPair('buttonClick', TJSONBool.Create(ButtonClick));
    Result := ParameterObject;
  except
    ParameterObject.Free;
    raise;
  end;
end;

function TComboBoxMessageAdapter.GetRPCBooleanPropertyValue(Data: TJSONValue;
  PropertyName: string): Boolean;
var
  JSONObject: TJSONObject;
  BoolValue: Boolean;
begin
  Result := False; // Default to False if property not found or not a boolean
  if Data is TJSONObject then
  begin
    JSONObject := Data as TJSONObject;
    if JSONObject.TryGetValue<Boolean>(PropertyName, BoolValue) then
      Result := BoolValue;
  end;
end;

function TComboBoxMessageAdapter.GetRPCPropertyValue(Data: TJSONValue;
  PropertyName: string): string;
  var
  JSONObject: TJSONObject;
  begin
    result := '';
    if Data is TJSONObject then
    begin
      JSONObject := Data as TJSONObject;
      JSONObject.TryGetValue<string>(PropertyName, result);
    end;
end;

procedure TComboBoxMessageAdapter.Update(Form: TForm; JSON: TJSONObject);
var
  Data: TJSONValue;
  dir, error, lookupType, startFrom, startId: string;
  InputJSON, ParameterObject, JSONObject: TJSONObject;
  VistaRequiredValues, VistaSourceData: TJSONValue;
  HTMLForm: TfrmHTMLDialog;

function EscapeJSONString(const AValue: string): string;
begin
  Result := AValue;
  Result := Result.Replace('\', '\\'); // Escape backslashes
  Result := Result.Replace('"', '\"'); // Escape double quotes
  Result := Result.Replace(#13#10, '\n'); // Escape new lines (CR+LF)
  Result := Result.Replace(#10, '\n'); // Escape new lines (LF)
  Result := Result.Replace(#13, '\n'); // Escape new lines (CR)
  Result := Result.Replace(#9, '\t'); // Escape tabs
end;

function EscapeJSONValue(Value: TJSONValue): TJSONValue;
var
  JSONObject: TJSONObject;
  JSONArray: TJSONArray;
  Pair: TJSONPair;
  i: Integer;
begin
  // Handle JSON Object
  if Value is TJSONObject then
  begin
    JSONObject := TJSONObject.Create;
    for Pair in TJSONObject(Value) do
      JSONObject.AddPair(EscapeJSONString(Pair.JsonString.Value), EscapeJSONValue(Pair.JsonValue));
    Result := JSONObject;
  end
  // Handle JSON Array
  else if Value is TJSONArray then
  begin
    JSONArray := TJSONArray.Create;
    for i := 0 to TJSONArray(Value).Count - 1 do
      JSONArray.AddElement(EscapeJSONValue(TJSONArray(Value).Items[i]));
    Result := JSONArray;
  end
  // Handle JSON String
  else if Value is TJSONString then
    Result := TJSONString.Create(EscapeJSONString(TJSONString(Value).Value))
  // For other types, just clone
  else
    Result := Value.Clone as TJSONValue;
end;

begin
  if Path = '' then
    Exit;

  Data := DelphiMessage.AsTypeDef<TJSONValue>('data', nil);
  VistaRequiredValues := nil;
  VistaSourceData := nil;
  if Assigned(Data) then
  begin
    if Form is TfrmHTMLDialog then
    begin
      HTMLForm := TfrmHTMLDialog(Form);

      if (HTMLForm.readParams.JSONData <> '') then
      begin
        JSONObject := TJSONObject.ParseJSONValue(HTMLForm.readParams.JSONData) as TJSONObject;
        if assigned(JSONObject) then // add this check to ensure JSONObject is not nil
        begin
          if not JSONObject.TryGetValue<TJSONValue>('vistaRequiredValues', VistaRequiredValues) then
            VistaRequiredValues := nil;
          if not JSONObject.TryGetValue<TJSONValue>('vistaSourceData', VistaSourceData) then
            VistaSourceData := nil;
        end;
      end;
    end;

    lookupType := GetRPCPropertyValue(data, 'lookupType');
    dir := GetRPCPropertyValue(data, 'direction');
    startFrom := GetRPCPropertyValue(data, 'displayText');
    startId :=  GetRPCPropertyValue(data, 'const');

    InputJSON := TJSONObject.Create;
    try
      InputJSON.AddPair('lookupType', lookupType);
      InputJSON.AddPair('startFrom', startFrom);
      InputJson.AddPair('startId', startId);
      InputJSON.AddPair('direction', dir);
      ParameterObject := CreateParameterObject(Data);

      if Assigned(VistaRequiredValues) then
        ParameterObject.AddPair('vistaRequiredValues', VistaRequiredValues.Clone as TJSONObject);
      if Assigned(VistaSourceData) then
        ParameterObject.AddPair('vistaSourceData', VistaSourceData.Clone as TJSONObject);

      InputJSON.AddPair('parameters', ParameterObject);
      Data := CreateJSONFromVistACall('ORHRPC LOOKUP', Error, InputJSON);
      Data := EscapeJSONValue(Data);
    finally
      FreeAndNil(InputJSON);
    end;

    DelphiMessage.ReplacePair('data', Data);
  end;
end;

procedure RegisterAdapter;
var
  List: array of string;
begin
  for var I := Low(TComboBoxMessageType) to High(TComboBoxMessageType) do
  begin
    SetLength(List, Length(List) + 1);
    List[Length(List) - 1] :=
      TRttiUtils.GetEnumNamefromValue<TComboBoxMessageType>(I, 'mt');
  end;
  TMessageAdapterManager.RegisterAdapter(List, TComboBoxMessageAdapter.Create);
end;

{ TComboBoxUpdateMessage }

destructor TComboBoxUpdateMessage.Destroy;
begin
//  FreeAndNil(FselectedItem);
  inherited;
end;

initialization

RegisterAdapter;
//TRPCProcRegistry.RegisterRPCProc(TRPCProc.Create('uORLists.setPersonList',
//  stComboStartDirProc, @uORLists.setPersonList))

end.

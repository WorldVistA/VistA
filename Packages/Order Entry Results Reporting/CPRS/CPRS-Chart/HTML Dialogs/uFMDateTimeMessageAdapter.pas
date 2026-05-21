unit uFMDateTimeMessageAdapter;

interface

uses
  System.JSON,
  Vcl.Forms,
  uMessageAdapterManager;

type
  TFMDateTimeMessageAdapter = class(TMessageAdapter)
  public
    procedure Update(Form: TForm; JSON: TJSONObject); override;
  end;

implementation

uses
  System.SysUtils,
  ORFn,
  ORNet,
  VAShared.UJSONValueHelper;

const
  FMDateConst = 'FormatFMDate';
  FMDateTimeConst = 'FormatFMDateTime';
  FMDataFormat = 'JSON FMDate Format';
  FMDataTimeFormat = 'JSON FMDateTime Format';
  ExternalStr = 'external';
  InternalStr = 'internal';

  { TFMDateTimeMessageAdapter }

procedure TFMDateTimeMessageAdapter.Update(Form: TForm; JSON: TJSONObject);
var
  Format, Value, ExValue, DTString: string;
  Data: TJSONObject;
  DT: TFMDateTime;

  procedure UpdateForFMDate;
  begin
    Format := RetrieveData(FMDataFormat);
    ExValue := FormatFMDateTime(Format, DT);
  end;

  procedure UpdateForFMDateTime;
  begin
    DTString := DT.ToString;
    if Length(Value) < Length(DTString) then
      Value := DTString;
    if Length(Value) > 7 then
      Format := FMDataTimeFormat
    else
      Format := FMDataFormat;
    Format := RetrieveData(Format);
    ExValue := FormatFMDateTime(Format, DT);
  end;

begin
  Data := DelphiMessage.AsTypeDef<TJSONObject>('data', TJSONObject.Create);
  Value := Data.AsTypeDef<string>(ExternalStr, '');
  DT := GetFMDT(Value);
  if DT < 0 then
    ExValue := ''
  else if MessageType = FMDateConst then
    UpdateForFMDate
  else if MessageType = FMDateTimeConst then
    UpdateForFMDateTime;
  Data.ReplacePair(InternalStr, TJSONString.Create(DT.ToString));
  Data.ReplacePair(ExternalStr, TJSONString.Create(ExValue));
end;

initialization

TMessageAdapterManager.RegisterAdapter([FMDateConst, FMDateTimeConst],
  TFMDateTimeMessageAdapter.Create);

end.

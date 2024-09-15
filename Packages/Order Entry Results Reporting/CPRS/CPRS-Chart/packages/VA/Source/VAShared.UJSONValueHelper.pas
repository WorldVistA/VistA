unit VAShared.UJSONValueHelper;

interface

uses
  System.JSON;

type
  TJSONValueHelper = class helper for TJSONValue
  public
    function AsTypeDef<T>(const APath: string; const Def: T): T;
  end;

implementation
uses
  VAShared.UJSONParameters;

function TJSONValueHelper.AsTypeDef<T>(const APath: string; const Def: T): T;
var
  AJSONValue: TJSONValue;
  Success: Boolean;
begin
  try
    AJSONValue := FindValue(APath);
    if not Assigned(AJSONValue) then Exit(Def);
    Success := TJSONParameters.TryAsType<T>(AJSONValue, Result);
    if not Success then Exit(Def);
  except
    Result := Def;
  end;
end;

end.

unit VAShared.UJSONValueHelper;

interface

{$IF DEFINED(VER290) OR DEFINED(VER300) OR DEFINED(VER310) OR DEFINED(VER320) OR DEFINED(VER330) OR DEFINED(VER340) OR DEFINED(VER350)}
{$UNDEF DELPHI12ORHIGHER}
{$ELSE}
{$DEFINE DELPHI12ORHIGHER}
{$IFEND}

uses
  System.SysUtils,
  System.JSON;

type
  TJSONValueHelper = class helper for TJSONValue
{$IFDEF DELPHI12ORHIGHER}
  private const
    // The JSON to Object features of Delphi 12 support 2 different libraries,
    // REST.Json and System.JSON.Serializers.  We are choosing
    // System.JSON.Serializers because it supports additional funcality, such
    // as TObjectList<T> structured arrays.
    JSONMapperLibrary = 'System.JSON.Serializers';
{$ENDIF}
  public
    function AsTypeDef<T>(const APath: string; const Def: T): T;
{$IFDEF DELPHI12ORHIGHER}
    class function ParseFromObject<T>(AInput: T): TJSONValue;
    class function ToObject<T>(AInput: string): T; overload;
    function ToObject<T>: T; overload;
{$ENDIF}
  end;

  TJSONObjectHelper = class helper for TJSONObject
  public
    function ReplacePair(const Str: string; const Val: TJSONValue): TJSONObject;
  end;

implementation

uses
  System.Rtti,
  System.Generics.Collections,
  VAShared.UJSONParameters;

{ TJSONValueHelper }

function TJSONValueHelper.AsTypeDef<T>(const APath: string; const Def: T): T;
var
  AJSONValue: TJSONValue;
  Success: Boolean;
begin
  try
    AJSONValue := FindValue(APath);
    if not Assigned(AJSONValue) then
      Exit(Def);
    Success := TJSONParameters.TryAsType<T>(AJSONValue, Result);
    if not Success then
      Exit(Def);
  except
    Result := Def;
  end;
end;

{$IFDEF DELPHI12ORHIGHER}

class function TJSONValueHelper.ToObject<T>(AInput: string): T;
begin
  TJSONMapper<T>.SetDefaultLibrary(JSONMapperLibrary);
  Result := TJSONMapper<T>.Default.FromObject(AInput);
end;

class function TJSONValueHelper.ParseFromObject<T>(AInput: T): TJSONValue;
begin
  TJSONMapper<T>.SetDefaultLibrary(JSONMapperLibrary);
  Result := TJSONMapper<T>.Default.ToObject(AInput);
end;

function TJSONValueHelper.ToObject<T>: T;
begin
  TJSONMapper<T>.SetDefaultLibrary(JSONMapperLibrary);
  Result := TJSONMapper<T>.Default.FromObject(Self);
end;
{$ENDIF}

{ TJSONObjectHelper }

function TJSONObjectHelper.ReplacePair(const Str: string;
  const Val: TJSONValue): TJSONObject;
var
  Value: TJSONPair;
begin
  Value := RemovePair(Str);
  if Assigned(Value) then
    FreeAndNil(Value);
  AddPair(Str, Val);
  Result := Self;
end;

end.

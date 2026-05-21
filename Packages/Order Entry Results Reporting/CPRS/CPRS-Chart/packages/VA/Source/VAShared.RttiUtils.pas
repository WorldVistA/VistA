unit VAShared.RttiUtils;

interface

uses
  System.Rtti,
  System.TypInfo;

type
  TRttiUtils = class
  public type
    TEnumOption = (eoDefaultFirst, eoStripSpaces);
    TEnumOptions = set of TEnumOption;
  public
    class function GetEnumNamefromValue<T>(Value: T;
      StripPrefix: string = ''): string;
    class function GetEnumValueFromString<T>(const AName: string;
      const Prefix: string = '';
      EnumOptions: TEnumOptions = [eoDefaultFirst, eoStripSpaces]): T; overload;
    class function GetEnumValueFromString<T>(const AName: string;
      const AlternateNames: array of string;
      EnumOptions: TEnumOptions = [eoDefaultFirst]): T; overload;
    class function GetRttiField(ATypeInf: PTypeInfo; AName: string;
      AParentClassName: string = ''): TRttiField;
    class function GetRttiProperty(ATypeInf: PTypeInfo; AName: string;
      AParentClassName: string = ''): TRttiProperty;
  end;

implementation

uses
  System.SysUtils;

{ TRttiUtils }

class function TRttiUtils.GetEnumNamefromValue<T>(Value: T;
  StripPrefix: string = ''): string;
var
  TypeInfo: PTypeInfo;
  ValueAsOrdinal: Integer;
begin
  TypeInfo := System.TypeInfo(T);
  // Ensure that T is an enumerated type
  if TypeInfo^.Kind <> tkEnumeration then
    raise Exception.Create('Type T must be an enumerated type');
  ValueAsOrdinal := TValue.From<T>(Value).AsOrdinal;
  Result := GetEnumName(TypeInfo, ValueAsOrdinal);
  if Result.StartsWith(StripPrefix) then
    Result := copy(Result, Length(StripPrefix) + 1, MaxInt);
end;

class function TRttiUtils.GetEnumValueFromString<T>(const AName, Prefix: string;
  EnumOptions: TEnumOptions): T;
var
  IValue: Integer;
  ATypeInf: PTypeInfo;
  TypeData: PTypeData;
  Value: TValue;
  Name: string;
begin
  ATypeInf := TypeInfo(T);
  Name := AName;
  if eoStripSpaces in EnumOptions then
    Name := Name.Replace(' ', '');
  IValue := GetEnumValue(ATypeInf, Name);
  if (IValue < 0) and (Prefix <> '') then
    IValue := GetEnumValue(ATypeInf, Prefix + Name);
  TypeData := ATypeInf^.TypeData;
  if (IValue < TypeData^.MinValue) or (IValue > TypeData^.MaxValue) then
    if (eoDefaultFirst in EnumOptions) then
      IValue := TypeData^.MinValue
    else
      raise EArgumentException.Create('GetEnumValueFromString can''t find ' +
        AName + ' in ' + GetTypeName(ATypeInf));
  TValue.Make(@IValue, ATypeInf, Value);
  Result := Value.AsType<T>;
end;

class function TRttiUtils.GetEnumValueFromString<T>(const AName: string;
  const AlternateNames: array of string; EnumOptions: TEnumOptions): T;
var
  IValue, idx, max: Integer;
  ATypeInf: PTypeInfo;
  TypeData: PTypeData;
  Value: TValue;
  Name: string;
begin
  ATypeInf := TypeInfo(T);
  TypeData := ATypeInf^.TypeData;
  IValue := -1;
  max := Length(AlternateNames);
  for idx := TypeData^.MinValue to TypeData^.MaxValue do
  begin
    inc(IValue);
    if IValue < max then
    begin
      Name := AName;
      if eoStripSpaces in EnumOptions then
        Name := Name.Replace(' ', '');
      if CompareText(Name, AlternateNames[IValue]) = 0 then
      begin
        TValue.Make(@idx, ATypeInf, Value);
        Exit(Value.AsType<T>);
      end;
    end;
  end;
  if (eoDefaultFirst in EnumOptions) then
  begin
    IValue := TypeData^.MinValue;
    TValue.Make(@IValue, ATypeInf, Value);
    Result := Value.AsType<T>;
  end
  else
    raise EArgumentException.Create('GetEnumValueFromString can''t find ' +
      AName + ' in ' + GetTypeName(ATypeInf));
end;

class function TRttiUtils.GetRttiField(ATypeInf: PTypeInfo;
  AName, AParentClassName: string): TRttiField;
var
  Ctx: TRttiContext;
  LType: TRttiType;
begin
  Ctx := TRttiContext.Create();
  try
    LType := Ctx.GetType(ATypeInf);
    for Result in LType.GetFields do
      if (CompareText(Result.Name, AName) = 0) then
      begin
        if AParentClassName = '' then
          Exit
        else if Result.Parent.Name = AParentClassName then
          Exit;
      end;
    Result := nil;
  finally
    Ctx.Free;
  end;
end;

class function TRttiUtils.GetRttiProperty(ATypeInf: PTypeInfo;
  AName, AParentClassName: string): TRttiProperty;
var
  Ctx: TRttiContext;
  LType: TRttiType;
begin
  Ctx := TRttiContext.Create();
  try
    LType := Ctx.GetType(ATypeInf);
    for Result in LType.GetProperties do
      if (CompareText(Result.Name, AName) = 0) and
        ((AParentClassName = '') or (Result.Parent.Name = AParentClassName))
      then
        Exit;
    Result := nil;
  finally
    Ctx.Free;
  end;
end;

end.

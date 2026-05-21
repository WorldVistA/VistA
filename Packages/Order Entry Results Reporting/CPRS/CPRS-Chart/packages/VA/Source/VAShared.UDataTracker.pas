unit VAShared.UDataTracker;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  System.TypInfo,
  VAShared.GenericStringList;

type
  TDataTracker = class
  private type
    TDataInfo = class
    private
      FData: Pointer;
      FType: PTypeInfo;
    public
      constructor Create(ADataPointer, ATypeInfo: Pointer);
    end;
  private
    FDataList: TStringList<TDataTracker.TDataInfo>;
    FValues: TDictionary<string, string>;
    procedure EnsureDictionary;
    function GetData(DataPath: string): TValue;
    function GetValue(AName: string): string;
    procedure SetValue(AName: string; const Value: string);
  public
    destructor Destroy; override;
    procedure Clear;
    procedure AddData(AName: string; ADataPointer, ATypeInfo: Pointer);
    function HasData(AName: string): Boolean;
    function HasValue(AName: string): Boolean;
    property Data[DataPath: string]: TValue read GetData;
    property Value[AName: string]: string read GetValue
      write SetValue;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Defaults;

{ TDataTracker.TDataInfo }

constructor TDataTracker.TDataInfo.Create(ADataPointer, ATypeInfo: Pointer);
begin
  inherited Create;
  FData := ADataPointer;
  FType := ATypeInfo;
end;

{ TDataTracker }

procedure TDataTracker.AddData(AName: string; ADataPointer, ATypeInfo: Pointer);
begin
  if not Assigned(FDataList) then
  begin
    FDataList := TStringList<TDataInfo>.Create(dupIgnore, True, False);
    FDataList.OwnsObjects := True;
  end;
  if FDataList.IndexOf(AName) < 0 then
    FDataList.AddObject(AName, TDataInfo.Create(ADataPointer, ATypeInfo))
  else
    raise EArgumentException.Create('Data with the name ' + AName +
      ' has already been added to ' + ClassName);
end;

procedure TDataTracker.Clear;
begin
  if Assigned(FDataList) then
    FDataList.Clear;
  if Assigned(FValues) then
    FValues.Clear;
end;

destructor TDataTracker.Destroy;
begin
  FreeAndNil(FDataList);
  FreeAndNil(FValues);
  inherited;
end;

procedure TDataTracker.EnsureDictionary;
begin
  if not Assigned(FValues) then
    FValues := TDictionary<string, string>.Create
      (TEqualityComparer<string>.Construct(
      function(const Left, Right: string): Boolean
      begin
        Result := CompareText(Left, Right) = 0; // Case-insensitive comparison
      end,
      function(const Value: string): Integer
      begin
        Result := TEqualityComparer<string>.Default.GetHashCode(Value.ToLower);
      end));
end;

function TDataTracker.GetData(DataPath: string): TValue;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiProperty: TRttiProperty;
  RttiField: TRttiField;
  MemberName, Path: string;
  MemberNames: TArray<string>;
  First: Boolean;
  CurrentValue: TValue;
  AData: TDataInfo;
  idx: Integer;

begin
  Result := TValue.Empty;
  if (DataPath = '') or (not Assigned(FDataList)) then
    Exit(TValue.Empty);
  MemberNames := DataPath.Split(['.']);
  First := True;
  RttiContext := TRttiContext.Create;
  try
    RttiType := nil;
    Path := '';
    for MemberName in MemberNames do
    begin
      if First then
      begin
        Path := MemberName;
        idx := FDataList.IndexOf(MemberName);
        if idx < 0 then
          Exit(TValue.Empty);
        AData := FDataList.Objects[idx];
        RttiType := RttiContext.GetType(AData.FType);
        TValue.Make(AData.FData, AData.FType, CurrentValue);
        First := False;
      end
      else
      begin
        Path := Path + '.' + MemberName;
        if RttiType is TRttiInstanceType then
        begin
          // Look for a property with the given name
          RttiProperty := TRttiInstanceType(RttiType).GetProperty(MemberName);
          if Assigned(RttiProperty) then
            CurrentValue := RttiProperty.GetValue(CurrentValue.AsObject)
          else
          begin
            RttiField := TRttiInstanceType(RttiType).GetField(MemberName);
            if Assigned(RttiField) then
              CurrentValue := RttiField.GetValue(CurrentValue.AsObject)
            else
              Exit(TValue.Empty);
          end;
        end
        else if RttiType is TRttiRecordType then
        begin
          // Look for a field with the given name
          RttiField := TRttiRecordType(RttiType).GetField(MemberName);
          if Assigned(RttiField) then
            CurrentValue := RttiField.GetValue
              (CurrentValue.GetReferenceToRawData)
          else
            Exit(TValue.Empty);
        end
        else
          Exit(TValue.Empty);
        RttiType := RttiContext.GetType(CurrentValue.TypeInfo);
      end;
      Result := CurrentValue;
    end;
  finally
    RttiContext.Free;
  end;
end;

function TDataTracker.GetValue(AName: string): string;
begin
  Result := '';
  if AName <> '' then
  begin
    EnsureDictionary;
    if FValues.ContainsKey(AName) then
      Result := FValues.Items[AName]
  end;
end;

function TDataTracker.HasData(AName: string): Boolean;
begin
  Result := not GetData(AName).IsEmpty;
end;

function TDataTracker.HasValue(AName: string): Boolean;
begin
  EnsureDictionary;
  Result := FValues.ContainsKey(AName);
end;

procedure TDataTracker.SetValue(AName: string; const Value: string);
begin
  if AName <> '' then
  begin
    EnsureDictionary;
    if FValues.ContainsKey(AName) then
      FValues[AName] := Value
    else
      FValues.Add(AName, Value);
  end;
end;

end.

unit IDEUtils.JSONDescendantClassesCommon;

interface

uses
  System.Classes, VAShared.GenericStringList;

type
  TVarInfo = class
  private
    FVarName: string;
    FVarType: string;
    FVarDefault: string;
  end;

  TMethodType = (mtConstructor, mtDestructor, mtProcedure, mtFunction);

  TMethodInfo = class
  private
    FClassMethod: Boolean;
    FMethodType: TMethodType;
    FName: string;
    FName2: string;
    FOverload: Boolean;
    FReturnType: string;
    FParameters: TStringList<TVarInfo>;
    FVars: TStringList<TVarInfo>;
    FLines: TStringList;
    FSubMethods: TStringList<TMethodInfo>;
    FIndentLevel: Integer;
  public
    constructor Create(AMethodType: TMethodType; AName: string;
      AReturnType: string = '');
    destructor Destroy; override;
    function AddSubMethod(AMethodType: TMethodType; AName: string;
      AReturnType: string = ''): TMethodInfo;
    function AddParam(AName, AType: string): TVarInfo;
    function AddVar(AName, AType: string): TVarInfo;
    property Lines: TStringList read FLines;
  end;

  TPropertyInfo = class
  private
    FField: string;
    FNewField: string;
    FName: string;
    FOldName: string;
    FPropType: string;
    FNewPropType: string;
    function GetListType: string;
    function GetSubType: string;
  public
    property Field: string read FField;
    property ListType: string read GetListType;
    property Name: string read FName;
    property PropType: string read FPropType;
    property SubType: string read GetSubType;
  end;

  TClassInfo = class(TObject)
  private
    FName: string;
    FOwnerPropertyName: string;
    FOwnerPropertyClassName: string;
    FParentClass: string;
    FPrivateFields: TStringList<TVarInfo>;
    FPrivateMethods: TStringList<TMethodInfo>;
    FProtectedMethods: TStringList<TMethodInfo>;
    FPublicProperties: TStringList<TPropertyInfo>;
    FPublicMethods: TStringList<TMethodInfo>;
  public
    constructor Create(AName, AParentClass: string);
    destructor Destroy; override;
    function AddPrivateFields(AName, AType: string): TVarInfo;
    function AddPrivateMethods(AMethodType: TMethodType; AName: string;
      AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
    function AddProtectedMethods(AMethodType: TMethodType; AName: string;
      AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
    function AddPublicMethods(AMethodType: TMethodType; AName: string;
      AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
    function AddPublicProperty(AName, AOldName, AType, AField: string)
      : TPropertyInfo;
  end;

  TConverterInfo = class
  private
    FParentType: string;
    FPropName: string;
    FConverterName: string;
    FSubClassName: string;
  end;

  TUnitInfo = class
  private
    FClasses: TStringList<TClassInfo>;
    FForwards: TStringList;
    FProjectFileName: string;
    FProjectUnitName: string;
    FBuildOwners: Boolean;
    FOwnerName: string;
    FTopClassOwner: Boolean;
    FTopClassOwnerName: string;
    FPrefix: string;
    FSuffix: string;
    FFreeOldProc: TMethodInfo;
    FConverterClass: TClassInfo;
    FGlobalVars: TStringList<TVarInfo>;
    FLibraryName: string;
    FSerializerClass: TClassInfo;
    FSerializerRegisterName: string;
    FPropertyConverters: TStringList<TConverterInfo>;
    function GetMainClass: TClassInfo;
  public
    constructor Create;
    destructor Destroy; override;
    function AddGlobalVar(AName, AType: string; ADefault: string = '')
      : TVarInfo;
    function AddPropertyConverter(AParentType, APropName, AConverterName,
      ASubClassName: string): TConverterInfo;
    property Classes: TStringList<TClassInfo> read FClasses;
    property Forwards: TStringList read FForwards;
    property ProjectUnitName: string read FProjectUnitName
      write FProjectUnitName;
    property ProjectFileName: string read FProjectFileName
      write FProjectFileName;
    property Prefix: string read FPrefix write FPrefix;
    property Suffix: string read FSuffix write FSuffix;
    property BuildOwners: Boolean read FBuildOwners write FBuildOwners;
    property OwnerName: string read FOwnerName write FOwnerName;
    property MainClass: TClassInfo read GetMainClass;
    property TopClassOwner: Boolean read FTopClassOwner write FTopClassOwner;
    property TopClassOwnerName: string read FTopClassOwnerName
      write FTopClassOwnerName;
  end;

procedure GatherUnitInfo(sl: TStringList; UnitInfo: TUnitInfo);
procedure BuildDescendantUnit(sl: TStringList; UnitInfo: TUnitInfo);

const
  OwnerNamePlusClass = 'Owner + Class Name minus T (OwnerMyClass: TMyClass)';
  OwnerNameFromClass = 'Class Name minus T (MyClass: TMyClass)';
  OwnerNameOwner = 'Owner';

implementation

uses
  System.SysUtils;

const
  ArrayListConst = 'TArray';
  BeginConst = 'begin';
  ClassConst = '=class(';
  CreateConst = 'Create';
  EndConst = 'end;';
  FinalizationConst = 'finalization';
  FreeAndNilOldConst = 'FreeAndNilOld';
  IgnorePropertiesConst = 'IgnoreProperties';
  ImplementationConst = 'implementation';
  InitializationConst = 'initialization';
  InterfaceConst = 'interface';
  JSONConverterConst = 'Converter';
  JSONConverterInternalToObjectConst1 = 'InternalToObject<T, U: class>';
  JSONConverterInternalToObjectConst2 = 'InternalToObject<T, U>';
  JSONConverterInternalToObjectConst3 = 'InternalToObject<T, TObject>';
  JSONConverterLibraryNameConst = 'LibraryName';
  JSONConverterToJSONConst = 'ToJSON<T>';
  JSONConverterToObjectConst1 = 'ToObject<T: class>';
  JSONConverterToObjectConst2 = 'ToObject<T>';
  JSONConverterToObjectConst3 = 'ToObject<T, U: class>';
  JSONConverterToObjectConst4 = 'ToObject<T, U>';
  JSONLibraryConst = 'JSONLibrary';
  JSONListConverterConst = 'TJsonListConverter';
  JSONTypedListConverterConst = ' = class(TJsonTypedListConverter<';
  ObjectListConst = 'TObjectList';
  PopulateOwnerConst = 'PopulateOwner';
  PrivateConst = 'private';
  PropertyConst = 'property ';
  ProtectedConst = 'protected';
  PublicConst = 'public';
  PublishedConst = 'published';
  ReadConst = ' read ';
  RTTIDirectiveConst =
    '{$RTTI EXPLICIT METHODS([vcProtected, vcPublic, vcPublished])}';
  ToJSONConst = 'ToJSON';
  TypeConst = 'type';
  UsesConst = 'uses';
  Uses1Default = '  System.Generics.Collections, System.JSON, System.JSON.Serializers, ';
  Uses2Default =
    '  System.SysUtils, System.JSON.Converters, System.JSON.Writers,';
  Uses3Default =
    '  System.JSON.Readers, System.Rtti, System.TypInfo, VAShared.RttiUtils;';
  VarConst = 'var';
  WriteConst = ' write ';

function AddVarToList(AList: TStringList<TVarInfo>; AName, AType: string;
  ADefault: string = ''): TVarInfo;
var
  idx: Integer;
begin
  idx := AList.IndexOf(UpperCase(AName));
  if idx < 0 then
  begin
    Result := TVarInfo.Create;
    Result.FVarName := AName;
    Result.FVarType := AType;
    Result.FVarDefault := ADefault;
    AList.AddObject(UpperCase(AName), Result);
  end
  else
    Result := AList.Objects[idx];
end;

function AddMethod(AList: TStringList<TMethodInfo>; AMethodType: TMethodType;
  AName: string; AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
var
  idx: Integer;
begin
  idx := AList.IndexOf(UpperCase(AName));
  if ForceNew or (idx < 0) then
  begin
    Result := TMethodInfo.Create(AMethodType, AName, AReturnType);
    AList.AddObject(UpperCase(AName), Result);
    if ForceNew then
      Result.FOverload := True;
  end
  else
    Result := AList.Objects[idx];
end;

{ TMethodInfo }

function TMethodInfo.AddParam(AName, AType: string): TVarInfo;
begin
  Result := AddVarToList(FParameters, AName, AType);
end;

function TMethodInfo.AddSubMethod(AMethodType: TMethodType;
  AName, AReturnType: string): TMethodInfo;
begin
  Result := AddMethod(FSubMethods, AMethodType, AName, AReturnType);
  Result.FIndentLevel := FIndentLevel + 2;
end;

function TMethodInfo.AddVar(AName, AType: string): TVarInfo;
begin
  Result := AddVarToList(FVars, AName, AType);
end;

constructor TMethodInfo.Create(AMethodType: TMethodType; AName: string;
  AReturnType: string = '');
begin
  inherited Create;
  FLines := TStringList.Create;
  FParameters := TStringList<TVarInfo>.Create;
  FVars := TStringList<TVarInfo>.Create;
  FSubMethods := TStringList<TMethodInfo>.Create;
  FMethodType := AMethodType;
  FName := AName;
  FReturnType := AReturnType;
end;

destructor TMethodInfo.Destroy;
begin
  FreeAndNil(FSubMethods);
  FreeAndNil(FVars);
  FreeAndNil(FParameters);
  FreeAndNil(FLines);
  inherited;
end;

{ TPropertyInfo }

function TPropertyInfo.GetListType: string;
var
  p: Integer;
begin
  Result := '';
  p := pos('<', FPropType);
  if (p > 0) and FPropType.EndsWith('>') then
    Result := copy(FPropType, 1, p - 1);
end;

function TPropertyInfo.GetSubType: string;
var
  p: Integer;
begin
  Result := '';
  p := pos('<', FPropType);
  if (p > 0) and FPropType.EndsWith('>') then
    Result := copy(FPropType, p + 1, Length(FPropType) - p - 1);
end;

{ TClassInfo }

function TClassInfo.AddPrivateFields(AName, AType: string): TVarInfo;
begin
  Result := AddVarToList(FPrivateFields, AName, AType);
end;

function TClassInfo.AddPrivateMethods(AMethodType: TMethodType; AName: string;
  AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
begin
  Result := AddMethod(FPrivateMethods, AMethodType, AName, AReturnType, ForceNew);
end;

function TClassInfo.AddProtectedMethods(AMethodType: TMethodType; AName: string;
  AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
begin
  Result := AddMethod(FProtectedMethods, AMethodType, AName, AReturnType, ForceNew);
end;

function TClassInfo.AddPublicMethods(AMethodType: TMethodType; AName: string;
  AReturnType: string = ''; ForceNew: Boolean = False): TMethodInfo;
begin
  Result := AddMethod(FPublicMethods, AMethodType, AName, AReturnType, ForceNew);
end;

function TClassInfo.AddPublicProperty(AName, AOldName, AType, AField: string)
  : TPropertyInfo;
begin
  Result := TPropertyInfo.Create;
  Result.FName := AName;
  Result.FOldName := AOldName;
  Result.FPropType := AType;
  Result.FField := AField;
  FPublicProperties.AddObject(UpperCase(AName), Result);
end;

constructor TClassInfo.Create(AName, AParentClass: string);
begin
  inherited Create;
  FPrivateFields := TStringList<TVarInfo>.Create;
  FPrivateMethods := TStringList<TMethodInfo>.Create;
  FProtectedMethods := TStringList<TMethodInfo>.Create;
  FPublicMethods := TStringList<TMethodInfo>.Create;
  FPublicProperties := TStringList<TPropertyInfo>.Create;
  FName := AName;
  FParentClass := AParentClass;
end;

destructor TClassInfo.Destroy;
begin
  FreeAndNil(FPublicProperties);
  FreeAndNil(FPublicMethods);
  FreeAndNil(FProtectedMethods);
  FreeAndNil(FPrivateMethods);
  FreeAndNil(FPrivateFields);
  inherited;
end;
{ TUnitInfo }

function TUnitInfo.AddGlobalVar(AName, AType: string; ADefault: string = '')
  : TVarInfo;
begin
  Result := AddVarToList(FGlobalVars, AName, AType, ADefault);
end;

function TUnitInfo.AddPropertyConverter(AParentType, APropName, AConverterName,
  ASubClassName: string): TConverterInfo;
var
  idx: Integer;
begin
  idx := FPropertyConverters.IndexOf(UpperCase(ASubClassName));
  if idx < 0 then
  begin
    Result := TConverterInfo.Create;
    Result.FParentType := AParentType;
    Result.FPropName := APropName;
    Result.FConverterName := AConverterName;
    Result.FSubClassName := ASubClassName;
    FPropertyConverters.AddObject(UpperCase(ASubClassName), Result);
  end
  else
    Result := FPropertyConverters.Objects[idx];
end;

constructor TUnitInfo.Create;
begin
  inherited Create;
  FClasses := TStringList<TClassInfo>.Create;
  FForwards := TStringList.Create;
  FGlobalVars := TStringList<TVarInfo>.Create;
  FPropertyConverters := TStringList<TConverterInfo>.Create;
end;

destructor TUnitInfo.Destroy;
begin
  FreeAndNil(FSerializerClass);
  FreeAndNil(FConverterClass);
  FreeAndNil(FFreeOldProc);
  FreeAndNil(FPropertyConverters);
  FreeAndNil(FGlobalVars);
  FreeAndNil(FForwards);
  FreeAndNil(FClasses);
  inherited;
end;

function TUnitInfo.GetMainClass: TClassInfo;
begin
  if FClasses.Count > 0 then
    Result := FClasses.Objects[FClasses.Count - 1]
  else
    Result := nil;
end;

procedure GatherUnitInfo(sl: TStringList; UnitInfo: TUnitInfo);
var
  i, idx, p, p2: Integer;
  InInterface, InType, InClass, InPublic: Boolean;
  line, AClassName, AParentClass, AOldPropertyName, APropertyName,
    APropertyType, AFieldName: string;
  ClassInfo, ChildClassInfo: TClassInfo;
  PropInfo: TPropertyInfo;
  MethodInfo: TMethodInfo;

  procedure AddOwner(ClsInfo: TClassInfo; AOwnerType: string);
  var
    AParentName: string;
    Temp: string;
  begin
    Temp := AOwnerType;
    if Temp.StartsWith('T') then
      delete(Temp, 1, 1);
    if UnitInfo.OwnerName = OwnerNamePlusClass then
      AParentName := 'Owner' + Temp
    else if UnitInfo.OwnerName = OwnerNameFromClass then
      AParentName := Temp
    else
      AParentName := UnitInfo.OwnerName;
    ClsInfo.FOwnerPropertyName := AParentName;
    ClsInfo.AddPrivateFields('F' + AParentName, AOwnerType);
    MethodInfo := ClsInfo.AddProtectedMethods(mtProcedure, PopulateOwnerConst);
    MethodInfo.AddParam('AOwner', AOwnerType);
    MethodInfo.Lines.Insert(0, 'F' + AParentName + ' := AOwner;');
    ClsInfo.AddPublicProperty(AParentName, '', AOwnerType, 'F' + AParentName);
  end;

  procedure InitClass;
  begin
    InClass := True;
    AParentClass := Trim(copy(line, 1, p - 1));
    AClassName := AParentClass;
    if AClassName.StartsWith('T') then
      delete(AClassName, 1, 1);
    AClassName := 'T' + UnitInfo.Prefix + AClassName + UnitInfo.Suffix;
    ClassInfo := TClassInfo.Create(AClassName, AParentClass);
    InPublic := False;
    UnitInfo.Classes.AddObject(UpperCase(AParentClass), ClassInfo);
  end;

  procedure EnsureFreeOldProc;
  begin
    if not Assigned(UnitInfo.FFreeOldProc) then
    begin
      MethodInfo := TMethodInfo.Create(mtProcedure, FreeAndNilOldConst);
      UnitInfo.FFreeOldProc := MethodInfo;
      MethodInfo.AddParam('ATypeInf', 'PTypeInfo');
      MethodInfo.AddParam('Instance', 'TObject');
      MethodInfo.AddParam('FieldName', 'string');
      MethodInfo.AddVar('LField', 'TRttiField');
      MethodInfo.Lines.Add('LField := GetRttiField(ATypeInf, FieldName);');
      MethodInfo.Lines.Add('if Assigned(LField) then');
      MethodInfo.Lines.Add('begin');
      MethodInfo.Lines.Add('  LField.GetValue(Instance).AsObject.Free;');
      MethodInfo.Lines.Add('  LField.SetValue(Instance, nil);');
      MethodInfo.Lines.Add('end;');
    end;
  end;

  procedure InitProperty;
  begin
    line := Trim(copy(line, Length(PropertyConst) + 1, MaxInt));
    p := pos(':', line);
    if p > 0 then
    begin
      AOldPropertyName := Trim(copy(line, 1, p - 1));
      APropertyName := UpperCase(copy(AOldPropertyName, 1, 1)) +
        copy(AOldPropertyName, 2, MaxInt);
      line := Trim(copy(line, p + 1, MaxInt));
      p := pos(ReadConst, line);
      if p > 0 then
      begin
        p2 := pos(' ', line, p + Length(ReadConst));
        if p2 <= 0 then
          p2 := pos(';', line, p + Length(ReadConst));
        if p2 > 0 then
        begin
          AFieldName := Trim(copy(line, p + Length(ReadConst),
            p2 - p - Length(ReadConst)));
          if AFieldName.StartsWith('F') then
            delete(AFieldName, 1, 1);
          AFieldName := 'F' + UpperCase(copy(AFieldName, 1, 1)) +
            copy(AFieldName, 2, MaxInt);
          APropertyType := Trim(copy(line, 1, p));
          PropInfo := ClassInfo.AddPublicProperty(APropertyName,
            AOldPropertyName, APropertyType, AFieldName);
          idx := UnitInfo.Classes.IndexOf(UpperCase(APropertyType));
          if (idx < 0) and (PropInfo.SubType <> '') then
            idx := UnitInfo.Classes.IndexOf(UpperCase(PropInfo.SubType));
          if idx < 0 then
            ClassInfo.FPublicProperties.delete
              (ClassInfo.FPublicProperties.Count - 1)
          else
          begin
            ChildClassInfo := UnitInfo.Classes.Objects[idx];
            ChildClassInfo.FOwnerPropertyClassName := AClassName;
            if UnitInfo.BuildOwners and (UnitInfo.OwnerName <> '') then
            begin
              if UnitInfo.FForwards.IndexOf(AClassName) < 0 then
                UnitInfo.Forwards.Add(AClassName);
              AddOwner(ChildClassInfo, AClassName);
            end;
            PropInfo.FNewField := 'F' + UnitInfo.Prefix + PropInfo.FName +
              UnitInfo.Suffix;
            if PropInfo.SubType = '' then
              PropInfo.FNewPropType := ChildClassInfo.FName
            else
            begin
              PropInfo.FNewPropType := PropInfo.ListType + '<' +
                ChildClassInfo.FName + '>';
              UnitInfo.AddPropertyConverter(ClassInfo.FName, PropInfo.FName,
                JSONListConverterConst + copy(ChildClassInfo.FName, 2, MaxInt),
                ChildClassInfo.FName);
            end;
            EnsureFreeOldProc;
            MethodInfo := ClassInfo.AddPublicMethods(mtConstructor,
              CreateConst);
            if MethodInfo.Lines.Count = 0 then
              MethodInfo.Lines.Add('inherited ' + CreateConst + ';');
            MethodInfo.Lines.Add(FreeAndNilOldConst + '(TypeInfo(' +
              PropInfo.FPropType + '), Self, ''' + PropInfo.FField + ''');');
            line := PropInfo.FNewField + ' := ' + PropInfo.FNewPropType + '.' +
              CreateConst;
            if PropInfo.ListType = ObjectListConst then
              line := line + '(True)';
            line := line + ';';
            MethodInfo.Lines.Add(line);
            ClassInfo.AddPrivateFields(PropInfo.FNewField,
              PropInfo.FNewPropType);
            MethodInfo := ClassInfo.AddPublicMethods(mtDestructor, 'Destroy');
            if MethodInfo.Lines.Count = 0 then
              MethodInfo.Lines.Add('inherited;');
            MethodInfo.Lines.Insert(0,
              'FreeAndNil(' + PropInfo.FNewField + ');');
            if UnitInfo.BuildOwners then
            begin
              MethodInfo := ClassInfo.AddProtectedMethods(mtProcedure,
                PopulateOwnerConst);
              if PropInfo.ListType = '' then
                MethodInfo.Lines.Add(PropInfo.FNewField + '.' +
                  PopulateOwnerConst + '(Self);')
              else
              begin
                MethodInfo.Lines.Add('for var I := 0 to ' + PropInfo.FNewField +
                  '.Count - 1 do');
                MethodInfo.Lines.Add('  ' + PropInfo.FNewField + '[I].' +
                  PopulateOwnerConst + '(Self);');
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure InitConverterClass;
  begin
    UnitInfo.FLibraryName := copy(UnitInfo.MainClass.FName, 2, MaxInt) +
      JSONLibraryConst;
    UnitInfo.AddGlobalVar(UnitInfo.FLibraryName, 'string');
    ClassInfo := TClassInfo.Create(UnitInfo.MainClass.FName +
      JSONConverterConst, 'TObject');
    UnitInfo.FConverterClass := ClassInfo;

    MethodInfo := ClassInfo.AddPrivateMethods(mtFunction,
      JSONConverterInternalToObjectConst1, 'T');
    MethodInfo.FName2 := JSONConverterInternalToObjectConst2;
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('JSONValue', 'TJSONValue');
    MethodInfo.AddParam('JSONString', 'string');
    MethodInfo.AddParam('AOwner', 'U');
    MethodInfo.AddVar('Ctx', 'TRttiContext');
    MethodInfo.AddVar('LType', 'TRttiType');
    MethodInfo.AddVar('LMethod', 'TRttiMethod');
    MethodInfo.AddVar('LArgs', 'array of TValue');
    MethodInfo.Lines.Add('TJSONMapper<T>.SetDefaultLibrary(LibraryName);');
    MethodInfo.Lines.Add('if Assigned(JSONValue) then');
    MethodInfo.Lines.Add('  Result := TJSONMapper<T>.Default.FromObject(JSONValue)');
    MethodInfo.Lines.Add('else');
    MethodInfo.Lines.Add('  Result := TJSONMapper<T>.Default.FromObject(JSONString);');
    MethodInfo.Lines.Add('Ctx := TRttiContext.Create;');
    MethodInfo.Lines.Add('try');
    MethodInfo.Lines.Add('  LType := Ctx.GetType(Result.ClassInfo);');
    MethodInfo.Lines.Add('  for LMethod in LType.GetMethods do');
    MethodInfo.Lines.Add('  if Assigned(LMethod) and LMethod.HasName(''' +
      PopulateOwnerConst + ''') then');
    MethodInfo.Lines.Add('  begin');
    MethodInfo.Lines.Add('    if Length(LMethod.GetParameters) > 0 then');
    MethodInfo.Lines.Add('    begin');
    MethodInfo.Lines.Add('      SetLength(LArgs, 1);');
    MethodInfo.Lines.Add('      LArgs[0] := TValue.From<U>(AOwner);');
    MethodInfo.Lines.Add('    end;');
    MethodInfo.Lines.Add('    LMethod.Invoke(Result, LArgs);');
    MethodInfo.Lines.Add('    exit;');
    MethodInfo.Lines.Add('  end;');
    MethodInfo.Lines.Add('finally');
    MethodInfo.Lines.Add('  Ctx.Free;');
    MethodInfo.Lines.Add('end;');

    MethodInfo := ClassInfo.AddPrivateMethods(mtFunction,
      JSONConverterLibraryNameConst, 'string');
    MethodInfo.FClassMethod := True;
    MethodInfo.Lines.Add('Result := QualifiedClassName;');
    MethodInfo.Lines.Add('if Result.EndsWith(''.'' + ClassName) then');
    MethodInfo.Lines.Add
      ('  delete(Result, Length(QualifiedClassName) - Length(ClassName) - 1, MaxInt);');

    MethodInfo := ClassInfo.AddPublicMethods(mtFunction,
      JSONConverterToJSONConst, 'string');
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('AObject', 'T');
    MethodInfo.Lines.Add('TJSONMapper<T>.SetDefaultLibrary(LibraryName);');
    MethodInfo.Lines.Add('Result := TJSONMapper<T>.Default.ToString(AObject);');

    MethodInfo := ClassInfo.AddPublicMethods(mtFunction,
      JSONConverterToObjectConst1, 'T', True);
    MethodInfo.FName2 := JSONConverterToObjectConst2;
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('JSON', 'TJSONValue');
    MethodInfo.Lines.Add('Result := ' + JSONConverterInternalToObjectConst3 +
      '(JSON, '''', nil);');

    MethodInfo := ClassInfo.AddPublicMethods(mtFunction,
      JSONConverterToObjectConst1, 'T', True);
    MethodInfo.FName2 := JSONConverterToObjectConst2;
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('JSON', 'string');
    MethodInfo.Lines.Add('Result := ' + JSONConverterInternalToObjectConst3 +
      '(nil, JSON, nil);');

    MethodInfo := ClassInfo.AddPublicMethods(mtFunction,
      JSONConverterToObjectConst3, 'T', True);
    MethodInfo.FName2 := JSONConverterToObjectConst4;
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('JSON', 'TJSONValue');
    MethodInfo.AddParam('AOwner', 'U');
    MethodInfo.Lines.Add('Result := ' + JSONConverterInternalToObjectConst2 +
      '(JSON, '''', AOwner);');

    MethodInfo := ClassInfo.AddPublicMethods(mtFunction,
      JSONConverterToObjectConst3, 'T', True);
    MethodInfo.FName2 := JSONConverterToObjectConst4;
    MethodInfo.FClassMethod := True;
    MethodInfo.AddParam('JSON', 'string');
    MethodInfo.AddParam('AOwner', 'U');
    MethodInfo.Lines.Add('Result := ' + JSONConverterInternalToObjectConst2 +
      '(nil, JSON, AOwner);');
  end;

  procedure InitSerializerClass;
  var
    SubMethod: TMethodInfo;
    i: Integer;
    ConverterInfo: TConverterInfo;
  begin
    ClassInfo := TClassInfo.Create(UnitInfo.MainClass.FName + 'JSONSerializer',
      'TJsonSerializer');
    UnitInfo.FSerializerClass := ClassInfo;
    MethodInfo := ClassInfo.AddPublicMethods(mtConstructor, CreateConst);
    MethodInfo.AddVar('Ctx', 'TRttiContext');
    MethodInfo.AddVar('AResolver', 'TJsonDynamicContractResolver');
    MethodInfo.AddVar('AAttributes', 'TJsonDynamicAttributes');
    MethodInfo.AddVar('AFieldType', 'TRttiType');

    SubMethod := MethodInfo.AddSubMethod(mtProcedure, 'Init');
    SubMethod.AddVar('LField', 'TRttiField');
    SubMethod.Lines.Add
      ('AResolver := TJsonDynamicContractResolver.Create(TJsonMemberSerialization.Public);');
    SubMethod.Lines.Add('ContractResolver := AResolver;');
    SubMethod.Lines.Add
      ('LField := GetRttiField(TypeInfo(TJsonDynamicContractResolver), ''FDynamicAttributes'');');
    SubMethod.Lines.Add('if Assigned(LField) then');
    SubMethod.Lines.Add
      ('  AAttributes := LField.GetValue(AResolver).AsType<TJsonDynamicAttributes>');
    SubMethod.Lines.Add('else');
    SubMethod.Lines.Add('  AAttributes := nil;');
    SubMethod.Lines.Add('AFieldType := Ctx.GetType(TRttiType);');

    SubMethod := MethodInfo.AddSubMethod(mtProcedure, IgnorePropertiesConst);
    SubMethod.AddParam('AClass', 'TClass');
    SubMethod.AddParam('ATypeInf', 'PTypeInfo');
    SubMethod.AddVar('LType', 'TRttiType');
    SubMethod.AddVar('LProp', 'TRttiProperty');
    SubMethod.AddVar('I, J', 'Integer');
    SubMethod.AddVar('PropList', 'TArray<string>');
    SubMethod.Lines.Add('LType := Ctx.GetType(ATypeInf);');
    SubMethod.Lines.Add('for LProp in LType.GetProperties do');
    SubMethod.Lines.Add(BeginConst);
    SubMethod.Lines.Add('  if LProp.HasAttribute<JsonInAttribute> then');
    SubMethod.Lines.Add('    continue;');
    SubMethod.Lines.Add
      ('  if (not(LProp.Visibility in [mvPublic, mvPublished])) or');
    SubMethod.Lines.Add('    (LProp.Parent.Name <> AClass.ClassName) then');
    SubMethod.Lines.Add('  ' + BeginConst);
    SubMethod.Lines.Add('    SetLength(PropList, Length(PropList) + 1);');
    SubMethod.Lines.Add('    PropList[Length(PropList) - 1] := LProp.Name;');
    SubMethod.Lines.Add('  ' + EndConst);
    SubMethod.Lines.Add(EndConst);
    SubMethod.Lines.Add('for I := Length(PropList) - 1 downto 0 do');
    SubMethod.Lines.Add('  for LProp in LType.GetProperties do');
    SubMethod.Lines.Add
      ('    if (CompareText(PropList[I], LProp.Name) = 0) and');
    SubMethod.Lines.Add('      (LProp.Parent.Name = AClass.ClassName) then');
    SubMethod.Lines.Add('    ' + BeginConst);
    SubMethod.Lines.Add
      ('      AResolver.SetPropertyName(ATypeInf, PropList[I], LProp.Name);');
    SubMethod.Lines.Add('      for J := I to Length(PropList) - 2 do');
    SubMethod.Lines.Add('        PropList[J] := PropList[J + 1];');
    SubMethod.Lines.Add('      SetLength(PropList, Length(PropList) - 1);');
    SubMethod.Lines.Add
      ('      AAttributes.AddAttribute(LProp, JsonIgnoreAttribute.Create);');
    SubMethod.Lines.Add('      break;');
    SubMethod.Lines.Add('    ' + EndConst);
    SubMethod.Lines.Add('AResolver.SetPropertiesIgnored(ATypeInf, PropList);');

    // MethodInfo.Lines.Add('
    MethodInfo.Lines.Add('inherited Create;');
    MethodInfo.Lines.Add('Ctx := TRttiContext.Create;');
    MethodInfo.Lines.Add('try');
    MethodInfo.Lines.Add('  Init;');
    for i := 0 to UnitInfo.FClasses.Count - 1 do
    begin
      ClassInfo := UnitInfo.FClasses.Objects[i];
      MethodInfo.Lines.Add('  ' + IgnorePropertiesConst + '(' +
        ClassInfo.FParentClass + ', TypeInfo(' + ClassInfo.FName + '));');
    end;
    for i := 0 to UnitInfo.FPropertyConverters.Count - 1 do
    begin
      ConverterInfo := UnitInfo.FPropertyConverters.Objects[i];
      MethodInfo.Lines.Add('  AResolver.SetPropertyConverter(TypeInfo(' +
        ConverterInfo.FParentType + '), ''' + ConverterInfo.FPropName + ''',');
      MethodInfo.Lines.Add('    ' + ConverterInfo.FConverterName + ');');
    end;
    MethodInfo.Lines.Add('finally');
    MethodInfo.Lines.Add('  Ctx.Free;');
    MethodInfo.Lines.Add(EndConst);
  end;

begin
  i := -1;
  InInterface := False;
  InType := False;
  InClass := False;
  InPublic := False;
  ClassInfo := nil;
  repeat
    inc(i);
    line := Trim(sl[i]);
    if not InInterface then
      InInterface := (line = InterfaceConst)
    else
    begin
      if not InType then
        InType := (line = TypeConst)
      else
      begin
        if not InClass then
        begin
          line := line.Replace(' ', '');
          p := pos(ClassConst, line);
          if (p > 0) and (not line.EndsWith(';')) then
            InitClass;
        end
        else
        begin
          if line = EndConst then
          begin
            InClass := False;
            ClassInfo := nil;
          end
          else if not InPublic then
            InPublic := (line = PublicConst) or (line = PublishedConst)
          else if (line = PrivateConst) or (line = ProtectedConst) then
            InPublic := False
          else if line.StartsWith(PropertyConst) then
            InitProperty;
        end;
      end;
    end;
  until (i >= sl.Count) or (line = ImplementationConst);
  if UnitInfo.BuildOwners and UnitInfo.TopClassOwner then
    AddOwner(UnitInfo.MainClass, UnitInfo.TopClassOwnerName);
  InitConverterClass;
  InitSerializerClass;
  UnitInfo.FSerializerRegisterName := copy(UnitInfo.FSerializerClass.FName, 2,
    MaxInt) + 'Registered';
  UnitInfo.AddGlobalVar(UnitInfo.FSerializerRegisterName, 'Boolean', 'False');
end;

procedure BuildDescendantUnit(sl: TStringList; UnitInfo: TUnitInfo);
var
  i, lastIdx: Integer;
  line: string;
  VarInfo: TVarInfo;
  PropInfo: TPropertyInfo;
  ConverterInfo: TConverterInfo;

  procedure AddVars(AList: TStringList<TVarInfo>; IndentLevel: Integer = 0);
  begin
    if AList.Count > 0 then
    begin
      AList.Sort;
      sl.Add(StringOfChar(' ', IndentLevel) + VarConst);
      for var i := 0 to AList.Count - 1 do
      begin
        VarInfo := AList.Objects[i];
        line := StringOfChar(' ', IndentLevel + 2) + VarInfo.FVarName + ': ' +
          VarInfo.FVarType;
        if VarInfo.FVarDefault <> '' then
          line := line + ' = ' + VarInfo.FVarDefault;
        line := line + ';';
        sl.Add(line);
      end;
    end;
  end;

  procedure AddMethodInfo(MethodInfo: TMethodInfo; Indent: Boolean;
    ClassName: string = ''; InClass: Boolean = False);
  var
    k, num: Integer;
    Spaces1, Spaces2: string;
  begin
    if not Assigned(MethodInfo) then
      exit;
    num := MethodInfo.FIndentLevel;
    if Indent then
      inc(num, 4);
    Spaces1 := StringOfChar(' ', num);
    Spaces2 := StringOfChar(' ', num + 2);
    if ClassName <> '' then
      InClass := True;
    line := Spaces1;
    if MethodInfo.FClassMethod then
      line := line + 'class ';
    case MethodInfo.FMethodType of
      mtConstructor:
        line := line + 'constructor';
      mtDestructor:
        line := line + 'destructor';
      mtProcedure:
        line := line + 'procedure';
      mtFunction:
        line := line + 'function';
    else
      exit;
    end;
    line := line + ' ';
    if ClassName <> '' then
      line := line + ClassName + '.';
    if InClass and (MethodInfo.FName2 <> '') then
      line := line + MethodInfo.FName2
    else
      line := line + MethodInfo.FName;
    if MethodInfo.FParameters.Count > 0 then
    begin
      line := line + '(';
      for k := 0 to MethodInfo.FParameters.Count - 1 do
      begin
        if k > 0 then
          line := line + '; ';
        VarInfo := MethodInfo.FParameters.Objects[k];
        line := line + VarInfo.FVarName + ': ' + VarInfo.FVarType;
      end;
      line := line + ')';
    end;
    if MethodInfo.FMethodType = mtFunction then
      line := line + ': ' + MethodInfo.FReturnType;
    line := line + ';';
    if (not InClass) and MethodInfo.FOverload then
      line := line + ' overload;';
    if (not InClass) and (MethodInfo.FMethodType = mtDestructor) then
      line := line + ' override;';
    sl.Add(line);
    if InClass then
    begin
      AddVars(MethodInfo.FVars, num);
      if MethodInfo.FSubMethods.Count > 0 then
      begin
        sl.Add('');
        for k := 0 to MethodInfo.FSubMethods.Count - 1 do
          AddMethodInfo(MethodInfo.FSubMethods.Objects[k], False, '', True);
      end;
      sl.Add(Spaces1 + BeginConst);
      for k := 0 to MethodInfo.Lines.Count - 1 do
        sl.Add(Spaces2 + MethodInfo.Lines[k]);
      sl.Add(Spaces1 + EndConst);
      sl.Add('');
    end;
  end;

  procedure AddMethods(AList: TStringList<TMethodInfo>; Indent: Boolean = True;
    ClassName: string = '');
  var
    j: Integer;
  begin
    AList.Sort;
    for j := 0 to AList.Count - 1 do
      AddMethodInfo(AList.Objects[j], Indent, ClassName);
  end;

  procedure AddClass(ClassInfo: TClassInfo; InClassDeclaration: Boolean = True);
  var
    j: Integer;
    TempList: TStringList<TMethodInfo>;
  begin
    if InClassDeclaration then
    begin
      lastIdx := sl.Add('  ' + ClassInfo.FName + ' = class(' +
        ClassInfo.FParentClass + ')');
      if (ClassInfo.FPrivateFields.Count > 0) or
        (ClassInfo.FPrivateMethods.Count > 0) then
      begin
        sl.Add('  ' + PrivateConst);
        ClassInfo.FPrivateFields.Sort;
        for j := 0 to ClassInfo.FPrivateFields.Count - 1 do
        begin
          VarInfo := ClassInfo.FPrivateFields.Objects[j];
          sl.Add('    ' + VarInfo.FVarName + ': ' + VarInfo.FVarType + ';');
        end;
        AddMethods(ClassInfo.FPrivateMethods);
      end;
      if ClassInfo.FProtectedMethods.Count > 0 then
      begin
        sl.Add('  ' + ProtectedConst);
        AddMethods(ClassInfo.FProtectedMethods);
      end;
      if (ClassInfo.FPublicMethods.Count > 0) or
        (ClassInfo.FPublicProperties.Count > 0) then
      begin
        sl.Add('  ' + PublicConst);
        AddMethods(ClassInfo.FPublicMethods);
        for j := 0 to ClassInfo.FPublicProperties.Count - 1 do
        begin
          ClassInfo.FPublicProperties.Sort;
          PropInfo := ClassInfo.FPublicProperties.Objects[j];
          line := '    ' + PropertyConst + PropInfo.FName + ': ';
          if PropInfo.FNewField = '' then
            line := line + PropInfo.FPropType + ReadConst + PropInfo.FField
          else
            line := line + PropInfo.FNewPropType + ReadConst +
              PropInfo.FNewField;
          line := line + ';';
          sl.Add(line);
        end;
      end;
      if lastIdx = sl.Count - 1 then
        sl[lastIdx] := sl[lastIdx] + ';'
      else
        sl.Add('  ' + EndConst);
      sl.Add('');
    end
    else
    begin
      TempList := TStringList<TMethodInfo>.Create(False);
      try
        TempList.Clear;
        TempList.AddStrings(ClassInfo.FPrivateMethods);
        TempList.AddStrings(ClassInfo.FProtectedMethods);
        TempList.AddStrings(ClassInfo.FPublicMethods);
        if TempList.Count > 0 then
        begin
          sl.Add('{ ' + ClassInfo.FName + ' }');
          sl.Add('');
          TempList.Sort;
          AddMethods(TempList, False, ClassInfo.FName);
        end;
      finally
        FreeAndNil(TempList);
      end;
    end;
  end;

begin
  sl.Clear;
  sl.Add('');
  sl.Add(RTTIDirectiveConst);
  sl.Add('');
  sl.Add(InterfaceConst);
  sl.Add('');
  sl.Add(UsesConst);
  sl.Add(Uses1Default + UnitInfo.ProjectUnitName + ';');
  sl.Add('');
  sl.Add(TypeConst);
  if UnitInfo.Forwards.Count > 0 then
  begin
    for i := 0 to UnitInfo.Forwards.Count - 1 do
      sl.Add('  ' + UnitInfo.Forwards[i] + ' = class;');
    sl.Add('');
  end;
  for i := 0 to UnitInfo.Classes.Count - 1 do
    AddClass(UnitInfo.Classes.Objects[i]);
  AddClass(UnitInfo.FConverterClass);
  sl.Add(ImplementationConst);
  sl.Add('');
  sl.Add(UsesConst);
  sl.Add(Uses2Default);
  sl.Add(Uses3Default);
  sl.Add('');
  AddVars(UnitInfo.FGlobalVars);
  sl.Add('');
  AddMethodInfo(UnitInfo.FFreeOldProc, False, '', True);
  for i := 0 to UnitInfo.Classes.Count - 1 do
    AddClass(UnitInfo.Classes.Objects[i], False);
  AddClass(UnitInfo.FConverterClass, False);
  sl.Add(TypeConst);
  if UnitInfo.FPropertyConverters.Count > 0 then
  begin
    for i := 0 to UnitInfo.FPropertyConverters.Count - 1 do
    begin
      ConverterInfo := UnitInfo.FPropertyConverters.Objects[i];
      sl.Add('  ' + ConverterInfo.FConverterName + JSONTypedListConverterConst +
        ConverterInfo.FSubClassName + '>);');
    end;
    sl.Add('');
  end;
  AddClass(UnitInfo.FSerializerClass);
  AddClass(UnitInfo.FSerializerClass, False);
  sl.Add(InitializationConst);
  sl.Add('');
  sl.Add(UnitInfo.FLibraryName + ' := ' + UnitInfo.FConverterClass.FName + '.' +
    JSONConverterLibraryNameConst + ';');
  sl.Add(UnitInfo.FSerializerRegisterName + ' := TJSONMappers.RegisterLibrary');
  sl.Add('  (' + UnitInfo.FLibraryName +
    ', TJSONMappers.TOptionality.DontCare,');
  sl.Add('  TJSONMappers.TOptionality.DontCare, TJSONMappers.TOptionality.DontCare,');
  sl.Add('  procedure(const AName: string; const ASerItems: TJSONMappers.TItem;');
  sl.Add('    var AIntro: string; var AReqUnit: string)');
  sl.Add('  const');
  sl.Add('    CSerItems: array [TJSONMappers.TItem] of string = (''Public'', ''Fields'');');
  sl.Add('  ' + BeginConst);
  sl.Add('    AIntro := ''[JsonSerialize(TJsonMemberSerialization.'' + CSerItems');
  sl.Add('      [ASerItems] + '')]'';');
  sl.Add('    AReqUnit := ' + UnitInfo.FLibraryName + ';');
  sl.Add('  end,');
  sl.Add('  procedure(const AName, AOrigName: string; const AElem: TJSONMappers.TItem;');
  sl.Add('    var AIntro: string; var AReqUnit: string)');
  sl.Add('  ' + BeginConst);
  sl.Add('    if AnsiSameText(AName, AOrigName) and (AElem <> TJSONMappers.TItem.Field) then');
  sl.Add('      Exit;');
  sl.Add('    AIntro := ''[JsonName('''''' + AOrigName + '''''')]'';');
  sl.Add('    AReqUnit := ' + UnitInfo.FLibraryName + ';');
  sl.Add('  end,');
  sl.Add('  procedure(const AItemType: string; var AIntro, AReqUnit,');
  sl.Add('    AInstantiation: string)');
  sl.Add('  ' + BeginConst);
  sl.Add('  ' + VarConst);
  sl.Add('    LConv := StringReplace(AItemType, ''<'', '''', [TReplaceFlag.rfReplaceAll]);');
  sl.Add('    LConv := ''TJsonListConverter'' + StringReplace(LConv, ''>'', '''',');
  sl.Add('      [TReplaceFlag.rfReplaceAll]);');
  sl.Add('    AIntro := ''[JsonConverter('' + LConv + '')]'';');
  sl.Add('    AReqUnit := ' + UnitInfo.FLibraryName + ';');
  sl.Add('    AInstantiation := LConv + '' = class(TJsonListConverter<'' + AItemType + ''>)'';');
  sl.Add('  end,');
  sl.Add('  function(ApValue: Pointer; ApTypeInfo: PTypeInfo): TJSONObject');
  sl.Add('  ' + VarConst);
  sl.Add('    LSer: ' + UnitInfo.FSerializerClass.FName + ';');
  sl.Add('    LWrt: TJsonObjectWriter;');
  sl.Add('    V: TValue;');
  sl.Add('  ' + BeginConst);
  sl.Add('    LSer := ' + UnitInfo.FSerializerClass.FName + '.Create;');
  sl.Add('    LWrt := TJsonObjectWriter.Create(False);');
  sl.Add('    try');
  sl.Add('      TValue.Make(ApValue, ApTypeInfo, V);');
  sl.Add('      LSer.Serialize(LWrt, V);');
  sl.Add('      Result := LWrt.JSON as TJSONObject;');
  sl.Add('    finally');
  sl.Add('      LWrt.Free;');
  sl.Add('      LSer.Free;');
  sl.Add('    ' + EndConst);
  sl.Add('  end,');
  sl.Add('  function(AValue: TJSONObject; ApTypeInfo: PTypeInfo): TValue');
  sl.Add('  ' + VarConst);
  sl.Add('    LSer: ' + UnitInfo.FSerializerClass.FName + ';');
  sl.Add('    LRdr: TJsonObjectReader;');
  sl.Add('  ' + BeginConst);
  sl.Add('    LSer := ' + UnitInfo.FSerializerClass.FName + '.Create;');
  sl.Add('    LRdr := TJsonObjectReader.Create(AValue);');
  sl.Add('    try');
  sl.Add('      Result := LSer.Deserialize(LRdr, ApTypeInfo);');
  sl.Add('    finally');
  sl.Add('      LRdr.Free;');
  sl.Add('      LSer.Free;');
  sl.Add('    ' + EndConst);
  sl.Add('  end);');
  sl.Add('');
  sl.Add(FinalizationConst);
  sl.Add('');
  sl.Add('if ' + UnitInfo.FSerializerRegisterName + ' then');
  sl.Add('  TJSONMappers.UnRegisterLibrary(' + UnitInfo.FLibraryName + ');');
  sl.Add('');
  sl.Add('end.');
end;

end.

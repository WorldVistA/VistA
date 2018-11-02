{*********************************************************}
{*                  OVCFILER.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcfiler;
  {-property read and write routines}

interface

uses
  Classes, Graphics, Controls, Forms, SysUtils, TypInfo,
  OvcBase, OvcMisc;

type
  {Descendants of the TOvcAbstractStore class are responsible for}
  {interacting with specific types of stores (registry, ini, db, ...) }
  {and must implement all of the abstract methods.}

  TOvcAbstractStore = class(TOvcComponent)
  protected
    RefCount : Integer;
    procedure DoOpen; virtual; abstract;
    procedure DoClose; virtual; abstract;
  public
    procedure Open; {open the store}
    procedure Close; {close the store}
    function ReadString(const Section, Item, DefaultValue : string) : string;
      virtual; abstract;
    procedure WriteString(const Section, Item, Value : string);
      virtual; abstract;
    procedure EraseSection(const Section : string);
      virtual;

    function ReadBoolean(const Section, Item : string; DefaultValue : Boolean) : Boolean;
    function ReadInteger(const Section, Item : string; DefaultValue : Integer) : Integer;
    procedure WriteBoolean(const Section, Item : string; Value : Boolean);
    procedure WriteInteger(const Section, Item : string; Value : Integer);
  end;

type
  {.Z+}
  PExPropInfo = ^ TExPropInfo;
  TExPropInfo = packed record
    PI      : TPropInfo;
    AObject : TObject;
  end;
  {.Z-}

type
  {.Z+}
  TOvcPropertyList = class(TObject)
  protected {private}
    FList  : TList;

    function Get(Index : Integer) : PExPropInfo;
    function GetCount : Integer;

  public
    constructor Create(AObject : TObject; Filter : TTypeKinds; const Prefix : string);
    destructor Destroy;
      override;

    function Contains(P : PExPropInfo) : Boolean;
    function Find(const AName : string) : PExPropInfo;
    procedure Delete(Index : Integer);
    procedure Intersect(List : TOvcPropertyList);

    property Count : Integer
      read GetCount;
    property Items[Index : Integer] : PExPropInfo
      read Get; default;
  end;
  {.Z-}

type
  {.Z+}
  TOvcDataFiler = class(TObject)
  protected {private}
    {property variables}
    FPrefix    : string;
    FSection   : string;
    FStorage : TOvcAbstractStore;

    {internal methods}
{$IFDEF VERSION5}
    function CreatePropertyList(AForm : TWinControl; StoredList : TStrings) : TStrings;
{$ELSE}
    function CreatePropertyList(AForm : TCustomForm; StoredList : TStrings) : TStrings;
{$ENDIF}
    procedure FreeInfoLists(Info : TStrings);

    {routines to get and set property values}
    function GetCharProperty(PropInfo : PExPropInfo): string;
    function GetClassProperty(PropInfo : PExPropInfo): string;
    function GetEnumProperty(PropInfo : PExPropInfo): string;
    function GetFloatProperty(PropInfo : PExPropInfo): string;
    function GetIntegerProperty(PropInfo : PExPropInfo): string;
    function GetLStringProperty(PropInfo : PExPropInfo): string;
    function GetSetProperty(PropInfo : PExPropInfo): string;
    function GetStringProperty(PropInfo : PExPropInfo): string;
    function GetStringsProperty(PropInfo : PExPropInfo): string;
    function GetVariantProperty(PropInfo : PExPropInfo): string;
    function GetWCharProperty(PropInfo : PExPropInfo): string;
    procedure SetCharProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetClassProperty({const S : string; }PropInfo : PExPropInfo);
    procedure SetEnumProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetFloatProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetIntegerProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetLStringProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetSetProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetStringProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetStringsProperty({const S : string; }PropInfo : PExPropInfo);
    procedure SetVariantProperty(const S : string; PropInfo : PExPropInfo);
    procedure SetWCharProperty(const S : string; PropInfo : PExPropInfo);

  protected
    function CreateDataFiler : TOvcDataFiler;
      virtual;
    procedure EraseSection(const ASection : string);
      virtual;
    function GetItemName(const APropName : string) : string;
      virtual;
    function ReadString(const ASection, Item, Default : string) : string;
      virtual;
    procedure WriteString(const ASection, Item, Value : string);
      virtual;

  public
{$IFDEF VERSION5}
    procedure LoadObjectsProps(AForm : TWinControl; StoredList : TStrings);
{$ELSE}
    procedure LoadObjectsProps(AForm : TCustomForm; StoredList : TStrings);
{$ENDIF}
    procedure LoadProperty(PropInfo : PExPropInfo);
    procedure LoadAllProperties(AObject : TObject);

{$IFDEF VERSION5}
    procedure StoreObjectsProps(AForm : TWinControl; StoredList : TStrings);
{$ELSE}
    procedure StoreObjectsProps(AForm : TCustomForm; StoredList : TStrings);
{$ENDIF}
    procedure StoreProperty(PropInfo : PExPropInfo);
    procedure StoreAllProperties(AObject : TObject);

    {properties}
    property Prefix : string
      read FPrefix write FPrefix;
    property Section : string
      read FSection write FSection;
    property Storage : TOvcAbstractStore
      read FStorage write FStorage;
  end;
  {.Z-}


{.Z+}
{$IFDEF VERSION5}
procedure UpdateStoredList(AForm : TWinControl; AStoredList : TStrings; FromForm : Boolean);
{$ELSE}
procedure UpdateStoredList(AForm : TCustomForm; AStoredList : TStrings; FromForm : Boolean);
{$ENDIF}
function CreateStoredItem(const CompName, PropName : string) : string;
function ParseStoredItem(const Item : string; var CompName, PropName : string) : Boolean;
function GetPropType(PropInfo : PExPropInfo) : PTypeInfo;
{.Z-}


implementation


{*** utility routines ***}

function CreateStoredItem(const CompName, PropName : string) : string;
begin
  Result := '';
  if (CompName <> '') and (PropName <> '') then
    Result := CompName + '.' + PropName;
end;

function GetPropType(PropInfo : PExPropInfo) : PTypeInfo;
begin
  Result := PropInfo^.PI.PropType^;
end;

function ParseStoredItem(const Item : string; var CompName, PropName : string) : Boolean;
var
  I : Integer;
begin
  Result := False;
  if Length(Item) = 0 then
    Exit;
  I := Pos('.', Item);
  if I > 0 then begin
    CompName := Trim(Copy(Item, 1, I - 1));
    PropName := Trim(Copy(Item, I + 1, Length(Item)-I));
    Result := (Length(CompName) > 0) and (Length(PropName) > 0);
  end;
end;

function ReplaceComponentName(const Item, CompName : string) : string;
var
  ACompName, APropName : string;
begin
  Result := '';
  if ParseStoredItem(Item, ACompName, APropName) then
    Result := CreateStoredItem(CompName, APropName);
end;

{$IFDEF VERSION5}
procedure UpdateStoredList(AForm : TWinControl; AStoredList : TStrings; FromForm : Boolean);
{$ELSE}
procedure UpdateStoredList(AForm : TCustomForm; AStoredList : TStrings; FromForm : Boolean);
{$ENDIF}
var
  I         : Integer;
  Component : TComponent;
  CompName  : string;
  PropName  : string;
begin
  if (AStoredList = nil) or (FromForm and (AForm = nil)) then
    Exit;
  for I := AStoredList.Count - 1 downto 0 do begin
    if ParseStoredItem(AStoredList[I], CompName, PropName) then begin
      if FromForm then begin
        Component := AForm.FindComponent(CompName);
        if Component = nil then
          AStoredList.Delete(I)
        else
          AStoredList.Objects[I] := Component;
      end else begin
        Component := TComponent(AStoredList.Objects[I]);
        if Component <> nil then
          AStoredList[I] := ReplaceComponentName(AStoredList[I], Component.Name)
        else
          AStoredList.Delete(I);
      end;
    end else
      AStoredList.Delete(I);
  end;
end;


{*** TOvcPropertyList ***}

function TOvcPropertyList.Contains(P : PExPropInfo) : Boolean;
var
  I : Integer;
begin
  Result := False;
  for I := 0 to Count - 1 do
    with Items[I]^.PI do
      if (PropType = P^.PI.PropType) and (CompareText(Name, P^.PI.Name) = 0) then begin
        Result := True;
        Break;
      end;
end;

constructor TOvcPropertyList.Create(AObject : TObject; Filter : TTypeKinds; const Prefix : string);
var
  I, J  : Integer;
  K     : Integer;

  LCount: Integer;
  Size  : Integer;
  C     : TOvcCollection;
  Props : TOvcPropertyList;
  PList : PPropList;
  P     : PExPropInfo;
begin
  inherited Create;
  FList := TList.Create;

  if Assigned(AObject) and (AObject.ClassInfo <> nil) then begin

    LCount := GetPropList(AObject.ClassInfo, Filter, nil);
    Size := LCount * SizeOf(Pointer);
    if Size > 0 then begin
      GetMem(PList, Size);
      try
        GetPropList(AObject.ClassInfo, Filter, PList);
        {transfer prop info to internal list and reallocate individual
        {property records so that the name can be modified}

        for I := 0 to LCount-1 do begin
          P := New(PExPropInfo);
          P^.PI := PList^[I]^;
          {prepend prefix, if any}
          if Prefix > '' then
            P^.PI.Name := Prefix + '.' + P^.PI.Name;
          P^.AObject := AObject;
          FList.Add(P);
        end;
      finally
        FreeMem(PList, Size);
      end;

      {now, see if any of these properties represent collections}
      {if so, get the properties for the collection items too}
      for K := LCount-1 downto 0 do begin
        if (Items[K]^.PI.PropType^.Kind = tkClass) and
           (CompareText(Items[K]^.PI.PropType^.Name, TOvcCollection.ClassName) = 0) then begin
          {get the collection instance}
          C := TOvcCollection(GetOrdProp(AObject, PPropInfo(Items[K])));
          for I := 0 to C.Count-1 do begin
            Props := TOvcPropertyList.Create(C.Item[I], tkProperties, Items[K]^.PI.Name
              + '[' + IntToStr(I) + ']');
            try
              {prefix names and add to parent list}
              for J := 0 to Props.Count-1 do begin
                P := New(PExPropInfo);
                P^ := Props.Items[J]^;
                FList.Add(P);
              end;
            finally
              Props.Free;
            end;
          end;
          {now, remove the collection from the list since it}
          {doesn't have any properties itself}
          Dispose(PExPropInfo(FList[K]));
          FList.Delete(K);
        end;
      end;
    end;
  end;
end;

procedure TOvcPropertyList.Delete(Index : Integer);
begin
  FList.Delete(Index);
end;

destructor TOvcPropertyList.Destroy;
var
  I : Integer;
begin
  for I := 0 to Count-1 do
    Dispose(PExPropInfo(FList[I]));
  FList.Free;

  inherited Destroy;
end;

function TOvcPropertyList.Find(const AName : string) : PExPropInfo;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    with PExPropInfo(FList[I])^.PI do
      if (CompareText(Name, AName) = 0) then begin
        Result := FList[I];
        Break;
      end;
end;

function TOvcPropertyList.Get(Index : Integer) : PExPropInfo;
begin
  Result := PExPropInfo(FList[Index]);
end;

function TOvcPropertyList.GetCount : Integer;
begin
  Result := Flist.Count;
end;

procedure TOvcPropertyList.Intersect(List : TOvcPropertyList);
var
  I : Integer;
begin
  for I := Count - 1 downto 0 do
    if not List.Contains(FList[I]) then
      Delete(I);
end;


{*** TOvcAbstractStore ***}

procedure TOvcAbstractStore.EraseSection(const Section : string);
begin
  {do nothing}
end;

procedure TOvcAbstractStore.Open;
begin
  inc(RefCount);
  if RefCount = 1 then
    DoOpen;
end;

procedure TOvcAbstractStore.Close;
begin
  if RefCount > 0 then
    dec(RefCount);
  if RefCount = 0 then
    DoClose;
end;

function TOvcAbstractStore.ReadBoolean(const Section, Item : string; DefaultValue : Boolean) : Boolean;
var
  S : string;
begin
  if DefaultValue then
    S := ReadString(Section, Item, '1')
  else
    S := ReadString(Section, Item, '0');
  Result := S[1] = '1';
end;

function TOvcAbstractStore.ReadInteger(const Section, Item : string; DefaultValue : Integer) : Integer;
var
  S : string;
begin
  S := ReadString(Section, Item, IntTostr(DefaultValue));
  Result := StrToIntDef(S, DefaultValue);
end;

procedure TOvcAbstractStore.WriteBoolean(const Section, Item : string; Value : Boolean);
begin
  if Value then
    WriteString(Section, Item, '1')
  else
    WriteString(Section, Item, '0')
end;

procedure TOvcAbstractStore.WriteInteger(const Section, Item : string; Value : Integer);
begin
  WriteString(Section, Item, IntToStr(Value));
end;


{*** TOvcDataFiler ***}

function TOvcDataFiler.CreateDataFiler : TOvcDataFiler;
begin
  Result := TOvcDataFiler.Create;
end;

{$IFDEF VERSION5}
function TOvcDataFiler.CreatePropertyList(AForm : TWinControl; StoredList : TStrings) : TStrings;
{$ELSE}
function TOvcDataFiler.CreatePropertyList(AForm : TCustomForm; StoredList : TStrings) : TStrings;
{$ENDIF}

var
  I     : Integer;
  Obj   : TComponent;
  Props : TOvcPropertyList;
begin
  UpdateStoredList(AForm, StoredList, False);
  Result := TStringList.Create;
  try
    TStringList(Result).Sorted := True;
    for I := 0 to StoredList.Count - 1 do begin
      Obj := TComponent(StoredList.Objects[I]);
      if Result.IndexOf(Obj.Name) < 0 then begin
        Props := TOvcPropertyList.Create(Obj, tkProperties, '');
        try
          Result.AddObject(Obj.Name, Props);
        except
          Props.Free;
          raise;
        end;
      end;
    end;
  except
    Result.Free;
    Result := nil;
  end;
end;

procedure TOvcDataFiler.EraseSection(const ASection : string);
begin
  if Assigned(FStorage) then
    FStorage.EraseSection(ASection);
end;

procedure TOvcDataFiler.FreeInfoLists(Info : TStrings);var
  I : Integer;
begin
  for I := Info.Count - 1 downto 0 do
    Info.Objects[I].Free;
  Info.Free;
end;

function TOvcDataFiler.GetCharProperty(PropInfo : PExPropInfo) : string;
begin
  Result := Char(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
end;

function TOvcDataFiler.GetClassProperty(PropInfo : PExPropInfo) : string;
var
  I     : Integer;
  Obj   : TObject;
  Saver : TOvcDataFiler;
  PropS : TOvcPropertyList;
begin
  Result := '';
  Obj := TObject(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));

  if (Obj <> nil) and (Obj is TComponent) then exit;

  if (Obj <> nil) and (Obj is TStrings) then
    GetStringsProperty(PropInfo);
  Saver := CreateDataFiler;
  try
    with Saver do begin
      Prefix := Self.Prefix + PropInfo^.PI.Name;
      Section := Self.Section;
      FStorage := Self.FStorage;
      Props := TOvcPropertyList.Create(Obj, tkProperties, '');
      try
        for I := 0 to Props.Count - 1 do
          StoreProperty(Props.Items[I]);
      finally
        Props.Free;
      end;
    end;
  finally
    Saver.Free;
  end;
end;

function TOvcDataFiler.GetEnumProperty(PropInfo : PExPropInfo) : string;
begin
  Result := GetEnumName(GetPropType(PropInfo), GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
end;

function TOvcDataFiler.GetFloatProperty(PropInfo : PExPropInfo) : string;
const
  Precisions : array[TFloatType] of Integer = (7, 15, 18, 18, 19);
begin
  Result := FloatToStrF(GetFloatProp(PropInfo^.AObject, PPropInfo(PropInfo)), ffGeneral,
    Precisions[GetTypeData(GetPropType(PropInfo))^.FloatType], 0);
end;

function TOvcDataFiler.GetIntegerProperty(PropInfo : PExPropInfo) : string;
begin
  Result := IntToStr(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
end;

function TOvcDataFiler.GetItemName(const APropName : string) : string;
begin
  Result := Prefix + APropName;
end;

function TOvcDataFiler.GetLStringProperty(PropInfo : PExPropInfo) : string;
begin
  Result := GetStrProp(PropInfo^.AObject, PPropInfo(PropInfo));
end;

type
  TCardinalSet = set of 0..SizeOf(Cardinal) * 8 - 1;

function TOvcDataFiler.GetSetProperty(PropInfo : PExPropInfo) : string;
var
  TypeInfo : PTypeInfo;
  W        : Cardinal;
  I        : Integer;
begin
  Result := '[';
  W := GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo));
  TypeInfo := GetTypeData(GetPropType(PropInfo))^.CompType^;
  for I := 0 to pred(sizeof(Cardinal) * 8) do
    if I in TCardinalSet(W) then begin
      if Length(Result) <> 1 then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  Result := Result + ']';
end;

function TOvcDataFiler.GetStringProperty(PropInfo : PExPropInfo) : string;
begin
  Result := GetStrProp(PropInfo^.AObject, PPropInfo(PropInfo));
end;

function TOvcDataFiler.GetStringsProperty(PropInfo : PExPropInfo) : string;
var
  List     : TObject;
  I        : Integer;
  SectName : string;
begin
  Result := '';
  List := TObject(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
  SectName := Format('%s.%s', [Section, GetItemName(PropInfo^.PI.Name)]);
  EraseSection(SectName);
  if (List is TStrings) and (TStrings(List).Count > 0) then begin
    WriteString(SectName, 'Count', IntToStr(TStrings(List).Count));
    for I := 0 to TStrings(List).Count - 1 do
      WriteString(SectName, Format('Item%d', [I]), TStrings(List)[I]);
  end;
end;

function TOvcDataFiler.GetVariantProperty(PropInfo : PExPropInfo) : string;
begin
  Result := GetVariantProp(PropInfo^.AObject, PPropInfo(PropInfo));
end;

function TOvcDataFiler.GetWCharProperty(PropInfo : PExPropInfo) : string;
begin
  Result := Char(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
end;

procedure TOvcDataFiler.LoadAllProperties(AObject : TObject);
var
  I     : Integer;
  Props : TOvcPropertyList;
begin
  Props := TOvcPropertyList.Create(AObject, tkProperties, '');
  try
    for I := 0 to Props.Count - 1 do
      LoadProperty(Props[I]);
  finally
    Props.Free;
  end;
end;

{$IFDEF VERSION5}
procedure TOvcDataFiler.LoadObjectsProps(AForm : TWinControl; StoredList : TStrings);
{$ELSE}
procedure TOvcDataFiler.LoadObjectsProps(AForm : TCustomForm; StoredList : TStrings);
{$ENDIF}
var
  Info     : TStrings;
  I, Idx   : Integer;
  Props    : TOvcPropertyList;
  CompName : string;
  PropName : string;
begin
  {create complete property lists for all components referenced in the stored}
  {properties list (StoredList). "Objects" holds TOvcPropertyList instances.}
  Info := CreatePropertyList(AForm, StoredList);
  if Info <> nil then
    try
      {cycle through all items, storing properties along the way}
      for I := 0 to StoredList.Count - 1 do begin
        if ParseStoredItem(StoredList[I], CompName, PropName) then begin
          Prefix := TComponent(StoredList.Objects[I]).Name;
          Idx := Info.IndexOf(Prefix);
          if Idx >= 0 then begin
            Prefix := Prefix + '.';
            Props := TOvcPropertyList(Info.Objects[Idx]);
            if Props <> nil then
              LoadProperty(Props.Find(PropName))
          end;
        end;
      end;
    finally
      FreeInfoLists(Info);
    end;
end;

procedure TOvcDataFiler.LoadProperty(PropInfo : PExPropInfo);
var
  S, Def : string;
begin
  try
    if PropInfo <> nil then begin
      case PropInfo^.PI.PropType^.Kind of
        tkInteger     : Def := GetIntegerProperty(PropInfo);
        tkChar        : Def := GetCharProperty(PropInfo);
        tkEnumeration : Def := GetEnumProperty(PropInfo);
        tkFloat       : Def := GetFloatProperty(PropInfo);
        tkWChar       : Def := GetWCharProperty(PropInfo);
        tkLString     : Def := GetLStringProperty(PropInfo);
        tkVariant     : Def := GetVariantProperty(PropInfo);
        tkString      : Def := GetStringProperty(PropInfo);
        tkSet         : Def := GetSetProperty(PropInfo);
        tkClasS       : Def := '';
      else
        Exit;
      end;

      if (Def <> '') or (PropInfo^.PI.PropType^.Kind = tkString)
        or (PropInfo^.PI.PropType^.Kind in [tkLString, tkWChar]) then
        S := Trim(ReadString(Section, GetItemName(PropInfo^.PI.Name), Def))
      else
        S := '';

      case PropInfo^.PI.PropType^.Kind of
        tkInteger     : SetIntegerProperty(S, PropInfo);
        tkChar        : SetCharProperty(S, PropInfo);
        tkEnumeration : SetEnumProperty(S, PropInfo);
        tkFloat       : SetFloatProperty(S, PropInfo);
        tkWChar       : SetWCharProperty(S, PropInfo);
        tkLString     : SetLStringProperty(S, PropInfo);
        tkVariant     : SetVariantProperty(S, PropInfo);
        tkString      : SetStringProperty(S, PropInfo);
        tkSet         : SetSetProperty(S, PropInfo);
        tkClasS       : SetClassProperty({S, }PropInfo);
      end;
    end;
  except
    {ignore errors}
  end;
end;

function TOvcDataFiler.ReadString(const ASection, Item, Default : string) : string;
begin
  if Assigned(FStorage) then
    Result := FStorage.ReadString(ASection, Item, Default)
  else
    Result := '';
end;

procedure TOvcDataFiler.SetCharProperty(const S : string; PropInfo : PExPropInfo);
var
  C : Char;
begin
  if S > '' then
    C := S[1]
  else
    C := #0;
  SetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo), Integer(C));
end;

procedure TOvcDataFiler.SetClassProperty({const S : string; }PropInfo : PExPropInfo);
var
  Loader : TOvcDataFiler;
  PropS  : TOvcPropertyList;
  I      : Integer;
  Obj    : TObject;
begin
  Obj := TObject(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
  if (Obj <> nil) and (Obj is TStrings) then
    SetStringsProperty({S, }PropInfo);
  Loader := CreateDataFiler;
  try
    with Loader do begin
      Prefix := Self.Prefix + PropInfo^.PI.Name;
      Section := Self.Section;
      FStorage := Self.FStorage;
      Props := TOvcPropertyList.Create(Obj, tkProperties, '');
      try
        for I := 0 to Props.Count - 1 do
          LoadProperty(Props.Items[I]);
      finally
        Props.Free;
      end;
    end;
  finally
    Loader.Free;
  end;
end;

procedure TOvcDataFiler.SetEnumProperty(const S : string; PropInfo : PExPropInfo);
var
  I        : Integer;
  EnumType : PTypeInfo;
begin
  EnumType := GetPropType(PropInfo);
  with GetTypeData(EnumType)^ do
    for I := MinValue to MaxValue do
      if CompareText(GetEnumName(EnumType, I), S) = 0 then begin
        SetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo), I);
        Exit;
      end;
end;

procedure TOvcDataFiler.SetFloatProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetFloatProp(PropInfo^.AObject, PPropInfo(PropInfo), StrToFloat(S));
end;

procedure TOvcDataFiler.SetIntegerProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo), StrToIntDef(S, 0));
end;

procedure TOvcDataFiler.SetLStringProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetStrProp(PropInfo^.AObject, PPropInfo(PropInfo), S);
end;

procedure TOvcDataFiler.SetSetProperty(const S : string; PropInfo : PExPropInfo);
const
  Delims = [' ', ',', '[', ']'];
var
  TypeInfo : PTypeInfo;
  W        : Cardinal;
  I, N     : Integer;
  Count    : Integer;
  EnumName : string;
begin
  W := 0;
  TypeInfo := GetTypeData(GetPropType(PropInfo))^.CompType^;
  Count := WordCount(S, Delims);
  for N := 1 to Count do begin
    EnumName := ExtractWord(N, S, Delims);
    try
      I := GetEnumValue(TypeInfo, EnumName);
      if I >= 0 then
        Include(TCardinalSet(W), I);
    except
      {ignore errors}
    end;
  end;
  SetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo), W);
end;

procedure TOvcDataFiler.SetStringProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetStrProp(PropInfo^.AObject, PPropInfo(PropInfo), S);
end;

procedure TOvcDataFiler.SetStringsProperty({const S : string; }PropInfo : PExPropInfo);
var
  List     : TObject;
  TemP     : TStrings;
  I, Cnt   : Integer;
  SectName : string;
begin
  List := TObject(GetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo)));
  if (List is TStrings) then begin
    SectName := Format('%s.%s', [Section, GetItemName(PropInfo^.PI.Name)]);
    Cnt := StrToIntDef(Trim(ReadString(SectName, 'Count', '0')), 0);
    if Cnt > 0 then begin
      Temp := TStringList.Create;
      try
        for I := 0 to Cnt - 1 do
          Temp.Add(ReadString(SectName, Format('Item%d', [I]), ''));
        TStrings(List).Assign(Temp);
      finally
        Temp.Free;
      end;
    end;
  end;
end;

procedure TOvcDataFiler.SetVariantProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetVariantProp(PropInfo^.AObject, PPropInfo(PropInfo), S);
end;

procedure TOvcDataFiler.SetWCharProperty(const S : string; PropInfo : PExPropInfo);
begin
  SetOrdProp(PropInfo^.AObject, PPropInfo(PropInfo), LongInt(S[1]));
end;

procedure TOvcDataFiler.StoreAllProperties(AObject : TObject);
var
  I     : Integer;
  Props : TOvcPropertyList;
begin
  Props := TOvcPropertyList.Create(AObject, tkProperties, '');
  try
    for I := 0 to Props.Count - 1 do
      StoreProperty(Props[I]);
  finally
    Props.Free;
  end;
end;

{$IFDEF VERSION5}
procedure TOvcDataFiler.StoreObjectsProps(AForm : TWinControl; StoredList : TStrings);
{$ELSE}
procedure TOvcDataFiler.StoreObjectsProps(AForm : TCustomForm; StoredList : TStrings);
{$ENDIF}

var
  Info     : TStrings;
  I, Idx   : Integer;
  Props    : TOvcPropertyList;
  CompName : string;
  PropName : string;
begin
  {create complete property lists for all components referenced in the stored}
  {properties list (StoredList). "Objects" holds TOvcPropertyList instances.}

  Info := CreatePropertyList(AForm, StoredList);
  if Info <> nil then
    try
      {cycle through all items, storing properties along the way}
      for I := 0 to StoredList.Count - 1 do begin
        if ParseStoredItem(StoredList[I], CompName, PropName) then begin
          Prefix := TComponent(StoredList.Objects[I]).Name;
          Idx := Info.IndexOf(Prefix);
          if Idx >= 0 then begin
            Prefix := Prefix + '.';
            Props := TOvcPropertyList(Info.Objects[Idx]);
            if Props <> nil then
              StoreProperty(Props.Find(PropName))
          end;
        end;
      end;
    finally
      FreeInfoLists(Info);
    end;
end;

procedure TOvcDataFiler.StoreProperty(PropInfo : PExPropInfo);
var
  S : string;
begin
  if PropInfo <> nil then begin
    case PropInfo^.PI.PropType^.Kind of
      tkInteger      : S := GetIntegerProperty(PropInfo);
      tkChar         : S := GetCharProperty(PropInfo);
      tkEnumeration  : S := GetEnumProperty(PropInfo);
      tkFloat        : S := GetFloatProperty(PropInfo);
      tkLString      : S := GetLStringProperty(PropInfo);
      tkWChar        : S := GetWCharProperty(PropInfo);
      tkVariant      : S := GetVariantProperty(PropInfo);
      tkString       : S := GetStringProperty(PropInfo);
      tkSet          : S := GetSetProperty(PropInfo);
      tkClasS        : S := GetClassProperty(PropInfo);
    else
      Exit;
    end;

    if (S <> '') or (PropInfo^.PI.PropType^.Kind in [tkString, tkLString,
      tkWChar]) then
      WriteString(Section, GetItemName(PropInfo^.PI.Name), Trim(S));
  end;
end;

procedure TOvcDataFiler.WriteString(const ASection, Item, Value : string);
begin
  if Assigned(FStorage) then
    FStorage.WriteString(ASection, Item, Value);
end;

end.

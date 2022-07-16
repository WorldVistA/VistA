unit VA508AccessibilityPE;

interface

uses
  Windows, SysUtils, DesignIntf, DesignEditors, DesignConst, TypInfo, Controls, StdCtrls,
  Classes, Forms, VA508AccessibilityManager, Dialogs, ColnEdit, RTLConsts, VA508AccessibilityManagerEditor;

type
  TVA508AccessibilityManager4PE = class(TVA508AccessibilityManager);

  TVA508AccessibilityPropertyMapper = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetProperties(Proc: TGetPropProc); override;
  end;

  TVA508NestedPropertyType = (ptText, ptLabel, ptProperty, ptDefault); //, ptEvent);

  TVA508NestedPropertyEditor = class(TNestedProperty)
  strict private
    FName: String;
    FType: TVA508NestedPropertyType;
    FManager: TVA508AccessibilityManager4PE;
  protected
    property Manager: TVA508AccessibilityManager4PE read FManager;
  public
    constructor Create(AParent: TVA508AccessibilityPropertyMapper;
      AName: String; PType: TVA508NestedPropertyType);
    function AllEqual: Boolean; override;
    procedure Edit; override;
    function GetEditLimit: Integer; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetName: string; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  {
  TVA508AccessibilityEventPropertyEditor = class(TVA508NestedPropertyEditor, IMethodProperty)
  protected
    function GetMethodValue(Index: Integer): TMethod;
  public
    function AllNamed: Boolean; virtual;
    procedure Edit; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const AValue: string); override;
    function GetFormMethodName: string; virtual;
    function GetTrimmedEventName: string;
  end;
   }
   
  TVA508CollectionPropertyEditor = class(TCollectionProperty)
  public
    function GetColOptions: TColOptions; override;
    function GetAttributes: TPropertyAttributes;  override;
    procedure GetValues(AProc: TGetStrProc); override;
    function GetValue: String; override;
    procedure SetValue(const AValue: String); override;
    procedure Edit;  override;
  //  function GetEditorClass: tForm; override;
  end;

{ TODO -oChris Bell : Impliment the actual code that will look to this new property }
  TVA508AccessibilityManagerEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TVA508AccessibilityLabelPropertyEditor = class(TComponentProperty)
  private
    FManager: TVA508AccessibilityManager4PE;
    function GetManager: TVA508AccessibilityManager4PE;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetProperties(Proc: TGetPropProc); override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TVA508AccessibilityPropertyPropertyEditor = class(TStringProperty)
  private
    FManager: TVA508AccessibilityManager4PE;
    function GetManager: TVA508AccessibilityManager4PE;
    function GetRootComponent(index: integer): TWinControl;
  public
    function AllEqual: Boolean; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetEditLimit: Integer; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  TVA508AccessibilityComponentPropertyEditor = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

const
  WinControlPropertyToMap = 'Hint'; 

procedure Register;

implementation

function GetAccessibilityManager(Editor: TPropertyEditor; Index: integer): TVA508AccessibilityManager4PE;
var
  Control, Root: TComponent;
  i: integer;

begin
  Result := nil;
  if assigned(Editor.GetComponent(Index)) and (Editor.GetComponent(Index) is TComponent) then
  begin
    Control := TComponent(Editor.GetComponent(Index));
    Root := Control;
    while (assigned(Root) and (not (Root is TCustomForm))) do
      Root := Root.Owner;
    if assigned(Root) and (Root is TCustomForm) then
    begin
      for i := 0 to Root.ComponentCount-1 do
      begin
        if Root.Components[i] is TVA508AccessibilityManager then
        begin
          Result := TVA508AccessibilityManager4PE(Root.Components[i]);
          exit;
        end;
      end;
    end;
  end;
end;

function AllComponentsHaveSameManager(Editor: TPropertyEditor): boolean;
var
  i: integer;
  manager: TVA508AccessibilityManager4PE;
begin
  manager := GetAccessibilityManager(Editor, 0);
  Result := assigned(manager);
  if (not result) or (Editor.PropCount < 2) then exit;
  for i := 1 to Editor.PropCount-1 do
  begin
    if (GetAccessibilityManager(Editor, i) <> manager) then
    begin
      Result := FALSE;
      exit;
    end;
  end;
end;

procedure GetStringPropertyNames(Manager: TVA508AccessibilityManager4PE;
  Component: TWinControl; List: TStringList; Add: boolean);
var
  i: Integer;
  current: TStringList;

begin
  current := TStringList.Create;
  try
    Manager.GetProperties(Component, current);
    if Add then
      list.Assign(current)
    else
    begin
      for I := List.Count - 1 downto 0 do
      begin
        if current.IndexOf(list[i]) < 0 then
          List.Delete(i);
      end;
    end;
  finally
    current.Free;
  end;
end;

function QVal(txt: string): string;
begin
  Result := '="' + txt + '"';
end;

function StripQVal(text: string): string;
var
  i: integer;
begin
  i := pos('=', text);
  if (i > 0) then
    Result := copy(text,1,i-1)
  else
    Result := text;
end;

{ TVA508AccessibilityPropertyMapper }

const
  DelphiPaletteName = 'VA 508';


function TVA508AccessibilityPropertyMapper.GetAttributes: TPropertyAttributes;
begin
  if AllComponentsHaveSameManager(Self) then
    Result := [paMultiSelect, paRevertable, paSubProperties]
  else
    Result := inherited GetAttributes;
end;

procedure TVA508AccessibilityPropertyMapper.GetProperties(
  Proc: TGetPropProc);
begin
  if not AllComponentsHaveSameManager(Self) then exit;
  Proc(TVA508NestedPropertyEditor.Create(Self, AccessibilityLabelPropertyName, ptLabel));
  Proc(TVA508NestedPropertyEditor.Create(Self, AccessibilityPropertyPropertyName, ptProperty));
  Proc(TVA508NestedPropertyEditor.Create(Self, AccessibilityTextPropertyName, ptText));
  Proc(TVA508NestedPropertyEditor.Create(Self, AccessibilityUseDefaultPropertyName, ptDefault));
//  Proc(TVA508AccessibilityEventPropertyEditor.Create(Self, AccessibilityEventPropertyName, ptEvent));
end;

{ TVA508NestedStringProperty }

function TVA508NestedPropertyEditor.AllEqual: Boolean;
var
  i: Integer;
  txt, prop: string;
  lbl: TLabel;
//  V, T: TMethod;
  default: boolean;

begin
  if PropCount > 1 then
  begin
    Result := False;
    if not (GetComponent(0) is TWinControl) then exit;
    case FType of
      ptText:
        begin
          txt := FManager.AccessText[TWinControl(GetComponent(0))];
          for i := 1 to PropCount - 1 do
            if txt <> FManager.AccessText[TWinControl(GetComponent(i))] then exit;
        end;

      ptLabel:
        begin
          lbl := FManager.AccessLabel[TWinControl(GetComponent(0))];
          for i := 1 to PropCount - 1 do
            if lbl <> FManager.AccessLabel[TWinControl(GetComponent(i))] then exit;
        end;

      ptProperty:
      begin
        prop := FManager.AccessProperty[TWinControl(GetComponent(0))];
        for i := 1 to PropCount - 1 do
          if prop <> FManager.AccessProperty[TWinControl(GetComponent(i))] then exit;
      end;

      ptDefault:
      begin
        default := FManager.UseDefault[TWinControl(GetComponent(0))];
        for i := 1 to PropCount - 1 do
          if default <> FManager.UseDefault[TWinControl(GetComponent(i))] then exit;
      end;


{      ptEvent:
      begin
        V := TMethod(FManager.OnComponentAccessRequest[TWinControl(GetComponent(0))]);
        for i := 1 to PropCount - 1 do
        begin
          T := TMethod(FManager.OnComponentAccessRequest[TWinControl(GetComponent(i))]);
          if (T.Code <> V.Code) or (T.Data <> V.Data) then Exit;
        end;
      end;}
    end;
  end;
  Result := True;
end;

constructor TVA508NestedPropertyEditor.Create(AParent: TVA508AccessibilityPropertyMapper;
             AName: String; PType: TVA508NestedPropertyType);
begin
  inherited Create(AParent);
  FManager := GetAccessibilityManager(AParent, 0);
  FName := AName;
  FType := PType;
end;

procedure TVA508NestedPropertyEditor.Edit;
var
  lbl: TLabel;

begin
  if (FType = ptLabel) and
    (Designer.GetShiftState * [ssCtrl, ssLeft] = [ssCtrl, ssLeft]) then
  begin
    lbl := FManager.AccessLabel[TWinControl(GetComponent(0))];
    if assigned(lbl) then
      Designer.SelectComponent(lbl)
    else
      inherited Edit;
  end
  else
    inherited Edit;
end;

function TVA508NestedPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  case FType of
    ptText:
      Result := [paMultiSelect, paRevertable, paAutoUpdate];
    ptLabel, ptProperty:
      Result := [paMultiSelect, paRevertable, paValueList, paSortList, paAutoUpdate];
    ptDefault:
      Result := [paMultiSelect, paValueList, paSortList, paRevertable];

//    ptEvent:
//      Result := [paMultiSelect, paValueList, paSortList, paRevertable];
    else
      Result := [];
  end;

end;

function TVA508NestedPropertyEditor.GetEditLimit: Integer;
begin
  case FType of
    ptText: Result := 32767;
    ptDefault : Result := 63;
//    ptEvent: Result := MaxIdentLength;
    else // ptLabel, ptProperty:
      Result := 127;
  end;
end;

function TVA508NestedPropertyEditor.GetName: string;
begin
  Result := FName;
end;

function TVA508NestedPropertyEditor.GetValue: string;
var
  lbl: TLabel;
  Default: boolean;
begin
  Result := '';
  if not (GetComponent(0) is TWinControl) then exit;
  case FType of
    ptLabel:
      begin
        lbl := FManager.AccessLabel[TWinControl(GetComponent(0))];
        if assigned(lbl) then
          Result := FManager.GetComponentName(lbl) + QVal(lbl.Caption);
      end;
    ptText:
      Result := FManager.AccessText[TWinControl(GetComponent(0))];
    ptProperty:
      begin
        Result := FManager.AccessProperty[TWinControl(GetComponent(0))];
        if Result <> '' then
          Result := Result + QVal(GetPropValue(GetComponent(0), Result));
      end;
    ptDefault:
      begin
        Default := FManager.UseDefault[TWinControl(GetComponent(0))];
        Result := GetEnumName(TypeInfo(Boolean), Ord(Default));
      end;
  end;
end;

procedure TVA508NestedPropertyEditor.GetValues(Proc: TGetStrProc);
var
  list: TStringList;
  i: integer;
  name: string;

begin
  list := TStringList.Create;
  try
    case FType of
      ptLabel:
        begin
          FManager.GetLabelStrings(list);
          for i := 0 to list.count-1 do
            Proc(list[i]);
        end;

      ptProperty:
      begin
        GetStringPropertyNames(FManager, TWinControl(GetComponent(0)), list, TRUE);
        if PropCount > 1 then
        begin
          for i := 1 to PropCount-1 do
          begin
            if GetComponent(i) is TWinControl then
              GetStringPropertyNames(FManager, TWinControl(GetComponent(i)), list, FALSE);
          end;
        end;
        list.Sort;
        for i := 0 to list.count-1 do
        begin
          name := list[i];
          if PropCount = 1 then
            name := name + QVal(GetPropValue(GetComponent(0), name));
          Proc(name);
        end;
      end;

      ptDefault:
      begin
        Proc(GetEnumName(TypeInfo(Boolean), Ord(False)));
        Proc(GetEnumName(TypeInfo(Boolean), Ord(True)));
      end;

    end;
  finally
    list.free;
  end;
end;

procedure TVA508NestedPropertyEditor.SetValue(const Value: string);
var
  i, BVal: Integer;
  lbl: TLabel;
  cmp: TComponent;
  Name: String;

begin
  BVal := Ord(FALSE);
  lbl := nil;
  case FType of

    ptLabel:
      begin
        Name := StripQVal(Value);
        cmp := Designer.GetComponent(Name);
        if (cmp is TLabel) then
          lbl := TLabel(cmp);
      end;

    ptProperty: Name := StripQVal(Value);

    ptDefault:
      begin
        BVal := GetEnumValue(TypeInfo(Boolean), Value);
        with GetTypeData(TypeInfo(Boolean))^ do
          if (BVal < MinValue) or (BVal > MaxValue) then
            raise EPropertyError.CreateRes(@SInvalidPropertyValue);
      end;

  end;
  for i := 0 to PropCount - 1 do
  begin
    if GetComponent(i) is TWinControl then
    begin
      case FType of
        ptText:     FManager.AccessText[TWinControl(GetComponent(i))] := Value;
        ptLabel:    FManager.AccessLabel[TWinControl(GetComponent(i))] := lbl;
        ptProperty: FManager.AccessProperty[TWinControl(GetComponent(i))] := Name;
        ptDefault:  FManager.UseDefault[TWinControl(GetComponent(i))] := Boolean(BVal);
      end;
    end;
  end;
  Modified;
end;

(*
{ TVA508AccessibilityEventPropertyEditor }

function TVA508AccessibilityEventPropertyEditor.AllNamed: Boolean;
var
  I: Integer;
begin
  Result := True;
  for I := 0 to PropCount - 1 do
    if GetComponent(I).GetNamePath = '' then
    begin
      Result := False;
      Break;
    end;
end;

procedure TVA508AccessibilityEventPropertyEditor.Edit;
var
  FormMethodName: string;
  CurDesigner: IDesigner;
begin
  CurDesigner := Designer; { Local property so if designer is nil'ed out, no AV will happen }
  if not AllNamed then
    raise EPropertyError.CreateRes(@SCannotCreateName);
  FormMethodName := GetValue;
  if (FormMethodName = '') or
    CurDesigner.MethodFromAncestor(GetMethodValue(0)) then
  begin
    if FormMethodName = '' then
      FormMethodName := GetFormMethodName;
    if FormMethodName = '' then
      raise EPropertyError.CreateRes(@SCannotCreateName);
    SetValue(FormMethodName);
  end;
  CurDesigner.ShowMethod(FormMethodName);
end;

function TVA508AccessibilityEventPropertyEditor.GetFormMethodName: string;
var
  I: Integer;
begin
  if GetComponent(0) = Designer.GetRoot then
  begin
    Result := Designer.GetRootClassName;
    if (Result <> '') and (Result[1] = 'T') then
      Delete(Result, 1, 1);
  end
  else
  begin
    Result := Designer.GetObjectName(GetComponent(0));
    for I := Length(Result) downto 1 do
      if Result[I] in ['.', '[', ']', '-', '>'] then
        Delete(Result, I, 1);
  end;
  if Result = '' then
    raise EPropertyError.CreateRes(@SCannotCreateName);
  Result := Result + GetTrimmedEventName;
end;

function TVA508AccessibilityEventPropertyEditor.GetMethodValue(Index: Integer): TMethod;
begin
  if not (GetComponent(Index) is TWinControl) then
  begin
    Result.Code := nil;
    Result.Data := nil;
  end
  else
    Result := TMethod(Manager.OnComponentAccessRequest[TWinControl(GetComponent(Index))]);
end;

{ TVA508AccessibilityEventPropertyEditor }

function TVA508AccessibilityEventPropertyEditor.GetTrimmedEventName: string;
begin
  Result := GetName;
  if (Length(Result) >= 2) and
    (Result[1] in ['O', 'o']) and (Result[2] in ['N', 'n']) then
    Delete(Result,1,2);
end;

function TVA508AccessibilityEventPropertyEditor.GetValue: string;
begin
  Result := Designer.GetMethodName(GetMethodValue(0));
end;

procedure TVA508AccessibilityEventPropertyEditor.GetValues(Proc: TGetStrProc);
begin
  Designer.GetMethods(GetTypeData(TypeInfo(TVA508ComponentScreenReaderEvent)), Proc);
end;

procedure TVA508AccessibilityEventPropertyEditor.SetValue(const AValue: string);

var
  CurDesigner: IDesigner;

  procedure CheckChainCall(const MethodName: string; Method: TMethod);
  var
    Persistent: TPersistent;
    Component: TComponent;
    InstanceMethod: string;
    Instance: TComponent;
  begin
    Persistent := GetComponent(0);
    if Persistent is TComponent then
    begin
      Component := TComponent(Persistent);
      if (Component.Name <> '') and (Method.Data <> CurDesigner.GetRoot) and
        (TObject(Method.Data) is TComponent) then
      begin
        Instance := TComponent(Method.Data);
        InstanceMethod := Instance.MethodName(Method.Code);
        if InstanceMethod <> '' then
          CurDesigner.ChainCall(MethodName, Instance.Name, InstanceMethod,
            GetTypeData(TypeInfo(TVA508ComponentScreenReaderEvent)));
      end;
    end;
  end;

var
  NewMethod: Boolean;
  CurValue: string;
  OldMethod: TMethod;
  i: integer;
  event: TVA508ComponentScreenReaderEvent;
begin
  CurDesigner := Designer;
  if not AllNamed then
    raise EPropertyError.CreateRes(@SCannotCreateName);
  CurValue:= GetValue;
  if (CurValue <> '') and (AValue <> '') and (SameText(CurValue, AValue) or
    not CurDesigner.MethodExists(AValue)) and
    not CurDesigner.MethodFromAncestor(GetMethodValue(0)) then
    CurDesigner.RenameMethod(CurValue, AValue)
  else
  begin
    NewMethod := (AValue <> '') and not CurDesigner.MethodExists(AValue);
    OldMethod := GetMethodValue(0);
    event := TVA508ComponentScreenReaderEvent(CurDesigner.CreateMethod(AValue, GetTypeData(TypeInfo(TVA508ComponentScreenReaderEvent))));
    for i := 0 to PropCount - 1 do
    begin
      if (GetComponent(i) is TWinControl) then
        Manager.OnComponentAccessRequest[TWinControl(GetComponent(i))] := event;
    end;
    if NewMethod then
    begin
      { Designer may have been nil'ed out this point when the code editor
        recieved focus. This fixes an AV by using a local variable which
        keeps a reference to the designer }
      if (PropCount = 1) and (OldMethod.Data <> nil) and (OldMethod.Code <> nil) then
        CheckChainCall(AValue, OldMethod);
      CurDesigner.ShowMethod(AValue);
    end;
  end;
  Modified;
end;

*)

{ TVA508CollectionProperty }

function TVA508CollectionPropertyEditor.GetColOptions: TColOptions;
begin
  Result := [coMove];
end;

procedure TVA508CollectionPropertyEditor.Edit;
var
 tmpCollection: TVA508AccessibilityCollection;
begin
 if TComponent(GetComponent(0)) is TVA508AccessibilityManager then
 begin
 va508CollectionEditor := Tva508CollectionEditor.Create(Application);
  try
 // tmpCollection := TVA508AccessibilityCollection(GetOrdValue);
  tmpCollection := TVA508AccessibilityCollection(GetObjectProp(GetComponent(0), GetPropInfo));

  va508CollectionEditor.FillOutList(tmpCollection, TVA508AccessibilityManager(GetComponent(0)));

  va508CollectionEditor.ShowModal;

  finally
    va508CollectionEditor.Free;
  end;
 end else
  inherited;

end;
{
function TVA508CollectionPropertyEditor.GetEditorClass: tForm;
begin
  Result := Tva508CollectionEditor;
end;      }

function TVA508CollectionPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

procedure TVA508CollectionPropertyEditor.GetValues(AProc: TGetStrProc);
// var
//   CollB: TVA508AccessibilityCollection;
 //  I: Integer;
 begin
 inherited;
 {
   if self.GetComponent(0) is TVA508AccessibilityItem then
   begin

    CollB := (self.GetComponent(0) as TVA508AccessibilityItem).Collection;
     for I := 0 to CollB.Count-1 do
     begin
       AProc(CollB.Items[I].AccessLabel.Caption);
 {   property AccessProperty: string read FProperty write SetProperty;
    property AccessText: string read FText write SetText;
    property Component: TWinControl read FComponent write SetComponent;
    property UseDefault: boolean read FDefault write SetDefault;
    property DisplayName: string read GetDisplayName;
     end;
   end; }
 end;

function TVA508CollectionPropertyEditor.GetValue: String;
 begin
   Result := GetStrValue;
 end;

procedure TVA508CollectionPropertyEditor.SetValue(const AValue: String);
 begin
   SetStrValue(AValue);
 end;


{ TVA508AccessibilityManagerEditor }

procedure TVA508AccessibilityManagerEditor.Edit;
var
 tmpCollection: TVA508AccessibilityCollection;
begin

 va508CollectionEditor := Tva508CollectionEditor.Create(Application);
 try
 // tmpCollection := TVA508AccessibilityCollection(GetOrdValue);

  tmpCollection := TVA508AccessibilityManager(Component).AccessData;

  va508CollectionEditor.FillOutList(tmpCollection, TVA508AccessibilityManager(Component));

  va508CollectionEditor.ShowModal;

  finally
    va508CollectionEditor.Free;
  end;

end;

procedure TVA508AccessibilityManagerEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit
  else inherited ExecuteVerb(Index);
end;

function TVA508AccessibilityManagerEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit Accessible Controls..'
  else
    Result := inherited GetVerb(Index);
end;

function TVA508AccessibilityManagerEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ TVA508AccessibilityLabelPropertyEditor }

function TVA508AccessibilityLabelPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable, paValueList, paSortList, paAutoUpdate];
end;

function TVA508AccessibilityLabelPropertyEditor.GetManager: TVA508AccessibilityManager4PE;
begin
  if not assigned(FManager) then
    FManager := TVA508AccessibilityManager4PE(TVA508AccessibilityItem(GetComponent(0)).Manager);
  Result := FManager;
end;

procedure TVA508AccessibilityLabelPropertyEditor.GetProperties(
  Proc: TGetPropProc);
begin
  exit;
end;

function TVA508AccessibilityLabelPropertyEditor.GetValue: string;
var
  lbl: TLabel;
begin
  lbl := TVA508AccessibilityItem(GetComponent(0)).AccessLabel;
  if assigned(lbl) then
    Result := GetManager.GetComponentName(lbl) + QVal(lbl.Caption);
end;

procedure TVA508AccessibilityLabelPropertyEditor.GetValues(Proc: TGetStrProc);
var
  i: integer;
  list: TStringList;
begin
  list := TStringList.Create;
  try
    GetManager.GetLabelStrings(list);
    for i := 0 to list.count-1 do
      Proc(list[i]);
  finally
    list.Free;
  end;
end;

procedure TVA508AccessibilityLabelPropertyEditor.SetValue(const Value: string);
begin
  inherited SetValue(StripQVal(Value));
end;

{ TVA508AccessibilityPropertyPropertyEditor }

function TVA508AccessibilityPropertyPropertyEditor.AllEqual: Boolean;
var
  i: integer;
  prop: string;
begin
  if PropCount > 1 then
  begin
    Result := FALSE;
    prop := GetManager.AccessProperty[TWinControl(GetComponent(0))];
    for i := 1 to PropCount - 1 do
      if prop <> FManager.AccessProperty[TWinControl(GetComponent(i))] then exit;
  end;
  Result := TRUE;
end;

function TVA508AccessibilityPropertyPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable, paValueList, paSortList, paAutoUpdate];
end;

function TVA508AccessibilityPropertyPropertyEditor.GetEditLimit: Integer;
begin
  Result := 127;
end;

function TVA508AccessibilityPropertyPropertyEditor.GetManager: TVA508AccessibilityManager4PE;
begin
  if not assigned(FManager) then
    FManager := TVA508AccessibilityManager4PE(TVA508AccessibilityItem(GetComponent(0)).Manager);
  Result := FManager;
end;

function TVA508AccessibilityPropertyPropertyEditor.GetRootComponent(
  index: integer): TWinControl;
begin
  Result := TVA508AccessibilityItem(GetComponent(index)).Component;
end;

function TVA508AccessibilityPropertyPropertyEditor.GetValue: string;
begin
  Result := inherited GetValue;
  if Result <> '' then
    Result := Result + QVal(GetPropValue(GetRootComponent(0), Result));
end;

procedure TVA508AccessibilityPropertyPropertyEditor.GetValues(
  Proc: TGetStrProc);
var
  list: TStringList;
  i: integer;
  name: string;

begin
  list := TStringList.Create;
  try
    GetStringPropertyNames(GetManager, GetRootComponent(0), list, TRUE);
    if PropCount > 1 then
    begin
      for i := 1 to PropCount-1 do
        GetStringPropertyNames(FManager, GetRootComponent(i), list, FALSE);
    end;
    list.Sort;
    for i := 0 to list.count-1 do
    begin
      name := list[i];
      if PropCount = 1 then
        name := name + QVal(GetPropValue(GetRootComponent(0), name));
      Proc(name);
    end;
  finally
    list.free;
  end;
end;

procedure TVA508AccessibilityPropertyPropertyEditor.SetValue(
  const Value: string);
begin
  inherited SetValue(StripQVal(Value));
end;

{ TVA508AccessibilityClassPropertyEditor }

function TVA508AccessibilityComponentPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDisplayReadOnly];
end;

procedure Register;
begin
  RegisterComponents(DelphiPaletteName, [TVA508AccessibilityManager, TVA508ComponentAccessibility,
                                         TVA508StaticText]);

  RegisterPropertyEditor(TypeInfo(TVA508AccessibilityCollection),
      TVA508AccessibilityManager, VA508DataPropertyName, TVA508CollectionPropertyEditor);
  RegisterPropertyEditor(TypeInfo(String), TWinControl, WinControlPropertyToMap,
    TVA508AccessibilityPropertyMapper);
  RegisterPropertyEditor(TypeInfo(TLabel), TVA508AccessibilityItem, AccessibilityLabelPropertyName,
    TVA508AccessibilityLabelPropertyEditor);
  RegisterPropertyEditor(TypeInfo(String), TVA508AccessibilityItem, AccessibilityPropertyPropertyName,
    TVA508AccessibilityPropertyPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TComponent), TVA508AccessibilityItem, AccessDataComponentText,
    TVA508AccessibilityComponentPropertyEditor);
  RegisterComponentEditor(TVA508AccessibilityManager, TVA508AccessibilityManagerEditor);
end;

end.


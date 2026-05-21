unit ORCtrlsDsgn;                                    // Oct 26, 1997 @ 10:00am

// To Do:  eliminate topindex itemtip on mousedown (seen when choosing clinic pts)

interface  // --------------------------------------------------------------------------------

uses Classes, DesignIntf, DesignEditors, TypInfo, ORCtrls, SysUtils, ORDtTm;

{ TPropertyEditor
  Edits a property of a component, or list of components, selected into the
  Object Inspector. The property editor is created based on the type of the
  property being edited as determined by the types registered by
  RegisterPropertyEditor. The Object Inspector uses a TPropertyEditor
  for all modification to a property. GetName and GetValue are called to
  display the name and value of the property. SetValue is called whenever the
  user requests to change the value. Edit is called when the user
  double-clicks the property in the Object Inspector. GetValues is called when
  the drop-down list of a property is displayed. GetProperties is called when
  the property is expanded to show sub-properties. AllEqual is called to decide
  whether or not to display the value of the property when more than one
  component is selected.

  The following are methods that can be overridden to change the behavior of
  the property editor:

    Activate
      Called whenever the property becomes selected in the object inspector.
      This is potentially useful to allow certain property attributes to
      to only be determined whenever the property is selected in the object
      inspector. Only paSubProperties and paMultiSelect,returned from
      GetAttributes,need to be accurate before this method is called.
    Deactivate
      Called whenevr the property becomes unselected in the object inspector.
    AllEqual
      Called whenever there is more than one component selected. If this
      method returns true,GetValue is called,otherwise blank is displayed
      in the Object Inspector. This is called only when GetAttributes
      returns paMultiSelect.
    AutoFill
      Called to determine whether the values returned by GetValues can be
      selected incrementally in the Object Inspector. This is called only when
      GetAttributes returns paValueList.
    Edit
      Called when the '...' button is pressed or the property is double-clicked.
      This can,for example,bring up a dialog to allow the editing the
      component in some more meaningful fashion than by text (e.g. the Font
      property).
    GetAttributes
      Returns the information for use in the Object Inspector to be able to
      show the appropriate tools. GetAttributes returns a set of type
      TPropertyAttributes:
        paValueList:    The property editor can return an enumerated list of
                        values for the property. If GetValues calls Proc
                        with values then this attribute should be set. This
                        will cause the drop-down button to appear to the right
                        of the property in the Object Inspector.
        paSortList:     Object Inspector to sort the list returned by
                        GetValues.
        paPickList:     Usable together with paValueList. The text field is
                        readonly. The user can still select values from drop
                        list. Unless paReadOnly.
        paSubProperties:The property editor has sub-properties that will be
                        displayed indented and below the current property in
                        standard outline format. If GetProperties will
                        generate property objects then this attribute should
                        be set.
        paDynamicSubProps:The sub properties can change. All designer tools
                        (e.g. property editors, component editors) that change
                        the list should call UpdateListPropertyEditors, so that
                        the object inspector will reread the subproperties.
        paDialog:       Indicates that the Edit method will bring up a
                        dialog. This will cause the '...' button to be
                        displayed to the right of the property in the Object
                        Inspector.
        paMultiSelect:  Allows the property to be displayed when more than
                        one component is selected. Some properties are not
                        appropriate for multi-selection (e.g. the Name
                        property).
        paAutoUpdate:   Causes the SetValue method to be called on each
                        change made to the editor instead of after the change
                        has been approved (e.g. the Caption property).
        paReadOnly:     Value is not allowed to change. But if paDialog is set
                        a Dialog can change the value. This disables only the
                        edit and combobox in the object inspector.
        paRevertable:   Allows the property to be reverted to the original
                        value. Things that shouldn't be reverted are nested
                        properties (e.g. Fonts) and elements of a composite
                        property such as set element values.
        paFullWidthName:Tells the object inspector that the value does not
                        need to be rendered and as such the name should be
                        rendered the full width of the inspector.
        paVolatileSubProperties: Any change of property value causes any shown
                        subproperties to be recollected.
        paDisableSubProperties: All subproperties are readonly
                        (not even via Dialog).
        paReference:    property contains a reference to something else. When
                        used in conjunction with paSubProperties the referenced
                        object should be displayed as sub properties to this
                        property.
        paNotNestable:  Indicates that the property is not safe to show when
                        showing the properties of an expanded reference.

    GetComponent
      Returns the Index'th component being edited by this property editor. This
      is used to retrieve the components. A property editor can only refer to
      multiple components when paMultiSelect is returned from GetAttributes.
    GetEditLimit
      Returns the number of character the user is allowed to enter for the
      value. The inplace editor of the object inspector will be have its
      text limited set to the return value. By default this limit is 255.
    GetName
      Returns the name of the property. By default the value is retrieved
      from the type information with all underbars replaced by spaces. This
      should only be overridden if the name of the property is not the name
      that should appear in the Object Inspector.
    GetProperties
      Should be overridden to call PropertyProc for every sub-property (or
      nested property) of the property begin edited and passing a new
      TPropertyEditor for each sub-property. By default, PropertyProc is not
      called and no sub-properties are assumed. TClassPropertyEditor will pass a
      new property editor for each published property in a class.
      TSetPropertyEditor passes a new editor for each element in the set.
    GetPropType
      Returns the type information pointer for the property(s) being edited.
    GetValue
      Returns the string value of the property. By default this returns
      '(unknown)'. This should be overridden to return the appropriate value.
    GetValues
      Called when paValueList is returned in GetAttributes. Should call Proc
      for every value that is acceptable for this property. TEnumPropertyEditor
      will pass every element in the enumeration.
    Initialize
      Called after the property editor has been created but before it is used.
      Many times property editors are created and because they are not a common
      property across the entire selection they are thrown away. Initialize is
      called after it is determined the property editor is going to be used by
      the object inspector and not just thrown away.
    SetValue(Value)
      Called to set the value of the property. The property editor should be
      able to translate the string and call one of the SetXxxValue methods. If
      the string is not in the correct format or not an allowed value,the
      property editor should generate an exception describing the problem. Set
      value can ignore all changes and allow all editing of the property be
      accomplished through the Edit method (e.g. the Picture property).
    ListMeasureWidth(Value,Canvas,AWidth)
      This is called during the width calculation phase of the drop down list
      preparation.
    ListMeasureHeight(Value,Canvas,AHeight)
      This is called during the item/value height calculation phase of the drop
      down list's render. This is very similar to TListBox's OnMeasureItem,
      just slightly different parameters.
    ListDrawValue(Value,Canvas,Rect,Selected)
      This is called during the item/value render phase of the drop down list's
      render. This is very similar to TListBox's OnDrawItem, just slightly
      different parameters.
    PropMeasureHeight(Value,Canvas,AHeight)
      This is called during the item/property height calculation phase of the
      object inspectors rows render. This is very similar to TListBox's
      OnMeasureItem, just slightly different parameters.
    PropDrawName(Canvas,Rect,Selected)
      Called during the render of the name column of the property list. Its
      functionality is very similar to TListBox's OnDrawItem,but once again
      it has slightly different parameters.
    PropDrawValue(Canvas,Rect,Selected)
      Called during the render of the value column of the property list. Its
      functionality is similar to PropDrawName. If multiple items are selected
      and their values don't match this procedure will be passed an empty
      value.

  Properties and methods useful in creating new TPropertyEditor classes:

    Name property
      Returns the name of the property returned by GetName
    PrivateEditory property
      This is the configuration directory of lazarus.
      If the property editor needs auxiliary or state files (templates,
      examples, etc) they should be stored in this editory.
    Value property
      The current value,as a string,of the property as returned by GetValue.
    Modified
      Called to indicate the value of the property has been modified. Called
      automatically by the SetXxxValue methods. If you call a TProperty
      SetXxxValue method directly,you *must* call Modified as well.
    GetXxxValue
      Gets the value of the first property in the Properties property. Calls
      the appropriate TProperty GetXxxValue method to retrieve the value.
    SetXxxValue
      Sets the value of all the properties in the Properties property. Calls
      the approprate TProperty SetXxxxValue methods to set the value.
    GetVisualValue
      This function will return the displayable value of the property. If
      only one item is selected or all the multi-selected items have the same
      property value then this function will return the actual property value.
      Otherwise this function will return an empty string.}

type
  TORImageIndexesPropertyEditor = class(TPropertyEditor)
  public
    procedure Modified;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetProperties(Proc: TGetPropProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TORImageIndexesElementPropertyEditor = class(TNestedProperty)
  private
    FElement: Integer;
    FParent: TPropertyEditor;
  protected
    constructor Create(Parent: TPropertyEditor; AElement: Integer); reintroduce;
    function ParentImgIdx(Idx: integer): TORCBImageIndexes;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetName: string; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TORSymbolPropertyEditor = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

procedure Register;

implementation

uses Vcl.Controls, Vcl.Forms, ORStaticText, ORRadioCheck, ORSplitter, UORForm,
  ORSymbolLabel, ORSymbolLabelPE;

{ TORImageIndexesPropertyEditor }

type
  TExposedORCheckBox = class(TORCheckBox)
  public
    property CustomImages;
  end;

procedure TORImageIndexesPropertyEditor.Modified;
begin
  inherited Modified;
end;

function TORImageIndexesPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paRevertable];
end;

procedure TORImageIndexesPropertyEditor.GetProperties(Proc: TGetPropProc);
var
  i: Integer;

begin
  for i := 0 to 5 do
    Proc(TORImageIndexesElementPropertyEditor.Create(Self, i));
end;

function TORImageIndexesPropertyEditor.GetValue: string;
begin
  Result := GetStrValue;
end;

procedure TORImageIndexesPropertyEditor.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

{ TORImageIndexesElementPropertyEditor }

constructor TORImageIndexesElementPropertyEditor.Create(Parent: TPropertyEditor; AElement: Integer);
begin
  inherited Create(Parent);
  FElement := AElement;
  FParent := Parent;
end;

function TORImageIndexesElementPropertyEditor.ParentImgIdx(Idx: integer): TORCBImageIndexes;
begin
  if(FParent.GetComponent(Idx) is TORCheckBox) then
    Result := TExposedORCheckBox(FParent.GetComponent(Idx)).CustomImages
  else
{  if(FParent.GetComponent(Idx) is TORListView) then
    Result := (FParent.GetComponent(Idx) as TORGEListView).FCustomImages
  else}
    Result := nil;
end;

function TORImageIndexesElementPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paRevertable];
end;

function TORImageIndexesElementPropertyEditor.GetName: string;
begin
  case FElement of
    0: Result := 'CheckedEnabledIndex';
    1: Result := 'GrayedEnabledIndex';
    2: Result := 'UncheckedEnabledIndex';
    3: Result := 'CheckedDisabledIndex';
    4: Result := 'GrayedDisabledIndex';
    5: Result := 'UncheckedDisabledIndex';
  end;
end;

function TORImageIndexesElementPropertyEditor.GetValue: string;
var
  i :integer;

begin
  for i := 0 to PropCount-1 do
  begin
    with ParentImgIdx(i) do
    case FElement of
      0: Result := IntToStr(CheckedEnabledIndex);
      1: Result := IntToStr(GrayedEnabledIndex);
      2: Result := IntToStr(UncheckedEnabledIndex);
      3: Result := IntToStr(CheckedDisabledIndex);
      4: Result := IntToStr(GrayedDisabledIndex);
      5: Result := IntToStr(UncheckedDisabledIndex);
    end;
  end;
end;

procedure TORImageIndexesElementPropertyEditor.SetValue(const Value: string);
var
  v, i: integer;

begin
  v := StrToIntDef(Value,-1);
  for i := 0 to PropCount-1 do
  begin
    with ParentImgIdx(i) do
    case FElement of
      0: CheckedEnabledIndex := v;
      1: GrayedEnabledIndex := v;
      2: UncheckedEnabledIndex := v;
      3: CheckedDisabledIndex := v;
      4: GrayedDisabledIndex := v;
      5: UncheckedDisabledIndex := v;
    end;
  end;
  (FParent as TORImageIndexesPropertyEditor).Modified;
end;

{ TORSymbolPropertyEditor }

procedure TORSymbolPropertyEditor.Edit;
var
  Dlg: TfrmORSymbolLabelPE;
  OldValue: string;
begin
  Dlg := TfrmORSymbolLabelPE.Create(Application);
  try
    Dlg.symMain.Symbol := (GetComponent(0) as TORSymbolLabel).Symbol;
    Dlg.UpdateCtrls;
    OldValue := Dlg.symMain.Symbol.ToString;
    if Dlg.ShowModal = mrOK then
    begin
      (GetComponent(0) as TORSymbolLabel).Symbol := Dlg.symMain.Symbol;
      if OldValue <> Dlg.symMain.Symbol.ToString then
        Modified;
    end;
  finally
    Dlg.Free;
  end;
end;

function TORSymbolPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paSubProperties, paDialog, paReadOnly];
end;

function TORSymbolPropertyEditor.GetValue: string;
begin
  Result := (GetComponent(0) as TORSymbolLabel).Symbol.ToString;
end;

procedure TORSymbolPropertyEditor.SetValue(const Value: string);
begin
  (GetComponent(0) as TORSymbolLabel).Symbol.FromString(Value);
end;

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS',
    [TORListBox, TORComboBox, TORAutoPanel, TOROffsetLabel, TORAlignEdit, TORSymbolLabel,
    TORAlignButton, TORAlignSpeedButton, TORTreeView, TORCheckBox, TORListView,
    TKeyClickPanel, TKeyClickRadioGroup, TCaptionListBox, TCaptionCheckListBox,
    TCaptionMemo, TCaptionEdit, TCaptionTreeView, TCaptionComboBox, TORDateTimeDlg, TORDateBox, TORDateCombo,
    TCaptionListView, TCaptionStringGrid, TCaptionRichEdit, TORStaticText, TORRadioCheck, TORSplitter{, TORCheckPanel, TORAlignBitBtn, TORCalendar}]);
  RegisterPropertyEditor(TypeInfo(string), TORCheckBox, 'ImageIndexes',
                         TORImageIndexesPropertyEditor);
  RegisterPropertyEditor(TypeInfo(TORSymbol), TORSymbolLabel, '',
                         TORSymbolPropertyEditor);
  RegisterNoIcon([TORForm]);
  RegisterCustomModule(TORForm, TCustomModule);
end;

end.


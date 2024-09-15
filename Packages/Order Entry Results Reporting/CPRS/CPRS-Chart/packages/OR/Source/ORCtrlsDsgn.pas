unit ORCtrlsDsgn;                                    // Oct 26, 1997 @ 10:00am

// To Do:  eliminate topindex itemtip on mousedown (seen when choosing clinic pts)

interface  // --------------------------------------------------------------------------------

uses Classes, DesignIntf, DesignEditors, TypInfo, ORCtrls, SysUtils, ORDtTm;

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

procedure Register;

implementation

uses ORStaticText, ORRadioCheck, ORSplitter, UORForm;

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

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS',
    [TORListBox, TORComboBox, TORAutoPanel, TOROffsetLabel, TORAlignEdit,
    TORAlignButton, TORAlignSpeedButton, TORTreeView, TORCheckBox, TORListView,
    TKeyClickPanel, TKeyClickRadioGroup, TCaptionListBox, TCaptionCheckListBox,
    TCaptionMemo, TCaptionEdit, TCaptionTreeView, TCaptionComboBox, TORDateTimeDlg, TORDateBox, TORDateCombo,
    TCaptionListView, TCaptionStringGrid, TCaptionRichEdit, TORStaticText, TORRadioCheck, TORSplitter{, TORCheckPanel, TORAlignBitBtn, TORCalendar}]);
  RegisterPropertyEditor( TypeInfo(string), TORCheckBox, 'ImageIndexes',
                          TORImageIndexesPropertyEditor);
  RegisterNoIcon([TORForm]);
  RegisterCustomModule(TORForm, TCustomModule);
end;

end.


unit ORCtrlsVA508Compatibility;

interface

uses
  Forms, Controls, StdCtrls, SysUtils, Windows, VA508AccessibilityManager;

type
  TORCheckBox508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
  end;

  TLBMgr = class
  private
    function GetIdx(Component: TWinControl): integer;
  public
    function GetComponentName(Component: TWinControl): string; virtual; abstract;
    function GetState(Component: TWinControl): string; virtual; abstract;
    function GetItemInstructions(Component: TWinControl): string; virtual; abstract;
  end;

  TORListBox508Manager = class(TVA508ManagedComponentClass)
  var
    FCheckBoxes: TLBMgr;
    FMultiSelect: TLBMgr;
    FStandard: TLBMgr;
    FCurrent: TLBMgr;
    function GetCurrent(Component: TWinControl): TLBMgr;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
    function GetItemInstructions(Component: TWinControl): string; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TVA508TORDateComboComplexManager = class(TVA508ComplexComponentManager)
  public
    constructor Create;
    procedure Refresh(Component: TWinControl;
                      AccessibilityManager: TVA508AccessibilityManager); override;
  end;

//  TVA508TORComboBoxComplexManager = class(TVA508ComplexComponentManager)
//  public
//    constructor Create;
//    procedure Refresh(Component: TWinControl;
//                      AccessibilityManager: TVA508AccessibilityManager); override;
//  end;

{  TVA508TORDateBoxComplexManager = class(TVA508ComplexComponentManager)
  public
    constructor Create;
    procedure Refresh(Component: TWinControl;
                      AccessibilityManager: TVA508AccessibilityManager); override;
  end;}

  TORComboBox508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TORDayCombo508Manager = class(TORComboBox508Manager)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TORMonthCombo508Manager = class(TORComboBox508Manager)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TORYearEdit508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TORDateButton508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

//  TORComboEdit508Manager = class(TVA508ManagedComponentClass)
//  public
//    constructor Create; override;
//    function Redirect(Component: TWinControl; var ManagedType: TManagedType): TWinControl; override;
//  end;

implementation

uses VA508DelphiCompatibility, ORCtrls, ORDtTm, VA508AccessibilityRouter,
  VA508AccessibilityConst, ORDtTmRng, UResponsiveGUI;

function GetEditBox(ComboBox: TORComboBox): TORComboEdit;
var
  i: integer;

begin
  Result := nil;
  for i := 0 to ComboBox.ControlCount - 1 do
  begin
    if ComboBox.Controls[i] is TORComboEdit then
    begin
      Result := TORComboEdit(ComboBox.Controls[i]);
      exit;
    end;
  end;
end;

function ORComboBoxAlternateHandle(Component: TWinControl): HWnd;
var
  eBox: TORComboEdit;
  cBox: TORComboBox;

begin
  cBox := TORComboBox(Component);
  eBox := GetEditBox(cBox);
  if assigned(eBox) then
    Result := eBox.Handle
  else
    Result := cBox.Handle;
end;

type
  TVA508RegistrationScreenReader = class(TVA508ScreenReader);
{ Registration }

procedure RegisterORComponents;
begin
  RegisterAlternateHandleComponent(TORComboBox, ORComboBoxAlternateHandle);

  RegisterManagedComponentClass(TORCheckBox508Manager.Create);
  RegisterManagedComponentClass(TORComboBox508Manager.Create);
  RegisterManagedComponentClass(TORListBox508Manager.Create);
  RegisterManagedComponentClass(TORDayCombo508Manager.Create);
  RegisterManagedComponentClass(TORMonthCombo508Manager.Create);
  RegisterManagedComponentClass(TORYearEdit508Manager.Create);
  RegisterManagedComponentClass(TORDateButton508Manager.Create);
//  RegisterManagedComponentClass(TORComboEdit508Manager.Create);

  RegisterComplexComponentManager(TVA508TORDateComboComplexManager.Create);
//  RegisterComplexComponentManager(TVA508TORComboBoxComplexManager.Create);
//  RegisterComplexComponentManager(TVA508TORDateBoxComplexManager.Create);


  with TVA508RegistrationScreenReader(GetScreenReader) do
  begin
//---TORCalendar ???
//---TORPopupMenu ???
//---TORMenuItem ???

    RegisterCustomClassBehavior(TORTreeView.ClassName, CLASS_BEHAVIOR_TREE_VIEW);
    RegisterCustomClassBehavior(TORAlignEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TORAlignButton.ClassName, CLASS_BEHAVIOR_BUTTON);
    RegisterCustomClassBehavior(TORAlignSpeedButton.ClassName, CLASS_BEHAVIOR_BUTTON);
    RegisterCustomClassBehavior(TORCheckBox.ClassName, CLASS_BEHAVIOR_CHECK_BOX);
    RegisterCustomClassBehavior(TKeyClickPanel.ClassName, CLASS_BEHAVIOR_BUTTON);
    RegisterCustomClassBehavior(TKeyClickRadioGroup.ClassName, CLASS_BEHAVIOR_GROUP_BOX);
    RegisterCustomClassBehavior(TCaptionTreeView.ClassName, CLASS_BEHAVIOR_TREE_VIEW);
    RegisterCustomClassBehavior(TCaptionMemo.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCaptionEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCaptionRichEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TOROffsetLabel.ClassName, CLASS_BEHAVIOR_STATIC_TEXT);

    RegisterCustomClassBehavior(TCaptionComboBox.ClassName, CLASS_BEHAVIOR_COMBO_BOX);
    RegisterCustomClassBehavior(TORComboEdit.ClassName, CLASS_BEHAVIOR_EDIT_COMBO);
    RegisterCustomClassBehavior(TORComboBox.ClassName, CLASS_BEHAVIOR_COMBO_BOX);
    RegisterCustomClassBehavior(TORListBox.ClassName, CLASS_BEHAVIOR_LIST_BOX);
    RegisterCustomClassBehavior(TCaptionCheckListBox.ClassName, CLASS_BEHAVIOR_LIST_BOX);
    RegisterCustomClassBehavior(TCaptionStringGrid.ClassName, CLASS_BEHAVIOR_LIST_BOX);

    RegisterCustomClassBehavior(TORDateEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TORDayCombo.ClassName, CLASS_BEHAVIOR_COMBO_BOX);
    RegisterCustomClassBehavior(TORMonthCombo.ClassName, CLASS_BEHAVIOR_COMBO_BOX);
    RegisterCustomClassBehavior(TORYearEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TORDateBox.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TORDateCombo.ClassName, CLASS_BEHAVIOR_GROUP_BOX);

    RegisterCustomClassBehavior(TORListView.ClassName, CLASS_BEHAVIOR_LIST_VIEW);
    RegisterCustomClassBehavior(TCaptionListView.ClassName, CLASS_BEHAVIOR_LIST_VIEW);
    RegisterCustomClassBehavior(TCaptionListBox.ClassName, CLASS_BEHAVIOR_LIST_BOX);

    RegisterCustomClassBehavior(TORDateRangeDlg.ClassName, CLASS_BEHAVIOR_DIALOG);
    RegisterCustomClassBehavior(TORfrmDtTm.ClassName, CLASS_BEHAVIOR_DIALOG);//called by TORDateTimeDlg
  end;
end;

{ TORCheckBox508Manager }

constructor TORCheckBox508Manager.Create;
begin
  inherited Create(TORCheckBox, [mtComponentName, mtInstructions, mtState, mtStateChange], TRUE);
end;

function TORCheckBox508Manager.GetComponentName(Component: TWinControl): string;
begin
  with TORCheckBox(Component) do
  begin
    if RadioStyle then
      Result := 'radio button'
    else
      Result := VA508DelphiCompatibility.GetCheckBoxComponentName(AllowGrayed);
  end;
end;

function TORCheckBox508Manager.GetInstructions(Component: TWinControl): string;
begin
  Result := VA508DelphiCompatibility.GetCheckBoxInstructionMessage(TORCheckBox(Component).Checked);
end;

function TORCheckBox508Manager.GetState(Component: TWinControl): string;
var
  cb: TORCheckBox;
begin
  TResponsiveGUI.ProcessMessages; // <<<  needed to allow messages that set state to process
  Result := '';
  cb := TORCheckBox(Component);
  if (cb.State = cbGrayed) and (cb.GrayedStyle in [gsQuestionMark, gsBlueQuestionMark]) then
    Result := 'Question Mark'
  else
    Result := VA508DelphiCompatibility.GetCheckBoxStateText(cb.State);
end;

{ TORListBox508Manager }

type
  TORListBoxCheckBoxes508Manager = class(TLBMgr)
  public
    function GetComponentName(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
    function GetItemInstructions(Component: TWinControl): string; override;
  end;

  TORListBoxMultiSelect508Manager = class(TLBMgr)
  public
    function GetComponentName(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
    function GetItemInstructions(Component: TWinControl): string; override;
  end;

  TORListBoxStandard508Manager = class(TLBMgr)
  public
    function GetComponentName(Component: TWinControl): string; override;
    function GetState(Component: TWinControl): string; override;
    function GetItemInstructions(Component: TWinControl): string; override;
  end;

constructor TORListBox508Manager.Create;
begin
  inherited Create(TORListBox, [mtComponentName, mtValue, mtState, mtStateChange,
                   mtItemChange, mtItemInstructions]);
end;

destructor TORListBox508Manager.Destroy;
begin
  FCurrent := nil;
  if assigned(FCheckBoxes) then
    FreeAndNil(FCheckBoxes);
  if assigned(FMultiSelect) then
    FreeAndNil(FMultiSelect);
  if assigned(FStandard) then
    FreeAndNil(FStandard);
  inherited;
end;

function TORListBox508Manager.GetComponentName(Component: TWinControl): string;
begin
  Result := GetCurrent(Component).GetComponentName(Component);
end;

function TORListBox508Manager.GetItem(Component: TWinControl): TObject;
var
  lb : TORListBox;
  max, id: integer;
begin
  GetCurrent(Component);
  lb := TORListBox(Component);
  max := lb.items.Count + 2;
  if max < 10000 then
    max := 10000;
  id := (lb.items.Count * max) + (lb.FocusIndex + 2);
  if lb.FocusIndex < 0 then dec(id);
  Result := TObject(id);
end;

function TORListBox508Manager.GetItemInstructions(
  Component: TWinControl): string;
begin
  Result := GetCurrent(Component).GetItemInstructions(Component);
end;

function TORListBox508Manager.GetState(Component: TWinControl): string;
begin
  Result := GetCurrent(Component).GetState(Component);
end;

function TORListBox508Manager.GetValue(Component: TWinControl): string;
var idx: integer;
  lb: TORListBox;
begin
  lb := TORListBox(Component);
  idx := lb.FocusIndex;
  if idx < 0 then
    idx := 0;
  Result := lb.DisplayText[idx];
end;

function TORListBox508Manager.GetCurrent(Component: TWinControl): TLBMgr;
var
  lb : TORListBox;

begin
  lb := TORListBox(Component);
  if lb.CheckBoxes then
  begin
    if not assigned(FCheckBoxes) then
      FCheckBoxes := TORListBoxCheckBoxes508Manager.Create;
    FCurrent := FCheckBoxes;
  end
  else if lb.MultiSelect then
  begin
    if not assigned(FMultiSelect) then
      FMultiSelect := TORListBoxMultiSelect508Manager.Create;
    FCurrent := FMultiSelect;
  end
  else
  begin
    if not assigned(FStandard) then
      FStandard := TORListBoxStandard508Manager.Create;
    FCurrent := FStandard;
  end;
  Result := FCurrent;
end;

{ TORListBoxCheckBoxes508Manager }

function TORListBoxCheckBoxes508Manager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := 'Check List Box'
end;

function TORListBoxCheckBoxes508Manager.GetItemInstructions(
  Component: TWinControl): string;
var
  lb: TORListBox;
  idx: integer;
begin
  Result := '';
  lb := TORListBox(Component);
  idx := GetIdx(Component);
  if (idx >= 0) then
    Result := VA508DelphiCompatibility.GetCheckBoxInstructionMessage(lb.Checked[idx])
  else
    Result := '';
end;

function TORListBoxCheckBoxes508Manager.GetState(
  Component: TWinControl): string;
var
  lb: TORListBox;
  idx: integer;
begin
  lb := TORListBox(Component);
  idx := GetIdx(Component);
  if (idx >= 0) then
  begin
    Result := GetCheckBoxStateText(lb.CheckedState[idx]);
    if lb.FocusIndex < 0 then
      Result := 'not selected ' + Result;
  end
  else
    Result := '';
end;

{ TORListBoxMultiSelect508Manager }

function TORListBoxMultiSelect508Manager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := 'Multi Select List Box'
end;

function TORListBoxMultiSelect508Manager.GetItemInstructions(
  Component: TWinControl): string;
var
  lb: TORListBox;
  idx: integer;
begin
  Result := '';
  lb := TORListBox(Component);
  idx := GetIdx(Component);
  if (idx >= 0) then
  begin
    if not lb.Selected[idx] then
      Result := 'to select press space bar'
    else
      Result := 'to un select press space bar';
  end;
end;

function TORListBoxMultiSelect508Manager.GetState(
  Component: TWinControl): string;
var
  lb: TORListBox;
  idx: Integer;
begin
  lb := TORListBox(Component);
  idx := GetIdx(Component);
  if (idx >= 0) then
  begin
    if lb.Selected[idx] then
      Result := 'Selected'
    else
      Result := 'Not Selected';
  end
  else
    Result := '';
end;

{ TORListBoxStandard508Manager }

function TORListBoxStandard508Manager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := 'List Box';
end;

function TORListBoxStandard508Manager.GetItemInstructions(
  Component: TWinControl): string;
begin
  Result := '';
end;

function TORListBoxStandard508Manager.GetState(Component: TWinControl): string;
var
  lb: TORListBox;
begin
  lb := TORListBox(Component);
  if (lb.FocusIndex < 0) then
    Result := 'Not Selected'
  else
    Result := '';
end;

{ TLBMgr }

function TLBMgr.GetIdx(Component: TWinControl): integer;
begin
  Result := TORListBox(Component).FocusIndex;
  if (Result < 0) and (TORListBox(Component).Count > 0) then
    Result := 0;
end;

{ TVA508TORDateComboComplexManager }

constructor TVA508TORDateComboComplexManager.Create;
begin
  inherited Create(TORDateCombo);
end;

type
  TORDateComboFriend = class(TORDateCombo);

procedure TVA508TORDateComboComplexManager.Refresh(Component: TWinControl;
  AccessibilityManager: TVA508AccessibilityManager);
begin
  with TORDateComboFriend(Component) do
  begin
    ClearSubControls(Component);
//    if assigned(CalBtn) then
//      CalBtn.TabStop := TRUE;
//    if IncludeBtn then
//      AddSubControl(CalBtn, AccessibilityManager);
    AddSubControl(Component, YearEdit, AccessibilityManager);
//    AddSubControl(YearUD, AccessibilityManager);
    if IncludeMonth then
      AddSubControl(Component, MonthCombo, AccessibilityManager);
    if IncludeDay then
      AddSubControl(Component, DayCombo, AccessibilityManager);
  end;
end;

{ TORDayCombo508Manager }

constructor TORDayCombo508Manager.Create;
begin
  inherited Create(TORDayCombo, [mtCaption, mtValue]);
end;

function TORDayCombo508Manager.GetCaption(Component: TWinControl): string;
begin
  Result := 'Day';
end;

{ TORMonthCombo508Manager }

constructor TORMonthCombo508Manager.Create;
begin
  inherited Create(TORMonthCombo, [mtCaption, mtValue]);
end;

function TORMonthCombo508Manager.GetCaption(Component: TWinControl): string;
begin
  Result := 'Month';
end;

{ TORYearEdit508Manager }

constructor TORYearEdit508Manager.Create;
begin
  inherited Create(TORYearEdit, [mtCaption]);
end;

function TORYearEdit508Manager.GetCaption(Component: TWinControl): string;
begin
  Result := 'Year';
end;

{ TORDateButton508Manager }

constructor TORDateButton508Manager.Create;
begin
  inherited Create(TORDateButton, [mtCaption]);
end;

function TORDateButton508Manager.GetCaption(Component: TWinControl): string;
begin
  Result := 'Date';
end;

(*
{ TVA508TORDateBoxComplexManager }

constructor TVA508TORDateBoxComplexManager.Create;
begin
  inherited Create(TORDateBox);
end;

type
  TORDateBoxFriend = class(TORDateBox);

procedure TVA508TORDateBoxComplexManager.Refresh(Component: TWinControl;
  AccessibilityManager: TVA508AccessibilityManager);
begin
  with TORDateBoxFriend(Component) do
  begin
    ClearSubControls;
    if assigned(DateButton) then
    begin
      DateButton.TabStop := TRUE;
      AddSubControl(DateButton, AccessibilityManager);
    end;
  end;
end;
*)

{ TVA508ORComboManager }

constructor TORComboBox508Manager.Create;
begin
  inherited Create(TORComboBox, [mtValue], TRUE);
end;

function TORComboBox508Manager.GetValue(Component: TWinControl): string;
begin
  Result := TORComboBox(Component).Text;
end;

{ TORComboEdit508Manager }

//constructor TORComboEdit508Manager.Create;
//begin
//  inherited Create(TORComboEdit, [mtComponentRedirect]);
//end;
//
//function TORComboEdit508Manager.Redirect(Component: TWinControl;
//  var ManagedType: TManagedType): TWinControl;
//begin
//  ManagedType := mtCaption;
//  Result := TWinControl(Component.Owner);
//end;

{ TVA508TORComboBoxComplexManager }

//constructor TVA508TORComboBoxComplexManager.Create;
//begin
//  inherited Create(TORComboBox);
//end;
//
//procedure TVA508TORComboBoxComplexManager.Refresh(Component: TWinControl;
//  AccessibilityManager: TVA508AccessibilityManager);
//var
//  eBox: TORComboEdit;
//begin
//  begin
//    ClearSubControls;
//    eBox := GetEditBox(TORComboBox(Component));
//    if assigned(eBox) then
//      AddSubControl(eBox, AccessibilityManager);
//  end;
//end;

initialization
  RegisterORComponents;

end.

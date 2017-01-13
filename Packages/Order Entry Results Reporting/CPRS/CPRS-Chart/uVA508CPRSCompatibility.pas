unit uVA508CPRSCompatibility;

interface

uses
  SysUtils, Windows, Classes, Controls, Forms, StdCtrls;

procedure QuickCopyWith508Msg(AFrom, ATo: TObject; docType: string = ''); deprecated;
procedure QuickAddWith508Msg(AFrom, ATo: TObject; docType: string = ''); deprecated;
procedure FastAssignWith508Msg(source, destination: TStrings; docType: string = ''); deprecated;

procedure SpeakTextInserted(docType: string = '');
procedure SpeakStrings(AnObject: TObject; docType: string = '');
function GetTabText: string;
procedure SpeakPatient;
procedure SpeakTabAndPatient;

implementation

uses VA508AccessibilityRouter, VA508AccessibilityManager, ORFn, uDlgComponents,
  VA508DelphiCompatibility, ORCtrls, fReminderDialog, fTemplateDialog, fFrame,
  uCore, ORCtrlsVA508Compatibility, mTemplateFieldButton, VA508AccessibilityConst;

type
  TCPRSParentDialogCheckBox508Manager = class(TORCheckBox508Manager)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TCPRSBaseDialogComponent508Manager = class(TVA508ManagedComponentClass)
  public
    function GetCaption(Component: TWinControl): string; override;
  end;

{  TCPRSDialogStaticLabel508Manager = class(TVA508StaticTextManager)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;
  }

  TCPRSDialogEdit508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
  end;

  TCPRSDialogFieldComboBox508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
  end;

  TCPRSDialogDateBox508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
  end;

  TCPRSDialogCheckBox508Manager = class(TORCheckBox508Manager)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TCPRSDialogRichEdit508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
  end;

  TCPRSDialogLabel508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
  end;

  TCPRSDialogHyperlink508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
  end;

  TCPRSDialogNumberComplexManager = class(TVA508ComplexComponentManager)
  public
    constructor Create;
    procedure Refresh(Component: TWinControl;
                      AccessibilityManager: TVA508AccessibilityManager); override;
  end;

  TCPRSDialogYearEdit508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function Redirect(Component: TWinControl; var ManagedType: TManagedType): TWinControl; override;
  end;

  TCPRSNumberField508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetCaption(Component: TWinControl): string; override;
  end;

  TCPRSDialogDateCombo508Manager = class(TCPRSBaseDialogComponent508Manager)
  public
    constructor Create; override;
  end;

  TfraTemplateFieldButtonComplexManager = class(TVA508ComplexComponentManager)
  public
    constructor Create;
    procedure Refresh(Component: TWinControl;
                      AccessibilityManager: TVA508AccessibilityManager); override;
  end;

  TfraTemplateFieldButton508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetValue(Component: TWinControl): string; override;
    function GetCaption(Component: TWinControl): string; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
  end;

  TMentalHealthMemo508Manager = class(TVA508ManagedComponentClass)
  public
    constructor Create; override;
    function GetComponentName(Component: TWinControl): string; override;
    function GetInstructions(Component: TWinControl): string; override;
  end;

procedure SpeakStrings(AnObject: TObject; docType: string = '');
begin
  if (AnObject is TStrings) and (TStrings(AnObject).Count > 0) then
    SpeakTextInserted(docType);
end;

procedure SpeakTextInserted(docType: string = '');
begin
  if docType = '' then
    GetScreenReader.Speak('text inserted')
  else
    GetScreenReader.Speak('text inserted in to ' + docType);
end;

procedure QuickCopyWith508Msg(AFrom, ATo: TObject; docType: string = '');
begin
  QuickCopy(AFrom, ATo);
  SpeakStrings(AFrom, docType);
end;

procedure QuickAddWith508Msg(AFrom, ATo: TObject; docType: string = '');
begin
  QuickAdd(AFrom, ATo);
  SpeakStrings(AFrom, docType);
end;

procedure FastAssignWith508Msg(source, destination: TStrings; docType: string = '');
begin
  FastAssign(source, destination);
  if source.Count > 0 then
    SpeakTextInserted(docType);
end;

procedure ControlShiftTOverride; forward;
procedure ControlTabOverride; forward;
procedure ControlShiftTabOverride; forward;

type
  TVA508RegistrationScreenReader = class(TVA508ScreenReader);

procedure Register508CompatibilityChanges;
begin
  with GetScreenReader do
  begin
    RegisterDictionaryChange('<unknown>','unknown');
    RegisterDictionaryChange('VistA','Vist a');
    RegisterDictionaryChange('VA','V A');
    RegisterDictionaryChange('VHA','V H A');
    RegisterDictionaryChange('HealtheVet','Health E Vet');
  end;
  RegisterManagedComponentClass(TCPRSParentDialogCheckBox508Manager.Create);
//  RegisterManagedComponentClass(TCPRSDialogStaticLabel508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogEdit508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogFieldComboBox508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogCheckBox508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogRichEdit508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogLabel508Manager.Create);
  RegisterManagedComponentClass(TCPRSNumberField508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogHyperlink508Manager.Create);
  RegisterManagedComponentClass(TfraTemplateFieldButton508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogDateBox508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogDateCombo508Manager.Create);
  RegisterManagedComponentClass(TCPRSDialogYearEdit508Manager.Create);
  RegisterManagedComponentClass(TMentalHealthMemo508Manager.Create);
  
  RegisterComplexComponentManager(TCPRSDialogNumberComplexManager.Create);

  GetScreenReader.RegisterCustomKeyMapping('Control+Tab', ControlTabOverride,
                'Advances to the next tab in a tab control',
                'advances to the next tab in a tab control, when you are inside a control with tabs');
  GetScreenReader.RegisterCustomKeyMapping('Control+Shift+Tab', ControlShiftTabOverride,
                'Advances to the previous tab in a tab control',
                'advances to the previous tab in a tab control, when you are inside a control with tabs');
  GetScreenReader.RegisterCustomKeyMapping('Control+Shift+T', ControlShiftTOverride,
                'Announces Chart Tab and Patient Name',
                'Announces the current CPRS Chart tab and the current patient');

  with TVA508RegistrationScreenReader(GetScreenReader) do
  begin
    RegisterCustomClassBehavior(TCPRSDialogParentCheckBox.ClassName, CLASS_BEHAVIOR_CHECK_BOX);
    RegisterCustomClassBehavior(TCPRSDialogCheckBox.ClassName, CLASS_BEHAVIOR_CHECK_BOX);
    RegisterCustomClassBehavior(TCPRSDialogRichEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCPRSDialogFieldEdit.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCPRSDialogComboBox.ClassName, CLASS_BEHAVIOR_EDIT_COMBO);
    RegisterCustomClassBehavior(TCPRSDialogButton.ClassName, CLASS_BEHAVIOR_BUTTON);
    RegisterCustomClassBehavior(TCPRSDialogDateBox.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCPRSDialogNumber.ClassName, CLASS_BEHAVIOR_EDIT);
    RegisterCustomClassBehavior(TCPRSNumberField.ClassName, CLASS_BEHAVIOR_EDIT);
  end;

end;

{ TCPRSDialogCheckBox }

constructor TCPRSParentDialogCheckBox508Manager.Create;
begin
  inherited Create(TCPRSDialogParentCheckBox, [mtCaption, mtComponentName, mtInstructions, mtState, mtStateChange]);
end;

function TCPRSParentDialogCheckBox508Manager.GetCaption(Component: TWinControl): string;
begin
  Result := TCPRSDialogParentCheckBox(Component).AccessText;
end;

type
  ExposedControl = class(TWinControl);

// CQ #14984
procedure ControlTabOverride;
begin
  if assigned(Screen.ActiveControl) and (Screen.ActiveControl is TCustomMemo) then
    ExposedControl(Screen.FocusedForm).SelectNext(Screen.ActiveControl, TRUE, TRUE)
  else
  begin
    keybd_event(VK_TAB, 0, 0, VK_CONTROL);
    keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, VK_CONTROL);
  end;
end;

procedure ControlShiftTabOverride;
begin
  if assigned(Screen.ActiveControl) and (Screen.ActiveControl is TCustomMemo) then
    ExposedControl(Screen.FocusedForm).SelectNext(Screen.ActiveControl, FALSE, TRUE)
  else
  begin
    keybd_event(VK_TAB, 0, 0, (VK_SHIFT * 256) + VK_CONTROL);
    keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, (VK_SHIFT * 256) + VK_CONTROL);
  end;
end;

procedure ControlShiftTOverride;
begin
  SpeakTabAndPatient;
end;

function GetTabText: string;
var
  idx: integer;
begin
  Result := '';
  if assigned(frmFrame) and assigned(frmFrame.tabPage) then
  begin
    idx := frmFrame.tabPage.TabIndex;
    if (idx >= 0) and (idx < uTabList.Count) then
    begin
      Result := frmFrame.tabPage.Tabs[idx];
      if Result = 'D/C Summ' then
        Result := 'Discharge Summary';
    end;
  end;
end;

procedure SpeakPatient;
begin
  //CQ #17491: Associating 508 change that allows JAWS to dictate the patient status indicator along with the name.
  if assigned(Patient) and (Patient.Name <> '') and (Patient.Status <> '') then
    GetScreenReader.Speak(Patient.Name + Patient.Status);
end;

procedure SpeakTabAndPatient;
var
  text: string;
begin
  text := GetTabText;
  if text <> '' then
    text := text + ' tab';
  if text <> '' then
    text := text + ', ';
  //CQ #17491: Associating 508 change that allows JAWS to dictate the patient status indicator along with the name.
  if assigned(Patient) and (Patient.Name <> '') and (Patient.Status <> '') then
    text := text + Patient.Name + Patient.Status
  else
    text := text + 'no patient selected';
  if text <> '' then
    GetScreenReader.Speak(text);
end;

{ TCPRSDialogComponent508Manager }

function TCPRSBaseDialogComponent508Manager.GetCaption(
  Component: TWinControl): string;
begin
  if Supports(Component, ICPRSDialogComponent) then
  begin
    Result := (Component as ICPRSDialogComponent).AccessText;
  end
  else
    Result := '';
end;

(*
{ TCPRSDialogStaticLabel508Manager }

constructor TCPRSDialogStaticLabel508Manager.Create;
begin
  inherited Create(TCPRSDialogStaticLabel, [mtCaption]);
end;

function TCPRSDialogStaticLabel508Manager.GetCaption(
  Component: TWinControl): string;
var
  txt: string;
begin
  if Supports(Component, ICPRSDialogComponent) then
  begin
    Result := (Component as ICPRSDialogComponent).AccessText;
  end
  else
    Result := '';
  txt := inherited GetCaption(Component);
  if txt <> '' then
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + txt;
  end;
end;
*)

{ TCPRSTemplateFieldEdit508Manager }

constructor TCPRSDialogEdit508Manager.Create;
begin
  inherited Create(TCPRSDialogFieldEdit, [mtCaption]);
end;

{ TCPRSTemplateFieldComboBox508Manager }

constructor TCPRSDialogFieldComboBox508Manager.Create;
begin
  inherited Create(TCPRSDialogComboBox, [mtCaption]);
end;

{ TCPRSTemplateFieldCheckBox508Manager }

constructor TCPRSDialogCheckBox508Manager.Create;
begin
  inherited Create(TCPRSDialogCheckBox, [mtCaption, mtComponentName, mtInstructions, mtState, mtStateChange]);
end;

function TCPRSDialogCheckBox508Manager.GetCaption(
  Component: TWinControl): string;
begin
  if Supports(Component, ICPRSDialogComponent) then
  begin
    Result := (Component as ICPRSDialogComponent).AccessText;
  end
  else
    Result := '';
  Result := Result + ' ' + TCheckBox(Component).Caption;
end;

{ TCPRSTemplateFieldRichEdit508Manager }

constructor TCPRSDialogRichEdit508Manager.Create;
begin
  inherited Create(TCPRSDialogRichEdit, [mtCaption]);
end;

{ TCPRSTemplateFieldDateCombo508Manager }

constructor TCPRSDialogLabel508Manager.Create;
begin
  inherited Create(TCPRSTemplateFieldLabel, [mtCaption, mtValue]);
end;

function TCPRSDialogLabel508Manager.GetValue(
  Component: TWinControl): string;
begin
  Result := TCPRSTemplateFieldLabel(Component).Caption;
end;

{ TCPRSTemplateFieldWebLabel508Manager }

constructor TCPRSDialogHyperlink508Manager.Create;
begin
  inherited Create(TCPRSDialogHyperlinkLabel, [mtCaption, mtValue, mtInstructions]);
end;

function TCPRSDialogHyperlink508Manager.GetInstructions(
  Component: TWinControl): string;
begin
  Result := 'To activate press space bar';
end;

function TCPRSDialogHyperlink508Manager.GetValue(
  Component: TWinControl): string;
begin
  Result := TCPRSDialogHyperlinkLabel(Component).Caption;
end;

{ TCPRSTemplateFieldNumberComplexManager }

constructor TCPRSDialogNumberComplexManager.Create;
begin
  inherited Create(TCPRSDialogNumber);
end;

procedure TCPRSDialogNumberComplexManager.Refresh(Component: TWinControl;
  AccessibilityManager: TVA508AccessibilityManager);
begin
  with TCPRSDialogNumber(Component) do
  begin
    ClearSubControls(Component);
    if assigned(Edit) then
      AddSubControl(Component, Edit, AccessibilityManager);
  end;
end;

{ TCPRSNumberField508Manager }

constructor TCPRSNumberField508Manager.Create;
begin
  inherited Create(TCPRSNumberField, [mtCaption]);
end;

function TCPRSNumberField508Manager.GetCaption(Component: TWinControl): string;
begin
  if assigned(Component.Owner) and Supports(Component.Owner, ICPRSDialogComponent) then
  begin
    Result := (Component.Owner as ICPRSDialogComponent).AccessText;
  end
  else
    Result := '';
end;

{ TfraTemplateFieldButtonComplexManager }

constructor TfraTemplateFieldButtonComplexManager.Create;
begin
  inherited Create(TfraTemplateFieldButton);
end;

procedure TfraTemplateFieldButtonComplexManager.Refresh(Component: TWinControl;
  AccessibilityManager: TVA508AccessibilityManager);
begin
  with TfraTemplateFieldButton(Component) do
  begin
    ClearSubControls(Component);
    AddSubControl(Component, pnlBtn, AccessibilityManager);
  end;
end;

{ TfraTemplateFieldButton508Manager }

constructor TfraTemplateFieldButton508Manager.Create;
begin
  inherited Create(TfraTemplateFieldButton, [mtComponentName, mtCaption, mtInstructions, mtValue]);
end;

function TfraTemplateFieldButton508Manager.GetCaption(
  Component: TWinControl): string;
begin
  if assigned(Component) and Supports(Component, ICPRSDialogComponent) then
  begin
    Result := (Component as ICPRSDialogComponent).AccessText;
  end
  else
    Result := '';
end;

function TfraTemplateFieldButton508Manager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := 'multi value button';
end;

function TfraTemplateFieldButton508Manager.GetInstructions(
  Component: TWinControl): string;
begin
  Result := 'to cycle through values press space bar';
end;

function TfraTemplateFieldButton508Manager.GetValue(
  Component: TWinControl): string;
begin
  Result := TfraTemplateFieldButton(Component).ButtonText;
  if Trim(Result) = '' then
    Result := 'blank';
end;

{ TCPRSTemplateFieldDateBox508Manager }

constructor TCPRSDialogDateBox508Manager.Create;
begin
  inherited Create(TCPRSDialogDateBox, [mtCaption]);
end;

{ TCPRSDialogYearEdit508Manager }

constructor TCPRSDialogYearEdit508Manager.Create;
begin
  inherited Create(TCPRSDialogYearEdit, [mtComponentRedirect]);
end;

function TCPRSDialogYearEdit508Manager.Redirect(Component: TWinControl;
  var ManagedType: TManagedType): TWinControl;
begin
  ManagedType := mtCaption;
  Result := TWinControl(Component.Owner);
end;

{ TCPRSDialogDateCombo508Manager }

constructor TCPRSDialogDateCombo508Manager.Create;
begin
  inherited Create(TCPRSDialogDateCombo, [mtCaption]);
end;

{ TMentalHealthMemo508Manager }

constructor TMentalHealthMemo508Manager.Create;
begin
  inherited Create(TMentalHealthMemo, [mtComponentName, mtInstructions]);
end;

function TMentalHealthMemo508Manager.GetComponentName(
  Component: TWinControl): string;
begin
  Result := ' ';
end;

function TMentalHealthMemo508Manager.GetInstructions(
  Component: TWinControl): string;
begin
  Result := ' ';
end;

initialization
  Register508CompatibilityChanges;


end.

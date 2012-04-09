unit fBase508Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VA508AccessibilityManager, OR2006Compatibility, uConst;

type
  TAccessibilityAction = (aaColorConversion, aaTitleBarHeightAdjustment,
                          aaFixTabStopArrowNavigationBug);
  TAccessibilityActions = set of TAccessibilityAction;

  TfrmBase508Form = class(Tfrm2006Compatibility)
    amgrMain: TVA508AccessibilityManager;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FLoadedCalled: boolean;
    FDefaultButton: TButton;
    FActions: TAccessibilityActions;
    FUnfocusableControlPtr: TMethod;
    procedure AdjustForTitleBarHeightChanges;
    function GetDefaultButton(OwnerComponent: TComponent) : TButton;
    procedure ClickDefaultButton;
    procedure SetDefaultButton(const Value: TButton);
    procedure ModifyUnfocusableControl(Control: TWinControl; Attach: boolean);
    procedure UM508(var Message: TMessage); message UM_508;
  protected
    procedure Activate; override;
    procedure Loaded; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure UpdateAccessabilityActions(var Actions: TAccessibilityActions); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property DefaultButton : TButton read FDefaultButton write SetDefaultButton;
  end;

var
  Last508KeyCode: LongInt = 0;

procedure UnfocusableControlEnter(Self, Sender: TObject);

implementation

uses ORFn, VA508AccessibilityRouter, VAUtils;

{$R *.dfm}

const
  MSG_508_CODE_TITLE_BAR = 1;

type
  TFriendWinControl = class(TWinControl);

procedure UnfocusableControlEnter(Self, Sender: TObject);
var
  ctrl: TWinControl;
begin
  if (Last508KeyCode = VK_UP) or (Last508KeyCode = VK_LEFT) then
  begin
    ctrl := TWinControl(Sender);
    ctrl := TFriendWinControl(ctrl.Parent).FindNextControl(ctrl, FALSE, TRUE, FALSE);
    if assigned(ctrl) and (ctrl <> Sender) then
      ctrl.SetFocus;
    Last508KeyCode := 0;
  end
  else
  if (Last508KeyCode = VK_DOWN) or (Last508KeyCode = VK_RIGHT) then
  begin
    keybd_event(VK_TAB,0,0,0);
    keybd_event(VK_TAB,0,KEYEVENTF_KEYUP,0);
    Last508KeyCode := 0;
  end;
end;

{ TfrmBase508Form }

// All forms in CPRS should be a descendant of this form, even those that are programatically
// made children of other forms.
procedure TfrmBase508Form.Activate;
begin
  Last508KeyCode := 0;
  inherited;
end;

procedure TfrmBase508Form.AdjustForTitleBarHeightChanges;
var
  OldResize: TNotifyEvent;
begin
  if parent <> nil then exit;
  OldResize := OnResize;
  try
    OnResize := nil;
    AdjustForWindowsXPStyleTitleBar(Self);
  finally
    OnResize := OldResize;
  end;
end;

procedure TfrmBase508Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (ssCtrl in Shift) then begin
    ClickDefaultButton;
    Key := 0;
  end;
end;

procedure TfrmBase508Form.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if FLoadedCalled and (aaFixTabStopArrowNavigationBug in FActions) and (AComponent is TWinControl) then
  begin
    ModifyUnfocusableControl(TWinControl(AComponent), Operation = opInsert);
  end;
end;

function TfrmBase508Form.GetDefaultButton(ownerComponent: TComponent): TButton;
var
  i : integer;
begin
  Result := nil;
  with ownerComponent do begin
    for i := 0 to ComponentCount - 1 do begin
      if Components[i] is TButton then begin
        if TButton(Components[i]).Default then
          Result := TButton(Components[i]);
      end
      else if Components[i] is TFrame then
        Result := GetDefaultButton(Components[i]);
      if Assigned(Result) then
        Break;
    end;
  end;
end;

procedure TfrmBase508Form.Loaded;
begin
  inherited Loaded;
  FLoadedCalled := TRUE;
end;

procedure TfrmBase508Form.ModifyUnfocusableControl(Control: TWinControl; Attach: boolean);
var
  wc: TFriendWinControl;
begin
  if (Control is TPanel) or (Control is TCustomGroupBox) then
  begin
    wc := TFriendWinControl(Control);
    if not wc.TabStop then
    begin
      if not assigned(wc.OnEnter) then
      begin
        if Attach then        
          wc.OnEnter := TNotifyEvent(FUnfocusableControlPtr);
      end
      else
      begin
        if (not Attach) and (TMethod(wc.OnEnter).Code = FUnfocusableControlPtr.Code) then
          wc.OnEnter := nil;
      end;
    end;
  end;
end;

procedure TfrmBase508Form.SetDefaultButton(const Value: TButton);
begin
  FDefaultButton := Value;
end;

procedure TfrmBase508Form.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if assigned(AParent) then
    AutoScroll := False;
end;

// to prevent a 508 feature from taking place, remove that feature's flag form the Actions set
// in an override of the UpdateAccessabilityActions proc.
procedure TfrmBase508Form.UM508(var Message: TMessage);
begin
  case Message.WParam of
    MSG_508_CODE_TITLE_BAR: AdjustForTitleBarHeightChanges;        
  end;
end;

procedure TfrmBase508Form.UpdateAccessabilityActions(var Actions: TAccessibilityActions);
begin
end;

type
  TExposedBtn = class(TButton);

procedure TfrmBase508Form.ClickDefaultButton;
var
  tempDefaultBtn: TButton;
begin
  if Assigned(DefaultButton) then
    tempDefaultBtn := DefaultButton
  else
    tempDefaultBtn := GetDefaultButton(Self);
  if Assigned(tempDefaultBtn) then
    if tempDefaultBtn.Visible then
      TExposedBtn(tempDefaultBtn).Click;
end;

constructor TfrmBase508Form.Create(AOwner: TComponent);

  procedure AdjustControls(Control: TWinControl);
  var
    i: integer;
    wc: TWinControl;
  begin
    for I := 0 to Control.ControlCount-1 do
    begin
      if Control.Controls[i] is TWinControl then
      begin
        wc := TWinControl(Control.Controls[i]);
        if not wc.TabStop then
          ModifyUnfocusableControl(wc, TRUE);
        AdjustControls(wc);
      end;
    end;
  end;

begin
  inherited Create(AOwner);
  if not assigned(Parent) then  
    AutoScroll := True;
  FActions := [aaColorConversion, aaTitleBarHeightAdjustment, aaFixTabStopArrowNavigationBug];
  UpdateAccessabilityActions(FActions);
  if aaColorConversion in FActions then
    UpdateColorsFor508Compliance(Self);

  if aaTitleBarHeightAdjustment in FActions then
    PostMessage(Handle, UM_508, MSG_508_CODE_TITLE_BAR, 0);

  if aaFixTabStopArrowNavigationBug in FActions then
  begin
    FUnfocusableControlPtr.Code := @UnfocusableControlEnter;
    FUnfocusableControlPtr.Data := nil;
    AdjustControls(Self);
  end;
  Last508KeyCode := 0;
end;

const
  KEY_MASK = $20000000; // ignore Alt keys
var
  KeyMonitorHook: HHOOK;
  MouseMonitorHook: HHOOK;

function KeyMonitorProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;
begin
  if (code = HC_ACTION) and ((lParam and KEY_MASK) = 0) then
    Last508KeyCode := wParam;
  Result := CallNextHookEx(KeyMonitorHook, Code, wParam, lParam);
end;

// if mouse click clear last key code
function MouseMonitorProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;
begin
  if (Code = HC_ACTION) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST) then
    Last508KeyCode := 0;
  Result := CallNextHookEx(MouseMonitorHook, Code, wParam, lParam);
end;

initialization
  KeyMonitorHook   := SetWindowsHookEx(WH_KEYBOARD, KeyMonitorProc,   0, GetCurrentThreadID);
  MouseMonitorHook := SetWindowsHookEx(WH_MOUSE,    MouseMonitorProc, 0, GetCurrentThreadID);

  SpecifyFormIsNotADialog(TfrmBase508Form);
  SpecifyFormIsNotADialog(Tfrm2006Compatibility);

finalization
  UnhookWindowsHookEx(KeyMonitorHook);
  UnhookWindowsHookEx(MouseMonitorHook);

end.

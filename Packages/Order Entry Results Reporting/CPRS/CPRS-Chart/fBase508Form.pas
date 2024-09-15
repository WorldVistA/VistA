unit fBase508Form;

interface

uses
  UORForm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ORFn,
  Dialogs, StdCtrls, ExtCtrls, VA508AccessibilityManager, OR2006Compatibility, uConst;

type
  TAccessibilityAction = (aaColorConversion, aaTitleBarHeightAdjustment,
                          aaFixTabStopArrowNavigationBug);
  TAccessibilityActions = set of TAccessibilityAction;

type
  TfrmBase508Form = class(TORForm, IORKeepBounds)
    amgrMain: TVA508AccessibilityManager;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FKeepBounds: boolean;
    FKeptBounds: TRect;
    HelpClicked: boolean;
    OldCursor: TCursor;
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
    procedure WMNCLBUTTONDOWN(var Msg: TWMNCLButtonDown) ; message WM_NCLBUTTONDOWN;
    procedure WMNCLBUTTONUP(var Msg: TWMNCLButtonUp) ; message WM_NCLBUTTONUP;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    function DoOnHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
  protected
    procedure Activate; override;
    procedure Loaded; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure UpdateAccessibilityActions(var Actions: TAccessibilityActions); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property DefaultButton : TButton read FDefaultButton write SetDefaultButton;
    function GetKeepBounds: boolean;
    procedure SetKeepBounds(Value: boolean);
    property KeepBounds: boolean read GetKeepBounds write SetKeepBounds;
  end;

var
  Last508KeyCode: LongInt = 0;

procedure UnfocusableControlEnter(Self, Sender: TObject);

implementation

uses ORSystem, ShellAPI, VA508AccessibilityRouter, VAUtils, uHelpManager,
  uGN_RPCLog, uCore, ORNet;

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

function TfrmBase508Form.GetKeepBounds: boolean;
begin
  Result := FKeepBounds;
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

procedure TfrmBase508Form.SetKeepBounds(Value: boolean);
begin
  FKeepBounds := Value;
  if Value then
    FKeptBounds := BoundsRect;
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

procedure TfrmBase508Form.UpdateAccessibilityActions(var Actions: TAccessibilityActions);
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

procedure TfrmBase508Form.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if WindowState <> wsMaximized then
  begin
    if KeepBounds then
      BoundsRect := FKeptBounds;
    if not assigned(parent) then
      ForceInsideWorkArea(Self);
    KeepBounds := False;
  end;
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
  HelpClicked := False;
  OldCursor := crDefault;
  if not assigned(Parent) then
    AutoScroll := True;
  FActions := [aaColorConversion, aaTitleBarHeightAdjustment, aaFixTabStopArrowNavigationBug];
  UpdateAccessibilityActions(FActions);
  if aaColorConversion in FActions then
    UpdateColorsFor508Compliance(Self);

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

function TfrmBase508Form.DoOnHelp(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
var
  context: THelpContext;
  current: TControl;
begin
  CallHelp := False;

  if assigned(Screen.ActiveControl) then begin
    current := Screen.ActiveControl;
    if (Data = 0) then begin
      while (current.HelpContext = 0) and (assigned(current.Parent)) do current := current.Parent;
      context := current.HelpContext;
    end else begin
      context := Data;
    end;
    Result := FormHelp(Command, context, CallHelp);
  end else begin
    Result := Application.OnHelp(Command, Data, CallHelp);
  end;
end;

function TfrmBase508Form.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
  Result := THelpManager.GetInstance.ExecHelp(Command, Data, CallHelp);
end;

procedure TfrmBase508Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CallHelp: boolean;
begin
  if (Key = VK_RETURN) and (ssCtrl in Shift) then begin
    ClickDefaultButton;
    Key := 0;
  end else if (Key = VK_F1) then begin
    if assigned(ActiveControl) then
      DoOnHelp(1, ActiveControl.HelpContext, CallHelp)
    else
      DoOnHelp(1, Self.HelpContext, CallHelp);
    Key := 0
  end
  // RPCLog modification ------------------------------------------------ begin
  else if (Key = VK_F2) and (ssCtrl in Shift) then
  begin
    Key := 0;
    if User.HasKey('XUPROGMODE') or (ShowRPCList = True) then
      ShowBroker;
  end
  else if (Key = VK_F3) and (ssCtrl in Shift) then
  begin
    AddFlag('',self.Caption + ' (' + self.Name + ')');
    Key := 0;
  end
  else if (Key = VK_F4) and (ssCtrl in Shift) then
  begin
    RPCLogPrev;
    Key := 0;
  end
  else if (Key = VK_F5) and (ssCtrl in Shift) then
  begin
    RPCLogNext;
    Key := 0;
{$IFDEF DEBUG}// VISTAOR-23966
  end
  else if (Key = VK_F6) and (ssCtrl in Shift) then
  begin
    Key := 0;
    ShowMessage('F7 - RPCBrokerV.Connected := not RPCBrokerV.Connected' + #13#10 +
//      'F8 - CallVistA(''XWB IM HERE'',[])' + #13#10 +
      'F8 - Close main form' + #13#10 +
      'F9 - Application.Terminate' + #13#10 +
      'F10 - Disconnect and Terminate)');
  end
  else if (Key = VK_F7) and (ssCtrl in Shift) then
  begin
    Key := 0;
    RPCBrokerV.Connected := not RPCBrokerV.Connected;
  end
  else if (Key = VK_F8) and (ssCtrl in Shift) then
  begin
    Key := 0;
//    RPCBrokerV.Param.Clear;
//    RPCBrokerV.RemoteProcedure := 'XWB IM HERE';
//    RPCBrokerV.Call;
    postMessage(Application.MainForm.Handle, WM_CLOSE,0,0);
  end
  else if (Key = VK_F9) and (ssCtrl in Shift) then
  begin
    Key := 0;
    Application.Terminate;
  end
  else if (Key = VK_F10) and (ssCtrl in Shift) then
  begin
    Key := 0;
    RPCBrokerV.Connected := False;
    SendMessage(Application.MainForm.Handle,WM_CLOSE,0,0);
{$ENDIF}
  end;
  // RPCLog modification -------------------------------------------------- end
end;

{=============================================================================================}
{  These two message handlers intercept the help button, and redirect it to the html system.  }
{=============================================================================================}
procedure TfrmBase508Form.WMNCLBUTTONDOWN(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
    Msg.Result := 0 // "eat" the message
  else
    inherited;
end;

procedure TfrmBase508Form.WMNCLBUTTONUP(var Msg: TWMNCLButtonUp);
var
  CallHelp: boolean;
  wc: TWinControl;
begin
  if Msg.HitTest = HTHELP then begin
    Msg.Result := 0;
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHelp;
    if HelpClicked then begin
      wc := FindVCLWindow(Mouse.CursorPos); // find the control under the cursor.
      if assigned(wc) then begin
        while (wc.HelpContext = 0) and (assigned(wc.Parent)) do wc := wc.Parent;
        FormHelp(1, wc.HelpContext, CallHelp);
      end else
        FormHelp(1, Self.HelpContext, CallHelp);
    end else begin
      Screen.Cursor := OldCursor;
    end;
    HelpClicked := not HelpClicked;
  end else
    inherited;
end;

// RPCLog modification -------------------------------------------------- begin

procedure TfrmBase508Form.FormActivate(Sender: TObject);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form Activate: '+ self.Name,RPCLog_OnActivate+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormShow(Sender: TObject);
begin
  inherited;
  if aaTitleBarHeightAdjustment in FActions then
  begin
    PostMessage(Handle, UM_508, MSG_508_CODE_TITLE_BAR, 0);
    exclude(FActions, aaTitleBarHeightAdjustment);
  end;
  if RPCLog_TrackForms then
    AddLogLine('Form Show: '+ self.Name,RPCLog_OnActivate+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form Close: '+ self.Name,RPCLog_OnClose+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormCreate(Sender: TObject);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form Create: '+ self.Name,RPCLog_OnCreate+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormDeactivate(Sender: TObject);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form DeActivate: '+ self.Name,RPCLog_OnDeActivate+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormDestroy(Sender: TObject);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form Destroy: '+ self.Name,RPCLog_OnDestroy+self.Caption + ' ('+self.Name+')');
end;

procedure TfrmBase508Form.FormHide(Sender: TObject);
begin
  inherited;
  if RPCLog_TrackForms then
    AddLogLine('Form Hide: '+ self.Name,RPCLog_OnHide+self.Caption + ' ('+self.Name+')');
end;
// RPCLog modification ----------------------------------------------------- end

initialization
  KeyMonitorHook   := SetWindowsHookEx(WH_KEYBOARD, KeyMonitorProc,   0, GetCurrentThreadID);
  MouseMonitorHook := SetWindowsHookEx(WH_MOUSE,    MouseMonitorProc, 0, GetCurrentThreadID);

  SpecifyFormIsNotADialog(TfrmBase508Form);
  SpecifyFormIsNotADialog(Tfrm2006Compatibility);

finalization
  UnhookWindowsHookEx(KeyMonitorHook);
  UnhookWindowsHookEx(MouseMonitorHook);

end.

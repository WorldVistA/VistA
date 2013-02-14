unit uFormMonitor;

interface

uses
  SysUtils, Forms, Classes, Windows, Messages, ExtCtrls, Contnrs, DateUtils;

procedure SetFormMonitoring(activate: boolean);

procedure MarkFormAsStayOnTop(Form: TForm; IsStayOnTop: Boolean);

// Some forms have display tasks when first displayed that are messed up by the
// form monitor - such as making a combo box automatically drop down.  These forms
// should call FormMonitorBringToFrontEvent, which will be called when the
// form monitor calls the form's BringToFront method.  The Seconds parameter is the
// amount of time that must transpire before the form monitor will call
// BringToFront again, unless another form has received focus since the event was called.

procedure FormMonitorBringToFrontEvent(Form: TForm; AEvent: TNotifyEvent; Seconds: integer = 3);

implementation

const
  TIMER_INTERVAL = 8;
  TIMER_CHECKS_BEFORE_TIMEOUT = 1000 div TIMER_INTERVAL;

type
  TFormMonitor = class
  private
    FOldActiveFormChangeEvent: TNotifyEvent;
    FOldActivateEvent: TNotifyEvent;
    FOldRestore: TNotifyEvent;
    FModifyingZOrder: boolean;
    FModifyPending: boolean;
    FActiveForm: TForm;
    FZOrderHandles: TList;
    FLastModal: boolean;
    fTopOnList: TList;
    fTopOffList: TList;
    fTimer: TTimer;
    FTimerCount: integer;
    FMenuPending: boolean;
    FWindowsHook: HHOOK;
    FRunning: boolean;
    FFormEvents: TObjectList;
    FLastActiveFormHandle: HWND;
    procedure ManageForms;
    function FormValid(form: TForm): boolean;
    function HandleValid(handle: HWND): boolean;
    procedure MoveOnTop(Handle: HWND);
    procedure MoveOffTop(Handle: HWND);
    procedure Normalize(Handle: HWND; Yes: boolean);
    procedure NormalizeReset;
    function IsNormalized(Handle: HWND): boolean;
    function GetActiveFormHandle: HWND;
    procedure StartZOrdering;
    function SystemRunning: boolean;
    function ModalDelphiForm: boolean;
    function IsTopMost(Handle: HWND): boolean;
  public
    procedure Start;
    procedure Stop;
    procedure Timer(Sender: TObject);
    procedure Activate(Sender: TObject);
    procedure ActiveFormChange(Sender: TObject);
    procedure Restore(Sender: TObject);
  end;

  TFormEvent = class(TObject)
  private
    FForm: TForm;
    FEvent: TNotifyEvent;
    FSeconds: integer;
    FTimeStamp: TDateTime;
  end;

var
  FormMonitor: TFormMonitor = nil;

type
  HDisableGhostProc = procedure(); stdcall;

const
  NORMALIZED    = $00000001;
  UN_NORMALIZED = $FFFFFFFE;
  STAY_ON_TOP   = $00000002;
  NORMAL_FORM   = $FFFFFFFD;


procedure DisableGhosting;
const
  DisableProc = 'DisableProcessWindowsGhosting';
  UserDLL = 'user32.dll';

var
  DisableGhostProc: HDisableGhostProc;
  User32Handle: THandle;

begin
  User32Handle := LoadLibrary(PChar(UserDLL));
  try
    if User32Handle <= HINSTANCE_ERROR then
      User32Handle := 0
    else
    begin
      DisableGhostProc := GetProcAddress(User32Handle, PChar(DisableProc));
      if(assigned(DisableGhostProc)) then
      begin
        DisableGhostProc;
      end;
    end;
  finally
    if(User32Handle <> 0) then
      FreeLibrary(User32Handle);
  end;
end;

procedure SetFormMonitoring(activate: boolean);
var
  running: boolean;
begin
  running := assigned(FormMonitor);
  if(activate <> running) then
  begin
    if(running) then
    begin
      FormMonitor.Stop;
      FormMonitor.Free;
      FormMonitor := nil;
    end
    else
    begin
      FormMonitor := TFormMonitor.Create;
      FormMonitor.Start;
    end;
  end;
end;

procedure MarkFormAsStayOnTop(Form: TForm; IsStayOnTop: Boolean);
var
  Data: Longint;
begin
  Data := GetWindowLong(Form.Handle, GWL_USERDATA);
  if(IsStayOnTop) then
  begin
    Data := Data or STAY_ON_TOP;
    SetWindowPos(Form.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
  end
  else
  begin
    Data := Data and NORMAL_FORM;
    SetWindowPos(Form.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
  end;
  SetWindowLong(Form.Handle, GWL_USERDATA, Data);
end;

function FindFormEventIndex(Form: TForm): integer;
var
  i: integer;
  event: TFormEvent;
begin
  Result := -1;
  for i := 0 to FormMonitor.FFormEvents.Count-1 do
  begin
    event := TFormEvent(FormMonitor.FFormEvents[i]);
    if(event.FForm = Form) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function FindFormEvent(Form: TForm): TFormEvent;
var
  idx: integer;
begin
  idx := FindFormEventIndex(Form);
  if(idx < 0) then
    Result := nil
  else
    Result := TFormEvent(FormMonitor.FFormEvents[idx]);
end;

procedure FormMonitorBringToFrontEvent(Form: TForm; AEvent: TNotifyEvent; Seconds: integer);
var
  event: TFormEvent;
  idx: integer;
begin
  event := FindFormEvent(Form);
  if(assigned(AEvent)) then
  begin
    if(event = nil) then
    begin
      event := TFormEvent.Create;
      event.FForm := Form;
      event.FTimeStamp := 0;
      FormMonitor.FFormEvents.Add(event);
    end;
    event.FEvent := AEvent;
    event.FSeconds := Seconds;
  end
  else
  if(event <> nil) then
  begin
    idx := FindFormEventIndex(Form);
    FormMonitor.FFormEvents.Delete(idx);
//    event.Free; - TObjectList frees object automatically
  end;
end;

function IsFormStayOnTop(form: TForm): boolean;
begin
  Result := (form.FormStyle = fsStayOnTop);
  if(not Result) then
    Result := ((GetWindowLong(Form.Handle, GWL_USERDATA) and STAY_ON_TOP) <> 0);
end;

{ TFormMonitor }

procedure TFormMonitor.Activate(Sender: TObject);
begin
  if(Assigned(FOldActivateEvent)) then
    FOldActivateEvent(Sender);
  NormalizeReset;
  StartZOrdering;
end;

procedure TFormMonitor.ActiveFormChange(Sender: TObject);
begin
  if(Assigned(FOldActiveFormChangeEvent)) then
    FOldActiveFormChangeEvent(Sender);
  StartZOrdering;
end;

procedure TFormMonitor.Restore(Sender: TObject);
begin
  if(Assigned(FOldRestore)) then
    FOldRestore(Sender);
  NormalizeReset;
  StartZOrdering;
end;

function TFormMonitor.FormValid(form: TForm): boolean;
begin
  Result := assigned(form);
  if Result then
    Result := (form.Parent = nil) and (form.ParentWindow = 0) and form.Visible and (form.Handle <> 0);
end;

function TFormMonitor.HandleValid(handle: HWND): boolean;
begin
  Result := (handle <> 0);
  if(Result) then
    Result := IsWindow(handle) and IsWindowVisible(handle) and isWindowEnabled(handle);
end;

function FindWindowZOrder(Window: HWnd; Data: Longint): Bool; stdcall;
begin
  if(IsWindow(Window) and IsWindowVisible(Window)) then
    FormMonitor.FZOrderHandles.Add(Pointer(Window));
  Result := True;
end;

procedure TFormMonitor.ManageForms;
var
  i, j: integer;
  form: TForm;
  formHandle, activeHandle: HWND;
  modal, doCall: boolean;
  event: TFormEvent;

begin
  if(FModifyingZOrder) then exit;
  if(not SystemRunning) then exit;
  FModifyingZOrder := TRUE;
  try
    activeHandle := GetActiveFormHandle;
    if (activeHandle <> 0) and (not assigned(FactiveForm)) then
        modal := true    //assumes DLL created forms are modal
      else
      modal := ModalDelphiForm;
    FZOrderHandles.Clear;
    fTopOnList.Clear;
    fTopOffList.Clear;

    EnumThreadWindows(GetCurrentThreadID, @FindWindowZOrder, 0);
    for i := 0 to FZOrderHandles.Count-1 do
    begin
      formHandle := HWND(FZOrderHandles[i]);
      for j := 0 to Screen.FormCount-1 do
      begin
        form := Screen.Forms[j];
        if(form.Handle = formHandle) then
        begin
          if formValid(form) and (form.Handle <> activeHandle) and IsFormStayOnTop(form) then
          begin
            if(modal and (not IsWindowEnabled(form.Handle))) then
              fTopOffList.Add(Pointer(form.Handle))
            else
              fTopOnList.Add(Pointer(form.Handle));
          end;
          break;
        end;
      end;
    end;
    for i := fTopOffList.Count-1 downto 0 do
      MoveOffTop(HWND(fTopOffList[i]));
    for i := fTopOnList.Count-1 downto 0 do
      MoveOnTop(HWND(fTopOnList[i]));

    if(activeHandle <> 0) then
    begin
      if(assigned(FActiveForm)) then
      begin
        event := FindFormEvent(FActiveForm);
        doCall := (event = nil);
        if(not doCall) then
          doCall := (activeHandle <> FLastActiveFormHandle);
        if(not doCall) then
          doCall := SecondsBetween(Now, event.FTimeStamp) > event.FSeconds;
        if(doCall) then
        begin
          if IsFormStayOnTop(FActiveForm) then
          begin
            SetWindowPos(activeHandle, HWND_TOPMOST, 0, 0, 0, 0,
                SWP_NOMOVE or SWP_NOSIZE);
            Normalize(activeHandle, FALSE);
          end;
          FActiveForm.BringToFront;
          if(event <> nil) then
          begin
            if(FormValid(event.FForm)) then
            begin
              event.FEvent(FActiveForm);
              event.FTimeStamp := now;
            end;
          end;
        end;
      end
      else
      begin
        if(activeHandle <> 0) then
        begin
          SetFocus(activeHandle);
          BringWindowToTop(activeHandle);
          if(IsTopMost(activeHandle)) then
            SetWindowPos(activeHandle, HWND_TOPMOST, 0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE);
        end;
      end;
    end;
    FLastActiveFormHandle := activeHandle;
  finally
    FModifyingZOrder := FALSE;
  end;
end;

function CallWndHook(Code: Integer; WParam: wParam; Msg: PCWPStruct): Longint; stdcall;
begin
  case Msg.message of
    WM_INITMENU, WM_INITMENUPOPUP, WM_ENTERMENULOOP:
      FormMonitor.FMenuPending := TRUE;
    WM_MENUSELECT, WM_EXITMENULOOP:
      FormMonitor.FMenuPending := FALSE;
  end;
  Result := CallNextHookEx(FormMonitor.FWindowsHook, Code, WParam, Longint(Msg));
end;

procedure TFormMonitor.Start;
begin
  if(FRunning) then exit;
  FRunning := TRUE;
  FTimer := TTimer.Create(Application);
  fTimer.Enabled := FALSE;
  FTimer.OnTimer := Timer;
  FTimer.Interval := TIMER_INTERVAL;
  FMenuPending := FALSE;
  FLastActiveFormHandle := 0;

  FZOrderHandles := TList.Create;
  fTopOnList := TList.Create;
  fTopOffList := TList.Create;
  FFormEvents := TObjectList.Create;
  FModifyingZOrder := false;
  FLastModal := false;
  FOldActiveFormChangeEvent := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange := ActiveFormChange;
  FOldActivateEvent := Application.OnActivate;
  Application.OnActivate := Activate;
  FOldRestore := Application.OnRestore;
  Application.OnRestore := Restore;
  FWindowsHook := SetWindowsHookEx(WH_CALLWNDPROC, @CallWndHook, 0, GetCurrentThreadID)
end;

procedure TFormMonitor.Stop;
begin
  if(not FRunning) then exit;
  FRunning := FALSE;
  if FWindowsHook <> 0 then
  begin
    UnHookWindowsHookEx(FWindowsHook);
    FWindowsHook := 0;
  end;
  Screen.OnActiveFormChange := FOldActiveFormChangeEvent;
  Application.OnActivate := FOldActivateEvent;
  Application.OnRestore := FOldRestore;

  FZOrderHandles.Free;
  fTopOnList.Free;
  fTopOffList.Free;
  FFormEvents.Free;
  fTimer.Enabled := FALSE;
  fTimer.Free;
end;

procedure TFormMonitor.MoveOffTop(Handle: HWND);
begin
  if(not IsNormalized(Handle)) then
  begin
    SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER);
    Normalize(Handle, TRUE);
  end;
end;

procedure TFormMonitor.MoveOnTop(Handle: HWND);
begin
  if(isNormalized(Handle)) then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOOWNERZORDER);
    Normalize(Handle, FALSE);
  end;
end;

procedure TFormMonitor.Normalize(Handle: HWND; Yes: boolean);
var
  Data: Longint;
begin
  Data := GetWindowLong(Handle, GWL_USERDATA);
  if(yes) then
    Data := Data or NORMALIZED
  else
    Data := Data and UN_NORMALIZED;
  SetWindowLong(Handle, GWL_USERDATA, Data);
end;

function TFormMonitor.IsNormalized(Handle: HWND): boolean;
begin
  Result := ((GetWindowLong(Handle, GWL_USERDATA) and NORMALIZED) <> 0);
end;

function TFormMonitor.IsTopMost(Handle: HWND): boolean;
begin
  Result := ((GetWindowLong(Handle, GWL_EXSTYLE) and WS_EX_TOPMOST) <> 0);
end;

function FindWindows(Window: HWnd; Data: Longint): Bool; stdcall;
begin
  FormMonitor.Normalize(Window, FALSE);
  Result := True;
end;

procedure TFormMonitor.NormalizeReset;
begin
  EnumThreadWindows(GetCurrentThreadID, @FindWindows, 0);
end;

var
  uActiveWindowHandle: HWND;
  uActiveWindowCount: integer;

function IsHandleOK(Handle: HWND): boolean;
var
  i: integer;
  
begin
  Result := FALSE;
  if(not formMonitor.HandleValid(Handle)) or (Handle = Application.Handle) then exit;
  for i := 0 to Screen.FormCount-1 do
  begin
    if(Handle = Screen.Forms[i].Handle) then exit;
  end;
  Result := TRUE;
end;

function FindActiveWindow(Window: HWnd; Data: Longint): Bool; stdcall;
begin
  Result := True;
  if(IsHandleOK(Window)) then 
  begin
    inc(uActiveWindowCount);
    if(uActiveWindowCount = 1) then
      uActiveWindowHandle := Window
    else
      if(uActiveWindowCount > 1) then
        Result := false;
  end;
end;

function TFormMonitor.GetActiveFormHandle: HWND;
var
  i: integer;
  form: TForm;

begin
  FActiveForm := Screen.ActiveForm;
  if(assigned(FActiveForm)) then
    Result := FActiveForm.Handle
  else
    Result := 0;
  if(FormValid(FActiveForm) and IsWindowEnabled(FActiveForm.Handle)) then
    exit;
  for i := 0 to Screen.FormCount-1 do
  begin
    form := Screen.Forms[i];
    if(form.Handle = Result) then
    begin
      if FormValid(form) and IsWindowEnabled(form.Handle) then
      begin
        FActiveForm := form;
        Result := form.Handle;
        exit;
      end;
    end;
  end;
  FActiveForm := nil;
  Result := GetActiveWindow;
  if(IsHandleOK(Result)) then exit;
  uActiveWindowHandle := 0;
  uActiveWindowCount := 0;
  EnumThreadWindows(GetCurrentThreadID, @FindActiveWindow, 0);
  if(uActiveWindowCount = 1) then
  begin
    Result := uActiveWindowHandle;
  end;
end;


procedure TFormMonitor.StartZOrdering;
begin
  if(FModifyPending) then exit;
  if(SystemRunning) then
  begin
    FModifyPending := TRUE;
    FTimerCount := 0;
    FTimer.Enabled := TRUE;
  end;
end;

function TFormMonitor.SystemRunning: boolean;
begin
  Result := assigned(Application.MainForm) and
            (Application.MainForm.Handle <> 0) and
            IsWindowVisible(Application.MainForm.Handle);
end;


function TFormMonitor.ModalDelphiForm: boolean;
var
  i: integer;
  form: TForm;
begin
  for i := 0 to Screen.FormCount-1 do
  begin
    form := screen.Forms[i];
    if(FormValid(form) and (fsModal in form.FormState)) then
    begin
      Result := TRUE;
      exit;
    end;
  end;
  Result := FALSE;
end;

procedure TFormMonitor.Timer(Sender: TObject);
var
  NoMenu: boolean;
begin
  inc(FTimerCount);
  if(FTimerCount > TIMER_CHECKS_BEFORE_TIMEOUT) then
  begin
    FTimer.Enabled := FALSE;
    FMenuPending := FALSE;
    FModifyPending := FALSE;
    exit;
  end;
  if(FTimerCount <> 1) then exit;
  FTimer.Enabled := FALSE;
  NoMenu := not FMenuPending;
  FMenuPending := FALSE;
  if(NoMenu and SystemRunning) then
    ManageForms;
  FModifyPending := FALSE;
end;

initialization
  DisableGhosting;

finalization

end.

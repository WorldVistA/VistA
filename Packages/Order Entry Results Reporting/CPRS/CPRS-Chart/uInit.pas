unit uInit;

interface

uses
  Forms, Windows, Messages, SysUtils, ExtCtrls;

type
  TCPRSTimeoutTimerCondition = function: boolean of object;
  TCPRSTimeoutTimerAction = procedure of object;

procedure InitTimeOut(AUserCondition: TCPRSTimeoutTimerCondition;
                      AUserAction: TCPRSTimeoutTimerAction);
procedure UpdateTimeOutInterval(NewTime: Cardinal);
function TimedOut: Boolean;
function TimingOut: Boolean;
procedure ShutDownTimeOut;
procedure SuspendTimeout;
procedure ResumeTimeout;

implementation

uses
  fTimeout;

type
  TCPRSTimeoutTimer = class(TTimer)
  private
    FIsTimeOutFormVisible: Boolean;
    FHooked: boolean;
    FUserCondition: TCPRSTimeoutTimerCondition;
    FUserAction: TCPRSTimeoutTimerAction;
    uTimeoutInterval: Cardinal;
    uTimeoutKeyHandle, uTimeoutMouseHandle: HHOOK;
    function PromptForTimeout: Boolean;
  protected
    procedure ResetTimeout;
    procedure timTimeoutTimer(Sender: TObject);
  end;

var
  timTimeout: TCPRSTimeoutTimer = nil;
  FTimedOut: boolean = False;
  FTimingOut: boolean = False;
  uSuspended: boolean = False;

function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;

{** Timeout Functions **}

function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every keyboard event that occurs while running CPRS }
begin
  if lParam shr 31 = 1 then timTimeout.ResetTimeout;                          // on KeyUp only
  Result := CallNextHookEx(timTimeout.uTimeoutKeyHandle, Code, wParam, lParam);
end;

function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every mouse event that occurs while running CPRS }
begin
  if (Code >= 0) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST)
    then timTimeout.ResetTimeout;                                             // all click events
  Result := CallNextHookEx(timTimeout.uTimeoutMouseHandle, Code, wParam, lParam);
end;

procedure InitTimeOut(AUserCondition: TCPRSTimeoutTimerCondition;
                      AUserAction: TCPRSTimeoutTimerAction);
begin
  if(not assigned(timTimeout)) then
  begin
    timTimeOut := TCPRSTimeoutTimer.Create(nil);
    with timTimeOut do
    begin
      OnTimer := timTimeoutTimer;
      FUserCondition := AUserCondition;
      FUserAction := AUserAction;
      uTimeoutInterval    := 120000;  // initially 2 minutes, will get DTIME after signon
      uTimeoutKeyHandle   := SetWindowsHookEx(WH_KEYBOARD, TimeoutKeyHook,   0, GetCurrentThreadID);
      uTimeoutMouseHandle := SetWindowsHookEx(WH_MOUSE,    TimeoutMouseHook, 0, GetCurrentThreadID);
      FHooked := TRUE;
      Interval := uTimeoutInterval;
      Enabled  := True;
    end;
  end;
end;

procedure UpdateTimeOutInterval(NewTime: Cardinal);
begin
  if(assigned(timTimeout)) then
  begin
    with timTimeout do
    begin
      uTimeoutInterval := NewTime;
      Interval := uTimeoutInterval;
      Enabled  := True;
    end;
  end;
end;

function TimedOut: Boolean;
begin
  Result := FTimedOut;
end;

function TimingOut: Boolean;
begin
  Result := FTimingOut or FTimedOut;
end;

procedure ShutDownTimeOut;
begin
  if(assigned(timTimeout)) then
  begin
    with timTimeout do
    begin
      Enabled := False;
      if(FHooked) then
      begin
        UnhookWindowsHookEx(uTimeoutKeyHandle);
        UnhookWindowsHookEx(uTimeoutMouseHandle);
        FHooked := FALSE;
      end;
    end;
    FreeAndNil(timTimeout);
  end;
end;

{ TCPRSTimeoutTime }

function TCPRSTimeoutTimer.PromptForTimeout: Boolean;
begin
  FIsTimeOutFormVisible := True;
  try
    Result := AllowTimeout; // This shows a modal timeout form
  finally
    FIsTimeOutFormVisible := False;
  end;
end;

procedure TCPRSTimeoutTimer.ResetTimeout;
{ this restarts the timer whenever there is a keyboard or mouse event,
  as long as the timeout form is not already visible }
begin
  if FIsTimeOutFormVisible then Exit;

  Enabled  := False;
  Interval := uTimeoutInterval;
  Enabled  := True;
end;

procedure TCPRSTimeoutTimer.timTimeoutTimer(Sender: TObject);
{ when the timer expires, the application is closed after warning the user }
begin
  if uSuspended then
  begin
    ResetTimeout;
    exit;
  end;
  Enabled := False;
  FTimingOut := True;
  try
    if(assigned(FUserCondition)) then
      FTimedOut := FUserCondition or PromptForTimeout
    else
      FTimedOut := PromptForTimeout;
    if FTimedOut then
    begin
      if(assigned(FUserAction)) then FUserAction;
    end
    else
      Enabled := True;
  finally
    FTimingOut := False;
  end;
end;

procedure SuspendTimeout;
begin
  uSuspended := True;
end;

procedure ResumeTimeout;
begin
  if assigned(timTimeout) then
    timTimeout.ResetTimeout;
  uSuspended := False;
end;

initialization

finalization
  ShutDownTimeOut;

end.

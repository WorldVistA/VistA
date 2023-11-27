unit UResponsiveGUI;

///////////////////////////////////////////////////////////////////////////////
/// TResponsiveGUI re-routes calls to Application.ProcessMessages to only
///  handle the part of the Windows message queue that does not come from user
///  input.
///
/// TResponsiveGUI.Enabled: if True, calls are rerouted. If False they are not.
/// TResponsiveGUI.Sleep: if True, calls are rerouted. If False they are not.
/// Parameter AAllowUserInput: if available on a method, this allows for
///  bypassing the reroute. I.e. revert back to a regular
///  Application.ProcessMessages.
///
/// IMPORTANT: When changing caption of a component suct as a TButton or a
///  TLabel, TResponsiveGUI message handling will not correctly update those
///  changes. This is because a message gets posted that is interpreted by
///  Windows as a user message.
/// The solution is to call "Update" on that component (I.e. TButton.Update),
///  which forces immediate redrawing. In fact, if a redraw is why an
///  Application.ProcessMessages is called, maybe that entire call can be
///  replaced with a TForm.Update, or TPanel.Update, instead of a
///  TResposiveGUI.ProcessMessages.
///////////////////////////////////////////////////////////////////////////////
interface

uses
  Winapi.Windows;

const
  PM_QS_ALL = 0;
  PM_QS_INPUT = QS_INPUT shl 16;
  PM_QS_PAINT = QS_PAINT shl 16;
  PM_QS_POSTMESSAGE = (QS_POSTMESSAGE or QS_HOTKEY or QS_TIMER) shl 16;
  PM_QS_SENDMESSAGE = QS_SENDMESSAGE shl 16;
  PM_QS_NOT_INPUT = PM_QS_PAINT or PM_QS_POSTMESSAGE or PM_QS_SENDMESSAGE;

type
  TResponsiveGUI = class(TObject)
  strict private
    class var FEnabled: Boolean;
  public
    class procedure ProcessMessages(AAllowUserInput: Boolean = False); overload;
    class procedure ProcessMessages(AStop: TDateTime;
      AAllowUserInput: Boolean = False); overload;
    class procedure ProcessMessages(AStop: TDateTime;
      AFilter: Cardinal); overload;
    class procedure Sleep(AMilliseconds: Cardinal);
    class property Enabled: Boolean read FEnabled write FEnabled;
  end;

implementation

uses
  Vcl.Dialogs,
  Vcl.Forms,
  Winapi.Messages,
  System.SysUtils,
  System.DateUtils;

class procedure TResponsiveGUI.ProcessMessages(
  AAllowUserInput: Boolean = False);
begin
  TResponsiveGUI.ProcessMessages(0, AAllowUserInput);
end;

class procedure TResponsiveGUI.ProcessMessages(AStop: TDateTime;
  AAllowUserInput: Boolean = False);
begin
  if AAllowUserInput then
    TResponsiveGUI.ProcessMessages(AStop, PM_QS_ALL)
  else
    TResponsiveGUI.ProcessMessages(AStop, PM_QS_NOT_INPUT);
end;

type
  TApplicationHack = class(TApplication);

class procedure TResponsiveGUI.ProcessMessages(AStop: TDateTime;
  AFilter: Cardinal);
// Processes just the paint messages on the message queue.
// AStop: the system time after which this procedure is no longer allowed to
//   run. 0 means no stop time
// AFilter: pass in one or more (or together) of the PM_QS constants defined
//   above. See PeekMessage documentation for meaning

  function PeekMsg(var AMsg: TMsg; AFilterMin, AFilterMax,
    ARemoveMsg: Cardinal): Boolean;
  begin
    Result :=
      Winapi.Windows.PeekMessage(AMsg, 0, AFilterMin, AFilterMax, ARemoveMsg);
  end;

  procedure DispatchMsg(AMsg: TMsg; AFilterMin, AFilterMax,
    ARemoveMsg: Cardinal);
  var
    AHandled: Boolean;
    AIsUnicode, AMsgExists: Boolean;
  begin
    AIsUnicode := (AMsg.hwnd = 0) or IsWindowUnicode(AMsg.hwnd);
    if AIsUnicode then
      AMsgExists := Winapi.Windows.PeekMessageW(AMsg, 0, 0, 0, ARemoveMsg)
    else
      AMsgExists := Winapi.Windows.PeekMessageA(AMsg, 0, 0, 0, ARemoveMsg);
    if not AMsgExists then
      Exit;
    AHandled := False;
    if Assigned(Application.OnMessage) then
      Application.OnMessage(AMsg, AHandled);
    if not(AMsg.message = WM_HOTKEY) and
      not TApplicationHack(Application).IsPreProcessMessage(AMsg) and
      not TApplicationHack(Application).IsHintMsg(AMsg) and
      not AHandled and
      not TApplicationHack(Application).IsMDIMsg(AMsg) and
      not TApplicationHack(Application).IsKeyMsg(AMsg) and
      not TApplicationHack(Application).IsDlgMsg(AMsg) then
    begin
      Winapi.Windows.TranslateMessage(AMsg);
      if AIsUnicode then
        Winapi.Windows.DispatchMessageW(AMsg)
      else
        Winapi.Windows.DispatchMessageA(AMsg);
    end;
  end;

var
  AMsg: TMsg;
  AHasDispatchedMsg: Boolean;
begin
  if not FEnabled then
  begin
    Application.ProcessMessages;
    Exit;
  end;

  if AFilter = PM_QS_ALL then
  begin
    Application.ProcessMessages;
    Exit;
  end;

  AHasDispatchedMsg := False;

  while Winapi.Windows.PeekMessage(AMsg, 0, 0, 0, PM_NOREMOVE or AFilter) do
  begin
    if AMsg.message = WM_QUIT then
    begin
      Application.ProcessMessages;
      Break;
    end else begin
      DispatchMsg(AMsg, 0, 0, PM_REMOVE or AFilter);
    end;
    AHasDispatchedMsg := True;
    if (AStop > 0) and (Now > AStop) then
      Break;
  end;

  if AHasDispatchedMsg and (AStop > 0) and (Now > AStop) then Exit;
  while PeekMsg(AMsg, WM_TIMER, WM_TIMER, PM_NOREMOVE) do
  begin
    DispatchMsg(AMsg, WM_TIMER, WM_TIMER, PM_REMOVE);
    AHasDispatchedMsg := True;
    if (AStop > 0) and (Now > AStop) then
      Break;
  end;

  if AHasDispatchedMsg and (AStop > 0) and (Now > AStop) then Exit;
  while PeekMsg(AMsg, WM_PAINT, WM_PAINT, PM_NOREMOVE) do
  begin
    DispatchMsg(AMsg, WM_PAINT, WM_PAINT, PM_REMOVE);
    // AHasDispatchedMsg := True;
    if (AStop > 0) and (Now > AStop) then
      Break;
  end;

end;

class procedure TResponsiveGUI.Sleep(AMilliseconds: Cardinal);
const
  ASleepInterval = 30;
var
  AStop: TDateTime;
begin
  if not FEnabled then
  begin
    System.SysUtils.Sleep(AMilliSeconds);
  end else begin
    AStop := IncMilliSecond(Now, AMilliseconds);
    while (AStop > Now) and (MillisecondsBetween(AStop, Now) >
      ASleepInterval) do
    begin
      System.SysUtils.Sleep(ASleepInterval);
      ProcessMessages(AStop, PM_QS_PAINT);
    end;
    if (AStop > Now) then
      AMilliseconds := MillisecondsBetween(AStop, Now)
    else
      AMilliseconds := 0;
    System.SysUtils.Sleep(AMilliseconds);
  end;
end;

end.

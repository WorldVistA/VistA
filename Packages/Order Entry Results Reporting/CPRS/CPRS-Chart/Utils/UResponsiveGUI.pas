unit UResponsiveGUI;

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
    class procedure ProcessMessages; overload;
    class procedure ProcessMessages(AStop: TDateTime;
      AFilter: Cardinal = PM_QS_NOT_INPUT); overload;
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

class procedure TResponsiveGUI.ProcessMessages;
begin
  ProcessMessages(0, PM_QS_NOT_INPUT);
end;

type
  TApplicationHack = class(TApplication);

class procedure TResponsiveGUI.ProcessMessages(AStop: TDateTime;
  AFilter: Cardinal = PM_QS_NOT_INPUT);
// Processes just the paint messages on the message queue.
// AStop: the system time after which this procedure is no longer allowed to
//   run. 0 means no stop time
// AFilter: pass in one or more (or together) of the PM_QS constants defined
//   above. See PeekMessage documentation for meaning
var
  AMsg: TMsg;
  AHandled: Boolean;
  AIsUnicode, AMsgExists: Boolean;
begin
  if not FEnabled then
  begin
    Application.ProcessMessages;
  end else begin
    if (AStop > 0) and (AStop > Now) then
      Exit;
    while Winapi.Windows.PeekMessage(AMsg, 0, 0, 0, PM_NOREMOVE or AFilter) do
    begin
      if AMsg.message = WM_QUIT then
      begin
        Application.ProcessMessages;
        Break;
      end else begin
        AIsUnicode := (AMsg.hwnd = 0) or IsWindowUnicode(AMsg.hwnd);
        if AIsUnicode then
          AMsgExists := PeekMessageW(AMsg, 0, 0, 0, PM_REMOVE or AFilter)
        else
          AMsgExists := PeekMessageA(AMsg, 0, 0, 0, PM_REMOVE or AFilter);

        if not AMsgExists then Break;
        AHandled := False;
        if Assigned(Application.OnMessage) then
          Application.OnMessage(AMsg, AHandled);
        if not(AMsg.message = WM_HOTKEY) and
          not TApplicationHack(Application).IsPreProcessMessage(AMsg) and
          not TApplicationHack(Application).IsHintMsg(AMsg) and
          not AHandled and not TApplicationHack(Application).IsMDIMsg(AMsg)
          and not TApplicationHack(Application).IsKeyMsg(AMsg) and
          not TApplicationHack(Application).IsDlgMsg(AMsg) then
        begin
          Winapi.Windows.TranslateMessage(AMsg);
          if AIsUnicode then
            Winapi.Windows.DispatchMessageW(AMsg)
          else
            Winapi.Windows.DispatchMessageA(AMsg);
        end;
      end;
      if (AStop > 0) and (Now > AStop) then
        Break;
    end;
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

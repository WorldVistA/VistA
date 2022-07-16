unit fVA508DispatcherHiddenWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TfrmVA508JawsDispatcherHiddenWindow = class(TForm)
    tmrMain: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrMainTimer(Sender: TObject);
  private
    FThreads: TStringList;
  protected
    procedure WndProc(var Msg: TMessage); override;
    procedure UpdateThreadList;
  public
    { Public declarations }
  end;

var
  frmVA508JawsDispatcherHiddenWindow: TfrmVA508JawsDispatcherHiddenWindow;

implementation

uses VAUtils, JAWSCommon;

{$R *.dfm}

procedure TfrmVA508JawsDispatcherHiddenWindow.FormCreate(Sender: TObject);
begin
  ErrorCheckClassName(Self, DISPATCHER_WINDOW_CLASS);
  FThreads := TStringList.Create;
  Caption := DISPATCHER_WINDOW_TITLE;
  UpdateThreadList;
end;

procedure TfrmVA508JawsDispatcherHiddenWindow.FormDestroy(Sender: TObject);
begin
  FThreads.Free;
end;

procedure TfrmVA508JawsDispatcherHiddenWindow.tmrMainTimer(Sender: TObject);
begin
  tmrMain.Enabled := FALSE;
  UpdateThreadList;
  if FThreads.Count < 1 then
    Application.Terminate
  else
    tmrMain.Enabled := TRUE;
end;

function WindowSearchProc(Handle: HWND; var FThreads: TStringList): BOOL; stdcall;
var
  cls: string;
  test: string;
  Thread: DWORD;
  ThreadID: string;

begin
  cls := GetWindowClassName(Handle);
  test := GetWindowTitle(handle);
  if (cls = DLL_MAIN_WINDOW_CLASS) then
  begin
    if (copy(GetWindowTitle(Handle),1,DLL_WINDOW_TITLE_LEN) = DLL_WINDOW_TITLE) then
    begin
      Thread := GetWindowThreadProcessId(Handle, nil);
      ThreadID := FastIntToHex(Thread);
      FThreads.AddObject(ThreadID, TObject(Handle))
    end;
  end;
  Result := TRUE;
end;

procedure TfrmVA508JawsDispatcherHiddenWindow.UpdateThreadList;
begin
  FThreads.Clear;
  EnumWindows(@WindowSearchProc, Integer(@FThreads));
end;

procedure TfrmVA508JawsDispatcherHiddenWindow.WndProc(var Msg: TMessage);
var
  CurrentWindow: HWND;
  Thread: DWORD;
  ThreadID: string;
  idx: integer;

  procedure FindActiveWindow;
  begin
    CurrentWindow := GetForegroundWindow();
    if IsWindow(CurrentWindow) then
    begin
      Thread := GetWindowThreadProcessId(CurrentWindow, nil);
      ThreadID := FastIntToHex(Thread);
      idx := FThreads.IndexOf(ThreadID);
      if idx < 0 then
      begin
        UpdateThreadList;
        idx := FThreads.IndexOf(ThreadID);
      end;
      if idx >= 0 then
      begin
        SendReturnValue(Handle, Integer(FThreads.Objects[idx]));
      end;
    end;
  end;

begin
  if Msg.Msg = MessageID then
  begin
    Msg.Result := 1;
    if assigned(Self) then // JAWS can detect the window before Delphi has finished creating it
    begin
      try
        if Msg.WParam = JAWS_MESSAGE_GET_DLL_WITH_FOCUS then
          FindActiveWindow;
      except
      end;
    end;
  end;
  inherited WndProc(Msg);
end;

end.

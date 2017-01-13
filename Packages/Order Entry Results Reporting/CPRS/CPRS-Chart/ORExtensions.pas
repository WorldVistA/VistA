unit ORExtensions;

interface

uses
  ORCtrls,
  System.Classes,
  Vcl.Clipbrd,
  Vcl.ComCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.Windows,
  TLHelp32,
  System.SysUtils,
  Vcl.Dialogs,
  System.UITypes;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TMemo = class(Vcl.StdCtrls.TMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TRichEdit = class(Vcl.ComCtrls.TRichEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
  end;

  TCaptionEdit = class(ORCtrls.TCaptionEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TCaptionMemo = class(ORCtrls.TCaptionMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

procedure ScrubTheClipboard;

implementation

procedure ScrubTheClipboard;
Type
  tClipInfo = record
    AppName: string;
    AppClass: string;
    AppHwnd: HWND;
    AppPid: Cardinal;
    AppTitle: String;
    ObjectHwnd: HWND;
  end;

const
  ATabWidth = 9;
  Max_Retry = 3;
  Hlp_Msg = 'System Error: %s' + #13#10 +
    'There was a problem accessing the clipboard please try again.' + #13#10 +
    #13#10 + 'The following application has a lock on the clipboard:' + #13#10 +
    'App Title: %s' + #13#10 + 'App Name: %s' + #13#10 + #13#10 +
    'If this problem persists please close %s and then try again. If you are still experiencing issues please contact your local CPRS help desk.';
var
  i, J, RetryCnt: integer;
  aAnsiValue: integer;
  aAnsiString: AnsiString;
  TryPst: Boolean;
  ClpLckInfo: tClipInfo;
  TmpStr: string;

  function GetClipSource(): tClipInfo;

    function GetAppByPID(PID: Cardinal): String;
    var
      snapshot: THandle;
      ProcEntry: TProcessEntry32;
    begin
      snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
      if (snapshot <> INVALID_HANDLE_VALUE) then
      begin
        ProcEntry.dwSize := SizeOf(ProcessEntry32);
        if (Process32First(snapshot, ProcEntry)) then
        begin
          // check the first entry
          if ProcEntry.th32ProcessID = PID then
            Result := ProcEntry.szExeFile
          else
          begin
            while Process32Next(snapshot, ProcEntry) do
            begin
              if ProcEntry.th32ProcessID = PID then
              begin
                Result := ProcEntry.szExeFile;
                Break;
              end;
            end;
          end;
        end;
      end;
      CloseHandle(snapshot);
    end;

    function GetHandleByPID(PID: Cardinal): HWND;
    type
      TEInfo = record
        PID: DWORD;
        HWND: THandle;
      end;
    var
      EInfo: TEInfo;

      function CallBack(Wnd: DWORD; var EI: TEInfo): Bool; stdcall;
      var
        PID: DWORD;
      begin
        GetWindowThreadProcessID(Wnd, @PID);
        Result := (PID <> EI.PID) or (not IsWindowVisible(Wnd)) or
          (not IsWindowEnabled(Wnd));

        if not Result then
          EI.HWND := Wnd;
      end;

    begin
      EInfo.PID := PID;
      EInfo.HWND := 0;
      EnumWindows(@CallBack, integer(@EInfo));
      Result := EInfo.HWND;
    end;

  begin
    with Result do
    begin
      ObjectHwnd := 0;
      AppHwnd := 0;
      AppPid := 0;
      // Get the owners handle (TEdit, etc...)
      ObjectHwnd := GetOpenClipboardWindow;
      if ObjectHwnd <> 0 then
      begin
        // Get its running applications Process ID
        GetWindowThreadProcessID(ObjectHwnd, AppPid);

        if AppPid <> 0 then
        begin
          // Get the applciation name from the Process ID
          AppName := GetAppByPID(AppPid);

          // Get the main applications hwnd
          AppHwnd := GetHandleByPID(AppPid);

          SetLength(AppClass, 255);
          SetLength(AppClass, GetClassName(AppHwnd, PChar(AppClass),
            Length(AppClass)));
          SetLength(AppTitle, 255);
          SetLength(AppTitle, GetWindowText(AppHwnd, PChar(AppTitle),
            Length(AppTitle)));
        end
        else
          AppName := 'No Process Found';
      end
      else
        AppName := 'No Source Found';
    end;
  end;

begin
  RetryCnt := 1;
  TryPst := true;
  // Grab our data from the clipboard, Try Three times
  while TryPst do
  begin
    while (RetryCnt <= Max_Retry) and TryPst do
    begin
      Try
        if Clipboard.HasFormat(CF_TEXT) then
        begin
          aAnsiString := AnsiString(Clipboard.AsText);

          i := 1;
          while aAnsiString[i] <> #0 do
            try
              aAnsiValue := Ord(aAnsiString[i]);
              if (aAnsiValue < 32) or (aAnsiValue > 126) then
                case aAnsiValue of
                  9:
                    begin
                      for J := 1 to
                        (ATabWidth - (Length(aAnsiString) mod ATabWidth)) do
                        aAnsiString := aAnsiString + ' ';
                      // aAnsiString[i] := #32;
                    end;
                  10:
                    aAnsiString[i] := #10;
                  13:
                    aAnsiString[i] := #13;
                  145, 146:
                    aAnsiString[i] := '''';
                  147, 148:
                    aAnsiString[i] := '"';
                  149:
                    aAnsiString[i] := '*';
                else
                  aAnsiString[i] := '?';
                end;
            finally
              inc(i);
            end;

          Clipboard.AsText := String(aAnsiString);
        end;
        TryPst := false;
      Except
        inc(RetryCnt);
        Sleep(100);
        If RetryCnt > Max_Retry then
          ClpLckInfo := GetClipSource;
      End;
    end;

    // If our retry count is greater than the max we were unable to grab the paste
    if RetryCnt > Max_Retry then
    begin
      TmpStr := Format(Hlp_Msg, [SysErrorMessage(GetLastError),
        ClpLckInfo.AppTitle, ClpLckInfo.AppName, ClpLckInfo.AppName]);
      if TaskMessageDlg('Clipboard Locked', TmpStr, mtError,
        [mbRetry, mbCancel], -1) = mrRetry then
      begin
        // reset the loop variables
        RetryCnt := 1;
        TryPst := true;
      end
      else
        Exit;
    end;

  end;
end;

{ TEdit }

procedure TEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TMemo }

procedure TMemo.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TRichEdit }

procedure TRichEdit.WMKeyDown(var Message: TMessage);
var
  aShiftState: TShiftState;
begin
  aShiftState := KeyDataToShiftState(message.WParam);
  if (ssCtrl in aShiftState) and (message.WParam = Ord('V')) then
    ScrubTheClipboard;
  if (ssShift in aShiftState) and (message.WParam = VK_INSERT) then
    ScrubTheClipboard;
  inherited;
end;

procedure TRichEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TCaptionEdit }

procedure TCaptionEdit.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

{ TCaptionMemo }

procedure TCaptionMemo.WMPaste(var Message: TMessage);
begin
  ScrubTheClipboard;
  inherited;
end;

end.

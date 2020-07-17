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
  ATabWidth = 8;
  Max_Retry = 3;
  Hlp_Msg = 'System Error: %s' + #13#10 +
    'There was a problem accessing the clipboard please try again.' + #13#10 +
    #13#10 + 'The following application has a lock on the clipboard:' + #13#10 +
    'App Title: %s' + #13#10 + 'App Name: %s' + #13#10 + #13#10 +
    'If this problem persists please close %s and then try again. If you are still experiencing issues please contact your local CPRS help desk.';
var
  i, X, J, RetryCnt: integer;
  aAnsiValue: integer;
  aAnsiString: AnsiString;
  TryPst: Boolean;
  ClpLckInfo: tClipInfo;
  TmpStr: string;
  TmpStrLst: TStringList;

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

          SetLength(AppClass, 256);
          SetLength(AppClass, GetClassName(AppHwnd, PChar(AppClass),
            Length(AppClass)- 1));
          SetLength(AppTitle, 256);
          SetLength(AppTitle, GetWindowText(AppHwnd, PChar(AppTitle),
            Length(AppTitle) - 1));
        end
        else
          AppName := 'No Process Found';
      end
      else
        AppName := 'No Source Found';
    end;
  end;

// Scrub clipboard but keep all formats
  procedure AddToClipBoard(aValue: AnsiString);
  var
    gMem: HGLOBAL;
    lp: Pointer;
    WS: String;
    ErrorCode: integer;
    ErrorMessage: String;
  begin
{$WARN SYMBOL_PLATFORM OFF}
    Clipboard.Open;
    try
      if Clipboard.HasFormat(CF_TEXT) then
      begin

        // now add the text to the clipboard
        gMem := GlobalAlloc(GHND, (Length(aValue) + 1));
        // Combines GMEM_MOVEABLE and GMEM_ZEROINIT - GMEM_DDESHARE is obsolete and ignored
        try
          if gMem = 0 then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          lp := GlobalLock(gMem);
          if not assigned(lp) then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          CopyMemory(lp, Pointer(PAnsiChar(@aValue[1])), (Length(aValue) + 1));
          // We should look at changing this to memcpy_s

          {
            Note: The Delphi import of GlobalUnlock() is incorrect in Winapi.Windows.
            Per https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-globalunlock

            If the memory object is still locked after decrementing the lock count,
            the return value is a nonzero value. If the memory object is unlocked
            after decrementing the lock count, the function returns zero and GetLastError
            returns NO_ERROR.

            Since a non-zero is interpreted as true and zero is interpreted as false, the
            result of the API call is actually inverted.
          }
          if GlobalUnlock(gMem) then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          SetClipboardData(CF_TEXT, gMem);

        except
          on E: Exception do
          begin
            GlobalFree(gMem)
          end;
        end;
      end;

      if Clipboard.HasFormat(CF_UNICODETEXT) then
      begin
        WS := UnicodeString(aValue);

        gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, ((Length(WS) + 1) * 2));
        try
          if gMem = 0 then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          lp := GlobalLock(gMem);
          if not assigned(lp) then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          CopyMemory(lp, Pointer(PChar(@WS[1])), ((Length(WS) + 1) * 2));

          {
            Note: The Delphi import of GlobalUnlock() is incorrect in Winapi.Windows.
            Per https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-globalunlock

            If the memory object is still locked after decrementing the lock count,
            the return value is a nonzero value. If the memory object is unlocked
            after decrementing the lock count, the function returns zero and GetLastError
            returns NO_ERROR.

            Since a non-zero is interpreted as true and zero is interpreted as false, the
            result of the API call is actually inverted.
          }
          if GlobalUnlock(gMem) then
          begin
            ErrorCode := GetLastError;
            ErrorMessage := SysErrorMessage(ErrorCode);
            raise Exception.Create(ErrorMessage);
          end;

          SetClipboardData(CF_UNICODETEXT, gMem);

        except
          on E: Exception do
          begin
            GlobalFree(gMem);
          end;
        end;
      end;
    finally
      Clipboard.Close;
    end;
{$WARN SYMBOL_PLATFORM ON}
  end;

begin
  // try
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
          // Load text line by line
          TmpStrLst := TStringList.Create;
          try
            // Load from clipboard
            TmpStrLst.Text := Clipboard.AsText;
            // loop line by line
            for i := 0 to TmpStrLst.Count - 1 do
            begin
              // convert line to ansi
              aAnsiString := AnsiString(TmpStrLst.strings[i]);
              TmpStr := '';
              // Loop character by character
              for X := 1 to Length(aAnsiString) do
              begin
                aAnsiValue := Ord(aAnsiString[X]);
                if (aAnsiValue < 32) or (aAnsiValue > 126) then
                begin
                  case aAnsiValue of
                    9:
                      for J := 1 to
                        (ATabWidth - (Length(TmpStr) mod ATabWidth)) do
                        TmpStr := TmpStr + ' ';
                    10:
                      TmpStr := TmpStr + #10;
                    13:
                      TmpStr := TmpStr + #13;
                    145, 146:
                      TmpStr := TmpStr + '''';
                    147, 148:
                      TmpStr := TmpStr + '"';
                    149:
                      TmpStr := TmpStr + '*';
                  else
                    TmpStr := TmpStr + '?';
                  end;
                end
                else
                  TmpStr := TmpStr + String(aAnsiString[X]);
              end;
              // Reset the line with the filtered string
              TmpStrLst.strings[i] := TmpStr;

            end;
            // Set the anisting to the full filtered results
            aAnsiString := '';
            for X := 0 to TmpStrLst.Count - 1 do
            begin
              if X > 0 then
                aAnsiString := aAnsiString + #13#10;
              aAnsiString := aAnsiString + AnsiString(TmpStrLst[X]);
            end;

          finally
            TmpStrLst.Free;
          end;

          // Clipboard.AsText := String(aAnsiString);
          AddToClipBoard(aAnsiString);
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
  // Except
  // Swallow the exception for the tim being
  // End;
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

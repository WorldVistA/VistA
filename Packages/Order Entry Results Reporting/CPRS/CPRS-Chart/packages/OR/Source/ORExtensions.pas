unit ORExtensions;

interface

uses
  ORCtrls,
  ORCtrls.ORRichEdit,
  Vcl.Clipbrd,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Winapi.Messages,
  Winapi.TLHelp32,
  Vcl.Dialogs,
  System.UITypes,
  SHDocVw;

type
  TEdit = class(Vcl.StdCtrls.TEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TMemo = class(Vcl.StdCtrls.TMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

const
  UM_MESSAGE = WM_USER + 300;

type
  TRichEdit = class(ORCtrls.ORRichEdit.TORRichEdit);

  TCaptionEdit = class(ORCtrls.TCaptionEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TCaptionMemo = class(ORCtrls.TCaptionMemo)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
  end;

  TListView = class(Vcl.ComCtrls.TListView)
    private
      procedure WMSetFocus(var Message: TMessage); message WM_SETFOCUS;
  end;

procedure ClipboardFilemanSafe;

function getUserDataFolder: String;

procedure SetUserDataFolder(ABrowser: TWebBrowser);

implementation

uses
  ORFn,
  Vcl.Edge,
  System.IOUtils,
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  Winapi.CommCtrl;

type
  TORBrowser = class(TWebBrowser);

procedure ClipboardFilemanSafe;
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
  I, X, J, RetryCnt: integer;
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

    procedure UpdateClip(FormatType: Cardinal; ClipText: AnsiString);
    var
      gMem: HGLOBAL;
      lp: Pointer;
      IsMemoryLocked: Boolean;
      StrLen, ErrorCode: integer;
      WS: string;
    begin
      {$WARN SYMBOL_PLATFORM OFF}
      if ClipText = '' then Exit;

      //Set the length based on the format type (either text or unitext)
      case FormatType of
        CF_TEXT: StrLen := (Length(ClipText) + 1) * SizeOf(ClipText[1]);
        CF_UNICODETEXT:
          begin
            WS := UnicodeString(ClipText);
            StrLen := ((Length(WS) + 1) * SizeOf(WS[1]));
          end;
      else Exit;
      end;

      //allocate the memory
      gMem := GlobalAlloc(GHND, StrLen);
      try
        //ensure we were able to allocate
        if gMem = 0 then RaiseLastOSError;

        //Lock the memory
        lp := GlobalLock(gMem);
        try
          if not assigned(lp) then RaiseLastOSError;
          //Move the text into the allocated space
          case FormatType of
            CF_TEXT: Move(PAnsiChar(ClipText)^, lp^, StrLen);
            CF_UNICODETEXT: Move(PChar(WS)^, lp^, StrLen);
          else raise Exception.Create('Unknown format type. This error should never occur!');
          end;
        finally
          //Try to unlock the memory
          // Note: Per https://docs.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-globalunlock
          // The result of GlobalUnlock() does not mean success or failure. It
          // is the LockCount (as a BOOL, but that's the Windows API being
          // weird) To know if the operation succeeded, the result of
          // GlobalUnlock needs to be false, AND the Last Error needs to be
          // NO_ERROR
          IsMemoryLocked := GlobalUnlock(gMem);
        end;

        //Ensure we were able to unlock
        if IsMemoryLocked then RaiseLastOSError
        else
        begin
          ErrorCode := GetLastError;
          case ErrorCode of
            NO_ERROR, ERROR_NOT_LOCKED:; // ERROR_NOT_LOCKED should not happen, but if it does we don't worry
          else RaiseLastOSError;
          end;
        end;

        //Set the clipboard text
        SetClipboardData(FormatType, gMem);
      except
        if gMem <> 0 then GlobalFree(gMem);
      end;
      {$WARN SYMBOL_PLATFORM ON}
    end;

  begin
    Clipboard.Open;
    try
      if Clipboard.HasFormat(CF_TEXT) then
        UpdateClip(CF_TEXT, aValue);
      if Clipboard.HasFormat(CF_UNICODETEXT) then
        UpdateClip(CF_UNICODETEXT, aValue);
    finally
      Clipboard.Close;
    end;
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
            // Set the ansistring to the full filtered results
            aAnsiString := '';
            for X := 0 to TmpStrLst.Count - 1 do
            begin
              aAnsiString := aAnsiString + AnsiString(TmpStrLst[X]);
              // Each line gets a CRLF added except the last line (unless the user specifically copied one)
              if x < (TmpStrLst.Count - 1) then
                aAnsiString := aAnsiString + CRLF
              else if copy(Clipboard.AsText, Length(Clipboard.AsText) - 1, 2) = CRLF then
                aAnsiString := aAnsiString + CRLF;
            end;

          finally
            TmpStrLst.Free;
          end;

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
  ClipboardFilemanSafe;
  inherited;
end;

{ TMemo }

procedure TMemo.WMPaste(var Message: TMessage);
begin
  ClipboardFilemanSafe;
  inherited;
end;

{ TCaptionEdit }

procedure TCaptionEdit.WMPaste(var Message: TMessage);
begin
  ClipboardFilemanSafe;
  inherited;
end;

{ TCaptionMemo }

procedure TCaptionMemo.WMPaste(var Message: TMessage);
begin
  ClipboardFilemanSafe;
  inherited;
end;

function getUserDataFolder: String;
var
  AppData: string;
const
  CPRSCacheDir: string = 'CPRSChart.exe\WebView2';
begin
  Result := '';
  AppData := GetEnvironmentVariable('APPDATA');
  if AppData = '' then
    raise Exception.Create('Unable to find %APPDATA% in user account in ORExtensions.pas');

  AppData := IncludeTrailingPathDelimiter(AppData) + CPRSCacheDir;

  if not (DirectoryExists(AppData)) then
    TDirectory.CreateDirectory(AppData);

  Result := AppData;
end;

procedure SetUserDataFolder(ABrowser: TWebBrowser);
//var
//  AppData: string;
//const
//  CPRSCacheDir: string = 'CPRSChart.exe\WebView2';
begin
  {
  blj 31 August 2021 - JIRA https://vajira.max.gov/browse/VISTAOR-26730
  On TEdgeBrowser, there is a property .UserDataFolder: String; that is used
  by WebView2 applications to cache data/cookies/other data from websites visited.
  For some unknown reason, Embarcadero chose NOT to publish that property on their
  updated TWebBrowser control.  This means that one of two things will happen:
    1: If CPRSChart.exe can write to the directory from which it was run, it will
       create a new "CPRSChart.exe.WebView2" subdirectory there.  This is bad.
    2: If CPRSChart.exe CANNOT write to the directory from which it was run
       (as will be the case the vast majority of the time in the field), the
       attempt to instantiate the MSEdge version of TWebBrowser will fail silently,
       and TWebBrowser will fall back to instantiating IE instead.

  Fortunately, an ugly hack was found in the Delphi Praxis forum, which we include
  below.

  Note: This function must be called with EVERY instance of TWebBrowser in the
  application.  Otherwise you'll either get an ugly directory or IE (an ugly web
  browser).
  }
  if ABrowser.ActiveEngine = IE then
    exit; //We don't need to be here right now.
{
  AppData := GetEnvironmentVariable('APPDATA');
  if AppData = '' then
    raise Exception.Create('Unable to find %APPDATA% in user account in ORExtensions.pas');

  AppData := IncludeTrailingPathDelimiter(AppData) + CPRSCacheDir;

  if not (DirectoryExists(AppData)) then
    TDirectory.CreateDirectory(AppData);

  TORBrowser(ABrowser).GetEdgeInterface.UserDataFolder := AppData;
}
  TORBrowser(ABrowser).GetEdgeInterface.UserDataFolder := getUserDataFolder;
end;


{ TListView }

procedure TListView.WMSetFocus(var Message: TMessage);
begin
 inherited;
 if Self.ItemIndex = -1 then
  ListView_SetItemState(Self.Handle, 0, LVIS_FOCUSED, LVIS_FOCUSED);
 RedrawWindow(Self.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_UPDATENOW);
end;

end.

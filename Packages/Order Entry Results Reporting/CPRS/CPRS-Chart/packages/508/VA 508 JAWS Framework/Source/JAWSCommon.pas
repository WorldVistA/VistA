unit JAWSCommon;

interface

uses
  SysUtils, Windows, Messages, Registry, StrUtils;

const
  DLL_MESSAGE_ID_NAME: PChar = 'VA 508 / Freedom Scientific - JAWS Communication Message ID';

  DISPATCHER_WINDOW_CLASS = 'TfrmVA508JawsDispatcherHiddenWindow';
  DISPATCHER_WINDOW_TITLE = 'VA 508 JAWS Dispatcher Window';
  DISPATCHER_WINDOW_TITLE_LEN = length(DISPATCHER_WINDOW_TITLE);

  DLL_MAIN_WINDOW_CLASS = 'TfrmVA508HiddenJawsMainWindow';
  DLL_WINDOW_TITLE = 'VA 508 JAWS Window';
  DLL_WINDOW_TITLE_LEN = length(DLL_WINDOW_TITLE);

// format = prefix : varname : <index #> : +/- <data>
  DLL_WINDOW_DELIM = ':';
  DLL_WINDOW_OFFSET = '=';
  DLL_WINDOW_LENGTH = ',';

  DLL_CAPTION_MAX = 4090; // max num of chars per title
  MAX_CHARS_IN_WINDOW_HANDLE = 12;
  DLL_CAPTION_LIMIT = DLL_CAPTION_MAX - MAX_CHARS_IN_WINDOW_HANDLE;

  DLL_DATA_WINDOW_CLASS = 'TfrmVA508HiddenJawsDataWindow';
  
  JAWS_MESSAGE_GET_DLL_WITH_FOCUS = 1;

var
  MessageID: UINT = 0;

procedure ErrorCheckClassName(obj: TObject; ClassName: string);
procedure SendReturnValue(Window: HWND; Value: Longint);

implementation

uses VAUtils;

procedure ErrorCheckClassName(obj: TObject; ClassName: string);
begin
  if obj.ClassName <> ClassName then
    Raise Exception.Create(obj.ClassName + ' should have been ' + ClassName);
end;

procedure SendReturnValue(Window: HWND; Value: Longint);
var
  idx1, idx2: integer;
  header: string;
  bump: byte;
begin
  header := GetWindowTitle(Window);
  idx1 := pos(':', header);
  if idx1 < 1 then
    idx1 := length(header) + 1;
  idx2 := posex(':', header, idx1+1);
  if idx2<=idx1 then
    idx2 := idx1+1;
  bump := StrToIntDef(copy(header, idx1+1, idx2 - idx1 - 1), 0);
  if bump > 254 then
    bump := 1
  else
    inc(bump);
  header := copy(header,1,idx1-1) + ':' + inttostr(bump) + ':' + IntToStr(Value);
  SetWindowText(Window, PChar(header));
end;

procedure InitializeCommonData;
begin
  MessageID := RegisterWindowMessage(DLL_MESSAGE_ID_NAME);
end;

initialization
  InitializeCommonData;

finalization

end.

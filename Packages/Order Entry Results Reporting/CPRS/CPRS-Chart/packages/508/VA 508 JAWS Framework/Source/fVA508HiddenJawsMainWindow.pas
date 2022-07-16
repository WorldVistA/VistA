unit fVA508HiddenJawsMainWindow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, ExtCtrls, ComObj, VA508AccessibilityConst, AppEvnts;

type
  TfrmVA508HiddenJawsMainWindow = class(TForm)
    ReloadTimer: TTimer;
    CloseINIFilesTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ReloadTimerTimer(Sender: TObject);
    procedure CloseINIFilesTimerTimer(Sender: TObject);
  private
    FRootCaption: string;
    FPostWindow: HWnd;
    FCloseFilesEvent: TNotifyEvent;
    FData: string;
    FVariables: string;
    FDataWindowPool: TList;
    FDataWindows: TObjectList;
    FComponentDataCallBackProc: TComponentDataRequestProc;
    FConfigChangePending: boolean;
    FConfigReloadProc: TConfigReloadProc;
    procedure ConverAccelChars(var text: string);
  protected
    procedure WndProc(var Msg: TMessage); override;
  public
    procedure ConfigReloadNeeded;
    procedure WriteData(VarName, Value: string);
    procedure PostData;
    procedure ResetINITimer(Event: TNotifyEvent);
    property ConfigReloadProc: TConfigReloadProc read FConfigReloadProc write FConfigReloadProc;
    property ComponentDataCallBackProc: TComponentDataRequestProc read FComponentDataCallBackProc write FComponentDataCallBackProc;
    property ConfigChangePending: boolean read FConfigChangePending write FConfigChangePending;
  end;

var
  frmVA508HiddenJawsMainWindow: TfrmVA508HiddenJawsMainWindow;

implementation

uses JAWSCommon, fVA508HiddenJawsDataWindow, VAUtils;

{$R *.dfm}

procedure TfrmVA508HiddenJawsMainWindow.CloseINIFilesTimerTimer(
  Sender: TObject);
begin
  CloseINIFilesTimer.Enabled := FALSE;
  if assigned(FCloseFilesEvent) then
    FCloseFilesEvent(Sender);
end;

procedure TfrmVA508HiddenJawsMainWindow.ConfigReloadNeeded;
begin
  ReloadTimer.Enabled := FALSE;
  ReloadTimer.Enabled := TRUE;
  FConfigChangePending := TRUE;
end;

// MSAA messes up strings with & chars
procedure TfrmVA508HiddenJawsMainWindow.ConverAccelChars(var text: string);
var
  i: integer;
  convert: boolean;
begin
  repeat
    i := pos('&', text);
    if i > 0 then
    begin
      convert := (i = length(text));
      if not convert then
        {$Ifdef VER180}
         Convert := not (text[i+1] in ['A'..'Z','a'..'z','0'..'9']);
        {$Else}
        convert := not CharInSet(text[i+1],['A'..'Z','a'..'z','0'..'9'] );
        {$EndIf}
      delete(text,i,1);
      if convert then
        insert(' and ', text, i);      
    end;
  until i = 0;
end;

procedure TfrmVA508HiddenJawsMainWindow.FormCreate(Sender: TObject);
begin
  ErrorCheckClassName(Self, DLL_MAIN_WINDOW_CLASS);
  FRootCaption := DLL_WINDOW_TITLE;
  Caption := FRootCaption;
  FDataWindowPool := TList.Create;
  FDataWindows := TObjectList.Create;
end;

procedure TfrmVA508HiddenJawsMainWindow.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDataWindowPool);
  FreeAndNil(FDataWindows);
end;

procedure TfrmVA508HiddenJawsMainWindow.ReloadTimerTimer(Sender: TObject);
begin
  ReloadTimer.Enabled := FALSE;
  if assigned(FConfigReloadProc) then
    FConfigReloadProc;
  FConfigChangePending := FALSE;
end;

procedure TfrmVA508HiddenJawsMainWindow.ResetINITimer(Event: TNotifyEvent);
begin
  FCloseFilesEvent := Event;
  CloseINIFilesTimer.Enabled := FALSE;
  CloseINIFilesTimer.Enabled := TRUE;  
end;

// data is in 2 strings
// list of variable names
// list of data
procedure TfrmVA508HiddenJawsMainWindow.WriteData(VarName, Value: string);
var
  offset, len: integer;
begin
  ConverAccelChars(Value);
  len := length(Value);
  if len > 0 then
  begin
    offset := length(FData);
    FData := FData + Value;
  end
  else
    offset := 0;
  FVariables := FVariables + DLL_WINDOW_DELIM + VarName + DLL_WINDOW_OFFSET +
                             IntToStr(offset) + DLL_WINDOW_LENGTH + IntToStr(len);
end;

// output
// caption:[next window handle]:varlen:var=offset,length:var=offset,len:data
// varlen = from first to last :

procedure TfrmVA508HiddenJawsMainWindow.PostData;
var
  DataWindow, LastWindow: TfrmVA508HiddenJawsDataWindow;
  Data, Output, RootOutput: string;
  Done, UpdateLastWindow: boolean;
  DataLen, Len, HandleIdx, AllowedChars, StartIndex: integer;

  procedure GetDataWindow;
  var
    idx: integer;
  begin
    if assigned(DataWindow) then
      LastWindow := DataWindow;
    if FDataWindowPool.Count > 0 then
    begin
      idx := FDataWindowPool.Count-1;
      DataWindow := TfrmVA508HiddenJawsDataWindow(FDataWindowPool[idx]);
      FDataWindowPool.Delete(idx);
    end
    else
    begin
      DataWindow := TfrmVA508HiddenJawsDataWindow.Create(Self);
      FDataWindows.Add(DataWindow);
      DataWindow.HandleNeeded;
      Application.ProcessMessages;
    end;
    if FPostWindow = 0 then
      FPostWindow := DataWindow.Handle;
  end;

begin
  LastWindow := nil;
  DataWindow := nil;
  FVariables := FVariables + DLL_WINDOW_DELIM;
  Len := length(FVariables);
  Data := IntToStr(Len) + FVariables + FData;
  DataLen := length(Data) + 1;
// Format = header  : next window handle : data
  RootOutput := FRootCaption + DLL_WINDOW_DELIM + DLL_WINDOW_DELIM;
  HandleIdx := length(RootOutput);
  AllowedChars := DLL_CAPTION_LIMIT - Length(RootOutput);
  StartIndex := 1;
  UpdateLastWindow := FALSE;
  repeat
    Done := TRUE;
    GetDataWindow;
    if UpdateLastWindow then
    begin
      Output := LastWindow.Caption;
      insert(IntToStr(DataWindow.handle), Output, HandleIdx);
      LastWindow.Caption := Output;
      UpdateLastWindow := FALSE;
    end;
    Len := DataLen - StartIndex;
    Output := RootOutput + copy(Data, StartIndex, AllowedChars);
    DataWindow.Caption := Output;
    if Len > AllowedChars then
    begin
      UpdateLastWindow := TRUE;
      Done := FALSE;
      inc(startIndex, AllowedChars);
    end;
  until Done;
end;

procedure TfrmVA508HiddenJawsMainWindow.WndProc(var Msg: TMessage);
var
  i: integer;
  data: string;
begin
  if Msg.Msg = MessageID then
  begin
    Msg.Result := 1;
    data := caption;
    try
  // make sure Delphi has finished creating the form.  If we dont, JAWS can detect the
  // window before Delphi has finished creating it - resulting in an access violation
      if assigned(Self) then
      begin
        try
          if assigned(FComponentDataCallBackProc) then
          begin
            FPostWindow := 0;
            FData := '';
            FVariables := '';
            FDataWindowPool.Assign(FDataWindows);
            try
              FComponentDataCallBackProc(Msg.WParam, Msg.LParam);
            except
            end;
            // clean up unused windows
            for i := 0 to FDataWindowPool.Count - 1 do
              TfrmVA508HiddenJawsDataWindow(FDataWindowPool[i]).Caption := '';
            SendReturnValue(Handle, FPostWindow);
          end;
        except
        end;
      end;
    finally
      if data = caption then
      begin
        SendReturnValue(Handle, 0);
      end;
    end;
  end
  else
    inherited WndProc(Msg);
end;

end.

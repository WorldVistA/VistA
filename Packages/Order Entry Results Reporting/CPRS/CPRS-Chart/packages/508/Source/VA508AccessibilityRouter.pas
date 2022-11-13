unit VA508AccessibilityRouter;

interface

uses
  SysUtils, Windows, Registry, StrUtils, Classes, Controls, Dialogs,
  Contnrs, DateUtils, Forms, ExtCtrls;

type
  TComponentDataNeededEvent = procedure(const WindowHandle: HWND; var DataStatus: LongInt;
    var Caption: PChar; var Value: PChar; var Data: PChar; var ControlType: PChar;
    var State: PChar; var Instructions: PChar; var ItemInstructions: PChar) of object;

  TKeyMapProcedure = procedure;

  TVA508ScreenReader = class(TObject)
  protected
    procedure RegisterCustomClassBehavior(Before, After: string); virtual; abstract;
    procedure RegisterClassAsMSAA(ClassName: string); virtual; abstract;
    procedure AddComponentDataNeededEventHandler(event: TComponentDataNeededEvent); virtual; abstract;
    procedure RemoveComponentDataNeededEventHandler(event: TComponentDataNeededEvent); virtual; abstract;
  public
    procedure Speak(Text: string); virtual; abstract;
    procedure RegisterDictionaryChange(Before, After: string); virtual; abstract;
    procedure RegisterCustomKeyMapping(Key: string; proc: TKeyMapProcedure;
                              shortDescription, longDescription: string); virtual; abstract;
  end;

function GetScreenReader: TVA508ScreenReader;

{ TODO -oJeremy Merrill -c508 :
if ScreenReaderSystemActive is false, but there are valid DLLs, add a recheck every 30 seconds
to see if the screen reader is running.  in the timer event, see if DLL.IsRunning is running is true.
if it is then pop up a message to the user (only once) and inform them that if they restart the app
with the screen reader running it will work better.  After the popup disable the timer event. }
function ScreenReaderSystemActive: boolean;

// Only guaranteed to be valid if called in an initialization section
// all other components stored as .dfm files will be registered as a dialog
// using the RegisterCustomClassBehavior
procedure SpecifyFormIsNotADialog(FormClass: TClass);

// do not call this routine - called by screen reader DLL
procedure ComponentDataRequested(WindowHandle: HWND; DataRequest: LongInt); stdcall;

implementation

uses VAUtils, VA508ScreenReaderDLLLinker, VAClasses, VA508AccessibilityConst, Generics.Collections, Generics.Defaults;

type
  TNullScreenReader = class(TVA508ScreenReader)
  public
    procedure Speak(Text: string); override;
    procedure RegisterDictionaryChange(Before, After: string); override;
    procedure RegisterCustomClassBehavior(Before, After: string); override;
    procedure RegisterClassAsMSAA(ClassName: string); override;
    procedure RegisterCustomKeyMapping(Key: string; proc: TKeyMapProcedure;
                              shortDescription, longDescription: string); override;
    procedure AddComponentDataNeededEventHandler(event: TComponentDataNeededEvent); override;
    procedure RemoveComponentDataNeededEventHandler(event: TComponentDataNeededEvent); override;
  end;

  TMasterScreenReader = class(TVA508ScreenReader)
  strict private
    FEventHandlers: TVAMethodList;
    FCustomBehaviors: TStringList;
    FInternalRegistration: boolean;
    FDataHasBeenRegistered: boolean;
    FTrying2Register: boolean;
    FKeyProc: TList;
  private
    function EncodeBehavior(Before, After: string; Action: integer): string;
    procedure DecodeBehavior(code: string; var Before, After: string;
      var Action: integer);
    function RegistrationAllowed: boolean;
    procedure RegisterCustomData;
  protected
    procedure RegisterCustomBehavior(Str1, Str2: String; Action: integer; CheckIR: boolean = FALSE);
    procedure ProcessCustomKeyCommand(DataRequest: integer);
    property EventHandlers: TVAMethodList read FEventHandlers;
  public
    constructor Create;
    destructor Destroy; override;
    procedure HandleSRException(E: Exception);
    procedure Speak(Text: string); override;
    procedure RegisterDictionaryChange(Before, After: string); override;
    procedure RegisterCustomClassBehavior(Before, After: string); override;
    procedure RegisterClassAsMSAA(ClassName: string); override;
    procedure RegisterCustomKeyMapping(Key: string; proc: TKeyMapProcedure;
                              shortDescription, longDescription: string); override;
    procedure AddComponentDataNeededEventHandler(event: TComponentDataNeededEvent); override;
    procedure RemoveComponentDataNeededEventHandler(event: TComponentDataNeededEvent); override;
  end;

var
  ActiveScreenReader: TVA508ScreenReader = nil;
  MasterScreenReader: TMasterScreenReader = nil;
  uNonDialogClassNames: TStringList = nil;
  SaveInitProc: Pointer = nil;
  Need2RegisterData: boolean = FALSE;
  OK2RegisterData: boolean = FALSE;
  CheckScreenReaderSystemActive: boolean = TRUE;
  uScreenReaderSystemActive: boolean = FALSE;
  uPostScreenReaderActivationTimer: TTimer = nil;

const
// number of seconds between checks for a screen reader
  POST_SCREEN_READER_ACTIVATION_CHECK_SECONDS = 30;

  POST_SCREEN_READER_INFO_MESSAGE = ERROR_INTRO +
    'The Accessibility Framework can only communicate with the screen' + CRLF +
    'reader if the screen reader is running before you start this application.'+ CRLF +
    'Please restart %s to take advantage of the enhanced'+ CRLF +
    'accessibility features offered by the Accessibility Framework.';

procedure VA508RouterInitProc;
begin
  if assigned(SaveInitProc) then
    TProcedure(SaveInitProc);
  OK2RegisterData := TRUE;
  if Need2RegisterData then
  begin
    Need2RegisterData := FALSE;
    if ScreenReaderSystemActive then
    begin
      TMasterScreenReader(GetScreenreader).RegisterCustomData;
    end;
  end;
end;

function GetScreenReader: TVA508ScreenReader;
begin
  if not assigned(ActiveScreenReader) then
  begin
    if ScreenReaderSystemActive then
    begin
      MasterScreenReader := TMasterScreenReader.Create;
      ActiveScreenReader := MasterScreenReader;
    end
    else
      ActiveScreenReader := TNullScreenReader.Create;
  end;
  Result := ActiveScreenReader;
end;

procedure PostScreenReaderCheckEvent(Self: TObject; Sender: TObject);
var
  AppName, ext, error: string;
begin
  if ScreenReaderActive then
  begin
    FreeAndNil(uPostScreenReaderActivationTimer);
    if IsScreenReaderSupported(TRUE) then
    begin
      AppName := ExtractFileName(ParamStr(0));
      ext := ExtractFileExt(AppName);
      AppName := LeftStr(AppName, length(AppName) - Length(ext));
      error := Format(POST_SCREEN_READER_INFO_MESSAGE, [AppName]);
      MessageBox(0, PChar(error), 'Accessibility Component Information',
        MB_OK or MB_ICONINFORMATION or MB_TASKMODAL or MB_TOPMOST);
    end;
  end;
end;

function ScreenReaderSystemActive: boolean;

  procedure CreateTimer;
  var
    ptr: TMethod;
  begin
    uPostScreenReaderActivationTimer := TTimer.Create(nil);
    with uPostScreenReaderActivationTimer do
    begin
      Enabled := FALSE;
      Interval := 1000 * POST_SCREEN_READER_ACTIVATION_CHECK_SECONDS;
      ptr.Code := @PostScreenReaderCheckEvent;
      ptr.Data := @ptr;
      OnTimer := TNotifyEvent(ptr);
      Enabled := TRUE;
    end;
  end;

begin
  if CheckScreenReaderSystemActive then
  begin
    CheckScreenReaderSystemActive := FALSE;
    // prevent Delphi IDE from running DLL
    if LowerCase(ExtractFileName(ParamStr(0))) <> 'bds.exe' then
      uScreenReaderSystemActive := ScreenReaderDLLsExist;
    if uScreenReaderSystemActive then
    begin
      if CheckForJaws and ScreenReaderSupportEnabled then
      begin
        if IsScreenReaderSupported(FALSE) then
          uScreenReaderSystemActive := InitializeScreenReaderLink
        else
          uScreenReaderSystemActive := FALSE;
      end
      else
      begin
        uScreenReaderSystemActive := FALSE;
        CreateTimer;
      end;
    end;
  end;
  Result := uScreenReaderSystemActive;
end;

procedure SpecifyFormIsNotADialog(FormClass: TClass);
var
  lc: string;
begin
  if ScreenReaderSystemActive then
  begin
    lc := lowercase(FormClass.ClassName);
    if not assigned(uNonDialogClassNames) then
      uNonDialogClassNames := TStringList.Create;
    if uNonDialogClassNames.IndexOf(lc) < 0 then
      uNonDialogClassNames.Add(lc);
    if assigned(MasterScreenReader) then
      MasterScreenReader.RegisterCustomBehavior(FormClass.ClassName, '',
                                        BEHAVIOR_REMOVE_COMPONENT_CLASS, TRUE);
  end;
end;

{ TMasterScreenReader }

procedure TMasterScreenReader.AddComponentDataNeededEventHandler(event: TComponentDataNeededEvent);
begin
  FEventHandlers.Add(TMethod(event));
end;

constructor TMasterScreenReader.Create;
begin
  FEventHandlers := TVAMethodList.Create;
  FCustomBehaviors := TStringList.Create;
  FInternalRegistration := FALSE;
  FDataHasBeenRegistered := FALSE;
  FKeyProc := TList.Create;
end;

procedure TMasterScreenReader.DecodeBehavior(code: string; var Before,
  After: string; var Action: integer);

  function Decode(var MasterString: string): string;
  var
    CodeLength: integer;
    hex: string;

  begin
    Result := '';
    if length(MasterString) > 1 then
    begin
      hex := copy(MasterString,1,2);
      CodeLength := FastHexToByte(hex);
      Result := copy(MasterString, 3, CodeLength);
      delete(MasterString, 1, CodeLength + 2);
    end;
  end;

begin
  Action := StrToIntDef(Decode(code), 0);
  Before := Decode(code);
  After := Decode(code);
  if code <> '' then
    Raise TVA508Exception.Create('Corrupted Custom Behavior');
end;

destructor TMasterScreenReader.Destroy;
begin
  CloseScreenReaderLink;
  FreeAndNil(FEventHandlers);
  FreeAndNil(FCustomBehaviors);
  FreeAndNil(FKeyProc);
  inherited;
end;

function TMasterScreenReader.EncodeBehavior(Before, After: string;
  Action: integer): string;

  function Coded(str: string): string;
  var
    len: integer;
  begin
    len := length(str);
    if len > 255 then
      Raise TVA508Exception.Create('RegisterCustomBehavior parameter can not be more than 255 characters long');
    Result := HexChars[len] + str;
  end;

begin
  Result := Coded(IntToStr(Action)) + Coded(Before) + Coded(After);
end;

procedure TMasterScreenReader.HandleSRException(E: Exception);
begin
  if not E.ClassNameIs(TVA508Exception.ClassName) then
    raise E;
end;

procedure TMasterScreenReader.ProcessCustomKeyCommand(DataRequest: integer);
var
  idx: integer;
  proc: TKeyMapProcedure;
begin
  idx := (DataRequest AND DATA_CUSTOM_KEY_COMMAND_MASK) - 1;
  if (idx < 0) or (idx >= FKeyProc.count) then exit;
  proc := TKeyMapProcedure(FKeyProc[idx]);
  proc;
end;

procedure TMasterScreenReader.RegisterClassAsMSAA(ClassName: string);
begin
  RegisterCustomBehavior(ClassName, '', BEHAVIOR_ADD_COMPONENT_MSAA, TRUE);
  RegisterCustomBehavior(ClassName, '', BEHAVIOR_REMOVE_COMPONENT_CLASS, TRUE);
end;

procedure TMasterScreenReader.RegisterCustomBehavior(Str1, Str2: String;
          Action: integer; CheckIR: boolean = FALSE);
var
  code: string;
  idx: integer;
  p2: PChar;
  ok: boolean;
begin
  code := EncodeBehavior(Str1, Str2, Action);
  idx := FCustomBehaviors.IndexOf(code);
  if idx < 0 then
  begin
    FCustomBehaviors.add(code);
    ok := RegistrationAllowed;
    if ok and CheckIR then
      ok := (not FInternalRegistration);
    if ok then
    begin
      try
        if Str2 = '' then
          p2 := nil
        else
          p2 := PChar(Str2);
        SRRegisterCustomBehavior(Action, PChar(Str1), P2);
      except
        on E: Exception do HandleSRException(E);
      end;
    end;
  end;
end;

procedure TMasterScreenReader.RegisterCustomClassBehavior(Before,
  After: string);
begin
  RegisterCustomBehavior(Before, After, BEHAVIOR_ADD_COMPONENT_CLASS, TRUE);
  RegisterCustomBehavior(Before, After, BEHAVIOR_REMOVE_COMPONENT_MSAA, TRUE);
end;

function EnumResNameProc(module: HMODULE; lpszType: PChar; lpszName: PChar; var list: TStringList): BOOL; stdcall;
var
  name: string;

begin
  name := lpszName;
  list.Add(name);
  Result := TRUE;
end;

procedure TMasterScreenReader.RegisterCustomData;
const
  rErrMsg = 'READ ERROR: %s';
var
  i, Action: integer;
  Before, After, code: string;

  procedure EnsureDialogAreSpecified;
  var
    list: TStringList;
    i: integer;
    stream: TResourceStream;
    Reader: TReader;
    ChildPos: integer;
    Flags: TFilerFlags;
    clsName: string;
    ok: boolean;
  begin
    FInternalRegistration := TRUE;
    try
      list := TStringList.Create;
      try
        if EnumResourceNames(HInstance, RT_RCDATA, @EnumResNameProc,
          integer(@list)) then
        begin
          for i := 0 to list.count - 1 do
          begin
            stream := TResourceStream.Create(HInstance, list[i], RT_RCDATA);
            try
              if TestStreamFormat(stream) = sofBinary then
              begin
                Reader := TReader.Create(stream, 512);
                try
                  try
                    Reader.ReadSignature;
                    Reader.ReadPrefix(Flags, ChildPos);
                    clsName := Reader.ReadStr;
                    ok := not assigned(uNonDialogClassNames);
                    if not ok then
                      ok := (uNonDialogClassNames.IndexOf
                        (LowerCase(clsName)) < 0);
                    if ok then
                      RegisterCustomClassBehavior(clsName,
                        CLASS_BEHAVIOR_DIALOG);
                  except
                    {$WARN SYMBOL_PLATFORM OFF}
                    if DebugHook <> 0 then
                      OutputDebugString(PwideChar(Format(rErrMsg, [list[i]])));
                    {$WARN SYMBOL_PLATFORM ON}
                  end;
                finally
                  Reader.Free;
                end;
              end;
            finally
              stream.Free;
            end;
          end;
        end;
      finally
        list.Free;
      end;
    finally
      FInternalRegistration := FALSE;
    end;
  end;

begin
  if FTrying2Register then
    exit;
  FTrying2Register := TRUE;
  try
    if OK2RegisterData then
    begin
      try
        EnsureDialogAreSpecified;
        RegisterCustomBehavior('', '',
          BEHAVIOR_PURGE_UNREGISTERED_KEY_MAPPINGS);
        for i := 0 to FCustomBehaviors.count - 1 do
        begin
          code := FCustomBehaviors[i];
          DecodeBehavior(code, Before, After, Action);
          SRRegisterCustomBehavior(Action, PChar(Before), PChar(After));
        end;
        FDataHasBeenRegistered := TRUE;
      except
        on E: Exception do
          HandleSRException(E);
      end;
    end
    else
      Need2RegisterData := TRUE;
  finally
    FTrying2Register := FALSE;
  end;
end;

procedure TMasterScreenReader.RegisterCustomKeyMapping(Key: string; proc: TKeyMapProcedure;
                              shortDescription, longDescription: string);
var
  idx: string;

  procedure AddDescription(DescType, Desc: string);
  var
    temp: string;
  begin
    temp := DescType + idx + '=' + Desc;
    if length(temp) > 255 then
      raise TVA508Exception.Create('Key Mapping description for ' + Key + ' exceeds 255 characters');
    RegisterCustomBehavior(DescType + idx, Desc, BEHAVIOR_ADD_CUSTOM_KEY_DESCRIPTION);
  end;

begin
  FKeyProc.Add(@proc);
  idx := inttostr(FKeyProc.Count);
  RegisterCustomBehavior(Key, idx, BEHAVIOR_ADD_CUSTOM_KEY_MAPPING);
  AddDescription('short', shortDescription);
  AddDescription('long', longDescription);
end;

procedure TMasterScreenReader.RegisterDictionaryChange(Before, After: string);
begin
  RegisterCustomBehavior(Before, After, BEHAVIOR_ADD_DICTIONARY_CHANGE);
end;

function TMasterScreenReader.RegistrationAllowed: boolean;
begin
  Result := FDataHasBeenRegistered;
  if not Result then
  begin
    RegisterCustomData;
    Result := FDataHasBeenRegistered;
  end;
end;

procedure TMasterScreenReader.RemoveComponentDataNeededEventHandler(event: TComponentDataNeededEvent);
begin
  FEventHandlers.Remove(TMethod(event));
end;

procedure TMasterScreenReader.Speak(Text: string);
begin
  if (not assigned(SRSpeakText)) or (Text = '') then exit;
  try
    SRSpeakText(PChar(Text));
  except
    on E: Exception do HandleSRException(E);
  end;
end;

// need to post a message here - can't do direct call - this message is called before mouse
// process messages are called that change a check box state
procedure ComponentDataRequested(WindowHandle: HWND; DataRequest: LongInt); stdcall;
var
  i: integer;
  Handle: HWND;
  Caption: PChar;
  Value: PChar;
  Data: PChar;
  ControlType: PChar;
  State: PChar;
  Instructions: PChar;
  ItemInstructions: PChar;
  DataStatus: LongInt;

  handler: TComponentDataNeededEvent;

begin
  if assigned(MasterScreenReader) then
  begin
    try
      if (DataRequest AND DATA_CUSTOM_KEY_COMMAND) <> 0 then
        MasterScreenReader.ProcessCustomKeyCommand(DataRequest)
      else
      begin
        Handle := WindowHandle;
        Caption := nil;
        Value := nil;
        Data := nil;
        ControlType := nil;
        State := nil;
        Instructions := nil;
        ItemInstructions := nil;
        DataStatus := DataRequest;
        i := 0;
        while (i < MasterScreenReader.EventHandlers.Count) do
        begin
          handler := TComponentDataNeededEvent(MasterScreenReader.EventHandlers.Methods[i]);
          if assigned(handler) then
            handler(Handle, DataStatus, Caption, Value, Data, ControlType, State,
                      Instructions, ItemInstructions);
          inc(i);
        end;
        SRComponentData(WindowHandle, DataStatus, Caption, Value, Data, ControlType, State, Instructions, ItemInstructions);
      end;
    except
      on E: Exception do MasterScreenReader.HandleSRException(E);
    end;
  end;
end;

{ TNullScreenReader }

procedure TNullScreenReader.AddComponentDataNeededEventHandler(
  event: TComponentDataNeededEvent);
begin
end;

procedure TNullScreenReader.RegisterClassAsMSAA(ClassName: string);
begin
end;

procedure TNullScreenReader.RegisterCustomClassBehavior(Before, After: string);
begin
end;

procedure TNullScreenReader.RegisterCustomKeyMapping(Key: string; proc: TKeyMapProcedure;
                              shortDescription, longDescription: string);
begin

end;

procedure TNullScreenReader.RegisterDictionaryChange(Before, After: string);
begin
end;

procedure TNullScreenReader.RemoveComponentDataNeededEventHandler(
  event: TComponentDataNeededEvent);
begin
end;

procedure TNullScreenReader.Speak(Text: string);
begin
end;

initialization
  SaveInitProc := InitProc;
  InitProc := @VA508RouterInitProc;

finalization
  if assigned(ActiveScreenReader) then
    FreeAndNil(ActiveScreenReader);
  if assigned(uNonDialogClassNames) then
    FreeAndNil(uNonDialogClassNames);
  if assigned(uPostScreenReaderActivationTimer) then
    FreeAndNil(uPostScreenReaderActivationTimer);

end.

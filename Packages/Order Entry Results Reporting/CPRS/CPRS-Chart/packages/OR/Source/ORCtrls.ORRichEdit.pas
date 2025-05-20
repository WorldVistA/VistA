unit ORCtrls.ORRichEdit;

interface
uses
  System.Rtti,
  System.Classes,
  WinApi.Messages,
  Vcl.Controls,
  Vcl.ComCtrls;

const
  UM_MESSAGE = WM_USER + 300;

type
  TMessageReceiver = class(TWinControl)
  private
    FNotifyEvent: TNotifyEvent;
  protected
    procedure HandleMessage(var Message: TMessage); message UM_MESSAGE;
  public
    constructor Create(ANotifyEvent: TNotifyEvent); reintroduce;
  end;

  TORRichEdit = class(Vcl.ComCtrls.TRichEdit)
  strict private
    FMessageReceiver: TMessageReceiver;
    FMustScrollBackLine: Integer;
    FLockDrawingCalled: Boolean;
    FVirtualMethodInterceptor: TVirtualMethodInterceptor;
    FIsAutoScrollEnabled: Boolean;
    FIsVScrollBottomEnabled: Boolean;
  protected
    procedure BeforeLinesInsert(const Args: TArray<TValue>);
    procedure AfterLinesInsert(Sender: TObject);
    function StringToRTFString(const S: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddString(const S: string);
    procedure InsertStringBefore(const S: string);
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
    procedure OnVScroll(var Msg: TMessage); message WM_VSCROLL;
  published
    // Toggles auto-scrolling to the bottom after a line is inserted
    property IsAutoScrollEnabled: Boolean read FIsAutoScrollEnabled
      write FIsAutoScrollEnabled default False;
  end;

implementation

uses
  Vcl.Forms,
  Vcl.ComStrs,
  WinApi.Windows,
  System.StrUtils,
  System.SysUtils,
  ORExtensions;

// TORRichEdit
constructor TMessageReceiver.Create(ANotifyEvent: TNotifyEvent);
begin
  inherited CreateParented(HWND_MESSAGE);
  FNotifyEvent := ANotifyEvent;
end;

procedure TMessageReceiver.HandleMessage(var Message: TMessage);
begin
  if Assigned(FNotifyEvent) then FNotifyEvent(Self);
end;

procedure TORRichEdit.BeforeLinesInsert(const Args: TArray<TValue>);
// Intercepts a call to TRichEditStrings.Insert
// We are replacing the insert string with one with #13 and #10s cleaned up
//   (TORRichEdit will throw an error when inserting #13#13#10, for instance)
// We are also scrolling back to the top
var
  S: string;
  ANeedToPostMessage: Boolean;
begin
  if Length(Args) <> 2 then
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Incorrect number of Args');
  if not Args[0].IsType<integer> then // Index: Integer
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Args[0] is not an integer');
  if not Args[1].IsType<string> then // const S: string
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Args[1] is not a string');

  if Args[1].IsEmpty and Self.ReadOnly then Args[1] := ' ';
  S := Args[1].AsType<string>;
  S := StringReplace(S, #13#10, #10, [rfReplaceAll]);
  S := StringReplace(S, #13, '', [rfReplaceAll]);
  Args[1] := S;

  if not IsAutoScrollEnabled and not (csloading in ComponentState) then
  begin
    ANeedToPostMessage := False;
    if FIsVScrollBottomEnabled and (Args[0].AsType<Integer> = Lines.Count) then
    begin
      FIsVScrollBottomEnabled := False;
      ANeedToPostMessage := True;
    end;

    if (not FLockDrawingCalled) and CanFocus then
    begin
      LockDrawing;
      FLockDrawingCalled := True;
      ANeedToPostMessage := True;
    end;

    if ANeedToPostMessage then
      PostMessage(FMessageReceiver.Handle, UM_MESSAGE, 0, 0);
  end;
end;

procedure TORRichEdit.AfterLinesInsert(Sender: TObject);
begin
  FIsVScrollBottomEnabled := True;

  if FLockDrawingCalled then
  begin
    UnlockDrawing;
    FLockDrawingCalled := False;
  end;
end;

function TORRichEdit.StringToRTFString(const S: string): string;
// Format a string to an rtf string compatible with streaming

  function FindUniqueSubText(const AText, ASubText: string): string;
  begin
    Result := ASubText;
    if ContainsText(AText, ASubText) then
    begin
      for var C := 'a' to 'z' do
      begin
        Result := AText + C;
        if not ContainsText(AText, Result) then Exit;
      end;
      Result := FindUniqueSubText(AText, ASubText + 'a');
    end;
  end;

var
  ASubText: string;
begin
  ASubText := FindUniqueSubText(S, '\par');
  Result := StringReplace(StringReplace(StringReplace(StringReplace(StringReplace(
    S, '\', '\\', [rfReplaceAll]),
    #13#10, ASubText, [rfReplaceAll]),
    #13, ASubText, [rfReplaceAll]),
    #10, ASubText, [rfReplaceAll]),
    ASubText, '\par'#13#10, [rfReplaceAll]);
end;

procedure TORRichEdit.AddString(const S: string);
var
  AStream: TStringStream;
begin
  AStream := TStringStream.Create;
  try
    Lines.SaveToStream(AStream);

    if Self.PlainText then
    begin
      AStream.Seek(0, soFromEnd);
      AStream.WriteString(#13#10 + S);
    end
    else begin
      AStream.Seek(-SizeOf('}'#0), soFromEnd);
      AStream.WriteString(StringToRTFString(S) + '}');
    end;

    AStream.Seek(0, soFromBeginning);
    Lines.LoadFromStream(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TORRichEdit.InsertStringBefore(const S: string);

  function RTFHeaderSize(AStream: TStringStream): Integer;
  var
    S: string;
    I, ALengthS: Integer;
    C, D: Char;
    InRTFCode, InMeaninglessSpaces: Boolean;
    InCurlyBracketsCount: Integer;
  begin
    S := AStream.DataString;
    ALengthS := Length(S);
    InCurlyBracketsCount := 1;
    InRTFCode := False;
    InMeaninglessSpaces := False;
    I := 2; // first character is always a {
    while I <= ALengthS do
    begin
      try
        C := S[I]; // C = character at position
        if I < ALengthS then D := S[I + 1]
        else D := #0; // D = next character

        if InCurlyBracketsCount > 1 then
        // Record the level of brackets.
        // Unless we're in outer brackets, we worry about nothing else
        begin
          case C of
            '{': Inc(InCurlyBracketsCount);
            '}': Dec(InCurlyBracketsCount);
          end;
          Continue;
        end;

        if InMeaninglessSpaces then
        // Meaningless spaces are spaces after RTF formatting codes.
        // Just ignore them until we come at a character that's not a space
        begin
          InMeaninglessSpaces := C = ' ';
          if InMeaninglessSpaces then Continue;
        end;

        case C of
        // If we are not yet in curly brackets, this starts us being in curly
        // brackets
          '{':
            begin
              Inc(InCurlyBracketsCount);
              Continue;
            end;
        end;

        if InRTFCode then
        // If we are in an RTF formatting code, we break out when we hit either
        // a space or a CRLF
        begin
          case C of
            ' ':
              begin
                InRTFCode := False;
                InMeaninglessSpaces := True;
              end;
            #13, #10: InRTFCode := False;
          end;
          Continue;
        end;

        if InRTFCode and (C = #13) and (D = #10) then
        begin
          Inc(I); // Advance I an extra character if we find #13#10
          InRTFCode := False; // #13#10 ends RTF formatting codes
          InMeaninglessSpaces := False; // #13#10 ends meaningless spaces
          Continue;
        end;

        if (C = '\') and (D <> '\') then
        // An un-escaped backslash means we are entering an RTF formatting code
        begin
          InRTFCode := True;
          Continue;
        end;

        // We are at the first character that's not in curly brackets, not an
        // rtf formatting code, and not a meaningless space. We've found the
        // end of the header
        if (I > 2) and (Copy(S, I - 2, 2) = #13#10) then
          Exit(I - 3) // The CRLF is part of the actual text
        else
          Exit(I - 1); // strings are 1 based, sizes are 0 based
      finally
        Inc(I); // This ALWAYS runs on Continue (and even on Exit)
      end;
    end;
    raise Exception.Create('AStream does not contain a valid RTF header');
  end;

var
  AStream, BStream: TStringStream;
  AHeaderSize: Integer;
begin
  AStream := TStringStream.Create;
  try
    BStream := TStringStream.Create;
    try
      Lines.SaveToStream(AStream); // Save ARichEdit to AStream
      AHeaderSize := RTFHeaderSize(AStream); // Determine HeaderSize
      AStream.Seek(AHeaderSize, soFromBeginning); // Position cursor on AStream beyond HeaderSize
      BStream.CopyFrom(AStream, AStream.Size - AHeaderSize); // Copy 2nd half of AStream onto BStream
      AStream.Seek(AHeaderSize, soFromBeginning); // Position cursor on AStream beyond HeaderSize
      AStream.WriteString(StringToRTFString(S)); // Insert new text
      BStream.SaveToStream(AStream); // Add BStream to AStream
      AStream.Seek(0, soFromBeginning); // Position AStream to start of stream
      Lines.LoadFromStream(AStream); // Load ARichEdit from AStream
    finally
      FreeAndNil(BStream);
    end;
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TORRichEdit.OnVScroll(var Msg: TMessage);
begin
  if (Msg.WParam = SB_BOTTOM) and not FIsVScrollBottomEnabled then Exit;
  inherited;
end;

constructor TORRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsVScrollBottomEnabled := True;
  FMessageReceiver := TMessageReceiver.Create(AfterLinesInsert);

  FVirtualMethodInterceptor := TVirtualMethodInterceptor.Create
    (Lines.ClassType);

  FVirtualMethodInterceptor.OnBefore :=
    procedure(Instance: TObject; Method: TRttiMethod;
      const Args: TArray<TValue>; out DoInvoke: Boolean; out Result: TValue)
    begin
      if SameText('Insert', Method.Name) then BeforeLinesInsert(Args);
    end;

  FVirtualMethodInterceptor.OnException :=
    procedure(Instance: TObject; Method: TRttiMethod;
      const Args: TArray<TValue>; out RaiseException: Boolean;
      TheException: Exception; out Result: TValue)
    begin
      RaiseException := not SameText('Insert', Method.Name) or
        (TheException.ClassType <> EOutOfResources) or
        (TheException.Message <> sRichEditInsertError);
    end;

  FMustScrollBackLine := -1;

  FVirtualMethodInterceptor.Proxify(Self.Lines);
end;

destructor TORRichEdit.Destroy;
var
  AVirtualMethodInterceptor: TVirtualMethodInterceptor;
begin
  // We have an issue (VISTAOR-37245) reported that makes me wonder if the VMT
  // is not assigned. I don't know how we get there, but I want to make sure we
  // don't generate errors if that happens.
  AVirtualMethodInterceptor := FVirtualMethodInterceptor;
  FVirtualMethodInterceptor := nil;
  if Assigned(AVirtualMethodInterceptor) then
    AVirtualMethodInterceptor.Unproxify(Self.Lines);

  FreeAndNil(AVirtualMethodInterceptor);
  FreeAndNil(FMessageReceiver);
  inherited Destroy;
end;

procedure TORRichEdit.WMKeyDown(var Message: TMessage);
var
  aShiftState: TShiftState;
begin
  aShiftState := KeyDataToShiftState(message.WParam);
  if (ssCtrl in aShiftState) and (message.WParam = Ord('V')) then
    ClipboardFilemanSafe;
  if (ssShift in aShiftState) and (message.WParam = VK_INSERT) then
    ClipboardFilemanSafe;
  inherited;
end;

procedure TORRichEdit.WMPaste(var Message: TMessage);
begin
  ClipboardFilemanSafe;
  inherited;
end;

end.

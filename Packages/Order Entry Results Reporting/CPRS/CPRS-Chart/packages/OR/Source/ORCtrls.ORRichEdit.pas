unit ORCtrls.ORRichEdit;

////////////////////////////////////////////////////////////////////////////////
/// In D11 we started to experience some issues with TRichEdit.
/// 1. TRichEditStrings.Insert introduces a new TOutOfResources error that
///    sometimes gets raised for no valid reason.
/// 2. TRichEdit scrolls to the bottom when the cursor is at the bottom and
///    strings get added. This is undesired behavior in CPRS.
/// 3. TRichEdit captures the mouse in certain situations. (We have reproduced
///    this behavior, and implemented work around behavior, but we don't have a
///    good full understanding of what exactly is happening)
///
/// TORRichEdit was introduced to handle our TRichEdit issues, and all
/// TRichEdits used in CPRS should inherit from TORRichEdit.
///
/// TORRichEdit inherits from TORCopyPasteRichEdit, which is preexisting code
/// that was written to introduce some new code for the copy/paste
/// functionality in CPRS.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  System.Rtti,
  System.Classes,
  Winapi.Messages,
  Vcl.ComCtrls,
  ORCtrls.MessageReceiver;

const
  UM_MESSAGE = WM_USER + 300;

type
  TORCopyPasteRichEdit = class(Vcl.ComCtrls.TRichEdit)
  public
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure WMKeyDown(var Message: TMessage); message WM_KEYDOWN;
  end;

  TMessageNotifyEvent = procedure(Sender: TObject; AMessage: TMessage)
    of object;

  TORRichEdit = class(TORCopyPasteRichEdit)
  strict private
    FMessageReceiver: TMessageReceiver;
    FMustScrollBackLine: Integer;
    FLockDrawingCalled: Boolean;
    FVirtualMethodInterceptor: TVirtualMethodInterceptor;
    FIsAutoScrollEnabled: Boolean;
    FIsVScrollBottomEnabled: Boolean;
  protected
    procedure BeforeLinesInsert(const Args: TArray<TValue>);
    procedure AfterLinesInsert(Sender: TObject; AMessage: TMessage);
    function StringToRTFString(const S: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddString(const S: string);
    procedure InsertStringBefore(const S: string);
    procedure OnVScroll(var Msg: TMessage); message WM_VSCROLL;
  published
    // Toggles auto-scrolling to the bottom after a line is inserted
    property IsAutoScrollEnabled: Boolean read FIsAutoScrollEnabled
      write FIsAutoScrollEnabled default False;
  end;

procedure Register;

implementation

uses
  Vcl.Forms,
  Vcl.ComStrs,
  System.StrUtils,
  System.SysUtils,
  Winapi.Windows,
  ORExtensions;

// TORCopyPasteRichEdit
procedure TORCopyPasteRichEdit.WMKeyDown(var Message: TMessage);
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

procedure TORCopyPasteRichEdit.WMPaste(var Message: TMessage);
begin
  ClipboardFilemanSafe;
  inherited;
end;

// TORRichEdit
constructor TORRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsVScrollBottomEnabled := True;
  
  // Create a reliable way to receive UM_MESSAGE messages. We set up the
  // AfterLinesInsert method as the method that gets called when any UM_MESSAGE
  // notifications come in.
  FMessageReceiver := TMessageReceiver.Create(UM_MESSAGE, AfterLinesInsert);

  FVirtualMethodInterceptor := TVirtualMethodInterceptor.Create
    (Lines.ClassType);

  // Intercept the TORRichEdit.Lines.Insert method before it fires and run
  // procedure BeforeLinesInsert.
  FVirtualMethodInterceptor.OnBefore :=
    procedure(Instance: TObject; Method: TRttiMethod;
      const Args: TArray<TValue>; out DoInvoke: Boolean; out Result: TValue)
    begin
      if SameText('Insert', Method.Name) then BeforeLinesInsert(Args);
    end;

  // Intercept any EOutOfResources exceptions with a message of
  // sRichEditInsertError that were thrown by the TORRichEdit.Lines.Insert
  // method. These exceptions, when they occur, are (usually?) not legit, and
  // we do not want them. This is where we make them disappear.
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

  // Start intercepting
  FVirtualMethodInterceptor.Proxify(Self.Lines);
end;

destructor TORRichEdit.Destroy;
var
  AVirtualMethodInterceptor: TVirtualMethodInterceptor;
begin
  // We have an issue (VISTAOR-37245) reported that makes me wonder if the VMI
  // is not assigned, so here's some (paranoia) code to obtain a local variable
  // reference before further handling.
  AVirtualMethodInterceptor := FVirtualMethodInterceptor;
  FVirtualMethodInterceptor := nil;

  // Stop intercepting
  if Assigned(AVirtualMethodInterceptor) then
    AVirtualMethodInterceptor.Unproxify(Self.Lines);

  FreeAndNil(AVirtualMethodInterceptor);
  FreeAndNil(FMessageReceiver);
  inherited Destroy;
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
  // Sanity check on the passed in Args array
  if Length(Args) <> 2 then
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Incorrect number of Args');
  if not Args[0].IsType<integer> then // Index: Integer
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Args[0] is not an integer');
  if not Args[1].IsType<string> then // const S: string
    raise Exception.Create
      ('ORExtensions RichEdit Fatal Error: Args[1] is not a string');

  // Change an emty string to a space. Empty string inserts can cause errors.
  if Args[1].IsEmpty and Self.ReadOnly then Args[1] := ' ';

  // Replace CRLFs with LFs and remove all leftover CRs
  S := Args[1].AsType<string>;
  S := StringReplace(S, #13#10, #10, [rfReplaceAll]);
  S := StringReplace(S, #13, '', [rfReplaceAll]);
  Args[1] := S;

  // Determine if we need to post a UM_MESSAGE notification
  if not IsAutoScrollEnabled and not (csloading in ComponentState) then
  begin
    ANeedToPostMessage := False;
	// If we don't want the RichEdit autoscrolling to the bottom
	// (new RichEdits may scroll to the bottom under certain circumstances)
	// then we need to discard those WM_VSCROLL messages and post a 
	// UM_MESSAGE to allow those WM_VSCROLL messages to be handled again 
	// when we are done
    if FIsVScrollBottomEnabled and (Args[0].AsType<Integer> = Lines.Count) then
    begin
      FIsVScrollBottomEnabled := False;
      ANeedToPostMessage := True;
    end;

    // If we lock drawing then we need to post a UM_MESSAGE
    if (not FLockDrawingCalled) and CanFocus then
    begin
      LockDrawing;
      FLockDrawingCalled := True;
      ANeedToPostMessage := True;
    end;
	
    // Post a UM_MESSAGE message to our MessageReceiver if we previously
    // determinded we had to post one.
    if ANeedToPostMessage then
      PostMessage(FMessageReceiver.Handle, UM_MESSAGE, 0, 0);
  end;
end;

procedure TORRichEdit.AfterLinesInsert(Sender: TObject; AMessage: TMessage);
// This method gets called when a UM_MESSAGE is received by FMessageReceiver.
// The idea is that we aggregate any number of BeforeLinesInsert responses
// into one single AfterLinesInsert update that only gets done when the Windows
// message queue gets handled. While we may have multiple UM_MESSAGEs on the
// queue for the same TORRichEdit, only the first one will make (all) changes,
// and the others will just not have any effect at all.
begin
  // Allow WM_VSCROLL messages for scrolling to the bottom to be handled again  
  FIsVScrollBottomEnabled := True;
  // Unlock drawing
  if FLockDrawingCalled then
  begin
    UnlockDrawing;
    FLockDrawingCalled := False;
  end;
end;

function TORRichEdit.StringToRTFString(const S: string): string;
// Format a string to an rtf string compatible with streaming. This entails
// changing CRLF, CR, and LF, to \par + CRLF.

  function FindUniqueSubText(const AText, ASubText: string): string;
  // Result is a unique SubText that does not occur in AText. It is the passed
  // in ASubText, if that is unique, or a slight variation of that if ASubText
  // is not unique.
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
  Result := StringReplace(StringReplace(StringReplace(StringReplace(
    StringReplace(S,
    '\', '\\', [rfReplaceAll]),
    #13#10, ASubText, [rfReplaceAll]),
    #13, ASubText, [rfReplaceAll]),
    #10, ASubText, [rfReplaceAll]),
    ASubText, '\par'#13#10, [rfReplaceAll]);
end;

procedure TORRichEdit.AddString(const S: string);
// Add a plain text string to the end of a TORRichEdit by streaming the
// ORRichEdit contents to a Stream, and writing that new string to the end of
// it. This gets around mouse capturing issues with TRichEdit (VISTAOR-37551)
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
// Insert a plain text string at the start of a TORRichEdit by streaming the
// ORRichEdit contents to a Stream, and writing that new string to the beginning
// of it. This gets around mouse capturing issues with TRichEdit (VISTAOR-37551)
// The problem is that an RTF stream starts with a header, so we determine the
// size of the header first, so we can insert the string after the header, and
// before the contents of the TORRichEdit.

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

procedure Register;
begin
  RegisterComponents('CPRS', [TORRichEdit]);
end;

end.

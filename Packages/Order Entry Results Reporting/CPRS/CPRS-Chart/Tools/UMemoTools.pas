unit UMemoTools;

interface
uses
  Winapi.Windows,
  System.Types,
  Vcl.StdCtrls;

type
  TMemoLocation = record
    LineIndex, CharIndex: LResult;
  end;

  TMemoTools = class(TObject)
  strict private
    class function TryFindMemoLocation(AMemo: TCustomMemo; APos: TPoint; out AMemoLocation: TMemoLocation): boolean;
  public
    class function IsWordDelimiter(AChar: Char): Boolean;
    class function CharAtCursor(AMemo: TCustomMemo; APos: TPoint): Char;
    class function WordAtCursor(AMemo: TCustomMemo; APos: TPoint): string;
    class function FindStringAtCursor(AMemo: TCustomMemo; APos: TPoint;
      AString: string; IgnoreCase: Boolean = True): boolean;
    class function FindStringsAtCursor(AMemo: TCustomMemo; APos: TPoint;
      AStrings: TArray<string>; IgnoreCase: Boolean = True): boolean; overload;
    class function FindStringsAtCursor(AMemo: TCustomMemo; APos: TPoint;
      AStrings: TArray<string>; out Index: integer;
      IgnoreCase: Boolean = True): boolean; overload;
  end;

implementation
uses
  System.SysUtils,
  Winapi.RichEdit,
  Winapi.Messages;

class function TMemoTools.IsWordDelimiter(AChar: Char): Boolean;
// Using logic from CopyPaste to determine what characters separate words
begin
  Result := CharInSet(AChar, [#0 .. #$1F, ' ', '.', ',', '?', ':', ';',
    '(', ')', '/', '\']);
end;

class function TMemoTools.TryFindMemoLocation(AMemo: TCustomMemo; APos: TPoint; out AMemoLocation: TMemoLocation): boolean;
// Find the mouse cursor position within the memo, as expressed in Lines and Chars
// This works for TRichEdit, but may need some modification for other Memos
var
  ACharIndex: LResult;
begin
  ACharIndex := AMemo.Perform(EM_CHARFROMPOS, 0, @APos); // Index of Character in Edit. Can't use this directly!
  // If a point is passed to EM_CHARFROMPOS as the lParam and the point is
  // outside the bounds of the edit control, then the lResult is (65535, 65535).
  if ACharIndex >= High(LResult) then Exit(False);
  AMemoLocation.LineIndex := AMemo.Perform(EM_EXLINEFROMCHAR, 0, ACharIndex); // Index of Line the character is on
  AMemoLocation.CharIndex := ACharIndex - AMemo.Perform(EM_LINEINDEX, AMemoLocation.LineIndex, 0); // Index of Character on line
  Result := AMemoLocation.CharIndex > 0;
end;

class function TMemoTools.CharAtCursor(AMemo: TCustomMemo; APos: TPoint): Char;
// Returns the Character underneath the mouse cursor
var
  AMemoLocation: TMemoLocation;
begin
  if not TryFindMemoLocation(AMemo, APos, AMemoLocation) then Exit(#0);
  Result := AMemo.Lines[AMemoLocation.LineIndex][AMemoLocation.CharIndex];
end;

class function TMemoTools.WordAtCursor(AMemo: TCustomMemo; APos: TPoint): string;
// Returns the Word underneath the mouse cursor
var
  AMemoLocation: TMemoLocation;
  ALeftBorder, ARightBorder, ALineLength: Integer;
  ALine: string;
begin
  if not TryFindMemoLocation(AMemo, APos, AMemoLocation) then Exit('');
  ALine := AMemo.Lines[AMemoLocation.LineIndex];

  ALeftBorder := AMemoLocation.CharIndex;
  while (ALeftBorder > 0) and
    (not IsWordDelimiter(ALine[ALeftBorder])) do
    Dec(ALeftBorder);

  ARightBorder := AMemoLocation.CharIndex;
  ALineLength := Length(ALine);
  while (ARightBorder <= ALineLength) and
    (not IsWordDelimiter(ALine[ARightBorder])) do
    Inc(ARightBorder);

  Result := Copy(ALine, ALeftBorder + 1, ARightBorder - 1 - ALeftBorder);
end;

class function TMemoTools.FindStringAtCursor(AMemo: TCustomMemo;
  APos: TPoint; AString: string; IgnoreCase: Boolean = True): boolean;
begin
  Result := FindStringsAtCursor(AMemo, APos, [AString], IgnoreCase);
end;

class function TMemoTools.FindStringsAtCursor(AMemo: TCustomMemo;
  APos: TPoint; AStrings: TArray<string>; IgnoreCase: Boolean = True): boolean;
var
  I: Integer;
begin
  Result := FindStringsAtCursor(AMemo, APos, AStrings, I, IgnoreCase);
end;

class function TMemoTools.FindStringsAtCursor(AMemo: TCustomMemo; APos: TPoint;
  AStrings: TArray<string>; out Index: integer; IgnoreCase: Boolean): boolean;
// This returns true if any of the strings in the AStrings array is found at the
// mouse cursor position
// Index contains the Index in AStrings of the found string.
var
  AMemoLocation: TMemoLocation;
  S, ALine: string;
  I, J: Integer;
begin
  if not TryFindMemoLocation(AMemo, APos, AMemoLocation) then Exit(False);
  ALine := AMemo.Lines[AMemoLocation.LineIndex];

  Result := False;
  Index := -1;
  for J := Low(AStrings) to High(AStrings) do
  begin
    if IgnoreCase then
    begin
      S := AStrings[J].ToUpper;
    end else begin
      S := AStrings[J];
    end;
    I := 0;
    repeat
      if IgnoreCase then
        I := Pos(S, ALine.ToUpper, I + 1)
      else
        I := Pos(S, ALine, I + 1);
      Result := (I > 0) and
        (AMemoLocation.CharIndex >= I) and
        (AMemoLocation.CharIndex < I + Length(S));
      if Result then
      begin
        Index := J;
        Exit;
      end;
    until I <= 0;
  end;
end;

end.


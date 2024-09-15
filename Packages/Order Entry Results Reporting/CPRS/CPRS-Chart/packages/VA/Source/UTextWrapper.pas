unit UTextWrapper;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TTextWrapper = class(TObject)
  private type
    TWrapper = class(TObject)
    strict private
      FInitialText: string;
      FOutput: TStringList;
      FLine: string;
      FMaxLen: Integer;
      FMinLen: Integer;
      FIndent: string;
      FIndentLen: Integer;
      FSplitters: TArray<Char>;
      FNesting: Boolean;
      FNestCount: Integer;
    public
      constructor Create(ANesting: Boolean = False);
      destructor Destroy; override;
      property InitialText: string read FInitialText write FInitialText;
      property Output: TStringList read FOutput write FOutput;
      property Line: string read FLine write FLine;
      property MaxLen: Integer read FMaxLen write FMaxLen;
      property MinLen: Integer read FMinLen write FMinLen;
      property Indent: string read FIndent write FIndent;
      property IndentLen: Integer read FIndentLen write FIndentLen;
      property Splitters: TArray<Char> read FSplitters write FSplitters;
      property Nesting: Boolean read FNesting write FNesting;
      property NestCount: Integer read FNestCount write FNestCount;
    end;
  private
    class var FWrappers: TObjectList<TWrapper>;
    class destructor Destroy;
    class function RetrieveWrapper: TWrapper;
  public
    /// <summary>Starts the process of adding text to a line that wraps as
    ///    needed when the Add procedure is called.  Should always be combined
    ///    in a try/finally statement with RetrieveTextEndWrapping.  All calls
    ///    to BeginWrapping, Add and RetrieveTextEndWrapping should all be made
    ///    in the same thread.</summary>
    /// <param name="InitialText">[<see cref="system|string"/>]
    //     Any initial text you want at the start of the line</param>
    /// <param name="Nested">[<see cref="system|Boolean"/>]
    ///    When Nested is False, a nested call to BeginWrapping will start a new
    ///    line, and after it's corresponding RetrieveTextEndWrapping is called,
    ///    Add will continue to add to the previous line.  When Nested is True,
    ///    all nested calls to BeginWrapping will ignore all passed parameters
    ///    except InitialText (which will be added as normal text).
    ///    Corresponding calls to RetrieveTextEndWrapping will return empty
    ///    strings until the RetrieveTextEndWrapping matching the first
    ///    BeginWrapping is called.  During nesting, all calls to Add will add
    ///    to the same line, regardless of intervening BeginWrapping /
    ///    RetrieveTextEndWrapping calls.</param>
    /// <param name="MaxLength">[<see cref="system|integer"/>]
    ///    How many characters long the line is allowed to reach before it is
    ///    wrapped.</param>
    /// <param name="IndentLength">[<see cref="system|integer"/>]
    ///    When the line wraps, how many spaces to indent subsequent
    ///    lines.</param>
    /// <param name="Splitters">[<see cref="system|string"/>]
    ///    Used at a prioritized list of characters to search for when splitting
    ///    a line.</param>
    class procedure BeginWrapping(InitialText: string; Nested: Boolean;
      MaxLength, IndentLength: Integer; Splitters: TArray<Char>);
    /// <summary>Adds text to the line started with BeginWrapping.  An attempt
    ///    is made to prevent wrapping the line in the middle of the Text if
    ///    possible.</summary>
    /// <param name="Text">[<see cref="system|string"/>]The text to add.</param>
    /// <param name="BeforeText">[<see cref="system|string"/>]
    ///    If any text, other than the InitialText added in the BeginWrapping
    ///    call, has already been added to line, the BeforeText will be added to
    ///    the line prior to adding Text.  This allows for comma or other
    ///    separators.</param>
    class procedure Add(Text: string; BeforeText: string = ' ');
    /// <summary>End the process of adding and wrapping text.</summary>
    /// <returns>[<see cref="system|string"/>] - The entire text created from
    ///    all calls to BeginWrapping and Add.  The return string may contain
    ///    carriage return line feed characters for text wrapping.  If
    ///    BeginWrapping was called with Nested = True, nested calls to
    ///    BeginWrapping / RetrieveTextEndWrapping will return emptry strings
    ///    until the final RetrieveTextEndWrapping is called, which will return
    ///    a cumulation of all lines together.</returns>
    class function RetrieveTextEndWrapping: string;
  end;

implementation

uses
  System.SysUtils;

{ TTextWrapper.TWrapper }

constructor TTextWrapper.TWrapper.Create(ANesting: Boolean);
begin
  inherited Create;
  FOutput := TStringList.Create;
  FNesting := ANesting;
  FNestCount := 1;
end;

destructor TTextWrapper.TWrapper.Destroy;
begin
  FreeAndNil(FOutput);
  inherited;
end;

{ TTextWrapper }

class procedure TTextWrapper.Add(Text, BeforeText: string);
var
  Wrapper: TWrapper;
  UseBeforeText: Boolean;

  procedure WrapLine;
  const
    Alpha = ['a' .. 'z', 'A' .. 'Z', '_'];
    Numbers = ['0' .. '9'];
    AlphaNumeric = Alpha + Numbers;
  var
    i, p, NotAlphaNumbericIdx, NumericIdx, Count, Found: Integer;
    NeedUpdate, done: Boolean;
    Index: array of Integer;
  begin
    if Length(Wrapper.Line) <= Wrapper.MaxLen then
      exit;
    Count := Length(Wrapper.Splitters) + 2;
    NotAlphaNumbericIdx := Count - 2;
    NumericIdx := Count - 1;
    SetLength(Index, Count);
    try
      while Length(Wrapper.Line) > Wrapper.MaxLen do
      begin
        for i := 0 to Count - 1 do
          Index[i] := 0;
        Found := 0;
        done := False;
        for p := Wrapper.MaxLen downto Wrapper.MinLen do
        begin
          for i := 0 to Count - 1 do
          begin
            if Index[i] = 0 then
            begin
              if i = NotAlphaNumbericIdx then
                NeedUpdate := (not CharInSet(Wrapper.Line[p], AlphaNumeric))
              else if i = NumericIdx then
                NeedUpdate := CharInSet(Wrapper.Line[p], Numbers)
              else
                NeedUpdate := (Wrapper.Line[p] = Wrapper.Splitters[i]);
              if NeedUpdate then
              begin
                Index[i] := p;
                if i = 0 then
                  done := True
                else
                begin
                  Inc(Found);
                  if Found >= Count then
                    done := True;
                end;
              end;
            end;
            if done then
              break;
          end;
          if done then
            break;
        end;
        done := False;
        for i := 0 to Count - 1 do
        begin
          p := Index[i];
          if p > 0 then
          begin
            done := True;
            break;
          end;
        end;
        if not done then
          p := Wrapper.MaxLen;
        Wrapper.Output.Add(copy(Wrapper.Line, 1, p).TrimRight);
        Wrapper.Line := Wrapper.Indent + copy(Wrapper.Line, p + 1,
          MaxInt).TrimLeft;
      end;
    finally
      SetLength(Index, 0);
    end;
  end;

  procedure AddToLine;
  begin
    if UseBeforeText then
      Wrapper.Line := Wrapper.Line + BeforeText;
    Wrapper.Line := Wrapper.Line + Text;
  end;

var
  len, blen: Integer;
begin
  if Text = '' then
    exit;
  Wrapper := RetrieveWrapper;
  len := Length(Wrapper.Line);
  if len = 0 then
  begin
    Wrapper.Line := Text;
    if Wrapper.Output.Count > 0 then
      Wrapper.Line := Wrapper.Indent + Wrapper.Line;
    WrapLine;
  end
  else
  begin
    UseBeforeText := (Wrapper.Output.Count > 1) or
      (Wrapper.Line <> Wrapper.InitialText);
    if UseBeforeText then
      blen := Length(BeforeText)
    else
      blen := 0;
    if (len + blen + Length(Text)) > Wrapper.MaxLen then
    begin
      if UseBeforeText then
      begin
        Wrapper.Line := Wrapper.Line + trim(BeforeText);
        Wrapper.Output.Add(Wrapper.Line);
        Wrapper.Line := Wrapper.Indent + Text;
      end
      else
        AddToLine;
      WrapLine;
    end
    else
      AddToLine;
  end;
end;

class procedure TTextWrapper.BeginWrapping(InitialText: string; Nested: Boolean;
  MaxLength, IndentLength: Integer; Splitters: TArray<Char>);
const
  MinLength = 20;
  DefaultSplitters: TArray<Char> = [' '];
var
  MinLen: Integer;
  AWrapper: TWrapper;
begin
  if MaxLength < MinLength then
    raise EArgumentException.CreateFmt('MaxLength (%i) must be at least %i.',
      [MaxLength, MinLength]);
  if IndentLength < 0 then
    IndentLength := 0;
  MinLen := MaxLength div 2;
  if IndentLength >= MinLen then
    raise EArgumentException.CreateFmt('IndentLength (%i) must be less than ' +
      'half the length of MaxLength (%i / 2 = %i)',
      [IndentLength, MaxLength, MinLen]);
  if not assigned(FWrappers) then
    FWrappers := TObjectList<TWrapper>.Create;
  if FWrappers.Count > 0 then
  begin
    AWrapper := FWrappers[FWrappers.Count - 1];
    if AWrapper.Nesting then
      AWrapper.NestCount := AWrapper.NestCount + 1
    else
      AWrapper := nil;
  end
  else
    AWrapper := nil;
  if not assigned(AWrapper) then
  begin
    AWrapper := TWrapper.Create(Nested);
    FWrappers.Add(AWrapper);
    AWrapper.InitialText := InitialText;
    AWrapper.MaxLen := MaxLength;
    AWrapper.MinLen := MinLen;
    AWrapper.Indent := StringOfChar(' ', IndentLength);
    AWrapper.IndentLen := IndentLength;
    AWrapper.Splitters := Splitters;
    if Length(AWrapper.Splitters) = 0 then
      AWrapper.Splitters := DefaultSplitters;
  end;
  Add(InitialText, '');
end;

class destructor TTextWrapper.Destroy;
begin
  FreeAndNil(FWrappers);
end;

class function TTextWrapper.RetrieveTextEndWrapping: string;
var
  Wrapper: TWrapper;
  KeepObj: Boolean;
begin
  Wrapper := RetrieveWrapper;
  if Wrapper.Nesting then
  begin
    Wrapper.NestCount := Wrapper.NestCount - 1;
    KeepObj := (Wrapper.NestCount > 0);
  end
  else
    KeepObj := False;
  if KeepObj then
    Result := ''
  else
  begin
    if trim(Wrapper.Line) <> '' then
      Wrapper.Output.Add(Wrapper.Line);
    Result := TrimRight(Wrapper.Output.Text);
    FWrappers.Delete(FWrappers.Count - 1);
  end;
end;

class function TTextWrapper.RetrieveWrapper: TWrapper;
begin
  if assigned(FWrappers) and (FWrappers.Count > 0) then
    Result := FWrappers[FWrappers.Count - 1]
  else
    raise Exception.Create(ClassName +
      '.BeginWrapping must be called before you can add text.');
end;

end.

{ ******************************************************************************

    ___  __  ____  _  _      _    ____   __   ____  ____  ____
   / __)/  \(  _ \( \/ )    / )  (  _ \ / _\ / ___)(_  _)(  __)
  ( (__(  O )) __/ )  /    / /    ) __//    \\___ \  )(   ) _)
   \___)\__/(__)  (__/    (_/    (__)  \_/\_/(____/ (__) (____)


  Utilities unit

  Components:

  TLogComponent = Handles application logging through out the
  CopyPaste tracking project

  TStopWatch =  Handles timming and allows the ability to gather
  control metrics

  Functions:

  BreakUpLongLines = Breaks a string up so it can be sent via the
  RPC broker

  BreakUpLongListLines = Breake up a stringlist lines at a certain
  length

  DateTimeToFMDateTime = converts a Delphi date/time type to a Fileman
  date/time

  FilteredStringCP = Remove special characters

  Piece =  Returns the Nth piece (PieceNum) of a string delimited by
  Delim

  Pieces =  returns several contiguous pieces

  DelimCount = Return number of delimeters in string

  TrimBlankLines = Removes leading and trailing blank lines from a stringlist

  SetPiece = sets the Nth piece (PieceNum) of a string to NewPiece, adding
  delimiters as necessary

  SetPieces = Sets multiple pieces at once

  { ****************************************************************************** }

unit U_CPTUtils;

interface

Uses
  Classes, System.SyncObjs, Winapi.Windows, System.SysUtils,
  System.DateUtils, Winapi.SHFolder, Vcl.Forms, U_CPTCommon, tom_TLB,
  VCL.Comctrls, Winapi.RichEdit;

type

  TLogfileLevel = (LOG_SUM, LOG_DETAIL);

  TLogComponent = class
  private
    FOwner: TObject;
    FCriticalSection: TCriticalSection;
    fLogToFile: TLogfileLevel;
    fOurLogFile: String;
    function GetLogFileName(): String;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function Dump(Instance: TPasteArray): string;
    procedure LogText(Action, MessageTxt: String);
    property LogToFile: TLogfileLevel read fLogToFile write fLogToFile;
    property LogFile: String read fOurLogFile;
  end;

  TStopWatch = class
  private
    FOwner: TObject;
    fFrequency: TLargeInteger;
    fIsRunning: Boolean;
    fIsHighResolution: Boolean;
    fStartCount, fStopCount: TLargeInteger;
    fActive: Boolean;
    procedure SetTickStamp(var lInt: TLargeInteger);
    function GetElapsedTicks: TLargeInteger;
    function GetElapsedMilliseconds: TLargeInteger;
    Function GetElapsedNanoSeconds: TLargeInteger;
    function GetElapsed: string;
  public
    constructor Create(AOwner: TComponent; const IsActive: Boolean = false;
      const startOnCreate: Boolean = false);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property IsHighResolution: Boolean read fIsHighResolution;
    property ElapsedTicks: TLargeInteger read GetElapsedTicks;
    property ElapsedMilliseconds: TLargeInteger read GetElapsedMilliseconds;
    property ElapsedNanoSeconds: TLargeInteger read GetElapsedNanoSeconds;
    property Elapsed: string read GetElapsed;
    property IsRunning: Boolean read fIsRunning;
  end;

procedure BreakUpLongLines(var SaveList: TStringList; BaseNode: String;
  const OrigList: TStringList; BreakLimit: Integer);

procedure BreakUpLongListLines(var aList: TStringList; BreakLimit: Integer);

function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
function FilteredStringCP(const X: string; ATabWidth: Integer = 8): string;
function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
function Piece(const S: string; Delim: char; PieceNum: Integer): string;
function Pieces(const S: string; Delim: char;
  FirstNum, LastNum: Integer): string;
function DelimCount(const Str, Delim: string): Integer;
procedure TrimBlankLines(const InList: TStrings; OutList: TStrings;
  AllBlanks: Boolean = false);
procedure TrimBlankValueLines(const InList: TStrings; OutList: TStrings;
  AllBlanks: Boolean = false);
procedure SetPiece(var X: string; Delim: char; PieceNum: Integer;
  const NewPiece: string);
procedure SetPieces(var X: string; Delim: char; Pieces: Array of Integer;
  FromString: string);
procedure StatusText(const S: string);
procedure SuspendRichUndo(aRichEdit: TRichEdit; aSuspend: Boolean);

implementation

const
  { names of months used by FormatFMDateTime }
  MONTH_NAMES_SHORT: array [1 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  MONTH_NAMES_LONG: array [1 .. 12] of string = ('January', 'February', 'March',
    'April', 'May', 'June', 'July', 'August', 'September', 'October',
    'November', 'December');

{$REGION 'Misc'}

function Piece(const S: string; Delim: char; PieceNum: Integer): string;
var
  I: Integer;
  Strt, Next: PChar;
begin
  I := 1;
  Strt := PChar(S);
  Next := StrScan(Strt, Delim);
  while (I < PieceNum) and (Next <> nil) do
  begin
    Inc(I);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if I < PieceNum then
    Result := ''
  else
    SetString(Result, Strt, Next - Strt);
end;

function FormatFMDateTime(AFormat: string; ADateTime: Double): string;
var
  X: string;
  Y, m, d, h, n, S: Integer;

  function CharAt(const X: string; APos: Integer): char;
  { returns a character at a given position in a string or the null character if past the end }
  begin
    if Length(X) < APos then
      Result := #0
    else
      Result := X[APos];
  end;

  function TrimFormatCount: Integer;
  { delete repeating characters and count how many were deleted }
  var
    c: char;
  begin
    Result := 0;
    c := AFormat[1];
    repeat
      delete(AFormat, 1, 1);
      Inc(Result);
    until CharAt(AFormat, 1) <> c;
  end;

begin { FormatFMDateTime }
  Result := '';
  if not(ADateTime > 0) then
    Exit;
  X := FloatToStrF(ADateTime, ffFixed, 15, 6) + '0000000';
  Y := StrToIntDef(Copy(X, 1, 3), 0) + 1700;
  m := StrToIntDef(Copy(X, 4, 2), 0);
  d := StrToIntDef(Copy(X, 6, 2), 0);
  h := StrToIntDef(Copy(X, 9, 2), 0);
  n := StrToIntDef(Copy(X, 11, 2), 0);
  S := StrToIntDef(Copy(X, 13, 2), 0);
  while Length(AFormat) > 0 do
  begin
    case UpCase(AFormat[1]) of
      '"':
        begin // literal
          delete(AFormat, 1, 1);
          while not(CharInSet(CharAt(AFormat, 1), [#0, '"'])) do
          begin
            Result := Result + AFormat[1];
            delete(AFormat, 1, 1);
          end;
          if CharAt(AFormat, 1) = '"' then
            delete(AFormat, 1, 1);
        end;
      'D':
        case TrimFormatCount of // day/date
          1:
            if d > 0 then
              Result := Result + IntToStr(d);
          2:
            if d > 0 then
              Result := Result + FormatFloat('00', d);
        end;
      'H':
        case TrimFormatCount of // hour
          1:
            Result := Result + IntToStr(h);
          2:
            Result := Result + FormatFloat('00', h);
        end;
      'M':
        case TrimFormatCount of // month
          1:
            if m > 0 then
              Result := Result + IntToStr(m);
          2:
            if m > 0 then
              Result := Result + FormatFloat('00', m);
          3:
            if m in [1 .. 12] then
              Result := Result + MONTH_NAMES_SHORT[m];
          4:
            if m in [1 .. 12] then
              Result := Result + MONTH_NAMES_LONG[m];
        end;
      'N':
        case TrimFormatCount of // minute
          1:
            Result := Result + IntToStr(n);
          2:
            Result := Result + FormatFloat('00', n);
        end;
      'S':
        case TrimFormatCount of // second
          1:
            Result := Result + IntToStr(S);
          2:
            Result := Result + FormatFloat('00', S);
        end;
      'Y':
        case TrimFormatCount of // year
          2:
            if Y > 0 then
              Result := Result + Copy(IntToStr(Y), 3, 2);
          4:
            if Y > 0 then
              Result := Result + IntToStr(Y);
        end;
    else
      begin // other
        Result := Result + AFormat[1];
        delete(AFormat, 1, 1);
      end;
    end; { case }
  end;
end; { FormatFMDateTime }

function DateTimeToFMDateTime(ADateTime: TDateTime): Double;
var
  Y, m, d, h, n, S, l: Word;
  DatePart, TimePart: Integer;
begin
  DecodeDate(ADateTime, Y, m, d);
  DecodeTime(ADateTime, h, n, S, l);
  DatePart := ((Y - 1700) * 10000) + (m * 100) + d;
  TimePart := (h * 10000) + (n * 100) + S;
  Result := DatePart + (TimePart / 1000000);
end;

function FilteredStringCP(const X: string; ATabWidth: Integer = 8): string;
var
  I, J: Integer;
  c: char;
begin
  Result := '';
  for I := 1 to Length(X) do
  begin
    c := X[I];
    if c = #9 then
    begin
      for J := 1 to (ATabWidth - (Length(Result) mod ATabWidth)) do
        Result := Result + ' ';
    end
    else if CharInSet(c, [#32 .. #127]) then
    begin
      Result := Result + c;
    end
    else if CharInSet(c, [#10, #13, #160]) then
    begin
      Result := Result + ' ';
    end
    else if CharInSet(c, [#128 .. #159]) then
    begin
      Result := Result + '?';
    end
    else if CharInSet(c, [#161 .. #255]) then
    begin
      Result := Result + X[I];
    end;
  end;

  if Copy(Result, Length(Result), 1) = ' ' then
    Result := TrimRight(Result) + ' ';
end;

procedure BreakUpLongLines(var SaveList: TStringList; BaseNode: String;
  const OrigList: TStringList; BreakLimit: Integer);
const
  BreakChars = [' ', '-'];
var
  BrCnt, I, Z, LastBreakPos: Integer;
  LineText: WideString;
  BrokenUpList: TStringList;

begin

  BrokenUpList := TStringList.Create;
  try
    BrCnt := 0;
    for I := 0 to OrigList.Count - 1 do
    begin
      // break up long lines for the save
      if Length(OrigList[I]) > BreakLimit then
      begin
        // break this line up
        LineText := OrigList[I];

        // loop through and break up line at FBreakUpLimit
        while Length(LineText) > BreakLimit do
        begin
          Inc(BrCnt);
          LastBreakPos := BreakLimit;

          if not CharInSet(LineText[BreakLimit + 1], BreakChars) then
          begin
            for Z := BreakLimit downto 1 do
              if LineText[Z] = ' ' then
              begin
                LastBreakPos := Z;
                Break;
              end;
          end;

          BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
            FilteredStringCP(Copy(LineText, 1, LastBreakPos)));
          LineText := Copy(LineText, LastBreakPos + 1, Length(LineText));

        end;
        // add any remainder
        if Length(LineText) > 0 then
        begin
          Inc(BrCnt);
          BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
            FilteredStringCP(LineText));
        end;
      end
      else
      begin
        Inc(BrCnt);
        BrokenUpList.Add(BaseNode + ',' + IntToStr(BrCnt) + '=' +
          FilteredStringCP(OrigList[I]));
      end;

    end;

    // add our final line count
    SaveList.Add(BaseNode + ',-1=' + IntToStr(BrCnt));
    // Add our text
    for I := 0 to BrokenUpList.Count - 1 do
      SaveList.Add(BrokenUpList.Strings[I]);

  finally
    BrokenUpList.Free;
  end;
end;

procedure BreakUpLongListLines(var aList: TStringList; BreakLimit: Integer);
const
  BreakChars = [' ', '-'];
var
  I, Z, LastBreakPos: Integer;
  LineText: WideString;
  WithWraps: TStringList;
begin
  WithWraps := TStringList.Create;
  try
    for I := 0 to aList.Count - 1 do
    begin
      // break up long lines for the save
      if Length(aList[I]) > BreakLimit then
      begin
        // WithWraps.Add( WrapText(aList[I], #13#10,BreakChars, BreakLimit));

        // break this line up
        LineText := aList[I];

        // loop through and break up line at FBreakUpLimit
        while Length(LineText) > BreakLimit do
        begin
          LastBreakPos := BreakLimit;

          if not CharInSet(LineText[BreakLimit + 1], BreakChars) then
          begin
            for Z := BreakLimit downto 1 do
              if LineText[Z] = ' ' then
              begin
                LastBreakPos := Z;
                Break;
              end;
          end;

          WithWraps.Add(FilteredStringCP(Copy(LineText, 1, LastBreakPos)));
          LineText := Copy(LineText, LastBreakPos + 1, Length(LineText));

        end;
        // add any remainder
        if Length(LineText) > 0 then
        begin;
          WithWraps.Add(FilteredStringCP(LineText));
        end;
      end
      else
      begin
        WithWraps.Add(FilteredStringCP(aList[I]));
      end;

    end;
    aList.Assign(WithWraps);
  finally
    WithWraps.Free;
  end;

end;

procedure TrimBlankValueLines(const InList: TStrings; OutList: TStrings;
  AllBlanks: Boolean = false);
var
  I, X, Y, MainCnt, SubCnt, UpdateCnt, UpdateMain, UpdateCntMain: Integer;
  StartCopy, txtFound: Boolean;
begin
  OutList.Clear;

  MainCnt := StrToIntDef(InList.Values['(0)'], 0);
  UpdateMain := 1;
  UpdateCntMain := 0;
  for I := 1 to MainCnt do
  begin
    StartCopy := false;
    UpdateCnt := 0;
    SubCnt := StrToIntDef(InList.Values['(' + IntToStr(I) + ',0)'], 0);

    for X := 1 to SubCnt do
    begin
      if AllBlanks then
        StartCopy := false;

      If Trim(InList.Values['(' + IntToStr(I) + ',' + IntToStr(X) + ')']) <> ''
      then
        StartCopy := true;

      if not AllBlanks then
      begin
        if StartCopy then
        begin
          // Look ahead for text
          txtFound := false;
          for Y := X + 1 to SubCnt do
          begin
            if Trim(InList.Values['(' + IntToStr(I) + ',' + IntToStr(Y) + ')'])
              <> '' then
            begin
              // We found text so we know we are not at the end
              txtFound := true;
              Break;
            end;

          end;

          // the rest is blank so we are done adding
          if not txtFound then
          begin
            Inc(UpdateCnt);
            OutList.Add('(' + IntToStr(UpdateMain) + ',' + IntToStr(UpdateCnt) +
              ')=' + InList.Values['(' + IntToStr(I) + ',' +
              IntToStr(X) + ')']);

            Break;
          end;
        end;
      end;

      if StartCopy then
      begin
        Inc(UpdateCnt);
        OutList.Add('(' + IntToStr(UpdateMain) + ',' + IntToStr(UpdateCnt) +
          ')=' + InList.Values['(' + IntToStr(I) + ',' + IntToStr(X) + ')']);
      end;

    end;
    if UpdateCnt > 0 then
    begin
      OutList.Add('(' + IntToStr(UpdateMain) + ',0)=' + IntToStr(UpdateCnt));
      Inc(UpdateMain);
      Inc(UpdateCntMain);
    end;
  end;
  OutList.Add('(0)=' + IntToStr(UpdateCntMain));
end;

procedure TrimBlankLines(const InList: TStrings; OutList: TStrings;
  AllBlanks: Boolean = false);
var
  I, X: Integer;
  StartCopy, txtFound: Boolean;
begin
  { if CheckValuesOnly then
    begin
    if Trim(InList.ValueFromIndex[i]) <> '' then
    StartCopy := True
    end }
  OutList.Clear;

  StartCopy := false;
  for I := 0 to InList.Count - 1 do
  begin
    if AllBlanks then
      StartCopy := false;

    if Trim(InList.Strings[I]) <> '' then
      StartCopy := true;

    if not AllBlanks then
    begin
      if StartCopy then
      begin
        // Look ahead for text
        txtFound := false;
        for X := I + 1 to InList.Count - 1 do
        begin
          if Trim(InList.Strings[X]) <> '' then
          begin
            // We found text so we know we are not at the end
            txtFound := true;
            Break;
          end;

        end;

        // the rest is blank so we are done adding
        if not txtFound then
        begin
          OutList.Add(InList.Strings[I]);
          Break;
        end;
      end;
    end;

    if StartCopy then
      OutList.Add(InList.Strings[I])
  end;

end;

function DelimCount(const Str, Delim: string): Integer;
var
  I, dlen, slen: Integer;

begin
  Result := 0;
  I := 1;
  dlen := Length(Delim);
  slen := Length(Str) - dlen + 1;
  while (I <= slen) do
  begin
    if (Copy(Str, I, dlen) = Delim) then
    begin
      Inc(Result);
      Inc(I, dlen);
    end
    else
      Inc(I);
  end;
end;

function Pieces(const S: string; Delim: char;
  FirstNum, LastNum: Integer): string;
{ returns several contiguous pieces }
var
  PieceNum: Integer;
begin
  Result := '';
  for PieceNum := FirstNum to LastNum do
    Result := Result + Piece(S, Delim, PieceNum) + Delim;
  if Length(Result) > 0 then
    delete(Result, Length(Result), 1);
end;

procedure SetPiece(var X: string; Delim: char; PieceNum: Integer;
  const NewPiece: string);
{ sets the Nth piece (PieceNum) of a string to NewPiece, adding delimiters as necessary }
var
  I: Integer;
  Strt, Next: PChar;
begin
  I := 1;
  Strt := PChar(X);
  Next := StrScan(Strt, Delim);
  while (I < PieceNum) and (Next <> nil) do
  begin
    Inc(I);
    Strt := Next + 1;
    Next := StrScan(Strt, Delim);
  end;
  if Next = nil then
    Next := StrEnd(Strt);
  if I < PieceNum then
    X := X + StringOfChar(Delim, PieceNum - I) + NewPiece
  else
    X := Copy(X, 1, Strt - PChar(X)) + NewPiece + StrPas(Next);
end;

procedure SetPieces(var X: string; Delim: char; Pieces: Array of Integer;
  FromString: string);
var
  I: Integer;

begin
  for I := low(Pieces) to high(Pieces) do
    SetPiece(X, Delim, Pieces[I], Piece(FromString, Delim, Pieces[I]));
end;

procedure StatusText(const S: string);
{ sends a user defined message to the main window of an application to display the text
  found in lParam.  Only useful if the main window has message event for this message }
begin
  if (Application.MainForm <> nil) and (Application.MainForm.HandleAllocated)
  then
    SendMessage(Application.MainForm.Handle, UM_STATUSTEXT, 0,
      Integer(PChar(S)));
end;

{$ENDREGION}
{$REGION 'TStopWatch'}

Const
  NSecsPerSec = 1000000000;

constructor TStopWatch.Create(AOwner: TComponent;
  const IsActive: Boolean = false; const startOnCreate: Boolean = false);
begin
  inherited Create();
  FOwner := AOwner;
  fIsRunning := false;
  fActive := IsActive;
  fIsHighResolution := QueryPerformanceFrequency(fFrequency);
  if NOT fIsHighResolution then
    fFrequency := MSecsPerSec;

  if startOnCreate then
    Start;
end;

destructor TStopWatch.Destroy;
begin
  Stop;
  inherited Destroy;
end;

function TStopWatch.GetElapsedTicks: TLargeInteger;
begin
  Result := fStopCount - fStartCount;
end;

procedure TStopWatch.SetTickStamp(var lInt: TLargeInteger);
begin
  if fIsHighResolution then
    QueryPerformanceCounter(lInt)
  else
    lInt := MilliSecondOf(Now);
end;

function TStopWatch.GetElapsed: string;
begin
  Result := FloatToStr(ElapsedMilliseconds / 1000) + ' Sec / ' +
    FloatToStr(ElapsedMilliseconds) + ' Ms / ' +
    FloatToStr(ElapsedNanoSeconds) + ' Ns';
end;

function TStopWatch.GetElapsedMilliseconds: TLargeInteger;
var
  Crnt: TLargeInteger;
begin
  if fIsRunning then
  begin
    SetTickStamp(Crnt);
    Result := (MSecsPerSec * (Crnt - fStartCount)) div fFrequency;
  end
  else
    Result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

function TStopWatch.GetElapsedNanoSeconds: TLargeInteger;
begin
  Result := (NSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  if fActive then
  begin
    SetTickStamp(fStartCount);
    fIsRunning := true;
  end;
end;

procedure TStopWatch.Stop;
begin
  if fActive then
  begin
    SetTickStamp(fStopCount);
    fIsRunning := false;
  end;
end;
{$ENDREGION}
{$REGION 'TLogComponent'}

constructor TLogComponent.Create(AOwner: TComponent);
begin
  inherited Create();
  FOwner := AOwner;
  FCriticalSection := TCriticalSection.Create;
end;

destructor TLogComponent.Destroy;
begin
  FCriticalSection.Free;
  inherited Destroy;
end;

function TLogComponent.Dump(Instance: TPasteArray): string;
var
  I: Integer;

  function DumpRecordPasteRec(RecToUse: TPasteText): String;
  var
    X, Y: Integer;
  begin
    Result := '[RecToUse.CopiedFromApplication]: ' +
      RecToUse.CopiedFromApplication;
    Result := Result + #13#10 + '[RecToUse.CopiedFromAuthor]: ' +
      RecToUse.CopiedFromAuthor;
    Result := Result + #13#10 + '[RecToUse.CopiedFromDocument]: ' +
      RecToUse.CopiedFromDocument;
    Result := Result + #13#10 + '[RecToUse.CopiedFromLocation]: ' +
      RecToUse.CopiedFromLocation;
    Result := Result + #13#10 + '[RecToUse.CopiedFromPatient]: ' +
      RecToUse.CopiedFromPatient;
    Result := Result + #13#10 + '[RecToUse.DateTimeOfPaste]: ' +
      RecToUse.DateTimeOfPaste;
    Result := Result + #13#10 + '[RecToUse.DateTimeOfOriginalDoc]: ' +
      RecToUse.DateTimeOfOriginalDoc;
    Result := Result + #13#10 + '[RecToUse.GroupItems]';
    for X := Low(RecToUse.GroupItems) to High(RecToUse.GroupItems) do
    begin
      with RecToUse.GroupItems[X] do
      begin
        Result := Result + #13#10#9 + '[GroupParent]' + BoolToStr(GroupParent);
        Result := Result + #13#10#9 + '[GroupText]' + GroupText.Text;
        Result := Result + #13#10#9 + '[GroupParent]' + IntToStr(ItemIEN);
        Result := Result + #13#10#9 + '[VisibleOnNote]' +
          BoolToStr(VisibleOnNote);
        Result := Result + #13#10#9 + '[HiglightLines]:';
        for Y := Low(HiglightLines) to High(HiglightLines) do
        begin
          Result := Result + #13#10#9#9 + '[LineToHighlight]: ' + HiglightLines
            [Y].LineToHighlight;
          Result := Result + #13#10#9#9 + '[LineToHighlight]: ' +
            BoolToStr(HiglightLines[Y].AboveWrdCnt);
        end;
      end;
    end;
    Result := Result + #13#10 + '[HiglightLines]:';
    for Y := Low(RecToUse.HiglightLines) to High(RecToUse.HiglightLines) do
    begin
      Result := Result + #13#10#9 + '[LineToHighlight]: ' +
        RecToUse.HiglightLines[Y].LineToHighlight;
      Result := Result + #13#10#9 + '[LineToHighlight]: ' +
        BoolToStr(RecToUse.HiglightLines[Y].AboveWrdCnt);
    end;
    Result := Result + #13#10 + '[RecToUse.IdentFired]: ' +
      BoolToStr(RecToUse.IdentFired);
    Result := Result + #13#10 + '[RecToUse.InfoPanelIndex]: ' +
      IntToStr(RecToUse.InfoPanelIndex);

    if RecToUse.Status = PasteNew then
      Result := Result + #13#10 + '[RecToUse.Status]: PasteNew'
    else if RecToUse.Status = PasteModify then
      Result := Result + #13#10 + '[RecToUse.Status]: PasteModify'
    else if RecToUse.Status = PasteNA then
      Result := Result + #13#10 + '[RecToUse.Status]: PasteNA';

    if Assigned(RecToUse.OriginalText) then
      Result := Result + #13#10 + '[RecToUse.OriginalText]: ' +
        RecToUse.OriginalText.Text;
    Result := Result + #13#10 + '[RecToUse.PasteDBID]: ' +
      IntToStr(RecToUse.PasteDBID);
    Result := Result + #13#10 + '[RecToUse.PastedPercentage]: ' +
      RecToUse.PastedPercentage;
    Result := Result + #13#10 + '[RecToUse.PastedText]: ' +
      RecToUse.PastedText.Text;
    Result := Result + #13#10 + '[RecToUse.UserWhoPasted]: ' +
      RecToUse.UserWhoPasted;
    Result := Result + #13#10 + '[RecToUse.VisibleOnList]: ' +
      BoolToStr(RecToUse.VisibleOnList);
    Result := Result + #13#10 + '[RecToUse.VisibleOnNote]: ' +
      BoolToStr(RecToUse.VisibleOnNote);
  end;

begin
  Result := '';
  for I := Low(Instance) to High(Instance) do
    Result := Result + '(' + IntToStr(I) + ')' + DumpRecordPasteRec(Instance[I]
      ) + #13#10;
end;

function TLogComponent.GetLogFileName(): String;
Var
  OurLogFile, LocalOnly, AppDir: string;

  // Finds the users special directory
  function LocalAppDataPath: string;
  const
    SHGFP_TYPE_CURRENT = 0;
  var
    path: array [0 .. MAX_PATH] of char;
  begin
    SHGetFolderPath(0, CSIDL_LOCAL_APPDATA, 0, SHGFP_TYPE_CURRENT, @path[0]);
    Result := StrPas(path);
  end;

begin
  OurLogFile := LocalAppDataPath;
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';

  LocalOnly := OurLogFile;

  // Now set the application level
  OurLogFile := OurLogFile + ExtractFileName(Application.ExeName);
  if (Copy(OurLogFile, Length(OurLogFile), 1) <> '\') then
    OurLogFile := OurLogFile + '\';
  AppDir := OurLogFile;

  // try to create or use base direcrtory
  if not DirectoryExists(AppDir) then
    if not ForceDirectories(AppDir) then
      OurLogFile := LocalOnly;

  OurLogFile := OurLogFile + 'CPRS_' + IntToStr(GetCurrentProcessID)
  { FormatDateTime('hhmmsszz', now) } + '_CopyPaste.TXT';

  Result := OurLogFile;
end;

procedure TLogComponent.LogText(Action, MessageTxt: string);
const
  PadLen: Integer = 18;
VAR
  AddText: TStringList;
  FS: TFileStream;
  Flags: Word;
  X, CenterPad: Integer;
  TextToAdd, Suffix, Suffix2: String;
begin
  FCriticalSection.Enter;
  try
    if Trim(fOurLogFile) = '' then
      fOurLogFile := GetLogFileName;

    If FileExists(fOurLogFile) then
      Flags := fmOpenReadWrite
    else
      Flags := fmCreate;

    AddText := TStringList.Create;
    try
      AddText.Text := MessageTxt;

      if UpperCase(Action) = 'TEXT' then
      begin
        Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
          UpperCase(Action) + ']';
        for X := 1 to AddText.Count - 1 do
        begin
          Suffix2 := '[' + IntToStr(X) + ' of ' +
            IntToStr(AddText.Count - 1) + ']';
          // center text
          CenterPad := round((PadLen - Length(Suffix2)) / 2);
          Suffix2 := StringOfChar(' ', CenterPad) + Suffix2;
          AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
            AddText.Strings[X];
        end;
      end
      else
      begin
        Suffix := FormatDateTime('hh:mm:ss', Now) + ' [' +
          UpperCase(Action) + ']';
        if AddText.Count > 1 then
        begin
          Suffix2 := FormatDateTime('hh:mm:ss', Now) + ' [' +
            StringOfChar('^', Length(Action)) + ']';
          for X := 1 to AddText.Count - 1 do
            AddText.Strings[X] := Suffix2.PadRight(PadLen) + ' - ' +
              AddText.Strings[X];
        end;
      end;
      TextToAdd := Suffix.PadRight(PadLen) + ' - ' + AddText.Text;

      FS := TFileStream.Create(fOurLogFile, Flags);
      try
        FS.Position := FS.Size;
        FS.Write(TextToAdd[1], Length(TextToAdd) * SizeOf(char));
      finally
        FS.Free;
      end;
    finally
      AddText.Free;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

{$ENDREGION}

procedure SuspendRichUndo(aRichEdit: TRichEdit; aSuspend: Boolean);
var
   IText: ITextDocument;
   IOLE: IUnknown;
begin
   if ARichEdit = nil then
    exit;

   ARichEdit.perform(EM_GETOLEINTERFACE, 0, integer(@IOLE));

   IOLE.QueryInterface(ITextDocument, IText);

   if aSuspend then
      IText.Undo(Integer(tomSuspend))
   else
      IText.Undo(Integer(tomResume));

end;
end.


unit VAShared.UTStringsHelper;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.Math,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VAUtils;

type
  TSortDir = (DIR_FRWRD, DIR_BKWRD);
  TSortArray = TArray<TSortDir>;

  TVAStringsHelper = class helper for TStrings
  public
    class var FSortTypeKind: TArray<System.TTypeKind>;
    class var FSortPieceNum: TArray<Integer>;
    class var FSortDir: TSortArray;
    class var FSortADelim: Char;
    /// <summary>
    /// Returns the index of the first string in the list,
    /// AFTER the StartIdx, where the PieceNum piece matches,
    /// case insensitively, the indicated Value
    /// </summary>
    /// <param name="Value">The Value to search for (case insensitively)</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name=" PieceNum">The number of the piece to search for</param>
    /// <param name=" StartIdx">Start index BEFORE the search begins,
    /// to start at the first index use -1</param>
    /// <returns>The index of the matching string, or -1 if not found</returns>
    function CaseInsensitiveIndexOfPiece(Value: string; Delim: Char = U;
      PieceNum: Integer = 1; StartIdx: Integer = -1): Integer;
    /// <summary>
    /// Returns True if the trimmed Value matches the trimmed PieceNum piece
    /// of any string in the list
    /// </summary>
    /// <param name="Value">The Value to trim and search for</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name=" PieceNum">The number of the piece to search for</param>
    function ContainsStringAtPiece(const Value: String; Delim: Char;
      const PieceNum: Integer): Boolean;
    /// <summary>Finds the first index of a string in the list where a specified
    /// substring can be found, case insensitively, anwhere in the string</summary>
    /// <param name="SubStr">Substring to search for</param>
    /// <returns>The first index where the substring was found, or -1 if not found</returns>
    function FuzzyIndexOf(const SubStr: String): Integer;
    /// <summary>
    /// Returns the index of the first string in the list, AFTER the StartIdx,
    /// where the PieceNum piece matches the indicated Value</summary>
    /// <param name="Value">The Value to search for</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name=" PieceNum">The number of the piece to search for</param>
    /// <param name=" StartIdx">Start index BEFORE the search begins,
    /// to start at the first index use -1 </param>
    /// <returns>The index of the matching string, or -1 if not found</returns>
    function IndexOfPiece(Value: string; Delim: Char = U; PieceNum: Integer = 1;
      StartIdx: Integer = -1): Integer;
    /// <summary>
    /// Returns the index of the first string in the list where all the Values
    /// match the 1st, 2nd, 3rd etc. '^' delimited pieces</summary>
    /// <param name="Values">An array of values to search for</param>
    /// <returns>The index of the matching string, or -1 if not found</returns>
    function IndexOfPieces(const Values: array of string): Integer; overload;
    /// <summary>
    /// Returns the index of the first string in the list, AFTER the StartIdx,
    /// where all the Values match the 1st, 2nd, 3rd etc. '^' delimited pieces</summary>
    /// <param name="Values">An array of values to search for</param>
    /// <param name=" StartIdx">Start index BEFORE the search begins,
    /// to start at the first index use -1 </param>
    /// <returns>The index of the matching string, or -1 if not found</returns>
    function IndexOfPieces(const Values: array of string; StartIdx: Integer)
      : Integer; overload;
    /// <summary>
    /// Returns the index of the first string in the list, AFTER the StartIdx,
    /// where all the requested Pieces match the cooresponding Values</summary>
    /// <param name="Values">An array of values to search for</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name=" Pieces">An array of piece numbers cooresponding to the
    /// the passed in Values</param>
    /// <param name=" StartIdx">Start index BEFORE the search begins,
    /// to start at the first index use -1 </param>
    /// <returns>The index of the matching string, or -1 if not found</returns>
    function IndexOfPieces(const Values: array of string; const Delim: Char;
      const Pieces: array of Integer; StartIdx: Integer = -1): Integer;
      overload;
    /// <summary>Finds the index of the string while stripping the spaces</summary>
    /// <param name="SubStr">Sub string that we want to find (should not have spaces)</param>
    /// <param name="OffSet">defines our starting position for the search</param>
    /// <returns>The index of the string, or -1 if not found</returns>
    function IndexOfStrippedString(const SubStr: string;
      OffSet: Integer = 0): Integer;
    /// <summary>Finds the index where a specific substring exist</summary>
    /// <param name="SubStr">Substring to search for</param>
    /// <param name="OffSet">The starting point to begin the search</param>
    /// <param name="CaseSensitive">Perform case sensitive search</param>
    /// <returns>The first index where the substring was found, or -1 if not found</returns>
    function IndexOfSubString(const SubStr: string; OffSet: Integer = 0;
      CaseSensitive: Boolean = False): Integer;
    /// <summary>Frees and nils all objects in the Objects property</summary>
    procedure KillObjects;
      deprecated 'use OwnsObjects, Clear, and/or FreeAndNil';
    /// <summary>Returns True if all Values match the 1st, 2nd, 3rd etc. '^'
    /// delimited pieces in the string at the specified index</summary>
    /// <param name="Index">The index of the string in the list to compare against</param>
    /// <param name="Values">An array of values to compare</param>
    function PiecesEqual(const Index: Integer; const Values: array of string)
      : Boolean; overload;
    /// <summary>Returns True if all Values match the cooresponding '^' delimited
    /// Pieces in the string at the specified index</summary>
    /// <param name="Index">The index of the string in the list to compare against</param>
    /// <param name="Values">An array of values to compare</param>
    /// <param name=" Pieces">An array of piece numbers cooresponding to the
    /// the passed in Values</param>
    function PiecesEqual(const Index: Integer; const Values: array of string;
      const Pieces: array of Integer): Boolean; overload;
    /// <summary>Returns True if all Values match the cooresponding Pieces in the
    /// string at the specified index</summary>
    /// <param name="Index">The index of the string in the list to compare against</param>
    /// <param name="Values">An array of values to compare</param>
    /// <param name=" Pieces">An array of piece numbers cooresponding to the
    /// the passed in Values</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    function PiecesEqual(const Index: Integer; const Values: array of string;
      const Pieces: array of Integer; const Delim: Char): Boolean; overload;
    /// <summary>Return unedited raw text (without non existent EOL markers) from TStrings</summary>
    /// <returns>Unedited raw text (without non existent EOL markers)</returns>
    function RawText: String;
    /// <summary>Sets the PieceNum '^' delimited piece of the string at the specified Index</summary>
    /// <param name="Index">The index of the string to modify</param>
    /// <param name="PieceNum">The number of the piece to modify</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name="NewValue">The new value of the piece</param>
    procedure SetStrPiece(Index, PieceNum: Integer;
      const NewValue: string); overload;
    /// <summary>Sets the PieceNum piece of the string at the specified Index</summary>
    /// <param name="Index">The index of the string to modify</param>
    /// <param name="PieceNum">The number of the piece to modify</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    /// <param name="NewValue">The new value of the piece</param>
    procedure SetStrPiece(Index, PieceNum: Integer; Delim: Char;
      const NewValue: string); overload;
    /// <summary>Retrieves a set of strings from a specific index on</summary>
    /// <param name="ReturnList">Return list where the strings should be placed</param>
    /// <param name="OffSet">Index to start processing at</param>
    /// <param name="Linecnt">How many lines to go past the Offset</param>
    Procedure StringsByNum(ReturnList: TStringList; OffSet: Integer = 0;
      Linecnt: Integer = 1);
    /// <summary>Sorts a non-sorted list by piece number</summary>
    /// <param name="<T>">Type sort (string, Integer, Float)</param>
    /// <param name="PieceNum">The piece number to use for sorting</param>
    /// <param name="aDelim">The delimiter character that separates each piece</param>
    /// <param name="aSortDir">The direction to sort (DIR_FRWRD, DIR_BKWRD)</param>
    procedure SortByDelimiter<T>(PieceNum: Integer; aDelim: Char = U; aSortDir:
      tSortDir = DIR_FRWRD);
    /// <summary>Sorts a non-sorted list by multiple piece numbers, case insensitively</summary>
    /// <param name="Pieces">The piece number(s) to use for sorting</param>
    /// <param name="PieceTypes">The types of each peice to sort</param>
    /// <param name="aDelim">The delimiter character that separates each piece</param>
    /// <param name="aSortDir">The direction(s) to sort (DIR_FRWRD, DIR_BKWRD)</param>
    procedure SortByDelimiters(const Pieces: TArray<Integer>; const PieceTypes: TArray<TTypeKind> = nil; aDelim: Char = U;
    const aSortDir: TSortArray = nil);
  end;

  TVAStringListHelper = class helper for TStringList
  public
    /// <summary>Removes duplicate entries</summary>
    procedure RemoveDuplicates;
    /// <summary>Sorts a non-sorted list by piece number</summary>
    /// <param name="PieceNum">The piece number to use for sorting</param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    procedure SortByPiece(PieceNum: Integer; Delim: Char = U);   deprecated 'Use SortByDelimeter instead';
    /// <summary>Sorts a non-sorted list by multiple piece numbers, case insensitively</summary>
    /// <param name="Pieces">An array of piece numbers to use for sorting/param>
    /// <param name="Delim">The delimiter character that separates each piece</param>
    procedure SortByPieces(Pieces: array of Integer; Delim: Char = U);   deprecated 'Use SortByDelimeters instead';
  end;

  function CustomSortByDelimiters(List: tStringList; Index1, Index2: Integer): Integer;

implementation

uses
  VAPieceHelper;

{ TVAStringsHelper }

function TVAStringsHelper.CaseInsensitiveIndexOfPiece(Value: string;
  Delim: Char; PieceNum, StartIdx: Integer): Integer;
begin
  Result := StartIdx;
  inc(Result);
  while ((Result >= 0) and (Result < Count) and
    (CompareText(Piece(Strings[Result], Delim, PieceNum), Value) <> 0)) do
    inc(Result);
  if (Result < 0) or (Result >= Count) then
    Result := -1;
end;

// Looks for given text at a specific piece
function TVAStringsHelper.ContainsStringAtPiece(const Value: String;
  Delim: Char; const PieceNum: Integer): Boolean;
var
  CheckString: String;
  TrimS: String;

begin
  Result := False;
  TrimS := Trim(Value);
  for CheckString in self do
    if Trim(Piece(CheckString, Delim, PieceNum)) = TrimS then
      Exit(True);
end;

function TVAStringsHelper.FuzzyIndexOf(const SubStr: String): Integer;
var
  I: Integer;
begin
  Result := -1;

  // Loop though each item and see if it contains the given text
  for I := 0 to Count - 1 do
    if ContainsText(Strings[I], SubStr) then
      Exit(I);
end;

function TVAStringsHelper.IndexOfPiece(Value: string; Delim: Char;
  PieceNum, StartIdx: Integer): Integer;
begin
  Result := StartIdx;
  inc(Result);
  while ((Result >= 0) and (Result < Count) and (Piece(Strings[Result], Delim,
    PieceNum) <> Value)) do
    inc(Result);
  if (Result < 0) or (Result >= Count) then
    Result := -1;
end;

function TVAStringsHelper.IndexOfPieces(const Values: array of string): Integer;
begin
  Result := IndexOfPieces(Values, U, [], -1);
end;

function TVAStringsHelper.IndexOfPieces(const Values: array of string;
  StartIdx: Integer): Integer;
begin
  Result := IndexOfPieces(Values, U, [], StartIdx);
end;

function TVAStringsHelper.IndexOfPieces(const Values: array of string;
  const Delim: Char; const Pieces: array of Integer; StartIdx: Integer)
  : Integer;
var
  Done: Boolean;

begin
  Result := StartIdx;
  repeat
    inc(Result);
    if (Result >= 0) and (Result < Count) then
      Done := PiecesEqual(Result, Values, Pieces, Delim)
    else
      Done := True;
  until (Done);
  if (Result < 0) or (Result >= Count) then
    Result := -1;
end;

function TVAStringsHelper.IndexOfStrippedString(const SubStr: string;
  OffSet: Integer = 0): Integer;
var
  tmpStr: String;
begin
  Result := -1;
  if OffSet > GetCount - 1 then
    Exit;

  for Result := OffSet to GetCount - 1 do
  begin
    tmpStr := Strings[Result];
    tmpStr := tmpStr.Replace(' ', '');
    if CompareStr(tmpStr, SubStr) = 0 then
      Exit;
  end;
  Result := -1;
end;

function TVAStringsHelper.IndexOfSubString(const SubStr: string;
  OffSet: Integer = 0; CaseSensitive: Boolean = False): Integer;
var
  S: string;
  Found: Boolean;

begin
  Result := -1;
  if OffSet > GetCount - 1 then
    Exit;
  if CaseSensitive then
    S := SubStr
  else
    S := UpperCase(SubStr);

  for Result := OffSet to GetCount - 1 do
  begin
    if CaseSensitive then
      Found := (Pos(S, Strings[Result]) > 0)
    else
      Found := (Pos(S, UpperCase(Strings[Result])) > 0);
    if Found then
      Exit;
  end;
  Result := -1;
end;

procedure TVAStringsHelper.KillObjects;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Assigned(Objects[I]) then
    begin
      Objects[I].Free;
      Objects[I] := nil;
    end;
  end;
end;

function TVAStringsHelper.PiecesEqual(const Index: Integer;
  const Values: array of string): Boolean;
begin
  Result := PiecesEqual(Index, Values, [], U);
end;

function TVAStringsHelper.PiecesEqual(const Index: Integer;
  const Values: array of string; const Pieces: array of Integer): Boolean;
begin
  Result := PiecesEqual(Index, Values, Pieces, U);
end;

function TVAStringsHelper.PiecesEqual(const Index: Integer;
  const Values: array of string; const Pieces: array of Integer;
  const Delim: Char): Boolean;
var
  I, cnt, p: Integer;

begin
  cnt := 0;
  Result := True;
  for I := low(Values) to high(Values) do
  begin
    inc(cnt);
    if (I >= low(Pieces)) and (I <= high(Pieces)) then
      p := Pieces[I]
    else
      p := cnt;
    if (Piece(Strings[Index], Delim, p) <> Values[I]) then
    begin
      Result := False;
      break;
    end;
  end;
end;

procedure TVAStringsHelper.SetStrPiece(Index, PieceNum: Integer;
  const NewValue: string);
begin
  SetStrPiece(Index, PieceNum, U, NewValue);
end;

procedure TVAStringsHelper.SetStrPiece(Index, PieceNum: Integer; Delim: Char;
  const NewValue: string);
var
  tmp: string;

begin
  tmp := Strings[Index];
  SetPiece(tmp, Delim, PieceNum, NewValue);
  Strings[Index] := tmp;
end;

procedure TVAStringsHelper.SortByDelimiter<T>(PieceNum: Integer; aDelim: Char; aSortDir: tSortDir);
begin
  SortByDelimiters([PieceNum], [GetTypeKind(T)], aDelim, [aSortDir]);
end;

procedure TVAStringsHelper.SortByDelimiters(const Pieces: TArray<Integer>; const PieceTypes: TArray<TTypeKind>; aDelim: Char; const aSortDir: TSortArray);
var
  sl: TStringList;
begin
  if ((Self is TStringList) and TStringList(Self).Sorted) or (Count = 0) then
    exit;

  if assigned(PieceTypes) then
  begin
    SetLength(FSortTypeKind, Length(PieceTypes));
    TArray.Copy<TTypeKind>(PieceTypes, FSortTypeKind, Length(PieceTypes));
  end;

  SetLength(FSortPieceNum, Length(Pieces));
  TArray.Copy<Integer>(Pieces, FSortPieceNum, Length(Pieces));

  SetLength(FSortDir, 0);
  If not assigned(aSortDir) then
  begin
    SetLength(FSortDir, 1);
    FSortDir[0] := DIR_FRWRD;
  end else begin
    SetLength(FSortDir, Length(aSortDir));
    TArray.Copy<TSortDir>(aSortDir, FSortDir, Length(aSortDir));
  end;


  FSortADelim := aDelim;
  try
    if Self is TSTringList then
      TStringList(Self).CustomSort(CustomSortByDelimiters)
    else begin
      sl := TStringList.Create;
        try
          sl.Assign(Self);
          sl.CustomSort(CustomSortByDelimiters);
          Self.Assign(sl);
        finally
          sl.Free;
        end;
    end;
  finally
    SetLength(FSortDir, 0);
    SetLength(FSortPieceNum, 0);
    SetLength(FSortTypeKind, 0);
  end;
end;

Procedure TVAStringsHelper.StringsByNum(ReturnList: TStringList;
  OffSet: Integer = 0; Linecnt: Integer = 1);
var
  I: Integer;
begin
  for I := OffSet to OffSet + Linecnt do
    ReturnList.Add(Strings[I]);
end;

function TVAStringsHelper.RawText: String;

// Mirror of Load from base class except output is string
  Function Load(Stream: TStream; Encoding: TEncoding): String;
  var
    Size: Integer;
    Buffer: TBytes;
  begin
    BeginUpdate;
    try
      Size := Stream.Size - Stream.Position;
      SetLength(Buffer, Size);
      Stream.Read(Buffer, 0, Size);
      Size := TEncoding.GetBufferEncoding(Buffer, Encoding, DefaultEncoding);
      SetEncoding(Encoding); // Keep Encoding in case the stream is saved
      Result := Encoding.GetString(Buffer, Size, Length(Buffer) - Size);
    finally
      EndUpdate;
    end;
  end;

var
  Stream: TStream;
begin
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream, Encoding);
    Stream.Position := 0;
    Result := Load(Stream, Encoding);
  finally
    Stream.Free;
  end;
end;

{ TVAStringListHelper }

procedure TVAStringListHelper.RemoveDuplicates;
var
  i: integer;

begin
  i := 1;
  while (i < Count) do
  begin
    if Strings[i] = Strings[i - 1] then
      Delete(i)
    else
      inc(i);
  end;
end;

procedure TVAStringListHelper.SortByPiece(PieceNum: Integer; Delim: Char);
begin
  SortByPieces([PieceNum], Delim);
end;

procedure TVAStringListHelper.SortByPieces(Pieces: array of Integer;
  Delim: Char);

  procedure QSort(L, R: Integer);
  var
    I, J: Integer;
    p: string;

  begin
    repeat
      I := L;
      J := R;
      p := Strings[(L + R) shr 1];
      repeat
        while ComparePieces(Strings[I], p, Pieces, Delim, True) < 0 do
          inc(I);
        while ComparePieces(Strings[J], p, Pieces, Delim, True) > 0 do
          Dec(J);
        if I <= J then
        begin
          Exchange(I, J);
          inc(I);
          Dec(J);
        end;
      until I > J;
      if L < J then
        QSort(L, J);
      L := I;
    until I >= R;
  end;

begin
  if not Sorted and (Count > 1) then
  begin
    Changing;
    QSort(0, Count - 1);
    Changed;
  end;
end;


function CustomSortByDelimiters(List: TStringList; Index1, Index2: Integer)
  : Integer;
var
  Str1, Str2: string;
  I, PieceNum: Integer;
  SortDelim: Char;
begin
  if (Length(List.FSortTypeKind) = 0) or (Length(List.FSortPieceNum) = 0) or
    (Length(List.FSortDir) = 0) then
    Exit(0);

  Result := 0;
  SortDelim := List.FSortADelim;
  for I := Low(List.FSortPieceNum) to High(List.FSortPieceNum) do
  begin
    PieceNum := List.FSortPieceNum[I];
    if (I > (Length(List.FSortDir) - 1)) or (List.FSortDir[I] = DIR_FRWRD) then
    begin
      // get the strings to compare
      Str1 := TPiece(List[Index1]).Piece(PieceNum, SortDelim);
      Str2 := TPiece(List[Index2]).Piece(PieceNum, SortDelim);
    end
    else
    begin
      // get the strings to compare
      Str1 := TPiece(List[Index2]).Piece(PieceNum, SortDelim);
      Str2 := TPiece(List[Index1]).Piece(PieceNum, SortDelim);
    end;

    if (Length(List.FSortTypeKind) < I) then
      Result := (AnsiCompareText(Str1, Str2))
    else
    begin
      case List.FSortTypeKind[I] of
        tkString, tkLString, tkUString, tkWString:
          Result := (AnsiCompareText(Str1, Str2));
        tkFloat:
          Result := (System.Math.CompareValue(StrToFloatDef(Str1, 0),
            StrToFloatDef(Str2, 0)));
        tkInteger:
          Result := (System.Math.CompareValue(StrToIntDef(Str1, 0),
            StrToIntDef(Str2, 0)));
      else
        Result := 0; // not supported type
      end;

    end;
    if Result <> 0 then
      break;
  end;
end;


end.

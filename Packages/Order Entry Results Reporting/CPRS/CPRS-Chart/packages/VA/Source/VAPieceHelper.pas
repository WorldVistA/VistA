unit VAPieceHelper;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;

const
  DefaultDelim = '^';

type
  TPiece = type string;

  TPieceHelper = record helper for TPiece
    /// <summary>Removes a substring and it's delimeter from a string</summary>
    /// <param name="Index">Indexes requested<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    procedure Delete(const Index: Integer; const Delim: Char = DefaultDelim);
    /// <summary>Returns an index of a substring in a delimeted string</summary>
    /// <param name="S">Substring to look for<para><b>Type: </b><c>char</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <returns><para><b>Type: </b><c>Integer</c></para> - </returns>
    function IndexOf(const S: string; const Delim: Char = DefaultDelim)
      : Integer;
    /// <summary>Returns a substring from a delimeted string</summary>
    /// <param name="Index">Index requested<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <returns><para><b>Type: </b><c>String</c></para> - </returns>
    function Piece(const Index: Integer;
      const Delim: Char = DefaultDelim): string;
    /// <summary>Returns several values from a delimited string in a TArray<String></summary>
    /// <param name="Indexes">Indexes requested<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <returns><para><b>Type: </b><c>TArray<string></c></para> - </returns>
    function ToArray(const Indexes: array of Integer;
      const Delim: Char = DefaultDelim): TArray<string>;
    /// <summary>Returns values from a delimited string to a list</summary>
    /// <param name="Destination">List to populate<para><b>Type: </b><c>TStrings</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    procedure ToList(out Destination: TStrings;
      const Delim: Char = DefaultDelim); overload;
    /// <summary>Returns values from a delimited string to a list</summary>
    /// <param name="Destination">List to populate<para><b>Type: </b><c>TStrings</c></para></param>
    /// <param name="Indexes">Indexes requested<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    procedure ToList(out Destination: TStrings; const Indexes: array of Integer;
      const Delim: Char = DefaultDelim); overload;
    /// <summary>Returns several values from a delimited string separated by a custom delimiter</summary>
    /// <param name="Indexes">Indexes requested<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <param name="ReturnDelim">Delimeter used to seperate the string in the Return<para><b>Type: </b><c>String</c></para></param>
    /// <returns><para><b>Type: </b><c>String</c></para> - </returns>
    function ToDelimitedString(const Indexes: array of Integer;
      const Delim: Char = DefaultDelim;
      const OutDelim: Char = DefaultDelim): string;
    /// <summary>Set a substring in a delimeted string</summary>
    /// <param name="Index">Index requested<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Value">Substring to update at requested index<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Original delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <returns><para><b>Type: </b><c>String</c></para> - </returns>
    function Update(const Index: Integer; const Value: string;
      const Delim: Char = DefaultDelim): string; overload;
    /// <summary>Set multiple substrings in a delimeted string</summary>
    /// <param name="Indexes">Indexes requested<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Values">Substrings to update at requested indexes<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Original delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <returns><para><b>Type: </b><c>String</c></para> - </returns>
    function Update(const Indexes: array of Integer;
      const Values: array of string; const Delim: Char = DefaultDelim;
      const AddNewPieces: Boolean = False): string; overload;
    /// <summary>Compares specific substring in string</summary>
    /// <param name="CompareString">Delimted string to compare against<para><b>Type: </b><c>string</c></para></param>
    /// <param name="Index">Index to compare<para><b>Type: </b><c>Integer</c></para></param>
    /// <param name="Delim">Original delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <param name="CaseInsensitive">Perform case insensitive compare<para><b>Type: </b><c>Boolean</c></para></param>
    function Compare(const CompareString: string; const Index: Integer;
      const Delim: Char = DefaultDelim; const CaseInsensitive: Boolean = False)
      : Integer; overload;
    /// <summary>Compares specific substrings in string</summary>
    /// <param name="CompareString">Delimted string to compare against<para><b>Type: </b><c>string</c></para></param>
    /// <param name="Indexes">Indexes to compare<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="Delim">Original delimeter used to seperate the string<para><b>Type: </b><c>char</c></para></param>
    /// <param name="CaseInsensitive">Perform case insensitive compare<para><b>Type: </b><c>Boolean</c></para></param>
    function Compare(const CompareString: string;
      const Indexes: array of Integer; const Delim: Char = DefaultDelim;
      const CaseInsensitive: Boolean = False): Integer; overload;
  end;

  TArrayHelper = class helper for TArray
    /// <summary>Check if index is within bounds of array</summary>
    /// <param name="Values">The array to check<para><b>Type: </b><c>array of T</c></para></param>
    /// <param name="Index">Index to validate<para><b>Type: </b><c>Integer</c></para></param>
    class function IndexInBounds<T>(const Values: array of T;
      const Index: Integer): Boolean;
    {$IF CompilerVersion < 36.0}
    // This code is to support Delphi 11 and earlier
    class function IndexOf<T>(const Values: array of T; const Item: T)
      : Integer; static;
    {$ENDIF}
  end;

implementation

uses
  System.Generics.Defaults,
  System.RTLConsts;

{ TPieceHelper }

function TPieceHelper.Compare(const CompareString: string; const Index: Integer;
  const Delim: Char; const CaseInsensitive: Boolean): Integer;
var
  StringA, StringB: string;
begin
  if string(Self).IsEmpty then
    Exit(0);

  StringA := Self.Piece(index, Delim);
  StringB := TPiece(CompareString).Piece(index, Delim);

  Exit(string.Compare(StringA, StringB, CaseInsensitive));
end;

function TPieceHelper.Compare(const CompareString: string;
  const Indexes: array of Integer; const Delim: Char;
  const CaseInsensitive: Boolean): Integer;
begin
  if string(Self).IsEmpty then
    Exit(0);

  Result := 0;

  for var i := low(Indexes) to high(Indexes) do
  begin
    Result := Self.Compare(CompareString, Indexes[i], Delim, CaseInsensitive);
    if Result <> 0 then
      break;
  end;
end;

procedure TPieceHelper.Delete(const Index: Integer;
  const Delim: Char = DefaultDelim);
var
  StringArray: TArray<string>;
begin
  if string(Self).IsEmpty then
    Exit;

  StringArray := string(Self).Split([Delim]);
  // If index is within range (zero based)
  if TArray.IndexInBounds<string>(StringArray, index - 1) then
  begin
    // remove the string
    System.Delete(StringArray, (index - 1), 1);
    // Stitch the string back together
    Self := string(Self).Join(Delim, StringArray);
  end;
end;

function TPieceHelper.IndexOf(const S: string;
  const Delim: Char = DefaultDelim): Integer;
var
  StringArray: TArray<string>;
  ReturnIndex: Integer;
begin
  if string(Self).IsEmpty then
    Exit(-1);

  StringArray := string(Self).Split([Delim]);

  ReturnIndex := TArray.IndexOf<string>(StringArray, S);

  if ReturnIndex <> -1 then
    Inc(ReturnIndex);
  Exit(ReturnIndex);
end;

function TPieceHelper.Piece(const Index: Integer; const Delim: Char): string;
var
  StringArray: TArray<string>;
begin
  if string(Self).IsEmpty then
    Exit('');

  StringArray := string(Self).Split([Delim]);
  // If index is withing range (zero based)
  if TArray.IndexInBounds<string>(StringArray, index - 1) then
    Exit(StringArray[(index - 1)])
  else
    Exit('');
end;

function TPieceHelper.ToArray(const Indexes: array of Integer;
  const Delim: Char = DefaultDelim): TArray<string>;
var
  StringArray: TArray<string>;
begin
  if string(Self).IsEmpty then
    Exit(nil);

  SetLength(Result, 0);
  StringArray := string(Self).Split([Delim]);
  for var i := low(Indexes) to high(Indexes) do
  begin
    // If index is withing range (zero based)
    if TArray.IndexInBounds<string>(StringArray, Indexes[i] - 1) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[high(Result)] := StringArray[Indexes[i] - 1];
    end;
  end;
end;

function TPieceHelper.ToDelimitedString(const Indexes: array of Integer;
  const Delim: Char = DefaultDelim;
  const OutDelim: Char = DefaultDelim): string;
var
  StringArray: TArray<string>;
begin
  if string(Self).IsEmpty then
    Exit('');

  Result := '';
  StringArray := Self.ToArray(Indexes, Delim);

  // loop through resutls and format
  for var i := low(StringArray) to high(StringArray) do
  begin
    if Length(Result) = 0 then
      Result := StringArray[i]
    else
      Result := Result.Join(OutDelim, [Result, StringArray[i]]);
  end;
end;

procedure TPieceHelper.ToList(out Destination: TStrings; const Delim: Char);
var
  StringArray: TArray<string>;
begin
  if string(Self).IsEmpty then
    Exit();

  if not Assigned(Destination) then
    raise EArgumentNilException.CreateRes(@SArgumentNil)at ReturnAddress;

  StringArray := string(Self).Split(Delim);
  for var i := low(StringArray) to high(StringArray) do
  begin
    Destination.Add(StringArray[i]);
  end;
end;

procedure TPieceHelper.ToList(out Destination: TStrings;
  const Indexes: array of Integer; const Delim: Char);
begin
  if string(Self).IsEmpty then
    Exit();

  if not Assigned(Destination) then
    raise EArgumentNilException.CreateRes(@SArgumentNil)at ReturnAddress;

  for var i := low(Indexes) to high(Indexes) do
  begin
    var
      S: string := Self.Piece(Indexes[i], Delim);
    if Length(S) > 0 then
      Destination.Add(S);
  end;
end;

function TPieceHelper.Update(const Index: Integer; const Value: string;
  const Delim: Char): string;
var
  StringArray: TArray<string>;
begin
  if (index < 1) or (index > string(Self).CountChar(Delim) + 1) then
    Exit('');

  Result := '';
  StringArray := string(Self).Split([Delim]);

  // Ensure we have a piece to modify
  if Length(StringArray) > 0 then
  begin
    // for each peice
    for var i := low(StringArray) to high(StringArray) do
    begin
      // are we on the requested piece
      if (index - 1) = i then
      begin
        // If its the first then dont add a delim first else join with delim
        if i = 0 then
          Result := Value
        else
          Result := Result.Join(Delim, [Result, Value]);
      end
      else
      begin
        // just add the current string at this piece
        // If its the first then dont add a delim first else join with delim
        if i = 0 then
          Result := StringArray[i]
        else
          Result := Result.Join(Delim, [Result, StringArray[i]]);
      end;
    end;
  end
  else if index = 1 then
    Result := Value
  else
    Exit(string(Self));
end;

function TPieceHelper.Update(const Indexes: array of Integer;
  const Values: array of string; const Delim: Char = DefaultDelim;
  const AddNewPieces: Boolean = False): string;
var
  StringArray: TArray<string>;
  PieceNum: Integer;
begin
  if not AddNewPieces and string(Self).IsEmpty then
    Exit('');

  // ensure that we have something in the arrays and that they are both the same length
  if (Length(Indexes) = 0) or (Length(Indexes) <> Length(Values)) then
  begin
    ErrorArgumentOutOfRange;
    Exit(string(Self));
  end;

  Result := string(Self);

  // split up the string
  StringArray := Result.Split([Delim]);
  for var i := low(Indexes) to high(Indexes) do
  begin
    // count current "pieces"
    var
      DelimCount: Integer := Result.CountChar(Delim);

    PieceNum := Indexes[i];
    // if we need to add
    if AddNewPieces and (DelimCount < PieceNum) then
    begin
      if (PieceNum - DelimCount) > 0 then
        Result := Result + System.StringOfChar(Delim,
          ((PieceNum - 1) - DelimCount))
    end;

    // get the updated piece
    Result := TPiece(Result).Update(Indexes[i], Values[i], Delim);
  end;
end;

{ TArrayHelper<T> }

class function TArrayHelper.IndexInBounds<T>(const Values: array of T;
  const Index: Integer): Boolean;
begin
  Exit((index >= low(Values)) and (index <= high(Values)))
end;

{$IF CompilerVersion < 36.0}

class function TArrayHelper.IndexOf<T>(const Values: array of T;
  const Item: T): Integer;
var
  Comparer: IEqualityComparer<T>;
begin
  Comparer := TEqualityComparer<T>.Default;

  for var i := 0 to high(Values) do
  begin
    if Comparer.Equals(Values[i], Item) then
      Exit(i);
  end;

  Exit(-1);
end;

{$ENDIF}

end.

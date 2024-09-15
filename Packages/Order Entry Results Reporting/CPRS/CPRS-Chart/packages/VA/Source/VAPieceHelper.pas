unit VAPieceHelper;

interface

uses
  SysUtils;

const
  DefaultDelim = '^';

type
  TPiece = type string;

  TPieceHelper = record helper for TPiece
    procedure DeletePiece(const PieceDelim: Char; const Index: Integer);
    function IndexOfPiece(const PieceDelim: Char; const S: string): integer;
    /// <summary>Returns several pieces sepreated by a custom delimeter</summary>
    /// <param name="S">String to return pieces from<para><b>Type: </b><c>char</c></para></param>
    /// <param name="PieceNumbers">Piece indexes requested<para><b>Type: </b><c>array of Integer</c></para></param>
    /// <param name="PieceDelim">Original delimeter used to seperate the pieces<para><b>Type: </b><c>char</c></para></param>
    /// <param name="ReturnDelim">Delimeter used to seperate the pieces in the Return<para><b>Type: </b><c>String</c></para></param>
    /// <returns><para><b>Type: </b><c>String</c></para> - </returns>
    function Pieces(PieceNumbers: array of Integer;
      PieceDelim: Char = DefaultDelim; ReturnDelim: Char = DefaultDelim)
      : string;
  end;

implementation

uses
  System.Generics.Defaults;

{ TCPRSStringHelper }

procedure TPieceHelper.DeletePiece(const PieceDelim: Char; const Index: Integer);
var
  ALst: TArray<string>;
begin
  ALst := string(Self).Split([PieceDelim]);
  if ((Index - 1) <= high(ALst)) and ((Index - 1) >= Low(ALst)) then
  begin
    Delete(ALst, (Index - 1), 1);
    Self := string(Self).Join(PieceDelim, ALst);
  end;
end;

function TPieceHelper.IndexOfPiece(const PieceDelim: Char;
  const S: string): Integer;
var
  ALst: TArray<string>;
  I: Integer;
begin
  ALst := string(Self).Split([PieceDelim]);
  for I := Low(ALst) to High(ALst) do
  begin
    if ALst[I] = S then
      Exit(I + 1);
  end;
  Exit(-1);
end;

function TPieceHelper.Pieces(PieceNumbers: array of Integer;
  PieceDelim: Char = DefaultDelim; ReturnDelim: Char = DefaultDelim): string;

  function InIntegerArray(const aArray: array of Integer; Lookup: Integer): boolean;
  var
    I: integer;
  begin
    for I := Low(aArray) to High(aArray) do
    begin
      if Lookup = aArray[I] then
        Exit(True);
    end;
    Exit(False);
  end;

var
  aSelf: string;
  aLst: TArray<string>;
  I, PieceNum: Integer;
begin
  Result := '';
  aSelf := string(Self);
  aLst := aSelf.Split([PieceDelim]);
  for I := Low(PieceNumbers) to High(PieceNumbers) do
  begin
    if (PieceNumbers[I] >= Low(aLst)) or (PieceNumbers[I] <= High(aLst)) then
    begin
      PieceNum := PieceNumbers[I] - 1;
      Result := Result.Join(ReturnDelim, [Result, aLst[PieceNum]]);
    end;
  end;
end;


end.

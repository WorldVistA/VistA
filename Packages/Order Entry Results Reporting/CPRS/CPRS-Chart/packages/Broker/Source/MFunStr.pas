{ **************************************************************
  Package: XWB - Kernel RPCBroker
  Date Created: Sept 18, 1997 (Version 1.1)
  Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
  Developers: Danila Manapsal, Don Craven, Joel Ivey
  Description: Contains TRPCBroker and related components.
  Unit: MFunStr functions that emulate MUMPS functions.
  Current Release: Version 1.1 Patch 72
  *************************************************************** }

{ **************************************************
  Changes in XWB*1.1*72 (RGG 07/30/2020) XWB*1.1*72
  1. Updated RPC Version to version 72.

  Changes in XWB*1.1*71 (RGG 10/18/2018) XWB*1.1*71
  1. Updated RPC Version to version 71.

  Changes in v1.1.65 (HGW 06/13/2016) XWB*1.1*65
  1. Added function RemoveCRLF to strip CR and LF from a string.

  Changes in v1.1.60 (HGW 12/18/2013) XWB*1.1*60
  1. Reformated indentation and comments to make code more readable.

  Changes in v1.1.50 (JLI 9/1/2011) XWB*1.1*50
  1. None.
  ************************************************** }
unit MFunStr;

interface

uses
  {System}
  System.SysUtils,
  {Vcl}
  Vcl.Dialogs;

{ procedure and function prototypes }
function Piece(x: string; del: string; piece1: integer = 1;
  piece2: integer = 0): string;
function Translate(passedString, identifier, associator: string): string;
function RemoveCRLF(const aString: string): string;

const
  U: string = '^';

implementation

{ --------------------- Translate ---------------------------------
  function TRANSLATE(string,identifier,associator)
  Performs a character-for-character replacement within a string.
  ------------------------------------------------------------------ }
function Translate(passedString, identifier, associator: string): string;
{ }
var
  index, position: integer;
  newString: string;
  substring: string;

begin
  newString := ''; { initialize NewString }
  for index := 1 to length(passedString) do
  begin
    substring := copy(passedString, index, 1);
    position := pos(substring, identifier);
    if position > 0 then
      newString := newString + copy(associator, position, 1)
    else
      newString := newString + copy(passedString, index, 1)
  end;
  result := newString;
end; // function Translate

{ --------------------- Piece -------------------------------------
  function PIECE(string,delimiter,piece number)
  Returns a field within a string using the specified delimiter.
  ------------------------------------------------------------------ }
function Piece(x: string; del: string; piece1: integer = 1;
  piece2: integer = 0): string;
var
  delIndex, pieceNumber: integer;
  Resval: String;
  Str: String;
begin
  { initialize variables }
  pieceNumber := 1;
  Str := x;
  { delIndex :=1; }
  if piece2 = 0 then
    piece2 := piece1;
  Resval := '';
  repeat
    delIndex := pos(del, Str);
    if (delIndex > 0) or ((pieceNumber > Pred(piece1)) and
      (pieceNumber < (piece2 + 1))) then
    begin
      if (pieceNumber > Pred(piece1)) and (pieceNumber < (piece2 + 1)) then
      begin
        if (pieceNumber > piece1) and (Str <> '') then
          Resval := Resval + del;
        if delIndex > 0 then
        begin
          Resval := Resval + copy(Str, 1, delIndex - 1);
          Str := copy(Str, delIndex + length(del), length(Str));
        end
        else
        begin
          Resval := Resval + Str;
          Str := '';
        end;
      end
      else
        Str := copy(Str, delIndex + length(del), length(Str));
    end
    else if Str <> '' then
      Str := '';
    inc(pieceNumber);
  until (pieceNumber > piece2);
  result := Resval;
end; // function Piece

{ --------------------- RemoveCRLF --------------------------------
  function REMOVECRLF(string)
  Removes CR and LF characters from a a string.
  ------------------------------------------------------------------ }
function RemoveCRLF(const aString: string): string;
var
  i, j: integer;
begin
  result := aString;
  j := 0;
  for i := 1 to length(result) do
  begin
    if (not CharInSet(result[i], [#10, #13])) then
    begin
      inc(j);
      result[j] := result[i]
    end;
  end;
  SetLength(result, j);
end; // function RemoveCRLF

end.

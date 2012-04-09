{ **************************************************************
	Package: XWB - Kernel RPCBroker
	Date Created: Sept 18, 1997 (Version 1.1)
	Site Name: Oakland, OI Field Office, Dept of Veteran Affairs
	Developers: Danila Manapsal, Don Craven, Joel Ivey
	Description: Functions that emulate MUMPS functions.
	Current Release: Version 1.1 Patch 47 (Jun. 17, 2008))
*************************************************************** }

unit MFunStr;

interface

uses SysUtils, Dialogs;

{procedure and function prototypes}
function Piece(x: string; del: string; piece1: integer = 1; piece2: integer=0): string;
function Translate(passedString, identifier, associator: string): string;

const
  U: string = '^';

implementation

function Translate(passedString, identifier, associator: string): string;
{TRANSLATE(string,identifier,associator)
Performs a character-for-character replacement within a string.}
var
   index, position: integer;
   newString: string;
   substring: string;

begin
     newString := '';                     {initialize NewString}
     for index := 1 to length(passedString) do begin
         substring := copy(passedString,index,1);
         position := pos(substring,identifier);
         if position > 0 then
           newString := newString + copy(associator,position,1)
         else
           newString := newString + copy(passedString,index,1)
     end;
     result := newString;
end;


function Piece(x: string; del: string; piece1: integer = 1; piece2: integer=0) : string;
{PIECE(string,delimiter,piece number)
Returns a field within a string using the specified delimiter.}
var
  delIndex,pieceNumber: integer;
  Resval: String;
  Str: String;
begin
  {initialize variables}
  pieceNumber := 1;
  Str := x;
  {delIndex :=1;}
  if piece2 = 0 then 
    piece2 := piece1;
  Resval := '';
  repeat
    delIndex := Pos(del,Str);
    if (delIndex > 0) or ((pieceNumber > Pred(piece1)) and (pieceNumber < (piece2+1))) then begin
      if (pieceNumber > Pred(piece1)) and (pieceNumber < (piece2+1)) then
      begin
        if (pieceNumber > piece1) and (Str <> '') then
          Resval := Resval + del;
        if delIndex > 0 then
        begin
          Resval := Resval + Copy(Str,1,delIndex-1);
          Str := Copy(Str,delIndex+Length(del),Length(Str));
        end
        else
        begin
          Resval := Resval + Str;
          Str := '';
        end;
      end
      else
        Str := Copy(Str,delIndex+Length(del),Length(Str));
    end
    else if Str <> '' then
      Str := '';
    inc(pieceNumber);
  until (pieceNumber > piece2);
  Result := Resval;
end;
end.

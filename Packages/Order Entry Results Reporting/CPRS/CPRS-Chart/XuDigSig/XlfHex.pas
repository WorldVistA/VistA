unit XlfHex;
//This is a file to support converting arrays and strings
//from to Hex.
interface

uses
  Classes, SysUtils;

  function ArrayToHexStr(pba: Pchar; len: integer): string;
  procedure HexStrToArray(str: string; var pba: array of byte);
implementation

function ArrayToHexStr;
//The first argument is a byte array with the data
//to convert.
//pbData: Array[0..20] of byte
// hex := ArrayToHexStr(pbData, length)
var
   i,v: integer;
   s: string;
begin
     //Convert the Array to a Hex string
     Result := '';
     s := '';
     for i := 0 to len-1 do
         begin
          v := integer(pba[i]);
          s := s + intToHex(v,2);
          end;
     Result := lowercase(s);
end;

procedure HexStrToArray;
var
   ix, ox, hx, bv: integer;
   ch: string;
   rdy: boolean;
const Hexvalues = '0123456789abcdef';
begin
     str := lowercase(str);
     ox := 0;  //Set the starting index for the output.
     bv := 0;
     rdy := false;
     for ix := 1 to length(str) do
     begin
          ch := copy(str, ix, 1);
          hx := pos(ch, Hexvalues);
          bv := bv*16 + (hx-1);
          if rdy then
            begin
            pba[ox] := bv;
            inc(ox);
            bv := 0;
            end;
          rdy := not rdy;
     end;
end;

end.

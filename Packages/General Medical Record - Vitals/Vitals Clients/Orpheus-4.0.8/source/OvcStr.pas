{*********************************************************}
{*                   OVCSTR.PAS 4.06                     *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Armin Biernaczyk  (unicode version of BMSearch & BMSearchUC)             *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcstr;
  {-General string handling routines}

interface

uses
  SysUtils;

{ For unicode-strings, we have two options:
  a) Use a huge (64KB) BM-table for searches. This results in a larger overhead, but searching
     is faster, when the buffer being searched contains many 2-byte-characters.
  b) Use a small (256B) BM-Table. The overhead is smaller, but searching can be slower

  use the symbol HUGE_UNICODE_BMTABLE to use the huge BM-table; by default, the small
  BM-table is used.}

type
  BTable = array[0..{$IFDEF HUGE_UNICODE_BMTABLE}$FFFF{$ELSE}$FF{$ENDIF}] of Byte;
  {table used by the Boyer-Moore search routines}

  TOvcCharSet = SysUtils.TSysCharSet;

function BinaryBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return a binary PChar string for a byte}
function BinaryLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return the binary PChar string for a long integer}
function BinaryWPChar(Dest : PChar; W : Word) : PChar;
  {-Return the binary PChar string for a word}
procedure BMMakeTable(MatchString : PChar; var BT : BTable);
  {-Build a Boyer-Moore link table}
function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
                  MatchString : PChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string}
function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
                    MatchString : PChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string. This
    search is not case sensitive}
function CharStrPChar(Dest : PChar; C : Char; Len : Cardinal) : PChar;
  {-Return a PChar string filled with the specified character}
function DetabPChar(Dest : PChar; Src : PChar; TabSize : Byte) : PChar;
  {-Expand tabs in a PChar string to blanks}
function HexBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return hex PChar string for byte}
function HexLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return the hex PChar string for a long integer}
function HexPtrPChar(Dest : PChar; P : Pointer) : PChar;
  {-Return hex PChar string for pointer}
function HexWPChar(Dest : PChar; W : Word) : PChar;
  {-Return the hex PChar string for a word}
function LoCaseChar(C : Char) : Char;
  {-Convert C to lower case}
function OctalLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return the octal PChar string for a long integer}
function StrChDeletePrim(P : PChar; Pos : Cardinal) : PChar;
  {-Primitive routine to delete a character from a PChar string}
function StrChInsertPrim(Dest : PChar; C : Char; Pos : Cardinal) : PChar;
  {-Primitive routine to insert a character into a PChar string}
function StrChPos(P : PChar; C : Char; var Pos : Cardinal) : Boolean;
  {-Sets Pos to location of C in P, return is True if found}
procedure StrInsertChars(Dest : PChar; Ch : Char; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos}
function StrStCopy(Dest, S : PChar; Pos, Count : Cardinal) : PChar;
  {-Copy characters at a specified position in a PChar string}
function StrStDeletePrim(P : PChar; Pos, Count : Cardinal) : PChar;
  {-Primitive routine to delete a sub-string from a PChar string}
function StrStInsert(Dest, S1, S2 : PChar; Pos : Cardinal) : PChar;
  {-Insert a PChar string into another at a specified position}
function StrStInsertPrim(Dest, S : PChar; Pos : Cardinal) : PChar;
  {-Insert a PChar string into another at a specified position. This
    primitive version modifies the source directly}
function StrStPos(P, S : PChar; var Pos : Cardinal) : Boolean;
  {-Sets Pos to position of the S in P, returns True if found}
function StrToLongPChar(S : PChar; var I : NativeInt) : Boolean;
  {-Convert a PChar string to a long integer}
procedure TrimAllSpacesPChar(P : PChar);
  {-Trim leading and trailing blanks from P}
function TrimEmbeddedZeros(const S : string) : string;
  {-Trim embedded zeros from a numeric string in exponential format}
procedure TrimEmbeddedZerosPChar(P : PChar);
  {-Trim embedded zeros from a numeric PChar string in exponential format}
function TrimTrailPrimPChar(S : PChar) : PChar;
  {-Return a PChar string with trailing white space removed}
function TrimTrailPChar(Dest, S : PChar) : PChar;
  {-Return a PChar string with trailing white space removed}
function TrimTrailingZeros(const S : string) : string;
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
procedure TrimTrailingZerosPChar(P : PChar);
  {-Trim trailing zeros from a numeric PChar string. It is assumed that
    there is a decimal point prior to the zeros. Also strips leading spaces.}
function UpCaseChar(C : Char) : Char;
  {-Convert a character to uppercase using the AnsiUpper API}

function ovc32StringIsCurrentCodePage(const S: string): Boolean; overload;
function ovc32StringIsCurrentCodePage(const S: PWideChar; CP:Cardinal=0): Boolean; overload;


implementation

uses
  Windows;

const
  Digits : array[0..$F] of Char = '0123456789ABCDEF';

function BinaryBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return binary string for byte}
var
  I : Word;
begin
  Result := Dest;
  for I := 7 downto 0 do begin
    Dest^ := Digits[Ord(B and (1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

function BinaryLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return binary string for Integer}
var
  I : Integer;
begin
  Result := Dest;
  for I := 31 downto 0 do begin
    Dest^ := Digits[Ord(L and Integer(1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

function BinaryWPChar(Dest : PChar; W : Word) : PChar;
  {-Return binary string for word}
var
  I : Word;
begin
  Result := Dest;
  for I := 15 downto 0 do begin
    Dest^ := Digits[Ord(W and (1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

procedure BMMakeTable(MatchString : PChar; var BT : BTable); register;
  {-Build Boyer-Moore link table

   Changes:
     10/2010, AB: unicode version of this procedure.
     03/2011, AB: PUREPASCAL-version added
                  Procedure can handle MatchStrings with more than 255 characters now

   Background: This table is built based on the string to be searched in a buffer to
     accelerate the search. The idea in a nutshell: imagine there is no match for 'MatchString'
     in the buffer at position p. You may try again at position p+1, then at p+2 and so on.
     However, let L := Length(MatchString) and take a look at the character c at position p+L-1
     in the buffer: If c is not present in 'MatchString', you can skip the next L-1 comparisons
     and try again at p+L.
     Even if c is present in 'MatchString' you may skip some positions - depending on the
     last occurrence of ch in MatchString.
     So, what we do is to build a table with one entry for each possible character and store
     the distance we can skip if we find this character in the buffer at p+L+1.

     Keep in mind that there is no need to store the "maximal" distance - smaller values are
     ok - the benefit of the table will just be smaller.

   What we do in detail:
     BT contains one byte for every possible character (256 Bytes for Ansi-Strings /
     65536 bytes for Unicode-Strings. The procedure fills this array as follows
     - For characters c that are not present in 'Matchstring' (not counting the last character)
       BT[c] is set to L (where L := Length(MatchString))
     - For other characters c the position p of the LAST occurrence within 'MatchString', not
       counting the last character (so p=0..L-2) is calculated and BT[c] is set to L-p-1.

     Example: For MatchString='ABCABC' we get
            BT[65] = 2   (65='A', p=4, L=6)
            BT[66] = 1   (66='B', p=5, L=6)
            BT[67] = 3   (67='C', p=3 (remember: the last character does not count), L=6)
            BT[c]  = 6 for c<65 or c>67

   If L>255, we consider the last 255 characters of MatchString. This might result "less than
   optimal" skip-distances, but still leads to a valid table. }
var
  L: Cardinal;
  c: Word;
  p: Byte;
begin
  L := StrLen(MatchString);
  if L>255 then begin
    MatchString := @MatchString[L-255];
    L := 255;
  end;
  FillChar(BT, SizeOf(BTable), Byte(L));
  if L>1 then for p := 0 to L-2 do begin
    c := Word(MatchString[p]);
    {$IFNDEF HUGE_UNICODE_BMTABLE}
    { If we are using a small (256-Byte) BM-Table in unicode, no information about characters
      with c>255 can be stored. }
    if c<=255 then
    {$ENDIF}
    BT[c] := L - p - 1;
  end;
end;

function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PChar; var Pos : Cardinal) : Boolean; register;
  {-Search MatchString in Buffer

   Changes:
     10/2010, AB: unicode version of this procedure.
     03/2011, AB: PUREPASCAL-version added
                  Procedure can handle MatchStrings with more than 255 characters now

   Background:
     This function searches 'MatchString' in 'Buffer' and returns True/False accordingly.
     If 'MatchString' is found, 'Pos' returns it's position within the 'Buffer'.
     'BufLength' is the size of 'Buffer' in characters (Unicode: not in bytes!). 'Pos' is
     character-based and zero-based.

     The procedure needs the BTable 'BT' which has to be computed via 'BMMakeTable' based on
     'MatchString'.
     For Length(MatchString)>1, this table ist used to accelerate the search as follows:
     Assume 'MatchString' is NOT found at Position p. The procedure looks at the
     character c at Position p+Length(MatchString)-1. The next position that has to be
     checked is not p+1, but p+BT[c]. In many cases we have BT[c]=Length(MatchString)
     which results in a significant reduction of the number of necessary comparisons.

     (This is a simplyfied version of the Boyer-Moore search algorithm). }

var
  BufPtr : PChar;
  lenMS1 : Cardinal;
  c      : Char;
begin
  result := False;
  if (MatchString=nil) or (MatchString^=#0) then
    Exit;

  lenMS1 := StrLen(MatchString) - 1;
  if lenMS1=0 then begin
    { trivial case: we are looking for a single character; BTable is of no use here.
      We could use StrLScan, except that 'Buffer' might not be null-terminated. }
    Pos := 0;
    while (Pos<BufLength) and not result do begin
      result := PChar(@Buffer)[Pos] = MatchString^;
      if not result then Inc(Pos);
    end;
  end else begin
    { 'BufPtr' points at the character in 'Buffer' that has to be compared to the last
      character in 'MatchString'. }
    BufPtr := PChar(@Buffer) + lenMS1;
    while (BufPtr < PChar(@Buffer)+BufLength) and not result do begin
      c := BufPtr^;
      if (c=MatchString[lenMS1]) and (StrLComp(BufPtr-lenMS1, MatchString, lenMS1)=0) then begin
        result := true;
        Pos := BufPtr-lenMS1-PChar(@Buffer);
      end else begin
        if Ord(c)<High(BTable) then
          BufPtr := BufPtr + BT[Ord(c)]
        else
          Inc(BufPtr);
      end;
    end;
  end;
end;

function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PChar; var Pos : Cardinal) : Boolean; register;
  {- Case-insensitive search for MatchString in Buffer. Return indicates
     success or failure.  Assumes MatchString is already raised to
     uppercase (PRIOR to creating the table)
     For details see 'BMSearch'; }

var
  BufPtr : PChar;
  lenMS1 : Cardinal;
  c      : Char;
begin
  result := False;
  if (MatchString=nil) or (MatchString^=#0) then
    Exit;

  lenMS1 := StrLen(MatchString) - 1;
  if lenMS1=0 then begin
    { trivial case: we are looking for a single character; BTable is of no use here. }
    Pos := 0;
    while (Pos<BufLength) and not result do begin
      result := UpCaseChar(PChar(@Buffer)[Pos]) = MatchString^;
      if not result then Inc(Pos);
    end;
  end else begin
    { 'BufPtr' points at the character in 'Buffer' that has to be compared to the last
      character in 'MatchString'. }
    BufPtr := PChar(@Buffer) + lenMS1;
    while (BufPtr < PChar(@Buffer)+BufLength) and not result do begin
      c := UpCaseChar(BufPtr^);
      if (c=MatchString[lenMS1]) and (StrLIComp(BufPtr-lenMS1, MatchString, lenMS1)=0) then begin
        result := true;
        Pos := BufPtr-lenMS1-PChar(@Buffer);
      end else begin
        if Ord(c)<High(BTable) then
          BufPtr := BufPtr + BT[Ord(c)]
        else
          Inc(BufPtr);
      end;
    end;
  end;
end;

function CharStrPChar(Dest : PChar; C : Char;
                      Len : Cardinal) : PChar; register;
  {- inserts char C Len times into Dest; adds #0
     Dest must point to a buffer for at least Len+1 characters

   Changes:
     03/2011, AB: PUREPASCAL-version added }

begin
  Dest[Len] := #0;
  while Len>0 do begin
    Dec(Len);
    Dest[Len] := C;
  end;
  Result := Dest;
end;

function DetabPChar(Dest : PChar; Src : PChar; TabSize : Byte) : PChar; register;
  { -Expand tabs in a string to blanks on spacing TabSize

   Changes:
     10/2010, AB: unicode version of this procedure.
     03/2011, AB: PUREPASCAL-version added }

var
  i, j: Integer;
  k: SmallInt;
  ch: Char;
begin
  i := 0;
  j := 0;
  repeat
    ch := Src[j];
    if ch <> #9 then begin
      Dest[i] := ch;
      Inc(i);
    end else begin
      for k := 1 to TabSize - i mod TabSize do begin
        Dest[i] := ' ';
        Inc(i);
      end;
    end;
    Inc(j);
  until ch=#0;
  result := Dest;
end;

function HexBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return hex string for byte}
begin
  Result := Dest;
  Dest^ := Digits[B shr 4];
  Inc(Dest);
  Dest^ := Digits[B and $F];
  Inc(Dest);
  Dest^ := #0;
end;


function HexLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return the hex string for a long integer}
var
  T2 : Array[0..4] of Char;
begin
  Result := StrCat(HexWPChar(Dest, HIWORD(L)), HexWPChar(T2, LOWORD(L)));
end;


function HexPtrPChar(Dest : PChar; P : Pointer) : PChar;
  {-Return hex string for pointer}
var
  T2 : Array[0..4] of Char;
begin
  StrCat(HexWPChar(Dest, HIWORD(Integer(P))), ':');
  Result := StrCat(Dest, HexWPChar(T2, LOWORD(NativeInt(P))));
end;


function HexWPChar(Dest : PChar; W : Word) : PChar;
begin
  Result := Dest;
  Dest^ := Digits[Hi(W) shr 4];
  Inc(Dest);
  Dest^ := Digits[Hi(W) and $F];
  Inc(Dest);
  Dest^ := Digits[Lo(W) shr 4];
  Inc(Dest);
  Dest^ := Digits[Lo(W) and $F];
  Inc(Dest);
  Dest^ := #0;
end;


function LoCaseChar(C: Char) : Char; register;
  {-Convert C to lower case

   Changes:
     03/2011, AB: PUREPASCAL-version added
                  Bugfix: function returned an uppercase character }

begin
  { CharLower is defined as function CharLower(P:PChar): PChar.
    However, this Windows-function will transform a character C to
    lowercase if the character ist passed to the function - in this
    case, the new charater will be returned. }
  result := Char(CharLower(PChar(C)));
end;

function OctalLPChar(Dest : PChar; L : Integer) : PChar;
  {-Return the octal PChar string for a long integer

   Changes:
     03/2011, AB: Bugfix: function did not work for UNICODE }
var
  I : Integer;
begin
  Result := Dest;
  Dest[12] := #0;
  for I := 11 downto 0 do begin
    Dest[I] := Digits[L and 7];
    L :=  L shr 3;
  end;
end;


function StrChDeletePrim(P : PChar; Pos : Cardinal) : PChar; register;
  {-Delete one character at pos P

   Changes:
     03/2011, AB: PUREPASCAL-version added
                  Bugfix: both unicode & ansi-version failed for Pos=StrLen(P) }
begin
  result := P;
  if Pos < StrLen(P) then
    StrCopy(P + Pos, P + Pos + 1);
end;

function StrChInsertPrim(Dest : PChar; C : Char;
                         Pos : Cardinal) : PChar; register;
  {-Primitive routine to insert a character into a PChar string
    note: if Pos>=StrLen(Dest), C will be appended

   Changes:
     01/2010, SZ: Unicode verified 27.01.2010
     03/2011, AB: PUREPASCAL-version added
                  improved performace of unicode-version
                  Bugfix: Ansi-Version failed for Pos=StrLen(Dest) }
var
  L: Cardinal;
begin
  result := Dest;
  L := StrLen(Dest);
  if Pos >= L then begin
    Dest[L]   := C;
    Dest[L+1] := #0;
  end else begin
    // StrCopy does not work here...
    Move(Dest[Pos], Dest[Pos+1], (L-Pos+1)*SizeOf(Char));
    Dest[Pos] := C;
  end;
end;

function StrChPos(P : PChar; C : Char;
                  var Pos : Cardinal): Boolean; register;
  {-Sets Pos to position of character C within string P returns True if found

   Changes:
     01/2010, SZ: Unicode verified 27.01.2010
     03/2011, AB: PUREPASCAL-version added (identical to unicode-version)
     09/2011, AB: Fix for issue 3405788 as suggested by Wolfgang Klein }
var
  Tmp: PChar;
begin
  Tmp := StrScan(P, C);
  Result := Tmp <> nil;
  if Result then
    Pos := Tmp - P;
end;

procedure StrInsertChars(Dest : PChar; Ch : Char; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos

   Changes:
     03/2011, AB: Bugfix: procedure did not work for Count>1024 }
var
  Count1024: Word;
  A : array[0..1024] of Char;
begin
  repeat
    if Count<=1024 then Count1024 := Count else Count1024 := 1024;
    StrPCopy(A, StringOfChar(Ch, Count1024));
    StrStInsertPrim(Dest, A, Pos);
    Count := Count - Count1024;
  until Count=0;
end;


function StrStCopy(Dest : PChar; S : PChar; Pos, Count : Cardinal) : PChar;
  {-Copy characters at a specified position in a PChar string}
var
  Len : Cardinal;
begin
  Len := StrLen(S);
  if Pos < Len then begin
    if (Len-Pos) < Count then
      Count := Len-Pos;
    Move(S[Pos], Dest^, Count * SizeOf(Char));
    Dest[Count] := #0;
  end else
    Dest[0] := #0;
  Result := Dest;
end;


function StrStDeletePrim(P : PChar; Pos, Count : Cardinal) : PChar; register;
  {-Primitive routine to delete a sub-string from a PChar string

   Changes:
     01/2010, SZ: Unicode verified 27.01.2010
     03/2011, AB: Bugfixes: function did not work in several cases like
                            P='' or Pos=0 & Count>StrLen(P)
                  Added PUREPASCAL version }
var
  LP: Cardinal;
begin
  result := P;
  LP := StrLen(P);
  if Pos>=LP then
    Exit;               { nothing to do if Pos>=StrLen(P) }
  if Pos + Count >= LP then
    P[Pos] := #0
  else
    Move(P[Pos+Count], P[Pos], (LP-Pos-Count+1)*SizeOf(Char));
end;

function StrStInsert(Dest : PChar; S1, S2 : PChar; Pos : Cardinal) : PChar;
begin
  StrCopy(Dest, S1);
  Result := StrStInsertPrim(Dest, S2, Pos);
end;

function StrStInsertPrim(Dest : PChar; S : PChar;
                         Pos : Cardinal) : PChar; register;
  {-Insert a PChar string into another at a specified position. This
    primitive version modifies the source directly

   Changes:
     01/2010, SZ: Unicode verified 27.01.2010
     03/2011, AB: Added PUREPASCAL version }

var
  LS, LD: Cardinal;
begin
  result := Dest;
  LS := StrLen(S);
  if LS=0 then Exit;     { nothing to do if S='' }

  LD := StrLen(Dest);
  if Pos > LD then
    Pos := LD;           { Append if Pos>StrLen(Dest) }
  Move(Dest[Pos], Dest[Pos+LS], (LD-Pos+1)*SizeOf(Char));
                         { get space for S }
  Move(S[0], Dest[Pos], LS*SizeOf(Char));
                         { insert S  into Dest }
end;

function StrStPos(P, S : PChar; var Pos : Cardinal) : boolean; register;
  {-Sets Pos to position of S in P, returns True if found

   Changes:
     01/2010, SZ: Unicode verified 27.01.2010
     03/2011, AB: Added PUREPASCAL version (identical to unicode-version) }
var
  Q: PChar;
begin
  Q := StrPos(P, S);
  if Q = nil then
  begin
    Pos := 0;
    Result := False;
  end
  else
  begin
    Pos := Q - P;
    Result := True;
  end;
end;

function StrToLongPChar(S : PChar; var I : NativeInt) : Boolean;
  {-Convert a string to a Integer, returning true if successful}
//SZ Unicode verified 27.01.2010
var
  Code : Cardinal;
  P    : array[0..255] of Char;
begin
  if StrLen(S)+1 > SizeOf(P) then begin
    Result := False;
    I := -1;
    Exit;
  end;
  StrCopy(P, S);
  TrimTrailPrimPChar(P);
  if StrStPos(P, '0x', Code) then begin
    StrStDeletePrim(P, Code, 2);
    StrChInsertPrim(P, '$', Code);
  end;
  Val(P, I, Code);
  if Code <> 0 then begin
    I := Code - 1;
    Result := False;
  end else
    Result := True;
end;


procedure TrimAllSpacesPChar(P : PChar);
  {-Trim leading and trailing blanks from P}
var
  I : Integer;
  PT : PChar;
begin
  I := StrLen(P);
  if I = 0 then
    Exit;

  {delete trailing spaces}
  Dec(I);
  while (I >= 0) and (P[I] = ' ') do begin
    P[I] := #0;
    Dec(I);
  end;

  {delete leading spaces}
  I := 0;
  PT := P;
  while PT^ = ' ' do begin
    Inc(I);
    Inc(PT);
  end;
  if I > 0 then
    StrStDeletePrim(P, 0, I);
end;


function TrimEmbeddedZeros(const S : string) : string;
  {-trim embedded zeros from a numeric string in exponential format

   Changes:
     03/2011, AB: Bugfix: function result was undefined for Pos('E',S)=0 }
var
  I, J : Integer;
begin
  Result := S;

  I := Pos('E', S);
  if I = 0 then
    Exit;  {nothing to do}

  {get rid of excess 0's after the decimal point}
  J := I;
  while (J > 1) and (Result[J-1] = '0') do
    Dec(J);
  if J <> I then begin
    System.Delete(Result, J, I-J);

    {get rid of the decimal point if that's all that's left}
    if (J > 1) and (Result[J-1] = '.') then
      System.Delete(Result, J-1, 1);
  end;

  {get rid of excess 0's in the exponent}
  I := Pos('E', Result);
  if I > 0 then begin
    Inc(I);
    J := I;
    while Result[J+1] = '0' do
      Inc(J);
    if J > I then
      System.Delete(Result, I+1, J-I);
  end;
end;


procedure TrimEmbeddedZerosPChar(P : PChar);
  {-Trim embedded zeros from a numeric string in exponential format}
var
  I, J : Cardinal;
begin
  if not StrChPos(P, 'E', I) then
    Exit;

  {get rid of excess 0's after the decimal point}
  J := I;
  while (J > 0) and (P[J-1] = '0') do
    Dec(J);
  if J <> I then begin
    StrStDeletePrim(P, J, I-J);

    {get rid of the decimal point if that's all that's left}
    if (J > 0) and (P[J-1] = '.') then
      StrStDeletePrim(P, J-1, 1);
  end;

  {Get rid of excess 0's in the exponent}
  if StrChPos(P, 'E', I) then begin
    Inc(I);
    J := I;
    while P[J+1] = '0' do
      Inc(J);
    if J > I then
      if P[J+1] = #0 then
        P[I-1] := #0
      else
        StrStDeletePrim(P, I+1, J-I);
  end;
end;


function TrimTrailingZeros(const S : string) : string;
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.

   Changes:
     03/2011, AB: Bugfix: function result was undefined for S='' }
var
  I : Integer;
begin
  Result := S;

  if S = '' then
    Exit;

  I := Length(Result);
  {delete trailing zeros}
  while (Result[I] = '0') and (I > 1) do
    Dec(I);
  {delete decimal point, if any}
  if Result[I] = '.' then
    Dec(I);
  Result := Trim(Copy(Result, 1, I));
end;


procedure TrimTrailingZerosPChar(P : PChar);
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
var
  PT : PChar;
begin
  PT := StrEnd(P);
  if Pointer(PT) = Pointer(P) then
    Exit;

  {back up to character prior to null}
  Dec(PT);

  {delete trailing zeros}
  while PT^ = '0' do begin
    PT^ := #0;
    Dec(PT);
  end;

  {delete decimal point, if any}
  if PT^ = '.' then
    PT^ := #0;

  TrimAllSpacesPChar(P);
end;


function TrimTrailPrimPChar(S : PChar) : PChar; register;
  {-delete trailing whitespace

   Changes:
     03/2011, AB: PUREPASCAL-version added
                  Bugfix: unicode-version deleted spaces only
                  Bugfix: loop for deleting whitespace in the ansi-version did
                          not stop at the beginning of the string (function could
                          wreak havoc if S = '  '). }
var
  PEnd: PChar;
begin
  PEnd := S + StrLen(S) - 1;
  while (PEnd >= S) and (PEnd^ <= ' ') do
    Dec(PEnd);
  PEnd[1] := #0;
  Result := S;
end;

function TrimTrailPChar(Dest, S : PChar) : PChar;
  {-Return a string with trailing white space removed}
begin
  StrCopy(Dest, S);
  Result := TrimTrailPrimPChar(Dest);
end;


function UpCaseChar(C: Char) : Char; register;
  {-Convert C to upper case

   Changes:
     03/2011, AB: PUREPASCAL-version added }
begin
  { CharUpper is defined as function CharUpper(P:PChar): PChar.
    However, this Windows-function will transform a character C to
    uppercase if the character ist passed to the function - in this
    case, the new charater will be returned. }
  result := Char(CharUpper(PChar(C)));
end;

function ovc32StringIsCurrentCodePage(const S: string): Boolean;
// returns True if a string can be displayed using the current system codepage
const
  WC_NO_BEST_FIT_CHARS = $00000400;
  CP_APC = 0;
var
  UsedDefaultChar: BOOL;   // not Boolean!!
  Len: Integer;
begin
  if Length(S) = 0 then
  begin
    Result := True;
    Exit;
  end;

  UsedDefaultChar := False;
  Len := WideCharToMultiByte(CP_APC, WC_NO_BEST_FIT_CHARS, PWideChar(S), Length(S), nil, 0, nil, @UsedDefaultChar);
  if Len <> 0 then
    Result := not UsedDefaultchar
  else
    Result := False;
end;

function ovc32StringIsCurrentCodePage(const S: PWideChar; CP:Cardinal=0{CP_APC}): Boolean;
// returns True if a string can be displayed using the current system codepage
const
  WC_NO_BEST_FIT_CHARS = $00000400;
var
  UsedDefaultChar: BOOL;   // not Boolean!!
  LenS, Len: Integer;
begin
  // A.B. StrLen(S)=0 does not work in Delphi 2006
  LenS := StrLen(S);

  if LenS=0 then
  begin
    Result := True;
    Exit;
  end;

  UsedDefaultChar := False;
  Len := WideCharToMultiByte(CP, WC_NO_BEST_FIT_CHARS, S, LenS, nil, 0, nil, @UsedDefaultChar);
  if Len <> 0 then
    Result := not UsedDefaultchar
  else
    Result := False;
end;

end.

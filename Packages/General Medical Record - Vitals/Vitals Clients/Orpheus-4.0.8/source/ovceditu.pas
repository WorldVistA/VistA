{*********************************************************}
{*                  OVCEDITU.PAS 4.06                    *}
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
{*                                                                            *}
{* Roman Kassebaum                                                            *}
{* Armin Biernaczyk                                                           *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovceditu;
  {-Editor utility routines}

interface

uses
  OvcBase;

type
  TOvcEditBase = class(TOvcCustomControlEx);

type
  TMarker = packed record
    Para  : Integer;  {number of paragraph}
    Pos   : Integer;  {position in paragraph}
  end;
  TMarkerArray = array[0..9] of TMarker;

type
  {text position record}
  TOvcTextPos = packed record
    Line : Integer;
    Col  : Integer;
  end;

function edBreakPoint(S : PChar; MaxLen : Word): Word;
  {-return the position to word break S}
procedure edDeleteSubString(S : PChar; SLen, Count, Pos : Integer);
  {-delete Cound characters from S starting at Pos}
function edEffectiveLen(S : PChar; Len : Word; TabSize : Byte) : Word;
  {-compute effective length of S, accounting for tabs}
function edFindNextLine(S : PChar; WrapCol : Integer) : PChar;
  {-find the start of the next line}
function edFindPosInMap(Map: Pointer; Lines, Pos : Word) : Word;
  {-return the para position}
function edGetActualCol(S : PChar; Col : Word; TabSize : Byte) : Word;
  {-compute actual column for effective column Col, accounting for tabs}
function edHaveTabs(S : PChar; Len : Cardinal) : Boolean;
  {Return True if tab are found in S}
function edPadPrim(S : PChar; Len : Word) : PChar;
  {-return a string right-padded to length len with blanks}
function edScanToEnd(P : PChar; Len : Word) : Word;
  {-return position of end of para P}
function edStrStInsert(Dest, S : PChar; DLen, SLen, Pos : Word) : PChar;
  {-insert S into Dest}
function edWhiteSpace(C : Char) : Boolean;
  {-return True if C is a white space character}


implementation


uses
   Windows, SysUtils;

function edBreakPoint(S : PChar; MaxLen : Word): Word;
  {-return the position to word break S}
begin
  result := MaxLen;
  while (result > 0) and not edWhiteSpace(S[result-1]) do
    Dec(result);
  if result = 0 then
    result := MaxLen;
end;


procedure edDeleteSubString(S : PChar; SLen, Count, Pos : Integer);
  {-delete Count characters from S starting at Pos}
begin
  if Pos<SLen then
    Move(S[Pos+Count], S[Pos], ((SLen+1)-(Pos+Count)) * SizeOf(Char));
end;


function edEffectiveLen(S : PChar; Len : Word; TabSize : Byte) : Word; register;
  {-compute effective length of S, accounting for tabs
    The function returns the length of S with <tab>-characters expanded to spaces; only the
    first 'Len' characters of S are taken into account. Examples
    S = '1234567890'; Len=20            -> result = 10
    S = '1234567890'; Len= 5            -> result =  5
    S = '1234'#9'90'; Len=20; TabSize=8 -> result = 10
    S = '1234'#9'90'; Len= 5; TabSize=8 -> result =  8 }
var
  i: Word;
begin
  result := 0;
  i := 0;
  while (i<Len) and (S[i]<>#0) do begin
    if S[i]<>#9 then
      Inc(result)
    else
      result := ((result div TabSize) + 1) * TabSize;
    Inc(i);
  end;
end;

function edFindNextLine(S : PChar; WrapCol : Integer) : PChar; register;
  {-find the start of the next line
    1) Find the last '-'/' '/#9 before or at position WrapCol
       If there is none, return pointer to S[WrapCol]
    2) Find the first character behind the ohne found in step 1 that is neither ' '
       nor #9. Return a pointer to this character. }
var
  c: Char;
begin
  result := @S[WrapCol];
  if S[WrapCol]<>#0 then begin
    repeat
      c := S[WrapCol];
      if (c<>'-') and (c<>' ') and (c<>#9) then
        Dec(WrapCol)
      else begin
        Inc(WrapCol);
        while (S[WrapCol]=' ') or (S[WrapCol]=#9) do Inc(WrapCol);
        result := @S[WrapCol];
        break;
      end;
    until WrapCol=0;
  end;
end;

function edFindPosInMap(Map: Pointer; Lines, Pos : Word) : Word; register;
  {-return the para position}
type
  PLineMap = ^LineMap;
  LineMap  = array[1..High(SmallInt)] of Word;
begin
  result := Lines;
  Dec(Pos);
  while (result>=1) and (Pos<PLineMap(Map)^[result]) do
    Dec(result);
end;

function edGetActualCol(S : PChar; Col : Word; TabSize : Byte) : Word; register;
  {-compute actual column for effective column Col, accounting for tabs
    (If Col is the column in S with "expanded" tabs, the function returns the column in S:
     e.g. for TabSize=6:

                              1  2  3  4  5  6  7  8  9
                          S = a  b  c #9  x #9  r  s  t

     S (with expanded tabs) = a  b  c  _  _  _  x  _  _  _  _  _  r  s  t
                        Col = 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
                     result = 1  2  3  4  4  4  5  6  6  6  6  6  7  8  9  }
var
  c: Word;
begin
  result := 1;
  c := 0;
  repeat
    if S^=#0 then
      Break
    else begin
      if S^=#9 then
        c := (c div TabSize + 1) * TabSize
      else
        Inc(c);
      if c+1<=Col then Inc(result);
    end;
    Inc(S);
  until c+1 >= Col;
end;

function edHaveTabs(S : PChar; Len : Cardinal) : Boolean; register;
  {-return True if tabs are found in S
    Note: this routine returns true if Len=0}
begin
  if Len=0 then
    result := True
  else begin
    while (Len>0) and (S^<>#9) do begin
      Inc(S);
      Dec(Len);
    end;
    result := Len>0;
  end;
end;

function edPadPrim(S : PChar; Len : Word) : PChar; register;
  {-return S padded with C to length Len}
var
  i: Integer;
begin
  i := 0;
  while S[i]<>#0 do Inc(i);
  if i<Len then begin
    while i<Len do begin
      S[i] := ' ';
      Inc(i);
    end;
    S[i] := #0;
  end;
  result := S;
end;

function edScanToEnd(P : PChar; Len : Word) : Word; register;
  {-return position of end of para P
    (The smallest index 0<i<=Len for which P[i-1]=#10; i=Len if there is no #10.) }
begin
  result := 0;
  while (result<Len) and (P[result]<>#10) do
    Inc(result);
  if result<Len then
    Inc(result);
end;

function edStrStInsert(Dest, S : PChar; DLen, SLen, Pos : Word) : PChar; register;
  {-insert S into Dest
    Dest must point to a buffer for DLen+SLen+1 characters. S will be inserted into Dest
    at position Pos (Pos=0: insert at the beginning).
    The function will do nothing if SLen=0 or Pos>DLen. }
begin
  result := Dest;
  if (Pos <= DLen) and (SLen > 0) then begin
    SysUtils.StrMove(Dest+(Pos+SLen), Dest+Pos, DLen+1-Pos);
    SysUtils.StrMove(Dest+Pos, S, SLen);
  end;
end;

function edWhiteSpace(C : Char) : Boolean; register;
  {-return True if C is a white space character}
begin
  result := (C = ' ') or (C = #9);
end;

end.

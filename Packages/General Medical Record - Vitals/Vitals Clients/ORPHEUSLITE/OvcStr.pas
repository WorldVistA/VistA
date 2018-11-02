{*********************************************************}
{*                   OVCSTR.PAS 4.06                    *}
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

type
  BTable = array[0..255] of Byte;
  {table used by the Boyer-Moore search routines}

function BinaryBPChar(Dest : PAnsiChar; B : Byte) : PAnsiChar;
  {-Return a binary PAnsiChar string for a byte}
function BinaryLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return the binary PAnsiChar string for a long integer}
function BinaryWPChar(Dest : PAnsiChar; W : Word) : PAnsiChar;
  {-Return the binary PAnsiChar string for a word}
procedure BMMakeTable(MatchString : PAnsiChar; var BT : BTable);
  {-Build a Boyer-Moore link table}
function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
                  MatchString : PAnsiChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string}
function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
                    MatchString : PAnsiChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string. This
    search is not case sensitive}
function CharStrPChar(Dest : PAnsiChar; C : AnsiChar; Len : Cardinal) : PAnsiChar;
  {-Return a PAnsiChar string filled with the specified character}
function DetabPChar(Dest : PAnsiChar; Src : PAnsiChar; TabSize : Byte) : PAnsiChar;
  {-Expand tabs in a PAnsiChar string to blanks}
function HexBPChar(Dest : PAnsiChar; B : Byte) : PAnsiChar;
  {-Return hex PAnsiChar string for byte}
function HexLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return the hex PAnsiChar string for a long integer}
function HexPtrPChar(Dest : PAnsiChar; P : Pointer) : PAnsiChar;
  {-Return hex PAnsiChar string for pointer}
function HexWPChar(Dest : PAnsiChar; W : Word) : PAnsiChar;
  {-Return the hex PAnsiChar string for a word}
function LoCaseChar(C : AnsiChar) : AnsiChar;
  {-Convert C to lower case}
function OctalLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return the octal PAnsiChar string for a long integer}
function StrChDeletePrim(P : PAnsiChar; Pos : Cardinal) : PAnsiChar;
  {-Primitive routine to delete a character from a PAnsiChar string}
function StrChInsertPrim(Dest : PAnsiChar; C : AnsiChar; Pos : Cardinal) : PAnsiChar;
  {-Primitive routine to insert a character into a PAnsiChar string}
function StrChPos(P : PAnsiChar; C : AnsiChar; var Pos : Cardinal) : Boolean;
  {-Sets Pos to location of C in P, return is True if found}
procedure StrInsertChars(Dest : PAnsiChar; Ch : AnsiChar; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos}
function StrStCopy(Dest, S : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar;
  {-Copy characters at a specified position in a PAnsiChar string}
function StrStDeletePrim(P : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar;
  {-Primitive routine to delete a sub-string from a PAnsiChar string}
function StrStInsert(Dest, S1, S2 : PAnsiChar; Pos : Cardinal) : PAnsiChar;
  {-Insert a PAnsiChar string into another at a specified position}
function StrStInsertPrim(Dest, S : PAnsiChar; Pos : Cardinal) : PAnsiChar;
  {-Insert a PAnsiChar string into another at a specified position. This
    primitive version modifies the source directly}
function StrStPos(P, S : PAnsiChar; var Pos : Cardinal) : Boolean;
  {-Sets Pos to position of the S in P, returns True if found}
function StrToLongPChar(S : PAnsiChar; var I : LongInt) : Boolean;
  {-Convert a PAnsiChar string to a long integer}
procedure TrimAllSpacesPChar(P : PAnsiChar);
  {-Trim leading and trailing blanks from P}
function TrimEmbeddedZeros(const S : string) : string;
  {-Trim embedded zeros from a numeric string in exponential format}
procedure TrimEmbeddedZerosPChar(P : PAnsiChar);
  {-Trim embedded zeros from a numeric PAnsiChar string in exponential format}
function TrimTrailPrimPChar(S : PAnsiChar) : PAnsiChar;
  {-Return a PAnsiChar string with trailing white space removed}
function TrimTrailPChar(Dest, S : PAnsiChar) : PAnsiChar;
  {-Return a PAnsiChar string with trailing white space removed}
function TrimTrailingZeros(const S : string) : string;
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
procedure TrimTrailingZerosPChar(P : PAnsiChar);
  {-Trim trailing zeros from a numeric PAnsiChar string. It is assumed that
    there is a decimal point prior to the zeros. Also strips leading spaces.}
function UpCaseChar(C : AnsiChar) : AnsiChar;
  {-Convert a character to uppercase using the AnsiUpper API}


implementation

uses
  Windows, SysUtils;

const
  Digits : array[0..$F] of AnsiChar = '0123456789ABCDEF';

function BinaryBPChar(Dest : PAnsiChar; B : Byte) : PAnsiChar;
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

function BinaryLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return binary string for LongInt}
var
  I : LongInt;
begin
  Result := Dest;
  for I := 31 downto 0 do begin
    Dest^ := Digits[Ord(L and LongInt(1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

function BinaryWPChar(Dest : PAnsiChar; W : Word) : PAnsiChar;
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

procedure BMMakeTable(MatchString : PAnsiChar; var BT : BTable); register;
  {Build Boyer-Moore link table}
asm
  push  esi             { Save registers because they will be changed }
  push  edi
  push  ebx

  cld                   { Ensure forward string ops }
  mov   edi, eax        { Move EAX to ESI & EDI }
  mov   esi, eax
  xor   eax, eax        { Zero EAX }
  or    ecx, -1
  repne scasb           { Search for null terminator }
  not   ecx
  dec   ecx             { ECX is length of search string }
  cmp   ecx, 0FFh       { If ECX > 255, force to 255 }
  jbe   @@1
  mov   ecx, 0FFh

@@1:
  mov   ch, cl          { Duplicate CL in CH }
  mov   eax, ecx        { Fill each byte in EAX with length }
  shl   eax, 16
  mov   ax, cx
  mov   edi, edx        { Point to the table }
  mov   ecx, 64         { Fill table bytes with length }
  rep   stosd
  cmp   al, 1           { If length >= 1, we're done }
  jbe   @@MTDone
  mov   edi, edx        { Reset EDI to beginning of table }
  xor   ebx, ebx        { Zero EBX }
  mov   cl, al          { Restore CL to length of string }
  dec   ecx

@@MTNext:
  lodsb                 { Load table with positions of letters }
  mov   bl, al          { That exist in the search string }
  mov   [edi+ebx], cl
  loop  @@MTNext

@@MTDone:
  pop   ebx             { Restore registers }
  pop   edi
  pop   esi
end;

function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PAnsiChar; var Pos : Cardinal) : Boolean; register;
var
  BufPtr : Pointer;
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BufLength to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasb               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  cmp   dl, 1               { Check to see if we have a trivial case }
  ja    @@BMSInit           { If Length(MatchString) > 1 do BM search }
  jb    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

  mov   al,[esi]            { If Length(MatchString) = 1 do a REPNE SCASB }
  mov   ebx, edi
  repne scasb
  jne   @@BMSNotFound       { No match during REP SCASB }
  dec   edi                 { Found, calculate position }
  sub   edi, ebx
  mov   esi, Pos            { Set position in Pos }
  mov   [esi], edi
  mov   eax, 1              { Set result to True }
  jmp   @@BMSDone           { We're done }

@@BMSInit:
  dec   edx                 { Set up for BM Search }
  add   esi, edx            { Set ESI to end of MatchString }
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dh, [esi]           { Set DH to character we'll be looking for }
  dec   esi                 { Dec ESI in prep for BMSFound loop }
  std                       { Backward string ops }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
  mov   al, [ebx+eax]       { Look up skip distance from table }
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   al, [edi]           { Move character from buffer into AL for comparison }
  cmp   dh, al              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  dec   edi
  xor   ecx, ecx            { Zero ECX }
  mov   cl, dl              { Move Length(MatchString) to ECX }
  repe  cmpsb               { Compare MatchString to buffer }
  je    @@BMSFound          { If equal, string is found }

  mov   al, dl              { Move Length(MatchString) to AL }
  sub   al, cl              { Calculate offset that string didn't match }
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }
  inc   edi
  mov   al, dh              { Move character back to AL }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to start of match }
  mov   edx, BufPtr         { Move pointer to buffer into EDX }
  sub   edi, edx            { Calculate position of match }
  mov   eax, edi
  inc   eax
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  cld                       { Restore direction flag }
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;

function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PAnsiChar; var Pos : Cardinal) : Boolean; register;
  {- Case-insensitive search of Buffer for MatchString. Return indicates
     success or failure.  Assumes MatchString is already raised to
     uppercase (PRIOR to creating the table) -}
var
  BufPtr : Pointer;
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BufLength to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasb               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  or    dl, dl              { Check to see if we have a trivial case }
  jz    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

@@BMSInit:
  dec   edx                 { Set up for BM Search }
  add   esi, edx            { Set ESI to end of MatchString }
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dh, [esi]           { Set DH to character we'll be looking for }
  dec   esi                 { Dec ESI in prep for BMSFound loop }
  std                       { Backward string ops }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
  mov   al, [ebx+eax]       { Look up skip distance from table }
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   al, [edi]           { Move character from buffer into AL for comparison }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  cld
  call  CharUpper
  std
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  cmp   dh, al              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  dec   edi
  xor   ecx, ecx            { Zero ECX }
  mov   cl, dl              { Move Length(MatchString) to ECX }
  jecxz @@BMSFound          { If ECX is zero, string is found }

@@StringComp:
  mov   al, [edi]           { Get char from buffer }
  dec   edi                 { Dec buffer index }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  cld
  call  CharUpper
  std
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  mov   ah, al              { Move buffer char to AH }
  lodsb                     { Get MatchString char }
  cmp   ah, al              { Compare }
  loope @@StringComp        { OK?  Get next character }
  je    @@BMSFound          { Matched! }

  xor   ah, ah              { Zero AH }
  mov   al, dl              { Move Length(MatchString) to AL }
  sub   al, cl              { Calculate offset that string didn't match }
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }
  inc   edi
  mov   al, dh              { Move character back to AL }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to start of match }
  mov   edx, BufPtr         { Move pointer to buffer into EDX }
  sub   edi, edx            { Calculate position of match }
  mov   eax, edi
  inc   eax
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  cld                       { Restore direction flag }
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;

function CharStrPChar(Dest : PAnsiChar; C : AnsiChar;
                      Len : Cardinal) : PAnsiChar; register;
asm
  push    edi            { Save EDI-about to change it }
  push    eax            { Save Dest pointer for return }
  mov     edi, eax       { Point EDI to Dest }

  mov     dh, dl         { Dup character 4 times }
  mov     eax, edx
  shl     eax, $10
  mov     ax, dx

  mov     edx, ecx       { Save Len }

  cld                    { Forward! }
  shr     ecx, 2         { Store dword char chunks first }
  rep     stosd
  mov     ecx, edx       { Store remaining characters }
  and     ecx, 3
  rep     stosb

  xor     al,al          { Add null terminator }
  stosb

  pop     eax            { Return Dest pointer }
  pop     edi            { Restore orig value of EDI }
end;

function DetabPChar(Dest : PAnsiChar; Src : PAnsiChar;
                    TabSize : Byte) : PAnsiChar; register;
  { -Expand tabs in a string to blanks on spacing TabSize- }
asm
  push    eax           { Save Dest for return value }
  push    edi           { Save EDI, ESI and EBX, we'll be changing them }
  push    esi
  push    ebx

  mov     esi, edx      { ESI -> Src }
  mov     edi, eax      { EDI -> Dest }
  xor     ebx, ebx      { Get TabSize in EBX }
  add     bl, cl
  jz      @@Done        { Exit if TabSize is zero }

  cld                   { Forward! }
  xor     edx, edx      { Set output length to zero }

@@Next:
  lodsb                 { Get next input character }
  or      al, al        { Is it a null? }
  jz      @@Done        { Yes-all done }
  cmp     al, 09        { Is it a tab? }
  je      @@Tab         { Yes, compute next tab stop }
  stosb                 { No, store to output }
  inc     edx           { Increment output length }
  jmp     @@Next        { Next character }

@@Tab:
  push    edx           { Save output length }
  mov     eax, edx      { Get current output length in DX:AX }
  xor     edx, edx
  div     ebx           { Output length MOD TabSize in DX }
  mov     ecx, ebx      { Calc number of spaces to insert... }
  sub     ecx, edx      { = TabSize - Mod value }
  pop     edx
  add     edx, ecx      { Add count of spaces into current output length }

  mov     eax,$2020     { Blank in AH, Blank in AL }
  shr     ecx, 1        { Store blanks }
  rep     stosw
  adc     ecx, ecx
  rep     stosb
  jmp     @@Next        { Back for next input }

@@Done:
  xor     al,al         { Store final null terminator }
  stosb

  pop     ebx           { Restore caller's EBX, ESI and EDI }
  pop     esi
  pop     edi
  pop     eax           { Return Dest }
end;

function HexBPChar(Dest : PAnsiChar; B : Byte) : PAnsiChar;
  {-Return hex string for byte}
begin
  Result := Dest;
  Dest^ := Digits[B shr 4];
  Inc(Dest);
  Dest^ := Digits[B and $F];
  Inc(Dest);
  Dest^ := #0;
end;

function HexLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return the hex string for a long integer}
var
  T2 : Array[0..4] of AnsiChar;
begin
  Result := StrCat(HexWPChar(Dest, HIWORD(L)), HexWPChar(T2, LOWORD(L)));
end;

function HexPtrPChar(Dest : PAnsiChar; P : Pointer) : PAnsiChar;
  {-Return hex string for pointer}
var
  T2 : Array[0..4] of AnsiChar;
begin
  StrCat(HexWPChar(Dest, HIWORD(LongInt(P))), ':');
  Result := StrCat(Dest, HexWPChar(T2, LOWORD(LongInt(P))));
end;

function HexWPChar(Dest : PAnsiChar; W : Word) : PAnsiChar;
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

function LoCaseChar(C: AnsiChar) : AnsiChar; register;
asm
  mov   edx, eax
  xor   eax, eax
  mov   al, dl
  push  eax
  call  CharLower
end;

function OctalLPChar(Dest : PAnsiChar; L : LongInt) : PAnsiChar;
  {-Return the octal PAnsiChar string for a long integer}
var
  I : LongInt;
begin
  Result := Dest;
  FillChar(Dest^, 12, '0');
  Dest[12] := #0;
  for I := 11 downto 0 do begin
    if L = 0 then
      Exit;

    Dest[I] := Digits[L and 7];
    L :=  L shr 3;
  end;
end;

function StrChDeletePrim(P : PAnsiChar; Pos : Cardinal) : PAnsiChar; register;
asm
  push   edi             { Save because we will be changing them }
  push   esi
  push   ebx

  mov    ebx, eax        { Save P to EDI & EBX }
  mov    edi, eax

  xor    al, al          { Zero }
  or     ecx, -1         { Set ECX to $FFFFFFFF }
  cld
  repne  scasb           { Find null terminator }
  not    ecx
  jecxz  @@ExitPoint
  sub    ecx, edx        { Calc number to move }
  jb     @@ExitPoint     { Exit if Pos > StrLen }

  mov    edi, ebx
  add    edi, edx        { Point to position to adjust }
  mov    esi, edi
  inc    esi             { Offset for source string }
  inc    ecx             { One more to include null terminator }
  rep    movsb           { Adjust the string }
@@ExitPoint:

  mov    eax, ebx
  pop    ebx             { restore registers }
  pop    esi
  pop    edi
end;

function StrChInsertPrim(Dest : PAnsiChar; C : AnsiChar;
                         Pos : Cardinal) : PAnsiChar; register;
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  xor    ebx, ebx        {zero}
  mov    ebx, ecx        {move POS to ebx}

  mov    esi, eax        {copy Dest to ESI and EDI}
  mov    edi, eax

  xor    al, al          {zero}
  or     ecx, -1         {set ECX to $FFFFFFFF}
  cld                    {ensure forward}
  repne  scasb           {find null terminator}

  not    ecx             {calc length (including null)}
  std                    {backwards string ops}
  add    esi, ecx
  dec    esi             {point to end of source string}
  sub    ecx, ebx        {calculate number to do}
  jae    @@1             {append if Pos greater than strlen + 1}
  mov    ecx, 1

@@1:
  rep    movsb           {adjust tail of string}
  mov    eax, edx
  stosb                  {insert the new character}

@@ExitPoint:

  cld                    {be a good neighbor}
  pop    ebx             {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;

function StrChPos(P : PAnsiChar; C : AnsiChar;
                  var Pos : Cardinal): Boolean; register;
  {-Sets Pos to position of character C within string P returns True if found}
asm
  push   esi               {save since we'll be changing}
  push   edi
  push   ebx
  mov    esi, ecx          {save Pos}

  cld                      {forward string ops}
  mov    edi, eax          {copy P to EDI}
  or     ecx, -1
  xor    eax, eax          {zero}
  mov    ebx, edi          {save EDI to EBX}
  repne  scasb             {search for NULL terminator}
  not    ecx
  dec    ecx               {ecx has len of string}

  test   ecx, ecx
  jz     @@NotFound        {if len of P = 0 then done}

  mov    edi, ebx          {reset EDI to beginning of string}
  mov    al, dl            {copy C to AL}
  repne  scasb             {find C in string}
  jne    @@NotFound

  mov    ecx, edi          {calculate position of C}
  sub    ecx, ebx
  dec    ecx               {ecx holds found position}

  mov    [esi], ecx        {store location}
  mov    eax, 1            {return true}
  jmp    @@ExitCode

@@NotFound:
  xor    eax, eax

@@ExitCode:

  pop    ebx               {restore registers}
  pop    edi
  pop    esi
end;

procedure StrInsertChars(Dest : PAnsiChar; Ch : AnsiChar; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos}
var
  A : array[0..1024] of AnsiChar;
begin
  FillChar(A, Count, Ch);
  A[Count] := #0;
  StrStInsertPrim(Dest, A, Pos);
end;

function StrStCopy(Dest : PAnsiChar; S : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar;
var
  Len : Cardinal;
begin
  Len := StrLen(S);
  if Pos < Len then begin
    if (Len-Pos) < Count then
      Count := Len-Pos;
    Move(S[Pos], Dest^, Count);
    Dest[Count] := #0;
  end else
    Dest[0] := #0;
  Result := Dest;
end;

function StrStDeletePrim(P : PAnsiChar; Pos, Count : Cardinal) : PAnsiChar; register;
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move Count to BX}
  mov    esi, eax        {move P to ESI and EDI}
  mov    edi, eax

  xor    eax, eax        {null}
  or     ecx, -1
  cld
  repne  scasb           {find null terminator}
  not    ecx             {calc length}
  jecxz  @@ExitPoint

  sub    ecx, ebx        {subtract Count}
  sub    ecx, edx        {subtract Pos}
  jns    @@L1

  mov    edi,esi         {delete everything after Pos}
  add    edi,edx
  stosb
  jmp    @@ExitPoint

@@L1:
  mov    edi,esi
  add    edi,edx         {point to position to adjust}
  mov    esi,edi
  add    esi,ebx         {point past string to delete in src}
  inc    ecx             {one more to include null terminator}
  rep    movsb           {adjust the string}

@@ExitPoint:

  pop    ebx            {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;

function StrStInsert(Dest : PAnsiChar; S1, S2 : PAnsiChar; Pos : Cardinal) : PAnsiChar;
begin
  StrCopy(Dest, S1);
  Result := StrStInsertPrim(Dest, S2, Pos);
end;

function StrStInsertPrim(Dest : PAnsiChar; S : PAnsiChar;
                         Pos : Cardinal) : PAnsiChar; register;
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move POS to ebx}
  mov    esi, eax        {copy Dest to ESI, S to EDI}
  mov    edi, edx

  xor    al, al          {zero}
  or     ecx, -1         {set ECX to $FFFFFFFF}
  cld                    {ensure forward}
  repne  scasb           {find null terminator}
  not    ecx             {calc length of source string (including null)}
  dec    ecx             {length without null}
  jecxz  @@ExitPoint     {if source length = 0, exit}
  push   ecx             {save length for later}

  mov    edi, esi        {reset EDI to Dest}
  or     ecx, -1
  repne  scasb           {find null}
  not    ecx             {length of dest string}

  cmp    ebx, ecx
  jb     @@1
  mov    ebx, ecx
  dec    ebx

@@1:
  std                    {backwards string ops}
  pop    eax             {restore length of S from stack}
  add    edi, eax        {set EDI S beyond end of Dest}
  dec    edi             {back up one for null}

  add    esi, ecx        {set ESI to end of Dest}
  dec    esi             {back up one for null}
  sub    ecx, ebx        {# of chars in Dest that are past Pos}
  rep    movsb           {adjust tail of string}

  mov    esi, edx        {set ESI to S}
  add    esi, eax        {set ESI to end of S}
  dec    esi             {back up one for null}
  mov    ecx, eax        {# of chars in S}
  rep    movsb           {copy S into Dest}

  cld                    {be a good neighbor}

@@ExitPoint:
  pop    ebx             {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;

function StrStPos(P, S : PAnsiChar; var Pos : Cardinal) : boolean; register;
asm
  push   edi                 { Save registers }
  push   esi
  push   ebx
  push   ecx

  mov    ebx, eax            { Move P to EBX }
  mov    edi, edx            { Move S to EDI & ESI }
  mov    esi, edx

  xor    eax, eax            { Zero EAX }
  or     ecx, -1             { Set ECX to FFFFFFFF }
  repne  scasb               { Find null at end of S }
  not    ecx

  mov    edx, ecx            { Save length to EDX }
  dec    edx                 { EDX has len of S }
  test   edx, edx
  jz     @@NotFound          { If len of S = 0 then done }

  mov    edi, ebx            { Set EDI to beginning of P }
  or     ecx, -1             { Set ECX to FFFFFFFF }
  repne  scasb               { Find null at end of P }
  not    ecx
  dec    ecx                 { ECX has len of P }
  jcxz   @@NotFound          { If len of P = 0 then done }

  dec    edx
  sub    ecx,edx             { Max chars to search }
  jbe    @@NotFound          { Done if len S > len P }
  lodsb                      { Get first char of S in AL }
  mov    edi,ebx             { Set EDI to beginning of EDI }

@@Next:
  repne  scasb               { Find first char of S in P }
  jne    @@NotFound          { If not found then done }
  test   edx, edx            { If length of S was one then found }
  jz     @@Found
  push   ecx
  push   edi
  push   esi
  mov    ecx,edx
  repe   cmpsb               { See if remaining chars in S match }
  pop    esi
  pop    edi
  pop    ecx
  je     @@Found             { Yes, so found }
  jmp    @@Next              { Look for next first char occurrence }

@@NotFound:
  pop    ecx
  xor    eax,eax             { Set return to False }
  jmp    @@ExitPoint

@@Found:
  dec    edi                 { Calc position of found string }
  mov    eax, edi
  sub    eax, ebx
  pop    ecx
  mov    [ecx], eax
  mov    eax, 1              { Set return to True }

@@ExitPoint:
  pop    ebx                 { Restore registers }
  pop    esi
  pop    edi
end;

function StrToLongPChar(S : PAnsiChar; var I : LongInt) : Boolean;
  {-Convert a string to a longint, returning true if successful}
var
  Code : Cardinal;
  P    : array[0..255] of AnsiChar;
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

procedure TrimAllSpacesPChar(P : PAnsiChar);
  {-Trim leading and trailing blanks from P}
var
  I : Integer;
  PT : PAnsiChar;
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
  {-trim embedded zeros from a numeric string in exponential format}
var
  I, J : Integer;
begin
  I := Pos('E', S);
  if I = 0 then
    Exit;  {nothing to do}

  Result := S;

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

procedure TrimEmbeddedZerosPChar(P : PAnsiChar);
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
    a decimal point prior to the zeros. Also strips leading spaces.}
var
  I : Integer;
begin
  if S = '' then
    Exit;

  Result := S;
  I := Length(Result);
  {delete trailing zeros}
  while (Result[I] = '0') and (I > 1) do
    Dec(I);
  {delete decimal point, if any}
  if Result[I] = '.' then
    Dec(I);
  Result := Trim(Copy(Result, 1, I));
end;

procedure TrimTrailingZerosPChar(P : PAnsiChar);
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
var
  PT : PAnsiChar;
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

function TrimTrailPrimPChar(S : PAnsiChar) : PAnsiChar; register;
asm
   cld
   push   edi
   mov    edx, eax
   mov    edi, eax

   or     ecx, -1
   xor    al, al
   repne  scasb
   not    ecx
   dec    ecx
   jecxz  @@ExitPoint

   dec    edi

@@1:
   dec    edi
   cmp    byte ptr [edi],' '
   jbe    @@1
   mov    byte ptr [edi+1],00h
@@ExitPoint:
   mov    eax, edx
   pop    edi
end;

function TrimTrailPChar(Dest, S : PAnsiChar) : PAnsiChar;
  {-Return a string with trailing white space removed}
begin
  StrCopy(Dest, S);
  Result := TrimTrailPrimPChar(Dest);
end;

function UpCaseChar(C : AnsiChar) : AnsiChar; register;
asm
  and   eax, 0FFh
  push  eax
  call  CharUpper
end;

end.

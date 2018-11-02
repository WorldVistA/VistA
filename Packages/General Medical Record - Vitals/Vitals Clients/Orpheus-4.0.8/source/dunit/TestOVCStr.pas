{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOVCStr;

interface

uses
  TestFramework;

type
  TTestOVCStr = class(TTestCase)
  published
    procedure TestBinaryBPChar;
    procedure TestBinaryLPChar;
    procedure TestBinaryWPChar;
    procedure TestBMMakeTable;
    procedure TestBMSearch;
    procedure TestBMSearchUC;
    procedure TestCharStrPChar;
    procedure TestDetabPChar;
    procedure TestHexBPChar;
    procedure TestHexLPChar;
    procedure TestHexPtrPChar;
    procedure TestHexWPChar;
    procedure TestLoCaseChar;
    procedure TestOctalLPChar;
    procedure TestStrChDeletePrim;
    procedure TestStrChInsertPrim;
    procedure TestStrChPos;
    procedure TestStrInsertChars;
    procedure TestStrStCopy;
    procedure TestStrStDeletePrim;
    procedure TestStrStInsertPrim;
    procedure TestStrStPos;
    procedure TestStrToLongPChar;
    procedure TestTrimAllSpacesPChar;
    procedure TestTrimEmbeddedZeros;
    procedure TestTrimEmbeddedZerosPChar;
    procedure TestTrimTrailingZeros;
    procedure TestTrimTrailingZerosPChar;
    procedure TestTrimTrailPrimPChar;
    procedure TestUpCaseChar;
  end;

implementation

uses
  SysUtils, OvcStr;

{ TTestOVCStr }

procedure TTestOVCStr.TestBinaryBPChar;
const
  cSomeBytes : array[0..3] of Byte =
    (0, 170, 85, 255);
  cResults : array[0..3] of string =
    ('00000000', '10101010', '01010101', '11111111');
var
  i, j: Integer;
  Dest: array[0..10] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeBytes) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := BinaryBPChar(@Dest, cSomeBytes[i]);
    CheckTrue((P=@Dest) and (Dest[9]='z'), Format('BinaryBPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('BinaryBPChar failed for %d',[cSomeBytes[i]]));
  end;
end;


procedure TTestOVCStr.TestBinaryLPChar;
const
  cSomeLongInts : array[0..3] of Integer =
    (0, -1431655766, 1431655765, -1);
  cResults : array[0..3] of string =
    ('00000000000000000000000000000000', '10101010101010101010101010101010',
     '01010101010101010101010101010101', '11111111111111111111111111111111');
var
  i, j: Integer;
  Dest: array[0..33] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeLongInts) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := BinaryLPChar(@Dest, cSomeLongInts[i]);
    CheckTrue((P=@Dest) and (Dest[33]='z'), Format('BinaryLPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('BinaryLPChar failed for %d',[cSomeLongInts[i]]));
  end;
end;


procedure TTestOVCStr.TestBinaryWPChar;
const
  cSomeWords : array[0..3] of Word =
    (0, 43690, 21845, 65535);
  cResults : array[0..3] of string =
    ('0000000000000000', '1010101010101010', '0101010101010101', '1111111111111111');
var
  i, j: Integer;
  Dest: array[0..17] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeWords) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := BinaryWPChar(@Dest, cSomeWords[i]);
    CheckTrue((P=@Dest) and (Dest[17]='z'), Format('BinaryWPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('BinaryWPChar failed for %d',[cSomeWords[i]]));
  end;
end;


procedure TTestOVCStr.TestBMMakeTable;
type
  TData = record
    S: string;
    BT: BTable;
  end;
const
  cSomeData: array[0..3] of TData =
   ((S: 'ABCABC';
     BT: (6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,2,1,3,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,
          6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6)),
    (S: 'Franz jagt im komplett verwahrlosten Taxi quer durch Bayern';
     BT: (59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,
           6,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,
          59,59, 5,59,59,59,58,59,59,59,59,59,59,59,59,59,59,59,59,59,21,59,59,59,59,59,59,59,59,59,59,59,
          59, 4,59, 8,11, 2,59,50, 7,18,52,44,28,42,23,27,41,16, 1,26,25,10,35,32,19, 3,54,59,59,59,59,59,
          59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,
          59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,
          59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,
          59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59,59)),
    (S: 'Unicode characters: Россия является прекрасной стране';
     BT: (53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,
           6,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,34,53,53,53,53,53,
          53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,52,53,53,53,53,53,53,53,53,53,53,
          53,40,53,39,47,37,53,53,43,50,53,53,53,53,51,48,53,53,36,35,38,53,53,53,53,53,53,53,53,53,53,53,
          53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,
          53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,
          53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,
          53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53,53)),
    (S: '12345678901234567890123456789012345678901234567890123456789012345678901234567890'+
        '12345678901234567890123456789012345678901234567890123456789012345678901234567890'+
        '12345678901234567890123456789012345678901234567890123456789012345678901234567890'+
        '1234567890123456';
     BT: (255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,  6,  5,  4,  3,  2,  1, 10,  9,  8,  7,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
          255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255)));
var
  i,j: Integer;
  OK: Boolean;
  BT: BTable;
begin
  for i := 0 to High(cSomeData) do begin
    BMMakeTable(@cSomeData[i].S[1], BT);
    OK := True;
    j := 0;
    while OK and (j<=High(BTable)) do begin
      OK := cSomeData[i].BT[j] = BT[j];
      Inc(j);
    end;
    CheckTrue(OK, Format('BMMakeTable failed for %s',[cSomeData[i].S]));
  end;
end;


procedure TTestOVCStr.TestBMSearch;
var
  BT: BTable;
  Buffer: array[0..255] of Char;
  iPos, i: Integer;
  Pos: Cardinal;
const
  MatchStrings: array[0..6] of string =
    ('DELPHI XE', // Match at the beginning of the Buffer
     'Delphi XE', // Match in the middle of the Buffer
     'PASCAL',    // Match at the end of the Buffer
     'foo',       // No Match
     'D',         // Match at the beginning (single character)
     'X',         // Match in the middle (single character)
     '9');        // No Match
  Results: array[0..6] of Integer =
    (0, 19, 33, -1, 0, 7, -1);
begin
  { Test BMSearch:
    First set up a Buffer, in which some strings are going to be searched. }
  for i := Low(Buffer) to High(Buffer) do
    Buffer[i] := #0;
  Buffer := 'DELPHI XEaelphi XEqDelphi XEaqsdePASCAL';
  { BMSearch needs a Booyer-Moore Table that has to be computed from the
    MatchString, so we need to call 'BMMakeTable' before searching for
    'MatchStrings[i]'. }
  for i := Low(MatchStrings) to High(MatchStrings) do begin
    BMMakeTable(@MatchStrings[i][1], BT);
    if not BMSearch(Buffer,Length(Buffer), BT, @MatchStrings[i][1], Pos) then
      iPos := -1
    else
      iPos := Pos;
    CheckEquals(Results[i],iPos,Format('BMSearch failed for test %d',[i]));
  end;
end;

procedure TTestOVCStr.TestBMSearchUC;
var
  BT: BTable;
  Buffer: array[0..255] of Char;
  iPos, i: Integer;
  Pos: Cardinal;
const
  { Note: 'BMSearchUC' requires the MatchString to be uppercase. }
  MatchStrings: array[0..6] of string =
    ('DELPHI XE', // Match at the beginning of the Buffer
     'EAELP',     // Match in the middle of the Buffer
     'PASCAL',    // Match at the end of the Buffer
     'FOO',       // No Match
     'D',         // Match at the beginning (single character)
     'X',         // Match in the middle (single character)
     '9');        // No Match
  Results: array[0..6] of Integer =
    (0, 8, 33, -1, 0, 7, -1);
begin
  { Test BMSearchUC:
    First set up a Buffer, in which some strings are going to be searched. }
  for i := Low(Buffer) to High(Buffer) do
    Buffer[i] := #0;
  Buffer := 'DELPHI XEaelphi XEqDelphi XEaqsdePASCAL';
  { BMSearchUC needs a Booyer-Moore Table that has to be computed from the
    MatchString, so we need to call 'BMMakeTable' before searching for
    'MatchStrings[i]'. }
  for i := Low(MatchStrings) to High(MatchStrings) do begin
    BMMakeTable(@MatchStrings[i][1], BT);
    if not BMSearchUC(Buffer,Length(Buffer), BT, @MatchStrings[i][1], Pos) then
      iPos := -1
    else
      iPos := Pos;
    CheckTrue(iPos=Results[i]);
  end;
end;

procedure TTestOVCStr.TestCharStrPChar;
type
  TData = record
    c: Char;
    Len: Cardinal;
    res: string;
  end;
const
  cSomeData: array[0..5] of TData =
    ((c: 'x'; Len:  0; res: ''),
     (c: 'x'; Len:  1; res: 'x'),
     (c: 'x'; Len:  2; res: 'xx'),
     (c: 'x'; Len:  3; res: 'xxx'),
     (c: 'x'; Len:  4; res: 'xxxx'),
     (c: 'M'; Len: 42; res: 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM'));
var
  i, j: Integer;
  Dest: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    Dest := AllocMem((cSomeData[i].Len+2)*SizeOf(Char));
    try
      for j := 0 to cSomeData[i].Len+1 do
        Dest[j] := 'z';
      Dest := CharStrPChar(Dest, cSomeData[i].c, cSomeData[i].Len);
      CheckEqualsString(cSomeData[i].res, Dest, Format('TestCharStrPChar faild for test %d',[i]));
    finally
      FreeMem(Dest);
    end;
  end;
end;


procedure TTestOVCStr.TestDetabPChar;
const
  TestStrings: array[0..15] of string =
    ('Tab>'#9'<Tab',  'Tab>    <Tab',
     'Ohne Tab',      'Ohne Tab',
     #9#9#9,          '                        ',
     #9'abc',         '        abc',
     'xyz'#9,         'xyz     ',
     '1234567'#9'1',  '1234567 1',
     '12345678'#9'1', '12345678        1',
     '',              '');
var
  i: Integer;
  dest, src: array[0..50] of Char;
begin
  for i := 0 to High(TestStrings) div 2 do begin
    StrCopy(src,@TestStrings[2*i][1]);
    DetabPChar(dest, src, 8);
    CheckEqualsString(TestStrings[2*i+1],dest,Format('DeTab failed for "%s"',[TestStrings[2*i]]));
  end;
end;


procedure TTestOVCStr.TestHexBPChar;
const
  cSomeBytes : array[0..3] of Byte =
    (0, 170, 85, 255);
  cResults : array[0..3] of string =
    ('00', 'AA', '55', 'FF');
var
  i, j: Integer;
  Dest: array[0..3] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeBytes) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := HexBPChar(@Dest, cSomeBytes[i]);
    CheckTrue((P=@Dest) and (Dest[3]='z'), Format('HexBPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('HexBPChar failed for %d',[cSomeBytes[i]]));
  end;
end;


procedure TTestOVCStr.TestHexLPChar;
const
  cSomeLongInts : array[0..3] of Integer =
    (0, -1431655766, 1431655765, -1);
  cResults : array[0..3] of string =
    ('00000000', 'AAAAAAAA', '55555555', 'FFFFFFFF');
var
  i, j: Integer;
  Dest: array[0..9] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeLongInts) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := HexLPChar(@Dest, cSomeLongInts[i]);
    CheckTrue((P=@Dest) and (Dest[9]='z'), Format('HexLPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('HexLPChar failed for %d',[cSomeLongInts[i]]));
  end;
end;


procedure TTestOVCStr.TestHexPtrPChar;
const
  cSomePointers : array[0..3] of Pointer =
    (Pointer(0), Pointer(-1431655766), Pointer(1431655765), Pointer(-1));
  cResults : array[0..3] of string =
    ('0000:0000', 'AAAA:AAAA', '5555:5555', 'FFFF:FFFF');
var
  i, j: Integer;
  Dest: array[0..10] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomePointers) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := HexPtrPChar(@Dest, cSomePointers[i]);
    CheckTrue((P=@Dest) and (Dest[10]='z'), Format('HexPtrPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('HexPtrPChar failed for %d',[Cardinal(cSomePointers[i])]));
  end;
end;


procedure TTestOVCStr.TestHexWPChar;
const
  cSomeWords : array[0..3] of Word =
    (0, 43690, 21845, 65535);
  cResults : array[0..3] of string =
    ('0000', 'AAAA', '5555', 'FFFF');
var
  i, j: Integer;
  Dest: array[0..5] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeWords) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := HexWPChar(@Dest, cSomeWords[i]);
    CheckTrue((P=@Dest) and (Dest[5]='z'), Format('HexWPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('HexWPChar failed for %d',[cSomeWords[i]]));
  end;
end;


procedure TTestOVCStr.TestLoCaseChar;
const
  cSomeChars: array[0..9] of Char =
    ('a', 'A', 'ä', 'Ä', 'é', 'É', ' ', '1', 'Đ', 'ę');
  cResults: array[0..9] of Char =
    ('a', 'a', 'ä', 'ä', 'é', 'é', ' ', '1', 'đ', 'ę');
var
  i: Integer;
begin
  for i := 0 to High(cSomeChars) do
    CheckEqualsString(cResults[i],LoCaseChar(cSomeChars[i]),Format('LoCaseChar failed for "%s"',[cSomeChars[i]]));
end;


procedure TTestOVCStr.TestOctalLPChar;
const
  cSomeLongInts : array[0..3] of Integer =
    (0, -1431655766, 1431655765, -1);
  cResults : array[0..3] of string =
    ('000000000000', '025252525252', '012525252525', '037777777777');
var
  i, j: Integer;
  Dest: array[0..13] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeLongInts) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    P := OctalLPChar(@Dest, cSomeLongInts[i]);
    CheckTrue((P=@Dest) and (Dest[13]='z'), Format('OctalLPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P, Format('OctalLPChar failed for %d',[cSomeLongInts[i]]));
  end;
end;


procedure TTestOVCStr.TestStrChDeletePrim;
type
  TData = record
    S: string;
    Pos: Cardinal;
    res: string;
  end;
const
  cSomeData: array[0..4] of TData =
    ((S: '';        Pos: 1; res: ''),
     (S: 'abcdefg'; Pos: 0; res: 'bcdefg'),
     (S: 'abcdefg'; Pos: 3; res: 'abcefg'),
     (S: 'abcdefg'; Pos: 6; res: 'abcdef'),
     (S: 'abcdefg'; Pos: 7; res: 'abcdefg'));
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeData[i].S);
    P := StrChDeletePrim(@Dest, cSomeData[i].Pos);
    CheckTrue((P=@Dest) and (Dest[Length(cSomeData[i].S)+1]='z'),
      Format('StrChDeletePrim failed for test %d',[i]));
    CheckEqualsString(cSomeData[i].res, P,
      Format('StrChDeletePrim failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrChInsertPrim;
type
  TData = record
    S: string;
    Pos: Cardinal;
    c: Char;
    res: string;
  end;
const
  cSomeData: array[0..5] of TData =
    ((S: '';        Pos:  1; c: 'X'; res: 'X'),
     (S: 'abcdefg'; Pos:  0; c: ' '; res: ' abcdefg'),
     (S: 'abcdefg'; Pos:  3; c: 'X'; res: 'abcXdefg'),
     (S: 'abcdefg'; Pos:  6; c: 'X'; res: 'abcdefXg'),
     (S: 'abcdefg'; Pos: 10; c: 'X'; res: 'abcdefgX')
     ,
     (S: 'ЙКЛМСТУ'; Pos:  1; c: 'Ȁ'; res: 'ЙȀКЛМСТУ')
     );
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeData[i].S);
    P := StrChInsertPrim(@Dest, cSomeData[i].c, cSomeData[i].Pos);
    CheckTrue((P=@Dest) and (Dest[Length(cSomeData[i].res)+1]='z'),
      Format('StrChInsertPrim failed for test %d',[i]));
    CheckEqualsString(cSomeData[i].res, P,
      Format('StrChInsertPrim failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrChPos;
type
  TData = record
    S: string;
    c: Char;
    res: Integer;
  end;
const
  cSomeData: array[0..5] of TData =
    ((S: '';        c: 'X'; res: -1),
     (S: 'abcdefg'; c: ' '; res: -1),
     (S: 'abcdefg'; c: 'a'; res:  0),
     (S: 'abcdefg'; c: 'd'; res:  3),
     (S: 'abcdefg'; c: 'g'; res:  6),
     (S: 'ЙКЛМСТУ'; c: 'Л'; res: 2)
     );
var
  i: Integer;
  Pos: Cardinal;
  res: Boolean;
begin
  for i := 0 to High(cSomeData) do begin
    Pos := 42;
    res := StrChPos(@cSomeData[i].S[1], cSomeData[i].c, Pos);
    CheckEquals(cSomeData[i].res>=0, res,
      Format('StrChPos failed for test %d',[i]));
    if res then
      CheckEquals(cSomeData[i].res, Pos, Format('StrChPos failed for test %d',[i]))
    else
      CheckEquals(42, Pos, Format('StrChPos failed for test %d',[i]))
  end;
end;


procedure TTestOVCStr.TestStrInsertChars;
type
  TData = record
    S: string;
    c: Char;
    Pos, Count: Word;
    res: string;
  end;
const
  cSomeData: array[0..5] of TData =
    ((S: '';        c: 'X'; Pos: 0; Count: 5; res: 'XXXXX'),
     (S: 'abcdefg'; c: ' '; Pos: 0; Count: 2; res: '  abcdefg'),
     (S: 'abcdefg'; c: 'a'; Pos: 3; Count: 5; res: 'abcaaaaadefg'),
     (S: 'abcdefg'; c: 'd'; Pos: 7; Count: 3; res: 'abcdefgddd'),
     (S: 'abcdefg'; c: 'g'; Pos: 9; Count: 1; res: 'abcdefgg'),
     (S: 'ЙКЛМСТУ'; c: 'Л'; Pos: 1; Count: 4; res: 'ЙЛЛЛЛКЛМСТУ')
     );
var
  i, j: Integer;
  Dest: array[0..50] of Char;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeData[i].S);
    StrInsertChars(@Dest[0], cSomeData[i].c, cSomeData[i].Pos, cSomeData[i].Count);
    CheckEquals(cSomeData[i].res, Dest,
      Format('StrInsertChars failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrStCopy;
type
  TData = record
    S: string;
    Pos, Count: Cardinal;
    res: string;
  end;
const
  cSomeData: array[0..8] of TData =
    ((S: '';            Pos: 0; Count: 1; res: ''),
     (S: 'Delphi XE';   Pos: 0; Count: 3; res: 'Del'),
     (S: 'Delphi XE';   Pos: 4; Count: 5; res: 'hi XE'),
     (S: 'Delphi XE';   Pos: 6; Count: 1; res: ' '),
     (S: 'Delphi XE';   Pos: 0; Count:10; res: 'Delphi XE'),
     (S: 'Delphi XE';   Pos: 6; Count: 8; res: ' XE'),
     (S: 'Delphi XE';   Pos:10; Count: 3; res: ''),
     (S: 'ЙКЛМСТУ';     Pos: 3; Count: 2; res: 'МС'),
     (S: 'ЙКЛМСТУ';     Pos: 1; Count: 5; res: 'КЛМСТ')
    );
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  res: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    res := StrStCopy(@Dest[0], @cSomeData[i].S[1], cSomeData[i].Pos, cSomeData[i].Count);
    CheckTrue((@Dest[0]=res) and (Dest[Length(cSomeData[i].res)+1]='z'),
      Format('StrStCopy failed for test %d',[i]));
    CheckEqualsString(cSomeData[i].res, res,
      Format('StrStCopy failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrStDeletePrim;
type
  TData = record
    P: string;
    Pos, Count: Cardinal;
    res: string;
  end;
const
  cSomeData: array[0..8] of TData =
    ((P: '';            Pos: 0; Count: 1; res: ''),
     (P: 'Delphi XE';   Pos: 0; Count: 3; res: 'phi XE'),
     (P: 'Delphi XE';   Pos: 4; Count: 5; res: 'Delp'),
     (P: 'Delphi XE';   Pos: 6; Count: 1; res: 'DelphiXE'),
     (P: 'Delphi XE';   Pos: 0; Count:10; res: ''),
     (P: 'Delphi XE';   Pos: 6; Count: 8; res: 'Delphi'),
     (P: 'Delphi XE';   Pos:10; Count: 3; res: 'Delphi XE'),
     (P: 'ЙКЛМСТУ';     Pos: 3; Count: 2; res: 'ЙКЛТУ'),
     (P: 'ЙКЛМСТУ';     Pos: 1; Count: 5; res: 'ЙУ')
    );
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  res: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeData[i].P);
    res := StrStDeletePrim(@Dest[0], cSomeData[i].Pos, cSomeData[i].Count);
    CheckTrue((@Dest[0]=res) and (Dest[Length(cSomeData[i].P)+1]='z'),
      Format('StrStDeletePrim failed for test %d',[i]));
    CheckEqualsString(cSomeData[i].res, Dest,
      Format('StrStDeletePrim failed for test %d',[i]));
  end;
end;



procedure TTestOVCStr.TestStrStInsertPrim;
type
  TData = record
    Dest, S: string;
    Pos: Cardinal;
    res: string;
  end;
const
  cSomeData: array[0..9] of TData =
    ((Dest: '';            S: 'foo';    Pos: 0; res: 'foo'),
     (Dest: 'foofoo';      S: 'abc';    Pos: 3; res: 'fooabcfoo'),
     (Dest: 'fofoo';       S: 'WXYZ';   Pos: 0; res: 'WXYZfofoo'),
     (Dest: 'fuofuo';      S: 'foo';    Pos: 9; res: 'fuofuofoo'),
     (Dest: 'Delphi';      S: '';       Pos: 3; res: 'Delphi'),
     (Dest: 'abc';         S: 'def';    Pos: 3; res: 'abcdef'),
     (Dest: 'abc';         S: 'def';    Pos: 4; res: 'abcdef'),
     (Dest: '--';          S: '++++++'; Pos: 1; res: '-++++++-'),
     (Dest: 'ЙКЛМСТУ';     S: 'ЛМ';    Pos: 2; res: 'ЙКЛМЛМСТУ'),
     (Dest: 'ЙКЛМСТУ';     S: ' 123';  Pos: 0; res: ' 123ЙКЛМСТУ')
    );
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  res: PChar;
begin
  for i := 0 to High(cSomeData) do begin
    for j := 0to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeData[i].Dest);
    res := StrStInsertPrim(@Dest[0], @cSomeData[i].S[1], cSomeData[i].Pos);
    CheckTrue((@Dest[0]=res) and (Dest[Length(cSomeData[i].Dest)+Length(cSomeData[i].S)+1]='z'),
      Format('StrStInsertPrim failed for test %d',[i]));
    CheckEqualsString(cSomeData[i].res, Dest,
      Format('StrStInsertPrim failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrStPos;
type
  TData = record
    P, S: string;
    Pos: Cardinal;
    res: Boolean;
  end;
const
  cSomeData: array[0..7] of TData =
    ((P: '';            S: 'foo';   Pos: 0; res: False),
     (P: 'foofoo';      S: 'foo';   Pos: 0; res: True),
     (P: 'fofoo';       S: 'foo';   Pos: 2; res: True),
     (P: 'fuofuo';      S: 'foo';   Pos: 0; res: False),
     (P: 'xxxfooxxx';   S: 'foo';   Pos: 3; res: True),
     (P: 'foofoo';      S: '';      Pos: 0; res: False),
     (P: 'ЙКЛМСТУ';     S: 'ЛМ';    Pos: 2; res: True),
     (P: 'ЙКЛМСТУ';     S: 'CT';    Pos: 0; res: False)
    );
var
  i: Integer;
  Pos: Cardinal;
  res: Boolean;
begin
  for i := 0 to High(cSomeData) do begin
    res := StrStPos(@cSomeData[i].P[1], @cSomeData[i].S[1], Pos);
    CheckTrue(cSomeData[i].res=res,
      Format('StrStPos failed for test %d',[i]));
    if res then
      CheckEquals(cSomeData[i].Pos, Pos,
        Format('StrStPos failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestStrToLongPChar;
type
  TData = record
    S: string;
    res: Boolean;
    i: Integer;
  end;
const
  cSomeData: array[0..6] of TData =
    ((S: '';            res: False; i: 0),
     (S: '123456';      res: True;  i:123456),
     (S: '-12345';      res: True;  i:-12345),
     (S: '-2147483648'; res: True;  i:-2147483648),
     (S: '0xFFFF';      res: True;  i:65535),
     (S: '2147483647';  res: True;  i:2147483647),
     (S: 'ABC100';      res: False; i:0));
var
  i: Integer;
  j: NativeInt;
  res: Boolean;
begin
  for i := 0 to High(cSomeData) do begin
    res := StrToLongPChar(@cSomeData[i].S[1], j);
    CheckTrue(cSomeData[i].res=res,
      Format('StrToLongPChar failed for test %d',[i]));
    if res then
      CheckEquals(cSomeData[i].i, j,
        Format('StrToLongPChar failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimAllSpacesPChar;
const
  cSomeStrings: array[0..6] of string =
   ('123', '', 'ycdvf  ', '     XXXX   ', ' qwert', '    ', '   9   ');
  cResults: array[0..6] of string =
   ('123', '', 'ycdvf', 'XXXX', 'qwert', '', '9');
var
  i, j: Integer;
  Dest: array[0..50] of Char;
begin
  for i := 0 to High(cSomeStrings) do begin
    for j := 0to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeStrings[i]);
    TrimAllSpacesPChar(@Dest[0]);
    CheckTrue(Dest[Length(cSomeStrings[i])+1]='z',
      Format('TrimAllSpacesPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], Dest,
      Format('TrimAllSpacesPChar failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimEmbeddedZeros;
const
  cSomeStrings: array[0..7] of string =
   ('100.00', '', '1.12000E+10', '1.55E-2', '1.000E-10', '1.100001E+2', '1.230000E-03', '1E+005');
  cResults: array[0..7] of string =
   ('100.00', '', '1.12E+10', '1.55E-2', '1E-10', '1.100001E+2', '1.23E-3', '1E+5');
var
  i: Integer;
  res: string;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := TrimEmbeddedZeros(cSomeStrings[i]);
    CheckEqualsString(cResults[i], res,
      Format('TrimEmbeddedZeros failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimEmbeddedZerosPChar;
const
  cSomeStrings: array[0..7] of string =
   ('100.00', '', '1.12000E+10', '1.55E-2', '1.000E-10', '1.100001E+2', '1.230000E-03', '1E+005');
  cResults: array[0..7] of string =
   ('100.00', '', '1.12E+10', '1.55E-2', '1E-10', '1.100001E+2', '1.23E-3', '1E+5');
var
  i, j: Integer;
  Dest: array[0..50] of Char;
begin
  for i := 0 to High(cSomeStrings) do begin
    for j := 0to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeStrings[i]);
    TrimEmbeddedZerosPChar(@Dest[0]);
    CheckTrue(Dest[Length(cSomeStrings[i])+1]='z',
      Format('TrimEmbeddedZerosPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], Dest,
      Format('TrimEmbeddedZerosPChar failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimTrailingZeros;
const
  cSomeStrings: array[0..7] of string =
   ('100.00', '0.123000', '123', '100.', '0.0', '', '0.0001', '10.10');
  cResults: array[0..7] of string =
   ('100', '0.123', '123', '100', '0', '', '0.0001', '10.1');
var
  i: Integer;
  res: string;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := TrimTrailingZeros(cSomeStrings[i]);
    CheckEqualsString(cResults[i], res,
      Format('TrimTrailingZeros failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimTrailingZerosPChar;
const
  cSomeStrings: array[0..7] of string =
   ('100.00', '0.123000', '123', '100.', '0.0', '', '0.0001', '10.10');
  cResults: array[0..7] of string =
   ('100', '0.123', '123', '100', '0', '', '0.0001', '10.1');
var
  i, j: Integer;
  Dest: array[0..50] of Char;
begin
  for i := 0 to High(cSomeStrings) do begin
    for j := 0to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeStrings[i]);
    TrimTrailingZerosPChar(@Dest[0]);
    CheckTrue(Dest[Length(cSomeStrings[i])+1]='z',
      Format('TrimTrailingZerosPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], Dest,
      Format('TrimTrailingZerosPChar failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestTrimTrailPrimPChar;
const
  cSomeStrings: array[0..4] of string =
    ('', 'abc', ' abc   ', '   ', '123'#9#10' ');
  cResults: array[0..4] of string =
    ('', 'abc', ' abc', '', '123');
var
  i, j: Integer;
  Dest: array[0..50] of Char;
  P: PChar;
begin
  for i := 0 to High(cSomeStrings) do begin
    for j := 0 to High(Dest) do
      Dest[j] := 'z';
    StrPCopy(Dest, cSomeStrings[i]);
    P := TrimTrailPrimPChar(@Dest);
    CheckTrue((P=@Dest) and (Dest[Length(cSomeStrings[i])+1]='z'),
      Format('TrimTrailPrimPChar failed for test %d',[i]));
    CheckEqualsString(cResults[i], P,
      Format('TrimTrailPrimPChar failed for test %d',[i]));
  end;
end;


procedure TTestOVCStr.TestUpCaseChar;
const
  cSomeChars: array[0..9] of Char =
    ('a', 'A', 'ä', 'Ä', 'é', 'É', ' ', '1', 'Đ', 'ę');
  cResults: array[0..9] of Char =
    ('A', 'A', 'Ä', 'Ä', 'É', 'É', ' ', '1', 'Đ', 'Ę');
var
  i: Integer;
begin
  for i := 0 to High(cSomeChars) do
    CheckEqualsString(cResults[i],UpCaseChar(cSomeChars[i]),Format('UpCaseChar failed for "%s"',[cSomeChars[i]]));
end;


initialization
  RegisterTest(TTestOVCStr.Suite);

end.

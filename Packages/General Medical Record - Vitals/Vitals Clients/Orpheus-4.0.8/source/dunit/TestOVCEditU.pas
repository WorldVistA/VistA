{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is Roman Kassebaum              *}
{*                                                                            *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Roman Kassebaum                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}
unit TestOVCEditU;

interface

uses
  TestFramework, OvcEditU, OvcEditN;

type
  TestOvcEditUClass = class(TTestCase)
  published
    procedure TestedBreakPoint;
    procedure TestedDeleteSubString;
    procedure TestedEffectiveLen;
    procedure TestedFindNextLine;
    procedure TestedFindPosInMap;
    procedure TestedGetActualCol;
    procedure TestedPadPrim;
    procedure TestedScanToEnd;
    procedure TestedHaveTabs;
    procedure TestedStrStInsert;
    procedure TestedWhiteSpace;
  end;

implementation

uses
  SysUtils;

{ TestOvcEditUClass }

procedure TestOvcEditUClass.TestedBreakPoint;
const
  cSomeStrings: array[0..5] of string =
    ('12345678901234567890',
     '',
     'abcd abcd abcd',
     '1234'#9'1234'#9'1234'#9'1234'#9,
     '                    ',
     #9'asdfghjkl');
  cResults: array[0..5] of Word =
    (20, 0, 10, 20, 20, 1);
var
  i: Integer;
  res: Word;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := edBreakPoint(@cSomeStrings[i][1],Length(cSomeStrings[i]));
    CheckEquals(cResults[i], res, Format('edBreakPoint failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedDeleteSubString;
type
  TData = record
    S: string;
    Count, Pos: Integer;
    res: string;
  end;
const
  cSomeStrings: array[0..3] of TData =
    ((S: '1234567890'; Count:  1; Pos:  0; res: '234567890'),
     (S: '1234567890'; Count: 10; Pos:  0; res: ''),
     (S: '1234567890'; Count:  0; Pos:  1; res: '1234567890'),
     (S: '1234567890'; Count:  5; Pos:  5; res: '12345'));
var
  i: Integer;
  res: PChar;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := AllocMem((Length(cSomeStrings[i].S)+1)*SizeOf(Char));
    try
      StrPCopy(res, cSomeStrings[i].S);
      edDeleteSubString(res, Length(cSomeStrings[i].S), cSomeStrings[i].Count, cSomeStrings[i].Pos);
      CheckEquals(cSomeStrings[i].res, res, Format('edDeleteSubString failed for test %d',[i]));
    finally
      FreeMem(res);
    end;
  end;
end;


procedure TestOvcEditUClass.TestedEffectiveLen;
const
  cSomeStrings: array[0..5] of string =
    ('1234567890',
     '1234'#9'90',
     'abcd'#9#9#9'abcd',
     '',
     'abcdef',
     '1'#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9#9'2');
  cResults: array[0..5] of Integer =
    (10, 10, 28, 0, 6, 152);
var
  i, res: Integer;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := edEffectiveLen(@cSomeStrings[i][1],20,8);
    CheckEquals(cResults[i], res, Format('edEffectiveLen failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedFindNextLine;
const
  cSomeStrings: array[0..6] of string =
    ('123456789012345678901234567890',
     '1234567890123456789 1234567890',
     '123456789012345 1234567890',
     '12345678901234567        1234567890',
     '12345678901234567                  ',
     '12345 12345 12345-12345-123456 12345',
     '12345678901234567890-12345');
  cResults: array[0..6] of string =
    ('1234567890',
     '1234567890',
     '1234567890',
     '1234567890',
     '',
     '12345-123456 12345',
     '12345');
var
  i: Integer;
  res: PChar;
begin
  for i := 5 to High(cSomeStrings) do begin
    res := edFindNextLine(@cSomeStrings[i][1],20);
    CheckEquals(cResults[i], res, Format('edFindNextLine failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedFindPosInMap;
const
  cLineMap: array[0..9] of Word =
    (1,2,30,444,445,500,1011,32000,40001,65530);
  cSomePos: array[0..7] of Word =
    (0, 1, 2, 3, 1000, 32768, 65000, 65535);
  cResults: array[0..7] of Word =
    (10, 0, 1, 2, 6, 8, 9, 10);
var
  i: Integer;
  res: Word;
begin
  for i := 0 to High(cSomePos) do begin
    res := edFindPosInMap(@cLineMap[0], 10, cSomePos[i]);
    CheckEquals(cResults[i], res, Format('edFindPosInMap failed for "%d"',[cSomePos[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedGetActualCol;
type
  TData = record
    S: string;
    Col: Word;
    TabSize: Byte;
    res: Word;
  end;
const
  cSomeData: array[0..20] of TData =
    ((S: '1234567890123456789012345'; Col: 20; TabSize: 8; res: 20),
     (S: #9'90123456789012345';       Col: 20; TabSize: 8; res: 13),
     (S: 'abcd'#9#9#9'abcd';          Col: 20; TabSize: 8; res:  7),
     (S: '';                          Col: 20; TabSize: 8; res:  1),
     (S: 'abcdef';                    Col: 20; TabSize: 8; res:  7),
     (S: 'abcdef';                    Col:  1; TabSize: 8; res:  1),
     { example given in the function's documentation in ovceditu.pas. }
     (S: 'abc'#9'x'#9'rst';           Col:  1; TabSize: 6; res:  1),
     (S: 'abc'#9'x'#9'rst';           Col:  2; TabSize: 6; res:  2),
     (S: 'abc'#9'x'#9'rst';           Col:  3; TabSize: 6; res:  3),
     (S: 'abc'#9'x'#9'rst';           Col:  4; TabSize: 6; res:  4),
     (S: 'abc'#9'x'#9'rst';           Col:  5; TabSize: 6; res:  4),
     (S: 'abc'#9'x'#9'rst';           Col:  6; TabSize: 6; res:  4),
     (S: 'abc'#9'x'#9'rst';           Col:  7; TabSize: 6; res:  5),
     (S: 'abc'#9'x'#9'rst';           Col:  8; TabSize: 6; res:  6),
     (S: 'abc'#9'x'#9'rst';           Col:  9; TabSize: 6; res:  6),
     (S: 'abc'#9'x'#9'rst';           Col: 10; TabSize: 6; res:  6),
     (S: 'abc'#9'x'#9'rst';           Col: 11; TabSize: 6; res:  6),
     (S: 'abc'#9'x'#9'rst';           Col: 12; TabSize: 6; res:  6),
     (S: 'abc'#9'x'#9'rst';           Col: 13; TabSize: 6; res:  7),
     (S: 'abc'#9'x'#9'rst';           Col: 14; TabSize: 6; res:  8),
     (S: 'abc'#9'x'#9'rst';           Col: 15; TabSize: 6; res:  9));
var
  i, res: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    res := edGetActualCol(@cSomeData[i].S[1], cSomeData[i].Col, cSomeData[i].TabSize);
    CheckEquals(cSomeData[i].res, res, Format('edGetActualCol failed for test %d',[i]));
  end;
end;


procedure TestOvcEditUClass.TestedPadPrim;
type
  TData = record
    s: string;
    Len: Word;
    res: string;
  end;
const
  cSomeStrings: array[0..4] of TData =
    ((s: '';       Len:  0; res: ''),
     (s: '';       Len: 10; res: '          '),
     (s: 'abc';    Len:  6; res: 'abc   '),
     (s: '123456'; Len:  6; res: '123456'),
     (s: '123456'; Len:  3; res: '123456'));
var
  i,l: Integer;
  res: PChar;
  Dest: PChar;
begin
  for i := 0 to High(cSomeStrings) do begin
    l := Length(cSomeStrings[i].s);
    if cSomeStrings[i].Len>l then l := cSomeStrings[i].Len;
    Dest := AllocMem((l+2)*SizeOf(Char));
    try
      Dest[l+1] := 'z';
      StrPCopy(Dest,cSomeStrings[i].s);
      res := edPadPrim(Dest, cSomeStrings[i].Len);
      CheckEquals(cSomeStrings[i].res, res, Format('edPadChPrim failed for test %d',[i]));
      { verify that 'edPadChPrim' causes no buffer-overflow }
      CheckEquals(Dest[l+1], 'z', Format('edPadChPrim failed for test %d',[i]));
    finally
      FreeMem(Dest);
    end;
  end;
end;


procedure TestOvcEditUClass.TestedScanToEnd;
const
  cSomeStrings: array[0..4] of string =
    ('Orpheus',
     '123'#10'456',
     #10'abcdef',
     'xyzxyz'#10,
     '');
  cResults: array[0..4] of Word =
    (7,4,1,7,0);
var
  sString: string;
  iScan: Word;
  i: Integer;
begin
  for i := 0 to High(cSomeStrings) do begin
    sString := cSomeStrings[i];
    iScan := edScanToEnd(PChar(sString), Length(sString));
    CheckEquals(cResults[i], iScan, Format('edScanToEnd failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedHaveTabs;
const
  cSomeStrings: array[0..4] of string =
    ('',
     '123456',
     '1245'#9'abcdef',
     '12345678901234567890'#9,
     '1234567890'#9);
  cResults: array[0..4] of Boolean =
    (True, False, True, True, True);
var
  i: Integer;
  res: Boolean;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := edHaveTabs(@cSomeStrings[i][1],Length(cSomeStrings[i]));
    CheckEquals(cResults[i], res, Format('edHaveTabs failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TestOvcEditUClass.TestedStrStInsert;
type
  TData = record
    Dest: string;
    Pos: Word;
    Src: string;
    res: string;
  end;
const
  cSomeStrings: array[0..12] of TData =
    ((Dest: '1234567890'; Pos:  0; Src: 'abcde'; res: 'abcde1234567890'),
     (Dest: '1234567890'; Pos:  5; Src: 'abcde'; res: '12345abcde67890'),
     (Dest: '1234567890'; Pos: 10; Src: 'abcde'; res: '1234567890abcde'),
     (Dest: '1234567890'; Pos: 11; Src: 'abcde'; res: '1234567890'),
     (Dest: '';           Pos:  0; Src: 'abcde'; res: 'abcde'),
     (Dest: '';           Pos:  0; Src: '';      res: ''),
     (Dest: '';           Pos:  5; Src: 'abcde'; res: ''),
     (Dest: '1234567890'; Pos:  4; Src: '';      res: '1234567890'),
     (Dest: '1234567890'; Pos:  4; Src: 'a';     res: '1234a567890'),
     (Dest: '1234567890'; Pos:  4; Src: 'ab';    res: '1234ab567890'),
     (Dest: 'ГЖЙПФΣΔШд'; Pos:  4; Src: 'ÐàÿĘ';    res: 'ГЖЙПÐàÿĘФΣΔШд'),
     (Dest: 'ГЖЙПФΣΔШд'; Pos:  4; Src: 'Ð';       res: 'ГЖЙПÐФΣΔШд'),
     (Dest: 'ГЖЙПФΣΔШд'; Pos:  9; Src: 'Ðàÿ';     res: 'ГЖЙПФΣΔШдÐàÿ')
    );
var
  i, j: Integer;
  res: PChar;
  Dest: PChar;
  DLen, SLen: Word;
begin
  for i := 0 to High(cSomeStrings) do begin
    DLen := Length(cSomeStrings[i].Dest);
    SLen := Length(cSomeStrings[i].Src);
    Dest := AllocMem((DLen+SLen+2)*SizeOf(Char));
    try
      for j := 0 to DLen+SLen+1 do Dest[j] := 'z';
      StrPCopy(Dest,cSomeStrings[i].Dest);
      res := edStrStInsert(Dest,@cSomeStrings[i].Src[1],DLen,SLen,cSomeStrings[i].Pos);
      CheckEquals(cSomeStrings[i].res, res, Format('edStrStInsert failed for test %d',[i]));
      { verify that 'edStrStInsert' causes no buffer-overflow }
      CheckEquals(Dest[DLen+SLen+1], 'z', Format('edStrStInsert failed for test %d',[i]));
    finally
      FreeMem(Dest);
    end;
  end;
end;


procedure TestOvcEditUClass.TestedWhiteSpace;
const
  cSomeChars: array[0..3] of Char =
    ('a', ' ', #9, 'Ġ');
  cResults: array[0..3] of Boolean =
    (False, True, True, False);
var
  i: Integer;
  res: Boolean;
begin
  for i := 0 to High(cSomeChars) do begin
    res := edWhiteSpace(cSomeChars[i]);
    CheckEquals(cResults[i], res, Format('edWhiteSpace failed for "%s"',[cSomeChars[i]]));
  end;
end;



initialization
  RegisterTest(TestOvcEditUClass.Suite);
end.


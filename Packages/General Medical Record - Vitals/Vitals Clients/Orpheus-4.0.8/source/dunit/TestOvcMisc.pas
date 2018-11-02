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

unit TestOvcMisc;

interface

uses
  TestFramework;

type
  TTestOvcMisc = class(TTestCase)
  public
    procedure TestGetDisplayString;
  published
    procedure TestCompStruct;
    procedure TestFixRealPrim;
    procedure TestPartialCompare;
    procedure TestGetArrowWidth;
  end;

implementation

uses
  SysUtils, Graphics, Forms, OvcMisc;


{ TTestOvcMisc }

procedure TTestOvcMisc.TestCompStruct;
var
  b1, b2: Byte;
  w1, w2: Word;
  i1, i2: Integer;
  d1, d2: Double;
  e1, e2: Extended;
begin
  b1 := 0;
  b2 := 1;
  CheckEquals(-1, CompStruct(b1, b2, SizeOf(b1)), 'CompStruct failed for b1=0, b2=1');
  b1 := 127;
  b2 := 127;
  CheckEquals(0, CompStruct(b1, b2, SizeOf(b1)), 'CompStruct failed for b1=b2=127');
  b1 := 255;
  b2 := 240;
  CheckEquals(1, CompStruct(b1, b2, SizeOf(b1)), 'CompStruct failed for b1=255, b2=240');

  w1 := 0;
  w2 := 1;
  CheckEquals(-1, CompStruct(w1, w2, SizeOf(w1)), 'CompStruct failed for w1=0, w2=1');
  w1 := $7777;
  w2 := $7777;
  CheckEquals(0, CompStruct(w1, w2, SizeOf(w1)), 'CompStruct failed for w1=w2=$7777');
  w1 := $9000;
  w2 := $8000;
  CheckEquals(1, CompStruct(w1, w2, SizeOf(w1)), 'CompStruct failed for w1=$9000, w2=$8000');

  i1 := 0;
  i2 := 1;
  CheckEquals(-1, CompStruct(i1, i2, SizeOf(i1)), 'CompStruct failed for i1=0, i2=1');
  i1 := $7777777;
  i2 := $7777777;
  CheckEquals(0, CompStruct(i1, i2, SizeOf(i1)), 'CompStruct failed for i1=i2=$7777777');
  i1 := $20000000;
  i2 := $10000000;
  CheckEquals(1, CompStruct(i1, i2, SizeOf(i1)), 'CompStruct failed for i1=$20000000, i2=$10000000');

  d1 := 0;
  d2 := 1;
  CheckEquals(-1, CompStruct(d1, d2, SizeOf(d1)), 'CompStruct failed for d1=0, d2=1');
  d1 := Sqrt(2);
  d2 := Sqrt(2);
  CheckEquals(0, CompStruct(d1, d2, SizeOf(d1)), 'CompStruct failed for d1=d2=Sqrt(2)');
  d1 := 0.70000;
  d2 := 0.70001;
  CheckEquals(1, CompStruct(d1, d2, SizeOf(d1)), 'CompStruct failed for d1=0.7, d2=0.70001');

  e1 := 0;
  e2 := 1;
  CheckEquals(-1, CompStruct(e1, e2, SizeOf(e1)), 'CompStruct failed for e1=0, e2=1');
  e1 := Sqrt(2);
  e2 := Sqrt(2);
  CheckEquals(0, CompStruct(e1, e2, SizeOf(e1)), 'CompStruct failed for e1=e2=Sqrt(2)');
  e1 := 0.70001;
  e2 := 0.70000;
  { In Win64 we have Extended=Double so the expected result is different from Win32 }
  CheckEquals({$IFDEF WIN64}-1{$ELSE}1{$ENDIF},
              CompStruct(e1, e2, SizeOf(e1)), 'CompStruct failed for e1=0.70001, e2=0.7');
end;


procedure TTestOvcMisc.TestFixRealPrim;
  {-notes:
    04/2011 AB: The behaviour for ',123' appears to be a bug: '.1' and '0,1' are both changed
                to '0.1' but ',1' is not; however, the code of 'FixRealPrim' has not been
                changed (for now).
                The behaviour for numbers like '1E3' seems a little odd, too: I can't see the
                reason for adding five zero's - and there is no clue in the code.
                This is potentially dangerous as there are no tests to ensure the buffer
                'P' is large enough! }
const
  cSomeStrings : array[0..12] of string =
    (' 1,750',   '  12345  ', '12,',         '4.2', '10.',       ' ,123 ', '-,3',
     '123, 456', '123 ,456',  '123  ,  456', '',    '1E3',       '4,56E12');
  cResults : array[0..12] of string =
    ('1.750',    '12345',     '12',          '4.2', '10.0',      ',123',{'0.123',} '-0.3',
     '123.456',  '123.456',   '123.456',     '0',   '1.00000E3', '4.5600000E12');
var
  i: Integer;
  P: array[0..50] of Char;
begin
  for i := 0 to High(cSomeStrings) do begin
    StrPCopy(P, cSomeStrings[i]);
    FixRealPrim(P,',');
    CheckEquals(cResults[i], P, Format('FixRealPrim failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TTestOvcMisc.TestGetDisplayString;
type
  TData = record
    s: string;
    mi,ma: Integer;
    res: string;
  end;
const
  cSomeData: array[0..4] of TData =
    ((s:'1234567890'; mi: 10; ma:50; res:'1234567890'),
     (s:'1234567890'; mi: 5;  ma:50; res:'12345.'),
     (s:'1234567890'; mi: 0;  ma:50; res:'1234...'),
     (s:'ǄǇǌǄǇǌǄǇǌǄǇǌ'; mi: 0;  ma:50; res:'ǄǇ...'),
     (s:'';           mi: 0;  ma:50; res:''));
var
  i: Integer;
  Form: TForm;
  res: string;
begin
  Form := TForm.Create(nil);
  try
    Form.Canvas.Font.Name := 'Arial';
    Form.Canvas.Font.Size := 12;
    for i := 0 to High(cSomeData) do begin
      res := GetDisplayString(Form.Canvas, cSomeData[i].s, cSomeData[i].mi, cSomeData[i].ma);
      CheckEquals(cSomeData[i].res, res,
                  Format('GetDisplayString failed for "%s"',[cSomeData[i].s]));
    end;
  finally
    Form.Free;
  end;
end;


procedure TTestOvcMisc.TestPartialCompare;
type
  TData = record
    s1, s2: string;
    res: Boolean;
  end;
const
  cSomeData: array[0..12] of TData =
    ((s1:'';          s2:'';           res:False),
     (s1:'Delphi';    s2:'Delphi';     res:True),
     (s1:'Delphi';    s2:'delphi';     res:True),
     (s1:'Delphi';    s2:'Dolphi';     res:False),
     (s1:'Delphi XE'; s2:'Delphi';     res:True),
     (s1:'Orpheu';    s2:'Orpheus';    res:True),
     (s1:'orpheus';   s2:'';           res:False),
     (s1:'';          s2:'orpheus';    res:False),
     (s1:'Unicode';   s2:'UnicodeǄǇǌ'; res:True),
     (s1:'╒═╕';       s2:'╒╒═╕═╕';     res:False),
     (s1:'╒═╕';       s2:'╒═╕═╕';      res:True),
     (s1:'ΑΒΓΔ';      s2:'αβγδ';       res:True),
     (s1:'Delphi XE'; s2:'DelphiXE';   res:False));
var
  i: Integer;
  res: Boolean;
begin
  for i := 0 to High(cSomeData) do begin
    res := PartialCompare(cSomeData[i].s1, cSomeData[i].s2);
    CheckEquals(cSomeData[i].res, res,
                Format('PartialCompare failed for "%s" <-> "%s"',
                       [cSomeData[i].s1,cSomeData[i].s2]));
  end;
end;


procedure TTestOvcMisc.TestGetArrowWidth;
type
  TData = record
    w,h, res: Integer;
  end;
const
  cSomeData: array[0..3] of TData =
    ((w: 10; h: 20; res: 5),
     (w: 20; h: 10; res: 5),
     (w: 12; h: 13; res: 7),
     (w: 13; h: 12; res: 7));
var
  i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    CheckEquals(cSomeData[i].res, GetArrowWidth(cSomeData[i].w,cSomeData[i].h),
                Format('GetArrowWidth failed for test #%d',[i]));
  end;
end;


initialization
  RegisterTest(TTestOvcMisc.Suite);

end.


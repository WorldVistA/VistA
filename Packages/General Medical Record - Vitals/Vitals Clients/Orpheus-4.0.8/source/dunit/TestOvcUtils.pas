unit TestOvcUtils;

interface

uses
  TestFramework;

type
  TTestOvcUtils = class(TTestCase)
  published
    procedure TestStripCharSeq;
    procedure TestStripCharFromEnd;
    procedure TestStripCharFromFront;
  end;

implementation

uses
  SysUtils, OvcUtils;

{ TTestOvcUtils }

procedure TTestOvcUtils.TestStripCharSeq;
const
  cSomeStrings : array[0..5] of string =
    ('abc', 'xxfoofoox   ', 'foo   xxx', '  yy  foo', 'foofoo', ' ffoooo  ');
  cResults : array[0..5] of string =
    ('abc', 'xxx   ', '   xxx', '  yy  ', '', '   ');
var
  i: Integer;
  Str: string;
begin
  for i := 0 to High(cSomeStrings) do begin
    Str := cSomeStrings[i];
    StripCharSeq('foo', Str);
    CheckEqualsString(cResults[i], Str,
      Format('StripCharSeq failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TTestOvcUtils.TestStripCharFromEnd;
const
  cSomeStrings : array[0..5] of string =
    ('abc', 'xxx   ', '   xxx', '  yy  ', '', '   ');
  cResults : array[0..5] of string =
    ('abc', 'xxx', '   xxx', '  yy', '', '');
var
  i: Integer;
  Str: string;
begin
  for i := 0 to High(cSomeStrings) do begin
    Str := cSomeStrings[i];
    StripCharFromEnd(' ', Str);
    CheckEqualsString(cResults[i], Str,
      Format('StripCharFromEnd failed for "%s"',[cSomeStrings[i]]));
  end;
end;


procedure TTestOvcUtils.TestStripCharFromFront;
const
  cSomeStrings : array[0..5] of string =
    ('abc', 'xxx   ', '   xxx', '  yy  ', '', '   ');
  cResults : array[0..5] of string =
    ('abc', 'xxx   ', 'xxx', 'yy  ', '', '');
var
  i: Integer;
  Str: string;
begin
  for i := 0 to High(cSomeStrings) do begin
    Str := cSomeStrings[i];
    StripCharFromFront(' ', Str);
    CheckEqualsString(cResults[i], Str,
      Format('StripCharFromFront failed for "%s"',[cSomeStrings[i]]));
  end;
end;

initialization
  RegisterTest(TTestOvcUtils.Suite);

end.

unit CPRSLibTestCases;

interface
uses
  TestFramework, ORFn, SysUtils, Classes, Types;

type
  TORFnTestCase = class(TTestCase)
  published
    // Test Date/Time functions
    procedure TestDateTimeToFMDateTime;
    procedure TestFMDateTimeOffsetBy;
    procedure TestFMDateTimeToDateTime;
    procedure TestFormatFMDateTime;
    procedure TestFormatFMDateTimeStr;
    procedure TestIsFMDateTime;
    procedure TestMakeFMDateTime;
    procedure TestSetListFMDateTime;
    // Test Numeric functions
    procedure TestHigherOf;
    procedure TestLowerOf;
    procedure TestRectContains;
    procedure TestStrToFloatDef;
  end;

implementation

{ TORFnTestCase }

// ** Test Date/Time Functions **

procedure TORFnTestCase.TestDateTimeToFMDateTime;
var
  TestDT: TDateTime;
begin
  // use 07/20/1969@20:17:39 - Date/Time (UTC) of Apollo 11 Lunar landing
  TestDT := EncodeDate(1969, 7, 20) + EncodeTime(20, 17, 39, 0);
  Check(FloatToStr(DateTimeToFMDateTime(TestDT)) = '2690720.201739', 'DateTimeToFMDateTime Failed!');
end;

procedure TORFnTestCase.TestFMDateTimeOffsetBy;
var
  TestFMDT: TFMDateTime;
begin
  TestFMDT := StrToFloat('2690725.201739');
  Check(FMDateTimeOffsetBy(StrToFloat('2690720.201739'), 5) = TestFMDT, 'FMDateTimeOffsetBy Failed!');
  TestFMDT := StrToFloat('2690629.201739');
  Check(FMDateTimeOffsetBy(StrToFloat('2690720.201739'), -21) = TestFMDT, 'FMDateTimeOffsetBy (Negative Offset) Failed!');
end;

procedure TORFnTestCase.TestFMDateTimeToDateTime;
var
  TestDT: TDateTime;
begin
  TestDT := EncodeDate(1969, 7, 20) + EncodeTime(20, 17, 39, 0);
  Check(TestDT = FMDateTimeToDateTime(StrToFloat('2690720.201739')), 'FMDateTimeToDateTime Failed!');
end;

procedure TORFnTestCase.TestFormatFMDateTime;
var
  TestFMDT: TFMDateTime;
  ExpectedDTString, ActualDTString: String;
begin
  TestFMDT := StrToFloat('2690720.201739');
  ExpectedDTString := '07/20/1969@20:17:39';
  ActualDTString := FormatFMDateTime('mm/dd/yyyy@hh:nn:ss', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTime Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := '19690720.201739';
  ActualDTString := FormatFMDateTime('yyyymmdd.hhnnss', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTime Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := '20 Jul 69 20:17';
  ActualDTString := FormatFMDateTime('dd mmm yy hh:nn', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTime Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := 'July 20, 1969 20:17';
  ActualDTString := FormatFMDateTime('mmmm dd, yyyy hh:nn', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTime Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
end;

procedure TORFnTestCase.TestFormatFMDateTimeStr;
var
  TestFMDT: String;
  ExpectedDTString, ActualDTString: String;
begin
  TestFMDT := '2690720.201739';
  ExpectedDTString := '07/20/1969@20:17:39';
  ActualDTString := FormatFMDateTimeStr('mm/dd/yyyy@hh:nn:ss', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTimeStr Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := '19690720.201739';
  ActualDTString := FormatFMDateTimeStr('yyyymmdd.hhnnss', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTime Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := '20 Jul 69 20:17';
  ActualDTString := FormatFMDateTimeStr('dd mmm yy hh:nn', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTimeStr Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
  ExpectedDTString := 'July 20, 1969 20:17';
  ActualDTString := FormatFMDateTimeStr('mmmm dd, yyyy hh:nn', TestFMDT);
  Check(ExpectedDTString = ActualDTString, 'FormatFMDateTimeStr Failed! Expected: ' + ExpectedDTString + ' Actual: ' + ActualDTString);
end;

procedure TORFnTestCase.TestHigherOf;
begin
  Check(HigherOf(1024, 2048) = 2048, 'HigherOf(1024, 2048) failed.');
  CheckFalse(HigherOf(1024, 2048) = 1024, 'HigherOf(1024, 2048) failed.');
end;

procedure TORFnTestCase.TestIsFMDateTime;
var
  TestFMDT: String;
begin
  // Test Case where isFMDateTime returns True
  TestFMDT := '2690720.201739';
  Check(IsFMDateTime(TestFMDT) = True, 'isFMDateTime failed for ' + TestFMDT);
  // Test Case where isFMDateTime returns False
  TestFMDT := '19690720.201739';
  Check(IsFMDateTime(TestFMDT) = False, 'isFMDateTime failed for ' + TestFMDT);
end;

procedure TORFnTestCase.TestLowerOf;
begin
  Check(LowerOf(1024, 2048) = 1024, 'LowerOf(1024, 2048) failed.');
  CheckFalse(LowerOf(1024, 2048) = 2048, 'LowerOf(1024, 2048) failed.');
end;

procedure TORFnTestCase.TestMakeFMDateTime;
var
  TestFMDT: String;
  MadeFMDT: Extended;
begin
  TestFMDT := '2690720.201739';
  MadeFMDT := MakeFMDateTime(TestFMDT);
  Check(TestFMDT = FloatToStr(MadeFMDT), 'MakeFMDateTime Failed. Expected: ' + TestFMDT + ' Actual: ' + FloatToStr(MadeFMDT));
  TestFMDT := '19690720.201739';
  MadeFMDT := MakeFMDateTime(TestFMDT);
  Check(-1 = MadeFMDT, 'MakeFMDateTime Failed. Expected: -1 Actual: ' + FloatToStr(MadeFMDT));
end;

procedure TORFnTestCase.TestRectContains;
var
  ARect: TRect;
  APoint: TPoint;
begin
  ARect := Rect(0, 0, 100, 100);
  APoint := Point(50, 50);
  Check(RectContains(ARect, APoint) = True, 'RectContains([0, 0, 100, 100], [50, 50]) Failed!');
  APoint := Point(50, 101);
  Check(RectContains(ARect, APoint) = False, 'RectContains([0, 0, 100, 100], [50, 101]) Failed!');
end;

procedure TORFnTestCase.TestSetListFMDateTime;
var
  AList: TStringList;
begin
  //Load AList with strings analogous to RPC Results
  AList := TStringList.Create;
  try
    AList.Add('917^3101012.142241^p^ANTICOAG^Consult^^ANTICOAG Cons^14520207^C');
    AList.Add('903^3100813.144108^a^NUTRITION ASSESSMENT^Consult^^NUTRITION ASSESSMENT Cons^14519894^C');
    AList.Add('902^20100713.124501^c^NUTRITION ASSESSMENT^Consult^*^NUTRITION ASSESSMENT Cons^14519811^C');
    AList.Add('899^3100707.093843^p^CARDIOLOGY^Consult^^CARDIOLOGY Cons^14519751^C');
    AList.Add('900^31007^p^CARDIOLOGY^Consult^^CARDIOLOGY Cons^14519752^C');
    SetListFMDateTime('mm/dd/yyyy@hh:nn:ss', AList, '^', 2);
    Check(Piece(AList[0], '^', 2) = '10/12/2010@14:22:41', 'SetListFMDateTime failed: ' + Piece(AList[0], '^', 2));
    Check(Piece(AList[1], '^', 2) = '08/13/2010@14:41:08', 'SetListFMDateTime failed: ' + Piece(AList[1], '^', 2));
    Check(Piece(AList[2], '^', 2) = '', 'HL7 Date/Time caused: ' + Piece(AList[2], '^', 2));
    Check(Piece(AList[3], '^', 2) = '07/07/2010@09:38:43', 'SetListFMDateTime failed: ' + Piece(AList[3], '^', 2));
    Check(Piece(AList[4], '^', 2) = '', 'Imprecise Date/Time caused: ' + Piece(AList[4], '^', 2));
    AList.Clear;
    AList.Add('917^3101012.142241^p^ANTICOAG^Consult^^ANTICOAG Cons^14520207^C');
    AList.Add('903^3100813.144108^a^NUTRITION ASSESSMENT^Consult^^NUTRITION ASSESSMENT Cons^14519894^C');
    AList.Add('902^20100713.124501^c^NUTRITION ASSESSMENT^Consult^*^NUTRITION ASSESSMENT Cons^14519811^C');
    AList.Add('899^3100707.093843^p^CARDIOLOGY^Consult^^CARDIOLOGY Cons^14519751^C');
    AList.Add('900^31007^p^CARDIOLOGY^Consult^^CARDIOLOGY Cons^14519752^C');
    SetListFMDateTime('mm/dd/yyyy@hh:nn:ss', AList, '^', 2, True);
    Check(Piece(AList[0], '^', 2) = '10/12/2010@14:22:41', 'SetListFMDateTime failed: ' + Piece(AList[0], '^', 2));
    Check(Piece(AList[1], '^', 2) = '08/13/2010@14:41:08', 'SetListFMDateTime failed: ' + Piece(AList[1], '^', 2));
    Check(Piece(AList[2], '^', 2) = '20100713.124501', 'HL7 Date/Time caused: ' + Piece(AList[2], '^', 2));
    Check(Piece(AList[3], '^', 2) = '07/07/2010@09:38:43', 'SetListFMDateTime failed: ' + Piece(AList[3], '^', 2));
    Check(Piece(AList[4], '^', 2) = '31007', 'Imprecise Date/Time caused: ' + Piece(AList[4], '^', 2));
  finally
    AList.Free;
  end;
end;

procedure TORFnTestCase.TestStrToFloatDef;
begin
  Check(StrToFloatDef('3.1416', Pi) = 3.1416, 'StrToFloatDef Failed!');
  Check(StrToFloatDef('0031416', Pi) = 31416, 'StrToFloatDef Failed!');
  Check(StrToFloatDef('NotANumber', Pi) = Pi, 'StrToFloatDef Failed!');
end;

initialization
  TestFramework.RegisterTest(TORFnTestCase.Suite);

end.

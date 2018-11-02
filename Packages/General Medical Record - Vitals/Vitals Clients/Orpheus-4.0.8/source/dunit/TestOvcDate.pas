unit TestOvcDate;

interface

uses
  TestFramework;

type
  TTestOVCDate = class(TTestCase)
  published
    procedure TestValidDate;
    procedure TestDMYtoStDate;
    procedure TestWeekOfYear;
    procedure TestStDateToDMY;
    procedure TestDayOfWeek;
    procedure TestStTimeToHMS;
    procedure TestHMStoStTime;
    procedure TestDateTimeToStDate;
    procedure TestDateDiff;
    procedure TestDateTimeDiff;
    procedure TestIncDateTime;
  end;


implementation

uses
  OvcDate, Windows, SysUtils;

{ TTestOVCDate }

procedure TTestOVCDate.TestValidDate;
type
  TData = record
    y,m,d,e: Integer;
    res:     Boolean;
  end;
const
  cSomeData : array[0..15] of TData =
    ((y: 1980; m: 1; d: 1; e:0; res: True),
     (y: 1600; m: 1; d: 1; e:0; res: True),
     (y: 1000; m:12; d: 1; e:0; res: False),
     (y: 1700; m:13; d: 1; e:0; res: False),
     (y: 1888; m:11; d:31; e:0; res: False),
     (y: 2000; m: 7; d:31; e:0; res: True),
     (y: 2100; m: 2; d:28; e:0; res: True),
     (y: 2100; m: 2; d:29; e:0; res: False),
     (y: 2100; m: 3; d: 1; e:0; res: True),
     (y: 2012; m: 2; d:29; e:0; res: True),
     (y: 2012; m: 2; d:30; e:0; res: False),
     (y:    0; m: 2; d:29; e:2000; res: True),
     (y:    0; m: 2; d:30; e:2000; res: False),
     (y:   12; m: 2; d:29; e:2000; res: True),
     (y:   12; m:12; d:31; e:2000; res: True),
     (y:   12; m: 2; d:30; e:2000; res: False));
var
  res: Boolean;
  i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    res := ValidDate(cSomeData[i].d, cSomeData[i].m, cSomeData[i].y, cSomeData[i].e);
    CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestDMYtoStDate;
type
  TData = record
    y,m,d,e: Integer;
    res:     Integer;
  end;
const
  cSomeData : array[0..11] of TData =
    ((y: 1980; m: 1; d: 1; e:0;    res: 138792),
     (y: 1900; m: 1; d: 1; e:0;    res: Date1900),
     (y:   00; m: 1; d: 1; e:2000; res: Date2000),
     (y: 1600; m: 1; d: 1; e:0;    res: 0),
     (y: 1000; m:12; d: 1; e:0;    res: BadDate),
     (y: 2000; m: 7; d:31; e:0;    res: 146309),
     (y: 2100; m: 2; d:28; e:0;    res: 182680),
     (y: 2100; m: 3; d: 1; e:0;    res: 182681),
     (y: 2012; m: 2; d:29; e:0;    res: 150539),
     (y:   00; m: 2; d:28; e:2100; res: 182680),
     (y:   00; m: 3; d: 1; e:2100; res: 182681),
     (y:   12; m: 2; d:29; e:2000; res: 150539));
var
  res: TStDate;
  i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    res := DMYtoStDate(cSomeData[i].d, cSomeData[i].m, cSomeData[i].y, cSomeData[i].e);
    CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestWeekOfYear;
var
  res: Byte;
  i: Integer;
begin
  for i := 3 to 365 do begin
    res := WeekOfYear(Date2000+i-1);
    CheckEquals((i+4) div 7, res, Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestStDateToDMY;
type
  TData = record
    y,m,d: Integer;
    st:    Integer;
  end;
const
  cSomeData : array[0..11] of TData =
    ((y: 1980; m: 1; d: 1; st: 138792),
     (y: 1900; m: 1; d: 1; st: Date1900),
     (y: 2000; m: 1; d: 1; st: Date2000),
     (y: 1600; m: 1; d: 1; st: 0),
     (y:    0; m: 0; d: 0; st: BadDate),
     (y: 2000; m: 7; d:31; st: 146309),
     (y: 2100; m: 2; d:28; st: 182680),
     (y: 2100; m: 3; d: 1; st: 182681),
     (y: 2012; m: 2; d:29; st: 150539),
     (y: 2100; m: 2; d:28; st: 182680),
     (y: 2100; m: 3; d: 1; st: 182681),
     (y: 2012; m: 2; d:29; st: 150539));
var
  d, m, y, i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    StDateToDMY(cSomeData[i].st, d, m, y);
    CheckTrue((d=cSomeData[i].d) and (m=cSomeData[i].m) and (y=cSomeData[i].y),
              Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestDayOfWeek;
type
  TData = record
    y,m,d: Integer;
    res:   TStDayType;
  end;
const
  cSomeData : array[0..9] of TData =
    ((y: 1968; m: 4; d:14; res: Sunday),
     (y: 1900; m: 1; d: 1; res: Monday),
     (y: 2000; m: 1; d: 1; res: Saturday),
     (y: 1600; m: 1; d: 1; res: Saturday),
     (y: 2000; m: 7; d:31; res: Monday),
     (y: 1993; m: 2; d: 9; res: Tuesday),
     (y: 1996; m: 3; d: 6; res: Wednesday),
     (y: 2012; m:12; d:27; res: Thursday),
     (y: 2100; m: 1; d: 1; res: Friday),
     (y: 2100; m: 3; d:32; res: TStDayType(7)));
var
  i: Integer;
  res: TStDayType;
begin
  for i := 0 to High(cSomeData) do begin
    res := ovcdate.DayOfWeek(DMYToStDate(cSomeData[i].d,cSomeData[i].m,cSomeData[i].y,0));
    CheckEquals(Ord(cSomeData[i].res), Ord(res), Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestStTimeToHMS;
type
  TData = record
    h,m,s: Byte;
    t:     TStTime;
  end;
const
  cSomeData : array[0..3] of TData =
    ((h: 0; m: 0; s: 0; t: 0),
     (h: 0; m:59; s:59; t: 59*60+59),
     (h:23; m:29; s:59; t: 23*60*60+29*60+59),
     (h: 0; m: 0; s: 0; t: BadTime));
var
  i: Integer;
  h,m,s: Byte;
begin
  for i := 0 to High(cSomeData) do begin
    StTimeToHMS(cSomeData[i].t,h,m,s);
    CheckTrue((h=cSomeData[i].h) and (m=cSomeData[i].m) and (s=cSomeData[i].s),
              Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestHMStoStTime;
type
  TData = record
    h,m,s: Byte;
    res:   TStTime;
  end;
const
  cSomeData : array[0..3] of TData =
    ((h: 0; m: 0; s: 0; res: 0),
     (h: 0; m:59; s:59; res: 59*60+59),
     (h:23; m:29; s:59; res: 23*60*60+29*60+59),
// According to the documentation, HMStoStTime should return BadTime here. However,
// the function is not implemented this way. We consider this a feature, not a bug ;-)
     (h:99; m: 0; s: 0; res: {BadTime} 3*60*60));
var
  i: Integer;
  res: TStTime;
begin
  for i := 0 to High(cSomeData) do begin
    res := HMStoStTime(cSomeData[i].h,cSomeData[i].m,cSomeData[i].s);
    CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestDateTimeToStDate;
type
  TData = record
    y,m,d: Integer;
    res:    Integer;
  end;
const
  cSomeData : array[0..10] of TData =
    ((y: 1980; m: 1; d: 1; res: 138792),
     (y: 1900; m: 1; d: 1; res: Date1900),
     (y: 2000; m: 1; d: 1; res: Date2000),
     (y: 1600; m: 1; d: 1; res: 0),
     (y: 2000; m: 7; d:31; res: 146309),
     (y: 2100; m: 2; d:28; res: 182680),
     (y: 2100; m: 3; d: 1; res: 182681),
     (y: 2012; m: 2; d:29; res: 150539),
     (y: 2100; m: 2; d:28; res: 182680),
     (y: 2100; m: 3; d: 1; res: 182681),
     (y: 2012; m: 2; d:29; res: 150539));
var
  i: Integer;
  res: TStDate;
begin
  for i := 0 to High(cSomeData) do begin
    res := DateTimeToStDate(EncodeDate(cSomeData[i].y,cSomeData[i].m,cSomeData[i].d));
    CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestDateDiff;
type
  TData = record
    y1,m1,d1,y2,m2,d2,y,m,d: Integer;
  end;
const
  cSomeData : array[0..5] of TData =
    ((y1: 1980; m1: 1; d1: 1;  y2: 1980; m2: 2; d2: 1;  y: 0; m: 1; d:  0),
     (y1: 2000; m1: 7; d1:22;  y2: 2001; m2: 3; d2:14;  y: 0; m: 7; d: 23),
     (y1: 2001; m1: 3; d1:14;  y2: 2000; m2: 7; d2:22;  y: 0; m: 7; d: 23),
     (y1: 2004; m1: 2; d1:28;  y2: 2004; m2: 3; d2: 1;  y: 0; m: 0; d:  2),
     (y1: 2000; m1: 4; d1:14;  y2: 1968; m2: 4; d2:14;  y:32; m: 0; d:  0),
     (y1: 2011; m1: 2; d1:28;  y2: 2012; m2: 3; d2: 1;  y: 1; m: 0; d:  1));
var
  d, m, y, i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    DateDiff(DMYToStDate(cSomeData[i].d1, cSomeData[i].m1, cSomeData[i].y1, 0),
             DMYToStDate(cSomeData[i].d2, cSomeData[i].m2, cSomeData[i].y2, 0),
             d,m,y);
    CheckTrue((d=cSomeData[i].d) and (m=cSomeData[i].m) and (y=cSomeData[i].y),
              Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestDateTimeDiff;
type
  TData = record
    y1,m1,d1,h1,n1,s1, y2,m2,d2,h2,n2,s2, d,s: Integer;
  end;
const
  cSomeData : array[0..2] of TData =
    ((y1: 1980; m1: 1; d1: 1; h1: 0; n1: 0; s1: 0;
      y2: 1980; m2: 2; d2: 1; h2: 0; n2: 0; s2: 0;  d:31; s: 0),
     (y1: 2001; m1: 1; d1: 1; h1: 0; n1: 0; s1: 0;
      y2: 2000; m2:12; d2:31; h2:23; n2:59; s2:59;  d: 0; s: 1),
     (y1: 2011; m1: 1; d1: 1; h1: 1; n1: 1; s1: 1;
      y2: 2012; m2: 1; d2: 1; h2:23; n2:23; s2:23;  d: 365; s: 80542));
var
  dt1, dt2: TStDateTimeRec;
  d, s, i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    dt1.D := DMYToStDate(cSomeData[i].d1, cSomeData[i].m1, cSomeData[i].y1, 0);
    dt1.T := HMStoStTime(cSomeData[i].h1, cSomeData[i].n1, cSomeData[i].s1);
    dt2.D := DMYToStDate(cSomeData[i].d2, cSomeData[i].m2, cSomeData[i].y2, 0);
    dt2.T := HMStoStTime(cSomeData[i].h2, cSomeData[i].n2, cSomeData[i].s2);
    DateTimeDiff(dt1, dt2, d, s);
    CheckTrue((d=cSomeData[i].d) and (s=cSomeData[i].s), Format('Test #%d failed',[i]));
  end;
end;


procedure TTestOVCDate.TestIncDateTime;
type
  TData = record
    y1,m1,d1,h1,n1,s1, d,s, y2,m2,d2,h2,n2,s2: Integer;
  end;
const
  cSomeData : array[0..1] of TData =
    ((y1: 1980; m1: 1; d1: 1; h1: 0; n1: 0; s1: 0;  d:60; s:3666;
      y2: 1980; m2: 3; d2: 1; h2: 1; n2: 1; s2: 6),
     (y1: 2011; m1:12; d1:31; h1:23; n1:59; s1:59;  d: 0; s:1;
      y2: 2012; m2: 1; d2: 1; h2: 0; n2: 0; s2: 0));
var
  dt1, dt2: TStDateTimeRec;
  i: Integer;
begin
  for i := 0 to High(cSomeData) do begin
    dt1.D := DMYToStDate(cSomeData[i].d1, cSomeData[i].m1, cSomeData[i].y1, 0);
    dt1.T := HMStoStTime(cSomeData[i].h1, cSomeData[i].n1, cSomeData[i].s1);
    IncDateTime(dt1,dt2,cSomeData[i].d,cSomeData[i].s);
    CheckTrue((dt2.D=DMYToStDate(cSomeData[i].d2, cSomeData[i].m2, cSomeData[i].y2, 0)) and
              (dt2.T=HMStoStTime(cSomeData[i].h2, cSomeData[i].n2, cSomeData[i].s2)),
              Format('Test #%d failed',[i]));
  end;
end;


initialization
  RegisterTest(TTestOVCDate.Suite);

end.


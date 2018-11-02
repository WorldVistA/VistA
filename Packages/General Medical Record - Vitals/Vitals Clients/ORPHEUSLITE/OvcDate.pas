{*********************************************************}
{*                   OVCDATE.PAS 4.06                    *}
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

{$IFDEF VERSION7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

{For BCB 3.0 package support.}
{$IFDEF VER110}
  {$ObjExportAll On}
{$ENDIF}


{---Global compiler defines for Delphi 2.0---}
{$A+} {Word Align Data}
{$H+} {Huge string support}
{$Q-} {Overflow check}
{$R-} {Range check}
{$S-} {Stack check}
{$T-} {Typed @ check}
{$V-} {Var strings}

unit ovcdate; {formerly StDate}
  {-Date and time manipulation}

interface

uses
  Windows, SysUtils;

type
  TStDate = LongInt;
    {In STDATE, dates are stored in long integer format as the number of days
    since January 1, 1600}

  TDateArray = array[0..(MaxLongInt div SizeOf(TStDate))-1] of TStDate;
    {Type for StDate open array}

  TStDayType = (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday);
    {An enumerated type used when representing a day of the week}

  TStBondDateType = (bdtActual, bdt30E360, bdt30360, bdt30360psa);
    {An enumerated type used for calculating bond date differences}

  TStTime = LongInt;
    {STDATE handles time in a manner similar to dates, representing a given
    time of day as the number of seconds since midnight}

  TStDateTimeRec =
    record
     {This record type simply combines the two basic date types defined by
      STDATE, Date and Time}
      D : TStDate;
      T : TStTime;
    end;

const
  MinYear = 1600;        {Minimum valid year for a date variable}
  MaxYear = 3999;        {Maximum valid year for a date variable}
  Mindate = $00000000;   {Minimum valid date for a date variable - 01/01/1600}
  Maxdate = $000D6025;   {Maximum valid date for a date variable - 12/31/3999}
  Date1900 = $0001AC05;  {This constant contains the Julian date for 01/01/1900}
  Date1980 = $00021E28;  {This constant contains the Julian date for 01/01/1980}
  Date2000 = $00023AB1;  {This constant contains the Julian date for 01/01/2000}
  {This value is used to represent an invalid date, such as 12/32/1992}
  BadDate = LongInt($FFFFFFFF);

  DeltaJD     = $00232DA8;   {Days between 1/1/-4173 and 1/1/1600}

  MinTime = 0;          {Minimum valid time for a time variable - 00:00:00 am}
  MaxTime = 86399;      {Maximum valid time for a time variable - 23:59:59 pm}
  {This value is used to represent an invalid time of day, such as 12:61:00}
  BadTime = LongInt($FFFFFFFF);

  SecondsInDay = 86400;      {Number of seconds in a day}
  SecondsInHour = 3600;      {Number of seconds in an hour}
  SecondsInMinute = 60;      {Number of seconds in a minute}
  HoursInDay = 24;           {Number of hours in a day}
  MinutesInHour = 60;        {Number of minutes in an hour}
  MinutesInDay = 1440;       {Number of minutes in a day}

var
  DefaultYear : Integer;     {default year--used by DateStringToDMY}
  DefaultMonth : ShortInt;   {default month}

  {-------julian date routines---------------}

function CurrentDate : TStDate;
  {-returns today's date as a Julian date}

function ValidDate(Day, Month, Year, Epoch : Integer) : Boolean;
  {-Verify that day, month, year is a valid date}

function DMYtoStDate(Day, Month, Year, Epoch : Integer) : TStDate;
  {-Convert from day, month, year to a Julian date}

procedure StDateToDMY(Julian : TStDate; var Day, Month, Year : Integer);
  {-Convert from a Julian date to day, month, year}

function IncDate(Julian : TStDate; Days, Months, Years : Integer) : TStDate;
  {-Add (or subtract) the number of days, months, and years to a date}

function IncDateTrunc(Julian : TStDate; Months, Years : Integer) : TStDate;
  {-Add (or subtract) the specified number of months and years to a date}

procedure DateDiff(Date1, Date2 : TStDate;
                   var Days, Months, Years : Integer);
{-Return the difference in days, months, and years between two valid Julian
  dates}

function BondDateDiff(Date1, Date2 : TStDate; DayBasis : TStBondDateType) : TStDate;
  {-Return the difference in days between two valid Julian
  dates using a specific financial basis}

function WeekOfYear(Julian : TStDate) : Byte;
  {-Returns the week number of the year given the Julian Date}

function AstJulianDate(Julian : TStDate) : Double;
  {-Returns the Astronomical Julian Date from a TStDate}

function AstJulianDatetoStDate(AstJulian : Double; Truncate : Boolean) : TStDate;
  {-Returns a TStDate from an Astronomical Julian Date.
  Truncate TRUE   Converts to appropriate 0 hours then truncates
           FALSE  Converts to appropriate 0 hours, then rounds to
                  nearest;}

function AstJulianDatePrim(Year, Month, Date : Integer; UT : TStTime) : Double;
  {-Returns an Astronomical Julian Date for any year, even those outside
    MinYear..MaxYear}

function DayOfWeek(Julian : TStDate) : TStDayType;
  {-Return the day of the week for a Julian date}

function DayOfWeekDMY(Day, Month, Year, Epoch : Integer) : TStDayType;
  {-Return the day of the week for the day, month, year}

function IsLeapYear(Year : Integer) : Boolean;
  {-Return True if Year is a leap year}

function DaysInMonth(Month : Integer; Year, Epoch : Integer) : Integer;
  {-Return the number of days in the specified month of a given year}

function ResolveEpoch(Year, Epoch : Integer) : Integer;
  {-Convert 2 digit year to 4 digit year according to Epoch}


  {-------time routines---------------}

function ValidTime(Hours, Minutes, Seconds : Integer) : Boolean;
  {-Return True if Hours:Minutes:Seconds is a valid time}

procedure StTimeToHMS(T : TStTime;
                    var Hours, Minutes, Seconds : Byte);
  {-Convert a time variable to hours, minutes, seconds}

function HMStoStTime(Hours, Minutes, Seconds : Byte) : TStTime;
  {-Convert hours, minutes, seconds to a time variable}

function CurrentTime : TStTime;
  {-Return the current time in seconds since midnight}

procedure TimeDiff(Time1, Time2 : TStTime;
                   var Hours, Minutes, Seconds : Byte);
  {-Return the difference in hours, minutes, and seconds between two times}

function IncTime(T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime;
  {-Add the specified hours, minutes, and seconds to a given time of day}

function DecTime(T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime;
  {-Subtract the specified hours, minutes, and seconds from a given time of day}

function RoundToNearestHour(T : TStTime; Truncate : Boolean) : TStTime;
  {-Given a time, round it to the nearest hour, or truncate minutes and
  seconds}

function RoundToNearestMinute(const T : TStTime; Truncate : Boolean) : TStTime;
  {-Given a time, round it to the nearest minute, or truncate seconds}

  {-------- routines for DateTimeRec records ---------}

procedure DateTimeDiff(DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec;
                       var Days : LongInt; var Secs : LongInt);
  {-Return the difference in days and seconds between two points in time}

procedure IncDateTime(DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec;
                      Days : Integer; Secs : LongInt);
  {-Increment (or decrement) a date and time by the specified number of days
  and seconds}

function DateTimeToStDate(DT : TDateTime) : TStDate;
  {-Convert Delphi TDateTime to TStDate}

function DateTimeToStTime(DT : TDateTime) : TStTime;
  {-Convert Delphi TDateTime to TStTime}

function StDateToDateTime(D : TStDate) : TDateTime;
  {-Convert TStDate to TDateTime}

function StTimeToDateTime(T : TStTime) : TDateTime;
  {-Convert TStTime to TDateTime}

function Convert2ByteDate(TwoByteDate : Word) : TStDate;
  {-Convert an Object Professional two byte date into a SysTools date}

function Convert4ByteDate(FourByteDate : TStDate) : Word;
  {-Convert a SysTools date into an Object Professional two byte date}


implementation

const
  First2Months = 59;           {1600 was a leap year}
  FirstDayOfWeek = Saturday;   {01/01/1600 was a Saturday}
  DateLen = 40;                {maximum length of Picture strings}
  MaxMonthName = 15;
  MaxDayName   = 15;


type
{  DateString = string[DateLen];}
  SString = string[255];

function IsLeapYear(Year : Integer) : Boolean;
  {-Return True if Year is a leap year}
begin
  Result := (Year mod 4 = 0) and (Year mod 4000 <> 0) and
    ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function IsLastDayofMonth(Day, Month, Year : Integer) : Boolean;
  {-Return True if date is the last day in month}
var
  Epoch : Integer;
begin
  Epoch := (Year div 100) * 100;
  if ValidDate(Day + 1, Month, Year, Epoch) then
    Result := false
  else
    Result := true;
end;

function IsLastDayofFeb(Date : TStDate) : Boolean;
  {-Return True if date is the last day in February}
var
  Day, Month, Year : Integer;
begin
  StDateToDMY(Date, Day, Month, Year);
  if (Month = 2) and IsLastDayOfMonth(Day, Month, Year) then
    Result := true
  else
    Result := false;
end;



procedure ExchangeLongInts(var I, J : LongInt);
register;
asm
  mov  ecx, [eax]
  push ecx
  mov  ecx, [edx]
  mov  [eax], ecx
  pop  ecx
  mov  [edx], ecx
end;

procedure ExchangeStructs(var I, J; Size : Cardinal);
register;
asm
  push edi
  push ebx
  push ecx
  shr  ecx, 2
  jz   @@LessThanFour

@@AgainDWords:
  mov  ebx, [eax]
  mov  edi, [edx]
  mov  [edx], ebx
  mov  [eax], edi
  add  eax, 4
  add  edx, 4
  dec  ecx
  jnz  @@AgainDWords

@@LessThanFour:
  pop  ecx
  and  ecx, $3
  jz   @@Done
  mov  bl, [eax]
  mov  bh, [edx]
  mov  [edx], bl
  mov  [eax], bh
  inc  eax
  inc  edx
  dec  ecx
  jz   @@Done

  mov  bl, [eax]
  mov  bh, [edx]
  mov  [edx], bl
  mov  [eax], bh
  inc  eax
  inc  edx
  dec  ecx
  jz   @@Done

  mov  bl, [eax]
  mov  bh, [edx]
  mov  [edx], bl
  mov  [eax], bh

@@Done:
  pop  ebx
  pop  edi
end;

function ResolveEpoch(Year, Epoch : Integer) : Integer;
  {-Convert 2-digit year to 4-digit year according to Epoch}
var
  EpochYear,
  EpochCent : Integer;
begin
  if Word(Year) < 100 then begin
    EpochYear := Epoch mod 100;
    EpochCent := (Epoch div 100) * 100;
    if (Year < EpochYear) then
      Inc(Year,EpochCent+100)
    else
      Inc(Year,EpochCent);
  end;
  Result := Year;
end;

function CurrentDate : TStDate;
  {-Returns today's date as a julian}
var
  Year, Month, Date : Word;
begin
  DecodeDate(Now,Year,Month,Date);
  Result := DMYToStDate(Date,Month,Year,0);
end;

function DaysInMonth(Month : integer; Year, Epoch : Integer) : Integer;
    {-Return the number of days in the specified month of a given year}
begin
  Year := ResolveEpoch(Year, Epoch);

  if (Year < MinYear) OR (Year > MaxYear) then
  begin
    Result := 0;
    Exit;
  end;

  case Month of
    1, 3, 5, 7, 8, 10, 12 :
      Result := 31;
    4, 6, 9, 11 :
      Result := 30;
    2 :
     Result := 28+Ord(IsLeapYear(Year));
  else
    Result := 0;
  end;
end;

function ValidDate(Day, Month, Year, Epoch : Integer) : Boolean;
  {-Verify that day, month, year is a valid date}
begin
  Year := ResolveEpoch(Year, Epoch);

  if (Day < 1) or (Year < MinYear) or (Year > MaxYear) then
    Result := False
  else case Month of
    1..12 :
      Result := Day <= DaysInMonth(Month, Year, Epoch);
  else
    Result := False;
  end
end;

function DMYtoStDate(Day, Month, Year, Epoch : Integer) : TStDate;
  {-Convert from day, month, year to a julian date}
begin
  Year := ResolveEpoch(Year, Epoch);

  if not ValidDate(Day, Month, Year, Epoch) then
    Result := BadDate
  else if (Year = MinYear) and (Month < 3) then
    if Month = 1 then
      Result := Pred(Day)
    else
      Result := Day+30
  else begin
    if Month > 2 then
      Dec(Month, 3)
    else begin
      Inc(Month, 9);
      Dec(Year);
    end;
    Dec(Year, MinYear);
    Result :=
      ((LongInt(Year div 100)*146097) div 4)+
      ((LongInt(Year mod 100)*1461) div 4)+
      (((153*Month)+2) div 5)+Day+First2Months;
  end;
end;

function WeekOfYear(Julian : TStDate) : Byte;
  {-Returns the week number of the year given the Julian Date}
var
  Day, Month, Year : Integer;
  FirstJulian : TStDate;
begin
  if (Julian < MinDate) or (Julian > MaxDate) then
  begin
    Result := 0;
    Exit;
  end;

  Julian := Julian + 3 - ((6 + Ord(DayOfWeek(Julian))) mod 7);
  StDateToDMY(Julian,Day,Month,Year);
  FirstJulian := DMYToStDate(1,1,Year,0);
  Result := 1 + (Julian - FirstJulian) div 7;
end;

function AstJulianDate(Julian : TStDate) : Double;
  {-Returns the Astronomical Julian Date from a TStDate}
begin
  {Subtract 0.5d since Astronomical JD starts at noon
   while TStDate (with implied .0) starts at midnight}
  Result := Julian - 0.5 + DeltaJD;
end;


function AstJulianDatePrim(Year, Month, Date : Integer; UT : TStTime) : Double;
var
  A, B : integer;
  LY,
  GC   : Boolean;

begin
  Result := -MaxLongInt;
  if (not (Month in [1..12])) or (Date < 1)  then
    Exit
  else if (Month in [1, 3, 5, 7, 8, 10, 12]) and (Date > 31) then
    Exit
  else if (Month in [4, 6, 9, 11]) and (Date > 30) then
    Exit
  else if (Month = 2) then begin
    LY := IsLeapYear(Year);
    if ((LY) and (Date > 29)) or (not (LY) and (Date > 28)) then
      Exit;
  end else if ((UT < 0) or (UT >= SecondsInDay)) then
    Exit;

  if (Month <= 2) then begin
    Year := Year - 1;
    Month := Month + 12;
  end;
  A := abs(Year div 100);

  if (Year > 1582) then
    GC := True
  else if (Year = 1582) then begin
    if (Month > 10) then
      GC := True
    else if (Month < 10) then
      GC := False
    else begin
      if (Date >= 15) then
        GC := True
      else
        GC := False;
    end;
  end else
    GC := False;
  if (GC) then
    B := 2 - A + abs(A div 4)
  else
    B := 0;

  Result := Trunc(365.25 * (Year + 4716))
          + Trunc(30.6001 * (Month + 1))
          + Date + B - 1524.5
          + UT / SecondsInDay;
end;


function AstJulianDatetoStDate(AstJulian : Double; Truncate : Boolean) : TStDate;
  {-Returns a TStDate from an Astronomical Julian Date.
    Truncate TRUE   Converts to appropriate 0 hours then truncates
             FALSE  Converts to appropriate 0 hours, then rounds to
                    nearest;}
begin
  {Convert to TStDate, adding 0.5d for implied .0d of TStDate}
  AstJulian := AstJulian + 0.5 - DeltaJD;
  if (AstJulian < MinDate) OR (AstJulian > MaxDate) then
  begin
    Result := BadDate;
    Exit;
  end;

  if Truncate then
    Result := Trunc(AstJulian)
  else
    Result := Trunc(AstJulian + 0.5);
end;

procedure StDateToDMY(Julian : TStDate; var Day, Month, Year : Integer);
  {-Convert from a julian date to month, day, year}
var
  I, J : LongInt;
begin
  if Julian = BadDate then begin
    Day := 0;
    Month := 0;
    Year := 0;
  end else if Julian <= First2Months then begin
    Year := MinYear;
    if Julian <= 30 then begin
      Month := 1;
      Day := Succ(Julian);
    end else begin
      Month := 2;
      Day := Julian-30;
    end;
  end else begin
    I := (4*LongInt(Julian-First2Months))-1;

    J := (4*((I mod 146097) div 4))+3;
    Year := (100*(I div 146097))+(J div 1461);
    I := (5*(((J mod 1461)+4) div 4))-3;
    Day := ((I mod 153)+5) div 5;

    Month := I div 153;
    if Month < 10 then
      Inc(Month, 3)
    else begin
      Dec(Month, 9);
      Inc(Year);
    end;
    Inc(Year, MinYear);
  end;
end;

function IncDate(Julian : TStDate; Days, Months, Years : Integer) : TStDate;
  {-Add (or subtract) the number of months, days, and years to a date.
    Months and years are added before days. No overflow/underflow
    checks are made}
var
  Day, Month, Year, Day28Delta : Integer;
begin
  StDateToDMY(Julian, Day, Month, Year);
  Day28Delta := Day-28;
  if Day28Delta < 0 then
    Day28Delta := 0
  else
    Day := 28;

  Inc(Year, Years);
  Inc(Year, Months div 12);
  Inc(Month, Months mod 12);
  if Month < 1 then begin
    Inc(Month, 12);
    Dec(Year);
  end
  else if Month > 12 then begin
    Dec(Month, 12);
    Inc(Year);
  end;

  Julian := DMYtoStDate(Day, Month, Year,0);
  if Julian <> BadDate then begin
    Inc(Julian, Days);
    Inc(Julian, Day28Delta);
  end;
  Result := Julian;
end;

function IncDateTrunc(Julian : TStDate; Months, Years : Integer) : TStDate;
  {-Add (or subtract) the specified number of months and years to a date}
var
  Day, Month, Year : Integer;
  MaxDay, Day28Delta : Integer;
begin
  StDateToDMY(Julian, Day, Month, Year);
  Day28Delta := Day-28;
  if Day28Delta < 0 then
    Day28Delta := 0
  else
    Day := 28;

  Inc(Year, Years);
  Inc(Year, Months div 12);
  Inc(Month, Months mod 12);
  if Month < 1 then begin
    Inc(Month, 12);
    Dec(Year);
  end
  else if Month > 12 then begin
    Dec(Month, 12);
    Inc(Year);
  end;

  Julian := DMYtoStDate(Day, Month, Year,0);
  if Julian <> BadDate then begin
    MaxDay := DaysInMonth(Month, Year,0);
    if Day+Day28Delta > MaxDay then
      Inc(Julian, MaxDay-Day)
    else
      Inc(Julian, Day28Delta);
  end;
  Result := Julian;
end;

procedure DateDiff(Date1, Date2 : TStDate; var Days, Months, Years : Integer);
  {-Return the difference in days,months,years between two valid julian dates}
var
  Day1, Day2, Month1, Month2, Year1, Year2 : Integer;
begin
  {we want Date2 > Date1}
  if Date1 > Date2 then
    ExchangeLongInts(Date1, Date2);

  {convert dates to day,month,year}
  StDateToDMY(Date1, Day1, Month1, Year1);
  StDateToDMY(Date2, Day2, Month2, Year2);

  {days first}
  if (Day1 = DaysInMonth(Month1, Year1, 0)) then begin
    Day1 := 0;
    Inc(Month1);   {OK if Month1 > 12}
  end;
  if (Day2 = DaysInMonth(Month2, Year2, 0)) then begin
    Day2 := 0;
    Inc(Month2);   {OK if Month2 > 12}
  end;
  if (Day2 < Day1) then begin
    Dec(Month2);
    if Month2 = 0 then begin
      Month2 := 12;
      Dec(Year2);
    end;
    Days := Day2 + DaysInMonth(Month1, Year1, 0) - Day1;
  end else
  Days := Day2-Day1;

  {now months and years}
  if Month2 < Month1 then begin
    Inc(Month2, 12);
    Dec(Year2);
  end;
  Months := Month2-Month1;
  Years := Year2-Year1;
end;

function BondDateDiff(Date1, Date2 : TStDate; DayBasis : TStBondDateType) : TStDate;
  {-Return the difference in days between two valid Julian
    dates using one a specific accrual method}
var
  Day1,
  Month1,
  Year1,
  Day2,
  Month2,
  Year2       : Integer;
  IY          : LongInt;
begin
  {we want Date2 > Date1}
  if Date1 > Date2 then
    ExchangeLongInts(Date1, Date2);

  if (DayBasis = bdtActual) then
    Result := Date2-Date1
  else
  begin
    StDateToDMY(Date1, Day1, Month1, Year1);
    StDateToDMY(Date2, Day2, Month2, Year2);

    if ((DayBasis = bdt30360PSA) and IsLastDayofFeb(Date1)) or (Day1 = 31) then
      Day1 := 30;
    if (DayBasis = bdt30E360) then
    begin
      if (Day2 = 31) then
        Day2 := 30
    end else
      if (Day2 = 31) and (Day1 >= 30) then
        Day2 := 30;

    IY := 360 * (Year2 - Year1);
    Result := IY + 30 * (Month2 - Month1) + (Day2 - Day1);
  end;
end;

function DayOfWeek(Julian : TStDate) : TStDayType;
  {-Return the day of the week for the date. Returns TStDayType(7) if Julian =
    BadDate.}
var
  B : Byte;
begin
  if Julian = BadDate then begin
    B := 7;
    Result := TStDayType(B);
  end else
    Result := TStDayType( (Julian+Ord(FirstDayOfWeek)) mod 7 );
end;

function DayOfWeekDMY(Day, Month, Year, Epoch : Integer) : TStDayType;
  {-Return the day of the week for the day, month, year}
begin
  Result := DayOfWeek( DMYtoStDate(Day, Month, Year, Epoch) );
end;

procedure StTimeToHMS(T : TStTime; var Hours, Minutes, Seconds : Byte);
  {-Convert a Time variable to Hours, Minutes, Seconds}
begin
  if T = BadTime then begin
    Hours := 0;
    Minutes := 0;
    Seconds := 0;
  end
  else begin
    Hours := T div SecondsInHour;
    Dec(T, LongInt(Hours)*SecondsInHour);
    Minutes := T div SecondsInMinute;
    Dec(T, LongInt(Minutes)*SecondsInMinute);
    Seconds := T;
  end;
end;

function HMStoStTime(Hours, Minutes, Seconds : Byte) : TStTime;
  {-Convert Hours, Minutes, Seconds to a Time variable}
var
  T : TStTime;
begin
  Hours := Hours mod HoursInDay;
  T := (LongInt(Hours)*SecondsInHour)+(LongInt(Minutes)*SecondsInMinute)+Seconds;
  Result := T mod SecondsInDay;
end;

function ValidTime(Hours, Minutes, Seconds : Integer) : Boolean;
  {-Return true if Hours:Minutes:Seconds is a valid time}
begin
  if (Hours < 0)   or (Hours > 23) or
     (Minutes < 0) or (Minutes >= 60) or
     (Seconds < 0) or (Seconds >= 60) then
    Result := False
  else
    Result := True;
end;

function CurrentTime : TStTime;
  {-Returns current time in seconds since midnight}
begin
  Result := Trunc(SysUtils.Time * SecondsInDay);
end;

procedure TimeDiff(Time1, Time2 : TStTime; var Hours, Minutes, Seconds : Byte);
  {-Return the difference in hours,minutes,seconds between two times}
begin
  StTimeToHMS(Abs(Time1-Time2), Hours, Minutes, Seconds);
end;

function IncTime(T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime;
  {-Add the specified hours,minutes,seconds to T and return the result}
begin
  Inc(T, HMStoStTime(Hours, Minutes, Seconds));
  Result := T mod SecondsInDay;
end;

function DecTime(T : TStTime; Hours, Minutes, Seconds : Byte) : TStTime;
  {-Subtract the specified hours,minutes,seconds from T and return the result}
begin
  Hours := Hours mod HoursInDay;
  Dec(T, HMStoStTime(Hours, Minutes, Seconds));
  if T < 0 then
    Result := T+SecondsInDay
  else
    Result := T;
end;

function RoundToNearestHour(T : TStTime; Truncate : Boolean) : TStTime;
  {-Round T to the nearest hour, or Truncate minutes and seconds from T}
var
  Hours, Minutes, Seconds : Byte;
begin
  StTimeToHMS(T, Hours, Minutes, Seconds);
  Seconds := 0;
  if not Truncate then
    if Minutes >= (MinutesInHour div 2) then
      Inc(Hours);
  Minutes := 0;
  Result := HMStoStTime(Hours, Minutes, Seconds);
end;

function RoundToNearestMinute(const T : TStTime; Truncate : Boolean) : TStTime;
  {-Round T to the nearest minute, or Truncate seconds from T}
var
  Hours, Minutes, Seconds : Byte;
begin
  StTimeToHMS(T, Hours, Minutes, Seconds);
  if not Truncate then
    if Seconds >= (SecondsInMinute div 2) then
      Inc(Minutes);
  Seconds := 0;
  Result := HMStoStTime(Hours, Minutes, Seconds);
end;


procedure DateTimeDiff(DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec;
                       var Days : LongInt; var Secs : LongInt);
  {-Return the difference in days and seconds between two points in time}
var
  tDT1, tDT2 : TStDateTimeRec;
begin
  tDT1 := DT1;
  tDT2 := DT2;
  {swap if tDT1 later than tDT2}
  if (tDT1.D > tDT2.D) or ((tDT1.D = tDT2.D) and (tDT1.T > tDT2.T)) then
    ExchangeStructs(tDT1, tDT2,sizeof(TStDateTimeRec));

  {the difference in days is easy}
  Days := tDT2.D-tDT1.D;

  {difference in seconds}
  if tDT2.T < tDT1.T then begin
    {subtract one day, add 24 hours}
    Dec(Days);
    Inc(tDT2.T, SecondsInDay);
  end;
  Secs := tDT2.T-tDT1.T;
end;

function DateTimeToStDate(DT : TDateTime) : TStDate;
  {-Convert Delphi TDateTime to TStDate}
var
  Day, Month, Year : Word;
begin
  DecodeDate(DT, Year, Month, Day);
  Result := DMYToStDate(Day, Month, Year, 0);
end;

function DateTimeToStTime(DT : TDateTime) : TStTime;
  {-Convert Delphi TDateTime to TStTime}
var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(DT, Hour, Min, Sec, MSec);
  Result := HMSToStTime(Hour, Min, Sec);
end;

function StDateToDateTime(D : TStDate) : TDateTime;
  {-Convert TStDate to TDateTime}
var
  Day, Month, Year : Integer;
begin
  Result := 0;
  if D <> BadDate then begin
    StDateToDMY(D, Day, Month, Year);
    Result := EncodeDate(Year, Month, Day);
  end;
end;

function StTimeToDateTime(T : TStTime) : TDateTime;
  {-Convert TStTime to TDateTime}
var
  Hour, Min, Sec   : Byte;
begin
  Result := 0;
  if T <> BadTime then begin
    StTimeToHMS(T, Hour, Min, Sec);
    Result := EncodeTime(Hour, Min, Sec, 0);
  end;
end;

procedure IncDateTime(DT1 : TStDateTimeRec; var DT2 : TStDateTimeRec; Days : Integer; Secs : LongInt);
  {-Increment (or decrement) DT1 by the specified number of days and seconds
    and put the result in DT2}
begin
  DT2 := DT1;

  {date first}
  Inc(DT2.D, LongInt(Days));

  if Secs < 0 then begin
    {change the sign}
    Secs := -Secs;

    {adjust the date}
    Dec(DT2.D, Secs div SecondsInDay);
    Secs := Secs mod SecondsInDay;

    if Secs > DT2.T then begin
      {subtract a day from DT2.D and add a day's worth of seconds to DT2.T}
      Dec(DT2.D);
      Inc(DT2.T, SecondsInDay);
    end;

    {now subtract the seconds}
    Dec(DT2.T, Secs);
  end
  else begin
    {increment the seconds}
    Inc(DT2.T, Secs);

    {adjust date if necessary}
    Inc(DT2.D, DT2.T div SecondsInDay);

    {force time to 0..SecondsInDay-1 range}
    DT2.T := DT2.T mod SecondsInDay;
  end;
end;

function Convert2ByteDate(TwoByteDate : Word) : TStDate;
begin
  Result := LongInt(TwoByteDate) + Date1900;
end;

function Convert4ByteDate(FourByteDate : TStDate) : Word;
begin
  Result := Word(FourByteDate - Date1900);
end;

procedure SetDefaultYear;
  {-Initialize DefaultYear and DefaultMonth}
var
  Month, Day, Year : Word;
  T : TDateTime;
begin
  T := Now;
  DecodeDate(T, Year, Month, Day);
  DefaultYear := Year;
  DefaultMonth := Month;
end;


initialization
  {initialize DefaultYear and DefaultMonth}
  SetDefaultYear;
end.

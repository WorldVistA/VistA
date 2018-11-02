{*********************************************************}
{*                   OVCINTL.PAS 4.06                    *}
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

unit ovcintl;
  {-International date/time support class}

interface

uses
  Windows, Registry, Classes, Forms, Messages, SysUtils, OvcConst, OvcData,
  OvcStr, OvcDate;

type
  TCurrencySt = array[0..5] of AnsiChar;

  {.Z+}
  TIntlData = packed record
    {substitution strings for semi-literal mask characters}
    CurrencyLtStr : TCurrencySt; {corresponding string for 'c'}
    CurrencyRtStr : TCurrencySt; {corresponding string for 'C'}
    DecimalChar   : AnsiChar;    {character used for decimal point}
    CommaChar     : AnsiChar;    {character used for comma}
    {format specifiers for currency masks}
    CurrDigits    : Byte;        {number of dec places in currency}
    SlashChar     : AnsiChar;    {date seperator}
    {characters that represent boolean values}
    TrueChar      : AnsiChar;
    FalseChar     : AnsiChar;
    YesChar       : AnsiChar;
    NoChar        : AnsiChar;
  end;
  {.Z-}

type
  TOvcIntlSup = class(TObject)
  {.Z+}
  protected {private}
    FAutoUpdate      : Boolean;     {true to reset settings when win.ini changes}

    {substitution strings for semi-literal mask characters}
    FCurrencyLtStr   : TCurrencySt; {corresponding string for 'c'}
    FCurrencyRtStr   : TCurrencySt; {corresponding string for 'C'}
    FDecimalChar     : AnsiChar;    {character used for decimal point}

    {general international settings}
    FCommaChar       : AnsiChar;    {character used for comma}
    FCurrencyDigits  : Byte;        {number of dec places in currency}
    FListChar        : AnsiChar;    {list serarater}
    FSlashChar       : AnsiChar;    {character used to separate dates}

    {characters that represent boolean values}
    FTrueChar        : AnsiChar;
    FFalseChar       : AnsiChar;
    FYesChar         : AnsiChar;
    FNoChar          : AnsiChar;

    {event variables}
    FOnWinIniChange  : TNotifyEvent; {notify of win.ini changes}

    {internal working variables}
    intlHandle       : hWnd;  {our window handle}
    w1159            : array[0..5] of AnsiChar;
    w2359            : array[0..5] of AnsiChar;
    wColonChar       : AnsiChar;
    wCountry         : PAnsiChar;
    wCurrencyForm    : Byte;
    wldSub1          : array[0..5] of AnsiChar;
    wldSub2          : array[0..5] of AnsiChar;
    wldSub3          : array[0..5] of AnsiChar;
    wLongDate        : array[0..39] of AnsiChar;
    wNegCurrencyForm : Byte;
    wShortDate       : array[0..29] of AnsiChar;
    wTLZero          : Boolean;
    w12Hour          : Boolean;

    {property methods}
    function GetCountry : string;
    function GetCurrencyLtStr : string;
    function GetCurrencyRtStr : string;
    procedure SetAutoUpdate(Value : Boolean);
    procedure SetCurrencyLtStr(const Value : string);
    procedure SetCurrencyRtStr(const Value : string);

    {internal methods}
    procedure isExtractFromPicture(Picture, S : PAnsiChar; Ch : AnsiChar;
              var I : Integer; Blank, Default : Integer);
    procedure isIntlWndProc(var Msg : TMessage);
    function isMaskCharCount(P : PAnsiChar; MC : AnsiChar) : Word;
    procedure isMergeIntoPicture(Picture : PAnsiChar; Ch : AnsiChar; I : Integer);
    procedure isMergePictureSt(Picture, P : PAnsiChar; MC : AnsiChar; SP : PAnsiChar);
    procedure isPackResult(Picture, S : PAnsiChar);
    procedure isSubstChar(Picture : PAnsiChar; OldCh, NewCh : AnsiChar);
    procedure isSubstCharSim(P : PAnsiChar; OC, NC : AnsiChar);
    function isTimeToTimeStringPrim(Dest, Picture : PAnsiChar; T : TStTime;
             Pack : Boolean; t1159, t2359 : PAnsiChar) : PAnsiChar;

  public
    constructor Create;
    destructor Destroy;
      override;
  {.Z-}

    function CurrentDateString(const Picture : string;
      Pack : Boolean) : string;
  {.Z+}
    function CurrentDatePChar(Dest : PAnsiChar; Picture : PAnsiChar;
      Pack : Boolean) : PAnsiChar;
      {-returns today's date as a string of the specified form}
  {.Z-}

    function CurrentTimeString(const Picture : string; Pack : Boolean) : string;
  {.Z+}
    function CurrentTimePChar(Dest : PAnsiChar; Picture : PAnsiChar; Pack : Boolean) : PAnsiChar;
      {-returns current time as a string of the specified form}
  {.Z-}

    function DateToDateString(const Picture : string; Julian : TStDate;
      Pack : Boolean) : string;
  {.Z+}
    function DateToDatePChar(Dest : PAnsiChar; Picture : PAnsiChar; Julian : TStDate;
      Pack : Boolean) : PAnsiChar;
  {.Z-}
      {-convert Julian to a string of the form indicated by Picture}

    function DateStringToDMY(const Picture, S : string; var Day, Month, Year : Integer;
      Epoch : Integer) : Boolean;
  {.Z+}
    function DatePCharToDMY(Picture, S : PAnsiChar; var Day, Month, Year : Integer;
      Epoch : Integer) : Boolean;
  {.Z-}
      {-extract day, month, and year from S, returning true if string is valid}

    function DateStringIsBlank(const Picture, S : string) : Boolean;
  {.Z+}
    function DatePCharIsBlank(Picture, S : PAnsiChar) : Boolean;
  {.Z-}
      {-return True if the month, day, and year in S are all blank}

    function DateStringToDate(const Picture, S : string; Epoch : Integer) : TStDate;
  {.Z+}
    function DatePCharToDate(Picture, S : PAnsiChar; Epoch : Integer) : TStDate;
  {.Z-}
      {-convert St, a string of the form indicated by Picture, to a julian date. Picture and St must be of equal lengths}

    function DayOfWeekToString(WeekDay : TDayType) : string;
  {.Z+}
    function DayOfWeekToPChar(Dest : PAnsiChar; WeekDay : TDayType) : PAnsiChar;
  {.Z-}
      {-return a string for the specified day of the week}

    function DMYtoDateString(const Picture : string;
      Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : string;
  {.Z+}
    function DMYtoDatePChar(Dest : PAnsiChar; Picture : PAnsiChar;
      Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : PAnsiChar;
  {.Z-}
      {-merge the month, day, and year into the picture}

    function InternationalCurrency(FormChar : AnsiChar; MaxDigits : Byte; Float,
                                   AddCommas, IsNumeric : Boolean) : string;
  {.Z+}
    function InternationalCurrencyPChar(Dest : PAnsiChar; FormChar : AnsiChar;
                                        MaxDigits : Byte; Float,
                                        AddCommas, IsNumeric : Boolean) : PAnsiChar;
  {.Z-}
      {-return a picture mask for a currency string, based on Windows' intl info}

    function InternationalDate(ForceCentury : Boolean) : string;
  {.Z+}
    function InternationalDatePChar(Dest : PAnsiChar; ForceCentury : Boolean) : PAnsiChar;
  {.Z-}
      {-return a picture mask for a short date string, based on Windows' international information}

    function InternationalLongDate(ShortNames : Boolean; ExcludeDOW : Boolean) : string;
  {.Z+}
    function InternationalLongDatePChar(Dest : PAnsiChar; ShortNames : Boolean; ExcludeDOW : Boolean) : PAnsiChar;
  {.Z-}
      {-return a picture mask for a date string, based on Windows' international information}

    function InternationalTime(ShowSeconds : Boolean) : string;
  {.Z+}
    function InternationalTimePChar(Dest : PAnsiChar; ShowSeconds : Boolean) : PAnsiChar;
  {.Z-}
      {-return a picture mask for a time string, based on Windows' international information}

    function MonthStringToMonth(const S : string; Width : Byte) : Byte;
  {.Z+}
    function MonthPCharToMonth(S : PAnsiChar; Width : Byte) : Byte;
  {.Z-}
      {-Convert the month name in S to a month (1..12)}

    function MonthToString(Month : Integer) : string;
  {.Z+}
    function MonthToPChar(Dest : PAnsiChar; Month : Integer) : PAnsiChar;
  {.Z-}
      {return month name as a string for Month}

    procedure ResetInternationalInfo;
      {-read string resources and update internal info to match Windows'}

    function TimeStringToHMS(const Picture, S : string; var Hour, Minute, Second : Integer) : Boolean;
  {.Z+}
    function TimePCharToHMS(Picture, S : PAnsiChar; var Hour, Minute, Second : Integer) : Boolean;
  {.Z-}
      {-extract Hours, Minutes, Seconds from St, returning true if string is valid}

    function TimeStringToTime(const Picture, S : string) : TStTime;
  {.Z+}
    function TimePCharToTime(Picture, S : PAnsiChar) : TStTime;
  {.Z-}
      {-convert S, a string of the form indicated by Picture, to a Time variable}

    function TimeToTimeString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  {.Z+}
    function TimeToTimePChar(Dest : PAnsiChar; Picture : PAnsiChar; T : TStTime; Pack : Boolean) : PAnsiChar;
  {.Z-}
      {-convert T to a string of the form indicated by Picture}

    function TimeToAmPmString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  {.Z+}
    function TimeToAmPmPChar(Dest : PAnsiChar; Picture : PAnsiChar; T : TStTime; Pack : Boolean) : PAnsiChar;
  {.Z-}
      {-convert T to a string of the form indicated by Picture. Times are always displayed in am/pm format.}

    property AutoUpdate : Boolean
      read FAutoUpdate write SetAutoUpdate;
    property CurrencyLtStr : string
      read GetCurrencyLtStr write SetCurrencyLtStr;
    property CurrencyRtStr : string
      read GetCurrencyRtStr write SetCurrencyRtStr;
    property DecimalChar : AnsiChar
      read FDecimalChar write FDecimalChar;
    property CommaChar : AnsiChar
      read FCommaChar write FCommaChar;
    property Country : string
      read GetCountry;
    property CurrencyDigits : Byte
      read FCurrencyDigits write FCurrencyDigits;
    property ListChar : AnsiChar
      read FListChar write FListChar;
    property SlashChar : AnsiChar
      read FSlashChar write FSlashChar;
    property TrueChar : AnsiChar
      read FTrueChar write FTrueChar;
    property FalseChar : AnsiChar
      read FFalseChar write FFalseChar;
    property YesChar : AnsiChar
      read FYesChar write FYesChar;
    property NoChar  : AnsiChar
      read FNoChar write FNoChar;
    property OnWinIniChange : TNotifyEvent
      read FOnWinIniChange write FOnWinIniChange;
  end;

const
  DefaultIntlData : TIntlData = (
    {substitution strings for semi-literal mask characters}
    CurrencyLtStr : '$'; {corresponding string for 'c'}
    CurrencyRtStr : '';  {corresponding string for 'C'}
    DecimalChar   : '.'; {character used for decimal point}
    CommaChar     : ','; {character used for comma}
    {format specifiers for currency masks}
    CurrDigits    : 2;   {number of dec places in currency}
    SlashChar     : '/'; {date seperator}
    {characters that represent boolean values}
    TrueChar      : 'T';
    FalseChar     : 'F';
    YesChar       : 'Y';
    NoChar        : 'N');

var
  {global default international support object}
  OvcIntlSup : TOvcIntlSup;

implementation

{*** Inline routines ***}

function GetMaxWord(A, B : Word) : Word; register;
  {-Return the greater of A and B}
asm
  and    eax,0FFFFH {faster than movzx              }
  and    edx,0FFFFH {faster than movzx              }
  cmp    eax,edx    {compare A and B                }
  jae    @@001      {done if ax is greater or equal }
  mov    eax,edx    {dx is larger, set result       }
@@001:
end;

{*** TOvcIntlSup ***}

constructor TOvcIntlSup.Create;
begin
  inherited Create;

  FAutoUpdate      := False;

  {substitution strings for semi-literal mask characters}
  StrCopy(FCurrencyLtStr, DefaultIntlData.CurrencyLtStr);
  StrCopy(FCurrencyRtStr, DefaultIntlData.CurrencyRtStr);
  FDecimalChar     := DefaultIntlData.DecimalChar;
  FCommaChar       := DefaultIntlData.CommaChar;

  {format specifiers for currency masks}
  FCurrencyDigits  := DefaultIntlData.CurrDigits;
  FSlashChar       := DefaultIntlData.SlashChar;

  {characters that represent boolean values}
  FTrueChar        := DefaultIntlData.TrueChar;
  FFalseChar       := DefaultIntlData.FalseChar;
  FYesChar         := DefaultIntlData.YesChar;
  FNoChar          := DefaultIntlData.NoChar;

  {get windows international information}
  ResetInternationalInfo;
end;

function TOvcIntlSup.CurrentDateString(const Picture : string;
  Pack : Boolean) : string;
  {-returns today's date as a string of the specified form}
begin
  Result := DateToDateString(Picture, CurrentDate, Pack);
end;

function TOvcIntlSup.CurrentDatePChar(Dest : PAnsiChar; Picture : PAnsiChar;
  Pack : Boolean) : PAnsiChar;
  {-returns today's date as a string of the specified form}
begin
  Result := DateToDatePChar(Dest, Picture, CurrentDate, Pack);
end;

function TOvcIntlSup.CurrentTimeString(const Picture : string; Pack : Boolean) : string;
  {-returns current time as a string of the specified form}
begin
  Result := TimeToTimeString(Picture, CurrentTime, Pack);
end;

function TOvcIntlSup.CurrentTimePChar(Dest : PAnsiChar; Picture : PAnsiChar; Pack : Boolean) : PAnsiChar;
  {-returns current time as a string of the specified form}
begin
  Result := TimeToTimePChar(Dest, Picture, CurrentTime, Pack);
end;

function TOvcIntlSup.DateStringIsBlank(const Picture, S : string) : Boolean;
  {-return True if the month, day, and year in S are all blank}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  StrPCopy(Buf2, S);
  Result := DatePCharIsBlank(Buf1, Buf2);
end;

function TOvcIntlSup.DatePCharIsBlank(Picture, S : PAnsiChar) : Boolean;
  {-return True if the month, day, and year in S are all blank}
var
  M, D, Y : Integer;
begin
  isExtractFromPicture(Picture, S, pmMonthName,  M, -2, 0);
  if M = 0 then
    isExtractFromPicture(Picture, S, pmMonth, M, -2, -2);
  isExtractFromPicture(Picture, S, pmDay,   D, -2, -2);
  isExtractFromPicture(Picture, S, pmYear,  Y, -2, -2);
  Result := (M = -2) and (D = -2) and (Y = -2);
end;

function TOvcIntlSup.DateStringToDate(const Picture, S : string; Epoch : Integer) : TStDate;
  {-convert St, a string of the form indicated by Picture, to a julian date.
    Picture and St must be of equal lengths}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  StrPCopy(Buf2, S);
  Result := DatePCharToDate(Buf1, Buf2, Epoch);
end;

function TOvcIntlSup.DatePCharToDate(Picture, S : PAnsiChar; Epoch : Integer) : TStDate;
  {-convert St, a string of the form indicated by Picture, to a julian date.
    Picture and St must be of equal lengths}
var
  Month, Day, Year : Integer;
begin
  {extract day, month, year from St}
  if DatePCharToDMY(Picture, S, Day, Month, Year, Epoch) then
    {convert to julian date}
    Result := DMYtoStDate(Day, Month, Year, Epoch)
  else
    Result := BadDate;
end;

function TOvcIntlSup.DateStringToDMY(const Picture, S : string; var Day, Month, Year : Integer;
  Epoch : Integer) : Boolean;
  {-extract day, month, and year from S, returning true if string is valid}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  StrPCopy(Buf2, S);
  Result := DatePCharToDMY(Buf1, Buf2, Day, Month, Year, Epoch);
end;

function TOvcIntlSup.DatePCharToDMY(Picture, S : PAnsiChar; var Day, Month, Year : Integer;
  Epoch : Integer) : Boolean;
  {-extract day, month, and year from S, returning true if string is valid}
begin
  Result := False;
  if StrLen(Picture) <> StrLen(S) then
    Exit;

  isExtractFromPicture(Picture, S, pmMonthName, Month, -1, 0);
  if Month = 0 then
    isExtractFromPicture(Picture, S, pmMonth, Month, -1, DefaultMonth);
  isExtractFromPicture(Picture, S, pmDay, Day, -1, 1);
  isExtractFromPicture(Picture, S, pmYear, Year, -1, DefaultYear);
  Result := ValidDate(Day, Month, Year, Epoch);
end;

function TOvcIntlSup.DateToDateString(const Picture : string;
         Julian : TStDate; Pack : Boolean) : string;
  {-convert Julian to a string of the form indicated by Picture}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  Result := StrPas(DateToDatePChar(Buf2, Buf1, Julian, Pack));
end;

function TOvcIntlSup.DateToDatePChar(Dest : PAnsiChar; Picture : PAnsiChar;
         Julian : TStDate; Pack : Boolean) : PAnsiChar;
  {-convert Julian to a string of the form indicated by Picture}
var
  Month, Day, Year : Integer;
begin
  Move(Picture[0], Dest[0], StrLen(Picture)+1);
  if Julian = BadDate then begin
    {map picture characters to spaces}
    isSubstChar(Dest, pmMonth,   ' ');
    isSubstChar(Dest, pmMonthName,    ' ');
    isSubstChar(Dest, pmDay,     ' ');
    isSubstChar(Dest, pmYear,    ' ');
    isSubstChar(Dest, pmWeekDay, ' ');
    isMergePictureSt(Picture, Dest, pmLongDateSub1, wldSub1);
    isMergePictureSt(Picture, Dest, pmLongDateSub2, wldSub2);
    isMergePictureSt(Picture, Dest, pmLongDateSub3, wldSub3);

    {map slashes}
    isSubstChar(Dest, pmDateSlash, SlashChar);

    Result := Dest;
  end else begin
    {convert Julian to day/month/year}
    StDateToDMY(Julian, Day, Month, Year);
    {merge the month, day, and year into the picture}
    Result := DMYtoDatePChar(Dest, Picture, Day, Month, Year, Pack, 0);
  end;
end;

function TOvcIntlSup.DayOfWeekToString(WeekDay : TDayType) : string;
  {-return the day of the week specified by WeekDay as a string. Will
    honor the international names as specified in the INI file.}
begin
  Result := FormatSettings.LongDayNames[Ord(WeekDay)+1];
end;

function TOvcIntlSup.DayOfWeekToPChar(Dest : PAnsiChar; WeekDay : TDayType) : PAnsiChar;
  {-return the day of the week specified by WeekDay as a string in Dest. Will
    honor the international names as specified in the INI file.}
begin
  Result := Dest;
  StrPCopy(Dest, FormatSettings.LongDayNames[Ord(WeekDay)+1]);
end;

destructor TOvcIntlSup.Destroy;
begin
  if intlHandle <> 0 then
  {$IFDEF VERSION6}
    Classes.DeallocateHWnd(intlHandle);
  {$ELSE}
    DeallocateHWnd(intlHandle);
  {$ENDIF}
  StrDispose(wCountry);
  inherited Destroy;
end;

function TOvcIntlSup.DMYtoDateString(const Picture : string; Day, Month,
         Year : Integer; Pack : Boolean; Epoch : Integer) : string;
  {-merge the month, day, and year into the picture}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  Result := StrPas(DMYtoDatePChar(Buf2, Buf1, Day, Month, Year, Pack, Epoch));
end;

function TOvcIntlSup.DMYtoDatePChar(Dest : PAnsiChar; Picture : PAnsiChar; Day, Month,
         Year : Integer; Pack : Boolean; Epoch : Integer) : PAnsiChar;
  {-merge the month, day, and year into the picture}
var
  DOW       : Integer;
  EpochCent : Integer;
begin
  Move(Picture[0], Dest[0], StrLen(Picture)+1);

  EpochCent := (Epoch div 100)*100;
  if Word(Year) < 100 then begin
    if Year < (Epoch mod 100) then
      Inc(Year, EpochCent + 100)
    else
      Inc(Year, EpochCent)
  end;

  DOW := Integer(DayOfWeekDMY(Day, Month, Year, Epoch));
  isMergeIntoPicture(Dest, pmMonth, Month);
  isMergeIntoPicture(Dest, pmDay, Day);
  isMergeIntoPicture(Dest, pmYear, Year);
  isMergeIntoPicture(Dest, pmMonthName, Month);
  isMergeIntoPicture(Dest, pmWeekDay, DOW);

  {map slashes}
  isSubstChar(Dest, pmDateSlash, SlashChar);

  isMergePictureSt(Picture, Dest, pmLongDateSub1, wldSub1);
  isMergePictureSt(Picture, Dest, pmLongDateSub2, wldSub2);
  isMergePictureSt(Picture, Dest, pmLongDateSub3, wldSub3);

  if Pack then
    isPackResult(Picture, Dest);

  Result := Dest;
end;

function TOvcIntlSup.GetCountry : string;
  {-return the country setting}
begin
  Result := StrPas(wCountry);
end;

function TOvcIntlSup.GetCurrencyLtStr : string;
begin
  Result := StrPas(FCurrencyLtStr);
end;

function TOvcIntlSup.GetCurrencyRtStr : string;
begin
  Result := StrPas(FCurrencyRtStr);
end;

function TOvcIntlSup.InternationalCurrency(FormChar : AnsiChar; MaxDigits : Byte; Float,
         AddCommas, IsNumeric : Boolean) : string;
  {-Return a picture mask for a currency string, based on Windows' intl info}
var
  Buf1 : array[0..255] of AnsiChar;
begin
  Result := StrPas(InternationalCurrencyPChar(Buf1, FormChar, MaxDigits,
            Float, AddCommas, IsNumeric));
end;

function TOvcIntlSup.InternationalCurrencyPChar(Dest : PAnsiChar; FormChar : AnsiChar;
         MaxDigits : Byte; Float, AddCommas, IsNumeric : Boolean) : PAnsiChar;
  {-Return a picture mask for a currency string, based on Windows' intl info}
const
  NP : array[0..1] of AnsiChar = pmNegParens+#0;
  NH : array[0..1] of AnsiChar = pmNegHere+#0;
var
  CLSlen, DLen, I, J : Word;
  Tmp : array[0..10] of AnsiChar;
begin
  Dest[0] := #0;
  Result := Dest;

  if (MaxDigits = 0) then
    Exit;

  {initialize Dest with the numeric part of the string to left of decimal point}
  I := Pred(MaxDigits) div 3 ;
  J := Word(MaxDigits)+(I*Ord(AddCommas));
  if J > 247 then
    DLen := 247
  else
    DLen := J;
  FillChar(Dest[0], DLen, FormChar);
  Dest[DLen] := #0;

  if AddCommas then begin
    {insert commas at appropriate points}
    J := 0;
    for I := DLen-1 downto 0 do
      if J < 3 then
        Inc(J)
      else begin
        Dest[I] := pmComma;
        J := 0;
      end;
  end;

  {add in the decimals}
  if CurrencyDigits > 0 then begin
    Dest[DLen] := pmDecimalPt;
    FillChar(Dest[DLen+1], CurrencyDigits, FormChar);
    Inc(DLen, CurrencyDigits+1);
    Dest[DLen] := #0;
  end;

  {do we need a minus before the currency symbol}
  if (wNegCurrencyForm = 6) then
    StrCat(Dest, NH);

  {see if we can do a floating currency symbol}
  if Float then
    Float := not Odd(wCurrencyForm);

  {plug in the picture characters for the currency symbol}
  CLSlen := StrLen(FCurrencyLtStr);
  if Float then
    StrStInsertPrim(Dest, CharStrPChar(Tmp, pmFloatDollar, CLSlen), 0)
  else if not Odd(wCurrencyForm) then
    StrStInsertPrim(Dest, CharStrPChar(Tmp, pmCurrencyLt, CLSlen), 0)
  else
    StrCat(Dest, CharStrPChar(Tmp, pmCurrencyRt, StrLen(FCurrencyRtStr)));

  {plug in special minus characters}
  if IsNumeric then
    case wNegCurrencyForm of
      0, 4 :
        StrCat(Dest, NP);
      3, 7, 10 :
        if Odd(wCurrencyForm) then
          StrCat(Dest, NH);
    end;
end;

function TOvcIntlSup.InternationalDate(ForceCentury : Boolean) : string;
  {-return a picture mask for a short date string, based on Windows' international information}
var
  Buf : array[0..255] of AnsiChar;
begin
  InternationalDatePChar(Buf, ForceCentury);
  Result := StrPas(Buf);
end;

function TOvcIntlSup.InternationalDatePChar(Dest : PAnsiChar;
                                            ForceCentury : Boolean) : PAnsiChar;
  {-return a picture mask for a date string, based on Windows' int'l info}


  procedure FixMask(MC : AnsiChar; DL : Integer);
  var
    I     : Cardinal;
    J, AL : Word;
    MCT   : AnsiChar;
    Found : Boolean;
  begin
    {find number of matching characters}
    MCT := MC;

    Found := StrChPos(Dest, MC, I);
    if not Found then begin
      MCT := UpCase(MC);
      Found := StrChPos(Dest, MCT, I);
    end;
    if not Found then
      Exit;

    {pad substring to desired length}
    AL := isMaskCharCount(Dest, MCT);
    if AL < DL then
      for J := 1 to DL-AL do
        StrChInsertPrim(Dest, MCT, I);


    if MC <> pmYear then
      {choose blank/zero padding}
      case AL of
        1 : if MCT = MC then
              isSubstCharSim(Dest, MCT, UpCase(MCT));
        2 : if MCT <> MC then
              isSubstCharSim(Dest, MCT, MC);
      end;
  end;

begin
  {copy Windows mask into our var}
  StrCopy(Dest, wShortDate);

  {if single Day marker, make double}
  FixMask(pmDay, 2);

  {if single Month marker, make double}
  FixMask(pmMonth, 2);

  {force yyyy if desired}
  FixMask(pmYear, 2 shl Ord(ForceCentury));

  Result := Dest;
end;

function TOvcIntlSup.InternationalLongDate(ShortNames : Boolean; ExcludeDOW : Boolean) : string;
  {-return a picture mask for a date string, based on Windows' int'l info}
var
  Buf : array[0..255] of AnsiChar;
begin
  Result := StrPas(InternationalLongDatePChar(Buf, ShortNames, ExcludeDOW));
end;

function TOvcIntlSup.InternationalLongDatePChar(Dest : PAnsiChar; ShortNames : Boolean;
         ExcludeDOW : Boolean) : PAnsiChar;
  {-return a picture mask for a date string, based on Windows' int'l info}
var
  I    : Cardinal;
  WC   : Word;
  Temp : array[0..80] of AnsiChar;
  Stop : Boolean;

  function LongestMonthName : Word;
  var
    I : Word;
  begin
    Result := 0;
    for I := 1 to 12 do
      Result := GetMaxWord(Result, Length(FormatSettings.LongMonthNames[I]));
  end;

  function LongestDayName : Word;
  var
    D : TDayType;
  begin
    Result := 0;
    for D := Sunday to Saturday do
      Result := GetMaxWord(Result, Length(FormatSettings.LongDayNames[Ord(D)+1]));
  end;

  procedure FixMask(MC : AnsiChar; DL : Integer);
  var
    I     : Cardinal;
    J, AL : Word;
    MCT   : AnsiChar;
    Found : Boolean;
  begin
    {find first matching mask character}
    MCT := MC;
    Found := StrChPos(Temp, MC, I);
    if not Found then begin
      MCT := UpCase(MC);
      Found := StrChPos(Temp, MCT, I);
    end;
    if not Found then
      Exit;

    {pad substring to desired length}
    AL := isMaskCharCount(Temp, MCT);
    if AL < DL then begin
      for J := 1 to DL-AL do
        StrChInsertPrim(Temp, MCT, I);
    end else if (AL > DL) then
      StrStDeletePrim(Temp, I, AL-DL);

    if MC <> pmYear then
      {choose blank/zero padding}
      case AL of
        1 : if MCT = MC then
              isSubstCharSim(Temp, MCT, UpCase(MCT));
        2 : if MCT <> MC then
              isSubstCharSim(Temp, MCT, MC);
      end;
  end;

begin
  {copy Windows mask into temporary var}
  StrCopy(Temp, wLongDate);

  if ExcludeDOW then begin
    {remove day-of-week and any junk that follows}
    if StrChPos(Temp, pmWeekDay, I) then begin
      WC := 1;
      Stop := False;
      repeat
        case LoCaseChar(Temp[I+WC]) of
          #0, pmMonth, pmDay, pmYear, pmMonthName : Stop := True;
        else
          Inc(WC);
        end;
      until Stop;
      StrStDeletePrim(Temp, I, WC);
    end;
  end else if ShortNames then
    FixMask(pmWeekDay, 3)
  else if isMaskCharCount(Temp, pmWeekday) = 4 then
    FixMask(pmWeekDay, LongestDayName);

  {fix month names}
  if ShortNames then
    FixMask(pmMonthName, 3)
  else if isMaskCharCount(Temp, pmMonthName) = 4 then
    FixMask(pmMonthName, LongestMonthName);

  {if single Day marker, make double}
  FixMask(pmDay, 2);

  {if single Month marker, make double}
  FixMask(pmMonth, 2);

  {force yyyy}
  FixMask(pmYear, 4);

  {copy result into Dest}
  StrCopy(Dest, Temp);
  Result := Dest;
end;

function TOvcIntlSup.InternationalTime(ShowSeconds : Boolean) : string;
  {-return a picture mask for a time string, based on Windows' int'l info}
var
  Buf : array[0..255] of AnsiChar;
begin
  Result := StrPas(InternationalTimePChar(Buf, ShowSeconds));
end;

function TOvcIntlSup.InternationalTimePChar(Dest : PAnsiChar; ShowSeconds : Boolean) : PAnsiChar;
  {-return a picture mask for a time string, based on Windows' int'l info}
var
  SL, ML : Word;
  S : array[0..20] of AnsiChar;
begin
  {format the default string}
  StrCopy(S, 'hh:mm:ss');
  if not wTLZero then
    S[0] := pmHourU;

  {show seconds?}
  if not ShowSeconds then
    S[5] := #0;

  {handle international AM/PM markers}
  if w12Hour then begin
    ML := GetMaxWord(StrLen(PAnsiChar(@w1159)), StrLen(PAnsiChar(@w2359)));
    if (ML <> 0) then begin
      SL := StrLen(S);
      S[SL] := ' ';
      FillChar(S[SL+1], ML, pmAmPm);
      S[SL+ML+1] := #0;
    end;
  end;

  StrCopy(Dest, S);
  Result := Dest;
end;

procedure TOvcIntlSup.isIntlWndProc(var Msg : TMessage);
  {-window procedure to catch WM_WININICHANGE messages}
begin
  with Msg do
    if AutoUpdate and (Msg = WM_WININICHANGE) then
      try
        if Assigned(FOnWinIniChange) then
          FOnWinIniChange(Self)
        else
          ResetInternationalInfo;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(intlHandle, Msg, wParam, lParam);
end;

procedure TOvcIntlSup.isExtractFromPicture(Picture, S : PAnsiChar;
                             Ch : AnsiChar; var I : Integer;
                             Blank, Default : Integer);
  {-extract the value of the subfield specified by Ch from S and return in
    I. I will be set to -1 in case of an error, Blank if the subfield exists
    in Picture but is empty, Default if the subfield doesn't exist in
    Picture.}
var
  PTmp    : Array[0..20] of AnsiChar;
  J, K, W : Cardinal;
  Code    : Integer;
  Found,
  UpFound : Boolean;
begin
  {find the start of the subfield}
  I := Default;
  Found := StrChPos(Picture, Ch, J);
  Ch := UpCaseChar(Ch);
  UpFound := StrChPos(Picture, Ch, K);

  if not Found or (UpFound and (K < J)) then begin
    J := K;
    Found := UpFound;
  end;
  if not Found or (StrLen(S) <> StrLen(Picture)) then
    Exit;

  {extract the substring}
  PTmp[0] := #0;
  W := 0;
  K := 0;
  while (UpCaseChar(Picture[J]) = Ch) and (J < StrLen(Picture)) do begin
    if S[J] <> ' ' then begin
      PTmp[k] := S[J];
      Inc(K);
      PTmp[k] := #0;
    end;
    Inc(J);
    Inc(W);
  end;

  if StrLen(PTmp) = 0 then
    I := Blank
  else if Ch = pmMonthNameU then begin
    I := MonthPCharToMonth(PTmp, W);
    if I = 0 then
      I := -1;
  end else begin
    {convert to a value}
    Val(PTmp, I, Code);
    if Code <> 0 then
      I := -1;
  end;
end;

function TOvcIntlSup.isMaskCharCount(P : PAnsiChar; MC : AnsiChar) : Word;
  {-return the number of mask characters (MC) in P}
var
  I : Cardinal;
begin
  if StrChPos(P, MC, I) then begin
    Result := 1;
    while P[I+Result] = MC do
      Inc(Result);
  end else
    Result := 0;
end;

procedure TOvcIntlSup.isMergePictureSt(Picture, P : PAnsiChar; MC : AnsiChar; SP : PAnsiChar);
var
  I, J : Cardinal;
begin
  if not StrChPos(Picture, MC, I) then
    Exit;
  J := 0;
  while Picture[I] = MC do begin
    if SP[J] = #0 then
      P[I] := ' '
    else begin
      P[I] := SP[J];
      Inc(J);
    end;
    Inc(I);
  end;
end;

procedure TOvcIntlSup.isMergeIntoPicture(Picture : PAnsiChar; Ch : AnsiChar;
                                       I : Integer);
  {-merge I into location in Picture indicated by format character Ch}
var
  Tmp  : string[MaxDateLen];
  TLen : Byte absolute Tmp;
  J    : Cardinal;
  K, L : Word;
  UCh, CPJ, CTI : AnsiChar;
  Done : Boolean;
begin
  {find the start of the subfield}
  UCh := UpCaseChar(Ch);
  if not StrChPos(Picture, Ch, J) then
    if not StrChPos(Picture, UCh, J) then
      Exit;

  {find the end of the subfield}
  K := J;
  while (J < StrLen(Picture)) and (UpCaseChar(Picture[J]) = UCh) do
    Inc(J);
  Dec(J);

  if (UCh = pmWeekDayU) or (UCh = pmMonthNameU) then begin
    if UCh = pmWeekDayU then
      case I of
        Ord(Sunday)..Ord(Saturday) :
          Tmp := FormatSettings.LongDayNames[I+1];
        else
          Tmp := '';
      end
    else
      case I of
        1..12 :
          Tmp := FormatSettings.LongMonthNames[I];
        else
          Tmp := '';
      end;
    K := Succ(J-K);
    if K > TLen then
      FillChar(Tmp[TLen+1], K-TLen, ' ');
    TLen := K;
  end else
    {convert I to a string}
    Str(I:MaxDateLen, Tmp);

  {now merge}
  L := TLen;
  Done := False;
  CPJ := Picture[J];

  while (UpCaseChar(CPJ) = UCh) and not Done do begin
    CTI := Tmp[L];
    if (UCh = pmMonthNameU) or (UCh = pmWeekDayU) then begin
      case CPJ of
        pmMonthNameU, pmWeekDayU :
          CTI := UpCaseChar(CTI);
      end;
    end
    {change spaces to 0's if desired}
    else if (CPJ >= 'a') and (CTI = ' ') then
      CTI := '0';
    Picture[J] := CTI;
    Done := (J = 0) or (L = 0);
    if not Done then begin
      Dec(J);
      Dec(L);
    end;
    CPJ := Picture[J];
  end;
end;

procedure TOvcIntlSup.isPackResult(Picture, S : PAnsiChar);
  {-remove unnecessary blanks from S}
var
  Temp : array[0..80] of AnsiChar;
  I, J : Integer;
begin
  FillChar(Temp, SizeOf(Temp), #0);
  I := 0;
  J := 0;
  while Picture[I] <> #0 do begin
    case Picture[I] of
      pmMonthU, pmDayU, pmMonthName, pmMonthNameU, pmWeekDay,
      pmWeekDayU, pmHourU, {pmMinU,} pmSecondU :
        if S[I] <> ' ' then begin
          Temp[J] := S[I];
          Inc(J);
        end;
      pmAmPm :
        if S[I] <> ' ' then begin
          Temp[J] := S[I];
          Inc(J);
        end
        else if (I > 0) and (Picture[I-1] = ' ') then begin
          Dec(J);
          Temp[J] := #0;
        end;
    else
      Temp[J] := S[I];
      Inc(J);
    end;
    Inc(I);
  end;

  StrCopy(S, Temp);
end;

procedure TOvcIntlSup.isSubstChar(Picture : PAnsiChar; OldCh, NewCh : AnsiChar);
  {-replace all instances of OldCh in Picture with NewCh}
var
  I : Byte;
  UpCh : AnsiChar;
  Temp : Cardinal;
begin
  UpCh := UpCaseChar(OldCh);
  if StrChPos(Picture, OldCh, Temp) or
     StrChPos(Picture, UpCh, Temp) then
    for I := 0 to StrLen(Picture)-1 do
      if UpCaseChar(Picture[I]) = UpCh then
        Picture[I] := NewCh;
end;

procedure TOvcIntlSup.isSubstCharSim(P : PAnsiChar; OC, NC : AnsiChar);
begin
  while P^ <> #0 do begin
    if P^ = OC then
      P^ := NC;
    Inc(P);
  end;
end;

function TOvcIntlSup.isTimeToTimeStringPrim(Dest, Picture : PAnsiChar;
                     T : TStTime; Pack : Boolean;
                     t1159, t2359 : PAnsiChar) : PAnsiChar;
  {-convert T to a string of the form indicated by Picture}
var
  I       : Word;
  Hours   : Byte;
  Minutes : Byte;
  Seconds : Byte;
  P       : PAnsiChar;
  TPos    : Cardinal;
  Found   : Boolean;
begin
  {merge the hours, minutes, and seconds into the picture}
  StTimeToHMS(T, Hours, Minutes, Seconds);
  StrCopy(Dest, Picture);

  P := nil;

  {check for TimeOnly}
  Found := StrChPos(Dest, pmAmPm, TPos);
  if Found then begin
    if (Hours >= 12) then
      P := t2359
    else
      P := t1159;
    if (t1159[0] <> #0) and (t2359[0] <> #0) then begin
      {adjust hours}
      case Hours of
        0      : Hours := 12;
        13..23 : Dec(Hours, 12);
      end;
    end;
  end;

  if T = BadTime then begin
    {map picture characters to spaces}
    isSubstChar(Dest, pmHour, ' ');
    isSubstChar(Dest, pmMinute, ' ');
    isSubstChar(Dest, pmSecond, ' ');
  end else begin
    {merge the numbers into the picture}
    isMergeIntoPicture(Dest, pmHour, Hours);
    isMergeIntoPicture(Dest, pmMinute, Minutes);
    isMergeIntoPicture(Dest, pmSecond, Seconds);
  end;

  {map colons}
  isSubstChar(Dest, pmTimeColon, wColonChar);

  {plug in AM/PM string if appropriate}
  if Found then begin
    if (t1159[0] = #0) and (t2359[0] = #0) then
      isSubstCharSim(@Dest[TPos], pmAmPm, ' ')
    else if (T = BadTime) and (t1159[0] = #0) then
      isSubstCharSim(@Dest[TPos], pmAmPm, ' ')
    else begin
      I := 0;
      while (Dest[TPos] = pmAmPm) and (P[I] <> #0) do begin
        Dest[TPos] := P[I];
        Inc(I);
        Inc(TPos);
      end;
    end;
  end;

  if Pack and (T <> BadTime) then
    isPackResult(Picture, Dest);

  Result := Dest;
end;

function TOvcIntlSup.MonthStringToMonth(const S : string; Width : Byte) : Byte;
  {-Convert the month name in MSt to a month (1..12)}
var
  I    : Word;
  Mt   : string[MaxDateLen];
  MLen : Byte absolute Mt;
  St   : string[MaxDateLen];
  SLen : Byte absolute St;
begin
  Result := 0;
  Mt := AnsiUpperCase(S);
  if Width > MLen then
    FillChar(Mt[MLen+1], Width-MLen, ' ');
  MLen := Width;

  for I := 1 to 12 do begin
    St := AnsiUpperCase(FormatSettings.LongMonthNames[I]);
    if Width > SLen then
      FillChar(St[SLen+1], Width-SLen, ' ');
    SLen := Width;
    if Mt = St then begin
      Result := I;
      Break;
    end;
  end;
end;

function TOvcIntlSup.MonthPCharToMonth(S : PAnsiChar; Width : Byte) : Byte;
  {-convert the month name in S to a month (1..12)}
var
  I    : Word;
  Mt   : string[MaxDateLen];
  MLen : Byte absolute Mt;
  St   : string[MaxDateLen];
  SLen : Byte absolute St;
begin
  Result := 0;
  Mt := AnsiUpperCase(StrPas(S));
  if Width > MLen then
    FillChar(Mt[MLen+1], Width-MLen, ' ');
  MLen := Width;

  for I := 1 to 12 do begin
    St := AnsiUpperCase(FormatSettings.LongMonthNames[I]);
    if Width > SLen then
      FillChar(St[SLen+1], Width-SLen, ' ');
    SLen := Width;
    if Mt = St then begin
      Result := I;
      Break;
    end;
  end;
end;

function TOvcIntlSup.MonthToString(Month : Integer) : string;
  {-return month name as a string for Month}
begin
  if (Month >= 1) and (Month <= 12) then
    Result := FormatSettings.LongMonthNames[Month]
  else
    Result := '';
end;

function TOvcIntlSup.MonthToPChar(Dest : PAnsiChar; Month : Integer) : PAnsiChar;
  {-return month name as a string for Month}
begin
  Result := Dest;
  if (Month >= 1) and (Month <= 12) then
    StrPCopy(Dest, FormatSettings.LongMonthNames[Month])
  else
    Dest[0] := #0;
end;

procedure TOvcIntlSup.ResetInternationalInfo;
  {-read Window's international information and string resources}
var
  S    : string;
  I    : Cardinal;
  Buf  : array[0..255] of AnsiChar;
  R    : TRegistry;

  procedure GetIntlString(S, Def, Buf : PAnsiChar; Size : Word);
  begin
    GetProfileString('intl', PWideChar(S), PWideChar(Def), PWideChar(Buf), Size);
  end;

  function GetIntlChar(S, Def : PAnsiChar) : AnsiChar;
  var
    B : array[0..5] of AnsiChar;
  begin
    GetIntlString(S, Def, B, SizeOf(B));
    Result := B[0];
    if (Result = #0) then
      Result := Def[0];
  end;

  procedure ExtractSubString(SubChar : AnsiChar; Dest : PAnsiChar);
  var
    I, Temp : Cardinal;
    L       : Word;
  begin
    FillChar(Dest^, SizeOf(wldSub1), 0);
    if not StrChPos(wLongDate, '''', I) then
      Exit;

    {delete the first quote}
    StrChDeletePrim(wLongDate, I);

    {assure that there is another quote}
    if not StrChPos(wLongDate, '''', Temp) then
      Exit;

    {copy substring into Dest, replace substring with SubChar}
    L := 0;
    while wLongDate[I] <> '''' do
      if L < SizeOf(wldSub1) then begin
        Dest[L] := wLongDate[I];
        Inc(L);
        wLongDate[I] := SubChar;
        Inc(I);
      end else
        StrChDeletePrim(wLongDate, I);

    {delete the second quote}
    StrChDeletePrim(wLongDate, I);
  end;

begin
  FDecimalChar     := GetIntlChar('sDecimal',
    @DefaultIntlData.DecimalChar);
  FCommaChar       := GetIntlChar('sThousand',
    @DefaultIntlData.CommaChar);
  FCurrencyDigits  := GetProfileInt('intl', 'iCurrDigits',
    DefaultIntlData.CurrDigits);
  if (FCommaChar = FDecimalChar) then begin
    FDecimalChar := DefaultIntlData.DecimalChar;
    FCommaChar := DefaultIntlData.CommaChar;
  end;
  wNegCurrencyForm := GetProfileInt('intl', 'iNegCurr', 0);
  FListChar        := GetIntlChar('sList', ',');

  GetIntlString('sCountry', '', Buf, SizeOf(Buf));
  wCountry := StrNew(Buf);

  GetIntlString('sCurrency', DefaultIntlData.CurrencyLtStr,
    FCurrencyLtStr, SizeOf(FCurrencyLtStr));
  StrCopy(FCurrencyRtStr, FCurrencyLtStr);

  wCurrencyForm := GetProfileInt('intl', 'iCurrency', 0);
  case wCurrencyForm of
    0 : {};
    1 : {};
    2 : StrCat(FCurrencyLtStr, ' ');
    3 : StrChInsertPrim(FCurrencyRtStr, ' ', 0);
  end;

  wTLZero := GetProfileInt('intl', 'iTLZero', 0) <> 0;
  w12Hour := FormatSettings.LongTimeFormat[Length(FormatSettings.LongTimeFormat)] = 'M';

  wColonChar := GetIntlChar('sTTime', ':');
  FSlashChar := GetIntlChar('sDate', @DefaultIntlData.SlashChar);
  GetIntlString('s1159', 'AM', w1159, SizeOf(w1159));
  GetIntlString('s2359', 'PM', w2359, SizeOf(w2359));

  {get short date mask and fix it up}
     R := TRegistry.Create;
     try
       R.RootKey := HKEY_CURRENT_USER;
       if R.OpenKey('Control Panel\International', False) then begin
         try
           if R.ValueExists('sShortDate') then
             StrPCopy(wShortDate, R.ReadString('sShortDate'))
           else
             GetIntlString('sShortDate', 'MM/dd/yy',
                            wShortDate, SizeOf(wShortDate));
         finally
           R.CloseKey;
         end;
       end else
         GetIntlString('sShortDate', 'MM/dd/yy',
                        wShortDate, SizeOf(wShortDate));
     finally
       R.Free;
     end;

  I := 0;
  while wShortDate[I] <> #0 do begin
    if wShortDate[I] = SlashChar then
      wShortDate[I] := '/';
    Inc(I);
  end;

  {get long date mask and fix it up}
  GetIntlString('sLongDate',  'dddd, MMMM dd, yyyy',
                wLongDate,  SizeOf(wLongDate));
  ExtractSubString(pmLongDateSub1, wldSub1);
  ExtractSubString(pmLongDateSub2, wldSub2);
  ExtractSubString(pmLongDateSub3, wldSub3);

  {replace ddd/dddd with www/wwww}
  if StrStPos(wLongDate, 'ddd', I) then
    while wLongDate[I] = 'd' do begin
      wLongDate[I] := 'w';
      Inc(I);
    end;

  {replace MMM/MMMM with nnn/nnnn}
  if StrStPos(wShortDate, 'MMM', I) then
    while wShortDate[I] = 'M' do begin
      wShortDate[I] := 'n';
      Inc(I);
    end;

  {replace MMM/MMMM with nnn/nnnn}
  if StrStPos(wLongDate, 'MMM', I) then
    while wLongDate[I] = 'M' do begin
      wLongDate[I] := 'n';
      Inc(I);
    end;

  {deal with oddities concerning . and ,}
  I := 0;
  while wLongDate[I] <> #0 do begin
    case wLongDate[I] of
      '.', ',' :
        if wLongDate[I+1] <> ' ' then begin
          StrChInsertPrim(wLongDate, ' ', I+1);
          Inc(I);
        end;
    end;
    Inc(I);
  end;

  {get Y/N and T/F values}
  S := GetOrphStr(SCYes);
  if Length(S) = 1 then
    YesChar := AnsiChar(s[1]);
  S := GetOrphStr(SCNo);
  if Length(S) = 1 then
    NoChar := AnsiChar(S[1]);
  S := GetOrphStr(SCTrue);
  if Length(S) = 1 then
    TrueChar := AnsiChar(S[1]);
  S := GetOrphStr(SCFalse);
  if Length(S) = 1 then
    FalseChar := AnsiChar(S[1]);
end;

procedure TOvcIntlSup.SetAutoUpdate(Value : Boolean);
  {-set the AutoUpdate option}
begin
  if Value <> FAutoUpdate then begin
    FAutoUpdate := Value;
    if FAutoUpdate then
      {allocate our window handle}
      {$IFDEF VERSION6}
        intlHandle := Classes.AllocateHWnd(isIntlWndProc)
      {$ELSE}
        intlHandle := AllocateHWnd(isIntlWndProc)
      {$ENDIF}
    else begin
      {deallocate our window handle}
      if intlHandle <> 0 then
        {$IFDEF VERSION6}
          Classes.DeallocateHWnd(intlHandle);
        {$ELSE}
          DeallocateHWnd(intlHandle);
        {$ENDIF}
      intlHandle := 0;
    end;
  end;
end;

procedure TOvcIntlSup.SetCurrencyLtStr(const Value : string);
begin
  StrPLCopy(FCurrencyLtStr, Value, SizeOf(FCurrencyLtStr)-1);
end;

procedure TOvcIntlSup.SetCurrencyRtStr(const Value : string);
begin
  StrPLCopy(FCurrencyRtStr, Value, SizeOf(FCurrencyRtStr)-1);
end;

function TOvcIntlSup.TimeStringToHMS(const Picture, S : string;
         var Hour, Minute, Second : Integer) : Boolean;
  {-extract Hours, Minutes, Seconds from St, returning true if string is valid}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  StrPCopy(Buf2, S);
  Result := TimePCharToHMS(Buf1, Buf2, Hour, Minute, Second);
end;

function TOvcIntlSup.TimePCharToHMS(Picture, S : PAnsiChar;
         var Hour, Minute, Second : Integer) : Boolean;
  {-extract Hours, Minutes, Seconds from St, returning true if string is valid}
var
  I, J  : Cardinal;
  Tmp,
  t1159,
  t2359 : array[0..20] of AnsiChar;
begin
  Result := False;
  if StrLen(Picture) <> StrLen(S) then
    Exit;

  {extract hours, minutes, seconds from St}
  isExtractFromPicture(Picture, S, pmHour, Hour, -1, 0);
  isExtractFromPicture(Picture, S, pmMinute,  Minute, -1, 0);
  isExtractFromPicture(Picture, S, pmSecond,  Second, -1, 0);
  if (Hour = -1) or (Minute = -1) or (Second = -1) then begin
    Result := False;
    Exit;
  end;

  {check for TimeOnly}
  if StrChPos(Picture, pmAmPm, I) and (w1159[0] <> #0)
    and (w2359[0] <> #0) then begin
    Tmp[0] := #0;
    J := 0;
    while Picture[I] = pmAmPm do begin
      Tmp[J] := S[I];
      Inc(J);
      Inc(I);
    end;
    Tmp[J] := #0;
    TrimTrailPrimPChar(Tmp);

    StrCopy(t1159, w1159);
    t1159[J] := #0;
    StrCopy(t2359, w2359);
    t2359[J] := #0;

    if (Tmp[0] = #0) then
      Hour := -1
    else if StrIComp(Tmp, t2359) = 0 then begin
      if (Hour < 12) then
        Inc(Hour, 12)
      else if (Hour = 0) or (Hour > 12) then
        {force BadTime}
        Hour := -1;
    end else if StrIComp(Tmp, t1159) = 0 then begin
      if Hour = 12 then
        Hour := 0
      else if (Hour = 0) or (Hour > 12) then
        {force BadTime}
        Hour := -1;
    end else
      {force BadTime}
      Hour := -1;
  end;

  Result := ValidTime(Hour, Minute, Second);
end;

function TOvcIntlSup.TimeToAmPmString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  {-convert T to a string of the form indicated by Picture. Times are always displayed in am/pm format.}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  Result := StrPas(TimeToAmPmPChar(Buf2, Buf1, T, Pack));
end;

function TOvcIntlSup.TimeToAmPmPChar(Dest : PAnsiChar; Picture : PAnsiChar; T : TStTime; Pack : Boolean) : PAnsiChar;
  {-convert T to a string of the form indicated by Picture. Times are always displayed in am/pm format.}
const
  t1159 = 'AM'#0;
  t2359 = 'PM'#0;
var
  PLen : Byte;
  Temp : Cardinal;
begin
  Move(Picture[0], Dest[0], StrLen(Picture)+1);
  if not StrChPos(Dest, pmAmPm, Temp) then begin
    PLen := StrLen(Dest);
    Dest[PLen] := pmAmPm;
    Dest[PLen+1] := #0;
  end;
  Result := isTimeToTimeStringPrim(Dest, Dest, T, Pack, t1159, t2359);
end;

function TOvcIntlSup.TimeStringToTime(const Picture, S : string) : TStTime;
  {-convert S, a string of the form indicated by Picture, to a Time variable}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  StrPCopy(Buf2, S);
  Result := TimePCharToTime(Buf1, Buf2);
end;

function TOvcIntlSup.TimePCharToTime(Picture, S : PAnsiChar) : TStTime;
  {-convert S, a string of the form indicated by Picture, to a Time variable}
var
  Hours, Minutes, Seconds : Integer;
begin
  if TimePCharToHMS(Picture, S, Hours, Minutes, Seconds) then
    Result := HMStoStTime(Hours, Minutes, Seconds)
  else
    Result := BadTime;
end;

function TOvcIntlSup.TimeToTimeString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  {-convert T to a string of the form indicated by Picture}
var
  Buf1 : array[0..255] of AnsiChar;
  Buf2 : array[0..255] of AnsiChar;
begin
  StrPCopy(Buf1, Picture);
  Result := StrPas(TimeToTimePChar(Buf2, Buf1, T, Pack));
end;

function TOvcIntlSup.TimeToTimePChar(Dest : PAnsiChar; Picture : PAnsiChar; T : TStTime; Pack : Boolean) : PAnsiChar;
  {-convert T to a string of the form indicated by Picture}
begin
  Result := isTimeToTimeStringPrim(Dest, Picture, T, Pack, w1159, w2359);
end;

procedure DestroyGlobalIntlSup; far;
begin
  OvcIntlSup.Free;
end;


initialization
  {create instance of default user data class}
  OvcIntlSup := TOvcIntlSup.Create;

finalization
  DestroyGlobalIntlSup;
end.

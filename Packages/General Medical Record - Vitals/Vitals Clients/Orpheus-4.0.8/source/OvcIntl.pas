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
{*    Roman Kassebaum                                                         *}
{*    Armin Biernaczyk                                                        *}
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
  TCurrencySt = array[0..5] of Char;

  

  TIntlData = packed record
    {substitution strings for semi-literal mask characters}
    CurrencyLtStr : TCurrencySt; {corresponding string for 'c'}
    CurrencyRtStr : TCurrencySt; {corresponding string for 'C'}
    DecimalChar   : Char;    {character used for decimal point}
    CommaChar     : Char;    {character used for comma}
    {format specifiers for currency masks}
    CurrDigits    : Byte;        {number of dec places in currency}
    SlashChar     : Char;    {date seperator}
    {characters that represent boolean values}
    TrueChar      : Char;
    FalseChar     : Char;
    YesChar       : Char;
    NoChar        : Char;
  end;


type
  TOvcIntlSup = class(TObject)
  

  protected {private}
    FAutoUpdate      : Boolean;     {true to reset settings when win.ini changes}

    {substitution strings for semi-literal mask characters}
    FCurrencyLtStr   : TCurrencySt; {corresponding string for 'c'}
    FCurrencyRtStr   : TCurrencySt; {corresponding string for 'C'}
    FDecimalChar     : Char;    {character used for decimal point}

    {general international settings}
    FCommaChar       : Char;    {character used for comma}
    FCurrencyDigits  : Byte;        {number of dec places in currency}
    FListChar        : Char;    {list serarater}
    FSlashChar       : Char;    {character used to separate dates}

    {characters that represent boolean values}
    FTrueChar        : Char;
    FFalseChar       : Char;
    FYesChar         : Char;
    FNoChar          : Char;

    {event variables}
    FOnWinIniChange  : TNotifyEvent; {notify of win.ini changes}

    {internal working variables}
    intlHandle       : hWnd;  {our window handle}
    w1159            : string; //array[0..5] of Char;
    w2359            : string; //array[0..5] of Char;
    wColonChar       : Char;
    wCountry         : string;
    wCurrencyForm    : Byte;
    wldSub1          : array[0..5] of Char;
    wldSub2          : array[0..5] of Char;
    wldSub3          : array[0..5] of Char;
    wLongDate        : array[0..39] of Char;
    wNegCurrencyForm : Byte;
    wShortDate       : array[0..29] of Char;
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
    procedure isExtractFromPictureEx(Picture, S : PChar; Ch : Char;
              var I : Integer; Blank, Default : Integer; ExCh : Char);
    procedure isExtractFromPicture(Picture, S : PChar; Ch : Char;
              var I : Integer; Blank, Default : Integer);
    procedure isIntlWndProc(var Msg : TMessage);
    function isMaskCharCount(P : PChar; MC : Char) : Word;
    procedure isMergeIntoPictureEx(Picture : PChar; Ch : Char; I : Integer; ExCh : Char);
    procedure isMergeIntoPicture(Picture : PChar; Ch : Char; I : Integer);
    procedure isMergePictureSt(Picture, P : PChar; MC : Char; SP : PChar);
    procedure isPackResult(Picture, S : PChar);
    procedure isSubstChar(Picture : PChar; OldCh, NewCh : Char);
    procedure isSubstCharSim(P : PChar; OC, NC : Char);
    function isTimeToTimeStringPrim(Dest, Picture : PChar; T : TStTime;
             Pack : Boolean; t1159, t2359 : PChar) : PChar;

  public
    constructor Create;
    destructor Destroy;
      override;


    function CurrentDateString(const Picture : string;
      Pack : Boolean) : string;
  

    function CurrentDatePChar(Dest : PChar; Picture : PChar;
      Pack : Boolean) : PChar;
      {-returns today's date as a string of the specified form}


    function CurrentTimeString(const Picture : string; Pack : Boolean) : string;
  

    function CurrentTimePChar(Dest : PChar; Picture : PChar; Pack : Boolean) : PChar;
      {-returns current time as a string of the specified form}


    function DateToDateString(const Picture : string; Julian : TStDate;
      Pack : Boolean) : string;
  

    function DateToDatePChar(Dest : PChar; Picture : PChar; Julian : TStDate;
      Pack : Boolean) : PChar;

      {-convert Julian to a string of the form indicated by Picture}
    function DateTimeToDatePChar(Dest : PChar; Picture : PChar;
      DT : TDateTime; Pack : Boolean) : PChar;

    function DateStringToDMY(const Picture, S : string; var Day, Month, Year : Integer;
      Epoch : Integer) : Boolean;
  

    function DatePCharToDMY(Picture, S : PChar; var Day, Month, Year : Integer;
      Epoch : Integer) : Boolean;

      {-extract day, month, and year from S, returning true if string is valid}

    function DateStringIsBlank(const Picture, S : string) : Boolean;
  

    function DatePCharIsBlank(Picture, S : PChar) : Boolean;

      {-return True if the month, day, and year in S are all blank}

    function DateStringToDate(const Picture, S : string; Epoch : Integer) : TStDate;
  

    function DatePCharToDate(Picture, S : PChar; Epoch : Integer) : TStDate;

      {-convert St, a string of the form indicated by Picture, to a julian date. Picture and St must be of equal lengths}

    function DayOfWeekToString(WeekDay : TDayType) : string;
  

    function DayOfWeekToPChar(Dest : PChar; WeekDay : TDayType) : PChar;

      {-return a string for the specified day of the week}

    function DMYtoDateString(const Picture : string;
      Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : string;
  

    function DMYtoDatePChar(Dest : PChar; Picture : PChar;
      Day, Month, Year : Integer; Pack : Boolean; Epoch : Integer) : PChar;

      {-merge the month, day, and year into the picture}

    function InternationalCurrency(FormChar : Char; MaxDigits : Byte; Float,
                                   AddCommas, IsNumeric : Boolean) : string;
  

    function InternationalCurrencyPChar(Dest : PChar; FormChar : Char;
                                        MaxDigits : Byte; Float,
                                        AddCommas, IsNumeric : Boolean) : PChar;

      {-return a picture mask for a currency string, based on Windows' intl info}

    function InternationalDate(ForceCentury : Boolean) : string;
  

    function InternationalDatePChar(Dest : PChar; ForceCentury : Boolean) : PChar;

      {-return a picture mask for a short date string, based on Windows' international information}

    function InternationalLongDate(ShortNames : Boolean; ExcludeDOW : Boolean) : string;
  

    function InternationalLongDatePChar(Dest : PChar; ShortNames : Boolean; ExcludeDOW : Boolean) : PChar;

      {-return a picture mask for a date string, based on Windows' international information}

    function InternationalTime(ShowSeconds : Boolean) : string;
  

    function InternationalTimePChar(Dest : PChar; ShowSeconds : Boolean) : PChar;

      {-return a picture mask for a time string, based on Windows' international information}

    function MonthStringToMonth(const S : string; Width : Byte) : Byte;
  

    function MonthPCharToMonth(S : PChar; Width : Byte) : Byte;

      {-Convert the month name in S to a month (1..12)}

    function MonthToString(Month : Integer) : string;
  

    function MonthToPChar(Dest : PChar; Month : Integer) : PChar;

      {return month name as a string for Month}

    procedure ResetInternationalInfo;
      {-read string resources and update internal info to match Windows'}

    function TimeStringToHMS(const Picture, S : string; var Hour, Minute, Second : Integer) : Boolean;
  

    function TimePCharToHMS(Picture, S : PChar; var Hour, Minute, Second : Integer) : Boolean;

      {-extract Hours, Minutes, Seconds from St, returning true if string is valid}

    function TimeStringToTime(const Picture, S : string) : TStTime;
  

    function TimePCharToTime(Picture, S : PChar) : TStTime;

      {-convert S, a string of the form indicated by Picture, to a Time variable}

    function TimeToTimeString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  

    function TimeToTimePChar(Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar;

      {-convert T to a string of the form indicated by Picture}

    function TimeToAmPmString(const Picture : string; T : TStTime; Pack : Boolean) : string;
  

    function TimeToAmPmPChar(Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar;

      {-convert T to a string of the form indicated by Picture. Times are always displayed in am/pm format.}

    property AutoUpdate : Boolean
      read FAutoUpdate write SetAutoUpdate;
    property CurrencyLtStr : string
      read GetCurrencyLtStr write SetCurrencyLtStr;
    property CurrencyRtStr : string
      read GetCurrencyRtStr write SetCurrencyRtStr;
    property DecimalChar : Char
      read FDecimalChar write FDecimalChar;
    property CommaChar : Char
      read FCommaChar write FCommaChar;
    property Country : string
      read GetCountry;
    property CurrencyDigits : Byte
      read FCurrencyDigits write FCurrencyDigits;
    property ListChar : Char
      read FListChar write FListChar;
    property SlashChar : Char
      read FSlashChar write FSlashChar;
    property TrueChar : Char
      read FTrueChar write FTrueChar;
    property FalseChar : Char
      read FFalseChar write FFalseChar;
    property YesChar : Char
      read FYesChar write FYesChar;
    property NoChar  : Char
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

uses
  StrUtils, OvcFormatSettings;

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

function TOvcIntlSup.CurrentDatePChar(Dest : PChar; Picture : PChar;
  Pack : Boolean) : PChar;
  {-returns today's date as a string of the specified form}
begin
  Result := DateToDatePChar(Dest, Picture, CurrentDate, Pack);
end;

function TOvcIntlSup.CurrentTimeString(const Picture : string; Pack : Boolean) : string;
  {-returns current time as a string of the specified form}
begin
  Result := TimeToTimeString(Picture, CurrentTime, Pack);
end;

function TOvcIntlSup.CurrentTimePChar(Dest : PChar; Picture : PChar; Pack : Boolean) : PChar;
  {-returns current time as a string of the specified form}
begin
  Result := TimeToTimePChar(Dest, Picture, CurrentTime, Pack);
end;

function TOvcIntlSup.DateStringIsBlank(const Picture, S : string) : Boolean;
  {-return True if the month, day, and year in S are all blank}
var
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  StrPLCopy(Buf2, S, Length(Buf2) - 1);
  Result := DatePCharIsBlank(Buf1, Buf2);
end;

function TOvcIntlSup.DatePCharIsBlank(Picture, S : PChar) : Boolean;
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  StrPLCopy(Buf2, S, Length(Buf2) - 1);
  Result := DatePCharToDate(Buf1, Buf2, Epoch);
end;

function TOvcIntlSup.DatePCharToDate(Picture, S : PChar; Epoch : Integer) : TStDate;
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  StrPLCopy(Buf2, S, Length(Buf2) - 1);
  Result := DatePCharToDMY(Buf1, Buf2, Day, Month, Year, Epoch);
end;

function TOvcIntlSup.DatePCharToDMY(Picture, S : PChar; var Day, Month, Year : Integer;
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  Result := StrPas(DateToDatePChar(Buf2, Buf1, Julian, Pack));
end;

function TOvcIntlSup.DateToDatePChar(Dest : PChar; Picture : PChar;
         Julian : TStDate; Pack : Boolean) : PChar;
  {-convert Julian to a string of the form indicated by Picture}
var
  Month, Day, Year : Integer;
begin
  Move(Picture[0], Dest[0], (StrLen(Picture)+1) * SizeOf(Char));
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

function TOvcIntlSup.DateTimeToDatePChar(Dest : PChar; Picture : PChar;
         DT : TDateTime; Pack : Boolean) : PChar;
  {-convert DateTime to a string of the form indicated by Picture}
begin
  Move(Picture[0], Dest[0], (StrLen(Picture)+1) * SizeOf(Char));
  TimeToTimePChar(Dest, Picture, DateTimeToStTime(DT), False);
  result := DateToDatePChar(Dest, Dest, DateTimeToStDate(DT), Pack);
end;

function TOvcIntlSup.DayOfWeekToString(WeekDay : TDayType) : string;
  {-return the day of the week specified by WeekDay as a string. Will
    honor the international names as specified in the INI file.}
begin
  Result := FormatSettings.LongDayNames[Ord(WeekDay)+1];
end;

function TOvcIntlSup.DayOfWeekToPChar(Dest : PChar; WeekDay : TDayType) : PChar;
  {-return the day of the week specified by WeekDay as a string in Dest. Will
    honor the international names as specified in the INI file.}
begin
  Result := Dest;
  StrPCopy(Dest, FormatSettings.LongDayNames[Ord(WeekDay)+1]);
end;

destructor TOvcIntlSup.Destroy;
begin
  if intlHandle <> 0 then
    Classes.DeallocateHWnd(intlHandle);
  inherited Destroy;
end;

function TOvcIntlSup.DMYtoDateString(const Picture : string; Day, Month,
         Year : Integer; Pack : Boolean; Epoch : Integer) : string;
  {-merge the month, day, and year into the picture}
var
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  Result := StrPas(DMYtoDatePChar(Buf2, Buf1, Day, Month, Year, Pack, Epoch));
end;

function TOvcIntlSup.DMYtoDatePChar(Dest : PChar; Picture : PChar; Day, Month,
         Year : Integer; Pack : Boolean; Epoch : Integer) : PChar;
  {-merge the month, day, and year into the picture}
var
  DOW       : Integer;
  EpochCent : Integer;
begin
  Move(Picture[0], Dest[0], (StrLen(Picture)+1) * SizeOf(Char));

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
  Result := wCountry;
end;

function TOvcIntlSup.GetCurrencyLtStr : string;
begin
  Result := StrPas(FCurrencyLtStr);
end;

function TOvcIntlSup.GetCurrencyRtStr : string;
begin
  Result := StrPas(FCurrencyRtStr);
end;

function TOvcIntlSup.InternationalCurrency(FormChar : Char; MaxDigits : Byte; Float,
         AddCommas, IsNumeric : Boolean) : string;
  {-Return a picture mask for a currency string, based on Windows' intl info}
var
  Buf1 : array[0..255] of Char;
begin
  Result := StrPas(InternationalCurrencyPChar(Buf1, FormChar, MaxDigits,
            Float, AddCommas, IsNumeric));
end;

function TOvcIntlSup.InternationalCurrencyPChar(Dest : PChar; FormChar : Char;
         MaxDigits : Byte; Float, AddCommas, IsNumeric : Boolean) : PChar;
  {-Return a picture mask for a currency string, based on Windows' intl info}
const
  NP : array[0..1] of Char = pmNegParens+#0;
  NH : array[0..1] of Char = pmNegHere+#0;
var
  CLSlen, DLen, I, J : Word;
  Tmp : array[0..10] of Char;
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
  StrPCopy(Dest, StringOfChar(FormChar, DLen)); //SZ FillChar(Dest[0], DLen * SizeOf(Char), FormChar);
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
    StrPCopy(Dest + DLen + 1, StringOfChar(FormChar, CurrencyDigits)); //SZ  FillChar(Dest[DLen+1], CurrencyDigits * SizeOf(Char), FormChar);
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
  Buf : array[0..255] of Char;
begin
  InternationalDatePChar(Buf, ForceCentury);
  Result := StrPas(Buf);
end;

function TOvcIntlSup.InternationalDatePChar(Dest : PChar;
                                            ForceCentury : Boolean) : PChar;
  {-return a picture mask for a date string, based on Windows' int'l info}


  procedure FixMask(MC : Char; DL : Integer);
  var
    I     : Cardinal;
    J, AL : Word;
    MCT   : Char;
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
  Buf : array[0..255] of Char;
begin
  Result := StrPas(InternationalLongDatePChar(Buf, ShortNames, ExcludeDOW));
end;

function TOvcIntlSup.InternationalLongDatePChar(Dest : PChar; ShortNames : Boolean;
         ExcludeDOW : Boolean) : PChar;
  {-return a picture mask for a date string, based on Windows' int'l info}
var
  I    : Cardinal;
  WC   : Word;
  Temp : array[0..80] of Char;
  Stop : Boolean;

  function LongestMonthName : Word;
  var
    L, I : Word;
  begin
    Result := 0;
    for I := 1 to 12 do begin
      L := Length(FormatSettings.LongMonthNames[I]);
      if L>Result then Result := L;
    end;
  end;

  function LongestDayName : Word;
  var
    L: Word;
    D : TDayType;
  begin
    Result := 0;
    for D := Sunday to Saturday do begin
      L := Length(FormatSettings.LongDayNames[Ord(D)+1]);
      if L>Result then Result := L;
    end;
  end;

  procedure FixMask(MC : Char; DL : Integer);
  var
    I     : Cardinal;
    J, AL : Word;
    MCT   : Char;
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
  Buf : array[0..255] of Char;
begin
  Result := StrPas(InternationalTimePChar(Buf, ShowSeconds));
end;

function TOvcIntlSup.InternationalTimePChar(Dest : PChar; ShowSeconds : Boolean) : PChar;
  {-return a picture mask for a time string, based on Windows' int'l info}
var
  SL, ML : Word;
  S : array[0..20] of Char;
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
    if Length(w1159)>Length(w2359) then ML := Length(w1159) else ML := Length(w2359);
    if (ML <> 0) then begin
      SL := StrLen(S);
      S[SL] := ' ';
	  StrPCopy(S + SL + 1, StringOfChar(pmAmPm, ML));  //R.K. FillChar(S[SL+1], ML, pmAmPm);
	  
      //R.K. S[SL+ML+1] := #0; Not necessary cause of the StrCopy
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

procedure TOvcIntlSup.isExtractFromPictureEx(Picture, S : PChar;
                             Ch : Char; var I : Integer;
                             Blank, Default : Integer; ExCh : Char);
  {-extract the value of the subfield specified by Ch from S and return in
    I. I will be set to -1 in case of an error, Blank if the subfield exists
    in Picture but is empty, Default if the subfield doesn't exist in
    Picture.

   -Changes:
    03/2011 AB: new parameter to support distinguishing Month and Minutes in picture-masks }
var
  PTmp    : Array[0..20] of Char;
  J, K, W : Cardinal;
  Code    : Integer;
  Found,
  UpFound : Boolean;
begin
  {find the start of the subfield}
  I := Default;
  J := 0;
  while (Picture[J]<>#0) and
        ((Picture[J]<>Ch) or ((J>0) and ((Picture[J-1]=ExCh) or (Picture[J-1]=Ch)))) do
    Inc(J);
  Found := Picture[J]=Ch;
  Ch := UpCaseChar(Ch);
  K := 0;
  while (Picture[K]<>#0) and
        ((Picture[K]<>Ch) or ((K>0) and ((Picture[K-1]=ExCh) or (Picture[K-1]=Ch)))) do
    Inc(K);
  UpFound := Picture[K]=Ch;

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


procedure TOvcIntlSup.isExtractFromPicture(Picture, S : PChar;
                             Ch : Char; var I : Integer;
                             Blank, Default : Integer);
begin
  isExtractFromPictureEx(Picture, S, Ch, I, Blank, Default, #0);
end;

function TOvcIntlSup.isMaskCharCount(P : PChar; MC : Char) : Word;
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

procedure TOvcIntlSup.isMergePictureSt(Picture, P : PChar; MC : Char; SP : PChar);
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


procedure TOvcIntlSup.isMergeIntoPictureEx(Picture : PChar; Ch : Char; I : Integer; ExCh : Char);
  {-merge I into location in Picture indicated by format character Ch

   -Changes:
    3/2011 AB: Bugfixes and code-sanitization }
var
  UCh          : Char;
  J, L, K, PLen: Cardinal;
  Tmp          : string;
begin
  {find the start 'J' of the subfield;
   this is the index of the first occurance of 'Ch' in 'Picture' given that the character
   before this subfield is different from 'ExCh'. If there is no such subfield the search
   is repeated for 'UCh'
   'ExCh' is used to distinguish subfields for month an minutes, see 'DateTimeToDatePChar'}
  UCh := UpCaseChar(Ch);
  J := 0;
  while (Picture[J]<>#0) and
        ((Picture[J]<>Ch) or ((J>0) and ((Picture[J-1]=ExCh) or (Picture[J-1]=Ch)))) do
    Inc(J);
  if Picture[J]=#0 then begin
    J := 0;
    while (Picture[J]<>#0) and
          ((Picture[J]<>UCh) or ((J>0) and ((Picture[J-1]=ExCh) or (Picture[J-1]=UCh)))) do
      Inc(J);
  end;
  if Picture[J]=#0 then Exit;

  {find the length 'L' of the subfield}
  L := 1;
  PLen := StrLen(Picture);
  while (J+L < PLen) and (UpCaseChar(Picture[J+L]) = UCh) do
    Inc(L);

  {find the string 'Tmp' that correnponds to I}
  if UCh = pmWeekDayU then begin
    if (I<Ord(Sunday)) or (I>Ord(Saturday)) then
      Tmp := ''
    else if L<=Cardinal(Length(FormatSettings.ShortDayNames[I+1])) then
      Tmp := FormatSettings.ShortDayNames[I+1]
    else
      Tmp := FormatSettings.LongDayNames[I+1];
  end else if UCh = pmMonthNameU then begin
    if (I<1) or (I>12) then
      Tmp := ''
    else if L<=Cardinal(Length(FormatSettings.ShortMonthNames[I])) then
      Tmp := FormatSettings.ShortMonthNames[I]
    else
      Tmp := FormatSettings.LongMonthNames[I];
  end else begin
    Tmp := Format('%*d',[L,I]);
    { DMYtoDateString('yy', 1, 1, 2012, False, 0) should return '12' (not '20), so we
      have to use the last digits of 'Tmp' in case Length(Tmp)>L. }
    if Cardinal(Length(Tmp))>L then Delete(Tmp,1,Cardinal(Length(Tmp))-L);
  end;

  {adjust length of 'Tmp' to length of the subfield}
  Tmp := Format('%-*.*s',[L,L,Tmp]);

  {now merge}
  for K := 0 to L-1 do begin
    if (Picture[J+K]=pmMonthNameU) or (Picture[J+K]=pmWeekDayU) then
      Picture[J+K] := UpCaseChar(Tmp[K+1])
    else if (Picture[J+K]<>pmMonthName) and (Picture[J+K]<>pmWeekDay) and
            (Picture[J+K] >= 'a') and (Tmp[K+1] = ' ') then
      Picture[J+K] := '0'
    else
      Picture[J+K] := Tmp[K+1];
  end;
end;


procedure TOvcIntlSup.isMergeIntoPicture(Picture : PChar; Ch : Char; I : Integer);
begin
  isMergeIntoPictureEx(Picture, Ch, I, #0);
end;


procedure TOvcIntlSup.isPackResult(Picture, S : PChar);
  {-remove unnecessary blanks from S}
var
  Temp : array[0..80] of Char;
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

procedure TOvcIntlSup.isSubstChar(Picture : PChar; OldCh, NewCh : Char);
  {-replace all instances of OldCh in Picture with NewCh}
var
  I : Byte;
  UpCh : Char;
  Temp : Cardinal;
begin
  UpCh := UpCaseChar(OldCh);
  if StrChPos(Picture, OldCh, Temp) or
     StrChPos(Picture, UpCh, Temp) then
    for I := 0 to StrLen(Picture)-1 do
      if UpCaseChar(Picture[I]) = UpCh then
        Picture[I] := NewCh;
end;

procedure TOvcIntlSup.isSubstCharSim(P : PChar; OC, NC : Char);
begin
  while P^ <> #0 do begin
    if P^ = OC then
      P^ := NC;
    Inc(P);
  end;
end;

function TOvcIntlSup.isTimeToTimeStringPrim(Dest, Picture : PChar;
                     T : TStTime; Pack : Boolean;
                     t1159, t2359 : PChar) : PChar;
  {-convert T to a string of the form indicated by Picture}
var
  I       : Word;
  Hours   : Byte;
  Minutes : Byte;
  Seconds : Byte;
  P       : PChar;
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
    isMergeIntoPictureEx(Dest, pmMinute, Minutes, pmDateSlash);
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
  {-Convert the month name in 'S' to a month (1..12)

   -Changes:
    03/2011 AB: This function should only compare the first 'Widht' characters; the
            new implementation ignored this. This caused trouble in OvcPictureFields with
            Mask='dd nnn yyyy' and DataType=pftDate as '01 Jan 2000' was not recognised as
            a valid date. }
var
  ps: string;
begin
  ps := Format('%*.*s',[Width,Width,S]);
  result := 12;
  while (result>0) and
        (CompareText(ps, Format('%*.*s',[Width,Width,
                                         FormatSettings.LongMonthNames[result]]))<>0) and
        (CompareText(ps, Format('%*.*s',[Width,Width,
                                         FormatSettings.ShortMonthNames[result]]))<>0) do
    Dec(result);
end;


function TOvcIntlSup.MonthPCharToMonth(S : PChar; Width : Byte) : Byte;
  {-convert the month name in S to a month (1..12)

   -Changes:
    03/2011 AB: Simply use MonthStringToMonth }
begin
  result := MonthStringToMonth(StrPas(S), Width);
end;


function TOvcIntlSup.MonthToString(Month : Integer) : string;
  {-return month name as a string for Month}
begin
  if (Month >= 1) and (Month <= 12) then
    Result := FormatSettings.LongMonthNames[Month]
  else
    Result := '';
end;

function TOvcIntlSup.MonthToPChar(Dest : PChar; Month : Integer) : PChar;
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
  //Buf  : array[0..255] of Char;
  //R    : TRegistry;

  //SZ these were fine for 16 bit code...
  {procedure GetIntlString(S, Def, Buf : PChar; Size : Word);
  begin
    GetProfileString('intl', S, Def, Buf, Size);
  end;

  function GetIntlChar(S, Def : PChar) : Char;
  var
    B : array[0..5] of Char;
  begin
    GetIntlString(S, Def, B, SizeOf(B));
    Result := B[0];
    if (Result = #0) then
      Result := Def[0];
  end; }

  procedure ExtractSubString(SubChar : Char; Dest : PChar);
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

  function GetLocaleChar(lcType: Cardinal; Default: Char): Char;
  var
    Len: Integer;
    S: string;
  begin
    Result := Default;
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, nil, 0);
    if Len = 0 then
      Exit;
    SetLength(S, Len);
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, PChar(S), Length(S));
    S := Copy(S, 1, Len - 1);
    if Length(S) = 1 then
      Result := S[1];
    //SZ Note: DecimalChar, ... could be more than 1 char; use default in that case for now
  end;

  function GetLocaleString(lcType: Cardinal; Default: string): string;
  var
    Len: Integer;
    S: string;
  begin
    Result := Default;
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, nil, 0);
    if Len = 0 then
      Exit;
    SetLength(S, Len);
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, PChar(S), Length(S));
    S := Copy(S, 1, Len - 1);
    Result := Trim(S);
  end;

  function GetLocaleInt(lcType: Cardinal; Default: Integer): Integer;
  var
    Len: Integer;
    S: string;
  begin
    Result := Default;
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, nil, 0);
    if Len = 0 then
      Exit;
    SetLength(S, Len);
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, PChar(S), Length(S));
    S := Copy(S, 1, Len - 1);
    Result := StrToIntDef(S, Default);
  end;

begin
  FDecimalChar     := GetLocaleChar(LOCALE_SDECIMAL, DefaultIntlData.DecimalChar); // GetIntlChar('sDecimal', @DefaultIntlData.DecimalChar);
  FCommaChar       := GetLocaleChar(LOCALE_STHOUSAND, DefaultIntlData.CommaChar); // GetIntlChar('sThousand', @DefaultIntlData.CommaChar);
  FCurrencyDigits  := GetLocaleInt(LOCALE_ICURRDIGITS, DefaultIntlData.CurrDigits);  // GetProfileInt('intl', 'iCurrDigits', DefaultIntlData.CurrDigits);
  if (FCommaChar = FDecimalChar) then begin
    FDecimalChar := DefaultIntlData.DecimalChar;
    FCommaChar := DefaultIntlData.CommaChar;
  end;
  wNegCurrencyForm := GetLocaleInt(LOCALE_INEGCURR, 0); //  GetProfileInt('intl', 'iNegCurr', 0);
  FListChar        := GetLocaleChar(LOCALE_SLIST,','); // GetIntlChar('sList', ',');

//  GetIntlString('sCountry', '', Buf, SizeOf(Buf));
//  wCountry := StrNew(Buf);
  wCountry := GetLocaleString(LOCALE_SCOUNTRY, '');

//  GetIntlString('sCurrency', DefaultIntlData.CurrencyLtStr,
//    FCurrencyLtStr, SizeOf(FCurrencyLtStr));
  StrPCopy(FCurrencyLtStr, GetLocaleString(LOCALE_SCURRENCY, DefaultIntlData.CurrencyLtStr));
  StrCopy(FCurrencyRtStr, FCurrencyLtStr);

  wCurrencyForm := GetLocaleInt(LOCALE_ICURRENCY, 0); //wCurrencyForm := GetProfileInt('intl', 'iCurrency', 0);
  case wCurrencyForm of
    0 : {};
    1 : {};
    2 : StrCat(FCurrencyLtStr, ' ');
    3 : StrChInsertPrim(FCurrencyRtStr, ' ', 0);
  end;

  wTLZero := GetLocaleInt(LOCALE_ITLZERO, 0) <> 0; //  wTLZero := GetProfileInt('intl', 'iTLZero', 0) <> 0;
  w12Hour := FormatSettings.LongTimeFormat[Length(FormatSettings.LongTimeFormat)] = 'M';

  wColonChar := GetLocaleChar(LOCALE_STIME, ':'); // wColonChar := GetIntlChar('sTTime', ':');
  FSlashChar := GetLocaleChar(LOCALE_SDATE, DefaultIntlData.SlashChar); // FSlashChar := GetIntlChar('sDate', @DefaultIntlData.SlashChar);
  w1159 := GetLocaleString(LOCALE_S1159, 'AM'); // GetIntlString('s1159', 'AM', w1159, SizeOf(w1159));
  w2359 := GetLocaleString(LOCALE_S2359, 'PM'); // GetIntlString('s2359', 'PM', w2359, SizeOf(w2359));

  {get short date mask and fix it up}
 {    R := TRegistry.Create;
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
     end;  }
  StrPLCopy(wShortDate, GetLocaleString(LOCALE_SSHORTDATE, 'MM/dd/yy'), Length(wShortDate) - 1);

  I := 0;
  while wShortDate[I] <> #0 do begin
    if wShortDate[I] = SlashChar then
      wShortDate[I] := '/';
    Inc(I);
  end;

  {get long date mask and fix it up}
  StrPLCopy(wLongDate, GetLocaleString(LOCALE_SLONGDATE, 'dddd, MMMM dd, yyyy'), Length(wLongDate) - 1); // GetIntlString('sLongDate',  'dddd, MMMM dd, yyyy', wLongDate,  SizeOf(wLongDate));
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
    YesChar := S[1];
  S := GetOrphStr(SCNo);
  if Length(S) = 1 then
    NoChar := S[1];
  S := GetOrphStr(SCTrue);
  if Length(S) = 1 then
    TrueChar := S[1];
  S := GetOrphStr(SCFalse);
  if Length(S) = 1 then
    FalseChar := S[1];
end;

procedure TOvcIntlSup.SetAutoUpdate(Value : Boolean);
  {-set the AutoUpdate option}
begin
  if Value <> FAutoUpdate then begin
    FAutoUpdate := Value;
    if FAutoUpdate then
      {allocate our window handle}
        intlHandle := Classes.AllocateHWnd(isIntlWndProc)
    else begin
      {deallocate our window handle}
      if intlHandle <> 0 then
          Classes.DeallocateHWnd(intlHandle);
      intlHandle := 0;
    end;
  end;
end;

procedure TOvcIntlSup.SetCurrencyLtStr(const Value : string);
begin
  StrPLCopy(FCurrencyLtStr, Value, Length(FCurrencyLtStr)-1);
end;

procedure TOvcIntlSup.SetCurrencyRtStr(const Value : string);
begin
  StrPLCopy(FCurrencyRtStr, Value, Length(FCurrencyRtStr)-1);
end;

function TOvcIntlSup.TimeStringToHMS(const Picture, S : string;
         var Hour, Minute, Second : Integer) : Boolean;
  {-extract Hours, Minutes, Seconds from St, returning true if string is valid}
var
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  StrPLCopy(Buf2, S, Length(Buf2) - 1);
  Result := TimePCharToHMS(Buf1, Buf2, Hour, Minute, Second);
end;

function TOvcIntlSup.TimePCharToHMS(Picture, S : PChar;
         var Hour, Minute, Second : Integer) : Boolean;
  {-extract Hours, Minutes, Seconds from St, returning true if string is valid}
var
  I, J  : Cardinal;
  Tmp,
  t1159,
  t2359 : array[0..20] of Char;
begin
  Result := False;
  if StrLen(Picture) <> StrLen(S) then
    Exit;

  {extract hours, minutes, seconds from St}
  isExtractFromPicture(Picture, S, pmHour, Hour, -1, 0);
  isExtractFromPictureEx(Picture, S, pmMinute,  Minute, -1, 0, pmDateSlash);
  isExtractFromPicture(Picture, S, pmSecond,  Second, -1, 0);
  if (Hour = -1) or (Minute = -1) or (Second = -1) then begin
    Result := False;
    Exit;
  end;

  {check for TimeOnly}
  if StrChPos(Picture, pmAmPm, I) and (w1159 <> ''){(w1159[0] <> #0)}
    and (w2359 <> '') {(w2359[0] <> #0)} then begin
    Tmp[0] := #0;
    J := 0;
    while Picture[I] = pmAmPm do begin
      Tmp[J] := S[I];
      Inc(J);
      Inc(I);
    end;
    Tmp[J] := #0;
    TrimTrailPrimPChar(Tmp);

    StrPLCopy(t1159, w1159, Length(t1159));
    t1159[J] := #0;
    StrPLCopy(t2359, w2359, Length(t2359));
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  Result := StrPas(TimeToAmPmPChar(Buf2, Buf1, T, Pack));
end;

function TOvcIntlSup.TimeToAmPmPChar(Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar;
  {-convert T to a string of the form indicated by Picture. Times are always displayed in am/pm format.}
const
  t1159 = 'AM'#0;
  t2359 = 'PM'#0;
var
  PLen : Byte;
  Temp : Cardinal;
begin
  Move(Picture[0], Dest[0], (StrLen(Picture)+1) * SizeOf(Char));
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  StrPLCopy(Buf2, S, Length(Buf2) - 1);
  Result := TimePCharToTime(Buf1, Buf2);
end;

function TOvcIntlSup.TimePCharToTime(Picture, S : PChar) : TStTime;
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
  Buf1 : array[0..255] of Char;
  Buf2 : array[0..255] of Char;
begin
  StrPLCopy(Buf1, Picture, Length(Buf1) - 1);
  Result := StrPas(TimeToTimePChar(Buf2, Buf1, T, Pack));
end;

function TOvcIntlSup.TimeToTimePChar(Dest : PChar; Picture : PChar; T : TStTime; Pack : Boolean) : PChar;
  {-convert T to a string of the form indicated by Picture}
begin
  Result := isTimeToTimeStringPrim(Dest, Picture, T, Pack, PChar(w1159), PChar(w2359));
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

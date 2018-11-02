{******************************************************************************}
{*                   TestOvcIntl.pas 4.08                                     *}
{******************************************************************************}

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
{* The Initial Developer of the Original Code is Roman Kassebaum              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Roman Kassebaum                                                         *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOVCIntl;

interface

uses
  TestFramework;

type
  TTestOVCIntl = class(TTestCase)
  public
    procedure TestDateStringToDate;
    procedure TestDateToDateString;
    procedure TestInternationalTime;
  published
    procedure TestMonthStringToMonth;
    procedure TestisMergeIntoPicture;
    procedure TestDateTimeToDatePChar;
  end;

implementation

uses
  OvcFormatSettings, OvcDate, OvcIntl, SysUtils, StrUtils;

type
  TProtectedIntlSub = class(TOvcIntlSup);

{$I OVC.INC}

{ TTestOVCIntl }

procedure TTestOVCIntl.TestDateStringToDate;
type
  TData = record
    p, s: string;
    res: TStDate;
  end;
const
  cSomeData: array[0..1] of TData =
    ((p:'dd/mm/yyyy'; s: '14.04.1968'; res: 134513),
     (p:'DD nnn yy';  s: ' 1 Jan 11';  res: 150115));
var
  pIntlSup: TOvcIntlSup;
  i: Integer;
  res: TStDate;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    for i := 0 to High(cSomeData) do begin
      res := pIntlSup.DateStringToDate(cSomeData[i].p,cSomeData[i].s,2000);
      CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
    end;
  finally
    pIntlSup.Free;
  end;
end;


procedure TTestOVCIntl.TestDateToDateString;
type
  TData = record
    p: string;
    j: TStDate;
    res: string;
  end;
const
  cSomeData: array[0..1] of TData =
    ((p:'dd/mm/yyyy'; j: 134513; res: '14.04.1968'),
     (p:'DD nnn yy';  j: 150115; res: ' 1 Jan 11'));
var
  pIntlSup: TOvcIntlSup;
  i: Integer;
  res: string;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    TProtectedIntlSub(pIntlSup).SlashChar := '.';
    for i := 0 to High(cSomeData) do begin
      res := pIntlSup.DateToDateString(cSomeData[i].p,cSomeData[i].j,False);
      CheckEquals(cSomeData[i].res, res, Format('Test #%d failed',[i]));
    end;
  finally
    pIntlSup.Free;
  end;
end;


procedure TTestOVCIntl.TestInternationalTime;
var
  pIntlSup: TOvcIntlSup;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    //This test should also work on a German OS, that's why I'm doing
    //some tricks to simulate an English OS.
    TProtectedIntlSub(pIntlSup).w12Hour := True;
    TProtectedIntlSub(pIntlSup).w1159 := 'AM';
    TProtectedIntlSub(pIntlSup).w2359 := 'PM';

    CheckEquals(pIntlSup.InternationalTime(True), 'hh:mm:ss tt');
    CheckEquals(pIntlSup.InternationalTime(False), 'hh:mm tt');
  finally
    pIntlSup.Free;
  end;
end;


procedure TTestOVCIntl.TestMonthStringToMonth;
var
  pIntlSup: TOvcIntlSup;
  m, i: Integer;
  s: string;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    for i := 1 to 12 do begin
      s := FormatSettings.LongMonthNames[i];
      m := OvcIntlSup.MonthStringToMonth(s,Length(s));
      CheckEquals(i,m,Format('Test failed for s="%s"',[s]));
      s := Copy(FormatSettings.LongMonthNames[i],1,4);
      m := OvcIntlSup.MonthStringToMonth(s,4);
      CheckEquals(i,m,Format('Test failed for s="%s"',[s]));
      s := FormatSettings.ShortMonthNames[i];
      m := OvcIntlSup.MonthStringToMonth(s,Length(s));
      CheckEquals(i,m,Format('Test failed for s="%s"',[s]));
    end;
    m := OvcIntlSup.MonthStringToMonth('foo',3);
    CheckEquals(0,m,Format('Test failed for s="%s"',[s]));
  finally
    pIntlSup.Free;
  end;
end;


procedure TTestOVCIntl.TestisMergeIntoPicture;
type
  TData = record
    p: string;
    ch: Char;
    i: Integer;
    res: string;
  end;
const
  cSomeData: array[0..6] of TData =
    ((p:' nnn '; ch:'n'; i:2; res:''),
     (p:'NNNNNNNNNN'; ch:'n'; i:12; res:''),
     (p:'ww';         ch:'w'; i:0; res:''),
     (p:'www';        ch:'w'; i:0; res:''),
     (p:'WWWWWWWWWW'; ch:'w'; i:1; res:''),
     (p:'----dd----'; ch:'d'; i:5; res:'----05----'),
     (p:'----DD----'; ch:'d'; i:5; res:'---- 5----'));
var
  pic: array[0..32] of Char;
  pIntlSup: TOvcIntlSup;
  i: Integer;
  res: string;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    for i := 0 to High(cSomeData) do begin
      StrPCopy(pic, cSomeData[i].p);
      TProtectedIntlSub(OvcIntlSup).isMergeIntoPicture(@pic[0], cSomeData[i].ch, cSomeData[i].i);
      case i of
        0: res := Format(' %3.3s ',[FormatSettings.ShortMonthNames[2]]);
        1: res := AnsiUpperCase(Format('%-10.10s',[FormatSettings.LongMonthNames[12]]));
        2: res := Format('%2.2s',[FormatSettings.ShortDayNames[1]]);
        3: res := Format('%3.3s',[FormatSettings.LongDayNames[1]]);
        4: res := AnsiUpperCase(Format('%-10.10s',[FormatSettings.LongDayNames[2]]));
        else res := cSomeData[i].res;
      end;
      CheckEqualsString(res, pic, Format('Test #%d failed',[i]));
    end;
  finally
    pIntlSup.Free;
  end;
end;


procedure TTestOVCIntl.TestDateTimeToDatePChar;
type
  TData = record
    p: string;
    d,m,y,h,min,s: Word;
    res: string;
  end;
const
  cSomeData: array[0..1] of TData =
    ((p:'dd/mm/yyyy hh:mm:ss';
      d: 14; m: 04; y: 1968; h: 23; min: 59; s: 45; res: '14.04.1968 23:59:45'),
     (p:'hh:mm:ss - DD/MM/yy';
      d: 01; m: 01; y: 2000; h:  1; min:  2; s:  3; res: '01:02:03 -  1. 1.00'));
var
  pic, dest: array[0..32] of Char;
  DT: TDateTime;
  pIntlSup: TOvcIntlSup;
  i: Integer;
begin
  pIntlSup := TOvcIntlSup.Create;
  TProtectedIntlSub(OvcIntlSup).wColonChar := ':';
  TProtectedIntlSub(OvcIntlSup).SlashChar := '.';
  try
    for i := 0 to High(cSomeData) do begin
      StrPCopy(pic, cSomeData[i].p);
      DT :=   EncodeDate(cSomeData[i].y, cSomeData[i].m, cSomeData[i].d)
            + EncodeTime(cSomeData[i].h, cSomeData[i].min, cSomeData[i].s, 0);
      OvcIntlSup.DateTimeToDatePChar(Dest, pic, DT, False);
      CheckEqualsString(cSomeData[i].res, dest, Format('Test #%d failed',[i]));
    end;
  finally
    pIntlSup.Free;
  end;
end;


initialization
  RegisterTest(TTestOVCIntl.Suite);

end.

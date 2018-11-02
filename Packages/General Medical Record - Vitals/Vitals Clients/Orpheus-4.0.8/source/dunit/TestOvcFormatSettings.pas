unit TestOvcFormatSettings;

interface

uses
  TestFramework;

type
  TTestFormatSettings = class(TTestCase)
  published
    procedure TestLongMonthNames;
  end;

implementation

uses
  SysUtils, OvcFormatSettings;

{ TTestFormatSettings }

procedure TTestFormatSettings.TestLongMonthNames;
var
  pOVCSettings: TFormatSettings;
  pSettings: SysUtils.TFormatSettings;
  iCount: Integer;
begin
  for iCount := Low(pOVCSettings.LongMonthNames) to High(pSettings.LongMonthNames) do
    CheckEquals(pSettings.LongMonthNames[iCount], pOVCSettings.LongMonthNames[iCount]);
end;

initialization
  RegisterTest(TTestFormatSettings.Suite);
end.
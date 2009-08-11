unit ORDtTmCal;

interface

uses SysUtils, Windows, Classes, Graphics, Grids, Calendar;

type
  TORCalendar = class(TCalendar)
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  end;

procedure Register;

implementation

{ TORCalendar ------------------------------------------------------------------------------- }

procedure TORCalendar.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
{ uses the Calendar that is part of Samples and highlights the current date }
var
  TheText: string;
  CurMonth, CurYear, CurDay: Word;
begin
  TheText := CellText[ACol, ARow];
  with ARect, Canvas do
  begin
    DecodeDate(Date, CurYear, CurMonth, CurDay);
    if (CurYear = Year) and (CurMonth = Month) and (IntToStr(CurDay) = TheText) then
    begin
      TheText := '[' + TheText + ']';
      Font.Style := [fsBold];
    end;
    TextRect(ARect, Left + (Right - Left - TextWidth(TheText)) div 2,
      Top + (Bottom - Top - TextHeight(TheText)) div 2, TheText);
  end;
end;

procedure TORCalendar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_PRIOR then
    CalendarDate := IncMonth(CalendarDate,-1)
  else if Key = VK_NEXT then
    CalendarDate := IncMonth(CalendarDate,1);
end;

procedure Register;
{ used by Delphi to put components on the Palette }
begin
  RegisterComponents('CPRS', [TORCalendar]);
end;

end.
 
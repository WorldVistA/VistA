unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ORFn;

type
  TSurrogate = class
  private
    FIEN:        Int64;
    FName:       string;
    FStart:      TFMDateTime;
    FStop:       TFMDateTime;
  public
    property IEN:        Int64          read FIEN       write FIEN;
    property Name:       string         read FName      write FName;
    property Start:      TFMDateTime    read FStart     write FStart;
    property Stop:       TFMDateTime    read FStop      write FStop;
  end;

function RelativeDate(entry: string): integer;
procedure DateLimits(const limit: integer; var value: integer);
procedure ShowDisplay(editbox: TEdit);
procedure TextExit(editbox: TEdit; var entrycheck: boolean; limitcheck: integer);
procedure LabelSurrogate(surrogateinfo: string; alabel: TStaticText);
procedure DisplayPtInfo(PtID: string);

const
  INVALID_DAYS = -99999;
  DAYS_LIMIT = 999;
  SELECTION_LIMIT = 999;

implementation

uses rCore, fRptBox, VAUtils;

function RelativeDate(entry: string): integer;
// return the number of days for the entry  (e.g. -3 for T - 3)

  function OKToday(value: string): boolean;
  // check if value is used as the current date
  begin
    Result := false;
    if value = 'T' then Result := true
    else if value = 'TODAY' then Result := true
    else if IsNow(value) then Result := true;
  end;

  procedure GetMultiplier(var entry: string; var multiplier: integer);
  // check if entry has a multiplier on today's date (days, weeks, months, years)
  var
    lastchar: char;
  begin
    if IsNow(entry) or (entry = 'TODAY') then
    begin
      multiplier := 1;
      exit;
    end;
    lastchar := entry[length(entry)];
    case lastchar of
      'D': multiplier := 1;
      'W': multiplier := 7;
      'M': multiplier := 30;
      'Y': multiplier := 365;
      else multiplier := 0;
    end;
    if multiplier > 0 then
      entry := copy(entry, 0, length(entry) - 1)
    else
      multiplier := 1;
  end;

var
  firstpart, operator: string;
  lenfirstpart, multiplier: integer;
begin                                  // begin function RelativeDate
  Result := INVALID_DAYS;
  entry := Uppercase(entry);
  GetMultiplier(entry, multiplier);
  if strtointdef(entry, INVALID_DAYS) <> INVALID_DAYS then
  begin
    Result := strtointdef(entry, INVALID_DAYS);
    if Result <> INVALID_DAYS then
      Result := Result * multiplier;
    exit;
  end;
  if OKToday(entry) then                      // process today only
  begin
    Result := 0;
    exit;
  end;
  firstpart := Piece(entry, ' ', 1);
  lenfirstpart := length(firstpart);
  if OKToday(firstpart) then                  // process space
  begin
    operator := Copy(entry, lenfirstpart + 2, 1);
    if (operator = '+') or (operator = '-') then
    begin
      if Copy(entry, lenfirstpart + 3, 1) = ' ' then
        Result := strtointdef(Copy(entry, lenfirstpart + 4, length(entry)), INVALID_DAYS)
      else
        Result := strtointdef(Copy(entry, lenfirstpart + 3, length(entry)), INVALID_DAYS);
      if Result <> INVALID_DAYS then
        if Result < 0 then
          Result := INVALID_DAYS
        else if operator = '-' then
          Result := -Result;
    end;
    if Result <> INVALID_DAYS then
      Result := Result * multiplier;
  end
  else
  begin
    firstpart := Piece(entry, '+', 1);
    lenfirstpart := length(firstpart);
    if OKToday(firstpart) then                // process +
    begin
      if Copy(entry, lenfirstpart + 2, 1) = ' ' then
        Result := strtointdef(Copy(entry, lenfirstpart + 3, length(entry)), INVALID_DAYS)
      else
        Result := strtointdef(Copy(entry, lenfirstpart + 2, length(entry)), INVALID_DAYS);
      if Result <> INVALID_DAYS then
        if Result < 0 then
          Result := INVALID_DAYS
    end
    else
    begin
      firstpart := Piece(entry, '-', 1);
      lenfirstpart := length(firstpart);
      if OKToday(firstpart) then              // process -
      begin
        if Copy(entry, lenfirstpart + 2, 1) = ' ' then
          Result := strtointdef(Copy(entry, lenfirstpart + 3, length(entry)), INVALID_DAYS)
        else
          Result := strtointdef(Copy(entry, lenfirstpart + 2, length(entry)), INVALID_DAYS);
        if Result <> INVALID_DAYS then
          Result := -Result;
      end;
    end;
    if Result <> INVALID_DAYS then
      Result := Result * multiplier;
  end;
end;

procedure DateLimits(const limit: integer; var value: integer);
// check if date is within valid limit
begin
  if value > limit then
  begin
    beep;
    InfoBox('Date cannot be greater than Today + ' + inttostr(limit), 'Warning', MB_OK or MB_ICONWARNING);
    value := INVALID_DAYS;
  end
  else if value < -limit then
  begin
    beep;
    InfoBox('Date cannot be less than Today - ' + inttostr(limit), 'Warning', MB_OK or MB_ICONWARNING);
    value := INVALID_DAYS;
  end;
end;

procedure ShowDisplay(editbox: TEdit);
// displays the relative date (uses tag of editbox to hold # of days
begin
  with editbox do
  begin
    if Tag > 0 then
      Text := 'Today + ' + inttostr(Tag)
    else if Tag < 0 then
      Text := 'Today - ' + inttostr(-Tag)
    else
      Text := 'Today';
    Hint := Text;
  end;
end;

procedure TextExit(editbox: TEdit; var entrycheck: boolean; limitcheck: integer);
// checks entry in editbx if date is valid
var
  tagnum: integer;
begin
  with editbox do
  begin
    if entrycheck then
    begin
      tagnum := RelativeDate(Hint);
      if tagnum = INVALID_DAYS then
      begin
        beep;
        InfoBox('Date entry was invalid', 'Warning', MB_OK or MB_ICONWARNING);
        SetFocus;
      end
      else
      begin
        DateLimits(limitcheck, tagnum);
        if tagnum = INVALID_DAYS then
          SetFocus
        else
          Tag := tagnum;
      end;
      ShowDisplay(editbox);
      if Focused then SelectAll;
    end;
    entrycheck := false;
  end;
end;

procedure LabelSurrogate(surrogateinfo: string; alabel: TStaticText);
// surrogateinfo = surrogateIEN^surrogate name^surrogate start date/time^surrogate stop date/time
var
  surrogatename, surrogatestart, surrogatestop: string;
  surrogateien: Int64;
begin
  surrogateien := strtoint64def(Piece(surrogateinfo, '^', 1), -1);
  if surrogateien > 1 then
  begin
    surrogatename := Piece(surrogateinfo, '^', 2);
    surrogatestart := Piece(surrogateinfo, '^', 3);
    if surrogatestart = '-1' then surrogatestart := '0';
    if surrogatestart = '' then surrogatestart := '0';
    surrogatestop := Piece(surrogateinfo, '^', 4);
    if surrogatestop = '-1' then surrogatestop := '0';
    if surrogatestop = '' then surrogatestop := '0';
    alabel.Caption := surrogatename;
    if (surrogatestart <> '0') and (surrogatestop <> '0') then
      alabel.Caption := surrogatename +
      ' (from ' + FormatFMDateTimeStr('mmm d,yyyy@hh:nn', surrogatestart) +
      ' until ' + FormatFMDateTimeStr('mmm d,yyyy@hh:nn', surrogatestop) + ')'
    else if surrogatestart <> '0' then
      alabel.Caption := surrogatename +
      ' (from ' + FormatFMDateTimeStr('mmm d,yyyy@hh:nn', surrogatestart) + ')'
    else if surrogatestop <> '0' then
      alabel.Caption := surrogatename +
      ' (until ' + FormatFMDateTimeStr('mmm d,yyyy@hh:nn', surrogatestop) + ')'
    else
      alabel.Caption := surrogatename;
  end
  else
    alabel.Caption := '<no surrogate designated>';
end;

procedure DisplayPtInfo(PtID: string);
var
  PtRec: TPtIDInfo;
  rpttext: TStringList;
begin
  if strtointdef(PtID, -1) < 0 then exit;
  PtRec := GetPtIDInfo(PtID);
  rpttext := TStringList.Create;
  try
    with PtRec do
    begin
      rpttext.Add('     ' + Name);
      rpttext.Add('SSN: ' + SSN);
      rpttext.Add('DOB: ' + DOB);
      rpttext.Add('');
      rpttext.Add(Sex);
      rpttext.Add(SCSts);
      rpttext.Add(Vet);
      rpttext.Add('');
      if length(Location) > 0 then rpttext.Add('Location: ' + Location);
      if length(RoomBed)  > 0 then rpttext.Add('Room/Bed: ' + RoomBed);
    end;
    ReportBox(rpttext, 'Patient ID', false);
  finally
    rpttext.free
  end;
end;

end.

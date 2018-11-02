unit mGMV_MDateTime;

interface

uses
  Forms;

type
  TMDateTime = class(TObject)
  private
    FDateTime: TDateTime;

    function getWDate: TDateTime;
    function getWTime: TDateTime;
    procedure setWDate(aDateTime:TDateTime);
    procedure setWTime(aDateTime:TDateTime);
    procedure setWDateTime(aDateTime:TDateTime);

    function getWSLong:String;
  public
    DateTimeFormat: String;
    DateFormat: String;
    TimeFormat: String;

    constructor Create;

    function getMDate: Double;
    function getMTime: Double;
    function getMDateTime: Double;
    procedure setMDate(aDateTime:Double);
    procedure setMTime(aDateTime:Double);
    procedure setMDateTime(aDateTime:Double);

    function getSWDate: String;
    function getSWTime: String;
    function getSWDateTime: String;

    function getSMDate: String;
    function getSMTime: String;
    function getSMDateTime: String;

    procedure setSMDateTime(aDateTime:String);
    procedure setSWDateTime(aDateTime:String);
 // published
    property WDate:TDateTime read getWDate write setWDate;
    property WTime:TDateTime read getWTime write setWTime;
    property WDateTime:TDateTime read FDateTime write setWDateTime;
    property WSLong:String read getWSLong;
  end;

  TMDateTimeRange = class(TObject)
  public
    Start: TMDateTime;
    Stop: TMDateTime;
    constructor create;
    destructor Destroy; override;
    function setMRange(aRange:String):Boolean;
    function selectMRange(aRange:String):Boolean;
    function getSWRange:String;
  end;

const
  sWRangeDelim = ' -- ';
  sDateRange = 'DATE RANGE';

implementation

uses uGMV_Common, Sysutils, Controls, fGMV_DateRange
  ;

//  function  FMDateTimeToWindowsDateTime( FMDateTime: Double ): TDateTime;
//  function  WindowsDateTimeToFMDateTime( WinDate: TDateTime ): Double;


constructor TMDateTime.Create;
begin
  inherited;
  DateTimeFormat := 'mm/dd/yy hh:nn:ss';
  DateFormat := 'mm/dd/yy';
  TimeFormat := 'hh:nn:ss';
end;

function TMDateTime.getWDate:TDateTime;
begin
  Result := trunc(FDateTime);
end;

function TMDateTIme.getWTime:TDateTime;
begin
  Result := frac(FDateTime);
end;

function TMDateTime.getWSLong:String;
begin
  Result := FormatDateTime('dddd mmmm mm, yyyy',FDateTime);
end;

procedure TMDateTime.setWDate(aDateTime:TDateTime);
begin
  FDateTime := trunc(aDateTime) + frac(FDateTime);
end;

procedure TMDateTime.setWTime(aDateTime:TDateTime);
begin
  FDateTime := trunc(FDateTime) + frac(aDateTime);
end;

procedure TMDateTime.setWDateTime(aDateTime:TDateTime);
begin
  FDateTime := aDateTime;
end;

///////////////////////////////////////////////////////////
function TMDateTime.getMDateTime:Double;
begin
  Result := WindowsDateTimeToFMDateTime(FDateTime);
end;

function TMDateTime.getMDate:Double;
begin
  Result := trunc(WindowsDateTimeToFMDateTime(FDateTime));
end;

function TMDateTIme.getMTime:Double;
begin
  Result := frac(WindowsDateTimeToFMDateTime(FDateTime));
end;

procedure TMDateTime.setMDate(aDateTime:Double);
begin
  FDateTime := trunc(FMDateTimeToWindowsDateTime(aDateTime)) + frac(FDateTime);
end;

procedure TMDateTime.setMTime(aDateTime:Double);
begin
  FDateTime := trunc(FDateTime) + frac(FMDateTimeToWindowsDateTime(aDateTime));
end;

procedure TMDateTime.setMDateTime(aDateTime:Double);
begin
  FDateTime := FMDateTimeToWindowsDateTime(aDateTime);
end;

//////////////////////////////////////////////////////////////////
function TMDateTime.getSWDate:String;
begin
  if fDateTime <> 0 then
    Result := formatDateTime(DateFormat,FDateTime)
  else
    Result := '';
end;

function TMDateTIme.getSWTime:String;
begin
  Result := formatDateTime(TimeFormat,FDateTime);
end;

function TMDateTime.getSWDateTime:String;
begin
  Result := formatDateTime(DateTimeFOrmat,FDateTime);
end;
////////////////////////////////////////////////////////////////////
function TMDateTime.getSMDate:String;
var
  d: Double;
begin
  try
    d :=WindowsDateTimeToFMDateTime(FDateTime);
    result := FloatToStr(trunc(d));
  except
    Result := '';
  end;
end;

function TMDateTIme.getSMTime:String;
var
  d: Double;
begin
  try
    d :=WindowsDateTimeToFMDateTime(FDateTime);
    result := FloatToStr(frac(d));
  except
    Result := '';
  end;
end;

function TMDateTime.getSMDateTime:String;
begin
  try
    result := FloatToStr(WindowsDateTimeToFMDateTime(FDateTime));
  except
    Result := '';
  end;
end;

procedure TMDateTime.setSMDateTime(aDateTime:String);
begin
  try
    FDateTime := FMDateTimeToWindowsDateTime(StrToFloat(aDateTime));
  except
  end;
end;

procedure TMDateTime.setSWDateTime(aDateTime:String);
begin
  try
    FDateTime := StrToDateTime(aDateTime);
  except
  end;
end;


////////////////////////////////////////////////////////////////////////

constructor TMDateTimeRange.create;
begin
  inherited;
  Start := TMDateTime.Create;
  Start.WDateTime := Now;
  Stop := TMDateTime.Create;
  Stop.WDateTime := Now;
end;

destructor TMDateTimeRange.Destroy;
begin
  Start.Free;
  Stop.Free;
  inherited;
end;

(**)
function TMDateTimeRange.setMRange(aRange:String):Boolean;
var
  i: Integer;
  _Now,
  aStart,aStop: TDateTime;
const
  DayKey = 'TODAY T-1 T-2 T-3 T-4 T-5 T-6 T-7 T-15 T-30 SIX MONTHS ONE YEAR TWO YEARS ALL RESULTS';

  function GetDateRange(var FromDate, ToDate: TDateTime; AllowFutureDate: Boolean = True; AllowPastDate: Boolean = True): Boolean;
  begin
    with TfrmGMV_DateRange.Create(Application) do
      try
        dtpFrom.DateTime := FromDate;
        dtpTo.DateTime := ToDate;
        dtpFrom.MaxDate := TRunc(Now);
        dtpTo.MaxDate := dtpFrom.MaxDate;
        ShowModal;
        if ModalResult = mrOK then
          begin
            FromDate := dtpFrom.Date;
            ToDate := dtpTo.Date;
            Result := True;
          end
        else
          Result := False;
      finally
        free;
      end;
  end;

begin
//  result := False;
  if UpperCase(aRange) = sDateRange then
    begin
      aStart := Start.WDateTime;
      aStop := Stop.WDateTime;
      if GetDateRange(aStart,aStop,False) then
        begin
          Start.WDateTime := aStart;
          Stop.WDateTime := aStop;
          result := True;
        end
      else
        Result := False;
    end
  else if pos(Uppercase(aRange),DayKey) <> 0 then
    begin
      _Now := Now;
      aStop := trunc(_Now)+1 - 1/(3600*24);
      _Now := trunc(_Now);
      i := pos(Uppercase(aRange),DayKey);
      case i of
        1:aStart := _Now;
        7:aStart := _Now - 1;
        11:aStart := _Now - 2;
        15:aStart := _Now - 3;
        19:aStart := _Now - 4;
        23:aStart := _Now - 5;
        27:aStart := _Now - 6;
        31:aStart := _Now - 7;
        35:aStart := _Now - 15;
        40:aStart := _Now - 30;
        45:aStart := _Now - 183;
        56:aStart := _Now - 365;
        65:aStart := _Now - 730;
        75:aStart := _Now - 44444; // All results
      end;
{
      CallRemoteProc(RPCBroker, 'GMV CONVERT DATE', ['NOW'], nil, []);
      if (RPCBroker.Results.Count > 0) then
        Stop.setSMDateTime(Piece(RPCBroker.Results[0], '^', 1))
      else
        Stop.WDateTime := Now;

      CallRemoteProc(RPCBroker, 'GMV CONVERT DATE', [aRange], nil, []);
      if (RPCBroker.Results.Count > 0) then
        Start.setSMDateTime(Piece(RPCBroker.Results[0], '^', 1))
      else
        Stop.WDateTime := Now;
}
      Start.WDateTime := aStart;
      Stop.WDateTime := aStop;
      result := True;
    end
  else
    begin
      Start.setsWDateTime(Piece(aRange,sWRangeDelim,1));
      Stop.setsWDateTime(Piece(aRange,sWRangeDelim,2));
      result := True;
    end;
end;
(**)
(*
function TMDateTimeRange.setMRange(aRange:String):Boolean;
var
  aStart,aStop: TDateTime;
begin
  try
      Start.setSWDateTime(piece(aRange,' -- ',1));
      Stop.setSWDateTime(piece(aRange,' -- ',2));
      result := True;
  except
    result := False;
  end;
end;
*)

function TMDateTimeRange.selectMRange(aRange:String):Boolean;
var
  aStart,aStop: TDateTime;
begin
  aStart := Start.WDateTime;
  aStop := Stop.WDateTime;
  if GetDateRange(aStart,aStop,False) then
    begin
      Start.WDateTime := aStart;
      Stop.WDateTime := aStop;
      result := True;
    end
  else
    result := False;
end;

function TMDateTimeRange.getSWRange:String;
begin
  Result := Start.getSWDate + sWRangeDelim + Stop.getSWDate;
end;

end.

unit mGMV_DateRange;

interface

type
  TMDateTime = class(TObject)
  private
    FDateTime: TDateTime;

    function getWDate: TDateTime;
    function getWTime: TDateTime;
    procedure setWDate(aDateTime:TDateTime);
    procedure setWTime(aDateTime:TDateTime);
    procedure setWDateTime(aDateTime:TDateTime);

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
    procedure setsWDateTime(aDateTime:String);
  published
    property WDate:TDateTime read getWDate write setWDate;
    property WTime:TDateTime read getWTime write setWTime;
    property WDateTime:TDateTime read FDateTime write setWDateTime;
  end;

implementation

uses u_Common, Sysutils;

//  function  FMDateTimeToWindowsDateTime( FMDateTime: Double ): TDateTime;
//  function  WindowsDateTimeToFMDateTime( WinDate: TDateTime ): Double;

constructor TMDateTime.Create;
begin
  inherited;
  DateTimeFormat := 'mm/dd/yy hh:mm:ss';
  DateFormat := 'mm/dd/yy';
  TimeFormat := 'hh:mm:ss';
end;

function TMDateTime.getWDate:TDateTime;
begin
  Result := trunc(FDateTime);
end;

function TMDateTIme.getWTime:TDateTime;
begin
  Result := frac(FDateTime);
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
  Result := formatDateTime(DateFormat,FDateTime);
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

end.

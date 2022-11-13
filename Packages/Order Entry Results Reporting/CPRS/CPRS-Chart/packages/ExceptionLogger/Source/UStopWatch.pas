unit UStopWatch;

interface

uses
  Winapi.Windows,
  System.Classes;

type
  TStopWatch = class
  private
    FOwner: TObject;
    fFrequency: TLargeInteger;
    fIsRunning: Boolean;
    fIsHighResolution: Boolean;
    fStartCount, fStopCount: TLargeInteger;
    fActive: Boolean;
    procedure SetTickStamp(var lInt: TLargeInteger);
    function GetElapsedTicks: TLargeInteger;
    function GetElapsedMilliseconds: TLargeInteger;
    Function GetElapsedNanoSeconds: TLargeInteger;
    function GetElapsed: string;
  public
    constructor Create(AOwner: TComponent; const IsActive: Boolean = false;
      const startOnCreate: Boolean = false);
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    property IsHighResolution: Boolean read fIsHighResolution;
    property ElapsedTicks: TLargeInteger read GetElapsedTicks;
    property ElapsedMilliseconds: TLargeInteger read GetElapsedMilliseconds;
    property ElapsedNanoSeconds: TLargeInteger read GetElapsedNanoSeconds;
    property Elapsed: string read GetElapsed;
    property IsRunning: Boolean read fIsRunning;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

{$REGION 'TStopWatch'}

Const
  NSecsPerSec = 1000000000;

constructor TStopWatch.Create(AOwner: TComponent;
  const IsActive: Boolean = false; const startOnCreate: Boolean = false);
begin
  inherited Create();
  FOwner := AOwner;
  fIsRunning := false;
  fActive := IsActive;
  fIsHighResolution := QueryPerformanceFrequency(fFrequency);
  if NOT fIsHighResolution then
    fFrequency := MSecsPerSec;

  if startOnCreate then
    Start;
end;

destructor TStopWatch.Destroy;
begin
  Stop;
  inherited Destroy;
end;

function TStopWatch.GetElapsedTicks: TLargeInteger;
begin
  Result := fStopCount - fStartCount;
end;

procedure TStopWatch.SetTickStamp(var lInt: TLargeInteger);
begin
  if fIsHighResolution then
    QueryPerformanceCounter(lInt)
  else
    lInt := MilliSecondOf(Now);
end;

function TStopWatch.GetElapsed: string;
begin
  Result := FloatToStr(ElapsedMilliseconds / 1000) + ' Sec / ' +
    FloatToStr(ElapsedMilliseconds) + ' Ms / ' +
    FloatToStr(ElapsedNanoSeconds) + ' Ns';
end;

function TStopWatch.GetElapsedMilliseconds: TLargeInteger;
var
  Crnt: TLargeInteger;
begin
  if fIsRunning then
  begin
    SetTickStamp(Crnt);
    Result := (MSecsPerSec * (Crnt - fStartCount)) div fFrequency;
  end
  else
    Result := (MSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

function TStopWatch.GetElapsedNanoSeconds: TLargeInteger;
begin
  Result := (NSecsPerSec * (fStopCount - fStartCount)) div fFrequency;
end;

procedure TStopWatch.Start;
begin
  if fActive then
  begin
    SetTickStamp(fStartCount);
    fIsRunning := true;
  end;
end;

procedure TStopWatch.Stop;
begin
  if fActive then
  begin
    SetTickStamp(fStopCount);
    fIsRunning := false;
  end;
end;
{$ENDREGION}

end.

{
  Most of Code is Public Domain.
  Number Formats modified by OSEHRA/Sam Habiel (OSE/SMH) for Plan VI (c) Sam Habiel 2019
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit UStopWatch;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils, System.DateUtils;

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
  Result := FloatToStr(ElapsedMilliseconds / 1000, TFormatSettings.Create('en-US')) + ' Sec / ' +
    FloatToStr(ElapsedMilliseconds, TFormatSettings.Create('en-US')) + ' Ms / ' +
    FloatToStr(ElapsedNanoSeconds, TFormatSettings.Create('en-US')) + ' Ns';
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

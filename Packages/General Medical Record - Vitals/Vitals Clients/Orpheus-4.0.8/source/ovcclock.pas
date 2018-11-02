{*********************************************************}
{*                   OVCCLOCK.PAS 4.06                   *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit ovcclock;
  {-clock component}

interface

uses
  Windows, Classes, Controls, Dialogs, Forms, Graphics, Menus, Messages,
  SysUtils, OvcBase, OvcMisc, OvcDate, O32LEDLabel;

type
  TOvcPercent = 0..100;
  TOvcClockMode = (cmClock, cmTimer, cmCountdownTimer);
  TOvcClockDisplayMode = (dmAnalog, dmDigital);

  TOvcLEDClockDisplay = class(TO32CustomLEDLabel)
  public
    procedure PaintSelf;
  end;

  TOvcDigitalOptions = class(TPersistent)
  protected{private}
    FOwner         : TComponent;
    FOnColor       : TColor;
    FOffColor      : TColor;
    FBgColor       : TColor;
    FSize          : TSegmentSize;
    FShowSeconds   : Boolean;
    FFlashColon    : Boolean;
    FOnChange      : TNotifyEvent;
    F24Hour        : Boolean;
    procedure Set24Hour(Value: Boolean);
    procedure SetOnColor(Value: TColor);
    procedure SetOffColor(Value: TColor);
    procedure SetBgColor(Value: TColor);
    procedure SetSize(Value: TSegmentSize);
    procedure SetShowSeconds(Value: Boolean);
    procedure DoOnChange;
  public
    constructor Create;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property MilitaryTime : Boolean read F24Hour write Set24Hour;
    property OnColor: TColor read FOnColor write SetOnColor;
    property OffColor: TColor read FOffColor write SetOffColor;
    property BgColor: TColor read FBgColor write SetBgColor;
    property Size: TSegmentSize read FSize write SetSize;
    property ShowSeconds: Boolean read FShowSeconds write SetShowSeconds;
  end;

  TOvcHandOptions = class(TPersistent)
  protected {private}
    {property variables}
    FHourHandColor    : TColor;
    FHourHandLength   : TOvcPercent;
    FHourHandWidth    : Integer;
    FMinuteHandColor  : TColor;
    FMinuteHandLength : TOvcPercent;
    FMinuteHandWidth  : Integer;
    FSecondHandColor  : TColor;
    FSecondHandLength : TOvcPercent;
    FSecondHandWidth  : Integer;
    FShowSecondHand   : Boolean;
    FSolidHands       : Boolean;
    {events variables}
    FOnChange     : TNotifyEvent;
    {property methods}
    procedure SetHourHandColor(Value : TColor);
    procedure SetHourHandLength(Value : TOvcPercent);
    procedure SetHourHandWidth(Value : Integer);
    procedure SetMinuteHandColor(Value : TColor);
    procedure SetMinuteHandLength(Value : TOvcPercent);
    procedure SetMinuteHandWidth(Value : Integer);
    procedure SetSecondHandColor(Value : TColor);
    procedure SetSecondHandLength(Value : TOvcPercent);
    procedure SetSecondHandWidth(Value : Integer);
    procedure SetShowSecondHand(Value : Boolean);
    procedure SetSolidHands(Value : Boolean);
    {internal methods}
    procedure DoOnChange;
  public
    procedure Assign(Source : TPersistent);
      override;
    property OnChange : TNotifyEvent
      read  FOnChange write FOnChange;
  published
    property HourHandColor : TColor
      read FHourHandColor write SetHourHandColor;
    property HourHandLength : TOvcPercent
      read FHourHandLength write SetHourHandLength;
    property HourHandWidth : Integer
      read FHourHandWidth write SetHourHandWidth;
    property MinuteHandColor : TColor
      read FMinuteHandColor write SetMinuteHandColor;
    property MinuteHandLength : TOvcPercent
      read FMinuteHandLength write SetMinuteHandLength;
    property MinuteHandWidth : Integer
      read FMinuteHandWidth write SetMinuteHandWidth;
    property SecondHandColor : TColor
      read FSecondHandColor write SetSecondHandColor;
    property SecondHandLength : TOvcPercent
      read FSecondHandLength write SetSecondHandLength;
    property SecondHandWidth : Integer
      read FSecondHandWidth write SetSecondHandWidth;
    property ShowSecondHand : Boolean
      read FShowSecondHand write SetShowSecondHand;
    property SolidHands : Boolean
      read FSolidHands write SetSolidHands;
  end;

  TOvcCustomClock = class(TOvcCustomControlEx)
  protected {private}
    FActive           : Boolean;
    FClockFace        : TBitmap;
    FClockMode        : TOvcClockMode;
    FDigitalOptions   : TOvcDigitalOptions;
    FDisplayMode      : TOvcClockDisplayMode;
    FDrawMarks        : Boolean;
    FElapsedDays      : Integer;
    FElapsedHours     : Integer;
    FElapsedMinutes   : Integer;
    FElapsedSeconds   : Integer;
    FHandOptions      : TOvcHandOptions;
    FTime             : TDateTime;
    FMilitaryTime     : Boolean;
    FStartTime        : TDateTime;
    FHourOffset       : Integer;   {Hours}
    FMinuteOffset     : Integer;   {Minutes}
    FSecondOffset     : Integer;   {Seconds}
    {event variables}
    FOnHourChange   : TNotifyEvent;
    FOnMinuteChange : TNotifyEvent;
    FOnSecondChange : TNotifyEvent;
    FOnCountdownDone: TNotifyEvent;
    {internal variables}
    ckAnalogHeight  : Integer;
    ckAnalogWidth   : Integer;
    ckLEDDisplay    : TOvcLEDClockDisplay;
    ckDraw          : TBitMap;
    ckClockHandle   : Integer;
    ckOldHour       : Integer;
    ckOldMinute     : Integer;
    ckOldSecond     : Integer;
    ckTimerTime     : TDateTime;
    ckDays          : Integer;
    ckHours         : Integer;
    ckMinutes       : Integer;
    ckSeconds       : Integer;
    ckTotalSeconds  : Integer;
    {property methods}
    function GetElapsedDays : Integer;
    function GetElapsedHours : Integer;
    function GetElapsedMinutes : Integer;
    function GetElapsedSeconds : Integer;
    function GetElapsedSecondsTotal : Integer;
    procedure SetActive(Value : Boolean);
    procedure SetClockFace(Value : TBitMap);
    procedure SetClockMode(Value : TOvcClockMode);
    procedure SetDisplayMode(Value: TOvcClockDisplayMode);
    procedure SetDrawMarks(Value : Boolean);
    procedure SetMinuteOffset(Value : Integer);
    procedure SetHourOffset(Value : Integer);
    procedure SetSecondOffset(Value : Integer);
    {internal methods}
    function ckConvertMsToDateTime(Value : Integer) : TDateTime;
    procedure ckHandOptionChange(Sender : TObject);
    procedure ckDigitalOptionChange(Sender : TObject);
    procedure SizeDigitalDisplay;
    procedure ckTimerEvent(Sender : TObject; Handle : Integer;
                Interval : Cardinal; ElapsedTime : Integer);
    procedure DoOnHourChange;
    procedure DoOnMinuteChange;
    procedure DoOnSecondChange;
    procedure DoOnCountdownDone;
    procedure PaintHands(ACanvas : TCanvas);
    {windows message methods}
    procedure WMResize     (var Msg: TWMSize);        message WM_SIZE;
    procedure WMEraseBkgnd (var Msg : TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode (var Msg : TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Loaded; override;
    procedure Paint; override;
    procedure PaintAnalog;
    procedure PaintDigital;
    {virtual property methods}
    procedure SetTime(Value : TDateTime); virtual;
    property Active : Boolean read FActive write SetActive;
    property ClockFace : TBitMap read FClockFace write SetClockFace;
    property ClockMode : TOvcClockMode read FClockMode write SetClockMode;
    property DigitalOptions: TOvcDigitalOptions
      read FDigitalOptions write FDigitalOptions;
    property DrawMarks : Boolean read FDrawMarks write SetDrawMarks;
    property HandOptions : TOvcHandOptions read FHandOptions write FHandOptions;
    property MinuteOffset : Integer read FMinuteOffset write SetMinuteOffset;
    property TimeOffset : Integer read FHourOffset write SetHourOffset;
    property HourOffset : Integer read FHourOffset write SetHourOffset;
    property SecondOffset: Integer read FSecondOffset write SetSecondOffset;
    {events}
    property OnHourChange : TNotifyEvent read FOnHourChange write FOnHourChange;
    property OnMinuteChange : TNotifyEvent
      read FOnMinuteChange write FOnMinuteChange;
    property OnSecondChange : TNotifyEvent
      read FOnSecondChange write FOnSecondChange;
    property OnCountdownDone : TNotifyEvent
      read FOnCountdownDone write FOnCountdownDone;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer); override;
    property DisplayMode: TOvcClockDisplayMode
      read FDisplayMode write SetDisplayMode;
    property ElapsedDays : Integer read GetElapsedDays;
    property ElapsedHours : Integer read GetElapsedHours;
    property ElapsedMinutes : Integer read GetElapsedMinutes;
    property ElapsedSeconds : Integer read GetElapsedSeconds;
    property ElapsedSecondsTotal : Integer read GetElapsedSecondsTotal;
    property Time : TDateTime read FTime write SetTime;
  end;

  TOvcClock = class(TOvcCustomClock)
  published
    {properties}
    property Anchors;
    property Constraints;
    property About;
    property Active;
    property Align;
    property Color;
    property Controller;
    property ClockFace;
    property ClockMode;
    property DigitalOptions;
    property DisplayMode;
    property DrawMarks default True;
    property Hint;
    property HandOptions;
    property LabelInfo;
    property MinuteOffset default 0;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property SecondOffset default 0;
    property ShowHint;
    property TimeOffset default 0;
    property HourOffset default 0;
    property Visible;
    {events}
    property OnClick;
    property OnCountdownDone;
    property OnDblClick;
    property OnHourChange;
    property OnMinuteChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSecondChange;
  end;


implementation

const
  ckDToR     = (Pi / 180);
  ckInterval = 500;


{===== TOvcLEDClockDisplay ===========================================}
procedure TOvcLEDClockDisplay.PaintSelf;
begin
  Paint;
end;

{===== TOvcDigitalOptions ============================================}
constructor TOvcDigitalOptions.Create;
begin
  inherited Create;
  FSize          := 2;
  FOnColor       := clYellow;
  FOffColor      := $00104E4A;
  FBgColor       := clBlack;
  FShowSeconds   := True;
  MilitaryTime   := True;
end;
{=====}

procedure TOvcDigitalOptions.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;
{=====}

procedure TOvcDigitalOptions.Set24Hour(Value: Boolean);
begin
  if F24Hour <> Value then begin
    F24Hour := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcDigitalOptions.SetOnColor(Value: TColor);
begin
  if FOnColor <> Value then begin
    FOnColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcDigitalOptions.SetOffColor(Value: TColor);
begin
  if FOffColor <> Value then begin
    FOffColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcDigitalOptions.SetBgColor(Value: TColor);
begin
  if FBgColor <> Value then begin
    FBgColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcDigitalOptions.SetSize(Value: TSegmentSize);
begin
  if FSize <> Value then begin
    FSize := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcDigitalOptions.SetShowSeconds(Value: Boolean);
begin
  if FShowSeconds <> Value then begin
    FShowSeconds := Value;
    DoOnChange;
  end;
end;
{=====}


{===== TOvcHandOptions ===============================================}

procedure TOvcHandOptions.Assign(Source : TPersistent);
begin
  if Source is TOvcHandOptions then begin
    FHourHandColor := TOvcHandOptions(Source).FHourHandColor;
    FHourHandLength := TOvcHandOptions(Source).FHourHandLength;
    FHourHandWidth := TOvcHandOptions(Source).FHourHandWidth;
    FMinuteHandColor := TOvcHandOptions(Source).FMinuteHandColor;
    FMinuteHandLength := TOvcHandOptions(Source).FMinuteHandLength;
    FMinuteHandWidth := TOvcHandOptions(Source).FMinuteHandWidth;
    FSecondHandColor := TOvcHandOptions(Source).FSecondHandColor;
    FSecondHandLength := TOvcHandOptions(Source).FSecondHandLength;
    FSecondHandWidth := TOvcHandOptions(Source).FSecondHandWidth;
    FShowSecondHand := TOvcHandOptions(Source).FShowSecondHand;
    FSolidHands := TOvcHandOptions(Source).FSolidHands;
    FOnChange := TOvcHandOptions(Source).FOnChange;
  end else
    inherited Assign(Source);
end;
{=====}

procedure TOvcHandOptions.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;
{=====}

procedure TOvcHandOptions.SetHourHandColor(Value : TColor);
begin
  if Value <> FHourHandColor then begin
    FHourHandColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetHourHandLength(Value : TOvcPercent);
begin
  if Value <> FHourHandLength then begin
    FHourHandLength := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetHourHandWidth(Value : Integer);
begin
  if (Value <> FHourHandWidth) and (Value > 0) then begin
    FHourHandWidth := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetMinuteHandColor(Value : TColor);
begin
  if Value <> FMinuteHandColor then begin
    FMinuteHandColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetMinuteHandLength(Value : TOvcPercent);
begin
  if Value <> FMinuteHandLength then begin
    FMinuteHandLength := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetMinuteHandWidth(Value : Integer);
begin
  if (Value <> FMinuteHandWidth) and (Value > 0) then begin
    FMinuteHandWidth := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetSecondHandColor(Value : TColor);
begin
  if Value <> FSecondHandColor then begin
    FSecondHandColor := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetSecondHandLength(Value : TOvcPercent);
begin
  if Value <> FSecondHandLength then begin
    FSecondHandLength := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetSecondHandWidth(Value : Integer);
begin
  if (Value <> FSecondHandWidth) and (Value > 0) then begin
    FSecondHandWidth := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetShowSecondHand(Value : Boolean);
begin
  if Value <> FShowSecondHand then begin
    FShowSecondHand := Value;
    DoOnChange;
  end;
end;
{=====}

procedure TOvcHandOptions.SetSolidHands(Value : Boolean);
begin
  if Value <> FSolidHands then begin
    FSolidHands := Value;
    DoOnChange;
  end;
end;

{===== TOvcCustomClock ===============================================}

constructor TOvcCustomClock.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Width      := 136;
  Height     := 136;

  FClockMode := cmClock;
  FDrawMarks := True;

  FHandOptions := TOvcHandOptions.Create;
  FHandOptions.OnChange         := ckHandOptionChange;
  FHandOptions.HourHandColor    := clBlack;
  FHandOptions.HourHandLength   := 60;
  FHandOptions.HourHandWidth    := 4;
  FHandOptions.MinuteHandColor  := clBlack;
  FHandOptions.MinuteHandLength := 80;
  FHandOptions.MinuteHandWidth  := 3;
  FHandOptions.SecondHandColor  := clRed;
  FHandOptions.SecondHandLength := 90;
  FHandOptions.SecondHandWidth  := 1;
  FHandOptions.ShowSecondHand   := True;
  FHandOptions.FSolidHands      := True;

  FDigitalOptions := TOvcDigitalOptions.Create;
  FDigitalOptions.FOnChange     := ckDigitalOptionChange;

  ckDraw            := TBitMap.Create;
  ckDraw.Width      := Width;
  ckDraw.Height     := Height;

  FClockFace        := TBitMap.Create;
  ckClockHandle     := -1;
end;
{=====}

destructor TOvcCustomClock.Destroy;
begin
  Active := False;

  FClockFace.Free;
  FClockFace := nil;

  FHandOptions.Free;
  FHandOptions := nil;
  FDigitalOptions.Free;
  FDigitalOptions := nil;

  ckDraw.Free;
  ckDraw := nil;

  inherited Destroy;
end;
{=====}

function TOvcCustomClock.ckConvertMsToDateTime(Value : Integer) : TDateTime;
var
  S, Days : Integer;
  Hour, Minute, Second : Word;
begin
  S := Value div 1000;
  Days := S div SecondsInDay;
  S := S mod SecondsInDay;
  Hour := S div SecondsInHour;
  S := S mod SecondsInHour;
  Minute := S div SecondsInMinute;
  Second := S mod SecondsInMinute;
  Result := EncodeTime(Hour, Minute, Second, 0) + Days;
end;
{=====}

procedure TOvcCustomClock.ckHandOptionChange(Sender : TObject);
begin
  if FDisplayMode = dmAnalog then
    Invalidate;
end;
{=====}

procedure TOvcCustomClock.ckDigitalOptionChange(Sender : TObject);
begin
  if FDisplayMode = dmDigital then begin
    ckLEDDisplay.Size := FDigitalOptions.Size;
    ckLEDDisplay.BgColor := FDigitalOptions.BgColor;
    ckLEDDisplay.OnColor := FDigitalOptions.OnColor ;
    ckLEDDisplay.OffColor := FDigitalOptions.OffColor;
    FMilitaryTime := FDigitalOptions.MilitaryTime;
    if FDigitalOptions.ShowSeconds and FMilitaryTime then
      ckLEDDisplay.Columns := 8
    else if FDigitalOptions.ShowSeconds and not FMilitaryTime then
      ckLEDDisplay.Columns := 11
    else if not FDigitalOptions.ShowSeconds and FMilitaryTime then
      ckLEDDisplay.Columns := 5
    else if not FDigitalOptions.ShowSeconds and not FMilitaryTime then
      ckLEDDisplay.Columns := 8;
    SizeDigitalDisplay;
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SizeDigitalDisplay;
begin
  Width := ckLEDDisplay.Width;
  Height := ckLEDDisplay.Height;
end;
{=====}

procedure TOvcCustomClock.ckTimerEvent(Sender : TObject; Handle : Integer;
            Interval : Cardinal; ElapsedTime : Integer);
var
  Hour, Minute, Second, MSecond : Word;
  C, D                          : Integer;
begin
  if FClockMode = cmClock then begin
    {Clock}
    DecodeTime(Now, Hour, Minute, Second, MSecond);
    D := Minute + FMinuteOffset;
    Minute := Abs(D mod 60);
    C := Hour + FHourOffset + (D div 60);
    if C > 23 then
      Dec(C, 24);
    if C < 0 then
      Inc(C, 24);
    Hour := C;
    SetTime(EncodeTime(Hour, Minute, Second, MSecond));
  end else if FClockMode = cmTimer then begin
    {Count Up Timer}
    SetTime(ckConvertMsToDateTime(ElapsedTime));
  end else begin
    {Countdown Timer}
    if (FStartTime - ckConvertMsToDateTime(ElapsedTime) <= 0) then begin
      SetTime(0);
      Active := false;
      DoOnCountdownDone;
    end else
      SetTime(FStartTime - ckConvertMsToDateTime(ElapsedTime));
  end;
end;
{=====}

procedure TOvcCustomClock.DoOnHourChange;
begin
  if Assigned(FOnHourChange) then
    FOnHourChange(Self);
end;
{=====}

procedure TOvcCustomClock.DoOnMinuteChange;
begin
  if Assigned(FOnMinuteChange) then
    FOnMinuteChange(Self);
end;
{=====}

procedure TOvcCustomClock.DoOnSecondChange;
begin
  if Assigned(FOnSecondChange) then
    FOnSecondChange(Self);
end;
{=====}

procedure TOvcCustomClock.DoOnCountdownDone;
begin
  if Assigned (FOnCOuntdownDone) then
    FOnCountdownDone(self);
end;
{=====}

function TOvcCustomClock.GetElapsedDays: Integer;
var
  ClockDate : TDateTime;
begin
  if ckClockHandle > -1 then begin
    ClockDate := ckConvertMsToDateTime(
      Controller.TimerPool.ElapsedTime[ckClockHandle]);
    ckDays := Trunc(ClockDate);
  end;
  Result := ckDays;
end;
{=====}

function TOvcCustomClock.GetElapsedHours: Integer;
var
  Hour     : Word;
  Min      : Word;
  Sec      : Word;
  MSec     : Word;
  TempTime : TDateTime;
begin
  if ckClockHandle > -1 then begin
    TempTime := ckConvertMsToDateTime(
      Controller.TimerPool.ElapsedTime[ckClockHandle]);
     DecodeTime(TempTime, Hour, Min, Sec, MSec);
     ckHours := Hour
  end;
  Result := ckHours;
end;
{=====}

function TOvcCustomClock.GetElapsedMinutes: Integer;
var
  Hour     : Word;
  Min      : Word;
  Sec      : Word;
  MSec     : Word;
  TempTime : TDateTime;
begin
  if ckClockHandle > -1 then begin
    TempTime := ckConvertMsToDateTime(
      Controller.TimerPool.ElapsedTime[ckClockHandle]);
    DecodeTime(TempTime, Hour, Min, Sec, MSec);
    ckMinutes := Min;
  end;
  Result := ckMinutes;
end;
{=====}

function TOvcCustomClock.GetElapsedSeconds : Integer;
var
  Hour     : Word;
  Min      : Word;
  Sec      : Word;
  MSec     : Word;
  TempTime : TDateTime;
begin
  if ckClockHandle > -1 then begin
    TempTime := ckConvertMsToDateTime(
      Controller.TimerPool.ElapsedTime[ckClockHandle]);
    DecodeTime(TempTime, Hour, Min, Sec, MSec);
    ckSeconds := Sec;
  end;
  Result := ckSeconds;
end;
{=====}

function TOvcCustomClock.GetElapsedSecondsTotal : Integer;
begin
  if ckClockHandle > -1 then
    ckTotalSeconds :=
      Controller.TimerPool.ElapsedTime[ckClockHandle] div 1000;
  Result := ckTotalSeconds;
end;
{=====}

procedure TOvcCustomClock.Loaded;
var
  HA : Boolean;
begin
  inherited Loaded;

  ckHandOptionChange(self);
  ckDigitalOptionChange(self);

  HA := FActive;
  FActive := False;
  SetActive(HA);
end;
{=====}

procedure TOvcCustomClock.Paint;
begin
  case FDisplayMode of
    dmDigital : PaintDigital;
    dmAnalog  : PaintAnalog;
  end;
end;
{=====}

procedure TOvcCustomClock.PaintDigital;
begin
{  if not FActive then
    ckLEDDisplay.Caption := '';}
  ckLEDDisplay.PaintSelf;
end;
{=====}

procedure TOvcCustomClock.PaintAnalog;
var
  HalfWidth   : Integer;
  HalfHeight  : Integer;
  Lcv         : Integer;
  MarkX       : Integer;
  MarkY       : Integer;
  MarkAngle   : Double;
  ElRgn       : HRgn;
  R           : TRect;

  procedure DrawTickMark(MarkX, MarkY : Integer;
                         LColor, MColor, RColor : TColor;
                         FiveMinute : Boolean);
  begin
    with ckDraw.Canvas do begin
      Pixels[MarkX, MarkY]     := MColor;
      Pixels[MarkX-1, MarkY-1] := LColor;
      Pixels[MarkX,   MarkY-1] := LColor;
      Pixels[MarkX-1, MarkY]   := LColor;

      Pixels[MarkX+1, MarkY+1] := RColor;
      Pixels[MarkX+1, MarkY]   := RColor;
      Pixels[MarkX, MarkY+1]   := RColor;

      if (FiveMinute) then begin
        Pixels[MarkX-1, MarkY+1] := LColor;
        Pixels[MarkX+1, MarkY-1] := RColor;
      end;
    end;
  end;

begin
  with ckDraw.Canvas do begin
    Brush.Color := Color;
    Pen.Color   := FHandOptions.HourHandColor;
    Pen.Width   := 1;
    FillRect(ClientRect);

    if not (FClockFace.Empty) then begin
      R := ClientRect;
      if FDrawMarks then
        InflateRect(R, -3, -3);
      ElRgn := CreateEllipticRgn(R.Left, R.Top, R.Right, R.Bottom);
      try
        SelectClipRgn(ckDraw.Canvas.Handle, ElRgn);
        StretchDraw(R, FClockFace);
      finally
        DeleteObject(ElRgn);
      end;
      SelectClipRgn(ckDraw.Canvas.Handle, 0);{remove clipping region}
    end;

    {draw marks}
    if FDrawMarks then begin
      with ClientRect do begin
        HalfWidth   := (Right - Left) shr 1;
        HalfHeight  := (Bottom - Top) shr 1;
      end;
      if HalfWidth < 1 then
        HalfWidth := 1;
      if HalfHeight < 1 then
        HalfHeight := 1;
      for Lcv := 0 to 59 do begin
        MarkAngle := ckDToR * (((Round((Lcv / 60) * 360)) + 90) mod 360);
        MarkX := Round(HalfWidth * (1 - (((100 - 2) / 100) * Cos(MarkAngle))));
        MarkY := Round(HalfHeight * (1 - (((100 - 2) / 100) * Sin(MarkAngle))));
        MoveTo(MarkX, MarkY);

        if Lcv mod 5 = 0 then
          DrawTickMark(MarkX, MarkY, clBlue, clGray, clBlack, True)
        else
          DrawTickMark(MarkX, MarkY, clGray, clSilver, clWhite, False);
      end;
    end;
  end;

  PaintHands(ckDraw.Canvas);

  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect(ClientRect, ckDraw.Canvas, ClientRect);
end;
{=====}

procedure TOvcCustomClock.PaintHands(ACanvas : TCanvas);
type
  HandType  = (HourHand, MinuteHand, SecondHand);
var
  X             : Integer;
  Hour          : Word;
  Minute        : Word;
  Second        : Word;
  MSecond       : Word;
  HalfWidth     : Integer;
  HalfHeight    : Integer;
  HandBase      : Integer;
  HandAngle     : Double;
  HourHandLen   : Integer;
  MinuteHandLen : Integer;
  SecondHandLen : Integer;

  procedure RotatePoint(OldPoint : TPoint; var NewPoint : TPoint);
  begin
    OldPoint.X := OldPoint.X - HalfWidth;
    OldPoint.Y := OldPoint.Y - HalfHeight;
    NewPoint.X := Round(OldPoint.X * Cos(HandAngle-Pi/2) - OldPoint.Y * Sin(HandAngle-Pi/2));
    NewPoint.Y := Round(OldPoint.X * Sin(HandAngle-Pi/2) + OldPoint.Y * Cos(HandAngle-Pi/2));
    if (HalfHeight < HalfWidth) then
      NewPoint.X := Round(NewPoint.X * (HalfWidth/HalfHeight))
    else
      NewPoint.Y := Round(NewPoint.Y * (HalfHeight/HalfWidth));
    NewPoint.X := NewPoint.X + HalfWidth;
    NewPoint.Y := NewPoint.Y + HalfHeight;
  end;

  procedure DrawNewHand(PenColor   : TColor;
                        Hand       : HandType;
                        HandLength : Integer;
                        HipWidth   : Integer);
  const
    MaxPoints = 7;
  var
    I          : Integer;
    Hip        : Integer;
    Points     : array[1..MaxPoints] of TPoint;
    HandPoints : array[1..MaxPoints] of TPoint;

    procedure ShadeHand;
    Var
      CPoints : array[1..3] of TPoint;

      procedure LoadPoints(Pt1, Pt2, Pt3 : Integer);
      begin
        CPoints[1] := HandPoints[Pt1];
        CPoints[2] := HandPoints[Pt2];
        CPoints[3] := HandPoints[Pt3];
        ACanvas.Polygon(CPoints);
      end;

    begin
      ACanvas.Brush.Color := clWhite;
      case Hand of
        HourHand : begin
                     case Hour of
                       0..3,
                      12..15 : begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(1,2,4);
                               end;
                       4..5,
                      16..17 : begin
                                 LoadPoints(1,2,4);
                                 LoadPoints(1,2,6);
                               end;
                       6..9,
                      18..21 : begin
                                 LoadPoints(1,2,6);
                                 LoadPoints(2,3,6);
                               end;
                      10..11,
                      22..23 : begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(2,3,6);
                               end;
                     end;
                   end;
        MinuteHand: begin
                     case Minute of
                       0..15 : begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(1,2,4);
                               end;
                       16..25: begin
                                 LoadPoints(1,2,4);
                                 LoadPoints(1,2,6);
                               end;
                       26..50: begin
                                 LoadPoints(1,2,6);
                                 LoadPoints(2,3,6);
                               end;
                       51..59: begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(2,3,6);
                               end;
                     end;
                   end;
        SecondHand: begin
                     case Second of
                       0..15 : begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(1,2,4);
                               end;
                       16..25: begin
                                 LoadPoints(1,2,4);
                                 LoadPoints(1,2,6);
                               end;
                       26..50: begin
                                 LoadPoints(1,2,6);
                                 LoadPoints(2,3,6);
                               end;
                       51..59: begin
                                 LoadPoints(2,3,4);
                                 LoadPoints(2,3,6);
                               end;
                     end;
                   end;
      end;
      ACanvas.Brush.Color := Color;
    end;

  begin
    {where to put Crossbar}
    if HipWidth > 1 then
      Hip := Trunc(HandLength * 0.25)
    else
      Hip := 0;

    {start at Center Point}
    Points[1].X := HalfWidth;
    Points[1].Y := HalfHeight;

    {up Center to Hip}
    Points[2].X := HalfWidth;
    Points[2].Y := HalfHeight-Hip;

    {up Center to Top}
    Points[3].X := HalfWidth;
    Points[3].Y := HalfHeight-HandLength;

    {angle Left}
    Points[4].X := HalfWidth-HipWidth;
    Points[4].Y := HalfHeight - Hip;

    {start at Center Point}
    Points[5].X := HalfWidth;
    Points[5].Y := HalfHeight;

    {angle Left}
    Points[6].X := HalfWidth+HipWidth;
    Points[6].Y := HalfHeight - Hip;

    {up Center to Top}
    Points[7].X := HalfWidth;
    Points[7].Y := HalfHeight-HandLength;

    for I :=1 to 7 do
      RotatePoint(Points[I], HandPoints[I]);

    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := PenColor;
    if FHandOptions.SolidHands then
      ACanvas.Brush.Color := PenColor
    else
      ACanvas.Brush.Color := Color;

    ACanvas.MoveTo(HalfWidth, HalfHeight);
    ACanvas.Polygon(HandPoints);

    if not FHandOptions.SolidHands then
      ShadeHand;
  end;

begin
  DecodeTime(FTime, Hour, Minute, Second, MSecond);

  HalfWidth   := (ClientRect.Right - ClientRect.Left) shr 1;
  HalfHeight  := (ClientRect.Bottom - ClientRect.Top) shr 1;
  if HalfWidth < 1 then
    HalfWidth := 1;
  if HalfHeight < 1 then
    HalfHeight := 1;

  {based on the Height or Width of the Clock, set the Hand Lengths}
  HandBase := MinI(HalfWidth, HalfHeight);
  HourHandLen   := Trunc(HandBase * FHandOptions.HourHandLength / 100);
  MinuteHandLen := Trunc(HandBase * FHandOptions.MinuteHandLength / 100);
  SecondHandLen := Trunc(HandBase * FHandOptions.SecondHandLength / 100);

  HandAngle := ckDToR * (((Round((((Hour * 5) + (Minute div 12)) / 60) * 360)) + 90) mod 360);
  DrawNewHand(FHandOptions.HourHandColor, HourHand, HourHandLen, FHandOptions.HourHandWidth);

  HandAngle := ckDToR * (((Round((Minute / 60) * 360)) + 90) mod 360);
  DrawNewHand(FHandOptions.MinuteHandColor, MinuteHand, MinuteHandLen, FHandOptions.MinuteHandWidth);

  if (FHandOptions.ShowSecondHand) then begin
    HandAngle := ckDToR * (((Round((Second / 60) * 360)) + 90) mod 360);
    DrawNewHand(FHandOptions.SecondHandColor, SecondHand, SecondHandLen, FHandOptions.SecondHandWidth);
  end;

  if FHandOptions.ShowSecondHand then
    ACanvas.Brush.Color := FHandOptions.SecondHandColor
  else
    ACanvas.Brush.Color := FHandOptions.MinuteHandColor;
  ACanvas.Pen.Color := clBlack;
  X := Round(HandBase * 0.04) + 1;
  ACanvas.Ellipse(HalfWidth-X, HalfHeight-X, HalfWidth+X, HalfHeight+X);
end;
{=====}

procedure TOvcCustomClock.SetActive(Value : Boolean);
begin
  if csLoading in ComponentState then begin
    FActive := Value;
    Exit;
  end;

  if Value <> FActive then begin
    FActive := Value;
    if FActive then begin
      if FDisplayMode = dmDigital then
        FMilitaryTime := DigitalOptions.MilitaryTime;
      if ckClockHandle = -1 then
        ckClockHandle := Controller.TimerPool.Add(ckTimerEvent, ckInterval);
      if FClockMode = cmClock then
        FTime := Now
      else if FClockMode = cmCountdownTimer then
        FStartTime := EncodeTime(FHourOffset {Hours}, FMinuteOffset,
          FSecondOffset, 0)
      else
        FTime := 0;
    end else if ckClockHandle > -1 then begin
      Controller.TimerPool.Remove(ckClockHandle);
      ckClockHandle := -1;
    end;

    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if Assigned(ckDraw) then begin
    ckDraw.Width  := AWidth;
    ckDraw.Height := AHeight;
  end;

  Invalidate;
end;
{=====}

procedure TOvcCustomClock.SetClockFace(Value : TBitMap);
begin
  if Assigned(Value) then
    FClockFace.Assign(Value)
  else begin
    FClockFace.Free;
    FClockFace := TBitmap.Create;
  end;
  Invalidate;
end;
{=====}

procedure TOvcCustomClock.SetClockMode(Value : TOvcClockMode);
begin
  if Value <> FClockMode then begin
    if FActive then Active := false;
    FClockMode := Value;
    if FClockMode = cmClock then
      DigitalOptions.MilitaryTime := false
    else
      DigitalOptions.MilitaryTime := true;

    if FClockMode <> cmCountdownTimer then
      FTime := 0
    else
      SetTime(EncodeTime(FHourOffset, FMinuteOffset, 0, 0));
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetDisplayMode(Value: TOvcClockDisplayMode);
begin
  if Value <> FDisplayMode then begin
    FDisplayMode := Value;
    case FDisplayMode of

      dmDigital: begin
        {Save the analog height and width}
        ckAnalogHeight := Height;
        ckAnalogWidth := Width;

        {Create and initialize the LED display}
        ckLEDDisplay := TOvcLEDClockDisplay.Create(self);
        ckLEDDisplay.Parent := self;
        ckLEDDisplay.OnColor := FDigitalOptions.OnColor;
        ckLEDDisplay.OffColor := FDigitalOptions.OffColor;
        ckLEDDisplay.BgColor := FDigitalOptions.BgColor;
        ckLEDDisplay.Size := FDigitalOptions.Size;
        if FDigitalOptions.ShowSeconds then begin
          ckLEDDisplay.Columns := 8;
          ckLEDDisplay.Caption := '00:00:00';
        end else begin
          ckLEDDisplay.Columns := 5;
          ckLEDDisplay.Caption := '00:00';
        end;

        {Set the height and width of the control}
        SizeDigitalDisplay;

        {Blank the control}
        Canvas.Brush.Color := FDigitalOptions.BgColor;
        Canvas.FillRect(GetClientRect);

        {Initialize the LED display}
        if FActive then begin
          if FClockMode = cmClock then
          {Clock}
            SetTime(Now)
          else if FClockMode = cmTimer then
          {Timer}
            SetTime(ckConvertMsToDateTime(FElapsedSeconds * 1000))
          else
          {Countdown Timer}
            if (FStartTime - ckConvertMsToDateTime(
              FElapsedSeconds * 1000) <= 0) then
            begin
              SetTime(0);
              Active := false;
              DoOnCountdownDone;
            end else
              SetTime(FStartTime - ckConvertMsToDateTime(FElapsedSeconds * 1000));
        end;

      end;

      dmAnalog: begin
        {Destroy the LED Display}
        if ckLEDDisplay <> nil then begin
          ckLEDDisplay.Free;
          ckLEDDisplay := nil;
        end;

        {Adjust the height and width}
        if (ckAnalogHeight < ckAnalogWidth) then begin
          {If the analog clock is shorted than it is wide then load default    }
          {height and width                                                    }
          Height := 136;
          Width := 136;
        end else begin
          {Otherwise reload saved values}
          Height := ckAnalogHeight;
          Width := ckAnalogWidth;
        end;

        {Blank the canvas}
        with ckDraw.Canvas do begin
          Brush.Color := Color;
          FillRect(ClientRect);
          Canvas.CopyMode := cmSrcCopy;
          Canvas.CopyRect(ClientRect, ckDraw.Canvas, ClientRect);
        end;
      end;
    end;
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetDrawMarks(Value : Boolean);
begin
  if Value <> FDrawMarks then begin
    FDrawMarks := Value;
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetTime(Value : TDateTime);
var
  Hour1, Minute1, Second1 : Word;
  Hour2, Minute2, Second2 : Word;
  MSecond : Word;
  TimeStr: string;
begin
  DecodeTime(Value, Hour1, Minute1, Second1, MSecond);
  DecodeTime(FTime, Hour2, Minute2, Second2, MSecond);
  if (Hour1 <> Hour2) or (Minute1 <> Minute2) or (Second1 <> Second2) then begin
    FTime := Value;

    if (Hour1 <> ckOldHour) then
      DoOnHourChange;
    ckOldHour := Hour1;
    if (Minute1 <> ckOldMinute) then
      DoOnMinuteChange;
    ckOldMinute := Minute1;
    if (Second1 <> ckOldSecond) then
      DoOnSecondChange;
    ckOldSecond := Second1;

    if DisplayMode = dmDigital then begin
      if FDigitalOptions.ShowSeconds and FMilitaryTime then
        TimeStr := FormatDateTime('hh:mm:ss', FTime)
      else if FDigitalOptions.ShowSeconds and not FMilitaryTime then
        TimeStr := FormatDateTime('hh:mm:ss am/pm', FTime)
      else if not FDigitalOptions.ShowSeconds and FMilitaryTime then
        TimeStr := FormatDateTime('hh:mm', FTime)
      else if not FDigitalOptions.ShowSeconds and not FMilitaryTime then
        TimeStr := FormatDateTime('hh:mm am/pm', FTime);
      ckLEDDisplay.Caption := TimeStr;
    end;

    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetMinuteOffset(Value : Integer);
begin
  if (Value <> FMinuteOffset) and (Abs(Value) <= 60) then begin
    FMinuteOffset := Value;
    if FClockMode = cmCountdownTimer then
      SetTime(EncodeTime(FHourOffset, FMinuteOffset, FSecondOffset, 0));
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetHourOffset(Value : Integer);
begin
  if (Value <> FHourOffset) and (Abs(Value) <= 24) then begin
    FHourOffset := Value;
    if FClockMode = cmCountdownTimer then
      SetTime(EncodeTime(FHourOffset, FMinuteOffset, FSecondOffset, 0));
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.SetSecondOffset(Value : Integer);
begin
  if (Value <> FSecondOffset) and (Abs(Value) <= 59) then begin
    FSecondOffset := Value;
    if FClockMode = cmCountdownTimer then
      SetTime(EncodeTime(FHourOffset, FMinuteOffset, FSecondOffset, 0));
    Invalidate;
  end;
end;
{=====}

procedure TOvcCustomClock.WMResize(var Msg: TWMSize);
begin
  if DisplayMode = dmDigital then begin
    Width := ckLEDDisplay.Width;
    Height := ckLEDDisplay.Height;
    Invalidate;
  end;
end;

procedure TOvcCustomClock.WMEraseBkgnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;
end;
{=====}

procedure TOvcCustomClock.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  {tell windows we are a static control to avoid receiving the focus}
  Msg.Result := DLGC_STATIC;
end;
{=====}

end.

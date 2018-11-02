{*********************************************************}
{*                  OVCPEAKM.PAS 4.06                    *}
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
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcpeakm;
  {-Peak meter component}

interface

uses
  UITypes, Windows, Classes, Controls, Graphics, Forms, Messages, SysUtils,
  OvcBase, ExtCtrls;

type
  TIntArray = array[0..pred(MaxInt div sizeof(Integer))] of Integer;
  PIntArray = ^TIntArray;
  TOvcPmStyle = (pmBar, pmHistoryPoint);
  TOvcPeakMeter = class(TOvcGraphicControl)

  protected
    {Property fields}
    FBackgroundColor : TColor;
    FBarColor : TColor;
    FBorderStyle : TBorderStyle;
    FCtl3D : Boolean;
    FEnabled : Boolean;
    FGridColor : TColor;
    FHistory : PIntArray;
    FInitialMax : Integer;
    FMarginTop : Integer;
    FMarginBottom : Integer;
    FMarginLeft : Integer;
    FMarginRight : Integer;
    FPeak : Integer;
    FPeakColor : TColor;
    FScaleMargin : Integer;
    FShowValues : Boolean;
    FStyle : TOvcPmStyle;
    FValue : Integer;

    HistorySize : Integer;

    {Local variables}
    MemBM      : TBitMap;

    procedure ResizeHistory(NewSize: Integer);

    {VCL methods}
    procedure Paint; override;

    {Property access methods}
    procedure SetBackgroundColor(const C : TColor);
    procedure SetBarColor(const Value : TColor);
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetCtl3D(const Value : Boolean);
    procedure SetGridColor(const Value : TColor);
    procedure SetMarginTop(Value : Integer);
    procedure SetMarginBottom(Value : Integer);
    procedure SetMarginLeft(Value : Integer);
    procedure SetMarginRight(Value : Integer);
    procedure SetPeak(Value : Integer);
    procedure SetPeakColor(const Value : TColor);
    procedure SetShowValues(Value : Boolean);
    procedure SetStyle(Value : TOvcPmStyle);
    procedure SetValue(Value : Integer);
    {Event methods}

  public
    {VCL methods}
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    {public properties}


    property Peak : Integer
      read FPeak write SetPeak;

  published
    property BackgroundColor : TColor
      read FBackgroundColor write SetBackgroundColor default clBtnFace;
    property BarColor : TColor
      read FBarColor write SetBarColor default clBlue;

    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle default bsSingle;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D default True;

    property GridColor : TColor
      read FGridColor write SetGridColor default clBlack;
    property MarginBottom : Integer
      read FMarginBottom write SetMarginBottom default 10;
    property MarginLeft : Integer
      read FMarginLeft write SetMarginLeft default 10;
    property MarginRight : Integer
      read FMarginRight write SetMarginRight default 10;
    property MarginTop : Integer
      read FMarginTop write SetMarginTop default 10;
    property PeakColor : TColor
      read FPeakColor write SetPeakColor default clRed;
    property ShowValues : Boolean
      read FShowValues write SetShowValues default True;
    property Style : TOvcPmStyle
      read FStyle write SetStyle default pmBar;
    property Value : Integer
      read FValue write SetValue
      default 0;

    {inherited properties}
    property Anchors;
    property Constraints;
    property Align;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;

    {inherited events}
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

uses
  OvcFormatSettings;

function TIntToStr(L : Integer) : String;
var
  i,j : Integer;
begin
  Result := IntToStr(L);
  i := length(Result);
  j := 1;
  repeat
    Dec(i);
    Inc(j);
    if (j mod 3 = 0) and (i > 1) then
      Insert(FormatSettings.ThousandSeparator, Result, i);
  until i = 0;
end;

constructor TOvcPeakMeter.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque, csFramed];

  {defaults}
  FBorderStyle := bsSingle;
  FCtl3D := True;
  FBackgroundColor := clBtnFace;
  FBarColor := clBlue;
  FMarginBottom := 10;
  FMarginLeft := 10;
  FMarginRight := 10;
  FMarginTop := 10;
  FPeakColor := clRed;
  FShowValues := True;
  SetBounds(Left, Top, 80, 120);
end;

destructor TOvcPeakMeter.Destroy;
begin
  MemBM.Free;
  if HistorySize <> 0 then
    FreeMem(FHistory, sizeof(Integer) * HistorySize);
  inherited Destroy;
end;


procedure TOvcPeakMeter.ResizeHistory(NewSize: Integer);
var
  NewHistory: PIntArray;
  R, W : Integer;
begin
  if NewSize = HistorySize then
    exit;
  GetMem(NewHistory, sizeof(Integer) * NewSize);
  R := HistorySize - 1;
  W := NewSize - 1;
  while (R >= 0) and (W >= 0) do begin
    NewHistory^[W] := FHistory^[R];
    dec(R);
    dec(W);
  end;
  while (W >= 0) do begin
    NewHistory^[W] := -1;
    dec(W);
  end;
  if HistorySize <> 0 then
    FreeMem(FHistory, sizeof(Integer) * HistorySize);
  FHistory := NewHistory;
  HistorySize := NewSize;
end;

procedure TOvcPeakMeter.Paint;
var
  TextWd     : Integer;
  TextHt     : Integer;
  UsedLen    : Integer;
  UnusedLen  : Integer;
  MeterLen   : Integer;
  DividerPos : Integer;
  PeakPos    : Integer;
  XOff       : Integer;
  YOff       : Integer;
  ClRect     : TRect;
  ClWidth,
  ClHeight   : Integer;
  AxMax,TickSep,Tics : Integer;
  ScaleMargin,V,X,Y,i : Integer;
  S : string;
  OldColor : TColor;
  First : Boolean;

  procedure Scale(DataMax : Integer; var AxisMax,ScaleInc, ScalePoints : Integer);
  var
    M      : double;
    Ex     : integer;
    Mant   : double;
  begin
    Mant := 1.0;
    Ex := 0;
    if (DataMax < 10 ) then
      M := 1
    else
      if DataMax < 4 then
        repeat
          if Mant < 1 then
            Mant := 2
          else
            if Mant < 3 then
               Mant := 5
            else begin
              Mant := 1;
              Inc(Ex);
            end;
          M := Mant*EXP(LN(10)*Ex);
        until M*DataMax >= 4
      else
        repeat
          if Mant > 3.5 then
            Mant := 2.0
          else
            if Mant > 1.5 then
              Mant := 1.0
            else begin
              Mant := 5.0;
              Dec(Ex);
            end;
          M := Mant*exp(ln(10)*Ex);
        until M*DataMax < 10;
    ScalePoints := trunc(M*DataMax + 1.0);
    inc(ScalePoints);
    if (ScalePoints/M) < DataMax then
      Inc(ScalePoints);
    AxisMax := round(ScalePoints/M);
    ScaleInc := round(1 / M);
  end;

begin
  ClRect := ClientRect;

  if BorderStyle <> bsNone then begin
    if Ctl3D then begin
      Frame3D(Canvas, ClRect, clBtnShadow, clBtnHighlight, 1);
      Frame3D(Canvas, ClRect, clBlack, clBtnHighlight, 1);
    end else
      Frame3D(Canvas, ClRect, clBlack, clBlack, 1);
  end;

  ClWidth := ClRect.Right - CLRect.Left;
  ClHeight := ClRect.Bottom - ClRect.Top;
  XOff := ClRect.Left;
  YOff := ClRect.Top;
  Dec(ClRect.Right,ClRect.Left);
  ClRect.Left := 0;
  Dec(ClRect.Bottom,ClRect.Top);
  ClRect.Top := 0;

  if Peak{MaxScale} = 0 then
    exit;

  if (MemBM <> nil) and ((MemBM.Width <> ClWidth) or (MemBM.Height <> ClHeight)) then begin
    MemBM.Free;
    MemBM := nil;
  end;
  if MemBM = nil then begin
    MemBM            := TBitMap.Create;
    MemBM.Width      := ClWidth;
    MemBM.Height     := ClHeight;
  end;
  Scale(Peak,AxMax,TickSep,Tics);
  S := TIntToStr(AxMax);
  with MemBM.Canvas do begin
    Pen.Color := clBlack;
    Font.Color := Self.Font.Color;
    OldColor := Brush.Color;
    Brush.Color := BackgroundColor;
    FillRect(ClRect);
    Brush.Color := OldColor;
    if ShowValues then begin
      TextWd := TextWidth(S);
      ScaleMargin := TextWd + 10;
    end else
      ScaleMargin := 0;
    MeterLen := ClHeight - (MarginTop+MarginBottom);
    DividerPos := round((Integer(Value) * MeterLen / (AxMax-TickSep)));
    PeakPos := ClRect.Top + MarginTop + MeterLen - round((Integer(Peak) * MeterLen / (AxMax-TickSep)));
    UsedLen := DividerPos;
    UnusedLen := MeterLen - UsedLen;
    if ShowValues then
      X := ScaleMargin - 5
    else
      X := 0;
    Pen.Color := GridColor;
    Y := ClHeight - MarginBottom;
    MoveTo(ClWidth,Y);
    LineTo(X,Y);
    V := TickSep;
    S := '0';
    if ShowValues then begin
      TextHt := TextHeight(S);
      TextWd := TextWidth(S);
      Brush.Style := bsClear;
      Font := Self.Font;
      TextOut(X - TextWd - 2, Y - TextHt div 2, S);
      MoveTo(X,Y);
    end;
    for i := 1 to tics-1 do begin
      dec(Y,round(TickSep * MeterLen / (AxMax-TickSep)));
      if ShowValues then
        LineTo(X,Y)
      else
        MoveTo(X,Y);
      LineTo(ClWidth-1,Y);
      LineTo(X,Y);
      if ShowValues then begin
        Brush.Style := bsClear;
        S := TIntToStr(V);
        TextHt := TextHeight(S);
        TextWd := TextWidth(S);
        TextOut(X - TextWd - 2, Y - TextHt div 2, S);
        MoveTo(X,Y);
      end;
      inc(V,TickSep);
    end;
    case Style of
    pmBar :
      if (UsedLen > 0) then begin
        Brush.Color := BarColor;
        FillRect(Rect(ScaleMargin+MarginLeft, MarginTop + UnusedLen, ClWidth - MarginRight, ClHeight-MarginBottom));
      end;
    pmHistoryPoint :
      begin
        ResizeHistory(ClWidth - X - 1);
        Pen.Color := BarColor;
        First := True;
        if HistorySize > 0 then begin
          MoveTo(HistorySize + X, MarginTop + MeterLen - round((Integer(Value) * MeterLen / (AxMax-TickSep))));
          for i := 0 to pred(HistorySize) do
            if FHistory^[i] <> -1 then
              if First then begin
                MoveTo(X+i, MarginTop + MeterLen - round((Integer(FHistory^[i]) * MeterLen / (AxMax-TickSep))));
                First := False;
              end else
                LineTo(X+i, MarginTop + MeterLen - round((Integer(FHistory^[i]) * MeterLen / (AxMax-TickSep))));
          LineTo(HistorySize + X, MarginTop + MeterLen - round((Integer(Value) * MeterLen / (AxMax-TickSep))));
        end;
      end;
    end;
    if ShowValues then begin
      if Peak > 0 then begin
        Pen.Color := PeakColor;
        MoveTo(X+1, PeakPos);
        if Style = pmBar then
          LineTo(ClWidth - MarginRight, PeakPos)
        else
          LineTo(ClWidth, PeakPos)
      end;
    end else begin
      Pen.Color := PeakColor;
      if Style = pmBar then begin
        MoveTo(2, PeakPos);
        LineTo(5, PeakPos - 2);
        LineTo(5, PeakPos + 2);
        LineTo(2, PeakPos);
      end else begin
        MoveTo(0, PeakPos);
        LineTo(ClWidth, PeakPos)
      end;
    end;
  end;
  Canvas.Draw(XOff, YOff, MemBM);
end;

procedure TOvcPeakMeter.SetBarColor(const Value : TColor);
begin
  if (Value <> FBarColor) then begin
    FBarColor := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetBackgroundColor(const C : TColor);
begin
  if (C <> FBackgroundColor) then begin
    FBackgroundColor := C;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetCtl3D(const Value : Boolean);
begin
  if Value <> FCtl3D then begin
    FCtl3D := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetGridColor(const Value : TColor);
begin
  if (Value <> FGridColor) then begin
    FGridColor := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetMarginTop(Value : Integer);
begin
  if Value <> FMarginTop then begin
    FMarginTop := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetMarginBottom(Value : Integer);
begin
  if Value <> FMarginBottom then begin
    FMarginBottom := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetMarginLeft(Value : Integer);
begin
  if Value <> FMarginLeft then begin
    FMarginLeft := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetMarginRight(Value : Integer);
begin
  if Value <> FMarginRight then begin
    FMarginRight := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetPeak(Value : Integer);
begin
  if Value <> FPeak then begin
    FPeak := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetPeakColor(const Value : TColor);
begin
  if (Value <> FPeakColor) then begin
    FPeakColor := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetShowValues(Value : Boolean);
begin
  if Value <> FShowValues then begin
    FShowValues := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetStyle(Value : TOvcPmStyle);
begin
  if Value <> FStyle then begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TOvcPeakMeter.SetValue(Value : Integer);
var
  i : Integer;
begin
  case Style of
  pmBar :
    if Value <> FValue then begin
      FValue := Value;
      if Value > Peak then
        FPeak := Value;
      Invalidate;
    end;
  pmHistoryPoint :
    begin
      if FHistory <> nil then begin
        for i := 1 to pred(HistorySize) do
          FHistory^[i - 1] := FHistory^[i];
        FHistory^[HistorySize - 1] := FValue;
      end;
      FValue := Value;
      if Value > Peak then
        FPeak := Value;
      Invalidate;
    end;
  end;
end;

end.

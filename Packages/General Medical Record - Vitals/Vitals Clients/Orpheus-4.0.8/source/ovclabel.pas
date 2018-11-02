{*********************************************************}
{*                  OVCLABEL.PAS 4.06                    *}
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

unit ovclabel;
  {-label component}

interface

uses
  Windows, Classes, Controls, Graphics, Messages, StdCtrls, SysUtils,
  OvcMisc, OvcVer;

type
  {preset "looks"}
  TOvcAppearance = (apNone, apCustom, apFlying, apRaised, apSunken, apShadow);
  {preset color schemes}
  TOvcColorScheme = (csCustom, csText, csWindows, csEmbossed, csGold, csSteel);
  {options for varying the shadow/highlight for the label}
  TOvcGraduateStyle = (gsNone, gsHorizontal, gsVertical);
  {directions for shading (highlights and shadows)}
  TOvcShadeDirection = (sdNone, sdUp, sdUpRight, sdRight, sdDownRight, sdDown,
                        sdDownLeft, sdLeft, sdUpLeft);
  {options for varying the text of the label}
  TOvcShadeStyle = (ssPlain, ssExtrude, ssGraduated);

  TOvcDepth = 0..255;

const
  lblDefAppearance         = apRaised;
  lblDefAutoSize           = False;
  lblDefColorScheme        = csWindows;
  lblDefFontName           = 'Times New Roman';
  lblDefFontSize           = 20;
  lblDefGraduateFromColor  = clGray;
  lblDefGraduateStyle      = gsNone;
  lblDefHighlightColor     = clWhite;
  lblDefHighlightDepth     = 1;
  lblDefHighlightDirection = sdUpLeft;
  lblDefHighlightStyle     = ssPlain;
  lblDefShadowColor        = clBlack;
  lblDefShadowDepth        = 1;
  lblDefShadowDirection    = sdDownRight;
  lblDefShadowStyle        = ssPlain;
  lblDefTransparent        = True;
  lblDefWordWrap           = True;

type
  TOvcCustomSettings = class(TPersistent)
  private

    {property variables}
    FGraduateFromColor  : TColor;
    FGraduateStyle      : TOvcGraduateStyle;
    FHighlightColor     : TColor;
    FHighlightDepth     : TOvcDepth;
    FHighlightDirection : TOvcShadeDirection;
    FHighlightStyle     : TOvcShadeStyle;
    FShadowColor        : TColor;
    FShadowDepth        : TOvcDepth;
    FShadowDirection    : TOvcShadeDirection;
    FShadowStyle        : TOvcShadeStyle;

    {event variables}
    FOnColorChange      : TNotifyEvent;
    FOnStyleChange      : TNotifyEvent;

    {internal variables}
    FUpdating           : Boolean;

    {internal methods}
    procedure DoOnColorChange;
    procedure DoOnStyleChange;

    {property methods}
    procedure SetGraduateFromColor(Value : TColor);
    procedure SetGraduateStyle(Value : TOvcGraduateStyle);
    procedure SetHighlightColor(Value : TColor);
    procedure SetHighlightDepth(Value : TOvcDepth);
    procedure SetHighlightDirection(Value : TOvcShadeDirection);
    procedure SetHighlightStyle(Value : TOvcShadeStyle);
    procedure SetShadowColor(Value : TColor);
    procedure SetShadowDepth(Value : TOvcDepth);
    procedure SetShadowDirection(Value : TOvcShadeDirection);
    procedure SetShadowStyle(Value : TOvcShadeStyle);

  public
    procedure Assign(Source : TPersistent);
      override;

    procedure BeginUpdate;
    procedure EndUpdate;


    property OnColorChange : TNotifyEvent
      read FOnColorChange write FOnColorChange;
    property OnStyleChange : TNotifyEvent
      read FOnStyleChange write FOnStyleChange;


  published
    property GraduateFromColor : TColor
      read FGraduateFromColor write SetGraduateFromColor default lblDefGraduateFromColor;
    property GraduateStyle : TOvcGraduateStyle
      read FGraduateStyle write SetGraduateStyle default lblDefGraduateStyle;
    property HighlightColor : TColor
      read FHighlightColor write SetHighlightColor default lblDefHighlightColor;
    property HighlightDepth : TOvcDepth
      read FHighlightDepth write SetHighlightDepth default lblDefHighlightDepth;
    property HighlightDirection : TOvcShadeDirection
      read FHighlightDirection write SetHighlightDirection default lblDefHighlightDirection;
    property HighlightStyle : TOvcShadeStyle
      read FHighlightStyle write SetHighlightStyle default lblDefHighlightStyle;
    property ShadowColor : TColor
      read FShadowColor write SetShadowColor default lblDefShadowColor;
    property ShadowDepth : TOvcDepth
      read FShadowDepth write SetShadowDepth default lblDefShadowDepth;
    property ShadowDirection : TOvcShadeDirection
      read FShadowDirection write SetShadowDirection default lblDefShadowDirection;
    property ShadowStyle : TOvcShadeStyle
      read FShadowStyle write SetShadowStyle default lblDefShadowStyle;
  end;

  TOvcCustomLabel = class(TCustomLabel)

  protected {private}
    {property variables}
    FAppearance         : TOvcAppearance;
    FColorScheme        : TOvcColorScheme;
    FCustomSettings     : TOvcCustomSettings;

    {interal variables}
    eslSchemes          : array [TOvcColorScheme, (cpHighlight, cpShadow, cpFace)] of TColor;
    SettingColorScheme  : Boolean;
    SettingAppearance   : Boolean;

    {property methods}
    function GetAbout : string;
    function GetWordWrap : Boolean;
    procedure SetAppearance(Value : TOvcAppearance);
    procedure SetColorScheme(Value : TOvcColorScheme);
    procedure SetWordWrap(Value : Boolean);
    procedure SetAbout(const Value : string);

    {internal methods}
    procedure PaintPrim(CR : TRect; Flags : Word);
    procedure ColorChanged(Sender : TObject);
    procedure StyleChanged(Sender : TObject);

  protected
    procedure Paint;
      override;


    {protected properties} {can be published by descendants}
    property About : string
      read GetAbout write SetAbout stored False;
    property Appearance : TOvcAppearance
      read FAppearance write SetAppearance default lblDefAppearance;
    property ColorScheme : TOvcColorScheme
      read FColorScheme write SetColorScheme default lblDefColorScheme;
    property CustomSettings : TOvcCustomSettings
      read FCustomSettings write FCustomSettings;
    property WordWrap : Boolean
      read GetWordWrap write SetWordWrap default lblDefWordWrap;
  public

    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

{ - Hdc changed to TOvcHdc for BCB Compatibility }
    procedure PaintTo(DC : TOvcHdc{Hdc}; CR : TRect; Flags : Word);

    property AutoSize;

  end;

  TOvcLabel = class(TOvcCustomLabel)
  published
    {properties}
    property About;
    property Align;
    property Alignment;
    property Anchors;
    property Appearance;
    property Caption;
    property Color;
    property ColorScheme;
    property Cursor;
    property CustomSettings;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property ParentColor;
    property ParentFont default False;
    property ParentShowHint;
    property ShowAccelChar;
    property ShowHint;
    property Transparent
      default lblDefTransparent;
    property Visible;
    property WordWrap;

    {events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

{*** TOvcCustomSettings ***}

procedure TOvcCustomSettings.Assign(Source : TPersistent);
var
  LS : TOvcCustomSettings absolute Source;
begin
  if Assigned(Source) and (Source is TOvcCustomSettings) then begin
    FGraduateFromColor := LS.GraduateFromColor;
    FGraduateStyle := LS.GraduateStyle;
    FHighlightColor := LS.HighlightColor;
    FHighlightDepth := LS.HighlightDepth;
    FHighlightDirection := LS.HighlightDirection;
    FHighlightStyle := LS.HighlightStyle;
    FShadowColor := LS.ShadowColor;
    FShadowDepth := LS.ShadowDepth;
    FShadowDirection := LS.ShadowDirection;
    FShadowStyle := LS.ShadowStyle;
  end else
    inherited Assign(Source);
end;

procedure TOvcCustomSettings.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TOvcCustomSettings.EndUpdate;
begin
  FUpdating := False;
  DoOnColorChange;
  DoOnStyleChange;
end;

procedure TOvcCustomSettings.DoOnColorChange;
begin
  if not FUpdating and Assigned(FOnColorChange) then
    FOnColorChange(Self);
end;

procedure TOvcCustomSettings.DoOnStyleChange;
begin
  if not FUpdating and Assigned(FOnStyleChange) then
    FOnStyleChange(Self);
end;

procedure TOvcCustomSettings.SetGraduateFromColor(Value : TColor);
begin
  if Value <> FGraduateFromColor then begin
    FGraduateFromColor := Value;
    DoOnColorChange;
  end;
end;

procedure TOvcCustomSettings.SetGraduateStyle(Value : TOvcGraduateStyle);
begin
  if Value <> FGraduateStyle then begin
    FGraduateStyle := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetHighlightColor(Value : TColor);
begin
  if Value <> FHighlightColor then begin
    FHighlightColor := Value;
    DoOnColorChange;
  end;
end;

procedure TOvcCustomSettings.SetHighlightDepth(Value : TOvcDepth);
begin
  if Value <> FHighlightDepth then begin
    FHighlightDepth := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetHighlightDirection(Value : TOvcShadeDirection);
begin
  if Value <> FHighlightDirection then begin
    FHighlightDirection := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetHighlightStyle(Value : TOvcShadeStyle);
begin
  if Value <> FHighlightStyle then begin
    FHighlightStyle := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetShadowColor(Value : TColor);
begin
  if Value <> FShadowColor then begin
    FShadowColor := Value;
    DoOnColorChange;
  end;
end;

procedure TOvcCustomSettings.SetShadowDepth(Value : TOvcDepth);
begin
  if Value <> FShadowDepth then begin
    FShadowDepth := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetShadowDirection(Value : TOvcShadeDirection);
begin
  if Value <> FShadowDirection then begin
    FShadowDirection := Value;
    DoOnStyleChange;
  end;
end;

procedure TOvcCustomSettings.SetShadowStyle(Value : TOvcShadeStyle);
begin
  if Value <> FShadowStyle then begin
    FShadowStyle := Value;
    DoOnStyleChange;
  end;
end;


{*** TOvcCustomLabel ***}

constructor TOvcCustomLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  eslSchemes[csWindows, cpHighlight] := lblDefHighlightColor;
  eslSchemes[csWindows, cpFace] := clGray;
  eslSchemes[csWindows, cpShadow] := lblDefShadowColor;

  eslSchemes[csText, cpHighlight] := clWhite;
  eslSchemes[csText, cpFace] := clBlack;
  eslSchemes[csText, cpShadow] := clGray;

  eslSchemes[csEmbossed, cpHighlight] := clWhite;
  eslSchemes[csEmbossed, cpFace] := clSilver;
  eslSchemes[csEmbossed, cpShadow] := clBlack;

  eslSchemes[csGold, cpHighlight] := clYellow;
  eslSchemes[csGold, cpFace] := clOlive;
  eslSchemes[csGold, cpShadow] := clBlack;

  eslSchemes[csSteel, cpHighlight] := clAqua;
  eslSchemes[csSteel, cpFace] := clTeal;
  eslSchemes[csSteel, cpShadow] := clNavy;

  eslSchemes[csCustom, cpHighlight] := eslSchemes[csWindows,cpHighlight];
  eslSchemes[csCustom, cpFace] := eslSchemes[csWindows,cpFace];
  eslSchemes[csCustom, cpShadow] := eslSchemes[csWindows,cpShadow];

  {initialize defaults}
  FAppearance                         := lblDefAppearance;
  FColorScheme                        := lblDefColorScheme;
  FCustomSettings                     := TOvcCustomSettings.Create;
  FCustomSettings.FGraduateFromColor  := lblDefGraduateFromColor;
  FCustomSettings.FGraduateStyle      := lblDefGraduateStyle;
  FCustomSettings.FHighlightColor     := eslSchemes[csWindows, cpHighlight];
  FCustomSettings.FHighlightDepth     := lblDefHighlightDepth;
  FCustomSettings.FHighlightDirection := lblDefHighlightDirection;
  FCustomSettings.FHighlightStyle     := lblDefHighlightStyle;
  FCustomSettings.FShadowColor        := eslSchemes[csWindows, cpShadow];
  FCustomSettings.FShadowDepth        := lblDefShadowDepth;
  FCustomSettings.FShadowDirection    := lblDefShadowDirection;
  FCustomSettings.FShadowStyle        := lblDefShadowStyle;
  FCustomSettings.OnColorChange       := ColorChanged;
  FCustomSettings.OnStyleChange       := StyleChanged;

  AutoSize            := lblDefAutoSize;
  Height              := 35;
  Width               := 150;
  Transparent         := lblDefTransparent;
  Font.Name           := lblDefFontName;
  Font.Size           := lblDefFontSize;
  Font.Color          := eslSchemes[FColorScheme, cpFace];
  WordWrap            := lblDefWordWrap;

  SettingColorScheme  := False;
  SettingAppearance   := False;
end;

destructor TOvcCustomLabel.Destroy;
begin
  FCustomSettings.Free;
  FCustomSettings := nil;

  inherited Destroy;
end;

function TOvcCustomLabel.GetAbout : string;
begin
  Result := OrVersionStr;
end;

function TOvcCustomLabel.GetWordWrap : Boolean;
begin
  Result := inherited WordWrap;
end;

procedure TOvcCustomLabel.Paint;
const
  Alignments : array [TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  Wrap : array[Boolean] of Word = (0, DT_WORDBREAK);
  Prefix : array[Boolean] of Word = (DT_NOPREFIX, 0);
begin
  PaintPrim(ClientRect, Wrap[WordWrap] or DT_EXPANDTABS or
                      Alignments[Alignment] or Prefix[ShowAccelChar]);
end;

procedure TOvcCustomLabel.PaintPrim(CR : TRect; Flags : Word);
const
  DrawingOffset : array [TOvcShadeDirection, (ioX, ioY)] of -1..1 =
      ((0,0),(0,-1),(+1,-1),(+1,0),(+1,+1),(0,+1),(-1,+1),(-1,0),(-1,-1));
  BandCount = 16;
var
  I          : Integer;
  MinOffset  : Integer;
  MaxOffset  : Integer;
  IX, IY     : Integer;
  IU, IV     : Integer;
  Limit      : Integer;
  Adjustment : Integer;
  AdjustR    : Double;
  AdjustG    : Double;
  AdjustB    : Double;
  Step       : Double;
  RctTemp    : TRect;
  FromR      : Byte;
  FromG      : Byte;
  FromB      : Byte;
  ToR        : Byte;
  ToG        : Byte;
  ToB        : Byte;
  BmpTemp    : TBitmap;
  BmpWork    : TBitmap;
  CnvWork    : TCanvas;
  Buf        : PChar;
begin
  if not Assigned(FCustomSettings) then
    Exit;

  {get offsets based on shadow and highlight directions and depths}
  MinOffset := MinI(MinI(MinI(MinI(DrawingOffset[FCustomSettings.HighlightDirection, ioX] * FCustomSettings.HighlightDepth,
               DrawingOffset[FCustomSettings.ShadowDirection, ioX] * FCustomSettings.ShadowDepth),
               DrawingOffset[FCustomSettings.HighlightDirection, ioY] * FCustomSettings.HighlightDepth),
               DrawingOffset[FCustomSettings.ShadowDirection, ioY] * FCustomSettings.ShadowDepth), 0);
  MaxOffset := MaxI(MaxI(MaxI(MaxI(DrawingOffset[FCustomSettings.HighlightDirection, ioX] * FCustomSettings.HighlightDepth,
               DrawingOffset[FCustomSettings.ShadowDirection, ioX] * FCustomSettings.ShadowDepth),
               DrawingOffset[FCustomSettings.HighlightDirection, ioY] * FCustomSettings.HighlightDepth),
               DrawingOffset[FCustomSettings.ShadowDirection, ioY] * FCustomSettings.ShadowDepth), 0);

  if Flags and DT_CENTER <> 0 then
    Adjustment := (MaxOffset - MinOffset) div 2
  else if Flags and DT_RIGHT <> 0 then
    Adjustment := MaxOffset - MinOffset
  else
    Adjustment := 0;

  {create temporary drawing surfaces}
  BmpTemp := TBitmap.Create;
  BmpWork := TBitmap.Create;
  try
    BmpTemp.Height := CR.Bottom-CR.Top;
    BmpTemp.Width := CR.Right-CR.Left;
    BmpTemp.Canvas.Font := Self.Font;

    BmpWork.Height := CR.Bottom-CR.Top;
    BmpWork.Width := CR.Right-CR.Left;
    BmpWork.Canvas.Font := Self.Font;

    {get copy of our canvas}
    BmpWork.Canvas.CopyRect(CR, Self.Canvas, CR);

    {set starting point for text - IX, IY}
    IX := 0; IY := 0;
    if not Transparent then begin
      BmpWork.Canvas.Brush.Color := Self.Color;
      BmpWork.Canvas.Brush.Style := bsSolid;
      BmpWork.Canvas.FillRect(CR);
    end;
    BmpWork.Canvas.Brush.Style := bsClear;

    Buf := StrAlloc(GetTextLen+1);
    try
      {get label's caption}
      GetTextBuf(Buf, GetTextLen+1);

      {prepare for extruding shadow, if requested}
      GetRGB(FCustomSettings.ShadowColor, FromR, FromG, FromB);
      AdjustR := 0;
      AdjustG := 0;
      AdjustB := 0;
      Limit := FCustomSettings.ShadowDepth;
      if (FCustomSettings.ShadowStyle <> ssPlain) and (FCustomSettings.ShadowDepth > 1) then begin
        Limit := 1;
        {find changes in RGB colors}
        if FCustomSettings.ShadowStyle = ssGraduated then begin
          GetRGB(Font.Color, ToR, ToG, ToB);
          AdjustR := (ToR - FromR) / (FCustomSettings.ShadowDepth - 1);
          AdjustG := (ToG - FromG) / (FCustomSettings.ShadowDepth - 1);
          AdjustB := (ToB - FromB) / (FCustomSettings.ShadowDepth - 1);
        end;
      end;
      CnvWork := BmpWork.Canvas;

      {process for each copy of the shadow}
      for I := FCustomSettings.ShadowDepth downto Limit do begin
        CnvWork.Font.Color :=
          RGB(FromR + Round(AdjustR * (FCustomSettings.ShadowDepth - I)),
              FromG + Round(AdjustG * (FCustomSettings.ShadowDepth - I)),
              FromB + Round(AdjustB * (FCustomSettings.ShadowDepth - I)));
        {create a rect that is offset for the shadow}
        RctTemp:= Rect(
          CR.Left - MinOffset -Adjustment + DrawingOffset[FCustomSettings.ShadowDirection, ioX] * I,
          CR.Top - MinOffset + DrawingOffset[FCustomSettings.ShadowDirection, ioY] * I,
          CR.Right - MinOffset - Adjustment + DrawingOffset[FCustomSettings.ShadowDirection, ioX] * I,
          CR.Bottom - MinOffset + DrawingOffset[FCustomSettings.ShadowDirection, ioY] * I);
        {draw shadow text with alignment}
        DrawText(CnvWork.Handle, Buf, StrLen(Buf), RctTemp, Flags);
      end;

      {prepare for extruding highlight, if requested}
      GetRGB(FCustomSettings.HighlightColor, FromR, FromG, FromB);
      AdjustR := 0;
      AdjustG := 0;
      AdjustB := 0;
      Limit := FCustomSettings.HighlightDepth;
      if (FCustomSettings.HighlightStyle <> ssPlain) and (FCustomSettings.HighlightDepth > 1) then begin
        Limit := 1;
        if FCustomSettings.HighlightStyle = ssGraduated then begin {find changes in RGB Colors}
          GetRGB(Font.Color, ToR, ToG, ToB);
          AdjustR := (ToR - FromR) / (FCustomSettings.HighlightDepth - 1);
          AdjustG := (ToG - FromG) / (FCustomSettings.HighlightDepth - 1);
          AdjustB := (ToB - FromB) / (FCustomSettings.HighlightDepth - 1);
        end;
      end;

      CnvWork := BmpWork.Canvas;

      {process for each copy of the highlight}
      for I := FCustomSettings.HighlightDepth downto Limit do begin
        CnvWork.Font.Color :=
          RGB(FromR + Round(AdjustR * (FCustomSettings.HighlightDepth - I)),
              FromG + Round(AdjustG * (FCustomSettings.HighlightDepth - I)),
              FromB + Round(AdjustB * (FCustomSettings.HighlightDepth - I)));
        {create a rect that is offset for the highlight}
        RctTemp:= Rect(
          CR.Left - MinOffset - Adjustment + DrawingOffset[FCustomSettings.HighlightDirection, ioX] * I,
          CR.Top - MinOffset + DrawingOffset[FCustomSettings.HighlightDirection, ioY] * I,
          CR.Right - MinOffset - Adjustment + DrawingOffset[FCustomSettings.HighlightDirection, ioX] * I,
          CR.Bottom - MinOffset + DrawingOffset[FCustomSettings.HighlightDirection, ioY] * I);
        {draw highlight text with alignment}
        DrawText(CnvWork.Handle, Buf, StrLen(Buf), RctTemp, Flags);
      end;

      if FCustomSettings.GraduateStyle <> gsNone then begin
        {copy original canvas to work area}
        BmpTemp.Canvas.CopyRect(CR, BmpWork.Canvas, CR);
        {choose an unusual color}
        BmpTemp.Canvas.Font.Color := $00FE09F1;
        BmpTemp.Canvas.Brush.Style := bsClear;
        CnvWork := BmpTemp.Canvas;
      end else begin
        BmpWork.Canvas.Font.Color := Font.Color;  {restore original font Color}
        CnvWork := BmpWork.Canvas;
      end;

      {create a rect that is offset for the original text}
      RctTemp:= Rect(CR.Left - MinOffset - Adjustment,
                     CR.Top - MinOffset,
                     CR.Right - MinOffset - Adjustment,
                     CR.Bottom - MinOffset);

      {draw original text with alignment}
      DrawText(CnvWork.Handle, Buf, StrLen(Buf), RctTemp, Flags);
    finally
      StrDispose(Buf);
    end;

    if FCustomSettings.GraduateStyle <> gsNone then begin
      {transfer graduations from temporary canvas}
      {calculate start point and extent}
      Limit := BmpWork.Canvas.TextWidth(Caption);
      IV := IY - MinOffset;

      if Flags and DT_CENTER <> 0 then
        IU := (CR.Right-CR.Left - Limit) div 2 - MinOffset - Adjustment
      else if Flags and DT_RIGHT <> 0 then
        IU := CR.Bottom-CR.Top - MaxOffset - Limit
      else
        IU := IX - MinOffset;

      if FCustomSettings.GraduateStyle = gsVertical then
        Limit := CR.Bottom-CR.Top-1
      else
        Dec(Limit);

      {calculate change in color at each step}
      GetRGB(FCustomSettings.GraduateFromColor, FromR, FromG, FromB);
      GetRGB(Font.Color, ToR, ToG, ToB);
      AdjustR := (ToR - FromR) / Pred(BandCount);
      AdjustG := (ToG - FromG) / Pred(BandCount);
      AdjustB := (ToB - FromB) / Pred(BandCount);

      Step := Limit / Pred(BandCount);

      {and draw it onto the canvas}
      BmpWork.Canvas.Brush.Style := bsSolid;
      for I := 0 to Pred(BandCount) do begin
        BmpWork.Canvas.Brush.Color := RGB(FromR + Round(AdjustR * I),
                                          FromG + Round(AdjustG * I),
                                          FromB + Round(AdjustB * I));
        if FCustomSettings.GraduateStyle = gsVertical then
          RctTemp := Rect(0, IV + Round(I*Step), CR.Right-CR.Left, IV + Round((I+1)*Step))
        else
          RctTemp := Rect(IU + Round(I*Step), 0, IU + Round((I+1)*Step), CR.Bottom-CR.Top);
        BmpWork.Canvas.BrushCopy(RctTemp, BmpTemp, RctTemp, BmpTemp.Canvas.Font.Color);
      end;
    end;

    Canvas.CopyRect(CR, BmpWork.Canvas, CR);
  finally
    BmpTemp.Free;
    BmpWork.Free;
  end;
end;

{ - Hdc changed to TOvcHdc for BCB compatibility}
procedure TOvcCustomLabel.PaintTo(DC : TOvcHdc {Hdc}; CR : TRect; Flags : Word);
begin
  Canvas.Handle := DC;
  try
    if not Transparent then begin
      Canvas.Brush.Color := Self.Color;
      Canvas.Brush.Style := bsSolid;
      {clear complete client area}
      Canvas.FillRect(Rect(0, 0, CR.Right, CR.Bottom));
    end;
    Canvas.Brush.Style := bsClear;
    PaintPrim(CR, Flags)
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TOvcCustomLabel.SetAppearance(Value : TOvcAppearance);
begin
  if FAppearance <> Value then begin
    SettingAppearance := True;
    try
      FAppearance := Value;
      FCustomSettings.BeginUpdate;
      try
        FCustomSettings.HighlightColor := eslSchemes[ColorScheme,cpHighlight];
        case FAppearance of
          apRaised:
            begin
              FCustomSettings.HighlightDirection := sdUpLeft;
              FCustomSettings.ShadowDirection := sdDownRight;
              FCustomSettings.HighlightDepth := 1;
              FCustomSettings.ShadowDepth := 1;
            end;
          apSunken:
            begin
              FCustomSettings.HighlightDirection := sdDownRight;
              FCustomSettings.ShadowDirection := sdUpLeft;
              FCustomSettings.HighlightDepth := 1;
              FCustomSettings.ShadowDepth := 1;
            end;
          apShadow:
            begin
              FCustomSettings.HighlightDirection := sdNone;
              FCustomSettings.ShadowDirection := sdDownRight;
              FCustomSettings.HighlightDepth := 0;
              FCustomSettings.ShadowDepth := 2;
            end;
          apFlying:
            begin
              FCustomSettings.HighlightDirection := sdDownRight;
              FCustomSettings.ShadowDirection := sdDownRight;
              FCustomSettings.HighlightDepth :=1;
              FCustomSettings.ShadowDepth :=5;
              {flying has two shadows}
              FCustomSettings.HighlightColor := eslSchemes[ColorScheme, cpShadow];
            end;
          apNone:
            begin
              FCustomSettings.HighlightDirection := sdNone;
              FCustomSettings.ShadowDirection := sdNone;
              FCustomSettings.HighlightDepth :=0;
              FCustomSettings.ShadowDepth :=0;
            end;
        end;
      finally
        FCustomSettings.EndUpdate;
      end;
    finally
      SettingAppearance := False;
      Perform(CM_TEXTCHANGED, 0, 0);
    end;
  end;
end;

procedure TOvcCustomLabel.SetColorScheme(Value : TOvcColorScheme);
begin
  if FColorScheme <> Value then begin
    SettingColorScheme := True;
    try
      FColorScheme := Value;
      FCustomSettings.BeginUpdate;
      try
        FCustomSettings.HighlightColor := eslSchemes[FColorScheme, cpHighlight];
        Font.Color := eslSchemes[FColorScheme, cpFace];
        FCustomSettings.ShadowColor := eslSchemes[FColorScheme, cpShadow];
        if FColorScheme <> csCustom then begin
          eslSchemes[csCustom, cpHighlight] := eslSchemes[FColorScheme, cpHighlight];
          eslSchemes[csCustom, cpFace] := eslSchemes[FColorScheme, cpFace];
          eslSchemes[csCustom, cpShadow] := eslSchemes[FColorScheme, cpShadow];
        end;
      finally
        FCustomSettings.EndUpdate;
      end;
    finally
      SettingColorScheme := False;
      Perform(CM_TEXTCHANGED, 0, 0);
    end;
  end;
end;

procedure TOvcCustomLabel.ColorChanged(Sender : TObject);
begin
  if csLoading in ComponentState then
    Exit;

  Invalidate;

  if not SettingColorScheme then
    FColorScheme := csCustom;

  if not SettingColorScheme then
    Perform(CM_COLORCHANGED, 0, 0);
end;

procedure TOvcCustomLabel.StyleChanged(Sender : TObject);
begin
  if csLoading in ComponentState then
    Exit;

  Invalidate;

  if not SettingAppearance then begin
    FAppearance := apCustom;
    Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

procedure TOvcCustomLabel.SetAbout(const Value : string);
begin
end;

procedure TOvcCustomLabel.SetWordWrap(Value : Boolean);
begin
  if Value <> WordWrap then begin
    inherited WordWrap := Value;
    Invalidate;
  end;
end;

end.

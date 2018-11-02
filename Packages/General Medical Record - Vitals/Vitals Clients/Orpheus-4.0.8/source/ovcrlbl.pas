{*********************************************************}
{*                  OVCRLBL.PAS 4.06                    *}
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
{*    Sebastian Zierer (Unicode Version)                                      *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcrlbl;
  {-Rotated label component}

interface

uses
  Windows, Classes, Controls, Graphics, Messages, SysUtils,
  OvcBase, OvcMisc;

type
  TOvcCustomRotatedLabel = class(TOvcGraphicControl)

  protected {private}
    {property instance variables}
    FAlignment      : TAlignment;
    FAutoSize       : Boolean;
    FCaption        : string;
    FFontAngle      : Integer;
    FOriginX        : Integer;
    FOriginY        : Integer;
    FShadowColor    : TColor;       {color for text shadowing}
    FShadowedText   : Boolean;      {true to draw shadowed text}

    {internal variables}
    rlBusy          : Boolean;

    {property methods}
    function GetTransparent : Boolean;
    procedure SetAlignment(Value : TAlignment);
    procedure SetAutoSize(Value : Boolean); override;
    procedure SetCaption(const Value : string);
    procedure SetOriginX(Value : Integer);
    procedure SetOriginY(Value : Integer);
    procedure SetShadowColor(const Value : TColor);
    procedure SetShadowedText(Value : Boolean);
    procedure SetTransparent(Value : Boolean);
    procedure SetFontAngle(Value : Integer);

    {internal methods}
    procedure lblAdjustSize;
      {-adjust horizontal and/or vertical size of control}
    procedure lblDrawText(var R : TRect; Flags : Word);
      {-draw the label text}

    {VCL message handling methods}
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;
    procedure CMTextChanged(var Mes : TMessage);
      message CM_TEXTCHANGED;

  protected
    procedure Loaded;
      override;
    procedure Paint;
      override;
    procedure SetName(const NewName : TComponentName);
      override;


    property Alignment : TAlignment
      read FAlignment write SetAlignment;
    property AutoSize : Boolean
      read FAutoSize write SetAutoSize;
    property Caption : string
      read FCaption write SetCaption;
    property FontAngle : Integer
      read FFontAngle write SetFontAngle;
    property OriginX : Integer
      read FOriginX write SetOriginX;
    property OriginY : Integer
      read FOriginY write SetOriginY;
    property ShadowColor : TColor
      read FShadowColor write SetShadowColor;
    property ShadowedText : Boolean
      read FShadowedText write SetShadowedText;
    property Transparent  : Boolean
      read GetTransparent write SetTransparent;

  public

    constructor Create(AOwner: TComponent);
      override;


    {public properties}
    property Canvas;
  end;

  TOvcRotatedLabel = class(TOvcCustomRotatedLabel)
  published
    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property Alignment default taLeftJustify;
    property AutoSize;
    property Caption;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property FontAngle default 0;
    property Height default 20;
    property OriginX default 0;
    property OriginY default 0;
    property ParentColor;
    {property ParentFont;}
    property ParentShowHint;
    property PopupMenu;
    property ShadowColor default clBtnShadow;
    property ShadowedText;
    property ShowHint;
    property Transparent default False;
    property Visible;

    {events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

{*** TOvcCustomRotatedLabel ***}

procedure TOvcCustomRotatedLabel.CMFontChanged(var Msg : TMessage);
var
  TM  : TTextMetric;
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if FFontAngle <> 0 then begin
    {check if the current font can be rotated}
    Canvas.Font := Self.Font;
    GetTextMetrics(Canvas.Handle, TM);
    if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
      {force zero font angle}
      FontAngle := 0;
  end;
  lblAdjustSize;
end;

procedure TOvcCustomRotatedLabel.CMTextChanged(var Mes : TMessage);
begin
  lblAdjustSize;
end;

constructor TOvcCustomRotatedLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable, csOpaque];

  {default property values}
  FAlignment      := taLeftJustify;
  FFontAngle      := 0;
  FOriginX        := 0;
  FOriginY        := 0;
  FShadowColor    := clBtnShadow;
  FShadowedText   := False;

  Font.Name       := 'Arial';
  Height          := 20;
  Width           := 130;

  if csDesigning in ComponentState then
    lblAdjustSize;
end;

function TOvcCustomRotatedLabel.GetTransparent : Boolean;
begin
  Result := not (csOpaque in ControlStyle);
end;

procedure TOvcCustomRotatedLabel.lblAdjustSize;
  {-adjust horizontal and/or vertical size of control}
var
  R  : TRect;
  W, H, X, Y : Integer;
begin
  if rlBusy then {avoid reentrance}
    Exit;

  rlBusy := True;
  try
    if not (csLoading in ComponentState) and AutoSize then begin
      R := ClientRect;
      Canvas.Font := Font;
      W := Canvas.TextWidth(Caption);
      H := Canvas.TextHeight(Caption);
      if FFontAngle <> 0 then begin
        {adjust height and width as necessary}
        {width (X) of text at new angle}
        X := Round(W * Cos(FFontAngle*Pi/180));
        {height (y) of text at new angle}
        Y := Round(W * Sin(FFontAngle*Pi/180));
        R.Bottom := Abs(Y) + 2*H;
        R.Right := Abs(X) + 2*H;
        if X < 0 then
          FOriginX := R.Right-H
        else
          FOriginX := H;
        if Y < 0 then
          FOriginY := H
        else begin
          if X < 0 then
            FOriginY := R.Bottom - H
          else
            FOriginY := R.Bottom - H - H div 2;
        end;
      end else begin
        FOriginX := 0;
        FOriginY := 0;
        R.Right := W;
        R.Bottom := H;
      end;

      SetBounds(Left, Top, R.Right, R.Bottom);
    end;
  finally
    rlBusy := False;
  end;
end;

procedure TOvcCustomRotatedLabel.lblDrawText(var R : TRect; Flags : Word);
  {-paint the controls display or calculate a TRect to fit text}
var
  HoldColor : TColor;
  T         : string;
  XO, YO    : Integer;
  A         : Integer;
  Buf       : PChar; //array[0..255] of Char;
  Len       : Integer;
begin
  T := Caption;
  if (Flags and DT_CALCRECT <> 0) and (T = '') then
    T := ' ';

  Flags := Flags or DT_NOPREFIX;

  {use our font}
  Canvas.Font := Font;

  {create the rotated font}
  if FFontAngle <> 0 then
    Canvas.Font.Handle := CreateRotatedFont(Font, FFontAngle);

  {force disabled text color, if not enabled}
  if not Enabled then
    Canvas.Font.Color := clGrayText;

  {draw the text}
  //StrPLCopy(Buf, T, 255);
  Len := Length(T);
  if DT_MODIFYSTRING and Flags <> 0 then
    Inc(Len, 4);   // this could add up to 4 characters
  Buf := StrAlloc(Len + 1);
  try
    StrPCopy(Buf, T);
    if FFontAngle = 0 then begin
      {draw shadow first, if selected}
      if FShadowedText then begin
        HoldColor := Canvas.Font.Color;
        Canvas.Font.Color := FShadowColor;
        if not Transparent then begin
          SetBkMode(Canvas.Handle, OPAQUE);
          Canvas.Brush.Color := Color;
        end;
        OffsetRect(R, +2, +1);
        DrawText(Canvas.Handle, Buf, -1, R, Flags);
        Canvas.Font.Color := HoldColor;
        SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
        OffsetRect(R, -2, -1);
        DrawText(Canvas.Handle, Buf, -1, R, Flags);
      end else begin
        DrawText(Canvas.Handle, Buf, -1, R, Flags)
      end;
    end else begin
      if FShadowedText then begin
        HoldColor := Canvas.Font.Color;
        Canvas.Font.Color := FShadowColor;
        if not Transparent then begin
          SetBkMode(Canvas.Handle, Windows.OPAQUE);
          Canvas.Brush.Color := Color;
        end;
        {calculate the shadow offset based on the quadrant the text is in}
        {        |          }  { 1 -- X+2, Y+1}
        {     2  |  1       }  { 2 -- X-1, Y-2}
        { -------+--------- }  { 3 -- X+2, Y+1}
        {     3  |  4       }  { 4 -- X-1, Y-2}
        {        |          }
        A := FFontAngle;
        if A < 0 then A := 360 + A;
        if A >= 270 then begin
          XO :=  2; YO :=  1;  {Quad=4}
        end else if A >= 180 then begin
          XO :=  2; YO :=  1;  {Quad=3}
        end else if A >= 90 then begin
          XO :=  2; YO :=  1;  {Quad=2}
        end else begin
          XO :=  2; YO :=  1;  {Quad=1}
        end;
        ExtTextOut(Canvas.Handle, OriginX+XO, OriginY+YO, ETO_CLIPPED,
          @R, Buf, StrLen(Buf), nil);
        Canvas.Font.Color := HoldColor;
        SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
        ExtTextOut(Canvas.Handle, OriginX, OriginY, ETO_CLIPPED,
          @R, Buf, StrLen(Buf), nil);
      end else begin
        ExtTextOut(Canvas.Handle, OriginX, OriginY, ETO_CLIPPED,
          @R, Buf, StrLen(Buf), nil);
      end;
    end;
  finally
    StrDispose(Buf);
  end;
end;

procedure TOvcCustomRotatedLabel.Loaded;
begin
  inherited Loaded;

  lblAdjustSize;
end;

procedure TOvcCustomRotatedLabel.Paint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  R : TRect;
begin
  R := ClientRect;
  with Canvas do begin
    if not Transparent then begin
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      FillRect(R);
    end;
    Brush.Style := bsClear;
    lblDrawText(R, Alignments[FAlignment])
  end;
end;

procedure TOvcCustomRotatedLabel.SetAlignment(Value : TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetAutoSize(Value : Boolean);
begin
  if Value <> FAutoSize then begin
    FAutoSize := Value;
    lblAdjustSize;
  end;
end;

procedure TOvcCustomRotatedLabel.SetCaption(const Value : string);
begin
  if Value <> FCaption then begin
    FCaption := Value;
    lblAdjustSize;
    Repaint;
  end;
end;

procedure TOvcCustomRotatedLabel.SetOriginX(Value : Integer);
begin
  if Value <> FOriginX then begin
    FOriginX := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetOriginY(Value : Integer);
begin
  if Value <> FOriginY then begin
    FOriginY := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetShadowColor(const Value : TColor);
begin
  if Value <> FShadowColor then begin
    FShadowColor := Value;
    invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetShadowedText(Value : Boolean);
begin
  if Value <> FShadowedText then begin
    FShadowedText := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetTransparent(Value : Boolean);
begin
  if Transparent <> Value then begin
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetFontAngle(Value : Integer);
var
  Neg : Integer;
  TM  : TTextMetric;
begin
  if Value <> FFontAngle then begin
    {check if the current font can be rotated}
    if not (csLoading in ComponentState) then begin
      if Value <> 0 then begin
        Canvas.Font := Font;
        GetTextMetrics(Canvas.Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          {force true-type font}
          Font.Name := 'Arial';
      end;
    end;
    if Value < 0 then Neg := -1 else Neg := 1;
    FFontAngle := (Abs(Value) mod 360) * Neg;

    lblAdjustSize;

    {repaint with new font}
    Invalidate;
  end;
end;

procedure TOvcCustomRotatedLabel.SetName(const NewName : TComponentName);
begin
  inherited SetName(NewName);
  if (csDesigning in ComponentState) and (FCaption = '') then
    FCaption := Self.Name;
end;


end.

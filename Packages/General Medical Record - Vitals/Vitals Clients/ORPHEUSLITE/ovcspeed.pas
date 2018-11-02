{*********************************************************}
{*                  OVCSPEED.PAS 4.06                    *}
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

unit ovcspeed;
  {-speed button}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Graphics, Forms,
  {$IFDEF VERSION4} ActnList, ImgList, {$ENDIF} Messages, SysUtils,
  OvcBase, OvcMisc;

type
  TOvcButtonState = (obsUp, obsDown, obsInactive, obsDisabled);

  TOvcCustomSpeedButton = class(TOvcGraphicControl)
  {.Z+}
  protected {private}
    {property variables}
    FAutoRepeat      : Boolean;
    FFlat            : Boolean;
    FGlyph           : Pointer;
    FGrayedInactive  : Boolean;
    FRepeatDelay     : Integer;
    FLayout          : TButtonLayout;
    FMargin          : Integer;
    FRepeatInterval  : Integer;
    FSpacing         : Integer;
    FStyle           : TButtonStyle;
    FTransparent     : Boolean;

    {internal variables}
    sbDown           : Boolean;
    sbDrawBM         : TBitmap;
    sbMouseInControl : Boolean;
    sbRepeatTimer    : TTimer;
    sbState          : TOvcButtonState;

    {property methods}
    function GetGlyph : TBitmap;
    function GetNumGlyphs : Integer;
    function GetWordWrap : Boolean;
    procedure SetAutoRepeat(Value : Boolean);
    procedure SetFlat(Value : Boolean);
    procedure SetGlyph(Value : TBitmap);
    procedure SetGrayedInactive(Value : Boolean);
    procedure SetLayout(Value : TButtonLayout);
    procedure SetMargin(Value : Integer);
    procedure SetNumGlyphs(Value : Integer);
    procedure SetSpacing(Value : Integer);
    procedure SetStyle(Value : TButtonStyle);
    procedure SetTransparent(Value : Boolean);
    procedure SetWordWrap(Value : Boolean);

    {internal methods}
    procedure GlyphChanged(Sender : TObject);
    procedure UpdateTracking;
    procedure TimerExpired(Sender : TObject);
    procedure DoMouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);

    {vcl message methods}
    procedure CMDialogChar(var Message : TCMDialogChar);
      message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message : TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message : TMessage);
      message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message : TMessage);
      message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message : TMessage);
      message CM_MOUSELEAVE;
    procedure CMSysColorChange(var Message : TMessage);
      message CM_SYSCOLORCHANGE;
    procedure CMTextChanged(var Message : TMessage);
      message CM_TEXTCHANGED;

    {windows message methods}
    procedure WMLButtonDblClk(var Message : TWMLButtonDown);
      message WM_LBUTTONDBLCLK;
    procedure WMRButtonDown(var Message : TWMRButtonDown);
      message WM_RBUTTONDOWN;
    procedure WMRButtonUp(var Message : TWMRButtonUp);
      message WM_RBUTTONUP;

  protected
    {$IFDEF VERSION4}
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean);
      override;
    {$ENDIF}
    function GetPalette : hPalette;
      override;
    procedure Loaded;
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Paint;
      override;
  {.Z-}

    {protected properties}
    property AutoRepeat : Boolean
      read FAutoRepeat write SetAutoRepeat;
    property Flat : Boolean
      read FFlat write SetFlat;
    property Glyph : TBitmap
      read GetGlyph write SetGlyph;
    property GrayedInactive : Boolean
      read FGrayedInactive write SetGrayedInactive;
    property Layout : TButtonLayout
      read FLayout write SetLayout;
    property Margin : Integer
      read FMargin write SetMargin;
    property NumGlyphs : Integer
      read GetNumGlyphs write SetNumGlyphs;
    property RepeatDelay : Integer
      read FRepeatDelay write FRepeatDelay;
    property RepeatInterval : Integer
      read FRepeatInterval write FRepeatInterval;
    property Spacing : Integer
      read FSpacing write SetSpacing;
    property Style : TButtonStyle
      read FStyle write SetStyle;
    property Transparent : Boolean
      read FTransparent write SetTransparent;
    property WordWrap : Boolean
      read GetWordWrap write SetWordWrap;

  public
  {.Z+}
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
  {.Z-}

    procedure SimulatedClick;
  end;

  TOvcSpeedButton = class(TOvcCustomSpeedButton)
  published
    {properties}
    property AutoRepeat default False;
    property Flat default False;
    property Glyph;
    property GrayedInactive default True;
    property Layout default blGlyphTop;
    property Margin default -1;
    property NumGlyphs default 1;
    property RepeatDelay default 500;
    property RepeatInterval default 100;
    property Spacing default 1;
    property Style default bsAutoDetect;
    property Transparent default False;
    property WordWrap default False;

    {inherited properties}
    {$IFDEF VERSION4}
    property Action;
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Caption;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint default False;
    property ShowHint default True;
    property Visible;

    {inherited events}
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

const
  sbDefMaxNumGlyphs   = 5;


{*** TOvcButtonGlyph ***}

type
  TOvcButtonGlyph = class
  private
    {property variables}
    FGlyphList        : TList;
    FNumGlyphs        : Integer;
    FWordWrap         : Boolean;

    {event variables}
    FOnChange         : TNotifyEvent;

    {internal variables}
    FIndexs           : array[TOvcButtonState] of Integer;
    FOriginal         : TBitmap;
    FTransparentColor : TColor;

    {property methods}
    procedure SetGlyph(Value : TBitmap);
    procedure SetNumGlyphs(Value : Integer);

    {internal methods}
    procedure CalcButtonLayout(Canvas : TCanvas; const Client : TRect;
      const Caption : string; Layout : TButtonLayout; Margin,
      Spacing : Integer; var GlyphPos : TPoint; var TextBounds : TRect);
    function CreateButtonGlyph(State : TOvcButtonState) : Integer;
    function DrawButtonGlyph(Canvas : TCanvas; X, Y : Integer;
      State : TOvcButtonState): TPoint;
    procedure DrawButtonText(Canvas : TCanvas; const Caption : string;
      TextBounds : TRect; State : TOvcButtonState);
    procedure GlyphChanged(Sender : TObject);
    procedure Invalidate;

  public
    constructor Create;
    destructor Destroy;
      override;

    function Draw(Canvas : TCanvas; const Client : TRect; const Caption : string;
      Layout : TButtonLayout; Margin, Spacing : Integer; State : TOvcButtonState) : TRect;

    {properties}
    property Glyph : TBitmap
      read FOriginal
      write SetGlyph;

    property NumGlyphs : Integer
      read FNumGlyphs
      write SetNumGlyphs;

    property WordWrap : Boolean
      read FWordWrap
      write FWordWrap;

    {events}
    property OnChange : TNotifyEvent
      read FOnChange
      write FOnChange;
  end;

procedure TOvcButtonGlyph.CalcButtonLayout(Canvas : TCanvas; const Client : TRect;
  const Caption : string; Layout : TButtonLayout; Margin, Spacing : Integer;
  var GlyphPos : TPoint; var TextBounds : TRect);
const
  WordWraps : array[Boolean] of Word = (0, DT_WORDBREAK);
var
  TextPos    : TPoint;
  ClientSize : TPoint;
  GlyphSize  : TPoint;
  TextSize   : TPoint;
  TotalSize  : TPoint;
begin
  {calculate the item sizes}
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom - Client.Top);
  if FOriginal <> nil then
    GlyphSize := Point(FOriginal.Width div FNumGlyphs, FOriginal.Height)
  else
    GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    DrawText(Canvas.Handle, PChar(Caption),
      -1, TextBounds, DT_CALCRECT or DT_CENTER or WordWraps[FWordWrap]);
  end else
    TextBounds := Rect(0, 0, 0, 0);

  TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom -
    TextBounds.Top);
  {if the layout has the glyph on the right or the left, then both the
   text and the glyph are centered vertically.  If the glyph is on the top
   or the bottom, then both the text and the glyph are centered horizontally}
  if Layout in [blGlyphLeft, blGlyphRight] then begin
    GlyphPos.Y := (ClientSize.Y div 2) - (GlyphSize.Y div 2);
    TextPos.Y := (ClientSize.Y div 2) - (TextSize.Y div 2);
  end else begin
    GlyphPos.X := (ClientSize.X div 2) - (GlyphSize.X div 2);
    TextPos.X := (ClientSize.X div 2) - (TextSize.X div 2);
  end;
  {if there is no text or no bitmap, then Spacing is irrelevant}
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;

  {adjust Margin and Spacing}
  if Margin = -1 then begin
    if Spacing = -1 then begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
      Spacing := Margin;
    end else begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X div 2) - (TotalSize.X div 2)
      else
        Margin := (ClientSize.Y div 2) - (TotalSize.Y div 2);
    end;
  end else begin
    if Spacing = -1 then begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
      if Layout in [blGlyphLeft, blGlyphRight] then
        Spacing := (TotalSize.X div 2) - (TextSize.X div 2)
      else Spacing := (TotalSize.Y div 2) - (TextSize.Y div 2);
    end;
  end;

  case Layout of
    blGlyphLeft:
      begin
        GlyphPos.X := Margin;
        TextPos.X := GlyphPos.X + GlyphSize.X + Spacing;
      end;
    blGlyphRight:
      begin
        GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
        TextPos.X := GlyphPos.X - Spacing - TextSize.X;
      end;
    blGlyphTop:
      begin
        GlyphPos.Y := Margin;
        TextPos.Y := GlyphPos.Y + GlyphSize.Y + Spacing;
      end;
    blGlyphBottom:
      begin
        GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
        TextPos.Y := GlyphPos.Y - Spacing - TextSize.Y;
      end;
  end;

  {fixup the result variables}
  Inc(GlyphPos.X, Client.Left);
  Inc(GlyphPos.Y, Client.Top);
  OffsetRect(TextBounds, TextPos.X + Client.Left, TextPos.Y + Client.Top);
end;

constructor TOvcButtonGlyph.Create;
var
  I : TOvcButtonState;
begin
  inherited Create;

  FOriginal := TBitmap.Create;
  FOriginal.OnChange := GlyphChanged;
  FTransparentColor := clFuchsia;
  FNumGlyphs := 1;
  for I := Low(I) to High(I) do
    FIndexs[I] := -1;
end;

function TOvcButtonGlyph.CreateButtonGlyph(State : TOvcButtonState) : Integer;
var
  TmpImage : TBitmap;
  MonoBmp  : TBitmap;
  IWidth   : Integer;
  IHeight  : Integer;
  X, Y     : Integer;
  IRect    : TRect;
  ORect    : TRect;
  I        : TOvcButtonState;

  function MapColor(Value : TColor) : TColor;
  var
    RGB : LongInt;
  begin
    if (Value = clBlack) or (Value = clWhite) or
       (Value = (FTransparentColor and not $02000000)) then
      Result := Value
    else if (Value = clNavy) then
      Result := clBlack
    else begin
      RGB := ColorToRGB(Value);
      if (GetRValue(RGB) + GetGValue(RGB) + GetBValue(RGB) > 128 * 3) then
        Result := clBtnFace
      else
        Result := clBtnShadow;
    end;
  end;

begin
  if (State = obsDown) and (NumGlyphs < 3) then
    State := obsUp;

  Result := FIndexs[State];
  if Result <> -1 then
    Exit;

  IWidth := FOriginal.Width div FNumGlyphs;
  IHeight := FOriginal.Height;
  if FGlyphList = nil then
    FGlyphList := TList.Create;

  TmpImage := TBitmap.Create;
  try
    TmpImage.Width := IWidth;
    TmpImage.Height := IHeight;
    IRect := Rect(0, 0, IWidth, IHeight);
    TmpImage.Canvas.Brush.Color := clBtnFace;
    I := State;
    if Ord(I) >= NumGlyphs then
      I := obsUp;
    ORect := Rect(Ord(I) * IWidth, 0, (Ord(I) + 1) * IWidth, IHeight);
    case State of
      obsUp, obsDown :
        TmpImage.Canvas.CopyRect(IRect, FOriginal.Canvas, ORect);
      obsDisabled :
        if NumGlyphs > 1 then
          TmpImage.Canvas.CopyRect(IRect, FOriginal.Canvas, ORect)
        else begin
          MonoBmp := CreateDisabledBitmap(FOriginal, clBlack);
          try
            TmpImage.Assign(MonoBmp);
          finally
            MonoBmp.Free;
          end;
        end;
      obsInactive :
        if NumGlyphs > 4 then
          TmpImage.Canvas.CopyRect(IRect, FOriginal.Canvas, ORect)
        else begin
          TmpImage.Canvas.CopyRect(IRect, FOriginal.Canvas, IRect);
          with TmpImage do begin
            for X := 0 to Width - 1 do
              for Y := 0 to Height - 1 do
                Canvas.Pixels[X, Y] := MapColor(Canvas.Pixels[X, Y]);
          end;
        end;
    end;
  except
    TmpImage.Free;
    raise;
  end;

  FIndexs[State] := FGlyphList.Add(TmpImage);
  Result := FIndexs[State];
  FOriginal.Dormant;
end;

destructor TOvcButtonGlyph.Destroy;
begin
  FOriginal.Free;
  FOriginal := nil;

  Invalidate;

  inherited Destroy;
end;

function TOvcButtonGlyph.Draw(Canvas : TCanvas; const Client : TRect;
  const Caption : string; Layout : TButtonLayout; Margin, Spacing : Integer;
  State : TOvcButtonState) : TRect;
var
  GlyphPos   : TPoint;
  TextBounds : TRect;
begin
  CalcButtonLayout(Canvas, Client, Caption, Layout, Margin, Spacing, GlyphPos, TextBounds);
  DrawButtonGlyph(Canvas, GlyphPos.X, GlyphPos.Y, State);
  DrawButtonText(Canvas, Caption, TextBounds, State);
  Result := TextBounds;
end;

function TOvcButtonGlyph.DrawButtonGlyph(Canvas : TCanvas; X, Y : Integer;
  State : TOvcButtonState) : TPoint;
var
  Index      : Integer;
  W, H       : Integer;
  Bmp        : TBitmap;
  TransColor : TColor;
begin
  if FOriginal = nil then begin
    Result := Point(0, 0);
    Exit;
  end;

  if (FOriginal.Width = 0) or (FOriginal.Height = 0) then
    Exit;

  Index := CreateButtonGlyph(State);
  Bmp := TBitmap(FGlyphList[Index]);
  W := Bmp.Width; H := Bmp.Height;
  if (State = obsDisabled) and (NumGlyphs = 1) then
    TransColor := clBtnFace
  else
    TransColor := FTransparentColor;

  DrawTransparentBitmap(Canvas, X, Y, 0, 0, Rect(0, 0, 0, 0), Bmp, TransColor);

  Result := Point(W, H);
end;

procedure TOvcButtonGlyph.DrawButtonText(Canvas : TCanvas; const Caption : string;
  TextBounds : TRect; State : TOvcButtonState);
const
  WordWraps : array[Boolean] of Word = (0, DT_WORDBREAK);
var
  Flags : Cardinal;
begin
  Canvas.Brush.Style := bsClear;
  Flags := DT_CENTER or DT_VCENTER or WordWraps[FWordWrap];
  if State = obsDisabled then begin
    with Canvas do begin
      OffsetRect(TextBounds, 1, 1);
      Font.Color := clWhite;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
      OffsetRect(TextBounds, -1, -1);
      Font.Color := clDkGray;
      DrawText(Handle, PChar(Caption), Length(Caption), TextBounds, Flags);
    end;
  end else
    DrawText(Canvas.Handle, PChar(Caption), -1, TextBounds, Flags);
end;

procedure TOvcButtonGlyph.GlyphChanged(Sender : TObject);
begin
  if Sender = FOriginal then begin
    FTransparentColor := FOriginal.TransparentColor;
    Invalidate;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TOvcButtonGlyph.Invalidate;
var
  B   : TOvcButtonState;
  Idx : Integer;
begin
  if FGlyphList <> nil then
  try
    for Idx := FGlyphList.Count - 1 downto 0 do begin
      TObject(FGlyphList[Idx]).Free;
      FGlyphList.Delete(Idx);
    end;
    FGlyphList.Free;
    FGlyphList := nil;
  finally
    for B := Low(B) to High(B) do
      FIndexs[B] := -1;
  end;
end;

procedure TOvcButtonGlyph.SetGlyph(Value : TBitmap);
var
  Glyphs : Integer;
begin
  Invalidate;
  FOriginal.Assign(Value);
  if (Value <> nil) and (Value.Height > 0) then begin
    FTransparentColor := Value.TransparentColor;
    if Value.Width mod Value.Height = 0 then begin
      Glyphs := Value.Width div Value.Height;
      if Glyphs > (Ord(High(TOvcButtonState)) + 1) then
        Glyphs := 1;
      SetNumGlyphs(Glyphs);
    end;
  end;
end;

procedure TOvcButtonGlyph.SetNumGlyphs(Value : Integer);
begin
  if (Value <> FNumGlyphs) and (Value > 0) and (Value <= sbDefMaxNumGlyphs) then begin
    Invalidate;
    FNumGlyphs := Value;
  end;
end;


{*** TOvcCustomSpeedButton ***}

{$IFDEF VERSION4}
procedure TOvcCustomSpeedButton.ActionChange(Sender : TObject; CheckDefaults : Boolean);

  procedure CopyImage(ImageList : TCustomImageList; Index : Integer);
  begin
    with Glyph do begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia;
      Canvas.FillRect(Rect(0,0, Width, Height));
      ImageList.Draw(Canvas, 0, 0, Index);
    end;
  end;

begin
  inherited ActionChange(Sender, CheckDefaults);

  if Sender is TCustomAction then
    with TCustomAction(Sender) do begin
      {Copy image from action's imagelist}
      if (Glyph.Empty) and (ActionList <> nil) and (ActionList.Images <> nil) and
        (ImageIndex >= 0) and (ImageIndex < ActionList.Images.Count) then
        CopyImage(ActionList.Images, ImageIndex);
    end;
end;
{$ENDIF}

procedure TOvcCustomSpeedButton.SimulatedClick;
var
  FirstTickCount : LongInt;
  Now            : LongInt;
begin
  if sbState <> obsDown then begin
    sbState := obsDown;
    sbDown := True;
    Repaint;
  end;

  try
    FirstTickCount := GetTickCount;
    repeat
      Now := GetTickCount;
    until (Now - FirstTickCount >= 20) or (Now < FirstTickCount);
    Click;
  finally
    sbState := obsUp;
    sbDown := False;
    Repaint
  end;
end;

procedure TOvcCustomSpeedButton.CMEnabledChanged(var Message : TMessage);
var
  State : TOvcButtonState;
begin
  inherited;

  if Enabled then begin
    if FFlat then
      State := obsInactive
    else
      State := obsUp;
  end else
    State := obsDisabled;

  TOvcButtonGlyph(FGlyph).CreateButtonGlyph(State);

  UpdateTracking;
  Repaint;
end;

procedure TOvcCustomSpeedButton.CMMouseEnter(var Message : TMessage);
begin
  inherited;

  if (not sbMouseInControl) and Enabled and IsForegroundTask then begin
    sbMouseInControl := True;
    if FFlat then
      Repaint;
  end;
end;

procedure TOvcCustomSpeedButton.CMMouseLeave(var Message : TMessage);
begin
  inherited;

  if sbMouseInControl and Enabled then begin
    sbMouseInControl := False;
    if FFlat then
      Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.CMDialogChar(var Message : TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled then begin
      Click;
      Result := 1;
    end else
      inherited;
end;

procedure TOvcCustomSpeedButton.CMFontChanged(var Message : TMessage);
begin
  Invalidate;
end;

procedure TOvcCustomSpeedButton.CMTextChanged(var Message : TMessage);
begin
  Invalidate;
end;

procedure TOvcCustomSpeedButton.CMSysColorChange(var Message : TMessage);
begin
  TOvcButtonGlyph(FGlyph).Invalidate;
  Invalidate;
end;

constructor TOvcCustomSpeedButton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  SetBounds(0, 0, 25, 25);
  ControlStyle := [csCaptureMouse, csOpaque, csDoubleClicks];
  FGrayedInactive := True;
  sbDrawBM := TBitmap.Create;
  FGlyph := TOvcButtonGlyph.Create;
  TOvcButtonGlyph(FGlyph).OnChange := GlyphChanged;
  ParentFont := True;
  ParentShowHint := False;
  ShowHint := True;
  FSpacing := 1;
  FMargin := -1;
  FRepeatDelay := 500;
  FRepeatInterval := 100;
  FStyle := bsAutoDetect;
  FLayout := blGlyphTop;
end;

destructor TOvcCustomSpeedButton.Destroy;
begin
  TOvcButtonGlyph(FGlyph).Free;

  sbDrawBM.Free;
  sbDrawBM := nil;
  if sbRepeatTimer <> nil then
    sbRepeatTimer.Free;

  inherited Destroy;
end;

procedure TOvcCustomSpeedButton.DoMouseUp(Button : TMouseButton; Shift : TShiftState;
  X, Y : Integer);
begin
  sbState := obsUp;
  sbDown := False;
  Repaint;
  UpdateTracking;
  if sbMouseInControl then
    Click;
end;

procedure TOvcCustomSpeedButton.GlyphChanged(Sender : TObject);
begin
  Invalidate;
end;

function TOvcCustomSpeedButton.GetGlyph : TBitmap;
begin
  Result := TOvcButtonGlyph(FGlyph).Glyph;
end;

function TOvcCustomSpeedButton.GetNumGlyphs : Integer;
begin
  Result := TOvcButtonGlyph(FGlyph).NumGlyphs;
end;

function TOvcCustomSpeedButton.GetPalette : hPalette;
begin
  Result := Glyph.Palette;
end;

function TOvcCustomSpeedButton.GetWordWrap : Boolean;
begin
  Result := TOvcButtonGlyph(FGlyph).WordWrap;
end;

procedure TOvcCustomSpeedButton.Loaded;
var
  State : TOvcButtonState;
begin
  inherited Loaded;

  if Enabled then begin
    if FFlat then
      State := obsInactive
    else
      State := obsUp;
  end else
    State := obsDisabled;

  TOvcButtonGlyph(FGlyph).CreateButtonGlyph(State);
end;

procedure TOvcCustomSpeedButton.MouseDown(Button : TMouseButton; Shift : TShiftState;
  X, Y : Integer);
var
  P   : TPoint;
  Msg : TMsg;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (not sbMouseInControl) and Enabled then begin
    sbMouseInControl := True;
    Repaint;
  end;

  if (Button = mbLeft) and Enabled then begin
    if sbState <> obsDown then begin
      sbState := obsDown;
      sbDown := True;
      Repaint;
    end;
    P := Point(-1, Height);
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      if (Msg.Message = WM_LBUTTONDOWN) or (Msg.Message = WM_LBUTTONDBLCLK) then begin
        P := ScreenToClient(Msg.Pt);
        if (P.X >= 0) and (P.X < ClientWidth) and (P.Y >= 0)
          and (P.Y <= ClientHeight) then PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
      end;
    end;
    if FAutoRepeat then begin
      if sbRepeatTimer = nil then
        sbRepeatTimer := TTimer.Create(Self);
      sbRepeatTimer.Interval := FRepeatDelay;
      sbRepeatTimer.OnTimer := TimerExpired;
      sbRepeatTimer.Enabled  := True;
    end;
  end;
end;

procedure TOvcCustomSpeedButton.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  inherited MouseMove(Shift, X, Y);

  UpdateTracking;
  if sbMouseInControl and sbDown and (sbState = obsUp) then begin
    sbState := obsDown;
    Repaint;
  end else if (sbState = obsDown) and (not sbMouseInControl) then begin
    sbState := obsUp;
    Repaint;
  end;
end;

procedure TOvcCustomSpeedButton.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);

  DoMouseUp(Button, Shift, X, Y);
  if sbRepeatTimer <> nil then
    sbRepeatTimer.Enabled := False;
end;

procedure TOvcCustomSpeedButton.Paint;
var
  PaintRect : TRect;
  AState    : TOvcButtonState;
begin
  if not Enabled then begin
    sbState := obsDisabled;
  end else if sbState = obsDisabled then
    sbState := obsUp;

  AState := sbState;
  if FFlat and not sbMouseInControl and not (csDesigning in ComponentState) then
    AState := obsInactive;

  PaintRect := Rect(0, 0, Width, Height);
  sbDrawBM.Width := Self.Width;
  sbDrawBM.Height := Self.Height;
  with sbDrawBM.Canvas do begin
    Font := Self.Font;
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(PaintRect);
    if FTransparent then
      CopyParentImage(Self, sbDrawBM.Canvas);
    if (AState <> obsInactive) then
      PaintRect := DrawButtonFrame(sbDrawBM.Canvas, PaintRect,
        sbState = obsDown, FFlat, FStyle);
  end;

  if sbState = obsDown then
    OffsetRect(PaintRect, 1, 1);
  if (sbState = obsDisabled) or not FGrayedInactive then
    AState := sbState;

  TOvcButtonGlyph(FGlyph).Draw(sbDrawBM.Canvas, PaintRect, Caption, FLayout,
    FMargin, FSpacing, AState);

  Canvas.Draw(0, 0, sbDrawBM);
end;

procedure TOvcCustomSpeedButton.SetAutoRepeat(Value : Boolean);
begin
  FAutoRepeat := Value;
  if not FAutoRepeat and (sbRepeatTimer <> nil) then begin
    sbRepeatTimer.Enabled := False;
    sbRepeatTimer.Free;
    sbRepeatTimer := nil;
  end;
end;

procedure TOvcCustomSpeedButton.SetFlat(Value : Boolean);
begin
  if Value <> FFlat then begin
    FFlat := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetGlyph(Value : TBitmap);
begin
  TOvcButtonGlyph(FGlyph).Glyph := Value;
  Invalidate;
end;

procedure TOvcCustomSpeedButton.SetGrayedInactive(Value : Boolean);
begin
  if Value <> FGrayedInactive then begin
    FGrayedInactive := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetLayout(Value : TButtonLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetMargin(Value : Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetNumGlyphs(Value : Integer);
begin
  if Value < 0 then
    Value := 1
  else if Value > sbDefMaxNumGlyphs then
    Value := sbDefMaxNumGlyphs;

  if Value <> TOvcButtonGlyph(FGlyph).NumGlyphs then begin
    TOvcButtonGlyph(FGlyph).NumGlyphs := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetSpacing(Value : Integer);
begin
  if Value <> FSpacing then begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetStyle(Value : TButtonStyle);
begin
  if Style <> Value then begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetTransparent(Value : Boolean);
begin
  if Value <> FTransparent then begin
    FTransparent := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.SetWordWrap(Value : Boolean);
begin
  if Value <> WordWrap then begin
    TOvcButtonGlyph(FGlyph).WordWrap := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSpeedButton.TimerExpired(Sender : TObject);
begin
  sbRepeatTimer.Interval := FRepeatInterval;
  if (sbState = obsDown) and MouseCapture then
    try
      Click;
    except
      sbRepeatTimer.Enabled := False;
      raise;
    end;
end;

procedure TOvcCustomSpeedButton.UpdateTracking;
var
  P        : TPoint;
  OldValue : Boolean;
begin
  OldValue := sbMouseInControl;
  GetCursorPos(P);
  sbMouseInControl := Enabled and (FindDragTarget(P, True) = Self) and
    IsForegroundTask;
  if (sbMouseInControl <> OldValue) and FFlat then
    if sbMouseInControl then Repaint else Invalidate;
end;

procedure TOvcCustomSpeedButton.WMLButtonDblClk(var Message : TWMLButtonDown);
begin
  inherited;

  if sbState = obsDown then
    DblClick;
end;

procedure TOvcCustomSpeedButton.WMRButtonDown(var Message : TWMRButtonDown);
begin
  inherited;

  UpdateTracking;
end;

procedure TOvcCustomSpeedButton.WMRButtonUp(var Message : TWMRButtonUp);
begin
  inherited;

  UpdateTracking;
end;


end.

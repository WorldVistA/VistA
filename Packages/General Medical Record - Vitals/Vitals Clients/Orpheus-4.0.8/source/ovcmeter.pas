{*********************************************************}
{*                  OVCMETER.PAS 4.06                    *}
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

unit ovcmeter;
  {-Meter component}

interface

uses
  Windows, Classes, Controls, Graphics, Forms, Messages, SysUtils, OvcBase,
  OvcMisc, ExtCtrls;

type

  TOvcOwnerDrawMeterEvent = procedure(Canvas: TCanvas; Rec: TRect) of object;

  TMeterOrientation = (moHorizontal, moVertical);

type
  TOvcCustomMeter = class(TOvcGraphicControl)
  protected {private}
    {Property fields}
    FBorderStyle   : TBorderStyle;
    FCtl3D         : Boolean;
    FInvertPercent : Boolean;
    FOrientation   : TMeterOrientation;
    FPercent       : Integer;
    FShowPercent   : Boolean;
    FUsedColor     : TColor;
    {FUsedShadow    : TColor;}
    FUnusedColor   : TColor;
    {FUnusedShadow  : TColor;}
    FUnusedImage   : TBitmap;
    FUsedImage     : TBitmap;
    FOwnerDraw     : TOvcOwnerDrawMeterEvent;

    MemBM          : TBitMap;
    TxtBM          : TBitMap;

    ValueString    : string;

    function PercentValue : Integer;
    {Property access methods}
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetCtl3D(const Value : Boolean);
    procedure SetInvertPercent(Value : Boolean);
    procedure SetOrientation(const O : TMeterOrientation);
    procedure SetPercent(const Value : Integer);
    procedure SetShowPercent(const SP : boolean);
    procedure SetUnusedColor(const C : TColor);
    procedure SetUnusedImage(Value : TBitmap);
    procedure SetUsedColor(const C : TColor);
    procedure SetUsedImage(Value : TBitmap);

  protected
    {VCL methods}
    procedure Paint;
      override;

  public
    {VCL methods}
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    property BorderStyle : TBorderStyle
       read FBorderStyle write SetBorderStyle default bsSingle;
    property Canvas;
    property Ctl3D : Boolean
      read FCtl3D write SetCtl3D default True;

    {public properties}
    property InvertPercent : Boolean
      read FInvertPercent write SetInvertPercent default True;
    property Orientation : TMeterOrientation
      read FOrientation write SetOrientation
      default moHorizontal;
    property ShowPercent : boolean
      read FShowPercent write SetShowPercent
      default False;
    property UnusedColor : TColor
      read FUnusedColor write SetUnusedColor
      default clWindow;
    property UnusedImage : TBitmap
      read FUnusedImage write SetUnusedImage;
    property UsedColor : TColor
      read FUsedColor write SetUsedColor
      default clLime;
    property UsedImage : TBitmap
      read FUsedImage write SetUsedImage;
    property Percent : Integer
      read FPercent write SetPercent
      default 33;
    property OnOwnerDraw: TOvcOwnerDrawMeterEvent
      read FOwnerDraw write FOwnerDraw;
  end;

  TOvcMeter = class(TOvcCustomMeter)
  published
    property BorderStyle;
    property Ctl3D;
    property InvertPercent;
    property Orientation;
    property Percent;
    property ShowPercent;
    property UnusedColor;
    property UnusedImage;
    property UsedColor;
    property UsedImage;

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
    property OnOwnerDraw;
  end;


implementation

uses
  ovcBidi;

{*** TOvcMeter ***}

constructor TOvcCustomMeter.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque, csFramed];

  {defaults}
  FBorderStyle   := bsSingle;
  FCtl3D         := True;
  FInvertPercent := True;
  FOrientation   := moHorizontal;
  FPercent       := 33;
  {FShowPercent   := False;} {redundant}
  FUnusedColor   := clWindow;
  FUnusedImage   := TBitmap.Create;
  FUsedColor     := clLime;
  FUsedImage     := TBitmap.Create;

  ValueString    := Format('%d%%', [FPercent]);

  Width          := 200;
  Height         := 24;
end;

destructor TOvcCustomMeter.Destroy;
begin
  MemBM.Free;
  TxtBM.Free;
  FUsedImage.Free;
  FUnusedImage.Free;
  inherited Destroy;
end;

procedure TOvcCustomMeter.Paint;
var
  ClRect, R  : TRect;
  ClWidth    : Integer;
  ClHeight   : Integer;
  TextWd     : Integer;
  TextHt     : Integer;
  UsedLen    : Integer;
  UnusedLen  : Integer;
  MeterLen   : Integer;
  DividerPos : Integer;
begin
  if (MemBM <> nil) and ((MemBM.Width <> ClientWidth)
  or (MemBM.Height <> ClientHeight)) then begin
    MemBM.Free;
    MemBM := nil;
  end;
  if MemBM = nil then begin
    MemBM            := TBitMap.Create;
    MemBM.Width      := ClientWidth;
    MemBM.Height     := ClientHeight;
  end;
  ClRect := ClientRect;

  if BorderStyle <> bsNone then begin
    if Ctl3D then begin
      Frame3D(MemBM.Canvas, ClRect, clBtnShadow, clBtnHighlight, 1);
      Frame3D(MemBM.Canvas, ClRect, clBlack, clBtnHighlight, 1);
    end else
      Frame3D(MemBM.Canvas, ClRect, clBlack, clBlack, 1);
  end;

  ClWidth := ClRect.Right - CLRect.Left + 1;
  ClHeight := ClRect.Bottom - ClRect.Top + 1;
  {calculate dimensions of both sides, position of divider, etc}
  if (FOrientation = moVertical) then
    MeterLen := ClHeight
  else
    MeterLen := ClWidth;
  DividerPos := (Integer(PercentValue) * MeterLen) div 100;
  if (DividerPos < 3) then begin
    UsedLen := 0;
    UnusedLen := MeterLen;
  end else if (DividerPos = MeterLen) then begin
    UsedLen := MeterLen;
    UnusedLen := 0;
  end else begin
    if (DividerPos > MeterLen-3) then
      DividerPos := MeterLen-3;
    UsedLen := DividerPos;
    UnusedLen := MeterLen - UsedLen - 1; {1 for the divider}
  end;

  {draw the meter based on the orientation}
  if (Orientation = moHorizontal) then begin
    with MemBM.Canvas do begin
      {draw the unused side of the meter}
      if (UnusedLen > 0) then begin
        if UnusedImage.Empty then begin
          Brush.Color := UnusedColor;
          FillRect(Rect(ClRect.Left + UsedLen, ClRect.Top,
            ClRect.Left + ClWidth - 1, ClRect.Top + ClHeight - 1));
        end else begin
          CopyMode := cmSrcCopy;
          CopyRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + ClWidth,
            ClRect.Top + ClHeight - 1), UnusedImage.Canvas,Rect(0, 0,
            UnusedImage.Width - 1, UnusedImage.Height - 1));
        end;
      end;
      {draw the used side of the meter}
      if (UsedLen > 0) then begin
        if UsedImage.Empty then begin
          Brush.Color := UsedColor;
          FillRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + UsedLen - 1,
            ClRect.Top + ClHeight - 1));
        end else begin
          CopyMode := cmSrcCopy;
          CopyRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + UsedLen,
            ClRect.Top + ClHeight - 1), UsedImage.Canvas,Rect(0, 0,
            round(Integer(UsedImage.Width) * UsedLen / MeterLen) - 1,
            UsedImage.Height - 1));
        end;
      end;

    end
  end else begin {it's vertical}
    with MemBM.Canvas do begin
      {draw the used side of the meter}
      if (UsedLen > 0) then begin
        if UsedImage.Empty then begin
          Brush.Color := UsedColor;
          FillRect(Rect(ClRect.Left, ClRect.Top + UnusedLen - 1,
            ClRect.Left+ClWidth - 1, ClRect.Top + ClHeight - 1));
        end else begin
          CopyMode := cmSrcCopy;
          CopyRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + ClWidth - 1,
            ClRect.Top + ClHeight - 1), UsedImage.Canvas,Rect(0, 0,
            UsedImage.Width - 1, UsedImage.Height - 1));
        end;
      end;
      {draw the unused side of the meter}
      if (UnusedLen > 0) then begin
        if UnusedImage.Empty then begin
          Brush.Color := UnusedColor;
          FillRect(Rect(ClRect.Left, ClRect.Top, ClRect.Left + ClWidth - 1,
            UnusedLen + 1));
        end else begin
          CopyMode := cmSrcCopy;
          CopyRect(Rect(
                     ClRect.Left, ClRect.Top,
                     ClRect.Left + ClWidth - 1,
                     ClRect.Top + UnusedLen - 1),
            UnusedImage.Canvas,Rect(
             0, 0, UnusedImage.Width - 1,
             round(Integer(UnUsedImage.Height) * UnusedLen / MeterLen - 1)));
        end;
      end;

    end;
  end;

  if ShowPercent then begin
    if GetLayout(Canvas.Handle) = LAYOUT_RTL then
      SetLayout(MemBM.Canvas.Handle, LAYOUT_RTL);  // double mirror the text if needed
    if InvertPercent then begin
      if (TxtBM <> nil) and ((TxtBM.Width <> ClientWidth)
      or (TxtBM.Height <> ClientHeight)) then begin
        TxtBM.Free;
        TxtBM := nil;
      end;
      if TxtBM = nil then begin
        TxtBM            := TBitMap.Create;
        TxtBM.Width      := ClientWidth;
        TxtBM.Height     := ClientHeight;
      end;
      with TxtBM, Canvas do begin
        Brush.Color := clBlack;
        Brush.Style := bsSolid;
        FillRect(Rect(0, 0, Width, Height));
        Font := Self.Font;
        Font.Color := clWhite;
        TextHt := TextHeight(ValueString);
        TextWd := TextWidth(ValueString);
        TextOut(ClRect.Left + (ClWidth - TextWd) div 2,
          ClRect.Top + (ClHeight - TextHt) div 2, ValueString);
        MemBM.Canvas.CopyMode := cmSrcInvert;
        MemBM.Canvas.Draw(0, 0, TxtBM);
      end;
    end else begin
      with MemBM.Canvas do begin
        Brush.Style := bsClear;
        Font := Self.Font;
        Font.Color := Self.Font.Color;
        R := ClRect;
        inc(R.Top, 2);
        TextHt := TextHeight(ValueString);
        TextWd := TextWidth(ValueString);
        TextOut(ClRect.Left + (ClWidth - TextWd) div 2,
          ClRect.Top + (ClHeight - TextHt) div 2, ValueString);
      end;
    end;
    SetLayout(MemBM.Canvas.Handle, 0);
  end
  else if Assigned(OnOwnerDraw) then
    OnOwnerDraw(MemBM.Canvas, Rect(0, 0, Width, Height));


  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(0, 0, MemBM);
end;

procedure TOvcCustomMeter.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetCtl3D(const Value : Boolean);
begin
  if Value <> FCtl3D then begin
    FCtl3D := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetInvertPercent(Value: Boolean);
begin
  if Value <> FInvertPercent then begin
    FInvertPercent := Value;
    if ShowPercent then
      Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetOrientation(const O : TMeterOrientation);
var
  TempVar : Integer;
begin
  if (O <> FOrientation) then begin
    FOrientation := O;

    {when switching orientation, make the new meter have the same
     origin, but swap the width and height values unless we're showing
     a bitmap}
    if not (csLoading in ComponentState) and UsedImage.Empty then begin
      TempVar := Width;
      Width := Height;
      Height := TempVar;
    end;
    Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetShowPercent(const SP : boolean);
begin
  if (SP <> FShowPercent) then begin
    FShowPercent := SP;
    Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetUnusedColor(const C : TColor);
begin
  if (C <> FUnusedColor) then begin
    FUnusedColor := C;
    Invalidate;
  end;
end;

function TOvcCustomMeter.PercentValue : Integer;
begin
  Result := MaxI(0,MinI(FPercent, 100));
end;

procedure TOvcCustomMeter.SetPercent(const Value : Integer);
begin
  if (Value <> FPercent) then begin
    FPercent := Value;
    ValueString := Format('%d%%', [PercentValue]);
    Repaint;
  end;
end;

procedure TOvcCustomMeter.SetUsedColor(const C : TColor);
begin
  if (C <> FUsedColor) then begin
    FUsedColor := C;
    Invalidate;
  end;
end;

procedure TOvcCustomMeter.SetUnusedImage(Value: TBitmap);
begin
  FUnusedImage.Assign(Value);
  if Value <> nil then begin
    if csDesigning in ComponentState then begin
      if BorderStyle <> bsNone then begin
        if Ctl3D then begin
          ClientWidth := Value.Width + 2;
          ClientHeight := Value.Height + 2;
        end else begin
          ClientWidth := Value.Width + 1;
          ClientHeight := Value.Height + 1;
        end;
      end else begin
        ClientWidth := Value.Width;
        ClientHeight := Value.Height;
      end;
      if ClientWidth >= ClientHeight then
        Orientation := moHorizontal
      else
        Orientation := moVertical;
    end;
  end;
  Invalidate;
end;

procedure TOvcCustomMeter.SetUsedImage(Value: TBitmap);
begin
  FUsedImage.Assign(Value);
  if Value <> nil then begin
    if csDesigning in ComponentState then begin
      if BorderStyle <> bsNone then begin
        if Ctl3D then begin
          ClientWidth := Value.Width + 2;
          ClientHeight := Value.Height + 2;
        end else begin
          ClientWidth := Value.Width + 1;
          ClientHeight := Value.Height + 1;
        end;
      end else begin
        ClientWidth := Value.Width;
        ClientHeight := Value.Height;
      end;
      if ClientWidth >= ClientHeight then
        Orientation := moHorizontal
      else
        Orientation := moVertical;
    end;
  end;
  Invalidate;
end;

end.

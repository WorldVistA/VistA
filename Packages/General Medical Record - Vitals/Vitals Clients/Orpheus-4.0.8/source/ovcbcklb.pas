{*********************************************************}
{*                    OVCBCKLB.PAS 4.06                  *}
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

unit ovcbcklb;
  {-Checked listbox control}

interface

uses
  Types, Windows, Classes, Controls, Forms, Graphics, Menus, Messages, StdCtrls,
  SysUtils, OvcBase, OvcLB;

const
  DefBoldX          = False;
  DefBoxBackColor   = clWindow;
  DefBoxClickOnly   = True;
  DefBoxFrameColor  = clWindowText;
  DefBoxMargin      = 2;
  DefCheckMark      = False;
  DefCheckXColor    = clWindowText;
  DefGlyphMaskColor = clWhite;
  DefShowGlyphs     = False;
  DefWantDblClicks  = True;

type
  TOvcBasicCheckList = class(TOvcCustomListBox)

  protected {private}
    {property variables}
    FBoldX          : Boolean;      {true for bold X in box}
    FBoxBackColor   : TColor;       {box background color}
    FBoxClickOnly   : Boolean;      {true for state change in box only}
    FBoxFrameColor  : TColor;       {box frame color}
    FBoxMargin      : Integer;      {margin around the box}
    FCheckMark      : Boolean;      {true to draw a check instead of an X}
    FCheckXColor    : TColor;       {color of check or X}
    FGlyphMaskColor : TColor;       {hidden color for glyphs}
{    FLabelInfo      : TOvcLabelInfo;}
    FShowGlyphs     : Boolean;      {true to display glyphs}
    FWantDblClicks  : Boolean;      {true to include cs_dblclks style}

    {property methods}
    function GetGlyphs(Index : Integer) : TBitmap;
    procedure SetBoxBackColor(Value : TColor);
    procedure SetBoxFrameColor(Value : TColor);
    procedure SetBoxMargin(Value : Integer);
    procedure SetCheckMark(Value : Boolean);
    procedure SetGlyphMaskColor(Value : TColor);
    procedure SetGlyphs(Index : Integer; Glyph : TBitmap);
    procedure SetShowGlyphs(Value : Boolean);
    procedure SetWantDblClicks(Value : Boolean);

{internal methods}
    procedure InvalidateItem(Index : Integer);
(*
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;
*)

    {windows message response methods}
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMNCHitTest(var Msg : TMessage);
      message WM_NCHITTEST;

    {private message methods}
(*
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;
*)

    {VCL message response methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;
    procedure CNDrawItem(var Msg : TWMDrawItem);
      message CN_DRAWITEM;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure CreateParams(var Params : TCreateParams);
      override;
(*
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;
*)

    procedure DrawItem(Index : Integer; Rect : TRect; State : TOwnerDrawState);
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    property Canvas;

    property Glyphs[Index : Integer] : TBitmap
      read GetGlyphs
      write SetGlyphs;

  published
    property BoldX : Boolean
      read FBoldX
      write FBoldX
      default DefBoldX;

    property BoxBackColor  : TColor
      read FBoxBackColor
      write SetBoxBackColor
      default DefBoxBackColor;

    property BoxClickOnly : Boolean
      read FBoxClickOnly
      write FBoxClickOnly
      default DefBoxClickOnly;

    property BoxFrameColor : TColor
      read FBoxFrameColor
      write SetBoxFrameColor
      default DefBoxFrameColor;

    property BoxMargin : Integer
      read FBoxMargin
      write SetBoxMargin
      default DefBoxMargin;

    property CheckMark : Boolean
      read FCheckMark
      write SetCheckMark
      default DefCheckMark;

    property CheckXColor : TColor
      read FCheckXColor
      write FCheckXColor
      default DefCheckXColor;

    property GlyphMaskColor : TColor
      read FGlyphMaskColor
      write SetGlyphMaskColor
      default DefGlyphMaskColor;

    property ShowGlyphs : Boolean
      read FShowGlyphs
      write SetShowGlyphs
      default DefShowGlyphs;

    property WantDblClicks : Boolean
      read FWantDblClicks
      write SetWantDblClicks
      default DefWantDblClicks;


    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle;
    property Color;
    property Columns;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property HorizontalScroll default False;
    property IntegralHeight;
    property ItemHeight;
    property LabelInfo;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStops;
    property Items;
    property TabStop;
    property Visible;

    {inherited events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnTabStopsChange;
  end;


implementation

{*** TOvcBasicCheckList ***}

procedure TOvcBasicCheckList.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.CNDrawItem(var Msg : TWMDrawItem);
var
  State : TOwnerDrawState;
  G     : TBitmap;
begin
  with Msg.DrawItemStruct^ do begin
    State := TOwnerDrawState(LongRec(itemState).Lo);
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State)
    else
      Canvas.FillRect(rcItem);
    if odFocused in State then begin
      rcItem.Left := rcItem.Left + rcItem.Bottom-rcItem.Top - BoxMargin div 2;
      Dec(rcItem.Left);

      if ShowGlyphs and (Items.Objects[ItemID] <> nil) then begin
        if Items.Objects[ItemID] is TBitmap then begin
          G := TBitmap(Items.Objects[ItemID]);
          if not G.Empty then
            rcItem.Left := rcItem.Left + BoxMargin + G.Width;
        end;
      end;

      DrawFocusRect(hDC, rcItem);
    end;
    Canvas.Handle := 0;
  end;
end;

{-------------------------------------------------------------------------}

constructor TOvcBasicCheckList.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Style           := lbOwnerDrawFixed;

  FBoldX          := DefBoldX;
  FBoxBackColor   := DefBoxBackColor;
  FBoxClickOnly   := DefBoxClickOnly;
  FBoxFrameColor  := DefBoxFrameColor;
  FBoxMargin      := DefBoxMargin;
  FCheckMark      := DefCheckMark;
  FCheckXColor    := DefCheckXColor;
  FGlyphMaskColor := DefGlyphMaskColor;
  FWantDblClicks  := DefWantDblClicks;

(*
  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
*)
end;

{-------------------------------------------------------------------------}

destructor TOvcBasicCheckList.Destroy;
begin
(*
  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;
*)
  inherited Destroy;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  {set style to reflect desire for double clicks}
  if FWantDblClicks then
    ControlStyle := ControlStyle + [csDoubleClicks]
  else
    ControlStyle := ControlStyle - [csDoubleClicks];
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.DrawItem(Index : Integer; Rect : TRect;
          State : TOwnerDrawState);
var
  W : Integer;
  X : Integer;
  Y : Integer;
  M : Integer;
  G : TBitmap;
  B : array[0..255] of Char;
begin
  {set colors and clear area}
  Canvas.Font.Color := Font.Color;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(Rect);

  M := BoxMargin;

  {determine width/height of the rectangle}
  W := Rect.Bottom - Rect.Top - 2*M;
  if not Odd(W) then
    Dec(W);

  {draw the box}
  Canvas.Brush.Color := BoxBackColor;
  Canvas.Pen.Color := BoxFrameColor;
  Canvas.Rectangle(Rect.Left + M, Rect.Top + M,
                   Rect.Left + W + M, Rect.Top + W + M);

  {check/X pen color}
  Canvas.Pen.Color := CheckXColor;

  if CheckMark then begin
    {draw the check mark}
    if odSelected in State then begin
      Y := W div 2 + 1;
      for X := 2 to (W div 3) do begin
        Canvas.MoveTo(Rect.Left + M + X, Rect.Top + M + Y - 1);
        Canvas.LineTo(Rect.Left + M + X, Rect.Top + M + Y + 2);
        Inc(Y);
      end;
      Dec(Y, 2);
      for X := (W div 3) + 1 to W - 3 do begin
        Canvas.MoveTo(Rect.Left + M + X, Rect.Top + M + Y - 1);
        Canvas.LineTo(Rect.Left + M + X, Rect.Top + M + Y + 2);
        Dec(Y);
      end;
    end;
  end else begin
    {draw the X mark?}
    if odSelected in State then begin
      if BoldX then begin
        Canvas.MoveTo(Rect.Left + M + 1, Rect.Top + M + 2);
        Canvas.LineTo(Rect.Left + W + M - 2, Rect.Top + W + M - 1);
        Canvas.MoveTo(Rect.Left + M + 2, Rect.Top + M + 1);
        Canvas.LineTo(Rect.Left + W + M - 1, Rect.Top + W + M - 2);
      end;
      Canvas.MoveTo(Rect.Left + M + 1, Rect.Top + M + 1);
      Canvas.LineTo(Rect.Left + W + M - 1, Rect.Top + W + M - 1);
      if BoldX then begin
        Canvas.MoveTo(Rect.Left + M + 1, Rect.Top + W + M - 3);
        Canvas.LineTo(Rect.Left + W + M - 2, Rect.Top + M);
        Canvas.MoveTo(Rect.Left + M + 2, Rect.Top + W + M - 2);
        Canvas.LineTo(Rect.Left + W + M - 1, Rect.Top + M + 1);
      end;
      Canvas.MoveTo(Rect.Left + M + 1, Rect.Top + W + M - 2);
      Canvas.LineTo(Rect.Left + W + M - 1, Rect.Top + M);
    end;
  end;

  {draw glyphs if enabled}
  if ShowGlyphs and (Items.Objects[Index] <> nil) then begin
    if Items.Objects[Index] is TBitmap then begin
      G := TBitmap(Items.Objects[Index]);
      if not G.Empty then begin
        X := Rect.Left + M + W + M;
        Y := Rect.Top + ((Rect.Bottom - Rect.Top) - G.Height) div 2;
        if Y < 0 then
          Y := 0;

        Canvas.Brush.Color := Color;
        Canvas.BrushCopy(Classes.Rect(X, Y, X + G.Width, Y + G.Height),
          G, Classes.Rect(0, 0, G.Width, G.Height), GlyphMaskColor);

        {adjust width to account for glyph}
        W := W + M + G.Width;
      end;
    end;
  end;

  {draw the text}
  Canvas.Brush.Color := Color;
  Canvas.Pen.Color := Font.Color;
  if (Index > -1) and (Index < Items.Count) then begin
    Y := Canvas.TextHeight(Items[Index]);
    Y := Rect.Top + ((Rect.Bottom - Rect.Top) - Y) div 2;
    StrPLCopy(B, Items[Index], 255);
    ExtTextOut(Canvas.Handle, Rect.Left + M + W + M, Y, ETO_CLIPPED,
      @Rect, B, StrLen(B), nil);
  end;

  {redraw top item to avoid windows bug}
  if FShowGlyphs and (Index <> TopIndex) then begin
    State := [];
    if SendMessage(Handle, LB_GETSEL, TopIndex, 0) > 0 then
      State := [odSelected];
    if (ItemIndex = TopIndex) and Focused then
      State := State + [odFocused];
    SendMessage(Handle, LB_GETITEMRECT, TopIndex, NativeInt(@Rect));
    DrawItem(TopIndex, Rect, State);
  end;
end;

{-------------------------------------------------------------------------}

function TOvcBasicCheckList.GetGlyphs(Index : Integer) : TBitmap;
begin
  Result := nil;
  if (Index > -1) and (Index < Items.Count) then
    if Items.Objects[Index] is TBitmap then
      Result := TBitmap(Items.Objects[Index]);
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetBoxBackColor(Value : TColor);
begin
  if (Value <> FBoxBackColor) then begin
    FBoxBackColor := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetBoxFrameColor(Value : TColor);
begin
  if (Value <> FBoxFrameColor) then begin
    FBoxFrameColor := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetBoxMargin(Value : Integer);
begin
  if (Value <> FBoxMargin) and (Value >= 0) and
     (ItemHeight - 2*Value > 0) then begin
    FBoxMargin := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetCheckMark(Value : Boolean);
begin
  if (Value <> FCheckMark) then begin
    FCheckMark := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetGlyphMaskColor(Value : TColor);
begin
  if (Value <> FGlyphMaskColor) then begin
    FGlyphMaskColor := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetGlyphs(Index : Integer; Glyph : TBitmap);
begin
  if (Index > -1) and (Index < Items.Count) then
    Items.Objects[Index] := Glyph;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetShowGlyphs(Value : Boolean);
begin
  if (Value <> FShowGlyphs) then begin
    FShowGlyphs := Value;
    Refresh;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.SetWantDblClicks(Value : Boolean);
  {-set the WantDblClicks property value}
begin
  if Value <> FWantDblClicks then begin
    FWantDblClicks := Value;
    RecreateWnd;
  end;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.WMLButtonDown(var Msg : TWMLButtonDown);
var
  I : Integer;
  P : TPoint;
  R : TRect;
begin
  if not Focused then
    SetFocus;

  P.X := Msg.XPos;
  P.Y := Msg.YPos;
  I := ItemAtPos(P, True);
  if I > -1 then begin
    FillChar(R, SizeOf(R), #0);
    SendMessage(Handle, LB_GETITEMRECT, I, NativeInt(@R));
    if (not BoxClickOnly) or ((Msg.XPos >= R.Left) and
       (Msg.XPos <= R.Left + ItemHeight - BoxMargin div 2)) then
      inherited
    else
      SendMessage(Handle, LB_SETCARETINDEX, I, 0);
  end else
    inherited;
end;

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.WMNCHitTest(var Msg : TMessage);
begin
  if (csDesigning in ComponentState) then
    DefaultHandler(Msg)
  else
    inherited;
end;

{-------------------------------------------------------------------------}

(*
BEGINNING OF EXTENSIVE 1.05 CHANGES
procedure TOvcBasicCheckList.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TForm;
  S  : string;
begin
  if csLoading in ComponentState then
    Exit;

  PF := TForm(GetParentForm(Self));
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;
      {turn off auto size}
      FLabelInfo.ALabel.AutoSize := False;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
                           (FLabelInfo.ALabel.Parent <> nil) and
                           not (csLoading in ComponentState) then begin

    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY + Top + Height,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.Notification(AComponent : TComponent;
                                          Operation : TOperation);
var
  PF : TForm;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := TForm(GetParentForm(Self));
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end;
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;
*)

{-------------------------------------------------------------------------}

(*
procedure TOvcBasicCheckList.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

END OF EXTENSIVE 1.05 CHANGES
*)

{-------------------------------------------------------------------------}

procedure TOvcBasicCheckList.InvalidateItem(Index : Integer);
var
  R : TRect;
begin
  SendMessage(Handle, LB_GETITEMRECT, Index, NativeInt(@R));
  InvalidateRect(Handle, @R, True);
end;

{-------------------------------------------------------------------------}

end.

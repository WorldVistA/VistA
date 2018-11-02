{*********************************************************}
{*                  OVCSLIDE.PAS 4.06                    *}
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

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcslide;
  {-Slider component}

interface

uses
  Types, Windows, Classes, Buttons, Controls, Graphics, Forms, Messages, SysUtils,
  OvcBase, OvcConst, OvcData, OvcExcpt;

type
  TOvcSliderOrientation = (soHorizontal, soVertical);

type
  TOvcCustomSlider = class(TOvcCustomControl)

  protected {private}
    {property variables}
    FBorderStyle   : TBorderStyle;
    FDrawMarks     : Boolean;
    FMarkColor     : TColor;
    FMax           : Double;
    FMin           : Double;
    FMinMarkSpacing: Integer;
    FOrientation   : TOvcSliderOrientation;
    FPosition      : Double;
    FStep          : Double;

    {event variables}
    FOnChange      : TNotifyEvent;

    {internal variables}
    slBtnRect      : TRect;
    slClickPos     : Double;
    slMemBM        : TBitMap;
    slMouseDown    : Boolean;
    slOffset       : Integer;
    slPointerWidth : Integer;
    slPopup        : Boolean;

    {property methods}
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetDrawMarks(Value : Boolean);
    procedure SetMarkColor(Value : TColor);
    procedure SetMinMarkSpacing(Value : Integer);
    procedure SetOrientation(const Value : TOvcSliderOrientation);
    procedure SetPosition(const Value : Double);
    procedure SetRangeHi(const Value : Double);
    procedure SetRangeLo(const Value : Double);
    procedure SetStep(const Value : Double);

    {VCL message methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMEnter(var Message : TCMEnter);
      message CM_ENTER;
    procedure CMExit(var Message : TCMExit);
      message CM_EXIT;

    {windows message response methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;

  protected
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure Paint;
      override;

    {dynamic event wrappers}
    procedure DoOnChange;
      virtual;
    procedure DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
      override;


    {properties}
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle;
    property DrawMarks : Boolean
      read FDrawMarks write SetDrawMarks;
    property MarkColor : TColor
      read FMarkColor write SetMarkColor default clBtnText;
    property Max : Double
      read FMax write SetRangeHi;
    property Min : Double
      read FMin write SetRangeLo;
    property MinMarkSpacing : Integer
      read FMinMarkSpacing write SetMinMarkSpacing;
    property Orientation : TOvcSliderOrientation
      read FOrientation write SetOrientation;
    property Position : Double
      read FPosition write SetPosition;
    property Step : Double
      read FStep write SetStep;

    {events}
    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;

  public

    constructor Create(AOwner : TComponent);
      override;
    constructor CreateEx(AOwner : TComponent; AsPopup : Boolean);
      virtual;
    destructor Destroy;
      override;
    procedure KeyPress(var Key : Char);
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;

    {public properties}
    property Canvas;

  end;

  TOvcSlider = class(TOvcCustomSlider)
  published
    {properties}
    property Anchors;
    property Constraints;
    property About;
    property Align;
    property BorderStyle default bsSingle;
    property Color;
    property Ctl3D;
    property Cursor;
    property DrawMarks default True;
    property Enabled;
    property Height default 20;
    property LabelInfo;
    property Max;
    property MarkColor;
    property Min;
    property Orientation default soHorizontal;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ShowHint;
    property Step;
    property TabOrder;
    property TabStop;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
  end;

implementation

{*** TOvcCustomSlider ***}

procedure TOvcCustomSlider.CMCtl3DChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  Invalidate;
end;

procedure TOvcCustomSlider.CMEnter(var Message : TCMEnter);
begin
  Invalidate;

  inherited;
end;

procedure TOvcCustomSlider.CMExit(var Message : TCMExit);
begin
  slMouseDown := False;
  Invalidate;

  inherited;
end;

constructor TOvcCustomSlider.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {owner will cpature mouse input, we can't also}
  if slPopup then
    ControlStyle := ControlStyle - [csCaptureMouse, csDoubleClicks];

  if NewStyleControls then
    ControlStyle := ControlStyle + [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque, csFramed];

  {defaults}
  FBorderStyle    := bsSingle;
  FDrawMarks      := True;
  FMarkColor      := clBtnText;
  FMinMarkSpacing := 5;
  FOrientation    := soHorizontal;
  FStep           := 1;
  FMax            := 10;
  FMin            := 0;
  FPosition       := FMin;

  Color           := clWindow;
  Width           := 150;
  Height          := 20;
end;

constructor TOvcCustomSlider.CreateEx(AOwner : TComponent; AsPopup : Boolean);
begin
  slPopup := AsPopup;

  Create(AOwner);
end;

procedure TOvcCustomSlider.CreateParams(var Params : TCreateParams);
const
  BorderStyles : array[TBorderStyle] of Integer = (0, WS_BORDER);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Integer(Style) or BorderStyles[FBorderStyle];
    if slPopup then begin
      Style := WS_POPUP or WS_BORDER;
      WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    end;
  end;

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    if not slPopup then
      Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;

  if not (csDesigning in ComponentState) then
    ControlStyle := ControlStyle - [csDoubleClicks];
end;

destructor TOvcCustomSlider.Destroy;
begin
  slMemBM.Free;
  slMemBM := nil;

  inherited Destroy;
end;

procedure TOvcCustomSlider.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TOvcCustomSlider.DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
var
  Key : Word;
begin
  inherited DoOnMouseWheel(Shift, Delta, XPos, YPos);

  if Delta < 0 then
    if (FOrientation = soHorizontal) then
      Key := VK_LEFT
    else
      Key := VK_DOWN
  else
    if (FOrientation = soHorizontal) then
      Key := VK_RIGHT
    else
      Key := VK_UP;

  KeyDown(Key, []);
end;

procedure TOvcCustomSlider.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if Shift <> [] then
    Exit;

  case Key of
    VK_HOME  : Position := FMin;
    VK_END   : Position := FMax;
  end;

  if (FOrientation = soHorizontal) then begin
    case Key of
      VK_RIGHT : Position := Position + FStep;
      VK_LEFT  : Position := Position - FStep;
    end;
  end else begin
    case Key of
      VK_UP   : Position := Position + FStep;
      VK_DOWN : Position := Position - FStep;
    end;
  end;
end;

procedure TOvcCustomSlider.KeyPress(var Key : Char);
begin
  inherited KeyPress(Key);

  if (FOrientation = soHorizontal) then begin
    case Key of
      '+' : Position := Position + FStep;
      '-' : Position := Position - FStep;
    end;
  end else begin
    case Key of
      '+' : Position := Position + FStep;
      '-' : Position := Position - FStep;
    end;
  end;
end;

procedure TOvcCustomSlider.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if not slPopup then begin
    SetFocus;
    inherited MouseDown(Button, Shift, X, Y);
  end;
  {record position so it can be used to offset the dragto position}
  if PtInRect(slBtnRect, Point(X, Y)) then begin
    {record pixel count into the button area}
    if (FOrientation = soHorizontal) then
      slOffset := X - slBtnRect.Left
    else
      slOffset := slBtnRect.Bottom - Y; {pixel count into the button area}
    {record that mouse is down}
    slMouseDown := True;
  end else if PtInRect(ClientRect, Point(X, Y)) then begin
    {if not on button, move one incement towards the mouse click}
    if (FOrientation = soHorizontal) then begin
      if X > slBtnRect.Right then
        Position := Position + FStep
      else if X < slBtnRect.Left then
        Position := Position - FStep;
    end else begin
      if Y < slBtnRect.Top then
        Position := Position + FStep
      else if Y > slBtnRect.Bottom then
        Position := Position - FStep;
    end;
  end;

  Invalidate;
end;

procedure TOvcCustomSlider.MouseMove(Shift : TShiftState; X, Y : Integer);
var
  P : Double;
begin
  if not slPopup then
    inherited MouseMove(Shift, X, Y);

  {if mouse is down, find position of mouse and move the pointer there}
  if slMouseDown then begin
    if (FOrientation = soHorizontal) then begin
      X := X - slOffset; {adjust for click position}
      if X < 0 then
        X := 0;
      if X > ClientWidth - slPointerWidth then
        X := ClientWidth - slPointerWidth;
      P := X * ((FMax - FMin) / (ClientWidth - 1 - slPointerWidth)) + FMin;
      Position := Round(P / FStep) * FStep;
    end else begin
      Y := ClientHeight - Y - slOffset; {reverse Y and adjust for click position}
      if Y < 0 then
        Y := 0;
      if Y > ClientHeight - slPointerWidth then
        Y := ClientHeight - slPointerWidth;
      P := Y * ((FMax - FMin) / (ClientHeight - 1 - slPointerWidth)) + FMin;
      Position := Round(P / FStep) * FStep;
    end;
  end;
  Invalidate;
end;

procedure TOvcCustomSlider.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if not slPopup then
    inherited MouseUp(Button, Shift, X, Y);

  {clear the "mouse is down" flag}
  slMouseDown := False;
  Invalidate;
end;

procedure TOvcCustomSlider.Paint;
var
  R     : TRect;
  X, Y  : Integer;
  Marks : Integer;
  F, S  : Double;
  I     : Integer;
  Len   : Integer;
  Range : Double;
begin
  if (slMemBM <> nil) and ((slMemBM.Width <> ClientWidth) or (slMemBM.Height <> ClientHeight)) then begin
    slMemBM.Free;
    slMemBM := nil;
  end;
  if slMemBM = nil then begin
    slMemBM        := TBitMap.Create;
    slMemBM.Width  := ClientWidth;
    slMemBM.Height := ClientHeight;
  end;

  if (FOrientation = soHorizontal) then
    Len := ClientWidth
  else
    Len := ClientHeight;

  {pointer width to 8% of length}
  slPointerWidth := Trunc(Len * 0.08);
  if not Odd(slPointerWidth) then
    Inc(slPointerWidth);
  if slPointerWidth < 7 then
    slPointerWidth := 7;

  {the range of values}
  Range := (FMax - FMin);

  slMemBM.Canvas.Pen.Color := FMarkColor;

  {draw the slider based on its orientation}
  if (FOrientation = soHorizontal) then begin
    with slMemBM.Canvas do begin
      Brush.Color := Color;
      FillRect(ClientRect);
      {draw the pointer at the proper position}
      X := Round(((FPosition - FMin) / Range) * (Len - 1 - slPointerWidth));
      slBtnRect := Rect(X, (ClientHeight div 2), X + slPointerWidth, ClientHeight);
      slBtnRect := DrawButtonFace(slMemBM.Canvas, slBtnRect, 1, bsNew, True, slMouseDown, Focused);
      {draw mark on button}
      MoveTo(X + (slBtnRect.Right - slBtnRect.Left) div 2, slBtnRect.top);
      LineTo(X + (slBtnRect.Right - slBtnRect.Left) div 2, slBtnRect.top +
             (slBtnRect.Bottom-slBtnRect.Top) div 2);

      if FDrawMarks then begin
        {try "step" number of marks first}
        S := FStep;
        Marks := Trunc(Range / S);
        if Marks > (Len - slPointerWidth div 2) div FMinMarkSpacing then begin {one every X pixels}
          Marks := (Len - slPointerWidth div 2) div FMinMarkSpacing;
          X := slPointerWidth div 2;
          for I := 0 to Marks-1 do begin
            MoveTo(X, 0);
            LineTo(X, ClientHeight div 4);
            Inc(X, FMinMarkSpacing);
          end;
        end else begin
          F := FMin;
          repeat
            X := Round(((F - FMin) / Range) * (Len -1 - slPointerWidth));
            X := X + slPointerWidth div 2;
            MoveTo(X, 0);
            LineTo(X, ClientHeight div 4);
            F := F + FStep;
          until F > FMax;
        end;
      end;
    end;
  end else begin {it's vertical}
    with slMemBM.Canvas do begin
      Brush.Color := Color;
      FillRect(ClientRect);
      Y := Round(((FPosition - FMin) / Range) * (Len -1 - slPointerWidth));
      slBtnRect := Rect((ClientWidth div 2), ClientHeight - Y - slPointerWidth, ClientWidth, ClientHeight - Y);
      slBtnRect := DrawButtonFace(slMemBM.Canvas, slBtnRect, 1, bsNew, True, slMouseDown, Focused);
      {draw mark on button}
      Pen.Color := FMarkColor;
      MoveTo((ClientWidth div 2), ClientHeight - Y - 1 - (slBtnRect.Bottom - slBtnRect.Top) div 2);
      LineTo((ClientWidth div 2) + (slBtnRect.Right - slBtnRect.Left) div 2,
             ClientHeight - Y - 1 - (slBtnRect.Bottom - slBtnRect.Top) div 2);

      if FDrawMarks then begin
        {try "step" number of marks first}
        S := FStep;
        Marks := Trunc(Range / S);
        if Marks > (Len - slPointerWidth div 2) div FMinMarkSpacing then begin {one every X pixels}
          Marks := (Len - slPointerWidth div 2) div FMinMarkSpacing;
          Y := ClientHeight - slPointerWidth div 2;
          for I := 0 to Marks-1 do begin
            MoveTo(0, Y);
            LineTo(ClientWidth div 4, Y);
            Dec(Y, FMinMarkSpacing);
          end;
        end else begin
          F := FMin;
          repeat
            Y := Round(((F - FMin) / Range) * (Len -1 - slPointerWidth));
            Y := ClientHeight - Y - slPointerWidth div 2;
            MoveTo(0, Y);
            LineTo(ClientWidth div 4, Y);
            F := F + FStep;
          until F > FMax;
        end;
      end;
    end;
  end;

  if Focused then begin
    R := slBtnRect;
    InflateRect(R, 3, 3);
    slMemBM.Canvas.DrawFocusRect(R);
  end;

  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(0, 0, slMemBM);
end;

procedure TOvcCustomSlider.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomSlider.SetDrawMarks(Value : Boolean);
begin
  if Value <> FDrawMarks then begin
    FDrawMarks := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    Invalidate;
end;

procedure TOvcCustomSlider.SetMarkColor(Value : TColor);
begin
  if Value <> FMarkColor then begin
    FMarkColor := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetMinMarkSpacing(Value : Integer);
begin
  if (Value <> FMinMarkSpacing) and (Value > 0) then begin
    FMinMarkSpacing := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetOrientation(const Value : TOvcSliderOrientation);
var
  TempVar : Integer;
begin
  if (Value <> FOrientation) then begin
    FOrientation := Value;

    {when switching orientation, make we have the same
     origin, but swap the width and height values}
    if not (csLoading in ComponentState) then begin
      TempVar := Width;
      Width := Height;
      Height := TempVar;
    end;
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetPosition(const Value : Double);
begin
  if Value <> FPosition then begin
    FPosition := Round(Value / FStep) * FStep;
    if FPosition > FMax then
      FPosition := FMax;
    if FPosition < FMin then
      FPosition := FMin;
    Invalidate;

    DoOnChange;
  end;
end;

procedure TOvcCustomSlider.SetRangeHi(const Value : Double);
begin
  if Value <> FMax then begin
    if not (csLoading in ComponentState) and (Value <= FMin) then
      raise EOvcException.Create(GetOrphStr(SCInvalidMinMaxValue));
    FMax := Value;
{    FPosition := FMin;}
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetRangeLo(const Value : Double);
begin
  if Value <> FMin then begin
    if not (csLoading in ComponentState) and (Value >= FMax) then
      raise EOvcException.Create(GetOrphStr(SCInvalidMinMaxValue));
    FMin := Value;
{    FPosition := FMin;}
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.SetStep(const Value : Double);
begin
  if Value <> FStep then begin
    FStep := Value;
    if FStep = 0 then
      FStep := 1;
    Invalidate;
  end;
end;

procedure TOvcCustomSlider.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background, we handle all painting}
end;

procedure TOvcCustomSlider.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  inherited;

  if csDesigning in ComponentState then
    Msg.Result := DLGC_STATIC
  else if slPopup then
    Msg.Result := Msg.Result or DLGC_WANTCHARS or DLGC_WANTARROWS or DLGC_WANTALLKEYS
  else
    Msg.Result := Msg.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TOvcCustomSlider.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  Invalidate;
end;

end.

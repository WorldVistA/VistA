{*********************************************************}
{*                    OVCFSC.PAS 4.08                    *}
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

unit ovcfsc;
  {-Spin control}

interface

uses
  UITypes, Types, Windows, Classes, Controls, Forms, Graphics,
  Messages, StdCtrls, SysUtils, OvcBase, OvcData, OvcEF, OvcMisc;

type
  TOvcFlatSpinnerStyle = (stNormalVertical, stNormalHorizontal, stFourWay, stStar,
    stDiagonalVertical, stDiagonalHorizontal, stDiagonalFourWay,
    stPlainStar);

  TOvcFlatDirection = (dUp, dDown, dRight, dLeft);

  TOvcFlatSpinState = (ssNone, ssNormal, ssUpBtn, ssDownBtn, ssLeftBtn,
                       ssRightBtn, ssCenterBtn);

  TOvcFlatSpinnerLineType = (ltSingle,
    ltTopBevel, ltBottomBevel, ltTopSlice, ltBottomSlice,
    ltTopSliceSquare, ltBottomSliceSquare,
    ltDiagTopBevel,ltDiagBottomBevel,
    ltStarLine0, ltStarLine1, ltStarLine2, ltStarLine3, ltStarLine4, ltStarLine5
    );

  TFlatSpinClickEvent =
    procedure(Sender : TObject; State : TOvcFlatSpinState;
              Delta : Double; Wrap : Boolean) of object;


type
  TOvcFlatSpinner = class(TOvcCustomControl)
  

  protected {private}
    FArrowColor     : TColor;
    FFaceColor      : TColor;
    FHighlightColor : TColor;
    FShadowColor    : TColor;

    {property variables}
    FAcceleration    : Integer;         {value used to determine acceleration}
    FAutoRepeat      : Boolean;         {repeat if button held}
    FDelayTime       : Integer;
    FDelta           : Double;          {amount to change by}
    FRepeatCount     : Integer;
    FFocusedControl  : TWinControl;     {the control to give the focus to}
    FShowArrows      : Boolean;
    FStyle           : TOvcFlatSpinnerStyle;
    FWrapMode        : Boolean;         {wrap at field bounderies}

    {events}
    FOnClick         : TFlatSpinClickEvent;

    {private instance variables}
    fscNextMsgTime    : Integer;

    {regions for the five spin button sections}
    fscUpRgn          : hRgn;
    fscDownRgn        : hRgn;
    fscLeftRgn        : hRgn;
    fscRightRgn       : hRgn;
    fscCenterRgn      : hRgn;

    fscCurrentState   : TOvcFlatSpinState;
    fscLButton        : Byte;
    fscMouseOverBtn   : Boolean;
    fscPrevState      : TOvcFlatSpinState;
    fscSizing         : Boolean;
    fscTopLeft,
    fscTopRight,
    fscBottomLeft,
    fscBottomRight,
    fscCenter         : TPoint;

    fscTopLeftCenter,
    fscBottomLeftCenter,
    fscTopRightCenter,
    fscBottomRightCenter : TPoint;

    fscTopMiddle,
    fscBottomMiddle,
    fscLeftMiddle,
    fscRightMiddle       : TPoint;

    fscTopLeft4,
    fscBottomLeft4,
    fscTopRight4,
    fscBottomRight4      : TPoint;

    {property methods}
    procedure SetAcceleration(const Value : Integer);
    procedure SetShowArrows(const Value : Boolean);
    procedure SetStyle(Value : TOvcFlatSpinnerStyle);

    procedure SetArrowColor(Value : TColor);
    procedure SetFaceColor(Value : TColor);
    procedure SetHighlightColor(Value : TColor);
    procedure SetShadowColor(Value : TColor);

    function  fscCheckMousePos : TOvcFlatSpinState;
    procedure fscDeleteRegions;
    procedure fscDoAutoRepeat;
    procedure fscDrawArrow(const R: TRect; const Pressed: Boolean;
                           const Direction: TOvcFlatDirection);
    procedure fscDrawLine(P1, P2 : TPoint; const Up : Boolean;
                          LineType : TOvcFlatSpinnerLineType);
    procedure fscDrawNormalButton(const Redraw : Boolean);
    procedure fscDrawFourWayButton(const Redraw : Boolean);
    procedure fscDrawStarButton(const Redraw : Boolean);
    procedure fscDrawDiagonalVertical(const Redraw : Boolean);
    procedure fscDrawDiagonalHorizontal(const Redraw : Boolean);
    procedure fscDrawDiagonalFourWay(const Redraw : Boolean);
    procedure fscDrawPlainStar(const Redraw : Boolean);
    procedure fscDrawButton(const Redraw : Boolean);
    procedure fscInvalidateButton(const State : TOvcFlatSpinState);
    procedure fscPolyline(const Points: array of TPoint);

    {private message response methods}
    procedure OMRecreateWnd(var Msg : TMessage);
      message om_RecreateWnd;

    {windows message handling methods}
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg : TWMLButtonUp);
      message WM_LBUTTONUP;

  protected
    BtnColor : array[Boolean, 0..7] of TColor;

    procedure DrawButton(C : TCanvas; R : TRect; Up : Boolean);
    procedure Paint; override;
    procedure ResetBtnColor;

    procedure CreateParams(var Params : TCreateParams); override;
    procedure Loaded; override;
    procedure Notification(AComponent : TComponent;
                           Operation  : TOperation); override;

    {dynamic event wrappers}
    procedure DoOnClick(State : TOvcFlatSpinState);
      dynamic;

    procedure fscDoMouseDown(const XPos, YPos: Integer);
      virtual;
    procedure fscDoMouseUp;
      virtual;

    procedure fscUpdateNormalSizes;
    procedure fscUpdateFourWaySizes;
    procedure fscUpdateStarSizes;
    procedure fscUpdateDiagonalVerticalSizes;
    procedure fscUpdateDiagonalHorizontalSizes;
    procedure fscUpdateDiagonalFourWaySizes;
    procedure fscUpdatePlainStarSizes;
    procedure fscUpdateSizes; virtual;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;

    property RepeatCount : Integer
      read FRepeatCount;

  published
    property ArrowColor  : TColor
      read FArrowColor
      write SetArrowColor
      default clBlack;

    property FaceColor : TColor
      read FFaceColor
      write SetFaceColor
      default clBtnFace;

    property HighlightColor : TColor
      read FHighlightColor
      write SetHighlightColor
      default clWhite;

    property ShadowColor : TColor
      read FShadowColor
      write SetShadowColor
      default clBtnShadow;

    property Acceleration : Integer
      read FAcceleration
      write SetAcceleration
      default 5;

    property AutoRepeat : Boolean
      read FAutoRepeat
      write FAutoRepeat
      default True;

    property Delta : Double
      read FDelta
      write FDelta;

    property DelayTime : Integer
      read FDelayTime
      write FDelayTime
      default 500;

    property FocusedControl : TWinControl
      read FFocusedControl
      write FFocusedControl;

    property ShowArrows : Boolean
      read FShowArrows
      write SetShowArrows;

    property Style : TOvcFlatSpinnerStyle
      read FStyle
      write SetStyle
      default stNormalVertical;

    property WrapMode : Boolean
      read FWrapMode
      write FWrapMode
      default True;

    {inherited properties}
    property Anchors;
    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property Visible;

    {events}
    property OnClick : TFlatSpinClickEvent
      read FOnClick write FOnClick;

    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

const
  scDefMinSize = 13;

{*** TOvcFlatSpinner ***}

constructor TOvcFlatSpinner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  ControlStyle := ControlStyle + [csReplicatable];

  FArrowColor := clBlack;
  FFaceColor := clBtnFace;
  FHighlightColor := clWhite;
  FShadowColor := clBtnShadow;

  {initialize property variables}
  FAcceleration  := 5;
  FAutoRepeat    := True;
  FDelayTime     := 500;
  FDelta         := 1;
  FRepeatCount   := 0;
  FShowArrows    := True;
  FStyle         := stNormalVertical;
  FWrapMode      := True;

  Width          := 16;
  Height         := 25;
  TabStop        := False;

  fscCurrentState := ssNormal;
  fscPrevState    := ssNone;
  fscMouseOverBtn := False;
end;

procedure TOvcFlatSpinner.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);
  ControlStyle := ControlStyle + [csOpaque] - [csFramed];

  if not (csDesigning in ComponentState) then
    ControlStyle := ControlStyle - [csDoubleClicks];
end;

destructor TOvcFlatSpinner.Destroy;
begin
  fscDeleteRegions;

  inherited Destroy;
end;


procedure TOvcFlatSpinner.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  L, T, H, W : Integer;
begin
  if (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then begin
    {limit smallest size}
    if AWidth < scDefMinSize then
      AWidth := scDefMinSize ;
    if AHeight < scDefMinSize then
      AHeight := scDefMinSize ;
  end;

  L := Left;
  T := Top;
  H := Height;
  W := Width;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (L <> Left) or (T <> Top) or (H <> Height) or (W <> Width) then begin

    fscTopLeft     := Point(0           , 0  );
    fscTopRight    := Point(Width-1     , 0  );
    fscBottomLeft  := Point(0           , Height-1);
    fscBottomRight := Point(Width-1     , Height-1);
    fscCenter      := Point(Width div 2 , Height div 2 );

    fscTopLeftCenter    := Point(Width * 1 div 3 , Height * 1 div 3 );
    fscBottomLeftCenter := Point(Width * 1 div 3 , Height * 2 div 3 );
    fscTopRightCenter   := Point(Width * 2 div 3 , Height * 1 div 3 );
    fscBottomRightCenter:= Point(Width * 2 div 3 , Height * 2 div 3 );

    fscTopMiddle   := Point(Width div 2 , 0 );
    fscBottomMiddle:= Point(Width div 2 , Height - 1 );
    fscLeftMiddle  := Point(0           , Height div 2 );
    fscRightMiddle := Point(Width - 1   , Height div 2 );

    fscTopLeft4    := Point(Width div 4    , 0 );
    fscBottomLeft4 := Point(Width div 4    , Height - 1 );
    fscTopRight4   := Point(Width * 3 div 4, 0 );
    fscBottomRight4:= Point(Width * 3 div 4, Height - 1 );
  end;

  {update sizes of control and button regions}
  fscUpdateSizes;

  if HandleAllocated then
    Invalidate;
end;


procedure TOvcFlatSpinner.DoOnClick(State : TOvcFlatSpinState);
var
  D : Double;
begin
  if Assigned(FOnClick) or
     (Assigned(FFocusedControl) and
              ((FFocusedControl is TOvcBaseEntryField) or
              (FFocusedControl is TCustomEdit))) then begin
    if fscMouseOverBtn then begin
      if Integer(GetTickCount) > fscNextMsgTime then begin

        {auto link with Orpheus entry fields}
        if Assigned(FFocusedControl) and (FFocusedControl is TOvcBaseEntryField) then begin
          case State of
            ssUpBtn : TOvcBaseEntryField(FFocusedControl).IncreaseValue(FWrapMode, Delta);
            ssDownBtn : TOvcBaseEntryField(FFocusedControl).DecreaseValue(FWrapMode, Delta);
            ssLeftBtn : TOvcBaseEntryField(FFocusedControl).MoveCaret(-1);
            ssRightBtn : TOvcBaseEntryField(FFocusedControl).MoveCaret(+1);
          end;
        end;

        {auto link with TCustomEdit controls}
        if Assigned(FFocusedControl) and (FFocusedControl is TCustomEdit) then begin
          try
            D := StrToFloat(TCustomEdit(FFocusedControl).Text);
            case State of
              ssUpBtn :
                TCustomEdit(FFocusedControl).Text := FloatToStr(D + Delta);
              ssDownBtn :
                TCustomEdit(FFocusedControl).Text := FloatToStr(D - Delta);
            end;
          except
          end;
        end;

        {call OnClick event handler, if assigned}
        if Assigned(FOnClick) then
          FOnClick(Self, State, Delta, FWrapMode);

        {setup for next time}
        fscNextMsgTime := Integer(GetTickCount) + DelayTime - Acceleration*10*FRepeatCount;
        Inc(FRepeatCount);
      end;
    end;
  end;
end;

procedure TOvcFlatSpinner.Loaded;
begin
  inherited Loaded;

  fscUpdateSizes;
end;

procedure TOvcFlatSpinner.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = FFocusedControl) and (Operation = opRemove) then
    FocusedControl := nil;
end;

procedure TOvcFlatSpinner.OMRecreateWnd(var Msg : TMessage);
begin
  RecreateWnd;
end;

function TOvcFlatSpinner.fscCheckMousePos : TOvcFlatSpinState;
var
  P           : TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);

  {see which button the mouse is over}
  Result := ssNone;
  if PtInRect(ClientRect, P) then begin
    if not (csClicked in ControlState) then
      Result := ssNormal

    {mouse is over one of the buttons, which one?}
    else if (fscUpRgn <> 0) and PtInRegion(fscUpRgn, P.X, P.Y) then
      if (Style = stNormalHorizontal) then
        Result := ssRightBtn
      else
        Result := ssUpBtn
    else if (fscDownRgn <> 0) and PtInRegion(fscDownRgn, P.X, P.Y) then
      if (Style = stNormalHorizontal) then
        Result := ssLeftBtn
      else
      Result := ssDownBtn
    else if (fscLeftRgn <> 0) and PtInRegion(fscLeftRgn, P.X, P.Y) then
      Result := ssLeftBtn
    else if (fscRightRgn <> 0) and PtInRegion(fscRightRgn, P.X, P.Y) then
      Result := ssRightBtn
    else if (fscCenterRgn <> 0) and PtInRegion(fscCenterRgn, P.X, P.Y) then
      Result := ssCenterBtn
    else
      Result := ssNormal;
  end;
end;

procedure TOvcFlatSpinner.fscDeleteRegions;
begin
  if fscUpRgn <> 0 then begin
    DeleteObject(fscUpRgn);
    fscUpRgn := 0;
  end;
  if fscDownRgn <> 0 then begin
    DeleteObject(fscDownRgn);
    fscDownRgn := 0;
  end;
  if fscLeftRgn <> 0 then begin
    DeleteObject(fscLeftRgn);
    fscLeftRgn := 0;
  end;
  if fscRightRgn <> 0 then begin
    DeleteObject(fscRightRgn);
    fscRightRgn := 0;
  end;
  if fscCenterRgn <> 0 then begin
    DeleteObject(fscCenterRgn);
    fscCenterRgn := 0;
  end;
end;

procedure TOvcFlatSpinner.fscDoAutoRepeat;
var
  NewState : TOvcFlatSpinState;
begin
  DoOnClick(fscCurrentState);

  {don't auto-repeat for center button}
  if (fscCurrentState = ssCenterBtn) or (not AutoRepeat) then begin
    repeat
      {allow other messages}
      Application.ProcessMessages;

      {until the mouse button is released}
    until (GetAsyncKeyState(fscLButton) and $8000) = 0;
    fscDoMouseUp;
    Exit;
  end;

  {repeat until left button released}
  repeat
    if AutoRepeat then
      DoOnClick(fscCurrentState);

    {allow other messages}
    Application.ProcessMessages;

    {get new button/mouse state}
    NewState := fscCheckMousePos;

    {has anything changed}
    if NewState <> fscCurrentState then begin
      {the mouse is not over a button or its over a new one}
      fscPrevState := fscCurrentState;
      fscCurrentState := NewState;

      {don't depress the center button if the mouse moves over it}
      if NewState = ssCenterBtn then
        fscCurrentState := ssNormal;

      fscMouseOverBtn := not (fscCurrentState in [ssNone, ssNormal]);

      fscInvalidateButton(fscPrevState);
      fscInvalidateButton(fscCurrentState);
    end;

    {until the mouse button is released}
  until (GetAsyncKeyState(fscLButton) and $8000) = 0;
  fscDoMouseUp;
end;

procedure TOvcFlatSpinner.fscDoMouseDown(const XPos, YPos: Integer);
begin
  fscPrevState := fscCurrentState;

  {find which button was clicked}
  fscCurrentState := fscCheckMousePos;
  fscMouseOverBtn := True;

  fscInvalidateButton(fscPrevState);
  fscInvalidateButton(fscCurrentState);

  {initialize and start repeating}
  FRepeatCount := 0;
  fscLButton := GetLeftButton;
  fscNextMsgTime := GetTickCount-1;
  fscDoAutoRepeat;
end;

procedure TOvcFlatSpinner.fscDoMouseUp;
begin
  {save last state and redraw}
  fscPrevState := fscCurrentState;
  fscCurrentState := ssNormal;
  fscMouseOverBtn := False;

  fscInvalidateButton(fscPrevState);
  fscInvalidateButton(fscCurrentState);
  fscDrawButton(False);
end;


procedure TOvcFlatSpinner.fscDrawArrow(const R: TRect; const Pressed: Boolean;
  const Direction: TOvcFlatDirection);
var
  ArrowWidth, ArrowHeight : Integer;
  X, Y : Integer;
  LeftPoint, RightPoint, PointPoint : TPoint;
  PLeftPoint, PRightPoint, PPointPoint : TPoint;
begin
  if not FShowArrows then
    Exit;

  with Canvas do begin
    ArrowWidth := GetArrowWidth(R.Right-R.Left, R.Bottom-R.Top);
    ArrowHeight := (ArrowWidth + 1) div 2;
    if Direction in [dUp, dDown] then begin
      X := (R.Right-R.Left-ArrowWidth) div 2;
      Y := (R.Bottom-R.Top-ArrowHeight) div 2;
    end else begin
      X := (R.Right-R.Left-ArrowHeight) div 2;
      Y := (R.Bottom-R.Top-ArrowWidth) div 2;
    end;
    case Direction of
      dUp :
        begin
          LeftPoint  := Point(R.Left + X, Y + ArrowHeight + R.Top - 1);
          RightPoint := Point(R.Left + X + ArrowWidth - 1, Y + ArrowHeight + R.Top -1 );
          PointPoint := Point(R.Left + X + (ArrowWidth div 2), Y + R.Top);
        end;
      dDown :
        begin
          LeftPoint  := Point(R.Left + X, Y + R.Top);
          RightPoint := Point(R.Left + X + ArrowWidth - 1 , Y + R.Top);
          PointPoint := Point(R.Left + X + (ArrowWidth div 2), Y + ArrowHeight + R.Top - 1);
        end;
      dRight :
        begin
          LeftPoint  := Point(R.Left + X, Y + R.Top);
          RightPoint := Point(R.Left + X, Y + ArrowWidth + R.Top - 1);
          PointPoint := Point(R.Left + X + ArrowHeight - 1, Y + (ArrowWidth div 2) + R.Top);
        end;
      dLeft  :
        begin
          LeftPoint  := Point(R.Left + X + ArrowHeight - 1, Y + R.Top);
          RightPoint := Point(R.Left + X + ArrowHeight - 1, Y + ArrowWidth - 1 + R.Top);
          PointPoint := Point(R.Left + X, Y + (ArrowWidth div 2) + R.Top);
        end;
    end;
    PLeftPoint.X := LeftPoint.X + 1;
    PLeftPoint.Y := LeftPoint.Y + 1;
    PRightPoint.X := RightPoint.X + 1;
    PRightPoint.Y := RightPoint.Y + 1;
    PPointPoint.X := PointPoint.X + 1;
    PPointPoint.Y := PointPoint.Y + 1;
    if Pressed then begin
      Pen.Color := FFaceColor;
      Brush.Color := FFaceColor;
      Polygon([LeftPoint, RightPoint, PointPoint]);
      Pen.Color := FArrowColor;
      Brush.Color := FArrowColor;
      Polygon([PLeftPoint, PRightPoint, PPointPoint]);
    end else begin
      Pen.Color := FFaceColor;
      Brush.Color := FFaceColor;
      Polygon([PLeftPoint, PRightPoint, PPointPoint]);
      Pen.Color := FArrowColor;
      Brush.Color := FArrowColor;
      Polygon([LeftPoint, RightPoint, PointPoint]);
    end;
  end;
end;

procedure TOvcFlatSpinner.fscDrawButton(const Redraw : Boolean);
begin
  case FStyle of
    stDiagonalFourWay    : fscDrawDiagonalFourWay(Redraw);
    stDiagonalHorizontal : fscDrawDiagonalHorizontal(Redraw);
    stDiagonalVertical   : fscDrawDiagonalVertical(Redraw);
    stFourWay            : fscDrawFourWayButton(Redraw);
    stNormalHorizontal   : fscDrawNormalButton(Redraw);
    stNormalVertical     : fscDrawNormalButton(Redraw);
    stPlainStar          : fscDrawPlainStar(Redraw);
    stStar               : fscDrawStarButton(Redraw);
  end;
end;

procedure TOvcFlatSpinner.fscDrawDiagonalFourWay(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := FFaceColor;
      Brush.Style := bsSolid;
      Pen.Color := FFaceColor;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
      fscDrawLine(fscBottomLeft4, fscTopRight4, True, ltSingle);
      fscDrawLine(fscBottomLeft, fscTopLeft, True, ltTopBevel);
      fscDrawLine(fscTopLeft, fscTopRight, True, ltTopBevel);
      fscDrawLine(fscBottomLeft, fscBottomRight, True, ltBottomBevel);
      fscDrawLine(fscBottomRight, fscTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          fscDrawArrow(Rect(Width Div 4, 0, Width Div 2, Height div 2), not(Up), dUp);
          fscDrawLine(fscTopLeft4, fscTopRight4, Up, ltTopBevel);
          fscDrawLine(fscTopLeft4, fscBottomLeft4, Up, ltDiagTopBevel);
          fscDrawLine(fscBottomLeft4, fscTopRight4, Up, ltBottomSlice);
        end;
        ssDownBtn  : begin
          fscDrawArrow(Rect(Width Div 2, (Height+1) div 2,
                            Width * 3 Div 4, Height), not(Up), dDown);
          fscDrawLine(fscBottomRight4, fscBottomLeft4, Up, ltBottomBevel);
          fscDrawLine(fscTopRight4, fscBottomRight4, Up, ltDiagBottomBevel);
          fscDrawLine(fscBottomLeft4, fscTopRight4, Up, ltTopSlice);
        end;
        ssLeftBtn : begin
          fscDrawArrow(Rect(0, 0, Width Div 4, Height), not(Up), dLeft);
          fscDrawLine(fscTopLeft, fscTopLeft4, Up, ltTopBevel);
          fscDrawLine(fscTopLeft, fscBottomLeft, Up, ltTopBevel);
          fscDrawLine(fscTopLeft4, fscBottomLeft4, Up, ltBottomBevel);
          fscDrawLine(fscBottomLeft, fscBottomLeft4, Up, ltBottomBevel);
        end;
        ssRightBtn : begin
          fscDrawArrow(Rect(Width * 3 Div 4, 0, Width, Height), not(Up), dRight);
          fscDrawLine(fscTopRight4, fscTopRight, Up, ltTopBevel);
          fscDrawLine(fscTopRight4, fscBottomRight4, Up, ltTopBevel);
          fscDrawLine(fscTopRight, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscBottomRight4, fscBottomRight, Up, ltBottomBevel);
        end;
      end;
    end;
  end;

begin
  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscDrawDiagonalHorizontal(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := FFaceColor;
      Brush.Style := bsSolid;
      Pen.Color := FFaceColor;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
      fscDrawLine(fscBottomLeft, fscTopRight, True, ltSingle);
      fscDrawLine(fscBottomLeft, fscTopLeft, True, ltTopBevel);
      fscDrawLine(fscTopLeft, fscTopRight, True, ltTopBevel);
      fscDrawLine(fscBottomLeft, fscBottomRight, True, ltBottomBevel);
      fscDrawLine(fscBottomRight, fscTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssLeftBtn : begin
          fscDrawArrow(Rect(0, 0, Width div 2, (Height div 2)), not(Up), dLeft);
          fscDrawLine(fscTopLeft, fscTopRight, Up, ltTopBevel);
          fscDrawLine(fscTopLeft, fscBottomLeft, Up, ltTopBevel);
          fscDrawLine(fscBottomLeft, fscTopRight, Up, ltBottomSlice);
        end;
        ssRightBtn  : begin
          fscDrawArrow(Rect((Width+1) div 2, (Height+1) div 2, Width, Height),
                             not(Up), dRight);
          fscDrawLine(fscBottomLeft, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscTopRight, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscBottomLeft, fscTopRight, Up, ltTopSlice);
        end;
      end;
    end;
  end;

begin
  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscDrawDiagonalVertical(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := FFaceColor;
      Brush.Style := bsSolid;
      Pen.Color := FFaceColor;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
      fscDrawLine(fscBottomLeft, fscTopRight, True, ltSingle);
      fscDrawLine(fscBottomLeft, fscTopLeft, True, ltTopBevel);
      fscDrawLine(fscTopLeft, fscTopRight, True, ltTopBevel);
      fscDrawLine(fscBottomLeft, fscBottomRight, True, ltBottomBevel);
      fscDrawLine(fscBottomRight, fscTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          fscDrawArrow(Rect(0, 0, Width div 2, (Height div 2)), not(Up), dUp);
          fscDrawLine(fscTopLeft, fscTopRight, Up, ltTopBevel);
          fscDrawLine(fscTopLeft, fscBottomLeft, Up, ltTopBevel);
          fscDrawLine(fscBottomLeft, fscTopRight, Up, ltBottomSlice);
        end;
        ssDownBtn  : begin
          fscDrawArrow(Rect((Width+1) div 2, (Height+1) div 2, Width, Height),
                            not(Up), dDown);
          fscDrawLine(fscBottomLeft, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscTopRight, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscBottomLeft, fscTopRight, Up, ltTopSlice);
        end;
      end;
    end;
  end;

begin
  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscDrawFourWayButton(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := FFaceColor;
      Brush.Style := bsSolid;
      Pen.Color := FFaceColor;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
      fscDrawLine(fscTopLeft, fscBottomRight, True, ltSingle);
      fscDrawLine(fscBottomLeft, fscTopRight, True, ltSingle);
      fscDrawLine(fscBottomLeft, fscTopLeft, True, ltTopBevel);
      fscDrawLine(fscTopLeft, fscTopRight, True, ltTopBevel);
      fscDrawLine(fscBottomLeft, fscBottomRight, True, ltBottomBevel);
      fscDrawLine(fscBottomRight, fscTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          fscDrawArrow(Rect(0, 0, Width, (Height div 3)), not(Up), dUp);
          fscDrawLine(fscTopLeft, fscTopRight, Up, ltTopBevel);
          fscDrawLine(fscTopRight, fscCenter, Up, ltBottomSliceSquare);
          fscDrawLine(fscTopLeft, fscCenter, Up, ltBottomSliceSquare);
        end;
        ssDownBtn  : begin
          fscDrawArrow(Rect(0, Height - (Height div 3), Width, Height), not(Up), dDown);
          fscDrawLine(fscBottomLeft, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscBottomLeft, fscCenter, Up, ltTopSliceSquare);
          fscDrawLine(fscBottomRight, fscCenter, Up, ltTopSliceSquare);
        end;
        ssLeftBtn : begin
          fscDrawArrow(Rect(0, 0, (Width div 3), Height), not(Up), dLeft);
          fscDrawLine(fscTopLeft, fscBottomLeft, Up, ltTopBevel);
          fscDrawLine(fscBottomLeft, fscCenter, Up, ltBottomSliceSquare);
          fscDrawLine(fscTopLeft, fscCenter, Up, ltTopSliceSquare);
        end;
        ssRightBtn : begin
          fscDrawArrow(Rect(Width - (Width div 3), 0, Width, Height), not(Up), dRight);
          fscDrawLine(fscTopRight, fscBottomRight, Up, ltBottomBevel);
          fscDrawLine(fscTopRight, fscCenter, Up, ltTopSliceSquare);
          fscDrawLine(fscBottomRight, fscCenter, Up, ltBottomSliceSquare);
        end;
      end;
    end;
  end;

begin
  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscDrawLine(P1, P2 : TPoint;
                                      const Up : Boolean;
                                      LineType : TOvcFlatSpinnerLineType);
  {-this routine draws a parallel line}
  {The Offset is required because of the nature of Bressenham's algorithm}
  {Negative Offsets are above the line, and Positive Offsets are Below}

  function GetSlope(const P1, P2 : TPoint) : Extended;
  var
    dX, dY : Integer;
  begin
    dY := (P1.y - P2.y);
    dX := (P1.x - P2.x);

    if (dX = 0) then
      if dY > 0 then
        Result := 999999.0
      else
        Result := -999999.0
    else
      Result := dY / dX;
  end;

  procedure DrawLine(P1, P2 : TPoint; Offset : Integer; const Square : Boolean);
  var
    Slope : Extended;
    P : TPoint;
    P1Square, P2Square : Boolean;
  begin
    P2Square := Square;
    P1Square := False;
    if P1.x > P2.X then begin
      P := P1;
      P1 := P2;
      P2 := P;
      P2Square := False;
      P1Square := Square;
    end;

    Slope := GetSlope(P1, P2);

    if Slope >= 0 then begin
      if P1.x > fscTopMiddle.x then
        Offset := -Offset;
    end;

    if abs(Slope) <= 1 then begin
      if Slope = 0 then begin
        P1.y := P1.y + Offset;
        P2.y := P2.y + Offset;
        {these are to shorten the lines a little}
        P1.X := P1.X - Abs(Offset);
        P2.X := P2.X + Abs(Offset);
      end else if (Slope = 1) and (Offset > 0) then begin
        if P1Square then begin
          P1.X := P1.X + 0 * Abs(Offset);
          P1.y := P1.y + 1 * Abs(Offset);
        end else begin
          P1.X := P1.X + 2 * Abs(Offset);
          P1.y := P1.y + 3 * Abs(Offset);
        end;
        if P2Square then begin
          P2.X := P2.X - 1 * Abs(Offset);
          P2.y := P2.y - 0 * Abs(Offset);
        end else begin
          P2.X := P2.X - 3 * Abs(Offset);
          P2.y := P2.y - 2 * Abs(Offset);
        end;
      end else if (Slope = 1) and (Offset < 0) then begin
        if P1Square then begin
          P1.X := P1.X + 1 * Abs(Offset);
          P1.y := P1.y + 0 * Abs(Offset);
        end else begin
          P1.X := P1.X + 3 * Abs(Offset);
          P1.y := P1.y + 2 * Abs(Offset);
        end;
        if  P2Square then begin
          P2.X := P2.X - 0 * Abs(Offset);
          P2.y := P2.y - 1 * Abs(Offset);
        end else begin
          P2.X := P2.X - 2 * Abs(Offset);
          P2.y := P2.y - 3 * Abs(Offset);
        end;
      end else if (Slope = -1) and (Offset > 0) then begin
        if P1Square then begin
          P1.X := P1.X + 1 * Abs(Offset);
          P1.y := P1.y - 0 * Abs(Offset);
        end else begin
          P1.X := P1.X + 3 * Abs(Offset);
          P1.y := P1.y - 2 * Abs(Offset);
        end;
        if P2Square then begin
          P2.X := P2.X - 0 * Abs(Offset);
          P2.y := P2.y + 1 * Abs(Offset);
        end else begin
          P2.X := P2.X - 2 * Abs(Offset);
          P2.y := P2.y + 3 * Abs(Offset);
        end;
      end else if (Slope = -1) and (Offset < 0) then begin
        if P1Square then begin
          P1.X := P1.X + 0 * Abs(Offset);
          P1.y := P1.y - 1 * Abs(Offset);
        end else begin
          P1.X := P1.X + 2 * Abs(Offset);
          P1.y := P1.y - 3 * Abs(Offset);
        end;
        if P2Square then begin
          P2.X := P2.X - 1 * Abs(Offset);
          P2.y := P2.y + 0 * Abs(Offset);
        end else begin
          P2.X := P2.X - 3 * Abs(Offset);
          P2.y := P2.y + 2 * Abs(Offset);
        end;
      end else begin
        P1.y := P1.y + Offset;
        P2.y := P2.y + Offset;
      end;
    end else begin
      P1.x := P1.x + Offset;
      P2.x := P2.x + Offset;
      if ((P1.x - P2.x) = 0) then begin
        {These are to shorten the lines a little}
        if (P1.y - P2.y) > 0 then begin
          P1.Y := P1.Y - Abs(Offset);
          P2.Y := P2.Y + Abs(Offset);
        end else begin
          P1.Y := P1.Y + Abs(Offset);
          P2.Y := P2.Y - Abs(Offset);
        end;
      end;
    end;
    fscPolyLine([P1, P2]);
  end;

const
  SpinnerLines : array[TOvcFlatSpinnerLineType, 0..1] of -1..7 = (
    (7, -1), {ltSingle}
    (4,  1), {ltTopBevel}
    (3,  2), {ltBottomBevel}
    (4,  7), {ltTopSlice}
    (3,  7), {ltBottomSlice}
    (4,  7), {ltTopSliceSquare}
    (3,  7), {ltBottomSliceSquare}
    (4,  1), {ltDiagTopBevel}
    (3,  2), {ltDiagBottomBevel}
    (0, -1), {ltStarLine0}
    (3, -1), {ltStarLine1}
    (4,  1), {ltStarLine2}
    (3,  2), {ltStarLine3}
    (4,  7), {ltStarLine4}
    (2,  7)  {ltStarLine5}
  );

{ComplementLine is used for shading the Left/Right Lines}
  ComplementLine : array[TOvcFlatSpinnerLineType] of TOvcFlatSpinnerLineType = (
    ltSingle,            {ltSingle}
    ltTopBevel,          {ltTopBevel}
    ltBottomBevel,       {ltBottomBevel}
    ltBottomSlice,       {ltTopSlice}
    ltTopSlice,          {ltBottomSlice}
    ltBottomSliceSquare, {ltTopSliceSquare}
    ltTopSliceSquare,    {ltBottomSliceSquare}
    ltDiagBottomBevel,   {ltDiagTopBevel}
    ltDiagTopBevel,      {ltDiagBottomBevel}
    ltStarLine1,         {ltStarLine0}
    ltStarLine0,         {ltStarLine1}
    ltStarLine3,         {ltStarLine2}
    ltStarLine2,         {ltStarLine3}
    ltStarLine5,         {ltStarLine4}
    ltStarLine4          {ltStarLine5}
  );

var
  DrawSquare : Boolean;
  Offset : Integer;

begin
  with Canvas do begin
{if the line is on the other side then ComplementLine}
    if (GetSlope(P1, P2) > 1) then
      linetype := ComplementLine[LineType];

    Pen.Color := BtnColor[Up, SpinnerLines[LineType, 0]];
    DrawSquare := False;
    Offset := 0;

    case LineType of
      ltTopSlice    :
        begin
          Offset := 1;
        end;
      ltBottomSlice :
        begin
          Offset := -1;
        end;
      ltTopSliceSquare    :
        begin
          DrawSquare := True;
          Offset := 1;
        end;
      ltBottomSliceSquare :
        begin
          DrawSquare := True;
          Offset := -1;
        end;
      ltDiagTopBevel    :
        begin
          Offset := 1;
        end;
      ltDiagBottomBevel    :
        begin
          Offset := -1;
        end;
      ltStarLine2    :
        begin
          if P1.X = P2.X then begin
            Inc(P1.X);Inc(P1.y);Inc(P2.X);Dec(P2.y);
          end else begin
            Inc(P1.X);Inc(P1.y);Dec(P2.X);Inc(P2.y);
          end;
        end;
      ltStarLine3 :
        begin
          if P1.X = P2.X then begin
            Dec(P1.X);Inc(P1.y);Dec(P2.X);Dec(P2.y);
          end else begin
            Inc(P1.X);Dec(P1.y);Dec(P2.X);Dec(P2.y);
          end;
        end;
      ltStarLine4 :
        begin
          DrawSquare := True;
          Offset := 1;
        end;
      ltStarLine5 :
        begin
          DrawSquare := True;
          Offset := -1;
        end;
    end;

    DrawLine(P1, P2, Offset, DrawSquare);

    if SpinnerLines[LineType, 1] = -1 then
      Exit;

    Pen.Color := BtnColor[Up, SpinnerLines[LineType, 1]];
    DrawSquare := False;
    Offset := 0;

    case LineType of
      ltTopBevel    :
        begin
          Offset := 1;
        end;
      ltBottomBevel :
        begin
          Offset := -1;
        end;
      ltTopSliceSquare    :
        begin
          DrawSquare := True;
        end;
      ltBottomSliceSquare :
        begin
          DrawSquare := True;
        end;
      ltDiagTopBevel    :
        begin
          Offset := 2;
        end;
      ltDiagBottomBevel    :
        begin
          Offset := -2;
        end;
      ltStarLine2    :
        begin
          if P1.X = P2.X then begin
            Inc(P1.X);Inc(P1.y);Inc(P2.X);Dec(P2.y);
          end else begin
            Inc(P1.X);Inc(P1.y);Dec(P2.X);Inc(P2.y);
          end;
        end;
      ltStarLine3 :
        begin
          if P1.X = P2.X then begin
            Dec(P1.X);Inc(P1.y);Dec(P2.X);Dec(P2.y);
          end else begin
            Inc(P1.X);Dec(P1.y);Dec(P2.X);Dec(P2.y);
          end;
        end;
    end;

    DrawLine(P1, P2, Offset, DrawSquare);
  end;
end;

procedure TOvcFlatSpinner.DrawButton(C : TCanvas; R : TRect; Up : Boolean);
begin
  C.Pen.Width := 1;
  C.Brush.Color := FFaceColor;
  C.Brush.Style := bsSolid;
  C.FillRect(R);
  if (Up) then
    C.Pen.Color := FHighlightColor
  else
    C.Pen.Color := FShadowColor;
  C.MoveTo(R.Left, R.Bottom);
  C.LineTo(R.Left, R.Top);
  C.LineTo(R.Right, R.Top);

  if (Up) then
    C.Pen.Color := FShadowColor
  else
    C.Pen.Color := FHighlightColor;
  C.MoveTo(R.Left, R.Bottom-1);
  C.LineTo(R.Right, R.Bottom-1);
  C.LineTo(R.Right, R.Top);
end;


procedure TOvcFlatSpinner.fscDrawNormalButton(const Redraw : Boolean);
var
  TopPressed    : Boolean;
  BottomPressed : Boolean;
  UpRect        : TRect;
  DownRect      : TRect;

begin
  if (csClicked in ControlState) and fscMouseOverBtn then begin
    TopPressed := (fscCurrentState in [ssUpBtn, ssRightBtn]);
    BottomPressed := (fscCurrentState in [ssDownBtn, ssLeftBtn]);
  end else begin
    TopPressed := False;
    BottomPressed := False;
  end;
  GetRgnBox(fscUpRgn, UpRect);
  GetRgnBox(fscDownRgn, DownRect);
  if FStyle = stNormalVertical then begin
    Inc(UpRect.Right);
    Inc(UpRect.Bottom);
    Inc(DownRect.Top);
  end else begin
    Inc(UpRect.Bottom);
    Dec(DownRect.Right);
  end;
  Inc(DownRect.Bottom);
  Inc(DownRect.Right);

  DrawButton(Canvas, UpRect, not TopPressed);
  DrawButton(Canvas, DownRect, not BottomPressed);

  if FStyle = stNormalVertical then begin
    fscDrawArrow(UpRect, TopPressed, dUp);
    fscDrawArrow(DownRect, BottomPressed, dDown);
  end else begin
    fscDrawArrow(UpRect, TopPressed, dRight);
    fscDrawArrow(DownRect, BottomPressed, dLeft);
  end;
end;

procedure TOvcFlatSpinner.fscDrawPlainStar(const Redraw : Boolean);
var
  PC     : TColor;

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Pen.Color := FShadowColor;
      Brush.Color := PC;
      Brush.Style := bsSolid;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn    :
          begin
            fscDrawArrow(Rect(fscTopLeftCenter.X, fscTopMiddle.Y,
                              fscTopRightCenter.X, fscCenter.Y), not(Up), dUp);
            fscDrawLine(fscTopMiddle, fscTopRightCenter, Up, ltStarLine0);
            fscDrawLine(fscTopRightCenter, fscCenter, Up, ltStarLine5);
            fscDrawLine(fscCenter, fscTopLeftCenter, Up, ltStarLine5);
            fscDrawLine(fscTopMiddle, fscTopLeftCenter, Up, ltStarLine0);
          end;
        ssDownBtn  :
          begin
            fscDrawArrow(Rect(fscBottomLeftCenter.X, fscCenter.Y,
                              fscBottomRightCenter.X, fscBottomMiddle.Y), not(Up), dDown);
            fscDrawLine(fscBottomMiddle, fscBottomLeftCenter, Up, ltStarLine1);
            fscDrawLine(fscCenter, fscBottomLeftCenter, Up, ltStarLine4);
            fscDrawLine(fscBottomRightCenter, fscCenter, Up, ltStarLine4);
            fscDrawLine(fscBottomMiddle, fscBottomRightCenter, Up, ltStarLine1);
          end;
        ssLeftBtn  :
          begin
            fscDrawArrow(Rect(fscLeftMiddle.X, fscTopLeftCenter.Y,
                              fscCenter.X, fscBottomLeftCenter.Y), not(Up), dLeft);
            fscDrawLine(fscLeftMiddle, fscTopLeftCenter, Up, ltStarLine0);
            fscDrawLine(fscTopLeftCenter, fscCenter, Up, ltStarLine4);
            fscDrawLine(fscCenter, fscBottomLeftCenter, Up, ltStarLine5);
            fscDrawLine(fscBottomLeftCenter, fscLeftMiddle, Up, ltStarLine1);
          end;
        ssRightBtn :
          begin
            fscDrawArrow(Rect(fscCenter.X, fscTopRightCenter.Y,
                              fscRightMiddle.X, fscBottomRightCenter.Y),
                              not(Up), dRight);
            fscDrawLine(fscCenter, fscTopRightCenter, Up, ltStarLine4);
            fscDrawLine(fscTopRightCenter, fscRightMiddle, Up, ltStarLine0);
            fscDrawLine(fscRightMiddle, fscBottomRightCenter, Up, ltStarLine1);
            fscDrawLine(fscBottomRightCenter, fscCenter, Up, ltStarLine5);
          end;
      end;
    end;
  end;

begin
  PC := FFaceColor;

  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscDrawStarButton(const Redraw : Boolean);
var
  PC     : TColor;

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Pen.Color := FShadowColor;
      Brush.Color := PC;
      Brush.Style := bsSolid;
      FillRect(Rect(fscTopLeft.X, fscTopLeft.Y,
                    fscBottomRight.X, fscBottomRight.Y));
    end;
  end;

  procedure DrawFace(State : TOvcFlatSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn    :
          begin
            fscDrawArrow(Rect(fscTopLeftCenter.X, fscTopMiddle.Y,
                        fscTopRightCenter.X, fscTopLeftCenter.Y), not(Up), dUp);
            fscDrawLine(fscTopMiddle, fscTopRightCenter, Up, ltStarLine0);
            fscDrawLine(fscTopRightCenter, fscTopLeftCenter, Up, ltStarLine1);
            fscDrawLine(fscTopMiddle, fscTopLeftCenter, Up, ltStarLine0);
          end;
        ssDownBtn  :
          begin
            fscDrawArrow(Rect(fscBottomLeftCenter.X, fscBottomLeftCenter.Y,
              fscBottomRightCenter.X, fscBottomMiddle.Y), not(Up), dDown);
            fscDrawLine(fscBottomMiddle, fscBottomLeftCenter, Up, ltStarLine1);
            fscDrawLine(fscBottomRightCenter, fscBottomLeftCenter, Up, ltStarLine0);
            fscDrawLine(fscBottomMiddle, fscBottomRightCenter, Up, ltStarLine1);
          end;
        ssLeftBtn  :
          begin
            fscDrawArrow(Rect(fscLeftMiddle.X, fscTopLeftCenter.Y,
              fscTopLeftCenter.X, fscBottomLeftCenter.Y), not(Up), dLeft);
            fscDrawLine(fscLeftMiddle, fscTopLeftCenter, Up, ltStarLine0);
            fscDrawLine(fscTopLeftCenter, fscBottomLeftCenter, Up, ltStarLine1);
            fscDrawLine(fscBottomLeftCenter, fscLeftMiddle, Up, ltStarLine1);
          end;
        ssRightBtn :
          begin
            fscDrawArrow(Rect(fscTopRightCenter.X, fscTopRightCenter.Y,
              fscRightMiddle.X, fscBottomRightCenter.Y), not(Up), dRight);
            fscDrawLine(fscTopRightCenter, fscBottomRightCenter, Up, ltStarLine0);
            fscDrawLine(fscRightMiddle, fscTopRightCenter, Up, ltStarLine0);
            fscDrawLine(fscBottomRightCenter, fscRightMiddle, Up, ltStarLine1);
          end;
        ssCenterBtn :
          begin
            fscDrawLine(fscTopLeftCenter, fscTopRightCenter, Up, ltStarLine2);
            fscDrawLine(fscTopLeftCenter, fscBottomLeftCenter, Up, ltStarLine2);
            fscDrawLine(fscTopRightCenter, fscBottomRightCenter, Up, ltStarLine3);
            fscDrawLine(fscBottomLeftCenter, fscBottomRightCenter, Up, ltStarLine3);
          end;
      end;
    end;
  end;

begin
  PC := FFaceColor;

  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
      DrawFace(ssCenterBtn, True);
    end;

    if fscPrevState <> fscCurrentState then
      DrawFace(fscPrevState, True);
    if fscMouseOverBtn then
      DrawFace(fscCurrentState, False);
  end;
end;

procedure TOvcFlatSpinner.fscInvalidateButton(const State : TOvcFlatSpinState);
begin
  case State of
    ssUpBtn     : InvalidateRgn(Handle, fscUpRgn, False);
    ssDownBtn   : InvalidateRgn(Handle, fscDownRgn, False);
    ssLeftBtn   : InvalidateRgn(Handle, fscLeftRgn, False);
    ssRightBtn  : InvalidateRgn(Handle, fscRightRgn, False);
    ssCenterBtn : InvalidateRgn(Handle, fscCenterRgn, False);
  end;
end;

procedure TOvcFlatSpinner.fscPolyline(const Points: array of TPoint);
begin
  Canvas.Polyline(Points);
  with Points[High(Points)] do
    Canvas.Pixels[X,Y] := Canvas.Pen.Color;
end;

procedure TOvcFlatSpinner.fscUpdateNormalSizes;
var
  scHeight : Integer;      {Height of client area}
  scWidth  : Integer;      {Width of client area}
begin
  {get size of client area}
  scWidth := fscBottomRight.X;
  scHeight := fscBottomRight.Y;

  {setup the TRect structures with new sizes}
  if FStyle = stNormalVertical then begin
    fscUpRgn   := CreateRectRgn(0, 0, scWidth, scHeight div 2);
    fscDownRgn := CreateRectRgn(0, scHeight div 2, scWidth, scHeight);
  end else begin
    fscUpRgn   := CreateRectRgn(scWidth div 2, 0, scWidth, scHeight);
    fscDownRgn := CreateRectRgn(0, 0, scWidth div 2, scHeight);
  end;
end;

procedure TOvcFlatSpinner.fscUpdateFourWaySizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := fscTopLeft;
  Points[1] := fscTopRight;
  Points[2] := fscCenter;
  fscUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscBottomLeft;
  Points[1] := fscCenter;
  Points[2] := fscBottomRight;
  fscDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscTopLeft;
  Points[1] := fscCenter;
  Points[2] := fscBottomLeft;
  fscLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscTopRight;
  Points[1] := fscBottomRight;
  Points[2] := fscCenter;
  fscRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdateStarSizes;
var
  Points : array[0..3] of TPoint;
begin
  {up}
  Points[0] := fscTopMiddle;
  Points[1] := fscTopRightCenter;
  Points[2] := fscTopLeftCenter;
  fscUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {down}
  Points[0] := fscBottomMiddle;
  Points[1] := fscBottomLeftCenter;
  Points[2] := fscBottomRightCenter;
  fscDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {left}
  Points[0] := fscLeftMiddle;
  Points[1] := fscTopLeftCenter;
  Points[2] := fscBottomLeftCenter;
  fscLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {right}
  Points[0] := fscRightMiddle;
  Points[1] := fscBottomRightCenter;
  Points[2] := fscTopRightCenter;
  fscRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {center}
  Points[0] := fscTopLeftCenter;
  Points[1] := fscTopRightCenter;
  Points[2] := fscBottomRightCenter;
  Points[3] := fscBottomLeftCenter;
  fscCenterRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdateDiagonalVerticalSizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := fscTopLeft;
  Points[1] := fscTopRight;
  Points[2] := fscBottomLeft;
  fscUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscBottomLeft;
  Points[1] := fscTopRight;
  Points[2] := fscBottomRight;
  fscDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdateDiagonalHorizontalSizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := fscTopLeft;
  Points[1] := fscTopRight;
  Points[2] := fscBottomLeft;
  fscLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscBottomLeft;
  Points[1] := fscTopRight;
  Points[2] := fscBottomRight;
  fscRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdateDiagonalFourWaySizes;
var
  Points : array[0..3] of TPoint;
begin
  Points[0] := fscTopLeft4;
  Points[1] := fscTopRight4;
  Points[2] := fscBottomLeft4;
  fscUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscTopRight4;
  Points[1] := fscBottomRight4;
  Points[2] := fscBottomLeft4;
  fscDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := fscTopLeft;
  Points[1] := fscTopLeft4;
  Points[2] := fscBottomLeft4;
  Points[3] := fscBottomLeft;
  fscLeftRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := fscTopRight4;
  Points[1] := fscTopRight;
  Points[2] := fscBottomRight;
  Points[3] := fscBottomRight4;
  fscRightRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdatePlainStarSizes;
var
  Points : array[0..3] of TPoint;
begin
  Points[0] := fscTopMiddle;
  Points[1] := fscTopRightCenter;
  Points[2] := fscCenter;
  Points[3] := fscTopLeftCenter;
  fscUpRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := fscBottomLeftCenter;
  Points[1] := fscCenter;
  Points[2] := fscBottomRightCenter;
  Points[3] := fscBottomMiddle;
  fscDownRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := fscLeftMiddle;
  Points[1] := fscTopLeftCenter;
  Points[2] := fscCenter;
  Points[3] := fscBottomLeftCenter;
  fscLeftRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := fscTopRightCenter;
  Points[1] := fscRightMiddle;
  Points[2] := fscBottomRightCenter;
  Points[3] := fscCenter;
  fscRightRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcFlatSpinner.fscUpdateSizes;
begin
  {store info about button locations}
  fscDeleteRegions;

  case FStyle of
    stNormalVertical     : fscUpdateNormalSizes;
    stNormalHorizontal   : fscUpdateNormalSizes;
    stFourWay            : fscUpdateFourWaySizes;
    stStar               : fscUpdateStarSizes;
    stDiagonalVertical   : fscUpdateDiagonalVerticalSizes;
    stDiagonalHorizontal : fscUpdateDiagonalHorizontalSizes;
    stDiagonalFourWay    : fscUpdateDiagonalFourWaySizes;
    stPlainStar          : fscUpdatePlainStarSizes;
  end;
end;

procedure TOvcFlatSpinner.ResetBtnColor;
begin
  BtnColor[False][0] := FShadowColor;
  BtnColor[False][1] := FShadowColor;
  BtnColor[False][2] := FFaceColor;
  BtnColor[False][3] := FHighlightColor;
  BtnColor[False][4] := FShadowColor;
  BtnColor[False][5] := FHighlightColor;
  BtnColor[False][6] := clRed;
  BtnColor[False][7] := FShadowColor;

  BtnColor[True][0] := FHighlightColor;
  BtnColor[True][1] := FFaceColor;
  BtnColor[True][2] := FShadowColor;
  BtnColor[True][3] := FShadowColor;
  BtnColor[True][4] := FHighlightColor;
  BtnColor[True][5] := FFaceColor;
  BtnColor[True][6] := clGreen;
  BtnColor[True][7] := FShadowColor;
end;

procedure TOvcFlatSpinner.Paint;
begin
  ResetBtnColor;
  fscDrawButton(True);
end;

procedure TOvcFlatSpinner.SetAcceleration(const Value : Integer);
begin
  if Value <= 10 then
    FAcceleration := Value;
end;

procedure TOvcFlatSpinner.SetShowArrows(const Value : Boolean);
begin
  if Value <> FShowArrows then begin
    FShowArrows := Value;
    Invalidate;
  end;
end;

procedure TOvcFlatSpinner.SetStyle(Value : TOvcFlatSpinnerStyle);
begin
  if Value <> FStyle then begin
    FStyle := Value;
    RecreateWnd;
    if not (csLoading in ComponentState) then
      SetBounds(Left, Top, Width, Height);  {force resize}
  end;
end;


procedure TOvcFlatSpinner.SetArrowColor(Value : TColor);
begin
  FArrowColor := Value;
  Repaint;
end;

procedure TOvcFlatSpinner.SetFaceColor(Value : TColor);
begin
  FFaceColor := Value;
  Repaint;
end;

procedure TOvcFlatSpinner.SetHighlightColor(Value : TColor);
begin
  FHighlightColor := Value;
  Repaint;
end;

procedure TOvcFlatSpinner.SetShadowColor(Value : TColor);
begin
  FShadowColor := Value;
  Repaint;
end;


procedure TOvcFlatSpinner.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  {tell windows we are a static control to avoid receiving the focus}
  Msg.Result := DLGC_STATIC;
end;

procedure TOvcFlatSpinner.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  inherited;

  if Assigned(FFocusedControl) then begin
    if GetFocus <> FFocusedControl.Handle then begin
      {set focus to ourself to force field validation}
      SetFocus;

      {allow message processing}
      Application.ProcessMessages;

      {if we didn't keep the focus, something must have happened--exit}
      if (GetFocus <> Handle) then
        Exit;
    end;

    if GetFocus <> FFocusedControl.Handle then
      if FFocusedControl.CanFocus then
        FFocusedControl.SetFocus;
  end;

  try
    fscDoMouseDown(Msg.XPos, Msg.YPos);
  except
    fscDoMouseUp;
    raise;
  end;
end;

procedure TOvcFlatSpinner.WMLButtonUp(var Msg : TWMLButtonUp);
begin
  inherited;
  fscDoMouseUp;
end;


end.

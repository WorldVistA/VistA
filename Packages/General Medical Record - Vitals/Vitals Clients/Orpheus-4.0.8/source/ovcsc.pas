{*********************************************************}
{*                    OVCSC.PAS 4.08                     *}
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

(*Changes)

  01/15/02 - Set AutoRepeat modified to prevent deadlocks at runtime.
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcsc;
  {-Spin control}

interface

uses
  UITypes, Types, Windows, Buttons, Classes, Controls, Forms, Graphics,
  Messages, StdCtrls, SysUtils, OvcBase, OvcData, OvcEF, OvcMisc, OvcExcpt;

type
  TOvcSpinnerStyle = (stNormalVertical, stNormalHorizontal, stFourWay, stStar,
    stDiagonalVertical, stDiagonalHorizontal, stDiagonalFourWay,
    stPlainStar);

  TOvcDirection = (dUp, dDown, dRight, dLeft);

  TOvcSpinState = (ssNone, ssNormal, ssUpBtn, ssDownBtn, ssLeftBtn,
                   ssRightBtn, ssCenterBtn);

  TOvcSpinnerLineType = (ltSingle,
    ltTopBevel, ltBottomBevel, ltTopSlice, ltBottomSlice,
    ltTopSliceSquare, ltBottomSliceSquare,
    ltDiagTopBevel,ltDiagBottomBevel,
    ltStarLine0, ltStarLine1, ltStarLine2, ltStarLine3, ltStarLine4, ltStarLine5
    );

  TSpinClickEvent =
    procedure(Sender : TObject; State : TOvcSpinState; Delta : Double; Wrap : Boolean)
    of object;

type
  TOvcSpinner = class(TOvcCustomControl)
  protected {private}
    {property variables}
    FAcceleration    : Integer;         {value used to determine acceleration}
    FAutoRepeat      : Boolean;         {repeat if button held}
    FDelayTime       : Integer;
    FDelta           : Double;          {amount to change by}
    FRepeatCount     : Integer;
    FFocusedControl  : TWinControl;     {the control to give the focus to}
    FShowArrows      : Boolean;
    FStyle           : TOvcSpinnerStyle;
    FWrapMode        : Boolean;         {wrap at field bounderies}

    {events}
    FOnClick         : TSpinClickEvent;

    {private instance variables}
    scNextMsgTime    : Integer;

    {regions for the five spin button sections}
    scUpRgn          : hRgn;
    scDownRgn        : hRgn;
    scLeftRgn        : hRgn;
    scRightRgn       : hRgn;
    scCenterRgn      : hRgn;

    scCurrentState   : TOvcSpinState;
    scLButton        : Byte;
    scMouseOverBtn   : Boolean;
    scPrevState      : TOvcSpinState;
    scSizing         : Boolean;
    scTopLeft, scTopRight, scBottomLeft, scBottomRight, scCenter : TPoint;
    scTopLeftCenter, scBottomLeftCenter, scTopRightCenter, scBottomRightCenter : TPoint;
    scTopMiddle, scBottomMiddle, scLeftMiddle, scRightMiddle : TPoint;
    scTopLeft4, scBottomLeft4, scTopRight4, scBottomRight4 : TPoint;

    {property methods}
    procedure SetAcceleration(const Value : Integer);
    procedure SetAutoRepeat(Value: Boolean);
    procedure SetShowArrows(const Value : Boolean);
    procedure SetStyle(Value : TOvcSpinnerStyle);

    {internal methods}
    function scCheckMousePos : TOvcSpinState;
    procedure scDeleteRegions;
    procedure scDoAutoRepeat;
    procedure scDrawArrow(const R: TRect; const Pressed: Boolean; const Direction: TOvcDirection);
    procedure scDrawLine(P1, P2 : TPoint; const Up : Boolean; LineType : TOvcSpinnerLineType);
    procedure scDrawNormalButton(const Redraw : Boolean);
    procedure scDrawFourWayButton(const Redraw : Boolean);
    procedure scDrawStarButton(const Redraw : Boolean);
    procedure scDrawDiagonalVertical(const Redraw : Boolean);
    procedure scDrawDiagonalHorizontal(const Redraw : Boolean);
    procedure scDrawDiagonalFourWay(const Redraw : Boolean);
    procedure scDrawPlainStar(const Redraw : Boolean);
    procedure scDrawButton(const Redraw : Boolean);
    procedure scInvalidateButton(const State : TOvcSpinState);
    procedure scPolyline(const Points: array of TPoint);

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
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure Loaded;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure Paint;
      override;

    {dynamic event wrappers}
    procedure DoOnClick(State : TOvcSpinState);
      dynamic;

    procedure scDoMouseDown(const XPos, YPos: Integer);
      virtual;
    procedure scDoMouseUp;
      virtual;
    procedure scUpdateNormalSizes;
    procedure scUpdateFourWaySizes;
    procedure scUpdateStarSizes;
    procedure scUpdateDiagonalVerticalSizes;
    procedure scUpdateDiagonalHorizontalSizes;
    procedure scUpdateDiagonalFourWaySizes;
    procedure scUpdatePlainStarSizes;
    procedure scUpdateSizes;
      virtual;

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
    {properties}
    property Acceleration : Integer
      read FAcceleration write SetAcceleration
      default 5;
    property AutoRepeat : Boolean
      read FAutoRepeat write SetAutoRepeat;
    property Delta : Double
      read FDelta write FDelta;
    property DelayTime : Integer
      read FDelayTime write FDelayTime
      default 500;
    property FocusedControl : TWinControl
      read FFocusedControl write FFocusedControl;
    property ShowArrows : Boolean
      read FShowArrows write SetShowArrows
      default True;
    property Style : TOvcSpinnerStyle
      read FStyle write SetStyle
      default stNormalVertical;
    property WrapMode : Boolean
      read FWrapMode write FWrapMode
      default True;

    {inherited properties}
    property Anchors;
    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property Visible;

    {events}
    property OnClick : TSpinClickEvent
      read FOnClick write FOnClick;

    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation

uses
  OvcEdCal, OvcEdTim;

const
  scDefMinSize = 13;


{*** TOvcSpinner ***}

constructor TOvcSpinner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  ControlStyle := ControlStyle + [csReplicatable];

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

  scCurrentState := ssNormal;
  scPrevState    := ssNone;
  scMouseOverBtn := False;
end;

procedure TOvcSpinner.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);
  ControlStyle := ControlStyle + [csOpaque] - [csFramed];

  if not (csDesigning in ComponentState) then
    ControlStyle := ControlStyle - [csDoubleClicks];
end;

destructor TOvcSpinner.Destroy;
begin
  scDeleteRegions;

  inherited Destroy;
end;

procedure TOvcSpinner.DoOnClick(State : TOvcSpinState);
var
  D : Double;
begin
  if Assigned(FOnClick) or
     (Assigned(FFocusedControl) and
              ((FFocusedControl is TOvcBaseEntryField) or
              (FFocusedControl is TCustomEdit))) then begin
    if scMouseOverBtn then begin
      if Integer(GetTickCount) > scNextMsgTime then begin

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
            if (FFocusedControl is TOvcCustomDateEdit) then
              D := TOvcCustomDateEdit(FFocusedControl).Date
            else if (FFocusedControl is TOvcCustomTimeEdit) then
              D := TOvcCustomTimeEdit(FFocusedControl).AsMinutes
            else
              D := StrToFloat(TCustomEdit(FFocusedControl).Text);

            case State of
              ssUpBtn   : D := D + Delta;
              ssDownBtn : D := D - Delta;
            end;

            if (FFocusedControl is TOvcCustomDateEdit) then
              TOvcCustomDateEdit(FFocusedControl).Date := D
            else if (FFocusedControl is TOvcCustomTimeEdit) then
              TOvcCustomTimeEdit(FFocusedControl).AsMinutes := trunc(D)
            else
              TCustomEdit(FFocusedControl).Text := FloatToStr(D);
          except
          end;
        end;

        {call OnClick event handler, if assigned}
        if Assigned(FOnClick) then
          FOnClick(Self, State, Delta, FWrapMode);

        {setup for next time}
        scNextMsgTime := Integer(GetTickCount) + DelayTime - Acceleration*10*FRepeatCount;
        Inc(FRepeatCount);
      end;
    end;
  end;
end;

procedure TOvcSpinner.Loaded;
begin
  inherited Loaded;

  scUpdateSizes;
end;

procedure TOvcSpinner.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = FFocusedControl) and (Operation = opRemove) then
    FocusedControl := nil;
end;

procedure TOvcSpinner.OMRecreateWnd(var Msg : TMessage);
begin
  RecreateWnd;
end;

function TOvcSpinner.scCheckMousePos : TOvcSpinState;
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
    else if (scUpRgn <> 0) and PtInRegion(scUpRgn, P.X, P.Y) then
      if (Style = stNormalHorizontal) then
        Result := ssRightBtn
      else
        Result := ssUpBtn
    else if (scDownRgn <> 0) and PtInRegion(scDownRgn, P.X, P.Y) then
      if (Style = stNormalHorizontal) then
        Result := ssLeftBtn
      else
      Result := ssDownBtn
    else if (scLeftRgn <> 0) and PtInRegion(scLeftRgn, P.X, P.Y) then
      Result := ssLeftBtn
    else if (scRightRgn <> 0) and PtInRegion(scRightRgn, P.X, P.Y) then
      Result := ssRightBtn
    else if (scCenterRgn <> 0) and PtInRegion(scCenterRgn, P.X, P.Y) then
      Result := ssCenterBtn
    else
      Result := ssNormal;
  end;
end;

procedure TOvcSpinner.scDeleteRegions;
begin
  if scUpRgn <> 0 then begin
    DeleteObject(scUpRgn);
    scUpRgn := 0;
  end;
  if scDownRgn <> 0 then begin
    DeleteObject(scDownRgn);
    scDownRgn := 0;
  end;
  if scLeftRgn <> 0 then begin
    DeleteObject(scLeftRgn);
    scLeftRgn := 0;
  end;
  if scRightRgn <> 0 then begin
    DeleteObject(scRightRgn);
    scRightRgn := 0;
  end;
  if scCenterRgn <> 0 then begin
    DeleteObject(scCenterRgn);
    scCenterRgn := 0;
  end;
end;

procedure TOvcSpinner.scDoAutoRepeat;
var
  NewState : TOvcSpinState;
begin
  DoOnClick(scCurrentState);

  {don't auto-repeat for center button}
  if (scCurrentState = ssCenterBtn) or (not AutoRepeat) then begin
    repeat
      {allow other messages}
      Application.ProcessMessages;

      {until the mouse button is released}
    until (GetAsyncKeyState(scLButton) and $8000) = 0;
    scDoMouseUp;
    Exit;
  end;

  {repeat until left button released}
  repeat
    if AutoRepeat then
      DoOnClick(scCurrentState);

    {allow other messages}
    Application.ProcessMessages;

    {get new button/mouse state}
    NewState := scCheckMousePos;

    {has anything changed}
    if NewState <> scCurrentState then begin
      {the mouse is not over a button or its over a new one}
      scPrevState := scCurrentState;
      scCurrentState := NewState;

      {don't depress the center button if the mouse moves over it}
      if NewState = ssCenterBtn then
        scCurrentState := ssNormal;

      scMouseOverBtn := not (scCurrentState in [ssNone, ssNormal]);

      scInvalidateButton(scPrevState);
      scInvalidateButton(scCurrentState);
    end;

    {until the mouse button is released}
  until (GetAsyncKeyState(scLButton) and $8000) = 0;
  scDoMouseUp;
end;

procedure TOvcSpinner.scDoMouseDown(const XPos, YPos: Integer);
begin
  scPrevState := scCurrentState;

  {find which button was clicked}
  scCurrentState := scCheckMousePos;
  scMouseOverBtn := True;

  scInvalidateButton(scPrevState);
  scInvalidateButton(scCurrentState);

  {initialize and start repeating}
  FRepeatCount := 0;
  scLButton := GetLeftButton;
  scNextMsgTime := GetTickCount-1;
  scDoAutoRepeat;
end;

procedure TOvcSpinner.scDoMouseUp;
begin
  {save last state and redraw}
  scPrevState := scCurrentState;
  scCurrentState := ssNormal;
  scMouseOverBtn := False;

  scInvalidateButton(scPrevState);
  scInvalidateButton(scCurrentState);
  scDrawButton(False);
end;

procedure TOvcSpinner.scDrawArrow(const R: TRect; const Pressed: Boolean;
  const Direction: TOvcDirection);
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
      Pen.Color := clBtnFace;
      Brush.Color := clBtnFace;
      Polygon([LeftPoint, RightPoint, PointPoint]);
      Pen.Color := clBtnText;
      Brush.Color := clBtnText;
      Polygon([PLeftPoint, PRightPoint, PPointPoint]);
    end else begin
      Pen.Color := clBtnFace;
      Brush.Color := clBtnFace;
      Polygon([PLeftPoint, PRightPoint, PPointPoint]);
      Pen.Color := clBtnText;
      Brush.Color := clBtnText;
      Polygon([LeftPoint, RightPoint, PointPoint]);
    end;
  end;
end;

procedure TOvcSpinner.scDrawButton(const Redraw : Boolean);
begin
  case FStyle of
    stDiagonalFourWay    : scDrawDiagonalFourWay(Redraw);
    stDiagonalHorizontal : scDrawDiagonalHorizontal(Redraw);
    stDiagonalVertical   : scDrawDiagonalVertical(Redraw);
    stFourWay            : scDrawFourWayButton(Redraw);
    stNormalHorizontal   : scDrawNormalButton(Redraw);
    stNormalVertical     : scDrawNormalButton(Redraw);
    stPlainStar          : scDrawPlainStar(Redraw);
    stStar               : scDrawStarButton(Redraw);
  end;
end;

procedure TOvcSpinner.scDrawDiagonalFourWay(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Pen.Color := clBtnFace;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y, scBottomRight.X, scBottomRight.Y));
      scDrawLine(scBottomLeft4, scTopRight4, True, ltSingle);
      scDrawLine(scBottomLeft, scTopLeft, True, ltTopBevel);
      scDrawLine(scTopLeft, scTopRight, True, ltTopBevel);
      scDrawLine(scBottomLeft, scBottomRight, True, ltBottomBevel);
      scDrawLine(scBottomRight, scTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          scDrawArrow(Rect(Width Div 4, 0, Width Div 2, Height div 2), not(Up), dUp);
          scDrawLine(scTopLeft4, scTopRight4, Up, ltTopBevel);
          scDrawLine(scTopLeft4, scBottomLeft4, Up, ltDiagTopBevel);
          scDrawLine(scBottomLeft4, scTopRight4, Up, ltBottomSlice);
        end;
        ssDownBtn  : begin
          scDrawArrow(Rect(Width Div 2, (Height+1) div 2, Width * 3 Div 4, Height), not(Up), dDown);
          scDrawLine(scBottomRight4, scBottomLeft4, Up, ltBottomBevel);
          scDrawLine(scTopRight4, scBottomRight4, Up, ltDiagBottomBevel);
          scDrawLine(scBottomLeft4, scTopRight4, Up, ltTopSlice);
        end;
        ssLeftBtn : begin
          scDrawArrow(Rect(0, 0, Width Div 4, Height), not(Up), dLeft);
          scDrawLine(scTopLeft, scTopLeft4, Up, ltTopBevel);
          scDrawLine(scTopLeft, scBottomLeft, Up, ltTopBevel);
          scDrawLine(scTopLeft4, scBottomLeft4, Up, ltBottomBevel);
          scDrawLine(scBottomLeft, scBottomLeft4, Up, ltBottomBevel);
        end;
        ssRightBtn : begin
          scDrawArrow(Rect(Width * 3 Div 4, 0, Width, Height), not(Up), dRight);
          scDrawLine(scTopRight4, scTopRight, Up, ltTopBevel);
          scDrawLine(scTopRight4, scBottomRight4, Up, ltTopBevel);
          scDrawLine(scTopRight, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scBottomRight4, scBottomRight, Up, ltBottomBevel);
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

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scDrawDiagonalHorizontal(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Pen.Color := clBtnFace;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y, scBottomRight.X, scBottomRight.Y));
      scDrawLine(scBottomLeft, scTopRight, True, ltSingle);
      scDrawLine(scBottomLeft, scTopLeft, True, ltTopBevel);
      scDrawLine(scTopLeft, scTopRight, True, ltTopBevel);
      scDrawLine(scBottomLeft, scBottomRight, True, ltBottomBevel);
      scDrawLine(scBottomRight, scTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssLeftBtn : begin
          scDrawArrow(Rect(0, 0, Width div 2, (Height div 2)), not(Up), dLeft);
          scDrawLine(scTopLeft, scTopRight, Up, ltTopBevel);
          scDrawLine(scTopLeft, scBottomLeft, Up, ltTopBevel);
          scDrawLine(scBottomLeft, scTopRight, Up, ltBottomSlice);
        end;
        ssRightBtn  : begin
          scDrawArrow(Rect((Width+1) div 2, (Height+1) div 2, Width, Height), not(Up), dRight);
          scDrawLine(scBottomLeft, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scTopRight, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scBottomLeft, scTopRight, Up, ltTopSlice);
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

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scDrawDiagonalVertical(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Pen.Color := clBtnFace;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y, scBottomRight.X, scBottomRight.Y));
      scDrawLine(scBottomLeft, scTopRight, True, ltSingle);
      scDrawLine(scBottomLeft, scTopLeft, True, ltTopBevel);
      scDrawLine(scTopLeft, scTopRight, True, ltTopBevel);
      scDrawLine(scBottomLeft, scBottomRight, True, ltBottomBevel);
      scDrawLine(scBottomRight, scTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          scDrawArrow(Rect(0, 0, Width div 2, (Height div 2)), not(Up), dUp);
          scDrawLine(scTopLeft, scTopRight, Up, ltTopBevel);
          scDrawLine(scTopLeft, scBottomLeft, Up, ltTopBevel);
          scDrawLine(scBottomLeft, scTopRight, Up, ltBottomSlice);
        end;
        ssDownBtn  : begin
          scDrawArrow(Rect((Width+1) div 2, (Height+1) div 2, Width, Height), not(Up), dDown);
          scDrawLine(scBottomLeft, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scTopRight, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scBottomLeft, scTopRight, Up, ltTopSlice);
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

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scDrawFourWayButton(const Redraw : Boolean);

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      Pen.Color := clBtnFace;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y, scBottomRight.X, scBottomRight.Y));
      scDrawLine(scTopLeft, scBottomRight, True, ltSingle);
      scDrawLine(scBottomLeft, scTopRight, True, ltSingle);
      scDrawLine(scBottomLeft, scTopLeft, True, ltTopBevel);
      scDrawLine(scTopLeft, scTopRight, True, ltTopBevel);
      scDrawLine(scBottomLeft, scBottomRight, True, ltBottomBevel);
      scDrawLine(scBottomRight, scTopRight, True, ltBottomBevel);
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn : begin
          scDrawArrow(Rect(0, 0, Width, (Height div 3)), not(Up), dUp);
          scDrawLine(scTopLeft, scTopRight, Up, ltTopBevel);
          scDrawLine(scTopRight, scCenter, Up, ltBottomSliceSquare);
          scDrawLine(scTopLeft, scCenter, Up, ltBottomSliceSquare);
        end;
        ssDownBtn  : begin
          scDrawArrow(Rect(0, Height - (Height div 3), Width, Height), not(Up), dDown);
          scDrawLine(scBottomLeft, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scBottomLeft, scCenter, Up, ltTopSliceSquare);
          scDrawLine(scBottomRight, scCenter, Up, ltTopSliceSquare);
        end;
        ssLeftBtn : begin
          scDrawArrow(Rect(0, 0, (Width div 3), Height), not(Up), dLeft);
          scDrawLine(scTopLeft, scBottomLeft, Up, ltTopBevel);
          scDrawLine(scBottomLeft, scCenter, Up, ltBottomSliceSquare);
          scDrawLine(scTopLeft, scCenter, Up, ltTopSliceSquare);
        end;
        ssRightBtn : begin
          scDrawArrow(Rect(Width - (Width div 3), 0, Width, Height), not(Up), dRight);
          scDrawLine(scTopRight, scBottomRight, Up, ltBottomBevel);
          scDrawLine(scTopRight, scCenter, Up, ltTopSliceSquare);
          scDrawLine(scBottomRight, scCenter, Up, ltBottomSliceSquare);
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

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scDrawLine(P1, P2 : TPoint; const Up : Boolean; LineType : TOvcSpinnerLineType);
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
      if P1.x > scTopMiddle.x then
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
    scPolyLine([P1, P2]);
  end;

const
  BtnColor : array[Boolean, 0..7] of TColor = (
    (clBtnShadow, clBtnShadow, clBtnFace,
        clBtnHighlight, clWindowFrame, clBtnHighLight, clRed, clWindowFrame),
    (clBtnHighlight, clBtnFace, clBtnShadow,
        clWindowFrame, clBtnHighlight, clBtnFace, clGreen, clWindowFrame));
  SpinnerLines : array[TOvcSpinnerLineType, 0..1] of -1..7 = (
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
  ComplementLine : array[TOvcSpinnerLineType] of TOvcSpinnerLineType = (
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

procedure TOvcSpinner.scDrawNormalButton(const Redraw : Boolean);
var
  TopPressed    : Boolean;
  BottomPressed : Boolean;
  UpRect        : TRect;
  DownRect      : TRect;

begin
  if (csClicked in ControlState) and scMouseOverBtn then begin
    TopPressed := (scCurrentState in [ssUpBtn, ssRightBtn]);
    BottomPressed := (scCurrentState in [ssDownBtn, ssLeftBtn]);
  end else begin
    TopPressed := False;
    BottomPressed := False;
  end;
  GetRgnBox(scUpRgn, UpRect);
  GetRgnBox(scDownRgn, DownRect);
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
  DrawButtonFace(Canvas, UpRect, 1, bsNew, False, TopPressed, False);
  DrawButtonFace(Canvas, DownRect, 1, bsNew, False, BottomPressed, False);
  if FStyle = stNormalVertical then begin
    scDrawArrow(UpRect, TopPressed, dUp);
    scDrawArrow(DownRect, BottomPressed, dDown);
  end else begin
    scDrawArrow(UpRect, TopPressed, dRight);
    scDrawArrow(DownRect, BottomPressed, dLeft);
  end;
end;

procedure TOvcSpinner.scDrawPlainStar(const Redraw : Boolean);
var
  PC     : TColor;

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Pen.Color := clWindowFrame;
      Brush.Color := PC;
      Brush.Style := bsSolid;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y, scBottomRight.X, scBottomRight.Y));
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn    :
          begin
            scDrawArrow(Rect(scTopLeftCenter.X, scTopMiddle.Y, scTopRightCenter.X, scCenter.Y), not(Up), dUp);
            scDrawLine(scTopMiddle, scTopRightCenter, Up, ltStarLine0);
            scDrawLine(scTopRightCenter, scCenter, Up, ltStarLine5);
            scDrawLine(scCenter, scTopLeftCenter, Up, ltStarLine5);
            scDrawLine(scTopMiddle, scTopLeftCenter, Up, ltStarLine0);
          end;
        ssDownBtn  :
          begin
            scDrawArrow(Rect(scBottomLeftCenter.X, scCenter.Y, scBottomRightCenter.X, scBottomMiddle.Y), not(Up), dDown);
            scDrawLine(scBottomMiddle, scBottomLeftCenter, Up, ltStarLine1);
            scDrawLine(scCenter, scBottomLeftCenter, Up, ltStarLine4);
            scDrawLine(scBottomRightCenter, scCenter, Up, ltStarLine4);
            scDrawLine(scBottomMiddle, scBottomRightCenter, Up, ltStarLine1);
          end;
        ssLeftBtn  :
          begin
            scDrawArrow(Rect(scLeftMiddle.X, scTopLeftCenter.Y, scCenter.X, scBottomLeftCenter.Y), not(Up), dLeft);
            scDrawLine(scLeftMiddle, scTopLeftCenter, Up, ltStarLine0);
            scDrawLine(scTopLeftCenter, scCenter, Up, ltStarLine4);
            scDrawLine(scCenter, scBottomLeftCenter, Up, ltStarLine5);
            scDrawLine(scBottomLeftCenter, scLeftMiddle, Up, ltStarLine1);
          end;
        ssRightBtn :
          begin
            scDrawArrow(Rect(scCenter.X, scTopRightCenter.Y, scRightMiddle.X, scBottomRightCenter.Y),not(Up), dRight);
            scDrawLine(scCenter, scTopRightCenter, Up, ltStarLine4);
            scDrawLine(scTopRightCenter, scRightMiddle, Up, ltStarLine0);
            scDrawLine(scRightMiddle, scBottomRightCenter, Up, ltStarLine1);
            scDrawLine(scBottomRightCenter, scCenter, Up, ltStarLine5);
          end;
      end;
    end;
  end;

begin
  {get current parent color}
  if (Parent is TCustomForm) then
    PC := TForm(Parent).Color
  else if (Parent is TCustomFrame) then
    PC := TFrame(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
    end;

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scDrawStarButton(const Redraw : Boolean);
var
  PC     : TColor;

  procedure DrawBasicShape;
  begin
    with Canvas do begin
      Pen.Color := clWindowFrame;
      Brush.Color := PC;
      Brush.Style := bsSolid;
      FillRect(Rect(scTopLeft.X, scTopLeft.Y,
        scBottomRight.X, scBottomRight.Y));
    end;
  end;

  procedure DrawFace(State : TOvcSpinState; Up : Boolean);
  begin
    with Canvas do begin
      case State of
        ssUpBtn    :
          begin
            scDrawArrow(Rect(scTopLeftCenter.X, scTopMiddle.Y,
              scTopRightCenter.X, scTopLeftCenter.Y), not(Up), dUp);
            scDrawLine(scTopMiddle, scTopRightCenter, Up, ltStarLine0);
            scDrawLine(scTopRightCenter, scTopLeftCenter, Up, ltStarLine1);
            scDrawLine(scTopMiddle, scTopLeftCenter, Up, ltStarLine0);
          end;
        ssDownBtn  :
          begin
            scDrawArrow(Rect(scBottomLeftCenter.X, scBottomLeftCenter.Y,
              scBottomRightCenter.X, scBottomMiddle.Y),not(Up), dDown);
            scDrawLine(scBottomMiddle, scBottomLeftCenter, Up, ltStarLine1);
            scDrawLine(scBottomRightCenter, scBottomLeftCenter, Up, ltStarLine0);
            scDrawLine(scBottomMiddle, scBottomRightCenter, Up, ltStarLine1);
          end;
        ssLeftBtn  :
          begin
            scDrawArrow(Rect(scLeftMiddle.X, scTopLeftCenter.Y,
              scTopLeftCenter.X, scBottomLeftCenter.Y), not(Up), dLeft);
            scDrawLine(scLeftMiddle, scTopLeftCenter, Up, ltStarLine0);
            scDrawLine(scTopLeftCenter, scBottomLeftCenter, Up, ltStarLine1);
            scDrawLine(scBottomLeftCenter, scLeftMiddle, Up, ltStarLine1);
          end;
        ssRightBtn :
          begin
            scDrawArrow(Rect(scTopRightCenter.X, scTopRightCenter.Y,
              scRightMiddle.X, scBottomRightCenter.Y), not(Up), dRight);
            scDrawLine(scTopRightCenter, scBottomRightCenter, Up, ltStarLine0);
            scDrawLine(scRightMiddle, scTopRightCenter, Up, ltStarLine0);
            scDrawLine(scBottomRightCenter, scRightMiddle, Up, ltStarLine1);
          end;
        ssCenterBtn :
          begin
            scDrawLine(scTopLeftCenter, scTopRightCenter, Up, ltStarLine2);
            scDrawLine(scTopLeftCenter, scBottomLeftCenter, Up, ltStarLine2);
            scDrawLine(scTopRightCenter, scBottomRightCenter, Up, ltStarLine3);
            scDrawLine(scBottomLeftCenter, scBottomRightCenter, Up, ltStarLine3);
          end;
      end;
    end;
  end;

begin
  {get current parent color}
  if (Parent is TCustomForm) then
    PC := TForm(Parent).Color
  else if (Parent is TCustomFrame) then
    PC := TFrame(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    if Redraw then begin
      DrawBasicShape;
      DrawFace(ssUpBtn, True);
      DrawFace(ssDownBtn, True);
      DrawFace(ssLeftBtn, True);
      DrawFace(ssRightBtn, True);
      DrawFace(ssCenterBtn, True);
    end;

    if scPrevState <> scCurrentState then
      DrawFace(scPrevState, True);
    if scMouseOverBtn then
      DrawFace(scCurrentState, False);
  end;
end;

procedure TOvcSpinner.scInvalidateButton(const State : TOvcSpinState);
begin
  case State of
    ssUpBtn     : InvalidateRgn(Handle, scUpRgn, False);
    ssDownBtn   : InvalidateRgn(Handle, scDownRgn, False);
    ssLeftBtn   : InvalidateRgn(Handle, scLeftRgn, False);
    ssRightBtn  : InvalidateRgn(Handle, scRightRgn, False);
    ssCenterBtn : InvalidateRgn(Handle, scCenterRgn, False);
  end;
end;

procedure TOvcSpinner.scPolyline(const Points: array of TPoint);
begin
  Canvas.Polyline(Points);
  with Points[High(Points)] do
    Canvas.Pixels[X,Y] := Canvas.Pen.Color;
end;

procedure TOvcSpinner.scUpdateNormalSizes;
var
  scHeight : Integer;      {Height of client area}
  scWidth  : Integer;      {Width of client area}
begin
  {get size of client area}
  scWidth := scBottomRight.X;
  scHeight := scBottomRight.Y;

  {setup the TRect structures with new sizes}
  if FStyle = stNormalVertical then begin
    scUpRgn   := CreateRectRgn(0, 0, scWidth, scHeight div 2);
    scDownRgn := CreateRectRgn(0, scHeight div 2, scWidth, scHeight);
  end else begin
    scUpRgn   := CreateRectRgn(scWidth div 2, 0, scWidth, scHeight);
    scDownRgn := CreateRectRgn(0, 0, scWidth div 2, scHeight);
  end;
end;

procedure TOvcSpinner.scUpdateFourWaySizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := scTopLeft;
  Points[1] := scTopRight;
  Points[2] := scCenter;
  scUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scBottomLeft;
  Points[1] := scCenter;
  Points[2] := scBottomRight;
  scDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scTopLeft;
  Points[1] := scCenter;
  Points[2] := scBottomLeft;
  scLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scTopRight;
  Points[1] := scBottomRight;
  Points[2] := scCenter;
  scRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcSpinner.scUpdateStarSizes;
var
  Points : array[0..3] of TPoint;
begin
  {up}
  Points[0] := scTopMiddle;
  Points[1] := scTopRightCenter;
  Points[2] := scTopLeftCenter;
  scUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {down}
  Points[0] := scBottomMiddle;
  Points[1] := scBottomLeftCenter;
  Points[2] := scBottomRightCenter;
  scDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {left}
  Points[0] := scLeftMiddle;
  Points[1] := scTopLeftCenter;
  Points[2] := scBottomLeftCenter;
  scLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {right}
  Points[0] := scRightMiddle;
  Points[1] := scBottomRightCenter;
  Points[2] := scTopRightCenter;
  scRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  {center}
  Points[0] := scTopLeftCenter;
  Points[1] := scTopRightCenter;
  Points[2] := scBottomRightCenter;
  Points[3] := scBottomLeftCenter;
  scCenterRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcSpinner.scUpdateDiagonalVerticalSizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := scTopLeft;
  Points[1] := scTopRight;
  Points[2] := scBottomLeft;
  scUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scBottomLeft;
  Points[1] := scTopRight;
  Points[2] := scBottomRight;
  scDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcSpinner.scUpdateDiagonalHorizontalSizes;
var
  Points : array[0..2] of TPoint;
begin
  Points[0] := scTopLeft;
  Points[1] := scTopRight;
  Points[2] := scBottomLeft;
  scLeftRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scBottomLeft;
  Points[1] := scTopRight;
  Points[2] := scBottomRight;
  scRightRgn := CreatePolygonRgn(Points, 3, ALTERNATE);
end;

procedure TOvcSpinner.scUpdateDiagonalFourWaySizes;
var
  Points : array[0..3] of TPoint;
begin
  Points[0] := scTopLeft4;
  Points[1] := scTopRight4;
  Points[2] := scBottomLeft4;
  scUpRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scTopRight4;
  Points[1] := scBottomRight4;
  Points[2] := scBottomLeft4;
  scDownRgn := CreatePolygonRgn(Points, 3, ALTERNATE);

  Points[0] := scTopLeft;
  Points[1] := scTopLeft4;
  Points[2] := scBottomLeft4;
  Points[3] := scBottomLeft;
  scLeftRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := scTopRight4;
  Points[1] := scTopRight;
  Points[2] := scBottomRight;
  Points[3] := scBottomRight4;
  scRightRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcSpinner.scUpdatePlainStarSizes;
var
  Points : array[0..3] of TPoint;
begin
  Points[0] := scTopMiddle;
  Points[1] := scTopRightCenter;
  Points[2] := scCenter;
  Points[3] := scTopLeftCenter;
  scUpRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := scBottomLeftCenter;
  Points[1] := scCenter;
  Points[2] := scBottomRightCenter;
  Points[3] := scBottomMiddle;
  scDownRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := scLeftMiddle;
  Points[1] := scTopLeftCenter;
  Points[2] := scCenter;
  Points[3] := scBottomLeftCenter;
  scLeftRgn := CreatePolygonRgn(Points, 4, ALTERNATE);

  Points[0] := scTopRightCenter;
  Points[1] := scRightMiddle;
  Points[2] := scBottomRightCenter;
  Points[3] := scCenter;
  scRightRgn := CreatePolygonRgn(Points, 4, ALTERNATE);
end;

procedure TOvcSpinner.scUpdateSizes;
begin
  {store info about button locations}
  scDeleteRegions;

  case FStyle of
    stNormalVertical     : scUpdateNormalSizes;
    stNormalHorizontal   : scUpdateNormalSizes;
    stFourWay            : scUpdateFourWaySizes;
    stStar               : scUpdateStarSizes;
    stDiagonalVertical   : scUpdateDiagonalVerticalSizes;
    stDiagonalHorizontal : scUpdateDiagonalHorizontalSizes;
    stDiagonalFourWay    : scUpdateDiagonalFourWaySizes;
    stPlainStar          : scUpdatePlainStarSizes;
  end;
end;

procedure TOvcSpinner.Paint;
begin
  scDrawButton(True);
end;

procedure TOvcSpinner.SetAcceleration(const Value : Integer);
begin
  if Value <= 10 then
    FAcceleration := Value;
end;

{ - Added}
procedure TOvcSpinner.SetAutoRepeat(Value: Boolean);
begin
  FAutoRepeat := Value;
  if FAutoRepeat and not (csLoading in ComponentState) then
    scDoAutoRepeat;
end;

procedure TOvcSpinner.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  L, T, H, W : Integer;
begin
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then begin
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

    scTopLeft     := Point(0           , 0  );
    scTopRight    := Point(Width-1     , 0  );
    scBottomLeft  := Point(0           , Height-1);
    scBottomRight := Point(Width-1     , Height-1);
    scCenter      := Point(Width div 2 , Height div 2 );

    scTopLeftCenter    := Point(Width * 1 div 3 , Height * 1 div 3 );
    scBottomLeftCenter := Point(Width * 1 div 3 , Height * 2 div 3 );
    scTopRightCenter   := Point(Width * 2 div 3 , Height * 1 div 3 );
    scBottomRightCenter:= Point(Width * 2 div 3 , Height * 2 div 3 );

    scTopMiddle   := Point(Width div 2 , 0 );
    scBottomMiddle:= Point(Width div 2 , Height - 1 );
    scLeftMiddle  := Point(0           , Height div 2 );
    scRightMiddle := Point(Width - 1   , Height div 2 );

    scTopLeft4    := Point(Width div 4    , 0 );
    scBottomLeft4 := Point(Width div 4    , Height - 1 );
    scTopRight4   := Point(Width * 3 div 4, 0 );
    scBottomRight4:= Point(Width * 3 div 4, Height - 1 );
  end;

  {update sizes of control and button regions}
  scUpdateSizes;

  if HandleAllocated then
    Invalidate;
end;

procedure TOvcSpinner.SetShowArrows(const Value : Boolean);
begin
  if Value <> FShowArrows then begin
    FShowArrows := Value;
    Invalidate;
  end;
end;

procedure TOvcSpinner.SetStyle(Value : TOvcSpinnerStyle);
begin
  if Value <> FStyle then begin
    FStyle := Value;
    RecreateWnd;
    if not (csLoading in ComponentState) then
      SetBounds(Left, Top, Width, Height);  {force resize}
  end;
end;

procedure TOvcSpinner.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  {tell windows we are a static control to avoid receiving the focus}
  Msg.Result := DLGC_STATIC;
end;

procedure TOvcSpinner.WMLButtonDown(var Msg : TWMLButtonDown);
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
    scDoMouseDown(Msg.XPos, Msg.YPos);
  except
    scDoMouseUp;
    raise;
  end;
end;

procedure TOvcSpinner.WMLButtonUp(var Msg : TWMLButtonUp);
begin
  inherited;
  scDoMouseUp;
end;


end.

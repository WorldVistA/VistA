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

unit ovclbl2;
  {-direction picker component}

interface

uses
  Windows, Classes, Controls, Graphics, Messages, OvcBase, OvcData, OvcMisc;

type
  TOvcCustomDirectionPicker = class(TOvcGraphicControl)
  protected {private}
    {property variables}
    FDirection       : Integer;
    FNumDirections   : Integer;
    FSelectedBitmap  : TBitmap;
    FShowCenter      : Boolean;
    FDirectionBitmap : TBitmap;

    {event variables}
    FOnChange        : TNotifyEvent;

    {property methods}
    procedure SetDirection(Value : Integer);
    procedure SetSelectedBitmap(Value : TBitmap);
    procedure SetNumDirections(Value : Integer);
    procedure SetShowCenter(Value : Boolean);
    procedure SetDirectionBitmap(Value : TBitmap);

  protected
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Paint;
      override;

    property Direction : Integer
      read FDirection write SetDirection default 0;
    property NumDirections : Integer
      read FNumDirections write SetNumDirections default 8;
    property SelectedBitmap : TBitmap
      read FSelectedBitmap write SetSelectedBitmap;
    property ShowCenter : Boolean
      read FShowCenter write SetShowCenter default True;
    property DirectionBitmap : TBitmap
      read FDirectionBitmap write SetDirectionBitmap;

    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;

  public
    constructor Create(AComponent : TComponent);
      override;
    destructor Destroy;
      override;
  end;

  TOvcDirectionPicker = class(TOvcCustomDirectionPicker)
  published
    property Direction;
    property Enabled;
    property SelectedBitmap;
    property NumDirections;
    property ShowCenter;
    property DirectionBitmap;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation


const
  DToR = Pi / 180;

constructor TOvcCustomDirectionPicker.Create(AComponent : TComponent);
begin
  inherited Create(AComponent);

  ControlStyle := [csClickEvents, csDoubleClicks];

  Width  := 50;
  Height := 50;

  FDirection := -1;
  FNumDirections := 8;
  FShowCenter := True;

  {create and load the bitmap images}
  {resource are in ovcreg.rc}
  FDirectionBitmap := TBitmap.Create;
  FDirectionBitmap.Handle := LoadBitmap(HInstance, 'ORBLUEDOT');
  FSelectedBitmap := TBitmap.Create;
  FSelectedBitmap.Handle := LoadBitmap(HInstance, 'ORREDDOT');
end;

destructor TOvcCustomDirectionPicker.Destroy;
begin
  {destroy bitmaps}
  FDirectionBitmap.Free;
  FDirectionBitmap := nil;
  FSelectedBitmap.Free;
  FSelectedBitmap := nil;

  inherited Destroy;
end;

procedure TOvcCustomDirectionPicker.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  I             : Integer;
  BW            : Integer;
  Angle         : Extended;
  Diameter      : Integer;
  Radius        : Integer;
  X1, Y1        : Integer;
  Distance      : Integer;
  BestDirection : Integer;
  BestDistance  : Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and Enabled then begin
    BW := MaxI(FDirectionBitmap.Width, FDirectionBitmap.Height);
    Diameter := MinI(Height, Width)-2*BW;
    Radius := Diameter div 2;

    if FShowCenter then begin
      {initialize at center (-1)}
      BestDistance := Round(Sqrt(Sqr(Radius+BW-X) + Sqr(Radius+BW-Y)));
      BestDirection := -1;
    end else begin
      BestDistance := Width*2;
      BestDirection := FDirection;
    end;

    for I := 0 to Pred(FNumDirections) do begin
      Angle := (I * (360/FNumDirections) + 90) * DToR;
      X1 := Round(Radius * (1-Cos(Angle))) + BW;
      Y1 := Round(Radius * (1-Sin(Angle))) + BW;
      Distance := Round(Sqrt(Sqr(X1-X) + Sqr(Y1-Y)));
      if Distance < BestDistance then begin
        BestDistance := Distance;
        BestDirection := I;
      end;
    end;

    Direction := BestDirection;
  end;
end;

procedure TOvcCustomDirectionPicker.Paint;
var
  I        : Integer;
  BW       : Integer;
  BW2      : Integer;
  Angle    : Extended;
  Diameter : Integer;
  Radius   : Integer;
  X, Y     : Integer;
begin
  BW := MaxI(FDirectionBitmap.Width, FDirectionBitmap.Height);
  Diameter := MinI(Height, Width)-2*BW;
  Radius := Diameter div 2;

  if FShowCenter then
    Canvas.Draw(Radius+BW, Radius+BW, FDirectionBitmap);
  for I := 0 to Pred(FNumDirections) do begin
    Angle := (I * (360/FNumDirections) + 90) * DToR;
    X := Round(Radius * (1-Cos(Angle)));
    Y := Round(Radius * (1-Sin(Angle)));
    Canvas.Draw(X+BW, Y+BW, FDirectionBitmap);
  end;

  {draw the dot for the selected direction}
  BW2 := (MaxI(FSelectedBitmap.Width, FSelectedBitmap.Height)-BW) div 2;  {adjustment for larger bitmap}
  if FDirection = -1 then begin
    if FShowCenter then
      Canvas.Draw(Radius+BW-BW2, Radius+BW-BW2, FSelectedBitmap)
  end else begin
    Angle := (FDirection * (360/FNumDirections) + 90) * DToR;
    X := Round(Radius * (1-Cos(Angle)));
    Y := Round(Radius * (1-Sin(Angle)));
    Canvas.Draw(X+BW-BW2, Y+BW-BW2, FSelectedBitmap);
  end;
end;

procedure TOvcCustomDirectionPicker.SetDirection(Value : Integer);
begin
  if csLoading in ComponentState then begin
    FDirection := Value;
    Exit;
  end;

  if (Value <> FDirection) and (Value >= -1) and (Value < FNumDirections) then begin
    FDirection := Value;
    Invalidate;
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
end;

procedure TOvcCustomDirectionPicker.SetSelectedBitmap(Value : TBitmap);
begin
  if Assigned(Value) then
    FSelectedBitmap.Assign(Value)
  else
    FSelectedBitmap.ReleaseHandle;
  Invalidate;
end;

procedure TOvcCustomDirectionPicker.SetNumDirections(Value : Integer);
begin
  if (Value <> FNumDirections) and (Value >= 2) then begin
    FNumDirections := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomDirectionPicker.SetShowCenter(Value : Boolean);
begin
  if Value <> FShowCenter then begin
    FShowCenter := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomDirectionPicker.SetDirectionBitmap(Value : TBitmap);
begin
  if Assigned(Value) then
    FDirectionBitmap.Assign(Value)
  else
    FDirectionBitmap.ReleaseHandle;
  Invalidate;
end;


initialization
  if Classes.GetClass(TOvcDirectionPicker.ClassName) = nil then
    Classes.RegisterClass(TOvcDirectionPicker);
end.

{*********************************************************}
{*                   O32BORDR.PAS 4.06                   *}
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

unit o32bordr;
  {New Style Border control for Orpheus 4 components.}

interface

uses
  Windows, Classes, Controls, Graphics;

type
  TO32BorderStyle = (bstyNone, bstyRaised, bstyLowered, bstyFlat, bstyChannel,
                     bstyRidge);

const
  THiliteColor: array[TO32BorderStyle] of TColor = (clWindow, clBtnHighlight,
    clBtnShadow, clWindowFrame, clBtnShadow, clBtnHighlight);

  TBaseColor: array[TO32BorderStyle] of TColor = (clWindow, clBtnShadow,
    clBtnHighlight, clWindowFrame, clBtnHighlight, clBtnShadow);

type
  TO32BorderSide  = (bsidLeft, bsidRight, bsidTop, bsidBottom);

  TSides = (left, right, top, bottom);

  TO32Borders = class;

  TO32BorderSet = class(TPersistent)
  protected {private}
    FOwner       : TPersistent;
    FLeft        : Boolean;
    FTop         : Boolean;
    FRight       : Boolean;
    FBottom      : Boolean;
    procedure SetLeft(Value: Boolean);
    procedure SetRight(Value: Boolean);
    procedure SetBottom(Value: Boolean);
    procedure SetTop(Value: Boolean);
  public
    constructor Create(AOwner: TPersistent);
  published
    property ShowLeft    : Boolean  read FLeft    write SetLeft
      default True;
    property ShowRight   : Boolean  read FRight   write SetRight
      default True;
    property ShowTop     : Boolean  read FTop     write SetTop
      default True;
    property ShowBottom  : Boolean  read FBottom  write SetBottom
      default True;
  end;

  TO32Borders = class(TPersistent)
  protected {private}
    Creating      : Boolean;
    FControl      : TWinControl;
    FBorderSet    : TO32BorderSet;
    FActive       : Boolean;
    FFlatColor    : TColor;
    FBorderWidth  : Integer;
    FBorderStyle  : TO32BorderStyle;
    procedure SetActive       (Value : Boolean);
    procedure SetBorderStyle  (Value : TO32BorderStyle);
    procedure SetFlatColor    (Value : TColor);

    procedure Draw3dBox(Canvas: TCanvas; Rct: TRect; Hilite,
     Base: TColor; DrawAllSides: Boolean);
    procedure DrawFlatBorder(Canvas: TControlCanvas; Rct: TRect;
      Color: TColor{; DrawAllSides: Boolean}); {!!!}
    procedure DrawBevel(Canvas: TControlCanvas; Rct: TRect; HiliteColor,
      BaseColor: TColor);
    procedure Draw3dBorders(Canvas: TControlCanvas; Rct: TRect);
    procedure EraseBorder(Canvas: TControlCanvas; Rct: TRect;
      Color: TColor; AllSides: Boolean);
    procedure DrawSingleSolidBorder(Canvas: TControlCanvas; Rct: TRect;
      Color: TColor; Side: TSides; Width: Integer);
  public
    constructor Create(Control: TWinControl);
    destructor  Destroy; override;
    procedure Changed;
    procedure BordersChanged;
    property  Control: TWinControl read FControl;
    procedure DrawBorders(var Canvas: TControlCanvas; Color: TColor);
    procedure RedrawControl;
  published
    property Active      : Boolean    read FActive       write SetActive
      default False;
    property BorderSet   : TO32BorderSet
                                      read FBorderSet   write FBorderSet;
    property BorderStyle: TO32BorderStyle read FBorderStyle write SetBorderStyle
      default bstyRidge;
    property FlatColor: TColor read FFlatColor write SetFlatColor
      default clLime;
  end;

implementation

{===== TO32BorderSet =================================================}
constructor TO32BorderSet.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
end;
{=====}

procedure TO32BorderSet.SetLeft(Value: Boolean);
begin
  if Value <> FLeft then begin
    FLeft := Value;
    TO32Borders(FOwner).BordersChanged;
  end;
end;
{=====}

procedure TO32BorderSet.SetRight(Value: Boolean);
begin
  if Value <> FRight then begin
    FRight := Value;
    TO32Borders(FOwner).BordersChanged;
  end;
end;
{=====}

procedure TO32BorderSet.SetBottom(Value: Boolean);
begin
  if Value <> FBottom then begin
    FBottom := Value;
    TO32Borders(FOwner).BordersChanged;
  end;
end;
{=====}

procedure TO32BorderSet.SetTop(Value: Boolean);
begin
  if Value <> FTop then begin
    FTop := Value;
    TO32Borders(FOwner).BordersChanged;
  end;
end;

{===== TO32BorderSet - End =====}


{===== TO32Borders =================================================}
constructor TO32Borders.Create(Control: TWinControl);
begin
  Creating := True;
  inherited Create;
  FControl := Control;
  FBorderSet := TO32BorderSet.Create(self);
  FActive := false;
  FBorderWidth := 2;
  FBorderStyle := bstyRidge;
  FFlatColor := clLime;
  FBorderSet.ShowBottom := true;
  FBorderSet.ShowLeft := true;
  FBorderSet.ShowRight := true;
  FBorderSet.ShowTop := true;
  Creating := False;
end;
{=====}

destructor  TO32Borders.Destroy;
begin
  FBorderSet.Free;
  inherited Destroy;
end;
{=====}

procedure TO32Borders.SetActive(Value: Boolean);
begin
  if FActive <> Value then begin
    FActive := Value;
    Changed;
  end;
end;
{=====}

procedure TO32Borders.SetBorderStyle(Value: TO32BorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    Changed;
  end;
end;
{=====}

procedure TO32Borders.SetFlatColor(Value: TColor);
begin
  if Value <> FFlatColor then begin
    FFlatColor := Value;
    if FBorderStyle = bstyFlat then
      Changed;
  end;
end;
{=====}

procedure TO32Borders.DrawBorders(var Canvas: TControlCanvas; Color: TColor);
var
  Rct     : TRect;
begin
  if not FActive then exit;

  Rct := Rect(0, 0, FControl.Width, FControl.Height);

  {Erase the existing border.}
  EraseBorder(Canvas, Rct, Color, true);

  {If the border style is bstyNone then don't do anything else.}
  if FBorderStyle = bstyNone then exit;

  {otherwise, draw the border.}
  if FBorderStyle = bstyFlat then
    DrawFlatBorder(Canvas, Rct, FFlatColor{, false})
  else Draw3dBorders(Canvas, Rct);
end;
{=====}

procedure TO32Borders.Draw3dBorders(Canvas: TControlCanvas; Rct: TRect);
var
  Hilite, Base: TColor;
  R: TRect;
begin
  Hilite := THiliteColor[FBorderStyle];
  Base   := TBaseColor[FBorderStyle];

  if FBorderStyle in [bstyLowered, bstyRaised ] then
    DrawBevel(Canvas, Rct, Hilite, Base)

  else with FBorderSet do begin
    R := Rct;
    {Patch the border edges}

    if ShowRight then
      Canvas.Pixels[R.Right - 1, R.Top] := Base;
    if ShowTop and not ShowRight then
      Canvas.Pixels[R.Right - 1, R.Top] := Hilite;
    if ShowBottom then
      Canvas.Pixels[R.Left, R.Bottom - 1] := Base;
    if ShowLeft and not ShowBottom then
      Canvas.Pixels[R.Left, R.Bottom - 1] := Hilite;
    if ShowTop and not ShowLeft then
      Canvas.Pixels[R.Left, R.Top + 1] := Base;
    if not ShowTop and ShowLeft then
      Canvas.Pixels[R.Left + 1, R.Top] := Base;
    if ShowBottom and not ShowRight then
      Canvas.Pixels[R.Right - 1, R.Bottom - 2] := Hilite;
    if not ShowBottom and ShowRight then
      Canvas.Pixels[R.Right - 2, R.Bottom - 1] := Hilite;

    Inc( R.Left );
    Inc( R.Top );
    Draw3dBox(Canvas, R, Base, Base, false);
    OffsetRect(R, -1, -1);
    Draw3dBox(Canvas, R, Hilite, Hilite, false);

{ - dead code}
//    if ShowLeft   then Inc(Rct.Left,   2);
//    if ShowTop    then Inc(Rct.Top,    2);
//    if ShowRight  then Dec(Rct.Right,  2);
//    if ShowBottom then Dec(Rct.Bottom, 2);
  end;
end;
{=====}

procedure TO32Borders.DrawSingleSolidBorder(Canvas: TControlCanvas; Rct: TRect;
  Color: TColor; Side: TSides; Width: Integer);
var
  i: Integer;
begin
  with Canvas, FBorderSet do begin
    Pen.Width := 1;
    Pen.Color := Color;

    if Side = left then
      for i := 0 to Width do begin
        MoveTo(Rct.Left - 1, Rct.Top);
        LineTo(Rct.Left - 1, Rct.Bottom);
        Inc(Rct.Left);
      end
    else if Side = right then
      for i := 0 to Width do begin
        MoveTo(Rct.Right , Rct.Top);
        LineTo(Rct.Right , Rct.Bottom);
        Dec(Rct.Right);
      end
    else if Side = top then
      for i := 0 to Width do begin
        MoveTo(Rct.Left, Rct.Top - 1);
        LineTo(Rct.Right, Rct.Top - 1);
        Inc(Rct.Top);
      end
    else if Side = bottom then
      for i := 0 to Width do begin
        MoveTo(Rct.Left, Rct.Bottom);
        LineTo(Rct.Right, Rct.Bottom);
        Dec(Rct.Bottom);
      end;
  end;
end;
{=====}

procedure TO32Borders.Draw3dBox(Canvas: TCanvas; Rct: TRect; Hilite,
  Base: TColor; DrawAllSides: Boolean);
begin
  with Canvas, Rct, FBorderSet do begin
    Pen.Width := 1;
    Pen.Color := Hilite;
    if ShowLeft or DrawAllSides then begin
      MoveTo( Left, Top );
      LineTo( Left, Bottom );
    end;

    if ShowTop or DrawAllSides then begin
      MoveTo( Left, Top );
      LineTo( Right, Top );
    end;

    Pen.Color := Base;
    if ShowRight or DrawAllSides then begin
      MoveTo( Right - 1, Top );
      LineTo( Right - 1, Bottom );
    end;

    if ShowBottom or DrawAllSides then begin
      MoveTo( Left, Bottom - 1 );
      LineTo( Right, Bottom - 1 );
    end;
  end;
end;
{=====}

procedure TO32Borders.DrawBevel(Canvas: TControlCanvas; Rct: TRect; HiliteColor,
  BaseColor: TColor);
var
  I: Integer;
begin
  Canvas.Pen.Width := 1;
  for I := 1 to FBorderWidth do
  begin
    Draw3dBox(Canvas, Rct, HiliteColor, BaseColor, False);
    Inc(Rct.Left);
    Inc(Rct.Top);
    Dec(Rct.Right);
    Dec(Rct.Bottom);
  end;
end;
{=====}

procedure TO32Borders.DrawFlatBorder(Canvas: TControlCanvas; Rct: TRect;
  Color: TColor{; DrawAllSides: Boolean});
begin
  Canvas.Pen.Color := Color;
  with BorderSet do begin
    if ShowLeft then
      DrawSingleSolidBorder(Canvas, Rct, Color, left, FBorderWidth);
    if ShowRight then
      DrawSingleSolidBorder(Canvas, Rct, Color, right, FBorderWidth);
    if ShowTop then
      DrawSingleSolidBorder(Canvas, Rct, Color, top, FBorderWidth);
    if ShowBottom then
      DrawSingleSolidBorder(Canvas, Rct, Color, bottom, FBorderWidth);
  end;
end;
{=====}

procedure TO32Borders.EraseBorder(Canvas: TControlCanvas; Rct: TRect;
  Color: TColor; AllSides: Boolean);
var
  i: Integer;
begin
  Canvas.Pen.Color := Color;
  with BorderSet do begin
    for i := 1 to FBorderWidth do begin
      Draw3dBox(Canvas, Rct, Color, Color, AllSides);
      Inc(Rct.Left);
      Inc(Rct.Top);
      Dec(Rct.Right);
      Dec(Rct.Bottom);
    end;
  end;
end;
{=====}

procedure TO32Borders.BordersChanged;
begin
  if FActive then Changed;
end;
{=====}

procedure TO32Borders.RedrawControl;
var
  Rct: TRect;
begin
  if not Creating then begin
    Rct := FControl.ClientRect;
    RedrawWindow(FControl.Handle, @Rct, 0,
      rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
  end;
end;
{=====}

procedure TO32Borders.Changed;
begin
  FControl.Invalidate;
  RedrawControl;
end;

{===== TO32Borders - End =====}

end.




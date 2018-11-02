{*********************************************************}
{*                   OVCDRAG.PAS 4.06                    *}
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

unit ovcdrag;

interface

uses
  Windows, Classes, Graphics;

type
  TOvcDragShow = class(TObject)
  

  protected
    dStretchBltMode   : Integer;
    dMemDC,dSMemDC,
    dDstDC,dSaveDC    : hDC;
    dSaveBmp, dMemBmp,
    dSMemBmp          : hBITMAP;
    dcrText, dcrBack  : TColorRef;
    dRect             : TRect;
    dSize             : TPoint;
    dSystemPalette16  : hPalette;
    dOldPal           : hPalette;
    Bitmap,dMask      : TBitmap;
    DeltaX, DeltaY    : Integer;
    dDragging,
    dHaveOriginal     : Boolean;

    procedure ilDragDraw;
    procedure ilRestoreOriginal;
    procedure ilSaveOriginal;

  public
    constructor Create(X, Y : Integer; SourceRect : TRect; TransColor : TColor);
    destructor Destroy;
      override;
    procedure DragMove(X, Y : Integer);
    procedure HideDragImage;
    procedure ShowDragImage;
  

  end;


implementation


{*** TOvcDragShow ***}

constructor TOvcDragShow.Create(X, Y : Integer; SourceRect : TRect; TransColor : TColor);
var
  dMaskDC : HDC;
  SrcDC : HDC;
begin
  dHaveOriginal := False;
  dDstDC := GetDC(0);
  DeltaX := X - SourceRect.Left;
  DeltaY := Y - SourceRect.Top;
  dec(X, DeltaX);
  dec(Y, DeltaY);
  dRect.Left := X;
  dRect.Top := Y;
  Bitmap := nil;
  dMask := nil;
  try
    Bitmap := TBitmap.Create;
    Bitmap.Width := SourceRect.Right - SourceRect.Left + 1;
    Bitmap.Height := SourceRect.Bottom - SourceRect.Top + 1;

    dMask := TBitmap.Create;
    dMask.Width := SourceRect.Right - SourceRect.Left + 1;
    dMask.Height := SourceRect.Bottom - SourceRect.Top + 1;

    BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, dDstDC, SourceRect.Left,
      SourceRect.Top, SRCCOPY);
    dMask.Canvas.BrushCopy(Rect(0, 0, dMask.Width - 1, dMask.Height - 1), Bitmap,
      Rect(0, 0, dMask.Width - 1, dMask.Height - 1), TransColor);

    dMemDC := CreateCompatibleDC(0);
    dSaveDC := CreateCompatibleDC(0);
    dDragging := True;
    dStretchBltMode := SetStretchBltMode(dDstDC, BLACKONWHITE);
    dSize.X := Bitmap.Width;
    dSize.Y := Bitmap.Height;
    dRect.Right := dRect.Left + dSize.X - 1;
    dRect.Bottom := dRect.Top + dSize.Y - 1;
    SrcDC := Bitmap.Canvas.Handle;
    dMaskDC := dMask.Canvas.Handle;
    dSMemDC := CreateCompatibleDC(dMaskDC);
    dMemBmp := CreateCompatibleBitmap(SrcDC, dSize.X, dSize.Y);
    SelectObject(dMemDC, dMemBmp);
    dSMemBmp := CreateCompatibleBitmap(dMaskDC, dSize.X, dSize.Y);
    SelectObject(dSMemDC, dSMemBmp);
    dSaveBmp := CreateCompatibleBitmap(SrcDC, dSize.X, dSize.Y);
    SelectObject(dSaveDC, dSaveBmp);
    dSystemPalette16 := GetStockObject(DEFAULT_PALETTE);
    dOldPal := SelectPalette(SrcDC, dSystemPalette16, False);
    SelectPalette(SrcDC, dOldPal, False);
    if dOldPal <> 0 then begin
      SelectPalette(dMemDC, dOldPal, True);
      SelectPalette(dSaveDC, dOldPal, True);
    end else begin
      SelectPalette(dMemDC, dSystemPalette16, True);
      SelectPalette(dSaveDC, dSystemPalette16, True);
    end;
    RealizePalette(dMemDC);
    RealizePalette(dSaveDC);

    BitBlt(dSMemDC, 0, 0, dSize.X, dSize.Y, dMaskDC, 0, 0, SrcCopy);
    BitBlt(dMemDC, 0, 0, dSize.X, dSize.Y, dMaskDC, 0, 0, SrcCopy);
    BitBlt(dMemDC, 0, 0, dSize.X, dSize.Y, SrcDC, 0, 0, SrcErase);
    dcrText := SetTextColor(dDstDC, $0);
    dcrBack := SetBkColor(dDstDC, $FFFFFF);
    ilSaveOriginal;
    ilDragDraw;
  except
    Bitmap.Free;
    dMask.Free;
    raise;
  end;
end;

destructor TOvcDragShow.Destroy;
begin
  ilRestoreOriginal;
  SetTextColor(dDstDC, dcrText);
  SetBkColor(dDstDC, dcrBack);
  DeleteObject(dMemBmp);
  DeleteObject(dSaveBmp);
  DeleteObject(dSMemBmp);
  DeleteDC(dMemDC);
  DeleteDC(dSMemDC);
  DeleteDC(dSaveDC);
  SetStretchBltMode(dDstDC, dStretchBltMode);
  ReleaseDC(0,dDstDC);
  dDragging := False;
  Bitmap.Free;
  dMask.Free;
  inherited Destroy;
end;

procedure TOvcDragShow.DragMove(X, Y: Integer);
var
  NewRect, Union : TRect;
  UnionSize : TPoint;
  WorkDC : hDC;
  WorkBM : hBitmap;
begin
  if not dDragging then exit;
  dec(X, DeltaX);
  dec(Y, DeltaY);
  {if we didn't move, get out}
  if (X = dRect.Left) and (Y = dRect.Top) then exit;
  {let's see where we're going}
  NewRect := Rect(X, Y, X + dSize.X - 1, Y + dSize.Y - 1);
  {if drag image not currently shown, just update next draw position and exit}
  if not dHaveOriginal then begin
    dRect := NewRect;
    exit;
  end;
  {do the old and new positions overlap?}
  if ord(IntersectRect(Union, dRect, NewRect)) <> 0 then begin
    {rect old and new combined:}
    UnionRect(Union, NewRect, dRect);
    {size of union:}
    UnionSize.X := Union.Right - Union.Left + 1;
    UnionSize.Y := Union.Bottom - Union.Top + 1;
    {create combination buffer}
    WorkDC := CreateCompatibleDC(0);
    WorkBM := CreateCompatibleBitmap(dDstDC, UnionSize.X, UnionSize.Y);
    SelectObject(WorkDC, WorkBM);
    if dOldPal <> 0 then
      SelectPalette(WorkDC, dOldPal, True)
    else
      SelectPalette(WorkDC, dSystemPalette16, True);
    RealizePalette(WorkDC);
    {copy screen section (including old image) to local buffer}
    BitBlt(WorkDC, 0, 0, UnionSize.X, UnionSize.Y, dDstDC, Union.Left, Union.Top, SRCCOPY);
    {"repair" by restoring background for old image}
    BitBlt(WorkDC, dRect.Left - Union.Left, dRect.Top - Union.Top,
       dSize.X, dSize.Y, dSaveDC, 0, 0, SRCCOPY);
    {save background so we can do the same next time}
    BitBlt(dSaveDC, 0, 0, dSize.X, dSize.Y, WorkDC, NewRect.Left - Union.Left, NewRect.Top - Union.Top, SrcCopy);
    {write image at new position into local buffer}
    BitBlt(WorkDC, NewRect.Left - Union.Left, NewRect.Top - Union.Top, dSize.X, dSize.Y, dSMemDC, 0, 0, SrcAnd);
    BitBlt(WorkDC, NewRect.Left - Union.Left, NewRect.Top - Union.Top, dSize.X, dSize.Y, dMemDC, 0, 0, SrcInvert);
    {copy combined image to screen}
    BitBlt(dDstDC, Union.Left, Union.Top, UnionSize.X, UnionSize.Y, WorkDC, 0, 0, SRCCOPY);
    dRect := NewRect;
    DeleteDC(WorkDC);
    DeleteObject(WorkBM);
  end else begin
    {images dont overlap, so we might as well do the draw in two steps}
    ilRestoreOriginal;
    dRect := NewRect;
    ilSaveOriginal;
    ilDragDraw;
  end;
end;

procedure TOvcDragShow.HideDragImage;
begin
  ilRestoreOriginal;
end;

procedure TOvcDragShow.ilDragDraw;
begin
  BitBlt(dDstDC, dRect.Left, dRect.Top, dSize.X, dSize.Y, dSMemDC, 0, 0, SrcAnd);
  BitBlt(dDstDC, dRect.Left, dRect.Top, dSize.X, dSize.Y, dMemDC, 0, 0, SrcInvert);
end;

procedure TOvcDragShow.ilRestoreOriginal;
begin
  if not dHaveOriginal then exit;
  BitBlt(dDstDC, dRect.Left, dRect.Top, dSize.X, dSize.Y, dSaveDC, 0, 0, SrcCopy);
  dHaveOriginal := False;
end;

procedure TOvcDragShow.ilSaveOriginal;
begin
  BitBlt(dSaveDC, 0, 0, dSize.X, dSize.Y, dDstDC, dRect.Left, dRect.Top, SrcCopy);
  dHaveOriginal := True;
end;

procedure TOvcDragShow.ShowDragImage;
begin
  ilSaveOriginal;
  ilDragDraw;
end;


end.

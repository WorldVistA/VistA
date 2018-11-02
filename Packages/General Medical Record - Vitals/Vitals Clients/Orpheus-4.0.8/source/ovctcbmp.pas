{*********************************************************}
{*                  OVCTCBMP.PAS 4.06                   *}
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

unit ovctcbmp;
  {-Orpheus Table Cell - Bitmap type}

interface

uses
  Windows, SysUtils, Graphics, Classes, OvcTCmmn, OvcTCell, OvcMisc;

type
  TOvcTCBaseBitMap = class(TOvcBaseTableCell)
    protected

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;

    public
      function  EditHandle : THandle; override;
      procedure EditHide; override;
      procedure EditMove(CellRect : TRect); override;
      procedure SaveEditedData(Data : pointer); override;
      procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                             CellRect : TRect;
                       const CellAttr : TOvcCellAttributes;
                             CellStyle: TOvcTblEditorStyle;
                             Data : pointer); override;
      procedure StopEditing(SaveValue : boolean;
                            Data : pointer); override;
  end;

  TOvcTCCustomBitMap = class(TOvcTCBaseBitMap)
    protected

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;

    public

      procedure ResolveAttributes(RowNum : TRowNum; ColNum : TColNum;
                                  var CellAttr : TOvcCellAttributes); override;

  end;

  TOvcTCBitMap = class(TOvcTCCustomBitMap)
    published
      {properties inherited from custom ancestor}
      property AcceptActivationClick default False;
      property Access default otxDefault;
      property Adjust default otaDefault;
      property Color;
      property Margin default 4;
      property Table;
      property TableColor default True;

      property OnOwnerDraw;
  end;


implementation


{===TOvcTCBaseBitMap=================================================}
procedure TOvcTCBaseBitMap.tcPaint(TableCanvas : TCanvas;
                             const CellRect    : TRect;
                                   RowNum      : TRowNum;
                                   ColNum      : TColNum;
                             const CellAttr    : TOvcCellAttributes;
                                   Data        : pointer);
  type
    LH = packed record cX, cY : word; end;
  var
    BMInfo            : PCellBitMapInfo absolute Data;
    Wd, Ht            : integer;
    DisplayWd         : integer;
    DisplayHt         : integer;
    CellWidth         : integer;
    CellHeight        : integer;
    SrcRect, DestRect : TRect;
    TransparentColor  : TColor;
    CellAdj           : TOvcTblAdjust;
  begin
    {blank out the cell (also sets the brush color)}
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
    {if there's no data, the index to the sub-bitmap is zero or
     the cell is invisible anyway, just exit}
    if (Data = nil) or
       (BMInfo^.Index = -1) or
       (CellAttr.caAccess = otxInvisible) then
      Exit;
    {make a note of the adjustment, and calc the cell width and height}
    CellAdj := CellAttr.caAdjust;
    CellWidth := CellRect.Right - CellRect.Left;
    CellHeight := CellRect.Bottom - CellRect.Top;
    {calculate data about the bitmap, including the source rectangle}
    with BMInfo^ do
      begin
        Wd := BM.Width;
        if (Count <= 1) then
          Index := 0
        else
          begin
            Wd := Wd div Count;
            if (Index >= Count) then
              Index := 0;
          end;
        Ht := BM.Height;
        DisplayWd := MinI(Wd, (CellWidth - 2*Margin));
        DisplayHt := MinI(Ht, (CellHeight - 2*Margin));
        with SrcRect do
          begin
            Left := Index * Wd;
            Right := Left + DisplayWd;
            Top := 0;
            Bottom := Top + DisplayHt;
          end;
        TransparentColor := BM.Canvas.Pixels[SrcRect.Left, Ht-1]
      end;
    {calculate the destination rectangle}
    with DestRect do
      begin
        case CellAdj of
          otaTopLeft, otaCenterLeft, otaBottomLeft :
             Left := Margin;
          otaTopRight, otaCenterRight, otaBottomRight :
             Left := (CellWidth - DisplayWd - Margin);
        else
          Left := (CellWidth - DisplayWd) div 2;
        end;{case}
        inc(Left, CellRect.Left);
        case CellAdj of
          otaTopLeft, otaTopCenter, otaTopRight :
             Top := Margin;
          otaBottomLeft, otaBottomCenter, otaBottomRight :
             Top := (CellHeight - DisplayHt - Margin);
        else
          Top := (CellHeight - DisplayHt) div 2;
        end;{case}
        inc(Top, CellRect.Top);
        Right := Left + DisplayWd;
        Bottom := Top + DisplayHt;
      end;
    {brush copy the bitmap onto the table}
    TableCanvas.BrushCopy(DestRect, BMInfo^.BM, SrcRect, TransparentColor);
  end;

function  TOvcTCBaseBitMap.EditHandle : THandle;
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
  Result := 0;
end;

procedure TOvcTCBaseBitMap.EditHide;
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;

procedure TOvcTCBaseBitMap.EditMove(CellRect : TRect);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;

procedure TOvcTCBaseBitMap.SaveEditedData(Data : pointer);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;

procedure TOvcTCBaseBitMap.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                        CellRect : TRect;
                  const CellAttr : TOvcCellAttributes;
                        CellStyle: TOvcTblEditorStyle;
                        Data : pointer);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;

procedure TOvcTCBaseBitMap.StopEditing(SaveValue : boolean;
                      Data : pointer);
begin
  {stub out abstract method so BCB doesn't see this as an abstract class}
end;


{====================================================================}

{===TOvcTCCustomBitMap===============================================}
procedure TOvcTCCustomBitMap.tcPaint(TableCanvas : TCanvas;
                               const CellRect    : TRect;
                                     RowNum      : TRowNum;
                                     ColNum      : TColNum;
                               const CellAttr    : TOvcCellAttributes;
                                     Data        : pointer);
  var
    BitMap : TBitmap absolute Data;
    BMInfo : TCellBitMapInfo;
  begin
    {if there's no bitmap, just let our ancestor deal with it}
    if (Data = nil) then
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, nil)
    {otherwise set up a bitmap info record, and let the ancestor paint it}
    else
      begin
        with BMInfo do
          begin
            BM := BitMap;
            Count := 1;
            ActiveCount := 1;
            Index := 0;
          end;
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @BMInfo);
      end;
  end;
{--------}
procedure TOvcTCCustomBitMap.ResolveAttributes(RowNum : TRowNum; ColNum : TColNum;
                                           var CellAttr : TOvcCellAttributes);
  begin
    inherited ResolveAttributes(RowNum, ColNum, CellAttr);
    case CellAttr.caAccess of
      otxDefault, otxNormal : CellAttr.caAccess := otxReadOnly;
    end;{case}
  end;
{====================================================================}


end.

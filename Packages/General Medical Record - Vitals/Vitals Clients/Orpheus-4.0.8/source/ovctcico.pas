{*********************************************************}
{*                  OVCTCICO.PAS 4.06                    *}
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

unit ovctcico;
  {-Orpheus Table Cell - Icon type}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, OvcTCmmn, OvcTCell;

type
  TOvcTCCustomIcon = class(TOvcBaseTableCell)
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

  TOvcTCIcon = class(TOvcTCCustomIcon)
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
procedure TOvcTCCustomIcon.tcPaint(TableCanvas : TCanvas;
                             const CellRect    : TRect;
                                   RowNum      : TRowNum;
                                   ColNum      : TColNum;
                             const CellAttr    : TOvcCellAttributes;
                                   Data        : pointer);
  var
    Icon              : TIcon absolute Data;
    Wd, Ht            : integer;
    CellWidth         : integer;
    CellHeight        : integer;
    Left, Top         : integer;
    CellAdj           : TOvcTblAdjust;
  begin
    {blank out the cell (also sets the brush color)}
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
    {nothing else to do if the data is nil or the cell in invisible}
    if (Data = nil) or
       (CellAttr.caAccess = otxInvisible) then
      Exit;
    {make a note of the adjustment, calc the cell width and height}
    CellAdj := CellAttr.caAdjust;
    CellWidth := CellRect.Right - CellRect.Left;
    CellHeight := CellRect.Bottom - CellRect.Top;
    {get the width/height of the icon}
    with Icon do
      begin
        Wd := Width;
        Ht := Height;
      end;
    {calculate the destination position}
    case CellAdj of
      otaTopLeft, otaCenterLeft, otaBottomLeft :
         Left := Margin;
      otaTopRight, otaCenterRight, otaBottomRight :
         Left := (CellWidth - Wd - Margin);
    else
      Left := (CellWidth - Wd) div 2;
    end;{case}
    inc(Left, CellRect.Left);
    case CellAdj of
      otaTopLeft, otaTopCenter, otaTopRight :
         Top := Margin;
      otaBottomLeft, otaBottomCenter, otaBottomRight :
         Top := (CellHeight - Ht - Margin);
    else
      Top := (CellHeight - Ht) div 2;
    end;{case}
    inc(Top, CellRect.Top);

    TableCanvas.Draw(Left, Top, Icon);
  end;
{--------}
procedure TOvcTCCustomIcon.ResolveAttributes(RowNum : TRowNum; ColNum : TColNum;
                                         var CellAttr : TOvcCellAttributes);
  begin
    inherited ResolveAttributes(RowNum, ColNum, CellAttr);
    case CellAttr.caAccess of
      otxDefault, otxNormal : CellAttr.caAccess := otxReadOnly;
    end;{case}
  end;
{====================================================================}


end.

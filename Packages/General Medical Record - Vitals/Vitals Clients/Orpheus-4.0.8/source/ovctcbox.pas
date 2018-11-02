{*********************************************************}
{*                  OVCTCBOX.PAS 4.08                    *}
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

unit ovctcbox;
  {-Orpheus Table Cell - Check box type}

interface

uses
  Windows, SysUtils, Graphics, Classes, Controls, StdCtrls,
  OvcTCmmn, OvcTCell, OvcTGRes, OvcTCGly, OvcMisc;

type
  TOvcTCCustomCheckBox = class(TOvcTCCustomGlyph)
    protected {private}

      FAllowGrayed : boolean;

      FatherValue : Integer;


    protected

      procedure SetAllowGrayed(AG : boolean);

      procedure GlyphsHaveChanged(Sender : TObject);
      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;


    public
      constructor Create(AOwner : TComponent); override;

      function  CanAssignGlyphs(CBG : TOvcCellGlyphs) : boolean; override;

      procedure SaveEditedData(Data : pointer); override;
      procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                             CellRect : TRect;
                       const CellAttr : TOvcCellAttributes;
                             CellStyle: TOvcTblEditorStyle;
                             Data : pointer); override;
      procedure StopEditing(SaveValue : boolean;
                            Data : pointer); override;

      property AllowGrayed : boolean
         read FAllowGrayed write SetAllowGrayed;

  end;

  TOvcTCCheckBox = class(TOvcTCCustomCheckBox)
    published
      {properties inherited from custom ancestor}
      property AcceptActivationClick default True;
      property Access default otxDefault;
      property Adjust default otaDefault;
      property AllowGrayed default False;
      property CellGlyphs;
      property Color;
      property Hint;
      property Margin default 4;
      property ShowHint default False;
      property Table;
      property TableColor default True;

      {events inherited from custom ancestor}
      property OnClick;
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
      property OnOwnerDraw;
  end;

implementation

uses
  Themes;

function ThemesEnabled: Boolean;// inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices;// inline;
begin
  Result := StyleServices;
end;

{===TOvcTCCustomCheckBox creation/destruction========================}
constructor TOvcTCCustomCheckBox.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    CellGlyphs.OnCfgChanged := nil;
    if (CellGlyphs.ActiveGlyphCount = 3) then
      CellGlyphs.ActiveGlyphCount := 2;
    CellGlyphs.OnCfgChanged := GlyphsHaveChanged;
    FAcceptActivationClick := true;
  end;
{--------}
procedure TOvcTCCustomCheckBox.SetAllowGrayed(AG : boolean);
  begin
    if AG <> FAllowGrayed then
      begin
        FAllowGrayed := AG;
        if AG then
          CellGlyphs.ActiveGlyphCount := 3
        else
          CellGlyphs.ActiveGlyphCount := 2;
        tcDoCfgChanged;
      end;
  end;
{--------}
function TOvcTCCustomCheckBox.CanAssignGlyphs(CBG : TOvcCellGlyphs) : boolean;
  begin
    Result := CBG.GlyphCount = 3;
  end;
{--------}
procedure TOvcTCCustomCheckBox.GlyphsHaveChanged(Sender : TObject);
  begin
    CellGlyphs.OnCfgChanged := nil;
    if FAllowGrayed then
      CellGlyphs.ActiveGlyphCount := 3
    else
      CellGlyphs.ActiveGlyphCount := 2;
    CellGlyphs.OnCfgChanged := GlyphsHaveChanged;
    tcDoCfgChanged;
  end;
{====================================================================}

{===TOvcTCCustomCheckBox painting====================================}
procedure TOvcTCCustomCheckBox.tcPaint(TableCanvas : TCanvas;
                                 const CellRect    : TRect;
                                       RowNum      : TRowNum;
                                       ColNum      : TColNum;
                                 const CellAttr    : TOvcCellAttributes;
                                       Data        : pointer);
  var
    B : ^TCheckBoxState absolute Data;
    Value : integer;
    Details: TThemedElementDetails;
    R: TRect;
    w, h, dw, dh: Integer;
  begin
    if (Data = nil) then
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, nil)
    else
      begin
        Value := ord(B^);
        if ThemesEnabled and CellGlyphs.IsDefault then begin
          inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, nil);
          w  := GetSystemMetrics(SM_CXMENUCHECK);
          h  := GetSystemMetrics(SM_CYMENUCHECK);
          dw := MaxI(0, CellRect.Right - CellRect.Left -  w - 2*Margin);
          dh := MaxI(0, CellRect.Bottom - CellRect.Top -  h - 2*Margin);
          R.Left := CellRect.Left + Margin;
          R.Top  := CellRect.Top + Margin;
          case Adjust of
            otaTopCenter:
              R.Left := R.Left + dw div 2;
            otaTopRight:
              R.Left := R.Left + dw;
            otaCenterLeft, otaDefault:
              R.Top := R.Top + dh div 2;
            otaCenter:
              begin R.Left := R.Left + dw div 2;  R.Top := R.Top + dh div 2; end;
            otaCenterRight:
              begin R.Left := R.Left + dw;  R.Top := R.Top + dh div 2; end;
            otaBottomLeft:
              R.Top := R.Top + dh;
            otaBottomCenter:
              begin R.Left := R.Left + dw div 2;  R.Top := R.Top + dh; end;
            otaBottomRight:
              begin R.Left := R.Left + dw;  R.Top := R.Top + dh; end;
          end;
          R.Right  := MinI(CellRect.Right, R.Left + w);
          R.Bottom := MinI(CellRect.Bottom, R.Top + h);
          with ThemeServices do begin
            case value of
              0:   Details := GetElementDetails(tbCheckBoxUncheckedNormal);
              1:   Details := GetElementDetails(tbCheckBoxCheckedNormal);
              else Details := GetElementDetails(tbCheckBoxMixedNormal);
            end;
            DrawElement(TableCanvas.Handle, Details, R);
{-Changes:
  10/2011, AB: There is an issue using user defined styles in Delphi XE2: Drawing the
               element seems to change the pen's parameters without the table noticing
               this. As a result, the gridlines for the next cells might not have width/
               color or style as defined in TOvcTable.GridPenSet. The following line
               is a workaround - there may be a better solution... }
            TableCanvas.Pen.Width := TableCanvas.Pen.Width + 1;
          end;
        end else
          inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @Value);
      end;
  end;
{====================================================================}


{===TOvcTCCheckBox editing===========================================}
procedure TOvcTCCustomCheckBox.SaveEditedData(Data : pointer);
  begin
    if Assigned(Data) then
      begin
        inherited SaveEditedData(@FatherValue);
        TCheckBoxState(Data^) := TCheckBoxState(FatherValue);
      end;
  end;
{--------}
procedure TOvcTCCustomCheckBox.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                            CellRect : TRect;
                                      const CellAttr : TOvcCellAttributes;
                                            CellStyle: TOvcTblEditorStyle;
                                            Data : pointer);
  begin
    if (Data = nil) then
      inherited StartEditing(RowNum, ColNum,
                             CellRect, CellAttr, CellStyle, nil)
    else
      begin
        FatherValue := Integer(TCheckBoxState(Data^));
        inherited StartEditing(RowNum, ColNum,
                               CellRect, CellAttr, CellStyle, @FatherValue);
      end;
  end;
{--------}
procedure TOvcTCCustomCheckBox.StopEditing(SaveValue : boolean;
                                           Data : pointer);
  begin
    inherited StopEditing(SaveValue, @FatherValue);
    if SaveValue and Assigned(Data) then
      TCheckBoxState(Data^) := TCheckBoxState(FatherValue);
  end;
{====================================================================}


end.

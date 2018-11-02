{*********************************************************}
{*                  OVCTCSTR.PAS 4.08                    *}
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

unit ovctcstr;
  {-Orpheus Table Cell - base string type}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, OvcTCmmn, OvcTCell;

type
  TEllipsisMode = (em_dont_show, em_show, em_show_readonly);

  TOvcTCBaseString = class(TOvcBaseTableCell)
    protected {private}

      FDataStringType   : TOvcTblStringtype;
      FUseWordWrap      : boolean;
      FShowEllipsis     : Boolean;
      FEllipsisReadonly : Boolean;
      FIgnoreCR         : Boolean;
      FOnChange         : TNotifyEvent;
  private
    { 07/2011, AUCOS-HKK: reimplemented property 'ASCIIZStrings' for backward-
        compatibility; better use 'DataStringType' to determine the kind of string the
        component uses. }
    function ReadASCIIZStrings: boolean;
    procedure SetUseASCIIZStrings(const Value: boolean);


    protected

      function GetEllipsisMode: TEllipsisMode;
      procedure SetEllipsisMode(EM:TEllipsisMode);
      procedure SetDataStringType(ADST : TOvcTblStringtype);
      procedure SetUseWordWrap(WW : boolean);

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;
      procedure tcPaintStrZ(TblCanvas : TCanvas;
                      const CellRect  : TRect;
                      const CellAttr  : TOvcCellAttributes;
                            StZ       : string); virtual;


      {properties}
      property DataStringType : TOvcTblStringtype
         read FDataStringType write SetDataStringType default tstString;
      { 07/2011, AUCOS-HKK: reimplemented property 'ASCIIZStrings' for backward compatibility }
      property UseASCIIZStrings : boolean
         read ReadASCIIZStrings write SetUseASCIIZStrings default True;

      property UseWordWrap : boolean
         read FUseWordWrap write SetUseWordWrap;

      { New property to access the new Field 'FEllipsisReadonly' together with 'FShowEllipsis'
        without changing 'ShowEllipsis' }
      property EllipsisMode: TEllipsisMode
         read GetEllipsisMode write SetEllipsisMode default em_show_readonly;

      property ShowEllipsis: Boolean read FShowEllipsis write FShowEllipsis;

      property IgnoreCR: Boolean read FIgnoreCR write FIgnoreCR default True;

      {events}
      property OnChange : TNotifyEvent
         read FOnChange write FOnChange;
    public
      constructor Create(AOwner : TComponent); override;
  end;


implementation


{===TOvcTCBaseString==========================================}
constructor TOvcTCBaseString.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FShowEllipsis := True;
  FEllipsisReadonly := True;
  FDataStringType := tstString;
  FIgnoreCR := True;
end;

procedure TOvcTCBaseString.tcPaint(TableCanvas : TCanvas;
                             const CellRect    : TRect;
                                   RowNum      : TRowNum;
                                   ColNum      : TColNum;
                             const CellAttr    : TOvcCellAttributes;
                                   Data        : pointer);
  {-Changes
    04/2011 AB: replaced UsePString by FDataStringType }
  var
    sBuffer: string;
  begin
    {blank out the cell}
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
    {if the cell is invisible or the passed data is nil and we're not
     designing, all's done}
    if (CellAttr.caAccess = otxInvisible) or
       ((Data = nil) and not (csDesigning in ComponentState)) then
      Exit;

    if Data = nil then
      sBuffer := Format('%d:%d', [RowNum, ColNum])
    else
      case FDataStringType of
        tstShortString: sBuffer := string(POvcShortString(Data)^);
        tstPChar:       sBuffer := string(PChar(Data));
        tstString:      sBuffer := PString(Data)^;
      end;

    tcPaintStrZ(TableCanvas, cellRect, CellAttr, sBuffer);
  end;

{--------}
procedure TOvcTCBaseString.tcPaintStrZ(TblCanvas : TCanvas;
                               const CellRect  : TRect;
                               const CellAttr  : TOvcCellAttributes;
                                     StZ       : string);
  {-Changes
    06/2011 AB: Added FEllipsisReadonly and FIgnoreCR:
                FIgnoreCR only has an effect when FUseWordWrap is false; in this case:
                True ->  The text is displayed in a single line i.e. any #13-characters in
                         StZ are ignore (this is the old behavior)
                False -> If there are #13-characters in StZ, the text is displayed in multiple
                         lines. }
  var
    Size   : TSize;
    Wd     : integer;
    LenStZ : integer;
    DTOpts : Cardinal;
    R      : TRect;
    OurAdjust : TOvcTblAdjust;
  begin
    TblCanvas.Font := CellAttr.caFont;
    TblCanvas.Font.Color := CellAttr.caFontColor;

    LenStZ := Length(StZ);

    R := CellRect;
    InflateRect(R, -Margin div 2, -Margin div 2);

    if FUseWordWrap then
      begin
        DTOpts:= DT_NOPREFIX or DT_WORDBREAK;
        case CellAttr.caAdjust of
          otaTopLeft, otaCenterLeft, otaBottomLeft    :
             DTOpts := DTOpts or DT_LEFT;
          otaTopRight, otaCenterRight, otaBottomRight :
             DTOpts := DTOpts or DT_RIGHT;
        else
          DTOpts := DTOpts or DT_CENTER;
        end;{case}
      end
    else
      begin
        DTOpts := DT_NOPREFIX;
        { remark: if the new option FIgnoreCR=False is used, DT_BOTTOM and DT_VCENTER will
                  have no effect; if there should be any need for these options some code
                  needs to be added to align the text manually (e.g using DT_CALCRECT) }
        if FIgnoreCR then DTOpts := DTOpts or DT_SINGLELINE;

        {make sure that if the string doesn't fit, we at least see
         the first few characters}
        GetTextExtentPoint32(TblCanvas.Handle, PChar(StZ), LenStZ, Size);
        Wd := Size.cX;
        OurAdjust := CellAttr.caAdjust;
        if Wd > (R.Right - R.Left) then
          case CellAttr.caAdjust of
            otaTopCenter, otaTopRight : OurAdjust := otaTopLeft;
            otaCenter, otaCenterRight : OurAdjust := otaCenterLeft;
            otaBottomCenter, otaBottomRight : OurAdjust := otaBottomLeft;
          end;

        case OurAdjust of
          otaTopLeft, otaCenterLeft, otaBottomLeft    :
             DTOpts := DTOpts or DT_LEFT;
          otaTopRight, otaCenterRight, otaBottomRight :
             DTOpts := DTOpts or DT_RIGHT;
        else
          DTOpts := DTOpts or DT_CENTER;
        end;{case}
        case OurAdjust of
          otaTopLeft, otaTopCenter, otaTopRight :
             DTOpts := DTOpts or DT_TOP;
          otaBottomLeft, otaBottomCenter, otaBottomRight :
             DTOpts := DTOpts or DT_BOTTOM;
        else
          DTOpts := DTOpts or DT_VCENTER;
        end;{case}
      end;

  { 06/2011 AB: The "old" behavior (4.06) should not be changed - but new options to display
                "..." at the end of the text if it doesn't fit should be offered. This is why
                'FEllipsisReadonly' has been introduced:
                True -> old behavior: FShowEllipsis is only used if CellAttr.caAccess =
                        otxReadOnly (although I can't see the point of this restriction).
                False -> FShowEllipsis is always used.

                To display "..." at the end of every line that does not fit (if the new
                option FIgnoreCR=False is used) DT_WORD_ELLIPSIS ist used; in any other
                case we still use DT_END_ELLIPSIS in order to preserve the old behavior. }

  if FShowEllipsis and ((CellAttr.caAccess = otxReadOnly) or not FEllipsisReadonly) then
    begin
      if FUseWordWrap or FIgnoreCR then
        DTOpts := DTOpts or DT_END_ELLIPSIS
      else
        DTOpts := DTOpts or DT_WORD_ELLIPSIS;
    end;

    case CellAttr.caTextStyle of
      tsFlat :
        DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
      tsRaised :
        begin
          OffsetRect(R, -1, -1);
          TblCanvas.Font.Color := CellAttr.caFontHiColor;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          OffsetRect(R, 1, 1);
          TblCanvas.Font.Color := CellAttr.caFontColor;
          TblCanvas.Brush.Style := bsClear;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          TblCanvas.Brush.Style := bsSolid;
        end;
      tsLowered :
        begin
          OffsetRect(R, 1, 1);
          TblCanvas.Font.Color := CellAttr.caFontHiColor;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          OffsetRect(R, -1, -1);
          TblCanvas.Font.Color := CellAttr.caFontColor;
          TblCanvas.Brush.Style := bsClear;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          TblCanvas.Brush.Style := bsSolid;
        end;
      end;
  end;

{--------}
function TOvcTCBaseString.GetEllipsisMode: TEllipsisMode;
begin
  if not FShowEllipsis then
    result := em_dont_show
  else if FEllipsisReadonly then
    result := em_show_readonly
  else
    result := em_show;
end;
{--------}
procedure TOvcTCBaseString.SetEllipsisMode(EM:TEllipsisMode);
begin
  if EM=em_dont_show then
    FShowEllipsis := False
  else begin
    FShowEllipsis := True;
    FEllipsisReadonly := EM=em_show_readonly;
  end;
end;

{--------}
procedure TOvcTCBaseString.SetDataStringType(ADST : TOvcTblStringtype);
  begin
    if ADST <> FDataStringType then begin
      FDataStringType := ADST;
      tcDoCfgChanged;
    end;
  end;

{--------}
procedure TOvcTCBaseString.SetUseWordWrap(WW : boolean);
  begin
    if (WW <> FUseWordWrap) then
      begin
        FUseWordWrap := WW;
        tcDoCfgChanged;
      end;
  end;
{====================================================================}

{ 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility
          Do not use this property in new projects - use 'DataStringType'
          instead. }

function TOvcTCBaseString.ReadASCIIZStrings: boolean;
begin
  result := DataStringType = tstString;
end;

procedure TOvcTCBaseString.SetUseASCIIZStrings(const Value: boolean);
begin
  if Value then
    DataStringType := tstString
  else if FDataStringType=tstString then
    DataStringType := tstShortString;
end;


end.

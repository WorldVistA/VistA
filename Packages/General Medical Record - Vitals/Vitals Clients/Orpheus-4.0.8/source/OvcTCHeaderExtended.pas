{*********************************************************}
{*                  OVCTCHDR.PAS 4.08                    *}
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

unit OvcTCHeaderExtended;
  {Orpheus Table Cell - Headers for columns and rows}

interface

uses
  UITypes, Windows, SysUtils, Graphics, Classes, Controls, OvcTCmmn, OvcTCell,
  OvcTCStr, OvcMisc, ovctchdr;

type
  TOvcTCColHeadExtendedInfoItem = class(TCollectionItem)
  private
    FCaption: string;
    FIcon: TIcon;
    FShowCaption: Boolean;
    procedure SetCaption(const Value: string);
    procedure SetIcon(const Value: TIcon);
    procedure SetShowCaption(const Value: Boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write SetCaption;
    property Icon: TIcon read FIcon write SetIcon;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
  end;

  TOvcTCColHeadExtendedInfoItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TOvcTCColHeadExtendedInfoItem;
    procedure SetItem(Index: Integer;
      const Value: TOvcTCColHeadExtendedInfoItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TOvcTCColHeadExtendedInfoItem;
    property Items[Index: Integer]: TOvcTCColHeadExtendedInfoItem read GetItem write SetItem; default;
    procedure ExchangeItems(I, J: Integer);
  end;

  // data storage for Extended Table Header Cell
  TOvcTCColHeadExtendedInfo = class(TOvcTCColHeadExtendedInfoItem)
  public
    constructor Create; reintroduce;
  end;

  TOvcTCColHeadExtended = class(TOvcTCCustomColHead)
    protected {private}

      FHeadings      : TOvcTCColHeadExtendedInfoItems;


    protected

      procedure SetHeadings(H : TOvcTCColHeadExtendedInfoItems);

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;


     public {protected}

      procedure chColumnsChanged(ColNum1, ColNum2 : TColNum; Action : TOvcTblActions); override;


    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

    published
      property Headings: TOvcTCColHeadExtendedInfoItems read FHeadings write SetHeadings;

      {properties inherited from custom ancestor}
      property About;
      property Adjust default otaDefault;
      property Color;
      property Font;
      property Margin default 4;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      //      property DataStringType;

      { 07/2011 AUCOS-HKK: Reimplemented 'ASCIIZStrings' for backward compatibility }
      property UseASCIIZStrings;
      property UseWordWrap default False;
      property ShowEllipsis default True;

      {events inherited from custom ancestor}
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;

implementation

uses
  Types, OvcExcpt;

{===TOvcTCColHeadExtended====================================================}
constructor TOvcTCColHeadExtended.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    FHeadings := TOvcTCColHeadExtendedInfoItems.Create(Self);
    Access := otxReadOnly;
    {UseWordWrap := false;}
    ShowLetters := true;
  end;
{--------}
destructor TOvcTCColHeadExtended.Destroy;
  begin
    FHeadings.Free;
    inherited Destroy;
  end;
{--------}
procedure TOvcTCColHeadExtended.chColumnsChanged(ColNum1, ColNum2 : TColNum;
                                         Action : TOvcTblActions);
  var
    MaxColNum : TColNum;
    ColNum    : TColNum;
  begin
    case Action of
      taInsert :
        if (0 <= ColNum1) and (ColNum1 < FHeadings.Count) then
          FHeadings.Insert(ColNum1)
        else if (ColNum1 = FHeadings.Count) then
          FHeadings.Add;
      taDelete :
        if (0 <= ColNum1) and (ColNum1 < FHeadings.Count) then
          FHeadings.Delete(ColNum1);
      taExchange :
        begin
          MaxColNum := MaxL(ColNum1, ColNum2);
          if (MaxColNum >= FHeadings.Count) and (FHeadings.Count > 0) then
            for ColNum := FHeadings.Count to MaxColNum do
              FHeadings.Add;
          if (0 <= ColNum1) and (0 <= ColNum2) and
             (FHeadings.Count > 0) then
              FHeadings.ExchangeItems(ColNum1, ColNum2);
        end;
    end;
  end;
{--------}
procedure TOvcTCColHeadExtended.tcPaint(TableCanvas : TCanvas;
                          const CellRect    : TRect;
                                RowNum      : TRowNum;
                                ColNum      : TColNum;
                          const CellAttr    : TOvcCellAttributes;
                                Data        : pointer);
  {------}
  procedure PaintAnArrow;
    var
      ArrowDim : Integer;
      X, Y     : Integer;
      LeftPoint, RightPoint, BottomPoint : TPoint;
      iCellWidth  : integer;
      CellHeight : integer;
    begin
      iCellWidth := CellRect.Right - CellRect.Left;
      CellHeight := CellRect.Bottom - CellRect.Top;
      with TableCanvas do
        begin
          Pen.Color := CellAttr.caFont.Color;
          Brush.Color := Pen.Color;
          ArrowDim := MinI(iCellWidth, CellHeight) div 3;
          case CellAttr.caAdjust of
            otaTopLeft, otaCenterLeft, otaBottomLeft:
              X := Margin;
            otaTopRight, otaCenterRight, otaBottomRight:
              X := iCellWidth-Margin-ArrowDim;
          else
            X := (iCellWidth - ArrowDim) div 2;
          end;{case}
          inc(X, CellRect.Left);
          case CellAttr.caAdjust of
            otaTopLeft, otaTopCenter, otaTopRight:
              Y := Margin;
            otaBottomLeft, otaBottomCenter, otaBottomRight:
              Y := CellHeight-Margin-ArrowDim;
          else
            Y := (CellHeight - ArrowDim) div 2;
          end;{case}
          inc(Y, CellRect.Top);
          LeftPoint := Point(X, Y);
          RightPoint := Point(X+ArrowDim, Y);
          BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
          Polygon([LeftPoint, RightPoint, BottomPoint]);
        end;
    end;
  {------}
  {-Changes
    04/2011 AB: Bugfix: As the inherited method expects a pointer to a string,
                PChar(HeadSt) had to be changed to @Head when calling 'inherited tcPaint'
    12/2012 AB: Due to the reimplementation of 'UseASCIIZStrings', the case 'DataString-
                Type'<>tstString must be taken into account here. }
  var
    LockedCols: TColNum;
    ActiveCol : TColNum;
    WorkCol   : TColNum;
    C         : char;
    HeadSt    : string;
    CA        : TOvcCellAttributes;
    orgDST    : TOvcTblStringtype;
    Item      : TOvcTCColHeadExtendedInfoItem;
    Icon      : TIcon;
    LCellRect : TRect;
    Left, Top : Integer;
    W, H      : Integer;
    CellHeight        : integer;
    CellAdj           : TOvcTblAdjust;
  begin
    Icon := nil;

    if (TObject(Data) is TOvcTCColHeadExtendedInfoItem) or (Data = nil) then
      Item := TOvcTCColHeadExtendedInfoItem(Data)
    else
      raise EOvcException.Create('Wrong Data type');

    CA := CellAttr;
    CellAdj := CellAttr.caAdjust;
    CellHeight := CellRect.Bottom - CellRect.Top;
    if Assigned(FTable) then
      begin
        LockedCols := tcRetrieveTableLockedCols;
        ActiveCol := tcRetrieveTableActiveCol;
      end
    else
      begin
        LockedCols := 0;
        ActiveCol := -1;
      end;
    HeadSt := '';
    { Set the cell color and font }
    if not TableColor then
      CA.caColor := Color;
    if not TableFont then begin
      CA.caFont.Assign(Font);
      CA.caFontColor := Font.Color;
    end;
    { We always pass a pointer to a string (@HeadSt) to the inherited method, therefore
      'DataStringType' must be set to tstString before calling the inherited method. }
    orgDST := FDataStringType;
    FDataStringType := tstString;
    { if required show a down arrow for the active column }
    if ShowActiveCol and (ColNum = ActiveCol) then
      begin
        {this call to inherited tcPaint blanks out the cell}
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA, @HeadSt);
        PaintAnArrow;
      end
    else if ShowLetters then
      begin
        {convert the column number to the spreadsheet-style letters}
        WorkCol := ColNum - LockedCols + 1;
        HeadSt := '.';
        while (WorkCol > 0) do
          begin
            C := Char(pred(WorkCol) mod 26 + ord('A'));
            System.Insert(C, HeadSt, 1);
            WorkCol := pred(WorkCol) div 26;
          end;
        Delete(HeadSt, length(HeadSt), 1);
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA, @HeadSt);
      end
    else {Data points to a column heading}
      begin
        HeadSt := '';
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA, @HeadSt); // clear background

        if Assigned(Data) then
        begin
          if Item.ShowCaption then
            HeadSt := Item.Caption;
          Icon   := Item.Icon;
        end else if (0 <= ColNum) and (ColNum < Headings.Count) then
        begin
          if Headings[ColNum].ShowCaption then
            HeadSt := Headings[ColNum].Caption;
          Icon := Headings[ColNum].Icon;
        end
        else
          HeadSt := '';

        LCellRect := CellRect;

        if Assigned(Icon) and not Icon.Empty then
        begin
          W := Icon.Width;
          H := Icon.Height;

          case CellAdj of
            otaTopLeft, otaTopCenter, otaTopRight :
               Top := Margin;
            otaBottomLeft, otaBottomCenter, otaBottomRight :
               Top := (CellHeight - H - Margin);
          else
            Top := (CellHeight - H) div 2;
          end;{case}

          Left := CellRect.Left + Margin;
          Top := TOp + CellRect.Top;
          TableCanvas.Draw(Left, Top, Icon, 0);
          LCellRect.Left := LCellRect.Left + Margin + W;
        end;

        inherited tcPaint(TableCanvas, LCellRect, RowNum, ColNum, CA, @HeadSt);
      end;
    { restore 'DataStringType' }
    FDataStringType := orgDST;
  end;

{--------}
procedure TOvcTCColHeadExtended.SetHeadings(H : TOvcTCColHeadExtendedInfoItems);
  begin
    FHeadings.Assign(H);
    tcDoCfgChanged;
  end;
{====================================================================}

{ TOvcTCColHeadExtendedInfoItem }

procedure TOvcTCColHeadExtendedInfoItem.Assign(Source: TPersistent);
  procedure AssignFromMyType(Src: TOvcTCColHeadExtendedInfoItem);
  begin
    Caption := Src.Caption;
    Icon := Src.Icon;
    ShowCaption := Src.ShowCaption;
  end;

begin
  if Source is TOvcTCColHeadExtendedInfoItem then
    AssignFromMyType(TOvcTCColHeadExtendedInfoItem(Source))
  else
    inherited;
end;

constructor TOvcTCColHeadExtendedInfoItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FIcon := TIcon.Create;
  FShowCaption := True;
end;

destructor TOvcTCColHeadExtendedInfoItem.Destroy;
begin
  FreeAndNil(FIcon);
  inherited;
end;

function TOvcTCColHeadExtendedInfoItem.GetDisplayName: string;
begin
  Result := FCaption;
end;

procedure TOvcTCColHeadExtendedInfoItem.SetCaption(const Value: string);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TOvcTCColHeadExtendedInfoItem.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
  Changed(False);
end;

procedure TOvcTCColHeadExtendedInfoItem.SetShowCaption(const Value: Boolean);
begin
  FShowCaption := Value;
  Changed(False);
end;

{ TOvcTCColHeadExtendedInfoItems }

function TOvcTCColHeadExtendedInfoItems.Add: TOvcTCColHeadExtendedInfoItem;
begin
  Result := TOvcTCColHeadExtendedInfoItem(inherited Add);
end;

constructor TOvcTCColHeadExtendedInfoItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TOvcTCColHeadExtendedInfoItem);
end;

procedure TOvcTCColHeadExtendedInfoItems.ExchangeItems(I, J: Integer);
var
  Item1, Item2 : TOvcTCColHeadExtendedInfoItem;
  tmp: Integer;
begin
  if I > J then
  begin // swap I, J
    tmp := I;
    I := J;
    J := tmp;
  end;

  Item1 := Items[I];
  Item2 := Items[J];

  Item1.Index := J;
  Item2.Index := I;
end;

function TOvcTCColHeadExtendedInfoItems.GetItem(
  Index: Integer): TOvcTCColHeadExtendedInfoItem;
begin
  Result := TOvcTCColHeadExtendedInfoItem(inherited Items[Index]);
end;

procedure TOvcTCColHeadExtendedInfoItems.SetItem(Index: Integer;
  const Value: TOvcTCColHeadExtendedInfoItem);
begin
  inherited Items[Index] := Value;
end;

procedure TOvcTCColHeadExtendedInfoItems.Update(Item: TCollectionItem);
begin
  inherited;
  if Owner is TOvcTCColHeadExtended then
    TOvcTCColHeadExtended(Owner).tcDoCfgChanged;
end;

{ TOvcTCColHeadExtendedInfo }

constructor TOvcTCColHeadExtendedInfo.Create;
begin
  inherited Create(nil);
end;

end.

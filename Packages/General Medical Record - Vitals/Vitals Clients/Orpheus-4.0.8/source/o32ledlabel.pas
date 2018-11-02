{*********************************************************}
{*                  O32LEDLABEL.PAS 4.06                 *}
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

unit o32ledlabel;
 {- The LED Label that is used in the OvcClock for digital display           }

interface

uses
  Windows, Classes, Controls, Graphics, Messages, SysUtils, OvcBase, O32SR;

type
  TSegmentSize = 2..10;

  TO32CustomLEDLabel = class(TGraphicControl)
  protected{private}
    FBgColor   : TColor;
    FOffColor  : TColor;
    FOnColor   : TColor;
    FColumns   : Integer;
    FRows      : Integer;
    FSize      : TSegmentSize;
    lbDrawBmp  : TBitmap;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure Initialize(var Points: array of TPoint);
    function  NewOffset(xOry: char; OldOffset: Integer): Integer;
    procedure ProcessCaption(Points: array of TPoint);
    procedure PaintSegment(Segment: Integer; Color: TColor;
                           Points: array of TPoint;
                           OffsetX, OffsetY: Integer);
    procedure ResizeControl(Row, Col, Size: Integer);
    function  GetAbout: string;
    procedure SetAbout(const Value: string);
    procedure SetSize(Value: TSegmentSize);
    procedure SetOnColor(Value: TColor);
    procedure SetOffColor(Value: TColor);
    procedure SetRows(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure SetbgColor(Value: TColor);
    procedure SelectSegments(Segment: Word;
                              Points: array of TPoint;
                              OffsetX, OffsetY: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy; override;
    {properties}
    property About: string
      read GetAbout write SetAbout stored False;
    property Columns: Integer
      read FColumns write SetColumns default 10;
    property Rows: Integer
      read FRows write SetRows default 1;
    property BgColor: TColor
      read FbgColor write SetbgColor default clBlack;
    property OffColor: TColor
      read FOffColor write SetOffColor default $00104E4A;
    property OnColor: TColor
      read FOnColor write SetOnColor default clYellow;
    property Size: TSegmentSize
      read FSize write SetSize default 2;
    {Inherited properties}
    property Caption;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

  TO32LEDLabel = class(TO32CustomLEDLabel)
  published
    property About;
    property Caption;
    property Columns;
    property Rows;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property BgColor;
    property OffColor;
    property OnColor;
    property ParentShowHint;
    property PopupMenu;
    property Size;
    property ShowHint;
    property Visible;
  end;

implementation

uses
  OvcVer;

{        LED Segment Map            }
{                                   }
{ ------------------------          }
{ |          1           |          }
{ ------------------------          }
{ |  | \    |  |    / |  |          }
{ |  |  \   |  |   /  |  |          }
{ |  |   \  |  |  /   |  |          }
{ |2 |\3  \ |4 | /5  /|6 |          }
{ |  | \   \|  |/   / |  |          }
{ |  |  \   |  |   /  |  |          }
{ -----------  -----------          }
{ |   7      \/   8      |          }
{ -----------/\-----------          }
{ |  |  /   |  |   \  |  |          }
{ |  | /   /|  |\   \ |  |          }
{ |9 |/10 / |11| \12 \|13|          }
{ |  |   /  |  |  \   |  |          }
{ |  |  /   |  |   \  |  |          }
{ |  | /    |  |    \ |  |          }
{ ------------------------ |-----|  }
{ |          14          | |  *  |  }
{ ------------------------ |-----|  }
{                                   }
{ * Period and comma are drawn here }
{ Colon is drawn in the center of   }
{ segments 4 and 11                 }

{ Each segment is made up of 6 points.  The segments that don't need 6 points, }
{ such as the period and colon dots, return to the coordinates of the initial  }
{ point for the remaining unused points.                                       }

const
{LED SEGMENT ARRAYS}
  MAX_POINTS = 107;

  DigitPoints: array[0..MAX_POINTS] of TPoint =
  {Segment 1}
  ((X:2;Y:2),(X:3;Y:1),(X:11;Y:1),(X:12;Y:2),(X:11;Y:3),(X:3;Y:3),
  {Segment 2}
  (X:2;Y:3),(X:3;Y:4),(X:3;Y:12),(X:2;Y:13),(X:1;Y:12),(X:1;Y:4),
  {Segment 3}
  (X:3;Y:3),(X:6;Y:9),(X:6;Y:13),(X:3;Y:7),(X:3;Y:3),(X:3;Y:3),
  {Segment 4}
  (X:7;Y:3),(X:8;Y:4),(X:8;Y:12),(X:7;Y:13),(X:6;Y:12),(X:6;Y:4),
  {Segment 5}
  (X:11;Y:3),(X:11;Y:7),(X:8;Y:13),(X:8;Y:9),(X:11;Y:3),(X:11;Y:3),
  {Segment 6}
  (X:12;Y:3),(X:13;Y:4),(X:13;Y:12),(X:12;Y:13),(X:11;Y:12),(X:11;Y:4),
  {Segment 7}
  (X:2;Y:14),(X:3;Y:13),(X:6;Y:13),(X:7;Y:14),(X:6;Y:15),(X:3;Y:15),
  {Segment 8}
  (X:7;Y:14),(X:8;Y:13),(X:11;Y:13),(X:12;Y:14),(X:11;Y:15),(X:8;Y:15),
  {Segment 9}
  (X:2;Y:15),(X:3;Y:16),(X:3;Y:24),(X:2;Y:25),(X:1;Y:24),(X:1;Y:16),
  {Segment 10}
  (X:6;Y:15),(X:6;Y:19),(X:3;Y:25),(X:3;Y:21),(X:6;Y:15),(X:6;Y:15),
  {Segment 11}
  (X:7;Y:15),(X:8;Y:16),(X:8;Y:24),(X:7;Y:25),(X:6;Y:24),(X:6;Y:16),
  {Segment 12}
  (X:8;Y:15),(X:11;Y:21),(X:11;Y:25),(X:8;Y:19),(X:8;Y:15),(X:8;Y:15),
  {Segment 13}
  (X:12;Y:15),(X:13;Y:16),(X:13;Y:24),(X:12;Y:25),(X:11;Y:24),(X:11;Y:16),
  {Segment 14}
  (X:2;Y:26),(X:3;Y:25),(X:11;Y:25),(X:12;Y:26),(X:11;Y:27),(X:3;Y:27),
  {Period    }
  (X:14;Y:25),(X:16;Y:25),(X:16;Y:27),(X:14;Y:27),(X:14;Y:25),(X:14;Y:25),
  {Comma     }
  (X:14;Y:25),(X:16;Y:25),(X:16;Y:27),(X:13;Y:30),(X:14;Y:27),(X:14;Y:25),
  {Colon Top }
  (X:5;Y:7),(X:9;Y:7),(X:9;Y:10),(X:5;Y:10),(X:5;Y:7),(X:5;Y:7),
  {Colon Btm }
  (X:5;Y:20),(X:9;Y:20),(X:9;Y:23),(X:5;Y:23),(X:5;Y:20),(X:5;Y:20));

  Characters: Array[0..72] of Word =
  ($0000,$3B70,$1320,$0001,$0300,$0002,$0840,$CCCC,$1020,$8784,
  { ' '    *      +    ,     -     .     /      0     1     2  }
   $870C,$4708,$C30C,$C38C,$8408,$C78C,$C70C,$0810,$2040,$C788,
  {   3     4     5     6     7     8     9     <     >     A  }
   $952C,$C084,$942C,$C384,$C380,$C18C,$4788,$9024,$048C,$4A90,
  {   B     C     D     E     F     G     H     I     J     K  }
   $4084,$6C88,$6498,$C48C,$C780,$C49E,$C790,$C214,$9020,$448C,
  {   L     M     N     O     P     Q     R     S     T     U  }
   $48C0,$44D8,$2850,$2820,$8844,$2010,$C788,$952C,$C084,$942C,
  {   V     W     X     Y     Z     /     a     b     c     d  }
   $C384,$C380,$C18C,$4788,$9024,$048C,$4A90,$4084,$6C88,$6498,
  {   e     f     g     h     i     j     k     l     m     n  }
   $C48C,$C780,$C49E,$C790,$C214,$9020,$448C,$48C0,$44D8,$2850,
  {   o     p     q     r     s     t     u     v     w     x  }
   $2820,$8844,$FFFF);
  {   y     z     : }

  CharacterNDX: Array[1..122] of integer =
  (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
   10, 11, 12, 13, 14, 15, 16, 72, 0, 17, 0, 18, 0, 0, 19, 20, 21, 22, 23, 24,
   25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43,
   44, 0, 45, 0, 0, 0, 0, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
   32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44);


{===== TO32CustomLEDLabel ============================================}

constructor TO32CustomLEDLabel.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse,
                   csOpaque,
                   csSetCaption,
                   csClickEvents,
                   csDoubleClicks];
  lbDrawBmp := TBitmap.Create;
  Width := 75;
  Height := 30;
  FOnColor := clYellow;
  FOffColor := $00104E4A;
  FBgColor := clBlack;
  FSize := 2;
  FRows := 1;
  FColumns := 10;
end;
{=====}

destructor TO32CustomLEDLabel.Destroy;
begin
  lbDrawBmp.Free;
  lbDrawBmp := nil;
  inherited Destroy;
end;
{=====}

function TO32CustomLEDLabel.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32CustomLEDLabel.SetAbout(const Value : string);
begin
  {Leave empty}
end;
{=====}

procedure TO32CustomLEDLabel.CMTextChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;
{=====}

procedure TO32CustomLEDLabel.Initialize(var Points: array of TPoint);
var
  I     : Integer;
begin
  for I := 0 to MAX_POINTS do begin
    Points[i].X := DigitPoints[i].X * (FSize - 1);
    Points[i].Y := DigitPoints[i].Y * (FSize - 1);
  end;
end;
{=====}

function TO32CustomLEDLabel.NewOffset(xOry:char;oldOffset:integer):integer;
begin
  if (xOry = 'x')then
    newOffset := oldOffset + 17 * (FSize - 1)
  else
    newOffset := oldOffset + 30 * (FSize -1)
end;

procedure TO32CustomLEDLabel.Paint;
var
  Points: array[0..MAX_POINTS] of TPoint;
begin
  lbDrawBMP.Width := Width;
  lbDrawBMP.Height := Height;

  Initialize(Points);
  lbDrawBMP.Canvas.Brush.Color := FBgColor;
  lbDrawBMP.Canvas.FillRect(ClientRect);
  ProcessCaption(Points);

  Canvas.CopyMode := cmSrcCopy;
  Canvas.Draw(0, 0, lbDrawBMP);
end;
{=====}

procedure TO32CustomLEDLabel.PaintSegment(Segment: Integer; Color: TColor;
                                          Points: array of TPoint;
                                          OffsetX, OffsetY: Integer);
var
  I: Integer;
  DrawPts: array[0..5] of TPoint;
begin
  Dec(Segment);
  lbDrawBMP.Canvas.Pen.Style := psClear;
  lbDrawBMP.Canvas.Brush.Color := Color;
  for i := 0 to 5 do begin
    DrawPts[i].X := offsetX + Points[Segment * 6 + i].X;
    DrawPts[i].Y := offsetY + Points[Segment * 6 + i].Y;
  end;
  lbDrawBMP.Canvas.Polygon(DrawPts);
end;
{=====}

procedure TO32CustomLEDLabel.SelectSegments(Segment: word; Points: array of TPoint;
  OffsetX, OffsetY: Integer);
var
  I     : integer;
  Bit   : word;
  Color : TColor;
  Skip  : Boolean;
begin
  if (Segment and $FFFF) = $FFFF then begin
    Color := FOnColor;
    PaintSegment(17, Color, Points, OffsetX, OffsetY);
    PaintSegment(18, Color, Points, OffsetX, OffsetY);
  end
  else begin
    Bit := $8000;
    for I := 1 to 16 do begin
      Skip := False;
      if (Segment and Bit) = Bit then
        Color := FOnColor
      else begin
        if (i = 15) or (i = 16) then
          Skip := True;
        Color := FOffColor;
      end;
      if (not Skip) and (Color <> FBgColor) then
          PaintSegment(I, Color,  Points, OffsetX,  OffsetY);
      Bit := Bit div 2;
    end;
  end;
end;
{=====}

procedure TO32CustomLEDLabel.ProcessCaption(Points: array of TPoint);
var
  Next           : Char;
  Last           : Char;
  I, X           : Integer;
  Row, ColsPerRow: Integer;
  Tmp            : Integer;
  OffsetX        : Integer;
  OffsetY        : Integer;
  DisplayStr     : string;
begin
  Last := #0;
  OffsetX  := FSize;
  OffsetY  := 0;

  DisplayStr := Caption;

  if Length(DisplayStr) > 0 then
    if (DisplayStr[1] = ',') or (DisplayStr[1] = '.') then
      DisplayStr := ' ' + DisplayStr;

  Row := 1;
  ColsPerRow := 0;
  for I := 1 to Length(Caption) do begin
    Next := Caption[I];
    case Ord(Next) of
      42..58,60,62,65..90,92,97..122: begin
        if ColsPerRow = FColumns  then begin
          Row := Row + 1;
          if Row > FRows then
            exit;
          offsetY := newOffset('y',offsetY);
          offsetX := FSize;
          ColsPerRow := 0
        end;
        if (Next = '.') or (Next = ',') then
          if (Last = '.') or (Last = ',') then begin
            SelectSegments(Characters[CharacterNDX[Ord(Next)]], Points,
              OffsetX, OffsetY);
            OffsetX := NewOffset('x', OffsetX);
          end
          else begin
            OffsetX := OffsetX - (17 * (FSize - 1));
            Tmp := (Characters[CharacterNDX[Ord(Next)]]
              or Characters[CharacterNDX[Ord(Last)]]);
            SelectSegments(Tmp, Points, OffsetX,  OffsetY);
            OffsetX := NewOffset('x', OffsetX);
          end
        else begin
          SelectSegments(Characters[CharacterNDX[Ord(Next)]], Points, OffsetX,
            OffsetY);
          offsetX := NewOffset('x', OffsetX);
          ColsPerRow := ColsPerRow + 1;
        end;
        end;
      10: begin {eat linefeed}
        end;
      13: begin
        if ColsPerRow < FColumns then
          for x := 1 to (FColumns - ColsPerRow) do begin
            SelectSegments(Characters[CharacterNDX[1]], Points, OffsetX,  OffsetY);
            OffsetX := NewOffset('x', OffsetX);
          end;
          Row := Row + 1;
          if Row > FRows then
             exit;
          OffsetY := NewOffset('y', OffsetY);
          OffsetX := FSize;
          ColsPerRow := 0;
        end;
        else begin
          if ColsPerRow = FColumns  then begin
            Row := Row + 1;
            if Row > FRows then
              Exit;
            OffsetY := NewOffset('y', OffsetY);
            OffsetX := FSize;
            ColsPerRow := 0;
          end;
          SelectSegments(Characters[CharacterNDX[1]], Points, OffsetX, OffsetY);
          OffsetX := newOffset('x', OffsetX);
          ColsPerRow := ColsPerRow + 1;
        end;
    end;
    Last := Next;
  end;
  for x := 1 to (FColumns - ColsPerRow) do begin
    SelectSegments(Characters[CharacterNDX[1]], Points, OffsetX, OffsetY);
    OffsetX := NewOffset('x', OffsetX);
  end;
  if (FColumns * FRows) > Length(caption) then begin
    for X := Row + 1 to FRows do begin
      OffsetX := FSize;
      OffsetY := NewOffset('y', OffsetY);
      for I := 1 to FColumns do begin
        SelectSegments(Characters[CharacterNDX[1]], Points, OffsetX, OffsetY);
        OffsetX := NewOffset('x', OffsetX);
      end;
    end;
  end;
end;
{=====}

procedure TO32CustomLEDLabel.ResizeControl(Row, Col, Size: Integer);
begin
  FRows := Row;
  FColumns := Col;
  FSize := Size;
  SetBounds(Left, Top, FColumns * 17 * (FSize - 1), FRows * 30 * (FSize - 1));
  Invalidate;
end;
{=====}

procedure TO32CustomLEDLabel.SetBgColor(Value:TColor);
begin
  if FBgColor <> Value then begin
    FBgColor := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLEDLabel.SetOnColor(Value:TColor);
begin
  if FOnColor <> Value then begin
    FOnColor := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLEDLabel.SetOffColor(Value:TColor);
begin
  if FOffColor <> Value then begin
    FOffColor := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomLEDLabel.SetRows(Value: Integer);
begin
  if FRows <> Value then
    ResizeControl(Value, FColumns, FSize);
end;
{=====}

procedure TO32CustomLEDLabel.SetColumns(Value:Integer);
begin
  if FColumns <> Value then
    ResizeControl(FRows,  Value,  FSize);
end;
{=====}

procedure TO32CustomLEDLabel.SetSize(Value: TSegmentSize);
begin
  if FSize <> Value then
    ResizeControl(FRows, FColumns, Value);
end;
{=====}

end.

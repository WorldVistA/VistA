{*********************************************************}
{*                   OVCCARET.PAS 4.06                   *}
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

{$B-} {Short-circuit Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovccaret;
  {-Caret handling class}

interface

uses
  Windows, Graphics, Classes, Controls, Forms;

type
  TOvcCaretShape = (                 {Predefined caret shapes..}
                    csBlock,         {..block over whole cell}
                    csHalfBlock,     {..block over bottom part of cell}
                    csVertLine,      {..vertical line to left of cell}
                    csHorzLine,      {..horizontal line on bottom of cell}
                    csCustom,        {..custom width/height}
                    csBitmap);       {..bitmap caret, custom width/height}

  TOvcCaretAlign = (                 {Alignment of caret in cell..}
                    caLeft,          {..left side, centered vertically}
                    caTop,           {..top side, centered horizontally}
                    caRight,         {..right side, centered vertically}
                    caBottom,        {..bottom side, centered horizontally}
                    caCenter);       {..centered vertically and horizontally}

type
  {Class defining a caret shape}
  TOvcCaret = class(TPersistent)

  protected
    {property fields}
    FAlign     : TOvcCaretAlign;      {Caret alignment in cell}
    FBitmap    : TBitmap;             {Bitmap for a bitmapped caret}
    FBitmapX   : Integer;             {Bitmap's hotspot X}
    FBitmapY   : Integer;             {Bitmap's hotspot Y}
    FBlinkTime : word;                {Blink time}
    FCaretHt   : Integer;             {Height: autosized for some shapes}
    FCaretWd   : Integer;             {Width: autosized for some shapes}
    FIsGray    : boolean;             {True if a 'gray' caret}
    FShape     : TOvcCaretShape;      {Shape}

    FOnChange  : TNotifyEvent;        {Owner's change notification}

    {internal fields}
    RefCount      : word;             {Reference count}

    {property access methods}
    procedure SetAlign(A : TOvcCaretAlign);
    procedure SetBitmap(BM : TBitMap);
    procedure SetBitmapX(X : Integer);
    procedure SetBitmapY(Y : Integer);
    procedure SetBlinkTime(BT : word);
    procedure SetCaretHeight(CH : Integer);
    procedure SetCaretWidth(CW : Integer);
    procedure SetIsGray(IG : boolean);
    procedure SetShape(S : TOvcCaretShape);

    {general methods}
    procedure NotifyChange;

  public
    {VCL methods}
    constructor Create;
    destructor Destroy; override;

    {other methods}
    procedure Register;
    procedure Deregister;

    {properties}
    property OnChange : TNotifyEvent
        read FOnChange
        write FOnChange;


  published
    {properties}
    property Bitmap : TBitmap
        read FBitmap write SetBitmap;
    property BitmapHotSpotX : Integer
        read FBitmapX write SetBitmapX
        default 0;
    property BitmapHotSpotY : Integer
        read FBitmapY write SetBitmapY
        default 0;
    property Shape : TOvcCaretShape
        read FShape write SetShape
        default csVertLine;
    property Align : TOvcCaretAlign
        read FAlign write SetAlign
        default caLeft;
    property BlinkTime : word
        read FBlinkTime write SetBlinkTime
        default 0;
    property CaretHeight : Integer
        read FCaretHt write SetCaretHeight
        default 10;
    property CaretWidth : Integer
        read FCaretWd write SetCaretWidth
        default 2;
    property IsGray : boolean
        read FIsGray write SetIsGray
        default False;
  end;


type
  TOvcSingleCaret = class(TPersistent)
  {Class defining a Single caret}
  protected
    {property fields}
    FCaretType : TOvcCaret;           {Current caret type}
    FHeight    : Integer;             {Cell height}
    FLinked    : boolean;             {True if linked to owner}
    FPos       : TPoint;              {Position within owner}
    FVisible   : boolean;             {True if visible}
    FWidth     : Integer;             {Cell width}

    {other fields}
    OrigBlinkTime : word;             {Blink time before linking}
    Owner   : TWinControl;            {Owning control}
    XOffset : Integer;                {X Offset of caret in cell}
    YOffset : Integer;                {Y Offset of caret in cell}

    {property access methods}
    procedure SetCaretType(CT : TOvcCaret);
    procedure SetCellHeight(CH : Integer);
    procedure SetCellWidth(CW : Integer);
    procedure SetLinked(L : boolean);
    procedure SetPos(P : TPoint);
    procedure SetVisible(V : boolean);

    {general methods}
    procedure MakeShape;
    procedure Reinit;
    procedure ResetPos;

  public
    {VCL methods}
    constructor Create(AOwner : TWinControl);
    destructor Destroy; override;

    {general methods}
    procedure CaretTypeHasChanged(Sender : TObject);

    {properties}
    property CaretType : TOvcCaret
        read FCaretType
        write SetCaretType;

    property CellHeight : Integer
        read FHeight
        write SetCellHeight;

    property CellWidth : Integer
        read FWidth
        write SetCellWidth;

    property Linked : boolean
        read FLinked
        write SetLinked
        stored false;

    property Position : TPoint
        read FPos
        write SetPos;

    property Visible : boolean
        read FVisible
        write SetVisible;
  end;

type
  TOvcCaretPair = class(TOvcSingleCaret)
  {Class defining a pair of carets, one each for insert/overwrite modes}
  protected
    {property fields}
    FInsMode  : boolean;
    FInsCaretType : TOvcCaret;
    FOvrCaretType : TOvcCaret;

    {property access methods}
    procedure SetInsMode(IM : boolean);
    procedure SetInsCaretType(ICT : TOvcCaret);
    procedure SetOvrCaretType(OCT : TOvcCaret);

  public
    {VCL methods}
    constructor Create(AOwner : TWinControl);
    destructor Destroy; override;

    {properties}
    property InsertMode : boolean
        read FInsMode
        write SetInsMode;

    property InsCaretType : TOvcCaret
        read FInsCaretType
        write SetInsCaretType;

    property OvrCaretType : TOvcCaret
        read FOvrCaretType
        write SetOvrCaretType;
  end;



implementation



{---TOvcCaret----------------------------------------------------}
constructor TOvcCaret.Create;
  begin
    inherited Create;

    FShape     := csVertLine;
    FAlign     := caLeft;
    FBlinkTime := 0;
    FIsGray    := False;
    FBitMap    := TBitMap.Create;
    FCaretHt   := 10;
    FCaretWd   := 2;
  end;
{--------}
destructor TOvcCaret.Destroy;
  begin
    FBitMap.Free;
    inherited Destroy;
  end;
{--------}
procedure TOvcCaret.Deregister;
  begin
    {decrement the reference count, if no one references us
     any more, kill ourselves}
    dec(RefCount);
    if (RefCount = 0) then
      Free;
  end;
{--------}
procedure TOvcCaret.NotifyChange;
  begin
    if Assigned(FOnChange) then
      FOnChange(Self);
  end;
{--------}
procedure TOvcCaret.Register;
  begin
    inc(RefCount);
  end;
{--------}
procedure TOvcCaret.SetAlign(A : TOvcCaretAlign);
  begin
    if (A <> FAlign) then
      begin
        FAlign := A;
        NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetBitmap(BM : TBitmap);
  begin
    if not Assigned(BM) then
      Exit;
    FBitMap.Assign(BM);
    NotifyChange;
  end;
{--------}
procedure TOvcCaret.SetBitmapX(X : Integer);
  begin
    if (X <> FBitMapX) then
      begin
        FBitMapX := X;
        if (Shape = csBitMap) then
          NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetBitmapY(Y : Integer);
  begin
    if (Y <> FBitMapY) then
      begin
        FBitMapY := Y;
        if (Shape = csBitMap) then
          NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetBlinkTime(BT : word);
  begin
    if (BT <> FBlinkTime) then
      begin
        FBlinkTime := BT;
        NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetCaretHeight(CH : Integer);
  begin
    if (CH <> FCaretHt) and (CH > 0) then
      begin
        FCaretHt := CH;
        NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetCaretWidth(CW : Integer);
  begin
    if (CW <> FCaretWd) and (CW > 0) then
      begin
        FCaretWd := CW;
        NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetIsGray(IG : boolean);
  begin
    if (IG <> FIsGray) then
      begin
        FIsGray := IG;
        NotifyChange;
      end;
  end;
{--------}
procedure TOvcCaret.SetShape(S : TOvcCaretShape);
  begin
    if (S <> FShape) then
      begin
        FShape := S;
        case FShape of
          csBlock:
            FAlign := caLeft;
          csVertLine :
            begin
              FAlign := caLeft;
              FCaretWd := 2;
            end;
          csHalfBlock:
            FAlign := caBottom;
          csHorzLine :
            begin
              FAlign := caBottom;
              FCaretHt := 2;
            end;
          csBitmap :
            begin
              FCaretHt := FBitMap.Height;
              FCaretWd := FBitMap.Width;
            end;
        end;{case}
        NotifyChange;
      end;
  end;
{--------------------------------------------------------------------}


{---TOvcSingleCaret--------------------------------------------------}
constructor TOvcSingleCaret.Create(AOwner : TWinControl);
  begin
    inherited Create;
    Owner := AOwner;

    FHeight := 10;
    FWidth := 10;

    {make our default caret type}
    FCaretType := TOvcCaret.Create;
    FCaretType.Register;
    Reinit;
  end;
{--------}
destructor TOvcSingleCaret.Destroy;
  begin
    Visible := false;
    Linked := false;
    FCaretType.Deregister;

    inherited Destroy;
  end;
{--------}
procedure TOvcSingleCaret.CaretTypeHasChanged(Sender : TObject);
  var
    WasLinked : boolean;
  begin
    {if something has changed about the caret, unlink from
     our owner, recalc our values, relink}
    WasLinked := Linked;
    Linked := false;
    Reinit;
    Linked := WasLinked;
  end;
{--------}
procedure TOvcSingleCaret.MakeShape;
  begin
    {don't bother if we aren't linked to anything or if we
     don't have a caret type}
    if (not Linked) or (not Assigned(FCaretType)) then
      Exit;

    {create the caret, and if necessary show it}
    with FCaretType do
      if (Shape = csBitmap) then
           CreateCaret(Owner.Handle, Bitmap.Handle, 0, 0)
      else CreateCaret(Owner.Handle, ord(IsGray), CaretWidth, CaretHeight);
    if Visible then
      ShowCaret(Owner.Handle);
  end;
{--------}
procedure TOvcSingleCaret.Reinit;
  var
    NewXOfs : Integer;
    NewYOfs : Integer;
  begin
    {don't bother if we don't have a caret type}
    if (not Assigned(FCaretType)) then
      Exit;

    {inits}
    NewXOfs := 0;
    NewYOfs := 0;

    with FCaretType do
      begin
        {stop recursion}
        OnChange := nil;

        {recalc the caret type's height and width}
        if (Shape <> csBitmap) and (Shape <> csCustom) then
          begin
            case Shape of
              csBlock    :
                begin
                  CaretHeight := FHeight;
                  CaretWidth := FWidth;
                end;
              csHalfBlock:
                begin
                  CaretHeight := FHeight div 2;
                  CaretWidth := FWidth;
                end;
              csVertLine : CaretHeight := FHeight;
              csHorzLine : CaretWidth := FWidth;
            end;{case}
          end;

        {allow changes to percolate through again}
        OnChange := CaretTypeHasChanged;

        {recalc the X and Y offsets}
        case Align of
          caLeft   : begin
                       NewXOfs := 0;
                       NewYOfs := (FHeight - CaretHeight) div 2;
                     end;
          caTop    : begin
                       NewXOfs := (FWidth - CaretWidth) div 2;
                       NewYOfs := 0;
                     end;
          caRight  : begin
                       NewXOfs := FWidth - CaretWidth;
                       NewYOfs := (FHeight - CaretHeight) div 2;;
                     end;
          caBottom : begin
                       NewXOfs := (FWidth - CaretWidth) div 2;
                       NewYOfs := FHeight - CaretHeight;
                     end;
          caCenter : begin
                       NewXOfs := (FWidth - CaretWidth) div 2;
                       NewYOfs := (FHeight - CaretHeight) div 2;
                     end;
        end;{case}
        if (Shape = csBitMap) then
          begin
            dec(NewXOfs, BitMapHotSpotX);
            dec(NewYOfs, BitMapHotSpotY);
          end;
        if (NewXOfs <> XOffset) or (NewYOfs <> YOffset) then
          begin
            XOffset := NewXOfs;
            YOffset := NewYOfs;
            if Linked then
              ResetPos;
          end;
      end;
  end;
{--------}
procedure TOvcSingleCaret.ResetPos;
  var
    NewX, NewY : Integer;
  begin
    if (FPos.X = MaxInt) then
         NewX := MaxInt
    else NewX := FPos.X + XOffset;
    if (FPos.Y = MaxInt) then
         NewY := MaxInt
    else NewY := FPos.Y + YOffset;
    SetCaretPos(NewX, NewY);
  end;
{--------}
procedure TOvcSingleCaret.SetCaretType(CT : TOvcCaret);
  begin
    if (CT <> FCaretType) then
      begin
        FCaretType.Deregister;
        FCaretType := CT;
        FCaretType.Register;
        FCaretType.OnChange := CaretTypeHasChanged;
        CaretTypeHasChanged(Self);
      end;
  end;
{--------}
procedure TOvcSingleCaret.SetCellHeight(CH : Integer);
  begin
    if (CH <> FHeight) and (CH > 0) then
      begin
        FHeight := CH;
        CaretTypeHasChanged(Self);
      end;
  end;
{--------}
procedure TOvcSingleCaret.SetCellWidth(CW : Integer);
  begin
    if (CW <> FWidth) and (CW > 0) then
      begin
        FWidth := CW;
        CaretTypeHasChanged(Self);
      end;
  end;
{--------}
procedure TOvcSingleCaret.SetLinked(L : boolean);
  begin
    if (L <> FLinked) then
      begin
        FLinked := L;
        if Assigned(Owner) and Owner.HandleAllocated then
          if FLinked then
            begin
              OrigBlinkTime := GetCaretBlinkTime;
              MakeShape;
              ResetPos;
              if (OrigBlinkTime <> CaretType.BlinkTime) then
                if (CaretType.BlinkTime <> 0) then
                  SetCaretBlinkTime(CaretType.BlinkTime);
            end
          else
            begin
              SetCaretBlinkTime(OrigBlinkTime);
              DestroyCaret;
            end
        else
          FLinked := false;
      end;
  end;
{--------}
procedure TOvcSingleCaret.SetPos(P : TPoint);
  begin
    if (P.X < 0) then
      P.X := MaxInt;
    if (P.Y < 0) then
      P.Y := MaxInt;
    if (P.X <> FPos.X) or (P.Y <> FPos.Y) then
      begin
        FPos := P;
        if Linked then
          ResetPos;
      end;
  end;
{--------}
procedure TOvcSingleCaret.SetVisible(V : boolean);
  begin
    if (V <> FVisible) then
      begin
        FVisible := V;
        if Linked then
          if Owner.HandleAllocated then
            if FVisible then
              ShowCaret(Owner.Handle)
            else
              HideCaret(Owner.Handle);
      end;
  end;


{---TOvcCaretPair----------------------------------------------------}
constructor TOvcCaretPair.Create(AOwner : TWinControl);
  begin
    inherited Create(AOwner);

    FInsCaretType := TOvcCaret.Create;
    FInsCaretType.Register;

    FOvrCaretType := TOvcCaret.Create;
    FOvrCaretType.Register;
    FOvrCaretType.Shape := csBlock;

    FInsMode := True;

    if FInsMode then
      CaretType := FInsCaretType
    else
      CaretType := FOvrCaretType
  end;

destructor TOvcCaretPair.Destroy;
begin
  FInsCaretType.Deregister;
  FOvrCaretType.Deregister;

  inherited Destroy;
end;

procedure TOvcCaretPair.SetInsMode(IM : boolean);
  begin
    if (IM <> FInsMode) then
      begin
        FInsMode := IM;
        if FInsMode then
             CaretType := FInsCaretType
        else CaretType := FOvrCaretType;
      end;
  end;
{--------}
procedure TOvcCaretPair.SetInsCaretType(ICT : TOvcCaret);
  begin
    if (ICT <> FInsCaretType) then
      begin
        FInsCaretType.Deregister;
        FInsCaretType := ICT;
        FInsCaretType.Register;
        if InsertMode then
          CaretType := FInsCaretType;
      end;
  end;
{--------}
procedure TOvcCaretPair.SetOvrCaretType(OCT : TOvcCaret);
  begin
    if (OCT <> FOvrCaretType) then
      begin
        FOvrCaretType.Deregister;
        FOvrCaretType := OCT;
        FOvrCaretType.Register;
        if not InsertMode then
          CaretType := FOvrCaretType;
      end;
  end;
{--------------------------------------------------------------------}


end.

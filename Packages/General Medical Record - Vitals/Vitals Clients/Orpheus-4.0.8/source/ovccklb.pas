{*********************************************************}
{*                   OVCCKLB.PAS 4.06                    *}
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
{*    Sebastian Zierer (Windows Visual Styles)                                *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovccklb;
  {-Checked ListBox control}

interface

uses
  Types, Windows, Classes, Controls, Forms, Graphics, Menus, Messages, StdCtrls,
  SysUtils, ImgList, OvcBase, OvcData, OvcLB, OvcMisc, Themes;

type
  TOvcCheckStyle = (csCheck, csX);

  TOvcStateChangeEvent = procedure (Sender : TObject; Index : Integer;
    OldState, NewState : TCheckBoxState) of object;

  { - new event}
  TOvcOwnerDrawCheckEvent = procedure(Sender: TObject; Canvas: TCanvas;
    R: TRect; AState: TOwnerDrawState; CheckStyle: TOvcCheckStyle) of object;

  TOvcCheckList = class(TOvcCustomListBox)
  protected {private}
    {property variables}
    FBoxColor       : TColor;         {box background color}
    FBoxClickOnly   : Boolean;        {true for state change in box only}
    FBoxMargin      : Integer;        {margin around the box}
    FCheckStyle     : TOvcCheckStyle; {style of checkbox to use}
    FCheckColor     : TColor;         {color of check or X}
    FGlyphIndex     : TList;          {index to glyph in image list}
    FGlyphs         : TImageList;     {image list containing glyphs}
    FGlyphWidth     : integer;        {width of box plus margin}
    FShowGlyphs     : Boolean;        {true to display glyphs}
    FStates         : TList;          {check state}
    FReadOnly       : Boolean;        {read only}
    FThreeState     : Boolean;        {true to allow grayed as a state}
    FWantDblClicks  : Boolean;        {true to include cs_dblclks style}

    {event variables}
    FOnStateChange  : TOvcStateChangeEvent;
    FOwnerDrawCheck : TOvcOwnerDrawCheckEvent;
    FMultiCheck: Boolean;

    {internal variables}
    clGrayBitmap    : TBitmap;        {gray brush bitmap}
    clDrawBmp       : TBitmap;

    procedure KeyPress(var Key: Char); override;

    function GetGlyphIndex(Index : Integer) : Integer;
    function GetStates(Index : Integer) : TCheckBoxState;
    procedure SetBoxColor(Value : TColor);
    procedure SetBoxMargin(Value : Integer);
    procedure SetGlyphIndex(Index : Integer; AGlyphIndex : Integer);
    procedure SetGlyphs(Value : TImageList);
    procedure SetShowGlyphs(Value : Boolean);
    procedure SetStates(Index : Integer; State : TCheckBoxState);
    procedure SetWantDblClicks(Value : Boolean);
    procedure SetMultiCheck(const Value: Boolean);

    {internal methods}
    procedure InvalidateItem(Index : Integer);

    {windows message response methods}
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMNCHitTest(var Msg : TMessage);
      message WM_NCHITTEST;
    procedure LBAddString(var Msg : TMessage);
      message LB_ADDSTRING;
    procedure LBDeleteString(var Msg : TMessage);
      message LB_DELETESTRING;
    procedure LBResetContent(var Msg: TMessage); message LB_RESETCONTENT;


    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;
    procedure CNDrawItem(var Msg : TWMDrawItem);
      message CN_DRAWITEM;

    //FLabelInfo: TOvcLabelInfo; SZ: careful, Delphi class completion silently adds FLabelInfo, but the inherited FLabelInfo should be used

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure DoOnStateChange(Index : Integer; OldState, NewState : TCheckBoxState);
      dynamic;
    procedure DrawItem(Index : Integer; Rect : TRect; AState : TOwnerDrawState);
      override;
    procedure tlResetHorizontalExtent; override;

    {protected properties}
    property Style;

    procedure LoadRecreateItems(RecreateItems: TStrings); override;
    procedure SaveRecreateItems(RecreateItems: TStrings); override;
  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;
    property Canvas;

    {public methods}
    procedure ChangeStateForAll(NewState : TCheckBoxState);
    procedure ChangeStateForNotSelected(NewState : TCheckBoxState);
    procedure ChangeStateForSelected(NewState : TCheckBoxState);
    function GetStateCount(AState : TCheckBoxState) : Integer;

    {public properties}
    property GlyphIndex[Index : Integer] : Integer
      read GetGlyphIndex write SetGlyphIndex;
    property States[Index : Integer] : TCheckBoxState
      read GetStates write SetStates;

  published
    property AutoComplete;
    property BoxClickOnly : Boolean
      read FBoxClickOnly write FBoxClickOnly
      default True;
    property BoxColor  : TColor
      read FBoxColor write SetBoxColor
      default clWhite;
    property BoxMargin : Integer
      read FBoxMargin write SetBoxMargin
      default 1;
    property CheckColor : TColor
      read FCheckColor write FCheckColor
      default clWindow;
    property CheckStyle : TOvcCheckStyle
      read FCheckStyle write FCheckStyle
      default csCheck;
    property Glyphs : TImageList
      read FGlyphs write SetGlyphs;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;
    property ReadOnly: Boolean
      read FReadOnly write FReadOnly default false;
    property ShowGlyphs : Boolean
      read FShowGlyphs write SetShowGlyphs
      default False;
    property ThreeState : Boolean
      read FThreeState write FThreeState
      default False;
    property WantDblClicks : Boolean
      read FWantDblClicks write SetWantDblClicks
      default True;
    property MultiCheck: Boolean read FMultiCheck write SetMultiCheck default True;

    {events}
    property OnStateChange  : TOvcStateChangeEvent
      read FOnStateChange write FOnStateChange;

    property OwnerDrawCheck: TOvcOwnerDrawCheckEvent
      read FOwnerDrawCheck write FOwnerDrawCheck;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle;
    property Color;
    property Columns;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property HorizontalScroll default False;
    property IntegralHeight;
    property Items;
    property ItemHeight;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property TabStops;
    property Visible;

    {inherited events}
    property OnClick;
    property OnDblClick;
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
    property OnStartDrag;
    property OnTabStopsChange;
  end;

implementation

function ThemesEnabled: Boolean; inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices; inline;
begin
  Result := StyleServices;
end;

type
  TCheckListBoxDataWrapper = class
  private
    FState: TCheckBoxState;
    FObject: TObject;
  public
    property State: TCheckBoxState read FState write FState;
    property Data: TObject read FObject write FObject;
  end;

{ TOvcCheckList }

procedure TOvcCheckList.ChangeStateForAll(NewState : TCheckBoxState);
var
  I : Integer;
begin
  for I := 0 to Items.Count-1 do
    States[I] := NewState;
end;

procedure TOvcCheckList.ChangeStateForNotSelected(NewState : TCheckBoxState);
var
  I : Integer;
begin
  for I := 0 to Items.Count-1 do
    if not Selected[I] then
      States[I] := NewState;
end;

procedure TOvcCheckList.ChangeStateForSelected(NewState : TCheckBoxState);
var
  I : Integer;
begin
  for I := 0 to Items.Count-1 do
    if Selected[I] then
      States[I] := NewState;
end;

procedure TOvcCheckList.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

procedure TOvcCheckList.CNDrawItem(var Msg : TWMDrawItem);
var
  S : TOwnerDrawState;
begin
  with Msg.DrawItemStruct^ do begin
      S := TOwnerDrawState(LongRec(itemState).Lo);

    FGlyphWidth := (rcItem.Right-rcItem.Left + 1 + BoxMargin*2);

    {add checkbox state information}
    if Integer(itemID) > -1 then begin
      case States[itemId] of
        cbUnchecked : S := S - [odChecked, odGrayed];
        cbChecked   : S := S + [odChecked] - [odGrayed];
        cbGrayed    : S := S + [odGrayed] - [odChecked];
      end;
    end;

    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;

    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, S)
    else
      Canvas.FillRect(rcItem);
    Canvas.Handle := 0;
  end;
end;

constructor TOvcCheckList.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Height          := 150;
  Style           := lbOwnerDrawFixed;

  FBoxClickOnly   := True;
  FBoxColor       := clWhite;
  FBoxMargin      := 1;
  FCheckColor     := clWindowText;
  FCheckStyle     := csCheck;
  FShowGlyphs     := False;
  FThreeState     := False;
  FWantDblClicks  := True;
  FMultiCheck     := True;

  FGlyphIndex := TList.Create;
  FStates := TList.Create; {list of check states}

  clGrayBitmap := TBitmap.Create;
  clGrayBitmap.Handle := LoadBaseBitmap('ORGRAYBITMAP');
  clDrawBmp := TBitMap.Create;
end;

procedure TOvcCheckList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  {set style to reflect desire for double clicks}
  if FWantDblClicks then
    ControlStyle := ControlStyle + [csDoubleClicks]
  else
    ControlStyle := ControlStyle - [csDoubleClicks];
end;

destructor TOvcCheckList.Destroy;
begin
  FGlyphIndex.Free;
  FGlyphIndex := nil;

  FStates.Free;
  FStates := nil;

  clGrayBitmap.Free;
  clGrayBitmap := nil;

  clDrawBmp.Free;
  clDrawBmp := nil;

  inherited Destroy;
end;

procedure TOvcCheckList.DoOnStateChange(Index : Integer; OldState, NewState : TCheckBoxState);
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, Index, OldState, NewState);
end;

procedure TOvcCheckList.DrawItem(Index : Integer; Rect : TRect; AState : TOwnerDrawState);
var
  W  : Integer;
  X  : Integer;
  Y  : Integer;
  DY : Integer;
  M  : Integer;
  R  : TRect;
  NR : TRect;
  tmp: string;
  ElementDetails: TThemedElementDetails;
begin
  NR := Classes.Rect(0, 0, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
  clDrawBmp.Width  := NR.Right;
  clDrawBmp.Height := NR.Bottom;
  clDrawBmp.Canvas.Font := Font;
  {set colors and clear area}
  clDrawBmp.Canvas.Font.Color := Font.Color;
  clDrawBmp.Canvas.Brush.Color := Color;
  clDrawBmp.Canvas.FillRect(NR);

  {exit if index is out of range}
  if (Index <= -1) or (Index >= Items.Count) then
    Exit;

  M := BoxMargin;

  {determine width/height of the rectangle}
  W := NR.Bottom - NR.Top - 2*M;

  { Forcing the checkbox width to an odd value causes the interior width }
  { to be an even value, which is contrary to the point                  }
  if {not} Odd(W) then
    Dec(W);

  if ThemesEnabled then
  begin
    if odChecked in AState then
    begin
      if not (odDisabled in AState) then
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal)
      else
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxCheckedDisabled);
    end
    else
    if odGrayed in AState then
    begin
      if not (odDisabled in AState) then
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedNormal)
      else
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxMixedDisabled);
    end
    else
    begin
      if not (odDisabled in AState) then
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedNormal)
      else
        ElementDetails := ThemeServices.GetElementDetails(tbCheckBoxUncheckedDisabled)
    end;

    ThemeServices.DrawElement(clDrawBmp.Canvas.Handle, ElementDetails, Classes.Rect(NR.Left + M, NR.Top + M, NR.Left + M + W, NR.Top + M + W));
  end;

  {draw the box}
  X := NR.Left + M;
  Y := NR.Top + M;
  if not ThemesEnabled then
  begin
    if odGrayed in AState then
      clDrawBmp.Canvas.Brush.Bitmap := clGrayBitmap
    else begin
      clDrawBmp.Canvas.Brush.Bitmap := nil;
      clDrawBmp.Canvas.Brush.Color := FBoxColor;
    end;
    clDrawBmp.Canvas.Pen.Color := RGB(192,204,216);
    clDrawBmp.Canvas.Rectangle(X, Y, X+W, Y+W);
    clDrawBmp.Canvas.Pen.Color := RGB(80,100,128);
    clDrawBmp.Canvas.PolyLine([Point(X,     Y+W-2),
                               Point(X,     Y),
                               Point(X+W-1, Y)]);
    clDrawBmp.Canvas.Pen.Color := clBlack;
    clDrawBmp.Canvas.PolyLine([Point(X+1,   Y+W-3),
                               Point(X+1,   Y+1),
                               Point(X+W-2, Y+1)]);
    clDrawBmp.Canvas.Pen.Color := RGB(128,152,176);
    clDrawBmp.Canvas.PolyLine([Point(X+1,   Y+W-2),
                               Point(X+W-2, Y+W-2),
                               Point(X+W-2, Y)]);
  end;

  { Let the owner draw the check mark }
  if not ThemesEnabled then
  begin
    if Assigned(FOwnerDrawCheck) then begin
      R := Classes.Rect(X + 3, Y + 3, X + W - 3, Y + W - 3);
      FOwnerDrawCheck(self, clDrawBmp.Canvas, R, AState, CheckStyle);
    end else begin
      { draw the check mark or the X }
      clDrawBmp.Canvas.Pen.Color := CheckColor;
      if (odChecked in AState) or (odGrayed in AState) then begin
        R := Classes.Rect(X+3, Y+3, X+W-3, Y+W-3);
        case CheckStyle of
          csX : with clDrawBmp.Canvas do begin
          {X}
            MoveTo(R.Left, R.Top);
            LineTo(R.Right, R.Bottom);
            MoveTo(R.Left, R.Top+1);
            LineTo(R.Right-1, R.Bottom);
            MoveTo(R.Left+1, R.Top);
            LineTo(R.Right, R.Bottom-1);
            MoveTo(R.Left, R.Bottom-1);
            LineTo(R.Right, R.Top-1);
            MoveTo(R.Left, R.Bottom-2);
            LineTo(R.Right-1, R.Top-1);
            MoveTo(R.Left+1, R.Bottom-1);
            LineTo(R.Right, R.Top);
          end;
          csCheck : with clDrawBmp.Canvas do begin
          {check}
            MoveTo(R.Left, R.Bottom-5);
            LineTo(R.Left+3, R.Bottom-2);
            MoveTo(R.Left, R.Bottom-4);
            LineTo(R.Left+3, R.Bottom-1);
            MoveTo(R.Left, R.Bottom-3);
            LineTo(R.Left+3, R.Bottom);
            MoveTo(R.Left+2, R.Bottom-3);
            LineTo(R.Right,  R.Top-1);
            MoveTo(R.Left+2, R.Bottom-2);
            LineTo(R.Right,  R.Top);
            MoveTo(R.Left+2, R.Bottom-1);
            LineTo(R.Right,  R.Top+1);
          end;
        end;
      end;
    end; { if OwnerDrawCheck }
  end;


  {draw glyphs if enabled}
  if FShowGlyphs and (Glyphs <> nil) and (Index < FGlyphIndex.Count) then begin
    if (GlyphIndex[Index] > -1) then
      Glyphs.Draw(clDrawBmp.Canvas, NR.Left + M + W + M,
        NR.Top + ((NR.Bottom - NR.Top) - Glyphs.Height) div 2, GlyphIndex[Index]);
    {adjust width to account for glyph size}
    W := W + M + Glyphs.Width;
  end;

  {draw the item text}
  DY := ((NR.Bottom - NR.Top) - clDrawBmp.Canvas.TextHeight(Items[Index])) div 2;
  Y := NR.Top + DY;
  if odSelected in AState then begin
    clDrawBmp.Canvas.Font.Color := clHighlightText;
    clDrawBmp.Canvas.Brush.Color := clHighlight;
    R := NR;
    Inc(R.Left, M + W + M - 1);
    clDrawBmp.Canvas.FillRect(R);
  end else
    clDrawBmp.Canvas.Brush.Color := Color;
  clDrawBmp.Canvas.Pen.Color := Font.Color;
  tmp := Items[Index];
  if odDisabled in AState then // SZ text should be grayed if item is disabled
    clDrawBmp.Canvas.Font.Color := clGrayText;
  ExtTextOut(clDrawBmp.Canvas.Handle, NR.Left + M + W + M + 1, Y, ETO_CLIPPED,
    @NR, PChar(tmp), Length(tmp), nil);

  {draw the focus rect}
  if odFocused in AState then begin
    R := NR;
    Inc(R.Left, M + W + M - 1);
    clDrawBmp.Canvas.DrawFocusRect(R);
  end;

  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect(Rect, clDrawBmp.Canvas, NR);
end;

function TOvcCheckList.GetGlyphIndex(Index : Integer) : Integer;
begin
  Result := -1;
  if (Index > -1) and (Index < FGlyphIndex.Count) then
    Result := Integer(FGlyphIndex[Index]);
end;

function TOvcCheckList.GetStateCount(AState : TCheckBoxState) : Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Items.Count - 1 do
    if States[I] = AState then
      Inc(Result);
end;

function TOvcCheckList.GetStates(Index : Integer) : TCheckBoxState;
begin
  Result := cbUnchecked;
  if (Index > -1) and (Index < FStates.Count) then
    Result := TCheckBoxState(FStates[Index]);
end;

procedure TOvcCheckList.InvalidateItem(Index : Integer);
var
  R : TRect;
begin
  SendMessage(Handle, LB_GETITEMRECT, Index, NativeInt(@R));
  InvalidateRect(Handle, @R, True);
end;



procedure TOvcCheckList.KeyPress(var Key: Char);
var
  I: Integer;
  State : TCheckBoxState;
  Tmp : TNotifyEvent;
  Toggle: Boolean;
begin
  //SZ: toggle should happen only when pressing space; old behaviour was on every key, but it toggled the previous item not the one that gets focused
  Toggle := (Key = ' '); //  Key is set to #0 in inherited KeyPress

  inherited KeyPress(Key);

  if Toggle and (not ReadOnly)
  and (ItemIndex >= 0)
  and (ItemIndex < Items.Count) then
  begin
    State := Self.States[ItemIndex];
    case State of
      cbUnchecked:
        if ThreeState then
          State := cbGrayed
        else
          State := cbChecked;
      cbChecked: State := cbUnchecked;
      cbGrayed: State := cbChecked;
    end;
    Self.States[ItemIndex] := State;

    if not FMultiCheck then
      for I := 0 to Count - 1 do
        if I <> ItemIndex then
          if States[I] <> cbUnchecked then
            States[I] := cbUnchecked;

    Tmp := OnClick;
    if (Assigned(Tmp)) then
      OnClick(Self);
  end;
end;

procedure TOvcCheckList.SaveRecreateItems(RecreateItems: TStrings);
var
  I: Integer;
  LWrapper: TCheckListBoxDataWrapper;
begin
  with RecreateItems do
  begin
    BeginUpdate;
    try
      NameValueSeparator := Items.NameValueSeparator;
      QuoteChar := Items.QuoteChar;
      Delimiter := Items.Delimiter;
      LineBreak := Items.LineBreak;
      for I := 0 to Items.Count - 1 do
      begin
        LWrapper := TCheckListBoxDataWrapper.Create;
        LWrapper.State := States[I];
        LWrapper.Data := Self.Items.Objects[I];
        AddObject(Items[I], LWrapper);
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TOvcCheckList.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcCheckList.SetBoxColor(Value : TColor);
begin
  if (Value <> FBoxColor) then begin
    FBoxColor := Value;
    Refresh;
  end;
end;

procedure TOvcCheckList.SetBoxMargin(Value : Integer);
begin
  if (Value <> FBoxMargin) and (Value > 0) and (ItemHeight - 2*Value > 0) then begin
    FBoxMargin := Value;
    Refresh;
  end;
end;

procedure TOvcCheckList.SetGlyphIndex(Index : Integer; AGlyphIndex : Integer);
var
  I : Integer;
begin
  if (Index > -1) and (Index < Items.Count) then begin
    {expand glyph index list to be same size as item list}
    if FGlyphIndex.Count < Items.Count then
      for I := FGlyphIndex.Count to Items.Count do
        FGlyphIndex.Add(Pointer(-1));
    FGlyphIndex[Index] := TObject(AGlyphIndex);
    InvalidateItem(Index);
  end;
end;

procedure TOvcCheckList.SetGlyphs(Value : TImageList);
begin
  if Value <> FGlyphs then begin
    FGlyphs := Value;
    Invalidate;
  end;
end;

procedure TOvcCheckList.SetMultiCheck(const Value: Boolean);
begin
  FMultiCheck := Value;
end;

procedure TOvcCheckList.SetShowGlyphs(Value : Boolean);
begin
  if (Value <> FShowGlyphs) then begin
    FShowGlyphs := Value;
    Refresh;
  end;
end;

procedure TOvcCheckList.SetStates(Index : Integer; State : TCheckBoxState);
var
  I        : Integer;
  OldState : TCheckBoxState;
begin
  if (Index > -1) and (Index < Items.Count) then begin
    {expand state list to be same size as item list}
    if FStates.Count < Items.Count then
      for I := FStates.Count to Items.Count do
        FStates.Add(nil);
    OldState := TCheckBoxState(FStates[Index]);
    FStates[Index] := TObject(State);
    InvalidateItem(Index);
    DoOnStateChange(Index, OldState, State);
  end;
end;

procedure TOvcCheckList.SetWantDblClicks(Value : Boolean);
begin
  if Value <> FWantDblClicks then begin
    FWantDblClicks := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCheckList.tlResetHorizontalExtent;
var
  I : Integer;
  W : Integer;
  X : Integer;
begin
  if not FHorizontalScroll then
    Exit;

  X := 0;
  for I := 0 to Items.Count - 1 do begin
    W := tlGetItemWidth(I);
    if W > X then
      X := W;
  end;
  {When the control is first displayed, FGlyphWidth has not been set}
  {Force a size for now}
  if (FGlyphWidth = 0) then begin
    if (ShowGlyphs) and (FGlyphs.Count > 0) then
      FGlyphWidth := FGlyphs.Width
    else
      FGlyphWidth := 16;
  end else
    FGlyphWidth := 16;
  X := X + 5 + FGlyphWidth;
  SendMessage(Handle, LB_SETHORIZONTALEXTENT, X, 0);
end;



procedure TOvcCheckList.WMLButtonDown(var Msg : TWMLButtonDown);
var
  I, J : Integer;
  P : TPoint;
  R : TRect;
begin
  P.X := Msg.XPos;
  P.Y := Msg.YPos;
  I := ItemAtPos(P, True);
  FillChar(R, SizeOf(R), 0);
  if I > -1 then
    SendMessage(Handle, LB_GETITEMRECT, I, NativeInt(@R));

  {eat click if clicking on the check box}
  if (Msg.XPos > R.Left + ItemHeight - BoxMargin div 2) then begin
    if not ReadOnly then
      inherited;
  end else
    InvalidateRect(Handle, @R, True);

  if not FReadOnly and (I > -1) then
  begin
    if (not FBoxclickOnly) or ((Msg.XPos >= R.Left) and
       (Msg.XPos <= R.Left + ItemHeight - BoxMargin div 2)) then
    begin
      case States[I] of
        cbUnchecked : if FThreeState then
                        States[I] := cbGrayed
                      else
                        States[I] := cbChecked;
        cbGrayed    : States[I] := cbChecked;
        cbChecked   : States[I] := cbUnchecked;
      end;
      // if MultiCheck is not enabled uncheck other items
      if not FMultiCheck then
        for J := 0 to Count - 1 do
          if J <> I then
            if States[J] <> cbUnchecked then
              States[J] := cbUnchecked;
    end;
    inherited;
  end;
end;

procedure TOvcCheckList.WMNCHitTest(var Msg : TMessage);
begin
  if (csDesigning in ComponentState) then
    DefaultHandler(Msg)
  else
    inherited;
end;

procedure TOvcCheckList.LBAddString(var Msg : TMessage);
begin
  inherited;
  FStates.Insert(Msg.Result, nil);
  if HorizontalScroll then
    ResetHorizontalScrollBar;
end;

procedure TOvcCheckList.LBDeleteString(var Msg : TMessage);
begin
  FStates.Delete(Msg.wParam);
  inherited;
  if HorizontalScroll then
    ResetHorizontalScrollBar;
end;

procedure TOvcCheckList.LBResetContent(var Msg: TMessage);
begin
  FStates.Clear;
  inherited;
  if HorizontalScroll then
    ResetHorizontalScrollBar;
end;

procedure TOvcCheckList.LoadRecreateItems(RecreateItems: TStrings);
var
  I: Integer;
begin
  with RecreateItems do
  begin
    BeginUpdate;
    try
      Items.NameValueSeparator := NameValueSeparator;
      Items.QuoteChar := QuoteChar;
      Items.Delimiter := Delimiter;
      Items.LineBreak := LineBreak;
      for I := 0 to Count - 1 do
      begin
        Items.AddObject(RecreateItems[I], (RecreateItems.Objects[I] as TCheckListBoxDataWrapper).Data);
        if Objects[I] <> nil then
          States[I] := (RecreateItems.Objects[I] as TCheckListBoxDataWrapper).State;
        Objects[I].Free;
        Objects[I] := nil;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

end.

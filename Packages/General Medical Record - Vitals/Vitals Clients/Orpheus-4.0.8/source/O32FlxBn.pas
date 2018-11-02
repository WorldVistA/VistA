{*********************************************************}
{*                   O32FLXBN.PAS 4.06                   *}
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
{$J+} {Writable constants}

unit o32flxbn;
  {O32FlexButton and associated support classes...}

interface

uses
  UITypes, Types, Windows, Controls, Messages, Buttons, Graphics, Classes,
  OvcBase, OvcVer, Grids, StdCtrls, O32MouseMon, OvcMisc;

type
  {forward declarations}
  TO32CustomFlexButton = class;

  TO32FlexButtonPopPosition = (ppBottomLeft, ppBottomRight, ppTopLeft,
                               ppTopRight);

  TO32FlexButtonItemEvent =
    procedure(Sender: TObject; Item: Integer) of object;

  TO32FlexButtonItemChangeEvent =
    procedure(Sender: TObject; var OldItem, NewItem: Integer) of object;

  TO32FlxBtnPopMenu = class(TDrawGrid)
  protected {private}
    FFlexButton: TO32CustomFlexButton;
    FBGColor: TColor;
    {internal methods}
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect;
                       AState: TGridDrawState); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CreateWnd; override;
    {message handlers}
    procedure CMMouseEnter (var Message : TMessage);  message CM_MOUSEENTER;
    procedure CMMouseLeave (var Message : TMessage);  message CM_MOUSELEAVE;
    procedure CMGotFocus   (var Message : TMessage);  message WM_SETFOCUS;
    procedure CMLostFocus  (var Message : TMessage);  message WM_KILLFOCUS;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BGColor: TColor read FBGColor write FBGColor;
  end;

  TO32FlexButtonItem = class(TO32CollectionItem)
  protected {private}
    FFlexButton : TO32CustomFlexButton;
    FGlyph      : TBitmap;
    FLayout     : TButtonLayout;
    {property methods}
    procedure SetLayout(Value: TButtonLayout);
    procedure SetCaption(const Value: String);
    function GetCaption: String;
    procedure SetGlyph(Value: TBitmap);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Caption: String read GetCaption write SetCaption;
    property BtnLayout: TButtonLayout read FLayout write SetLayout;
    property Glyph: TBitmap read FGlyph write SetGlyph;
  end;

  TO32FlexButtonItems = class(TO32Collection)
  protected
    FFlexButton: TO32CustomFlexButton;
  public
    function AddItem(const Name, Caption: String;
                 Glyph: TBitmap): TO32FlexButtonItem; dynamic;
  end;

  TO32CustomFlexButton = class(TBitBtn)
  protected {private}
    {property variables}
    FCanvas          : TCanvas;
    FItems           : TO32FlexButtonItems;
    FSmartPop        : Boolean;
    FActiveItem      : Integer;
    FPopGlyph        : TBitmap;
    FPopRect         : TRect;
    FPopPosition     : TO32FlexButtonPopPosition;
    FPopAreaSize     : Integer;
    FPopupMenu       : TO32FlxBtnPopMenu;
    FPopRowCount     : Integer;
    FPopWidth        : Integer;
    FMenuActive      : Boolean;
    FMenuColor       : TColor;
    FMouseInMenu     : Boolean;
    FMenuFocused     : Boolean;
    FWheelSelection  : Boolean;
    {event variables}
    FOnClick         : TO32FlexButtonItemEvent;
    FOnMenuPop       : TNotifyEvent;
    FOnMenuClick     : TO32FlexButtonItemChangeEvent;
    FOnItemChange    : TO32FlexButtonItemChangeEvent;
    {Internal Variables}
    fbPopupClicked   : Boolean;

    {message handlers}
    procedure CMLostFocus  (var Message : TMessage);     message WM_KILLFOCUS;

{ - HWnd changed to TOvcHWnd for BCB Compatibility}
    procedure MouseMonitor(const MouseMessage: Integer;
                           const wParam, lParam: Integer;
                           const ScreenPt: TPoint;
                           const MouseWnd: TOvcHwnd{hWnd});
    procedure CNDrawItem   (var Message: TWMDrawItem);   message CN_DRAWITEM;

    {property methods}
    function GetAbout : string;
    function GetItem(Value: Integer): TO32FlexButtonItem;
    function GetMenuColor: TColor;
    procedure SetAbout(const Value : string);
    procedure SetItem(Value: Integer; const Item: TO32FlexButtonItem);
    procedure SetMenuColor(Value: TColor);
    procedure SetPopGlyph(Value: TBitmap);
    procedure SetSelection(Value: Integer);
    procedure SetPopPosition(Value: TO32FlexButtonPopPosition);
    procedure SetWheelSelection(Value: Boolean);
    procedure DoMenuClick(Selection: Integer);
    {internal methods}
    procedure MouseInMenu(Value: Boolean);
    procedure MenuFocused(Value: Boolean);
    procedure IncrementItem;
    procedure DecrementItem;
    procedure DrawPopGlyph(const DrawItemStruct: TDrawItemStruct);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PopMenuOpen;
    procedure PopMenuClose;
    procedure Click; override;
    {properties}
    property About : string
      read GetAbout write SetAbout stored False;
    property ActiveItem: Integer
      read FActiveItem write SetSelection;
    property Items[Index: Integer]: TO32FlexButtonItem
      read GetItem write SetItem;
    property ItemCollection: TO32FlexButtonItems
      read FItems write FItems;
    property MenuColor: TColor
      read GetMenuColor write SetMenuColor;
    property PopPosition: TO32FlexButtonPopPosition
      read FPopPosition write SetPopPosition;
    property PopAreaSize: Integer
      read FPopAreaSize write FPopAreaSize;
    property PopGlyph: TBitmap
      read FPopGlyph write SetPopGlyph;
    property PopRowCount: Integer
      read FPopRowCount write FPopRowCount;
    property PopWidth: Integer
      read FPopWidth write FPopWidth;
    property SmartPop: Boolean
      read FSmartPop write FSmartPop;
    property WheelSelection: Boolean
      read FWheelSelection write SetWheelSelection;
    property OnClick: TO32FlexButtonItemEvent
      read FOnClick write FOnClick;
    property OnMenuPop: TNotifyEvent
      read FOnMenuPop write FOnMenuPop;
    property OnMenuClick  : TO32FlexButtonItemChangeEvent
      read FOnMenuClick write FOnMenuClick;
    property OnItemChange : TO32FlexButtonItemChangeEvent
      read FOnItemChange write FOnItemChange;
  end;

  TO32FlexButton = class(TO32CustomFlexButton)
  published
    property About;
    property ActiveItem default -1;
    property ItemCollection;
    property WheelSelection; {default True;}
    property MenuColor;
    property PopPosition default ppBottomRight;
    property PopRowCount default 5;
    property PopWidth default 125;
    property SmartPop default True;
    property OnClick;
    property OnMenuPop;
    property OnMenuClick;
    property OnItemChange;
  end;

implementation

uses
  SysUtils;

{*** TO32FlexButtonItems *********************************************}

function TO32FlexButtonItems.AddItem(const Name, Caption: String;
                                Glyph: TBitmap): TO32FlexButtonItem;
var
  NewItem: TO32FlexButtonItem;
begin
  TO32CollectionItem(NewItem) := Add;
  NewItem.FFlexButton := FFlexButton;
  NewItem.Name := Name;
  NewItem.Glyph.Assign(Glyph);
  NewItem.Caption := Caption;
  result := NewItem;

  {If this is the only item then make it active}
  if Count = 1 then
    FFlexButton.ActiveItem := 0;
end;

{*** TO32FlexButtonItem **********************************************}

constructor TO32FlexButtonItem.Create(Collection: TCollection);

begin
  inherited Create(Collection);
  FGlyph := TBitmap.Create;
  FFlexButton := TO32FlexButtonItems(Collection).FFlexButton;
end;
{=====}

destructor TO32FlexButtonItem.Destroy;
begin
  FGlyph.Free;
  inherited Destroy;
end;
{=====}

procedure TO32FlexButtonItem.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then begin
    FLayout := Value;
    FFlexButton.Invalidate;
  end;
end;
{=====}

procedure TO32FlexButtonItem.SetCaption(const Value: String);
begin
  DisplayText := Value;
end;
{=====}

function TO32FlexButtonItem.GetCaption: String;
begin
  result := DisplayText;
end;
{=====}

procedure TO32FlexButtonItem.SetGlyph(Value: TBitmap);
begin
  if FGlyph <> Value then begin
    FGlyph.Assign(Value);
    if FFlexButton.ActiveItem = Index then
      FFlexButton.Glyph := FGlyph;
  end;
end;
{=====}

{***** TO32FlxBtnPopMenu *********************************************}

constructor TO32FlxBtnPopMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColCount := 1;
//  Color := clMenu;
  FixedCols := 0;
  FixedRows := 0;
  Options := [goDrawFocusSelected];
  DefaultRowHeight := 23;
  ScrollBars := ssNone;
  TabStop := false;
end;
{=====}

destructor TO32FlxBtnPopMenu.Destroy;
begin
  inherited Destroy;
end;
{=====}

procedure TO32FlxBtnPopMenu.DrawCell(ACol, ARow: Integer; ARect: TRect;
                                     AState: TGridDrawState);
var
  TmpImage: TBitmap;
  IWidth, IHeight: Integer;
  Glyphs: Integer;
  IRect: TRect;
  TransparentColor, BackgroundColor : TColor;
  r, c: Integer;
begin
  Color := BGColor;
  TmpImage := TBitmap.Create;
  IWidth := FFlexButton.Items[ARow].Glyph.Width;
  IHeight := FFlexButton.Items[ARow].Glyph.Height;
  TmpImage.TransparentMode := tmFixed;
  TransparentColor := FFlexButton.Items[ARow].Glyph.Canvas.Pixels[0, IHeight - 1];
  try
    if  (FFlexButton.Items[ARow].Glyph <> nil)
    and (FFlexButton.Items[ARow].Glyph.Height > 0) then
    begin
      if IWidth mod IHeight = 0 then
      begin
        Glyphs := IWidth div IHeight;
        if Glyphs > 1 then begin
          TmpImage.Width := IHeight;
          TmpImage.Height := IHeight;
          IRect := Rect(0, 0, IHeight, IHeight);
          TmpImage.Canvas.Brush.Color := BGColor {clBtnFace};
          TmpImage.Palette := CopyPalette(FFlexButton.Items[ARow].Glyph.Palette);
          TmpImage.Canvas.CopyRect(IRect, FFlexButton.Items[ARow].Glyph.Canvas,
            IRect);

          {Convert transparent pixels to the menu's background color}
          if (gdSelected in AState) then  {gdSelected, gdFixed, gdFocused}
            BackgroundColor := clHighlight
          else
            BackgroundColor := BGColor; {clMenu;}

          for r := 0 to IHeight do
            for c := 0 to IHeight - 1 do
              if TmpImage.Canvas.Pixels[c, r] = TransparentColor then
                TmpImage.Canvas.Pixels[c, r] := BackgroundColor;
        end;
      end else
        TmpImage.Assign(FFlexButton.Items[ARow].Glyph);
    end;

    Canvas.Draw(ARect.Left, ARect.Top, TmpImage);
    Canvas.TextOut(ARect.Left + DefaultRowHeight, ARect.Top,
      FFlexButton.Items[ARow].Caption);
  finally
    TmpImage.Free;
  end;
end;
{=====}

procedure TO32FlxBtnPopMenu.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  FFlexButton.MouseInMenu(true);
  SetFocus;
end;
{=====}

procedure TO32FlxBtnPopMenu.CMMouseEnter(var Message : TMessage);
begin
  FFlexButton.MouseInMenu(true);
end;
{=====}

procedure TO32FlxBtnPopMenu.MouseDown(Button: TMouseButton; Shift: TShiftState;
 X, Y: Integer);
var
  C, R: Integer;
begin
  MouseToCell(X, Y, C, R);
  if R > -1 then
    FFlexButton.DoMenuClick(R);
end;
{=====}

procedure TO32FlxBtnPopMenu.CreateWnd;
var
  Hgt, vCnt: Integer;
begin
  inherited;
  if FFlexButton.FItems.Count <= FFlexButton.PopRowCount then
    vCnt := FFlexButton.FItems.Count
  else
    vCnt := FFlexButton.PopRowCount;

  ClientWidth := DefaultColWidth;
  hgt := DefaultRowHeight * vCnt;
  ClientHeight := hgt;
end;
{=====}

procedure TO32FlxBtnPopMenu.CMMouseLeave(var Message : TMessage);
begin
  FFlexButton.MouseInMenu(false);
end;
{=====}

procedure TO32FlxBtnPopMenu.CMGotFocus(var Message : TMessage);
begin
  FFlexButton.MenuFocused(true);
end;
{=====}

procedure TO32FlxBtnPopMenu.CMLostFocus(var Message : TMessage);
begin
  FFlexButton.MenuFocused(false);
end;
{=====}

{*** TO32CustomFlexButton ********************************************}

constructor TO32CustomFlexButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TO32FlexButtonItems.Create(self, TO32FlexButtonItem);
  FItems.FFlexButton := self;
  FMenuColor := clBtnFace;
  fbPopupClicked := false;
  FPopRowCount := 5;
  FPopWidth := 125;
  FSmartPop := true;
  Width := 100;
  FPopPosition := ppBottomRight;
  FActiveItem := -1;
  FMenuActive := false;
  FPopGlyph := TBitmap.Create;
  FCanvas := TCanvas.Create;
  FPopAreaSize := 10;
  FWheelSelection := true;
end;
{=====}

destructor TO32CustomFlexButton.Destroy;
begin
  StopMouseMonitor(MouseMonitor);
  FItems.Free;
  FPopGlyph.Free;
  FCanvas.Free;
  inherited Destroy;
end;
{=====}

function TO32CustomFlexButton.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

function TO32CustomFlexButton.GetItem(Value: Integer): TO32FlexButtonItem;
begin
  result := TO32FlexButtonItem(FItems.Item[Value]);
end;
{=====}

function TO32CustomFlexButton.GetMenuColor: TColor;
begin
  Result := FMenuColor;
end;
{=====}

procedure TO32CustomFlexButton.SetAbout(const Value : string);
begin
  {Leave empty}
end;
{=====}

procedure TO32CustomFlexButton.SetItem(Value: Integer;
                                       const Item: TO32FlexButtonItem);
begin
  FItems.Item[Value] := Item;
end;
{=====}

procedure TO32CustomFlexButton.SetMenuColor(Value: TColor);
begin
  FMenuColor := Value;
  if FPopupMenu <> nil then
    FPopupMenu.BGColor := FMenuColor;
end;
{=====}

procedure TO32CustomFlexButton.SetPopGlyph(Value: TBitmap);
begin
  if FPopGlyph <> Value then
    FPopGlyph.Assign(Value);
    Invalidate;
end;
{=====}

procedure TO32CustomFlexButton.PopMenuOpen;
var
  BtnTopLeft: TPoint;
begin
  if (not FMenuActive) and (FItems.Count > 0) then begin
    FMenuActive := true;
    FPopupMenu := TO32FlxBtnPopMenu.Create(Owner);
    FPopupMenu.Visible := false;
    FPopupMenu.BGColor := FMenuColor;
    FPopupMenu.Parent := GetImmediateParentForm(self);
    FPopupMenu.FFlexButton := Self;
    FPopupMenu.RowCount := FItems.Count;
    FPopupMenu.DefaultColWidth := FPopWidth;
    BtnTopLeft := Point(Left, Top);

    BtnTopLeft := FPopupMenu.ScreenToClient(
      Self.Parent.ClientToScreen(BtnTopLeft));

    case FPopPosition of
      ppBottomLeft: begin
        FPopupMenu.Left := BtnTopLeft.x + 2;
        FPopupMenu.Top := BtnTopLeft.y + Height + 2;
        { if the menu extends below the bottom of the form then display it at }
        { the top of the button }
        if SmartPop then
          if FPopupMenu.Top + FPopupMenu.Height
          > FPopupMenu.Parent.Height then
            FPopupMenu.Top := BtnTopLeft.y - FPopupMenu.Height + 2;
      end;

      ppBottomRight: begin
        FPopupMenu.Left
          := (BtnTopLeft.x + Width) - FPopupMenu.DefaultColWidth - 2;
        FPopupMenu.Top := BtnTopLeft.y + Height + 2;
        { if the menu extends below the bottom of the form then display it at }
        { the top of the button }
        if SmartPop then
          if FPopupMenu.Top + FPopupMenu.Height
          > FPopupMenu.Parent.Height then
            FPopupMenu.Top := BtnTopLeft.y - FPopupMenu.Height + 2;
      end;

      ppTopRight: begin
        FPopupMenu.Left
          := (BtnTopLeft.x + Width) - FPopupMenu.DefaultColWidth - 2;
        FPopupMenu.Top := BtnTopLeft.y - FPopupMenu.Height + 2;
        { if the menu extends above the top of the form then display it at }
        { the bottom of the button }
        if SmartPop then
          if FPopupMenu.Top < 0 then
            FPopupMenu.Top := BtnTopLeft.y + Height + 2;
      end;

      ppTopLeft: begin
        FPopupMenu.Left := BtnTopLeft.x + 2;
        FPopupMenu.Top := BtnTopLeft.y - FPopupMenu.Height + 2;
        { if the menu extends above the top of the form then display it at }
        { the bottom of the button }
        if SmartPop then
          if FPopupMenu.Top < 0 then
            FPopupMenu.Top := BtnTopLeft.y + Height + 2;
      end;

    end;
    FPopupMenu.Visible := true;
    FPopupMenu.Row := FActiveItem;
  end;
end;
{=====}

procedure TO32CustomFlexButton.PopMenuClose;
begin
  if FMenuActive then begin
    FMenuActive := false;
    FPopupMenu.Free;
    FPopupMenu := nil;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomFlexButton.Click;
begin
  if (not fbPopupClicked) and (FActiveItem > -1) and Assigned(FOnClick) then
  begin
    FOnClick(Self, FActiveItem);
    inherited Click;
  end
  else
    fbPopupClicked := false;
end;
{=====}

procedure TO32CustomFlexButton.SetSelection(Value: Integer);
var
  OldItem: Integer;
begin
  if Value <= ItemCollection.Count - 1 then begin
    if FActiveItem <> Value then begin
      OldItem := FActiveItem;
      if Assigned(FOnMenuClick) then
        FOnMenuClick(Self, FActiveItem, Value);
      if (Value <> -1) then begin
        FActiveItem := Value;
        Caption := Items[Value].Caption;
        Glyph := Items[Value].Glyph;
        Layout := Items[Value].BtnLayout;
      end;
      if (not (csLoading in ComponentState))
      and Assigned(FOnItemChange) then
        FOnItemChange(self, OldItem, Value);
    end;
  end;
  PopMenuClose;
end;
{=====}

procedure TO32CustomFlexButton.SetPopPosition(Value: TO32FlexButtonPopPosition);
begin
  if Value <> FPopPosition then begin
    FPopPosition := Value;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomFlexButton.SetWheelSelection(Value: Boolean);
begin
  if FWheelSelection = Value then
    Exit;
  FWheelSelection := Value;
  if not (csDesigning in ComponentState) then begin
    if Value then
      StartMouseMonitor(MouseMonitor)
    else
      StopMouseMonitor(MouseMonitor);
  end;
end;
{=====}

procedure TO32CustomFlexButton.DoMenuClick(Selection: Integer);
begin
  if Assigned(FOnMenuClick) and (FActiveItem <> Selection) then
    FOnMenuClick(Self, FActiveItem, Selection);

  SetSelection(Selection);
end;
{=====}

procedure TO32CustomFlexButton.MouseInMenu(Value: Boolean);
begin
  if FMouseInMenu <> Value then
    FMouseInMenu := Value;
end;
{=====}

procedure TO32CustomFlexButton.MenuFocused(Value: Boolean);
begin
  if FMenuFocused <> Value then begin
    FMenuFocused := Value;
    if not FMenuFocused and not Focused then
      PopMenuClose;
  end;
end;
{=====}

procedure TO32CustomFlexButton.CMLostFocus(var Message : TMessage);
begin
  if (not FMenuFocused) and (not FMouseInMenu) then
    PopMenuClose;
end;
{=====}

{ - HWnd changed to TOvcHWnd for BCB Compatibility}
procedure TO32CustomFlexButton.MouseMonitor(const MouseMessage: Integer;
                                            const wParam, lParam: Integer;
                                            const ScreenPt: TPoint;
                                            const MouseWnd: TOvcHWnd{hWnd});
var
  Pt: TPoint;
begin
  if MouseMessage = WM_MOUSEWHEEL then begin
    Pt := ScreenPt;
    Windows.ScreenToClient(Self.Handle, Pt);
    if PtInRect(Self.ClientRect, pt) then
      if wParam <= 0 then
        IncrementItem
      else
        DecrementItem;
  end;
end;
{=====}

procedure TO32CustomFlexButton.CNDrawItem(var Message: TWMDrawItem);
begin
  inherited;
  DrawPopGlyph(Message.DrawItemStruct^);
end;
{=====}

procedure TO32CustomFlexButton.DrawPopGlyph(const DrawItemStruct: TDrawItemStruct);
var
  R, StateRect: TRect;
  TmpColor: TColor;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  R := ClientRect;
  InflateRect(R, -1, -1);

  {Build the rect}
  case FPopPosition of
    ppBottomLeft  : begin
      FPopRect.Left := R.Left + 1;
      FPopRect.Right := R.Left + PopAreaSize + 1;
      FPopRect.Top := R.Bottom - PopAreaSize - 1;
      FPopRect.Bottom := R.Bottom - 1;
    end;

    ppBottomRight : begin
      FPopRect.Left := R.Right - PopAreaSize - 1;
      FPopRect.Right := R.Right - 1;
      FPopRect.Top := R.Bottom - PopAreaSize - 1;
      FPopRect.Bottom := R.Bottom - 1;
    end;

    ppTopLeft     : begin
      FPopRect.Left := R.Left + 1;
      FPopRect.Right := R.Left + PopAreaSize;
      FPopRect.Top := R.Top + 1;
      FPopRect.Bottom := R.Top + PopAreaSize;
    end;

    ppTopRight    : begin
      FPopRect.Left := R.Right - PopAreaSize - 1;
      FPopRect.Right := R.Right - 1;
      FPopRect.Top := R.Top + 1;
      FPopRect.Bottom := R.Top + PopAreaSize + 1;
    end;
  end;

  if Enabled then begin
    if FMenuActive then
      {Enabled "-"}
      StateRect := Rect(FPopGlyph.Height * 2, 0, FPopGlyph.Height * 3,
        FPopGlyph.Height)
    else
      {Enabled "+"}
      StateRect := Rect(0, 0, FPopGlyph.Height, FPopGlyph.Height);
  end else
    {Disabled "+"}
    StateRect := Rect(FPopGlyph.Height, 0, FPopGlyph.Height * 2,
      FPopGlyph.Height);

  if FPopGlyph.Height > 0 then begin
    {Paint the PopGlyph}
    FCanvas.CopyRect(FPopRect, FPopGlyph.Canvas, StateRect);

  end else begin
    {Paint a default image}

    {Make the PopRect an odd width and height so that the little + and - don't
     look offset}
    if ((FPopRect.Right - FPopRect.Left) mod 2) = 0 then
      Dec(FPopRect.Right);
    if((FPopRect.Bottom - FPopRect.Top) mod 2) = 0 then
      Dec(FPopRect.Bottom);

    if Enabled then begin
      FCanvas.Pen.Color := clBlack;
      FCanvas.Brush.Color := clWhite;
    end
    else begin
      FCanvas.Pen.Color := clInactiveCaption;
      FCanvas.Brush.Color := clBtnFace;
    end;

    {Draw the square}
    FCanvas.FillRect(FPopRect);
    TmpColor := FCanvas.Brush.Color;
    FCanvas.Brush.Color := FCanvas.Pen.Color;
    FCanvas.FrameRect(FPopRect);
    FCanvas.Brush.Color := TmpColor;

    {Draw a minus in the square}
    FCanvas.MoveTo(FPopRect.Left + 2, FPopRect.Top
      + (FPopRect.Bottom - FPopRect.Top) div 2);
    FCanvas.LineTo(FPopRect.Right - 2, FPopRect.Top
      + (FPopRect.Bottom - FPopRect.Top) div 2);

    if not FMenuActive then begin
    {Draw the vertical part of the plus}
      FCanvas.MoveTo(FPopRect.Left + ((FPopRect.Right - FPopRect.Left) div 2),
        FPopRect.Top + 2);
      FCanvas.LineTo(FPopRect.Left + ((FPopRect.Right - FPopRect.Left) div 2),
        FPopRect.Bottom - 2);
    end;
  end;
  FCanvas.Handle := 0;
end;
{=====}

procedure TO32CustomFlexButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (X >= FPopRect.Left) and (X <= FPopRect.Right)
    and (Y >= FPopRect.Top) and (Y <= FPopRect.Bottom) then
  begin
    fbPopupClicked := true;
    if FMenuActive then
      PopMenuClose
    else
      PopMenuOpen;
  end else begin
    fbPopupClicked := false;
    inherited;
  end;
end;
{=====}

procedure TO32CustomFlexButton.Loaded;
begin
  if (ItemCollection.Count > 0) and (ActiveItem = -1) then
    ActiveItem := 0;
  if FPopupMenu <> nil then
    FPopupMenu.BGColor := FMenuColor;
{Fix for problem 673218 and 1093481, exclude code from D3 that do not
 support mousewheel operations. Fix provided by marcus fuchs}
  if WheelSelection and (not (csDesigning in ComponentState)) then
      StartMouseMonitor(MouseMonitor);
  inherited;
end;
{=====}

procedure TO32CustomFlexButton.DecrementItem;
begin
  if FItems.Count > 0 then begin
    if ActiveItem = 0 then
      {Wrap to top}
      ActiveItem := FItems.Count - 1
    else
      {Decrement Selection}
      ActiveItem := ActiveItem - 1;
  end;
end;
{=====}

procedure TO32CustomFlexButton.IncrementItem;
begin
  if FItems.Count > 0 then begin
    if ActiveItem = FItems.Count - 1 then
      {Wrap to bottom}
      ActiveItem := 0
    else
      {Decrement Selection}
      ActiveItem := ActiveItem + 1;
  end;
end;

end.

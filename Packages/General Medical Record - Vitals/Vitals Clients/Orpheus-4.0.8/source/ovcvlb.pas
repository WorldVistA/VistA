{*********************************************************}
{*                   OVCVLB.PAS 4.08                     *}
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

{$I Ovc.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}
{$Q-} {Arithmatic-Overflow Checking}

unit ovcvlb;
  {-Virtual list box component}

interface

uses
  Windows, Classes, Controls, Forms, Graphics, StdCtrls, Menus, Messages, Types,
  SysUtils, OvcBase, OvcData, OvcCmd, OvcConst, OvcMisc, OvcExcpt, OvcColor, UITypes;

const
  vlbMaxTabStops = 128;             {maximum number of tab stops}

const
  {default property values}
  vlDefAutoRowHeight   = True;
  vlDefAlign           = alNone;
  vlDefBorderStyle     = bsSingle;
  vlDefColor           = clWindow;
  vlDefColumns         = 255;
  vlDefCtl3D           = True;
  vlDefHeaderBack      = clBtnFace;
  vlDefHeaderText      = clBtnText;
  vlDefHeight          = 150;
  vlDefIntegralHeight  = True;
  vlDefItemIndex       = -1;
  vlDefMultiSelect     = False;
  vlDefNumItems        = MaxLongInt;
  vlDefOwnerDraw       = False;
  vlDefParentColor     = False;
  vlDefParentCtl3D     = True;
  vlDefParentFont      = True;
  vlDefProtectBack     = clRed;
  vlDefProtectText     = clWhite;
  vlDefRowHeight       = 17;
  vlDefScrollBars      = ssVertical;
  vlDefSelectBack      = clHighlight;
  vlDefSelectText      = clHighlightText;
  vlDefShowHeader      = False;
  vlDefTopIndex        = 0;
  vlDefTabStop         = True;
  vlDefUseTabStops     = False;
  vlDefWidth           = 100;

type
  TCharToItemEvent =
    procedure(Sender : TObject; Ch : Char; var Index : Integer)
    of object;
    {-event to notify caller of a key press and return new item index}
  TDrawItemEvent =
    procedure(Sender : TObject; Index : Integer; Rect : TRect; const S : string)
    of object;
    {-event to allow user to draw the cell items}
  TGetItemEvent =
    procedure(Sender : TObject; Index : Integer; var ItemString : string)
    of object;
    {-event to get string to display}
  TGetItemColorEvent =
    procedure(Sender : TObject; Index : Integer; var FG, BG : TColor)
    of object;
    {-event to get color of the item cell}
  TGetItemStatusEvent =
    procedure(Sender : TObject; Index : Integer; var Protect : Boolean)
    of object;
    {-event to get the protected status item cell}
  THeaderClickEvent =
    procedure(Sender : TObject; Point : TPoint)
    of object;
    {-event to notify of a mouse click in the header area}
  TIsSelectedEvent =
    procedure(Sender : TObject; Index : Integer; var Selected : Boolean)
    of object;
    {-event to get the current selection status from the user}
  TSelectEvent =
    procedure(Sender : TObject; Index : Integer; Selected : Boolean)
    of object;
    {-event to notify of a selection change}
  TTopIndexChanged =
    procedure(Sender : TObject; NewTopIndex : Integer)
    of object;
    {-event to notify when the top index changes}

type
  TTabStopArray = array[0..vlbMaxTabStops] of Integer;
  TBuffer = array[0..255] of Char;

type
  TOvcCustomVirtualListBox = class(TOvcCustomControlEx)

  protected {private}
    {property variables}
    FItemIndex         : Integer;     {selected item}
    FAutoRowHeight     : Boolean;     {true to handle row height calc}
    FBorderStyle       : TBorderStyle;{border style to use}
    FColumns           : Integer;        {number of char columns}
    FFillColor         : TColor;
    FHeader            : string;      {the column header}
    FHeaderColor       : TOvcColors;  {header line colors}
    FIntegralHeight    : Boolean;     {adjust height based on font}
    FMultiSelect       : Boolean;     {allow multiple selections}
    FNumItems          : Integer;     {total number of items}
    FOwnerDraw         : Boolean;     {true if user will draw rows}
    FProtectColor      : TOvcColors;  {protected item colors}
    FRowHeight         : Integer;     {height of one row}
    FScrollBars        : TScrollStyle;{scroll bar style to use}
    FSelectColor       : TOvcColors;  {selected item color}
    FShowHeader        : Boolean;     {true to use the header}
    FSmoothScroll      : Boolean;     {use smooth scrolling (duh) }
    FTopIndex          : Integer;     {item at top of window}
    FUseTabStops       : Boolean;     {true to use tab stops}
    FWheelDelta        : Integer;

    {event variables}
    FOnCharToItem      : TCharToItemEvent;
    FOnClickHeader     : THeaderClickEvent;
    FOnDrawItem        : TDrawItemEvent;
    FOnGetItem         : TGetItemEvent;
    FOnGetItemColor    : TGetItemColorEvent;
    FOnGetItemStatus   : TGetItemStatusEvent;
    FOnIsSelected      : TIsSelectedEvent;
    FOnSelect          : TSelectEvent;
    FOnTopIndexChanged : TTopIndexChanged;
    FOnUserCommand     : TUserCommandEvent;

    {internal/working variables}
    lAnchor            : Integer;   {anchor point for extended selections}
    lDivisor           : Integer;   {divisor for scroll bars}
    lDlgUnits          : Integer;   {used for tab spacing}
    lFocusedIndex      : Integer;   {index of the focused item}
    lHaveHS            : Boolean;   {if True, we have a horizontal scroll bar}
    lHaveVS            : Boolean;   {if True, we have a vertical scroll bar}
    lHDelta            : Integer;   {horizontal scroll delta}
    lHighIndex         : Integer;   {highest allowable index}
    lNumTabStops       : 0..vlbMaxTabStops; {number of tab stops in tabstop array}
    lRows              : Integer;   {number of rows in window}
    lTabs              : TTabStopArray;
    lUpdating          : Integer;   {user updating flag}
    lVSHigh            : Integer;   {vertical scroll limit}
    lVMargin           : Integer;   {extra vertical line margin}
    MousePassThru      : Boolean;

    {property methods}
    procedure SetAutoRowHeight(Value : Boolean);
      {-set use of auto row height calculations}
    procedure SetBorderStyle(const Value : TBorderStyle);
      {-set the style used for the border}
    procedure SetColumns(const Value: Integer);
    procedure SetHeader(const Value : string);
      {-set the header at top of list box}
    procedure SetIntegralHeight(Value : Boolean);
      {-set use of integral font height adjustment}
    procedure SetMultiSelect(Value : Boolean); virtual;
      {-set ability to select multiple items}
    procedure InternalSetNumItems(Value : Integer; Paint, UpdateIndices : Boolean);
      {-set the number of items in the list box}
    procedure SetNumItems(Value : Integer);
      {-set the number of items in the list box}
    procedure SetRowHeight(Value : Integer);
      {-set height of cell row}
    procedure SetScrollBars(const Value : TScrollStyle); virtual;
      {-set use of vertical and horizontal scroll bars}
    procedure SetShowHeader(Value : Boolean);
      {-set the header at top of list box}

    {internal methods}
    procedure vlbAdjustIntegralHeight;
      {-adjust height of the list box}
    procedure vlbCalcFontFields; virtual;
      {-calculate sizes based on font selection}
    procedure vlbClearAllItems;
      {-clear the highlight from all items}
    procedure vlbClearSelRange(First, Last : Integer);
      {-clear the selection for the given range of indexes}
    procedure vlbColorChanged(AColor: TObject);
      {-a color has changed, refresh display}
    procedure vlbDragSelection(First, Last : Integer);
      {-drag the selection}
    procedure vlbDrawFocusRect(Index : Integer);
      {-draw the focus rectangle}
    procedure vlbDrawHeader;
      {-draw the header and text area}
    procedure vlbExtendSelection(Index : Integer);
      {-process Shift-LMouseBtn}
    procedure vlbHScrollPrim(Delta : Integer);
      {-scroll horizontally}
    procedure vlbInitScrollInfo;
      {-setup scroll bar range and initial position}
    procedure vlbMakeItemVisible(Index : Integer);
      {-make sure the item is visible}
    procedure vlbNewActiveItem(Index : Integer);
      {-set the currently selected item}
    function  vlbScaleDown(N : Integer) : Integer;
      {-scale down index for scroll bar use}
    function  vlbScaleUp(N : Integer) : Integer;
      {-scale up scroll index to our index}
    procedure vlbSelectRangePrim(First, Last : Integer; Select : Boolean);
      {-change the selection for the given range of indexes}
    procedure vlbSetAllItemsPrim(Select : Boolean);
      {-primitive routine thats acts on all items}
    procedure vlbSetFocusedIndex(Index : Integer);
      {-set focus to this item. invalidate previous}
    procedure vlbSetHScrollPos;
      {-set the horizontal scroll position}
    procedure vlbSetHScrollRange;
      {-set the horizontal scroll range}
    procedure vlbSetSelRange(First, Last : Integer);
      {-set the selection on for the given range of indexes}
    procedure vlbSetVScrollPos;
      {-set the vertical scroll position}
    procedure vlbSetVScrollRange;
      {-set the vertical scroll range}
    procedure vlbToggleSelection(Index : Integer);
      {-process Ctrl-LMouseBtn}
    procedure vlbValidateItem(Index : Integer);
      {-validate the area for this item}
    procedure vlbVScrollPrim(Delta : Integer);
      {-scroll vertically}

    {VCL control messages}
    procedure CMCtl3DChanged(var Message: TMessage);
      message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage);
      message CM_FONTCHANGED;

    {windows message methods}
    procedure WMChar(var Msg : TWMChar);
      message WM_CHAR;
    procedure WMEraseBkgnd(var Msg : TWMEraseBkgnd);
      message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMHScroll(var Msg : TWMScroll);
      message WM_HSCROLL;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Msg : TWMLButtonDblClk);
      message WM_LBUTTONDBLCLK;
    procedure WMMouseActivate(var Msg : TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMSize(var Msg : TWMSize);
      message WM_SIZE;
    procedure WMVScroll(var Msg : TWMScroll);
      message WM_VSCROLL;

    {list box messages}
    procedure LBGetCaretIndex(var Msg : TMessage);
      message LB_GETCARETINDEX;
    procedure LBGetCount(var Msg : TMessage);
      message LB_GETCOUNT;
    procedure LBGetCurSel(var Msg : TMessage);
      message LB_GETCURSEL;
    procedure LBGetItemHeight(var Msg : TMessage);
      message LB_GETITEMHEIGHT;
    procedure LBGetItemRect(var Msg : TMessage);
      message LB_GETITEMRECT;
    procedure LBGetSel(var Msg : TMessage);
      message LB_GETSEL;
    procedure LBGetTopIndex(var Msg : TMessage);
      message LB_GETTOPINDEX;
    procedure LBResetContent(var Msg : TMessage);
      message LB_RESETCONTENT;
    procedure LBSelItemRange(var Msg : TMessage);
      message LB_SELITEMRANGE;
    procedure LBSetCurSel(var Msg : TMessage);
      message LB_SETCURSEL;
    procedure LBSetSel(var Msg : TMessage);
      message LB_SETSEL;
    procedure LBSetTabStops(var Msg : TMessage);
      message LB_SETTABSTOPS;
    procedure LBSetTopIndex(var Msg : TMessage);
      message LB_SETTOPINDEX;

  protected
    procedure ChangeScale(M, D : Integer);
      override;
    procedure CreateParams(var Params: TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DragCanceled;
      override;
    procedure Paint;
      override;
    procedure WndProc(var Message: TMessage);
      override;

    {event wrappers}
    function DoOnCharToItem(Ch : Char) : Integer;
      dynamic;
      {-call the OnCharToItem event, if assigned}
    procedure DoOnClickHeader(Point : TPoint);
      dynamic;
      {-call the OnClickHeader event, if assigned}
    procedure DoOnDrawItem(Index : Integer; Rect : TRect; const S : string);
      virtual;
      {-call the OnDrawItem event, if assigned}
    function DoOnGetItem(Index : Integer) : string;
      virtual;
      {-call the OnGetItem event, if assigned}
    procedure DoOnGetItemColor(Index : Integer; var FG, BG : TColor);
      virtual;
      {-call the OnGetItemColor event, if assigned}
    function DoOnGetItemStatus(Index : Integer) : Boolean;
      virtual;
      {-call the OnGetItemStatus event, if assigned}
    function DoOnIsSelected(Index : Integer) : Boolean;
      virtual;
      {-call the OnIsSelected event, if assigned}
    procedure DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
      override;
    procedure DoOnSelect(Index : Integer; Selected : Boolean);
      dynamic;
      {-call the OnSelect event, if assigned}
    procedure DoOnTopIndexChanged(NewTopIndex : Integer);
      dynamic;
      {-call the OnTopIndexChanged event, if assigned}
    procedure DoOnUserCommand(Command : Word);
      dynamic;
      {-perform notification of a user command}

    {virtual property methods}
    procedure SetItemIndex(Index : Integer);
      virtual;
      {-change the currently selected item}
    procedure SetTopIndex(Index : Integer);
      virtual;
      {-set the index of the first visible entry in the list}
    procedure ForceTopIndex(Index : Integer; ThumbTracking : Boolean);
      virtual;
      {-re-set the index of the first visible entry in the list - even if it doesn't change}

    procedure SimulatedClick;
      virtual;
      {-generates a click event when called. Called from SetItemIndex. Introduced so that
        descendants can turn off the behavior.}
    function IsValidIndex(Index : Integer) : Boolean;



    {protected properties}
    property AutoRowHeight : Boolean
      read FAutoRowHeight write SetAutoRowHeight default vlDefAutoRowHeight;
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle default vlDefBorderStyle;
    property Columns : Integer
      read FColumns write SetColumns default vlDefColumns;
    property Header : string
      read FHeader write SetHeader;
    property HeaderColor : TOvcColors
      read FHeaderColor write FHeaderColor;
    property IntegralHeight : Boolean
      read FIntegralHeight write SetIntegralHeight default vlDefIntegralHeight;
    property MultiSelect : Boolean
      read FMultiSelect write SetMultiSelect default vlDefMultiSelect;
    property NumItems : Integer
      read FNumItems write SetNumItems default vlDefNumItems;
    property OwnerDraw : Boolean
      read FOwnerDraw write FOwnerDraw default vlDefOwnerDraw;
    property ProtectColor : TOvcColors
      read FProtectColor write FProtectColor;
    property RowHeight : Integer
      read FRowHeight write SetRowHeight default vlDefRowHeight;
    property ScrollBars : TScrollStyle
       read FScrollBars write SetScrollBars default vlDefScrollBars;
    property SelectColor : TOvcColors
      read FSelectColor write FSelectColor;
    property ShowHeader : Boolean
      read FShowHeader write SetShowHeader default vlDefShowHeader;
    property UseTabStops : Boolean
      read FUseTabStops write FUseTabStops default vlDefUseTabStops;
    property WheelDelta: Integer
      read FWheelDelta write FWheelDelta default 3;
    {protected events}
    property OnCharToItem : TCharToItemEvent
      read FOnCharToItem write FOnCharToItem;
    property OnClickHeader : THeaderClickEvent
      read FOnClickHeader write FOnClickHeader;
    property OnDrawItem : TDrawItemEvent
      read FOnDrawItem write FOnDrawItem;
    property OnGetItem : TGetItemEvent
      read FOnGetItem write FOnGetItem;
    property OnGetItemColor : TGetItemColorEvent
      read FOnGetItemColor write FOnGetItemColor;
    property OnGetItemStatus : TGetItemStatusEvent
      read FOnGetItemStatus write FOnGetItemStatus;
    property OnIsSelected : TIsSelectedEvent
      read FOnIsSelected write FOnIsSelected;
    property OnSelect : TSelectEvent
      read FOnSelect write FOnSelect;
    property OnTopIndexChanged : TTopIndexChanged
      read FOnTopIndexChanged write FOnTopIndexChanged;
    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand write FOnUserCommand;

  public


    constructor Create(AOwner : TComponent);
      override;
    destructor  Destroy;
      override;


    procedure BeginUpdate; virtual;
      {-user is updating the list items--don't paint}
    procedure CenterCurrentLine;
      {- center the currently selected line (if any) on screen}
    procedure CenterLine(Index : Integer);
      {- center the specified line (if any) vertically on screen}
    procedure DeselectAll;
      {-deselect all items}
    procedure DrawItem(Index : Integer);
      {-invalidate and update the area for this item}
    procedure EndUpdate; virtual;
      {-user is done updating the list items--force repaint}
    procedure InsertItemsAt(Items : Integer; Index : Integer);
      {-increase NumItems with Items amount while scrolling window down from Index}
    procedure DeleteItemsAt(Items : Integer; Index : Integer);
      {-decrease NumItems with Items amount while scrolling window up from Index}
    procedure InvalidateItem(Index : Integer);
      {-invalidate the area for this item}
    function ItemAtPos(Pos : TPoint; Existing : Boolean) : Integer;
      {-return the index of the cell that contains the point Pos}
    procedure Scroll(HDelta, VDelta : Integer);
      {-scroll the list by the give delta amount}
    procedure SelectAll;
      {-select all items}
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;
    procedure SetTabStops(const Tabs : array of Integer);
      {-set tab stop positions}

    {public properties}
    property Canvas;

    property ItemIndex : Integer
      read FItemIndex write SetItemIndex;
    property FillColor : TColor read FFillColor write FFillColor;
    property SmoothScroll : Boolean
      read FSmoothScroll write FSmoothScroll default True;
    property TopIndex : Integer
      read FTopIndex write SetTopIndex;
  end;

  TOvcVirtualListBox = class(TOvcCustomVirtualListBox)
  published
    property AutoRowHeight;
    property BorderStyle;
    property Columns;
    property Header;
    property HeaderColor;
    property IntegralHeight;
    property MultiSelect;
    property NumItems;
    property OwnerDraw;
    property ProtectColor;
    property RowHeight;
    property ScrollBars;
    property SelectColor;
    property ShowHeader;
    property SmoothScroll;
    property UseTabStops;
    property WheelDelta;
    property OnCharToItem;
    property OnClickHeader;
    property OnDrawItem;
    property OnGetItem;
    property OnGetItemColor;
    property OnGetItemStatus;
    property OnIsSelected;
    property OnSelect;
    property OnTopIndexChanged;
    property OnUserCommand;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property Color;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor default vlDefParentColor;
    property ParentCtl3D default vlDefParentCtl3D;
    property ParentFont default vlDefParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default vlDefTabStop;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
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
  end;


implementation

{const
  vlbWheelDelta = 3;} {changed to property}

{*** TOvcVirtualListBox ***}

procedure TOvcCustomVirtualListBox.BeginUpdate;
  {-user is updating the list items--don't paint}
begin
  inc(lUpdating);
end;

procedure TOvcCustomVirtualListBox.CenterCurrentLine;
{- center the currently selected line (if any) on screen}
begin
  if ItemIndex <> -1 then
    TopIndex := ItemIndex - (lRows div 2);
end;

procedure TOvcCustomVirtualListBox.CenterLine(Index : Integer);
begin
  if Index <> -1 then
    TopIndex := Index - (lRows div 2);
end;

procedure TOvcCustomVirtualListBox.ChangeScale(M, D : Integer);
begin
  inherited ChangeScale(M, D);

  if M <> D then begin
    {scale row height}
    FRowHeight := MulDiv(FRowHeight, M, D);

    vlbCalcFontFields;
    vlbAdjustIntegralHeight;
    vlbCalcFontFields;
    vlbInitScrollInfo;
    Refresh;
  end;
end;

procedure TOvcCustomVirtualListBox.CMCtl3DChanged(var Message: TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;

procedure TOvcCustomVirtualListBox.CMFontChanged(var Message: TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  {reset internal size variables}
  if FIntegralHeight then begin
    vlbCalcFontFields;
    vlbAdjustIntegralHeight;
  end;

  vlbCalcFontFields;
  vlbInitScrollInfo;
end;

constructor TOvcCustomVirtualListBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FillColor := Color;
  FSmoothScroll := True;

  if NewStyleControls then
    ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse, csOpaque]
  else
    ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse, csOpaque, csFramed];

  {set default values for inherited persistent properties}
  Align        := vlDefAlign;
  Color        := vlDefColor;
  Ctl3D        := vlDefCtl3D;
  Height       := vlDefHeight;
  ParentColor  := vlDefParentColor;
  ParentCtl3D  := vlDefParentCtl3D;
  ParentFont   := vlDefParentFont;
  TabStop      := vlDefTabStop;
  Width        := vlDefWidth;

  {set default values for new persistent properties}
  FAutoRowHeight  := vlDefAutoRowHeight;
  FBorderStyle    := vlDefBorderStyle;
  FColumns        := vlDefColumns;
  FHeader         := '';
  FIntegralHeight := vlDefIntegralHeight;
  FItemIndex      := vlDefItemIndex;
  FMultiSelect    := vlDefMultiSelect;
  FNumItems       := vlDefNumItems;
  FOwnerDraw      := vlDefOwnerDraw;
  FRowHeight      := vlDefRowHeight;
  FScrollBars     := vlDefScrollBars;
  FShowHeader     := vlDefShowHeader;
  FTopIndex       := vlDefTopIndex;
  FUseTabStops    := vlDefUseTabStops;

  {set defaults for internal variables}
  lHDelta         := 0;
  lHaveHS         := False;
  lHaveVS         := False;

  lAnchor         := 0;
  lFocusedIndex   := 0; {-1;}

  lNumTabStops    := 0;
  FillChar(lTabs, SizeOf(lTabs), #0);

  {create and initialize color objects}
  FHeaderColor  := TOvcColors.Create(vlDefHeaderText, vlDefHeaderBack);
  FHeaderColor.OnColorChange := vlbColorChanged;
  FProtectColor := TOvcColors.Create(vlDefProtectText, vlDefProtectBack);
  FProtectColor.OnColorChange := vlbColorChanged;
  FSelectColor  := TOvcColors.Create(vlDefSelectText, vlDefSelectBack);
  FSelectColor.OnColorChange := vlbColorChanged;
  FWheelDelta := 3;
end;

procedure TOvcCustomVirtualListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Style or DWord(ScrollBarStyles[FScrollBars])
                   or DWord(BorderStyles[FBorderStyle]);
  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcCustomVirtualListBox.CreateWnd;
begin
  inherited CreateWnd;

  {do we have scroll bars}
  lHaveVS := FScrollBars in [ssVertical, ssBoth];
  lHaveHS := FScrollBars in [ssHorizontal, ssBoth];
  lHighIndex := Pred(FNumItems);

  lFocusedIndex := 0; {-1;}

  {determine the height of one row and number of rows}
  vlbCalcFontFields;
  vlbAdjustIntegralHeight;

  {setup scroll bar info}
  vlbInitScrollInfo;
end;

function TOvcCustomVirtualListBox.DoOnCharToItem(Ch : Char) : Integer;
begin
  Result := FItemIndex;
  if Assigned(FOnCharToItem) then
    FOnCharToItem(Self, Ch, Result);
end;

procedure TOvcCustomVirtualListBox.DoOnClickHeader(Point : TPoint);
begin
  if Assigned(FOnClickHeader) then
    FOnClickHeader(Self, Point);
end;

procedure TOvcCustomVirtualListBox.DoOnDrawItem(Index : Integer; Rect : TRect;
  const S : string);
begin
  if Assigned(FOnDrawItem) then
    FOnDrawItem(Self, Index, Rect, S);
end;

function TOvcCustomVirtualListBox.DoOnGetItem(Index : Integer) : string;
  {-returns the string representing Nth item}
var
  S : string;
begin
  if Assigned(FOnGetItem) then begin
    S := '';
    FOnGetItem(Self, Index, S);
    Result := S;
  end else if csDesigning in ComponentState then begin
    Result := Format(GetOrphStr(SCSampleListItem), [Index]);
  end else
    Result := Format(GetOrphStr(SCGotItemWarning), [Index]);
end;

procedure TOvcCustomVirtualListBox.DoOnGetItemColor(Index : Integer; var FG, BG : TColor);
begin
  if Assigned(FOnGetItemColor) then
    FOnGetItemColor(Self, Index, FG, BG);
end;

function TOvcCustomVirtualListBox.DoOnGetItemStatus(Index : Integer) : Boolean;
begin
  Result := False;
  if Assigned(FOnGetItemStatus) then
    FOnGetItemStatus(Self, Index, Result);
end;

function TOvcCustomVirtualListBox.DoOnIsSelected(Index : Integer) : Boolean;
  {-returns the selected status for the "Index" item}
begin
  if csDesigning in ComponentState then
    Result := Index = 0
  else begin
    Result := (Index = FItemIndex);
    if FMultiSelect then begin
      if Assigned(FOnIsSelected) then
        FOnIsSelected(Self, Index, Result)
      else
        raise EOnIsSelectedNotAssigned.Create;
    end;
  end;
end;

procedure TOvcCustomVirtualListBox.DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
var
  I : Integer;
begin
  inherited DoOnMouseWheel(Shift, Delta, XPos, YPos);

  if Delta < 0 then begin
    for I := 1 to {vlb}WheelDelta do
      Perform(WM_VSCROLL, MAKELONG(SB_LINEDOWN, 0), 0);
  end else if Delta > 0 then begin
    for I := 1 to {vlb}WheelDelta do
      Perform(WM_VSCROLL, MAKELONG(SB_LINEUP, 0), 0);
  end;
end;

procedure TOvcCustomVirtualListBox.DoOnSelect(Index : Integer; Selected : Boolean);
  {-notify of selection change}
begin
  if csDesigning in ComponentState then
    Exit;

  if FMultiSelect then begin
    if Assigned(FOnSelect) then begin
      {select if not protected-deselect always}
      if (not Selected) or (not DoOnGetItemStatus(Index)) then
        FOnSelect(Self, Index, Selected);
    end else
      raise EOnSelectNotAssigned.Create;
  end;
end;

procedure TOvcCustomVirtualListBox.DoOnTopIndexChanged(NewTopIndex : Integer);
  {-call the OnTopIndexChanged event, if assigned}
begin
  if Assigned(FOnTopIndexChanged) then
    FOnTopIndexChanged(Self, NewTopIndex);
end;

procedure TOvcCustomVirtualListBox.DoOnUserCommand(Command : Word);
  {-perform notification of a user command}
begin
  if Assigned(FOnUserCommand) then
    FOnUserCommand(Self, Command);
end;

procedure TOvcCustomVirtualListBox.DeselectAll;
  {-deselect all items}
begin
  vlbSetAllItemsPrim(False {deselect});
end;

procedure TOvcCustomVirtualListBox.DrawItem(Index : Integer);
  {-invalidate and update the area for this item}
begin
  InvalidateItem(Index);
  Update;
end;

destructor  TOvcCustomVirtualListBox.Destroy;
begin
  {if lUpdating <> 0 then debug code}
    {raise Exception.Create('Mismatched BeginUpdate/EndUpdate');}
  FHeaderColor.Free;
  FProtectColor.Free;
  FSelectColor.Free;

  inherited Destroy;
end;

procedure TOvcCustomVirtualListBox.EndUpdate;
 {-user is done updating the list items--force repaint}
begin
  dec(lUpdating);
  if lUpdating < 0 then
    raise Exception.Create('Mismatched BeginUpdate/EndUpdate');
  if lUpdating = 0 then
    Invalidate;
end;

function ScrollCanvas(Canvas : TCanvas; R : TRect; EastWest : Boolean; Distance : Integer;
  Smooth : Boolean) : TRect;
var
  UpdRect : TRect;
  NextStep,StepSize : Integer;
  {OldColor : TColor;}
begin
  if Distance = 0 then begin
    Result := Rect(0,0,0,0);
    exit;
  end;
  if Smooth then
    StepSize := MaxI((Abs(Distance) div 4), MinI(2, Abs(Distance)))
  else
    StepSize := Abs(Distance);
  Result := R;
  if EastWest then
    if abs(Distance) < (Result.Right-Result.Left+1) then
      if Distance < 0 then
        Result.Left := Result.Right + Distance
      else
        Result.Right := Result.Left + Distance
    else
  else
    if abs(Distance) < (Result.Bottom-Result.Top+1) then
      if Distance < 0 then
        Result.Top := Result.Bottom + Distance
      else
        Result.Bottom := Result.Top + Distance;
  repeat
    if Distance > 0 then
      if Distance > StepSize then
        NextStep := StepSize
      else
        NextStep := Distance
    else
      if Distance < -StepSize then
        NextStep := -StepSize
      else
        NextStep := Distance;
    if EastWest then
      ScrollDC(Canvas.Handle,NextStep,0,R,R,0,@UpdRect)
    else
      ScrollDC(Canvas.Handle,0,NextStep,R,R,0,@UpdRect);
{ 01/2012, AB: Types.UnionRect(Result, UpdRect, Result) always yields Result := UpdRect
               this appears to be a bug. The workaround is to use the following line: }
    UnionRect(Result, Result, UpdRect);
    dec(Distance,NextStep);
  until Distance = 0;
end;

procedure TOvcCustomVirtualListBox.InsertItemsAt(Items : Integer; Index : Integer);
  {-increase NumItems with Items amount while scrolling window down from Index}
var
  CR : TRect;
  AbsBottom : Integer;
  OldItemIndex : Integer;
begin
  OldItemIndex := ItemIndex;
  ItemIndex := -1;
  InternalSetNumItems(NumItems + Items,False,False);
  if (lUpdating = 0) then
    if (Index-FTopIndex) < lRows then begin
      AbsBottom := (ClientRect.Bottom div FRowHeight) * FRowHeight;
      if Index >= FTopIndex then begin
        CR := Rect(0, (Index-FTopIndex+Ord(FShowHeader))*FRowHeight, ClientWidth, AbsBottom);
        {Make sure the canvas is updated,
         because we will be validating the scrolled portion.}
        CR := ScrollCanvas(Canvas, CR, False, Items*FRowHeight, FSmoothScroll);
        InvalidateRect(Handle,@CR,False);
      end else begin
        CR := Rect(0, (Ord(FShowHeader))*FRowHeight, ClientWidth, AbsBottom);
        Update;
        {Make sure the canvas is updated,
         because we will be validating the scrolled portion.}
        CR := ScrollCanvas(Canvas, CR, False, Items*FRowHeight, FSmoothScroll);
        InvalidateRect(Handle, @CR, False);
        Update;
      end;
    end;
  if OldItemIndex >= Index then
    inc(OldItemIndex,Items);
  ItemIndex := OldItemIndex;
end;

procedure TOvcCustomVirtualListBox.DeleteItemsAt(Items : Integer; Index : Integer);
  {-decrease NumItems with Items amount while scrolling window up from Index}
var
  CR : TRect;
  AbsBottom,OldItemIndex : Integer;
begin
  OldItemIndex := ItemIndex;
  ItemIndex := -1;
  if lUpdating = 0 then
    Update;
  InternalSetNumItems(NumItems - Items,False,False);
  if lUpdating = 0 then begin
    if (Index-FTopIndex) < lRows then begin
      AbsBottom := (ClientRect.Bottom div FRowHeight) * FRowHeight;
      if Index >= FTopIndex then begin
        CR := Rect(0, (Index-FTopIndex+Ord(FShowHeader))*FRowHeight, ClientWidth, AbsBottom);
        CR := ScrollCanvas(Canvas, CR, False, -Items*FRowHeight, FSmoothScroll);
        InvalidateRect(Handle,@CR,False);
        Update;
      end else begin
        CR := Rect(0, (Ord(FShowHeader))*FRowHeight, ClientWidth, AbsBottom);
        CR := ScrollCanvas(Canvas, CR, False, -Items*FRowHeight, FSmoothScroll);
        InvalidateRect(Handle,@CR,False);
        Update;
      end;
    end;
  end;
  if OldItemIndex >= Index+Items then
    dec(OldItemIndex,Items)
  else
  if OldItemIndex >= Index then
    OldItemIndex := -1;
  ItemIndex := OldItemIndex;
  if TopIndex + lRows > FNumItems then
    ForceTopIndex(FNumItems - 1, True)
  else
    ForceTopIndex(TopIndex, False);
end;

procedure TOvcCustomVirtualListBox.InvalidateItem(Index : Integer);
  {-invalidate the area for this item}
var
  CR : TRect;
begin
  if (Index >= FTopIndex) and (Index-FTopIndex < lRows) then begin  {visible?}
    CR := Rect(0, (Index-FTopIndex+Ord(FShowHeader))*FRowHeight, ClientWidth, 0);
    CR.Bottom := CR.Top+FRowHeight;
    InvalidateRect(Handle, @CR, True);
  end;
end;

function TOvcCustomVirtualListBox.ItemAtPos(Pos : TPoint;
         Existing : Boolean) : Integer;
  {-return the index of the cell that contains the point Pos}
begin
  if (Pos.Y < Ord(FShowHeader)*FRowHeight) then begin
    if Existing then
      Result := -1
    else
      Result := 0;
  end else if (Pos.Y >= ClientHeight) then begin
    if Existing then
      Result := -1
    else
      Result := lHighIndex;
  end else begin {convert to an index}
    Result := FTopIndex-Ord(FShowHeader)+(Pos.Y div FRowHeight);
    {test for click below last item (IntegralHeight not set)}
    if ClientHeight mod FRowHeight > 0 then
      if Result > FTopIndex+lRows-1 then
        Result := FTopIndex+lRows-1;
    if Result > NumItems then
      if Existing then
        Result := -1
      else
        Result := NumItems;
  end;
end;

procedure TOvcCustomVirtualListBox.LBGetCaretIndex(var Msg : TMessage);
begin
  Msg.Result := lFocusedIndex;
end;

procedure TOvcCustomVirtualListBox.LBGetCount(var Msg : TMessage);
begin
  Msg.Result := FNumItems;
end;

procedure TOvcCustomVirtualListBox.LBGetCurSel(var Msg : TMessage);
begin
  Msg.Result := FItemIndex;
end;

procedure TOvcCustomVirtualListBox.LBGetItemHeight(var Msg : TMessage);
begin
  Msg.Result := FRowHeight;
end;

procedure TOvcCustomVirtualListBox.LBGetItemRect(var Msg : TMessage);
begin
  PRect(Msg.LParam)^ :=
    Rect(0, (Integer(Msg.WParam) - FTopIndex) * FRowHeight,
         ClientWidth, (Integer(Msg.WParam) - FTopIndex) * FRowHeight + FRowHeight);
end;

procedure TOvcCustomVirtualListBox.LBGetSel(var Msg : TMessage);
begin
  if (Integer(Msg.wParam) >= 0) and (Integer(Msg.wParam) <= lHighIndex) then
    Msg.Result := Ord(DoOnIsSelected(Msg.wParam))
  else
    Msg.Result := LB_ERR;
end;

procedure TOvcCustomVirtualListBox.LBGetTopIndex(var Msg : TMessage);
begin
  Msg.Result := FTopIndex;
end;

procedure TOvcCustomVirtualListBox.LBResetContent(var Msg : TMessage);
begin
  NumItems := 0;
end;

procedure TOvcCustomVirtualListBox.LBSelItemRange(var Msg : TMessage);
begin
  if FMultiSelect and (Msg.wParamLo <= lHighIndex)
     and (Msg.wParamHi <= lHighIndex) then begin
    vlbSelectRangePrim(Msg.lParamLo, Msg.lParamHi, Msg.wParam > 0);
    Msg.Result := 0;
  end else
    Msg.Result := LB_ERR;
end;

procedure TOvcCustomVirtualListBox.LBSetCurSel(var Msg : TMessage);
begin
  if FMultiSelect and (Integer(Msg.wParam) >= -1) and (Integer(Msg.wParam) <= lHighIndex) then begin
    SetItemIndex(Msg.wParam);
    if Msg.wParam = $FFFF then
      Msg.Result := LB_ERR
    else
      Msg.Result := 0;
  end else
    Msg.Result := LB_ERR;
end;

procedure TOvcCustomVirtualListBox.LBSetSel(var Msg : TMessage);
begin
  if FMultiSelect and (Msg.lParam >= -1) and (Msg.lParam <= lHighIndex) then begin
    if Msg.lParam = -1 then
      vlbSetAllItemsPrim(Msg.wParam > 0)
    else begin
      DoOnSelect(Msg.lParam, Msg.wParam > 0);
      InvalidateItem(Msg.lParam);
    end;
    Msg.Result := 0;
  end else
    Msg.Result := LB_ERR;
end;

procedure TOvcCustomVirtualListBox.LBSetTabStops(var Msg : TMessage);
type
  IA = TTabStopArray;
  IP = ^IA;
var
  I : Integer;
begin
  lNumTabStops := Msg.wParam;
  if lNumTabStops > vlbMaxTabStops then begin
    lNumTabStops := vlbMaxTabStops;
    Msg.Result := 0;  {didn't set all tabs}
  end else
    Msg.Result := 1;

  for I := 0 to Pred(lNumTabStops) do
    lTabs[I] := IP(Msg.lParam)^[I] * lDlgUnits;
end;

procedure TOvcCustomVirtualListBox.LBSetTopIndex(var Msg : TMessage);
begin
  if (Integer(Msg.wParam) >= 0) and (Integer(Msg.wParam) <= lHighIndex) then begin
    SetTopIndex(Msg.wParam);
    Msg.Result := 0;
  end else
    Msg.Result := LB_ERR;
end;

procedure TOvcCustomVirtualListBox.Paint;
var
  I    : Integer;
  ST   : string;
  CR   : TRect;
  IR   : TRect;
  Clip : TRect;
  Last : Integer;

  procedure DrawItem(N : Integer; Row : Integer);
    {-Draw item N at Row}
  var
    S       : PChar;
    FGColor : TColor;
    BGColor : TColor;
    DX      : Integer;
  begin
    {get bounding rectangle}
    CR.Top := Pred(Row)*FRowHeight;
    CR.Bottom := CR.Top+FRowHeight;

    {do we have anything to paint}
    if Bool(IntersectRect(IR, Clip, CR)) then begin

      {get colors}
      if DoOnGetItemStatus(N) then begin
        BGColor := FProtectColor.BackColor;
        FGColor := FProtectColor.TextColor;
      end else if DoOnIsSelected(N) and (Row <= lRows+Ord(FShowHeader)) then begin
        BGColor := FSelectColor.BackColor;
        FGColor := FSelectColor.TextColor;
      end else begin
        BGColor := Color;
        FGColor := Font.Color;
        DoOnGetItemColor(N, FGColor, BGColor);
      end;

      {assign colors to our canvas}
      Canvas.Brush.Color := BGColor;
      Canvas.Font.Color := FGColor;

      {clear the line}
      Canvas.FillRect(CR);

      {get the string}
      if N <= lHighIndex then begin
        ST := DoOnGetItem(N);
        if lHDelta >= Integer(Length(ST)) then
          S := nil
        else
          S := @PChar(ST)[lHDelta];
      end else
        S := nil;

      {draw the string}
      if S <> nil then begin
        if FOwnerDraw then
          DoOnDrawItem(N, CR, S)
        else if FUseTabStops then begin
          DX := 0;
          if lHDelta > 0 then begin
            {measure portion of string to the left of the window}
            DX := LOWORD(GetTabbedTextExtent(Canvas.Handle,
                  PChar(ST), lHDelta, lNumTabStops, lTabs));
          end;
          TabbedTextOut(Canvas.Handle, CR.Left+2, CR.Top,
                        S, StrLen(S), lNumTabStops, lTabs, -DX)
        end else
          ExtTextOut(Canvas.Handle, CR.Left+2, CR.Top,
                     ETO_CLIPPED + ETO_OPAQUE, @CR, S, StrLen(S), nil);
      end;
    end;
  end;

begin
  {exit if the updating flag is set}
  if lUpdating > 0 then
    Exit;

  Canvas.Font := Font;

  {we will erase our own background}
  SetBkMode(Canvas.Handle, TRANSPARENT);

  {get the client rectangle}
  CR := ClientRect;

  {get the clipping region}
  GetClipBox(Canvas.Handle, Clip);

  {do we have a header?}
  if FShowHeader then begin
    if Bool(IntersectRect(IR, Clip, Rect(CR.Left, CR.Top, CR.Right, FRowHeight))) then
      vlbDrawHeader;
  end;

  {calculate last visible item}
  Last := lRows;
  if Last > NumItems then
    Last := NumItems;

  {display each row}
  for I := 1 to Last do
    DrawItem(FTopIndex+Pred(I), I+Ord(FShowHeader));

  {paint any blank area below last item}
  CR.Top := FRowHeight * (Last+Ord(FShowHeader));
  if CR.Top < ClientHeight then begin
    CR.Bottom := ClientHeight;
    {clear the area}
    Canvas.Brush.Color := Color;
    Canvas.FillRect(CR);
  end;

  Canvas.Brush.Color := Color;
  Canvas.Font.Color := Font.Color;
  if Canvas.Handle > 0 then {force colors to be selected into canvas};
  {conditionally, draw the focus rect}
  if lFocusedIndex <> -1 then
    vlbDrawFocusRect(lFocusedIndex);
end;

procedure TOvcCustomVirtualListBox.DragCanceled;
var
  M: TWMMouse;
  P, MousePos: TPoint;
begin
  with M do
  begin
    Msg := WM_LBUTTONDOWN;
    GetCursorPos(MousePos);
    P := ScreenToClient(MousePos);
    Pos := PointToSmallPoint(P);
    Keys := 0;
    Result := 0;
  end;
  DefaultHandler(M);
  M.Msg := WM_LBUTTONUP;
  DefaultHandler(M);
end;

procedure TOvcCustomVirtualListBox.WndProc(var Message: TMessage);
begin
  {for auto drag mode, let listbox handle itself, instead of TControl}
  if not (csDesigning in ComponentState) and ((Message.Msg = WM_LBUTTONDOWN) or
    (Message.Msg = WM_LBUTTONDBLCLK)) and not Dragging then
  begin
    if DragMode = dmAutomatic then
    begin
      if IsControlMouseMsg(TWMMouse(Message)) then
        Exit;
      ControlState := ControlState + [csLButtonDown];
      Dispatch(Message);  {overrides TControl's BeginDrag}
      Exit;
    end;
  end;
  inherited WndProc(Message);
end;

procedure TOvcCustomVirtualListBox.Scroll(HDelta, VDelta : Integer);
  {-scroll the list by the give delta amount}
begin
  if HDelta <> 0 then
    vlbHScrollPrim(HDelta);

  if VDelta <> 0 then
    vlbVScrollPrim(VDelta);
end;

procedure TOvcCustomVirtualListBox.SelectAll;
  {-select all items}
begin
  vlbSetAllItemsPrim(True {select});
end;

procedure TOvcCustomVirtualListBox.SetAutoRowHeight(Value : Boolean);
  {-set use of auto row height calculations}
begin
  if Value <> FAutoRowHeight then begin
    FAutoRowHeight := Value;
    if FAutoRowHeight then begin
      vlbCalcFontFields;
      vlbAdjustIntegralHeight;
      vlbCalcFontFields;
      vlbInitScrollInfo;
      Refresh;
    end;
  end;
end;

procedure TOvcCustomVirtualListBox.SetBorderStyle(const Value : TBorderStyle);
  {-set the style used for the border}
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomVirtualListBox.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  if not (Align in [alNone, alTop, alBottom]) then
    FIntegralHeight := False;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TOvcCustomVirtualListBox.SetHeader(const Value : string);
  {-set the header at top of list box}
begin
  if Value <> FHeader then begin
    FHeader := Value;
    {toggle show header flag as appropriate}
    if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
      ShowHeader := FHeader <> '';
    Repaint;
  end;
end;

procedure TOvcCustomVirtualListBox.SetIntegralHeight(Value : Boolean);
  {-set use of integral font height adjustment}
begin
  if (Value <> FIntegralHeight) and (Align in [alNone, alTop, alBottom]) then begin
    FIntegralHeight := Value;
    if FIntegralHeight then begin
      vlbCalcFontFields;
      vlbAdjustIntegralHeight;
      vlbCalcFontFields;
      vlbInitScrollInfo;
    end;
  end;
end;

procedure TOvcCustomVirtualListBox.SetItemIndex(Index : Integer);
  {-change the currently selected item}
begin
  {verify valid index}
  if Index > lHighIndex then
  if lHighIndex < 0 then
    Index := -1
  else
    Index := lHighIndex;

  {do we need to do any more}
  if (Index = FItemIndex) then
    Exit;

  {erase current selection}
  InvalidateItem(FItemIndex);

  {if Index <> -1 then}
    DoOnSelect(FItemIndex, False);

  {set the newly selected item index}
  FItemIndex := Index;
  {lFocusedIndex := -1;}
  Update;

  if csDesigning in ComponentState then
    Exit;

  {vlbMakeItemVisible(Index);}
  if FItemIndex > -1 then begin
    vlbMakeItemVisible(Index);
    DoOnSelect(FItemIndex, True);
  end;
  if FItemIndex <> -1 then
    vlbSetFocusedIndex(FItemIndex)
  else
    vlbSetFocusedIndex(0);
  DrawItem(FItemIndex);

  {notify of an index change}
  if not MouseCapture then
    SimulatedClick;
end;

procedure TOvcCustomVirtualListBox.SimulatedClick;
begin
  Click;
end;

function TOvcCustomVirtualListBox.IsValidIndex(Index : Integer) : Boolean;
begin
  Result := (Index >= 0) and (Index <= lHighIndex);
end;

procedure TOvcCustomVirtualListBox.SetMultiSelect(Value : Boolean);
  {-set ability to select multiple items}
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    if Value <> FMultiSelect then
      FMultiSelect := Value;
end;

procedure TOvcCustomVirtualListBox.InternalSetNumItems(Value : Integer; Paint, UpdateIndices : Boolean);
  {-set the number of items in the list box}
var
  OldNumItems : Integer;
begin
  if Value <> FNumItems then begin
    if (Value < 0) then
      Value := MaxLongInt;

    OldNumItems := FNumItems;
    {set new item index}
    FNumItems := Value;

    {reset high index}
    lHighIndex := Pred(FNumItems);
    {reset horizontal offset}
    lHDelta := 0;

    {reset selected item}
    if UpdateIndices then
      if not (csLoading in ComponentState) then begin
        if ItemIndex >= FNumItems then
          ItemIndex := -1;
        if TopIndex + lRows > FNumItems then
          ForceTopIndex(FNumItems - 1, True)
        else
          ForceTopIndex(TopIndex, False);
      end;
    if Paint and ((NumItems <= lRows) or (OldNumItems <= lRows)) then
      Repaint;

    vlbInitScrollInfo;
  end;
end;

procedure TOvcCustomVirtualListBox.SetNumItems(Value : Integer);
  {-set the number of items in the list box}
begin
  InternalSetNumItems(Value, True, True);
end;

procedure TOvcCustomVirtualListBox.SetRowHeight(Value : Integer);
  {-set height of cell row}
begin
  if Value <> FRowHeight then begin
    FRowHeight := Value;
    if not (csLoading in ComponentState) then
      AutoRowHeight := False;
    vlbCalcFontFields;
    vlbAdjustIntegralHeight;
    vlbCalcFontFields;
    vlbInitScrollInfo;
    Refresh;
  end;
end;

procedure TOvcCustomVirtualListBox.SetScrollBars(const Value : TScrollStyle);
  {-set use of vertical and horizontal scroll bars}
begin
  if Value <> FScrollBars then begin
    FScrollBars := Value;
    lHaveVS := (FScrollBars = ssVertical) or (FScrollBars = ssBoth);
    lHaveHS := (FScrollBars = ssHorizontal) or (FScrollBars = ssBoth);
    RecreateWnd;
  end;
end;

procedure TOvcCustomVirtualListBox.SetShowHeader(Value : Boolean);
  {-set show flag for the header}
begin
  if Value <> FShowHeader then begin
    FShowHeader := Value;
    Refresh;
  end;
end;

procedure TOvcCustomVirtualListBox.SetTabStops(const Tabs : array of Integer);
  {-set tab stop positions}
var
  I : Integer;
begin
  HandleNeeded;
  lNumTabStops := High(Tabs)+1;
  if lNumTabStops > vlbMaxTabStops then
    lNumTabStops := vlbMaxTabStops;
  for I := 0 to Pred(lNumTabStops) do
    lTabs[I] := Tabs[I] * lDlgUnits;
end;

procedure TOvcCustomVirtualListBox.ForceTopIndex(Index : Integer; ThumbTracking : Boolean);
  {-set the index of the first visible entry in the list}
var
  DY       : Integer;
  SaveD    : Integer;
  ClipBox,
  TmpArea,
  ClipArea : TRect;
  Inv      : TRect;
begin
  if (Index >= 0) and (Index <= lHighIndex) then begin
    Update;
    SaveD := FTopIndex;
    {if we can't make the requested item the top one, at least show it}
    if Index + lRows -1 <= lHighIndex then
      FTopIndex := Index
    else
      FTopIndex := lHighIndex - lRows + 1;

    {check for valid index}
    if FTopIndex < 0 then
      FTopIndex := 0;
    if FTopIndex = SaveD then
      Exit;
    vlbSetVScrollPos;
    ClipArea := ClientRect;
    {adjust top of the clipping region to exclude the header, if any}
    if FShowHeader then with ClipArea do
      Top := Top + FRowHeight;

    if GetClipBox(Canvas.Handle, ClipBox) <> SIMPLEREGION then
      InvalidateRect(Handle, @ClipArea, True)
    else begin
      InterSectRect(ClipArea, ClipArea, ClipBox);

      TmpArea := ClipArea;
      TmpArea.Bottom := ClipArea.Bottom;
      {adjust bottom of the clipping region to an even number of rows}
      with ClipArea do
        Bottom := (Bottom div FRowHeight) * FRowHeight;
      TmpArea.Top := ClipArea.Bottom;
      {if ThumbTracking then
        InvalidateRect(Handle, @ClipArea, True)
      else} begin
        DY := (SaveD - FTopIndex);
        if Abs(DY) > lRows then
          DY := lRows;
        DY := DY * FRowHeight;
        Update;
        {Make sure the canvas is updated,
         because we will be validating the scrolled portion.}
        Inv := ScrollCanvas(Canvas, ClipArea, False, DY, (not ThumbTracking) and FSmoothScroll);
        InvalidateRect(Handle, @Inv, False);
        InvalidateRect(Handle, @TmpArea, False);
        if SaveD <> FTopIndex then begin
          DoOnTopIndexChanged(FTopIndex);
          SaveD := FTopIndex;
        end;
        Update;
      end;
    end;
    vlbSetFocusedIndex(FItemIndex);

    {notify that top index has changed}
    if SaveD <> FTopIndex then
      DoOnTopIndexChanged(FTopIndex);
  end;
end;

procedure TOvcCustomVirtualListBox.SetTopIndex(Index : Integer);
  {-set the index of the first visible entry in the list}
begin
  if csDesigning in ComponentState then
    Exit;

  if Index <> FTopIndex then
    ForceTopIndex(Index, False);
end;

procedure TOvcCustomVirtualListBox.vlbAdjustIntegralHeight;
begin
  if (csDesigning in ComponentState) and
     not (csLoading in ComponentState) then
    if FIntegralHeight then
      if ClientHeight mod FRowHeight <> 0 then
        ClientHeight := (ClientHeight div FRowHeight) * FRowHeight;
end;

procedure TOvcCustomVirtualListBox.vlbCalcFontFields;
var
  Alpha : string;
begin
  if not HandleAllocated then
    Exit;

  Alpha := GetOrphStr(SCAlphaString);

  {set the canvas font}
  Canvas.Font := Self.Font;

  {determine the height of one row}
  if FAutoRowHeight and not (csLoading in ComponentState) then
    FRowHeight := Canvas.TextHeight(GetOrphStr(SCTallLowChars)) + lVMargin;
  lRows := (ClientHeight div FRowHeight)-Ord(FShowHeader);
  if lRows < 1 then
    lRows := 1;

  {calculate the base dialog unit for tab spacing}
  lDlgUnits := (Canvas.TextWidth(Alpha) div Length(Alpha)) div 4
end;

procedure TOvcCustomVirtualListBox.vlbClearAllItems;
  {-clear the highlight from all items}
begin
  vlbSetAllItemsPrim(False);
end;

procedure TOvcCustomVirtualListBox.vlbClearSelRange(First, Last : Integer);
  {-clear the selection for the given range of indexes}
begin
  vlbSelectRangePrim(First, Last, False);
end;

procedure TOvcCustomVirtualListBox.vlbColorChanged(AColor: TObject);
  {-a color has changed, refresh display}
begin
  Refresh;
end;

procedure TOvcCustomVirtualListBox.vlbDrawFocusRect(Index : Integer);
  {-draw the focus rectangle}
var
  CR : TRect;
begin
  if Index < 0 then exit;
  if Focused then begin
    if (Index >= FTopIndex) and (Index-FTopIndex <= Pred(lRows)) then begin
      CR := ClientRect;
      CR.Top := (Index-FTopIndex+Ord(FShowHeader))*FRowHeight;
      CR.Bottom := CR.Top + FRowHeight;
      Canvas.DrawFocusRect(CR);
    end;
  end;
  lFocusedIndex := Index;
end;

procedure TOvcCustomVirtualListBox.vlbDragSelection(First, Last : Integer);
  {-drag the selection}
var
  I       : Integer;
  OutSide : Boolean;
begin

  {set new active item}
  vlbNewActiveItem(Last);

  {remove selection from visible selected items not in range}
  for I := FTopIndex to FTopIndex+Pred(lRows) do begin
    if First <= Last then
      OutSide :=  (I < First) or (I > Last)
    else
      OutSide :=  (I < Last) or (I > First);

    if DoOnIsSelected(I) and OutSide then
        InvalidateItem(I);

  end;

  {deselect all items}
  DoOnSelect(-1, False);

  {select new range}
  vlbSetSelRange(First, Last);
  vlbSetFocusedIndex(Last);
  Update;
end;

procedure TOvcCustomVirtualListBox.vlbDrawHeader;
  {-draw the header and text}
var
  R      : TRect;
  Buf    : string;
  S      : PChar;
  DX     : Integer;
begin
  {get the printable area of the header text}
  Buf := FHeader;
  if lHDelta >= Integer(Length(Buf)) then
    S := ' ' {space to erase last character from header}
  else
    S := PChar(@Buf[lHDelta+1]);

  Canvas.Font := Font;
  with Canvas do begin
    {draw header text}
    Brush.Color := FHeaderColor.BackColor;
    Font.Color := FHeaderColor.TextColor;

    R := Bounds(0, 0, Width, FRowHeight-1);

    {clear the line}
    Canvas.FillRect(R);

    if S <> nil then
      if FUseTabStops then begin
        DX := 0;
        if lHDelta > 0 then begin
          {measure portion of string to the left of the window}
          DX := LOWORD(GetTabbedTextExtent(Canvas.Handle, PChar(Buf), lHDelta,
                lNumTabStops, lTabs));
        end;
        TabbedTextOut(Canvas.Handle, 2, 0,
                      S, StrLen(S), lNumTabStops, lTabs, -DX)
      end else
        ExtTextOut(Canvas.Handle, 2, 0, ETO_OPAQUE + ETO_CLIPPED,
                   @R, S, StrLen(S), nil);

    {draw border line}
    Pen.Color := clBlack;
    PolyLine([Point(R.Left, R.Bottom), Point(R.Right, R.Bottom)]);

    {draw ctl3d highlight}
    if Ctl3D then begin
      Pen.Color := clBtnHighlight;
      PolyLine([Point(R.Left, R.Bottom-1),
                Point(R.Left, R.Top),
                Point(R.Right, R.Top)]);
    end;
  end;
end;

procedure TOvcCustomVirtualListBox.vlbExtendSelection(Index : Integer);
  {-process Shift-LMouseBtn}
begin
  {verify valid index}
  if Index < 0 then
    Index := 0
  else if Index > lHighIndex then
    Index := lHighIndex;

  {clear current selections}
  vlbClearAllItems;

  {set selection for all items from the active one to the currently selected item}
  vlbSetSelRange(lAnchor, Index);

  {set new active item}
  FItemIndex := Index;
  vlbSetFocusedIndex(FItemIndex);
  Update;
end;

procedure TOvcCustomVirtualListBox.vlbHScrollPrim(Delta : Integer);
var
  SaveD : Integer;
begin
  SaveD := lHDelta;
  if Delta < 0 then
    if Delta > lHDelta then
      lHDelta := 0
    else
      Inc(lHDelta, Delta)
  else
    if Integer(lHDelta)+Delta > Integer(FColumns) then
      lHDelta := FColumns
    else
      Inc(lHDelta, Delta);

  if lhDelta < 0 then
    lhDelta := 0;

  if lHDelta <> SaveD then begin
    vlbSetHScrollPos;
    Refresh;
  end;
end;

procedure TOvcCustomVirtualListBox.vlbInitScrollInfo;
  {-setup scroll bar range and initial position}
begin
  if not HandleAllocated then
    Exit;

  {initialize scroll bars, if any}
  vlbSetVScrollRange;
  vlbSetVScrollPos;
  vlbSetHScrollRange;
  vlbSetHScrollPos;
end;

procedure TOvcCustomVirtualListBox.vlbMakeItemVisible(Index : Integer);
  {-make sure the item is visible}
begin
  if Index < FTopIndex then
    TopIndex := Index
  else if Index+Integer($80000000) > (FTopIndex+Pred(lRows))+Integer($80000000) then begin
    TopIndex := Index-Pred(lRows);
    if FTopIndex < 0 then
      TopIndex := 0;
  end;
end;

procedure TOvcCustomVirtualListBox.vlbNewActiveItem(Index : Integer);
  {-set the currently selected item}
begin
  {verify valid index}
  if Index < 0 then
    Index := 0
  else if Index > lHighIndex then
    Index := lHighIndex;

  {set the newly selected item index}
  FItemIndex := Index;
  vlbMakeItemVisible(Index);
  DoOnSelect(Index, True);
  InvalidateItem(Index);
end;

function TOvcCustomVirtualListBox.vlbScaleDown(N : Integer) : Integer;
begin
  Result := N div lDivisor;
end;

function TOvcCustomVirtualListBox.vlbScaleUp(N : Integer) : Integer;
begin
  Result := N * lDivisor;
end;

procedure TOvcCustomVirtualListBox.vlbSelectRangePrim(First, Last : Integer; Select : Boolean);
  {-change the selection for the given range of indexes}
var
  I : Integer;
begin
  if First <= Last then begin
    for I := First to Last do begin
      DoOnSelect(I, Select);
      InvalidateItem(I);
    end;
  end else begin
    for I := First downto Last do begin
      DoOnSelect(I, Select);
      InvalidateItem(I);
    end;
  end;
end;

procedure TOvcCustomVirtualListBox.vlbSetAllItemsPrim(Select : Boolean);
  {-primitive routine thats acts on all items}
var
  I         : Integer;
  LastIndex : Integer;
begin
  {determine highest index to test}
  LastIndex := FTopIndex+Pred(lRows);
  if LastIndex > Pred(FNumItems) then
    LastIndex := Pred(FNumItems);

  {invalidate items that require repainting}
  for I := FTopIndex to LastIndex do
    if DoOnIsSelected(I) <> Select then
      InvalidateItem(I);

  {select or deselect all items}
  DoOnSelect(-1, Select);
end;

procedure TOvcCustomVirtualListBox.vlbSetFocusedIndex(Index : Integer);
  {-set focus index to this item. invalidate previous}
begin
  if Index <> lFocusedIndex then begin
    InvalidateItem(lFocusedIndex);

    lFocusedIndex := Index;
    InvalidateItem(lFocusedIndex);
  end;
end;

{ rewritten - see below
procedure TOvcCustomVirtualListBox.vlbSetHScrollPos;
begin
  if lHaveHS then
    SetScrollPos(Handle, SB_HORZ, lHDelta, True);
end;
}

{ rewritten}
procedure TOvcCustomVirtualListBox.vlbSetHScrollPos;
var
  SI : TScrollInfo;
begin
  if lHaveHS and HandleAllocated then begin
    with SI do begin
      cbSize := SizeOf(SI);
      fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
      nMin := 0;
      nMax := FColumns;
      nPage := FColumns div 2;
      nPos := lhDelta;
      nTrackPos := nPos;
    end;
    SetScrollInfo(Handle, SB_HORZ, SI, True);
  end;
end;

{ rewritten - see below
procedure TOvcCustomVirtualListBox.vlbSetHScrollRange;
begin
  if lHaveHS then
    SetScrollRange(Handle, SB_HORZ, 0, FColumns, False);
end;
}

{ rewritten}
procedure TOvcCustomVirtualListBox.vlbSetHScrollRange;
{var
  SI : TScrollInfo;}
begin
  vlbSetHScrollPos;
  (*
  if lHaveHS then
    begin
      with SI do
        begin
          fMask := {SIF_PAGE + }SIF_RANGE;
          nMin  := 1;
          nMax := FColumns - ClientWidth;
          //nPage := nMax div 10;
          cbSize := SizeOf(SI);
        end;
      SetScrollInfo(Handle, SB_HORZ, SI, False);
    end;
  *)
end;

procedure TOvcCustomVirtualListBox.vlbSetSelRange(First, Last : Integer);
  {-set the selection on for the given range of indexes}
begin
  vlbSelectRangePrim(First, Last, True);
end;

procedure TOvcCustomVirtualListBox.vlbSetVScrollPos;
var
  SI : TScrollInfo;
begin
  if not HandleAllocated then
    Exit;
  with SI do begin
    cbSize := SizeOf(SI);
    fMask := SIF_RANGE or SIF_PAGE or SIF_POS;
    nMin := 0;
    nMax := Pred(lVSHigh);
    nPage := lRows;
    nPos := vlbScaleDown(FTopIndex);
    nTrackPos := nPos;
  end;
  SetScrollInfo(Handle, SB_VERT, SI, True);
end;

procedure TOvcCustomVirtualListBox.vlbSetVScrollRange;
var
  ItemRange : Integer;
begin
  ItemRange := FNumItems;
  lDivisor := 1;
  if ItemRange < lRows then
    lVSHigh := 1
  else if ItemRange <= High(SmallInt) then
    lVSHigh := ItemRange
  else begin
    lDivisor := 2*(ItemRange div 32768);
    lVSHigh := ItemRange div lDivisor;
  end;

  if lHaveVS then
    if not ((FNumItems > lRows) or (csDesigning in ComponentState)) then
      lvSHigh := 0
    else
  else
    lvSHigh := 0;
  vlbSetVScrollPos;
end;

procedure TOvcCustomVirtualListBox.vlbToggleSelection(Index : Integer);
  {-process Ctrl-LMouseBtn}
var
  WasSelected : Boolean;
begin
  if (Index < 0) or (Index > lHighIndex) then
    exit;
  {toggle highlight}
  WasSelected := DoOnIsSelected(Index);
  DoOnSelect(Index, not WasSelected);
  vlbSetFocusedIndex(Index);
  DrawItem(Index);
  {set new active item}
  FItemIndex := Index;
  {and anchor point}
  lAnchor := Index;
end;

procedure TOvcCustomVirtualListBox.vlbValidateItem(Index : Integer);
  {-validate the area for this item}
var
  CR : TRect;
begin
  if (Index >= FTopIndex) and (Index-FTopIndex < lRows) then begin  {visible?}
    CR := Rect(0, (Index-FTopIndex+Ord(FShowHeader))*FRowHeight, ClientWidth, 0);
    CR.Bottom := CR.Top+FRowHeight;
    ValidateRect(Handle, @CR);
  end;
end;

procedure TOvcCustomVirtualListBox.vlbVScrollPrim(Delta : Integer);
var
  I : Integer;
begin
  I := FTopIndex+Delta;
  if I < 0 then
    if Delta > 0 then
      I := lHighIndex
    else
      I := 0
  else if (I > lHighIndex-Pred(lRows)) then begin
    if lHighIndex > Pred(lRows) then
      I := lHighIndex-Pred(lRows)
    else
      I := 0;
  end;

  SetTopIndex(I);
end;

procedure TOvcCustomVirtualListBox.WMChar(var Msg : TWMChar);
var
  L : Integer;
begin
  inherited;

  L := DoOnCharToItem(Char(Msg.CharCode));
  if (L >= 0) and (L <= lHighIndex) then
    SetItemIndex(L);
end;

procedure TOvcCustomVirtualListBox.WMEraseBkgnd(var Msg : TWMEraseBkGnd);
begin
  {indicate that we have processed this message}
  Msg.Result := 1;
end;

procedure TOvcCustomVirtualListBox.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  inherited;

  Msg.Result := Msg.Result or DLGC_WANTCHARS or DLGC_WANTARROWS;
end;

procedure TOvcCustomVirtualListBox.WMHScroll(var Msg : TWMHScroll);
begin
  case Msg.ScrollCode of
    SB_LINERIGHT : vlbHScrollPrim(+1);
    SB_LINELEFT  : vlbHScrollPrim(-1);
    SB_PAGERIGHT : vlbHScrollPrim(+10);
    SB_PAGELEFT  : vlbHScrollPrim(-10);
    SB_THUMBPOSITION, SB_THUMBTRACK :
      if lHDelta <> Msg.Pos then begin
        lHDelta := Msg.Pos;
        vlbSetHScrollPos;
        Refresh;
      end;
  end;
end;

procedure TOvcCustomVirtualListBox.WMKeyDown(var Msg : TWMKeyDown);
var
  I   : Integer;
  Cmd : Word;
begin
  inherited;

  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  if Cmd <> ccNone then begin

    {filter invalid commands}
    case Cmd of
      ccExtendHome, ccExtendEnd, ccExtendPgUp,
      ccExtendPgDn, ccExtendUp, ccExtendDown :
        if not FMultiSelect then
          Exit;
    end;

    case Cmd of
      ccLeft :
        if lHaveHs then begin
          if lHDelta > 0 then begin
            Dec(lHDelta);
            vlbSetHScrollPos;
            Refresh;
          end;
        end else begin
          if FItemIndex > 0 then begin
            vlbClearAllItems;
            SetItemIndex(FItemIndex-1);
            lAnchor := FItemIndex;
          end;
        end;
      ccRight :
        if lHaveHs then begin
          if lHDelta < FColumns then begin
            Inc(lHDelta);
            vlbSetHScrollPos;
            Refresh;
          end;
        end else begin
          if FItemIndex < lHighIndex then begin
            vlbClearAllItems;
            SetItemIndex(FItemIndex+1);
            lAnchor := FItemIndex;
          end;
        end;
      ccUp :
        if FItemIndex > 0 then begin
          vlbClearAllItems;
          SetItemIndex(FItemIndex-1);
          lAnchor := FItemIndex;
        end;
      ccDown :
        if FItemIndex < lHighIndex then begin
          vlbClearAllItems;
          SetItemIndex(FItemIndex+1);
          lAnchor := FItemIndex;
        end;
      ccHome :
        if FItemIndex <> 0 then begin
          vlbClearAllItems;
          SetItemIndex(0);
          lAnchor := FItemIndex;
        end;
      ccEnd :
        if (FNumItems > 0) and (FItemIndex <> lHighIndex) then begin
          vlbClearAllItems;
          SetItemIndex(lHighIndex);
          lAnchor := FItemIndex;
        end;
      ccPrevPage :
        if FNumItems > 0 then begin
          if lRows = 1 then
            I := Pred(FItemIndex)
          else
            I := FItemIndex-Pred(lRows);
          if I < 0 then
            I := 0;
          if I <> FItemIndex then begin
            vlbClearAllItems;
            SetItemIndex(I);
            lAnchor := FItemIndex;
          end;
        end;
      ccNextPage :
        if FNumItems > 0 then begin
          if lRows = 1 then begin
            if FItemIndex < lHighIndex then
              I := Succ(FItemIndex)
            else
              I := lHighIndex;
          end else if FItemIndex <= lHighIndex-Pred(lRows) then
            I := FItemIndex+Pred(lRows)
          else
            I := lHighIndex;
          if I <> FItemIndex then begin
            vlbClearAllItems;
            SetItemIndex(I);
            lAnchor := FItemIndex;
          end;
        end;
      ccExtendHome :
        if FItemIndex > 0 then begin
          vlbNewActiveItem(0);
          vlbExtendSelection(0);
        end;
      ccExtendEnd :
        if FItemIndex < lHighIndex then begin
          vlbNewActiveItem(lHighIndex);
          vlbExtendSelection(lHighIndex);
        end;
      ccExtendPgUp :
       begin
          I := FItemIndex-Pred(lRows);
          vlbNewActiveItem(I);
          vlbExtendSelection(I);
       end;
      ccExtendPgDn :
        begin
          I := FItemIndex+Pred(lRows);
          vlbNewActiveItem(I);
          vlbExtendSelection(I);
        end;
      ccExtendUp :
        begin
          I := FItemIndex-1;
          vlbNewActiveItem(I);
          vlbExtendSelection(I);
        end;
      ccExtendDown :
        begin
          I := FItemIndex+1;
          vlbNewActiveItem(I);
          vlbExtendSelection(I);
        end;
    else
      {do user command notification for user commands}
      if Cmd >= ccUserFirst then
        DoOnUserCommand(Cmd);
    end;

    {indicate that this message was processed}
    Msg.Result := 0;
  end;
end;

procedure TOvcCustomVirtualListBox.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  {re-draw focused item to erase focus rect}
  DrawItem(lFocusedIndex);
end;

procedure TOvcCustomVirtualListBox.WMLButtonDown(var Msg : TWMLButtonDown);
var
  I            : Integer;
  LastI        : Integer;
  LButton      : Byte;
  CtrlKeyDown  : Boolean;
  ShiftKeyDown : Boolean;

  function PointToIndex : Integer;
  var
    Pt           : TPoint;
  begin
    GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    if Pt.Y < Ord(FShowHeader)*FRowHeight then begin
      {speed up as the cursor moves farther away}
      Result := FTopIndex+(Pt.Y div FRowHeight)-1;
      if Result < 0 then
        Result := 0;
    end else if Pt.Y >= ClientHeight then begin
      {speed up as the cursor moves farther away}
      Result := FTopIndex+(Pt.Y div FRowHeight);
      if Result > lHighIndex then
        Result := lHighIndex;
    end else begin
      {convert to an index}
      Result := FTopIndex-Ord(FShowHeader)+(Pt.Y div FRowHeight);
      if ClientHeight mod FRowHeight > 0 then
        if Result > FTopIndex-1 + lRows then
          Result := FTopIndex-1 + lRows;
    end;
  end;

var
  ItemNo : Integer;
  ShiftState: TShiftState;
begin
  ShiftState := KeysToShiftState(Msg.Keys);
  if (DragMode = dmAutomatic) and FMultiSelect then
  begin
    if not (ssShift in ShiftState) or (ssCtrl in ShiftState) then
    begin
      ItemNo := ItemAtPos(SmallPointToPoint(Msg.Pos), True);
      if (ItemNo >= 0) and (DoOnIsSelected(ItemNo)) then
      begin
        BeginDrag (False);
        Exit;
      end;
    end;
  end;
  inherited;
  if (DragMode = dmAutomatic) and not (FMultiSelect and
    ((ssCtrl in ShiftState) or (ssShift in ShiftState))) then
    BeginDrag(False);

  if MousePassThru then exit;

  {solve problem with minimized modeless dialogs and MDI child windows}
  {that contain virtual ListBox components}
  if not Focused and CanFocus then
    Windows.SetFocus(Handle);

  {is this click on the header?}
  if FShowHeader and (Msg.YPos < FRowHeight) then begin
    DoOnClickHeader(Point(Msg.XPos, Msg.YPos));
    Exit;
  end;

  if (FNumItems <> 0) then begin
    {get the actual left button}
    LButton := GetLeftButton;

    {get the key state}
    if FMultiSelect then begin
      CtrlKeyDown := GetKeyState(VK_CONTROL) and $8000 <> 0;
      ShiftKeyDown := GetKeyState(VK_SHIFT) and $8000 <> 0;
    end else begin
      CtrlKeyDown := False;
      ShiftKeyDown := False;
    end;

    if CtrlKeyDown then
      vlbToggleSelection(PointToIndex)
    else if ShiftKeyDown then
      vlbExtendSelection(PointToIndex)
    else begin
      vlbClearAllItems;

      {reselect the active item}
      if FItemIndex <> -1 then begin
        DoOnSelect(FItemIndex, True);
        vlbSetFocusedIndex(FItemIndex);
      end;

      {watch the mouse position while the left button is down}
      LastI := -1;
      repeat
        I := PointToIndex;
        if I <= lHighIndex then
          if not FMultiSelect or (LastI = -1) then begin
            SetItemIndex(I);
            lAnchor := I;
            LastI := I;
          end else begin
            {extend/shrink the selection to follow the mouse}
            if I <> LastI then begin
              vlbDragSelection(lAnchor, I);
              LastI := I;
            end;
          end;
        Application.ProcessMessages;  {Gasp}
      until (GetAsyncKeyState(LButton) and $8000 = 0) or Dragging
            or (GetCapture <> Handle);

    end;
  end;
end;

procedure TOvcCustomVirtualListBox.WMLButtonDblClk(var Msg : TWMLButtonDblClk);
begin
  {is this click below the header, if any}
  if (Msg.YPos > FRowHeight * Ord(FShowHeader)) then
    inherited
  else
    {say we processed this message}
    Msg.Result := 0;
end;

procedure TOvcCustomVirtualListBox.WMMouseActivate(var Msg : TWMMouseActivate);
begin
  if (csDesigning in ComponentState) or (GetFocus = Handle) then
    inherited
  else begin
    if Controller.ErrorPending then
      Msg.Result := MA_NOACTIVATEANDEAT
    else
      Msg.Result := MA_ACTIVATE;
  end;
end;

procedure TOvcCustomVirtualListBox.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  Update;
  DrawItem(lFocusedIndex);
end;

procedure TOvcCustomVirtualListBox.WMSize(var Msg : TWMSize);
begin
  if FRowHeight > 0 then begin
    {integral font height adjustment}
    vlbCalcFontFields;
    vlbAdjustIntegralHeight;
    vlbCalcFontFields;
    vlbInitScrollInfo;

    {reposition so that items are displayed at bottom of list}
    if lRows + FTopIndex - 1 >= FNumItems then
      if NumItems-lRows >= 0 then
        TopIndex := NumItems-lRows
      else
        TopIndex := 0;
  end;

  inherited;
end;

procedure TOvcCustomVirtualListBox.WMVScroll(var Msg : TWMVScroll);
var
  I : Integer;
begin
  case Msg.ScrollCode of
    SB_LINEUP   : vlbVScrollPrim(-1);
    SB_LINEDOWN : vlbVScrollPrim(+1);
    SB_PAGEDOWN : vlbVScrollPrim(+Pred(lRows));
    SB_PAGEUP   : vlbVScrollPrim(-Pred(lRows));
    SB_THUMBPOSITION, SB_THUMBTRACK :
      begin
        if Msg.Pos = 0 then
          I := 0
        else if Msg.Pos = lVSHigh then
          if lRows >= FNumItems then
            I := 0
          else
            I := lHighIndex-Pred(lRows)
        else
          I := vlbScaleUp(Msg.Pos);
        ForceTopIndex(I,True);
      end;
  end;
end;

{ new}
procedure TOvcCustomVirtualListBox.SetColumns(const Value: Integer);
begin
  if Value <> FColumns then begin
    FColumns := Value;
    vlbInitScrollInfo;
  end;
end;

end.

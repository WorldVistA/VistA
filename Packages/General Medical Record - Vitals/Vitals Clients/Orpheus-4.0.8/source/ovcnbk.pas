{*********************************************************}
{*                    OVCNBK.PAS 4.08                    *}
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
{*   Sebastian Zierer (Visual Styles)                                         *}
{*   Roman Kassebaum  (D2007 support)                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

(* Change Log)


  Const TRect params prevent the tabs from properly modifying the rects when
  they were drawn - 8/22/01 - PB.
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcnbk;
  {-Notebook component}

interface

uses
  UITypes, Types, Windows, Buttons, Classes, Controls, Forms, Graphics,
  Menus, Messages, SysUtils, StdCtrls, OvcBase, OvcCmd, OvcConst, OvcData, OvcExcpt,
  OvcMisc, Themes;

type
  TDrawTabEvent = procedure(Sender : TObject; Index : Integer;
    const Title : string; R : TRect; Enabled, Active : Boolean) of object;
  {event generated when drawing the tab text}
  TMouseOverTabEvent = procedure(Sender : TObject; Index : Integer) of object;
  {event generated when the mouse passes over a tab}
  TPageChangeEvent = procedure(Sender : TObject; Index : Integer;
    var AllowChange : Boolean) of object;
  {event generated when the tab is about to be changed}
  TPageChangedEvent = procedure(Sender : TObject; Index : Integer) of object;
  {event generated after a new tab has been selected}
  TTabClickEvent = procedure(Sender : TObject; Index : Integer) of object;
  {event generated when a tab is clicked with the left mouse button}

  TOvcTabOrientation = (toTop, toRight, toBottom, toLeft);
  TTabTextOrientation = (ttoHorizontal, ttoVerticalRight, ttoVerticalLeft);

  {forward declartion for notebook class}
  TOvcNotebook = class;

  TOvcTabPage = class(TOvcCollectibleControl)
  protected {private}
    {property variables}
    FArea        : TRect;      {tab dimensions}
    FRow         : Integer;    {row this tab is in}
    FTabColor    : TColor;     {color of the tab}
    FTabWidth    : Integer;    {width of this tab}
    FTextColor   : TColor;     {text color for tab text}
    FPageVisible : Boolean;    {true if tab is to be shown}

    {internal variables}
    NoteBook     : TOvcNotebook;

    {property methods}
    function GetCaption : string;
    function GetDummy : Integer;
    function GetIsEnabled : Boolean;
    procedure SetCaption(const Value : string);
    procedure SetDummy(Value : Integer);
    procedure SetIsEnabled(Value : Boolean);
    procedure SetTabColor(Value : TColor);
    procedure SetTextColor(Value : TColor);
    procedure SetPageVisible(Value : Boolean);

    {internal methods}

            {provide access to ancestors size properties}
    function tpGetHeight : Integer;
    function tpGetLeft : Integer;
    function tpGetTop : Integer;
    function tpGetWidth : Integer;

    procedure tpReadBoolean(Reader : TReader);
    procedure tpReadCursor(Reader : TReader);
    procedure tpReadInt(Reader : TReader);

    {message response methods}
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;

  protected
    {procedure AlignControls(AControl: TControl; var Rect: TRect);
      override;}
    procedure DefineProperties(Filer : TFiler);
      override;
    function GetBaseName : string;
      override;
    function GetDisplayText : string;
      override;
    procedure Paint; override;
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;

    {streaming hooks}
  public
    constructor Create(AOwner : TComponent);
      override;
    {procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;}

    property Area : TRect
      read FArea write FArea stored False;
    property Row : Integer
      read FRow write FRow;
    property TabWidth : Integer
      read FTabWidth write FTabWidth;

  published
    property Caption : string
      read GetCaption write SetCaption;
    property Enabled : Boolean
      read GetIsEnabled write SetIsEnabled
      default True;
    property PageVisible : Boolean
      read FPageVisible write SetPageVisible
      default True;
    property TabColor : TColor
      read FTabColor write SetTabColor default clBtnFace;
    property TextColor : TColor
      read FTextColor write SetTextColor default clBtnText;

    property Font;
    property Hint;
    property ParentFont;

    {hide these properties}
    property Cursor : Integer read GetDummy write SetDummy stored False;
    {property Height : Integer read GetDummy write SetDummy stored False;}
    {property Left : Integer read GetDummy write SetDummy stored False;}
    property TabOrder : Integer read GetDummy write SetDummy stored False;
    {property Top : Integer read GetDummy write SetDummy stored False;}
    {property Width : Integer read GetDummy write SetDummy stored False;}
    property Left stored False;
    property Top stored False;
    property Width stored False;
    property Height stored False;
  end;

  TOvcNotebook = class(TOvcCustomControlEx)
  protected {private}
    {property varialbes}
    FActiveTabFont     : TFont;         {font for the active tab}
    FConserveResources : Boolean;       {if true, non visual page handles are destroyed}
    FDefaultPageIndex  : Integer;       {page to display when first created}
    FHighlightColor    : TColor;        {color for border highlight}
    FOldStyle          : Boolean;       {Use old style tab painting}
    FPages             : TOvcCollection;{collection of tab pages}
    FPageIndex         : Integer;       {current notebook page index}
    FPageUsesTabColor  : Boolean;       {true forces page to use tab color}
    FShadowColor       : TColor;        {color for tab shadow}
    FShadowedText      : Boolean;       {true to draw shadowed tab text}
    FTabAutoHeight     : Boolean;       {true to enable height auto adjust}
    FTabHeight         : Integer;       {the height of each tab}
    FTabOrientation    : TOvcTabOrientation;
    FTabTextOrientation: TTabTextOrientation;
    FTabRowCount       : Integer;       {number of tab rows. 0=autocalc}
    FTabUseDefaultColor: Boolean;       {true to use page color}
    FTextShadowColor   : TColor;        {color for text shadowing}
    FUseActiveTabFont  : Boolean;

    {event variables}
    FOnDrawTab         : TDrawTabEvent;
    FOnMouseOverTab    : TMouseOverTabEvent;
    FOnPageChange      : TPageChangeEvent;
    FOnPageChanged     : TPageChangedEvent;
    FOnTabClick        : TTabClickEvent;
    FOnUserCommand     : TUserCommandEvent;

    {internal variables}
    {tabCanAlign    : Boolean;}
    tabFocusedRow  : Integer;    {index of the row containing the active tab}
    tabHitTest     : TPoint;     {location of mouse cursor}
    tabLastRow     : Integer;    {the last row index -- tabTotalRows-1}
    tabOverTab     : Boolean;    {true if the mouse is over a tab}
    tabPainting    : Boolean;    {true when painting}
    tabTabChanging : Boolean;    {flag to indicate the tab is changing}
    tabTabCursor   : HCursor;    {design-time tab slecting cursor handle}
    tabTabSelecting: Boolean;    {true while moving through tabs}
    tabTotalRows   : Integer;    {total count of tab rows}

    FHotTab: Integer; // Tab that should be painted with "hot" visual style

    {property methods}
    function GetClientHeight : Integer;
    function GetClientWidth : Integer;
    function GetPage(Index : Integer) : TOvcTabPage;
    function GetPageCount : Integer;
    procedure SetActiveTabFont(Value : TFont);
    procedure SetConserveResources(Value : Boolean);
    procedure SetHighlightColor(const Value : TColor);
    procedure SetOldStyle(Value : Boolean);
    procedure SetPageIndex(Value : Integer);
    procedure SetPageUsesTabColor(Value : Boolean);
    procedure SetShadowColor(const Value : TColor);
    procedure SetShadowedText(Value : Boolean);
    procedure SetTabAutoHeight(Value : Boolean);
    procedure SetTabColor(Value : TColor);
    procedure SetTabHeight(Value : Integer);
    procedure SetTabOrientation(Value : TOvcTabOrientation);
    procedure SetTabTextOrientation(Value: TTabTextOrientation);
    procedure SetTabRowCount(Value : Integer);
    procedure SetTabUseDefaultColor(Value : Boolean);
    procedure SetTextShadowColor(const Value : TColor);
    procedure SetUseActiveTabFont(Value : Boolean);

    {internal methods}
    procedure tabAdjustPageSize;
    procedure tabCalcTabInfo;
    procedure tabCollectionChanged(Sender : TObject);
    procedure tabCollectionItemSelected(Sender : TObject; Index : Integer);
    procedure tabGetEditorCaption(var Caption : string);
    procedure tabDrawFocusRect(Index : Integer);
    procedure tabFontChanged(Sender : TObject);
    procedure tabPaintBottomTabs;
    procedure tabPaintLeftTabs;
    procedure tabPaintRightTabs;
    procedure tabPaintTopTabs;
    function tabGetTabRect(Index : Integer) : TRect;
    function IsTabHeightStored: Boolean;

    {VCL control methods}
    procedure CMColorChanged(var Msg : TMessage);
      message CM_COLORCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMDialogChar(var Msg : TCMDialogChar);
      message CM_DIALOGCHAR;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;
    procedure CMParentColorChanged(var Msg : TMessage);
      message CM_PARENTCOLORCHANGED;

    {windows message response methods}
    procedure WMEraseBkgnd(var Msg : TWMEraseBkgnd);
      message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMMouseActivate(var Msg : TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
    procedure WMSetCursor(var Msg : TWMSetCursor);
      message WM_SETCURSOR;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    procedure AncestorNotFound(Reader: TReader; const ComponentName: string;
      ComponentClass: TPersistentClass; var Component: TComponent);
    procedure ChangeScale(M, D : Integer);
      override;
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure Loaded; override;
    procedure Paint;
      override;
    procedure ShowControl(AControl : TControl);
      override;

    {dynamic event handlers}
    function DoOnDrawTab(Index : Integer; const Title : string;
             Enabled, Active : Boolean) : Boolean;
      dynamic;
    procedure DoOnMouseOverTab(Index : Integer);
      dynamic;
    procedure DoOnPageChange(Index : Integer; var AllowChange : Boolean);
      dynamic;
    procedure DoOnPageChanged(Index : Integer);
      dynamic;
    procedure DoOnTabClick(Index : Integer);
      dynamic;
    procedure DoOnUserCommand(Command : Word);
      dynamic;

    {vcl methods}
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y: Integer);
      override;
    procedure ReadState(Reader : TReader);
      override;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;

    procedure BeginUpdate;
      {-suspend window updates}
    procedure EndUpdate;
      {-allow window updates}
    function GetTabRect(Index : Integer) : TRect;
      {-return the area of the specified tab}
    procedure DeletePage(Index : Integer);
      {-delete the specified notebook page}
    procedure ForcePageHandles;
      {-call HandleNeeded for each page in notebook}
    function IndexOf(const Name : string;
                     ByCaption : Boolean) : Integer;
      {-return page index given the page name or caption}
    procedure InsertPage(const Name : string; Index : Integer);
      {-insert a notebook page at the specified location}
    procedure InvalidateTab(Index : Integer);
      {-invalidate the specified tab}
    function IsValid(Index : Integer) : Boolean;
      {-return true if the Index tab is valid}
    procedure NextPage;
      {-display the next valid notebook page}
    function NextValidIndex(Index : Integer) : Integer;
      {-change to the next valid tab page}
    function PrevValidIndex(Index : Integer) : Integer;
      {-change to the previous valid tab page}
    procedure PrevPage;
      {-display the previous valid notebook page}
    function PageNameToIndex(const Name : string) : Integer;
      {-return page index given the page caption}
    function TabsInRow(Row : Integer) : Integer;
      {-return the nuber of tabs in Row}

    property Canvas;

    property ClientHeight : Integer
      read GetClientHeight;
    property ClientWidth : Integer
      read GetClientWidth;
    property PageCount : Integer
      read GetPageCount;
    property Pages[Index : Integer] : TOvcTabPage
      read GetPage;

  published
    property UseActiveTabFont : Boolean
      read FUseActiveTabFont write SetUseActiveTabFont
      default True;
    property ActiveTabFont : TFont
      read FActiveTabFont write SetActiveTabFont
      stored FUseActiveTabFont;
    property ConserveResources : Boolean
      read FConserveResources write SetConserveResources
      default False;
    property DefaultPageIndex : Integer
      read FDefaultPageIndex write FDefaultPageIndex
      default 0;
    property HighlightColor : TColor
      read FHighlightColor write SetHighlightColor
      default clBtnHighlight;
    property OldStyle : Boolean
      read FOldStyle write SetOldStyle
      default False;
    property PageIndex : Integer
      read FPageIndex write SetPageIndex stored False;
    property PageCollection : TOvcCollection
      read FPages write FPages;
    property PageUsesTabColor : Boolean
      read FPageUsesTabColor write SetPageUsesTabColor
      default True;
    property ShadowColor : TColor
      read FShadowColor write SetShadowColor
      default clBtnShadow;
    property ShadowedText : Boolean
      read FShadowedText write SetShadowedText
      default False;
    property TabAutoHeight : Boolean
      read FTabAutoHeight write SetTabAutoHeight
      default True;
    property TabHeight : Integer
      read FTabHeight write SetTabHeight
      stored IsTabHeightStored
      default 20;
    property TabOrientation : TOvcTabOrientation
      read FTabOrientation write SetTabOrientation
      default toTop;
    property TabTextOrientation: TTabTextOrientation
      read FTabTextOrientation write SetTabTextOrientation
      default ttoHorizontal;
    property TabRowCount : Integer
      read FTabRowCount write SetTabRowCount
      default 0;
    property TextShadowColor : TColor
      read FTextShadowColor write SetTextShadowColor
      default clBtnShadow;
    property TabUseDefaultColor : Boolean
      read FTabUseDefaultColor write SetTabUseDefaultColor
      default True;

    {event properties}
    property OnDrawTab : TDrawTabEvent
      read FOnDrawTab write FOnDrawTab;
    property OnMouseOverTab : TMouseOverTabEvent
      read FOnMouseOverTab write FOnMouseOverTab;
    property OnPageChange : TPageChangeEvent
      read FOnPageChange write FOnPageChange;
    property OnPageChanged : TPageChangedEvent
      read FOnPageChanged write FOnPageChanged;
    property OnTabClick : TTabClickEvent
      read FOnTabClick write FOnTabClick;
    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand write FOnUserCommand;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property Controller;
    property Color default clBtnFace;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LabelInfo;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
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
    property OnStartDrag;
  end;

implementation

uses
  UxTheme, Math;

type
  {provide access to protected TControl methods and properties}
  TLocalControl = class(TControl);

const
  tabTabBorder   = 6;
  tabFontName    = 'Arial';
  tabMinTabWidth = 20;
  tabMargin      = 2;

function ThemesEnabled: Boolean; inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices; inline;
begin
  Result := StyleServices;
end;

{*** TOvcTabPage ***}

procedure TOvcTabPage.CMFontChanged(var Msg : TMessage);
var
  TM : TTextMetric;
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if not HandleAllocated then
    Exit;

  {check if the new font can be rotated}
  if Notebook.TabOrientation in [toRight, toLeft] then begin
    {test font}
    Canvas.Font := Font;
    GetTextMetrics(Canvas.Handle, TM);
    if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then begin
      {force font}
      Font.Name := tabFontName;
      raise EInvalidTabFont.Create;
    end;
  end;

  Notebook.Invalidate;
end;

procedure TOvcTabPage.CMMouseenter(var Message: TMessage);
begin
  inherited;

  if NoteBook.FHotTab <> -1 then
  begin
      if ThemesEnabled then
        NoteBook.InvalidateTab(NoteBook.FHotTab);
    NoteBook.FHotTab := -1;
  end;
end;

constructor TOvcTabPage.Create(AOwner : TComponent);
begin
  Notebook := (AOwner as TOvcNotebook);

  inherited Create(AOwner);

  FPageVisible := True;
  FTabColor    := clBtnFace;
  FTabWidth    := 65;
  FTextColor   := clBtnText;

  ControlStyle := ControlStyle +
    [csAcceptsControls, csCaptureMouse, csClickEvents];

  Enabled := True;
  Parent := Notebook;
  TabStop := False;
  ParentFont := True;
  ParentShowHint := True;
end;

procedure TOvcTabPage.DefineProperties(Filer : TFiler);
begin
  inherited DefineProperties(Filer);

  {these properties may be in the stream from an earlier version}
  {this allows us to read and ignore them}
  Filer.DefineProperty('Cursor', tpReadCursor, nil, False);
  Filer.DefineProperty('Top', tpReadInt, nil, False);
  Filer.DefineProperty('Left', tpReadInt, nil, False);
  Filer.DefineProperty('Height', tpReadInt, nil, False);
  Filer.DefineProperty('Width', tpReadInt, nil, False);
  Filer.DefineProperty('Visible', tpReadBoolean, nil, False);
end;

function TOvcTabPage.GetBaseName : string;
begin
  Result := GetOrphStr(SCPageBaseName);
end;

function TOvcTabPage.GetCaption : string;
begin
  Result := inherited Caption;
end;

function TOvcTabPage.GetDisplayText : string;
begin
  if Caption > '' then
    Result := Caption + ': ' + ClassName
  else
    Result := Name + ': ' + ClassName;
end;

function TOvcTabPage.GetDummy : Integer;
begin
  Result := 0;
end;

function TOvcTabPage.GetIsEnabled : Boolean;
begin
  Result := inherited Enabled;
end;

procedure TOvcTabPage.Paint;
var
  Details: TThemedElementDetails;
begin
  if ThemesEnabled and ((not Assigned(Notebook)) or (Notebook.Color=clBtnface)) then
  begin
    Details := ThemeServices.GetElementDetails(ttBody);
    ThemeServices.DrawElement(Canvas.Handle, Details, ClientRect);
  end
  else
    inherited;
end;

procedure TOvcTabPage.SetCaption(const Value : string);
begin
  inherited Caption := Value;

  Notebook.Invalidate;
  if not (csLoading in ComponentState) then
    Changed;
end;

procedure TOvcTabPage.SetDummy(Value : Integer);
begin
end;

procedure TOvcTabPage.SetIsEnabled(Value : Boolean);
begin
  inherited Enabled := Value;

  Notebook.Invalidate;
end;

procedure TOvcTabPage.SetPageVisible(Value : Boolean);
begin
  FPageVisible := Value;
  Notebook.Invalidate;
end;

procedure TOvcTabPage.SetTabColor(Value : TColor);
begin
  if Value <> FTabColor then begin
    FTabColor := Value;
    InvalidateRect(Notebook.Handle, @FArea, False);
  end;
end;

procedure TOvcTabPage.SetTextColor(Value : TColor);
begin
  if Value <> FTextColor then begin
    FTextColor := Value;
    InvalidateRect(Notebook.Handle, @FArea, False);
  end;
end;


function TOvcTabPage.tpGetHeight : Integer;
begin
  Result := inherited Height;
end;


function TOvcTabPage.tpGetLeft : Integer;
begin
  Result := inherited Left;
end;


function TOvcTabPage.tpGetTop : Integer;
begin
  Result := inherited Top;
end;


function TOvcTabPage.tpGetWidth : Integer;
begin
  Result := inherited Width;
end;

procedure TOvcTabPage.tpReadBoolean(Reader : TReader);
begin
  Reader.ReadBoolean;
end;

procedure TOvcTabPage.tpReadCursor(Reader : TReader);
begin
  Reader.ReadInteger;
end;

procedure TOvcTabPage.tpReadInt(Reader : TReader);
begin
  Reader.ReadInteger;
end;

procedure TOvcTabPage.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  if not (csDesigning in ComponentState) then
    Msg.Result := HTTRANSPARENT
  else
    inherited;
end;


{*** TOvcNotebook ***}

procedure TOvcNotebook.BeginUpdate;
begin
  Perform(WM_SETREDRAW, 0, 0);
end;

procedure TOvcNotebook.CMColorChanged(var Msg : TMessage);
var
  I : Integer;
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if not tabPainting then begin
    FPageUsesTabColor := False;
    {change all of the tab colors (not using the TabColor property)}
    if FTabUseDefaultColor then begin
      for I := 0 to FPages.Count-1 do
        TOvcTabPage(FPages[I]).TabColor := Color;
    end;
  end;
end;

procedure TOvcNotebook.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  Msg.Result := NativeInt(tabOverTab);
end;

procedure TOvcNotebook.CMDialogChar(var Msg : TCMDialogChar);
var
  FoundAccel : Boolean;
  Idx, I     : Integer;
  TP         : TOvcTabPage;
  C          : TWinControl;
begin
  FoundAccel := False;
  if Enabled then begin
    {remember where to stop}
    Idx := PageIndex;
    I := Idx;
    repeat
      Inc(I);
      if I > FPages.Count-1 then
        I := 0;
      TP := TOvcTabPage(FPages[I]);
      if ISAccel(Msg.CharCode, TP.Caption) then begin
        if IsValid(I) and CanFocus then begin
          FoundAccel := True;

          {if were already on the selected page, give tab focus}
          if I = PageIndex then
            SetFocus
          else begin {otherwise, change to it}
            PageIndex := I;

            {move focus to first control on the page}
            C := TOvcTabPage(FPages[PageIndex]).FindNextControl(nil, True, True, False);
            if Assigned(C) then
              C.SetFocus
            else  {set the focus to the tab}
              SetFocus;

            if PageIndex = I then
              DoOnTabClick(I);
          end;
          Break;
        end;
        Break;
      end;
    until I = Idx;
  end;

  if not FoundAccel then
    inherited
  else
    Msg.Result := 1;
end;

procedure TOvcNotebook.CMFontChanged(var Msg : TMessage);
var
  TM : TTextMetric;
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if not HandleAllocated then
    Exit;

  {check if the new font can be rotated}
  if FTabOrientation in [toRight, toLeft] then begin
    {test primary tab font}
    Canvas.Font := Self.Font;
    GetTextMetrics(Canvas.Handle, TM);
    if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then begin
      {force font}
      Font.Name := tabFontName;
      raise EInvalidTabFont.Create;
    end;

    {test active tab font}
    if FUseActiveTabFont then begin
      Canvas.Font := FActiveTabFont;
      GetTextMetrics(Canvas.Handle, TM);
      if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then begin
        {force font}
        FActiveTabFont.Name := tabFontName;
        raise EInvalidTabFont.Create;
      end;
    end;
  end;

  {redraw the notebook}
  Refresh;
end;

procedure TOvcNotebook.CMMouseleave(var Message: TMessage);
begin
  if FHotTab <> -1 then
    InvalidateTab(FHotTab);
  FHotTab := -1;
  inherited;
end;

procedure TOvcNotebook.CMParentColorChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  {redraw the notebook}
  Refresh;
end;

constructor TOvcNotebook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csOpaque];

  {TabTabSelecting          := False;} {redundant}

  FHotTab := -1;

  {create font for the active tab and set the default}
  FActiveTabFont          := TFont.Create;
  FActiveTabFont.Name     := Font.Name;
  FActiveTabFont.OnChange := tabFontChanged;


  {FConserveResources      := False;} {redundant}
  {FDefaultPageIndex       := 0;} {redundant}
  FHighlightColor         := clBtnHighlight;
  {FPageIndex              := 0;} {redundant}
  FPageUsesTabColor       := True;
  FShadowColor            := clBtnShadow;
  {FShadowedText           := False;} {redundant}
  FTabAutoHeight          := True;
  FTabHeight              := 20;
  {FTabRowcount            := 0;} {redundant}
  FTabUseDefaultColor     := True;
  FTextShadowColor        := clBtnShadow;
  FUseActiveTabFont       := True;

  tabPainting := True;
  try
    Color                 := clBtnFace;
  finally
    tabPainting := False;
  end;

  Height                  := 185;
  ParentColor             := False;
  TabStop                 := True;
  Width                   := 220;

  if Classes.GetClass(TOvcTabPage.ClassName) = nil then
    Classes.RegisterClass(TOvcTabPage);
//  if Classes.GetClass(TOvcTabPage.ClassName) = nil then
//    Classes.RegisterClass(TOvcTabPage);

  FPages := TOvcCollection.Create(Self, TOvcTabPage);
  FPages.OnChanged := tabCollectionChanged;
  FPages.OnItemSelected := tabCollectionItemSelected;
  FPages.OnGetEditorCaption := tabGetEditorCaption;

  {load design-time cursor}
  if csDesigning in ComponentState then begin
    tabTabCursor := LoadBaseCursor('ORTABCURSOR');
    {tabCanAlign := True;}
  end;
end;

procedure TOvcNotebook.ChangeScale(M, D : Integer);
begin
  inherited ChangeScale(M, D);

  if M <> D then begin
    {scale the tab height and widths}
    TabHeight := MulDiv(FTabHeight, M, D);

    {scale the active tab font. "inherited" scales normal font}
    FActiveTabFont.Size := MulDiv(FActiveTabFont.Size, M, D);

    tabCalcTabInfo;
  end;
end;

procedure TOvcNotebook.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Style or WS_CLIPCHILDREN;
    if not (csDesigning in ComponentState) then
      WindowClass.Style := WindowClass.Style and not CS_DBLCLKS;
  end;
end;

procedure TOvcNotebook.CreateWnd;
begin
  inherited CreateWnd;

  {force the default "first page" to be TopMost}
  if IsValid(PageIndex) then
    with TOvcTabPage(FPages[PageIndex]) do begin
      Visible := True;
      BringToFront;
    end;
end;

destructor TOvcNotebook.Destroy;
begin
  FPages.Free;
  FPages := nil;

  FActiveTabFont.Free;
  FActiveTabFont := nil;

  {destroy design-time cursor}
  if (csDesigning in ComponentState) and (tabTabCursor <> 0) then
    DestroyCursor(tabTabCursor);

  inherited Destroy;
end;

function TOvcNotebook.DoOnDrawTab(Index : Integer; const Title : string;
         Enabled, Active : Boolean) : Boolean;
var
  R : TRect;
begin
  Result := Assigned(FOnDrawTab) and
            (Index > -1) and (Index < FPages.Count);
  if Result then begin
    R := tabGetTabRect(Index);
    FOnDrawTab(Self, Index, Title, R, Enabled, Active);
  end;
end;

procedure TOvcNotebook.DoOnMouseOverTab(Index : Integer);
begin
  if Assigned(FOnMouseOverTab) then
    FOnMouseOverTab(Self, Index);
end;

procedure TOvcNotebook.DoOnPageChange(Index : Integer; var AllowChange : Boolean);
begin
 if Assigned(FOnPageChange) then
   FOnPageChange(Self, Index, AllowChange);
end;

procedure TOvcNotebook.DoOnPageChanged(Index : Integer);
begin
  if Assigned(FOnPageChanged) then
    FOnPageChanged(Self, Index);
end;

procedure TOvcNotebook.DoOnTabClick(Index : Integer);
begin
  if Assigned(FOnTabClick) then
    FOnTabClick(Self, Index);
end;

procedure TOvcNotebook.DoOnUserCommand(Command : Word);
begin
  if Assigned(FOnUserCommand) then
    FOnUserCommand(Self, Command);
end;

procedure TOvcNotebook.EndUpdate;
begin
  Perform(WM_SETREDRAW, 1, 0);
  Invalidate;
end;

procedure TOvcNotebook.ForcePageHandles;
var
  I : Integer;
  P : TOvcTabPage;
begin
  for I := 0 to FPages.Count-1 do begin
    P := Pages[I];
    P.DisableAlign;
    try
      P.HandleNeeded;
      P.ControlState := P.ControlState - [csAlignmentNeeded];
    finally
      P.EnableAlign;
    end;
  end;
end;

function TOvcNotebook.GetClientHeight : Integer;
begin
  if IsValid(PageIndex) then
    Result := TOvcTabPage(FPages[PageIndex]).tpGetHeight
  else
    Result := 0;
end;

function TOvcNotebook.GetClientWidth : Integer;
begin
  if IsValid(PageIndex) then
    Result := TOvcTabPage(FPages[PageIndex]).tpGetWidth
  else
    Result := 0;
end;

function TOvcNotebook.GetPage(Index : Integer) : TOvcTabPage;
begin
  if (Index > -1) and (Index < FPages.Count) then
    Result := TOvcTabPage(FPages[Index])
  else
    Result := nil;
end;

function TOvcNotebook.GetPageCount : Integer;
begin
  Result := FPages.Count;
end;

function TOvcNotebook.GetTabRect(Index : Integer) : TRect;
begin
  if (Index > -1) and (Index < FPages.Count) then
    Result := TOvcTabPage(FPages[Index]).Area
  else
    Result := Rect(0, 0, 0, 0);
end;

procedure TOvcNotebook.DeletePage(Index : Integer);
var
  CurIndex : Integer;
begin
  if (Index > -1) and (Index < FPages.Count) and (FPages.Count > 0) then begin
    {hide the currently active page}
    CurIndex := PageIndex;
    TOvcTabPage(FPages[CurIndex]).Visible := False;

    {delete the requested page}
    FPages.Delete(Index);

    if IsValid(CurIndex) then begin
      with TOvcTabPage(FPages[CurIndex]) do begin
        Visible := True;
        BringToFront;
      end;
    end else if IsValid(0) then
      PageIndex := 0;

    {force recalculation for alignment settings}
    if Align <> alNone then begin
      tabCalcTabInfo;
      SetBounds(Left, Top, Width, Height);
    end;

    Invalidate;
  end;
end;

function TOvcNotebook.IndexOf(const Name : string;
                              ByCaption : Boolean) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to FPages.Count-1 do begin
    if (ByCaption) then begin
      if (CompareText(Name, TOvcTabPage(FPages[I]).Caption) = 0) then begin
        Result := I;
        Break;
      end;
    end else begin
      if (CompareText(Name, TOvcTabPage(FPages[I]).Name) = 0) then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;


procedure TOvcNotebook.InsertPage(const Name : string; Index : Integer);
var
  Idx : Integer;
begin
  if (Index > -1) and (Index <= FPages.Count) then begin
    FPages.Insert(Index);
    TOvcTabPage(FPages[Index]).Caption := Name;

    {force recalculation for alignment settings}
    if Align <> alNone then begin
      tabCalcTabInfo;
      SetBounds(Left, Top, Width, Height);
    end;

    {see if we need to shift the active page}
    if Index <= FPageIndex then begin
      Idx := FPageIndex+1;
      if Idx > FPages.Count-1 then
        Idx := FPages.Count-1;
      FPageIndex := -1;
      SetPageIndex(Idx);
    end;

    if FPages.Count = 1 then
      PageIndex := 0
    else
      PageIndex := Index;

    Invalidate;
  end else
    raise EInvalidPageIndex.Create;
end;

procedure TOvcNotebook.Loaded;
var
  I         : Integer;
  {SaveAlign : TAlign;}
begin
  inherited Loaded;
  if FPages.Count > 0 then begin
    FPageIndex := FDefaultPageIndex;

    {hide all tab pages except the active one}
    for I := 0 to FPages.Count - 1 do begin
      if I <> FPageIndex then begin
        TOvcTabPage(FPages[I]).Visible := False;

        {destroy handles of hidden page and contents}
        if ConserveResources and not (csDesigning in ComponentState) then
          TOvcTabPage(FPages[I]).DestroyHandle;
      end;

      {force default page to refresh}
      FPageIndex := -1;
      PageIndex := FDefaultPageIndex;
    end;
  end;
  tabCalcTabInfo;
end;

procedure TOvcNotebook.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  I  : Integer;
  C  : TWinControl;
  PC : TOvcTabPage;
  PF : TCustomForm;
begin
  if Button = mbLeft then begin
    if GetFocus = Handle then
      tabTabSelecting := True
    else
      tabTabSelecting := False;
    for I := 0 to Pred(FPages.Count) do begin
      PC := TOvcTabPage(FPages[I]);

      {is this a click on a visible tab?}
      if PageIndex <> I then begin

        {is click in tab area and tab accessible}
        if (PC.Enabled or (csDesigning in ComponentState)) and
            (PC.PageVisible or (csDesigning in ComponentState)) and
              PtInRect(PC.Area, Point(X,Y)) then begin

          {if everything is going well (no errors on page), we should be focused}
          if (GetFocus <> Handle) and not (csDesigning in ComponentState) then begin
            {if not, cancel any modes that we might be in and don't change pages}
            Perform(WM_CANCELMODE, 0, 0);
            Exit;
          end;

          PageIndex := I;
          {if we couldn't change pages, exit}
          if PageIndex <> I then
            Exit;

          if not (csDesigning in ComponentState) then begin
            {move focus to first control on the page}
            PF := TCustomForm(GetParentForm(Self));
            if Assigned(PF) then begin
              C := FindNextControl(nil, True, True, False);
              if not Assigned(C) then
                C := FindNextControl(nil, True, False, False);
              if Assigned(C) and (C <> TOvcTabPage(FPages[PageIndex])) then
                PF.ActiveControl := C
              else
                SetFocus;
            end else
              SetFocus;
          end else begin
            PF := TCustomForm(GetParentForm(Self));
            if Assigned(PF) and (PF.Designer <> nil) then
              PF.Designer.Modified;
          end;
          DoOnTabClick(I);
          Break;
        end;

        if PtInRect(PC.Area, Point(X,Y)) then
          DoOnTabClick(I);
      end else if PtInRect(PC.Area, Point(X,Y)) then begin
        {tab is already the active tab, so focus it}
        SetFocus;
        DoOnTabClick(I);
        Break;
      end;
    end;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TOvcNotebook.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I    : Integer;
  PC   : TOvcTabPage;
  FoundTab: Boolean;
begin
  FoundTab := False;
  for I := 0 to Pred(FPages.Count) do begin
    PC := TOvcTabPage(FPages[I]);
    if PtInRect(PC.Area, Point(X,Y)) then
    begin
      FoundTab := True;
      if ThemesEnabled then
        if FHotTab <> I then
        begin
          if FHotTab <> -1 then
            InvalidateTab(FHotTab);
          FHotTab := I;
          InvalidateTab(FHotTab);
        end;

      DoOnMouseOverTab(I);
      Break;
    end;
  end;

  if not FoundTab then
  begin
    if FHotTab <> -1 then
    begin
      if ThemesEnabled then
        InvalidateTab(FHotTab);
      FHotTab := -1;
    end;
  end;

  inherited MouseMove(Shift, X, Y);
end;

procedure TOvcNotebook.InvalidateTab(Index : Integer);
var
  R : TRect;
begin
  if (Index > -1) and (Index < FPages.Count) then begin
    R := TOvcTabPage(FPages[Index]).Area;
    {increase to include border of pages}
    case FTabOrientation of
      toTop    : Inc(R.Bottom, 5);
      toBottom : Dec(R.Top, 5);
      toRight  : Dec(R.Left, 5);
      toLeft   : Inc(R.Right, 5);
    end;
    if HandleAllocated then
      InvalidateRect(Handle, @R, False);
  end;
end;

function TOvcNotebook.IsValid(Index : Integer) : Boolean;
begin
  Result := (Index > -1) and
            (Index < FPages.Count) and
            ((TOvcTabPage(FPages[Index]).Enabled) or (csDesigning in ComponentState)) and
            ((TOvcTabPage(FPages[Index]).PageVisible) or (csDesigning in ComponentState));
end;

function TOvcNotebook.NextValidIndex(Index : Integer) : Integer;
begin
  {insure passed index is in valid range}
  if (Index < 0) or (Index > FPages.Count-1) then
    Index := FPages.Count-1;

  {search for next valid index}
  Result := Succ(Index);
  while (not IsValid(Result)) and (Result <> Index) do begin
    Inc(Result);
    if Result > FPages.Count-1 then
      Result := 0;
  end;

  if (not IsValid(Result)) or (Result = Index) then
    Result := -1;
end;

function TOvcNotebook.PrevValidIndex(Index : Integer) : Integer;
begin
  {insure passed index is in valid range}
  if (Index < 0) or (Index > FPages.Count-1) then
    Index := 0;

  {search for next valid index}
  Result := Pred(Index);
  while (not IsValid(Result)) and (Result <> Index) do begin
    Dec(Result);
    if Result < 0  then
      Result := FPages.Count-1;
  end;

  if (not IsValid(Result)) or (Result = Index) then
    Result := -1;
end;

procedure TOvcNotebook.NextPage;
var
  I : Integer;
begin
  I := NextValidIndex(PageIndex);
  if I > -1 then
    PageIndex := I;
end;

procedure TOvcNotebook.PrevPage;
var
  I : Integer;
begin
  I := PrevValidIndex(PageIndex);
  if I > -1 then
    PageIndex := I;
end;

function TOvcNotebook.PageNameToIndex(const Name : string) : Integer;
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to FPages.Count-1 do
    if CompareText(Name, TOvcTabPage(FPages[I]).Caption) = 0 then begin
      Result := I;
      Break;
    end;
end;

procedure TOvcNotebook.Paint;
begin
  inherited Paint;

  if FPages.Count > 0 then begin
    tabCalcTabInfo;
    tabAdjustPageSize;
    if TabHeight > 0 then
      case FTabOrientation of
        toTop    : tabPaintTopTabs;
        toBottom : tabPaintBottomTabs;
        toRight  : tabPaintRightTabs;
        toLeft   : tabPaintLeftTabs;
      end;
  end else begin
    {if no tabs defined, just paint the complete client area}
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;
    Canvas.Rectangle(0, 0, Width, Height);
    if csDesigning in ComponentState then begin
      Canvas.Font := Font;
      Canvas.TextOut(5, 5, GetOrphStr(SCNoPagesAssigned));
    end;
  end;
end;

procedure TOvcNotebook.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  if not (csLoading in ComponentState) then begin
    {restrict minimum width/height}
    if FTabOrientation in [toTop, toBottom] then
      AWidth := MaxI(tabMinTabWidth, AWidth)
    else
      AHeight := MaxI(tabMinTabWidth, AHeight);
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if HandleAllocated then begin
    tabCalcTabInfo;
    tabAdjustPageSize;
  end;
end;

procedure TOvcNotebook.SetActiveTabFont(Value : TFont);
begin
  FActiveTabFont.Assign(Value);
  Invalidate;
end;

procedure TOvcNotebook.SetConserveResources(Value : Boolean);
var
  I : Integer;
begin
  if Value <> FConserveResources then begin
    FConserveResources := Value;
    if Value and not (csDesigning in ComponentState) then
      for I := 0 to FPages.Count - 1 do
        if I <> PageIndex then
          {destroy handles of hidden pages and their components}
          TOvcTabPage(FPages[I]).DestroyHandle;
  end;
end;

procedure TOvcNotebook.SetOldStyle(Value : Boolean);
begin
  if Value <> FOldStyle then begin
    FOldStyle := Value;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetHighlightColor(const Value : TColor);
begin
  if Value <> FHighlightColor then begin
    FHighlightColor := Value;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetPageIndex(Value : Integer);
var
  PF         : TCustomForm;
  OkToChange : Boolean;
  OldIdx     : Integer;
begin
  if csLoading in ComponentState then begin
    {must be setting the default}
    FPageIndex := Value;
    Exit;
  end;

  {save previous page index}
  OldIdx := FPageIndex;

  if (Value <> FPageIndex) and IsValid(Value) then begin
    if tabTabChanging then
      Exit;
    tabTabChanging := True;
    try
      if not (csDesigning in ComponentState) then begin
        OkToChange := True;

        {ask user if this is ok}
        if OldIdx <> -1 then
          DoOnPageChange(Value, OkToChange);
        if not OkToChange then
          Exit;
      end;

      PF := TCustomForm(GetParentForm(Self));
      {are we a parent of the active control}
      if (PF <> nil) then
        if ContainsControl(PF.ActiveControl) then begin
          PF.ActiveControl := nil;

          //Fix for problem 667973.
          // We try to remove focus from the current control above, but the
          // control may refuse to let focus go away, if it does we can't
          // continue with the page change operation.
          if PF.ActiveControl<>nil then exit;
        end;


      with TOvcTabPage(FPages[Value]) do begin
        BringToFront;
        Visible := True;
        {Enabled := True;}
      end;

      if IsValid(FPageIndex) then begin
        {hide the current page}
        TOvcTabPage(FPages[FPageIndex]).Visible := False;

        {destroy handles of hidden page and contents}
        if ConserveResources and not (csDesigning in ComponentState) then
          TOvcTabPage(FPages[FPageIndex]).DestroyHandle;
      end;

      FPageIndex := Value;
      tabFocusedRow := TOvcTabPage(FPages[FPageIndex]).Row;

      {change the notebooks hint and help context}
      HelpContext := TOvcTabPage(FPages[FPageIndex]).HelpContext;
      Hint := TOvcTabPage(FPages[FPageIndex]).Hint;

(*
      {if we are selecting the tab using the arrow keys}
      if tabTabSelecting then
        SetFocus;
*)

      Invalidate;
    finally
      tabTabChanging := False;
      {report page change}
      if not (csDesigning in ComponentState) and (Value = FPageIndex) then
        if OldIdx <> -1 then
          DoOnPageChanged(FPageIndex);
    end;
  end else if not IsValid(Value) then
    raise EInvalidPageIndex.Create;

  if not IsValid(FPageIndex) then
    raise EInvalidPageIndex.Create;
end;

procedure TOvcNotebook.SetPageUsesTabColor(Value : Boolean);
begin
  if Value <> FPageUsesTabColor then begin
    FPageUsesTabColor := Value;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetShadowColor(const Value : TColor);
begin
  if Value <> FShadowColor then begin
    FShadowColor := Value;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetShadowedText(Value : Boolean);
begin
  if Value <> FShadowedText then begin
    FShadowedText := Value;
    Refresh;
  end;
end;

function TOvcNotebook.IsTabHeightStored: Boolean;
begin
  Result := not TabAutoHeight;
end;

procedure TOvcNotebook.SetTabAutoHeight(Value : Boolean);
begin
  if Value <> FTabAutoHeight then begin
    FTabAutoHeight := Value;

    if FTabAutoHeight then
      Refresh;
  end;
end;

procedure TOvcNotebook.SetTabHeight(Value : Integer);
begin
  if (Value <> FTabHeight) and (Value >= 0) then begin
    FTabHeight := Value;
    if not (csLoading in ComponentState) then
      TabAutoHeight := False;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetTabOrientation(Value : TOvcTabOrientation);
var
  I  : Integer;
  TM : TTextMetric;
begin
  if Value <> FTabOrientation then begin
    {check if the current font can be rotated}
    if (not (csLoading in ComponentState)) and (Value in [toRight, toLeft]) then begin
      {test primary tab font}
      Canvas.Font := Self.Font;
      GetTextMetrics(Canvas.Handle, TM);
      if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
        if not (csLoading in ComponentState) then
          if csDesigning in ComponentState then begin
            {force font}
            Font.Name := tabFontName;
          end else
            raise EInvalidTabFont.Create;

      {test active tab font}
      if FUseActiveTabFont then begin
        Canvas.Font := FActiveTabFont;
        GetTextMetrics(Canvas.Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          if not (csLoading in ComponentState) then
            if csDesigning in ComponentState then begin
              {force font}
              FActiveTabFont.Name := tabFontName;
            end else
              raise EInvalidTabFont.Create;
      end;

      {test individual page fonts}
      for I := 0 to FPages.Count-1 do begin
        Canvas.Font := TOvcTabPage(FPages[I]).Font;
        GetTextMetrics(Canvas.Handle, TM);
        if (TM.tmPitchAndFamily and TMPF_TRUETYPE) = 0 then
          if not (csLoading in ComponentState) then
            if csDesigning in ComponentState then begin
              {force font}
              FActiveTabFont.Name := tabFontName;
            end else
              raise EInvalidTabFont.Create;
      end;
    end;

    FTabOrientation := Value;

    {force recalculation for alignment settings}
    SetBounds(Left, Top, Width, Height);
    Refresh;
  end;
end;

procedure TOvcNotebook.SetTabTextOrientation(Value: TTabTextOrientation);
begin
  if Value <> FTabTextOrientation then begin
    FTabTextOrientation := Value;
    Invalidate;
  end;
end;

procedure TOvcNotebook.SetTabRowCount(Value : Integer);
begin
  if csLoading in ComponentState then begin
    FTabRowCount := Value;
    Exit;
  end;

  if (Value <> FTabRowCount) and
     (Value >= 0) and
     (Value <= FPages.Count) then
    FTabRowCount := Value;

  tabCalcTabInfo;

  {force recalculation for alignment settings}
  SetBounds(Left, Top, Width, Height);
  Refresh;
end;

procedure TOvcNotebook.SetTabColor(Value : TColor);
var
  TP : TOvcTabPage;
begin
  if IsValid(PageIndex) then begin
    TP := TOvcTabPage(FPages[PageIndex]);
    if TP.TextColor <> Value then begin
      TP.TabColor := Value;
      FTabUseDefaultColor := False;
      InvalidateTab(PageIndex);
    end;
  end;
end;

procedure TOvcNotebook.SetTabUseDefaultColor(Value : Boolean);
var
  I : Integer;
begin
  if Value <> FTabUseDefaultColor then begin
    FTabUseDefaultColor := Value;
    if Value and not (csLoading in ComponentState) then begin
      for I := 0 to FPages.Count-1 do
        TOvcTabPage(FPages[I]).TabColor := Color;
    end;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetTextShadowColor(const Value : TColor);
begin
  if Value <> FTextShadowColor then begin
    FTextShadowColor := Value;
    Refresh;
  end;
end;

procedure TOvcNotebook.SetUseActiveTabFont(Value : Boolean);
begin
  if Value <> FUseActiveTabFont then begin
    FUseActiveTabFont := Value;
    Invalidate;
  end;
end;

procedure TOvcNotebook.ShowControl(AControl : TControl);
var
  I  : Integer;
begin
  for I := 0 to FPages.Count - 1 do
    if TOvcTabPage(FPages[I]) = AControl then begin
      {show the page this control is on}
      PageIndex := I;
      Break;
    end;

  inherited ShowControl(AControl);
end;

function TOvcNotebook.TabsInRow(Row : Integer) : Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to FPages.Count-1 do
    if TOvcTabPage(FPages[I]).Row = Row then
      if TOvcTabPage(FPages[I]).PageVisible or (csDesigning in componentState) then
        Inc(Result);
end;

procedure TOvcNotebook.tabAdjustPageSize;
var
  I    : Integer;
  T, L : Integer;
  W, H : Integer;
begin
  {adjust size of all contained pages to fit our client area}
  L := 0;
  T := 0;
  if TabHeight = 0 then begin
    W := Self.Width;
    H := Self.Height;
  end else begin
    W := 0;
    H := 0;
    case FTabOrientation of
      toTop :
        begin
          L := 1;
          T := FTabHeight*tabTotalRows+3;
          H := Self.Height-T-2;
          W := Self.Width-3;
          if ThemesEnabled then
            Dec(W);
        end;
      toBottom :
        begin
          L := 1;
          T := 1;
          H := Self.Height-FTabHeight*tabTotalRows-5;
          W := Self.Width-3;
          if ThemesEnabled then
            Dec(W);
        end;
      toRight :
        begin
          L := 1;
          T := 1;
          H := Self.Height-3;
          W := Self.Width-(FTabHeight*tabTotalRows+2)-2;
        end;
      toLeft :
        begin
          L := FTabHeight*tabTotalRows+3;
          T := 1;
          H := Self.Height-3;
          W := Self.Width-L-2;
        end;
    end;
  end;

  {change the client area size for all tab pages}
  for I := 0 to FPages.Count-1 do
    with TOvcTabPage(FPages[I]) do
      if (L <> tpGetLeft) or (T <> tpGetTop) or
         (W <> tpGetWidth) or (H <> tpGetHeight) then
        SetBounds(L, T, W, H);
end;

procedure TOvcNotebook.tabCalcTabInfo;
var
  I    : Integer;
  J    : Integer;
  K    : Integer;
  Row  : Integer;
  WH   : Integer;
  TTW  : Integer;
  TPR  : Integer;
  Adj  : Integer;
  Diff : Integer;
  PC   : TOvcTabPage;

  function WidthOfTabs(Row : Integer) : Integer;
  var
    I : Integer;
  begin
    Result := 0;
    for I := 0 to FPages.Count-1 do
      if TOvcTabPage(FPages[I]).Row = Row then
        if TOvcTabPage(FPages[I]).PageVisible or (csDesigning in componentState)
        then Inc(Result, TOvcTabPage(FPages[I]).TabWidth);
  end;

  procedure SetFont(F : TFont);
  begin
    Canvas.Font := F;
    if FTabOrientation = toRight then
      Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 90)
    else if FTabOrientation = toleft then
      Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 270);
  end;


  { Removes the HotKey character from the string.
   The Hot Key Character is defined as cHotKeyChar in OvcConst }
  function StripHotKeyChar(const Text: String): String;
  var
    I: Integer;
  begin
    Result := Text;
    I := Length(Result);
    while I > 0 do begin
      if Result[I] = cHotKeyChar then Delete(Result, I, 1);
      Dec(I);
    end;
  end;

begin
  if not Visible then
    Exit;

  {calculate tab height based on the fonts}
  if FTabAutoHeight then begin
    {get height for active tab font}
    if FUseActiveTabFont then begin
      SetFont(FActiveTabFont);
      I := Canvas.TextHeight(GetOrphStr(SCTallLowChars))+tabMargin*2;
    end else
      I := 0;

    {get height for default font}
    SetFont(Self.Font);
    J := Canvas.TextHeight(GetOrphStr(SCTallLowChars))+tabMargin*2;

    {select largest height}
    FTabHeight := MaxI(I, J);

    {tab page fonts}
    for I := 0 to FPages.Count-1 do begin
      SetFont(TOvcTabPage(FPages[I]).Font);
      J := Canvas.TextHeight(GetOrphStr(SCTallLowChars))+tabMargin*2;
      {select largest height}
      FTabHeight := MaxI(FTabHeight, J);
    end;
  end else
    if FTabHeight = 0 then
      Exit;

  case FTabOrientation of
    toTop, toBottom : WH := Self.Width-4;
    toLeft, toRight : WH := Self.Height-4;
  else
    WH := 0;
  end;

  if FPages.Count = 0 then
    Exit;

  {determine tab widths}
  {compute the text widths (using the default and selected fonts) for each tab}
  {and use that value plus a text margin to determine the tab widths}
  if OldStyle then begin
    {all tabs the same width}
    J := tabMinTabWidth;
    for I := 0 to FPages.Count-1 do begin
      PC := TOvcTabPage(FPages[I]);
      if PC.PageVisible or (csDesigning in componentState) then begin
        if FUseActiveTabFont then begin
          SetFont(FActiveTabFont);
          J := MaxI(J, Canvas.TextWidth(StripHotKeyChar(PC.Caption)));
        end;
        SetFont(PC.Font);
        J := MaxI(J, Canvas.TextWidth(StripHotKeyChar(PC.Caption)))
          + tabTabBorder*2;
      end;
    end;
    {set tab widths}
    for I := 0 to FPages.Count-1 do begin
      PC := TOvcTabPage(FPages[I]);
      if PC.PageVisible or (csDesigning in componentState) then
        PC.TabWidth := J
      else
        PC.TabWidth := 0;
    end;
  end else begin
    for I := 0 to FPages.Count-1 do begin
      PC := TOvcTabPage(FPages[I]);
      if PC.PageVisible or (csDesigning in componentState) then begin
        if FUseActiveTabFont then begin
          SetFont(FActiveTabFont);
          J := Canvas.TextWidth(StripHotKeyChar(PC.Caption));
        end else
          J := 0;
        SetFont(PC.Font);
        J := MaxI(J, Canvas.TextWidth(StripHotKeyChar(PC.Caption)))
          + tabTabBorder*2;
        PC.TabWidth := MaxI(J, tabMinTabWidth);
      end else
        PC.TabWidth := 0;
    end;
  end;

  tabFocusedRow := 0;
  if FTabRowCount = 0 {autocalc} then begin
    {determine the number of tabs that can fit}
    {on a row and the total number of tab rows}
    tabTotalRows := 0;
    I := 0;
    repeat
      Inc(tabTotalRows); {always have at least one row}
      TTW := 0;
      PC := TOvcTabPage(FPages[I]);
      repeat
        if PC.PageVisible or (csDesigning in componentState) then begin
          Inc(TTW, PC.TabWidth);        {at least one tab per row}
          PC.Row := Pred(tabTotalRows);
          if I = PageIndex then
            tabFocusedRow := PC.Row;
        end;
        Inc(I);
        if I < FPages.Count then
          PC := TOvcTabPage(FPages[I]);
      until (I = FPages.Count) or (TTW+PC.TabWidth > WH);
    until (I > FPages.Count-1);
  end else begin
    {determine the number of tabs that need to fit on each row}
    tabTotalRows := FTabRowCount;
    TPR := FPages.Count div tabTotalRows; {tabs per row}
    J := TPR;
    K := FPages.Count;
    Row := 0;
    for I := 0 to FPages.Count-1 do begin
      PC := TOvcTabPage(FPages[I]);
      if PC.PageVisible or (csDesigning in componentState) then begin
        PC.Row := Row;
        if I = PageIndex then
          tabFocusedRow := PC.Row;
        Dec(J);
        if J = 0 then begin {start next row}
          Inc(Row);
          J := TPR;
          if Row >= tabTotalRows then begin
            K := I + 1;
            Break;
          end;
        end;
      end;
    end;
    {spread odd tabs between rows}
    Row := 0;
    for I := K to FPages.Count-1 do begin
      PC := TOvcTabPage(FPages[I]);
      if PC.PageVisible or (csDesigning in componentState) then begin
        PC.Row := Row;
        if I = PageIndex then
          tabFocusedRow := PC.Row;
        Inc(Row);
      end;
    end;
  end;

  if OldStyle then begin
    {adjust the tab widths in each row for a perfect fit}
    for Row := 0 to Pred(tabTotalRows) do begin
      Diff := WH - WidthOfTabs(Row);
      if (TabsInRow(Row) > 0) then begin
        Adj := Abs(Diff) div TabsInRow(Row);
        for I := 0 to FPages.Count-1 do begin
          PC := TOvcTabPage(FPages[I]);
          if (PC.Row = Row) and
             (PC.PageVisible or (csDesigning in componentState)) then begin
            if Diff > 0 then
              PC.TabWidth := PC.TabWidth + Adj
            else
              PC.TabWidth := PC.TabWidth - Adj;
          end;
        end;
        {spread remainder (if any) between some of the tabs}
        Adj := Abs(Diff) mod TabsInRow(Row);
        if Adj > 0 then begin
          for I := 0 to FPages.Count-1 do begin
            PC := TOvcTabPage(FPages[I]);
            if (Adj > 0) and (PC.Row = Row) and
              (PC.PageVisible or (csDesigning in componentState)) then begin
              if Diff > 0 then
                PC.TabWidth := PC.TabWidth + 1
              else
                PC.TabWidth := PC.TabWidth - 1;
              Dec(Adj);
            end;
          end;
        end;
      end else
        Dec(tabTotalRows);
    end;
  end;
  tabLastRow := Pred(tabTotalRows);

end;

procedure TOvcNotebook.tabCollectionChanged(Sender : TObject);
begin
  Invalidate;
end;

procedure TOvcNotebook.tabCollectionItemSelected(Sender : TObject; Index : Integer);
begin
  if csDesigning in ComponentState then
    if (Index > -1) and (Index < FPages.Count) then
      PageIndex := Index;
end;

procedure TOvcNotebook.tabGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingPages);
end;

procedure TOvcNotebook.tabDrawFocusRect(Index : Integer);
var
  R : TRect;
begin
  if TabHeight = 0 then
    exit;
  if IsValid(Index) then begin
    {force canvas handle update}
    if Canvas.Handle = 0 then {};
    R := tabGetTabRect(Index);
    case FTabOrientation of
      toTop :
        begin
          Dec(R.Top, 2);
          Dec(R.Bottom, 2);
          InflateRect(R,4,0);
        end;
      toBottom :
        begin
          Inc(R.Top, 2);
          Dec(R.Bottom, 3);
          InflateRect(R,4,0);
        end;
      toRight :
        begin
          Inc(R.Right, 2);
          Inc(R.Left, 1);
          InflateRect(R,0,4);
        end;
      toLeft :
        begin
          Inc(R.Left, 4);
          Dec(R.Right, 1);
          InflateRect(R,0,4);
        end;
    end;
    Canvas.DrawFocusRect(R);
  end;
end;

procedure TOvcNotebook.tabFontChanged(Sender : TObject);
begin
  if csLoading in ComponentState then
    Exit;

  Perform(CM_FONTCHANGED, 0, 0);
end;

function TOvcNotebook.tabGetTabRect(Index : Integer) : TRect;
begin
  if TabHeight = 0 then begin
    Result := Rect(0, 0, 0, 0);
    exit;
  end;
  Result := TOvcTabPage(FPages[Index]).Area;
  case FTabOrientation of
    toTop :
      begin
        InflateRect(Result, -tabTabBorder, 0);
        Dec(Result.Left);
        Inc(Result.Top, tabMargin+1);
      end;
    toBottom :
      begin
        InflateRect(Result, -tabTabBorder, 0);
        Dec(Result.Left);
        Inc(Result.Bottom, tabMargin+1);
      end;
    toRight :
      begin
        InflateRect(Result, 0, -tabTabBorder);
        Dec(Result.Top);
        Dec(Result.Right, tabMargin+1);
      end;
    toLeft :
      begin
        InflateRect(Result, 0, -tabTabBorder);
        Dec(Result.Top);
        Dec(Result.Left, tabMargin+1);
      end;
  end;
end;

procedure TOvcNotebook.tabPaintBottomTabs;
var
  TP        : TOvcTabPage;
  I          : Integer;
  YOfs       : Integer;
  XOfs       : Integer;
  R          : TRect;
  TabRect    : TRect;
  TextOfs    : Integer;
  Row        : Integer;
  StartRow   : Integer;
  TabsUsed   : Integer;
  PC         : TColor;
  CR: TRect;
  Details: TThemedElementDetails;

  procedure DrawTabBorder({const} TR : TRect; Current, Hot, IsEnabled : Boolean);
  var
    PW         : Integer;
    L, T, R, B : Integer;
    TT: TThemedTab;
    Details: TThemedElementDetails;
    RBody: TRect;
    TmpImg: TBitmap;
  begin
    if ThemesEnabled and (TP.TabColor=clBtnFace) then
    begin
      Details := ThemeServices.GetElementDetails(ttPane);
      RBody := Rect(0, 0, Width, Height-tabTotalRows*FTabHeight-1);

      // we must cut off the bottom edge so draw into own bitmap first
      TmpImg := TBitmap.Create;
      try
        TmpImg.PixelFormat := pfDevice;
        TmpImg.SetSize(Width, TR.Top + 1);
        ThemeServices.DrawElement(TmpImg.Canvas.Handle, Details, RBody);
        BitBlt(Canvas.Handle, RBody.Left, RBody.Top, RBody.Right - RBody.Left, RBody.Bottom - RBody.Top-1, TmpImg.Canvas.Handle, 0, 0, SRCCOPY);
      finally
        TmpImg.Free;
      end;

      if not IsEnabled then
        TT := ttTabItemDisabled
      else if Current then
        TT := ttTabItemSelected
      else if Hot then
        TT := ttTabItemHot
      else
        TT := ttTabItemNormal;

      // Tab touches both left and right border (there is 1 pixel gap; this is probably intentional)
      if (TR.Left = 0) and (TR.Right >= Width) then
      begin
        case TT of
          ttTabItemNormal: TT := ttTabitemBothEdgeNormal;
          ttTabItemHot: TT := ttTabItemBothEdgeHot;
          ttTabItemSelected: TT := ttTabItemBothEdgeSelected;
        end;
        Dec(TR.Right, 2);
      end
      // Tab touches left border
      else if TR.Left = 0 then
        case TT of
          ttTabItemNormal: TT := ttTabitemLeftEdgeNormal;
          ttTabItemHot: TT := ttTabItemLeftEdgeHot;
          ttTabItemSelected: TT := ttTabItemLeftEdgeSelected;
        end
      // Tab touches right border
      else if TR.Right = Width then
        case TT of
          ttTabItemNormal: TT := ttTabitemRightEdgeNormal;
          ttTabItemHot: TT := ttTabItemRightEdgeHot;
          ttTabItemSelected: TT := ttTabItemRightEdgeSelected;
        end;
      Details := ThemeServices.GetElementDetails(TT);
      TmpImg := TBitmap.Create;
      try
        TmpImg.PixelFormat := pfDevice;
        TmpImg.SetSize(TR.Right - TR.Left, TR.Bottom - TR.Top);
        ThemeServices.DrawElement(TmpImg.Canvas.Handle, Details, Rect(0, 0, TmpImg.Width, TmpImg.Height));
        // Draw it flipped
        StretchBlt(Canvas.Handle, TR.Left, TR.Bottom, TmpImg.Width, -TmpImg.Height-2, TmpImg.Canvas.Handle, 0, 0, TmpImg.Width, TmpImg.Height, SRCCOPY)
      finally
        TmpImg.Free;
      end;
    end
    else
    with Canvas do begin
      with TR do begin
        L := Left;
        T := Top;
        R := Right;
        B := Bottom;
      end;

      {fill the tab area}
      Brush.Color := TP.TabColor;
      Pen.Color := TP.TabColor;
      Polygon([Point(L+1,     T),
               Point(L+1,     B-2),
               Point(L+3,     B-1),
               Point(R-3,     B-1),
               Point(R-1,     B-3),
               Point(R-1,     T)]);

      {highlight}
      Pen.Color := FHighlightColor;
      PolyLine([Point(L,      T+1),
                Point(L,      B-2)]);

      {border}
      Pen.Color := clBlack;
      PolyLine([Point(R-1,    T),
                Point(R-1,    B-2),
                Point(R-3,    B),
                Point(L+2,    B),
                Point(L,      B-2)]);

      {shadow}
      Pen.Color := FShadowColor;
      PolyLine([Point(R-2,    T),
                Point(R-2,    B-2),
                Point(R-3,    B-1),
                Point(L+2,    B-1),
                Point(L,      B-2)]);

      if Current then begin
        PW := Self.Width; {page width}

        {clear area directly above the tab}
        Pen.Color := Color;
        Rectangle(L, T, R, T-1);

        {border}
        Pen.Color := clBlack;
        PolyLine([Point(L-1,  T),
                  Point(0,    T)]);
        PolyLine([Point(PW-1, 0),
                  Point(PW-1, T),
                  Point(R-2,  T)]);

        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(L-1,  T-1),
                  Point(0,    T-1)]);
        PolyLine([Point(PW-2, 1),
                  Point(PW-2, T-1),
                  Point(R-2,  T-1)]);
        Pixels[PW-2, T-1] := FShadowColor;

        {highlight}
        Pen.Color := FHighlightColor;
        PolyLine([Point(0,    T),
                  Point(0,    0),
                  Point(PW,   0)]);
        PolyLine([Point(L,    T),
                  Point(L,    B)]);
        Pixels[L+1, T] := Color;

      end;
    end;
  end;

  procedure DrawTab(Index : Integer; const Title : string; IsEnabled,
                    IsTabActive : Boolean;
                    TxtOfs : Integer; {const} Rect, TabRect : TRect);
  var
    HoldColor : TColor;
  begin

    {draw the tab and borders}
    R := Rect;
    DrawTabBorder(TabRect, IsTabActive, Index = FHotTab, IsEnabled);

    with Canvas do begin
      {get text bounding rectangle}
      R := Rect;
      Inc(R.Left, tabTabBorder);
      Inc(R.Top, TxtOfs);
      Dec(R.Right, tabTabBorder);
      Dec(R.Bottom, TxtOfs);

      if (R.Right > Width-2) then
        R.Right := Width-tabTabBorder*2-2;

      {exit if user has drawn the tab}
      if DoOnDrawTab(Index, Title, IsEnabled, IsTabActive) then
        Exit;

      {exit if text won't fit on tab}
      if TextHeight(Title) > FTabHeight - tabMargin*2 then
        Exit;

      HoldColor := Canvas.Font.Color;
      if IsEnabled then begin
        {draw shadow first, if selected}
        if FShadowedText then begin
          Canvas.Font.Color := FTextShadowColor;
          if ThemesEnabled then
            SetBkMode(Canvas.Handle, TRANSPARENT)
          else
            SetBkMode(Canvas.Handle, OPAQUE);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
          Canvas.Font.Color := HoldColor;
          SetBkMode(Canvas.Handle, TRANSPARENT);
          OffsetRect(R, -2, -1);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        end else begin
          {draw the text}
          if ThemesEnabled then
            SetBkMode(Canvas.Handle, TRANSPARENT)
          else
            SetBkMode(Canvas.Handle, OPAQUE);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        end;
      end else begin
        {use shadow text for inactive tabs}
        Canvas.Font.Color := FHighlightColor;
        SetBkMode(Canvas.Handle, OPAQUE);
        DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        SetBkMode(Canvas.Handle, TRANSPARENT);
        Canvas.Font.Color := FShadowColor;
        OffsetRect(R, -2, -1);
        DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
      end;
      Canvas.Font.Color := HoldColor;
    end;
  end;

  procedure DrawTriangle(X, Y : Integer; Left : Boolean);
  begin
    if ThemesEnabled then
      Exit;
    if Row <> StartRow then begin
      {get color from directly below this triangle area}
      Canvas.Brush.Color := Canvas.Pixels[X,Y+1];
      Canvas.Pen.Color := Canvas.Brush.Color;
    end;
    if Left then
      Canvas.Polygon([Point(X,Y), Point(X+1,Y), Point(X,Y-1)])
    else
      Canvas.Polygon([Point(X,Y), Point(X-2,Y), Point(X,Y-2)]);
  end;

begin
  if ThemesEnabled then
  begin
    CR := ClientRect;
    Details := ThemeServices.GetElementDetails(tttabDontCare);
    ThemeServices.DrawParentBackground(Handle, Canvas.Handle, Details, True, @CR);
  end;
  {get page color}
  if FPageUsesTabColor then begin
    TP := TOvcTabPage(FPages[PageIndex]);
    tabPainting := True;
    try
      Color := TP.TabColor;
    finally
      tabPainting := False;
    end;
  end;

  {get current parent color}
  if Parent is TControl then
    PC := TLocalControl(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    {clear area to left and right of tabs}
    Brush.Color := PC;
    Pen.Color := PC;

    if OldStyle then begin
      Rectangle(0, Height, 2, Height-tabTotalRows*FTabHeight-2);
      Rectangle(Width-2, Height, Width, Height-tabTotalRows*FTabHeight-2);
    end else
      Rectangle(0, Height-tabTotalRows*FTabHeight-2, Width, Height);

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars))) div 2;

    {bottom of tab rows}
    YOfs := Height-3;

    {clear the two pixel blank area below the tabs}
    Brush.Color :=  PC;
    Pen.Color :=  PC;
    Rectangle(0, Height, Width, Height-2);

    {start with the row after the row containing the focused tab}
    Row := Succ(tabFocusedRow);
    if Row > tabLastRow then
      Row := 0;
    StartRow := Row;
    repeat
      XOfs := 2; {left of first tab}
      TabsUsed := 0;
      for I := 0 to FPages.Count-1 do begin
        TP := TOvcTabPage(FPages[I]);
        if (TP.Row = Row) and (TP.PageVisible or (csDesigning in componentState)) then begin
          {record tab area}
          TP.Area := Bounds(XOfs, YOfs-FTabHeight, TP.TabWidth, FTabHeight);

          {set the font to use}
          Canvas.Font := TP.Font;

          {draw the tab}
          Canvas.Font.Color := TP.TextColor;
          TabRect := TP.Area;
          TabRect.Top := Height-tabTotalRows*FTabHeight-2;
          DrawTab(I, TP.Caption, Enabled and TP.Enabled, (I = PageIndex), TextOfs,
            TP.Area, TabRect);

          {paint corners to match parent color}
          Brush.Color := PC;
          Pen.Color := PC;
          if Row = StartRow then begin
            DrawTriangle(TP.Area.Left, TP.Area.Bottom, True);    {left}
            DrawTriangle(TP.Area.Right, TP.Area.Bottom, False);  {right}
          end else begin
            if TabsUsed >0 then
              DrawTriangle(TP.Area.Left, TP.Area.Bottom, True);  {left}
            DrawTriangle(TP.Area.Right, TP.Area.Bottom, False);  {right}
          end;

          Inc(TabsUsed);
          XOfs := TP.Area.Right;
        end;
      end;

      Dec(YOfs, FTabHeight);
      Inc(Row);
      if Row > tabLastRow then Row := 0;
    until Row = StartRow;

    {draw the active tab}

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars)) + 2) div 2;

    TP := TOvcTabPage(FPages[PageIndex]);
    if FUseActiveTabFont then
      Canvas.Font := FActiveTabFont
    else begin
      Canvas.Font := TP.Font;
      Canvas.Font.Color := TP.TextColor;
    end;

    R := TP.Area;
    InflateRect(R, 2, 2);
    Inc(R.Top, 2);
    TabRect := R;
    DrawTab(PageIndex, TP.Caption, Enabled and TP.Enabled, True, TextOfs, R, TabRect);

    {reset to default font and colors so focus rect is drawn properly}
    Canvas.Brush.Color := TP.TabColor;
    Canvas.Pen.Color := TP.TabColor;

    {draw the focus rect if the tab has the focus}
    if Focused then
      tabDrawFocusRect(PageIndex);
  end;
end;

procedure TOvcNotebook.tabPaintLeftTabs;
var
  TP         : TOvcTabPage;
  I          : Integer;
  YOfs       : Integer;
  XOfs       : Integer;
  R          : TRect;
  TabRect    : TRect;
  TextOfs    : Integer;
  Row        : Integer;
  StartRow   : Integer;
  TabsUsed   : Integer;
  PC         : TColor;

  procedure DrawTabBorder({const} TR : TRect; Current : Boolean);
  var
    PH         : Integer;
    L, T, R, B : Integer;
  begin
    with Canvas do begin
      with TR do begin
        L := Left;
        T := Top;
        R := Right;
        B := Bottom;
      end;

      {fill the tab area}
      Brush.Color := TP.TabColor;
      Pen.Color := TP.TabColor;
      Polygon([Point(L+2,      T+1),
               Point(R,        T+1),
               Point(R,        B-1),
               Point(L+2,      B-1),
               Point(L,        B-2),
               Point(L,        T+2)]);

      {highlight}
      Pen.Color := FHighlightColor;
      PolyLine([Point(L,       B-2),
                Point(L,       T+2),
                Point(L+2,     T),
                Point(R,       T)]);

      if (TabsUsed = 0) or Current then begin
        {border}
        Pen.Color := clBlack;
        PolyLine([Point(L,       B-2),
                  Point(L+2,     B),
                  Point(R,       B)]);

        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(L+1,     B-2),
                  Point(L+2,     B-1),
                  Point(R,       B-1)]);
      end else begin
        {border}
        Pen.Color := clBlack;
        PolyLine([Point(L,       B-3),
                  Point(L+2,     B-1),
                  Point(R,       B-1)]);

        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(L+1,     B-3),
                  Point(L+2,     B-2),
                  Point(R,       B-2)]);
      end;

      if Current then begin
        PH := Self.Height-1; {page height}

        {clear area directly below(right) of the tab}
        Pen.Color := Color;
        Rectangle(R-1, T, R+2, B);

        {border}
        Pen.Color := clBlack;
        PolyLine([Point(R,       PH),
                  Point(Width-1, PH),
                  Point(Width-1,  0)]);

        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(R,       PH-1),
                  Point(Width-2, PH-1),
                  Point(Width-2, 0)]);

        {highlight}
        Pen.Color := FHighlightColor;
        PolyLine([Point(R,    B),
                  Point(R,    PH)]);
        PolyLine([Point(R-1,  T),
                  Point(R,    T),
                  Point(R,    0),
                  Point(Width, 0)]);
      end;
    end;
  end;

  procedure DrawTab(Index : Integer; Title : string;
                    IsEnabled, IsTabActive : Boolean;
                    TxtOfs : Integer; {const} Rect, TabRect : TRect);
  var
    UIndent   : Integer;
    CTIndent  : Integer;
    WD        : Integer;
    TW        : Integer;
    TH        : Integer;
    HoldColor : TColor;
    UPos      : Integer;
    P         : Integer;
  begin
    {draw the tab and borders}
    DrawTabBorder(TabRect, IsTabActive);

    with Canvas do begin
      {get text bounding rectangle}
      R := Rect;
      Inc(R.Left, TxtOfs);
      Inc(R.Top, tabTabBorder);
      Dec(R.Right, TxtOfs);
      Dec(R.Bottom, tabTabBorder);

      if (R.Bottom >= Height-2) then
        R.Bottom := Height-tabTabBorder*2-2;

      {exit if user has drawn the tab}
      if DoOnDrawTab(Index, Title, IsEnabled, IsTabActive) then
        Exit;

      {exit if text won't fit on tab}
      if TextHeight(Title) > FTabHeight - tabMargin*2 then
        Exit;

      {find location for underlined character}
      UPos := Pos('&', Title);
      if UPos > 0 then begin
        Delete(Title, UPos, 1);

        {was the '&' escaped?}
        P := Pos('&', Title);
        if (P > 0) and (P = UPos) then
          UPos := 0;
      end;
      if Title = '' then
        Title := ' ';

      {convert UPos to pixel position within the title}
      if UPos > 0 then
        UIndent := TextWidth(Copy(Title, 1, UPos-1))
      else
        UIndent := 0;

      {calc indent needed to center}
      CTIndent := 0;
      TW := TextWidth(Title);
      WD := R.Bottom - R.Top;
      if TW < WD then
        CTIndent := (WD - TW) div 2;

      HoldColor := Canvas.Font.Color;
      if IsEnabled then begin
        {draw shadow first, if selected}
        if FShadowedText then begin
          {draw the shadow text first}
          Canvas.Font.Color := FTextShadowColor;
          SetBkMode(Canvas.Handle, OPAQUE);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Left+TxtOfs, Rect.Bottom-tabTabBorder-CTIndent, Title);

          {draw normal text}
          Canvas.Font.Color := HoldColor;
          SetBkMode(Canvas.Handle, TRANSPARENT);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Left+TxtOfs+2, Rect.Bottom-tabTabBorder-CTIndent+1, Title);

          {draw underline character, if any}
          if UPos > 0 then begin
            TH := TextHeight(Title)-1;
            Pen.Color := Canvas.Font.Color;
            MoveTo(Rect.Left+TxtOfs+TH+2, Rect.Bottom-tabTabBorder-UIndent-CTIndent+1);
            LineTo(Rect.Left+TxtOfs+TH+2, Rect.Bottom-tabTabBorder-UIndent-CTIndent-
                   TextWidth(Title[UPos])+1);
          end;
        end else begin  {normal tab}
          {draw the text}
          SetBkMode(Canvas.Handle, OPAQUE);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Left+TxtOfs, Rect.Bottom-tabTabBorder-CTIndent, Title);

          {draw underline character, if any}
          if UPos > 0 then begin
            TH := TextHeight(Title)-1;
            Pen.Color := Canvas.Font.Color;
            MoveTo(Rect.Left+TxtOfs+TH, Rect.Bottom-tabTabBorder-UIndent-CTIndent);
            LineTo(Rect.Left+TxtOfs+TH, Rect.Bottom-tabTabBorder-UIndent-CTIndent-
                   TextWidth(Title[UPos]));
          end;
        end;
      end else begin  {inactive tab}
        {draw the highlight text first}
        Canvas.Font.Color := FHighlightColor;
        SetBkMode(Canvas.Handle, OPAQUE);
        if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
        TextOut(Rect.Left+TxtOfs-1, Rect.Bottom-tabTabBorder-CTIndent, Title);

        {draw shadow text for inactive tab}
        SetBkMode(Canvas.Handle, TRANSPARENT);
        if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
        Canvas.Font.Color := FShadowColor;
        TextOut(Rect.Left+TxtOfs, Rect.Bottom-tabTabBorder-CTIndent+2, Title);

        {draw underline character, if any}
        if UPos > 0 then begin
          TH := TextHeight(Title)-1;
          Pen.Color := Canvas.Font.Color;
          MoveTo(Rect.Left+TxtOfs+TH+1, Rect.Bottom-tabTabBorder-UIndent-CTIndent+1);
          LineTo(Rect.Left+TxtOfs+TH+1, Rect.Bottom-tabTabBorder-UIndent-CTIndent-
                 TextWidth(Title[UPos])+1);
        end;

        {restore font color}
        Canvas.Font.Color := HoldColor;
      end;

    end;
  end;

  procedure DrawTriangle(X, Y : Integer; Left : Boolean);
  begin
    if Row <> StartRow then begin
      {get color from directly to the left of this triangle area}
      Canvas.Brush.Color := Canvas.Pixels[X-1,Y];
      Canvas.Pen.Color := Canvas.Brush.Color;
    end;
    if Left then
      Canvas.Polygon([Point(X,Y), Point(X+1,Y), Point(X,Y+1)])
    else
      Canvas.Polygon([Point(X,Y), Point(X,Y-2), Point(X+2,Y)]);
  end;

begin
  {get the page color}
  if FPageUsesTabColor then begin
    TP := TOvcTabPage(FPages[PageIndex]);
    tabPainting := True;
    try
      Color := TP.TabColor;
    finally
      tabPainting := False;
    end;
  end;

  {get current parent color}
  if Parent is TControl then
    PC := TLocalControl(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    {clear area above and below tabs}
    Brush.Color := PC;
    Pen.Color := PC;

    if OldStyle then begin
      Rectangle(0, 0, tabTotalRows*FTabHeight+2, 2);
      Rectangle(0, Height-2, tabTotalRows*FTabHeight+2, Height);
    end else
      Rectangle(0,0,tabTotalRows*FTabHeight+2,Height);

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars))) div 2 - 1;

    {left side (top) of tab row}
    XOfs := 2;

    {clear the two pixel blank area to the left of the tabs}
    Brush.Color :=  PC;
    Pen.Color :=  PC;
    Rectangle(0, 0, 2, Height);

    {start with the row after the row containing the focused tab}
    Row := Succ(tabFocusedRow);
    if Row > tabLastRow then
      Row := 0;
    StartRow := Row;
    repeat
      YOfs := Height-2;  {left edge of first tab}
      TabsUsed := 0;
      for I := 0 to FPages.Count-1 do begin
        TP := TOvcTabPage(FPages[I]);
        if (TP.Row = Row) and (TP.PageVisible or (csDesigning in componentState)) then begin
          {record tab area}
          TP.Area := Bounds(XOfs, YOfs-TP.TabWidth, FTabHeight, TP.TabWidth);

          {set the font to use}
          Canvas.Font := TP.Font;
          Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 90);

          {draw the tab}
          Canvas.Font.Color := TP.TextColor;
          TabRect := TP.Area;
          TabRect.Right := tabTotalRows*FTabHeight+2;
          DrawTab(I, TP.Caption, Enabled and TP.Enabled, (I = PageIndex), TextOfs, TP.Area, TabRect);

          {paint corners to match parent color}
          Brush.Color := PC;
          Pen.Color := PC;
          if Row = StartRow then begin
            DrawTriangle(TP.Area.Left, TP.Area.Top, True);     {top}
            DrawTriangle(TP.Area.Left, TP.Area.Bottom, False); {bottom}
          end else begin
            if TabsUsed = 0 then
              DrawTriangle(TP.Area.Left, TP.Area.Top, True);   {top}
            DrawTriangle(TP.Area.Left, TP.Area.Bottom, False); {bottom}
          end;

          Inc(TabsUsed);
          YOfs := TP.Area.Top;  {next tab in row}
        end;
      end;

      Inc(XOfs, FTabHeight);
      Inc(Row);
      if Row > tabLastRow then Row := 0;
    until Row = StartRow;

    {draw the active tab}

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars)) + 2) div 2;

    TP := TOvcTabPage(FPages[PageIndex]);
    if FUseActiveTabFont then
      Canvas.Font := FActiveTabFont
    else begin
      Canvas.Font := TP.Font;
      Canvas.Font.Color := TP.TextColor;
    end;
    Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 90);

    R := TP.Area;
    InflateRect(R, 2, 2);
    Dec(R.Right, 2);
    Dec(R.Bottom, 1);
    DrawTab(PageIndex, TP.Caption, Enabled and TP.Enabled, True, TextOfs, R, R);

    {reset to default font and colors so focus rect is drawn properly}
    Canvas.Font := Self.Font;
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;

    {draw the focus rect if the tab has the focus}
    if Focused then
      tabDrawFocusRect(PageIndex);
  end;
end;

procedure TOvcNotebook.tabPaintRightTabs;
var
  TP         : TOvcTabPage;
  I          : Integer;
  YOfs       : Integer;
  XOfs       : Integer;
  R          : TRect;
  TabRect    : TRect;
  TextOfs    : Integer;
  Row        : Integer;
  StartRow   : Integer;
  TabsUsed   : Integer;
  PC         : TColor;

  procedure DrawTabBorder({const} TR : TRect; Current : Boolean);
  var
    PH         : Integer;
    L, T, R, B : Integer;
  begin
    with Canvas do begin
      with TR do begin
        L := Left;
        T := Top;
        R := Right;
        B := Bottom;
      end;

      {fill the tab area}
      Brush.Color := TP.TabColor;
      Pen.Color := TP.TabColor;
      Polygon([Point(L+1,      T),
               Point(R-2,      T),
               Point(R-1,      T+2),
               Point(R-1,      B-3),
               Point(R-2,      B-1),
               Point(L+1,      B-1)]);

      {highlight}
      Pen.Color := FHighlightColor;
      PolyLine([Point(L+1,     T),
                Point(R-2,     T),
                Point(R,       T+2)]);

      {border}
      Pen.Color := clBlack;
      PolyLine([Point(R,       T+2),
                Point(R,       B-2),
                Point(R-1,     B-2),
                Point(R-2,     B-1),
                Point(L,       B-1)]);

      {shadow}
      Pen.Color := FShadowColor;
      PolyLine([Point(R-1,     T+2),
                Point(R-1,     B-3),
                Point(R-2,     B-2),
                Point(L,       B-2)]);

      if Current then begin
        PH := Self.Height; {page height}

        {clear area directly below(left) of the tab}
        Pen.Color := Color;
        Rectangle(L+1, T, L-1, B);

        {border}
        Pen.Color := clBlack;
        PolyLine([Point(L,    0),
                  Point(L,    T)]);
        PolyLine([Point(L,    B-1),
                  Point(L,    PH)]);
        PolyLine([Point(0,    PH-1),
                  Point(L,    PH-1)]);

        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(L-1,  0),
                  Point(L-1,  T-1)]);
        PolyLine([Point(L-1,  B),
                  Point(L-1,  PH-1)]);
        PolyLine([Point(1,    PH-2),
                  Point(L+1,  PH-2)]);

        {highlight}
        Pen.Color := FHighlightColor;
        PolyLine([Point(0,    PH-1),
                  Point(0,    0),
                  Point(L+1,  0)]);
      end;
    end;
  end;

  procedure DrawTab(Index : Integer; Title : string;
                    IsEnabled, IsTabActive : Boolean;
                    TxtOfs : Integer; {const} Rect, TabRect : TRect);
  var
    UIndent   : Integer;
    CTIndent  : Integer;
    WD        : Integer;
    TW        : Integer;
    TH        : Integer;
    HoldColor : TColor;
    UPos      : Integer;
    P         : Integer;
  begin
    {draw the tab and borders}
    DrawTabBorder(TabRect, IsTabActive);

    with Canvas do begin
      {get text bounding rectangle}
      R := Rect;
      Inc(R.Left, TxtOfs);
      Inc(R.Top, tabTabBorder);
      Dec(R.Right, TxtOfs);
      Dec(R.Bottom, tabTabBorder);

      if (R.Bottom >= Height-2) then
        R.Bottom := Height-tabTabBorder*2-2;

      {exit if user has drawn the tab}
      if DoOnDrawTab(Index, Title, IsEnabled, IsTabActive) then
        Exit;

      {exit if text won't fit on tab}
      if TextHeight(Title) > FTabHeight - tabMargin*2 then
        Exit;

      {find location for underlined character}
      UPos := Pos('&', Title);
      if UPos > 0 then begin
        Delete(Title, UPos, 1);

        {was the '&' escaped?}
        P := Pos('&', Title);
        if (P > 0) and (P = UPos) then
          UPos := 0;
      end;
      if Title = '' then
        Title := ' ';

      {convert UPos to pixel position within the title}
      if UPos > 0 then
        UIndent := TextWidth(Copy(Title, 1, UPos-1))
      else
        UIndent := 0;

      {calc indent needed to center}
      CTIndent := 0;
      TW := TextWidth(Title);
      WD := R.Bottom - R.Top;
      if TW < WD then
        CTIndent := (WD - TW) div 2;

      HoldColor := Canvas.Font.Color;
      if IsEnabled then begin
        {draw shadow first, if selected}
        if FShadowedText then begin
          {draw the shadow text first}
          Canvas.Font.Color := FTextShadowColor;
          SetBkMode(Canvas.Handle, OPAQUE);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Right-TxtOfs, Rect.Top+tabTabBorder+CTIndent, Title);

          {draw normal text}
          Canvas.Font.Color := HoldColor;
          SetBkMode(Canvas.Handle, TRANSPARENT);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Right-TxtOfs-2, Rect.Top+tabTabBorder+CTIndent-1, Title);

          {draw underline character, if any}
          if UPos > 0 then begin
            TH := TextHeight(Title)-1;
            Pen.Color := Canvas.Font.Color;
            MoveTo(Rect.Right-TxtOfs-TH-2, Rect.Top+tabTabBorder+UIndent+CTIndent-1);
            LineTo(Rect.Right-TxtOfs-TH-2, Rect.Top+tabTabBorder+UIndent+CTIndent+
                   TextWidth(Title[UPos])-1);
          end;
        end else begin  {normal tab}
          {draw the text}
          SetBkMode(Canvas.Handle, OPAQUE);
          if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
          TextOut(Rect.Right-TxtOfs, Rect.Top+tabTabBorder+CTIndent, Title);

          {draw underline character, if any}
          if UPos > 0 then begin
            TH := TextHeight(Title)-1;
            Pen.Color := Canvas.Font.Color;
            MoveTo(Rect.Right-TxtOfs-TH, Rect.Top+tabTabBorder+UIndent+CTIndent);
            LineTo(Rect.Right-TxtOfs-TH, Rect.Top+tabTabBorder+UIndent+CTIndent+
                   TextWidth(Title[UPos]));
          end;
        end;
      end else begin  {inactive tab}
        {draw the highlight text first}
        Canvas.Font.Color := FHighlightColor;
        SetBkMode(Canvas.Handle, OPAQUE);
        if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
        TextOut(Rect.Right-TxtOfs+1, Rect.Top+tabTabBorder+CTIndent, Title);

        {draw shadow text for inactive tab}
        SetBkMode(Canvas.Handle, TRANSPARENT);
        if Canvas.Handle <> 0 then {force handle update after SetBkMode call};
        Canvas.Font.Color := FShadowColor;
        TextOut(Rect.Right-TxtOfs, Rect.Top+tabTabBorder+CTIndent-2, Title);

        {draw underline character, if any}
        if UPos > 0 then begin
          TH := TextHeight(Title)-1;
          Pen.Color := Canvas.Font.Color;
          MoveTo(Rect.Right-TxtOfs-TH-1, Rect.Top+tabTabBorder+UIndent+CTIndent-1);
          LineTo(Rect.Right-TxtOfs-TH-1, Rect.Top+tabTabBorder+UIndent+CTIndent+
                 TextWidth(Title[UPos])-1);
        end;

        {restore font color}
        Canvas.Font.Color := HoldColor;
      end;

    end;
  end;

  procedure DrawTriangle(X, Y : Integer; Left : Boolean);
  begin
    if Row <> StartRow then begin
      {get color from directly to the right of this triangle area}
      Canvas.Brush.Color := Canvas.Pixels[X+1,Y];
      Canvas.Pen.Color := Canvas.Brush.Color;
    end;
    if Left then
      Canvas.Polygon([Point(X,Y), Point(X-1,Y), Point(X,Y+1)])
    else
      Canvas.Polygon([Point(X,Y), Point(X,Y-2), Point(X-2,Y)]);
  end;

begin
  {get the page color}
  if FPageUsesTabColor then begin
    TP := TOvcTabPage(FPages[PageIndex]);
    tabPainting := True;
    try
      Color := TP.TabColor;
    finally
      tabPainting := False;
    end;
  end;

  {get current parent color}
  if Parent is TControl then
    PC := TLocalControl(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    {clear area above and below tabs}
    Brush.Color := PC;
    Pen.Color := PC;
    Rectangle(Width-tabTotalRows*FTabHeight-2, 0, Width, 2);
    Rectangle(Width-tabTotalRows*FTabHeight-2, Height-2, Width, Height);

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars))) div 2 - 1;

    {right side (top) of tab row}
    XOfs := Width-2;

    {clear the two pixel blank area to the right of the tabs}
    Brush.Color :=  PC;
    Pen.Color :=  PC;
    Rectangle(Width, 0, Width-2, Height);

    if not OldStyle then
      Rectangle(Width-tabTotalRows*FTabHeight-2,2,Width,Height);

    {start with the row after the row containing the focused tab}
    Row := Succ(tabFocusedRow);
    if Row > tabLastRow then
      Row := 0;
    StartRow := Row;
    repeat
      YOfs := 2;  {top (left edge) of first tab}
      TabsUsed := 0;
      for I := 0 to FPages.Count-1 do begin
        TP := TOvcTabPage(FPages[I]);
        if (TP.Row = Row) and (TP.PageVisible or (csDesigning in componentState)) then begin
          {record tab area}
          TP.Area := Bounds(XOfs-FTabHeight, YOfs, FTabHeight, TP.TabWidth);

          {set the font to use}
          Canvas.Font := TP.Font;
          Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 270);

          {draw the tab}
          Canvas.Font.Color := TP.TextColor;
          TabRect := TP.Area;
          TabRect.Left := Width-tabTotalRows*FTabHeight-2;
          DrawTab(I, TP.Caption, Enabled and TP.Enabled, (I = PageIndex), TextOfs, TP.Area, TabRect);

          {paint corners to match parent color}
          Brush.Color := PC;
          Pen.Color := PC;
          if Row = StartRow then begin
            DrawTriangle(TP.Area.Right, TP.Area.Top, True);     {top}
            DrawTriangle(TP.Area.Right, TP.Area.Bottom, False); {bottom}
          end else begin
            if TabsUsed = 0 then
              DrawTriangle(TP.Area.Right, TP.Area.Top, True);   {top}
            DrawTriangle(TP.Area.Right, TP.Area.Bottom, False); {bottom}
          end;

          Inc(TabsUsed);
          YOfs := TP.Area.Bottom;  {next tab in row}
        end;
      end;

      Dec(XOfs, FTabHeight);
      Inc(Row);
      if Row > tabLastRow then Row := 0;
    until Row = StartRow;

    {draw the active tab}

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars)) + 2) div 2;

    TP := TOvcTabPage(FPages[PageIndex]);
    if FUseActiveTabFont then
      Canvas.Font := FActiveTabFont
    else begin
      Canvas.Font := TP.Font;
      Canvas.Font.Color := TP.TextColor;
    end;
    Canvas.Font.Handle := CreateRotatedFont(Canvas.Font, 270);

    R := TP.Area;
    InflateRect(R, 2, 2);
    Inc(R.Left, 2);
    DrawTab(PageIndex, TP.Caption, Enabled and TP.Enabled, True, TextOfs, R, R);

    {reset to default font and colors so focus rect is drawn properly}
    Canvas.Font := Self.Font;
    Canvas.Brush.Color := Color;
    Canvas.Pen.Color := Color;

    {draw the focus rect if the tab has the focus}
    if Focused then
      tabDrawFocusRect(PageIndex);
  end;
end;

procedure TOvcNotebook.tabPaintTopTabs;
var
  TP         : TOvcTabPage;
  I          : Integer;
  YOfs       : Integer;
  XOfs       : Integer;
  R          : TRect;
  TabRect    : TRect;
  TextOfs    : Integer;
  Row        : Integer;
  StartRow   : Integer;
  TabsUsed   : Integer;
  PC         : TColor;
  CR: TRect;
  Details: TThemedElementDetails;

  procedure DrawTabBorder({const} TR : TRect; Current, Hot, IsEnabled : Boolean);
  var
    PW         : Integer;
    L, T, R, B : Integer;
    TT: TThemedTab;
    Details: TThemedElementDetails;
    RBody: TRect;
  begin
    if ThemesEnabled and (TP.TabColor=clBtnFace) then
    begin
      Details := ThemeServices.GetElementDetails(ttPane);
      RBody := Rect(0, 0 + TR.Bottom, Width, Height);
      ThemeServices.DrawElement(Canvas.Handle, Details, RBody);

      if not IsEnabled then
        TT := ttTabItemDisabled
      else if Current then
        TT := ttTabItemSelected
      else if Hot then
        TT := ttTabItemHot
      else
        TT := ttTabItemNormal;

      // Tab touches both left and right border (there is 1 pixel gap; this is probably intentional)
      if (TR.Left = 0) and (TR.Right >= Width) then
      begin
        case TT of
          ttTabItemNormal: TT := ttTabitemBothEdgeNormal;
          ttTabItemHot: TT := ttTabItemBothEdgeHot;
          ttTabItemSelected: TT := ttTabItemBothEdgeSelected;
        end;
        Dec(TR.Right, 2);
      end
      // Tab touches left border
      else if TR.Left = 0 then
        case TT of
          ttTabItemNormal: TT := ttTabitemLeftEdgeNormal;
          ttTabItemHot: TT := ttTabItemLeftEdgeHot;
          ttTabItemSelected: TT := ttTabItemLeftEdgeSelected;
        end
      // Tab touches right border
      else if TR.Right = Width then
        case TT of
          ttTabItemNormal: TT := ttTabitemRightEdgeNormal;
          ttTabItemHot: TT := ttTabItemRightEdgeHot;
          ttTabItemSelected: TT := ttTabItemRightEdgeSelected;
        end;
      Inc(TR.Bottom, 2); // we must draw a little bit into the border of the main area
      Details := ThemeServices.GetElementDetails(TT);
      ThemeServices.DrawElement(Canvas.Handle, Details, TR);
    end
    else
    with Canvas do begin
      with TR do begin
        L := Left;
        T := Top;
        R := Right;
        B := Bottom;
      end;

      {fill the tab area}
      Brush.Color := TP.TabColor;
      Pen.Color := TP.TabColor;
      Polygon([Point(L,       B),
               Point(L,       T+2),
               Point(L+2,     T),
               Point(R-4,     T),
               Point(R-2,     T+2),
               Point(R-2,     B)]);

      {highlight}
      Pen.Color := FHighlightColor;
      PolyLine([Point(L,      B-1),
                Point(L,      T+2),
                Point(L+2,    T),
                Point(R-2,    T)]);

      {border}
      Pen.Color := clBlack;
      PolyLine([Point(R-2,    T+1),
                Point(R-1,    T+2),
                Point(R-1,    B)]);

      {shadow}
      Pen.Color := FShadowColor;
      PolyLine([Point(R-2,    T+2),
                Point(R-2,    B)]);

      if Current then begin
        PW := Self.Width; {page width}

        {clear area directly below the tab}
        Pen.Color := Color;
        Rectangle(L, B, R, B+1);

        {highlight}
        Pen.Color := FHighlightColor;
        PolyLine([Point(L,    B),
                  Point(0,    B),
                  Point(0,    Height-1)]);
        Pen.Color := FHighlightColor;
        PolyLine([Point(R-1,  B),
                  Point(PW-2, B)]);

        {border}
        Pen.Color := clBlack;
        PolyLine([Point(0,    Height-1),
                  Point(PW-1, Height-1),
                  Point(PW-1, B-1)]);
        {shadow}
        Pen.Color := FShadowColor;
        PolyLine([Point(1,    Height-2),
                  Point(PW-2, Height-2),
                  Point(PW-2, B-1)]);
      end;
    end;
  end;

  procedure DrawTab(Index : Integer; const Title : string; IsEnabled,
                    IsTabActive : Boolean;
                    TxtOfs : Integer; {const} Rect : TRect;
                    {const} TabRect : TRect);
  var
    HoldColor : TColor;
  begin

    {draw the tab and borders}
    R := Rect;
    DrawTabBorder(TabRect, IsTabActive, Index = FHotTab, IsEnabled);

    with Canvas do begin
      {get text bounding rectangle}
      R := Rect;
      Inc(R.Left, tabTabBorder);
      Inc(R.Top, TxtOfs);
      Dec(R.Right, tabTabBorder);
      Dec(R.Bottom, TxtOfs);

      if (R.Right > Width-2) then
        R.Right := Width-tabTabBorder*2-2;

      {exit if user has drawn the tab}
      if DoOnDrawTab(Index, Title, IsEnabled, IsTabActive) then
        Exit;

      {exit if text won't fit on tab}
      if TextHeight(Title) > FTabHeight - tabMargin*2 then
        Exit;

      HoldColor := Canvas.Font.Color;
      if IsEnabled then begin
        {draw shadow first, if selected}
        if FShadowedText then begin
          Canvas.Font.Color := FTextShadowColor;
          if ThemesEnabled then
            SetBkMode(Canvas.Handle, TRANSPARENT)
          else
            SetBkMode(Canvas.Handle, OPAQUE);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
          Canvas.Font.Color := HoldColor;
          SetBkMode(Canvas.Handle, TRANSPARENT);
          OffsetRect(R, -2, -1);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        end else begin
          {draw the text}
          if ThemesEnabled then
            SetBkMode(Canvas.Handle, TRANSPARENT)
          else
            SetBkMode(Canvas.Handle, OPAQUE);
          DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        end;
      end else begin
        {use shadow text for inactive tabs}
        Canvas.Font.Color := FHighlightColor;
        if ThemesEnabled then
          SetBkMode(Canvas.Handle, TRANSPARENT)
        else
          SetBkMode(Canvas.Handle, OPAQUE);
        DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
        SetBkMode(Canvas.Handle, TRANSPARENT);
        Canvas.Font.Color := FShadowColor;
        OffsetRect(R, -2, -1);
        DrawText(Canvas.Handle, PChar(Title), -1, R, DT_CENTER or DT_SINGLELINE);
      end;
      Canvas.Font.Color := HoldColor;
    end;
  end;

  procedure DrawTriangle(X, Y : Integer; Left : Boolean);
  begin
    if ThemesEnabled then
      Exit;
    if Row <> StartRow then begin
      {get color from directly above this triangle area}
      Canvas.Brush.Color := Canvas.Pixels[X,Y-1];
      Canvas.Pen.Color := Canvas.Brush.Color;
    end;
    if Left then
      Canvas.Polygon([Point(X,Y), Point(X+1,Y), Point(X,Y+1)])
    else
      Canvas.Polygon([Point(X,Y), Point(X-2,Y), Point(X,Y+2)]);
  end;

begin
  if ThemesEnabled then
  begin
    CR := ClientRect;
    Details := ThemeServices.GetElementDetails(tttabDontCare);
    ThemeServices.DrawParentBackground(Handle, Canvas.Handle, Details, True, @CR);
  end;
  {get page color}
  if FPageUsesTabColor then begin
    TP := TOvcTabPage(FPages[PageIndex]);
    tabPainting := True;
    try
      Color := TP.TabColor;
    finally
      tabPainting := False;
    end;
  end;

  {get current parent color}
  if Parent is TControl then
    PC := TLocalControl(Parent).Color
  else
    PC := Color;

  with Canvas do begin
    {clear area to left and right of tabs}
    Brush.Color := PC;
    Pen.Color := PC;

    if OldStyle then begin
      Rectangle(0, 0, 2, tabTotalRows*FTabHeight+2);
      Rectangle(Width-2, 0, Width, tabTotalRows*FTabHeight+2);
    end else
      Rectangle(0,2,Width,tabTotalRows*FTabHeight+2);

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars))) div 2;

    {top of tab row}
    YOfs := 2;

    {clear the two pixel blank area above the tabs}
    Brush.Color :=  PC;
    Pen.Color :=  PC;
    Rectangle(0, 0, Width, 2);

    {start with the row after the row containing the focused tab}
    Row := Succ(tabFocusedRow);
    if Row > tabLastRow then
      Row := 0;
    StartRow := Row;
    repeat
      XOfs := 2; {left of first tab}
      TabsUsed := 0;
      for I := 0 to FPages.Count-1 do begin
        TP := TOvcTabPage(FPages[I]);
        if (TP.Row = Row) and (TP.PageVisible or (csDesigning in componentState)) then begin
          {record tab area}
          TP.Area := Bounds(XOfs, YOfs, TP.TabWidth, FTabHeight);

          {set the font to use}
          Canvas.Font := TP.Font;

          {draw the tab}
          Canvas.Font.Color := TP.TextColor;
          TabRect := TP.Area;
          TabRect.Bottom := tabTotalRows*FTabHeight+2;
          DrawTab(I, TP.Caption, Enabled and TP.Enabled, (I = PageIndex), TextOfs, TP.Area, TabRect);

          {paint corners to match parent color}
          Brush.Color := PC;
          Pen.Color := PC;
          if Row = StartRow then begin
            DrawTriangle(TP.Area.Left, TP.Area.Top, True);    {left}
            DrawTriangle(TP.Area.Right, TP.Area.Top, False);  {right}
          end else begin
            if TabsUsed >0 then
              DrawTriangle(TP.Area.Left, TP.Area.Top, True);  {left}
            DrawTriangle(TP.Area.Right, TP.Area.Top, False);  {right}
          end;

          Inc(TabsUsed);
          XOfs := TP.Area.Right;
        end;
      end;

      Inc(YOfs, FTabHeight);
      Inc(Row);
      if Row > tabLastRow then Row := 0;
    until Row = StartRow;

    {draw the active tab}

    {calculate starting position of text}
    TextOfs := (FTabHeight - TextHeight(GetOrphStr(SCTallLowChars)) + 2) div 2;

    TP := TOvcTabPage(FPages[PageIndex]);
    if FUseActiveTabFont then
      Canvas.Font := FActiveTabFont
    else begin
      Canvas.Font := TP.Font;
      Canvas.Font.Color := TP.TextColor;
    end;

    R := TP.Area;
    InflateRect(R, 2, 2);
    Dec(R.Bottom, 2);
    TabRect := R;
    DrawTab(PageIndex, TP.Caption, Enabled and TP.Enabled, True, TextOfs, R, TabRect);

    {reset to default font and colors so focus rect is drawn properly}
    Canvas.Brush.Color := TP.TabColor;
    Canvas.Pen.Color := TP.TabColor;

    {draw the focus rect if the tab has the focus}
    if Focused then
      tabDrawFocusRect(PageIndex);
  end;
end;

procedure TOvcNotebook.WMEraseBkgnd(var Msg : TWMEraseBkgnd);
begin
  Msg.Result := 1;   {don't erase background, just say we did}
end;

procedure TOvcNotebook.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  inherited;

  if csDesigning in ComponentState then
    Msg.Result := DLGC_STATIC
  else
    Msg.Result := Msg.Result or DLGC_WANTARROWS;
end;

procedure TOvcNotebook.WMKeyDown(var Msg : TWMKeyDown);
var
  I   : Integer;
  Cmd : Word;
  Pt  : TPoint;
  TP  : TOvcTabPage;
begin
  {translate the key to a command}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));

  if Cmd <> ccNone then begin
    if Cmd in [ccLeft, ccRight, ccUp, ccDown, ccHome, ccEnd] then begin
      tabTabSelecting := True;

      I := -1;
      if FTabOrientation = toTop then begin
        case Cmd of
          ccLeft  : I := PrevValidIndex(PageIndex);
          ccRight : I := NextValidIndex(PageIndex);
          ccUp    :
            if tabTotalRows > 1 then begin
              TP := TOvcTabPage(FPages[PageIndex]);
              {fake a mouse click on the tab above this one}
              Pt.X := TP.Area.Left + TP.TabWidth div 2;
              Pt.Y := TP.Area.Top - FTabHeight div 2;
              MouseDown(mbLeft, [], Pt.X, Pt.Y);
            end;
          ccHome  : I := NextValidIndex(FPages.Count-1);
          ccEnd   : I := PrevValidIndex(0);
        end;
      end else if FTabOrientation = toBottom then begin
        case Cmd of
          ccLeft  : I := PrevValidIndex(PageIndex);
          ccRight : I := NextValidIndex(PageIndex);
          ccDown  :
            if tabTotalRows > 1 then begin
              TP := TOvcTabPage(FPages[PageIndex]);
              {fake a mouse click on the tab below this one}
              Pt.X := TP.Area.Left + TP.TabWidth div 2;
              Pt.Y := TP.Area.Bottom + FTabHeight div 2;
              MouseDown(mbLeft, [], Pt.X, Pt.Y);
            end;
          ccHome  : I := NextValidIndex(FPages.Count-1);
          ccEnd   : I := PrevValidIndex(0);
        end;
      end else if FTabOrientation = toRight then begin
        case Cmd of
          ccUp    : I := PrevValidIndex(PageIndex);
          ccDown  : I := NextValidIndex(PageIndex);
          ccRight :
            if tabTotalRows > 1 then begin
              TP := TOvcTabPage(FPages[PageIndex]);
              {fake a mouse click on the tab to the right of this one}
              Pt.X := TP.Area.Right + FTabHeight div 2;
              Pt.Y := TP.Area.Top + TP.TabWidth div 2;
              MouseDown(mbLeft, [], Pt.X, Pt.Y);
            end;
          ccHome  : I := NextValidIndex(FPages.Count-1);
          ccEnd   : I := PrevValidIndex(0);
        end;
      end else if FTabOrientation = toLeft then begin
        case Cmd of
          ccUp    : I := NextValidIndex(PageIndex);
          ccDown  : I := PrevValidIndex(PageIndex);
          ccLeft :
            if tabTotalRows > 1 then begin
              TP := TOvcTabPage(FPages[PageIndex]);
              {fake a mouse click on the tab to the left of this one}
              Pt.X := TP.Area.Left - FTabHeight div 2;
              Pt.Y := TP.Area.Top + TP.TabWidth div 2;
              MouseDown(mbLeft, [], Pt.X, Pt.Y);
            end;
          ccHome  : I := NextValidIndex(FPages.Count-1);
          ccEnd   : I := PrevValidIndex(0);
        end;
      end;

      {set new page index}
      if I > -1 then begin
        PageIndex := I;
        SetFocus;
      end;
    end else
      {do user command notification for user commands}
      if Cmd >= ccUserFirst then
        DoOnUserCommand(Cmd);

    {indicate that this message was processed}
    Msg.Result := 0;
  end;

  inherited;
end;

procedure TOvcNotebook.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  inherited;

  tabHitTest.X := Msg.Pos.X;
  tabHitTest.Y := Msg.Pos.Y;
end;

procedure TOvcNotebook.WMKillFocus(var Msg : TWMKillFocus);
begin
  {re-draw the tab--erasing the focus rectangle, if any}
  InvalidateTab(PageIndex);

  {release the mouse}
  if GetCapture = Handle then
    ReleaseCapture;

  inherited;
end;

procedure TOvcNotebook.WMMouseActivate(var Msg : TWMMouseActivate);
var
  TP         : TOvcTabPage;
  I          : Integer;
  P          : TPoint;
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;

  {see if the tab should be given the focus}
  if Msg.MouseMsg = WM_LBUTTONDOWN then begin
    GetCursorPos(P);
    P := ScreenToClient(P);

    for I := 0 to Pred(FPages.Count) do begin
      TP := TOvcTabPage(FPages[I]);
      if TP.Enabled and PtInRect(TP.Area, Point(P.X, P.Y)) then begin
        SetFocus;
        Break;
      end;
    end;

  end;
end;

procedure TOvcNotebook.WMSetCursor(var Msg : TWMSetCursor);
var
  TP : TOvcTabPage;
  I  : Integer;

  procedure SetNewCursor(C : HCursor);
  begin
    SetCursor(C);
    Msg.Result := Ord(True);
  end;

begin
  if csDesigning in ComponentState then begin
    if (Msg.HitTest = HTCLIENT) then begin
      tabOverTab := False;
      tabHitTest := ScreenToClient(tabHitTest);

      {check if mouse is over a tab}
      for I := 0 to FPages.Count-1 do begin
        TP := TOvcTabPage(FPages[I]);
        if PtInRect(TP.Area, tabHitTest) then begin
          tabOverTab := True;
          Break;
        end;
      end;
    end;

    {set appropriate cursor}
    if tabOverTab then
      SetNewCursor(tabTabCursor)
    else
      inherited;
  end else
    inherited;
end;

procedure TOvcNotebook.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  {force repaint of tab and drawing of focus rect}
  InvalidateTab(PageIndex);
end;

procedure TOvcNotebook.AncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
  Component := FPages.ItemByName(ComponentName);
end;

procedure TOvcNotebook.ReadState(Reader : TReader);
var
  SaveAncestorNotFound : TAncestorNotFoundEvent;
begin
  SaveAncestorNotFound := Reader.OnAncestorNotFound;
  try
    Reader.OnAncestorNotFound := AncestorNotFound;
    inherited ReadState(Reader);
  finally
    Reader.OnAncestorNotFound := SaveAncestorNotFound;
  end;
end;

end.


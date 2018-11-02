{*********************************************************}
{*                   O32IGRID.PAS 4.08                   *}
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
{*   Armin Biernaczyk:                                                        *}
{*     07/2011: Changed 'xxx.List^[I]' to 'xxx.List[M]' in several places     *}
{*              (for compatibility with Delphi Pulsar)                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}


unit o32igrid;
  {Orpheus InspectorGrid component and support classes.}

interface

uses
  Types, Windows, Graphics, Classes, Forms, Mask, StdCtrls, ExtCtrls, Grids, Messages,
  Controls, OvcBase, OvcCmbx, OvcClrCb, ovcftcbx, UITypes;

const
  ScrollBarWidth = 16;

type
  {Forward Declarations}
  TO32CustomInspectorGrid = class;

  TO32InspectorItem = class;

  TO32IGridItemType = (itParent, itSet, itList, itString, itInteger,
    itFloat, itCurrency, itDate, itColor, itLogical, itFont);

  TO32IGridCell = (icLeft, icRight);


  {Events}
  To32IGridItemEvent =
    procedure(Sender: TObject; Item: Word) of object;
  To32IGridDeleteItemEvent =
    procedure(Sender: TObject; Item: Word;
              var AllowIt: Boolean) of object;
  TO32GetEditMaskEvent =
    procedure(Sender: TObject; Item: TO32InspectorItem;
              var Mask: string) of object;
  TO32GetEditTextEvent =
    procedure(Sender: TObject; Item: TO32InspectorItem;
              var Text: string) of object;
  TO32GetEditLimitEvent =
    procedure(Sender: TObject; Item: TO32InspectorItem;
              var Limit: Integer) of object;
  TO32IGridCellPaintEvent =
    procedure(Sender: TObject; Rect: TRect;
              Canvas: TCanvas;
              Item: Word;
              Cell: TO32IGridCell;
              var Default: Boolean) of object;

  { Edit }
  TO32GridEdit = class(TCustomMaskEdit)
  protected {private}
    FGrid      : TO32CustomInspectorGrid;
    FClickTime : Integer;
    Updating   : Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TO32CustomInspectorGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Changed(Sender: TObject);
    procedure DblClick; override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function EditCanModify: Boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;

    property  Grid: TO32CustomInspectorGrid read FGrid;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Deselect;
    procedure Hide;
    {D4, 5 ...}
    procedure Invalidate; reintroduce;
    procedure SetFocus; reintroduce;
    procedure Move(const Loc: TRect);
    function PosEqual(const Rect: TRect): Boolean;
    procedure UpdateLoc(const Loc: TRect);
    function Visible: Boolean;
  end;

  { Combo box }
  TO32GridCombo = class(TCustomComboBox)
  protected {private}
    FGrid       : TO32CustomInspectorGrid;
    FClickTime  : Integer;
    FStyle      : TComboBoxStyle;
    Updating   : Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TO32CustomInspectorGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Changed(Sender: TObject);
    procedure DblClick; override;
    procedure DropDownList(Value: Boolean);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    function  EditCanModify: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;
    property  Grid: TO32CustomInspectorGrid read FGrid;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Deselect;
    procedure Hide;
    procedure Move(const Loc: TRect);
    procedure UpdateLoc(const Loc: TRect);
  end;

  { Color Combo }
  TO32GridColorCombo = class(TOvcCustomColorComboBox)
  protected {private}
    FGrid      : TO32CustomInspectorGrid;
    FClickTime : Integer;
    FStyle     : TComboBoxStyle;
    Updating   : Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TO32CustomInspectorGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Changed(Sender: TObject);
    procedure DblClick; override;
    procedure DropDownList(Value: Boolean);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure WMMouseWheel(var Msg : TMessage); message WM_MOUSEWHEEL;
    function  EditCanModify: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;
    property  Grid: TO32CustomInspectorGrid read FGrid;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Deselect;
    procedure Hide;
    procedure Move(const Loc: TRect);
    procedure UpdateLoc(const Loc: TRect);
  end;

  { FontCombo }
  TO32GridFontCombo = class(TOvcFontComboBox)
  protected {private}
    FGrid      : TO32CustomInspectorGrid;
    FClickTime : Integer;
    FStyle     : TComboBoxStyle;
    Updating   : Boolean;
    procedure InternalMove(const Loc: TRect; Redraw: Boolean);
    procedure SetGrid(Value: TO32CustomInspectorGrid);
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Changed(Sender: TObject);
    procedure DblClick; override;
    procedure DropDownList(Value: Boolean);
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
    procedure WMMouseWheel(var Msg : TMessage); message WM_MOUSEWHEEL;
    function  EditCanModify: Boolean;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure BoundsChanged; virtual;
    procedure UpdateContents; virtual;
    procedure WndProc(var Message: TMessage); override;
    property  Grid: TO32CustomInspectorGrid read FGrid;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Deselect;
    procedure Hide;
    procedure Move(const Loc: TRect);
    procedure UpdateLoc(const Loc: TRect);
  end;


  { InspectorItem }
  TO32InspectorItem = class(TO32CollectionItem)
  protected {private}
    FType       : TO32IGridItemType;
    FCaption    : string;
    FParent     : TO32InspectorItem;
    FParentIndex: Integer;
    FAbsIndex   : Word;
    FIGrid      : TO32CustomInspectorGrid;
    FInt        : Integer;
    FString     : string;
    FDouble     : Double;
    FImageIndex : Integer;
    FReadOnly   : Boolean;
    FExpanded   : Boolean;
    FCurrency   : Currency;
    FDate       : TDateTime;
    FColor      : TColor;
    FLogical    : Boolean;
    FFont       : TFont;
    FLevel      : Integer;
    FVisible    : Boolean;
    FItemsList  : TStringList;
    FTag        : Integer;

    {Property Methods}
    procedure SetType(Value: TO32IGridItemType);
    procedure SetCaption(Value: string);
    procedure SetCurrency(Value: Currency);
    procedure SetDate(Value :TDateTime);
    procedure SetString(Value: string);
    procedure SetIndex(Value: Integer); override;
    procedure SetInteger(Value: Integer);
    procedure SetItemsList(Value: TStringList);
    procedure SetFloat(Value: double);
    procedure SetColor(Value: TColor);
    procedure SetBoolean(Value: boolean);
    procedure SetExpanded(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetValue(Value: Variant);
    procedure SetVisible(Value: Boolean);

    function CountChildren: Integer;

    function  GetCurrency: Currency;
    function  GetDate: TDateTime;
    function  GetString: string;
    function  GetInteger: Integer;
    function  GetItemsList: TStringList;
    function  GetFloat: double;
    function  GetColor: TColor;
    function  GetBoolean: boolean;
    function  GetFont: TFont;
    function  GetValue: Variant;

    procedure DefineProperties(Filer: TFiler); override;
    procedure StoreParent(Writer: TWriter);
    procedure LoadParent(Reader: TReader);
    procedure StoreValue(Writer: TWriter);
    procedure LoadValue(Reader: TReader);
    function  StrToColor(Value: string): TColor;
    function  ColorToStr(Value: TColor): string;
    function  GetElementsAsString: string;
    procedure SetElementsAsString(Value: string);

  public
    SL : TStringlist;
    ObjectRef : TObject;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Collapse;
    procedure Expand;
    procedure DeleteChildren;
    procedure FreeObject;
    procedure AddObject(Ref: TObject);

    property AbsoluteIndex: Word
      read FAbsIndex;
    property ChildCount: Integer
      read CountChildren;
    property InspectorGrid: TO32CustomInspectorGrid
      read FIGrid;
    property AsDate: TDateTime
      read GetDate write SetDate;
    property AsString: string
      read GetString write SetString;
    property AsInteger: Integer
      read GetInteger write SetInteger;
    property AsFloat: Double
      read GetFloat write SetFloat;
    property AsCurrency: Currency
      read GetCurrency write SetCurrency;
    property AsColor: TColor
      read GetColor write SetColor;
    property AsBoolean: Boolean
      read GetBoolean write SetBoolean;
    property AsFont: TFont
      read GetFont write SetFont;
    property Expanded: Boolean
      read FExpanded write SetExpanded;
    property Parent: TO32InspectorItem
      read FParent;
    property ParentIndex: Integer
      read FParentIndex;
    property Value: Variant
      read GetValue write SetValue;
    property Level: Integer
      read FLevel;
  published
    property Caption: string
      read FCaption write SetCaption;
    property DisplayText : string
      read GetString write SetString;
    property ImageIndex: Integer
      read FImageIndex write FImageIndex;
    property ItemsList: TStringList
      read GetItemsList write SetItemsList;
    property ItemType: TO32IGridItemType
      read FType write SetType;
    property ReadOnly: Boolean
      read FReadOnly write FReadOnly;
    property Tag: Integer
      read FTag write FTag;
    property Visible: Boolean
      read FVisible write SetVisible;
    property Name;
  end;

  {InspectorItems}
  TO32InspectorItems = class(TO32Collection)
  protected{private}
    FInspectorGrid : TO32CustomInspectorGrid;
    FVisibleItems  : TList;
    function  Compare(Item1, Item2: TO32InspectorItem): Integer;
    procedure SortList(AList: TList);
    procedure Sort;
    procedure LoadChildren(TargetList: TList);
    function GetTypeNumber(Value: TO32IGridItemType): Integer;

  public
    constructor Create(AOwner : TPersistent;
                       ItemClass : TCollectionItemClass); override;
    destructor Destroy; override;
    procedure LoadVisibleItems;
    function AddItem(ItemType: TO32IGridItemType;
                     Parent: TO32InspectorItem): TO32InspectorItem;
    function InsertItem(ItemType: TO32IGridItemType;
                        Parent: TO32InspectorItem;
                        Index: Integer): TO32InspectorItem;
    property VisibleItems: TList read FVisibleItems;
  end;


  {InspectorGrid}
  TO32CustomInspectorGrid = class(TO32CustomControl)
  protected {private}
    FItemTextColor        : TColor;
    FCaptionTextColor     : TColor;
    FAutoExpand           : Boolean;
    FGridLineColor        : TColor;
    FFont                 : TFont;
    FChildIndentation     : Word;
    FEditCellColor        : TColor;
    FItems                : TO32InspectorItems;
    FTextColor            : TColor;
    FUpdatingIndex        : Integer;
    FImages               : TImageList;
    FAnchor               : TGridCoord;
    FBorderStyle          : TBorderStyle;
    FCanEditModify        : Boolean;
    FColCount             : Integer;
    FColWidths            : Pointer;
    FTabStops             : Pointer;
    FCurrent              : TGridCoord;
    FDefaultColWidth      : Integer;
    FDefaultRowHeight     : Integer;
    FEditColor            : TColor;
    FFixedCols            : Integer;
    FFixedRows            : Integer;
    FFixedColor           : TColor;
    FGridLineWidth        : Integer;
    FOptions              : TGridOptions;
    FReadOnly             : Boolean;
    FRowCount             : Integer;
    FRowHeights           : Pointer;
    FSorted               : Boolean;
    FScrollBars           : TScrollStyle;
    FTopLeft              : TGridCoord;
    FSizingIndex          : Integer;
    FSizingPos            : Integer;
    FSizingOfs            : Integer;
    FMoveIndex            : Integer;
    FMovePos              : Integer;
    FHitTest              : TPoint;
    FInplaceEdit          : TWinControl;
    FInplaceCol           : Integer;
    FInplaceRow           : Integer;
    FColOffset            : Integer;
    FDefaultDrawing       : Boolean;
    FEditorMode           : Boolean;
    FGridState            : TGridState;
    FSaveCellExtents      : Boolean;
    DesignOptionsBoost    : TGridOptions;
    FActiveItem           : integer;
    FExpandGlyph          : TBitmap;

    FAfterEdit : To32IGridItemEvent;
    FBeforeEdit: To32IGridItemEvent;
    FOnCellPaint: TO32IGridCellPaintEvent;
    FOnDelete: To32IGridDeleteItemEvent;
    FOnExpand: To32IGridItemEvent;
    FOnCollapse: To32IGridItemEvent;
    FOnGetEditMask: TO32GetEditMaskEvent;
    FOnGetEditText: TO32GetEditTextEvent;
    FOnGetEditLimit: TO32GetEditLimitEvent;
    FOnItemChange: To32IGridItemEvent;
    FOnItemEditorChange: To32IGridItemEvent;
    FOnItemSelect: To32IGridItemEvent;

    procedure SetCaptionTextColor(const Value: TColor);
    procedure SetItemTextColor(const Value: TColor);
    procedure SetGridLineColor(const Value: TColor);
    procedure SetActiveItem(const Value: integer);
    function  GetAbout : string;
    procedure SetAbout(const Value : string);
    procedure SetFont(const Value: TFont);
    function  GetCells(ACol, ARow: Integer): string;
    procedure SetCells(ACol, ARow: Integer; const Value: string);
    procedure SetEditCellColor(const Value: TColor);
    function  CalcCoordFromPoint(X, Y: Integer;
                const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CalcDrawInfoXY(var DrawInfo: TGridDrawInfo;
                UseWidth, UseHeight: Integer);
    function  CalcMaxTopLeft(const Coord: TGridCoord;
                const DrawInfo: TGridDrawInfo): TGridCoord;
    procedure CancelMode;
    procedure ChangeSize(NewColCount, NewRowCount: Integer);
    procedure ClampInView(const Coord: TGridCoord);
    procedure DrawMove;
    procedure FocusCell(ACol, ARow: Integer; MoveAnchor: Boolean);
    procedure UpdateCellContents;
    procedure GridRectToScreenRect(GridRect: TGridRect;
                var ScreenRect: TRect; IncludeLine: Boolean);
    function  GetItems(Index: Integer): TO32InspectorItem;
    function GetSelectedItem: TO32InspectorItem;
    procedure HideEdit;
    procedure Initialize;
    procedure InvalidateGrid;
    procedure InvalidateRect(ARect: TGridRect);
    procedure ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal;
                UseRightToLeft: Boolean);
    procedure MoveAnchor(const NewAnchor: TGridCoord);
    procedure MoveAndScroll(Mouse, CellHit: Integer; var DrawInfo: TGridDrawInfo;
                var Axis: TGridAxisDrawInfo; Scrollbar: Integer; const MousePt: TPoint);
    procedure MoveCurrent(ACol, ARow: Integer; MoveAnchor, Show: Boolean);
    procedure MoveTopLeft(ALeft, ATop: Integer);
    procedure ResizeCol(Index: Integer; OldSize, NewSize: Integer);
    procedure ResizeRow(Index: Integer; OldSize, NewSize: Integer);
    procedure ScrollDataInfo(DX, DY: Integer; var DrawInfo: TGridDrawInfo);
    procedure SelectionMoved(const OldSel: TGridRect);
    procedure TopLeftMoved(const OldTopLeft: TGridCoord);
    procedure UpdateScrollPos;
    procedure UpdateScrollRange;
    function  GetColWidths(Index: Integer): Integer;
    function GetItemCount: Integer;
    function  GetRowHeights(Index: Integer): Integer;
    function  GetSelection: TGridRect;
    function  GetTabStops(Index: Integer): Boolean;
    function IsEditing: Boolean;
    function  IsActiveControl: Boolean;
    procedure ReadColWidths(Reader: TReader);
    procedure ReadRowHeights(Reader: TReader);
    procedure SetCol(Value: Integer);
    procedure SetColWidths(Index: Integer; Value: Integer);
    procedure SetDefaultRowHeight(Value: Integer);
    procedure SetEditorMode(Value: Boolean);
    procedure SetFixedRows(Value: Integer);
    procedure SetEditColor(Value: TColor);
    procedure SetExpandGlyph(Value: TBitmap);
    procedure SetChildIndentation(Value: Word);
    procedure SetOptions(Value: TGridOptions);
    procedure SetReadOnly(Value: Boolean);
    procedure SetRow(Value: Integer);
    procedure SetImageList(Value: TImageList);
    procedure SetRowCount(Value: Integer);
    procedure SetRowHeights(Index: Integer; Value: Integer);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetSelection(Value: TGridRect);
    procedure SetSorted(Value: Boolean);
    procedure SetTabStops(Index: Integer; Value: Boolean);
    procedure SetTopRow(Value: Integer);
    procedure UpdateEdit;
    procedure UpdateText;
    procedure WriteColWidths(Writer: TWriter);
    procedure WriteRowHeights(Writer: TWriter);
    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMCancelMode(var Msg: TWMCancelMode); message WM_CANCELMODE;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;

    function  ParentTypeCount: Integer;
    procedure CalcDrawInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcFixedInfo(var DrawInfo: TGridDrawInfo);
    procedure CalcSizingState(X, Y: Integer; var State: TGridState;
                var Index: Integer; var SizingPos, SizingOfs: Integer;
                var FixedInfo: TGridDrawInfo); virtual;
    procedure CalcRowHeight;
    function  CreateEditor: TWinControl; virtual;
    procedure DestroyEditor;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetParent(Value: TWinControl); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
                X, Y: Integer); override;
    procedure ExpandCollapse(Index: Integer);
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
                X, Y: Integer); override;

    procedure AdjustSize(Index, Amount: Integer; Rows: Boolean); reintroduce; dynamic;

    function BoxRect(ALeft, ATop, ARight, ABottom: Integer): TRect;
    procedure DoExit; override;
    function CellRect(ACol, ARow: Integer): TRect;
    function CanEditAcceptKey(Key: Char): Boolean; dynamic;
    function CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean; dynamic;
    function CanEditModify: Boolean; dynamic;
    function CanEditShow: Boolean; virtual;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    procedure DoOnExpand(Index: Integer);
    procedure DoOnCollapse(Index: Integer);
    procedure WMMouseWheel(var Msg : TMessage); message WM_MOUSEWHEEL;
    function GetEditText(ACol, ARow: Integer): string; dynamic;
    procedure SetEditText(ACol, ARow: Integer; const Value: string); dynamic;
    function GetEditMask(ACol, ARow: Integer): string; dynamic;
    function GetEditLimit: Integer; dynamic;
    function GetGridWidth: Integer;
    function GetGridHeight: Integer;
    procedure HideEditor;
    procedure ShowEditor;
    procedure ShowEditorChar(Ch: Char);
    procedure EditorChanged;
    procedure DrawCell(ACol, ARow: Integer; ARect: TRect;
                AState: TGridDrawState); virtual;
    procedure DefineProperties(Filer: TFiler); override;
    function SelectCell(ACol, ARow: Integer): Boolean; virtual;
    procedure SizeChanged(OldColCount, OldRowCount: Integer); dynamic;
    function Sizing(X, Y: Integer): Boolean;
    procedure ScrollData(DX, DY: Integer);
    procedure InvalidateCell(ACol, ARow: Integer);
    procedure TopLeftChanged; dynamic;
    procedure TimedScroll(Direction: TGridScrollDirection); dynamic;
    procedure Paint; override;
    procedure ColWidthsChanged; dynamic;
    procedure RowHeightsChanged; dynamic;
    procedure UpdateDesigner;
    function BeginColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function BeginRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function CheckColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function CheckRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function EndColumnDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    function EndRowDrag(var Origin, Destination: Integer;
      const MousePt: TPoint): Boolean; dynamic;
    procedure ItemChanged(Item: TO32InspectorItem);
    procedure ItemVisibilityChanged;
    procedure UpdateEditorLocation;
    procedure MoveEditor(ARect: TRect);
    procedure AdjustEditor(ARect: TRect);
    procedure DeselectEditor;
    procedure UpdateEditContents;
    procedure EditorSelectAll;
    procedure SetEditGrid(AGrid: TO32CustomInspectorGrid);
    procedure SetEditFont(Font: TFont);
    procedure SetEditClickTIme(Value: Integer);
    procedure SetEditWndProc(Msg: TMessage);
    function EditorMaxLength: Integer;
    function GetEditorText: string;
    function EditorMatchesType(Index: Integer): Boolean;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(ItemType: TO32IGridItemType;
                 Parent: TO32InspectorItem): TO32InspectorItem;
    function Insert(ItemType: TO32IGridItemType;
      Parent: TO32InspectorItem; Index: Word): TO32InspectorItem;

    procedure Delete(Index: Word);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ExpandAll;
    procedure CollapseAll;
    function GetItemAt(X, Y: Integer): TO32InspectorItem;

    property AutoExpand: Boolean read FAutoExpand write FAutoExpand;
    property ActiveItem: Integer read FActiveItem write SetActiveItem;
    property Col: Integer read FCurrent.X write SetCol;
    property ColWidths[Index: Integer]: Integer read GetColWidths write SetColWidths;
    property DefaultRowHeight: Integer read FDefaultRowHeight write SetDefaultRowHeight default 24;
    property EditCellColor: TColor read FEditCellColor write SetEditCellColor;
    property Editing: Boolean read IsEditing;
    property EditorMode: Boolean read FEditorMode write SetEditorMode;
    property FixedRows: Integer read FFixedRows write SetFixedRows default 1;
    property GridHeight: Integer read GetGridHeight;
    property GridWidth: Integer read GetGridWidth;
    property HitTest: TPoint read FHitTest;
    property InplaceEditor: TWinControl read FInplaceEdit;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TO32InspectorItem read GetItems;
    property Options: TGridOptions read FOptions write SetOptions;
    property RowHeights[Index: Integer]: Integer read GetRowHeights write SetRowHeights;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property Selection: TGridRect read GetSelection write SetSelection;
    property TabStops[Index: Integer]: Boolean read GetTabStops write SetTabStops;
    property TopRow: Integer read FTopLeft.Y write SetTopRow;
    property ActiveRow: Integer read FCurrent.Y write SetRow;

  {To be published}

    property ChildIndentation: word
      read FChildIndentation write SetChildIndentation;
    property CaptionTextColor: TColor read FCaptionTextColor write SetCaptionTextColor;
    property ItemTextColor: TColor read FItemTextColor write SetItemTextColor;
    property Color default clWindow;
    property GridLineColor: TColor read FGridLineColor write SetGridLineColor;
    property EditColor : TColor read FEditColor write SetEditColor;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property ExpandGlyph: TBitmap read FExpandGlyph write SetExpandGlyph default nil;
    property Font: TFont read FFont write SetFont;
    property ItemCollection: TO32InspectorItems read FItems write FItems;
    property Images: TImageList read FImages write SetImageList default nil;
    property ParentColor default False;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default false;
    property RowCount: Integer read FRowCount;
    property Selected: TO32InspectorItem read GetSelectedItem;
    property Sorted: Boolean read FSorted write SetSorted default false;

    property AfterEdit: To32IGridItemEvent
      read FAfterEdit write FAfteredit;
    property BeforeEdit: To32IGridItemEvent
      read FBeforeEdit write FBeforeEdit;
    property OnDelete: To32IGridDeleteItemEvent
      read FOnDelete write FOnDelete;
    property OnExpand: To32IGridItemEvent
      read FOnExpand write FOnExpand;
    property OnCollapse: To32IGridItemEvent
      read FOnCollapse write FOnCollapse;
    property OnCellPaint: TO32IGridCellPaintEvent
      read FOnCellPaint write FOnCellPaint;
    property OnGetEditMask: TO32GetEditMaskEvent
      read FOnGetEditMask write FOnGetEditMask;
    property OnGetEditText: TO32GetEditTextEvent
      read FOnGetEditText write FOnGetEditText;
    property OnGetEditLimit: TO32GetEditLimitEvent
      read FOnGetEditLimit write FOnGetEditLimit;
    property OnItemChange: To32IGridItemEvent
      read FOnItemChange write FOnItemChange;
    property OnItemEditorChange: To32IGridItemEvent
      read FOnItemEditorChange write FOnItemEditorChange;
    property OnItemSelect: To32IGridItemEvent
      read FOnItemSelect write FOnItemSelect;

  published
    property About: string read GetAbout write SetAbout stored false;
    property TabStop default True;
  end;

  TO32InspectorGrid = class(TO32CustomInspectorGrid)
  published
    property Align;
    property Anchors;
    property Constraints;
    property OnContextPopup;
    property AutoExpand;
    property CaptionTextColor;
    property ChildIndentation;
    property Color;
    property Ctl3D;
    property DefaultDrawing;
    property EditColor default clWindow;
    property Enabled;
    property ExpandGlyph;
    property Font;
    property GridLineColor default clBtnShadow;
    property Hint;
    property ItemCollection;
    property ItemTextColor default clNavy;
    property Images;
    property LabelInfo;
    property ParentColor;
    property ParentShowHint;
    property ReadOnly;
    property Selected;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Tag;
    property Visible;
    property AfterEnter;
    property AfterExit;
    property AfterEdit;
    property BeforeEdit;
    property OnClick;
    property OnDelete;
    property OnDblClick;
    property OnCellPaint;
    property OnCollapse;
    property OnEnter;
    property OnExit;
    property OnExpand;
    property OnGetEditMask;
    property OnGetEditText;
    property OnGetEditLimit;
    property OnItemChange;
    property OnItemEditorChange;
    property OnItemSelect;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnMouseWheel;
  end;


implementation

uses
  Math, Consts, SysUtils, OvcData, OvcConst, OvcVer, Dialogs, OvcUtils, OVCStr,
  OvcFormatSettings;

const
  TextMargin = 2;

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxCustomExtents] of Integer;

  TSelection = record
    StartPos, EndPos: Integer;
  end;

{===== Local Methods =================================================}

function GridRect(Coord1, Coord2: TGridCoord): TGridRect;
begin
  with Result do
  begin
    Left := Coord2.X;
    if Coord1.X < Coord2.X then Left := Coord1.X;
    Right := Coord1.X;
    if Coord1.X < Coord2.X then Right := Coord2.X;
    Top := Coord2.Y;
    if Coord1.Y < Coord2.Y then Top := Coord1.Y;
    Bottom := Coord1.Y;
    if Coord1.Y < Coord2.Y then Bottom := Coord2.Y;
  end;
end;

function PointInGridRect(Col, Row: Integer; const Rect: TGridRect): Boolean;
begin
  Result := (Col >= Rect.Left) and (Col <= Rect.Right) and (Row >= Rect.Top)
    and (Row <= Rect.Bottom);
end;

type
  TXorRects = array[0..3] of TRect;

procedure XorRects(const R1, R2: TRect; var XorRects: TXorRects);
var
  Intersect, Union: TRect;

  function PtInRect(X, Y: Integer; const Rect: TRect): Boolean;
  begin
    with Rect do Result := (X >= Left) and (X <= Right) and (Y >= Top) and
      (Y <= Bottom);
  end;

  function Includes(const P1: TPoint; var P2: TPoint): Boolean;
  begin
    with P1 do
    begin
      Result := PtInRect(X, Y, R1) or PtInRect(X, Y, R2);
      if Result then P2 := P1;
    end;
  end;

  function Build(var R: TRect; const P1, P2, P3: TPoint): Boolean;
  begin
    Build := True;
    with R do
      if Includes(P1, TopLeft) then
      begin
        if not Includes(P3, BottomRight) then BottomRight := P2;
      end
      else if Includes(P2, TopLeft) then BottomRight := P3
      else Build := False;
  end;

begin
  FillChar(XorRects, SizeOf(XorRects), 0);
  if not Bool(IntersectRect(Intersect, R1, R2)) then
  begin
    { Don't intersect so its simple }
    XorRects[0] := R1;
    XorRects[1] := R2;
  end
  else
  begin
    UnionRect(Union, R1, R2);
    if Build(XorRects[0],
      Point(Union.Left, Union.Top),
      Point(Union.Left, Intersect.Top),
      Point(Union.Left, Intersect.Bottom)) then
      XorRects[0].Right := Intersect.Left;
    if Build(XorRects[1],
      Point(Intersect.Left, Union.Top),
      Point(Intersect.Right, Union.Top),
      Point(Union.Right, Union.Top)) then
      XorRects[1].Bottom := Intersect.Top;
    if Build(XorRects[2],
      Point(Union.Right, Intersect.Top),
      Point(Union.Right, Intersect.Bottom),
      Point(Union.Right, Union.Bottom)) then
      XorRects[2].Left := Intersect.Right;
    if Build(XorRects[3],
      Point(Union.Left, Union.Bottom),
      Point(Intersect.Left, Union.Bottom),
      Point(Intersect.Right, Union.Bottom)) then
      XorRects[3].Top := Intersect.Bottom;
  end;
end;
{=====}

procedure ModifyExtents(var Extents: Pointer; Index, Amount: Integer;
  Default: Integer);
var
  LongSize, OldSize: Integer;
  NewSize: Integer;
  I: Integer;
begin
  if Amount <> 0 then
  begin
    if not Assigned(Extents) then OldSize := 0
    else OldSize := PIntArray(Extents)^[0];
    if (Index < 0) or (OldSize < Index) then
      raise EInvalidGridOperation.Create(SIndexOutOfRange);
    LongSize := OldSize + Amount;
    if LongSize < 0 then
      raise EInvalidGridOperation.Create(STooManyDeleted)
    else if LongSize >= MaxInt - 1 then
      raise EInvalidGridOperation.Create(SGridTooLarge);
    NewSize := Cardinal(LongSize);
    if NewSize > 0 then Inc(NewSize);
    ReallocMem(Extents, NewSize * SizeOf(Integer));
    if Assigned(Extents) then
    begin
      I := Index + 1;
      while I < NewSize do
      begin
        PIntArray(Extents)^[I] := Default;
        Inc(I);
      end;
      PIntArray(Extents)^[0] := NewSize-1;
    end;
  end;
end;
{=====}

procedure UpdateExtents(var Extents: Pointer; NewSize: Integer;
  Default: Integer);
var
  OldSize: Integer;
begin
  OldSize := 0;
  if Assigned(Extents) then OldSize := PIntArray(Extents)^[0];
  ModifyExtents(Extents, OldSize, NewSize - OldSize, Default);
end;
{=====}

function CompareExtents(E1, E2: Pointer): Boolean;
var
  I: Integer;
begin
  Result := False;
  if E1 <> nil then
  begin
    if E2 <> nil then
    begin
      for I := 0 to PIntArray(E1)^[0] do
        if PIntArray(E1)^[I] <> PIntArray(E2)^[I] then Exit;
      Result := True;
    end
  end
  else Result := E2 = nil;
end;
{=====}

function LongMulDiv(Mult1, Mult2, Div1: Integer): Integer; stdcall;
  external 'kernel32.dll' name 'MulDiv';


{===== TO32GridEdit ==================================================}

constructor TO32GridEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  OnChange := Changed;
  Updating := false;
  DoubleBuffered := False;
end;
{=====}

procedure TO32GridEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;
{=====}

procedure TO32GridEdit.Changed(Sender: TObject);
begin
  if not Updating then
    Grid.EditorChanged;
end;
{=====}

procedure TO32GridEdit.SetGrid(Value: TO32CustomInspectorGrid);
begin
  FGrid := Value;
end;
{=====}

procedure TO32GridEdit.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;
{=====}

procedure TO32GridEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if goTabs in Grid.Options then
    Message.Result := Message.Result or DLGC_WANTTAB;
end;
{=====}

procedure TO32GridEdit.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;
{=====}

procedure TO32GridEdit.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridEdit.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridEdit.DblClick;
begin
  Grid.DblClick;
end;
{=====}

function TO32GridEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;
{=====}

function TO32GridEdit.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;
{=====}

procedure TO32GridEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  begin
    Grid.KeyDown(Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, NativeInt(@Result.StartPos), NativeInt(@Result.EndPos));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := ((StartPos = 0) or (EndPos = StartPos)) and
        (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (StartPos = 0) and ((EndPos = 0) or (EndPos = GetTextLen));
  end;

begin
  { translate the enter key to mean arrow down }
  if Key = VK_RETURN then Key := VK_DOWN;

  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
  end;
  if (Key = VK_DELETE) and not Grid.CanEditModify then Key := 0;

  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;
{=====}

procedure TO32GridEdit.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if CharInSet(Key, [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, NativeInt(@Selection.StartPos), NativeInt(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          Deselect else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;
{=====}

procedure TO32GridEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;
{=====}

procedure TO32GridEdit.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or GetParentForm(Self).SetFocusedControl(Grid) then Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;
{=====}

procedure TO32GridEdit.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, NativeInt($FFFFFFFF));
end;
{=====}

procedure TO32GridEdit.Invalidate;
var
  Cur: TRect;
begin
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, Grid.Handle, Cur, 2);
  ValidateRect(Grid.Handle, @Cur);
  InvalidateRect(Grid.Handle, @Cur, False);
end;
{=====}

procedure TO32GridEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;
{=====}

procedure TO32GridEdit.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;
{=====}

function TO32GridEdit.PosEqual(const Rect: TRect): Boolean;
var
  Cur: TRect;
begin
  GetWindowRect(Handle, Cur);
  MapWindowPoints(HWND_DESKTOP, Grid.Handle, Cur, 2);
  Result := EqualRect(Rect, Cur);
end;
{=====}

procedure TO32GridEdit.InternalMove(const Loc: TRect; Redraw: Boolean);
begin
  if IsRectEmpty(Loc) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Loc do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, Bottom - Top,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    BoundsChanged;
    if Redraw then Invalidate;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;
{=====}

procedure TO32GridEdit.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, NativeInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;
{=====}

procedure TO32GridEdit.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;
{=====}

function TO32GridEdit.Visible: Boolean;
begin
 Result := IsWindowVisible(Handle);
end;
{=====}

procedure TO32GridEdit.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;
{=====}

procedure TO32GridEdit.UpdateContents;
begin
  Updating := true;
  Text := '';
  EditMask := Grid.GetEditMask(Grid.Col, Grid.ActiveRow);
  Text := Grid.GetEditText(Grid.Col, Grid.ActiveRow);
  MaxLength := Grid.GetEditLimit;
  Updating := false;
end;


{===== TO32GridCombo =================================================}

constructor TO32GridCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := csDropDownList;
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  OnChange := Changed;
  Updating := false;
  DoubleBuffered := False;

  ControlStyle := ControlStyle - [csFixedWidth, csFixedHeight, csFramed];
  Height := 15;
end;
{=====}

procedure TO32GridCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;
{=====}

procedure TO32GridCombo.Changed(Sender: TObject);
begin
  if not Updating then
    Grid.EditorChanged;
end;
{=====}

procedure TO32GridCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  DropDownList(not DroppedDown);
end;
{=====}

procedure TO32GridCombo.DropDownList(Value: Boolean);
var
  R: TRect;
begin
  SendMessage(Handle, CB_SHOWDROPDOWN, NativeInt(Value), 0);
  R := ClientRect;
  InvalidateRect(Handle, @R, True);
end;
{=====}


procedure TO32GridCombo.SetGrid(Value: TO32CustomInspectorGrid);
begin
  FGrid := Value;
end;
{=====}

procedure TO32GridCombo.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;
{=====}

procedure TO32GridCombo.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;
{=====}

procedure TO32GridCombo.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridCombo.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridCombo.DblClick;
begin
  Grid.DblClick;
end;
{=====}

function TO32GridCombo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;
{=====}

function TO32GridCombo.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;
{=====}

procedure TO32GridCombo.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    GridKeyDown := Grid.OnKeyDown;
    if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, NativeInt(@Result.StartPos), NativeInt(@Result.EndPos));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := ((StartPos = 0) or (EndPos = StartPos)) and
        (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (StartPos = 0) and ((EndPos = 0) or (EndPos = GetTextLen));
  end;

begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
  end;
  if (Key = VK_DELETE) and not Grid.CanEditModify then Key := 0;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;
{=====}

procedure TO32GridCombo.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if CharInSet(Key, [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, NativeInt(@Selection.StartPos), NativeInt(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          Deselect else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;
{=====}

procedure TO32GridCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;
{=====}

procedure TO32GridCombo.WndProc(var Message: TMessage);
begin
 case Message.Msg of
    WM_SETFOCUS:
    begin
      if (GetParentForm(Self) = nil) or GetParentForm(Self).SetFocusedControl(Grid)
      then Dispatch(Message);
      Exit;
    end;
    WM_LBUTTONDOWN:
    begin
      if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then begin
        Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
    end;
  end;
  inherited WndProc(Message);
end;
{=====}

procedure TO32GridCombo.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, NativeInt($FFFFFFFF));
end;
{=====}

procedure TO32GridCombo.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;
{=====}

procedure TO32GridCombo.InternalMove(const Loc: TRect; Redraw: Boolean);
var
  Rct: TRect;
begin
  Rct := Loc;

  Rct.Left := Rct.Left - 1;
  Rct.Top := Rct.Top -2;
  Rct.Right := Rct.Right + 2;
  if IsRectEmpty(Rct) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Rct do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, (Bottom - Top) *5,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    Height := Rct.Bottom - Rct.Top;
    BoundsChanged;
    if Redraw then Invalidate;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;
{=====}

procedure TO32GridCombo.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, NativeInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;
{=====}

procedure TO32GridCombo.UpdateLoc(const Loc: TRect);
begin
 InternalMove(Loc, False);
end;
{=====}

procedure TO32GridCombo.Move(const Loc: TRect);
begin
 InternalMove(Loc, True);
end;
{=====}

procedure TO32GridCombo.UpdateContents;
begin
  Updating := true;
  Items.Assign(Grid.Items[Grid.ActiveItem].ItemsList);
  Self.ItemIndex :=
    self.Items.IndexOf(Grid.GetEditText(Grid.Col, Grid.ActiveRow));
  MaxLength := Grid.GetEditLimit;
  Updating := false;
end;

{===== TO32GridColorCombo =================================================}

constructor TO32GridColorCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  OnChange := Changed;
  Updating := false;
  DoubleBuffered := False;
  ControlStyle := ControlStyle - [csFixedHeight];
  Height := 15;
end;
{=====}

procedure TO32GridColorCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;
{=====}

procedure TO32GridColorCombo.Changed(Sender: TObject);
begin
  if not Updating then
    Grid.EditorChanged;
end;
{=====}

procedure TO32GridColorCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  DropDownList(not DroppedDown);
end;
{=====}

procedure TO32GridColorCombo.DropDownList(Value: Boolean);
var
  R: TRect;
begin
  SendMessage(Handle, CB_SHOWDROPDOWN, NativeInt(Value), 0);
  R := ClientRect;
  InvalidateRect(Handle, @R, True);
end;
{=====}

procedure TO32GridColorCombo.SetGrid(Value: TO32CustomInspectorGrid);
begin
  FGrid := Value;
end;
{=====}

procedure TO32GridColorCombo.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;
{=====}

procedure TO32GridColorCombo.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;
{=====}

procedure TO32GridColorCombo.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridColorCombo.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridColorCombo.DblClick;
begin
  Grid.DblClick;
end;
{=====}

function TO32GridColorCombo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;
{=====}

function TO32GridColorCombo.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;
{=====}

procedure TO32GridColorCombo.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    GridKeyDown := Grid.OnKeyDown;
    if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, NativeInt(@Result.StartPos), NativeInt(@Result.EndPos));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := ((StartPos = 0) or (EndPos = StartPos)) and
        (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (StartPos = 0) and ((EndPos = 0) or (EndPos = GetTextLen));
  end;

begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
  end;
  if (Key = VK_DELETE) and not Grid.CanEditModify then Key := 0;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;
{=====}

procedure TO32GridColorCombo.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if CharInSet(Key, [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, NativeInt(@Selection.StartPos), NativeInt(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          Deselect else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;
{=====}

procedure TO32GridColorCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;
{=====}

procedure TO32GridColorCombo.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil)
        or GetParentForm(Self).SetFocusedControl(Grid) then
          Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
    inherited WndProc(Message)
end;
{=====}

procedure TO32GridColorCombo.WMMouseWheel(var Msg : TMessage);
var
  Delta: integer;
begin
  Delta := TWMMouseWheel(Msg).WheelDelta;
   if Delta < 0 then begin
     if (FGrid.ActiveRow < FGrid.RowCount - 1) then
       FGrid.FocusCell(1, FGrid.ActiveRow + 1, true);
   end
   else if (FGrid.ActiveRow > 0) then
     FGrid.FocusCell(1, FGrid.ActiveRow - 1, true);
end;
{=====}

procedure TO32GridColorCombo.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, NativeInt($FFFFFFFF));
end;
{=====}

procedure TO32GridColorCombo.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;
{=====}

procedure TO32GridColorCombo.InternalMove(const Loc: TRect; Redraw: Boolean);
var
  Rct: TRect;
begin
  Rct := Loc;

  Rct.Left := Rct.Left - 1;
  Rct.Top := Rct.Top -2;
  Rct.Right := Rct.Right + 2;
  if IsRectEmpty(Rct) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Rct do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, (Bottom - Top) *5,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    Height := Rct.Bottom - Rct.Top;
    BoundsChanged;
    if Redraw then Invalidate;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;
{=====}

procedure TO32GridColorCombo.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, NativeInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;
{=====}

procedure TO32GridColorCombo.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;
{=====}

procedure TO32GridColorCombo.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;
{=====}

procedure TO32GridColorCombo.UpdateContents;
var
  Item: TO32InspectorItem;
begin
  Updating := true;
  Item := TO32InspectorItem(FGrid.FItems.VisibleItems[FGrid.ActiveRow]);
  SelectedColor := Item.AsColor;
  Updating := false;
end;

{===== TO32GridFontCombo =================================================}

constructor TO32GridFontCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentCtl3D := False;

  {disable MRU list}
  FMRUList.MaxItems := 0;
  Style := ocsDropDownList;

  PreviewFont := true;

  Ctl3D := False;
  TabStop := False;
  OnChange := Changed;
  Updating := false;
  DoubleBuffered := False;
  ControlStyle := ControlStyle - [csFixedHeight];
end;
{=====}

procedure TO32GridFontCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;
{=====}

procedure TO32GridFontCombo.Changed(Sender: TObject);
begin
  if not Updating then
    Grid.EditorChanged;
end;
{=====}

procedure TO32GridFontCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  DropDownList(not DroppedDown);
end;
{=====}

procedure TO32GridFontCombo.DropDownList(Value: Boolean);
var
  R: TRect;
begin
  SendMessage(Handle, CB_SHOWDROPDOWN, NativeInt(Value), 0);
  R := ClientRect;
  InvalidateRect(Handle, @R, True);
end;
{=====}

procedure TO32GridFontCombo.SetGrid(Value: TO32CustomInspectorGrid);
begin
  FGrid := Value;
end;
{=====}

procedure TO32GridFontCombo.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;
{=====}

procedure TO32GridFontCombo.WMPaste(var Message);
begin
  if not EditCanModify then Exit;
  inherited
end;
{=====}

procedure TO32GridFontCombo.WMClear(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridFontCombo.WMCut(var Message);
begin
  if not EditCanModify then Exit;
  inherited;
end;
{=====}

procedure TO32GridFontCombo.DblClick;
begin
  Grid.DblClick;
end;
{=====}

function TO32GridFontCombo.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;
{=====}

function TO32GridFontCombo.EditCanModify: Boolean;
begin
  Result := Grid.CanEditModify;
end;
{=====}

procedure TO32GridFontCombo.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    Grid.KeyDown(Key, Shift);
    Key := 0;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    GridKeyDown := Grid.OnKeyDown;
    if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
  end;

  function ForwardMovement: Boolean;
  begin
    Result := goAlwaysShowEditor in Grid.Options;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

  function Selection: TSelection;
  begin
    SendMessage(Handle, EM_GETSEL, NativeInt(@Result.StartPos), NativeInt(@Result.EndPos));
  end;

  function RightSide: Boolean;
  begin
    with Selection do
      Result := ((StartPos = 0) or (EndPos = StartPos)) and
        (EndPos = GetTextLen);
   end;

  function LeftSide: Boolean;
  begin
    with Selection do
      Result := (StartPos = 0) and ((EndPos = 0) or (EndPos = GetTextLen));
  end;

begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent
      else if (Shift = [ssShift]) and not Grid.CanEditModify then Key := 0;
    VK_LEFT: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_RIGHT: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_HOME: if ForwardMovement and (Ctrl or LeftSide) then SendToParent;
    VK_END: if ForwardMovement and (Ctrl or RightSide) then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          Deselect;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
  end;
  if (Key = VK_DELETE) and not Grid.CanEditModify then Key := 0;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;
{=====}

procedure TO32GridFontCombo.KeyPress(var Key: Char);
var
  Selection: TSelection;
begin
  Grid.KeyPress(Key);
  if CharInSet(Key, [#32..#255]) and not Grid.CanEditAcceptKey(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  case Key of
    #9, #27: Key := #0;
    #13:
      begin
        SendMessage(Handle, EM_GETSEL, NativeInt(@Selection.StartPos), NativeInt(@Selection.EndPos));
        if (Selection.StartPos = 0) and (Selection.EndPos = GetTextLen) then
          Deselect else
          SelectAll;
        Key := #0;
      end;
    ^H, ^V, ^X, #32..#255:
      if not Grid.CanEditModify then Key := #0;
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;
{=====}

procedure TO32GridFontCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  Grid.KeyUp(Key, Shift);
end;
{=====}

procedure TO32GridFontCombo.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil)
        or GetParentForm(Self).SetFocusedControl(Grid) then
          Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
    inherited WndProc(Message)
end;
{=====}

procedure TO32GridFontCombo.WMMouseWheel(var Msg : TMessage);
var
  Delta: integer;
begin
  Delta := TWMMouseWheel(Msg).WheelDelta;
   if Delta < 0 then begin
     if (FGrid.ActiveRow < FGrid.RowCount - 1) then
       FGrid.FocusCell(1, FGrid.ActiveRow + 1, true);
   end
   else if (FGrid.ActiveRow > 0) then
     FGrid.FocusCell(1, FGrid.ActiveRow - 1, true);
end;
{=====}

procedure TO32GridFontCombo.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, NativeInt($FFFFFFFF));
end;
{=====}

procedure TO32GridFontCombo.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(Grid.Handle);
  end;
end;
{=====}

procedure TO32GridFontCombo.InternalMove(const Loc: TRect; Redraw: Boolean);
var
  Rct: TRect;
begin
  Rct := Loc;

  Rct.Left := Rct.Left - 1;
  Rct.Top := Rct.Top -2;
  Rct.Right := Rct.Right + 2;
  if IsRectEmpty(Rct) then Hide
  else
  begin
    CreateHandle;
    Redraw := Redraw or not IsWindowVisible(Handle);
    Invalidate;
    with Rct do
      SetWindowPos(Handle, HWND_TOP, Left, Top, Right - Left, (Bottom - Top) *5,
        SWP_SHOWWINDOW or SWP_NOREDRAW);
    Height := Rct.Bottom - Rct.Top;
    BoundsChanged;
    if Redraw then begin
      Populate;
      UpdateContents;
    end;
    if Grid.Focused then
      Windows.SetFocus(Handle);
  end;
end;
{=====}

procedure TO32GridFontCombo.BoundsChanged;
var
  R: TRect;
begin
  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, NativeInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;
{=====}

procedure TO32GridFontCombo.UpdateLoc(const Loc: TRect);
begin
  InternalMove(Loc, False);
end;
{=====}

procedure TO32GridFontCombo.Move(const Loc: TRect);
begin
  InternalMove(Loc, True);
end;
{=====}

procedure TO32GridFontCombo.UpdateContents;
var
  Item: TO32InspectorItem;
begin
  Updating := true;
  Item := TO32InspectorItem(FGrid.FItems.VisibleItems[FGrid.ActiveRow]);
  FontName := Item.AsString;
  Updating := false;
end;


{===== TO32InspectorItems ============================================}

constructor TO32InspectorItems.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner, ItemClass);
  FInspectorGrid := TO32CustomInspectorGrid(AOwner);
  FVisibleItems := TList.Create;
end;
{=====}

destructor TO32InspectorItems.Destroy;
begin
  FVisibleItems.Free;
  inherited;
end;
{=====}

function TO32InspectorItems.AddItem(ItemType: TO32IGridItemType;
  Parent: TO32InspectorItem): TO32InspectorItem;
var
  NewItem: TO32InspectorItem;
  Number: Integer;
begin
  NewItem := nil;

  { create a parented item }
  if Parent <> nil then begin
    if (Parent.ItemType in [itParent, itSet]) then begin
      { Create the new item and insert it below the parent }
      NewItem := TO32InspectorItem(
        Insert(Parent.Index + Parent.ChildCount + 1));
      NewItem.FIGrid := FInspectorGrid;
      NewItem.FParent := Parent;
      NewItem.FParentIndex := Parent.Index;
      NewItem.FLevel := Parent.FLevel + 1;
      NewItem.Visible := Parent.Expanded;
      NewItem.ItemType := ItemType;
    end;
  end;

  { Unable to create a parented item, so create a root item... }
  if NewItem = nil then begin
    { Create the new item }
    NewItem := TO32InspectorItem(Add);
    NewItem.FIGrid := FInspectorGrid;
    NewItem.ItemType := ItemType;
    NewItem.FLevel := 0;
  end;

  { Set default caption }
  Number := GetTypeNumber(NewItem.FType);
  case NewItem.FType of
      itParent    : NewItem.Caption := 'Parent' + IntToStr(Number);
      itSet       : NewItem.Caption := 'Set' + IntToStr(Number);
      itList      : NewItem.Caption := 'List' + IntToStr(Number);
      itString    : NewItem.Caption := 'String' + IntToStr(Number);
      itInteger   : NewItem.Caption := 'Integer' + IntToStr(Number);
      itFloat     : NewItem.Caption := 'Float' + IntToStr(Number);
      itCurrency  : NewItem.Caption := 'Currency' + IntToStr(Number);
      itDate      : NewItem.Caption := 'Date' + IntToStr(Number);
      itColor     : NewItem.Caption := 'Color' + IntToStr(Number);
      itLogical   : NewItem.Caption := 'Boolean' + IntToStr(Number);
      itFont      : NewItem.Caption := 'Font' + IntToStr(Number);
  end;

  result := NewItem;

  { notify grid of change }
  FInspectorGrid.ItemVisibilityChanged;
end;
{=====}

function TO32InspectorItems.GetTypeNumber(Value: TO32IGridItemType): Integer;
var
  I : Integer;
begin
  result := 0;
  for I := 0 to Count - 1 do
    if TO32InspectorItem(Items[I]).ItemType = Value then
      Inc(Result);
end;

function TO32InspectorItems.InsertItem(ItemType: TO32IGridItemType;
                                       Parent: TO32InspectorItem;
                                       Index: Integer): TO32InspectorItem;
var
  NewItem: TO32InspectorItem;
  I: Integer;
  Ndx: Integer;
  ItemAtIndex: TO32InspectorItem;
  ok: Boolean;
  ParentItem: TO32InspectorItem;
begin
  ok := false;
  if Index > FInspectorGrid.FItems.Count - 1 then
    Ndx := FInspectorGrid.FItems.Count - 1
  else
    Ndx := Index;

  I := Ndx;

  ItemAtIndex := TO32InspectorItem(FInspectorGrid.FItems.Items[Ndx]);

  if Parent <> nil then begin
    if (Parent.ItemType in [itParent, itSet]) then
      ParentItem := Parent
    else
      ParentItem := nil;
  end
  else ParentItem := nil;

  {don't allow insertions in the middle of children unless the new item's }
  { parent is the same as the children's }
  if ItemAtIndex.Parent <> Parent
  then begin
    ok := false;
    I := Ndx;
    ItemAtIndex := TO32InspectorItem(FInspectorGrid.FItems.Items[I]);
    while (I < FInspectorGrid.FItems.Count - 1) and (not ok) do begin
      ItemAtIndex := TO32InspectorItem(FInspectorGrid.FItems.Items[I]);
      ok := ItemAtIndex.Parent = Parent;
      Inc(I);
    end;
  end;

  {If we were unable to inc our way to a valid insertion postion then start }
  { from the very beginning looking for the parent }
  if (ItemAtIndex.Parent <> Parent) and (Parent <> nil) then begin
    I := 0;
    ok := false;
    while (I < FInspectorGrid.FItems.Count - 1) and (not ok) do begin
      if (TO32InspectorItem(FInspectorGrid.FItems.Items[I]).Parent = Parent)
      then ok := true;
      Inc(I);
    end;
  end;

  ok := ok and (ParentItem <> nil);

  { I is now our insertion point}

  { if not ok then we were unable to find a parent so create a new root item }
  { at the insertion point }
  if not ok then begin
    NewItem := TO32InspectorItem(Insert(I));
    NewItem.FIGrid := FInspectorGrid;
    NewItem.ItemType := ItemType;
    NewItem.FLevel := 0;
  end

  { otherwise create a new parented item at the current insertion point }
  else begin
    NewItem := TO32InspectorItem(Insert(I));
    NewItem.FIGrid := FInspectorGrid;
    NewItem.FParent := ParentItem;
    NewItem.FParentIndex := ParentItem.Index;
    NewItem.FLevel := ParentItem.FLevel + 1;
    NewItem.Visible := ParentItem.Expanded;
    NewItem.ItemType := ItemType;
  end;

  result := NewItem;

  { notify grid of change }
  FInspectorGrid.ItemVisibilityChanged;
end;
{=====}

procedure TO32InspectorItems.LoadVisibleItems;
var
  I: Integer;
begin
  FVisibleItems.Clear;
  I := 0;
  while I < Count do begin
    if TO32InspectorItem(Items[I]).Visible then
      FVisibleItems.Add(Items[I])
    else if TO32InspectorItem(Items[I]).ItemType in [itSet, itParent] then
      Inc(I, TO32InspectorItem(Items[I]).ChildCount);
    Inc(I);
  end;
  if FInspectorGrid.Sorted then Sort;
end;
{=====}

procedure TO32InspectorItems.Sort;
var
  SortedList: TList;
  I: Integer;
begin
  SortedList := TList.Create;
  {Load list of mainlevel items}
  for I := 0 to FVisibleItems.Count - 1 do begin
    if TO32InspectorItem(FVisibleItems.List[I]).Level = 0 then
      SortedList.Add(FVisibleItems.List[I]);
  end;

  SortList(SortedList);

  LoadChildren(SortedList);

  FVisibleItems.Free;
  FVisibleItems := SortedList;
end;
{=====}

procedure TO32InspectorItems.LoadChildren(TargetList: TList);
var
  I, J, K: Integer;
  ChildList: TList;
  Level: Integer;
  Done: Boolean;
begin
  ChildList := TList.Create;
  try
    Done := false;

    { main-level items are at level 0.  Items at levels greater than 0 are }
    { children of another item }
    Level := 1;

    while not done do begin
      ChildList.Clear;
      { Spin through all of the visible items looking for any children at this }
      { level }
      for I := 0 to FVisibleItems.Count - 1 do begin
        if TO32InspectorItem(FVisibleItems.List[I]).Level = Level then
          ChildList.Add(FVisibleItems.List[I]);
      end;

      { If we found any children then sort them, insert them into the sorted }
      { list, and increment the level }
      if ChildList.Count > 0 then begin
        { Sort all items at this level }
        if ChildList.Count > 1 then SortList(ChildList);

        { Insert each child into the sorted list, under its parent }
        { We go backwards to maintain alphabetic order in the children, as they }
        { are inserted at the top of their list, directly under their parent. }
        for J := ChildList.Count - 1 downto 0 do begin
          for K := 0 to TargetList.Count - 1 do
            if TargetList.List[K] = TO32InspectorItem(ChildList.List[J]).Parent
            then begin
              TargetList.Insert(K + 1, ChildList.List[J]);
              break;
            end;
        end;
        Inc(Level);
      end

      { if we didn't find any children at this level then we're done. }
      else
        Done := true;
    end;
  {Fix for bug 873415 - Peter Grimshaw
   The child list should be deallocated after the sorting is done}
  finally
    ChildList.Free;
  end;
end;
{=====}

procedure TO32InspectorItems.SortList(AList: TList);
var
  i, j       : integer;
  IndexOfMin : integer;
  Temp       : pointer;
begin
  for i := 0 to AList.Count - 1 do begin
    IndexOfMin := i;
    for j := i to AList.Count - 1 do
      if (Compare(AList.List[j], AList.List[IndexOfMin]) < 0)
      then IndexOfMin := j;
    Temp := AList.List[i];
    AList.List[i] := AList.List[IndexOfMin];
    AList.List[IndexOfMin] := Temp;
  end;
end;
{=====}

function TO32InspectorItems.Compare(Item1, Item2: TO32InspectorItem): Integer;
begin
  {Compares the value of the Item captions}
  if Item1.FCaption < Item2.Caption then
    result := -1
  else if Item1.FCaption = Item2.Caption then
    result := 0
  else
    result := 1;
end;


{===== TO32InspectorItem =============================================}

constructor TO32InspectorItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FItemsList := TStringList.Create;
  FFont := TFont.Create;
  FIGrid := (Collection as TO32InspectorItems).FInspectorGrid;
  FLevel := 0;
  FImageIndex := -1;
  FVisible := true;
  FExpanded := false;
  FParent := nil;
  FParentIndex := -1;
  FType := itString;
  Name := 'Item' + IntToStr(Index);

  { notify grid of design time change }
  if (csDesigning in FIGrid.ComponentState) then
    FIGrid.ItemVisibilityChanged;
end;
{=====}

destructor TO32InspectorItem.Destroy;
var
  I: Integer;
  OldGrid: TO32CustomInspectorGrid;
begin
  OldGrid := FIGrid;
  FVisible := false;
  if FType in [itSet, itParent] then begin
    Collapse;
    {iterate through the child items and delete them}
    if FIGrid.ItemCollection.Count - 1 > Index then
      for I := FIGrid.ItemCollection.Count - 1 downto Index + 1 do begin
        if (FIGrid.Items[I].Parent = self) then
           FIGrid.ItemCollection.Delete(I);
      end;
  end;
  FreeObject; {if any}
  ItemType := itString;
  FItemsList.Free;
  FFont.Free;
  if not (csDestroying in OldGrid.ComponentState)
    then OldGrid.ItemVisibilityChanged;
  inherited Destroy;
end;
{=====}

procedure TO32InspectorItem.Collapse;
var
  I : Integer;
begin
  if FType in [itSet, itParent] then begin
   {Iterate through children setting Visible to False}
    for I := Index + 1 to FIGrid.ItemCollection.Count - 1 do begin
      if (FIGrid.Items[I].Parent = self) then begin
        FIGrid.Items[I].Collapse;
        FIGrid.Items[I].Visible := false;
      end;
    end;
    Expanded := false;
    FIGrid.DoOnCollapse(Index);
  end;
end;
{=====}

procedure TO32InspectorItem.Expand;
var
  I : Integer;
  VisibleKids: Integer;
begin
  if FType in [itSet, itParent] then begin
    VisibleKids := 0;
    {Iterate through children setting visible to true}
    for I := Index + 1 to FIGrid.ItemCollection.Count - 1 do begin
      if (FIGrid.Items[I].Parent = self) then begin
        FIGrid.Items[I].Expand;
        FIGrid.Items[I].Visible := true;
        Inc(VisibleKids);
      end;
    end;
    Expanded := (VisibleKids > 0);
    if Expanded then FIGrid.DoOnExpand(Index);
  end;
end;
{=====}

procedure TO32InspectorItem.DeleteChildren;
var
  I: Integer;
begin
  if FType in [itSet, itParent] then begin
    Collapse;
    {iterate through the child items and delete them}
    if FIGrid.ItemCollection.Count - 1 > Index then
      for I := FIGrid.ItemCollection.Count - 1 downto Index + 1 do begin
        if (FIGrid.Items[I].Parent = self) then
           FIGrid.ItemCollection.Delete(I);
      end;
  end;
end;
{=====}

procedure TO32InspectorItem.FreeObject;
begin
  if (ObjectRef <> nil) then
  begin
    ObjectRef.Free;
    ObjectRef := nil;
  end;
end;
{=====}

procedure TO32InspectorItem.AddObject(Ref: TObject);
begin
  if (Ref <> nil) then begin
    if (ObjectRef <> nil) then
      FreeObject;
    ObjectRef := Ref;
  end;
end;
{=====}

function TO32InspectorItem.GetBoolean: boolean;
begin
  if FType = itLogical then
    result := FLogical
  else
    result := false;
end;
{=====}

function TO32InspectorItem.GetColor: TColor;
begin
  if FType = itColor then
    result := FColor
  else
    result := 0;
end;
{=====}

function TO32InspectorItem.GetCurrency: Currency;
begin
  if FType = itCurrency then
    result := FCurrency
  else
    result := 0;
end;
{=====}

function TO32InspectorItem.GetDate: TDateTime;
begin
  if FType = itDate then
    result := FDate
  else
    result := 0;
end;
{=====}

function TO32InspectorItem.GetFloat: double;
begin
  if FType in [itFloat, itCurrency] then
    result := FDouble
  else
    result := 0.0;
end;
{=====}

function TO32InspectorItem.GetFont: TFont;
begin
  if FType = itFont then
    result := FFont
  else
    result := nil;
end;
{=====}

function TO32InspectorItem.GetInteger: Integer;
begin
  if FType = itInteger then
    result := FInt
  else
    result := 0;
end;
{=====}

{ - Added}
function  TO32InspectorItem.GetItemsList: TStringList;
begin
  result := FItemsList;
end;
{=====}

function TO32InspectorItem.GetString: string;
begin
  case FType of
    itString   : result := FString;
    itParent   : result := FString;
    itDate     : result := FormatDateTime(FormatSettings.ShortDateFormat , FDate);
    itList     : result := FString;
    itInteger  : result := IntToStr(FInt);
    itFloat    : result := FloatToStr(FDouble);
    itCurrency : result := FormatCurr(FormatSettings.CurrencyString + '#' + FormatSettings.ThousandSeparator
      + '##0' + FormatSettings.DecimalSeparator + '00' , FCurrency);
    itLogical: begin
      if FLogical then
        result := 'True'
      else
        result := 'False';
    end;
    itSet: begin
      result := GetElementsAsString;
    end;
    itColor    : result := ColorToStr(FColor);
    itFont     : result := FFont.Name;
  end;
end;
{=====}

function TO32InspectorItem.GetValue: Variant;
begin
  case FType of
    itParent   : result := FCaption;
    itList     : result := FString;
    itString   : result := FString;
    itInteger  : result := FInt;
    itFloat    : result := FDouble;
    itCurrency : result := FCurrency;
    itDate     : result := FDate;
    itColor    : result := FColor;
    itLogical  : result := FLogical;
    itFont     : result := FFont.Name;{ Variants cannot be used on classes so  }
                                      { the data type is itFont, we just       }
                                      { return the font name.                  }
    itSet      : result := GetElementsAsString;
  end;
end;
{=====}

procedure TO32InspectorItem.LoadParent(Reader: TReader);
begin
  FParentIndex := Reader.ReadInteger;
end;
{=====}

procedure TO32InspectorItem.StoreParent(Writer: TWriter);
begin
  Writer.WriteInteger(FParentIndex);
end;
{=====}

procedure TO32InspectorItem.LoadValue(Reader: TReader);
begin
  AsString := Reader.ReadString;
end;
{=====}

procedure TO32InspectorItem.StoreValue(Writer: TWriter);
begin
  Writer.WriteString(AsString);
end;
{=====}

procedure TO32InspectorItem.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('ParentItem', LoadParent, StoreParent, true);
end;
{=====}

procedure TO32InspectorItem.SetBoolean(Value: boolean);
begin
  if FType = itLogical then begin
    FLogical := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetColor(Value: TColor);
begin
  if FType = itColor then begin
    FColor := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetCurrency(Value: Currency);
begin
  if FType = itCurrency then begin
    FCurrency := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetDate(Value: TDateTime);
begin
  if FType = itDate then begin
    FDate := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetFloat(Value: double);
begin
  if FType = itFloat then begin
    FDouble := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetExpanded(Value: Boolean);
begin
  if FExpanded <> Value then begin
    FExpanded := Value;
    FIGrid.ItemVisibilityChanged;
  end;
end;
{=====}

procedure TO32InspectorItem.SetVisible(Value: Boolean);
begin
  if Value <> FVisible then begin
    FVisible := Value;
    FIGrid.ItemVisibilityChanged;
  end;
end;
{=====}

function TO32InspectorItem.CountChildren: Integer;
var
  I : Integer;
begin
  result := 0;
  for I := Index + 1 to FIGrid.ItemCollection.Count - 1 do begin
    if (FIGrid.Items[I].Parent = self) then begin
      Inc(result);
      if FIGrid.Items[I].ItemType in [itSet, itParent] then
        inc(Result, FIGrid.Items[I].ChildCount);
    end;
  end;
end;

procedure TO32InspectorItem.SetFont(Value: TFont);
begin
  if FType = itFont then begin
    FFont.Assign(Value);
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetInteger(Value: Integer);
begin
  if FInt <> Value then begin
    FInt := Value;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

{ - Added}
procedure TO32InspectorItem.SetItemsList(Value: TStringList);
var
  I: Integer;
  DS: string;
begin
  if FType in [itList, itLogical] then begin
    if Value.Count = 0 then
      FItemsList.Clear
    else
      FItemsList.Assign(Value);
  end else
    FItemsList.Clear;

  DS := '';
  if FItemsList.Count > 0 then begin
    if DisplayText = '' then
      DS := FItemsList.Strings[0]
    else begin
      for I := 0 to Pred(FItemsList.Count) do
        if DisplayText = FItemsList.Strings[I] then
          DS := FItemsList.Strings[I];
    end;
  end;

  DisplayText := DS;
end;
{=====}

procedure TO32InspectorItem.SetString(Value: string);
var
  Str: string;
begin
  Str := Value;
  { strip parens }
  if (Str <> '') then begin
    while Str[1] = '(' do Delete(Str, 1, 1);
    while (Str <> '') and (Str[Length(Str)] = ')') do Delete(Str, Length(Str), 1);
  end;

  case FType of
    itParent   : FString := '(' + Str + ')';
    itList     : begin
      {if the string is not in the list then ignore it.}
      if FItemsList.IndexOf(Str) > -1 then
        FString := Str
      else
        FString := '';
    end;
    itString   : FString   := Str;
    itInteger  : FInt      := StrToIntDef(Str, 0);
    itFloat    : FDouble   := StrToFloat(Str);
    itCurrency : begin
      StripCharSeq(FormatSettings.ThousandSeparator, Str);
      StripCharSeq(FormatSettings.CurrencyString, Str);
      FCurrency := StrToCurr(Str);
    end;
    itDate     : begin
      try
        FDate := StrToDateTime(Str);
      except
        FDate := now;
      end;
    end;
    itColor    : FColor := StrToColor(Str);
    itLogical  :
      FLogical := (AnsiUppercase(Str) = 'TRUE') or (AnsiUppercase(Str) = 'T');
    itFont     : FFont.Name := Str;
    itSet      : SetElementsAsString(Str);
  end;
  FIGrid.ItemChanged(Self);
end;
{=====}

{ - added}
procedure TO32InspectorItem.SetIndex(Value: Integer);
var
  All: TO32InspectorItems;
  OldID, NewID: Integer;
  Test1, Test2: Boolean;
  Down, SkippedAGroup : Boolean;
begin
  if (Value < 0) or (Value > pred(Collection.Count)) then Exit;

  OldID := Index;
  NewID := Value;
  All := (Collection as TO32InspectorItems);

  { this chunk is a little tricky, if a parented collection was moved to the   }
  { end of the list, then it would be stuck there.  This allows a non parented }
  { item to be moved to the very end of the list so that the parented cluster  }
  { could be free to move back up the list }
  if (Value = pred(Collection.Count))
  and (FType <> itParent)
  and (Parent = nil)
  and (TO32InspectorItem(All.Items[Pred(Collection.Count)]).Parent <> nil)
  then inherited;

  { Don't allow a non-parented item to be moved into a parent's group }
  { Skip over parents while moving down the list }
  if (NewID > OldID)
  and ((All.Items[NewID] as TO32InspectorItem).FType = itParent)
  and ((All.Items[NewID] as TO32InspectorItem).Parent <> self)
  then Inc(NewID);

  Test1 := ((All.Items[NewID] as TO32InspectorItem).Parent <> Parent);
  Test2 := ((All.Items[NewID] as TO32InspectorItem).Parent <> Self);
  Down := NewID > OldID;
  SkippedAGroup := false;

  while Test1 and Test2 do begin
    if Down then begin
      Inc(NewID);
      SkippedAGroup := true;
    end else
      Dec(NewID);
    if (NewID < 0) or (NewID > Pred(All.Count)) then exit;

    Test1 := ((All.Items[NewID] as TO32InspectorItem).Parent <> Parent);
    Test2 := ((All.Items[NewID] as TO32InspectorItem).Parent <> Self);
  end;

  if Down and SkippedAGroup then Dec(NewID);

  { don't allow an item to be moved out of scope }
  if (FParent <> nil) then begin
    if ((NewID <= FParent.Index)
    or (NewID > FParent.Index + FParent.ChildCount))
    then Exit;

    if (FType = itParent)
    and (NewID + ChildCount > FParent.Index + FParent.ChildCount)
    then Exit;
  end;

  { if this is a parent item, then move all of it's children }
  if FType = itParent then begin
    { Don't allow a collection to be moved out of scope }
    if (NewID + ChildCount > pred(Collection.Count)) then
      Exit;

    if NewID > OldID then begin
      { moving down the list (To a higher number) }
      All.Items[Succ(OldID + ChildCount)].Index := OldID;
    end else begin
      { moving up the list (toward zero) }
      if Succ(OldID + ChildCount) >= Pred(Collection.Count) then
        All.Items[OldID - 1].Index := Succ(OldID + ChildCount - 1)
      else
        All.Items[OldID - 1].Index := Succ(OldID + ChildCount);
    end;
  end else
    inherited SetIndex(NewID);

  FIGrid.ActiveItem := NewID;

  All.LoadVisibleItems;
  FIGrid.Invalidate;
end;
{=====}

function TO32InspectorItem.ColorToStr(Value: TColor): string;
begin
  { ColorConstants as defined in Graphics.pas }
  if Value = clBlack                    then result := 'clBlack'
  else if Value = clMaroon              then result := 'clMaroon'
  else if Value = clGreen               then result := 'clGreen'
  else if Value = clOlive               then result := 'clOlive'
  else if Value = clNavy                then result := 'clNavy'
  else if Value = clPurple              then result := 'clPurple'
  else if Value = clTeal                then result := 'clTeal'
  else if Value = clGray                then result := 'clGray'
  else if Value = clSilver              then result := 'clSilver'
  else if Value = clRed                 then result := 'clRed'
  else if Value = clLime                then result := 'clLime'
  else if Value = clYellow              then result := 'clYellow'
  else if Value = clBlue                then result := 'clBlue'
  else if Value = clFuchsia             then result := 'clFuchsia'
  else if Value = clAqua                then result := 'clAqua'
  else if Value = clLtGray              then result := 'clLtGray'
  else if Value = clDkGray              then result := 'clDkGray'
  else if Value = clWhite               then result := 'clWhite'
  else if Value = clNone                then result := 'clNone'
  else if Value = clDefault             then result := 'clDefault'
  else if Value = clScrollbar           then result := 'clScrollBar'
  else if Value = clBackground          then result := 'clBackground'
  else if Value = clActiveCaption       then result := 'clActiveCaption'
  else if Value = clInactiveCaption     then result := 'clInactiveCaption'
  else if Value = clMenu                then result := 'clMenu'
  else if Value = clWindow              then result := 'clWindow'
  else if Value = clWindowFrame         then result := 'clWindowFrame'
  else if Value = clMenuText            then result := 'clMenuText'
  else if Value = clWindowText          then result := 'clWindowText'
  else if Value = clCaptionText         then result := 'clCaptionText'
  else if Value = clActiveBorder        then result := 'clActiveBorder'
  else if Value = clInactiveBorder      then result := 'clInactiveBorder'
  else if Value = clAppWorkSpace        then result := 'clAppWorkSpace'
  else if Value = clHighlight           then result := 'clHighlight'
  else if Value = clHighlightText       then result := 'clHighlightText'
  else if Value = clBtnFace             then result := 'clBtnFace'
  else if Value = clBtnShadow           then result := 'clBtnShadow'
  else if Value = clGrayText            then result := 'clGrayText'
  else if Value = clBtnText             then result := 'clBtnText'
  else if Value = clInactiveCaptionText then result := 'clInactiveCaptionText'
  else if Value = clBTNHighlight        then result := 'clBtnHighlight'
  else if Value = cl3DDKShadow          then result := 'cl3DDkShadow'
  else if Value = cl3DLight             then result := 'cl3DLight'
  else if Value = clInfoText            then result := 'clInfoText'
  else if Value = clInfoBK              then result := 'clInfoBk'
  else result := IntToStr(Value);
end;
{=====}

function TO32InspectorItem.StrToColor(Value: string): TColor;
var
  Str: string;
begin
  { see if the color is a predefined color name }
  if Pos('CL', AnsiUpperCase(Value)) = 1 then begin
    { this is a ColorConstant as defined in Graphics.pas }
    Str := AnsiUpperCase(Value);
    if Str = 'CLBLACK'                    then result := clBlack
    else if Str = 'CLMAROON'              then result := clMaroon
    else if Str = 'CLGREEN'               then result := clGreen
    else if Str = 'CLOLIVE'               then result := clOlive
    else if Str = 'CLNAVY'                then result := clNavy
    else if Str = 'CLPURPLE'              then result := clPurple
    else if Str = 'CLTEAL'                then result :=  clTeal
    else if Str = 'CLGRAY'                then result := clGray
    else if Str = 'CLSILVER'              then result := clSilver
    else if Str = 'CLRED'                 then result := clRed
    else if Str = 'CLLIME'                then result := clLime
    else if Str = 'CLYELLOW'              then result := clYellow
    else if Str = 'CLBLUE'                then result := clBlue
    else if Str = 'CLFUCHSIA'             then result := clFuchsia
    else if Str = 'CLAQUA'                then result := clAqua
    else if Str = 'CLLTGRAY'              then result := clLtGray
    else if Str = 'CLDKGRAY'              then result := clDkGray
    else if Str = 'CLWHITE'               then result := clWhite
    else if Str = 'CLNONE'                then result := clNone
    else if Str = 'CLDEFAULT'             then result := clDefault
    else if Str = 'CLSCROLLBAR'           then result := clScrollBar
    else if Str = 'CLBACKGROUND'          then result := clBackground
    else if Str = 'CLACTIVECAPTION'       then result := clActiveCaption
    else if Str = 'CLINACTIVECAPTION'     then result := clInactiveCaption
    else if Str = 'CLMENU'                then result := clMenu
    else if Str = 'CLWINDOW'              then result := clWindow
    else if Str = 'CLWINDOWFRAME'         then result := clWindowFrame
    else if Str = 'CLMENUTEXT'            then result := clMenuText
    else if Str = 'CLWINDOWTEXT'          then result := clWindowText
    else if Str = 'CLCAPTIONTEXT'         then result := clCaptionText
    else if Str = 'CLACTIVEBORDER'        then result :=  clActiveBorder
    else if Str = 'CLINACTIVEBORDER'      then result := clInactiveBorder
    else if Str = 'CLAPPWORKSPACE'        then result := clAppWorkSpace
    else if Str = 'CLHIGHLIGHT'           then result := clHighlight
    else if Str = 'CLHIGHLIGHTTEXT'       then result := clHighlightText
    else if Str = 'CLBTNFACE'             then result := clBtnFace
    else if Str = 'CLBTNSHADOW'           then result := clBtnShadow
    else if Str = 'CLGRAYTEXT'            then result := clGrayText
    else if Str = 'CLBTNTEXT'             then result := clBtnText
    else if Str = 'CLINACTIVECAPTIONTEXT' then result := clInactiveCaptionText
    else if Str = 'CLBTNHIGHLIGHT'        then result := clBtnHighlight
    else if Str = 'CL3DDKSHADOW'          then result := cl3DDkShadow
    else if Str = 'CL3DLIGHT'             then result := cl3DLight
    else if Str = 'CLINFOTEXT'            then result := clInfoText
    else if Str = 'CLINFOBK'              then result := clInfoBk
    else raise(Exception.Create(GetOrphStr(SCBadColorConst) + ': ' + Value));
  end

  else begin
    {Maybe thy are attempting to set the color with a hexidecimal value?...}
    try
      result := StrToIntDef(Value, 0);
    except
      raise(Exception.Create(GetOrphStr(SCBadColorValue) + ': ' + Value));
    end;
  end;
end;
{=====}

procedure TO32InspectorItem.SetElementsAsString(Value: string);
var
  CommaPos: Integer;
  SetStr, ElementStr: string;
  NewItem: TO32InspectorItem;
begin
  if (csLoading in FIGrid.ComponentState) then exit;

  SetStr := Value;
  if SetStr = '' then exit;

  { strip any extranneous characters from the ends }
  while not (ord(SetStr[1]) in [48..57, 65..90, 97..122]) do begin
    Delete(SetStr, 1, 1);
    if (Length(SetStr) <= 0) then exit;
  end;
  while not (ord(SetStr[Length(SetStr)]) in [48..57, 65..90, 97..122]) do begin
    Delete(SetStr, Length(SetStr), 1);
    if (Length(SetStr) <= 0) then exit;
  end;

  {Break the set string apart and create new items for each element}
  if SetStr <> '' then begin
    CommaPos := Pos(',', SetStr);
    { Add all but the last item }
    while CommaPos > 0 do begin
      ElementStr := Copy(SetStr, 1, CommaPos - 1);
      Delete(SetStr, 1, CommaPos);
      { strip any blanks from ElementStr }
      StripCharFromFront(' ', ElementStr);
      StripCharFromEnd(' ', ElementStr);
      { strip blanks and extra commas from the front of SetStr }
      StripCharFromFront(' ', SetStr);
      StripCharFromFront(',', SetStr);
      StripCharFromFront(' ', SetStr);

      NewItem := FIGrid.Add(itLogical, Self);
      NewItem.Caption := ElementStr;
      NewItem.FLevel := Self.Level + 1;
      NewItem.ImageIndex := -1;
      NewItem.AsBoolean := true;
      CommaPos := Pos(',', SetStr);
    end;
    { Add the last item }
    if SetStr <> '' then begin
      ElementStr := SetStr;
      { strip any blanks from ElementStr }
      while (ElementStr[1] = ' ') do
        delete(ElementStr, 1, 1);
      while (ElementStr[Length(ElementStr)] = ' ') do
        delete(ElementStr, Length(ElementStr), 1);

      NewItem := FIGrid.Add(itLogical, Self);
      NewItem.Caption := ElementStr;
      NewItem.AsBoolean := true;
    end;
  end;

end;
{=====}

function TO32InspectorItem.GetElementsAsString: string;
var
  I: Integer;
  Item: TO32InspectorItem;
begin
  if FType = itSet then begin
    result := '[';
    for I := Index + 1 to FIGrid.ItemCollection.Count - 1 do begin
      Item := FIGrid.Items[I];
      if (Item.FParent = self) and (Item.ItemType = itLogical)
      and (Item.AsBoolean) then
        result := result + Item.Caption + ', ';
    end;
    while result[Length(result)] = ' ' do delete(result, length(result), 1);
    while result[Length(result)] = ',' do delete(result, length(result), 1);
    result := result + ']';
  end else
    result := '';
end;
{=====}

procedure TO32InspectorItem.SetValue(Value: Variant);
begin
  case FType of
    itParent   : FString := '(' + Value + ')';
    itList     : begin
      {if the string is not in the list then ignore it.}
      if FItemsList.IndexOf(Value) > -1 then
        FString := Value
      else
        FString := '';
    end;
    itString   : FString   := Value;
    itInteger  : FInt      := Value;
    itFloat    : FDouble   := Value;
    itCurrency : FCurrency := Value;

    itDate     : begin
      try
        FDate := Value;
      except
        FDate := now;
      end;
    end;
    itLogical  : FLogical := Value;
    itSet      : SetElementsAsString(Value);
  end;
  FIGrid.ItemChanged(Self);
end;
{=====}

procedure TO32InspectorItem.SetType(Value: TO32IGridItemType);
begin
  if Value <> FType then begin
    FType := Value;
    case FType of
        {itParent    :}
        {itSet       :}
        {itList      :}
        {itString    :}
        {itInteger   :}
        {itFloat     :}
        {itCurrency  :}
        itDate      : FDate := now;
        itColor     : FColor := clBlack;
        itLogical   : begin
          if FItemsList.count = 0 then begin
            FItemsList.Add('True');
            FItemsList.Add('False');
          end;
          AsString := 'true';
        end;
        itFont      : FFont.Assign(FIGrid.Font);
    end;
    FIGrid.ItemChanged(Self);
  end;
end;
{=====}

procedure TO32InspectorItem.SetCaption(Value: string);
begin
  if Value <> FCaption then begin
    FCaption := Value;
    if FIGrid.Sorted then
      (Collection as TO32InspectorItems).Sort;
    FIGrid.ItemChanged(Self);
  end;
end;

{===== TO32CustomInspectorGrid =======================================}

constructor TO32CustomInspectorGrid.Create(AOwner: TComponent);
const
  GridStyle = [csCaptureMouse, csOpaque, csDoubleClicks];
begin
  inherited Create(AOwner);
  if NewStyleControls then
    ControlStyle := GridStyle
  else
    ControlStyle := GridStyle + [csFramed];

  // To prevent flickering
  DoubleBuffered := true;

  FItems := TO32InspectorItems.Create(Self, TO32InspectorItem);
  FExpandGlyph := TBitmap.Create;
  FChildIndentation := 5;
  FCanEditModify := true;
  FAutoExpand := false;
  FReadOnly := false;
  FUpdatingIndex := 0;
  FSorted := false;
  FFont := TFont.Create;
  FFont.Assign(TCustomForm(AOwner).Font);
  Color := clMenu;
  FEditColor := clWindow;
  FGridLineColor := clBtnShadow;
  FCaptionTextColor := clBlack;
  FItemTextColor := clNavy;
  FColCount := 2;
  FRowCount := 0;
  FFixedCols := 0;
  FFixedRows := 0;
  FGridLineWidth := 1;
  FOptions := [goVertLine, goHorzLine, goColSizing, goThumbTracking,
               goRowSelect];
  DesignOptionsBoost := [goColSizing, goRowSizing];
  FFixedColor := clBtnFace;
  FScrollBars := ssNone;
  FBorderStyle := bsSingle;
  FDefaultColWidth := 64;
  FDefaultRowHeight := 24;
  FDefaultDrawing := True;
  Width := (FDefaultColWidth * 2) + 6;
  Height := FDefaultRowHeight * 10;
  FSaveCellExtents := True;
  FEditorMode := False;
  ParentColor := False;
  TabStop := True;
  SetBounds(Left, Top, Width, Height);
  Initialize;
end;
{=====}

destructor TO32CustomInspectorGrid.Destroy;
begin
  FInplaceEdit.Free;
  FExpandGlyph.Free;
  FItems.Free;
  FFont.Free;
  FreeMem(FColWidths);
  FreeMem(FRowHeights);
  FreeMem(FTabStops);
  inherited Destroy;
end;
{=====}

procedure TO32CustomInspectorGrid.SetParent(Value: TWinControl);
begin
  inherited;
  CalcRowHeight;
end;
{=====}

procedure TO32CustomInspectorGrid.AdjustSize(Index, Amount: Integer; Rows: Boolean);
var
  NewCur: TGridCoord;
  OldRows, OldCols: Integer;
  MovementX, MovementY: Integer;
  MoveRect: TGridRect;
  ScrollArea: TRect;
  AbsAmount: Integer;

  function DoSizeAdjust(var Count: Integer; var Extents: Pointer;
    DefaultExtent: Integer; var Current: Integer): Integer;
  var
    I: Integer;
    NewCount: Integer;
  begin
    NewCount := Count + Amount;
    if NewCount < Index then
      raise EInvalidGridOperation.Create(STooManyDeleted);
    if (Amount < 0) and Assigned(Extents) then begin
      Result := 0;
      for I := Index to Index - Amount - 1 do
        Inc(Result, PIntArray(Extents)^[I]);
    end
    else
      Result := Amount * DefaultExtent;
    if Extents <> nil then
      ModifyExtents(Extents, Index, Amount, DefaultExtent);
    Count := NewCount;
    if Current >= Index then
      if (Amount < 0) and (Current < Index - Amount) then Current := Index
      else Inc(Current, Amount);
  end;

begin
  if Amount = 0 then Exit;
  NewCur := FCurrent;
  OldCols := 2;
  OldRows := RowCount;
  MoveRect.Left := 0;
  MoveRect.Right := 1;
  MoveRect.Top := 0;
  MoveRect.Bottom := RowCount - 1;
  MovementX := 0;
  MovementY := 0;
  AbsAmount := Amount;
  if AbsAmount < 0 then AbsAmount := -AbsAmount;
  if Rows then
  begin
    MovementY := DoSizeAdjust(FRowCount, FRowHeights, DefaultRowHeight, NewCur.Y);
    MoveRect.Top := Index;
    if Index + AbsAmount <= TopRow then MoveRect.Bottom := TopRow - 1;
  end
  else
  begin
    MovementX := DoSizeAdjust(FColCount, FColWidths, 64{DefaultColWidth}, NewCur.X);
    MoveRect.Left := Index;
  end;
  GridRectToScreenRect(MoveRect, ScrollArea, True);
  if not IsRectEmpty(ScrollArea) then
  begin
    ScrollWindow(Handle, MovementX, MovementY, @ScrollArea, @ScrollArea);
    UpdateWindow(Handle);
  end;
  SizeChanged(OldCols, OldRows);
  if (NewCur.X <> FCurrent.X) or (NewCur.Y <> FCurrent.Y) then
    MoveCurrent(NewCur.X, NewCur.Y, True, True);
end;
{=====}

function TO32CustomInspectorGrid.BoxRect(ALeft, ATop, ARight, ABottom: Integer): TRect;
var
  GridRect: TGridRect;
begin
  GridRect.Left := ALeft;
  GridRect.Right := ARight;
  GridRect.Top := ATop;
  GridRect.Bottom := ABottom;
  GridRectToScreenRect(GridRect, Result, False);
end;
{=====}

procedure TO32CustomInspectorGrid.DoExit;
begin
  UpdateCellContents;
  inherited DoExit;
  if not (goAlwaysShowEditor in Options) then HideEditor;
end;
{=====}

function TO32CustomInspectorGrid.CellRect(ACol, ARow: Integer): TRect;
begin
  Result := BoxRect(ACol, ARow, ACol, ARow);
end;
{=====}

function TO32CustomInspectorGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.CanGridAcceptKey(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.CanEditModify: Boolean;
begin
  Result := FCanEditModify;
end;
{=====}

function TO32CustomInspectorGrid.CanEditShow: Boolean;
begin
  Result := false;

  if FReadOnly then Exit;

  if (csDesigning in ComponentState) then
    exit;

  if FItems.VisibleItems.Count < 1 then
    exit;


  Result := not (TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ItemType
    in [itParent, itSet])
     and not TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ReadOnly;

end;
{=====}

function TO32CustomInspectorGrid.IsActiveControl: Boolean;
var
  H: Hwnd;
  ParentForm: TCustomForm;
begin
  Result := False;
  ParentForm := GetParentForm(Self);
  if Assigned(ParentForm) then
  begin
    if (ParentForm.ActiveControl = Self) then
      Result := True
  end
  else
  begin
    H := GetFocus;
    while IsWindow(H) and (Result = False) do
    begin
      if H = WindowHandle then
        Result := True
      else
        H := GetParent(H);
    end;
  end;
end;
{=====}

function TO32CustomInspectorGrid.GetEditMask(ACol, ARow: Integer): string;
var
  Mask: string;
begin
  if Assigned(FOnGetEditMask) then
    FOnGetEditMask(Self, TO32InspectorItem(FItems[ARow]), Mask);

  result := Mask;
end;
{=====}

function TO32CustomInspectorGrid.GetEditText(ACol, ARow: Integer): string;
var
  Text: string;
begin
  if Assigned(FOnGetEditText) then
    FOnGetEditText(Self, TO32InspectorItem(FItems.VisibleItems[ARow]), Text)
  else
    Text := TO32InspectorItem(FItems.VisibleItems[ARow]).AsString;

  result := Text;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditText(ACol, ARow: Integer; const Value: string);
begin
  TO32InspectorItem(FItems.VisibleItems[ARow]).AsString := Value;
end;
{=====}

function TO32CustomInspectorGrid.GetEditLimit: Integer;
var
  Limit: Integer;
begin
  Limit := 0;
  if Assigned(FOnGetEditLimit) then
    FOnGetEditLimit(Self, TO32InspectorItem(FItems.VisibleItems[ActiveRow]),
      Limit);

  result := Limit;
end;
{=====}

procedure TO32CustomInspectorGrid.HideEditor;
begin
  FEditorMode := False;
  HideEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.ShowEditor;
begin
  FEditorMode := True;
  UpdateEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.ShowEditorChar(Ch: Char);
begin
  ShowEditor;
  if FInplaceEdit <> nil then
    PostMessage(FInplaceEdit.Handle, WM_CHAR, Word(Ch), 0);
end;
{=====}

procedure TO32CustomInspectorGrid.EditorChanged;
begin
  if Assigned(FOnItemEditorChange) then
    FOnItemEditorChange(self, ActiveItem);
end;
{=====}

procedure TO32CustomInspectorGrid.ReadColWidths(Reader: TReader);
var
  I: Integer;
begin
  with Reader do
  begin
    ReadListBegin;
    for I := 0 to 1 do ColWidths[I] := ReadInteger;
    ReadListEnd;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.ReadRowHeights(Reader: TReader);
var
  I: Integer;
begin
  with Reader do
  begin
    ReadListBegin;
    for I := 0 to RowCount - 1 do RowHeights[I] := ReadInteger;
    ReadListEnd;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.WriteColWidths(Writer: TWriter);
var
  I: Integer;
begin
  with Writer do begin
    WriteListBegin;
    for I := 0 to 1 do WriteInteger(ColWidths[I]);
    WriteListEnd;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.WriteRowHeights(Writer: TWriter);
var
  I: Integer;
begin
  with Writer do begin
    WriteListBegin;
    for I := 0 to RowCount - 1 do WriteInteger(RowHeights[I]);
    WriteListEnd;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.DefineProperties(Filer: TFiler);

  function DoColWidths: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not CompareExtents(TO32CustomInspectorGrid(Filer.Ancestor).FColWidths, FColWidths)
    else
      Result := FColWidths <> nil;
  end;

  function DoRowHeights: Boolean;
  begin
    if Filer.Ancestor <> nil then
      Result := not CompareExtents(TO32CustomInspectorGrid(Filer.Ancestor).FRowHeights, FRowHeights)
    else
      Result := FRowHeights <> nil;
  end;


begin
  inherited DefineProperties(Filer);
  if FSaveCellExtents then
    with Filer do
    begin
      DefineProperty('ColWidths', ReadColWidths, WriteColWidths, DoColWidths);
      DefineProperty('RowHeights', ReadRowHeights, WriteRowHeights, DoRowHeights);
    end;
end;
{=====}

procedure TO32CustomInspectorGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);

  procedure DrawGlyph(ARect: TRect; Item: Integer);
  var
    SavePenColor, SaveBrushColor, TmpColor: TColor;
    TempRect: TRect;
  begin
    {Save canvas colors }
    SavePenColor := Canvas.Pen.Color;
    SaveBrushColor := Canvas.Brush.Color;

    if TO32InspectorItem(FItems.VisibleItems[Item]).ChildCount > 0 then
    begin
      Canvas.Pen.Color := cl3DDkShadow;
      Canvas.Brush.Color := clBtnHighlight;
    end else begin
      Canvas.Pen.Color := clGrayText;
      Canvas.Brush.Color := Color;
    end;

    if FExpandGlyph.Height = 0 then begin
    { Draw a default glyph since there is no image assigned... }
      { Fill the glyph area with the background color }
      Canvas.FillRect(ARect);
      TmpColor := Canvas.Brush.Color;
      { Flip Colors... }
      Canvas.Brush.Color := Canvas.Pen.Color;
      { Draw a square }
      Canvas.FrameRect(ARect);
      { Un-flip colors }
      Canvas.Brush.Color := TmpColor;

      {Draw a minus in the square}
      Canvas.MoveTo(ARect.Left + 2, ARect.Top
        + (ARect.Bottom - ARect.Top) div 2);
      Canvas.LineTo(ARect.Right - 2, ARect.Top
        + (ARect.Bottom - ARect.Top) div 2);

      if not TO32InspectorItem(FItems.VisibleItems[Item]).FExpanded then begin
      {Draw the vertical part of the plus}
        Canvas.MoveTo(ARect.Left + ((ARect.Right - ARect.Left) div 2),
          ARect.Top + 2);
        Canvas.LineTo(ARect.Left + ((ARect.Right - ARect.Left) div 2),
          ARect.Bottom - 2);
      end;
    end

    else begin
    { The user has specified an image to use for the glyph states so load it }
    { from the supplied bitmap }

      if TO32InspectorItem(FItems.VisibleItems[Item]).ChildCount > 0 then
      {Enabled}
      begin
        if not TO32InspectorItem(FItems.VisibleItems[Item]).FExpanded then
        {Draw the enabled "Plus" part of the glyph}
          TempRect := Rect(0, 0, FExpandGlyph.Height, FExpandGlyph.Height)
        else
        {Draw the enabled "Minus" part of the glyph}
          TempRect := Rect(FExpandGlyph.Height * 2, 0, FExpandGlyph.Height * 3,
            FExpandGlyph.Height)
      end else
        {Draw the disabled "Plus" part of the glyph}
        TempRect := Rect(FExpandGlyph.Height, 0, FExpandGlyph.Height * 2,
          FExpandGlyph.Height);

      {Draw the glyph}
      Canvas.CopyRect(ARect, FExpandGlyph.Canvas, TempRect);

    end;
    { Reinstate canvas colors. }
    Canvas.Pen.Color := SavePenColor;
    Canvas.Brush.Color := SaveBrushColor;
  end;

var
  Str: string;
  GlyphRect: TRect;
  BrushColor, PenColor, FontColor: TColor;
  TransparentColor: TColor;
  SaveBrush, SavePen: TColor;
  Item: TO32InspectorItem;
  Bmp: TBitmap;
  r, c: Integer;
  Default: boolean;
begin
  if FItems.VisibleItems.Count < 1 then exit;

  { save colors }
  PenColor := Canvas.Pen.Color;
  BrushColor := Canvas.Brush.Color;
  FontColor := Canvas.Font.Color;

  Item := TO32InspectorItem(FItems.VisibleItems[ARow]);

  Default := true;
  if Assigned(FOnCellPaint) then
    FOnCellPaint(Self, ARect, Canvas, Item.Index, icRight,
      Default);

  if Default then begin
    if ACol = 0 then begin
    { Paint the caption cell (left) }
      Str := Str + Item.Caption;

      { if there are no parent items, then don't leave the space for }
      { the expand glyph }
      if ParentTypeCount > 0 then begin
        { Indent child items }
        ARect.Left := ARect.Left + (Item.FLevel * ChildIndentation);

        { Draw the expand glyph for all parent items }
        if (Item.ItemType in [itParent, itSet]) then
        begin
          { set up the glyph's rect }
          GlyphRect.Top := ARect.Top + ((ARect.Bottom - ARect.Top) div 2) - 5;
          GlyphRect.Left := ARect.Left + 2;
          GlyphRect.Right := GlyphRect.Left + 9;
          GlyphRect.Bottom := GlyphRect.Top + 9;
          { Draw the glyph }
          DrawGlyph(GlyphRect, ARow);
        end;

        { Move the text rect's left side a little to the right to allow room }
        { for the glyph.}
        ARect.Left := ARect.Left + 11;
      end;

      { if the item has an associated image in the ImageList then draw it now }
      if (Item.ImageIndex > -1)
      and (Images <> nil) then begin
        Bmp := TBitmap.Create;
        try
          Images.GetBitmap(Item.ImageIndex, Bmp);
          if Bmp.Height > 0 then begin
            GlyphRect.Top := ARect.Top;
            GlyphRect.Left := ARect.Left;
            GlyphRect.Right := ARect.Left + (ARect.Bottom - ARect.Top);
            GlyphRect.Bottom := ARect.Bottom;

            { fix transparent color }
            TransparentColor := Bmp.Canvas.Pixels[1, Bmp.Height - 1];
            for r := 0 to Bmp.Height - 1 do
              for c := 0 to Bmp.Width - 1 do
                if Bmp.Canvas.Pixels[c, r] = TransparentColor then
                  Bmp.Canvas.Pixels[c, r] := Canvas.Brush.Color;
            { Draw the glyph }
            Canvas.Draw(GlyphRect.Left, GlyphRect.Top, Bmp);

            { Move the text rect's left side a little to the right to allow }
            { room for the glyph. }
            ARect.Left := ARect.Left + (ARect.Bottom - ARect.Top) + 2;
          end;
        finally
          Bmp.Free;
        end;
      end;

      { Draw the text }
      Canvas.Font.Color := FCaptionTextColor;
      Canvas.TextRect(ARect, ARect.Left+2, ARect.Top+2, Str);
    end

    { Paint the value cell (right) }
    else if TO32InspectorItem(FItems.VisibleItems[ARow]).ItemType = itColor then
    begin
      { Draw a little color square next to the color's name }
      GlyphRect.Top := ARect.Top + ((ARect.Bottom - ARect.Top) div 2) - 6;
      GlyphRect.Left := ARect.Left + 2;
      GlyphRect.Right := GlyphRect.Left + 12;
      GlyphRect.Bottom := GlyphRect.Top + 12;
      { Save and set colors }
      SaveBrush := Canvas.Brush.Color;
      SavePen := Canvas.Pen.Color;
      Canvas.Brush.Color :=
        TO32InspectorItem(FItems.VisibleItems[ARow]).AsColor;
      { draw color box }
      Canvas.FillRect(GlyphRect);
      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect(GlyphRect);
      { reset colors }
      Canvas.Brush.Color := SaveBrush;
      Canvas.Pen.Color := SavePen;
      { Draw Text }
      GlyphRect := ARect;
      GlyphRect.Left := GlyphRect.Left + 16;
      Canvas.Font.Color := FItemTextColor;
      Canvas.TextRect(GlyphRect, GlyphRect.Left+2, GlyphRect.Top+2,
        TO32InspectorItem(FItems.VisibleItems[ARow]).AsString);
    end
    else begin
      Canvas.Font.Color := FItemTextColor;
      Canvas.TextRect(ARect, ARect.Left+2, ARect.Top+2,
        TO32InspectorItem(FItems.VisibleItems[ARow]).AsString);
    end;
  end;
  {else if Assigned(FOnCellPaint) then}
    {FOnCellPaint(Self, ARect, Canvas, Item, Cell, Default);}

  { restore colors }
  Canvas.Pen.Color := PenColor;
  Canvas.Brush.Color := BrushColor;
  Canvas.Font.Color := FontColor;
end;
{=====}

function TO32CustomInspectorGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
  Result := True;
end;

procedure TO32CustomInspectorGrid.SizeChanged(OldColCount, OldRowCount: Integer);
begin
end;
{=====}

function TO32CustomInspectorGrid.Sizing(X, Y: Integer): Boolean;
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Index: Integer;
  Pos, Ofs: Integer;
begin
  State := FGridState;
  if State = gsNormal then
  begin
    CalcDrawInfo(DrawInfo);
    CalcSizingState(X, Y, State, Index, Pos, Ofs, DrawInfo);
  end;
  Result := State <> gsNormal;
end;
{=====}

procedure TO32CustomInspectorGrid.TopLeftChanged;
begin
  if FEditorMode and (FInplaceEdit <> nil) then
    UpdateEditorLocation;
end;
{=====}

procedure TO32CustomInspectorGrid.Paint;
var
  DrawInfo: TGridDrawInfo;
  Sel: TGridRect;
  UpdateRect: TRect;
  FocRect: TRect;
  I: Integer;

  procedure DrawCells(ACol, ARow: Integer; StartX, StartY, StopX, StopY: Integer;
    Color: TColor; IncludeDrawState: TGridDrawState);
  var
    CurCol, CurRow: Integer;
    Where: TRect;
    DrawState: TGridDrawState;
    Focused: Boolean;
  begin
    CurRow := ARow;
    Where.Top := StartY;
    while (Where.Top < StopY) and (CurRow < RowCount) do
    begin
      CurCol := ACol;
      Where.Left := StartX;
      Where.Bottom := Where.Top + RowHeights[CurRow];
      while (Where.Left < StopX) and (CurCol < 2) do
      begin
        { Move the left side one pixel to the right to allow the centerline }
        { highlight to show }
        if CurCol > 0 then
          Where.Left := Where.Left + 1;

        Where.Right := Where.Left + ColWidths[CurCol];
        if (Where.Right > Where.Left) and RectVisible(Canvas.Handle, Where) then
        begin
          DrawState := IncludeDrawState;
          Focused := IsActiveControl;
          if Focused and (CurRow = ActiveRow) and (CurCol = Col)  then
            Include(DrawState, gdFocused);
          if PointInGridRect(CurCol, CurRow, Sel) then
            Include(DrawState, gdSelected);
          if not (gdFocused in DrawState) or not (goEditing in Options) or
            not FEditorMode or (csDesigning in ComponentState) then
          begin
            { Paint the cell }
            if DefaultDrawing or (csDesigning in ComponentState) then begin
              Canvas.Font.Assign(Self.Font);
              Canvas.Brush.Color := Color;
              Canvas.FillRect(Where);
            end;
            DrawCell(CurCol, CurRow, Where, DrawState);
          end;
        end;
        Where.Left := Where.Right + DrawInfo.Horz.EffectiveLineWidth;
        Inc(CurCol);
      end;
      Where.Top := Where.Bottom + DrawInfo.Vert.EffectiveLineWidth;
      Inc(CurRow);
    end;
  end;

begin
  if FUpdatingIndex > 0 then exit;

  UpdateRect := Canvas.ClipRect;
  CalcDrawInfo(DrawInfo);

  with DrawInfo do begin
    if FItems.VisibleItems.Count > 0 then begin
      if (Horz.EffectiveLineWidth > 0) or (Vert.EffectiveLineWidth > 0) then
      begin
        { Draw the grid lines... }
        Canvas.Pen.Width := 1;
        Canvas.Pen.Color := FGridLineColor;
        { Draw Horizontal Lines }
        Canvas.MoveTo(0, DefaultRowHeight);
        Canvas.LineTo(Width, DefaultRowHeight);

        for I := 2 to (RowCount) do begin
          Canvas.MoveTo(0, I * (DefaultRowHeight + 1) - 1);
          Canvas.LineTo(Width, I * (DefaultRowHeight + 1) - 1);
        end;

        { Draw Vertical line }
        Canvas.MoveTo(ColWidths[0], 0);
        Canvas.LineTo(ColWidths[0], RowCount * (DefaultRowHeight + 1));
        { Highlight }
        Canvas.Pen.Color := clBtnHighlight;
        Canvas.MoveTo(ColWidths[0] + 1, 0);
        Canvas.LineTo(COlWidths[0] + 1, RowCount * (DefaultRowHeight + 1));
      end;

      { Draw the cells in the four areas }
      Sel := Selection;
      DrawCells(0, TopRow, Horz.FixedBoundary - FColOffset,
        Vert.FixedBoundary, Horz.GridBoundary, Vert.GridBoundary, Color, []);

      if not (csDesigning in ComponentState) and
        (goRowSelect in Options) and DefaultDrawing then
      begin
        GridRectToScreenRect(GetSelection, FocRect, False);

        {Draw the selected item as if it were lowered}
        Canvas.Pen.Color := cl3DDkShadow; {DarkShadowColor}
        Canvas.MoveTo(FocRect.Left, FocRect.Bottom);
        Canvas.LineTo(FocRect.Left, FocRect.Top);
        Canvas.LineTo(FocRect.Right, FocRect.Top);
        Canvas.Pen.Color := clBtnHighlight;
        Canvas.LineTo(FocRect.Right, FocRect.Bottom);
        Canvas.LineTo(FocRect.Left, FocRect.Bottom);
      end;
    end;

    { Fill in area not occupied by cells }
    if Horz.GridBoundary < Horz.GridExtent then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(Horz.GridBoundary, 0, Horz.GridExtent, Vert.GridBoundary));
    end;
    if Vert.GridBoundary < Vert.GridExtent then
    begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(0, Vert.GridBoundary, Horz.GridExtent, Vert.GridExtent));
    end;
  end;
end;
{=====}

function TO32CustomInspectorGrid.CalcCoordFromPoint(X, Y: Integer;
  const DrawInfo: TGridDrawInfo): TGridCoord;

  function DoCalc(const AxisInfo: TGridAxisDrawInfo; N: Integer): Integer;
  var
    I, Start, Stop: Integer;
    Line: Integer;
  begin
    with AxisInfo do
    begin
      if N < FixedBoundary then
      begin
        Start := 0;
        Stop :=  FixedCellCount - 1;
        Line := 0;
      end
      else
      begin
        Start := FirstGridCell;
        Stop := GridCellCount - 1;
        Line := FixedBoundary;
      end;
      Result := -1;
      for I := Start to Stop do
      begin
        Inc(Line, GetExtent(I) + EffectiveLineWidth);
        if N < Line then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

  function DoCalcRightToLeft(const AxisInfo: TGridAxisDrawInfo; N: Integer): Integer;
  var
    I, Start, Stop: Integer;
    Line: Integer;
  begin
    N := ClientWidth - N;
    with AxisInfo do
    begin
      if N < FixedBoundary then
      begin
        Start := 0;
        Stop :=  FixedCellCount - 1;
        Line := ClientWidth;
      end
      else
      begin
        Start := FirstGridCell;
        Stop := GridCellCount - 1;
        Line := FixedBoundary;
      end;
      Result := -1;
      for I := Start to Stop do
      begin
        Inc(Line, GetExtent(I) + EffectiveLineWidth);
        if N < Line then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;

begin
  Result.X := DoCalc(DrawInfo.Horz, X);
  Result.Y := DoCalc(DrawInfo.Vert, Y);
end;
{=====}

procedure TO32CustomInspectorGrid.CalcDrawInfo(var DrawInfo: TGridDrawInfo);
begin
  CalcDrawInfoXY(DrawInfo, ClientWidth, ClientHeight);
end;
{=====}

procedure TO32CustomInspectorGrid.CalcDrawInfoXY(var DrawInfo: TGridDrawInfo;
  UseWidth, UseHeight: Integer);

  procedure CalcAxis(var AxisInfo: TGridAxisDrawInfo; UseExtent: Integer);
  var
    I: Integer;
  begin
    with AxisInfo do
    begin
      GridExtent := UseExtent;
      GridBoundary := FixedBoundary;
      FullVisBoundary := FixedBoundary;
      LastFullVisibleCell := FirstGridCell;
      for I := FirstGridCell to GridCellCount - 1 do
      begin
        Inc(GridBoundary, GetExtent(I) + EffectiveLineWidth);
        if GridBoundary > GridExtent + EffectiveLineWidth then
        begin
          GridBoundary := GridExtent;
          Break;
        end;
        LastFullVisibleCell := I;
        FullVisBoundary := GridBoundary;
      end;
    end;
  end;

begin
  CalcFixedInfo(DrawInfo);
  CalcAxis(DrawInfo.Horz, UseWidth);
  CalcAxis(DrawInfo.Vert, UseHeight);
end;
{=====}

procedure TO32CustomInspectorGrid.CalcFixedInfo(var DrawInfo: TGridDrawInfo);

  procedure CalcFixedAxis(var Axis: TGridAxisDrawInfo; LineOptions: TGridOptions;
    FixedCount, FirstCell, CellCount: Integer; GetExtentFunc: TGetExtentsFunc);
  var
    I: Integer;
  begin
    with Axis do
    begin
      if LineOptions * Options = [] then
        EffectiveLineWidth := 0
      else
        EffectiveLineWidth := 1;//GridLineWidth;

      FixedBoundary := 0;
      for I := 0 to FixedCount - 1 do
        Inc(FixedBoundary, GetExtentFunc(I) + EffectiveLineWidth);

      FixedCellCount := FixedCount;
      FirstGridCell := FirstCell;
      GridCellCount := CellCount;
      GetExtent := GetExtentFunc;
    end;
  end;

begin
  CalcFixedAxis(DrawInfo.Horz, [goFixedVertLine, goVertLine], 0,
    0, 2, GetColWidths);
  CalcFixedAxis(DrawInfo.Vert, [goFixedHorzLine, goHorzLine], 0,
    TopRow, RowCount, GetRowHeights);
end;
{=====}

{ Calculates the TopLeft that will put the given Coord in view }
function TO32CustomInspectorGrid.CalcMaxTopLeft(const Coord: TGridCoord;
  const DrawInfo: TGridDrawInfo): TGridCoord;

  function CalcMaxCell(const Axis: TGridAxisDrawInfo; Start: Integer): Integer;
  var
    Line: Integer;
    I, Extent: Integer;
  begin
    Result := Start;
    with Axis do
    begin
      Line := GridExtent + EffectiveLineWidth;
      for I := Start downto FixedCellCount do
      begin
        Extent := GetExtent(I);
        if Extent > 0 then
        begin
          Dec(Line, Extent);
          Dec(Line, EffectiveLineWidth);
          if Line < FixedBoundary then
          begin
            if (Result = Start) and (GetExtent(Start) <= 0) then
              Result := I;
            Break;
          end;
          Result := I;
        end;
      end;
    end;
  end;

begin
  Result.X := CalcMaxCell(DrawInfo.Horz, Coord.X);
  Result.Y := CalcMaxCell(DrawInfo.Vert, Coord.Y);
end;
{=====}

procedure TO32CustomInspectorGrid.CalcSizingState(X, Y: Integer; var State: TGridState;
  var Index: Integer; var SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);

  procedure CalcAxisState(const AxisInfo: TGridAxisDrawInfo; Pos: Integer;
    NewState: TGridState);
  var
    I, Line, Back, Range: Integer;
  begin
    with AxisInfo do
    begin
      Line := FixedBoundary;
      Range := EffectiveLineWidth;
      Back := 0;
      if Range < 7 then
      begin
        Range := 7;
        Back := (Range - EffectiveLineWidth) shr 1;
      end;
      for I := FirstGridCell to GridCellCount - 1 do
      begin
        Inc(Line, GetExtent(I));
        if Line > GridBoundary then Break;
        if (Pos >= Line - Back) and (Pos <= Line - Back + Range) then
        begin
          State := NewState;
          SizingPos := Line;
          SizingOfs := Line - Pos;
          Index := I;
          Exit;
        end;
        Inc(Line, EffectiveLineWidth);
      end;
      if (GridBoundary = GridExtent) and (Pos >= GridExtent - Back)
        and (Pos <= GridExtent) then
      begin
        State := NewState;
        SizingPos := GridExtent;
        SizingOfs := GridExtent - Pos;
        Index := LastFullVisibleCell + 1;
      end;
    end;
  end;

begin
  State := gsNormal;
    with FixedInfo do begin
      Vert.GridExtent := ClientHeight;
      Horz.GridExtent := ClientWidth;
        if (X > ColWidths[0] + 2) then exit;
        CalcAxisState(Horz, X, gsColSizing);
    end;
end;
{=====}

procedure TO32CustomInspectorGrid.CalcRowHeight;
var
  I, Ht: Integer;
begin
  if (csDestroying in ComponentState) then exit;

  DefaultRowHeight := Canvas.TextHeight(GetOrphStr(SCTallLowChars))
    + (TextMargin * 2);

  { For now I have to use the wrapped up Windows combo box for which I have   }
  { no control over the height or borders.  For now, we will force minimum    }
  { RowHeight to 21 which is the height of a standard combo box.              }
  if DefaultRowHeight < 21 then DefaultRowHeight := 19;
  { Later I plan on creating a new combo box from scratch and replacing these }
  { combo boxes with descendants of the new one.                              }

  Ht := 0;

  for I := 0 to RowCount - 1 do
    Inc(Ht, RowHeights[I]);

  if (Ht + 4) > Height then begin
    if ScrollBars <> ssVertical then
      ColWidths[1] := ColWidths[1] - ScrollBarWidth;
    ScrollBars := ssVertical
  end else begin
    if ScrollBars <> ssNone then
      ColWidths[1] := ColWidths[1] + ScrollBarWidth;
    ScrollBars := ssNone;
  end;

  RowHeightsChanged;
end;
{=====}

procedure TO32CustomInspectorGrid.ChangeSize(NewColCount, NewRowCount: Integer);
var
  OldColCount, OldRowCount: Integer;
  OldDrawInfo: TGridDrawInfo;

  procedure MinRedraw(const OldInfo, NewInfo: TGridAxisDrawInfo; Axis: Integer);
  var
    R: TRect;
    First: Integer;
  begin
    First := Min(OldInfo.LastFullVisibleCell, NewInfo.LastFullVisibleCell);
    // Get the rectangle around the leftmost or topmost cell in the target range.
    R := CellRect(First and not Axis, First and Axis);
    R.Bottom := Height;
    R.Right := Width;
    Windows.InvalidateRect(Handle, @R, False);
  end;

  procedure DoChange;
  var
    Coord: TGridCoord;
    NewDrawInfo: TGridDrawInfo;
  begin
    if FColWidths <> nil then
      UpdateExtents(FColWidths, 2, 64{DefaultColWidth});
    if FTabStops <> nil then
      UpdateExtents(FTabStops, 2, Integer(True));
    if FRowHeights <> nil then
      UpdateExtents(FRowHeights, RowCount, DefaultRowHeight);
    Coord := FCurrent;
    if ActiveRow >= RowCount then Coord.Y := RowCount - 1;
    if Col >= 2 then Coord.X := 1;
    if (FCurrent.X <> Coord.X) or (FCurrent.Y <> Coord.Y) then
      MoveCurrent(Coord.X, Coord.Y, True, True);
    if (FAnchor.X <> Coord.X) or (FAnchor.Y <> Coord.Y) then
      MoveAnchor(Coord);
    if HandleAllocated then
    begin
      CalcDrawInfo(NewDrawInfo);
      MinRedraw(OldDrawInfo.Horz, NewDrawInfo.Horz, 0);
      MinRedraw(OldDrawInfo.Vert, NewDrawInfo.Vert, -1);
    end;
    UpdateScrollRange;
    SizeChanged(OldColCount, OldRowCount);
  end;

begin
  if HandleAllocated then
    CalcDrawInfo(OldDrawInfo);
  OldColCount := FColCount;
  OldRowCount := FRowCount;
  FColCount := NewColCount;
  FRowCount := NewRowCount;
  try
    DoChange;
  except
    { Could not change size so try to clean up by setting the size back }
    FColCount := OldColCount;
    FRowCount := OldRowCount;
    DoChange;
    InvalidateGrid;
    raise;
  end;
end;
{=====}

{ Will move TopLeft so that Coord is in view }
procedure TO32CustomInspectorGrid.ClampInView(const Coord: TGridCoord);
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;
  OldTopLeft: TGridCoord;
begin
  if not HandleAllocated then Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo, Coord do
  begin
    if (X > Horz.LastFullVisibleCell) or
      (Y > Vert.LastFullVisibleCell) or (X < 0) or (Y < TopRow) then
    begin
      OldTopLeft := FTopLeft;
      MaxTopLeft := CalcMaxTopLeft(Coord, DrawInfo);
      Update;
      if X < 0 then FTopLeft.X := X
      else if X > Horz.LastFullVisibleCell then FTopLeft.X := MaxTopLeft.X;
      if Y < TopRow then FTopLeft.Y := Y
      else if Y > Vert.LastFullVisibleCell then FTopLeft.Y := MaxTopLeft.Y;
      TopLeftMoved(OldTopLeft);
    end;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.DrawMove;
var
  OldPen: TPen;
  Pos: Integer;
  R: TRect;
begin
  OldPen := TPen.Create;
  try
    with Canvas do
    begin
      OldPen.Assign(Pen);
      try
        Pen.Style := psDot;
        Pen.Mode := pmXor;
        Pen.Width := 5;
        R := CellRect(FMovePos, 0);
        if FMovePos > FMoveIndex then
          Pos := R.Right
        else
          Pos := R.Left;
        MoveTo(Pos, 0);
        LineTo(Pos, ClientHeight);
      finally
        Canvas.Pen := OldPen;
      end;
    end;
  finally
    OldPen.Free;
  end;
end;
{=====}

{ - modified}
procedure TO32CustomInspectorGrid.FocusCell(ACol, ARow: Integer; MoveAnchor: Boolean);
begin
  UpdateCellContents;
  MoveCurrent(ACol, ARow, MoveAnchor, True);
  DestroyEditor;
  UpdateEdit;
  Click;
  if Assigned(FOnItemSelect) then
    FOnItemSelect(Self, ActiveItem);
end;
{=====}

{ - new}
procedure TO32CustomInspectorGrid.UpdateCellContents;
var
  OldStr: string;
  OldColor: TColor;
  Changed: Boolean;
begin
  Changed := false;
  if (FItems.VisibleItems.Count = 0) then exit;
  { Update the grid with the editor's contents }
  if FInPlaceEdit <> nil then begin
    case TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ItemType of
      itParent, itSet, itList, itString, itInteger, itFloat, itCurrency, itDate,
      itLogical:
      begin
        { Temporarily save the old value }
        OldStr := TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsString;
        { if the contents have been changed, then update the item }
        if OldStr <> GetEditorText then begin
          TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsString := GetEditorText;
          Changed := true;
        end;
      end;
      itColor:
      begin
        { Temporarily save the old color }
        OldColor := TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsColor;
        { if the color has changed then update the item }
        if (OldColor <> (FInplaceEdit as TO32GridColorCombo).SelectedColor)
        then begin
          TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsColor
            := (FInplaceEdit as TO32GridColorCombo).SelectedColor;
          Changed := true;
        end;
      end;
      itFont:
      begin
        OldStr := TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsFont.Name;
        if (OldStr <> (FInplaceEdit as TO32GridFontCombo).FontName) then begin
          TO32InspectorItem(FItems.VisibleItems[ActiveRow]).AsFont.Name
            := (FInplaceEdit as TO32GridFontCombo).FontName;
          Changed := true;
        end;
      end;
    end; {case}

    { Call the user-defined OnChange event }
    if Changed and Assigned(FOnItemChange) then
      FOnItemChange(Self, ActiveItem);

    if Changed and Assigned(FAfterEdit) then
      FAfterEdit(TO32InspectorItem(FItems.VisibleItems[ActiveRow]),
        TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Index);
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.GridRectToScreenRect(GridRect: TGridRect;
  var ScreenRect: TRect; IncludeLine: Boolean);

  function LinePos(const AxisInfo: TGridAxisDrawInfo; Line: Integer): Integer;
  var
    Start, I: Integer;
  begin
    with AxisInfo do
    begin
      Result := 0;
      if Line < FixedCellCount then
        Start := 0
      else
      begin
        if Line >= FirstGridCell then
          Result := FixedBoundary;
        Start := FirstGridCell;
      end;
      for I := Start to Line - 1 do
      begin
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
        if Result > GridExtent then
        begin
          Result := 0;
          Exit;
        end;
      end;
    end;
  end;

  function CalcAxis(const AxisInfo: TGridAxisDrawInfo;
    GridRectMin, GridRectMax: Integer;
    var ScreenRectMin, ScreenRectMax: Integer): Boolean;
  begin
    Result := False;
    with AxisInfo do
    begin
      if (GridRectMin >= FixedCellCount) and (GridRectMin < FirstGridCell) then
        if GridRectMax < FirstGridCell then
        begin
          FillChar(ScreenRect, SizeOf(ScreenRect), 0); { erase partial results }
          Exit;
        end
        else
          GridRectMin := FirstGridCell;
      if GridRectMax > LastFullVisibleCell then
      begin
        GridRectMax := LastFullVisibleCell;
        if GridRectMax < GridCellCount - 1 then Inc(GridRectMax);
        if LinePos(AxisInfo, GridRectMax) = 0 then
          Dec(GridRectMax);
      end;

      ScreenRectMin := LinePos(AxisInfo, GridRectMin);
      ScreenRectMax := LinePos(AxisInfo, GridRectMax);
      if ScreenRectMax = 0 then
        ScreenRectMax := ScreenRectMin + GetExtent(GridRectMin)
      else
        Inc(ScreenRectMax, GetExtent(GridRectMax));
      if ScreenRectMax > GridExtent then
        ScreenRectMax := GridExtent;
      if IncludeLine then Inc(ScreenRectMax, EffectiveLineWidth);
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
begin
  FillChar(ScreenRect, SizeOf(ScreenRect), 0);
  if (GridRect.Left > GridRect.Right) or (GridRect.Top > GridRect.Bottom) then
    Exit;
  CalcDrawInfo(DrawInfo);
  with DrawInfo do
  begin
    if GridRect.Left > Horz.LastFullVisibleCell + 1 then Exit;
    if GridRect.Top > Vert.LastFullVisibleCell + 1 then Exit;

    if CalcAxis(Horz, GridRect.Left, GridRect.Right, ScreenRect.Left,
      ScreenRect.Right) then
    begin
      CalcAxis(Vert, GridRect.Top, GridRect.Bottom, ScreenRect.Top,
        ScreenRect.Bottom);
    end;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.Initialize;
begin
  FTopLeft.X := 0;
  FTopLeft.Y := 0;
  FCurrent := FTopLeft;
  FAnchor := FCurrent;
  if goRowSelect in Options then FAnchor.X := 1;
end;
{=====}

procedure TO32CustomInspectorGrid.InvalidateCell(ACol, ARow: Integer);
var
  Rect: TGridRect;
begin
  Rect.Top := ARow;
  Rect.Left := ACol;
  Rect.Bottom := ARow;
  Rect.Right := ACol;
  InvalidateRect(Rect);
end;
{=====}

procedure TO32CustomInspectorGrid.InvalidateGrid;
begin
  Invalidate;
end;
{=====}

procedure TO32CustomInspectorGrid.InvalidateRect(ARect: TGridRect);
var
  InvalidRect: TRect;
begin
  if not HandleAllocated then Exit;
  GridRectToScreenRect(ARect, InvalidRect, True);
  Windows.InvalidateRect(Handle, @InvalidRect, False);
end;
{=====}

procedure TO32CustomInspectorGrid.ModifyScrollBar(ScrollBar, ScrollCode, Pos: Cardinal;
  UseRightToLeft: Boolean);
var
  NewTopLeft, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  RTLFactor: Integer;

  function MaxNum: Integer;
  begin
    if ScrollBar = SB_HORZ then Result := MaxTopLeft.X
    else Result := MaxTopLeft.Y;
  end;

  function PageUp: Integer;
  var
    MaxTopLeft: TGridCoord;
  begin
    MaxTopLeft := CalcMaxTopLeft(FTopLeft, DrawInfo);
    if ScrollBar = SB_HORZ then
      Result := FTopLeft.X - MaxTopLeft.X else
      Result := FTopLeft.Y - MaxTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function PageDown: Integer;
  var
    DrawInfo: TGridDrawInfo;
  begin
    CalcDrawInfo(DrawInfo);
    with DrawInfo do
      if ScrollBar = SB_HORZ then
        Result := Horz.LastFullVisibleCell - FTopLeft.X else
        Result := Vert.LastFullVisibleCell - FTopLeft.Y;
    if Result < 1 then Result := 1;
  end;

  function CalcScrollBar(Value, ARTLFactor: Integer): Integer;
  begin
    Result := Value;
    case ScrollCode of
      SB_LINEUP:
        Dec(Result, ARTLFactor);
      SB_LINEDOWN:
        Inc(Result, ARTLFactor);
      SB_PAGEUP:
        Dec(Result, PageUp * ARTLFactor);
      SB_PAGEDOWN:
        Inc(Result, PageDown * ARTLFactor);
      SB_THUMBPOSITION, SB_THUMBTRACK:
        if (goThumbTracking in Options) or (ScrollCode = SB_THUMBPOSITION) then
        begin
          if (ARTLFactor = 1) then
            Result := LongMulDiv(Pos, MaxNum, MaxShortInt)
          else
            Result := MaxNum - LongMulDiv(Pos, MaxNum, MaxShortInt);
        end;
      SB_BOTTOM:
        Result := MaxNum;
      SB_TOP:
        Result := 0;
    end;
  end;

  procedure ModifyPixelScrollBar(Code, Pos: Cardinal);
  var
    NewOffset: Integer;
    OldOffset: Integer;
    R: TGridRect;
    GridSpace, ColWidth: Integer;
  begin
    NewOffset := FColOffset;
    ColWidth := ColWidths[DrawInfo.Horz.FirstGridCell];
    GridSpace := ClientWidth - DrawInfo.Horz.FixedBoundary;
    case Code of
      SB_LINEUP: Dec(NewOffset, Canvas.TextWidth('0') * RTLFactor);
      SB_LINEDOWN: Inc(NewOffset, Canvas.TextWidth('0') * RTLFactor);
      SB_PAGEUP: Dec(NewOffset, GridSpace * RTLFactor);
      SB_PAGEDOWN: Inc(NewOffset, GridSpace * RTLFactor);
      SB_THUMBPOSITION,
      SB_THUMBTRACK:
        if (goThumbTracking in Options) or (Code = SB_THUMBPOSITION) then
        begin
          NewOffset := Pos
        end;
      SB_BOTTOM: NewOffset := 0;
      SB_TOP: NewOffset := ColWidth - GridSpace;
    end;
    if NewOffset < 0 then
      NewOffset := 0
    else if NewOffset >= ColWidth - GridSpace then
      NewOffset := ColWidth - GridSpace;
    if NewOffset <> FColOffset then
    begin
      OldOffset := FColOffset;
      FColOffset := NewOffset;
      ScrollData(OldOffset - NewOffset, 0);
      FillChar(R, SizeOf(R), 0);
      R.Bottom := FixedRows;
      InvalidateRect(R);
      Update;
      UpdateScrollPos;
    end;
  end;

var
  Temp: Integer;
begin
  RTLFactor := 1;
  if Visible and CanFocus and TabStop and not (csDesigning in ComponentState) then
    SetFocus;
  CalcDrawInfo(DrawInfo);
  MaxTopLeft.X := 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  NewTopLeft := FTopLeft;
  if ScrollBar = SB_HORZ then
    repeat
      Temp := NewTopLeft.X;
      NewTopLeft.X := CalcScrollBar(NewTopLeft.X, RTLFactor);
    until (NewTopLeft.X <= 0) or (NewTopLeft.X >= MaxTopLeft.X)
      or (ColWidths[NewTopLeft.X] > 0) or (Temp = NewTopLeft.X)
  else
    repeat
      Temp := NewTopLeft.Y;
      NewTopLeft.Y := CalcScrollBar(NewTopLeft.Y, 1);
    until (NewTopLeft.Y <= FixedRows) or (NewTopLeft.Y >= MaxTopLeft.Y)
      or (RowHeights[NewTopLeft.Y] > 0) or (Temp = NewTopLeft.Y);
  NewTopLeft.X := Math.Max(0, Math.Min(MaxTopLeft.X, NewTopLeft.X));
  NewTopLeft.Y := Math.Max(FixedRows, Math.Min(MaxTopLeft.Y, NewTopLeft.Y));
  if (NewTopLeft.X <> FTopLeft.X) or (NewTopLeft.Y <> FTopLeft.Y) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
end;
{=====}

procedure TO32CustomInspectorGrid.MoveAnchor(const NewAnchor: TGridCoord);
var
  OldSel: TGridRect;
begin
  if [goRangeSelect, goEditing] * Options = [goRangeSelect] then
  begin
    OldSel := Selection;
    FAnchor := NewAnchor;
    if goRowSelect in Options then
      FAnchor.X := 1;
    ClampInView(NewAnchor);
    SelectionMoved(OldSel);
  end
  else MoveCurrent(NewAnchor.X, NewAnchor.Y, True, True);
end;
{=====}

procedure TO32CustomInspectorGrid.MoveCurrent(ACol, ARow: Integer; MoveAnchor,
  Show: Boolean);
var
  OldSel: TGridRect;
  OldCurrent: TGridCoord;
begin
  if (ACol < 0) or (ARow < 0) or (ACol >= 2) or (ARow >= RowCount) then
    exit;
  if SelectCell(ACol, ARow) then
  begin
    OldSel := Selection;
    OldCurrent := FCurrent;
    FCurrent.X := ACol;
    FCurrent.Y := ARow;
    if MoveAnchor or not (goRangeSelect in Options) then
    begin
      FAnchor := FCurrent;
      FAnchor.X := 1;
    end;
    FCurrent.X := 0;
    if Show then ClampInView(FCurrent);
    SelectionMoved(OldSel);
    with OldCurrent do InvalidateCell(X, Y);
    with FCurrent do InvalidateCell(ACol, ARow);
    FActiveItem := FCurrent.Y;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.MoveTopLeft(ALeft, ATop: Integer);
var
  OldTopLeft: TGridCoord;
begin
  if (ALeft = FTopLeft.X) and (ATop = FTopLeft.Y) then Exit;
  Update;
  OldTopLeft := FTopLeft;
  FTopLeft.X := ALeft;
  FTopLeft.Y := ATop;
  TopLeftMoved(OldTopLeft);
end;
{=====}

procedure TO32CustomInspectorGrid.ResizeCol(Index: Integer; OldSize, NewSize: Integer);
begin
  InvalidateGrid;
end;
{=====}

procedure TO32CustomInspectorGrid.ResizeRow(Index: Integer; OldSize, NewSize: Integer);
begin
  InvalidateGrid;
end;
{=====}

procedure TO32CustomInspectorGrid.SelectionMoved(const OldSel: TGridRect);
var
  OldRect, NewRect: TRect;
  AXorRects: TXorRects;
  I: Integer;
begin
 if not HandleAllocated then Exit;
  GridRectToScreenRect(OldSel, OldRect, True);
  GridRectToScreenRect(Selection, NewRect, True);
  XorRects(OldRect, NewRect, AXorRects);
  for I := Low(AXorRects) to High(AXorRects) do
    Windows.InvalidateRect(Handle, @AXorRects[I], False);
end;
{=====}

procedure TO32CustomInspectorGrid.ScrollDataInfo(DX, DY: Integer;
  var DrawInfo: TGridDrawInfo);
var
  ScrollArea: TRect;
  ScrollFlags: Integer;
begin
  with DrawInfo do
  begin
    ScrollFlags := SW_INVALIDATE;
    if not DefaultDrawing then
      ScrollFlags := ScrollFlags or SW_ERASE;
    { Scroll the area }
    if DY = 0 then
    begin
      { Scroll both the column titles and data area at the same time }
      ScrollArea := Rect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.GridExtent);
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end
    else if DX = 0 then
    begin
      { Scroll both the row titles and data area at the same time }
      ScrollArea := Rect(0, Vert.FixedBoundary, Horz.GridExtent, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end
    else
    begin
      { Scroll titles and data area separately }
      { Column titles }
      ScrollArea := Rect(Horz.FixedBoundary, 0, Horz.GridExtent, Vert.FixedBoundary);
      ScrollWindowEx(Handle, DX, 0, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      { Row titles }
      ScrollArea := Rect(0, Vert.FixedBoundary, Horz.FixedBoundary, Vert.GridExtent);
      ScrollWindowEx(Handle, 0, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
      { Data area }
      ScrollArea := Rect(Horz.FixedBoundary, Vert.FixedBoundary, Horz.GridExtent,
        Vert.GridExtent);
      ScrollWindowEx(Handle, DX, DY, @ScrollArea, @ScrollArea, 0, nil, ScrollFlags);
    end;
  end;
  InvalidateRect(Selection);
end;
{=====}

procedure TO32CustomInspectorGrid.ScrollData(DX, DY: Integer);
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  ScrollDataInfo(DX, DY, DrawInfo);
end;
{=====}

procedure TO32CustomInspectorGrid.TopLeftMoved(const OldTopLeft: TGridCoord);

  function CalcScroll(const AxisInfo: TGridAxisDrawInfo;
    OldPos, CurrentPos: Integer; var Amount: Integer): Boolean;
  var
    Start, Stop: Integer;
    I: Integer;
  begin
    Result := False;
    with AxisInfo do
    begin
      if OldPos < CurrentPos then
      begin
        Start := OldPos;
        Stop := CurrentPos;
      end
      else
      begin
        Start := CurrentPos;
        Stop := OldPos;
      end;
      Amount := 0;
      for I := Start to Stop - 1 do
      begin
        Inc(Amount, GetExtent(I) + EffectiveLineWidth);
        if Amount > (GridBoundary - FixedBoundary) then
        begin
          { Scroll amount too big, redraw the whole thing }
          InvalidateGrid;
          Exit;
        end;
      end;
      if OldPos < CurrentPos then Amount := -Amount;
    end;
    Result := True;
  end;

var
  DrawInfo: TGridDrawInfo;
  Delta: TGridCoord;
begin
  UpdateScrollPos;
  CalcDrawInfo(DrawInfo);
  if CalcScroll(DrawInfo.Horz, OldTopLeft.X, FTopLeft.X, Delta.X) and
    CalcScroll(DrawInfo.Vert, OldTopLeft.Y, FTopLeft.Y, Delta.Y) then
    ScrollDataInfo(Delta.X, Delta.Y, DrawInfo);
  TopLeftChanged;
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateScrollPos;
var
  DrawInfo: TGridDrawInfo;
  MaxTopLeft: TGridCoord;
{  GridSpace, ColWidth: Integer;}

  procedure SetScroll(Code: Word; Value: Integer);
  begin
    if GetScrollPos(Handle, Code) <> Value then
      SetScrollPos(Handle, Code, Value, True);
  end;

begin
  if (not HandleAllocated) or (ScrollBars = ssNone) then Exit;
  CalcDrawInfo(DrawInfo);
  MaxTopLeft.X := 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  if ScrollBars in [ssHorizontal, ssBoth] then
    SetScroll(SB_HORZ, LongMulDiv(FTopLeft.X - 0, MaxShortInt,
      MaxTopLeft.X - 0));
  if ScrollBars in [ssVertical, ssBoth] then
    SetScroll(SB_VERT, LongMulDiv(FTopLeft.Y - 0, MaxShortInt,
      MaxTopLeft.Y - FixedRows));
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateScrollRange;
var
  MaxTopLeft, OldTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  OldScrollBars: TScrollStyle;
  Updated: Boolean;

  procedure DoUpdate;
  begin
    if not Updated then
    begin
      Update;
      Updated := True;
    end;
  end;

  function ScrollBarVisible(Code: Word): Boolean;
  var
    Min, Max: Integer;
  begin
    Result := False;
    if (ScrollBars = ssBoth) or
      ((Code = SB_HORZ) and (ScrollBars = ssHorizontal)) or
      ((Code = SB_VERT) and (ScrollBars = ssVertical)) then
    begin
      GetScrollRange(Handle, Code, Min, Max);
      Result := Min <> Max;
    end;
  end;

  procedure CalcSizeInfo;
  begin
    CalcDrawInfoXY(DrawInfo, DrawInfo.Horz.GridExtent, DrawInfo.Vert.GridExtent);
    MaxTopLeft.X := 1;
    MaxTopLeft.Y := RowCount - 1;
    MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  end;

  procedure SetAxisRange(var Max, Old, Current: Integer; Code: Word;
    Fixeds: Integer);
  begin
    CalcSizeInfo;
    if Fixeds < Max then
      SetScrollRange(Handle, Code, 0, MaxShortInt, True)
    else
      SetScrollRange(Handle, Code, 0, 0, True);
    if Old > Max then
    begin
      DoUpdate;
      Current := Max;
    end;
  end;

  procedure SetHorzRange;
{  var
    Range: Integer;}
  begin
    if OldScrollBars in [ssHorizontal, ssBoth] then
      SetAxisRange(MaxTopLeft.X, OldTopLeft.X, FTopLeft.X, SB_HORZ, 0);
  end;

  procedure SetVertRange;
  begin
    if OldScrollBars in [ssVertical, ssBoth] then
      SetAxisRange(MaxTopLeft.Y, OldTopLeft.Y, FTopLeft.Y, SB_VERT, 0);
  end;

begin
  if (ScrollBars = ssNone) or not HandleAllocated or not Showing then Exit;
  with DrawInfo do
  begin
    Horz.GridExtent := ClientWidth;
    Vert.GridExtent := ClientHeight;
    { Ignore scroll bars for initial calculation }
    if ScrollBarVisible(SB_HORZ) then
      Inc(Vert.GridExtent, GetSystemMetrics(SM_CYHSCROLL));
    if ScrollBarVisible(SB_VERT) then
      Inc(Horz.GridExtent, GetSystemMetrics(SM_CXVSCROLL));
  end;
  OldTopLeft := FTopLeft;
  { Temporarily mark us as not having scroll bars to avoid recursion }
  OldScrollBars := FScrollBars;
  FScrollBars := ssNone;
  Updated := False;
  try
    { Update scrollbars }
    SetHorzRange;
    DrawInfo.Vert.GridExtent := ClientHeight;
    SetVertRange;
    if DrawInfo.Horz.GridExtent <> ClientWidth then
    begin
      DrawInfo.Horz.GridExtent := ClientWidth;
      SetHorzRange;
    end;
  finally
    FScrollBars := OldScrollBars;
  end;
  UpdateScrollPos;
  if (FTopLeft.X <> OldTopLeft.X) or (FTopLeft.Y <> OldTopLeft.Y) then
    TopLeftMoved(OldTopLeft);
end;
{=====}

function TO32CustomInspectorGrid.CreateEditor: TWinControl;
begin
  Result := nil;

  if TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ReadOnly then
    Exit;

  if not (csDesigning in ComponentState) then
    case TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ItemType of
      { Don't edit Parents or Sets (Which are parents of a cluster of bools) }
      itParent, itSet:
        result := nil;

      { Combo Box }
      itList, itLogical: begin
        result := TO32GridCombo.Create(Parent);
        result.Parent := Parent;
        {result.Height := GetRowHeights(ActiveRow);}
        (result as TO32GridCombo).Color := FEditColor;
      end;

      { Mask Edit }
      itString, itInteger, itFloat, itCurrency, itDate: begin
        result := TO32GridEdit.Create(Self);
        (result as TO32GridEdit).Color := FEditColor;
      end;

      { Color Combo }
      itColor: begin
        result := TO32GridColorCombo.Create(Parent);
        result.Parent := Parent;
        {result.Height := GetRowHeights(ActiveRow);}
        (result as TO32GridColorCombo).Color := FEditColor;
      end;

      { FontCombo - Not implemented }
      itFont: begin
        result := TO32GridFontCombo.Create(Parent);
        result.Parent := Parent;
        {result.Height := GetRowHeights(ActiveRow);}
        (result as TO32GridFontCombo).Color := FEditColor;
      end;
    end;
end;
{=====}

procedure TO32CustomInspectorGrid.DestroyEditor;
begin
  if (FInPlaceEdit <> nil) then begin
    FInPlaceEdit.Free;
    FInPlaceEdit := nil;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP;
    if FScrollBars in [ssVertical, ssBoth] then
      Style := Style or WS_VSCROLL;
    if FScrollBars in [ssHorizontal, ssBoth] then
      Style := Style or WS_HSCROLL;
    WindowClass.style := CS_DBLCLKS;
    if FBorderStyle = bsSingle then begin
      if NewStyleControls and Ctl3D then begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or WS_EX_CLIENTEDGE;
      end else
        Style := Style or WS_BORDER;
    end;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewTopLeft, NewCurrent, MaxTopLeft: TGridCoord;
  DrawInfo: TGridDrawInfo;
  PageWidth, PageHeight: Integer;
  NeedsInvalidating: Boolean;

  procedure CalcPageExtents;
  begin
    CalcDrawInfo(DrawInfo);
    PageWidth := DrawInfo.Horz.LastFullVisibleCell - 0;
    if PageWidth < 1 then PageWidth := 1;
    PageHeight := DrawInfo.Vert.LastFullVisibleCell - TopRow;
    if PageHeight < 1 then PageHeight := 1;
  end;

  procedure Restrict(var Coord: TGridCoord; MinX, MinY, MaxX, MaxY: Integer);
  begin
    with Coord do
    begin
      if X > MaxX then X := MaxX
      else if X < MinX then X := MinX;
      if Y > MaxY then Y := MaxY
      else if Y < MinY then Y := MinY;
    end;
  end;

begin
  inherited KeyDown(Key, Shift);
  NeedsInvalidating := False;
  if not CanGridAcceptKey(Key, Shift) then Key := 0;

  NewCurrent := FCurrent;
  NewTopLeft := FTopLeft;
  CalcPageExtents;
  if ssCtrl in Shift then
    case Key of
      VK_UP: Dec(NewTopLeft.Y);
      VK_DOWN: Inc(NewTopLeft.Y);
      VK_PRIOR: NewCurrent.Y := TopRow;
      VK_NEXT: NewCurrent.Y := DrawInfo.Vert.LastFullVisibleCell;
      VK_HOME:
        begin
          NewCurrent.X := 0;
          NewCurrent.Y := 0;
          NeedsInvalidating := false;
        end;
      VK_END:
        begin
          NewCurrent.X := 1;
          NewCurrent.Y := RowCount - 1;
          NeedsInvalidating := false;
        end;
    end
  else
    case Key of
      VK_UP: begin
        Dec(NewCurrent.Y);
        if (ActiveItem = 0) then UpdateCellContents;
      end;
      VK_DOWN: begin
        Inc(NewCurrent.Y);
        if (ActiveItem = pred(ItemCount)) then UpdateCellContents;
      end;

      VK_LEFT:
        if TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Expanded then
          TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Collapse;
      VK_RIGHT:
        if (TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ChildCount > 0)
        and (not TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Expanded) then
          TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Expand;

      VK_NEXT:
        begin
          Inc(NewCurrent.Y, PageHeight);
          Inc(NewTopLeft.Y, PageHeight);
        end;
      VK_PRIOR:
        begin
          Dec(NewCurrent.Y, PageHeight);
          Dec(NewTopLeft.Y, PageHeight);
        end;
      VK_HOME: NewCurrent.Y := 0;
      VK_END: NewCurrent.Y := RowCount - 1;
      VK_TAB:
        if not (ssAlt in Shift) then
        repeat
          if ssShift in Shift then
          begin
            Dec(NewCurrent.X);
            if NewCurrent.X < 0 then
            begin
              NewCurrent.X := 1;
              Dec(NewCurrent.Y);
              if NewCurrent.Y < 0 then NewCurrent.Y := RowCount - 1;
            end;
            Shift := [];
          end
          else
          begin
            Inc(NewCurrent.X);
            if NewCurrent.X >= 2 then
            begin
              NewCurrent.X := 0;
              Inc(NewCurrent.Y);
              if NewCurrent.Y >= RowCount then NewCurrent.Y := 0;
            end;
          end;
        until TabStops[NewCurrent.X] or (NewCurrent.X = FCurrent.X);
      VK_F2: EditorMode := True;
    end;
  MaxTopLeft.X := 1;
  MaxTopLeft.Y := RowCount - 1;
  MaxTopLeft := CalcMaxTopLeft(MaxTopLeft, DrawInfo);
  Restrict(NewTopLeft, 0, 0, MaxTopLeft.X, MaxTopLeft.Y);
  if (NewTopLeft.X <> 0) or (NewTopLeft.Y <> TopRow) then
    MoveTopLeft(NewTopLeft.X, NewTopLeft.Y);
  Restrict(NewCurrent, 0, 0, 1, RowCount - 1);
  if (NewCurrent.X <> Col) or (NewCurrent.Y <> ActiveRow) then begin
    FocusCell(NewCurrent.X, NewCurrent.Y, not (ssShift in Shift));

    { Expand or collapse the node as required...}
    if FAutoExpand then
      TO32InspectorItem(FItems.VisibleItems[NewCurrent.Y]).Expand
  end;
  if NeedsInvalidating then Invalidate;
end;
{=====}

procedure TO32CustomInspectorGrid.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if not (goAlwaysShowEditor in Options) and (Key = #13) then
  begin
    if FEditorMode then
      HideEditor else
      ShowEditor;
    Key := #0;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.MouseDown(Button: TMouseButton;
                                            Shift: TShiftState; X, Y: Integer);
var
  CellHit: TGridCoord;
  DrawInfo: TGridDrawInfo;
  MoveDrawn: Boolean;
begin
  MoveDrawn := False;
  if not (csDesigning in ComponentState) and
    (CanFocus or (GetParentForm(Self) = nil)) then
  begin
    SetFocus;
    if not IsActiveControl then
    begin
      MouseCapture := False;
      Exit;
    end;
  end;
  if (Button = mbLeft) and (ssDouble in Shift) then begin
    CalcDrawInfo(DrawInfo);
    CalcSizingState(X, Y, FGridState, FSizingIndex, FSizingPos, FSizingOfs,
      DrawInfo);
    if FGridState <> gsNormal then Exit;
    CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
    if (CellHit.Y > -1) and (CellHit.Y < RowCount) then begin
      DblClick;
      if FItems.VisibleItems.Count > 0 then
        ExpandCollapse(ActiveRow);
    end;
  end
  else if Button = mbLeft then
  begin
    CalcDrawInfo(DrawInfo);
    CalcSizingState(X, Y, FGridState, FSizingIndex, FSizingPos, FSizingOfs,
      DrawInfo);
    if FGridState <> gsNormal then
      Exit;
    CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
    if (CellHit.Y > -1) and (CellHit.Y < RowCount) then
      FocusCell(CellHit.X, CellHit.Y, true);
    Click;
    { Expand or collapse the node as required...}
    if FAutoExpand
    and not TO32InspectorItem(FItems.VisibleItems[CellHit.Y]).Expanded
    then
      TO32InspectorItem(FItems.VisibleItems[CellHit.Y]).Expand
    else if (CellHit.X = 0) and (X < 14) then
      ExpandCollapse(CellHit.Y);
  end;
  try
    inherited MouseDown(Button, Shift, X, Y);
  except
    if MoveDrawn then DrawMove;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.ExpandCollapse(Index: Integer);
var
  Item: TO32InspectorItem;
begin
  Item := TO32InspectorItem(FItems.VisibleItems[Index]);
  if (Item.ItemType in [itParent, itSet]) then
  if Item.Expanded then
    Item.Collapse
  else if Item.ChildCount > 0 then
    Item.Expand;
end;
{=====}

procedure TO32CustomInspectorGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  DrawInfo: TGridDrawInfo;
  NewSize: Integer;
  DiffSize: Integer;
  Rect: TRect;

  function ResizeLine(const AxisInfo: TGridAxisDrawInfo): Integer;
  var
    I: Integer;
  begin
    with AxisInfo do
    begin
      Result := FixedBoundary;
      for I := FirstGridCell to FSizingIndex - 1 do
        Inc(Result, GetExtent(I) + EffectiveLineWidth);
      Result := FSizingPos - Result;
    end;
  end;

begin
 CalcDrawInfo(DrawInfo);
  case FGridState of
    gsColSizing:
      begin
        { Column sizing happens here...}

        { Prevent the columns from being dragged closed }
        if (X < 35) then
          X := 35
        else if (X > Width - 35) then
          X := Width - 35;

        { Adjust the column sizes }
        NewSize := ResizeLine(DrawInfo.Horz);
        FSizingPos := X + FSizingOfs;
        DiffSize := NewSize - ColWidths[0];
        ColWidths[0] := NewSize;
        ColWidths[1] := ColWidths[1] - DiffSize;

        { Update the designer }
        UpdateDesigner;

        { Update the InPlaceEditor }
        if not (csDesigning in ComponentState) then begin
          Rect := CellRect(1, ActiveRow);
          Rect.Top := Rect.Top + 1;
          AdjustEditor(Rect);
        end;
      end;
  end;
  inherited MouseMove(Shift, X, Y);
end;
{=====}

procedure TO32CustomInspectorGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  try
    case FGridState of
      gsSelecting:
        begin
          MouseMove(Shift, X, Y);
          KillTimer(Handle, 1);
          UpdateEdit;
          Click;
        end;
    else
      UpdateEdit;
    end;
    inherited MouseUp(Button, Shift, X, Y);
  finally
    FGridState := gsNormal;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.MoveAndScroll(Mouse, CellHit: Integer;
  var DrawInfo: TGridDrawInfo; var Axis: TGridAxisDrawInfo;
  ScrollBar: Integer; const MousePt: TPoint);
begin
  if (CellHit <> FMovePos) and
    not((FMovePos = Axis.FixedCellCount) and (Mouse < Axis.FixedBoundary)) and
    not((FMovePos = Axis.GridCellCount-1) and (Mouse > Axis.GridBoundary)) then
  begin
    DrawMove;   // hide the drag line
    if (Mouse < Axis.FixedBoundary) then
    begin
      if (FMovePos > Axis.FixedCellCount) then
      begin
        ModifyScrollbar(ScrollBar, SB_LINEUP, 0, False);
        Update;
        CalcDrawInfo(DrawInfo);    // this changes contents of Axis var
      end;
      CellHit := Axis.FirstGridCell;
    end
    else if (Mouse >= Axis.FullVisBoundary) then
    begin
      if (FMovePos = Axis.LastFullVisibleCell) and
        (FMovePos < Axis.GridCellCount -1) then
      begin
        ModifyScrollBar(Scrollbar, SB_LINEDOWN, 0, False);
        Update;
        CalcDrawInfo(DrawInfo);    // this changes contents of Axis var
      end;
      CellHit := Axis.LastFullVisibleCell;
    end
    else if CellHit < 0 then CellHit := FMovePos;
    if ((FGridState = gsColMoving) and CheckColumnDrag(FMoveIndex, CellHit, MousePt))
      or ((FGridState = gsRowMoving) and CheckRowDrag(FMoveIndex, CellHit, MousePt)) then
      FMovePos := CellHit;
    DrawMove;
  end;
end;
{=====}

function TO32CustomInspectorGrid.GetColWidths(Index: Integer): Integer;
begin
  if (FColWidths = nil) or (Index >= 2) then
    Result := 64{DefaultColWidth}
  else
    Result := PIntArray(FColWidths)^[Index + 1];
end;
{=====}

function TO32CustomInspectorGrid.GetItemCount: Integer;
begin
  result := FItems.Count;
end;
{=====}

function TO32CustomInspectorGrid.GetRowHeights(Index: Integer): Integer;
begin
  if (FRowHeights = nil) or (Index >= RowCount) then
    Result := DefaultRowHeight
  else
    Result := PIntArray(FRowHeights)^[Index + 1];
end;
{=====}

function TO32CustomInspectorGrid.GetGridWidth: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Horz.GridBoundary;
end;
{=====}

function TO32CustomInspectorGrid.GetGridHeight: Integer;
var
  DrawInfo: TGridDrawInfo;
begin
  CalcDrawInfo(DrawInfo);
  Result := DrawInfo.Vert.GridBoundary;
end;
{=====}

function TO32CustomInspectorGrid.GetSelection: TGridRect;
begin
  Result := GridRect(FCurrent, FAnchor);
end;
{=====}

function TO32CustomInspectorGrid.GetTabStops(Index: Integer): Boolean;
begin
  if FTabStops = nil then Result := True
  else Result := Boolean(PIntArray(FTabStops)^[Index + 1]);
end;
{=====}

function TO32CustomInspectorGrid.IsEditing: Boolean;
begin
  result := FInPlaceEdit <> nil;
end;
{=====}

procedure TO32CustomInspectorGrid.SetCol(Value: Integer);
begin
  if Col <> Value then FocusCell(Value, ActiveRow, True);
end;
{=====}

procedure TO32CustomInspectorGrid.SetColWidths(Index: Integer; Value: Integer);
begin
  if FColWidths = nil then
    UpdateExtents(FColWidths, 2, 64);
  if Index >= 2 then
    raise EInvalidGridOperation.Create(SIndexOutOfRange);
  if Value <> PIntArray(FColWidths)^[Index + 1] then
  begin
    ResizeCol(Index, PIntArray(FColWidths)^[Index + 1], Value);
    PIntArray(FColWidths)^[Index + 1] := Value;
    ColWidthsChanged;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetDefaultRowHeight(Value: Integer);
begin
  if FRowHeights <> nil then UpdateExtents(FRowHeights, 0, 0);
  if Value < 21 then
    FDefaultRowHeight := 19
  else
    FDefaultRowHeight := Value;
  RowHeightsChanged;
  InvalidateGrid;
end;
{=====}

procedure TO32CustomInspectorGrid.SetFixedRows(Value: Integer);
begin
  if FFixedRows <> Value then
  begin
    if Value < 0 then
      raise EInvalidGridOperation.Create(SIndexOutOfRange);
    if Value >= RowCount then
      raise EInvalidGridOperation.Create(SFixedRowTooBig);
    FFixedRows := Value;
    Initialize;
    InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditorMode(Value: Boolean);
begin
  if not Value then
    HideEditor
  else begin
    ShowEditor;
    if FInplaceEdit <> nil then
      DeselectEditor;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditColor(Value: TColor);
begin
  if FEditColor <> Value then begin
    FEditColor := Value;
    if FInPlaceEdit <> nil then FInPlaceEdit.Invalidate;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetExpandGlyph(Value: TBitmap);
begin
  if FExpandGlyph <> Value then begin
    FExpandGlyph.Assign(Value);
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetChildIndentation(Value: Word);
begin
  if Value <> FChildIndentation then begin
    FChildIndentation := Value;
    InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetOptions(Value: TGridOptions);
begin
  if FOptions <> Value then
  begin
    Exclude(Value, goAlwaysShowEditor);
    FOptions := Value;
    if not FEditorMode then HideEditor;
    MoveCurrent(Col, ActiveRow,  True, False);
    InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
  if FReadOnly
  then DestroyEditor
  else UpdateEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.SetRow(Value: Integer);
begin
  if ActiveRow <> Value then FocusCell(Col, Value, True);
end;
{=====}

procedure TO32CustomInspectorGrid.SetImageList(Value: TImageList);
begin
  if FImages <> Value then
    FImages := Value;
end;
{=====}

procedure TO32CustomInspectorGrid.SetRowCount(Value: Integer);
begin
  if FRowCount <> Value then
  begin
    ChangeSize(2, Value);
    CalcRowHeight;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetRowHeights(Index: Integer; Value: Integer);
begin
  if FRowHeights = nil then
    UpdateExtents(FRowHeights, RowCount, DefaultRowHeight);
  if Index >= RowCount then
    raise EInvalidGridOperation.Create(SIndexOutOfRange);
  if Value <> PIntArray(FRowHeights)^[Index + 1] then
  begin
    ResizeRow(Index, PIntArray(FRowHeights)^[Index + 1], Value);
    PIntArray(FRowHeights)^[Index + 1] := Value;
    RowHeightsChanged;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetSelection(Value: TGridRect);
var
  OldSel: TGridRect;
begin
  OldSel := Selection;
  FAnchor := Value.TopLeft;
  FCurrent := Value.BottomRight;
  SelectionMoved(OldSel);
end;
{=====}

procedure TO32CustomInspectorGrid.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then begin
    FSorted := Value;
    ItemVisibilityChanged;
    Invalidate;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetTabStops(Index: Integer; Value: Boolean);
begin
  if FTabStops = nil then
    UpdateExtents(FTabStops, 2, Integer(True));
  if Index >= 2 then
    raise EInvalidGridOperation.Create(SIndexOutOfRange);
  PIntArray(FTabStops)^[Index + 1] := Integer(Value);
end;
{=====}

procedure TO32CustomInspectorGrid.SetTopRow(Value: Integer);
begin
  if FTopLeft.Y <> Value then MoveTopLeft(0, Value);
end;
{=====}

procedure TO32CustomInspectorGrid.HideEdit;
begin
  if FInplaceEdit <> nil then
    try
      UpdateText;
    finally
      FInplaceCol := -1;
      FInplaceRow := -1;
      FInplaceEdit.Hide;
    end;
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateEdit;

  procedure UpdateEditor;
  begin
    FInplaceCol := 1;
    FInplaceRow := ActiveRow;
    UpdateEditContents;
    if EditorMaxLength = -1 then FCanEditModify := False
    else FCanEditModify := True;
    EditorSelectAll;
  end;

var
  Rect: TRect;
begin
  if CanEditShow then begin
    if Assigned(FBeforeEdit) then
      FBeforeEdit(TO32InspectorItem(FItems.VisibleItems[ActiveRow]),
        TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Index);

    if FInplaceEdit = nil then
    begin
      FInplaceEdit := CreateEditor;
      SetEditGrid(Self);
      FInplaceEdit.Parent := Self;
      UpdateEditor;
      Rect := CellRect(1, ActiveRow);
      Rect.Top := Rect.Top + 1;
      MoveEditor(Rect);
    end

    else begin
      if (ActiveRow <> FInplaceRow) then
      begin
        HideEdit;
        UpdateEditor;
        Rect := CellRect(1, ActiveRow);
        Rect.Top := Rect.Top + 1;
        MoveEditor(Rect);
      end;
    end;

(* - Moved to the UpdateCellContents method
    if Assigned(FAfterEdit) then
      FAfterEdit(TO32InspectorItem(FItems.VisibleItems[ActiveRow]),
        TO32InspectorItem(FItems.VisibleItems[ActiveRow]).Index);
*)
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateText;
begin
  if (FInplaceCol <> -1) and (FInplaceRow <> -1) then
    SetEditText(FInplaceCol, FInplaceRow, GetEditorText);
end;

{=====}
procedure TO32CustomInspectorGrid.WMChar(var Msg: TWMChar);
begin
  if (goEditing in Options) and CharInSet(Char(Msg.CharCode), [^H, #32..#255]) then
    ShowEditorChar(Char(Msg.CharCode))
  else
    inherited;
end;
{=====}

procedure TO32CustomInspectorGrid.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
 Msg.Result := DLGC_WANTARROWS;
end;
{=====}

procedure TO32CustomInspectorGrid.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  InvalidateRect(Selection);
  if (FInplaceEdit <> nil) and (Msg.FocusedWnd <> FInplaceEdit.Handle) then
    HideEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.WMLButtonDown(var Message: TMessage);
begin
  inherited;
  if FInplaceEdit <> nil then SetEditClickTime(GetMessageTime);
end;
{=====}

procedure TO32CustomInspectorGrid.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  DefaultHandler(Msg);
  FHitTest := ScreenToClient(SmallPointToPoint(Msg.Pos));
end;
{=====}

procedure TO32CustomInspectorGrid.WMSetCursor(var Msg: TWMSetCursor);
var
  DrawInfo: TGridDrawInfo;
  State: TGridState;
  Index: Integer;
  Pos, Ofs: Integer;
  Cur: HCURSOR;
begin
  Cur := 0;
  with Msg do
  begin
    if HitTest = HTCLIENT then
    begin
      if FGridState = gsNormal then
      begin
        CalcDrawInfo(DrawInfo);
        CalcSizingState(FHitTest.X, FHitTest.Y, State, Index, Pos, Ofs,
          DrawInfo);
      end else State := FGridState;
      if State = gsRowSizing then
        Cur := Screen.Cursors[crVSplit]
      else if State = gsColSizing then
        Cur := Screen.Cursors[crHSplit]
    end;
  end;
  if Cur <> 0 then SetCursor(Cur)
  else inherited;
end;
{=====}

procedure TO32CustomInspectorGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  if (FInplaceEdit = nil) or (Msg.FocusedWnd <> FInplaceEdit.Handle) then
  begin
    InvalidateRect(Selection);
    UpdateEdit;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.WMSize(var Msg: TWMSize);
var
  Rect: TRect;
begin
  inherited;
  SetColWidths(0, (Width - 4) div 2);
  SetCOlWidths(1, (Width - 4) div 2);

  Rect := CellRect(1, ActiveRow);
  Rect.Top := Rect.Top + 1;
  MoveEditor(Rect);

  UpdateScrollRange;
end;
{=====}

procedure TO32CustomInspectorGrid.WMVScroll(var Msg: TWMVScroll);
begin
  ModifyScrollBar(SB_VERT, Msg.ScrollCode, Msg.Pos, True);
end;
{=====}

function TO32CustomInspectorGrid.ParentTypeCount: Integer;
var
  I: Integer;
  Item: TO32InspectorItem;
begin
  Result := 0;
  for I := 0 to Pred(FItems.Count) do begin
    Item := TO32InspectorItem(FItems.Items[I]);
    if (Item.ItemType in [itParent, itSet]) then
      Inc(Result);
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.WMHScroll(var Msg: TWMHScroll);
begin
  ModifyScrollBar(SB_HORZ, Msg.ScrollCode, Msg.Pos, True);
end;
{=====}

procedure TO32CustomInspectorGrid.CancelMode;
var
  DrawInfo: TGridDrawInfo;
begin
 try
    case FGridState of
      gsSelecting:
        KillTimer(Handle, 1);
      gsRowSizing, gsColSizing:
        begin
          CalcDrawInfo(DrawInfo);
        end;
      gsColMoving, gsRowMoving:
        begin
          DrawMove;
          KillTimer(Handle, 1);
        end;
    end;
  finally
    FGridState := gsNormal;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.WMCancelMode(var Msg: TWMCancelMode);
begin
  inherited;
  CancelMode;
end;
{=====}

procedure TO32CustomInspectorGrid.CMCancelMode(var Msg: TMessage);
begin
  if Assigned(FInplaceEdit) then SetEditWndProc(Msg);
  inherited;
  CancelMode;
end;
{=====}

procedure TO32CustomInspectorGrid.CMFontChanged(var Message: TMessage);
begin
  if FInplaceEdit <> nil then SetEditFont(Font);

  DefaultRowHeight := Canvas.TextHeight(GetOrphStr(SCTallLowChars))
    + TextMargin * 2;

  { For now I have to use the wrapped up Windows combo box for which I have   }
  { no control over the height or borders.  For now, we will force minimum    }
  { RowHeight to 21 which is the height of a standard combo box.              }
  if DefaultRowHeight < 21 then DefaultRowHeight := 19;
  { Later I plan on creating a new combo box from scratch and replacing these }
  { combo boxes with descendants of the new one.                              }

  inherited;
end;
{=====}

procedure TO32CustomInspectorGrid.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;
{=====}

procedure TO32CustomInspectorGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  Msg.Result := NativeInt(BOOL(Sizing(Msg.Pos.X, Msg.Pos.Y)));
end;
{=====}

procedure TO32CustomInspectorGrid.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (goEditing in Options) and (Char(Msg.CharCode) = #13) then Msg.Result := 1;
end;
{=====}

procedure TO32CustomInspectorGrid.TimedScroll(Direction: TGridScrollDirection);
var
  MaxAnchor, NewAnchor: TGridCoord;
begin
  NewAnchor := FAnchor;
  MaxAnchor.X := 1;
  MaxAnchor.Y := RowCount - 1;
  if (sdLeft in Direction) and (FAnchor.X > 0) then Dec(NewAnchor.X);
  if (sdRight in Direction) and (FAnchor.X < MaxAnchor.X) then Inc(NewAnchor.X);
  if (sdUp in Direction) and (FAnchor.Y > 0) then Dec(NewAnchor.Y);
  if (sdDown in Direction) and (FAnchor.Y < MaxAnchor.Y) then Inc(NewAnchor.Y);
  if (FAnchor.X <> NewAnchor.X) or (FAnchor.Y <> NewAnchor.Y) then
    MoveAnchor(NewAnchor);
end;
{=====}

procedure TO32CustomInspectorGrid.WMTimer(var Msg: TWMTimer);
var
  Point: TPoint;
  DrawInfo: TGridDrawInfo;
  ScrollDirection: TGridScrollDirection;
  CellHit: TGridCoord;
begin
  if not (FGridState in [gsSelecting, gsRowMoving, gsColMoving]) then Exit;
  GetCursorPos(Point);
  Point := ScreenToClient(Point);
  CalcDrawInfo(DrawInfo);
  ScrollDirection := [];
  with DrawInfo do
  begin
    CellHit := CalcCoordFromPoint(Point.X, Point.Y, DrawInfo);
    case FGridState of
      gsColMoving:
        MoveAndScroll(Point.X, CellHit.X, DrawInfo, Horz, SB_HORZ, Point);
      gsRowMoving:
        MoveAndScroll(Point.Y, CellHit.Y, DrawInfo, Vert, SB_VERT, Point);
      gsSelecting:
      begin
        if Point.X < Horz.FixedBoundary then Include(ScrollDirection, sdLeft)
        else if Point.X > Horz.FullVisBoundary then Include(ScrollDirection, sdRight);
        if Point.Y < Vert.FixedBoundary then Include(ScrollDirection, sdUp)
        else if Point.Y > Vert.FullVisBoundary then Include(ScrollDirection, sdDown);
        if ScrollDirection <> [] then  TimedScroll(ScrollDirection);
      end;
    end;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.ColWidthsChanged;
begin
  UpdateScrollRange;
  UpdateEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.RowHeightsChanged;
begin
  UpdateScrollRange;
  UpdateEdit;
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateDesigner;
var
  ParentForm: TCustomForm;
begin
  if (csDesigning in ComponentState) and HandleAllocated and
    not (csUpdating in ComponentState) then
  begin
    ParentForm := GetParentForm(Self);
    if Assigned(ParentForm) and Assigned(ParentForm.Designer) then
      ParentForm.Designer.Modified;
  end;
end;
{=====}

function TO32CustomInspectorGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if not Result then
  begin
    if ActiveRow < RowCount - 1 then
      FocusCell(1, ActiveRow + 1, true);
    Result := True;
  end;
end;
{=====}

function TO32CustomInspectorGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if not Result then
  begin
    if ActiveRow > 0 then
      FocusCell(1, ActiveRow - 1, true);
    Result := True;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.DoOnExpand(Index: Integer);
begin
  if Assigned(FOnExpand) then
    FOnExpand(self, Index);
end;
{=====}

procedure TO32CustomInspectorGrid.DoOnCollapse(Index: Integer);
begin
  if Assigned(FOnCollapse) then
    FOnCollapse(self, Index);
end;
{=====}

procedure TO32CustomInspectorGrid.WMMouseWheel(var Msg : TMessage);
var
  Delta: integer;
begin
  Delta := TWMMouseWheel(Msg).WheelDelta;
   if Delta < 0 then begin
     if (ActiveRow < RowCount - 1) then
       FocusCell(1, ActiveRow + 1, true);
   end
   else if (ActiveRow > 0) then
     FocusCell(1, ActiveRow - 1, true);
end;
{=====}

function TO32CustomInspectorGrid.CheckColumnDrag(var Origin,
  Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.CheckRowDrag(var Origin,
  Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.BeginColumnDrag(var Origin, Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.BeginRowDrag(var Origin, Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.EndColumnDrag(var Origin, Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

function TO32CustomInspectorGrid.EndRowDrag(var Origin, Destination: Integer; const MousePt: TPoint): Boolean;
begin
  Result := True;
end;
{=====}

procedure TO32CustomInspectorGrid.CMShowingChanged(var Message: TMessage);
begin
  inherited;
  if Showing then UpdateScrollRange;
end;
{=====}

function TO32CustomInspectorGrid.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32CustomInspectorGrid.SetAbout(const Value : string);
begin

  { leave empty }
end;
{=====}

procedure TO32CustomInspectorGrid.SetFont(const Value: TFont);
begin
  if FFont <> Value then begin
    FFont.Assign(Value);
    CalcRowHeight;
    if not (csLoading in ComponentState) then
      InvalidateGrid;
  end;
end;
{=====}

function TO32CustomInspectorGrid.GetCells(ACol, ARow: Integer): string;
begin
  if ACol = 0 then
    result := TO32InspectorItem(FItems.VisibleItems[ARow]).Caption
  else
    result := TO32InspectorItem(FItems.VisibleItems[ARow]).AsString;
end;
{=====}

procedure TO32CustomInspectorGrid.SetCells(ACol, ARow: Integer;
  const Value: string);
begin
  if ACol = 0 then
      TO32InspectorItem(FItems.VisibleItems[ARow]).Caption := Value
  else
    TO32InspectorItem(FItems.VisibleItems[ARow]).AsString := Value;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditCellColor(const Value: TColor);
begin
  if FEditCellColor <> Value then begin
    FEditCellColor := Value;
    if FInPlaceEdit <> nil then FInPlaceEdit.Invalidate;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetActiveItem(const Value: integer);
begin
  { Programatic Selection }
  if FActiveItem <> Value then begin
    FocusCell(0, Value, true);
  end;
end;
{=====}

function TO32CustomInspectorGrid.GetItems(Index: Integer): TO32InspectorItem;
begin
  result := TO32InspectorItem(FItems.Items[Index]);
end;
{=====}

function TO32CustomInspectorGrid.GetSelectedItem: TO32InspectorItem;
begin
  if FItems.VisibleItems.Count >0 then
    result := TO32InspectorItem(FItems.VisibleItems[ActiveRow])
  else
    result := nil;
end;
{=====}

function TO32CustomInspectorGrid.Add(ItemType: TO32IGridItemType;
  Parent: TO32InspectorItem): TO32InspectorItem;
begin
  result := FItems.AddItem(ItemType, Parent);
end;
{=====}

function TO32CustomInspectorGrid.Insert(ItemType: TO32IGridItemType;
  Parent: TO32InspectorItem; Index: Word): TO32InspectorItem;
begin

  result := FItems.InsertItem(ItemType, Parent, Index);
end;
{=====}

procedure TO32CustomInspectorGrid.Delete(Index: Word);
var
  AllowIt: Boolean;
begin

  if Assigned(FOnDelete) then begin
    FOnDelete(TO32InspectorItem(FItems[Index]), Index, AllowIt);
    if not AllowIt then Exit;
  end;

  if (FItems.Count > 0) and (Index < FItems.Count) then
      FItems.Delete(Index);
end;
{=====}

procedure TO32CustomInspectorGrid.BeginUpdate;
begin
  Inc(FUpdatingIndex);
end;
{=====}

procedure TO32CustomInspectorGrid.EndUpdate;
begin
  Dec(FUpdatingIndex);
end;
{=====}

procedure TO32CustomInspectorGrid.ExpandAll;
var
  I: Integer;
begin
  BeginUpdate;
  for I := FItems.VisibleItems.Count - 1 downto 0 do begin
    if TO32InspectorItem(FItems.VisibleItems[I]).FType in [itParent, itSet]
    then TO32InspectorItem(FItems.VisibleItems[I]).Expand;
  end;
  EndUpdate;
end;
{=====}

procedure TO32CustomInspectorGrid.CollapseAll;
var
  I: Integer;
begin
  BeginUpdate;
  for I := FItems.VisibleItems.Count - 1 downto 0 do begin
    if TO32InspectorItem(FItems.VisibleItems[I]).FType in [itParent, itSet]
    then TO32InspectorItem(FItems.VisibleItems[I]).Collapse;
  end;
  EndUpdate;
end;
{=====}


function TO32CustomInspectorGrid.GetItemAt(X, Y: Integer): TO32InspectorItem;
var
  DrawInfo: TGridDrawInfo;
  CellHit: TGridCoord;
begin
  CalcDrawInfo(DrawInfo);
  CalcSizingState(X, Y, FGridState, FSizingIndex, FSizingPos, FSizingOfs,
    DrawInfo);
  CellHit := CalcCoordFromPoint(X, Y, DrawInfo);
  if (CellHit.Y > -1) and (CellHit.Y < RowCount) then
    result := TO32InspectorItem(FItems.VisibleItems[CellHit.Y])
  else
    result := nil;
end;
{=====}

procedure TO32CustomInspectorGrid.ItemChanged(Item: TO32InspectorItem);
begin
  { Forcibly update the editor contents in the event that the cell is being }
  { edited when the underlying value is changed... }
  if FItems.VisibleItems.Count > 0 then
    if (Item = TO32InspectorItem(FItems.VisibleItems[ActiveRow]))
    and (FInplaceEdit <> nil) then
      UpdateEditContents;
  { Invalidate the Grid }
  InvalidateGrid;
end;
{=====}

procedure TO32CustomInspectorGrid.ItemVisibilityChanged;
begin
{ - changed}
  if (csLoading in ComponentState) or (csDestroying in ComponentState) then
    Exit;

  DestroyEditor;
  FItems.LoadVisibleItems;

  if (FItems.VisibleItems.Count > 0)
  and (ActiveRow > FItems.VisibleItems.Count - 1)
  then ActiveRow := FItems.VisibleItems.Count - 1;

  SetRowCount(FItems.VisibleItems.Count);
  InvalidateGrid;
end;
{=====}

procedure TO32CustomInspectorGrid.UpdateEditorLocation;
begin

  if not EditorMatchesType(ActiveRow) then
    DestroyEditor;

  { edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).UpdateLoc(CellRect(Col, ActiveRow))

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).UpdateLoc(CellRect(Col, ActiveRow))

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).UpdateLoc(CellRect(Col, ActiveRow))

  { font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).UpdateLoc(CellRect(Col, ActiveRow));
end;
{=====}

procedure TO32CustomInspectorGrid.MoveEditor(ARect: TRect);
begin


  if (FInplaceEdit is TO32GridEdit) then begin
    { Stick the edit box in the target cell }
    (FInplaceEdit as TO32GridEdit).Text := GetEditText(1, ActiveRow);
    (FInplaceEdit as TO32GridEdit).Move(ARect);
  end

  else if (FInplaceEdit is TO32GridCombo) then begin
    { Load ComboBox Items }
    (FInplaceEdit as TO32GridCombo).Items.Assign(
      TO32InspectorItem(FItems.VisibleItems[ActiveRow]).ItemsList);
    { Set the active item }
    (FInplaceEdit as TO32GridCombo).ItemIndex :=
      (FInplaceEdit as TO32GridCombo).Items.IndexOf(GetEditText(1, ActiveRow));
    { Stick the ComboBox in the target cell }
    (FInplaceEdit as TO32GridCombo).Move(ARect);
  end

  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).Move(ARect)

  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).Move(ARect);

end;
{=====}

procedure TO32CustomInspectorGrid.AdjustEditor(ARect: TRect);
begin

  if (FInplaceEdit is TO32GridEdit) then begin
    (FInplaceEdit as TO32GridEdit).Width := ARect.Right - ARect.Left;
    (FInplaceEdit as TO32GridEdit).Left := ARect.Left;
    FInplaceEdit.Invalidate;
  end

  else if (FInplaceEdit is TO32GridCombo) then begin
    (FInplaceEdit as TO32GridCombo).Width := ARect.Right - ARect.Left;
    (FInplaceEdit as TO32GridCombo).Left := ARect.Left;
    FInplaceEdit.Invalidate;
  end

  else if (FInplaceEdit is TO32GridColorCombo) then begin
    (FInplaceEdit as TO32GridColorCombo).Width := ARect.Right - ARect.Left;
    (FInplaceEdit as TO32GridColorCombo).Left := ARect.Left;
    FInplaceEdit.Invalidate;
  end

  else if (FInplaceEdit is TO32GridFontCombo) then begin
    (FInplaceEdit as TO32GridFontCombo).Width := ARect.Right - ARect.Left;
    (FInplaceEdit as TO32GridFontCombo).Left := ARect.Left;
    FInplaceEdit.Invalidate;
  end;

end;
{=====}

procedure TO32CustomInspectorGrid.DeselectEditor;
begin
  { edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).Deselect

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).Deselect

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).Deselect

  { font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).Deselect;

end;
{=====}

procedure TO32CustomInspectorGrid.UpdateEditContents;
begin
  { regular old edit field }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).UpdateContents

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).UpdateContents

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).UpdateContents

  { font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).UpdateContents;
end;
{=====}

function TO32CustomInspectorGrid.EditorMaxLength: Integer;
begin
  result := 0;
  if (FInplaceEdit is TO32GridEdit) then
    result := (FInplaceEdit as TO32GridEdit).MaxLength
  else if (FInplaceEdit is TO32GridCombo) then
    result := (FInplaceEdit as TO32GridCombo).MaxLength;
end;
{=====}

procedure TO32CustomInspectorGrid.EditorSelectAll;
begin
  { edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).SelectAll

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).SelectAll

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).SelectAll

  { font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).SelectAll;

end;
{=====}

procedure TO32CustomInspectorGrid.SetEditGrid(AGrid: TO32CustomInspectorGrid);
begin
  { Plain old edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).SetGrid(AGrid)

  { Combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).SetGrid(AGrid)

  { Color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).SetGrid(AGrid)

  { Font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).SetGrid(AGrid);

end;
{=====}

function TO32CustomInspectorGrid.GetEditorText: string;
begin
  result := '';
  if (FInplaceEdit is TO32GridEdit) then
    result := (FInplaceEdit as TO32GridEdit).Text

  else if (FInplaceEdit is TO32GridCombo) then
    result := (FInplaceEdit as TO32GridCombo).Text

  else if (FInplaceEdit is TO32GridFontCombo) then
    result := (FInplaceEdit as TO32GridFontCombo).Text;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditClickTime(Value: Integer);
begin
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).FClickTime := Value
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).FClickTime := Value;
end;
{=====}

procedure TO32CustomInspectorGrid.SetEditWndProc(Msg: TMessage);
begin
  { edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).WndProc(Msg)

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).WndProc(Msg)

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).WndProc(Msg)

  { Font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).WndProc(Msg);

end;
{=====}

procedure TO32CustomInspectorGrid.SetEditFont(Font: TFont);
begin
  { edit }
  if (FInplaceEdit is TO32GridEdit) then
    (FInplaceEdit as TO32GridEdit).Font.Assign(Font)

  { combo box }
  else if (FInplaceEdit is TO32GridCombo) then
    (FInplaceEdit as TO32GridCombo).Font.Assign(Font)

  { color combo box }
  else if (FInplaceEdit is TO32GridColorCombo) then
    (FInplaceEdit as TO32GridColorCombo).Font.Assign(Font)

  { font combo box }
  else if (FInplaceEdit is TO32GridFontCombo) then
    (FInplaceEdit as TO32GridFontCombo).Font.Assign(Font);
end;
{=====}

function TO32CustomInspectorGrid.EditorMatchesType(Index: Integer): Boolean;
begin
  result := false;
  case TO32InspectorItem(FItems.VisibleItems[Index]).ItemType of
    { There should be no editor for parent and set types }
    itParent, itSet:  result := (FInplaceEdit = nil);

    { Combo Box }
    itList, itLogical:
      result := (FInPlaceEdit is TO32GridCombo);

    { Mask Edit }
    itString, itInteger, itFloat, itCurrency, itDate:
      result := (FInPlaceEdit is TO32GridEdit);

    { Color Combo }
    itColor:
      result := (FInPlaceEdit is TO32GridColorCombo);

    { FontCombo }
    itFont:
      result := (FInPlaceEdit is TO32GridFontCombo);
  end
end;
{=====}

procedure TO32CustomInspectorGrid.SetGridLineColor(const Value: TColor);
begin
  if FGridLineColor <> Value then begin
     FGridLineColor := Value;
     InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetCaptionTextColor(const Value: TColor);
begin
  if FCaptionTextColor <> Value then begin
    FCaptionTextColor := Value;
    InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.SetItemTextColor(const Value: TColor);
begin
  if FItemTextColor <> Value then begin
    FItemTextColor := Value;
    InvalidateGrid;
  end;
end;
{=====}

procedure TO32CustomInspectorGrid.Loaded;
var
  I: Integer;
  ParentIndex: Integer;
begin
  inherited;
  FItems.LoadVisibleItems;
  SetRowCount(FItems.VisibleItems.Count);
  for I := 0 to FItems.Count - 1 do begin
    ParentIndex := (FItems[I] as TO32InspectorItem).ParentIndex;
    if ParentIndex > -1 then begin
      TO32InspectorItem(FItems[I]).FParent
        := TO32InspectorItem(FItems[ParentIndex]);
      TO32InspectorItem(FItems[I]).FLevel
        := TO32InspectorItem(FItems[ParentIndex]).FLevel + 1;
    end;
  end;
  ItemVisibilityChanged;
end;

end.


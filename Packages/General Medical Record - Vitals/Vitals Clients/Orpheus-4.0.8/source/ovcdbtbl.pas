{*********************************************************}
{*                  OVCDBTBL.PAS 4.00                    *}
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
{* Roman Kassebaum                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdbtbl;
  {data-aware table}

interface

{$I ovc.inc}

uses
  Windows, Buttons, Classes, Controls, DB, Forms, Graphics, Menus, Messages, SysUtils,
  StdCtrls, OvcBase, OvcCmd, OvcConst, OvcData, OvcExcpt, OvcMisc, OvcTCBEF, OvcTCell,
  OvcTBClr, OvcTBCls, OvcTCmmn, OvcTGPns, OvcDate, UITypes;

type
  {data-aware table options}
  TOvcDbTableOptions = (dtoCellsPaintText, dtoAllowColumnMove,
    dtoAllowColumnSize, dtoAlwaysEditing, dtoHighlightActiveRow,
    dtoIntegralHeight, dtoEnterToTab, dtoPageScroll,
    dtoShowIndicators, dtoShowPictures, dtoStretch, dtoWantTabs,
    dtoWrapAtEnds);
  TOvcDbTableOptionSet = set of TOvcDbTableOptions;

  {header options}
  TOvcHeaderOptions = (hoShowHeader, hoUseHeaderCell, hoUseLetters, hoUseStrings);
  TOvcHeaderOptionSet = set of TOvcHeaderOptions;

  {date or time edit options for datetime fields}
  TDateOrTime = (dtUseDate, dtUseTime);

type
  TOvcCustomDbTable = class;

  TOvcDbTableDataLink = class(TDataLink)
  protected {private }
    {property variables}
    FFieldCount   : Integer;
    FFieldMap     : Pointer;
    FFieldMapSize : Integer;
    FInUpdateData : Boolean;
    FMapBuilt     : Boolean;
    FModified     : Boolean;
    FTable        : TOvcCustomDbTable;

    {property methods}
    function GetDefaultFields : Boolean;
    function GetFields(Index : Integer) : TField;

  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance : Integer); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field : TField); override;
    procedure UpdateData; override;

  public
    constructor Create(ATable : TOvcCustomDbTable);
    destructor Destroy; override;

    function AddMapping(const FieldName : string) : Boolean;
    procedure ClearFieldMappings;
    procedure Modified;
    procedure Reset;

    {properties}
    property DefaultFields : Boolean read GetDefaultFields;
    property FieldCount : Integer read FFieldCount;
    property Fields[Index : Integer] : TField read GetFields;
  end;


  TOvcDbTableColumn = class(TOvcTableColumn)
  protected {private}
    {properties}
    FDataField    : string;      {database field name}
    FDateOrTime   : TDateOrTime; {which part of DateTime fields to edit}
    FField        : TField;      {database field object}
    FOffset       : Integer;     {X-Offset to left edge}
    {property methods}
    function GetField : TField;
    function GetTable : TOvcCustomDbTable;
    procedure SetDataField(const Value : string);
    procedure SetDateOrTime(Value : TDateOrTime);
    procedure SetField(Value : TField);
  public
    procedure Assign(Source : TPersistent);
      override;
    constructor Create(ATable : TOvcTableAncestor);
      override;
    {properties}
    property Field : TField
      read GetField write SetField;
    property Offset : Integer
      read FOffset write FOffset;
    property Table : TOvcCustomDbTable
      read GetTable;
  published
    property DataField : string
      read FDataField write SetDataField;
    property DateOrTime : TDateOrTime
      read FDateOrTime write SetDateOrTime;
  end;


  TOvcVisibleColumns = class(TObject)
  protected {private}
    {property variables}
    FList      : TList;             {mapping of visible column numbers}
    FRightEdge : Integer;           {right edge of last visible column}
    FTable     : TOvcCustomDbTable; {owning table}
    {property methods}
    function GetColumn(Index : Integer) : TOvcDbTableColumn;
    function GetCount : Integer;
  public
    constructor Create(ATable : TOvcCustomDbTable);
    destructor Destroy; override;
    function IndexOf(ColNum : Integer) : Integer;
    procedure Add(ColNum : Integer);
    procedure Clear;
    procedure Delete(Index : Integer);
    procedure Exchange(Index1, Index2 : Integer);
    procedure Insert(Index, ColNum : Integer);
    procedure Move(Index1, Index2 : Integer);
    property Column[Index: Integer]: TOvcDbTableColumn read GetColumn; default;
    property Count : Integer read GetCount;
    property RightEdge : Integer read FRightEdge write FRightEdge;
  end;
  TOvcColumnMovedEvent =
    procedure(Sender : TObject; FromCol, ToCol : Integer) of object;


  TOvcCustomDbTable = class(TOvcTableAncestor)
  protected {private}
    {property variables}
    FAccess              : TOvcTblAccess;       {default access mode for the table}
    FActiveColumn        : Integer;             {active table column}
    FActiveRow           : Integer;             {active table row}
    FAdjust              : TOvcTblAdjust;       {default adjustment for the table}
    FBorderStyle         : TBorderStyle;        {border type around table}
    FColors              : TOvcTableColors;     {table cell colors}
    FColorUnused         : TColor;              {color of unused area}
    FColumns             : TOvcTableColumns;    {table column definitions}
    FDataLink            : TOvcDbTableDataLink; {link to db data fields}
    FDefaultMargin       : Integer;             {default cell margin}
    FGridPenSet          : TOvcGridPenSet;      {set of grid pens}
    FHeaderCell          : TOvcBaseTableCell;   {cell for column headings}
    FHeaderHeight        : Integer;             {height of the header row}
    FHeaderOptions       : TOvcHeaderOptionSet; {options for the header}
    FLeftColumn          : Integer;             {leftmost column}
    FLockedColumns       : Integer;             {number of fixed columns}
    FOptions             : TOvcDbTableOptionSet;{data-aware table options}
    FRowHeight           : Integer;             {height of table rows}
    FRowIndicatorWidth   : Integer;             {width of row indicators}
    FScrollBars          : TScrollStyle;        {scroll bar presence}
    FTextStyle           : TOvcTextStyle;       {default text style}
    FVisibleColumns      : TOvcVisibleColumns;  {list of visible columns}
    FVisibleRowCount     : Integer;             {count of visible rows}
    {event variables}
    FOnActiveCellChanged : TCellNotifyEvent;    {active cell changed event}
    FOnColumnMoved       : TOvcColumnMovedEvent;
    FOnIndicatorClick    : TCellNotifyEvent;    {a mouse click on the indicators}
    FOnGetCellAttributes : TCellAttrNotifyEvent;{get cell attributes event}
    FOnLeftColumnChanged : TNotifyEvent;        {left column changed}
    FOnLockedCellClick   : TCellNotifyEvent;    {locked cell clicked event}
    FOnPaintUnusedArea   : TNotifyEvent;        {unused bit needs painting event}
    FOnUnusedAreaClick   : TCellNotifyEvent;    {unused area clicked event}
    FOnUserCommand       : TUserCommandEvent;   {user command event}
    {internal variables}
    tbActiveCell         : TOvcBaseTableCell;   {the active cell object}
    tbCellAttrFont       : TFont;               {cached font for painting cells}
    tbCmdTable           : string;              {the command table name for the grid}
    tbColMoveCursor      : hCursor;             {cursor for column moves}
    tbDataSource         : TDataSource;         {copy of our datasource}
    tbDisplayedError     : Boolean;             {flag to indicate that an error was reported}
    tbHasHSBar           : Boolean;             {true if horiz scroll bar present}
    tbHasVSBar           : Boolean;             {true if vert scroll bar present}
    tbIndicators         : TImageList;          {list of indicators}
    tbRowIndicatorWidth  : Integer;             {width of indicator column or 0 if not displayed}
    tbLastLeftCol        : Integer;             {the last column number that can be leftmost}
    tbMoveIndex          : Integer;             {the index of the column being moved}
    tbMoveToIndex        : Integer;             {the index of the column being targeted by move}
    tbMovingCol          : Integer;             {column that is being moved}
    tbPainting           : Boolean;             {true during painting operation}
    tbRebuilding         : Boolean;             {true when rebuilding columns}
    tbScrolling          : Boolean;             {true if db is scrolling us}
    tbSelectingNewCell   : Boolean;             {true when selecting a new cell}
    tbSizeOffset         : Integer;             {the offset of the sizing line}
    tbSizeIndex          : Integer;             {the index of the sized row/col}
    tbState              : TOvcTblStates;       {the state of the table}
    {property read methods}
    function GetColumnCount : Integer;
    function GetDataSource : TDataSource;
    function GetFieldCount : Integer;
    function GetFields(Index : Integer) : TField;
    function GetSelectedField : TField;
    function GetVisibleColumnCount : Integer;
    {property write methods}
    procedure SetAccess(Value : TOvcTblAccess);
    procedure SetActiveColumn(Value : Integer);
    procedure SetActiveRow(Value : Integer);
    procedure SetAdjust(Value : TOvcTblAdjust);
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure SetColumnCount(Value : Integer);
    procedure SetColors(Value : TOvcTableColors);
    procedure SetColorUnused(Value : TColor);
    procedure SetColumns(Value : TOvcTableColumns);
    procedure SetDataSource(Value : TDataSource);
    procedure SetDefaultMargin(Value : Integer);
    procedure SetHeaderCell(Value : TOvcBaseTableCell);
    procedure SetHeaderHeight(Value : Integer);
    procedure SetHeaderOptions(Value : TOvcHeaderOptionSet);
    procedure SetLeftColumn(Value : Integer);
    procedure SetLockedColumns(Value : Integer);
    procedure SetOptions(Value : TOvcDbTableOptionSet);
    procedure SetRowHeight(Value : Integer);
    procedure SetRowIndicatorWidth(Value : Integer);
    procedure SetScrollBars(Value : TScrollStyle);
    procedure SetSelectedField(Value : TField);
    procedure SetTextStyle(Value : TOvcTextStyle);
    {cell-table messages}
    procedure ctimKillFocus(var Msg : TMessage); message ctim_KillFocus;
    procedure ctimQueryOptions(var Msg : TMessage); message ctim_QueryOptions;
    procedure ctimQueryColor(var Msg : TMessage); message ctim_QueryColor;
    procedure ctimQueryFont(var Msg : TMessage); message ctim_QueryFont;
    procedure ctimQueryLockedCols(var Msg : TMessage);
      message ctim_QueryLockedCols;
    procedure ctimQueryLockedRows(var Msg : TMessage);
      message ctim_QueryLockedRows;
    procedure ctimQueryActiveCol(var Msg : TMessage);
      message ctim_QueryActiveCol;
    procedure ctimQueryActiveRow(var Msg : TMessage);
      message ctim_QueryActiveRow;
    procedure ctimRemoveCell(var Msg : TMessage); message ctim_RemoveCell;
    procedure ctimSetFocus(var Msg : TMessage); message ctim_SetFocus;
    procedure ctimStartEdit(var Msg : TMessage); message ctim_StartEdit;
    procedure ctimStartEditMouse(var Msg : TWMMouse);
      message ctim_StartEditMouse;
    procedure ctimStartEditKey(var Msg : TWMKey); message ctim_StartEditKey;
    {VCL message methods}
    procedure CMColorChanged(var Msg : TMessage); message CM_COLORCHANGED;
    procedure CMCtl3DChanged(var Msg : TMessage); message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMFontChanged(var Msg : TMessage); message CM_FONTCHANGED;
    {Window message methods}
    procedure WMCommand(var Msg : TMessage); message WM_COMMAND;
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg : TWMScroll); message WM_HSCROLL;
    procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDblClk(var Msg : TWMMouse); message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Msg : TWMMouse); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg : TWMMouse); message WM_LBUTTONUP;
    procedure WMMouseMove(var Msg : TWMMouse); message WM_MOUSEMOVE;
    procedure WMNCHitTest(var Msg : TMessage); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg : TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg : TWMSize); message WM_SIZE;
    procedure WMVScroll(var Msg : TWMVScroll); message WM_VSCROLL;
    {datalink notification routines}
    procedure tbDataChanged;
    procedure tbEditingChanged;
    procedure tbLayoutChanged;
    procedure tbRecordChanged(Field : TField);
    {assorted internal methods}
    function tbAdjustIntegralHeight : Boolean;
    function tbCalcActiveCellRect(var ACR : TRect) : Boolean;
    function tbCalcCellRect(RowNum, ColNum : Integer) : TRect;
    function tbCalcColumnRect(ColNum : Integer) : TRect;
    procedure tbCalcColumnsOnLastPage;
    function tbCalcRowRect(RowNum : Integer) : TRect;
    function tbCalcRowTop(RowNum : Integer) : Integer;
    function tbCalcRowBottom(RowNum : Integer) : Integer;
    procedure tbCalcRowColData(NewLeftCol : Integer);
    procedure tbCalcVisibleRows;
    function tbCanModify : Boolean;
    procedure tbCellChanged(Sender : TObject); override;
    function tbCellModified(Cell : TOvcBaseTableCell) : Boolean;
    procedure tbColorsChanged(Sender : TObject);
    function tbColumnAtRight : Integer;
    procedure tbColumnChanged(Sender : TObject;
                              C1, C2 : Integer;
                              Action : TOvcTblActions);
    procedure tbDefineFieldMap;
    procedure tbDrawActiveCell(CellAttr : TOvcCellAttributes);
    procedure tbDrawMoveLine;
    procedure tbDrawSizeLine;
    procedure tbDrawUnusedArea;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    function tbEditCellHasFocus(FocusHandle : TOvcHWnd{hWnd}) : Boolean;

    function tbFindCell(ColNum : Integer) : TOvcBaseTableCell;
    function tbGetDataSize(ACell : TOvcBaseTableCell) : Integer;
    procedure tbGetMem(var P: Pointer; ACell: TOvcBaseTableCell; const AField: TField); //SZ (added)
    procedure tbFreeMem(P: Pointer; ACell: TOvcBaseTableCell; const AField: TField); //SZ (added)
    function tbGetFieldColumn(AField : TField) : Integer;
    procedure tbGetFieldValue(AField : TField;
                              ACell  : TOvcBaseTableCell;
                              Data   : Pointer;
                              Size   : Integer);
    procedure tbGridPenChanged(Sender : TObject);
    function tbIsDbActive : Boolean;
    function tbIsColumnHidden(ColNum : Integer) : Boolean;
    function tbIsInMoveArea(MouseX, MouseY : Integer) : Boolean;
    function tbIsOnGridLine(MouseX, MouseY : Integer) : Boolean;
{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    function tbIsSibling(HW : TOvcHWnd{hWnd}) : Boolean;
    function tbLoading(DS : TDataSource) : Boolean;
    procedure tbMoveActCellPageLeft;
    procedure tbMoveActCellPageRight;
    function tbPaintBitmapCell(ACanvas   : TCanvas;
                               PaintRect : TRect;
                               CellAttr  : TOvcCellAttributes;
                               AField    : TField;
                               ACell     : TOvcBaseTableCell;
                               Active    : Boolean) : Boolean;
    procedure tbPaintString(const CellRect : TRect;
                            const CellAttr : TOvcCellAttributes;
                                  Margin   : Integer;
                                  WordWrap : Boolean;
                            const S        : string);
    procedure tbQueryColData(ColNum : Integer;
                         var W      : Integer;
                         var A      : TOvcTblAccess;
                         var H      : Boolean);
    procedure tbReadColData(Reader : TReader);
    procedure tbRebuildColumns;
    procedure tbScrollBarPageLeft;
    procedure tbScrollBarPageRight;
    procedure tbScrollNotification(Delta : Integer);
    procedure tbScrollTableLeft(NewLeftCol : Integer);
    procedure tbScrollTableRight(NewLeftCol : Integer);
    procedure tbSetFieldValue(AField : TField;
                              ACell  : TOvcBaseTableCell;
                              Data   : Pointer;
                              Size   : Integer);
{ - HWnd changed to TOvcHWnd for BCB Compatibility }
    procedure tbSetFocus(AHandle : TOvcHWnd{hWnd});
    procedure tbUpdateActive;
    procedure tbUpdateHScrollBar;
    procedure tbUpdateBufferLimit;
    procedure tbUpdateVScrollBar;
    procedure tbWriteColData(Writer : TWriter);
  protected
    procedure ChangeScale(M, D : Integer); override;
    procedure CreateParams(var Params : TCreateParams); override;
    procedure CreateWnd; override;
    procedure DefineProperties(Filer : TFiler); override;
    procedure Loaded; override;
    procedure Notification(AComponent : TComponent;
                           Operation  : TOperation); override;
    procedure Paint; override;
    procedure SetLinkActive(Value : Boolean);
    procedure UpdateData;
    {event wrapper routines}
    procedure DoOnActiveCellChanged(RowNum, ColNum : Integer); dynamic;
    procedure DoOnColumnMoved(FromCol, ToCol : Integer); dynamic;
    procedure DoOnGetCellAttributes(RowNum   : TRowNum;
                                    ColNum   : Integer;
                                var CellAttr : TOvcCellAttributes); dynamic;
    procedure DoOnIndicatorClick(RowNum, ColNum : Integer); dynamic;
    procedure DoOnLeftColumnChanged; dynamic;
    procedure DoOnLockedCellClick(RowNum, ColNum : Integer); dynamic;
    procedure DoOnMouseWheel(Shift : TShiftState;
                             Delta, XPos, YPos : SmallInt); override;
    procedure DoOnPaintUnusedArea; virtual;
    procedure DoOnUnusedAreaClick(RowNum, ColNum : Integer); dynamic;
    procedure DoOnUserCommand(Cmd : Word); dynamic;
    {internal properties}
    property DataLink : TOvcDbTableDataLink read FDataLink;
    property VisibleColumns : TOvcVisibleColumns read FVisibleColumns;
    {protected properties - some may be published in descendants}
    property Access : TOvcTblAccess read FAccess write SetAccess;
    property Adjust : TOvcTblAdjust read FAdjust write SetAdjust;
    property BorderStyle : TBorderStyle read FBorderStyle write SetBorderStyle;
    property ColumnCount : Integer read GetColumnCount;
    property Colors : TOvcTableColors read FColors write SetColors;
    property ColorUnused : TColor read FColorUnused write SetColorUnused;
    property Columns : TOvcTableColumns read FColumns write SetColumns;
    property DataSource : TDataSource read GetDataSource write SetDataSource;
    property DefaultMargin : Integer read FDefaultMargin write SetDefaultMargin;
    property GridPenSet : TOvcGridPenSet read FGridPenSet write FGridPenSet;
    property HeaderCell : TOvcBaseTableCell
      read FHeaderCell write SetHeaderCell;
    property HeaderHeight : Integer read FHeaderHeight write SetHeaderHeight;
    property HeaderOptions : TOvcHeaderOptionSet
      read FHeaderOptions write SetHeaderOptions;
    property LockedColumns : Integer read FLockedColumns write SetLockedColumns;
    property Options : TOvcdbTableOptionSet read FOptions write SetOptions;
    property RowHeight : Integer read FRowHeight write SetRowHeight;
    property RowIndicatorWidth : Integer
      read FRowIndicatorWidth write SetRowIndicatorWidth;
    property ScrollBars : TScrollStyle read FScrollBars write SetScrollBars;
    property TextStyle : TOvcTextStyle read FTextStyle write SetTextStyle;
    {events}
    property OnActiveCellChanged : TCellNotifyEvent
      read FOnActiveCellChanged write FOnActiveCellChanged;
    property OnColumnMoved : TOvcColumnMovedEvent
      read FOnColumnMoved write FOnColumnMoved;
    property OnGetCellAttributes : TCellAttrNotifyEvent
       read FOnGetCellAttributes write FOnGetCellAttributes;
    property OnIndicatorClick : TCellNotifyEvent
      read FOnIndicatorClick write FOnIndicatorClick;
    property OnLeftColumnChanged : TNotifyEvent
      read FOnLeftColumnChanged write FOnLeftColumnChanged;
    property OnLockedCellClick : TCellNotifyEvent
      read FOnLockedCellClick write FOnLockedCellClick;
    property OnPaintUnusedArea : TNotifyEvent
      read FOnPaintUnusedArea write FOnPaintUnusedArea;
    property OnUnusedAreaClick : TCellNotifyEvent
      read FOnUnusedAreaClick write FOnUnusedAreaClick;
    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand write FOnUserCommand;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer); override;
    {public methods}
    function CalcRowCol(X, Y : Integer;
                    var RowNum, ColNum : Integer) : TOvcTblRegion;
    function FilterKey(var Msg : TWMKey) : TOvcTblKeyNeeds; override;
    procedure GetColumnOrderStrings(var Cols : TStrings);
    procedure GetColumnOrder(var Cols : array of string);
    procedure GetColumnWidthsStrings(var Cols : TStrings);
    procedure GetColumnWidths(var Cols : array of Integer);
    function IncCol(ColNum, Delta : Integer) : Integer;
    function IncRow(RowNum, Delta : Integer) : Integer;
    function InEditingState : Boolean;
    procedure InvalidateCell(RowNum, ColNum : Integer);
    procedure InvalidateColumn(ColNum : Integer);
    procedure InvalidateHeader;
    procedure InvalidateIndicators;
    procedure InvalidateNotLocked;
    procedure InvalidateRow(RowNum : Integer);
    procedure InvalidateUnusedArea;
    procedure MakeColumnVisible(ColNum : Integer);
    procedure MoveActiveCell(Command : Word);
    procedure ResolveCellAttributes(RowNum   : TRowNum;
                                    ColNum   : TColNum;
                                var CellAttr : TOvcCellAttributes); override;
    function SaveEditedData : Boolean;
    procedure Scroll(Delta : Integer);
    procedure SetActiveCell(RowNum, ColNum : Integer);
    function SetCellProperties(AField : TField;
                               ACell  : TOvcBaseTableCell) : Boolean;
    procedure SetColumnOrderStrings(const Cols : TStrings);
    procedure SetColumnOrder(const Cols : array of string);
    procedure SetColumnWidthsStrings(const Cols : TStrings);
    procedure SetColumnWidths(const Cols : array of Integer);
    function StartEditing : Boolean;
    function StopEditing(SaveValue : Boolean) : Boolean;
    {public properties}
    property Canvas;
    property ActiveColumn : Integer read FActiveColumn write SetActiveColumn;
    property ActiveRow : Integer read FActiveRow write SetActiveRow;
    property FieldCount : Integer read GetFieldCount;
    property SelectedField : TField read GetSelectedField write SetSelectedField;
    property Fields[Index : Integer] : TField read GetFields;
    property LeftColumn : Integer read FLeftColumn write SetLeftColumn;
    property VisibleColumnCount : Integer read GetVisibleColumnCount;
    property VisibleRowCount : Integer read FVisibleRowCount;
  end;

  TOvcDbTable = class(TOvcCustomDbTable)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property LockedColumns;
    property Access;
    property Adjust;
    property Align;
    property BorderStyle;
    property ColumnCount stored False;
    property Color default tbDefTableColor;
    property ColorUnused;
    property Colors;
    property Columns;
    property Controller;
    property Ctl3D;
    property DataSource;
    property DefaultMargin;
    property DragCursor;
    property Enabled;
    property Font;
    property GridPenSet;
    property HeaderCell;
    property HeaderHeight;
    property HeaderOptions;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowHeight;
    property RowIndicatorWidth;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextStyle;
    property Visible;
    {events}
    property OnActiveCellChanged;
    property OnClick;
    property OnColumnMoved;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCellAttributes;
    property OnIndicatorClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnLeftColumnChanged;
    property OnLockedCellClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintUnusedArea;
    property OnStartDrag;
    property OnUnusedAreaClick;
    property OnUserCommand;
  end;


implementation

uses
  Types, Dialogs, OvcNF, OvcPF, OvcSF, OvcTCBmp, OvcTCBox, OvcTCCbx, OvcTCEdt,
  OvcTCGly, OvcTCHdr, OvcTCIco, OvcTCNum, OvcTCPic, OvcTCSim, OvcTCHeaderExtended;

type
  TLocalCell = class(TOvcBaseTableCell);
  {allows access to a cell's protected properties}

const
  {field types where editing is supported}
  SupportedFieldTypes : set of TFieldType = [ftString, ftSmallInt,
    ftInteger, ftWord, ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate,
    ftTime, ftDateTime, ftWideString];

  dtDefHitMargin = 4;


{*** TOvcDbTableDataLink ***}

const
  MaxMapSize = MaxInt div 16; {maximum columns}
  MapElementSize = SizeOf(Integer);

type
  TFieldMappingsArray = array[0..MaxMapSize] of Integer;
  TFieldMappings = ^TFieldMappingsArray;

procedure TOvcDbTableDataLink.ActiveChanged;
begin
  FTable.SetLinkActive(Active);
end;

function TOvcDbTableDataLink.AddMapping(const FieldName : string) : Boolean;
var
  Field   : TField;
  NewSize : Integer;
  NewMap  : Pointer;
begin
  if FFieldCount >= MaxMapSize then
    raise EOrpheusTable.Create(GetOrphStr(SCTableToManyColumns));

  Field := DataSet.FindField(FieldName);
  {FindField does not raise an exception if the field is not found}

  Result := Field <> nil;

  if Result then begin
    if FFieldMapSize = 0 then begin
      FFieldMapSize := 16;
      GetMem(FFieldMap, FFieldMapSize * MapElementSize);
    end else if FFieldCount = FFieldMapSize then begin
      NewSize := FFieldMapSize;

      {double previous size for each new allocation}
      Inc(NewSize, NewSize);
      if (NewSize > MaxMapSize) or (NewSize < FFieldCount) then
        NewSize := MaxMapSize;

      GetMem(NewMap, NewSize * MapElementSize);
      Move(FFieldMap^, NewMap^, MapElementSize * FFieldCount);
      FreeMem(FFieldMap {, MapElementSize * FFieldCount});
      FFieldMapSize := NewSize;
      FFieldMap := NewMap;
    end;

    TFieldMappings(FFieldMap)^[FFieldCount] := Field.Index;
    Field.FreeNotification(FTable);

    Inc(FFieldCount);

    FMapBuilt := True;
  end;
end;

procedure TOvcDbTableDataLink.ClearFieldMappings;
begin
  if FFieldMap <> nil then begin
    FreeMem(FFieldMap {, FFieldMapSize * MapElementSize});
    FFieldMap := nil;
    FFieldMapSize := 0;
    FFieldCount := 0;
    FMapBuilt := False;
  end;
end;

constructor TOvcDbTableDataLink.Create(ATable : TOvcCustomDBTable);
begin
  inherited Create;

  FTable := ATable;
end;

destructor TOvcDbTableDataLink.Destroy;
begin
  ClearFieldMappings;

  inherited Destroy;
end;

function TOvcDbTableDataLink.GetDefaultFields : Boolean;
begin
  Result := True;

  if DataSet <> nil then
    Result := DataSet.Fields.LifeCycles = [TFieldLifeCycle.lcAutomatic];
end;

function TOvcDbTableDataLink.GetFields(Index : Integer) : TField;
begin
  if (Index < FFieldCount) and (Index >= 0) then
    Result := DataSet.Fields[TFieldMappings(FFieldMap)^[Index]]
  else
    raise EOrpheusTable.Create(GetOrphStr(SCTableInvalidFieldIndex));
end;

procedure TOvcDbTableDataLink.DataSetChanged;
begin
  FTable.tbDataChanged;
  FModified := False;
end;

procedure TOvcDbTableDataLink.DataSetScrolled(Distance : Integer);
begin
  FTable.tbScrollNotification(Distance);
end;

procedure TOvcDbTableDataLink.EditingChanged;
begin
  FTable.tbEditingChanged;
end;

procedure TOvcDbTableDataLink.LayoutChanged;
begin
  FTable.tbLayoutChanged;
end;

procedure TOvcDbTableDataLink.Modified;
begin
  FModified := True;
end;

procedure TOvcDbTableDataLink.RecordChanged(Field : TField);
begin
  if (Field = nil) or not FInUpdateData then begin
    FTable.tbRecordChanged(Field);
    FModified := False;
  end;
end;

procedure TOvcDbTableDataLink.Reset;
begin
  if FModified then
    RecordChanged(nil)
  else
    Dataset.Cancel;
end;

procedure TOvcDbTableDataLink.UpdateData;
  {-post changes in the active cell to the datasource}
begin
  FInUpdateData := True;
  try
    if FModified then
      FTable.UpdateData;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;


{*** TOvcDbTableColumn ***}

procedure TOvcDbTableColumn.Assign(Source : TPersistent);
begin
  inherited Assign(Source);

  if Source is TOvcDbTableColumn then begin
    DataField := TOvcDbTableColumn(Source).DataField;
    DateOrTime := TOvcDbTableColumn(Source).DateOrTime;
  end;
end;

constructor TOvcDbTableColumn.Create(ATable : TOvcTableAncestor);
begin
  inherited Create(ATable);

  FDateOrTime := dtUseDate;
end;

function TOvcDbTableColumn.GetField : TField;
begin
  {get field from the dataset}
  if (FField = nil) and (Length(FDataField) > 0) then
    if (Table <> nil) and (Table.DataLink.DataSet <> nil) then begin
      with Table.Datalink.Dataset do
        if Active or (Fields.LifeCycles <> [TFieldLifeCycle.lcAutomatic]) then
          SetField(FindField(FDataField)); { no exceptions }
    end;

  Result := FField;
end;

function TOvcDbTableColumn.GetTable : TOvcCustomDbTable;
begin
  Result := TOvcCustomDbTable(inherited Table);
end;

procedure TOvcDbTableColumn.SetDataField(const Value : string);
var
  AField: TField;
begin
  AField := nil;
  if (Table <> nil) and (Table.DataLink.DataSet <> nil) and
    not (csLoading in Table.ComponentState) and (Length(Value) > 0) then
      AField := Table.DataLink.DataSet.FindField(Value); { no exceptions }
  FDataField := Value;
  SetField(AField);
end;

procedure TOvcDbTableColumn.SetDateOrTime(Value : TDateOrTime);
begin
  if Value <> FDateOrTime then begin
    FDateOrTime := Value;

    if csLoading in Table.ComponentState then
      Exit;

    if (Field <> nil) and (DefaultCell <> nil) then
      Table.SetCellProperties(Field, DefaultCell);
  end;
end;

procedure TOvcDbTableColumn.SetField(Value : TField);
begin
  if Value <> FField  then begin
    FField := Value;
    if Assigned(FField) then
      FDataField := FField.FieldName;
  end;
end;


{*** TOvcVisibleColumns ***}

procedure TOvcVisibleColumns.Add(ColNum : Integer);
begin
  Insert(FList.Count, ColNum);
end;

procedure TOvcVisibleColumns.Clear;
begin
  FList.Clear;
end;

constructor TOvcVisibleColumns.Create(ATable : TOvcCustomDbTable);
begin
  inherited Create;

  FList := TList.Create;
  FTable := ATable;
end;

procedure TOvcVisibleColumns.Delete(Index : Integer);
begin
  FList.Delete(Index);
end;

destructor TOvcVisibleColumns.Destroy;
begin
  FList.Clear;
  FList.Free;
  FList := nil;

  inherited Destroy;
end;

procedure TOvcVisibleColumns.Exchange(Index1, Index2 : Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TOvcVisibleColumns.IndexOf(ColNum : Integer) : Integer;
begin
  for Result := 0 to Pred(FList.Count) do
    if ColNum = Integer(FList[Result]) then
      Exit;

  Result := -1;
end;

function TOvcVisibleColumns.GetColumn(Index : Integer) : TOvcDbTableColumn;
begin
  Result := TOvcDbTableColumn(FTable.Columns[Integer(FList[Index])]);
end;

function TOvcVisibleColumns.GetCount : Integer;
begin
  Result := FList.Count;
end;

procedure TOvcVisibleColumns.Insert(Index, ColNum : Integer);
begin
  FList.Expand.Insert(Index, Pointer(ColNum));
end;

procedure TOvcVisibleColumns.Move(Index1, Index2 : Integer);
var
  Col : Integer;
begin
  if Index1 <> Index2 then begin
    Col := Integer(FList[Index1]);
    Delete(Index1);
    Insert(Index2, Col);
  end;
end;


{*** TOvcCustomDbTable ***}

function TOvcCustomDbTable.CalcRowCol(X, Y : Integer; var RowNum, ColNum : Integer) : TOvcTblRegion;
  {-return the row and column where x,y land and the region code}
var
  Idx : Integer;
  TW  : Integer;
  TH  : Integer;
begin
  RowNum := CRCFXY_RowBelow;
  ColNum := CRCFXY_ColToRight;

  {calculate the table width based on the columns that fit}
  TW := MinI(ClientWidth, VisibleColumns.RightEdge);

  {calculate the table height based on the rows that will fit}
  if hoShowHeader in HeaderOptions then begin
    TH := MinI(ClientHeight, VisibleRowCount * RowHeight + HeaderHeight);
    if tbIsDbActive then
      TH := MinI(TH, DataLink.RecordCount * RowHeight + HeaderHeight);
  end else begin
    TH := MinI(ClientHeight, VisibleRowCount * RowHeight);
    if tbIsDbActive then
      TH := MinI(TH, DataLink.RecordCount * RowHeight);
  end;

  {make a first pass at calculating the region}
  if (X < 0) or (Y < 0) or (X >= ClientWidth) or (Y >= ClientHeight) then
    Result := otrOutside {definitely}
  else
    Result := otrInMain; {possibly}

  {find row}
  if (hoShowHeader in HeaderOptions) then begin
    if (Y > HeaderHeight) then begin
      if (Y < TH) then
        RowNum := (Y-HeaderHeight) div RowHeight
      else
        RowNum := CRCFXY_RowBelow;  {Y is below all table cells}
    end else
      RowNum := CRCFXY_RowAbove;    {Y is above all table cells}
  end else if (Y > 0) and (Y < TH) then
    RowNum := Y div RowHeight
  else if (Y > 0) then
    RowNum := CRCFXY_RowBelow       {Y is below all table cells}
  else
    RowNum := CRCFXY_RowAbove;      {Y is above all table cells}

  {find column}
  if (X > tbRowIndicatorWidth) and (X < TW) then begin
    Idx := 0;
    while (Idx < VisibleColumnCount) and (X > VisibleColumns[Idx].Offset) do
      Inc(Idx);
    ColNum := VisibleColumns[Pred(Idx)].Number;
  end else if (X < tbRowIndicatorWidth) then
    ColNum := CRCFXY_ColToLeft      {X is to left of all table cells}
  else
    ColNum := CRCFXY_ColToRight;    {X is to right of all table cells}

  {patch up the region}
  if (Result = otrInMain) then begin
    if (RowNum = CRCFXY_RowBelow) or (ColNum = CRCFXY_ColToRight) then
      Result := otrInUnused
    else if (RowNum = CRCFXY_RowAbove) or (ColNum = CRCFXY_ColToLeft) then
      Result := otrInLocked
    else if (ColNum < LockedColumns) then
      Result := otrInLocked
  end;
end;

procedure TOvcCustomDbTable.ChangeScale(M, D : Integer);
var
  I : Integer;
begin
  inherited ChangeScale(M, D);

  if (M <> D) then
    for I := 0 to Pred(ColumnCount) do
      with Columns[I] do
        Width := MulDiv(Width, M, D);
end;

procedure TOvcCustomDbTable.CMColorChanged(var Msg : TMessage);
begin
  inherited;

  tbNotifyCellsOfTableChange;
end;

procedure TOvcCustomDbTable.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;

procedure TOvcCustomDbTable.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  Msg.Result := 1;

  if (csDesigning in ComponentState) then begin
    if ((tbState * [otsSizing, otsMoving]) <> []) then
      Exit;

    if tbIsOnGridLine(Msg.Pos.X, Msg.Pos.Y) then
      Msg.Result := 1
    else
      Msg.Result := NativeInt(tbIsInMoveArea(Msg.Pos.X, Msg.Pos.Y));
  end;
end;

procedure TOvcCustomDbTable.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  tbNotifyCellsOfTableChange;
end;

constructor TOvcCustomDbTable.Create(AOwner : TComponent);
var
  Bmp : Graphics.TBitmap;
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csDoubleClicks]
  else
    ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csDoubleClicks, csFramed];

  {set default inherited properties}
  Color               := tbDefTableColor;
  Height              := tbDefHeight;
  ParentColor         := False;
  TabStop             := True;
  Width               := tbDefWidth;

  {set default property values}
  FAccess             := tbDefAccess;
  FActiveRow          := 0;
  FAdjust             := tbDefAdjust;
  FActiveColumn       := 0;
  FBorderStyle        := tbDefBorderStyle;
  FColorUnused        := clWindow;
  FDefaultMargin      := 4;
  FHeaderHeight       := 21;
  FHeaderOptions      := [hoShowHeader];
  FRowIndicatorWidth  := 11;
  FLockedColumns      := 0;
  FLeftColumn         := 0;
  FOptions            := [dtoShowIndicators];
  FRowHeight          := 21;
  FScrollBars         := tbDefScrollBars;
  FTextStyle          := tsFlat;

  {initialize internal items}
  tbCmdTable := GetOrphStr(SCGridTableName);
  tbCellAttrFont := TFont.Create;
  tbColMoveCursor := LoadBaseCursor('ORCOLUMNMOVECURSOR');
  tbState := [otsNormal];

  {create grid pen object}
  FGridPenSet := TOvcGridPenSet.Create;
  FGridPenSet.OnCfgChanged := tbGridPenChanged;

  {create table colors object}
  FColors := TOvcTableColors.Create;
  FColors.OnCfgChanged := tbColorsChanged;

  {create table columns object}
  FColumns := TOvcTableColumns.Create(Self, 1, TOvcDbTableColumn);
  FColumns.OnColumnChanged := tbColumnChanged;
  FColumns.Table := Self;

  {create the visible columns object}
  FVisibleColumns := TOvcVisibleColumns.Create(Self);

  {create indicators object and load bitmaps}
  Bmp := Graphics.TBitmap.Create;
  try
    Bmp.Handle := LoadBaseBitmap('ORDBARROW');
    tbIndicators := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    tbIndicators.AddMasked(Bmp, clWhite);
    Bmp.Handle := LoadBaseBitmap('ORDBEDIT');
    tbIndicators.AddMasked(Bmp, clWhite);
    Bmp.Handle := LoadBaseBitmap('ORDBINSERT');
    tbIndicators.AddMasked(Bmp, clWhite);
  finally
    Bmp.Free;
  end;

  {create the table data link object}
  FDataLink := TOvcDbTableDataLink.Create(Self);
end;

procedure TOvcCustomDbTable.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Integer(Style) or OvcData.ScrollBarStyles[FScrollBars]
                   or OvcData.BorderStyles[FBorderStyle];
  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcCustomDbTable.CreateWnd;
begin
  inherited CreateWnd;

  tbHasHSBar := False;
  tbHasVSBar := False;
  if (FScrollBars = ssBoth) or (FScrollBars = ssHorizontal) then
    tbHasHSBar := True;
  if (FScrollBars = ssBoth) or (FScrollBars = ssVertical) then
    tbHasVSBar := True;

  if (dtoShowIndicators in Options) then
    tbRowIndicatorWidth := FRowIndicatorWidth
  else
    tbRowIndicatorWidth := 0;

  tbLayoutChanged;

  tbCalcColumnsOnLastPage; {calls tbCalcRowColData(LeftColumn)}
  tbUpdateVScrollBar;
  tbUpdateHScrollBar;

  SetLeftColumn(LeftColumn); {this call will adjust for locked column count}
  ActiveColumn := LockedColumns;

  {trigger the active cell changed event}
  DoOnActiveCellChanged(ActiveRow, ActiveColumn);
end;

procedure TOvcCustomDbTable.ctimKillFocus(var Msg : TMessage);
begin
  {cell has lost the focus}

  if not tbIsSibling(Msg.wParam) then
    Exit;

  {if lParam (the error code) is non-zero, the field had an error and
  has requested that the focus be returned -- don't stop editing in this case}
  if Msg.lParam = 0 then
    StopEditing(True);

  {if focus isn't going to the table or already there}
  if (Msg.wParam <> Handle) and (Handle <> GetFocus) then
    Exclude(tbState, otsFocused);

  InvalidateCell(ActiveRow, ActiveColumn);
end;

procedure TOvcCustomDbTable.ctimQueryOptions(var Msg : TMessage);
var
  O : TOvcTblOptionSet;
begin
  O := [otoNoRowResizing, otoNoSelection];

  {map our properties to ancestor's table options}
  if (dtoAlwaysEditing in Options) then
    Include(O, otoAlwaysEditing);
  if (dtoHighlightActiveRow in Options) then
    Include(O, otoBrowseRow);
  if (dtoAllowColumnMove in Options) then
    Include(O, otoAllowColMoves);
  if not (dtoAllowColumnSize in Options) then
    Include(O, otoNoColResizing);
  if (dtoWantTabs in Options) then
    Include(O, otoTabToArrow);
  if (dtoEnterToTab in Options) then
    Include(O, otoEnterToArrow);

  Msg.Result := Word(O);
end;

procedure TOvcCustomDbTable.ctimQueryColor(var Msg : TMessage);
begin
  Msg.Result := NativeInt(Color);
end;

procedure TOvcCustomDbTable.ctimQueryFont(var Msg : TMessage);
begin
  Msg.Result := NativeInt(Font);
end;

procedure TOvcCustomDbTable.ctimQueryLockedCols(var Msg : TMessage);
begin
  Msg.Result := NativeInt(LockedColumns);
end;

procedure TOvcCustomDbTable.ctimQueryLockedRows(var Msg : TMessage);
begin
  Msg.Result := 0; {we don't allow locked rows}
end;

procedure TOvcCustomDbTable.ctimQueryActiveCol(var Msg : TMessage);
begin
  Msg.Result := NativeInt(ActiveColumn);
end;

procedure TOvcCustomDbTable.ctimQueryActiveRow(var Msg : TMessage);
begin
  Msg.Result := NativeInt(ActiveRow);
end;

procedure TOvcCustomDbTable.ctimRemoveCell(var Msg : TMessage);
begin
  Notification(TComponent(Msg.LParam), opRemove);
  Msg.Result := 0;
end;

procedure TOvcCustomDbTable.ctimSetFocus(var Msg : TMessage);
begin
  {cell has received the focus}
  Include(tbState, otsFocused);
end;

procedure TOvcCustomDbTable.ctimStartEdit(var Msg : TMessage);
begin
  if (otsFocused in tbState) then begin
    StartEditing;
    Msg.Result := 1;
  end else
    Msg.Result := 0;
end;

procedure TOvcCustomDbTable.ctimStartEditMouse(var Msg : TWMMouse);
begin
  if Assigned(tbActiveCell) and InEditingState then
    if tbActiveCell.AcceptActivationClick then begin
      tbSetFocus(tbActiveCell.EditHandle);

      if not (tbActiveCell is TOvcTCComboBox) then
        PostMessage(tbActiveCell.EditHandle, WM_LBUTTONDOWN, Msg.Keys, Integer(Msg.Pos))
      else if (tbActiveCell is TOvcTCComboBox) then begin
        if TOvcTCComboBox(tbActiveCell).Style <> csDropDownList then
          PostMessage(tbActiveCell.EditHandle, WM_LBUTTONDOWN, Msg.Keys, Integer(Msg.Pos));
      end;

    end;
  Msg.Result := 1;
end;

procedure TOvcCustomDbTable.ctimStartEditKey(var Msg : TWMKey);
begin
  if Assigned(tbActiveCell) and InEditingState then begin
    tbSetFocus(tbActiveCell.EditHandle);
    PostMessage(tbActiveCell.EditHandle, WM_KEYDOWN, Msg.CharCode, Msg.KeyData);
  end;
  Msg.Result := 1;
end;

procedure TOvcCustomDbTable.DefineProperties(Filer : TFiler);
begin
  inherited DefineProperties(Filer);

  Filer.DefineProperty('ColData', tbReadColData, tbWriteColData, True);
end;

destructor TOvcCustomDbTable.Destroy;
begin
  if not (csDestroying in ComponentState) then
    Destroying;

  if Assigned(FHeaderCell) then begin
    FHeaderCell.DecRefs;
    FHeaderCell := nil;
  end;

  {destroy table columns}
  FColumns.Free;
  FColumns := nil;

  {destroy table pens}
  GridPenSet.Free;
  GridPenSet := nil;

  {destroy table colors}
  FColors.Free;
  FColors := nil;

  {destroy table data link}
  FDataLink.Free;
  FDataLink := nil;

  {destroy table columns object}
  FVisibleColumns.Free;
  FVisibleColumns := nil;

  {destroy cell attributes}
  tbCellAttrFont.Free;
  tbCellAttrFont := nil;

  tbIndicators.Free;
  tbIndicators := nil;

  inherited Destroy;
end;

procedure TOvcCustomDbTable.DoOnActiveCellChanged(RowNum, ColNum : Integer);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnActiveCellChanged) then
    FOnActiveCellChanged(Self, RowNum, ColNum);
end;

procedure TOvcCustomDbTable.DoOnColumnMoved(FromCol, ToCol : Integer);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnColumnMoved) then
    FOnColumnMoved(Self, FromCol, ToCol);
end;

procedure TOvcCustomDbTable.DoOnGetCellAttributes(
          RowNum : TRowNum; ColNum : Integer; var CellAttr : TOvcCellAttributes);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
     Assigned(FOnGetCellAttributes) then
    FOnGetCellAttributes(Self, RowNum, ColNum, CellAttr);
end;

procedure TOvcCustomDbTable.DoOnIndicatorClick(RowNum, ColNum : Integer);
begin
  if not (csDesigning in ComponentState) and Assigned(FOnIndicatorClick) then
    FOnIndicatorClick(Self, RowNum, ColNum);
end;

procedure TOvcCustomDbTable.DoOnLeftColumnChanged;
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnLeftColumnChanged) then
    FOnLeftColumnChanged(Self);
end;

procedure TOvcCustomDbTable.DoOnLockedCellClick(RowNum, ColNum : Integer);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnLockedCellClick) then
    FOnLockedCellClick(Self, RowNum, ColNum);
end;

procedure TOvcCustomDbTable.DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
begin
  inherited DoOnMouseWheel(Shift, Delta, XPos, YPos);

  if Delta < 0 then
    MoveActiveCell(ccDown)
  else
    MoveActiveCell(ccUp);
end;

procedure TOvcCustomDbTable.DoOnPaintUnusedArea;
begin
  if ((ComponentState * [csLoading, csDestroying]) <> []) then
    Exit;

  if Assigned(FOnPaintUnusedArea) then
    FOnPaintUnusedArea(Self)
  else
    tbDrawUnusedArea;
end;

procedure TOvcCustomDbTable.DoOnUnusedAreaClick(RowNum, ColNum : Integer);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnUnusedAreaClick) then
    FOnUnusedAreaClick(Self, RowNum, ColNum);
end;

procedure TOvcCustomDbTable.DoOnUserCommand(Cmd : Word);
begin
  if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnUserCommand) then
    FOnUserCommand(Self, Cmd);
end;

function TOvcCustomDbTable.FilterKey(var Msg : TWMKey) : TOvcTblKeyNeeds;
  {-filter/translate entered keys}
var
  Cmd : Word;
begin
  {insure that the active column is visible}
  MakeColumnVisible(ActiveColumn);

  Result := otkDontCare;
  Cmd := Controller.EntryCommands.TranslateUsing([tbCmdTable], TMessage(Msg));

  {first the hard coded keys}
  case Msg.CharCode of
    VK_RETURN :
      if (dtoEnterToTab in Options) then
        Result := otkMustHave;
    VK_TAB :
      if (dtoWantTabs in Options) then
        Result := otkMustHave;
    VK_ESCAPE :
      Result := otkMustHave;
  end;{case}

  {now the translated commands}
  case Cmd of
    ccTableEdit :
      Result := otkMustHave;
    ccBotOfPage, ccBotRightCell, ccDown, ccEnd, ccFirstPage, ccHome,
    ccLastPage, ccLeft, ccNextPage, ccPageLeft, ccPageRight, ccPrevPage,
    ccRight, ccTopLeftCell, ccTopOfPage, ccUp, ccWordLeft, ccWordRight :
      Result := otkWouldLike;
  end;
end;

function TOvcCustomDbTable.GetColumnCount : Integer;
begin
  Result := FColumns.Count;
end;

procedure TOvcCustomDbTable.GetColumnOrderStrings(var Cols : TStrings);
  {-obtain the the table column order and return it in a TStrings object}
var
  I : Integer;
begin
  for I := 0 to ColumnCount -1 do begin
    Cols.add(TOvcDbTableColumn(Columns[I]).DataField);
  end;
end;

procedure TOvcCustomDbTable.GetColumnOrder(var Cols : array of string);
  {-obtain the the table column order}
var
  I : Integer;
begin
  for I := Low(Cols) to High(Cols) do begin
    if (I >= 0) and (I < ColumnCount) then
      Cols[I] := TOvcDbTableColumn(Columns[I]).DataField
    else
      Cols[I] := '';
  end;
end;

procedure TOvcCustomDbTable.GetColumnWidthsStrings(var Cols : TStrings);
  {-obtain the widths of the table columns}
var
  I : Integer;
begin
  for I := 0 to ColumnCount -1 do
    Cols.add(IntToStr(Columns[I].Width));
end;

procedure TOvcCustomDbTable.GetColumnWidths(var Cols : array of Integer);
  {-obtain the widths of the table columns}
var
  I : Integer;
begin
  for I := Low(Cols) to High(Cols) do
    if (I >= 0) and (I < ColumnCount) then
      Cols[I] := Columns[I].Width
    else
      Cols[I] := -1;
end;

function TOvcCustomDbTable.GetDataSource : TDataSource;
begin
  Result := nil;
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource;
end;

function TOvcCustomDbTable.GetFieldCount : Integer;
begin
  Result := FDatalink.FieldCount;
end;

function TOvcCustomDbTable.GetFields(Index : Integer) : TField;
begin
  Result := FDatalink.Fields[Index];
end;

function TOvcCustomDbTable.GetSelectedField : TField;
begin
  Result := nil;
  if ActiveColumn < DataLink.FieldCount then
    Result := Fields[ActiveColumn];
end;

function TOvcCustomDbTable.GetVisibleColumnCount : Integer;
begin
  Result := VisibleColumns.Count;
end;

function TOvcCustomDbTable.IncCol(ColNum, Delta : Integer) : Integer;
{-Return a valid unhidden column number. If Direction is:
      - : start at ColNum and find the previous unhidden column number, if there
          is none previous to this one, return ColNum.
      + : start at ColNum and find the next unhidden column number, if there is
          none after this one, return ColNum
      0 : verify that ColNum is unhidden, if not find the next unhidden column
          number, if none after this one, find the previous one. If still
          none, return ColNum.}
var
  CL, CC : Integer;
begin
  CL := LockedColumns;
  CC := ColumnCount;

  {adjust ColNum to be in range}
  if (ColNum < CL) then
    ColNum := CL;
  if (ColNum >= CC) then
    ColNum := Pred(CC);

  {default to this column}
  Result := ColNum;

  {are there any columns? if not, exit}
  if Result = -1 then
    Exit;

  {see if column is visible}
  if (Delta = 0) then
    if not tbIsColumnHidden(Result) then
      Exit;

  {now delta >= 0, ie to increment the column number}
  if (Delta >= 0) then begin {go forwards}
    Inc(Result);
    while Result < CC do begin
      if not tbIsColumnHidden(Result) then
        Exit;
      Inc(Result);
    end;
    Result := ColNum;
  end;

  {now delta <= 0, ie to decrement the column number}
  if (Delta <= 0) then begin {go backwards}
    Dec(Result);
    while (Result >= CL) do begin
      if not tbIsColumnHidden(Result) then
        Exit;
      Dec(Result);
    end;
    Result := ColNum;
  end;
end;

function TOvcCustomDbTable.IncRow(RowNum, Delta : Integer) : Integer;
  {-increase/decrease the row number and verify}
begin
  Result := RowNum + Delta;
  if Result < 0 then
    Result := 0
  else if Result > Pred(VisibleRowCount) then
    Result := Pred(VisibleRowCount);
end;

function TOvcCustomDbTable.InEditingState : Boolean;
  {-return True if the cell is in edit mode}
begin
  Result := (otsEditing in tbState);
end;

procedure TOvcCustomDbTable.InvalidateCell(RowNum, ColNum : Integer);
  {-invalidate the specified cell}
var
  R : TRect;
begin
  if (dtoHighlightActiveRow in Options) then
    InvalidateRow(RowNum)
  else begin
    R := tbCalcCellRect(RowNum, ColNum);
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TOvcCustomDbTable.InvalidateColumn(ColNum : Integer);
  {-invalidate the specified column}
var
  R : TRect;
begin
  R := tbCalcColumnRect(ColNum);
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomDbTable.InvalidateHeader;
  {-invalidate the header row}
var
  R : TRect;
begin
  if (hoShowHeader in HeaderOptions) then begin
    R := ClientRect;
    R.Left := tbRowIndicatorWidth;
    R.Bottom := HeaderHeight;
    R.Right := VisibleColumns.RightEdge;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TOvcCustomDbTable.InvalidateIndicators;
  {-invalidate the row indicators}
var
  R : TRect;
begin
  if (dtoShowIndicators in Options) then begin
    R := ClientRect;
    R.Right := RowIndicatorWidth;
    R.Bottom := tbCalcRowBottom(Pred(VisibleRowCount));
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TOvcCustomDbTable.InvalidateNotLocked;
  {-invalidate cell portion of table, excluding locked columns}
var
  R   : TRect;
  Idx : Integer;
begin
  R.Right := VisibleColumns.RightEdge;
  Idx := VisibleColumns.IndexOf(LeftColumn);
  if (Idx > -1) and (Idx < VisibleColumnCount) then
    R.Left := VisibleColumns[Idx].Offset
  else
    R.Left := 0;
  R.Top := 0; {include the header area, if any}
  R.Bottom := tbCalcRowBottom(Pred(VisibleRowCount));

  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomDbTable.InvalidateRow(RowNum : Integer);
  {-invalidate the specified row}
var
  R : TRect;
begin
  if (RowNum < 0) or (RowNum >= VisibleRowCount) then
    Exit;

  R := tbCalcRowRect(RowNum);
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomDbTable.InvalidateUnusedArea;
  {-invalidate the unused regions}
var
  R    : TRect;
  CR   : TRect;
begin
  CR := ClientRect;

  {right edge}
  R.Left := VisibleColumns.RightEdge;
  R.Right := CR.Right;
  R.Top := 0;
  R.Bottom := CR.Bottom;
  if R.Right > R.Left then
    InvalidateRect(Handle, @R, False);

  {bottom}
  R.Right := R.Left;
  R.Left := 0;
  R.Top := tbCalcRowBottom(Pred(VisibleRowCount));
  if R.Bottom > R.Top then
    InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomDbTable.Loaded;
var
  I : Integer;
begin
  inherited Loaded;

  Columns.tcStopLoading;
  tbCalcRowColData(LeftColumn);

  {if our cell list is empty refresh it now}
  if (taCellList.Count = 0) then begin
    if Assigned(FHeaderCell) then
      tbIncludeCell(FHeaderCell);

    for I := 0 to Pred(ColumnCount) do
      tbIncludeCell(Columns.DefaultCell[I]);
  end;

  {tbLayoutChanged;}
end;

procedure TOvcCustomDbTable.MakeColumnVisible(ColNum : Integer);
  {-insure that ColNum is visible}
var
  CW       : Integer;
  Idx      : Integer;
  FarRight : Integer;
  LeftIdx  : Integer;
  LColWd   : Integer;
begin
  ColNum := IncCol(ColNum, 0);

  {get the index for the column}
  Idx := VisibleColumns.IndexOf(ColNum);
  if Idx = -1 then
    {the column is not visible -- make this column the left column}
    LeftColumn := ColNum
  else begin
    CW := ClientWidth;
    FarRight := VisibleColumns[Idx].Offset + VisibleColumns[Idx].Width;
    if (FarRight > CW) then begin
      {the column is partially visible}
      {pretend that we're scrolling the table left, column by column, until
       either (1) the column we want is fully visible, or (2) the column we
       want is the leftmost column then set the leftmost column}
      LeftIdx := VisibleColumns.IndexOf(LeftColumn);
      if (LeftIdx >= 0) then begin
        LColWd := VisibleColumns[LeftIdx].Width;
        Dec(FarRight, LColWd);
      end;
      Inc(LeftIdx);

      while (LeftIdx < Idx) and (FarRight > CW) do begin
        LColWd := VisibleColumns[LeftIdx].Width;
        Dec(FarRight, LColWd);
        Inc(LeftIdx);
      end;
      if (LeftIdx < VisibleColumnCount) then
        LeftColumn := VisibleColumns[LeftIdx].Number;
    end;
  end;
end;

procedure TOvcCustomDbTable.MoveActiveCell(Command : Word);
  {-move cell based on the passed Command}
var
  I : Integer;
begin
  if tbIsDbActive then with DataLink do begin
    case Command of
      ccBotOfPage     :
        if ActiveRow < Pred(VisibleRowCount) then
          Scroll(Pred(VisibleRowCount)-ActiveRow);
      ccBotRightCell  :
        begin
          DataSet.Last;
          ActiveColumn := IncCol(Pred(ColumnCount), 0);
        end;
      ccDown          :
        Scroll(1);
      ccEnd           :
        ActiveColumn := IncCol(Pred(ColumnCount), 0);
      ccFirstPage     :
        DataSet.First;
      ccHome          :
        ActiveColumn := IncCol(LockedColumns, 0);
      ccLastPage      :
        DataSet.Last;
      ccLeft          :
        begin
          if InEditingState then
            tbActiveCell.CellEditor.Perform(CM_EXIT, 0, 0);
          I := IncCol(ActiveColumn, -1);
          if (I <> ActiveColumn) or not (dtoWrapAtEnds in Options) then
            ActiveColumn := I
          else begin
            if (ActiveRow = 0) then
              Scroll(-1)
            else
              ActiveRow := Pred(ActiveRow);
            ActiveColumn := Pred(ColumnCount);
          end;
        end;
      ccNextPage      :
        Scroll(VisibleRowCount);
      ccPageLeft      :
        tbMoveActCellPageLeft;
      ccPageRight     :
        tbMoveActCellPageRight;
      ccPrevPage      :
        Scroll(-VisibleRowCount);
      ccRight         :
        begin
          if InEditingState then
            tbActiveCell.CellEditor.Perform(CM_EXIT, 0, 0);
          I := IncCol(ActiveColumn, 1);
          if (I <> ActiveColumn) or not (dtoWrapAtEnds in Options) then
            ActiveColumn := I
          else begin
            if (ActiveRow = Pred(VisibleRowCount)) then
              Scroll(+1)
            else
              ActiveRow := Succ(ActiveRow);
            ActiveColumn := 0;
          end;
        end;
      ccTopLeftCell   :
        begin
          DataSet.First;
          ActiveColumn := IncCol(LockedColumns, 0);
        end;
      ccTopOfPage     :
        if ActiveRow > 0 then
          Scroll(-ActiveRow);
      ccUp            :
        Scroll(-1);
    end;
  end;
end;

procedure TOvcCustomDbTable.Notification(AComponent : TComponent; Operation : TOperation);
var
  I : Integer;
begin
  inherited Notification(AComponent, Operation);

  if (AComponent is TOvcBaseTableCell) and (Operation = opRemove) then begin
    if (FHeaderCell = TOvcBaseTableCell(AComponent)) then begin
      FHeaderCell.DecRefs;
      FHeaderCell := nil;
      HeaderOptions := HeaderOptions - [hoUseHeaderCell]
    end else if Assigned(FColumns) then
      FColumns.tcNotifyCellDeletion(TOvcBaseTableCell(AComponent));
  end;

  if (Operation = opRemove) and (FDataLink <> nil) then begin
    {was it our datasource or one of the associated TField objects}
    if (AComponent = tbDataSource) then begin
      VisibleColumns.Clear;
      DataSource := nil
    end else if (AComponent is TField) then begin
      for I := 0 to ColumnCount-1 do begin
        if TOvcDbTableColumn(Columns[I]).Field = AComponent then begin
          TOvcDbTableColumn(Columns[I]).Field := nil;
          TOvcDbTableColumn(Columns[I]).DefaultCell := nil;

          {delete the column}
          Columns.Delete(I);
          Break;
        end;
      end;
    end;
  end else if (Operation = opInsert) and (AComponent is TField) then begin
    {was a TField object added for our dataset}
    if (FDataLink <> nil) and not tbLoading(DataSource) then
      if (TField(AComponent).DataSet = FDataLink.DataSet) then
        tbLayoutChanged;
  end;
end;

procedure TOvcCustomDbTable.Paint;
var
  R           : Integer;
  ColIdx      : Integer;
  Indent      : Integer;
  SaveActive  : Integer;
  DataSize    : Integer;
  Indicator   : Integer;
  CR          : TRect;
  DR          : TRect;
  TR          : TRect;
  IR          : TRect;
  Clip        : TRect;
  Data        : Pointer;
  Fld         : TField;
  Col         : TOvcDbTableColumn;
  Cell        : TOvcBaseTableCell;
  CellAttr    : TOvcCellAttributes;
  GridPen     : TOvcGridPen;
  HBrushColor : TColor;
  HBrushStyle : TBrushStyle;
  ColIsLocked : Boolean;
  IsActiveRow : Boolean;
  WordWrap    : Boolean;
  S           : string;

  procedure DrawEffects(GridPen : TOvcGridPen; R : TRect);
  var
    BrushColor  : TColor;
  begin
    {check to see if there is a grid to display}
    if (GridPen.Effect <> geNone) then begin
      with Canvas do begin
        {Get ready to draw the cell's grid}
        BrushColor := Color;
        Brush.Color := BrushColor;
        Pen.Style := GridPen.Style;
        Pen.Width := 1;
        SetBkColor(Handle, ColorToRGB(BrushColor));

        {draw the left and top lines}
        if (GridPen.Effect = ge3D) then begin
          {set the pen color for the top & left}
          Pen.Color := GridPen.SecondColor;
          {draw the lines}
          MoveTo(R.Left, R.Bottom-1);
          LineTo(R.Left, R.Top);
          LineTo(R.Right, R.Top);
        end;

        {set the pen color for the bottom & right}
        Pen.Color := GridPen.NormalColor;

        {draw right line}
        if (GridPen.Effect <> geHorizontal) then begin
          MoveTo(R.Right-1, R.Top);
          LineTo(R.Right-1, R.Bottom);
        end;

        {draw bottom line}
        if (GridPen.Effect <> geVertical) then begin
          MoveTo(R.Left, R.Bottom-1);
          LineTo(R.Right, R.Bottom-1);
        end;
      end;
    end;
  end;

  procedure PaintString;
  begin
    {blank out the cell}
    Canvas.Brush.Color := CellAttr.caColor;
    Canvas.FillRect(DR);

    {if the cell is not invisible, draw the text}
    if (CellAttr.caAccess <> otxInvisible) then
      tbPaintString(DR, CellAttr, Indent, WordWrap, S);
  end;

begin
  if InEditingState and (tbActiveCell is TOvcTCComboBox) then begin
    {validate area occupied by combobox}
    GetWindowRect(tbActiveCell.EditHandle, CR);
    CR.TopLeft := ScreenToClient(CR.TopLeft);
    CR.BottomRight := ScreenToClient(CR.BottomRight);
    ValidateRect(Handle, @CR);

    {validate area occupied by combobox list}
    SendMessage(tbActiveCell.EditHandle, CB_GETDROPPEDCONTROLRECT, 0, NativeInt(@CR));
    CR.TopLeft := ScreenToClient(CR.TopLeft);
    CR.BottomRight := ScreenToClient(CR.BottomRight);
    ValidateRect(Handle, @CR);
  end;

  SaveActive := ActiveRow;
  CR := ClientRect;

  {set up the cell attribute record}
  FillChar(CellAttr, SizeOf(CellAttr), 0);
  CellAttr.caFont := tbCellAttrFont;

  {save brush properties}
  HBrushColor := Canvas.Brush.Color;
  HBrushStyle := Canvas.Brush.Style;

  {get the cliping region}
  GetClipBox(Canvas.Handle, Clip);

  {set up the cell attribute record}
  tbPainting := True;
  try
    TR := CR;

    {paint the header if enabled}
    if (hoShowHeader in HeaderOptions) then begin
      TR.Bottom := TR.Top + HeaderHeight;

      if Bool(IntersectRect(IR, TR, Clip)) then begin

        {if showing indicators, need to paint top/left bit}
        if (dtoShowIndicators in Options) then begin
          TR.Right := tbRowIndicatorWidth;

          {restore canvas properties}
          Canvas.Brush.Color := HBrushColor;
          Canvas.Brush.Style := HBrushStyle;
          Canvas.Pen.Style   := psSolid;

          {draw the indicator button face}
          DrawButtonFace(Canvas, TR, 1, bsNew, False, False, False);
        end;

        {get the gridpen for the header}
        GridPen := GridPenSet.LockedGrid;

        {set up the cell attribute record}
        CellAttr.caFont.Assign(Font);
        if Assigned(FHeaderCell) and (hoUseHeaderCell in HeaderOptions) then
          FHeaderCell.ResolveAttributes(-1, -1, CellAttr)
        else begin
          {default to table settings}
          CellAttr.caAccess := otxDefault;
          CellAttr.caAdjust := otaDefault;
          CellAttr.caColor := Colors.Locked;
          CellAttr.caFont.Assign(Font);
          CellAttr.caFontColor := Colors.LockedText;
          CellAttr.caFontHiColor := Colors.SelectedText;
          CellAttr.caTextStyle := TextStyle;
          ResolveCellAttributes(-1, -1, CellAttr);
        end;

        for ColIdx := 0 to Pred(VisibleColumnCount) do begin
          {get copy of this column object}
          Col := VisibleColumns[ColIdx];

          if not Assigned(Col) or Col.Hidden then
            Continue;

          {get remaining cell bounds}
          TR.Left := Col.Offset;
          TR.Right := TR.Left + Col.Width;

          {does this cell need painting}
          if not Bool(IntersectRect(IR, TR, Clip)) then
            Continue;

          {adjust cell rect for effects}
          DR := TR;
          case GridPen.Effect of
            geVertical  : Dec(DR.Right);
            geHorizontal: Dec(DR.Bottom);
            geBoth      : begin
                            Dec(DR.Right);
                            Dec(DR.Bottom);
                          end;
            ge3D        : InflateRect(DR, -1, -1);
          end;

          {get a copy of the field object}
          Fld := Col.Field;
          if not tbIsDbActive then
            Fld := nil
          else if Assigned(Fld) and (csDestroying in Fld.ComponentState) then
            Fld := nil;

          {blank out the header region}
          Canvas.Brush.Color := CellAttr.caColor;
          Canvas.FillRect(DR);

          {draw the header text}
          if Assigned(FHeaderCell) and (hoUseHeaderCell in HeaderOptions) then begin
            {force proper options in header cell}
            if (FHeaderCell is TOvcTCCustomColHead) then
              TOvcTCCustomColHead(FHeaderCell).ShowLetters := (hoUseLetters in FHeaderOptions);

            {draw header text using the header cell}
            if Assigned(Fld) and not (hoUseLetters in HeaderOptions) and
               not (hoUseStrings in HeaderOptions) then begin
              S := Fld.DisplayLabel;
              FHeaderCell.Paint(Canvas, DR, -1, Col.Number, CellAttr, PString(@S)); //SZ: TOvcTCCustomColHead.tcPaint (ovctchdr.pas) needs PString
            end else
              FHeaderCell.Paint(Canvas, DR, -1, Col.Number, CellAttr, nil);
          end else begin
            if Assigned(Fld) then
              S := Fld.DisplayLabel
            else
              S := '';

            if (CellAttr.caAccess <> otxInvisible) then
              tbPaintString(DR, CellAttr, DefaultMargin, False, S);
          end;

          DrawEffects(GridPen, TR);

          {restore canvas properties}
          Canvas.Brush.Color := HBrushColor;
          Canvas.Brush.Style := HBrushStyle;
          Canvas.Pen.Style   := psSolid;
        end;
      end;

      {reset for cell drawing}
      TR := CR;
      Inc(TR.Top, HeaderHeight);
    end;

    {paint visible rows and columns if invalid}
    Dec(TR.Top, RowHeight); {prepare for first row}
    for R := 0 to Pred(VisibleRowCount) do begin
      {set top of row}
      Inc(TR.Top, RowHeight);

      {flag to see if this is the active row}
      IsActiveRow := R = SaveActive;

      {adjust to one row height}
      TR.Bottom := TR.Top + RowHeight;

      {expand to full width so we can test the complete row}
      TR.Left := CR.Left;
      TR.Right := CR.Right;

      {is there anything in this row that needs painting?}
      if not Bool(IntersectRect(IR, TR, Clip)) then
        Continue;

      {display row indicators if enabled}
      if (dtoShowIndicators in Options) then begin
        TR.Right := tbRowIndicatorWidth;

        {draw the indicator button face}
        DrawButtonFace(Canvas, TR, 1, bsNew, False, False, False);

        if tbIsDbActive and IsActiveRow then begin
          Indicator := 0;
          if DataLink.DataSet <> nil then
            case DataLink.DataSet.State of
              dsEdit   : Indicator := 1;
              dsInsert : Indicator := 2;
            end;
          tbIndicators.BkColor := clBtnFace;
          tbIndicators.Draw(Canvas, FRowIndicatorWidth-tbIndicators.Width-3,
            (TR.Top + TR.Bottom - tbIndicators.Height) shr 1, Indicator);
        end;
      end;

      {move to appropriate db table record}
      if (DataLink <> nil) and tbIsDbActive then
        DataLink.ActiveRecord := R;

      for ColIdx := 0 to Pred(VisibleColumnCount) do begin
        {get copy of this column object}
        Col := VisibleColumns[ColIdx];

        if not Assigned(Col) or Col.Hidden then
          Continue;

        {is column locked}
        ColIsLocked := (Col.Number < LockedColumns);

        {get the gridpen for the cell}
        if ColIsLocked then
          GridPen := GridPenSet.LockedGrid
        else
          GridPen := GridPenSet.NormalGrid;

        {get remaining cell bounds}
        TR.Left := Col.Offset;
        TR.Right := TR.Left + Col.Width;

        {does this cell need painting}
        if not Bool(IntersectRect(IR, TR, Clip)) then
          Continue;

        {adjust cell rect for effects}
        DR := TR;
        case GridPen.Effect of
          geVertical  : Dec(DR.Right);
          geHorizontal: Dec(DR.Bottom);
          geBoth      : begin
                          Dec(DR.Right);
                          Dec(DR.Bottom);
                        end;
          ge3D        : InflateRect(DR, -1, -1);
        end;

        {don't do painting for the active cell if editing}
        if not (InEditingState and IsActiveRow and (Col.Number = ActiveColumn)) then begin
          {get a copy of the field object}
          Fld := Col.Field;
          if not tbIsDbActive then
            Fld := nil
          else if Assigned(Fld) and (csDestroying in Fld.ComponentState) then
            Fld := nil;

          {get text to draw}
          if Assigned(Fld) then
            S := Fld.DisplayText
          else
            S := '';

          {get copy of cell}
          Cell := Col.DefaultCell;

          WordWrap := False;
          if (Cell <> nil) then begin
            {set up the cell attribute record}
            CellAttr.caFont.Assign(Font);
            Cell.ResolveAttributes(R, Col.Number, CellAttr);
            if Cell is TOvcTCString then
              WordWrap := TOvcTCString(Col.DefaultCell).UseWordWrap;
            Indent := TLocalCell(Cell).Margin;
          end else begin
            {default to table settings}
            CellAttr.caAccess := otxDefault;
            CellAttr.caAdjust := otaDefault;
            CellAttr.caColor := Color;
            CellAttr.caFont.Assign(Font);
            CellAttr.caFontColor := Font.Color;
            CellAttr.caFontHiColor := Colors.SelectedText;
            CellAttr.caTextStyle := tsFlat;

            if Col.Number < LockedColumns then begin
              CellAttr.caColor := Colors.Locked;
              CellAttr.caFontColor := Colors.LockedText;
            end;

            Indent := DefaultMargin;

            {determine justification based on field properties}
            if Assigned(Fld) and not DataLink.DefaultFields then begin
              case Fld.Alignment of
                taLeftJustify  : CellAttr.caAdjust := otaCenterLeft;
                taRightJustify : CellAttr.caAdjust := otaCenterRight;
                taCenter       : CellAttr.caAdjust := otaCenter;
              end;
            end else if DataLink.DefaultFields and (Col.Number > -1)
                  and not (csDesigning in ComponentState) then begin
              if (DataLink.DataSet <> nil) and (FieldCount > 0) then
                case Fields[Col.Number].Alignment of
                  taLeftJustify  : CellAttr.caAdjust := otaCenterLeft;
                  taRightJustify : CellAttr.caAdjust := otaCenterRight;
                  taCenter       : CellAttr.caAdjust := otaCenter;
                end;

            end;

            ResolveCellAttributes(R, Col.Number, CellAttr);
          end;

          {paint the cell}
          if Assigned(Fld) and Assigned(Cell) and (Cell is TOvcTCBitmap) then
          begin
            {if cell is a bitmap - handle specially}
            if not tbPaintBitmapCell(Canvas, DR, CellAttr, Fld, Cell,
                   IsActiveRow and (Col.Number = ActiveColumn)) then
              PaintString;
          end else if Assigned(Fld) and Assigned(Cell) and (
             (Cell is TOvcTCCheckBox) or (Cell is TOvcTCGlyph) or
             (Cell is TOvcTCComboBox) or
             (dtoCellsPaintText in Options)) then begin
            {if cell is a checkbox, glyph, or combobox - handle specially}
            DataSize := tbGetDataSize(Cell);
            if DataSize > 0 then begin

              {allocate data buffer}
              tbGetMem(Data, Cell, Fld); // SZ GetMem(Data, DataSize);        //SZ: Data could contain string fields, this does not work correctly with GetMem
              try
                tbGetFieldValue(Fld, Cell, Data, DataSize);
                try
                  Cell.Paint(Canvas, DR, R, Col.Number, CellAttr, Data);
                except
                  on EInvalidDateForMask do begin
                    S := '********'; {invalid date value for epoch and mask}
                    PaintString;
                  end else
                    raise;
                end;
              finally
                tbFreeMem(Data, Cell, Fld); // FreeMem(Data {, DataSize});
              end;
            end else
              Cell.Paint(Canvas, DR, R, Col.Number, CellAttr, nil);
{ - begin}
          end else if Assigned(Fld) and Assigned(Cell)
          and (Cell is TOvcTCBaseEntryField) then begin
            DataSize := tbGetDataSize(Cell);
            if DataSize > 0 then begin

              {allocate data buffer}
              tbGetMem(Data, Cell, Fld); //SZ GetMem(Data, DataSize);
              try
                tbGetFieldValue(Fld, Cell, Data, DataSize);
                try
                  Cell.Paint(Canvas, DR, R, Col.Number, CellAttr, Data);
                except
                  on EInvalidPictureMask do begin
                    S := '********'; {invalid value for picturemask}
                    PaintString;
                  end else
                    raise;
                end;
              finally
                tbFreeMem(Data, Cell, Fld); //SZ FreeMem(Data {, DataSize});
              end;
            end else
              Cell.Paint(Canvas, DR, R, Col.Number, CellAttr, nil);
{ - end}
          end else
            PaintString;
        end;

        {draw the grid effects around the cell}
        DrawEffects(GridPen, TR);

        {restore canvas properties}
        Canvas.Brush.Color := HBrushColor;
        Canvas.Brush.Style := HBrushStyle;
        Canvas.Pen.Style   := psSolid;
      end;
    end;

    {restore db position}
    if (DataLink <> nil) and tbIsDbActive then
      DataLink.ActiveRecord := SaveActive;

    {restore canvas properties}
    Canvas.Brush.Color := HBrushColor;
    Canvas.Brush.Style := HBrushStyle;
    Canvas.Pen.Style   := psSolid;
    Canvas.Font := Font;

    {paint the unused areas}
    DoOnPaintUnusedArea;

    {draw the active table cell}
    tbDrawActiveCell(CellAttr);
  finally
    tbPainting := False;
  end;
end;

procedure TOvcCustomDbTable.ResolveCellAttributes(RowNum : TRowNum;
          ColNum : TColNum; var CellAttr : TOvcCellAttributes);
  {-obtain cell attributes}
var
  TempColor  : TColor;
begin
  with CellAttr do begin
    {calculate the access rights}
    if (caAccess = otxDefault) then
      caAccess := Access;

    {calculate the adjustment}
    if (caAdjust = otaDefault) then
      caAdjust := Adjust;

    {calculate the colors}
    TempColor := caColor;
    if (RowNum = ActiveRow) and (ColNum = ActiveColumn) then begin
      if (otsFocused in tbState) then begin
        if InEditingState or ((dtoAlwaysEditing in Options) and
                              (caAccess = otxNormal)) then begin
          TempColor := Colors.Editing;
          caFontColor := Colors.EditingText
        end else begin
          TempColor := Colors.ActiveFocused;
          caFontColor := Colors.ActiveFocusedText;
        end
      end else begin
        TempColor := Colors.ActiveUnfocused;
        caFontColor := Colors.ActiveUnfocusedText;
      end
    end else begin
      if (RowNum = ActiveRow) and (dtoHighlightActiveRow in Options) then begin
        if (otsFocused in tbState) then begin
          TempColor := Colors.ActiveFocused;
          caFontColor := Colors.ActiveFocusedText;
        end else begin
          TempColor := Colors.ActiveUnfocused;
          caFontColor := Colors.ActiveUnfocusedText;
        end;
      end else begin
        if (ColNum < LockedColumns) and (RowNum > -1 {not the header row}) then begin
          caFontColor := Colors.LockedText;
          TempColor := Colors.Locked
        end;
      end;
    end;
    caColor := TempColor;

    {if no cell assigned, use table's default text style}
    if ColNum > -1 then
      if (Columns[ColNum] <> nil) then
        if (Columns[ColNum].DefaultCell = nil) then
          caTextStyle := TextStyle;
  end;
  DoOnGetCellAttributes(RowNum, ColNum, CellAttr);
end;

function TOvcCustomDbTable.SaveEditedData : Boolean;
  {-save data to attached db field}
var
  Data     : Pointer;
  DataSize : Integer;
  Fld      : TField;
begin
  Result := True;
  if InEditingState then begin
    if DataLink.FieldCount > 0 then begin
      {exit if the cell was not modified}
      if not tbCellModified(tbActiveCell) then
        Exit;

      Result := tbActiveCell.CanSaveEditedData(True);
      if not Result then
        Exit;

      {figure out what data size should be}
      Fld := TOvcDbTableColumn(Columns[ActiveColumn]).Field;
      DataSize := tbGetDataSize(tbActiveCell);
      if DataSize = 0 then begin
        Result := False;
        Exit;
      end;

      {allocate data buffer}
      tbGetMem(Data, tbActiveCell, Fld); // GetMem(Data, DataSize);
      try
        {get data from cell}
        tbActiveCell.SaveEditedData(Data);

        {save data to field}
        tbSetFieldValue(Fld, tbActiveCell, Data, DataSize);
      finally
        tbFreeMem(Data, tbActiveCell, Fld); // FreeMem(Data {, DataSize});
      end;
    end;
  end;
end;

procedure TOvcCustomDbTable.Scroll(Delta : Integer);
  {-scroll the datasource by Delta (signed)}
begin
  if tbIsDbActive then
    DataLink.DataSet.MoveBy(Delta);
end;

procedure TOvcCustomDbTable.SetAccess(Value : TOvcTblAccess);
var
  TempAccess : TOvcTblAccess;
begin
  if (Value = otxDefault) then
    TempAccess := tbDefAccess
  else
    TempAccess := Value;

  if (TempAccess <> FAccess) then begin
    if (TempAccess = otxInvisible) or (FAccess = otxInvisible) then
      Invalidate;
    FAccess := TempAccess;
  end;
end;

procedure TOvcCustomDbTable.SetActiveCell(RowNum : Integer; ColNum : Integer);
  {-change the active cell to the specified row and column}
begin
  if VisibleColumnCount = 0 then
    Exit;

  {force valid row number}
  RowNum := IncRow(RowNum, 0);

  {force valid column number}
  ColNum := IncCol(ColNum, 0);

  if (RowNum <> ActiveRow) or (ColNum <> ActiveColumn) then begin
    if HandleAllocated then begin

      if InEditingState then
        if not StopEditing(True) then
          Exit;

      {invalidate the indicator column}
      InvalidateIndicators;

      {invalidate the old cell}
      InvalidateCell(FActiveRow, FActiveColumn);

      {scroll the data source if this change isn't due to a db scroll action}
      if tbIsDbActive and not tbScrolling and (RowNum <> FActiveRow) then begin
        tbScrolling := True;
        try
          Scroll(RowNum-FActiveRow);
        finally
          tbScrolling := False;
        end;
      end;

      {update the active column}
      FActiveColumn := ColNum;

      {and make it visible}
      if not tbScrolling then
        MakeColumnVisible(FActiveColumn);

      {update the active row}
      FActiveRow := RowNum;

      {invalidate the new cell}
      InvalidateCell(FActiveRow, FActiveColumn);

      {resume editing, if always editing}
      if (dtoAlwaysEditing in Options) then
        PostMessage(Handle, ctim_StartEdit, 0, 0);

      tbUpdateHScrollBar;
      tbUpdateVScrollBar;

      DoOnActiveCellChanged(RowNum, ColNum);
    end else begin
      FActiveRow := RowNum;
      FActiveColumn := ColNum;
    end;
  end;
end;

procedure TOvcCustomDbTable.SetActiveColumn(Value : Integer);
begin
  SetActiveCell(FActiveRow, Value);
end;

procedure TOvcCustomDbTable.SetActiveRow(Value : Integer);
begin
  SetActiveCell(Value, FActiveColumn);
end;

procedure TOvcCustomDbTable.SetAdjust(Value : TOvcTblAdjust);
var
  TempAdjust : TOvcTblAdjust;
begin
  if (Value = otaDefault) then
    TempAdjust := tbDefAdjust
  else
    TempAdjust := Value;

  if (TempAdjust <> FAdjust) then begin
    Invalidate;
    FAdjust := TempAdjust;
  end;
end;

procedure TOvcCustomDbTable.SetBorderStyle(Value : TBorderStyle);
begin
  if (Value <> BorderStyle) then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomDbTable.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  Changed  : Boolean;
  HH       : Integer;
begin
  Changed := (Width <> AWidth) or (Height <> AHeight);

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if Changed and HandleAllocated then begin
    {insure that table has room for header and one row}
    if (hoShowHeader in HeaderOptions) then
      HH := HeaderHeight
    else
      HH := 0;
    if ClientHeight < HH + RowHeight then begin
      ClientHeight := HH + RowHeight;
      {exit, since changing height will cause SetBounds to be called again}
      Exit;
    end;

    {see if we need to adjust for integral height}
    if tbAdjustIntegralHeight then
      {exit, since changing height will cause SetBounds to be called again}
      Exit;

    {recalc table data}
    tbCalcColumnsOnLastPage; {calls tbCalcRowColData(LeftColumn)}
    tbUpdateBufferLimit; {calls tbUpdateActive}
    tbUpdateHScrollBar;
    tbUpdateVScrollBar;
  end;
end;

function TOvcCustomDbTable.SetCellProperties(AField : TField;
          ACell : TOvcBaseTableCell) : Boolean;
  {-set the cell properties to match the field data type}
var
  Col : Integer;
begin
  Result := True;

  if (ACell is TOvcTCString) then begin
    TOvcTCString(ACell).MaxLength := AField.DisplayWidth;
    TOvcTCString(ACell).DataStringType := tstString;
  end else if (ACell is TOvcTCComboBox) then begin
    TOvcTCComboBox(ACell).UseRunTimeItems := False;

    {WideString Support}
    if AField.DataType in [ftString, ftWideString, ftSmallInt, ftInteger,
      ftWord] then begin
      if AField.DataType in [ftString, ftWideString] then

        TOvcTCComboBox(ACell).MaxLength := AField.DisplayWidth;
    end else
      Result := False;
  end else if (ACell is TOvcTCSimpleField) then begin
    case AField.DataType of

      {WideString Support}
      ftString, ftWideString :
        begin
          TOvcTCSimpleField(ACell).DataType := sftString;
          TOvcTCSimpleField(ACell).MaxLength := AField.DisplayWidth;
        end;
      ftSmallInt : TOvcTCSimpleField(ACell).DataType := sftInteger;
      ftInteger  : TOvcTCSimpleField(ACell).DataType := sftLongInt;
      ftWord     : TOvcTCSimpleField(ACell).DataType := sftWord;
      ftBoolean  : TOvcTCSimpleField(ACell).DataType := sftBoolean;
      ftFloat    : TOvcTCSimpleField(ACell).DataType := sftExtended;
      ftCurrency : TOvcTCSimpleField(ACell).DataType := sftExtended;
      ftBCD      : TOvcTCSimpleField(ACell).DataType := sftExtended;
    else
      Result := False;
    end;
  end else if (ACell is TOvcTCPictureField) then begin
    case AField.DataType of

      {WideString Support}
      ftString, ftWideString :
        begin
          TOvcTCPictureField(ACell).DataType := pftString;
          if Length(TOvcTCPictureField(ACell).PictureMask) >
             AField.DisplayWidth then
            TOvcTCPictureField(ACell).PictureMask :=
              Copy(TOvcTCPictureField(ACell).PictureMask, 1,
                   AField.DisplayWidth);
          TOvcTCPictureField(ACell).MaxLength := AField.DisplayWidth;
        end;
      ftSmallInt : TOvcTCPictureField(ACell).DataType := pftInteger;
      ftInteger  : TOvcTCPictureField(ACell).DataType := pftLongInt;
      ftWord     : TOvcTCPictureField(ACell).DataType := pftWord;
      ftBoolean  : TOvcTCPictureField(ACell).DataType := pftBoolean;
      ftFloat    : TOvcTCPictureField(ACell).DataType := pftExtended;
      ftCurrency : TOvcTCPictureField(ACell).DataType := pftExtended;
      ftBCD      : TOvcTCPictureField(ACell).DataType := pftExtended;
      ftDate     : TOvcTCPictureField(ACell).DataType := pftDate;
      ftTime     : TOvcTCPictureField(ACell).DataType := pftTime;
      ftDateTime :
        begin
          Col := tbGetFieldColumn(AField);
          if Col > -1 then
            case TOvcDbTableColumn(Columns[Col]).DateOrTime of
              dtUseDate : TOvcTCPictureField(ACell).DataType := pftDate;
              dtUseTime : TOvcTCPictureField(ACell).DataType := pftTime;
            end;
        end;
    else
      Result := False;
    end;
  end else if (ACell is TOvcTCNumericField) then begin
    case AField.DataType of
      ftSmallInt : TOvcTCNumericField(ACell).DataType := nftInteger;
      ftInteger  : TOvcTCNumericField(ACell).DataType := nftLongInt;
      ftWord     : TOvcTCNumericField(ACell).DataType := nftWord;
      ftFloat    : TOvcTCNumericField(ACell).DataType := nftExtended;
      ftCurrency : TOvcTCNumericField(ACell).DataType := nftExtended;
      ftBCD      : TOvcTCNumericField(ACell).DataType := nftExtended;
    else
      Result := False;
    end;
  end else if (ACell is TOvcTCBitmap) then
    Result := AField.DataType in [ftBlob, ftGraphic]
  else if (ACell is TOvcTCMemo) then
    Result := False  {not supported}
  else if (ACell is TOvcTCIcon) then
    Result := False  {not supported}
  else if (ACell is TOvcTCRowHead) then
    Result := False  {not supported}
  else if (ACell is TOvcTCCustomColHead) then
    Result := False  {not supported}
  else if (ACell is TOvcTCCheckBox) then
    Result := AField.DataType in [ftBoolean]
  else if (ACell is TOvcTCGlyph) then
    Result := AField.DataType in [ftSmallInt, ftInteger, ftWord, ftFloat,
      ftCurrency, ftBCD];

  {see if this is a supported special, user-defined, cell}
  Result := Result or ACell.SpecialCellSupported(AField);

  if Result then
    tbCellChanged(Self);
end;

procedure TOvcCustomDbTable.SetColumnCount(Value : Integer);
begin
  if (Value <> ColumnCount) then begin
    if (Value <= LockedColumns) then
      LockedColumns := 0;
    FColumns.Count := Value
  end;
end;

procedure TOvcCustomDbTable.SetColumnOrderStrings(const Cols : TStrings);
  {-set the order of the table columns}
var
  I, J : Integer;
begin
  {inform tbColumnChanged not to act on the following changes}
  tbRebuilding := True;
  try
    for I := 0 to ColumnCount - 1 do
      if (Cols[I] > '') then begin
        {see if we need to swap}
        if CompareText(Cols[I], TOvcDbTableColumn(Columns[I]).DataField) <> 0
        then begin
          {find index that has field to swap with}
          for J := I + 1 to Pred(ColumnCount) do
            if CompareText(Cols[I], TOvcDbTableColumn(Columns[J]).DataField) = 0
            then begin
              Columns.Exchange(I, J);
              Break;
            end;
        end;
      end;
  finally
    tbRebuilding := False;
  end;
  tbColumnChanged(Self, 0, 0, taGeneral);
end;

procedure TOvcCustomDbTable.SetColumnOrder(const Cols : array of string);
  {-set the order of the table columns}
var
  I, J : Integer;
begin
  {inform tbColumnChanged not to act on the following changes}
  tbRebuilding := True;
  try
    for I := Low(Cols) to High(Cols) do
      if (I >= 0) and (I < ColumnCount) and (Cols[I] > '') then begin
        {see if we need to swap}
        if CompareText(Cols[I], TOvcDbTableColumn(Columns[I]).DataField) <> 0 then begin
          {find index that has field to swap with}
          for J := I+1 to Pred(ColumnCount) do
            if CompareText(Cols[I], TOvcDbTableColumn(Columns[J]).DataField) = 0 then begin
              Columns.Exchange(I, J);
              Break;
            end;
        end;
      end;
  finally
    tbRebuilding := False;
  end;
  tbColumnChanged(Self, 0, 0, taGeneral);
end;

{-set the widths of the table columns}
procedure TOvcCustomDbTable.SetColumnWidthsStrings(const Cols : TStrings);
var
  I : Integer;
begin
  for I := 0 to Cols.Count-1 do
    if (I >= 0) and (I < ColumnCount) then
      if StrToInt(Cols[I]) >= 0 then
        Columns[I].Width := StrToInt(Cols[I]);
  Invalidate;
end;

{-set the widths of the table columns}
procedure TOvcCustomDbTable.SetColumnWidths(const Cols : array of Integer);
var
  I : Integer;
begin
  for I := Low(Cols) to High(Cols) do
    if (I >= 0) and (I < ColumnCount) then
      if Cols[I] >= 0 then
        Columns[I].Width := Cols[I];
  Invalidate;
end;

procedure TOvcCustomDbTable.SetColors(Value : TOvcTableColors);
begin
  FColors.Assign(Value);
end;

procedure TOvcCustomDbTable.SetColorUnused(Value : TColor);
begin
  if (Value <> ColorUnused) then begin
    FColorUnused := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomDbTable.SetColumns(Value : TOvcTableColumns);
begin
  FColumns.Free;
  FColumns := Value;
  FColumns.Table := Self;
end;

procedure TOvcCustomDbTable.SetDataSource(Value : TDataSource);
var
  I      : Integer;
  Active : Boolean;
begin
  tbDataSource := FDataLink.DataSource;
  FDataLink.DataSource := Value;

  {tell datasource to notify us when it is deleted}
  if Value <> nil then
    Value.FreeNotification(Self);

  {force remapping of columns and data fields}
  if not tbLoading(Value) then
    for I := 0 to Pred(ColumnCount) do
      TOvcDbTableColumn(Columns[I]).DataField := '';

  {get active status of datasource}
  Active := tbIsDbActive;

  {reset all fields to nil if datasource is not active or datasource was changed}
{  if (csDesigning in ComponentState) then begin}
    if (not Active) or (tbDataSource <> FDataLink.DataSource) then
      for I := 0 to Pred(ColumnCount) do begin
        TOvcDbTableColumn(Columns[I]).Field := nil;

        {clear cell assignments}
        if (Value = nil) then
          Columns[I].DefaultCell := nil;
      end;
{  end;}

  {update local copy for use in notification method}
  tbDataSource := FDataLink.DataSource;

  {tell the table about this change}
  SetLinkActive(Active);
end;

procedure TOvcCustomDbTable.SetDefaultMargin(Value : Integer);
begin
  if (Value <> FDefaultMargin) and (Value >= 2) then begin
    FDefaultMargin := Value;
    Invalidate;
  end;
end;

procedure TOvcCustomDbTable.SetLinkActive(Value : Boolean);
  {-notify of the active state of data link}
var
  I : Integer;
begin
  if not Value then begin
    if InEditingState then
      if not StopEditing(True) then
        Abort;
    LeftColumn := 0;
    SetActiveCell(0, LeftColumn);
  end;

  if (csDestroying in ComponentState) then
    Exit;

  {reset field information if datasource or dataset is nil}
  if not (csLoading in ComponentState) and HandleAllocated then
    if (DataSource = nil) or (DataSource.DataSet = nil) then begin
      for I := 0 to Pred(ColumnCount) do begin
        TOvcDbTableColumn(Columns[I]).Field := nil;
        TOvcDbTableColumn(Columns[I]).DataField := '';
      end;
    end;

  tbLayoutChanged;
  tbUpdateVScrollBar;
  tbUpdateHScrollBar;

  {resume editing, if always editing}
  if Value and (dtoAlwaysEditing in Options) then
    PostMessage(Handle, ctim_StartEdit, 0, 0);
end;

procedure TOvcCustomDbTable.SetHeaderCell(Value : TOvcBaseTableCell);
var
  DoIt : Boolean;
begin
  {see if this cell component makes sense as a header cell}
  if Assigned(Value) and not ((Value is TOvcTCString) or
     (Value is TOvcTCCustomColHead)) then
    if (csDesigning in ComponentState) then
      raise EOrpheusTable.Create(GetOrphStr(SCTableInvalidHeaderCell))
    else
      Exit;

  DoIt := False;
  if (Value <> FHeaderCell) then
    if Assigned(Value) then begin
      if (Value.References = 0) or ((Value.References > 0) and (Value.Table = Self)) then
        DoIt := True;
    end else
      DoIt := True;

  if DoIt then begin
    if Assigned(FHeaderCell) then
      FHeaderCell.DecRefs;
    FHeaderCell := Value;
    if Assigned(FHeaderCell) then begin
      if (FHeaderCell.References = 0) then
        FHeaderCell.Table := Self;
      FHeaderCell.IncRefs;

      {if this is a TOvcTCCustomColHead cell, trun off ShowLetters}
      if (FHeaderCell is TOvcTCCustomColHead) and (FHeaderCell.References = 1) then
        TOvcTCCustomColHead(FHeaderCell).ShowLetters := False;
    end;
    tbCellChanged(Self);
  end;

  if HandleAllocated then begin
    {update the datasource's buffer count}
    tbUpdateBufferLimit; {calls tbUpdateActive}
    tbCalcRowColData(LeftColumn);
    Invalidate;
    tbUpdateVScrollBar;
  end;
end;

procedure TOvcCustomDbTable.SetHeaderHeight(Value : Integer);
begin
  if (Value <> FHeaderHeight) and (Value > 0) then begin
    FHeaderHeight := Value;

    if (hoShowHeader in HeaderOptions) then
      Invalidate;

    if HandleAllocated then begin
      tbAdjustIntegralHeight;

      {update the datasource's buffer count}
      tbUpdateBufferLimit; {calls tbUpdateActive}
      tbCalcRowColData(LeftColumn);
      Invalidate;
      tbUpdateVScrollBar;
    end;
  end;
end;

procedure TOvcCustomDbTable.SetHeaderOptions(Value : TOvcHeaderOptionSet);
var
  Old : TOvcHeaderOptionSet;
begin
  if Value <> FHeaderOptions then begin

    {save previous value}
    Old := FHeaderOptions;

    FHeaderOptions := Value;

    if (csLoading in ComponentState) then
      Exit;

    if not HandleAllocated then
      Exit;

    {validate options}
    if not Assigned(FHeaderCell) then begin
      {if no header cell, can't have these options}
      Exclude(FHeaderOptions, hoUseHeaderCell);
      Exclude(FHeaderOptions, hoUseLetters);
      Exclude(FHeaderOptions, hoUseStrings);
      {will use field labels by default}
    end;

    if (hoUseHeaderCell in FHeaderOptions) then begin
      if (FHeaderCell is TOvcTCCustomColHead) then begin
        if (hoUseStrings in FHeaderOptions) and not (hoUseStrings in Old) then
          Exclude(FHeaderOptions, hoUseLetters);
        if (hoUseLetters in FHeaderOptions) and not (hoUseLetters in Old) then
          Exclude(FHeaderOptions, hoUseStrings)
      end else begin
        {must be a standard string field}
        Exclude(FHeaderOptions, hoUseLetters);
        Exclude(FHeaderOptions, hoUseStrings);
      end;
    end else begin
      Exclude(FHeaderOptions, hoUseLetters);
      Exclude(FHeaderOptions, hoUseStrings);
    end;

    {see if hoShowHeader has changed}
    if (hoShowHeader in Old) <> (hoShowHeader in FHeaderOptions) then begin
      tbAdjustIntegralHeight;

      {update the datasource's buffer count}
      tbUpdateBufferLimit; {calls tbUpdateActive}
      tbCalcRowColData(LeftColumn);
      Invalidate;
      tbUpdateVScrollBar;
    end;

    {see if hoUseLetters has changed}
    if (hoUseLetters in Old) <> (hoUseLetters in FHeaderOptions) then
      InvalidateHeader;

    {see if hoUseStrings has changed}
    if (hoUseStrings in Old) <> (hoUseStrings in FHeaderOptions) then
      InvalidateHeader;

    {see if hoUseHeaderCell has changed}
    if (hoUseHeaderCell in Old) <> (hoUseHeaderCell in FHeaderOptions) then
      InvalidateHeader;
  end;
end;

procedure TOvcCustomDbTable.SetLeftColumn(Value : Integer);
begin
  {ensure that column is not hidden}
  Value := IncCol(Value, 0);
  if (Value > tbLastLeftCol) then
    Value := tbLastLeftCol;

  if Value < 0 then
    Exit;

  if Value <> FLeftColumn then begin
    if Value > FLeftColumn then
      tbScrollTableLeft(Value)
    else
      tbScrollTableRight(Value);

    tbUpdateHScrollBar;
  end;
end;

procedure TOvcCustomDbTable.SetLockedColumns(Value : Integer);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    FLockedColumns := Value
  else begin
    if (Value <> FLockedColumns) then begin
      if (Value >= 0) and (Value < ColumnCount) then begin
        FLockedColumns := Value;

        tbCalcColumnsOnLastPage; {calls tbCalcRowColData(LeftColumn)}

        {this will adjust for the new locked col}
        SetLeftColumn(LeftColumn);

        if csDesigning in ComponentState then
          ActiveColumn := FLockedColumns
        else if (ActiveColumn < Value) then
          ActiveColumn := LeftColumn;

        tbUpdateHScrollBar;
        tbUpdateVScrollBar;
        Invalidate;
      end;
    end;
  end;
end;

procedure TOvcCustomDbTable.SetOptions(Value : TOvcDbTableOptionSet);
var
  Old : TOvcDbTableOptionSet;
begin
  if Value <> FOptions then begin
    Old := FOptions;
    FOptions := Value;

    if (csLoading in ComponentState) then
      Exit;

    if not HandleAllocated then
      Exit;

    {see if dtoAlwaysEditing was turned on}
    if not (dtoAlwaysEditing in Old) and (dtoAlwaysEditing in FOptions) then
      PostMessage(Handle, ctim_StartEdit, 0, 0);

    {see if dtoAlwaysEditing was turned off}
    if (dtoAlwaysEditing in Old) and
       not (dtoAlwaysEditing in FOptions) then begin
      Application.ProcessMessages;
      if InEditingState then
        StopEditing(True);
    end;

    {see if dtoHighlightActiveRow has changed}
    if (dtoHighlightActiveRow in Old) <> (dtoHighlightActiveRow in FOptions) then
      if not InEditingState then
        InvalidateRow(ActiveRow);

    {see if dtoShowIndicator has changed}
    if (dtoShowIndicators in Old) <> (dtoShowIndicators in FOptions) then begin
      if (dtoShowIndicators in FOptions) then begin
        {at design-time, automatically set width}
        if (csDesigning in ComponentState) and (FRowIndicatorWidth = 0) then
          FRowIndicatorWidth := 11;

        tbRowIndicatorWidth := FRowIndicatorWidth
      end else
        tbRowIndicatorWidth := 0;

      tbCalcRowColData(LeftColumn);
      Invalidate;
      tbUpdateHScrollBar;
    end;

    {see if dtoShowPictures has changed}
    if (dtoShowPictures in Old) <> (dtoShowPictures in FOptions) then
      Invalidate;

    {see if dtoStretch has changed}
    if (dtoStretch in Old) <> (dtoStretch in FOptions) then
      Invalidate;

    {see if dtoIntegralHeight has changed}
    if (dtoIntegralHeight in Old) <> (dtoIntegralHeight in FOptions) then
      tbAdjustIntegralHeight;

    {see if dtoCellsPaintText has changed}
    if (dtoCellsPaintText in Old) <> (dtoCellsPaintText in FOptions) then
      Invalidate;
  end;
end;

procedure TOvcCustomDbTable.SetRowHeight(Value : Integer);
begin
  if Value <> FRowHeight then begin
    FRowHeight := Value;

    if HandleAllocated then begin
      tbAdjustIntegralHeight;

      {update the datasource's buffer count}
      tbUpdateBufferLimit; {calls tbUpdateActive}
      tbCalcRowColData(LeftColumn);
      Invalidate;
      tbUpdateVScrollBar;
    end;
  end;
end;

procedure TOvcCustomDbTable.SetRowIndicatorWidth(Value : Integer);
begin
  if (Value <> FRowIndicatorWidth) and (Value >= 0) then begin
    FRowIndicatorWidth := Value;

    if not HandleAllocated then
      Exit;

    {at design-time, automatically toggle the show state}
    if csDesigning in ComponentState then begin
      if FRowIndicatorWidth = 0 then
        Exclude(FOptions, dtoShowIndicators)
      else
        Include(FOptions, dtoShowIndicators);
    end;

    if (dtoShowIndicators in Options) then
      tbRowIndicatorWidth := FRowIndicatorWidth
    else
      tbRowIndicatorWidth := 0;

    tbCalcRowColData(LeftColumn);
    Invalidate;
    tbUpdateHScrollBar;
    tbUpdateVScrollBar;
  end;
end;

procedure TOvcCustomDbTable.SetScrollBars(Value : TScrollStyle);
begin
  if (Value <> FScrollBars) then begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomDbTable.SetSelectedField(Value : TField);
var
  I: Integer;
begin
  for I := 0 to FieldCount - 1 do
    if Fields[I] = Value then begin
      ActiveColumn := I;
      Break;
    end;
end;

procedure TOvcCustomDbTable.SetTextStyle(Value : TOvcTextStyle);
begin
  if Value <> FTextStyle then begin
    FTextStyle := Value;
    Invalidate;
  end;
end;

function TOvcCustomDbTable.StartEditing : Boolean;
  {begin editing mode}
var
  DataSize   : Integer;
  CellRect   : TRect;
  Data       : Pointer;
  Fld        : TField;
  BrushColor : TColor;
  CellAttr   : TOvcCellAttributes;
begin
  Result := InEditingState;

  {exit if already editing}
  if Result then
    Exit;

  {exit if we are designing}
  if (csDesigning in ComponentState) then
    Exit;

  {exit if no datasource is assigned}
  if (DataSource = nil) then
    Exit;

  {see if a cell editor is assigned}
  tbActiveCell := tbFindCell(ActiveColumn);
  if not Assigned(tbActiveCell) then
    Exit;

  {is this one of our supported field types or a special cell}
  Fld := TOvcDbTableColumn(Columns[ActiveColumn]).Field;
  if not Assigned(Fld) or
     not ((Fld.DataType in SupportedFieldTypes) or
     tbActiveCell.SpecialCellSupported(Fld)) then begin
    tbActiveCell := nil;
    Exit;
  end;

  {force focus to table}
  if not Focused then
    tbSetFocus(Handle);
  Include(tbState, otsFocused);

  {make sure the column is visible}
  MakeColumnVisible(ActiveColumn);

  if Assigned(tbActiveCell) then begin
    FillChar(CellAttr, SizeOf(CellAttr), 0);
    CellAttr.caFont := TFont.Create;
    try
      CellAttr.caFont.Assign(Font);
      tbActiveCell.ResolveAttributes(ActiveRow, ActiveColumn, CellAttr);
      if (CellAttr.caAccess = otxNormal) then begin
        {see if field can be modified}
        try
          Result := tbCanModify;
        except
          tbActiveCell := nil;
          raise;
        end;

        {exit if the datasource couldn't enter edit mode}
        if not Result then begin
          tbActiveCell := nil;
          Exit;
        end;

        {invalidate the indicator column}
        InvalidateIndicators;

        if tbCalcActiveCellRect(CellRect) then begin
          Exclude(tbState, otsNormal);
          CellAttr.caColor := Colors.Editing;
          CellAttr.caFontColor := Colors.EditingText;

          {figure out what data size should be}
          DataSize := tbGetDataSize(tbActiveCell);
          if DataSize = 0 then begin
            tbActiveCell := nil;
            Result := False;
            Exit;
          end;

          {handle clearing of rect for combobox cells}
          if (tbActiveCell is TOvcTCComboBox) then begin
            {clear cell area for combo box cells}
            BrushColor := Canvas.Brush.Color;
            Canvas.Brush.Color := Color;
            Canvas.FillRect(CellRect);
            Canvas.Brush.Color := BrushColor;
          end;

          {allocate data buffer}
          tbGetMem(Data, tbActiveCell, Fld); //SZ GetMem(Data, DataSize);
          try
            {get the field value for the entry field}
            tbGetFieldValue(Fld, tbActiveCell, Data, DataSize);

            {tell the cell to start editing}
            tbActiveCell.StartEditing(ActiveRow, ActiveColumn, CellRect,
                                      CellAttr, tesNormal, Data);
          finally
            tbFreeMem(Data, tbActiveCell, Fld); //SZ FreeMem(Data {, DataSize});
          end;

          Result := (tbActiveCell.EditHandle <> 0);

          {give the cell the focus}
          if Result then begin
            tbSetFocus(tbActiveCell.EditHandle);
            Include(tbState, otsEditing);
          end;
        end;
      end else
        tbActiveCell := nil;
    finally
      CellAttr.caFont.Free;
    end;
  end;
end;

function TOvcCustomDbTable.StopEditing(SaveValue : Boolean) : Boolean;
  {-end edit mode and optionally save the edited value}
var
  MustFocus : Boolean;
  Data      : Pointer;
  DataSize  : Integer;
  Fld       : TField;
begin
  Result := True;

  {if not editing, exit}
  if not InEditingState then
    Exit;

  if (FDataLink.DataSet = nil) then
    Exit;

  {if we can't stop, exit}
  Result := False;
  if (not tbActiveCell.CanStopEditing(SaveValue)) then
    Exit;

  Result := True;
  MustFocus := tbEditCellHasFocus(GetFocus);
  tbState := tbState - [otsEditing] + [otsNormal];

  {figure out what data size should be}
  Fld := TOvcDbTableColumn(Columns[ActiveColumn]).Field;
  DataSize := tbGetDataSize(tbActiveCell);
  if SaveValue and (DataSize > 0) and tbCellModified(tbActiveCell) then begin

    {allocate data buffer}
    tbGetMem(Data, tbActiveCell, Fld); //SZ GetMem(Data, DataSize);
    try
      tbActiveCell.StopEditing(SaveValue, Data);
      {save the "Data" to the TField object}
      tbSetFieldValue(Fld, tbActiveCell, Data, DataSize);

      {update the database}
      if FDataLink.DataSet.State in [dsEdit, dsInsert] then
        FDataLink.UpdateRecord;
    finally
      tbFreeMem(Data, tbActiveCell, Fld); //SZ FreeMem(Data {, DataSize});
    end;
  end else
    tbActiveCell.StopEditing(False, nil);

  tbActiveCell := nil;

  {invalidate the active cell}
  InvalidateCell(ActiveRow, ActiveColumn);

  {invalidate the indicator column}
  InvalidateIndicators;

  {give table the focus}
  if MustFocus then
    SetFocus;
end;

function TOvcCustomDbTable.tbAdjustIntegralHeight : Boolean;
var
  R  : Integer;
  HH : Integer;
begin
  Result := False;
  if not (dtoIntegralHeight in Options) then
    Exit;

  if (hoShowHeader in HeaderOptions) then
    HH := HeaderHeight
  else
    HH := 0;

  R := (ClientHeight - HH) div RowHeight;
  if (ClientHeight - HH) mod RowHeight <> 0 then begin
    {shrink to an integral height}
    ClientHeight := HH + R * RowHeight;
    Result := True;
  end;
end;

function  TOvcCustomDbTable.tbCalcActiveCellRect(var ACR : TRect) : Boolean;
  {-calculate the bounds of the active cell}
begin
  Result := False;

  {get basic boundry}
  ACR := tbCalcCellRect(ActiveRow, ActiveColumn);

  {exit if cell is off screen}
  if (ACR.Bottom = 0) or (ACR.Right = 0) then
    Exit;

  Result := True;
  with GridPenSet.NormalGrid do begin
    case Effect of
      geVertical   : Dec(ACR.Right);
      geHorizontal : Dec(ACR.Bottom);
      geBoth       : begin
                       Dec(ACR.Right);
                       Dec(ACR.Bottom);
                     end;
      ge3D         : InflateRect(ACR, -1, -1);
    end;
  end;
end;

function TOvcCustomDbTable.tbCalcCellRect(RowNum, ColNum : Integer) : TRect;
  {-return the bounds of the specified cell}
var
  Idx : Integer;
begin
  FillChar(Result, SizeOf(Result), #0);

  if (RowNum >= 0) and (RowNum < VisibleRowCount) then begin
    Idx := VisibleColumns.IndexOf(ColNum);
    if (Idx > -1) and (Idx < VisibleColumnCount) then begin
      Result.Left := VisibleColumns[Idx].Offset;
      Result.Top := tbCalcRowTop(RowNum);
      Result.Bottom := Result.Top + RowHeight;
      Result.Right := Result.Left + VisibleColumns[Idx].Width;
    end;
  end;
end;

function TOvcCustomDbTable.tbCalcColumnRect(ColNum : Integer) : TRect;
  {-return the bounds of the specified column}
var
  Idx : Integer;
begin
  FillChar(Result, SizeOf(Result), $FF);
  Idx := VisibleColumns.IndexOf(ColNum);
  if (Idx > -1) and (Idx < VisibleColumnCount) then begin
    Result.Top := 0;
    Result.Bottom := tbCalcRowBottom(Pred(VisibleRowCount));
    Result.Left := VisibleColumns[Idx].Offset;
    Result.Right := Result.Left + VisibleColumns[Idx].Width;
  end;
end;

procedure TOvcCustomDbTable.tbCalcColumnsOnLastPage;
  {-determine the number of columns that fit on the last page}
var
  OldLeftCol : Integer;
  NewLeftCol : Integer;
  StillGoing : Boolean;
begin
  if ColumnCount < 1 then
    Exit;

  NewLeftCol := IncCol(Pred(ColumnCount), 0);
  tbCalcRowColData(NewLeftCol);

  if VisibleColumns.RightEdge >= ClientWidth then begin
    {only this column fits}
    tbLastLeftCol := NewLeftCol;

    {restore column data}
    tbCalcRowColData(ActiveColumn);

    Exit;
  end;

  repeat
    OldLeftCol := NewLeftCol;
    NewLeftCol := IncCol(NewLeftCol, -1);
    if (NewLeftCol = OldLeftCol) then
      StillGoing := False
    else begin
      tbCalcRowColData(NewLeftCol);
      StillGoing := VisibleColumns.RightEdge < ClientWidth;
    end;
  until not StillGoing;
  tbLastLeftCol := OldLeftCol;

  {restore column data}
  tbCalcRowColData(LeftColumn);
end;

procedure TOvcCustomDbTable.tbCalcRowColData(NewLeftCol : Integer);
  {-calculate the row and column information for the new column}
var
  X            : Integer;
  Width        : Integer;
  ColNum       : Integer;
  FullWidth    : Integer;
  PredColCount : Integer;
  PredLocked   : Integer;
  Idx          : Integer;
  Access       : TOvcTblAccess;
  Hidden       : Boolean;
begin
  X := tbRowIndicatorWidth;
  Idx := -1;
  ColNum := -1;

  {avoid forcing window handle creation}
  if HandleAllocated then
    FullWidth := ClientWidth
  else
    FullWidth := Width;

  PredColCount := Pred(ColumnCount);
  PredLocked := Pred(LockedColumns);

  {clear the visible columns}
  VisibleColumns.Clear;

  {deal with the locked columns first}
  if (LockedColumns <> 0) then begin
    while (X < FullWidth) and (ColNum < PredLocked) do begin
      Inc(ColNum);
      tbQueryColData(ColNum, Width, Access, Hidden);
      if not Hidden then begin
        VisibleColumns.Add(ColNum);
        Inc(Idx);
        VisibleColumns[Idx].Offset := X;
        Inc(X, Width);
      end;
    end;
  end;

  {now deal with the rightmost columns}
  ColNum := Pred(NewLeftCol);
  if NewLeftCol >= 0 then
    while (X < FullWidth) and (ColNum < PredColCount) do begin
      Inc(ColNum);
      tbQueryColData(ColNum, Width, Access, Hidden);
      if not Hidden then begin
        VisibleColumns.Add(ColNum);
        Inc(Idx);
        VisibleColumns[Idx].Offset := X;
        Inc(X, Width);
      end;
    end;

  {store the right-most edge position}
  VisibleColumns.RightEdge := X;

  tbUpdateBufferLimit; {calls tbUpdateActive}
end;

function TOvcCustomDbTable.tbCalcRowRect(RowNum : Integer) : TRect;
  {-return the bounds of the specified row}
begin
  Result.Top := tbCalcRowTop(RowNum);
  Result.Bottom := Result.Top + RowHeight;
  Result.Left := tbRowIndicatorWidth;
  Result.Right := VisibleColumns.RightEdge;
end;

function TOvcCustomDbTable.tbCalcRowTop(RowNum : Integer) : Integer;
  {-return the top pixel position for RowNum. -1 if invalid}
begin
  Result := -1;
  if (RowNum >= 0) and (RowNum < VisibleRowCount) then begin
    Result := RowNum * RowHeight;
    if (hoShowHeader in HeaderOptions) then
      Inc(Result, HeaderHeight);
  end;
end;

function TOvcCustomDbTable.tbCalcRowBottom(RowNum : Integer) : Integer;
  {-return the bottom pixel position for RowNum. -1 if invalid}
begin
  Result := tbCalcRowTop(RowNum);
  if Result > -1 then
    Inc(Result, RowHeight);
end;

procedure TOvcCustomDbTable.tbCalcVisibleRows;
  {-number of rows that fit within the client height - not counting the header}
var
  HH : Integer;
begin
  {does not include the header row!}
  if (hoShowHeader in HeaderOptions) then
    HH := HeaderHeight
  else
    HH := 0;

  FVisibleRowCount := (ClientHeight - HH) div RowHeight;
  if FVisibleRowCount < 1 then
    FVisibleRowCount := 1;
end;

function TOvcCustomDbTable.tbCanModify : Boolean;
  {-enter db edit mode and return True if successful}
var
  Cell : TOvcBaseTableCell;
begin
  Result := False;

  {can't edit if not cell assigned or bitmaps and icons}
  Cell := tbFindCell(ActiveColumn);
  if (Cell = nil) or (Cell is TOvcTCBitmap) or (Cell is TOvcTCIcon) then
    Exit;

  if tbIsDbActive and not FDatalink.Readonly and
    (FieldCount > 0) and Fields[ActiveColumn].CanModify then begin
    if DataSource.AutoEdit then
      repeat
        try
          FDatalink.Edit;
          Break;
        except
          on EDataBaseError do begin
            {tell WMSetFocus that we caused the focus change}
            tbDisplayedError := True;
            if MessageDlg(GetOrphStr(SCCantEdit), mtError,
               [mbAbort, mbRetry], 0) <> mrRetry then begin
              {tell WMSetFocus that we caused the focus change}
              tbDisplayedError := True;
              raise;
            end;
          end
        end
      until False;

    Result := FDatalink.Editing;
    if Result then
      FDatalink.Modified;
  end;
end;

procedure TOvcCustomDbTable.tbCellChanged(Sender : TObject);
  {-notification of a cell change}
begin
  if ((ComponentState * [csLoading, csDestroying]) <> []) then
    Exit;

  Invalidate;
end;

function TOvcCustomDbTable.tbCellModified(Cell : TOvcBaseTableCell) : Boolean;
begin
  Result := False;
  if not Assigned(Cell) then
    Exit;

  if (Cell is TOvcTCSimpleField) or (Cell is TOvcTCPictureField) or
     (Cell is TOvcTCNumericField) then
    Result := TOvcTCBaseEntryField(Cell).Modified
  else if (Cell is TOvcTCString) then
    Result := TOvcTCString(Cell).Modified
  else if (Cell is TOvcTCMemo) then
    Result := TOvcTCMemo(Cell).Modified
  else if (Cell is TOvcTCBitmap) then
    Result := False {no editing allowed}
  else if (Cell is TOvcTCIcon) then
    Result := False {no editing allowed}
  else
    Result := True;
end;

procedure TOvcCustomDbTable.tbColorsChanged(Sender : TObject);
  {-notification of a color change}
begin
  if ((ComponentState * [csLoading, csDestroying]) <> []) then
    Exit;

  Invalidate;
end;

function TOvcCustomDbTable.tbColumnAtRight : Integer;
  {-return the index of the column at the right edge of the table}
var
  Count : Integer;
begin
  Count := VisibleColumnCount;
  Result := VisibleColumns[Pred(Count)].Number;
end;

procedure TOvcCustomDbTable.tbColumnChanged(Sender : TObject; C1, C2 : Integer;
  Action : TOvcTblActions);
  {-notification of a column change}
var
  DoIt : Boolean;
begin
  if (csLoading in ComponentState) then
    Exit;

  if (csDestroying in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  if tbRebuilding then
    Exit;

  if VisibleColumnCount = 0 then
    Exit;

  {decide whether there's anything to do to the visible display}
  DoIt := False;
  case Action of
    taGeneral :
      DoIt := True;
    taSingle  :
      begin
        DoIt := (VisibleColumns[0].Number <= C1) and
                (C1 <= VisibleColumns[Pred(VisibleColumnCount)].Number);
        {check for unhiding a column after all others}
        if not DoIt then
          DoIt :=
            (C1 > VisibleColumns[Pred(VisibleColumnCount)].Number) and
            (ClientWidth > VisibleColumns.RightEdge);
      end;
    taAll     :
      DoIt := True;
    taInsert  :
      begin
        DoIt := (VisibleColumns[0].Number <= C1) and
                (C1 <= VisibleColumns[Pred(VisibleColumnCount)].Number);
        {check for appending a column}
        if not DoIt then
          DoIt := (C1 > VisibleColumns[Pred(VisibleColumnCount)].Number) and
                  (ClientWidth > VisibleColumns.RightEdge);
        tbCalcRowColData(LeftColumn);
        tbLayOutChanged;
      end;
    taDelete  :
      begin
        tbCalcRowColData(0);
        if VisibleColumnCount > 0 then
          DoIt := (VisibleColumns[0].Number <= C1) and
                  (C1 <= VisibleColumns[Pred(VisibleColumnCount)].Number)
        else
          DoIt := True;
        tbCalcRowColData(LeftColumn);
        tbLayOutChanged;
      end;
    taExchange:
      begin
        DoIt := (VisibleColumns[0].Number <= C1) and
                (C1 <= VisibleColumns[Pred(VisibleColumnCount)].Number);
        if not DoIt then
          DoIt := (VisibleColumns[0].Number <= C2) and
                  (C2 <= VisibleColumns[Pred(VisibleColumnCount)].Number);
        tbCalcRowColData(LeftColumn);
        tbLayOutChanged;
      end;
  end;

  {exit if nothing to do}
  if not DoIt then
    Exit;

  tbCalcColumnsOnLastPage; {calls tbCalcRowColData(LeftColumn)}

  {the column could have changed because it was hidden or deleted...
   ...must make sure that LeftColumn and ActiveColumn haven't
      been hidden as well.}
  if (Action = taSingle) or (Action = taDelete) then begin
      if (C1 = LeftColumn) then
        SetLeftColumn(LeftColumn);
      if (C1 = ActiveColumn) then
        SetActiveColumn(ActiveColumn);
  end;

  {update the scrollbar}
  tbUpdateHScrollBar;

  {adjust left column if all columns will fit}
  if (LeftColumn > tbLastLeftCol) then
    LeftColumn := tbLastLeftCol;

  {redisplay the table}
  Invalidate;
end;

procedure TOvcCustomDbTable.tbDataChanged;
begin
  if not HandleAllocated or tbPainting then
    Exit;

  if (csDestroying in ComponentState) then
    Exit;

  Invalidate;

  {update the datasource's buffer count}
  tbUpdateBufferLimit; {calls tbUpdateActive}
  tbUpdateVScrollBar;

  {change the active row}
  tbScrolling := True;
  try
    tbUpdateActive;
  finally
    tbScrolling := False;
  end;
end;

procedure TOvcCustomDbTable.tbDefineFieldMap;
  {-define mapping between columns and field names}
var
  I    : Integer;
  DoIt : Boolean;
begin
  if (DataSource = nil) or (FDataLink.DataSet = nil) then
    Exit;

  {see if columns need to be rebuilt}
  if FDataLink.FMapBuilt and (FDataLink.DataSet <> nil) then
    DoIt := (ColumnCount <> FDataLink.DataSet.FieldCount) or
            (FieldCount <> FDataLink.DataSet.FieldCount) or
            (ColumnCount = 0)
  else
    DoIt := False;

  {clear the mapping between the column field names and the dataset's field}
  FDataLink.ClearFieldMappings;

  {see if any field names have changed - we set DataField to '' after a name change}
  if not DoIt then begin
    for I := 0 to Pred(ColumnCount) do
      if (TOvcDbTableColumn(Columns[I]).DataField = '') then begin
        DoIt := True;
        Break;
      end;
  end;

  if DoIt then
    tbRebuildColumns;

  {remap the columns to fields}
  for I := 0 to Pred(ColumnCount) do begin
    TOvcDbTableColumn(Columns[I]).Field := nil;
    DataLink.AddMapping(TOvcDbTableColumn(Columns[I]).DataField);
  end;
end;

procedure TOvcCustomDbTable.tbDrawActiveCell(CellAttr : TOvcCellAttributes);
  {-draw the active cell}
var
  Row          : Integer;
  Col          : Integer;
  RowOfs       : Integer;
  ColOfs       : Integer;
  Ht           : Integer;
  Wd           : Integer;
  Idx          : Integer;
  ActRowOfs    : Integer;
  ActRowBottom : Integer;
  ActColOfs    : Integer;
  ActColRight  : Integer;
  GridPen      : TOvcGridPen;
  BrushColor   : TColor;
  CellRect     : TRect;
  R            : TRect;
  DrawItFocused: Boolean;
begin
  {get index of the active cell}
  Idx := VisibleColumns.IndexOf(ActiveColumn);

  {If we are in editing mode, display the editing control for the
   cell, otherwise, draw the focus box around the cell contents}
  if InEditingState then begin
    {hide the edit cell if it is off the visible table}
    if (Idx = -1) or not tbCalcActiveCellRect(CellRect) then
      tbActiveCell.EditHide
    else begin
      tbActiveCell.EditMove(CellRect);
      UpdateWindow(tbActiveCell.EditHandle);

      {clear exposed portion of the cell area under the combo box}
      if (tbActiveCell is TOvcTCComboBox) then begin
        {validate the cell area}
        ValidateRect(Handle, @CellRect);

        {get the area of the combobox}
        GetWindowRect(tbActiveCell.EditHandle, R);
        R.TopLeft := ScreenToClient(R.TopLeft);
        R.BottomRight := ScreenToClient(R.BottomRight);

        {validate area under the combobox (may cover more than one cell)}
        if CalcRowCol(R.Left, R.Bottom, Row, Col) = otrInMain then begin
          R := tbCalcCellRect(Row, Col);
          ValidateRect(Handle, @R);
        end;

        {adjust R so that it is the area below the combobox in this cell}
        R.Top := R.Bottom;
        R.Left := CellRect.Left;
        R.BottomRight := CellRect.BottomRight;

        {and clear this area}
        if R.Top < R.Bottom then begin
          BrushColor := Canvas.Brush.Color;
          Canvas.Brush.Color := CellAttr.caColor;
          Canvas.FillRect(R);
          Canvas.Brush.Color := BrushColor;
        end;

        {since the active cell is always the last to be painted}
        {validate the complete column to avoid multiple repaints}
        {because of the combobox extending below the cell area}
        R := tbCalcColumnRect(ActiveColumn);
        R.Bottom := {Client}Height;
        ValidateRect(Handle, @R);

        {this is needed under NT 3.51}
        InvalidateRect(tbActiveCell.EditHandle, nil, False);
        UpdateWindow(tbActiveCell.EditHandle);
      end;
    end;
  end else begin
    {exit if active cell is not visible}
    if Idx = -1 then
      Exit;

    {draw the box round the cell}
    ActRowOfs    := 0;
    ActRowBottom := 0;
    ActColOfs    := 0;
    ActColRight  := 0;

    with Canvas do begin
      {get the correct grid pen}
      if (otsFocused in tbState) then begin
        GridPen := GridPenSet.CellWhenFocused;
        DrawItFocused := True;
      end else begin
        GridPen := GridPenSet.CellWhenUnfocused;
        DrawItFocused := False;
      end;

      if GridPen.Effect = geNone then
        Exit;

      RowOfs := tbCalcRowTop(ActiveRow);
      ColOfs := VisibleColumns[Idx].Offset;
      Ht := RowHeight;
      Wd := VisibleColumns[Idx].Width;

      {calculate where to draw the vertical/horizontal lines}
      case GridPenSet.NormalGrid.Effect of
        geNone      : begin
                        ActRowOfs := RowOfs;
                        ActRowBottom := RowOfs+Ht-1;
                        ActColOfs := ColOfs;
                        ActColRight := ColOfs+Wd-1
                      end;
        geVertical  : begin
                        ActRowOfs := RowOfs;
                        ActRowBottom := RowOfs+Ht-1;
                        ActColOfs := ColOfs;
                        ActColRight := ColOfs+Wd-2;
                      end;
        geHorizontal: begin
                        ActRowOfs := RowOfs;
                        ActRowBottom := RowOfs+Ht-2;
                        ActColOfs := ColOfs;
                        ActColRight := ColOfs+Wd-1;
                      end;
        geBoth      : begin
                        ActRowOfs := RowOfs;
                        ActRowBottom := RowOfs+Ht-2;
                        ActColOfs := ColOfs;
                        ActColRight := ColOfs+Wd-2;
                      end;
        ge3D        : begin
                        ActRowOfs := RowOfs+1;
                        ActRowBottom := RowOfs+Ht-2;
                        ActColOfs := ColOfs+1;
                        ActColRight := ColOfs+Wd-2;
                      end;
      end;

      {get the correct background color for the pen}
      if DrawItFocused then
        BrushColor := Colors.ActiveFocused
      else
        BrushColor := Colors.ActiveUnfocused;
      Brush.Color := Color;

      {to circumvent a bug in LineTo}
      SetBkColor(Handle, ColorToRGB(BrushColor));

      {set up the pen}
      with Pen do begin
        Width := 1;
        Style := GridPen.Style;
        Color := GridPen.NormalColor;
      end;

      {right line}
      if GridPen.Effect in [geVertical, geBoth, ge3D] then begin
        MoveTo(ActColRight, ActRowOfs);
        LineTo(ActColRight, ActRowBottom+1);
      end;

      {bottom line}
      if GridPen.Effect in [geHorizontal, geBoth, ge3D] then begin
        MoveTo(ActColOfs, ActRowBottom);
        LineTo(ActColRight+1, ActRowBottom);
      end;

      {if in 3D, must change colors}
      if (GridPen.Effect = ge3D) then
        Pen.Color := GridPen.SecondColor;

      {left line}
      if GridPen.Effect in [geVertical, geBoth, ge3D] then begin
        MoveTo(ActColOfs, ActRowOfs);
        LineTo(ActColOfs, ActRowBottom+1);
      end;

      {top line}
      if GridPen.Effect in [geHorizontal, geBoth, ge3D] then begin
        MoveTo(ActColOfs, ActRowOfs);
        LineTo(ActColRight+1, ActRowOfs);
      end;

    end;
  end;
end;

procedure TOvcCustomDbTable.tbDrawMoveLine;
  {-draw the column move line}
var
  OldPen     : TPen;
  MoveOffset : Integer;
begin
  if (otsMoving in tbState) then with Canvas do begin
    OldPen := TPen.Create;
    try
      OldPen.Assign(Pen);
      try
        Pen.Mode := pmXor;
        Pen.Style := psSolid;
        Pen.Color := clWhite;
        Pen.Width := 3;
        if (tbMoveIndex < tbMoveToIndex) then
          if tbMoveToIndex < Pred(VisibleColumnCount) then
            MoveOffset := VisibleColumns[Succ(tbMoveToIndex)].Offset
          else
            MoveOffset := VisibleColumns.RightEdge
        else
          MoveOffset := VisibleColumns[tbMoveToIndex].Offset;
        MoveTo(MoveOffset, 0);
        LineTo(MoveOffset, ClientHeight);
      finally
        Canvas.Pen := OldPen;
      end;
    finally
      OldPen.Free;
    end;
  end;
end;

procedure TOvcCustomDbTable.tbDrawSizeLine;
  {-draw the column size line}
var
  OldPen : TPen;
begin
  if (otsSizing in tbState) then
    with Canvas do begin
      OldPen := TPen.Create;
      try
        OldPen.Assign(Pen);
        Pen.Color := clBlack;
        Pen.Mode := pmXor;
        Pen.Style := psDot;
        Pen.Width := 1;
        MoveTo(tbSizeOffset, 0);
        LineTo(tbSizeOffset, ClientHeight);
      finally
        Canvas.Pen := OldPen;
        OldPen.Free;
      end;
    end;
end;

procedure TOvcCustomDbTable.tbDrawUnusedArea;
  {-paint the area below and to the right of the used grid}
var
  R    : TRect;
  CR   : TRect;
  IR   : TRect;
  Clip : TRect;
begin
  CR := ClientRect;

  R.Left := VisibleColumns.RightEdge;
  R.Right := CR.Right;
  R.Top := 0;
  R.Bottom := CR.Bottom;

  {get the cliping region}
  if csDesigning in ComponentState then
    Clip := CR
  else
    GetClipBox(Canvas.Handle, Clip);

  {is there anything here that needs painting?}
  if Bool(IntersectRect(IR, R, Clip)) then
    if (R.Left < R.Right) then
      with Canvas do begin
        Brush.Color := ColorUnused;
        FillRect(R);
      end;

  R.Right := R.Left;
  R.Left := 0;
  R.Top := tbCalcRowBottom(Pred(VisibleRowCount));

  {is there anything here that needs painting?}
  if Bool(IntersectRect(IR, R, Clip)) then
    if (R.Top < R.Bottom) then
      with Canvas do begin
        Brush.Color := ColorUnused;
        FillRect(R);
      end;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function  TOvcCustomDbTable.tbEditCellHasFocus(
  FocusHandle : TOvcHWnd{hWnd}) : Boolean;
  {-return True if the edit cell has the focus}
var
  ChildHandle : hWnd;
begin
  Result := False;

  if not Assigned(tbActiveCell) then
    Exit;

  if (tbActiveCell.EditHandle = 0) then
    Exit;

  Result := True;
  if (FocusHandle = tbActiveCell.EditHandle) then
    Exit;

  ChildHandle := GetWindow(tbActiveCell.EditHandle, GW_CHILD);
  while (ChildHandle <> 0) do begin
    if (FocusHandle = ChildHandle) then
      Exit;

    ChildHandle := GetWindow(ChildHandle, GW_CHILD);
  end;
  Result := False;
end;

procedure TOvcCustomDbTable.tbEditingChanged;
var
  InEditMode : Boolean;
begin
  if (csDestroying in ComponentState) then
    Exit;

  {a change in the datasource's editing state occurred}
  InEditMode := (DataLink.DataSet <> nil) and
                (DataLink.DataSet.State in [dsEdit, dsInsert]);

  {if data source is not in edit or insert mode -- stop editing}
  if not InEditMode then
    StopEditing(True);

  {invalidate the indicator column}
  InvalidateIndicators;

  {if datasource is editable and in always editing mode, resume editing}
  if (dtoAlwaysEditing in Options) and InEditMode then
    PostMessage(Handle, ctim_StartEdit, 0, 0);
end;

function TOvcCustomDbTable.tbFindCell(ColNum : Integer) : TOvcBaseTableCell;
  {-return the cell object for ColNum}
begin
  Result := nil;
  if (ColNum > -1) and (ColNum < ColumnCount) then
    Result := Columns[ColNum].DefaultCell;
end;

procedure TOvcCustomDbTable.tbFreeMem(P: Pointer; ACell: TOvcBaseTableCell; const AField: TField);
begin
  if (ACell is TOvcTCString) or (AField.DataType in [ftString, ftWideString]) then
    Dispose(PString(P))
  else
    FreeMem(P);
end;

function TOvcCustomDbTable.tbGetDataSize(ACell : TOvcBaseTableCell) : Integer;    //SZ FIXME
  {-return the size of Cell's data requirements}
begin
  Result := ACell.SpecialCellDataSize;
  if Result = 0 then begin
    if (ACell is TOvcTCString) then
      Result := SizeOf(PString) // TOvcTCString(ACell).MaxLength+1
    else if (ACell is TOvcTCMemo) then
      Result := 0
    else if (ACell is TOvcTCSimpleField) then
      Result := TOvcTCSimpleField(ACell).DataSize
    else if (ACell is TOvcTCPictureField) then
      Result := TOvcTCPictureField(ACell).DataSize
    else if (ACell is TOvcTCNumericField) then
      Result := TOvcTCNumericField(ACell).DataSize
    else if (ACell is TOvcTCComboBox) then
      Result := SizeOf(TCellComboBoxInfo)
    else if (ACell is TOvcTCBitmap) then
      Result := 0
    else if (ACell is TOvcTCCheckBox) then
      Result := SizeOf(TCheckBoxState)
    else if (ACell is TOvcTCGlyph) then
      Result := SizeOf(Integer);
  end;
end;

function TOvcCustomDbTable.tbGetFieldColumn(AField : TField) : Integer;
  {-return this fields column}
begin
  for Result := 0 to Pred(ColumnCount) do
    if TOvcDbTableColumn(Columns[Result]).Field = AField then
      Exit;
  Result := -1;
end;

procedure TOvcCustomDbTable.tbGetFieldValue(AField : TField;
          ACell : TOvcBaseTableCell; Data : Pointer; Size : Integer);
  {-get the value from the db field}
var
//  S   : string[255];
//  I   : SmallInt absolute S;
//  L   : Integer absolute S;
//  W   : Word absolute S;
//  B   : Boolean absolute S;
//  E   : Extended absolute S;
//  WD  : TStDate absolute S;
//  WT  : TStTime absolute S;
  {DT  : TDateTime absolute S;}
  Col : Integer;
  Idx : Integer;
begin
//  FillChar(S, SizeOf(S), #0);

  if Assigned(AField) then begin
    {get the field value into Data^}
    if ACell.SpecialCellSupported(AField) then begin
      ACell.SpecialCellDataTransfer(AField, Data, cdpForEdit);
      Exit;
    end;
    if (ACell is TOvcTCString) then
      PString(Data)^ := AField.Text
    else if (ACell is TOvcTCSimpleField) or
            (ACell is TOvcTCPictureField) or
            (ACell is TOvcTCNumericField) then begin
      case AField.DataType of
        ftString   : PString(Data)^ := AField.Text;

        ftWideString : PString(Data)^ := AField.Text;
        ftSmallInt : PSmallInt(Data)^ := AField.AsInteger; //I := AField.AsInteger;
        ftInteger  : PLongInt(Data)^ := AField.AsInteger; // L := AField.AsInteger;
        ftWord     : PWord(Data)^ := AField.AsInteger; // W := AField.AsInteger;
        ftBoolean  : PBoolean(Data)^ := AField.AsBoolean; // B := AField.AsBoolean;
        ftFloat    : PExtended(Data)^ := AField.AsFloat; // E := AField.AsFloat;
        ftCurrency : PExtended(Data)^ := AField.AsFloat; // E := AField.AsFloat;
        ftBCD      : PExtended(Data)^ := AField.AsFloat; // E := AField.AsFloat;
        ftTime     :
          if (AField.IsNull) then
            PStDate(Data)^ := BadTime // WT := BadTime
          else
            PStTime(Data)^ := DateTimeToStTime(AField.AsDateTime); // WT := DateTimeToStTime(AField.AsDateTime);
        ftDate     :
          if (AField.IsNull) then
            PStDate(Data)^ := BadDate // WD := BadDate
          else
            PStDate(Data)^ := DateTimeToStDate(AField.AsDateTime); // WD := DateTimeToStDate(AField.AsDateTime);
        ftDateTime :
          begin
            PStDate(Data)^ := BadDate; // WD := BadDate;
            Col := tbGetFieldColumn(AField);
            if Col > -1 then begin
              case TOvcDbTableColumn(Columns[Col]).DateOrTime of
                dtUseDate :
                  if (AField.IsNull) then
                    PStDate(Data)^ := BadDate // WD := BadDate
                  else
                    PStDate(Data)^ := DateTimeToStDate(AField.AsDateTime); // WD := DateTimeToStDate(AField.AsDateTime);
                dtUseTime :
                  if (AField.IsNull) then
                    PStTime(Data)^ := BadTime // WT := BadTime
                  else
                    PStTime(Data)^ := DateTimeToStTime(AField.AsDateTime); // WT := DateTimeToStTime(AField.AsDateTime);
              end;
            end;
          end;
      end;
    end else if (ACell is TOvcTCComboBox) then begin
      FillChar(Data^, Size, #0);
      if AField.DataType in [ftSmallInt, ftInteger, ftWord] then begin
        PCellComboBoxInfo(Data)^.Index := AField.AsInteger;
        PCellComboBoxInfo(Data)^.St := '';
      end else begin
        PString(Data)^ := AField.Text;
        if PString(Data)^ = '' then
          Idx := -1
        else
          Idx := TOvcTCComboBox(ACell).Items.IndexOf(PString(Data)^);

        PCellComboBoxInfo(Data)^.Index := Idx;

        if Idx = -1 then
          if TOvcTCComboBox(ACell).Style in [csDropDown, csSimple] then
            PCellComboBoxInfo(Data)^.St := PString(Data)^ //S;
      end;

      Exit;
    end else if (ACell is TOvcTCMemo) then begin
      Exit; {not supported}
    end else if (ACell is TOvcTCBitmap) then begin
      Exit; {picture is retrieved during painting}
    end else if (ACell is TOvcTCIcon) then begin
      Exit; {not supported}
    end else if (ACell is TOvcTCCheckBox) then begin
      if AField.AsBoolean then
        TCheckBoxState(Data^) := cbChecked
      else
        TCheckBoxState(Data^) := cbUnChecked;
      Exit;
    end else if (ACell is TOvcTCGlyph) then begin
      Integer(Data^) := AField.AsInteger;
      Exit;
    end;
  end;

  {transfer data}
//SZ - not needed anymore; data modified directly, the data size for strings can now be > 255
//  if Size > SizeOf(S) then
//    Size := SizeOf(S);
//  Move(S, Data^, Size);
end;


procedure TOvcCustomDbTable.tbGetMem(var P: Pointer; ACell: TOvcBaseTableCell; const AField: TField);
// allocates memory for the cell data
// we cannot use a simple GetMem anymore because PString has a special memory layout
// this also happens if the Field is a StringField
var
  Size: Integer;
begin
  Size := tbGetDataSize(ACell);

  if (ACell is TOvcTCString) or (AField.DataType in [ftString, ftWideString]) then
    New(PString(P))
  else
    GetMem(P, Size);
end;

procedure TOvcCustomDbTable.tbGridPenChanged(Sender : TObject);
  {-notification of a grid pen change change}
begin
  if ((ComponentState * [csLoading, csDestroying]) <> []) then
    Exit;

  Invalidate;
end;

function TOvcCustomDbTable.tbIsOnGridLine(MouseX, MouseY : Integer) : Boolean;
  {-return True if mouse is over a grid line}
var
  Idx : Integer;
begin
  Result := False;
  if not (hoShowHeader in HeaderOptions) or (MouseY >= HeaderHeight) then
    Exit;

  {check right edge first}
  if Abs(MouseX - VisibleColumns.RightEdge) <= dtDefHitMargin then begin
    Result := True;
    tbSizeIndex := Pred(VisibleColumnCount);
  end else begin
    {check for mouse cursor over the right edge for other columns}
    for Idx := 1 to Pred(VisibleColumnCount) do begin
      if Abs(MouseX - VisibleColumns[Idx].Offset) <= dtDefHitMargin then begin
        Result := True;
        tbSizeIndex := Pred(Idx);
        Break;
      end;
    end;
  end;
end;

function TOvcCustomDbTable.tbIsDbActive : Boolean;
  {-return True is the datasource is active}
begin
  Result := Assigned(FDataLink) and (DataSource <> nil) and FDataLink.Active;
end;

function TOvcCustomDbTable.tbIsColumnHidden(ColNum : Integer) : Boolean;
  {-return hidden status for this column}
var
  C : TOvcDbTableColumn;
begin
  Result := True;

  if (ColNum >= 0) and (ColNum < ColumnCount) then begin
    C := TOvcDbTableColumn(Columns[ColNum]);
    if Assigned(C) then begin
      Result := C.Hidden;

      {see if the field is marked as not visible}
      if not FDataLink.DefaultFields and (C.Field <> nil) then
        Result := Result or not C.Field.Visible;
    end;
  end;
end;

function TOvcCustomDbTable.tbIsInMoveArea(MouseX, MouseY : Integer) : Boolean;
  {-return true if mouse is over the sizing area of the header}
var
  Idx              : Integer;
  LockedColsOffset : Integer;
begin
  Result := False;
  if not (hoShowHeader in HeaderOptions) or (MouseY >= HeaderHeight) then
    Exit;

  {calc the offset of the locked columns}
  LockedColsOffset := tbRowIndicatorWidth;
  Idx := 0;
  while (Idx < VisibleColumnCount) do begin
    if VisibleColumns[Idx].Number >= LockedColumns then
      Break;
    Inc(Idx);
    if Idx < VisibleColumnCount then
      LockedColsOffset := VisibleColumns[Idx].Offset
    else
      LockedColsOffset := VisibleColumns.RightEdge;
  end;


  {the cursor is within the column move area if it's in the header area
   above the main area of the table}
  Result := (MouseX >= LockedColsOffset) and (MouseX < VisibleColumns.RightEdge);
end;

procedure TOvcCustomDbTable.tbLayoutChanged;
var
  I : Integer;
begin
  if (csDestroying in ComponentState) then
    Exit;

  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  {create the field to column map}
  tbDefineFieldMap;

  {reclaculate column values}
  tbCalcColumnsOnLastPage; {calls tbCalcRowColData(LeftColumn)}

  {update the datasource's buffer count}
  tbUpdateBufferLimit; {calls tbUpdateActive}

  Invalidate;
  tbUpdateHScrollBar;
  tbUpdateVScrollBar;

  if FDataLink.DataSet = nil then begin
    for I := 0 to Pred(ColumnCount) do begin
      TOvcDbTableColumn(Columns[I]).Field := nil;
      TOvcDbTableColumn(Columns[I]).DataField := '';
    end;
    tbCalcRowColData(0);
  end;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function TOvcCustomDbTable.tbIsSibling(HW : TOvcHWnd{hWnd}) : Boolean;
  {-return True if the window HW one of our siblings}
var
  C : TWinControl;
  H : hWnd;
begin
  Result := False;
  C := FindControl(HW);

  {see if this window is a child of one of our siblings}
  if not Assigned(C) then begin
    H := GetParent(HW);
    if H > 0 then
      C := FindControl(H);
  end;

  if Assigned(C) then
    if (GetImmediateParentForm(C) = GetImmediateParentForm(Self)) then
      Result := True;
end;

function TOvcCustomDbTable.tbLoading(DS : TDataSource) : Boolean;
  {-return True if table or datasource is loading}
begin
  Result := (csLoading in ComponentState);
  {DS could be on a data module}
  if Assigned(DS) then begin
    Result := Result or (csLoading in DS.ComponentState);
    if Assigned(DS.Owner) then
      Result := Result or (csLoading in DS.Owner.ComponentState);
  end;
end;

procedure TOvcCustomDbTable.tbMoveActCellPageLeft;
  {-move the active cell one page left}
var
  CurLeftCol   : Integer;
  CurIdx       : Integer;
  Walker       : Integer;
  NewActiveRow : Integer;
  NewActiveCol : Integer;
begin
  CurLeftCol := LeftColumn;
  if (ActiveColumn = LeftColumn) then begin
    Walker := IncCol(CurLeftCol, -1);
    if (Walker = CurLeftCol) then
      Exit;
  end;
  CurIdx := VisibleColumns.IndexOf(ActiveColumn);
  tbScrollBarPageLeft;

  if (CurIdx = -1) or (CurLeftCol = LeftColumn) then
    NewActiveCol := IncCol(LeftColumn, 0)
  else if (CurIdx < VisibleColumnCount) then
    NewActiveCol := IncCol(VisibleColumns[CurIdx].Number, 0)
  else
    NewActiveCol := IncCol(VisibleColumns[Pred(VisibleColumnCount)].Number, 0);
  NewActiveRow := ActiveRow;

  if (ActiveColumn <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
    SetActiveCell(NewActiveRow, NewActiveCol);
end;

procedure TOvcCustomDbTable.tbMoveActCellPageRight;
  {-move the active cell one page right}
var
  NewLeftCol   : Integer;
  CurCol       : Integer;
  LastCol      : Integer;
  CurIdx       : Integer;
  LastIdx      : Integer;
  NewActiveRow : Integer;
  NewActiveCol : Integer;
begin
  CurCol := ActiveColumn;
  CurIdx := VisibleColumns.IndexOf(CurCol);

  LastIdx := Pred(VisibleColumnCount);
  LastCol := VisibleColumns[LastIdx].Number;

  if (CurCol = LastCol) then
    NewLeftCol := IncCol(LastCol, 1)
  else
    NewLeftCol := LastCol;

  LeftColumn := NewLeftCol;
  if (CurIdx = -1) then
    NewActiveCol := IncCol(LeftColumn, 0)
  else if (CurIdx < VisibleColumnCount) then
    NewActiveCol := IncCol(VisibleColumns[CurIdx].Number, 0)
  else
    NewActiveCol := IncCol(VisibleColumns[Pred(VisibleColumnCount)].Number, 0);

  NewActiveRow := ActiveRow;
  if (ActiveColumn <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
    SetActiveCell(NewActiveRow, NewActiveCol);
end;

function TOvcCustomDbTable.tbPaintBitmapCell(ACanvas : TCanvas; PaintRect : TRect;
         CellAttr : TOvcCellAttributes; AField : TField;
         ACell : TOvcBaseTableCell; Active : Boolean) : Boolean;
  {-paint the bitmap data using the bitmap cell}
var
  Rgn : hRgn;
  R   : TRect;
  Pic : TPicture;
begin
  Result := False;
  if not (dtoShowPictures in Options) and not Active then
    Exit;

  if AField is TBlobField then begin
    Pic := TPicture.Create;
    try
      Pic.Assign(AField);
      if Pic.Graphic is TBitmap then begin
        with ACanvas do begin
          Brush.Color := CellAttr.caColor;
          Brush.Style := bsSolid;

          if (dtoStretch in Options) then begin
            {paint the graphic to fit in the cell}
            if Pic.Graphic.Empty then
              FillRect(PaintRect)
            else
              StretchDraw(PaintRect, Pic.Graphic);
            Result := True;
          end else begin
            {setup clipping region to the cell region}
            with PaintRect do
              Rgn := CreateRectRgn(Left, Top, Right, Bottom);
            try
              SelectClipRgn(ACanvas.Handle, Rgn);
              if ACanvas.Handle > 0 then {force DC to be re-realized};
            finally
              DeleteObject(Rgn);
            end;

            {draw the graphic}
            with PaintRect do
              SetRect(R, Left, Top, Left+Pic.Width, Top+Pic.Height);
            StretchDraw(R, Pic.Graphic);

            Rgn := CreateRectRgn(0, 0, Width, Height);
            try
              {reset the clipping region}
              SelectClipRgn(ACanvas.Handle, Rgn);

              {clear any unused area of the cell}
              ExcludeClipRect(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
              if ACanvas.Handle > 0 then {force DC to be re-realized};
              FillRect(PaintRect);

              {reset the clipping region}
              SelectClipRgn(ACanvas.Handle, Rgn);
              if ACanvas.Handle > 0 then {force DC to be re-realized};
            finally
              DeleteObject(Rgn);
            end;

            Result := True;
          end;

        end;
      end;
    finally
      Pic.Free;
    end;
  end;
end;

procedure TOvcCustomDbTable.tbPaintString(const CellRect : TRect;
  const CellAttr : TOvcCellAttributes; Margin : Integer;
  WordWrap : Boolean; const S : string);
  {-paint the data for this cell}
var
  Size      : TSize;
var
  Wd        : Integer;
  Len       : Integer;
  DTOpts    : Cardinal;
  R         : TRect;
  OurAdjust : TOvcTblAdjust;
  Buf       : array[0..255] of Char;
begin
  Canvas.Font := CellAttr.caFont;
  Canvas.Font.Color := CellAttr.caFontColor;
  if S > '' then
    StrPLCopy(Buf, S, 255)
  else
    Buf[0] := #0;
  Len := StrLen(Buf);
  R := CellRect;
  InflateRect(R, -Margin div 2, -Margin div 2);

  if WordWrap then begin
    DTOpts:= DT_NOPREFIX or DT_WORDBREAK;
    case CellAttr.caAdjust of
      otaTopLeft, otaCenterLeft, otaBottomLeft    :
         DTOpts := DTOpts or DT_LEFT;
      otaTopRight, otaCenterRight, otaBottomRight :
         DTOpts := DTOpts or DT_RIGHT;
    else
      DTOpts := DTOpts or DT_CENTER;
    end;
  end else begin
    DTOpts:= DT_NOPREFIX or DT_SINGLELINE;

    {make sure that if the string doesn't fit, we at least see the first few characters}
    GetTextExtentPoint32(Canvas.Handle, Buf, Len, Size);
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
    end;

    case OurAdjust of
      otaTopLeft, otaTopCenter, otaTopRight :
         DTOpts := DTOpts or DT_TOP;
      otaBottomLeft, otaBottomCenter, otaBottomRight :
         DTOpts := DTOpts or DT_BOTTOM;
    else
      DTOpts := DTOpts or DT_VCENTER;
    end;

  end;

  case CellAttr.caTextStyle of
    tsFlat :
      DrawText(Canvas.Handle, Buf, Len, R, DTOpts);
    tsRaised :
      begin
        OffsetRect(R, -1, -1);
        Canvas.Font.Color := CellAttr.caFontHiColor;
        DrawText(Canvas.Handle, Buf, Len, R, DTOpts);
        OffsetRect(R, 1, 1);
        Canvas.Font.Color := CellAttr.caFontColor;
        Canvas.Brush.Style := bsClear;
        DrawText(Canvas.Handle, Buf, Len, R, DTOpts);
        Canvas.Brush.Style := bsSolid;
      end;
    tsLowered :
      begin
        OffsetRect(R, 1, 1);
        Canvas.Font.Color := CellAttr.caFontHiColor;
        DrawText(Canvas.Handle, Buf, Len, R, DTOpts);
        OffsetRect(R, -1, -1);
        Canvas.Font.Color := CellAttr.caFontColor;
        Canvas.Brush.Style := bsClear;
        DrawText(Canvas.Handle, Buf, Len, R, DTOpts);
        Canvas.Brush.Style := bsSolid;
      end;
    end;
end;

procedure TOvcCustomDbTable.tbQueryColData(ColNum : Integer; var W : Integer;
                                         var A : TOvcTblAccess; var H : Boolean);
  {-return column data for ColNum}
var
  C : TOvcDbTableColumn;
begin
  C := TOvcDbTableColumn(Columns[ColNum]);
  if Assigned(C) then begin
    W := C.Width;

    if (C.DefaultCell <> nil) then
      A := C.DefaultCell.Access
    else
      A := otxReadOnly;

    H := C.Hidden;

    {see if the field is marked as not visible}
    if not FDataLink.DefaultFields and (C.Field <> nil) then
      H := H or not C.Field.Visible;
  end;
end;

procedure TOvcCustomDbTable.tbReadColData(Reader : TReader);
  {-read column data from the stream}
var
  ColObj : TOvcDbTableColumn;
  Fixups : TStringList;
begin
  with Reader do begin
    ReadListBegin;
    Columns.Clear;
    Fixups := Columns.tcStartLoading;
    while not EndOfList do begin
      ColObj := TOvcDbTableColumn.Create(Self);
      ColObj.Width := ReadInteger;
      ColObj.Hidden := ReadBoolean;
      ColObj.DataField := ReadString;
      ColObj.DateOrTime := TDateOrTime(ReadInteger);
      if ReadBoolean then
        Fixups.AddObject(ReadString, ColObj);
      Columns.Append(ColObj);
    end;
    ReadListEnd;
  end;
end;

procedure TOvcCustomDbTable.tbRecordChanged(Field : TField);
var
  Col : Integer;
begin
  if (csDestroying in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  if Field = nil then
    InvalidateRow(ActiveRow)
  else begin
    {find the cell to invalidate}
    for Col := 0 to DataLink.FieldCount-1 do
      if Field = Fields[Col] then begin
        InvalidateCell(ActiveRow, Col);
        Break;
      end;
  end;

  if InEditingState then begin
    if ((Field = nil) or (SelectedField = Field)) then begin
      if not StopEditing(False) then
        Abort;

      {since we were editing, start again using new data}
      PostMessage(Handle, ctim_StartEdit, 0, 0);
    end;
  end;
end;

procedure TOvcCustomDbTable.tbRebuildColumns;
  {-rebuild and relink coulmns with the data fields}
var
  I        : Integer;
  ColCount : Integer;
  Col      : TOvcDbTableColumn;
  Fld      : TField;

  function GetColumnWidth : Integer;
  var
    W      : Integer;
    TM     : TTextMetric;
    NeedDC : Boolean;
  begin
    NeedDC := not HandleAllocated;
    if NeedDC then
      Canvas.Handle := GetDC(0);
    try
      Canvas.Font := Self.Font;
      GetTextMetrics(Canvas.Handle, TM);

      if (hoShowHeader in HeaderOptions) then
        W := Length(Fld.DisplayLabel) * (Canvas.TextWidth('0') - TM.tmOverhang) +
          TM.tmOverhang + 4
      else
        W := 0;

      Result :=
        Fld.DisplayWidth * (Canvas.TextWidth('0') - TM.tmOverhang) + TM.tmOverhang + 4;
      if W > Result then
        Result := W;
    finally
      if NeedDC then begin
        ReleaseDC(0, Canvas.Handle);
        Canvas.Handle := 0;
      end;
    end;
  end;

begin
  if (csLoading in ComponentState) then
    Exit;

  {inform tbColumnChanged not to act on the following changes}
  tbRebuilding := True;
  try
    ColCount := FDataLink.DataSet.FieldCount;
    if (ColCount = 0) then
      Inc(ColCount);
    FColumns.Count := ColCount;

    for I := 0 to Pred(ColCount) do begin
      Col := TOvcDbTableColumn(Columns[I]);

      {force columns to re-aquire fields (in case dataset has changed)}
      Col.Field := nil;

      if I < FDataLink.DataSet.FieldCount then begin
        Fld := FDatalink.DataSet.Fields[I];
        if Assigned(Fld) then begin
          Col.DataField := Fld.FieldName;
          Col.Width := GetColumnWidth;
        end else begin
          Col.DataField := '';
          Col.Width := tbDefColWidth;
        end;
      end else
        Col.DataField := '';
    end;
  finally
    tbRebuilding := False;
  end;

  tbColumnChanged(Self, 0, 0, taGeneral);
end;

procedure TOvcCustomDbTable.tbScrollBarPageLeft;
  {-scroll visible columns left one page}
var
  NewLeftCol : Integer;
  CurLeftCol : Integer;
  Walker     : Integer;
  CW         : Integer;
begin
  CurLeftCol := LeftColumn;
  Walker := IncCol(CurLeftCol, -1);
  if (Walker = CurLeftCol) then
    Exit;

  CW := ClientWidth;
  NewLeftCol := Walker;
  tbCalcRowColData(NewLeftCol);
  while (VisibleColumns.RightEdge < CW) or
        (VisibleColumns[Pred(VisibleColumnCount)].Number > CurLeftCol) do begin
    Walker := IncCol(NewLeftCol, -1);
    if (Walker = NewLeftCol) then
      Break;
    NewLeftCol := Walker;
    tbCalcRowColData(NewLeftCol);
  end;

  {restore row and column data}
  tbCalcRowColData(CurLeftCol);
  LeftColumn := NewLeftCol;
end;

procedure TOvcCustomDbTable.tbScrollBarPageRight;
  {-scroll visible columns right one page}
var
  LastIdx : Integer;
  LastCol : Integer;
begin
  LastIdx := Pred(VisibleColumnCount);
  LastCol := VisibleColumns[LastIdx].Number;

  if (LeftColumn <> LastCol) then
    LeftColumn := LastCol
  else
    LeftColumn := IncCol(LeftColumn, 1);
end;

procedure TOvcCustomDbTable.tbScrollNotification(Delta : Integer);
  {-respond to a db scroll action}
var
  R : TRect;
begin
  if tbScrolling then
    Exit;

  if (DataLink <> nil) and tbIsDbActive then begin
    {change the active row}
    tbScrolling := True;
    try
      tbUpdateActive;
    finally
      tbScrolling := False;
    end;

    if Delta <> 0 then begin
      {if the db scrolled more than visible rows, repaint table}
      if Abs(Delta) > VisibleRowCount then
        Invalidate
      else if Assigned(FOnGetCellAttributes) then
        Invalidate
      else begin
        if not StopEditing(True) then
          Abort;

        {invalidate the indicator column}
        InvalidateIndicators;

        InvalidateRow(ActiveRow);
        if (hoShowHeader in HeaderOptions) then
          R.Top := HeaderHeight
        else
          R.Top := 0;
        R.Bottom := tbCalcRowBottom(Pred(VisibleRowCount));
        R.Left := 0;
        R.Right := VisibleColumns.RightEdge;
        ScrollWindow(Handle, 0, -RowHeight * Delta, @R, @R);

        if (dtoAlwaysEditing in Options) then
          PostMessage(Handle, ctim_StartEdit, 0, 0);
      end;
    end;
  end;

  tbUpdateVScrollBar;
end;

procedure TOvcCustomDbTable.tbScrollTableLeft(NewLeftCol : Integer);
  {-scroll left to new left column}
var
  NewColRight : Integer;
  OldColRight : Integer;
  NewColIdx   : Integer;
  OldColIdx   : Integer;
  NewCLOfs    : Integer;
  OldCLOfs    : Integer;
  CW          : Integer;
  R           : TRect;
begin
  {the window is scrolled left, ie the new leftmost column
   is to the right of the current leftmost column}
  CW := ClientWidth;
  NewColIdx := VisibleColumns.IndexOf(NewLeftCol);

  {if the new column is not yet visible or only partially}
  {visible or if the current left column is no longer valid}
  if (NewColIdx = -1) or (VisibleColumns.RightEdge > CW) or
     (IncCol(LeftColumn, 0) <> LeftColumn) then begin
    {the new leftmost column is not (fully) visible}
    FLeftColumn := NewLeftCol;
    tbCalcRowColData(LeftColumn);
    InvalidateNotLocked;
    InvalidateUnusedArea;
  end else begin
    {the new leftmost column is fully visible}
    OldColIdx := VisibleColumns.IndexOf(FLeftColumn);
    OldColRight := tbColumnAtRight;
    if VisibleColumns.RightEdge < CW then begin
      Inc(OldColRight);
      InvalidateUnusedArea;
    end;
    NewCLOfs := VisibleColumns[NewColIdx].Offset;
    OldCLOfs := VisibleColumns[OldColIdx].Offset;

    R := Rect(OldCLOfs, 0, CW, ClientHeight);
    ScrollWindow(Handle, (OldCLOfs-NewCLOfs), 0, @R, @R);

    FLeftColumn := NewLeftCol;
    tbCalcRowColData(LeftColumn);
    NewColRight := tbColumnAtRight;

    if OldColRight <= NewColRight then
      InvalidateUnusedArea;
  end;

  DoOnLeftColumnChanged;
end;

procedure TOvcCustomDbTable.tbScrollTableRight(NewLeftCol : Integer);
  {-scroll right to new left column}
var
  OldLeftCol : Integer;
  OldColIdx  : Integer;
  OldCLOfs   : Integer;
  OrigOfs    : Integer;
  Idx        : Integer;
  R          : TRect;
begin
  {the window is scrolled right, ie the new leftmost column
   is to the left of the current leftmost column}
  OldLeftCol := LeftColumn;
  Idx := VisibleColumns.IndexOf(OldLeftCol);
  if Idx > -1 then
    OrigOfs := VisibleColumns[Idx].Offset
  else
    OrigOfs := 0;
  FLeftColumn := NewLeftCol;
  tbCalcRowColData(LeftColumn);
  OldColIdx := VisibleColumns.IndexOf(OldLeftCol);
  if (OldColIdx = -1) then begin
    {the old leftmost column is no longer visible}
    InvalidateNotLocked;
    InvalidateUnusedArea;
  end else begin
    {the old leftmost column is (partially) visible}
    OldCLOfs := VisibleColumns[OldColIdx].Offset;
    R := Rect(OrigOfs, 0, ClientWidth, ClientHeight);
    ScrollWindow(Handle, (OldClOfs-OrigOfs), 0, @R, @R);
  end;

  DoOnLeftColumnChanged;
end;

procedure TOvcCustomDbTable.tbSetFieldValue(AField : TField;
          ACell : TOvcBaseTableCell; Data : Pointer; Size : Integer);
  {-set the db field value}
var
  S   : string[255];          //SZ FIXME
  I   : SmallInt absolute S;
  L   : Integer absolute S;
  W   : Word absolute S;
  B   : Boolean absolute S;
  E   : Extended absolute S;
  DT  : TDateTime absolute S;
  WD  : TStDate absolute S;
  WT  : TStTime absolute S;
  H   : TDateTime;
  Idx : Integer;
begin
  if (FDataLink.DataSet = nil) then
    Exit;

  {exit if the datasource isn't in edit or insert mode}
  if not (FDataLink.DataSet.State in [dsEdit, dsInsert]) then
    Exit;

  if Assigned(AField) then begin
    if ACell.SpecialCellSupported(AField) then begin
      ACell.SpecialCellDataTransfer(AField, Data, cdpForSave);
      Exit;
    end;

    {set the db field value from the cell value}
    if (ACell is TOvcTCComboBox) then begin
      if AField.DataType in [ftSmallInt, ftInteger, ftWord] then
        AField.AsInteger := PCellComboBoxInfo(Data)^.Index
      else begin
        if TOvcTCComboBox(ACell).Style in [csDropDown, csSimple] then
          AField.Text := PCellComboBoxInfo(Data)^.St
        else begin
          Idx := PCellComboBoxInfo(Data)^.Index;
          if Idx < 0 then
            AField.Text := ''
          else
            AField.Text := TOvcTCComboBox(ACell).Items[Idx];
        end;
      end;

      Exit;
    end else if (ACell is TOvcTCMemo) then begin
      Exit; {not supported}
    end else if (ACell is TOvcTCBitmap) then begin
      Exit; {editing not supported}
    end else if (ACell is TOvcTCIcon) then begin
      Exit; {not supported}
    end else if (ACell is TOvcTCCheckBox) then begin
      AField.AsBoolean := TCheckBoxState(Data^) = cbChecked;
      Exit;
    end else if (ACell is TOvcTCGlyph) then begin
      AField.AsInteger := Integer(Data^);
      Exit;
    end;

    {transfer data}
    if Size > SizeOf(S) then
      Size := SizeOf(S);
    //If the field is a StringField then the data pointer is a PString.
    if AField.InheritsFrom(TStringField) then
      S := ShortString(PString(Data)^)
    else
      Move(Data^, S, Size);

    if (ACell is TOvcTCString) then
      AField.Text := string(S)
    else if (ACell is TOvcTCSimpleField) or
            (ACell is TOvcTCPictureField) or
            (ACell is TOvcTCNumericField) then begin
      case AField.DataType of
        ftString   : AField.Text := string(S);

        {WideString Support}
        ftWideString : AField.Text := string(S);
        ftSmallInt : AField.AsInteger := I;
        ftInteger  : AField.AsInteger := L;
        ftWord     : AField.AsInteger := W;
        ftBoolean  : AField.AsBoolean := B;
        ftFloat    : AField.AsFloat := E;
        ftCurrency : AField.AsFloat := E;
        ftBCD      : AField.AsFloat := E;
        ftDate     :
          if WD = BadDate then
            AField.Clear
          else
            AField.AsDateTime := StDateToDateTime(WD);
        ftTime     :
          if WT = BadTime then
            AField.Clear
          else
            AField.AsDateTime := StTimeToDateTime(WT);
        ftDateTime :
          begin
            {preserve unedited date or time portion of field value}
            H := AField.AsDateTime;
            if ACell is TOvcTCPictureField then begin
              {convert ovc date or time to DateTime}
              if TOvcTCPictureField(ACell).DataType = pftDate then begin
                DT := StDateToDateTime(WD);
                AField.AsDateTime := Trunc(DT) + Frac(H);
              end else if TOvcTCPictureField(ACell).DataType = pftTime then begin
                DT := StTimeToDateTime(WT);
                AField.AsDateTime := Frac(DT) + Trunc(H);
              end;
            end;
          end;
      end;
    end;

  end;
end;

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
procedure TOvcCustomDbTable.tbSetFocus(AHandle : TOvcHWnd{hWnd});
  {-call window's SetFocus routine}
begin
  if AHandle <> 0 then begin
    Windows.SetFocus(AHandle);
  end;
end;

procedure TOvcCustomDbTable.tbUpdateActive;
  {-update the table's active row}
begin
  if tbIsDbActive then
    ActiveRow := FDatalink.ActiveRecord;
end;

procedure TOvcCustomDbTable.tbUpdateBufferLimit;
  {-update the data link's buffer size}
begin
  tbCalcVisibleRows;

  try
    with FDataLink do begin
      if Active and (RecordCount > 0) then begin
        FDataLink.BufferCount := VisibleRowCount;
        FVisibleRowCount := RecordCount;
        {this update may have been triggered by a scroll action}
        tbScrolling := True;
        try
          tbUpdateActive;
        finally
          tbScrolling := False;
        end;
      end else
        FVisibleRowCount := 1;
    end;
  except
    {ignore errors}
  end;
end;

procedure TOvcCustomDbTable.tbUpdateHScrollBar;
  {-update the horizontal scrollbar range and position}
var
  I           : Integer;
  ColNum      : Integer;
begin
  if tbHasHSBar and HandleAllocated then begin
    I := 0;
    for ColNum := LockedColumns to tbLastLeftCol do
      if not tbIsColumnHidden(ColNum) then
        Inc(I);
    SetScrollRange(Handle, SB_HORZ, 0, Pred(I), False);

    I := 0;
    for ColNum := LockedColumns to Pred(LeftColumn) do
      if not tbIsColumnHidden(ColNum) then
        Inc(I);
    SetScrollPos(Handle, SB_HORZ, I, True)
  end;
end;

procedure TOvcCustomDbTable.tbUpdateVScrollBar;
  {-update the vertical scrollbar range and position}
var
  SIOld, SINew : TScrollInfo;
begin
  if (FDataLink.DataSet = nil) then
    Exit;

  if tbIsDbActive and HandleAllocated and tbHasVSBar then begin
    with FDatalink.DataSet do begin
      SIOld.cbSize := SizeOf(SIOld);
      SIOld.fMask := SIF_ALL;
      GetScrollInfo(Self.Handle, SB_VERT, SIOld);
      SINew := SIOld;
      if IsSequenced then begin
        SINew.nMin := 1;
        SINew.nPage := Self.VisibleRowCount;
        SINew.nMax := Integer(DWORD(RecordCount) + SINew.nPage - 1);
        if State in [dsInactive, dsBrowse, dsEdit] then
          SINew.nPos := RecNo;  {else keep old pos}
      end else begin
        SINew.nMin := 0;
        SINew.nPage := 0;
        SINew.nMax := 4;
        if FDataLink.DataSet.BOF then
          SINew.nPos := 0
        else if FDataLink.DataSet.EOF then
          SINew.nPos := 4
        else
          SINew.nPos := 2;
      end;
      if (SINew.nMin <> SIOld.nMin) or (SINew.nMax <> SIOld.nMax) or
         (SINew.nPage <> SIOld.nPage) or (SINew.nPos <> SIOld.nPos) then
        SetScrollInfo(Self.Handle, SB_VERT, SINew, True);
    end;
  end;
end;

procedure TOvcCustomDbTable.tbWriteColData(Writer : TWriter);
  {-write column data to stream}
var
  ColNum : Integer;
begin
  with Writer do begin
    WriteListBegin;
    for ColNum := 0 to Pred(ColumnCount) do
      with TOvcDbTableColumn(Columns[ColNum]) do begin
        WriteInteger(Width);
        WriteBoolean(Hidden);
        WriteString(DataField);
        WriteInteger(Ord(DateOrTime));
        if (DefaultCell <> nil) then begin
          WriteBoolean(True);
          WriteString(DefaultCell.Name);
        end else
          WriteBoolean(False);
      end;
      WriteListEnd;
    end;
end;

procedure TOvcCustomDbTable.UpdateData;
  {update the field from the edit cell}
begin
  if not SaveEditedData then
    Abort;
end;

procedure TOvcCustomDbTable.WMCommand(var Msg : TMessage);
var
  R : TRect;
begin
  if InEditingState and (Msg.Msg = WM_COMMAND) then begin
    case Msg.wParamHi of
      CBN_CLOSEUP :
        {force column to repaint}
        InvalidateColumn(ActiveColumn);
      CBN_DROPDOWN :
        begin
          GetWindowRect(Msg.lParam, R);
          {validate area occupied by combobox}
          R.TopLeft := ScreenToClient(R.TopLeft);
          R.BottomRight := ScreenToClient(R.BottomRight);
          ValidateRect(Handle, @R);

          SendMessage(Msg.lParam, CB_GETDROPPEDCONTROLRECT, 0, NativeInt(@R));
          {validate area occupied by combobox list}
          R.TopLeft := ScreenToClient(R.TopLeft);
          R.BottomRight := ScreenToClient(R.BottomRight);
          ValidateRect(Handle, @R);
        end;
      CBN_KILLFOCUS :
        {handle killfocus messages from combobox cells}
        {tell table to stop editing if one of the combobox child controls is}
        {loosing the focus. We will get notified directly by the combobox if}
        {it is loosing the focus}
        if GetFocus <> tbActiveCell.EditHandle then
          PostMessage(Handle, ctim_KillFocus, Msg.lParamLo, 0);
    end;
  end;

  inherited;
end;

procedure TOvcCustomDbTable.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1; {no erasing of the background, we'll do it all}
end;

procedure TOvcCustomDbTable.WMGetDlgCode(var Msg : TMessage);
begin
  Msg.Result := DLGC_WANTCHARS or DLGC_WANTARROWS;

  if (dtoWantTabs in Options) then
    Msg.Result := Msg.Result or DLGC_WANTTAB;
  if (dtoEnterToTab in Options) then
    Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
end;

procedure TOvcCustomDbTable.WMHScroll(var Msg : TWMScroll);
var
  I          : Integer;
  NewLeftCol : Integer;
begin
  {ignore SB_ENDSCROLL and SB_THUMBTRACK messages}
  if (Msg.ScrollCode = SB_ENDSCROLL) or
     (Msg.ScrollCode = SB_THUMBTRACK) then begin
    inherited;
    Exit;
  end;

  {if not focused then do so; if being designed update the table view}
  if not (otsFocused in tbState) then
    SetFocus
  else if (csDesigning in ComponentState) then
    Update;

  {see if the cell being edited is valid; if not exit}
  if InEditingState then
    if not tbActiveCell.CanSaveEditedData(True) then
      Exit;

  {process the scrollbar message}
  case Msg.ScrollCode of
    SB_LINELEFT      :
      LeftColumn := IncCol(LeftColumn, -1);
    SB_LINERIGHT     :
      LeftColumn := IncCol(LeftColumn, 1);
    SB_PAGELEFT      :
      tbScrollBarPageLeft;
    SB_PAGERIGHT     :
      tbScrollBarPageRight;
    SB_THUMBPOSITION :
      begin
        NewLeftCol := LockedColumns;
        for I := 0 to Pred(Msg.Pos) do
          NewLeftCol := IncCol(NewLeftCol, 1);
        if (NewLeftCol <> LeftColumn) then
          LeftColumn := NewLeftCol;
      end;
  else
    inherited;
    Exit;
  end;

  Msg.Result := 0;
end;

procedure TOvcCustomDbTable.WMKeyDown(var Msg : TWMKey);
var
  Cmd           : Word;
  ShiftFlags    : Byte;
begin
  inherited;

  {if datasource is not assigned, exit}
  if (DataSource = nil) then
    Exit;

  if (FDataLink.DataSet = nil) then
    Exit;

  {if Tab key is being converted to arrow key, do it}
  if (dtoWantTabs in Options) and (Msg.CharCode = VK_TAB) then begin
    {get shift value}
    ShiftFlags := GetShiftFlags;
    {convert Tab combination to command}
    if (ShiftFlags = 0) then
      Cmd := ccRight
    else if (ShiftFlags = ss_Shift) then
      Cmd := ccLeft
    else
      Cmd := ccNone;
  end else if (dtoEnterToTab in Options) and (Msg.CharCode = VK_RETURN) then begin
    {If Enter key is being converted to right arrow, do it.}
    ShiftFlags := GetShiftFlags;
    {convert Enter combination to command}
    if (ShiftFlags = 0) then
      Cmd := ccRight
    else if (ShiftFlags and ss_Shift) <> 0 then
      Cmd := ccLeft
    else
      Cmd := ccNone;
  end else
    {otherwise, just translate into a command}
    Cmd := Controller.EntryCommands.TranslateUsing([tbCmdTable], TMessage(Msg));

  if InEditingState then begin
    if not (dtoAlwaysEditing in Options) and
       ((Cmd = ccTableEdit) or (Msg.CharCode = VK_ESCAPE)) then begin
      if not StopEditing(Msg.CharCode <> VK_ESCAPE) then
        Exit;

      {exit datasource edit state}
      if (Msg.CharCode = VK_ESCAPE) then
        FDataLink.Reset;

      tbSetFocus(Handle);
      Include(tbState, otsFocused);
    end;
  end else if (Cmd = ccTableEdit) or
    (
      (Cmd > ccLastCmd) and (Cmd < ccUserFirst) and
      (
        (Msg.CharCode = VK_SPACE) or
        (
         (VK_0 <= Msg.CharCode) and (Msg.CharCode <= VK_DIVIDE)
        ) or
        (Msg.CharCode >= $BA)
      )
    ) then begin
        StartEditing;
        if (Cmd <> ccTableEdit) then
          PostMessage(Handle, ctim_StartEditKey, Msg.CharCode, Msg.KeyData);
  end else if (Msg.CharCode = VK_ESCAPE) then begin
    {take the datasource out of edit mode}
    FDataLink.Reset;
    if FDataLink.DataSet.State in [dsEdit, dsInsert] then
      FDataLink.Reset;
  end;

  case Cmd of
    ccBotOfPage,
    ccBotRightCell,
    ccDown,
    ccEnd,
    ccFirstPage,
    ccHome,
    ccLastPage,
    ccLeft,
    ccNextPage,
    ccPageLeft,
    ccPageRight,
    ccPrevPage,
    ccRight,
    ccTopLeftCell,
    ccTopOfPage,
    ccUp           : MoveActiveCell(Cmd);
  else
    if (Cmd >= ccUserFirst) then
      DoOnUserCommand(Cmd);
  end;
end;

procedure TOvcCustomDbTable.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  Exclude(tbState, otsFocused);
  InvalidateCell(ActiveRow, ActiveColumn);
end;

procedure TOvcCustomDbTable.WMLButtonDblClk(var Msg : TWMMouse);
var
  Row    : Integer;
  Col    : Integer;
  Region : TOvcTblRegion;
begin
  {inherited;}

  if (csDesigning in ComponentState) then
    Exit;

  {if datasource is not assigned, exit}
  if (DataSource = nil) then
    Exit;

  {try to stop editing - if not, exit}
  if InEditingState then
    if not StopEditing(True) then
      Exit;

  Region := CalcRowCol(Msg.XPos, Msg.YPos, Row, Col);
  if Region = (otrInMain) then begin
    SetActiveCell(Row, Col);
    PostMessage(Handle, ctim_StartEdit, 0, 0);
    PostMessage(Handle, ctim_StartEditMouse, Msg.Keys, Integer(Msg.Pos));
  end;

  inherited;
end;

procedure TOvcCustomDbTable.WMLButtonDown(var Msg : TWMMouse);
var
  Row        : Integer;
  Col        : Integer;
  Idx        : Integer;
  Region     : TOvcTblRegion;
  WasFocused : Boolean;
begin
  inherited;

  {if datasource is not assigned, exit}
  if (DataSource = nil) then
    Exit;

  {see if the cell being edited is valid; if not exit}
  if InEditingState then
    if not tbActiveCell.CanSaveEditedData(True) then
      Exit;

  {are we currently unfocused? if so, focus the table}
  WasFocused := Focused;
  if not WasFocused and not (csDesigning in ComponentState) then begin

    {set flag telling WMSetFocus that we are selecting another cell}
    tbSelectingNewCell := True;
    try
      {note: by the time SetFocus returns WMSetFocus will have been called}
      SetFocus;
      if not Focused then
        tbSetFocus(Handle);

      {allow ctim_KillFocus message posted by the cell to be processed}
      Application.ProcessMessages;
    finally
      tbSelectingNewCell := False;
    end;
  end;
  Include(tbState, otsFocused);

  {are we currently showing a sizing cursor? if so the user wants to resize a column}
  if (otsShowSize in tbState) then begin
    tbState := tbState - [otsShowSize] + [otsSizing];

    if Msg.XPos >= VisibleColumns[tbSizeIndex].Offset + dtDefHitMargin then
      tbSizeOffset := Msg.XPos;
    tbDrawSizeLine;
    Exit;
  end;

  {are we currently showing a col move cursor? if so the user wants to move that col}
  if (otsShowMove in tbState) then begin
    {work out which column the click was in}
    CalcRowCol(Msg.XPos, Msg.YPos, Row, Col);

    {translate to a column index}
    Idx := VisibleColumns.IndexOf(Col);

    if Idx <> -1 then begin
      tbState := tbState - [otsShowMove] + [otsMoving];
      tbMoveIndex := Idx;
      tbMoveToIndex := tbMoveIndex;
      tbDrawMoveLine;
      Exit;
    end;
  end;

  if (csDesigning in ComponentState) then
    Exit;

  if not tbIsDbActive then
    Exit;

  {are we focused and not editing?}
  if (otsFocused in tbState) and (otsNormal in tbState) then begin
    Region := CalcRowCol(Msg.XPos, Msg.YPos, Row, Col);

    {if the datasource is in edit or insert mode, update the record}
    if FDataLink.DataSet <> nil then
      if (FDataLink.DataSet.State in [dsEdit, dsInsert]) then begin
        Idx := VisibleColumns.IndexOf(Col);
        if (Idx = -1) or (VisibleColumns[Idx].DefaultCell = nil) then
          FDataLink.DataSet.Post;
      end;

    case Region of
      otrInMain :
        begin
          if not (dtoAlwaysEditing in Options) and (ActiveRow = Row) and
             (ActiveColumn = Col) and WasFocused then begin
            PostMessage(Handle, ctim_StartEdit, 0, 0);
            PostMessage(Handle, ctim_StartEditMouse, Msg.Keys, Integer(Msg.Pos));
          end else if (dtoAlwaysEditing in Options) then begin
            PostMessage(Handle, ctim_StartEdit, 0, 0);
            PostMessage(Handle, ctim_StartEditMouse, Msg.Keys, Integer(Msg.Pos));
          end;

          SetActiveCell(Row, Col);
        end;
      otrInLocked :
        begin
          {see if the click was in an indicator region}
          if (Msg.XPos <= tbRowIndicatorWidth) then
            DoOnIndicatorClick(Row, Col)
          else if (otsNormal in tbState) then
            DoOnLockedCellClick(Row, Col);
        end;
      otrInUnused :
        DoOnUnusedAreaClick(Row, Col);
    end;
  end;

end;

procedure TOvcCustomDbTable.WMLButtonUp(var Msg : TWMMouse);
var
  ColNum  : Integer;
  ColFrom : Integer;
  ColTo   : Integer;
  PF      : TForm;
begin
  inherited;

  {if datasource is not assigned, exit}
  if (DataSource = nil) then
    Exit;

  if (otsSizing in tbState) then begin
    tbDrawSizeLine;

    {check for minimum width}
    if (tbSizeOffset < VisibleColumns[tbSizeIndex].Offset + dtDefHitMargin) then
        tbSizeOffset := VisibleColumns[tbSizeIndex].Offset + dtDefHitMargin;

    VisibleColumns[tbSizeIndex].Width :=
      tbSizeOffset - VisibleColumns[tbSizeIndex].Offset;

    tbState := tbState - [otsSizing] + [otsNormal];

    {notify the designer of the change}
    if csDesigning in ComponentState then begin
      PF := TForm(GetParentForm(Self));
      if Assigned(PF) and (PF.Designer <> nil) then
        PF.Designer.Modified;
    end;

    Invalidate;
  end;

  if (otsMoving in tbState) then begin
    tbDrawMoveLine;

    tbState := tbState - [otsMoving] + [otsNormal];

    if (tbMoveIndex <> tbMoveToIndex) then begin
      ColFrom := VisibleColumns[tbMoveIndex].Number;
      ColTo := VisibleColumns[tbMoveToIndex].Number;

      {inform tbColumnChanged not to act on the following changes}
      tbRebuilding := True;
      try
        if (ColTo > ColFrom) then
          for ColNum := ColFrom to Pred(ColTo) do
            Columns.Exchange(ColNum, Succ(ColNum))
        else
          for ColNum := Pred(ColFrom) downto ColTo do
            Columns.Exchange(ColNum, Succ(ColNum));
      finally
        tbRebuilding := False;
      end;

      tbColumnChanged(Self, 0, 0, taGeneral);

      {notify that a column has moved}
      DoOnColumnMoved(ColFrom, ColTo);
    end;

    {notify the designer of the change}
    if csDesigning in ComponentState then begin
      PF := TForm(GetParentForm(Self));
      if Assigned(PF) and (PF.Designer <> nil) then
        PF.Designer.Modified;
    end;
  end;

end;

procedure TOvcCustomDbTable.WMMouseMove(var Msg : TWMMouse);
var
  Row : Integer;
  Col : Integer;
  Idx : Integer;
begin
  inherited;

  {if datasource is not assigned, exit}
  if (DataSource = nil) then
    Exit;

  if (otsSizing in tbState) then begin
    tbDrawSizeLine;
    if Msg.XPos >= VisibleColumns[tbSizeIndex].Offset+dtDefHitMargin then
      tbSizeOffset := Msg.XPos;
    tbDrawSizeLine;
  end;

  if (otsMoving in tbState) then begin
    CalcRowCol(Msg.XPos, Msg.YPos, Row, Col);
    if (Col >= LockedColumns) then begin
      Idx := VisibleColumns.IndexOf(Col);
      if (Idx > -1) and (Idx <> tbMoveToIndex) then begin
        tbDrawMoveLine;
        tbMoveToIndex := Idx;
        tbDrawMoveLine;
      end;
    end;
  end
end;

procedure TOvcCustomDbTable.WMNCHitTest(var Msg : TMessage);
begin
  if (csDesigning in ComponentState) then
    DefaultHandler(Msg)
  else
    inherited;
end;

procedure TOvcCustomDbTable.WMSetCursor(var Msg : TWMSetCursor);
var
  CurMousePos : TPoint;
  NewCursor   : HCursor;
  OnGridLine  : Boolean;
  InMoveArea  : Boolean;
begin
  {pass along non client hits and reset flags}
  if (Msg.HitTest <> HTCLIENT) or not (hoShowHeader in HeaderOptions) then begin
    inherited;
    if ((tbState * [otsShowSize, otsShowMove]) <> []) then
      tbState := tbState - [otsShowSize, otsShowMove] + [otsNormal];
    Exit;
  end;

  {no size or move while editing}
  if InEditingState then begin
    inherited;
    Exit;
  end;

  {get the mouse cursor position in terms of the table client area}
  GetCursorPos(CurMousePos);
  CurMousePos := ScreenToClient(CurMousePos);

  {work out whether the cursor is over a grid line or on the column
   move area; take into account whether such definitions are allowed}
  OnGridLine := tbIsOnGridLine(CurMousePos.X, CurMousePos.Y);
  if OnGridLine then
    OnGridLine := (dtoAllowColumnSize in Options) or (csDesigning in ComponentState);

  InMoveArea := False;
  if (not OnGridLine) and
     ((dtoAllowColumnMove in Options) or (csDesigning in ComponentState)) then
    InMoveArea := tbIsInMoveArea(CurMousePos.X, CurMousePos.Y);

  {now set the cursor}
  if InMoveArea then begin
    NewCursor := tbColMoveCursor;
    tbState := tbState - [otsNormal, otsShowSize] + [otsShowMove];
  end else if OnGridLine then begin
    NewCursor := Screen.Cursors[crHSplit];
    tbState := tbState - [otsNormal, otsShowMove] + [otsShowSize];
  end else begin
    NewCursor := Screen.Cursors[Cursor];
    tbState := tbState - [otsShowMove, otsShowSize] + [otsNormal];
  end;

  SetCursor(NewCursor);
  Msg.Result := 1;
end;

procedure TOvcCustomDbTable.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;

  InvalidateCell(ActiveRow, ActiveColumn);
  Include(tbState, otsFocused);
  Include(tbState, otsNormal);

  {exit if a new cell is being selected in WMLButtonDown}
  if tbSelectingNewCell then
    Exit;

  {exit if this focus change is due to displaying an error dialog}
  if tbDisplayedError then begin
    tbDisplayedError := False;
    Exit;
  end;

  {if focus isn't comming from our edit cell, try to start editing}
  if not (csDesigning in ComponentState) and (dtoAlwaysEditing in Options) then begin
    if Assigned(tbActiveCell) then begin
      if (tbActiveCell.EditHandle <> Msg.FocusedWnd) then
        PostMessage(Handle, ctim_StartEdit, 0, 0);
    end else
      PostMessage(Handle, ctim_StartEdit, 0, 0);
  end;
end;

procedure TOvcCustomDbTable.WMSize(var Msg : TWMSize);
begin
  inherited;

  {update the datasource's buffer count}
  tbUpdateBufferLimit; {calls tbUpdateActive}
end;

procedure TOvcCustomDbTable.WMVScroll(var Msg : TWMVScroll);
var
  SI : TScrollInfo;
begin
  {ignore SB_ENDSCROLL and SB_THUMBTRACK messages}
  if (Msg.ScrollCode = SB_ENDSCROLL) or
     (Msg.ScrollCode = SB_THUMBTRACK) then begin
    inherited;
    Exit;
  end;

  if (FDataLink.DataSet = nil) then
    Exit;

  {if not focused then do so; if being designed update the table view}
  if not (otsFocused in tbState) then
    SetFocus
  else if (csDesigning in ComponentState) then
    Update;

  {see if the cell being edited is valid; if not exit}
  if InEditingState then
    if not tbActiveCell.CanSaveEditedData(True) then
      Exit;

  if tbIsDbActive then with DataLink do begin
    case Msg.ScrollCode of
      SB_LINEUP        :
        if (dtoPageScroll in Options) then
          Scroll(-ActiveRecord - 1)
        else
          Scroll(-1);
      SB_LINEDOWN      :
        if (dtoPageScroll in Options) then
          Scroll(DataSet.RecordCount - ActiveRecord)
        else
          Scroll(+1);
      SB_PAGEUP        :
        Scroll(-VisibleRowCount);
      SB_PAGEDOWN      :
        Scroll(VisibleRowCount);
      SB_THUMBPOSITION :
        begin
          if DataSet.IsSequenced then begin
            SI.cbSize := SizeOf(SI);
            SI.fMask := SIF_ALL;
            GetScrollInfo(Self.Handle, SB_VERT, SI);
            if SI.nTrackPos <= 1 then
              DataSet.First
            else if SI.nTrackPos >= DataSet.RecordCount then
              DataSet.Last
            else
              DataSet.RecNo := SI.nTrackPos;
          end else
            case Msg.Pos of
              0 : DataSet.First;
              1 : Scroll(-VisibleRowCount);
              2 : Exit;
              3 : Scroll(VisibleRowCount);
              4 : DataSet.Last;
            end;
        end;
      SB_BOTTOM : DataSet.Last;
      SB_TOP    : DataSet.First;
    end;
  end;
end;


end.

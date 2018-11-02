{*********************************************************}
{*                  OVCTABLE.PAS 4.08                    *}
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
{* Roman Kassebaum                                                            *}
{* Patrick Lajko/CDE Software                                                 *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

(*Changes)

  10/20/01- Hdc changed to TOvcHdc for BCB Compatibility
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctable;
  {Orpheus table definitions}

interface

uses
  Types, Windows, SysUtils, Messages, Graphics, Classes, Controls, Forms, StdCtrls,
  Menus, Dialogs, OvcMisc, OvcData, OvcConst, OvcBase, OvcCmd, OvcTCmmn, OvcTCAry,
  OvcTSelL, OvcTCell, OvcTCHdr, OvcTGPns, OvcTbClr, OvcTbRws, OvcTbCls, OvcDrag,
  UITypes;

type
  TOvcCustomTable = class(TOvcTableAncestor)
    {-The custom class for tables}
    protected {private}
      {property fields - even size}
      FActiveCol      : TColNum;             {column of active cell}
      FActiveRow      : TRowNum;             {row of active cell}
      FBlockColBegin  : TColNum;             {start column for settings}
      FBlockColEnd    : TColNum;             {end column for settings}
      FBlockRowBegin  : TRowNum;             {start row for settings}
      FBlockRowEnd    : TRowNum;             {end row for settings}
      FCells          : TOvcTableCells;      {independent cells}
      FColors         : TOvcTableColors;     {table cell colors}
      FCols           : TOvcTableColumns;    {table column definitions}
      FGridPenSet     : TOvcGridPenSet;      {set of grid pens}
      FLeftCol        : TColNum;             {leftmost column}
      FLockedCols     : TColNum;             {number of locked columns}
      FLockedRows     : TRowNum;             {number of locked rows}
      FLockedRowsCell : TOvcBaseTableCell;   {cell for column headings}
      FRows           : TOvcTableRows;       {table row definitions}
      FSelAnchorCol   : TColNum;             {selection: anchor column}
      FSelAnchorRow   : TRowNum;             {selection: anchor row}
      FTopRow         : TRowNum;             {topmost row}
      FColorUnused    : TColor;              {color of unused area}
      FOldRowColBehavior: Boolean;

      {property fields - odd size}
      FAccess      : TOvcTblAccess;          {default access mode for the table}
      FAdjust      : TOvcTblAdjust;          {default adjustment for the table}
      FBorderStyle : TBorderStyle;           {border type around table}
      FOptions     : TOvcTblOptionSet;       {set of table options}
      FScrollBars  : TScrollStyle;           {scroll bar presence}
      Filler       : byte;

      {property event fields}
      FActiveCellChanged  : TCellNotifyEvent;       {active cell changed event}
      FActiveCellMoving   : TCellMoveNotifyEvent;   {active cell moving event}
      FBeginEdit          : TCellBeginEditNotifyEvent;{active cell about to be edited}
      FClipboardCopy      : TNotifyEvent;           {copy to clipboard requested}
      FClipboardCut       : TNotifyEvent;           {cut to clipboard requested}
      FClipboardPaste     : TNotifyEvent;           {paste from clipboard requested}
      FColumnsChanged     : TColChangeNotifyEvent;  {column insert/delete/exchange}
      FDoneEdit           : TCellNotifyEvent;       {active cell has been edited}
      FEndEdit            : TCellEndEditNotifyEvent;{active cell about to be stopped being edited}
      FEnteringColumn     : TColNotifyEvent;        {entering column event}
      FEnteringRow        : TRowNotifyEvent;        {entering row event}
      FGetCellData        : TCellDataNotifyEvent;   {get cell data event}
      FGetCellAttributes  : TCellAttrNotifyEvent;   {get cell attributes event}
      FLeavingColumn      : TColNotifyEvent;        {leaving column event}
      FLeavingRow         : TRowNotifyEvent;        {leaving row event}
      FLockedCellClick    : TCellNotifyEvent;       {locked cell clicked event}
      FPaintUnusedArea    : TNotifyEvent;           {unused bit needs painting event}
      FRowsChanged        : TRowChangeNotifyEvent;  {row insert/delete/exchange}
      FSizeCellEditor     : TSizeCellEditorNotifyEvent;{sizing of cell editor}
      FTopLeftCellChanged : TCellNotifyEvent;       {top left cell change event}
      FTopLeftCellChanging: TCellChangeNotifyEvent; {top left cell moving event}
      FUserCommand        : TUserCommandEvent;      {user command event}
      FOnResizeColumn     : TColResizeEvent;
      FOnResizeRow        : TRowResizeEvent;
      FOnGetRowAttributes : TRowAttrNotifyEvent; //SZ

      {other fields - even size}
      tbColNums : POvcTblDisplayArray;  {displayed column numbers}
      tbRowNums : POvcTblDisplayArray;  {displayed row numbers}
      tbRowsOnLastPage : TRowNum;       {number of complete rows on last page}
      tbLastTopRow : TRowNum;           {the last row number that can be top}
      tbColsOnLastPage : TColNum;       {num of complete columns on rightmost page}
      tbLastLeftCol : TColNum;          {the last column number that can be leftmost}
      tbLockCount : integer;            {the lock display count}
      tbCmdTable : PString;             {the command table name for the grid}
      tbState : TOvcTblStates;          {the state of the table}
      tbSizeOffset : integer;           {the offset of the sizing line}
      tbSizeIndex  : integer;           {the index of the sized row/col}
      tbMoveIndex : integer;            {the index of the column being moved}
      tbMoveIndexTo : integer;          {the index of the column being targeted by move}
      tbLastEntRow : TRowNum;           {last row that was entered}
      tbLastEntCol : TColNum;           {last column that was entered}
      tbActCell : TOvcBaseTableCell;    {the active cell object}
      tbInvCells : TOvcCellArray;       {cells that need repainting}
      tbSelList : TOvcSelectionList;    {list of selected cells}
      tbCellAttrFont : TFont;           {cached font for painting cells}
      tbColMoveCursor : HCursor;        {cursor for column moves}
      tbRowMoveCursor : HCursor;        {cursor for row moves}
      tbHSBarPosCount : integer;        {number of positions for horz scrollbar}
      tbDrag : TOvcDragShow;

      {other fields - odd size}
      tbHasHSBar : boolean;             {true if horiz scroll bar present}
      tbHasVSBar : boolean;             {true if vert scroll bar present}
      tbUpdateSBs : boolean;            {true if the scroll bars must be updated}
      tbIsSelecting : boolean;          {is in mouse selection mode}
      tbIsDeselecting : boolean;        {is in mouse deselection mode}
      tbIsKeySelecting : boolean;       {is in key selection mode}
      tbMustUpdate : boolean;           {scrolling has left an invalid region}
      tbMustFinishLoading : boolean;    {finish loading data in CreateWnd}
      ProcessingVScrollMessage: Boolean;{Internal flag}
      FHasBorderWidth: Boolean;         {true if CellAttr.BorderWidth > 1 in any cell}


    protected
      {property read routines}
      function GetAllowRedraw : boolean;
      function GetColCount : TColNum;
      function GetColOffset(ColNum : TColNum) : integer;
      function GetRowLimit : TRowNum;
      function GetRowOffset(RowNum : TRowNum) : integer;

      {property write routines}
      procedure SetAccess(A : TOvcTblAccess);
      procedure SetActiveCol(ColNum : TColNum);
      procedure SetActiveRow(RowNum : TRowNum); virtual; //R.K.
      procedure SetAdjust(A : TOvcTblAdjust);
      procedure SetAllowRedraw(AR : boolean);
      procedure SetBorderStyle(const BS : TBorderStyle);
      procedure SetBlockAccess(A : TOvcTblAccess);
      procedure SetBlockAdjust(A : TOvcTblAdjust);
      procedure SetBlockCell(C : TOvcBaseTableCell);
      procedure SetBlockColBegin(ColNum : TColNum);
      procedure SetBlockColEnd(ColNum : TColNum);
      procedure SetBlockColor(C : TColor);
      procedure SetBlockFont(F : TFont);
      procedure SetBlockRowBegin(RowNum : TRowNum);
      procedure SetBlockRowEnd(RowNum : TRowNum);
      procedure SetColors(C : TOvcTableColors);
      procedure SetColCount(CC : integer);
      procedure SetCols(CS : TOvcTableColumns);
      procedure SetLeftCol(ColNum : TColNum);
      procedure SetLockedCols(ColNum : TColNum);
      procedure SetLockedRows(RowNum : TRowNum);
      procedure SetLockedRowsCell(C : TOvcBaseTableCell);
      procedure SetOptions(O : TOvcTblOptionSet);
      procedure SetPaintUnusedArea(PUA : TNotifyEvent);
      procedure SetRowLimit(RowNum : TRowNum);
      procedure SetRows(RS : TOvcTableRows);
      procedure SetScrollBars(const SB : TScrollStyle);
      procedure SetTopRow(RowNum : TRowNum);
      procedure SetColorUnused(CU : TColor);

      {overridden Delphi VCL methods}
      procedure ChangeScale(M, D : integer); override;
      procedure Notification(AComponent: TComponent; Operation: TOperation); override;

      {general methods}
      function  tbCalcActiveCellRect(var ACR : TRect) : boolean;
      function  tbCalcCellsFromRect(const UR : TRect; var GR : TRect) : integer;
      procedure tbCalcColData(var CD : POvcTblDisplayArray; NewLeftCol : TColNum);
      procedure tbCalcColsOnLastPage;
      procedure tbCalcHSBarPosCount;
      function  tbCalcRequiresVSBar : boolean;
      procedure tbCalcRowData(var RD : POvcTblDisplayArray; NewTopRow : TRowNum);
      procedure tbCalcRowsOnLastPage;

      procedure tbDrawActiveCell;
      procedure tbDrawCells(RowInxStart, RowInxEnd : integer;
                            ColInxStart, ColInxEnd : integer);
      procedure tbDrawInvalidCells(InvCells : TOvcCellArray);
      procedure tbDrawMoveLine;
      procedure tbDrawRow(RowInx : integer; ColInxStart, ColInxEnd : integer);
      procedure tbDrawSizeLine;
      procedure tbDrawUnusedBit;
      procedure tbDrawCellBorder(RowInx: TRowNum; ColInx: TColNum; CellAttr: TOvcCellAttributes);
      procedure tbDrawCellBorders(RowInxStart, RowInxEnd : integer;
                                  ColInxStart, ColInxEnd : integer);
      procedure tbDrawRowBorder(RowInx: TRowNum; RowAttr: TOvcRowAttributes);
      procedure tbDrawRowBorders(RowInxStart, RowInxEnd : integer);

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
      function  tbEditCellHasFocus(FocusHandle : TOvcHWnd{HWND}) : boolean;

      procedure tbEnsureColumnIsVisible(ColNum : TColNum);
      procedure tbEnsureRowIsVisible(RowNum : TRowNum);

      function  tbFindCell(RowNum : TRowNum;
                           ColNum : TColNum) : TOvcBaseTableCell;
      function  tbFindColInx(ColNum : TColNum) : integer;
      function  tbFindRowInx(RowNum : TRowNum) : integer;

      function  tbIsOnGridLine(MouseX, MouseY : integer;
                               var VerticalGrid : boolean) : boolean;
      function  tbIsInMoveArea(MouseX, MouseY : integer;
                           var IsColMove : boolean) : boolean;
      procedure tbSetActiveCellWithSel(RowNum : TRowNum;
                                       ColNum : TColNum);
      procedure tbSetActiveCellPrim(RowNum : TRowNum; ColNum : TColNum);

      {selection methods}
      procedure tbDeselectAll(CA : TOvcCellArray);
      function tbDeselectAllIterator(RowNum1 : TRowNum; ColNum1 : TColNum;
                                     RowNum2 : TRowNum; ColNum2 : TColNum;
                                     ExtraData : pointer) : boolean;
      procedure tbSelectCol(ColNum : TColNum);
      procedure tbSelectRow(RowNum : TRowNum);
      procedure tbSelectTable;
      procedure tbSetAnchorCell(RowNum : TRowNum; ColNum : TColNum;
                                Action : TOvcTblSelectionType);
      procedure tbUpdateSelection(RowNum : TRowNum; ColNum : TColNum;
                                  Action : TOvcTblSelectionType);

      {notification procedures}
      procedure DoActiveCellChanged(RowNum : TRowNum; ColNum : TColNum);
        virtual;
      procedure DoActiveCellMoving(Command : word; var RowNum : TRowNum;
                                   var ColNum : TColNum); virtual;
      procedure DoBeginEdit(RowNum : TRowNum; ColNum : TColNum;
                            var AllowIt : boolean); virtual;
      procedure DoClipboardCopy; virtual;
      procedure DoClipboardCut; virtual;
      procedure DoClipboardPaste; virtual;
      procedure DoColumnsChanged(ColNum1, ColNum2 : TColNum;
                                 Action : TOvcTblActions); virtual;
      procedure DoDoneEdit(RowNum : TRowNum; ColNum : TColNum); virtual;
      procedure DoEndEdit(Cell : TOvcBaseTableCell;
                          RowNum : TRowNum; ColNum : TColNum;
                          var AllowIt : boolean); virtual;
      procedure DoEnteringColumn(ColNum : TColNum); virtual;
      procedure DoEnteringRow(RowNum : TRowNum); virtual;
      procedure DoGetCellAttributes(RowNum : TRowNum; ColNum : TColNum;
                                    var CellAttr : TOvcCellAttributes); virtual;
      procedure DoGetRowAttributes(RowNum : TRowNum;
                                    var CellAttr : TOvcRowAttributes); virtual;
      procedure DoGetCellData(RowNum : TRowNum; ColNum : TColNum;
                              var Data : pointer;
                              Purpose : TOvcCellDataPurpose); virtual;
      procedure DoLeavingColumn(ColNum : TColNum); virtual;
      procedure DoLeavingRow(RowNum : TRowNum); virtual;
      procedure DoLockedCellClick(RowNum : TRowNum; ColNum : TColNum); virtual;
      procedure DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
        override;
      procedure DoPaintUnusedArea; virtual;
      procedure DoRowsChanged(RowNum1, RowNum2 : TRowNum;
                              Action : TOvcTblActions); virtual;
      procedure DoSizeCellEditor(RowNum   : TRowNum;
                                 ColNum   : TColNum;
                             var CellRect : TRect;
                             var CellStyle: TOvcTblEditorStyle); virtual;
      procedure DoTopLeftCellChanged(RowNum : TRowNum; ColNum : TColNum); virtual;
      procedure DoTopLeftCellChanging(var RowNum : TRowNum;
                                      var ColNum : TColNum); virtual;
      procedure DoUserCommand(Cmd : word); virtual;

      {row/col data retrieval}
      function tbIsColHidden(ColNum : TColNum) : boolean;
	  function tbIsColShowRightLine(ColNum : TColNum) : boolean; //CDE
      function tbIsRowHidden(RowNum : TRowNum) : boolean;
      procedure tbQueryColData(ColNum : TColNum;
                           var W : integer;
                           var A : TOvcTblAccess;
                           var H : boolean);
      procedure tbQueryRowData(RowNum : TRowNum;
                           var Ht: integer;
                           var H : boolean);

      {invalidation}
      procedure tbInvalidateColHdgPrim(ColNum : TColNum; InvCells : TOvcCellArray);
      procedure tbInvalidateRowHdgPrim(RowNum : TRowNum; InvCells : TOvcCellArray);

      {scrollbar stuff}
      procedure tbSetScrollPos(SB : TOvcScrollBar);
      procedure tbSetScrollRange(SB : TOvcScrollBar);

      {active cell movement}
      procedure tbMoveActCellBotOfPage;
      procedure tbMoveActCellBotRight;
      procedure tbMoveActCellDown;
      procedure tbMoveActCellFirstCol;
      procedure tbMoveActCellFirstRow;
      procedure tbMoveActCellLastCol;
      procedure tbMoveActCellLastRow;
      procedure tbMoveActCellLeft;
      procedure tbMoveActCellPageDown;
      procedure tbMoveActCellPageLeft;
      procedure tbMoveActCellPageRight;
      procedure tbMoveActCellPageUp;
      procedure tbMoveActCellRight;
      procedure tbMoveActCellTopLeft;
      procedure tbMoveActCellTopOfPage;
      procedure tbMoveActCellUp;

      {scrollbar scrolling routine}
      procedure tbScrollBarDown;
      procedure tbScrollBarLeft;
      procedure tbScrollBarPageDown;
      procedure tbScrollBarPageLeft;
      procedure tbScrollBarPageRight;
      procedure tbScrollBarPageUp;
      procedure tbScrollBarRight;
      procedure tbScrollBarUp;

      {table scrolling routines}
      procedure tbScrollTableLeft(NewLeftCol : TColNum);
      procedure tbScrollTableRight(NewLeftCol : TColNum);
      procedure tbScrollTableUp(NewTopRow : TRowNum);
      procedure tbScrollTableDown(NewTopRow : TRowNum);

      {notifications}
      procedure tbCellChanged(Sender : TObject); override;
      procedure tbColChanged(Sender : TObject; ColNum1, ColNum2 : TColNum;
                             Action : TOvcTblActions);
      procedure tbGridPenChanged(Sender : TObject);
      procedure tbRowChanged(Sender : TObject; RowNum1, RowNum2 : TRowNum;
                             Action : TOvcTblActions);
      procedure tbColorsChanged(Sender : TObject);

      {streaming routines}
      procedure DefineProperties(Filer : TFiler); override;
      procedure tbFinishLoadingDefaultCells;
      procedure tbReadColData(Reader : TReader);
      procedure tbReadRowData(Reader : TReader);
      procedure tbWriteColData(Writer : TWriter);
      procedure tbWriteRowData(Writer : TWriter);

      {Cell-Table interaction messages}
      procedure ctimLoadDefaultCells(var Msg : TMessage); message ctim_LoadDefaultCells;
      procedure ctimQueryOptions(var Msg : TMessage); message ctim_QueryOptions;
      procedure ctimQueryColor(var Msg : TMessage); message ctim_QueryColor;
      procedure ctimQueryFont(var Msg : TMessage); message ctim_QueryFont;
      procedure ctimQueryLockedCols(var Msg : TMessage); message ctim_QueryLockedCols;
      procedure ctimQueryLockedRows(var Msg : TMessage); message ctim_QueryLockedRows;
      procedure ctimQueryActiveCol(var Msg : TMessage); message ctim_QueryActiveCol;
      procedure ctimQueryActiveRow(var Msg : TMessage); message ctim_QueryActiveRow;
      procedure ctimRemoveCell(var Msg : TMessage); message ctim_RemoveCell;
      procedure ctimStartEdit(var Msg : TMessage); message ctim_StartEdit;
      procedure ctimStartEditMouse(var Msg : TWMMouse); message ctim_StartEditMouse;
      procedure ctimStartEditKey(var Msg : TWMKey); message ctim_StartEditKey;

      {Delphi component messages}
      procedure CMColorChanged(var Msg : TMessage); message CM_COLORCHANGED;
      procedure CMCtl3DChanged(var Msg : TMessage); message CM_CTL3DCHANGED;
      procedure CMDesignHitTest(var Msg : TCMDesignHitTest); message CM_DESIGNHITTEST;
      procedure CMFontChanged(var Msg : TMessage); message CM_FONTCHANGED;

      {Windows messages}
      procedure WMCancelMode(var Msg : TMessage); message WM_CANCELMODE;
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
      procedure WMVScroll(var Msg : TWMScroll); message WM_VSCROLL;

      {unpublishable or should not be published properties}
      property AllowRedraw : boolean
         read GetAllowRedraw write SetAllowRedraw
         stored false;

      property BlockAccess : TOvcTblAccess
         write SetBlockAccess;

      property BlockAdjust : TOvcTblAdjust
         write SetBlockAdjust;

      property BlockColBegin : TColNum
         read FBlockColBegin write SetBlockColBegin;

      property BlockColEnd : TColNum
         read FBlockColEnd write SetBlockColEnd;

      property BlockColor : TColor
         write SetBlockColor;

      property BlockCell : TOvcBaseTableCell
         write SetBlockCell;

      property BlockFont : TFont
         write SetBlockFont;

      property BlockRowBegin : TRowNum
         read FBlockRowBegin write SetBlockRowBegin;

      property BlockRowEnd : TRowNum
         read FBlockRowEnd write SetBlockRowEnd;

      property ColOffset [ColNum : TColNum] : integer
         read GetColOffset;

      property RowOffset [RowNum : TRowNum] : integer
         read GetRowOffset;

      property TableState : TOvcTblStates
         read tbState;

      {publishable properties}
      property Access : TOvcTblAccess
         read FAccess write SetAccess;

      property ActiveCol : TColNum
         read FActiveCol write SetActiveCol;

      property ActiveRow : TRowNum
         read FActiveRow write SetActiveRow;

      property Adjust : TOvcTblAdjust
         read FAdjust write SetAdjust;

      property BorderStyle : TBorderStyle
         read FBorderStyle write SetBorderStyle;

      property ColCount : TColNum
         read GetColCount write SetColCount;

      property Colors : TOvcTableColors
         read FColors write SetColors;

      property ColorUnused : TColor
         read FColorUnused write SetColorUnused;

      property Columns : TOvcTableColumns
         read FCols write SetCols;

      property GridPenSet : TOvcGridPenSet
         read FGridPenSet write FGridPenSet;

      property LeftCol : TColNum
         read FLeftCol write SetLeftCol;

      property LockedCols : TColNum
         read FLockedCols write SetLockedCols;

      property LockedRows : TRowNum
         read FLockedRows write SetLockedRows;

      property LockedRowsCell : TOvcBaseTableCell
         read FLockedRowsCell write SetLockedRowsCell;

      property OldRowColBehavior : Boolean
         read FOldRowColBehavior write FOldRowColBehavior;

      property Options : TOvcTblOptionSet
         read FOptions write SetOptions;

      property RowLimit : TRowNum
         read GetRowLimit write SetRowLimit;

      property Rows : TOvcTableRows
         read FRows write SetRows;

      property ScrollBars : TScrollStyle
         read FScrollBars write SetScrollBars;

      property TopRow : TRowNum
         read FTopRow write SetTopRow;

      {New events}
      property OnActiveCellChanged : TCellNotifyEvent
         read FActiveCellChanged write FActiveCellChanged;

      property OnActiveCellMoving : TCellMoveNotifyEvent
         read FActiveCellMoving write FActiveCellMoving;

      property OnBeginEdit : TCellBeginEditNotifyEvent
         read FBeginEdit write FBeginEdit;

      property OnClipboardCopy : TNotifyEvent
         read FClipboardCopy write FClipboardCopy;

      property OnClipboardCut : TNotifyEvent
         read FClipboardCut write FClipboardCut;

      property OnClipboardPaste : TNotifyEvent
         read FClipboardPaste write FClipboardPaste;

      property OnColumnsChanged : TColChangeNotifyEvent
         read FColumnsChanged write FColumnsChanged;

      property OnDoneEdit : TCellNotifyEvent
         read FDoneEdit write FDoneEdit;

      property OnEndEdit : TCellEndEditNotifyEvent
         read FEndEdit write FEndEdit;

      property OnEnteringColumn : TColNotifyEvent
         read FEnteringColumn write FEnteringColumn;

      property OnEnteringRow : TRowNotifyEvent
         read FEnteringRow write FEnteringRow;

      property OnGetCellData : TCellDataNotifyEvent
         read FGetCellData write FGetCellData;

      property OnGetCellAttributes : TCellAttrNotifyEvent
         read FGetCellAttributes write FGetCellAttributes;

      property OnGetRowAttributes : TRowAttrNotifyEvent
         read FOnGetRowAttributes write FOnGetRowAttributes;

      property OnLeavingColumn : TColNotifyEvent
         read FLeavingColumn write FLeavingColumn;

      property OnLeavingRow : TRowNotifyEvent
         read FLeavingRow write FLeavingRow;

      property OnLockedCellClick : TCellNotifyEvent
         read FLockedCellClick write FLockedCellClick;

      property OnPaintUnusedArea : TNotifyEvent
         read FPaintUnusedArea write SetPaintUnusedArea;

      property OnResizeColumn : TColResizeEvent
         read FOnResizeColumn write FOnResizeColumn;

      property OnResizeRow : TRowResizeEvent
         read FOnResizeRow write FOnResizeRow;

      property OnRowsChanged : TRowChangeNotifyEvent
         read FRowsChanged write FRowsChanged;

      property OnSizeCellEditor : TSizeCellEditorNotifyEvent
         read FSizeCellEditor write FSizeCellEditor;

      property OnTopLeftCellChanged : TCellNotifyEvent
         read FTopLeftCellChanged write FTopLeftCellChanged;

      property OnTopLeftCellChanging : TCellChangeNotifyEvent
         read FTopLeftCellChanging write FTopLeftCellChanging;

      property OnUserCommand : TUserCommandEvent
         read FUserCommand write FUserCommand;

    public
      {overridden methods}
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      procedure CreateParams(var Params : TCreateParams); override;
      procedure CreateWnd; override;
      procedure Loaded; override;
      procedure Paint; override;
      procedure SetBounds(ALeft, ATop, AWidth, AHeight: integer); override;

      {new public methods}
      function CalcRowColFromXY(X, Y : integer;
                                var RowNum : TRowNum;
                                var ColNum : TColNum) : TOvcTblRegion;
      function FilterKey(var Msg : TWMKey) : TOvcTblKeyNeeds; override;
      procedure GetDisplayedColNums(var NA : TOvcTableNumberArray);
      procedure GetDisplayedRowNums(var NA : TOvcTableNumberArray);
      procedure ResolveCellAttributes(RowNum : TRowNum; ColNum : TColNum;
                                      var CellAttr : TOvcCellAttributes); override;
      procedure ResolveRowAttributes(RowNum : TRowNum;
                                     var RowAttr : TOvcRowAttributes);

      {methods for setting cells, faster than setting row/col properties}
      procedure SetActiveCell(RowNum : TRowNum; ColNum : TColNum);
      procedure SetTopLeftCell(RowNum : TRowNum; ColNum : TColNum);

      {methods for calculating next/prev row/col numbers for main area}
      function IncCol(ColNum : TColNum; Direction : integer) : TColNum;
      function IncRow(RowNum : TRowNum; Direction : integer) : TRowNum;

      {methods for invalidating cells to force a redraw}
      procedure InvalidateCell(RowNum : TRowNum; ColNum : TColNum);
      procedure InvalidateColumn(ColNum : TColNum);
      procedure InvalidateRow(RowNum : TRowNum);
      procedure InvalidateTable;
      procedure InvalidateCellsInRect(const R : TRect);
      procedure InvalidateColumnHeading(ColNum : TColNum);
      procedure InvalidateRowHeading(RowNum : TRowNum);
      procedure InvalidateTableNotLockedCols;
      procedure InvalidateTableNotLockedRows;

      {selection methods}
      function HaveSelection : boolean;
      function InSelection(RowNum : TRowNum; ColNum : TColNum) : boolean;
      procedure IterateSelections(SI : TSelectionIterator; ExtraData : pointer);

      {editing state method}
      function InEditingState : boolean;
      function SaveEditedData : boolean;
      function StartEditingState : boolean;
      function StopEditingState(SaveValue : boolean) : boolean;

      {scrollbar scrolling routine}
      procedure ProcessScrollBarClick(ScrollBar : TOvcScrollBar;
                                      ScrollCode : TScrollCode); virtual;

      {active cell movement routine}
      procedure MoveActiveCell(Command : word); virtual;

      {public property}
      property Cells : TOvcTableCells
         read FCells;


    end;

  TOvcTable = class(TOvcCustomTable)
    public
      property AllowRedraw;
      property BlockAccess;
      property BlockAdjust;
      property BlockColBegin;
      property BlockColEnd;
      property BlockColor;
      property BlockCell;
      property BlockFont;
      property BlockRowBegin;
      property BlockRowEnd;
      property Canvas;
      property ColOffset;
      property RowOffset;
      property TableState;
    published
      {Properties}
      property LockedRows default 1;
      property TopRow default 1;
      property ActiveRow default 1;
      property RowLimit default 10;

      property LockedCols default 1;
      property LeftCol default 1;
      property ActiveCol default 1;

      property OldRowColBehavior default false;

      property Anchors;
      property Constraints;
      property DragKind;
      property Access default otxNormal;
      property Adjust default otaCenterLeft;
      property Align;
      property BorderStyle default bsSingle;
      property ColCount stored False;
      property Color default tbDefTableColor;
      property ColorUnused default clWindow;
      property Colors;
      property Columns;
      property Controller;
      property Ctl3D;
      property DragCursor;
      property DragMode;
      property Enabled;
      property Font;
      property GridPenSet;
      property LockedRowsCell;
      property Options default [];
      property ParentColor default False;
      property ParentCtl3D;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property Rows;
      property ScrollBars default ssBoth;
      property ShowHint;
      property TabOrder;
      property TabStop default True;
      property Visible;

      {Events}
      property OnActiveCellChanged;
      property OnActiveCellMoving;
      property OnBeginEdit;
      property OnClipboardCopy;
      property OnClipboardCut;
      property OnClipboardPaste;
      property OnColumnsChanged;
      property OnDblClick;
      property OnDoneEdit;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnEndEdit;
      property OnEnter;
      property OnEnteringColumn;
      property OnEnteringRow;
      property OnExit;
      property OnGetCellData;
      property OnGetCellAttributes;
      property OnGetRowAttributes;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnLeavingColumn;
      property OnLeavingRow;
      property OnLockedCellClick;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnMouseWheel;
      property OnPaintUnusedArea;
      property OnResizeColumn;
      property OnResizeRow;
      property OnRowsChanged;
      property OnSizeCellEditor;
      property OnTopLeftCellChanged;
      property OnTopLeftCellChanging;
      property OnUserCommand;
    end;

implementation
{===== Local Routines ================================================}

function NewString(const S: string): PString;
begin
  New(Result);
  Result^ := S;
end;

procedure DisposeString(P: PString);
begin
  if (P <> nil)
  and (P^ <> '') then
    Dispose(P);
end;


{===== TOvcTable creation and destruction ============================}

constructor TOvcCustomTable.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);

    ProcessingVScrollMessage := false;

    tbState := [otsNormal];

    if NewStyleControls then
      ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csDoubleClicks]
    else
      ControlStyle := ControlStyle + [csOpaque, csCaptureMouse, csDoubleClicks, csFramed];

    Height  := tbDefHeight;
    Width   := tbDefWidth;
    FColorUnused := clWindow;

    ParentColor := false;
    Color := tbDefTableColor;
    TabStop := true;


    FGridPenSet := TOvcGridPenSet.Create;
    FGridPenSet.OnCfgChanged := tbGridPenChanged;

    FColors := TOvcTableColors.Create;
    FColors.OnCfgChanged := tbColorsChanged;

    FCols := TOvcTableColumns.Create(Self, tbDefColCount, TOvcTableColumn);
    FCols.OnColumnChanged := tbColChanged;
    FCols.Table := Self;

    FCells := TOvcTableCells.Create(Self);
    FCells.OnCfgChanged := tbCellChanged;
    FCells.Table := Self;
    tbInvCells := TOvcCellArray.Create;

    FRows := TOvcTableRows.Create;
    RowLimit := tbDefRowCount;
    FRows.OnCfgChanged := tbRowChanged;

    FBorderStyle := tbDefBorderStyle;
    FScrollBars := tbDefScrollBars;
    FAccess := tbDefAccess;
    FAdjust := tbDefAdjust;
    tbCellAttrFont := TFont.Create;

    FActiveCol := tbDefLockedCols;
    FLockedCols := tbDefLockedCols;
    FLeftCol := tbDefLockedCols;
    FSelAnchorCol := tbDefLockedCols;

    FActiveRow := tbDefLockedRows;
    FLockedRows := tbDefLockedRows;
    FTopRow := tbDefLockedRows;
    FSelAnchorRow := tbDefLockedRows;

    tbColMoveCursor := LoadBaseCursor('ORCOLUMNMOVECURSOR');
    tbRowMoveCursor := LoadBaseCursor('ORROWMOVECURSOR');

    tbSelList := TOvcSelectionList.Create(tbDefRowCount, tbDefColCount);

    tbLastEntRow := -1;
    tbLastEntCol := -1;

    tbCmdTable := NewString(GetOrphStr(SCGridTableName));

    AssignDisplayArray(tbColNums, succ(tbDefColCount));
    AssignDisplayArray(tbRowNums, succ(tbDefRowCount));

    if csDesigning in ComponentState then
      tbState := tbState + [otsDesigning]
    else
      tbState := tbState + [otsUnfocused];

    tbMustFinishLoading := true;
  end;
{--------}

destructor TOvcCustomTable.Destroy;
  begin
    if not (csDestroying in ComponentState) then
      Destroying;
    FCols.Free;
    FCells.Free;
    FRows.Free;
    tbInvCells.Free;
    tbSelList.Free;
    tbCellAttrFont.Free;
    if Assigned(tbColNums) then
      AssignDisplayArray(tbColNums, 0);
    if Assigned(tbRowNums) then
      AssignDisplayArray(tbRowNums, 0);
    DisposeString(tbCmdTable);
    GridPenSet.Free;
    FColors.Free;

    DestroyCursor(tbColMoveCursor);
    DestroyCursor(tbRowMoveCursor);

    inherited Destroy;
  end;
{--------}

procedure TOvcCustomTable.CreateParams(var Params: TCreateParams);
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
{--------}

procedure TOvcCustomTable.CreateWnd;
  begin
    inherited CreateWnd;
    {post a message to ourselves to finish loading the cells}
    {--the reason for this is that cell components _may_ be }
    {  on a data module: we must wait until all data modules}
    {  have been created, otherwise we may not pick up some }
    {  cell references (Delphi 2 does not guarantee any     }
    {  particular order for form/data module creation).     }
    PostMessage(Handle, ctim_LoadDefaultCells, 0, 0);

    tbLockCount := 0;

    tbHasHSBar := false;
    tbHasVSBar := false;
    if (FScrollBars = ssBoth) or (FScrollBars = ssHorizontal) then
      tbHasHSBar := true;
    if (FScrollBars = ssBoth) or (FScrollBars = ssVertical) then
      tbHasVSBar := true;

    tbCalcColData(tbColNums, LeftCol);
    tbCalcRowData(tbRowNums, TopRow);
    {make sure the column/row properties are valid}
    LeftCol := LeftCol;
    TopRow := TopRow;
    ActiveCol := ActiveCol;
    ActiveRow := ActiveRow;
    FSelAnchorCol := ActiveCol;
    FSelAnchorRow := ActiveRow;

    {Set up the scrollbars}
    tbSetScrollRange(otsbHorizontal);
    tbSetScrollPos(otsbHorizontal);
    tbSetScrollRange(otsbVertical);
    tbSetScrollPos(otsbVertical);

    {Must trigger the active cell and topleft cell change events}
    DoTopLeftCellChanged(TopRow, LeftCol);
    DoActiveCellChanged(ActiveRow, ActiveCol);

    if not (otsDesigning in tbState) and (otoAlwaysEditing in Options) then
      PostMessage(Handle, ctim_StartEdit, 0, 0);
  end;
{--------}

procedure TOvcCustomTable.Loaded;
  begin
    inherited Loaded;
  end;

{==TOvcTable property streaming routines=============================}

procedure TOvcCustomTable.DefineProperties(Filer : TFiler);
  begin
    inherited DefineProperties(Filer);
    with Filer do
      begin
        DefineProperty('RowData', tbReadRowData, tbWriteRowData, true);
        DefineProperty('ColData', tbReadColData, tbWriteColData, true);
      end;
  end;
{--------}

procedure TOvcCustomTable.tbFinishLoadingDefaultCells;
  var
    i : integer;
  begin
    FCols.tcStopLoading;
    {if our cell list is empty refresh it now}
    if (taCellList.Count = 0) then
      begin
        if Assigned(FLockedRowsCell) then
          tbIncludeCell(FLockedRowsCell);
        for i := 0 to pred(FCols.Count) do
          tbIncludeCell(FCols.DefaultCell[i]);
        {we don't have to do the Cells matrix: no design time support}
      end;
  end;
{--------}

procedure TOvcCustomTable.tbReadColData(Reader : TReader);
  var
    ColObj   : TOvcTableColumn;
    Fixups   : TStringList;
  begin
    AllowRedraw := false;
    with Reader do
      begin
        ReadListBegin;
        FCols.Clear;
        Fixups := FCols.tcStartLoading;
        while not EndOfList do
          begin
            ColObj := TOvcTableColumn.Create(Self);
            ColObj.Width := Readinteger;
            ColObj.Hidden := ReadBoolean;
            if ReadBoolean then
              Fixups.AddObject(ReadString, ColObj);
            FCols.Append(ColObj);
          end;
        ReadListEnd;
      end;
    AllowRedraw := true;
  end;
{--------}

procedure TOvcCustomTable.tbReadRowData(Reader : TReader);
  var
    RowNum   : TRowNum;
    RS       : TRowStyle;
  begin
    with Reader do
      begin
        ReadListBegin;
        FRows.Clear;
        FRows.DefaultHeight := Readinteger;
        while not EndOfList do
          begin
            RowNum := Readinteger;
            RS.Hidden := ReadBoolean;
            RS.Height := Readinteger;
            FRows[RowNum] := RS;
          end;
        ReadListEnd;
      end;
  end;
{--------}

procedure TOvcCustomTable.tbWriteColData(Writer : TWriter);
  var
    ColNum : TColNum;
    S : string;
  begin
    if tbMustFinishLoading then begin
      tbFinishLoadingCellList;
      tbFinishLoadingDefaultCells;
      tbMustFinishLoading := false;
    end;

    with Writer do
      begin
        WriteListBegin;
        for ColNum := 0 to pred(ColCount) do
          with FCols[ColNum] do
            begin
              WriteInteger(Width);
              WriteBoolean(Hidden);
              if (DefaultCell <> nil) then
                begin
                  WriteBoolean(true);
                  S := DefaultCell.Owner.Name;
                  if (S <> '') then
                    S := S + '.' + DefaultCell.Name
                  else
                    S := DefaultCell.Name;
                  WriteString(S);
                end
              else
                WriteBoolean(false);
            end;
        WriteListEnd;
      end;
  end;
{--------}

procedure TOvcCustomTable.tbWriteRowData(Writer : TWriter);
  var
    RowNum   : TRowNum;
    RS       : TRowStyle;
  begin
    with Writer do
      begin
        WriteListBegin;
        Writeinteger(FRows.DefaultHeight);
        for RowNum := 0 to pred(FRows.Limit) do
          if FRows.RowIsSpecial[RowNum] then
            begin
              Writeinteger(RowNum);
              RS := FRows[RowNum];
              WriteBoolean(RS.Hidden);
              Writeinteger(RS.Height);
            end;
        WriteListEnd;
      end;
  end;
{====================================================================}


{==TOvcTable property read routines==================================}
function TOvcCustomTable.GetAllowRedraw : boolean;
  begin
    Result := (tbLockCount = 0);
  end;
{--------}
function TOvcCustomTable.GetColCount : TColNum;
  begin
    Result := FCols.Count;
  end;
{--------}
function TOvcCustomTable.GetColOffset(ColNum : TColNum) : integer;
  var
    ColInx : integer;
  begin
    ColInx := tbFindColInx(ColNum);
    if (ColInx <> -1) then
      Result := tbColNums^.Ay[ColInx].Offset
    else
      Result := -1;
  end;
{--------}
function TOvcCustomTable.GetRowLimit : TRowNum;
  begin
    Result := FRows.Limit;
  end;
{--------}
function TOvcCustomTable.GetRowOffset(RowNum : TRowNum) : integer;
  var
    RowInx : integer;
  begin
    RowInx := tbFindRowInx(RowNum);
    if (RowInx <> -1) then
      Result := tbRowNums^.Ay[RowInx].Offset
    else
      Result := -1;
  end;
{--------}
procedure TOvcCustomTable.ResolveCellAttributes(RowNum : TRowNum; ColNum : TColNum;
                                            var CellAttr : TOvcCellAttributes);
  var
    TempAccess    : TOvcTblAccess;
    TempAdjust    : TOvcTblAdjust;
    TempColor     : TColor;
    TempFontColor : TColor;
    TempSparseAttr: TOvcSparseAttr;
  begin
    FCells.ResolveFullAttr(RowNum, ColNum, TempSparseAttr);
    with CellAttr do
      begin
        {calculate the access rights}
        TempAccess := TempSparseAttr.scaAccess;
        if (TempAccess = otxDefault) then
          begin
            TempAccess := caAccess;
            if (TempAccess = otxDefault) then
              TempAccess := Access;
          end;
        caAccess := TempAccess;
        {calculate the adjustment}
        TempAdjust := TempSparseAttr.scaAdjust;
        if (TempAdjust = otaDefault) then
          begin
            TempAdjust := caAdjust;
            if (TempAdjust = otaDefault) then
              TempAdjust := Adjust;
          end;
        caAdjust := TempAdjust;
        {calculate the font}
        if Assigned(TempSparseAttr.scaFont) then
          caFont.Assign(TempSparseAttr.scaFont);
        {calculate the colors}
        if (RowNum = ActiveRow) and (ColNum = ActiveCol) then
          if (otsFocused in tbState) then
            if InEditingState or
               ((otoAlwaysEditing in Options) and (caAccess = otxNormal)) then
              begin
                TempColor := Colors.Editing;
                TempFontColor := Colors.EditingText
              end
            else
              begin
                TempColor := Colors.ActiveFocused;
                TempFontColor := Colors.ActiveFocusedText;
              end
          else
            begin
              TempColor := Colors.ActiveUnfocused;
              TempFontColor := Colors.ActiveUnfocusedText;
            end
        else
          begin
            if (RowNum = ActiveRow) and (otoBrowseRow in FOptions) then
              if (otsFocused in tbState) then
                begin
                  TempColor := Colors.ActiveFocused;
                  TempFontColor := Colors.ActiveFocusedText;
                end
              else
                begin
                  TempColor := Colors.ActiveUnfocused;
                  TempFontColor := Colors.ActiveUnfocusedText;
                end
            else if InSelection(RowNum, ColNum) then
              begin
                TempColor := Colors.Selected;
                TempFontColor := Colors.SelectedText;
              end
            else
              begin
                TempColor := TempSparseAttr.scaColor;
                if Assigned(TempSparseAttr.scaFont) then
                  TempFontColor := TempSparseAttr.scaFont.Color
                else if (RowNum < LockedRows) or (ColNum < LockedCols) then
                  TempFontColor := Colors.LockedText
                else
                  TempFontColor := caFontColor;
                if (TempColor = clOvcTableDefault) then
                  if (RowNum < LockedRows) or (ColNum < LockedCols) then
                    TempColor := Colors.Locked
                  else
                    TempColor := caColor;
              end;
          end;
        caColor := TempColor;
        caFontColor := TempFontColor;
      end;
    DoGetCellAttributes(RowNum, ColNum, CellAttr);
  end;

procedure TOvcCustomTable.ResolveRowAttributes(RowNum: TRowNum;
  var RowAttr: TOvcRowAttributes);
begin
  DoGetRowAttributes(RowNum, RowAttr);
end;

{====================================================================}


{==TOvcTable property write routines=================================}
procedure TOvcCustomTable.SetAccess(A : TOvcTblAccess);
  var
    TempAccess : TOvcTblAccess;
  begin
    if (A = otxDefault) then
         TempAccess := tbDefAccess
    else TempAccess := A;
    if (TempAccess <> FAccess) then
      begin
        AllowRedraw := false;
        try
          if (TempAccess = otxInvisible) or (FAccess = otxInvisible) then
            InvalidateTable;
          FAccess := TempAccess;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.SetActiveCell(RowNum : TRowNum; ColNum : TColNum);
  begin
    DoActiveCellMoving(ccNone, RowNum, ColNum);
    tbSetActiveCellWithSel(RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.tbSetActiveCellWithSel(RowNum : TRowNum;
                                                 ColNum : TColNum);
  begin
    if tbIsKeySelecting then
      tbUpdateSelection(RowNum, ColNum, tstDeselectAll)
    else
      tbSetAnchorCell(RowNum, ColNum, tstDeselectAll);
    tbSetActiveCellPrim(RowNum, ColNum);
  end;
{--------}

procedure TOvcCustomTable.tbSetActiveCellPrim(RowNum : TRowNum; ColNum : TColNum);
  var
    TempInvCells : TOvcCellArray;
  begin
    {verify the row/column numbers to be visible}
    RowNum := IncRow(RowNum, 0);
    ColNum := IncCol(ColNum, 0);
    {if nothing to do, get out}
    if (RowNum = FActiveRow) and (ColNum = FActiveCol) then
      Exit;
    {if can't do anything visually, just set the internal fields and
     then exit}
    if (not HandleAllocated) or
       (tbRowNums^.Count = 0) or (tbColNums^.Count = 0) then
      begin
        FActiveRow := RowNum;
        FActiveCol := ColNum;
        Exit;
      end;
    {set the new active cell}
    TempInvCells := nil;
    AllowRedraw := false;
    try
      TempInvCells := TOvcCellArray.Create;
      if (RowNum <> FActiveRow) then
        begin
          tbInvalidateRowHdgPrim(FActiveRow, TempInvCells);
          InvalidateRowHeading(RowNum);
          DoLeavingRow(FActiveRow);
        end;
      if (ColNum <> FActiveCol) then
        begin
          tbInvalidateColHdgPrim(FActiveCol, TempInvCells);
          InvalidateColumnHeading(ColNum);
          DoLeavingColumn(FActiveCol);
        end;
      tbInvCells.DeleteCell(ActiveRow, ActiveCol);
      TempInvCells.AddCell(ActiveRow, ActiveCol);

      if not OldRowColBehavior then
        if FActiveRow <> RowNum then
          DoEnteringRow(RowNum);

      FActiveRow := RowNum;

      if not OldRowColBehavior then
        if FActiveCol <> ColNum then
          DoEnteringColumn(ColNum);

      FActiveCol := ColNum;
      tbDrawInvalidCells(TempInvCells);
      tbEnsureRowIsVisible(RowNum);
      tbEnsureColumnIsVisible(ColNum);
      if not (otsDesigning in tbState) and (otoAlwaysEditing in Options) then
        PostMessage(Handle, ctim_StartEdit, 0, 0)
      else
        InvalidateCell(ActiveRow, ActiveCol);
    finally
      AllowRedraw := true;
      TempInvCells.Free;
    end;{try..finally}
    tbSetScrollPos(otsbHorizontal);
    tbSetScrollPos(otsbVertical);
    DoActiveCellChanged(RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.SetActiveCol(ColNum : TColNum);
  begin
    SetActiveCell(FActiveRow, ColNum);
  end;
{--------}
procedure TOvcCustomTable.SetActiveRow(RowNum : TRowNum);
  begin
    SetActiveCell(RowNum, FActiveCol);
  end;
{--------}
procedure TOvcCustomTable.SetAdjust(A : TOvcTblAdjust);
  var
    TempAdjust : TOvcTblAdjust;
  begin
    if (A = otaDefault) then
         TempAdjust := tbDefAdjust
    else TempAdjust := A;
    if (TempAdjust <> FAdjust) then
      begin
        AllowRedraw := false;
        try
          InvalidateTable;
          FAdjust := TempAdjust;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.SetAllowRedraw(AR : boolean);
  var
    CellRect : TRect;
    MustFocus: boolean;
    R        : TRect;
    CellStyle: TOvcTblEditorStyle;
  begin
    if AR {AllowRedraw is true} then
      begin
        dec(tbLockCount);
        if (tbLockCount <= 0) then
          begin
            {Setting the tbLockCount explicitly to zero is to catch
             programmers who call AllowRedraw := true once to often}
            tbLockCount := 0;
            {Update the scroll bars}
            if tbUpdateSBs then
              begin
                tbUpdateSBs := false;
                tbSetScrollPos(otsbHorizontal);
                tbSetScrollPos(otsbVertical);
              end;
            {if in row selection mode invalidate it}
            if (otoBrowseRow in Options) then
              InvalidateRow(ActiveRow);
            {draw the invalid and active cells if we have a handle}
            if HandleAllocated then
              begin
                {redraw invalid cells}
                if not tbInvCells.Empty then
                  tbDrawInvalidCells(tbInvCells);
                if (otsHiddenEdit in tbState) then
                  begin
                    if tbCalcActiveCellRect(CellRect) then
                      begin
                        {note: cell style is ignored here}
                        CellStyle := tesNormal;
                        DoSizeCellEditor(ActiveRow, ActiveCol, CellRect, CellStyle);
                        MustFocus := Focused;
                        tbActCell.EditMove(CellRect);
                        tbState := tbState - [otsHiddenEdit] + [otsEditing];
                        if MustFocus then
                          Windows.SetFocus(tbActCell.EditHandle);
                      end
                  end
                else
                  tbDrawActiveCell;
              end;
          end;
      end
    else
      begin
        inc(tbLockCount);
        if (tbLockCount = 1) and (HandleAllocated) then
          begin
            if (otoBrowseRow in Options) then
              InvalidateRow(ActiveRow);
            if (otsEditing in tbState) then
              begin
                MustFocus := tbEditCellHasFocus(Windows.GetFocus);
                GetWindowRect(tbActCell.EditHandle, R);
                R.TopLeft := ScreenToClient(R.TopLeft);
                R.BottomRight := ScreenToClient(R.BottomRight);
                InvalidateCellsInRect(R);
                tbActCell.EditHide;
                tbState := tbState - [otsEditing] + [otsHiddenEdit];
                if MustFocus then
                  SetFocus;
              end
            else if not (otoBrowseRow in Options) then
              InvalidateCell(ActiveRow, ActiveCol);
          end;
      end;
  end;
{--------}
procedure TOvcCustomTable.SetBorderStyle(const BS : TBorderStyle);
  begin
    if (BS <> BorderStyle) then
      begin
        FBorderStyle := BS;
        RecreateWnd;
      end;
  end;
{--------}
procedure TOvcCustomTable.SetBlockAccess(A : TOvcTblAccess);
  var
    R : TRowNum;
    C : TColNum;
  begin
    for R := BlockRowBegin to BlockRowEnd do
      for C := BlockColBegin to BlockColEnd do
        FCells.Access[R, C] := A;
  end;
{--------}
procedure TOvcCustomTable.SetBlockAdjust(A : TOvcTblAdjust);
  var
    R : TRowNum;
    C : TColNum;
  begin
    for R := BlockRowBegin to BlockRowEnd do
      for C := BlockColBegin to BlockColEnd do
        FCells.Adjust[R, C] := A;
  end;
{--------}
procedure TOvcCustomTable.SetBlockCell(C : TOvcBaseTableCell);
  var
    Rn : TRowNum;
    Cn : TColNum;
  begin
    for Rn := BlockRowBegin to BlockRowEnd do
      for Cn := BlockColBegin to BlockColEnd do
        FCells.Cell[Rn, Cn] := C;
  end;
{--------}
procedure TOvcCustomTable.SetBlockColBegin(ColNum : TColNum);
  begin
    if (ColNum <> FBlockColBegin) then
      if (0 <= ColNum) and (ColNum < ColCount) then
        begin
          FBlockColBegin := ColNum;
          if (FBlockColEnd < FBlockColBegin) then
            FBlockColEnd := ColNum;
        end;
  end;
{--------}
procedure TOvcCustomTable.SetBlockColEnd(ColNum : TColNum);
  begin
    if (ColNum <> FBlockColEnd) then
      if (0 <= ColNum) and (ColNum < ColCount) then
        begin
          FBlockColEnd := ColNum;
          if (FBlockColEnd < FBlockColBegin) then
            FBlockColBegin := ColNum;
        end;
  end;
{--------}
procedure TOvcCustomTable.SetBlockColor(C : TColor);
  var
    Rn : TRowNum;
    Cn : TColNum;
  begin
    for Rn := BlockRowBegin to BlockRowEnd do
      for Cn := BlockColBegin to BlockColEnd do
        FCells.Color[Rn, Cn] := C;
  end;
{--------}
procedure TOvcCustomTable.SetBlockFont(F : TFont);
  var
    R : TRowNum;
    C : TColNum;
  begin
    for R := BlockRowBegin to BlockRowEnd do
      for C := BlockColBegin to BlockColEnd do
        FCells.Font[R, C] := F;
  end;
{--------}
procedure TOvcCustomTable.SetBlockRowBegin(RowNum : TRowNum);
  begin
    if (RowNum <> FBlockRowBegin) then
      if (0 <= RowNum) and (RowNum < RowLimit) then
        begin
          FBlockRowBegin := RowNum;
          if (FBlockRowEnd < FBlockRowBegin) then
            FBlockRowEnd    := RowNum;
        end;
  end;
{--------}
procedure TOvcCustomTable.SetBlockRowEnd(RowNum : TRowNum);
  begin
    if (RowNum <> FBlockRowEnd) then
      if (0 <= RowNum) and (RowNum < RowLimit) then
        begin
          FBlockRowEnd := RowNum;
          if (FBlockRowEnd < FBlockRowBegin) then
            FBlockRowBegin := RowNum;
        end;
  end;
{--------}
procedure TOvcCustomTable.SetColors(C : TOvcTableColors);
  begin
    FColors.Assign(C);
  end;
{--------}
procedure TOvcCustomTable.SetColorUnused(CU : TColor);
  begin
    if (CU <> ColorUnused) then
      begin
        AllowRedraw := false;
        FColorUnused := CU;
        tbInvCells.AddUnusedBit;
        AllowRedraw := true;
      end;
  end;
{--------}
procedure TOvcCustomTable.SetColCount(CC : integer);
  begin
    if (CC <> ColCount) and (CC > LockedCols) then
      begin
        AllowRedraw := false;
        try
          Columns.Count := CC;
          tbSelList.SetColCount(CC);
          tbSetScrollRange(otsbHorizontal);
          if (CC <= ActiveCol) then
            ActiveCol := pred(CC);
          if (CC <= LeftCol) then
            LeftCol := pred(CC);
          if (CC <= FSelAnchorCol) then
            FSelAnchorCol := pred(CC);
          if (CC <= BlockColBegin) then
            BlockColBegin := pred(CC);
          if (CC <= BlockColEnd) then
            BlockColEnd := pred(CC);
          tbSetScrollPos(otsbHorizontal);

        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.SetCols(CS : TOvcTableColumns);
  begin
    AllowRedraw := false;
    try
      FCols.Free;
      FCols := CS;
      FCols.Table := Self;
      FCols.OnColumnChanged := tbColChanged;
      tbColChanged(FCols, 0, 0, taGeneral);
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.SetLeftCol(ColNum : TColNum);
  begin
    SetTopLeftCell(TopRow, ColNum);
  end;
{--------}
procedure TOvcCustomTable.SetLockedCols(ColNum : TColNum);
  begin
    if not HandleAllocated then
      FLockedCols := ColNum
    else
      if (ColNum <> FLockedCols) then
        if (0 <= ColNum) and (ColNum < ColCount) then
          begin
            AllowRedraw := false;
            try
              FLockedCols := ColNum;
              if LeftCol < ColNum then
                LeftCol := LeftCol; {this does do something!}
              if (ActiveCol < ColNum) then
                ActiveCol := LeftCol; {this does do something!}
              tbCalcColData(tbColNums, LeftCol);
              InvalidateTable;
            finally
              AllowRedraw := true;
            end;{try..finally}
            tbSetScrollRange(otsbHorizontal);
            tbSetScrollPos(otsbHorizontal);
          end;
  end;
{--------}
procedure TOvcCustomTable.SetLockedRows(RowNum : TRowNum);
  begin
    if not HandleAllocated then
      FLockedRows := RowNum
    else
      if (RowNum <> FLockedRows) then
        if (0 <= RowNum) then
          begin
            AllowRedraw := false;
            try
              FLockedRows := RowNum;
              if (TopRow < RowNum) then
                TopRow := TopRow; {this does do something!}
              if (ActiveRow < RowNum) then
                ActiveRow := ActiveRow; {this does do something!}
              tbCalcRowData(tbRowNums, TopRow);
              InvalidateTable;
            finally
              AllowRedraw := true;
            end;{try..finally}
            tbSetScrollRange(otsbVertical);
            tbSetScrollPos(otsbVertical);
          end;
  end;
{--------}
procedure TOvcCustomTable.SetLockedRowsCell(C : TOvcBaseTableCell);
  var
    DoIt : boolean;
  begin
    DoIt := false;
    if (C <> FLockedRowsCell) then
      if Assigned(C) then
        begin
          if (C.References = 0) or
             ((C.References > 0) and (C.Table = Self)) then
            DoIt := true;
        end
      else
        DoIt := true;

    if DoIt then
      begin
        if Assigned(FLockedRowsCell) then
          FLockedRowsCell.DecRefs;
        FLockedRowsCell := C;
        if Assigned(FLockedRowsCell) then
          begin
            if (FLockedRowsCell.References = 0) then
              FLockedRowsCell.Table := Self;
            FLockedRowsCell.IncRefs;
          end;
        tbCellChanged(Self);
      end;
  end;
{--------}
procedure TOvcCustomTable.SetOptions(O : TOvcTblOptionSet);
  begin
    AllowRedraw := false;
    try
      FOptions := O;
      if HaveSelection then
        begin
          tbIsSelecting := false;
          tbIsDeselecting := false;
          tbSetAnchorCell(ActiveRow, ActiveCol, tstDeselectAll);
        end;
      {patch up the options set to exclude meaningless combinations}
      if (otoBrowseRow in FOptions) then
        begin
          FOptions := FOptions +
             [otoNoSelection, otoNoRowResizing{, otoNoColResizing}] -
             [otoMouseDragSelect, otoRowSelection, otoColSelection];
        end;
      if (otoAlwaysEditing in FOptions) then
        begin
          FOptions := FOptions +
             [otoNoSelection, otoNoRowResizing, otoNoColResizing] -
             [otoMouseDragSelect, otoRowSelection, otoColSelection];
        end
      else if (otoNoSelection in FOptions) then
        begin
          FOptions := FOptions -
             [otoMouseDragSelect, otoRowSelection, otoColSelection];
        end;
      if (otoRowSelection in FOptions) then
        FOptions := FOptions - [otoAllowRowMoves];
      if (otoColSelection in FOptions) then
        FOptions := FOptions - [otoAllowColMoves];
      InvalidateTable;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.SetPaintUnusedArea(PUA : TNotifyEvent);
  begin
    AllowRedraw := false;
    FPaintUnusedArea := PUA;
    tbInvCells.AddUnusedBit;
    AllowRedraw := true;
  end;
{--------}
procedure TOvcCustomTable.SetRowLimit(RowNum : TRowNum);
  begin
    if (RowNum <> FRows.Limit) and (RowNum > LockedRows) then
      begin
        AllowRedraw := false;
        try
          FRows.Limit := RowNum;
          tbSelList.SetRowCount(RowLimit);
          tbSetScrollRange(otsbVertical);
          if (RowNum <= ActiveRow) then
            ActiveRow := pred(RowNum);
          if (RowNum <= TopRow) then
            TopRow := pred(RowNum);
          if (RowNum <= FSelAnchorRow) then
            FSelAnchorRow := pred(RowNum);
          if (RowNum <= BlockRowBegin) then
            BlockRowBegin := pred(RowNum);
          if (RowNum <= BlockRowEnd) then
            BlockRowEnd := pred(RowNum);
          tbSetScrollPos(otsbVertical);
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.SetRows(RS : TOvcTableRows);
  begin
    AllowRedraw := false;
    try
      FRows.Free;
      FRows := RS;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.SetScrollBars(const SB : TScrollStyle);
  begin
    if (SB <> ScrollBars) then
      begin
        FScrollBars := SB;
        RecreateWnd;
      end;
  end;
{--------}
procedure TOvcCustomTable.SetTopRow(RowNum : TRowNum);
  begin
    SetTopLeftCell(RowNum, LeftCol);
  end;
{--------}
procedure TOvcCustomTable.SetTopLeftCell(RowNum : TRowNum; ColNum : TColNum);
  begin
    {ensure that the new top left cell minimises the unused space}
    if (ColNum > tbLastLeftCol) then
      ColNum := tbLastLeftCol;
    if (RowNum > tbLastTopRow) then
      RowNum := tbLastTopRow;
    {ensure that RowNum and C are not hidden}
    RowNum := IncRow(RowNum, 0);
    ColNum := IncCol(ColNum, 0);
    DoTopLeftCellChanging(RowNum, ColNum);
    {change the topmost row and leftmost column if required}
    if not HandleAllocated then
      begin
        FTopRow := RowNum;
        FLeftCol := ColNum;
      end
    else
      if (RowNum <> FTopRow) or (ColNum <> FLeftCol) then
        begin
          AllowRedraw := false;
          {note: the tbScrollTableXxx routines set FTopRow and FLeftCol}
          try
            if (RowNum > FTopRow) then
              tbScrollTableUp(RowNum)
            else if (RowNum < FTopRow) then
              tbScrollTableDown(RowNum);
            if (ColNum > FLeftCol) then
              tbScrollTableLeft(ColNum)
            else if (ColNum < FLeftCol) then
              tbScrollTableRight(ColNum);
          finally
            AllowRedraw := true;
          end;{try..finally}
          tbSetScrollPos(otsbVertical);
          tbSetScrollPos(otsbHorizontal);
          DoTopLeftCellChanged(RowNum, ColNum);
        end;
  end;
{====================================================================}


{==TOvcTable Scroller routines=======================================}
procedure TOvcCustomTable.tbSetScrollPos(SB : TOvcScrollBar);
  var
    ColNum  : TColNum;
    ColCnt  : TColNum;
    Divisor : Integer;
  begin
    if (SB = otsbVertical) then
      begin
        if tbHasVSBar then
          if HandleAllocated and (tbLockCount = 0) then
            begin
              if (tbLastTopRow < 16*1024) then
                SetScrollPos(Handle, SB_VERT, TopRow, true)
              else
                begin
                  if (tbLastTopRow > (16 * 1024)) then
                    Divisor := RowLimit div $400
                  else
                    Divisor := RowLimit div $40;
                  SetScrollPos(Handle, SB_VERT,
                                        TopRow div Divisor,
                                        True);
                end
            end
          else
            tbUpdateSBs := true;
      end
    else {SB = otsbHorizontal}
      begin
        if tbHasHSBar then
          if HandleAllocated and (tbLockCount = 0) then
            begin
              ColCnt := 0;
              for ColNum := LockedCols to pred(LeftCol) do
                if not tbIsColHidden(ColNum) then
                  inc(ColCnt);
              SetScrollPos(Handle, SB_HORZ, ColCnt, true)
            end
          else
            tbUpdateSBs := true;
      end;
  end;
{--------}

procedure TOvcCustomTable.tbSetScrollRange(SB : TOvcScrollBar);
  var
    Divisor : Integer;
  begin
    if (SB = otsbVertical) then
      begin
        if HandleAllocated then
          tbCalcRowsOnLastPage;
        if tbHasVSBar and HandleAllocated then
          begin
//            tbCalcRowsOnLastPage;
            if (tbLastTopRow < 16*1024) then
              if tbCalcRequiresVSBar then
                SetScrollRange(Handle, SB_Vert, LockedRows, tbLastTopRow, false)
              else
                SetScrollRange(Handle, SB_Vert, LockedRows, LockedRows, false)
            else begin
              if (tbLastTopRow > (16*1024)) then
                Divisor := Succ(tbLastTopRow div $400)
              else
                Divisor := Succ(tbLastTopRow div $40);
              SetScrollRange(Handle, SB_Vert,
                                     LockedRows,
                                     tbLastTopRow div Divisor,
                                     False)
            end;
          end
      end
    else {SB = otsbHorizontal}
      begin
        tbCalcColsOnLastPage;
        if tbHasHSBar and HandleAllocated then
          begin
            tbCalcHSBarPosCount;
            SetScrollRange(Handle, SB_HORZ, 0, pred(tbHSBarPosCount), false);
          end;
      end;
  end;
{====================================================================}


{==TOvcTable editing routines========================================}
function TOvcCustomTable.FilterKey(var Msg : TWMKey) : TOvcTblKeyNeeds;
  var
    Cmd : word;
  begin
    Result := otkDontCare;
    Cmd := Controller.EntryCommands.TranslateUsing([tbCmdTable^], TMessage(Msg));
    {first the hard coded keys}
    case Msg.CharCode of
      VK_RETURN :
        if (otoEnterToArrow in Options) then
          Result := otkMustHave;
      VK_TAB :
        if (otoTabToArrow in Options) then
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
    end;{case}
  end;
{--------}
function TOvcCustomTable.SaveEditedData : boolean;
  var
    Data      : pointer;
  begin
    Result := true;
    if InEditingState then
      begin
        Result := false;
        if not tbActCell.CanSaveEditedData(true) then
          Exit;
        Result := true;
        DoEnteringColumn(ActiveCol);
        DoEnteringRow(ActiveRow);
        DoGetCellData(ActiveRow, ActiveCol, Data, cdpForSave);
        tbActCell.SaveEditedData(Data);
      end;
  end;
{--------}
function TOvcCustomTable.StartEditingState : boolean;
  var
    CellRect : TRect;
    Data     : pointer;
    CellAttr : TOvcCellAttributes;
    CellStyle: TOvcTblEditorStyle;
  begin
    Result := true;
    if InEditingState then
      Exit;
    DoBeginEdit(ActiveRow, ActiveCol, Result);
    if not Result then
      Exit;
    Result := false;
    AllowRedraw := false;
    try
      tbEnsureRowIsVisible(ActiveRow);
      tbEnsureColumnIsVisible(ActiveCol);
      tbActCell := tbFindCell(ActiveRow, ActiveCol);
      if Assigned(tbActCell) then
        begin
          FillChar(CellAttr, sizeof(CellAttr), 0);
          CellAttr.caFont := tbCellAttrFont;
          CellAttr.caFont.Assign(Font);
          tbActCell.ResolveAttributes(ActiveRow, ActiveCol, CellAttr);
          if (CellAttr.caAccess = otxNormal) then
            begin
              if not tbCalcActiveCellRect(CellRect) then
                {we're in big trouble, lads};
              CellStyle := tesNormal;
              DoSizeCellEditor(ActiveRow, ActiveCol, CellRect, CellStyle);
              DoEnteringColumn(ActiveCol);
              DoEnteringRow(ActiveRow);
              DoGetCellData(ActiveRow, ActiveCol, Data, cdpForEdit);
              tbState := tbState - [otsNormal] + [otsHiddenEdit];
              { 06/2011, AB: To allow the user to use the "normal" colors (as set in the
                             OnGetCellAttributes-event) we only set the colors if text and
                             background colors are different. }
              if Colors.Editing<>Colors.EditingText then begin
                CellAttr.caColor := Colors.Editing;
                CellAttr.caFontColor := Colors.EditingText;
              end;
              tbActCell.StartEditing(ActiveRow, ActiveCol, CellRect, CellAttr, CellStyle, Data);
              Result := (tbActCell.EditHandle <> 0);
              if not Result then
                begin
                  tbState := tbState + [otsNormal] - [otsHiddenEdit];
                  tbActCell := nil;
                end;
            end
          else
            tbActCell := nil;
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
function TOvcCustomTable.StopEditingState(SaveValue : boolean) : boolean;
  var
    Data      : pointer;
    MustFocus : boolean;

    R : TRect;

  begin
    Result := true;
    if not InEditingState then
      Exit;
    Result := false;
{
fix(?) for issue 873422
Check that tbActCell is assigned, exit if not.
As far as I can see there is absolutely no way this could happen. If we are in
the editing state we are about to leave we also have an active cell. However
this still happens to btmi - Peter Grimshaw - So I have included the change
as suggested by him.
}
    if (tbActCell=nil) then
      Exit;
    if not tbActCell.CanSaveEditedData(SaveValue) then
      Exit;
    DoEndEdit(tbActCell, ActiveRow, ActiveCol, Result);
    if not Result then
      Exit;
    Result := true;
    GetWindowRect(tbActCell.EditHandle, R);
    AllowRedraw := false;
    try
      MustFocus := tbEditCellHasFocus(Windows.GetFocus);
      if not MustFocus then
        MustFocus := Focused;
      DoEnteringColumn(ActiveCol);
      DoEnteringRow(ActiveRow);
      { To give the user the possibility to find out whether a value has been saved when
        leaving a cell or not, 'DoGetCellData' is only called when neccessary }
      if SaveValue then
        DoGetCellData(ActiveRow, ActiveCol, Data, cdpForSave)
      else
        Data := nil;

      R.TopLeft := ScreenToClient(R.TopLeft);
      R.BottomRight := ScreenToClient(R.BottomRight);
      InvalidateCellsInRect(R);

      tbActCell.StopEditing(SaveValue, Data);
      tbActCell := nil;
      try
        if SaveValue then
          DoDoneEdit(ActiveRow, ActiveCol);
      finally
        if not (otoAlwaysEditing in Options) then
          InvalidateCell(ActiveRow, ActiveCol);
        tbState := tbState - [otsEditing, otsHiddenEdit] + [otsNormal];
        if MustFocus then
          SetFocus
        else
          tbState := tbState - [otsFocused] + [otsUnfocused];
      end;{try..finally}
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{====================================================================}


{==TOvcTable selection methods=======================================}
procedure TOvcCustomTable.tbDeselectAll(CA : TOvcCellArray);
  begin
    with tbSelList do
      begin
        Iterate(tbDeselectAllIterator, pointer(CA));
        DeselectAll;
      end;
  end;
{--------}
function TOvcCustomTable.tbDeselectAllIterator(RowNum1 : TRowNum; ColNum1 : TColNum;
                                               RowNum2 : TRowNum; ColNum2 : TColNum;
                                               ExtraData : pointer) : boolean;
  var
    RowNum : TRowNum;
    ColNum : TColNum;
    RowInx : integer;
    CA : TOvcCellArray absolute ExtraData;
  begin
    {optimisations: 1. generally ColNum1 = ColNum2
                    2. take it from the viewpoint of what rows are visible
                       rather than what rows are selected}
    Result := true;
    for ColNum := ColNum1 to ColNum2 do
      if (tbFindColInx(ColNum) <> -1) then
        with tbRowNums^ do
          for RowInx := 0 to pred(Count) do
            begin
              RowNum := Ay[RowInx].Number;
              if (RowNum1 <= RowNum) and (RowNum <= RowNum2) then
                CA.AddCell(RowNum, ColNum);
            end;
  end;
{--------}
function TOvcCustomTable.HaveSelection : boolean;
  begin
    Result := tbSelList.HaveSelection;
  end;
{--------}
function TOvcCustomTable.InSelection(RowNum : TRowNum; ColNum : TColNum) : boolean;
  begin
    if HaveSelection then
      Result := tbSelList.IsCellSelected(RowNum, ColNum)
    else
      Result := false;
  end;
{--------}
procedure TOvcCustomTable.IterateSelections(SI : TSelectionIterator; ExtraData : pointer);
  begin
    with tbSelList do
      Iterate(SI, ExtraData);
  end;
{--------}
procedure TOvcCustomTable.tbSelectCol(ColNum : TColNum);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    tbSelList.SelectCellRange(LockedRows, ColNum, pred(RowLimit), ColNum);
    ColInx := tbFindColInx(ColNum);
    if (ColInx <> -1) then
      with tbRowNums^ do
        for RowInx := 0 to pred(Count) do
          tbInvCells.AddCell(Ay[RowInx].Number, ColNum);
  end;
{--------}
procedure TOvcCustomTable.tbSelectRow(RowNum : TRowNum);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    tbSelList.SelectCellRange(RowNum, LockedCols, RowNum, pred(ColCount));
    RowInx := tbFindRowInx(RowNum);
    if (RowInx <> -1) then
      with tbColNums^ do
        for ColInx := 0 to pred(Count) do
          tbInvCells.AddCell(RowNum, Ay[ColInx].Number);
  end;
{--------}
procedure TOvcCustomTable.tbSelectTable;
  begin
    tbSelList.SelectAll;
    InvalidateTable;
  end;
{--------}
procedure TOvcCustomTable.tbSetAnchorCell(RowNum : TRowNum; ColNum : TColNum;
                                          Action : TOvcTblSelectionType);
  begin
    {deselect the current selection(s) if required}
    if (Action = tstDeselectAll) then
      tbDeselectAll(tbInvCells);
    {set the anchor point to a sensible value}
    if (ColNum < LockedCols) then
      FSelAnchorCol := LockedCols
    else if (ColNum >= ColCount) then
      FSelAnchorCol := pred(ColCount)
    else
      FSelAnchorCol := ColNum;
    if (RowNum < LockedRows) then
      FSelAnchorRow := LockedRows
    else if (RowNum >= RowLimit) then
      FSelAnchorRow := pred(RowLimit)
    else
      FSelAnchorRow := RowNum;
    {tell the selection list object}
    tbSelList.SetRangeAnchor(RowNum, ColNum, Action);
    {try and work out whether we are selecting or deselecting}
    tbIsSelecting := false;
    tbIsDeselecting := false;
    if (Action = tstAdditional) then
      begin
        if InSelection(RowNum, ColNum) then
          tbIsDeselecting := true
        else
          tbIsSelecting := true;
      end;
  end;
{--------}
procedure TOvcCustomTable.tbUpdateSelection(RowNum : TRowNum; ColNum : TColNum;
                                            Action : TOvcTblSelectionType);
  var
    R          : TRowNum;
    C          : TColNum;
    OldSelRow1 : TRowNum;
    OldSelRow2 : TRowNum;
    OldSelCol1 : TColNum;
    OldSelCol2 : TColNum;
    NewSelRow1 : TRowNum;
    NewSelRow2 : TRowNum;
    NewSelCol1 : TColNum;
    NewSelCol2 : TColNum;
    RowInx     : integer;
    ColInx     : integer;
    NewInvCells: TOvcCellArray;
    DeselCells : TOvcCellArray;
  begin
    NewInvCells := nil;
    DeselCells := nil;
    try
      {create temporary cell arrays: one for new invalid cells,
       one for any deselected cells}
      NewInvCells := TOvcCellArray.Create;
      DeselCells := TOvcCellArray.Create;
      {deselect currently selected cells if required}
      if (Action = tstDeselectAll) then
        tbDeselectAll(DeselCells);
      {calculate the old and new selections (the parameters RowNum,
       ColNum form the address of the new active cell)}
      OldSelRow1 := MinL(ActiveRow, FSelAnchorRow);
      OldSelRow2 := MaxL(ActiveRow, FSelAnchorRow);
      NewSelRow1 := MinL(RowNum, FSelAnchorRow);
      NewSelRow2 := MaxL(RowNum, FSelAnchorRow);
      if (otoBrowseRow in Options) then
        begin
          OldSelCol1 := LockedCols;
          OldSelCol2 := pred(ColCount);
          NewSelCol1 := LockedCols;
          NewSelCol2 := pred(ColCount);
        end
      else
        begin
          OldSelCol1 := MinI(ActiveCol, FSelAnchorCol);
          OldSelCol2 := MaxI(ActiveCol, FSelAnchorCol);
          NewSelCol1 := MinI(ColNum, FSelAnchorCol);
          NewSelCol2 := MaxI(ColNum, FSelAnchorCol);
        end;
      {extend the range in the selection list}
      tbSelList.ExtendRange(RowNum, ColNum, tbIsSelecting or tbIsKeySelecting);
      {for the old selection, remove the cells from the deselected cell
       array (if they are there) and add them to the new selected cell
       array}
      for RowInx := 0 to pred(tbRowNums^.Count) do
        begin
          R := tbRowNums^.Ay[RowInx].Number;
          if (OldSelRow1 <= R) and (R <= OldSelRow2) then
            for ColInx := 0 to pred(tbColNums^.Count) do
              begin
                C := tbColNums^.Ay[ColInx].Number;
                if (OldSelCol1 <= C) and (C <= OldSelCol2) then
                  begin
                    DeselCells.DeleteCell(R, C);
                    NewInvCells.AddCell(R, C);
                  end;
              end;
          end;
      {for the new selection, for each cell remove it from the new selected
       cell array; if it wasn't there add it to the same array}
      for RowInx := 0 to pred(tbRowNums^.Count) do
        begin
          R := tbRowNums^.Ay[RowInx].Number;
          if (NewSelRow1 <= R) and (R <= NewSelRow2) then
            for ColInx := 0 to pred(tbColNums^.Count) do
              begin
                C := tbColNums^.Ay[ColInx].Number;
                if (NewSelCol1 <= C) and (C <= NewSelCol2) then
                  if not NewInvCells.DeleteCell(R, C) then
                    NewInvCells.AddCell(R, C);
              end;
          end;
      {add the current active cell to the new selected cell array}
      NewInvCells.AddCell(ActiveRow, ActiveCol);
      {merge the cells from the temporary arrays into the main invalid
       cell array}
      tbInvCells.Merge(NewInvCells);
      tbInvCells.Merge(DeselCells);
    finally
      NewInvCells.Free;
      DeselCells.Free
    end;{try..finally}
  end;
{====================================================================}


{==TOvcTable notification methods====================================}
procedure TOvcCustomTable.tbCellChanged(Sender : TObject);
  begin
    {don't bother if we're being loaded or destroyed}
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    {if we have a handle repaint the table}
    if HandleAllocated then
      begin
        AllowRedraw := false;
        try
          InvalidateTable;
        finally
          AllowRedraw := true;
        end;{try..finally}
     end;
  end;
{--------}
procedure TOvcCustomTable.tbColChanged(Sender : TObject; ColNum1, ColNum2 : TColNum;
                                       Action : TOvcTblActions);
  var
    CC   : TColNum;
    DoIt : boolean;
  begin
    {don't bother if we're being loaded or destroyed}
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    {similarly don't bother if we have no handle}
    if not HandleAllocated then begin
      tbSelList.SetColCount(ColCount);
      Exit;
    end;
    {make sure there's no flicker}
    AllowRedraw := false;
    try
      {decide whether there's anything to do to the visible display}
      DoIt := false;
      with tbColNums^ do
        case Action of
          taGeneral : DoIt := true;
          taSingle  : begin
                        DoIt := (Ay[0].Number <= ColNum1) and
                                (ColNum1 <= Ay[pred(Count)].Number);
                        {check for unhiding a column after all others}
                        if not DoIt then
                          DoIt := (ColNum1 > Ay[pred(Count)].Number) and
                                  (ClientWidth > Ay[Count].Offset);
                        DoColumnsChanged(ColNum1, -1, taSingle);
                      end;
          taAll     : DoIt := true;
          taInsert  : begin
                        DoIt := (Ay[0].Number <= ColNum1) and
                                (ColNum1 <= Ay[pred(Count)].Number);
                        {check for appending a column}
                        if not DoIt then
                          DoIt := (ColNum1 > Ay[pred(Count)].Number) and
                                  (ClientWidth > Ay[Count].Offset);
                        FCells.InsertCol(ColNum1);
                        DoColumnsChanged(ColNum1, -1, taInsert);
                      end;
          taDelete  : begin
                        DoIt := (Ay[0].Number <= ColNum1) and
                                (ColNum1 <= Ay[pred(Count)].Number);
                        FCells.DeleteCol(ColNum1);
                        DoColumnsChanged(ColNum1, -1, taDelete);
                      end;
          taExchange: begin
                        DoIt := (Ay[0].Number <= ColNum1) and
                                (ColNum1 <= Ay[pred(Count)].Number);
                        if not DoIt then
                          DoIt := (Ay[0].Number <= ColNum2) and
                                  (ColNum2 <= Ay[pred(Count)].Number);
                        FCells.ExchangeCols(ColNum1, ColNum2);
                        DoColumnsChanged(ColNum1, ColNum2, taExchange);
                      end;
        end;{case}
      {if nothing to do to the visible columns, then do it!}
      if not DoIt then
        begin
          {must still reset the horizontal scroll bar even so}
          tbSelList.SetColCount(ColCount);
          tbSetScrollRange(otsbHorizontal);
          tbSetScrollPos(otsbHorizontal);
          Exit;
        end;
      {redisplay the table}
      tbCalcColData(tbColNums, LeftCol);
      InvalidateTable;
      {the column could have changed because it was hidden or deleted...
       ...must make sure that LeftCol and ActiveCol haven't
          been hidden as well.}
      if (Action = taSingle) or (Action = taDelete) then
        begin
          if (ColNum1 = LeftCol) then
            LeftCol := LeftCol; {this does do something!}
          if (ColNum1 = ActiveCol) then
            ActiveCol := ActiveCol; {this does do something!}
        end;
      {reset the block column values}
      CC := ColCount;
      if (CC <= BlockColBegin) then
        BlockColBegin := pred(CC);
      if (CC <= BlockColEnd) then
        BlockColEnd := pred(CC);
      tbSelList.SetColCount(ColCount);
      tbSetScrollRange(otsbHorizontal);
      tbSetScrollPos(otsbHorizontal);
      if (LeftCol > tbLastLeftCol) then
        LeftCol := tbLastLeftCol;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbColorsChanged(Sender : TObject);
  begin
    {don't bother if we're being loaded or destroyed}
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    {if we have a handle repaint the table}
    if HandleAllocated then
      begin
        AllowRedraw := false;
        try
          InvalidateTable;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.tbGridPenChanged(Sender : TObject);
  begin
    {don't bother if we're being loaded or destroyed}
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    {if we have a handle repaint the table}
    if HandleAllocated then
      begin
        AllowRedraw := false;
        try
          InvalidateTable;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.tbRowChanged(Sender : TObject; RowNum1, RowNum2 : TRowNum;
                                       Action : TOvcTblActions);
  var
    RL   : TRowNum;
    DoIt : boolean;
  begin
    {don't bother if we're being loaded or destroyed}
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    {similarly don't bother if we have no handle}
    if not HandleAllocated then begin
      tbSelList.SetRowCount(RowLimit);
      Exit;
    end;
    {make sure there's no flicker}
    AllowRedraw := false;
    try
      {decide whether there's anything to do to the visible display}
      DoIt := false;
      with tbRowNums^ do
        case Action of
          taGeneral : DoIt := true;
          taSingle  : begin
                        DoIt := (Ay[0].Number <= RowNum1) and
                                (RowNum1 <= Ay[pred(Count)].Number);
                        {check for unhiding a row after all others}
                        if not DoIt then
                          DoIt := (RowNum1 > Ay[pred(Count)].Number) and
                                  (ClientHeight > Ay[Count].Offset);
                        DoRowsChanged(RowNum1, -1, taSingle);
                      end;
          taAll     : DoIt := true;
          taInsert  : begin
                        DoIt := (Ay[0].Number <= RowNum1) and
                                (RowNum1 <= Ay[pred(Count)].Number);
                        {check for appending a row}
                        if not DoIt then
                          DoIt := (RowNum1 > Ay[pred(Count)].Number) and
                                  (ClientHeight > Ay[Count].Offset);
                        FCells.InsertRow(RowNum1);
                        DoRowsChanged(RowNum1, -1, taInsert);
                      end;
          taDelete  : begin
                        DoIt := (Ay[0].Number <= RowNum1) and
                                (RowNum1 <= Ay[pred(Count)].Number);
                        FCells.DeleteRow(RowNum1);
                        DoRowsChanged(RowNum1, -1, taDelete);
                      end;
          taExchange: begin
                        DoIt := (Ay[0].Number <= RowNum1) and
                                (RowNum1 <= Ay[pred(Count)].Number);
                        if not DoIt then
                          DoIt := (Ay[0].Number <= RowNum2) and
                                  (RowNum2 <= Ay[pred(Count)].Number);
                        FCells.ExchangeRows(RowNum1, RowNum2);
                        DoRowsChanged(RowNum1, RowNum2, taExchange);
                      end;
        end;{case}
      {if nothing to do to the visible rows, then do it!}
      if not DoIt then
        begin
          {must still reset the vertical scroll bar even so}
          tbSelList.SetRowCount(RowLimit);
          tbSetScrollRange(otsbVertical);
          tbSetScrollPos(otsbVertical);
          Exit;
        end;
      {redisplay the table}
      tbCalcRowData(tbRowNums, TopRow);
      InvalidateTable;
      {the row could have changed because it was hidden or deleted...
       ...must make sure that TopRow and ActiveRow haven't
          been hidden as well.}
      if (Action = taSingle) or (Action = taDelete) then
        begin
          if (RowNum1 = TopRow) then
            TopRow := TopRow; {this does do something!}
          if (RowNum1 = ActiveRow) then
            ActiveRow := ActiveRow; {this does do something!}
        end;
      {reset the block row values}
      RL := RowLimit;
      if (RL <= BlockRowBegin) then
        BlockRowBegin := pred(RL);
      if (RL <= BlockRowEnd) then
        BlockRowEnd := pred(RL);
      tbSelList.SetRowCount(RowLimit);
      tbSetScrollRange(otsbVertical);
      tbSetScrollPos(otsbVertical);
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{====================================================================}


{==TOvcTable invalidate cell methods=================================}
procedure TOvcCustomTable.InvalidateCell(RowNum : TRowNum; ColNum : TColNum);
  var
    CInx : integer;
    RInx : integer;
  begin
    RInx := tbFindRowInx(RowNum);
    if (RInx <> -1) then
      begin
        CInx := tbFindColInx(ColNum);
        if (CInx <> -1) then
          tbInvCells.AddCell(RowNum, ColNum);
      end;
  end;
{--------}
procedure TOvcCustomTable.InvalidateCellsInRect(const R : TRect);
  var
    GR          : TRect;
    WhatToPaint : integer;
    RowInx      : integer;
    ColInx      : integer;
  begin
    WhatToPaint := tbCalcCellsFromRect(R, GR);

    if (WhatToPaint <> 2) then
      for RowInx := GR.Top to GR.Bottom do
        for ColInx := GR.Left to GR.Right do
          InvalidateCell(tbRowNums^.Ay[RowInx].Number, tbColNums^.Ay[ColInx].Number);

    if (WhatToPaint <> 0) then
      tbInvCells.AddUnusedBit;
  end;
{--------}
procedure TOvcCustomTable.InvalidateColumn(ColNum : TColNum);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    ColInx := tbFindColInx(ColNum);
    if (ColInx <> -1) then
      with tbRowNums^ do
        for RowInx := 0 to pred(Count) do
          tbInvCells.AddCell(Ay[RowInx].Number, ColNum);
  end;
{--------}
procedure TOvcCustomTable.tbInvalidateColHdgPrim(ColNum : TColNum; InvCells : TOvcCellArray);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    ColInx := tbFindColInx(ColNum);
    if (ColInx <> -1) then
      with tbRowNums^ do
        for RowInx := 0 to pred(LockedRows) do
          InvCells.AddCell(Ay[RowInx].Number, ColNum);
  end;
{--------}
procedure TOvcCustomTable.InvalidateColumnHeading(ColNum : TColNum);
  begin
    tbInvalidateColHdgPrim(ColNum, tbInvCells);
  end;
{--------}
procedure TOvcCustomTable.InvalidateRow(RowNum : TRowNum);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    RowInx := tbFindRowInx(RowNum);
    if (RowInx <> -1) then
      with tbColNums^ do
        for ColInx := 0 to pred(Count) do
          tbInvCells.AddCell(RowNum, Ay[ColInx].Number);
  end;
{--------}
procedure TOvcCustomTable.tbInvalidateRowHdgPrim(RowNum : TRowNum; InvCells : TOvcCellArray);
  var
    RowInx : integer;
    ColInx : integer;
  begin
    RowInx := tbFindRowInx(RowNum);
    if (RowInx <> -1) then
      with tbColNums^ do
        for ColInx := 0 to pred(LockedCols) do
          InvCells.AddCell(RowNum, Ay[ColInx].Number);
  end;
{--------}
procedure TOvcCustomTable.InvalidateRowHeading(RowNum : TRowNum);
  begin
    tbInvalidateRowHdgPrim(RowNum, tbInvCells);
  end;
{--------}
procedure TOvcCustomTable.InvalidateTable;
  var
    RowInx : integer;
    ColInx : integer;
    PredColNumsCount : integer;
    PredRowNumsCount : integer;
  begin
    PredColNumsCount := pred(tbColNums^.Count);
    PredRowNumsCount := pred(tbRowNums^.Count);
    for RowInx := 0 to PredRowNumsCount do
      for ColInx := 0 to PredColNumsCount do
        tbInvCells.AddCell(tbRowNums^.Ay[RowInx].Number,
                             tbColNums^.Ay[ColInx].Number);
    tbInvCells.AddUnusedBit;
  end;
{--------}
procedure TOvcCustomTable.InvalidateTableNotLockedCols;
  var
    RowInx      : integer;
    ColInx      : integer;
    StartColInx : integer;
    PredColNumsCount : integer;
    PredRowNumsCount : integer;
  begin
    StartColInx := 0;
    PredColNumsCount := pred(tbColNums^.Count);
    PredRowNumsCount := pred(tbRowNums^.Count);
    while (StartColInx <= PredColNumsCount) and
          (tbColNums^.Ay[StartColInx].Number < LockedCols) do
      inc(StartColInx);
    for RowInx := 0 to PredRowNumsCount do
      for ColInx := StartColInx to PredColNumsCount do
        tbInvCells.AddCell(tbRowNums^.Ay[RowInx].Number,
                             tbColNums^.Ay[ColInx].Number);
    tbInvCells.AddUnusedBit;
  end;
{--------}
procedure TOvcCustomTable.InvalidateTableNotLockedRows;
  var
    RowInx      : integer;
    ColInx      : integer;
    StartRowInx : integer;
    PredColNumsCount : integer;
    PredRowNumsCount : integer;
  begin
    StartRowInx := 0;
    PredColNumsCount := pred(tbColNums^.Count);
    PredRowNumsCount := pred(tbRowNums^.Count);
    while (StartRowInx <= PredRowNumsCount) and
          (tbRowNums^.Ay[StartRowInx].Number < LockedRows) do
      inc(StartRowInx);
    for RowInx := StartRowInx to PredRowNumsCount do
      for ColInx := 0 to PredColNumsCount do
        tbInvCells.AddCell(tbRowNums^.Ay[RowInx].Number,
                             tbColNums^.Ay[ColInx].Number);
    tbInvCells.AddUnusedBit;
  end;
{====================================================================}


{==TOvcTable miscellaneous===========================================}
function  TOvcCustomTable.tbCalcActiveCellRect(var ACR : TRect) : boolean;
  var
    RInx : integer;
    CInx : integer;
  begin
    Result := false;
    RInx := tbFindRowInx(ActiveRow);
    if (RInx = -1) then
      Exit;
    CInx := tbFindColInx(ActiveCol);
    if (CInx = -1) then
      Exit;

    Result := true;
    with ACR do
      begin
        Top := tbRowNums^.Ay[RInx].Offset;
        Bottom := tbRowNums^.Ay[succ(RInx)].Offset;
        Left := tbColNums^.Ay[CInx].Offset;
        Right := tbColNums^.Ay[succ(CInx)].Offset;
      end;
    with GridPenSet.NormalGrid do
      case Effect of
        geVertical   : dec(ACR.Right);
        geHorizontal : dec(ACR.Bottom);
        geBoth       : begin
                         dec(ACR.Right);
                         dec(ACR.Bottom);
                       end;
        ge3D         : InflateRect(ACR, -1, -1);
      end;{case}
  end;
{--------}
function TOvcCustomTable.tbCalcCellsFromRect(const UR : TRect; var GR : TRect) : integer;
  {-Converts a paint rect into a 'grid' rect. A grid rect is a rectangle of
    cells, defined by their display indexes rather than their row/column
    numbers.
    The function result is a definition of the type of rectangle produced:
      0--top left and bottom right corners of the original rect are
         exclusively within the table;
      1--top left of the rect is in the displayed table, the bottom right is
         in the 'unused' bit (the bit between the displayed cells and the
         client area;
      2--the original rectangle is exclusively in the 'unused bit'.
    }
  var
    Row : TRowNum;
    Col : TColNum;
    Region : TOvcTblRegion;
  begin
    Result := 0;
    Region := CalcRowColFromXY(UR.Left, UR.Top, Row, Col);
    if (Region = otrInUnused) then
      begin
        Result := 2;
        FillChar(GR, sizeof(GR), $FF); {set 'em all to -1}
        Exit;
      end;
    GR.Left := tbFindColInx(Col);
    GR.Top := tbFindRowInx(Row);
    Region := CalcRowColFromXY(UR.Right, UR.Bottom, Row, Col);
    if (Region = otrInUnused) or (Region = otrOutside) then
      Result := 1;
    if (Col = CRCFXY_ColToRight) then
      GR.Right := pred(tbColNums^.Count)
    else
      GR.Right := tbFindColInx(Col);
    if (Row = CRCFXY_RowBelow) then
      GR.Bottom := pred(tbRowNums^.Count)
    else
      GR.Bottom := tbFindRowInx(Row);
  end;
{--------}
procedure TOvcCustomTable.tbCalcColData(var CD : POvcTblDisplayArray;
                                            NewLeftCol : TColNum);
  var
    X      : integer;
    Width  : integer;
    Access : TOvcTblAccess;
    Hidden : boolean;
    ColNum : TColNum;
    FullWidth    : integer;
    PredColCount : TColNum;
    PredLocked   : TColNum;
  begin
    {initialise}
    X := 0;
    ColNum := -1;
    CD^.Count := 0;
    FullWidth := ClientWidth;              {save expense of function call in loop}
    PredColCount := pred(ColCount);        {save expense of function call in loop}
    PredLocked := pred(LockedCols);        {save expense of function call in loop}

    {deal with the locked columns first}
    if (LockedCols <> 0) then
      while (X < FullWidth) and (ColNum < PredLocked) do
        begin
          inc(ColNum);
          tbQueryColData(ColNum, Width, Access, Hidden);
          if not Hidden then
            begin
              with CD^ do
                begin
                  with Ay[Count] do
                    begin
                      Number := ColNum;
                      Offset := X;
                    end;
                  inc(Count);
                  if (Count >= AllocNm) then
                    AssignDisplayArray(CD, AllocNm+16);
                end;
              inc(X, Width);
            end;
        end;

    {now deal with the rightmost columns}
    ColNum := pred(NewLeftCol);
    while (X < FullWidth) and (ColNum < PredColCount) do
      begin
        inc(ColNum);
        tbQueryColData(ColNum, Width, Access, Hidden);
        if not Hidden then
          begin
            with CD^ do
              begin
                with Ay[Count] do
                  begin
                    Number := ColNum;
                    Offset := X;
                  end;
                inc(Count);
                if (Count >= AllocNm) then
                  AssignDisplayArray(CD, AllocNm+16);
              end;
            inc(X, Width);
          end;
      end;

    {use the next spare element for storing the offset for the grid}
    with CD^ do
      Ay[Count].Offset := X;
  end;
{--------}
function TOvcCustomTable.CalcRowColFromXY(X, Y : integer;
                                      var RowNum : TRowNum;
                                      var ColNum : TColNum) : TOvcTblRegion;
  var
    ColInx : integer;
    RowInx : integer;
    CW     : integer;
    CH     : integer;
    TW     : integer;
    TH     : integer;
  begin
    RowNum := CRCFXY_RowBelow;
    ColNum := CRCFXY_ColToRight;
    CW := ClientWidth;
    CH := ClientHeight;

    {calculate the table width and height}
    with tbColNums^ do
      TW := MinI(CW, Ay[Count].Offset);
    with tbRowNums^ do
      TH := MinI(CH, Ay[Count].Offset);

    {make a first pass at calculating the region}
    if (X < 0) or (Y < 0) or (X >= CW) or (Y >= CH) then
      Result := otrOutside {definitely}
    else
      Result := otrInMain; {possibly, could also be one of the other two}

    {calculate row first}
    with tbRowNums^ do
      if (0 <= Y) and (Y < TH) then
        begin
          RowInx := 0;
          while (Ay[RowInx].Offset <= Y) do
            inc(RowInx);
          RowNum := Ay[pred(RowInx)].Number;
        end;

    {now calculate column}
    with tbColNums^ do
      if (0 <= X) and (X < TW) then
        begin
          ColInx := 0;
          while (Ay[ColInx].Offset <= X) do
            inc(ColInx);
          ColNum := Ay[pred(ColInx)].Number;
        end;

     {now patch up the region}
     if (Result = otrInMain) then
       if (RowNum = CRCFXY_RowBelow) or (ColNum = CRCFXY_ColToRight) then
         Result := otrInUnused
       else if (RowNum < LockedRows) or (ColNum < LockedCols) then
         Result := otrInLocked;

     {now patch up the row and column numbers}
     if (Result = otrOutside) or (Result = otrInUnused) then
       begin
         if (RowNum = CRCFXY_RowBelow) and (Y < 0) then
           RowNum := CRCFXY_RowAbove;
         if (ColNum = CRCFXY_ColToRight) and (X < 0) then
           ColNum := CRCFXY_ColToLeft;
       end;
  end;
{--------}
{$IFDEF SuppressWarnings}
{$Warnings OFF}
{$ENDIF}
procedure TOvcCustomTable.tbCalcColsOnLastPage;
  var
    CD         : POvcTblDisplayArray;
    OldLeftCol : TColNum;
    NewLeftCol : TColNum;
    StillGoing : boolean;
  begin
    OldLeftCol := 0;
    if (ColCount <= LockedCols) then
      begin
        tbColsOnLastPage := 0;
        Exit;
      end;

    CD := nil;
    AssignDisplayArray(CD, tbColNums^.AllocNm);

    try
      NewLeftCol := IncCol(pred(ColCount), 0);
      tbCalcColData(CD, NewLeftCol);
      if (CD^.Ay[CD^.Count].Offset > ClientWidth) then
        begin
          tbLastLeftCol := NewLeftCol;
          tbColsOnLastPage := 1;
          Exit;
        end;

      StillGoing := true;
      while StillGoing do
        begin
          OldLeftCol := NewLeftCol;
          NewLeftCol := IncCol(NewLeftCol, -1);
          if (NewLeftCol = OldLeftCol) then
            StillGoing := false
          else
            begin
              tbCalcColData(CD, NewLeftCol);
              StillGoing := (CD^.Ay[CD^.Count].Offset < ClientWidth);
            end;
        end;
      tbColsOnLastPage := ColCount - NewLeftCol;
      tbLastLeftCol := OldLeftCol;
      if tbLastLeftCol < LeftCol then
        LeftCol := tbLastLeftCol;
    finally
      AssignDisplayArray(CD, 0);
    end;{try..finally}
  end;
{$IFDEF SuppressWarnings}
{$Warnings ON}
{$ENDIF}
{--------}
procedure TOvcCustomTable.tbCalcRowData(var RD : POvcTblDisplayArray;
                                            NewTopRow : TRowNum);
  var
    Y      : integer;
    Height : integer;
    Hidden : boolean;
    RowNum : TRowNum;
    FullHeight   : integer;
    PredRowLimit : TRowNum;
    PredLocked   : TRowNum;
  begin
    {initialise}
    Y := 0;
    RowNum := -1;
    RD^.Count := 0;
    FullHeight := ClientHeight;            {save expense of function call in loop}
    PredRowLimit := pred(RowLimit);        {save expense of function call in loop}
    PredLocked := pred(LockedRows);        {save expense of function call in loop}

    {deal with the locked rows first}
    if (LockedRows <> 0) then
      while (Y < FullHeight) and (RowNum < PredLocked) do
        begin
          inc(RowNum);
          tbQueryRowData(RowNum, Height, Hidden);
          if not Hidden then
            begin
              with RD^ do
                begin
                  with Ay[Count] do
                    begin
                      Number := RowNum;
                      Offset := Y;
                    end;
                  inc(Count);
                  if (Count >= AllocNm) then
                    AssignDisplayArray(RD, AllocNm+16);
                end;
              inc(Y, Height);
            end;
        end;

    {now deal with the rows underneath the fixed rows}
    RowNum := pred(NewTopRow);
    while (Y < FullHeight) and (RowNum < PredRowLimit) do
      begin
        inc(RowNum);
        tbQueryRowData(RowNum, Height, Hidden);
        if not Hidden then
          begin
            with RD^ do
              begin
                with Ay[Count] do
                  begin
                    Number := RowNum;
                    Offset := Y;
                  end;
                inc(Count);
                if (Count >= AllocNm) then
                  AssignDisplayArray(RD, AllocNm+16);
              end;
            inc(Y, Height);
          end;
      end;

    {use the next spare element for storing the offset for the grid}
    with RD^ do
      Ay[Count].Offset := Y;
  end;
{--------}
{$IFDEF SuppressWarnings}
{$Warnings OFF}
{$ENDIF}
procedure TOvcCustomTable.tbCalcRowsOnLastPage;
  var
    RD         : POvcTblDisplayArray;
    OldTopRow  : TRowNum;
    NewTopRow  : TRowNum;
    StillGoing : boolean;
  begin
    OldTopRow := 0;
    if (RowLimit <= LockedRows) then
      begin
        tbRowsOnLastPage := 0;
        Exit;
      end;

    RD := nil;
    AssignDisplayArray(RD, tbRowNums^.AllocNm);

    try
      NewTopRow := IncRow(pred(RowLimit), 0);
      tbCalcRowData(RD, NewTopRow);
      if (RD^.Ay[RD^.Count].Offset >= ClientHeight) then
        begin
          tbLastTopRow := NewTopRow;
          tbRowsOnLastPage := 1;
          Exit;
        end;

      StillGoing := true;
      while StillGoing do
        begin
          OldTopRow := NewTopRow;
          NewTopRow := IncRow(OldTopRow, -1);
          if (NewTopRow = OldTopRow) then
            StillGoing := false
          else
            begin
              tbCalcRowData(RD, NewTopRow);
              StillGoing := (RD^.Ay[RD^.Count].Offset < ClientHeight);
            end;
        end;
      tbRowsOnLastPage := RowLimit - OldTopRow;
      tbLastTopRow := OldTopRow;
      if tbLastTopRow < TopRow then
        TopRow := tbLastTopRow;
    finally
      AssignDisplayArray(RD, 0);
    end;{try..finally}
  end;
{$IFDEF SuppressWarnings}
{$Warnings ON}
{$ENDIF}
{--------}
procedure TOvcCustomTable.tbCalcHSBarPosCount;
  var
    Col : TColNum;
  begin
    tbHSBarPosCount := 0;
    for Col := LockedCols to tbLastLeftCol do
      if not tbIsColHidden(Col) then
        inc(tbHSBarPosCount);
  end;
{--------}
function TOvcCustomTable.tbCalcRequiresVSBar : boolean;
  var
    Row : TRowNum;
  begin
    {a fast check for possible hidden rows: if there are none and the
     last page's top row is not equal to the number of locked rows
     then obviously a vertical scrollbar is required.}
    if (LockedRows < tbLastTopRow) and
       (Rows.Count = 0) then
      begin
        Result := true;
        Exit;
      end;
    {otherwise check to see whether all rows between the locked rows
     and the last page's top row are hidden: if so no vertical scroll
     bar is required.}
    Result := false;
    for Row := LockedRows to pred(tbLastTopRow) do
      if not Rows.Hidden[Row] then
        begin
          Result := true;
          Exit;
        end;
  end;
{--------}
procedure TOvcCustomTable.ChangeScale(M, D : integer);
  var
    i : TColNum;
  begin
    inherited ChangeScale(M, D);
    if (M <> D) then
      begin
        Rows.rwScaleHeights(M, D);
        for i := 0 to pred(ColCount) do
          with Columns[i] do
            Width := MulDiv(Width, M, D);
      end;
  end;
{--------}

{ - HWnd changed to TOvcHWnd for BCB Compatibility }
function  TOvcCustomTable.tbEditCellHasFocus(
  FocusHandle : TOvcHWnd{HWND}) : boolean;
  var
    ChildHandle : HWND;
  begin
    Result := false;
    if not InEditingState then
      Exit;
    if (tbActCell.EditHandle = 0) then
      Exit;
    Result := true;
    if (FocusHandle = tbActCell.EditHandle) then
      Exit;
    ChildHandle := GetWindow(tbActCell.EditHandle, GW_CHILD);
    while (ChildHandle <> 0) do
      begin
        if (FocusHandle = ChildHandle) then
          Exit;
        ChildHandle := GetWindow(ChildHandle, GW_CHILD);
      end;
    Result := false;
  end;
{--------}
procedure TOvcCustomTable.tbEnsureColumnIsVisible(ColNum : TColNum);
  var
    ColInx : integer;
    CW     : integer;
    FarRight : integer;
    LeftInx  : integer;
    LColOfs  : integer;
    LColWd   : integer;
  begin
    {get the index for the column}
    ColInx := tbFindColInx(ColNum);
    if (ColInx = -1) then
      begin
        {the column is not even visible}
        {make this column the left column}
        LeftCol := ColNum;
      end
    else
      begin
        CW := ClientWidth;
        with tbColNums^ do
          FarRight := Ay[succ(ColInx)].Offset;
        if (FarRight > CW) then
          begin
            {the column is partially visible}

            {pretend that we're scrolling the table left
             column by column, until either
               (1) the column we want is fully visible, or
               (2) the column we want is the leftmost column
             then set the leftmost column}
            LeftInx := tbFindColInx(LeftCol);
            LColOfs := tbColNums^.Ay[LeftInx].Offset;
            LColWd := tbColNums^.Ay[succ(LeftInx)].Offset - LColOfs;
            dec(FarRight, LColWd);
            inc(LColOfs, LColWd);
            inc(LeftInx);
            while (LeftInx < ColInx) and (FarRight > CW) do
              begin
                LColWd := tbColNums^.Ay[succ(LeftInx)].Offset - LColOfs;
                dec(FarRight, LColWd);
                inc(LColOfs, LColWd);
                inc(LeftInx);
              end;
            if (LeftInx < tbColNums^.Count) then
              LeftCol := tbColNums^.Ay[LeftInx].Number;
          end;
      end;
  end;
{--------}
procedure TOvcCustomTable.tbEnsureRowIsVisible(RowNum : TRowNum);
  var
    RowInx : integer;
    CH     : integer;
    FarBottom: integer;
    TopInx   : integer;
    TpRowOfs : integer;
    TpRowHt  : integer;
  begin
    RowInx := tbFindRowInx(RowNum);
    if (RowInx = -1) then
      begin
        {the row is not even visible}
        {make this row the top row}
        TopRow := RowNum;
      end
    else
      begin
        CH := ClientHeight;
        with tbRowNums^ do
          FarBottom := Ay[succ(RowInx)].Offset;
        if (FarBottom > CH) then
          begin
            {the row is partially visible}

            {pretend that we're scrolling the table up
             row by row, until either
               (1) the row we want is fully visible, or
               (2) the row we want is the topmost row
             then set the topmost row}
            TopInx := tbFindRowInx(TopRow);
            TpRowOfs := tbRowNums^.Ay[TopInx].Offset;
            TpRowHt := tbRowNums^.Ay[succ(TopInx)].Offset - TpRowOfs;
            dec(FarBottom, TpRowHt);
            inc(TpRowOfs, TpRowHt);
            inc(TopInx);
            while (TopInx < RowInx) and (FarBottom > CH) do
              begin
                TpRowHt := tbRowNums^.Ay[succ(TopInx)].Offset - TpRowOfs;
                dec(FarBottom, TpRowHt);
                inc(TpRowOfs, TpRowHt);
                inc(TopInx);
              end;
            if (TopInx < tbRowNums^.Count) then
              TopRow := tbRowNums^.Ay[TopInx].Number;
          end;
      end;
  end;
{--------}
function TOvcCustomTable.tbFindCell(RowNum : TRowNum;
                                    ColNum : TColNum) : TOvcBaseTableCell;
  begin
    Result := FCells[RowNum, ColNum];
    if not Assigned(Result) then
      if (RowNum < LockedRows) then
        Result := FLockedRowsCell
      else
        Result := FCols[ColNum].DefaultCell;
  end;
{--------}
function  TOvcCustomTable.tbFindColInx(ColNum : TColNum) : integer;
  var
    L, M, R   : integer;
    CurNumber : TColNum;
  begin
    Result := -1;
    with tbColNums^ do
      begin
        if (Count = 0) then
          Exit;
        L := 0;
        R := pred(Count);
        repeat
          M := (L + R) div 2;
          CurNumber := Ay[M].Number;
          if (ColNum = CurNumber) then
            begin
              Result := M;
              Exit;
            end
          else if (ColNum < CurNumber) then
            R := pred(M)
          else
            L := succ(M);
        until (L > R);
      end;
  end;
{--------}
function TOvcCustomTable.tbFindRowInx(RowNum : TRowNum) : integer;
  var
    L, M, R   : integer;
    CurNumber : TRowNum;
  begin
    Result := -1;
    with tbRowNums^ do
      begin
        if (Count = 0) then
          Exit;
        L := 0;
        R := pred(Count);
        repeat
          M := (L + R) div 2;
          CurNumber := Ay[M].Number;
          if (RowNum = CurNumber) then
            begin
              Result := M;
              Exit;
            end
          else if (RowNum < CurNumber) then
            R := pred(M)
          else
            L := succ(M);
        until (L > R);
      end;
  end;
{--------}
procedure TOvcCustomTable.GetDisplayedColNums(var NA : TOvcTableNumberArray);
  var
    i : integer;
    WorkCount : integer;
  begin
    WorkCount := MinL(NA.NumElements, tbColNums^.Count);
    for i := 0 to pred(WorkCount) do
      NA.Number[i] := tbColNums^.Ay[i].Number;
    NA.Count := tbColNums^.Count
  end;
{--------}
procedure TOvcCustomTable.GetDisplayedRowNums(var NA : TOvcTableNumberArray);
  var
    i : integer;
    WorkCount : integer;
  begin
    WorkCount := MinL(NA.NumElements, tbRowNums^.Count);
    for i := 0 to pred(WorkCount) do
      NA.Number[i] := tbRowNums^.Ay[i].Number;
    NA.Count := tbRowNums^.Count
  end;
{--------}
function TOvcCustomTable.IncCol(ColNum : TColNum; Direction : integer) : TColNum;
  {-Return a valid unhidden column number. If Direction is:
      -ve : start at C and find the previous unhidden column number, if there
            is none previous to this one, return C.
      +ve : start at R and find the next unhidden column number, if there is
            none after this one, return C
        0 : verify that C is unhidden, if not find the next unhidden column
            number, if none after this one, find the previous one. If still
            none, return C.}
  var
    CL, CC : TColNum;
  begin
    {save the values of properties in local variables}
    CL := LockedCols;
    CC := ColCount;
    {adjust ColNum to be in range}
    if (ColNum < CL) or (ColNum >= CC) then
      ColNum := CL;
    {first direction=0, ie to see whether the column is visible}
    Result := ColNum;
    if (Direction = 0) then {check not hidden}
      if not tbIsColHidden(Result) then
        Exit;
    {now direction>=0, ie to increment the column number}
    if (Direction >= 0) then {go forwards}
      begin
        inc(Result);
        while Result < CC do
          begin
            if not tbIsColHidden(Result) then
              Exit;
            inc(Result);
          end;
        Result := ColNum;
      end;
    {now direction<=0, ie to decrement the column number}
    if (Direction <= 0) then {go backwards}
      begin
        dec(Result);
        while (Result >= CL) do
          begin
            if not tbIsColHidden(Result) then
              Exit;
            dec(Result);
          end;
        Result := ColNum;
      end;
  end;
{--------}
function TOvcCustomTable.IncRow(RowNum : TRowNum; Direction : integer) : TRowNum;
  {-Return a valid unhidden row number. If Direction is:
      -ve : start at R and find the previous unhidden row number, if there
            is none previous to this one, return R.
      +ve : start at R and find the next unhidden row number, if there is
            none after this one, return R
        0 : verify that R is unhidden, if not find the next unhidden row
            number, if none after this one, find the previous one. If still
            none, return R.}
  var
    RL, RC : TRowNum;
  begin
    {save the values of properties in local variables}
    RL := LockedRows;
    RC := RowLimit;
    {adjust RowNum to be in range}
    if (RowNum < RL) or (RowNum >= RC) then
      RowNum := RL;
    {first direction=0, ie to see whether the column is visible}
    Result := RowNum;
    if (Direction = 0) then {check not hidden}
      if not tbIsRowHidden(Result) then
        Exit;
    {now direction>=0, ie to increment the column number}
    if (Direction >= 0) then {go forwards}
      begin
        inc(Result);
        while (Result < RC) do
          begin
            if not tbIsRowHidden(Result) then
              Exit;
            inc(Result);
          end;
        Result := RowNum;
      end;
    {now direction<=0, ie to decrement the column number}
    if (Direction <= 0) then {go backwards}
      begin
        dec(Result);
        while (Result >= RL) do
          begin
            if not tbIsRowHidden(Result) then
              Exit;
            dec(Result);
          end;
        Result := RowNum;
      end;
  end;
{--------}
function TOvcCustomTable.InEditingState : boolean;
  begin
    Result := (tbState * [otsEditing, otsHiddenEdit]) <> [];
  end;
{--------}
function TOvcCustomTable.tbIsColHidden(ColNum : TColNum) : boolean;
  begin
    if (ColNum < 0) or (ColNum >= FCols.Count) then
      Result := True
    else
      Result := FCols[ColNum].Hidden;
  end;
{--------}
function TOvcCustomTable.tbIsColShowRightLine(ColNum : TColNum) : boolean; //CDE
	begin
//	  if (ColNum < 0) or (ColNum >= FCols.Count) then
//		 Result := True
//	  else
		 Result := FCols[ColNum].ShowRightLine;
	end;
{--------}
function TOvcCustomTable.tbIsOnGridLine(MouseX, MouseY : integer;
                                    var VerticalGrid : boolean) : boolean;
  var
    GridLine : integer;
    Inx      : integer;
    LockedColsOffset : integer;
    LockedRowsOffset : integer;
  begin
    Result := false;
    {calc the offsets of the column and row}
    LockedColsOffset := -1;
    Inx := 0;
    with tbColNums^ do
      while (Inx < Count) do
        begin
          if (Ay[Inx].Number >= LockedCols) then
            Break;
          inc(Inx);
          LockedColsOffset := Ay[Inx].Offset;
        end;
    LockedRowsOffset := -1;
    Inx := 0;
    with tbRowNums^ do
      while (Inx < Count) do
        begin
          if (Ay[Inx].Number >= LockedRows) then
            Break;
          inc(Inx);
          LockedRowsOffset := Ay[Inx].Offset;
        end;
    {do the obvious test: cursor is not within the locked area}
    if (MouseX >= LockedColsOffset) and (MouseY >= LockedRowsOffset) then
      Exit;
    {check rows first}
    if (MouseX < LockedColsOffset) then
      begin
        Inx := 0;
        with tbRowNums^ do
          while (Inx < Count) do
            begin
              inc(Inx);
              GridLine := Ay[Inx].Offset;
              if (GridLine-2 <= MouseY) and (MouseY <= GridLine+2) then
                begin
                  VerticalGrid := false;
                  Result := true;
                  tbSizeIndex := pred(Inx);
                  Exit;
                end;
            end;
      end;
    {check columns next}
    if (MouseY < LockedRowsOffset) then
      begin
        Inx := 0;
        with tbColNums^ do
          while (Inx < Count) do
            begin
              inc(Inx);
              GridLine := Ay[Inx].Offset;
              if (GridLine-2 <= MouseX) and (MouseX <= GridLine+2) then
                begin
                  VerticalGrid := true;
                  Result := true;
                  tbSizeIndex := pred(Inx);
                  Exit;
                end;
            end;
      end;
  end;
{--------}
function TOvcCustomTable.tbIsInMoveArea(MouseX, MouseY : integer;
                                    var IsColMove : boolean) : boolean;
  var
    Inx              : integer;
    LockedColsOffset : integer;
    LockedRowsOffset : integer;
  begin
    Result := false;
    IsColMove := false;
    {calc the offsets of the column and row}
    LockedColsOffset := -1;
    Inx := 0;
    with tbColNums^ do
      while (Inx < Count) do
        begin
          if (Ay[Inx].Number >= LockedCols) then
            Break;
          inc(Inx);
          LockedColsOffset := Ay[Inx].Offset;
        end;
    LockedRowsOffset := -1;
    Inx := 0;
    with tbRowNums^ do
      while (Inx < Count) do
        begin
          if (Ay[Inx].Number >= LockedRows) then
            Break;
          inc(Inx);
          LockedRowsOffset := Ay[Inx].Offset;
        end;
    {do the obvious test: cursor is not within the locked area}
    if (MouseX >= LockedColsOffset) and (MouseY >= LockedRowsOffset) then
      Exit;
    {the cursor is within the column move area if it's in a locked cell
     above the main area of the table; otherwise the cursor is within the
     row move area if it's in a locked cell to the left of the main area
     of the table}
    Result := (MouseX >= LockedColsOffset) and (MouseY < LockedRowsOffset) and
              (MouseX < tbColNums^.Ay[tbColNums^.Count].Offset);
    if Result then
      IsColMove := true
    else
      Result := (MouseX < LockedColsOffset) and (MouseY >= LockedRowsOffset) and
                (MouseY < tbRowNums^.Ay[tbRowNums^.Count].Offset);
  end;
{--------}
function TOvcCustomTable.tbIsRowHidden(RowNum : TRowNum) : boolean;
  begin
    Result := Rows[RowNum].Hidden;
  end;
{--------}
procedure TOvcCustomTable.Notification(AComponent: TComponent; Operation: TOperation);
  begin
    inherited Notification(AComponent, Operation);
    if (AComponent is TOvcBaseTableCell) and (Operation = opRemove) then
      begin
        AllowRedraw := false;
        try
          if (FLockedRowsCell = TOvcBaseTableCell(AComponent)) then
            begin
              FLockedRowsCell.DecRefs;
              FLockedRowsCell := nil;
              tbCellChanged(Self);
            end;
          if Assigned(FCols) then
            FCols.tcNotifyCellDeletion(TOvcBaseTableCell(AComponent));
          if Assigned(FCells) then
            FCells.tcNotifyCellDeletion(TOvcBaseTableCell(AComponent));
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;
  end;
{--------}
procedure TOvcCustomTable.tbQueryColData(ColNum : TColNum;
                                     var W : integer;
                                     var A : TOvcTblAccess;
                                     var H : boolean);
  var
    ColData : TOvcTableColumn;
  begin
    ColData := FCols[ColNum];
    if Assigned(ColData) then with ColData do
      begin
        W := Width;
        if (DefaultCell <> nil) then
          A := DefaultCell.Access
        else
          A := otxReadOnly;
        H := Hidden;
      end;
  end;
{--------}
procedure TOvcCustomTable.tbQueryRowData(RowNum : TRowNum;
                                     var Ht: integer;
                                     var H : boolean);
  var
    RowData : TRowStyle;
  begin
    RowData := FRows[RowNum];
    with RowData do
      begin
        Ht:= Height;
        H := Hidden;
      end;
  end;
{--------}
procedure TOvcCustomTable.SetBounds(ALeft, ATop, AWidth, AHeight: integer);
  var
    WidthChanged  : boolean;
    HeightChanged : boolean;
  begin
    if (not HandleAllocated) then
      begin
        inherited SetBounds(ALeft, ATop, AWidth, AHeight);
        Exit;
      end;

    WidthChanged := (Width <> AWidth);
    HeightChanged := (Height <> AHeight);

    if WidthChanged or HeightChanged then
      begin
        AllowRedraw := false;
        try
          inherited SetBounds(ALeft, ATop, AWidth, AHeight);
          if WidthChanged then
            tbCalcColData(tbColNums, LeftCol);
          if HeightChanged then
            tbCalcRowData(tbRowNums, TopRow);
          tbSetScrollRange(otsbVertical);
          tbSetScrollRange(otsbHorizontal);
          if (TopRow > tbLastTopRow) then
            TopRow := tbLastTopRow;
          if (LeftCol > tbLastLeftCol) then
            LeftCol := tbLastLeftCol;
          InvalidateTable;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end
    else
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  end;
{====================================================================}


{==TOvcTable active cell movement====================================}
procedure TOvcCustomTable.tbMoveActCellBotOfPage;
  var
    RowInx : integer;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    with tbRowNums^ do
      if (Ay[Count].Offset <= ClientHeight) then
        NewActiveRow := IncRow(Ay[pred(Count)].Number, 0)
      else
        begin
          RowInx := pred(Count);
          if (RowInx > 0) then
            dec(RowInx);
          if (Ay[RowInx].Number < LockedRows) then
            NewActiveRow := IncRow(TopRow, 0)
          else
            NewActiveRow := IncRow(Ay[RowInx].Number, 0);
        end;
    NewActiveCol := ActiveCol;
    DoActiveCellMoving(ccBotOfPage, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellBotRight;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(pred(RowLimit), 0);
    NewActiveCol := IncCol(pred(ColCount), 0);
    DoActiveCellMoving(ccBotRightCell, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellDown;
  var
    NewTopRow    : TRowNum;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
    i            : integer;
  begin
    NewTopRow := TopRow;
    NewActiveRow := IncRow(ActiveRow, 1);
    NewActiveCol := ActiveCol;
    DoActiveCellMoving(ccDown, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        {we need to take care of a special case: if the current active
         cell is *exactly* on the last row of the page, we need to
         artificially move the top row down by one, before setting the
         active cell, otherwise the top row is forced to the active cell
         later on--a bit disconcerting.}
        with tbRowNums^ do
          if (Ay[Count].Offset = ClientHeight) and
             (ActiveRow = Ay[pred(Count)].Number) and
             (NewActiveRow > ActiveRow) then
            begin
              for i := 1 to NewActiveRow-ActiveRow do
                NewTopRow := IncRow(TopRow, 1);
              if (NewTopRow < NewActiveRow) then
                begin
                  AllowRedraw := False;
                  try
                    TopRow := NewTopRow;
                    tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
                  finally
                    AllowRedraw := True;
                  end;{try..finally}
                end
              else
                tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
            end
          else
            begin
              tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
            end;
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellFirstCol;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveCol := IncCol(LockedCols, 0);
    NewActiveRow := ActiveRow;
    DoActiveCellMoving(ccHome, NewActiveRow, NewActiveCol);
    if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellFirstRow;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(LockedRows, 0);
    NewActiveCol := ActiveCol;
    DoActiveCellMoving(ccFirstPage, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellLastCol;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveCol := IncCol(pred(ColCount), 0);
    NewActiveRow := ActiveRow;
    DoActiveCellMoving(ccEnd, NewActiveRow, NewActiveCol);
    if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellLastRow;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(pred(RowLimit), 0);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        NewActiveCol := ActiveCol;
        DoActiveCellMoving(ccLastPage, NewActiveRow, NewActiveCol);
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellLeft;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveCol := IncCol(ActiveCol, -1);
    NewActiveRow := ActiveRow;
    DoActiveCellMoving(ccLeft, NewActiveRow, NewActiveCol);
    if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellPageDown;
  var
    NewTopRow,
    CurRow, LastRow : TRowNum;
    CurInx, LastInx : integer;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    CurRow := ActiveRow;
    CurInx := tbFindRowInx(CurRow);
    with tbRowNums^ do
      begin
        LastInx := pred(Count);
        LastRow := Ay[LastInx].Number;
      end;
    if (CurRow = LastRow) then
      NewTopRow := IncRow(LastRow, 1)
    else
      NewTopRow := LastRow;

    AllowRedraw := false;
    try
      TopRow := NewTopRow;

      if (CurInx = -1) then
        NewActiveRow := IncRow(TopRow, 0)
      else if (CurInx < tbRowNums^.Count) then
        NewActiveRow := IncRow(tbRowNums^.Ay[CurInx].Number, 0)
      else
        NewActiveRow := IncRow(tbRowNums^.Ay[pred(tbRowNums^.Count)].Number, 0);
      NewActiveCol := ActiveCol;
      DoActiveCellMoving(ccNextPage, NewActiveRow, NewActiveCol);
      if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
        begin
          tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellPageLeft;
  var
    Walker,
    CurLeftCol : TRowNum;
    CurInx : integer;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    CurLeftCol := LeftCol;
    if (ActiveCol = LeftCol) then
      begin
        Walker := IncCol(CurLeftCol, -1);
        if (Walker = CurLeftCol) then
          Exit;
      end;
    CurInx := tbFindColInx(ActiveCol);
    AllowRedraw := false;
    try
      tbScrollBarPageLeft;
      if (CurInx = -1) or (CurLeftCol = LeftCol) then
        NewActiveCol := IncCol(LeftCol, 0)
      else if (CurInx < tbColNums^.Count) then
        NewActiveCol := IncCol(tbColNums^.Ay[CurInx].Number, 0)
      else
        NewActiveCol := IncCol(tbColNums^.Ay[pred(tbColNums^.Count)].Number, 0);
      NewActiveRow := ActiveRow;
      DoActiveCellMoving(ccPageLeft, NewActiveRow, NewActiveCol);
      if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
        begin
          tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellPageRight;
  var
    NewLeftCol,
    CurCol, LastCol : TColNum;
    CurInx, LastInx : integer;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    CurCol := ActiveCol;
    CurInx := tbFindColInx(CurCol);
    with tbColNums^ do
      begin
        LastInx := pred(Count);
        LastCol := Ay[LastInx].Number;
      end;
    if (CurCol = LastCol) then
      NewLeftCol := IncCol(LastCol, 1)
    else
      NewLeftCol := LastCol;

    AllowRedraw := false;
    try
      LeftCol := NewLeftCol;

      if (CurInx = -1) then
        NewActiveCol := IncCol(LeftCol, 0)
      else if (CurInx < tbColNums^.Count) then
        NewActiveCol := IncCol(tbColNums^.Ay[CurInx].Number, 0)
      else
        NewActiveCol := IncCol(tbColNums^.Ay[pred(tbColNums^.Count)].Number, 0);
      NewActiveRow := ActiveRow;
      DoActiveCellMoving(ccPageRight, NewActiveRow, NewActiveCol);
      if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
        begin
          tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellPageUp;
  var
    Walker,
    CurTopRow : TRowNum;
    CurInx : integer;
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    CurTopRow := TopRow;
    if (ActiveRow = TopRow) then
      begin
        Walker := IncRow(CurTopRow, -1);
        if (Walker = CurTopRow) then
          Exit;
      end;
    CurInx := tbFindRowInx(ActiveRow);
    AllowRedraw := false;
    try
      tbScrollBarPageUp;
      if (CurInx = -1) or (CurTopRow = TopRow) then
        NewActiveRow := IncRow(TopRow, 0)
      else if (CurInx < tbRowNums^.Count) then
        NewActiveRow := IncRow(tbRowNums^.Ay[CurInx].Number, 0)
      else
        NewActiveRow := IncRow(tbRowNums^.Ay[pred(tbRowNums^.Count)].Number, 0);
      NewActiveCol := ActiveCol;
      DoActiveCellMoving(ccPrevPage, NewActiveRow, NewActiveCol);
      if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
        begin
          tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellRight;
  var
    NewActiveRow : TRowNum;
    NewLeftCol,
    NewActiveCol : TColNum;
    i            : integer;
  begin
    NewLeftCol := LeftCol;
    NewActiveCol := IncCol(ActiveCol, 1);
    NewActiveRow := ActiveRow;
    DoActiveCellMoving(ccRight, NewActiveRow, NewActiveCol);
    if (ActiveCol <> NewActiveCol) or (ActiveRow <> NewActiveRow) then
      begin
        {we need to take care of a special case: if the current active
         cell is *exactly* on the last column of the page, we need to
         artificially move the leftmost column across by one, before
         setting the active cell, otherwise the leftmost column is
         forced to the active cell later on--a bit disconcerting.}
        with tbColNums^ do
          if (NewActiveCol > ActiveCol) and
             (ActiveCol = Ay[pred(Count)].Number) and
             (Ay[Count].Offset = ClientWidth) then
            begin
              for i := 1 to NewActiveCol-ActiveCol do
                NewLeftCol := IncCol(LeftCol, 1);
              if (NewLeftCol < NewActiveCol) then
                begin
                  AllowRedraw := False;
                  try
                    LeftCol := NewLeftCol;
                    tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
                  finally
                    AllowRedraw := True;
                  end;{try..finally}
                end
              else
                tbSetActiveCellWithSel(NewActiveRow, NewActiveCol)
            end
          else
            tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellTopLeft;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(LockedRows, 0);
    NewActiveCol := IncCol(LockedCols, 0);
    DoActiveCellMoving(ccTopLeftCell, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellTopOfPage;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(TopRow, 0);
    NewActiveCol := ActiveCol;
    DoActiveCellMoving(ccTopOfPage, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.tbMoveActCellUp;
  var
    NewActiveRow : TRowNum;
    NewActiveCol : TColNum;
  begin
    NewActiveRow := IncRow(ActiveRow, -1);
    NewActiveCol := ActiveCol;
    DoActiveCellMoving(ccUp, NewActiveRow, NewActiveCol);
    if (ActiveRow <> NewActiveRow) or (ActiveCol <> NewActiveCol) then
      begin
        tbSetActiveCellWithSel(NewActiveRow, NewActiveCol);
      end;
  end;
{--------}
procedure TOvcCustomTable.MoveActiveCell(Command : word);
  begin
    if (otoNoSelection in Options) then
      tbIsKeySelecting := false;
{
Fix for problem 667935
Hide drag image if visible
If the active cell is moved while drag-moving lines or cols the drag image
will be painted at random places in the table
}
    if tbDrag<>nil then
      tbDrag.HideDragImage;
    case Command of
      {NOTE: this case statement has been optimised, the ccXxx
       constants are in ASCENDING order of value not name--it's
       lucky that the former implies the latter.}
      ccBotOfPage     : tbMoveActCellBotOfPage;
      ccBotRightCell  : tbMoveActCellBotRight;
      ccDown          : tbMoveActCellDown;
      ccEnd           : tbMoveActCellLastCol;
      ccFirstPage     : tbMoveActCellFirstRow;
      ccHome          : tbMoveActCellFirstCol;
      ccLastPage      : tbMoveActCellLastRow;
      ccLeft          : tbMoveActCellLeft;
      ccNextPage      : tbMoveActCellPageDown;
      ccPageLeft      : tbMoveActCellPageLeft;
      ccPageRight     : tbMoveActCellPageRight;
      ccPrevPage      : tbMoveActCellPageUp;
      ccRight         : tbMoveActCellRight;
      ccTopLeftCell   : tbMoveActCellTopLeft;
      ccTopOfPage     : tbMoveActCellTopOfPage;
      ccUp            : tbMoveActCellUp;
    end;{case}
{
Fix for problem 667935
}
    if tbDrag<>nil then
      tbDrag.ShowDragImage;
  end;
{====================================================================}


{==TOvcTable scrollbar event handlers================================}
procedure TOvcCustomTable.ProcessScrollBarClick(ScrollBar : TOvcScrollBar;
                                                ScrollCode : TScrollCode);
  var
    Form : TCustomForm;
  begin
    {check to see whether the cell being edited is valid;
     no scrolling allowed if it isn't (tough).}
    if InEditingState then
      begin
        if not tbActCell.CanSaveEditedData(true) then
          Exit;
      end;
    {perform the scroll}
    if (ScrollBar = otsbVertical) then
      case ScrollCode of
        scLineUp   : tbScrollBarUp;
        scLineDown : tbScrollBarDown;
        scPageUp   : tbScrollBarPageUp;
        scPageDown : tbScrollBarPageDown;
      end{case}
    else {it's otsbHorizontal}
      case ScrollCode of
        scLineUp   : tbScrollBarLeft;
        scLineDown : tbScrollBarRight;
        scPageUp   : tbScrollBarPageLeft;
        scPageDown : tbScrollBarPageRight;
      end;{case}
    if (otsDesigning in tbState) then
      begin
        Form := TCustomForm(GetParentForm(Self));
        if (Form <> nil) and (Form.Designer <> nil) then
          Form.Designer.Modified;
      end;
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarDown;
  begin
    TopRow := IncRow(TopRow, 1);
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarPageDown;
  var
    LastInx : integer;
    LastRow : TRowNum;
  begin
    with tbRowNums^ do
      begin
        LastInx := pred(Count);
        LastRow := Ay[LastInx].Number;
      end;
    if (TopRow <> LastRow) then
      TopRow := LastRow
    else
      TopRow := IncRow(TopRow, 1);
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarPageUp;
  var
    CurTopRow : TRowNum;
    Walker    : TRowNum;
    CH        : integer;
    OurRowNums: POvcTblDisplayArray;
    NewTopRow : TRowNum;
  begin
    {-Scroll the table so that the current top row appears at
      the bottom of the table window (if possible).}
    CurTopRow := TopRow;
    Walker := IncRow(CurTopRow, -1);
    if (Walker = CurTopRow) then
      Exit;

    OurRowNums := nil;
    AssignDisplayArray(OurRowNums, tbRowNums^.AllocNm);
    try
      CH := ClientHeight;
      NewTopRow := Walker;
      tbCalcRowData(OurRowNums, NewTopRow);
      while (OurRowNums^.Ay[OurRowNums^.Count].Offset < CH) or
            (OurRowNums^.Ay[pred(OurRowNums^.Count)].Number > CurTopRow) do
      begin
        Walker := IncRow(NewTopRow, -1);
        if (Walker = NewTopRow) then
          Break;
        NewTopRow := Walker;
        tbCalcRowData(OurRowNums, NewTopRow);
      end;
    finally
      AssignDisplayArray(OurRowNums, 0);
    end;{try..finally}
    TopRow := NewTopRow;
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarUp;
  begin
    TopRow := IncRow(TopRow, -1);
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarLeft;
  begin
    LeftCol := IncCol(LeftCol, -1);
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarPageLeft;
  var
    CurLeftCol : TColNum;
    Walker     : TColNum;
    CW         : integer;
    OurColNums : POvcTblDisplayArray;
    NewLeftCol : TColNum;
  begin
    CurLeftCol := LeftCol;
    Walker := IncCol(CurLeftCol, -1);
    if (Walker = CurLeftCol) then
      Exit;

    OurColNums := nil;
    AssignDisplayArray(OurColNums, tbColNums^.AllocNm);
    try
      CW := ClientWidth;
      NewLeftCol := Walker;
      tbCalcColData(OurColNums, NewLeftCol);
      while (OurColNums^.Ay[OurColNums^.Count].Offset < CW) or
            (OurColNums^.Ay[pred(OurColNums^.Count)].Number > CurLeftCol) do
      begin
        Walker := IncCol(NewLeftCol, -1);
        if (Walker = NewLeftCol) then
          Break;
        NewLeftCol := Walker;
        tbCalcColData(OurColNums, NewLeftCol);
      end;
    finally
      AssignDisplayArray(OurColNums, 0);
    end;{try..finally}
    LeftCol := NewLeftCol;
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarPageRight;
  var
    LastInx : integer;
    LastCol : TColNum;
  begin
    with tbColNums^ do
      begin
        LastInx := pred(Count);
        LastCol := Ay[LastInx].Number;
      end;
    if (LeftCol <> LastCol) then
      LeftCol := LastCol
    else
      LeftCol := IncCol(LeftCol, 1);
  end;
{--------}
procedure TOvcCustomTable.tbScrollBarRight;
  begin
    LeftCol := IncCol(LeftCol, 1);
  end;
{====================================================================}


{==TOvcTable table scrolling routines================================}
procedure TOvcCustomTable.tbScrollTableLeft(NewLeftCol : TColNum);
  var
    NewColInx : integer;
    NewCLOfs  : integer;
    OldColRight : TColNum;
    OldColInx : integer;
    OldCLOfs  : integer;
    ColNum    : TColNum;
    R         : TRect;
    CW        : integer;
  begin
    {the window is scrolled left, ie the new leftmost column
     is to the right of the current leftmost column}
    AllowRedraw := false;
    try
      NewColInx := tbFindColInx(NewLeftCol);
      CW := ClientWidth;
      if (NewColInx = -1) or
         (tbColNums^.Ay[succ(NewColInx)].Offset > CW) then
        begin
          {the new leftmost column is not (fully) visible}
          FLeftCol := NewLeftCol;
          tbCalcColData(tbColNums, LeftCol);
          InvalidateTableNotLockedCols;
        end
      else
        begin
          {the new leftmost column is fully visible}
          OldColInx := tbFindColInx(FLeftCol);
          with tbColNums^ do
            begin
              OldColRight := Ay[pred(Count)].Number;
              if (Ay[Count].Offset < CW) then
                begin
                  inc(OldColRight);
                  tbInvCells.AddUnusedBit;
                end;
              NewCLOfs := Ay[NewColInx].Offset;
              OldCLOfs := Ay[OldColInx].Offset;
            end;
          R := Rect(OldCLOfs, 0, CW, ClientHeight);
          ScrollWindow(Handle,
                       (OldCLOfs-NewCLOfs), 0,
                       @R, @R);
          FLeftCol := NewLeftCol;
          tbCalcColData(tbColNums, LeftCol);
          if (OldColRight <= tbColNums^.Ay[pred(tbColNums^.Count)].Number) then
            begin
              tbInvCells.AddUnusedBit;
              for ColNum := OldColRight to tbColNums^.Ay[pred(tbColNums^.Count)].Number do
                InvalidateColumn(ColNum);
            end;
          R.Left := OldCLOfs + (CW - NewCLOfs);
          ValidateRect(Handle, @R);
          tbMustUpdate := true;
          UpdateWindow(Handle);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbScrollTableRight(NewLeftCol : TColNum);
  var
    OldLeftCol: TColNum;
    OldColInx : integer;
    OldCLOfs  : integer;
    OrigOfs   : integer;
    ColNum    : TColNum;
    R         : TRect;
  begin
    {the window is scrolled right, ie the new leftmost column
     is to the left of the current leftmost column}
    AllowRedraw := false;
    try
      OldLeftCol := FLeftCol;
      OldColInx := tbFindColInx(OldLeftCol);
      OrigOfs := tbColNums^.Ay[OldColInx].Offset;
      FLeftCol := NewLeftCol;
      tbCalcColData(tbColNums, LeftCol);
      OldColInx := tbFindColInx(OldLeftCol);
      if (OldColInx = -1) then
        begin
          {the old leftmost column is no longer visible}
          InvalidateTableNotLockedCols;
        end
      else
        begin
          {the old leftmost column is (partially) visible}
          OldCLOfs := tbColNums^.Ay[OldColInx].Offset;
          R := Rect(OrigOfs, 0, ClientWidth, ClientHeight);
          ScrollWindow(Handle,
                       (OldClOfs-OrigOfs), 0,
                       @R, @R);
          for ColNum := FLeftCol to pred(OldLeftCol) do
            InvalidateColumn(ColNum);
          R.Right := OldCLOfs;
          ValidateRect(Handle, @R);
          tbMustUpdate := true;
          UpdateWindow(Handle);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbScrollTableUp(NewTopRow : TRowNum);
  var
    NewRowInx : integer;
    NewRTOfs  : integer;
    OldRowBottom : TRowNum;
    OldRowInx : integer;
    OldRTOfs  : integer;
    RowNum    : TRowNum;
    R         : TRect;
    CH        : integer;
  begin
    {the window is scrolled up, ie the new topmost row
     is underneath the current topmost row}
    AllowRedraw := false;
    try
      NewRowInx := tbFindRowInx(NewTopRow);
      CH := ClientHeight;
      if (NewRowInx = -1) or
         (tbRowNums^.Ay[succ(NewRowInx)].Offset > CH) then
        begin
          {the new topmost row is not (fully) visible}
          FTopRow := NewTopRow;
          tbCalcRowData(tbRowNums, TopRow);
          InvalidateTableNotLockedRows;
        end
      else
        begin
          {the new topmost row is fully visible}
          OldRowInx := tbFindRowInx(FTopRow);
          with tbRowNums^ do
            begin
              OldRowBottom := Ay[pred(Count)].Number;
              if (Ay[Count].Offset < CH) then
                begin
                  inc(OldRowBottom);
                  tbInvCells.AddUnusedBit;
                end;
              NewRTOfs := Ay[NewRowInx].Offset;
              OldRTOfs := Ay[OldRowInx].Offset;
            end;
          R := Rect(0, OldRTOfs, ClientWidth, CH);
          ScrollWindow(Handle,
                       0, (OldRTOfs-NewRTOfs),
                       @R, @R);
          FTopRow := NewTopRow;
          tbCalcRowData(tbRowNums, TopRow);
          if (OldRowBottom <= tbRowNums^.Ay[pred(tbRowNums^.Count)].Number) then
            begin
              tbInvCells.AddUnusedBit;
              for RowNum := OldRowBottom to tbRowNums^.Ay[pred(tbRowNums^.Count)].Number do
                InvalidateRow(RowNum);
            end;
          R.Top := OldRTOfs + (CH - NewRTOfs);
          ValidateRect(Handle, @R);
          tbMustUpdate := true;
          UpdateWindow(Handle);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.tbScrollTableDown(NewTopRow : TRowNum);
  var
    OldTopRow : TRowNum;
    OldRowInx : integer;
    OldRTOfs  : integer;
    OrigOfs   : integer;
    RowNum    : TRowNum;
    R         : TRect;
  begin
    {the window is scrolled down, ie the new topmost row
     is above the current topmost row}
    AllowRedraw := false;
    try
      OldTopRow := FTopRow;
      OldRowInx := tbFindRowInx(OldTopRow);
      OrigOfs := tbRowNums^.Ay[OldRowInx].Offset;
      FTopRow := NewTopRow;
      tbCalcRowData(tbRowNums, TopRow);
      OldRowInx := tbFindRowInx(OldTopRow);
      if (OldRowInx = -1) then
        begin
          {the old topmost row is no longer visible}
          InvalidateTableNotLockedRows;
        end
      else
        begin
          {the old topmost row is (partially) visible}
          OldRTOfs := tbRowNums^.Ay[OldRowInx].Offset;
          R := Rect(0, OrigOfs, ClientWidth, ClientHeight);
          ScrollWindow(Handle,
                       0, (OldRTOfs-OrigOfs),
                       @R, @R);
          for RowNum := FTopRow to pred(OldTopRow) do
            InvalidateRow(RowNum);
          R.Bottom := OldRTOfs;
          ValidateRect(Handle, @R);
          tbMustUpdate := true;
          UpdateWindow(Handle);
        end;
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{====================================================================}


{==TOvcTable drawing routines========================================}
procedure TOvcCustomTable.tbDrawActiveCell;
  var
    RowOfs : integer;
    ColOfs : integer;
    RowInx : integer;
    ColInx : integer;
    Ht     : integer;
    Wd     : integer;
    ActRowOfs    : integer;
    ActRowBottom : integer;
    ActColOfs    : integer;
    ActColRight  : integer;
    GridPen      : TOvcGridPen;
    BrushColor   : TColor;
    DrawItFocused: boolean;
  begin
    ActRowOfs    := 0;
    ActRowBottom := 0;
    ActColOfs    := 0;
    ActColRight  := 0;

    {Find the cell's row on the screen, exit if not present}
    RowInx := tbFindRowInx(ActiveRow);
    if (RowInx = -1) then Exit;

    {Find the cell's column on the screen, exit if not present}
    ColInx := tbFindColInx(ActiveCol);
    if (ColInx = -1) then Exit;

    {If we are in editing mode, display the editing control for the
     cell, otherwise, draw the focus box around the cell contents}
    if InEditingState then
      begin
        UpdateWindow(tbActCell.EditHandle);
      end
    else
      begin
        {draw the box round the cell}
        with Canvas do
          begin
            {get the correct grid pen}
            if (otsFocused in tbState) then
              begin
                GridPen := GridPenSet.CellWhenFocused;
                DrawItFocused := true;
              end
            else
              begin
                GridPen := GridPenSet.CellWhenUnfocused;
                DrawItFocused := false;
              end;
            if GridPen.Effect = geNone then
              Exit;

            RowOfs := tbRowNums^.Ay[RowInx].Offset;
            Ht := tbRowNums^.Ay[succ(RowInx)].Offset - RowOfs;
            ColOfs := tbColNums^.Ay[ColInx].Offset;
            Wd := tbColNums^.Ay[succ(ColInx)].Offset - ColOfs;

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
            end;{case}

            {get the correct background color for the pen}
            if DrawItFocused then
                 BrushColor := Colors.ActiveFocused
            else BrushColor := Colors.ActiveUnfocused;
            Brush.Color := Color;

            Windows.SetBkColor(Handle, ColorToRGB(BrushColor));

            {set up the pen}
            with Pen do
              begin
                Width := 1;
                Style := GridPen.Style;
                Color := GridPen.NormalColor;
              end;

            {right line}
            if GridPen.Effect in [geVertical, geBoth, ge3D] then
              begin
                MoveTo(ActColRight, ActRowOfs);
                LineTo(ActColRight, ActRowBottom+1);
              end;
            {bottom line}
            if GridPen.Effect in [geHorizontal, geBoth, ge3D] then
              begin
                MoveTo(ActColOfs, ActRowBottom);
                LineTo(ActColRight+1, ActRowBottom);
              end;

            {if in 3D, must change colors}
            if (GridPen.Effect = ge3D) then
              Pen.Color := GridPen.SecondColor;

            {left line}
            if GridPen.Effect in [geVertical, geBoth, ge3D] then
              begin
                MoveTo(ActColOfs, ActRowOfs);
                LineTo(ActColOfs, ActRowBottom+1);
              end;
            {top line}
            if GridPen.Effect in [geHorizontal, geBoth, ge3D] then
              begin
                MoveTo(ActColOfs, ActRowOfs);
                LineTo(ActColRight+1, ActRowOfs);
              end;
          end;
      end;
  end;

{--------}
procedure TOvcCustomTable.tbDrawCellBorder(RowInx: TRowNum; ColInx: TColNum;
  CellAttr: TOvcCellAttributes);
var
  RowOfs    : integer;
  RowHt     : integer;
//  RowNum    : TRowNum;
//  ColNum    : TColNum;
  ColOfs    : integer;
  ColWd     : integer;
//  DestRect  : TRect;
begin
  with tbRowNums^ do
    begin
//      RowNum := Ay[RowInx].Number;
      RowOfs := Ay[RowInx].Offset;
      RowHt := Ay[succ(RowInx)].Offset - RowOfs;
    end;
    with tbColNums^ do
      begin
//        ColNum := Ay[ColInx].Number;
        ColOfs := Ay[ColInx].Offset;
        ColWd := Ay[succ(ColInx)].Offset - ColOfs;
      end;

  if (CellAttr.caBorderColor <> clOvcTableDefault) or (CellAttr.caBorderStyle <> psSolid) then
  begin
    if CellAttr.caBorderColor <> clOvcTableDefault then
      Canvas.Pen.Color := CellAttr.caBorderColor
    else
      Canvas.Pen.Color := GridPenSet.NormalGrid.NormalColor;
    Canvas.Pen.Width := CellAttr.caBorderWidth;
    Canvas.Pen.Style := CellAttr.caBorderStyle;
    Canvas.MoveTo(ColOfs, RowOfs);
    Canvas.LineTo(ColOfs + ColWd - 1, RowOfs);
    Canvas.LineTo(ColOfs + ColWd - 1, RowOfs + RowHt - 1);
    Canvas.LineTo(ColOfs, RowOfs + RowHt - 1);
    Canvas.LineTo(ColOfs, RowOfs);
  end;
end;

procedure TOvcCustomTable.tbDrawCellBorders(RowInxStart, RowInxEnd, ColInxStart,
  ColInxEnd: integer);
var
  RowInx: TRowNum;
  ColInx: TColNum;
  CellAttr: TOvcCellAttributes;
  RowNum    : TRowNum;
  ColNum    : TColNum;
begin
  {Delphi bug fix - refresh the canvas handle to force brush to be recreated}
  Canvas.Refresh;
  {draw cells that need it}

  if (RowInxStart < 0) or (RowInxEnd < 0) or
     (ColInxStart < 0) or (ColInxEnd < 0) then
    Exit;

  FillChar(CellAttr, SizeOf(CellAttr), 0);
  CellAttr.caFont := TFont.Create;
  try
    with tbRowNums^ do
      for RowInx := RowInxStart to RowInxEnd do
        for ColInx := ColInxStart to ColInxEnd do
        begin
          CellAttr.caBorderColor := clOvcTableDefault;
          CellAttr.caBorderStyle := psSolid;
          CellAttr.caBorderWidth := 1;
          RowNum := tbRowNums^.Ay[RowInx].Number;
          ColNum := tbColNums^.Ay[ColInx].Number;
          ResolveCellAttributes(RowNum, ColNum, CellAttr);
          tbDrawCellBorder(RowInx, ColInx, CellAttr);
        end;
  finally
    FreeAndNil(CellAttr.caFont);
  end;
end;

procedure TOvcCustomTable.tbDrawCells(RowInxStart, RowInxEnd : integer;
                                      ColInxStart, ColInxEnd : integer);
  var
    RowInx : integer;
  begin
    {Delphi bug fix - refresh the canvas handle to force brush to be recreated}
    Canvas.Refresh;
    {draw cells that need it}

    if (RowInxStart < 0) or (RowInxEnd < 0) or
       (ColInxStart < 0) or (ColInxEnd < 0) then
      Exit;

    with tbRowNums^ do
      for RowInx := RowInxStart to RowInxEnd do
        tbDrawRow(RowInx, ColInxStart, ColInxEnd);
  end;
{--------}
procedure TOvcCustomTable.tbDrawInvalidCells(InvCells : TOvcCellArray);
  var
    RowInx     : integer;
    ColInx     : integer;
    EndColInx  : integer;
    CellInx    : integer;
    NextCellInx: integer;
    OldRowNum  : TRowNum;
    CellAddr   : TOvcCellAddress;
    NewCellAddr: TOvcCellAddress;
    EndCol     : TColNum;
    ContinueTrying : boolean;
    GR: TRect;
  begin
    if FHasBorderWidth then // draw the entire table if borderwidth > 1; this could be optimized
    begin
      if tbCalcCellsFromRect(ClientRect, GR) = 2 then
        Exit;

      GR.Top := tbFindRowInx(GR.Top);
      tbDrawCells(GR.Top, GR.Bottom, GR.Left, GR.Right);
      DoPaintUnusedArea;
      tbDrawCellBorders(GR.Top, GR.Bottom, GR.Left, GR.Right);
      tbDrawRowBorders(GR.Top, GR.Bottom);
      InvCells.Clear;
      Exit;
    end;

    if (InvCells.Count > 0) then
      begin
        {Delphi bug fix - refresh the canvas handle to force brush to be recreated}
        Canvas.Refresh;
        {set up for while loop}
        OldRowNum := -1;
        CellInx := 0;
        while (CellInx < InvCells.Count) do
          begin
            InvCells.GetCellAddr(CellInx, CellAddr);
            RowInx := tbFindRowInx(CellAddr.Row);
            if (RowInx <> -1) then
              begin
                ColInx := tbFindColInx(CellAddr.Col);
                if (ColInx <> -1) then
                  begin
                    {have we switched rows?}
                    if (OldRowNum <> CellAddr.Row) then
                      OldRowNum := CellAddr.Row;
                    {try and get a block of columns}
                    EndCol := CellAddr.Col;
                    NextCellInx := succ(CellInx);
                    ContinueTrying := true;
                    while ContinueTrying do
                      begin
                        if (NextCellInx >= InvCells.Count) then
                          ContinueTrying := false
                        else
                          begin
                            InvCells.GetCellAddr(NextCellInx, NewCellAddr);
                            if (OldRowNum = NewCellAddr.Row) and
                               (NewCellAddr.Col = succ(EndCol)) then
                              begin
                                EndCol := NewCellAddr.Col;
                                inc(NextCellInx);
                              end
                            else
                              ContinueTrying := false;
                          end
                      end;
                    if (EndCol <> CellAddr.Col) then
                      begin
                        EndColInx := tbFindColInx(EndCol);
                        CellInx := pred(NextCellInx);
                        {just in case (hidden cols perhaps?)}
                        while (EndColInx = -1) do
                          begin
                            dec(EndCol);
                            EndColInx := tbFindColInx(EndCol);
                          end
                      end
                    else
                      EndColInx := ColInx;
                    tbDrawRow(RowInx, ColInx, EndColInx);
                  end;
              end;
            inc(CellInx);
          end;
      end;
    if InvCells.MustDoUnusedBit then
      DoPaintUnusedArea;
    InvCells.Clear;
  end;
{--------}
procedure TOvcCustomTable.tbDrawMoveLine;
  var
    OldPen : TPen;
    MoveOffset : integer;
  begin
    if tbDrag <> nil then
      tbDrag.HideDragImage;
    if (otsMoving in tbState) then
      with Canvas do
        begin
          OldPen := TPen.Create;
          try
            OldPen.Assign(Pen);
            try
              Pen.Mode := pmXor;
              Pen.Style := psSolid;
              Pen.Color := clWhite;
              Pen.Width := 3;
              if (otsDoingCol in tbState) then
                begin
                  if (tbMoveIndex < tbMoveIndexTo) then
                    MoveOffset := tbColNums^.Ay[succ(tbMoveIndexTo)].Offset
                  else
                    MoveOffset := tbColNums^.Ay[tbMoveIndexTo].Offset;
                  MoveTo(MoveOffset, 0);
                  LineTo(MoveOffset, ClientHeight);
                end
              else {doing row}
                begin
                  if (tbMoveIndex < tbMoveIndexTo) then
                    MoveOffset := tbRowNums^.Ay[succ(tbMoveIndexTo)].Offset
                  else
                    MoveOffset := tbRowNums^.Ay[tbMoveIndexTo].Offset;
                  MoveTo(0, MoveOffset);
                  LineTo(ClientWidth, MoveOffset);
                end
            finally
              Canvas.Pen := OldPen;
            end;{try..finally}
          finally
            OldPen.Free;
          end;{try..finally}
        end;
    if tbDrag <> nil then
      tbDrag.ShowDragImage;
  end;
{--------}
procedure TOvcCustomTable.tbDrawRow(RowInx : integer; ColInxStart, ColInxEnd : integer);
  var
    RowOfs    : integer;
    RowHt     : integer;
    RowNum    : TRowNum;
    ColInx    : integer;
    ColNum    : TColNum;
    ColOfs    : integer;
    ColWd     : integer;
    Cell      : TOvcBaseTableCell;
    Data      : pointer;
    GridPen   : TOvcGridPen;
    BrushColor: TColor;
    CellAttr  : TOvcCellAttributes;
    RowAttr   : TOvcRowAttributes;
    DestRect  : TRect;
    RowIsLocked : boolean;
    ColIsLocked : boolean;
    IsActiveRow : boolean;
	  DrawRightLine: boolean; //CDE
  begin
    {calculate data about the row, tell the user we're entering the row}
    with tbRowNums^ do
      begin
        RowNum := Ay[RowInx].Number;
        RowOfs := Ay[RowInx].Offset;
        RowHt := Ay[succ(RowInx)].Offset - RowOfs;
      end;
    IsActiveRow := ActiveRow = RowNum;
    RowIsLocked := RowNum < LockedRows;
    { Don't fire the OnEnteringRow when we are painting, unless }
    { OldRowColBehavior is true                                 }
    if OldRowColBehavior then
      DoEnteringRow(RowNum);

    {set up the cell attribute record}
    FillChar(CellAttr, sizeof(CellAttr), 0);
    CellAttr.caFont := tbCellAttrFont;

    {SZ: set up the row attribute record}
    FillChar(RowAttr, SizeOf(RowAttr), 0);
    RowAttr.caBorderColor := clOvcTableDefault;
    ResolveRowAttributes(RowNum, RowAttr);
    if RowAttr.caBorderWidth > 1 then
      FHasBorderWidth := True; // from now on we must invalid the entire visible area

    {for all required cells}
    for ColInx := ColInxEnd downto ColInxStart do
      begin
        {set up the cell border attributes}
        CellAttr.caBorderColor := clOvcTableDefault;
        CellAttr.caBorderStyle := psSolid;
        {calculate data about the column, tell the user we're entering the column}
        with tbColNums^ do
          begin
            ColNum := Ay[ColInx].Number;
            ColOfs := Ay[ColInx].Offset;
            ColWd := Ay[succ(ColInx)].Offset - ColOfs;
          end;
        ColIsLocked := (ColNum < LockedCols);
		    DrawRightLine:=tbIsColShowRightLine(ColNum); //CDE
        { Don't fire the OnEnteringCol when we are painting, unless }
        { OldRowColBehavior is true                                 }
        if OldRowColBehavior then
          DoEnteringColumn(ColNum);

        {get the gridpen for the cell}
        if (RowIsLocked or ColIsLocked) then
          GridPen := GridPenSet.LockedGrid
        else
          GridPen := GridPenSet.NormalGrid;

        {calculate row height/column width available to the cell}
        DestRect := Rect(ColOfs, RowOfs, ColOfs+ColWd, RowOfs+RowHt);
        case GridPen.Effect of
          geVertical  : dec(DestRect.Right);
          geHorizontal: dec(DestRect.Bottom);
          geBoth      : begin
                          dec(DestRect.Right);
                          dec(DestRect.Bottom);
                        end;
          ge3D        : InflateRect(DestRect, -1, -1);
        end;{case}

        {SZ: make the cell content a bit smaller so that alignment is correct after painting the top table border line}
        if (RowInx = 0) and (BorderStyle = bsNone) and (GridPen.Effect in [geHorizontal, geBoth]) then
          Inc(DestRect.Top, 1);

        {don't do painting for the cell being edited}
        Cell := nil;
        if not (IsActiveRow and (ColNum = ActiveCol) and
                (InEditingState)) then
          begin
            {get the cell}
            Cell := tbFindCell(RowNum, ColNum);
            if Assigned(Cell) then begin
                {paint it}
              DoGetCellData(RowNum, ColNum, Data, cdpForPaint);
              CellAttr.caFont.Assign(Font);
              Cell.ResolveAttributes(RowNum, ColNum, CellAttr);
              Cell.Paint(Canvas, DestRect,
                         RowNum, ColNum,
                         CellAttr,
                         Data);
            end;
          end;

        {if no cell found or it's the active cell in editing mode
         clear the rectangle}
        if not Assigned(Cell) or
           (IsActiveRow and (ColNum = ActiveCol) and InEditingState) then
          begin
            with CellAttr do
              begin
                caAccess := otxDefault;
                caAdjust := otaDefault;
                caColor := Color;
                caFont.Assign(Font);
                caFontColor := Font.Color;
              end;
            ResolveCellAttributes(RowNum, ColNum, CellAttr);
            Canvas.Brush.Color := CellAttr.caColor;
            Canvas.FillRect(DestRect);
          end;
        // Custom Cell Border (Grid) current cell
        if CellAttr.caBorderWidth > 1 then
          FHasBorderWidth := True; // from now on we must invalid the entire visible area
        if (CellAttr.caBorderColor <> clOvcTableDefault) or (CellAttr.caBorderStyle <> psSolid) then
          tbDrawCellBorder(RowInx, ColInx, CellAttr)
        else
        {Check to see if there is a grid to display}
        if (GridPen.Effect <> geNone) then
          with Canvas do
            begin
              {Get ready to draw the cell's grid}
              BrushColor := Color;
              Brush.Color := BrushColor;
              Pen.Style := GridPen.Style;
              Pen.Width := 1;

              Windows.SetBkColor(Handle, ColorToRGB(BrushColor));

              {SZ: draw a top line if BorderStyle = bsNone and the horizontal lines should be drawn }
              if (RowInx = 0) and (BorderStyle = bsNone) and (GridPen.Effect in [geHorizontal, geBoth]) then
              begin
                { set the pen color for the top }
                Pen.Color := GridPen.NormalColor;
                { draw top line }
                MoveTo(ColOfs, RowOfs);
                LineTo(ColOfs+ColWd, RowOfs);
              end;


              {draw the top and left lines, only if required of course}
              if (GridPen.Effect = ge3D) then
                begin
                  {set the pen color for the top & left}
                  Pen.Color := GridPen.SecondColor;
                  {draw the lines}
                  MoveTo(ColOfs, pred(RowOfs+RowHt));
                  LineTo(ColOfs, RowOfs);
                  LineTo(ColOfs+ColWd, RowOfs);
                end;

              {set the pen color for the bottom & right}
              Pen.Color := GridPen.NormalColor;

              {draw right line}
              if (GridPen.Effect <> geVertical) then
              begin
                MoveTo(ColOfs, pred(RowOfs + RowHt));
                LineTo(ColOfs + ColWd, pred(RowOfs + RowHt));
              end;

              { draw right line }
              if (GridPen.Effect <> geHorizontal) then
              begin
                // CDE START
                if not DrawRightLine then
                begin
                  Pen.Color := Brush.Color;
                end;
                // END CDE
                MoveTo(ColOfs + ColWd - 1, RowOfs);
                LineTo(ColOfs + ColWd - 1, RowOfs + RowHt);
              end;
         end;
     end;

    //SZ: Draw Row Border
    if (RowAttr.caBorderColor <> clOvcTableDefault) or (RowAttr.caBorderStyle <> psSolid) then
      tbDrawRowBorder(RowInx, RowAttr);
  end;

procedure TOvcCustomTable.tbDrawRowBorder(RowInx: TRowNum; RowAttr: TOvcRowAttributes);
var
  RowOfs    : integer;
  RowHt     : integer;
//  RowNum    : TRowNum;
//  ColNum    : TColNum;
  ColOfs    : integer;
  ColWd     : integer;
//  DestRect  : TRect;
begin
  with tbRowNums^ do
    begin
//      RowNum := Ay[RowInx].Number;
      RowOfs := Ay[RowInx].Offset;
      RowHt := Ay[succ(RowInx)].Offset - RowOfs;
    end;
    with tbColNums^ do
      begin
//        ColNum := Ay[ColInx].Number;
        ColOfs := Ay[0].Offset;
        ColWd := Ay[Count].Offset - ColOfs;
      end;

  if (RowAttr.caBorderColor <> clOvcTableDefault) or (RowAttr.caBorderStyle <> psSolid) then
  begin
    if RowAttr.caBorderColor <> clOvcTableDefault then
      Canvas.Pen.Color := RowAttr.caBorderColor
    else
      Canvas.Pen.Color := GridPenSet.NormalGrid.NormalColor;
    Canvas.Pen.Width := RowAttr.caBorderWidth;
    Canvas.Pen.Style := RowAttr.caBorderStyle;
    Canvas.MoveTo(ColOfs, RowOfs);
    Canvas.LineTo(ColOfs + ColWd - 1, RowOfs);
    Canvas.LineTo(ColOfs + ColWd - 1, RowOfs + RowHt - 1);
    Canvas.LineTo(ColOfs, RowOfs + RowHt - 1);
    Canvas.LineTo(ColOfs, RowOfs);
  end;
end;

procedure TOvcCustomTable.tbDrawRowBorders(RowInxStart, RowInxEnd: Integer);
var
  RowInx: TRowNum;
  RowAttr: TOvcRowAttributes;
  RowNum    : TRowNum;
begin
  {Delphi bug fix - refresh the canvas handle to force brush to be recreated}
  Canvas.Refresh;
  {draw cells that need it}

  if (RowInxStart < 0) or (RowInxEnd < 0) then
    Exit;

  FillChar(RowAttr, SizeOf(RowAttr), 0);

  with tbRowNums^ do
    for RowInx := RowInxStart to RowInxEnd do
      begin
        RowAttr.caBorderColor := clOvcTableDefault;
        RowAttr.caBorderStyle := psSolid;
        RowAttr.caBorderWidth := 1;
        RowNum := tbRowNums^.Ay[RowInx].Number;
        ResolveRowAttributes(RowNum, RowAttr);
        tbDrawRowBorder(RowInx, RowAttr);
      end;
end;

{--------}
procedure TOvcCustomTable.tbDrawSizeLine;
  var
    OldPen : TPen;
  begin
    if (otsSizing in tbState) then
      with Canvas do
        begin
          OldPen := TPen.Create;
          try
            OldPen.Assign(Pen);
            Pen.Color := clBlack;
            Pen.Mode := pmXor;
            Pen.Style := psDot;
            Pen.Width := 1;
            if (otsDoingRow in tbState) then
              begin
                MoveTo(0, tbSizeOffset);
                LineTo(ClientWidth, tbSizeOffset);
              end
            else
              begin
                MoveTo(tbSizeOffset, 0);
                LineTo(tbSizeOffset, ClientHeight);
              end;
          finally
            Canvas.Pen := OldPen;
            OldPen.Free;
          end;{try..finally}
        end;
  end;
{--------}
procedure TOvcCustomTable.tbDrawUnusedBit;
  var
    R  : TRect;
    CR : TRect;
    ChangedBrush : boolean;
  begin
    ChangedBrush := false;
    Windows.GetClientRect(Handle, CR);
    with R, tbColNums^ do
      begin
        Left := Ay[Count].Offset;
        Right := CR.Right;
        Top := 0;
        Bottom := CR.Bottom;
      end;
    if (R.Left < R.Right) then
      with Canvas do
        begin
          Brush.Color := ColorUnused;
          FillRect(R);
          ChangedBrush := true;
        end;

    with R, tbRowNums^ do
      begin
        Right := Left;
        Left := 0;
        Top := Ay[Count].Offset;
      end;
    if (R.Top < R.Bottom) then
      with Canvas do
        begin
          if not ChangedBrush then
            Brush.Color := ColorUnused;
          FillRect(R);
        end;
  end;
{--------}
procedure TOvcCustomTable.Paint;
  var
    UR, GR : TRect;
    WhatToPaint : integer;
    RowInx      : integer;
    ColInx      : integer;
  begin
    {don't do anything if the table is locked from drawing and
     there is no scrolling going on (tbMustUpdate is *only* set in
     the tbScrollTableXxx methods to force an update).}
    if (tbLockCount > 0) and (not tbMustUpdate) then
      begin
        Exit;
      end;

    if tbDrag <> nil then
      tbDrag.HideDragImage;

    Windows.GetClipBox(Canvas.Handle, UR);
    WhatToPaint := tbCalcCellsFromRect(UR, GR);

    if (WhatToPaint = 0) and
       (otsEditing in tbState) and
       ((GR.Top = ActiveRow) and (GR.Bottom = ActiveRow) and
        (GR.Left = ActiveCol) and (GR.Right = ActiveCol)) then
      Exit;

    {if we are actually processing a WM_PAINT message, then paint the
     invalid cells, etc}
    if (tbLockCount = 0) then
      begin
        if (WhatToPaint <> 2) then
          tbDrawCells(GR.Top, GR.Bottom, GR.Left, GR.Right);

        if (WhatToPaint <> 0) then
          DoPaintUnusedArea;

        if FHasBorderWidth then // draw cell border if borderwidth > 1; otherwise drawn in tbDrawRow
        begin
          tbDrawCellBorders(GR.Top, GR.Bottom, GR.Left, GR.Right);
          tbDrawRowBorders(GR.Top, GR.Bottom);
        end;

        tbDrawActiveCell;
      end
    {otherwise we are in the middle of a scroll operation, so just invalidate
     the cells that need it}
    else {tbLockCount > 0, ie tbMustUpdate is true}
      begin
        if (WhatToPaint <> 2) then
          for RowInx := GR.Top to GR.Bottom do
            for ColInx := GR.Left to GR.Right do
              InvalidateCell(tbRowNums^.Ay[RowInx].Number, tbColNums^.Ay[ColInx].Number);
        if (WhatToPaint <> 0) then
          tbInvCells.AddUnusedBit;
        tbMustUpdate := false;
      end;

    if tbDrag <> nil then
      tbDrag.ShowDragImage;

  end;
{====================================================================}


{==TOvcTable event handlers==========================================}
procedure TOvcCustomTable.DoActiveCellChanged(RowNum : TRowNum; ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FActiveCellChanged) then
      FActiveCellChanged(Self, RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.DoActiveCellMoving(Command : word;
                                         var RowNum : TRowNum;
                                         var ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    if Assigned(FActiveCellMoving) then
      FActiveCellMoving(Self, Command, RowNum, ColNum);
    if InEditingState and ((RowNum <> ActiveRow) or (ColNum <> ActiveCol)) then
      if not StopEditingState(true) then
        begin
          RowNum := ActiveRow;
          ColNum := ActiveCol;
          Exit;
        end;
  end;
{--------}
procedure TOvcCustomTable.DoBeginEdit(RowNum : TRowNum; ColNum : TColNum;
                                  var AllowIt : boolean);
  begin
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      AllowIt := false
    else
      begin
        AllowIt := true;
        if Assigned(FBeginEdit) then
          FBeginEdit(Self, RowNum, ColNum, AllowIt);
      end;
  end;
{--------}
procedure TOvcCustomTable.DoClipboardCopy;
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FClipboardCopy) then
      FClipboardCopy(Self);
  end;
{--------}
procedure TOvcCustomTable.DoClipboardCut;
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FClipboardCut) then
      FClipboardCut(Self);
  end;
{--------}
procedure TOvcCustomTable.DoClipboardPaste;
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FClipboardPaste) then
      FClipboardPaste(Self);
  end;
{--------}
procedure TOvcCustomTable.DoColumnsChanged(ColNum1, ColNum2 : TColNum;
                                           Action : TOvcTblActions);
  var
    i : integer;
  begin
    for i := 0 to pred(taCellList.Count) do
      if (TOvcTableCellAncestor(taCellList[i]) is TOvcTCCustomColHead) then
        TOvcTCCustomColHead(taCellList[i]).chColumnsChanged(ColNum1, ColNum2, Action);

    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FColumnsChanged) then
      FColumnsChanged(Self, ColNum1, ColNum2, Action);
  end;
{--------}
procedure TOvcCustomTable.DoDoneEdit(RowNum : TRowNum; ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FDoneEdit) then
      FDoneEdit(Self, RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.DoEndEdit(Cell : TOvcBaseTableCell;
                                    RowNum : TRowNum; ColNum : TColNum;
                                var AllowIt : boolean);
  begin
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      AllowIt := false
    else
      begin
        AllowIt := true;
        if Assigned(FEndEdit) then
          FEndEdit(Self, Cell, RowNum, ColNum, AllowIt);
      end;
  end;
{--------}
procedure TOvcCustomTable.DoEnteringColumn(ColNum : TColNum);
  begin
    if (ColNum <> tbLastEntCol) then
      begin
        tbLastEntCol := ColNum;
        if ((ComponentState * [csLoading, csDestroying]) = []) and
           Assigned(FEnteringColumn) then
          FEnteringColumn(Self, ColNum);
      end;
  end;
{--------}
procedure TOvcCustomTable.DoEnteringRow(RowNum : TRowNum);
  begin
    if (RowNum <> tbLastEntRow) then
      begin
        tbLastEntRow := RowNum;
        if ((ComponentState * [csLoading, csDestroying]) = []) and
           Assigned(FEnteringRow) then
          FEnteringRow(Self, RowNum);
      end;
  end;
{--------}
procedure TOvcCustomTable.DoGetCellAttributes(RowNum : TRowNum; ColNum : TColNum;
                                          var CellAttr : TOvcCellAttributes);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FGetCellAttributes) then
      FGetCellAttributes(Self, RowNum, ColNum, CellAttr);
  end;
{--------}
procedure TOvcCustomTable.DoGetCellData(RowNum  : TRowNum; ColNum : TColNum;
                                    var Data    : pointer;
                                        Purpose : TOvcCellDataPurpose);
{$IFDEF DEBUG}
  var
    DataComp: Integer;
{$ENDIF}
  begin
    Data := nil;
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       HandleAllocated and
       Assigned(FGetCellData) then begin
      FGetCellData(Self, RowNum, ColNum, Data, Purpose);
{$IFDEF DEBUG}
      { A common bug is to provide a pointer to a local variable in 'GetCellData'. This
        will lead to an access-violation. We try to detect this here: If data points
        to some local data, @DataComp will be a "little" larger than 'Data'. 1024
        is an arbitrary choice. }
      if Assigned(Data) and (NativeInt(@DataComp)-NativeInt(Data)>0)
                        and (NativeInt(@DataComp)-NativeInt(Data)<1024) then
        raise EOrpheusTable.CreateFmt(GetOrphStr(SCTableInvalidData),[RowNum,ColNum]);
{$ENDIF}
    end;
  end;
procedure TOvcCustomTable.DoGetRowAttributes(RowNum: TRowNum;
  var CellAttr: TOvcRowAttributes);
begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FOnGetRowAttributes) then
      FOnGetRowAttributes(Self, RowNum, CellAttr);
end;

{--------}
procedure TOvcCustomTable.DoLeavingColumn(ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FLeavingColumn) then
      FLeavingColumn(Self, ColNum);
  end;
{--------}
procedure TOvcCustomTable.DoLeavingRow(RowNum : TRowNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FLeavingRow) then
      FLeavingRow(Self, RowNum);
  end;
{--------}
procedure TOvcCustomTable.DoLockedCellClick(RowNum : TRowNum; ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FLockedCellClick) then
      FLockedCellClick(Self, RowNum, ColNum);
  end;
{--------}

procedure TOvcCustomTable.DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
begin
  inherited DoOnMouseWheel(Shift, Delta, XPos, YPos);

  if (ssCtrl in Shift) then begin
    if (Delta > 0) then
      tbMoveActCellPageUp
    else
      tbMoveActCellPageDown;
  end else begin
    if Delta < 0 then
      MoveActiveCell(ccDown)
    else
      MoveActiveCell(ccUp);
  end;
end;

procedure TOvcCustomTable.DoPaintUnusedArea;
  begin
    if ((ComponentState * [csLoading, csDestroying]) <> []) then
      Exit;
    if Assigned(FPaintUnusedArea) then
      FPaintUnusedArea(Self)
    else
      tbDrawUnusedBit;
  end;
{--------}
procedure TOvcCustomTable.DoRowsChanged(RowNum1, RowNum2 : TRowNum;
                                        Action : TOvcTblActions);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FRowsChanged) then
      FRowsChanged(Self, RowNum1, RowNum2, Action);
  end;
{--------}
procedure TOvcCustomTable.DoSizeCellEditor(RowNum   : TRowNum;
                                           ColNum   : TColNum;
                                       var CellRect : TRect;
                                       var CellStyle: TOvcTblEditorStyle);
  begin
    if Assigned(FSizeCellEditor) then
      FSizeCellEditor(Self, RowNum, ColNum, CellRect, CellStyle);
  end;
{--------}
procedure TOvcCustomTable.DoTopLeftCellChanged(RowNum : TRowNum; ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FTopLeftCellChanged) then
      FTopLeftCellChanged(Self, RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.DoTopLeftCellChanging(var RowNum : TRowNum;
                                                var ColNum : TColNum);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FTopLeftCellChanging) then
      FTopLeftCellChanging(Self, RowNum, ColNum);
  end;
{--------}
procedure TOvcCustomTable.DoUserCommand(Cmd : word);
  begin
    if ((ComponentState * [csLoading, csDestroying]) = []) and
       Assigned(FUserCommand) then
      FUserCommand(Self, Cmd);
  end;
{====================================================================}


{==TOvcTable Windows Message handlers================================}
procedure TOvcCustomTable.CMColorChanged(var Msg : TMessage);
  begin
    inherited;
    AllowRedraw := false;
    tbNotifyCellsOfTableChange;
    AllowRedraw := true;
  end;
{--------}
procedure TOvcCustomTable.CMCtl3DChanged(var Msg : TMessage);
  begin
    if (csLoading in ComponentState) or not HandleAllocated then
      Exit;

    if NewStyleControls and (FBorderStyle = bsSingle) then
      RecreateWnd;

    inherited;
  end;
{--------}
procedure TOvcCustomTable.CMDesignHitTest(var Msg : TCMDesignHitTest);
  var
    IsVert     : boolean;
    IsColMove  : boolean;
    OnGridLine : boolean;
  begin
    Msg.Result := 1;
    if (otsDesigning in tbState) then
      begin
        if ((tbState * [otsSizing, otsMoving]) <> []) then
          Exit;
        Msg.Result := 0;
        OnGridLine := tbIsOnGridLine(Msg.Pos.X, Msg.Pos.Y, IsVert);
        if OnGridLine then
          Msg.Result := 1
        else
          Msg.Result := NativeInt(tbIsInMoveArea(Msg.Pos.X, Msg.Pos.Y, IsColMove));
      end;
  end;
{--------}
procedure TOvcCustomTable.CMFontChanged(var Msg : TMessage);
  begin
    inherited;
    AllowRedraw := false;
    tbNotifyCellsOfTableChange;
    AllowRedraw := true;
  end;
{--------}
procedure TOvcCustomTable.ctimQueryOptions(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(word(FOptions));
  end;
{--------}
procedure TOvcCustomTable.ctimQueryColor(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(Color);
  end;
{--------}
procedure TOvcCustomTable.ctimQueryFont(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(Font);
  end;
{--------}
procedure TOvcCustomTable.ctimQueryLockedCols(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(LockedCols);
  end;
{--------}
procedure TOvcCustomTable.ctimQueryLockedRows(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(LockedRows);
  end;
{--------}
procedure TOvcCustomTable.ctimQueryActiveCol(var Msg : TMessage);
  begin
    Msg.Result := NativeInt(ActiveCol);
  end;
{--------}
procedure TOvcCustomTable.ctimQueryActiveRow(var Msg : TMessage);
  begin
    Msg.Result := Integer(ActiveRow);
  end;
{--------}
procedure TOvcCustomTable.ctimRemoveCell(var Msg : TMessage);
  begin
    Notification(TComponent(Msg.LParam), opRemove);
    Msg.Result := 0;
  end;
{--------}
procedure TOvcCustomTable.ctimStartEdit(var Msg : TMessage);
  begin
    if not StartEditingState then
      begin
        AllowRedraw := false;
        InvalidateCell(ActiveRow, ActiveCol);
        AllowRedraw := true;
      end;
    Msg.Result := 1;
  end;
{--------}
procedure TOvcCustomTable.ctimStartEditMouse(var Msg : TWMMouse);
  begin
    if Assigned(tbActCell) and InEditingState then
      if tbActCell.AcceptActivationClick then
        begin
          Windows.SetFocus(tbActCell.EditHandle);
          PostMessage(tbActCell.EditHandle,
                      WM_LBUTTONDOWN,
                      Msg.Keys, Integer(Msg.Pos))
        end;
    Msg.Result := 1;
  end;
{--------}
procedure TOvcCustomTable.ctimStartEditKey(var Msg : TWMKey);
  begin
    if Assigned(tbActCell) and InEditingState then
      begin
        Windows.SetFocus(tbActCell.EditHandle);
        PostMessage(tbActCell.EditHandle, WM_KEYDOWN, Msg.CharCode, Msg.KeyData);
      end;
    Msg.Result := 1;
  end;
{--------}
procedure TOvcCustomTable.ctimLoadDefaultCells(var Msg : TMessage);
  begin
    AllowRedraw := false;
    tbFinishLoadingCellList;
    tbFinishLoadingDefaultCells;
    Msg.Result := 0;
    tbMustFinishLoading := false;
    AllowRedraw := true;
  end;
{--------}
procedure TOvcCustomTable.WMCancelMode(var Msg : TMessage);
  begin
    inherited;
    tbIsKeySelecting := false;
    if (otsMouseSelect in tbState) then
      tbState := tbState - [otsMouseSelect] + [otsNormal];
  end;
{--------}
procedure TOvcCustomTable.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
  begin
    Msg.Result := 1; {no erasing of the background, we'll do it all}
  end;
{--------}
procedure TOvcCustomTable.WMGetDlgCode(var Msg : TMessage);
  begin
    Msg.Result := DLGC_WANTCHARS or DLGC_WANTARROWS;
    if (otoTabToArrow in Options) then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
  end;
{--------}
procedure TOvcCustomTable.WMHScroll(var Msg : TWMScroll);
  {------}
  procedure ProcessThumb;
    var
      i : integer;
      NewLeftCol : TColNum;
    begin
      NewLeftCol := LockedCols;
      for i := 0 to pred(Msg.Pos) do
        NewLeftCol := IncCol(NewLeftCol, 1);
      if (NewLeftCol <> LeftCol) then
        LeftCol := NewLeftCol;
    end;
  {------}
  begin
    {ignore SB_ENDSCROLL and SB_THUMBTRACK messages (the latter
     if required to by the Options property): this'll possibly
     avoid multiple validations}
    if (Msg.ScrollCode = SB_ENDSCROLL) or
       ((Msg.ScrollCode = SB_THUMBTRACK) and
        (not (otoThumbTrack in Options))) then
      begin
        inherited;
        Exit;
      end;
    {if not focused then do so; if being designed update the
     table view}
    if (otsUnfocused in tbState) then
      SetFocus
    else if (otsDesigning in tbState) then
      Update;
    {check to see whether the cell being edited is valid;
     no scrolling allowed if it isn't (tough).}
    if InEditingState then
      begin
        if not tbActCell.CanSaveEditedData(true) then
          Exit;
      end;
    {process the scrollbar message}
    case Msg.ScrollCode of
      SB_LINELEFT      : ProcessScrollBarClick(otsbHorizontal, scLineUp);
      SB_LINERIGHT     : ProcessScrollBarClick(otsbHorizontal, scLineDown);
      SB_PAGELEFT      : ProcessScrollBarClick(otsbHorizontal, scPageUp);
      SB_PAGERIGHT     : ProcessScrollBarClick(otsbHorizontal, scPageDown);
      SB_THUMBPOSITION : ProcessThumb;
      SB_THUMBTRACK    : if (otoThumbTrack in Options) then ProcessThumb;
    else
      inherited;
      Exit;
    end;
    Msg.Result := 0;
  end;
{--------}
procedure TOvcCustomTable.WMKeyDown(var Msg : TWMKey);
  var
    Cmd           : word;
    ShiftFlags    : byte;
  begin
    inherited;

    {If Tab key is being converted to arrow key, do it}
    if (otoTabToArrow in Options) and (Msg.CharCode = VK_TAB) then
      begin
        {get shift value}
        ShiftFlags := GetShiftFlags;
        {convert Tab combination to command}
        if (ShiftFlags = 0) then
          Cmd := ccRight
        else if (ShiftFlags = ss_Shift) then
          Cmd := ccLeft
        else
          Cmd := ccNone;
      end
    {If Enter key is being converted to right arrow, do it.}
    else if (otoEnterToArrow in Options) and (Msg.CharCode = VK_RETURN) then
      begin
        {get shift value}
        ShiftFlags := GetShiftFlags;
        {convert Enter combination to command}
        if (ShiftFlags = 0) then
          Cmd := ccRight
        else
          Cmd := ccNone;
      end
    {Otherwise just translate into a command}
    else
      Cmd := Controller.EntryCommands.TranslateUsing([tbCmdTable^], TMessage(Msg));

    if InEditingState then
      begin
        if (not (otoAlwaysEditing in Options)) and
           ((Cmd = ccTableEdit) or (Msg.CharCode = VK_ESCAPE)) then
          begin
            if not StopEditingState(Msg.CharCode <> VK_ESCAPE) then
              begin
                inherited;
                Exit;
              end;
          end
      end
    else {not editing}
      if (Cmd = ccTableEdit) or
         ((Cmd > ccLastCmd) and (Cmd < ccUserFirst) and
          ((Msg.CharCode = VK_SPACE) or
           ((VK_0 <= Msg.CharCode) and (Msg.CharCode <= VK_DIVIDE)) or
            (Msg.CharCode >= $BA))) then
        begin
          PostMessage(Handle, ctim_StartEdit, 0, 0);
          if (Cmd <> ccTableEdit) then
            PostMessage(Handle, ctim_StartEditKey, Msg.CharCode, Msg.KeyData);
        end;

    tbIsKeySelecting := false;
{
Fix for problem 667935
Hide (draw again) move line whle doing key operations
If the active cell is moved while drag-moving lines or cols the drag insert
line will be corrupted
}
    if (otsMoving in tbState) then
      tbDrawMoveLine;
    case Cmd of
      ccBotOfPage,   ccBotRightCell,
      ccDown,        ccEnd,
      ccFirstPage,   ccHome,
      ccLastPage,    ccLeft,
      ccNextPage,    ccPageLeft,
      ccPageRight,   ccPrevPage,
      ccRight,       ccTopLeftCell,
      ccTopOfPage,   ccUp            : MoveActiveCell(Cmd);
      ccExtendDown   : begin tbIsKeySelecting := true; MoveActiveCell(ccDown);      end;
      ccExtendEnd    : begin tbIsKeySelecting := true; MoveActiveCell(ccEnd);       end;
      ccExtendHome   : begin tbIsKeySelecting := true; MoveActiveCell(ccHome);      end;
      ccExtendLeft   : begin tbIsKeySelecting := true; MoveActiveCell(ccLeft);      end;
      ccExtendPgDn   : begin tbIsKeySelecting := true; MoveActiveCell(ccNextPage);  end;
      ccExtendPgUp   : begin tbIsKeySelecting := true; MoveActiveCell(ccPrevPage);  end;
      ccExtendRight  : begin tbIsKeySelecting := true; MoveActiveCell(ccRight);     end;
      ccExtendUp     : begin tbIsKeySelecting := true; MoveActiveCell(ccUp);        end;
      ccExtBotOfPage : begin tbIsKeySelecting := true; MoveActiveCell(ccBotOfPage); end;
      ccExtFirstPage : begin tbIsKeySelecting := true; MoveActiveCell(ccFirstPage); end;
      ccExtLastPage  : begin tbIsKeySelecting := true; MoveActiveCell(ccLastPage);  end;
      ccExtTopOfPage : begin tbIsKeySelecting := true; MoveActiveCell(ccTopOfPage); end;
      ccExtWordLeft  : begin tbIsKeySelecting := true; MoveActiveCell(ccWordLeft);  end;
      ccExtWordRight : begin tbIsKeySelecting := true; MoveActiveCell(ccWordRight); end;
      ccCopy  : DoClipboardCopy;
      ccCut   : DoClipboardCut;
      ccPaste : DoClipboardPaste;
    else
      if (Cmd >= ccUserFirst) then
        DoUserCommand(Cmd);
    end;
{
Fix for problem 667935
}
    if (otsMoving in tbState) then
      tbDrawMoveLine;
  end;
{--------}
procedure TOvcCustomTable.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;

    if (otsEditing in tbState) then
      begin
        Exit;
      end;

    AllowRedraw := false;
    try
      InvalidateCell(ActiveRow, ActiveCol);
      tbState := tbState - [otsFocused] + [otsUnfocused];
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}
procedure TOvcCustomTable.WMLButtonDblClk(var Msg : TWMMouse);
  var
    Row    : TRowNum;
    Col    : TColNum;
    Region : TOvcTblRegion;
  begin
    inherited;
    if not (otsDesigning in tbState) then
      begin
        Region := CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
        if Region = (otrInMain) then
          begin
//R.K.
            if FActiveCol <> Col then
              ActiveCol := Col;
            if FActiveRow <> Row then
              ActiveRow := Row;
//Ende
            PostMessage(Handle, ctim_StartEdit, Msg.Keys, Integer(Msg.Pos));
            PostMessage(Handle, ctim_StartEditMouse, Msg.Keys, Integer(Msg.Pos));
          end;
      end;
  end;
{--------}
procedure TOvcCustomTable.WMLButtonDown(var Msg : TWMMouse);
  var
    Row : TRowNum;
    Col : TColNum;
    Action : TOvcTblSelectionType;
    Region : TOvcTblRegion;
    R : TRect;
    P : TPoint;
    ShiftKeyDown : boolean;
    CtrlKeyDown  : boolean;
    AllowDrag    : boolean;
    WasUnfocused : boolean;
  begin
    inherited;

    {are we currently unfocused? if so focus the table}
    WasUnfocused := false;
    if (otsUnfocused in tbState) then
      begin
        WasUnfocused := true;
        AllowRedraw := false;
        try
          {note: by the time SetFocus returns WMSetFocus will have been called}
          SetFocus;
          {..to get round an MDI bug..}
          if not Focused then
            Windows.SetFocus(Handle);
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;

    {are we currently showing a sizing cursor? if so the user wants to
     resize a column/row}
    if (otsShowSize in tbState) then
      begin
        tbState := tbState - [otsShowSize] + [otsSizing];
        if (otsDoingRow in tbState) then
          begin
            if (Msg.YPos >= tbRowNums^.Ay[tbSizeIndex].Offset+6) then
              tbSizeOffset := Msg.YPos;
            tbDrawSizeLine;
          end
        else {we're sizing a column}
          begin
            if (Msg.XPos >= tbColNums^.Ay[tbSizeIndex].Offset+6) then
              tbSizeOffset := Msg.XPos;
            tbDrawSizeLine;
          end;
        Exit;
      end;

    {are we currently showing a row/col move cursor? if so the user wants
     to move that row/col}
    if (otsShowMove in tbState) then
      begin
        tbState := tbState - [otsShowMove] + [otsMoving];
        {work out the row/column we're in}
        CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
        if (otsDoingCol in tbState) then begin
          tbMoveIndex := tbFindColInx(Col);
          R.Left := ColOffset[Col];
          R.Right := MinI(ClientWidth, R.Left + Columns[Col].Width);
          R.Top := RowOffset[0];
          R.Bottom := RowOffset[1];
        end else begin{doing row}
          tbMoveIndex := tbFindRowInx(Row);
          R.Top := RowOffset[Row];
          R.Bottom := RowOffset[Row + 1];
          R.Bottom := MinI(ClientHeight, R.Top + Rows[Row].Height);
          R.Left := ColOffset[0];
          R.Right := ColOffset[1];
        end;

        R.TopLeft := ClientToScreen(R.TopLeft);
        R.BottomRight := ClientToScreen(R.BottomRight);

        P := ClientToScreen(Point(Msg.XPos, Msg.YPos));

        tbDrag := TOvcDragShow.Create(P.x, P.y, R, clBtnFace);

        tbMoveIndexTo := tbMoveIndex;
        tbDrawMoveLine;
        Exit;
      end;

    {are we focused and do we allow selections? if so be prepared to start or
     extend the current selection (note that AlwaysEditing will be false)}
    if (otsFocused in tbState) and (not (otoNoSelection in Options)) then
      begin
        {if we are editing a cell then stop editing it now (if possible)}
        if InEditingState then
          begin
            Windows.SetFocus(tbActCell.EditHandle);
          end;
        {get the state of the shift & ctrl keys}
        ShiftKeyDown := (Msg.Keys and MK_SHIFT) <> 0;
        CtrlKeyDown := (Msg.Keys and MK_CONTROL) <> 0;
        {calculate where the mouse button was pressed}
        Region := CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
        case Region of
          otrInMain :
            {the mouse was clicked in the main area}
            begin
              AllowRedraw := false;
              try
                AllowDrag := true;
                {confirm the new active cell}
                DoActiveCellMoving(ccMouse, Row, Col);
                {if neither shift nor control are down, or control is
                 down on its own, we have to reset the anchor point}
                if (not ShiftKeyDown) then
                  begin
                    if CtrlKeyDown then
                      Action := tstAdditional
                    else
                      begin
                        Action := tstDeselectAll;
                        {if the active cell hasn't changed (ie the user
                         clicked on the active cell, must start editing}
                        if (ActiveRow = Row) and (ActiveCol = Col) and
                           not WasUnfocused then
                          begin
                            PostMessage(Handle, ctim_StartEdit, 0, 0);
                            PostMessage(Handle, ctim_StartEditMouse,
                                        Msg.Keys, Integer(Msg.Pos));
                            AllowDrag := false;
                          end;
                      end;
                    tbSetAnchorCell(Row, Col, Action);
                  end
                {if the shift key is down then the user is either extending
                 the last selection only (control is up) or the last
                 selection in addition to the other selections (control is
                 down); extend the selection}
                else {shift key is down}
                  begin
                    if CtrlKeyDown then
                      Action := tstAdditional
                    else
                      begin
                        Action := tstDeselectAll;
                        tbIsSelecting := true;
                      end;
                    tbUpdateSelection(Row, Col, Action);
                  end;
                {now set the active cell}
                tbSetActiveCellPrim(Row, Col);
              finally
                AllowRedraw := true;
              end;{try..finally}
              {until we get a mouse up message we are selecting with
               the mouse (if we're allowed to, that is)}
              if (otoMouseDragSelect in Options) and AllowDrag then
                tbState := tbState - [otsNormal] + [otsMouseSelect];
            end;
          otrInLocked :
            begin
              {the mouse was clicked on a locked cell}
              if InEditingState then
                if not StopEditingState(true) then
                  Exit;
              AllowRedraw := false;
              try
                if (otoRowSelection in Options) and (Row >= LockedRows) then
                  tbSelectRow(Row);
                if (otoColSelection in Options) and (Col >= LockedCols) then
                  tbSelectCol(Col);
                if (otoRowSelection in Options) and (otoColSelection in Options) and
                   (Row < LockedRows) and (Col < LockedCols) then
                  tbSelectTable;
              finally
                AllowRedraw := true;
              end;{try..finally}
              if (otsNormal in tbState) then
                DoLockedCellClick(Row, Col);
            end;
          otrInUnused :
            begin
              {clicking in the unused area deselects all selections}
              if InEditingState then
                if not StopEditingState(true) then
                  Exit;

              {move to new location}
              if (Row = CRCFXY_RowBelow) then
                Row := IncRow(pred(RowLimit), 0);
              if (Col = CRCFXY_ColToRight) then
                Col := IncCol(pred(ColCount), 0);

              {if row or col should changed, notify and doit}
              if (Col <> ActiveCol) or (Row <> ActiveRow) then begin
                DoActiveCellMoving(ccNone, Row, Col);
                tbSetAnchorCell(Row, Col, tstDeselectAll);
                tbSetActiveCellPrim(Row, Col);
              end;
            end;
        end;{case}
        Exit;
      end;

    {are we focused? (and selections are not allowed)}
    if (otsFocused in tbState) then
      if ((tbState * [otsNormal, otsEditing, otsHiddenEdit]) <> []) then
        begin
          Region := CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
          case Region of
            otrInMain :
              begin
                if InEditingState then
                  Windows.SetFocus(tbActCell.EditHandle);
                AllowRedraw := false;
                try
                  DoActiveCellMoving(ccMouse, Row, Col);
                  { 19.04.2011 AB: The tables behavior regarding checkboxes was unsatisfactory:
                    When otoNoSelection in Options and you click on a cell that has already
                    been active, the ctim_StartEditMouse messages was posted twice - resulting
                    in no change of the checkbox' state. }
                  if (not (otoAlwaysEditing in Options)) and (ActiveRow = Row) and (ActiveCol = Col) and (not WasUnfocused) then
                  begin
                    PostMessage(Handle, ctim_StartEdit, 0, 0);
                    PostMessage(Handle, ctim_StartEditMouse, Msg.Keys, Integer(Msg.Pos));
                  end;

                  tbSetActiveCellPrim(Row, Col);
                finally
                  AllowRedraw := true;
                end;
              end;
            otrInLocked :
              if (otsNormal in tbState) then
                DoLockedCellClick(Row, Col);
          end;{case}
          Exit;
        end;
  end;
{--------}
procedure TOvcCustomTable.WMLButtonUp(var Msg : TWMMouse);
  var
    Form    : TForm;
    ColNum  : TColNum;
    ColFrom : TColNum;
    ColTo   : TColNum;
    RowNum  : TRowNum;
    RowFrom : TRowNum;
    RowTo   : TRowNum;
    DoingCol: boolean;
  begin
    inherited;

    if tbDrag <> nil then begin
      tbDrag.Free;
      tbDrag := nil;
    end;

    if (otsMouseSelect in tbState) then
      begin
        {tbIsSelecting := false;}
        tbState := tbState - [otsMouseSelect] + [otsNormal];
        Exit;
      end;

    if (otsSizing in tbState) then
      begin
        tbDrawSizeLine;
        AllowRedraw := false;
        try
          if (otsDoingRow in tbState) then
            begin
              if (tbSizeOffset < tbRowNums^.Ay[tbSizeIndex].Offset+6) then
                tbSizeOffset := tbRowNums^.Ay[tbSizeIndex].Offset+6;
              FRows.Height[tbRowNums^.Ay[tbSizeIndex].Number] :=
                 tbSizeOffset - tbRowNums^.Ay[tbSizeIndex].Offset;
              if Assigned(OnResizeRow) then
                OnResizeRow(Self, tbRowNums^.Ay[tbSizeIndex].Number,
                  FRows.Height[tbRowNums^.Ay[tbSizeIndex].Number]);
            end
          else
            begin
              if (tbSizeOffset < tbColNums^.Ay[tbSizeIndex].Offset+6) then
                tbSizeOffset := tbColNums^.Ay[tbSizeIndex].Offset+6;
              FCols[tbColNums^.Ay[tbSizeIndex].Number].Width :=
                 tbSizeOffset - tbColNums^.Ay[tbSizeIndex].Offset;
              if Assigned(OnResizeColumn) then
                OnResizeColumn(Self, tbColNums^.Ay[tbSizeIndex].Number,
                  FCols[tbColNums^.Ay[tbSizeIndex].Number].Width);
            end;
          tbState := tbState - [otsSizing, otsDoingRow, otsDoingRow] + [otsNormal];
          if (otsDesigning in tbState) then
            begin
              Form := TForm(GetParentForm(Self));
              if (Form <> nil) and (Form.Designer <> nil) then
                Form.Designer.Modified;
            end;
          InvalidateTable;
        finally
          AllowRedraw := true;
        end;{try..finally}
      end;

    if (otsMoving in tbState) then
      begin
        tbDrawMoveLine;
        DoingCol := otsDoingCol in tbState;
        tbState := tbState - [otsMoving, otsDoingRow, otsDoingCol] + [otsNormal];
        if (tbMoveIndex <> tbMoveIndexTo) then
          begin
            AllowRedraw := false;
            try
              if DoingCol then
                begin
                  ColFrom := tbColNums^.Ay[tbMoveIndex].Number;
                  ColTo := tbColNums^.Ay[tbMoveIndexTo].Number;
                  if (ColTo > ColFrom) then
                    for ColNum := ColFrom to pred(ColTo) do
                      Columns.Exchange(ColNum, succ(ColNum))
                  else
                    for ColNum := pred(ColFrom) downto ColTo do
                      Columns.Exchange(ColNum, succ(ColNum));
                  if ActiveCol = ColFrom then
                    ActiveCol := ColTo
                  else if (ColTo > ColFrom) then begin
                    if (ColFrom < ActiveCol) and (ActiveCol <= ColTo) then
                      ActiveCol := IncCol(ActiveCol, -1);
                  end
                  else begin
                    if (ColTo <= ActiveCol) and (ActiveCol < ColFrom) then
                      ActiveCol := IncCol(ActiveCol, +1);
                  end;
                end
              else {doing rows}
                begin
                  RowFrom := tbRowNums^.Ay[tbMoveIndex].Number;
                  RowTo := tbRowNums^.Ay[tbMoveIndexTo].Number;
                  if (RowTo > RowFrom) then
                    for RowNum := RowFrom to pred(RowTo) do
                      Rows.Exchange(RowNum, succ(RowNum))
                  else
                    for RowNum := pred(RowFrom) downto RowTo do
                      Rows.Exchange(RowNum, succ(RowNum));
                  if ActiveRow = RowFrom then
                    ActiveRow := RowTo
                  else if (RowTo > RowFrom) then begin
                    if (RowFrom < ActiveRow) and (ActiveRow <= RowTo) then
                      ActiveRow := IncRow(ActiveRow, -1);
                  end
                  else begin
                    if (RowTo <= ActiveRow) and (ActiveRow < RowFrom) then
                      ActiveRow := IncRow(ActiveRow, +1);
                  end;
                end;
            finally
              AllowRedraw := true;
            end;{try..finally}
            if (otsDesigning in tbState) then
              begin
                Form := TForm(GetParentForm(Self));
                if (Form <> nil) and (Form.Designer <> nil) then
                  Form.Designer.Modified;
              end;
          end;
      end;
  end;
{--------}
procedure TOvcCustomTable.WMMouseMove(var Msg : TWMMouse);
  var
    Row : TRowNum;
    Col : TColNum;
    NewMoveIndexTo  : integer;
    Region : TOvcTblRegion;
    Action : TOvcTblSelectionType;
    P : TPoint;
  begin
    inherited;

    if tbDrag <> nil then begin
      P := ClientToScreen(Point(Msg.XPos, Msg.YPos));
      tbDrag.DragMove(P.x, P.y);
    end;

    if (otsMouseSelect in tbState) then
      begin
        Region := CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
        if (Region = otrOutside) or (Region = otrInUnused) then
          begin
            if (Row = CRCFXY_RowAbove) then
              Row := IncRow(ActiveRow, -1)
            else if (Row = CRCFXY_RowBelow) then
              with tbRowNums^ do
                Row := MinL(pred(RowLimit), succ(Ay[pred(Count)].Number));
            if (Col = CRCFXY_ColToLeft) then
              Col := IncCol(ActiveCol, -1)
            else if (Col = CRCFXY_ColToRight) then
              with tbColNums^ do
                Col := MinI(pred(ColCount), succ(Ay[pred(Count)].Number));
          end
        else if (Region = otrInLocked) then
          begin
            if (Row < LockedRows) then
              Row := IncRow(ActiveRow, -1);
            if (Col < LockedCols) then
              Col := IncCol(ActiveCol, -1);
          end;
        DoActiveCellMoving(ccMouse, Row, Col);
        if (Row = ActiveRow) and (Col = ActiveCol) then
          Exit; {there's nothing to do, just moved within cell}
        if ((Msg.Keys and MK_CONTROL) <> 0) then
          Action := tstAdditional
        else
          begin
            Action := tstDeselectAll;
            tbIsSelecting := true;
          end;
        AllowRedraw := false;
        try
          tbUpdateSelection(Row, Col, Action);
          tbSetActiveCellPrim(Row, Col);
        finally
          AllowRedraw := true;
        end;{try..finally}
        Exit;
      end;

    if (otsSizing in tbState) then
      begin
        tbDrawSizeLine;
        if (otsDoingRow in tbState) then
          begin
            if (Msg.YPos >= tbRowNums^.Ay[tbSizeIndex].Offset+6) then
              tbSizeOffset := Msg.YPos;
          end
        else
          begin
            if (Msg.XPos >= tbColNums^.Ay[tbSizeIndex].Offset+6) then
              tbSizeOffset := Msg.XPos;
          end;
        tbDrawSizeLine;
        Exit;
      end;

    if (otsMoving in tbState) then
      begin
        CalcRowColFromXY(Msg.XPos, Msg.YPos, Row, Col);
        if (otsDoingCol in tbState) then
          begin
            if (Col >= LockedCols) then
              begin
                NewMoveIndexTo := tbFindColInx(Col);
                if (NewMoveIndexTo <> tbMoveIndexTo) then
                  begin
                    tbDrawMoveLine;
                    tbMoveIndexTo := NewMoveIndexTo;
                    tbDrawMoveLine;
                  end;
              end;
          end
        else {we're moving rows}
          begin
            if (Row >= LockedRows) then
              begin
                NewMoveIndexTo := tbFindRowInx(Row);
                if (NewMoveIndexTo <> tbMoveIndexTo) then
                  begin
                    tbDrawMoveLine;
                    tbMoveIndexTo := NewMoveIndexTo;
                    tbDrawMoveLine;
                  end;
              end;
          end;
      end;
  end;
{--------}
procedure TOvcCustomTable.WMNCHitTest(var Msg : TMessage);
  begin
    if (otsDesigning in tbState) then
      DefaultHandler(Msg)
    else
      inherited;
  end;
{--------}
procedure TOvcCustomTable.WMSetCursor(var Msg : TWMSetCursor);
  var
    CurMousePos  : TPoint;
    NewCursor    : HCursor;
    IsVert       : boolean;
    IsColMove    : boolean;
    OnGridLine   : boolean;
    InMoveArea   : boolean;
  begin
    {ignore non client hit tests, let our ancestor deal with it}
    if (Msg.HitTest <> HTCLIENT) then
      begin
        inherited;
        if ((tbState * [otsShowSize, otsShowMove]) <> []) then
          tbState := tbState - [otsShowSize, otsShowMove, otsDoingRow, otsDoingCol]
                             + [otsNormal];
        Exit;
      end;

    {if the table is unfocused or we are editing, let our ancestor deal with it}
    if (otsUnfocused in tbState) or InEditingState then
      begin
        inherited;
        Exit;
      end;

    {get the mouse cursor position in terms of the table client area}
    GetCursorPos(CurMousePos);
    CurMousePos := ScreenToClient(CurMousePos);
    {work out whether the cursor is over a grid line or on the column
     move area; take into account whether such definitions are allowed}
    OnGridLine := tbIsOnGridLine(CurMousePos.X, CurMousePos.Y, IsVert);
    if OnGridLine then
      if IsVert then
        OnGridLine := (not (otoNoColResizing in Options)) or
                      (otsDesigning in tbState)
      else
        OnGridLine := (not (otoNoRowResizing in Options)) or
                      (otsDesigning in tbState);
    InMoveArea := false;
    if (not OnGridLine) and
       ((otoAllowColMoves in Options) or (otoAllowRowMoves in Options) or
        (otsDesigning in tbState)) then
      begin
        InMoveArea := tbIsInMoveArea(CurMousePos.X, CurMousePos.Y, IsColMove);
        if InMoveArea then
          if IsColMove then
            InMoveArea := otoAllowColMoves in Options
          else
            InMoveArea := otoAllowRowMoves in Options;
      end;
    {now set the cursor}
    if InMoveArea then
      begin
        if IsColMove then
          begin
            NewCursor := tbColMoveCursor;
            tbState := tbState - [otsNormal, otsShowSize, otsDoingRow]
                               + [otsShowMove, otsDoingCol];
          end
        else {row move}
          begin
            NewCursor := tbRowMoveCursor;
            tbState := tbState - [otsNormal, otsShowSize, otsDoingCol]
                               + [otsShowMove, otsDoingRow];
          end;
      end
    else if OnGridLine then
      if IsVert then
        begin
          NewCursor := Screen.Cursors[crHSplit];
          tbState := tbState - [otsNormal, otsShowMove, otsDoingRow]
                             + [otsShowSize, otsDoingCol];
        end
      else
        begin
          NewCursor := Screen.Cursors[crVSplit];
          tbState := tbState - [otsNormal, otsShowMove, otsDoingCol]
                             + [otsShowSize, otsDoingRow];
        end
    else
      begin
        NewCursor := Screen.Cursors[Cursor];
        tbState := tbState - [otsShowMove, otsShowSize, otsDoingRow, otsDoingCol]
                           + [otsNormal];
      end;
    SetCursor(NewCursor);

    Msg.Result := 1;
  end;
{--------}
procedure TOvcCustomTable.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;

    if (otsEditing in tbState) then
      begin
        if tbEditCellHasFocus(Msg.FocusedWnd) then
          GetParentForm(Self).Perform(WM_NEXTDLGCTL, 1, 0)
        else
          Windows.SetFocus(tbActCell.EditHandle);
        Exit;
      end;

    if (otsFocused in tbState) then
      Exit;

    AllowRedraw := false;
    try
      InvalidateCell(ActiveRow, ActiveCol);
      tbState := tbState - [otsUnfocused] + [otsFocused];
    finally
      AllowRedraw := true;
    end;{try..finally}
  end;
{--------}

procedure TOvcCustomTable.WMVScroll(var Msg : TWMScroll);

  procedure ProcessThumb;
    var
      Divisor : Integer;
    begin
      if (Msg.Pos <> TopRow) then
        begin
          if RowLimit < (16*1024) then
            TopRow := Msg.Pos
          else if Msg.Pos = LockedRows then
            TopRow := LockedRows
          else begin
            if (RowLimit > (16*1024)) then
              Divisor := Succ(RowLimit div $400)
            else
              Divisor := Succ(RowLimit div $40);
            if (Msg.Pos = RowLimit div Divisor) then
              TopRow := pred(RowLimit)
            else
              TopRow := Msg.Pos * Divisor;
          end;
        end;
    end;

begin
  if ProcessingVScrollMessage then
    Exit;
  ProcessingVScrollMessage := true;
  try
    {ignore SB_ENDSCROLL and SB_THUMBTRACK messages (the latter
     if required to by the Options property): this'll possibly
     avoid multiple validations}
    if (Msg.ScrollCode = SB_ENDSCROLL) or
       ((Msg.ScrollCode = SB_THUMBTRACK) and
        (not (otoThumbTrack in Options))) then
      begin
        inherited;
        Exit;
      end;
    {if we're not focused then do so; if we're being designed
     update the table view}
    if (otsUnFocused in tbState) then
      SetFocus
    else if (otsDesigning in tbState) then
      Update;
    {check to see whether the cell being edited is valid;
     no scrolling allowed if it isn't (tough).}
    if InEditingState then
      begin
        if not tbActCell.CanSaveEditedData(true) then
          Exit;
      end;
    {process the scrollbar message}
    case Msg.ScrollCode of
      SB_LINEUP        : ProcessScrollBarClick(otsbVertical, scLineUp);
      SB_LINEDOWN      : ProcessScrollBarClick(otsbVertical, scLineDown);
      SB_PAGEUP        : ProcessScrollBarClick(otsbVertical, scPageUp);
      SB_PAGEDOWN      : ProcessScrollBarClick(otsbVertical, scPageDown);
      SB_THUMBPOSITION : ProcessThumb;
      SB_THUMBTRACK    : if (otoThumbTrack in Options) then ProcessThumb;
    else
      inherited;
      Exit;
    end;
    Msg.Result := 0;
  finally
    ProcessingVScrollMessage := false;
  end;
end;
{====================================================================}


end.

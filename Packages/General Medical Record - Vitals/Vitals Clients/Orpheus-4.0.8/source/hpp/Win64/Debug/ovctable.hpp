// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctable.pas' rev: 29.00 (Windows)

#ifndef OvctableHPP
#define OvctableHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Dialogs.hpp>
#include <ovcmisc.hpp>
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovctcmmn.hpp>
#include <ovctcary.hpp>
#include <ovctsell.hpp>
#include <ovctcell.hpp>
#include <ovctchdr.hpp>
#include <ovctgpns.hpp>
#include <ovctbclr.hpp>
#include <ovctbrws.hpp>
#include <ovctbcls.hpp>
#include <ovcdrag.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctable
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomTable;
class DELPHICLASS TOvcTable;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomTable : public Ovctcmmn::TOvcTableAncestor
{
	typedef Ovctcmmn::TOvcTableAncestor inherited;
	
protected:
	int FActiveCol;
	int FActiveRow;
	int FBlockColBegin;
	int FBlockColEnd;
	int FBlockRowBegin;
	int FBlockRowEnd;
	Ovctcell::TOvcTableCells* FCells;
	Ovctbclr::TOvcTableColors* FColors;
	Ovctbcls::TOvcTableColumns* FCols;
	Ovctgpns::TOvcGridPenSet* FGridPenSet;
	int FLeftCol;
	int FLockedCols;
	int FLockedRows;
	Ovctcell::TOvcBaseTableCell* FLockedRowsCell;
	Ovctbrws::TOvcTableRows* FRows;
	int FSelAnchorCol;
	int FSelAnchorRow;
	int FTopRow;
	System::Uitypes::TColor FColorUnused;
	bool FOldRowColBehavior;
	Ovctcmmn::TOvcTblAccess FAccess;
	Ovctcmmn::TOvcTblAdjust FAdjust;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Ovctcmmn::TOvcTblOptionSet FOptions;
	System::Uitypes::TScrollStyle FScrollBars;
	System::Byte Filler;
	Ovctcmmn::TCellNotifyEvent FActiveCellChanged;
	Ovctcmmn::TCellMoveNotifyEvent FActiveCellMoving;
	Ovctcmmn::TCellBeginEditNotifyEvent FBeginEdit;
	System::Classes::TNotifyEvent FClipboardCopy;
	System::Classes::TNotifyEvent FClipboardCut;
	System::Classes::TNotifyEvent FClipboardPaste;
	Ovctcmmn::TColChangeNotifyEvent FColumnsChanged;
	Ovctcmmn::TCellNotifyEvent FDoneEdit;
	Ovctcmmn::TCellEndEditNotifyEvent FEndEdit;
	Ovctcmmn::TColNotifyEvent FEnteringColumn;
	Ovctcmmn::TRowNotifyEvent FEnteringRow;
	Ovctcmmn::TCellDataNotifyEvent FGetCellData;
	Ovctcmmn::TCellAttrNotifyEvent FGetCellAttributes;
	Ovctcmmn::TColNotifyEvent FLeavingColumn;
	Ovctcmmn::TRowNotifyEvent FLeavingRow;
	Ovctcmmn::TCellNotifyEvent FLockedCellClick;
	System::Classes::TNotifyEvent FPaintUnusedArea;
	Ovctcmmn::TRowChangeNotifyEvent FRowsChanged;
	Ovctcmmn::TSizeCellEditorNotifyEvent FSizeCellEditor;
	Ovctcmmn::TCellNotifyEvent FTopLeftCellChanged;
	Ovctcmmn::TCellChangeNotifyEvent FTopLeftCellChanging;
	Ovccmd::TUserCommandEvent FUserCommand;
	Ovctcmmn::TColResizeEvent FOnResizeColumn;
	Ovctcmmn::TRowResizeEvent FOnResizeRow;
	Ovctcmmn::TRowAttrNotifyEvent FOnGetRowAttributes;
	Ovctcmmn::TOvcTblDisplayArray *tbColNums;
	Ovctcmmn::TOvcTblDisplayArray *tbRowNums;
	int tbRowsOnLastPage;
	int tbLastTopRow;
	int tbColsOnLastPage;
	int tbLastLeftCol;
	int tbLockCount;
	System::UnicodeString *tbCmdTable;
	Ovctcmmn::TOvcTblStates tbState;
	int tbSizeOffset;
	int tbSizeIndex;
	int tbMoveIndex;
	int tbMoveIndexTo;
	int tbLastEntRow;
	int tbLastEntCol;
	Ovctcell::TOvcBaseTableCell* tbActCell;
	Ovctcary::TOvcCellArray* tbInvCells;
	Ovctsell::TOvcSelectionList* tbSelList;
	Vcl::Graphics::TFont* tbCellAttrFont;
	HICON tbColMoveCursor;
	HICON tbRowMoveCursor;
	int tbHSBarPosCount;
	Ovcdrag::TOvcDragShow* tbDrag;
	bool tbHasHSBar;
	bool tbHasVSBar;
	bool tbUpdateSBs;
	bool tbIsSelecting;
	bool tbIsDeselecting;
	bool tbIsKeySelecting;
	bool tbMustUpdate;
	bool tbMustFinishLoading;
	bool ProcessingVScrollMessage;
	bool FHasBorderWidth;
	bool __fastcall GetAllowRedraw(void);
	int __fastcall GetColCount(void);
	int __fastcall GetColOffset(int ColNum);
	int __fastcall GetRowLimit(void);
	int __fastcall GetRowOffset(int RowNum);
	void __fastcall SetAccess(Ovctcmmn::TOvcTblAccess A);
	void __fastcall SetActiveCol(int ColNum);
	virtual void __fastcall SetActiveRow(int RowNum);
	void __fastcall SetAdjust(Ovctcmmn::TOvcTblAdjust A);
	void __fastcall SetAllowRedraw(bool AR);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle BS);
	void __fastcall SetBlockAccess(Ovctcmmn::TOvcTblAccess A);
	void __fastcall SetBlockAdjust(Ovctcmmn::TOvcTblAdjust A);
	void __fastcall SetBlockCell(Ovctcell::TOvcBaseTableCell* C);
	void __fastcall SetBlockColBegin(int ColNum);
	void __fastcall SetBlockColEnd(int ColNum);
	void __fastcall SetBlockColor(System::Uitypes::TColor C);
	void __fastcall SetBlockFont(Vcl::Graphics::TFont* F);
	void __fastcall SetBlockRowBegin(int RowNum);
	void __fastcall SetBlockRowEnd(int RowNum);
	void __fastcall SetColors(Ovctbclr::TOvcTableColors* C);
	void __fastcall SetColCount(int CC);
	void __fastcall SetCols(Ovctbcls::TOvcTableColumns* CS);
	void __fastcall SetLeftCol(int ColNum);
	void __fastcall SetLockedCols(int ColNum);
	void __fastcall SetLockedRows(int RowNum);
	void __fastcall SetLockedRowsCell(Ovctcell::TOvcBaseTableCell* C);
	void __fastcall SetOptions(Ovctcmmn::TOvcTblOptionSet O);
	void __fastcall SetPaintUnusedArea(System::Classes::TNotifyEvent PUA);
	void __fastcall SetRowLimit(int RowNum);
	void __fastcall SetRows(Ovctbrws::TOvcTableRows* RS);
	void __fastcall SetScrollBars(const System::Uitypes::TScrollStyle SB);
	void __fastcall SetTopRow(int RowNum);
	void __fastcall SetColorUnused(System::Uitypes::TColor CU);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	bool __fastcall tbCalcActiveCellRect(System::Types::TRect &ACR);
	int __fastcall tbCalcCellsFromRect(const System::Types::TRect &UR, System::Types::TRect &GR);
	void __fastcall tbCalcColData(Ovctcmmn::POvcTblDisplayArray &CD, int NewLeftCol);
	void __fastcall tbCalcColsOnLastPage(void);
	void __fastcall tbCalcHSBarPosCount(void);
	bool __fastcall tbCalcRequiresVSBar(void);
	void __fastcall tbCalcRowData(Ovctcmmn::POvcTblDisplayArray &RD, int NewTopRow);
	void __fastcall tbCalcRowsOnLastPage(void);
	void __fastcall tbDrawActiveCell(void);
	void __fastcall tbDrawCells(int RowInxStart, int RowInxEnd, int ColInxStart, int ColInxEnd);
	void __fastcall tbDrawInvalidCells(Ovctcary::TOvcCellArray* InvCells);
	void __fastcall tbDrawMoveLine(void);
	void __fastcall tbDrawRow(int RowInx, int ColInxStart, int ColInxEnd);
	void __fastcall tbDrawSizeLine(void);
	void __fastcall tbDrawUnusedBit(void);
	void __fastcall tbDrawCellBorder(int RowInx, int ColInx, const Ovctcmmn::TOvcCellAttributes &CellAttr);
	void __fastcall tbDrawCellBorders(int RowInxStart, int RowInxEnd, int ColInxStart, int ColInxEnd);
	void __fastcall tbDrawRowBorder(int RowInx, const Ovctcmmn::TOvcRowAttributes &RowAttr);
	void __fastcall tbDrawRowBorders(int RowInxStart, int RowInxEnd);
	bool __fastcall tbEditCellHasFocus(HWND FocusHandle);
	void __fastcall tbEnsureColumnIsVisible(int ColNum);
	void __fastcall tbEnsureRowIsVisible(int RowNum);
	Ovctcell::TOvcBaseTableCell* __fastcall tbFindCell(int RowNum, int ColNum);
	int __fastcall tbFindColInx(int ColNum);
	int __fastcall tbFindRowInx(int RowNum);
	bool __fastcall tbIsOnGridLine(int MouseX, int MouseY, bool &VerticalGrid);
	bool __fastcall tbIsInMoveArea(int MouseX, int MouseY, bool &IsColMove);
	void __fastcall tbSetActiveCellWithSel(int RowNum, int ColNum);
	void __fastcall tbSetActiveCellPrim(int RowNum, int ColNum);
	void __fastcall tbDeselectAll(Ovctcary::TOvcCellArray* CA);
	bool __fastcall tbDeselectAllIterator(int RowNum1, int ColNum1, int RowNum2, int ColNum2, void * ExtraData);
	void __fastcall tbSelectCol(int ColNum);
	void __fastcall tbSelectRow(int RowNum);
	void __fastcall tbSelectTable(void);
	void __fastcall tbSetAnchorCell(int RowNum, int ColNum, Ovctcmmn::TOvcTblSelectionType Action);
	void __fastcall tbUpdateSelection(int RowNum, int ColNum, Ovctcmmn::TOvcTblSelectionType Action);
	virtual void __fastcall DoActiveCellChanged(int RowNum, int ColNum);
	virtual void __fastcall DoActiveCellMoving(System::Word Command, int &RowNum, int &ColNum);
	virtual void __fastcall DoBeginEdit(int RowNum, int ColNum, bool &AllowIt);
	virtual void __fastcall DoClipboardCopy(void);
	virtual void __fastcall DoClipboardCut(void);
	virtual void __fastcall DoClipboardPaste(void);
	virtual void __fastcall DoColumnsChanged(int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action);
	virtual void __fastcall DoDoneEdit(int RowNum, int ColNum);
	virtual void __fastcall DoEndEdit(Ovctcell::TOvcBaseTableCell* Cell, int RowNum, int ColNum, bool &AllowIt);
	virtual void __fastcall DoEnteringColumn(int ColNum);
	virtual void __fastcall DoEnteringRow(int RowNum);
	virtual void __fastcall DoGetCellAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
	virtual void __fastcall DoGetRowAttributes(int RowNum, Ovctcmmn::TOvcRowAttributes &CellAttr);
	virtual void __fastcall DoGetCellData(int RowNum, int ColNum, void * &Data, Ovctcmmn::TOvcCellDataPurpose Purpose);
	virtual void __fastcall DoLeavingColumn(int ColNum);
	virtual void __fastcall DoLeavingRow(int RowNum);
	virtual void __fastcall DoLockedCellClick(int RowNum, int ColNum);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	virtual void __fastcall DoPaintUnusedArea(void);
	virtual void __fastcall DoRowsChanged(int RowNum1, int RowNum2, Ovctcmmn::TOvcTblActions Action);
	virtual void __fastcall DoSizeCellEditor(int RowNum, int ColNum, System::Types::TRect &CellRect, Ovctcmmn::TOvcTblEditorStyle &CellStyle);
	virtual void __fastcall DoTopLeftCellChanged(int RowNum, int ColNum);
	virtual void __fastcall DoTopLeftCellChanging(int &RowNum, int &ColNum);
	virtual void __fastcall DoUserCommand(System::Word Cmd);
	bool __fastcall tbIsColHidden(int ColNum);
	bool __fastcall tbIsColShowRightLine(int ColNum);
	bool __fastcall tbIsRowHidden(int RowNum);
	void __fastcall tbQueryColData(int ColNum, int &W, Ovctcmmn::TOvcTblAccess &A, bool &H);
	void __fastcall tbQueryRowData(int RowNum, int &Ht, bool &H);
	void __fastcall tbInvalidateColHdgPrim(int ColNum, Ovctcary::TOvcCellArray* InvCells);
	void __fastcall tbInvalidateRowHdgPrim(int RowNum, Ovctcary::TOvcCellArray* InvCells);
	void __fastcall tbSetScrollPos(Ovctcmmn::TOvcScrollBar SB);
	void __fastcall tbSetScrollRange(Ovctcmmn::TOvcScrollBar SB);
	void __fastcall tbMoveActCellBotOfPage(void);
	void __fastcall tbMoveActCellBotRight(void);
	void __fastcall tbMoveActCellDown(void);
	void __fastcall tbMoveActCellFirstCol(void);
	void __fastcall tbMoveActCellFirstRow(void);
	void __fastcall tbMoveActCellLastCol(void);
	void __fastcall tbMoveActCellLastRow(void);
	void __fastcall tbMoveActCellLeft(void);
	void __fastcall tbMoveActCellPageDown(void);
	void __fastcall tbMoveActCellPageLeft(void);
	void __fastcall tbMoveActCellPageRight(void);
	void __fastcall tbMoveActCellPageUp(void);
	void __fastcall tbMoveActCellRight(void);
	void __fastcall tbMoveActCellTopLeft(void);
	void __fastcall tbMoveActCellTopOfPage(void);
	void __fastcall tbMoveActCellUp(void);
	void __fastcall tbScrollBarDown(void);
	void __fastcall tbScrollBarLeft(void);
	void __fastcall tbScrollBarPageDown(void);
	void __fastcall tbScrollBarPageLeft(void);
	void __fastcall tbScrollBarPageRight(void);
	void __fastcall tbScrollBarPageUp(void);
	void __fastcall tbScrollBarRight(void);
	void __fastcall tbScrollBarUp(void);
	void __fastcall tbScrollTableLeft(int NewLeftCol);
	void __fastcall tbScrollTableRight(int NewLeftCol);
	void __fastcall tbScrollTableUp(int NewTopRow);
	void __fastcall tbScrollTableDown(int NewTopRow);
	virtual void __fastcall tbCellChanged(System::TObject* Sender);
	void __fastcall tbColChanged(System::TObject* Sender, int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action);
	void __fastcall tbGridPenChanged(System::TObject* Sender);
	void __fastcall tbRowChanged(System::TObject* Sender, int RowNum1, int RowNum2, Ovctcmmn::TOvcTblActions Action);
	void __fastcall tbColorsChanged(System::TObject* Sender);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall tbFinishLoadingDefaultCells(void);
	void __fastcall tbReadColData(System::Classes::TReader* Reader);
	void __fastcall tbReadRowData(System::Classes::TReader* Reader);
	void __fastcall tbWriteColData(System::Classes::TWriter* Writer);
	void __fastcall tbWriteRowData(System::Classes::TWriter* Writer);
	MESSAGE void __fastcall ctimLoadDefaultCells(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryOptions(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryColor(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryFont(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryLockedCols(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryLockedRows(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryActiveCol(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryActiveRow(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimRemoveCell(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimStartEdit(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimStartEditMouse(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall ctimStartEditKey(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	__property bool AllowRedraw = {read=GetAllowRedraw, write=SetAllowRedraw, stored=false, nodefault};
	__property Ovctcmmn::TOvcTblAccess BlockAccess = {write=SetBlockAccess, nodefault};
	__property Ovctcmmn::TOvcTblAdjust BlockAdjust = {write=SetBlockAdjust, nodefault};
	__property int BlockColBegin = {read=FBlockColBegin, write=SetBlockColBegin, nodefault};
	__property int BlockColEnd = {read=FBlockColEnd, write=SetBlockColEnd, nodefault};
	__property System::Uitypes::TColor BlockColor = {write=SetBlockColor, nodefault};
	__property Ovctcell::TOvcBaseTableCell* BlockCell = {write=SetBlockCell};
	__property Vcl::Graphics::TFont* BlockFont = {write=SetBlockFont};
	__property int BlockRowBegin = {read=FBlockRowBegin, write=SetBlockRowBegin, nodefault};
	__property int BlockRowEnd = {read=FBlockRowEnd, write=SetBlockRowEnd, nodefault};
	__property int ColOffset[int ColNum] = {read=GetColOffset};
	__property int RowOffset[int RowNum] = {read=GetRowOffset};
	__property Ovctcmmn::TOvcTblStates TableState = {read=tbState, nodefault};
	__property Ovctcmmn::TOvcTblAccess Access = {read=FAccess, write=SetAccess, nodefault};
	__property int ActiveCol = {read=FActiveCol, write=SetActiveCol, nodefault};
	__property int ActiveRow = {read=FActiveRow, write=SetActiveRow, nodefault};
	__property Ovctcmmn::TOvcTblAdjust Adjust = {read=FAdjust, write=SetAdjust, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property int ColCount = {read=GetColCount, write=SetColCount, nodefault};
	__property Ovctbclr::TOvcTableColors* Colors = {read=FColors, write=SetColors};
	__property System::Uitypes::TColor ColorUnused = {read=FColorUnused, write=SetColorUnused, nodefault};
	__property Ovctbcls::TOvcTableColumns* Columns = {read=FCols, write=SetCols};
	__property Ovctgpns::TOvcGridPenSet* GridPenSet = {read=FGridPenSet, write=FGridPenSet};
	__property int LeftCol = {read=FLeftCol, write=SetLeftCol, nodefault};
	__property int LockedCols = {read=FLockedCols, write=SetLockedCols, nodefault};
	__property int LockedRows = {read=FLockedRows, write=SetLockedRows, nodefault};
	__property Ovctcell::TOvcBaseTableCell* LockedRowsCell = {read=FLockedRowsCell, write=SetLockedRowsCell};
	__property bool OldRowColBehavior = {read=FOldRowColBehavior, write=FOldRowColBehavior, nodefault};
	__property Ovctcmmn::TOvcTblOptionSet Options = {read=FOptions, write=SetOptions, nodefault};
	__property int RowLimit = {read=GetRowLimit, write=SetRowLimit, nodefault};
	__property Ovctbrws::TOvcTableRows* Rows = {read=FRows, write=SetRows};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, nodefault};
	__property int TopRow = {read=FTopRow, write=SetTopRow, nodefault};
	__property Ovctcmmn::TCellNotifyEvent OnActiveCellChanged = {read=FActiveCellChanged, write=FActiveCellChanged};
	__property Ovctcmmn::TCellMoveNotifyEvent OnActiveCellMoving = {read=FActiveCellMoving, write=FActiveCellMoving};
	__property Ovctcmmn::TCellBeginEditNotifyEvent OnBeginEdit = {read=FBeginEdit, write=FBeginEdit};
	__property System::Classes::TNotifyEvent OnClipboardCopy = {read=FClipboardCopy, write=FClipboardCopy};
	__property System::Classes::TNotifyEvent OnClipboardCut = {read=FClipboardCut, write=FClipboardCut};
	__property System::Classes::TNotifyEvent OnClipboardPaste = {read=FClipboardPaste, write=FClipboardPaste};
	__property Ovctcmmn::TColChangeNotifyEvent OnColumnsChanged = {read=FColumnsChanged, write=FColumnsChanged};
	__property Ovctcmmn::TCellNotifyEvent OnDoneEdit = {read=FDoneEdit, write=FDoneEdit};
	__property Ovctcmmn::TCellEndEditNotifyEvent OnEndEdit = {read=FEndEdit, write=FEndEdit};
	__property Ovctcmmn::TColNotifyEvent OnEnteringColumn = {read=FEnteringColumn, write=FEnteringColumn};
	__property Ovctcmmn::TRowNotifyEvent OnEnteringRow = {read=FEnteringRow, write=FEnteringRow};
	__property Ovctcmmn::TCellDataNotifyEvent OnGetCellData = {read=FGetCellData, write=FGetCellData};
	__property Ovctcmmn::TCellAttrNotifyEvent OnGetCellAttributes = {read=FGetCellAttributes, write=FGetCellAttributes};
	__property Ovctcmmn::TRowAttrNotifyEvent OnGetRowAttributes = {read=FOnGetRowAttributes, write=FOnGetRowAttributes};
	__property Ovctcmmn::TColNotifyEvent OnLeavingColumn = {read=FLeavingColumn, write=FLeavingColumn};
	__property Ovctcmmn::TRowNotifyEvent OnLeavingRow = {read=FLeavingRow, write=FLeavingRow};
	__property Ovctcmmn::TCellNotifyEvent OnLockedCellClick = {read=FLockedCellClick, write=FLockedCellClick};
	__property System::Classes::TNotifyEvent OnPaintUnusedArea = {read=FPaintUnusedArea, write=SetPaintUnusedArea};
	__property Ovctcmmn::TColResizeEvent OnResizeColumn = {read=FOnResizeColumn, write=FOnResizeColumn};
	__property Ovctcmmn::TRowResizeEvent OnResizeRow = {read=FOnResizeRow, write=FOnResizeRow};
	__property Ovctcmmn::TRowChangeNotifyEvent OnRowsChanged = {read=FRowsChanged, write=FRowsChanged};
	__property Ovctcmmn::TSizeCellEditorNotifyEvent OnSizeCellEditor = {read=FSizeCellEditor, write=FSizeCellEditor};
	__property Ovctcmmn::TCellNotifyEvent OnTopLeftCellChanged = {read=FTopLeftCellChanged, write=FTopLeftCellChanged};
	__property Ovctcmmn::TCellChangeNotifyEvent OnTopLeftCellChanging = {read=FTopLeftCellChanging, write=FTopLeftCellChanging};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FUserCommand, write=FUserCommand};
	
public:
	__fastcall virtual TOvcCustomTable(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomTable(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	Ovctcmmn::TOvcTblRegion __fastcall CalcRowColFromXY(int X, int Y, int &RowNum, int &ColNum);
	virtual Ovctcmmn::TOvcTblKeyNeeds __fastcall FilterKey(Winapi::Messages::TWMKey &Msg);
	void __fastcall GetDisplayedColNums(Ovctcmmn::TOvcTableNumberArray &NA);
	void __fastcall GetDisplayedRowNums(Ovctcmmn::TOvcTableNumberArray &NA);
	virtual void __fastcall ResolveCellAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
	void __fastcall ResolveRowAttributes(int RowNum, Ovctcmmn::TOvcRowAttributes &RowAttr);
	void __fastcall SetActiveCell(int RowNum, int ColNum);
	void __fastcall SetTopLeftCell(int RowNum, int ColNum);
	int __fastcall IncCol(int ColNum, int Direction);
	int __fastcall IncRow(int RowNum, int Direction);
	void __fastcall InvalidateCell(int RowNum, int ColNum);
	void __fastcall InvalidateColumn(int ColNum);
	void __fastcall InvalidateRow(int RowNum);
	void __fastcall InvalidateTable(void);
	void __fastcall InvalidateCellsInRect(const System::Types::TRect &R);
	void __fastcall InvalidateColumnHeading(int ColNum);
	void __fastcall InvalidateRowHeading(int RowNum);
	void __fastcall InvalidateTableNotLockedCols(void);
	void __fastcall InvalidateTableNotLockedRows(void);
	bool __fastcall HaveSelection(void);
	bool __fastcall InSelection(int RowNum, int ColNum);
	void __fastcall IterateSelections(Ovctcmmn::TSelectionIterator SI, void * ExtraData);
	bool __fastcall InEditingState(void);
	bool __fastcall SaveEditedData(void);
	bool __fastcall StartEditingState(void);
	bool __fastcall StopEditingState(bool SaveValue);
	virtual void __fastcall ProcessScrollBarClick(Ovctcmmn::TOvcScrollBar ScrollBar, System::Uitypes::TScrollCode ScrollCode);
	virtual void __fastcall MoveActiveCell(System::Word Command);
	__property Ovctcell::TOvcTableCells* Cells = {read=FCells};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomTable(HWND ParentWindow) : Ovctcmmn::TOvcTableAncestor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTable : public TOvcCustomTable
{
	typedef TOvcCustomTable inherited;
	
public:
	__property AllowRedraw;
	__property BlockAccess;
	__property BlockAdjust;
	__property BlockColBegin;
	__property BlockColEnd;
	__property BlockColor;
	__property BlockCell;
	__property BlockFont;
	__property BlockRowBegin;
	__property BlockRowEnd;
	__property Canvas;
	__property ColOffset;
	__property RowOffset;
	__property TableState;
	
__published:
	__property LockedRows = {default=1};
	__property TopRow = {default=1};
	__property ActiveRow = {default=1};
	__property RowLimit = {default=10};
	__property LockedCols = {default=1};
	__property LeftCol = {default=1};
	__property ActiveCol = {default=1};
	__property OldRowColBehavior = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Access = {default=1};
	__property Adjust = {default=4};
	__property Align = {default=0};
	__property BorderStyle = {default=1};
	__property ColCount = {stored=false};
	__property Color = {default=-16777201};
	__property ColorUnused = {default=-16777211};
	__property Colors;
	__property Columns;
	__property Controller;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property GridPenSet;
	__property LockedRowsCell;
	__property Options = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property Rows;
	__property ScrollBars = {default=3};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnActiveCellChanged;
	__property OnActiveCellMoving;
	__property OnBeginEdit;
	__property OnClipboardCopy;
	__property OnClipboardCut;
	__property OnClipboardPaste;
	__property OnColumnsChanged;
	__property OnDblClick;
	__property OnDoneEdit;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEndEdit;
	__property OnEnter;
	__property OnEnteringColumn;
	__property OnEnteringRow;
	__property OnExit;
	__property OnGetCellData;
	__property OnGetCellAttributes;
	__property OnGetRowAttributes;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnLeavingColumn;
	__property OnLeavingRow;
	__property OnLockedCellClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnPaintUnusedArea;
	__property OnResizeColumn;
	__property OnResizeRow;
	__property OnRowsChanged;
	__property OnSizeCellEditor;
	__property OnTopLeftCellChanged;
	__property OnTopLeftCellChanging;
	__property OnUserCommand;
public:
	/* TOvcCustomTable.Create */ inline __fastcall virtual TOvcTable(System::Classes::TComponent* AOwner) : TOvcCustomTable(AOwner) { }
	/* TOvcCustomTable.Destroy */ inline __fastcall virtual ~TOvcTable(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTable(HWND ParentWindow) : TOvcCustomTable(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctable */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTABLE)
using namespace Ovctable;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctableHPP

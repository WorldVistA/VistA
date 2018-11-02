// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbtbl.pas' rev: 29.00 (Windows)

#ifndef OvcdbtblHPP
#define OvcdbtblHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <ovctcbef.hpp>
#include <ovctcell.hpp>
#include <ovctbclr.hpp>
#include <ovctbcls.hpp>
#include <ovctcmmn.hpp>
#include <ovctgpns.hpp>
#include <ovcdate.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbtbl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbTableDataLink;
class DELPHICLASS TOvcDbTableColumn;
class DELPHICLASS TOvcVisibleColumns;
class DELPHICLASS TOvcCustomDbTable;
class DELPHICLASS TOvcDbTable;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcDbTableOptions : unsigned char { dtoCellsPaintText, dtoAllowColumnMove, dtoAllowColumnSize, dtoAlwaysEditing, dtoHighlightActiveRow, dtoIntegralHeight, dtoEnterToTab, dtoPageScroll, dtoShowIndicators, dtoShowPictures, dtoStretch, dtoWantTabs, dtoWrapAtEnds };

typedef System::Set<TOvcDbTableOptions, TOvcDbTableOptions::dtoCellsPaintText, TOvcDbTableOptions::dtoWrapAtEnds> TOvcDbTableOptionSet;

enum DECLSPEC_DENUM TOvcHeaderOptions : unsigned char { hoShowHeader, hoUseHeaderCell, hoUseLetters, hoUseStrings };

typedef System::Set<TOvcHeaderOptions, TOvcHeaderOptions::hoShowHeader, TOvcHeaderOptions::hoUseStrings> TOvcHeaderOptionSet;

enum DECLSPEC_DENUM TDateOrTime : unsigned char { dtUseDate, dtUseTime };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcDbTableDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
protected:
	int FFieldCount;
	void *FFieldMap;
	int FFieldMapSize;
	bool FInUpdateData;
	bool FMapBuilt;
	bool FModified;
	TOvcCustomDbTable* FTable;
	bool __fastcall GetDefaultFields(void);
	Data::Db::TField* __fastcall GetFields(int Index);
	virtual void __fastcall ActiveChanged(void);
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall DataSetScrolled(int Distance);
	virtual void __fastcall EditingChanged(void);
	virtual void __fastcall LayoutChanged(void);
	virtual void __fastcall RecordChanged(Data::Db::TField* Field);
	virtual void __fastcall UpdateData(void);
	
public:
	__fastcall TOvcDbTableDataLink(TOvcCustomDbTable* ATable);
	__fastcall virtual ~TOvcDbTableDataLink(void);
	bool __fastcall AddMapping(const System::UnicodeString FieldName);
	void __fastcall ClearFieldMappings(void);
	void __fastcall Modified(void);
	void __fastcall Reset(void);
	__property bool DefaultFields = {read=GetDefaultFields, nodefault};
	__property int FieldCount = {read=FFieldCount, nodefault};
	__property Data::Db::TField* Fields[int Index] = {read=GetFields};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcDbTableColumn : public Ovctbcls::TOvcTableColumn
{
	typedef Ovctbcls::TOvcTableColumn inherited;
	
protected:
	System::UnicodeString FDataField;
	TDateOrTime FDateOrTime;
	Data::Db::TField* FField;
	int FOffset;
	Data::Db::TField* __fastcall GetField(void);
	TOvcCustomDbTable* __fastcall GetTable(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDateOrTime(TDateOrTime Value);
	void __fastcall SetField(Data::Db::TField* Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcDbTableColumn(Ovctcmmn::TOvcTableAncestor* ATable);
	__property Data::Db::TField* Field = {read=GetField, write=SetField};
	__property int Offset = {read=FOffset, write=FOffset, nodefault};
	__property TOvcCustomDbTable* Table = {read=GetTable};
	
__published:
	__property System::UnicodeString DataField = {read=FDataField, write=SetDataField};
	__property TDateOrTime DateOrTime = {read=FDateOrTime, write=SetDateOrTime, nodefault};
public:
	/* TOvcTableColumn.Destroy */ inline __fastcall virtual ~TOvcDbTableColumn(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcVisibleColumns : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TOvcDbTableColumn* operator[](int Index) { return Column[Index]; }
	
protected:
	System::Classes::TList* FList;
	int FRightEdge;
	TOvcCustomDbTable* FTable;
	TOvcDbTableColumn* __fastcall GetColumn(int Index);
	int __fastcall GetCount(void);
	
public:
	__fastcall TOvcVisibleColumns(TOvcCustomDbTable* ATable);
	__fastcall virtual ~TOvcVisibleColumns(void);
	int __fastcall IndexOf(int ColNum);
	void __fastcall Add(int ColNum);
	void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	void __fastcall Exchange(int Index1, int Index2);
	void __fastcall Insert(int Index, int ColNum);
	void __fastcall Move(int Index1, int Index2);
	__property TOvcDbTableColumn* Column[int Index] = {read=GetColumn/*, default*/};
	__property int Count = {read=GetCount, nodefault};
	__property int RightEdge = {read=FRightEdge, write=FRightEdge, nodefault};
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOvcColumnMovedEvent)(System::TObject* Sender, int FromCol, int ToCol);

class PASCALIMPLEMENTATION TOvcCustomDbTable : public Ovctcmmn::TOvcTableAncestor
{
	typedef Ovctcmmn::TOvcTableAncestor inherited;
	
protected:
	Ovctcmmn::TOvcTblAccess FAccess;
	int FActiveColumn;
	int FActiveRow;
	Ovctcmmn::TOvcTblAdjust FAdjust;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Ovctbclr::TOvcTableColors* FColors;
	System::Uitypes::TColor FColorUnused;
	Ovctbcls::TOvcTableColumns* FColumns;
	TOvcDbTableDataLink* FDataLink;
	int FDefaultMargin;
	Ovctgpns::TOvcGridPenSet* FGridPenSet;
	Ovctcell::TOvcBaseTableCell* FHeaderCell;
	int FHeaderHeight;
	TOvcHeaderOptionSet FHeaderOptions;
	int FLeftColumn;
	int FLockedColumns;
	TOvcDbTableOptionSet FOptions;
	int FRowHeight;
	int FRowIndicatorWidth;
	System::Uitypes::TScrollStyle FScrollBars;
	Ovctcmmn::TOvcTextStyle FTextStyle;
	TOvcVisibleColumns* FVisibleColumns;
	int FVisibleRowCount;
	Ovctcmmn::TCellNotifyEvent FOnActiveCellChanged;
	TOvcColumnMovedEvent FOnColumnMoved;
	Ovctcmmn::TCellNotifyEvent FOnIndicatorClick;
	Ovctcmmn::TCellAttrNotifyEvent FOnGetCellAttributes;
	System::Classes::TNotifyEvent FOnLeftColumnChanged;
	Ovctcmmn::TCellNotifyEvent FOnLockedCellClick;
	System::Classes::TNotifyEvent FOnPaintUnusedArea;
	Ovctcmmn::TCellNotifyEvent FOnUnusedAreaClick;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	Ovctcell::TOvcBaseTableCell* tbActiveCell;
	Vcl::Graphics::TFont* tbCellAttrFont;
	System::UnicodeString tbCmdTable;
	HICON tbColMoveCursor;
	Data::Db::TDataSource* tbDataSource;
	bool tbDisplayedError;
	bool tbHasHSBar;
	bool tbHasVSBar;
	Vcl::Controls::TImageList* tbIndicators;
	int tbRowIndicatorWidth;
	int tbLastLeftCol;
	int tbMoveIndex;
	int tbMoveToIndex;
	int tbMovingCol;
	bool tbPainting;
	bool tbRebuilding;
	bool tbScrolling;
	bool tbSelectingNewCell;
	int tbSizeOffset;
	int tbSizeIndex;
	Ovctcmmn::TOvcTblStates tbState;
	int __fastcall GetColumnCount(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	int __fastcall GetFieldCount(void);
	Data::Db::TField* __fastcall GetFields(int Index);
	Data::Db::TField* __fastcall GetSelectedField(void);
	int __fastcall GetVisibleColumnCount(void);
	void __fastcall SetAccess(Ovctcmmn::TOvcTblAccess Value);
	void __fastcall SetActiveColumn(int Value);
	void __fastcall SetActiveRow(int Value);
	void __fastcall SetAdjust(Ovctcmmn::TOvcTblAdjust Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetColumnCount(int Value);
	void __fastcall SetColors(Ovctbclr::TOvcTableColors* Value);
	void __fastcall SetColorUnused(System::Uitypes::TColor Value);
	void __fastcall SetColumns(Ovctbcls::TOvcTableColumns* Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetDefaultMargin(int Value);
	void __fastcall SetHeaderCell(Ovctcell::TOvcBaseTableCell* Value);
	void __fastcall SetHeaderHeight(int Value);
	void __fastcall SetHeaderOptions(TOvcHeaderOptionSet Value);
	void __fastcall SetLeftColumn(int Value);
	void __fastcall SetLockedColumns(int Value);
	void __fastcall SetOptions(TOvcDbTableOptionSet Value);
	void __fastcall SetRowHeight(int Value);
	void __fastcall SetRowIndicatorWidth(int Value);
	void __fastcall SetScrollBars(System::Uitypes::TScrollStyle Value);
	void __fastcall SetSelectedField(Data::Db::TField* Value);
	void __fastcall SetTextStyle(Ovctcmmn::TOvcTextStyle Value);
	MESSAGE void __fastcall ctimKillFocus(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryOptions(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryColor(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryFont(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryLockedCols(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryLockedRows(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryActiveCol(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimQueryActiveRow(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimRemoveCell(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimSetFocus(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimStartEdit(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall ctimStartEditMouse(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall ctimStartEditKey(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMCommand(Winapi::Messages::TMessage &Msg);
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
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	void __fastcall tbDataChanged(void);
	void __fastcall tbEditingChanged(void);
	void __fastcall tbLayoutChanged(void);
	void __fastcall tbRecordChanged(Data::Db::TField* Field);
	bool __fastcall tbAdjustIntegralHeight(void);
	bool __fastcall tbCalcActiveCellRect(System::Types::TRect &ACR);
	System::Types::TRect __fastcall tbCalcCellRect(int RowNum, int ColNum);
	System::Types::TRect __fastcall tbCalcColumnRect(int ColNum);
	void __fastcall tbCalcColumnsOnLastPage(void);
	System::Types::TRect __fastcall tbCalcRowRect(int RowNum);
	int __fastcall tbCalcRowTop(int RowNum);
	int __fastcall tbCalcRowBottom(int RowNum);
	void __fastcall tbCalcRowColData(int NewLeftCol);
	void __fastcall tbCalcVisibleRows(void);
	bool __fastcall tbCanModify(void);
	virtual void __fastcall tbCellChanged(System::TObject* Sender);
	bool __fastcall tbCellModified(Ovctcell::TOvcBaseTableCell* Cell);
	void __fastcall tbColorsChanged(System::TObject* Sender);
	int __fastcall tbColumnAtRight(void);
	void __fastcall tbColumnChanged(System::TObject* Sender, int C1, int C2, Ovctcmmn::TOvcTblActions Action);
	void __fastcall tbDefineFieldMap(void);
	void __fastcall tbDrawActiveCell(const Ovctcmmn::TOvcCellAttributes &CellAttr);
	void __fastcall tbDrawMoveLine(void);
	void __fastcall tbDrawSizeLine(void);
	void __fastcall tbDrawUnusedArea(void);
	bool __fastcall tbEditCellHasFocus(HWND FocusHandle);
	Ovctcell::TOvcBaseTableCell* __fastcall tbFindCell(int ColNum);
	int __fastcall tbGetDataSize(Ovctcell::TOvcBaseTableCell* ACell);
	void __fastcall tbGetMem(void * &P, Ovctcell::TOvcBaseTableCell* ACell, Data::Db::TField* const AField);
	void __fastcall tbFreeMem(void * P, Ovctcell::TOvcBaseTableCell* ACell, Data::Db::TField* const AField);
	int __fastcall tbGetFieldColumn(Data::Db::TField* AField);
	void __fastcall tbGetFieldValue(Data::Db::TField* AField, Ovctcell::TOvcBaseTableCell* ACell, void * Data, int Size);
	void __fastcall tbGridPenChanged(System::TObject* Sender);
	bool __fastcall tbIsDbActive(void);
	bool __fastcall tbIsColumnHidden(int ColNum);
	bool __fastcall tbIsInMoveArea(int MouseX, int MouseY);
	bool __fastcall tbIsOnGridLine(int MouseX, int MouseY);
	bool __fastcall tbIsSibling(HWND HW);
	bool __fastcall tbLoading(Data::Db::TDataSource* DS);
	void __fastcall tbMoveActCellPageLeft(void);
	void __fastcall tbMoveActCellPageRight(void);
	bool __fastcall tbPaintBitmapCell(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &PaintRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Data::Db::TField* AField, Ovctcell::TOvcBaseTableCell* ACell, bool Active);
	void __fastcall tbPaintString(const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, int Margin, bool WordWrap, const System::UnicodeString S);
	void __fastcall tbQueryColData(int ColNum, int &W, Ovctcmmn::TOvcTblAccess &A, bool &H);
	void __fastcall tbReadColData(System::Classes::TReader* Reader);
	void __fastcall tbRebuildColumns(void);
	void __fastcall tbScrollBarPageLeft(void);
	void __fastcall tbScrollBarPageRight(void);
	void __fastcall tbScrollNotification(int Delta);
	void __fastcall tbScrollTableLeft(int NewLeftCol);
	void __fastcall tbScrollTableRight(int NewLeftCol);
	void __fastcall tbSetFieldValue(Data::Db::TField* AField, Ovctcell::TOvcBaseTableCell* ACell, void * Data, int Size);
	void __fastcall tbSetFocus(HWND AHandle);
	void __fastcall tbUpdateActive(void);
	void __fastcall tbUpdateHScrollBar(void);
	void __fastcall tbUpdateBufferLimit(void);
	void __fastcall tbUpdateVScrollBar(void);
	void __fastcall tbWriteColData(System::Classes::TWriter* Writer);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	void __fastcall SetLinkActive(bool Value);
	void __fastcall UpdateData(void);
	DYNAMIC void __fastcall DoOnActiveCellChanged(int RowNum, int ColNum);
	DYNAMIC void __fastcall DoOnColumnMoved(int FromCol, int ToCol);
	DYNAMIC void __fastcall DoOnGetCellAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
	DYNAMIC void __fastcall DoOnIndicatorClick(int RowNum, int ColNum);
	DYNAMIC void __fastcall DoOnLeftColumnChanged(void);
	DYNAMIC void __fastcall DoOnLockedCellClick(int RowNum, int ColNum);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	virtual void __fastcall DoOnPaintUnusedArea(void);
	DYNAMIC void __fastcall DoOnUnusedAreaClick(int RowNum, int ColNum);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Cmd);
	__property TOvcDbTableDataLink* DataLink = {read=FDataLink};
	__property TOvcVisibleColumns* VisibleColumns = {read=FVisibleColumns};
	__property Ovctcmmn::TOvcTblAccess Access = {read=FAccess, write=SetAccess, nodefault};
	__property Ovctcmmn::TOvcTblAdjust Adjust = {read=FAdjust, write=SetAdjust, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property int ColumnCount = {read=GetColumnCount, nodefault};
	__property Ovctbclr::TOvcTableColors* Colors = {read=FColors, write=SetColors};
	__property System::Uitypes::TColor ColorUnused = {read=FColorUnused, write=SetColorUnused, nodefault};
	__property Ovctbcls::TOvcTableColumns* Columns = {read=FColumns, write=SetColumns};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property int DefaultMargin = {read=FDefaultMargin, write=SetDefaultMargin, nodefault};
	__property Ovctgpns::TOvcGridPenSet* GridPenSet = {read=FGridPenSet, write=FGridPenSet};
	__property Ovctcell::TOvcBaseTableCell* HeaderCell = {read=FHeaderCell, write=SetHeaderCell};
	__property int HeaderHeight = {read=FHeaderHeight, write=SetHeaderHeight, nodefault};
	__property TOvcHeaderOptionSet HeaderOptions = {read=FHeaderOptions, write=SetHeaderOptions, nodefault};
	__property int LockedColumns = {read=FLockedColumns, write=SetLockedColumns, nodefault};
	__property TOvcDbTableOptionSet Options = {read=FOptions, write=SetOptions, nodefault};
	__property int RowHeight = {read=FRowHeight, write=SetRowHeight, nodefault};
	__property int RowIndicatorWidth = {read=FRowIndicatorWidth, write=SetRowIndicatorWidth, nodefault};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, nodefault};
	__property Ovctcmmn::TOvcTextStyle TextStyle = {read=FTextStyle, write=SetTextStyle, nodefault};
	__property Ovctcmmn::TCellNotifyEvent OnActiveCellChanged = {read=FOnActiveCellChanged, write=FOnActiveCellChanged};
	__property TOvcColumnMovedEvent OnColumnMoved = {read=FOnColumnMoved, write=FOnColumnMoved};
	__property Ovctcmmn::TCellAttrNotifyEvent OnGetCellAttributes = {read=FOnGetCellAttributes, write=FOnGetCellAttributes};
	__property Ovctcmmn::TCellNotifyEvent OnIndicatorClick = {read=FOnIndicatorClick, write=FOnIndicatorClick};
	__property System::Classes::TNotifyEvent OnLeftColumnChanged = {read=FOnLeftColumnChanged, write=FOnLeftColumnChanged};
	__property Ovctcmmn::TCellNotifyEvent OnLockedCellClick = {read=FOnLockedCellClick, write=FOnLockedCellClick};
	__property System::Classes::TNotifyEvent OnPaintUnusedArea = {read=FOnPaintUnusedArea, write=FOnPaintUnusedArea};
	__property Ovctcmmn::TCellNotifyEvent OnUnusedAreaClick = {read=FOnUnusedAreaClick, write=FOnUnusedAreaClick};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	
public:
	__fastcall virtual TOvcCustomDbTable(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomDbTable(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	Ovctcmmn::TOvcTblRegion __fastcall CalcRowCol(int X, int Y, int &RowNum, int &ColNum);
	virtual Ovctcmmn::TOvcTblKeyNeeds __fastcall FilterKey(Winapi::Messages::TWMKey &Msg);
	void __fastcall GetColumnOrderStrings(System::Classes::TStrings* &Cols);
	void __fastcall GetColumnOrder(System::UnicodeString *Cols, const int Cols_High);
	void __fastcall GetColumnWidthsStrings(System::Classes::TStrings* &Cols);
	void __fastcall GetColumnWidths(int *Cols, const int Cols_High);
	int __fastcall IncCol(int ColNum, int Delta);
	int __fastcall IncRow(int RowNum, int Delta);
	bool __fastcall InEditingState(void);
	void __fastcall InvalidateCell(int RowNum, int ColNum);
	void __fastcall InvalidateColumn(int ColNum);
	void __fastcall InvalidateHeader(void);
	void __fastcall InvalidateIndicators(void);
	void __fastcall InvalidateNotLocked(void);
	void __fastcall InvalidateRow(int RowNum);
	void __fastcall InvalidateUnusedArea(void);
	void __fastcall MakeColumnVisible(int ColNum);
	void __fastcall MoveActiveCell(System::Word Command);
	virtual void __fastcall ResolveCellAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
	bool __fastcall SaveEditedData(void);
	void __fastcall Scroll(int Delta);
	void __fastcall SetActiveCell(int RowNum, int ColNum);
	bool __fastcall SetCellProperties(Data::Db::TField* AField, Ovctcell::TOvcBaseTableCell* ACell);
	void __fastcall SetColumnOrderStrings(System::Classes::TStrings* const Cols);
	void __fastcall SetColumnOrder(System::UnicodeString const *Cols, const int Cols_High);
	void __fastcall SetColumnWidthsStrings(System::Classes::TStrings* const Cols);
	void __fastcall SetColumnWidths(int const *Cols, const int Cols_High);
	bool __fastcall StartEditing(void);
	bool __fastcall StopEditing(bool SaveValue);
	__property Canvas;
	__property int ActiveColumn = {read=FActiveColumn, write=SetActiveColumn, nodefault};
	__property int ActiveRow = {read=FActiveRow, write=SetActiveRow, nodefault};
	__property int FieldCount = {read=GetFieldCount, nodefault};
	__property Data::Db::TField* SelectedField = {read=GetSelectedField, write=SetSelectedField};
	__property Data::Db::TField* Fields[int Index] = {read=GetFields};
	__property int LeftColumn = {read=FLeftColumn, write=SetLeftColumn, nodefault};
	__property int VisibleColumnCount = {read=GetVisibleColumnCount, nodefault};
	__property int VisibleRowCount = {read=FVisibleRowCount, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomDbTable(HWND ParentWindow) : Ovctcmmn::TOvcTableAncestor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbTable : public TOvcCustomDbTable
{
	typedef TOvcCustomDbTable inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property LockedColumns;
	__property Access;
	__property Adjust;
	__property Align = {default=0};
	__property BorderStyle;
	__property ColumnCount = {stored=false};
	__property Color = {default=-16777201};
	__property ColorUnused;
	__property Colors;
	__property Columns;
	__property Controller;
	__property Ctl3D;
	__property DataSource;
	__property DefaultMargin;
	__property DragCursor = {default=-12};
	__property Enabled = {default=1};
	__property Font;
	__property GridPenSet;
	__property HeaderCell;
	__property HeaderHeight;
	__property HeaderOptions;
	__property Options;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property RowHeight;
	__property RowIndicatorWidth;
	__property ScrollBars;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property TextStyle;
	__property Visible = {default=1};
	__property OnActiveCellChanged;
	__property OnClick;
	__property OnColumnMoved;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnGetCellAttributes;
	__property OnIndicatorClick;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnLeftColumnChanged;
	__property OnLockedCellClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnPaintUnusedArea;
	__property OnStartDrag;
	__property OnUnusedAreaClick;
	__property OnUserCommand;
public:
	/* TOvcCustomDbTable.Create */ inline __fastcall virtual TOvcDbTable(System::Classes::TComponent* AOwner) : TOvcCustomDbTable(AOwner) { }
	/* TOvcCustomDbTable.Destroy */ inline __fastcall virtual ~TOvcDbTable(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbTable(HWND ParentWindow) : TOvcCustomDbTable(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbtbl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBTBL)
using namespace Ovcdbtbl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbtblHPP

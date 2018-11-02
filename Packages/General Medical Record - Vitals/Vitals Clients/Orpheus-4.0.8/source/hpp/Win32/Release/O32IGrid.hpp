// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32igrid.pas' rev: 29.00 (Windows)

#ifndef O32igridHPP
#define O32igridHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Grids.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Controls.hpp>
#include <ovcbase.hpp>
#include <ovccmbx.hpp>
#include <ovcclrcb.hpp>
#include <ovcftcbx.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32igrid
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32GridEdit;
class DELPHICLASS TO32GridCombo;
class DELPHICLASS TO32GridColorCombo;
class DELPHICLASS TO32GridFontCombo;
class DELPHICLASS TO32InspectorItem;
class DELPHICLASS TO32InspectorItems;
class DELPHICLASS TO32CustomInspectorGrid;
class DELPHICLASS TO32InspectorGrid;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32IGridItemType : unsigned char { itParent, itSet, itList, itString, itInteger, itFloat, itCurrency, itDate, itColor, itLogical, itFont };

enum DECLSPEC_DENUM TO32IGridCell : unsigned char { icLeft, icRight };

typedef void __fastcall (__closure *To32IGridItemEvent)(System::TObject* Sender, System::Word Item);

typedef void __fastcall (__closure *To32IGridDeleteItemEvent)(System::TObject* Sender, System::Word Item, bool &AllowIt);

typedef void __fastcall (__closure *TO32GetEditMaskEvent)(System::TObject* Sender, TO32InspectorItem* Item, System::UnicodeString &Mask);

typedef void __fastcall (__closure *TO32GetEditTextEvent)(System::TObject* Sender, TO32InspectorItem* Item, System::UnicodeString &Text);

typedef void __fastcall (__closure *TO32GetEditLimitEvent)(System::TObject* Sender, TO32InspectorItem* Item, int &Limit);

typedef void __fastcall (__closure *TO32IGridCellPaintEvent)(System::TObject* Sender, const System::Types::TRect &Rect, Vcl::Graphics::TCanvas* Canvas, System::Word Item, TO32IGridCell Cell, bool &Default);

class PASCALIMPLEMENTATION TO32GridEdit : public Vcl::Mask::TCustomMaskEdit
{
	typedef Vcl::Mask::TCustomMaskEdit inherited;
	
protected:
	TO32CustomInspectorGrid* FGrid;
	int FClickTime;
	bool Updating;
	void __fastcall InternalMove(const System::Types::TRect &Loc, bool Redraw);
	void __fastcall SetGrid(TO32CustomInspectorGrid* Value);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMPaste(void *Message);
	HIDESBASE MESSAGE void __fastcall WMCut(void *Message);
	MESSAGE void __fastcall WMClear(void *Message);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	HIDESBASE void __fastcall Changed(System::TObject* Sender);
	DYNAMIC void __fastcall DblClick(void);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	virtual bool __fastcall EditCanModify(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall BoundsChanged(void);
	virtual void __fastcall UpdateContents(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	__property TO32CustomInspectorGrid* Grid = {read=FGrid};
	
public:
	__fastcall virtual TO32GridEdit(System::Classes::TComponent* AOwner);
	void __fastcall Deselect(void);
	HIDESBASE void __fastcall Hide(void);
	HIDESBASE void __fastcall Invalidate(void);
	HIDESBASE void __fastcall SetFocus(void);
	void __fastcall Move(const System::Types::TRect &Loc);
	bool __fastcall PosEqual(const System::Types::TRect &Rect);
	void __fastcall UpdateLoc(const System::Types::TRect &Loc);
	HIDESBASE bool __fastcall Visible(void);
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32GridEdit(HWND ParentWindow) : Vcl::Mask::TCustomMaskEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TO32GridEdit(void) { }
	
};


class PASCALIMPLEMENTATION TO32GridCombo : public Vcl::Stdctrls::TCustomComboBox
{
	typedef Vcl::Stdctrls::TCustomComboBox inherited;
	
protected:
	TO32CustomInspectorGrid* FGrid;
	int FClickTime;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	bool Updating;
	void __fastcall InternalMove(const System::Types::TRect &Loc, bool Redraw);
	void __fastcall SetGrid(TO32CustomInspectorGrid* Value);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(void *Message);
	MESSAGE void __fastcall WMCut(void *Message);
	MESSAGE void __fastcall WMClear(void *Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	HIDESBASE void __fastcall Changed(System::TObject* Sender);
	DYNAMIC void __fastcall DblClick(void);
	void __fastcall DropDownList(bool Value);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	bool __fastcall EditCanModify(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall BoundsChanged(void);
	virtual void __fastcall UpdateContents(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	__property TO32CustomInspectorGrid* Grid = {read=FGrid};
	
public:
	__fastcall virtual TO32GridCombo(System::Classes::TComponent* AOwner);
	void __fastcall Deselect(void);
	HIDESBASE void __fastcall Hide(void);
	void __fastcall Move(const System::Types::TRect &Loc);
	void __fastcall UpdateLoc(const System::Types::TRect &Loc);
public:
	/* TCustomComboBox.Destroy */ inline __fastcall virtual ~TO32GridCombo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32GridCombo(HWND ParentWindow) : Vcl::Stdctrls::TCustomComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32GridColorCombo : public Ovcclrcb::TOvcCustomColorComboBox
{
	typedef Ovcclrcb::TOvcCustomColorComboBox inherited;
	
protected:
	TO32CustomInspectorGrid* FGrid;
	int FClickTime;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	bool Updating;
	void __fastcall InternalMove(const System::Types::TRect &Loc, bool Redraw);
	void __fastcall SetGrid(TO32CustomInspectorGrid* Value);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(void *Message);
	MESSAGE void __fastcall WMCut(void *Message);
	MESSAGE void __fastcall WMClear(void *Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	HIDESBASE void __fastcall Changed(System::TObject* Sender);
	DYNAMIC void __fastcall DblClick(void);
	void __fastcall DropDownList(bool Value);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	bool __fastcall EditCanModify(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall BoundsChanged(void);
	virtual void __fastcall UpdateContents(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	__property TO32CustomInspectorGrid* Grid = {read=FGrid};
	
public:
	__fastcall virtual TO32GridColorCombo(System::Classes::TComponent* AOwner);
	void __fastcall Deselect(void);
	HIDESBASE void __fastcall Hide(void);
	void __fastcall Move(const System::Types::TRect &Loc);
	void __fastcall UpdateLoc(const System::Types::TRect &Loc);
public:
	/* TOvcCustomColorComboBox.Destroy */ inline __fastcall virtual ~TO32GridColorCombo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32GridColorCombo(HWND ParentWindow) : Ovcclrcb::TOvcCustomColorComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32GridFontCombo : public Ovcftcbx::TOvcFontComboBox
{
	typedef Ovcftcbx::TOvcFontComboBox inherited;
	
protected:
	TO32CustomInspectorGrid* FGrid;
	int FClickTime;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	bool Updating;
	void __fastcall InternalMove(const System::Types::TRect &Loc, bool Redraw);
	void __fastcall SetGrid(TO32CustomInspectorGrid* Value);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(void *Message);
	MESSAGE void __fastcall WMCut(void *Message);
	MESSAGE void __fastcall WMClear(void *Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	HIDESBASE void __fastcall Changed(System::TObject* Sender);
	DYNAMIC void __fastcall DblClick(void);
	void __fastcall DropDownList(bool Value);
	DYNAMIC bool __fastcall DoMouseWheel(System::Classes::TShiftState Shift, int WheelDelta, const System::Types::TPoint &MousePos);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	bool __fastcall EditCanModify(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall BoundsChanged(void);
	virtual void __fastcall UpdateContents(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	__property TO32CustomInspectorGrid* Grid = {read=FGrid};
	
public:
	__fastcall virtual TO32GridFontCombo(System::Classes::TComponent* AOwner);
	void __fastcall Deselect(void);
	HIDESBASE void __fastcall Hide(void);
	void __fastcall Move(const System::Types::TRect &Loc);
	void __fastcall UpdateLoc(const System::Types::TRect &Loc);
public:
	/* TOvcFontComboBox.Destroy */ inline __fastcall virtual ~TO32GridFontCombo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32GridFontCombo(HWND ParentWindow) : Ovcftcbx::TOvcFontComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32InspectorItem : public Ovcbase::TO32CollectionItem
{
	typedef Ovcbase::TO32CollectionItem inherited;
	
protected:
	TO32IGridItemType FType;
	System::UnicodeString FCaption;
	TO32InspectorItem* FParent;
	int FParentIndex;
	System::Word FAbsIndex;
	TO32CustomInspectorGrid* FIGrid;
	int FInt;
	System::UnicodeString FString;
	double FDouble;
	int FImageIndex;
	bool FReadOnly;
	bool FExpanded;
	System::Currency FCurrency;
	System::TDateTime FDate;
	System::Uitypes::TColor FColor;
	bool FLogical;
	Vcl::Graphics::TFont* FFont;
	int FLevel;
	bool FVisible;
	System::Classes::TStringList* FItemsList;
	int FTag;
	void __fastcall SetType(TO32IGridItemType Value);
	void __fastcall SetCaption(System::UnicodeString Value);
	void __fastcall SetCurrency(System::Currency Value);
	void __fastcall SetDate(System::TDateTime Value);
	void __fastcall SetString(System::UnicodeString Value);
	virtual void __fastcall SetIndex(int Value);
	void __fastcall SetInteger(int Value);
	void __fastcall SetItemsList(System::Classes::TStringList* Value);
	void __fastcall SetFloat(double Value);
	void __fastcall SetColor(System::Uitypes::TColor Value);
	void __fastcall SetBoolean(bool Value);
	void __fastcall SetExpanded(bool Value);
	void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetValue(const System::Variant &Value);
	void __fastcall SetVisible(bool Value);
	int __fastcall CountChildren(void);
	System::Currency __fastcall GetCurrency(void);
	System::TDateTime __fastcall GetDate(void);
	System::UnicodeString __fastcall GetString(void);
	int __fastcall GetInteger(void);
	System::Classes::TStringList* __fastcall GetItemsList(void);
	double __fastcall GetFloat(void);
	System::Uitypes::TColor __fastcall GetColor(void);
	bool __fastcall GetBoolean(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	System::Variant __fastcall GetValue(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall StoreParent(System::Classes::TWriter* Writer);
	void __fastcall LoadParent(System::Classes::TReader* Reader);
	void __fastcall StoreValue(System::Classes::TWriter* Writer);
	void __fastcall LoadValue(System::Classes::TReader* Reader);
	System::Uitypes::TColor __fastcall StrToColor(System::UnicodeString Value);
	System::UnicodeString __fastcall ColorToStr(System::Uitypes::TColor Value);
	System::UnicodeString __fastcall GetElementsAsString(void);
	void __fastcall SetElementsAsString(System::UnicodeString Value);
	
public:
	System::Classes::TStringList* SL;
	System::TObject* ObjectRef;
	__fastcall virtual TO32InspectorItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TO32InspectorItem(void);
	void __fastcall Collapse(void);
	void __fastcall Expand(void);
	void __fastcall DeleteChildren(void);
	void __fastcall FreeObject(void);
	void __fastcall AddObject(System::TObject* Ref);
	__property System::Word AbsoluteIndex = {read=FAbsIndex, nodefault};
	__property int ChildCount = {read=CountChildren, nodefault};
	__property TO32CustomInspectorGrid* InspectorGrid = {read=FIGrid};
	__property System::TDateTime AsDate = {read=GetDate, write=SetDate};
	__property System::UnicodeString AsString = {read=GetString, write=SetString};
	__property int AsInteger = {read=GetInteger, write=SetInteger, nodefault};
	__property double AsFloat = {read=GetFloat, write=SetFloat};
	__property System::Currency AsCurrency = {read=GetCurrency, write=SetCurrency};
	__property System::Uitypes::TColor AsColor = {read=GetColor, write=SetColor, nodefault};
	__property bool AsBoolean = {read=GetBoolean, write=SetBoolean, nodefault};
	__property Vcl::Graphics::TFont* AsFont = {read=GetFont, write=SetFont};
	__property bool Expanded = {read=FExpanded, write=SetExpanded, nodefault};
	__property TO32InspectorItem* Parent = {read=FParent};
	__property int ParentIndex = {read=FParentIndex, nodefault};
	__property System::Variant Value = {read=GetValue, write=SetValue};
	__property int Level = {read=FLevel, nodefault};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::UnicodeString DisplayText = {read=GetString, write=SetString};
	__property int ImageIndex = {read=FImageIndex, write=FImageIndex, nodefault};
	__property System::Classes::TStringList* ItemsList = {read=GetItemsList, write=SetItemsList};
	__property TO32IGridItemType ItemType = {read=FType, write=SetType, nodefault};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, nodefault};
	__property int Tag = {read=FTag, write=FTag, nodefault};
	__property bool Visible = {read=FVisible, write=SetVisible, nodefault};
	__property Name = {default=0};
};


class PASCALIMPLEMENTATION TO32InspectorItems : public Ovcbase::TO32Collection
{
	typedef Ovcbase::TO32Collection inherited;
	
protected:
	TO32CustomInspectorGrid* FInspectorGrid;
	System::Classes::TList* FVisibleItems;
	int __fastcall Compare(TO32InspectorItem* Item1, TO32InspectorItem* Item2);
	void __fastcall SortList(System::Classes::TList* AList);
	void __fastcall Sort(void);
	void __fastcall LoadChildren(System::Classes::TList* TargetList);
	int __fastcall GetTypeNumber(TO32IGridItemType Value);
	
public:
	__fastcall virtual TO32InspectorItems(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass);
	__fastcall virtual ~TO32InspectorItems(void);
	void __fastcall LoadVisibleItems(void);
	TO32InspectorItem* __fastcall AddItem(TO32IGridItemType ItemType, TO32InspectorItem* Parent);
	HIDESBASE TO32InspectorItem* __fastcall InsertItem(TO32IGridItemType ItemType, TO32InspectorItem* Parent, int Index);
	__property System::Classes::TList* VisibleItems = {read=FVisibleItems};
};


class PASCALIMPLEMENTATION TO32CustomInspectorGrid : public Ovcbase::TO32CustomControl
{
	typedef Ovcbase::TO32CustomControl inherited;
	
protected:
	System::Uitypes::TColor FItemTextColor;
	System::Uitypes::TColor FCaptionTextColor;
	bool FAutoExpand;
	System::Uitypes::TColor FGridLineColor;
	Vcl::Graphics::TFont* FFont;
	System::Word FChildIndentation;
	System::Uitypes::TColor FEditCellColor;
	TO32InspectorItems* FItems;
	System::Uitypes::TColor FTextColor;
	int FUpdatingIndex;
	Vcl::Controls::TImageList* FImages;
	Vcl::Grids::TGridCoord FAnchor;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FCanEditModify;
	int FColCount;
	void *FColWidths;
	void *FTabStops;
	Vcl::Grids::TGridCoord FCurrent;
	int FDefaultColWidth;
	int FDefaultRowHeight;
	System::Uitypes::TColor FEditColor;
	int FFixedCols;
	int FFixedRows;
	System::Uitypes::TColor FFixedColor;
	int FGridLineWidth;
	Vcl::Grids::TGridOptions FOptions;
	bool FReadOnly;
	int FRowCount;
	void *FRowHeights;
	bool FSorted;
	System::Uitypes::TScrollStyle FScrollBars;
	Vcl::Grids::TGridCoord FTopLeft;
	int FSizingIndex;
	int FSizingPos;
	int FSizingOfs;
	int FMoveIndex;
	int FMovePos;
	System::Types::TPoint FHitTest;
	Vcl::Controls::TWinControl* FInplaceEdit;
	int FInplaceCol;
	int FInplaceRow;
	int FColOffset;
	bool FDefaultDrawing;
	bool FEditorMode;
	Vcl::Grids::TGridState FGridState;
	bool FSaveCellExtents;
	Vcl::Grids::TGridOptions DesignOptionsBoost;
	int FActiveItem;
	Vcl::Graphics::TBitmap* FExpandGlyph;
	To32IGridItemEvent FAfterEdit;
	To32IGridItemEvent FBeforeEdit;
	TO32IGridCellPaintEvent FOnCellPaint;
	To32IGridDeleteItemEvent FOnDelete;
	To32IGridItemEvent FOnExpand;
	To32IGridItemEvent FOnCollapse;
	TO32GetEditMaskEvent FOnGetEditMask;
	TO32GetEditTextEvent FOnGetEditText;
	TO32GetEditLimitEvent FOnGetEditLimit;
	To32IGridItemEvent FOnItemChange;
	To32IGridItemEvent FOnItemEditorChange;
	To32IGridItemEvent FOnItemSelect;
	void __fastcall SetCaptionTextColor(const System::Uitypes::TColor Value);
	void __fastcall SetItemTextColor(const System::Uitypes::TColor Value);
	void __fastcall SetGridLineColor(const System::Uitypes::TColor Value);
	void __fastcall SetActiveItem(const int Value);
	HIDESBASE System::UnicodeString __fastcall GetAbout(void);
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	System::UnicodeString __fastcall GetCells(int ACol, int ARow);
	void __fastcall SetCells(int ACol, int ARow, const System::UnicodeString Value);
	void __fastcall SetEditCellColor(const System::Uitypes::TColor Value);
	Vcl::Grids::TGridCoord __fastcall CalcCoordFromPoint(int X, int Y, const Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall CalcDrawInfoXY(Vcl::Grids::TGridDrawInfo &DrawInfo, int UseWidth, int UseHeight);
	Vcl::Grids::TGridCoord __fastcall CalcMaxTopLeft(const Vcl::Grids::TGridCoord &Coord, const Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall CancelMode(void);
	void __fastcall ChangeSize(int NewColCount, int NewRowCount);
	void __fastcall ClampInView(const Vcl::Grids::TGridCoord &Coord);
	void __fastcall DrawMove(void);
	void __fastcall FocusCell(int ACol, int ARow, bool MoveAnchor);
	void __fastcall UpdateCellContents(void);
	void __fastcall GridRectToScreenRect(const Vcl::Grids::TGridRect &GridRect, System::Types::TRect &ScreenRect, bool IncludeLine);
	TO32InspectorItem* __fastcall GetItems(int Index);
	TO32InspectorItem* __fastcall GetSelectedItem(void);
	void __fastcall HideEdit(void);
	void __fastcall Initialize(void);
	void __fastcall InvalidateGrid(void);
	void __fastcall InvalidateRect(const Vcl::Grids::TGridRect &ARect);
	void __fastcall ModifyScrollBar(unsigned ScrollBar, unsigned ScrollCode, unsigned Pos, bool UseRightToLeft);
	void __fastcall MoveAnchor(const Vcl::Grids::TGridCoord &NewAnchor);
	void __fastcall MoveAndScroll(int Mouse, int CellHit, Vcl::Grids::TGridDrawInfo &DrawInfo, Vcl::Grids::TGridAxisDrawInfo &Axis, int Scrollbar, const System::Types::TPoint &MousePt);
	void __fastcall MoveCurrent(int ACol, int ARow, bool MoveAnchor, bool Show);
	void __fastcall MoveTopLeft(int ALeft, int ATop);
	void __fastcall ResizeCol(int Index, int OldSize, int NewSize);
	void __fastcall ResizeRow(int Index, int OldSize, int NewSize);
	void __fastcall ScrollDataInfo(int DX, int DY, Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall SelectionMoved(const Vcl::Grids::TGridRect &OldSel);
	void __fastcall TopLeftMoved(const Vcl::Grids::TGridCoord &OldTopLeft);
	void __fastcall UpdateScrollPos(void);
	void __fastcall UpdateScrollRange(void);
	int __fastcall GetColWidths(int Index);
	int __fastcall GetItemCount(void);
	int __fastcall GetRowHeights(int Index);
	Vcl::Grids::TGridRect __fastcall GetSelection(void);
	bool __fastcall GetTabStops(int Index);
	bool __fastcall IsEditing(void);
	bool __fastcall IsActiveControl(void);
	void __fastcall ReadColWidths(System::Classes::TReader* Reader);
	void __fastcall ReadRowHeights(System::Classes::TReader* Reader);
	void __fastcall SetCol(int Value);
	void __fastcall SetColWidths(int Index, int Value);
	void __fastcall SetDefaultRowHeight(int Value);
	void __fastcall SetEditorMode(bool Value);
	void __fastcall SetFixedRows(int Value);
	void __fastcall SetEditColor(System::Uitypes::TColor Value);
	void __fastcall SetExpandGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetChildIndentation(System::Word Value);
	void __fastcall SetOptions(Vcl::Grids::TGridOptions Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetRow(int Value);
	void __fastcall SetImageList(Vcl::Controls::TImageList* Value);
	void __fastcall SetRowCount(int Value);
	void __fastcall SetRowHeights(int Index, int Value);
	void __fastcall SetScrollBars(System::Uitypes::TScrollStyle Value);
	void __fastcall SetSelection(const Vcl::Grids::TGridRect &Value);
	void __fastcall SetSorted(bool Value);
	void __fastcall SetTabStops(int Index, bool Value);
	void __fastcall SetTopRow(int Value);
	void __fastcall UpdateEdit(void);
	void __fastcall UpdateText(void);
	void __fastcall WriteColWidths(System::Classes::TWriter* Writer);
	void __fastcall WriteRowHeights(System::Classes::TWriter* Writer);
	MESSAGE void __fastcall CMCancelMode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall CMWantSpecialKey(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	MESSAGE void __fastcall WMTimer(Winapi::Messages::TWMTimer &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	int __fastcall ParentTypeCount(void);
	void __fastcall CalcDrawInfo(Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall CalcFixedInfo(Vcl::Grids::TGridDrawInfo &DrawInfo);
	virtual void __fastcall CalcSizingState(int X, int Y, Vcl::Grids::TGridState &State, int &Index, int &SizingPos, int &SizingOfs, Vcl::Grids::TGridDrawInfo &FixedInfo);
	void __fastcall CalcRowHeight(void);
	virtual Vcl::Controls::TWinControl* __fastcall CreateEditor(void);
	void __fastcall DestroyEditor(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall ExpandCollapse(int Index);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASEDYNAMIC void __fastcall AdjustSize(int Index, int Amount, bool Rows);
	System::Types::TRect __fastcall BoxRect(int ALeft, int ATop, int ARight, int ABottom);
	DYNAMIC void __fastcall DoExit(void);
	System::Types::TRect __fastcall CellRect(int ACol, int ARow);
	DYNAMIC bool __fastcall CanEditAcceptKey(System::WideChar Key);
	DYNAMIC bool __fastcall CanGridAcceptKey(System::Word Key, System::Classes::TShiftState Shift);
	DYNAMIC bool __fastcall CanEditModify(void);
	virtual bool __fastcall CanEditShow(void);
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	void __fastcall DoOnExpand(int Index);
	void __fastcall DoOnCollapse(int Index);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	DYNAMIC System::UnicodeString __fastcall GetEditText(int ACol, int ARow);
	DYNAMIC void __fastcall SetEditText(int ACol, int ARow, const System::UnicodeString Value);
	DYNAMIC System::UnicodeString __fastcall GetEditMask(int ACol, int ARow);
	DYNAMIC int __fastcall GetEditLimit(void);
	int __fastcall GetGridWidth(void);
	int __fastcall GetGridHeight(void);
	void __fastcall HideEditor(void);
	void __fastcall ShowEditor(void);
	void __fastcall ShowEditorChar(System::WideChar Ch);
	void __fastcall EditorChanged(void);
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual bool __fastcall SelectCell(int ACol, int ARow);
	DYNAMIC void __fastcall SizeChanged(int OldColCount, int OldRowCount);
	bool __fastcall Sizing(int X, int Y);
	void __fastcall ScrollData(int DX, int DY);
	void __fastcall InvalidateCell(int ACol, int ARow);
	DYNAMIC void __fastcall TopLeftChanged(void);
	DYNAMIC void __fastcall TimedScroll(Vcl::Grids::TGridScrollDirection Direction);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall ColWidthsChanged(void);
	DYNAMIC void __fastcall RowHeightsChanged(void);
	void __fastcall UpdateDesigner(void);
	DYNAMIC bool __fastcall BeginColumnDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	DYNAMIC bool __fastcall BeginRowDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	DYNAMIC bool __fastcall CheckColumnDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	DYNAMIC bool __fastcall CheckRowDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	DYNAMIC bool __fastcall EndColumnDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	DYNAMIC bool __fastcall EndRowDrag(int &Origin, int &Destination, const System::Types::TPoint &MousePt);
	void __fastcall ItemChanged(TO32InspectorItem* Item);
	void __fastcall ItemVisibilityChanged(void);
	void __fastcall UpdateEditorLocation(void);
	void __fastcall MoveEditor(const System::Types::TRect &ARect);
	void __fastcall AdjustEditor(const System::Types::TRect &ARect);
	void __fastcall DeselectEditor(void);
	void __fastcall UpdateEditContents(void);
	void __fastcall EditorSelectAll(void);
	void __fastcall SetEditGrid(TO32CustomInspectorGrid* AGrid);
	void __fastcall SetEditFont(Vcl::Graphics::TFont* Font);
	void __fastcall SetEditClickTIme(int Value);
	void __fastcall SetEditWndProc(const Winapi::Messages::TMessage &Msg);
	int __fastcall EditorMaxLength(void);
	System::UnicodeString __fastcall GetEditorText(void);
	bool __fastcall EditorMatchesType(int Index);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TO32CustomInspectorGrid(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomInspectorGrid(void);
	TO32InspectorItem* __fastcall Add(TO32IGridItemType ItemType, TO32InspectorItem* Parent);
	HIDESBASE TO32InspectorItem* __fastcall Insert(TO32IGridItemType ItemType, TO32InspectorItem* Parent, System::Word Index);
	void __fastcall Delete(System::Word Index);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	void __fastcall ExpandAll(void);
	void __fastcall CollapseAll(void);
	TO32InspectorItem* __fastcall GetItemAt(int X, int Y);
	__property bool AutoExpand = {read=FAutoExpand, write=FAutoExpand, nodefault};
	__property int ActiveItem = {read=FActiveItem, write=SetActiveItem, nodefault};
	__property int Col = {read=FCurrent.X, write=SetCol, nodefault};
	__property int ColWidths[int Index] = {read=GetColWidths, write=SetColWidths};
	__property int DefaultRowHeight = {read=FDefaultRowHeight, write=SetDefaultRowHeight, default=24};
	__property System::Uitypes::TColor EditCellColor = {read=FEditCellColor, write=SetEditCellColor, nodefault};
	__property bool Editing = {read=IsEditing, nodefault};
	__property bool EditorMode = {read=FEditorMode, write=SetEditorMode, nodefault};
	__property int FixedRows = {read=FFixedRows, write=SetFixedRows, default=1};
	__property int GridHeight = {read=GetGridHeight, nodefault};
	__property int GridWidth = {read=GetGridWidth, nodefault};
	__property System::Types::TPoint HitTest = {read=FHitTest};
	__property Vcl::Controls::TWinControl* InplaceEditor = {read=FInplaceEdit};
	__property int ItemCount = {read=GetItemCount, nodefault};
	__property TO32InspectorItem* Items[int Index] = {read=GetItems};
	__property Vcl::Grids::TGridOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property int RowHeights[int Index] = {read=GetRowHeights, write=SetRowHeights};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, default=3};
	__property Vcl::Grids::TGridRect Selection = {read=GetSelection, write=SetSelection};
	__property bool TabStops[int Index] = {read=GetTabStops, write=SetTabStops};
	__property int TopRow = {read=FTopLeft.Y, write=SetTopRow, nodefault};
	__property int ActiveRow = {read=FCurrent.Y, write=SetRow, nodefault};
	__property System::Word ChildIndentation = {read=FChildIndentation, write=SetChildIndentation, nodefault};
	__property System::Uitypes::TColor CaptionTextColor = {read=FCaptionTextColor, write=SetCaptionTextColor, nodefault};
	__property System::Uitypes::TColor ItemTextColor = {read=FItemTextColor, write=SetItemTextColor, nodefault};
	__property Color = {default=-16777211};
	__property System::Uitypes::TColor GridLineColor = {read=FGridLineColor, write=SetGridLineColor, nodefault};
	__property System::Uitypes::TColor EditColor = {read=FEditColor, write=SetEditColor, nodefault};
	__property bool DefaultDrawing = {read=FDefaultDrawing, write=FDefaultDrawing, default=1};
	__property Vcl::Graphics::TBitmap* ExpandGlyph = {read=FExpandGlyph, write=SetExpandGlyph, default=0};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property TO32InspectorItems* ItemCollection = {read=FItems, write=FItems};
	__property Vcl::Controls::TImageList* Images = {read=FImages, write=SetImageList, default=0};
	__property ParentColor = {default=0};
	__property bool ReadOnly = {read=FReadOnly, write=SetReadOnly, default=0};
	__property int RowCount = {read=FRowCount, nodefault};
	__property TO32InspectorItem* Selected = {read=GetSelectedItem};
	__property bool Sorted = {read=FSorted, write=SetSorted, default=0};
	__property To32IGridItemEvent AfterEdit = {read=FAfterEdit, write=FAfterEdit};
	__property To32IGridItemEvent BeforeEdit = {read=FBeforeEdit, write=FBeforeEdit};
	__property To32IGridDeleteItemEvent OnDelete = {read=FOnDelete, write=FOnDelete};
	__property To32IGridItemEvent OnExpand = {read=FOnExpand, write=FOnExpand};
	__property To32IGridItemEvent OnCollapse = {read=FOnCollapse, write=FOnCollapse};
	__property TO32IGridCellPaintEvent OnCellPaint = {read=FOnCellPaint, write=FOnCellPaint};
	__property TO32GetEditMaskEvent OnGetEditMask = {read=FOnGetEditMask, write=FOnGetEditMask};
	__property TO32GetEditTextEvent OnGetEditText = {read=FOnGetEditText, write=FOnGetEditText};
	__property TO32GetEditLimitEvent OnGetEditLimit = {read=FOnGetEditLimit, write=FOnGetEditLimit};
	__property To32IGridItemEvent OnItemChange = {read=FOnItemChange, write=FOnItemChange};
	__property To32IGridItemEvent OnItemEditorChange = {read=FOnItemEditorChange, write=FOnItemEditorChange};
	__property To32IGridItemEvent OnItemSelect = {read=FOnItemSelect, write=FOnItemSelect};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property TabStop = {default=1};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomInspectorGrid(HWND ParentWindow) : Ovcbase::TO32CustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32InspectorGrid : public TO32CustomInspectorGrid
{
	typedef TO32CustomInspectorGrid inherited;
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property OnContextPopup;
	__property AutoExpand;
	__property CaptionTextColor;
	__property ChildIndentation;
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DefaultDrawing = {default=1};
	__property EditColor = {default=-16777211};
	__property Enabled = {default=1};
	__property ExpandGlyph = {default=0};
	__property Font;
	__property GridLineColor = {default=-16777200};
	__property Hint = {default=0};
	__property ItemCollection;
	__property ItemTextColor = {default=8388608};
	__property Images = {default=0};
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentShowHint = {default=1};
	__property ReadOnly = {default=0};
	__property Selected;
	__property ShowHint;
	__property Sorted = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Tag = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property AfterEdit;
	__property BeforeEdit;
	__property OnClick;
	__property OnDelete;
	__property OnDblClick;
	__property OnCellPaint;
	__property OnCollapse;
	__property OnEnter;
	__property OnExit;
	__property OnExpand;
	__property OnGetEditMask;
	__property OnGetEditText;
	__property OnGetEditLimit;
	__property OnItemChange;
	__property OnItemEditorChange;
	__property OnItemSelect;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnMouseWheel;
public:
	/* TO32CustomInspectorGrid.Create */ inline __fastcall virtual TO32InspectorGrid(System::Classes::TComponent* AOwner) : TO32CustomInspectorGrid(AOwner) { }
	/* TO32CustomInspectorGrid.Destroy */ inline __fastcall virtual ~TO32InspectorGrid(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32InspectorGrid(HWND ParentWindow) : TO32CustomInspectorGrid(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ScrollBarWidth = System::Int8(0x10);
}	/* namespace O32igrid */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32IGRID)
using namespace O32igrid;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32igridHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctccbx.pas' rev: 29.00 (Windows)

#ifndef OvctccbxHPP
#define OvctccbxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Vcl.Themes.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctccbx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCComboBoxEditOld;
class DELPHICLASS TOvcTCComboEdit;
class DELPHICLASS TOvcTCComboBoxEdit;
class DELPHICLASS TOvcTCCustomComboBox;
class DELPHICLASS TOvcTCComboBox;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcTCComboBoxState : unsigned char { otlbsUp, otlbsDown };

class PASCALIMPLEMENTATION TOvcTCComboBoxEditOld : public Vcl::Stdctrls::TCustomComboBox
{
	typedef Vcl::Stdctrls::TCustomComboBox inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	HWND EditField;
	void *PrevEditWndProc;
	void *NewEditWndProc;
	void __fastcall EditWindowProc(Winapi::Messages::TMessage &Msg);
	bool __fastcall FilterWMKEYDOWN(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall CMRelease(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
public:
	__fastcall virtual TOvcTCComboBoxEditOld(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTCComboBoxEditOld(void);
	virtual void __fastcall CreateWnd(void);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCComboBoxEditOld(HWND ParentWindow) : Vcl::Stdctrls::TCustomComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCComboEdit : public Vcl::Stdctrls::TEdit
{
	typedef Vcl::Stdctrls::TEdit inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	System::UnicodeString FFilter;
	bool __fastcall SelectItem(const System::UnicodeString AnItem);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TCustomEdit.Create */ inline __fastcall virtual TOvcTCComboEdit(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCComboEdit(HWND ParentWindow) : Vcl::Stdctrls::TEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TOvcTCComboEdit(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCComboBoxEdit : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	int FItemIndex;
	Ovctcell::TOvcBaseTableCell* FCell;
	int FMaxLength;
	System::Classes::TStrings* FItems;
	bool FSorted;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	int FDropDownCount;
	System::Classes::TNotifyEvent FOnChange;
	Vcl::Stdctrls::TDrawItemEvent FOnDrawItem;
	Vcl::Stdctrls::TMeasureItemEvent FOnMeasureItem;
	System::Classes::TNotifyEvent FOnDropDown;
	Ovctcmmn::TOvcCellAttributes FCellAttr;
	unsigned FCloseTime;
	bool FInUpdate;
	Vcl::Stdctrls::TListBox* FListBox;
	Ovcbase::TOvcPopupWindow* FDropDown;
	bool FIsDroppedDown;
	TOvcTCComboEdit* FEditControl;
	bool FAutoComplete;
	bool FAutoDropDown;
	unsigned FLastTime;
	unsigned FAutoCompleteDelay;
	System::UnicodeString FFilter;
	void __fastcall SetItemIndex(const int Value);
	void __fastcall SetDropDownCount(const int Value);
	void __fastcall SetItems(System::Classes::TStrings* const Value);
	void __fastcall SetMaxLength(const int Value);
	void __fastcall SetSorted(const bool Value);
	void __fastcall SetStyle(const Vcl::Stdctrls::TComboBoxStyle Value);
	void __fastcall SetCellAttr(const Ovctcmmn::TOvcCellAttributes &Value);
	void __fastcall ShowDropDown(void);
	void __fastcall ShowEdit(void);
	void __fastcall DropDownClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall ListBoxClick(System::TObject* Sender);
	void __fastcall ListBoxMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	__classmethod void __fastcall DrawText(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, bool Focused, System::UnicodeString AText);
	void __fastcall DrawBackground(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, bool Focused);
	__classmethod void __fastcall DrawButton(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &CellRect);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	void __fastcall UpdateEditPosition(void);
	void __fastcall EditChanged(System::TObject* Sender);
	void __fastcall SetAutoDropDown(const bool Value);
	
protected:
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	bool __fastcall SelectItem(const System::UnicodeString AnItem);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	virtual void __fastcall DestroyWindowHandle(void);
	virtual void __fastcall CreateWnd(void);
	
public:
	__fastcall virtual TOvcTCComboBoxEdit(System::Classes::TComponent* AOwner);
	MESSAGE void __fastcall CMRelease(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	__fastcall virtual ~TOvcTCComboBoxEdit(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property Ovctcmmn::TOvcCellAttributes CellAttr = {read=FCellAttr, write=SetCellAttr};
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, nodefault};
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
	__property int DropDownCount = {read=FDropDownCount, write=SetDropDownCount, default=8};
	__property int MaxLength = {read=FMaxLength, write=SetMaxLength, default=0};
	__property Vcl::Stdctrls::TComboBoxStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property bool Sorted = {read=FSorted, write=SetSorted, default=0};
	__property System::Classes::TStrings* Items = {read=FItems, write=SetItems};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property Vcl::Stdctrls::TDrawItemEvent OnDrawItem = {read=FOnDrawItem, write=FOnDrawItem};
	__property System::Classes::TNotifyEvent OnDropDown = {read=FOnDropDown, write=FOnDropDown};
	__property Vcl::Stdctrls::TMeasureItemEvent OnMeasureItem = {read=FOnMeasureItem, write=FOnMeasureItem};
	__property unsigned AutoCompleteDelay = {read=FAutoCompleteDelay, write=FAutoCompleteDelay, default=500};
	__property bool AutoComplete = {read=FAutoComplete, write=FAutoComplete, default=1};
	__property bool AutoDropDown = {read=FAutoDropDown, write=SetAutoDropDown, nodefault};
	__property Canvas;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCComboBoxEdit(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomComboBox : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	int FDropDownCount;
	TOvcTCComboBoxEdit* FEdit;
	System::Classes::TStrings* FItems;
	System::Word FMaxLength;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	bool FAutoAdvanceChar;
	bool FAutoAdvanceLeftRight;
	bool FHideButton;
	bool FSaveStringValue;
	bool FSorted;
	bool FShowArrow;
	bool FUseRunTimeItems;
	System::Classes::TNotifyEvent FOnChange;
	System::Classes::TNotifyEvent FOnDropDown;
	Vcl::Stdctrls::TDrawItemEvent FOnDrawItem;
	Vcl::Stdctrls::TMeasureItemEvent FOnMeasureItem;
	
private:
	System::UnicodeString FTextHint;
	void __fastcall SetTextHint(const System::UnicodeString Value);
	
protected:
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	void __fastcall SetShowArrow(bool Value);
	void __fastcall SetItems(System::Classes::TStrings* I);
	void __fastcall SetSorted(bool S);
	void __fastcall DrawArrow(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr);
	void __fastcall DrawButton(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &CellRect);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	__property bool AutoAdvanceChar = {read=FAutoAdvanceChar, write=FAutoAdvanceChar, nodefault};
	__property bool AutoAdvanceLeftRight = {read=FAutoAdvanceLeftRight, write=FAutoAdvanceLeftRight, nodefault};
	__property int DropDownCount = {read=FDropDownCount, write=FDropDownCount, nodefault};
	__property bool HideButton = {read=FHideButton, write=FHideButton, nodefault};
	__property System::Classes::TStrings* Items = {read=FItems, write=SetItems};
	__property System::Word MaxLength = {read=FMaxLength, write=FMaxLength, nodefault};
	__property bool SaveStringValue = {read=FSaveStringValue, write=FSaveStringValue, nodefault};
	__property bool Sorted = {read=FSorted, write=SetSorted, nodefault};
	__property bool ShowArrow = {read=FShowArrow, write=SetShowArrow, nodefault};
	__property Vcl::Stdctrls::TComboBoxStyle Style = {read=FStyle, write=FStyle, nodefault};
	__property bool UseRunTimeItems = {read=FUseRunTimeItems, write=FUseRunTimeItems, nodefault};
	__property System::UnicodeString TextHint = {read=FTextHint, write=SetTextHint};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property System::Classes::TNotifyEvent OnDropDown = {read=FOnDropDown, write=FOnDropDown};
	__property Vcl::Stdctrls::TDrawItemEvent OnDrawItem = {read=FOnDrawItem, write=FOnDrawItem};
	__property Vcl::Stdctrls::TMeasureItemEvent OnMeasureItem = {read=FOnMeasureItem, write=FOnMeasureItem};
	
public:
	__fastcall virtual TOvcTCCustomComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTCCustomComboBox(void);
	virtual TOvcTCComboBoxEdit* __fastcall CreateEditControl(void);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
};


class PASCALIMPLEMENTATION TOvcTCComboBox : public TOvcTCCustomComboBox
{
	typedef TOvcTCCustomComboBox inherited;
	
__published:
	__property AcceptActivationClick = {default=1};
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property AutoAdvanceChar = {default=0};
	__property AutoAdvanceLeftRight = {default=0};
	__property Color;
	__property DropDownCount = {default=8};
	__property Font;
	__property HideButton = {default=0};
	__property Hint = {default=0};
	__property Items;
	__property ShowHint = {default=0};
	__property Margin = {default=4};
	__property MaxLength = {default=0};
	__property SaveStringValue = {default=0};
	__property ShowArrow = {default=0};
	__property Sorted = {default=0};
	__property Style = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property TextHint = {default=0};
	__property UseRunTimeItems = {default=0};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawItem;
	__property OnDropDown;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMeasureItem;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
public:
	/* TOvcTCCustomComboBox.Create */ inline __fastcall virtual TOvcTCComboBox(System::Classes::TComponent* AOwner) : TOvcTCCustomComboBox(AOwner) { }
	/* TOvcTCCustomComboBox.Destroy */ inline __fastcall virtual ~TOvcTCComboBox(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Vcl::Graphics::TBitmap* OvcComboBoxBitmap;
extern DELPHI_PACKAGE int OvcComboBoxButtonWidth;
}	/* namespace Ovctccbx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCCBX)
using namespace Ovctccbx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctccbxHPP

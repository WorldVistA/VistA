// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32flxbn.pas' rev: 29.00 (Windows)

#ifndef O32flxbnHPP
#define O32flxbnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <ovcbase.hpp>
#include <ovcver.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.StdCtrls.hpp>
#include <O32MouseMon.hpp>
#include <ovcmisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32flxbn
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32FlxBtnPopMenu;
class DELPHICLASS TO32FlexButtonItem;
class DELPHICLASS TO32FlexButtonItems;
class DELPHICLASS TO32CustomFlexButton;
class DELPHICLASS TO32FlexButton;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32FlexButtonPopPosition : unsigned char { ppBottomLeft, ppBottomRight, ppTopLeft, ppTopRight };

typedef void __fastcall (__closure *TO32FlexButtonItemEvent)(System::TObject* Sender, int Item);

typedef void __fastcall (__closure *TO32FlexButtonItemChangeEvent)(System::TObject* Sender, int &OldItem, int &NewItem);

class PASCALIMPLEMENTATION TO32FlxBtnPopMenu : public Vcl::Grids::TDrawGrid
{
	typedef Vcl::Grids::TDrawGrid inherited;
	
protected:
	TO32CustomFlexButton* FFlexButton;
	System::Uitypes::TColor FBGColor;
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMGotFocus(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMLostFocus(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TO32FlxBtnPopMenu(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32FlxBtnPopMenu(void);
	__property System::Uitypes::TColor BGColor = {read=FBGColor, write=FBGColor, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32FlxBtnPopMenu(HWND ParentWindow) : Vcl::Grids::TDrawGrid(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32FlexButtonItem : public Ovcbase::TO32CollectionItem
{
	typedef Ovcbase::TO32CollectionItem inherited;
	
protected:
	TO32CustomFlexButton* FFlexButton;
	Vcl::Graphics::TBitmap* FGlyph;
	Vcl::Buttons::TButtonLayout FLayout;
	void __fastcall SetLayout(Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetCaption(void);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* Value);
	
public:
	__fastcall virtual TO32FlexButtonItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TO32FlexButtonItem(void);
	
__published:
	__property System::UnicodeString Caption = {read=GetCaption, write=SetCaption};
	__property Vcl::Buttons::TButtonLayout BtnLayout = {read=FLayout, write=SetLayout, nodefault};
	__property Vcl::Graphics::TBitmap* Glyph = {read=FGlyph, write=SetGlyph};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TO32FlexButtonItems : public Ovcbase::TO32Collection
{
	typedef Ovcbase::TO32Collection inherited;
	
protected:
	TO32CustomFlexButton* FFlexButton;
	
public:
	DYNAMIC TO32FlexButtonItem* __fastcall AddItem(const System::UnicodeString Name, const System::UnicodeString Caption, Vcl::Graphics::TBitmap* Glyph);
public:
	/* TO32Collection.Create */ inline __fastcall virtual TO32FlexButtonItems(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass) : Ovcbase::TO32Collection(AOwner, ItemClass) { }
	/* TO32Collection.Destroy */ inline __fastcall virtual ~TO32FlexButtonItems(void) { }
	
};


class PASCALIMPLEMENTATION TO32CustomFlexButton : public Vcl::Buttons::TBitBtn
{
	typedef Vcl::Buttons::TBitBtn inherited;
	
protected:
	Vcl::Graphics::TCanvas* FCanvas;
	TO32FlexButtonItems* FItems;
	bool FSmartPop;
	int FActiveItem;
	Vcl::Graphics::TBitmap* FPopGlyph;
	System::Types::TRect FPopRect;
	TO32FlexButtonPopPosition FPopPosition;
	int FPopAreaSize;
	TO32FlxBtnPopMenu* FPopupMenu;
	int FPopRowCount;
	int FPopWidth;
	bool FMenuActive;
	System::Uitypes::TColor FMenuColor;
	bool FMouseInMenu;
	bool FMenuFocused;
	bool FWheelSelection;
	TO32FlexButtonItemEvent FOnClick;
	System::Classes::TNotifyEvent FOnMenuPop;
	TO32FlexButtonItemChangeEvent FOnMenuClick;
	TO32FlexButtonItemChangeEvent FOnItemChange;
	bool fbPopupClicked;
	MESSAGE void __fastcall CMLostFocus(Winapi::Messages::TMessage &Message);
	void __fastcall MouseMonitor(const int MouseMessage, const int wParam, const int lParam, const System::Types::TPoint &ScreenPt, const HWND MouseWnd);
	HIDESBASE MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Message);
	System::UnicodeString __fastcall GetAbout(void);
	TO32FlexButtonItem* __fastcall GetItem(int Value);
	System::Uitypes::TColor __fastcall GetMenuColor(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetItem(int Value, TO32FlexButtonItem* const Item);
	void __fastcall SetMenuColor(System::Uitypes::TColor Value);
	void __fastcall SetPopGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetSelection(int Value);
	void __fastcall SetPopPosition(TO32FlexButtonPopPosition Value);
	void __fastcall SetWheelSelection(bool Value);
	void __fastcall DoMenuClick(int Selection);
	void __fastcall MouseInMenu(bool Value);
	void __fastcall MenuFocused(bool Value);
	void __fastcall IncrementItem(void);
	void __fastcall DecrementItem(void);
	void __fastcall DrawPopGlyph(const tagDRAWITEMSTRUCT &DrawItemStruct);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TO32CustomFlexButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomFlexButton(void);
	void __fastcall PopMenuOpen(void);
	void __fastcall PopMenuClose(void);
	DYNAMIC void __fastcall Click(void);
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property int ActiveItem = {read=FActiveItem, write=SetSelection, nodefault};
	__property TO32FlexButtonItem* Items[int Index] = {read=GetItem, write=SetItem};
	__property TO32FlexButtonItems* ItemCollection = {read=FItems, write=FItems};
	__property System::Uitypes::TColor MenuColor = {read=GetMenuColor, write=SetMenuColor, nodefault};
	__property TO32FlexButtonPopPosition PopPosition = {read=FPopPosition, write=SetPopPosition, nodefault};
	__property int PopAreaSize = {read=FPopAreaSize, write=FPopAreaSize, nodefault};
	__property Vcl::Graphics::TBitmap* PopGlyph = {read=FPopGlyph, write=SetPopGlyph};
	__property int PopRowCount = {read=FPopRowCount, write=FPopRowCount, nodefault};
	__property int PopWidth = {read=FPopWidth, write=FPopWidth, nodefault};
	__property bool SmartPop = {read=FSmartPop, write=FSmartPop, nodefault};
	__property bool WheelSelection = {read=FWheelSelection, write=SetWheelSelection, nodefault};
	__property TO32FlexButtonItemEvent OnClick = {read=FOnClick, write=FOnClick};
	__property System::Classes::TNotifyEvent OnMenuPop = {read=FOnMenuPop, write=FOnMenuPop};
	__property TO32FlexButtonItemChangeEvent OnMenuClick = {read=FOnMenuClick, write=FOnMenuClick};
	__property TO32FlexButtonItemChangeEvent OnItemChange = {read=FOnItemChange, write=FOnItemChange};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomFlexButton(HWND ParentWindow) : Vcl::Buttons::TBitBtn(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32FlexButton : public TO32CustomFlexButton
{
	typedef TO32CustomFlexButton inherited;
	
__published:
	__property About = {default=0};
	__property ActiveItem = {default=-1};
	__property ItemCollection;
	__property WheelSelection;
	__property MenuColor;
	__property PopPosition = {default=1};
	__property PopRowCount = {default=5};
	__property PopWidth = {default=125};
	__property SmartPop = {default=1};
	__property OnClick;
	__property OnMenuPop;
	__property OnMenuClick;
	__property OnItemChange;
public:
	/* TO32CustomFlexButton.Create */ inline __fastcall virtual TO32FlexButton(System::Classes::TComponent* AOwner) : TO32CustomFlexButton(AOwner) { }
	/* TO32CustomFlexButton.Destroy */ inline __fastcall virtual ~TO32FlexButton(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32FlexButton(HWND ParentWindow) : TO32CustomFlexButton(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32flxbn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32FLXBN)
using namespace O32flxbn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32flxbnHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcclrcb.pas' rev: 29.00 (Windows)

#ifndef OvcclrcbHPP
#define OvcclrcbHPP

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
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovccmbx.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <Vcl.Themes.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcclrcb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomColorComboBox;
class DELPHICLASS TOvcColorComboBox;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomColorComboBox : public Ovccmbx::TOvcBaseComboBox
{
	typedef Ovccmbx::TOvcBaseComboBox inherited;
	
protected:
	bool FShowColorNames;
	int BoxWidth;
	System::Uitypes::TColor __fastcall GetSelectedColor(void);
	void __fastcall SetSelectedColor(System::Uitypes::TColor Value);
	void __fastcall SetShowColorNames(bool Value);
	System::Uitypes::TColor __fastcall ColorFromString(System::UnicodeString Str);
	void __fastcall CalculateBoxWidth(void);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	virtual void __fastcall CreateWnd(void);
	__property System::Uitypes::TColor SelectedColor = {read=GetSelectedColor, write=SetSelectedColor, nodefault};
	__property bool ShowColorNames = {read=FShowColorNames, write=SetShowColorNames, default=1};
	
public:
	__fastcall virtual TOvcCustomColorComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomColorComboBox(void);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall DrawItemThemed(HDC DC, const Vcl::Themes::TThemedElementDetails &Details, int Index, const System::Types::TRect &Rect);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomColorComboBox(HWND ParentWindow) : Ovccmbx::TOvcBaseComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcColorComboBox : public TOvcCustomColorComboBox
{
	typedef TOvcCustomColorComboBox inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property Enabled = {default=1};
	__property Font;
	__property HotTrack = {default=0};
	__property ItemHeight;
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property SelectedColor = {default=0};
	__property ShowColorNames = {default=1};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Text = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnSelectionChange;
	__property OnStartDrag;
	__property OnMouseWheel;
public:
	/* TOvcCustomColorComboBox.Create */ inline __fastcall virtual TOvcColorComboBox(System::Classes::TComponent* AOwner) : TOvcCustomColorComboBox(AOwner) { }
	/* TOvcCustomColorComboBox.Destroy */ inline __fastcall virtual ~TOvcColorComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcColorComboBox(HWND ParentWindow) : TOvcCustomColorComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcclrcb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCLRCB)
using namespace Ovcclrcb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcclrcbHPP

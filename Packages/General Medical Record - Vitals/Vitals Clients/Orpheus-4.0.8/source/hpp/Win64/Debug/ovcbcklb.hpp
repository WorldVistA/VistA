// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbcklb.pas' rev: 29.00 (Windows)

#ifndef OvcbcklbHPP
#define OvcbcklbHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovclb.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbcklb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcBasicCheckList;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcBasicCheckList : public Ovclb::TOvcCustomListBox
{
	typedef Ovclb::TOvcCustomListBox inherited;
	
protected:
	bool FBoldX;
	System::Uitypes::TColor FBoxBackColor;
	bool FBoxClickOnly;
	System::Uitypes::TColor FBoxFrameColor;
	int FBoxMargin;
	bool FCheckMark;
	System::Uitypes::TColor FCheckXColor;
	System::Uitypes::TColor FGlyphMaskColor;
	bool FShowGlyphs;
	bool FWantDblClicks;
	Vcl::Graphics::TBitmap* __fastcall GetGlyphs(int Index);
	void __fastcall SetBoxBackColor(System::Uitypes::TColor Value);
	void __fastcall SetBoxFrameColor(System::Uitypes::TColor Value);
	void __fastcall SetBoxMargin(int Value);
	void __fastcall SetCheckMark(bool Value);
	void __fastcall SetGlyphMaskColor(System::Uitypes::TColor Value);
	void __fastcall SetGlyphs(int Index, Vcl::Graphics::TBitmap* Glyph);
	void __fastcall SetShowGlyphs(bool Value);
	void __fastcall SetWantDblClicks(bool Value);
	void __fastcall InvalidateItem(int Index);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Msg);
	Ovcbase::TOvcLabelPosition DefaultLabelPosition;
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	
public:
	__fastcall virtual TOvcBasicCheckList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBasicCheckList(void);
	__property Canvas;
	__property Vcl::Graphics::TBitmap* Glyphs[int Index] = {read=GetGlyphs, write=SetGlyphs};
	
__published:
	__property bool BoldX = {read=FBoldX, write=FBoldX, default=0};
	__property System::Uitypes::TColor BoxBackColor = {read=FBoxBackColor, write=SetBoxBackColor, default=-16777211};
	__property bool BoxClickOnly = {read=FBoxClickOnly, write=FBoxClickOnly, default=1};
	__property System::Uitypes::TColor BoxFrameColor = {read=FBoxFrameColor, write=SetBoxFrameColor, default=-16777208};
	__property int BoxMargin = {read=FBoxMargin, write=SetBoxMargin, default=2};
	__property bool CheckMark = {read=FCheckMark, write=SetCheckMark, default=0};
	__property System::Uitypes::TColor CheckXColor = {read=FCheckXColor, write=FCheckXColor, default=-16777208};
	__property System::Uitypes::TColor GlyphMaskColor = {read=FGlyphMaskColor, write=SetGlyphMaskColor, default=16777215};
	__property bool ShowGlyphs = {read=FShowGlyphs, write=SetShowGlyphs, default=0};
	__property bool WantDblClicks = {read=FWantDblClicks, write=SetWantDblClicks, default=1};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Align = {default=0};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Columns = {default=0};
	__property Controller;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property ExtendedSelect = {default=1};
	__property Font;
	__property HorizontalScroll = {default=0};
	__property IntegralHeight = {default=0};
	__property ItemHeight = {default=16};
	__property LabelInfo;
	__property MultiSelect = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Sorted = {default=0};
	__property TabOrder = {default=-1};
	__property TabStops;
	__property Items;
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property OnTabStopsChange;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBasicCheckList(HWND ParentWindow) : Ovclb::TOvcCustomListBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DefBoldX = false;
static const int DefBoxBackColor = int(-16777211);
static const bool DefBoxClickOnly = true;
static const int DefBoxFrameColor = int(-16777208);
static const System::Int8 DefBoxMargin = System::Int8(0x2);
static const bool DefCheckMark = false;
static const int DefCheckXColor = int(-16777208);
static const int DefGlyphMaskColor = int(16777215);
static const bool DefShowGlyphs = false;
static const bool DefWantDblClicks = true;
}	/* namespace Ovcbcklb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBCKLB)
using namespace Ovcbcklb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbcklbHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcftcbx.pas' rev: 29.00 (Windows)

#ifndef OvcftcbxHPP
#define OvcftcbxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Printers.hpp>
#include <ovccmbx.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.UITypes.hpp>
#include <ovcbase.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcftcbx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcFontComboBox;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TFontCategories : unsigned char { fcAll, fcTrueType, fcDevice };

enum DECLSPEC_DENUM TFontPitches : unsigned char { fpAll, fpFixed, fpVariable };

class PASCALIMPLEMENTATION TOvcFontComboBox : public Ovccmbx::TOvcBaseComboBox
{
	typedef Ovccmbx::TOvcBaseComboBox inherited;
	
protected:
	bool FPreviewFont;
	TFontCategories FCategories;
	TFontPitches FPitchStyles;
	Vcl::Controls::TControl* FPreviewControl;
	Vcl::Graphics::TBitmap* fcTTBitmap;
	Vcl::Graphics::TBitmap* fcDevBitmap;
	System::UnicodeString __fastcall GetFontName(void);
	void __fastcall SetFontName(const System::UnicodeString FontName);
	void __fastcall SetPreviewControl(Vcl::Controls::TControl* Value);
	bool __fastcall FontIsSymbol(const System::UnicodeString FontName);
	MESSAGE void __fastcall OMUpdatePreview(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CmFontChange(Winapi::Messages::TMessage &Message);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &ItemRect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Notification(System::Classes::TComponent* Component, System::Classes::TOperation Operation);
	void __fastcall DoPreview(void);
	
public:
	__fastcall virtual TOvcFontComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcFontComboBox(void);
	void __fastcall Populate(void);
	virtual void __fastcall SelectionChanged(void);
	__property System::UnicodeString FontName = {read=GetFontName, write=SetFontName};
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AutoSearch = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property Enabled = {default=1};
	__property Font;
	__property HotTrack = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ItemHeight;
	__property KeyDelay = {default=500};
	__property LabelInfo;
	__property MRUListColor = {default=-16777211};
	__property MRUListCount = {default=3};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Style = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property TFontCategories FontCategories = {read=FCategories, write=FCategories, default=0};
	__property TFontPitches FontPitchStyles = {read=FPitchStyles, write=FPitchStyles, default=0};
	__property Vcl::Controls::TControl* PreviewControl = {read=FPreviewControl, write=SetPreviewControl};
	__property bool PreviewFont = {read=FPreviewFont, write=FPreviewFont, default=0};
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
	__property OnSelectionChange;
	__property OnStartDrag;
	__property OnMouseWheel;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcFontComboBox(HWND ParentWindow) : Ovccmbx::TOvcBaseComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcftcbx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCFTCBX)
using namespace Ovcftcbx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcftcbxHPP

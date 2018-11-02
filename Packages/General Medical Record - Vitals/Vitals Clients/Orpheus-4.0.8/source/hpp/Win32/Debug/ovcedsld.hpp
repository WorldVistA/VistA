// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedsld.pas' rev: 29.00 (Windows)

#ifndef OvcedsldHPP
#define OvcedsldHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcedpop.hpp>
#include <ovcmisc.hpp>
#include <ovcslide.hpp>
#include <ovcexcpt.hpp>
#include <Winapi.Imm.hpp>
#include <ovceditf.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedsld
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomSliderEdit;
class DELPHICLASS TOvcSliderEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomSliderEdit : public Ovcedpop::TOvcEdPopup
{
	typedef Ovcedpop::TOvcEdPopup inherited;
	
protected:
	bool FAllowIncDec;
	Ovcslide::TOvcSlider* FSlider;
	bool FValidate;
	bool PopupClosing;
	System::Uitypes::TCursor HoldCursor;
	bool WasAutoScroll;
	double __fastcall GetAsFloat(void);
	int __fastcall GetAsInteger(void);
	System::UnicodeString __fastcall GetAsString(void);
	bool __fastcall GetPopupDrawMarks(void);
	int __fastcall GetPopupHeight(void);
	double __fastcall GetPopupMax(void);
	double __fastcall GetPopupMin(void);
	double __fastcall GetPopupStep(void);
	int __fastcall GetPopupWidth(void);
	HIDESBASE bool __fastcall GetReadOnly(void);
	void __fastcall SetAsFloat(const double Value);
	void __fastcall SetAsInteger(int Value);
	void __fastcall SetAsString(const System::UnicodeString Value);
	void __fastcall SetPopupDrawMarks(bool Value);
	void __fastcall SetPopupHeight(int Value);
	void __fastcall SetPopupMax(const double Value);
	void __fastcall SetPopupMin(const double Value);
	void __fastcall SetPopupStep(const double Value);
	void __fastcall SetPopupWidth(int Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall PopupChange(System::TObject* Sender);
	void __fastcall PopupKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PopupKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall PopupMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall WMImeComposition(Winapi::Messages::TMessage &Msg);
	DYNAMIC void __fastcall DoExit(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	__property bool AllowIncDec = {read=FAllowIncDec, write=FAllowIncDec, nodefault};
	__property int PopupHeight = {read=GetPopupHeight, write=SetPopupHeight, nodefault};
	__property bool PopupDrawMarks = {read=GetPopupDrawMarks, write=SetPopupDrawMarks, nodefault};
	__property double PopupMax = {read=GetPopupMax, write=SetPopupMax};
	__property double PopupMin = {read=GetPopupMin, write=SetPopupMin};
	__property double PopupStep = {read=GetPopupStep, write=SetPopupStep};
	__property int PopupWidth = {read=GetPopupWidth, write=SetPopupWidth, nodefault};
	__property bool Validate = {read=FValidate, write=FValidate, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	
public:
	__fastcall virtual TOvcCustomSliderEdit(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	__property int AsInteger = {read=GetAsInteger, write=SetAsInteger, nodefault};
	__property double AsFloat = {read=GetAsFloat, write=SetAsFloat};
	__property System::UnicodeString AsString = {read=GetAsString, write=SetAsString};
	__property Ovcslide::TOvcSlider* Slider = {read=FSlider};
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcCustomSliderEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomSliderEdit(HWND ParentWindow) : Ovcedpop::TOvcEdPopup(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSliderEdit : public TOvcCustomSliderEdit
{
	typedef TOvcCustomSliderEdit inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AllowIncDec = {default=0};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property ButtonGlyph;
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupAnchor = {default=0};
	__property PopupDrawMarks = {default=1};
	__property PopupHeight = {default=20};
	__property PopupMax = {default=0};
	__property PopupMenu;
	__property PopupMin = {default=0};
	__property PopupStep = {default=0};
	__property PopupWidth = {default=121};
	__property ReadOnly = {default=0};
	__property ShowButton = {default=1};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Validate = {default=0};
	__property Visible = {default=1};
	__property OnChange;
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
public:
	/* TOvcCustomSliderEdit.Create */ inline __fastcall virtual TOvcSliderEdit(System::Classes::TComponent* AOwner) : TOvcCustomSliderEdit(AOwner) { }
	
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcSliderEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSliderEdit(HWND ParentWindow) : TOvcCustomSliderEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcedsld */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDSLD)
using namespace Ovcedsld;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedsldHPP

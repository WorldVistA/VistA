// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcspeed.pas' rev: 29.00 (Windows)

#ifndef OvcspeedHPP
#define OvcspeedHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.ActnList.hpp>
#include <Vcl.ImgList.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcspeed
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomSpeedButton;
class DELPHICLASS TOvcSpeedButton;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcButtonState : unsigned char { obsUp, obsDown, obsInactive, obsDisabled };

class PASCALIMPLEMENTATION TOvcCustomSpeedButton : public Ovcbase::TOvcGraphicControl
{
	typedef Ovcbase::TOvcGraphicControl inherited;
	
protected:
	bool FAutoRepeat;
	bool FFlat;
	void *FGlyph;
	bool FGrayedInactive;
	int FRepeatDelay;
	Vcl::Buttons::TButtonLayout FLayout;
	int FMargin;
	int FRepeatInterval;
	int FSpacing;
	Vcl::Buttons::TButtonStyle FStyle;
	bool FTransparent;
	bool sbDown;
	Vcl::Graphics::TBitmap* sbDrawBM;
	bool sbMouseInControl;
	Vcl::Extctrls::TTimer* sbRepeatTimer;
	TOvcButtonState sbState;
	Vcl::Graphics::TBitmap* __fastcall GetGlyph(void);
	int __fastcall GetNumGlyphs(void);
	bool __fastcall GetWordWrap(void);
	void __fastcall SetAutoRepeat(bool Value);
	void __fastcall SetFlat(bool Value);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetGrayedInactive(bool Value);
	void __fastcall SetLayout(Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetMargin(int Value);
	void __fastcall SetNumGlyphs(int Value);
	void __fastcall SetSpacing(int Value);
	void __fastcall SetStyle(Vcl::Buttons::TButtonStyle Value);
	void __fastcall SetTransparent(bool Value);
	void __fastcall SetWordWrap(bool Value);
	void __fastcall GlyphChanged(System::TObject* Sender);
	void __fastcall UpdateTracking(void);
	void __fastcall TimerExpired(System::TObject* Sender);
	HIDESBASE void __fastcall DoMouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMSysColorChange(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Message);
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	__property bool AutoRepeat = {read=FAutoRepeat, write=SetAutoRepeat, nodefault};
	__property bool Flat = {read=FFlat, write=SetFlat, nodefault};
	__property Vcl::Graphics::TBitmap* Glyph = {read=GetGlyph, write=SetGlyph};
	__property bool GrayedInactive = {read=FGrayedInactive, write=SetGrayedInactive, nodefault};
	__property Vcl::Buttons::TButtonLayout Layout = {read=FLayout, write=SetLayout, nodefault};
	__property int Margin = {read=FMargin, write=SetMargin, nodefault};
	__property int NumGlyphs = {read=GetNumGlyphs, write=SetNumGlyphs, nodefault};
	__property int RepeatDelay = {read=FRepeatDelay, write=FRepeatDelay, nodefault};
	__property int RepeatInterval = {read=FRepeatInterval, write=FRepeatInterval, nodefault};
	__property int Spacing = {read=FSpacing, write=SetSpacing, nodefault};
	__property Vcl::Buttons::TButtonStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, nodefault};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, nodefault};
	
public:
	__fastcall virtual TOvcCustomSpeedButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomSpeedButton(void);
	void __fastcall SimulatedClick(void);
};


class PASCALIMPLEMENTATION TOvcSpeedButton : public TOvcCustomSpeedButton
{
	typedef TOvcCustomSpeedButton inherited;
	
__published:
	__property AutoRepeat = {default=0};
	__property Flat = {default=0};
	__property Glyph;
	__property GrayedInactive = {default=1};
	__property Layout = {default=2};
	__property Margin = {default=-1};
	__property NumGlyphs = {default=1};
	__property RepeatDelay = {default=500};
	__property RepeatInterval = {default=100};
	__property Spacing = {default=1};
	__property Style = {default=0};
	__property Transparent = {default=0};
	__property WordWrap = {default=0};
	__property Action;
	__property Anchors = {default=3};
	__property Constraints;
	__property Caption = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=0};
	__property ShowHint = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TOvcCustomSpeedButton.Create */ inline __fastcall virtual TOvcSpeedButton(System::Classes::TComponent* AOwner) : TOvcCustomSpeedButton(AOwner) { }
	/* TOvcCustomSpeedButton.Destroy */ inline __fastcall virtual ~TOvcSpeedButton(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcspeed */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSPEED)
using namespace Ovcspeed;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcspeedHPP

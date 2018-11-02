// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrlbl.pas' rev: 29.00 (Windows)

#ifndef OvcrlblHPP
#define OvcrlblHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrlbl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomRotatedLabel;
class DELPHICLASS TOvcRotatedLabel;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomRotatedLabel : public Ovcbase::TOvcGraphicControl
{
	typedef Ovcbase::TOvcGraphicControl inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	bool FAutoSize;
	System::UnicodeString FCaption;
	int FFontAngle;
	int FOriginX;
	int FOriginY;
	System::Uitypes::TColor FShadowColor;
	bool FShadowedText;
	bool rlBusy;
	bool __fastcall GetTransparent(void);
	void __fastcall SetAlignment(System::Classes::TAlignment Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetOriginX(int Value);
	void __fastcall SetOriginY(int Value);
	void __fastcall SetShadowColor(const System::Uitypes::TColor Value);
	void __fastcall SetShadowedText(bool Value);
	void __fastcall SetTransparent(bool Value);
	void __fastcall SetFontAngle(int Value);
	void __fastcall lblAdjustSize(void);
	void __fastcall lblDrawText(System::Types::TRect &R, System::Word Flags);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Mes);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, nodefault};
	__property bool AutoSize = {read=FAutoSize, write=SetAutoSize, nodefault};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property int FontAngle = {read=FFontAngle, write=SetFontAngle, nodefault};
	__property int OriginX = {read=FOriginX, write=SetOriginX, nodefault};
	__property int OriginY = {read=FOriginY, write=SetOriginY, nodefault};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=SetShadowColor, nodefault};
	__property bool ShadowedText = {read=FShadowedText, write=SetShadowedText, nodefault};
	__property bool Transparent = {read=GetTransparent, write=SetTransparent, nodefault};
	
public:
	__fastcall virtual TOvcCustomRotatedLabel(System::Classes::TComponent* AOwner);
	__property Canvas;
public:
	/* TOvcGraphicControl.Destroy */ inline __fastcall virtual ~TOvcCustomRotatedLabel(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRotatedLabel : public TOvcCustomRotatedLabel
{
	typedef TOvcCustomRotatedLabel inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property AutoSize;
	__property Caption;
	__property Color = {default=-16777211};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property FontAngle = {default=0};
	__property Height = {default=20};
	__property OriginX = {default=0};
	__property OriginY = {default=0};
	__property ParentColor = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShadowColor = {default=-16777200};
	__property ShadowedText;
	__property ShowHint;
	__property Transparent = {default=0};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TOvcCustomRotatedLabel.Create */ inline __fastcall virtual TOvcRotatedLabel(System::Classes::TComponent* AOwner) : TOvcCustomRotatedLabel(AOwner) { }
	
public:
	/* TOvcGraphicControl.Destroy */ inline __fastcall virtual ~TOvcRotatedLabel(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcrlbl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRLBL)
using namespace Ovcrlbl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrlblHPP

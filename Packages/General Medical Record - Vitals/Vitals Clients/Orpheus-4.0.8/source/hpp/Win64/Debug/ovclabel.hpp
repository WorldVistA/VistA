// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovclabel.pas' rev: 29.00 (Windows)

#ifndef OvclabelHPP
#define OvclabelHPP

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
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcmisc.hpp>
#include <ovcver.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovclabel
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomSettings;
class DELPHICLASS TOvcCustomLabel;
class DELPHICLASS TOvcLabel;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcAppearance : unsigned char { apNone, apCustom, apFlying, apRaised, apSunken, apShadow };

enum DECLSPEC_DENUM TOvcColorScheme : unsigned char { csCustom, csText, csWindows, csEmbossed, csGold, csSteel };

enum DECLSPEC_DENUM TOvcGraduateStyle : unsigned char { gsNone, gsHorizontal, gsVertical };

enum DECLSPEC_DENUM TOvcShadeDirection : unsigned char { sdNone, sdUp, sdUpRight, sdRight, sdDownRight, sdDown, sdDownLeft, sdLeft, sdUpLeft };

enum DECLSPEC_DENUM TOvcShadeStyle : unsigned char { ssPlain, ssExtrude, ssGraduated };

typedef System::Byte TOvcDepth;

class PASCALIMPLEMENTATION TOvcCustomSettings : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FGraduateFromColor;
	TOvcGraduateStyle FGraduateStyle;
	System::Uitypes::TColor FHighlightColor;
	TOvcDepth FHighlightDepth;
	TOvcShadeDirection FHighlightDirection;
	TOvcShadeStyle FHighlightStyle;
	System::Uitypes::TColor FShadowColor;
	TOvcDepth FShadowDepth;
	TOvcShadeDirection FShadowDirection;
	TOvcShadeStyle FShadowStyle;
	System::Classes::TNotifyEvent FOnColorChange;
	System::Classes::TNotifyEvent FOnStyleChange;
	bool FUpdating;
	void __fastcall DoOnColorChange(void);
	void __fastcall DoOnStyleChange(void);
	void __fastcall SetGraduateFromColor(System::Uitypes::TColor Value);
	void __fastcall SetGraduateStyle(TOvcGraduateStyle Value);
	void __fastcall SetHighlightColor(System::Uitypes::TColor Value);
	void __fastcall SetHighlightDepth(TOvcDepth Value);
	void __fastcall SetHighlightDirection(TOvcShadeDirection Value);
	void __fastcall SetHighlightStyle(TOvcShadeStyle Value);
	void __fastcall SetShadowColor(System::Uitypes::TColor Value);
	void __fastcall SetShadowDepth(TOvcDepth Value);
	void __fastcall SetShadowDirection(TOvcShadeDirection Value);
	void __fastcall SetShadowStyle(TOvcShadeStyle Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	__property System::Classes::TNotifyEvent OnColorChange = {read=FOnColorChange, write=FOnColorChange};
	__property System::Classes::TNotifyEvent OnStyleChange = {read=FOnStyleChange, write=FOnStyleChange};
	
__published:
	__property System::Uitypes::TColor GraduateFromColor = {read=FGraduateFromColor, write=SetGraduateFromColor, default=8421504};
	__property TOvcGraduateStyle GraduateStyle = {read=FGraduateStyle, write=SetGraduateStyle, default=0};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=16777215};
	__property TOvcDepth HighlightDepth = {read=FHighlightDepth, write=SetHighlightDepth, default=1};
	__property TOvcShadeDirection HighlightDirection = {read=FHighlightDirection, write=SetHighlightDirection, default=8};
	__property TOvcShadeStyle HighlightStyle = {read=FHighlightStyle, write=SetHighlightStyle, default=0};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=SetShadowColor, default=0};
	__property TOvcDepth ShadowDepth = {read=FShadowDepth, write=SetShadowDepth, default=1};
	__property TOvcShadeDirection ShadowDirection = {read=FShadowDirection, write=SetShadowDirection, default=4};
	__property TOvcShadeStyle ShadowStyle = {read=FShadowStyle, write=SetShadowStyle, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcCustomSettings(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcCustomSettings(void) : System::Classes::TPersistent() { }
	
};


class PASCALIMPLEMENTATION TOvcCustomLabel : public Vcl::Stdctrls::TCustomLabel
{
	typedef Vcl::Stdctrls::TCustomLabel inherited;
	
	
private:
	enum DECLSPEC_DENUM _TOvcCustomLabel__1 : unsigned char { cpHighlight, cpShadow, cpFace };
	
	
protected:
	TOvcAppearance FAppearance;
	TOvcColorScheme FColorScheme;
	TOvcCustomSettings* FCustomSettings;
	System::StaticArray<System::StaticArray<System::Uitypes::TColor, 3>, 6> eslSchemes;
	bool SettingColorScheme;
	bool SettingAppearance;
	System::UnicodeString __fastcall GetAbout(void);
	bool __fastcall GetWordWrap(void);
	void __fastcall SetAppearance(TOvcAppearance Value);
	void __fastcall SetColorScheme(TOvcColorScheme Value);
	HIDESBASE void __fastcall SetWordWrap(bool Value);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall PaintPrim(const System::Types::TRect &CR, System::Word Flags);
	void __fastcall ColorChanged(System::TObject* Sender);
	void __fastcall StyleChanged(System::TObject* Sender);
	virtual void __fastcall Paint(void);
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property TOvcAppearance Appearance = {read=FAppearance, write=SetAppearance, default=3};
	__property TOvcColorScheme ColorScheme = {read=FColorScheme, write=SetColorScheme, default=2};
	__property TOvcCustomSettings* CustomSettings = {read=FCustomSettings, write=FCustomSettings};
	__property bool WordWrap = {read=GetWordWrap, write=SetWordWrap, default=1};
	
public:
	__fastcall virtual TOvcCustomLabel(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomLabel(void);
	void __fastcall PaintTo(HDC DC, const System::Types::TRect &CR, System::Word Flags);
	__property AutoSize = {default=1};
};


class PASCALIMPLEMENTATION TOvcLabel : public TOvcCustomLabel
{
	typedef TOvcCustomLabel inherited;
	
__published:
	__property About = {default=0};
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property Anchors = {default=3};
	__property Appearance = {default=3};
	__property Caption = {default=0};
	__property Color = {default=-16777211};
	__property ColorScheme = {default=2};
	__property Cursor = {default=0};
	__property CustomSettings;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property FocusControl;
	__property Font;
	__property ParentColor = {default=1};
	__property ParentFont = {default=0};
	__property ParentShowHint = {default=1};
	__property ShowAccelChar = {default=1};
	__property ShowHint;
	__property Transparent = {default=1};
	__property Visible = {default=1};
	__property WordWrap = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TOvcCustomLabel.Create */ inline __fastcall virtual TOvcLabel(System::Classes::TComponent* AOwner) : TOvcCustomLabel(AOwner) { }
	/* TOvcCustomLabel.Destroy */ inline __fastcall virtual ~TOvcLabel(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const TOvcAppearance lblDefAppearance = (TOvcAppearance)(3);
static const bool lblDefAutoSize = false;
static const TOvcColorScheme lblDefColorScheme = (TOvcColorScheme)(2);
#define lblDefFontName L"Times New Roman"
static const System::Int8 lblDefFontSize = System::Int8(0x14);
static const int lblDefGraduateFromColor = int(8421504);
static const TOvcGraduateStyle lblDefGraduateStyle = (TOvcGraduateStyle)(0);
static const int lblDefHighlightColor = int(16777215);
static const System::Int8 lblDefHighlightDepth = System::Int8(0x1);
static const TOvcShadeDirection lblDefHighlightDirection = (TOvcShadeDirection)(8);
static const TOvcShadeStyle lblDefHighlightStyle = (TOvcShadeStyle)(0);
static const int lblDefShadowColor = int(0);
static const System::Int8 lblDefShadowDepth = System::Int8(0x1);
static const TOvcShadeDirection lblDefShadowDirection = (TOvcShadeDirection)(4);
static const TOvcShadeStyle lblDefShadowStyle = (TOvcShadeStyle)(0);
static const bool lblDefTransparent = true;
static const bool lblDefWordWrap = true;
}	/* namespace Ovclabel */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCLABEL)
using namespace Ovclabel;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvclabelHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcmeter.pas' rev: 29.00 (Windows)

#ifndef OvcmeterHPP
#define OvcmeterHPP

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
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcmeter
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomMeter;
class DELPHICLASS TOvcMeter;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOvcOwnerDrawMeterEvent)(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Rec);

enum DECLSPEC_DENUM TMeterOrientation : unsigned char { moHorizontal, moVertical };

class PASCALIMPLEMENTATION TOvcCustomMeter : public Ovcbase::TOvcGraphicControl
{
	typedef Ovcbase::TOvcGraphicControl inherited;
	
protected:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FCtl3D;
	bool FInvertPercent;
	TMeterOrientation FOrientation;
	int FPercent;
	bool FShowPercent;
	System::Uitypes::TColor FUsedColor;
	System::Uitypes::TColor FUnusedColor;
	Vcl::Graphics::TBitmap* FUnusedImage;
	Vcl::Graphics::TBitmap* FUsedImage;
	TOvcOwnerDrawMeterEvent FOwnerDraw;
	Vcl::Graphics::TBitmap* MemBM;
	Vcl::Graphics::TBitmap* TxtBM;
	System::UnicodeString ValueString;
	int __fastcall PercentValue(void);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetCtl3D(const bool Value);
	void __fastcall SetInvertPercent(bool Value);
	void __fastcall SetOrientation(const TMeterOrientation O);
	void __fastcall SetPercent(const int Value);
	void __fastcall SetShowPercent(const bool SP);
	void __fastcall SetUnusedColor(const System::Uitypes::TColor C);
	void __fastcall SetUnusedImage(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetUsedColor(const System::Uitypes::TColor C);
	void __fastcall SetUsedImage(Vcl::Graphics::TBitmap* Value);
	virtual void __fastcall Paint(void);
	
public:
	__fastcall virtual TOvcCustomMeter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomMeter(void);
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property Canvas;
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, default=1};
	__property bool InvertPercent = {read=FInvertPercent, write=SetInvertPercent, default=1};
	__property TMeterOrientation Orientation = {read=FOrientation, write=SetOrientation, default=0};
	__property bool ShowPercent = {read=FShowPercent, write=SetShowPercent, default=0};
	__property System::Uitypes::TColor UnusedColor = {read=FUnusedColor, write=SetUnusedColor, default=-16777211};
	__property Vcl::Graphics::TBitmap* UnusedImage = {read=FUnusedImage, write=SetUnusedImage};
	__property System::Uitypes::TColor UsedColor = {read=FUsedColor, write=SetUsedColor, default=65280};
	__property Vcl::Graphics::TBitmap* UsedImage = {read=FUsedImage, write=SetUsedImage};
	__property int Percent = {read=FPercent, write=SetPercent, default=33};
	__property TOvcOwnerDrawMeterEvent OnOwnerDraw = {read=FOwnerDraw, write=FOwnerDraw};
};


class PASCALIMPLEMENTATION TOvcMeter : public TOvcCustomMeter
{
	typedef TOvcCustomMeter inherited;
	
__published:
	__property BorderStyle = {default=1};
	__property Ctl3D = {default=1};
	__property InvertPercent = {default=1};
	__property Orientation = {default=0};
	__property Percent = {default=33};
	__property ShowPercent = {default=0};
	__property UnusedColor = {default=-16777211};
	__property UnusedImage;
	__property UsedColor = {default=65280};
	__property UsedImage;
	__property Anchors = {default=3};
	__property Constraints;
	__property Align = {default=0};
	__property Font;
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
public:
	/* TOvcCustomMeter.Create */ inline __fastcall virtual TOvcMeter(System::Classes::TComponent* AOwner) : TOvcCustomMeter(AOwner) { }
	/* TOvcCustomMeter.Destroy */ inline __fastcall virtual ~TOvcMeter(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcmeter */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCMETER)
using namespace Ovcmeter;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcmeterHPP

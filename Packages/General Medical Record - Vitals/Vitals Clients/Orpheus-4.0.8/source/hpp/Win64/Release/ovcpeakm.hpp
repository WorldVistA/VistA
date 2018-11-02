// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcpeakm.pas' rev: 29.00 (Windows)

#ifndef OvcpeakmHPP
#define OvcpeakmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <Vcl.ExtCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcpeakm
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcPeakMeter;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<int, 536870911> TIntArray;

typedef TIntArray *PIntArray;

enum DECLSPEC_DENUM TOvcPmStyle : unsigned char { pmBar, pmHistoryPoint };

class PASCALIMPLEMENTATION TOvcPeakMeter : public Ovcbase::TOvcGraphicControl
{
	typedef Ovcbase::TOvcGraphicControl inherited;
	
protected:
	System::Uitypes::TColor FBackgroundColor;
	System::Uitypes::TColor FBarColor;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FCtl3D;
	bool FEnabled;
	System::Uitypes::TColor FGridColor;
	TIntArray *FHistory;
	int FInitialMax;
	int FMarginTop;
	int FMarginBottom;
	int FMarginLeft;
	int FMarginRight;
	int FPeak;
	System::Uitypes::TColor FPeakColor;
	int FScaleMargin;
	bool FShowValues;
	TOvcPmStyle FStyle;
	int FValue;
	int HistorySize;
	Vcl::Graphics::TBitmap* MemBM;
	void __fastcall ResizeHistory(int NewSize);
	virtual void __fastcall Paint(void);
	void __fastcall SetBackgroundColor(const System::Uitypes::TColor C);
	void __fastcall SetBarColor(const System::Uitypes::TColor Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetCtl3D(const bool Value);
	void __fastcall SetGridColor(const System::Uitypes::TColor Value);
	void __fastcall SetMarginTop(int Value);
	void __fastcall SetMarginBottom(int Value);
	void __fastcall SetMarginLeft(int Value);
	void __fastcall SetMarginRight(int Value);
	void __fastcall SetPeak(int Value);
	void __fastcall SetPeakColor(const System::Uitypes::TColor Value);
	void __fastcall SetShowValues(bool Value);
	void __fastcall SetStyle(TOvcPmStyle Value);
	void __fastcall SetValue(int Value);
	
public:
	__fastcall virtual TOvcPeakMeter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcPeakMeter(void);
	__property int Peak = {read=FPeak, write=SetPeak, nodefault};
	
__published:
	__property System::Uitypes::TColor BackgroundColor = {read=FBackgroundColor, write=SetBackgroundColor, default=-16777201};
	__property System::Uitypes::TColor BarColor = {read=FBarColor, write=SetBarColor, default=16711680};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property bool Ctl3D = {read=FCtl3D, write=SetCtl3D, default=1};
	__property System::Uitypes::TColor GridColor = {read=FGridColor, write=SetGridColor, default=0};
	__property int MarginBottom = {read=FMarginBottom, write=SetMarginBottom, default=10};
	__property int MarginLeft = {read=FMarginLeft, write=SetMarginLeft, default=10};
	__property int MarginRight = {read=FMarginRight, write=SetMarginRight, default=10};
	__property int MarginTop = {read=FMarginTop, write=SetMarginTop, default=10};
	__property System::Uitypes::TColor PeakColor = {read=FPeakColor, write=SetPeakColor, default=255};
	__property bool ShowValues = {read=FShowValues, write=SetShowValues, default=1};
	__property TOvcPmStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property int Value = {read=FValue, write=SetValue, default=0};
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
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcpeakm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCPEAKM)
using namespace Ovcpeakm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcpeakmHPP

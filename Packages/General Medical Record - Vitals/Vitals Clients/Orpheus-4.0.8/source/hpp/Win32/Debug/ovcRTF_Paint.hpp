// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcRTF_Paint.pas' rev: 29.00 (Windows)

#ifndef Ovcrtf_paintHPP
#define Ovcrtf_paintHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcRTF_TOM.hpp>
#include <ovcRTF_IText.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrtf_paint
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcRTFPainter;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRTFPainter : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Ovcrtf_tom::_di_ITextServices FServices;
	Ovcrtf_tom::TTextHostImpl* FHostImpl;
	Ovcrtf_tom::_di_ITextHost FHost;
	
public:
	__fastcall TOvcRTFPainter(void);
	__fastcall virtual ~TOvcRTFPainter(void);
	Ovcrtf_itext::_di_ITextDocument __fastcall GetDoc(void);
	void __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Rect, const bool Transparent, const bool WordWrap);
	int __fastcall GetDrawHeight(Vcl::Graphics::TCanvas* Canvas, int DrawWidth);
	System::Types::TSize __fastcall GetDrawExtent(Vcl::Graphics::TCanvas* Canvas, int DrawWidth);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall DrawRTF(Vcl::Graphics::TCanvas* Canvas, const System::UnicodeString RTF, const System::Types::TRect &Rect, const bool Transparent, const bool WordWrap);
}	/* namespace Ovcrtf_paint */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRTF_PAINT)
using namespace Ovcrtf_paint;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcrtf_paintHPP

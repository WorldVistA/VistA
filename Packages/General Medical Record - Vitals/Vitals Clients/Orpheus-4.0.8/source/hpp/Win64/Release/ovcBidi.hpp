// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcBidi.pas' rev: 29.00 (Windows)

#ifndef OvcbidiHPP
#define OvcbidiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbidi
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Word WS_EX_RIGHT = System::Word(0x1000);
static const System::Int8 WS_EX_LEFT = System::Int8(0x0);
static const System::Word WS_EX_RTLREADING = System::Word(0x2000);
static const System::Int8 WS_EX_LTRREADING = System::Int8(0x0);
static const System::Word WS_EX_LEFTSCROLLBAR = System::Word(0x4000);
static const System::Int8 WS_EX_RIGHTSCROLLBAR = System::Int8(0x0);
static const System::Int8 LAYOUT_RTL = System::Int8(0x1);
static const System::Int8 LAYOUT_BTT = System::Int8(0x2);
static const System::Int8 LAYOUT_VBH = System::Int8(0x4);
static const System::Int8 LAYOUT_ORIENTATIONMASK = System::Int8(0x7);
static const System::Int8 LAYOUT_BITMAPORIENTATIONPRESERVED = System::Int8(0x8);
static const unsigned NOMIRRORBITMAP = unsigned(0x80000000);
extern "C" System::LongBool __stdcall GetProcessDefaultLayout(/* out */ unsigned &pdwDefaultLayout);
extern "C" System::LongBool __stdcall SetProcessDefaultLayout(unsigned dwDefaultLayout);
extern "C" unsigned __stdcall SetLayout(HDC dc, unsigned dwLayout);
extern "C" unsigned __stdcall GetLayout(HDC dc);
extern DELPHI_PACKAGE bool __fastcall IsBidi(void);
}	/* namespace Ovcbidi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBIDI)
using namespace Ovcbidi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbidiHPP

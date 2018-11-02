// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'O32MouseMon.pas' rev: 29.00 (Windows)

#ifndef O32mousemonHPP
#define O32mousemonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <ovcmisc.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32mousemon
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TMouseMonHandler)(const int MouseMessage, const int wParam, const int lParam, const System::Types::TPoint ScreenPt, const HWND MouseWnd);

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall StartMouseMonitor(TMouseMonHandler Callback);
extern DELPHI_PACKAGE void __fastcall StopMouseMonitor(TMouseMonHandler Callback);
}	/* namespace O32mousemon */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32MOUSEMON)
using namespace O32mousemon;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32mousemonHPP

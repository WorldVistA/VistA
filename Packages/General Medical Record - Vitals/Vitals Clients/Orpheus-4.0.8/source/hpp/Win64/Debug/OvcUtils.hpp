// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OvcUtils.pas' rev: 29.00 (Windows)

#ifndef OvcutilsHPP
#define OvcutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall StripCharSeq(System::UnicodeString CharSeq, System::UnicodeString &Str);
extern DELPHI_PACKAGE void __fastcall StripCharFromEnd(System::WideChar Chr, System::UnicodeString &Str);
extern DELPHI_PACKAGE void __fastcall StripCharFromFront(System::WideChar Chr, System::UnicodeString &Str);
}	/* namespace Ovcutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCUTILS)
using namespace Ovcutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcutilsHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcvalid.pas' rev: 29.00 (Windows)

#ifndef OvcvalidHPP
#define OvcvalidHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <ovcpb.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcvalid
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::WideChar PartialChar = (System::WideChar)(0x70);
static const System::WideChar ReqdChar = (System::WideChar)(0x72);
static const System::WideChar UnlessChar = (System::WideChar)(0x75);
extern DELPHI_PACKAGE System::Word __fastcall ValidateNoBlanks(Ovcpb::TOvcPictureBase* EF);
extern DELPHI_PACKAGE System::Word __fastcall ValidateNotPartial(Ovcpb::TOvcPictureBase* EF);
extern DELPHI_PACKAGE System::Word __fastcall ValidateSubfields(Ovcpb::TOvcPictureBase* EF, const System::UnicodeString SubfieldMask);
}	/* namespace Ovcvalid */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCVALID)
using namespace Ovcvalid;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcvalidHPP

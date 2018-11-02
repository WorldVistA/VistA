// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcThemes.pas' rev: 29.00 (Windows)

#ifndef OvcthemesHPP
#define OvcthemesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Themes.hpp>
#include <Winapi.UxTheme.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcthemes
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TovcThemes;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TovcThemes : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod void __fastcall DrawSelection(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &ARect);
public:
	/* TObject.Create */ inline __fastcall TovcThemes(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TovcThemes(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcthemes */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTHEMES)
using namespace Ovcthemes;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcthemesHPP

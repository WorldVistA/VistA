// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccolor.pas' rev: 29.00 (Windows)

#ifndef OvccolorHPP
#define OvccolorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccolor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcColors;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Uitypes::TColor FBackColor;
	System::Uitypes::TColor FTextColor;
	bool FUseDefault;
	System::Classes::TNotifyEvent FOnColorChange;
	System::Uitypes::TColor cDefBackColor;
	System::Uitypes::TColor cDefTextColor;
	void __fastcall SetBackColor(System::Uitypes::TColor Value);
	void __fastcall SetTextColor(System::Uitypes::TColor Value);
	void __fastcall SetUseDefault(bool Value);
	void __fastcall ReadUseDefault(System::Classes::TReader* Reader);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	DYNAMIC void __fastcall DoOnColorChange(void);
	DYNAMIC void __fastcall ResetToDefaultColors(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcColors(System::Uitypes::TColor FG, System::Uitypes::TColor BG);
	__property System::Classes::TNotifyEvent OnColorChange = {read=FOnColorChange, write=FOnColorChange};
	
__published:
	__property System::Uitypes::TColor BackColor = {read=FBackColor, write=SetBackColor, nodefault};
	__property System::Uitypes::TColor TextColor = {read=FTextColor, write=SetTextColor, nodefault};
	__property bool UseDefault = {read=FUseDefault, write=SetUseDefault, stored=false, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcColors(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovccolor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCOLOR)
using namespace Ovccolor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccolorHPP

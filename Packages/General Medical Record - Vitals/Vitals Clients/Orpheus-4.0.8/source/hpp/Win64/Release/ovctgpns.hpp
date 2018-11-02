// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctgpns.pas' rev: 29.00 (Windows)

#ifndef OvctgpnsHPP
#define OvctgpnsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctgpns
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcGridPen;
class DELPHICLASS TOvcGridPenSet;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TGridEffect : unsigned char { geNone, geVertical, geHorizontal, geBoth, ge3D };

class PASCALIMPLEMENTATION TOvcGridPen : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Uitypes::TColor FNormalColor;
	System::Uitypes::TColor FSecondColor;
	TGridEffect FEffect;
	Vcl::Graphics::TPenStyle FStyle;
	System::Classes::TNotifyEvent FOnCfgChanged;
	void __fastcall SetNormalColor(System::Uitypes::TColor C);
	void __fastcall SetSecondColor(System::Uitypes::TColor C);
	void __fastcall SetEffect(TGridEffect E);
	void __fastcall SetStyle(Vcl::Graphics::TPenStyle S);
	void __fastcall DoCfgChanged(void);
	
public:
	__property System::Classes::TNotifyEvent OnCfgChanged = {read=FOnCfgChanged, write=FOnCfgChanged};
	__fastcall TOvcGridPen(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::Uitypes::TColor NormalColor = {read=FNormalColor, write=SetNormalColor, nodefault};
	__property System::Uitypes::TColor SecondColor = {read=FSecondColor, write=SetSecondColor, default=-16777196};
	__property Vcl::Graphics::TPenStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property TGridEffect Effect = {read=FEffect, write=SetEffect, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcGridPen(void) { }
	
};


class PASCALIMPLEMENTATION TOvcGridPenSet : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcGridPen* FNormalGrid;
	TOvcGridPen* FLockedGrid;
	TOvcGridPen* FCellWhenFocused;
	TOvcGridPen* FCellWhenUnfocused;
	void __fastcall SetOnCfgChanged(System::Classes::TNotifyEvent OC);
	
public:
	__property System::Classes::TNotifyEvent OnCfgChanged = {write=SetOnCfgChanged};
	__fastcall TOvcGridPenSet(void);
	__fastcall virtual ~TOvcGridPenSet(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TOvcGridPen* NormalGrid = {read=FNormalGrid, write=FNormalGrid};
	__property TOvcGridPen* LockedGrid = {read=FLockedGrid, write=FLockedGrid};
	__property TOvcGridPen* CellWhenFocused = {read=FCellWhenFocused, write=FCellWhenFocused};
	__property TOvcGridPen* CellWhenUnfocused = {read=FCellWhenUnfocused, write=FCellWhenUnfocused};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctgpns */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTGPNS)
using namespace Ovctgpns;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctgpnsHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctbclr.pas' rev: 29.00 (Windows)

#ifndef OvctbclrHPP
#define OvctbclrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctbclr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTableColors;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTableColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Uitypes::TColor FLocked;
	System::Uitypes::TColor FLockedText;
	System::Uitypes::TColor FActiveFocused;
	System::Uitypes::TColor FActiveFocusedText;
	System::Uitypes::TColor FActiveUnfocused;
	System::Uitypes::TColor FActiveUnfocusedText;
	System::Uitypes::TColor FEditing;
	System::Uitypes::TColor FEditingText;
	System::Uitypes::TColor FSelected;
	System::Uitypes::TColor FSelectedText;
	System::Classes::TNotifyEvent FOnCfgChanged;
	void __fastcall SetLocked(System::Uitypes::TColor C);
	void __fastcall SetLockedText(System::Uitypes::TColor C);
	void __fastcall SetActiveFocused(System::Uitypes::TColor C);
	void __fastcall SetActiveFocusedText(System::Uitypes::TColor C);
	void __fastcall SetActiveUnfocused(System::Uitypes::TColor C);
	void __fastcall SetActiveUnfocusedText(System::Uitypes::TColor C);
	void __fastcall SetEditing(System::Uitypes::TColor C);
	void __fastcall SetEditingText(System::Uitypes::TColor C);
	void __fastcall SetSelected(System::Uitypes::TColor C);
	void __fastcall SetSelectedText(System::Uitypes::TColor C);
	void __fastcall DoCfgChanged(void);
	
public:
	__property System::Classes::TNotifyEvent OnCfgChanged = {read=FOnCfgChanged, write=FOnCfgChanged};
	__fastcall TOvcTableColors(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::Uitypes::TColor ActiveFocused = {read=FActiveFocused, write=SetActiveFocused, default=-16777203};
	__property System::Uitypes::TColor ActiveFocusedText = {read=FActiveFocusedText, write=SetActiveFocusedText, default=-16777202};
	__property System::Uitypes::TColor ActiveUnfocused = {read=FActiveUnfocused, write=SetActiveUnfocused, default=-16777203};
	__property System::Uitypes::TColor ActiveUnfocusedText = {read=FActiveUnfocusedText, write=SetActiveUnfocusedText, default=-16777202};
	__property System::Uitypes::TColor Locked = {read=FLocked, write=SetLocked, default=-16777201};
	__property System::Uitypes::TColor LockedText = {read=FLockedText, write=SetLockedText, default=-16777208};
	__property System::Uitypes::TColor Editing = {read=FEditing, write=SetEditing, default=-16777201};
	__property System::Uitypes::TColor EditingText = {read=FEditingText, write=SetEditingText, default=-16777208};
	__property System::Uitypes::TColor Selected = {read=FSelected, write=SetSelected, default=-16777203};
	__property System::Uitypes::TColor SelectedText = {read=FSelectedText, write=SetSelectedText, default=-16777202};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcTableColors(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctbclr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTBCLR)
using namespace Ovctbclr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctbclrHPP

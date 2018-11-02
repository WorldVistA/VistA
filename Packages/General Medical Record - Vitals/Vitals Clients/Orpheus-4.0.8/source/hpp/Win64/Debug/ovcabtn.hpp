// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcabtn.pas' rev: 29.00 (Windows)

#ifndef OvcabtnHPP
#define OvcabtnHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcver.hpp>
#include <Vcl.StdCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcabtn
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcAttachedButton;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcButtonPosition : unsigned char { bpRight, bpLeft, bpTop, bpBottom };

class PASCALIMPLEMENTATION TOvcAttachedButton : public Vcl::Buttons::TBitBtn
{
	typedef Vcl::Buttons::TBitBtn inherited;
	
protected:
	Vcl::Controls::TWinControl* FAttachedControl;
	bool FAttachTwoWay;
	TOvcButtonPosition FPosition;
	int FSeparation;
	void *abNewWndProc;
	void *abPrevWndProc;
	bool abSizing;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetAttachedControl(Vcl::Controls::TWinControl* Value);
	void __fastcall SetAttachTwoWay(bool Value);
	void __fastcall SetPosition(TOvcButtonPosition Value);
	void __fastcall SetSeparation(int Value);
	void __fastcall abHookControl(void);
	void __fastcall abSetButtonBounds(const System::Types::TRect &CR);
	void __fastcall abSetControlBounds(void);
	void __fastcall abUnHookControl(void);
	void __fastcall abWndProc(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMRecreateWnd(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TOvcAttachedButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcAttachedButton(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property Vcl::Controls::TWinControl* AttachedControl = {read=FAttachedControl, write=SetAttachedControl};
	__property bool AttachTwoWay = {read=FAttachTwoWay, write=SetAttachTwoWay, default=0};
	__property TOvcButtonPosition Position = {read=FPosition, write=SetPosition, default=0};
	__property int Separation = {read=FSeparation, write=SetSeparation, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcAttachedButton(HWND ParentWindow) : Vcl::Buttons::TBitBtn(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcabtn */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCABTN)
using namespace Ovcabtn;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcabtnHPP

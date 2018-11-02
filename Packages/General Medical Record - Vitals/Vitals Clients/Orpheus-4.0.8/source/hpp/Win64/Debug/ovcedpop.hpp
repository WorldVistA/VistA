// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedpop.pas' rev: 29.00 (Windows)

#ifndef OvcedpopHPP
#define OvcedpopHPP

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
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovceditf.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedpop
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcEdButton;
class DELPHICLASS TOvcEdPopup;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcEdButton : public Vcl::Buttons::TBitBtn
{
	typedef Vcl::Buttons::TBitBtn inherited;
	
public:
	DYNAMIC void __fastcall Click(void);
public:
	/* TBitBtn.Create */ inline __fastcall virtual TOvcEdButton(System::Classes::TComponent* AOwner) : Vcl::Buttons::TBitBtn(AOwner) { }
	/* TBitBtn.Destroy */ inline __fastcall virtual ~TOvcEdButton(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcEdButton(HWND ParentWindow) : Vcl::Buttons::TBitBtn(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TOvcPopupEvent)(System::TObject* Sender);

enum DECLSPEC_DENUM TOvcPopupAnchor : unsigned char { paLeft, paRight };

class PASCALIMPLEMENTATION TOvcEdPopup : public Ovceditf::TOvcCustomEdit
{
	typedef Ovceditf::TOvcCustomEdit inherited;
	
protected:
	TOvcEdButton* FButton;
	Vcl::Graphics::TBitmap* FButtonGlyph;
	bool FPopupActive;
	TOvcPopupAnchor FPopupAnchor;
	TOvcPopupEvent FOnPopupClose;
	TOvcPopupEvent FOnPopupOpen;
	bool FShowButton;
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetShowButton(bool Value);
	int __fastcall GetButtonWidth(void);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC bool __fastcall GetButtonEnabled(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	virtual void __fastcall Loaded(void);
	MESSAGE void __fastcall OnMsgClose(Winapi::Messages::TMessage &M);
	MESSAGE void __fastcall OnMsgOpen(Winapi::Messages::TMessage &M);
	__property TOvcPopupAnchor PopupAnchor = {read=FPopupAnchor, write=FPopupAnchor, nodefault};
	__property bool ShowButton = {read=FShowButton, write=SetShowButton, nodefault};
	
public:
	__fastcall virtual TOvcEdPopup(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcEdPopup(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph};
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	__property TOvcPopupEvent OnPopupClose = {read=FOnPopupClose, write=FOnPopupClose};
	__property TOvcPopupEvent OnPopupOpen = {read=FOnPopupOpen, write=FOnPopupOpen};
	__property bool PopupActive = {read=FPopupActive, nodefault};
	__property Controller;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcEdPopup(HWND ParentWindow) : Ovceditf::TOvcCustomEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word MsgClose = System::Word(0x464);
static const System::Word MsgOpen = System::Word(0x465);
}	/* namespace Ovcedpop */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDPOP)
using namespace Ovcedpop;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedpopHPP

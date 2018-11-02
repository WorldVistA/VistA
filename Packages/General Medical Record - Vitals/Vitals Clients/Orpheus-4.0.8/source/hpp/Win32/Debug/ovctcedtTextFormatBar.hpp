// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcedtTextFormatBar.pas' rev: 29.00 (Windows)

#ifndef OvctcedttextformatbarHPP
#define OvctcedttextformatbarHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <ovcbase.hpp>
#include <ovcspeed.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.AppEvnts.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcedttextformatbar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFormSubClasser;
class DELPHICLASS TOvcTextFormatBar;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TSubClassMessageEvent)(const Winapi::Messages::TMessage &Msg);

class PASCALIMPLEMENTATION TFormSubClasser : public Vcl::Controls::TControl
{
	typedef Vcl::Controls::TControl inherited;
	
private:
	Vcl::Forms::TCustomForm* FForm;
	TSubClassMessageEvent FOnMessage;
	void __fastcall RevertParentWindowProc(void);
	static NativeInt __stdcall SubClassWindowProc(HWND hWnd, unsigned uMsg, NativeUInt wParam, NativeInt lParam, NativeUInt uIdSubclass, NativeUInt dwRefData);
	void __fastcall SetOnMessage(const TSubClassMessageEvent Value);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall DoMessage(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall virtual ~TFormSubClasser(void);
	void __fastcall SetForm(Vcl::Forms::TCustomForm* AForm);
	__property TSubClassMessageEvent OnMessage = {read=FOnMessage, write=SetOnMessage};
public:
	/* TControl.Create */ inline __fastcall virtual TFormSubClasser(System::Classes::TComponent* AOwner) : Vcl::Controls::TControl(AOwner) { }
	
};


class PASCALIMPLEMENTATION TOvcTextFormatBar : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TTimer* Timer1;
	Vcl::Buttons::TSpeedButton* btnBold;
	Vcl::Buttons::TSpeedButton* btnItalic;
	Vcl::Buttons::TSpeedButton* btnUnderline;
	void __fastcall Timer1Timer(System::TObject* Sender);
	void __fastcall btnBoldClick(System::TObject* Sender);
	void __fastcall btnItalicClick(System::TObject* Sender);
	void __fastcall btnUnderlineClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormPaint(System::TObject* Sender);
	
private:
	System::Uitypes::TFontStyles FAllowedFontStyles;
	TFormSubClasser* FFormSubClasser;
	Vcl::Controls::TWinControl* FAttachedControl;
	void __fastcall SetAllowedFontStyles(const System::Uitypes::TFontStyles Value);
	void __fastcall SetPopupParent(Vcl::Forms::TCustomForm* const Value);
	Vcl::Forms::TCustomForm* __fastcall GetPopupParent(void);
	void __fastcall FormMessage(const Winapi::Messages::TMessage &Msg);
	void __fastcall SetAttachedControl(Vcl::Controls::TWinControl* const Value);
	
protected:
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual ~TOvcTextFormatBar(void);
	__property System::Uitypes::TFontStyles AllowedFontStyles = {read=FAllowedFontStyles, write=SetAllowedFontStyles, default=7};
	void __fastcall UpdatePosition(void);
	__property Vcl::Forms::TCustomForm* PopupParent = {read=GetPopupParent, write=SetPopupParent};
	__property Vcl::Controls::TWinControl* AttachedControl = {read=FAttachedControl, write=SetAttachedControl};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcTextFormatBar(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcTextFormatBar(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTextFormatBar(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcedttextformatbar */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCEDTTEXTFORMATBAR)
using namespace Ovctcedttextformatbar;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcedttextformatbarHPP

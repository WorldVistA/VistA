// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32imgfm.pas' rev: 29.00 (Windows)

#ifndef O32imgfmHPP
#define O32imgfmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32imgfm
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TProtectedForm;
class DELPHICLASS TO32CustomImageForm;
class DELPHICLASS TO32ImageForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TProtectedForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
public:
	/* TCustomForm.Create */ inline __fastcall virtual TProtectedForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TProtectedForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TProtectedForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TProtectedForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32CustomImageForm : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
protected:
	bool FAutoSize;
	HRGN FOpaqueRgn;
	Vcl::Graphics::TBitmap* FPicture;
	bool FStretch;
	System::Uitypes::TColor FTransparentColor;
	System::Classes::TComponent* FDragControl;
	bool FDrawing;
	bool ifPictureChanged;
	void *NewWndProc;
	void *PrevWndProc;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetDragControl(System::Classes::TComponent* Control);
	void __fastcall SetPicture(Vcl::Graphics::TBitmap* Value);
	void __fastcall AdjustFormSize(void);
	void __fastcall SetTransparentColor(System::Uitypes::TColor Value);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	System::Types::TRect __fastcall DestRect(void);
	bool __fastcall DoPaletteChange(void);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	virtual void __fastcall Paint(void);
	void __fastcall DestroyWindow(void);
	void __fastcall ifWndProc(Winapi::Messages::TMessage &Message);
	void __fastcall HookForm(void);
	__property bool AutoSize = {read=FAutoSize, write=SetAutoSize, nodefault};
	__property Vcl::Graphics::TBitmap* Picture = {read=FPicture, write=SetPicture};
	__property System::Classes::TComponent* DragControl = {read=FDragControl, write=SetDragControl};
	__property System::Uitypes::TColor TransparentColor = {read=FTransparentColor, write=SetTransparentColor, nodefault};
	
public:
	__fastcall virtual TO32CustomImageForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomImageForm(void);
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	void __fastcall RenderForm(void);
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
};


class PASCALIMPLEMENTATION TO32ImageForm : public TO32CustomImageForm
{
	typedef TO32CustomImageForm inherited;
	
__published:
	__property Align = {default=0};
	__property AutoSize = {default=1};
	__property DragControl;
	__property Picture;
	__property PopupMenu;
	__property ShowHint;
	__property TransparentColor = {default=0};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnMouseDown;
public:
	/* TO32CustomImageForm.Create */ inline __fastcall virtual TO32ImageForm(System::Classes::TComponent* AOwner) : TO32CustomImageForm(AOwner) { }
	/* TO32CustomImageForm.Destroy */ inline __fastcall virtual ~TO32ImageForm(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32imgfm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32IMGFM)
using namespace O32imgfm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32imgfmHPP

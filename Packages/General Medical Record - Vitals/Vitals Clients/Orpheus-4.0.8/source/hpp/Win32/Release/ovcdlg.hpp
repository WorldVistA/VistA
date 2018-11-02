// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdlg.pas' rev: 29.00 (Windows)

#ifndef OvcdlgHPP
#define OvcdlgHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDialogPlacement;
class DELPHICLASS TOvcBaseDialog;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcDialogPosition : unsigned char { mpCenter, mpCenterTop, mpCustom };

enum DECLSPEC_DENUM TOvcDialogOption : unsigned char { doShowHelp, doSizeable };

typedef System::Set<TOvcDialogOption, TOvcDialogOption::doShowHelp, TOvcDialogOption::doSizeable> TOvcDialogOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcDialogPlacement : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcDialogPosition FPosition;
	int FHeight;
	int FLeft;
	int FTop;
	int FWidth;
	bool __fastcall LeftTopUsed(void);
	
__published:
	__property TOvcDialogPosition Position = {read=FPosition, write=FPosition, default=0};
	__property int Top = {read=FTop, write=FTop, stored=LeftTopUsed, default=10};
	__property int Left = {read=FLeft, write=FLeft, stored=LeftTopUsed, default=10};
	__property int Height = {read=FHeight, write=FHeight, nodefault};
	__property int Width = {read=FWidth, write=FWidth, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcDialogPlacement(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcDialogPlacement(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcBaseDialog : public Ovcbase::TOvcComponent
{
	typedef Ovcbase::TOvcComponent inherited;
	
protected:
	System::UnicodeString FCaption;
	Vcl::Graphics::TFont* FFont;
	Vcl::Graphics::TIcon* FIcon;
	TOvcDialogOptions FOptions;
	TOvcDialogPlacement* FPlacement;
	System::Classes::TNotifyEvent FOnHelpClick;
	void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetIcon(Vcl::Graphics::TIcon* Value);
	void __fastcall DoFormPlacement(Vcl::Forms::TForm* Form);
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property Vcl::Graphics::TIcon* Icon = {read=FIcon, write=SetIcon};
	__property TOvcDialogOptions Options = {read=FOptions, write=FOptions, nodefault};
	__property TOvcDialogPlacement* Placement = {read=FPlacement, write=FPlacement};
	__property System::Classes::TNotifyEvent OnHelpClick = {read=FOnHelpClick, write=FOnHelpClick};
	
public:
	__fastcall virtual TOvcBaseDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseDialog(void);
	virtual bool __fastcall Execute(void) = 0 ;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdlg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDLG)
using namespace Ovcdlg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdlgHPP

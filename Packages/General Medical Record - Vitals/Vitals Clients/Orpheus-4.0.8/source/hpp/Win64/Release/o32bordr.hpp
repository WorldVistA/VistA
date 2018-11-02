// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32bordr.pas' rev: 29.00 (Windows)

#ifndef O32bordrHPP
#define O32bordrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32bordr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32BorderSet;
class DELPHICLASS TO32Borders;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32BorderStyle : unsigned char { bstyNone, bstyRaised, bstyLowered, bstyFlat, bstyChannel, bstyRidge };

enum DECLSPEC_DENUM TO32BorderSide : unsigned char { bsidLeft, bsidRight, bsidTop, bsidBottom };

enum DECLSPEC_DENUM TSides : unsigned char { left, right, top, bottom };

class PASCALIMPLEMENTATION TO32BorderSet : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Classes::TPersistent* FOwner;
	bool FLeft;
	bool FTop;
	bool FRight;
	bool FBottom;
	void __fastcall SetLeft(bool Value);
	void __fastcall SetRight(bool Value);
	void __fastcall SetBottom(bool Value);
	void __fastcall SetTop(bool Value);
	
public:
	__fastcall TO32BorderSet(System::Classes::TPersistent* AOwner);
	
__published:
	__property bool ShowLeft = {read=FLeft, write=SetLeft, default=1};
	__property bool ShowRight = {read=FRight, write=SetRight, default=1};
	__property bool ShowTop = {read=FTop, write=SetTop, default=1};
	__property bool ShowBottom = {read=FBottom, write=SetBottom, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TO32BorderSet(void) { }
	
};


class PASCALIMPLEMENTATION TO32Borders : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	bool Creating;
	Vcl::Controls::TWinControl* FControl;
	TO32BorderSet* FBorderSet;
	bool FActive;
	System::Uitypes::TColor FFlatColor;
	int FBorderWidth;
	TO32BorderStyle FBorderStyle;
	void __fastcall SetActive(bool Value);
	void __fastcall SetBorderStyle(TO32BorderStyle Value);
	void __fastcall SetFlatColor(System::Uitypes::TColor Value);
	void __fastcall Draw3dBox(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Rct, System::Uitypes::TColor Hilite, System::Uitypes::TColor Base, bool DrawAllSides);
	void __fastcall DrawFlatBorder(Vcl::Controls::TControlCanvas* Canvas, const System::Types::TRect &Rct, System::Uitypes::TColor Color);
	void __fastcall DrawBevel(Vcl::Controls::TControlCanvas* Canvas, const System::Types::TRect &Rct, System::Uitypes::TColor HiliteColor, System::Uitypes::TColor BaseColor);
	void __fastcall Draw3dBorders(Vcl::Controls::TControlCanvas* Canvas, const System::Types::TRect &Rct);
	void __fastcall EraseBorder(Vcl::Controls::TControlCanvas* Canvas, const System::Types::TRect &Rct, System::Uitypes::TColor Color, bool AllSides);
	void __fastcall DrawSingleSolidBorder(Vcl::Controls::TControlCanvas* Canvas, const System::Types::TRect &Rct, System::Uitypes::TColor Color, TSides Side, int Width);
	
public:
	__fastcall TO32Borders(Vcl::Controls::TWinControl* Control);
	__fastcall virtual ~TO32Borders(void);
	void __fastcall Changed(void);
	void __fastcall BordersChanged(void);
	__property Vcl::Controls::TWinControl* Control = {read=FControl};
	void __fastcall DrawBorders(Vcl::Controls::TControlCanvas* &Canvas, System::Uitypes::TColor Color);
	void __fastcall RedrawControl(void);
	
__published:
	__property bool Active = {read=FActive, write=SetActive, default=0};
	__property TO32BorderSet* BorderSet = {read=FBorderSet, write=FBorderSet};
	__property TO32BorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=5};
	__property System::Uitypes::TColor FlatColor = {read=FFlatColor, write=SetFlatColor, default=65280};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::StaticArray<System::Uitypes::TColor, 6> THiliteColor;
extern DELPHI_PACKAGE System::StaticArray<System::Uitypes::TColor, 6> TBaseColor;
}	/* namespace O32bordr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32BORDR)
using namespace O32bordr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32bordrHPP

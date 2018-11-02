// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovclbl2.pas' rev: 29.00 (Windows)

#ifndef Ovclbl2HPP
#define Ovclbl2HPP

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
#include <Winapi.Messages.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovclbl2
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomDirectionPicker;
class DELPHICLASS TOvcDirectionPicker;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomDirectionPicker : public Ovcbase::TOvcGraphicControl
{
	typedef Ovcbase::TOvcGraphicControl inherited;
	
protected:
	int FDirection;
	int FNumDirections;
	Vcl::Graphics::TBitmap* FSelectedBitmap;
	bool FShowCenter;
	Vcl::Graphics::TBitmap* FDirectionBitmap;
	System::Classes::TNotifyEvent FOnChange;
	void __fastcall SetDirection(int Value);
	void __fastcall SetSelectedBitmap(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetNumDirections(int Value);
	void __fastcall SetShowCenter(bool Value);
	void __fastcall SetDirectionBitmap(Vcl::Graphics::TBitmap* Value);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	__property int Direction = {read=FDirection, write=SetDirection, default=0};
	__property int NumDirections = {read=FNumDirections, write=SetNumDirections, default=8};
	__property Vcl::Graphics::TBitmap* SelectedBitmap = {read=FSelectedBitmap, write=SetSelectedBitmap};
	__property bool ShowCenter = {read=FShowCenter, write=SetShowCenter, default=1};
	__property Vcl::Graphics::TBitmap* DirectionBitmap = {read=FDirectionBitmap, write=SetDirectionBitmap};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
public:
	__fastcall virtual TOvcCustomDirectionPicker(System::Classes::TComponent* AComponent);
	__fastcall virtual ~TOvcCustomDirectionPicker(void);
};


class PASCALIMPLEMENTATION TOvcDirectionPicker : public TOvcCustomDirectionPicker
{
	typedef TOvcCustomDirectionPicker inherited;
	
__published:
	__property Direction = {default=0};
	__property Enabled = {default=1};
	__property SelectedBitmap;
	__property NumDirections = {default=8};
	__property ShowCenter = {default=1};
	__property DirectionBitmap;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TOvcCustomDirectionPicker.Create */ inline __fastcall virtual TOvcDirectionPicker(System::Classes::TComponent* AComponent) : TOvcCustomDirectionPicker(AComponent) { }
	/* TOvcCustomDirectionPicker.Destroy */ inline __fastcall virtual ~TOvcDirectionPicker(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovclbl2 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCLBL2)
using namespace Ovclbl2;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovclbl2HPP

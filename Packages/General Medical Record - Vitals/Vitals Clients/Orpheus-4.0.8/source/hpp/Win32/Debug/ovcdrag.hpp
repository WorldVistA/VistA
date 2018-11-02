// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdrag.pas' rev: 29.00 (Windows)

#ifndef OvcdragHPP
#define OvcdragHPP

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
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdrag
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDragShow;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcDragShow : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int dStretchBltMode;
	HDC dMemDC;
	HDC dSMemDC;
	HDC dDstDC;
	HDC dSaveDC;
	HBITMAP dSaveBmp;
	HBITMAP dMemBmp;
	HBITMAP dSMemBmp;
	unsigned dcrText;
	unsigned dcrBack;
	System::Types::TRect dRect;
	System::Types::TPoint dSize;
	HPALETTE dSystemPalette16;
	HPALETTE dOldPal;
	Vcl::Graphics::TBitmap* Bitmap;
	Vcl::Graphics::TBitmap* dMask;
	int DeltaX;
	int DeltaY;
	bool dDragging;
	bool dHaveOriginal;
	void __fastcall ilDragDraw(void);
	void __fastcall ilRestoreOriginal(void);
	void __fastcall ilSaveOriginal(void);
	
public:
	__fastcall TOvcDragShow(int X, int Y, const System::Types::TRect &SourceRect, System::Uitypes::TColor TransColor);
	__fastcall virtual ~TOvcDragShow(void);
	void __fastcall DragMove(int X, int Y);
	void __fastcall HideDragImage(void);
	void __fastcall ShowDragImage(void);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdrag */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDRAG)
using namespace Ovcdrag;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdragHPP

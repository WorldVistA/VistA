// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcpb.pas' rev: 29.00 (Windows)

#ifndef OvcpbHPP
#define OvcpbHPP

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
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcstr.hpp>
#include <ovcbase.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcpb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcPictureBase;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcPictureBase : public Ovcef::TOvcBaseEntryField
{
	typedef Ovcef::TOvcBaseEntryField inherited;
	
protected:
	System::Byte pfSemiLits;
	Ovcdata::TPictureFlags pfPicFlags;
	int pfSelPos;
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	virtual void __fastcall CreateWnd(void);
	virtual bool __fastcall efCanClose(bool DoValidation);
	virtual void __fastcall efCaretToEnd(void);
	virtual void __fastcall efCaretToStart(void);
	DYNAMIC void __fastcall efChangeMask(System::WideChar * Mask);
	virtual System::Word __fastcall efEditBegin(void);
	System::Word __fastcall efEditEnd(void);
	virtual bool __fastcall efFieldIsEmpty(void);
	virtual System::WideChar * __fastcall efGetDisplayString(System::WideChar * Dest, System::Word Size);
	virtual void __fastcall efRemoveBadOptions(void);
	virtual void __fastcall efSetCaretPos(int Value);
	System::Word __fastcall pbCalcLength(void);
	void __fastcall pbCalcWidthAndPlaces(System::Word &Width, System::Word &Places);
	void __fastcall pbFixDecimalPoint(System::WideChar * P);
	void __fastcall pbFixNumber(int DotPos, int StBgn, int StEnd, bool FirstHalf, bool SecondHalf);
	bool __fastcall pbIsLiteral(System::Word N);
	void __fastcall pbInitPictureFlags(void);
	bool __fastcall pbIsNumber(void);
	bool __fastcall pbIsSemiLiteral(System::Word N);
	void __fastcall pbMergePicture(const System::WideChar * Dest, const System::WideChar * Src);
	void __fastcall pbOptimizeInitPictureFlags(void);
	virtual void __fastcall pbRemoveSemiLits(void);
	void __fastcall pbRestoreSemiLits(void);
	void __fastcall pbStripLiterals(System::WideChar * Dest, System::WideChar * Src);
	void __fastcall pbStripPicture(const System::WideChar * Dest, const System::WideChar * Src);
	
public:
	void __fastcall pbGetPictureFlags(Ovcdata::TPictureFlags &Flags);
	DYNAMIC System::UnicodeString __fastcall GetStrippedEditString(void);
	DYNAMIC void __fastcall MergeWithPicture(const System::UnicodeString S);
	DYNAMIC System::Word __fastcall ValidateContents(bool ReportError);
public:
	/* TOvcBaseEntryField.Create */ inline __fastcall virtual TOvcPictureBase(System::Classes::TComponent* AOwner) : Ovcef::TOvcBaseEntryField(AOwner) { }
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcPictureBase(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcPictureBase(HWND ParentWindow) : Ovcef::TOvcBaseEntryField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcpb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCPB)
using namespace Ovcpb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcpbHPP

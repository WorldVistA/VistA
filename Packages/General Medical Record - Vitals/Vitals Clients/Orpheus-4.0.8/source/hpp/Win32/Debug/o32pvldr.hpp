// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32pvldr.pas' rev: 29.00 (Windows)

#ifndef O32pvldrHPP
#define O32pvldrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <o32vldtr.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32pvldr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32ParadoxValidator;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 8> O32pvldr__1;

class PASCALIMPLEMENTATION TO32ParadoxValidator : public O32vldtr::TO32BaseValidator
{
	typedef O32vldtr::TO32BaseValidator inherited;
	
protected:
	System::WideChar FMaskBlank;
	virtual void __fastcall SetInput(const System::UnicodeString Value);
	virtual void __fastcall SetMask(const System::UnicodeString Value);
	virtual bool __fastcall GetValid(void);
	virtual System::Classes::TStringList* __fastcall GetSampleMasks(void);
	bool __fastcall Validate(const System::UnicodeString Value, int &Pos);
	bool __fastcall DoValidateChar(System::WideChar NewChar, int MaskOffset);
	bool __fastcall ValidateChar(System::WideChar NewChar, int Offset);
	int __fastcall FindLiteralChar(int MaskOffset, System::WideChar InChar);
	
public:
	__fastcall virtual TO32ParadoxValidator(System::Classes::TComponent* AOwner);
	virtual bool __fastcall IsValid(void);
	__property Valid;
	__property Input = {default=0};
	
__published:
	__property Mask = {default=0};
	__property BeforeValidation;
	__property AfterValidation;
	__property OnValidationError;
public:
	/* TO32BaseValidator.Destroy */ inline __fastcall virtual ~TO32ParadoxValidator(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ParadoxMaskCount = System::Int8(0x8);
static const System::Int8 ParadoxMaskLength = System::Int8(0x19);
extern DELPHI_PACKAGE O32pvldr__1 ParadoxMaskLookup;
}	/* namespace O32pvldr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32PVLDR)
using namespace O32pvldr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32pvldrHPP

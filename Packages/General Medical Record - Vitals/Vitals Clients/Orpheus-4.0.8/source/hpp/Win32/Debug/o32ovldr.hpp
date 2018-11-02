// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32ovldr.pas' rev: 29.00 (Windows)

#ifndef O32ovldrHPP
#define O32ovldrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <o32vldtr.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32ovldr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32OrMaskValidator;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 17> O32ovldr__1;

class PASCALIMPLEMENTATION TO32OrMaskValidator : public O32vldtr::TO32BaseValidator
{
	typedef O32vldtr::TO32BaseValidator inherited;
	
protected:
	System::WideChar FMaskBlank;
	virtual void __fastcall SetInput(const System::UnicodeString Value);
	virtual void __fastcall SetMask(const System::UnicodeString Value);
	virtual bool __fastcall GetValid(void);
	virtual System::Classes::TStringList* __fastcall GetSampleMasks(void);
	bool __fastcall Validate(const System::UnicodeString Value, int &ErrorPos);
	
public:
	virtual bool __fastcall IsValid(void);
	__property Valid;
	__property Input = {default=0};
	
__published:
	__property Mask = {default=0};
	__property BeforeValidation;
	__property AfterValidation;
	__property OnValidationError;
public:
	/* TO32BaseValidator.Create */ inline __fastcall virtual TO32OrMaskValidator(System::Classes::TComponent* AOwner) : O32vldtr::TO32BaseValidator(AOwner) { }
	/* TO32BaseValidator.Destroy */ inline __fastcall virtual ~TO32OrMaskValidator(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 OrpheusMaskCount = System::Int8(0x11);
static const System::Int8 OrpheusMaskLength = System::Int8(0xb);
extern DELPHI_PACKAGE O32ovldr__1 OrpheusMaskLookup;
static const System::Int8 vecNotAnyOrUpperChar = System::Int8(0x1);
static const System::Int8 vecNotAnyOrLowerChar = System::Int8(0x2);
static const System::Int8 vecNotAlphaChar = System::Int8(0x3);
static const System::Int8 vecNotUpperAlpha = System::Int8(0x4);
static const System::Int8 vecNotLowerAlpha = System::Int8(0x5);
static const System::Int8 vecNotDS = System::Int8(0x6);
static const System::Int8 vecNotDSM = System::Int8(0x9);
static const System::Int8 vecNotDSMP = System::Int8(0xa);
static const System::Int8 vecNotDSMPE = System::Int8(0xb);
static const System::Int8 vecNotHexadecimal = System::Int8(0xc);
static const System::Int8 vecNotBinary = System::Int8(0xd);
static const System::Int8 vecNotOctal = System::Int8(0xe);
static const System::Int8 vecNotTrueFalse = System::Int8(0xf);
static const System::Int8 vecNotYesNo = System::Int8(0x10);
static const System::Int8 vecTooLongInput = System::Int8(0x14);
}	/* namespace O32ovldr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32OVLDR)
using namespace O32ovldr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32ovldrHPP

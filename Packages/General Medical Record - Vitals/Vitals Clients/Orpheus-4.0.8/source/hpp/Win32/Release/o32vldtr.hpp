// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32vldtr.pas' rev: 29.00 (Windows)

#ifndef O32vldtrHPP
#define O32vldtrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32vldtr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32BaseValidator;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TValidationEvent : unsigned char { veOnChange, veOnEnter, veOnExit };

typedef void __fastcall (__closure *TValidatorErrorEvent)(System::TObject* Sender, const System::UnicodeString ErrorMsg);

typedef System::TMetaClass* TValidatorClass;

class PASCALIMPLEMENTATION TO32BaseValidator : public Ovcbase::TO32Component
{
	typedef Ovcbase::TO32Component inherited;
	
protected:
	System::Classes::TNotifyEvent FBeforeValidation;
	System::Classes::TNotifyEvent FAfterValidation;
	System::Classes::TNotifyEvent FOnUserValidation;
	TValidatorErrorEvent FOnErrorEvent;
	System::UnicodeString FInput;
	System::UnicodeString FMask;
	bool FValid;
	System::Word FErrorCode;
	System::Word FSampleMaskLength;
	System::Classes::TStringList* FSampleMasks;
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	virtual void __fastcall SetInput(const System::UnicodeString Value) = 0 ;
	virtual void __fastcall SetMask(const System::UnicodeString Value) = 0 ;
	void __fastcall SetValid(bool Value);
	HIDESBASE System::UnicodeString __fastcall GetAbout(void);
	virtual bool __fastcall GetValid(void) = 0 ;
	virtual System::Classes::TStringList* __fastcall GetSampleMasks(void) = 0 ;
	void __fastcall DoOnUserValidation(void);
	void __fastcall DoBeforeValidation(void);
	void __fastcall DoAfterValidation(void);
	void __fastcall DoOnError(System::TObject* Sender, const System::UnicodeString ErrorMsg);
	
public:
	__fastcall virtual TO32BaseValidator(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32BaseValidator(void);
	virtual bool __fastcall IsValid(void) = 0 ;
	int __fastcall SampleMaskLength(void);
	__property System::UnicodeString Input = {read=FInput, write=SetInput};
	__property System::UnicodeString Mask = {read=FMask, write=SetMask};
	__property bool Valid = {read=GetValid, nodefault};
	__property System::Word ErrorCode = {read=FErrorCode, nodefault};
	__property System::Classes::TStringList* SampleMasks = {read=GetSampleMasks};
	__property System::Classes::TNotifyEvent BeforeValidation = {read=FBeforeValidation, write=FBeforeValidation};
	__property System::Classes::TNotifyEvent AfterValidation = {read=FAfterValidation, write=FAfterValidation};
	__property TValidatorErrorEvent OnValidationError = {read=FOnErrorEvent, write=FOnErrorEvent};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32vldtr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32VLDTR)
using namespace O32vldtr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32vldtrHPP

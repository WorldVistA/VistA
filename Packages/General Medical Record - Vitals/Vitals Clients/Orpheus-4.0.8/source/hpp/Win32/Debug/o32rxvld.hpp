// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32rxvld.pas' rev: 29.00 (Windows)

#ifndef O32rxvldHPP
#define O32rxvldHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <o32vldtr.hpp>
#include <o32rxngn.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32rxvld
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32RegExValidator;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 13> O32rxvld__1;

class PASCALIMPLEMENTATION TO32RegExValidator : public O32vldtr::TO32BaseValidator
{
	typedef O32vldtr::TO32BaseValidator inherited;
	
protected:
	bool FLogging;
	System::UnicodeString FLogFile;
	O32rxngn::TO32RegexEngine* FRegexEngine;
	int FExprErrorPos;
	O32rxngn::TO32RegexError FExprErrorCode;
	bool FIgnoreCase;
	void __fastcall SetIgnoreCase(const bool Value);
	void __fastcall SetLogging(const bool Value);
	void __fastcall SetLogFile(const System::UnicodeString Value);
	virtual void __fastcall SetMask(const System::UnicodeString Value);
	virtual bool __fastcall GetValid(void);
	virtual System::Classes::TStringList* __fastcall GetSampleMasks(void);
	virtual void __fastcall SetInput(const System::UnicodeString Value);
	bool __fastcall CheckExpression(int &ErrorPos);
	
public:
	__fastcall virtual TO32RegExValidator(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32RegExValidator(void);
	virtual bool __fastcall IsValid(void);
	System::UnicodeString __fastcall GetExprError(void);
	__property Valid;
	__property int ExprErrorPos = {read=FExprErrorPos, write=FExprErrorPos, nodefault};
	
__published:
	__property Input = {default=0};
	__property System::UnicodeString Expression = {read=FMask, write=SetMask, stored=true};
	__property bool Logging = {read=FLogging, write=SetLogging, default=0};
	__property System::UnicodeString LogFile = {read=FLogFile, write=SetLogFile};
	__property bool IgnoreCase = {read=FIgnoreCase, write=SetIgnoreCase, stored=true, default=1};
	__property BeforeValidation;
	__property AfterValidation;
	__property OnValidationError;
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 RXMaskCount = System::Int8(0xd);
static const System::Int8 RXMaskLength = System::Int8(0x50);
extern DELPHI_PACKAGE O32rxvld__1 RXMaskLookup;
static const System::Int8 EC_NO_ERROR = System::Int8(0x0);
static const System::Int8 EC_INVALID_EXPR = System::Int8(0x1);
static const System::Int8 EC_INVALID_INPUT = System::Int8(0x2);
static const System::Int8 EC_NO_MATCH = System::Int8(0x3);
}	/* namespace O32rxvld */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32RXVLD)
using namespace O32rxvld;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32rxvldHPP

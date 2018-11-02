// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32vpool.pas' rev: 29.00 (Windows)

#ifndef O32vpoolHPP
#define O32vpoolHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <ovcbase.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <o32vldtr.hpp>
#include <o32ovldr.hpp>
#include <o32pvldr.hpp>
#include <o32rxvld.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32vpool
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32ValidatorItem;
class DELPHICLASS TO32Validators;
class DELPHICLASS TO32ValidatorPool;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TVPoolNotifyEvent)(System::TObject* Sender, int ValidatorItem);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32ValidatorItem : public Ovcbase::TO32CollectionItem
{
	typedef Ovcbase::TO32CollectionItem inherited;
	
protected:
	O32vldtr::TO32BaseValidator* FValidator;
	System::UnicodeString FValidationEvent;
	O32vldtr::TValidatorClass FValidatorClass;
	System::UnicodeString FValidatorType;
	bool FBeepOnError;
	System::UnicodeString FMask;
	Vcl::Stdctrls::TCustomEdit* FComponent;
	System::Uitypes::TColor FComponentColor;
	System::Uitypes::TColor FErrorColor;
	O32vldtr::TValidationEvent FEvent;
	void __fastcall DoValidation(System::TObject* Sender);
	void __fastcall SetComponent(Vcl::Stdctrls::TCustomEdit* Value);
	void __fastcall SetValidatorType(const System::UnicodeString Value);
	void __fastcall AssignValidator(void);
	void __fastcall SetEvent(O32vldtr::TValidationEvent Event);
	void __fastcall AssignEvent(void);
	TO32ValidatorPool* __fastcall ValidatorPool(void);
	
public:
	__fastcall virtual TO32ValidatorItem(System::Classes::TCollection* Collection);
	__property O32vldtr::TO32BaseValidator* Validator = {read=FValidator, write=FValidator};
	__property O32vldtr::TValidatorClass ValidatorClass = {read=FValidatorClass, write=FValidatorClass};
	
__published:
	__property bool BeepOnError = {read=FBeepOnError, write=FBeepOnError, nodefault};
	__property Name = {default=0};
	__property System::Uitypes::TColor ErrorColor = {read=FErrorColor, write=FErrorColor, nodefault};
	__property Vcl::Stdctrls::TCustomEdit* Component = {read=FComponent, write=SetComponent};
	__property System::UnicodeString Mask = {read=FMask, write=FMask};
	__property O32vldtr::TValidationEvent ValidationEvent = {read=FEvent, write=SetEvent, nodefault};
	__property System::UnicodeString ValidatorType = {read=FValidatorType, write=SetValidatorType, stored=true};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TO32ValidatorItem(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TO32Validators : public Ovcbase::TO32Collection
{
	typedef Ovcbase::TO32Collection inherited;
	
protected:
	TO32ValidatorPool* FValidatorPool;
	HIDESBASE TO32ValidatorItem* __fastcall GetItem(int Index);
	
public:
	__fastcall virtual TO32Validators(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass);
	System::Classes::TCollectionItem* __fastcall AddItem(O32vldtr::TValidatorClass ValidatorClass);
	HIDESBASE void __fastcall Delete(int Index);
	void __fastcall DeleteByName(const System::UnicodeString Name);
	O32vldtr::TO32BaseValidator* __fastcall GetValidatorByName(const System::UnicodeString Name);
	__property TO32ValidatorPool* ValidatorPool = {read=FValidatorPool};
	__property TO32ValidatorItem* Items[int index] = {read=GetItem};
public:
	/* TO32Collection.Destroy */ inline __fastcall virtual ~TO32Validators(void) { }
	
};


class PASCALIMPLEMENTATION TO32ValidatorPool : public Ovcbase::TO32Component
{
	typedef Ovcbase::TO32Component inherited;
	
protected:
	TO32Validators* FValidators;
	
public:
	__fastcall virtual TO32ValidatorPool(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32ValidatorPool(void);
	
__published:
	__property Name = {default=0};
	__property TO32Validators* Validators = {read=FValidators, write=FValidators};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32vpool */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32VPOOL)
using namespace O32vpool;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32vpoolHPP

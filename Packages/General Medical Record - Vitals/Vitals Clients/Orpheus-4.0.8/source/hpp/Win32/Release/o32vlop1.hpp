// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32vlop1.pas' rev: 29.00 (Windows)

#ifndef O32vlop1HPP
#define O32vlop1HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <o32vldtr.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcconst.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32vlop1
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TProtectedControl;
class DELPHICLASS TValidatorOptions;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TValidationType : unsigned char { vtNone, vtUser, vtValidator };

class PASCALIMPLEMENTATION TProtectedControl : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
public:
	/* TWinControl.Create */ inline __fastcall virtual TProtectedControl(System::Classes::TComponent* AOwner) : Vcl::Controls::TWinControl(AOwner) { }
	/* TWinControl.CreateParented */ inline __fastcall TProtectedControl(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TProtectedControl(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TValidatorOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	Vcl::Controls::TWinControl* FOwner;
	Vcl::Controls::TWinControl* FHookedControl;
	TValidationType FValidationType;
	System::UnicodeString FValidatorType;
	O32vldtr::TValidatorClass FValidatorClass;
	bool FSoftValidation;
	System::UnicodeString FMask;
	bool FLastValid;
	System::Word FLastErrorCode;
	bool FBeepOnError;
	bool FInputRequired;
	bool FEnableHooking;
	int FUpdating;
	O32vldtr::TValidationEvent FEvent;
	void *NewWndProc;
	void *PrevWndProc;
	void __fastcall HookControl(void);
	void __fastcall UnHookControl(void);
	void __fastcall voWndProc(Winapi::Messages::TMessage &Msg);
	void __fastcall RecreateHookedWnd(void);
	bool __fastcall Validate(void);
	void __fastcall AssignValidator(void);
	void __fastcall SetValidatorType(const System::UnicodeString VType);
	void __fastcall SetEvent(O32vldtr::TValidationEvent Event);
	void __fastcall SetEnableHooking(bool Value);
	__property bool InputRequired = {read=FInputRequired, write=FInputRequired, nodefault};
	
public:
	__fastcall TValidatorOptions(Vcl::Controls::TWinControl* AOwner);
	__fastcall virtual ~TValidatorOptions(void);
	void __fastcall AttachTo(Vcl::Controls::TWinControl* Value);
	void __fastcall SetLastErrorCode(System::Word Code);
	void __fastcall SetLastValid(bool Valid);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	__property bool LastValid = {read=FLastValid, nodefault};
	__property System::Word LastErrorCode = {read=FLastErrorCode, nodefault};
	__property bool EnableHooking = {read=FEnableHooking, write=SetEnableHooking, nodefault};
	__property O32vldtr::TValidatorClass ValidatorClass = {read=FValidatorClass, write=FValidatorClass};
	
__published:
	__property bool BeepOnError = {read=FBeepOnError, write=FBeepOnError, nodefault};
	__property bool SoftValidation = {read=FSoftValidation, write=FSoftValidation, nodefault};
	__property O32vldtr::TValidationEvent ValidationEvent = {read=FEvent, write=SetEvent, stored=true, nodefault};
	__property System::UnicodeString ValidatorType = {read=FValidatorType, write=SetValidatorType, stored=true};
	__property TValidationType ValidationType = {read=FValidationType, write=FValidationType, stored=true, nodefault};
	__property System::UnicodeString Mask = {read=FMask, write=FMask, stored=true};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32vlop1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32VLOP1)
using namespace O32vlop1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32vlop1HPP

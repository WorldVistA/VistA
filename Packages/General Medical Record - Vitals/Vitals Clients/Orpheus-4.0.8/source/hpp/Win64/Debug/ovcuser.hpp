// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcuser.pas' rev: 29.00 (Windows)

#ifndef OvcuserHPP
#define OvcuserHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <ovcdata.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcuser
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcUserData;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcUserData : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	Ovcdata::TUserCharSets FUserCharSets;
	Ovcdata::TForceCase FForceCase;
	Ovcdata::TSubstChars FSubstChars;
	Ovcdata::TCaseChange __fastcall GetForceCase(Ovcdata::TForceCaseRange Index);
	System::WideChar __fastcall GetSubstChar(Ovcdata::TSubstCharRange Index);
	Ovcdata::TCharSet __fastcall GetUserCharSet(Ovcdata::TUserSetRange Index);
	void __fastcall SetForceCase(Ovcdata::TForceCaseRange Index, Ovcdata::TCaseChange CC);
	void __fastcall SetSubstChar(Ovcdata::TSubstCharRange Index, System::WideChar SC);
	void __fastcall SetUserCharSet(Ovcdata::TUserSetRange Index, const Ovcdata::TCharSet &US);
	
public:
	__fastcall TOvcUserData(void);
	__property Ovcdata::TCaseChange ForceCase[Ovcdata::TForceCaseRange Index] = {read=GetForceCase, write=SetForceCase};
	__property System::WideChar SubstChars[Ovcdata::TSubstCharRange Index] = {read=GetSubstChar, write=SetSubstChar};
	__property Ovcdata::TCharSet UserCharSet[Ovcdata::TUserSetRange Index] = {read=GetUserCharSet, write=SetUserCharSet};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOvcUserData(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcUserData* OvcUserData;
}	/* namespace Ovcuser */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCUSER)
using namespace Ovcuser;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcuserHPP

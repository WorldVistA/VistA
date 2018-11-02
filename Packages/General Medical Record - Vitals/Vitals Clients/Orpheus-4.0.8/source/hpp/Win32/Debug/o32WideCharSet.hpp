// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'O32WideCharSet.pas' rev: 29.00 (Windows)

#ifndef O32widecharsetHPP
#define O32widecharsetHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32widecharset
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TWideCharSetEnumerator;
struct TWideCharSet;
//-- type declarations -------------------------------------------------------
typedef TWideCharSet *PWideCharSet;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TWideCharSetEnumerator : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FIndex;
	TWideCharSet *FList;
	System::WideChar FCurrent;
	
public:
	__fastcall TWideCharSetEnumerator(PWideCharSet AList);
	System::WideChar __fastcall GetCurrent(void);
	bool __fastcall MoveNext(void);
	__property System::WideChar Current = {read=GetCurrent, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TWideCharSetEnumerator(void) { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TWideCharSet
{
private:
	System::StaticArray<System::Sysutils::TSysCharSet, 256> FChars;
	
public:
	TWideCharSetEnumerator* __fastcall GetEnumerator(void);
	static TWideCharSet __fastcall _op_Include(const TWideCharSet &Rec, System::WideChar AChar);
	static TWideCharSet __fastcall _op_Include(const TWideCharSet &Rec, System::UnicodeString AChar);
	static TWideCharSet __fastcall _op_Addition(const TWideCharSet &Rec, System::WideChar AChar);
	static TWideCharSet __fastcall _op_Subtraction(const TWideCharSet &Rec, System::WideChar AChar);
	static TWideCharSet __fastcall _op_Exclude(const TWideCharSet &Rec, System::WideChar AChar);
	static TWideCharSet __fastcall _op_Exclude(const TWideCharSet &Rec, System::UnicodeString AChar);
	static bool __fastcall _op_In(System::WideChar AChar, const TWideCharSet &Rec);
	static TWideCharSet __fastcall _op_Implicit(const System::Sysutils::TSysCharSet &S);
	TWideCharSet& __fastcall operator=(const System::Sysutils::TSysCharSet &S) { *this = TWideCharSet::_op_Implicit(S); return *this; };
	__fastcall operator System::Sysutils::TSysCharSet();
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32widecharset */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32WIDECHARSET)
using namespace O32widecharset;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32widecharsetHPP

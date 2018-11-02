// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32intlst.pas' rev: 29.00 (Windows)

#ifndef O32intlstHPP
#define O32intlstHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32intlst
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32IntList;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TO32IntList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int operator[](int aInx) { return Items[aInx]; }
	
protected:
	bool FAllowDups;
	int FCount;
	bool FIsSorted;
	System::Classes::TList* FList;
	int __fastcall ilGetCapacity(void);
	int __fastcall ilGetItem(int aInx);
	void __fastcall ilSetCapacity(int aValue);
	void __fastcall ilSetCount(int aValue);
	void __fastcall ilSetIsSorted(bool aValue);
	void __fastcall ilSetItem(int aInx, int aValue);
	void __fastcall ilSort(void);
	
public:
	__fastcall TO32IntList(void);
	__fastcall virtual ~TO32IntList(void);
	int __fastcall Add(int aItem);
	void __fastcall Clear(void);
	void __fastcall Insert(int aInx, void * aItem);
	__property bool AllowDups = {read=FAllowDups, write=FAllowDups, nodefault};
	__property int Capacity = {read=ilGetCapacity, write=ilSetCapacity, nodefault};
	__property int Count = {read=FCount, write=ilSetCount, nodefault};
	__property bool IsSorted = {read=FIsSorted, write=ilSetIsSorted, nodefault};
	__property int Items[int aInx] = {read=ilGetItem, write=ilSetItem/*, default*/};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32intlst */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32INTLST)
using namespace O32intlst;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32intlstHPP

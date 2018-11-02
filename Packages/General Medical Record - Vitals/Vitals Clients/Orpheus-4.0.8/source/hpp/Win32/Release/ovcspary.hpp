// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcspary.pas' rev: 29.00 (Windows)

#ifndef OvcsparyHPP
#define OvcsparyHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <ovcexcpt.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcspary
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcSparseArray;
//-- type declarations -------------------------------------------------------
typedef bool __fastcall (*TSparseArrayFunc)(int Index, void * Item, void * ExtraData);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcSparseArray : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	void * operator[](int Index) { return Items[Index]; }
	
protected:
	int FCount;
	void *FArray;
	System::Word ChunkCount;
	System::Word ChunkArraySize;
	void __fastcall RecalcCount(void);
	int __fastcall GetActiveCount(void);
	void * __fastcall GetItem(int Index);
	void __fastcall PutItem(int Index, void * Item);
	
public:
	__fastcall TOvcSparseArray(void);
	__fastcall virtual ~TOvcSparseArray(void);
	int __fastcall Add(void * Item);
	void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	void __fastcall Exchange(int Index1, int Index2);
	void * __fastcall First(void);
	int __fastcall ForAll(TSparseArrayFunc Action, bool Backwards, void * ExtraData);
	int __fastcall IndexOf(void * Item);
	void __fastcall Insert(int Index, void * Item);
	void * __fastcall Last(void);
	void __fastcall Squeeze(void);
	__property int Count = {read=FCount, nodefault};
	__property int ActiveCount = {read=GetActiveCount, nodefault};
	__property void * Items[int Index] = {read=GetItem, write=PutItem/*, default*/};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const int MaxSparseArrayItems = int(0x4e200);
}	/* namespace Ovcspary */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSPARY)
using namespace Ovcspary;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcsparyHPP

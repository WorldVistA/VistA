// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdlm.pas' rev: 29.00 (Windows)

#ifndef OvcdlmHPP
#define OvcdlmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdlm
{
//-- forward type declarations -----------------------------------------------
struct TOvcPoolPage;
class DELPHICLASS TOvcPoolManager;
struct TOvcPTDataPage;
class DELPHICLASS TOvcPageTree;
struct TOvcListNode0;
struct TOvcListNode;
class DELPHICLASS TOvcList;
class DELPHICLASS TOvcSortedList;
class DELPHICLASS TOvcLiteCache;
class DELPHICLASS TOvcLiteStringCache;
class DELPHICLASS TOvcFastList;
//-- type declarations -------------------------------------------------------
typedef void * *PPointer;

typedef TOvcPoolPage *POvcPoolPage;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcPoolPage
{
public:
	System::StaticArray<System::Byte, 4092> Data;
	TOvcPoolPage *NextPage;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcPoolManager : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TOvcPoolPage *FirstPage;
	TOvcPoolPage *LastPage;
	void *LastPageTop;
	void *LastPageEnd;
	int InternalSize;
	int ItemsPerPage;
	void *DeletedList;
	unsigned OwnerThread;
	void __fastcall NewPage(void);
	
public:
	void __fastcall Clear(void);
	__fastcall TOvcPoolManager(int ItemSize);
	__fastcall virtual ~TOvcPoolManager(void);
	void * __fastcall NewItem(void);
	void __fastcall DeleteItem(void * Item);
};

#pragma pack(pop)

typedef TOvcPTDataPage *POvcPTDataPage;

typedef System::StaticArray<void *, 1018> TOvcPTDataArray;

typedef TOvcPTDataArray *POvcPTDataArray;

struct DECLSPEC_DRECORD TOvcPTDataPage
{
public:
	TOvcPTDataArray Data;
	int UseCount;
	int PageType;
	TOvcPTDataPage *Owner;
	void *LowKey;
	void *HighKey;
};


enum DECLSPEC_DENUM TOvcPTSearchResult : unsigned char { srFound, srPageFound, srBelowPage, srAbovePage };

typedef int __fastcall (__closure *TOvcPTCompareFunc)(TOvcPageTree* Sender, void * UserData, void * Key1, void * Key2);

typedef void __fastcall (__closure *TOvcPTPageChangeProc)(TOvcPageTree* Sender, void * UserData, int Count, POvcPTDataArray DataArray, void * NewPage);

class PASCALIMPLEMENTATION TOvcPageTree : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TOvcPTDataPage *iLastKeyPage;
	int iLastKeyIndex;
	System::Classes::TList* PageStack;
	System::Classes::TList* IndexStack;
	TOvcPTCompareFunc FCompare;
	TOvcPTPageChangeProc FPageChange;
	TOvcPTSearchResult __fastcall BinarySearch(POvcPTDataPage Root, void * Key, POvcPTDataPage &Page, int &Index);
	bool __fastcall InternalGEQ(POvcPTDataPage Root, void * Key, POvcPTDataPage &Page, int &Index);
	bool __fastcall InternalAdd(void * Key, POvcPTDataPage &TargetPage);
	void __fastcall DeletePage(POvcPTDataPage Page);
	TOvcPTSearchResult __fastcall BinarySearchData(POvcPTDataPage Root, void * Key, POvcPTDataPage &Page, int &Index);
	TOvcPTSearchResult __fastcall BinarySearchIndex(POvcPTDataPage Root, void * Key, POvcPTDataPage &Page, int &Index);
	void __fastcall Clear(void);
	void __fastcall Init(void);
	TOvcPTDataPage *Root;
	TOvcPoolManager* Pool;
	void *FUserData;
	void __fastcall NotifyPageChange(POvcPTDataPage Page);
	void __fastcall RecalcEdges(void);
	void __fastcall ClearPosition(POvcPTDataPage Page);
	
public:
	__fastcall TOvcPageTree(void * UserData);
	__fastcall virtual ~TOvcPageTree(void);
	bool __fastcall Add(void * Key);
	bool __fastcall AddEx(void * Key, void * &DataPage);
	bool __fastcall GEQ(void * Key, void * &Data);
	bool __fastcall GNX(void * &Data);
	bool __fastcall GPR(void * &Data);
	bool __fastcall GFirst(void * &Data);
	bool __fastcall GLast(void * &Data);
	bool __fastcall GGEQ(void * Key, void * &Data);
	bool __fastcall GLEQ(void * Key, void * &Data);
	bool __fastcall Delete(void * Key);
	bool __fastcall DeleteEx(void * Key, void * IndexPage, bool AllowCompare);
	void __fastcall PushPosition(void);
	bool __fastcall PopPosition(void);
	__property TOvcPTCompareFunc OnCompare = {read=FCompare, write=FCompare};
	__property TOvcPTPageChangeProc OnPageChange = {read=FPageChange, write=FPageChange};
};


struct DECLSPEC_DRECORD TOvcListNode0
{
public:
	void *Item;
	void *UserData;
	void *IndexPage;
};


struct DECLSPEC_DRECORD TOvcListNode
{
public:
	void *Item;
	void *UserData;
	System::StaticArray<void *, 65> IndexPages;
};


typedef TOvcListNode *POvcListNode;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TOvcPoolManager* Pool;
	TOvcPageTree* Index;
	int FCount;
	void * __fastcall GetUserData(POvcListNode Node);
	void __fastcall SetUserData(POvcListNode Node, void * Value);
	POvcListNode __fastcall NewNode(void);
	void __fastcall FreeNode(POvcListNode P);
	int __fastcall Compare(TOvcPageTree* Sender, void * UserData, void * Key1, void * Key2);
	void __fastcall PageChange(TOvcPageTree* Sender, void * UserData, int Count, POvcPTDataArray DataArray, void * NewPage);
	
public:
	__fastcall TOvcList(void);
	__fastcall virtual ~TOvcList(void);
	virtual void __fastcall DeleteNode(POvcListNode Node);
	virtual POvcListNode __fastcall Add(void * Item);
	bool __fastcall ItemExists(void * Item);
	void __fastcall AddIfUnique(void * Item);
	virtual POvcListNode __fastcall AddObject(void * Item, void * UserData);
	void __fastcall Clear(void);
	virtual void __fastcall Delete(void * Item);
	bool __fastcall Empty(void);
	POvcListNode __fastcall FindNode(void * Item);
	void __fastcall SetAllUserData(void * Value);
	__property void * UserData[POvcListNode Node] = {read=GetUserData, write=SetUserData};
	bool __fastcall First(POvcListNode &Node);
	bool __fastcall Next(POvcListNode &Node);
	bool __fastcall Last(POvcListNode &Node);
	bool __fastcall Prev(POvcListNode &Node);
	__property int Count = {read=FCount, nodefault};
	void __fastcall PushIndexPosition(void);
	void __fastcall PopIndexPosition(void);
};

#pragma pack(pop)

typedef int __fastcall (__closure *TOvcMultiCompareFunc)(int Key, void * I1, void * I2);

class PASCALIMPLEMENTATION TOvcSortedList : public TOvcList
{
	typedef TOvcList inherited;
	
protected:
	TOvcMultiCompareFunc FCompareFunc;
	int FCurrentKey;
	int KeyCount;
	System::StaticArray<TOvcPageTree*, 64> Indexes;
	int FCount;
	int __fastcall GetCount(void);
	void __fastcall SetCurrentKey(int Value);
	int __fastcall CompareM(TOvcPageTree* Sender, void * UserData, void * Key1, void * Key2);
	void __fastcall PageChangeM(TOvcPageTree* Sender, void * UserData, int Count, POvcPTDataArray DataArray, void * NewPage);
	int __fastcall ComputeCount(void);
	
public:
	virtual POvcListNode __fastcall Add(void * Item);
	virtual POvcListNode __fastcall AddObject(void * Item, void * UserData);
	__fastcall TOvcSortedList(int NumKeys, TOvcMultiCompareFunc CompareFunc);
	HIDESBASE void __fastcall Clear(void);
	__property int CurrentKey = {read=FCurrentKey, write=SetCurrentKey, nodefault};
	virtual void __fastcall Delete(void * Item);
	__fastcall virtual ~TOvcSortedList(void);
	void * __fastcall FirstItem(void);
	void * __fastcall LastItem(void);
	HIDESBASE bool __fastcall First(void * &Item);
	HIDESBASE bool __fastcall Next(void * &Item);
	HIDESBASE bool __fastcall Last(void * &Item);
	HIDESBASE bool __fastcall Prev(void * &Item);
	__property int Count = {read=GetCount, nodefault};
	bool __fastcall GGEQ(void * SearchItem, void * &Item);
	bool __fastcall GLEQ(void * SearchItem, void * &Item);
	virtual void __fastcall DeleteNode(POvcListNode Node);
	void __fastcall PushIndex(void);
	void __fastcall PopIndex(void);
};


typedef void __fastcall (__closure *TOvcFCRemoveNotifier)(const void *Value);

class PASCALIMPLEMENTATION TOvcLiteCache : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	NativeInt __fastcall GetTimeStamp(int Index);
	void __fastcall SetTimeStamp(int Index, const NativeInt Value);
	void * __fastcall GetKeySlot(int Index);
	void * __fastcall GetValueSlot(int Index);
	void *Buffer;
	int CacheCount;
	int FCacheSize;
	TOvcFCRemoveNotifier FRemoveNotifier;
	int FValueSize;
	__property NativeInt TimeStamp[int Index] = {read=GetTimeStamp, write=SetTimeStamp};
	__property void * KeySlot[int Index] = {read=GetKeySlot};
	__property void * ValueSlot[int Index] = {read=GetValueSlot};
	
public:
	void __fastcall AddValue(void * Key, const void *Value);
	void __fastcall Clear(void);
	__fastcall TOvcLiteCache(int ValueSize, int CacheSize);
	__fastcall virtual ~TOvcLiteCache(void);
	bool __fastcall GetValue(void * Key, void *Value);
	__property TOvcFCRemoveNotifier RemoveNotifier = {read=FRemoveNotifier, write=FRemoveNotifier};
	void __fastcall RemoveValue(void * Key);
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcLiteStringCache : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TOvcLiteCache* FCache;
	void __fastcall RemoveNotifier(const void *Value);
	
public:
	void __fastcall AddValue(void * Key, const System::UnicodeString Value);
	void __fastcall Clear(void);
	__fastcall TOvcLiteStringCache(int CacheSize);
	__fastcall virtual ~TOvcLiteStringCache(void);
	bool __fastcall GetValue(void * Key, System::UnicodeString &Value);
	void __fastcall RemoveValue(void * Key);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcFastList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	void * operator[](int Index) { return Items[Index]; }
	
protected:
	System::Classes::TPointerList *FList;
	int FCount;
	int FCapacity;
	void * __fastcall Get(int Index);
	void __fastcall Grow(void);
	void __fastcall Put(int Index, void * Item);
	void __fastcall SetCapacity(int NewCapacity);
	void __fastcall SetCount(int NewCount);
	__classmethod void __fastcall BoundsError(int Data);
	__classmethod void __fastcall CapacityError(int Data);
	__classmethod void __fastcall CountError(int Data);
	
public:
	__fastcall virtual ~TOvcFastList(void);
	int __fastcall Add(void * Item);
	void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	int __fastcall IndexOf(void * Item);
	__property int Count = {read=FCount, write=SetCount, nodefault};
	__property void * Items[int Index] = {read=Get, write=Put/*, default*/};
	__property System::Classes::PPointerList List = {read=FList};
public:
	/* TObject.Create */ inline __fastcall TOvcFastList(void) : System::TObject() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 dlmMaxKeys = System::Int8(0x40);
static const System::Word dlmPageSize = System::Word(0x1000);
static const System::Word dlmMaxItemSize = System::Word(0xffc);
static const System::Word EntriesPerPage = System::Word(0x3fa);
static const System::Int8 DATAPAGE = System::Int8(0x0);
static const System::Int8 INDEXPAGE = System::Int8(0x1);
}	/* namespace Ovcdlm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDLM)
using namespace Ovcdlm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdlmHPP

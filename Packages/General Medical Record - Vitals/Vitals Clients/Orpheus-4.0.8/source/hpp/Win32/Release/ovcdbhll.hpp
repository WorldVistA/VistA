// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbhll.pas' rev: 29.00 (Windows)

#ifndef OvcdbhllHPP
#define OvcdbhllHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <ovcbase.hpp>
#include <Data.DB.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbhll
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbEngineHelperBase;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbEngineHelperBase : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	virtual void __fastcall GetAliasNames(System::Classes::TStrings* aList);
	virtual void __fastcall GetAliasPath(const System::UnicodeString aAlias, System::UnicodeString &aPath);
	virtual void __fastcall GetAliasDriverName(const System::UnicodeString aAlias, System::UnicodeString &aDriver);
	virtual void __fastcall GetTableNames(const System::UnicodeString aAlias, System::Classes::TStrings* aList);
	virtual void __fastcall FindNearestKey(Data::Db::TDataSet* aDataSet, System::TVarRec const *aKeyValues, const int aKeyValues_High);
	virtual Data::Db::TIndexDefs* __fastcall GetIndexDefs(Data::Db::TDataSet* aDataSet);
	virtual Data::Db::TField* __fastcall GetIndexField(Data::Db::TDataSet* aDataSet, int aFieldIndex);
	virtual int __fastcall GetIndexFieldCount(Data::Db::TDataSet* aDataSet);
	virtual void __fastcall GetIndexFieldNames(Data::Db::TDataSet* aDataSet, System::UnicodeString &aIndexFieldNames);
	virtual void __fastcall GetIndexName(Data::Db::TDataSet* aDataSet, System::UnicodeString &aIndexName);
	virtual bool __fastcall IsChildDataSet(Data::Db::TDataSet* aDataSet);
	virtual void __fastcall SetIndexFieldNames(Data::Db::TDataSet* aDataSet, const System::UnicodeString aIndexFieldNames);
	virtual void __fastcall SetIndexName(Data::Db::TDataSet* aDataSet, const System::UnicodeString aIndexName);
public:
	/* TComponent.Create */ inline __fastcall virtual TOvcDbEngineHelperBase(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TOvcDbEngineHelperBase(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall OvcFindNearestKey(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, System::TVarRec const *aKeyValues, const int aKeyValues_High);
extern DELPHI_PACKAGE void __fastcall OvcGetAliasDriverName(TOvcDbEngineHelperBase* aHelper, const System::UnicodeString aAlias, System::UnicodeString &aDriver);
extern DELPHI_PACKAGE void __fastcall OvcGetAliasNames(TOvcDbEngineHelperBase* aHelper, System::Classes::TStrings* aList);
extern DELPHI_PACKAGE void __fastcall OvcGetAliasPath(TOvcDbEngineHelperBase* aHelper, const System::UnicodeString aAlias, System::UnicodeString &aPath);
extern DELPHI_PACKAGE Data::Db::TIndexDefs* __fastcall OvcGetIndexDefs(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet);
extern DELPHI_PACKAGE Data::Db::TField* __fastcall OvcGetIndexField(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, int aFieldIndex);
extern DELPHI_PACKAGE int __fastcall OvcGetIndexFieldCount(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet);
extern DELPHI_PACKAGE void __fastcall OvcGetIndexFieldNames(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, System::UnicodeString &aIndexFieldNames);
extern DELPHI_PACKAGE void __fastcall OvcGetIndexName(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, System::UnicodeString &aIndexName);
extern DELPHI_PACKAGE bool __fastcall OvcIsChildDataSet(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet);
extern DELPHI_PACKAGE void __fastcall OvcSetIndexFieldNames(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, const System::UnicodeString aIndexFieldNames);
extern DELPHI_PACKAGE void __fastcall OvcSetIndexName(TOvcDbEngineHelperBase* aHelper, Data::Db::TDataSet* aDataSet, const System::UnicodeString aIndexName);
extern DELPHI_PACKAGE void __fastcall OvcGetTableNames(TOvcDbEngineHelperBase* aHelper, const System::UnicodeString aAlias, System::Classes::TStrings* aList);
}	/* namespace Ovcdbhll */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBHLL)
using namespace Ovcdbhll;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbhllHPP

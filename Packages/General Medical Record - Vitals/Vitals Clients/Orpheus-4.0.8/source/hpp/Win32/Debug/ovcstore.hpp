// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcstore.pas' rev: 29.00 (Windows)

#ifndef OvcstoreHPP
#define OvcstoreHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Win.Registry.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.SysUtils.hpp>
#include <System.IniFiles.hpp>
#include <ovcfiler.hpp>
#include <ovcstr.hpp>
#include <System.StrUtils.hpp>
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcstore
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcVirtualStore;
class DELPHICLASS TOvcRegistryStore;
class DELPHICLASS TOvcIniFileStore;
class DELPHICLASS TElement;
class DELPHICLASS TO32XMLFileStore;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOvcReadStrEvent)(const System::UnicodeString Section, const System::UnicodeString Item, System::UnicodeString &Value);

typedef void __fastcall (__closure *TOvcWriteStrEvent)(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString Value);

typedef void __fastcall (__closure *TOvcEraseSectEvent)(const System::UnicodeString Section);

class PASCALIMPLEMENTATION TOvcVirtualStore : public Ovcfiler::TOvcAbstractStore
{
	typedef Ovcfiler::TOvcAbstractStore inherited;
	
protected:
	System::Classes::TNotifyEvent FOnCloseStore;
	System::Classes::TNotifyEvent FOnOpenStore;
	TOvcReadStrEvent FOnReadString;
	TOvcWriteStrEvent FOnWriteString;
	TOvcEraseSectEvent FOnEraseSection;
	virtual void __fastcall DoOpen(void);
	virtual void __fastcall DoClose(void);
	
public:
	virtual System::UnicodeString __fastcall ReadString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString DefaultValue);
	virtual void __fastcall WriteString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString Value);
	virtual void __fastcall EraseSection(const System::UnicodeString Section);
	
__published:
	__property System::Classes::TNotifyEvent OnCloseStore = {read=FOnCloseStore, write=FOnCloseStore};
	__property System::Classes::TNotifyEvent OnOpenStore = {read=FOnOpenStore, write=FOnOpenStore};
	__property TOvcReadStrEvent OnReadString = {read=FOnReadString, write=FOnReadString};
	__property TOvcWriteStrEvent OnWriteString = {read=FOnWriteString, write=FOnWriteString};
	__property TOvcEraseSectEvent OnEraseSection = {read=FOnEraseSection, write=FOnEraseSection};
public:
	/* TOvcComponent.Create */ inline __fastcall virtual TOvcVirtualStore(System::Classes::TComponent* AOwner) : Ovcfiler::TOvcAbstractStore(AOwner) { }
	/* TOvcComponent.Destroy */ inline __fastcall virtual ~TOvcVirtualStore(void) { }
	
};


enum DECLSPEC_DENUM TOvcRegistryRoot : unsigned char { rrCurrentUser, rrLocalMachine };

class PASCALIMPLEMENTATION TOvcRegistryStore : public Ovcfiler::TOvcAbstractStore
{
	typedef Ovcfiler::TOvcAbstractStore inherited;
	
protected:
	System::UnicodeString FKeyName;
	TOvcRegistryRoot FRegistryRoot;
	System::Win::Registry::TRegIniFile* FStore;
	System::UnicodeString __fastcall GetKeyName(void);
	void __fastcall SetKeyName(const System::UnicodeString Value);
	virtual void __fastcall DoOpen(void);
	virtual void __fastcall DoClose(void);
	
public:
	virtual System::UnicodeString __fastcall ReadString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString DefaultValue);
	virtual void __fastcall WriteString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString Value);
	virtual void __fastcall EraseSection(const System::UnicodeString Section);
	
__published:
	__property System::UnicodeString KeyName = {read=GetKeyName, write=SetKeyName};
	__property TOvcRegistryRoot RegistryRoot = {read=FRegistryRoot, write=FRegistryRoot, default=0};
public:
	/* TOvcComponent.Create */ inline __fastcall virtual TOvcRegistryStore(System::Classes::TComponent* AOwner) : Ovcfiler::TOvcAbstractStore(AOwner) { }
	/* TOvcComponent.Destroy */ inline __fastcall virtual ~TOvcRegistryStore(void) { }
	
};


class PASCALIMPLEMENTATION TOvcIniFileStore : public Ovcfiler::TOvcAbstractStore
{
	typedef Ovcfiler::TOvcAbstractStore inherited;
	
protected:
	System::UnicodeString FIniFileName;
	System::Inifiles::TIniFile* FStore;
	bool FUseExeDir;
	System::UnicodeString __fastcall GetIniFileName(void);
	virtual void __fastcall DoOpen(void);
	virtual void __fastcall DoClose(void);
	
public:
	virtual System::UnicodeString __fastcall ReadString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString DefaultValue);
	virtual void __fastcall WriteString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString Value);
	virtual void __fastcall EraseSection(const System::UnicodeString Section);
	
__published:
	__property System::UnicodeString IniFileName = {read=GetIniFileName, write=FIniFileName};
	__property bool UseExeDir = {read=FUseExeDir, write=FUseExeDir, default=0};
public:
	/* TOvcComponent.Create */ inline __fastcall virtual TOvcIniFileStore(System::Classes::TComponent* AOwner) : Ovcfiler::TOvcAbstractStore(AOwner) { }
	/* TOvcComponent.Destroy */ inline __fastcall virtual ~TOvcIniFileStore(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TElement : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString ElementName;
	int Index;
	int ParentIndex;
	System::UnicodeString Indent;
	System::UnicodeString Value;
	bool EndingTag;
public:
	/* TObject.Create */ inline __fastcall TElement(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TElement(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TO32XMLFileStore : public Ovcfiler::TOvcAbstractStore
{
	typedef Ovcfiler::TOvcAbstractStore inherited;
	
protected:
	System::UnicodeString FXMLFileName;
	System::Classes::TStringList* FStore;
	bool FUseExeDir;
	System::Classes::TList* xsElementList;
	int xsTagStart;
	int xsTagStop;
	bool xsChanged;
	System::UnicodeString __fastcall GetXMLFileName(void);
	virtual void __fastcall DoOpen(void);
	virtual void __fastcall DoClose(void);
	void __fastcall xsInitialize(void);
	void __fastcall xsInitializeElementList(void);
	bool __fastcall xsIsValidXMLFile(void);
	void __fastcall xsParseXML(void);
	int __fastcall xsParseElement(int BeginPos);
	void __fastcall xsAddToElementList(const System::UnicodeString ElementName, int ParentIndex, const System::UnicodeString Indent, const System::UnicodeString Value, bool EndingTag);
	void __fastcall xsInsertInElementList(int Index, const System::UnicodeString ElementName, int ParentIndex, const System::UnicodeString Indent, const System::UnicodeString Value);
	void __fastcall xsDeleteFromElementList(int Index);
	void __fastcall xsWriteXMLFile(void);
	System::UnicodeString __fastcall xsStripElement(const System::UnicodeString Element);
	System::UnicodeString __fastcall xsGetIndentOf(int ElementIndex);
	System::UnicodeString __fastcall xsGetFStoreIndentOf(int Index);
	System::UnicodeString __fastcall xsGetFStoreValueOf(int Index);
	int __fastcall xsFindElement(const System::UnicodeString Item, int StartAt);
	void __fastcall xsAdjustParentIndex(int StartingAt, bool Inc);
	int __fastcall xsFindClosingTag(int OpeningTagIndex);
	
public:
	__fastcall virtual TO32XMLFileStore(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32XMLFileStore(void);
	virtual System::UnicodeString __fastcall ReadString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString DefaultValue);
	virtual void __fastcall WriteString(const System::UnicodeString Section, const System::UnicodeString Item, const System::UnicodeString Value);
	HIDESBASE void __fastcall WriteBoolean(const System::UnicodeString Parent, const System::UnicodeString Element, bool Value);
	HIDESBASE void __fastcall WriteInteger(const System::UnicodeString Parent, const System::UnicodeString Element, int Value);
	void __fastcall WriteStr(const System::UnicodeString Parent, const System::UnicodeString Element, const System::UnicodeString Value);
	HIDESBASE bool __fastcall ReadBoolean(const System::UnicodeString Parent, const System::UnicodeString Element);
	HIDESBASE int __fastcall ReadInteger(const System::UnicodeString Parent, const System::UnicodeString Element);
	System::UnicodeString __fastcall ReadStr(const System::UnicodeString Parent, const System::UnicodeString Element, const System::UnicodeString DefaultValue);
	virtual void __fastcall EraseSection(const System::UnicodeString Section);
	
__published:
	__property System::UnicodeString XMLFileName = {read=GetXMLFileName, write=FXMLFileName};
	__property bool UseExeDir = {read=FUseExeDir, write=FUseExeDir, default=0};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcstore */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSTORE)
using namespace Ovcstore;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcstoreHPP

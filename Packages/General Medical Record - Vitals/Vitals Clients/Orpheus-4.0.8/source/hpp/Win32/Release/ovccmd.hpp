// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccmd.pas' rev: 29.00 (Windows)

#ifndef OvccmdHPP
#define OvccmdHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccmd
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCommandTable;
class DELPHICLASS TOvcCommandProcessor;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcProcessorState : unsigned char { stNone, stPartial, stLiteral };

typedef void __fastcall (__closure *TUserCommandEvent)(System::TObject* Sender, System::Word Command);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcCommandTable : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	Ovcdata::TOvcCmdRec operator[](int Index) { return Commands[Index]; }
	
protected:
	bool FActive;
	System::Classes::TList* FCommandList;
	System::UnicodeString FTableName;
	Ovcdata::TOvcCmdRec __fastcall GetCmdRec(int Index);
	int __fastcall GetCount(void);
	void __fastcall PutCmdRec(int Index, const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall ctDisposeCommandEntry(Ovcdata::POvcCmdRec P);
	Ovcdata::POvcCmdRec __fastcall ctNewCommandEntry(const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall ctReadData(System::Classes::TReader* Reader);
	void __fastcall ctWriteData(System::Classes::TWriter* Writer);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	__fastcall TOvcCommandTable(void);
	__fastcall virtual ~TOvcCommandTable(void);
	int __fastcall AddRec(const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	void __fastcall Exchange(int Index1, int Index2);
	int __fastcall IndexOf(const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall InsertRec(int Index, const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	void __fastcall Move(int CurIndex, int NewIndex);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	__property Ovcdata::TOvcCmdRec Commands[int Index] = {read=GetCmdRec, write=PutCmdRec/*, default*/};
	__property int Count = {read=GetCount, stored=false, nodefault};
	__property bool IsActive = {read=FActive, write=FActive, nodefault};
	__property System::UnicodeString TableName = {read=FTableName, write=FTableName};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcCommandProcessor : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TOvcCommandTable* operator[](int Index) { return Table[Index]; }
	
protected:
	System::Classes::TList* FTableList;
	TOvcProcessorState cpState;
	System::Byte cpSaveKey;
	System::Byte cpSaveSS;
	int __fastcall GetCount(void);
	TOvcCommandTable* __fastcall GetTable(int Index);
	void __fastcall SetTable(int Index, TOvcCommandTable* CT);
	Ovcdata::TOvcCmdRec __fastcall cpFillCommandRec(System::Byte Key1, System::Byte ShiftState1, System::Byte Key2, System::Byte ShiftState2, System::Word Command);
	void __fastcall cpReadData(System::Classes::TReader* Reader);
	System::Word __fastcall cpScanTable(TOvcCommandTable* CT, System::Byte Key, System::Byte SFlags);
	void __fastcall cpWriteData(System::Classes::TWriter* Writer);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	__fastcall TOvcCommandProcessor(void);
	__fastcall virtual ~TOvcCommandProcessor(void);
	void __fastcall Add(TOvcCommandTable* CT);
	void __fastcall AddCommand(const System::UnicodeString TableName, System::Byte Key1, System::Byte ShiftState1, System::Byte Key2, System::Byte ShiftState2, System::Word Command);
	void __fastcall AddCommandRec(const System::UnicodeString TableName, const Ovcdata::TOvcCmdRec &CmdRec);
	void __fastcall ChangeTableName(const System::UnicodeString OldName, const System::UnicodeString NewName);
	void __fastcall Clear(void);
	int __fastcall CreateCommandTable(const System::UnicodeString TableName, bool Active);
	void __fastcall Delete(int Index);
	void __fastcall DeleteCommand(const System::UnicodeString TableName, System::Byte Key1, System::Byte ShiftState1, System::Byte Key2, System::Byte ShiftState2);
	void __fastcall DeleteCommandTable(const System::UnicodeString TableName);
	void __fastcall Exchange(int Index1, int Index2);
	int __fastcall GetCommandCount(const System::UnicodeString TableName);
	TOvcCommandTable* __fastcall GetCommandTable(const System::UnicodeString TableName);
	void __fastcall GetState(TOvcProcessorState &State, System::Byte &Key, System::Byte &Shift);
	int __fastcall GetCommandTableIndex(const System::UnicodeString TableName);
	virtual int __fastcall LoadCommandTable(const System::UnicodeString FileName);
	void __fastcall ResetCommandProcessor(void);
	virtual void __fastcall SaveCommandTable(const System::UnicodeString TableName, const System::UnicodeString FileName);
	void __fastcall SetScanPriority(System::UnicodeString const *Names, const int Names_High);
	void __fastcall SetState(TOvcProcessorState State, System::Byte Key, System::Byte Shift);
	System::Word __fastcall Translate(Winapi::Messages::TMessage &Msg);
	System::Word __fastcall TranslateUsing(System::UnicodeString const *Tables, const int Tables_High, Winapi::Messages::TMessage &Msg);
	System::Word __fastcall TranslateKey(System::Word Key, System::Classes::TShiftState ShiftState);
	System::Word __fastcall TranslateKeyUsing(System::UnicodeString const *Tables, const int Tables_High, System::Word Key, System::Classes::TShiftState ShiftState);
	__property int Count = {read=GetCount, stored=false, nodefault};
	__property TOvcCommandTable* Table[int Index] = {read=GetTable, write=SetTable/*, default*/};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::StaticArray<Ovcdata::TOvcCmdRec, 64> DefCommandTable;
static const System::Int8 DefWsMaxCommands = System::Int8(0x28);
extern DELPHI_PACKAGE System::StaticArray<Ovcdata::TOvcCmdRec, 40> DefWsCommandTable;
static const System::Int8 DefGridMaxCommands = System::Int8(0x26);
extern DELPHI_PACKAGE System::StaticArray<Ovcdata::TOvcCmdRec, 38> DefGridCommandTable;
}	/* namespace Ovccmd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCMD)
using namespace Ovccmd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccmdHPP

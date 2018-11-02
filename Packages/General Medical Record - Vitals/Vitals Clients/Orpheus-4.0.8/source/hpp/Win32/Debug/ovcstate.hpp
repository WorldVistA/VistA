// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcstate.pas' rev: 29.00 (Windows)

#ifndef OvcstateHPP
#define OvcstateHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovcfiler.hpp>
#include <ovcexcpt.hpp>
#include <ovcconst.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcstate
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcAbstractState;
class DELPHICLASS TOvcFormState;
class DELPHICLASS TOvcComponentState;
class DELPHICLASS TOvcPersistentState;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcFormStateOption : unsigned char { fsState, fsPosition, fsNoSize, fsColor, fsActiveControl, fsDefaultMonitor };

typedef System::Set<TOvcFormStateOption, TOvcFormStateOption::fsState, TOvcFormStateOption::fsDefaultMonitor> TOvcFormStateOptions;

class PASCALIMPLEMENTATION TOvcAbstractState : public Ovcbase::TOvcComponent
{
	typedef Ovcbase::TOvcComponent inherited;
	
protected:
	bool FActive;
	System::UnicodeString FSection;
	Ovcfiler::TOvcAbstractStore* FStorage;
	System::Classes::TNotifyEvent FOnSaveState;
	System::Classes::TNotifyEvent FOnRestoreState;
	bool isDestroying;
	bool isRestored;
	bool isSaved;
	System::Classes::TNotifyEvent isSaveFormCreate;
	System::Classes::TNotifyEvent isSaveFormDestroy;
	Vcl::Forms::TCloseQueryEvent isSaveFormCloseQuery;
	Vcl::Controls::TWinControl* __fastcall GetForm(void);
	System::UnicodeString __fastcall GetSection(void);
	System::UnicodeString __fastcall GetSpecialValue(const System::UnicodeString Item);
	void __fastcall SetSpecialValue(const System::UnicodeString Item, const System::UnicodeString Value);
	void __fastcall SetStorage(Ovcfiler::TOvcAbstractStore* Value);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall RestoreEvents(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall DoOnRestoreState(void);
	DYNAMIC void __fastcall DoOnSaveState(void);
	virtual void __fastcall RestoreStatePrim(void) = 0 ;
	virtual void __fastcall SaveStatePrim(void) = 0 ;
	DYNAMIC void __fastcall SetEvents(void);
	__property Vcl::Controls::TWinControl* Form = {read=GetForm};
	__property bool Active = {read=FActive, write=FActive, nodefault};
	__property System::UnicodeString Section = {read=GetSection, write=FSection};
	__property Ovcfiler::TOvcAbstractStore* Storage = {read=FStorage, write=SetStorage};
	__property System::Classes::TNotifyEvent OnSaveState = {read=FOnSaveState, write=FOnSaveState};
	__property System::Classes::TNotifyEvent OnRestoreState = {read=FOnRestoreState, write=FOnRestoreState};
	
public:
	__fastcall virtual TOvcAbstractState(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcAbstractState(void);
	void __fastcall RestoreState(void);
	void __fastcall SaveState(void);
	__property System::UnicodeString SpecialValue[const System::UnicodeString Item] = {read=GetSpecialValue, write=SetSpecialValue};
};


class PASCALIMPLEMENTATION TOvcFormState : public TOvcAbstractState
{
	typedef TOvcAbstractState inherited;
	
protected:
	TOvcFormStateOptions FOptions;
	bool FDefMaximize;
	void __fastcall UpdateFormState(void);
	void __fastcall ReadFormState(Vcl::Controls::TWinControl* Form, const System::UnicodeString Section);
	void __fastcall WriteFormState(Vcl::Controls::TWinControl* Form, const System::UnicodeString Section);
	virtual void __fastcall RestoreStatePrim(void);
	virtual void __fastcall SaveStatePrim(void);
	
public:
	__fastcall virtual TOvcFormState(System::Classes::TComponent* AOwner);
	
__published:
	__property Active = {default=1};
	__property TOvcFormStateOptions Options = {read=FOptions, write=FOptions, nodefault};
	__property Section = {default=0};
	__property Storage;
	__property OnSaveState;
	__property OnRestoreState;
public:
	/* TOvcAbstractState.Destroy */ inline __fastcall virtual ~TOvcFormState(void) { }
	
};


class PASCALIMPLEMENTATION TOvcComponentState : public TOvcAbstractState
{
	typedef TOvcAbstractState inherited;
	
protected:
	System::Classes::TStrings* FStoredProperties;
	void __fastcall SetStoredProperties(System::Classes::TStrings* Value);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall RestoreStatePrim(void);
	virtual void __fastcall SaveStatePrim(void);
	virtual void __fastcall WriteState(System::Classes::TWriter* Writer);
	
public:
	__fastcall virtual TOvcComponentState(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcComponentState(void);
	void __fastcall SetNotification(void);
	void __fastcall UpdateStoredProperties(void);
	
__published:
	__property Active = {default=1};
	__property Section = {default=0};
	__property Storage;
	__property System::Classes::TStrings* StoredProperties = {read=FStoredProperties, write=SetStoredProperties};
	__property OnSaveState;
	__property OnRestoreState;
};


class PASCALIMPLEMENTATION TOvcPersistentState : public Ovcbase::TOvcComponent
{
	typedef Ovcbase::TOvcComponent inherited;
	
protected:
	Ovcfiler::TOvcAbstractStore* FStorage;
	void __fastcall SetStorage(Ovcfiler::TOvcAbstractStore* Value);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	void __fastcall RestoreState(System::Classes::TPersistent* AnObject, const System::UnicodeString ASection);
	void __fastcall SaveState(System::Classes::TPersistent* AnObject, const System::UnicodeString ASection);
	
__published:
	__property Ovcfiler::TOvcAbstractStore* Storage = {read=FStorage, write=SetStorage};
public:
	/* TOvcComponent.Create */ inline __fastcall virtual TOvcPersistentState(System::Classes::TComponent* AOwner) : Ovcbase::TOvcComponent(AOwner) { }
	/* TOvcComponent.Destroy */ inline __fastcall virtual ~TOvcPersistentState(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetDefaultSection(System::Classes::TComponent* Component);
}	/* namespace Ovcstate */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSTATE)
using namespace Ovcstate;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcstateHPP

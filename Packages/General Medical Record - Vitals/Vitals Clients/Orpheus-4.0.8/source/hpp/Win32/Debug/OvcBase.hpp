// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbase.pas' rev: 29.00 (Windows)

#ifndef OvcbaseHPP
#define OvcbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovccmd.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovcconst.hpp>
#include <ovcexcpt.hpp>
#include <ovctimer.hpp>
#include <ovcdate.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbase
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcAttachedLabel;
class DELPHICLASS TO32ContainerList;
class DELPHICLASS TOvcLabelInfo;
class DELPHICLASS TOvcComponent;
class DELPHICLASS TO32Component;
class DELPHICLASS TOvcController;
class DELPHICLASS TOvcGraphicControl;
class DELPHICLASS TO32CustomControl;
class DELPHICLASS TOvcCustomControl;
class DELPHICLASS TOvcCollectible;
class DELPHICLASS TO32CollectionItem;
class DELPHICLASS TOvcCollectibleControl;
class DELPHICLASS TOvcCollection;
class DELPHICLASS TO32Collection;
class DELPHICLASS TOvcCollectionStreamer;
class DELPHICLASS TOvcCustomControlEx;
class DELPHICLASS TOvcPopupWindow;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcLabelPosition : unsigned char { lpTopLeft, lpBottomLeft };

typedef void __fastcall (__closure *TOvcAttachEvent)(System::TObject* Sender, bool Value);

class PASCALIMPLEMENTATION TOvcAttachedLabel : public Vcl::Stdctrls::TLabel
{
	typedef Vcl::Stdctrls::TLabel inherited;
	
protected:
	Vcl::Controls::TWinControl* FControl;
	void __fastcall SavePosition(void);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TOvcAttachedLabel(System::Classes::TComponent* AOwner);
	__fastcall virtual TOvcAttachedLabel(System::Classes::TComponent* AOwner, Vcl::Controls::TWinControl* AControl);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	
__published:
	__property Vcl::Controls::TWinControl* Control = {read=FControl, write=FControl};
public:
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TOvcAttachedLabel(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32ContainerList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
public:
	System::Classes::TComponent* FOwner;
	__fastcall virtual TO32ContainerList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32ContainerList(void);
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcLabelInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	int FOffsetX;
	int FOffsetY;
	System::Classes::TNotifyEvent FOnChange;
	TOvcAttachEvent FOnAttach;
	void __fastcall DoOnAttach(void);
	void __fastcall DoOnChange(void);
	bool __fastcall IsVisible(void);
	void __fastcall SetOffsetX(int Value);
	void __fastcall SetOffsetY(int Value);
	void __fastcall SetVisible(bool Value);
	
public:
	TOvcAttachedLabel* ALabel;
	bool FVisible;
	__property TOvcAttachEvent OnAttach = {read=FOnAttach, write=FOnAttach};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	void __fastcall SetOffsets(int X, int Y);
	
__published:
	__property int OffsetX = {read=FOffsetX, write=SetOffsetX, stored=IsVisible, nodefault};
	__property int OffsetY = {read=FOffsetY, write=SetOffsetY, stored=IsVisible, nodefault};
	__property bool Visible = {read=FVisible, write=SetVisible, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcLabelInfo(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcLabelInfo(void) : System::Classes::TPersistent() { }
	
};


typedef void __fastcall (__closure *TMouseWheelEvent)(System::TObject* Sender, System::Classes::TShiftState Shift, System::Word Delta, System::Word XPos, System::Word YPos);

typedef void __fastcall (__closure *TDataErrorEvent)(System::TObject* Sender, System::Word ErrorCode, const System::UnicodeString ErrorMsg);

typedef void __fastcall (__closure *TPostEditEvent)(System::TObject* Sender, Vcl::Controls::TWinControl* GainingControl);

typedef void __fastcall (__closure *TPreEditEvent)(System::TObject* Sender, Vcl::Controls::TWinControl* LosingControl);

typedef void __fastcall (__closure *TDelayNotifyEvent)(System::TObject* Sender, System::Word NotifyCode);

typedef void __fastcall (__closure *TIsSpecialControlEvent)(System::TObject* Sender, Vcl::Controls::TWinControl* Control, bool &Special);

typedef void __fastcall (__closure *TGetEpochEvent)(System::TObject* Sender, int &Epoch);

enum DECLSPEC_DENUM TOvcBaseEFOption : unsigned char { efoAutoAdvanceChar, efoAutoAdvanceLeftRight, efoAutoAdvanceUpDown, efoAutoSelect, efoBeepOnError, efoInsertPushes };

typedef System::Set<TOvcBaseEFOption, TOvcBaseEFOption::efoAutoAdvanceChar, TOvcBaseEFOption::efoInsertPushes> TOvcBaseEFOptions;

class PASCALIMPLEMENTATION TOvcComponent : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	TOvcCollectionStreamer* FCollectionStreamer;
	bool FInternal;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TOvcComponent(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcComponent(void);
	__property TOvcCollectionStreamer* CollectionStreamer = {read=FCollectionStreamer, write=FCollectionStreamer};
	__property bool Internal = {read=FInternal, write=FInternal, nodefault};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
};


class PASCALIMPLEMENTATION TO32Component : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	bool FInternal;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	
public:
	__fastcall virtual TO32Component(System::Classes::TComponent* AOwner);
	__property bool Internal = {read=FInternal, write=FInternal, nodefault};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TO32Component(void) { }
	
};


class PASCALIMPLEMENTATION TOvcController : public TOvcComponent
{
	typedef TOvcComponent inherited;
	
protected:
	TOvcBaseEFOptions FBaseEFOptions;
	Ovccmd::TOvcCommandProcessor* FEntryCommands;
	int FEpoch;
	bool FErrorPending;
	System::UnicodeString FErrorText;
	HWND FHandle;
	bool FInsertMode;
	Ovctimer::TOvcTimerPool* FTimerPool;
	TDelayNotifyEvent FOnDelayNotify;
	TDataErrorEvent FOnError;
	TGetEpochEvent FOnGetEpoch;
	TIsSpecialControlEvent FOnIsSpecialControl;
	TPostEditEvent FOnPostEdit;
	TPreEditEvent FOnPreEdit;
	Ovctimer::TTriggerEvent FOnTimerTrigger;
	int __fastcall GetEpoch(void);
	HWND __fastcall GetHandle(void);
	void __fastcall SetEpoch(int Value);
	void __fastcall cWndProc(Winapi::Messages::TMessage &Msg);
	
public:
	__fastcall virtual TOvcController(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcController(void);
	void __fastcall DestroyHandle(void);
	void __fastcall DoOnPostEdit(System::TObject* Sender, Vcl::Controls::TWinControl* GainingControl);
	void __fastcall DoOnPreEdit(System::TObject* Sender, Vcl::Controls::TWinControl* LosingControl);
	void __fastcall DoOnTimerTrigger(System::TObject* Sender, int Handle, unsigned Interval, int ElapsedTime);
	void __fastcall DelayNotify(System::TObject* Sender, System::Word NotifyCode);
	void __fastcall DoOnError(System::TObject* Sender, System::Word ErrorCode, const System::UnicodeString ErrorMsg);
	DYNAMIC bool __fastcall IsSpecialButton(HWND H);
	void __fastcall MarkAsUninitialized(bool Uninitialized);
	System::Classes::TComponent* __fastcall ValidateEntryFields(void);
	System::Classes::TComponent* __fastcall ValidateEntryFieldsEx(bool ReportError, bool ChangeFocus);
	System::Classes::TComponent* __fastcall ValidateTheseEntryFields(System::Classes::TComponent* const *Fields, const int Fields_High);
	__property bool ErrorPending = {read=FErrorPending, write=FErrorPending, nodefault};
	__property System::UnicodeString ErrorText = {read=FErrorText, write=FErrorText};
	__property HWND Handle = {read=GetHandle, nodefault};
	__property bool InsertMode = {read=FInsertMode, write=FInsertMode, nodefault};
	__property Ovctimer::TOvcTimerPool* TimerPool = {read=FTimerPool};
	
__published:
	__property Ovccmd::TOvcCommandProcessor* EntryCommands = {read=FEntryCommands, write=FEntryCommands, stored=true};
	__property TOvcBaseEFOptions EntryOptions = {read=FBaseEFOptions, write=FBaseEFOptions, default=56};
	__property int Epoch = {read=GetEpoch, write=SetEpoch, nodefault};
	__property TDataErrorEvent OnError = {read=FOnError, write=FOnError};
	__property TGetEpochEvent OnGetEpoch = {read=FOnGetEpoch, write=FOnGetEpoch};
	__property TDelayNotifyEvent OnDelayNotify = {read=FOnDelayNotify, write=FOnDelayNotify};
	__property TIsSpecialControlEvent OnIsSpecialControl = {read=FOnIsSpecialControl, write=FOnIsSpecialControl};
	__property TPostEditEvent OnPostEdit = {read=FOnPostEdit, write=FOnPostEdit};
	__property TPreEditEvent OnPreEdit = {read=FOnPreEdit, write=FOnPreEdit};
	__property Ovctimer::TTriggerEvent OnTimerTrigger = {read=FOnTimerTrigger, write=FOnTimerTrigger};
};


class PASCALIMPLEMENTATION TOvcGraphicControl : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
protected:
	TOvcCollectionStreamer* FCollectionStreamer;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TOvcGraphicControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcGraphicControl(void);
	__property TOvcCollectionStreamer* CollectionStreamer = {read=FCollectionStreamer, write=FCollectionStreamer};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
};


class PASCALIMPLEMENTATION TO32CustomControl : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
protected:
	System::Classes::TNotifyEvent FAfterEnter;
	System::Classes::TNotifyEvent FAfterExit;
	TMouseWheelEvent FOnMouseWheel;
	TOvcLabelInfo* FLabelInfo;
	bool FInternal;
	TOvcAttachedLabel* __fastcall GetAttachedLabel(void);
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall LabelAttach(System::TObject* Sender, bool Value);
	void __fastcall LabelChange(System::TObject* Sender);
	void __fastcall PositionLabel(void);
	MESSAGE void __fastcall OMAssignLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMPositionLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMRecordLabelPosition(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterEnter(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterExit(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	TOvcLabelPosition DefaultLabelPosition;
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property System::Classes::TNotifyEvent AfterEnter = {read=FAfterEnter, write=FAfterEnter};
	__property System::Classes::TNotifyEvent AfterExit = {read=FAfterExit, write=FAfterExit};
	__property TMouseWheelEvent OnMouseWheel = {read=FOnMouseWheel, write=FOnMouseWheel};
	__property TOvcLabelInfo* LabelInfo = {read=FLabelInfo, write=FLabelInfo};
	
public:
	__property bool Internal = {read=FInternal, write=FInternal, nodefault};
	__fastcall virtual TO32CustomControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomControl(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property TOvcAttachedLabel* AttachedLabel = {read=GetAttachedLabel};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomControl(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCustomControl : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
protected:
	System::Classes::TNotifyEvent FAfterEnter;
	System::Classes::TNotifyEvent FAfterExit;
	TOvcCollectionStreamer* FCollectionStreamer;
	TMouseWheelEvent FOnMouseWheel;
	TOvcLabelInfo* FLabelInfo;
	bool FInternal;
	TOvcAttachedLabel* __fastcall GetAttachedLabel(void);
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall LabelAttach(System::TObject* Sender, bool Value);
	void __fastcall LabelChange(System::TObject* Sender);
	void __fastcall PositionLabel(void);
	MESSAGE void __fastcall OMAssignLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMPositionLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMRecordLabelPosition(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterEnter(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterExit(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	TOvcLabelPosition DefaultLabelPosition;
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	virtual void __fastcall Loaded(void);
	__property System::Classes::TNotifyEvent AfterEnter = {read=FAfterEnter, write=FAfterEnter};
	__property System::Classes::TNotifyEvent AfterExit = {read=FAfterExit, write=FAfterExit};
	__property TMouseWheelEvent OnMouseWheel = {read=FOnMouseWheel, write=FOnMouseWheel};
	__property TOvcLabelInfo* LabelInfo = {read=FLabelInfo, write=FLabelInfo};
	
public:
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	__fastcall virtual TOvcCustomControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomControl(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property TOvcAttachedLabel* AttachedLabel = {read=GetAttachedLabel};
	__property TOvcCollectionStreamer* CollectionStreamer = {read=FCollectionStreamer, write=FCollectionStreamer};
	__property bool Internal = {read=FInternal, write=FInternal, nodefault};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomControl(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCollectible : public TOvcComponent
{
	typedef TOvcComponent inherited;
	
protected:
	TOvcCollection* FCollection;
	bool InChanged;
	int __fastcall GetIndex(void);
	void __fastcall SetCollection(TOvcCollection* Value);
	virtual void __fastcall SetIndex(int Value);
	DYNAMIC void __fastcall Changed(void);
	DYNAMIC System::UnicodeString __fastcall GenerateName(void);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	
public:
	__fastcall virtual TOvcCollectible(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCollectible(void);
	__property TOvcCollection* Collection = {read=FCollection};
	__property System::UnicodeString DisplayText = {read=GetDisplayText};
	__property int Index = {read=GetIndex, write=SetIndex, nodefault};
	__property Name = {default=0};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32CollectionItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FName;
	System::UnicodeString FDisplayText;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	virtual void __fastcall SetName(System::UnicodeString Value);
	
public:
	__property System::UnicodeString DisplayText = {read=FDisplayText, write=FDisplayText};
	__property System::UnicodeString Name = {read=FName, write=SetName};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TO32CollectionItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TO32CollectionItem(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcCollectibleControl : public TOvcCustomControl
{
	typedef TOvcCustomControl inherited;
	
protected:
	TOvcCollection* FCollection;
	bool FInternal;
	bool InChanged;
	int __fastcall GetIndex(void);
	void __fastcall SetCollection(TOvcCollection* Value);
	void __fastcall SetIndex(int Value);
	HIDESBASEDYNAMIC void __fastcall Changed(void);
	DYNAMIC System::UnicodeString __fastcall GenerateName(void);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	
public:
	__fastcall virtual TOvcCollectibleControl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCollectibleControl(void);
	__property bool Internal = {read=FInternal, write=FInternal, nodefault};
	__property TOvcCollection* Collection = {read=FCollection};
	__property System::UnicodeString DisplayText = {read=GetDisplayText};
	__property int Index = {read=GetIndex, write=SetIndex, nodefault};
	__property Name = {default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCollectibleControl(HWND ParentWindow) : TOvcCustomControl(ParentWindow) { }
	
};


typedef System::TMetaClass* TOvcCollectibleClass;

typedef System::TMetaClass* TO32CollectibleClass;

typedef void __fastcall (__closure *TOvcItemSelectedEvent)(System::TObject* Sender, int Index);

typedef void __fastcall (__closure *TOvcGetEditorCaption)(System::UnicodeString &Caption);

typedef void __fastcall (__closure *TO32GetEditorCaption)(System::UnicodeString &Caption);

class PASCALIMPLEMENTATION TOvcCollection : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	System::Classes::TComponent* operator[](int Index) { return Item[Index]; }
	
protected:
	TOvcCollectibleClass FItemClass;
	Vcl::Forms::TForm* FItemEditor;
	System::Classes::TList* FItems;
	System::Classes::TComponent* FOwner;
	bool FReadOnly;
	bool FStored;
	TOvcCollectionStreamer* FStreamer;
	System::Classes::TNotifyEvent FOnChanged;
	TOvcItemSelectedEvent FOnItemSelected;
	TOvcGetEditorCaption FOnGetEditorCaption;
	bool InLoaded;
	bool IsLoaded;
	bool InChanged;
	int __fastcall GetCount(void);
	System::Classes::TComponent* __fastcall GetItem(int Index);
	void __fastcall SetItem(int Index, System::Classes::TComponent* Value);
	virtual void __fastcall Changed(void);
	void __fastcall Loaded(void);
	
public:
	__fastcall TOvcCollection(System::Classes::TComponent* AOwner, TOvcCollectibleClass ItemClass);
	__fastcall virtual ~TOvcCollection(void);
	__property Vcl::Forms::TForm* ItemEditor = {read=FItemEditor, write=FItemEditor};
	System::Classes::TComponent* __fastcall Add(void);
	virtual void __fastcall Clear(void);
	void __fastcall Delete(int Index);
	void __fastcall DoOnItemSelected(int Index);
	System::UnicodeString __fastcall GetEditorCaption(void);
	System::Classes::TComponent* __fastcall ItemByName(const System::UnicodeString Name);
	System::Classes::TComponent* __fastcall Insert(int Index);
	Vcl::Forms::TForm* __fastcall ParentForm(void);
	__property int Count = {read=GetCount, nodefault};
	__property TOvcCollectibleClass ItemClass = {read=FItemClass};
	__property System::Classes::TComponent* Item[int Index] = {read=GetItem, write=SetItem/*, default*/};
	__property TOvcGetEditorCaption OnGetEditorCaption = {read=FOnGetEditorCaption, write=FOnGetEditorCaption};
	__property System::Classes::TComponent* Owner = {read=FOwner};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property bool Stored = {read=FStored, write=FStored, default=1};
	__property System::Classes::TNotifyEvent OnChanged = {read=FOnChanged, write=FOnChanged};
	__property TOvcItemSelectedEvent OnItemSelected = {read=FOnItemSelected, write=FOnItemSelected};
};


class PASCALIMPLEMENTATION TO32Collection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TO32CollectionItem* operator[](int Index) { return Item[Index]; }
	
protected:
	Vcl::Forms::TForm* FItemEditor;
	bool FReadOnly;
	System::Classes::TPersistent* FOwner;
	System::Classes::TNotifyEvent FOnChanged;
	TOvcItemSelectedEvent FOnItemSelected;
	TO32GetEditorCaption FOnGetEditorCaption;
	bool InLoaded;
	bool IsLoaded;
	bool InChanged;
	HIDESBASE int __fastcall GetCount(void);
	void __fastcall Loaded(void);
	
public:
	__fastcall virtual TO32Collection(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass);
	__fastcall virtual ~TO32Collection(void);
	__property Vcl::Forms::TForm* ItemEditor = {read=FItemEditor, write=FItemEditor};
	HIDESBASEDYNAMIC TO32CollectionItem* __fastcall Add(void);
	HIDESBASE TO32CollectionItem* __fastcall GetItem(int Index);
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	HIDESBASE void __fastcall SetItem(int Index, TO32CollectionItem* Value);
	void __fastcall DoOnItemSelected(int Index);
	System::UnicodeString __fastcall GetEditorCaption(void);
	TO32CollectionItem* __fastcall ItemByName(const System::UnicodeString Name);
	Vcl::Forms::TForm* __fastcall ParentForm(void);
	__property int Count = {read=GetCount, nodefault};
	__property TO32CollectionItem* Item[int Index] = {read=GetItem, write=SetItem/*, default*/};
	__property TO32GetEditorCaption OnGetEditorCaption = {read=FOnGetEditorCaption, write=FOnGetEditorCaption};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property System::Classes::TNotifyEvent OnChanged = {read=FOnChanged, write=FOnChanged};
	__property TOvcItemSelectedEvent OnItemSelected = {read=FOnItemSelected, write=FOnItemSelected};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcCollectionStreamer : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TList* FCollectionList;
	System::Classes::TComponent* FOwner;
	void __fastcall Loaded(void);
	void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	
public:
	__fastcall TOvcCollectionStreamer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCollectionStreamer(void);
	void __fastcall Clear(void);
	TOvcCollection* __fastcall CollectionFromType(System::Classes::TComponent* Component);
	__property System::Classes::TComponent* Owner = {read=FOwner};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcCustomControlEx : public TOvcCustomControl
{
	typedef TOvcCustomControl inherited;
	
protected:
	TOvcController* FController;
	bool __fastcall ControllerAssigned(void);
	TOvcController* __fastcall GetController(void);
	virtual void __fastcall SetController(TOvcController* Value);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__property TOvcController* Controller = {read=GetController, write=SetController};
public:
	/* TOvcCustomControl.Create */ inline __fastcall virtual TOvcCustomControlEx(System::Classes::TComponent* AOwner) : TOvcCustomControl(AOwner) { }
	/* TOvcCustomControl.Destroy */ inline __fastcall virtual ~TOvcCustomControlEx(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomControlEx(HWND ParentWindow) : TOvcCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcPopupWindow : public Vcl::Forms::TCustomForm
{
	typedef Vcl::Forms::TCustomForm inherited;
	
private:
	HWND FPrevActiveWindow;
	System::Uitypes::TCloseAction FCloseAction;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FCancelled;
	void __fastcall SetCloseAction(const System::Uitypes::TCloseAction Value);
	HIDESBASE void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	
protected:
	DYNAMIC void __fastcall Deactivate(void);
	DYNAMIC void __fastcall InitializeNewForm(void);
	DYNAMIC void __fastcall DoClose(System::Uitypes::TCloseAction &Action);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	
public:
	HIDESBASE MESSAGE void __fastcall WMActivate(Winapi::Messages::TWMActivate &Message);
	MESSAGE void __fastcall WMActivateApp(Winapi::Messages::TWMActivateApp &Message);
	void __fastcall Popup(const System::Types::TPoint &P);
	DYNAMIC bool __fastcall IsShortCut(Winapi::Messages::TWMKey &Message);
	__fastcall virtual TOvcPopupWindow(System::Classes::TComponent* AOwner);
	__property System::Uitypes::TCloseAction CloseAction = {read=FCloseAction, write=SetCloseAction, nodefault};
	
__published:
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property OnClose;
	__property bool Cancelled = {read=FCancelled, nodefault};
	__property Visible = {default=0};
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcPopupWindow(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TCustomForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcPopupWindow(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcPopupWindow(HWND ParentWindow) : Vcl::Forms::TCustomForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcController* __fastcall FindController(Vcl::Controls::TWinControl* Form);
extern DELPHI_PACKAGE Vcl::Controls::TWinControl* __fastcall GetImmediateParentForm(Vcl::Controls::TControl* Control);
extern DELPHI_PACKAGE void __fastcall ResolveController(Vcl::Controls::TWinControl* AForm, TOvcController* &AController);
extern DELPHI_PACKAGE TOvcController* __fastcall DefaultController(void);
}	/* namespace Ovcbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBASE)
using namespace Ovcbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbaseHPP

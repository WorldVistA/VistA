// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32lkout.pas' rev: 29.00 (Windows)

#ifndef O32lkoutHPP
#define O32lkoutHPP

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
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Winapi.MMSystem.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovcver.hpp>
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcmisc.hpp>
#include <ovcspeed.hpp>
#include <ovcfiler.hpp>
#include <ovcstate.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32lkout
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32FolderContainer;
class DELPHICLASS TO32LookOutBtnItem;
class DELPHICLASS TO32LookOutFolder;
class DELPHICLASS TO32RenameEdit;
class DELPHICLASS TO32CustomLookoutBar;
class DELPHICLASS TO32LookoutBar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32IconSize : unsigned char { isLarge, isSmall };

enum DECLSPEC_DENUM TlobOrientation : unsigned char { loHorizontal, loVertical };

enum DECLSPEC_DENUM TO32BackgroundMethod : unsigned char { bmNone, bmNormal, bmStretch, bmTile };

enum DECLSPEC_DENUM TO32FolderDrawingStyle : unsigned char { dsDefButton, dsEtchedButton, dsCoolTab, dsStandardTab };

enum DECLSPEC_DENUM TO32FolderType : unsigned char { ftDefault, ftContainer };

class PASCALIMPLEMENTATION TO32FolderContainer : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	TO32CustomLookoutBar* FLookoutBar;
	int FIndex;
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	
public:
	__fastcall virtual TO32FolderContainer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32FolderContainer(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	__property int Index = {read=FIndex, nodefault};
	__property TO32CustomLookoutBar* LookoutBar = {read=FLookoutBar};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32FolderContainer(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32LookOutBtnItem : public Ovcbase::TO32CollectionItem
{
	typedef Ovcbase::TO32CollectionItem inherited;
	
protected:
	TO32LookOutFolder* FFolder;
	System::UnicodeString FCaption;
	System::UnicodeString FDescription;
	int FIconIndex;
	System::Types::TRect FIconRect;
	System::Types::TRect FLabelRect;
	int FTag;
	System::UnicodeString liDisplayName;
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetIconIndex(int Value);
	
public:
	__fastcall virtual TO32LookOutBtnItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TO32LookOutBtnItem(void);
	__property TO32LookOutFolder* Folder = {read=FFolder};
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Types::TRect IconRect = {read=FIconRect};
	__property System::Types::TRect LabelRect = {read=FLabelRect};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property int IconIndex = {read=FIconIndex, write=SetIconIndex, nodefault};
	__property Name = {default=0};
	__property int Tag = {read=FTag, write=FTag, nodefault};
};


class PASCALIMPLEMENTATION TO32LookOutFolder : public Ovcbase::TO32CollectionItem
{
	typedef Ovcbase::TO32CollectionItem inherited;
	
protected:
	TO32CustomLookoutBar* FLookoutBar;
	System::UnicodeString FCaption;
	bool FEnabled;
	TO32IconSize FIconSize;
	TO32FolderType FFolderType;
	int FContainerIndex;
	Ovcbase::TO32Collection* FItems;
	System::UnicodeString lfDisplayName;
	System::Types::TRect lfRect;
	int FTag;
	TO32LookOutBtnItem* __fastcall GetItem(int Index);
	int __fastcall GetItemCount(void);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetFolderType(TO32FolderType Value);
	int __fastcall CreateContainer(void);
	void __fastcall SetIconSize(TO32IconSize Value);
	void __fastcall SetItem(int Index, TO32LookOutBtnItem* Value);
	void __fastcall lfGetEditorCaption(System::UnicodeString &Caption);
	void __fastcall lfItemChange(System::TObject* Sender);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall ReadIndex(System::Classes::TReader* Reader);
	void __fastcall WriteIndex(System::Classes::TWriter* Writer);
	
public:
	__fastcall virtual TO32LookOutFolder(System::Classes::TCollection* Collection);
	__fastcall virtual ~TO32LookOutFolder(void);
	TO32FolderContainer* __fastcall GetContainer(void);
	__property TO32LookOutBtnItem* Items[int Index] = {read=GetItem};
	__property int ItemCount = {read=GetItemCount, nodefault};
	__property int ContainerIndex = {read=FContainerIndex, write=FContainerIndex, nodefault};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, nodefault};
	__property TO32FolderType FolderType = {read=FFolderType, write=SetFolderType, nodefault};
	__property Ovcbase::TO32Collection* ItemCollection = {read=FItems, write=FItems};
	__property TO32IconSize IconSize = {read=FIconSize, write=SetIconSize, nodefault};
	__property Name = {default=0};
	__property int Tag = {read=FTag, write=FTag, nodefault};
};


class PASCALIMPLEMENTATION TO32RenameEdit : public Vcl::Stdctrls::TCustomMemo
{
	typedef Vcl::Stdctrls::TCustomMemo inherited;
	
protected:
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	
public:
	int FolderIndex;
	int ItemIndex;
	__fastcall virtual TO32RenameEdit(System::Classes::TComponent* AOwner);
public:
	/* TCustomMemo.Destroy */ inline __fastcall virtual ~TO32RenameEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32RenameEdit(HWND ParentWindow) : Vcl::Stdctrls::TCustomMemo(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TO32FolderClickEvent)(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);

typedef void __fastcall (__closure *TO32ItemClickEvent)(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);

typedef void __fastcall (__closure *TO32FolderChangeEvent)(System::TObject* Sender, int Index, bool &AllowChange, bool Dragging);

typedef void __fastcall (__closure *TO32FolderChangedEvent)(System::TObject* Sender, int Index);

typedef void __fastcall (__closure *TO32LOBDragOverEvent)(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &AcceptFolder, bool &AcceptItem);

typedef void __fastcall (__closure *TO32LOBDragDropEvent)(System::TObject* Sender, System::TObject* Source, int X, int Y, int FolderIndex, int ItemIndex);

typedef void __fastcall (__closure *TO32MouseOverItemEvent)(System::TObject* Sender, TO32LookOutBtnItem* Item);

class PASCALIMPLEMENTATION TO32CustomLookoutBar : public Ovcbase::TO32CustomControl
{
	typedef Ovcbase::TO32CustomControl inherited;
	
protected:
	int FActiveFolder;
	int FActiveItem;
	TlobOrientation FOrientation;
	bool FAllowRearrange;
	System::Uitypes::TColor FBackgroundColor;
	Vcl::Graphics::TBitmap* FBackgroundImage;
	TO32BackgroundMethod FBackgroundMethod;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	int FButtonHeight;
	Ovcbase::TO32ContainerList* FContainers;
	TO32FolderDrawingStyle FDrawingStyle;
	Ovcbase::TO32Collection* FFolders;
	int FHotFolder;
	Vcl::Controls::TImageList* FImages;
	Vcl::Graphics::TFont* FItemFont;
	System::Word FItemSpacing;
	int FPreviousFolder;
	int FPreviousItem;
	bool FPlaySounds;
	int FSelectedItem;
	Vcl::Graphics::TFont* FSelectedItemFont;
	int FScrollDelta;
	bool FShowButtons;
	System::UnicodeString FSoundAlias;
	Ovcfiler::TOvcAbstractStore* FStorage;
	int FLoadingFolder;
	System::Classes::TNotifyEvent FOnArrange;
	TO32LOBDragDropEvent FOnDragDrop;
	TO32LOBDragOverEvent FOnDragOver;
	TO32FolderChangeEvent FOnFolderChange;
	TO32FolderChangedEvent FOnFolderChanged;
	TO32FolderClickEvent FOnFolderClick;
	TO32ItemClickEvent FOnItemClick;
	TO32MouseOverItemEvent FOnMouseOverItem;
	bool lobChanging;
	TO32RenameEdit* lobEdit;
	int lobTopItem;
	bool lobExternalDrag;
	int lobDragFromItem;
	int lobDragFromFolder;
	int lobDragToItem;
	int lobDragToFolder;
	int lobDropY;
	System::Types::TPoint lobHitTest;
	System::Types::TRect lobItemsRect;
	bool lobMouseDown;
	bool lobOverButton;
	Ovcspeed::TOvcSpeedButton* lobScrollDownBtn;
	Ovcspeed::TOvcSpeedButton* lobScrollUpBtn;
	int lobTimer;
	int lobExternalDragItem;
	bool lobFolderAccept;
	bool lobItemAccept;
	bool lobCursorOverItem;
	bool lobAcceptAny;
	int lobLastMouseOverItem;
	TO32LookOutFolder* __fastcall GetFolder(int Index);
	int __fastcall GetFolderCount(void);
	TO32FolderContainer* __fastcall GetContainer(int Index);
	void __fastcall SetActiveFolder(int Value);
	void __fastcall SetBackgroundColor(System::Uitypes::TColor Value);
	void __fastcall SetBackgroundImage(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetBackgroundMethod(TO32BackgroundMethod Value);
	void __fastcall SetDrawingStyle(TO32FolderDrawingStyle Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetButtonHeight(int Value);
	void __fastcall SetImages(Vcl::Controls::TImageList* Value);
	void __fastcall SetItemFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetItemSpacing(System::Word Value);
	void __fastcall SetOrientation(TlobOrientation Value);
	void __fastcall SetSelectedItem(int Value);
	void __fastcall SetSelectedItemFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetScrollDelta(int Value);
	void __fastcall SetStorage(Ovcfiler::TOvcAbstractStore* Value);
	System::Types::TRect __fastcall lobButtonRect(int Index);
	void __fastcall lobCommitEdit(System::TObject* Sender);
	DYNAMIC void __fastcall DragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	bool __fastcall lobDropHitTest(int X, int Y);
	void __fastcall lobFolderChange(System::TObject* Sender);
	void __fastcall lobFolderSelected(System::TObject* Sender, int Index);
	void __fastcall lobFontChanged(System::TObject* Sender);
	void __fastcall lobGetEditorCaption(System::UnicodeString &Caption);
	System::Types::TRect __fastcall lobGetFolderArea(int Index);
	void __fastcall lobGetHitTest(int X, int Y, int &FolderIndex, int &ItemIndex);
	void __fastcall lobImagesChanged(System::TObject* Sender);
	void __fastcall lobRecalcDisplayNames(void);
	void __fastcall lobScrollDownBtnClick(System::TObject* Sender);
	void __fastcall lobScrollUpBtnClick(System::TObject* Sender);
	bool __fastcall lobShowScrollUp(void);
	bool __fastcall lobShowScrollDown(void);
	void __fastcall lobTimerEvent(System::TObject* Sender, int Handle, unsigned Interval, int ElapsedTime);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMParentColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Loaded(void);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	int __fastcall AddContainer(TO32FolderContainer* Container);
	void __fastcall RemoveContainer(TO32FolderContainer* Container);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	void __fastcall DoArrange(void);
	void __fastcall DoFolderChange(int Index, bool &AllowChange);
	void __fastcall DoFolderChanged(int Index);
	void __fastcall DoFolderClick(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);
	void __fastcall DoItemClick(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);
	void __fastcall DoMouseOverItem(int X, int Y, int ItemIndex);
	__property int ActiveFolder = {read=FActiveFolder, write=SetActiveFolder, nodefault};
	__property bool AllowRearrange = {read=FAllowRearrange, write=FAllowRearrange, nodefault};
	__property System::Uitypes::TColor BackgroundColor = {read=FBackgroundColor, write=SetBackgroundColor, nodefault};
	__property Vcl::Graphics::TBitmap* BackgroundImage = {read=FBackgroundImage, write=SetBackgroundImage};
	__property TO32BackgroundMethod BackgroundMethod = {read=FBackgroundMethod, write=SetBackgroundMethod, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property int ButtonHeight = {read=FButtonHeight, write=SetButtonHeight, nodefault};
	__property TO32FolderDrawingStyle DrawingStyle = {read=FDrawingStyle, write=SetDrawingStyle, nodefault};
	__property Ovcbase::TO32Collection* FolderCollection = {read=FFolders, write=FFolders};
	__property Vcl::Controls::TImageList* Images = {read=FImages, write=SetImages};
	__property Vcl::Graphics::TFont* ItemFont = {read=FItemFont, write=SetItemFont};
	__property System::Word ItemSpacing = {read=FItemSpacing, write=SetItemSpacing, nodefault};
	__property TlobOrientation Orientation = {read=FOrientation, write=SetOrientation, nodefault};
	__property bool PlaySounds = {read=FPlaySounds, write=FPlaySounds, nodefault};
	__property int ScrollDelta = {read=FScrollDelta, write=SetScrollDelta, default=2};
	__property int SelectedItem = {read=FSelectedItem, write=SetSelectedItem, nodefault};
	__property Vcl::Graphics::TFont* SelectedItemFont = {read=FSelectedItemFont, write=SetSelectedItemFont};
	__property bool ShowButtons = {read=FShowButtons, write=FShowButtons, nodefault};
	__property System::UnicodeString SoundAlias = {read=FSoundAlias, write=FSoundAlias};
	__property Ovcfiler::TOvcAbstractStore* Storage = {read=FStorage, write=SetStorage};
	__property AfterEnter;
	__property AfterExit;
	__property OnMouseWheel;
	__property System::Classes::TNotifyEvent OnArrange = {read=FOnArrange, write=FOnArrange};
	__property TO32LOBDragDropEvent OnDragDrop = {read=FOnDragDrop, write=FOnDragDrop};
	__property TO32LOBDragOverEvent OnDragOver = {read=FOnDragOver, write=FOnDragOver};
	__property TO32FolderClickEvent OnFolderClick = {read=FOnFolderClick, write=FOnFolderClick};
	__property TO32ItemClickEvent OnItemClick = {read=FOnItemClick, write=FOnItemClick};
	__property TO32FolderChangeEvent OnFolderChange = {read=FOnFolderChange, write=FOnFolderChange};
	__property TO32FolderChangedEvent OnFolderChanged = {read=FOnFolderChanged, write=FOnFolderChanged};
	__property TO32MouseOverItemEvent OnMouseOverItem = {read=FOnMouseOverItem, write=FOnMouseOverItem};
	
public:
	__fastcall virtual TO32CustomLookoutBar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomLookoutBar(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	DYNAMIC void __fastcall DragDrop(System::TObject* Source, int X, int Y);
	void __fastcall BeginUpdate(void);
	void __fastcall ClampSelectedItemInView(void);
	void __fastcall ItemChanged(int FolderIndex, int ItemIndex);
	void __fastcall FolderChanged(int FolderIndex);
	void __fastcall EndUpdate(void);
	int __fastcall GetFolderAt(int X, int Y);
	int __fastcall GetItemAt(int X, int Y);
	TO32FolderContainer* __fastcall Container(void);
	void __fastcall InsertFolder(const System::UnicodeString ACaption, int AFolderIndex);
	void __fastcall AddFolder(const System::UnicodeString ACaption);
	void __fastcall RenameFolder(int AFolderIndex);
	void __fastcall InsertItem(const System::UnicodeString ACaption, int AFolderIndex, int AItemIndex, int AIconIndex);
	void __fastcall AddItem(const System::UnicodeString ACaption, int AFolderIndex, int AIconIndex);
	void __fastcall InvalidateItem(int FolderIndex, int ItemIndex);
	void __fastcall RenameItem(int AFolderIndex, int AItemIndex);
	void __fastcall RestoreState(const System::UnicodeString Section = System::UnicodeString());
	void __fastcall SaveState(const System::UnicodeString Section = System::UnicodeString());
	__property int ActiveItem = {read=FActiveItem, nodefault};
	__property TO32FolderContainer* Containers[int Index] = {read=GetContainer};
	__property TO32LookOutFolder* Folders[int Index] = {read=GetFolder};
	__property int FolderCount = {read=GetFolderCount, nodefault};
	__property int PreviousFolder = {read=FPreviousFolder, nodefault};
	__property int PreviousItem = {read=FPreviousItem, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomLookoutBar(HWND ParentWindow) : Ovcbase::TO32CustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32LookoutBar : public TO32CustomLookoutBar
{
	typedef TO32CustomLookoutBar inherited;
	
__published:
	__property ActiveFolder;
	__property AllowRearrange;
	__property BackgroundColor;
	__property BackgroundImage;
	__property BackgroundMethod;
	__property BorderStyle;
	__property ButtonHeight;
	__property DrawingStyle = {default=0};
	__property FolderCollection;
	__property Images;
	__property ItemFont;
	__property ItemSpacing;
	__property Orientation = {default=1};
	__property PlaySounds = {default=0};
	__property ScrollDelta = {default=2};
	__property SelectedItem = {default=-1};
	__property SelectedItemFont;
	__property ShowButtons = {default=1};
	__property SoundAlias = {default=0};
	__property Storage;
	__property AfterEnter;
	__property AfterExit;
	__property OnMouseWheel;
	__property OnArrange;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnFolderClick;
	__property OnItemClick;
	__property OnFolderChange;
	__property OnFolderChanged;
	__property OnMouseOverItem;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Align = {default=0};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property Enabled = {default=1};
	__property Font;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Visible = {default=1};
public:
	/* TO32CustomLookoutBar.Create */ inline __fastcall virtual TO32LookoutBar(System::Classes::TComponent* AOwner) : TO32CustomLookoutBar(AOwner) { }
	/* TO32CustomLookoutBar.Destroy */ inline __fastcall virtual ~TO32LookoutBar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32LookoutBar(HWND ParentWindow) : TO32CustomLookoutBar(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32lkout */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32LKOUT)
using namespace O32lkout;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32lkoutHPP

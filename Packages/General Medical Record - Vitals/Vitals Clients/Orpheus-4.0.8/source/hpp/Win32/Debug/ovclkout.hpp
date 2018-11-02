// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovclkout.pas' rev: 29.00 (Windows)

#ifndef OvclkoutHPP
#define OvclkoutHPP

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
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcmisc.hpp>
#include <ovcspeed.hpp>
#include <ovcfiler.hpp>
#include <ovcstate.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovclkout
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcLookOutItem;
class DELPHICLASS TOvcLookOutFolder;
class DELPHICLASS TOvcRenameEdit;
class DELPHICLASS TOvcLookOutBar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcIconSize : unsigned char { isLarge, isSmall };

enum DECLSPEC_DENUM TOvcBackgroundMethod : unsigned char { bmNone, bmNormal, bmStretch, bmTile };

enum DECLSPEC_DENUM TOvcFolderDrawingStyle : unsigned char { dsDefault, dsEtched };

class PASCALIMPLEMENTATION TOvcLookOutItem : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	System::UnicodeString FCaption;
	System::UnicodeString FDescription;
	int FIconIndex;
	System::Types::TRect FIconRect;
	System::Types::TRect FLabelRect;
	System::UnicodeString liDisplayName;
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetIconIndex(int Value);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	
public:
	__fastcall virtual TOvcLookOutItem(System::Classes::TComponent* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Types::TRect IconRect = {read=FIconRect};
	__property System::Types::TRect LabelRect = {read=FLabelRect};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property int IconIndex = {read=FIconIndex, write=SetIconIndex, nodefault};
public:
	/* TOvcCollectible.Destroy */ inline __fastcall virtual ~TOvcLookOutItem(void) { }
	
};


class PASCALIMPLEMENTATION TOvcLookOutFolder : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	System::UnicodeString FCaption;
	bool FEnabled;
	TOvcIconSize FIconSize;
	Ovcbase::TOvcCollection* FItems;
	System::UnicodeString lfDisplayName;
	System::Types::TRect lfRect;
	TOvcLookOutItem* __fastcall GetItem(int Index);
	int __fastcall GetItemCount(void);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetIconSize(TOvcIconSize Value);
	void __fastcall SetItem(int Index, TOvcLookOutItem* Value);
	void __fastcall lfGetEditorCaption(System::UnicodeString &Caption);
	void __fastcall lfItemChange(System::TObject* Sender);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	
public:
	__fastcall virtual TOvcLookOutFolder(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcLookOutFolder(void);
	__property TOvcLookOutItem* Items[int Index] = {read=GetItem};
	__property int ItemCount = {read=GetItemCount, nodefault};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, nodefault};
	__property Ovcbase::TOvcCollection* ItemCollection = {read=FItems, write=FItems};
	__property TOvcIconSize IconSize = {read=FIconSize, write=SetIconSize, nodefault};
};


class PASCALIMPLEMENTATION TOvcRenameEdit : public Vcl::Stdctrls::TCustomMemo
{
	typedef Vcl::Stdctrls::TCustomMemo inherited;
	
protected:
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	
public:
	int FolderIndex;
	int ItemIndex;
	__fastcall virtual TOvcRenameEdit(System::Classes::TComponent* AOwner);
public:
	/* TCustomMemo.Destroy */ inline __fastcall virtual ~TOvcRenameEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcRenameEdit(HWND ParentWindow) : Vcl::Stdctrls::TCustomMemo(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TOvcFolderClickEvent)(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);

typedef void __fastcall (__closure *TOvcItemClickEvent)(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int Index);

typedef void __fastcall (__closure *TOvcFolderChangeEvent)(System::TObject* Sender, int Index, bool &AllowChange, bool Dragging);

typedef void __fastcall (__closure *TOvcFolderChangedEvent)(System::TObject* Sender, int Index);

typedef void __fastcall (__closure *TOvcLOBDragOverEvent)(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &AcceptFolder, bool &AcceptItem);

typedef void __fastcall (__closure *TOvcLOBDragDropEvent)(System::TObject* Sender, System::TObject* Source, int X, int Y, int FolderIndex, int ItemIndex);

typedef void __fastcall (__closure *TOvcMouseOverItemEvent)(System::TObject* Sender, TOvcLookOutItem* Item);

class PASCALIMPLEMENTATION TOvcLookOutBar : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	int FActiveFolder;
	int FActiveItem;
	bool FAllowRearrange;
	System::Uitypes::TColor FBackgroundColor;
	Vcl::Graphics::TBitmap* FBackgroundImage;
	TOvcBackgroundMethod FBackgroundMethod;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	int FButtonHeight;
	TOvcFolderDrawingStyle FDrawingStyle;
	Ovcbase::TOvcCollection* FFolders;
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
	System::Classes::TNotifyEvent FOnArrange;
	TOvcLOBDragDropEvent FOnDragDrop;
	TOvcLOBDragOverEvent FOnDragOver;
	TOvcFolderChangeEvent FOnFolderChange;
	TOvcFolderChangedEvent FOnFolderChanged;
	TOvcFolderClickEvent FOnFolderClick;
	TOvcItemClickEvent FOnItemClick;
	TOvcMouseOverItemEvent FOnMouseOverItem;
	bool lobChanging;
	TOvcRenameEdit* lobEdit;
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
	TOvcLookOutFolder* __fastcall GetFolder(int Index);
	int __fastcall GetFolderCount(void);
	void __fastcall SetActiveFolder(int Value);
	void __fastcall SetBackgroundColor(System::Uitypes::TColor Value);
	void __fastcall SetBackgroundImage(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetBackgroundMethod(TOvcBackgroundMethod Value);
	void __fastcall SetDrawingStyle(TOvcFolderDrawingStyle Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetButtonHeight(int Value);
	void __fastcall SetImages(Vcl::Controls::TImageList* Value);
	void __fastcall SetItemFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetItemSpacing(System::Word Value);
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
	
public:
	__fastcall virtual TOvcLookOutBar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcLookOutBar(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	DYNAMIC void __fastcall DragDrop(System::TObject* Source, int X, int Y);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	int __fastcall GetFolderAt(int X, int Y);
	int __fastcall GetItemAt(int X, int Y);
	void __fastcall InsertFolder(const System::UnicodeString ACaption, int AFolderIndex);
	void __fastcall InsertItem(const System::UnicodeString ACaption, int AFolderIndex, int AItemIndex, int AIconIndex);
	void __fastcall InvalidateItem(int FolderIndex, int ItemIndex);
	void __fastcall RemoveFolder(int AFolderIndex);
	void __fastcall RemoveItem(int AFolderIndex, int AItemIndex);
	void __fastcall RenameFolder(int AFolderIndex);
	void __fastcall RenameItem(int AFolderIndex, int AItemIndex);
	void __fastcall RestoreState(const System::UnicodeString Section = System::UnicodeString());
	void __fastcall SaveState(const System::UnicodeString Section = System::UnicodeString());
	__property int ActiveItem = {read=FActiveItem, nodefault};
	__property TOvcLookOutFolder* Folders[int Index] = {read=GetFolder};
	__property int FolderCount = {read=GetFolderCount, nodefault};
	__property int PreviousFolder = {read=FPreviousFolder, nodefault};
	__property int PreviousItem = {read=FPreviousItem, nodefault};
	
__published:
	__property int ActiveFolder = {read=FActiveFolder, write=SetActiveFolder, default=-1};
	__property bool AllowRearrange = {read=FAllowRearrange, write=FAllowRearrange, default=1};
	__property System::Uitypes::TColor BackgroundColor = {read=FBackgroundColor, write=SetBackgroundColor, default=-16777213};
	__property Vcl::Graphics::TBitmap* BackgroundImage = {read=FBackgroundImage, write=SetBackgroundImage};
	__property TOvcBackgroundMethod BackgroundMethod = {read=FBackgroundMethod, write=SetBackgroundMethod, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property int ButtonHeight = {read=FButtonHeight, write=SetButtonHeight, default=20};
	__property TOvcFolderDrawingStyle DrawingStyle = {read=FDrawingStyle, write=SetDrawingStyle, default=0};
	__property Ovcbase::TOvcCollection* FolderCollection = {read=FFolders, write=FFolders};
	__property Vcl::Controls::TImageList* Images = {read=FImages, write=SetImages};
	__property Vcl::Graphics::TFont* ItemFont = {read=FItemFont, write=SetItemFont};
	__property System::Word ItemSpacing = {read=FItemSpacing, write=SetItemSpacing, nodefault};
	__property bool PlaySounds = {read=FPlaySounds, write=FPlaySounds, default=0};
	__property int ScrollDelta = {read=FScrollDelta, write=SetScrollDelta, default=2};
	__property int SelectedItem = {read=FSelectedItem, write=FSelectedItem, default=-1};
	__property Vcl::Graphics::TFont* SelectedItemFont = {read=FSelectedItemFont, write=SetSelectedItemFont};
	__property bool ShowButtons = {read=FShowButtons, write=FShowButtons, default=1};
	__property System::UnicodeString SoundAlias = {read=FSoundAlias, write=FSoundAlias, stored=FPlaySounds};
	__property Ovcfiler::TOvcAbstractStore* Storage = {read=FStorage, write=SetStorage};
	__property AfterEnter;
	__property AfterExit;
	__property OnMouseWheel;
	__property System::Classes::TNotifyEvent OnArrange = {read=FOnArrange, write=FOnArrange};
	__property TOvcLOBDragDropEvent OnDragDrop = {read=FOnDragDrop, write=FOnDragDrop};
	__property TOvcLOBDragOverEvent OnDragOver = {read=FOnDragOver, write=FOnDragOver};
	__property TOvcFolderClickEvent OnFolderClick = {read=FOnFolderClick, write=FOnFolderClick};
	__property TOvcItemClickEvent OnItemClick = {read=FOnItemClick, write=FOnItemClick};
	__property TOvcFolderChangeEvent OnFolderChange = {read=FOnFolderChange, write=FOnFolderChange};
	__property TOvcFolderChangedEvent OnFolderChanged = {read=FOnFolderChanged, write=FOnFolderChanged};
	__property TOvcMouseOverItemEvent OnMouseOverItem = {read=FOnMouseOverItem, write=FOnMouseOverItem};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Align = {default=0};
	__property Controller;
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
	/* TWinControl.CreateParented */ inline __fastcall TOvcLookOutBar(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovclkout */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCLKOUT)
using namespace Ovclkout;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvclkoutHPP

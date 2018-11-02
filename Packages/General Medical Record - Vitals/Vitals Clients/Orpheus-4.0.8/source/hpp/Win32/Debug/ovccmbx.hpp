// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccmbx.pas' rev: 29.00 (Windows)

#ifndef OvccmbxHPP
#define OvccmbxHPP

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
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovcbordr.hpp>
#include <ovctimer.hpp>
#include <Vcl.Themes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccmbx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcMRUList;
class DELPHICLASS TOvcHTColors;
class DELPHICLASS TOvcBaseComboBox;
class DELPHICLASS TOvcComboBox;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcMRUList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FMaxItems;
	System::Classes::TStrings* FList;
	void __fastcall SetMaxItems(int Value);
	
public:
	void __fastcall Clear(void);
	__fastcall TOvcMRUList(void);
	__fastcall virtual ~TOvcMRUList(void);
	void __fastcall NewItem(const System::UnicodeString Item, System::TObject* Obj);
	void __fastcall Shrink(void);
	bool __fastcall RemoveItem(const System::UnicodeString Item);
	__property System::Classes::TStrings* Items = {read=FList};
	__property int MaxItems = {read=FMaxItems, write=SetMaxItems, nodefault};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TOvcComboStyle : unsigned char { ocsDropDown, ocsDropDownList };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcHTColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Uitypes::TColor FHighlight;
	System::Uitypes::TColor FShadow;
	
public:
	__fastcall virtual TOvcHTColors(void);
	
__published:
	__property System::Uitypes::TColor Highlight = {read=FHighlight, write=FHighlight, default=-16777196};
	__property System::Uitypes::TColor Shadow = {read=FShadow, write=FShadow, default=-16777200};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcHTColors(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcBaseComboBox : public Vcl::Stdctrls::TCustomComboBox
{
	typedef Vcl::Stdctrls::TCustomComboBox inherited;
	
private:
	unsigned FCurrentState;
	unsigned FNewState;
	bool FBufferedPaintInitialized;
	
protected:
	bool FAutoSearch;
	Ovcbordr::TOvcBorders* FBorders;
	bool FDrawingEdit;
	int FDroppedWidth;
	bool FHotTrack;
	bool FHTBorder;
	TOvcHTColors* FHTColors;
	int FKeyDelay;
	int FItemHeight;
	Ovcbase::TOvcLabelInfo* FLabelInfo;
	System::Uitypes::TColor FMRUListColor;
	int FMRUListCount;
	TOvcComboStyle FStyle;
	System::Classes::TNotifyEvent FAfterEnter;
	System::Classes::TNotifyEvent FAfterExit;
	Ovcbase::TMouseWheelEvent FOnMouseWheel;
	System::Classes::TNotifyEvent FOnSelChange;
	bool FEventActive;
	bool FIsFocused;
	bool FIsHot;
	bool FLastKeyWasBackSpace;
	TOvcMRUList* FMRUList;
	System::Classes::TStringList* FList;
	int FListIndex;
	int FSaveItemIndex;
	bool FStandardHomeEnd;
	int FTimer;
	int FCurItemIndex;
	void __fastcall HotTimerEvent(System::TObject* Sender, int Handle, unsigned Interval, int ElapsedTime);
	void __fastcall TimerEvent(System::TObject* Sender, int Handle, unsigned Interval, int ElapsedTime);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetDroppedWidth(int Value);
	void __fastcall SetHotTrack(bool Value);
	HIDESBASE void __fastcall SetItemHeight(int Value);
	int __fastcall GetListIndex(void);
	void __fastcall SetListIndex(int Value);
	System::Classes::TStrings* __fastcall GetList(void);
	System::Classes::TStrings* __fastcall GetMRUList(void);
	void __fastcall SetKeyDelay(int Value);
	void __fastcall SetMRUListCount(int Value);
	void __fastcall SetOcbStyle(TOvcComboStyle Value);
	void __fastcall SetStandardHomeEnd(bool Value);
	void __fastcall AddItemToMRUList(int Index);
	void __fastcall CheckHot(HWND HotWnd);
	Ovcbase::TOvcAttachedLabel* __fastcall GetAttachedLabel(void);
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall LabelAttach(System::TObject* Sender, bool Value);
	void __fastcall LabelChange(System::TObject* Sender);
	void __fastcall PositionLabel(void);
	void __fastcall RecalcHeight(void);
	void __fastcall SetHot(void);
	void __fastcall UpdateMRUList(void);
	void __fastcall UpdateMRUListModified(void);
	void __fastcall MRUListUpdate(int Count);
	MESSAGE void __fastcall OMAssignLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMPositionLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMRecordLabelPosition(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterEnter(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMAfterExit(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CNCommand(Winapi::Messages::TWMCommand &Message);
	HIDESBASE MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMMeasureItem(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseWheel(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	Ovcbase::TOvcLabelPosition DefaultLabelPosition;
	virtual void __fastcall ComboWndProc(Winapi::Messages::TMessage &Message, HWND ComboWnd, void * ComboProc);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	DYNAMIC void __fastcall DoExit(void);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &ItemRect, Winapi::Windows::TOwnerDrawState State);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall MeasureItem(int Index, int &IHeight);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual void __fastcall SelectionChanged(void);
	DYNAMIC void __fastcall Select(void);
	virtual void __fastcall SetItemIndex(const int Value)/* overload */;
	void __fastcall BorderChanged(System::TObject* ABorder);
	void __fastcall Paint(void);
	void __fastcall PaintBorders(void);
	virtual void __fastcall PaintWindow(HDC DC);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Msg);
	void __fastcall SetHTBorder(bool Value);
	void __fastcall SetHTColors(TOvcHTColors* Value);
	bool __fastcall UseRuntimeThemes(void);
	void __fastcall PaintState(HDC DC, unsigned State);
	void __fastcall StartAnimation(unsigned NewState);
	DYNAMIC void __fastcall CloseUp(void);
	MESSAGE void __fastcall CNCtlcoloredit(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledchanged(Winapi::Messages::TMessage &Message);
	virtual void __fastcall DrawItemThemed(HDC DC, const Vcl::Themes::TThemedElementDetails &Details, int Index, const System::Types::TRect &Rect);
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property bool AutoSearch = {read=FAutoSearch, write=FAutoSearch, default=1};
	__property int ItemHeight = {read=FItemHeight, write=SetItemHeight, nodefault};
	__property int KeyDelay = {read=FKeyDelay, write=SetKeyDelay, default=500};
	__property Ovcbase::TOvcLabelInfo* LabelInfo = {read=FLabelInfo, write=FLabelInfo};
	__property System::Uitypes::TColor MRUListColor = {read=FMRUListColor, write=FMRUListColor, default=-16777211};
	__property int MRUListCount = {read=FMRUListCount, write=SetMRUListCount, default=3};
	__property TOvcComboStyle Style = {read=FStyle, write=SetOcbStyle, nodefault};
	__property System::Classes::TNotifyEvent AfterEnter = {read=FAfterEnter, write=FAfterEnter};
	__property System::Classes::TNotifyEvent AfterExit = {read=FAfterExit, write=FAfterExit};
	__property Ovcbase::TMouseWheelEvent OnMouseWheel = {read=FOnMouseWheel, write=FOnMouseWheel};
	__property System::Classes::TNotifyEvent OnSelectionChange = {read=FOnSelChange, write=FOnSelChange};
	
public:
	__fastcall virtual TOvcBaseComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseComboBox(void);
	__property bool DrawingEdit = {read=FDrawingEdit, nodefault};
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	HIDESBASE int __fastcall AddItem(const System::UnicodeString Item, System::TObject* AObject);
	void __fastcall AssignItems(System::Classes::TPersistent* Source);
	void __fastcall ClearItems(void);
	void __fastcall InsertItem(int Index, const System::UnicodeString Item, System::TObject* AObject);
	void __fastcall RemoveItem(const System::UnicodeString Item);
	void __fastcall ClearMRUList(void);
	void __fastcall ForceItemsToMRUList(int Value);
	__property Ovcbase::TOvcAttachedLabel* AttachedLabel = {read=GetAttachedLabel};
	__property int DroppedWidth = {read=FDroppedWidth, write=SetDroppedWidth, default=-1};
	__property bool HotTrack = {read=FHotTrack, write=SetHotTrack, default=0};
	__property System::Classes::TStrings* List = {read=GetList};
	__property int ListIndex = {read=GetListIndex, write=SetListIndex, nodefault};
	__property System::Classes::TStrings* MRUList = {read=GetMRUList};
	__property bool StandardHomeEnd = {read=FStandardHomeEnd, write=SetStandardHomeEnd, nodefault};
	
__published:
	__property Ovcbordr::TOvcBorders* Borders = {read=FBorders, write=FBorders};
	__property bool HotTrackBorder = {read=FHTBorder, write=SetHTBorder, default=1};
	__property TOvcHTColors* HotTrackColors = {read=FHTColors, write=SetHTColors};
	__property AutoComplete = {default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBaseComboBox(HWND ParentWindow) : Vcl::Stdctrls::TCustomComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcComboBox : public TOvcBaseComboBox
{
	typedef TOvcBaseComboBox inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AutoSearch = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property DroppedWidth = {default=-1};
	__property Enabled = {default=1};
	__property Font;
	__property HotTrack = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ItemHeight;
	__property Items;
	__property KeyDelay = {default=500};
	__property LabelInfo;
	__property MaxLength = {default=0};
	__property MRUListColor = {default=-16777211};
	__property MRUListCount = {default=3};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Sorted = {default=0};
	__property Style = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Text = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnSelectionChange;
	__property OnStartDrag;
	__property OnMouseWheel;
public:
	/* TOvcBaseComboBox.Create */ inline __fastcall virtual TOvcComboBox(System::Classes::TComponent* AOwner) : TOvcBaseComboBox(AOwner) { }
	/* TOvcBaseComboBox.Destroy */ inline __fastcall virtual ~TOvcComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcComboBox(HWND ParentWindow) : TOvcBaseComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 cbxSeparatorHeight = System::Int8(0x3);
}	/* namespace Ovccmbx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCMBX)
using namespace Ovccmbx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccmbxHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcvlb.pas' rev: 29.00 (Windows)

#ifndef OvcvlbHPP
#define OvcvlbHPP

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
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcmisc.hpp>
#include <ovcexcpt.hpp>
#include <ovccolor.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcvlb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomVirtualListBox;
class DELPHICLASS TOvcVirtualListBox;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TCharToItemEvent)(System::TObject* Sender, System::WideChar Ch, int &Index);

typedef void __fastcall (__closure *TDrawItemEvent)(System::TObject* Sender, int Index, const System::Types::TRect &Rect, const System::UnicodeString S);

typedef void __fastcall (__closure *TGetItemEvent)(System::TObject* Sender, int Index, System::UnicodeString &ItemString);

typedef void __fastcall (__closure *TGetItemColorEvent)(System::TObject* Sender, int Index, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);

typedef void __fastcall (__closure *TGetItemStatusEvent)(System::TObject* Sender, int Index, bool &Protect);

typedef void __fastcall (__closure *THeaderClickEvent)(System::TObject* Sender, const System::Types::TPoint &Point);

typedef void __fastcall (__closure *TIsSelectedEvent)(System::TObject* Sender, int Index, bool &Selected);

typedef void __fastcall (__closure *TSelectEvent)(System::TObject* Sender, int Index, bool Selected);

typedef void __fastcall (__closure *TTopIndexChanged)(System::TObject* Sender, int NewTopIndex);

typedef System::StaticArray<int, 129> TTabStopArray;

typedef System::StaticArray<System::WideChar, 256> TBuffer;

class PASCALIMPLEMENTATION TOvcCustomVirtualListBox : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	int FItemIndex;
	bool FAutoRowHeight;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	int FColumns;
	System::Uitypes::TColor FFillColor;
	System::UnicodeString FHeader;
	Ovccolor::TOvcColors* FHeaderColor;
	bool FIntegralHeight;
	bool FMultiSelect;
	int FNumItems;
	bool FOwnerDraw;
	Ovccolor::TOvcColors* FProtectColor;
	int FRowHeight;
	System::Uitypes::TScrollStyle FScrollBars;
	Ovccolor::TOvcColors* FSelectColor;
	bool FShowHeader;
	bool FSmoothScroll;
	int FTopIndex;
	bool FUseTabStops;
	int FWheelDelta;
	TCharToItemEvent FOnCharToItem;
	THeaderClickEvent FOnClickHeader;
	TDrawItemEvent FOnDrawItem;
	TGetItemEvent FOnGetItem;
	TGetItemColorEvent FOnGetItemColor;
	TGetItemStatusEvent FOnGetItemStatus;
	TIsSelectedEvent FOnIsSelected;
	TSelectEvent FOnSelect;
	TTopIndexChanged FOnTopIndexChanged;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	int lAnchor;
	int lDivisor;
	int lDlgUnits;
	int lFocusedIndex;
	bool lHaveHS;
	bool lHaveVS;
	int lHDelta;
	int lHighIndex;
	System::Byte lNumTabStops;
	int lRows;
	TTabStopArray lTabs;
	int lUpdating;
	int lVSHigh;
	int lVMargin;
	bool MousePassThru;
	void __fastcall SetAutoRowHeight(bool Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetColumns(const int Value);
	void __fastcall SetHeader(const System::UnicodeString Value);
	void __fastcall SetIntegralHeight(bool Value);
	virtual void __fastcall SetMultiSelect(bool Value);
	void __fastcall InternalSetNumItems(int Value, bool Paint, bool UpdateIndices);
	void __fastcall SetNumItems(int Value);
	void __fastcall SetRowHeight(int Value);
	virtual void __fastcall SetScrollBars(const System::Uitypes::TScrollStyle Value);
	void __fastcall SetShowHeader(bool Value);
	void __fastcall vlbAdjustIntegralHeight(void);
	virtual void __fastcall vlbCalcFontFields(void);
	void __fastcall vlbClearAllItems(void);
	void __fastcall vlbClearSelRange(int First, int Last);
	void __fastcall vlbColorChanged(System::TObject* AColor);
	void __fastcall vlbDragSelection(int First, int Last);
	void __fastcall vlbDrawFocusRect(int Index);
	void __fastcall vlbDrawHeader(void);
	void __fastcall vlbExtendSelection(int Index);
	void __fastcall vlbHScrollPrim(int Delta);
	void __fastcall vlbInitScrollInfo(void);
	void __fastcall vlbMakeItemVisible(int Index);
	void __fastcall vlbNewActiveItem(int Index);
	int __fastcall vlbScaleDown(int N);
	int __fastcall vlbScaleUp(int N);
	void __fastcall vlbSelectRangePrim(int First, int Last, bool Select);
	void __fastcall vlbSetAllItemsPrim(bool Select);
	void __fastcall vlbSetFocusedIndex(int Index);
	void __fastcall vlbSetHScrollPos(void);
	void __fastcall vlbSetHScrollRange(void);
	void __fastcall vlbSetSelRange(int First, int Last);
	void __fastcall vlbSetVScrollPos(void);
	void __fastcall vlbSetVScrollRange(void);
	void __fastcall vlbToggleSelection(int Index);
	void __fastcall vlbValidateItem(int Index);
	void __fastcall vlbVScrollPrim(int Delta);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	MESSAGE void __fastcall LBGetCaretIndex(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetCount(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetCurSel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetItemHeight(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetItemRect(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetSel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBGetTopIndex(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBResetContent(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBSelItemRange(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBSetCurSel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBSetSel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBSetTabStops(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall LBSetTopIndex(Winapi::Messages::TMessage &Msg);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall DragCanceled(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	DYNAMIC int __fastcall DoOnCharToItem(System::WideChar Ch);
	DYNAMIC void __fastcall DoOnClickHeader(const System::Types::TPoint &Point);
	virtual void __fastcall DoOnDrawItem(int Index, const System::Types::TRect &Rect, const System::UnicodeString S);
	virtual System::UnicodeString __fastcall DoOnGetItem(int Index);
	virtual void __fastcall DoOnGetItemColor(int Index, System::Uitypes::TColor &FG, System::Uitypes::TColor &BG);
	virtual bool __fastcall DoOnGetItemStatus(int Index);
	virtual bool __fastcall DoOnIsSelected(int Index);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	DYNAMIC void __fastcall DoOnSelect(int Index, bool Selected);
	DYNAMIC void __fastcall DoOnTopIndexChanged(int NewTopIndex);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	virtual void __fastcall SetItemIndex(int Index);
	virtual void __fastcall SetTopIndex(int Index);
	virtual void __fastcall ForceTopIndex(int Index, bool ThumbTracking);
	virtual void __fastcall SimulatedClick(void);
	bool __fastcall IsValidIndex(int Index);
	__property bool AutoRowHeight = {read=FAutoRowHeight, write=SetAutoRowHeight, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property int Columns = {read=FColumns, write=SetColumns, default=255};
	__property System::UnicodeString Header = {read=FHeader, write=SetHeader};
	__property Ovccolor::TOvcColors* HeaderColor = {read=FHeaderColor, write=FHeaderColor};
	__property bool IntegralHeight = {read=FIntegralHeight, write=SetIntegralHeight, default=1};
	__property bool MultiSelect = {read=FMultiSelect, write=SetMultiSelect, default=0};
	__property int NumItems = {read=FNumItems, write=SetNumItems, default=2147483647};
	__property bool OwnerDraw = {read=FOwnerDraw, write=FOwnerDraw, default=0};
	__property Ovccolor::TOvcColors* ProtectColor = {read=FProtectColor, write=FProtectColor};
	__property int RowHeight = {read=FRowHeight, write=SetRowHeight, default=17};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, default=2};
	__property Ovccolor::TOvcColors* SelectColor = {read=FSelectColor, write=FSelectColor};
	__property bool ShowHeader = {read=FShowHeader, write=SetShowHeader, default=0};
	__property bool UseTabStops = {read=FUseTabStops, write=FUseTabStops, default=0};
	__property int WheelDelta = {read=FWheelDelta, write=FWheelDelta, default=3};
	__property TCharToItemEvent OnCharToItem = {read=FOnCharToItem, write=FOnCharToItem};
	__property THeaderClickEvent OnClickHeader = {read=FOnClickHeader, write=FOnClickHeader};
	__property TDrawItemEvent OnDrawItem = {read=FOnDrawItem, write=FOnDrawItem};
	__property TGetItemEvent OnGetItem = {read=FOnGetItem, write=FOnGetItem};
	__property TGetItemColorEvent OnGetItemColor = {read=FOnGetItemColor, write=FOnGetItemColor};
	__property TGetItemStatusEvent OnGetItemStatus = {read=FOnGetItemStatus, write=FOnGetItemStatus};
	__property TIsSelectedEvent OnIsSelected = {read=FOnIsSelected, write=FOnIsSelected};
	__property TSelectEvent OnSelect = {read=FOnSelect, write=FOnSelect};
	__property TTopIndexChanged OnTopIndexChanged = {read=FOnTopIndexChanged, write=FOnTopIndexChanged};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	
public:
	__fastcall virtual TOvcCustomVirtualListBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomVirtualListBox(void);
	virtual void __fastcall BeginUpdate(void);
	void __fastcall CenterCurrentLine(void);
	void __fastcall CenterLine(int Index);
	void __fastcall DeselectAll(void);
	void __fastcall DrawItem(int Index);
	virtual void __fastcall EndUpdate(void);
	void __fastcall InsertItemsAt(int Items, int Index);
	void __fastcall DeleteItemsAt(int Items, int Index);
	void __fastcall InvalidateItem(int Index);
	int __fastcall ItemAtPos(const System::Types::TPoint &Pos, bool Existing);
	void __fastcall Scroll(int HDelta, int VDelta);
	void __fastcall SelectAll(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall SetTabStops(int const *Tabs, const int Tabs_High);
	__property Canvas;
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, nodefault};
	__property System::Uitypes::TColor FillColor = {read=FFillColor, write=FFillColor, nodefault};
	__property bool SmoothScroll = {read=FSmoothScroll, write=FSmoothScroll, default=1};
	__property int TopIndex = {read=FTopIndex, write=SetTopIndex, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomVirtualListBox(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcVirtualListBox : public TOvcCustomVirtualListBox
{
	typedef TOvcCustomVirtualListBox inherited;
	
__published:
	__property AutoRowHeight = {default=1};
	__property BorderStyle = {default=1};
	__property Columns = {default=255};
	__property Header = {default=0};
	__property HeaderColor;
	__property IntegralHeight = {default=1};
	__property MultiSelect = {default=0};
	__property NumItems = {default=2147483647};
	__property OwnerDraw = {default=0};
	__property ProtectColor;
	__property RowHeight = {default=17};
	__property ScrollBars = {default=2};
	__property SelectColor;
	__property ShowHeader = {default=0};
	__property SmoothScroll = {default=1};
	__property UseTabStops = {default=0};
	__property WheelDelta = {default=3};
	__property OnCharToItem;
	__property OnClickHeader;
	__property OnDrawItem;
	__property OnGetItem;
	__property OnGetItemColor;
	__property OnGetItemStatus;
	__property OnIsSelected;
	__property OnSelect;
	__property OnTopIndexChanged;
	__property OnUserCommand;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TOvcCustomVirtualListBox.Create */ inline __fastcall virtual TOvcVirtualListBox(System::Classes::TComponent* AOwner) : TOvcCustomVirtualListBox(AOwner) { }
	/* TOvcCustomVirtualListBox.Destroy */ inline __fastcall virtual ~TOvcVirtualListBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcVirtualListBox(HWND ParentWindow) : TOvcCustomVirtualListBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Byte vlbMaxTabStops = System::Byte(0x80);
static const bool vlDefAutoRowHeight = true;
static const Vcl::Controls::TAlign vlDefAlign = (Vcl::Controls::TAlign)(0);
static const Vcl::Forms::TFormBorderStyle vlDefBorderStyle = (Vcl::Forms::TFormBorderStyle)(1);
static const int vlDefColor = int(-16777211);
static const System::Byte vlDefColumns = System::Byte(0xff);
static const bool vlDefCtl3D = true;
static const int vlDefHeaderBack = int(-16777201);
static const int vlDefHeaderText = int(-16777198);
static const System::Byte vlDefHeight = System::Byte(0x96);
static const bool vlDefIntegralHeight = true;
static const System::Int8 vlDefItemIndex = System::Int8(-1);
static const bool vlDefMultiSelect = false;
static const int vlDefNumItems = int(2147483647);
static const bool vlDefOwnerDraw = false;
static const bool vlDefParentColor = false;
static const bool vlDefParentCtl3D = true;
static const bool vlDefParentFont = true;
static const int vlDefProtectBack = int(255);
static const int vlDefProtectText = int(16777215);
static const System::Int8 vlDefRowHeight = System::Int8(0x11);
static const System::Uitypes::TScrollStyle vlDefScrollBars = (System::Uitypes::TScrollStyle)(2);
static const int vlDefSelectBack = int(-16777203);
static const int vlDefSelectText = int(-16777202);
static const bool vlDefShowHeader = false;
static const System::Int8 vlDefTopIndex = System::Int8(0x0);
static const bool vlDefTabStop = true;
static const bool vlDefUseTabStops = false;
static const System::Int8 vlDefWidth = System::Int8(0x64);
}	/* namespace Ovcvlb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCVLB)
using namespace Ovcvlb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcvlbHPP

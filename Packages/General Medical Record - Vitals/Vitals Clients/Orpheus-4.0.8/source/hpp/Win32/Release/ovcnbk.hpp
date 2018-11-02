// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcnbk.pas' rev: 29.00 (Windows)

#ifndef OvcnbkHPP
#define OvcnbkHPP

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
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <Vcl.Themes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcnbk
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTabPage;
class DELPHICLASS TOvcNotebook;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TDrawTabEvent)(System::TObject* Sender, int Index, const System::UnicodeString Title, const System::Types::TRect &R, bool Enabled, bool Active);

typedef void __fastcall (__closure *TMouseOverTabEvent)(System::TObject* Sender, int Index);

typedef void __fastcall (__closure *TPageChangeEvent)(System::TObject* Sender, int Index, bool &AllowChange);

typedef void __fastcall (__closure *TPageChangedEvent)(System::TObject* Sender, int Index);

typedef void __fastcall (__closure *TTabClickEvent)(System::TObject* Sender, int Index);

enum DECLSPEC_DENUM TOvcTabOrientation : unsigned char { toTop, toRight, toBottom, toLeft };

enum DECLSPEC_DENUM TTabTextOrientation : unsigned char { ttoHorizontal, ttoVerticalRight, ttoVerticalLeft };

class PASCALIMPLEMENTATION TOvcTabPage : public Ovcbase::TOvcCollectibleControl
{
	typedef Ovcbase::TOvcCollectibleControl inherited;
	
protected:
	System::Types::TRect FArea;
	int FRow;
	System::Uitypes::TColor FTabColor;
	int FTabWidth;
	System::Uitypes::TColor FTextColor;
	bool FPageVisible;
	TOvcNotebook* NoteBook;
	System::UnicodeString __fastcall GetCaption(void);
	int __fastcall GetDummy(void);
	bool __fastcall GetIsEnabled(void);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetDummy(int Value);
	void __fastcall SetIsEnabled(bool Value);
	void __fastcall SetTabColor(System::Uitypes::TColor Value);
	void __fastcall SetTextColor(System::Uitypes::TColor Value);
	void __fastcall SetPageVisible(bool Value);
	int __fastcall tpGetHeight(void);
	int __fastcall tpGetLeft(void);
	int __fastcall tpGetTop(void);
	int __fastcall tpGetWidth(void);
	void __fastcall tpReadBoolean(System::Classes::TReader* Reader);
	void __fastcall tpReadCursor(System::Classes::TReader* Reader);
	void __fastcall tpReadInt(System::Classes::TReader* Reader);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	virtual void __fastcall Paint(void);
	HIDESBASE MESSAGE void __fastcall CMMouseenter(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TOvcTabPage(System::Classes::TComponent* AOwner);
	__property System::Types::TRect Area = {read=FArea, write=FArea, stored=false};
	__property int Row = {read=FRow, write=FRow, nodefault};
	__property int TabWidth = {read=FTabWidth, write=FTabWidth, nodefault};
	
__published:
	__property System::UnicodeString Caption = {read=GetCaption, write=SetCaption};
	__property bool Enabled = {read=GetIsEnabled, write=SetIsEnabled, default=1};
	__property bool PageVisible = {read=FPageVisible, write=SetPageVisible, default=1};
	__property System::Uitypes::TColor TabColor = {read=FTabColor, write=SetTabColor, default=-16777201};
	__property System::Uitypes::TColor TextColor = {read=FTextColor, write=SetTextColor, default=-16777198};
	__property Font;
	__property Hint = {default=0};
	__property ParentFont = {default=1};
	__property int Cursor = {read=GetDummy, write=SetDummy, stored=false, nodefault};
	__property int TabOrder = {read=GetDummy, write=SetDummy, stored=false, nodefault};
	__property Left = {stored=false};
	__property Top = {stored=false};
	__property Width = {stored=false};
	__property Height = {stored=false};
public:
	/* TOvcCollectibleControl.Destroy */ inline __fastcall virtual ~TOvcTabPage(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTabPage(HWND ParentWindow) : Ovcbase::TOvcCollectibleControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcNotebook : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	Vcl::Graphics::TFont* FActiveTabFont;
	bool FConserveResources;
	int FDefaultPageIndex;
	System::Uitypes::TColor FHighlightColor;
	bool FOldStyle;
	Ovcbase::TOvcCollection* FPages;
	int FPageIndex;
	bool FPageUsesTabColor;
	System::Uitypes::TColor FShadowColor;
	bool FShadowedText;
	bool FTabAutoHeight;
	int FTabHeight;
	TOvcTabOrientation FTabOrientation;
	TTabTextOrientation FTabTextOrientation;
	int FTabRowCount;
	bool FTabUseDefaultColor;
	System::Uitypes::TColor FTextShadowColor;
	bool FUseActiveTabFont;
	TDrawTabEvent FOnDrawTab;
	TMouseOverTabEvent FOnMouseOverTab;
	TPageChangeEvent FOnPageChange;
	TPageChangedEvent FOnPageChanged;
	TTabClickEvent FOnTabClick;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	int tabFocusedRow;
	System::Types::TPoint tabHitTest;
	int tabLastRow;
	bool tabOverTab;
	bool tabPainting;
	bool tabTabChanging;
	HICON tabTabCursor;
	bool tabTabSelecting;
	int tabTotalRows;
	int FHotTab;
	HIDESBASE int __fastcall GetClientHeight(void);
	HIDESBASE int __fastcall GetClientWidth(void);
	TOvcTabPage* __fastcall GetPage(int Index);
	int __fastcall GetPageCount(void);
	void __fastcall SetActiveTabFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetConserveResources(bool Value);
	void __fastcall SetHighlightColor(const System::Uitypes::TColor Value);
	void __fastcall SetOldStyle(bool Value);
	void __fastcall SetPageIndex(int Value);
	void __fastcall SetPageUsesTabColor(bool Value);
	void __fastcall SetShadowColor(const System::Uitypes::TColor Value);
	void __fastcall SetShadowedText(bool Value);
	void __fastcall SetTabAutoHeight(bool Value);
	void __fastcall SetTabColor(System::Uitypes::TColor Value);
	void __fastcall SetTabHeight(int Value);
	void __fastcall SetTabOrientation(TOvcTabOrientation Value);
	void __fastcall SetTabTextOrientation(TTabTextOrientation Value);
	void __fastcall SetTabRowCount(int Value);
	void __fastcall SetTabUseDefaultColor(bool Value);
	void __fastcall SetTextShadowColor(const System::Uitypes::TColor Value);
	void __fastcall SetUseActiveTabFont(bool Value);
	void __fastcall tabAdjustPageSize(void);
	void __fastcall tabCalcTabInfo(void);
	void __fastcall tabCollectionChanged(System::TObject* Sender);
	void __fastcall tabCollectionItemSelected(System::TObject* Sender, int Index);
	void __fastcall tabGetEditorCaption(System::UnicodeString &Caption);
	void __fastcall tabDrawFocusRect(int Index);
	void __fastcall tabFontChanged(System::TObject* Sender);
	void __fastcall tabPaintBottomTabs(void);
	void __fastcall tabPaintLeftTabs(void);
	void __fastcall tabPaintRightTabs(void);
	void __fastcall tabPaintTopTabs(void);
	System::Types::TRect __fastcall tabGetTabRect(int Index);
	bool __fastcall IsTabHeightStored(void);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMParentColorChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall ShowControl(Vcl::Controls::TControl* AControl);
	DYNAMIC bool __fastcall DoOnDrawTab(int Index, const System::UnicodeString Title, bool Enabled, bool Active);
	DYNAMIC void __fastcall DoOnMouseOverTab(int Index);
	DYNAMIC void __fastcall DoOnPageChange(int Index, bool &AllowChange);
	DYNAMIC void __fastcall DoOnPageChanged(int Index);
	DYNAMIC void __fastcall DoOnTabClick(int Index);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	HIDESBASE MESSAGE void __fastcall CMMouseleave(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TOvcNotebook(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcNotebook(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	System::Types::TRect __fastcall GetTabRect(int Index);
	void __fastcall DeletePage(int Index);
	void __fastcall ForcePageHandles(void);
	int __fastcall IndexOf(const System::UnicodeString Name, bool ByCaption);
	void __fastcall InsertPage(const System::UnicodeString Name, int Index);
	void __fastcall InvalidateTab(int Index);
	bool __fastcall IsValid(int Index);
	void __fastcall NextPage(void);
	int __fastcall NextValidIndex(int Index);
	int __fastcall PrevValidIndex(int Index);
	void __fastcall PrevPage(void);
	int __fastcall PageNameToIndex(const System::UnicodeString Name);
	int __fastcall TabsInRow(int Row);
	__property Canvas;
	__property int ClientHeight = {read=GetClientHeight, nodefault};
	__property int ClientWidth = {read=GetClientWidth, nodefault};
	__property int PageCount = {read=GetPageCount, nodefault};
	__property TOvcTabPage* Pages[int Index] = {read=GetPage};
	
__published:
	__property bool UseActiveTabFont = {read=FUseActiveTabFont, write=SetUseActiveTabFont, default=1};
	__property Vcl::Graphics::TFont* ActiveTabFont = {read=FActiveTabFont, write=SetActiveTabFont, stored=FUseActiveTabFont};
	__property bool ConserveResources = {read=FConserveResources, write=SetConserveResources, default=0};
	__property int DefaultPageIndex = {read=FDefaultPageIndex, write=FDefaultPageIndex, default=0};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=-16777196};
	__property bool OldStyle = {read=FOldStyle, write=SetOldStyle, default=0};
	__property int PageIndex = {read=FPageIndex, write=SetPageIndex, stored=false, nodefault};
	__property Ovcbase::TOvcCollection* PageCollection = {read=FPages, write=FPages};
	__property bool PageUsesTabColor = {read=FPageUsesTabColor, write=SetPageUsesTabColor, default=1};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=SetShadowColor, default=-16777200};
	__property bool ShadowedText = {read=FShadowedText, write=SetShadowedText, default=0};
	__property bool TabAutoHeight = {read=FTabAutoHeight, write=SetTabAutoHeight, default=1};
	__property int TabHeight = {read=FTabHeight, write=SetTabHeight, stored=IsTabHeightStored, default=20};
	__property TOvcTabOrientation TabOrientation = {read=FTabOrientation, write=SetTabOrientation, default=0};
	__property TTabTextOrientation TabTextOrientation = {read=FTabTextOrientation, write=SetTabTextOrientation, default=0};
	__property int TabRowCount = {read=FTabRowCount, write=SetTabRowCount, default=0};
	__property System::Uitypes::TColor TextShadowColor = {read=FTextShadowColor, write=SetTextShadowColor, default=-16777200};
	__property bool TabUseDefaultColor = {read=FTabUseDefaultColor, write=SetTabUseDefaultColor, default=1};
	__property TDrawTabEvent OnDrawTab = {read=FOnDrawTab, write=FOnDrawTab};
	__property TMouseOverTabEvent OnMouseOverTab = {read=FOnMouseOverTab, write=FOnMouseOverTab};
	__property TPageChangeEvent OnPageChange = {read=FOnPageChange, write=FOnPageChange};
	__property TPageChangedEvent OnPageChanged = {read=FOnPageChanged, write=FOnPageChanged};
	__property TTabClickEvent OnTabClick = {read=FOnTabClick, write=FOnTabClick};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Controller;
	__property Color = {default=-16777201};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property LabelInfo;
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
	/* TWinControl.CreateParented */ inline __fastcall TOvcNotebook(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcnbk */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCNBK)
using namespace Ovcnbk;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcnbkHPP

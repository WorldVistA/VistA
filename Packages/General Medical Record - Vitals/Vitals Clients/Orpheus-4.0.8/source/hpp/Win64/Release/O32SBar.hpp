// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'o32sbar.pas' rev: 29.00 (Windows)

#ifndef O32sbarHPP
#define O32sbarHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdActns.hpp>
#include <ovcbase.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32sbar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32SBContainer;
class DELPHICLASS TO32StatusPanel;
class DELPHICLASS TO32StatusPanels;
class DELPHICLASS TO32CustomStatusBar;
class DELPHICLASS TO32StatusBar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TO32StatusPanelStyle : unsigned char { spsText, spsContainer, spsOwnerDraw };

enum DECLSPEC_DENUM TO32StatusPanelBevel : unsigned char { spbNone, spbLowered, spbRaised };

class PASCALIMPLEMENTATION TO32SBContainer : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	TO32CustomStatusBar* FStatusBar;
	int FIndex;
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Message);
	MESSAGE void __fastcall CMNotifyParent(Winapi::Messages::TWMNotify &Message);
	void __fastcall FixControls(void);
	void __fastcall InvalidateControls(void);
	
public:
	__fastcall virtual TO32SBContainer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32SBContainer(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	virtual void __fastcall Invalidate(void);
	__property int Index = {read=FIndex, nodefault};
	__property TO32CustomStatusBar* StatusBar = {read=FStatusBar};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32SBContainer(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32StatusPanel : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FText;
	TO32CustomStatusBar* FStatusBar;
	int FContainerIndex;
	int FWidth;
	System::Classes::TAlignment FAlignment;
	TO32StatusPanelBevel FBevel;
	System::Classes::TBiDiMode FBiDiMode;
	bool FParentBiDiMode;
	TO32StatusPanelStyle FStyle;
	bool FUpdateNeeded;
	int __fastcall CreateContainer(void);
	bool __fastcall IsBiDiModeStored(void);
	void __fastcall SetAlignment(System::Classes::TAlignment Value);
	void __fastcall SetBevel(TO32StatusPanelBevel Value);
	void __fastcall SetBiDiMode(System::Classes::TBiDiMode Value);
	void __fastcall SetParentBiDiMode(bool Value);
	void __fastcall SetStyle(TO32StatusPanelStyle Value);
	void __fastcall SetText(const System::UnicodeString Value);
	void __fastcall SetWidth(int Value);
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	TO32SBContainer* __fastcall GetContainer(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall ReadIndex(System::Classes::TReader* Reader);
	void __fastcall WriteIndex(System::Classes::TWriter* Writer);
	
public:
	__fastcall virtual TO32StatusPanel(System::Classes::TCollection* Collection);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall ParentBiDiModeChanged(void);
	bool __fastcall UseRightToLeftAlignment(void);
	bool __fastcall UseRightToLeftReading(void);
	__property TO32SBContainer* Container = {read=GetContainer};
	__property int ContainerIndex = {read=FContainerIndex, write=FContainerIndex, nodefault};
	
__published:
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property TO32StatusPanelBevel Bevel = {read=FBevel, write=SetBevel, default=1};
	__property System::Classes::TBiDiMode BiDiMode = {read=FBiDiMode, write=SetBiDiMode, stored=IsBiDiModeStored, nodefault};
	__property bool ParentBiDiMode = {read=FParentBiDiMode, write=SetParentBiDiMode, default=1};
	__property TO32StatusPanelStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TO32StatusPanel(void) { }
	
};


typedef void __fastcall (__closure *TO32DrawPanelEvent)(TO32CustomStatusBar* StatusBar, TO32StatusPanel* Panel, const System::Types::TRect &Rect);

class PASCALIMPLEMENTATION TO32StatusPanels : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TO32StatusPanel* operator[](int Index) { return Items[Index]; }
	
protected:
	TO32CustomStatusBar* FStatusBar;
	HIDESBASE TO32StatusPanel* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TO32StatusPanel* Value);
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	virtual void __fastcall Update(System::Classes::TCollectionItem* Item);
	
public:
	__fastcall TO32StatusPanels(TO32CustomStatusBar* StatusBar);
	HIDESBASE TO32StatusPanel* __fastcall Add(void);
	__property TO32StatusPanel* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TO32StatusPanels(void) { }
	
};


class PASCALIMPLEMENTATION TO32CustomStatusBar : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
protected:
	TO32StatusPanels* FPanels;
	Vcl::Graphics::TCanvas* FCanvas;
	Ovcbase::TO32ContainerList* FContainers;
	System::UnicodeString FSimpleText;
	bool FSimplePanel;
	bool FSizeGrip;
	bool FUseSystemFont;
	bool FAutoHint;
	TO32DrawPanelEvent FOnDrawPanel;
	System::Classes::TNotifyEvent FOnHint;
	void __fastcall DoRightToLeftAlignment(System::UnicodeString &Str, System::Classes::TAlignment AAlignment, bool ARTLAlignment);
	HIDESBASE bool __fastcall IsFontStored(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetPanels(TO32StatusPanels* Value);
	void __fastcall SetSimplePanel(bool Value);
	void __fastcall UpdateSimpleText(void);
	void __fastcall SetSimpleText(const System::UnicodeString Value);
	void __fastcall SetSizeGrip(bool Value);
	void __fastcall SyncToSystemFont(void);
	void __fastcall UpdatePanel(int Index, bool Repaint);
	void __fastcall UpdatePanels(bool UpdateRects, bool UpdateText);
	HIDESBASE MESSAGE void __fastcall CMBiDiModeChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMParentFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMSysColorChange(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMWinIniChange(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMSysFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Message);
	MESSAGE void __fastcall WMGetTextLength(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	void __fastcall SetUseSystemFont(const bool Value);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual bool __fastcall DoHint(void);
	DYNAMIC void __fastcall DrawPanel(TO32StatusPanel* Panel, const System::Types::TRect &Rect);
	DYNAMIC System::Classes::TComponent* __fastcall GetChildOwner(void);
	int __fastcall AddContainer(TO32SBContainer* Container);
	void __fastcall RemoveContainer(TO32SBContainer* Container);
	TO32SBContainer* __fastcall GetContainer(int Index);
	
public:
	__fastcall virtual TO32CustomStatusBar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TO32CustomStatusBar(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	DYNAMIC void __fastcall FlipChildren(bool AllLevels);
	TO32StatusPanel* __fastcall GetPanelAt(int X, int Y);
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property TO32SBContainer* Containers[int Index] = {read=GetContainer};
	__property bool AutoHint = {read=FAutoHint, write=FAutoHint, default=0};
	__property Align = {default=2};
	__property BorderWidth = {default=0};
	__property Color = {default=-16777201};
	__property Font = {stored=IsFontStored};
	__property TO32StatusPanels* Panels = {read=FPanels, write=SetPanels};
	__property ParentColor = {default=0};
	__property ParentFont = {default=0};
	__property bool SimplePanel = {read=FSimplePanel, write=SetSimplePanel, nodefault};
	__property System::UnicodeString SimpleText = {read=FSimpleText, write=SetSimpleText};
	__property bool SizeGrip = {read=FSizeGrip, write=SetSizeGrip, default=1};
	__property bool UseSystemFont = {read=FUseSystemFont, write=SetUseSystemFont, default=1};
	__property System::Classes::TNotifyEvent OnHint = {read=FOnHint, write=FOnHint};
	__property TO32DrawPanelEvent OnDrawPanel = {read=FOnDrawPanel, write=FOnDrawPanel};
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32CustomStatusBar(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TO32StatusBar : public TO32CustomStatusBar
{
	typedef TO32CustomStatusBar inherited;
	
__published:
	__property About = {default=0};
	__property Action;
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BorderWidth = {default=0};
	__property DragKind = {default=0};
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property OnEndDock;
	__property OnResize;
	__property OnStartDock;
	__property OnStartDrag;
	__property AutoHint = {default=0};
	__property Align = {default=2};
	__property Color = {default=-16777201};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Panels;
	__property ParentColor = {default=0};
	__property ParentFont = {default=0};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property SimplePanel = {default=0};
	__property SimpleText = {default=0};
	__property SizeGrip = {default=1};
	__property UseSystemFont = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnContextPopup;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnHint;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnDrawPanel;
public:
	/* TO32CustomStatusBar.Create */ inline __fastcall virtual TO32StatusBar(System::Classes::TComponent* AOwner) : TO32CustomStatusBar(AOwner) { }
	/* TO32CustomStatusBar.Destroy */ inline __fastcall virtual ~TO32StatusBar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32StatusBar(HWND ParentWindow) : TO32CustomStatusBar(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace O32sbar */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32SBAR)
using namespace O32sbar;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32sbarHPP

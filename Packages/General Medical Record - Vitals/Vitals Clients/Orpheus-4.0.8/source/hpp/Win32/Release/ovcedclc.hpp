// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedclc.pas' rev: 29.00 (Windows)

#ifndef OvcedclcHPP
#define OvcedclcHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.MultiMon.hpp>
#include <ovcbase.hpp>
#include <ovccalc.hpp>
#include <ovcedpop.hpp>
#include <ovcmisc.hpp>
#include <ovceditf.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedclc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomNumberEdit;
class DELPHICLASS TOvcNumberEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomNumberEdit : public Ovcedpop::TOvcEdPopup
{
	typedef Ovcedpop::TOvcEdPopup inherited;
	
protected:
	bool FAllowIncDec;
	Ovccalc::TOvcCalculator* FCalculator;
	bool PopupClosing;
	System::Uitypes::TCursor HoldCursor;
	bool WasAutoScroll;
	double __fastcall GetAsFloat(void);
	int __fastcall GetAsInteger(void);
	System::UnicodeString __fastcall GetAsString(void);
	Ovccalc::TOvcCalcColors* __fastcall GetPopupColors(void);
	int __fastcall GetPopupDecimals(void);
	Vcl::Graphics::TFont* __fastcall GetPopupFont(void);
	int __fastcall GetPopupHeight(void);
	int __fastcall GetPopupWidth(void);
	HIDESBASE bool __fastcall GetReadOnly(void);
	void __fastcall SetAsFloat(double Value);
	void __fastcall SetAsInteger(int Value);
	void __fastcall SetAsString(const System::UnicodeString Value);
	void __fastcall SetPopupColors(Ovccalc::TOvcCalcColors* Value);
	void __fastcall SetPopupDecimals(int Value);
	void __fastcall SetPopupFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetPopupHeight(int Value);
	void __fastcall SetPopupWidth(int Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall PopupButtonPressed(System::TObject* Sender, Ovccalc::TOvcCalculatorButton Button);
	void __fastcall PopupKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PopupKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall PopupMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall DoExit(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	__property bool AllowIncDec = {read=FAllowIncDec, write=FAllowIncDec, nodefault};
	__property Ovccalc::TOvcCalcColors* PopupColors = {read=GetPopupColors, write=SetPopupColors};
	__property int PopupDecimals = {read=GetPopupDecimals, write=SetPopupDecimals, nodefault};
	__property Vcl::Graphics::TFont* PopupFont = {read=GetPopupFont, write=SetPopupFont};
	__property int PopupHeight = {read=GetPopupHeight, write=SetPopupHeight, nodefault};
	__property int PopupWidth = {read=GetPopupWidth, write=SetPopupWidth, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	
public:
	__fastcall virtual TOvcCustomNumberEdit(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	__property int AsInteger = {read=GetAsInteger, write=SetAsInteger, nodefault};
	__property Ovccalc::TOvcCalculator* Calculator = {read=FCalculator};
	__property double AsFloat = {read=GetAsFloat, write=SetAsFloat};
	__property System::UnicodeString AsString = {read=GetAsString, write=SetAsString};
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcCustomNumberEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomNumberEdit(HWND ParentWindow) : Ovcedpop::TOvcEdPopup(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcNumberEdit : public TOvcCustomNumberEdit
{
	typedef TOvcCustomNumberEdit inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AllowIncDec;
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property ButtonGlyph;
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupAnchor;
	__property PopupColors;
	__property PopupDecimals;
	__property PopupFont;
	__property PopupHeight;
	__property PopupWidth;
	__property PopupMenu;
	__property ReadOnly;
	__property ShowHint;
	__property ShowButton;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnChange;
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
	__property OnPopupClose;
	__property OnPopupOpen;
	__property OnStartDrag;
public:
	/* TOvcCustomNumberEdit.Create */ inline __fastcall virtual TOvcNumberEdit(System::Classes::TComponent* AOwner) : TOvcCustomNumberEdit(AOwner) { }
	
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcNumberEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcNumberEdit(HWND ParentWindow) : TOvcCustomNumberEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcedclc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDCLC)
using namespace Ovcedclc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedclcHPP

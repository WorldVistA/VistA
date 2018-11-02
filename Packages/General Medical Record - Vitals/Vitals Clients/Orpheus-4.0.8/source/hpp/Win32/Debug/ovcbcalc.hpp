// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbcalc.pas' rev: 29.00 (Windows)

#ifndef OvcbcalcHPP
#define OvcbcalcHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.MultiMon.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcver.hpp>
#include <ovcmisc.hpp>
#include <ovceditf.hpp>
#include <ovcbordr.hpp>
#include <ovcedclc.hpp>
#include <ovccalc.hpp>
#include <ovcedpop.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbcalc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcNumberEditEx;
class DELPHICLASS TOvcBorderEdPopup;
class DELPHICLASS TOvcBorderedNumberEdit;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOvcPopupEvent)(System::TObject* Sender);

enum DECLSPEC_DENUM TOvcPopupAnchor : unsigned char { paLeft, paRight };

class PASCALIMPLEMENTATION TOvcNumberEditEx : public Ovcedclc::TOvcNumberEdit
{
	typedef Ovcedclc::TOvcNumberEdit inherited;
	
protected:
	TOvcBorderEdPopup* BorderParent;
public:
	/* TOvcCustomNumberEdit.Create */ inline __fastcall virtual TOvcNumberEditEx(System::Classes::TComponent* AOwner) : Ovcedclc::TOvcNumberEdit(AOwner) { }
	
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcNumberEditEx(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcNumberEditEx(HWND ParentWindow) : Ovcedclc::TOvcNumberEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBorderEdPopup : public Ovcbordr::TOvcBorderParent
{
	typedef Ovcbordr::TOvcBorderParent inherited;
	
protected:
	Ovceditf::TOvcCustomEdit* FEdit;
	Ovcedpop::TOvcEdButton* FButton;
	Vcl::Graphics::TBitmap* FButtonGlyph;
	Ovcbase::TOvcController* FController;
	bool FPopupActive;
	TOvcPopupAnchor FPopupAnchor;
	TOvcPopupEvent FOnPopupClose;
	TOvcPopupEvent FOnPopupOpen;
	bool FShowButton;
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetShowButton(bool Value);
	int __fastcall GetButtonWidth(void);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC bool __fastcall GetButtonEnabled(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	virtual void __fastcall Loaded(void);
	MESSAGE void __fastcall OnMsgClose(Winapi::Messages::TMessage &M);
	MESSAGE void __fastcall OnMsgOpen(Winapi::Messages::TMessage &M);
	
public:
	__fastcall virtual TOvcBorderEdPopup(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBorderEdPopup(void);
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	virtual void __fastcall SetEditControl(Ovceditf::TOvcCustomEdit* EC);
	__property Canvas;
	__property bool PopupActive = {read=FPopupActive, nodefault};
	__property TOvcPopupAnchor PopupAnchor = {read=FPopupAnchor, write=FPopupAnchor, nodefault};
	
__published:
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBorderEdPopup(HWND ParentWindow) : Ovcbordr::TOvcBorderParent(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBorderedNumberEdit : public TOvcBorderEdPopup
{
	typedef TOvcBorderEdPopup inherited;
	
protected:
	TOvcNumberEditEx* FOvcEdit;
	System::Classes::TBiDiMode FBiDiMode;
	Vcl::Controls::TSizeConstraints* FConstraints;
	bool FParentBiDiMode;
	System::Uitypes::TDragKind FDragKind;
	System::UnicodeString FAbout;
	bool FAutoSelect;
	bool FAutoSize;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::Uitypes::TEditCharCase FCharCase;
	Ovcbase::TOvcController* FController;
	System::Uitypes::TCursor FCursor;
	System::Uitypes::TCursor FDragCursor;
	System::Uitypes::TDragMode FDragMode;
	bool FEnabled;
	Vcl::Graphics::TFont* FFont;
	int FHeight;
	bool FHideSelection;
	Vcl::Controls::TImeMode FImeMode;
	System::UnicodeString FImeName;
	int FMaxLength;
	bool FOEMConvert;
	bool FParentFont;
	bool FParentShowHint;
	System::WideChar FPasswordChar;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	bool FReadOnly;
	bool FShowHint;
	System::Uitypes::TTabOrder FTabOrder;
	bool FVisible;
	int FWidth;
	System::Classes::TNotifyEvent FOnChange;
	System::Classes::TNotifyEvent FOnClick;
	System::Classes::TNotifyEvent FOnDblClick;
	Vcl::Controls::TDragDropEvent FOnDragDrop;
	Vcl::Controls::TDragOverEvent FOnDragOver;
	Vcl::Controls::TEndDragEvent FOnEndDrag;
	System::Classes::TNotifyEvent FOnEnter;
	System::Classes::TNotifyEvent FOnExit;
	Vcl::Controls::TKeyEvent FOnKeyDown;
	Vcl::Controls::TKeyPressEvent FOnKeyPress;
	Vcl::Controls::TKeyEvent FOnKeyUp;
	Vcl::Controls::TMouseEvent FOnMouseDown;
	Vcl::Controls::TMouseMoveEvent FOnMouseMove;
	Vcl::Controls::TMouseEvent FOnMouseUp;
	Vcl::Controls::TStartDragEvent FOnStartDrag;
	bool FAllowIncDec;
	Ovccalc::TOvcCalculator* FCalculator;
	bool PopupClosing;
	System::Uitypes::TCursor HoldCursor;
	bool WasAutoScroll;
	System::Classes::TBiDiMode __fastcall GetBiDiMode(void);
	System::Uitypes::TDragKind __fastcall GetDragKind(void);
	bool __fastcall GetParentBiDiMode(void);
	virtual void __fastcall SetBiDiMode(System::Classes::TBiDiMode Value);
	void __fastcall SetDragKind(System::Uitypes::TDragKind Value);
	virtual void __fastcall SetParentBiDiMode(bool Value);
	HIDESBASE System::UnicodeString __fastcall GetAbout(void);
	bool __fastcall GetAutoSelect(void);
	bool __fastcall GetAutoSize(void);
	System::Uitypes::TEditCharCase __fastcall GetCharCase(void);
	Ovcbase::TOvcController* __fastcall GetController(void);
	System::Uitypes::TCursor __fastcall GetCursor(void);
	System::Uitypes::TCursor __fastcall GetDragCursor(void);
	HIDESBASE System::Uitypes::TDragMode __fastcall GetDragMode(void);
	bool __fastcall GetEditEnabled(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	bool __fastcall GetHideSelection(void);
	Vcl::Controls::TImeMode __fastcall GetImeMode(void);
	System::UnicodeString __fastcall GetImeName(void);
	int __fastcall GetMaxLength(void);
	bool __fastcall GetOEMConvert(void);
	bool __fastcall GetParentShowHint(void);
	System::WideChar __fastcall GetPasswordChar(void);
	bool __fastcall GetReadOnly(void);
	bool __fastcall GetEditShowButton(void);
	bool __fastcall GetParentFont(void);
	bool __fastcall GetEditParentShowHint(void);
	System::Classes::TNotifyEvent __fastcall GetOnChange(void);
	System::Classes::TNotifyEvent __fastcall GetOnClick(void);
	System::Classes::TNotifyEvent __fastcall GetOnDblClick(void);
	Vcl::Controls::TDragDropEvent __fastcall GetOnDragDrop(void);
	Vcl::Controls::TDragOverEvent __fastcall GetOnDragOver(void);
	Vcl::Controls::TEndDragEvent __fastcall GetOnEndDrag(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyDown(void);
	Vcl::Controls::TKeyPressEvent __fastcall GetOnKeyPress(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyUp(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseDown(void);
	Vcl::Controls::TMouseMoveEvent __fastcall GetOnMouseMove(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseUp(void);
	TOvcPopupEvent __fastcall GetOnPopupClose(void);
	TOvcPopupEvent __fastcall GetOnPopupOpen(void);
	TOvcPopupAnchor __fastcall GetPopupAnchor(void);
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetAutoSelect(bool Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetCharCase(System::Uitypes::TEditCharCase Value);
	HIDESBASE void __fastcall SetCursor(System::Uitypes::TCursor Value);
	void __fastcall SetDragCursor(System::Uitypes::TCursor Value);
	void __fastcall SetEditController(Ovcbase::TOvcController* Value);
	void __fastcall SetEditDragMode(System::Uitypes::TDragMode Value);
	void __fastcall SetEditEnabled(bool Value);
	HIDESBASE void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetHideSelection(bool Value);
	void __fastcall SetImeMode(Vcl::Controls::TImeMode Value);
	void __fastcall SetImeName(const System::UnicodeString Value);
	void __fastcall SetMaxLength(int Value);
	void __fastcall SetOEMConvert(bool Value);
	HIDESBASE void __fastcall SetParentShowHint(bool Value);
	void __fastcall SetPasswordChar(System::WideChar Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetEditShowButton(bool Value);
	void __fastcall SetOnChange(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnClick(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnDblClick(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnDragDrop(Vcl::Controls::TDragDropEvent Value);
	void __fastcall SetOnDragOver(Vcl::Controls::TDragOverEvent Value);
	void __fastcall SetOnEndDrag(Vcl::Controls::TEndDragEvent Value);
	void __fastcall SetOnKeyDown(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnKeyPress(Vcl::Controls::TKeyPressEvent Value);
	void __fastcall SetOnKeyUp(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnMouseDown(Vcl::Controls::TMouseEvent Value);
	void __fastcall SetOnMouseMove(Vcl::Controls::TMouseMoveEvent Value);
	void __fastcall SetOnMouseUp(Vcl::Controls::TMouseEvent Value);
	void __fastcall SetOnPopupClose(TOvcPopupEvent Value);
	void __fastcall SetOnPopupOpen(TOvcPopupEvent Value);
	void __fastcall SetPopupAnchor(TOvcPopupAnchor Value);
	double __fastcall GetAsFloat(void);
	int __fastcall GetAsInteger(void);
	System::UnicodeString __fastcall GetAsString(void);
	Ovccalc::TOvcCalcColors* __fastcall GetPopupColors(void);
	int __fastcall GetPopupDecimals(void);
	Vcl::Graphics::TFont* __fastcall GetPopupFont(void);
	int __fastcall GetPopupHeight(void);
	int __fastcall GetPopupWidth(void);
	void __fastcall SetAsFloat(double Value);
	void __fastcall SetAsInteger(int Value);
	void __fastcall SetAsString(const System::UnicodeString Value);
	void __fastcall SetPopupColors(Ovccalc::TOvcCalcColors* Value);
	void __fastcall SetPopupDecimals(int Value);
	void __fastcall SetPopupFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetPopupHeight(int Value);
	void __fastcall SetPopupWidth(int Value);
	HIDESBASE void __fastcall SetParentFont(bool Value);
	void __fastcall SetEditParentShowHint(bool Value);
	DYNAMIC void __fastcall GlyphChanged(void);
	
public:
	__fastcall virtual TOvcBorderedNumberEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBorderedNumberEdit(void);
	__property int AsInteger = {read=GetAsInteger, write=SetAsInteger, nodefault};
	__property double AsFloat = {read=GetAsFloat, write=SetAsFloat};
	__property System::UnicodeString AsString = {read=GetAsString, write=SetAsString};
	__property Ovccalc::TOvcCalculator* Calculator = {read=FCalculator};
	__property TOvcNumberEditEx* EditControl = {read=FOvcEdit};
	
__published:
	__property Anchors = {default=3};
	__property System::Classes::TBiDiMode BiDiMode = {read=GetBiDiMode, write=SetBiDiMode, nodefault};
	__property Constraints;
	__property bool ParentBiDiMode = {read=GetParentBiDiMode, write=SetParentBiDiMode, nodefault};
	__property System::Uitypes::TDragKind DragKind = {read=GetDragKind, write=SetDragKind, nodefault};
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout};
	__property bool AllowIncDec = {read=FAllowIncDec, write=FAllowIncDec, nodefault};
	__property bool AutoSelect = {read=GetAutoSelect, write=SetAutoSelect, nodefault};
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, nodefault};
	__property System::Uitypes::TEditCharCase CharCase = {read=GetCharCase, write=SetCharCase, nodefault};
	__property Ovcbase::TOvcController* Controller = {read=GetController, write=SetEditController};
	__property System::Uitypes::TCursor Cursor = {read=GetCursor, write=SetCursor, nodefault};
	__property System::Uitypes::TCursor DragCursor = {read=GetDragCursor, write=SetDragCursor, nodefault};
	__property System::Uitypes::TDragMode DragMode = {read=GetDragMode, write=SetDragMode, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
	__property bool HideSelection = {read=GetHideSelection, write=SetHideSelection, nodefault};
	__property Vcl::Controls::TImeMode ImeMode = {read=GetImeMode, write=SetImeMode, nodefault};
	__property ImeName = {default=0};
	__property int MaxLength = {read=GetMaxLength, write=SetMaxLength, nodefault};
	__property bool OEMConvert = {read=GetOEMConvert, write=SetOEMConvert, nodefault};
	__property bool ParentFont = {read=GetParentFont, write=SetParentFont, nodefault};
	__property bool ParentShowHint = {read=GetParentShowHint, write=SetParentShowHint, nodefault};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, nodefault};
	__property TOvcPopupAnchor PopupAnchor = {read=GetPopupAnchor, write=SetPopupAnchor, nodefault};
	__property Ovccalc::TOvcCalcColors* PopupColors = {read=GetPopupColors, write=SetPopupColors};
	__property int PopupDecimals = {read=GetPopupDecimals, write=SetPopupDecimals, nodefault};
	__property Vcl::Graphics::TFont* PopupFont = {read=GetPopupFont, write=SetPopupFont};
	__property int PopupHeight = {read=GetPopupHeight, write=SetPopupHeight, nodefault};
	__property PopupMenu;
	__property int PopupWidth = {read=GetPopupWidth, write=SetPopupWidth, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property bool ShowButton = {read=GetEditShowButton, write=SetEditShowButton, nodefault};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property System::Classes::TNotifyEvent OnChange = {read=GetOnChange, write=SetOnChange};
	__property System::Classes::TNotifyEvent OnClick = {read=GetOnClick, write=SetOnClick};
	__property System::Classes::TNotifyEvent OnDblClick = {read=GetOnDblClick, write=SetOnDblClick};
	__property Vcl::Controls::TDragDropEvent OnDragDrop = {read=GetOnDragDrop, write=SetOnDragDrop};
	__property Vcl::Controls::TDragOverEvent OnDragOver = {read=GetOnDragOver, write=SetOnDragOver};
	__property Vcl::Controls::TEndDragEvent OnEndDrag = {read=GetOnEndDrag, write=SetOnEndDrag};
	__property OnEnter;
	__property OnExit;
	__property Vcl::Controls::TKeyEvent OnKeyDown = {read=GetOnKeyDown, write=SetOnKeyDown};
	__property Vcl::Controls::TKeyPressEvent OnKeyPress = {read=GetOnKeyPress, write=SetOnKeyPress};
	__property Vcl::Controls::TKeyEvent OnKeyUp = {read=GetOnKeyUp, write=SetOnKeyUp};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=GetOnMouseDown, write=SetOnMouseDown};
	__property Vcl::Controls::TMouseMoveEvent OnMouseMove = {read=GetOnMouseMove, write=SetOnMouseMove};
	__property Vcl::Controls::TMouseEvent OnMouseUp = {read=GetOnMouseUp, write=SetOnMouseUp};
	__property OnStartDrag;
	__property TOvcPopupEvent OnPopupClose = {read=GetOnPopupClose, write=SetOnPopupClose};
	__property TOvcPopupEvent OnPopupOpen = {read=GetOnPopupOpen, write=SetOnPopupOpen};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBorderedNumberEdit(HWND ParentWindow) : TOvcBorderEdPopup(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word BorderMsgClose = System::Word(0x40a);
static const System::Word BorderMsgOpen = System::Word(0x40b);
}	/* namespace Ovcbcalc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBCALC)
using namespace Ovcbcalc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbcalcHPP

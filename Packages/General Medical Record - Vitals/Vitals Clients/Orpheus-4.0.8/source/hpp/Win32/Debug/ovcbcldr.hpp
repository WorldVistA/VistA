// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbcldr.pas' rev: 29.00 (Windows)

#ifndef OvcbcldrHPP
#define OvcbcldrHPP

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
#include <ovcbordr.hpp>
#include <ovceditf.hpp>
#include <ovcbcalc.hpp>
#include <ovcedcal.hpp>
#include <ovccal.hpp>
#include <System.UITypes.hpp>
#include <ovcedpop.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbcldr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDateEditEx;
class DELPHICLASS TOvcBorderedDateEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDateEditEx : public Ovcedcal::TOvcDateEdit
{
	typedef Ovcedcal::TOvcDateEdit inherited;
	
protected:
	Ovcbcalc::TOvcBorderEdPopup* BorderParent;
public:
	/* TOvcCustomDateEdit.Create */ inline __fastcall virtual TOvcDateEditEx(System::Classes::TComponent* AOwner) : Ovcedcal::TOvcDateEdit(AOwner) { }
	
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcDateEditEx(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDateEditEx(HWND ParentWindow) : Ovcedcal::TOvcDateEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBorderedDateEdit : public Ovcbcalc::TOvcBorderEdPopup
{
	typedef Ovcbcalc::TOvcBorderEdPopup inherited;
	
protected:
	TOvcDateEditEx* FOvcEdit;
	System::Classes::TBiDiMode FBiDiMode;
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
	Ovcbcalc::TOvcPopupAnchor FPopupAnchor;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	bool FReadOnly;
	bool FShowHint;
	System::Uitypes::TTabOrder FTabOrder;
	System::UnicodeString FText;
	bool FVisible;
	int FWidth;
	System::Classes::TNotifyEvent FOnChange;
	System::Classes::TNotifyEvent FOnClick;
	System::Classes::TNotifyEvent FOnDblClick;
	Vcl::Controls::TDragDropEvent FOnDragDrop;
	Vcl::Controls::TDragOverEvent FOnDragOver;
	Vcl::Controls::TEndDragEvent FOnEndDock;
	Vcl::Controls::TStartDockEvent FOnStartDock;
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
	Ovccal::TOvcCalendar* FCalendar;
	System::TDateTime FDate;
	System::UnicodeString FDateText;
	int FEpoch;
	bool FForceCentury;
	Ovcedcal::TOvcRequiredDateFields FRequiredFields;
	System::UnicodeString FTodayString;
	Ovcedcal::TOvcGetDateEvent FOnGetDate;
	Ovcedcal::TOvcGetDateMaskEvent FOnGetDateMask;
	Ovcedcal::TOvcPreParseDateEvent FOnPreParseDate;
	System::Classes::TNotifyEvent FOnSetDate;
	System::Classes::TBiDiMode __fastcall GetBiDiMode(void);
	bool __fastcall GetParentBiDiMode(void);
	System::Uitypes::TDragKind __fastcall GetDragKind(void);
	Vcl::Controls::TEndDragEvent __fastcall GetOnEndDock(void);
	Vcl::Controls::TStartDockEvent __fastcall GetOnStartDock(void);
	virtual void __fastcall SetBiDiMode(System::Classes::TBiDiMode Value);
	virtual void __fastcall SetParentBiDiMode(bool Value);
	void __fastcall SetDragKind(System::Uitypes::TDragKind Value);
	void __fastcall SetOnEndDock(Vcl::Controls::TEndDragEvent Value);
	void __fastcall SetOnStartDock(Vcl::Controls::TStartDockEvent Value);
	HIDESBASE System::UnicodeString __fastcall GetAbout(void);
	bool __fastcall GetAllowIncDec(void);
	bool __fastcall GetAutoSelect(void);
	bool __fastcall GetAutoSize(void);
	System::Uitypes::TEditCharCase __fastcall GetCharCase(void);
	Ovcbase::TOvcController* __fastcall GetController(void);
	System::Uitypes::TCursor __fastcall GetCursor(void);
	System::Uitypes::TCursor __fastcall GetDragCursor(void);
	HIDESBASE System::Uitypes::TDragMode __fastcall GetDragMode(void);
	bool __fastcall GetEditEnabled(void);
	bool __fastcall GetForceCentury(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	bool __fastcall GetHideSelection(void);
	Vcl::Controls::TImeMode __fastcall GetImeMode(void);
	System::UnicodeString __fastcall GetImeName(void);
	int __fastcall GetMaxLength(void);
	bool __fastcall GetOEMConvert(void);
	bool __fastcall GetParentFont(void);
	bool __fastcall GetParentShowHint(void);
	System::WideChar __fastcall GetPasswordChar(void);
	bool __fastcall GetReadOnly(void);
	Ovcedcal::TOvcRequiredDateFields __fastcall GetRequiredFields(void);
	System::UnicodeString __fastcall GetEditText(void);
	bool __fastcall GetEditShowButton(void);
	System::UnicodeString __fastcall GetTodayString(void);
	Ovcedcal::TOvcGetDateEvent __fastcall GetOnGetDate(void);
	Ovcedcal::TOvcGetDateMaskEvent __fastcall GetOnGetDateMask(void);
	Ovcedcal::TOvcPreParseDateEvent __fastcall GetOnPreParseDate(void);
	System::Classes::TNotifyEvent __fastcall GetOnSetDate(void);
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
	Ovcbcalc::TOvcPopupEvent __fastcall GetOnPopupClose(void);
	Ovcbcalc::TOvcPopupEvent __fastcall GetOnPopupOpen(void);
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetAllowIncDec(bool Value);
	void __fastcall SetAutoSelect(bool Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetCharCase(System::Uitypes::TEditCharCase Value);
	void __fastcall SetEditController(Ovcbase::TOvcController* Value);
	HIDESBASE void __fastcall SetCursor(System::Uitypes::TCursor Value);
	void __fastcall SetDragCursor(System::Uitypes::TCursor Value);
	void __fastcall SetEditDragMode(System::Uitypes::TDragMode Value);
	void __fastcall SetEditEnabled(bool Value);
	HIDESBASE void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetForceCentury(bool Value);
	void __fastcall SetHideSelection(bool Value);
	void __fastcall SetImeMode(Vcl::Controls::TImeMode Value);
	void __fastcall SetImeName(const System::UnicodeString Value);
	void __fastcall SetMaxLength(int Value);
	void __fastcall SetOEMConvert(bool Value);
	HIDESBASE void __fastcall SetParentFont(bool Value);
	HIDESBASE void __fastcall SetParentShowHint(bool Value);
	void __fastcall SetPasswordChar(System::WideChar Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetRequiredFields(Ovcedcal::TOvcRequiredDateFields Value);
	void __fastcall SetEditText(const System::UnicodeString Value);
	void __fastcall SetEditShowButton(bool Value);
	void __fastcall SetTodayString(const System::UnicodeString Value);
	void __fastcall SetOnGetDate(Ovcedcal::TOvcGetDateEvent Value);
	void __fastcall SetOnGetDateMask(Ovcedcal::TOvcGetDateMaskEvent Value);
	void __fastcall SetOnPreParseDate(Ovcedcal::TOvcPreParseDateEvent Value);
	void __fastcall SetOnSetDate(System::Classes::TNotifyEvent Value);
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
	void __fastcall SetOnPopupClose(Ovcbcalc::TOvcPopupEvent Value);
	void __fastcall SetOnPopupOpen(Ovcbcalc::TOvcPopupEvent Value);
	System::TDateTime __fastcall GetDate(void);
	int __fastcall GetEpoch(void);
	Ovccal::TOvcCalColors* __fastcall GetPopupColors(void);
	Vcl::Graphics::TFont* __fastcall GetPopupFont(void);
	int __fastcall GetPopupHeight(void);
	Ovccal::TOvcDateFormat __fastcall GetPopupDateFormat(void);
	Ovccal::TOvcDayNameWidth __fastcall GetPopupDayNameWidth(void);
	Ovccal::TOvcCalDisplayOptions __fastcall GetPopupOptions(void);
	Ovccal::TOvcDayType __fastcall GetPopupWeekStarts(void);
	int __fastcall GetPopupWidth(void);
	void __fastcall SetEpoch(int Value);
	void __fastcall SetEditForceCentury(bool Value);
	void __fastcall SetPopupColors(Ovccal::TOvcCalColors* Value);
	void __fastcall SetPopupFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetPopupHeight(int Value);
	void __fastcall SetPopupWidth(int Value);
	void __fastcall SetPopupDateFormat(Ovccal::TOvcDateFormat Value);
	void __fastcall SetPopupDayNameWidth(Ovccal::TOvcDayNameWidth Value);
	void __fastcall SetPopupOptions(Ovccal::TOvcCalDisplayOptions Value);
	void __fastcall SetPopupWeekStarts(Ovccal::TOvcDayType Value);
	DYNAMIC void __fastcall GlyphChanged(void);
	void __fastcall SetDate(System::TDateTime Value);
	
public:
	__fastcall virtual TOvcBorderedDateEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBorderedDateEdit(void);
	System::UnicodeString __fastcall DateString(const System::UnicodeString Mask);
	System::UnicodeString __fastcall FormatDate(System::TDateTime Value);
	void __fastcall SetDateText(const System::UnicodeString Value);
	__property Ovccal::TOvcCalendar* Calendar = {read=FCalendar};
	__property TOvcDateEditEx* EditControl = {read=FOvcEdit};
	
__published:
	__property Anchors = {default=3};
	__property System::Classes::TBiDiMode BiDiMode = {read=GetBiDiMode, write=SetBiDiMode, nodefault};
	__property Constraints;
	__property bool ParentBiDiMode = {read=GetParentBiDiMode, write=SetParentBiDiMode, nodefault};
	__property System::Uitypes::TDragKind DragKind = {read=GetDragKind, write=SetDragKind, nodefault};
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout};
	__property bool AllowIncDec = {read=GetAllowIncDec, write=SetAllowIncDec, nodefault};
	__property bool AutoSelect = {read=GetAutoSelect, write=SetAutoSelect, nodefault};
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, nodefault};
	__property System::Uitypes::TEditCharCase CharCase = {read=GetCharCase, write=SetCharCase, nodefault};
	__property Ovcbase::TOvcController* Controller = {read=GetController, write=SetEditController};
	__property System::Uitypes::TCursor Cursor = {read=GetCursor, write=SetCursor, nodefault};
	__property System::Uitypes::TCursor DragCursor = {read=GetDragCursor, write=SetDragCursor, nodefault};
	__property System::Uitypes::TDragMode DragMode = {read=GetDragMode, write=SetDragMode, nodefault};
	__property int Epoch = {read=GetEpoch, write=SetEpoch, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
	__property bool ForceCentury = {read=GetForceCentury, write=SetEditForceCentury, nodefault};
	__property bool HideSelection = {read=GetHideSelection, write=SetHideSelection, nodefault};
	__property Vcl::Controls::TImeMode ImeMode = {read=GetImeMode, write=SetImeMode, nodefault};
	__property ImeName = {default=0};
	__property bool ParentFont = {read=GetParentFont, write=SetParentFont, nodefault};
	__property bool ParentShowHint = {read=GetParentShowHint, write=SetParentShowHint, nodefault};
	__property Ovcbcalc::TOvcPopupAnchor PopupAnchor = {read=FPopupAnchor, write=FPopupAnchor, nodefault};
	__property Ovccal::TOvcCalColors* PopupColors = {read=GetPopupColors, write=SetPopupColors};
	__property Vcl::Graphics::TFont* PopupFont = {read=GetPopupFont, write=SetPopupFont};
	__property int PopupHeight = {read=GetPopupHeight, write=SetPopupHeight, nodefault};
	__property PopupMenu;
	__property int PopupWidth = {read=GetPopupWidth, write=SetPopupWidth, nodefault};
	__property Ovccal::TOvcDateFormat PopupDateFormat = {read=GetPopupDateFormat, write=SetPopupDateFormat, nodefault};
	__property Ovccal::TOvcDayNameWidth PopupDayNameWidth = {read=GetPopupDayNameWidth, write=SetPopupDayNameWidth, nodefault};
	__property Ovccal::TOvcCalDisplayOptions PopupOptions = {read=GetPopupOptions, write=SetPopupOptions, nodefault};
	__property Ovccal::TOvcDayType PopupWeekStarts = {read=GetPopupWeekStarts, write=SetPopupWeekStarts, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property Ovcedcal::TOvcRequiredDateFields RequiredFields = {read=GetRequiredFields, write=SetRequiredFields, nodefault};
	__property bool ShowButton = {read=GetEditShowButton, write=SetEditShowButton, nodefault};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property System::UnicodeString TodayString = {read=GetTodayString, write=SetTodayString};
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
	__property Ovcedcal::TOvcGetDateEvent OnGetDate = {read=GetOnGetDate, write=SetOnGetDate};
	__property Ovcedcal::TOvcGetDateMaskEvent OnGetDateMask = {read=GetOnGetDateMask, write=SetOnGetDateMask};
	__property Vcl::Controls::TKeyEvent OnKeyDown = {read=GetOnKeyDown, write=SetOnKeyDown};
	__property Vcl::Controls::TKeyPressEvent OnKeyPress = {read=GetOnKeyPress, write=SetOnKeyPress};
	__property Vcl::Controls::TKeyEvent OnKeyUp = {read=GetOnKeyUp, write=SetOnKeyUp};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=GetOnMouseDown, write=SetOnMouseDown};
	__property Vcl::Controls::TMouseMoveEvent OnMouseMove = {read=GetOnMouseMove, write=SetOnMouseMove};
	__property Vcl::Controls::TMouseEvent OnMouseUp = {read=GetOnMouseUp, write=SetOnMouseUp};
	__property Ovcbcalc::TOvcPopupEvent OnPopupClose = {read=GetOnPopupClose, write=SetOnPopupClose};
	__property Ovcbcalc::TOvcPopupEvent OnPopupOpen = {read=GetOnPopupOpen, write=SetOnPopupOpen};
	__property Ovcedcal::TOvcPreParseDateEvent OnPreParseDate = {read=GetOnPreParseDate, write=SetOnPreParseDate};
	__property System::Classes::TNotifyEvent OnSetDate = {read=GetOnSetDate, write=SetOnSetDate};
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBorderedDateEdit(HWND ParentWindow) : Ovcbcalc::TOvcBorderEdPopup(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word BorderMsgClose = System::Word(0x40a);
static const System::Word BorderMsgOpen = System::Word(0x40b);
}	/* namespace Ovcbcldr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBCLDR)
using namespace Ovcbcldr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbcldrHPP

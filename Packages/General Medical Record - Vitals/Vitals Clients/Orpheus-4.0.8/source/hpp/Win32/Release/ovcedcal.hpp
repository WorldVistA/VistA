// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedcal.pas' rev: 29.00 (Windows)

#ifndef OvcedcalHPP
#define OvcedcalHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
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
#include <ovccal.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcedpop.hpp>
#include <ovcexcpt.hpp>
#include <ovcintl.hpp>
#include <ovcmisc.hpp>
#include <ovceditf.hpp>
#include <ovcdate.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedcal
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomDateEdit;
class DELPHICLASS TOvcDateEdit;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcDateOrder : unsigned char { doMDY, doDMY, doYMD };

enum DECLSPEC_DENUM TOvcRequiredDateField : unsigned char { rfYear, rfMonth, rfDay };

typedef System::Set<TOvcRequiredDateField, TOvcRequiredDateField::rfYear, TOvcRequiredDateField::rfDay> TOvcRequiredDateFields;

typedef void __fastcall (__closure *TOvcGetDateEvent)(System::TObject* Sender, System::UnicodeString &Value);

typedef void __fastcall (__closure *TOvcPreParseDateEvent)(System::TObject* Sender, System::UnicodeString &Value);

typedef void __fastcall (__closure *TOvcGetDateMaskEvent)(System::TObject* Sender, System::UnicodeString &Mask);

class PASCALIMPLEMENTATION TOvcCustomDateEdit : public Ovcedpop::TOvcEdPopup
{
	typedef Ovcedpop::TOvcEdPopup inherited;
	
protected:
	bool FAllowIncDec;
	Ovccal::TOvcCalendar* FCalendar;
	System::TDateTime FDate;
	int FEpoch;
	bool FForceCentury;
	TOvcRequiredDateFields FRequiredFields;
	System::UnicodeString FTodayString;
	TOvcGetDateEvent FOnGetDate;
	TOvcGetDateMaskEvent FOnGetDateMask;
	TOvcPreParseDateEvent FOnPreParseDate;
	System::Classes::TNotifyEvent FOnSetDate;
	TOvcDateOrder DateOrder;
	System::Uitypes::TCursor HoldCursor;
	bool PopupClosing;
	bool WasAutoScroll;
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
	HIDESBASE bool __fastcall GetReadOnly(void);
	void __fastcall SetEpoch(int Value);
	void __fastcall SetForceCentury(bool Value);
	void __fastcall SetPopupColors(Ovccal::TOvcCalColors* Value);
	void __fastcall SetPopupFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetPopupHeight(int Value);
	void __fastcall SetPopupWidth(int Value);
	void __fastcall SetPopupDateFormat(Ovccal::TOvcDateFormat Value);
	void __fastcall SetPopupDayNameWidth(Ovccal::TOvcDayNameWidth Value);
	void __fastcall SetPopupOptions(Ovccal::TOvcCalDisplayOptions Value);
	void __fastcall SetPopupWeekStarts(Ovccal::TOvcDayType Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	System::UnicodeString __fastcall ParseDate(const System::UnicodeString Value);
	void __fastcall PopupDateChange(System::TObject* Sender, System::TDateTime Date);
	void __fastcall PopupKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PopupKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall PopupMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall DoExit(void);
	DYNAMIC void __fastcall GlyphChanged(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall SetDate(System::TDateTime Value);
	__property bool AllowIncDec = {read=FAllowIncDec, write=FAllowIncDec, nodefault};
	__property int Epoch = {read=GetEpoch, write=SetEpoch, nodefault};
	__property bool ForceCentury = {read=FForceCentury, write=SetForceCentury, nodefault};
	__property Ovccal::TOvcCalColors* PopupColors = {read=GetPopupColors, write=SetPopupColors};
	__property Vcl::Graphics::TFont* PopupFont = {read=GetPopupFont, write=SetPopupFont};
	__property int PopupHeight = {read=GetPopupHeight, write=SetPopupHeight, nodefault};
	__property int PopupWidth = {read=GetPopupWidth, write=SetPopupWidth, nodefault};
	__property Ovccal::TOvcDateFormat PopupDateFormat = {read=GetPopupDateFormat, write=SetPopupDateFormat, nodefault};
	__property Ovccal::TOvcDayNameWidth PopupDayNameWidth = {read=GetPopupDayNameWidth, write=SetPopupDayNameWidth, nodefault};
	__property Ovccal::TOvcCalDisplayOptions PopupOptions = {read=GetPopupOptions, write=SetPopupOptions, nodefault};
	__property Ovccal::TOvcDayType PopupWeekStarts = {read=GetPopupWeekStarts, write=SetPopupWeekStarts, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property TOvcRequiredDateFields RequiredFields = {read=FRequiredFields, write=FRequiredFields, nodefault};
	__property System::UnicodeString TodayString = {read=FTodayString, write=FTodayString};
	__property TOvcGetDateEvent OnGetDate = {read=FOnGetDate, write=FOnGetDate};
	__property TOvcGetDateMaskEvent OnGetDateMask = {read=FOnGetDateMask, write=FOnGetDateMask};
	__property TOvcPreParseDateEvent OnPreParseDate = {read=FOnPreParseDate, write=FOnPreParseDate};
	__property System::Classes::TNotifyEvent OnSetDate = {read=FOnSetDate, write=FOnSetDate};
	
public:
	__fastcall virtual TOvcCustomDateEdit(System::Classes::TComponent* AOwner);
	System::UnicodeString __fastcall DateString(const System::UnicodeString Mask);
	DYNAMIC System::UnicodeString __fastcall FormatDate(System::TDateTime Value);
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	DYNAMIC void __fastcall SetDateText(System::UnicodeString Value);
	__property Ovccal::TOvcCalendar* Calendar = {read=FCalendar};
	__property System::TDateTime Date = {read=GetDate, write=SetDate};
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcCustomDateEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomDateEdit(HWND ParentWindow) : Ovcedpop::TOvcEdPopup(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDateEdit : public TOvcCustomDateEdit
{
	typedef TOvcCustomDateEdit inherited;
	
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
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Epoch;
	__property Font;
	__property ForceCentury;
	__property HideSelection = {default=1};
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupAnchor;
	__property PopupColors;
	__property PopupDateFormat;
	__property PopupDayNameWidth;
	__property PopupFont;
	__property PopupHeight;
	__property PopupMenu;
	__property PopupOptions;
	__property PopupWidth;
	__property PopupWeekStarts;
	__property ReadOnly;
	__property RequiredFields;
	__property ShowButton;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property TodayString = {default=0};
	__property Visible = {default=1};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnGetDate;
	__property OnGetDateMask;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnPopupClose;
	__property OnPopupOpen;
	__property OnPreParseDate;
	__property OnSetDate;
	__property OnStartDrag;
public:
	/* TOvcCustomDateEdit.Create */ inline __fastcall virtual TOvcDateEdit(System::Classes::TComponent* AOwner) : TOvcCustomDateEdit(AOwner) { }
	
public:
	/* TOvcEdPopup.Destroy */ inline __fastcall virtual ~TOvcDateEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDateEdit(HWND ParentWindow) : TOvcCustomDateEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcedcal */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDCAL)
using namespace Ovcedcal;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedcalHPP

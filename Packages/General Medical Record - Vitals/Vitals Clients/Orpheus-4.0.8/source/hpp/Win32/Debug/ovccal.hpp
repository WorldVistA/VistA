// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccal.pas' rev: 29.00 (Windows)

#ifndef OvccalHPP
#define OvccalHPP

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
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcintl.hpp>
#include <ovcmisc.hpp>
#include <ovcdate.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccal
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCalColors;
class DELPHICLASS TOvcCustomCalendar;
class DELPHICLASS TOvcCalendar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcDateFormat : unsigned char { dfShort, dfLong };

typedef System::Int8 TOvcDayNameWidth;

enum DECLSPEC_DENUM TOvcDayType : unsigned char { dtSunday, dtMonday, dtTuesday, dtWednesday, dtThursday, dtFriday, dtSaturday };

enum DECLSPEC_DENUM TOvcCalDisplayOption : unsigned char { cdoShortNames, cdoShowYear, cdoShowInactive, cdoShowRevert, cdoShowToday, cdoShowNavBtns, cdoHideActive };

typedef System::Set<TOvcCalDisplayOption, TOvcCalDisplayOption::cdoShortNames, TOvcCalDisplayOption::cdoHideActive> TOvcCalDisplayOptions;

typedef System::StaticArray<System::Uitypes::TColor, 6> TOvcCalColorArray;

enum DECLSPEC_DENUM TOvcCalColorScheme : unsigned char { cscalCustom, cscalClassic, cscalWindows, cscalGold, cscalOcean, cscalRose };

typedef System::StaticArray<System::StaticArray<System::Uitypes::TColor, 6>, 6> TOvcCalSchemeArray;

class PASCALIMPLEMENTATION TOvcCalColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	bool FUpdating;
	System::Classes::TNotifyEvent FOnChange;
	bool SettingScheme;
	System::Uitypes::TColor __fastcall GetColor(int Index);
	void __fastcall SetColor(int Index, System::Uitypes::TColor Value);
	void __fastcall SetColorScheme(TOvcCalColorScheme Value);
	void __fastcall DoOnChange(void);
	
public:
	TOvcCalColorArray FCalColors;
	TOvcCalColorScheme FColorScheme;
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
__published:
	__property System::Uitypes::TColor ActiveDay = {read=GetColor, write=SetColor, index=0, nodefault};
	__property TOvcCalColorScheme ColorScheme = {read=FColorScheme, write=SetColorScheme, nodefault};
	__property System::Uitypes::TColor DayNames = {read=GetColor, write=SetColor, index=1, nodefault};
	__property System::Uitypes::TColor Days = {read=GetColor, write=SetColor, index=2, nodefault};
	__property System::Uitypes::TColor InactiveDays = {read=GetColor, write=SetColor, index=3, nodefault};
	__property System::Uitypes::TColor MonthAndYear = {read=GetColor, write=SetColor, index=4, nodefault};
	__property System::Uitypes::TColor Weekend = {read=GetColor, write=SetColor, index=5, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcCalColors(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcCalColors(void) : System::Classes::TPersistent() { }
	
};


typedef void __fastcall (__closure *TDateChangeEvent)(System::TObject* Sender, System::TDateTime Date);

typedef void __fastcall (__closure *TCalendarDateEvent)(System::TObject* Sender, System::TDateTime ADate, const System::Types::TRect &Rect);

typedef void __fastcall (__closure *TGetHighlightEvent)(System::TObject* Sender, System::TDateTime ADate, System::Uitypes::TColor &Color);

typedef void __fastcall (__closure *TGetDateEnabledEvent)(System::TObject* Sender, System::TDateTime ADate, bool &Enabled);

class PASCALIMPLEMENTATION TOvcCustomCalendar : public Ovcbase::TOvcCustomControl
{
	typedef Ovcbase::TOvcCustomControl inherited;
	
protected:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FBrowsing;
	TOvcCalColors* FColors;
	TOvcCalDisplayOptions FOptions;
	System::TDateTime FDate;
	int FDay;
	TOvcDateFormat FDateFormat;
	TOvcDayNameWidth FDayNameWidth;
	bool FDrawHeader;
	Ovcintl::TOvcIntlSup* FIntlSup;
	int FMonth;
	bool FReadOnly;
	bool FWantDblClicks;
	TOvcDayType FWeekStarts;
	int FYear;
	TDateChangeEvent FOnChange;
	TCalendarDateEvent FOnDrawDate;
	TCalendarDateEvent FOnDrawItem;
	TGetDateEnabledEvent FOnGetDateEnabled;
	TGetHighlightEvent FOnGetHighlight;
	Vcl::Buttons::TSpeedButton* clBtnLeft;
	Vcl::Buttons::TSpeedButton* clBtnRevert;
	Vcl::Buttons::TSpeedButton* clBtnRight;
	Vcl::Buttons::TSpeedButton* clBtnToday;
	bool clInPopup;
	Vcl::Buttons::TSpeedButton* clBtnNextYear;
	Vcl::Buttons::TSpeedButton* clBtnPrevYear;
	System::StaticArray<System::Byte, 49> clCalendar;
	System::Word clDay;
	System::Byte clFirst;
	System::Byte clLast;
	System::Word clMonth;
	System::StaticArray<System::StaticArray<System::Types::TRect, 7>, 9> clRowCol;
	bool cSettingScheme;
	System::Word clYear;
	int clWidth;
	System::StaticArray<System::WideChar, 41> clMask;
	bool clPopup;
	System::TDateTime clRevertDate;
	int clRowCount;
	int clStartRow;
	System::TDateTime __fastcall GetAsDateTime(void);
	int __fastcall GetAsStDate(void);
	System::TDateTime __fastcall GetCalendarDate(void);
	int __fastcall GetDay(void);
	int __fastcall GetMonth(void);
	int __fastcall GetYear(void);
	void __fastcall SetAsDateTime(System::TDateTime Value);
	void __fastcall SetAsStDate(int Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetDate(System::TDateTime Value);
	void __fastcall SetDateFormat(TOvcDateFormat Value);
	void __fastcall SetDayNameWidth(TOvcDayNameWidth Value);
	void __fastcall SetDisplayOptions(TOvcCalDisplayOptions Value);
	void __fastcall SetDrawHeader(bool Value);
	void __fastcall SetIntlSupport(Ovcintl::TOvcIntlSup* Value);
	void __fastcall SetWantDblClicks(bool Value);
	void __fastcall SetWeekStarts(TOvcDayType Value);
	void __fastcall calChangeMonth(System::TObject* Sender);
	void __fastcall calColorChange(System::TObject* Sender);
	System::Types::TRect __fastcall calGetCurrentRectangle(void);
	System::TDateTime __fastcall calGetValidDate(System::TDateTime ADate, int Delta);
	void __fastcall calRebuildCalArray(void);
	void __fastcall calRecalcSize(void);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	void __fastcall calBtnClick(System::TObject* Sender);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall DoOnChange(System::TDateTime Value);
	DYNAMIC bool __fastcall DoOnGetDateEnabled(System::TDateTime ADate);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	DYNAMIC bool __fastcall IsReadOnly(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	virtual void __fastcall SetCalendarDate(System::TDateTime Value);
	
public:
	__fastcall virtual TOvcCustomCalendar(System::Classes::TComponent* AOwner);
	__fastcall virtual TOvcCustomCalendar(System::Classes::TComponent* AOwner, bool AsPopup);
	__fastcall virtual ~TOvcCustomCalendar(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	System::UnicodeString __fastcall DateString(const System::UnicodeString Mask);
	System::UnicodeString __fastcall DayString(void);
	void __fastcall IncDay(int Delta);
	void __fastcall IncMonth(int Delta);
	void __fastcall IncYear(int Delta);
	System::UnicodeString __fastcall MonthString(void);
	void __fastcall SetToday(void);
	__property System::TDateTime AsDateTime = {read=GetAsDateTime, write=SetAsDateTime};
	__property int AsStDate = {read=GetAsStDate, write=SetAsStDate, nodefault};
	__property bool Browsing = {read=FBrowsing, nodefault};
	__property Canvas;
	__property int Day = {read=GetDay, nodefault};
	__property int Month = {read=GetMonth, nodefault};
	__property int Year = {read=GetYear, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property System::TDateTime CalendarDate = {read=GetCalendarDate, write=SetCalendarDate};
	__property TOvcCalColors* Colors = {read=FColors, write=FColors};
	__property System::TDateTime Date = {read=FDate, write=SetDate};
	__property TOvcDateFormat DateFormat = {read=FDateFormat, write=SetDateFormat, nodefault};
	__property TOvcDayNameWidth DayNameWidth = {read=FDayNameWidth, write=SetDayNameWidth, nodefault};
	__property bool DrawHeader = {read=FDrawHeader, write=SetDrawHeader, nodefault};
	__property Ovcintl::TOvcIntlSup* IntlSupport = {read=FIntlSup, write=SetIntlSupport};
	__property TOvcCalDisplayOptions Options = {read=FOptions, write=SetDisplayOptions, nodefault};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, nodefault};
	__property bool WantDblClicks = {read=FWantDblClicks, write=SetWantDblClicks, nodefault};
	__property TOvcDayType WeekStarts = {read=FWeekStarts, write=SetWeekStarts, nodefault};
	__property TDateChangeEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TCalendarDateEvent OnDrawDate = {read=FOnDrawDate, write=FOnDrawDate};
	__property TCalendarDateEvent OnDrawItem = {read=FOnDrawItem, write=FOnDrawItem};
	__property TGetDateEnabledEvent OnGetDateEnabled = {read=FOnGetDateEnabled, write=FOnGetDateEnabled};
	__property TGetHighlightEvent OnGetHighlight = {read=FOnGetHighlight, write=FOnGetHighlight};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomCalendar(HWND ParentWindow) : Ovcbase::TOvcCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCalendar : public TOvcCustomCalendar
{
	typedef TOvcCustomCalendar inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Align = {default=0};
	__property BorderStyle;
	__property Colors;
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DateFormat = {default=1};
	__property DayNameWidth;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property LabelInfo;
	__property Options;
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property WantDblClicks = {default=1};
	__property WeekStarts = {default=0};
	__property AfterEnter;
	__property AfterExit;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawDate;
	__property OnDrawItem;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnGetDateEnabled;
	__property OnGetHighlight;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TOvcCustomCalendar.Create */ inline __fastcall virtual TOvcCalendar(System::Classes::TComponent* AOwner) : TOvcCustomCalendar(AOwner) { }
	/* TOvcCustomCalendar.CreateEx */ inline __fastcall virtual TOvcCalendar(System::Classes::TComponent* AOwner, bool AsPopup) : TOvcCustomCalendar(AOwner, AsPopup) { }
	/* TOvcCustomCalendar.Destroy */ inline __fastcall virtual ~TOvcCalendar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCalendar(HWND ParentWindow) : TOvcCustomCalendar(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcCalSchemeArray CalScheme;
}	/* namespace Ovccal */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCAL)
using namespace Ovccal;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccalHPP

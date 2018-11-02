// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcclock.pas' rev: 29.00 (Windows)

#ifndef OvcclockHPP
#define OvcclockHPP

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
#include <Vcl.Dialogs.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <ovcdate.hpp>
#include <o32ledlabel.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcclock
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcLEDClockDisplay;
class DELPHICLASS TOvcDigitalOptions;
class DELPHICLASS TOvcHandOptions;
class DELPHICLASS TOvcCustomClock;
class DELPHICLASS TOvcClock;
//-- type declarations -------------------------------------------------------
typedef System::Int8 TOvcPercent;

enum DECLSPEC_DENUM TOvcClockMode : unsigned char { cmClock, cmTimer, cmCountdownTimer };

enum DECLSPEC_DENUM TOvcClockDisplayMode : unsigned char { dmAnalog, dmDigital };

class PASCALIMPLEMENTATION TOvcLEDClockDisplay : public O32ledlabel::TO32CustomLEDLabel
{
	typedef O32ledlabel::TO32CustomLEDLabel inherited;
	
public:
	void __fastcall PaintSelf(void);
public:
	/* TO32CustomLEDLabel.Create */ inline __fastcall virtual TOvcLEDClockDisplay(System::Classes::TComponent* AOwner) : O32ledlabel::TO32CustomLEDLabel(AOwner) { }
	/* TO32CustomLEDLabel.Destroy */ inline __fastcall virtual ~TOvcLEDClockDisplay(void) { }
	
};


class PASCALIMPLEMENTATION TOvcDigitalOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Classes::TComponent* FOwner;
	System::Uitypes::TColor FOnColor;
	System::Uitypes::TColor FOffColor;
	System::Uitypes::TColor FBgColor;
	O32ledlabel::TSegmentSize FSize;
	bool FShowSeconds;
	bool FFlashColon;
	System::Classes::TNotifyEvent FOnChange;
	bool F24Hour;
	void __fastcall Set24Hour(bool Value);
	void __fastcall SetOnColor(System::Uitypes::TColor Value);
	void __fastcall SetOffColor(System::Uitypes::TColor Value);
	void __fastcall SetBgColor(System::Uitypes::TColor Value);
	void __fastcall SetSize(O32ledlabel::TSegmentSize Value);
	void __fastcall SetShowSeconds(bool Value);
	void __fastcall DoOnChange(void);
	
public:
	__fastcall TOvcDigitalOptions(void);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
__published:
	__property bool MilitaryTime = {read=F24Hour, write=Set24Hour, nodefault};
	__property System::Uitypes::TColor OnColor = {read=FOnColor, write=SetOnColor, nodefault};
	__property System::Uitypes::TColor OffColor = {read=FOffColor, write=SetOffColor, nodefault};
	__property System::Uitypes::TColor BgColor = {read=FBgColor, write=SetBgColor, nodefault};
	__property O32ledlabel::TSegmentSize Size = {read=FSize, write=SetSize, nodefault};
	__property bool ShowSeconds = {read=FShowSeconds, write=SetShowSeconds, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcDigitalOptions(void) { }
	
};


class PASCALIMPLEMENTATION TOvcHandOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Uitypes::TColor FHourHandColor;
	TOvcPercent FHourHandLength;
	int FHourHandWidth;
	System::Uitypes::TColor FMinuteHandColor;
	TOvcPercent FMinuteHandLength;
	int FMinuteHandWidth;
	System::Uitypes::TColor FSecondHandColor;
	TOvcPercent FSecondHandLength;
	int FSecondHandWidth;
	bool FShowSecondHand;
	bool FSolidHands;
	System::Classes::TNotifyEvent FOnChange;
	void __fastcall SetHourHandColor(System::Uitypes::TColor Value);
	void __fastcall SetHourHandLength(TOvcPercent Value);
	void __fastcall SetHourHandWidth(int Value);
	void __fastcall SetMinuteHandColor(System::Uitypes::TColor Value);
	void __fastcall SetMinuteHandLength(TOvcPercent Value);
	void __fastcall SetMinuteHandWidth(int Value);
	void __fastcall SetSecondHandColor(System::Uitypes::TColor Value);
	void __fastcall SetSecondHandLength(TOvcPercent Value);
	void __fastcall SetSecondHandWidth(int Value);
	void __fastcall SetShowSecondHand(bool Value);
	void __fastcall SetSolidHands(bool Value);
	void __fastcall DoOnChange(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
__published:
	__property System::Uitypes::TColor HourHandColor = {read=FHourHandColor, write=SetHourHandColor, nodefault};
	__property TOvcPercent HourHandLength = {read=FHourHandLength, write=SetHourHandLength, nodefault};
	__property int HourHandWidth = {read=FHourHandWidth, write=SetHourHandWidth, nodefault};
	__property System::Uitypes::TColor MinuteHandColor = {read=FMinuteHandColor, write=SetMinuteHandColor, nodefault};
	__property TOvcPercent MinuteHandLength = {read=FMinuteHandLength, write=SetMinuteHandLength, nodefault};
	__property int MinuteHandWidth = {read=FMinuteHandWidth, write=SetMinuteHandWidth, nodefault};
	__property System::Uitypes::TColor SecondHandColor = {read=FSecondHandColor, write=SetSecondHandColor, nodefault};
	__property TOvcPercent SecondHandLength = {read=FSecondHandLength, write=SetSecondHandLength, nodefault};
	__property int SecondHandWidth = {read=FSecondHandWidth, write=SetSecondHandWidth, nodefault};
	__property bool ShowSecondHand = {read=FShowSecondHand, write=SetShowSecondHand, nodefault};
	__property bool SolidHands = {read=FSolidHands, write=SetSolidHands, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcHandOptions(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcHandOptions(void) : System::Classes::TPersistent() { }
	
};


class PASCALIMPLEMENTATION TOvcCustomClock : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	bool FActive;
	Vcl::Graphics::TBitmap* FClockFace;
	TOvcClockMode FClockMode;
	TOvcDigitalOptions* FDigitalOptions;
	TOvcClockDisplayMode FDisplayMode;
	bool FDrawMarks;
	int FElapsedDays;
	int FElapsedHours;
	int FElapsedMinutes;
	int FElapsedSeconds;
	TOvcHandOptions* FHandOptions;
	System::TDateTime FTime;
	bool FMilitaryTime;
	System::TDateTime FStartTime;
	int FHourOffset;
	int FMinuteOffset;
	int FSecondOffset;
	System::Classes::TNotifyEvent FOnHourChange;
	System::Classes::TNotifyEvent FOnMinuteChange;
	System::Classes::TNotifyEvent FOnSecondChange;
	System::Classes::TNotifyEvent FOnCountdownDone;
	int ckAnalogHeight;
	int ckAnalogWidth;
	TOvcLEDClockDisplay* ckLEDDisplay;
	Vcl::Graphics::TBitmap* ckDraw;
	int ckClockHandle;
	int ckOldHour;
	int ckOldMinute;
	int ckOldSecond;
	System::TDateTime ckTimerTime;
	int ckDays;
	int ckHours;
	int ckMinutes;
	int ckSeconds;
	int ckTotalSeconds;
	int __fastcall GetElapsedDays(void);
	int __fastcall GetElapsedHours(void);
	int __fastcall GetElapsedMinutes(void);
	int __fastcall GetElapsedSeconds(void);
	int __fastcall GetElapsedSecondsTotal(void);
	void __fastcall SetActive(bool Value);
	void __fastcall SetClockFace(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetClockMode(TOvcClockMode Value);
	void __fastcall SetDisplayMode(TOvcClockDisplayMode Value);
	void __fastcall SetDrawMarks(bool Value);
	void __fastcall SetMinuteOffset(int Value);
	void __fastcall SetHourOffset(int Value);
	void __fastcall SetSecondOffset(int Value);
	System::TDateTime __fastcall ckConvertMsToDateTime(int Value);
	void __fastcall ckHandOptionChange(System::TObject* Sender);
	void __fastcall ckDigitalOptionChange(System::TObject* Sender);
	void __fastcall SizeDigitalDisplay(void);
	void __fastcall ckTimerEvent(System::TObject* Sender, int Handle, unsigned Interval, int ElapsedTime);
	void __fastcall DoOnHourChange(void);
	void __fastcall DoOnMinuteChange(void);
	void __fastcall DoOnSecondChange(void);
	void __fastcall DoOnCountdownDone(void);
	void __fastcall PaintHands(Vcl::Graphics::TCanvas* ACanvas);
	MESSAGE void __fastcall WMResize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
	void __fastcall PaintAnalog(void);
	void __fastcall PaintDigital(void);
	virtual void __fastcall SetTime(System::TDateTime Value);
	__property bool Active = {read=FActive, write=SetActive, nodefault};
	__property Vcl::Graphics::TBitmap* ClockFace = {read=FClockFace, write=SetClockFace};
	__property TOvcClockMode ClockMode = {read=FClockMode, write=SetClockMode, nodefault};
	__property TOvcDigitalOptions* DigitalOptions = {read=FDigitalOptions, write=FDigitalOptions};
	__property bool DrawMarks = {read=FDrawMarks, write=SetDrawMarks, nodefault};
	__property TOvcHandOptions* HandOptions = {read=FHandOptions, write=FHandOptions};
	__property int MinuteOffset = {read=FMinuteOffset, write=SetMinuteOffset, nodefault};
	__property int TimeOffset = {read=FHourOffset, write=SetHourOffset, nodefault};
	__property int HourOffset = {read=FHourOffset, write=SetHourOffset, nodefault};
	__property int SecondOffset = {read=FSecondOffset, write=SetSecondOffset, nodefault};
	__property System::Classes::TNotifyEvent OnHourChange = {read=FOnHourChange, write=FOnHourChange};
	__property System::Classes::TNotifyEvent OnMinuteChange = {read=FOnMinuteChange, write=FOnMinuteChange};
	__property System::Classes::TNotifyEvent OnSecondChange = {read=FOnSecondChange, write=FOnSecondChange};
	__property System::Classes::TNotifyEvent OnCountdownDone = {read=FOnCountdownDone, write=FOnCountdownDone};
	
public:
	__fastcall virtual TOvcCustomClock(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomClock(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property TOvcClockDisplayMode DisplayMode = {read=FDisplayMode, write=SetDisplayMode, nodefault};
	__property int ElapsedDays = {read=GetElapsedDays, nodefault};
	__property int ElapsedHours = {read=GetElapsedHours, nodefault};
	__property int ElapsedMinutes = {read=GetElapsedMinutes, nodefault};
	__property int ElapsedSeconds = {read=GetElapsedSeconds, nodefault};
	__property int ElapsedSecondsTotal = {read=GetElapsedSecondsTotal, nodefault};
	__property System::TDateTime Time = {read=FTime, write=SetTime};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomClock(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcClock : public TOvcCustomClock
{
	typedef TOvcCustomClock inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property About = {default=0};
	__property Active;
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property ClockFace;
	__property ClockMode;
	__property DigitalOptions;
	__property DisplayMode;
	__property DrawMarks = {default=1};
	__property Hint = {default=0};
	__property HandOptions;
	__property LabelInfo;
	__property MinuteOffset = {default=0};
	__property ParentColor = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property SecondOffset = {default=0};
	__property ShowHint;
	__property TimeOffset = {default=0};
	__property HourOffset = {default=0};
	__property Visible = {default=1};
	__property OnClick;
	__property OnCountdownDone;
	__property OnDblClick;
	__property OnHourChange;
	__property OnMinuteChange;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnSecondChange;
public:
	/* TOvcCustomClock.Create */ inline __fastcall virtual TOvcClock(System::Classes::TComponent* AOwner) : TOvcCustomClock(AOwner) { }
	/* TOvcCustomClock.Destroy */ inline __fastcall virtual ~TOvcClock(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcClock(HWND ParentWindow) : TOvcCustomClock(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcclock */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCLOCK)
using namespace Ovcclock;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcclockHPP

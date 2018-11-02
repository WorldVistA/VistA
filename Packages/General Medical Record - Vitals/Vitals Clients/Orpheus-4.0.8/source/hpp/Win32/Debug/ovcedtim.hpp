// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedtim.pas' rev: 29.00 (Windows)

#ifndef OvcedtimHPP
#define OvcedtimHPP

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
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcintl.hpp>
#include <ovcmisc.hpp>
#include <ovceditf.hpp>
#include <ovcdate.hpp>
#include <System.UITypes.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedtim
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomTimeEdit;
class DELPHICLASS TOvcTimeEdit;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcTimeField : unsigned char { tfHours, tfMinutes, tfSeconds };

enum DECLSPEC_DENUM TOvcTimeMode : unsigned char { tmClock, tmDuration };

enum DECLSPEC_DENUM TOvcDurationDisplay : unsigned char { ddHMS, ddHM, ddMS, ddHHH, ddMMM, ddSSS };

typedef void __fastcall (__closure *TOvcGetTimeEvent)(System::TObject* Sender, System::UnicodeString &Value);

typedef void __fastcall (__closure *TOvcPreParseTimeEvent)(System::TObject* Sender, System::UnicodeString &Value);

class PASCALIMPLEMENTATION TOvcCustomTimeEdit : public Ovceditf::TOvcCustomEdit
{
	typedef Ovceditf::TOvcCustomEdit inherited;
	
protected:
	TOvcDurationDisplay FDurationDisplay;
	System::UnicodeString FNowString;
	bool FDefaultToPM;
	TOvcTimeField FPrimaryField;
	bool FShowSeconds;
	bool FShowUnits;
	System::TDateTime FTime;
	TOvcTimeMode FTimeMode;
	int FUnitsLength;
	TOvcGetTimeEvent FOnGetTime;
	TOvcPreParseTimeEvent FOnPreParseTime;
	System::Classes::TNotifyEvent FOnSetTime;
	int __fastcall GetAsHours(void);
	int __fastcall GetAsMinutes(void);
	int __fastcall GetAsSeconds(void);
	System::TDateTime __fastcall GetTime(void);
	void __fastcall SetAsHours(int Value);
	void __fastcall SetAsMinutes(int Value);
	void __fastcall SetAsSeconds(int Value);
	void __fastcall SetDurationDisplay(TOvcDurationDisplay Value);
	void __fastcall SetShowSeconds(bool Value);
	void __fastcall SetShowUnits(bool Value);
	void __fastcall SetTimeMode(TOvcTimeMode Value);
	void __fastcall SetUnitsLength(int Value);
	void __fastcall ParseFields(const System::UnicodeString Value, System::Classes::TStringList* S);
	DYNAMIC void __fastcall DoExit(void);
	void __fastcall SetTime(System::TDateTime Value);
	DYNAMIC void __fastcall SetTimeText(System::UnicodeString Value);
	__property bool DefaultToPM = {read=FDefaultToPM, write=FDefaultToPM, nodefault};
	__property TOvcDurationDisplay DurationDisplay = {read=FDurationDisplay, write=SetDurationDisplay, nodefault};
	__property System::UnicodeString NowString = {read=FNowString, write=FNowString};
	__property TOvcTimeField PrimaryField = {read=FPrimaryField, write=FPrimaryField, nodefault};
	__property bool ShowSeconds = {read=FShowSeconds, write=SetShowSeconds, nodefault};
	__property bool ShowUnits = {read=FShowUnits, write=SetShowUnits, nodefault};
	__property TOvcTimeMode TimeMode = {read=FTimeMode, write=SetTimeMode, nodefault};
	__property int UnitsLength = {read=FUnitsLength, write=SetUnitsLength, nodefault};
	__property TOvcGetTimeEvent OnGetTime = {read=FOnGetTime, write=FOnGetTime};
	__property TOvcPreParseTimeEvent OnPreParseTime = {read=FOnPreParseTime, write=FOnPreParseTime};
	__property System::Classes::TNotifyEvent OnSetTime = {read=FOnSetTime, write=FOnSetTime};
	
public:
	__fastcall virtual TOvcCustomTimeEdit(System::Classes::TComponent* AOwner);
	DYNAMIC System::UnicodeString __fastcall FormatTime(System::TDateTime Value);
	__property System::TDateTime AsDateTime = {read=GetTime, write=SetTime};
	__property int AsHours = {read=GetAsHours, write=SetAsHours, nodefault};
	__property int AsMinutes = {read=GetAsMinutes, write=SetAsMinutes, nodefault};
	__property int AsSeconds = {read=GetAsSeconds, write=SetAsSeconds, nodefault};
public:
	/* TOvcCustomEdit.Destroy */ inline __fastcall virtual ~TOvcCustomTimeEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomTimeEdit(HWND ParentWindow) : Ovceditf::TOvcCustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTimeEdit : public TOvcCustomTimeEdit
{
	typedef TOvcCustomTimeEdit inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DefaultToPM;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DurationDisplay;
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property LabelInfo;
	__property MaxLength = {default=0};
	__property NowString = {default=0};
	__property OEMConvert = {default=0};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property PrimaryField;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property ShowSeconds;
	__property ShowUnits;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property TimeMode;
	__property UnitsLength;
	__property Visible = {default=1};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnGetTime;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnPreParseTime;
	__property OnSetTime;
	__property OnStartDrag;
public:
	/* TOvcCustomTimeEdit.Create */ inline __fastcall virtual TOvcTimeEdit(System::Classes::TComponent* AOwner) : TOvcCustomTimeEdit(AOwner) { }
	
public:
	/* TOvcCustomEdit.Destroy */ inline __fastcall virtual ~TOvcTimeEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTimeEdit(HWND ParentWindow) : TOvcCustomTimeEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcedtim */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDTIM)
using namespace Ovcedtim;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcedtimHPP

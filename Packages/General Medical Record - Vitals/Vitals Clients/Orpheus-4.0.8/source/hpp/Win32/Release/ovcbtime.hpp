// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbtime.pas' rev: 29.00 (Windows)

#ifndef OvcbtimeHPP
#define OvcbtimeHPP

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
#include <ovceditf.hpp>
#include <ovcbordr.hpp>
#include <ovcbcalc.hpp>
#include <ovcedtim.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbtime
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTimeEditEx;
class DELPHICLASS TOvcBorderedTimeEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTimeEditEx : public Ovcedtim::TOvcTimeEdit
{
	typedef Ovcedtim::TOvcTimeEdit inherited;
	
protected:
	Ovcbcalc::TOvcBorderEdPopup* BorderParent;
public:
	/* TOvcCustomTimeEdit.Create */ inline __fastcall virtual TOvcTimeEditEx(System::Classes::TComponent* AOwner) : Ovcedtim::TOvcTimeEdit(AOwner) { }
	
public:
	/* TOvcCustomEdit.Destroy */ inline __fastcall virtual ~TOvcTimeEditEx(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTimeEditEx(HWND ParentWindow) : Ovcedtim::TOvcTimeEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBorderedTimeEdit : public Ovcbordr::TOvcBorderParent
{
	typedef Ovcbordr::TOvcBorderParent inherited;
	
protected:
	TOvcTimeEditEx* FOvcEdit;
	int FAsHours;
	int FAsMinutes;
	int FAsSeconds;
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
	Ovcedtim::TOvcDurationDisplay FDurationDisplay;
	System::UnicodeString FNowString;
	bool FDefaultToPM;
	Ovcedtim::TOvcTimeField FPrimaryField;
	bool FShowSeconds;
	bool FShowUnits;
	System::TDateTime FTime;
	Ovcedtim::TOvcTimeMode FTimeMode;
	int FUnitsLength;
	Ovcedtim::TOvcGetTimeEvent FOnGetTime;
	Ovcedtim::TOvcPreParseTimeEvent FOnPreParseTime;
	System::Classes::TNotifyEvent FOnSetTime;
	System::Classes::TBiDiMode __fastcall GetBiDiMode(void);
	bool __fastcall GetParentBiDiMode(void);
	System::Uitypes::TDragKind __fastcall GetDragKind(void);
	virtual void __fastcall SetBiDiMode(System::Classes::TBiDiMode Value);
	virtual void __fastcall SetParentBiDiMode(bool Value);
	void __fastcall SetDragKind(System::Uitypes::TDragKind Value);
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
	System::UnicodeString __fastcall GetEditText(void);
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
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetAutoSelect(bool Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetCharCase(System::Uitypes::TEditCharCase Value);
	void __fastcall SetEditController(Ovcbase::TOvcController* Value);
	HIDESBASE void __fastcall SetCursor(System::Uitypes::TCursor Value);
	void __fastcall SetDragCursor(System::Uitypes::TCursor Value);
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
	void __fastcall SetEditText(const System::UnicodeString Value);
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
	int __fastcall GetAsHours(void);
	int __fastcall GetAsMinutes(void);
	int __fastcall GetAsSeconds(void);
	bool __fastcall GetDefaultToPM(void);
	Ovcedtim::TOvcDurationDisplay __fastcall GetDurationDisplay(void);
	System::UnicodeString __fastcall GetNowString(void);
	Ovcedtim::TOvcTimeField __fastcall GetPrimaryField(void);
	bool __fastcall GetShowSeconds(void);
	bool __fastcall GetShowUnits(void);
	System::TDateTime __fastcall GetTime(void);
	Ovcedtim::TOvcTimeMode __fastcall GetTimeMode(void);
	int __fastcall GetUnitsLength(void);
	Ovcedtim::TOvcGetTimeEvent __fastcall GetOnGetTime(void);
	Ovcedtim::TOvcPreParseTimeEvent __fastcall GetOnPreParseTime(void);
	System::Classes::TNotifyEvent __fastcall GetOnSetTime(void);
	void __fastcall SetAsHours(int Value);
	void __fastcall SetAsMinutes(int Value);
	void __fastcall SetAsSeconds(int Value);
	void __fastcall SetDefaultToPM(bool Value);
	void __fastcall SetDurationDisplay(Ovcedtim::TOvcDurationDisplay Value);
	void __fastcall SetNowString(const System::UnicodeString Value);
	void __fastcall SetPrimaryField(Ovcedtim::TOvcTimeField Value);
	void __fastcall SetShowSeconds(bool Value);
	void __fastcall SetShowUnits(bool Value);
	void __fastcall SetTime(System::TDateTime Value);
	void __fastcall SetTimeMode(Ovcedtim::TOvcTimeMode Value);
	void __fastcall SetUnitsLength(int Value);
	void __fastcall SetOnGetTime(Ovcedtim::TOvcGetTimeEvent Value);
	void __fastcall SetOnPreParseTime(Ovcedtim::TOvcPreParseTimeEvent Value);
	void __fastcall SetOnSetTime(System::Classes::TNotifyEvent Value);
	
public:
	__fastcall virtual TOvcBorderedTimeEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBorderedTimeEdit(void);
	__property System::TDateTime AsDateTime = {read=GetTime, write=SetTime};
	__property int AsHours = {read=GetAsHours, write=SetAsHours, nodefault};
	__property int AsMinutes = {read=GetAsMinutes, write=SetAsMinutes, nodefault};
	__property int AsSeconds = {read=GetAsSeconds, write=SetAsSeconds, nodefault};
	__property TOvcTimeEditEx* EditControl = {read=FOvcEdit};
	
__published:
	__property bool DefaultToPM = {read=GetDefaultToPM, write=SetDefaultToPM, nodefault};
	__property Ovcedtim::TOvcDurationDisplay DurationDisplay = {read=GetDurationDisplay, write=SetDurationDisplay, nodefault};
	__property System::UnicodeString NowString = {read=GetNowString, write=SetNowString};
	__property Ovcedtim::TOvcTimeField PrimaryField = {read=GetPrimaryField, write=SetPrimaryField, nodefault};
	__property bool ShowSeconds = {read=GetShowSeconds, write=SetShowSeconds, nodefault};
	__property bool ShowUnits = {read=GetShowUnits, write=SetShowUnits, nodefault};
	__property Ovcedtim::TOvcTimeMode TimeMode = {read=GetTimeMode, write=SetTimeMode, nodefault};
	__property int UnitsLength = {read=GetUnitsLength, write=SetUnitsLength, nodefault};
	__property Ovcedtim::TOvcGetTimeEvent OnGetTime = {read=GetOnGetTime, write=SetOnGetTime};
	__property Ovcedtim::TOvcPreParseTimeEvent OnPreParseTime = {read=GetOnPreParseTime, write=SetOnPreParseTime};
	__property System::Classes::TNotifyEvent OnSetTime = {read=GetOnSetTime, write=SetOnSetTime};
	__property Anchors = {default=3};
	__property System::Classes::TBiDiMode BiDiMode = {read=GetBiDiMode, write=SetBiDiMode, nodefault};
	__property bool ParentBiDiMode = {read=GetParentBiDiMode, write=SetParentBiDiMode, nodefault};
	__property Constraints;
	__property System::Uitypes::TDragKind DragKind = {read=GetDragKind, write=SetDragKind, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, nodefault};
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout};
	__property bool AutoSelect = {read=GetAutoSelect, write=SetAutoSelect, nodefault};
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
	__property bool ParentShowHint = {read=GetParentShowHint, write=SetParentShowHint, nodefault};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, nodefault};
	__property PopupMenu;
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
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBorderedTimeEdit(HWND ParentWindow) : Ovcbordr::TOvcBorderParent(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word BorderMsgClose = System::Word(0x414);
static const System::Word BorderMsgOpen = System::Word(0x415);
}	/* namespace Ovcbtime */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBTIME)
using namespace Ovcbtime;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbtimeHPP

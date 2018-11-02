// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccalc.pas' rev: 29.00 (Windows)

#ifndef OvccalcHPP
#define OvccalcHPP

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
#include <Vcl.Clipbrd.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcdata.hpp>
#include <ovcconst.hpp>
#include <ovcbase.hpp>
#include <ovcmisc.hpp>
#include <Vcl.Themes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccalc
{
//-- forward type declarations -----------------------------------------------
struct TOvcButtonInfo;
class DELPHICLASS TOvcCalcColors;
class DELPHICLASS TOvcCalcPanel;
class DELPHICLASS TOvcCustomCalculatorEngine;
class DELPHICLASS TOvcCalcTape;
class DELPHICLASS TOvcCustomCalculator;
class DELPHICLASS TOvcCalculator;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcCalculatorButton : unsigned char { cbNone, cbTape, cbBack, cbClearEntry, cbClear, cbAdd, cbSub, cbMul, cbDiv, cb0, cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8, cb9, cbDecimal, cbEqual, cbInvert, cbChangeSign, cbPercent, cbSqrt, cbMemClear, cbMemRecall, cbMemStore, cbMemAdd, cbMemSub, cbSubTotal };

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcButtonInfo
{
public:
	System::Types::TRect Position;
	System::UnicodeString Caption;
	bool Visible;
};
#pragma pack(pop)


typedef System::StaticArray<TOvcButtonInfo, 29> TOvcButtonArray;

enum DECLSPEC_DENUM TOvcCalculatorOperation : unsigned char { coNone, coAdd, coSub, coMul, coDiv, coEqual, coInvert, coPercent, coSqrt, coMemClear, coMemRecall, coMemStore, coMemAdd, coMemSub, coSubTotal };

enum DECLSPEC_DENUM TOvcCalcState : unsigned char { csValid, csLocked, csClear };

typedef System::Set<TOvcCalcState, TOvcCalcState::csValid, TOvcCalcState::csClear> TOvcCalcStates;

typedef System::StaticArray<System::Uitypes::TColor, 8> TOvcCalcColorArray;

enum DECLSPEC_DENUM TOvcCalcColorScheme : unsigned char { cscalcCustom, cscalcWindows, cscalcDark, cscalcOcean, cscalcPlain };

typedef System::StaticArray<System::StaticArray<System::Uitypes::TColor, 8>, 5> TOvcCalcSchemeArray;

typedef System::StaticArray<System::UnicodeString, 31> TOvcCalcDisplayString;

typedef System::StaticArray<TOvcCalculatorOperation, 31> TOvcCalcButtonToOperation;

class PASCALIMPLEMENTATION TOvcCalcColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FUpdating;
	System::Classes::TNotifyEvent FOnChange;
	bool SettingScheme;
	void __fastcall DoOnChange(void);
	System::Uitypes::TColor __fastcall GetColor(const int Index);
	System::Uitypes::TColor __fastcall GetDisplayTextColor(void);
	void __fastcall SetColor(const int Index, const System::Uitypes::TColor Value);
	void __fastcall SetColorScheme(const TOvcCalcColorScheme Value);
	void __fastcall SetDisplayTextColor(const System::Uitypes::TColor Value);
	
public:
	TOvcCalcColorArray FCalcColors;
	TOvcCalcColorScheme FColorScheme;
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(void);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
__published:
	__property TOvcCalcColorScheme ColorScheme = {read=FColorScheme, write=SetColorScheme, nodefault};
	__property System::Uitypes::TColor DisabledMemoryButtons = {read=GetColor, write=SetColor, index=0, nodefault};
	__property System::Uitypes::TColor Display = {read=GetColor, write=SetColor, index=1, nodefault};
	__property System::Uitypes::TColor DisplayTextColor = {read=GetDisplayTextColor, write=SetDisplayTextColor, nodefault};
	__property System::Uitypes::TColor EditButtons = {read=GetColor, write=SetColor, index=3, nodefault};
	__property System::Uitypes::TColor FunctionButtons = {read=GetColor, write=SetColor, index=4, nodefault};
	__property System::Uitypes::TColor MemoryButtons = {read=GetColor, write=SetColor, index=5, nodefault};
	__property System::Uitypes::TColor NumberButtons = {read=GetColor, write=SetColor, index=6, nodefault};
	__property System::Uitypes::TColor OperatorButtons = {read=GetColor, write=SetColor, index=7, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcCalcColors(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TOvcCalcColors(void) : System::Classes::TPersistent() { }
	
};


class PASCALIMPLEMENTATION TOvcCalcPanel : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
protected:
	DYNAMIC void __fastcall Click(void);
public:
	/* TCustomPanel.Create */ inline __fastcall virtual TOvcCalcPanel(System::Classes::TComponent* AOwner) : Vcl::Extctrls::TPanel(AOwner) { }
	
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TOvcCalcPanel(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCalcPanel(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCustomCalculatorEngine : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FDecimals;
	bool FShowSeparatePercent;
	System::Extended cCalculated;
	TOvcCalculatorOperation cLastOperation;
	int cOperationCount;
	System::Extended cMemory;
	System::StaticArray<System::Extended, 4> cOperands;
	TOvcCalcStates cState;
	
public:
	virtual bool __fastcall AddOperand(const System::Extended Value, const TOvcCalculatorOperation Button) = 0 ;
	virtual bool __fastcall AddOperation(const TOvcCalculatorOperation Button) = 0 ;
	void __fastcall ClearAll(void);
	void __fastcall PushOperand(const System::Extended Value);
	System::Extended __fastcall PopOperand(void);
	System::Extended __fastcall TopOperand(void);
	__property int Decimals = {read=FDecimals, write=FDecimals, nodefault};
	__property TOvcCalculatorOperation LastOperation = {read=cLastOperation, write=cLastOperation, nodefault};
	__property System::Extended Memory = {read=cMemory, write=cMemory};
	__property int OperationCount = {read=cOperationCount, write=cOperationCount, nodefault};
	__property bool ShowSeparatePercent = {read=FShowSeparatePercent, write=FShowSeparatePercent, nodefault};
	__property TOvcCalcStates State = {read=cState, write=cState, nodefault};
public:
	/* TObject.Create */ inline __fastcall TOvcCustomCalculatorEngine(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TOvcCustomCalculatorEngine(void) { }
	
};


class PASCALIMPLEMENTATION TOvcCalcTape : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FMaxPaperCount;
	bool FShowTape;
	int FTapeDisplaySpace;
	bool FVisible;
	Vcl::Stdctrls::TListBox* taListBox;
	System::Uitypes::TColor taTapeColor;
	int taHeight;
	System::Classes::TComponent* taOwner;
	int taOperandSize;
	Vcl::Graphics::TFont* taFont;
	int taMaxTapeCount;
	bool taTapeInitialized;
	int taWidth;
	void __fastcall ValidateListBox(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	void __fastcall SetFont(Vcl::Graphics::TFont* const Value);
	int __fastcall GetHeight(void);
	void __fastcall SetHeight(const int Value);
	System::Classes::TStrings* __fastcall GetTape(void);
	void __fastcall SetTape(System::Classes::TStrings* const Value);
	System::Uitypes::TColor __fastcall GetTapeColor(void);
	void __fastcall SetTapeColor(const System::Uitypes::TColor Value);
	int __fastcall GetTop(void);
	void __fastcall SetTop(const int Value);
	int __fastcall GetTopIndex(void);
	void __fastcall SetTopIndex(const int Value);
	bool __fastcall GetVisible(void);
	void __fastcall SetVisible(const bool Value);
	int __fastcall GetWidth(void);
	void __fastcall SetWidth(const int Value);
	void __fastcall Add(const System::UnicodeString Value);
	void __fastcall DeleteFirst(void);
	void __fastcall taOnClick(System::TObject* Sender);
	void __fastcall taOnDblClick(System::TObject* Sender);
	void __fastcall taOnDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall taTapeFontChange(System::TObject* Sender);
	
public:
	__fastcall TOvcCalcTape(System::Classes::TComponent* const AOwner, const int AOperandSize);
	__fastcall virtual ~TOvcCalcTape(void);
	void __fastcall InitializeTape(void);
	void __fastcall SetBounds(const int ALeft, const int ATop, const int AWidth, const int AHeight);
	int __fastcall GetDisplayedItemCount(void);
	void __fastcall AddToTape(const System::UnicodeString Value, const System::UnicodeString OpString);
	void __fastcall AddToTapeLeft(const System::UnicodeString Value);
	void __fastcall ClearTape(void);
	void __fastcall RefreshDisplays(void);
	void __fastcall SpaceTape(const System::WideChar Value);
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
	__property int Height = {read=GetHeight, write=SetHeight, nodefault};
	__property int MaxPaperCount = {read=FMaxPaperCount, write=FMaxPaperCount, nodefault};
	__property bool ShowTape = {read=FShowTape, write=FShowTape, nodefault};
	__property System::Classes::TStrings* Tape = {read=GetTape, write=SetTape};
	__property System::Uitypes::TColor TapeColor = {read=GetTapeColor, write=SetTapeColor, nodefault};
	__property int TapeDisplaySpace = {read=FTapeDisplaySpace, write=FTapeDisplaySpace, nodefault};
	__property int Top = {read=GetTop, write=SetTop, nodefault};
	__property int TopIndex = {read=GetTopIndex, write=SetTopIndex, nodefault};
	__property bool Visible = {read=GetVisible, write=SetVisible, nodefault};
	__property int Width = {read=GetWidth, write=SetWidth, nodefault};
};


typedef void __fastcall (__closure *TOvcCalcButtonPressedEvent)(System::TObject* Sender, TOvcCalculatorButton Button);

enum DECLSPEC_DENUM TOvcCalculatorOption : unsigned char { coShowItemCount, coShowMemoryButtons, coShowClearTapeButton, coShowTape, coShowSeparatePercent };

typedef System::Set<TOvcCalculatorOption, TOvcCalculatorOption::coShowItemCount, TOvcCalculatorOption::coShowSeparatePercent> TOvcCalculatorOptions;

class PASCALIMPLEMENTATION TOvcCustomCalculator : public Ovcbase::TOvcCustomControl
{
	typedef Ovcbase::TOvcCustomControl inherited;
	
protected:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TOvcCalcColors* FColors;
	System::Extended FDisplay;
	System::UnicodeString FDisplayStr;
	System::Extended FLastOperand;
	TOvcCalculatorOptions FOptions;
	System::WideChar FTapeSeparatorChar;
	TOvcCalcButtonPressedEvent FOnButtonPressed;
	TOvcButtonArray cButtons;
	bool cDecimalEntered;
	TOvcCalculatorButton cDownButton;
	System::Types::TPoint cHitTest;
	TOvcCalculatorButton cLastButton;
	int cMargin;
	bool cMinus0;
	bool cOverBar;
	TOvcCalcPanel* cPanel;
	bool cPopup;
	int cScrBarWidth;
	int cSizeOffset;
	bool cSizing;
	HICON cTabCursor;
	TOvcCalcTape* cTape;
	TOvcCustomCalculatorEngine* cEngine;
	TOvcCalculatorButton cMouseOverButton;
	bool cMouseTracking;
	void __fastcall cAdjustHeight(void);
	void __fastcall cCalculateLook(void);
	void __fastcall cClearAll(void);
	void __fastcall cColorChange(System::TObject* Sender);
	void __fastcall cDisplayError(void);
	void __fastcall cDrawCalcButton(const TOvcButtonInfo &Button, const bool Pressed, const bool MouseOver);
	void __fastcall cDrawFocusState(void);
	void __fastcall cDrawSizeLine(void);
	void __fastcall cEvaluate(const TOvcCalculatorButton Button);
	System::UnicodeString __fastcall cFormatString(const System::Extended Value);
	int __fastcall cGetFontWidth(void);
	void __fastcall cInvalidateIndicator(void);
	void __fastcall cRefreshDisplays(void);
	void __fastcall cSetDisplayString(const System::UnicodeString Value);
	void __fastcall cTapeFontChange(System::TObject* Sender);
	int __fastcall GetDecimals(void);
	int __fastcall GetMaxPaperCount(void);
	System::Extended __fastcall GetMemory(void);
	System::Extended __fastcall GetOperand(void);
	System::Classes::TStrings* __fastcall GetTape(void);
	Vcl::Graphics::TFont* __fastcall GetTapeFont(void);
	int __fastcall GetTapeHeight(void);
	bool __fastcall GetVisible(void);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetDecimals(const int Value);
	void __fastcall SetDisplay(const System::Extended Value);
	void __fastcall SetDisplayStr(const System::UnicodeString Value);
	void __fastcall SetMaxPaperCount(const int Value);
	void __fastcall SetMemory(const System::Extended Value);
	void __fastcall SetOperand(const System::Extended Value);
	void __fastcall SetOptions(const TOvcCalculatorOptions Value);
	void __fastcall SetTape(System::Classes::TStrings* const Value);
	void __fastcall SetTapeFont(Vcl::Graphics::TFont* const Value);
	void __fastcall SetTapeHeight(const int Value);
	HIDESBASE void __fastcall SetVisible(const bool Value);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetText(Winapi::Messages::TWMGetText &Msg);
	MESSAGE void __fastcall WMGetTextLength(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Msg);
	MESSAGE void __fastcall WMMouseLeave(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	MESSAGE void __fastcall WMSetText(Winapi::Messages::TWMSetText &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property TOvcCalcColors* Colors = {read=FColors, write=FColors};
	__property int Decimals = {read=GetDecimals, write=SetDecimals, nodefault};
	__property int MaxPaperCount = {read=GetMaxPaperCount, write=SetMaxPaperCount, nodefault};
	__property TOvcCalculatorOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property Vcl::Graphics::TFont* TapeFont = {read=GetTapeFont, write=SetTapeFont};
	__property int TapeHeight = {read=GetTapeHeight, write=SetTapeHeight, nodefault};
	__property System::WideChar TapeSeparatorChar = {read=FTapeSeparatorChar, write=FTapeSeparatorChar, nodefault};
	__property bool Visible = {read=GetVisible, write=SetVisible, nodefault};
	__property TOvcCalcButtonPressedEvent OnButtonPressed = {read=FOnButtonPressed, write=FOnButtonPressed};
	
public:
	__fastcall virtual TOvcCustomCalculator(System::Classes::TComponent* AOwner);
	__fastcall virtual TOvcCustomCalculator(System::Classes::TComponent* AOwner, bool AsPopup);
	__fastcall virtual ~TOvcCustomCalculator(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall PushOperand(const System::Extended Value);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall CopyToClipboard(void);
	void __fastcall PasteFromClipboard(void);
	void __fastcall PressButton(TOvcCalculatorButton Button);
	__property System::Extended LastOperand = {read=FLastOperand, write=FLastOperand};
	__property System::Extended Memory = {read=GetMemory, write=SetMemory};
	__property System::Extended Operand = {read=GetOperand, write=SetOperand};
	__property System::UnicodeString DisplayStr = {read=FDisplayStr, write=SetDisplayStr};
	__property System::Extended DisplayValue = {read=FDisplay, write=SetDisplay};
	__property System::Classes::TStrings* Tape = {read=GetTape, write=SetTape};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomCalculator(HWND ParentWindow) : Ovcbase::TOvcCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCalculator : public TOvcCustomCalculator
{
	typedef TOvcCustomCalculator inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Align = {default=0};
	__property BorderStyle = {default=0};
	__property Ctl3D;
	__property Font;
	__property TapeFont;
	__property Colors;
	__property Cursor = {default=0};
	__property Decimals;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property LabelInfo;
	__property MaxPaperCount = {default=9999};
	__property TapeHeight;
	__property Options = {default=3};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property TapeSeparatorChar = {default=95};
	__property Visible = {default=1};
	__property OnButtonPressed;
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
	__property OnMouseWheel;
	__property OnStartDrag;
public:
	/* TOvcCustomCalculator.Create */ inline __fastcall virtual TOvcCalculator(System::Classes::TComponent* AOwner) : TOvcCustomCalculator(AOwner) { }
	/* TOvcCustomCalculator.CreateEx */ inline __fastcall virtual TOvcCalculator(System::Classes::TComponent* AOwner, bool AsPopup) : TOvcCustomCalculator(AOwner, AsPopup) { }
	/* TOvcCustomCalculator.Destroy */ inline __fastcall virtual ~TOvcCalculator(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCalculator(HWND ParentWindow) : TOvcCustomCalculator(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcCalcSchemeArray CalcScheme;
extern DELPHI_PACKAGE TOvcCalcDisplayString CalcDisplayString;
extern DELPHI_PACKAGE TOvcCalcButtonToOperation CalcButtontoOperation;
}	/* namespace Ovccalc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCALC)
using namespace Ovccalc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccalcHPP

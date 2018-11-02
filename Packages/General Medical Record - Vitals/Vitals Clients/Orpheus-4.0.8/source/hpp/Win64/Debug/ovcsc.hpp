// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcsc.pas' rev: 29.00 (Windows)

#ifndef OvcscHPP
#define OvcscHPP

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
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcmisc.hpp>
#include <ovcexcpt.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcsc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcSpinner;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcSpinnerStyle : unsigned char { stNormalVertical, stNormalHorizontal, stFourWay, stStar, stDiagonalVertical, stDiagonalHorizontal, stDiagonalFourWay, stPlainStar };

enum DECLSPEC_DENUM TOvcDirection : unsigned char { dUp, dDown, dRight, dLeft };

enum DECLSPEC_DENUM TOvcSpinState : unsigned char { ssNone, ssNormal, ssUpBtn, ssDownBtn, ssLeftBtn, ssRightBtn, ssCenterBtn };

enum DECLSPEC_DENUM TOvcSpinnerLineType : unsigned char { ltSingle, ltTopBevel, ltBottomBevel, ltTopSlice, ltBottomSlice, ltTopSliceSquare, ltBottomSliceSquare, ltDiagTopBevel, ltDiagBottomBevel, ltStarLine0, ltStarLine1, ltStarLine2, ltStarLine3, ltStarLine4, ltStarLine5 };

typedef void __fastcall (__closure *TSpinClickEvent)(System::TObject* Sender, TOvcSpinState State, double Delta, bool Wrap);

class PASCALIMPLEMENTATION TOvcSpinner : public Ovcbase::TOvcCustomControl
{
	typedef Ovcbase::TOvcCustomControl inherited;
	
protected:
	int FAcceleration;
	bool FAutoRepeat;
	int FDelayTime;
	double FDelta;
	int FRepeatCount;
	Vcl::Controls::TWinControl* FFocusedControl;
	bool FShowArrows;
	TOvcSpinnerStyle FStyle;
	bool FWrapMode;
	TSpinClickEvent FOnClick;
	int scNextMsgTime;
	HRGN scUpRgn;
	HRGN scDownRgn;
	HRGN scLeftRgn;
	HRGN scRightRgn;
	HRGN scCenterRgn;
	TOvcSpinState scCurrentState;
	System::Byte scLButton;
	bool scMouseOverBtn;
	TOvcSpinState scPrevState;
	bool scSizing;
	System::Types::TPoint scTopLeft;
	System::Types::TPoint scTopRight;
	System::Types::TPoint scBottomLeft;
	System::Types::TPoint scBottomRight;
	System::Types::TPoint scCenter;
	System::Types::TPoint scTopLeftCenter;
	System::Types::TPoint scBottomLeftCenter;
	System::Types::TPoint scTopRightCenter;
	System::Types::TPoint scBottomRightCenter;
	System::Types::TPoint scTopMiddle;
	System::Types::TPoint scBottomMiddle;
	System::Types::TPoint scLeftMiddle;
	System::Types::TPoint scRightMiddle;
	System::Types::TPoint scTopLeft4;
	System::Types::TPoint scBottomLeft4;
	System::Types::TPoint scTopRight4;
	System::Types::TPoint scBottomRight4;
	void __fastcall SetAcceleration(const int Value);
	void __fastcall SetAutoRepeat(bool Value);
	void __fastcall SetShowArrows(const bool Value);
	void __fastcall SetStyle(TOvcSpinnerStyle Value);
	TOvcSpinState __fastcall scCheckMousePos(void);
	void __fastcall scDeleteRegions(void);
	void __fastcall scDoAutoRepeat(void);
	void __fastcall scDrawArrow(const System::Types::TRect &R, const bool Pressed, const TOvcDirection Direction);
	void __fastcall scDrawLine(System::Types::TPoint P1, System::Types::TPoint P2, const bool Up, TOvcSpinnerLineType LineType);
	void __fastcall scDrawNormalButton(const bool Redraw);
	void __fastcall scDrawFourWayButton(const bool Redraw);
	void __fastcall scDrawStarButton(const bool Redraw);
	void __fastcall scDrawDiagonalVertical(const bool Redraw);
	void __fastcall scDrawDiagonalHorizontal(const bool Redraw);
	void __fastcall scDrawDiagonalFourWay(const bool Redraw);
	void __fastcall scDrawPlainStar(const bool Redraw);
	void __fastcall scDrawButton(const bool Redraw);
	void __fastcall scInvalidateButton(const TOvcSpinState State);
	void __fastcall scPolyline(System::Types::TPoint const *Points, const int Points_High);
	MESSAGE void __fastcall OMRecreateWnd(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall DoOnClick(TOvcSpinState State);
	virtual void __fastcall scDoMouseDown(const int XPos, const int YPos);
	virtual void __fastcall scDoMouseUp(void);
	void __fastcall scUpdateNormalSizes(void);
	void __fastcall scUpdateFourWaySizes(void);
	void __fastcall scUpdateStarSizes(void);
	void __fastcall scUpdateDiagonalVerticalSizes(void);
	void __fastcall scUpdateDiagonalHorizontalSizes(void);
	void __fastcall scUpdateDiagonalFourWaySizes(void);
	void __fastcall scUpdatePlainStarSizes(void);
	virtual void __fastcall scUpdateSizes(void);
	
public:
	__fastcall virtual TOvcSpinner(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcSpinner(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property int RepeatCount = {read=FRepeatCount, nodefault};
	
__published:
	__property int Acceleration = {read=FAcceleration, write=SetAcceleration, default=5};
	__property bool AutoRepeat = {read=FAutoRepeat, write=SetAutoRepeat, nodefault};
	__property double Delta = {read=FDelta, write=FDelta};
	__property int DelayTime = {read=FDelayTime, write=FDelayTime, default=500};
	__property Vcl::Controls::TWinControl* FocusedControl = {read=FFocusedControl, write=FFocusedControl};
	__property bool ShowArrows = {read=FShowArrows, write=SetShowArrows, default=1};
	__property TOvcSpinnerStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property bool WrapMode = {read=FWrapMode, write=FWrapMode, default=1};
	__property Anchors = {default=3};
	__property Constraints;
	__property Enabled = {default=1};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property Visible = {default=1};
	__property TSpinClickEvent OnClick = {read=FOnClick, write=FOnClick};
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSpinner(HWND ParentWindow) : Ovcbase::TOvcCustomControl(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcsc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSC)
using namespace Ovcsc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcscHPP

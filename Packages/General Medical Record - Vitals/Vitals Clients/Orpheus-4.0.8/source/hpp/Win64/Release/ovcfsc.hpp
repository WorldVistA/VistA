// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcfsc.pas' rev: 29.00 (Windows)

#ifndef OvcfscHPP
#define OvcfscHPP

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

//-- user supplied -----------------------------------------------------------

namespace Ovcfsc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcFlatSpinner;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcFlatSpinnerStyle : unsigned char { stNormalVertical, stNormalHorizontal, stFourWay, stStar, stDiagonalVertical, stDiagonalHorizontal, stDiagonalFourWay, stPlainStar };

enum DECLSPEC_DENUM TOvcFlatDirection : unsigned char { dUp, dDown, dRight, dLeft };

enum DECLSPEC_DENUM TOvcFlatSpinState : unsigned char { ssNone, ssNormal, ssUpBtn, ssDownBtn, ssLeftBtn, ssRightBtn, ssCenterBtn };

enum DECLSPEC_DENUM TOvcFlatSpinnerLineType : unsigned char { ltSingle, ltTopBevel, ltBottomBevel, ltTopSlice, ltBottomSlice, ltTopSliceSquare, ltBottomSliceSquare, ltDiagTopBevel, ltDiagBottomBevel, ltStarLine0, ltStarLine1, ltStarLine2, ltStarLine3, ltStarLine4, ltStarLine5 };

typedef void __fastcall (__closure *TFlatSpinClickEvent)(System::TObject* Sender, TOvcFlatSpinState State, double Delta, bool Wrap);

class PASCALIMPLEMENTATION TOvcFlatSpinner : public Ovcbase::TOvcCustomControl
{
	typedef Ovcbase::TOvcCustomControl inherited;
	
protected:
	System::Uitypes::TColor FArrowColor;
	System::Uitypes::TColor FFaceColor;
	System::Uitypes::TColor FHighlightColor;
	System::Uitypes::TColor FShadowColor;
	int FAcceleration;
	bool FAutoRepeat;
	int FDelayTime;
	double FDelta;
	int FRepeatCount;
	Vcl::Controls::TWinControl* FFocusedControl;
	bool FShowArrows;
	TOvcFlatSpinnerStyle FStyle;
	bool FWrapMode;
	TFlatSpinClickEvent FOnClick;
	int fscNextMsgTime;
	HRGN fscUpRgn;
	HRGN fscDownRgn;
	HRGN fscLeftRgn;
	HRGN fscRightRgn;
	HRGN fscCenterRgn;
	TOvcFlatSpinState fscCurrentState;
	System::Byte fscLButton;
	bool fscMouseOverBtn;
	TOvcFlatSpinState fscPrevState;
	bool fscSizing;
	System::Types::TPoint fscTopLeft;
	System::Types::TPoint fscTopRight;
	System::Types::TPoint fscBottomLeft;
	System::Types::TPoint fscBottomRight;
	System::Types::TPoint fscCenter;
	System::Types::TPoint fscTopLeftCenter;
	System::Types::TPoint fscBottomLeftCenter;
	System::Types::TPoint fscTopRightCenter;
	System::Types::TPoint fscBottomRightCenter;
	System::Types::TPoint fscTopMiddle;
	System::Types::TPoint fscBottomMiddle;
	System::Types::TPoint fscLeftMiddle;
	System::Types::TPoint fscRightMiddle;
	System::Types::TPoint fscTopLeft4;
	System::Types::TPoint fscBottomLeft4;
	System::Types::TPoint fscTopRight4;
	System::Types::TPoint fscBottomRight4;
	void __fastcall SetAcceleration(const int Value);
	void __fastcall SetShowArrows(const bool Value);
	void __fastcall SetStyle(TOvcFlatSpinnerStyle Value);
	void __fastcall SetArrowColor(System::Uitypes::TColor Value);
	void __fastcall SetFaceColor(System::Uitypes::TColor Value);
	void __fastcall SetHighlightColor(System::Uitypes::TColor Value);
	void __fastcall SetShadowColor(System::Uitypes::TColor Value);
	TOvcFlatSpinState __fastcall fscCheckMousePos(void);
	void __fastcall fscDeleteRegions(void);
	void __fastcall fscDoAutoRepeat(void);
	void __fastcall fscDrawArrow(const System::Types::TRect &R, const bool Pressed, const TOvcFlatDirection Direction);
	void __fastcall fscDrawLine(System::Types::TPoint P1, System::Types::TPoint P2, const bool Up, TOvcFlatSpinnerLineType LineType);
	void __fastcall fscDrawNormalButton(const bool Redraw);
	void __fastcall fscDrawFourWayButton(const bool Redraw);
	void __fastcall fscDrawStarButton(const bool Redraw);
	void __fastcall fscDrawDiagonalVertical(const bool Redraw);
	void __fastcall fscDrawDiagonalHorizontal(const bool Redraw);
	void __fastcall fscDrawDiagonalFourWay(const bool Redraw);
	void __fastcall fscDrawPlainStar(const bool Redraw);
	void __fastcall fscDrawButton(const bool Redraw);
	void __fastcall fscInvalidateButton(const TOvcFlatSpinState State);
	void __fastcall fscPolyline(System::Types::TPoint const *Points, const int Points_High);
	MESSAGE void __fastcall OMRecreateWnd(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	System::StaticArray<System::StaticArray<System::Uitypes::TColor, 8>, 2> BtnColor;
	void __fastcall DrawButton(Vcl::Graphics::TCanvas* C, const System::Types::TRect &R, bool Up);
	virtual void __fastcall Paint(void);
	void __fastcall ResetBtnColor(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall DoOnClick(TOvcFlatSpinState State);
	virtual void __fastcall fscDoMouseDown(const int XPos, const int YPos);
	virtual void __fastcall fscDoMouseUp(void);
	void __fastcall fscUpdateNormalSizes(void);
	void __fastcall fscUpdateFourWaySizes(void);
	void __fastcall fscUpdateStarSizes(void);
	void __fastcall fscUpdateDiagonalVerticalSizes(void);
	void __fastcall fscUpdateDiagonalHorizontalSizes(void);
	void __fastcall fscUpdateDiagonalFourWaySizes(void);
	void __fastcall fscUpdatePlainStarSizes(void);
	virtual void __fastcall fscUpdateSizes(void);
	
public:
	__fastcall virtual TOvcFlatSpinner(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcFlatSpinner(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property int RepeatCount = {read=FRepeatCount, nodefault};
	
__published:
	__property System::Uitypes::TColor ArrowColor = {read=FArrowColor, write=SetArrowColor, default=0};
	__property System::Uitypes::TColor FaceColor = {read=FFaceColor, write=SetFaceColor, default=-16777201};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=16777215};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=SetShadowColor, default=-16777200};
	__property int Acceleration = {read=FAcceleration, write=SetAcceleration, default=5};
	__property bool AutoRepeat = {read=FAutoRepeat, write=FAutoRepeat, default=1};
	__property double Delta = {read=FDelta, write=FDelta};
	__property int DelayTime = {read=FDelayTime, write=FDelayTime, default=500};
	__property Vcl::Controls::TWinControl* FocusedControl = {read=FFocusedControl, write=FFocusedControl};
	__property bool ShowArrows = {read=FShowArrows, write=SetShowArrows, nodefault};
	__property TOvcFlatSpinnerStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property bool WrapMode = {read=FWrapMode, write=FWrapMode, default=1};
	__property Anchors = {default=3};
	__property Constraints;
	__property Enabled = {default=1};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property Visible = {default=1};
	__property TFlatSpinClickEvent OnClick = {read=FOnClick, write=FOnClick};
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcFlatSpinner(HWND ParentWindow) : Ovcbase::TOvcCustomControl(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcfsc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCFSC)
using namespace Ovcfsc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcfscHPP

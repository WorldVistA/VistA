// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcRTF_TOM.pas' rev: 29.00 (Windows)

#ifndef Ovcrtf_tomHPP
#define Ovcrtf_tomHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.RichEdit.hpp>
#include <Winapi.Imm.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrtf_tom
{
//-- forward type declarations -----------------------------------------------
struct MYCHARFORMATW;
struct TReqResize;
__interface ITextServices;
typedef System::DelphiInterface<ITextServices> _di_ITextServices;
__interface ITextHost;
typedef System::DelphiInterface<ITextHost> _di_ITextHost;
class DELPHICLASS TTextHostImpl;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD MYCHARFORMATW
{
public:
	unsigned cbSize;
	int dwMask;
	int dwEffects;
	int yHeight;
	int yOffset;
	unsigned crTextColor;
	System::Byte bCharSet;
	System::Byte bPitchAndFamily;
	System::StaticArray<System::WideChar, 32> szFaceName;
};


typedef MYCHARFORMATW TMyCharFormatW;

typedef MYCHARFORMATW *PCharFormatW;

typedef PARAFORMAT *PParaFormat;

typedef System::Types::TSize TSizeL;

typedef System::Types::TRect TRectL;

typedef TReqResize *PReqResize;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TReqResize
{
public:
	tagNMHDR nmhdr;
	System::Types::TRect rc;
};
#pragma pack(pop)


enum DECLSPEC_DENUM TTxtBackStyle : unsigned int { txtBack_Transparent, txtBack_Opaque };

enum DECLSPEC_DENUM TTxtView : unsigned int { txtView_Active, txtView_Inactive };

typedef System::LongBool __stdcall (*TTxDrawCallback)(unsigned param);

__interface  INTERFACE_UUID("{8D33F740-CF58-11CE-A89D-00AA006CADC5}") ITextServices  : public System::IInterface 
{
	virtual HRESULT __stdcall TxSendMessage(unsigned msg, NativeUInt wParam, NativeInt lParam, /* out */ NativeInt &plresult) = 0 ;
	virtual HRESULT __stdcall TxDraw(unsigned dwDrawAspect, int lindex, void * pvAspect, Winapi::Activex::PDVTargetDevice ptd, HDC hdcDraw, HDC hicTargetDev, const System::Types::TRect &lprcBounds, const System::Types::TRect &lprcWBounds, const System::Types::TRect &lprcUpdate, TTxDrawCallback pfnContinue, unsigned dwContinue, TTxtView lViewID) = 0 ;
	virtual HRESULT __stdcall TxGetHScroll(/* out */ int &plMin, /* out */ int &plMax, /* out */ int &plPos, /* out */ int &plPage, /* out */ System::LongBool &pfEnabled) = 0 ;
	virtual HRESULT __stdcall TxGetVScroll(/* out */ int &plMin, /* out */ int &plMax, /* out */ int &plPos, /* out */ int &plPage, /* out */ System::LongBool &pfEnabled) = 0 ;
	virtual HRESULT __stdcall OnTxSetCursor(unsigned dwDrawAspect, int lindex, void * pvAspect, Winapi::Activex::PDVTargetDevice ptd, HDC hdcDraw, HDC hicTargetDev, const System::Types::TRect &lprcClient, int x, int y) = 0 ;
	virtual HRESULT __stdcall TxQueryHitPoint(unsigned dwDrawAspect, int lindex, void * pvAspect, Winapi::Activex::PDVTargetDevice ptd, HDC hdcDraw, HDC hicTargetDev, const System::Types::TRect &lprcClient, int x, int y, /* out */ unsigned &pHitResult) = 0 ;
	virtual HRESULT __stdcall OnTxInPlaceActivate(const System::Types::TRect &prcClient) = 0 ;
	virtual HRESULT __stdcall OnTxInPlaceDeactivate(void) = 0 ;
	virtual HRESULT __stdcall OnTxUIActivate(void) = 0 ;
	virtual HRESULT __stdcall OnTxUIDeactivate(void) = 0 ;
	virtual HRESULT __stdcall TxGetText(/* out */ System::WideChar * &pbstrText) = 0 ;
	virtual HRESULT __stdcall TxSetText(System::WideChar * pszText) = 0 ;
	virtual HRESULT __stdcall TxGetCurTargetX(/* out */ int &px) = 0 ;
	virtual HRESULT __stdcall TxGetBaselinePos(/* out */ int &pBaselinePos) = 0 ;
	virtual HRESULT __stdcall TxGetNaturalSize(unsigned dwAspect, HDC hdcDraw, HDC hicTargetDev, Winapi::Activex::PDVTargetDevice ptd, unsigned dwMode, const System::Types::TSize &psizelExtent, int &pwidth, int &pheight) = 0 ;
	virtual HRESULT __stdcall TxGetDropTarget(/* out */ _di_IDropTarget &ppDropTarget) = 0 ;
	virtual HRESULT __stdcall OnTxPropertyBitsChange(unsigned dwMask, unsigned dwBits) = 0 ;
	virtual HRESULT __stdcall TxGetCachedSize(/* out */ unsigned &pdwWidth, /* out */ unsigned &pdwHeight) = 0 ;
};

__interface  INTERFACE_UUID("{C5BDD8D0-D26E-11CE-A89E-00AA006CADC5}") ITextHost  : public System::IInterface 
{
	virtual HDC __stdcall TxGetDC(void) = 0 ;
	virtual int __stdcall TxReleaseDC(HDC hdc) = 0 ;
	virtual System::LongBool __stdcall TxShowScrollBar(int fnBar, System::LongBool fShow) = 0 ;
	virtual System::LongBool __stdcall TxEnableScrollBar(int fuSBFlags, int fuArrowFlags) = 0 ;
	virtual System::LongBool __stdcall TxSetScrollRange(int fnBar, int nMinPos, int nMaxPos, System::LongBool fRedraw) = 0 ;
	virtual System::LongBool __stdcall TxSetScrollPos(int fnBar, int nPos, System::LongBool fRedraw) = 0 ;
	virtual void __stdcall TxInvalidateRect(const System::Types::TRect &prc, System::LongBool fMode) = 0 ;
	virtual void __stdcall TxViewChange(System::LongBool fUpdate) = 0 ;
	virtual System::LongBool __stdcall TxCreateCaret(HBITMAP hbmp, int xWidth, int yHeight) = 0 ;
	virtual System::LongBool __stdcall TxShowCaret(System::LongBool fShow) = 0 ;
	virtual System::LongBool __stdcall TxSetCaretPos(int x, int y) = 0 ;
	virtual System::LongBool __stdcall TxSetTimer(unsigned idTimer, unsigned uTimeout) = 0 ;
	virtual void __stdcall TxKillTimer(unsigned idTimer) = 0 ;
	virtual void __stdcall TxScrollWindowEx(int dx, int dy, const System::Types::TRect &lprcScroll, const System::Types::TRect &lprcClip, HRGN hrgnUpdate, unsigned fuScroll) = 0 ;
	virtual void __stdcall TxSetCapture(System::LongBool fCapture) = 0 ;
	virtual void __stdcall TxSetFocus(void) = 0 ;
	virtual void __stdcall TxSetCursor(HICON hcur, System::LongBool fText) = 0 ;
	virtual System::LongBool __stdcall TxScreenToClient(System::Types::TPoint &lppt) = 0 ;
	virtual System::LongBool __stdcall TxClientToScreen(System::Types::TPoint &lppt) = 0 ;
	virtual HRESULT __stdcall TxActivate(/* out */ int &lpOldState) = 0 ;
	virtual HRESULT __stdcall TxDeactivate(int lNewState) = 0 ;
	virtual HRESULT __stdcall TxGetClientRect(/* out */ System::Types::TRect &prc) = 0 ;
	virtual HRESULT __stdcall TxGetViewInset(/* out */ System::Types::TRect &prc) = 0 ;
	virtual HRESULT __stdcall TxGetCharFormat(/* out */ PCharFormatW &ppCF) = 0 ;
	virtual HRESULT __stdcall TxGetParaFormat(/* out */ PParaFormat &ppPF) = 0 ;
	virtual unsigned __stdcall TxGetSysColor(int nIndex) = 0 ;
	virtual HRESULT __stdcall TxGetBackStyle(/* out */ TTxtBackStyle &pstyle) = 0 ;
	virtual HRESULT __stdcall TxGetMaxLength(/* out */ unsigned &pLength) = 0 ;
	virtual HRESULT __stdcall TxGetScrollBars(/* out */ unsigned &pdwScrollBar) = 0 ;
	virtual HRESULT __stdcall TxGetPasswordChar(/* out */ System::WideChar &pch) = 0 ;
	virtual HRESULT __stdcall TxGetAcceleratorPos(/* out */ int &pcp) = 0 ;
	virtual HRESULT __stdcall TxGetExtent(/* out */ System::Types::TSize &lpExtent) = 0 ;
	virtual HRESULT __stdcall OnTxCharFormatChange(const MYCHARFORMATW &pcf) = 0 ;
	virtual HRESULT __stdcall OnTxParaFormatChange(const PARAFORMAT &ppf) = 0 ;
	virtual HRESULT __stdcall TxGetPropertyBits(unsigned dwMask, /* out */ unsigned &pdwBits) = 0 ;
	virtual HRESULT __stdcall TxNotify(unsigned iNotify, void * pv) = 0 ;
	virtual int __stdcall TxImmGetContext(void) = 0 ;
	virtual void __stdcall TxImmReleaseContext(int himc) = 0 ;
	virtual HRESULT __stdcall TxGetSelectionBarWidth(/* out */ int &lSelBarWidth) = 0 ;
};

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTextHostImpl : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	virtual HDC __stdcall TxGetDC(void);
	virtual int __stdcall TxReleaseDC(HDC hdc);
	virtual System::LongBool __stdcall TxShowScrollBar(int fnBar, System::LongBool fShow);
	virtual System::LongBool __stdcall TxEnableScrollBar(int fuSBFlags, int fuArrowFlags);
	virtual System::LongBool __stdcall TxSetScrollRange(int fnBar, int nMinPos, int nMaxPos, System::LongBool fRedraw);
	virtual System::LongBool __stdcall TxSetScrollPos(int fnBar, int nPos, System::LongBool fRedraw);
	virtual void __stdcall TxInvalidateRect(const System::Types::TRect &prc, System::LongBool fMode);
	virtual void __stdcall TxViewChange(System::LongBool fUpdate);
	virtual System::LongBool __stdcall TxCreateCaret(HBITMAP hbmp, int xWidth, int yHeight);
	virtual System::LongBool __stdcall TxShowCaret(System::LongBool fShow);
	virtual System::LongBool __stdcall TxSetCaretPos(int x, int y);
	virtual System::LongBool __stdcall TxSetTimer(unsigned idTimer, unsigned uTimeout);
	virtual void __stdcall TxKillTimer(unsigned idTimer);
	virtual void __stdcall TxScrollWindowEx(int dx, int dy, const System::Types::TRect &lprcScroll, const System::Types::TRect &lprcClip, HRGN hrgnUpdate, unsigned fuScroll);
	virtual void __stdcall TxSetCapture(System::LongBool fCapture);
	virtual void __stdcall TxSetFocus(void);
	virtual void __stdcall TxSetCursor(HICON hcur, System::LongBool fText);
	virtual System::LongBool __stdcall TxScreenToClient(System::Types::TPoint &lppt);
	virtual System::LongBool __stdcall TxClientToScreen(System::Types::TPoint &lppt);
	virtual HRESULT __stdcall TxActivate(/* out */ int &lpOldState);
	virtual HRESULT __stdcall TxDeactivate(int lNewState);
	virtual HRESULT __stdcall TxGetClientRect(/* out */ System::Types::TRect &prc);
	virtual HRESULT __stdcall TxGetViewInset(/* out */ System::Types::TRect &prc);
	virtual HRESULT __stdcall TxGetCharFormat(/* out */ PCharFormatW &ppCF);
	virtual HRESULT __stdcall TxGetParaFormat(/* out */ PParaFormat &ppPF);
	virtual unsigned __stdcall TxGetSysColor(int nIndex);
	virtual HRESULT __stdcall TxGetBackStyle(/* out */ TTxtBackStyle &pstyle);
	virtual HRESULT __stdcall TxGetMaxLength(/* out */ unsigned &pLength);
	virtual HRESULT __stdcall TxGetScrollBars(/* out */ unsigned &pdwScrollBar);
	virtual HRESULT __stdcall TxGetPasswordChar(/* out */ System::WideChar &pch);
	virtual HRESULT __stdcall TxGetAcceleratorPos(/* out */ int &pcp);
	virtual HRESULT __stdcall TxGetExtent(/* out */ System::Types::TSize &lpExtent);
	virtual HRESULT __stdcall OnTxCharFormatChange(const MYCHARFORMATW &pcf);
	virtual HRESULT __stdcall OnTxParaFormatChange(const PARAFORMAT &ppf);
	virtual HRESULT __stdcall TxGetPropertyBits(unsigned dwMask, /* out */ unsigned &pdwBits) = 0 ;
	virtual HRESULT __stdcall TxNotify(unsigned iNotify, void * pv);
	virtual int __stdcall TxImmGetContext(void);
	virtual void __stdcall TxImmReleaseContext(int himc);
	virtual HRESULT __stdcall TxGetSelectionBarWidth(/* out */ int &lSelBarWidth);
public:
	/* TObject.Create */ inline __fastcall TTextHostImpl(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TTextHostImpl(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define SID_ITextHost L"{c5bdd8d0-d26e-11ce-a89e-00aa006cadc5}"
#define SID_ITextServices L"{8d33f740-cf58-11ce-a89d-00aa006cadc5}"
extern DELPHI_PACKAGE GUID IID_ITextHost;
extern DELPHI_PACKAGE GUID IID_ITextServices;
static const System::Int8 txtBit_RichText = System::Int8(0x1);
static const System::Int8 txtBit_Multiline = System::Int8(0x2);
static const System::Int8 txtBit_ReadOnly = System::Int8(0x4);
static const System::Int8 txtBit_ShowAccelerator = System::Int8(0x8);
static const System::Int8 txtBit_UsePassword = System::Int8(0x10);
static const System::Int8 txtBit_HideSelection = System::Int8(0x20);
static const System::Int8 txtBit_SaveSelection = System::Int8(0x40);
static const System::Byte txtBit_AutoWordSel = System::Byte(0x80);
static const System::Word txtBit_Vertical = System::Word(0x100);
static const System::Word txtBit_SelBarChange = System::Word(0x200);
static const System::Word txtBit_WordWrap = System::Word(0x400);
static const System::Word txtBit_AllowBeep = System::Word(0x800);
static const System::Word txtBit_DisableDrag = System::Word(0x1000);
static const System::Word txtBit_ViewInsetChange = System::Word(0x2000);
static const System::Word txtBit_BackStyleChange = System::Word(0x4000);
static const System::Word txtBit_MaxLengthChange = System::Word(0x8000);
static const int txtBit_ScrollBarChange = int(0x10000);
static const int txtBit_CharFormatChange = int(0x20000);
static const int txtBit_ParaFormatChange = int(0x40000);
static const int txtBit_ExtentChange = int(0x80000);
static const int txtBit_ClientRectChange = int(0x100000);
static const int txtBit_UseCurrentBkg = int(0x200000);
static const System::Int8 txtNS_FitToContent = System::Int8(0x1);
static const System::Int8 txtNS_RoundToLine = System::Int8(0x2);
extern "C" HRESULT __stdcall CreateTextServices(System::_di_IInterface punkOuter, _di_ITextHost pITextHost, /* out */ void *ppUnk);
extern DELPHI_PACKAGE void __fastcall PatchTextServices(_di_ITextServices &Services);
extern DELPHI_PACKAGE _di_ITextHost __fastcall CreateTextHost(TTextHostImpl* const Impl);
}	/* namespace Ovcrtf_tom */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRTF_TOM)
using namespace Ovcrtf_tom;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcrtf_tomHPP

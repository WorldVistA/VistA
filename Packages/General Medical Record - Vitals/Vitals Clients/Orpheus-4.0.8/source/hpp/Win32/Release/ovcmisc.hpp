// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcmisc.pas' rev: 29.00 (Windows)

#ifndef OvcmiscHPP
#define OvcmiscHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Consts.hpp>
#include <ovcdata.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcmisc
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef HDC TOvcHdc;

typedef HWND TOvcHWND;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE HBITMAP __fastcall LoadBaseBitmap(System::WideChar * lpBitmapName);
extern DELPHI_PACKAGE HICON __fastcall LoadBaseCursor(System::WideChar * lpCursorName);
extern DELPHI_PACKAGE int __fastcall CompStruct(const void *S1, const void *S2, unsigned Size);
extern DELPHI_PACKAGE void __fastcall FixRealPrim(System::WideChar * P, System::WideChar DC);
extern DELPHI_PACKAGE System::Byte __fastcall GetLeftButton(void);
extern DELPHI_PACKAGE HWND __fastcall GetNextDlgItem(HWND Ctrl);
extern DELPHI_PACKAGE void __fastcall GetRGB(System::Uitypes::TColor Clr, System::Byte &IR, System::Byte &IG, System::Byte &IB);
extern DELPHI_PACKAGE System::Byte __fastcall GetShiftFlags(void);
extern DELPHI_PACKAGE HFONT __fastcall CreateRotatedFont(Vcl::Graphics::TFont* F, int Angle);
extern DELPHI_PACKAGE int __fastcall GetTopTextMargin(Vcl::Graphics::TFont* Font, Vcl::Forms::TBorderStyle BorderStyle, int Height, bool Ctl3D);
extern DELPHI_PACKAGE System::Word __fastcall PtrDiff(const System::WideChar * P1, const System::WideChar * P2);
extern DELPHI_PACKAGE void __fastcall PtrInc(void *P, System::Word Delta);
extern DELPHI_PACKAGE void __fastcall PtrDec(void *P, System::Word Delta);
extern DELPHI_PACKAGE int __fastcall MinI(int X, int Y);
extern DELPHI_PACKAGE int __fastcall MaxI(int X, int Y);
extern DELPHI_PACKAGE int __fastcall MinL(int X, int Y);
extern DELPHI_PACKAGE int __fastcall MaxL(int X, int Y);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TrimLeft(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TrimRight(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall QuotedStr(const System::UnicodeString S);
extern DELPHI_PACKAGE int __fastcall WordCount(const System::UnicodeString S, const Ovcdata::TCharSet &WordDelims);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractWord(int N, const System::UnicodeString S, const Ovcdata::TCharSet &WordDelims);
extern DELPHI_PACKAGE int __fastcall WordPosition(const int N, const System::UnicodeString S, const Ovcdata::TCharSet &WordDelims);
extern DELPHI_PACKAGE System::Types::TRect __fastcall DrawButtonFrame(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Client, bool IsDown, bool IsFlat, Vcl::Buttons::TButtonStyle Style);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetDisplayString(Vcl::Graphics::TCanvas* Canvas, const System::UnicodeString S, int MinChars, int MaxWidth);
extern DELPHI_PACKAGE bool __fastcall IsForegroundTask(void);
extern DELPHI_PACKAGE void __fastcall FixTextBuffer(System::WideChar * InBuf, System::WideChar * OutBuf, int OutSize);
extern DELPHI_PACKAGE void __fastcall TransStretchBlt(HDC DstDC, int DstX, int DstY, int DstW, int DstH, HDC SrcDC, int SrcX, int SrcY, int SrcW, int SrcH, HDC MaskDC, int MaskX, int MaskY);
extern DELPHI_PACKAGE int __fastcall DefaultEpoch(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GenerateComponentName(Vcl::Controls::TWinControl* PF, const System::UnicodeString Root);
extern DELPHI_PACKAGE bool __fastcall PartialCompare(const System::UnicodeString S1, const System::UnicodeString S2);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PathEllipsis(const System::UnicodeString S, int MaxWidth);
extern DELPHI_PACKAGE Vcl::Graphics::TBitmap* __fastcall CreateDisabledBitmap(Vcl::Graphics::TBitmap* FOriginal, System::Uitypes::TColor OutlineColor);
extern DELPHI_PACKAGE void __fastcall CopyParentImage(Vcl::Controls::TControl* Control, Vcl::Graphics::TCanvas* Dest);
extern DELPHI_PACKAGE void __fastcall DrawTransparentBitmap(Vcl::Graphics::TCanvas* Dest, int X, int Y, int W, int H, const System::Types::TRect &Rect, Vcl::Graphics::TBitmap* Bitmap, System::Uitypes::TColor TransparentColor);
extern DELPHI_PACKAGE int __fastcall WidthOf(const System::Types::TRect &R);
extern DELPHI_PACKAGE int __fastcall HeightOf(const System::Types::TRect &R);
extern DELPHI_PACKAGE void __fastcall DebugOutput(const System::UnicodeString S);
extern DELPHI_PACKAGE int __fastcall GetArrowWidth(int Width, int Height);
}	/* namespace Ovcmisc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCMISC)
using namespace Ovcmisc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcmiscHPP

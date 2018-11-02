// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcviewr.pas' rev: 29.00 (Windows)

#ifndef OvcviewrHPP
#define OvcviewrHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovccaret.hpp>
#include <ovccmd.hpp>
#include <ovccolor.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcfxfnt.hpp>
#include <ovcmisc.hpp>
#include <ovcstr.hpp>
#include <ovcbordr.hpp>
#include <ovceditu.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcviewr
{
//-- forward type declarations -----------------------------------------------
struct TOvcTextPos;
struct TOvcViewerRange;
class DELPHICLASS TOvcBaseViewer;
class DELPHICLASS TStringNode;
class DELPHICLASS TVwrStringList;
class DELPHICLASS TOvcCustomTextFileViewer;
class DELPHICLASS TOvcTextFileViewer;
struct TfvPageRec;
class DELPHICLASS TOvcCustomFileViewer;
class DELPHICLASS TOvcFileViewer;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcTextPos
{
public:
	int Line;
	int Col;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcViewerRange
{
public:
	TOvcTextPos Start;
	TOvcTextPos Stop;
};
#pragma pack(pop)


class PASCALIMPLEMENTATION TOvcBaseViewer : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	Ovcbordr::TOvcBorders* FBorders;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	bool FExpandTabs;
	Ovcfxfnt::TOvcFixedFont* FFixedFont;
	Ovccolor::TOvcColors* FHighlightColors;
	System::Uitypes::TColor FMarginColor;
	System::Uitypes::TScrollStyle FScrollBars;
	bool FShowBookmarks;
	bool FShowCaret;
	System::Byte FTabSize;
	int FCaretEffCol;
	TOvcTextPos FCaretPos;
	int FLineCount;
	System::StaticArray<TOvcTextPos, 10> FMarkers;
	int FTopLine;
	Ovcdata::TShowStatusEvent FOnShowStatus;
	Ovcdata::TTopLineChangedEvent FOnTopLineChanged;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	bool vwAmFocused;
	TOvcTextPos vwAnchor;
	Vcl::Graphics::TBitmap* vwBMGlyphs;
	Ovccaret::TOvcSingleCaret* vwCaret;
	int vwCols;
	int vwColWid;
	System::WideChar vwDefaultChar;
	bool vwDitheredBG;
	int vwDivisor;
	int vwFile;
	System::WideChar vwFirstChar;
	TOvcViewerRange vwHighlight;
	int vwHDelta;
	bool vwHScroll;
	int vwHSHigh;
	System::WideChar vwLastChar;
	HICON vwLineSelCursor;
	bool vwLineSelCursorOn;
	int vwRowHt;
	int vwRows;
	HICON vwSaveCursor;
	bool vwVScroll;
	int vwVSHigh;
	int vwVSMax;
	bool vwWaiting;
	TOvcTextPos __fastcall GetCaretActualPos(void);
	TOvcTextPos __fastcall GetCaretEffectivePos(void);
	Ovccaret::TOvcCaret* __fastcall GetCaretType(void);
	int __fastcall GetLineLength(int LineNum);
	System::UnicodeString __fastcall GetStringLine(int LineNum);
	int __fastcall GetTopLine(void);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle BS);
	void __fastcall SetCaretType(Ovccaret::TOvcCaret* CT);
	void __fastcall SetCaretActualPos(const TOvcTextPos &LC);
	void __fastcall SetCaretEffectivePos(const TOvcTextPos &LC);
	void __fastcall SetExpandTabs(bool E);
	void __fastcall SetFixedFont(Ovcfxfnt::TOvcFixedFont* FF);
	void __fastcall SetLineCount(int N);
	void __fastcall SetMarginColor(System::Uitypes::TColor C);
	void __fastcall SetScrollBars(System::Uitypes::TScrollStyle SB);
	void __fastcall SetShowBookmarks(bool SB);
	void __fastcall SetShowCaret(bool Value);
	void __fastcall SetTabSize(System::Byte N);
	void __fastcall SetTopLine(int LineNum);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	MESSAGE void __fastcall OMShowStatus(Ovcdata::TOMShowStatus &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	DYNAMIC void __fastcall DoOnShowStatus(int LineNum, int ColNum);
	DYNAMIC void __fastcall DoOnTopLineChanged(int Line);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	virtual System::WideChar * __fastcall GetLinePtr(int LineNum, int &Len) = 0 ;
	void __fastcall vwBorderChanged(System::TObject* ABorder);
	void __fastcall vwPaintBorders(void);
	void __fastcall vwCalcColorFields(void);
	void __fastcall vwCalcFontFields(void);
	bool __fastcall vwCaretIsVisible(void);
	void __fastcall vwChangeLineCount(int N);
	void __fastcall vwFixedFontChanged(System::TObject* Sender);
	int __fastcall vwGetLineEffLen(int N);
	void __fastcall vwGetMousePos(TOvcTextPos &MousePos, int XPixel, int YPixel);
	void __fastcall vwHighlightColorsChanged(System::TObject* Sender);
	void __fastcall vwInitInternalFields(void);
	void __fastcall vwInvalidateLine(int LineNum);
	void __fastcall vwMoveCaret(int HDelta, int VDelta, bool MoveByPage, bool AmSelecting);
	void __fastcall vwMoveCaretPrim(int HDelta, int VDelta, bool MoveByPage, bool AmSelecting, bool AbsMove);
	void __fastcall vwMoveCaretTo(int Line, int Col, bool AmSelecting);
	void __fastcall vwPositionCaret(void);
	void __fastcall vwReadBookmarkGlyphs(void);
	void __fastcall vwRefreshLines(const TOvcTextPos &Start, const TOvcTextPos &Stop);
	void __fastcall vwResetHighlight(bool Refresh);
	void __fastcall vwScrollPrim(int HDelta, int VDelta);
	void __fastcall vwScrollPrimHorz(int Delta);
	void __fastcall vwScrollPrimVert(int Delta);
	void __fastcall vwSetHScrollPos(void);
	void __fastcall vwSetHScrollRange(void);
	void __fastcall vwSetVScrollPos(void);
	void __fastcall vwSetVScrollRange(void);
	void __fastcall vwShowWaitCursor(bool ShowIt);
	void __fastcall vwUpdateHighlight(bool Refresh);
	__property Ovcbordr::TOvcBorders* Borders = {read=FBorders, write=FBorders};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property Ovccaret::TOvcCaret* Caret = {read=GetCaretType, write=SetCaretType};
	__property bool ExpandTabs = {read=FExpandTabs, write=SetExpandTabs, nodefault};
	__property Ovcfxfnt::TOvcFixedFont* FixedFont = {read=FFixedFont, write=SetFixedFont};
	__property Ovccolor::TOvcColors* HighlightColors = {read=FHighlightColors, write=FHighlightColors};
	__property System::Uitypes::TColor MarginColor = {read=FMarginColor, write=SetMarginColor, nodefault};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, nodefault};
	__property bool ShowBookmarks = {read=FShowBookmarks, write=SetShowBookmarks, nodefault};
	__property bool ShowCaret = {read=FShowCaret, write=SetShowCaret, nodefault};
	__property System::Byte TabSize = {read=FTabSize, write=SetTabSize, nodefault};
	__property Ovcdata::TShowStatusEvent OnShowStatus = {read=FOnShowStatus, write=FOnShowStatus};
	__property Ovcdata::TTopLineChangedEvent OnTopLineChanged = {read=FOnTopLineChanged, write=FOnTopLineChanged};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	
public:
	__fastcall virtual TOvcBaseViewer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseViewer(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	virtual int __fastcall CheckLine(int LineNum);
	int __fastcall ActualColumn(int Line, int EffectiveCol);
	void __fastcall ClearMarker(System::Byte N);
	void __fastcall CopyToClipboard(void);
	int __fastcall EffectiveColumn(int Line, int ActualCol);
	int __fastcall GetCaretPosition(int &Col);
	System::WideChar * __fastcall GetLine(int LineNum, System::WideChar * Dest, int DestLen);
	int __fastcall GetMarkerPosition(System::Byte N, int &Col);
	int __fastcall GetPrintableLine(int LineNum, System::WideChar * Dest, int DestLen);
	bool __fastcall GetSelection(int &Line1, int &Col1, int &Line2, int &Col2);
	void __fastcall GotoMarker(System::Byte N);
	virtual bool __fastcall Search(const System::UnicodeString S, Ovcdata::TSearchOptionSet Options);
	void __fastcall SelectAll(bool CaretAtEnd);
	void __fastcall SetCaretPosition(int Line, int Col);
	void __fastcall SetMarker(System::Byte N);
	void __fastcall SetMarkerAt(System::Byte N, int Line, int Col);
	void __fastcall SetSelection(int Line1, int Col1, int Line2, int Col2, bool CaretAtEnd);
	__property TOvcTextPos CaretActualPos = {read=GetCaretActualPos, write=SetCaretActualPos};
	__property TOvcTextPos CaretEffectivePos = {read=GetCaretEffectivePos, write=SetCaretEffectivePos};
	__property Color = {default=-16777211};
	__property int LineCount = {read=FLineCount, write=SetLineCount, nodefault};
	__property int LineLength[int LineNum] = {read=GetLineLength};
	__property System::UnicodeString Lines[int LineNum] = {read=GetStringLine};
	__property int TopLine = {read=GetTopLine, write=SetTopLine, stored=false, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBaseViewer(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TStringNode : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TStringNode* snNext;
	TStringNode* snPrev;
	System::WideChar *snS;
	System::Word snSLen;
	
public:
	__fastcall TStringNode(System::WideChar * P);
	__fastcall virtual ~TStringNode(void);
	System::WideChar * __fastcall GetS(int &Len);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TVwrStringList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TStringNode* slHead;
	TStringNode* slTail;
	int slCount;
	int slLastN;
	TStringNode* slLastNode;
	
public:
	__fastcall TVwrStringList(void);
	__fastcall virtual ~TVwrStringList(void);
	int __fastcall Count(void);
	void __fastcall Append(TStringNode* P);
	TStringNode* __fastcall Nth(int N);
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcCustomTextFileViewer : public TOvcBaseViewer
{
	typedef TOvcBaseViewer inherited;
	
protected:
	System::UnicodeString *FFileName;
	int FFileSize;
	TVwrStringList* fvLines;
	System::UnicodeString __fastcall GetFileName(void);
	bool __fastcall GetIsOpen(void);
	void __fastcall SetFileName(const System::UnicodeString N);
	void __fastcall SetIsOpen(bool OpenIt);
	virtual System::WideChar * __fastcall GetLinePtr(int LineNum, int &Len);
	__property System::UnicodeString FileName = {read=GetFileName, write=SetFileName};
	__property bool IsOpen = {read=GetIsOpen, write=SetIsOpen, nodefault};
	
public:
	__fastcall virtual TOvcCustomTextFileViewer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomTextFileViewer(void);
	virtual int __fastcall CheckLine(int LineNum);
	__property int FileSize = {read=FFileSize, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomTextFileViewer(HWND ParentWindow) : TOvcBaseViewer(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTextFileViewer : public TOvcCustomTextFileViewer
{
	typedef TOvcCustomTextFileViewer inherited;
	
__published:
	__property Borders;
	__property BorderStyle = {default=1};
	__property Caret;
	__property Controller;
	__property ExpandTabs = {default=1};
	__property FileName = {default=0};
	__property FixedFont;
	__property HighlightColors;
	__property IsOpen = {default=0};
	__property LabelInfo;
	__property MarginColor = {default=-16777211};
	__property ScrollBars = {default=3};
	__property ShowBookmarks = {default=1};
	__property ShowCaret = {default=1};
	__property TabSize = {default=8};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnShowStatus;
	__property OnTopLineChanged;
	__property OnUserCommand;
	__property OnClick;
	__property OnDblClick;
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
	__property OnStartDrag;
public:
	/* TOvcCustomTextFileViewer.Create */ inline __fastcall virtual TOvcTextFileViewer(System::Classes::TComponent* AOwner) : TOvcCustomTextFileViewer(AOwner) { }
	/* TOvcCustomTextFileViewer.Destroy */ inline __fastcall virtual ~TOvcTextFileViewer(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTextFileViewer(HWND ParentWindow) : TOvcCustomTextFileViewer(ParentWindow) { }
	
};


typedef int TQuasiTime;

typedef int TBlockNum;

typedef System::StaticArray<char, 4096> TfvBufferArray;

typedef TfvBufferArray *PfvBufferArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TfvPageRec
{
public:
	int BlockNum;
	int ByteCount;
	int LastUsed;
	TfvBufferArray *Buffer;
};
#pragma pack(pop)


typedef System::StaticArray<TfvPageRec, 512> TfvPageArray;

typedef TfvPageArray *PfvPageArray;

class PASCALIMPLEMENTATION TOvcCustomFileViewer : public TOvcBaseViewer
{
	typedef TOvcBaseViewer inherited;
	
protected:
	int FBufferPageCount;
	System::UnicodeString *FFileName;
	int FFileSize;
	bool FFilterChars;
	bool FInHexMode;
	bool FIsOpen;
	int fvCurLine;
	int fvCurOffset;
	int fvKnownLine;
	int fvKnownOffset;
	int fvLastLine;
	int fvLastLine2;
	int fvLastLineOffset;
	System::WideChar *fvLnBuf;
	int fvLineInBuf;
	int fvLnBufLen;
	int fvMaxPage;
	int fvNewLine;
	int fvNewOffset;
	int fvPageArraySize;
	TfvPageArray *fvPages;
	int fvTicks;
	char *fvWorkBeg;
	int fvWorkBlk;
	char *fvWorkEnd;
	int fvWorkOffset;
	char *fvWorkPtr;
	System::UnicodeString __fastcall GetFileName(void);
	void __fastcall SetBufferPageCount(int BPC);
	void __fastcall SetFileName(const System::UnicodeString N);
	void __fastcall SetFilterChars(bool FC);
	void __fastcall SetInHexMode(bool HM);
	void __fastcall SetIsOpen(bool OpenIt);
	void __fastcall fvDeallocateBuffers(void);
	System::WideChar * __fastcall fvGetLineAsText(int LineNum, int &Len);
	System::WideChar * __fastcall fvGetLineInHex(int LineNum, int &Len);
	bool __fastcall fvGetWorkingChar(void);
	void __fastcall fvGetWorkingPage(void);
	void __fastcall fvGotoHexLine(int Line);
	void __fastcall fvGotoTextLine(int Line);
	void __fastcall fvInitFileFields(void);
	void __fastcall fvInitObjectFields(void);
	void __fastcall fvNewWorkingSet(void);
	virtual System::WideChar * __fastcall GetLinePtr(int LineNum, int &Len);
	__property int BufferPageCount = {read=FBufferPageCount, write=SetBufferPageCount, nodefault};
	__property System::UnicodeString FileName = {read=GetFileName, write=SetFileName};
	__property bool FilterChars = {read=FFilterChars, write=SetFilterChars, nodefault};
	__property bool InHexMode = {read=FInHexMode, write=SetInHexMode, nodefault};
	__property bool IsOpen = {read=FIsOpen, write=SetIsOpen, nodefault};
	
public:
	__fastcall virtual TOvcCustomFileViewer(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomFileViewer(void);
	virtual int __fastcall CheckLine(int LineNum);
	virtual bool __fastcall Search(const System::UnicodeString S, Ovcdata::TSearchOptionSet Options);
	__property int FileSize = {read=FFileSize, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomFileViewer(HWND ParentWindow) : TOvcBaseViewer(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcFileViewer : public TOvcCustomFileViewer
{
	typedef TOvcCustomFileViewer inherited;
	
__published:
	__property Borders;
	__property BorderStyle = {default=1};
	__property BufferPageCount = {default=16};
	__property Caret;
	__property Controller;
	__property ExpandTabs = {default=1};
	__property FileName = {default=0};
	__property FilterChars = {default=1};
	__property FixedFont;
	__property InHexMode = {default=0};
	__property HighlightColors;
	__property IsOpen = {default=0};
	__property LabelInfo;
	__property MarginColor = {default=-16777211};
	__property ScrollBars = {default=3};
	__property ShowBookmarks = {default=1};
	__property ShowCaret = {default=1};
	__property TabSize = {default=8};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnShowStatus;
	__property OnTopLineChanged;
	__property OnUserCommand;
	__property OnClick;
	__property OnDblClick;
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
public:
	/* TOvcCustomFileViewer.Create */ inline __fastcall virtual TOvcFileViewer(System::Classes::TComponent* AOwner) : TOvcCustomFileViewer(AOwner) { }
	/* TOvcCustomFileViewer.Destroy */ inline __fastcall virtual ~TOvcFileViewer(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcFileViewer(HWND ParentWindow) : TOvcCustomFileViewer(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 vwMaxMarkers = System::Int8(0xa);
static const short MaxSmallInt = short(32767);
static const System::Int8 LogBufSize = System::Int8(0xc);
static const System::Word PageBufSize = System::Word(0x1000);
static const System::Int8 MinPageCount = System::Int8(0x2);
static const System::Word MaxPageCount = System::Word(0x200);
static const int LargestQuasiTime = int(0x7fffffff);
}	/* namespace Ovcviewr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCVIEWR)
using namespace Ovcviewr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcviewrHPP

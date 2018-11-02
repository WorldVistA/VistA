// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcedit.pas' rev: 29.00 (Windows)

#ifndef OvceditHPP
#define OvceditHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.MMSystem.hpp>
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
#include <ovccolor.hpp>
#include <ovcconst.hpp>
#include <ovccmd.hpp>
#include <ovcdata.hpp>
#include <ovceditn.hpp>
#include <ovceditu.hpp>
#include <ovcexcpt.hpp>
#include <ovcfxfnt.hpp>
#include <ovcmisc.hpp>
#include <ovcstr.hpp>
#include <ovceditp.hpp>
#include <ovcbordr.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcedit
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcEditorMargin;
class DELPHICLASS TOvcEditorMargins;
class DELPHICLASS TOvcCustomEditor;
class DELPHICLASS TOvcEditor;
class DELPHICLASS TOvcCustomTextFileEditor;
class DELPHICLASS TOvcTextFileEditor;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TEditorErrorEvent)(System::TObject* Sender, System::Word &ErrorCode);

typedef void __fastcall (__closure *TEditorDrawLineEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* EditorCanvas, const System::Types::TRect &Rect, System::WideChar * S, int Len, int Line, int Pos, int Count, int HBLine, int HBCol, int HELine, int HECol, bool &WasDrawn);

enum DECLSPEC_DENUM TOvcMarginSide : unsigned char { msLeft, msRight };

typedef System::Set<char, _DELPHI_SET_CHAR(0), _DELPHI_SET_CHAR(255)> TClipboardChars;

class PASCALIMPLEMENTATION TOvcEditorMargin : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcCustomEditor* FEditor;
	TOvcMarginSide FSide;
	bool FEnabled;
	int FLineWeight;
	Vcl::Graphics::TPenStyle FLineStyle;
	System::Uitypes::TColor FLineColor;
	int FLinePosition;
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetLinePosition(int Value);
	void __fastcall SetLineWeight(int Value);
	void __fastcall SetLineStyle(Vcl::Graphics::TPenStyle Value);
	void __fastcall SetLineColor(System::Uitypes::TColor Value);
	
public:
	__fastcall TOvcEditorMargin(TOvcMarginSide Side, TOvcCustomEditor* AOwner);
	
__published:
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property int LineWeight = {read=FLineWeight, write=SetLineWeight, default=1};
	__property Vcl::Graphics::TPenStyle LineStyle = {read=FLineStyle, write=SetLineStyle, default=0};
	__property System::Uitypes::TColor LineColor = {read=FLineColor, write=SetLineColor, default=0};
	__property int LinePosition = {read=FLinePosition, write=SetLinePosition, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcEditorMargin(void) { }
	
};


class PASCALIMPLEMENTATION TOvcEditorMargins : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	TOvcCustomEditor* FEditor;
	TOvcEditorMargin* FLeftMargin;
	TOvcEditorMargin* FRightMargin;
	
public:
	__fastcall TOvcEditorMargins(TOvcCustomEditor* AOwner);
	__fastcall virtual ~TOvcEditorMargins(void);
	
__published:
	__property TOvcEditorMargin* Right = {read=FRightMargin, write=FRightMargin};
	__property TOvcEditorMargin* Left = {read=FLeftMargin, write=FLeftMargin};
};


class PASCALIMPLEMENTATION TOvcCustomEditor : public Ovceditu::TOvcEditBase
{
	typedef Ovceditu::TOvcEditBase inherited;
	
protected:
	bool FAutoIndent;
	bool FNewStyleIndent;
	TOvcEditorMargins* FMargins;
	Ovcbordr::TOvcBorders* FBorders;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	int FByteLimit;
	TClipboardChars FClipboardChars;
	Ovcfxfnt::TOvcFixedFont* FFixedFont;
	bool FHideSelection;
	Ovccolor::TOvcColors* FHighlightColors;
	bool FInsertMode;
	bool FKeepClipboardChars;
	System::Uitypes::TColor FMarginColor;
	int FParaLengthLimit;
	int FParaLimit;
	bool FReadOnly;
	System::Uitypes::TScrollStyle FScrollBars;
	bool FScrollBarsAlways;
	bool FScrollPastEnd;
	bool FShowBookmarks;
	bool FShowLineNumbers;
	bool FShowRules;
	bool FShowWrapColumn;
	System::Uitypes::TColor FRuleColor;
	System::Byte FTabSize;
	Ovcdata::TTabType FTabType;
	bool FTrimWhiteSpace;
	System::Word FUndoBufferSize;
	bool FWantEnter;
	bool FWantTab;
	System::UnicodeString FWordDelimiters;
	bool FWordWrap;
	bool FWrapAtLeft;
	int FWrapColumn;
	bool FWrapToWindow;
	int FWheelDelta;
	System::Classes::TNotifyEvent FOnChange;
	TEditorDrawLineEvent FOnDrawLine;
	TEditorErrorEvent FOnError;
	Ovcdata::TShowStatusEvent FOnShowStatus;
	Ovcdata::TTopLineChangedEvent FOnTopLineChanged;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	Ovceditu::TMarker edAnchor;
	Vcl::Graphics::TBitmap* edBMGlyphs;
	bool edCapture;
	Ovccaret::TOvcCaretPair* edCaret;
	int edCols;
	int edColWid;
	int edCurCol;
	int edCurLine;
	int edCurPara;
	int edDivisor;
	int edHDelta;
	Ovceditu::TMarker edHltBgn;
	Ovceditu::TOvcTextPos edHltBgnL;
	Ovceditu::TMarker edHltEnd;
	Ovceditu::TOvcTextPos edHltEndL;
	bool edHScroll;
	int edHSMax;
	int edLinePos;
	int edLineNumW;
	Ovceditp::TOvcParaList* edParas;
	bool edPendingHSP;
	bool edPendingVSP;
	bool edPendingVSR;
	TOvcCustomEditor* edPrev;
	bool edRedrawPending;
	int edRowHt;
	int edRows;
	int edeRows;
	HICON edSelCursor;
	bool edSelCursorOn;
	int edTopLine;
	int edTopPara;
	int edTopPos;
	bool edVScroll;
	int edVSMax;
	bool edSuppressChar;
	bool edRectSelect;
	int edRectSelectDiff;
	bool edResettingScrollbars;
	System::StaticArray<int, 1024> edColWidthArray;
	TOvcCustomEditor* __fastcall GetFirstEditor(void);
	Ovccaret::TOvcCaret* __fastcall GetInsCaretType(void);
	Ovccaret::TOvcCaret* __fastcall GetOvrCaretType(void);
	int __fastcall GetLeftColumn(void);
	int __fastcall GetLeftMargin(void);
	void __fastcall SetLeftMargin(int Value);
	int __fastcall GetRightMargin(void);
	void __fastcall SetRightMargin(int Value);
	int __fastcall GetLineCount(void);
	int __fastcall GetLineLength(int LineNum);
	bool __fastcall GetModified(void);
	TOvcCustomEditor* __fastcall GetNextEditor(void);
	System::WideChar * __fastcall GetParaPointer(int ParaNum);
	int __fastcall GetParaLength(int ParaNum);
	TOvcCustomEditor* __fastcall GetPrevEditor(void);
	System::UnicodeString __fastcall GetStringLine(int LineNum);
	System::UnicodeString __fastcall GetTextString(void);
	int __fastcall GetTopLine(void);
	int __fastcall GetVisibleColumns(void);
	int __fastcall GetVisibleRows(void);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetClipboardChars(const TClipboardChars &Value);
	void __fastcall SetFixedFont(Ovcfxfnt::TOvcFixedFont* Value);
	void __fastcall SetHideSelection(bool Value);
	void __fastcall SetInsCaretType(Ovccaret::TOvcCaret* const Value);
	void __fastcall SetInsertMode(bool Value);
	void __fastcall SetKeepClipboardChars(bool Value);
	void __fastcall SetLeftColumn(int Value);
	void __fastcall SetMarginColor(System::Uitypes::TColor C);
	void __fastcall SetNewStyleIndent(bool Value);
	void __fastcall SetModified(bool Value);
	void __fastcall SetOvrCaretType(Ovccaret::TOvcCaret* const Value);
	void __fastcall SetParaLengthLimit(int Value);
	void __fastcall SetParaLimit(int Value);
	void __fastcall SetScrollBars(System::Uitypes::TScrollStyle Value);
	void __fastcall SetScrollBarsAlways(bool Value);
	void __fastcall SetScrollPastEnd(bool Value);
	void __fastcall SetShowBookmarks(bool Value);
	void __fastcall SetShowLineNumbers(bool Value);
	void __fastcall SetShowRules(bool Value);
	void __fastcall SetShowWrapColumn(bool Value);
	void __fastcall SetRuleColor(System::Uitypes::TColor Color);
	void __fastcall SetTabSize(System::Byte Value);
	void __fastcall SetTabType(Ovcdata::TTabType Value);
	void __fastcall SetTextString(const System::UnicodeString Value);
	void __fastcall SetTopLine(int Value);
	void __fastcall SetUndoBufferSize(System::Word Value);
	void __fastcall SetWordDelimiters(const System::UnicodeString Value);
	void __fastcall SetWordWrap(bool Value);
	void __fastcall SetWrapAtLeft(bool Value);
	void __fastcall SetWrapColumn(int Value);
	void __fastcall SetWrapToWindow(bool Value);
	void __fastcall SetWheelDelta(int Value);
	void __fastcall edBorderChanged(System::TObject* ABorder);
	void __fastcall edPaintBorders(void);
	void __fastcall edAdjustWrapColumn(void);
	void __fastcall edBackspace(void);
	void __fastcall edCalcRowColInfo(void);
	bool __fastcall edCaretInWindow(System::Word &Col);
	void __fastcall edCaretLeft(bool Shift);
	void __fastcall edCaretRight(bool Shift);
	void __fastcall edChangeTopLine(int Value);
	void __fastcall edColorChanged(System::TObject* AColor);
	void __fastcall edDeleteLine(void);
	void __fastcall edDeleteSelection(void);
	void __fastcall edDeleteToBeginning(void);
	void __fastcall edDeleteToEnd(void);
	void __fastcall edDeleteWord(void);
	void __fastcall edDetach(void);
	void __fastcall edDoTab(void);
	void __fastcall edFixedFontChanged(System::TObject* Sender);
	int __fastcall edGetEditLine(int LineNum, System::WideChar * Buf, System::Word BufLen);
	int __fastcall edGetIndentLevel(int N, int Col);
	int __fastcall edGetRowHt(void);
	void __fastcall edGetMousePos(int &Line, int &Col);
	bool __fastcall edHaveHighlight(void);
	void __fastcall edHScrollPrim(int Delta);
	void __fastcall edInsertChar(System::WideChar Ch);
	System::Word __fastcall edInsertTextAtCaret(System::WideChar * P);
	bool __fastcall edIsWordDelim(System::WideChar Ch);
	bool __fastcall edIsStringHighlighted(System::WideChar * S, bool MatchCase);
	void __fastcall edMoveCaret(int HDelta, int VDelta, bool MVP, bool DragH);
	void __fastcall edMoveCaretPrim(int HDelta, int VDelta, bool MVP, bool DragH, bool AbsCol);
	void __fastcall edMoveCaretTo(int Line, int Col, bool DragH);
	void __fastcall edMoveCaretToPP(int Para, int Pos, bool DragH);
	void __fastcall edMoveToEndOfLine(bool Shift);
	void __fastcall edNewLine(bool BreakP, bool Follow);
	void __fastcall edPositionCaret(System::Word Col);
	void __fastcall edReadBookmarkGlyphs(void);
	void __fastcall edReadMargin(System::Classes::TReader* Reader);
	void __fastcall edRecreateWnd(void);
	void __fastcall edRedraw(bool Now);
	void __fastcall edRefreshLines(int Start, int Stop);
	System::Word __fastcall edReplaceSelection(System::WideChar * P);
	void __fastcall edResetHighlight(bool Refresh);
	int __fastcall edSearchReplace(System::WideChar * FS, System::WideChar * RS, Ovcdata::TSearchOptionSet Options);
	void __fastcall edSetCaretSize(void);
	void __fastcall edSetHScrollPos(void);
	void __fastcall edSetHScrollRange(void);
	void __fastcall edSetLineNumbersWidth(void);
	void __fastcall edSetSelectionPP(int Para1, int Pos1, int Para2, int Pos2, bool CaretAtEnd);
	void __fastcall edSetSelPrim(int Para1, int Pos1, int Para2, int Pos2);
	void __fastcall edSetVScrollPos(void);
	void __fastcall edSetVScrollRange(void);
	void __fastcall edUpdateVScrollRange(void);
	void __fastcall edUpdateVScrollPos(void);
	void __fastcall edUpdateHighlight(bool Refresh);
	void __fastcall edUpdateHScrollPos(void);
	void __fastcall edVScrollPrim(int Delta);
	void __fastcall edWordLeft(bool Shift);
	void __fastcall edWordRight(bool Shift);
	virtual void __fastcall edUpdateOnDeletedParaPrim(int N, bool Current);
	virtual void __fastcall edUpdateOnDeletedTextPrim(int N, int Pos, int Count, bool Current);
	virtual void __fastcall edUpdateOnInsertedParaPrim(int N, int Pos, int Indent, bool Current);
	virtual void __fastcall edUpdateOnInsertedTextPrim(int N, int Pos, int Count, bool Current);
	virtual void __fastcall edUpdateOnJoinedParasPrim(int N, int Pos, bool Current);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMShowStatus(Ovcdata::TOMShowStatus &Msg);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkGnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMSysKeyDown(Winapi::Messages::TWMKey &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall DoOnChange(void);
	virtual bool __fastcall DoOnDrawLine(Vcl::Graphics::TCanvas* EditorCanvas, const System::Types::TRect &Rect, System::WideChar * S, int Len, int Line, int Pos, int Count, int HBLine, int HBCol, int HELine, int HECol);
	DYNAMIC void __fastcall DoOnError(System::Word ErrorCode);
	DYNAMIC void __fastcall DoOnMouseWheel(System::Classes::TShiftState Shift, short Delta, short XPos, short YPos);
	DYNAMIC void __fastcall DoOnShowStatus(int LineNum, System::Word ColNum);
	DYNAMIC void __fastcall DoOnTopLineChanged(int Line);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	DYNAMIC void __fastcall edAddSampleParas(void);
	DYNAMIC void __fastcall edScrollPrim(int HDelta, int VDelta);
	virtual bool __fastcall GetReadOnly(void);
	virtual void __fastcall SetByteLimit(int Value);
	__property bool AutoIndent = {read=FAutoIndent, write=FAutoIndent, nodefault};
	__property bool NewStyleIndent = {read=FNewStyleIndent, write=SetNewStyleIndent, nodefault};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, nodefault};
	__property int ByteLimit = {read=FByteLimit, write=SetByteLimit, nodefault};
	__property Ovccaret::TOvcCaret* CaretIns = {read=GetInsCaretType, write=SetInsCaretType};
	__property Ovccaret::TOvcCaret* CaretOvr = {read=GetOvrCaretType, write=SetOvrCaretType};
	__property Ovcfxfnt::TOvcFixedFont* FixedFont = {read=FFixedFont, write=SetFixedFont};
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, nodefault};
	__property Ovccolor::TOvcColors* HighlightColors = {read=FHighlightColors, write=FHighlightColors};
	__property bool InsertMode = {read=FInsertMode, write=SetInsertMode, nodefault};
	__property int LeftMargin = {read=GetLeftMargin, write=SetLeftMargin, nodefault};
	__property TOvcEditorMargins* MarginOptions = {read=FMargins, write=FMargins};
	__property int ParaLengthLimit = {read=FParaLengthLimit, write=SetParaLengthLimit, nodefault};
	__property int ParaLimit = {read=FParaLimit, write=SetParaLimit, nodefault};
	__property bool ReadOnly = {read=GetReadOnly, write=FReadOnly, nodefault};
	__property int RightMargin = {read=GetRightMargin, write=SetRightMargin, nodefault};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, nodefault};
	__property bool ScrollBarsAlways = {read=FScrollBarsAlways, write=SetScrollBarsAlways, nodefault};
	__property bool ScrollPastEnd = {read=FScrollPastEnd, write=SetScrollPastEnd, nodefault};
	__property bool ShowBookmarks = {read=FShowBookmarks, write=SetShowBookmarks, nodefault};
	__property bool ShowLineNumbers = {read=FShowLineNumbers, write=SetShowLineNumbers, nodefault};
	__property bool ShowRules = {read=FShowRules, write=SetShowRules, nodefault};
	__property bool ShowWrapColumn = {read=FShowWrapColumn, write=SetShowWrapColumn, nodefault};
	__property System::Uitypes::TColor RuleColor = {read=FRuleColor, write=SetRuleColor, nodefault};
	__property System::Byte TabSize = {read=FTabSize, write=SetTabSize, nodefault};
	__property Ovcdata::TTabType TabType = {read=FTabType, write=SetTabType, nodefault};
	__property bool TrimWhiteSpace = {read=FTrimWhiteSpace, write=FTrimWhiteSpace, nodefault};
	__property System::Word UndoBufferSize = {read=FUndoBufferSize, write=SetUndoBufferSize, nodefault};
	__property bool WantEnter = {read=FWantEnter, write=FWantEnter, nodefault};
	__property bool WantTab = {read=FWantTab, write=FWantTab, nodefault};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, nodefault};
	__property bool WrapAtLeft = {read=FWrapAtLeft, write=SetWrapAtLeft, nodefault};
	__property int WrapColumn = {read=FWrapColumn, write=SetWrapColumn, nodefault};
	__property bool WrapToWindow = {read=FWrapToWindow, write=SetWrapToWindow, nodefault};
	__property int WheelDelta = {read=FWheelDelta, write=SetWheelDelta, nodefault};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TEditorDrawLineEvent OnDrawLine = {read=FOnDrawLine, write=FOnDrawLine};
	__property TEditorErrorEvent OnError = {read=FOnError, write=FOnError};
	__property Ovcdata::TShowStatusEvent OnShowStatus = {read=FOnShowStatus, write=FOnShowStatus};
	__property Ovcdata::TTopLineChangedEvent OnTopLineChanged = {read=FOnTopLineChanged, write=FOnTopLineChanged};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
	
public:
	TOvcCustomEditor* edNext;
	void __fastcall edResetPositionInfo(void);
	void __fastcall edAdjustMargins(void);
	void __fastcall edUpdateOnDeletedPara(int N);
	void __fastcall edUpdateOnDeletedText(int N, int Pos, int Count);
	void __fastcall edUpdateOnInsertedPara(int N, int Pos, int Indent);
	void __fastcall edUpdateOnInsertedText(int N, int Pos, int Count);
	void __fastcall edUpdateOnJoinedParas(int N, int Pos);
	__fastcall virtual TOvcCustomEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomEditor(void);
	System::Word __fastcall AppendPara(System::WideChar * Para);
	virtual void __fastcall Attach(TOvcCustomEditor* Editor);
	void __fastcall BeginUpdate(void);
	bool __fastcall CanRedo(void);
	bool __fastcall CanUndo(void);
	void __fastcall Clear(void);
	void __fastcall ClearSelection(void);
	DYNAMIC void __fastcall ClearMarker(System::Byte N);
	DYNAMIC void __fastcall CopyToClipboard(void);
	DYNAMIC void __fastcall CutToClipboard(void);
	void __fastcall DeleteAll(bool UpdateScreen);
	int __fastcall EffectiveColumn(System::WideChar * S, int Col);
	void __fastcall EndUpdate(void);
	void __fastcall FlushUndoBuffer(void);
	int __fastcall GetCaretPosition(int &Col);
	System::UnicodeString __fastcall GetCurrentWord(void);
	System::WideChar * __fastcall GetLine(int LineNum, System::WideChar * Dest, int DestLen);
	int __fastcall GetMarkerPosition(System::Byte N, int &Col);
	void __fastcall GetMousePos(int &L, int &C, bool Existing);
	System::WideChar * __fastcall GetPara(int ParaNum, System::Word &Len);
	int __fastcall GetPrintableLine(int LineNum, System::WideChar * Dest, int DestLen);
	bool __fastcall GetSelection(int &Line1, int &Col1, int &Line2, int &Col2);
	void __fastcall GotoMarker(System::Byte N);
	int __fastcall GetSelTextBuf(System::WideChar * Buffer, int BufSize);
	int __fastcall GetSelTextLen(void);
	HIDESBASE int __fastcall GetText(System::WideChar * P, int Size);
	HIDESBASE int __fastcall GetTextBuf(System::WideChar * Buffer, int BufSize);
	HIDESBASE int __fastcall GetTextLen(void);
	bool __fastcall HasSelection(void);
	HIDESBASE void __fastcall Insert(System::WideChar * S);
	void __fastcall InsertString(const System::UnicodeString S);
	void __fastcall LineToPara(int &L, int &C);
	int __fastcall ParaCount(void);
	void __fastcall ParaToLine(int &L, int &C);
	DYNAMIC void __fastcall PasteFromClipboard(void);
	DYNAMIC bool __fastcall ProcessCommand(System::Word Cmd, System::Word CharCode);
	DYNAMIC void __fastcall Redo(void);
	void __fastcall Deselect(bool CaretAtEnd);
	DYNAMIC int __fastcall Replace(const System::UnicodeString S, const System::UnicodeString R, Ovcdata::TSearchOptionSet Options);
	void __fastcall ResetScrollBars(bool UpdateScreen);
	bool __fastcall Search(const System::UnicodeString S, Ovcdata::TSearchOptionSet Options);
	void __fastcall SelectAll(bool CaretAtEnd);
	void __fastcall SetCaretPosition(int Line, int Col);
	DYNAMIC void __fastcall SetMarker(System::Byte N);
	DYNAMIC void __fastcall SetMarkerAt(System::Byte N, int Line, int Col);
	void __fastcall SetSelection(int Line1, int Col1, int Line2, int Col2, bool CaretAtEnd);
	void __fastcall SetSelTextBuf(System::WideChar * Buffer);
	HIDESBASE void __fastcall SetText(System::WideChar * P);
	HIDESBASE void __fastcall SetTextBuf(System::WideChar * Buffer);
	DYNAMIC void __fastcall Undo(void);
	void __fastcall XYToLineCol(int X, int Y, int &Line, int &Col);
	__property Ovcbordr::TOvcBorders* Borders = {read=FBorders, write=FBorders};
	__property Canvas;
	__property int ColumnWidth = {read=edColWid, nodefault};
	__property TClipboardChars ClipboardChars = {read=FClipboardChars, write=SetClipboardChars};
	__property TOvcCustomEditor* FirstEditor = {read=GetFirstEditor};
	__property bool KeepClipboardChars = {read=FKeepClipboardChars, write=SetKeepClipboardChars, nodefault};
	__property int LeftColumn = {read=GetLeftColumn, write=SetLeftColumn, nodefault};
	__property System::UnicodeString Lines[int LineNum] = {read=GetStringLine};
	__property int LineCount = {read=GetLineCount, nodefault};
	__property int LineLength[int LineNum] = {read=GetLineLength};
	__property int MaxLength = {read=FByteLimit, write=SetByteLimit, stored=false, nodefault};
	__property System::Uitypes::TColor MarginColor = {read=FMarginColor, write=SetMarginColor, nodefault};
	__property bool Modified = {read=GetModified, write=SetModified, stored=false, nodefault};
	__property TOvcCustomEditor* NextEditor = {read=GetNextEditor};
	__property int ParaLength[int ParaNum] = {read=GetParaLength};
	__property System::WideChar * ParaPointer[int ParaNum] = {read=GetParaPointer};
	__property TOvcCustomEditor* PrevEditor = {read=GetPrevEditor};
	__property int TextLength = {read=GetTextLen, nodefault};
	__property System::UnicodeString Text = {read=GetTextString, write=SetTextString};
	__property int TopLine = {read=GetTopLine, write=SetTopLine, stored=false, nodefault};
	__property int VisibleColumns = {read=GetVisibleColumns, nodefault};
	__property int VisibleRows = {read=GetVisibleRows, nodefault};
	__property System::UnicodeString WordDelimiters = {read=FWordDelimiters, write=SetWordDelimiters, stored=false};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomEditor(HWND ParentWindow) : Ovceditu::TOvcEditBase(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcEditor : public TOvcCustomEditor
{
	typedef TOvcCustomEditor inherited;
	
__published:
	__property AutoIndent = {default=0};
	__property NewStyleIndent = {default=0};
	__property Borders;
	__property BorderStyle = {default=1};
	__property ByteLimit = {default=2147483647};
	__property CaretIns;
	__property CaretOvr;
	__property FixedFont;
	__property HideSelection = {default=1};
	__property HighlightColors;
	__property InsertMode = {default=1};
	__property LabelInfo;
	__property LeftMargin;
	__property MarginColor = {default=-16777211};
	__property MarginOptions;
	__property ParaLengthLimit = {default=32767};
	__property ParaLimit = {default=2147483647};
	__property ReadOnly = {default=0};
	__property RightMargin;
	__property RuleColor = {default=8388608};
	__property ScrollBars = {default=3};
	__property ScrollBarsAlways = {default=0};
	__property ScrollPastEnd = {default=0};
	__property ShowBookmarks = {default=1};
	__property ShowLineNumbers = {default=0};
	__property ShowRules = {default=0};
	__property ShowWrapColumn = {default=0};
	__property TabSize = {default=8};
	__property TabType = {default=0};
	__property TrimWhiteSpace = {default=1};
	__property UndoBufferSize = {default=8192};
	__property WantEnter = {default=1};
	__property WantTab = {default=0};
	__property WordWrap = {default=0};
	__property WrapAtLeft = {default=1};
	__property WrapColumn = {default=80};
	__property WrapToWindow = {default=0};
	__property WheelDelta = {default=1};
	__property OnChange;
	__property OnDrawLine;
	__property OnError;
	__property OnShowStatus;
	__property OnTopLineChanged;
	__property OnUserCommand;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Cursor = {default=-4};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
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
	__property OnMouseWheel;
	__property OnStartDrag;
public:
	/* TOvcCustomEditor.Create */ inline __fastcall virtual TOvcEditor(System::Classes::TComponent* AOwner) : TOvcCustomEditor(AOwner) { }
	/* TOvcCustomEditor.Destroy */ inline __fastcall virtual ~TOvcEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcEditor(HWND ParentWindow) : TOvcCustomEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCustomTextFileEditor : public TOvcCustomEditor
{
	typedef TOvcCustomEditor inherited;
	
protected:
	System::UnicodeString FBackupExt;
	System::UnicodeString FFileName;
	bool FMakeBackup;
	bool FIsOpen;
	System::Sysutils::TEncoding* FEncoding;
	void __fastcall SetFileName(const System::UnicodeString Value);
	void __fastcall SetIsOpen(bool Value);
	void __fastcall SetBackupExt(System::UnicodeString Value);
	void __fastcall SetEncoding(System::Sysutils::TEncoding* Value);
	System::UnicodeString __fastcall teFixFileName(const System::UnicodeString Value);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TOvcCustomTextFileEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomTextFileEditor(void);
	virtual void __fastcall Attach(TOvcCustomEditor* Editor);
	void __fastcall NewFile(const System::UnicodeString Name);
	DYNAMIC void __fastcall LoadFromFile(const System::UnicodeString Name, System::Sysutils::TEncoding* const AEncoding = (System::Sysutils::TEncoding*)(0x0));
	System::Sysutils::TEncoding* __fastcall suggestEncoding(void);
	DYNAMIC void __fastcall SaveToFile(const System::UnicodeString Name, System::Sysutils::TEncoding* const AEncoding = (System::Sysutils::TEncoding*)(0x0));
	__property System::UnicodeString BackupExt = {read=FBackupExt, write=FBackupExt};
	__property System::UnicodeString FileName = {read=FFileName, write=SetFileName};
	__property bool IsOpen = {read=FIsOpen, write=SetIsOpen, nodefault};
	__property bool MakeBackup = {read=FMakeBackup, write=FMakeBackup, nodefault};
	__property System::Sysutils::TEncoding* Encoding = {read=FEncoding, write=SetEncoding};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomTextFileEditor(HWND ParentWindow) : TOvcCustomEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTextFileEditor : public TOvcCustomTextFileEditor
{
	typedef TOvcCustomTextFileEditor inherited;
	
__published:
	__property Borders;
	__property FileName = {default=0};
	__property IsOpen = {default=0};
	__property MakeBackup = {default=0};
	__property BackupExt = {stored=FMakeBackup, default=0};
	__property AutoIndent;
	__property NewStyleIndent = {default=0};
	__property BorderStyle = {default=1};
	__property ByteLimit = {default=2147483647};
	__property CaretIns;
	__property CaretOvr;
	__property FixedFont;
	__property HideSelection = {default=1};
	__property HighlightColors;
	__property InsertMode = {default=1};
	__property LabelInfo;
	__property LeftMargin;
	__property MarginColor = {default=-16777211};
	__property MarginOptions;
	__property ParaLengthLimit = {default=32767};
	__property ParaLimit = {default=2147483647};
	__property ReadOnly = {default=0};
	__property RightMargin;
	__property RuleColor = {default=8388608};
	__property ScrollBars = {default=3};
	__property ScrollBarsAlways = {default=0};
	__property ScrollPastEnd = {default=0};
	__property ShowBookmarks = {default=1};
	__property ShowLineNumbers = {default=0};
	__property ShowRules = {default=0};
	__property ShowWrapColumn = {default=0};
	__property TabSize = {default=8};
	__property TabType = {default=0};
	__property TrimWhiteSpace = {default=1};
	__property UndoBufferSize = {default=8192};
	__property WantEnter = {default=1};
	__property WantTab = {default=0};
	__property WordWrap = {default=0};
	__property WrapAtLeft = {default=1};
	__property WrapColumn = {default=80};
	__property WrapToWindow = {default=0};
	__property WheelDelta = {default=1};
	__property OnChange;
	__property OnDrawLine;
	__property OnError;
	__property OnShowStatus;
	__property OnTopLineChanged;
	__property OnUserCommand;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property Cursor = {default=-4};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
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
	__property OnMouseWheel;
	__property OnStartDrag;
public:
	/* TOvcCustomTextFileEditor.Create */ inline __fastcall virtual TOvcTextFileEditor(System::Classes::TComponent* AOwner) : TOvcCustomTextFileEditor(AOwner) { }
	/* TOvcCustomTextFileEditor.Destroy */ inline __fastcall virtual ~TOvcTextFileEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTextFileEditor(HWND ParentWindow) : TOvcCustomTextFileEditor(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MARGINPAD = System::Int8(0x5);
}	/* namespace Ovcedit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCEDIT)
using namespace Ovcedit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvceditHPP

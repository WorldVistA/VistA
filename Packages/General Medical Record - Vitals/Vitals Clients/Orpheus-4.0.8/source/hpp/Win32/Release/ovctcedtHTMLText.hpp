// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcedtHTMLText.pas' rev: 29.00 (Windows)

#ifndef OvctcedthtmltextHPP
#define OvctcedthtmltextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <ovcbase.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>
#include <ovctcedtTextFormatBar.hpp>
#include <Vcl.Graphics.hpp>
#include <ovctcedt.hpp>
#include <ovcRTF_IText.hpp>
#include <ovcRTF_Paint.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcedthtmltext
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomHtmlTextEditBase;
class DELPHICLASS TOvcCustomHtmlMemo;
class DELPHICLASS TOvcHtmlMemo;
class DELPHICLASS TOvcTCHtmlTextEdit;
class DELPHICLASS TOvcTCCustomHTMLText;
class DELPHICLASS TOvcTCHTMLText;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomHtmlTextEditBase : public Vcl::Comctrls::TRichEdit
{
	typedef Vcl::Comctrls::TRichEdit inherited;
	
private:
	System::Uitypes::TFontStyles FAllowedFontStyles;
	System::UnicodeString __fastcall GetRichText(void);
	void __fastcall SetRichText(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetHTMLTextFrom(Ovcrtf_itext::_di_ITextDocument Doc);
	System::UnicodeString __fastcall GetHTMLText(void);
	void __fastcall SetHTMLText(const System::UnicodeString Value);
	void __fastcall SetAllowedFontStyles(const System::Uitypes::TFontStyles Value);
	HIDESBASE System::UnicodeString __fastcall GetPlainText(void);
	
protected:
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PasteRichtextFromClipboard(void);
	
public:
	__fastcall virtual TOvcCustomHtmlTextEditBase(System::Classes::TComponent* AOwner);
	__property System::UnicodeString RichText = {read=GetRichText, write=SetRichText};
	__property System::UnicodeString HTMLText = {read=GetHTMLText, write=SetHTMLText};
	__property System::UnicodeString PlainText = {read=GetPlainText};
	__classmethod void __fastcall FillIDocument(const Ovcrtf_itext::_di_ITextDocument Doc, System::UnicodeString HtmlText, bool InsertAtCurPos, Vcl::Graphics::TFont* AFont = (Vcl::Graphics::TFont*)(0x0));
	Ovcrtf_itext::_di_ITextDocument __fastcall GetIDoc(void);
	
__published:
	__property System::Uitypes::TFontStyles AllowedFontStyles = {read=FAllowedFontStyles, write=SetAllowedFontStyles, default=7};
public:
	/* TCustomRichEdit.Destroy */ inline __fastcall virtual ~TOvcCustomHtmlTextEditBase(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomHtmlTextEditBase(HWND ParentWindow) : Vcl::Comctrls::TRichEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCustomHtmlMemo : public TOvcCustomHtmlTextEditBase
{
	typedef TOvcCustomHtmlTextEditBase inherited;
	
private:
	Ovctcedttextformatbar::TOvcTextFormatBar* FFormatBar;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
public:
	__fastcall virtual ~TOvcCustomHtmlMemo(void);
public:
	/* TOvcCustomHtmlTextEditBase.Create */ inline __fastcall virtual TOvcCustomHtmlMemo(System::Classes::TComponent* AOwner) : TOvcCustomHtmlTextEditBase(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomHtmlMemo(HWND ParentWindow) : TOvcCustomHtmlTextEditBase(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcHtmlMemo : public TOvcCustomHtmlMemo
{
	typedef TOvcCustomHtmlMemo inherited;
	
__published:
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property Anchors = {default=3};
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Constraints;
	__property Ctl3D;
	__property DoubleBuffered;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property Lines;
	__property MaxLength = {default=0};
	__property OEMConvert = {default=0};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentDoubleBuffered = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ScrollBars = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Touch;
	__property Visible = {default=1};
	__property WantReturns = {default=1};
	__property WantTabs = {default=0};
	__property WordWrap = {default=1};
	__property StyleElements = {default=7};
	__property OnChange;
	__property OnClick;
	__property OnContextPopup;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnGesture;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseActivate;
	__property OnMouseDown;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDock;
	__property OnStartDrag;
public:
	/* TOvcCustomHtmlMemo.Destroy */ inline __fastcall virtual ~TOvcHtmlMemo(void) { }
	
public:
	/* TOvcCustomHtmlTextEditBase.Create */ inline __fastcall virtual TOvcHtmlMemo(System::Classes::TComponent* AOwner) : TOvcCustomHtmlMemo(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcHtmlMemo(HWND ParentWindow) : TOvcCustomHtmlMemo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCHtmlTextEdit : public TOvcCustomHtmlTextEditBase
{
	typedef TOvcCustomHtmlTextEditBase inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TOvcCustomHtmlTextEditBase.Create */ inline __fastcall virtual TOvcTCHtmlTextEdit(System::Classes::TComponent* AOwner) : TOvcCustomHtmlTextEditBase(AOwner) { }
	
public:
	/* TCustomRichEdit.Destroy */ inline __fastcall virtual ~TOvcTCHtmlTextEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCHtmlTextEdit(HWND ParentWindow) : TOvcCustomHtmlTextEditBase(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomHTMLText : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
private:
	System::Uitypes::TFontStyles FAllowedFontStyles;
	Ovctcedttextformatbar::TOvcTextFormatBar* FFormatBar;
	void __fastcall SetAllowedFontStyles(const System::Uitypes::TFontStyles Value);
	
protected:
	TOvcTCHtmlTextEdit* FEdit;
	System::Word FMaxLength;
	bool FWantReturns;
	bool FWantTabs;
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	bool __fastcall GetModified(void);
	__property System::Word MaxLength = {read=FMaxLength, write=FMaxLength, nodefault};
	__property bool WantReturns = {read=FWantReturns, write=FWantReturns, nodefault};
	__property bool WantTabs = {read=FWantTabs, write=FWantTabs, nodefault};
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	virtual void __fastcall tcPaintStrZ(Vcl::Graphics::TCanvas* TblCanvas, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, System::UnicodeString StZ);
	
public:
	__fastcall virtual TOvcTCCustomHTMLText(System::Classes::TComponent* AOwner);
	virtual TOvcTCHtmlTextEdit* __fastcall CreateEditControl(System::Classes::TComponent* AOwner);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	__property bool Modified = {read=GetModified, nodefault};
	__property System::Uitypes::TFontStyles AllowedFontStyles = {read=FAllowedFontStyles, write=SetAllowedFontStyles, default=7};
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomHTMLText(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCHTMLText : public TOvcTCCustomHTMLText
{
	typedef TOvcTCCustomHTMLText inherited;
	
__published:
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property DataStringType = {default=2};
	__property Hint = {default=0};
	__property Margin = {default=4};
	__property MaxLength = {default=0};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property UseASCIIZStrings = {default=1};
	__property UseWordWrap = {default=1};
	__property AllowedFontStyles = {default=7};
	__property OnChange;
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
	__property OnOwnerDraw;
public:
	/* TOvcTCCustomHTMLText.Create */ inline __fastcall virtual TOvcTCHTMLText(System::Classes::TComponent* AOwner) : TOvcTCCustomHTMLText(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCHTMLText(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall StyleΔToHTML(System::Uitypes::TFontStyles Old, System::Uitypes::TFontStyles New);
}	/* namespace Ovctcedthtmltext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCEDTHTMLTEXT)
using namespace Ovctcedthtmltext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcedthtmltextHPP

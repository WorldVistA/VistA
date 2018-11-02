// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcgly.pas' rev: 29.00 (Windows)

#ifndef OvctcglyHPP
#define OvctcglyHPP

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
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctgres.hpp>
#include <ovctcbmp.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcgly
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCGlyphEdit;
class DELPHICLASS TOvcTCCustomGlyph;
class DELPHICLASS TOvcTCGlyph;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCGlyphEdit : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
protected:
	int FValue;
	Ovctcell::TOvcBaseTableCell* FCell;
	int FRow;
	int FCol;
	Ovctcmmn::TOvcCellAttributes FCellAttr;
	void __fastcall SetValue(int V);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
public:
	__fastcall virtual TOvcTCGlyphEdit(System::Classes::TComponent* AOwner);
	virtual void __fastcall Paint(void);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
	__property int Value = {read=FValue, write=SetValue, nodefault};
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TOvcTCGlyphEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCGlyphEdit(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomGlyph : public Ovctcbmp::TOvcTCBaseBitMap
{
	typedef Ovctcbmp::TOvcTCBaseBitMap inherited;
	
protected:
	Ovctgres::TOvcCellGlyphs* FCellGlyphs;
	TOvcTCGlyphEdit* FEdit;
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	void __fastcall SetCellGlyphs(Ovctgres::TOvcCellGlyphs* CBG);
	void __fastcall GlyphsHaveChanged(System::TObject* Sender);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	__property Ovctgres::TOvcCellGlyphs* CellGlyphs = {read=FCellGlyphs, write=SetCellGlyphs};
	
public:
	__fastcall virtual TOvcTCCustomGlyph(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTCCustomGlyph(void);
	virtual TOvcTCGlyphEdit* __fastcall CreateEditControl(void);
	virtual bool __fastcall CanAssignGlyphs(Ovctgres::TOvcCellGlyphs* CBG);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
};


class PASCALIMPLEMENTATION TOvcTCGlyph : public TOvcTCCustomGlyph
{
	typedef TOvcTCCustomGlyph inherited;
	
__published:
	__property AcceptActivationClick = {default=1};
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property CellGlyphs;
	__property Color;
	__property Hint = {default=0};
	__property Margin = {default=4};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property OnClick;
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
	/* TOvcTCCustomGlyph.Create */ inline __fastcall virtual TOvcTCGlyph(System::Classes::TComponent* AOwner) : TOvcTCCustomGlyph(AOwner) { }
	/* TOvcTCCustomGlyph.Destroy */ inline __fastcall virtual ~TOvcTCGlyph(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcgly */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCGLY)
using namespace Ovctcgly;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcglyHPP

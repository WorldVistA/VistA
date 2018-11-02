// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctchdr.pas' rev: 29.00 (Windows)

#ifndef OvctchdrHPP
#define OvctchdrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>
#include <ovcmisc.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctchdr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCCustomColHead;
class DELPHICLASS TOvcTCColHead;
class DELPHICLASS TOvcTCRowHead;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCCustomColHead : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
private:
	bool FShowLetters;
	bool FShowActiveCol;
	
public:
	virtual void __fastcall SetShowLetters(bool SL);
	virtual void __fastcall SetShowActiveCol(bool SAC);
	virtual void __fastcall chColumnsChanged(int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action) = 0 ;
	__fastcall virtual TOvcTCCustomColHead(System::Classes::TComponent* AOwner);
	
__published:
	__property bool ShowLetters = {read=FShowLetters, write=SetShowLetters, default=1};
	__property bool ShowActiveCol = {read=FShowActiveCol, write=SetShowActiveCol, default=0};
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomColHead(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCColHead : public TOvcTCCustomColHead
{
	typedef TOvcTCCustomColHead inherited;
	
protected:
	System::Classes::TStringList* FHeadings;
	void __fastcall SetHeadings(System::Classes::TStringList* H);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	virtual void __fastcall chColumnsChanged(int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action);
	__fastcall virtual TOvcTCColHead(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcTCColHead(void);
	
__published:
	__property System::Classes::TStringList* Headings = {read=FHeadings, write=SetHeadings};
	__property About = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property Font;
	__property Margin = {default=4};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property UseASCIIZStrings = {default=1};
	__property UseWordWrap = {default=0};
	__property ShowEllipsis = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
};


class PASCALIMPLEMENTATION TOvcTCRowHead : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	bool FShowActiveRow;
	bool FShowNumbers;
	void __fastcall SetShowActiveRow(bool SAR);
	void __fastcall SetShowNumbers(bool SN);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	__fastcall virtual TOvcTCRowHead(System::Classes::TComponent* AOwner);
	
__published:
	__property bool ShowActiveRow = {read=FShowActiveRow, write=SetShowActiveRow, default=0};
	__property bool ShowNumbers = {read=FShowNumbers, write=SetShowNumbers, default=1};
	__property About = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property Font;
	__property Margin = {default=4};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property UseASCIIZStrings = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCRowHead(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctchdr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCHDR)
using namespace Ovctchdr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctchdrHPP

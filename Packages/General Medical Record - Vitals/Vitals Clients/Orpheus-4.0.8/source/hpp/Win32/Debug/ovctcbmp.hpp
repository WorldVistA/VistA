// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcbmp.pas' rev: 29.00 (Windows)

#ifndef OvctcbmpHPP
#define OvctcbmpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovcmisc.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcbmp
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCBaseBitMap;
class DELPHICLASS TOvcTCCustomBitMap;
class DELPHICLASS TOvcTCBitMap;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCBaseBitMap : public Ovctcell::TOvcBaseTableCell
{
	typedef Ovctcell::TOvcBaseTableCell inherited;
	
protected:
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
public:
	/* TOvcBaseTableCell.Create */ inline __fastcall virtual TOvcTCBaseBitMap(System::Classes::TComponent* AOwner) : Ovctcell::TOvcBaseTableCell(AOwner) { }
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCBaseBitMap(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomBitMap : public TOvcTCBaseBitMap
{
	typedef TOvcTCBaseBitMap inherited;
	
protected:
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	virtual void __fastcall ResolveAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
public:
	/* TOvcBaseTableCell.Create */ inline __fastcall virtual TOvcTCCustomBitMap(System::Classes::TComponent* AOwner) : TOvcTCBaseBitMap(AOwner) { }
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomBitMap(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCBitMap : public TOvcTCCustomBitMap
{
	typedef TOvcTCCustomBitMap inherited;
	
__published:
	__property AcceptActivationClick = {default=0};
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property Margin = {default=4};
	__property Table;
	__property TableColor = {default=1};
	__property OnOwnerDraw;
public:
	/* TOvcBaseTableCell.Create */ inline __fastcall virtual TOvcTCBitMap(System::Classes::TComponent* AOwner) : TOvcTCCustomBitMap(AOwner) { }
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCBitMap(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcbmp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCBMP)
using namespace Ovctcbmp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcbmpHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcico.pas' rev: 29.00 (Windows)

#ifndef OvctcicoHPP
#define OvctcicoHPP

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
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcico
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCCustomIcon;
class DELPHICLASS TOvcTCIcon;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCCustomIcon : public Ovctcell::TOvcBaseTableCell
{
	typedef Ovctcell::TOvcBaseTableCell inherited;
	
protected:
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	
public:
	virtual void __fastcall ResolveAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
public:
	/* TOvcBaseTableCell.Create */ inline __fastcall virtual TOvcTCCustomIcon(System::Classes::TComponent* AOwner) : Ovctcell::TOvcBaseTableCell(AOwner) { }
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomIcon(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCIcon : public TOvcTCCustomIcon
{
	typedef TOvcTCCustomIcon inherited;
	
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
	/* TOvcBaseTableCell.Create */ inline __fastcall virtual TOvcTCIcon(System::Classes::TComponent* AOwner) : TOvcTCCustomIcon(AOwner) { }
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCIcon(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcico */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCICO)
using namespace Ovctcico;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcicoHPP

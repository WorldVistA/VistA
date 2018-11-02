// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcstr.pas' rev: 29.00 (Windows)

#ifndef OvctcstrHPP
#define OvctcstrHPP

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

//-- user supplied -----------------------------------------------------------

namespace Ovctcstr
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCBaseString;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TEllipsisMode : unsigned char { em_dont_show, em_show, em_show_readonly };

class PASCALIMPLEMENTATION TOvcTCBaseString : public Ovctcell::TOvcBaseTableCell
{
	typedef Ovctcell::TOvcBaseTableCell inherited;
	
protected:
	Ovctcmmn::TOvcTblStringtype FDataStringType;
	bool FUseWordWrap;
	bool FShowEllipsis;
	bool FEllipsisReadonly;
	bool FIgnoreCR;
	System::Classes::TNotifyEvent FOnChange;
	
private:
	bool __fastcall ReadASCIIZStrings(void);
	void __fastcall SetUseASCIIZStrings(const bool Value);
	
protected:
	TEllipsisMode __fastcall GetEllipsisMode(void);
	void __fastcall SetEllipsisMode(TEllipsisMode EM);
	void __fastcall SetDataStringType(Ovctcmmn::TOvcTblStringtype ADST);
	void __fastcall SetUseWordWrap(bool WW);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	virtual void __fastcall tcPaintStrZ(Vcl::Graphics::TCanvas* TblCanvas, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, System::UnicodeString StZ);
	__property Ovctcmmn::TOvcTblStringtype DataStringType = {read=FDataStringType, write=SetDataStringType, default=2};
	__property bool UseASCIIZStrings = {read=ReadASCIIZStrings, write=SetUseASCIIZStrings, default=1};
	__property bool UseWordWrap = {read=FUseWordWrap, write=SetUseWordWrap, nodefault};
	__property TEllipsisMode EllipsisMode = {read=GetEllipsisMode, write=SetEllipsisMode, default=2};
	__property bool ShowEllipsis = {read=FShowEllipsis, write=FShowEllipsis, nodefault};
	__property bool IgnoreCR = {read=FIgnoreCR, write=FIgnoreCR, default=1};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
public:
	__fastcall virtual TOvcTCBaseString(System::Classes::TComponent* AOwner);
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCBaseString(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcstr */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCSTR)
using namespace Ovctcstr;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcstrHPP

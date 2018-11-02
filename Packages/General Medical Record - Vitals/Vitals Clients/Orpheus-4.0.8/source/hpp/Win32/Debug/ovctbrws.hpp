// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctbrws.pas' rev: 29.00 (Windows)

#ifndef OvctbrwsHPP
#define OvctbrwsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <ovcconst.hpp>
#include <ovctcmmn.hpp>
#include <ovcspary.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctbrws
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTableRows;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTableRows : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	Ovctcmmn::TRowStyle operator[](int RowNum) { return List[RowNum]; }
	
protected:
	int FActiveCount;
	Ovcspary::TOvcSparseArray* FList;
	int FDefHeight;
	int FLimit;
	Ovctcmmn::TRowChangeNotifyEvent FOnCfgChanged;
	Ovctcmmn::TRowStyle __fastcall GetRow(int RowNum);
	int __fastcall GetRowHeight(int RowNum);
	bool __fastcall GetRowHidden(int RowNum);
	bool __fastcall GetRowIsSpecial(int RowNum);
	void __fastcall SetDefHeight(int H);
	void __fastcall SetRow(int RowNum, const Ovctcmmn::TRowStyle &RS);
	void __fastcall SetRowHeight(int RowNum, int H);
	void __fastcall SetRowHidden(int RowNum, bool H);
	void __fastcall SetLimit(int RowNum);
	void __fastcall trDoCfgChanged(int RowNum1, int RowNum2, Ovctcmmn::TOvcTblActions Action);
	
public:
	void __fastcall rwScaleHeights(int M, int D);
	__property Ovctcmmn::TRowChangeNotifyEvent OnCfgChanged = {write=FOnCfgChanged};
	__fastcall TOvcTableRows(void);
	__fastcall virtual ~TOvcTableRows(void);
	void __fastcall Append(const Ovctcmmn::TRowStyle &RS);
	void __fastcall Clear(void);
	void __fastcall Delete(int RowNum);
	void __fastcall Exchange(const int RowNum1, const int RowNum2);
	void __fastcall Insert(const int RowNum, const Ovctcmmn::TRowStyle &RS);
	void __fastcall Reset(const int RowNum);
	__property Ovctcmmn::TRowStyle List[int RowNum] = {read=GetRow, write=SetRow/*, default*/};
	__property int Count = {read=FActiveCount, nodefault};
	__property int DefaultHeight = {read=FDefHeight, write=SetDefHeight, nodefault};
	__property int Height[int RowNum] = {read=GetRowHeight, write=SetRowHeight};
	__property bool Hidden[int RowNum] = {read=GetRowHidden, write=SetRowHidden};
	__property bool RowIsSpecial[int RowNum] = {read=GetRowIsSpecial};
	__property int Limit = {read=FLimit, write=SetLimit, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctbrws */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTBRWS)
using namespace Ovctbrws;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctbrwsHPP

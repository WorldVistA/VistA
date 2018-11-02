// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctbcls.pas' rev: 29.00 (Windows)

#ifndef OvctbclsHPP
#define OvctbclsHPP

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
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <ovcconst.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctbcls
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTableColumn;
class DELPHICLASS TOvcTableColumns;
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TOvcTableColumnClass;

class PASCALIMPLEMENTATION TOvcTableColumn : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FDefCell;
	int FNumber;
	Ovctcmmn::TColChangeNotifyEvent FOnColumnChanged;
	Ovctcmmn::TOvcTableAncestor* FTable;
	int FWidth;
	bool FHidden;
	bool FShowRightLine;
	void __fastcall SetDefCell(Ovctcell::TOvcBaseTableCell* BTC);
	void __fastcall SetHidden(bool H);
	void __fastcall SetShowRightLine(bool H);
	void __fastcall SetWidth(int W);
	void __fastcall tcDoColumnChanged(void);
	void __fastcall tcNotifyCellDeletion(Ovctcell::TOvcBaseTableCell* Cell);
	
public:
	__property int Number = {read=FNumber, write=FNumber, nodefault};
	__property Ovctcmmn::TColChangeNotifyEvent OnColumnChanged = {write=FOnColumnChanged};
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcTableColumn(Ovctcmmn::TOvcTableAncestor* ATable);
	__fastcall virtual ~TOvcTableColumn(void);
	__property Ovctcmmn::TOvcTableAncestor* Table = {read=FTable};
	
__published:
	__property Ovctcell::TOvcBaseTableCell* DefaultCell = {read=FDefCell, write=SetDefCell};
	__property bool Hidden = {read=FHidden, write=SetHidden, nodefault};
	__property bool ShowRightLine = {read=FShowRightLine, write=SetShowRightLine, default=1};
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
};


class PASCALIMPLEMENTATION TOvcTableColumns : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TOvcTableColumn* operator[](int ColNum) { return List[ColNum]; }
	
protected:
	System::Classes::TList* FList;
	Ovctcmmn::TColChangeNotifyEvent FOnColumnChanged;
	System::Classes::TStringList* FFixups;
	Ovctcmmn::TOvcTableAncestor* FTable;
	TOvcTableColumnClass tcColumnClass;
	TOvcTableColumn* __fastcall GetCol(int ColNum);
	int __fastcall GetCount(void);
	Ovctcell::TOvcBaseTableCell* __fastcall GetDefaultCell(int ColNum);
	bool __fastcall GetHidden(int ColNum);
	bool __fastcall GetShowRightLine(int ColNum);
	int __fastcall GetWidth(int ColNum);
	void __fastcall SetCol(int ColNum, TOvcTableColumn* C);
	void __fastcall SetCount(int C);
	void __fastcall SetDefaultCell(int ColNum, Ovctcell::TOvcBaseTableCell* C);
	void __fastcall SetHidden(int ColNum, bool H);
	void __fastcall SetShowRightLine(int ColNum, bool H);
	void __fastcall SetWidth(int ColNum, int W);
	void __fastcall SetOnColumnChanged(Ovctcmmn::TColChangeNotifyEvent OC);
	void __fastcall tcDoColumnChanged(int ColNum1, int ColNum2, Ovctcmmn::TOvcTblActions Action);
	
public:
	void __fastcall tcNotifyCellDeletion(Ovctcell::TOvcBaseTableCell* Cell);
	System::Classes::TStringList* __fastcall tcStartLoading(void);
	void __fastcall tcStopLoading(void);
	__property Ovctcmmn::TColChangeNotifyEvent OnColumnChanged = {write=SetOnColumnChanged};
	__fastcall TOvcTableColumns(Ovctcmmn::TOvcTableAncestor* ATable, int ANumber, TOvcTableColumnClass AColumnClass);
	__fastcall virtual ~TOvcTableColumns(void);
	void __fastcall Append(TOvcTableColumn* C);
	void __fastcall Clear(void);
	void __fastcall Delete(int ColNum);
	void __fastcall Exchange(int ColNum1, int ColNum2);
	void __fastcall Insert(const int ColNum, TOvcTableColumn* C);
	__property int Count = {read=GetCount, write=SetCount, nodefault};
	__property Ovctcell::TOvcBaseTableCell* DefaultCell[int ColNum] = {read=GetDefaultCell, write=SetDefaultCell};
	__property bool Hidden[int ColNum] = {read=GetHidden, write=SetHidden};
	__property bool ShowRightLinex[int ColNum] = {read=GetShowRightLine, write=SetShowRightLine};
	__property TOvcTableColumn* List[int ColNum] = {read=GetCol, write=SetCol/*, default*/};
	__property Ovctcmmn::TOvcTableAncestor* Table = {read=FTable, write=FTable};
	__property int Width[int ColNum] = {read=GetWidth, write=SetWidth};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctbcls */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTBCLS)
using namespace Ovctbcls;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctbclsHPP

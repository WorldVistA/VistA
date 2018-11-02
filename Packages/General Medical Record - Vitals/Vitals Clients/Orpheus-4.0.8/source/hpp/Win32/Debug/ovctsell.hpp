// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctsell.pas' rev: 29.00 (Windows)

#ifndef OvctsellHPP
#define OvctsellHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <ovctcmmn.hpp>
#include <ovcmisc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctsell
{
//-- forward type declarations -----------------------------------------------
struct TOvcSelRowRange;
struct TOvcSelRRArray;
class DELPHICLASS TOvcSelectionList;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcSelRowRange
{
public:
	int L;
	int H;
};
#pragma pack(pop)


typedef TOvcSelRRArray *POvcSelRRArray;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TOvcSelRRArray
{
public:
	int RRCount;
	int RRTotal;
	System::StaticArray<TOvcSelRowRange, 268435454> RRs;
};
#pragma pack(pop)


typedef System::StaticArray<POvcSelRRArray, 536870911> TOvcSelColArray;

typedef TOvcSelColArray *POvcSelColArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcSelectionList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TOvcSelColArray *slArray;
	int slColCount;
	int slColWithSelCount;
	int slActiveCol;
	int slActiveRow;
	int slAnchorCol;
	int slAnchorRow;
	int slRowCount;
	int slColMin;
	int slColMax;
	int slRowMin;
	int slRowMax;
	bool slSelecting;
	bool slEmptyRange;
	void __fastcall slDeselectCellRangeInCol(int Row1, int Row2, int ColNum);
	void __fastcall slSelectCellRangeInCol(int Row1, int Row2, int ColNum);
	
public:
	__fastcall TOvcSelectionList(int RowCount, int ColCount);
	__fastcall virtual ~TOvcSelectionList(void);
	void __fastcall DeselectAll(void);
	void __fastcall DeselectCell(int RowNum, int ColNum);
	void __fastcall DeselectCellRange(int FromRow, int FromCol, int ToRow, int ToCol);
	void __fastcall ExtendRange(int RowNum, int ColNum, bool IsSelecting);
	bool __fastcall HaveSelection(void);
	bool __fastcall IsCellSelected(int RowNum, int ColNum);
	void __fastcall Iterate(Ovctcmmn::TSelectionIterator SI, void * ExtraData);
	void __fastcall SelectAll(void);
	void __fastcall SelectCell(int RowNum, int ColNum);
	void __fastcall SelectCellRange(int FromRow, int FromCol, int ToRow, int ToCol);
	void __fastcall SetColCount(int ColCount);
	void __fastcall SetRangeAnchor(int RowNum, int ColNum, Ovctcmmn::TOvcTblSelectionType Action);
	void __fastcall SetRowCount(int RowCount);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctsell */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTSELL)
using namespace Ovctsell;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctsellHPP

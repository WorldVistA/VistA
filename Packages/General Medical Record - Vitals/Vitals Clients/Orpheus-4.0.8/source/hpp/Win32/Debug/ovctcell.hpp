// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcell.pas' rev: 29.00 (Windows)

#ifndef OvctcellHPP
#define OvctcellHPP

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
#include <ovcspary.hpp>
#include <ovcver.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcell
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcBaseTableCell;
class DELPHICLASS TOvcTableCells;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcBaseTableCell : public Ovctcmmn::TOvcTableCellAncestor
{
	typedef Ovctcmmn::TOvcTableCellAncestor inherited;
	
protected:
	System::Uitypes::TColor FColor;
	Vcl::Graphics::TFont* FFont;
	System::UnicodeString FHint;
	int FMargin;
	int FReferences;
	Ovctcmmn::TOvcTableAncestor* FTable;
	System::Uitypes::TColor FTextHiColor;
	bool FAcceptActivationClick;
	Ovctcmmn::TOvcTblAccess FAccess;
	Ovctcmmn::TOvcTblAdjust FAdjust;
	bool FShowHint;
	bool FTableColor;
	bool FTableFont;
	Ovctcmmn::TOvcTextStyle FTextStyle;
	System::Byte Filler;
	System::Classes::TNotifyEvent FOnClick;
	System::Classes::TNotifyEvent FOnDblClick;
	Vcl::Controls::TDragDropEvent FOnDragDrop;
	Vcl::Controls::TDragOverEvent FOnDragOver;
	Vcl::Controls::TEndDragEvent FOnEndDrag;
	System::Classes::TNotifyEvent FOnEnter;
	System::Classes::TNotifyEvent FOnExit;
	Vcl::Controls::TKeyEvent FOnKeyDown;
	Vcl::Controls::TKeyPressEvent FOnKeyPress;
	Vcl::Controls::TKeyEvent FOnKeyUp;
	Vcl::Controls::TMouseEvent FOnMouseDown;
	Vcl::Controls::TMouseMoveEvent FOnMouseMove;
	Vcl::Controls::TMouseEvent FOnMouseUp;
	Ovctcmmn::TCellPaintNotifyEvent FOnOwnerDraw;
	bool tcBadColorValue;
	bool tcBadFontValue;
	bool tcNoConfigChange;
	System::UnicodeString __fastcall GetAbout(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	System::Uitypes::TColor __fastcall GetColor(void);
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	void __fastcall SetAccess(Ovctcmmn::TOvcTblAccess A);
	void __fastcall SetAdjust(Ovctcmmn::TOvcTblAdjust A);
	void __fastcall SetColor(System::Uitypes::TColor C);
	void __fastcall SetFont(Vcl::Graphics::TFont* F);
	void __fastcall SetHint(const System::UnicodeString H);
	void __fastcall SetMargin(int M);
	void __fastcall SetTable(Ovctcmmn::TOvcTableAncestor* T);
	void __fastcall SetTableColor(bool B);
	void __fastcall SetTableFont(bool B);
	void __fastcall SetTextHiColor(System::Uitypes::TColor THC);
	void __fastcall SetTextStyle(Ovctcmmn::TOvcTextStyle TS);
	bool __fastcall IsColorStored(void);
	bool __fastcall IsFontStored(void);
	DYNAMIC void __fastcall tcChangeScale(int M, int D);
	void __fastcall tcFontHasChanged(System::TObject* Sender);
	virtual void __fastcall tcPaint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	void __fastcall tcRetrieveTableColor(void);
	int __fastcall tcRetrieveTableActiveCol(void);
	int __fastcall tcRetrieveTableActiveRow(void);
	void __fastcall tcRetrieveTableFont(void);
	int __fastcall tcRetrieveTableLockedCols(void);
	int __fastcall tcRetrieveTableLockedRows(void);
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=IsColorStored, nodefault};
	__property System::Uitypes::TColor TextHiColor = {read=FTextHiColor, write=SetTextHiColor, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont, stored=IsFontStored};
	__property System::UnicodeString Hint = {read=FHint, write=SetHint};
	__property int Margin = {read=FMargin, write=SetMargin, nodefault};
	__property bool ShowHint = {read=FShowHint, write=FShowHint, nodefault};
	__property bool TableColor = {read=FTableColor, write=SetTableColor, nodefault};
	__property bool TableFont = {read=FTableFont, write=SetTableFont, nodefault};
	__property Ovctcmmn::TOvcTextStyle TextStyle = {read=FTextStyle, write=SetTextStyle, nodefault};
	__property System::Classes::TNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property System::Classes::TNotifyEvent OnDblClick = {read=FOnDblClick, write=FOnDblClick};
	__property Vcl::Controls::TDragDropEvent OnDragDrop = {read=FOnDragDrop, write=FOnDragDrop};
	__property Vcl::Controls::TDragOverEvent OnDragOver = {read=FOnDragOver, write=FOnDragOver};
	__property Vcl::Controls::TEndDragEvent OnEndDrag = {read=FOnEndDrag, write=FOnEndDrag};
	__property System::Classes::TNotifyEvent OnEnter = {read=FOnEnter, write=FOnEnter};
	__property System::Classes::TNotifyEvent OnExit = {read=FOnExit, write=FOnExit};
	__property Vcl::Controls::TKeyEvent OnKeyDown = {read=FOnKeyDown, write=FOnKeyDown};
	__property Vcl::Controls::TKeyPressEvent OnKeyPress = {read=FOnKeyPress, write=FOnKeyPress};
	__property Vcl::Controls::TKeyEvent OnKeyUp = {read=FOnKeyUp, write=FOnKeyUp};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=FOnMouseDown, write=FOnMouseDown};
	__property Vcl::Controls::TMouseMoveEvent OnMouseMove = {read=FOnMouseMove, write=FOnMouseMove};
	__property Vcl::Controls::TMouseEvent OnMouseUp = {read=FOnMouseUp, write=FOnMouseUp};
	__property Ovctcmmn::TCellPaintNotifyEvent OnOwnerDraw = {read=FOnOwnerDraw, write=FOnOwnerDraw};
	
public:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall tcResetTableValues(void);
	virtual bool __fastcall SpecialCellSupported(System::TObject* Field);
	virtual int __fastcall SpecialCellDataSize(void);
	virtual void __fastcall SpecialCellDataTransfer(System::TObject* Field, void * Data, Ovctcmmn::TOvcCellDataPurpose Purpose);
	__fastcall virtual TOvcBaseTableCell(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBaseTableCell(void);
	void __fastcall IncRefs(void);
	void __fastcall DecRefs(void);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual bool __fastcall CanSaveEditedData(bool SaveValue);
	bool __fastcall CanStopEditing(bool SaveValue);
	virtual Ovctcmmn::TOvcTblKeyNeeds __fastcall FilterTableKey(Winapi::Messages::TWMKey &Msg);
	void __fastcall PostMessageToTable(int Msg, int wParam, int lParam);
	void __fastcall SendKeyToTable(Winapi::Messages::TWMKey &Msg);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	bool __fastcall TableWantsEnter(void);
	bool __fastcall TableWantsTab(void);
	virtual bool __fastcall DoOwnerDraw(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	void __fastcall Paint(Vcl::Graphics::TCanvas* TableCanvas, const System::Types::TRect &CellRect, int RowNum, int ColNum, const Ovctcmmn::TOvcCellAttributes &CellAttr, void * Data);
	virtual void __fastcall ResolveAttributes(int RowNum, int ColNum, Ovctcmmn::TOvcCellAttributes &CellAttr);
	__property bool AcceptActivationClick = {read=FAcceptActivationClick, write=FAcceptActivationClick, nodefault};
	__property Ovctcmmn::TOvcTblAccess Access = {read=FAccess, write=SetAccess, nodefault};
	__property Ovctcmmn::TOvcTblAdjust Adjust = {read=FAdjust, write=SetAdjust, nodefault};
	__property Vcl::Controls::TControl* CellEditor = {read=GetCellEditor};
	__property int References = {read=FReferences, nodefault};
	__property Ovctcmmn::TOvcTableAncestor* Table = {read=FTable, write=SetTable};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
};


class PASCALIMPLEMENTATION TOvcTableCells : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	Ovcspary::TOvcSparseArray* FMatrix;
	System::Classes::TNotifyEvent FOnCfgChanged;
	Ovctcmmn::TOvcTableAncestor* FTable;
	int tcCellAttrCount;
	Ovctcmmn::TOvcTblAccess __fastcall GetAccess(int RowNum, int ColNum);
	Ovctcmmn::TOvcTblAdjust __fastcall GetAdjust(int RowNum, int ColNum);
	TOvcBaseTableCell* __fastcall GetCell(int RowNum, int ColNum);
	System::Uitypes::TColor __fastcall GetColor(int RowNum, int ColNum);
	Vcl::Graphics::TFont* __fastcall GetFont(int RowNum, int ColNum);
	void __fastcall SetAccess(int RowNum, int ColNum, Ovctcmmn::TOvcTblAccess A);
	void __fastcall SetAdjust(int RowNum, int ColNum, Ovctcmmn::TOvcTblAdjust A);
	void __fastcall SetCell(int RowNum, int ColNum, TOvcBaseTableCell* BTC);
	void __fastcall SetColor(int RowNum, int ColNum, System::Uitypes::TColor C);
	void __fastcall SetFont(int RowNum, int ColNum, Vcl::Graphics::TFont* F);
	
public:
	void __fastcall tcNotifyCellDeletion(TOvcBaseTableCell* Cell);
	void __fastcall tcDoCfgChanged(void);
	__property System::Classes::TNotifyEvent OnCfgChanged = {write=FOnCfgChanged};
	__property Ovctcmmn::TOvcTableAncestor* Table = {read=FTable, write=FTable};
	__fastcall TOvcTableCells(Ovctcmmn::TOvcTableAncestor* ATable);
	__fastcall virtual ~TOvcTableCells(void);
	void __fastcall DeleteCol(int ColNum);
	void __fastcall DeleteRow(int RowNum);
	void __fastcall ExchangeCols(int ColNum1, int ColNum2);
	void __fastcall ExchangeRows(int RowNum1, int RowNum2);
	void __fastcall InsertCol(int ColNum);
	void __fastcall InsertRow(int RowNum);
	void __fastcall ResetCell(int RowNum, int ColNum);
	void __fastcall ResolveFullAttr(int RowNum, int ColNum, Ovctcmmn::TOvcSparseAttr &SCA);
	__property Ovctcmmn::TOvcTblAccess Access[int RowNum][int ColNum] = {read=GetAccess, write=SetAccess};
	__property Ovctcmmn::TOvcTblAdjust Adjust[int RowNum][int ColNum] = {read=GetAdjust, write=SetAdjust};
	__property TOvcBaseTableCell* Cell[int RowNum][int ColNum] = {read=GetCell, write=SetCell/*, default*/};
	__property System::Uitypes::TColor Color[int RowNum][int ColNum] = {read=GetColor, write=SetColor};
	__property Vcl::Graphics::TFont* Font[int RowNum][int ColNum] = {read=GetFont, write=SetFont};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcell */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCELL)
using namespace Ovctcell;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcellHPP

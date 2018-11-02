// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcedt.pas' rev: 29.00 (Windows)

#ifndef OvctcedtHPP
#define OvctcedtHPP

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
#include <ovcbase.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcstr.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcedt
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCStringEdit;
class DELPHICLASS TOvcTCCustomString;
class DELPHICLASS TOvcTCString;
class DELPHICLASS TOvcTCMemoEdit;
class DELPHICLASS TOvcTCCustomMemo;
class DELPHICLASS TOvcTCMemo;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCStringEdit : public Vcl::Stdctrls::TEdit
{
	typedef Vcl::Stdctrls::TEdit inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TCustomEdit.Create */ inline __fastcall virtual TOvcTCStringEdit(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCStringEdit(HWND ParentWindow) : Vcl::Stdctrls::TEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TOvcTCStringEdit(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomString : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	TOvcTCStringEdit* FEdit;
	System::Word FMaxLength;
	bool FAutoAdvanceChar;
	bool FAutoAdvanceLeftRight;
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	bool __fastcall GetModified(void);
	__property bool AutoAdvanceChar = {read=FAutoAdvanceChar, write=FAutoAdvanceChar, nodefault};
	__property bool AutoAdvanceLeftRight = {read=FAutoAdvanceLeftRight, write=FAutoAdvanceLeftRight, nodefault};
	__property System::Word MaxLength = {read=FMaxLength, write=FMaxLength, nodefault};
	
public:
	virtual TOvcTCStringEdit* __fastcall CreateEditControl(System::Classes::TComponent* AOwner);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	__property bool Modified = {read=GetModified, nodefault};
public:
	/* TOvcTCBaseString.Create */ inline __fastcall virtual TOvcTCCustomString(System::Classes::TComponent* AOwner) : Ovctcstr::TOvcTCBaseString(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomString(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCString : public TOvcTCCustomString
{
	typedef TOvcTCCustomString inherited;
	
__published:
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property AutoAdvanceChar = {default=0};
	__property AutoAdvanceLeftRight = {default=0};
	__property Color;
	__property EllipsisMode = {default=2};
	__property Font;
	__property Hint = {default=0};
	__property IgnoreCR = {default=1};
	__property Margin = {default=4};
	__property MaxLength = {default=0};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property UseWordWrap = {default=0};
	__property DataStringType = {default=2};
	__property UseASCIIZStrings = {default=1};
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
	/* TOvcTCBaseString.Create */ inline __fastcall virtual TOvcTCString(System::Classes::TComponent* AOwner) : TOvcTCCustomString(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCString(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCMemoEdit : public Vcl::Stdctrls::TMemo
{
	typedef Vcl::Stdctrls::TMemo inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TCustomMemo.Create */ inline __fastcall virtual TOvcTCMemoEdit(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TMemo(AOwner) { }
	/* TCustomMemo.Destroy */ inline __fastcall virtual ~TOvcTCMemoEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCMemoEdit(HWND ParentWindow) : Vcl::Stdctrls::TMemo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomMemo : public Ovctcstr::TOvcTCBaseString
{
	typedef Ovctcstr::TOvcTCBaseString inherited;
	
protected:
	TOvcTCMemoEdit* FEdit;
	System::Word FMaxLength;
	bool FWantReturns;
	bool FWantTabs;
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	bool __fastcall GetModified(void);
	__property System::Word MaxLength = {read=FMaxLength, write=FMaxLength, nodefault};
	__property bool WantReturns = {read=FWantReturns, write=FWantReturns, nodefault};
	__property bool WantTabs = {read=FWantTabs, write=FWantTabs, nodefault};
	
public:
	__fastcall virtual TOvcTCCustomMemo(System::Classes::TComponent* AOwner);
	virtual TOvcTCMemoEdit* __fastcall CreateEditControl(System::Classes::TComponent* AOwner);
	virtual NativeUInt __fastcall EditHandle(void);
	virtual void __fastcall EditHide(void);
	virtual void __fastcall EditMove(const System::Types::TRect &CellRect);
	virtual void __fastcall SaveEditedData(void * Data);
	virtual void __fastcall StartEditing(int RowNum, int ColNum, const System::Types::TRect &CellRect, const Ovctcmmn::TOvcCellAttributes &CellAttr, Ovctcmmn::TOvcTblEditorStyle CellStyle, void * Data);
	virtual void __fastcall StopEditing(bool SaveValue, void * Data);
	__property bool Modified = {read=GetModified, nodefault};
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomMemo(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCMemo : public TOvcTCCustomMemo
{
	typedef TOvcTCCustomMemo inherited;
	
__published:
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property Color;
	__property DataStringType = {default=2};
	__property EllipsisMode = {default=2};
	__property Font;
	__property Hint = {default=0};
	__property IgnoreCR = {default=1};
	__property Margin = {default=4};
	__property MaxLength = {default=0};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextStyle = {default=0};
	__property UseASCIIZStrings = {default=1};
	__property UseWordWrap = {default=1};
	__property WantReturns = {default=0};
	__property WantTabs = {default=0};
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
	/* TOvcTCCustomMemo.Create */ inline __fastcall virtual TOvcTCMemo(System::Classes::TComponent* AOwner) : TOvcTCCustomMemo(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCMemo(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcedt */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCEDT)
using namespace Ovctcedt;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcedtHPP

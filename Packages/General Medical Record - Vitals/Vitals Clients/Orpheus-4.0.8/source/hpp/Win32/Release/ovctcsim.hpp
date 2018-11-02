// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcsim.pas' rev: 29.00 (Windows)

#ifndef OvctcsimHPP
#define OvctcsimHPP

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
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcsf.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcbef.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcbase.hpp>
#include <ovctcstr.hpp>
#include <ovccaret.hpp>
#include <System.UITypes.hpp>
#include <ovccmd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcsim
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCSimpleFieldEdit;
class DELPHICLASS TOvcTCCustomSimpleField;
class DELPHICLASS TOvcTCSimpleField;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCSimpleFieldEdit : public Ovcsf::TOvcSimpleField
{
	typedef Ovcsf::TOvcSimpleField inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	DYNAMIC void __fastcall efMoveFocusToNextField(void);
	DYNAMIC void __fastcall efMoveFocusToPrevField(void);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
__published:
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TOvcCustomSimpleField.Create */ inline __fastcall virtual TOvcTCSimpleFieldEdit(System::Classes::TComponent* AOwner) : Ovcsf::TOvcSimpleField(AOwner) { }
	
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcTCSimpleFieldEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCSimpleFieldEdit(HWND ParentWindow) : Ovcsf::TOvcSimpleField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomSimpleField : public Ovctcbef::TOvcTCBaseEntryField
{
	typedef Ovctcbef::TOvcTCBaseEntryField inherited;
	
protected:
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	Ovcsf::TSimpleDataType __fastcall GetDataType(void);
	System::WideChar __fastcall GetPictureMask(void);
	void __fastcall SetDataType(Ovcsf::TSimpleDataType DT);
	void __fastcall SetPictureMask(System::WideChar PM);
	__property Ovcsf::TSimpleDataType DataType = {read=GetDataType, write=SetDataType, nodefault};
	__property System::WideChar PictureMask = {read=GetPictureMask, write=SetPictureMask, nodefault};
	
public:
	virtual Ovcef::TOvcBaseEntryField* __fastcall CreateEntryField(System::Classes::TComponent* AOwner);
public:
	/* TOvcTCBaseEntryField.Create */ inline __fastcall virtual TOvcTCCustomSimpleField(System::Classes::TComponent* AOwner) : Ovctcbef::TOvcTCBaseEntryField(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomSimpleField(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCSimpleField : public TOvcTCCustomSimpleField
{
	typedef TOvcTCCustomSimpleField inherited;
	
__published:
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property CaretIns;
	__property CaretOvr;
	__property Color;
	__property ControlCharColor = {default=255};
	__property DataStringType = {default=2};
	__property DataType = {default=0};
	__property DecimalPlaces = {default=0};
	__property EFColors;
	__property EllipsisMode = {default=2};
	__property Font;
	__property Hint = {default=0};
	__property Margin = {default=4};
	__property MaxLength = {default=15};
	__property Options = {default=2050};
	__property PadChar = {default=32};
	__property PasswordChar = {default=42};
	__property PictureMask = {default=88};
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property ShowHint = {default=0};
	__property Table;
	__property TableColor = {default=1};
	__property TableFont = {default=1};
	__property TextHiColor = {default=-16777196};
	__property TextMargin = {default=2};
	__property TextStyle = {default=0};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnError;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnOwnerDraw;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcTCBaseEntryField.Create */ inline __fastcall virtual TOvcTCSimpleField(System::Classes::TComponent* AOwner) : TOvcTCCustomSimpleField(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCSimpleField(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcsim */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCSIM)
using namespace Ovctcsim;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcsimHPP

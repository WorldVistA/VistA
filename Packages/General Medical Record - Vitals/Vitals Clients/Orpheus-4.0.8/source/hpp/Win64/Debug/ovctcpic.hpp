// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcpic.pas' rev: 29.00 (Windows)

#ifndef OvctcpicHPP
#define OvctcpicHPP

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
#include <ovcef.hpp>
#include <ovcpf.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctcbef.hpp>
#include <ovcuser.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcpb.hpp>
#include <ovcbase.hpp>
#include <ovctcstr.hpp>
#include <ovccaret.hpp>
#include <System.UITypes.hpp>
#include <ovccmd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcpic
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcTCPictureFieldEdit;
class DELPHICLASS TOvcTCCustomPictureField;
class DELPHICLASS TOvcTCPictureField;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcTCPictureFieldEdit : public Ovcpf::TOvcPictureField
{
	typedef Ovcpf::TOvcPictureField inherited;
	
protected:
	Ovctcell::TOvcBaseTableCell* FCell;
	DYNAMIC void __fastcall efMoveFocusToNextField(void);
	DYNAMIC void __fastcall efMoveFocusToPrevField(void);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	
public:
	__property Ovctcell::TOvcBaseTableCell* CellOwner = {read=FCell, write=FCell};
public:
	/* TOvcCustomPictureField.Create */ inline __fastcall virtual TOvcTCPictureFieldEdit(System::Classes::TComponent* AOwner) : Ovcpf::TOvcPictureField(AOwner) { }
	
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcTCPictureFieldEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcTCPictureFieldEdit(HWND ParentWindow) : Ovcpf::TOvcPictureField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcTCCustomPictureField : public Ovctcbef::TOvcTCBaseEntryField
{
	typedef Ovctcbef::TOvcTCBaseEntryField inherited;
	
protected:
	virtual Vcl::Controls::TControl* __fastcall GetCellEditor(void);
	Ovcpf::TPictureDataType __fastcall GetDataType(void);
	int __fastcall GetEpoch(void);
	System::UnicodeString __fastcall GetPictureMask(void);
	short __fastcall GetFloatScale(void);
	Ovcuser::TOvcUserData* __fastcall GetUserData(void);
	void __fastcall SetDataType(Ovcpf::TPictureDataType DT);
	void __fastcall SetEpoch(int E);
	void __fastcall SetPictureMask(const System::UnicodeString PM);
	void __fastcall SetFloatScale(short FS);
	void __fastcall SetUserData(Ovcuser::TOvcUserData* UD);
	__property Ovcpf::TPictureDataType DataType = {read=GetDataType, write=SetDataType, nodefault};
	__property int Epoch = {read=GetEpoch, write=SetEpoch, nodefault};
	__property System::UnicodeString PictureMask = {read=GetPictureMask, write=SetPictureMask};
	__property short FloatScale = {read=GetFloatScale, write=SetFloatScale, nodefault};
	
public:
	virtual Ovcef::TOvcBaseEntryField* __fastcall CreateEntryField(System::Classes::TComponent* AOwner);
	__property Ovcuser::TOvcUserData* UserData = {read=GetUserData, write=SetUserData};
public:
	/* TOvcTCBaseEntryField.Create */ inline __fastcall virtual TOvcTCCustomPictureField(System::Classes::TComponent* AOwner) : Ovctcbef::TOvcTCBaseEntryField(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCCustomPictureField(void) { }
	
};


class PASCALIMPLEMENTATION TOvcTCPictureField : public TOvcTCCustomPictureField
{
	typedef TOvcTCCustomPictureField inherited;
	
__published:
	__property DataType = {default=0};
	__property PictureMask = {default=0};
	__property MaxLength = {default=15};
	__property Access = {default=0};
	__property Adjust = {default=0};
	__property CaretIns;
	__property CaretOvr;
	__property Color;
	__property ControlCharColor = {default=255};
	__property DataStringType = {default=2};
	__property DecimalPlaces = {default=0};
	__property EFColors;
	__property EllipsisMode = {default=2};
	__property Epoch = {default=0};
	__property FloatScale = {default=0};
	__property Font;
	__property Hint = {default=0};
	__property Margin = {default=4};
	__property Options = {default=2};
	__property PadChar = {default=32};
	__property PasswordChar = {default=42};
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
	/* TOvcTCBaseEntryField.Create */ inline __fastcall virtual TOvcTCPictureField(System::Classes::TComponent* AOwner) : TOvcTCCustomPictureField(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TOvcTCPictureField(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcpic */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCPIC)
using namespace Ovctcpic;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcpicHPP

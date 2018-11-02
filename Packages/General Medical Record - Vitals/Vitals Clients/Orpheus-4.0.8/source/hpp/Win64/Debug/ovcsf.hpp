// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcsf.pas' rev: 29.00 (Windows)

#ifndef OvcsfHPP
#define OvcsfHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovccolor.hpp>
#include <ovccaret.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcexcpt.hpp>
#include <ovcintl.hpp>
#include <ovcmisc.hpp>
#include <ovcstr.hpp>
#include <Winapi.Imm.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Forms.hpp>
#include <ovcbordr.hpp>
#include <Vcl.Menus.hpp>
#include <ovccmd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcsf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomSimpleField;
class DELPHICLASS TOvcSimpleField;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSimpleDataType : unsigned char { sftString, sftChar, sftBoolean, sftYesNo, sftLongInt, sftWord, sftInteger, sftByte, sftShortInt, sftReal, sftExtended, sftDouble, sftSingle, sftComp };

class PASCALIMPLEMENTATION TOvcCustomSimpleField : public Ovcef::TOvcBaseEntryField
{
	typedef Ovcef::TOvcBaseEntryField inherited;
	
protected:
	TSimpleDataType FSimpleDataType;
	System::WideChar FPictureMask;
	System::Byte __fastcall sfGetDataType(TSimpleDataType Value);
	void __fastcall sfResetFieldProperties(TSimpleDataType FT);
	void __fastcall sfSetDefaultRanges(void);
	MESSAGE void __fastcall WMImeComposition(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall efEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd);
	virtual System::WideChar * __fastcall efGetDisplayString(System::WideChar * Dest, System::Word Size);
	DYNAMIC void __fastcall efIncDecValue(bool Wrap, double Delta);
	virtual System::Word __fastcall efTransfer(void * DataPtr, System::Word TransferFlag);
	virtual void __fastcall sfSetDataType(TSimpleDataType Value);
	virtual void __fastcall sfSetPictureMask(System::WideChar Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcCustomSimpleField(System::Classes::TComponent* AOwner);
	virtual System::Word __fastcall efValidateField(void);
	__property TSimpleDataType DataType = {read=FSimpleDataType, write=sfSetDataType, nodefault};
	__property System::WideChar PictureMask = {read=FPictureMask, write=sfSetPictureMask, nodefault};
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcCustomSimpleField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomSimpleField(HWND ParentWindow) : Ovcef::TOvcBaseEntryField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSimpleField : public TOvcCustomSimpleField
{
	typedef TOvcCustomSimpleField inherited;
	
__published:
	__property DataType;
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property CaretIns;
	__property CaretOvr;
	__property Color = {default=-16777211};
	__property ControlCharColor;
	__property Controller;
	__property Ctl3D;
	__property Borders;
	__property DecimalPlaces;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property EFColors;
	__property Enabled = {default=1};
	__property Font;
	__property LabelInfo;
	__property MaxLength = {default=15};
	__property Options = {default=2050};
	__property PadChar = {default=32};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PasswordChar = {default=42};
	__property PictureMask;
	__property PopupMenu;
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Tag = {default=0};
	__property TextMargin = {default=2};
	__property Uninitialized = {default=0};
	__property Visible = {default=1};
	__property ZeroDisplay = {default=0};
	__property ZeroDisplayValue = {default=0};
	__property AfterEnter;
	__property AfterExit;
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
	__property OnStartDrag;
	__property OnMouseWheel;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcCustomSimpleField.Create */ inline __fastcall virtual TOvcSimpleField(System::Classes::TComponent* AOwner) : TOvcCustomSimpleField(AOwner) { }
	
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcSimpleField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSimpleField(HWND ParentWindow) : TOvcCustomSimpleField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcsf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCSF)
using namespace Ovcsf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcsfHPP

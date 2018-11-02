// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcpf.pas' rev: 29.00 (Windows)

#ifndef OvcpfHPP
#define OvcpfHPP

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
#include <ovccaret.hpp>
#include <ovccolor.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <ovcpb.hpp>
#include <ovcstr.hpp>
#include <ovcdate.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Forms.hpp>
#include <ovcbordr.hpp>
#include <Vcl.Menus.hpp>
#include <ovccmd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcpf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomPictureField;
class DELPHICLASS TOvcPictureField;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TPictureDataType : unsigned char { pftString, pftChar, pftBoolean, pftYesNo, pftLongInt, pftWord, pftInteger, pftByte, pftShortInt, pftReal, pftExtended, pftDouble, pftSingle, pftComp, pftDate, pftTime, pftDateTime };

class PASCALIMPLEMENTATION TOvcCustomPictureField : public Ovcpb::TOvcPictureBase
{
	typedef Ovcpb::TOvcPictureBase inherited;
	
protected:
	bool FInitDateTime;
	TPictureDataType FPictureDataType;
	System::UnicodeString FPictureMask;
	short FFloatScale;
	void __fastcall SetInitDateTime(bool Value);
	System::Byte __fastcall pfGetDataType(TPictureDataType Value);
	void __fastcall pfResetFieldProperties(TPictureDataType FT);
	void __fastcall pfSetDefaultRanges(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall efEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd);
	DYNAMIC void __fastcall efIncDecValue(bool Wrap, double Delta);
	virtual System::Word __fastcall efTransfer(void * DataPtr, System::Word TransferFlag);
	virtual void __fastcall pfSetDataType(TPictureDataType Value);
	virtual void __fastcall pfSetPictureMask(const System::UnicodeString Value);
	virtual void __fastcall SetAsString(const System::UnicodeString Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcCustomPictureField(System::Classes::TComponent* AOwner);
	virtual System::Word __fastcall efValidateField(void);
	__property TPictureDataType DataType = {read=FPictureDataType, write=pfSetDataType, nodefault};
	__property bool InitDateTime = {read=FInitDateTime, write=SetInitDateTime, nodefault};
	__property System::UnicodeString PictureMask = {read=FPictureMask, write=pfSetPictureMask};
	__property short FloatScale = {read=FFloatScale, write=FFloatScale, nodefault};
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcCustomPictureField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomPictureField(HWND ParentWindow) : Ovcpb::TOvcPictureBase(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcPictureField : public TOvcCustomPictureField
{
	typedef TOvcCustomPictureField inherited;
	
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
	__property Controller;
	__property ControlCharColor;
	__property Ctl3D;
	__property Borders;
	__property DecimalPlaces;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property EFColors;
	__property Enabled = {default=1};
	__property Epoch;
	__property Font;
	__property FloatScale = {default=0};
	__property InitDateTime;
	__property LabelInfo;
	__property MaxLength = {default=15};
	__property Options = {default=2050};
	__property PadChar = {default=32};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PasswordChar = {default=42};
	__property PictureMask = {default=0};
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
	__property OnGetEpoch;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnStartDrag;
	__property OnUserCommand;
	__property OnUserValidation;
public:
	/* TOvcCustomPictureField.Create */ inline __fastcall virtual TOvcPictureField(System::Classes::TComponent* AOwner) : TOvcCustomPictureField(AOwner) { }
	
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcPictureField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcPictureField(HWND ParentWindow) : TOvcCustomPictureField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcpf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCPF)
using namespace Ovcpf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcpfHPP

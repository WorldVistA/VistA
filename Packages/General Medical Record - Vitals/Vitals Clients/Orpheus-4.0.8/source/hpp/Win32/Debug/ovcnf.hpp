// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcnf.pas' rev: 29.00 (Windows)

#ifndef OvcnfHPP
#define OvcnfHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
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
#include <Winapi.Imm.hpp>
#include <System.UITypes.hpp>
#include <ovcbordr.hpp>
#include <ovccmd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcnf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomNumericField;
class DELPHICLASS TOvcNumericField;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TNumericDataType : unsigned char { nftLongInt, nftWord, nftInteger, nftByte, nftShortInt, nftReal, nftExtended, nftDouble, nftSingle, nftComp };

class PASCALIMPLEMENTATION TOvcCustomNumericField : public Ovcpb::TOvcPictureBase
{
	typedef Ovcpb::TOvcPictureBase inherited;
	
protected:
	TNumericDataType FNumericDataType;
	System::UnicodeString FPictureMask;
	System::Word nfMaxLen;
	System::Word nfMaxDigits;
	System::Word nfPlaces;
	bool nfMinus;
	Ovcdata::TEditString nfTmp;
	System::Byte __fastcall nfGetDataType(TNumericDataType Value);
	void __fastcall nfReloadTmp(void);
	void __fastcall nfResetFieldProperties(TNumericDataType FT);
	void __fastcall nfSetDefaultRanges(void);
	void __fastcall nfSetMaxLength(System::WideChar * Mask);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	MESSAGE void __fastcall WMImeComposition(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall efCaretToEnd(void);
	virtual void __fastcall efCaretToStart(void);
	DYNAMIC void __fastcall efChangeMask(System::WideChar * Mask);
	virtual void __fastcall efEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd);
	virtual System::WideChar * __fastcall efGetDisplayString(System::WideChar * Dest, System::Word Size);
	DYNAMIC void __fastcall efIncDecValue(bool Wrap, double Delta);
	virtual System::Word __fastcall efTransfer(void * DataPtr, System::Word TransferFlag);
	virtual void __fastcall pbRemoveSemiLits(void);
	virtual void __fastcall efSetCaretPos(int Value);
	virtual void __fastcall nfSetDataType(TNumericDataType Value);
	virtual void __fastcall nfSetPictureMask(const System::UnicodeString Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcCustomNumericField(System::Classes::TComponent* AOwner);
	virtual System::Word __fastcall efValidateField(void);
	__property TNumericDataType DataType = {read=FNumericDataType, write=nfSetDataType, nodefault};
	__property System::UnicodeString PictureMask = {read=FPictureMask, write=nfSetPictureMask};
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcCustomNumericField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomNumericField(HWND ParentWindow) : Ovcpb::TOvcPictureBase(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcNumericField : public TOvcCustomNumericField
{
	typedef TOvcCustomNumericField inherited;
	
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
	__property Ctl3D;
	__property Borders;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property EFColors;
	__property Enabled = {default=1};
	__property Font;
	__property LabelInfo;
	__property Options = {default=2050};
	__property PadChar = {default=32};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
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
	/* TOvcCustomNumericField.Create */ inline __fastcall virtual TOvcNumericField(System::Classes::TComponent* AOwner) : TOvcCustomNumericField(AOwner) { }
	
public:
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TOvcNumericField(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcNumericField(HWND ParentWindow) : TOvcCustomNumericField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcnf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCNF)
using namespace Ovcnf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcnfHPP

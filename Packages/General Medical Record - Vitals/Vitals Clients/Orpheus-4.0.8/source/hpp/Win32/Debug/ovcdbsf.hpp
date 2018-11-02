// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbsf.pas' rev: 29.00 (Windows)

#ifndef OvcdbsfHPP
#define OvcdbsfHPP

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
#include <Data.DB.hpp>
#include <Data.DBConsts.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovccaret.hpp>
#include <ovccmd.hpp>
#include <ovccolor.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcef.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <ovcsf.hpp>
#include <ovcbordr.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbsf
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbSimpleField;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbSimpleField : public Ovcsf::TOvcCustomSimpleField
{
	typedef Ovcsf::TOvcCustomSimpleField inherited;
	
protected:
	Vcl::Controls::TControlCanvas* FCanvas;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	Data::Db::TFieldType FFieldType;
	bool FUseTFieldMask;
	bool FZeroAsNull;
	bool efdbBusy;
	Ovcdata::TDbEntryFieldState sfdbState;
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TField* __fastcall GetField(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetFieldType(Data::Db::TFieldType Value);
	void __fastcall SetUseTFieldMask(bool Value);
	void __fastcall SetZeroAsNull(bool Value);
	void __fastcall sfdbDataChange(System::TObject* Sender);
	void __fastcall sfdbEditingChange(System::TObject* Sender);
	void __fastcall sfdbGetFieldValue(void);
	void __fastcall sfdbSetFieldProperties(void);
	void __fastcall sfdbSetFieldValue(void);
	void __fastcall sfdbUpdateData(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall DoOnChange(void);
	virtual void __fastcall efEdit(Winapi::Messages::TMessage &Msg, System::Word Cmd);
	DYNAMIC void __fastcall efGetSampleDisplayData(System::WideChar * T);
	DYNAMIC void __fastcall efIncDecValue(bool Wrap, double Delta);
	virtual bool __fastcall efIsReadOnly(void);
	
public:
	__fastcall virtual TOvcDbSimpleField(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbSimpleField(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC void __fastcall Restore(void);
	DYNAMIC void __fastcall CutToClipboard(void);
	DYNAMIC void __fastcall PasteFromClipboard(void);
	__property Data::Db::TField* Field = {read=GetField};
	
__published:
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Data::Db::TFieldType FieldType = {read=FFieldType, write=SetFieldType, default=0};
	__property bool UseTFieldMask = {read=FUseTFieldMask, write=SetUseTFieldMask, default=0};
	__property bool ZeroAsNull = {read=FZeroAsNull, write=SetZeroAsNull, default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property AutoSize = {default=1};
	__property Borders;
	__property BorderStyle = {default=1};
	__property CaretIns;
	__property CaretOvr;
	__property Color = {default=-16777211};
	__property ControlCharColor = {default=255};
	__property Controller;
	__property Ctl3D;
	__property Cursor = {default=-4};
	__property DecimalPlaces = {default=0};
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
	__property PictureMask = {default=88};
	__property PopupMenu;
	__property RangeHi = {stored=false, default=0};
	__property RangeLo = {stored=false, default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Tag = {default=0};
	__property TextMargin = {default=2};
	__property Visible = {default=1};
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
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbSimpleField(HWND ParentWindow) : Ovcsf::TOvcCustomSimpleField(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbsf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBSF)
using namespace Ovcdbsf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbsfHPP

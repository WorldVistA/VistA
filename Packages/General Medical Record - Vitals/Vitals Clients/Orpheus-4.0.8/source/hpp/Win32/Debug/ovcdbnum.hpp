// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbnum.pas' rev: 29.00 (Windows)

#ifndef OvcdbnumHPP
#define OvcdbnumHPP

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
#include <Winapi.Messages.hpp>
#include <ovcedclc.hpp>
#include <ovcedpop.hpp>
#include <ovceditf.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.UITypes.hpp>
#include <ovcbase.hpp>
#include <ovccalc.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbnum
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcCustomDbNumberEdit;
class DELPHICLASS TOvcDbNumberEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcCustomDbNumberEdit : public Ovcedclc::TOvcCustomNumberEdit
{
	typedef Ovcedclc::TOvcCustomNumberEdit inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	bool FAutoUpdate;
	Vcl::Controls::TControlCanvas* FCanvas;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	bool FFocused;
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TField* __fastcall GetField(void);
	HIDESBASE bool __fastcall GetReadOnly(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetFocused(bool Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall EditingChange(System::TObject* Sender);
	System::Types::TPoint __fastcall GetTextMargins(void);
	void __fastcall UpdateData(System::TObject* Sender);
	MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC bool __fastcall GetButtonEnabled(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property bool AutoUpdate = {read=FAutoUpdate, write=FAutoUpdate, nodefault};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	
public:
	__fastcall virtual TOvcCustomDbNumberEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomDbNumberEdit(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC void __fastcall PopupClose(System::TObject* Sender);
	DYNAMIC void __fastcall PopupOpen(void);
	__property Data::Db::TField* Field = {read=GetField};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomDbNumberEdit(HWND ParentWindow) : Ovcedclc::TOvcCustomNumberEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcDbNumberEdit : public TOvcCustomDbNumberEdit
{
	typedef TOvcCustomDbNumberEdit inherited;
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AllowIncDec;
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property AutoUpdate;
	__property BorderStyle = {default=1};
	__property ButtonGlyph;
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DataField = {default=0};
	__property DataSource;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property LabelInfo;
	__property Font;
	__property HideSelection = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupAnchor;
	__property PopupColors;
	__property PopupFont;
	__property PopupHeight;
	__property PopupMenu;
	__property PopupWidth;
	__property ReadOnly;
	__property ShowButton;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
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
	__property OnPopupClose;
	__property OnPopupOpen;
	__property OnStartDrag;
public:
	/* TOvcCustomDbNumberEdit.Create */ inline __fastcall virtual TOvcDbNumberEdit(System::Classes::TComponent* AOwner) : TOvcCustomDbNumberEdit(AOwner) { }
	/* TOvcCustomDbNumberEdit.Destroy */ inline __fastcall virtual ~TOvcDbNumberEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbNumberEdit(HWND ParentWindow) : TOvcCustomDbNumberEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbnum */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBNUM)
using namespace Ovcdbnum;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbnumHPP

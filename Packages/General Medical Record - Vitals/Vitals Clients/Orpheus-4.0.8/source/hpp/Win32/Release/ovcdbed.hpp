// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbed.pas' rev: 29.00 (Windows)

#ifndef OvcdbedHPP
#define OvcdbedHPP

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
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovcedit.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <System.UITypes.hpp>
#include <ovcbordr.hpp>
#include <ovccaret.hpp>
#include <ovcfxfnt.hpp>
#include <ovccolor.hpp>
#include <ovccmd.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbed
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbEditor : public Ovcedit::TOvcCustomEditor
{
	typedef Ovcedit::TOvcCustomEditor inherited;
	
protected:
	bool FAutoUpdate;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	bool edUpdating;
	Data::Db::TField* __fastcall GetField(void);
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall eddbGetEditorValue(void);
	void __fastcall eddbDataChange(System::TObject* Sender);
	void __fastcall eddbEditingChange(System::TObject* Sender);
	void __fastcall eddbSetEditorValue(void);
	void __fastcall eddbUpdateData(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall edAddSampleParas(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual bool __fastcall GetReadOnly(void);
	
public:
	__fastcall virtual TOvcDbEditor(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbEditor(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC void __fastcall CutToClipboard(void);
	DYNAMIC void __fastcall Redo(void);
	DYNAMIC int __fastcall Replace(const System::UnicodeString S, const System::UnicodeString R, Ovcdata::TSearchOptionSet Options);
	DYNAMIC void __fastcall PasteFromClipboard(void);
	DYNAMIC void __fastcall Undo(void);
	__property Data::Db::TField* Field = {read=GetField};
	
__published:
	__property bool AutoUpdate = {read=FAutoUpdate, write=FAutoUpdate, default=1};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property AutoIndent = {default=0};
	__property Borders;
	__property BorderStyle = {default=1};
	__property ByteLimit = {default=2147483647};
	__property CaretIns;
	__property CaretOvr;
	__property FixedFont;
	__property HideSelection = {default=1};
	__property HighlightColors;
	__property InsertMode = {default=1};
	__property LabelInfo;
	__property LeftMargin = {default=15};
	__property MarginColor = {default=-16777211};
	__property ParaLengthLimit = {default=32767};
	__property ParaLimit = {default=2147483647};
	__property ReadOnly = {default=0};
	__property RightMargin = {default=5};
	__property ScrollBars = {default=3};
	__property ScrollBarsAlways = {default=0};
	__property ScrollPastEnd = {default=0};
	__property ShowBookmarks = {default=1};
	__property TabSize = {default=8};
	__property TabType = {default=0};
	__property UndoBufferSize = {default=8192};
	__property WantEnter = {default=1};
	__property WantTab = {default=0};
	__property WordWrap = {default=0};
	__property WrapAtLeft = {default=1};
	__property WrapColumn = {default=80};
	__property WrapToWindow = {default=0};
	__property WheelDelta = {default=1};
	__property OnError;
	__property OnShowStatus;
	__property OnUserCommand;
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property Cursor = {default=-4};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
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
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbEditor(HWND ParentWindow) : Ovcedit::TOvcCustomEditor(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbed */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBED)
using namespace Ovcdbed;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbedHPP

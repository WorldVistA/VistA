// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbacb.pas' rev: 29.00 (Windows)

#ifndef OvcdbacbHPP
#define OvcdbacbHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <ovccmbx.hpp>
#include <ovcdbtcb.hpp>
#include <ovcdbhll.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcbase.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbacb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbAliasComboBox;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbAliasComboBox : public Ovccmbx::TOvcBaseComboBox
{
	typedef Ovccmbx::TOvcBaseComboBox inherited;
	
protected:
	Ovcdbhll::TOvcDbEngineHelperBase* FDbEngineHelper;
	Ovcdbtcb::TOvcDbTableNameComboBox* FTableNameComboBox;
	System::UnicodeString __fastcall GetAliasName(void);
	System::UnicodeString __fastcall GetPath(void);
	System::UnicodeString __fastcall GetDriverName(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SelectionChanged(void);
	
public:
	void __fastcall Populate(void);
	__property System::UnicodeString AliasName = {read=GetAliasName};
	__property System::UnicodeString Path = {read=GetPath};
	__property System::UnicodeString DriverName = {read=GetDriverName};
	
__published:
	__property Ovcdbtcb::TOvcDbTableNameComboBox* TableNameComboBox = {read=FTableNameComboBox, write=FTableNameComboBox};
	__property Ovcdbhll::TOvcDbEngineHelperBase* DbEngineHelper = {read=FDbEngineHelper, write=FDbEngineHelper};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property AutoSearch = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property Enabled = {default=1};
	__property Font;
	__property HotTrack = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ItemHeight;
	__property KeyDelay = {default=500};
	__property LabelInfo;
	__property MRUListColor = {default=-16777211};
	__property MRUListCount = {default=3};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Style = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Text = {default=0};
	__property Visible = {default=1};
	__property AfterEnter;
	__property AfterExit;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnSelectionChange;
	__property OnStartDrag;
	__property OnMouseWheel;
public:
	/* TOvcBaseComboBox.Create */ inline __fastcall virtual TOvcDbAliasComboBox(System::Classes::TComponent* AOwner) : Ovccmbx::TOvcBaseComboBox(AOwner) { }
	/* TOvcBaseComboBox.Destroy */ inline __fastcall virtual ~TOvcDbAliasComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbAliasComboBox(HWND ParentWindow) : Ovccmbx::TOvcBaseComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbacb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBACB)
using namespace Ovcdbacb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbacbHPP

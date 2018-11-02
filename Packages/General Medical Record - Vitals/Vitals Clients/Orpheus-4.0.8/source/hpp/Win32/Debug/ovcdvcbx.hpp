// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdvcbx.pas' rev: 29.00 (Windows)

#ifndef OvcdvcbxHPP
#define OvcdvcbxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <ovccmbx.hpp>
#include <ovcdrcbx.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Graphics.hpp>
#include <ovcbase.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdvcbx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDriveComboBox;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDriveComboBox : public Ovccmbx::TOvcBaseComboBox
{
	typedef Ovccmbx::TOvcBaseComboBox inherited;
	
protected:
	System::WideChar FDrive;
	System::WideChar FFirstDrive;
	Ovcdrcbx::TOvcDirectoryComboBox* FDirComboBox;
	System::UnicodeString FVolName;
	void __fastcall SetDrive(const System::WideChar Value);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetFirstDrive(System::WideChar Value);
	
public:
	__fastcall virtual TOvcDriveComboBox(System::Classes::TComponent* AOwner);
	void __fastcall Populate(void);
	virtual void __fastcall SelectionChanged(void);
	__property System::WideChar Drive = {read=FDrive, write=SetDrive, nodefault};
	__property System::UnicodeString VolumeName = {read=FVolName};
	
__published:
	__property Ovcdrcbx::TOvcDirectoryComboBox* DirectoryComboBox = {read=FDirComboBox, write=FDirComboBox};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property About = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Cursor = {default=0};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property Enabled = {default=1};
	__property System::WideChar FirstScannedDrive = {read=FFirstDrive, write=SetFirstDrive, default=65};
	__property Font;
	__property HotTrack = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ItemHeight;
	__property LabelInfo;
	__property MRUListColor = {default=-16777211};
	__property MRUListCount = {default=3};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
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
	/* TOvcBaseComboBox.Destroy */ inline __fastcall virtual ~TOvcDriveComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDriveComboBox(HWND ParentWindow) : Ovccmbx::TOvcBaseComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdvcbx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDVCBX)
using namespace Ovcdvcbx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdvcbxHPP

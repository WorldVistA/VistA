// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcflcbx.pas' rev: 29.00 (Windows)

#ifndef OvcflcbxHPP
#define OvcflcbxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <ovccmbx.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>
#include <ovcbase.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcflcbx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcFileComboBox;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcCbxFileAttribute : unsigned char { cbxReadOnly, cbxHidden, cbxSysFile, cbxArchive, cbxAnyFile };

typedef System::Set<TOvcCbxFileAttribute, TOvcCbxFileAttribute::cbxReadOnly, TOvcCbxFileAttribute::cbxAnyFile> TOvcCbxFileAttributes;

class PASCALIMPLEMENTATION TOvcFileComboBox : public Ovccmbx::TOvcBaseComboBox
{
	typedef Ovccmbx::TOvcBaseComboBox inherited;
	
protected:
	TOvcCbxFileAttributes FAttributes;
	System::UnicodeString FDirName;
	System::UnicodeString FFileMask;
	bool FShowIcons;
	void __fastcall SetAttributes(TOvcCbxFileAttributes Value);
	void __fastcall SetDirectory(const System::UnicodeString Value);
	void __fastcall SetFileMask(const System::UnicodeString Value);
	void __fastcall SetShowIcons(bool Value);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &ItemRect, Winapi::Windows::TOwnerDrawState State);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TOvcFileComboBox(System::Classes::TComponent* AOwner);
	void __fastcall Populate(void);
	
__published:
	__property TOvcCbxFileAttributes Attributes = {read=FAttributes, write=SetAttributes, default=16};
	__property System::UnicodeString Directory = {read=FDirName, write=SetDirectory};
	__property System::UnicodeString FileMask = {read=FFileMask, write=SetFileMask};
	__property bool ShowIcons = {read=FShowIcons, write=SetShowIcons, default=1};
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
	/* TOvcBaseComboBox.Destroy */ inline __fastcall virtual ~TOvcFileComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcFileComboBox(HWND ParentWindow) : Ovccmbx::TOvcBaseComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcflcbx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCFLCBX)
using namespace Ovcflcbx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcflcbxHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcislb.pas' rev: 29.00 (Windows)

#ifndef OvcislbHPP
#define OvcislbHPP

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
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcdata.hpp>
#include <ovciseb.hpp>
#include <ovceditf.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcislb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcSearchEdit;
class DELPHICLASS TOvcSearchListBox;
class DELPHICLASS TOvcSearchList;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcSearchEdit : public Ovciseb::TOvcBaseISE
{
	typedef Ovciseb::TOvcBaseISE inherited;
	
public:
	virtual void __fastcall PerformSearch(void);
public:
	/* TOvcBaseISE.Create */ inline __fastcall virtual TOvcSearchEdit(System::Classes::TComponent* AOwner) : Ovciseb::TOvcBaseISE(AOwner) { }
	/* TOvcBaseISE.Destroy */ inline __fastcall virtual ~TOvcSearchEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSearchEdit(HWND ParentWindow) : Ovciseb::TOvcBaseISE(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSearchListBox : public Vcl::Stdctrls::TCustomListBox
{
	typedef Vcl::Stdctrls::TCustomListBox inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TMessage &Msg);
	DYNAMIC void __fastcall Click(void);
public:
	/* TCustomListBox.Create */ inline __fastcall virtual TOvcSearchListBox(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TCustomListBox(AOwner) { }
	/* TCustomListBox.Destroy */ inline __fastcall virtual ~TOvcSearchListBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSearchListBox(HWND ParentWindow) : Vcl::Stdctrls::TCustomListBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcSearchList : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TOvcSearchEdit* FEdit;
	TOvcSearchListBox* FListBox;
	bool __fastcall GetAutoSearch(void);
	bool __fastcall GetAutoSelect(void);
	bool __fastcall GetCaseSensitive(void);
	int __fastcall GetColumns(void);
	bool __fastcall GetHideSelection(void);
	int __fastcall GetItemHeight(void);
	System::Classes::TStrings* __fastcall GetItems(void);
	int __fastcall GetItemIndex(void);
	int __fastcall GetKeyDelay(void);
	Vcl::Stdctrls::TListBox* __fastcall GetListBox(void);
	System::Classes::TNotifyEvent __fastcall GetOnChange(void);
	System::WideChar __fastcall GetPasswordChar(void);
	bool __fastcall GetShowResults(void);
	void __fastcall SetAutoSearch(bool Value);
	void __fastcall SetAutoSelect(bool Value);
	void __fastcall SetBorderStyle(Vcl::Forms::TBorderStyle Value);
	void __fastcall SetCaseSensitive(bool Value);
	void __fastcall SetColumns(int Value);
	void __fastcall SetHideSelection(bool Value);
	void __fastcall SetItemHeight(int Value);
	void __fastcall SetItems(System::Classes::TStrings* Value);
	void __fastcall SetItemIndex(int Value);
	void __fastcall SetKeyDelay(int Value);
	void __fastcall SetOnChange(System::Classes::TNotifyEvent Value);
	void __fastcall SetPasswordChar(System::WideChar Value);
	void __fastcall SetShowResults(bool Value);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Msg);
	void __fastcall SetPositions(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
	
public:
	__fastcall virtual TOvcSearchList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcSearchList(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property Canvas;
	__property TOvcSearchEdit* Edit = {read=FEdit};
	__property int ItemIndex = {read=GetItemIndex, write=SetItemIndex, nodefault};
	__property Vcl::Stdctrls::TListBox* ListBox = {read=GetListBox};
	
__published:
	__property bool AutoSearch = {read=GetAutoSearch, write=SetAutoSearch, default=1};
	__property bool AutoSelect = {read=GetAutoSelect, write=SetAutoSelect, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property bool CaseSensitive = {read=GetCaseSensitive, write=SetCaseSensitive, default=0};
	__property int Columns = {read=GetColumns, write=SetColumns, nodefault};
	__property bool HideSelection = {read=GetHideSelection, write=SetHideSelection, default=1};
	__property int ItemHeight = {read=GetItemHeight, write=SetItemHeight, nodefault};
	__property System::Classes::TStrings* Items = {read=GetItems, write=SetItems};
	__property int KeyDelay = {read=GetKeyDelay, write=SetKeyDelay, default=500};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, default=0};
	__property bool ShowResults = {read=GetShowResults, write=SetShowResults, default=1};
	__property System::Classes::TNotifyEvent OnChange = {read=GetOnChange, write=SetOnChange};
	__property Anchors = {default=3};
	__property Constraints;
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property Enabled = {default=1};
	__property Font;
	__property LabelInfo;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcSearchList(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcislb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCISLB)
using namespace Ovcislb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcislbHPP

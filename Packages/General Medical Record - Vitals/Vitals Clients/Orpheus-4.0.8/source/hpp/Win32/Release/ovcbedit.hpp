// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcbedit.pas' rev: 29.00 (Windows)

#ifndef OvcbeditHPP
#define OvcbeditHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcver.hpp>
#include <ovcbordr.hpp>
#include <ovceditf.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcbedit
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcEditEx;
class DELPHICLASS TOvcBorderedEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcEditEx : public Ovceditf::TOvcEdit
{
	typedef Ovceditf::TOvcEdit inherited;
	
protected:
	TOvcBorderedEdit* BorderParent;
public:
	/* TOvcCustomEdit.Create */ inline __fastcall virtual TOvcEditEx(System::Classes::TComponent* AOwner) : Ovceditf::TOvcEdit(AOwner) { }
	/* TOvcCustomEdit.Destroy */ inline __fastcall virtual ~TOvcEditEx(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcEditEx(HWND ParentWindow) : Ovceditf::TOvcEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcBorderedEdit : public Ovcbordr::TOvcBorderParent
{
	typedef Ovcbordr::TOvcBorderParent inherited;
	
protected:
	TOvcEditEx* FOvcEdit;
	System::Classes::TBiDiMode FBiDiMode;
	bool FParentBiDiMode;
	System::Uitypes::TDragKind FDragKind;
	System::UnicodeString FAbout;
	bool FAutoSelect;
	bool FAutoSize;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	System::Uitypes::TEditCharCase FCharCase;
	Ovcbase::TOvcController* FController;
	System::Uitypes::TCursor FCursor;
	System::Uitypes::TCursor FDragCursor;
	System::Uitypes::TDragMode FDragMode;
	bool FEnabled;
	Vcl::Graphics::TFont* FFont;
	int FHeight;
	bool FHideSelection;
	Vcl::Controls::TImeMode FImeMode;
	System::UnicodeString FImeName;
	int FMaxLength;
	bool FOEMConvert;
	bool FParentFont;
	bool FParentShowHint;
	System::WideChar FPasswordChar;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	bool FReadOnly;
	bool FShowHint;
	System::Uitypes::TTabOrder FTabOrder;
	System::UnicodeString FText;
	bool FVisible;
	int FWidth;
	System::Classes::TNotifyEvent FOnChange;
	System::Classes::TNotifyEvent FOnClick;
	System::Classes::TNotifyEvent FOnDblClick;
	Vcl::Controls::TDragDropEvent FOnDragDrop;
	Vcl::Controls::TDragOverEvent FOnDragOver;
	Vcl::Controls::TEndDragEvent FOnEndDock;
	Vcl::Controls::TStartDockEvent FOnStartDock;
	Vcl::Controls::TEndDragEvent FOnEndDrag;
	System::Classes::TNotifyEvent FOnEnter;
	System::Classes::TNotifyEvent FOnExit;
	Vcl::Controls::TKeyEvent FOnKeyDown;
	Vcl::Controls::TKeyPressEvent FOnKeyPress;
	Vcl::Controls::TKeyEvent FOnKeyUp;
	Vcl::Controls::TMouseEvent FOnMouseDown;
	Vcl::Controls::TMouseMoveEvent FOnMouseMove;
	Vcl::Controls::TMouseEvent FOnMouseUp;
	Vcl::Controls::TStartDragEvent FOnStartDrag;
	virtual void __fastcall CreateWnd(void);
	System::Classes::TBiDiMode __fastcall GetBiDiMode(void);
	bool __fastcall GetParentBiDiMode(void);
	System::Uitypes::TDragKind __fastcall GetDragKind(void);
	Vcl::Controls::TEndDragEvent __fastcall GetOnEndDock(void);
	Vcl::Controls::TStartDockEvent __fastcall GetOnStartDock(void);
	void __fastcall SetEditBiDiMode(System::Classes::TBiDiMode Value);
	void __fastcall SetEditParentBiDiMode(bool Value);
	void __fastcall SetDragKind(System::Uitypes::TDragKind Value);
	void __fastcall SetOnEndDock(Vcl::Controls::TEndDragEvent Value);
	void __fastcall SetOnStartDock(Vcl::Controls::TStartDockEvent Value);
	HIDESBASE System::UnicodeString __fastcall GetAbout(void);
	bool __fastcall GetAutoSelect(void);
	bool __fastcall GetAutoSize(void);
	System::Uitypes::TEditCharCase __fastcall GetCharCase(void);
	Ovcbase::TOvcController* __fastcall GetController(void);
	System::Uitypes::TCursor __fastcall GetCursor(void);
	System::Uitypes::TCursor __fastcall GetDragCursor(void);
	HIDESBASE System::Uitypes::TDragMode __fastcall GetDragMode(void);
	bool __fastcall GetEditEnabled(void);
	int __fastcall GetEditHeight(void);
	int __fastcall GetEditWidth(void);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	bool __fastcall GetHideSelection(void);
	Vcl::Controls::TImeMode __fastcall GetImeMode(void);
	System::UnicodeString __fastcall GetImeName(void);
	int __fastcall GetMaxLength(void);
	bool __fastcall GetOEMConvert(void);
	bool __fastcall GetParentShowHint(void);
	System::WideChar __fastcall GetPasswordChar(void);
	bool __fastcall GetReadOnly(void);
	System::UnicodeString __fastcall GetEditText(void);
	bool __fastcall GetParentFont(void);
	System::Classes::TNotifyEvent __fastcall GetOnChange(void);
	System::Classes::TNotifyEvent __fastcall GetOnClick(void);
	System::Classes::TNotifyEvent __fastcall GetOnDblClick(void);
	Vcl::Controls::TDragDropEvent __fastcall GetOnDragDrop(void);
	Vcl::Controls::TDragOverEvent __fastcall GetOnDragOver(void);
	Vcl::Controls::TEndDragEvent __fastcall GetOnEndDrag(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyDown(void);
	Vcl::Controls::TKeyPressEvent __fastcall GetOnKeyPress(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyUp(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseDown(void);
	Vcl::Controls::TMouseMoveEvent __fastcall GetOnMouseMove(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseUp(void);
	HIDESBASE void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetAutoSelect(bool Value);
	virtual void __fastcall SetAutoSize(bool Value);
	void __fastcall SetCharCase(System::Uitypes::TEditCharCase Value);
	void __fastcall SetEditController(Ovcbase::TOvcController* Value);
	HIDESBASE void __fastcall SetCursor(System::Uitypes::TCursor Value);
	void __fastcall SetDragCursor(System::Uitypes::TCursor Value);
	void __fastcall SetEditDragMode(System::Uitypes::TDragMode Value);
	void __fastcall SetEditEnabled(bool Value);
	void __fastcall SetEditHeight(int Value);
	void __fastcall SetEditWidth(int Value);
	HIDESBASE void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetHideSelection(bool Value);
	void __fastcall SetImeMode(Vcl::Controls::TImeMode Value);
	void __fastcall SetImeName(const System::UnicodeString Value);
	void __fastcall SetMaxLength(int Value);
	void __fastcall SetOEMConvert(bool Value);
	HIDESBASE void __fastcall SetParentShowHint(bool Value);
	void __fastcall SetPasswordChar(System::WideChar Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetEditText(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetParentFont(bool Value);
	void __fastcall SetOnChange(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnClick(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnDblClick(System::Classes::TNotifyEvent Value);
	void __fastcall SetOnDragDrop(Vcl::Controls::TDragDropEvent Value);
	void __fastcall SetOnDragOver(Vcl::Controls::TDragOverEvent Value);
	void __fastcall SetOnEndDrag(Vcl::Controls::TEndDragEvent Value);
	void __fastcall SetOnKeyDown(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnKeyPress(Vcl::Controls::TKeyPressEvent Value);
	void __fastcall SetOnKeyUp(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnMouseDown(Vcl::Controls::TMouseEvent Value);
	void __fastcall SetOnMouseMove(Vcl::Controls::TMouseMoveEvent Value);
	void __fastcall SetOnMouseUp(Vcl::Controls::TMouseEvent Value);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	
public:
	__fastcall virtual TOvcBorderedEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcBorderedEdit(void);
	__property TOvcEditEx* EditControl = {read=FOvcEdit};
	
__published:
	__property Anchors = {default=3};
	__property System::Classes::TBiDiMode BiDiMode = {read=GetBiDiMode, write=SetEditBiDiMode, nodefault};
	__property bool ParentBiDiMode = {read=GetParentBiDiMode, write=SetEditParentBiDiMode, nodefault};
	__property System::Uitypes::TDragKind DragKind = {read=GetDragKind, write=SetDragKind, nodefault};
	__property bool AutoSize = {read=GetAutoSize, write=SetAutoSize, nodefault};
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout};
	__property bool AutoSelect = {read=GetAutoSelect, write=SetAutoSelect, nodefault};
	__property System::Uitypes::TEditCharCase CharCase = {read=GetCharCase, write=SetCharCase, nodefault};
	__property Ovcbase::TOvcController* Controller = {read=GetController, write=SetEditController};
	__property System::Uitypes::TCursor Cursor = {read=GetCursor, write=SetCursor, nodefault};
	__property System::Uitypes::TCursor DragCursor = {read=GetDragCursor, write=SetDragCursor, nodefault};
	__property System::Uitypes::TDragMode DragMode = {read=GetDragMode, write=SetDragMode, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, nodefault};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
	__property bool HideSelection = {read=GetHideSelection, write=SetHideSelection, nodefault};
	__property Vcl::Controls::TImeMode ImeMode = {read=GetImeMode, write=SetImeMode, nodefault};
	__property ImeName = {default=0};
	__property int MaxLength = {read=GetMaxLength, write=SetMaxLength, nodefault};
	__property bool OEMConvert = {read=GetOEMConvert, write=SetOEMConvert, nodefault};
	__property bool ParentFont = {read=GetParentFont, write=SetParentFont, nodefault};
	__property bool ParentShowHint = {read=GetParentShowHint, write=SetParentShowHint, nodefault};
	__property System::WideChar PasswordChar = {read=GetPasswordChar, write=SetPasswordChar, nodefault};
	__property PopupMenu;
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property System::UnicodeString Text = {read=GetEditText, write=SetEditText};
	__property Visible = {default=1};
	__property System::Classes::TNotifyEvent OnChange = {read=GetOnChange, write=SetOnChange};
	__property System::Classes::TNotifyEvent OnClick = {read=GetOnClick, write=SetOnClick};
	__property System::Classes::TNotifyEvent OnDblClick = {read=GetOnDblClick, write=SetOnDblClick};
	__property Vcl::Controls::TDragDropEvent OnDragDrop = {read=GetOnDragDrop, write=SetOnDragDrop};
	__property Vcl::Controls::TDragOverEvent OnDragOver = {read=GetOnDragOver, write=SetOnDragOver};
	__property Vcl::Controls::TEndDragEvent OnEndDock = {read=GetOnEndDock, write=SetOnEndDock};
	__property Vcl::Controls::TStartDockEvent OnStartDock = {read=GetOnStartDock, write=SetOnStartDock};
	__property Vcl::Controls::TEndDragEvent OnEndDrag = {read=GetOnEndDrag, write=SetOnEndDrag};
	__property OnEnter;
	__property OnExit;
	__property Vcl::Controls::TKeyEvent OnKeyDown = {read=GetOnKeyDown, write=SetOnKeyDown};
	__property Vcl::Controls::TKeyPressEvent OnKeyPress = {read=GetOnKeyPress, write=SetOnKeyPress};
	__property Vcl::Controls::TKeyEvent OnKeyUp = {read=GetOnKeyUp, write=SetOnKeyUp};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=GetOnMouseDown, write=SetOnMouseDown};
	__property Vcl::Controls::TMouseMoveEvent OnMouseMove = {read=GetOnMouseMove, write=SetOnMouseMove};
	__property Vcl::Controls::TMouseEvent OnMouseUp = {read=GetOnMouseUp, write=SetOnMouseUp};
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcBorderedEdit(HWND ParentWindow) : Ovcbordr::TOvcBorderParent(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcbedit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCBEDIT)
using namespace Ovcbedit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcbeditHPP

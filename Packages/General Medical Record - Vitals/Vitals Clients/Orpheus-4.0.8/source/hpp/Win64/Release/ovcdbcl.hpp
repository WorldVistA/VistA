// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbcl.pas' rev: 29.00 (Windows)

#ifndef OvcdbclHPP
#define OvcdbclHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovccmd.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovccolor.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbcl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbColumnList;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *THeaderClickEvent)(System::TObject* Sender, System::Types::TPoint Point);

typedef void __fastcall (__closure *TIndicatorClickEvent)(System::TObject* Sender, int Row);

class PASCALIMPLEMENTATION TOvcDbColumnList : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	int FActiveRow;
	bool FAutoRowHeight;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	System::UnicodeString FHeader;
	Ovccolor::TOvcColors* FHeaderColor;
	bool FHideSelection;
	Ovccolor::TOvcColors* FHighlightColors;
	bool FIntegralHeight;
	System::Uitypes::TColor FLineColor;
	bool FPageScroll;
	int FRowHeight;
	int FRowIndicatorWidth;
	System::Uitypes::TScrollStyle FScrollBars;
	bool FShowHeader;
	bool FShowIndicator;
	int FTextMargin;
	THeaderClickEvent FOnClickHeader;
	TIndicatorClickEvent FOnIndicatorClick;
	Ovccmd::TUserCommandEvent FOnUserCommand;
	int clHDelta;
	Vcl::Controls::TImageList* clIndicators;
	int clNumRows;
	bool clPainting;
	Data::Db::TField* __fastcall GetField(void);
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetActiveRow(int Value);
	void __fastcall SetAutoRowHeight(bool Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetHeader(const System::UnicodeString Value);
	void __fastcall SetIntegralHeight(bool Value);
	void __fastcall SetLineColor(System::Uitypes::TColor Value);
	void __fastcall SetRowHeight(int Value);
	void __fastcall SetRowIndicatorWidth(int Value);
	void __fastcall SetScrollBars(const System::Uitypes::TScrollStyle Value);
	void __fastcall SetShowHeader(bool Value);
	void __fastcall SetShowIndicator(bool Value);
	void __fastcall SetTextMargin(int Value);
	void __fastcall clAdjustIntegralHeight(void);
	void __fastcall clAdjustRowHeight(void);
	void __fastcall clCalcNumRows(void);
	void __fastcall clColorChanged(System::TObject* AColor);
	void __fastcall clDrawHeader(void);
	void __fastcall clSetHScrollPos(void);
	void __fastcall clSetHScrollRange(void);
	void __fastcall clSetVScrollPos(void);
	void __fastcall clSetVScrollRange(void);
	void __fastcall clInitScrollBarInfo(void);
	void __fastcall clUpdateActive(void);
	void __fastcall clUpdateNumRows(void);
	void __fastcall clActiveChange(System::TObject* Sender);
	void __fastcall clDataChange(System::TObject* Sender);
	void __fastcall clEditingChange(System::TObject* Sender);
	void __fastcall clUpdateData(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Msg);
	MESSAGE void __fastcall WMGetMinMaxInfo(Winapi::Messages::TWMGetMinMaxInfo &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Msg);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Msg);
	DYNAMIC void __fastcall ChangeScale(int M, int D);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall DoOnClickHeader(System::Types::TPoint Point);
	DYNAMIC void __fastcall DoOnIndicatorClick(int Row);
	DYNAMIC void __fastcall DoOnUserCommand(System::Word Command);
	
public:
	__fastcall virtual TOvcDbColumnList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbColumnList(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	void __fastcall InvalidateItem(int Row);
	__property int ActiveRow = {read=FActiveRow, write=SetActiveRow, stored=false, nodefault};
	__property Canvas;
	__property Data::Db::TField* Field = {read=GetField};
	
__published:
	__property bool AutoRowHeight = {read=FAutoRowHeight, write=SetAutoRowHeight, default=1};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=1};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString Header = {read=FHeader, write=SetHeader};
	__property Ovccolor::TOvcColors* HeaderColor = {read=FHeaderColor, write=FHeaderColor};
	__property bool HideSelection = {read=FHideSelection, write=FHideSelection, default=1};
	__property Ovccolor::TOvcColors* HighlightColors = {read=FHighlightColors, write=FHighlightColors};
	__property bool IntegralHeight = {read=FIntegralHeight, write=SetIntegralHeight, default=1};
	__property System::Uitypes::TColor LineColor = {read=FLineColor, write=SetLineColor, default=12632256};
	__property bool PageScroll = {read=FPageScroll, write=FPageScroll, default=0};
	__property int RowHeight = {read=FRowHeight, write=SetRowHeight, default=17};
	__property int RowIndicatorWidth = {read=FRowIndicatorWidth, write=SetRowIndicatorWidth, default=11};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, default=2};
	__property bool ShowHeader = {read=FShowHeader, write=SetShowHeader, default=0};
	__property bool ShowIndicator = {read=FShowIndicator, write=SetShowIndicator, default=1};
	__property int TextMargin = {read=FTextMargin, write=SetTextMargin, default=1};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property THeaderClickEvent OnClickHeader = {read=FOnClickHeader, write=FOnClickHeader};
	__property TIndicatorClickEvent OnIndicatorClick = {read=FOnIndicatorClick, write=FOnIndicatorClick};
	__property Ovccmd::TUserCommandEvent OnUserCommand = {read=FOnUserCommand, write=FOnUserCommand};
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
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbColumnList(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBCL)
using namespace Ovcdbcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbclHPP

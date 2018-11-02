// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcurl.pas' rev: 29.00 (Windows)

#ifndef OvcurlHPP
#define OvcurlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcver.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcurl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcURL;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcURL : public Vcl::Stdctrls::TCustomLabel
{
	typedef Vcl::Stdctrls::TCustomLabel inherited;
	
protected:
	System::UnicodeString FCaption;
	System::Uitypes::TColor FHighlightColor;
	System::UnicodeString FURL;
	bool FUseVisitedColor;
	System::Uitypes::TColor FVisitedColor;
	Vcl::Extctrls::TTimer* urlTimer;
	System::Uitypes::TColor urlFontColor;
	System::UnicodeString __fastcall GetAbout(void);
	bool __fastcall GetUnderlineURL(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	void __fastcall SetHighlightColor(const System::Uitypes::TColor Value);
	void __fastcall SetUnderlineURL(bool Value);
	void __fastcall SetURL(const System::UnicodeString Value);
	void __fastcall SetVisitedColor(const System::Uitypes::TColor Value);
	void __fastcall TimerEvent(System::TObject* Sender);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	
public:
	DYNAMIC void __fastcall Click(void);
	__fastcall virtual TOvcURL(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcURL(void);
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=255};
	__property bool UnderlineURL = {read=GetUnderlineURL, write=SetUnderlineURL, stored=false, nodefault};
	__property System::UnicodeString URL = {read=FURL, write=SetURL};
	__property bool UseVisitedColor = {read=FUseVisitedColor, write=FUseVisitedColor, default=0};
	__property System::Uitypes::TColor VisitedColor = {read=FVisitedColor, write=SetVisitedColor, stored=FUseVisitedColor, default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property AutoSize = {default=1};
	__property Color = {default=-16777211};
	__property Cursor = {default=-21};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property FocusControl;
	__property Font;
	__property ParentColor = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowAccelChar = {default=1};
	__property ShowHint;
	__property Transparent = {default=0};
	__property Layout = {default=0};
	__property Visible = {default=1};
	__property WordWrap = {default=0};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcurl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCURL)
using namespace Ovcurl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcurlHPP

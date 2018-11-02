// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbclk.pas' rev: 29.00 (Windows)

#ifndef OvcdbclkHPP
#define OvcdbclkHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <ovcbase.hpp>
#include <ovcclock.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <System.SysUtils.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbclk
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbClock;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbClock : public Ovcclock::TOvcCustomClock
{
	typedef Ovcclock::TOvcCustomClock inherited;
	
protected:
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TField* __fastcall GetField(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall clkDataChange(System::TObject* Sender);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TOvcDbClock(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbClock(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	__property Data::Db::TField* Field = {read=GetField};
	
__published:
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Anchors = {default=3};
	__property Constraints;
	__property About = {default=0};
	__property Align = {default=0};
	__property Color = {default=-16777211};
	__property Controller;
	__property ClockFace;
	__property DrawMarks = {default=1};
	__property Hint = {default=0};
	__property HandOptions;
	__property LabelInfo;
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TimeOffset = {default=0};
	__property Visible = {default=1};
	__property DigitalOptions;
	__property DisplayMode = {default=0};
	__property OnClick;
	__property OnDblClick;
	__property OnHourChange;
	__property OnMinuteChange;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnSecondChange;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbClock(HWND ParentWindow) : Ovcclock::TOvcCustomClock(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbclk */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBCLK)
using namespace Ovcdbclk;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbclkHPP

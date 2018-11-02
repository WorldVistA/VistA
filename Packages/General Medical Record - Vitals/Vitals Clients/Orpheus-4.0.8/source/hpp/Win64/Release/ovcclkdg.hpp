// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcclkdg.pas' rev: 29.00 (Windows)

#ifndef OvcclkdgHPP
#define OvcclkdgHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcdlg.hpp>
#include <ovcclock.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcclkdg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmClockDlg;
class DELPHICLASS TOvcClockDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmClockDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnHelp;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* btnCancel;
	Ovcclock::TOvcClock* OvcClock1;
	Ovcbase::TOvcController* OvcController1;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmClockDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmClockDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmClockDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmClockDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcClockDialog : public Ovcdlg::TOvcBaseDialog
{
	typedef Ovcdlg::TOvcBaseDialog inherited;
	
protected:
	Ovcclock::TOvcClock* FClock;
	Vcl::Graphics::TBitmap* __fastcall GetClockFace(void);
	void __fastcall SetClockFace(Vcl::Graphics::TBitmap* Value);
	
public:
	__fastcall virtual TOvcClockDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcClockDialog(void);
	virtual bool __fastcall Execute(void);
	__property Ovcclock::TOvcClock* Clock = {read=FClock};
	
__published:
	__property Caption = {default=0};
	__property Vcl::Graphics::TBitmap* ClockFace = {read=GetClockFace, write=SetClockFace};
	__property Font;
	__property Icon;
	__property Options;
	__property Placement;
	__property OnHelpClick;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcclkdg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCLKDG)
using namespace Ovcclkdg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcclkdgHPP

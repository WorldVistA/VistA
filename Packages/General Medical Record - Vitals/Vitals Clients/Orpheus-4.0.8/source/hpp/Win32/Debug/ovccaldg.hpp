// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccaldg.pas' rev: 29.00 (Windows)

#ifndef OvccaldgHPP
#define OvccaldgHPP

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
#include <ovccal.hpp>
#include <ovcdlg.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccaldg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmCalendarDlg;
class DELPHICLASS TOvcCalendarDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmCalendarDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnHelp;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Ovccal::TOvcCalendar* OvcCalendar1;
	void __fastcall OvcCalendar1DblClick(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmCalendarDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmCalendarDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmCalendarDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmCalendarDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCalendarDialog : public Ovcdlg::TOvcBaseDialog
{
	typedef Ovcdlg::TOvcBaseDialog inherited;
	
protected:
	Ovccal::TOvcCalendar* FCalendar;
	
public:
	__fastcall virtual TOvcCalendarDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCalendarDialog(void);
	virtual bool __fastcall Execute(void);
	__property Ovccal::TOvcCalendar* Calendar = {read=FCalendar};
	
__published:
	__property Caption = {default=0};
	__property Font;
	__property Icon;
	__property Options;
	__property Placement;
	__property OnHelpClick;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovccaldg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCALDG)
using namespace Ovccaldg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvccaldgHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcclcdg.pas' rev: 29.00 (Windows)

#ifndef OvcclcdgHPP
#define OvcclcdgHPP

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
#include <ovccalc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcclcdg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmCalculatorDlg;
class DELPHICLASS TOvcCalculatorDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmCalculatorDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnHelp;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Ovccalc::TOvcCalculator* OvcCalculator1;
	void __fastcall FormShow(System::TObject* Sender);
	
public:
	double Value;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmCalculatorDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmCalculatorDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmCalculatorDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmCalculatorDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcCalculatorDialog : public Ovcdlg::TOvcBaseDialog
{
	typedef Ovcdlg::TOvcBaseDialog inherited;
	
protected:
	Ovccalc::TOvcCalculator* FCalculator;
	double FValue;
	
public:
	__fastcall virtual TOvcCalculatorDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCalculatorDialog(void);
	virtual bool __fastcall Execute(void);
	__property Ovccalc::TOvcCalculator* Calculator = {read=FCalculator};
	
__published:
	__property Caption = {default=0};
	__property Font;
	__property Icon;
	__property Options;
	__property Placement;
	__property double Value = {read=FValue, write=FValue};
	__property OnHelpClick;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcclcdg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCLCDG)
using namespace Ovcclcdg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcclcdgHPP

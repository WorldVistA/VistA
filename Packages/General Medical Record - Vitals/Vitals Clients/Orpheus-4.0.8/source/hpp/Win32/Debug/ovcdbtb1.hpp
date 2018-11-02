// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbtb1.pas' rev: 29.00 (Windows)

#ifndef Ovcdbtb1HPP
#define Ovcdbtb1HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <ovcbase.hpp>
#include <ovcef.hpp>
#include <ovcsf.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovcintl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbtb1
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmProperties;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmProperties : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Ovcsf::TOvcSimpleField* edPictureMask;
	Ovcbase::TOvcController* OvcController1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Ovcsf::TOvcSimpleField* edDecimalPlaces;
	Vcl::Extctrls::TRadioGroup* rgDateOrTime;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* Button2;
	void __fastcall rgDateOrTimeClick(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmProperties(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmProperties(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmProperties(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmProperties(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbtb1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBTB1)
using namespace Ovcdbtb1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcdbtb1HPP

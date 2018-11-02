// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovccmdp1.pas' rev: 29.00 (Windows)

#ifndef Ovccmdp1HPP
#define Ovccmdp1HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovccmdp1
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmScanOrder;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmScanOrder : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TListBox* lbCommands;
	Vcl::Buttons::TBitBtn* btnUp;
	Vcl::Buttons::TBitBtn* bntDown;
	Vcl::Buttons::TBitBtn* btnOk;
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Extctrls::TPanel* pnlCmdTables;
	Vcl::Buttons::TBitBtn* btnCancel;
	void __fastcall btnUpClick(System::TObject* Sender);
	void __fastcall bntDownClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmScanOrder(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmScanOrder(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmScanOrder(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmScanOrder(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovccmdp1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCCMDP1)
using namespace Ovccmdp1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovccmdp1HPP

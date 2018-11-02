// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbae0.pas' rev: 29.00 (Windows)

#ifndef Ovcdbae0HPP
#define Ovcdbae0HPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcdbae.hpp>
#include <ovcpb.hpp>
#include <ovcpf.hpp>
#include <ovcef.hpp>
#include <ovcsf.hpp>
#include <ovcstr.hpp>
#include <ovcdbsf.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbae0
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmDbAeRange;
class DELPHICLASS TLocalAE;
class DELPHICLASS TLocalEF;
class DELPHICLASS TDbAeRangeProperty;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmDbAeRange : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* lblRange;
	Vcl::Stdctrls::TLabel* lblLower;
	Vcl::Stdctrls::TLabel* lblUpper;
	Ovcpf::TOvcPictureField* pfRange;
	Ovcbase::TOvcController* DefaultController;
	Ovcsf::TOvcSimpleField* sfRange;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* Button2;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmDbAeRange(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmDbAeRange(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmDbAeRange(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmDbAeRange(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TLocalAE : public Ovcdbae::TOvcBaseDbArrayEditor
{
	typedef Ovcdbae::TOvcBaseDbArrayEditor inherited;
	
public:
	/* TOvcBaseDbArrayEditor.Create */ inline __fastcall virtual TLocalAE(System::Classes::TComponent* AOwner) : Ovcdbae::TOvcBaseDbArrayEditor(AOwner) { }
	/* TOvcBaseDbArrayEditor.Destroy */ inline __fastcall virtual ~TLocalAE(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TLocalAE(HWND ParentWindow) : Ovcdbae::TOvcBaseDbArrayEditor(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TLocalEF : public Ovcdbae::TOvcDbSimpleCell
{
	typedef Ovcdbae::TOvcDbSimpleCell inherited;
	
public:
	/* TOvcDbSimpleCell.Create */ inline __fastcall virtual TLocalEF(System::Classes::TComponent* AOwner) : Ovcdbae::TOvcDbSimpleCell(AOwner) { }
	
public:
	/* TOvcDbSimpleField.Destroy */ inline __fastcall virtual ~TLocalEF(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TLocalEF(HWND ParentWindow) : Ovcdbae::TOvcDbSimpleCell(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TDbAeRangeProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TDbAeRangeProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TDbAeRangeProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbae0 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBAE0)
using namespace Ovcdbae0;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcdbae0HPP

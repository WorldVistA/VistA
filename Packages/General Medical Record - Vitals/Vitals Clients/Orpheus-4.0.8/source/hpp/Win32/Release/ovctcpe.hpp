// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctcpe.pas' rev: 29.00 (Windows)

#ifndef OvctcpeHPP
#define OvctcpeHPP

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
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovctcbef.hpp>
#include <ovcstr.hpp>
#include <ovcef.hpp>
#include <ovcbase.hpp>
#include <ovcsf.hpp>
#include <ovcpb.hpp>
#include <ovcpf.hpp>
#include <ovctcstr.hpp>
#include <ovctcell.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctcpe
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmTCRange;
class DELPHICLASS TLocalEF;
class DELPHICLASS TLocalTC;
class DELPHICLASS TTCRangeProperty;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmTCRange : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* lblRange;
	Vcl::Stdctrls::TLabel* lblLower;
	Vcl::Stdctrls::TLabel* lblUpper;
	Ovcpf::TOvcPictureField* pfRange;
	Ovcbase::TOvcController* DefaultController;
	Ovcsf::TOvcSimpleField* sfRange;
	Vcl::Buttons::TBitBtn* btnOK;
	Vcl::Buttons::TBitBtn* btnCancel;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmTCRange(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmTCRange(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmTCRange(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmTCRange(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TLocalEF : public Ovcef::TOvcBaseEntryField
{
	typedef Ovcef::TOvcBaseEntryField inherited;
	
public:
	/* TOvcBaseEntryField.Create */ inline __fastcall virtual TLocalEF(System::Classes::TComponent* AOwner) : Ovcef::TOvcBaseEntryField(AOwner) { }
	/* TOvcBaseEntryField.Destroy */ inline __fastcall virtual ~TLocalEF(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TLocalEF(HWND ParentWindow) : Ovcef::TOvcBaseEntryField(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TLocalTC : public Ovctcbef::TOvcTCBaseEntryField
{
	typedef Ovctcbef::TOvcTCBaseEntryField inherited;
	
public:
	/* TOvcTCBaseEntryField.Create */ inline __fastcall virtual TLocalTC(System::Classes::TComponent* AOwner) : Ovctcbef::TOvcTCBaseEntryField(AOwner) { }
	
public:
	/* TOvcBaseTableCell.Destroy */ inline __fastcall virtual ~TLocalTC(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TTCRangeProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall Edit(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TTCRangeProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TTCRangeProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctcpe */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTCPE)
using namespace Ovctcpe;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvctcpeHPP

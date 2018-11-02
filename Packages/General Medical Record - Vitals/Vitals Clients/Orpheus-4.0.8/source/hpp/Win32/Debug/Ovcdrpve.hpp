// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Ovcdrpve.pas' rev: 29.00 (Windows)

#ifndef OvcdrpveHPP
#define OvcdrpveHPP

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
#include <Vcl.Grids.hpp>
#include <ovcrptvw.hpp>
#include <ovcdrpvw.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdrpve
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmRvDataItemEditor;
class DELPHICLASS TOvcReportViewItemsProperty;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmRvDataItemEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Grids::TStringGrid* StringGrid1;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* btnAdd;
	Vcl::Stdctrls::TButton* btnDelete;
	Vcl::Stdctrls::TButton* btnOk;
	void __fastcall bntAddClick(System::TObject* Sender);
	void __fastcall StringGrid1SetEditText(System::TObject* Sender, int ACol, int ARow, const System::UnicodeString Value);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	void __fastcall StringGrid1SelectCell(System::TObject* Sender, int ACol, int ARow, bool &CanSelect);
	
public:
	Ovcdrpvw::TOvcDataReportView* ReportView;
	int FieldCount;
	int CurRow;
	Designintf::_di_IDesigner Dsgn;
	Ovcdrpvw::TOvcDRVEnumEvent SaveOnEnumerate;
	void __fastcall LoadData(void);
	void __fastcall OvcDataReportView1Enumerate(System::TObject* Sender, Ovcdrpvw::TOvcDataRvItem* Data, bool &Stop, void * UserData);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmRvDataItemEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmRvDataItemEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmRvDataItemEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmRvDataItemEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcReportViewItemsProperty : public Designeditors::TPropertyEditor
{
	typedef Designeditors::TPropertyEditor inherited;
	
public:
	virtual void __fastcall Edit(void);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual System::UnicodeString __fastcall GetValue(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcReportViewItemsProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TPropertyEditor(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcReportViewItemsProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcfrmRvDataItemEditor* OvcfrmRvDataItemEditor;
extern DELPHI_PACKAGE void __fastcall ShowRvDataItemsEditor(Designintf::_di_IDesigner Des, Ovcdrpvw::TOvcDataReportView* DataReportView);
}	/* namespace Ovcdrpve */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDRPVE)
using namespace Ovcdrpve;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdrpveHPP

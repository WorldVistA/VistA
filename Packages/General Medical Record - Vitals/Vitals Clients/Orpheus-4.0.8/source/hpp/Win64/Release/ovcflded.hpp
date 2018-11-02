// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcflded.pas' rev: 29.00 (Windows)

#ifndef OvcfldedHPP
#define OvcfldedHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <ovcrptvw.hpp>
#include <ovcbase.hpp>
#include <ovccmbx.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcflded
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrmOvcRvFldEd;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrmOvcRvFldEd : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TListBox* ListBox1;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Extctrls::TPanel* Panel6;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* Label7;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TEdit* edtExpression;
	Ovccmbx::TOvcComboBox* cbxField;
	Ovccmbx::TOvcComboBox* cbxOp;
	Ovccmbx::TOvcComboBox* cbxFunc;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* edtName;
	Vcl::Stdctrls::TEdit* edtCaption;
	Vcl::Stdctrls::TEdit* edtHint;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TLabel* Label11;
	Ovccmbx::TOvcComboBox* ComboBox1;
	Vcl::Stdctrls::TLabel* Label12;
	Vcl::Stdctrls::TLabel* Label13;
	Vcl::Stdctrls::TEdit* edtWidth;
	Vcl::Stdctrls::TEdit* edtPrintWidth;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TButton* btnNewField;
	Vcl::Stdctrls::TButton* btnDelete;
	Vcl::Stdctrls::TLabel* Label14;
	Vcl::Stdctrls::TLabel* Label15;
	void __fastcall btnNewFieldClick(System::TObject* Sender);
	void __fastcall ListBox1Click(System::TObject* Sender);
	void __fastcall btnOKClick(System::TObject* Sender);
	void __fastcall cbxFieldClick(System::TObject* Sender);
	void __fastcall cbxOpClick(System::TObject* Sender);
	void __fastcall cbxFuncClick(System::TObject* Sender);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	void __fastcall edtNameExit(System::TObject* Sender);
	
private:
	Ovcrptvw::TOvcRvField* FEditField;
	void __fastcall SelectField(const System::UnicodeString FieldName);
	void __fastcall SetEditField(Ovcrptvw::TOvcRvField* const Value);
	
public:
	Ovcrptvw::TOvcCustomReportView* EditReportView;
	void __fastcall PopulateList(void);
	void __fastcall PopulateFieldCombo(void);
	__property Ovcrptvw::TOvcRvField* EditField = {read=FEditField, write=SetEditField};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrmOvcRvFldEd(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmOvcRvFldEd(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrmOvcRvFldEd(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrmOvcRvFldEd(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcflded */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCFLDED)
using namespace Ovcflded;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcfldedHPP

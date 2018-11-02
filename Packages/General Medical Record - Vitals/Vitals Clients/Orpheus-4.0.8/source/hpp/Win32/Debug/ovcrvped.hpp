// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrvped.pas' rev: 29.00 (Windows)

#ifndef OvcrvpedHPP
#define OvcrvpedHPP

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
#include <ovcpb.hpp>
#include <ovcnf.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrvped
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TRVCmpEd2;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TRVCmpEd2 : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TCheckBox* chkShowHeader;
	Vcl::Stdctrls::TCheckBox* chkShowFooter;
	Vcl::Stdctrls::TCheckBox* chkShowGroupTotals;
	Vcl::Stdctrls::TListBox* ListBox1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TCheckBox* chkTotals;
	Vcl::Stdctrls::TCheckBox* ChkOwnerDraw;
	Ovcnf::TOvcNumericField* edtWidth;
	Ovcnf::TOvcNumericField* edtPrintWidth;
	Vcl::Buttons::TBitBtn* btnOk;
	Vcl::Buttons::TBitBtn* btnCancel;
	Vcl::Stdctrls::TLabel* Label2;
	Ovcnf::TOvcNumericField* edtFilterIndex;
	Vcl::Stdctrls::TCheckBox* chkGroupBy;
	Ovcnf::TOvcNumericField* edtTag;
	Ovcnf::TOvcNumericField* edtColTag;
	Vcl::Stdctrls::TCheckBox* chkShowGroupCounts;
	Vcl::Stdctrls::TCheckBox* chkShowHint;
	Vcl::Stdctrls::TCheckBox* chkDescending;
	Vcl::Stdctrls::TCheckBox* chkAllowResize;
	Vcl::Stdctrls::TCheckBox* chkHidden;
	Vcl::Stdctrls::TCheckBox* chkVisible;
	Vcl::Stdctrls::TComboBox* cbxSortDir;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TEdit* edtFilterExp;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TEdit* edtAgg;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TComboBox* cbxDefaultSort;
	Vcl::Stdctrls::TLabel* Label6;
	void __fastcall ListBox1Click(System::TObject* Sender);
	void __fastcall chkTotalsClick(System::TObject* Sender);
	void __fastcall ChkOwnerDrawClick(System::TObject* Sender);
	void __fastcall edtWidthChange(System::TObject* Sender);
	void __fastcall edtPrintWidthChange(System::TObject* Sender);
	void __fastcall edtColTagChange(System::TObject* Sender);
	void __fastcall chkShowHintClick(System::TObject* Sender);
	void __fastcall chkAllowResizeClick(System::TObject* Sender);
	void __fastcall chkVisibleClick(System::TObject* Sender);
	void __fastcall cbxSortDirChange(System::TObject* Sender);
	void __fastcall edtAggExit(System::TObject* Sender);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TRVCmpEd2(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TRVCmpEd2(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TRVCmpEd2(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TRVCmpEd2(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcrvped */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRVPED)
using namespace Ovcrvped;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrvpedHPP

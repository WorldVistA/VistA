// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbtb0.pas' rev: 29.00 (Windows)

#ifndef Ovcdbtb0HPP
#define Ovcdbtb0HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovcef.hpp>
#include <ovcpb.hpp>
#include <ovcpf.hpp>
#include <ovcnf.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovcdbtbl.hpp>
#include <ovctbcls.hpp>
#include <ovctable.hpp>
#include <ovcsf.hpp>
#include <ovcsc.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbtb0
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmDbColEditor;
class DELPHICLASS TOvcDbTableColumnProperty;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmDbColEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Ovcsf::TOvcSimpleField* ctlColNumber;
	Vcl::Stdctrls::TComboBox* ctlCell;
	Vcl::Stdctrls::TCheckBox* ctlHidden;
	Ovcsf::TOvcSimpleField* ctlWidth;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Buttons::TSpeedButton* btnPrev;
	Vcl::Buttons::TSpeedButton* btnNext;
	Vcl::Buttons::TSpeedButton* btnFirst;
	Vcl::Buttons::TSpeedButton* btnLast;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Ovcbase::TOvcController* DefaultController;
	Ovcsc::TOvcSpinner* OvcSpinner1;
	Ovcsc::TOvcSpinner* OvcSpinner2;
	Vcl::Stdctrls::TEdit* edFieldType;
	Vcl::Stdctrls::TEdit* edFieldName;
	Vcl::Stdctrls::TEdit* edDataType;
	Vcl::Stdctrls::TEdit* edDataSize;
	Vcl::Buttons::TBitBtn* btnProperties;
	Vcl::Stdctrls::TButton* btnApply;
	Vcl::Stdctrls::TButton* btnClose;
	void __fastcall btnApplyClick(System::TObject* Sender);
	void __fastcall btnCloseClick(System::TObject* Sender);
	void __fastcall btnFirstClick(System::TObject* Sender);
	void __fastcall btnLastClick(System::TObject* Sender);
	void __fastcall btnNextClick(System::TObject* Sender);
	void __fastcall btnPrevClick(System::TObject* Sender);
	void __fastcall btnPropertiesClick(System::TObject* Sender);
	void __fastcall ctlColNumberChange(System::TObject* Sender);
	void __fastcall ctlColNumberExit(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	Ovctbcls::TOvcTableColumns* FCols;
	int FColNum;
	int CurCellIndex;
	System::Classes::TStringList* Cells;
	Ovcdbtbl::TOvcDbTableOptionSet Ops;
	
protected:
	void __fastcall AddCellComponentName(const System::UnicodeString S);
	void __fastcall GetCells(void);
	void __fastcall RefreshColData(void);
	void __fastcall SetColNum(int C);
	
public:
	System::TObject* Editor;
	void __fastcall SetCols(Ovctbcls::TOvcTableColumns* CS);
	__property Ovctbcls::TOvcTableColumns* Cols = {read=FCols, write=SetCols};
	__property int ColNum = {read=FColNum, write=SetColNum, nodefault};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmDbColEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmDbColEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmDbColEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmDbColEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcDbTableColumnProperty : public Designeditors::TClassProperty
{
	typedef Designeditors::TClassProperty inherited;
	
public:
	virtual void __fastcall Edit(void);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcDbTableColumnProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TClassProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcDbTableColumnProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbtb0 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBTB0)
using namespace Ovcdbtb0;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovcdbtb0HPP

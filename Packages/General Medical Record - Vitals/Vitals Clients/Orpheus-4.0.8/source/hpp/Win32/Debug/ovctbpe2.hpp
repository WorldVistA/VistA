// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovctbpe2.pas' rev: 29.00 (Windows)

#ifndef Ovctbpe2HPP
#define Ovctbpe2HPP

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
#include <System.TypInfo.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <ovcbase.hpp>
#include <ovcef.hpp>
#include <ovcpb.hpp>
#include <ovcnf.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovctcmmn.hpp>
#include <ovctcell.hpp>
#include <ovctbcls.hpp>
#include <ovctable.hpp>
#include <ovcsf.hpp>
#include <ovcsc.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovctbpe2
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmColEditor;
class DELPHICLASS TOvcTableColumnProperty;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmColEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Ovcsf::TOvcSimpleField* ctlColNumber;
	Vcl::Stdctrls::TComboBox* ctlDefaultCell;
	Vcl::Stdctrls::TCheckBox* ctlHidden;
	Ovcsf::TOvcSimpleField* ctlWidth;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Buttons::TSpeedButton* SpeedButton1;
	Vcl::Buttons::TSpeedButton* SpeedButton2;
	Vcl::Buttons::TSpeedButton* SpeedButton3;
	Vcl::Buttons::TSpeedButton* SpeedButton4;
	Vcl::Buttons::TSpeedButton* SpeedButton5;
	Vcl::Buttons::TSpeedButton* SpeedButton6;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Buttons::TBitBtn* DoneButton;
	Vcl::Buttons::TBitBtn* ApplyButton;
	Ovcbase::TOvcController* DefaultController;
	Ovcsc::TOvcSpinner* OvcSpinner1;
	Ovcsc::TOvcSpinner* OvcSpinner2;
	Vcl::Stdctrls::TCheckBox* ctlShowRightLine;
	Vcl::Stdctrls::TLabel* Label5;
	void __fastcall ctlColNumberExit(System::TObject* Sender);
	void __fastcall ApplyButtonClick(System::TObject* Sender);
	void __fastcall SpeedButton1Click(System::TObject* Sender);
	void __fastcall SpeedButton2Click(System::TObject* Sender);
	void __fastcall SpeedButton3Click(System::TObject* Sender);
	void __fastcall SpeedButton4Click(System::TObject* Sender);
	void __fastcall SpeedButton5Click(System::TObject* Sender);
	void __fastcall SpeedButton6Click(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall DoneButtonClick(System::TObject* Sender);
	void __fastcall ctlColNumberChange(System::TObject* Sender);
	
private:
	Ovctbcls::TOvcTableColumns* FCols;
	int FColNum;
	int CurCellIndex;
	System::Classes::TStringList* Cells;
	
protected:
	void __fastcall GetCells(void);
	void __fastcall RefreshColData(void);
	void __fastcall SetColNum(int C);
	void __fastcall AddCellComponentName(const System::UnicodeString S);
	
public:
	System::TObject* Editor;
	void __fastcall SetCols(Ovctbcls::TOvcTableColumns* CS);
	__property Ovctbcls::TOvcTableColumns* Cols = {read=FCols, write=SetCols};
	__property int ColNum = {read=FColNum, write=SetColNum, nodefault};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmColEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmColEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmColEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmColEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcTableColumnProperty : public Designeditors::TClassProperty
{
	typedef Designeditors::TClassProperty inherited;
	
public:
	virtual void __fastcall Edit(void);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcTableColumnProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TClassProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcTableColumnProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovctbpe2 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCTBPE2)
using namespace Ovctbpe2;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovctbpe2HPP

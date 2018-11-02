// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Ovcoutle.pas' rev: 29.00 (Windows)

#ifndef OvcoutleHPP
#define OvcoutleHPP

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
#include <ovcbase.hpp>
#include <ovcvlb.hpp>
#include <ovcoutln.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovceditf.hpp>
#include <ovcedpop.hpp>
#include <ovcedsld.hpp>
#include <ovcdata.hpp>
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcoutle
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmOLItemsEditor;
class DELPHICLASS TOvcOutlineItemsProperty;
class DELPHICLASS TOvcOutlineEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmOLItemsEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Ovcbase::TOvcController* OvcController1;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Ovcoutln::TOvcOutline* OvcOutline1;
	Vcl::Stdctrls::TButton* btnNewItem;
	Vcl::Stdctrls::TButton* btnNewSubItem;
	Vcl::Stdctrls::TButton* btnDelete;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* edtText;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Extctrls::TRadioGroup* rgStyle;
	Vcl::Stdctrls::TButton* btnOk;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TButton* btnApply;
	Ovcedsld::TOvcSliderEdit* OvcSliderEdit1;
	Vcl::Stdctrls::TCheckBox* chkChecked;
	Vcl::Extctrls::TRadioGroup* rgMode;
	void __fastcall btnNewItemClick(System::TObject* Sender);
	void __fastcall btnNewSubItemClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall OvcOutline1ActiveChange(Ovcoutln::TOvcCustomOutline* Sender, Ovcoutln::TOvcOutlineNode* OldNode, Ovcoutln::TOvcOutlineNode* NewNode);
	void __fastcall rgStyleClick(System::TObject* Sender);
	void __fastcall chkCheckedClick(System::TObject* Sender);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	void __fastcall btnApplyClick(System::TObject* Sender);
	void __fastcall OvcSliderEdit1Change(System::TObject* Sender);
	void __fastcall edtTextExit(System::TObject* Sender);
	
private:
	Ovcoutln::TOvcOutlineNode* FCurRoot;
	void __fastcall SetCurRoot(Ovcoutln::TOvcOutlineNode* const Value);
	
public:
	Ovcoutln::TOvcCustomOutline* EditOutline;
	Designintf::_di_IDesigner Dsgn;
	__property Ovcoutln::TOvcOutlineNode* CurRoot = {read=FCurRoot, write=SetCurRoot};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmOLItemsEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmOLItemsEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmOLItemsEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmOLItemsEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcOutlineItemsProperty : public Designeditors::TPropertyEditor
{
	typedef Designeditors::TPropertyEditor inherited;
	
public:
	virtual void __fastcall Edit(void);
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual System::UnicodeString __fastcall GetValue(void);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcOutlineItemsProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TPropertyEditor(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcOutlineItemsProperty(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcOutlineEditor : public Designeditors::TDefaultEditor
{
	typedef Designeditors::TDefaultEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TOvcOutlineEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOvcOutlineEditor(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TOvcfrmOLItemsEditor* OvcfrmOLItemsEditor;
}	/* namespace Ovcoutle */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCOUTLE)
using namespace Ovcoutle;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcoutleHPP

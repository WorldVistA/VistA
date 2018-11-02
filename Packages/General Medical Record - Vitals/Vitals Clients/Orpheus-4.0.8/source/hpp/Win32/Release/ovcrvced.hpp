// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrvced.pas' rev: 29.00 (Windows)

#ifndef OvcrvcedHPP
#define OvcrvcedHPP

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
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <ovcbase.hpp>
#include <ovcef.hpp>
#include <ovcsf.hpp>
#include <ovcrvidx.hpp>
#include <ovcrptvw.hpp>
#include <ovcdata.hpp>
#include <ovccmbx.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovclb.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrvced
{
//-- forward type declarations -----------------------------------------------
struct TTmpColumnProp;
class DELPHICLASS TRVCmpEd;
class DELPHICLASS TOvcReportViewEditor;
class DELPHICLASS TOvcRvActiveViewProperty;
class DELPHICLASS TOvcRvFieldNameProperty;
class DELPHICLASS TOvcRvImgIdxProperty;
//-- type declarations -------------------------------------------------------
typedef TTmpColumnProp *PTmpColumnProp;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTmpColumnProp
{
public:
	int Width;
	int PrintWidth;
	int ColTag;
	Ovcrvidx::TOvcAbstractRvField* ColumnDef;
	bool GroupBy;
	bool ComputeTotals;
	bool OwnerDraw;
	bool ShowHint;
	bool AllowResize;
	System::UnicodeString Name;
	Ovcrptvw::TOvcRvViewField* Ref;
	bool Visible;
	int SortDir;
	System::UnicodeString AggExp;
};
#pragma pack(pop)


enum DECLSPEC_DENUM TEditMode : unsigned char { emBrowsing, emCreating, emCloning, emEditing };

class PASCALIMPLEMENTATION TRVCmpEd : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Ovcsf::TOvcSimpleField* edtViewTitle;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TLabel* Label1;
	Ovclb::TOvcListBox* SListBox;
	Ovclb::TOvcListBox* NSListBox;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Ovclb::TOvcListBox* GListBox;
	Ovclb::TOvcListBox* NGListBox;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Buttons::TBitBtn* btnAddG;
	Vcl::Buttons::TBitBtn* btnAdd;
	Vcl::Buttons::TBitBtn* btnRemove;
	Vcl::Buttons::TBitBtn* btnUp;
	Vcl::Buttons::TBitBtn* btnDown;
	Vcl::Buttons::TBitBtn* btnProp;
	Vcl::Buttons::TBitBtn* btnOk;
	Vcl::Buttons::TBitBtn* btnCancel;
	Vcl::Stdctrls::TComboBox* cbxName;
	Ovcbase::TOvcAttachedLabel* OvcComboBox1Label1;
	Vcl::Stdctrls::TButton* btnNew;
	Vcl::Stdctrls::TButton* btnClone;
	Vcl::Stdctrls::TButton* btnEdit;
	Vcl::Stdctrls::TButton* btnDelete;
	Vcl::Extctrls::TBevel* Bevel1;
	void __fastcall SListBoxClick(System::TObject* Sender);
	void __fastcall NSListBoxClick(System::TObject* Sender);
	void __fastcall btnAddGClick(System::TObject* Sender);
	void __fastcall btnAddClick(System::TObject* Sender);
	void __fastcall GListBoxClick(System::TObject* Sender);
	void __fastcall NGListBoxClick(System::TObject* Sender);
	void __fastcall btnRemoveClick(System::TObject* Sender);
	void __fastcall btnUpClick(System::TObject* Sender);
	void __fastcall btnDownClick(System::TObject* Sender);
	void __fastcall btnPropClick(System::TObject* Sender);
	void __fastcall btnOkClick(System::TObject* Sender);
	void __fastcall cbxNameClick(System::TObject* Sender);
	void __fastcall btnNewClick(System::TObject* Sender);
	void __fastcall btnCloneClick(System::TObject* Sender);
	void __fastcall btnEditClick(System::TObject* Sender);
	void __fastcall GListBoxDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall NGListBoxDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall GListBoxDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall NGListBoxDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall btnDeleteClick(System::TObject* Sender);
	
public:
	Ovcrptvw::TOvcCustomReportView* OwnerView;
	int FilterIndex;
	System::UnicodeString FilterExp;
	int ViewTag;
	int ViewSortColumn;
	bool ViewSortDescending;
	bool ShowHeader;
	bool ShowFooter;
	bool ShowGroupTotals;
	bool ShowGroupCounts;
	bool Hidden;
	bool EditEnabled;
	bool Cloning;
	TEditMode EditMode;
	void __fastcall EnableEdit(bool Enable);
	void __fastcall LoadNewView(System::UnicodeString Name);
	void __fastcall ClearOldView(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TRVCmpEd(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TRVCmpEd(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TRVCmpEd(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TRVCmpEd(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcReportViewEditor : public Designeditors::TDefaultEditor
{
	typedef Designeditors::TDefaultEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TOvcReportViewEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TDefaultEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TOvcReportViewEditor(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRvActiveViewProperty : public Designeditors::TPropertyEditor
{
	typedef Designeditors::TPropertyEditor inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall GetValues(System::Classes::TGetStrProc Proc);
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall SetValue(const System::UnicodeString AValue)/* overload */;
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcRvActiveViewProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TPropertyEditor(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcRvActiveViewProperty(void) { }
	
	/* Hoisted overloads: */
	
public:
	inline void __fastcall  SetValue(const System::WideString Value){ Designeditors::TPropertyEditor::SetValue(Value); }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRvFieldNameProperty : public Designeditors::TPropertyEditor
{
	typedef Designeditors::TPropertyEditor inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall GetValues(System::Classes::TGetStrProc Proc);
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall SetValue(const System::UnicodeString AValue)/* overload */;
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcRvFieldNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TPropertyEditor(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcRvFieldNameProperty(void) { }
	
	/* Hoisted overloads: */
	
public:
	inline void __fastcall  SetValue(const System::WideString Value){ Designeditors::TPropertyEditor::SetValue(Value); }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRvImgIdxProperty : public Designeditors::TIntegerProperty
{
	typedef Designeditors::TIntegerProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual System::UnicodeString __fastcall GetValue(void);
	virtual void __fastcall GetValues(System::Classes::TGetStrProc Proc);
	void __fastcall ListMeasureWidth(const System::UnicodeString Value, Vcl::Graphics::TCanvas* ACanvas, int &AWidth);
	void __fastcall ListMeasureHeight(const System::UnicodeString Value, Vcl::Graphics::TCanvas* ACanvas, int &AHeight);
	void __fastcall ListDrawValue(const System::UnicodeString Value, Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, bool ASelected);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TOvcRvImgIdxProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TIntegerProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TOvcRvImgIdxProperty(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall EditViews(Designintf::_di_IDesigner Dsg, Ovcrptvw::TOvcCustomReportView* ReportView);
}	/* namespace Ovcrvced */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRVCED)
using namespace Ovcrvced;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrvcedHPP

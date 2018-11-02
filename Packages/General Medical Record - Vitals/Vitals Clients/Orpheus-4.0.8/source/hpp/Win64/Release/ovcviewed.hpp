// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcviewed.pas' rev: 29.00 (Windows)

#ifndef OvcviewedHPP
#define OvcviewedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovcdrag.hpp>
#include <ovcrptvw.hpp>
#include <ovcbase.hpp>
#include <ovcrvidx.hpp>
#include <Vcl.Menus.hpp>
#include <ovccmbx.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcviewed
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TfrmViewEd;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TfrmViewEd : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
	
private:
	enum DECLSPEC_DENUM _TfrmViewEd__1 : unsigned char { moNothing, moFields, moGroups, moColumns };
	
	
__published:
	Vcl::Stdctrls::TStaticText* StaticText1;
	Vcl::Forms::TScrollBox* Panel1;
	Vcl::Forms::TScrollBox* Panel2;
	Vcl::Forms::TScrollBox* Panel3;
	Vcl::Stdctrls::TStaticText* StaticText2;
	Vcl::Stdctrls::TStaticText* StaticText3;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* Button2;
	Vcl::Extctrls::TPanel* Panel4;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Menus::TPopupMenu* ViewFieldPopup;
	Vcl::Menus::TMenuItem* ShowTotals1;
	Vcl::Menus::TMenuItem* AllowResize1;
	Vcl::Menus::TMenuItem* ShowHint1;
	Vcl::Extctrls::TPanel* Panel5;
	Vcl::Stdctrls::TStaticText* StaticText4;
	Vcl::Extctrls::TPanel* Panel6;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TEdit* tEdit;
	Vcl::Stdctrls::TEdit* fEdit;
	Ovccmbx::TOvcComboBox* cbxField;
	Ovccmbx::TOvcComboBox* cbxOp;
	Vcl::Extctrls::TPanel* Panel7;
	Vcl::Extctrls::TPanel* Panel8;
	Vcl::Stdctrls::TCheckBox* tbHeader;
	Vcl::Stdctrls::TCheckBox* tbFooter;
	Vcl::Stdctrls::TCheckBox* tbGroupCounts;
	Vcl::Stdctrls::TCheckBox* tbGroupTotals;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* Label6;
	Vcl::Stdctrls::TLabel* Label7;
	Ovccmbx::TOvcComboBox* cbxFunc;
	Vcl::Stdctrls::TLabel* Label8;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Stdctrls::TButton* btnAdditional;
	void __fastcall tbHeaderClick(System::TObject* Sender);
	void __fastcall tbFooterClick(System::TObject* Sender);
	void __fastcall tbGroupCountsClick(System::TObject* Sender);
	void __fastcall tbGroupTotalsClick(System::TObject* Sender);
	void __fastcall ViewFieldPopupPopup(System::TObject* Sender);
	void __fastcall AllowResize1Click(System::TObject* Sender);
	void __fastcall ShowTotals1Click(System::TObject* Sender);
	void __fastcall ShowHint1Click(System::TObject* Sender);
	void __fastcall tEditChange(System::TObject* Sender);
	void __fastcall Button1Click(System::TObject* Sender);
	void __fastcall cbxFieldClick(System::TObject* Sender);
	void __fastcall cbxOpClick(System::TObject* Sender);
	void __fastcall cbxFuncClick(System::TObject* Sender);
	void __fastcall btnAdditionalClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	
private:
	Ovcrptvw::TOvcRvViewField* PopupColumn;
	MESSAGE void __fastcall WMRebuild(Winapi::Messages::TMessage &Message);
	void __fastcall ClearLists(void);
	void __fastcall OvcReportView1SortingChanged(System::TObject* Sender);
	
public:
	Ovcrptvw::TOvcCustomReportView* OwnerViewx;
	System::Classes::TList* FieldList;
	System::Classes::TList* PaintList;
	System::Classes::TList* GroupList;
	System::Classes::TList* GPaintList;
	System::Classes::TList* ColumnList;
	System::Classes::TList* CPaintList;
	Ovcdrag::TOvcDragShow* DragShow;
	System::Types::TRect FieldRect;
	System::Types::TRect GroupRect;
	System::Types::TRect ColumnRect;
	_TfrmViewEd__1 MouseOver;
	Ovcrptvw::TOvcRvField* DragField;
	Ovcrptvw::TOvcRvViewField* DragColumn;
	System::UnicodeString SaveView;
	Ovcrptvw::TOvcRVView* EV;
	Ovcrptvw::TOvcCustomReportView* EditReportView;
	void __fastcall PaintBox1Paint(System::TObject* Sender);
	void __fastcall GPaintBoxPaint(System::TObject* Sender);
	void __fastcall CPaintBoxPaint(System::TObject* Sender);
	void __fastcall FPaintBoxMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall FPaintBoxMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall FPaintBoxMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall GPaintBoxMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall GPaintBoxMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall GPaintBoxMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall CPaintBoxMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall CPaintBoxMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall CPaintBoxMouseMove(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall BuildFieldList(void);
	void __fastcall BuildGroupColumnList(void);
	void __fastcall BuildColumnList(void);
	void __fastcall CalcDragRects(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfrmViewEd(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfrmViewEd(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfrmViewEd(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfrmViewEd(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word WM_Rebuild = System::Word(0x47b);
static const System::Int8 DefGroupColWidth = System::Int8(0x14);
extern DELPHI_PACKAGE bool __fastcall EditView(Ovcrptvw::TOvcCustomReportView* ReportView);
}	/* namespace Ovcviewed */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCVIEWED)
using namespace Ovcviewed;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcviewedHPP

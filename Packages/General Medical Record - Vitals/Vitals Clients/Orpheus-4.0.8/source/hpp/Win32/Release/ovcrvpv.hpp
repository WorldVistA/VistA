// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrvpv.pas' rev: 29.00 (Windows)

#ifndef OvcrvpvHPP
#define OvcrvpvHPP

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
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrvpv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcRVPrintPreview;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcRVPrintPreview : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TComboBox* ZoomCombo;
	Vcl::Extctrls::TPanel* PaperPanel;
	Vcl::Extctrls::TPaintBox* PaintBox1;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* lblSection;
	Vcl::Buttons::TBitBtn* btnPrevSection;
	Vcl::Buttons::TBitBtn* btnNextSection;
	Vcl::Comctrls::TStatusBar* StatusBar1;
	void __fastcall btnNextClick(System::TObject* Sender);
	void __fastcall btnLastClick(System::TObject* Sender);
	void __fastcall edtPageChange(System::TObject* Sender);
	void __fastcall btnPrintClick(System::TObject* Sender);
	void __fastcall PaintBox1Paint(System::TObject* Sender);
	void __fastcall ZoomComboChange(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall btnPrevSectionClick(System::TObject* Sender);
	void __fastcall btnNextSectionClick(System::TObject* Sender);
	void __fastcall PaintBox1MouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall btnFirstClick(System::TObject* Sender);
	void __fastcall btnPrevClick(System::TObject* Sender);
	void __fastcall btnCloseClick(System::TObject* Sender);
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* btnPrint;
	Vcl::Buttons::TBitBtn* btnFirst;
	Vcl::Buttons::TBitBtn* btnPrev;
	Vcl::Buttons::TBitBtn* btnNext;
	Vcl::Buttons::TBitBtn* btnLast;
	Vcl::Stdctrls::TButton* btnClose;
	Vcl::Stdctrls::TEdit* edtPage;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* lblMaxPage;
	Vcl::Forms::TScrollBox* ScrollBox1;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall SetCurPage(const int Value);
	void __fastcall SetCurSection(const int Value);
	
protected:
	double FScale;
	int FZoom;
	int FPageNo;
	int FSectionNo;
	void __fastcall SetZoom(const int Value);
	void __fastcall ResizeCanvas(void);
	void __fastcall AlignPaper(void);
	
public:
	int FCurPage;
	int FCurSection;
	int FPageCount;
	int FSectionCount;
	Ovcrptvw::TRVPrintMode FPrintMode;
	bool FSelectedOnly;
	int FLineHeight;
	int FLinesPerPage;
	Ovcrptvw::TOvcCustomReportView* OwnerReport;
	__property int CurPage = {read=FCurPage, write=SetCurPage, nodefault};
	__property int CurSection = {read=FSectionNo, write=SetCurSection, nodefault};
	void __fastcall RenderPage(int PageNo, int SectionNo);
	__property int Zoom = {read=FZoom, write=SetZoom, nodefault};
	__property double Scale = {read=FScale};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcRVPrintPreview(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcRVPrintPreview(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcRVPrintPreview(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcRVPrintPreview(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcrvpv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRVPV)
using namespace Ovcrvpv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrvpvHPP

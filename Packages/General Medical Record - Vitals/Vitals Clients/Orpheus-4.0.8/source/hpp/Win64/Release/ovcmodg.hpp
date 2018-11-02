// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcmodg.pas' rev: 29.00 (Windows)

#ifndef OvcmodgHPP
#define OvcmodgHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.UITypes.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcdlg.hpp>
#include <ovcbase.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcmodg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmMemoDlg;
class DELPHICLASS TOvcMemoDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmMemoDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* btnHelp;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TMemo* Memo;
	Vcl::Stdctrls::TButton* btnOK;
	Vcl::Stdctrls::TButton* btnCancel;
	Vcl::Stdctrls::TLabel* lblReadOnly;
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmMemoDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmMemoDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmMemoDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmMemoDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcMemoDialog : public Ovcdlg::TOvcBaseDialog
{
	typedef Ovcdlg::TOvcBaseDialog inherited;
	
protected:
	System::Classes::TStrings* FLines;
	Vcl::Graphics::TFont* FMemoFont;
	bool FReadOnly;
	bool FWordWrap;
	void __fastcall SetLines(System::Classes::TStrings* Value);
	void __fastcall SetMemoFont(Vcl::Graphics::TFont* Value);
	
public:
	__fastcall virtual TOvcMemoDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcMemoDialog(void);
	virtual bool __fastcall Execute(void);
	
__published:
	__property Caption = {default=0};
	__property Font;
	__property Icon;
	__property Options;
	__property Placement;
	__property System::Classes::TStrings* Lines = {read=FLines, write=SetLines};
	__property Vcl::Graphics::TFont* MemoFont = {read=FMemoFont, write=SetMemoFont};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, default=1};
	__property OnHelpClick;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcmodg */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCMODG)
using namespace Ovcmodg;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcmodgHPP

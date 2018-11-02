// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovclkou1.pas' rev: 29.00 (Windows)

#ifndef Ovclkou1HPP
#define Ovclkou1HPP

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
#include <ovcspeed.hpp>
#include <ovcbase.hpp>
#include <ovcstate.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <ovclkout.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovclkou1
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcfrmLkOutEd;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcfrmLkOutEd : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* pnlItems;
	Vcl::Extctrls::TPanel* pnlFolders;
	Vcl::Stdctrls::TListBox* lbItems;
	Vcl::Stdctrls::TListBox* lbFolders;
	Vcl::Extctrls::TPanel* Panel1;
	Ovcspeed::TOvcSpeedButton* btnItemAdd;
	Ovcspeed::TOvcSpeedButton* btnItemDelete;
	Ovcspeed::TOvcSpeedButton* btnItemUp;
	Ovcspeed::TOvcSpeedButton* btnItemDown;
	Vcl::Extctrls::TPanel* Panel4;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Extctrls::TPanel* Panel5;
	Ovcspeed::TOvcSpeedButton* btnFolderAdd;
	Ovcspeed::TOvcSpeedButton* btnFolderDelete;
	Ovcspeed::TOvcSpeedButton* btnFolderUp;
	Ovcspeed::TOvcSpeedButton* btnFolderDown;
	Vcl::Extctrls::TPanel* Panel6;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Extctrls::TPanel* pnlImages;
	Vcl::Extctrls::TPanel* Panel8;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TListBox* lbImages;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall lbFoldersClick(System::TObject* Sender);
	void __fastcall lbItemsMeasureItem(Vcl::Controls::TWinControl* Control, int Index, int &Height);
	void __fastcall lbItemsDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall lbImagesDrawItem(Vcl::Controls::TWinControl* Control, int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	void __fastcall lbItemsClick(System::TObject* Sender);
	void __fastcall lbImagesClick(System::TObject* Sender);
	void __fastcall btnItemUpClick(System::TObject* Sender);
	void __fastcall btnItemDownClick(System::TObject* Sender);
	void __fastcall btnFolderUpClick(System::TObject* Sender);
	void __fastcall btnFolderDownClick(System::TObject* Sender);
	void __fastcall btnItemDeleteClick(System::TObject* Sender);
	void __fastcall btnFolderDeleteClick(System::TObject* Sender);
	void __fastcall btnFolderAddClick(System::TObject* Sender);
	void __fastcall btnItemAddClick(System::TObject* Sender);
	
public:
	Ovclkout::TOvcLookOutBar* Bar;
	Designintf::_di_IDesigner Designer;
	void __fastcall PopulateFolderList(void);
	void __fastcall PopulateItemList(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TOvcfrmLkOutEd(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TOvcfrmLkOutEd(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TOvcfrmLkOutEd(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcfrmLkOutEd(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall EditLookOut(Designintf::_di_IDesigner Designer, Ovclkout::TOvcLookOutBar* Bar);
}	/* namespace Ovclkou1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCLKOU1)
using namespace Ovclkou1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Ovclkou1HPP

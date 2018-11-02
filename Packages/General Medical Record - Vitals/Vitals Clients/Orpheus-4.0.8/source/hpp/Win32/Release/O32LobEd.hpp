// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'O32LobEd.pas' rev: 29.00 (Windows)

#ifndef O32lobedHPP
#define O32lobedHPP

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
#include <o32lkout.hpp>
#include <o32coled.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace O32lobed
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TO32LookoutBarEditor;
class DELPHICLASS TO32frmLkOutEd;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TO32LookoutBarEditor : public Designeditors::TComponentEditor
{
	typedef Designeditors::TComponentEditor inherited;
	
public:
	virtual void __fastcall ExecuteVerb(int Index);
	virtual System::UnicodeString __fastcall GetVerb(int Index);
	virtual int __fastcall GetVerbCount(void);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TO32LookoutBarEditor(System::Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Designeditors::TComponentEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TO32LookoutBarEditor(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TO32frmLkOutEd : public Vcl::Forms::TForm
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
	O32lkout::TO32LookoutBar* Bar;
	Designintf::_di_IDesigner Designer;
	void __fastcall PopulateFolderList(void);
	void __fastcall PopulateItemList(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TO32frmLkOutEd(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TO32frmLkOutEd(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TO32frmLkOutEd(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TO32frmLkOutEd(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall EditLookOut(Designintf::_di_IDesigner Designer, O32lkout::TO32LookoutBar* Bar);
}	/* namespace O32lobed */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_O32LOBED)
using namespace O32lobed;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// O32lobedHPP

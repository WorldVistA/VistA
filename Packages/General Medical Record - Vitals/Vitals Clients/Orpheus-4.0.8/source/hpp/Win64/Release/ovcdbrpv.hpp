// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbrpv.pas' rev: 29.00 (Windows)

#ifndef OvcdbrpvHPP
#define OvcdbrpvHPP

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
#include <Data.DB.hpp>
#include <ovcbase.hpp>
#include <ovcrvidx.hpp>
#include <ovcrptvw.hpp>
#include <ovcdlm.hpp>
#include <ovcconst.hpp>
#include <ovcexcpt.hpp>
#include <System.UITypes.hpp>
#include <ovcfiler.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbrpv
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDbRvDataLink;
class DELPHICLASS TOvcDbRvField;
class DELPHICLASS TOvcDbReportView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDbRvDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
protected:
	int FFieldCount;
	void *FFieldMap;
	int FFieldMapSize;
	bool FInUpdateData;
	bool FMapBuilt;
	bool FModified;
	TOvcDbReportView* FReportView;
	virtual void __fastcall ActiveChanged(void);
	virtual void __fastcall UpdateData(void);
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall DataSetScrolled(int Distance);
	virtual void __fastcall LayoutChanged(void);
	virtual void __fastcall RecordChanged(Data::Db::TField* Field);
	
public:
	__fastcall TOvcDbRvDataLink(TOvcDbReportView* AReportView);
	__property int FieldCount = {read=FFieldCount, nodefault};
public:
	/* TDataLink.Destroy */ inline __fastcall virtual ~TOvcDbRvDataLink(void) { }
	
};


class PASCALIMPLEMENTATION TOvcDbRvField : public Ovcrptvw::TOvcRvField
{
	typedef Ovcrptvw::TOvcRvField inherited;
	
__published:
	__property Alignment = {stored=false, default=0};
	__property Caption = {stored=false, default=0};
	__property CanSort = {stored=false, default=1};
	__property DefaultPrintWidth = {stored=false, default=1440};
	__property DefaultWidth = {stored=false, default=50};
public:
	/* TOvcRvField.Create */ inline __fastcall virtual TOvcDbRvField(System::Classes::TComponent* AOwner) : Ovcrptvw::TOvcRvField(AOwner) { }
	/* TOvcRvField.Destroy */ inline __fastcall virtual ~TOvcDbRvField(void) { }
	
};


typedef void __fastcall (__closure *TOvcDbRVEnumEvent)(System::TObject* Sender, bool &Stop, void * UserData);

class PASCALIMPLEMENTATION TOvcDbReportView : public Ovcrptvw::TOvcCustomReportView
{
	typedef Ovcrptvw::TOvcCustomReportView inherited;
	
protected:
	System::Classes::TList* DataList;
	System::Classes::TList* FieldList;
	System::Classes::TList* DCacheList;
	TOvcDbRvDataLink* FDataLink;
	bool FKeySearch;
	TOvcDbRVEnumEvent FOnEnumerate;
	System::UnicodeString FSearchString;
	int InMove;
	bool FUseRecordCount;
	bool FRefreshOnMove;
	bool FSyncOnOwnerDraw;
	void __fastcall ActiveChanged(void);
	void __fastcall BindViews(void);
	void __fastcall BuildFieldTable(void);
	void __fastcall ClearAll(void);
	void __fastcall ClearBindings(void);
	void __fastcall ClearDataList(void);
	void __fastcall ClearTableFields(void);
	DYNAMIC void __fastcall Click(void);
	virtual Ovcrptvw::TOvcRVListBox* __fastcall CreateListBox(void);
	System::UnicodeString __fastcall CreateValidFieldName(const System::UnicodeString FieldName);
	void __fastcall DataSetChanged(void);
	void __fastcall DataSetScrolled(void);
	DYNAMIC void __fastcall DblClick(void);
	virtual void __fastcall DoBusy(bool SetOn);
	virtual int __fastcall DoCompareFields(void * Data1, void * Data2, int FieldIndex);
	virtual void __fastcall DoDrawViewField(Vcl::Graphics::TCanvas* Canvas, void * Data, Ovcrptvw::TOvcRvField* Field, Ovcrptvw::TOvcRvViewField* ViewField, int TextAlign, bool IsSelected, bool IsGroup, int ViewFieldIndex, const System::Types::TRect &Rect, const System::UnicodeString Text, const System::UnicodeString TruncText);
	virtual System::UnicodeString __fastcall DoGetGroupString(Ovcrptvw::TOvcRvViewField* ViewField, Ovcrvidx::TOvcRvIndexGroup* GroupRef);
	virtual void __fastcall DoDetail(void * Data);
	virtual void __fastcall DoEnumEvent(void * Data, bool &Stop, void * UserData);
	virtual double __fastcall DoGetFieldAsFloat(void * Data, int FieldIndex);
	virtual System::UnicodeString __fastcall DoGetFieldAsString(void * Data, int FieldIndex);
	virtual System::Variant __fastcall DoGetFieldValue(void * Data, int Field);
	virtual void __fastcall DoKeySearch(int FieldIndex, const System::UnicodeString SearchString);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	virtual Ovcbase::TOvcCollectibleClass __fastcall GetFieldClassType(void);
	int __fastcall InternalRecordCount(void);
	virtual void __fastcall Loaded(void);
	void __fastcall MoveDataPointer(void * P);
	void __fastcall UpdateCurrentSelection(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall RecordChanged(void);
	void __fastcall ReloadData(void);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	__property TOvcDbRvDataLink* DataLink = {read=FDataLink};
	
public:
	virtual void __fastcall AssignStructure(Ovcrptvw::TOvcCustomReportView* Source);
	__fastcall virtual TOvcDbReportView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbReportView(void);
	virtual void __fastcall Enumerate(void * UserData);
	virtual void __fastcall EnumerateSelected(void * UserData);
	virtual void __fastcall EnumerateEx(bool Backwards, bool SelectedOnly, void * StartAfter, void * UserData);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	
__published:
	__property Controller;
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property bool SyncOnOwnerDraw = {read=FSyncOnOwnerDraw, write=FSyncOnOwnerDraw, default=0};
	__property ActiveView = {default=0};
	__property Align = {default=0};
	__property AutoCenter = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property BorderStyle = {default=0};
	__property Ctl3D;
	__property ColumnResize = {default=1};
	__property CustomViewStore;
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Fields;
	__property FieldWidthStore;
	__property Font;
	__property GridLines = {default=0};
	__property GroupColor = {default=-16777201};
	__property HeaderImages;
	__property HideSelection = {default=0};
	__property KeyTimeout = {default=1000};
	__property MultiSelect = {default=0};
	__property Options;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=0};
	__property PopupMenu;
	__property PrinterProperties;
	__property bool RefreshOnMove = {read=FRefreshOnMove, write=FRefreshOnMove, default=1};
	__property ScrollBars = {default=2};
	__property ShowHint = {default=1};
	__property SmoothScroll = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property bool UseRecordCount = {read=FUseRecordCount, write=FUseRecordCount, default=0};
	__property Views;
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnDetailPrint;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawViewField;
	__property OnDrawViewFieldEx;
	__property OnEnter;
	__property TOvcDbRVEnumEvent OnEnumerate = {read=FOnEnumerate, write=FOnEnumerate};
	__property OnExit;
	__property OnExtern;
	__property OnGetPrintHeaderFooter;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnPrintStatus;
	__property OnSelectionChanged;
	__property OnSignalBusy;
	__property OnSortingChanged;
	__property OnStartDrag;
	__property OnViewSelect;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbReportView(HWND ParentWindow) : Ovcrptvw::TOvcCustomReportView(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbrpv */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBRPV)
using namespace Ovcdbrpv;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbrpvHPP

// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdbidx.pas' rev: 29.00 (Windows)

#ifndef OvcdbidxHPP
#define OvcdbidxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.SysUtils.hpp>
#include <System.TypInfo.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcdata.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <ovcver.hpp>
#include <ovcdbhll.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdbidx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcIndexInfo;
class DELPHICLASS TOvcIndexSelectDataLink;
class DELPHICLASS TOvcDbIndexSelect;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TDisplayMode : unsigned char { dmFieldLabel, dmIndexName, dmFieldNames, dmFieldNumbers, dmUserDefined };

typedef void __fastcall (__closure *TGetDisplayLabelEvent)(TOvcDbIndexSelect* Sender, const System::UnicodeString FieldNames, const System::UnicodeString IndexName, Data::Db::TIndexOptions IndexOptions, System::UnicodeString &DisplayName);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcIndexInfo : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::UnicodeString FDisplayName;
	System::Classes::TStringList* FFields;
	System::UnicodeString FFieldNames;
	System::UnicodeString FIndexName;
	Data::Db::TIndexOptions FIndexOptions;
	TOvcDbIndexSelect* FOwner;
	Data::Db::TDataSet* FDataSet;
	void __fastcall SetDisplayName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TOvcIndexInfo(TOvcDbIndexSelect* AOwner, Data::Db::TDataSet* ADataSet, const System::UnicodeString AIndexName, const System::UnicodeString AFieldNames);
	__fastcall virtual ~TOvcIndexInfo(void);
	void __fastcall RefreshIndexInfo(void);
	__property System::UnicodeString DisplayName = {read=FDisplayName, write=SetDisplayName};
	__property System::Classes::TStringList* Fields = {read=FFields};
	__property System::UnicodeString FieldNames = {read=FFieldNames};
	__property System::UnicodeString IndexName = {read=FIndexName};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcIndexSelectDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
protected:
	TOvcDbIndexSelect* FIndexSelect;
	virtual void __fastcall ActiveChanged(void);
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall LayoutChanged(void);
	
public:
	__fastcall TOvcIndexSelectDataLink(TOvcDbIndexSelect* AIndexSelect);
public:
	/* TDataLink.Destroy */ inline __fastcall virtual ~TOvcIndexSelectDataLink(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TOvcDbIndexSelect : public Vcl::Stdctrls::TCustomComboBox
{
	typedef Vcl::Stdctrls::TCustomComboBox inherited;
	
protected:
	Ovcdbhll::TOvcDbEngineHelperBase* FDbEngineHelper;
	TOvcIndexSelectDataLink* FDataLink;
	TDisplayMode FDisplayMode;
	Ovcbase::TOvcLabelInfo* FLabelInfo;
	bool FMonitorIdx;
	bool FShowHidden;
	TGetDisplayLabelEvent FOnGetDisplayLabel;
	bool isRefreshPending;
	System::UnicodeString __fastcall GetAbout(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetAbout(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetDisplayMode(TDisplayMode Value);
	void __fastcall SetMonitorIdx(bool Value);
	void __fastcall SetShowHidden(bool Value);
	void __fastcall isFindIndex(void);
	Ovcbase::TOvcAttachedLabel* __fastcall GetAttachedLabel(void);
	System::UnicodeString __fastcall GetIndexName(Data::Db::TDataSet* ADataSet);
	System::UnicodeString __fastcall GetIndexFieldNames(Data::Db::TDataSet* ADataSet);
	void __fastcall LabelAttach(System::TObject* Sender, bool Value);
	void __fastcall LabelChange(System::TObject* Sender);
	void __fastcall PositionLabel(void);
	HIDESBASE MESSAGE void __fastcall CMVisibleChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMDestroy(Winapi::Messages::TWMNoParams &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Msg);
	MESSAGE void __fastcall OMAssignLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMPositionLabel(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall OMRecordLabelPosition(Winapi::Messages::TMessage &Msg);
	Ovcbase::TOvcLabelPosition DefaultLabelPosition;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall Change(void);
	virtual void __fastcall ClearObjects(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	DYNAMIC void __fastcall DropDown(void);
	
public:
	__fastcall virtual TOvcDbIndexSelect(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDbIndexSelect(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall RefreshList(void);
	void __fastcall RefreshNow(void);
	void __fastcall SetRefreshPendingFlag(void);
	__property Ovcbase::TOvcAttachedLabel* AttachedLabel = {read=GetAttachedLabel};
	__property Canvas;
	__property Items;
	__property MaxLength = {default=0};
	__property Text = {default=0};
	
__published:
	__property System::UnicodeString About = {read=GetAbout, write=SetAbout, stored=false};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property TDisplayMode DisplayMode = {read=FDisplayMode, write=SetDisplayMode, default=0};
	__property Ovcbase::TOvcLabelInfo* LabelInfo = {read=FLabelInfo, write=FLabelInfo};
	__property bool MonitorIndexChanges = {read=FMonitorIdx, write=SetMonitorIdx, default=0};
	__property bool ShowHidden = {read=FShowHidden, write=SetShowHidden, default=1};
	__property Ovcdbhll::TOvcDbEngineHelperBase* DbEngineHelper = {read=FDbEngineHelper, write=FDbEngineHelper};
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property DropDownCount = {default=8};
	__property Enabled = {default=1};
	__property Font;
	__property ItemHeight;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Sorted = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property TGetDisplayLabelEvent OnGetDisplayLabel = {read=FOnGetDisplayLabel, write=FOnGetDisplayLabel};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDrawItem;
	__property OnDropDown;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMeasureItem;
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcDbIndexSelect(HWND ParentWindow) : Vcl::Stdctrls::TCustomComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdbidx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDBIDX)
using namespace Ovcdbidx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdbidxHPP

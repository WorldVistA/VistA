// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrptvw.pas' rev: 29.00 (Windows)

#ifndef OvcrptvwHPP
#define OvcrptvwHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Variants.hpp>
#include <ovcfiler.hpp>
#include <ovcconst.hpp>
#include <ovcexcpt.hpp>
#include <ovcbase.hpp>
#include <ovcbtnhd.hpp>
#include <ovcdata.hpp>
#include <ovcmisc.hpp>
#include <ovcvlb.hpp>
#include <ovcrvidx.hpp>
#include <ovccolor.hpp>
#include <ovcrvexpdef.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrptvw
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcRVHeader;
class DELPHICLASS TOvcRVFooter;
class DELPHICLASS TOvcRvListSelectColors;
class DELPHICLASS TOvcRVListBox;
class DELPHICLASS TOvcRvField;
class DELPHICLASS TOvcRvFields;
class DELPHICLASS TOvcRvViewField;
class DELPHICLASS TOvcRvViewFields;
class DELPHICLASS TOvcRVView;
class DELPHICLASS TOvcRvViews;
class DELPHICLASS TRvPrintFont;
class DELPHICLASS TOvcRvPrintProps;
class DELPHICLASS TOvcRVOptions;
class DELPHICLASS TOvcCustomReportView;
class DELPHICLASS TOvcReportView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcRVHeader : public Ovcbtnhd::TOvcButtonHeader
{
	typedef Ovcbtnhd::TOvcButtonHeader inherited;
	
protected:
	TOvcRVListBox* FListBox;
	bool ShowingSizer;
	int LastOffset;
	bool InRearrange;
	void __fastcall HideShowSizer(int Position);
	void __fastcall HideSizer(void);
	void __fastcall ShowSizer(int ASection);
	virtual void __fastcall DoOnClick(void);
	DYNAMIC void __fastcall DblClick(void);
	DYNAMIC void __fastcall DoOnSized(int ASection, int AWidth);
	DYNAMIC void __fastcall DoOnSizing(int ASection, int AWidth);
	DYNAMIC bool __fastcall DoRearranging(int OldIndex, int NewIndex);
	DYNAMIC void __fastcall DoRearranged(int OldIndex, int NewIndex);
	virtual void __fastcall Paint(void);
	void __fastcall SetSortGlyph(void);
	
public:
	void __fastcall Reload(void);
	__property TOvcRVListBox* ListBox = {read=FListBox, write=FListBox};
public:
	/* TOvcButtonHeader.Create */ inline __fastcall virtual TOvcRVHeader(System::Classes::TComponent* AOwner) : Ovcbtnhd::TOvcButtonHeader(AOwner) { }
	/* TOvcButtonHeader.Destroy */ inline __fastcall virtual ~TOvcRVHeader(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcRVHeader(HWND ParentWindow) : Ovcbtnhd::TOvcButtonHeader(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcRVFooter : public Ovcbtnhd::TOvcButtonHeader
{
	typedef Ovcbtnhd::TOvcButtonHeader inherited;
	
protected:
	TOvcRVListBox* FListBox;
	virtual void __fastcall Paint(void);
	
public:
	void __fastcall Reload(void);
	void __fastcall UpdateSections(void);
	__property TOvcRVListBox* ListBox = {read=FListBox, write=FListBox};
public:
	/* TOvcButtonHeader.Create */ inline __fastcall virtual TOvcRVFooter(System::Classes::TComponent* AOwner) : Ovcbtnhd::TOvcButtonHeader(AOwner) { }
	/* TOvcButtonHeader.Destroy */ inline __fastcall virtual ~TOvcRVFooter(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcRVFooter(HWND ParentWindow) : Ovcbtnhd::TOvcButtonHeader(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TOvcRVGridLines : unsigned char { glNone, glVertical, glHorizontal, glBoth };

class PASCALIMPLEMENTATION TOvcRvListSelectColors : public Ovccolor::TOvcColors
{
	typedef Ovccolor::TOvcColors inherited;
	
__published:
	__property BackColor = {default=-16777203};
	__property TextColor = {default=-16777202};
public:
	/* TOvcColors.Create */ inline __fastcall virtual TOvcRvListSelectColors(System::Uitypes::TColor FG, System::Uitypes::TColor BG) : Ovccolor::TOvcColors(FG, BG) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcRvListSelectColors(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRVListBox : public Ovcvlb::TOvcVirtualListBox
{
	typedef Ovcvlb::TOvcVirtualListBox inherited;
	
protected:
	TOvcRVHeader* FButtonHeader;
	TOvcRVFooter* FFooter;
	TOvcRVGridLines FGridLines;
	Vcl::Graphics::TBitmap* LineCanvas;
	int FocusLeft;
	bool InClick;
	bool IsSimulated;
	System::Types::TRect HintRect;
	TOvcRvListSelectColors* FSelectColor;
	int __fastcall CalcMaxX(void);
	DYNAMIC void __fastcall Click(void);
	DYNAMIC void __fastcall DoEndDrag(System::TObject* Target, int X, int Y);
	DYNAMIC void __fastcall DoStartDrag(Vcl::Controls::TDragObject* &DragObject);
	virtual bool __fastcall DoOnIsSelected(int Index);
	DYNAMIC void __fastcall DoOnSelect(int Index, bool Selected);
	DYNAMIC void __fastcall DragOver(System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall DrawGroupItem(Vcl::Graphics::TCanvas* Canvas, void * Data, int Group, bool Expanded, const System::Types::TRect &Rect, System::Uitypes::TColor FGColor, System::Uitypes::TColor BGColor, Ovcrvidx::TOvcRvIndexGroup* GroupRef, bool IsSelected, int MaxX);
	HIDESBASE void __fastcall DrawItem(Vcl::Graphics::TCanvas* Canvas, void * Data, const System::Types::TRect &Rect, System::Uitypes::TColor FGColor, System::Uitypes::TColor BGColor, bool IsSelected);
	void __fastcall DrawItemG(Vcl::Graphics::TCanvas* Canvas, void * Data, const System::Types::TRect &Rect, System::Uitypes::TColor FGColor, System::Uitypes::TColor BGColor, Ovcrvidx::TOvcRvIndexGroup* GroupRef, bool IsSelected);
	System::UnicodeString __fastcall GetStringAtPos(const System::Types::TPoint &XY);
	void __fastcall InternalDrawItem(int N, const System::Types::TRect &CR);
	void __fastcall InternalSetItemIndex(int Index, bool DeselectOld);
	virtual void __fastcall Paint(void);
	void __fastcall SetGridLines(TOvcRVGridLines Value);
	virtual void __fastcall SetItemIndex(int Index);
	virtual void __fastcall SetMultiSelect(bool Value);
	virtual void __fastcall SimulatedClick(void);
	virtual void __fastcall vlbCalcFontFields(void);
	HIDESBASE void __fastcall vlbDrawFocusRect(Vcl::Graphics::TCanvas* Canvas, int Left, int Right, int Index);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMHintShow(Winapi::Messages::TMessage &Message);
	
public:
	TOvcCustomReportView* ReportView;
	DYNAMIC void __fastcall DragDrop(System::TObject* Source, int X, int Y);
	__fastcall virtual TOvcRVListBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcRVListBox(void);
	__property TOvcRVGridLines GridLines = {read=FGridLines, write=SetGridLines, nodefault};
	__property TOvcRVFooter* RVFooter = {read=FFooter, write=FFooter};
	__property TOvcRVHeader* RVHeader = {read=FButtonHeader, write=FButtonHeader};
	__property TOvcRvListSelectColors* SelectColor = {read=FSelectColor, write=FSelectColor};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcRVListBox(HWND ParentWindow) : Ovcvlb::TOvcVirtualListBox(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TOvcRvFieldSort : unsigned char { rfsFirstAscending, rfsFirstDescending, rfsAlwaysAscending, rfsAlwaysDescending };

class PASCALIMPLEMENTATION TOvcRvField : public Ovcrvidx::TOvcAbstractRvField
{
	typedef Ovcrvidx::TOvcAbstractRvField inherited;
	
protected:
	System::Classes::TAlignment FAlignment;
	System::UnicodeString FCaption;
	int FDefaultPrintWidth;
	int FDefaultWidth;
	bool FDefaultOwnerDraw;
	TOvcRvFieldSort FDefaultSortDirection;
	System::UnicodeString FExpression;
	int FImageIndex;
	bool FNoDesign;
	int FVPage;
	System::UnicodeString FHint;
	Ovcrvexpdef::TOvcRvExpression* FExp;
	bool FDirty;
	bool FDFMBased;
	Ovcrvexpdef::TOvcRvExpression* __fastcall Exp(void);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	HIDESBASE TOvcCustomReportView* __fastcall GetOwnerReport(void);
	void __fastcall SetAlignment(System::Classes::TAlignment Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	__property TOvcCustomReportView* OwnerReport = {read=GetOwnerReport};
	HIDESBASE void __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	HIDESBASE void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	void __fastcall SetImageIndex(const int Value);
	void __fastcall SetExpression(const System::UnicodeString Value);
	void __fastcall SetDirty(const bool Value);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	
public:
	__fastcall virtual TOvcRvField(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcRvField(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual System::Variant __fastcall GetValue(void * Data);
	virtual System::UnicodeString __fastcall AsString(void * Data);
	bool __fastcall InUse(void);
	bool __fastcall RefersTo(TOvcRvField* const RefField);
	void __fastcall ValidateExpression(void);
	
__published:
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property CanSort = {default=1};
	__property Ovcrvidx::TOvcDRDataType DataType = {read=FDataType, write=FDataType, default=0};
	__property bool DefaultOwnerDraw = {read=FDefaultOwnerDraw, write=FDefaultOwnerDraw, default=0};
	__property int DefaultPrintWidth = {read=FDefaultPrintWidth, write=FDefaultPrintWidth, default=1440};
	__property TOvcRvFieldSort DefaultSortDirection = {read=FDefaultSortDirection, write=FDefaultSortDirection, default=0};
	__property int DefaultWidth = {read=FDefaultWidth, write=FDefaultWidth, default=50};
	__property System::UnicodeString Expression = {read=FExpression, write=SetExpression};
	__property int ImageIndex = {read=FImageIndex, write=SetImageIndex, default=-1};
	__property System::UnicodeString Hint = {read=FHint, write=FHint};
	__property bool NoDesign = {read=FNoDesign, write=FNoDesign, default=0};
	__property bool Dirty = {read=FDirty, write=SetDirty, stored=false, nodefault};
};


class PASCALIMPLEMENTATION TOvcRvFields : public Ovcrvidx::TOvcAbstractRvFields
{
	typedef Ovcrvidx::TOvcAbstractRvFields inherited;
	
protected:
	HIDESBASE TOvcRvField* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcRvField* Value);
	TOvcCustomReportView* __fastcall GetOwnerReport(void);
	
public:
	__fastcall TOvcRvFields(TOvcCustomReportView* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	HIDESBASE TOvcRvField* __fastcall Add(void);
	__property TOvcRvField* Items[int Index] = {read=GetItem, write=SetItem};
	__property TOvcCustomReportView* Owner = {read=GetOwnerReport};
public:
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcRvFields(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRvViewField : public Ovcrvidx::TOvcAbstractRvViewField
{
	typedef Ovcrvidx::TOvcAbstractRvViewField inherited;
	
protected:
	System::UnicodeString FAggregate;
	bool FAllowResize;
	bool FOwnerDraw;
	int FPrintWidth;
	int FWidth;
	bool FShowHint;
	bool FVisible;
	Ovcrvexpdef::TOvcRvExpression* FAggExp;
	TOvcRvFieldSort FSortDirection;
	DYNAMIC void __fastcall Changed(void);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	HIDESBASE TOvcRvField* __fastcall GetField(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	TOvcCustomReportView* __fastcall GetOwnerReport(void);
	TOvcRVView* __fastcall GetOwnerView(void);
	int __fastcall GetPrintWidth(void);
	bool __fastcall GetPrintWidthStored(void);
	int __fastcall GetWidth(void);
	bool __fastcall GetWidthStored(void);
	void __fastcall SetAggregate(const System::UnicodeString Value);
	virtual void __fastcall SetIndex(int Value);
	void __fastcall SetPrintWidth(int Value);
	void __fastcall SetVisible(const bool Value);
	void __fastcall SetWidth(int Value);
	Ovcrvexpdef::TOvcRvExpression* __fastcall GetAggExp(void);
	virtual void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	virtual bool __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	bool __fastcall GetAllowResize(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcRvViewField(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcRvViewField(void);
	__property Ovcrvexpdef::TOvcRvExpression* AggExp = {read=GetAggExp};
	__property TOvcRvField* Field = {read=GetField};
	__property TOvcCustomReportView* OwnerReport = {read=GetOwnerReport};
	__property TOvcRVView* OwnerView = {read=GetOwnerView};
	
__published:
	__property bool OwnerDraw = {read=FOwnerDraw, write=FOwnerDraw, default=0};
	__property int PrintWidth = {read=GetPrintWidth, write=SetPrintWidth, stored=GetPrintWidthStored, default=-1};
	__property int Width = {read=GetWidth, write=SetWidth, stored=GetWidthStored, default=-1};
	__property ComputeTotals = {default=0};
	__property FieldName = {default=0};
	__property GroupBy = {default=0};
	__property bool ShowHint = {read=FShowHint, write=FShowHint, default=1};
	__property bool AllowResize = {read=GetAllowResize, write=FAllowResize, default=1};
	__property bool Visible = {read=FVisible, write=SetVisible, default=1};
	__property System::UnicodeString Aggregate = {read=FAggregate, write=SetAggregate};
	__property TOvcRvFieldSort SortDirection = {read=FSortDirection, write=FSortDirection, default=0};
};


class PASCALIMPLEMENTATION TOvcRvViewFields : public Ovcrvidx::TOvcAbstractRvViewFields
{
	typedef Ovcrvidx::TOvcAbstractRvViewFields inherited;
	
protected:
	HIDESBASE TOvcRvViewField* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcRvViewField* Value);
	TOvcRVView* __fastcall GetOwnerView(void);
	
public:
	__fastcall TOvcRvViewFields(TOvcRVView* AOwner);
	HIDESBASE TOvcRvViewField* __fastcall Add(void);
	__property TOvcRvViewField* Items[int Index] = {read=GetItem, write=SetItem};
	__property TOvcRVView* Owner = {read=GetOwnerView};
public:
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcRvViewFields(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRVView : public Ovcrvidx::TOvcAbstractRvView
{
	typedef Ovcrvidx::TOvcAbstractRvView inherited;
	
protected:
	bool FShowFooter;
	bool FShowHeader;
	bool FShowGroupCounts;
	bool FShowGroupTotals;
	System::UnicodeString FTitle;
	int FDefaultSortColumn;
	bool FDefaultSortDescending;
	bool FDirty;
	bool FHidden;
	bool FDFMBased;
	Ovcrvexpdef::TOvcRvExpression* FFilterExp;
	void __fastcall SetDirty(const bool Value);
	TOvcRvViewFields* __fastcall GetViewFields(void);
	HIDESBASE void __fastcall SetViewFields(TOvcRvViewFields* const Value);
	DYNAMIC System::UnicodeString __fastcall GetBaseName(void);
	HIDESBASE TOvcRvViewField* __fastcall GetViewField(int Index);
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	void __fastcall SetShowFooter(bool Value);
	void __fastcall SetShowHeader(bool Value);
	void __fastcall SetTitle(const System::UnicodeString Value);
	virtual void __fastcall SetFilter(const System::UnicodeString Value);
	bool __fastcall Include(void * Data);
	Ovcrvexpdef::TOvcRvExpression* __fastcall GetFilterExp(void);
	__property Ovcrvexpdef::TOvcRvExpression* FilterExp = {read=GetFilterExp};
	TOvcCustomReportView* __fastcall OwnerReport(void);
	System::UnicodeString __fastcall UniqueViewTitle(const System::UnicodeString Title);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcRVView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcRVView(void);
	__property bool Dirty = {read=FDirty, write=SetDirty, nodefault};
	virtual void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	virtual void __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	void __fastcall Refresh(void);
	__property TOvcRvViewField* ViewField[int Index] = {read=GetViewField};
	
__published:
	__property int DefaultSortColumn = {read=FDefaultSortColumn, write=FDefaultSortColumn, default=0};
	__property bool DefaultSortDescending = {read=FDefaultSortDescending, write=FDefaultSortDescending, default=0};
	__property System::UnicodeString Filter = {read=FFilter, write=SetFilter};
	__property bool Hidden = {read=FHidden, write=FHidden, default=0};
	__property bool ShowGroupCounts = {read=FShowGroupCounts, write=FShowGroupCounts, default=0};
	__property bool ShowGroupTotals = {read=FShowGroupTotals, write=FShowGroupTotals, default=0};
	__property bool ShowFooter = {read=FShowFooter, write=SetShowFooter, default=0};
	__property bool ShowHeader = {read=FShowHeader, write=SetShowHeader, default=1};
	__property System::UnicodeString Title = {read=FTitle, write=SetTitle};
	__property TOvcRvViewFields* ViewFields = {read=GetViewFields, write=SetViewFields};
	__property FilterIndex = {default=-1};
};


class PASCALIMPLEMENTATION TOvcRvViews : public Ovcrvidx::TOvcAbstractRvViews
{
	typedef Ovcrvidx::TOvcAbstractRvViews inherited;
	
protected:
	HIDESBASE TOvcRVView* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcRVView* Value);
	
public:
	__fastcall TOvcRvViews(TOvcCustomReportView* AOwner);
	virtual void __fastcall Clear(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	HIDESBASE TOvcRVView* __fastcall Add(void);
	__property TOvcRVView* Items[int Index] = {read=GetItem, write=SetItem};
public:
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcRvViews(void) { }
	
};


typedef void __fastcall (__closure *TOvcRVGetGroupStringEvent)(System::TObject* Sender, int FieldIndex, Ovcrvidx::TOvcRvIndexGroup* GroupRef, System::UnicodeString &Str);

typedef void __fastcall (__closure *TOvcGetPrintHeaderFooterEvent)(System::TObject* Sender, bool IsHeader, int Line, System::UnicodeString &LeftString, System::UnicodeString &CenterString, System::UnicodeString &RightString, System::Uitypes::TFontStyles &LeftAttr, System::Uitypes::TFontStyles &CenterAttr, System::Uitypes::TFontStyles &RightAttr);

typedef void __fastcall (__closure *TOvcRvSignalBusyEvent)(System::TObject* Sender, bool BusyFlag);

typedef void __fastcall (__closure *TOvcDrawViewFieldEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, void * Data, int ViewFieldIndex, const System::Types::TRect &Rect, const System::UnicodeString S);

typedef void __fastcall (__closure *TOvcDrawViewFieldExEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, TOvcRvField* Field, TOvcRvViewField* ViewField, int &TextAlign, bool IsSelected, bool IsGroupLine, void * Data, const System::Types::TRect &Rect, const System::UnicodeString Text, const System::UnicodeString TruncText, bool &DefaultDrawing);

typedef void __fastcall (__closure *TOvcPrintStatusEvent)(System::TObject* Sender, int Page, bool &Abort);

typedef void __fastcall (__closure *TOvcKeySearchEvent)(System::TObject* Sender, int SortColumn, const System::UnicodeString KeyString);

typedef void __fastcall (__closure *TOvcDetailPrintEvent)(System::TObject* Sender, void * MasterData);

enum DECLSPEC_DENUM TOvcRVExpType : unsigned char { etExpand, etCollapse, etToggle };

enum DECLSPEC_DENUM TRVPrintMode : unsigned char { pmCurrent, pmExpandAll, pmCollapseAll };

class PASCALIMPLEMENTATION TRvPrintFont : public Vcl::Graphics::TFont
{
	typedef Vcl::Graphics::TFont inherited;
	
protected:
	bool __fastcall NameStored(void);
	
__published:
	__property Charset = {default=1};
	__property Color = {default=-16777208};
	__property Height = {default=-13};
	__property Name = {stored=NameStored, default=0};
	__property Style = {default=0};
public:
	/* TFont.Create */ inline __fastcall TRvPrintFont(void) : Vcl::Graphics::TFont() { }
	/* TFont.Destroy */ inline __fastcall virtual ~TRvPrintFont(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRvPrintProps : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	int FDetailIndent;
	int FPrintColumnMargin;
	TRvPrintFont* FPrintFont;
	int FPrintFooterLines;
	int FPrintHeaderLines;
	int FPrintLineWidth;
	bool FAutoScaleColumns;
	bool FPrintGridLines;
	int FMarginLeft;
	int FMarginTop;
	int FMarginRight;
	int FMarginBottom;
	void __fastcall SetPrintFont(TRvPrintFont* Value);
	
public:
	__fastcall TOvcRvPrintProps(void);
	__fastcall virtual ~TOvcRvPrintProps(void);
	
__published:
	__property bool AutoScaleColumns = {read=FAutoScaleColumns, write=FAutoScaleColumns, default=0};
	__property int DetailIndent = {read=FDetailIndent, write=FDetailIndent, default=0};
	__property int MarginLeft = {read=FMarginLeft, write=FMarginLeft, default=0};
	__property int MarginTop = {read=FMarginTop, write=FMarginTop, default=0};
	__property int MarginRight = {read=FMarginRight, write=FMarginRight, default=0};
	__property int MarginBottom = {read=FMarginBottom, write=FMarginBottom, default=0};
	__property int PrintColumnMargin = {read=FPrintColumnMargin, write=FPrintColumnMargin, default=72};
	__property TRvPrintFont* PrintFont = {read=FPrintFont, write=SetPrintFont};
	__property int PrintFooterLines = {read=FPrintFooterLines, write=FPrintFooterLines, default=0};
	__property bool PrintGridLines = {read=FPrintGridLines, write=FPrintGridLines, default=0};
	__property int PrintHeaderLines = {read=FPrintHeaderLines, write=FPrintHeaderLines, default=0};
	__property int PrintLineWidth = {read=FPrintLineWidth, write=FPrintLineWidth, default=12};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TOvcRVOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	int FHeaderLines;
	bool FHeaderAutoHeight;
	int FHeaderHeight;
	bool FFooterAutoHeight;
	int FFooterHeight;
	TOvcCustomReportView* FOwner;
	bool FShowGroupCaptionInHeader;
	bool FShowGroupCaptionInList;
	int __fastcall GetHeaderHeight(void);
	void __fastcall SetHeaderHeight(const int Value);
	bool __fastcall NotHeaderAutoHeight(void);
	void __fastcall SetHeaderAutoHeight(const bool Value);
	int __fastcall GetFooterHeight(void);
	void __fastcall SetFooterHeight(const int Value);
	bool __fastcall NotFooterAutoHeight(void);
	void __fastcall SetFooterAutoHeight(const bool Value);
	bool __fastcall GetHeaderAllowDragRearrange(void);
	void __fastcall SetHeaderAllowDragRearrange(const bool Value);
	Ovcbtnhd::TOvcBHDrawingStyle __fastcall GetFooterDrawingStyle(void);
	Ovcbtnhd::TOvcBHDrawingStyle __fastcall GetHeaderDrawingStyle(void);
	void __fastcall SetFooterDrawingStyle(const Ovcbtnhd::TOvcBHDrawingStyle Value);
	void __fastcall SetHeaderDrawingStyle(const Ovcbtnhd::TOvcBHDrawingStyle Value);
	int __fastcall GetWheelDelta(void);
	void __fastcall SetWheelDelta(const int Value);
	bool __fastcall GetHeaderWordWrap(void);
	void __fastcall SetHeaderLines(const int Value);
	void __fastcall SetHeaderWordWrap(const bool Value);
	int __fastcall GetFooterTextMargin(void);
	int __fastcall GetHeaderTextMargin(void);
	bool __fastcall GetListAutoRowHeight(void);
	Vcl::Forms::TBorderStyle __fastcall GetListBorderStyle(void);
	System::Uitypes::TColor __fastcall GetListColor(void);
	int __fastcall GetListRowHeight(void);
	TOvcRvListSelectColors* __fastcall GetListSelectColor(void);
	void __fastcall SetFooterTextMargin(const int Value);
	void __fastcall SetHeaderTextMargin(const int Value);
	void __fastcall SetListAutoRowHeight(const bool Value);
	void __fastcall SetListBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetListColor(const System::Uitypes::TColor Value);
	void __fastcall SetListRowHeight(const int Value);
	void __fastcall SetListSelectColor(TOvcRvListSelectColors* const Value);
	void __fastcall SetShowGroupCaptionInHeader(const bool Value);
	void __fastcall SetShowGroupCaptionInList(const bool Value);
	bool __fastcall NotListAutoRowHeight(void);
	
public:
	__fastcall TOvcRVOptions(TOvcCustomReportView* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property Ovcbtnhd::TOvcBHDrawingStyle HeaderDrawingStyle = {read=GetHeaderDrawingStyle, write=SetHeaderDrawingStyle, default=3};
	__property Ovcbtnhd::TOvcBHDrawingStyle FooterDrawingStyle = {read=GetFooterDrawingStyle, write=SetFooterDrawingStyle, default=3};
	__property bool HeaderAllowDragRearrange = {read=GetHeaderAllowDragRearrange, write=SetHeaderAllowDragRearrange, default=1};
	__property bool HeaderAutoHeight = {read=FHeaderAutoHeight, write=SetHeaderAutoHeight, default=1};
	__property int HeaderHeight = {read=GetHeaderHeight, write=SetHeaderHeight, stored=NotHeaderAutoHeight, default=18};
	__property int HeaderLines = {read=FHeaderLines, write=SetHeaderLines, default=1};
	__property bool HeaderWordWrap = {read=GetHeaderWordWrap, write=SetHeaderWordWrap, default=0};
	__property int HeaderTextMargin = {read=GetHeaderTextMargin, write=SetHeaderTextMargin, default=1};
	__property bool FooterAutoHeight = {read=FFooterAutoHeight, write=SetFooterAutoHeight, default=1};
	__property int FooterHeight = {read=GetFooterHeight, write=SetFooterHeight, stored=NotFooterAutoHeight, default=18};
	__property int FooterTextMargin = {read=GetFooterTextMargin, write=SetFooterTextMargin, default=1};
	__property bool ListAutoRowHeight = {read=GetListAutoRowHeight, write=SetListAutoRowHeight, default=1};
	__property int ListRowHeight = {read=GetListRowHeight, write=SetListRowHeight, stored=NotListAutoRowHeight, default=18};
	__property Vcl::Forms::TBorderStyle ListBorderStyle = {read=GetListBorderStyle, write=SetListBorderStyle, default=1};
	__property System::Uitypes::TColor ListColor = {read=GetListColor, write=SetListColor, default=-16777211};
	__property TOvcRvListSelectColors* ListSelectColor = {read=GetListSelectColor, write=SetListSelectColor};
	__property bool ShowGroupCaptionInHeader = {read=FShowGroupCaptionInHeader, write=SetShowGroupCaptionInHeader, default=0};
	__property bool ShowGroupCaptionInList = {read=FShowGroupCaptionInList, write=SetShowGroupCaptionInList, default=1};
	__property int WheelDelta = {read=GetWheelDelta, write=SetWheelDelta, default=3};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TOvcRVOptions(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TRvChangeEvent : unsigned char { rvViewCreate, rvViewDestroy, rvViewSelect, rvDestroying };

typedef void __fastcall (__closure *TRVNotifyEvent)(TOvcCustomReportView* Sender, TRvChangeEvent Event);

enum DECLSPEC_DENUM TRvCurrentPosition : unsigned char { rvpMoveToFirst, rvpMoveToLast, rvpMoveToNext, rvpMoveToPrevious, rvpScrollToTop, rvpScrollToBottom };

typedef System::TMetaClass* TOvcReportViewClass;

typedef int __fastcall (__closure *TAdvancePageMethod)(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, int VPage, int RenderPage, bool &Abort, int PrintStartLeft);

typedef int __fastcall (__closure *TGetPageNumberMethod)(void);

class PASCALIMPLEMENTATION TOvcCustomReportView : public Ovcrvidx::TOvcAbstractReportView
{
	typedef Ovcrvidx::TOvcAbstractReportView inherited;
	
protected:
	System::UnicodeString FActiveView;
	System::UnicodeString FActiveViewByTitle;
	bool FAutoCenter;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	TOvcRVView* FCurrentView;
	Ovcfiler::TOvcAbstractStore* FFieldWidthStore;
	Ovcfiler::TOvcAbstractStore* FCustomViewStore;
	bool FDesigning;
	System::Uitypes::TColor FGroupColor;
	bool FHideSelection;
	bool FKeySearch;
	int FKeyTimeout;
	int FPageNumber;
	TOvcRvPrintProps* FPrinterProperties;
	System::Classes::TNotifyEvent FDetailPrint;
	System::Classes::TNotifyEvent FOnClick;
	System::Classes::TNotifyEvent FOnDblClick;
	TOvcDrawViewFieldEvent FOnDrawViewField;
	TOvcDrawViewFieldExEvent FOnDrawViewFieldEx;
	TOvcRVGetGroupStringEvent FOnGetGroupString;
	TOvcGetPrintHeaderFooterEvent FOnGetPrintHeaderFooter;
	Ovcrvidx::TOvcRVEnumEvent FOnEnumerate;
	Vcl::Controls::TKeyPressEvent FOnKeyPress;
	TOvcKeySearchEvent FOnKeySearch;
	TOvcPrintStatusEvent FOnPrintStatus;
	TOvcRvSignalBusyEvent FOnSignalBusy;
	System::Classes::TNotifyEvent FOnSortingChanged;
	TOvcRVOptions* FOptions;
	System::Classes::TNotifyEvent FOnViewSelect;
	TOvcCustomReportView* FPrintDetailView;
	int InPrint;
	int PLineHeight;
	int PLinesPerPage;
	int PMaxVertPage;
	int FPPageCount;
	bool PrintAborted;
	bool DidPrint;
	double PAspect;
	System::Uitypes::TScrollStyle FScrollBars;
	bool FWidthChanged;
	bool StoreChangedWidths;
	System::Classes::TList* ChangeNotificationList;
	System::UnicodeString ColWidthKey;
	System::UnicodeString KeyString;
	int LastKeyTime;
	Vcl::Extctrls::TPanel* HeaderPanel;
	Vcl::Extctrls::TPanel* FooterPanel;
	bool rvHaveHS;
	int HScrollDelta;
	int ClientExtra;
	TOvcRVHeader* FRVHeader;
	TOvcRVFooter* FRVFooter;
	TOvcRVListBox* FRVListBox;
	int UpdateCount;
	void *SaveCurItem;
	Vcl::Graphics::TFont* SaveFont;
	bool FAutoReset;
	bool FPrinting;
	void *FUserData;
	bool ViewDeleted;
	bool LoadingViews;
	bool Searching;
	void __fastcall LockListPaint(void);
	void __fastcall UnlockListPaint(void);
	DYNAMIC void __fastcall Click(void);
	void __fastcall ColumnsChanged(System::TObject* Sender);
	int __fastcall CompLineWidth2(int PrintStartLeft, int PrintStopRight);
	int __fastcall CompLineWidth(void);
	int __fastcall CountSelected(bool StopOnFirst);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual TOvcRvViews* __fastcall CreateViewCollection(void);
	virtual TOvcRVListBox* __fastcall CreateListBox(void);
	virtual TOvcRVHeader* __fastcall CreateHeader(void);
	virtual TOvcRVFooter* __fastcall CreateFooter(void);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall DblClick(void);
	virtual void __fastcall DoBusy(bool SetOn);
	virtual void __fastcall DoDetail(void * Data);
	void __fastcall DoChangeNotification(TRvChangeEvent Event);
	virtual int __fastcall DoCompareFields(void * Data1, void * Data2, int FieldIndex);
	virtual void __fastcall DoDrawViewField(Vcl::Graphics::TCanvas* Canvas, void * Data, TOvcRvField* Field, TOvcRvViewField* ViewField, int TextAlign, bool IsSelected, bool IsGroup, int ViewFieldIndex, const System::Types::TRect &Rect, const System::UnicodeString Text, const System::UnicodeString TruncText);
	virtual void __fastcall DoEnumEvent(void * Data, bool &Stop, void * UserData);
	virtual bool __fastcall DoFilter(Ovcrvidx::TOvcAbstractRvView* View, void * Data);
	virtual double __fastcall DoGetFieldAsFloat(void * Data, int Field);
	void __fastcall DoHeaderFooter(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, const bool IsHeader);
	void __fastcall DoSectionHeader(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, int VPage, int PrintStartLeft);
	virtual void __fastcall DoKeySearch(int FieldIndex, const System::UnicodeString SearchString);
	virtual void __fastcall DoLinesChanged(int LineDelta, int Offset);
	virtual void __fastcall DoLinesWillChange(void);
	virtual void __fastcall DoSortingChanged(void);
	TOvcRvField* __fastcall GetColumn(int Index);
	bool __fastcall GetColumnResize(void);
	Ovcrvidx::TOvcRvIndexGroup* __fastcall GetCurrentGroup(void);
	void * __fastcall GetCurrentItem(void);
	HIDESBASE TOvcRvField* __fastcall GetField(int Index);
	virtual Ovcbase::TOvcCollectibleClass __fastcall GetFieldClassType(void);
	TOvcRvFields* __fastcall GetFields(void);
	HIDESBASE void __fastcall SetFields(TOvcRvFields* const Value);
	bool __fastcall GetDesigning(void);
	HIDESBASE void __fastcall SetDesigning(const bool Value);
	virtual Ovcbase::TOvcCollectibleClass __fastcall GetViewClassType(void);
	TOvcRvViews* __fastcall GetViews(void);
	HIDESBASE void __fastcall SetViews(TOvcRvViews* const Value);
	TOvcRVGridLines __fastcall GetGridLines(void);
	virtual System::UnicodeString __fastcall DoGetGroupString(TOvcRvViewField* ViewField, Ovcrvidx::TOvcRvIndexGroup* GroupRef);
	virtual bool __fastcall GetHaveSelection(void);
	virtual int __fastcall GetSelectionCount(void);
	bool __fastcall GetIsGrouped(void);
	Vcl::Controls::TImageList* __fastcall GetHeaderImages(void);
	void __fastcall SetHeaderImages(Vcl::Controls::TImageList* const Value);
	bool __fastcall GetMultiSelect(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyUp(void);
	Vcl::Controls::TKeyEvent __fastcall GetOnKeyDown(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseDown(void);
	Vcl::Controls::TMouseMoveEvent __fastcall GetOnMouseMove(void);
	Vcl::Controls::TMouseEvent __fastcall GetOnMouseUp(void);
	int __fastcall GetPageNumber(void);
	Vcl::Menus::TPopupMenu* __fastcall GetPopup(void);
	bool __fastcall GetPrinting(void);
	int __fastcall GetPrintAreaHeight(void);
	int __fastcall GetPrintAreaWidth(void);
	int __fastcall GetPrintPageHeight(void);
	int __fastcall GetPrintPageWidth(void);
	int __fastcall GetPrintStartLeft(void);
	int __fastcall GetPrintStartTop(void);
	int __fastcall GetPrintStopBottom(void);
	int __fastcall GetPrintStopRight(void);
	bool __fastcall GetSmoothScroll(void);
	int __fastcall GetSortColumn(void);
	bool __fastcall GetSortDescending(void);
	TOvcRVView* __fastcall GetView(int Index);
	int __fastcall CompareValues(void * Data1, void * Data2, int FieldIndex);
	void __fastcall InternalBeginUpdate(bool LockIndexer);
	void __fastcall InternalEndUpdate(bool UnlockIndexer);
	void __fastcall ListDblClick(System::TObject* Sender);
	void __fastcall ListKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall LoadColumnWidths(void);
	virtual void __fastcall Loaded(void);
	bool __fastcall LockUpdate(void);
	void __fastcall MakeGroupVisible(Ovcrvidx::TOvcRvIndexGroup* GRef);
	MESSAGE void __fastcall WMMakeGroupVisible(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall PHResize(System::TObject* Sender);
	void __fastcall PFResize(System::TObject* Sender);
	void __fastcall AncestorNotFound(System::Classes::TReader* Reader, const System::UnicodeString ComponentName, System::Classes::TPersistentClass ComponentClass, System::Classes::TComponent* &Component);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	void __fastcall RecalcWidth(void);
	void __fastcall BeginPrint(TRVPrintMode PrintMode, bool SelectedOnly);
	void __fastcall EndPrint(TRVPrintMode PrintMode);
	int __fastcall CalcHLinesNet(void);
	int __fastcall CalcHPages(const bool SelectedOnly, const int LinesPerPage);
	void __fastcall DoLine(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, int VPage, int Line, int PrintStartLeft);
	void __fastcall DoSectionFooter(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, int VPage, int PrintStartLeft);
	int __fastcall AdvancePage(Vcl::Graphics::TCanvas* Canvas, int &CurY, int LineHeight, int VPage, int RenderPage, bool &Abort, int PrintStartLeft);
	bool __fastcall RenderPageBlock(Vcl::Graphics::TCanvas* Canvas, const int LineHeight, const int LinesPerPage, const int VPage, const int HPage, TAdvancePageMethod AdvancePage, TGetPageNumberMethod PageNumber, int &LinesLeft, int &CurY, int PrintStartLeft);
	void __fastcall ResizeColumn(void);
	void __fastcall InitScrollInfo(void);
	void __fastcall HScrollPrim(int Delta);
	void __fastcall LoadCustomViews(void);
	int __fastcall PaintCell(Vcl::Graphics::TCanvas* Canvas, int CurY, void * Data, const System::UnicodeString S, TOvcRvViewField* Cell, int Left, bool BottomLine, bool TopLine, bool PaintIt, bool Clip, bool Last, int ImageIndex, int LineHeight);
	void __fastcall PaintString(Vcl::Graphics::TCanvas* Canvas, int CurY, int LineHeight, System::UnicodeString S, System::Classes::TAlignment Alignment, int Left, int Right, const System::Uitypes::TFontStyles Attr);
	void __fastcall SaveDirtyViews(void);
	void __fastcall ScaleColumn(int C);
	void __fastcall ScaleColumnWidthsForPrint(void);
	void __fastcall SetHScrollPos(void);
	void __fastcall SetHScrollRange(void);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	void __fastcall SetActiveView(const System::UnicodeString Value);
	void __fastcall SetActiveViewByTitle(const System::UnicodeString Value);
	void __fastcall SetBorderStyle(const Vcl::Forms::TBorderStyle Value);
	void __fastcall SetColumnResize(bool Value);
	virtual void __fastcall SetDragMode(System::Uitypes::TDragMode Value);
	void __fastcall SetCurrentItem(void * Value);
	void __fastcall SetGridLines(TOvcRVGridLines Value);
	void __fastcall SetGroupColor(System::Uitypes::TColor Value);
	void __fastcall SetHideSelection(const bool Value);
	void __fastcall SetMultiSelect(bool Value);
	void __fastcall SetOnKeyUp(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnKeyDown(Vcl::Controls::TKeyEvent Value);
	void __fastcall SetOnMouseDown(Vcl::Controls::TMouseEvent Value);
	void __fastcall SetOnMouseMove(Vcl::Controls::TMouseMoveEvent Value);
	void __fastcall SetOnMouseUp(Vcl::Controls::TMouseEvent Value);
	void __fastcall SetOptions(TOvcRVOptions* const Value);
	HIDESBASE void __fastcall SetPopupMenu(Vcl::Menus::TPopupMenu* Value);
	void __fastcall SetScrollBars(const System::Uitypes::TScrollStyle Value);
	void __fastcall SetSmoothScroll(bool Value);
	void __fastcall SetSortColumn(int Value);
	void __fastcall SetSortDescending(bool Value);
	void __fastcall SetWidthChanged(bool Value);
	void __fastcall StoreColumnWidths(void);
	int __fastcall PixelsToTwips(int T);
	int __fastcall TwipsToPixels(int T);
	__property bool WidthChanged = {read=FWidthChanged, write=SetWidthChanged, nodefault};
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	__property Ovcrvidx::TOvcRVCompareFieldsEvent OnCompareFields = {read=FOnCompareFields, write=FOnCompareFields};
	__property TOvcDrawViewFieldEvent OnDrawViewField = {read=FOnDrawViewField, write=FOnDrawViewField};
	__property TOvcDrawViewFieldExEvent OnDrawViewFieldEx = {read=FOnDrawViewFieldEx, write=FOnDrawViewFieldEx};
	__property Ovcrvidx::TOvcRVEnumEvent OnEnumerate = {read=FOnEnumerate, write=FOnEnumerate};
	__property Ovcrvidx::TOvcRVFilterEvent OnFilter = {read=FOnFilter, write=FOnFilter};
	__property Ovcrvidx::TOvcRVGetFieldAsFloatEvent OnGetFieldAsFloat = {read=FOnGetFieldAsFloat, write=FOnGetFieldAsFloat};
	__property Ovcrvidx::TOvcRVGetFieldValueEvent OnGetFieldValue = {read=FGetFieldValue, write=FGetFieldValue};
	__property Ovcrvidx::TOvcRvGetGroupTotalEvent OnGetGroupTotal = {read=FOnGetGroupTotal, write=FOnGetGroupTotal};
	__property Ovcrvidx::TOvcRVGetFieldAsStringEvent OnGetFieldAsString = {read=FOnGetFieldAsString, write=FOnGetFieldAsString};
	__property TOvcRVGetGroupStringEvent OnGetGroupString = {read=FOnGetGroupString, write=FOnGetGroupString};
	__property TOvcKeySearchEvent OnKeySearch = {read=FOnKeySearch, write=FOnKeySearch};
	
public:
	__fastcall virtual TOvcCustomReportView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcCustomReportView(void);
	virtual void __fastcall AssignStructure(TOvcCustomReportView* Source);
	__property bool Designing = {read=GetDesigning, write=SetDesigning, nodefault};
	__property TOvcRVHeader* InternalHeader = {read=FRVHeader};
	__property TOvcRVFooter* InternalFooter = {read=FRVFooter};
	__property TOvcRVListBox* InternalListBox = {read=FRVListBox};
	__property int PrintPageWidth = {read=GetPrintPageWidth, nodefault};
	__property int PrintPageHeight = {read=GetPrintPageHeight, nodefault};
	__property int PrintStartLeft = {read=GetPrintStartLeft, nodefault};
	__property int PrintStopRight = {read=GetPrintStopRight, nodefault};
	__property int PrintStartTop = {read=GetPrintStartTop, nodefault};
	__property int PrintStopBottom = {read=GetPrintStopBottom, nodefault};
	__property int PrintAreaWidth = {read=GetPrintAreaWidth, nodefault};
	__property int PrintAreaHeight = {read=GetPrintAreaHeight, nodefault};
	bool __fastcall RenderPageSection(Vcl::Graphics::TCanvas* Canvas, const bool SelectedOnly, const int LineHeight, const int LinesPerPage, const int VPage, const int HPage, bool ScaleFonts);
	void __fastcall ReplaceView(const System::UnicodeString Name, TOvcRVView* NewDefinition);
	void __fastcall SaveViewToStorage(Ovcfiler::TOvcAbstractStore* Storage, TOvcRVView* View);
	System::UnicodeString __fastcall UniqueViewNameFromTitle(const System::UnicodeString Title);
	void __fastcall ScaleColumnWidths(void);
	__classmethod void __fastcall StretchDrawImageListImage(Vcl::Graphics::TCanvas* Canvas, Vcl::Controls::TImageList* ImageList, const System::Types::TRect &TargetRect, int ImageIndex, bool PreserveAspect);
	void __fastcall BeginUpdate(void);
	void __fastcall CenterCurrentLine(void);
	TOvcRvField* __fastcall ColumnFromOffset(int XOffset);
	int __fastcall DataCount(void);
	bool __fastcall EditNewView(const System::UnicodeString Title);
	bool __fastcall EditCurrentView(void);
	bool __fastcall EditCopyOfCurrentView(void);
	bool __fastcall EditCalculatedFields(void);
	void __fastcall EndUpdate(void);
	virtual void __fastcall Enumerate(void * UserData);
	virtual void __fastcall EnumerateSelected(void * UserData);
	virtual void __fastcall EnumerateEx(bool Backwards, bool SelectedOnly, void * StartAfter, void * UserData);
	__property TOvcRvFields* Fields = {read=GetFields, write=SetFields};
	DYNAMIC bool __fastcall Focused(void);
	void * __fastcall GetGroupElement(Ovcrvidx::TOvcRvIndexGroup* G);
	void __fastcall GotoNearest(void * DataRef);
	void * __fastcall ItemAtPos(const System::Types::TPoint &Pos);
	void __fastcall Navigate(TRvCurrentPosition NewPosition);
	void __fastcall Print(TRVPrintMode PrintMode, bool SelectedOnly);
	void __fastcall PrintPreview(TRVPrintMode PrintMode, bool SelectedOnly);
	void __fastcall RebuildIndexes(void);
	void __fastcall RegisterChangeNotification(TRVNotifyEvent ClientMethod);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	void __fastcall UnRegisterChangeNotification(TRVNotifyEvent ClientMethod);
	System::UnicodeString __fastcall ViewNameByTitle(const System::UnicodeString Value);
	__property System::UnicodeString ActiveView = {read=FActiveView, write=SetActiveView};
	__property System::UnicodeString ActiveViewByTitle = {read=FActiveViewByTitle, write=SetActiveViewByTitle};
	__property bool AutoCenter = {read=FAutoCenter, write=FAutoCenter, default=0};
	__property bool AutoReset = {read=FAutoReset, write=FAutoReset, default=0};
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorderStyle, write=SetBorderStyle, default=0};
	__property bool ColumnResize = {read=GetColumnResize, write=SetColumnResize, default=1};
	__property Ovcrvidx::TOvcRvIndexGroup* CurrentGroup = {read=GetCurrentGroup};
	__property void * CurrentItem = {read=GetCurrentItem, write=SetCurrentItem};
	__property TOvcRVView* CurrentView = {read=FCurrentView};
	__property Ovcfiler::TOvcAbstractStore* CustomViewStore = {read=FCustomViewStore, write=FCustomViewStore};
	__property TOvcRvField* Field[int Index] = {read=GetField};
	__property Ovcfiler::TOvcAbstractStore* FieldWidthStore = {read=FFieldWidthStore, write=FFieldWidthStore};
	__property TOvcRVGridLines GridLines = {read=GetGridLines, write=SetGridLines, default=0};
	__property System::Uitypes::TColor GroupColor = {read=FGroupColor, write=SetGroupColor, default=-16777201};
	__property bool HaveSelection = {read=GetHaveSelection, nodefault};
	__property Vcl::Controls::TImageList* HeaderImages = {read=GetHeaderImages, write=SetHeaderImages};
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, default=0};
	bool __fastcall IsEmpty(void);
	__property bool IsGrouped = {read=GetIsGrouped, nodefault};
	__property bool KeySearch = {read=FKeySearch, write=FKeySearch, default=0};
	__property int KeyTimeout = {read=FKeyTimeout, write=FKeyTimeout, default=1000};
	__property bool MultiSelect = {read=GetMultiSelect, write=SetMultiSelect, default=0};
	__property TOvcRVOptions* Options = {read=FOptions, write=SetOptions};
	__property int PageNumber = {read=FPageNumber, nodefault};
	__property int PageCount = {read=FPPageCount, nodefault};
	__property Vcl::Menus::TPopupMenu* PopupMenu = {read=GetPopup, write=SetPopupMenu};
	__property TOvcRvPrintProps* PrinterProperties = {read=FPrinterProperties, write=FPrinterProperties};
	__property bool Printing = {read=FPrinting, nodefault};
	__property TOvcCustomReportView* PrintDetailView = {read=FPrintDetailView, write=FPrintDetailView};
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, default=2};
	__property int SelectionCount = {read=GetSelectionCount, nodefault};
	__property bool SmoothScroll = {read=GetSmoothScroll, write=SetSmoothScroll, default=1};
	__property int SortColumn = {read=GetSortColumn, write=SetSortColumn, nodefault};
	__property bool SortDescending = {read=GetSortDescending, write=SetSortDescending, nodefault};
	__property void * UserData = {read=FUserData, write=FUserData};
	__property TOvcRVView* View[int Index] = {read=GetView};
	__property TOvcRvViews* Views = {read=GetViews, write=SetViews};
	__property TOvcGetPrintHeaderFooterEvent OnGetPrintHeaderFooter = {read=FOnGetPrintHeaderFooter, write=FOnGetPrintHeaderFooter};
	__property TOvcPrintStatusEvent OnPrintStatus = {read=FOnPrintStatus, write=FOnPrintStatus};
	__property TOvcRvSignalBusyEvent OnSignalBusy = {read=FOnSignalBusy, write=FOnSignalBusy};
	__property System::Classes::TNotifyEvent OnViewSelect = {read=FOnViewSelect, write=FOnViewSelect};
	__property System::Classes::TNotifyEvent OnClick = {read=FOnClick, write=FOnClick};
	__property System::Classes::TNotifyEvent OnDetailPrint = {read=FDetailPrint, write=FDetailPrint};
	__property System::Classes::TNotifyEvent OnDblClick = {read=FOnDblClick, write=FOnDblClick};
	__property OnKeyDown = {read=GetOnKeyDown, write=SetOnKeyDown};
	__property Vcl::Controls::TKeyPressEvent OnKeyPress = {read=FOnKeyPress, write=FOnKeyPress};
	__property OnKeyUp = {read=GetOnKeyUp, write=SetOnKeyUp};
	__property Vcl::Controls::TMouseEvent OnMouseDown = {read=GetOnMouseDown, write=SetOnMouseDown};
	__property Vcl::Controls::TMouseMoveEvent OnMouseMove = {read=GetOnMouseMove, write=SetOnMouseMove};
	__property Vcl::Controls::TMouseEvent OnMouseUp = {read=GetOnMouseUp, write=SetOnMouseUp};
	__property System::Classes::TNotifyEvent OnSortingChanged = {read=FOnSortingChanged, write=FOnSortingChanged};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcCustomReportView(HWND ParentWindow) : Ovcrvidx::TOvcAbstractReportView(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TOvcReportView : public TOvcCustomReportView
{
	typedef TOvcCustomReportView inherited;
	
public:
	void __fastcall AddData(const void * Data);
	void __fastcall ChangeData(const void * Data);
	void __fastcall RemoveData(const void * Data);
	void __fastcall Clear(void);
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property DragKind = {default=0};
	__property ActiveView = {default=0};
	__property Align = {default=0};
	__property AutoCenter = {default=0};
	__property BorderStyle = {default=0};
	__property Ctl3D;
	__property ColumnResize = {default=1};
	__property Controller;
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
	__property KeySearch = {default=0};
	__property KeyTimeout = {default=1000};
	__property MultiSelect = {default=0};
	__property Options;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property PrinterProperties;
	__property ScrollBars = {default=2};
	__property ShowHint = {default=1};
	__property SmoothScroll = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Views;
	__property Visible = {default=1};
	__property OnClick;
	__property OnCompareFields;
	__property OnDblClick;
	__property OnDetailPrint;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawViewField;
	__property OnDrawViewFieldEx;
	__property OnEndDrag;
	__property OnEnter;
	__property OnEnumerate;
	__property OnExit;
	__property OnExtern;
	__property OnFilter;
	__property OnGetFieldAsFloat;
	__property OnGetGroupTotal;
	__property OnGetFieldAsString;
	__property OnGetFieldValue;
	__property OnGetGroupString;
	__property OnGetPrintHeaderFooter;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnKeySearch;
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
	/* TOvcCustomReportView.Create */ inline __fastcall virtual TOvcReportView(System::Classes::TComponent* AOwner) : TOvcCustomReportView(AOwner) { }
	/* TOvcCustomReportView.Destroy */ inline __fastcall virtual ~TOvcReportView(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcReportView(HWND ParentWindow) : TOvcCustomReportView(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool rvDefShowHeader = true;
static const bool rvDefShowFooter = false;
static const bool rvDefShowGroupTotals = false;
static const bool rvDefShowGroupCounts = false;
static const System::Int8 rvDefColWidth = System::Int8(0x32);
static const System::Word rvDefColPrintWidth = System::Word(0x5a0);
static const bool rvDefColComputeTotals = false;
static const bool rvDefColOwnerDraw = false;
static const bool rvDefShowHint = true;
static const System::Word rvDefKeyTimeout = System::Word(0x3e8);
static const System::Word OM_MAKEGROUPVISIBLE = System::Word(0x7f03);
extern DELPHI_PACKAGE bool OvcRptVwShowTruncTextHint;
extern DELPHI_PACKAGE int __fastcall CompareInt(int I1, int I2);
extern DELPHI_PACKAGE int __fastcall CompareFloat(System::Extended F1, System::Extended F2);
extern DELPHI_PACKAGE int __fastcall CompareComp(System::Comp F1, System::Comp F2);
}	/* namespace Ovcrptvw */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRPTVW)
using namespace Ovcrptvw;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrptvwHPP

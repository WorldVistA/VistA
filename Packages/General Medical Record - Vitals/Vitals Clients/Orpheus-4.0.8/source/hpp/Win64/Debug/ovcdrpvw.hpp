// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcdrpvw.pas' rev: 29.00 (Windows)

#ifndef OvcdrpvwHPP
#define OvcdrpvwHPP

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
#include <ovcconst.hpp>
#include <ovcexcpt.hpp>
#include <ovcmisc.hpp>
#include <ovcbase.hpp>
#include <ovcrvidx.hpp>
#include <ovcrptvw.hpp>
#include <System.Types.hpp>
#include <Vcl.Controls.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Forms.hpp>
#include <ovcfiler.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcdrpvw
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcDataRvField;
class DELPHICLASS TOvcDataRvItem;
class DELPHICLASS TOvcDataRvItems;
class DELPHICLASS TOvcDataReportView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TOvcDataRvField : public Ovcrptvw::TOvcRvField
{
	typedef Ovcrptvw::TOvcRvField inherited;
	
protected:
	System::UnicodeString FFormat;
	bool FCustomFormat;
	void __fastcall SetDataType(Ovcrvidx::TOvcDRDataType Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property bool CustomFormat = {read=FCustomFormat, write=FCustomFormat, default=0};
	__property Ovcrvidx::TOvcDRDataType DataType = {read=FDataType, write=SetDataType, default=0};
	__property System::UnicodeString Format = {read=FFormat, write=FFormat};
public:
	/* TOvcRvField.Create */ inline __fastcall virtual TOvcDataRvField(System::Classes::TComponent* AOwner) : Ovcrptvw::TOvcRvField(AOwner) { }
	/* TOvcRvField.Destroy */ inline __fastcall virtual ~TOvcDataRvField(void) { }
	
};


typedef System::StaticArray<int, 536870911> TIntArray;

typedef TIntArray *PIntArray;

typedef System::StaticArray<System::Byte, 2147483647> TByteArray;

typedef TByteArray *PByteArray;

class PASCALIMPLEMENTATION TOvcDataRvItem : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	void *FData;
	TOvcDataReportView* FOwner;
	TOvcDataRvItems* FOwnerList;
	TIntArray *FieldIndexTable;
	TIntArray *FieldSizeTable;
	int FieldIndexSize;
	TByteArray *DataBuffer;
	int DataBufferSize;
	bool Temp;
	void __fastcall Changed(void);
	void __fastcall CheckType(int Index, Ovcrvidx::TOvcDRDataType DataType);
	void __fastcall ClearData(void);
	bool __fastcall InternalGetAsBoolean(int Index);
	bool __fastcall GetAsBoolean(int Index);
	System::TDateTime __fastcall GetAsDateTime(int Index);
	System::TDateTime __fastcall InternalGetAsDateTime(int Index);
	unsigned __fastcall InternalGetAsDWord(int Index);
	unsigned __fastcall GetAsDWord(int Index);
	void * __fastcall GetCustomFieldBuffer(int Index);
	System::Variant __fastcall GetValue(int Index);
	void __fastcall SetValue(int Index, const System::Variant &Value);
	System::Extended __fastcall GetAsFloat(int Index);
	System::Extended __fastcall InternalGetAsFloat(int Index);
	int __fastcall InternalGetAsInteger(int Index);
	int __fastcall GetAsInteger(int Index);
	System::UnicodeString __fastcall GetAsString(int Index);
	int __fastcall GetFieldSize(int Index);
	bool __fastcall GetSelected(void);
	void __fastcall SetAsBoolean(int Index, const bool Value);
	void __fastcall SetAsDateTime(int Index, const System::TDateTime Value);
	void __fastcall SetAsDWord(int Index, const unsigned Value);
	void __fastcall SetAsFloat(int Index, const System::Extended Value);
	void __fastcall SetAsInteger(int Index, const int Value);
	void __fastcall SetAsString(int Index, const System::UnicodeString Value);
	void __fastcall SetFieldSize(int Index, int NewSize);
	void __fastcall SetSelected(bool Value);
	void __fastcall ValidateData(void);
	__property int FieldSize[int Index] = {read=GetFieldSize, write=SetFieldSize};
	__fastcall TOvcDataRvItem(TOvcDataReportView* AOwner, TOvcDataRvItems* AOwnerList, bool Temporary);
	System::WideChar * __fastcall GetAsPChar(int Index);
	__property System::WideChar * AsPChar[int Index] = {read=GetAsPChar};
	void __fastcall PreAllocate(void);
	
public:
	void __fastcall Assign(TOvcDataRvItem* Source);
	__fastcall virtual ~TOvcDataRvItem(void);
	void __fastcall ReadFromStream(System::Classes::TStream* Stream);
	void __fastcall WriteToStream(System::Classes::TStream* Stream);
	__property System::UnicodeString AsString[int Index] = {read=GetAsString, write=SetAsString};
	__property System::Extended AsFloat[int Index] = {read=GetAsFloat, write=SetAsFloat};
	__property System::TDateTime AsDateTime[int Index] = {read=GetAsDateTime, write=SetAsDateTime};
	__property int AsInteger[int Index] = {read=GetAsInteger, write=SetAsInteger};
	__property bool AsBoolean[int Index] = {read=GetAsBoolean, write=SetAsBoolean};
	__property unsigned AsDWord[int Index] = {read=GetAsDWord, write=SetAsDWord};
	void __fastcall SetCustom(int Index, const void *Value, unsigned Size);
	__property System::Variant Value[int Index] = {read=GetValue, write=SetValue};
	__property void * Data = {read=FData, write=FData};
	__property bool Selected = {read=GetSelected, write=SetSelected, nodefault};
};


class PASCALIMPLEMENTATION TOvcDataRvItems : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TOvcDataRvItem* operator[](int Index) { return Item[Index]; }
	
protected:
	System::Classes::TList* FItems;
	TOvcDataReportView* FOwner;
	System::Classes::TMemoryStream* PendingStream;
	bool ClearingAll;
	int __fastcall GetCount(void);
	TOvcDataRvItem* __fastcall GetItem(int Index);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	
public:
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	__fastcall virtual TOvcDataRvItems(TOvcDataReportView* AOwner);
	__fastcall virtual ~TOvcDataRvItems(void);
	TOvcDataRvItem* __fastcall Add(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall Clear(void);
	__property int Count = {read=GetCount, nodefault};
	__property TOvcDataRvItem* Item[int Index] = {read=GetItem/*, default*/};
};


typedef void __fastcall (__closure *TOvcDRVCompareCustomEvent)(System::TObject* Sender, int FieldIndex, void * Data1, void * Data2, int &Result);

typedef void __fastcall (__closure *TOvcDRVGetCustomAsStringEvent)(System::TObject* Sender, int FieldIndex, void * Data, System::UnicodeString &Result);

typedef void __fastcall (__closure *TOvcDRVGetCustomFieldSizeEvent)(System::TObject* Sender, int FieldIndex, unsigned &Result);

typedef void __fastcall (__closure *TOvcDrawDViewFieldEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, TOvcDataRvItem* Data, int ViewFieldIndex, const System::Types::TRect &Rect, const System::UnicodeString S);

typedef void __fastcall (__closure *TOvcDrawDViewFieldExEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, Ovcrptvw::TOvcRvField* Field, Ovcrptvw::TOvcRvViewField* ViewField, int &TextAlign, bool IsSelected, bool IsGroupLine, TOvcDataRvItem* Data, const System::Types::TRect &Rect, const System::UnicodeString Text, const System::UnicodeString TruncText, bool &DefaultDrawing);

typedef void __fastcall (__closure *TOvcDRVEnumEvent)(System::TObject* Sender, TOvcDataRvItem* Data, bool &Stop, void * UserData);

typedef void __fastcall (__closure *TOvcDRVFilterEvent)(System::TObject* Sender, TOvcDataRvItem* Data, int FilterIndex, bool &Include);

typedef void __fastcall (__closure *TOvcDRVFormatFloatEvent)(System::TObject* Sender, int Index, const double Value, System::UnicodeString &Result);

class PASCALIMPLEMENTATION TOvcDataReportView : public Ovcrptvw::TOvcCustomReportView
{
	typedef Ovcrptvw::TOvcCustomReportView inherited;
	
protected:
	TOvcDataRvItems* FItems;
	TOvcDrawDViewFieldEvent FOnDrawViewField;
	TOvcDrawDViewFieldExEvent FOnDrawViewFieldEx;
	TOvcDRVEnumEvent FOnEnumerate;
	TOvcDRVFormatFloatEvent FOnFormatFloat;
	TOvcDRVCompareCustomEvent FOnCompareCustom;
	TOvcDRVGetCustomAsStringEvent FOnGetCustomAsString;
	void __fastcall CountSelection(System::TObject* Sender, TOvcDataRvItem* Data, bool &Stop, void * UserData);
	void __fastcall CountSelection2(System::TObject* Sender, TOvcDataRvItem* Data, bool &Stop, void * UserData);
	int __fastcall DoCompareCustom(int FieldIndex, void * Data1, void * Data2);
	virtual int __fastcall DoCompareFields(void * Data1, void * Data2, int FieldIndex);
	virtual void __fastcall DoDrawViewField(Vcl::Graphics::TCanvas* Canvas, void * Data, Ovcrptvw::TOvcRvField* Field, Ovcrptvw::TOvcRvViewField* ViewField, int TextAlign, bool IsSelected, bool IsGroup, int ViewFieldIndex, const System::Types::TRect &Rect, const System::UnicodeString Text, const System::UnicodeString TruncText);
	virtual void __fastcall DoEnumEvent(void * Data, bool &Stop, void * UserData);
	System::UnicodeString __fastcall DoGetCustomAsString(int FieldIndex, void * Data);
	virtual double __fastcall DoGetFieldAsFloat(void * Data, int Field);
	virtual System::UnicodeString __fastcall DoGetFieldAsString(void * Data, int FieldIndex);
	virtual System::Variant __fastcall DoGetFieldValue(void * Data, int Field);
	virtual bool __fastcall DoFilter(Ovcrvidx::TOvcAbstractRvView* View, void * Data);
	virtual System::UnicodeString __fastcall DoGetGroupString(Ovcrptvw::TOvcRvViewField* ViewField, Ovcrvidx::TOvcRvIndexGroup* GroupRef);
	virtual void __fastcall DoKeySearch(int FieldIndex, const System::UnicodeString SearchString);
	HIDESBASE TOvcDataRvItem* __fastcall GetCurrentItem(void);
	HIDESBASE TOvcDataRvField* __fastcall GetField(int Index);
	virtual Ovcbase::TOvcCollectibleClass __fastcall GetFieldClassType(void);
	virtual void __fastcall Loaded(void);
	HIDESBASE void __fastcall SetCurrentItem(TOvcDataRvItem* const Value);
	TOvcDRVFilterEvent __fastcall GetOnFilter(void);
	void __fastcall SetOnFilter(const TOvcDRVFilterEvent Value);
	virtual bool __fastcall GetHaveSelection(void);
	virtual int __fastcall GetSelectionCount(void);
	
public:
	__fastcall virtual TOvcDataReportView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcDataReportView(void);
	__property TOvcDataRvItem* CurrentItem = {read=GetCurrentItem, write=SetCurrentItem};
	virtual void __fastcall Enumerate(void * UserData);
	virtual void __fastcall EnumerateSelected(void * UserData);
	virtual void __fastcall EnumerateEx(bool Backwards, bool SelectedOnly, void * StartAfter, void * UserData);
	__property TOvcDataRvField* Field[int Index] = {read=GetField};
	
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
	__property TOvcDataRvItems* Items = {read=FItems, write=FItems};
	__property KeySearch = {default=0};
	__property KeyTimeout = {default=1000};
	__property MultiSelect = {default=0};
	__property Options;
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=0};
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
	__property TOvcDRVCompareCustomEvent OnCompareCustom = {read=FOnCompareCustom, write=FOnCompareCustom};
	__property OnDetailPrint;
	__property OnDragDrop;
	__property OnDragOver;
	__property TOvcDRVFormatFloatEvent OnFormatFloat = {read=FOnFormatFloat, write=FOnFormatFloat};
	__property TOvcDRVGetCustomAsStringEvent OnGetCustomAsString = {read=FOnGetCustomAsString, write=FOnGetCustomAsString};
	__property OnDblClick;
	__property TOvcDrawDViewFieldEvent OnDrawViewField = {read=FOnDrawViewField, write=FOnDrawViewField};
	__property TOvcDrawDViewFieldExEvent OnDrawViewFieldEx = {read=FOnDrawViewFieldEx, write=FOnDrawViewFieldEx};
	__property TOvcDRVEnumEvent OnEnumerate = {read=FOnEnumerate, write=FOnEnumerate};
	__property OnEnter;
	__property OnExtern;
	__property TOvcDRVFilterEvent OnFilter = {read=GetOnFilter, write=SetOnFilter};
	__property OnExit;
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
	/* TWinControl.CreateParented */ inline __fastcall TOvcDataReportView(HWND ParentWindow) : Ovcrptvw::TOvcCustomReportView(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ovcdrpvw */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCDRPVW)
using namespace Ovcdrpvw;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcdrpvwHPP

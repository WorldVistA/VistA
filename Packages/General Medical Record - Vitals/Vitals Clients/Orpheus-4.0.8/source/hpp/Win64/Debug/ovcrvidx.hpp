// CodeGear C++Builder
// Copyright (c) 1995, 2015 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ovcrvidx.pas' rev: 29.00 (Windows)

#ifndef OvcrvidxHPP
#define OvcrvidxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <ovcbase.hpp>
#include <ovcconst.hpp>
#include <ovcexcpt.hpp>
#include <ovcdlm.hpp>
#include <ovcfiler.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ovcrvidx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOvcAbstractRvField;
class DELPHICLASS TOvcAbstractRvFields;
class DELPHICLASS TOvcAbstractRvViewField;
class DELPHICLASS TOvcAbstractRvViewFields;
class DELPHICLASS TOvcAbstractRvView;
class DELPHICLASS TOvcAbstractRvViews;
class DELPHICLASS TOvcRvIndexGroup;
class DELPHICLASS TOvcRvIndexSuperGroup;
class DELPHICLASS TOvcRvIndex;
class DELPHICLASS TOvcAbstractReportView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TOvcDRDataType : unsigned char { dtString, dtFloat, dtInteger, dtDateTime, dtBoolean, dtDWord, dtCustom };

class PASCALIMPLEMENTATION TOvcAbstractRvField : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	bool FCanSort;
	TOvcDRDataType FDataType;
	TOvcAbstractReportView* __fastcall GetOwnerReport(void);
	bool __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	
public:
	__fastcall virtual TOvcAbstractRvField(System::Classes::TComponent* AOwner);
	__property TOvcDRDataType DataType = {read=FDataType, write=FDataType, nodefault};
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property TOvcAbstractReportView* OwnerReport = {read=GetOwnerReport};
	__property bool CanSort = {read=FCanSort, write=FCanSort, default=1};
	virtual System::Variant __fastcall GetValue(void * Data);
	virtual System::UnicodeString __fastcall AsString(void * Data);
public:
	/* TOvcCollectible.Destroy */ inline __fastcall virtual ~TOvcAbstractRvField(void) { }
	
};


class PASCALIMPLEMENTATION TOvcAbstractRvFields : public Ovcbase::TOvcCollection
{
	typedef Ovcbase::TOvcCollection inherited;
	
protected:
	TOvcAbstractReportView* FOwner;
	HIDESBASE TOvcAbstractRvField* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcAbstractRvField* Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	HIDESBASE TOvcAbstractRvField* __fastcall ItemByName(const System::UnicodeString Name);
	__property TOvcAbstractRvField* Items[int Index] = {read=GetItem, write=SetItem};
	__property TOvcAbstractReportView* Owner = {read=FOwner};
public:
	/* TOvcCollection.Create */ inline __fastcall TOvcAbstractRvFields(System::Classes::TComponent* AOwner, Ovcbase::TOvcCollectibleClass ItemClass) : Ovcbase::TOvcCollection(AOwner, ItemClass) { }
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcAbstractRvFields(void) { }
	
};


class PASCALIMPLEMENTATION TOvcAbstractRvViewField : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	System::UnicodeString FFieldName;
	bool FGroupBy;
	bool FComputeTotals;
	TOvcAbstractRvView* FOwnerView;
	void __fastcall SetFieldName(const System::UnicodeString Value);
	TOvcAbstractRvField* FField;
	TOvcAbstractReportView* FOwnerReport;
	TOvcAbstractRvField* __fastcall GetField(void);
	virtual void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	virtual bool __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	
public:
	void __fastcall ClearField(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TOvcAbstractRvViewField(System::Classes::TComponent* AOwner);
	__property bool ComputeTotals = {read=FComputeTotals, write=FComputeTotals, default=0};
	__property TOvcAbstractRvField* Field = {read=GetField};
	__property System::UnicodeString FieldName = {read=FFieldName, write=SetFieldName};
	__property bool GroupBy = {read=FGroupBy, write=FGroupBy, default=0};
	__property TOvcAbstractReportView* OwnerReport = {read=FOwnerReport};
	__property TOvcAbstractRvView* OwnerView = {read=FOwnerView};
public:
	/* TOvcCollectible.Destroy */ inline __fastcall virtual ~TOvcAbstractRvViewField(void) { }
	
};


class PASCALIMPLEMENTATION TOvcAbstractRvViewFields : public Ovcbase::TOvcCollection
{
	typedef Ovcbase::TOvcCollection inherited;
	
protected:
	HIDESBASE TOvcAbstractRvViewField* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcAbstractRvViewField* Value);
	TOvcAbstractRvView* __fastcall GetOwnerEx(void);
	
public:
	__property TOvcAbstractRvView* Owner = {read=GetOwnerEx};
	__property TOvcAbstractRvViewField* Items[int Index] = {read=GetItem, write=SetItem};
public:
	/* TOvcCollection.Create */ inline __fastcall TOvcAbstractRvViewFields(System::Classes::TComponent* AOwner, Ovcbase::TOvcCollectibleClass ItemClass) : Ovcbase::TOvcCollection(AOwner, ItemClass) { }
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcAbstractRvViewFields(void) { }
	
};


class PASCALIMPLEMENTATION TOvcAbstractRvView : public Ovcbase::TOvcCollectible
{
	typedef Ovcbase::TOvcCollectible inherited;
	
protected:
	int FFilterIndex;
	System::UnicodeString FFilter;
	void __fastcall SetViewFields(TOvcAbstractRvViewFields* Value);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	int __fastcall GetGroupCount(void);
	virtual void __fastcall SaveToStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	virtual void __fastcall LoadFromStorage(Ovcfiler::TOvcAbstractStore* Storage, const System::UnicodeString Prefix);
	TOvcAbstractRvViewFields* FViewFields;
	TOvcAbstractRvViewField* __fastcall GetViewField(int Index);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual ~TOvcAbstractRvView(void);
	__property int FilterIndex = {read=FFilterIndex, write=FFilterIndex, default=-1};
	__property int GroupCount = {read=GetGroupCount, nodefault};
	__property TOvcAbstractRvViewField* ViewField[int Index] = {read=GetViewField};
	__property TOvcAbstractRvViewFields* ViewFields = {read=FViewFields, write=SetViewFields};
public:
	/* TOvcCollectible.Create */ inline __fastcall virtual TOvcAbstractRvView(System::Classes::TComponent* AOwner) : Ovcbase::TOvcCollectible(AOwner) { }
	
};


class PASCALIMPLEMENTATION TOvcAbstractRvViews : public Ovcbase::TOvcCollection
{
	typedef Ovcbase::TOvcCollection inherited;
	
protected:
	HIDESBASE TOvcAbstractRvView* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TOvcAbstractRvView* Value);
	TOvcAbstractReportView* FOwner;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property TOvcAbstractReportView* Owner = {read=FOwner};
	__property TOvcAbstractRvView* Items[int Index] = {read=GetItem, write=SetItem};
public:
	/* TOvcCollection.Create */ inline __fastcall TOvcAbstractRvViews(System::Classes::TComponent* AOwner, Ovcbase::TOvcCollectibleClass ItemClass) : Ovcbase::TOvcCollection(AOwner, ItemClass) { }
	/* TOvcCollection.Destroy */ inline __fastcall virtual ~TOvcAbstractRvViews(void) { }
	
};


typedef void __fastcall (__closure *TOvcRVCompareFieldsEvent)(System::TObject* Sender, void * Data1, void * Data2, int FieldIndex, int &Res);

typedef void __fastcall (__closure *TOvcRVGetFieldAsFloatEvent)(System::TObject* Sender, void * Data, int FieldIndex, double &Value);

typedef void __fastcall (__closure *TOvcRVGetFieldValueEvent)(System::TObject* Sender, void * Data, int FieldIndex, System::Variant &Value);

typedef void __fastcall (__closure *TOvcRVGetFieldAsStringEvent)(System::TObject* Sender, void * Data, int FieldIndex, System::UnicodeString &Str);

typedef void __fastcall (__closure *TOvcRvGetGroupTotalEvent)(System::TObject* Sender, TOvcRvIndexGroup* Group, double &Result);

typedef void __fastcall (__closure *TOvcRVEnumEvent)(System::TObject* Sender, void * Data, bool &Stop, void * UserData);

typedef void __fastcall (__closure *TOvcRVFilterEvent)(System::TObject* Sender, void * Data, int FilterIndex, bool &Include);

typedef void __fastcall (__closure *TOvcRVLinesChangedEvent)(TOvcAbstractReportView* Sender, int LineDelta, int Offset);

typedef void __fastcall (__closure *TOvcRVExternEvent)(TOvcAbstractReportView* Sender, const System::Variant &ArgList, System::Variant &Result);

enum DECLSPEC_DENUM TRvEnumMode : unsigned char { emExpandAll, emCollapseAll };

class PASCALIMPLEMENTATION TOvcRvIndexGroup : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FExpanded;
	TOvcRvIndexGroup* FGroup;
	TOvcRvIndex* FOwner;
	int FAbsGroupColumn;
	int FAbsSortColumn;
	int FGroupColumn;
	TOvcAbstractRvView* FView;
	Ovcdlm::TOvcFastList* FElements;
	int OwnerFieldCount;
	bool FContainsGroups;
	bool Dirty;
	int FLines;
	int __fastcall FindData(void * Data);
	void __fastcall ClearElementList(void);
	TOvcRvIndexGroup* __fastcall GetElement(int I);
	int __fastcall CompareGroupTotals(TOvcRvIndexGroup* Item1, TOvcRvIndexGroup* Item2);
	int __fastcall CompareValueTotals(TOvcRvIndexGroup* Item1, TOvcRvIndexGroup* Item2);
	int __fastcall CompareItemValues(TOvcRvIndexGroup* Item1, TOvcRvIndexGroup* Item2);
	int __fastcall CompareGroupValues(TOvcRvIndexGroup* Item1, TOvcRvIndexGroup* Item2);
	int __fastcall GetCount(void);
	void * __fastcall GetData(void);
	TOvcRvIndexGroup* __fastcall GetElementAtLine(int &Line);
	void * __fastcall GetDataAtLine(int &Line);
	int __fastcall GetItemCount(void);
	int __fastcall GetLines(void);
	int __fastcall GetOffsetOfData(void * DataValue);
	int __fastcall GetOffsetOfGroup(TOvcRvIndexGroup* Group);
	bool __fastcall GetSelected(void);
	double __fastcall GetTotal(int Field);
	void __fastcall ResetLines(void);
	void __fastcall SetExpanded(bool Value);
	void __fastcall SetSelected(const bool Value);
	void __fastcall Sort(void);
	
public:
	__property TOvcRvIndexGroup* Element[int I] = {read=GetElement};
	__property bool ContainsGroups = {read=FContainsGroups, nodefault};
	__fastcall TOvcRvIndexGroup(TOvcRvIndex* AOwner, TOvcRvIndexGroup* AGroup, int AGroupColumn, TOvcAbstractRvView* AView);
	__fastcall virtual ~TOvcRvIndexGroup(void);
	void __fastcall Clear(void);
	void __fastcall ExpandAll(bool Expand);
	void __fastcall SelectAll(bool Select);
	void __fastcall ReverseAll(void);
	void __fastcall SortAll(void);
	virtual bool __fastcall ProcessAdds(Ovcdlm::TOvcList* Adds, int Level);
	bool __fastcall ProcessAdds2(Ovcdlm::TOvcFastList* Adds, int Level);
	__property int GroupColumn = {read=FGroupColumn, nodefault};
	__property int OffsetOfGroup[TOvcRvIndexGroup* Group] = {read=GetOffsetOfGroup};
	__property int Count = {read=GetCount, nodefault};
	__property void * Data = {read=GetData};
	__property bool Expanded = {read=FExpanded, write=SetExpanded, nodefault};
	__property TOvcRvIndexGroup* Group = {read=FGroup};
	__property int ItemCount = {read=GetItemCount, nodefault};
	__property int Lines = {read=GetLines, nodefault};
	__property int OffsetOfData[void * DataValue] = {read=GetOffsetOfData};
	__property TOvcRvIndex* Owner = {read=FOwner};
	__property bool IsSelected = {read=GetSelected, write=SetSelected, nodefault};
	__property double Total[int Field] = {read=GetTotal};
	System::Variant __fastcall Min(System::TObject* SimpleExpression);
	System::Variant __fastcall Max(System::TObject* SimpleExpression);
	double __fastcall Sum(System::TObject* SimpleExpression);
	System::Variant __fastcall Avg(System::TObject* SimpleExpression);
};


typedef int __fastcall (__closure *TOvcRvIndexSuperCompare)(void * Data1, void * Data2, int FieldIndex);

class PASCALIMPLEMENTATION TOvcRvIndexSuperGroup : public TOvcRvIndexGroup
{
	typedef TOvcRvIndexGroup inherited;
	
protected:
	TOvcRvIndexSuperCompare SuperCompare;
	int Stop;
	System::StaticArray<int, 32> FX;
	int __fastcall CompareItems(void * Data1, void * Data2);
	void __fastcall BuildNewGroupIndex(Ovcdlm::TOvcList* Adds, int Level);
	
public:
	__fastcall TOvcRvIndexSuperGroup(TOvcRvIndex* AOwner, TOvcAbstractRvView* AView);
	virtual bool __fastcall ProcessAdds(Ovcdlm::TOvcList* Adds, int Level);
public:
	/* TOvcRvIndexGroup.Destroy */ inline __fastcall virtual ~TOvcRvIndexSuperGroup(void) { }
	
};


class PASCALIMPLEMENTATION TOvcRvIndex : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FAbsIndex;
	bool FComputeTotalsHere;
	TOvcAbstractReportView* FOwner;
	TOvcRvIndexSuperGroup* FRoot;
	int FSortColumn;
	int FSortColumn0;
	TOvcAbstractRvView* FView;
	Ovcdlm::TOvcList* Contents;
	Ovcdlm::TOvcFastList* DirtyList;
	void __fastcall SetSortColumn(int Value);
	void __fastcall ProcessDeletes(Ovcdlm::TOvcList* Deletes);
	void __fastcall ProcessUpdates(Ovcdlm::TOvcList* Updates);
	void __fastcall ProcessGroupDeletes(TOvcRvIndexGroup* CurGroup, void * Item);
	
public:
	__property int AbsIndex = {read=FAbsIndex, nodefault};
	__fastcall TOvcRvIndex(TOvcAbstractReportView* AOwner, TOvcAbstractRvView* AView, int ASortColumn);
	__fastcall virtual ~TOvcRvIndex(void);
	void __fastcall ClearData(void);
	void __fastcall MakeVisible(void * Data);
	__property bool ComputeTotalsHere = {read=FComputeTotalsHere, nodefault};
	__property TOvcAbstractReportView* Owner = {read=FOwner};
	__property TOvcRvIndexSuperGroup* Root = {read=FRoot};
	__property int SortColumn = {read=FSortColumn, write=SetSortColumn, nodefault};
	void __fastcall SortPending(void);
	__property TOvcAbstractRvView* View = {read=FView};
	int __fastcall Count(void);
	System::Variant __fastcall Min(System::TObject* SimpleExpression);
	System::Variant __fastcall Max(System::TObject* SimpleExpression);
	double __fastcall Sum(System::TObject* SimpleExpression);
	System::Variant __fastcall Avg(System::TObject* SimpleExpression);
};


class PASCALIMPLEMENTATION TOvcAbstractReportView : public Ovcbase::TOvcCustomControlEx
{
	typedef Ovcbase::TOvcCustomControlEx inherited;
	
protected:
	bool FDelayedBinding;
	System::UnicodeString FActiveIndexerView;
	TOvcRvIndex* FActiveIndex;
	int FBusyCount;
	bool FMultiSelect;
	TOvcRvIndex* FSavedIndex;
	int FSilentUpdate;
	int FInternalSortColumn;
	int FUpdateCount;
	Ovcdlm::TOvcList* FAdds;
	Ovcdlm::TOvcList* FDeletes;
	Ovcdlm::TOvcList* FUpdates;
	System::Classes::TStringList* FIndexes;
	Ovcdlm::TOvcList* FRawData;
	Ovcdlm::TOvcFastList* FSelected;
	TOvcAbstractRvView* __fastcall FindView(const System::UnicodeString ViewName);
	TOvcRvIndex* __fastcall GetIndexItem(int I);
	__property TOvcRvIndex* IndexItems[int I] = {read=GetIndexItem};
	void __fastcall DeleteInactiveIndexes(TOvcRvIndex* Active);
	void __fastcall DeleteViewIndexes(const System::UnicodeString ViewName);
	void __fastcall ClearIndexData(void);
	TOvcRvIndex* __fastcall FindIndex(const System::UnicodeString ViewName, int SortColumn);
	void __fastcall CheckMultiSelect(void);
	void __fastcall CheckUpdate(void);
	void * __fastcall GetData(int Index);
	bool __fastcall GetExpanded(TOvcRvIndexGroup* GroupRef);
	TOvcAbstractRvField* __fastcall GetField(int Index);
	int __fastcall GetGroupColumn(int Index);
	TOvcRvIndexGroup* __fastcall GetGroupRef(int Index);
	bool __fastcall GetIsBusy(void);
	bool __fastcall GetIsGroup(int Index);
	int __fastcall GetLines(void);
	int __fastcall GetOffsetOfData(void * DataValue);
	bool __fastcall GetSelected(int Index);
	TOvcRvIndexGroup* __fastcall GetTotalRef(void);
	void __fastcall SetActiveIndexerView(const System::UnicodeString Value);
	void __fastcall SetExpanded(TOvcRvIndexGroup* GroupRef, bool Value);
	void __fastcall SetFields(TOvcAbstractRvFields* Value);
	void __fastcall SetSelected(int Index, bool Value);
	void __fastcall SetInternalSortColumn(int Value);
	void __fastcall SetViews(TOvcAbstractRvViews* Value);
	TOvcAbstractRvFields* FFields;
	TOvcAbstractRvViews* FViews;
	TOvcRVCompareFieldsEvent FOnCompareFields;
	TOvcRVFilterEvent FOnFilter;
	TOvcRVGetFieldAsFloatEvent FOnGetFieldAsFloat;
	TOvcRVGetFieldAsStringEvent FOnGetFieldAsString;
	TOvcRVExternEvent FExtern;
	TOvcRVGetFieldValueEvent FGetFieldValue;
	TOvcRvGetGroupTotalEvent FOnGetGroupTotal;
	System::Classes::TNotifyEvent FSelectionChanged;
	bool CollapseEvent;
	bool FPresorted;
	virtual void __fastcall DoEnumEvent(void * Data, bool &Stop, void * UserData) = 0 ;
	virtual int __fastcall DoCompareFields(void * Data1, void * Data2, int FieldIndex);
	virtual bool __fastcall DoFilter(TOvcAbstractRvView* View, void * Data);
	virtual double __fastcall DoGetFieldAsFloat(void * Data, int Field);
	virtual System::UnicodeString __fastcall DoGetFieldAsString(void * Data, int FieldIndex);
	virtual System::Variant __fastcall DoGetFieldValue(void * Data, int Field);
	virtual double __fastcall DoGetGroupAsFloat(TOvcRvIndexGroup* Group, double Total);
	virtual void __fastcall DoLinesChanged(int LineDelta, int Offset) = 0 ;
	virtual void __fastcall DoLinesWillChange(void) = 0 ;
	virtual void __fastcall DoSortingChanged(void) = 0 ;
	TOvcRvIndexGroup* __fastcall GetElementAtLine(int Index);
	void * __fastcall GetDataAtLine(int Index);
	int __fastcall GetOffsetOfGroup(TOvcRvIndexGroup* Group);
	void __fastcall PopulateIndex(TOvcRvIndexGroup* IndexGroup);
	void __fastcall UpdateIndex(void);
	__property TOvcRvIndex* ActiveIndex = {read=FActiveIndex};
	__property int UpdateCount = {read=FUpdateCount, nodefault};
	void __fastcall BeginTemporaryIndex(TRvEnumMode EnumMode);
	void __fastcall BeginUpdateIndex(void);
	void __fastcall ClearIndex(void);
	__property bool DelayedBinding = {read=FDelayedBinding, write=FDelayedBinding, nodefault};
	void __fastcall DoEnumerate(void * UserData);
	void __fastcall DoEnumerateSelected(void * UserData);
	void __fastcall DoEnumerateEx(bool Backwards, bool SelectedOnly, void * StartAfter, void * UserData);
	void __fastcall DoSelectionChanged(void);
	void __fastcall EndTemporaryIndex(void);
	void __fastcall EndUpdateIndex(void);
	virtual int __fastcall Find(void * DataRef);
	void __fastcall InternalSelectAll(bool Select);
	__property System::UnicodeString ActiveIndexerView = {read=FActiveIndexerView, write=SetActiveIndexerView};
	void __fastcall AddDataPrim(void * Data);
	void __fastcall ChangeDataPrim(void * Data);
	__property bool IsBusy = {read=GetIsBusy, nodefault};
	__property bool Expanded[TOvcRvIndexGroup* GroupRef] = {read=GetExpanded, write=SetExpanded};
	__property int GroupField[int Index] = {read=GetGroupColumn};
	__property TOvcRvIndexGroup* GroupRef[int Index] = {read=GetGroupRef};
	void __fastcall InternalMakeVisible(void * Data);
	__property int InternalSortColumn = {read=FInternalSortColumn, write=SetInternalSortColumn, nodefault};
	__property bool IsGroup[int Index] = {read=GetIsGroup};
	__property bool IsMultiSelect = {read=FMultiSelect, write=FMultiSelect, nodefault};
	__property bool IsSelected[int Index] = {read=GetSelected, write=SetSelected};
	void __fastcall RemoveDataPrim(void * Data);
	__property TOvcRvIndexGroup* TotalRef = {read=GetTotalRef};
	System::UnicodeString __fastcall UniqueViewFieldName(const System::UnicodeString Name);
	System::UnicodeString __fastcall UniqueViewName(const System::UnicodeString Name);
	
public:
	__fastcall virtual TOvcAbstractReportView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TOvcAbstractReportView(void);
	void __fastcall ClearIndexList(void);
	System::Variant __fastcall DoExtern(const System::Variant &ArgList);
	int __fastcall Count(TOvcRvIndexGroup* GroupRef);
	void __fastcall ExpandAll(bool Expand);
	__property TOvcAbstractRvField* Field[int Index] = {read=GetField};
	__property TOvcAbstractRvFields* Fields = {read=FFields, write=SetFields};
	__property void * ItemData[int Index] = {read=GetData};
	__property int Lines = {read=GetLines, nodefault};
	void __fastcall MakeVisible(void * Data);
	__property int OffsetOfData[void * DataValue] = {read=GetOffsetOfData};
	__property bool Presorted = {read=FPresorted, write=FPresorted, nodefault};
	void __fastcall SelectAll(bool Select);
	double __fastcall Total(TOvcRvIndexGroup* GroupRef, int Field);
	__property TOvcAbstractRvViews* Views = {read=FViews, write=SetViews};
	__property System::Classes::TNotifyEvent OnSelectionChanged = {read=FSelectionChanged, write=FSelectionChanged};
	__property TOvcRVExternEvent OnExtern = {read=FExtern, write=FExtern};
public:
	/* TWinControl.CreateParented */ inline __fastcall TOvcAbstractReportView(HWND ParentWindow) : Ovcbase::TOvcCustomControlEx(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 OvcRvMaxGroupingDepth = System::Int8(0x20);
}	/* namespace Ovcrvidx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OVCRVIDX)
using namespace Ovcrvidx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// OvcrvidxHPP


{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Armin Biernaczyk                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{*********************************************************}
{*                  OVCRVIDX.PAS 4.00                    *}
{*********************************************************}
unit ovcrvidx;
{- Indexer for the report view component}

interface
uses
  Windows, Classes, SysUtils, OvcBase, OvcConst, OvcExcpt, OvcDlm, OvcFiler;

const
  OvcRvMaxGroupingDepth = 32;
type
  TOvcAbstractReportView = class;

  TOvcDRDataType = (
    dtString, dtFloat, dtInteger, dtDateTime, dtBoolean, dtDWord, dtCustom);


  TOvcAbstractRvField = class(TOvcCollectible)
  protected
    FCanSort: Boolean;
    FDataType: TOvcDRDataType;
    function GetOwnerReport : TOvcAbstractReportView;
    function LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean;
    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string);
  public
    constructor Create(AOwner : TComponent); override;
    property DataType : TOvcDRDataType
      read FDataType write FDataType;
    procedure Assign(Source: TPersistent); override;
    property OwnerReport : TOvcAbstractReportView
                   read GetOwnerReport;
    property CanSort : Boolean
                   read FCanSort write FCanSort default True;
    function GetValue(Data: Pointer): Variant; virtual;
    function AsString(Data: Pointer): string; virtual;
  end;



  TOvcAbstractRvFields = class(TOvcCollection)
  protected
    FOwner: TOvcAbstractReportView;
    function GetItem(Index: Integer): TOvcAbstractRvField;
    procedure SetItem(Index: Integer; Value: TOvcAbstractRvField);
  public
    procedure Assign(Source: TPersistent); override;
    function ItemByName(const Name: string): TOvcAbstractRvField;
    property Items[Index: Integer]: TOvcAbstractRvField
                   read GetItem write SetItem;
    property Owner: TOvcAbstractReportView
                   read FOwner;
  end;


  TOvcAbstractRvView = class;


  TOvcAbstractRvViewField = class(TOvcCollectible)
  protected
    FFieldName : string;
    FGroupBy : Boolean;
    FComputeTotals : Boolean;
    FOwnerView : TOvcAbstractRvView;
    procedure SetFieldName(const Value : string);
  protected
    FField : TOvcAbstractRvField;
    FOwnerReport : TOvcAbstractReportView;
    function GetField : TOvcAbstractRvField;
    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string); virtual;
    function LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean; virtual;
  public
    procedure ClearField;
    procedure Assign(Source: TPersistent); override;
    constructor Create(AOwner : TComponent); override;
    property ComputeTotals : Boolean
                   read FComputeTotals write FComputeTotals default False;
    property Field : TOvcAbstractRvField
                   read GetField;
    property FieldName : string
                   read FFieldName write SetFieldName;
    property GroupBy : Boolean
                   read FGroupBy write FGroupBy default False;
    property OwnerReport : TOvcAbstractReportView
                   read FOwnerReport;
    property OwnerView : TOvcAbstractRvView
                   read FOwnerView;
  end;



  TOvcAbstractRvViewFields = class(TOvcCollection)
  protected
    function GetItem(Index: Integer): TOvcAbstractRvViewField;
    procedure SetItem(Index: Integer; Value: TOvcAbstractRvViewField);
    function GetOwnerEx: TOvcAbstractRvView;
  protected
    {FOwnerReport : TOvcAbstractReportView;}
  public
    property Owner: TOvcAbstractRvView
                   read GetOwnerEx;
    property Items[Index: Integer]: TOvcAbstractRvViewField
                   read GetItem write SetItem;
  end;



  TOvcAbstractRvView = class(TOvcCollectible)
  protected
    FFilterIndex: Integer;
    FFilter          : string;
    procedure SetViewFields(Value: TOvcAbstractRvViewFields);
    function GetDisplayText: string; override;
    function GetGroupCount : Integer;
    procedure SaveToStorage(Storage: TOvcAbstractStore;
      const Prefix: string); virtual;
    procedure LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string); virtual;
  protected
    FViewFields : TOvcAbstractRvViewFields;
    function GetViewField(Index : Integer) : TOvcAbstractRvViewField;
  public
    procedure Assign(Source: TPersistent); override;
    destructor Destroy; override;
    property FilterIndex: Integer
                   read FFilterIndex write FFilterIndex default -1;
    property GroupCount : Integer
                   read GetGroupCount;
    property ViewField[Index : Integer] : TOvcAbstractRvViewField
                   read GetViewField;
    property ViewFields: TOvcAbstractRvViewFields
                   read FViewFields write SetViewFields;
  end;



  TOvcAbstractRvViews = class(TOvcCollection)
  protected
    function GetItem(Index: Integer): TOvcAbstractRvView;
    procedure SetItem(Index: Integer; Value: TOvcAbstractRvView);
  protected
    FOwner: TOvcAbstractReportView;
  public
    procedure Assign(Source: TPersistent); override;
    property Owner: TOvcAbstractReportView
                   read FOwner;
    property Items[Index: Integer]: TOvcAbstractRvView
                   read GetItem write SetItem;
  end;


  TOvcRvIndexGroup = class;

  TOvcRVCompareFieldsEvent =
    procedure(Sender : TObject; Data1, Data2 : Pointer; FieldIndex : Integer; var Res : Integer) of object;
    {- Compare event. FieldIndex is the index into the Fields collection of the report view.
                      Res returns -1 for field in Data1 < field in Data2
                                   0 for field in Data1 = field in Data2
                                   1 for field in Data1 > field in Data2}

  TOvcRVGetFieldAsFloatEvent =
    procedure(Sender : TObject; Data : Pointer; FieldIndex : Integer; var Value : double) of object;
    {- Get Field data as float event. Used by the indexer to compute totals for the Field.
       This event is only called if the relevant view ViewField has ComputeTotals = True.}

  TOvcRVGetFieldValueEvent =
    procedure(Sender : TObject; Data : Pointer; FieldIndex : Integer; var Value : Variant) of object;
    {- Get Field data as float event. Used by the indexer to compute totals for the Field.
       This event is only called if the relevant view ViewField has ComputeTotals = True.}

  TOvcRVGetFieldAsStringEvent =
    procedure(Sender : TObject; Data : Pointer; FieldIndex : Integer;
      var Str : string) of object;

  TOvcRvGetGroupTotalEvent =
    procedure(Sender: TObject; Group: TOvcRvIndexGroup; var Result: double) of object;

  TOvcRVEnumEvent =
    procedure(Sender : TObject; Data : Pointer; var Stop : Boolean; UserData : Pointer) of object;
    {- Enumerator method type. Stop defaults to False. If changed to True by the
       event, the enumeration terminates.}

  TOvcRVFilterEvent =
    procedure(Sender: TObject; Data: Pointer; FilterIndex: Integer; var Include: Boolean) of object;

  TOvcRVLinesChangedEvent =
    procedure(Sender : TOvcAbstractReportView; LineDelta : Integer; Offset : Integer) of object;
    {- Notification event generated by the indexer when the number of lines needed to represent
       the view changes - for example when a node is expanded/collapsed, or when data is added
       or removed. Used by the report view to control the virtual list box. LineDelta is
       the number of lines inserted (positive) or deleted (negative). Offset is the offset into
       the index where lines are to be inserted or removed. An offset of -1 indicates that the
       entire view should be invalidated - e.g. because of a switch to a different view.}

  TOvcRVExternEvent =
    procedure(Sender : TOvcAbstractReportView; const ArgList: Variant; var Result: Variant) of object;



  TRvEnumMode = (emExpandAll, emCollapseAll);

  TOvcRvIndex = class;

  TOvcRvIndexGroup = class
  protected
    FExpanded: Boolean;
    FGroup: TOvcRvIndexGroup;
    FOwner: TOvcRvIndex;
    FAbsGroupColumn : Integer;
    FAbsSortColumn: Integer;
    FGroupColumn: Integer;
    FView : TOvcAbstractRvView;
    FElements : TOvcFastList;
    OwnerFieldCount : Integer;
    FContainsGroups: Boolean;
    Dirty : Boolean; { group needs resorting}
    {FSelected : Boolean;}
    FLines: Integer;
    function FindData(Data: Pointer): Integer;
    procedure ClearElementList;
    function GetElement(I: Integer): TOvcRvIndexGroup;
    function CompareGroupTotals(Item1, Item2 : TOvcRvIndexGroup): Integer;
    function CompareValueTotals(Item1, Item2 : TOvcRvIndexGroup): Integer;
    function CompareItemValues(Item1, Item2 : TOvcRvIndexGroup): Integer;
    function CompareGroupValues(Item1, Item2 : TOvcRvIndexGroup): Integer;
    function GetCount: Integer;
    function GetData: Pointer;
    function GetElementAtLine(var Line: Integer): TOvcRvIndexGroup;
    function GetDataAtLine(var Line: Integer): Pointer;
    function GetItemCount: Integer;
    function GetLines: Integer;
    function GetOffsetOfData(DataValue: Pointer): Integer;
    function GetOffsetOfGroup(Group: TOvcRvIndexGroup): Integer;
    function GetSelected: Boolean;
    function GetTotal(Field: Integer): Double;
    procedure ResetLines;
    procedure SetExpanded(Value: Boolean);
    procedure SetSelected(const Value: Boolean);
    procedure Sort;
  public
    property Element[I: Integer]: TOvcRvIndexGroup read GetElement;
    property ContainsGroups: Boolean read FContainsGroups;
    constructor Create(AOwner: TOvcRvIndex; AGroup: TOvcRvIndexGroup; AGroupColumn: Integer; AView: TOvcAbstractRvView);
    destructor Destroy; override;
    procedure Clear;
    procedure ExpandAll(Expand: Boolean);
    procedure SelectAll(Select: Boolean);
    procedure ReverseAll;
    procedure SortAll;
    function ProcessAdds(Adds : TOvcList; Level : Integer): Boolean; virtual;
    function ProcessAdds2(Adds : TOvcFastList; Level : Integer): Boolean;
    property GroupColumn: Integer read FGroupColumn;
    property OffsetOfGroup[Group: TOvcRvIndexGroup]: Integer read GetOffsetOfGroup;
    property Count: Integer read GetCount;
    property Data: Pointer read GetData;
    property Expanded: Boolean read FExpanded write SetExpanded;
    property Group: TOvcRvIndexGroup read FGroup;
    property ItemCount: Integer read GetItemCount;
    property Lines: Integer read GetLines;
    property OffsetOfData[DataValue: Pointer]: Integer read GetOffsetOfData;
    property Owner: TOvcRvIndex read FOwner;
    property IsSelected: Boolean read GetSelected write SetSelected;
    property Total[Field: Integer]: Double read GetTotal;
    function Min(SimpleExpression : TObject): Variant;
    function Max(SimpleExpression : TObject): Variant;
    function Sum(SimpleExpression : TObject): double;
    function Avg(SimpleExpression : TObject): Variant;
  end;

  { new}
  TOvcRvIndexSuperCompare = function(Data1, Data2: Pointer; FieldIndex: Integer) : Integer of object;
  TOvcRvIndexSuperGroup = class(TOvcRvIndexGroup)
  protected
    SuperCompare: TOvcRvIndexSuperCompare;
    Stop: Integer;
    FX: array[0..OvcRvMaxGroupingDepth-1] of Integer;
    function CompareItems(Data1, Data2: Pointer): Integer;
    procedure BuildNewGroupIndex(Adds: TOvcList; Level : Integer);
  public
    constructor Create(AOwner: TOvcRvIndex; AView: TOvcAbstractRvView);
    function ProcessAdds(Adds : TOvcList; Level : Integer): Boolean; override;
  end;

  TOvcRvIndex = class
  protected
    FAbsIndex : Integer;
    FComputeTotalsHere : Boolean;
    FOwner: TOvcAbstractReportView;
    FRoot: TOvcRvIndexSuperGroup;
    FSortColumn: Integer;
    FSortColumn0 : Integer;
    FView: TOvcAbstractRvView;
    Contents : TOvcList;
    DirtyList : TOvcFastList; {list of index groups that require resorting}
    procedure SetSortColumn(Value : Integer);
    procedure ProcessDeletes(Deletes : TOvcList);
    procedure ProcessUpdates(Updates : TOvcList);
    procedure ProcessGroupDeletes(CurGroup : TOvcRvIndexGroup; Item : Pointer);
  public
    property AbsIndex : Integer read FAbsIndex;
    constructor Create(AOwner: TOvcAbstractReportView; AView: TOvcAbstractRvView; ASortColumn: Integer);
    destructor Destroy; override;
    procedure ClearData;
    procedure MakeVisible(Data: Pointer);
    property ComputeTotalsHere : Boolean read FComputeTotalsHere;
    property Owner: TOvcAbstractReportView read FOwner;
    property Root: TOvcRvIndexSuperGroup read FRoot;
    property SortColumn: Integer read FSortColumn write SetSortColumn;
    {property SortColumn0 : Integer read FSortColumn0;}
    procedure SortPending;
    property View: TOvcAbstractRvView read FView;
    function Count: Integer;
    function Min(SimpleExpression : TObject): Variant;
    function Max(SimpleExpression : TObject): Variant;
    function Sum(SimpleExpression : TObject): double;
    function Avg(SimpleExpression : TObject): Variant;
  end;



  TOvcAbstractReportView = class(TOvcCustomControlEx)

  protected
    FDelayedBinding : Boolean;
    FActiveIndexerView: string;
    FActiveIndex: TOvcRvIndex;
    FBusyCount: Integer;
    FMultiSelect: Boolean;
    FSavedIndex: TOvcRvIndex;
    FSilentUpdate: Integer;
    FInternalSortColumn: Integer;
    FUpdateCount: Integer;
    FAdds : TOvcList;
    FDeletes : TOvcList;
    FUpdates : TOvcList;
    FIndexes : TStringList;
    FRawData: TOvcList;
    FSelected : TOvcFastList;
    function FindView(const ViewName: string): TOvcAbstractRvView;
    function GetIndexItem(I: Integer): TOvcRvIndex;
    property IndexItems[I: Integer]: TOvcRvIndex read GetIndexItem;
    procedure DeleteInactiveIndexes(Active : TOvcRvIndex);
    procedure DeleteViewIndexes(const ViewName : string);
    procedure ClearIndexData;
    function FindIndex(const ViewName: string; SortColumn: Integer): TOvcRvIndex;
    procedure CheckMultiSelect;
    procedure CheckUpdate;
    function GetData(Index: Integer): Pointer;
    function GetExpanded(GroupRef: TOvcRvIndexGroup): Boolean;
    function GetField(Index : Integer) : TOvcAbstractRvField;
    function GetGroupColumn(Index: Integer): Integer;
    function GetGroupRef(Index: Integer): TOvcRvIndexGroup;
    function GetIsBusy: Boolean;
    function GetIsGroup(Index: Integer): Boolean;
    function GetLines: Integer;
    function GetOffsetOfData(DataValue: Pointer): Integer;
    function GetSelected(Index: Integer): Boolean;
    function GetTotalRef: TOvcRvIndexGroup;
    procedure SetActiveIndexerView(const Value: string);
    procedure SetExpanded(GroupRef: TOvcRvIndexGroup; Value: Boolean);
    procedure SetFields(Value: TOvcAbstractRvFields);
    procedure SetSelected(Index: Integer; Value: Boolean);
    procedure SetInternalSortColumn(Value: Integer);
    procedure SetViews(Value: TOvcAbstractRvViews);
  protected
    FFields: TOvcAbstractRvFields;
    FViews : TOvcAbstractRvViews;
    FOnCompareFields: TOvcRVCompareFieldsEvent;
    FOnFilter: TOvcRVFilterEvent;
    FOnGetFieldAsFloat: TOvcRVGetFieldAsFloatEvent;
    FOnGetFieldAsString      : TOvcRVGetFieldAsStringEvent;
    FExtern: TOvcRVExternEvent;
    FGetFieldValue: TOvcRVGetFieldValueEvent;
    FOnGetGroupTotal : TOvcRvGetGroupTotalEvent;

    FSelectionChanged: TNotifyEvent;
    CollapseEvent : Boolean;
    FPresorted : Boolean;
    procedure DoEnumEvent(Data : Pointer; var Stop : boolean; UserData : Pointer); virtual; abstract;
    function DoCompareFields(Data1, Data2: Pointer; FieldIndex: Integer) : Integer; virtual;
    function DoFilter(View: TOvcAbstractRvView; Data: Pointer): Boolean; virtual;
    function DoGetFieldAsFloat(Data: Pointer; Field: Integer) : Double; virtual;
    function DoGetFieldAsString(Data : Pointer; FieldIndex : Integer) : string; virtual;
    function DoGetFieldValue(Data: Pointer; Field: Integer) : Variant; virtual;
    function DoGetGroupAsFloat(Group: TOvcRvIndexGroup; Total: double) : Double; virtual;
    procedure DoLinesChanged(LineDelta: Integer; Offset: Integer); virtual; abstract;
    procedure DoLinesWillChange; virtual; abstract;
    procedure DoSortingChanged; virtual; abstract;
    function GetElementAtLine(Index: Integer): TOvcRvIndexGroup;
    function GetDataAtLine(Index: Integer): Pointer;
    function GetOffsetOfGroup(Group: TOvcRvIndexGroup): Integer;
    procedure PopulateIndex(IndexGroup: TOvcRvIndexGroup);
    procedure UpdateIndex;
    property ActiveIndex: TOvcRvIndex read FActiveIndex;
    property UpdateCount: Integer read FUpdateCount;
    procedure BeginTemporaryIndex(EnumMode: TRvEnumMode);
    procedure BeginUpdateIndex;
    procedure ClearIndex;
      {- Clear all item data from all views.}
    property DelayedBinding : Boolean
                   read FDelayedBinding write FDelayedBinding;
    procedure DoEnumerate(UserData: Pointer);
    procedure DoEnumerateSelected(UserData: Pointer);
    procedure DoEnumerateEx(Backwards, SelectedOnly: Boolean; StartAfter: Pointer;
      UserData: Pointer);
    procedure DoSelectionChanged;
    procedure EndTemporaryIndex;
    procedure EndUpdateIndex;
    function Find(DataRef: Pointer): Integer; virtual;
    procedure InternalSelectAll(Select: Boolean);
    property ActiveIndexerView: string read FActiveIndexerView write SetActiveIndexerView;
    procedure AddDataPrim(Data : Pointer);
      {- Add one or more records to the index}
    procedure ChangeDataPrim(Data : Pointer);
      {- Change one or more records in the index}
    property IsBusy: Boolean read GetIsBusy;
    property Expanded[GroupRef: TOvcRvIndexGroup]: Boolean read GetExpanded write SetExpanded;
    property GroupField[Index: Integer]: Integer read GetGroupColumn;
    property GroupRef[Index: Integer]: TOvcRvIndexGroup read GetGroupRef;
    procedure InternalMakeVisible(Data: Pointer);
    property InternalSortColumn: integer read FInternalSortColumn write SetInternalSortColumn;
    property IsGroup[Index: Integer]: Boolean read GetIsGroup;
    property IsMultiSelect: Boolean read FMultiSelect write FMultiSelect;
    property IsSelected[Index: Integer]: Boolean read GetSelected write SetSelected;
    {property Lines: Integer read GetLines;} {moved to public}
    procedure RemoveDataPrim(Data : Pointer);
      {- Remove one or more records to the index}
    property TotalRef: TOvcRvIndexGroup read GetTotalRef;
    function UniqueViewFieldName(const Name: string): string;
    function UniqueViewName(const Name: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearIndexList;
    function DoExtern(const ArgList: Variant): Variant;

    function Count(GroupRef: TOvcRvIndexGroup): Integer;
      {- Return number of items in group identified by GroupRef}
    procedure ExpandAll(Expand: Boolean);
      {- Expand/collapse all groups. Has no effect in views with no
         grouped fields.}
    property Field[Index : Integer] : TOvcAbstractRvField
                   read GetField;
    property Fields: TOvcAbstractRvFields
                   read FFields write SetFields;

    property ItemData[Index: Integer]: Pointer read GetData;
      {- Data of the current view by offset}
    property Lines: Integer read GetLines; {moved from protected}
      {- returns the number of currently visible lines in the view}
    procedure MakeVisible(Data: Pointer);
    property OffsetOfData[DataValue: Pointer]: Integer read GetOffsetOfData;
      {- Returns the offset of a given item in the current view. -1 if
         the item is not currently visible.}

    property Presorted : Boolean read FPresorted write FPresorted;
    procedure SelectAll(Select: Boolean);
    function Total(GroupRef: TOvcRvIndexGroup; Field: Integer): Double;
      {- Return the sum of items for the group and field defined
         by GroupRef and Field.}
    property Views : TOvcAbstractRvViews
                   read FViews write SetViews;
    property OnSelectionChanged: TNotifyEvent read FSelectionChanged write FSelectionChanged;
    property OnExtern: TOvcRVExternEvent read FExtern write FExtern;
  end;


implementation
uses
  OvcRvExpDef;

constructor TOvcAbstractRvField.Create(AOwner : TComponent);
{create a field definition}
begin
  inherited Create(AOwner);
  FCanSort := True;
end;

function TOvcAbstractRvField.GetOwnerReport : TOvcAbstractReportView;
{Return owner as TAbstracTOrAbstractReportView}
begin
  Result := TOvcAbstractRvFields(Collection).Owner;
end;

procedure TOvcAbstractRvField.Assign(Source: TPersistent);
{Assign field}
var
  Field: TOvcAbstractRvField;
begin
  if Source is TOvcAbstractRvField then begin
    Field := TOvcAbstractRvField(Source);
    CanSort := Field.CanSort;
    Name := Field.Name;
  end else
    inherited Assign(Source);
end;

function TOvcAbstractRvField.LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean;
begin
  CanSort := Storage.ReadBoolean(Prefix, 'CanSort', True);
  Result := True;
end;

procedure TOvcAbstractRvField.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  if not CanSort then
    Storage.WriteBoolean(Prefix, 'CanSort', False);
end;

function TOvcAbstractRvField.GetValue(Data: Pointer): Variant;
begin
  Result := OwnerReport.DoGetFieldValue(Data, Index);
end;

function TOvcAbstractRvField.AsString(Data: Pointer): string;
begin
  Result := OwnerReport.DoGetFieldAsString(Data, Index);
end;

procedure TOvcAbstractRvFields.Assign(Source: TPersistent);
var
  NewField : TOvcAbstractRvField;
  i : Integer;
begin
  if Source is TOvcAbstractRvFields then begin
    Clear;
    for i := 0 to pred(TOvcAbstractRvFields(Source).Count) do begin
      NewField := TOvcAbstractRvField(Add);
      NewField.Assign(TOvcAbstractRvFields(Source).Items[i]);
    end;
  end else
    inherited Assign(Source);
end;

function TOvcAbstractRvFields.GetItem(Index: Integer): TOvcAbstractRvField;
{Return collection-item cast to TOrAbstractRvColumn}
begin
  Result := TOvcAbstractRvField(inherited GetItem(Index));
end;

function TOvcAbstractRvFields.ItemByName(
  const Name: string): TOvcAbstractRvField;
var
  i : Integer;
begin
  for i := 0 to Count - 1 do
    if AnsiUpperCase(Item[i].Name) = AnsiUpperCase(Name) then begin
      Result := TOvcAbstractRvField(Item[i]);
      exit;
    end;
  Result := nil;
end;

procedure TOvcAbstractRvFields.SetItem(Index: Integer; Value: TOvcAbstractRvField);
{Set collection item of type TOrAbstractRvColumn}
begin
  inherited SetItem(Index, Value);
end;

procedure TOvcAbstractRvViewField.Assign(Source: TPersistent);
begin
  if Source is TOvcAbstractRvViewField then begin
    Name := OwnerReport.UniqueViewFieldName(TOvcAbstractRvViewField(Source).Name);
    ComputeTotals := TOvcAbstractRvViewField(Source).ComputeTotals;
    FieldName := TOvcAbstractRvViewField(Source).FieldName;
    GroupBy := TOvcAbstractRvViewField(Source).GroupBy;
  end else
    inherited Assign(Source);
end;

procedure TOvcAbstractRvViewField.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
begin
  if ComputeTotals then
    Storage.WriteBoolean(Prefix, 'CompTotals', ComputeTotals);
  Storage.WriteString(Prefix, 'FieldName', FieldName);
  if GroupBy then
    Storage.WriteBoolean(Prefix, 'GroupBy', GroupBy);
end;

function TOvcAbstractRvViewField.LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string): Boolean;
var
  S: string;
begin
  { optimized
  ComputeTotals := Storage.ReadBoolean(Prefix, 'CompTotals', False);
  GroupBy := Storage.ReadBoolean(Prefix, 'GroupBy', False);
  }
  S := Storage.ReadString(Prefix, 'FieldName', '');
  Result := S <> '';
  if Result then begin
    FieldName := S;
    ComputeTotals := Storage.ReadBoolean(Prefix, 'CompTotals', False);
    GroupBy := Storage.ReadBoolean(Prefix, 'GroupBy', False);
  end;
end;

procedure TOvcAbstractRvViewField.ClearField;
begin
  FField := nil;
end;

constructor TOvcAbstractRvViewField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FOwnerReport := TOvcAbstractReportView(Owner.Owner);
  FOwnerView := TOvcAbstractRvView(Owner);
end;

procedure TOvcAbstractRvViewField.SetFieldName(const Value : string);
var
  i : Integer;
begin
  if FOwnerReport.DelayedBinding then begin
    FFieldName := Value;
    exit;
  end;
  for i := 0 to pred(FOwnerReport.Fields.Count) do
    with FOwnerReport.Field[i] do
      if Name = Value then begin
        FFieldName := Value;
        FField := FOwnerReport.Field[i];
        exit;
      end;
  raise EReportViewError.CreateFmt(SCViewFieldNotFound,[Value],0);
end;

function TOvcAbstractRvViewField.GetField : TOvcAbstractRvField;
begin
  if FField = nil then
    raise EReportViewError.CreateFmt(SCCantResolveField,[FFieldName],0);
  Result := FField;
end;

procedure TOvcAbstractReportView.SetFields(Value: TOvcAbstractRvFields);
{Set method for the ReportColumns collection}
begin
  FFields.Assign(Value);
end;

function TOvcAbstractReportView.GetField(Index : Integer) : TOvcAbstractRvField;
{Get field by Index}
begin
  Result := TOvcAbstractRvField(Fields[Index]);
end;

procedure TOvcAbstractRvViews.Assign(Source: TPersistent);
var
  NewView : TOvcAbstractRvView;
  i : Integer;
begin
  if Source is TOvcAbstractRvViews then begin
    Clear;
    for i := 0 to pred(TOvcAbstractRvViews(Source).Count) do begin
      NewView := TOvcAbstractRvView(Add);
      NewView.Assign(TOvcAbstractRvViews(Source).Items[i]);
    end;
  end else
    inherited Assign(Source);
end;

function TOvcAbstractRvViews.GetItem(Index: Integer): TOvcAbstractRvView;
{Return collection-item cast to TOrRvView}
begin
  Result := TOvcAbstractRvView(inherited GetItem(Index));
end;

procedure TOvcAbstractRvViews.SetItem(Index: Integer; Value: TOvcAbstractRvView);
{Set collection item of type TOrRvView}
begin
  inherited SetItem(Index, Value);
end;

procedure TOvcAbstractRvView.Assign(Source: TPersistent);
var
  NewViewField : TOvcAbstractRvViewField;
  i : Integer;
begin
  if Source is TOvcAbstractRvView then begin
    ViewFields.Clear;
    Name := TOvcAbstractReportView(Owner).UniqueViewName(
      TOvcAbstractRvView(Source).Name);
    FilterIndex := TOvcAbstractRvView(Source).FilterIndex;
    FFilter := TOvcAbstractRvView(Source).FFilter;
    for i := 0 to pred(TOvcAbstractRvView(Source).ViewFields.Count) do begin
      NewViewField := TOvcAbstractRvViewField(ViewFields.Add);
      NewViewField.Assign(TOvcAbstractRvView(Source).ViewFields[i]);
    end;
  end else
    inherited Assign(Source);
end;

destructor TOvcAbstractRvView.Destroy;
begin
  if Owner <> nil then
    TOvcAbstractReportView(Owner).DeleteViewIndexes(Name);
  FViewFields.Free;
  inherited Destroy;
end;

function TOvcAbstractRvView.GetDisplayText: string;
{Return display string for property editor}
begin
  Result := Name;
  if Result = '' then
    Result := inherited GetDisplayText;
end;

function TOvcAbstractRvViewFields.GetItem(Index: Integer): TOvcAbstractRvViewField;
begin
  Result := TOvcAbstractRvViewField(inherited GetItem(Index));
end;

function TOvcAbstractRvViewFields.GetOwnerEx: TOvcAbstractRvView;
begin
  Result := TOvcAbstractRvView(inherited Owner);
end;

procedure TOvcAbstractRvViewFields.SetItem(Index: Integer; Value: TOvcAbstractRvViewField);
begin
  inherited SetItem(Index, Value);
end;

function TOvcAbstractRvView.GetGroupCount : Integer;
begin
  Result := 0;
  while (Result < ViewFields.Count) and (ViewField[Result].GroupBy) do
    inc(Result);
end;

function TOvcAbstractRvView.GetViewField(Index : Integer) : TOvcAbstractRvViewField;
begin
  Result := TOvcAbstractRvViewField(FViewFields[Index]);
end;

procedure TOvcAbstractRvView.SaveToStorage(Storage: TOvcAbstractStore;
  const Prefix: string);
var
  i : Integer;
begin
  if FilterIndex <> -1 then
    Storage.WriteInteger(Prefix, 'FilterIndex', FilterIndex);
  if ViewFields.Count <> 0 then
    Storage.WriteInteger(Prefix, 'ViewFields', ViewFields.Count);
  for i := 0 to pred(ViewFields.Count) do begin
    Storage.EraseSection(Prefix + '_VF_' + IntToStr(i));
    ViewField[i].SaveToStorage(Storage, Prefix + '_VF_' + IntToStr(i));
  end;
  if Tag <> 0 then
    Storage.WriteInteger(Prefix, 'Tag', Tag);
end;

procedure TOvcAbstractRvView.LoadFromStorage(Storage: TOvcAbstractStore;
      const Prefix: string);
var
  NewField : TOvcAbstractRvViewField;
  FieldCount, i : Integer;
begin
  FilterIndex := Storage.ReadInteger(Prefix, 'FilterIndex', -1);
  FieldCount := Storage.ReadInteger(Prefix, 'ViewFields', 0);
  for i := 0 to pred(FieldCount) do begin
    NewField := TOvcAbstractRvViewField(ViewFields.Add);
    if not NewField.LoadFromStorage(Storage, Prefix + '_VF_' + IntToStr(i)) then
      NewField.Free;
  end;
  Tag := Storage.ReadInteger(Prefix, 'Tag', 0);
end;

procedure TOvcAbstractRvView.SetViewFields(Value: TOvcAbstractRvViewFields);
{Set method for the ViewFields collection}
begin
  FViewFields.Assign(Value);
end;

procedure TOvcAbstractReportView.ClearIndexList;
var
  I : Integer;
begin
  for I := 0 to FIndexes.Count - 1 do
    TObject(FIndexes.Objects[I]).Free;
  FIndexes.Clear;
  FActiveIndex := nil;
end;

constructor TOvcAbstractReportView.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FInternalSortColumn := 1;
  FSilentUpdate := 0;
  FAdds := TOvcList.Create;
  FDeletes := TOvcList.Create;
  FUpdates := TOvcList.Create;
  FIndexes := TStringList.Create;
  FIndexes.Duplicates := dupError;
  FIndexes.Sorted := True;
  FRawData := TOvcList.Create;
  FSelected := TOvcFastList.Create;
end;

destructor TOvcAbstractReportView.Destroy;
begin
  ClearIndexList;
  FAdds.Free;
  FDeletes.Free;
  FUpdates.Free;
  FIndexes.Free;
  FSelected.Free;
  FRawData.Free;
  inherited Destroy
end;

procedure TOvcAbstractReportView.AddDataPrim(Data : Pointer);
begin
  FRawData.Add(Data);
  FAdds.Add(Data);
  if FUpdateCount <= 0 then
    UpdateIndex
end;

procedure TOvcAbstractReportView.BeginTemporaryIndex(EnumMode: TRvEnumMode);
begin
  if Assigned(FSavedIndex) then
    raise EReportViewError.Create(SCAlreadyInTempMode,0);
  FSavedIndex := FActiveIndex;
  Inc(FBusyCount);
  try
    FActiveIndex := TOvcRvIndex.Create(Self, FActiveIndex.View, FActiveIndex.SortColumn);
    PopulateIndex(FActiveIndex.Root);
    FActiveIndex.SortPending;
    case EnumMode of
    emExpandAll:
      FActiveIndex.Root.ExpandAll(True);
    emCollapseAll:
      begin
        FActiveIndex.Root.ExpandAll(False);
        FActiveIndex.Root.Expanded := True
      end
    end;
  finally
    Dec(FBusyCount)
  end
end;

procedure TOvcAbstractReportView.BeginUpdateIndex;
begin
  Inc(FUpdateCount);
end;

procedure TOvcAbstractReportView.ChangeDataPrim(Data : Pointer);
begin
  if FAdds.ItemExists(Data) then
    exit; {Item is pending for addition but hasn't been added yet}
  if FDeletes.ItemExists(Data) then
    exit; {Item is scheduled for delete. No further processing needed}
  if not FRawData.ItemExists(Data) then
    raise EItemNotFound.CreateFmt(SCItemNotFound, [Data],0);
  FUpdates.AddIfUnique(Data);
  if FUpdateCount <= 0 then
    UpdateIndex
end;

procedure TOvcAbstractReportView.CheckMultiSelect;
begin
  if not IsMultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
end;

procedure TOvcAbstractReportView.CheckUpdate;
begin
  if FUpdateCount > 0 then
    raise EUpdatePending.Create(SCUpdatePending,0);
end;

procedure TOvcAbstractReportView.ClearIndex;
begin
  ClearIndexData;
  FRawData.Clear;
  FSelected.Clear;
  if FUpdateCount = 0 then
    DoLinesChanged(0, -1)
end;

function TOvcAbstractReportView.Count(GroupRef: TOvcRvIndexGroup): Integer;
begin
  Result := TOvcRvIndexGroup(GroupRef).ItemCount
end;

function TOvcAbstractReportView.DoCompareFields(Data1, Data2: Pointer; FieldIndex: Integer) : Integer;
begin
  FOnCompareFields(Self, Data1, Data2, FieldIndex, Result);
end;

function TOvcAbstractReportView.DoFilter(View: TOvcAbstractRvView; Data: Pointer): Boolean;
begin
  if (Owner <> nil) and (csDesigning in Owner.ComponentState) then
    Result := True
  else begin
    if (View.FFilter = '') and (View.FilterIndex >= 0) and not Assigned(FOnFilter) then
      raise EOnFilterNotAsgnd.Create(SCOnFilterNotAssigned,0);
    Result := True;
    if Assigned(FOnFilter) then
      FOnFilter(Self, Data, View.FilterIndex, Result);
  end;
end;

function TOvcAbstractReportView.DoGetFieldAsFloat(Data: Pointer; Field: Integer) : Double;
begin
  if not Assigned(FOnGetFieldAsFloat) then
    raise EGetAsFloatNotAsg.Create(SCGetAsFloatNotAssigned,0);
  FOnGetFieldAsFloat(Self, Data, Field, Result)
end;

function TOvcAbstractReportView.DoGetFieldAsString(Data : Pointer; FieldIndex : Integer) : string;
begin
  if assigned(FOnGetFieldAsString) then
    FOnGetFieldAsString(Self,Data,FieldIndex,Result)
  else
    Result := format('[%d]',[FieldIndex]);
end;

function TOvcAbstractReportView.DoGetGroupAsFloat(Group: TOvcRvIndexGroup;
  Total: double): Double;
begin
  Result := Total;
  if Assigned(FOnGetGroupTotal) then
    FOnGetGroupTotal(Self, Group, Result)
end;

function TOvcAbstractReportView.DoGetFieldValue(Data: Pointer;
  Field: Integer): Variant;
begin
  if not Assigned(FGetFieldValue) then
    raise Exception.Create('OnGetFieldValue not assigned');
  FGetFieldValue(Self, Data, Field, Result)
end;

procedure TOvcAbstractReportView.EndTemporaryIndex;
begin
  if not Assigned(FSavedIndex) then
    raise EReportViewError.Create(SCNotInTempMode,0);
  Inc(FBusyCount);
  try
    FActiveIndex.Free;
    FActiveIndex := FSavedIndex;
    FInternalSortColumn := FActiveIndex.SortColumn;
    FSavedIndex := nil;
  finally
    Dec(FBusyCount)
  end
end;

procedure TOvcAbstractReportView.EndUpdateIndex;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
    UpdateIndex
end;

procedure TOvcAbstractReportView.DoEnumerate(UserData: Pointer);
var
  Stop: Boolean;

  procedure EnumGroup(Group: TOvcRvIndexGroup);
  var
    I: Integer;
  begin
    I := Group.FElements.Count - 1;
    while (I >= 0) and not Stop do begin
      if Group.ContainsGroups then
        EnumGroup(TOvcRvIndexGroup(Group.Element[I]))
      else
        DoEnumEvent(Group.Element[I], Stop, UserData);
      dec(I)
    end
  end;

begin
  if not Assigned(FActiveIndex) then
    Exit;
  Stop := False;
  EnumGroup(FActiveIndex.Root)
end;

procedure TOvcAbstractReportView.DoEnumerateSelected(UserData: Pointer);
var
  Stop: Boolean;

  procedure EnumGroup(Group: TOvcRvIndexGroup; Sel : Boolean);
  var
    I: Integer;
  begin
    Sel := Sel or Group.IsSelected;
    I := Group.Count - 1;
    while (I >= 0) and not Stop do begin
      if Group.ContainsGroups then
        EnumGroup(TOvcRvIndexGroup(Group.Element[I]), Sel)
      else
        if Sel then
          DoEnumEvent(Group.Element[I], Stop, UserData)
        else
          if Group.FOwner.Owner.FSelected.IndexOf(Group.Element[I]) <> -1 then
            DoEnumEvent(Group.Element[I], Stop, UserData);
      dec(I)
    end
  end;

begin
  if not Assigned(FActiveIndex) then
    Exit;
  Stop := False;
  EnumGroup(FActiveIndex.Root, False)
end;

procedure TOvcAbstractReportView.DoEnumerateEx(Backwards, SelectedOnly: Boolean;
  StartAfter: Pointer; UserData: Pointer);
var
  Stop, Active: Boolean;

  procedure EnumGroupB(Group: TOvcRvIndexGroup; Sel : Boolean);
  var
    I: Integer;
  begin
    Sel := Sel or Group.IsSelected;
    I := Group.Count - 1;
    while (I >= 0) and not Stop do begin
      if Group.ContainsGroups then
        EnumGroupB(TOvcRvIndexGroup(Group.Element[I]), Sel)
      else
        if Sel then
          if Active then
            DoEnumEvent(Group.Element[I], Stop, UserData)
          else
            Active := Group.Element[I] = StartAfter
        else
          if Group.FOwner.Owner.FSelected.IndexOf(Group.Element[I]) <> -1 then
            if Active then
              DoEnumEvent(Group.Element[I], Stop, UserData)
            else
              Active := Group.Element[I] = StartAfter;
      dec(I)
    end
  end;

  procedure EnumGroupF(Group: TOvcRvIndexGroup; Sel : Boolean);
  var
    I, J: Integer;
  begin
    Sel := Sel or Group.IsSelected;
    I := 0;
    J := Group.Count - 1;
    while (I <= J) and not Stop do begin
      if Group.ContainsGroups then
        EnumGroupF(TOvcRvIndexGroup(Group.Element[I]), Sel)
      else
        if Sel then
          if Active then
            DoEnumEvent(Group.Element[I], Stop, UserData)
          else
            Active := Group.Element[I] = StartAfter
        else
          if Group.FOwner.Owner.FSelected.IndexOf(Group.Element[I]) <> -1 then
            if Active then
              DoEnumEvent(Group.Element[I], Stop, UserData)
            else
              Active := Group.Element[I] = StartAfter;
      inc(I)
    end
  end;

begin
  if not Assigned(FActiveIndex) then
    Exit;
  Stop := False;
  Active := StartAfter = nil;
  if Backwards then
    EnumGroupB(FActiveIndex.Root, not SelectedOnly)
  else
    EnumGroupF(FActiveIndex.Root, not SelectedOnly);
end;

procedure TOvcAbstractReportView.ExpandAll(Expand: Boolean);
begin
  if not Assigned(FActiveIndex) then
    Exit;
  CheckUpdate;
  DoLinesWillChange;
  if not Expand then
    CollapseEvent := True;
  FActiveIndex.Root.ExpandAll(Expand);
  FActiveIndex.Root.Expanded := True;
  DoLinesChanged(-1, -1);
end;

function TOvcAbstractReportView.Find(DataRef: Pointer): Integer;
begin
  { First determine whether or not the item is already in the index. If so, just return its offset. }
  Result := GetOffsetOfData(DataRef);
  { If not, we have more work to do. }
  if Result < 0 then begin
    { Add the new item to the index. }
    Inc(FSilentUpdate);
    try
      AddDataPrim(DataRef);
      try
        { Find it. }
        Result := GetOffsetOfData(DataRef);
      finally
        { And remove it. }
        RemoveDataPrim(DataRef);
      end;
    finally
      Dec(FSilentUpdate)
    end
  end
end;

function TOvcAbstractReportView.GetData(Index: Integer): Pointer;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    Result := nil
  else
    Result := GetDataAtLine(Index);
end;

function TOvcAbstractReportView.GetElementAtLine(Index: Integer): TOvcRvIndexGroup;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    raise ENoActiveView.Create(SCNoActiveView,0);
  { Return the Element corresponding to the specified line index.
    We need to first add 1 to the index because the group header
    line for the root group is not included in the line count. }
  inc(Index); {Index is a VAR argument here}
  Result := FActiveIndex.Root.GetElementAtLine(Index);
end;

function TOvcAbstractReportView.GetDataAtLine(Index: Integer): Pointer;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    raise ENoActiveView.Create(SCNoActiveView,0);
  { Return the Element corresponding to the specified line index.
    We need to first add 1 to the index because the group header
    line for the root group is not included in the line count. }
  inc(Index); {Index is a VAR argument here}
  Result := FActiveIndex.Root.GetDataAtLine(Index);
end;

function TOvcAbstractReportView.GetExpanded(GroupRef: TOvcRvIndexGroup): Boolean;
begin
  CheckUpdate;
  Result := TOvcRvIndexGroup(GroupRef).Expanded;
end;

function TOvcAbstractReportView.GetGroupColumn(Index: Integer): Integer;
begin
  CheckUpdate;
  Result := TOvcRvIndexGroup(GetGroupRef(Index)).GroupColumn - 1;
end;

function TOvcAbstractReportView.GetGroupRef(Index: Integer): TOvcRvIndexGroup;
begin
  CheckUpdate;
  TOvcRvIndexGroup(Result) := GetElementAtLine(Index);
  if not (TObject(Result) is TOvcRvIndexGroup) then
    raise EItemIsNotGroup.CreateFmt(SCItemIsNotGroup, [Index],0);
end;

function TOvcAbstractReportView.GetIsBusy: Boolean;
begin
  Result := FBusyCount > 0
end;

function TOvcAbstractReportView.GetIsGroup(Index: Integer): Boolean;
var
  El : TObject;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    Result := False
  else begin
    El := GetElementAtLine(Index);
    Result := (El <> nil) and (El is TOvcRvIndexGroup);
  end;
end;

function TOvcAbstractReportView.GetLines: Integer;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    Result := 0
  else
    { Subtract 1 from the total because the group header
      line for the root group should not be included. }
    Result := FActiveIndex.Root.Lines - 1
end;

function TOvcAbstractReportView.GetOffsetOfData(DataValue: Pointer): Integer;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    Result := -1
  else begin
    Result := FActiveIndex.Root.OffsetOfData[DataValue];
    if Result > 0 then
      { We need to subtract 1 to account for the fact that we shouldn't count
        the group header line for the root view. }
      dec(Result);
  end;
end;

procedure TOvcAbstractReportView.InternalMakeVisible(Data: Pointer);
begin
  FActiveIndex.MakeVisible(Data);
end;

procedure TOvcAbstractReportView.MakeVisible(Data: Pointer);
begin
  DoLinesWillChange;
  FActiveIndex.MakeVisible(Data);
  DoLinesChanged(-1, -1);
end;

function TOvcAbstractReportView.GetOffsetOfGroup(Group: TOvcRvIndexGroup): Integer;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    Result := 0
  else
    if Group = FActiveIndex.Root then
      Result := 0
    else
      Result := FActiveIndex.Root.OffsetOfGroup[Group];
end;

function TOvcAbstractReportView.GetSelected(Index: Integer): Boolean;
var
  Element: TOvcRvIndexGroup;
  Item : Pointer;
begin
  CheckUpdate;
  CheckMultiSelect;
  if not Assigned(FActiveIndex) then
    Result := False
  else begin
    Element := GetElementAtLine(Index);
    if Assigned(Element) then
      Result := Element.IsSelected
    else begin
      Item := GetDataAtLine(Index);
      if Item = nil then
        Result := False
      else
        Result := FSelected.IndexOf(Item) <> -1;
    end;
  end;
end;

function TOvcAbstractReportView.GetTotalRef: TOvcRvIndexGroup;
begin
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    raise ENoActiveView.Create(SCNoActiveView,0);
  Result := FActiveIndex.Root;
end;

procedure TOvcAbstractReportView.PopulateIndex(IndexGroup: TOvcRvIndexGroup);
var
  Node: POvcListNode;
begin
  if (IndexGroup.FView.FFilterIndex <> -1)
  or (IndexGroup.FView.FFilter <> '') then begin
    if FRawData.First(Node) then
      repeat
        if DoFilter(IndexGroup.FView, Node.Item) then
          Node.UserData := Pointer(1)
        else
          Node.UserData := Pointer(0);
      until not FRawData.Next(Node)
  end else
    FRawData.SetAllUserData(Pointer(1));
  Inc(FBusyCount);
  try
    IndexGroup.ProcessAdds(FRawData, 2);
  finally
    Dec(FBusyCount)
  end;
end;

procedure TOvcAbstractReportView.RemoveDataPrim(Data : Pointer);
var
  IX : Integer;
begin
  FRawData.Delete(Data);
  with FSelected do begin
    IX := IndexOf(Data);
    if IX <> -1 then
      Delete(IX);
  end;
  FDeletes.AddIfUnique(Data);
  if FUpdateCount <= 0 then
    UpdateIndex;
end;

procedure TOvcAbstractReportView.InternalSelectAll(Select: Boolean);
var
  Node: POvcListNode;
begin
  if not Assigned(FActiveIndex) then
    Exit;
  if Select then begin
    if FRawData.First(Node) then
      repeat
        FSelected.Add(Node.Item);
      until not FRawData.Next(Node);
  end else
    FSelected.Clear;
  FActiveIndex.Root.SelectAll(Select);
end;

procedure TOvcAbstractReportView.SelectAll(Select: Boolean);
begin
  if not Assigned(FActiveIndex) then
    Exit;
  CheckUpdate;
  CheckMultiSelect;
  DoLinesWillChange;
  InternalSelectAll(Select);
  DoLinesChanged(-1, -1);
  DoSelectionChanged;
end;

procedure TOvcAbstractReportView.SetActiveIndexerView(const Value: string);
begin
  CheckUpdate;
  if FActiveIndexerView <> Value then begin
    DoLinesWillChange;
    Inc(FBusyCount);
    try
      FActiveIndexerView := Value;
      if Value = '' then
        FActiveIndex := nil
      else begin
        FActiveIndex := FindIndex(FActiveIndexerView, FInternalSortColumn);
        FInternalSortColumn := FActiveIndex.SortColumn;
        if (FActiveIndex.Root.Count = 0)
        and not FRawData.Empty then begin
          PopulateIndex(FActiveIndex.Root);
          FActiveIndex.SortPending;
        end;
      end;
      if FRawData.Empty then
        DeleteInactiveIndexes(FActiveIndex);
    finally
      Dec(FBusyCount)
    end;
    DoLinesChanged(0, -1)
  end
end;

procedure TOvcAbstractReportView.SetExpanded(GroupRef: TOvcRvIndexGroup; Value: Boolean);
var
  Delta: Integer;
  OldLines: Integer;
begin
  if not Assigned(FActiveIndex) then
    Exit;
  CheckUpdate;
  if TOvcRvIndexGroup(GroupRef).Expanded <> Value then begin
    DoLinesWillChange;
    CollapseEvent := True;
    Inc(FBusyCount);
    try
      { Retrieve the current number of lines in the view as a whole. }
      OldLines := FActiveIndex.Root.Lines;
      { Expand/collapse the specified group. }
      TOvcRvIndexGroup(GroupRef).Expanded := Value;
      { Delta is the change in the number of lines in the view as a whole. Since the only thing that has changed is the state
        of the specified group, a non-zero Delta implies that (a) the specified group is visible and (b) its line count has
        changed. }
      Delta := FActiveIndex.Root.Lines - OldLines;
      { We really only need to issue a LinesChanged event when Delta is non-zero, but since we already issued an
        OnLinesWillChange event, we will issue the LinesChanged event regardless. Caveat: GetOffsetOfGroup works properly
        only if the group is visible. If Delta is zero, it could be because the group is invisible, but in that case, it
        doesn't matter if GetOffsetOfGroup returns the wrong value, since nothing has changed. }
    finally
      Dec(FBusyCount)
    end;
    DoLinesChanged(Delta, GetOffsetOfGroup(TOvcRvIndexGroup(GroupRef)));
  end
end;

procedure TOvcAbstractReportView.SetSelected(Index: Integer; Value: Boolean);
var
  Element: TOvcRvIndexGroup;
  Item : Pointer;
  IX : Integer;
begin
  CheckMultiSelect;
  CheckUpdate;
  if not Assigned(FActiveIndex) then
    exit;
  Element := GetElementAtLine(Index);
  if Assigned(Element) then begin
    if Element.IsSelected <> Value then begin
      Element.IsSelected := Value;
      DoSelectionChanged;
    end;
  end else begin
    Item := GetDataAtLine(Index);
    if Item <> nil then begin
      IX := FSelected.IndexOf(Item);
      if IX = -1 then
        if Value then begin
          FSelected.Add(Item);
          DoSelectionChanged;
        end else
      else
        if not Value then begin
          FSelected.Delete(IX);
          DoSelectionChanged;
        end;
    end else
      raise ELineNoOutOfRange.CreateFmt(SCLineNoOutOfRange, [Index],0);
  end;
end;

procedure TOvcAbstractReportView.SetInternalSortColumn(Value: Integer);
begin
  CheckUpdate;
  if FInternalSortColumn <> Value then begin
    DoLinesWillChange;
    Inc(FBusyCount);
    try
      if FInternalSortColumn = - Value then begin
        if FActiveIndex <> nil then begin
          FActiveIndex.SortColumn := Value;
          FInternalSortColumn := FActiveIndex.SortColumn;
          FActiveIndex.Root.ReverseAll
        end;
      end else begin
        if FActiveIndex <> nil then begin
          FActiveIndex.SortColumn := Value;
          FInternalSortColumn := FActiveIndex.SortColumn;
          FActiveIndex.Root.SortAll;
          FActiveIndex.SortPending;
        end;
      end;
    finally
      Dec(FBusyCount)
    end;
    DoLinesChanged(0, -1);
    DoSortingChanged;
  end;
end;

procedure TOvcAbstractReportView.SetViews(Value: TOvcAbstractRvViews);
{Set method for the Views collection}
begin
  FViews.Assign(Value);
end;

function TOvcAbstractReportView.Total(GroupRef: TOvcRvIndexGroup; Field: Integer): Double;
begin
  CheckUpdate;
  Result := TOvcRvIndexGroup(GroupRef).Total[Field];
end;

function TOvcAbstractReportView.UniqueViewFieldName(const Name: string) : string;
var
  i, j : Integer;
  Found : Boolean;
begin
  Result := Name;
  repeat
    Found := False;
    for i := 0 to pred(Views.Count) do
      with Views.Items[i] do begin
        for j := 0 to pred(ViewFields.Count) do
          if ViewField[j].Name = Result then begin
            Found := True;
            break;
          end;
        if Found then
          break;
      end;
    if Found then
      Result := Result + '_1';
  until not Found;
end;

function TOvcAbstractReportView.UniqueViewName(const Name: string) : string;
var
  i : Integer;
  Found : Boolean;
begin
  Result := Name;
  repeat
    Found := False;
    for i := 0 to pred(Views.Count) do
      with Views.Items[i] do
        if Name = Result then begin
          Found := True;
          break;
        end;
    if Found then
      Result := Result + '_1';
  until not Found;
end;

procedure TOvcAbstractReportView.UpdateIndex;
var
  I,
  FI : Integer;
  FilterExp: string;
  V : TOvcAbstractRvView;
  Index : TOvcRvIndex;
  Node: POvcListNode;
begin
  if FSilentUpdate <= 0 then
    DoLinesWillChange;
  Inc(FBusyCount);
  try
    for I := 0 to FIndexes.Count - 1 do begin
      Index := IndexItems[I];
      V := Index.FView;
      FilterExp := Index.FView.FFilter;
      FI := Index.FView.FFilterIndex;
      if (FI <> -1) or (FilterExp <> '') then begin
        {For filtered views, we need to first check whether each changed item
         should be in this index.}
        if FUpdates.First(Node) then
          repeat
            if DoFilter(Index.FView, Node.Item) then
              Node.UserData := Pointer(0) {mark for inclusion}
            else
              Node.UserData := Pointer(1); {mark for exclusion}
          until not FUpdates.Next(Node);
        {delete changed items that should no longer be part of the index}
        Index.ProcessDeletes(FUpdates);
      end else
        {All changed items should be in any un-filtered index}
        FAdds.SetAllUserData(Pointer(0));
      { Mark items that we just deleted as processed.
        Other updates that are not present in the view's index should
        be converted to Adds, otherwise they should be processed as changes.}
      if FUpdates.First(Node) then
        repeat
          if NativeInt(Node.UserData) = 1 then
            Node.UserData := Pointer(0) {deleted, mark as processed}
          else begin
            if Index.Contents.ItemExists(Node.Item) then
              Node.UserData := Pointer(2) {present, mark for change}
            else
              Node.UserData := Pointer(3); {not present, mark for add}
          end;
        until not FUpdates.Next(Node);
      {Process updates. That is, check that each changed item still belongs to
       the group it was in before. If it doesn't, it's flagged with one (1),
       which means that the following call to ProcessDeletes will delete it,
       and then it's re-marked as a new add.}
      Index.ProcessUpdates(FUpdates);
      Index.ProcessDeletes(FUpdates); {process any deletes flagged by ProcessUpdates}
      if FUpdates.First(Node) then
        repeat
          if NativeInt(Node.UserData) <> 0 then
            Node.UserData := Pointer(2); {mark for re-add}
        until not FUpdates.Next(Node);
      Index.Root.ProcessAdds(FUpdates, 2); {level 1 used for filtering}
      FDeletes.SetAllUserData(Pointer(1));
      Index.ProcessDeletes(FDeletes);
      if (FI <> -1) or (FilterExp <> '') then begin
        if FAdds.First(Node) then
          repeat
            if DoFilter(V, Node.Item) then
              Node.UserData := Pointer(1) {mark for inclusion}
            else
              Node.UserData := Pointer(0); {mark for exclusion}
          until not FAdds.Next(Node);
      end else
        FAdds.SetAllUserData(Pointer(1));
      Index.Root.ProcessAdds(FAdds, 2); {level 1 used for filtering}
      {Sort any groups that were changed}
      Index.SortPending;
    end;
  finally
    Dec(FBusyCount);
  end;
  FUpdates.Clear;
  FAdds.Clear;
  FDeletes.Clear;
  if FRawData.Empty then
  //if FRawData.Count = 0 then
    DeleteInactiveIndexes(FActiveIndex);
  if FSilentUpdate <= 0 then
    DoLinesChanged(0, -1);
end;

function TOvcAbstractReportView.GetIndexItem(I: Integer): TOvcRvIndex;
begin
  Result := TOvcRvIndex(FIndexes.Objects[I])
end;

procedure TOvcAbstractReportView.DeleteInactiveIndexes(Active: TOvcRvIndex);
var
  I: Integer;
begin
  for i := pred(FIndexes.Count) downto 0 do
    if TOvcRvIndex(FIndexes.Objects[I]) <> Active then begin
      TOvcRvIndex(FIndexes.Objects[I]).Free;
      FIndexes.Delete(I);
    end;
end;

procedure TOvcAbstractReportView.DeleteViewIndexes(const ViewName : string);
var
  I: Integer;
begin
  for i := pred(FIndexes.Count) downto 0 do
    if pos(ViewName, FIndexes[i]) = 1 then begin
      TOvcRvIndex(FIndexes.Objects[I]).Free;
      FIndexes.Delete(I);
    end;
end;

procedure TOvcAbstractReportView.ClearIndexData;
var
  I: Integer;
begin
  for I := 0 to FIndexes.Count - 1 do
    TOvcRvIndex(FIndexes.Objects[I]).ClearData;
end;

function BuildIndexName(const ViewName: string; SortColumn: Integer): string;
begin
  Result := Format('%s%%%d', [ViewName, abs(SortColumn)]);
end;

function TOvcAbstractReportView.FindIndex(const ViewName: string; SortColumn: Integer): TOvcRvIndex;
var
  I: Integer;
  View: TOvcAbstractRvView;
begin
  View := FindView(ViewName);
  if SortColumn > View.ViewFields.Count then
    SortColumn := 1;
  if FIndexes.Find(BuildIndexName(ViewName, SortColumn), I) then
    Result := TOvcRvIndex(FIndexes.Objects[I])
  else begin
    Result := TOvcRvIndex.Create(Self, View, abs(SortColumn));
    FIndexes.AddObject(BuildIndexName(ViewName, SortColumn), Result)
  end
end;

function TOvcAbstractReportView.FindView(const ViewName: string): TOvcAbstractRvView;
var
  I: Integer;
begin
  I := 0;
  Result := nil;
  with Views do
    while (not Assigned(Result)) and (I < Count) do begin
      if Items[I].Name = ViewName then begin
        Result := Items[I];
        Break
      end;
      Inc(I)
    end;
  if not Assigned(Result) then
    raise EUnknownView.CreateFmt(SCUnknownView, [ViewName],0)
end;

{--TOvcRvIndex------------------------------------------------------------------------------------------------}

constructor TOvcRvIndex.Create(AOwner: TOvcAbstractReportView; AView: TOvcAbstractRvView; ASortColumn: Integer);
begin
  inherited Create;
  FOwner := AOwner;
  FView := AView;
  SortColumn := ASortColumn;
  FRoot := TOvcRvIndexSuperGroup.Create(Self, AView);
  FRoot.FExpanded := True;
  Contents := TOvcList.Create;
  DirtyList := TOvcFastList.Create;
end;

destructor TOvcRvIndex.Destroy;
begin
  if FOwner.FActiveIndex = Self then
    FOwner.FActiveIndex := nil;
  FRoot.Free;
  FRoot := nil;
  Contents.Free;
  DirtyList.Free;
  inherited Destroy;
end;

procedure TOvcRvIndex.ClearData;
begin
  FRoot.Clear;
  Contents.Clear;
end;

procedure TOvcRvIndex.MakeVisible(Data: Pointer);
var
  CurGroup : TOvcRvIndexGroup;
  Node: POvcListNode;
begin
  Node := Contents.FindNode(Data);
  if Node <> nil then begin
    CurGroup := TOvcRvIndexGroup(Node.UserData);
    if CurGroup <> nil then
      CurGroup.ExpandAll(True);
  end;
end;

procedure TOvcRvIndex.ProcessDeletes(Deletes : TOvcList);
var
  CurGroup : TOvcRvIndexGroup;
  CNode, Node: POvcListNode;
begin
  if Deletes.First(Node) then
    repeat
      if NativeInt(Node.UserData) = 1 then begin
        CNode := Contents.FindNode(Node.Item);
        if CNode <> nil then begin
          CurGroup := CNode.UserData;
          ProcessGroupDeletes(CurGroup, Node.Item);
          Contents.Delete(Node.Item);
        end;
      end;
    until not Deletes.Next(Node);
end;

procedure TOvcRvIndex.ProcessGroupDeletes(CurGroup : TOvcRvIndexGroup; Item : Pointer);
var
  JX : Integer;
begin
  while CurGroup <> nil do
    with CurGroup do begin
      if Item <> nil then begin
        if ContainsGroups then
          JX := FElements.IndexOf(Item)
        else
          JX := FindData(Item);
        if ContainsGroups then
          Element[JX].Free;
        FElements.Delete(JX);
        ResetLines;
        if FElements.Count = 0 then begin
          if Dirty then begin
            with DirtyList do
              Delete(IndexOf(CurGroup));
            Dirty := False;
          end;
          Item := CurGroup;
        end else begin
          if not Dirty then begin
            DirtyList.Add(CurGroup);
            Dirty := True;
          end;
          Item := nil;
        end
      end else begin
        if not Dirty then begin
          DirtyList.Add(CurGroup);
          Dirty := True;
        end;
        Item := nil;
      end;
      CurGroup := FGroup;
    end;
end;

procedure TOvcRvIndex.ProcessUpdates(Updates : TOvcList);
var
  J: Integer;
  MatchCount, Rslt : Integer;
  Item2 : Pointer;
  CurGroup : TOvcRvIndexGroup;
  CNode, Node: POvcListNode;
  Belong : Boolean;
  Exists: Boolean;
begin
  if Updates.Last(Node) then
    repeat
      {process items flagged for processing, items with userdata <> 2 will
       already have been deleted or flagged as new adds}
      if NativeInt(Node.UserData) = 2 then begin
        {get the group that the item belonged to previously}
        CNode := Contents.FindNode(Node.Item);
        CurGroup := CNode.UserData;
        {do we still belong to this group?}
        if CurGroup.FGroupColumn = 0 then
          Belong := True {This is a non-grouped supergroup}
        else
          if CurGroup.Count > 0 then begin
            Belong := False; {Assume failure}
            MatchCount := 0;
            for J := 0 to pred(CurGroup.Count) do
              if CurGroup.Element[J] <> Node.Item then begin {we can't check against ourselves}
                Item2 := CurGroup.Element[J];
                if CurGroup.FAbsGroupColumn < 0 then
                  Rslt := 0 {group contains all items (supergroup - non-grouped view)}
                else
                  Rslt := FOwner.DoCompareFields(Node.Item, Item2, CurGroup.FAbsGroupColumn);
                if Rslt = 0 then begin {we matched another item in the group}
                  Updates.PushIndexPosition;
                  Exists := Updates.ItemExists(Item2);
                  Updates.PopIndexPosition;
                  if not Exists then begin
                    inc(MatchCount);
                    Belong := True; {If that item does not have a pending update, we're home free}
                    break;          {If it does, we have to keep searching}
                  end;
                end else
                  break;
              end;
            if not Belong and (MatchCount > 0) and (MatchCount = CurGroup.Count - 1) then begin
              {All other items in group match ours}
              {This means we belong to the group even if all items changed}
              Belong := True;
            end;
          end else
            Belong := False; {Group is empty, we have to fail
              (should never happen - at least our item should be there)}
        if Belong then begin
          {yes, we still belong in this group - just mark the group for resorting}
          with CurGroup do
            if not Dirty then begin
              DirtyList.Add(CurGroup);
              Dirty := True;
            end;
          Node.UserData := Pointer(0); {mark item as processed}
        end else begin
          {we now belong in a different group, schedule a delete and an add for this item}
          Node.UserData := Pointer(1); {mark for delete/add}
        end;
      end;

    until not Updates.Prev(Node);
end;

procedure TOvcRvIndex.SetSortColumn(Value : Integer);
var
  i : Integer;
begin
  if Value = 0 then begin
    FSortColumn := 0;
    FSortColumn0 := -1;
    FComputeTotalsHere := False;
    FAbsIndex := -1;
    exit;
  end;
  FSortColumn := Value;
  FSortColumn0 := abs(Value) - 1;
  if (View.ViewFields.Count > 0) and
  not (View.ViewField[FSortColumn0].Field.CanSort) then begin
    FSortColumn := -1;
    for i := 0 to pred(View.ViewFields.Count) do
      if View.ViewField[FSortColumn0].Field.CanSort then begin
        FSortColumn0 := i;
        FSortColumn := i + 1;
        break;
      end;
    if FSortColumn = -1 then begin
      FSortColumn := 0;
      FSortColumn0 := -1;
      FComputeTotalsHere := False;
      FAbsIndex := -1;
      exit;
    end;
  end;
  if FSortColumn0 >= View.ViewFields.Count then begin
    FComputeTotalsHere := False;
    FAbsIndex := -1;
  end else begin
    FComputeTotalsHere := View.ViewFields.Items[FSortColumn0].ComputeTotals;
    FAbsIndex := View.ViewField[FSortColumn0].Field.Index;
  end;
end;

procedure TOvcRvIndex.SortPending;
var
  I : Integer;
  AllDone : Boolean;
begin
  if FSortColumn0 <> -1 then begin
    {Add parents to list}
    repeat
      AllDone := True;
      for i := pred(DirtyList.Count) downto 0 do
        with TOvcRvIndexGroup(DirtyList[i]) do
          if (FGroup <> nil) and not FGroup.Dirty then begin
            DirtyList.Add(FGroup);
            FGroup.Dirty := True;
            AllDone := False;
            break;
          end;
    until AllDone;
  end;
  {Sort dirty groups}
  for i := pred(DirtyList.Count) downto 0 do
    with TOvcRvIndexGroup(DirtyList[i]) do begin
      if FSortColumn0 <> -1 then
        if not FOwner.FOwner.Presorted then
          Sort;
      Dirty := False;
    end;
  DirtyList.Clear;
end;

{--TOvcRvIndexGroup--------------------------------------------------------------------------------------}

constructor TOvcRvIndexGroup.Create(AOwner: TOvcRvIndex;
                                    AGroup: TOvcRvIndexGroup;
                                    AGroupColumn: Integer;
                                    AView: TOvcAbstractRvView);
begin
  FOwner := AOwner;
  FGroup := AGroup;
  FView := AView;
  if AGroupColumn < 0 then
    AGroupColumn := 0;
  FGroupColumn := AGroupColumn;
  FElements := TOvcFastList.Create;
  if FOwner.View.ViewFields.Count <= AGroupColumn then begin
    FContainsGroups := False;
    FAbsGroupColumn := -1;
    if FOwner.View.ViewFields.Count > 0 then
      FAbsSortColumn := FView.ViewField[0].Field.Index
    else
      FAbsSortColumn := 0;
  end else begin
    FContainsGroups := FView.ViewField[AGroupColumn].GroupBy;
    if AGroupColumn > 0 then begin
      FAbsGroupColumn := FView.ViewField[AGroupColumn - 1].Field.Index;
      FAbsSortColumn := FView.ViewField[AGroupColumn].Field.Index;
    end else begin
      FAbsGroupColumn := -1;
      FAbsSortColumn := FView.ViewField[0].Field.Index;
    end;
  end;
  FLines := -1;
end;

destructor TOvcRvIndexGroup.Destroy;
begin
  ClearElementList;
  FElements.Free;
  inherited Destroy
end;

procedure TOvcRvIndexGroup.Clear;
begin
  ClearElementList;
end;

procedure TOvcRvIndexGroup.ClearElementList;
var
  I: Integer;
begin
  ResetLines;
  if ContainsGroups then
    for I := FElements.Count - 1 downto 0 do
      Element[I].Free;
  FElements.Clear;
end;

function TOvcRvIndexGroup.CompareValueTotals(Item1, Item2: TOvcRvIndexGroup): Integer;
var
  AbsIndex : Integer;
  C: Integer;
  Value1: Double;
  Value2: Double;
begin
  AbsIndex := FOwner.AbsIndex;
  Value1 := FOwner.Owner.DoGetFieldAsFloat(Item1, AbsIndex);
  Value2 := FOwner.Owner.DoGetFieldAsFloat(Item2, AbsIndex);
  if Value1 < Value2 then
    Result := -1
  else
    if Value1 > Value2 then
      Result := +1
    else begin
      Result := 0;
      { Sub-sort the view on the other sortable Fields, from left to right. }
      C := 0;
      while (Result = 0) and (C < OwnerFieldCount) do begin
        if C = AbsIndex then
          Result := 0
        else
          Result := FOwner.Owner.DoCompareFields(Item1, Item2, C);
        Inc(C)
      end
    end;
  if FOwner.SortColumn < 0 then
    Result := - Result
end;

function TOvcRvIndexGroup.CompareGroupTotals(Item1, Item2: TOvcRvIndexGroup): Integer;
var
  AbsIndex : Integer;
  C: Integer;
  Value1: Double;
  Value2: Double;
begin
  AbsIndex := FOwner.AbsIndex;
  Value1 := Item1.GetTotal(AbsIndex);
  Value2 := Item2.GetTotal(AbsIndex);
  if Value1 < Value2 then
    Result := -1
  else
    if Value1 > Value2 then
      Result := +1
    else begin
      Result := 0;
      { Sub-sort the view on the other sortable Fields, from left to right. }
      C := 0;
      while (Result = 0) and (C < OwnerFieldCount) do begin
        if C = AbsIndex then
          Result := 0
        else
          Result := FOwner.Owner.DoCompareFields(Item1.Data, Item2.Data, C);
        Inc(C)
      end
    end;
  if FOwner.SortColumn < 0 then
    Result := - Result
end;


function TOvcRvIndexGroup.CompareItemValues(Item1, Item2: TOvcRvIndexGroup): Integer;
var
  C, AbsIndex: Integer;
begin
  AbsIndex := FOwner.AbsIndex;
  Result := FOwner.Owner.DoCompareFields(Item1, Item2, AbsIndex);
  { Sub-sort the view on the other sortable Fields, from left to right. }
  if Result = 0 then begin
    C := 0;
    while (Result = 0) and (C < OwnerFieldCount) do begin
      if C = AbsIndex then
        Result := 0
      else
        Result := FOwner.Owner.DoCompareFields(Item1, Item2, C);
      Inc(C)
    end
  end;
  if FOwner.SortColumn < 0 then
    Result := - Result
end;

function TOvcRvIndexGroup.CompareGroupValues(Item1, Item2: TOvcRvIndexGroup): Integer;
var
  C{, AbsIndex}: Integer;
begin
  {AbsIndex := FOwner.AbsIndex;}
  Assert(TObject(Item1) is TOvcRvIndexGroup);
  Assert(TObject(Item2) is TOvcRvIndexGroup);
  Result := FOwner.Owner.DoCompareFields(Item1.Data, Item2.Data,
    {AbsIndex} FAbsSortColumn);
  { Sub-sort the view on the other sortable Fields, from left to right. }
  if Result = 0 then begin
    C := 0;
    while (Result = 0) and (C < OwnerFieldCount) do begin
      if C = FAbsSortColumn{AbsIndex} then
        Result := 0
      else
        Result := FOwner.Owner.DoCompareFields(Item1.Data, Item2.Data, C);
      Inc(C)
    end
  end;
  if FOwner.SortColumn < 0 then
    Result := - Result
end;

procedure TOvcRvIndexGroup.SetExpanded(Value: Boolean);
begin
  if FExpanded <> Value then begin
    if Value and (FGroup <> nil) and not FGroup.Expanded then
      FGroup.Expanded := True;
    FExpanded := Value;
    ResetLines;
  end;
end;

procedure TOvcRvIndexGroup.ResetLines;
begin
  if FLines <> -1 then begin
    FLines := -1;
    if FGroup <> nil then
      FGroup.ResetLines;
  end;
end;

procedure TOvcRvIndexGroup.ExpandAll(Expand: Boolean);
var
  I: Integer;
begin
  Expanded := Expand;
  if ContainsGroups then
    for I := 0 to FElements.Count - 1 do
      Element[I].ExpandAll(Expand);
end;

{ rewritten
procedure TOvcRvIndexGroup.SelectAll(Select: Boolean);
var
  I: Integer;
begin
  FSelected := Select;
  if ContainsGroups then
    for I := 0 to FElements.Count - 1 do
      Element[I].SelectAll(Select);
end;}

{ rewritten}
procedure TOvcRvIndexGroup.SelectAll(Select: Boolean);
var
  I, IX: Integer;
begin
  if Select <> IsSelected then
    if ContainsGroups then begin
      for I := 0 to FElements.Count - 1 do
        Element[I].SelectAll(Select)
    end else
      for I := 0 to FElements.Count - 1 do begin
        IX := Owner.Owner.FSelected.IndexOf(Element[I]);
        if IX = -1 then
          if Select then begin
            Owner.Owner.FSelected.Add(Element[I]);
            Owner.Owner.DoSelectionChanged;
          end else
        else
          if not Select then begin
            Owner.Owner.FSelected.Delete(IX);
            Owner.Owner.DoSelectionChanged;
          end;
      end;
end;

function TOvcRvIndexGroup.GetCount: Integer;
begin
  Result := FElements.Count;
end;

function TOvcRvIndexGroup.GetElement(I: Integer): TOvcRvIndexGroup;
begin
  Result := TOvcRvIndexGroup(FElements.Items[I]);
end;

function TOvcRvIndexGroup.GetData: Pointer;
begin
  if Count > 0 then
    if ContainsGroups then
      Result := Element[0].Data
    else
      Result := Element[0]
  else
    Result := nil
end;

function TOvcRvIndexGroup.GetElementAtLine(var Line: Integer): TOvcRvIndexGroup;
var
  I : Integer;
  NumLines : Integer;
begin
  { The default return value is nil. }
  Result := nil;
  { If the specified line index falls outside of the range for this group, just decrement the line index by the number of
    lines in the group. }
  NumLines := GetLines;
  if (Line < 0) or (Line >= NumLines) then
    Dec(Line, NumLines)
  else
    { If the line index is zero, then return this group. }
    if Line = 0 then
      Result := Self
    else begin
      { If we reach this point, it's because the group is expanded and the line index falls somewhere in it. First, decrement
        the line index by 1 to skip over the group header line. }
      Dec(Line);
      { If this group contains subgroups, iterate through the subgroups to locate the subgroup that contains the line index. }
      if ContainsGroups then begin
        I := 0;
        repeat
          Result := TOvcRvIndexGroup(Element[I]).GetElementAtLine(Line);
          Inc(I);
        until Assigned(Result) or (I >= FElements.Count) or (Line < 0);
      end else
        { If this group contains items, then return the item corresponding to the line index. }
        if (Line >= 0) and (Line < FElements.Count) then
          dec(Line, FElements.Count);
    end
end;

function TOvcRvIndexGroup.GetDataAtLine(var Line: Integer): Pointer;
var
  I : Integer;
  NumLines : Integer;
begin
  { The default return value is nil. }
  Result := nil;
  { If the specified line index falls outside of the range for this group, just decrement the line index by the number of
    lines in the group. }
  NumLines := GetLines;
  if (Line < 0) or (Line >= NumLines) then
    Dec(Line, NumLines)
  else
    { If the line index is zero, then return this group. }
    if Line = 0 then
      Result := Self.Data
    else begin
      { If we reach this point, it's because the group is expanded and the line index falls somewhere in it. First, decrement
        the line index by 1 to skip over the group header line. }
      Dec(Line);
      { If this group contains subgroups, iterate through the subgroups to locate the subgroup that contains the line index. }
      if ContainsGroups then begin
        I := 0;
        repeat
          Result := TOvcRvIndexGroup(Element[I]).GetDataAtLine(Line);
          Inc(I);
        until Assigned(Result) or (I >= FElements.Count)
      end else
        { If this group contains items, then return the item corresponding to the line index. }
        if (Line >= 0) and (Line < FElements.Count) then
          Result := Element[Line];
    end
end;

function TOvcRvIndexGroup.GetItemCount: Integer;
var
  I : Integer;
begin
  if ContainsGroups then begin
    Result := 0;
    for I := 0 to FElements.Count - 1 do
      Inc(Result, Element[I].ItemCount)
  end else
    Result := FElements.Count;
end;

function TOvcRvIndexGroup.GetLines : Integer;
var
  I: Integer;
begin
  if FLines = -1 then begin
    FLines := 1;
    if FExpanded then
      if ContainsGroups then begin
        for I := 0 to FElements.Count - 1 do
          inc(FLines, Element[I].Lines);
      end else
        inc(FLines, FElements.Count);
  end;
  Result := FLines;
end;

function TOvcRvIndexGroup.GetOffsetOfData(DataValue: Pointer): Integer;
var
  AccumulatedOffset: Integer;
  I: Integer;
begin
  Result := - 1;
  if Expanded then begin
    AccumulatedOffset := 1;
    for I := 0 to Count - 1 do begin
      if ContainsGroups then
        Result := Element[I].OffsetOfData[DataValue]
      else
        Result := FElements.IndexOf(DataValue);
      if Result >= 0 then begin
        Inc(Result, AccumulatedOffset);
        Break
      end else
        if ContainsGroups then
          Inc(AccumulatedOffset, Element[I].Lines)
        else
          Inc(AccumulatedOffset);
    end
  end
end;

function TOvcRvIndexGroup.GetOffsetOfGroup(Group: TOvcRvIndexGroup): Integer;
var
  AccumulatedOffset: Integer;
  I: Integer;
begin
  Result := - 1;
  if Expanded and ContainsGroups then begin
    AccumulatedOffset := 1;
    for I := 0 to Count - 1 do begin
      if Element[I] = Group then
        Result := 0
      else
        Result := TOvcRvIndexGroup(Element[I]).OffsetOfGroup[Group];
      if Result >= 0 then begin
        Inc(Result, AccumulatedOffset);
        Break
      end else
        Inc(AccumulatedOffset, Element[I].Lines)
    end
  end
end;

{ new}
function TOvcRvIndexGroup.GetSelected: Boolean;
var
  I, IX: Integer;
begin
  Result := False;
  if ContainsGroups then begin
    for I := 0 to FElements.Count - 1 do
      if not Element[I].IsSelected then
        exit;
  end else
    for I := 0 to FElements.Count - 1 do begin
      IX := Owner.Owner.FSelected.IndexOf(Element[I]);
      if IX = -1 then
        exit;
    end;
  Result := True;
end;

{ new}
procedure TOvcRvIndexGroup.SetSelected(const Value: Boolean);
var
  i, ix: Integer;
begin
  if ContainsGroups then begin
    for I := 0 to FElements.Count - 1 do
      Element[I].IsSelected := Value;
  end else
    for I := 0 to FElements.Count - 1 do begin
      IX := Owner.Owner.FSelected.IndexOf(Element[I]);
      if IX = -1 then
        if Value then begin
          Owner.Owner.FSelected.Add(Element[I]);
          Owner.Owner.DoSelectionChanged;
        end else
      else
        if not Value then begin
          Owner.Owner.FSelected.Delete(IX);
          Owner.Owner.DoSelectionChanged;
        end;
    end;
end;

function TOvcRvIndexGroup.GetTotal(Field: Integer): Double;
var
  I : Integer;
begin
  Result := 0.0;
  with FElements do
    for I := 0 to Count - 1 do
      if ContainsGroups then
        Result := Result + FOwner.Owner.DoGetGroupAsFloat(Element[I], Element[I].Total[Field])
          //Element[I].Total[Field]
      else
        Result := Result + FOwner.Owner.DoGetFieldAsFloat(Element[I], Field);
end;

procedure TOvcRvIndexGroup.ReverseAll;
var
  I : Integer;
  Tmp : Pointer;
begin
  with FElements do begin
    if ContainsGroups then
      for I := 0 to Count - 1 do
        Element[I].ReverseAll;
    for I := 0 to (Count div 2) - 1 do begin
      Tmp := FElements[I];
      FElements[I] := FElements[Count - I - 1];
      FElements[Count - I - 1] := Tmp;
    end;
  end;
end;

function TOvcRvIndexGroup.FindData(Data: Pointer): Integer;
var
  I: Integer;
begin
  if ContainsGroups then begin
    Result := -1;
    I := 0;
    while (I < FElements.Count) and (TOvcRvIndexGroup(Element[I]).Data <> Data) do
      Inc(I);
    if I = FElements.Count then
      Result := -1
    else if TOvcRvIndexGroup(Element[I]).Data = Data then
      Result := I;
  end else
    Result := FElements.IndexOf(Data);
end;

function TOvcRvIndexGroup.ProcessAdds(Adds : TOvcList; Level : Integer): Boolean;
var
  I: Integer;
  Rslt: Integer;
  IX : Integer;
  SubGroup : TOvcRvIndexGroup;
  DataHere : Pointer;
  HaveAny : Boolean;
  Node: POvcListNode;
begin
  HaveAny := False;
  Result := False;

  if (FElements.Count = 0) then
    DataHere := nil
  else
    DataHere := Data;

  if Adds.First(Node) then
    repeat
      if NativeInt(Node.UserData) >= (Level - 1) then begin
        if (FElements.Count = 0) then
          if HaveAny and (FAbsGroupColumn >= 0) then
            Rslt := FOwner.Owner.DoCompareFields(DataHere, Node.Item, FAbsGroupColumn)
          else
            Rslt := 0
        else
          if FAbsGroupColumn < 0 then
            Rslt := 0
          else
            Rslt := FOwner.Owner.DoCompareFields(DataHere, Node.Item, FAbsGroupColumn);
        if (Rslt = 0) then begin
          Node.UserData := Pointer(Level);
          if not HaveAny then begin
            DataHere := Node.Item;
            HaveAny := True;
          end;
        end;
      end;
    until not Adds.Next(Node);
  { At this point, those items from the list that pertain to this group are marked.
    How we proceed from here depends on whether this group contains subgroups or just
    items. If we don't have any items, we just skip the whole thing, of course. }
  if HaveAny then begin
    if ContainsGroups then begin
      { If this group contains subgroups, first pass the list to each of the subgroups for
        processing. If at any time the number of items in the list goes to zero, we know
        that we can skip iterating through the rest of the subgroups. }
      I := FElements.Count - 1;
      while (I >= 0) and HaveAny do begin
        Element[I].ProcessAdds(Adds, Level + 1);
        { Delete the subgroup if it's empty. }
        if TOvcRvIndexGroup(Element[I]).Count = 0 then begin
          IX := Owner.DirtyList.IndexOf(Element[I]);
          if IX <> -1 then
            Owner.DirtyList.Delete(IX);
          Element[I].Free;
          FElements.Delete(I);
        end;
        Dec(I);
      end;
      { Check to see if there are any items remaining in the list. }
      { If there are, we've got some new items to add. We need to create new subgroups
        for the new items, since they didn't go in any of the existing subgroups.
        To do this, we create a new subgroup. We then pass the list to the new
        subgroup's ProcessAdds method. Initially, the new group will be empty,
        of course, but that will cause it to be a group for the first entry we
        find. Any other items that match the first will go in the group as well.
        Repeat until all of the items have been placed in subgroups. }
      SubGroup := nil;
      repeat
        if SubGroup <> nil then begin
          if SubGroup.Count = 0 then begin
            IX := Owner.DirtyList.IndexOf(SubGroup);
            if IX <> -1 then
              Owner.DirtyList.Delete(IX);
            SubGroup.Free;
            with FElements do
              Delete(IndexOf(SubGroup));
          end;
        end;
        SubGroup := TOvcRvIndexGroup.Create(FOwner, Self, FGroupColumn + 1, FView);
        FElements.Add(SubGroup);
      until not SubGroup.ProcessAdds(Adds, Level + 1);
      { Delete the subgroup if it's empty. }
      if SubGroup.Count = 0 then begin
        IX := Owner.DirtyList.IndexOf(SubGroup);
        if IX <> -1 then
          Owner.DirtyList.Delete(IX);
        SubGroup.Free;
        with FElements do
          Delete(IndexOf(SubGroup));
      end;
    end else begin
      { If this group contains items rather than subgroups, process the items here. }
      if Adds.First(Node) then
        repeat
          if NativeInt(Node.UserData) >= Level then begin
            Assert(Node.Item <> nil);
            FElements.Add(Node.Item);
            FOwner.Contents.AddObject(Node.Item, Self);
            Node.UserData := Pointer(0); {Mark the entry as used}
          end;
        until not Adds.Next(Node); //(Node = LowNode) or not Adds.Prev(Node);
      { If this group contains items rather than subgroups, process the items here. }
    end;
    { Finally, we need to make sure the changed group is sorted. }
    if not Dirty then begin
      Owner.DirtyList.Add(Self);
      Dirty := True;
    end;
    Result := True;
  end;
  ResetLines;
end;

type
  TListSortCompare = function (Data1, Data2: Pointer; FieldIndex: Integer) : Integer of object;

procedure QuickSort(SortList: PPointerList; L, R, FieldIndex: Integer;
  SCompare: TListSortCompare);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := POvcListNode(SortList^[(L + R) shr 1]).Item;
    repeat
      while SCompare(POvcListNode(SortList^[I]).Item, P, FieldIndex) < 0 do
        Inc(I);
      while SCompare(POvcListNode(SortList^[J]).Item, P, FieldIndex) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J, FieldIndex, SCompare);
    L := I;
  until I >= R;
end;

function BinarySearch(SortList: PPointerList; Key: Pointer; L, U, FieldIndex: Integer;
  SCompare: TListSortCompare): Integer;
var
  I : Integer;
  C : Integer;
begin
  while L <= U do begin
    I := (L + U) div 2;
    C := SCompare(POvcListNode(SortList^[I]).Item, Key, FieldIndex);
    if C = 0 then begin
      Result := I;
      exit;
    end;
    if C > 0 then
      U := I - 1
    else
      L := I + 1;
  end;
  Result := -1;
end;

function TOvcRvIndexGroup.ProcessAdds2(Adds: TOvcFastList;
  Level: Integer): Boolean;
var
  I, J: Integer;
  IX : Integer;
  SubGroup : TOvcRvIndexGroup;
  DataHere : Pointer;
  HaveAny : Boolean;
  Node: POvcListNode;
  SubList: TOvcFastList;
begin
  if Adds.Count > 1 then
    QuickSort(Adds.List, 0, Adds.Count - 1, FAbsGroupColumn, FOwner.Owner.DoCompareFields);

  HaveAny := False;
  Result := False;

  if (FElements.Count = 0) then begin
    DataHere := nil;
    I := 0;
    while I < Adds.Count do begin
      Node := Adds[I];
      if NativeInt(Node.UserData) >= (Level - 1) then begin
        Node.UserData := Pointer(Level);
        DataHere := Node.Item;
        HaveAny := True;
        break;
      end;
      inc(I);
    end;
    if DataHere <> nil then begin
      inc(I);
      while I < Adds.Count do begin
        Node := Adds[I];
        if NativeInt(Node.UserData) >= (Level - 1) then
          if FOwner.Owner.DoCompareFields(DataHere, Node.Item, FAbsGroupColumn) <> 0 then
            break
          else
            Node.UserData := Pointer(Level);
        inc(I);
      end;
    end;
  end else begin
    DataHere := Data;
    I := BinarySearch(Adds.List, DataHere, 0, Adds.Count - 1, FAbsGroupColumn, FOwner.Owner.DoCompareFields);
    if I <> -1 then begin
      HaveAny := True;
      J := I;
      while I < Adds.Count do begin
        Node := Adds[I];
        if NativeInt(Node.UserData) >= (Level - 1) then
          if FOwner.Owner.DoCompareFields(DataHere, Node.Item, FAbsGroupColumn) <> 0 then
            break
          else
            Node.UserData := Pointer(Level);
        inc(I);
      end;
      I := J - 1;
      while I >= 0 do begin
        Node := Adds[I];
        if NativeInt(Node.UserData) >= (Level - 1) then
          if FOwner.Owner.DoCompareFields(DataHere, Node.Item, FAbsGroupColumn) <> 0 then
            break
          else
            Node.UserData := Pointer(Level);
        dec(I);
      end;
    end;
  end;

  { At this point, those items from the list that pertain to this group are marked.
    How we proceed from here depends on whether this group contains subgroups or just
    items. If we don't have any items, we just skip the whole thing, of course. }
  if HaveAny then begin
    if ContainsGroups then begin
      { If this group contains subgroups, first pass the list to each of the subgroups for
        processing. If at any time the number of items in the list goes to zero, we know
        that we can skip iterating through the rest of the subgroups. }
      SubList := TOvcFastList.Create;
      for I := 0 to Adds.Count - 1 do begin
        Node := Adds[I];
        if NativeInt(Node.UserData) >= Level then
          SubList.Add(Node);
      end;

      if SubList.Count > 0 then begin
        I := FElements.Count - 1;
        while (I >= 0) and HaveAny do begin
          Element[I].ProcessAdds2(SubList, Level + 1);
          { Delete the subgroup if it's empty. }
          if TOvcRvIndexGroup(Element[I]).Count = 0 then begin
            IX := Owner.DirtyList.IndexOf(Element[I]);
            if IX <> -1 then
              Owner.DirtyList.Delete(IX);
            Element[I].Free;
            FElements.Delete(I);
          end;
          Dec(I);
        end;
      end;

      { Check to see if there are any items remaining in the list. }
      { If there are, we've got some new items to add. We need to create new subgroups
        for the new items, since they didn't go in any of the existing subgroups.
        To do this, we create a new subgroup. We then pass the list to the new
        subgroup's ProcessAdds method. Initially, the new group will be empty,
        of course, but that will cause it to be a group for the first entry we
        find. Any other items that match the first will go in the group as well.
        Repeat until all of the items have been placed in subgroups. }
      SubGroup := nil;
      repeat
        if SubGroup <> nil then begin
          if SubGroup.Count = 0 then begin
            IX := Owner.DirtyList.IndexOf(SubGroup);
            if IX <> -1 then
              Owner.DirtyList.Delete(IX);
            SubGroup.Free;
            with FElements do
              Delete(IndexOf(SubGroup));
          end;
        end;
        if SubList.Count = 0 then
          break;
        SubGroup := TOvcRvIndexGroup.Create(FOwner, Self, FGroupColumn + 1, FView);
        FElements.Add(SubGroup);
      until not SubGroup.ProcessAdds2(SubList, Level + 1);
      SubList.Free;
      { Delete the subgroup if it's empty. }
      if (SubGroup <> nil) and (SubGroup.Count = 0) then begin
        IX := Owner.DirtyList.IndexOf(SubGroup);
        if IX <> -1 then
          Owner.DirtyList.Delete(IX);
        SubGroup.Free;
        with FElements do
          Delete(IndexOf(SubGroup));
      end;
    end else begin
      { If this group contains items rather than subgroups, process the items here. }
      for i := Adds.Count - 1 downto 0 do begin
        Node := Adds[I];
        if NativeInt(Node.UserData) >= Level then begin
          Assert(Node.Item <> nil);
          FElements.Add(Node.Item);
          FOwner.Contents.AddObject(Node.Item, Self);
          Node.UserData := Pointer(0); {Mark the entry as used}
          Adds.Delete(i);
        end;
      end;
      { If this group contains items rather than subgroups, process the items here. }
    end;
    { Finally, we need to make sure the changed group is sorted. }
    if not Dirty then begin
      Owner.DirtyList.Add(Self);
      Dirty := True;
    end;
    Result := True;
  end;
  ResetLines;
end;

type
  TCompare = function(Item1, Item2 : TOvcRvIndexGroup) : Integer of object;

procedure ShellSort(SortList: PPointerList; T: Integer; Compare : TCompare);
var
  H: Integer;
  I: Integer;
  J: Integer;
  L: Integer;
  Temp: Pointer;
begin
  H := 1;
  repeat
    H := H * 3 + 1;
  until H > T;
  repeat
    H := H div 3;
    L := H;
    for I := L to T - 1 do begin
      Temp := SortList^[I];
      J := I;
      while Compare(SortList^[J - H], Temp) > 0 do begin
        SortList^[J] := SortList^[J - H];
        J := J - H;
        if J < L then
          Break;
      end;
      SortList^[J] := Temp;
    end;
  until H = 1;
end;

procedure TOvcRvIndexGroup.Sort;
begin
  OwnerFieldCount := FOwner.FOwner.FFields.Count;
  if (FElements <> nil) and (FOwner.View.ViewFields.Count > 0) then
    if FOwner.ComputeTotalsHere then
      if ContainsGroups then
        ShellSort(FElements.List, FElements.Count, CompareGroupTotals)
      else
        ShellSort(FElements.List, FElements.Count, CompareValueTotals)
    else
      if ContainsGroups then
        ShellSort(FElements.List, FElements.Count, CompareGroupValues)
      else
        ShellSort(FElements.List, FElements.Count, CompareItemValues);
end;

procedure TOvcRvIndexGroup.SortAll;
var
  I: Integer;
begin
  if not Dirty then begin
    Owner.DirtyList.Add(Self);
    Dirty := True;
  end;
  if ContainsGroups then
    for I := 0 to FElements.Count - 1 do
      TOvcRvIndexGroup(Element[I]).SortAll;
end;

procedure TOvcAbstractReportView.DoSelectionChanged;
begin
  if assigned(FSelectionChanged) then
    FSelectionChanged(Self);
end;

function TOvcRvIndexGroup.Min(SimpleExpression: TObject): Variant;
var
  I : Integer;
  V: Variant;
  First: Boolean;
begin
  Result := varNull;
  First := True;
  with FElements do
    for I := 0 to Count - 1 do begin
      if ContainsGroups then
        V := Element[I].Min(SimpleExpression)
      else
        V := TOvcRvExpSimpleExpression(SimpleExpression).GetValue(Element[I]);
      if First then begin
        Result := V;
        First := False;
      end else
        if V < Result then
          Result := V;
    end;
end;

function TOvcRvIndexGroup.Avg(SimpleExpression: TObject): Variant;
begin
  if Count = 0 then
    Result := varNull
  else
    Result := Sum(SimpleExpression) / Count;
end;

function TOvcRvIndexGroup.Max(SimpleExpression: TObject): Variant;
var
  I : Integer;
  V: Variant;
  First: Boolean;
begin
  Result := varNull;
  First := True;
  with FElements do
    for I := 0 to Count - 1 do begin
      if ContainsGroups then
        V := Element[I].Max(SimpleExpression)
      else
        V := TOvcRvExpSimpleExpression(SimpleExpression).GetValue(Element[I]);
      if First then begin
        Result := V;
        First := False;
      end else
        if V > Result then
          Result := V;
    end;
end;

function TOvcRvIndexGroup.Sum(SimpleExpression: TObject): double;
var
  I : Integer;
begin
  Result := 0;
  with FElements do
    for I := 0 to Count - 1 do begin
      if ContainsGroups then
        Result := Result +  Element[I].Sum(SimpleExpression)
      else
        Result := Result + TOvcRvExpSimpleExpression(SimpleExpression).GetValue(Element[I]);
    end;
end;

function TOvcRvIndex.Avg(SimpleExpression: TObject): Variant;
begin
  Result := Root.Avg(SimpleExpression);
end;

function TOvcRvIndex.Max(SimpleExpression: TObject): Variant;
begin
  Result := Root.Max(SimpleExpression);
end;

function TOvcRvIndex.Min(SimpleExpression: TObject): Variant;
begin
  Result := Root.Min(SimpleExpression);
end;

function TOvcRvIndex.Sum(SimpleExpression: TObject): double;
begin
  Result := Root.Sum(SimpleExpression);
end;

function TOvcRvIndex.Count: Integer;
begin
  Result := Root.Count;
end;

function TOvcAbstractReportView.DoExtern(const ArgList: Variant): Variant;
begin
  if Assigned(FExtern) then
    FExtern(Self, ArgList, Result)
  else
    raise Exception.Create('Cannot evaluate EXTERN function - no OnExtern handler assigned');
end;

{ TOvcRvIndexSuperGroup }

constructor TOvcRvIndexSuperGroup.Create(AOwner: TOvcRvIndex;
  AView: TOvcAbstractRvView);
begin
  inherited Create(AOwner, nil, 0, AView);
end;

type
  TListSortCompare2 = function (Data1, Data2: Pointer) : Integer of object;

procedure QuickSort2(SortList: PPointerList; L, R: Integer;
  SCompare: TListSortCompare2);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do
        Inc(I);
      while SCompare(SortList^[J], P) > 0 do
        Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort2(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

function TOvcRvIndexSuperGroup.CompareItems(Data1, Data2: Pointer) : Integer;
var
  i: Integer;
begin
  Result := 0;
  i := 0;
  while i < Stop do begin
    Result := SuperCompare(Data1, Data2, FX[i]);
    if Result <> 0 then
      break;
    inc(i);
  end;
end;

procedure TOvcRvIndexSuperGroup.BuildNewGroupIndex(Adds : TOvcList; Level : Integer);
  {Changes:
     07/2011, AB: Changed 'SubList.List[..]' to 'SubList.List^[..]'  }
type
  TCompareFields = function (Data1, Data2: Pointer; FieldIndex: Integer) : Integer of object;
var
  SubList: TOvcFastList;
  Node: POvcListNode;
  i, j: Integer;
  Depth: Integer;
  Groups: array[-1..OvcRvMaxGroupingDepth-1] of TOvcRvIndexGroup;
  GroupFields: array[0..OvcRvMaxGroupingDepth-1] of Integer;
  CompareFunc: TCompareFields;
  NewGroup: TOvcRvIndexGroup;
  ItemGroup: TOvcRvIndexGroup;
begin
  {new grouped index}
  SubList := TOvcFastList.Create;
  {note: SubList is list of items here}
  if Adds.First(Node) then
    repeat
      if NativeInt(Node.UserData) >= (Level - 1) then begin
        Node.UserData := Pointer(0); {Mark the entry as used}
        SubList.Add(Node.Item);
      end;
    until not Adds.Next(Node);

  if SubList.Count > 1 then begin
    Stop := 0;
    repeat
      if not FView.ViewField[Stop].GroupBy then
        break;
      FX[Stop] := FView.ViewField[Stop].Field.Index;
      inc(Stop);
    until Stop >= FView.ViewFields.Count;

    SuperCompare := FOwner.Owner.DoCompareFields;
    QuickSort2(SubList.List, 0, SubList.Count - 1, CompareItems);
  end;

  Depth := 0;
  while (Depth < FView.ViewFields.Count)
  and FView.ViewField[Depth].GroupBy do
    inc(Depth);

  for i := 0 to OvcRvMaxGroupingDepth -1 do begin
    Groups[i] := nil;
    GroupFields[i] := -1;
  end;

  Groups[-1] := Self;

  for i := 0 to Depth - 1 do
    GroupFields[i] := FView.ViewField[i].Field.Index;

  CompareFunc := FOwner.Owner.DoCompareFields;

  for i := 0 to SubList.Count - 1 do begin
    j := 0;
    repeat
      if (Groups[j] = nil)
      or (CompareFunc(SubList.List^[i], Groups[j].Data, GroupFields[j]) <> 0) then
        break;
      inc(j);
    until j >= Depth;
    if j < Depth then begin
      repeat
        NewGroup := TOvcRvIndexGroup.Create(Owner, Groups[j - 1], j + 1, FView);;
        Groups[j] := NewGroup;
        Owner.DirtyList.Add(NewGroup);
        NewGroup.Dirty := True;
        Groups[j - 1].FElements.Add(NewGroup);
        inc(j);
      until j >= Depth;
    end;
    ItemGroup := Groups[Depth-1];
    ItemGroup.FElements.Add(SubList.List^[i]);
    FOwner.Contents.AddObject(SubList.List^[i], ItemGroup);
  end;

  SubList.Free;
end;

function TOvcRvIndexSuperGroup.ProcessAdds(Adds : TOvcList; Level : Integer): Boolean;
var
  I: Integer;
  IX : Integer;
  SubGroup : TOvcRvIndexGroup;
  Node: POvcListNode;
  SubList: TOvcFastList;
begin
  if ContainsGroups then begin
    if FElements.Count = 0 then begin
      BuildNewGroupIndex(Adds, Level);
    end else begin
      SubList := TOvcFastList.Create;
      {note: SubList is list of nodes here}
      if Adds.First(Node) then
        repeat
          if NativeInt(Node.UserData) >= (Level - 1) then begin
            Node.UserData := Pointer(Level);
            SubList.Add(Node);
          end;
        until not Adds.Next(Node);
      { At this point, those items from the list that pertain to this group are marked.
        How we proceed from here depends on whether this group contains subgroups or just
        items. If we don't have any items, we just skip the whole thing, of course. }

      { If this group contains subgroups, first pass the list to each of the subgroups for
        processing. If at any time the number of items in the list goes to zero, we know
        that we can skip iterating through the rest of the subgroups. }
      if SubList.Count >= 0 then begin
        I := FElements.Count - 1;
        while (I >= 0) do begin
          Element[I].ProcessAdds2(SubList, Level + 1);
          //Element[I].ProcessAdds(Adds, Level + 1);
          if SubList.Count = 0 then
            break;
          { Delete the subgroup if it's empty. }
          if TOvcRvIndexGroup(Element[I]).Count = 0 then begin
            IX := Owner.DirtyList.IndexOf(Element[I]);
            if IX <> -1 then
              Owner.DirtyList.Delete(IX);
            Element[I].Free;
            FElements.Delete(I);
          end;
          Dec(I);
        end;
      end;
      { Check to see if there are any items remaining in the list. }
      { If there are, we've got some new items to add. We need to create new subgroups
        for the new items, since they didn't go in any of the existing subgroups.
        To do this, we create a new subgroup. We then pass the list to the new
        subgroup's ProcessAdds method. Initially, the new group will be empty,
        of course, but that will cause it to be a group for the first entry we
        find. Any other items that match the first will go in the group as well.
        Repeat until all of the items have been placed in subgroups. }
      SubGroup := nil;
      repeat
        if SubGroup <> nil then begin
          if SubGroup.Count = 0 then begin
            IX := Owner.DirtyList.IndexOf(SubGroup);
            if IX <> -1 then
              Owner.DirtyList.Delete(IX);
            SubGroup.Free;
            with FElements do
              Delete(IndexOf(SubGroup));
          end;
        end;
        if SubList.Count = 0 then
          break;
        SubGroup := TOvcRvIndexGroup.Create(FOwner, Self, 1, FView);
        FElements.Add(SubGroup);
      until not SubGroup.ProcessAdds2(SubList, Level + 1);
      SubList.Free;
      { Delete the subgroup if it's empty. }
      if SubGroup <> nil then
        if SubGroup.Count = 0 then begin
          IX := Owner.DirtyList.IndexOf(SubGroup);
          if IX <> -1 then
            Owner.DirtyList.Delete(IX);
          SubGroup.Free;
          with FElements do
            Delete(IndexOf(SubGroup));
        end;
    end;
  end else begin
    { At this point, those items from the list that pertain to this group are marked.}
    { If this group contains items rather than subgroups, process the items here. }
    if Adds.First(Node) then
      repeat
        if NativeInt(Node.UserData) >= (Level - 1) then begin
          Assert(Node.Item <> nil);
          FElements.Add(Node.Item);
          FOwner.Contents.AddObject(Node.Item, Self);
          Node.UserData := Pointer(0); {Mark the entry as used}
        end;
      until not Adds.Next(Node);
  end;
  { Finally, we need to make sure the changed group is sorted. }
  if not Dirty then begin
    Owner.DirtyList.Add(Self);
    Dirty := True;
  end;
  Result := True;
  ResetLines;
end;

end.

{*********************************************************}
{*                  OVCDRPVW.PAS 4.08                    *}
{*********************************************************}

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
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdrpvw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, OvcConst, OvcExcpt,
  OvcMisc, OvcBase, OvcRvIdx, OvcRptVw;

type
  TOvcDataReportView = class;
  TOvcDataRvField = class(TOvcRvField)
  protected
    FFormat : string;
    FCustomFormat : Boolean;
    procedure SetDataType(Value : TOvcDrDataType);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property CustomFormat : Boolean
      read FCustomFormat write FCustomFormat default False;
    property DataType : TOvcDRDataType
      read FDataType write SetDataType default dtString;
    property Format : string
      read FFormat write FFormat;
  end;
  

  TOvcDataRvItem = class;
  TIntArray = array[0..pred(MaxInt div sizeof(Integer))] of Integer;
  PIntArray = ^TIntArray;
  TByteArray = array[0..pred(MaxInt div sizeof(Byte))] of Byte;
  PByteArray = ^TByteArray;
  TOvcDataRvItems = class;

  TOvcDataRvItem = class
  

  protected
    FData : Pointer;
    FOwner : TOvcDataReportView;
    FOwnerList : TOvcDataRvItems;
    FieldIndexTable : PIntArray;
    FieldSizeTable : PIntArray;
    FieldIndexSize : Integer;
    DataBuffer : PByteArray;
    DataBufferSize : Integer;
    Temp : Boolean;
    procedure Changed;
    procedure CheckType(Index : Integer; DataType : TOvcDRDataType);
    procedure ClearData;
    function InternalGetAsBoolean(Index: Integer): Boolean;
    function GetAsBoolean(Index: Integer): Boolean;
    function GetAsDateTime(Index : Integer): TDateTime;
    function InternalGetAsDateTime(Index : Integer): TDateTime;
    function InternalGetAsDWord(Index: Integer): DWord;
    function GetAsDWord(Index: Integer): DWord;
    function GetCustomFieldBuffer(Index: Integer): Pointer;
    function GetValue(Index: Integer): Variant;
    procedure SetValue(Index: Integer; const Value: Variant);
    function GetAsFloat(Index: Integer): Extended;
    function InternalGetAsFloat(Index: Integer): Extended;
    function InternalGetAsInteger(Index: Integer): Integer;
    function GetAsInteger(Index: Integer): Integer;
    function GetAsString(Index: Integer): string;
    function GetFieldSize(Index: Integer): Integer;
    function GetSelected : Boolean;
    procedure SetAsBoolean(Index: Integer; const Value: Boolean);
    procedure SetAsDateTime(Index : Integer; const Value: TDateTime);
    procedure SetAsDWord(Index: Integer; const Value: DWord);
    procedure SetAsFloat(Index: Integer; const Value: Extended);
    procedure SetAsInteger(Index: Integer; const Value: Integer);
    procedure SetAsString(Index: Integer; const Value: string);
    procedure SetFieldSize(Index, NewSize : Integer);
    procedure SetSelected(Value : Boolean);
    procedure ValidateData;
    property FieldSize[Index : Integer] : Integer
      read GetFieldSize write SetFieldSize;
    constructor Create(AOwner : TOvcDataReportView; AOwnerList : TOvcDataRvItems; Temporary : Boolean);
    function GetAsPChar(Index: Integer) : PChar;
    property AsPChar[Index : Integer] : PChar
      read GetAsPChar;
    procedure PreAllocate;
  public
    procedure Assign(Source: TOvcDataRvItem);
    destructor Destroy; override;
    procedure ReadFromStream(Stream : TStream);
    procedure WriteToStream(Stream : TStream);

    property AsString[Index : Integer] : string
      read GetAsString write SetAsString;
    property AsFloat[Index : Integer] : Extended
      read GetAsFloat write SetAsFloat;
    property AsDateTime[Index : Integer] : TDateTime
      read GetAsDateTime write SetAsDateTime;
    property AsInteger[Index : Integer] : Integer
      read GetAsInteger write SetAsInteger;
    property AsBoolean[Index : Integer] : Boolean
      read GetAsBoolean write SetAsBoolean;
    property AsDWord[Index : Integer] : DWord
      read GetAsDWord write SetAsDWord;
    procedure SetCustom(Index: Integer; const Value; Size: DWord);
    property Value[Index: Integer]: Variant
      read GetValue write SetValue;
    property Data : Pointer read FData write FData;
    property Selected : Boolean
      read GetSelected write SetSelected;
  end;

  TOvcDataRvItems = class(TPersistent)
  

  protected
    FItems : TList;
    FOwner : TOvcDataReportView;
    PendingStream : TMemoryStream;
    ClearingAll : Boolean;
    function GetCount: Integer;
    function GetItem(Index: Integer): TOvcDataRvItem;
    procedure DefineProperties(Filer: TFiler); override;
  public
    procedure LoadFromStream(Stream : TStream);
    procedure SaveToStream(Stream : TStream);
    constructor Create(AOwner : TOvcDataReportView); virtual;
    destructor Destroy; override;

    function Add : TOvcDataRvItem;
    procedure Assign(Source : TPersistent); override;
    procedure Clear;
    property Count : Integer read GetCount;
    property Item[Index: Integer]: TOvcDataRvItem read GetItem; default;
  end;

  TOvcDRVCompareCustomEvent =
    procedure(Sender : TObject; FieldIndex: Integer; Data1, Data2: Pointer;
      var Result: Integer) of object;
  TOvcDRVGetCustomAsStringEvent =
    procedure(Sender : TObject; FieldIndex: Integer; Data: Pointer;
      var Result: string) of object;
  TOvcDRVGetCustomFieldSizeEvent =
    procedure(Sender : TObject; FieldIndex: Integer;
      var Result: DWord) of object;

  TOvcDrawDViewFieldEvent =
    procedure(Sender : TObject; Canvas : TCanvas; Data : TOvcDataRvItem;
      ViewFieldIndex: Integer; Rect : TRect; const S : string) of object;
  TOvcDrawDViewFieldExEvent =
    procedure(Sender : TObject; Canvas : TCanvas;
      Field : TOvcRvField; ViewField : TOvcRvViewField;
      var TextAlign : Integer; IsSelected, IsGroupLine : Boolean;
      Data : TOvcDataRvItem; Rect : TRect; const Text, TruncText : string;
      var DefaultDrawing : Boolean) of object;
  TOvcDRVEnumEvent =
    procedure(Sender : TObject; Data : TOvcDataRvItem; var Stop : Boolean; UserData : Pointer) of object;
    {- Enumerator method type. Stop should default to False. If changed to True by the
       event, the enumeration terminates.}

  TOvcDRVFilterEvent =
    procedure(Sender: TObject; Data: TOvcDataRvItem; FilterIndex: Integer; var Include: Boolean) of object;

  TOvcDRVFormatFloatEvent =
    procedure(Sender: TObject; Index: Integer; const Value: double; var
      Result: string) of object;

  TOvcDataReportView = class(TOvcCustomReportView)
  

  protected
    FItems             : TOvcDataRvItems;
    FOnDrawViewField   : TOvcDrawDViewFieldEvent;
    FOnDrawViewFieldEx : TOvcDrawDViewFieldExEvent;
    FOnEnumerate       : TOvcDRVEnumEvent;
    FOnFormatFloat : TOvcDRVFormatFloatEvent;
    FOnCompareCustom : TOvcDRVCompareCustomEvent;
    FOnGetCustomAsString : TOvcDRVGetCustomAsStringEvent;
    procedure CountSelection(Sender: TObject; Data: TOvcDataRvItem;
      var Stop: Boolean; UserData: Pointer);
    procedure CountSelection2(Sender: TObject; Data: TOvcDataRvItem;
      var Stop: Boolean; UserData: Pointer);
    function DoCompareCustom(FieldIndex: Integer; Data1,
      Data2: Pointer): Integer;
    function DoCompareFields(Data1, Data2: Pointer; FieldIndex: Integer) : Integer; override;
    procedure DoDrawViewField(Canvas : TCanvas; Data : Pointer;
      Field : TOvcRvField; ViewField : TOvcRvViewField; TextAlign : Integer;
      IsSelected, IsGroup : Boolean;
      ViewFieldIndex : Integer; Rect : TRect; const Text, TruncText : string); override;
    procedure DoEnumEvent(Data : Pointer; var Stop : boolean; UserData : Pointer); override;
    function DoGetCustomAsString(FieldIndex: Integer; Data: Pointer): string;
    function DoGetFieldAsFloat(Data: Pointer; Field: Integer) : Double; override;
    function DoGetFieldAsString(Data : Pointer; FieldIndex: Integer) : string; override;
    function DoGetFieldValue(Data: Pointer; Field: Integer) : Variant; override;
    function DoFilter(View: TOvcAbstractRvView; Data: Pointer): Boolean; override;
    function DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string; override;
    procedure DoKeySearch(FieldIndex : Integer;const SearchString : string); override;
    function GetCurrentItem: TOvcDataRvItem;
    function GetField(Index : Integer) : TOvcDataRvField;
    function GetFieldClassType : TOvcCollectibleClass; override;
    procedure Loaded; override;
    procedure SetCurrentItem(const Value: TOvcDataRvItem);
    function GetOnFilter: TOvcDRVFilterEvent;
    procedure SetOnFilter(const Value: TOvcDRVFilterEvent);
    function GetHaveSelection : Boolean; override;
    function GetSelectionCount : Integer; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    property CurrentItem : TOvcDataRvItem
      read GetCurrentItem write SetCurrentItem;
    procedure Enumerate(UserData : Pointer); override;
    procedure EnumerateSelected(UserData : Pointer); override;
    procedure EnumerateEx(Backwards, SelectedOnly: Boolean; StartAfter: Pointer;
      UserData : Pointer); override;
    property Field[Index : Integer] : TOvcDataRvField
                   read GetField;
  

  published
    property Anchors;
    property Constraints;
    property DragKind;
    property ActiveView;
    property Align;
    property AutoCenter;
    property BorderStyle;
    property Ctl3D;
    property ColumnResize;
    property Controller;
    property CustomViewStore;
    property DragMode;
    property Enabled;
    property Fields;
    property FieldWidthStore;
    property Font;
    property GridLines;
    property GroupColor;
    property HeaderImages;
    property HideSelection;
    property Items : TOvcDataRvItems
      read FItems write FItems;
    property KeySearch;
    property KeyTimeout;
    property MultiSelect;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint default False;
    property PopupMenu;
    property PrinterProperties;
    property ScrollBars;
    property ShowHint default True;
    property SmoothScroll;
    property TabOrder;
    property TabStop;
    property Views;
    property Visible;

    property OnClick;
    property OnCompareCustom : TOvcDRVCompareCustomEvent
                   read FOnCompareCustom write FOnCompareCustom;
    property OnDetailPrint;
    property OnDragDrop;
    property OnDragOver;
    property OnFormatFloat : TOvcDRVFormatFloatEvent
                   read FOnFormatFloat write FOnFormatFloat;
    property OnGetCustomAsString : TOvcDRVGetCustomAsStringEvent
                   read FOnGetCustomAsString write FOnGetCustomAsString;
    property OnDblClick;
    property OnDrawViewField : TOvcDrawDViewFieldEvent
                   read FOnDrawViewField write FOnDrawViewField;
      {- Event generated by the report view for view fields that have
         their OwnerDraw property set to True}
    property OnDrawViewFieldEx : TOvcDrawDViewFieldExEvent
                   read FOnDrawViewFieldEx write FOnDrawViewFieldEx;
      {- Event generated by the report view for view fields that have
         their OwnerDraw property set to True}
    property OnEnumerate : TOvcDRVEnumEvent
                   read FOnEnumerate write FOnEnumerate;
    property OnEnter;
    property OnExtern;
    property OnFilter: TOvcDRVFilterEvent
                   read GetOnFilter write SetOnFilter;
      {- Event generated when the index is maintained for views that
         have a FilterIndex <> -1}
    property OnExit;
    property OnGetPrintHeaderFooter;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPrintStatus;
    property OnSelectionChanged;
    property OnSignalBusy;
    property OnSortingChanged;
    property OnStartDrag;
    property OnViewSelect;
  end;

implementation
const
  StreamSig : array[0..3] of AnsiChar = 'ODRD';

type
  PBoolean  = ^Boolean;
  PDateTime = ^TDateTime;

function CompareDWord(D1, D2 : DWord) : Integer;
begin
  if D1 < D2 then
    Result := -1
  else
  if D1 = D2 then
    Result := 0
  else
    Result := 1;
end;

{ TOvcDataRvField }

procedure TOvcDataRvField.Assign(Source: TPersistent);
begin
  if Source is TOvcDataRvField then begin
    DataType := TOvcDataRvField(Source).DataType;
    Format := TOvcDataRvField(Source).Format;
  end;
  inherited Assign(Source);
end;

procedure TOvcDataRvField.SetDataType(Value: TOvcDrDataType);
begin
  if Value <> FDataType then begin
    if TOvcDataReportView(OwnerReport).Items.Count > 0 then
      raise Exception.Create('It is not possible to change data types while the view contains data');
    FDataType := Value;
  end;
end;

{TOvcDataReportView}

constructor TOvcDataReportView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TOvcDataRvItems.Create(Self);
  if Classes.GetClass(TOvcDataRvField.ClassName) = nil then
    Classes.RegisterClass(TOvcDataRvField);
end;

destructor TOvcDataReportView.Destroy;
begin
  FItems.Clear;
  FItems.Free;
  inherited Destroy;
end;

function TOvcDataReportView.DoCompareCustom(FieldIndex: Integer;
  Data1, Data2: Pointer): Integer;
begin
  if not Assigned(FOnCompareCustom) then
    raise Exception.Create('OnCompareCustom not assigned');
  FOnCompareCustom(Self, FieldIndex, Data1, Data2, Result);
end;

function TOvcDataReportView.DoCompareFields(Data1, Data2: Pointer;
  FieldIndex: Integer) : Integer;
begin
  case TOvcDataRvField(Field[FieldIndex]).DataType of
  dtString :
    Result := StrIComp(
      TOvcDataRvItem(Data1).AsPChar[FieldIndex],
      TOvcDataRvItem(Data2).AsPChar[FieldIndex]
      );
  dtFloat :
    Result := CompareFloat(
      TOvcDataRvItem(Data1).InternalGetAsFloat(FieldIndex),
      TOvcDataRvItem(Data2).InternalGetAsFloat(FieldIndex)
      );
  dtDateTime :
    Result := CompareFloat(
      TOvcDataRvItem(Data1).InternalGetAsDateTime(FieldIndex),
      TOvcDataRvItem(Data2).InternalGetAsDateTime(FieldIndex)
      );
  dtInteger :
    Result := CompareInt(
      TOvcDataRvItem(Data1).InternalGetAsInteger(FieldIndex),
      TOvcDataRvItem(Data2).InternalGetAsInteger(FieldIndex)
      );
  dtBoolean :
    Result := CompareInt(
      ord(TOvcDataRvItem(Data1).InternalGetAsBoolean(FieldIndex)),
      ord(TOvcDataRvItem(Data2).InternalGetAsBoolean(FieldIndex))
      );
  dtDWord :
    Result := CompareDWord(
      TOvcDataRvItem(Data1).InternalGetAsDWord(FieldIndex),
      TOvcDataRvItem(Data2).InternalGetAsDWord(FieldIndex)
      );
  dtCustom :
    Result := DoCompareCustom(
      FieldIndex,
      TOvcDataRvItem(Data1).GetCustomFieldBuffer(FieldIndex),
      TOvcDataRvItem(Data2).GetCustomFieldBuffer(FieldIndex));
  else
    raise Exception.Create('Unsupported datatype');
  end;
end;

procedure TOvcDataReportView.DoDrawViewField(Canvas : TCanvas; Data : Pointer;
      Field : TOvcRvField; ViewField : TOvcRvViewField; TextAlign : Integer;
      IsSelected, IsGroup : Boolean;
      ViewFieldIndex : Integer; Rect : TRect; const Text, TruncText : string);
var
  P : PChar;
  DefaultDrawing : Boolean;
begin
  SaveFont.Assign(Canvas.Font);
  if assigned(FOnDrawViewFieldEx) then begin
    DefaultDrawing := True;
    FOnDrawViewFieldEx(Self, Canvas, Field, ViewField, TextAlign,
      IsSelected, IsGroup, Data, Rect, Text, TruncText, DefaultDrawing);
    if DefaultDrawing then begin
      P := PChar(TruncText);
      DrawText(Canvas.Handle, P, Strlen(P), Rect, TextAlign);
    end;
  end else
  if assigned(FOnDrawViewField) then
    FOnDrawViewField(Self, Canvas, Data, ViewFieldIndex, Rect, TruncText);
  Canvas.Font.Assign(SaveFont);
end;

procedure TOvcDataReportView.DoEnumEvent(Data: Pointer; var Stop: boolean;
  UserData: Pointer);
begin
  if assigned(FOnEnumerate) then
    FOnEnumerate(Self, Data, Stop, UserData);
end;

function TOvcDataReportView.DoFilter(View: TOvcAbstractRvView; Data: Pointer): Boolean;
//function TOvcDataReportView.DoFilter(Data: Pointer;
//  FilterIndex: Integer): Boolean;
begin
  if TOvcRvView(View).Filter <> '' then
    Result := inherited DoFilter(View, Data)
  else begin
    if (Owner <> nil) and (csDesigning in Owner.ComponentState) then
      Result := True
    else begin
      if (View.FilterIndex >= 0) and (not Assigned(FOnFilter)) then
        raise EOnFilterNotAsgnd.Create(SCOnFilterNotAssigned,0);
      Result := True;
      if Assigned(FOnFilter) then
        FOnFilter(Self, Data, View.FilterIndex, Result);
    end;
  end;
end;

function TOvcDataReportView.DoGetFieldValue(Data: Pointer;
  Field: Integer): Variant;
begin
  Result := TOvcDataRvItem(Data).Value[Field];
end;

function TOvcDataReportView.DoGetFieldAsFloat(Data: Pointer;
  Field: Integer) : Double;
var
  F: TOvcRvField;
begin
  F := Self.Field[Field];
  if F.Expression <> '' then
    Result := F.GetValue(Data)
  else
    {Result := TOvcDataRvItem(Data).AsFloat[Field];}
    { begin}
    case F.DataType of
    dtInteger :
      Result := TOvcDataRvItem(Data).InternalGetAsInteger(Field);
    dtDWord :
      Result := TOvcDataRvItem(Data).InternalGetAsDWord(Field);
    dtFloat :
      Result := TOvcDataRvItem(Data).InternalGetAsFloat(Field);
    else
      Result := 0;
    end;
    { end}
end;

function TOvcDataReportView.DoGetFieldAsString(Data: Pointer;
  FieldIndex: Integer): string;
begin
  Result := TOvcDataRvItem(Data).AsString[FieldIndex];
end;

{ rewritten}
function TOvcDataReportView.DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string;
var
  FieldIndex: Integer;
  D: Double;
begin
  FieldIndex := ViewField.Field.Index;
  if ViewField.Aggregate <> '' then
    D := ViewField.AggExp.GetValue(GroupRef)
  else
    D := Total(GroupRef, FieldIndex);
  if TOvcDataRvField(Field[FieldIndex]).CustomFormat
  and assigned(FOnFormatFloat) then begin
    Result := '';
    FOnFormatFloat(Self, FieldIndex, D, Result);
  end else
    Result := SysUtils.FormatFloat(
      TOvcDataRvField(Field[FieldIndex]).Format, D);
end;

procedure TOvcDataReportView.DoKeySearch(FieldIndex : Integer;const SearchString : string);
var
  SearchItem : TOvcDataRvItem;
begin
  if TOvcDataRvField(Field[FieldIndex]).DataType = dtString  then begin
    SearchItem := TOvcDataRvItem.Create(Self, nil, True);
    try
      SearchItem.AsString[FieldIndex] := SearchString;
      GotoNearest(SearchItem);
    finally
      SearchItem.Free;
    end;
  end;
end;

procedure TOvcDataReportView.Enumerate(UserData : Pointer);
{Enumerates all items.
 Calls OnEnumerate for each item. Does not return groups.}
begin
  if not Assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumNotAssigned,0);
  DoEnumerate(UserData);
end;

procedure TOvcDataReportView.EnumerateSelected(UserData : Pointer);
{Enumerates selected items when multiselect is enabled.
 Calls OnEnumSelected for each one. Does not return groups.}
begin
  if not MultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
  if not assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumSelectedNA,0);
  DoEnumerateSelected(UserData);
end;

procedure TOvcDataReportView.EnumerateEx(Backwards, SelectedOnly: Boolean;
  StartAfter: Pointer; UserData : Pointer);
begin
  if SelectedOnly and not MultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
  if not assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumSelectedNA,0);
  DoEnumerateEx(Backwards, SelectedOnly, StartAfter, UserData);
end;

function TOvcDataReportView.GetCurrentItem: TOvcDataRvItem;
begin
  Result := TOvcDataRvItem(inherited CurrentItem);
end;

function TOvcDataReportView.GetField(Index : Integer) : TOvcDataRvField;
begin
  Result := TOvcDataRvField(inherited GetField(Index));
end;

function TOvcDataReportView.GetFieldClassType : TOvcCollectibleClass;
begin
  Result := TOvcDataRvField;
end;

procedure TOvcDataReportView.Loaded;
begin
  inherited Loaded;
  if assigned(Items.PendingStream) then begin
    Items.LoadFromStream(Items.PendingStream);
    Items.PendingStream.Free;
    Items.PendingStream := nil;
  end;
end;

procedure TOvcDataReportView.SetCurrentItem(const Value: TOvcDataRvItem);
begin
  inherited CurrentItem := Value;
end;

function TOvcDataReportView.GetOnFilter: TOvcDRVFilterEvent;
begin
  Result := TOvcDRVFilterEvent(FOnFilter);
end;

procedure TOvcDataReportView.CountSelection(Sender : TObject; Data : TOvcDataRvItem; var Stop : Boolean; UserData : Pointer);
begin
  Boolean(UserData^) := True;
  Stop := True;
end;

function TOvcDataReportView.GetHaveSelection: Boolean;
var
  SaveEnumerator : TOvcDRVEnumEvent;
begin
  SaveEnumerator := OnEnumerate;
  Result := False;
  try
    OnEnumerate := CountSelection;
    DoEnumerateSelected(@Result);
  finally
    OnEnumerate := SaveEnumerator;
  end;
end;

procedure TOvcDataReportView.CountSelection2(Sender : TObject; Data : TOvcDataRvItem; var Stop : Boolean; UserData : Pointer);
begin
  inc(Integer(UserData^));
end;

function TOvcDataReportView.GetSelectionCount: Integer;
var
  SaveEnumerator : TOvcDRVEnumEvent;
begin
  SaveEnumerator := OnEnumerate;
  Result := 0;
  try
    OnEnumerate := CountSelection2;
    DoEnumerateSelected(@Result);
  finally
    OnEnumerate := SaveEnumerator;
  end;
end;

procedure TOvcDataReportView.SetOnFilter(const Value: TOvcDRVFilterEvent);
begin
  TOvcDRVFilterEvent(FOnFilter) := Value;
end;

function TOvcDataReportView.DoGetCustomAsString(FieldIndex: Integer;
  Data: Pointer): string;
begin
  if not assigned(FOnGetCustomAsString) then
    raise Exception.Create('OnGetCustomAsString not assigned');
  FOnGetCustomAsString(Self, FieldIndex, Data, Result);
end;

{ TOvcDataRvItem }

constructor TOvcDataRvItem.Create(AOwner: TOvcDataReportView; AOwnerList : TOvcDataRvItems; Temporary : Boolean);
begin
  FOwner := AOwner;
  FOwnerList := AOwnerList;
  Temp := Temporary;
  PreAllocate; {Pre-allocate record buffer}
  if not Temporary then
    if assigned(AOwner) and (AOwner is TOvcCustomReportView) then
      AOwner.AddDataPrim(Self);
  if assigned(AOwnerList) then
    AOwnerList.FItems.Add(Self);
end;

destructor TOvcDataRvItem.Destroy;
var
  IX : Integer;
begin
  if not Temp then
    if assigned(FOwner) and (not Assigned(FOwnerList) or not FOwnerList.ClearingAll) then
      FOwner.RemoveDataPrim(Self);
  ClearData;
  if assigned(FOwnerList) and not FOwnerList.ClearingAll then
    with FOwnerList.FItems do begin
      IX := IndexOf(Self);
      if IX <> -1 then
        Delete(IX);
    end;
  inherited Destroy;
end;

procedure TOvcDataRvItem.CheckType(Index : Integer; DataType : TOvcDRDataType);
begin
  if TOvcDataRvField(FOwner.Field[Index]).DataType <> DataType then
    raise Exception.Create('Type mismatch');
end;

procedure TOvcDataRvItem.Changed;
begin
  if not Temp then
    FOwner.ChangeDataPrim(Self);
end;

procedure TOvcDataRvItem.ClearData;
begin
  if DataBuffer <> nil then begin
    FreeMem(DataBuffer,DataBufferSize);
    DataBuffer := nil;
    DataBufferSize := 0;
    FreeMem(FieldIndexTable,FieldIndexSize);
    FieldIndexTable := nil;
    FreeMem(FieldSizeTable,FieldIndexSize);
    FieldSizeTable := nil;
    FieldIndexSize := 0;
  end;
end;

{ new}
procedure TOvcDataRvItem.PreAllocate;
var
  i, s, Offset: Integer;
begin
  ValidateData; {allocate field index and size tables}
  DataBufferSize := 0;
  Offset := 0;
  for i := 0 to FOwner.Fields.Count - 1 do begin
    case FOwner.Field[i].DataType of
    dtString :
      S := 0;
    dtFloat :
      S := sizeof(Extended);
    dtInteger :
      S := sizeof(Integer);
    dtDateTime :
      S := sizeof(TDateTime);
    dtBoolean :
      S := sizeof(Boolean);
    dtDWord :
      S := sizeof(DWord);
    else //dtCustom :
      S := 0;
    end;
    FieldIndexTable[i] := Offset;
    inc(Offset, S);
    inc(DataBufferSize, S);
    FieldSizeTable[i] := S;
  end;
  DataBuffer := AllocMem(DataBufferSize);
end;

procedure TOvcDataRvItem.ValidateData;
begin
  if FieldIndexSize <> FOwner.Fields.Count * sizeof(Integer) then begin
    ClearData;
    FieldIndexSize := FOwner.Fields.Count * sizeof(Integer);
    FieldSizeTable := AllocMem(FieldIndexSize);
    FieldIndexTable := AllocMem(FieldIndexSize);
  end;
end;

procedure TOvcDataRvItem.SetFieldSize(Index, NewSize : Integer);
  {-Changes:
    04/2011, AB: Modification to preserve the content of the field given by 'Index';
                 this has been done to simplify string-transformation in 'ReadFromStream' }
var
  i, fc, Offset, NewDataBufferSize, OldSize : Integer;
  NewDataBuffer : PByteArray;
  NewFieldIndexTable : PIntArray;
begin
  if FieldSize[Index] <> NewSize then begin
    NewDataBufferSize := 0;
    fc := FOwner.Fields.Count;
    ValidateData;
    for i := 0 to pred(fc) do
      if i <> Index then
        inc(NewDataBufferSize, FieldSize[i]);
    inc(NewDataBufferSize,NewSize);
    OldSize := FieldSizeTable^[Index];
    FieldSizeTable^[Index] := NewSize;
    GetMem(NewDataBuffer, NewDataBufferSize);
    GetMem(NewFieldIndexTable, FieldIndexSize);
    Offset := 0;
    for i := 0 to pred(fc) do begin
      NewFieldIndexTable^[i] := Offset;
      inc(Offset, FieldSizeTable^[i]);
    end;
    for i := 0 to pred(fc) do
      if FieldSizeTable^[i] > 0 then begin
        if i <> Index then
          move(DataBuffer^[FieldIndexTable^[i]],
               NewDataBuffer^[NewFieldIndexTable^[i]],
               FieldSizeTable^[i])
        else if OldSize>0 then
          move(DataBuffer^[FieldIndexTable^[i]],
               NewDataBuffer^[NewFieldIndexTable^[i]],
               MinI(OldSize,FieldSizeTable^[i]));
      end;

    FreeMem(DataBuffer, DataBufferSize);
    DataBuffer := NewDataBuffer;
    DataBufferSize := NewDataBufferSize;
    FreeMem(FieldIndexTable, FieldIndexSize);
    FieldIndexTable := NewFieldIndexTable;
  end;
end;

function TOvcDataRvItem.InternalGetAsBoolean(Index: Integer): Boolean;
{- get as Boolean, no type check}
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] = 0) then
    Result := False
  else
    Result := Boolean((@DataBuffer^[FieldIndexTable^[Index]])^);
end;

function TOvcDataRvItem.GetAsBoolean(Index: Integer): Boolean;
begin
  CheckType(Index, dtBoolean);
  Result := InternalGetAsBoolean(Index);
end;

function TOvcDataRvItem.InternalGetAsDateTime(Index : Integer): TDateTime;
{- get as date/time, no type check}
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] = 0) then
    Result := 0
  else
    Result := TDateTime((@DataBuffer^[FieldIndexTable^[Index]])^);
end;

function TOvcDataRvItem.GetAsDateTime(Index : Integer): TDateTime;
begin
  CheckType(Index, dtDateTime);
  Result := InternalGetAsDateTime(Index);
end;

function TOvcDataRvItem.InternalGetAsFloat(Index: Integer): Extended;
{-get float, no type check}
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] = 0) then
    Result := 0
  else
    Result := Extended((@DataBuffer^[FieldIndexTable^[Index]])^);
end;

function TOvcDataRvItem.GetAsFloat(Index: Integer): Extended;
begin
  case TOvcDataRvField(FOwner.Field[Index]).DataType of
  dtInteger :
    Result := InternalGetAsInteger(Index);
  dtDWord :
    Result := InternalGetAsDWord(Index);
  dtFloat :
    Result := InternalGetAsFloat(Index);
  else
    raise Exception.Create('Type mismatch');
  end;
end;

function TOvcDataRvItem.InternalGetAsInteger(Index: Integer): Integer;
{- get as Integer, no type check}
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] = 0) then
    Result := 0
  else
    Result := Integer((@DataBuffer^[FieldIndexTable^[Index]])^);
end;

function TOvcDataRvItem.GetAsInteger(Index: Integer): Integer;
begin
  CheckType(Index, dtInteger);
  Result := InternalGetAsInteger(Index);
end;

function TOvcDataRvItem.GetAsPChar(Index: Integer) : PChar;
const
  NullChar : Char = #0;
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] < 2) then
    Result := @NullChar
  else
    Result := @DataBuffer^[FieldIndexTable^[Index]];
end;

function TOvcDataRvItem.GetCustomFieldBuffer(Index: Integer): Pointer;
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] < 2) then
    Result := nil
  else
    Result := @DataBuffer^[FieldIndexTable^[Index]];
end;

function TOvcDataRvItem.GetAsString(Index: Integer): string;
var
  F : string;
begin
  case TOvcDataRvField(FOwner.Field[Index]).DataType of
  dtString :
    begin
      if FieldSize[Index] = 0 then
        Result := ''
      else begin
        SetLength(Result,((FieldSize[Index] div sizeof(char)) - 1)); {account for trailing #0}
        if FieldSize[Index] > sizeof(char) then
          move(DataBuffer^[FieldIndexTable^[Index]],Result[1],FieldSize[Index])
        else
          Result := '';
      end;
    end;
  dtFloat  :
    begin
      if TOvcDataRvField(FOwner.Field[Index]).CustomFormat
      and assigned(FOwner.FOnFormatFloat) then begin
        Result := '';
        FOwner.FOnFormatFloat(FOwner, Index, AsFloat[Index], Result);
      end else
        Result := SysUtils.FormatFloat(TOvcDataRvField(FOwner.Field[Index]).Format,AsFloat[Index]);
    end;
  dtInteger :
    begin
      f := Trim(TOvcDataRvField(FOwner.Field[Index]).Format);
      if f <> '' then
        Result := SysUtils.Format(f,[AsInteger[Index]])
      else
        Result := IntToStr(AsInteger[Index]);
    end;
  dtDateTime :
    if AsDateTime[Index] < 1.0 then
      Result := ''
    else
      Result := SysUtils.FormatDateTime(TOvcDataRvField(FOwner.Field[Index]).Format,AsDateTime[Index]);
  dtBoolean :
    if AsBoolean[Index] then
      Result := 'TRUE'
    else
      Result := 'FALSE';
  dtDWord :
    begin
      f := TOvcDataRvField(FOwner.Field[Index]).Format;
      if f <> '' then
        Result := SysUtils.Format(f,[AsDWord[Index]])
      else
        Result := IntToStr(AsDWord[Index]);
    end;
  dtCustom :
    Result := FOwner.DoGetCustomAsString(Index,
      GetCustomFieldBuffer(Index));
  end;
end;

function TOvcDataRvItem.GetValue(Index: Integer): Variant;
var
  F : string;
begin
  case TOvcDataRvField(FOwner.Field[Index]).DataType of
  dtString :
    begin
      if FieldSize[Index] = 0 then
        Result := ''
      else begin
        SetLength(F,((FieldSize[Index] div sizeof(char)) - 1)); {account for trailing #0}
        if FieldSize[Index] > sizeof(char) then
          move(DataBuffer^[FieldIndexTable^[Index]],F[1],FieldSize[Index])
        else
          F := '';
        Result := F;
      end;
    end;
  dtFloat  :
    Result := AsFloat[Index];
  dtInteger :
    Result := AsInteger[Index];
  dtDateTime :
    Result := AsDateTime[Index];
  dtBoolean :
    Result := AsBoolean[Index];
  dtDWord :
    Result := 1.0 * AsDWord[Index];
  dtCustom :
    Result := FOwner.DoGetCustomAsString(Index,
      GetCustomFieldBuffer(Index));
  end;
end;

procedure TOvcDataRvItem.SetValue(Index: Integer; const Value: Variant);
begin
  case TOvcDataRvField(FOwner.Field[Index]).DataType of
  dtString :
    AsString[Index] := Value;
  dtFloat  :
    AsFloat[Index] := Value;
  dtInteger :
    AsInteger[Index] := Value;
  dtDateTime :
    AsDateTime[Index] := Value;
  dtBoolean :
    AsBoolean[Index] := Value;
  dtDWord :
    AsDWord[Index] := Value;
  {!!! custom}
  end;
end;

function TOvcDataRvItem.InternalGetAsDWord(Index: Integer): DWord;
{- get as DWord, no type check}
begin
  if (FieldSizeTable = nil) or (FieldSizeTable^[Index] = 0) then
    Result := 0
  else
    Result := DWord((@DataBuffer^[FieldIndexTable^[Index]])^);
end;

function TOvcDataRvItem.GetAsDWord(Index: Integer): DWord;
begin
  CheckType(Index, dtDWord);
  Result := InternalGetAsDWord(Index);
end;

function TOvcDataRvItem.GetFieldSize(Index: Integer): Integer;
begin
  if FieldSizeTable <> nil then begin
    if Index >= FOwner.Fields.Count then
      raise Exception.Create('Field index out of range');
    Result := FieldSizeTable^[Index];
  end else
    Result := 0;
end;

function TOvcDataRvItem.GetSelected: Boolean;
begin
  Result := FOwner.IsSelected[FOwner.OffsetOfData[Self]];
end;

procedure TOvcDataRvItem.SetAsBoolean(Index: Integer;
  const Value: Boolean);
begin
  if Value <> AsBoolean[Index] then begin
    {CheckType(Index, dtBoolean);} {redundant Get just checked it}
    Assert(FieldSize[Index] = sizeof(Boolean));
    {FieldSize[Index] := sizeof(Boolean);}
    {move(Value,DataBuffer^[FieldIndexTable^[Index]],sizeof(Boolean));}
    PBoolean(@DataBuffer^[FieldIndexTable^[Index]])^ := Value;
    Changed;
  end;
end;

procedure TOvcDataRvItem.SetAsDateTime(Index : Integer; const Value: TDateTime);
begin
  if Value <> AsDateTime[Index] then begin
    {CheckType(Index, dtDateTime);} {redundant Get just checked it}
    Assert(FieldSize[Index] = sizeof(TDateTime));
    {FieldSize[Index] := sizeof(TDateTime);}
    {move(Value,DataBuffer^[FieldIndexTable^[Index]],sizeof(TDateTime));}
    PDateTime(@DataBuffer^[FieldIndexTable^[Index]])^ := Value;
    Changed;
  end;
end;

procedure TOvcDataRvItem.SetAsFloat(Index: Integer; const Value: Extended);
begin
  if Value <> AsFloat[Index] then begin
    {CheckType(Index, dtFloat);} {redundant Get just checked it}
    Assert(FieldSize[Index] = sizeof(Extended));
    {FieldSize[Index] := sizeof(Extended);
    {move(Value,DataBuffer^[FieldIndexTable^[Index]],sizeof(Extended));}
    PExtended(@DataBuffer^[FieldIndexTable^[Index]])^ := Value;
    Changed;
  end;
end;

procedure TOvcDataRvItem.SetAsInteger(Index: Integer;
  const Value: Integer);
begin
  if Value <> AsInteger[Index] then begin
    {CheckType(Index, dtInteger);} {redundant Get just checked it}
    Assert(FieldSize[Index] = sizeof(Integer));
    {FieldSize[Index] := sizeof(Integer);}
    {move(Value,DataBuffer^[FieldIndexTable^[Index]],sizeof(Integer));}
    PInteger(@DataBuffer^[FieldIndexTable^[Index]])^ := Value;
    Changed;
  end;
end;

procedure TOvcDataRvItem.SetAsString(Index: Integer;
  const Value: string);
var
  E : Extended;
  Err : Integer;
begin
  case TOvcDataRvField(FOwner.Field[Index]).DataType of
  dtString :
    if Value <> AsString[Index] then begin
      FieldSize[Index] := (length(Value) +  1) * sizeof(char);
      if FieldSize[Index] > sizeof(char) then
        move(Value[1],DataBuffer^[FieldIndexTable^[Index]], FieldSize[Index]);
      Changed;
    end;
  dtFloat  :
    begin
      Val(Value,E,Err);
      if Err = 0 then
        SetAsFloat(Index, E)
      else
        SetAsFloat(Index, 0);
    end;
  dtInteger :
    begin
      Val(Value,E,Err);
      if Err = 0 then
        SetAsInteger(Index, round(E))
      else
        SetAsInteger(Index, 0);
    end;
  dtDateTime :
    SetAsDateTime(Index, StrToDateTime(Value));
  dtBoolean :
    SetAsBoolean(Index, CompareText(Value, 'TRUE') = 0);
  dtDWord :
    begin
      Val(Value,E,Err);
      if Err = 0 then
        SetAsDWord(Index, round(E))
      else
        SetAsDWord(Index, 0);
    end;
  end;
end;

procedure TOvcDataRvItem.SetAsDWord(Index: Integer;
  const Value: DWord);
begin
  if Value <> AsDWord[Index] then begin
    {CheckType(Index, dtDWord);} {redundant Get just checked it}
    Assert(FieldSize[Index] = sizeof(DWord));
    {FieldSize[Index] := sizeof(DWord);}
    {move(Value, DataBuffer^[FieldIndexTable^[Index]], sizeof(DWord));}
    PDWord(@DataBuffer^[FieldIndexTable^[Index]])^ := Value;
    Changed;
  end;
end;

procedure TOvcDataRvItem.SetCustom(Index: Integer; const Value; Size: DWord);
begin
  CheckType(Index, dtCustom);
  FieldSize[Index] := Size;
  move(Value, DataBuffer^[FieldIndexTable^[Index]], Size);
  Changed;
end;

procedure TOvcDataRvItem.SetSelected(Value: Boolean);
begin
  FOwner.IsSelected[FOwner.OffsetOfData[Self]] := Value;
end;

procedure TOvcDataRvItem.ReadFromStream(Stream: TStream);
var
  FS : Integer;
  i : Integer;
  j, k1, k2 : Integer;
begin
  for i := 0 to pred(FOwner.Fields.Count) do begin
    Stream.Read(FS, sizeof(FS));
    if FS <> 0 then begin
      FieldSize[i] := FS;
      Stream.Read(DataBuffer^[FieldIndexTable^[i]], FS);
      if FOwner.Field[i].DataType = dtString then begin
        { Beware: We might have just read an old fashioned Ansi-String from the
          stream (e.g data from an older *.dfm file). We have to detect this and
          transform the data if necessary. }
        j := FieldIndexTable^[i];
        if ((FS mod 2) <> 0) or (DataBuffer^[j+FS-2]<>0) then begin
          { We have an Ansi-String in DataBuffer: Double the field-size and transform it
            as follows:
                               j   j+1  j+2  j+3  j+4  j+5  j+6  j+7
            DataBuffer (old)  65   66   67    0
            DataBuffer (new)  65    0   66    0   67   0     0    0 }
          k1 := j+FS-1;
          FS := 2*FS;
          k2 := j+FS-1;
          FieldSize[i] := FS;
          while k1>=j do begin
            DataBuffer^[k2] := 0;
            Dec(k2);
            DataBuffer^[k2] := DataBuffer^[k1];
            Dec(k2);
            Dec(k1);
          end;
        end;
      end;
    end;
  end;
end;

procedure TOvcDataRvItem.WriteToStream(Stream: TStream);
var
  FS : Integer;
  i : Integer;
begin
  for i := 0 to pred(FOwner.Fields.Count) do begin
    FS := FieldSize[i];
    Stream.Write(FS, sizeof(FS));
    if FS <> 0 then
      Stream.Write(DataBuffer^[FieldIndexTable^[i]], FS);
  end;
end;

procedure TOvcDataRvItem.Assign(Source: TOvcDataRvItem);
var
  i : Integer;
  Target: TOvcDataRvField;
begin
  for i := 0 to Source.FOwner.Fields.Count - 1 do begin
    Target := TOvcDataRvField(FOwner.Fields.ItemByName(Source.FOwner.Field[i].Name));
    if Target <> nil then
      Value[Target.Index] := Source.Value[i];
  end;
end;

{ TOvcDataRvItems }

function TOvcDataRvItems.Add: TOvcDataRvItem;
begin
  Result := TOvcDataRvItem.Create(FOwner, Self, False);
end;

procedure TOvcDataRvItems.Clear;
var
  i : Integer;
begin
  ClearingAll := True;
  try
    for i := pred(FItems.Count) downto 0 do
      TOvcDataRvItem(FItems[i]).Free;
  finally
    ClearingAll := False;
    if assigned(FOwner) then
      FOwner.ClearIndex;
  end;
  FItems.Clear;
end;

constructor TOvcDataRvItems.Create(AOwner : TOvcDataReportView);
begin
  FOwner := AOwner;
  FItems := TList.Create;
end;

procedure TOvcDataRvItems.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Data', LoadFromStream, SaveToStream, FItems.Count > 0);
end;

destructor TOvcDataRvItems.Destroy;
begin
  FItems.Clear;
  FItems.Free;
  inherited Destroy;
end;

function TOvcDataRvItems.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TOvcDataRvItems.GetItem(Index: Integer): TOvcDataRvItem;
begin
  Result := FItems[Index];
end;

procedure TOvcDataRvItems.LoadFromStream(Stream: TStream);
var
  p, i, RecordCount : Integer;
  SigTest : array[0..3] of AnsiChar;
begin
  if assigned(FOwner) and (csLoading in FOwner.ComponentState) then begin
    PendingStream := TMemoryStream.Create;
    p := Stream.Position;
    Stream.Read(SigTest, sizeof(SigTest));
    Stream.Read(i, sizeof(i));
    Stream.Seek(p, soFromBeginning);
    PendingStream.CopyFrom(Stream, i + 4);
    PendingStream.Position := 0;
  end else begin
    Stream.Read(SigTest, sizeof(SigTest));
    if SigTest <> StreamSig then
      raise Exception.Create('Bad stream signature in report view data');
    Stream.Read(i, sizeof(i));
    Stream.Read(RecordCount, SizeOf(RecordCount));
    FOwner.BeginUpdate;
    try
      for i := 0 to pred(RecordCount) do
        Add.ReadFromStream(Stream);
    finally
      FOwner.EndUpdate;
    end;
  end;
end;

procedure TOvcDataRvItems.SaveToStream(Stream: TStream);
var
  p, i, RecordCount : Integer;
begin
  Stream.Write(StreamSig, sizeof(StreamSig));
  RecordCount := FItems.Count;
  p := Stream.Position;
  Stream.Write(RecordCount, sizeof(RecordCount)); {place holder}
  Stream.Write(RecordCount, sizeof(RecordCount));
  for i := 0 to pred(RecordCount) do
    Item[i].WriteToStream(Stream);
  i := Stream.Position - p;
  Stream.Seek(p, soFromBeginning);
  Stream.Write(i, sizeof(i));
end;

procedure TOvcDataRvItems.Assign(Source: TPersistent);
var
  MemoryStream : TMemoryStream;
begin
  if Source is TOvcDataRvItems then begin
    Clear;
    MemoryStream := TMemoryStream.Create;
    try
      TOvcDataRvItems(Source).SaveToStream(MemoryStream);
      MemoryStream.Seek(0, 0);
      LoadFromStream(MemoryStream);
    finally
      MemoryStream.Free;
    end;
  end else
    inherited Assign(Source);
end;

end.


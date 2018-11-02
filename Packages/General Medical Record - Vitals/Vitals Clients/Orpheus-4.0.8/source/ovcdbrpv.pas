{*********************************************************}
{*                  OVCDBRPV.PAS 4.06                    *}
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

{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}
{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}

unit ovcdbrpv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  DB, OvcBase, OvcRVIdx, OvcRptVw, OvcDlm, OvcConst, OvcExcpt;

type
  TOvcDbReportView = class;
  TOvcDbRvDataLink = class(TDataLink)
  protected {private }
    {property variables}
    FFieldCount   : Integer;
    FFieldMap     : Pointer;
    FFieldMapSize : Integer;
    FInUpdateData : Boolean;
    FMapBuilt     : Boolean;
    FModified     : Boolean;
    FReportView   : TOvcDbReportView;

    {property methods}
    //function GetDefaultFields : Boolean;
    //function GetFields(Index : Integer) : TField;

  protected
    procedure ActiveChanged;
      override;
    procedure UpdateData;
      override;
    procedure DataSetChanged;
      override;
    procedure DataSetScrolled(Distance: Integer);
      override;
    procedure LayoutChanged;
      override;
    procedure RecordChanged(Field : TField);
      override;
  public
    constructor Create(AReportView : TOvcDbReportView);

    {properties}
    //property DefaultFields : Boolean
    //  read GetDefaultFields;
    property FieldCount : Integer
      read FFieldCount;
    //property Fields[Index : Integer] : TField
    //  read GetFields;
  end;

  TOvcDbRvField = class(TOvcRvField)
  

  protected
  published
    {inherited properties}
    property Alignment stored false;
    property Caption stored false;
    property CanSort stored false;
    property DefaultPrintWidth stored false;
    property DefaultWidth stored false;

  end;

  TOvcDbRVEnumEvent =
    procedure(Sender : TObject; var Stop : Boolean; UserData : Pointer) of object;
    {- Enumerator method type. Stop defaults to False. If changed to True by the
       event, the enumeration terminates.}

  TOvcDbReportView = class(TOvcCustomReportView)
  protected
    DataList      : TList;
    FieldList     : TList;
    DCacheList    : TList;
    FDataLink     : TOvcDbRvDataLink; {link to db data fields}
    FKeySearch    : Boolean;
    FOnEnumerate  : TOvcDbRVEnumEvent;
    FSearchString : string;
    InMove        : Integer;
    FUseRecordCount : Boolean;
    FRefreshOnMove : Boolean;
    FSyncOnOwnerDraw: Boolean;
    procedure ActiveChanged;
    procedure BindViews;
    procedure BuildFieldTable;
    procedure ClearAll;
    procedure ClearBindings;
    procedure ClearDataList;
    procedure ClearTableFields;
    procedure Click; override;
    function CreateListBox: TOvcRVListBox; override;
    function CreateValidFieldName(const FieldName : string) : string;
    procedure DataSetChanged;
    procedure DataSetScrolled;
    procedure DblClick; override;
    procedure DoBusy(SetOn : Boolean); override;
    function DoCompareFields(Data1, Data2 : Pointer; FieldIndex : Integer) : Integer; override;
    procedure DoDrawViewField(Canvas : TCanvas; Data : Pointer;
      Field : TOvcRvField; ViewField : TOvcRvViewField; TextAlign : Integer;
      IsSelected, IsGroup : Boolean;
      ViewFieldIndex : Integer; Rect : TRect; const Text, TruncText : string); override;
    function DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string; override;
    procedure DoDetail(Data: Pointer); override;

    procedure DoEnumEvent(Data : Pointer; var Stop : boolean; UserData : Pointer); override;
    function DoGetFieldAsFloat(Data : Pointer; FieldIndex : Integer) : double; override;
    function DoGetFieldAsString(Data : Pointer; FieldIndex : Integer) : string; override;
    function DoGetFieldValue(Data: Pointer; Field: Integer) : Variant; override;

    procedure DoKeySearch(FieldIndex : Integer; const SearchString : string); override;
    function GetDataSource : TDataSource;
    function GetFieldClassType : TOvcCollectibleClass; override;
    function InternalRecordCount : Integer;
    procedure Loaded; override;
    procedure MoveDataPointer(P : Pointer);
    procedure UpdateCurrentSelection;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure RecordChanged;
    procedure ReloadData;
    procedure SetDataSource(Value : TDataSource);
    procedure SetName(const NewName : TComponentName); override;
    {internal properties}
    property DataLink : TOvcDbRvDataLink
                       read FDataLink;
  public
    procedure AssignStructure(Source: TOvcCustomReportView); override;
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure Enumerate(UserData : Pointer); override;
      {- Enumerate all items in the view. Pass UserData to OnEnumerate}
    procedure EnumerateSelected(UserData : Pointer); override;
    procedure EnumerateEx(Backwards, SelectedOnly: Boolean; StartAfter: Pointer;
      UserData : Pointer); override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

  published
    property Controller; {must be first}
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;
    property SyncOnOwnerDraw: Boolean
      read FSyncOnOwnerDraw write FSyncOnOwnerDraw default False;

  {inherited properties}
  published
    property ActiveView;
    property Align;
    property AutoCenter;
    property Anchors;
    property Constraints;
    property DragKind;
    property BorderStyle;
    property Ctl3D;
    property ColumnResize;
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
    property KeyTimeout;
    property MultiSelect;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint default False;
    property PopupMenu;
    property PrinterProperties;
    property RefreshOnMove : Boolean
      read FRefreshOnMove write FRefreshOnMove default True;
    property ScrollBars;
    property ShowHint default True;
    property SmoothScroll;
    property TabOrder;
    property TabStop;
    property UseRecordCount : Boolean
      read FUseRecordCount write FUseRecordCount default False;
    property Views;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDetailPrint;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawViewField;
    property OnDrawViewFieldEx;
    property OnEnter;
    property OnEnumerate : TOvcDbRVEnumEvent
                   read FOnEnumerate write FOnEnumerate;
      {- Event generated for each item when the Enumerate method is
         called}
    property OnExit;
    property OnExtern;
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

uses
  ovcstr, OvcFormatSettings;

const
  CacheSize = 256;
  {MaxRecords = 16384;}

type
  TOvcDbRVListBox = class(TOvcRVListBox)
  protected
    SavedDataPointer: Pointer;
    procedure Paint; override;
  end;

constructor TOvcDbRvDataLink.Create(AReportView : TOvcDbReportView);
begin
  inherited Create;

  FReportView := AReportView;
end;

procedure TOvcDbRvDataLink.ActiveChanged;
begin
  FReportView.ActiveChanged;
end;

procedure TOvcDbRvDataLink.UpdateData;
begin
  FReportView.ReloadData;
end;

procedure TOvcDbRvDataLink.DataSetChanged;
begin
  FReportView.DatasetChanged;
end;

procedure TOvcDbRvDataLink.DataSetScrolled(Distance: Integer);
begin
  FReportView.DatasetScrolled;
end;

procedure TOvcDbRvDataLink.RecordChanged(Field : TField);
begin
end;

procedure TOvcDbRvDataLink.LayoutChanged;
begin
  FReportView.ClearAll;
  FReportView.BuildFieldTable;
end;

{
function TOvcDbRvDataLink.GetFields(Index : Integer) : TField;
begin
  if (Index < DataSet.FieldCount) and (Index >= 0) then
    Result := DataSet.Fields[Index]
  else
    raise Exception.Create('Invalid Field Index');
end;
}

{
function TOvcDbRvDataLink.GetDefaultFields : Boolean;
begin
  Result := True;

  if DataSet <> nil then
    Result := DataSet.DefaultFields;
end;
}

procedure TOvcDbReportView.ActiveChanged;
begin
  if (FDataLink.DataSet = nil) or not FDataLink.DataSet.Active then begin
    ClearAll;
    if not (csDestroying in ComponentState) then
      BuildFieldTable;
  end else
    BuildFieldTable;
end;

procedure TOvcDbReportView.AssignStructure(Source: TOvcCustomReportView);
{- replace all fields and views from another report view}
begin
  if not (Source is TOvcDbReportView) then
    raise Exception.Create(Source.Name + ' is not compatible with TOvcDbReportView');
  ClearAll;
  DelayedBinding := True;
  Name := Source.Name;
  DataSource := TOvcDbReportView(Source).DataSource;
  {copy views from source}
  Views.Assign(Source.Views);
  BindViews;
end;

procedure TOvcDbReportView.BindViews;
var
  i,j : Integer;
  S : string;
begin
  DelayedBinding := False;
  for i := 0 to pred(Views.Count) do
    with View[i] do
      for j := 0 to pred(ViewFields.Count) do
        ViewField[j].FieldName := ViewField[j].FieldName;
  if ActiveView <> '' then begin
    S := ActiveView;
    ActiveView := '';
    ActiveView := S;
  end;
end;

procedure TOvcDbReportView.ClearTableFields;
var
  i: Integer;
begin
  for i := Fields.Count - 1 downto 0 do
    if Field[i].Expression = '' then
      Field[i].Free;
end;

procedure TOvcDbReportView.BuildFieldTable;
var
  ColCount : Integer;
  Fld      : TField;
  Col      : TOvcDbRvField;
  i        : Integer;
begin
  FieldList.Clear;
  DelayedBinding := True;
  //Fields.Clear;
  ClearTableFields;
  if (FDataLink.DataSet = nil) then exit;
  try
    for i := 0 to pred(DCacheList.Count) do
      TOvcLiteStringCache(DCacheList[i]).Clear;
    for i := 0 to pred(DCacheList.Count) do
      TObject(DCacheList[i]).Free;
    DCacheList.Clear;
    ColCount := FDataLink.DataSet.FieldCount;
    for i := 0 to pred(ColCount) do begin
      Fld := FDatalink.DataSet.Fields[I];
      {FieldList.Add(Fld);}
      if Assigned(Fld)
      and (Fld.DataType in [ftString, ftSmallint, ftInteger, ftWord,
                            ftBoolean, ftFloat, ftCurrency, ftDate, ftTime,
                            ftDateTime, ftAutoInc, ftWideString,ftLargeint]) then begin
        FieldList.Add(Fld);
        Col := TOvcDbRvField(Fields.Add);
        Col.Name := CreateValidFieldName(Name+Fld.FieldName);
        Col.Caption := Fld.DisplayLabel;
        Col.Alignment := Fld.Alignment;
        Col.CanSort := True;
        case Fld.DataType of
        ftString :
          Col.DataType := dtString;
        ftSmallint,
        ftInteger,
        ftWord,
        ftAutoInc :
          Col.DataType := dtInteger;
        ftBoolean :
          Col.DataType := dtBoolean;
        ftFloat,
        ftCurrency,
        ftLargeInt,
        ftBCD :
          Col.DataType := dtFloat;
        ftDate,
        ftTime,
        ftDateTime :
          Col.DataType := dtDateTime;
        else
          Col.DataType := dtCustom;
          Col.NoDesign := True;
        end;

        if HandleAllocated then
          Col.DefaultWidth := Fld.DisplayWidth * Canvas.TextWidth('0')
        else
          Col.DefaultWidth := Fld.DisplayWidth * Screen.Forms[0].Canvas.TextWidth('0')
      end;
      DCacheList.Add(TOvcLiteStringCache.Create(CacheSize));
    end;
      if (FDataLink.DataSet <> nil) and FDataLink.DataSet.Active then
        BindViews; {resolve field references from views and activate current view (if any)}
    if (FDataLink.DataSet <> nil) and FDataLink.DataSet.Active then
      ReloadData;
  except
    ClearAll;
    raise;
  end;
end;

procedure TOvcDbReportView.ClearAll;
var
  i : Integer;
begin
  FRVListBox.NumItems := 0;
  {FCurrentView := nil;}
  DelayedBinding := True;
  ClearIndex;
  ClearBindings;
  //Fields.Clear;
  ClearTableFields;
  for i := 0 to pred(DCacheList.Count) do
    TOvcLiteStringCache(DCacheList[i]).Clear;
  FieldList.Clear;
  ClearDataList;
  {RVListBox.NumItems := 0;}
  {ClearIndexList;}
end;

procedure TOvcDbReportView.ClearBindings;
var
  i,j : Integer;
begin
  for i := 0 to pred(Views.Count) do
    with View[i] do
      for j := 0 to pred(ViewFields.Count) do
        ViewField[j].ClearField;
end;

procedure TOvcDbReportView.ClearDataList;
begin
  DataList.Clear;
end;

procedure TOvcDbReportView.MoveDataPointer(P : Pointer);
begin
  inc(InMove);
  try
    FDataLink.ActiveRecord := Integer(P) - 1;
  finally
    dec(InMove);
  end;
end;

procedure TOvcDbReportView.UpdateCurrentSelection;
begin
  if RefreshOnMove then begin
    inc(InMove);
    try
      FDatalink.DataSet.Refresh;
    finally
      dec(InMove);
    end;
  end;
end;

procedure TOvcDbReportView.Click;
begin
  if CurrentItem <> nil then begin
    MoveDataPointer(CurrentItem);
    UpdateCurrentSelection;
  end;
  inherited Click;
end;

constructor TOvcDbReportView.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  if Classes.GetClass(TOvcDbRvField.ClassName) = nil then
    Classes.RegisterClass(TOvcDbRvField);
  DelayedBinding := True; {Don't bind view fields until the database is opened}
  FFields.Stored := False;
  FFields.ReadOnly := True;
  FDataLink := TOvcDbRvDataLink.Create(Self);
  DataList := TList.Create;
  FieldList := TList.Create;
  DCacheList := TList.Create;
  KeySearch := True;
  RefreshOnMove := True;
end;

function TOvcDbReportView.CreateValidFieldName(const FieldName : string) : string;
var
  i : Integer;
begin
  if CharInSet(FieldName[1], ['A'..'Z','a'..'z']) then
    Result := FieldName[1]
  else
    Result := '_';
  for i := 2 to length(FieldName) do
    if CharInSet(FieldName[i], ['A'..'Z','a'..'z','0'..'9']) then
      Result := Result + FieldName[i]
    else
      Result := Result + '_';
  repeat
    for i := 0 to pred(Fields.Count) do
      if Field[i].Name = Result then begin
        Result := Result + '_1';
        continue;
      end;
  until True;
end;

destructor TOvcDbReportView.Destroy;
var
  i : Integer;
begin
  ClearDataList;
  DataList.Free;
  FieldList.Free;
  for i := 0 to pred(DCacheList.Count) do
    TObject(DCacheList[i]).Free;
  DCacheList.Free;
  inherited Destroy;
  FDataLink.Free;
end;

procedure TOvcDbReportView.DblClick;
begin
  if CurrentItem <> nil then begin
    MoveDataPointer(CurrentItem);
    UpdateCurrentSelection;
    inherited DblClick;
  end;
end;

procedure TOvcDbReportView.DoBusy;
begin
  if not LockUpdate then
    if assigned(FOnSignalBusy) then
      FOnSignalBusy(Self,SetOn)
    else
      if SetOn then
        Screen.Cursor := crHourglass
      else
        Screen.Cursor := crDefault;
end;

function TOvcDbReportView.DoCompareFields(Data1, Data2 : Pointer; FieldIndex : Integer) : Integer;
var
  S1,S2 : string;
  I1,I2 : Integer;
  B1,B2 : Boolean;
  F1,F2 : double;
  ActiveRecord: Integer;
begin
  result := 0;
  ActiveRecord := FDataLink.ActiveRecord;
  try
    case TField(FieldList[FieldIndex]).DataType of
    ftWideString, ftString :
      begin
        if FKeySearch and (Data1 = Pointer($FFFFFFFF)) then
          S1 := FSearchString
        else begin
          MoveDataPointer(Data1);
          S1 := TField(FieldList[FieldIndex]).AsString;
        end;
        if FKeySearch and (Data2 = Pointer($FFFFFFFF)) then
          S2 := FSearchString
        else begin
          MoveDataPointer(Data2);
          S2 := TField(FieldList[FieldIndex]).AsString;
        end;
        Result := CompareText(S1,S2);
      end;
    ftSmallint, ftInteger, ftWord, ftAutoInc:
      begin
        if FKeySearch
        and ((Data1 = Pointer($FFFFFFFF))
        or (Data2 = Pointer($FFFFFFFF))) then
          Result := 0
        else begin
          MoveDataPointer(Data1);
          I1 := TField(FieldList[FieldIndex]).AsInteger;
          MoveDataPointer(Data2);
          I2 := TField(FieldList[FieldIndex]).AsInteger;
          Result := CompareInt(I1,I2);
        end;
      end;
    ftBoolean :
      begin
        if FKeySearch
        and ((Data1 = Pointer($FFFFFFFF))
        or (Data2 = Pointer($FFFFFFFF))) then
          Result := 0
        else begin
          MoveDataPointer(Data1);
          B1 := TField(FieldList[FieldIndex]).AsBoolean;
          MoveDataPointer(Data2);
          B2 := TField(FieldList[FieldIndex]).AsBoolean;
          if B1 and not B2 then
            Result := -1
          else
          if B2 and not B1 then
            Result := 1
          else
            Result := 0;
        end;
      end;
    ftFloat,
    ftCurrency,
    ftLargeInt,
    ftDate,
    ftTime,
    ftDateTime :
      begin
        if FKeySearch
        and ((Data1 = Pointer($FFFFFFFF))
        or (Data2 = Pointer($FFFFFFFF))) then
          Result := 0
        else begin
          MoveDataPointer(Data1);
          F1 := TField(FieldList[FieldIndex]).AsFloat;
          MoveDataPointer(Data2);
          F2 := TField(FieldList[FieldIndex]).AsFloat;
          Result := CompareFloat(F1,F2);
        end;
      end;
    else
      raise Exception.CreateFmt('Unsupported data type:%d',
        [ord(TField(FieldList[FieldIndex]).DataType)]);
    end;
  finally
    FDataLink.ActiveRecord := ActiveRecord;
  end;
end;

procedure TOvcDbReportView.DoEnumEvent(Data: Pointer; var Stop: boolean;
  UserData: Pointer);
begin
  if assigned(FOnEnumerate) then begin
    MoveDataPointer(Data);
    UpdateCurrentSelection;
    FOnEnumerate(Self, Stop, UserData);
  end;
end;

function TOvcDbReportView.DoGetFieldAsFloat(Data : Pointer; FieldIndex : Integer) : double;
begin
  case TField(FieldList[FieldIndex]).DataType of
  ftSmallint, ftInteger, ftWord, ftFloat, ftLargeInt, ftCurrency, ftAutoInc:;
  else
    Result := 0;
    exit;
  end;
  MoveDataPointer(Data);
  if TField(FieldList[FieldIndex]).IsNull then
    Result := 0
  else
    Result := TField(FieldList[FieldIndex]).AsFloat;
end;

function TOvcDbReportView.DoGetFieldAsString(Data : Pointer; FieldIndex : Integer) : string;
begin
  if not TOvcLiteStringCache(DCacheList[FieldIndex]).GetValue(Data,Result) then begin
    MoveDataPointer(Data);
    if TField(FieldList[FieldIndex]).IsNull then
      Result := ''
    else
      Result := TField(FieldList[FieldIndex]).DisplayText;
    TOvcLiteStringCache(DCacheList[FieldIndex]).AddValue(Data,Result);
  end;
end;

function TOvcDbReportView.DoGetFieldValue(Data: Pointer; Field: Integer) : Variant;
begin
  MoveDataPointer(Data);
  if TField(FieldList[Field]).IsNull then
    Result := varNull
  else
    Result := TField(FieldList[Field]).AsVariant;
end;

function TOvcDbReportView.DoGetGroupString(ViewField : TOvcRvViewField; GroupRef : TOvcRvIndexGroup) : string;
var
  D : double;
  FmtStr: string;
  FloatFormat : TFloatFormat;
  Digits : Integer;
  F : TField;
  FieldIndex: Integer;
begin
  FieldIndex := ViewField.Field.Index;
  D := Total(GroupRef, FieldIndex);
  F := TField(FieldList[FieldIndex]);
  if F is TFloatField then
    with TFloatField(F) do begin
      FmtStr := DisplayFormat;
      if FmtStr = '' then begin
        if Currency or (DataType = ftCurrency) then begin
          FloatFormat := ffCurrency;
          Digits := FormatSettings.CurrencyDecimals;
        end else begin
          FloatFormat := ffGeneral;
          Digits := 0;
        end;
        Result := FloatToStrF(D, FloatFormat, Precision, Digits);
      end else
        Result := FormatFloat(FmtStr, D);
    end
  else
  if F is TIntegerField then
    Result := IntToStr(Round(D))
  else
    Result := '';
  if assigned(F.OnGetText) then
    F.OnGetText(F, Result, True);
end;

procedure TOvcDbReportView.DoKeySearch(FieldIndex : Integer; const SearchString : string);
begin
  if (TField(FieldList[FieldIndex]).DataType = ftString) or (TField(FieldList[FieldIndex]).DataType = ftWideString) then
  begin
    FKeySearch := True;
    FSearchString := SearchString;
    try
      GotoNearest(Pointer($FFFFFFFF));
    finally
      FKeySearch := False;
    end;
  end;
end;

procedure TOvcDbReportView.Enumerate(UserData : Pointer);
{Enumerates all items.
 Calls OnEnumerate for each item. Does not return groups.}
begin
  if not Assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumNotAssigned,0);
  DoEnumerate(UserData);
end;

procedure TOvcDbReportView.EnumerateSelected(UserData : Pointer);
{Enumerates all items.
 Calls OnEnumerate for each item. Does not return groups.}
begin
  if not Assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumNotAssigned,0);
  inc(InMove);
  try
    DoEnumerateSelected(UserData);
  finally
    dec(InMove);
  end;
end;

procedure TOvcDbReportView.EnumerateEx(Backwards, SelectedOnly: Boolean;
  StartAfter: Pointer; UserData : Pointer);
begin
  if SelectedOnly and not MultiSelect then
    raise ENotMultiSelect.Create(SCNotMultiSelect,0);
  if not assigned(FOnEnumerate) then
    raise EReportViewError.Create(SCOnEnumSelectedNA,0);
  DoEnumerateEx(Backwards, SelectedOnly, StartAfter, UserData);
end;

function TOvcDbReportView.GetDataSource : TDataSource;
begin
  Result := nil;
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource;
end;

function TOvcDbReportView.GetFieldClassType : TOvcCollectibleClass;
begin
  Result := TOvcDbRvField;
end;

function TOvcDbReportView.InternalRecordCount : Integer;
var
  P: Pointer;
begin
  if UseRecordCount then
    Result := DataSource.DataSet.RecordCount
  else begin
    Result := 0;
    P := DataSource.DataSet.GetBookmark;
    DataSource.DataSet.DisableControls;
    try
      DataSource.DataSet.First;
      while not DataSource.DataSet.eof do begin
        inc(Result);
        DataSource.DataSet.Next;
      end;
    finally
      try
        DataSource.DataSet.GotoBookmark(P);
      except
        {ignore failure - we're just trying to be nice}
      end;
      DataSource.DataSet.EnableControls;
    end;
  end;
end;

procedure TOvcDbReportView.RecordChanged;
begin
  ReloadData;
end;

procedure TOvcDbReportView.ReloadData;
const
  InReload : Boolean = False;
var
  i: Integer;
begin
  if InReload then exit;
  InReload := True;
  inc(InMove);
  try
    ClearIndex;
    ClearDataList;
    for i := 0 to pred(DCacheList.Count) do
      TOvcLiteStringCache(DCacheList[i]).Clear;
    FDataLink.BufferCount := InternalRecordCount;
    for i := 0 to pred(FDataLink.BufferCount) do
      DataList.Add(Pointer(i + 1));
    Screen.Cursor := crHourGlass;
    try
      BeginUpdate;
      try
        for i := 0 to pred(DataList.Count) do begin
          AddDataPrim(DataList[i]);
        {if i > MaxRecords then                                        !!.02
          raise Exception.Create('Maximum data count for the data aware report view reached');}
        end;
      finally
        EndUpdate;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    InReload := False;
    dec(InMove);
  end;
end;

procedure TOvcDbReportView.SetDataSource(Value : TDataSource);
begin
  if Value <> FDataLink.DataSource then
    ClearAll;
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
  if Fields.Count = 0 then
    BuildFieldTable;
end;

procedure TOvcDbReportView.SetName(const NewName : TComponentName);
var
  OldName,Tmp : string;
  i,j : Integer;
  WasActive : Boolean;
begin
  if NewName <> Name then begin
    OldName := Name;
    WasActive := (FDataLink.DataSet <> nil) and FDataLink.DataSet.Active;
    inherited SetName(NewName);
    if WasActive then
      ClearAll;
    DelayedBinding := True;
    for i := 0 to pred(Fields.Count) do begin
      Tmp := Field[i].Name;
      if pos(OldName,Tmp) = 1 then begin
        delete(Tmp,1,length(OldName));
        Tmp := NewName + Tmp;
        Field[i].Name := Tmp;
      end;
    end;
    for i := 0 to pred(Views.Count) do begin
      for j := 0 to pred(View[i].ViewFields.Count) do begin
        Tmp := View[i].ViewField[j].FieldName;
        if pos(OldName,Tmp) = 1 then begin
          delete(Tmp,1,length(OldName));
          Tmp := NewName + Tmp;
          View[i].ViewField[j].FieldName := Tmp;
        end;
      end;
    end;
    if WasActive then
      BuildFieldTable;
  end;
end;

function TOvcDbReportView.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbReportView.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

{ rewritten}
procedure TOvcDbReportView.DataSetChanged;
var
  ActiveRecord : Integer;
begin
  if FDataLink.Editing then exit;
  if InMove > 0 then exit;
  ActiveRecord := FDataLink.ActiveRecord;
  ReloadData;
  CurrentItem := Pointer(ActiveRecord + 1);
end;

{ new}
procedure TOvcDbReportView.DataSetScrolled;
begin
  if not FDataLink.Editing and (InMove = 0) then
    CurrentItem := Pointer(FDataLink.ActiveRecord + 1);
end;
(* !!.05
procedure TOvcDbReportView.DataSetChanged;
var
  SaveActiveRecord : Integer;
begin
  SaveActiveRecord := FDataLink.ActiveRecord;
  if InMove > 0 then exit;
  ReloadData;
  if SaveActiveRecord <> -1 then begin
    {if we're not looking at the active record, adjust}
    if CurrentItem <> Pointer(SaveActiveRecord + 1) then
      CurrentItem := Pointer(SaveActiveRecord + 1);
  end;
end;
*)

procedure TOvcDbReportView.Loaded;
begin
  inherited Loaded;
  BuildFieldTable;
end;

procedure TOvcDbReportView.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) then begin
    {was it our datasource or one of the associated TField objects}
    if (AComponent = DataSource) then begin
      DataSource := nil
    end else if (AComponent is TField) then begin
      ClearAll;
      BuildFieldTable;
    end;
  end else if (Operation = opInsert) and (AComponent is TField) then begin
    {was a TField object added for our dataset}
    if (FDataLink <> nil) then
      if (TField(AComponent).DataSet = FDataLink.DataSet) then begin
        ClearAll;
        BuildFieldTable;
      end;
  end;
end;

procedure TOvcDbReportView.DoDrawViewField(Canvas: TCanvas; Data: Pointer;
  Field: TOvcRvField; ViewField: TOvcRvViewField; TextAlign: Integer;
  IsSelected, IsGroup: Boolean; ViewFieldIndex: Integer; Rect: TRect;
  const Text, TruncText: string);
begin
  if SyncOnOwnerDraw then
    MoveDataPointer(Data);
  inherited DoDrawViewField(Canvas, Data, Field, ViewField, TextAlign,
    IsSelected, IsGroup, ViewFieldIndex, Rect, Text, TruncText);
end;

function TOvcDbReportView.CreateListBox: TOvcRVListBox;
begin
  Result := TOvcDbRVListBox.Create(Self);
end;

{ TOvcDbRVListBox }

procedure TOvcDbRVListBox.Paint;
begin
  if TOvcDbReportView(Owner).SyncOnOwnerDraw then
    SavedDataPointer := Pointer(TOvcDbReportView(Owner).FDataLink.ActiveRecord + 1);
  inherited;
  if TOvcDbReportView(Owner).SyncOnOwnerDraw then
    TOvcDbReportView(Owner).MoveDataPointer(SavedDataPointer);
end;

procedure TOvcDbReportView.DoDetail;
begin
  MoveDataPointer(Data);
  inherited;
end;

end.

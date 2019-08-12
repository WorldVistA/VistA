unit uROR_GridView;
{$I Components.inc}

interface

uses
  ComCtrls, Controls, Classes, Graphics, Variants, uROR_Utilities,
  uROR_CustomListView, Messages, CommCtrl, OvcFiler;

type
  TCCRGridView = class;

  TCCRGridDataType   = (gftUnknown, gftString, gftInteger, gftDateTime,
                        gftDouble, gftFMDate, gftBoolean, gftMUMPS);

  //----------------------------- TCCRGridField(s) -----------------------------

  TCCRGridField = class(TCollectionItem)
  private
    fAlignment:    TAlignment;
    fAllowResize:  Boolean;
    fAllowSort:    Boolean;
    fAutoSize:     Boolean;
    fCaption:      String;
    fColIndex:     Integer;
    fDataType:     TCCRGridDataType;
    fFMDTOptions:  TFMDateTimeMode;
    fFormat:       String;
    fMaxWidth:     Integer;
    fMinWidth:     Integer;
    fTag:          Longint;
    fVisible:      Boolean;
    fWidth:        Integer;

  protected
    function  GetDisplayName: String; override;
    function  getGridView: TCCRGridView;
    procedure setAlignment(const aValue: TAlignment); virtual;
    procedure setAutoSize(const aValue: Boolean); virtual;
    procedure setCaption(const aValue: String); virtual;
    procedure setDataType(const aValue: TCCRGridDataType); virtual;
    procedure setFMDTOptions(const aValue: TFMDateTimeMode); virtual;
    procedure setFormat(const aValue: String); virtual;
    procedure setMaxWidth(const aValue: Integer); virtual;
    procedure setMinWidth(const aValue: Integer); virtual;
    procedure setTag(const aValue: Longint); virtual;
    procedure setVisible(const aValue: Boolean); virtual;
    procedure setWidth(const aValue: Integer); virtual;
    function  validColumn(const aColumnIndex: Integer): Boolean;

    property ColIndex: Integer                        read    fColIndex
                                                      write   fColIndex;

  public
    constructor Create(aCollection: TCollection); override;

    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(aDest: TPersistent); override;

    property GridView: TCCRGridView                   read    getGridView;

  published
    property Alignment: TAlignment                    read    fAlignment
                                                      write   setAlignment
                                                      default taLeftJustify;

    property AllowResize: Boolean                     read    fAllowResize
                                                      write   fAllowResize
                                                      default True;

    property AllowSort: Boolean                       read    fAllowSort
                                                      write   fAllowSort
                                                      default True;

    property AutoSize: Boolean                        read    fAutoSize
                                                      write   setAutoSize;

    property Caption: String                          read    fCaption
                                                      write   setCaption;

    property DataType: TCCRGridDataType               read    fDataType
                                                      write   setDataType
                                                      default gftString;

    property FMDTOptions: TFMDateTimeMode             read    fFMDTOptions
                                                      write   setFMDTOptions
                                                      default fmdtShortDateTime;

    property Format: String                           read    fFormat
                                                      write   setFormat;

    property MaxWidth: Integer                        read    fMaxWidth
                                                      write   setMaxWidth;

    property MinWidth: Integer                        read    fMinWidth
                                                      write   setMinWidth;

    property Tag: Longint                             read    fTag
                                                      write   setTag;

    property Visible: Boolean                         read    fVisible
                                                      write   setVisible
                                                      default True;

    property Width: Integer                           read    fWidth
                                                      write   setWidth
                                                      default 50;

  end;

  TCCRGridFieldClass = class of TCCRGridField;

  TCCRGridFields = class(TOwnedCollection)
  protected
    function  GetItem(anIndex: Integer): TCCRGridField;
    function  getGridView: TCCRGridView;
    procedure Notify(anItem: TCollectionItem; anAction: TCollectionNotification); override;
    procedure Update(anItem: TCollectionItem); override;

  public
    constructor Create(anOwner: TCCRGridView;
      anItemClass: TCCRGridFieldClass = nil);

    function  GetColumn(aColumnIndex: Integer): TListColumn;

    property GridView: TCCRGridView                   read  getGridView;

    property Items[anIndex: Integer]: TCCRGridField   read  GetItem; default;

  end;

  //------------------------------ TCCRGridItem(s) -----------------------------

  TCCRFieldData = record
    VString: String;
    MType: TCCRGridDataType;
  case TCCRGridDataType of
    gftBoolean:  (VBoolean: Boolean);
    gftDateTime: (VDateTime: TDateTime);
    gftDouble:   (VDouble: Double);
    gftInteger:  (VInteger: Integer);
  end;
  TCCRFieldDataArray = array of TCCRFieldData;
  PCCRFieldDataArray = ^TCCRFieldDataArray;

  TCCRGridItem = class(TCCRCustomListItem)
  private
    fFieldData: array of TCCRFieldData;

    function  getListView: TCCRGridView;

  protected
    function  formatFieldValue(aFieldIndex: Integer): String;
    function  getAsBoolean(aFieldIndex: Integer): Boolean;
    function  getAsDateTime(aFieldIndex: Integer): TDateTime;
    function  getAsDouble(aFieldIndex: Integer): Double;
    function  getAsInteger(aFieldIndex: Integer): Integer;
    function  getAsString(aFieldIndex: Integer): String;
    function  getFieldValue(const aFieldIndex: Integer;
      var anInternalValue: Variant): String; override;
    function  getFormatted(aFieldIndex: Integer): String;

    procedure setAsBoolean(aFieldIndex: Integer; const aValue: Boolean);
    procedure setAsDateTime(aFieldIndex: Integer; const aValue: TDateTime);
    procedure setAsDouble(aFieldIndex: Integer; const aValue: Double);
    procedure setAsInteger(aFieldIndex: Integer; const aValue: Integer);
    procedure setAsString(aFieldIndex: Integer; const aValue: String);

  public
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure AssignRawData(const RawData: String; anIndexList: array of Integer;
      const Separator: String = '^');
    function  GetDataType(aFieldIndex: Integer): TCCRGridDataType;
    function  GetRawData(anIndexList: array of Integer;
      const Separator: String = '^'): String;
    procedure UpdateStringValues(const aFieldIndex: Integer); override;

    property AsBoolean[anIndex: Integer]: Boolean     read  getAsBoolean
                                                      write setAsBoolean;

    property AsDateTime[anIndex: Integer]: TDateTime  read  getAsDateTime
                                                      write setAsDateTime;

    property AsDouble[anIndex: Integer]: Double       read  getAsDouble
                                                      write setAsDouble;

    property AsInteger[anIndex: Integer]: Integer     read  getAsInteger
                                                      write setAsInteger;

    property AsString[anIndex: Integer]: String       read  getAsString
                                                      write setAsString;

    property Formatted[anIndex: Integer]: String      read   getFormatted;

    property ListView: TCCRGridView                   read   getListView;

  end;

  TCCRGridItems = class(TCCRCustomListItems)
  private
    function  getItem(anIndex: Integer): TCCRGridItem;
    procedure setItem(anIndex: Integer; const aValue: TCCRGridItem);

  public
    function Add: TCCRGridItem;
    function AddItem(anItem: TCCRGridItem; anIndex: Integer = -1): TCCRGridItem;
    procedure AppendRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^'; const numStrPerItem: Integer = 1);
    procedure AssignRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^');
    procedure GetRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String = '^');
    function Insert(anIndex: Integer): TCCRGridItem;

    property Item[anIndex: Integer]: TCCRGridItem         read    getItem
                                                          write   setItem;
                                                          default;
  end;

  //------------------------------- TCCRGridView -------------------------------

  TCCRColumnResizeEvent = procedure(aSender: TCCRGridView;
    aColumn: TListColumn) of object;

  TCCRFormatFieldValueEvent =  procedure (aSender: TObject; anItem: TCCRGridItem;
    const aFieldIndex: Integer; var aResult: String; var Default: Boolean) of object;

  TCCRGridView = class(TCCRCustomListView)
  private
    fFields:             TCCRGridFields;
    fOnFieldValueFormat: TCCRFormatFieldvalueEvent;
    fOnColumnResize:     TCCRColumnResizeEvent;

    function  getItemFocused: TCCRGridItem;
    function  getItems: TCCRGridItems;
    function  getSelected: TCCRGridItem;
    procedure setItemFocused(aValue: TCCRGridItem);
    procedure setSelected(aValue: TCCRGridItem);

  protected
    procedure CompareItems(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer); override;
    function  CreateListItem: TListItem; override;
    function  CreateListItems: TListItems; override;
    procedure CreateWnd; override;
    procedure DoOnColumnResize(aColumn: TListColumn); virtual;
    function  getSortColumn: Integer; override;
    procedure setFields(const aValue: TCCRGridFields); virtual;
    procedure UpdateColumns(const aClrFlg: Boolean); virtual;
    procedure WMNotify(var Msg: TWMNotify); message WM_NOTIFY;

    property Columns;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    function  ColumnIndex(const aFieldIndex: Integer;
      const SortableOnly: Boolean = False): Integer; override;
    function FieldIndex(const aColumnIndex: Integer;
      const SortableOnly: Boolean = False): Integer; override;
    function GetNextItem(StartItem: TCCRCustomListItem;
      Direction: TSearchDirection; States: TItemStates): TCCRGridItem;
    procedure LoadLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;
    procedure SaveLayout(aStorage: TOvcAbstractStore; const aSection: String); virtual;

    property ItemFocused: TCCRGridItem                read    getItemFocused
                                                      write   setItemFocused;

    property Items: TCCRGridItems                     read    getItems;

    property Selected: TCCRGridItem                   read    getSelected
                                                      write   setSelected;
    property SortColumn;

  published
    property Action;
    property Align;
    property AllocBy;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind                                default bkNone;
    property BevelOuter;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property ColumnClick;
    //property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatScrollBars;
    property Font;
    //property FullDrag;
    property GridLines                                default True;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property HoverTime;
    property IconOptions;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentColor                              default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly                                 default False;
    property RowSelect                                default True;
    property ShowColumnHeaders                        default True;
    property ShowHint;
    property ShowWorkAreas;
    property SmallImages;
    //property SortType;
    property StateImages;
    property TabOrder;
    property TabStop                                  default True;
    //property ViewStyle;
    property Visible;

    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    //property OnColumnDragged;
    property OnColumnRightClick;
    //property OnCompare;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnGetSubItemImage;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;

    property SortDescending;
    property SortField;

    property Fields: TCCRGridFields                   read    fFields
                                                      write   setFields;

    property OnColumnResize: TCCRColumnResizeEvent    read    fOnColumnResize
                                                      write   fOnColumnResize;

    property OnFieldValueFormat: TCCRFormatFieldValueEvent
                                                      read    fOnFieldValueFormat
                                                      write   fOnFieldValueFormat;

  end;

implementation

uses
  uROR_Resources, SysUtils;

//////////////////////////////// TCCRGridField \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRGridField.Create(aCollection: TCollection);
begin
  fAlignment   := taLeftJustify;
  fAllowResize := True;
  fAllowSort   := True;
  fColIndex    := -1;
  fDataType    := gftString;
  fFMDTOptions := fmdtShortDateTime;
  fVisible     := True;
  fWidth       := 50;
  inherited;
end;

procedure TCCRGridField.Assign(Source: TPersistent);
begin
  if Source is TCCRGridField then
    with TCCRGridField(Source) do
      begin
        Self.Alignment   := Alignment;
        Self.AllowResize := AllowResize;
        Self.AllowSort   := AllowSort;
        Self.AutoSize    := AutoSize;
        Self.Caption     := Caption;
        Self.ColIndex    := ColIndex;
        Self.DataType    := DataType;
        Self.FMDTOptions := FMDTOptions;
        Self.Format      := Format;
        Self.MaxWidth    := MaxWidth;
        Self.MinWidth    := MinWidth;
        Self.Tag         := Tag;
        Self.Visible     := Visible;
        Self.Width       := Width;
      end
  else if Source is TListColumn then
    with TListColumn(Source) do
      begin
        Self.Alignment   := Alignment;
        Self.AutoSize    := AutoSize;
        Self.MaxWidth    := MaxWidth;
        Self.MinWidth    := MinWidth;
        Self.Width       := Width;
        Self.Caption     := Caption;
      end
  else
    inherited;
end;

procedure TCCRGridField.AssignTo(aDest: TPersistent);
var
  wdc: Boolean;
begin
  if aDest is TListColumn then
    with TListColumn(aDest) do
      begin
        wdc := (Self.Width <> Width);

        Alignment := Self.Alignment;
        AutoSize  := Self.AutoSize;
        MaxWidth  := Self.MaxWidth;
        MinWidth  := Self.MinWidth;
        Tag       := Self.Index;
        Width     := Self.Width;
        Caption   := Self.Caption;

        if wdc and Assigned(GridView) then
          GridView.DoOnColumnResize(TListColumn(aDest));
      end
  else
    inherited;
end;

function TCCRGridField.GetDisplayName: String;
begin
  if fCaption <> '' then
    Result := Caption
  else
    Result := inherited GetDisplayName;
end;

function TCCRGridField.getGridView: TCCRGridView;
begin
  if Assigned(Collection) then
    Result := TCCRGridFields(Collection).GridView
  else
    Result := nil;
end;

procedure TCCRGridField.setAlignment(const aValue: TAlignment);
begin
  if aValue <> fAlignment then
    begin
      fAlignment := aValue;
      if validColumn(ColIndex) then
        GridView.Columns[ColIndex].Alignment := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setAutoSize(const aValue: Boolean);
begin
  if aValue <> fAutoSize then
    begin
      fAutoSize := aValue;
      if validColumn(ColIndex) then
        GridView.Columns[ColIndex].AutoSize := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setCaption(const aValue: String);
begin
  if aValue <> fCaption then
    begin
      fCaption := aValue;
      if validColumn(ColIndex) then
        GridView.Columns[ColIndex].Caption := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setDataType(const aValue: TCCRGridDataType);
begin
  if aValue <> fDataType then
    begin
      fDataType := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setFMDTOptions(const aValue: TFMDateTimeMode);
begin
  if aValue <> fFMDTOptions then
    begin
      fFMDTOptions := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setFormat(const aValue: String);
begin
  if aValue <> fFormat then
    begin
      fFormat := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setMaxWidth(const aValue: Integer);
begin
  if aValue <> fmaxWidth then
    begin
      fMaxWidth := aValue;
      if validColumn(ColIndex) then
        GridView.Columns[ColIndex].MaxWidth := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setMinWidth(const aValue: Integer);
begin
  if aValue <> fMinWidth then
    begin
      fMinWidth := aValue;
      if validColumn(ColIndex) then
        GridView.Columns[ColIndex].MinWidth := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setTag(const aValue: Longint);
begin
  if aValue <> fTag then
    begin
      fTag := aValue;
      Changed(False);
    end;
end;

procedure TCCRGridField.setVisible(const aValue: Boolean);
begin
  if aValue <> fVisible then
    begin
      fVisible := aValue;
      Changed(True);
    end;
end;

procedure TCCRGridField.setWidth(const aValue: Integer);
begin
  if aValue <> fWidth then
    begin
      fWidth := aValue;
      if validColumn(ColIndex) then
        with GridView do
          begin
            Columns[ColIndex].Width := aValue;
            DoOnColumnResize(Columns[ColIndex]);
          end;
      Changed(False);
    end;
end;

function TCCRGridField.validColumn(const aColumnIndex: Integer): Boolean;
begin
  if Assigned(GridView) then
    Result := (aColumnIndex >= 0) and (aColumnIndex < GridView.Columns.Count)
  else
    Result := False;
end;

///////////////////////////////// TCCRGridFields \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRGridFields.Create(anOwner: TCCRGridView;
  anItemClass: TCCRGridFieldClass);
begin
  if Assigned(anItemClass) then
    inherited Create(anOwner, anItemClass)
  else
    inherited Create(anOwner, TCCRGridField);
end;

function TCCRGridFields.GetColumn(aColumnIndex: Integer): TListColumn;
begin
  Result := nil;
  if Assigned(GridView) then
    if (aColumnIndex >= 0) and (aColumnIndex < GridView.Columns.Count) then
      Result := GridView.Columns[aColumnIndex];
end;

function TCCRGridFields.getGridView: TCCRGridView;
begin
  Result := TCCRGridView(Owner);
end;

function TCCRGridFields.GetItem(anIndex: Integer): TCCRGridField;
begin
  Result := TCCRGridField(inherited GetItem(anIndex));
end;

procedure TCCRGridFields.Notify(anItem: TCollectionItem;
  anAction: TCollectionNotification);
var
  col: TListColumn;
  fld: TCCRGridField;
begin
  inherited;
  fld := TCCRGridField(anItem);
  case anAction of
    cnAdded:
      if fld.Visible and Assigned(GridView) then
        begin
          col := GridView.Columns.Add;
          col.Assign(fld);
          fld.ColIndex := col.Index;
        end;
    cnDeleting, cnExtracting:
      if Assigned(GridView) then
        begin
          col := GetColumn(fld.ColIndex);
          if Assigned(col) then
            GridView.Columns.Delete(col.Index);
          fld.ColIndex := -1;
        end;
  end;
end;

procedure TCCRGridFields.Update(anItem: TCollectionItem);
begin
  inherited;
  if (anItem = nil) and Assigned(GridView) then
    GridView.UpdateColumns(True);
end;

////////////////////////////////// TCCRGridItem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

destructor TCCRGridItem.Destroy;
var
  i: Integer;
begin
  for i:=0 to High(fFieldData) do
    fFieldData[i].VString := '';
  SetLength(fFieldData, 0);
  fFieldData := nil;
  inherited;
end;

procedure TCCRGridItem.Assign(Source: TPersistent);
var
  i: Integer;
  si: TCCRGridItem;
begin
  inherited;
  if Source is TCCRGridItem then
    begin
      si := TCCRGridItem(Source);
      SetLength(fFieldData, High(si.fFieldData)+1);
      for i:=0 to High(fFieldData) do
        fFieldData[i] := si.fFieldData[i];
    end
end;

procedure TCCRGridItem.AssignRawData(const RawData: String;
  anIndexList: array of Integer; const Separator: String);
var
  i, ip, n: Integer;
begin
  n := ListView.Fields.Count - 1;
  if n > High(anIndexList) then n := High(anIndexList);
  BeginUpdate;
  try
    for i:=0 to n do
      begin
        ip := anIndexList[i];
        if ip > 0 then
          AsString[i] := Piece(RawData, Separator, ip);
      end;
  finally
    EndUpdate;
  end;
end;

function TCCRGridItem.formatFieldValue(aFieldIndex: Integer): String;
var
  dt: TCCRGridDataType;
  defaultFormat: Boolean;
begin
  Result := '';
  dt := GetDataType(aFieldIndex);
  if (dt = gftUnknown) or (aFieldIndex > High(fFieldData)) then Exit;

  with ListView do
    begin
      //--- Get the custom-formatted external value (if possible)
      if Assigned(OnFieldValueFormat) then
        begin
          defaultFormat := False;
          OnFieldValueFormat(ListView, Self, aFieldIndex, Result, defaultFormat);
        end
      else
        defaultFormat := True;
      //--- Get the default external value of the field
      if defaultFormat then
        case dt of
          gftBoolean:
            Result := BooleanToString(
                          fFieldData[aFieldIndex].VBoolean,
                          Fields[aFieldIndex].Format);
          gftDateTime:
           if fFieldData[aFieldIndex].VDateTime > 0 then
              Result := FormatDateTime(
                          Fields[aFieldIndex].Format,
                          fFieldData[aFieldIndex].VDateTime);
          gftDouble:
            Result := FormatFloat(
                          Fields[aFieldIndex].Format,
                          fFieldData[aFieldIndex].VDouble);
          gftFMDate:
            if fFieldData[aFieldIndex].VDouble > 0 then
              Result := FMDateTimeStr(
                          FloatToStr(fFieldData[aFieldIndex].VDouble),
                          Fields[aFieldIndex].FMDTOptions);
          gftInteger:
            if Fields[aFieldIndex].Format <> '' then
              Result := Format(
                          Fields[aFieldIndex].Format,
                          [fFieldData[aFieldIndex].VInteger])
            else
              Result := IntToStr(fFieldData[aFieldIndex].VInteger);
          gftString, gftMUMPS:
            if Fields[aFieldIndex].Format <> '' then
              Result := Format(
                          Fields[aFieldIndex].Format,
                          [fFieldData[aFieldIndex].VString])
            else
              Result := fFieldData[aFieldIndex].VString;
        end;
    end;
end;

function TCCRGridItem.getAsBoolean(aFieldIndex: Integer): Boolean;
var
  dt: TCCRGridDataType;
begin
  Result := False;
  if aFieldIndex <= High(fFieldData) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := fFieldData[aFieldIndex].MType;
      case dt of
        gftBoolean:
          Result := fFieldData[aFieldIndex].VBoolean;
        gftDateTime:
          Result := (fFieldData[aFieldIndex].VDateTime > 0);
        gftDouble:
          Result := (fFieldData[aFieldIndex].VDouble <> 0);
        gftFMDate:
          Result := (fFieldData[aFieldIndex].VDouble > 0);
        gftInteger:
          Result := (fFieldData[aFieldIndex].VInteger <> 0);
        gftString:
           Result := StrToBoolDef(fFieldData[aFieldIndex].VString, False);
      end;
    end;
end;

function TCCRGridItem.getAsDateTime(aFieldIndex: Integer): TDateTime;
var
  dt: TCCRGridDataType;
begin
  Result := 0;
  if aFieldIndex <= High(fFieldData) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := fFieldData[aFieldIndex].MType;
      case dt of
        gftBoolean:
            Result := -1;
        gftDateTime:
          Result := fFieldData[aFieldIndex].VDateTime;
        gftDouble, gftFMDate:
          Result := fFieldData[aFieldIndex].VDouble;
        gftInteger:
          Result := fFieldData[aFieldIndex].VInteger;
        gftString:
          Result := StrToFloatDef(fFieldData[aFieldIndex].VString, 0);
      end;
    end;
  if Result < 0 then
    raise EConvertError.Create(RSC0020);
end;

function TCCRGridItem.getAsDouble(aFieldIndex: Integer): Double;
var
  dt: TCCRGridDataType;
begin
  Result := 0;
  if aFieldIndex <= High(fFieldData) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := fFieldData[aFieldIndex].MType;
      case dt of
        gftBoolean:
          if fFieldData[aFieldIndex].VBoolean then
            Result := 1
          else
            Result := 0;
        gftDateTime:
          Result := fFieldData[aFieldIndex].VDateTime;
        gftDouble, gftFMDate:
          Result := fFieldData[aFieldIndex].VDouble;
        gftInteger:
          Result := fFieldData[aFieldIndex].VInteger;
        gftString:
          Result := StrToFloatDef(fFieldData[aFieldIndex].VString, 0);
      end;
    end;
end;

function TCCRGridItem.getAsInteger(aFieldIndex: Integer): Integer;
var
  dt: TCCRGridDataType;
begin
  Result := 0;
  if aFieldIndex <= High(fFieldData) then
    begin
      dt := GetDataType(aFieldIndex);
      if dt = gftMUMPS then
        dt := fFieldData[aFieldIndex].MType;
      case dt of
        gftBoolean:
          if fFieldData[aFieldIndex].VBoolean then
            Result := 1
          else
            Result := 0;
        gftDateTime:
          Result := Trunc(fFieldData[aFieldIndex].VDateTime);
        gftDouble, gftFMDate:
          Result := Trunc(fFieldData[aFieldIndex].VDouble);
        gftInteger:
          Result := fFieldData[aFieldIndex].VInteger;
        gftString:
          Result := StrToIntDef(fFieldData[aFieldIndex].VString, 0);
      end;
    end;
end;

function TCCRGridItem.getAsString(aFieldIndex: Integer): String;
begin
  Result := '';
  if (aFieldIndex >= 0) and (aFieldIndex <= High(fFieldData)) then
    Result := fFieldData[aFieldIndex].VString;
end;

function TCCRGridItem.GetDataType(aFieldIndex: Integer): TCCRGridDataType;
begin
  Result := gftUnknown;
  if Assigned(ListView) then
    with ListView do
      if (aFieldIndex >= 0) and (aFieldIndex < Fields.Count) then
        Result := Fields[aFieldIndex].DataType;
end;

function TCCRGridItem.getFieldValue(const aFieldIndex: Integer;
  var anInternalValue: Variant): String;
var
  dt: TCCRGridDataType;
begin
  Result := '';
  dt := GetDataType(aFieldIndex);
  if dt = gftMUMPS then
    dt := fFieldData[aFieldIndex].MType;
  case dt of
    gftBoolean:
      begin
        anInternalValue := fFieldData[aFieldIndex].VBoolean;
        Result := fFieldData[aFieldIndex].VString;
      end;
    gftDateTime:
      begin
        anInternalValue := fFieldData[aFieldIndex].VDateTime;
        Result := fFieldData[aFieldIndex].VString;
      end;
    gftDouble, gftFMDate:
      begin
        anInternalValue := fFieldData[aFieldIndex].VDouble;
        Result := fFieldData[aFieldIndex].VString;
      end;
    gftInteger:
      begin
        anInternalValue := fFieldData[aFieldIndex].VInteger;
        Result := fFieldData[aFieldIndex].VString;
      end;
    gftString:
      begin
        anInternalValue := fFieldData[aFieldIndex].VString;
        Result := anInternalValue;
      end;
  end;
end;

function TCCRGridItem.getFormatted(aFieldIndex: Integer): String;
begin
  if (aFieldIndex < 0) or (aFieldIndex >= ListView.Fields.Count) then
    Result := ''
  else if ListView.Fields[aFieldIndex].Visible then
    Result := StringValues[ListView.ColumnIndex(aFieldIndex)]
  else
    Result := formatFieldValue(aFieldIndex);
end;

function TCCRGridItem.getListView: TCCRGridView;
begin
  Result := inherited ListView as TCCRGridView;
end;

function TCCRGridItem.GetRawData(anIndexList: array of Integer;
  const Separator: String): String;
var
  i, ifld, lastFld: Integer;
begin
  Result := '';
  lastFld := ListView.Fields.Count - 1;
  for i:=0 to High(anIndexList) do
    begin
      ifld := anIndexList[i];
      if (ifld >= 0) and (ifld <= lastFld) then
        Result := Result + AsString[ifld] + Separator
      else
        Result := Result + Separator;
    end;
end;

procedure TCCRGridItem.setAsBoolean(aFieldIndex: Integer; const aValue: Boolean);
var
  dt: TCCRGridDataType;
begin
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;

  with ListView do
    begin
      if aFieldIndex > High(fFieldData) then
        SetLength(fFieldData, aFieldIndex+1);
      if dt = gftMUMPS then
        begin
          fFieldData[aFieldIndex].MType := gftDouble;
          dt := gftDouble;
        end;
      case dt of
        gftBoolean:
          fFieldData[aFieldIndex].VBoolean := aValue;
        gftDateTime, gftFMDate:
          raise EConvertError.Create(RSC0020);
        gftDouble:
          if aValue then
            fFieldData[aFieldIndex].VDouble := 1
          else
            fFieldData[aFieldIndex].VDouble := 0;
        gftInteger:
          if aValue then
            fFieldData[aFieldIndex].VInteger := 1
          else
            fFieldData[aFieldIndex].VInteger := 0;
        gftString:
          fFieldData[aFieldIndex].VString := BoolToStr(aValue);
      end;
      UpdateStringValues(aFieldIndex);
    end;
end;

procedure TCCRGridItem.setAsDateTime(aFieldIndex: Integer; const aValue: TDateTime);
begin
  setAsDouble(aFieldIndex, aValue);
end;

procedure TCCRGridItem.setAsDouble(aFieldIndex: Integer; const aValue: Double);
var
  dt: TCCRGridDataType;
begin
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;

  with ListView do
    begin
      if aFieldIndex > High(fFieldData) then
        SetLength(fFieldData, aFieldIndex+1);
      if dt = gftMUMPS then
        begin
          fFieldData[aFieldIndex].MType := gftDouble;
          dt := gftDouble;
        end;
      case dt of
        gftBoolean:
          fFieldData[aFieldIndex].VBoolean := (aValue <> 0);
        gftDateTime:
          fFieldData[aFieldIndex].VDateTime := aValue;
        gftDouble, gftFMDate:
          fFieldData[aFieldIndex].VDouble := aValue;
        gftInteger:
          fFieldData[aFieldIndex].VInteger := Trunc(aValue);
        gftString:
          fFieldData[aFieldIndex].VString := FloatToStr(aValue);
      end;
      UpdateStringValues(aFieldIndex);
    end;
end;

procedure TCCRGridItem.setAsInteger(aFieldIndex: Integer; const aValue: Integer);
var
  dt: TCCRGridDataType;
begin
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;

  with ListView do
    begin
      if aFieldIndex > High(fFieldData) then
        SetLength(fFieldData, aFieldIndex+1);
      if dt = gftMUMPS then
        begin
          fFieldData[aFieldIndex].MType := gftDouble;
          dt := gftDouble;
        end;
      case dt of
        gftBoolean:
          fFieldData[aFieldIndex].VBoolean := (aValue <> 0);
        gftDateTime:
          fFieldData[aFieldIndex].VDateTime := aValue;
        gftDouble, gftFMDate:
          fFieldData[aFieldIndex].VDouble := aValue;
        gftInteger:
          fFieldData[aFieldIndex].VInteger := aValue;
        gftString:
          fFieldData[aFieldIndex].VString := IntToStr(aValue);
      end;
      UpdateStringValues(aFieldIndex);
    end;
end;

procedure TCCRGridItem.setAsString(aFieldIndex: Integer; const aValue: String);
var
  dt: TCCRGridDataType;
begin
  dt := GetDataType(aFieldIndex);
  if dt = gftUnknown then Exit;

  with ListView do
    begin
      if aFieldIndex > High(fFieldData) then
        SetLength(fFieldData, aFieldIndex+1);
      case dt of
        gftBoolean:
          fFieldData[aFieldIndex].VBoolean := StrToBoolDef(aValue, False);
        gftDateTime:
          fFieldData[aFieldIndex].VDateTime := StrToDateTimeDef(aValue, 0);
        gftDouble, gftFMDate:
          fFieldData[aFieldIndex].VDouble := StrToFloatDef(aValue, 0);
        gftInteger:
          fFieldData[aFieldIndex].VInteger := StrToIntDef(aValue, 0);
        gftMUMPS:
          try
            fFieldData[aFieldIndex].VDouble := StrToFloat(aValue);
            fFieldData[aFieldIndex].MType   := gftDouble;
          except
            fFieldData[aFieldIndex].VString := aValue;
            fFieldData[aFieldIndex].MType   := gftString;
          end;
        gftString:
          fFieldData[aFieldIndex].VString := aValue;
      end;
      UpdateStringValues(aFieldIndex);
    end;
end;

procedure TCCRGridItem.UpdateStringValues(const aFieldIndex: Integer);
var
  i, n: Integer;

  procedure update_field(const aFieldIndex: Integer);
  var
    dt: TCCRGridDataType;
  begin
    dt := GetDataType(aFieldIndex);
    if (dt = gftUnknown) or (aFieldIndex > High(fFieldData)) then Exit;
    //--- Update the internal string value of the field
    with fFieldData[aFieldIndex] do
      begin
        if dt = gftMUMPS then
          dt := MType;
        case dt of
          gftBoolean:
            VString := BoolToStr(VBoolean);
          gftDateTime:
            VString := FloatToStr(VDateTime);
          gftDouble, gftFMDate:
            VString := FloatToStr(VDouble);
          gftInteger:
            VString := IntToStr(VInteger);
        end;
      end;
    //--- Update the Caption or SubItem if the field is visible
    with ListView do
      if Fields[aFieldIndex].Visible then
        StringValues[ColumnIndex(aFieldIndex)] := formatFieldValue(aFieldIndex);
  end;

begin
  if UpdateLock = 0 then
    if aFieldIndex >= 0 then
      update_field(aFieldIndex)
    else
      begin
        SubItems.BeginUpdate;
        try
          n := ListView.Fields.Count - 1;
          for i:=0 to n do
            update_field(i);
        finally
          SubItems.EndUpdate;
        end;
      end;
end;

////////////////////////////////// TCCRGridItems \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function TCCRGridItems.Add: TCCRGridItem;
begin
  Result := TCCRGridItem(inherited Add);
end;

function TCCRGridItems.AddItem(anItem: TCCRGridItem; anIndex: Integer): TCCRGridItem;
begin
  Result := TCCRGridItem(inherited AddItem(anItem, anIndex));
end;

procedure TCCRGridItems.AppendRawData(RawData: TStrings; anIndexList: array of Integer;
      const Separator: String; const numStrPerItem: Integer);
var
  i, j: Integer;
  buf: String;
  gi : TCCRGridItem;
begin
  BeginUpdate;
  try
    i := 0;
    while i < RawData.Count do
      begin
        buf := RawData[i];
        Inc(i);
        for j:=2 to numStrPerItem do
          begin
            if i >= RawData.Count then
              Break;
            buf := buf + Separator + RawData[i];
            Inc(i);
          end;
        gi := Add;
        if Assigned(gi) then
          gi.AssignRawData(buf, anIndexList, Separator);
      end;
  finally
    EndUpdate;
  end;
end;

procedure TCCRGridItems.AssignRawData(RawData: TStrings;
  anIndexList: array of Integer; const Separator: String);
begin
  BeginUpdate;
  try
    Clear;
    AppendRawData(RawData, anIndexList, Separator);
  finally
    EndUpdate;
  end;
end;

function TCCRGridItems.getItem(anIndex: Integer): TCCRGridItem;
begin
  Result := inherited Item[anIndex] as TCCRGridItem;
end;

procedure TCCRGridItems.GetRawData(RawData: TStrings; anIndexList: array of Integer;
  const Separator: String);
var
  i, numItems: Integer;
  buf: String;
begin
  RawData.BeginUpdate;
  try
    RawData.Clear;
    numItems := Count - 1;
    for i:=0 to numItems do
      begin
        buf := Item[i].GetRawData(anIndexList, Separator);
        RawData.Add(buf);
      end;
  finally
    RawData.EndUpdate;
  end;
end;

function TCCRGridItems.Insert(anIndex: Integer): TCCRGridItem;
begin
  Result := TCCRGridItem(inherited Insert(anIndex));
end;

procedure TCCRGridItems.setItem(anIndex: Integer; const aValue: TCCRGridItem);
begin
  Item[anIndex].Assign(aValue);
end;

////////////////////////////////// TCCRGridView \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRGridView.Create(anOwner: TComponent);
begin
  inherited;

  BevelKind           := bkNone;
  GridLines           := True;
  ParentColor         := False;
  ReadOnly            := False;
  RowSelect           := True;
  ShowColumnHeaders   := True;
  TabStop             := True;
  ViewStyle           := vsReport;

  fFields             := TCCRGridFields.Create(Self);
  fOnColumnResize     := nil;
  fOnFieldValueFormat := nil;
end;

destructor TCCRGridView.Destroy;
begin
  FreeAndNil(fFields);
  inherited;
end;

function TCCRGridView.ColumnIndex(const aFieldIndex: Integer;
  const SortableOnly: Boolean): Integer;
begin
  if (aFieldIndex >= 0) and (aFieldIndex < Fields.Count) then
    begin
      if Fields[aFieldIndex].AllowSort then
        begin
          Result := Fields[aFieldIndex].ColIndex;
          if (Result < 0) or (Result >= Columns.Count) then
            Result := -1;
        end
      else
        Result := -1;
    end
  else
    Result := -1;
end;

procedure TCCRGridView.CompareItems(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  dt1, dt2, dt: TCCRGridDataType;
  iv1, iv2: Integer;
  dv1, dv2: Double;
  bv1, bv2: Boolean;
begin
  if (SortField < 0) or (SortField >= Fields.Count) then Exit;
  Compare := 0;
  dt := Fields[SortField].DataType;

  if dt = gftMUMPS then
    begin
      //--- Get the actual data types
      dt1 := TCCRGridItem(Item1).fFieldData[SortField].MType;
      dt2 := TCCRGridItem(Item2).fFieldData[SortField].MType;
      //--- If they are different, perform MUMPS-like comparison.
      //--- Otherwise, skip to the regular comparison of values.
      if dt1 <> dt2 then
        begin
          //--- Item1
          if TCCRGridItem(Item1).getAsString(SortField) = '' then
              Dec(Compare, 1)
          else if dt1 = gftDouble then
              Inc(Compare, 1)
          else if dt1 = gftString then
              Inc(Compare, 2);
          //--- Item2
          if TCCRGridItem(Item2).getAsString(SortField) = '' then
              Inc(Compare, 1)
          else if dt2 = gftDouble then
              Dec(Compare, 1)
          else if dt2 = gftString then
              Dec(Compare, 2);
          {
          dv1\dv2 | empty | number | string
          --------+-------+--------+---------
          empty   |   0   |   -2   |   -3
          --------+-------+--------+---------
          number  |   2   |  cmp.  |   -1
          --------+-------+--------+---------
          string  |   3   |    1   |  cmp.
          }
          if Compare < -1 then
            Compare := -1;
          if Compare > 1 then
            Compare := 1;
        end
      else
        dt := dt1;
    end;
  //--- Regular comparison of field values
  case dt of
    gftBoolean:
      begin
        bv1 := TCCRGridItem(Item1).getAsBoolean(SortField);
        bv2 := TCCRGridItem(Item2).getAsBoolean(SortField);
        if      bv1 > bv2 then Compare :=  1
        else if bv1 < bv2 then Compare := -1;
      end;
    gftDateTime, gftDouble, gftFMDate:
      begin
        dv1 := TCCRGridItem(Item1).getAsDouble(SortField);
        dv2 := TCCRGridItem(Item2).getAsDouble(SortField);
        if      dv1 > dv2 then Compare :=  1
        else if dv1 < dv2 then Compare := -1;
      end;
    gftInteger:
      begin
        iv1 := TCCRGridItem(Item1).getAsInteger(SortField);
        iv2 := TCCRGridItem(Item2).getAsInteger(SortField);
        if      iv1 > iv2 then Compare :=  1
        else if iv1 < iv2 then Compare := -1;
      end;
    gftString:
      Compare := CompareStr(
        TCCRGridItem(Item1).getAsString(SortField),
        TCCRGridItem(Item2).getAsString(SortField));
  end;
  //--- Reverse the sort order if necessary
  if SortDescending then
    Compare := -Compare;
end;

function TCCRGridView.CreateListItem: TListItem;
var
  LClass: TListItemClass;
begin
  LClass := TCCRGridItem;
  if Assigned(OnCreateItemClass) then
    OnCreateItemClass(Self, LClass);
  Result := LClass.Create(Items);
end;

function TCCRGridView.CreateListItems: TListItems;
begin
  Result := TCCRGridItems.Create(self);
end;

procedure TCCRGridView.CreateWnd;
begin
  inherited;
  UpdateColumns(False);
end;

procedure TCCRGridView.DoOnColumnResize(aColumn: TListColumn);
begin
  if Assigned(OnColumnResize) then
    OnColumnResize(Self, aColumn);
end;

function TCCRGridView.FieldIndex(const aColumnIndex: Integer;
  const SortableOnly: Boolean): Integer;
begin
  if (aColumnIndex >= 0) and (aColumnIndex < Columns.Count) then
    begin
      Result := Columns[aColumnIndex].Tag;
      if (Result < 0) or (Result >= Fields.Count) then
        Result := -1
      else if not Fields[Result].AllowSort then
        Result := -1;
    end
  else
    Result := -1;
end;

function TCCRGridView.getItemFocused: TCCRGridItem;
begin
  Result := inherited ItemFocused as TCCRGridItem;
end;

function TCCRGridView.getItems: TCCRGridItems;
begin
  Result := inherited Items as TCCRGridItems;
end;

function TCCRGridView.GetNextItem(StartItem: TCCRCustomListItem;
  Direction: TSearchDirection; States: TItemStates): TCCRGridItem;
begin
  Result := TCCRGridItem(inherited GetNextItem(StartItem, Direction, States));
end;

function TCCRGridView.getSelected: TCCRGridItem;
begin
  Result := inherited Selected as TCCRGridItem;
end;

function TCCRGridView.getSortColumn: Integer;
begin
  if (SortField >= 0) and (SortField < Fields.Count) then
    Result := Fields[SortField].ColIndex
  else
    Result := -1;
end;

procedure TCCRGridView.LoadLayout(aStorage: TOvcAbstractStore; const aSection: String);
var
  i, n, wd: Integer;
begin
  try
    aStorage.Open;
    try
      n := Fields.Count - 1;
      for i:=0 to n do
        begin
          wd := aStorage.ReadInteger(aSection, Fields[i].GetNamePath, -1);
          if wd >= 0 then Fields[i].Width := wd;
        end;
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRGridView.SaveLayout(aStorage: TOvcAbstractStore; const aSection: String);
  var
    i, n: Integer;
begin
  try
    aStorage.Open;
    try
      n := Fields.Count - 1;
      for i:=0 to n do
        aStorage.WriteInteger(aSection, Fields[i].GetNamePath, Fields[i].Width);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRGridView.setFields(const aValue: TCCRGridFields);
begin
  try
    fFields.Free;
    Columns.Clear;
  except
  end;
  fFields := aValue;
end;

procedure TCCRGridView.setItemFocused(aValue: TCCRGridItem);
begin
  inherited ItemFocused := aValue;
end;

procedure TCCRGridView.setSelected(aValue: TCCRGridItem);
begin
  inherited Selected := aValue;
end;

procedure TCCRGridView.UpdateColumns(const aClrFlg: Boolean);
var
  i, n: Integer;
  col: TListColumn;
begin
  if aClrFlg then
    Clear;

  Columns.BeginUpdate;
  try
    Columns.Clear;
    n := Fields.Count - 1;
    for i:=0 to n do
      if Fields[i].Visible then
        begin
          col := Columns.Add;
          if Assigned(col) then
            begin
              col.Assign(Fields[i]);
              Fields[i].ColIndex := col.Index;
            end;
        end;
    UpdateSortField;
  finally
    Columns.EndUpdate;
  end;
end;

procedure TCCRGridView.WMNotify(var Msg: TWMNotify);
var
  colNdx, colWidth, fldNdx: Integer;
begin
  if csDesigning in	ComponentState then
    begin
      inherited;
      Exit;
    end;

  if (Msg.NMHdr^.code = HDN_BEGINTRACKA) or (Msg.NMHdr^.code = HDN_BEGINTRACKW) then
    begin
      colNdx := FindColumnIndex(Msg.NMHdr);
      fldNdx := FieldIndex(colNdx);
      if fldNdx >= 0 then
        if not Fields[fldNdx].AllowResize then
          begin
            Msg.Result := 1; // Disable resizing the column
            Exit;
          end;
    end;

  inherited;

  case Msg.NMHdr^.code of
    HDN_ENDTRACK:
      begin
        colNdx := FindColumnIndex(Msg.NMHdr);
        colWidth := FindColumnWidth(Msg.NMHdr);
        //--- Update the width of field
        fldNdx := FieldIndex(colNdx);
        if (fldNdx >= 0) and (colWidth >= 0) then
          Fields[fldNdx].fWidth := colWidth;
        //--- Call the event handler (if assigned)
        DoOnColumnResize(Columns[colNdx]);
      end;
    //HDN_BEGINTRACK:
    //HDN_TRACK: ;
  end;
end;

end.

unit uROR_CustomListView;
{$I Components.inc}

interface

uses
  ComCtrls, Controls, Classes, Graphics, Variants, uROR_Utilities, Messages,
  CommCtrl, Windows;

type
  TCCRCustomListView = class;

  TCCRFindStringMode = set of (fsmCase, fsmInclusive, fsmPartial, fsmWrap);

  //--------------------------- TCCRCustomListItem(s) --------------------------

  TCCRCustomListItem = class(TListItem)
  private
    fUpdateLock: Integer;

    function  getListView: TCCRCustomListView;
    function  getStringValue(aColumnIndex: Integer): String;
    procedure setStringValue(aColumnIndex: Integer; const aValue: String);

  protected
    function  getFieldValue(const aFieldIndex: Integer;
      var anInternalValue: Variant): String; virtual; abstract;

    property UpdateLock: Integer read fUpdateLock;

  public
    procedure BeginUpdate; virtual;
    procedure EndUpdate; virtual;
    procedure UpdateStringValues(const aFieldIndex: Integer = -1); virtual;

    property ListView: TCCRCustomListView                 read    getListView;

    property StringValues[aColumnIndex: Integer]: String  read    getStringValue
                                                          write   setStringValue;
  end;

  TCCRCustomListItems = class(TListItems)
  private
    function  getItem(anIndex: Integer): TCCRCustomListItem;
    procedure setItem(anIndex: Integer; const aValue: TCCRCustomListItem);

  public
    property Item[anIndex: Integer]: TCCRCustomListItem   read    getItem
                                                          write   setItem;
                                                          default;
  end;

  //----------------------------- TCCRCustomListView ---------------------------

  TCCRCustomListView = class(TCustomListView)
  private
    fColor:           TColor;
    fSortDescending:  Boolean;
    fSortField:       Integer;

    function  getItems: TCCRCustomListItems;
    procedure setColor(const aColor: TColor);

  protected
    procedure ColClick(aColumn: TListColumn); override;
    procedure CompareItems(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer); virtual;
    procedure CreateWnd; override;
    procedure DoEnter; override;
    function  FindColumnIndex(pHeader: PNMHdr): Integer;
    function  FindColumnWidth(pHeader: PNMHdr): Integer;
    function  getSortColumn: Integer; virtual;
    procedure InsertItem(anItem: TListItem); override;
    procedure Loaded; override;
    procedure SetEnabled(aValue: Boolean); override;
    procedure setSortColumn(const aValue: Integer); virtual;
    procedure setSortDescending(const aValue: Boolean); virtual;
    procedure setSortField(const aValue: Integer); virtual;
    procedure UpdateSortField; virtual;

    property Color: TColor                            read    fColor
                                                      write   setColor
                                                      default clWindow;

    property Items: TCCRCustomListItems               read    getItems;

    property SortColumn: Integer                      read    getSortColumn
                                                      write   setSortColumn;

    property SortDescending: Boolean                  read    fSortDescending
                                                      write   setSortDescending
                                                      default False;

    property SortField: Integer                       read    fSortField
                                                      write   setSortField
                                                      default -1;

  public
    constructor Create(anOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Activate;
    function  ColumnIndex(const aFieldIndex: Integer;
      const SortableOnly: Boolean = False): Integer; virtual;
    procedure EnsureSelection;
    function  FieldIndex(const aColumnIndex: Integer;
      const SortableOnly: Boolean = False): Integer; virtual;
    function  FindString(aValue: String; aFieldIndex: Integer;
      aStartIndex: Integer = 0;
      aMode: TCCRFindStringMode = [fsmInclusive]): TCCRCustomListItem;

  end;

implementation

uses
  uROR_Resources, ImgList, SysUtils, StrUtils;

const
  imgAscending  = 0;
  imgDescending = 1;

var
  DefaultImages: TImageList = nil;
  DICount: Integer = 0;

function LoadDefaultImages: TImageList;
begin
  if DICount <= 0 then
    begin
      if Assigned(DefaultImages) then
        DefaultImages.Free;
      DefaultImages := TImageList.Create(nil);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'SORT_ASCENDING', clFuchsia);
      DefaultImages.ResInstLoad(HInstance, rtBitmap, 'SORT_DESCENDING', clFuchsia);
    end;
  Inc(DICount);
  Result := DefaultImages;
end;

procedure UnloadDefaultImages;
begin
  if DICount > 0 then
    begin
      Dec(DICount);
      if DICount = 0 then
        FreeAndNil(DefaultImages);
    end;
end;

/////////////////////////////// TCCRCustomListItem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRCustomListItem.BeginUpdate;
begin
  if fUpdateLock = 0 then
    SubItems.BeginUpdate;
  Inc(fUpdateLock);
end;

procedure TCCRCustomListItem.EndUpdate;
begin
  if fUpdateLock > 0 then
    begin
      Dec(fUpdateLock);
      if fUpdateLock = 0 then
        begin
          UpdateStringValues;
          SubItems.EndUpdate;
        end;
    end;
end;

function TCCRCustomListItem.getListView: TCCRCustomListView;
begin
  Result := inherited ListView as TCCRCustomListView;
end;

function TCCRCustomListItem.getStringValue(aColumnIndex: Integer): String;
begin
  if aColumnIndex = 0 then
    Result := Caption
  else if (aColumnIndex > 0) and (aColumnIndex <= SubItems.Count) then
    Result := SubItems[aColumnIndex-1]
  else
    Result := '';
end;

procedure TCCRCustomListItem.setStringValue(aColumnIndex: Integer; const aValue: String);
var
  i: Integer;
begin
  if aColumnIndex = 0 then
   Caption := aValue
  else if (aColumnIndex > 0) and (aColumnIndex < ListView.Columns.Count) then
    begin
      if aColumnIndex > SubItems.Count then
        for i:=ListView.Columns.Count-2 to SubItems.Count do
          SubItems.Add('');
      SubItems[aColumnIndex-1] := aValue;
    end;
end;

procedure TCCRCustomListItem.UpdateStringValues(const aFieldIndex: Integer);
var
  i, n: Integer;
  iv: Variant;
begin
  if Assigned(Data) and (UpdateLock = 0) then
    if (aFieldIndex >= 0) and (aFieldIndex < ListView.Columns.Count) then
      StringValues[aFieldIndex] := getFieldValue(aFieldIndex, iv)
    else
      begin
        SubItems.BeginUpdate;
        try
          n := ListView.Columns.Count - 1;
          for i:=0 to n do
            StringValues[i] := getFieldValue(i, iv);
        finally
          SubItems.EndUpdate;
        end;
      end;
end;

/////////////////////////////// TCCRCustomListItems \\\\\\\\\\\\\\\\\\\\\\\\\\\\

function TCCRCustomListItems.getItem(anIndex: Integer): TCCRCustomListItem;
begin
  Result := inherited Item[anIndex] as TCCRCustomListItem;
end;

procedure TCCRCustomListItems.setItem(anIndex: Integer; const aValue: TCCRCustomListItem);
begin
  inherited Item[anIndex] := aValue;
end;

/////////////////////////////// TCCRCustomListView \\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRCustomListView.Create(anOwner: TComponent);
begin
  inherited;

  BevelKind         := bkNone;
  GridLines         := True;
  OnCompare         := CompareItems;
  ParentColor       := False;
  ReadOnly          := False;
  SmallImages       := LoadDefaultImages;
  TabStop           := True;

  fColor            := clWindow;
  fSortDescending   := False;
  fSortField        := -1;
end;

destructor TCCRCustomListView.Destroy;
begin
  UnloadDefaultImages;
  inherited;
end;

procedure TCCRCustomListView.Activate;
begin
  if Items.Count > 0 then
    begin
      SetFocus;
      EnsureSelection;
    end;
end;

procedure TCCRCustomListView.ColClick(aColumn: TListColumn);
var
  fldNdx: Integer;
begin
  fldNdx := FieldIndex(aColumn.Index);
  if fldNdx >= 0 then
    if fldNdx <> SortField then
      SortField := fldNdx
    else
      SortDescending := not SortDescending;
  inherited;
end;

function TCCRCustomListView.ColumnIndex(const aFieldIndex: Integer;
  const SortableOnly: Boolean): Integer;
begin
  if (aFieldIndex >= 0) and (aFieldIndex < Columns.Count) then
    Result := aFieldIndex
  else
    Result := -1;
end;

procedure TCCRCustomListView.CompareItems(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  iv1, iv2: Variant;
begin
  Compare := 0;
  if (SortField < 0) or (SortField >= Columns.Count) then
    Exit;

  TCCRCustomListItem(Item1).getFieldValue(SortField, iv1);
  TCCRCustomListItem(Item2).getFieldValue(SortField, iv2);

  case VarCompareValue(iv1, iv2) of
    vrLessThan:    Compare := -1;
    vrGreaterThan: Compare := 1;
  end;

  if SortDescending then
    Compare := -Compare;
end;

procedure TCCRCustomListView.CreateWnd;
var
  wnd: HWND;
begin
  inherited;
  wnd := GetWindow(Handle, GW_CHILD);
  SetWindowLong(wnd, GWL_STYLE,
    GetWindowLong(wnd, GWL_STYLE) and not HDS_FULLDRAG);
end;

procedure TCCRCustomListView.DoEnter;
begin
  inherited;
  EnsureSelection;
end;

procedure TCCRCustomListView.EnsureSelection;
begin
  if (Items.Count > 0) and (ItemIndex < 0) then
    ItemIndex := 0;
  if ItemIndex >= 0 then
    ItemFocused := Items[ItemIndex];
end;

function TCCRCustomListView.FieldIndex(const aColumnIndex: Integer;
  const SortableOnly: Boolean): Integer;
begin
  if (aColumnIndex >= 0) and (aColumnIndex < Columns.Count) then
    Result := aColumnIndex
  else
    Result := -1;
end;

function TCCRCustomListView.FindColumnIndex(pHeader: PNMHdr): Integer;
var
  hwndHeader: HWND;
  iteminfo: THdItem;
  ItemIndex: Integer;
  buf: array [0..128] of Char;
begin
  Result := -1;
  hwndHeader := pHeader^.hwndFrom;
  ItemIndex := pHDNotify(pHeader)^.Item;
  FillChar(iteminfo, SizeOf(iteminfo), 0);
  iteminfo.Mask := HDI_TEXT;
  iteminfo.pszText := buf;
  iteminfo.cchTextMax := SizeOf(buf) - 1;
  Header_GetItem(hwndHeader, ItemIndex, iteminfo);
  if CompareStr(Columns[ItemIndex].Caption, iteminfo.pszText) = 0 then
    Result := ItemIndex
  else
  begin
    for ItemIndex := 0 to Columns.Count - 1 do
      if CompareStr(Columns[ItemIndex].Caption, iteminfo.pszText) = 0 then
      begin
        Result := ItemIndex;
        Break;
      end;
  end;
end;

function TCCRCustomListView.FindColumnWidth(pHeader: pNMHdr): Integer;
begin
  Result := -1;
  if Assigned(PHDNotify(pHeader)^.pItem) and
    ((PHDNotify(pHeader)^.pItem^.mask and HDI_WIDTH) <> 0) then
    Result := PHDNotify(pHeader)^.pItem^.cxy;
end;

function TCCRCustomListView.FindString(aValue: String; aFieldIndex: Integer;
  aStartIndex: Integer = 0; aMode: TCCRFindStringMode = [fsmInclusive]): TCCRCustomListItem;
var
  n: Integer;
  iv: Variant;

  function find(aStartIndex, anEndIndex: Integer; aMode: TCCRFindStringMode): TCCRCustomListItem;
  var
    i: Integer;
    Comparator: function(const aSubText, aText: String): Boolean;
  begin
    Result := nil;

    if aStartIndex < 0 then
      aStartIndex := 0;
    if anEndIndex >= Items.Count then
      anEndIndex := Items.Count - 1;

    if fsmPartial in aMode then
      if fsmCase in aMode then
        Comparator := AnsiStartsStr
      else
        Comparator := AnsiStartsText
    else
      if fsmCase in aMode then
        Comparator := AnsiSameStr
      else
        Comparator := AnsiSameText;

    for i:=aStartIndex to anEndIndex do
      if Comparator(aValue, Items[i].getFieldValue(aFieldIndex, iv)) then
      begin
        Result := Items[i];
        Break;
      end;
  end;

begin
  Result := nil;
  if Items.Count > 0 then
    begin
      n := Items.Count - 1;
      if fsmInclusive in aMode then
        Result := find(aStartIndex, n, aMode)
      else
        Result := find(aStartIndex+1, n, aMode);

      if (not Assigned(Result)) and (fsmWrap in aMode) then
        begin
          if fsmInclusive in aMode then
            n := aStartIndex - 1
          else
            n := aStartIndex;
          if n >= 0 then
            Result := find(0, n, aMode);
        end;
    end;
end;

function TCCRCustomListView.getItems: TCCRCustomListItems;
begin
  Result := inherited Items as TCCRCustomListItems;
end;

function TCCRCustomListView.getSortColumn: Integer;
begin
  if (SortField >= 0) and (SortField < Columns.Count) then
    Result := SortField
  else
    Result := -1;
end;

procedure TCCRCustomListView.InsertItem(anItem: TListItem);
var
  i: Integer;
begin
  with anItem do
    begin
      ImageIndex := -1;
      Indent     := -1;
      SubItems.BeginUpdate;
      try
        for i:=2 to Columns.Count do
          SubItems.Add('');
      finally
        SubItems.EndUpdate;
      end;
    end;
  inherited;
end;

procedure TCCRCustomListView.Loaded;
begin
  inherited;

  if ParentColor then
    begin
      ParentColor := False;  // Enforce correct Parent Color
      ParentColor := True
    end;

  if (SortField >= 0) and (SortField < Columns.Count) then
    UpdateSortField
  else
    SortField := -1;
end;

procedure TCCRCustomListView.setColor(const aColor: TColor);
begin
  if aColor <> fColor then
    begin
      fColor := aColor;
      if Enabled then
        inherited Color := aColor;
    end;
end;

procedure TCCRCustomListView.SetEnabled(aValue: Boolean);
begin
  if aValue <> Enabled then
    begin
      inherited;
      if aValue then
        inherited Color := fColor
      else
        inherited Color := clBtnFace;
    end;
end;

procedure TCCRCustomListView.setSortColumn(const aValue: Integer);
begin
  if (aValue <> SortColumn) and (aValue < Columns.Count) then
    SortField := FieldIndex(aValue);
end;

procedure TCCRCustomListView.setSortDescending(const aValue: Boolean);
begin
  if aValue <> fSortDescending then
    begin
      fSortDescending := aValue;
      if SortField >= 0 then
        begin
          UpdateSortField;
          AlphaSort;
        end;
    end;
end;

procedure TCCRCustomListView.setSortField(const aValue: Integer);
begin
  if aValue <> fSortField then
    if aValue >= 0 then
      begin
        if SortColumn >= 0 then
          Columns[SortColumn].ImageIndex := -1;
        fSortField := aValue;
        fSortDescending := False;
        UpdateSortField;
        if SortType <> stBoth then
          SortType := stBoth
        else
          AlphaSort;
      end
    else
      begin
        if SortColumn >= 0 then
          Columns[SortColumn].ImageIndex := -1;
        fSortField := -1;
        SortType   := stNone;
      end;
end;

procedure TCCRCustomListView.UpdateSortField;
begin
  if (SortColumn >= 0) and (SortColumn < Columns.Count) then
  begin
    if SortDescending then
      Columns[SortColumn].ImageIndex := imgDescending
    else
      Columns[SortColumn].ImageIndex := imgAscending;
  end;
end;

end.

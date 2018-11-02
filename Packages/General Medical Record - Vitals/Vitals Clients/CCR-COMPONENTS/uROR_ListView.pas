unit uROR_ListView;
{$I Components.inc}

interface

uses
  ComCtrls, Controls, Classes, Variants, uROR_Utilities, uROR_CustomListView;

type
  TCCRListView = class;

  //------------------------------ TCCRListItem(s) -----------------------------

  TCCRListItem = class(TCCRCustomListItem)
  private
    function  getListView: TCCRListView;

  protected
    function  getFieldValue(const aFieldIndex: Integer;
      var anInternalValue: Variant): String; override;

  public
    property ListView: TCCRListView                   read    getListView;

  end;

  TCCRListItems = class(TCCRCustomListItems)
  private
    function  getItem(anIndex: Integer): TCCRListItem;
    procedure setItem(anIndex: Integer; const aValue: TCCRListItem);

  public
    function Add: TCCRListItem;
    function AddItem(anItem: TCCRListItem; anIndex: Integer = -1): TCCRListItem;
    function AddObject(const aCaption: String; anObject: TObject): TCCRListItem;
    function Insert(anIndex: Integer): TCCRListItem;

    property Item[anIndex: Integer]: TCCRListItem     read    getItem
                                                      write   setItem;
                                                      default;
  end;

  //-------------------------------- TCCRListView ------------------------------

  TCCRGetFieldValueEvent = procedure(Sender: TCCRCustomListView;
    anItem: TCCRCustomListItem; const aFieldIndex: Integer;
    var anExternalValue: String; var anInternalValue: Variant) of object;

  TCCRListView = class(TCCRCustomListView)
  private
    fOnFieldValueGet: TCCRGetFieldValueEvent;

    function  getItemFocused: TCCRListItem;
    function  getItems: TCCRListItems;
    function  getSelected: TCCRListItem;
    procedure setItemFocused(aValue: TCCRListItem);
    procedure setSelected(aValue: TCCRListItem);

  protected
    function  CreateListItem: TListItem; override;
    function  CreateListItems: TListItems; override;

  public
    constructor Create(anOwner: TComponent); override;

    procedure AddItem(aCaption: String; anObject: TObject); override;
    function  GetNextItem(StartItem: TCCRCustomListItem;
      Direction: TSearchDirection; States: TItemStates): TCCRListItem;

    property ItemFocused: TCCRListItem                read    getItemFocused
                                                      write   setItemFocused;

    property Items: TCCRListItems                     read    getItems;

    property Selected: TCCRListItem                   read    getSelected
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
    property Columns;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatScrollBars;
    property Font;
    //property FullDrag;
    property GridLines                                default False;
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
    property RowSelect;
    property ShowColumnHeaders                        default True;
    property ShowHint;
    property ShowWorkAreas;
    property SmallImages;
    //property SortType;
    property StateImages;
    property TabOrder;
    property TabStop                                  default True;
    property ViewStyle;
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

    property OnFieldValueGet: TCCRGetFieldValueEvent  read    fOnFieldValueGet
                                                      write   fOnFieldValueGet;
    property SortDescending default False;
    property SortField default -1;

  end;

implementation

///////////////////////////////// TCCRListItem \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function TCCRListItem.getFieldValue(const aFieldIndex: Integer;
  var anInternalValue: Variant): String;
begin
  Result := '';
  anInternalValue := Unassigned;
  if (aFieldIndex >= 0) and (aFieldIndex < ListView.Columns.Count) then
    if Assigned(ListView.OnFieldValueGet) then
      ListView.OnFieldValueGet(ListView, Self, aFieldIndex, Result, anInternalValue)
    else
      begin
        Result := StringValues[aFieldIndex];
        //--- By default, internal value = external value
        anInternalValue := Result;
      end;
end;

function TCCRListItem.getListView: TCCRListView;
begin
  Result := inherited ListView as TCCRListView;
end;

////////////////////////////////// TCCRListItems \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

function TCCRListItems.Add: TCCRListItem;
begin
  Result := TCCRListItem(inherited Add);
end;

function TCCRListItems.AddItem(anItem: TCCRListItem; anIndex: Integer): TCCRListItem;
begin
  Result := TCCRListItem(inherited AddItem(anItem, anIndex));
end;

function TCCRListItems.AddObject(const aCaption: String; anObject: TObject): TCCRListItem;
begin
  Result := Add;
  with Result do
    begin
      Caption := aCaption;
      Data := anObject;
      UpdateStringValues;
    end;
end;

function TCCRListItems.getItem(anIndex: Integer): TCCRListItem;
begin
  Result := inherited Item[anIndex] as TCCRListItem;
end;

function TCCRListItems.Insert(anIndex: Integer): TCCRListItem;
begin
  Result := TCCRListItem(inherited Insert(anIndex));
end;

procedure TCCRListItems.setItem(anIndex: Integer; const aValue: TCCRListItem);
begin
  Item[anIndex].Assign(aValue);
end;

////////////////////////////////// TCCRListView \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRListView.Create(anOwner: TComponent);
begin
  inherited;

  BevelKind         := bkNone;
  GridLines         := False;
  ParentColor       := False;
  ReadOnly          := False;
  ShowColumnHeaders := True;
  TabStop           := True;
end;

procedure TCCRListView.AddItem(aCaption: String; anObject: TObject);
begin
  Items.AddObject(aCaption, anObject);
end;

function TCCRListView.CreateListItem: TListItem;
var
  LClass: TListItemClass;
begin
  LClass := TCCRListItem;
  if Assigned(OnCreateItemClass) then
    OnCreateItemClass(Self, LClass);
  Result := LClass.Create(Items);
end;

function TCCRListView.CreateListItems: TListItems;
begin
  Result := TCCRListItems.Create(self);
end;

function TCCRListView.getItemFocused: TCCRListItem;
begin
  Result := TCCRListItem(inherited ItemFocused);
end;

function TCCRListView.getItems: TCCRListItems;
begin
  Result := inherited Items as TCCRListItems;
end;

function TCCRListView.GetNextItem(StartItem: TCCRCustomListItem;
  Direction: TSearchDirection; States: TItemStates): TCCRListItem;
begin
  Result := TCCRListItem(inherited GetNextItem(StartItem, Direction, States));
end;

function TCCRListView.getSelected: TCCRListItem;
begin
  Result := TCCRListItem(inherited Selected);
end;

procedure TCCRListView.setItemFocused(aValue: TCCRListItem);
begin
  inherited ItemFocused := aValue;
end;

procedure TCCRListView.setSelected(aValue: TCCRListItem);
begin
  inherited Selected := aValue;
end;

end.

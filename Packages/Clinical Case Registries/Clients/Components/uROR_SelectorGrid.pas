unit uROR_SelectorGrid;

interface
{$IFNDEF NOTMSPACK}

uses
  Forms, Classes, Controls, Buttons, uROR_GridView, Graphics, Types,
  uROR_AdvColGrid, uROR_Selector, uROR_CustomSelector, OvcFiler;

type

  TCCRResultGrid = class(TCCRAdvColGrid)
  protected
    procedure DblClick; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

  end;

  TCCRSelectorGrid = class(TCCRCustomSelector)
  private

  protected
    procedure DoUpdateButtons(var EnableAdd, EnableAddAll,
      EnableRemove, EnableRemoveAll: Boolean); override;
    function  getResultList: TCCRResultGrid;
    function  getSourceList: TCCRSourceList;

  public
    constructor Create(anOwner: TComponent); override;

    procedure Add; override;
    procedure AddAll; override;
    procedure AddSelectedItems; virtual;
    procedure Clear; override;
    function  CreateResultList: TWinControl; override;
    function  CreateSourceList: TWinControl; override;
    procedure LoadLayout(aStorage: TOvcAbstractStore; aSection: String = ''); override;
    procedure Remove; override;
    procedure RemoveAll; override;
    procedure RemoveSelectedItems; virtual;
    procedure SaveLayout(aStorage: TOvcAbstractStore; aSection: String = ''); override;

  published
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    property BevelInner default bvNone;
    property BevelOuter default bvNone;
    property BevelWidth;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    //property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    //property UseDockManager default True;
    //property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    //property Locked;
    property ParentBiDiMode;
    {$IFDEF VERSION7}
    property ParentBackground;
    {$ENDIF}
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    //property OnDockDrop;
    //property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    //property OnUnDock;

    property AddRemoveMode;
    property AutoSort;
    property CustomAdd;
    property CustomRemove;
    property IDField;
    property OnAdd;
    property OnAddAll;
    property OnRemove;
    property OnRemoveAll;
    property OnSplitterMove;
    property OnUpdateButtons;
    property SplitPos;

    property ResultList: TCCRResultGrid             read    getResultList;

    property SourceList: TCCRSourceList             read    getSourceList;

  end;

{$ENDIF}
implementation
{$IFNDEF NOTMSPACK}

uses
  Dialogs, SysUtils, uROR_Resources, ComCtrls, Windows, AdvGrid, Math;

///////////////////////////////// TCCRResultGrid \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRResultGrid.DblClick;
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRCustomSelector) then
    TCCRCustomSelector(Owner).Remove;
end;

procedure TCCRResultGrid.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Source <> Self then
    if (Source is TControl) and (TControl(Source).Owner = Owner) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        TCCRCustomSelector(Owner).Add;
end;

procedure TCCRResultGrid.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  if Source <> Self then
    if (Source is TControl) and (TControl(Source).Owner = Owner) then
      begin
        Accept := True;
        if Assigned(OnDragOver) then
          inherited;
      end;
end;

procedure TCCRResultGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Shift = [] then
    if (Key = VK_RETURN) or (Key = Word(' ')) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        begin
          TCCRCustomSelector(Owner).Remove;
          Repaint;  // To force repainting the current cell
        end;
end;

//////////////////////////////// TCCRSelectorGrid \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRSelectorGrid.Create(anOwner: TComponent);
begin
  inherited;

  with ResultList do
    begin
      DefaultRowHeight := 18;
      MouseActions.DisjunctRowSelect := True;
      MouseActions.RowSelect := True;
    end;

  with SourceList do
    begin
      MultiSelect := True;
      ReadOnly    := True;
    end;
end;

procedure TCCRSelectorGrid.Add;
begin
  if Assigned(SourceList.Selected) then
    begin
      inherited;
      //--- Default processing
      if not CustomAdd then
        AddSelectedItems;

      //--- Custom event handler
      if Assigned(OnAdd) then
        OnAdd(Self);

      //--- Common post-processing
      ResultChanged := True;
    end;
end;

procedure TCCRSelectorGrid.AddAll;
begin
  inherited;
  //--- Default processing
  if not CustomAdd then
    begin
      SourceList.SelectAll;
      AddSelectedItems;
    end;

  //--- Custom event handler
  if Assigned(OnAddAll) then
    OnAddAll(Self);

  //--- Common post-processing
  ResultChanged := True;
end;

procedure TCCRSelectorGrid.AddSelectedItems;
  procedure copy_items;
  var
    srci: TCCRGridItem;
    oldCursor: TCursor;
    restoreCursor: Boolean;
    itemId, rawData: String;
    fldLst, rdpLst: array of Integer;
    i, n: Integer;
  begin
    oldCursor := Screen.Cursor;
    if SourceList.SelCount > 30 then
      begin
        Screen.Cursor := crHourGlass;
        restoreCursor := True;
      end
    else
      restoreCursor := False;

    n := Min(SourceList.Fields.Count, ResultList.AllColCount) - 1;
    SetLength(fldLst, n+1);
    SetLength(rdpLst, n+1);
    for i:=0 to n do
      begin
        fldLst[i] := i;
        rdpLst[i] := i + 1;
      end;

    ResultList.BeginUpdate;
    try
      srci := SourceList.Selected;
      while Assigned(srci) do
        begin
          itemId := srci.AsString[IDField];
          if itemId <> '' then
            i := ResultList.FindString(itemId, IDField)
          else
            i := -1;
          if (itemId = '') or (i < 0) then
            begin
              rawData := srci.GetRawData(fldLst);
              ResultList.AddRow;
              ResultList.AssignRawData(ResultList.RowCount-1, rawData, rdpLst);
            end;
          srci := SourceList.GetNextItem(srci, sdAll, [isSelected]);
        end;
      if AutoSort then
        ResultList.QSort;
    finally
      ResultList.EndUpdate;
      if restoreCursor then
        Screen.Cursor := oldCursor;
      SetLength(fldLst, 0);
      SetLength(rdpLst, 0);
    end;
  end;

var
  next: TCCRGridItem;
begin
  if SourceList.SelCount > 0 then
    begin
      SourceList.Items.BeginUpdate;
      try
        copy_items;
        //--- Find the first item after selection
        next := SourceList.Items[SourceList.Items.Count-1];
        next := TCCRGridItem(GetListItemFollowingSelection(next));
        //--- Remove the selected items from the list or unselect them
        if AddRemoveMode = armDefault then
          SourceList.DeleteSelected
        else
          SourceList.ClearSelection;
        //--- Select the item
        if Assigned(next) then
          begin
            SourceList.Selected := next;
            SourceList.ItemFocused := SourceList.Selected;
          end
        else if SourceList.Items.Count > 0 then
          begin
            SourceList.Selected := SourceList.Items[SourceList.Items.Count-1];
            SourceList.ItemFocused := SourceList.Selected;
          end;
      finally
        SourceList.Items.EndUpdate;
      end;
    end;
end;

procedure TCCRSelectorGrid.Clear;
begin
  inherited;
  SourceList.Clear;
  ResultList.RemoveAll;
end;

function TCCRSelectorGrid.CreateResultList: TWinControl;
begin
  Result := TCCRResultGrid.Create(Self);
end;

function TCCRSelectorGrid.CreateSourceList: TWinControl;
begin
  Result := TCCRSourceList.Create(Self);
end;

procedure TCCRSelectorGrid.DoUpdateButtons(var EnableAdd, EnableAddAll,
  EnableRemove, EnableRemoveAll: Boolean);
begin
  inherited;
  if SourceList.Items.Count > 0 then
    begin
      EnableAdd    := Assigned(SourceList.Selected);
      EnableAddAll := True;
    end
  else
    begin
      EnableAdd    := False;
      EnableAddAll := False;
    end;
  if ResultList.RowCount > ResultList.FixedRows then
    begin
      EnableRemove    := ResultList.RowSelectCount > 0;
      EnableRemoveAll := True;
    end
  else
    begin
      EnableRemove    := False;
      EnableRemoveAll := False;
    end;
end;

function TCCRSelectorGrid.getResultList: TCCRResultGrid;
begin
  Result := TCCRResultGrid(GetResultControl);
end;

function TCCRSelectorGrid.getSourceList: TCCRSourceList;
begin
  Result := TCCRSourceList(GetSourceControl);
end;

procedure TCCRSelectorGrid.LoadLayout(aStorage: TOvcAbstractStore; aSection: String);
var
  sn: String;
begin
  if aSection <> '' then
    sn := aSection
  else
    sn := Name;

  try
    aStorage.Open;
    try
      SourceList.LoadLayout(aStorage, sn);
      ResultList.LoadLayout(aStorage, sn);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRSelectorGrid.Remove;
begin
  if ResultList.RowSelectCount > 0 then
    begin
      inherited;
      //--- Default processing
      if not CustomRemove then
        RemoveSelectedItems;

      //--- Custom event handler
      if Assigned(OnRemove) then
        OnRemove(Self);

      //--- Common post-processing
      ResultChanged := True;
    end;
end;

procedure TCCRSelectorGrid.RemoveAll;
begin
  inherited;
  //--- Default processing
  if not CustomRemove then
    begin
      with ResultList do
        SelectRows(FixedRows, RowCount-FixedRows);
      RemoveSelectedItems;
    end;

  //--- Custom event handler
  if Assigned(OnRemoveAll) then
    OnRemoveAll(Self);

  //--- Common post-processing
  ResultChanged := True;
end;

procedure TCCRSelectorGrid.RemoveSelectedItems;

  procedure copy_items;
  var
    oldCursor: TCursor;
    restoreCursor: Boolean;
    fldLst, rdpLst: array of Integer;
    dstRow, i, n: Integer;
    itemId, rawData: String;
    srci: TCCRGridItem;
  begin
    oldCursor := Screen.Cursor;
    if ResultList.RowSelectCount > 30 then
      begin
        Screen.Cursor := crHourGlass;
        restoreCursor := True;
      end
    else
      restoreCursor := False;

    n := Min(SourceList.Fields.Count, ResultList.AllColCount) - 1;
    SetLength(fldLst, n+1);
    SetLength(rdpLst, n+1);
    for i:=0 to n do
      begin
        fldLst[i] := i;
        rdpLst[i] := i + 1;
      end;

    SourceList.Items.BeginUpdate;
    try
      n := ResultList.AllRowCount - 1;
      with ResultList do
        for dstRow:=RealRowIndex(FixedRows) to n do
          if RowSelect[DisplRowIndex(dstRow)] then
            begin
              itemId := AllCells[IDField,dstRow];
              if (itemId = '') or (SourceList.FindString(itemId, IDField) = nil) then
                begin
                  rawData := GetRawData(dstRow, fldLst);
                  srci := SourceList.Items.Add;
                  srci.AssignRawData(rawData, rdpLst);
                end;
            end;
      if AutoSort then
        SourceList.AlphaSort;
    finally
      SourceList.Items.EndUpdate;
      if restoreCursor then
        Screen.Cursor := oldCursor;
      SetLength(fldLst, 0);
      SetLength(rdpLst, 0);
    end;
  end;

begin
  if ResultList.RowSelectCount > 0 then
    begin
      ResultList.BeginUpdate;
      try
        if AddRemoveMode = armDefault then
          copy_items;
        ResultList.RemoveSelectedRows;
      finally
        ResultList.EndUpdate;
      end;
    end;
end;

procedure TCCRSelectorGrid.SaveLayout(aStorage: TOvcAbstractStore; aSection: String);
var
  sn: String;
begin
  if aSection <> '' then
    sn := aSection
  else
    sn := Name;

  try
    aStorage.Open;
    try
      SourceList.SaveLayout(aStorage, sn);
      ResultList.SaveLayout(aStorage, sn);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

{$ENDIF}
end.

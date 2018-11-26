unit uROR_SelectorTree;
{$I Components.inc}

interface
{$IFNDEF NOVTREE}

uses
  Forms, Buttons, Classes, Controls, Windows, uROR_GridView, OvcFiler,
  uROR_CustomSelector, ComCtrls, VirtualTrees, uROR_Utilities, Messages,
  uROR_TreeGrid, ActiveX, uROR_Selector;

type

  TCCRResultTree = class(TCCRTreeGrid)
  protected
    procedure DoDragDrop(Source: TObject; DataObject: IDataObject;
      Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
      var Effect: Integer; Mode: TDropMode); override;
    function DoDragOver(Source: TObject; Shift: TShiftState; State: TDragState;
      Pt: TPoint; Mode: TDropMode; var Effect: Integer): Boolean; override;
    procedure DoEnter; override;
    function  DoKeyAction(var CharCode: Word; var Shift: TShiftState): Boolean; override;
    procedure DoStructureChange(Node: PVirtualNode; Reason: TChangeReason); override;
    procedure HandleMouseDblClick(var Message: TWMMouse; const HitInfo: THitInfo); override;

  public
    procedure Clear; override;

  end;

  TCCRSelectorTree = class(TCCRCustomSelector)
  private
    function  getResultTree: TCCRResultTree;
    function  getSourceList: TCCRSourceList;

  protected
    function  CreateResultList: TWinControl; override;
    function  CreateSourceList: TWinControl; override;
    procedure DoUpdateButtons(var EnableAdd, EnableAddAll, EnableRemove,
      EnableRemoveAll: Boolean); override;

  public
    constructor Create(anOwner: TComponent); override;
    
    procedure Add; override;
    procedure AddAll; override;
    procedure AddSelectedItems; virtual;
    procedure Clear; override;
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
    property OnAdd;
    property OnAddAll;
    property OnRemove;
    property OnRemoveAll;
    property OnSplitterMove;
    property OnUpdateButtons;
    property SplitPos;

    property ResultTree: TCCRResultTree             read    getResultTree;

    property SourceList: TCCRSourceList             read    getSourceList;

  end;

{$ENDIF}
implementation
{$IFNDEF NOVTREE}

///////////////////////////////// TCCRResultTree \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRResultTree.Clear;
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRCustomSelector) then
    TCCRCustomSelector(Owner).ResultChanged := True;
end;

procedure TCCRResultTree.DoDragDrop(Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
  var Effect: Integer; Mode: TDropMode);
begin
  if Source is TCCRSelectorList then
    if Assigned(Owner) and (Owner is TCCRSelectorTree) then
      TCCRSelectorTree(Owner).Add;
end;

function TCCRResultTree.DoDragOver(Source: TObject; Shift: TShiftState;
State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer): Boolean;
var
  hitInfo: THitInfo;
begin
  Result := False;
  if Source is TCCRSelectorList then
    if TCCRSelectorList(Source).Owner = Owner then
      begin
        Result := True;
        if Assigned(OnDragOver) then
          Result := inherited DoDragOver(Source, Shift, State, Pt, Mode, Effect);
        if Result then
          begin
            GetHitTestInfoAt(Pt.X, Pt.Y, True, hitInfo);
            if Assigned(hitInfo.HitNode) then
              begin
                ClearSelection;
                Selected[hitInfo.HitNode] := True;
              end;
          end;
      end;
end;

procedure TCCRResultTree.DoEnter;
begin
  inherited;
  if not Assigned(FocusedNode) then
    FocusedNode := GetFirstChild(nil);
end;

function TCCRResultTree.DoKeyAction(var CharCode: Word; var Shift: TShiftState): Boolean;
begin
  Result := inherited DoKeyAction(CharCode, Shift);
  if not Result then
    Exit;

  if Shift = [] then
    if (CharCode = VK_RETURN) or (CharCode = Word(' ')) then
      if Assigned(Owner) and (Owner is TCCRSelectorTree) then
        TCCRSelectorTree(Owner).Remove;
end;

procedure TCCRResultTree.DoStructureChange(Node: PVirtualNode; Reason: TChangeReason);
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRCustomSelector) then
    TCCRCustomSelector(Owner).ResultChanged := True;
end;

procedure TCCRResultTree.HandleMouseDblClick(var Message: TWMMouse; const HitInfo: THitInfo);
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRSelectorTree) then
    TCCRSelectorTree(Owner).Remove;
end;

//////////////////////////////// TCCRSelectorTree \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRSelectorTree.Create(anOwner: TComponent);
begin
  inherited;

  with SourceList do
    begin
      MultiSelect := True;
      ReadOnly    := True;
    end;

  with ResultTree do
    begin
      DragType    := dtVCL;
      with TreeOptions do
        begin
          SelectionOptions := SelectionOptions + [toMultiSelect];
          MiscOptions := MiscOptions - [toReadOnly];
        end;
    end;
end;

procedure TCCRSelectorTree.Add;
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

procedure TCCRSelectorTree.AddAll;
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

procedure TCCRSelectorTree.AddSelectedItems;
var
  next: TCCRGridItem;
begin
  SourceList.Items.BeginUpdate;
  try
//    CopySelectedItems(SrcGrid, DstTree);
    if AutoSort then
      ResultTree.SortData;
    if SourceList.SelCount > 0 then
      begin
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
      end;
  finally
    SourceList.Items.EndUpdate;
  end;
end;

procedure TCCRSelectorTree.Clear;
begin
  inherited;
  SourceList.Clear;
  ResultTree.Clear;
end;
{
procedure TCCRSelectorTree.CopySelectedItems(SrcLst, DstLst: TCCRSelectorList);
var
  dsti, srci: TCCRGridItem;
  oldCursor: TCursor;
  restoreCursor: Boolean;
begin
  oldCursor := Screen.Cursor;
  if SrcLst.SelCount > 30 then
    begin
      Screen.Cursor := crHourGlass;
      restoreCursor := True;
    end
  else
    restoreCursor := False;

  DstLst.Items.BeginUpdate;
  try
    srci := SrcLst.Selected;
    while Assigned(srci) do
      begin
        if (srci.Caption = '') or
          (DstLst.FindCaption(0, srci.Caption, False, True, False) = nil) then
          begin
            dsti := DstLst.Items.Add;
            dsti.Assign(srci);
          end;
        srci := SrcLst.GetNextItem(srci, sdAll, [isSelected]);
      end;
  finally
    DstLst.Items.EndUpdate;
    if restoreCursor then
      Screen.Cursor := oldCursor;
  end;
end;
}

function TCCRSelectorTree.CreateResultList: TWinControl;
begin
  Result := TCCRResultTree.Create(Self);
end;

function TCCRSelectorTree.CreateSourceList: TWinControl;
begin
  Result := TCCRSourceList.Create(Self);
end;

procedure TCCRSelectorTree.DoUpdateButtons(var EnableAdd, EnableAddAll,
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
  if ResultTree.hasChildren[ResultTree.RootNode] then
    begin
      EnableRemove    := (ResultTree.SelectedCount > 0);
      EnableRemoveAll := True;
    end
  else
    begin
      EnableRemove    := False;
      EnableRemoveAll := False;
    end;
end;

function TCCRSelectorTree.getResultTree: TCCRResultTree;
begin
  Result := TCCRResultTree(GetResultControl);
end;

function TCCRSelectorTree.getSourceList: TCCRSourceList;
begin
  Result := TCCRSourceList(GetSourceControl);
end;

procedure TCCRSelectorTree.LoadLayout(aStorage: TOvcAbstractStore; aSection: String);
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
      ResultTree.LoadLayout(aStorage, sn);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

procedure TCCRSelectorTree.Remove;
begin
  if ResultTree.SelectedCount > 0 then
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

procedure TCCRSelectorTree.RemoveAll;
begin
  inherited;
  //--- Default processing
  if not CustomRemove then
    begin
      ResultTree.SelectAll(False);
      RemoveSelectedItems;
    end;

  //--- Custom event handler
  if Assigned(OnRemoveAll) then
    OnRemoveAll(Self);

  //--- Common post-processing
  ResultChanged := True;
end;

procedure TCCRSelectorTree.RemoveSelectedItems;
begin
end;

procedure TCCRSelectorTree.SaveLayout(aStorage: TOvcAbstractStore; aSection: String);
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
      ResultTree.SaveLayout(aStorage, sn);
    finally
      aStorage.Close;
    end;
  except
  end;
end;

{
procedure TCCRSelectorTree.TransferSelectedItems(SrcLst, DstLst: TCCRSelectorList);
var
  next: TCCRGridItem;
begin
  SrcLst.Items.BeginUpdate;
  try
    if (SrcLst = SourceList) or (AddRemoveMode = armDefault) then
      CopySelectedItems(SrcLst, DstLst);
    if AutoSort then
      DstLst.AlphaSort;
    if SrcLst.SelCount > 0 then
      begin
        //--- Find the last selected item
        next := SrcLst.Items[SrcLst.Items.Count-1];
        if not next.Selected then
          next := SrcLst.GetNextItem(next, sdAbove, [isSelected]);
        //--- Find the next non-selected item
        if Assigned(next) then
          begin
            next := SrcLst.GetNextItem(next, sdBelow, [isNone]);
            if Assigned(next) then
              if next.Selected then next := nil;
          end;
        //--- Remove the selected items from the list or unselect them
        if (SrcLst = ResultTree) or (AddRemoveMode = armDefault) then
          SrcLst.DeleteSelected
        else
          SrcLst.ClearSelection;
        //--- Select the item
        if Assigned(next) then
          begin
            SrcLst.Selected := next;
            SrcLst.ItemFocused := SrcLst.Selected;
          end
        else if SrcLst.Items.Count > 0 then
          begin
            SrcLst.Selected := SrcLst.Items[SrcLst.Items.Count-1];
            SrcLst.ItemFocused := SrcLst.Selected;
          end;
      end;
  finally
    SrcLst.Items.EndUpdate;
  end;
end;
}

{$ENDIF}
end.

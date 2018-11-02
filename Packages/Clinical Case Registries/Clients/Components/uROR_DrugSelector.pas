unit uROR_DrugSelector;

interface
{$IFNDEF NOVTREE}

uses
  Forms, Classes, Controls, uROR_SelectorTree, Buttons, VirtualTrees,
  uROR_TreeGrid, uROR_GridView, Graphics, Types;

const
  //--- Columns

  idscIEN  = 0;
  idscName = 1;
  idscCode = 2;
  idscType = 3;

  //--- Tree Levels

  idslGroup   = 0;
  idslSection = 1;
  idslItem    = 2;

  //--- Node Types

  idstGeneric     =   1;
  idstFormulation =   2;
  idstDrugClass   =   3;

  idstSpecial     = 100;
  idstInvestig    = 101;
  idstRegistry    = 102;

type

  TCCRDrugSelectorTree = class;

  TCCRDrugSelector = class(TCCRSelectorTree)
  private
    fSourceType:  Integer;

    function  getResultTree: TCCRDrugSelectorTree;

  protected
    function  CreateResultList: TWinControl; override;
    procedure DoUpdateButtons(var EnableAdd, EnableAddAll,
      EnableRemove, EnableRemoveAll: Boolean); override;
    procedure Loaded; override;
    procedure ResultTreeCheckingHandler(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure ResultTreePaintTextHandler(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure ResultTreeSelectionHandler(Sender: TBaseVirtualTree;
       Node: PVirtualNode);
    procedure ResultTreeSortHandler(aSender: TCCRTreeGrid;
      var aColumn: TColumnIndex; var aDirection: TSortDirection);

  public
    constructor Create(anOwner: TComponent); override;

    procedure AddSelectedItems; override;
    procedure Clear; override;
    procedure RemoveSelectedItems; override;

    property ResultTree: TCCRDrugSelectorTree       read    getResultTree;

    property SourceType: Integer                    read    fSourceType
                                                    write   fSourceType;

  end;

  TCCRDrugSelectorTree = class(TCCRResultTree)
  private
    HasItems:     Boolean;
    InvestigMeds: PVirtualNode;
    RegistryMeds: PVirtualNode;

  protected
    function  DoDragOver(Source: TObject; Shift: TShiftState; State: TDragState;
      Pt: TPoint; Mode: TDropMode; var Effect: Integer): Boolean; override;

  public
    constructor Create(anOwner: TComponent); override;

    function  AddGroup(const aGroupName: String): PVirtualNode;
    function  AddItem(aParent: PVirtualNode; const aName: String;
      const aType: Integer = 0): PVirtualNode;
    procedure Clear; override;
    procedure DeleteGroup(aNode: PVirtualNode);
    procedure DeleteItem(aNode: PVirtualNode);
    procedure EndUpdate;
    function  FindGroup(const aName: String): PVirtualNode;
    function  GetFirstResultItem: PVirtualNode;
    function  GetGroup(aNode: PVirtualNode): PVirtualNode;
    function  GetSection(aGroup: PVirtualNode; const aType: Integer): PVirtualNode;

  end;

{$ENDIF}
implementation
{$IFNDEF NOVTREE}

uses
  Dialogs, SysUtils, uROR_Resources, ComCtrls, uROR_CustomSelector;

//////////////////////////////// TCCRDrugSelector \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRDrugSelector.Create(anOwner: TComponent);
begin
  inherited;

  with SourceList do
    begin
      SortField := -1;
      SortField := idscName;
    end;

  with ResultTree do
    begin
      with Header do
        begin
          Options := Options + [hoVisible,hoShowSortGlyphs];
          SortColumn  := idscName;
        end;

      with TreeOptions do
        begin
          AutoOptions  := AutoOptions  + [toAutoSpanColumns];
          MiscOptions  := MiscOptions  - [toAcceptOLEDrop];
          MiscOptions  := MiscOptions  + [toCheckSupport,toReportMode];
          PaintOptions := PaintOptions + [toShowHorzGridLInes,toShowVertGridLInes];
        end;

      OnChange    := ResultTreeSelectionHandler;
      OnChecking  := ResultTreeCheckingHandler;
      OnPaintText := ResultTreePaintTextHandler;
      OnSort      := ResultTreeSortHandler;
    end;

  ResultChanged := False;
end;

procedure TCCRDrugSelector.AddSelectedItems;

  procedure copy_items(aSection: PVirtualNode; fldLst: array of Integer);
  var
    srci: TCCRGridItem;
    dsti: PVirtualNode;
    oldCursor: TCursor;
    restoreCursor: Boolean;
    itemId: String;
    i: Integer;
  begin
    oldCursor := Screen.Cursor;
    if SourceList.SelCount > 30 then
      begin
        Screen.Cursor := crHourGlass;
        restoreCursor := True;
      end
    else
      restoreCursor := False;

    ResultTree.BeginUpdate;
    try
      srci := SourceList.Selected;
      while Assigned(srci) do
        begin
          itemId := srci.AsString[idscIEN];
          if (itemId = '') or (ResultTree.Find(itemId, idscIEN, aSection) = nil) then
            begin
              dsti := ResultTree.AddItem(aSection, srci.AsString[idscName]);
              ResultTree.AsString[dsti,idscIEN] := itemId;
              for i:=0 to High(fldLst) do
                ResultTree.AsString[dsti,fldLst[i]] := srci.AsString[fldLst[i]];
            end;
          srci := SourceList.GetNextItem(srci, sdAll, [isSelected]);
        end;
    finally
      ResultTree.EndUpdate;
      if restoreCursor then
        Screen.Cursor := oldCursor;
    end;
  end;

var
  groupNode, sectionNode: PVirtualNode;
  next: TCCRGridItem;

begin
  if SourceList.SelCount = 0 then
    Exit;

  groupNode := ResultTree.GetGroup(ResultTree.FocusedNode);
  if not Assigned(groupNode) then
    begin
      groupNode := ResultTree.GetFirstChild(nil);
      if not Assigned(groupNode) then
        Exit;
    end;

  sectionNode := ResultTree.GetSection(groupNode, SourceType);
  if not Assigned(sectionNode) then
    Exit;

  SourceList.Items.BeginUpdate;
  try
    if SourceType = idstDrugClass then
      copy_items(sectionNode, [idscCode])
    else
      copy_items(sectionNode, []);

    if AutoSort then
      ResultTree.SortData;
    with ResultTree do
      begin
        FullCollapse;
        Expanded[sectionNode] := True;
      end;

    with SourceList do
      begin
        //--- Find the first item after selection
        next := TCCRGridItem(GetListItemFollowingSelection(Items[Items.Count-1]));
        //--- Remove the selected items from the source list
        DeleteSelected;
        //--- Select the item
        if Assigned(next) then
          begin
            Selected := next;
            ItemFocused := Selected;
          end
        else if Items.Count > 0 then
          begin
            Selected := Items[Items.Count-1];
            ItemFocused := Selected;
          end;
      end;
  finally
    SourceList.Items.EndUpdate;
  end;
end;

procedure TCCRDrugSelector.Clear;
begin
  inherited;
  if Assigned(ResultTree) then
    with ResultTree do
      begin
        BeginUpdate;
        try
          AddGroup('Medications');
          FullExpand;
        finally
          EndUpdate;
        end;
      end;
end;

function TCCRDrugSelector.CreateResultList: TWinControl;
begin
  Result := TCCRDrugSelectorTree.Create(Self);
end;

procedure TCCRDrugSelector.DoUpdateButtons(var EnableAdd, EnableAddAll,
  EnableRemove, EnableRemoveAll: Boolean);
begin
  inherited;
  with ResultTree do
    begin
      EnableRemove     := HasItems and (SelectedCount > 0);
      EnableRemoveAll  := HasItems;
      if GetFirstChild(RootNode) = nil then
        begin
          EnableAdd    := False;
          EnableAddAll := False;
        end;
    end;
end;

function TCCRDrugSelector.getResultTree: TCCRDrugSelectorTree;
begin
  Result := TCCRDrugSelectorTree(GetResultControl);
end;

procedure TCCRDrugSelector.Loaded;
begin
  inherited;
  with SourceList.Fields do
    if Count = 0 then
      begin
        with TCCRGridField(Add) do
          begin
            Caption := 'ID';
            Visible := False;
          end;
        with TCCRGridField(Add) do
          begin
            Caption := 'Name';
            Width := 150;
          end;
        with TCCRGridField(Add) do
          begin
            Caption := 'Code';
            DataType := gftMUMPS;
            Width := 100;
          end;
      end;

  with ResultTree.Header do
    if Columns.Count = 0 then
      begin
        with TCCRTreeGridColumn(Columns.Add) do
          begin
            Text := 'ID';
            Options := Options - [coVisible];
          end;
        with TCCRTreeGridColumn(Columns.Add) do
          begin
            Text := 'Name';
            Width := 200;
          end;
        with TCCRTreeGridColumn(Columns.Add) do
          begin
            Text := 'Code';
            DataType := gftMUMPS;
            Width := 100;
          end;
        with TCCRTreeGridColumn(Columns.Add) do
          begin
            Text := 'Type';
            DataType := gftInteger;
            Options := Options - [coVisible];
          end;
        MainColumn := idscName;
      end;
end;

procedure TCCRDrugSelector.RemoveSelectedItems;

  function next_item(aNode: PVirtualNode): PVirtualNode;
  begin
    with ResultTree do
      begin
        Result := GetNext(aNode);
        while Assigned(Result) do
          if (GetNodeLevel(Result) = idslItem) and
            (AsInteger[Result,idscType] < idstSpecial) then Break
          else
            Result := GetNext(Result);
      end;
  end;

  function prev_item(aNode: PVirtualNode): PVirtualNode;
  begin
    with ResultTree do
      begin
        Result := GetPrevious(aNode);
        while Assigned(Result) do
          if (GetNodeLevel(Result) = idslItem) and
            (AsInteger[Result,idscType] < idstSpecial) then Break
          else
            Result := GetPrevious(Result);
      end;
  end;

var
  last, nextSel, node, snode: PVirtualNode;
begin
  if ResultTree.SelectedCount = 0 then
    Exit;

  ResultTree.BeginUpdate;
  try
    with ResultTree do
      begin
        //--- Find the last selected node
        last := nil;
        node := GetFirstSelected;
        while Assigned(node) do
          begin
            last := node;
            node := GetNextSelected(node);
          end;
        //--- Find item that will be selected
        if Assigned(last) then
          begin
            nextSel := next_item(last);
            if not Assigned(nextSel) then
              nextSel := prev_item(last);
          end
        else
          nextSel := nil;
        //---
        node := GetFirstSelected;
        while Assigned(node) do
          begin
            if AsInteger[node,idscType] < idstSpecial then
              case GetNodeLevel(node) of
                idslGroup:
                  begin
                    snode := GetFirstChild(node);
                    while Assigned(snode) do
                      begin
                        Selected[snode] := False;
                        if AsInteger[snode,idscType] < idstSpecial then
                          DeleteChildren(snode, True);
                        snode := GetNextSibling(snode);
                      end;
                  end;
                idslSection:
                  DeleteChildren(node, True);
                idslItem:
                  begin
                    DeleteNode(node);
                    node := nil;
                  end;
              end;
            if Assigned(node) then
              Selected[node] := False;
            node := GetFirstSelected;
          end;
        //---
        ClearSelection;
        if Assigned(nextSel) then
          begin
            Selected[nextSel] := True;
            FocusedNode := nextSel;
            ScrollIntoView(nextSel, False);
          end;
      end;
  finally
    ResultTree.EndUpdate;
  end;
end;

procedure TCCRDrugSelector.ResultTreeCheckingHandler(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
var
  itemType: Integer;
begin
  with ResultTree do
    begin
      itemType := AsInteger[Node,idscType];
      if itemType = idstRegistry then
        begin
          if NewState = csUncheckedNormal then
            RegistryMeds := nil
          else if NewState = csCheckedNormal then
            if Assigned(RegistryMeds) then
              begin
                Allowed := False;
                MessageDlg(Format(RSC0030,
                  [AsString[Node,idscName],AsString[RegistryMeds,idscName]]),
                  mtInformation, [mbOK], 0);
              end
            else
              RegistryMeds := GetGroup(Node);
        end
      else if itemType = idstInvestig then
        begin
          if NewState = csUncheckedNormal then
            InvestigMeds := nil
          else if NewState = csCheckedNormal then
            if Assigned(InvestigMeds) then
              begin
                Allowed := False;
                MessageDlg(Format(RSC0030,
                  [AsString[Node,idscName],AsString[InvestigMeds,idscName]]),
                  mtInformation, [mbOK], 0);
              end
            else
              InvestigMeds := GetGroup(Node);
        end;
    end;
end;

procedure TCCRDrugSelector.ResultTreePaintTextHandler(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender.GetNodeLevel(Node) <= idslSection then
    TargetCanvas.Font.Style := [fsBold];
end;

procedure TCCRDrugSelector.ResultTreeSelectionHandler(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  with ResultTree do
    if Assigned(Node) and Selected[Node] then
      if AsInteger[Node,idscType] >= idstSpecial then
        Selected[Node] := False;
end;

procedure TCCRDrugSelector.ResultTreeSortHandler(aSender: TCCRTreeGrid;
  var aColumn: TColumnIndex; var aDirection: TSortDirection);
var
  vn: PVirtualNode;
begin
  with ResultTree do
    begin
      vn := GetFirst();
      while Assigned(vn) do
        begin
          if GetNodeLevel(vn) = idslSection then
            Sort(vn, aColumn, aDirection);
          vn := GetNext(vn);
        end;
    end;
end;

////////////////////////////// TCCRDrugSelectorTree \\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRDrugSelectorTree.Create(anOwner: TComponent);
begin
  inherited;
  Clear;
end;

function TCCRDrugSelectorTree.AddGroup(const aGroupName: String): PVirtualNode;
var
  vn, sn: PVirtualNode;
begin
  BeginUpdate;
  try
    Result := AddChild(RootNode);
    AsString[Result,idscName] := aGroupName;

    sn := AddChild(Result);
    AsString[sn,idscName]  := 'Individual Formulations';
    AsInteger[sn,idscType] := idstFormulation;

    sn := AddChild(Result);
    AsString[sn,idscName]  := 'Generic';
    AsInteger[sn,idscType] := idstGeneric;

    sn := AddChild(Result);
    AsString[sn,idscName]  := 'Drug Classes';
    AsInteger[sn,idscType] := idstDrugClass;

    sn := AddChild(Result);
    AsString[sn,idscName]  := 'Registry Specific';
    AsInteger[sn,idscType] := idstSpecial;
    vn := AddItem(sn, 'Registry Medications', idstRegistry);
    CheckType[vn] := ctCheckBox;
    vn := AddItem(sn, 'Investigational Drugs', idstInvestig);
    CheckType[vn] := ctCheckBox;

    FullCollapse;
    FullExpand(Result);
  finally
    EndUpdate;
  end;
end;

function TCCRDrugSelectorTree.AddItem(aParent: PVirtualNode; const aName: String;
  const aType: Integer): PVirtualNode;
begin
  Result := AddChild(aParent);
  AsString[Result,idscName]  := aName;
  AsInteger[Result,idscType] := aType;
  if aType = 0 then
    HasItems := True;
end;

procedure TCCRDrugSelectorTree.Clear;
begin
  inherited;
  HasItems := False;
  InvestigMeds := nil;
  RegistryMeds := nil
end;

procedure TCCRDrugSelectorTree.DeleteGroup(aNode: PVirtualNode);
begin
  if aNode = RegistryMeds then
    RegistryMeds := nil
  else if aNode = InvestigMeds then
    InvestigMeds := nil;
  DeleteNode(aNode);
  if UpdateCount = 0 then
    HasItems := (GetFirstResultItem <> nil);
end;

procedure TCCRDrugSelectorTree.DeleteItem(aNode: PVirtualNode);
begin
  if Assigned(aNode) then
    begin
      DeleteNode(aNode);
      if UpdateCount = 0 then
        HasItems := (GetFirstResultItem <> nil);
    end;
end;

function TCCRDrugSelectorTree.DoDragOver(Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer): Boolean;
begin
  Result := inherited DoDragOver(Source, Shift, State, Pt, Mode, Effect);
  if Result and (ChildCount[RootNode] = 0) then
    Result := False;
end;

procedure TCCRDrugSelectorTree.EndUpdate;
begin
  inherited;
  HasItems := (GetFirstResultItem <> nil);
end;

function TCCRDrugSelectorTree.FindGroup(const aName: String): PVirtualNode;
begin
  Result := GetFirstChild(RootNode);
  while Assigned(Result) do
    if AnsiSameText(AsString[Result,idscName], aName) then
      Break
    else
      Result := GetNextSibling(Result);
end;

function TCCRDrugSelectorTree.GetFirstResultItem: PVirtualNode;
begin
  Result := GetFirst;
  while Assigned(Result) do
    if (GetNodeLevel(Result) = idslItem) and (AsInteger[Result,idscType] < idstSpecial) then
      Break
    else
      Result := GetNext(Result);
end;

function TCCRDrugSelectorTree.GetGroup(aNode: PVirtualNode): PVirtualNode;
begin
  Result := aNode;
  while Assigned(Result) and (GetNodeLevel(Result) > 0) do
    Result := NodeParent[Result];
end;

function TCCRDrugSelectorTree.GetSection(aGroup: PVirtualNode; const aType: Integer): PVirtualNode;
begin
  if Assigned(aGroup) then
    begin
      if GetNodeLevel(aGroup) > idslGroup then
        aGroup := GetGroup(aGroup);
      Result := GetFirstChild(aGroup);
      while Assigned(Result) do
        if AsInteger[Result,idscType] = aType then
          Break
        else
          Result := GetNextSibling(Result);
    end
  else
    Result := nil;
end;

{$ENDIF}
end.

unit uROR_Selector;
{$I Components.inc}

interface

uses
  ComCtrls, Forms, Buttons, Classes, Controls, Windows,
  uROR_GridView, OvcFiler, uROR_CustomSelector;

type

  TCCRResultList = class(TCCRSelectorList)
  protected
    procedure DblClick; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

  public
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

  end;

  TCCRSelector = class(TCCRCustomSelector)
  private
    function  getResultList: TCCRResultList;
    function  getSourceList: TCCRSourceList;

  protected
    procedure DoUpdateButtons(var EnableAdd, EnableAddAll,
      EnableRemove, EnableRemoveAll: Boolean); override;

  public
    constructor Create(anOwner: TComponent); override;

    procedure Add; override;
    procedure AddAll; override;
    procedure Clear; override;
    procedure CopySelectedItems(SrcLst, DstLst: TCCRSelectorList);
    function  CreateResultList: TWinControl; override;
    function  CreateSourceList: TWinControl; override;
    procedure LoadLayout(aStorage: TOvcAbstractStore; aSection: String = ''); override;
    procedure MoveSelectedItems(SrcLst, DstLst: TCCRSelectorList);
    procedure Remove; override;
    procedure RemoveAll; override;
    procedure SaveLayout(aStorage: TOvcAbstractStore; aSection: String = ''); override;
    procedure TransferSelectedItems(SrcLst, DstLst: TCCRSelectorList);

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

    property ResultList: TCCRResultList             read    getResultList;

    property SourceList: TCCRSourceList             read    getSourceList;

  end;

implementation

///////////////////////////////// TCCRResultList \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRResultList.DblClick;
begin
  inherited;
  if Assigned(Owner) and (Owner is TCCRCustomSelector) then
    TCCRCustomSelector(Owner).Remove;
end;

procedure TCCRresultList.DragDrop(Source: TObject; X, Y: Integer);
begin
  if Source <> Self then
    if (Source is TControl) and (TControl(Source).Owner = Owner) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        TCCRCustomSelector(Owner).Add;
end;

procedure TCCRResultList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Shift = [] then
    if (Key = VK_RETURN) or (Key = Word(' ')) then
      if Assigned(Owner) and (Owner is TCCRCustomSelector) then
        TCCRCustomSelector(Owner).Remove;
end;

////////////////////////////////// TCCRSelector \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

constructor TCCRSelector.Create(anOwner: TComponent);
begin
  inherited;

  with SourceList do
    begin
      MultiSelect := True;
      ReadOnly    := True;
    end;

  with ResultList do
    begin
      MultiSelect := True;
      ReadOnly    := True;
    end;
end;

procedure TCCRSelector.Add;
begin
  if Assigned(SourceList.Selected) then
    begin
      inherited;
      //--- Default processing
      if not CustomAdd then
        TransferSelectedItems(SourceList, ResultList);

      //--- Custom event handler
      if Assigned(OnAdd) then
        OnAdd(Self);

      //--- Common post-processing
      ResultChanged := True;
    end;
end;

procedure TCCRSelector.AddAll;
begin
  inherited;
  //--- Default processing
  if not CustomAdd then
    begin
      SourceList.SelectAll;
      TransferSelectedItems(SourceList, ResultList);
    end;

  //--- Custom event handler
  if Assigned(OnAddAll) then
    OnAddAll(Self);

  //--- Common post-processing
  ResultChanged := True;
end;

procedure TCCRSelector.Clear;
begin
  inherited;
  SourceList.Clear;
  ResultList.Clear;
end;

procedure TCCRSelector.CopySelectedItems(SrcLst, DstLst: TCCRSelectorList);
var
  dsti, srci: TCCRGridItem;
  oldCursor: TCursor;
  restoreCursor: Boolean;
  itemId: String;
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
        itemId := srci.AsString[IDField];
        if (itemId = '') or
          (DstLst.FindCaption(0, itemId, False, True, False) = nil) then
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

function TCCRSelector.CreateResultList: TWinControl;
begin
  Result := TCCRResultList.Create(Self);
end;

function TCCRSelector.CreateSourceList: TWinControl;
begin
  Result := TCCRSourceList.Create(Self);
end;

procedure TCCRSelector.DoUpdateButtons(var EnableAdd, EnableAddAll,
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
  if ResultList.Items.Count > 0 then
    begin
      EnableRemove    := Assigned(ResultList.Selected);
      EnableRemoveAll := True;
    end
  else
    begin
      EnableRemove    := False;
      EnableRemoveAll := False;
    end;
end;

function TCCRSelector.getResultList: TCCRResultList;
begin
  Result := TCCRResultList(GetResultControl);
end;

function TCCRSelector.getSourceList: TCCRSourceList;
begin
  Result := TCCRSourceList(GetSourceControl);
end;

procedure TCCRSelector.LoadLayout(aStorage: TOvcAbstractStore; aSection: String);
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

procedure TCCRSelector.MoveSelectedItems(SrcLst, DstLst: TCCRSelectorList);
begin
  SrcLst.Items.BeginUpdate;
  try
    CopySelectedItems(SrcLst, DstLst);
    SrcLst.DeleteSelected;
  finally
    SrcLst.Items.EndUpdate;
  end;
end;

procedure TCCRSelector.Remove;
begin
  if Assigned(ResultList.Selected) then
    begin
      inherited;
      //--- Default processing
      if not CustomRemove then
        TransferSelectedItems(ResultList, SourceList);

      //--- Custom event handler
      if Assigned(OnRemove) then
        OnRemove(Self);

      //--- Common post-processing
      ResultChanged := True;
    end;
end;

procedure TCCRSelector.RemoveAll;
begin
  inherited;
  //--- Default processing
  if not CustomRemove then
    begin
      ResultList.SelectAll;
      TransferSelectedItems(ResultList, SourceList);
    end;

  //--- Custom event handler
  if Assigned(OnRemoveAll) then
    OnRemoveAll(Self);

  //--- Common post-processing
  ResultChanged := True;
end;

procedure TCCRSelector.SaveLayout(aStorage: TOvcAbstractStore; aSection: String);
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

procedure TCCRSelector.TransferSelectedItems(SrcLst, DstLst: TCCRSelectorList);
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
        //--- Find the first item after selection
        with SrcLst do
          next := TCCRGridItem(GetListItemFollowingSelection(Items[Items.Count-1]));
        //--- Remove the selected items from the list or unselect them
        if (SrcLst = ResultList) or (AddRemoveMode = armDefault) then
          SrcLst.DeleteSelected
        else
          SrcLst.ClearSelection;
        //--- Select the item
        with SrcLst do
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
    SrcLst.Items.EndUpdate;
  end;
end;

end.

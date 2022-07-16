unit UCaptionListView508Manager;
////////////////////////////////////////////////////////////////////////////////
///  TCaptionListView508Manager implements 508 functionality for
///  TCaptionListView components. You can just create it with the
///  TVA508AccessibilityManager from a TfrmBase508Form and let it do its thing,
///  or you can finetune behavior as desired.
///  The Owner of this becomes the TVA508AccessibilityManager that is passed in,
///  so no need to Destroy this.
////////////////////////////////////////////////////////////////////////////////
interface
uses
  Vcl.Controls,
  Vcl.ComCtrls,
  VA508AccessibilityManager;

type
  TCaptionListView508Manager = class;

  TCaptionListViewGetTextEvent = function (Sender: TCaptionListView508Manager;
    AListView: TListView; AListItem: TListItem): string of object;

  TCaptionListViewGetItemEvent = function (Sender: TCaptionListView508Manager;
    AListView: TListView): TObject of object;

  TCaptionListView508Manager = class(TVA508ComponentManager)
  private
    FVA508AccessibilityManager: TVA508AccessibilityManager;
    FListView: TListView;
    FPreviousComponentManager: TVA508ComponentManager;
    FOnGetItem: TCaptionListViewGetItemEvent;
    FOnGetText: TCaptionListViewGetTextEvent;
  protected
    property PreviousComponentManager: TVA508ComponentManager
      read FPreviousComponentManager;
  public
    constructor Create(AVA508AccessibilityManager: TVA508AccessibilityManager;
      AListView: TListView;
      AManagedTypes: TManagedTypes = [mtValue, mtItemChange]); overload;
    destructor Destroy; override;
    function GetValue(Component: TWinControl): string; override;
    function GetItem(Component: TWinControl): TObject; override;
  public
    property OnGetText: TCaptionListViewGetTextEvent
      read FOnGetText write FOnGetText;
    property OnGetItem: TCaptionListViewGetItemEvent
      read FOnGetItem write FOnGetItem;
    property VA508AccessibilityManager: TVA508AccessibilityManager
      read FVA508AccessibilityManager;
    property ListView: TListView read FListView;
  end;

implementation
uses
  System.Classes,
  System.SysUtils;

constructor TCaptionListView508Manager.Create(
  AVA508AccessibilityManager: TVA508AccessibilityManager;
  AListView: TListView; AManagedTypes: TManagedTypes = [mtValue, mtItemChange]);
begin
  if not Assigned(AVA508AccessibilityManager) then
    raise Exception.Create('AVA508AccessibilityManager not assigned');
  if not Assigned(AListView) then
    raise Exception.Create('AListView not assigned');

  inherited Create(AManagedTypes);

  // Creates the link to the manager for this listview
  FVA508AccessibilityManager := AVA508AccessibilityManager;
  FListView := AListView;
  FPreviousComponentManager :=
    VA508AccessibilityManager.ComponentManager[AListView]; // This transfers ownership of FPreviousComponentManager to us.
  VA508AccessibilityManager.ComponentManager[AListView] :=
    Self; // This transfers ownership to VA508AccessibilityManager! No need to Free this youself!
end;

destructor TCaptionListView508Manager.Destroy;
begin
  FreeAndNil(FPreviousComponentManager);
  inherited;
end;

function TCaptionListView508Manager.GetItem(Component: TWinControl): TObject;
begin
  if Assigned(Component) and (Component is TListView) then
  begin
    if Assigned(FOnGetItem) then begin
      // Fire the assigned event
      Result := FOnGetItem(Self, TListView(Component));
    end else begin
      // run the default behavior
      Result := TListView(Component).Selected;
    end;
  end else Result := nil;
end;

function TCaptionListView508Manager.GetValue(Component: TWinControl): string;
var
  I: integer;
  ColumnHeader, CellText: string;
  ACollectionItem: TCollectionItem;
  AListView: TListView;
  AListItem: TListItem;
  AListGroup: TListGroup;
  AListColumn: TListColumn;
begin
  Result := '';
  if not Assigned(Component) then Exit;
  if not (Component is TListView) then Exit;
  AListView := TListView(Component);
  AListItem := AListView.Selected;

  if Assigned(FOnGetText) then begin
    // fire the assigned event
    Result := FOnGetText(Self, AListView, AListItem);
  end else begin
    // run the default behavior
    if not Assigned(AListItem) then Exit;

    // Get the groupname if we need to
    if AListView.GroupView then
    begin
      for ACollectionItem in AListView.Groups do
      begin
        if ACollectionItem is TListGroup then
        begin
          AListGroup := TListGroup(ACollectionItem);
          if AListGroup.GroupID = AListItem.GroupID then begin
            Result := 'Group: ' + AListGroup.Header;
            Break;
          end;
        end;
      end;
    end;

    // Build up the item string
    for I := 0 to AListView.Columns.Count - 1 do
    begin
      AListColumn := AListView.Columns[I];

      ColumnHeader := Trim(AListColumn.Caption);
      // Read "Column 4" (whatever the column is) when an emty column comes up
      if ColumnHeader = '' then ColumnHeader := Format('Column %d', [I]);

      if I = 0 then
        CellText := Trim(AListItem.Caption)
      else
        CellText := Trim(AListItem.SubItems[I - 1]);
      // Read "empty" when an emty column text comes up
      if CellText = '' then CellText := 'Empty';

      Result := Trim(Format('%s %s %s,', [Result, ColumnHeader, CellText]));
    end;

  end;
end;

end.

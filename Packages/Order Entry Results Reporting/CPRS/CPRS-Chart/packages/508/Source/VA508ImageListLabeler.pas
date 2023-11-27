unit VA508ImageListLabeler;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ImgList, VAClasses, Graphics, ComCtrls,
  Contnrs, Forms, oleacc2, VA508MSAASupport;

type
  TVA508ImageListLabeler = class;
  TVA508ImageListLabels = class;

  TVA508ImageListLabel = class(TCollectionItem)
  private
    FImageIndex: integer;
    FCaption: string;
    FOverlayIndex: integer;
    procedure SetImageIndex(const Value: integer);
    procedure Changed;
    procedure SetCaption(const Value: string);
    procedure SetOverlayIndex(const Value: integer);
  protected
    procedure Refresh;
    function Labeler: TVA508ImageListLabeler;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Caption: string read FCaption write SetCaption;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
    property OverlayIndex: integer read FOverlayIndex write SetOverlayIndex;
  end;

  TVA508ImageListLabels = class(TCollection)
  private
    FOwner: TVA508ImageListLabeler;
    FColumns: TStringList;
    FImageData: TStrings;
    FOverlayData: TStrings;
    FBuildOverlayData: boolean;
  protected
    function GetAttrCount: Integer; override;
    function GetAttr(Index: Integer): string; override;
    function GetItemAttr(Index, ItemIndex: Integer): string; override;
    function GetItem(Index: Integer): TVA508ImageListLabel;
    procedure SetItem(Index: Integer; Value: TVA508ImageListLabel);
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    procedure Update(Item: TCollectionItem); override;
    function GetImageData: TStrings;
    function GetOverlayData: TStrings;
    procedure ResetData;    
  public
    constructor Create(Owner: TVA508ImageListLabeler);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;
    function Add: TVA508ImageListLabel;
    property Items[Index: Integer]: TVA508ImageListLabel read GetItem write SetItem; default;
  end;

  TVA508ImageListComponent = class(TCollectionItem)
  private
    FComponent: TWinControl;
    FComponentNotifier: TVANotificationEventComponent;
    procedure ComponentNotifyEvent(AComponent: TComponent; Operation: TOperation);
    procedure SetComponent(const Value: TWinControl);
    function Labeler: TVA508ImageListLabeler;
  protected
    function GetDisplayName: string; override;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function ImageListTypes: TVA508ImageListTypes;
  published
    property Component: TWinControl read FComponent write SetComponent;
  end;

  TVA508ImageListComponents = class(TCollection)
  private
    FOwner: TVA508ImageListLabeler;
  protected
    function GetItem(Index: Integer): TVA508ImageListComponent;
    procedure SetItem(Index: Integer; Value: TVA508ImageListComponent);
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    constructor Create(Owner: TVA508ImageListLabeler);
    destructor Destroy; override;
    function GetOwner: TPersistent; override;
    function Add: TVA508ImageListComponent;
    property Items[Index: Integer]: TVA508ImageListComponent read GetItem write SetItem; default;
  end;

  TVA508ImageListLabeler = class(TComponent)
  private
    FStartup: boolean;
    FOldComponentList: TList;
    FImageListChanging: boolean;
    FImageListChanged: boolean;
    FItemChange: boolean;
    FOnChange: TNotifyEvent;
    FChangeLink: TChangeLink;
    FImageList: TCustomImageList;
    FComponents: TVA508ImageListComponents;
    FItems: TVA508ImageListLabels;
    FRemoteLabeler: TVA508ImageListLabeler;
    procedure SetImageList(const Value: TCustomImageList);
    procedure SetRemoteLabeler(const Value: TVA508ImageListLabeler);
  protected
    procedure ImageIndexQuery(Sender: TObject; ImageIndex: integer;
                              ImageType: TVA508ImageListType; var ImageText: string);
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ImageListChange(Sender: TObject);
    procedure ItemChanged;
    procedure SaveChanges(Reregister: boolean);
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ComponentImageListChanged;
  published
    property Components: TVA508ImageListComponents read FComponents write FComponents;
    property ImageList: TCustomImageList read FImageList write SetImageList;
    property Labels: TVA508ImageListLabels read FItems write FItems;
    property RemoteLabeler: TVA508ImageListLabeler read FRemoteLabeler write SetRemoteLabeler;
  end;

procedure Register;

implementation

uses VA508Classes, VA508AccessibilityRouter, UResponsiveGUI;

procedure Register;
begin
  RegisterComponents('VA 508', [TVA508ImageListLabeler]);
end;

{ TVA508ImageListLabeler }

procedure TVA508ImageListLabeler.ComponentImageListChanged;
begin
  SaveChanges(TRUE);
end;

constructor TVA508ImageListLabeler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStartup := TRUE;
  FOldComponentList := TList.Create;
  FItems := TVA508ImageListLabels.Create(Self);
  FComponents := TVA508ImageListComponents.Create(Self);
  FChangeLink := TChangeLink.Create;
  FChangeLink.OnChange := ImageListChange;
  VA508ComponentCreationCheck(Self, AOwner, TRUE, TRUE);
end;

destructor TVA508ImageListLabeler.Destroy;
begin
  FItems.Clear;
  FComponents.Clear;
  SaveChanges(FALSE);
  SetImageList(nil);
  FreeAndNil(FItems);
  FreeAndNil(FComponents);
  FChangeLink.Free;
  FreeAndNil(FOldComponentList);
  inherited;
end;

procedure TVA508ImageListLabeler.ImageIndexQuery(Sender: TObject; ImageIndex: integer; 
                                  ImageType: TVA508ImageListType; var ImageText: string);
var
  list: TStrings;
begin
  if ImageIndex < 0 then exit;
  if ImageType = iltOverlayImages then
  begin
    if assigned(RemoteLabeler) then
      list := RemoteLabeler.FItems.GetOverlayData
    else
      list := FItems.GetOverlayData;
  end
  else
  begin
    if assigned(RemoteLabeler) then
      list := RemoteLabeler.FItems.GetImageData
    else
      list := FItems.GetImageData;
  end;
  if ImageIndex < list.Count then
    ImageText := list[ImageIndex]
  else
    ImageText := '';
end;

procedure TVA508ImageListLabeler.ImageListChange(Sender: TObject);
var
  i: integer;
begin
  if assigned(FOnChange) then
  begin
    FItemChange := FALSE;
    FImageListChanged := TRUE;
    try
      for I := 0 to FItems.Count - 1 do
      begin
        FItems.Items[i].Refresh;
        if FItemChange then
          break;
      end;
      if FItemChange then
        FOnChange(Self);
    finally
      FImageListChanged := FALSE;
    end;                         
  end;
end;

procedure TVA508ImageListLabeler.ItemChanged;
begin
  if FImageListChanged then
    FItemChange := TRUE
  else if assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TVA508ImageListLabeler.Loaded;
begin
  inherited;
  FStartup := FALSE;
  TResponsiveGUI.ProcessMessages;
  SaveChanges(FALSE);
end;

procedure TVA508ImageListLabeler.SaveChanges(Reregister: boolean);
var
  i, idx: integer;
  Item: TVA508ImageListComponent;
  Comp: TWinControl;
  NewList: TList;
  reg: boolean;
begin
  if FStartup or (csDesigning in ComponentState) or (not ScreenReaderSystemActive) then exit;
  if (FComponents.Count = 0) and (FOldComponentList.Count = 0) then exit;
  NewList := TList.Create;
  try
    for i := 0 to FComponents.Count - 1 do
    begin
      Item := FComponents.Items[i];
      if assigned(Item.Component) then
      begin
        NewList.Add(Item.Component);
        idx := FOldComponentList.IndexOf(Item.Component);
        if idx < 0 then
          reg := TRUE
        else
        begin
          FOldComponentList.Delete(idx);
          reg := Reregister;
        end;
        if reg then
          RegisterComponentImageListQueryEvent(Item.Component, Item.ImageListTypes, ImageIndexQuery);
      end;
    end;
    for i := 0 to FOldComponentList.Count-1 do
    begin
      Comp := TWinControl(FOldComponentList[i]);
      UnregisterComponentImageListQueryEvent(Comp, ImageIndexQuery);
    end;
  finally
    FOldComponentList.Free;
    FOldComponentList := NewList;
  end;
end;

procedure TVA508ImageListLabeler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FImageList) and (Operation = opRemove) then
    SetImageList(nil);
end;

procedure TVA508ImageListLabeler.SetImageList(const Value: TCustomImageList);
var
  i,idx: integer;
  list: string;
begin
  if FImageListChanging then exit;
  if assigned(FRemoteLabeler) then 
  begin
    FImageList := nil;
    exit;
  end;
  if FImageList <> Value then
  begin
    FImageListChanging := TRUE;
    try
      if assigned(FImageList) then
      begin
        FImageList.UnRegisterChanges(FChangeLink);
        FImageList.RemoveFreeNotification(Self);
      end;
      FImageList := Value;
      if assigned(FImageList) then
      begin
        FImageList.FreeNotification(Self);
        FImageList.RegisterChanges(FChangeLink);
        if FImageList.count > 0 then
        begin
          list := StringOfChar('x',FImageList.Count);
          for i := 0 to FItems.Count - 1 do
          begin
            idx := FItems[i].ImageIndex + 1;
            if idx > 0 then
              list[idx] := ' ';
          end;
          for i := 0 to FImageList.Count - 1 do
          begin
            if list[i+1] = 'x' then
              FItems.Add.ImageIndex := i;
          end;
        end;
      end;
      if assigned(FOnChange) then
        FOnChange(Self);
    finally
      FImageListChanging := FALSE;
    end;
  end;
end;

procedure TVA508ImageListLabeler.SetRemoteLabeler(const Value: TVA508ImageListLabeler);
begin
  if (FRemoteLabeler <> Value) then
  begin
    if assigned(Value) then
    begin
      FItems.Clear;
      SetImageList(nil);
    end;
    FRemoteLabeler := Value;
  end;
end;

{ TVA508ImageListItems }

function TVA508ImageListLabels.Add: TVA508ImageListLabel;
begin
  Result := TVA508ImageListLabel(inherited Add);
end;

constructor TVA508ImageListLabels.Create(Owner: TVA508ImageListLabeler);
begin
  inherited Create(TVA508ImageListLabel);
  FImageData := TStringList.Create;
  FOverlayData := TStringList.Create;
  FOwner := Owner;
  FColumns := TStringList.Create;
  FColumns.Add('Image');
  FColumns.Add('ImageIndex');
  FColumns.Add('OverlayIndex');  
  FColumns.Add('Caption');
end;

destructor TVA508ImageListLabels.Destroy;
begin
  Clear;
  FreeAndNil(FColumns);
  FreeAndNil(FImageData);
  FreeAndNil(FOverlayData);
  inherited;
end;

function TVA508ImageListLabels.GetAttr(Index: Integer): string;
begin
  Result := FColumns[Index];
end;

function TVA508ImageListLabels.GetAttrCount: Integer;
begin
  Result := FColumns.Count;
end;

function TVA508ImageListLabels.GetImageData: TStrings;
var
  i: integer;
  item: TVA508ImageListLabel;
begin
  if (FImageData.Count = 0) and (Count > 0) then
  begin
    for i := 0 to Count-1 do
    begin
      item := Items[i];
      while FImageData.Count <= item.ImageIndex do
        FImageData.Add('');
      FImageData[item.ImageIndex] := item.Caption;
    end;
  end;
  Result := FImageData;
end;

function TVA508ImageListLabels.GetItem(Index: Integer): TVA508ImageListLabel;
begin
  Result := TVA508ImageListLabel(inherited GetItem(Index));
end;

function TVA508ImageListLabels.GetItemAttr(Index, ItemIndex: Integer): string;
begin
  case Index of
    0:  Result := ' '; // needs something on index 0 or it doesn't display anything on entire line
    1:  if GetItem(ItemIndex).ImageIndex < 0 then
          Result := ' '
        else
          Result := IntToStr(GetItem(ItemIndex).ImageIndex);
    2:  begin
          if (GetItem(ItemIndex).OverlayIndex < 0) then
            Result := ' '
          else
            Result := IntToStr(GetItem(ItemIndex).OverlayIndex);
        end;
    3:  Result := GetItem(ItemIndex).Caption;
    else  Result := '';
  end;
end;

function TVA508ImageListLabels.GetOverlayData: TStrings;
var
  i: integer;
  item: TVA508ImageListLabel;
begin
  if FBuildOverlayData then
  begin
    FBuildOverlayData := FALSE;
    if (Count > 0) then
    begin
      for i := 0 to Count-1 do
      begin
        item := Items[i];
        if item.OverlayIndex >= 0 then
        begin
          while FOverlayData.Count <= item.OverlayIndex do
            FOverlayData.Add('');
          FOverlayData[item.OverlayIndex] := item.Caption;
        end;
      end;
    end;
  end;
  Result := FOverlayData;
end;

function TVA508ImageListLabels.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TVA508ImageListLabels.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  ResetData;
end;

procedure TVA508ImageListLabels.ResetData;
begin
  FImageData.Clear;
  FOverlayData.Clear;
  FBuildOverlayData := TRUE;
end;

procedure TVA508ImageListLabels.SetItem(Index: Integer; Value: TVA508ImageListLabel);
begin
  inherited SetItem(Index, Value);
end;

procedure TVA508ImageListLabels.Update(Item: TCollectionItem);
begin
  inherited;
  ResetData;
end;

{ TVA508GraphicLabel }

procedure TVA508ImageListLabel.Assign(Source: TPersistent);
var
  item: TVA508ImageListLabel;
begin
  if Source is TVA508ImageListLabel then
  begin
    item := TVA508ImageListLabel(Source);
    SetImageIndex(item.ImageIndex);
    FCaption := item.Caption;
  end
  else
    inherited Assign(Source);
end;

procedure TVA508ImageListLabel.Changed;
begin
  labeler.ItemChanged;
end;

constructor TVA508ImageListLabel.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FOverlayIndex := -1;
end;

destructor TVA508ImageListLabel.Destroy;
begin
  inherited;
end;

function TVA508ImageListLabel.Labeler: TVA508ImageListLabeler;
begin
  Result := TVA508ImageListLabeler(TVA508ImageListLabels(GetOwner).GetOwner);
end;

procedure TVA508ImageListLabel.Refresh;
begin
  SetImageIndex(FImageIndex);
end;

procedure TVA508ImageListLabel.SetCaption(const Value: string);
begin
  if (FCaption <> Value) then
  begin
    FCaption := Value;
    TVA508ImageListLabels(GetOwner).Update(Self);
  end;
end;

procedure TVA508ImageListLabel.SetImageIndex(const Value: integer);
var
  before: integer;
begin
  if csReading in labeler.ComponentState then
    FImageIndex := Value
  else
  begin
    before := FImageIndex;
    if not assigned(labeler.ImageList) then
      FImageIndex := -1
    else
    if (Value >= 0) and (Value < labeler.ImageList.Count) then
      FImageIndex := Value
    else
      FImageIndex := -1;
    if FImageIndex <> before then
    begin
      Changed;
      TVA508ImageListLabels(GetOwner).Update(Self);
    end;
  end;

end;

procedure TVA508ImageListLabel.SetOverlayIndex(const Value: integer);
begin
  if (FOverlayIndex <> Value) and (Value >= 0) and (Value < 16) then
  begin
    FOverlayIndex := Value;
  end;
end;

{ TVA508ImageListComponents }

function TVA508ImageListComponents.Add: TVA508ImageListComponent;
begin
  Result := TVA508ImageListComponent(inherited Add);
end;

constructor TVA508ImageListComponents.Create(Owner: TVA508ImageListLabeler);
begin
  inherited Create(TVA508ImageListComponent);
  FOwner := Owner;
end;

destructor TVA508ImageListComponents.Destroy;
begin
  Clear;
  inherited;
end;

function TVA508ImageListComponents.GetItem(
  Index: Integer): TVA508ImageListComponent;
begin
  Result := TVA508ImageListComponent(inherited GetItem(Index));
end;

function TVA508ImageListComponents.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TVA508ImageListComponents.Notify(Item: TCollectionItem;
  Action: TCollectionNotification);
begin
  inherited;
  FOwner.SaveChanges(FALSE);
end;

procedure TVA508ImageListComponents.SetItem(Index: Integer;
  Value: TVA508ImageListComponent);
begin
  inherited SetItem(Index, Value);
end;

{ TVA508ImageListComponent }

procedure TVA508ImageListComponent.Assign(Source: TPersistent);
var
  comp: TVA508ImageListComponent;
begin
  if Source is TVA508ImageListComponent then
  begin
    comp := TVA508ImageListComponent(Source);
    comp.Component := FComponent;
  end
  else
    inherited Assign(Source);
end;

procedure TVA508ImageListComponent.ComponentNotifyEvent(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and assigned(AComponent) and (AComponent = FComponent) then
    SetComponent(nil);
end;

destructor TVA508ImageListComponent.Destroy;
begin
  SetComponent(nil);
  if assigned(FComponentNotifier) then
    FreeAndNil(FComponentNotifier);
  inherited;
end;

function TVA508ImageListComponent.GetDisplayName: string;
begin
  if assigned(FComponent) and (length(FComponent.Name) > 0) then
    Result := FComponent.Name + ' (' + FComponent.ClassName + ')'
  else
    Result := inherited GetDisplayName;
end;

type
  TExposedTreeView = class(TCustomTreeView);
  TExposedListView = class(TCustomListView);

function TVA508ImageListComponent.ImageListTypes: TVA508ImageListTypes;
var
  list: TCustomImageList;
begin
  Result := [];
  list := Labeler.ImageList;
  if (not assigned(list)) and assigned(Labeler.FRemoteLabeler) then
    list := Labeler.FRemoteLabeler.ImageList;
  if (not assigned(list)) then exit;
  if FComponent is TCustomTreeView then
  begin
    with TExposedTreeView(FComponent) do
    begin
      if list = Images then
        Result := Result + [iltImages, iltOverlayImages];
      if list = StateImages then
        Include(Result, iltStateImages);
    end;
  end
  else if FComponent is TCustomListView then
  begin
    with TExposedListView(FComponent) do
    begin
      if list = LargeImages then
        Result := Result + [iltLargeImages, iltOverlayImages];
      if list = SmallImages then
        Result := Result + [iltSmallImages, iltOverlayImages];
      if list = StateImages then
        Include(Result, iltStateImages);
    end;
  end;
end;

function TVA508ImageListComponent.Labeler: TVA508ImageListLabeler;
begin
  Result := TVA508ImageListLabeler(TVA508ImageListLabels(GetOwner).GetOwner);
end;

procedure TVA508ImageListComponent.SetComponent(const Value: TWinControl);
var
  i: integer;
  found: boolean;
begin
  if FComponent <> Value then
  begin
    if assigned(Value) then
    begin
      Found := false;
      for i := low(VA508ImageListLabelerClasses) to high(VA508ImageListLabelerClasses) do
      begin
        if Value is VA508ImageListLabelerClasses[i] then
        begin
          Found := true;
          break;
        end;
      end;
      if not found then
        raise EVA508AccessibilityException.Create('Invalid component class used in ' + TVA508ImageListComponent.ClassName);
    end;
    if assigned(FComponentNotifier) and assigned(FComponent) then
      FComponentNotifier.RemoveFreeNotification(FComponent);
    if assigned(Value) then
    begin
      if not assigned(FComponentNotifier) then
        FComponentNotifier := TVANotificationEventComponent.NotifyCreate(nil, ComponentNotifyEvent);
      FComponentNotifier.FreeNotification(Value);
    end;
    FComponent := Value;
    Labeler.SaveChanges(FALSE);
  end;
end;

end.

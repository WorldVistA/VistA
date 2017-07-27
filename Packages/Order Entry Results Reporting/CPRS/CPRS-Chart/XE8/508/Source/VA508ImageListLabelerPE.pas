unit VA508ImageListLabelerPE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ColnEdit, ToolWnds, ImgList, DesignIntf, TypInfo,
  DesignEditors, VA508ImageListLabeler, VA508MSAASupport, ToolsAPI, StdCtrls, Buttons, Menus;

const
  VA508_CUSTOM_REDRAW_IMAGES = WM_USER + 123;

type
  TVA508ImageListReceiver = procedure(lvItem: TListItem; item: TVA508ImageListLabel) of object;

  TfrmImageListEditor = class(TCollectionEditor)
    imgTemp16: TImageList;
    imgTemp24: TImageList;
    imgTemp32: TImageList;
  private
    FRedrawImages: boolean;
    FSize: integer;
    FBitMap1: TBitMap;
    FBitMap2: TBitMap;
    FBMRect: TRect;
    FOldOnChange: TNotifyEvent;
    FOnChangeRedirected: boolean;
    procedure ImageDataChanged(Sender: TObject);
    procedure IterateItems(Receiver: TVA508ImageListReceiver);
    procedure RedrawImages(var Msg); message VA508_CUSTOM_REDRAW_IMAGES;
    procedure GetSize;
    procedure UpdateImages(lvItem: TListItem; item: TVA508ImageListLabel);
    function GetImageList: TImageList;
  protected
    procedure ItemChange(Sender: TObject; Item: TListItem);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TVA508ImageListItemsProperty = class(TCollectionProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetEditorClass: TCollectionEditorClass; override;
  end;

  TVA508ImageListComponentEditor = class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TVA508ImageListComponentProperty = class(TComponentProperty)
  private
    FProc: TGetStrProc;
    procedure FilterValues(const S: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TVA508LabelerImageListProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;

  TVA508LabelerRemoteLabelerProperty = class(TComponentProperty)
  private
    FProc: TGetStrProc;
    procedure FilterValues(const S: string);
  public
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

{$R *.dfm}

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TVA508ImageListLabels), TVA508ImageListLabeler, 'Labels', TVA508ImageListItemsProperty);
  RegisterPropertyEditor(TypeInfo(TVA508ImageListLabeler), TVA508ImageListLabeler, 'RemoteLabeler', TVA508LabelerRemoteLabelerProperty);
  RegisterPropertyEditor(TypeInfo(TCustomImageList), TVA508ImageListLabeler, 'ImageList', TVA508LabelerImageListProperty);
  RegisterPropertyEditor(TypeInfo(TComponent), TVA508ImageListComponent, 'Component', TVA508ImageListComponentProperty);
  RegisterComponentEditor(TVA508ImageListLabeler, TVA508ImageListComponentEditor);
end;

const
  GSIZE_SMALL = 16;
  GSIZE_MED   = 24;
  GSIZE_LARGE = 32;

type
  TVA508AccessImageListLabeler = class(TVA508ImageListLabeler);


constructor TfrmImageListEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
// this works because refresh of images in parent class destroys and rebuilds list
  ListView1.OnInsert := ItemChange;
  ListView1.OnDeletion := ItemChange;
end;

{ TVA508GraphicsProperty }

function TVA508ImageListItemsProperty.GetAttributes: TPropertyAttributes;
var
  comp: TVA508ImageListLabeler;
begin
  comp := TVA508ImageListLabeler(GetComponent(0));
  if assigned(comp) and assigned(comp.RemoteLabeler) then
    Result := [paReadOnly, paDisplayReadOnly, paAutoUpdate]
  else
    Result := inherited GetAttributes + [paAutoUpdate];
end;

function TVA508ImageListItemsProperty.GetEditorClass: TCollectionEditorClass;
begin
  Result := TfrmImageListEditor;
end;

destructor TfrmImageListEditor.Destroy;
begin
  if FOnChangeRedirected then
  begin
    TVA508AccessImageListLabeler(Component).OnChange := FOldOnChange;
    FOnChangeRedirected := FALSE;
  end;
  inherited;
end;

procedure TfrmImageListEditor.ImageDataChanged(Sender: TObject);
begin
  ItemChange(Sender, nil);
end;

procedure TfrmImageListEditor.ItemChange(Sender: TObject;
  Item: TListItem);
var
  Msg: TMsg;
begin
  FRedrawImages := TRUE;
  if not PeekMessage(Msg, Handle, VA508_CUSTOM_REDRAW_IMAGES, VA508_CUSTOM_REDRAW_IMAGES, PM_NOREMOVE) then
    PostMessage(Handle, VA508_CUSTOM_REDRAW_IMAGES, 0, 0);
end;

procedure TfrmImageListEditor.IterateItems(
  Receiver: TVA508ImageListReceiver);
var
  i: integer;
  item: TVA508ImageListLabel;
  lvItem: TListItem;

begin
  if assigned(Receiver) then
  begin
    ListView1.items.BeginUpdate;
    try
      for i := 0 to ListView1.Items.Count - 1 do
      begin
        lvItem := ListView1.items[i];
        item := TVA508ImageListLabels(Collection).Items[i];
        if assigned(item) then
          Receiver(lvItem, item);
      end;
    finally
     ListView1.items.EndUpdate;
    end;
  end;
end;

function TfrmImageListEditor.GetImageList: TImageList;
begin
  case FSize of
    GSIZE_SMALL: Result := imgTemp16;
    GSIZE_MED:   Result := imgTemp24;
    GSIZE_LARGE: Result := imgTemp32;
    else         Result := nil;
  end;
end;

procedure TfrmImageListEditor.GetSize;
var
  imgSize: integer;
  imageList: TCustomImageList;
begin
  imageList := TVA508AccessImageListLabeler(Component).ImageList;
  if assigned(ImageList) then
  begin
    imgSize := ImageList.Height;
    if imgSize < ImageList.Width then
      imgSize := ImageList.Width;
  end
  else
    imgSize := 0;
  if FSize < imgSize then
    FSize := imgSize;
end;

procedure TfrmImageListEditor.RedrawImages(var Msg);
var
  i, BeforeSize: integer;
  imgList: TImageList;

begin
  if FRedrawImages then
  begin
    FRedrawImages := FALSE;
    ListView1.items.BeginUpdate;
    try
      if not FOnChangeRedirected then
      begin
        FOldOnChange := TVA508AccessImageListLabeler(Component).OnChange;
        TVA508AccessImageListLabeler(Component).OnChange := ImageDataChanged;
        FOnChangeRedirected := TRUE;
      end;

      BeforeSize := FSize;
      FSize := GSIZE_SMALL;

      GetSize;
      if FSize > GSIZE_MED then
        FSize := GSIZE_LARGE
      else if FSize > GSIZE_SMALL then
        FSize := GSIZE_MED
      else
        FSize := GSIZE_SMALL;

      if FSize <> BeforeSize then
        ListView1.Columns[0].Width := FSize * 3;

      imgList := GetImageList;
      for I := imgList.Count - 1 downto 1 do
        imgList.Delete(i);
      ListView1.SmallImages := imgList;
      ListView1.StateImages := imgList;

      FBitmap1 := TBitMap.Create;
      FBitmap2 := TBitMap.Create;
      try
        FBitmap1.Height := imgList.Height;
        FBitmap1.Width := imgList.Width;
        FBMRect.Left := 0;
        FBMRect.Top := 0;
        FBMRect.Right := FBitMap1.Width;
        FBMRect.Bottom := FBitMap1.Height;

        IterateItems(UpdateImages);
      finally
        FreeAndNil(FBitmap1);
        FreeAndNil(FBitmap1);
      end;
    finally
      ListView1.items.EndUpdate;
    end;
  end;
end;

procedure TfrmImageListEditor.UpdateImages(lvItem: TListItem;
  item: TVA508ImageListLabel);
var
  imgLst: TImageList;
  stretch: boolean;
  ImageList: TCustomImageList;

begin
  ImageList := TVA508AccessImageListLabeler(Component).ImageList;
  if assigned(ImageList) and (item.ImageIndex >= 0) then
  begin
    imgLst := GetImageList;
    stretch := ((imgLst.Height <> ImageList.Height) or
                (imgLst.Width  <> ImageList.Width));
    if stretch then
    begin
      ImageList.GetBitmap(item.ImageIndex, FBitMap2);
      FBitmap1.Canvas.StretchDraw(FBMRect, FBitMap2);
    end
    else
      ImageList.GetBitmap(item.ImageIndex, FBitMap1);

    imgLst.Add(FBitMap1, nil);
    lvitem.ImageIndex := imglst.Count-1;
    FBitMap1.Canvas.FillRect(FBMRect);
    if stretch then
      FBitMap2.Canvas.FillRect(FBMRect);
  end
  else
    lvitem.ImageIndex := 0;
end;

{ TVA508ImageListComponentEditor }

procedure TVA508ImageListComponentEditor.Edit;
begin
  ShowCollectionEditorClass(Designer, TfrmImageListEditor, Component,
      TVA508ImageListLabeler(Component).Labels, 'Images');
end;

procedure TVA508ImageListComponentEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then Edit
  else inherited ExecuteVerb(Index);
end;

function TVA508ImageListComponentEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then
    Result := 'Edit Image List Labels...'
  else
    Result := inherited GetVerb(Index);
end;

function TVA508ImageListComponentEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ TVA508ImageListComponentProperty }

procedure TVA508ImageListComponentProperty.FilterValues(const S: string);
var
  comp: TComponent;
  i: integer;

begin
  comp := Designer.GetComponent(S);
  if assigned(comp) then
  begin
    for i := low(VA508ImageListLabelerClasses) to high(VA508ImageListLabelerClasses) do
    begin
      if comp is VA508ImageListLabelerClasses[i] then
        FProc(S + ' (' + comp.ClassName + ')');
    end;
  end;
end;

function TVA508ImageListComponentProperty.GetValue: string;
var
  comp: TComponent;

begin
  Result := inherited GetValue;
  comp := Designer.GetComponent(Result);
  if assigned(comp) then
    Result := Result + ' (' + comp.ClassName + ')';
end;

procedure TVA508ImageListComponentProperty.GetValues(Proc: TGetStrProc);
begin
  FProc := Proc;
  Designer.GetComponentNames(GetTypeData(GetPropType), FilterValues);
end;

procedure TVA508ImageListComponentProperty.SetValue(const Value: string);
var
  i: integer;
  data: string;
begin
  data := Value;
  i := pos(' (',data);
  if i > 0 then
    delete(data, i, MaxInt);
  inherited SetValue(Data);
end;


{ TVA508LabelerImageListProperty }

function TVA508LabelerImageListProperty.GetAttributes: TPropertyAttributes;
var
  comp: TVA508ImageListLabeler;
begin
  comp := TVA508ImageListLabeler(GetComponent(0));
  if assigned(comp) and (not assigned(comp.RemoteLabeler)) then
    Result := inherited GetAttributes
  else
    Result := [paReadOnly, paDisplayReadOnly, paAutoUpdate];
end;


{ TVA508LabelerRemoteLabelerProperty }

procedure TVA508LabelerRemoteLabelerProperty.FilterValues(const S: string);
begin
  if pos('->', S) > 0 then
    FProc(S);
end;

procedure TVA508LabelerRemoteLabelerProperty.GetValues(Proc: TGetStrProc);
begin
  FProc := Proc;
  Designer.GetComponentNames(GetTypeData(GetPropType), FilterValues);
end;

end.

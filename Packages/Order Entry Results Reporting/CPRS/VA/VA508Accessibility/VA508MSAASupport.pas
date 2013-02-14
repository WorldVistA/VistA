unit VA508MSAASupport;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComObj, ActiveX, oleacc2, MSAAConstants,
  ImgList, VAClasses, Graphics, ComCtrls, CommCtrl, Contnrs, VA508AccessibilityConst;

type
  TVA508ImageListType = (iltImages, iltLargeImages, iltOverlayImages, iltSmallImages, iltStateImages);
  TVA508ImageListTypes = set of TVA508ImageListType;

  TVA508OnImageIndexQueryEvent = procedure(Sender: TObject; ImageIndex: integer;
                                    ImageType: TVA508ImageListType; var ImageText: string) of object;

const
  VA508ImageListLabelerClasses: array[0..1] of TClass = (TCustomTreeView, TCustomListView);

procedure RegisterComponentImageListQueryEvent(Component: TWinControl;
                  ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);

procedure UnregisterComponentImageListQueryEvent(Component: TWinControl;
                                                        Event: TVA508OnImageIndexQueryEvent);

procedure RegisterMSAAComponentQueryProc(Component: TWinControl; Proc: TVA508QueryProc);
procedure UnregisterMSAAComponentQueryProc(Component: TWinControl; Proc: TVA508QueryProc);
procedure RegisterMSAAComponentListQueryProc(Component: TWinControl; Proc: TVA508ListQueryProc);
procedure UnregisterMSAAComponentListQueryProc(Component: TWinControl; Proc: TVA508ListQueryProc);

implementation

var
  uShutDown: boolean = FALSE;
  Events: TInterfaceList = nil;
  AccPropServices: IAccPropServices = nil;
  NamePropIDs: array[0..0] of TGUID;
  uNotifier: TVANotificationEventComponent;

type
  TServerType = (stImageList, stList, stNormal);
  TServerTypes = set of TServerType;

  TImageEventData = class
    ImageListTypes: TVA508ImageListTypes;
    Event: TVA508OnImageIndexQueryEvent;
  end;

  TListProcData = class
    Proc: TVA508ListQueryProc;
  end;

  TProcData = class
    Proc: TVA508QueryProc;
  end;

  IMSAAServer = interface
    function GetComponent: TWinControl;
    procedure AddImageEvent(ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);
    procedure RemoveImageEvent(ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);
    procedure AddListProc(Proc: TVA508ListQueryProc);
    procedure RemoveListProc(Proc: TVA508ListQueryProc);
    procedure AddProc(Proc: TVA508QueryProc);
    procedure RemoveProc(Proc: TVA508QueryProc);
    procedure AssignServerType(AServerType: TServerType);
    function EventCount: integer;
  end;

  TMSAAServer = class(TInterfacedObject, IAccPropServer, IMSAAServer)
  private
    FServerTypes: TServerTypes;
    FAttached: boolean;
    FEventData: TObjectList;
    FComponent: TWinControl;
    FOldWndProc: TWndMethod;
    function ImageEventIndex(Event: TVA508OnImageIndexQueryEvent): integer;
    function ListProcIndex(Proc: TVA508ListQueryProc): integer;
    function ProcIndex(Proc: TVA508QueryProc): integer;
    procedure Attach;
    procedure Detatch;
    procedure Hook;
    procedure UnHook;
    procedure AssignServerType(AServerType: TServerType);
    procedure UnassignServerType(AServerType: TServerType);
  protected
    procedure MSAAWindowProc(var Message: TMessage);
  public
    constructor Create(AComponent: TWinControl);
    destructor Destroy; override;
    class procedure ValidateServerType(AComponent: TWinControl; AServerType: TServerType);
    function GetPropValue(const pIDString: PByte; dwIDStringLen: LongWord; idProp: MSAAPROPID;
      out pvarValue: OleVariant; out pfHasProp: Integer): HResult; stdcall;
    function GetComponent: TWinControl;
    procedure AddImageEvent(ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);
    procedure RemoveImageEvent(ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);
    procedure AddListProc(Proc: TVA508ListQueryProc);
    procedure RemoveListProc(Proc: TVA508ListQueryProc);
    procedure AddProc(Proc: TVA508QueryProc);
    procedure RemoveProc(Proc: TVA508QueryProc);
    function EventCount: integer;
  end;

  TExposedTreeView = class(TCustomTreeView);
  TExposedListView = class(TCustomListView);

function FindServer(Component: TWinControl; var index: integer): IMSAAServer; forward;

procedure NotifyEvent(Self: TObject; AComponent: TComponent; Operation: TOperation);
var
  server: IMSAAServer;
  index: integer;
begin
  if assigned(Events) and (Operation = opRemove) and (AComponent is TWinControl) then
  begin
    server := FindServer(TWinControl(AComponent), index);
    try
      if assigned(server) then
        Events.Delete(index);
    finally
      server := nil;
    end;
  end;
end;

var
  AccServicesCount: integer = 0;

procedure IncAccServices;
var
  m: TVANotifyEvent;
begin
  if AccServicesCount = 0 then
  begin
    AccPropServices := CoCAccPropServices.Create;
    NamePropIDs[0] := PROPID_ACC_NAME;
    TMethod(m).Code := @NotifyEvent;
    TMethod(m).Data := nil;
    uNotifier := TVANotificationEventComponent.NotifyCreate(nil, m);
  end;
  inc(AccServicesCount);
end;

procedure DecAccServices;
begin
  dec(AccServicesCount);
  if AccServicesCount = 0 then
  begin
    FreeAndNil(uNotifier);
    AccPropServices := nil;
  end;
end;
  
procedure Cleanup;
begin
  uShutDown := TRUE;
  if assigned(Events) then
  begin
    Events := nil;
    DecAccServices;
  end;
end;

function FindServer(Component: TWinControl; var index: integer): IMSAAServer;
var
  i: integer;

begin
  if not assigned(Events) then
  begin
    Events := TInterfaceList.Create;
    IncAccServices;
  end;
  for I := 0 to Events.Count - 1 do
  begin
    Result := IMSAAServer(Events[i]);
    index := i;
    if Result.GetComponent = Component then exit;
  end;
  Result := nil;
  index := -1;
end;

procedure RegisterComponentImageListQueryEvent(Component: TWinControl;
                  ImageListTypes: TVA508ImageListTypes; Event: TVA508OnImageIndexQueryEvent);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  TMSAAServer.ValidateServerType(Component,stImageList);
  server := FindServer(Component, index);
  try
    if not assigned(server) then
    begin
      server := TMSAAServer.Create(Component);
      Events.Add(server);
      uNotifier.FreeNotification(Component);
    end;
    server.AddImageEvent(ImageListTypes, Event);
  finally
    server := nil;
  end;
end;

procedure UnregisterComponentImageListQueryEvent(Component: TWinControl;
                                                        Event: TVA508OnImageIndexQueryEvent);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  server := FindServer(Component, index);
  try
    if assigned(server) then
    begin
      uNotifier.RemoveFreeNotification(Component);
      server.RemoveImageEvent([], Event);
      if server.EventCount = 0 then
        Events.Delete(index);
    end;
  finally
    server := nil;
  end;
end;

procedure RegisterMSAAComponentQueryProc(Component: TWinControl; Proc: TVA508QueryProc);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  TMSAAServer.ValidateServerType(Component, stNormal);
  server := FindServer(Component, index);
  try
    if not assigned(server) then
    begin
      server := TMSAAServer.Create(Component);
      Events.Add(server);
      uNotifier.FreeNotification(Component);
    end;
    server.AddProc(Proc);
  finally
    server := nil;
  end;
end;

procedure UnregisterMSAAComponentQueryProc(Component: TWinControl; Proc: TVA508QueryProc);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  server := FindServer(Component, index);
  try
    if assigned(server) then
    begin
      uNotifier.RemoveFreeNotification(Component);
      server.RemoveProc(Proc);
      if server.EventCount = 0 then
        Events.Delete(index);
    end;
  finally
    server := nil;
  end;
end;

procedure RegisterMSAAComponentListQueryProc(Component: TWinControl; Proc: TVA508ListQueryProc);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  TMSAAServer.ValidateServerType(Component, stList);
  server := FindServer(Component, index);
  try
    if not assigned(server) then
    begin
      server := TMSAAServer.Create(Component);
      Events.Add(server);
      uNotifier.FreeNotification(Component);
    end;
    server.AddListProc(Proc);
  finally
    server := nil;
  end;
end;

procedure UnregisterMSAAComponentListQueryProc(Component: TWinControl; Proc: TVA508ListQueryProc);
var
  server: IMSAAServer;
  index: integer;
begin
  if uShutDown then exit;
  if not assigned(Component) then exit;
  server := FindServer(Component, index);
  try
    if assigned(server) then
    begin
      uNotifier.RemoveFreeNotification(Component);
      server.RemoveListProc(Proc);
      if server.EventCount = 0 then
        Events.Delete(index);
    end;
  finally
    server := nil;
  end;
end;

{ TMSAAImageListServer }

procedure TMSAAServer.AddImageEvent(ImageListTypes: TVA508ImageListTypes;
  Event: TVA508OnImageIndexQueryEvent);
var
  data: TImageEventData;
  idx: integer;
begin
  idx := ImageEventIndex(Event);
  if idx < 0 then
  begin
    data := TImageEventData.Create;
    data.Event := Event;
    FEventData.Add(data);
  end
  else
    data := TImageEventData(FEventData[idx]);
  data.ImageListTypes := ImageListTypes;
  AssignServerType(stImageList);
end;

procedure TMSAAServer.AddListProc(Proc: TVA508ListQueryProc);
var
  data: TListProcData;
  idx: integer;
begin
  idx := ListProcIndex(Proc);
  if idx < 0 then
  begin
    data := TListProcData.Create;
    data.Proc := Proc;
    FEventData.Add(data);
  end;
  AssignServerType(stList);
end;

procedure TMSAAServer.AddProc(Proc: TVA508QueryProc);
var
  data: TProcData;
  idx: integer;
begin
  idx := ProcIndex(Proc);
  if idx < 0 then
  begin
    data := TProcData.Create;
    data.Proc := Proc;
    FEventData.Add(data);
  end;
  AssignServerType(stNormal);
end;

procedure TMSAAServer.AssignServerType(AServerType: TServerType);
begin
  FServerTypes := FServerTypes + [AServerType];
end;

procedure TMSAAServer.Attach;
begin
  if (not FAttached) and (not uShutDown) and (FComponent.Handle <> 0) then
  begin
//    if FServerType = stNormal then
//      FAttached := Succeeded(AccPropServices.SetHwndPropServer(FComponent.Handle,
//                    OBJID_CLIENT, CHILDID_SELF, @NamePropIDs, 1, Self, ANNO_THIS))
//    else
      FAttached := Succeeded(AccPropServices.SetHwndPropServer(FComponent.Handle,
                    OBJID_CLIENT, CHILDID_SELF, @NamePropIDs, 1, Self, ANNO_CONTAINER));
  end;
end;

constructor TMSAAServer.Create(AComponent: TWinControl);
begin
  IncAccServices;
  FComponent := AComponent;
  FEventData := TObjectList.Create;
  if AComponent.Showing then
    Attach
  else
    Hook;
end;

destructor TMSAAServer.Destroy;
begin
  Detatch;
  FreeAndNil(FEventData);
  DecAccServices;
  inherited;
end;

procedure TMSAAServer.Detatch;
var
  Ok2Detatch: boolean;
begin
  if FAttached and (not uShutDown) then
  begin
    Ok2Detatch := (not (csDestroying in FComponent.ComponentState)) and FComponent.visible;
    if Ok2Detatch then
    begin
      if Succeeded(AccPropServices.ClearHwndProps(FComponent.Handle,
                    OBJID_CLIENT, CHILDID_SELF, @NamePropIDs, 1)) then
      FAttached := FALSE;
    end
    else
      FAttached := FALSE;
  end;
end;

function TMSAAServer.EventCount: integer;
begin
  Result := FEventData.Count;
end;

function TMSAAServer.ImageEventIndex(
  Event: TVA508OnImageIndexQueryEvent): integer;
var
  i: integer;
  data: TImageEventData;
begin
  for i := 0 to FEventData.Count - 1 do
  begin
    if FEventData[i] is TImageEventData then
    begin
      data := TImageEventData(FEventData[i]);
      if (TMethod(data.Event).Code = TMethod(Event).Code) and
         (TMethod(data.Event).Data = TMethod(Event).Data) then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
  Result := -1;
end;

function TMSAAServer.ListProcIndex(Proc: TVA508ListQueryProc): integer;
var
  i: integer;
  data: TListProcData;
begin
  for i := 0 to FEventData.Count - 1 do
  begin
    if FEventData[i] is TListProcData then
    begin
      data := TListProcData(FEventData[i]);
      if @data.Proc = @Proc then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
  Result := -1;
end;

function TMSAAServer.GetComponent: TWinControl;
begin
  Result := FComponent;
end;

function TMSAAServer.GetPropValue(const pIDString: PByte;
  dwIDStringLen: LongWord; idProp: MSAAPROPID; out pvarValue: OleVariant;
  out pfHasProp: Integer): HResult;
var
  phwnd: HWND;
  pidObject: LongWord;
  pidChild: LongWord;
  text, CombinedText: string;

  function Append(data: array of string): string;
  var
    i: integer;
  begin
    Result := '';
    for i := low(data) to high(data) do
    begin
      if data[i] <> '' then
      begin
        if result <> '' then
          Result := Result + ' ';
        Result := Result + data[i];
      end;
    end;
  end;

  function GetImageLabelText(ImageListType: TVA508ImageListType; ImageIndex: integer): string;
  var
    i: integer;
    Data: TImageEventData;
  begin
    Result := '';
    for i := 0 to FEventData.Count - 1 do
    begin
      if FEventData[i] is TImageEventData then
      begin
        data := TImageEventData(FEventData[i]);
        if ImageListType in data.ImageListTypes then
        begin
          data.Event(FComponent, ImageIndex, ImageListType, Result);
          break;
        end;
      end;
    end;
  end;

  procedure DoTreeView;
  var
    id: HTREEITEM;
    node: TTreeNode;
    overlay: string;
    state: string;
    tree:TExposedTreeView;
  begin
    tree := TExposedTreeView(FComponent);
    id := HTREEITEM(pidChild);
    node := tree.Items.GetNode(id);
    if assigned(node) then
    begin
      state := '';
      overlay := '';
      // 0 state not valid on tree views
      if assigned(tree.StateImages) and (node.StateIndex > 0) then
        state := GetImageLabelText(iltStateImages, node.StateIndex);
      if node.Selected then
        text := GetImageLabelText(iltImages, node.SelectedIndex)
      else
        text := GetImageLabelText(iltImages, node.ImageIndex);
      if node.OverlayIndex >= 0 then
      begin
        overlay := GetImageLabelText(iltOverlayImages, node.OverlayIndex);
      end;
      text := Append([state, text, overlay, node.Text]);
    end;
  end;

  procedure DoListView;
  var
    view: TExposedListView;
    ilType: TVA508ImageListType;
    item: TListItem;
    state: string;
    overlay: string;
    i: integer;
    coltext: string;
  begin
    view := TExposedListView(FComponent);
    if pidChild > LongWord(view.Items.Count) then exit;
    state := '';
    overlay := '';
    item := view.Items[pidChild-1];
    if assigned(view.StateImages) then
      state := GetImageLabelText(iltStateImages, item.StateIndex);
    if view.ViewStyle = vsIcon then
      ilType := iltLargeImages
    else
      ilType := iltSmallImages;
    text := GetImageLabelText(ilType, item.ImageIndex);
    if (item.OverlayIndex >= 0) then
      overlay := GetImageLabelText(iltOverlayImages, item.OverlayIndex);
    text := Append([state, text, overlay]);

    if not (stList in FServerTypes) then
    begin
      if (view.ViewStyle = vsReport) and (view.Columns.Count > 0) then
        text := Append([text, view.Columns[0].Caption]);
      colText := item.Caption;
      if colText = '' then
        colText := 'blank';
      text := Append([text, colText]);

      if view.ViewStyle = vsReport then
      begin
        for i := 1 to view.Columns.Count - 1 do
        begin
          if view.Columns[i].Width > 0 then
          begin
            text := Append([text, view.Columns[i].Caption]);
            if (i-1) < item.SubItems.Count then
              colText := item.SubItems[i-1]
            else
              colText := '';
            if colText = '' then
              colText := 'blank';
            Text := Append([text, colText + ',']);
          end;
        end;
      end;
    end;
  end;

  procedure DoListComponent;
  var
    i: integer;
    data: TListProcData;
  begin
    for i := 0 to FEventData.Count - 1 do
    begin
      if FEventData[i] is TListProcData then
      begin
        data := TListProcData(FEventData[i]);
        data.Proc(FComponent, pidChild-1, text);
      end;
    end;
  end;

  procedure DoNormalComponent;
  var
    i: integer;
    data: TProcData;
  begin
    for i := 0 to FEventData.Count - 1 do
    begin
      if FEventData[i] is TProcData then
      begin
        data := TProcData(FEventData[i]);
        data.Proc(FComponent, text);
      end;
    end;
  end;

  procedure HasProperty;
  begin
    TVarData(pvarValue).VType := VT_BSTR;
    pfHasProp := 1;
    text := '';
  end;

  procedure NoProperty;
  begin
    TVarData(pvarValue).VType := VT_EMPTY;
    pfHasProp := 0;
  end;

begin
  VariantInit(pvarValue);
  OleCheck(AccPropServices.DecomposeHwndIdentityString(pIDString, dwIDStringLen,
    phwnd, pidObject, pidChild));
  if (phwnd = FComponent.Handle) then
  begin
    if (pidChild = CHILDID_SELF) then
    begin
      if stNormal in FServerTypes then
      begin
        HasProperty;
        DoNormalComponent;
        pvarValue := text;
      end
      else
        NoProperty;
    end
    else
    begin
      NoProperty;
      if (FServerTypes * [stList, stImageList]) <> [] then
      begin
        HasProperty;
        CombinedText := '';
        if stImageList in FServerTypes then
        begin
          if FComponent is TCustomTreeView then DoTreeView else
          if FComponent is TCustomListView then DoListView;
        end;
        CombinedText := text;
        text := '';
        if stList in FServerTypes then
        begin
          DoListComponent;
        end;
        if text <> '' then
        begin
          if CombinedText <> '' then
            CombinedText := CombinedText + ' ';
          CombinedText := CombinedText + text;
        end;
        pvarValue := CombinedText;
      end;
    end;
  end
  else
    NoProperty;
  Result := S_OK;
end;

procedure TMSAAServer.Hook;
begin
  FOldWndProc := FComponent.WindowProc;
  FComponent.WindowProc := MSAAWindowProc;
end;

procedure TMSAAServer.RemoveImageEvent(ImageListTypes: TVA508ImageListTypes;
  Event: TVA508OnImageIndexQueryEvent);
var
  idx: integer;
begin
  idx := ImageEventIndex(Event);
  if idx >= 0 then
    FEventData.Delete(idx);
  UnassignServerType(stImageList);
end;

procedure TMSAAServer.RemoveListProc(Proc: TVA508ListQueryProc);
var
  idx: integer;
begin
  idx := ListProcIndex(Proc);
  if idx >= 0 then
    FEventData.Delete(idx);
  UnassignServerType(stList);
end;

procedure TMSAAServer.RemoveProc(Proc: TVA508QueryProc);
var
  idx: integer;
begin
  idx := ProcIndex(Proc);
  if idx >= 0 then
    FEventData.Delete(idx);
  UnassignServerType(stNormal);
end;

class procedure TMSAAServer.ValidateServerType(AComponent: TWinControl; AServerType: TServerType);
var
  i: integer;

begin
  if AServerType = stImageList then
  begin
    for i := low(VA508ImageListLabelerClasses) to high(VA508ImageListLabelerClasses) do
    begin
      if AComponent is VA508ImageListLabelerClasses[i] then exit;
    end;
    raise TVA508Exception.Create('Unsupported Image List MSAA Label Component');
  end;
end;

procedure TMSAAServer.UnassignServerType(AServerType: TServerType);
begin
  FServerTypes := FServerTypes - [AServerType];
end;

procedure TMSAAServer.UnHook;
begin
  FComponent.WindowProc := FOldWndProc;
end;

procedure TMSAAServer.MSAAWindowProc(var Message: TMessage);
var
  DoAttach: boolean;
begin
  DoAttach := (Message.Msg = CM_SHOWINGCHANGED);
  FOldWndProc(Message);
  if DoAttach then  
  begin
    Unhook;
    Attach;
  end;
end;

function TMSAAServer.ProcIndex(Proc: TVA508QueryProc): integer;
var
  i: integer;
  data: TProcData;
begin
  for i := 0 to FEventData.Count - 1 do
  begin
    if FEventData[i] is TProcData then
    begin
      data := TProcData(FEventData[i]);
      if @data.Proc = @Proc then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
  Result := -1;
end;

initialization

finalization
  Cleanup;

end.

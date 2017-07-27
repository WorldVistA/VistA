unit VAClasses;

interface

uses
  Windows, Controls, Classes, SysUtils, Types, RTLConsts;

type
  TVABaseMethodList = class(TObject)
  strict private
    FCode: TList;
    FData: TList;
  strict protected
    function GetMethod(index: integer): TMethod;
    property Code: TList read FCode;
    property Data: TList read FData;
  protected
    constructor Create; virtual;
    function IndexOf(const Method: TMethod): integer;
    procedure Add(const Method: TMethod);
    procedure Clear;
    function Count: integer;
    procedure Delete(index: integer);
    procedure Remove(const Method: TMethod);
    property Methods[index: integer]: TMethod read GetMethod; default;
  public
    destructor Destroy; override;
  end;

  TVAMethodList = class(TVABaseMethodList)
  public
    constructor Create; override;
    destructor Destroy; override;
    function IndexOf(const Method: TMethod): integer;
    procedure Add(const Method: TMethod);
    procedure Clear;
    function Count: integer;
    procedure Delete(index: integer);
    procedure Remove(const Method: TMethod);
    property Methods;
  end;


  TVALinkedMethodList = class(TVABaseMethodList)
  private
    FLinkedObjects: TList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Add(Obj: TObject; const Method: TMethod);
    function IndexOf(const obj: TObject): integer;
    procedure Clear;
    function Count: integer;
    procedure Delete(index: integer);
    procedure Remove(const obj: TObject); overload;
    function GetMethod(Obj: TObject): TMethod;
//    property Methods;
  end;

  // event fires before the component has acted on the notification
  TVANotifyEvent = procedure(AComponent: TComponent; Operation: TOperation) of object;

  TVANotificationEventComponent = class(TComponent)
  private
    FOnNotifyEvent: TVANotifyEvent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor NotifyCreate(AOwner: TComponent; AOnNotifyEvent: TVANotifyEvent); virtual;
    property OnNotifyEvent: TVANotifyEvent read FOnNotifyEvent write FOnNotifyEvent;
  end;

  TVAListChangeEvent = procedure(Sender: TObject; Item: Pointer; Operation: TOperation) of object;

  TVAList = class(TList)
  private
    FOnChange: TVAListChangeEvent;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    property OnChange: TVAListChangeEvent read FOnChange write FOnChange;
  end;

const
  DynaPropAccesibilityCaption = 1;

type
  IVADynamicProperty = interface(IInterface)
  ['{1D1620E9-59D1-475D-94E9-FAE89A601D55}']
    function SupportsDynamicProperty(PropertyID: integer): boolean;
    function GetDynamicProperty(PropertyID: integer): string;
  end;

implementation

{ TVABaseMethodList }

procedure TVABaseMethodList.Add(const Method: TMethod);
begin
  if IndexOf(Method) < 0 then
  begin
    FCode.Add(Method.Code);
    FData.Add(Method.Data);
  end;
end;

procedure TVABaseMethodList.Clear;
begin
  FCode.Clear;
  FData.Clear;
end;

function TVABaseMethodList.Count: integer;
begin
  Result := FCode.Count;
end;

constructor TVABaseMethodList.Create;
begin
  FCode := TList.Create;
  FData := TList.Create;
end;

procedure TVABaseMethodList.Delete(index: integer);
begin
  FCode.Delete(index);
  FData.Delete(index);
end;

destructor TVABaseMethodList.Destroy;
begin
  FreeAndNil(FCode);
  FreeAndNil(FData);
  inherited;
end;

function TVABaseMethodList.GetMethod(index: integer): TMethod;
begin
  Result.Code := FCode[index];
  Result.Data := FData[index];
end;

function TVABaseMethodList.IndexOf(const Method: TMethod): integer;
begin
  if assigned(Method.Code) and assigned(Method.data) and (FCode.Count > 0) then
  begin
    Result := 0;
    while((Result < FCode.Count) and ((FCode[Result] <> Method.Code) or
          (FData[Result] <> Method.Data))) do inc(Result);
    if Result >= FCode.Count then Result := -1;
  end
  else
    Result := -1;
end;

procedure TVABaseMethodList.Remove(const Method: TMethod);
var
  idx: integer;

begin
  idx := IndexOf(Method);
  if(idx >= 0) then
  begin
    FCode.Delete(idx);
    FData.Delete(idx);
  end;
end;

{ TVAMethodList }

procedure TVAMethodList.Add(const Method: TMethod);
begin
  inherited Add(Method);
end;

procedure TVAMethodList.Clear;
begin
  inherited Clear;
end;

function TVAMethodList.Count: integer;
begin
  Result := inherited Count;
end;

constructor TVAMethodList.Create;
begin
  inherited Create;
end;

procedure TVAMethodList.Delete(index: integer);
begin
  inherited Delete(index);
end;

destructor TVAMethodList.Destroy;
begin
  inherited;
end;

function TVAMethodList.IndexOf(const Method: TMethod): integer;
begin
  Result := inherited IndexOf(Method);
end;

procedure TVAMethodList.Remove(const Method: TMethod);
begin
  inherited Remove(Method);
end;

{ TVANotificationEventComponent }

procedure TVANotificationEventComponent.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if assigned(FOnNotifyEvent) then FOnNotifyEvent(AComponent, Operation);
  inherited;
end;

constructor TVANotificationEventComponent.NotifyCreate(AOwner: TComponent;
  AOnNotifyEvent: TVANotifyEvent);
begin
  inherited Create(AOwner);
  FOnNotifyEvent := AOnNotifyEvent;
end;

{ TVALinkedMethodList }

procedure TVALinkedMethodList.Add(Obj: TObject; const Method: TMethod);
begin
  if assigned(obj) and assigned(Method.Code) and (IndexOf(Obj) < 0) then
  begin
    FLinkedObjects.Add(Obj);
    Code.Add(Method.Code);
    Data.Add(Method.Data);
  end;  
end;

procedure TVALinkedMethodList.Clear;
begin
  FLinkedObjects.Clear;
  Code.Clear;
  Data.Clear;
end;

function TVALinkedMethodList.Count: integer;
begin
  Result := FLinkedObjects.Count;
end;

constructor TVALinkedMethodList.Create;
begin
  inherited;
  FLinkedObjects := TList.Create;
end;

procedure TVALinkedMethodList.Delete(index: integer);
begin
  FLinkedObjects.Delete(index);
  Code.Delete(index);
  Data.Delete(index);
end;

destructor TVALinkedMethodList.Destroy;
begin
  FreeAndNil(FLinkedObjects);
  inherited;
end;

function TVALinkedMethodList.GetMethod(Obj: TObject): TMethod;
var
  idx: integer;
begin
  idx := IndexOf(Obj);
  if idx < 0 then
  begin
    Result.Code := nil;
    Result.Data := nil;
  end
  else
    Result := Methods[idx];
end;

function TVALinkedMethodList.IndexOf(const obj: TObject): integer;
begin
  if assigned(obj) then
    Result := FLinkedObjects.IndexOf(obj)
  else
    Result := -1;
end;

procedure TVALinkedMethodList.Remove(const obj: TObject);
var
  i: integer;
begin
  i := IndexOf(obj);
  if i >= 0 then
    Delete(i);
end;

{ TVAList }

procedure TVAList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if assigned(FOnChange) and (Ptr <> nil) then
  begin
    if Action = lnAdded then
      FOnChange(Self, Ptr, opInsert)
    else
      FOnChange(Self, Ptr, opRemove)
  end;
end;

end.


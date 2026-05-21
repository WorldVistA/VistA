unit ORCtrls.RPCList;

// ***************************************************************************************
//
//
//
// TRPC - Modified TStringList that contains information about each RPC call
//
// TRPCList - Object that contains a list of TRPC objects
//
//
//
// ***************************************************************************************

interface

uses
  System.Classes,
  System.SyncObjs,
  System.Generics.Collections,
  System.JSON;

type
  TRPCList = class;

  TRPC = class(TObject)
  private
    FList: TStringList;
    FDuration: string;
    FLock: TCriticalSection;
    FName: string;
    FRanAt: string;
    FOwner: TObject;
    function GetDuration: string;
    function GetName: string;
    function GetRanAt: string;
    procedure SetDuration(const Value: string);
    procedure SetName(const Value: string);
    procedure SetRanAt(const Value: string);
    procedure SetOwner(const Value: TObject);
    function GetText: String;
    procedure SetText(const Value: String);
    function Get(Index: Integer): string;
    procedure Put(Index: Integer; const Value: string);
  protected
    function GetOwner: TObject;
  public
    function Add(const S: string): Integer;
    procedure Assign(const Source: TRPC); overload;
    procedure Assign(const Source: TStringList); overload;
    constructor Create(const aCriticalSection: TCriticalSection);
    destructor Destroy; override;
    procedure Insert(Index: Integer; const S: string);
    property List: TStringList read FList;
    procedure LoadFromJsonObject(Value: TJsonObject);
    procedure Lock;
    procedure ToJSON(out AResult: TJsonObject);
    procedure Unlock;
    property Duration: string read GetDuration write SetDuration;
    property Name: string read GetName write SetName;
    property RanAt: string read GetRanAt write SetRanAt;
    property Strings[Index: Integer]: string read Get write Put; default;
    property Text: String read GetText write SetText;
    property Owner: TObject read GetOwner write SetOwner;
  end;

  TListNotifyProc = procedure(const Value: TRPC) of object;

  TRPCList = class(TObject)
  private
    FList: TObjectList<TRPC>;
    FLock: TCriticalSection;
    FOnAdd: TListNotifyProc;
    FOnDelete: TListNotifyProc;
    function GetList: TObjectList<TRPC>;
    function GetItems(Index: integer): TRPC;
    procedure SetList(const Value: TObjectList<TRPC>);
    function GetCount: integer;
    function GetStrings(Index: integer): TStringList;
    function GetOnDelete: TListNotifyProc;
    procedure SetOnDelete(const Value: TListNotifyProc);
    function GetOnAdd: TListNotifyProc;
    procedure SetOnAdd(const Value: TListNotifyProc);
  public
    function Add(const Value: TRPC): NativeInt;
    procedure AddRPCs(RPCList: TRPCList);
    procedure Assign(const Source: TRPCList);
    procedure Clear;
    procedure Delete(Index: integer);
    constructor Create; overload;
    constructor Create(aCriticalSection: TCriticalSection); overload;
    constructor Create(AOwnsObjects: Boolean; aCriticalSection: TCriticalSection); overload;
    destructor Destroy; override;
    procedure LoadFromJsonObject(Value: TJsonObject);
    procedure Lock;
    procedure Notify(Sender: TObject; const Item: TRPC; Action: TCollectionNotification);
    procedure Remove(const Value: TRPC);
    procedure ToJSON(out AResult: TJsonObject);
    procedure Unlock;
    property Count: integer read GetCount;
    property Items[Index: integer]: TRPC read GetItems;
    property List: TObjectList<TRPC> read GetList write SetList;
    property OnAdd: TListNotifyProc read GetOnAdd write SetOnAdd;
    property OnDelete: TListNotifyProc read GetOnDelete write SetOnDelete;
    property Strings[Index: integer]: TStringList read GetStrings; default;
  end;

implementation

uses
  System.SysUtils;

{ TRPC }

function TRPC.Add(const S: string): Integer;
begin
  Exit(FList.Add(S));
end;

procedure TRPC.Assign(const Source: TRPC);
begin
  Lock;
  try
    Self.Name := TRPC(Source).Name;
    Self.RanAt := TRPC(Source).RanAt;
    Self.Duration := TRPC(Source).Duration;
    Self.FList.Assign(TRPC(Source).List);
  finally
    Unlock;
  end;
end;

procedure TRPC.Assign(const Source: TStringList);
begin
  Lock;
  try
    Self.FList.Assign(Source);
  finally
    Unlock;
  end;
end;

constructor TRPC.Create(const ACriticalSection: TCriticalSection);
begin
  inherited Create;
  FLock := ACriticalSection;
  FList := TStringList.create;
end;

destructor TRPC.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TRPC.Get(Index: Integer): string;
begin
  Lock;
  try
    Exit(fList.Strings[Index]);
  finally
    Unlock;
  end;
end;

function TRPC.GetDuration: string;
begin
  Lock;
  try
    Exit(FDuration);
  finally
    Unlock;
  end;
end;

function TRPC.GetName: string;
begin
  Lock;
  try
    Exit(FName);
  finally
    Unlock;
  end;
end;

function TRPC.GetOwner: TObject;
begin
  Lock;
  try
    Exit(FOwner);
  finally
    Unlock;
  end;
end;

function TRPC.GetRanAt: string;
begin
  Exit(FRanAt);
end;

function TRPC.GetText: String;
begin
  Lock;
  try
    Exit(FList.Text);
  finally
    Unlock;
  end;
end;

procedure TRPC.Insert(Index: Integer; const S: string);
begin
  Lock;
  try
    FList.Insert(Index, S);
  finally
    Unlock;
  end;
end;

procedure TRPC.LoadFromJsonObject(Value: TJsonObject);
var
  S: string;
begin
  If not Assigned(Value) then
    raise Exception.Create('Error trying to load RPC log from JSON. Value not assigned');

  Lock;
  try
    try
      Value.TryGetValue<string>('Name', FName);
      Value.TryGetValue<string>('Duration', FDuration);
      Value.TryGetValue<string>('RanAt', FRanAt);
      Value.TryGetValue<string>('Text', S);
      FList.Text := S;
    except
      on E : Exception do
        raise Exception.Create('Error trying to load RPC log from JSON' + E.ClassName +'  error raised, with message : ' + E.Message);
    end;
  finally
    Unlock;
  end;
end;

procedure TRPC.Lock;
begin
  if Assigned(FLock) then
    FLock.Acquire;
end;

procedure TRPC.Put(Index: Integer; const Value: string);
begin
 Lock;
  try
    FList[Index] := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.SetDuration(const Value: string);
begin
  Lock;
  try
    FDuration := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.SetName(const Value: string);
begin
  Lock;
  try
    FName := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.SetOwner(const Value: TObject);
begin
  Lock;
  try
    FOwner := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.SetRanAt(const Value: string);
begin
  Lock;
  try
    FRanAt := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.SetText(const Value: String);
begin
  Lock;
  try
    FList.Text := Value;
  finally
    Unlock;
  end;
end;

procedure TRPC.ToJSON(out AResult: TJsonObject);
begin
  AResult := TJsonObject.Create;
  AResult.AddPair('Name', Self.Name);
  AResult.AddPair('Duration', Self.Duration);
  AResult.AddPair('RanAt', Self.RanAt);
  AResult.AddPair('Text', TJSONString.Create(Self.Text));
end;

procedure TRPC.Unlock;
begin
  if Assigned(FLock) then
    FLock.Release;
end;

{ TRPCList }

function TRPCList.Add(const Value: TRPC): NativeInt;
begin
  Lock;
  try
    Exit(FList.Add(Value));
  finally
    Unlock;
  end;
end;

procedure TRPCList.AddRPCs(RPCList: TRPCList);
begin
  if Assigned(RPCList) then
  begin
    // Add the existing intems from ORNET to the local list
    for var i := 0 to RPCList.Count - 1 do
    begin
      Self.Add(RPCList.Items[i]);
    end;
  end;
end;

procedure TRPCList.Assign(const Source: TRPCList);
var
  aRPC: TRPC;
begin
  Lock;
  try
    for var i := 0 to Source.List.Count - 1 do
    begin
      aRPC := TRPC.Create(FLock);
      aRPC.Assign(Source.Items[i]);
      Self.Add(aRPC);
    end;
  finally
    Unlock;
  end;
end;

constructor TRPCList.Create;
begin
  Create(True, nil);
end;

procedure TRPCList.Clear;
begin
  Lock;
  try
    FList.Clear;
  finally
    Unlock;
  end;
end;

constructor TRPCList.Create(AOwnsObjects: Boolean; ACriticalSection: TCriticalSection);
begin
  Lock;
  try
    inherited Create;
    FLock := ACriticalSection;
    FList := TObjectList<TRPC>.Create(AOwnsObjects);
    FList.OnNotify := Notify;
  finally
    Unlock;
  end;
end;

constructor TRPCList.Create(ACriticalSection: TCriticalSection);
begin
  Create(True, ACriticalSection);
end;

procedure TRPCList.Delete(Index: Integer);
begin
  Lock;
  try
    FList.Delete(Index);
  finally
    Unlock;
  end;
end;

destructor TRPCList.Destroy;
begin
  Lock;
  try
    FreeAndNil(FList);
    inherited;
  finally
    Unlock;
  end;
end;

function TRPCList.GetList: TObjectList<TRPC>;
begin
  Lock;
  try
    Exit(FList);
  finally
    Unlock;
  end;
end;

function TRPCList.GetOnAdd: TListNotifyProc;
begin
  Lock;
  try
    Result := FOnAdd;
  finally
    Unlock;
  end;
end;

function TRPCList.GetOnDelete: TListNotifyProc;
begin
  Lock;
  try
    Result := FOnDelete;
  finally
    Unlock;
  end;
end;

function TRPCList.GetStrings(Index: Integer): TStringList;
begin
  Lock;
  try
    Exit((FList.Items[Index] as TRPC).List);
  finally
    Unlock;
  end;
end;

procedure TRPCList.LoadFromJsonObject(Value: TJsonObject);
var
  LoadStr: string;
  RPCArray: TJsonArray;
  aRPC: TRPC;
begin
  LoadStr := Value.Format;

  if Value.TryGetValue<TJsonArray>('RPCS', RPCArray) then
  begin
    for var i := 0 to RPCArray.Count - 1 do
    begin
      aRPC := TRPC.Create(nil);
      aRPC.LoadFromJsonObject(RPCArray.Items[i] as TJsonObject);
      FList.Add(aRPC);
    end;
  end;
end;

procedure TRPCList.Lock;
begin
  if Assigned(FLock) then
    FLock.Acquire;
end;

procedure TRPCList.Notify(Sender: TObject; const Item: TRPC; Action: TCollectionNotification);

  procedure TryFreeOwnedObject;
  begin
    If (Assigned(FList) and not FList.OwnsObjects) and (Assigned(Item) and (Self = TRPCList(Item.Owner))) then
      FreeAndNil(Item);
  end;

begin
  // Sender TObjectList<TRPC>
  // self  TRPCList

  Case Action of
    cnRemoved:
      begin
        If Assigned(FOnDelete) then
          FOnDelete(Item);
      end;
  End;

  inherited;

  Case Action of
    cnAdded:
      begin
        If Assigned(FOnAdd) then
          FOnAdd(Item);
      end;
    cnRemoved:
      TryFreeOwnedObject;
  End;
end;

procedure TRPCList.Remove(const Value: TRPC);
begin
  Lock;
  try
    FList.Remove(Value);
  finally
    Unlock;
  end;
end;

function TRPCList.GetCount: Integer;
begin
  Lock;
  try
    If Assigned(FList) then
      Exit(FList.Count)
    else
      Exit(0);
  finally
    Unlock;
  end;
end;

function TRPCList.GetItems(Index: Integer): TRPC;
begin
  Lock;
  try
    Exit(FList.Items[Index]);
  finally
    Unlock;
  end;
end;

procedure TRPCList.SetList(const Value: TObjectList<TRPC>);
begin
  Lock;
  try
    FList := Value;
  finally
    Unlock;
  end;
end;

procedure TRPCList.SetOnAdd(const Value: TListNotifyProc);
begin
  Lock;
  try
    FOnAdd := Value;
  finally
    Unlock;
  end;
end;

procedure TRPCList.SetOnDelete(const Value: TListNotifyProc);
begin
  Lock;
  try
    FOnDelete := Value;
  finally
    Unlock;
  end;
end;

procedure TRPCList.ToJSON(out AResult: TJsonObject);
var
  ItemsArray: TJsonArray;
  ItemObject: TJsonObject;
begin
  AResult := TJsonObject.Create;
  AResult.AddPair('Export Date', TJSONString.Create(FormatDateTime('YYYY-MM-DD HH:NN:SS', Now)));
  ItemsArray := TJsonArray.Create;
  AResult.AddPair(TJSONPair.Create('RPCS', ItemsArray));
  for var i := 0 to Self.Count - 1 do
  begin
    Items[i].ToJSON(ItemObject);
    ItemsArray.Add(ItemObject);
  end;
end;

procedure TRPCList.Unlock;
begin
  if Assigned(FLock) then
    FLock.Release;
end;

end.

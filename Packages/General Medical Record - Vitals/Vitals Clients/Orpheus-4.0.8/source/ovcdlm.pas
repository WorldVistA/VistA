{*********************************************************}
{*                   OVCDLM.PAS 4.08                     *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdlm;

interface

uses
  Windows, Classes, SysUtils;

{.$DEFINE OvcDlmDebug}
const
  dlmMaxKeys = 64;

{ TOvcPoolManager }

const
  dlmPageSize = 4096;
  dlmMaxItemSize = dlmPageSize - sizeof(Pointer);

type
  PPointer = ^Pointer;
  POvcPoolPage = ^TOvcPoolPage;
  TOvcPoolPage = packed record
    Data : array[0..pred(dlmMaxItemSize)] of byte;
    NextPage : POvcPoolPage;                           {moved to last}
  end;

  TOvcPoolManager = class
  protected {protected}
    FirstPage : POvcPoolPage;
    LastPage : POvcPoolPage;
    LastPageTop : Pointer;
    LastPageEnd : Pointer;
    InternalSize : Integer;
    ItemsPerPage : Integer;
    DeletedList : Pointer;
    OwnerThread : DWord;
  protected
    procedure NewPage;
  public
    procedure Clear;
    constructor Create(ItemSize : Integer);
    destructor Destroy; override;
    function NewItem : Pointer;
    procedure DeleteItem(Item : Pointer);
  end;

const
  EntriesPerPage = (4092 - 2*sizeof(Integer) - 3*SizeOf(Pointer)) div sizeof(Pointer);
    {5 = UseCount, PageType, Owner, LowKey, HighKey}
  DATAPAGE = 0;
  INDEXPAGE = 1;
type
  POvcPTDataPage = ^TOvcPTDataPage;
  TOvcPTDataArray = array[0..pred(EntriesPerPage)] of Pointer;
  POvcPTDataArray = ^TOvcPTDataArray;
  TOvcPTDataPage = record
    Data : TOvcPTDataArray;
    UseCount : Integer;
    PageType : Integer;
    Owner : POvcPTDataPage;
    LowKey, HighKey : Pointer;
  end;
  TOvcPageTree = class;
  TOvcPTSearchResult = (srFound, srPageFound, srBelowPage, srAbovePage);
  TOvcPTCompareFunc = function(Sender: TOvcPageTree; UserData, Key1, Key2: Pointer): Integer of object;
  TOvcPTPageChangeProc = procedure(Sender: TOvcPageTree; UserData: Pointer; Count: Integer; DataArray : POvcPTDataArray; NewPage: Pointer) of object;
  TOvcPageTree = class
  protected
    {contains last successful search result}
    iLastKeyPage : POvcPTDataPage;
    iLastKeyIndex : Integer;
    PageStack,
    IndexStack: TList;
    FCompare: TOvcPTCompareFunc;
    FPageChange: TOvcPTPageChangeProc;
    function BinarySearch(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
    function InternalGEQ(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): Boolean;
    function InternalAdd(Key: Pointer; var TargetPage: POvcPTDataPage): Boolean;
    procedure DeletePage(Page: POvcPTDataPage);
    function BinarySearchData(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
    function BinarySearchIndex(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
    procedure Clear;
    procedure Init;
  protected
    Root : POvcPTDataPage;
    Pool : TOvcPoolManager;
    FUserData: Pointer;
    procedure NotifyPageChange(Page: POvcPTDataPage);
    procedure RecalcEdges;
    procedure ClearPosition(Page: POvcPTDataPage);
  public
    constructor Create(UserData: Pointer);
    destructor Destroy; override;
    function Add(Key: Pointer): Boolean;
    function AddEx(Key: Pointer; var DataPage: Pointer): Boolean;
    function GEQ(Key: Pointer; var Data: Pointer): Boolean;
    function GNX(var Data: Pointer): Boolean;
    function GPR(var Data: Pointer): Boolean;
    function GFirst(var Data: Pointer): Boolean;
    function GLast(var Data: Pointer): Boolean;
    function GGEQ(Key: Pointer; var Data: Pointer): Boolean;
    function GLEQ(Key: Pointer; var Data: Pointer): Boolean;
    function Delete(Key: Pointer): Boolean;
    function DeleteEx(Key, IndexPage: Pointer; AllowCompare: Boolean): Boolean;
    procedure PushPosition;
    function PopPosition: Boolean;
    property OnCompare: TOvcPTCompareFunc read FCompare write FCompare;
    property OnPageChange: TOvcPTPageChangeProc read FPageChange write FPageChange;
  end;

{ TOvcList }
type
  TOvcListNode0 = record
    Item : Pointer;
    UserData: Pointer;
    IndexPage: Pointer;
  end;
  TOvcListNode = record
    Item : Pointer;
    UserData : Pointer;
    IndexPages: array[0..dlmMaxKeys] of Pointer;
  end;
  POvcListNode = ^TOvcListNode;
  TOvcList = class
  protected
    Pool : TOvcPoolManager;
    Index: TOvcPageTree;
    FCount: Integer;
    function GetUserData(Node: POvcListNode) : Pointer;
    procedure SetUserData(Node: POvcListNode; Value : Pointer);
    function NewNode : POvcListNode;
    procedure FreeNode(P : POvcListNode);
    function Compare(Sender: TOvcPageTree; UserData, Key1, Key2: Pointer): Integer;
    procedure PageChange(Sender: TOvcPageTree; UserData: Pointer; Count: Integer; DataArray : POvcPTDataArray; NewPage: Pointer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure DeleteNode(Node: POvcListNode); virtual;
    function Add(Item : Pointer) : POvcListNode; virtual;
    function ItemExists(Item: Pointer): Boolean;
    procedure AddIfUnique(Item: Pointer);
    function AddObject(Item,UserData : Pointer) : POvcListNode; virtual;
    procedure Clear;
    procedure Delete(Item: Pointer); virtual;
    function Empty: Boolean;
    function FindNode(Item: Pointer): POvcListNode;
    procedure SetAllUserData(Value : Pointer);
    property UserData[Node: POvcListNode] : Pointer read GetUserData write SetUserData;
    function First(var Node: POvcListNode): Boolean;
    function Next(var Node: POvcListNode): Boolean;
    function Last(var Node: POvcListNode): Boolean;
    function Prev(var Node: POvcListNode): Boolean;
    property Count: Integer read FCount;
    procedure PushIndexPosition;
    procedure PopIndexPosition;
  end;


{ TOvcSortedList }
type
  TOvcMultiCompareFunc = function(Key : Integer; I1,I2 : Pointer) : Integer of object;
  TOvcSortedList = class(TOvcList)
  protected
    FCompareFunc : TOvcMultiCompareFunc;
    FCurrentKey : Integer;
    KeyCount : Integer;
    Indexes: array[0..pred(dlmMaxKeys)] of TOvcPageTree;
    FCount: Integer;
    function GetCount: Integer;
    procedure SetCurrentKey(Value : Integer);
    function CompareM(Sender: TOvcPageTree; UserData, Key1, Key2: Pointer): Integer;
    procedure PageChangeM(Sender: TOvcPageTree; UserData: Pointer; Count: Integer; DataArray : POvcPTDataArray; NewPage: Pointer);
    function ComputeCount: Integer;
  public
    function Add(Item : Pointer) : POvcListNode; override;
    function AddObject(Item,UserData : Pointer) : POvcListNode; override;
    constructor Create(NumKeys : Integer; CompareFunc : TOvcMultiCompareFunc);
    procedure Clear;
    property CurrentKey : Integer read FCurrentKey write SetCurrentKey;
    procedure Delete(Item: Pointer); override;
    destructor Destroy; override;
    function FirstItem: Pointer;
    function LastItem: Pointer;
    function First(var Item: Pointer): Boolean;
    function Next(var Item: Pointer): Boolean;
    function Last(var Item: Pointer): Boolean;
    function Prev(var Item: Pointer): Boolean;
    property Count: Integer read GetCount;
    function GGEQ(SearchItem: Pointer; var Item: Pointer): Boolean;
    function GLEQ(SearchItem: Pointer; var Item: Pointer): Boolean;
    procedure DeleteNode(Node: POvcListNode); override;
    procedure PushIndex;
    procedure PopIndex;
  end;

{ TOvcLiteCache }
type
  TOvcFCRemoveNotifier = procedure(const Value) of object;
  TOvcLiteCache = class
  protected
    function GetTimeStamp(Index: Integer): NativeInt;
    procedure SetTimeStamp(Index: Integer; const Value: NativeInt);
    function GetKeySlot(Index: Integer): Pointer;
    function GetValueSlot(Index: Integer): Pointer;
  protected
    Buffer : Pointer;
    CacheCount : Integer;
    FCacheSize : Integer;
    FRemoveNotifier : TOvcFCRemoveNotifier;
    FValueSize : Integer;
    property TimeStamp[Index : Integer] : NativeInt read GetTimeStamp write SetTimeStamp;
    property KeySlot[Index : Integer] : Pointer read GetKeySlot;
    property ValueSlot[Index : Integer] : Pointer read GetValueSlot;
  public
    procedure AddValue(Key : Pointer; const Value);
    procedure Clear;
    constructor Create(ValueSize, CacheSize : Integer);
    destructor Destroy; override;
    function GetValue(Key : Pointer; var Value) : Boolean;
    property RemoveNotifier : TOvcFCRemoveNotifier read FRemoveNotifier write FRemoveNotifier;
    procedure RemoveValue(Key : Pointer);
  end;

{ TOvcLiteStringCache }

  TOvcLiteStringCache = class
  protected
    FCache : TOvcLiteCache;
    procedure RemoveNotifier(const Value);
  public
    procedure AddValue(Key : Pointer; const Value : string);
    procedure Clear;
    constructor Create(CacheSize : Integer);
    destructor Destroy; override;
    function GetValue(Key : Pointer; var Value : string) : Boolean;
    procedure RemoveValue(Key : Pointer);
  end;

  TOvcFastList = class(TObject)
  protected
    FList: PPointerList;
    FCount: Integer;
    FCapacity: Integer;
  protected
    function Get(Index: Integer): Pointer;
    procedure Grow;
    procedure Put(Index: Integer; Item: Pointer);
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
    class procedure BoundsError(Data: Integer);
    class procedure CapacityError(Data: Integer);
    class procedure CountError(Data: Integer);
    //property Capacity: Integer read FCapacity write SetCapacity;
  public
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function IndexOf(Item: Pointer): Integer;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
    property List: PPointerList read FList;
  end;

implementation

{===== Local routines=================================================}
function NewString(const S: string): PString;
begin
  New(Result);
  Result^ := S;
end;

procedure DisposeString(P: PString);
begin
  if (P <> nil)
  {and (P^ <> '')} then
    Dispose(P);
end;

{===== TOvcList ======================================================}

function TOvcList.Add(Item : Pointer) : POvcListNode;
begin
  Result := NewNode;
  Result^.Item := Item;
  Index.AddEx(Result, Result^.IndexPages[0]);
  inc(FCount);
end;

procedure TOvcList.AddIfUnique(Item: Pointer) ;
var
  Node: POvcListNode;
begin
  if not ItemExists(Item) then begin
    Node := NewNode;
    Node^.Item := Item;
    Index.AddEx(Node, Node^.IndexPages[0]);
    inc(FCount);
  end;
end;

function TOvcList.ItemExists(Item: Pointer): Boolean;
var
  SearchItem: TOvcListNode;
  ItemFound: POvcListNode;
begin
  SearchItem.Item := Item;
  Result := Index.GEQ(@SearchItem, Pointer(ItemFound));
end;

function TOVcList.FindNode(Item: Pointer): POvcListNode;
var
  LookNode: TOvcListNode;
begin
  LookNode.Item := Item;
  if not Index.GEQ(@LookNode, Pointer(Result)) then
    Result := nil;
end;

function TOvcList.AddObject(Item,UserData : Pointer) : POvcListNode;
begin
  Result := NewNode;
  Result^.Item := Item;
  Result^.UserData := UserData;
  Index.AddEx(Result, Result^.IndexPages[0]);
  inc(FCount);
end;

procedure TOvcList.Clear;
begin
  Index.Clear;
  if Pool <> nil then
    Pool.Clear;
  FCount := 0;
end;

constructor TOvcList.Create;
begin
  Index := TOvcPageTree.Create(nil);
  Index.OnCompare := Compare;
  Index.OnPageChange := PageChange;
  Pool := TOvcPoolManager.Create(sizeof(TOvcListNode0));
end;

procedure TOvcList.DeleteNode(Node: POvcListNode);
begin
  Index.DeleteEx(Node, Node^.IndexPages[0], True );
  FreeNode(Node);
  dec(FCount);
end;

procedure TOvcList.Delete(Item: Pointer);
var
  Tmp: POvcListNode;
begin
  Tmp := FindNode(Item);
  if Tmp <> nil then begin
    Index.DeleteEx(Tmp, Tmp^.IndexPages[0], True );
    FreeNode(Tmp);
    dec(FCount);
  end else
    raise Exception.Create('List node not found');
end;

destructor TOvcList.Destroy;
begin
  Index.Free;
  Pool.Free;
end;

procedure TOvcList.FreeNode(P : POvcListNode);
begin
  Pool.DeleteItem(P);
end;

function TOvcList.GetUserData(Node: POvcListNode): Pointer;
begin
  Result := Node.UserData;
end;

procedure TOvcList.SetAllUserData(Value : Pointer);
var
  Tmp : POvcListNode;
begin
  if First(Tmp) then
    repeat
      Tmp^.UserData := Value;
    until not Next(Tmp);
end;

procedure TOvcList.SetUserData(Node: POvcListNode; Value: Pointer);
begin
  Node.UserData := Value;
end;

function TOvcList.NewNode: POvcListNode;
begin
  Result := Pool.NewItem;
end;

function TOvcList.Compare(Sender: TOvcPageTree; UserData, Key1,
  Key2: Pointer): Integer;
begin
  Result := NativeUInt(POvcListNode(Key1)^.Item) - NativeUInt(POvcListNode(Key2)^.Item);
end;

function TOvcList.First(var Node: PovcListNode): Boolean;
begin
  Result := Index.GFirst(Pointer(Node));
end;

function TOvcList.Next(var Node: POvcListNode): Boolean;
begin
  Result := Index.GNX(Pointer(Node));
end;

procedure TOvcList.PageChange(Sender: TOvcPageTree; UserData: Pointer; Count: Integer;
  DataArray: POvcPTDataArray; NewPage: Pointer);
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    POvcListNode(DataArray[i])^.IndexPages[0] := NewPage;
end;

function TOvcList.Empty: Boolean;
var
  Node: POvcListNode;
begin
  Result := not First(Node);
end;

function TOvcList.Last(var Node: POvcListNode): Boolean;
begin
  Result := Index.GLast(Pointer(Node));
end;

{ new}
procedure TOvcList.PopIndexPosition;
begin
  Index.PopPosition;
end;

function TOvcList.Prev(var Node: POvcListNode): Boolean;
begin
  Result := Index.GPR(Pointer(Node));
end;

{ new}
procedure TOvcList.PushIndexPosition;
begin
  Index.PushPosition;
end;

{===== TOvcSortedList ================================================}


function TOvcSortedList.Add(Item : Pointer) : POvcListNode;
var
  i : Integer;
begin
  Result := inherited Add(Item);
  for i := 0 to pred(KeyCount) do
    Indexes[i].AddEx(Result, Result^.IndexPages[i + 1]); {index zero used by ancestor}
  inc(FCount);
end;

function TOvcSortedList.AddObject(Item,UserData : Pointer) : POvcListNode;
begin
  Result := Add(Item);
  Result^.UserData := UserData;
end;

procedure TOvcSortedList.Clear;
var
  i : Integer;
begin
  Index.Clear;
  for i := 0 to pred(KeyCount) do
    Indexes[i].Clear;
  if Pool <> nil then
    Pool.Clear;
  FCount := 0;
end;

constructor TOvcSortedList.Create(NumKeys: Integer;
  CompareFunc: TOvcMultiCompareFunc);
var
  i : Integer;
begin
  if NumKeys > dlmMaxKeys then
    raise Exception.Create('Too many keys in list');
  Index := TOvcPageTree.Create(nil); {master index used by ancestor}
  Index.OnCompare := Compare;
  Index.OnPageChange := PageChange;
  Pool := TOvcPoolManager.Create(sizeof(TOvcListNode0) + NumKeys * sizeof(Pointer));
  FCompareFunc := CompareFunc;
  FCurrentKey := -1;
  KeyCount := NumKeys;
  for i := 0 to pred(NumKeys) do begin
    Indexes[i] := TOvcPageTree.Create(Pointer(i + 1));
    Indexes[i].OnCompare := CompareM;
    Indexes[i].OnPageChange := PageChangeM;
  end;
end;

procedure TOvcSortedList.DeleteNode(Node: POvcListNode);
var
  i : Integer;
begin
  for i := 0 to pred(KeyCount) do
    Indexes[i].DeleteEx(Node, Node^.IndexPages[i + 1], True {??});
  inherited DeleteNode(Node);
  dec(FCount);
end;

procedure TOvcSortedList.Delete(Item: Pointer);
var
  Tmp: POvcListNode;
begin
  Tmp := FindNode(Item);
  if Tmp = nil then
    raise Exception.Create('Node not found');
  DeleteNode(Tmp);
end;

destructor TOvcSortedList.Destroy;
var
  i : Integer;
begin
  inherited Destroy;
  for i := 0 to pred(KeyCount) do
    Indexes[i].Free;
end;

function TOvcSortedList.CompareM(Sender: TOvcPageTree; UserData, Key1,
  Key2: Pointer): Integer;
begin
  if Key1 = Key2 then
    Result := 0
  else begin
    Result := FCompareFunc(Integer(UserData) - 1, POvcListNode(Key1).Item, POvcListNode(Key2).Item);
    if Result = 0 then
      if Key1 = Key2 then
        raise Exception.Create('Internal error')
      else
        Result := NativeUInt(Key1) - NativeUInt(Key2);
  end;
end;

procedure TOvcSortedList.PageChangeM(Sender: TOvcPageTree;
  UserData: Pointer; Count: Integer; DataArray: POvcPTDataArray;
  NewPage: Pointer);
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    POvcListNode(DataArray[i]).IndexPages[Integer(UserData)] := NewPage;
end;

procedure TOvcSortedList.SetCurrentKey(Value: Integer);
begin
  if (Value < -1) or (Value >= KeyCount) then
    raise Exception.Create('Key number out of range');
  if FCurrentKey <> Value then
    FCurrentKey := Value;
end;

function TOvcSortedList.FirstItem: Pointer;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then begin
    if not Index.GFirst(Pointer(Node)) then
      Result := nil
    else
      Result := Node.Item;
  end else begin
    if not Indexes[FCurrentKey].GFirst(Pointer(Node)) then
      Result := nil
    else
      Result := Node.Item;
  end;
end;

function TOvcSortedList.LastItem: Pointer;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then begin
    if not Index.GLast(Pointer(Node)) then
      Result := nil
    else
      Result := Node.Item;
  end else begin
    if not Indexes[FCurrentKey].GLast(Pointer(Node)) then
      Result := nil
    else
      Result := Node.Item;
  end;
end;

function TOvcSortedList.First(var Item: Pointer): Boolean;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then
    Result := Index.GFirst(Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GFirst(Pointer(Node));
  if Result then
    Item := Node.Item;
end;

function TOvcSortedList.Next(var Item: Pointer): Boolean;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then
    Result := Index.GNx(Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GNx(Pointer(Node));
  if Result then
    Item := Node.Item;
end;

function TOvcSortedList.Last(var Item: Pointer): Boolean;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then
    Result := Index.GLast(Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GLast(Pointer(Node));
  if Result then
    Item := Node.Item;
end;

function TOvcSortedList.Prev(var Item: Pointer): Boolean;
var
  Node: POvcListNode;
begin
  if FCurrentKey = -1 then
    Result := Index.GPr(Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GPr(Pointer(Node));
  if Result then
    Item := Node.Item;
end;

procedure TOvcSortedList.PopIndex;
begin
  {$IFOPT C+}
  if FCurrentKey = -1 then
    Assert(Index.PopPosition)
  else
    Assert(Indexes[FCurrentKey].PopPosition);
  {$ELSE}
  if FCurrentKey = -1 then
    Index.PopPosition
  else
    Indexes[FCurrentKey].PopPosition;
  {$ENDIF}
end;

procedure TOvcSortedList.PushIndex;
begin
  if FCurrentKey = -1 then
    Index.PushPosition
  else
    Indexes[FCurrentKey].PushPosition;
end;

function TOvcSortedList.ComputeCount: Integer;
var
  Item: Pointer;
begin
  Result := 0;
  if First(Item) then
    repeat
      inc(Result);
    until not Next(Item);
end;

function TOvcSortedList.GetCount: Integer;
begin
  Result := FCount;
  Assert(Result = ComputeCount);
end;

function TOvcSortedList.GGEQ(SearchItem: Pointer; var Item: Pointer): Boolean;
var
  SearchNode: TOvcListNode;
  Node: POvcListNode;
begin
  SearchNode.Item := SearchItem;
  if FCurrentKey = -1 then
    Result := Index.GGEQ(@SearchNode, Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GGEQ(@SearchNode, Pointer(Node));
  if Result then
    Item := Node.Item;
end;

function TOvcSortedList.GLEQ(SearchItem: Pointer;
  var Item: Pointer): Boolean;
var
  SearchNode: TOvcListNode;
  Node: POvcListNode;
begin
  SearchNode.Item := SearchItem;
  if FCurrentKey = -1 then
    Result := Index.GLEQ(@SearchNode, Pointer(Node))
  else
    Result := Indexes[FCurrentKey].GLEQ(@SearchNode, Pointer(Node));
  if Result then
    Item := Node.Item;
end;

{===== TOvcLiteCache =================================================}

procedure TOvcLiteCache.AddValue(Key : Pointer; const Value);
var
  Old : Integer;
  i,NewSlot : Integer;
begin
  if CacheCount >= FCacheSize then begin
    Old := MaxLongInt;
    NewSlot := -1;
    for i := 0 to pred(CacheCount) do
      if TimeStamp[i] < Old then begin
        Old := TimeStamp[i];
        NewSlot := i;
      end;
    if (NewSlot <> -1) then
      if assigned(FRemoveNotifier) then
        FRemoveNotifier(ValueSlot[NewSlot]^)
      else
    else
      exit;
  end else begin
    NewSlot := CacheCount;
    inc(CacheCount);
  end;
  TimeStamp[NewSlot] := GetTickCount;
  PPointer(KeySlot[NewSlot])^ := Key;
  if FValueSize = 4 then
    PPointer(ValueSlot[NewSlot])^ := PPointer(@Value)^
  else
    move(Value,ValueSlot[NewSlot]^,FValueSize);
end;

procedure TOvcLiteCache.Clear;
var
  i : Integer;
begin
  if assigned(FRemoveNotifier) then
    for i := 0 to pred(CacheCount) do
      FRemoveNotifier(ValueSlot[i]^);
  CacheCount := 0;
end;

constructor TOvcLiteCache.Create(ValueSize, CacheSize: Integer);
begin
  GetMem(Buffer, CacheSize *
    (sizeof(Pointer) + ValueSize + sizeof(Integer))); {Key, Value, Time stamp}
  CacheCount := 0;
  FCacheSize := CacheSize;
  FValueSize := ValueSize;
end;

destructor TOvcLiteCache.Destroy;
begin
  Clear;
  FreeMem(Buffer{, FCacheSize * (sizeof(Pointer) + FValueSize + sizeof(Integer))});
    {last item is size of time stamp}
  inherited Destroy;
end;

function TOvcLiteCache.GetKeySlot(Index: Integer): Pointer;
begin
  Result := @PByte(Buffer)[Index * (sizeof(Pointer) + FValueSize + sizeof(Integer))];
end;

function TOvcLiteCache.GetTimeStamp(Index: Integer): NativeInt;
begin
  Result := NativeInt(Pointer(@
    PByte(Buffer)[Index * (sizeof(Pointer) + FValueSize + sizeof(Integer))
      + sizeof(Pointer) + FValueSize])^);
end;

function TOvcLiteCache.GetValue(Key : Pointer; var Value): Boolean;
var
  i : Integer;
begin
  for i := 0 to pred(CacheCount) do
    if (TimeStamp[i] <> 0) then
      if Key = PPointer(KeySlot[i])^ then begin
        if FValueSize = 4 then
          PPointer(@Value)^ := PPointer(ValueSlot[i])^
        else
          move(ValueSlot[i]^,Value,FValueSize);
        Result := True;
        exit;
      end;
  Result := False;
end;

function TOvcLiteCache.GetValueSlot(Index: Integer): Pointer;
begin
  Result := @PByte(Buffer)[Index * (sizeof(Pointer)
    + FValueSize + sizeof(Integer)) + sizeof(Pointer)];
end;

procedure TOvcLiteCache.RemoveValue(Key : Pointer);
var
  i : Integer;
begin
  for i := 0 to pred(CacheCount) do
    if (TimeStamp[i] <> 0) and (Key = PPointer(KeySlot[i])^) then begin
      TimeStamp[i] := 0;
      exit;
    end;
end;

procedure TOvcLiteCache.SetTimeStamp(Index: Integer; const Value: NativeInt);
begin
  NativeInt(Pointer(@
    PByte(Buffer)[Index * (sizeof(Pointer) + FValueSize + sizeof(Integer))
      + sizeof(Pointer) + FValueSize])^)
      := Value;
end;

{===== TOvcLiteStringCache ===========================================}

procedure TOvcLiteStringCache.AddValue(Key : Pointer; const Value: string);
var
  P : Pointer;
begin
  P := NewString(Value);
  FCache.AddValue(Key,P);
end;

procedure TOvcLiteStringCache.Clear;
begin
  FCache.Clear;
end;

constructor TOvcLiteStringCache.Create(CacheSize: Integer);
begin
  FCache := TOvcLiteCache.Create(sizeof(Pointer),CacheSize);
  FCache.RemoveNotifier := RemoveNotifier;
end;

destructor TOvcLiteStringCache.Destroy;
begin
  FCache.Destroy;
  inherited Destroy;
end;

function TOvcLiteStringCache.GetValue(Key : Pointer;
  var Value: string): Boolean;
var
  P : Pointer;
begin
  Result := FCache.GetValue(Key,P);
  if Result then
    Value := PString(P)^;
end;

procedure TOvcLiteStringCache.RemoveNotifier(const Value);
var
  P : Pointer absolute Value;
begin
  DisposeString(P);
end;

procedure TOvcLiteStringCache.RemoveValue(Key : Pointer);
begin
  FCache.RemoveValue(Key);
end;

{===== TOvcPoolManager ===============================================}

procedure TOvcPoolManager.Clear;
var
  Tmp : POvcPoolPage;
begin
  while FirstPage <> nil do begin
    Tmp := FirstPage^.NextPage;
    Dispose(FirstPage);
    FirstPage := Tmp;
  end;
  FirstPage := nil;
  LastPage := nil;
  DeletedList := nil;
end;

constructor TOvcPoolManager.Create(ItemSize : Integer);
begin
  if ItemSize > dlmMaxItemSize then
    raise Exception.Create('PoolManager does not support items > 4K');
  InternalSize := ItemSize;
  while InternalSize mod 4 <> 0 do
    inc(InternalSize);
  if InternalSize > dlmMaxItemSize then
    raise Exception.Create('PoolManager item size overflow');
  ItemsPerPage := dlmMaxItemSize div InternalSize;
{$IFDEF OvcDlmDebug}
  OwnerThread := GetCurrentThreadID;
{$ENDIF}
end;

destructor TOvcPoolManager.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TOvcPoolManager.NewPage;
var
  NPage : POvcPoolPage;
begin
  GetMem(NPage, dlmPageSize);
  NPage.NextPage := nil;
  if FirstPage = nil then
    FirstPage := NPage;
  if LastPage <> nil then
    LastPage^.NextPage := NPage;
  LastPage := NPage;
  LastPageTop := @NPage^.Data;
  LastPageEnd := Pointer(NativeUInt(LastPageTop) + DWord(ItemsPerPage)*DWord(InternalSize));
end;

function TOvcPoolManager.NewItem : Pointer;
begin
{$IFDEF OvcDlmDebug}
  if OwnerThread <> GetCurrentThreadID then
    raise Exception.Create('PoolManager is not re-entrant');
{$ENDIF}
  if DeletedList <> nil then begin
    Result := DeletedList;
    DeletedList := PPointer(DeletedList)^;
{$IFDEF OvcDlmDebug}
    if DeletedList <> nil then
      if IsBadReadPtr(PPointer(DeletedList)^, 4) then
        raise Exception.Create('Internal pool error');
    if IsBadWritePtr(Result,InternalSize) then
      raise Exception.Create('Internal pool error');
{$ENDIF}
  end else begin
    if (LastPage = nil) or (LastPageTop = LastPageEnd) then
      NewPage;
    Result := LastPageTop;
{$IFDEF OvcDlmDebug}
    if IsBadWritePtr(Result,InternalSize) then
      raise Exception.Create('Internal pool error');
{$ENDIF}
    LastPageTop := PAnsiChar(LastPageTop) + InternalSize;
  end;
end;

procedure TOvcPoolManager.DeleteItem(Item : Pointer);
begin
{$IFDEF OvcDlmDebug}
  if OwnerThread <> GetCurrentThreadID then
    raise Exception.Create('PoolManager is not re-entrant');
{$ENDIF}
  PPointer(Item)^ := DeletedList;
  DeletedList := Item;
  if (PPointer(DeletedList)^ <> nil) and IsBadReadPtr(PPointer(DeletedList)^, 4) then
    raise Exception.Create('Internal pool error');
end;

{===== TOvcFastList ==================================================}

destructor TOvcFastList.Destroy;
begin
  Clear;
  if Assigned(FList) then Dispose(FList);
end;

function TOvcFastList.Add(Item: Pointer): Integer;
begin
  Result := FCount;
  if Result = FCapacity then Grow;
  FList^[Result] := Item;
  Inc(FCount);
end;

procedure TOvcFastList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TOvcFastList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    BoundsError(Index);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Pointer));
end;

class procedure TOvcFastList.BoundsError(Data: Integer);
begin
  raise EListError.CreateFmt('List index out of bounds:%d', [Data]);
end;

class procedure TOvcFastList.CapacityError(Data: Integer);
begin
  raise EListError.CreateFmt('Invalid list capacity:%d', [Data]);
end;

class procedure TOvcFastList.CountError(Data: Integer);
begin
  raise EListError.CreateFmt('Invalid list count:%d', [Data]);
end;

function TOvcFastList.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    BoundsError(Index);
  Result := FList^[Index];
end;

procedure TOvcFastList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else
    if FCapacity > 8 then
      Delta := 16
    else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TOvcFastList.IndexOf(Item: Pointer): Integer;
var
  Look : PPointer;
begin
  if FCount = 0 then begin
    Result := -1;
    exit;
  end;
  Result := FCount - 1;
  Look := @FList^[Result];
  while (Result >= 0) and (Look^ <> Item) do begin
    dec(Look);
    dec(Result);
  end;
end;

procedure TOvcFastList.Put(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index >= FCount) then
    BoundsError(Index);
  FList^[Index] := Item;
end;

procedure TOvcFastList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount)then
    CapacityError(NewCapacity);
  if NewCapacity <> FCapacity then begin
    if not Assigned(FList) then
      New(FList);
    SetLength(FList^, NewCapacity);
    FCapacity := NewCapacity;
  end;
end;

procedure TOvcFastList.SetCount(NewCount: Integer);
begin
  if (NewCount < 0) then
    CountError(NewCount);
  if NewCount > FCapacity then SetCapacity(NewCount);
  if NewCount > FCount then
    FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);
  FCount := NewCount;
end;

procedure UpdateLow(Page, ChildPage : POvcPTDataPage; Key: Pointer);
{- update lowkey on parent pages}
begin
  if Page <> nil then begin
    if ChildPage = Page.Data[0] then begin
      Page.LowKey := Key;
      UpdateLow(Page.Owner, Page, Key);
    end;
  end;
end;

procedure UpdateHigh(Page, ChildPage : POvcPTDataPage; Key: Pointer);
{- update highkey on parent pages}
begin
  if Page <> nil then begin
    if ChildPage = Page.Data[Page.UseCount - 1] then begin
      Page.HighKey := Key;
      UpdateHigh(Page.Owner, Page, Key);
    end;
  end;
end;

function TOvcPageTree.InternalAdd(Key: Pointer; var TargetPage: POvcPTDataPage): Boolean;
var
  Page, Page1, Page2 : POvcPTDataPage;
  Index, I, J : Integer;
begin
  case BinarySearch(Root, Key, Page, Index) of
  srFound :
    begin
      Result := False;
      TargetPage := Page;
      exit;
    end;
  srPageFound :
    ;
  srBelowPage :
    Index := 0;
  srAbovePage :
    Index := Page.UseCount;
  end;
  if Page.UseCount >= EntriesPerPage then begin
    {page split}
    ClearPosition(Page); {search result no longer valid for this page}
    Page1 := Pool.NewItem;
    for i := 0 to pred(Page.UseCount div 2) do
      Page1.Data[i] := Page.Data[i];
    Page1.UseCount := Page.UseCount div 2;
    Page1.PageType := DATAPAGE;
    Page1.LowKey := Page1.Data[0];
    Page1.HighKey := Page1.Data[Page1.UseCount - 1];
    NotifyPageChange(Page1);
    Page2 := Pool.NewItem;
    for i := Page1.UseCount to pred(Page.UseCount) do
      Page2.Data[i - Page1.UseCount] := Page.Data[i];
    Page2.UseCount := Page.UseCount - Page1.UseCount;
    Page2.PageType := DATAPAGE;
    Page2.LowKey := Page2.Data[0];
    Page2.HighKey := Page2.Data[Page2.UseCount - 1];
    NotifyPageChange(Page2);
    if (Page.Owner <> nil) and (Page.Owner.UseCount < EntriesPerPage) then begin
      {pointers to both pages fit in owner page}
      {store new pointers in owner page and delete old data page}
      i := 0;
      while Page.Owner.Data[i] <> Page do
        inc(i);
      for j := pred(Page.Owner.UseCount) downto i do
        Page.Owner.Data[j+1] := Page.Owner.Data[j];
      Page.Owner.Data[i] := Page1;
      Page.Owner.Data[i+1] := Page2;
      inc(Page.Owner.UseCount);
      Page1.Owner := Page.Owner;
      Page2.Owner := Page.Owner;
      Pool.DeleteItem(Page);
    end else begin
      {no room in owner index page, create new by}
      {converting Page to index page}
      Page1.Owner := Page;
      Page2.Owner := Page;
      Page.Data[0] := Page1;
      Page.Data[1] := Page2;
      Page.UseCount := 2;
      Page.PageType := INDEXPAGE;
      Page.LowKey := Page1.Data[0];
      Page.HighKey := Page2.Data[Page2.UseCount - 1];
    end;
    {adjust index}
    if Index >= Page1.UseCount then begin
      dec(Index, Page1.UseCount);
      Page := Page2;
    end else
      Page := Page1;
  end;
  for I := pred(Page.UseCount) downto Index do
    Page.Data[I + 1] := Page.Data[I];
  Page.Data[Index] := Key;
  inc(Page.UseCount);
  TargetPage := Page;
  if Index = 0 then begin
    Page.LowKey := Key;
    UpdateLow(Page.Owner, Page, Key);
  end;
  if Index = Page.UseCount - 1 then begin
    Page.HighKey := Key;
    UpdateHigh(Page.Owner, Page, Key);
  end;
  Result := True;
end;

function TOvcPageTree.Add(Key: Pointer): Boolean;
var
  P : Pointer;
begin
  Result := InternalAdd(Key, POvcPTDataPage(P));
end;

function TOvcPageTree.AddEx(Key: Pointer; var DataPage: Pointer): Boolean;
begin
  Result := InternalAdd(Key, POvcPTDataPage(DataPage));
end;

procedure TOvcPageTree.DeletePage(Page : POvcPTDataPage);
var
  I, Index : Integer;
begin
  if Page.Owner <> nil then begin
    Index := -1;
    for i := 0 to pred(Page.Owner.UseCount) do
      if Page.Owner.Data[i] = Page then begin
        Index := I;
        break;
      end;
    Assert(Index <> -1);
    if Page.Owner.UseCount = 1 then
      DeletePage(Page.Owner)
    else begin
      for i := Index to Page.Owner.UseCount - 2 do
        Page.Owner.Data[i] := Page.Owner.Data[i + 1];
      dec(Page.Owner.UseCount);
    end;
    Pool.DeleteItem(Page);
  end else begin
    Page.PageType := DATAPAGE;
    Page.UseCount := 0;
  end;
  RecalcEdges;
end;

function TOvcPageTree.Delete(Key: Pointer): Boolean;
var
  Page : POvcPTDataPage;
  I, Index : Integer;
begin
  case BinarySearch(Root, Key, Page, Index) of
  srFound :
    begin
      Assert(Page.UseCount <> 0);
      ClearPosition(Page); {search result no longer valid for this page}
      for i := Index to Page.UseCount - 2 do
        Page.Data[i] := Page.Data[i + 1];
      dec(Page.UseCount);
      if Index = 0 then begin
        Page.LowKey := Page.Data[0];
        UpdateLow(Page.Owner, Page, Page.LowKey);
      end;
      if (Index >= Page.UseCount) and (Page.UseCount > 0) then begin
        Page.HighKey := Page.Data[Page.UseCount - 1];
        UpdateHigh(Page.Owner, Page, Page.HighKey);
      end;
      if Page.UseCount <= 0 then
        DeletePage(Page);
      Result := True;
    end;
  else
    Result := False;
  end;
end;

function TOvcPageTree.DeleteEx(Key: Pointer; IndexPage : Pointer;
  AllowCompare: Boolean): Boolean;
var
  Page : POvcPTDataPage absolute IndexPage;
  I, L, U, C, Index : Integer;
begin
  if Page.PageType <> DATAPAGE then begin
    Result := False;
    exit;
  end;
  Index := -1;
  if AllowCompare then begin
    {binary search}
    L := 0;
    U := Page.UseCount - 1;
    while L <= U do begin
      I := (L + U) div 2;
      Assert(assigned(OnCompare));
      C := OnCompare(Self, FUserData, Key, Page.Data[I]);
      if C = 0 then begin
        Index := I;
        break;
      end;
      if C < 0 then
        U := I - 1
      else
        L := I + 1;
    end;
  end else begin
    {sequential search}
    for i := 0 to pred(Page.UseCount) do
      if Page.Data[i] = Key then begin
        Index := I;
        break;
      end;
  end;
  if Index = -1 then begin
    Result := False;
    exit;
  end;
  ClearPosition(Page);
  for i := Index to Page.UseCount - 2 do
    Page.Data[i] := Page.Data[i + 1];
  dec(Page.UseCount);
  if Index = 0 then begin
    Page.LowKey := Page.Data[0];
    UpdateLow(Page.Owner, Page, Page.LowKey);
  end;
  if (Index >= Page.UseCount) and (Page.UseCount > 0) then begin
    Page.HighKey := Page.Data[Page.UseCount - 1];
    UpdateHigh(Page.Owner, Page, Page.HighKey);
  end;
  if Page.UseCount <= 0 then
    DeletePage(Page);
  Result := True;
end;

function TOvcPageTree.BinarySearchData(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
var
  L, U, I : Integer;
  C : Integer;
begin
  if (Root.useCount = 0) then begin
    Assert(Root.Owner = nil);
    Result := srBelowPage;
    Page := Root;
    Index := 0;
    exit;
  end;
  Assert(assigned(OnCompare));
  C := OnCompare(Self, FUserData, Key, Root.LowKey);
  if C < 0 then begin
    Result := srBelowPage;
    Page := Root;
    Index := 0;
    exit;
  end;
  if C = 0 then begin
    Result := srFound;
    Page := Root;
    Index := 0;
    exit;
  end;
  Assert(assigned(OnCompare));
  C := OnCompare(Self, FUserData, Key, Root.HighKey);
  if C > 0 then begin
    Result := srAbovePage;
    Page := Root;
    Index := Root.UseCount;
    exit;
  end;
  if C = 0 then begin
    Result := srFound;
    Page := Root;
    Index := Root.UseCount - 1;
    exit;
  end;
  L := 0;
  U := Root.UseCount - 1;
  while L <= U do begin
    I := (L + U) div 2;
    Assert(assigned(OnCompare));
    C := OnCompare(Self, FUserData, Key, Root.Data[I]);
    if C = 0 then begin
      Result := srFound;
      Page := Root;
      Index := I;
      exit;
    end;
    if C < 0 then
      U := I - 1
    else
      L := I + 1;
  end;
  Page := Root;
  Result := srPageFound;
  Index := L;
end;

function GetLowEdgePage(Page: POvcPTDataPage): POvcPTDataPage;
begin
  if Page.PageType = DATAPAGE then
    Result := Page
  else
    Result := GetLowEdgePage(POvcPTDataPage(Page.Data[0]));
end;

function GetHighEdgePage(Page: POvcPTDataPage): POvcPTDataPage;
begin
  if Page.PageType = DATAPAGE then
    Result := Page
  else
    Result := GetHighEdgePage(POvcPTDataPage(Page.Data[Page.UseCount - 1]));
end;

function TOvcPageTree.BinarySearchIndex(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
var
  L, U, I, C : Integer;
begin
  if (Root.useCount = 0) then begin
    Assert(Root.Owner = nil);
    Result := srBelowPage;
    Page := Root;
    Index := 0;
    exit;
  end;
  Assert(assigned(OnCompare));
  C := OnCompare(Self, FUserData, Key, Root.LowKey);
  if C < 0 then begin
    Result := srBelowPage;
    Page := GetLowEdgePage(Root);
    Index := 0;
    exit;
  end;
  Assert(assigned(OnCompare));
  C := OnCompare(Self, FUserData, Key, Root.HighKey);
  if C > 0 then begin
    Result := srAbovePage;
    Page := GetHighEdgePage(Root);
    Index := Page{Root}.UseCount;
    exit;
  end;
  Result := srBelowPage; {suppress compiler warning}
  L := 0;
  U := Root.UseCount - 1;
  while L <= U do begin
    I := (L + U) div 2;
    Result := BinarySearch(
      POvcPTDataPage(Root.Data[I]), Key, Page, Index);
    case Result of
    srFound :
      begin
        exit;
      end;
    srPageFound :
      begin
        exit;
      end;
    srBelowPage :
      U := I - 1;
    srAbovePage :
      L := I + 1;
    end;
  end;
end;

function TOvcPageTree.BinarySearch(Root: POvcPTDataPage; Key: Pointer;
      var Page: POvcPTDataPage; var Index: Integer): TOvcPTSearchResult;
begin
  Assert((Root.useCount <> 0) or (Root.Owner = nil));
  if Root.PageType = INDEXPAGE then
    Result := BinarySearchIndex(Root, Key, Page, Index)
  else
    Result := BinarySearchData(Root, Key, Page, Index);
end;

function TOvcPageTree.InternalGEQ(Root: POvcPTDataPage; Key: Pointer;
  var Page: POvcPTDataPage; var Index: Integer): Boolean;
begin
  if Root = nil then begin
    Result := False;
    Page := nil;
    Index := -1;
  end else
    Result := BinarySearch(Root, Key, Page, Index) = srFound;
end;

function TOvcPageTree.GEQ(Key: Pointer; var Data: Pointer): Boolean;
begin
  Result := InternalGEQ(Root, Key, iLastKeyPage, iLastKeyIndex);
  if not Result then
    iLastKeyPage := nil
  else
    Data := iLastKeyPage.Data[iLastKeyIndex];
end;

function TOvcPageTree.GGEQ(Key: Pointer; var Data: Pointer): Boolean;
begin
  Result := InternalGEQ(Root, Key, iLastKeyPage, iLastKeyIndex);
  if not Result then
    if iLastkeyPage <> nil then begin
      Result := True;
      if iLastKeyIndex < iLastKeyPage.UseCount then
        Data := iLastKeyPage.Data[iLastKeyIndex]
      else
        Result := GNX(Data);
    end else
      Result := False
  else
    Data := iLastKeyPage.Data[iLastKeyIndex];
end;

function TOvcPageTree.GLEQ(Key: Pointer; var Data: Pointer): Boolean;
begin
  Result := InternalGEQ(Root, Key, iLastKeyPage, iLastKeyIndex);
  if not Result then
    if iLastkeyPage <> nil then
      Result := GPR(Data)
    else
      Result := False
  else
    Data := iLastKeyPage.Data[iLastKeyIndex];
end;

function NextLexPage(ParentPage, ChildPage: POvcPTDataPage): POvcPTDataPage;
var
  i, Index: Integer;
begin
  if ParentPage = nil then
    Result := nil
  else begin
    Index := -1;
    for i := 0 to pred(ParentPage.UseCount) do
      if ParentPage.Data[i] = ChildPage then begin
        Index := I;
        break;
      end;
    Assert(Index <> -1);
    if Index < ParentPage.UseCount - 1 then begin
      Result := POvcPTDataPage(ParentPage.Data[Index + 1]);
      if Result.PageType = INDEXPAGE then
        Result := GetLowEdgePage(Result);
    end else
      Result := NextLexPage(ParentPage.Owner, ParentPage);
  end;
end;

function TOvcPageTree.GNX(var Data: Pointer): Boolean;
begin
  {should not be called unless we have a current position}
  Assert(iLastKeyPage <> nil);
  if iLastKeyPage = nil then
    Result := False
  else
    if iLastKeyIndex < iLastKeyPage.UseCount - 1 then begin
      inc(iLastKeyIndex);
      Data := iLastKeyPage.Data[iLastKeyIndex];
      Result := True;
    end else begin
      iLastKeyPage := NextLexPage(iLastKeyPage.Owner, iLastKeyPage);
      if (iLastKeyPage = nil) or (iLastKeyPage.UseCount = 0) then
        Result := False
      else
        begin
          Data := iLastKeyPage.Data[0];
          iLastKeyIndex := 0;
          Result := True;
        end;
    end;
end;

function PrevLexPage(ParentPage, ChildPage: POvcPTDataPage): POvcPTDataPage;
var
  i, Index: Integer;
begin
  if ParentPage = nil then
    Result := nil
  else begin
    Index := -1;
    for i := 0 to pred(ParentPage.UseCount) do
      if ParentPage.Data[i] = ChildPage then begin
        Index := I;
        break;
      end;
    Assert(Index <> -1);
    if Index > 0 then begin
      Result := POvcPTDataPage(ParentPage.Data[Index - 1]);
      if Result.PageType = INDEXPAGE then
        Result := GetHighEdgePage(Result);
    end else
      Result := PrevLexPage(ParentPage.Owner, ParentPage);
  end;
end;

function TOvcPageTree.GPR(var Data: Pointer): Boolean;
begin
  {should not be called unless we have a current position}
  Assert(iLastKeyPage <> nil);
  if iLastKeyPage = nil then
    Result := False
  else
    if iLastKeyIndex > 0 then begin
      dec(iLastKeyIndex);
      Data := iLastKeyPage.Data[iLastKeyIndex];
      Result := True;
    end else begin
      iLastKeyPage := PrevLexPage(iLastKeyPage.Owner, iLastKeyPage);
      if (iLastKeyPage = nil) or (iLastKeyPage.UseCount = 0) then
        Result := False
      else
        begin
          iLastKeyIndex := iLastKeyPage.UseCount - 1;
          Data := iLastKeyPage.Data[iLastKeyIndex];
          Result := True;
        end;
    end;
end;

function TOvcPageTree.GFirst(var Data: Pointer): Boolean;
begin
  Result := False;
  iLastKeyPage := GetLowEdgePage(Root);
  if iLastKeyPage <> nil then
    if iLastKeyPage.UseCount > 0 then begin
      iLastKeyIndex := 0;
      Data := iLastKeyPage.Data[0];
      Result := True;
    end else
      iLastKeyPage := nil;
end;

function TOvcPageTree.GLast(var Data: Pointer): Boolean;
begin
  Result := False;
  iLastKeyPage := GetHighEdgePage(Root);
  if iLastKeyPage <> nil then
    if iLastKeyPage.UseCount > 0 then begin
      iLastKeyIndex := iLastKeyPage.UseCount - 1;
      Data := iLastKeyPage.Data[iLastKeyIndex];
      Result := True;
    end else
      iLastKeyPage := nil;
end;

procedure TOvcPageTree.Init;
begin
  Pool := TOvcPoolManager.Create(sizeof(TOvcPTDataPage));
  Root := Pool.NewItem;
  Root.Owner := nil;
  Root.UseCount := 0;
  Root.PageType := DATAPAGE;
end;

constructor TOvcPageTree.Create;
begin
  FUserData := UserData;
  Init;
end;

procedure TOvcPageTree.Clear;
begin
  Pool.Free;
  Init;
end;

procedure TOvcPageTree.ClearPosition(Page: POvcPTDataPage);
var
  i: Integer;
begin
  if iLastKeyPage = Page then
    iLastKeyPage := nil;
  if PageStack <> nil then
    for i := 0 to PageStack.Count - 1 do
      if PageStack[i] = Page then begin
        PageStack[i] := nil;
        IndexStack[i] := Pointer(-1);
      end;
end;

function TOvcPageTree.PopPosition: Boolean;
begin
  if (PageStack = nil)
  or (IndexStack = nil)
  or (PageStack.Count = 0)
  or (IndexStack.Count = 0) then
    Result := False
  else begin
    iLastKeyPage := PageStack[PageStack.Count - 1];
    PageStack.Delete(PageStack.Count - 1);
    iLastKeyIndex := Integer(IndexStack[IndexStack.Count - 1]);
    IndexStack.Delete(IndexStack.Count - 1);
    Result := iLastKeyIndex <> -1;
  end;
end;

procedure TOvcPageTree.PushPosition;
begin
  if PageStack = nil then
    PageStack := TList.Create;
  PageStack.Add(iLastKeyPage);
  if IndexStack = nil then
    IndexStack := TList.Create;
  IndexStack.Add(Pointer(iLastKeyIndex));
end;

destructor TOvcPageTree.Destroy;
begin
  Pool.Free;
  PageStack.Free;
  IndexStack.Free;
  inherited;
end;

procedure TOvcPageTree.NotifyPageChange(Page: POvcPTDataPage);
begin
  Assert(Assigned(OnPageChange));
  OnPageChange(Self, FUserData, Page.UseCount, @Page.Data, Page);
end;

procedure TOvcPageTree.RecalcEdges;

  procedure RecalcEdge(Root: POvcPTDataPage);
  var
    i: Integer;
    EP: POvcPTDataPage;
  begin
    if Root.PageType = DATAPAGE then begin
      if Root.UseCount > 0 then begin
        Root.LowKey := Root.Data[0];
        Root.HighKey := Root.Data[Root.UseCount - 1];
      end;
    end else begin
      if Root.useCount > 0 then begin
        Root.LowKey := GetLowEdgePage(Root).Data[0];
        EP := GetHighEdgePage(Root);
        Root.HighKey := EP.Data[EP.UseCount - 1];
        for i := 0 to Root.UseCount - 1 do
          RecalcEdge(Root.Data[i]);
      end;
    end;
  end;

begin
  RecalcEdge(Root);
end;

end.


{*********************************************************}
{*                    OVCCACHE.PAS 4.06                  *}
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
{$G+} {286 Instructions}
{$I+} {Input/Output-Checking}
{$N+} {Numeric Coprocessor}
{$P+} {Open Parameters}
{$Q-} {Overflow Checking}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit OvcCache;
  {general cache object}


  (*******************************************************************

   TOvcCache is a simple data cache component that can be used is
   situations where "normal" data retrieval methods would be too slow,
   i.e., displaying records in a virtual ListBox or in a table
   component. TOvcCache does not implement "write chaching", you must
   provide a mechanism to write data once it has been modified and to
   inform the cache so that it can refresh that record.

   To use a TOvcCache component in your application, you can either
   create an instance of it dynamically (demonstrated in the CUSTORD
   demo program) or by dropping it on a form (after registering the
   component with Delphi so that it is available from the component
   palette). In either case, you _MUST_ assign a method to the
   OnGetItem event. The method assigned to OnGetItem is called
   whenever the cache needs to fill or update its internal copy of a
   cache element.

   Once this is setup, your application will always obtain data
   through the cache. It, in turn, will call the method assigned to
   the OnGetItem only when it has to. Use the Items indexed property
   to obtain a pointer to a cache item, e.g., MyCache.Items[3] would
   return a pointer to the fourth item (because the array is zero-
   based) in the cache.

   The number of data items held in the cache is determined by the
   MaxCacheItems property and must be at least 2 and no more than
   MaxLongInt. The number of items you want the cache to maintain
   depends on where that data is coming from, whether the data is
   in a file that is shared by others, and most importantly, through
   experimentation.


   TOvcCache provide the following events, methods, and properties:
   ===================================================================

   property CacheHits : Integer

     CacheHits determines the number of times a requested item was in
     the cache and did not require loading (by calling OnGetItem).

   property CacheMisses : Integer

     CacheMisses determines the number of times a requested item was
     not in the cache and required loading (by calling OnGetItem).

   procedure Clear;

     Removes all items currently in the cache and clears the locked
     cache item flag (see LockCacheItem).

   property Count : Integer

     Count is a read-only property that returns the number of items
     currently managed by the cache.

   property Items[Index : Integer] : Pointer (read-only)

     This index property is used to obtain a pointer to the data
     managed by the cache object. The returned pointer usually
     references a data record that has been allocated on the heap but,
     it can also be a pointer to a class instance.

   procedure LockCacheItem(Index : Integer);

     Locks the specified cache item so that it will not be purged
     when the cache performs its search for an item to remove when
     it needs to make room for a new item. Calling LockCacheItem
     clears any previously locked item.

   property LockedItem : Integer

     LockedItem is a read-only property that returns the index of the
     currently locked cache item. If no cache item is locked,
     LockedItem returns -1.

   property MemoryUsage : Integer (read-only)

     MemoryUsage is a read-only property that returns the amount of
     memory currently in use by the cache object and all of the cache
     elements.

   property OnDoneItem : TOnDoneItemEvent
   TOnDoneItemEvent = procedure(Index : Integer; P : Pointer;
                                Size : Word) of object;

     If a method is assigned to this event, it is called when the
     cache needs to remove one of its items. (P) is a pointer to the
     cache item and Size is the size of the item that was set when
     the item was added to the cache through a call to the method
     assigned to the OnGetItem event. If you do not assign a method
     to this event, the cache will attempt to deallocate Size bytes
     of memory for (P).

   property OnGetItem : TOnGetItemEvent
   TOnGetItemEvent = procedure(Index : Integer; var P : Pointer;
                               var Size : Word) of object;

     The method assigned to this event is called when the cache
     receives a request for an item and that item is not in the
     cache. You must assign a method to this event, otherwise the
     cache has no way to obtain the requested data.

     Index is a number from 0 to MaxLongInt and can represent record
     numbers corresponding to records in a data file or just about
     anything you want them to. The cache assumes that you will
     request items using the same index number that was used when the
     item was added to the cache.

     (P) is a pointer to the global memory containing the data you
     wish to add to the cache. You must allocate this memory on the
     global heap rather than on the stack or as an address of a local
     variable. If you specify the size of the memory allocation in
     Size, the cache will deallocate the memory for this item when it
     is no longer needed (if OnDoneItem is not assigned).

     (P) could also point to a class instance if you had an
     application that required an object cache. If this is the case,
     you must assign a method to the OnDoneItem event so that you can
     destroy the objects contained within the cache. If you fail to do
     this, the cache will attempt to dispose of Size bytes of memory
     for P and will not properly destroy the object.

   procedure PreLoad(Index, Number : Integer);

     PreLoad loads the specified Number of items starting with the
     index specified by Index. Clear is called to remove any
     existing cache items before the new items are added.

   procedure Refresh;

     Refresh re-loads all items currently in the cache. Calling
     Refresh also clears the item locked by a previous call to
     LockCacheItem.

   procedure UnlockCacheItem;

     Unlocks a cache item previously locked using LockCacheItem.

   procedure Update(Index : Integer);

     Freshens the data for the specified Index cache item.

   property DiscardMethod : TDiscardMethod
   TDiscardMethod = (dmMostDistant, dmLeastUsed);

     DiscardMethod determines which method is used to determine the
     cache item to remove to make room for a new cache item.

     dmMostDistant is the default and involves a simple comparison of
     the cache index numbers to determine which one is the most
     distant from the index of the item currently being added. This
     method is useful when the cache indexes represent sequential
     record numbers.

     dmLeastUsed performs a search through all cache items, looking
     for the item that has been retrieved the least number of times.

   property MaxCacheItems : Integer

     MaxCacheItems determines the maximum number of items maintained
     by the cache. The "right" value for this property is best
     determined through experimentation.


   ******************************************************************)

interface

uses
  Classes;

type
  TDiscardMethod = (dmMostDistant, dmLeastUsed);

const
  DefDiscardMethod = dmMostDistant;
  DefMaxCacheItems = 10;
  DefMinCacheItems = 2;  {2 or greater}

type
  {record for one cache item}
  PCacheRecord = ^TCacheRecord;
  TCacheRecord = packed record
    Index  : Integer; {index number}
    Data   : Pointer; {pointer to data}
    Hits   : Integer; {number of times used}
    Size   : Word;    {size of data}
  end;

type
  TOnGetItemEvent =
    procedure(Index : Integer; var P : Pointer; var Size : Word)
    of object;
  TOnDoneItemEvent =
    procedure(Index : Integer; P : Pointer; Size : Word)
    of object;

  TOvcCache = class(TComponent)

  protected {private}
    {instance variables}
    FCacheHits     : Integer;   {number of times requested item was in cache}
    FCacheMisses   : Integer;   {number of times requested item was not in cache}
    FDiscardMethod : TDiscardMethod; {method used to free cache items}
    FList          : TList;     {list of cached items}
    FMaxCacheItems : Integer;   {maximum items allowed in cache}
    FLockedItem    : Integer;   {item to be kept in the cache}

    {event instance variables}
    FOnGetItem     : TOnGetItemEvent;  {must be assigned}
    FOnDoneItem    : TOnDoneItemEvent; {optional}

    {event wrapper methods}
    procedure DoOnGetItem(Index : Integer; var P : Pointer; var Size : Word);
      {-call FOnGetItem if assigned, otherwise return nil}
    procedure DoOnDoneItem(Index : Integer; var P : Pointer; Size : Word);
      {-call FOnDoneItem if assigned, otherwise deallocate cache item}

    {property methods}
    function GetCount : Integer;
      {-return the number of items in the cache}
    function GetItem(Index : Integer) : Pointer;
      {-return pointer to data for Index}
    function GetMemoryUsage : Integer;
      {-return the amount of memory used for items in the cache}
    procedure SetMaxCacheItems(Value : Integer);
      {-set the maximum number of items to cache}

    {internal methods}
    procedure ResetHits;
      {-reset hit count for all cached items}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    {public methods}
    procedure Clear;
      {-remove all items from cache}
    procedure LockCacheItem(Index : Integer);
      {-lock the Index item so it remains in the cache}
    procedure PreLoad(Index, Number : Integer);
      {-load Number items starting at Index}
    procedure Refresh;
      {-reload all items currently in cache}
    procedure UnlockCacheItem;
      {-unlock the previously locked item}
    procedure Update(Index : Integer);
      {-reload data for the Index item}

    {public properties}
    property CacheHits : Integer
      read FCacheHits write FCacheHits;
    property CacheMisses : Integer
      read FCacheMisses write FCacheMisses;
    property Count : Integer
      read GetCount;
    property Items[Index : Integer] : Pointer
      read GetItem;
    property LockedItem : Integer
      read FLockedItem;
    property MemoryUsage : Integer
      read GetMemoryUsage;

  published
    {published properties}
    property DiscardMethod : TDiscardMethod
      read FDiscardMethod write FDiscardMethod;
    property MaxCacheItems : Integer
      read FMaxCacheItems write SetMaxCacheItems;

    {published events}
    property OnDoneItem : TOnDoneItemEvent
      read FOnDoneItem write FOnDoneItem;
    property OnGetItem : TOnGetItemEvent
      read FOnGetItem write FOnGetItem;
  end;


procedure Register;
  {-IDE Component registration}


implementation

{*** TOvcCache ***}

procedure TOvcCache.Clear;
  {-remove all items from cache}
var
  I : Integer;
  P : PCacheRecord;
begin
  UnlockCacheItem; {clear locked item}
  for I := 0 to FList.Count-1 do begin
    P := PCacheRecord(FList.Items[I]);
    DoOnDoneItem(P^.Index, P^.Data, P^.Size);
    FreeMem(P, SizeOf(TCacheRecord));
  end;
  FList.Clear;
end;

constructor TOvcCache.Create(AOwner : TComponent);
  {-create cache with MaxItems maximum items}
begin
  inherited Create(AOwner);
  MaxCacheItems := DefMaxCacheItems;
  FList := TList.Create;

  FDiscardMethod := DefDiscardMethod;
  FLockedItem := -1; {no locked item}
end;

destructor TOvcCache.Destroy;
  {-destroy cache object}
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TOvcCache.DoOnGetItem(Index : Integer; var P : Pointer; var Size : Word);
  {-call FOnGetItem if assigned, otherwise return nil}
begin
  P := nil;
  Size := 0;
  if Assigned(FOnGetItem) then
    FOnGetItem(Index, P, Size);
end;

procedure TOvcCache.DoOnDoneItem(Index : Integer; var P : Pointer; Size : Word);
  {-call FOnDoneItem if assigned, otherwise deallocate cache item}
begin
  if Assigned(FOnDoneItem) then
    FOnDoneItem(Index, P, Size)
  else begin
    FreeMem(P, Size);
    P := nil;
  end;
end;

function TOvcCache.GetCount : Integer;
  {-return the number of items in the cache}
begin
  Result := FList.Count;
end;

function TOvcCache.GetItem(Index : Integer) : Pointer;
  {-return pointer to data for the Index cache item}
var
  I   : Integer;
  P   : PCacheRecord;
  DP  : Pointer;
  SZ  : Word;
  Idx : Integer;

  function FindMostDistant : Integer;
  var
    I        : Integer;
    Distance : Integer;
    P        : PCacheRecord;
  begin
    Distance := 0;
    Result := -1;
    for I := 0 to FList.Count-1 do begin
      P := PCacheRecord(FList.Items[I]);
      if (Abs(P^.Index - Index) > Distance) and
         (P^.Index <> LockedItem) then begin
        Distance := Abs(P^.Index - Index);
        Result := I;
      end;
    end;
  end;

  function FindLeastUsed : Integer;
  var
    I    : Integer;
    Hits : Integer;
    P    : PCacheRecord;
  begin
    Hits := MaxLongInt;
    Result := -1;
    for I := 0 to FList.Count-1 do begin
      P := PCacheRecord(FList.Items[I]);
      if (P^.Hits < Hits) and (P^.Index <> LockedItem) then begin
        Hits := P^.Hits;
        Result := I;
      end;
    end;
  end;

begin
  Result := nil;

  {search for Index item in the cache}
  for I := 0 to FList.Count-1 do begin
    P := PCacheRecord(FList.Items[I]);
    if Assigned(P) and (P^.Index = Index) then begin
      {return pointer to cache data}
      Result := P^.Data;
      Inc(FCacheHits);
      Inc(P^.Hits);
      if P^.Hits < 0 then  {roll-over, clear all}
        ResetHits;
      Break;
    end;
  end;

  {see if we failed to find a match}
  if not Assigned(Result) then begin
    Inc(FCacheMisses);

    {ask for data for this cache item}
    DoOnGetItem(Index, DP, SZ);
    {exit if no data associated with this item}
    if not Assigned(DP) then Exit;

    {if cache is full, discard one item in the list}
    if FList.Count >= MaxCacheItems then begin

      if DiscardMethod = dmMostDistant then
        Idx := FindMostDistant
      else
        Idx := FindLeastUsed;

      P := nil;
      if Idx > -1 then begin
        P := PCacheRecord(FList.Items[Idx]);
        if Assigned(P) then begin
          with P^ do
            DoOnDoneItem(Index, Data, Size);

          {replace with new data}
          P^.Index := Index;
          P^.Data := DP;
          P^.Size := SZ;
          P^.Hits := 0;
        end;
      end;
    end else begin
      {otherwise, allocate a cache record (P)}
      GetMem(P, SizeOf(TCacheRecord));

      {insert new cache record at top of list}
      P^.Index := Index;
      P^.Data := DP;
      P^.Size := SZ;
      P^.Hits := 0;
      FList.Insert(0, P);
    end;

    {return pointer to data in cache}
    if Assigned(P) then
      Result := P^.Data;
  end;
end;

function TOvcCache.GetMemoryUsage : Integer;
  {-return the amount of memory used for items in the cache}
var
  I : Integer;
begin
  Result := SizeOf(TCacheRecord) * (FList.Count-1);
  for I := 0 to FList.Count-1 do
    Result := Result + PCacheRecord(FList.Items[I])^.Size;
end;

procedure TOvcCache.LockCacheItem(Index : Integer);
  {-lock the Index item so it remaines in the cache}
begin
  FLockedItem := Index;
end;

procedure TOvcCache.PreLoad(Index, Number : Integer);
  {-load Number items starting at Index}
var
  I : Integer;
  P : PCacheRecord;
begin
  {remove any existing cache items}
  Clear;
  {fill cache with Number items starting at Index}
  for I := Index to Index+Number-1 do begin
    {allocate a cache record (P)}
    GetMem(P, SizeOf(TCacheRecord));
    {ask for data for this item}
    DoOnGetItem(I, P^.Data, P^.Size);
    {exit if no data associated with this index}
    if Assigned(P) then begin
      P^.Index := I;
      P^.Hits := 0;
      {add to cache list}
      FList.Add(P);
    end;
  end;
end;

procedure TOvcCache.Refresh;
  {-reload all items currently in cache}
var
  I : Integer;
  P : PCacheRecord;
begin
  UnlockCacheItem; {clear locked item}
  for I := 0 to FList.Count-1 do begin
    P := PCacheRecord(FList.Items[I]);
    with P^ do begin
      DoOnDoneItem(Index, Data, Size);
      DoOnGetItem(Index, Data, Size);
      Hits := 0;
    end;
  end;
end;

procedure TOvcCache.ResetHits;
  {-reset hit count for all cached items}
var
  I : Integer;
begin
  for I := 0 to FList.Count-1 do
    PCacheRecord(FList.Items[I])^.Hits := 0;
end;

procedure TOvcCache.SetMaxCacheItems(Value : Integer);
  {-set the maximum number of items to cache}
begin
  FMaxCacheItems := Value;
  if FMaxCacheItems < DefMinCacheItems then
    FMaxCacheItems := DefMinCacheItems;
end;

procedure TOvcCache.UnlockCacheItem;
  {-unlock the previously locked item}
begin
  FLockedItem := -1;
end;

procedure TOvcCache.Update(Index : Integer);
  {-reload data for Index}
var
  I : Integer;
  P : PCacheRecord;
begin
  for I := 0 to FList.Count-1 do begin
    P := PCacheRecord(FList.Items[I]);
    if P^.Index = Index then begin
      with P^ do begin
        DoOnDoneItem(Index, Data, Size);
        DoOnGetItem(Index, Data, Size);
        Hits := 0;
        Break;
      end;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Orpheus Non-Visual', [TOvcCache]);
end;


end.

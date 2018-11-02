{*********************************************************}
{*                  OVCSPARY.PAS 4.06                    *}
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

unit ovcspary;
  {-Orpheus - sparse array implementation}

interface

uses
  Windows,
  SysUtils, OvcExcpt, OvcConst, OvcData;

const
  MaxSparseArrayItems = 320000;  {maximum items in a sparse array}

type
  TSparseArrayFunc = function (Index : Integer; Item : pointer;
                               ExtraData : pointer) : boolean;
    {-Sparse array's iterator type. Should return true to continue iterating,
      false otherwise.}

  {The sparse array class}
  TOvcSparseArray = class
    protected {private}
      FCount : Integer;       {Fake count of the items}
      FArray : pointer;       {Sparse array}

      ChunkCount : word;      {Number of chunks}
      ChunkArraySize : word;  {Size of FArray}

      procedure RecalcCount;

    protected
      function GetActiveCount : Integer;
      function GetItem(Index : Integer) : pointer;
      procedure PutItem(Index : Integer; Item : pointer);

    public
      constructor Create;
      destructor Destroy; override;

      function  Add(Item : pointer) : Integer;
        {-Add Item to end of array}
      procedure Clear;
        {-Clear array}
      procedure Delete(Index : Integer);
        {-Delete item at Index, all items below move up one}
      procedure Exchange(Index1, Index2 : Integer);
        {-Swap the items at Index1 and Index2}
      function  First : pointer;
        {-Return First item}
      function  ForAll(Action : TSparseArrayFunc;
                       Backwards : boolean;
                       ExtraData : pointer) : Integer;
        {-Iterate through all active items, maybe backwards}
      function  IndexOf(Item : pointer) : Integer;
        {-Get the index of Item}
      procedure Insert(Index : Integer; Item : pointer);
        {-Insert Item at Index, it and all items below move down one}
      function  Last : pointer;
        {-Return Last item}
      procedure Squeeze;
        {-Pack the sparse array}

      property Count : Integer
        {-Logical count of the number of items (=IndexOf(Last)+1)}
         read FCount;
      property ActiveCount : Integer
        {-Count of non-nil items}
         read GetActiveCount;
      property Items[Index : Integer] : pointer
        {-Items array}
         read GetItem write PutItem;
         default;
  end;


implementation


{Notes: the sparse array is implemented as an array of chunks, each
        chunk contains 32 items (2^5). The array of chunks consists
        of a set of elements, each with chunk index and a pointer to
        the chunk. To find the item for a given index you do two
        things: calculate the chunk index (divide by 32) and the
        index into the chunk (the remainder once divided by 32).
        For example: where is item 100? 100 = 3*32 + 4, so you try
        and find chunk index 3 in the chunk array (the array is sorted
        by chunk index, hence you do a binary search), and if found
        return the 5th element (zero based arrays). If not found then
        the item does not exist.
        Thus setting item 10000 in a sparse array will allocate only
        one chunk, the 9999 previous items are all assumed nil.
        The sparse array can only accomodate pointers. An unused item
        will be nil. A nil pointer will indicate an unused item. Hence
        you cannot really use a sparse array for longints say, unless
        you can guarantee that all your values will be non-nil.

        Sizing stuff: maximum number of pointers that can be stored is
        just less than 350,000. For various reasons the maximum index
        that is allowed for the sparse array is 319,999 meaning that a
        sparse array could hold up to 320,000 pointers. To increase this
        you could hold 64 or 128 pointers per chunk instead.
        The minimum heap the sparse array will take is 896 bytes.

        Sparse arrays cannot really be used for keeping sorted items:
        obviously all the items will appear at the start of the array,
        there can be no holes.
}

const
  ShiftValue = 5;
  ChunkElements = 1 shl ShiftValue; {Number of elements in a chunk: 32}
  ChunkMask = pred(ChunkElements);  {Mask used for the item in a chunk: $1F}

type
  PChunk = ^TChunk;                 {Definition of a chunk}
  TChunk = array [0..pred(ChunkElements)] of pointer;

  TChunkArrayElement = packed record  {Definition of a chunk array element}
    ChunkIndex : word;                {..index of the chunk}
    Chunk : PChunk;                   {..the chunk itself}
  end;

const
  DefChunkArrayElements = 4;        {Initial size of the chunk array}
  MaxChunkArrayElements = ($10000 div sizeof(TChunkArrayElement)) - 1;
                                    {Absolute maximum of chunk array elements}

type
  PChunkArray = ^TChunkArray;       {Definition of a chunk array}
  TChunkArray = array [0..pred(MaxChunkArrayElements)] of TChunkArrayElement;

{===Helper routines==================================================}
procedure RaiseException(ClassType : integer);
  begin
    case ClassType of
      1 : raise ESAEAtMaxSize.Create(GetOrphStr(SCSAEAtMaxSize));
      2 : raise ESAEOutOfBounds.Create(GetOrphStr(SCSAEOutOfBounds));
    else
      raise ESparseArrayError.Create(GetOrphStr(SCSAEGeneral));
    end;{case}
  end;
{--------}
function GrowChunkArray(A : PChunkArray; var CurSize : word) : PChunkArray;
  {-Grow the chunk array, return the new size and the new pointer}
  var
    NewSize : Integer;
    NewSizeAdj : word;
  begin
    NewSize := Integer(CurSize) +
               (DefChunkArrayElements * sizeof(TChunkArrayElement));
    NewSizeAdj := MaxChunkArrayElements * sizeof(TChunkArrayElement);
    if (NewSize < NewSizeAdj) then
      NewSizeAdj := NewSize;
    GetMem(Result, NewSizeAdj);
    {$IFOPT D+}
    FillChar(Result^, NewSizeAdj, $CC);
    {$ENDIF}
    if (CurSize <> 0) then
      begin
        Move(A^, Result^, CurSize);
        FreeMem(A, CurSize);
      end;
    CurSize := NewSizeAdj;
  end;
{--------}
function GetChunk(A : PChunkArray;
                  CI : word; NumChunks : word) : integer;
  {-Find a chunk array element given the chunk index CI and the number of
    chunks. Return the index into the chunk array, or -1 if not found.}
  var
    L, R : integer;
    MsInx : word;
  begin
    L := 0;
    R := pred(NumChunks);
    repeat
      Result := (L + R) div 2;
      MsInx := A^[Result].ChunkIndex;
      if (CI = MsInx) then
        Exit
      else if (CI < MsInx) then
        R := pred(Result)
      else
        L := succ(Result);
    until (L > R);
    Result := -1;
  end;
{--------}
function EnsureChunk(var A : PChunkArray; CI : word;
                     var NumChunks, Size : word;
                     DontCreate : boolean) : integer;
  {-Makes sure that chunk CI is available for use. If it does not yet
    exist and DontCreate is false, creates a new chunk, inserts it into
    the chunk array (possibly growing the array). Return the index of
    the chunk in the array.}
  var
    NumElements : word;
    L, R, M : integer;
    MsInx : word;
  begin
    L := 0;
    if (NumChunks > 0) then
      begin
        R := pred(NumChunks);
        repeat
          M := (L + R) div 2;
          MsInx := A^[M].ChunkIndex;
          if (CI = MsInx) then
            begin
              Result := M;
              Exit;
            end
          else if (CI < MsInx) then
            R := pred(M)
          else
            L := succ(M);
        until (L > R);
      end;

    if DontCreate then
      begin
        Result := -1;
        Exit;
      end;

    Result := L;

    NumElements := Size div sizeof(TChunkArrayElement);
    if (NumChunks = NumElements) then
      A := GrowChunkArray(A, Size);

    if (Result < NumChunks) then
      Move(A^[Result], A^[succ(Result)],
           (NumChunks - Result) * sizeof(TChunkArrayElement));

    with A^[Result] do
      begin
        ChunkIndex := CI;
        Chunk := New(PChunk);
        FillChar(Chunk^, sizeof(TChunk), 0);
      end;

    inc(NumChunks);
  end;
{--------}
function ChunkIsBlank(A : PChunkArray; ArrayInx : word) : boolean;
  {-Return true if the chunk has no items (all pointers are nil).}
  var
    Chunk: PChunk;
    i: Integer;
  begin
    Chunk := A^[ArrayInx].Chunk;
    i := pred(ChunkElements);
    while (i>=0) and (Chunk^[i]=nil) do Dec(i);
    result := i<0;
  end;
{--------}
procedure DeleteChunk(A : PChunkArray; ArrayInx : word; var NumChunks : word);
  {-Delete a chunk, moving chunks below up one.}
  begin
    Dispose(A^[ArrayInx].Chunk);
    if ArrayInx < pred(NumChunks) then
      Move(A^[succ(ArrayInx)], A^[ArrayInx],
           (NumChunks - ArrayInx) * sizeof(TChunkArrayElement));
    dec(NumChunks);
    {$IFOPT D+}
    FillChar(A^[NumChunks], sizeof(TChunkArrayElement), $CC);
    {$ENDIF}
  end;

{===TOvcSparseArray ForAll routines=====================================}
function CountActiveElements(Index : Integer;
                             Item : pointer;
                             ExtraData : pointer) : boolean; far;
  var
    ED : ^Integer absolute ExtraData;
  begin
    Result := True;
    inc(ED^);
  end;
{=====}

function Find1stOrLastElement(Index : Integer;
                              Item : pointer;
                              ExtraData : pointer) : boolean; far;
  var
    ED : ^pointer absolute ExtraData;
  begin
    Find1stOrLastElement := false;
    ED^ := Item;
  end;
{=====}

function FindSpecificElement(Index : Integer;
                             Item : pointer;
                             ExtraData : pointer) : boolean; far;
  begin
    {continue looking if this Item is NOT the one we want}
    FindSpecificElement := Item <> ExtraData;
  end;
{=====}

constructor TOvcSparseArray.Create;
  begin
    FArray := GrowChunkArray(FArray, ChunkArraySize);
  end;
{=====}

destructor TOvcSparseArray.Destroy;
  begin
    if Assigned(FArray) then
      begin
        Clear;
        FreeMem(FArray, ChunkArraySize);
      end;
  end;
{=====}

procedure TOvcSparseArray.RecalcCount;
  var
    Dummy : pointer;
  begin
    FCount := succ(ForAll(Find1stOrLastElement, true, @Dummy));
  end;
{--------}
procedure TOvcSparseArray.Squeeze;
  var
    ArrayInx : word;
  begin
    ArrayInx := 0;
    while ArrayInx <> ChunkCount do
      if ChunkIsBlank(FArray, ArrayInx) then
        DeleteChunk(FArray, ArrayInx, ChunkCount)
      else
        inc(ArrayInx);
  end;
{=======================================================================}


{===TOvcSparseArray property access=====================================}
function TOvcSparseArray.GetActiveCount : Integer;
  begin
    Result := 0;
    ForAll(CountActiveElements, true, @Result);
  end;
{--------}
function TOvcSparseArray.GetItem(Index : Integer) : pointer;
  var
    ChunkIndex : word;
    ChunkNum   : integer;
  begin
    if (Index < 0) or (Index >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;

    Result := nil;
    if (ChunkCount > 0) then
      begin
        ChunkIndex := Index shr ShiftValue;
        ChunkNum := GetChunk(FArray, ChunkIndex, ChunkCount);
        if (ChunkNum <> -1) then
          Result := PChunkArray(FArray)^[ChunkNum].Chunk^[Index and ChunkMask];
      end;
  end;
{--------}
procedure TOvcSparseArray.PutItem(Index : Integer; Item : pointer);
  var
    ChunkIndex : word;
    ChunkNum   : integer;
  begin
    if (Index < 0) or (Index >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;

    ChunkIndex := Index shr ShiftValue;
    ChunkNum := EnsureChunk(PChunkArray(FArray),
                            ChunkIndex, ChunkCount, ChunkArraySize,
                            (Item = nil));

    if (ChunkNum <> -1) then
      begin
        PChunkArray(FArray)^[ChunkNum].Chunk^[Index and ChunkMask] := Item;
        if (Item = nil) then
          Squeeze;
        RecalcCount;
      end;
  end;
{====================================================================}


{===TOvcSparseArray item maintenance====================================}
function TOvcSparseArray.Add(Item : pointer) : Integer;
  begin
    if (FCount = MaxSparseArrayItems) then
      RaiseException(1);

    Result := FCount;
    PutItem(Result, Item);
  end;
{--------}
procedure TOvcSparseArray.Clear;
  var
    i : integer;
  begin
    if (ChunkCount > 0) then
      begin
        for i := 0 to pred(ChunkCount) do
          Dispose(PChunkArray(FArray)^[i].Chunk);
        {$IFOPT D+}
        FillChar(FArray^, ChunkArraySize, $CC);
        {$ENDIF}
      end;
    ChunkCount := 0;
    FCount := 0;
  end;
{--------}
procedure TOvcSparseArray.Delete(Index : Integer);
  const
    LastPos = pred(ChunkElements);
  var
    MajorInx : word;
    ChunkNum, Dummy : integer;
    StartPos : word;
    OurChunk  : PChunk;
    Transferred : boolean;
  begin
    if (Index < 0) or (Index >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;

    if (Index >= FCount) then
      Exit;

    MajorInx := Index shr ShiftValue;
    ChunkNum := EnsureChunk(PChunkArray(FArray),
                            MajorInx, ChunkCount, ChunkArraySize,
                            false);

    StartPos := Index and ChunkMask;
    OurChunk := PChunkArray(FArray)^[ChunkNum].Chunk;
    if (StartPos <> LastPos) then
      Move(OurChunk^[succ(StartPos)], OurChunk^[StartPos],
           (LastPos-StartPos)*sizeof(Pointer));

    inc(ChunkNum);
    while (ChunkNum <> ChunkCount) do
      begin
        with PChunkArray(FArray)^[ChunkNum] do
          begin
            if (ChunkIndex = MajorInx+1) then
              begin
                Transferred := true;
                OurChunk^[LastPos] := Chunk^[0];
              end
            else
              begin
                Transferred := false;
                OurChunk^[LastPos] := nil;
              end;
            MajorInx := ChunkIndex;
            OurChunk := Chunk;
          end;
        if (OurChunk^[0] <> nil) and (not Transferred) then
          begin
            Dummy := EnsureChunk(PChunkArray(FArray),
                                 MajorInx-1, ChunkCount, ChunkArraySize,
                                 true);
            PChunkArray(FArray)^[Dummy].Chunk^[LastPos] :=
               OurChunk^[0];
          end;
        Move(OurChunk^[1], OurChunk^[0], LastPos*sizeof(Pointer));
        inc(ChunkNum);
      end;

    OurChunk^[LastPos] := nil;
    Squeeze;
    RecalcCount;
  end;
{--------}
procedure TOvcSparseArray.Exchange(Index1, Index2 : Integer);
  var
    Item1, Item2 : pointer;
  begin
    if (Index1 = Index2) then
      Exit;

    if (Index1 < 0) or (Index1 >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;
    if (Index2 < 0) or (Index2 >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;

    Item1 := GetItem(Index1);
    Item2 := GetItem(Index2);
    PutItem(Index2, Item1);
    PutItem(Index1, Item2);
  end;
{--------}
function TOvcSparseArray.First : pointer;
  begin
    Result := nil;
    ForAll(Find1stOrLastElement, false, @Result);
  end;
{--------}
function TOvcSparseArray.ForAll(Action : TSparseArrayFunc;
                                Backwards : boolean;
                                ExtraData : pointer) : Integer;
  var
    MajorInx : word;
    MinorInx : word;
    MajorStub : Integer;
  label
    ExitLoopsReverse, ExitLoopsForwards;
  begin
    if (ChunkCount = 0) then
      Result := -1
    else if Backwards then
      begin
        for MajorInx := pred(ChunkCount) downto 0 do
          with PChunkArray(FArray)^[MajorInx] do
            begin
              MajorStub := Integer(ChunkIndex) shl ShiftValue;
              for MinorInx := pred(ChunkElements) downto 0 do
                if (Chunk^[MinorInx] <> nil) then
                  begin
                    Result := MajorStub + MinorInx;
                    if not Action(Result,
                                  Chunk^[MinorInx],
                                  ExtraData) then
                      Goto ExitLoopsReverse;
                  end;
            end;
        Result := -1;
      ExitLoopsReverse:
      end
    else
      begin
        for MajorInx := 0 to pred(ChunkCount) do
          with PChunkArray(FArray)^[MajorInx] do
            begin
              MajorStub := Integer(ChunkIndex) shl ShiftValue;
              for MinorInx := 0 to pred(ChunkElements) do
                if (Chunk^[MinorInx] <> nil) then
                  begin
                    Result := MajorStub + MinorInx;
                    if not Action(Result,
                                  Chunk^[MinorInx],
                                  ExtraData) then
                      Goto ExitLoopsForwards;
                end;
            end;
        Result := -1;
      ExitLoopsForwards:
      end;
  end;
{--------}
function TOvcSparseArray.IndexOf(Item : pointer) : Integer;
  begin
    Result := ForAll(FindSpecificElement, true, Item);
  end;
{--------}
procedure TOvcSparseArray.Insert(Index : Integer; Item : pointer);
  const
    LastPos = pred(ChunkElements);
  var
    MajorInx : word;
    ChunkNum : integer;
    CarryItem, NewCarryItem : pointer;
    StartPos : word;
  begin
    if (Index < 0) or (Index >= MaxSparseArrayItems) then
      begin
        RaiseException(2);
      end;

    if (FCount = MaxSparseArrayItems) then
      RaiseException(1);

    if (Index >= FCount) then
      begin
        PutItem(Index, Item);
        Exit;
      end;

    MajorInx := Index shr ShiftValue;
    ChunkNum := EnsureChunk(PChunkArray(FArray),
                            MajorInx, ChunkCount, ChunkArraySize,
                            false);

    CarryItem := Item;
    StartPos := Index and ChunkMask;
    repeat
      with PChunkArray(FArray)^[ChunkNum] do
        begin
          MajorInx := ChunkIndex;
          NewCarryItem := Chunk^[LastPos];
          if (StartPos <> LastPos) then
            Move(Chunk^[StartPos], Chunk^[succ(StartPos)],
                 (LastPos-StartPos)*sizeof(Pointer));
          Chunk^[StartPos] := CarryItem;
          CarryItem := NewCarryItem;
          StartPos := 0;
        end;
      inc(ChunkNum);
      if (CarryItem <> nil) then
        if (ChunkNum = ChunkCount) or
           (PChunkArray(FArray)^[ChunkNum].ChunkIndex <> MajorInx+1) then
          ChunkNum := EnsureChunk(PChunkArray(FArray),
                                  MajorInx+1, ChunkCount, ChunkArraySize,
                                  false);
    until (ChunkNum = ChunkCount);
    inc(FCount);
  end;
{--------}
function TOvcSparseArray.Last : pointer;
  begin
    Result := nil;
    ForAll(Find1stOrLastElement, true, @Result);
  end;
{====================================================================}

end.

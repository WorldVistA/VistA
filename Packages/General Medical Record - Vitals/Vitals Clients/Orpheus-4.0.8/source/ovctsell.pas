{*********************************************************}
{*                  OVCTSELL.PAS 4.06                    *}
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

unit ovctsell;
  {-Table cell selection list class}

{Notes:

  The TOvcSelectionList class implements a data structure that stores which
  cells in a table are selected. The structure is implemented as an array
  of (sub)arrays, each element of the outer array pertaining to a single
  column. The items in each subarray are ranges of rows that are selected.
  Thus if the cells (in (row,col) format) (1,1)..(2,3) are all selected,
  the structure will look like this:
             Column   Value
             0        nil
             1        array with 1 element: range row 1 to row 2
             2        array with 1 element: range row 1 to row 2
             3        array with 1 element: range row 1 to row 2
             4        nil
             ...
  Adding a new selected cell at (4,2) would add an element to the third
  column's subarray: a range from row 4 to row 4.

  To check whether a cell is selected or not, get the element of the array
  pertaining to the column. If nil, the cell is not selected. If not,
  search through the ranges sequentially until the cell's row falls into a
  range.

  Adding a selected cell (or cells) will generally add a new row range
  element to the relevant column array, but it might cause row range
  mergings. Deselecting a cell (or cells) might cause range splittings and
  mergings.

  To aid in dynamic selection of cells, the class remembers the 'current
  range'. The table using this class will set the anchor cell address and
  then periodically set the new active cell; the difference between these
  is the current range. The class will move the current range to the above
  data structure when the anchor cell is set. IsCellSelected and
  HaveSelection will both look at this current range as well as the data
  structure. Note that the current range could be for selecting as well as
  deselecting cells: there's a flag to define which.

  One important assumption has been made. This is that generally there are
  'few' selections (obviously one can imagine the fanatical user who is
  determined to see 1000 separate disjoint selections, but normally there
  will be one selection to maybe half a dozen). In other words it will be
  more efficient to code a sequential search internally rather than a
  binary one, and other similar types of speed improvements have not been
  used.
}

interface

uses
  Windows, SysUtils, OvcTCmmn, OvcMisc;

type
  TOvcSelRowRange = packed record            {a row range}
    L, H : TRowNum;
  end;

  POvcSelRRArray = ^TOvcSelRRArray;   {an array of row ranges}
  TOvcSelRRArray = packed record
    RRCount : integer;
    RRTotal : integer;
    RRs     : array [0..(MaxInt div sizeof(TOvcSelRowRange))-2] of TOvcSelRowRange;
  end;

  POvcSelColArray = ^TOvcSelColArray; {an array of arrays of row ranges}
  TOvcSelColArray = array [0..(MaxInt div sizeof(POvcSelRRArray))-1] of POvcSelRRArray;

  TOvcSelectionList = class           {class to manage list of selected cells}
    protected {private}

      {even sized}
      slArray : POvcSelColArray;      {array of arrays of row ranges}
      slColCount : TColNum;           {number of columns in slArray}
      slColWithSelCount : TColNum;    {num of columns with at least 1 selected cell}
      slActiveCol : TColNum;          {current active cell-column}
      slActiveRow : TColNum;          {                   -row}
      slAnchorCol : TColNum;          {current anchor-column}
      slAnchorRow : TColNum;          {              -row}
      slRowCount : TRowNum;           {number of rows in slArray}
      slColMin : TColNum;             {current range-minimum column}
      slColMax : TColNum;             {             -maximum column}
      slRowMin : TRowNum;             {             -minimum row}
      slRowMax : TRowNum;             {             -maximum row}
      {odd sized}
      slSelecting : boolean;          {current range is for selection}
      slEmptyRange : boolean;         {current range is empty}

    protected

      procedure slDeselectCellRangeInCol(Row1, Row2 : TRowNum; ColNum : TColNum);
      procedure slSelectCellRangeInCol(Row1, Row2 : TRowNum; ColNum : TColNum);

    public
      constructor Create(RowCount : TRowNum; ColCount : TColNum);
        {-Create a new instance for RowCount rows & ColCount columns}
      destructor Destroy; override;
        {-Destroy the instance}

      procedure DeselectAll;
        {-Deselect all cells}
      procedure DeselectCell(RowNum : TRowNum; ColNum : TColNum);
        {-Deselect a single cell}
      procedure DeselectCellRange(FromRow : TRowNum; FromCol : TColNum;
                                  ToRow : TRowNum; ToCol : TColNum);
        {-Deselect a range of cells}
      procedure ExtendRange(RowNum : TRowNum; ColNum : TColNum;
                            IsSelecting : boolean);
        {-Extend/shrink the current range to RowNum, ColNum}
      function HaveSelection : boolean;
        {-Return true if at least one cell is selected}
      function IsCellSelected(RowNum : TRowNum; ColNum : TColNum) : boolean;
        {-Return true if specified cell is selected}
      procedure Iterate(SI : TSelectionIterator; ExtraData : pointer);
        {-Iterate through all the selection ranges calling SI for each}
      procedure SelectAll;
        {-Select all cells}
      procedure SelectCell(RowNum : TRowNum; ColNum : TColNum);
        {-Mark a single cell as selected}
      procedure SelectCellRange(FromRow : TRowNum; FromCol : TColNum;
                                ToRow : TRowNum; ToCol : TColNum);
        {-Mark a range of cells as selected}
      procedure SetColCount(ColCount : TColNum);
        {-Change the number of columns}
      procedure SetRangeAnchor(RowNum : TRowNum; ColNum : TColNum;
                               Action : TOvcTblSelectionType);
        {-Set the anchor cell; if Action is tstAdditional the current
          selection is stored, if not all DeselectAll is called}
      procedure SetRowCount(RowCount : TRowNum);
        {-Change the number of rows}
  end;

implementation

const
  RRArrayInc = 16;
  RRElemSize = sizeof(TOvcSelRowRange);

{===Helper routines==================================================}
function CalcRRArraySize(ElementCount : integer) : integer;
  {-Given a number of elements, calcs the memory block size}
  begin
    Result := (ElementCount * RRElemSize) + (2 * sizeof(integer));
  end;
{--------}
procedure AllocRRArray(var RRA : POvcSelRRArray);
  {-Allocates/grows a row range array}
  var
    NewTotal : integer;
    NewArray: POvcSelRRArray;
  begin
    {are we growing a current allocation?}
    if Assigned(RRA) then
      begin
        NewTotal := RRA^.RRTotal + RRArrayInc;
        NewArray := AllocMem(CalcRRArraySize(NewTotal));
        NewArray^.RRTotal := NewTotal;
        NewArray^.RRCount := RRA^.RRCount;
        Move(RRA^.RRs, NewArray^.RRs, RRA^.RRCount * RRElemSize);
        FreeMem(RRA, CalcRRArraySize(RRA^.RRTotal));
        RRA := NewArray;
      end
    {otherwise this is a new allocation}
    else
      begin
        RRA := AllocMem(CalcRRArraySize(RRArrayInc));
        RRA^.RRTotal := RRArrayInc;
      end;
  end;
{--------}
procedure FreeRRArray(var RRA : POvcSelRRArray);
  {-Frees a row range array}
  begin
    {Note: assumes RRA is not nil}
    FreeMem(RRA {, CalcRRArraySize(RRA^.RRTotal)});
    RRA := nil;
  end;
{--------}
procedure ReallocColArray(var CA : POvcSelColArray; OldCC, NewCC : TColNum);
  {-Reallocates (ie allocs or frees or grows) a column array}
  var
    NewArray : POvcSelColArray;
    i        : integer;
  begin
    {if there's no change, forget it}
    if (NewCC = OldCC) then
      Exit;
    {if the new array size is greater then just copy over the
     old array's contents after clearing the new array}
    if (NewCC > OldCC) then
      begin
        NewArray := AllocMem(NewCC * sizeof(pointer));
        if (OldCC > 0) then
          Move(CA^, NewArray^, OldCC * sizeof(pointer));
      end
    {if the new array size is smaller then we have to dispose of
     the subarrays that will no longer be used, then copy over
     the remaining elements (if any).}
    else
      begin
        for i := NewCC to pred(OldCC) do
          if Assigned(CA^[i]) then
            FreeRRArray(CA^[i]);
        if (NewCC = 0) then
          NewArray := nil
        else
          begin
            GetMem(NewArray, NewCC * sizeof(pointer));
            Move(CA^, NewArray^, NewCC * sizeof(pointer));
          end;
      end;
    {dispose of the old array, return the new one}
    if (OldCC > 0) then
      FreeMem(CA {, OldCC * sizeof(pointer)});
    CA := NewArray;
  end;
{====================================================================}


{===TOvcSelectionList================================================}
constructor TOvcSelectionList.Create(RowCount : TRowNum; ColCount : TColNum);
  begin
    {inherited Create;}
    SetRowCount(RowCount);
    SetColCount(ColCount);
  end;
{--------}
destructor TOvcSelectionList.Destroy;
  begin
    SetColCount(0);
    {inherited Destroy;}
  end;
{--------}
procedure TOvcSelectionList.DeselectAll;
  var
    ColNum : TColNum;
  begin
    if (slColWithSelCount > 0) then
      begin
        for ColNum := 0 to pred(slColCount) do
          if Assigned(slArray^[ColNum]) then
            FreeRRArray(slArray^[ColNum]);
        slColWithSelCount := 0;
      end;
    slEmptyRange := true;
  end;
{--------}
procedure TOvcSelectionList.DeselectCell(RowNum : TRowNum; ColNum : TColNum);
  begin
    {sanity checks}
    if (RowNum < 0) or (RowNum >= slRowCount) or
       (ColNum < 0) or (ColNum >= slColCount) then
      Exit;
    {do it}
    slDeselectCellRangeInCol(RowNum, RowNum, ColNum);
  end;
{--------}
procedure TOvcSelectionList.DeselectCellRange(FromRow : TRowNum; FromCol : TColNum;
                                              ToRow : TRowNum; ToCol : TColNum);
  var
    ColNum : TColNum;
    SwapTemp : Integer;
  begin
    {save the caller from himself: sort the rows/cols into ascending order}
    if FromRow > ToRow then
      begin
        SwapTemp := FromRow;
        FromRow := ToRow;
        ToRow := SwapTemp;
      end;
    if FromCol > ToCol then
      begin
        SwapTemp := FromCol;
        FromCol := ToCol;
        ToCol := SwapTemp;
      end;
    {sanity checks}
    if (FromRow < 0) or (FromRow >= slRowCount) or
       (ToRow < 0) or (ToRow >= slRowCount) or
       (FromCol < 0) or (FromCol >= slColCount) or
       (ToCol < 0) or (ToCol >= slColCount) then
      Exit;
    {for each column, deselect cells in that column}
    for ColNum := FromCol to ToCol do
      slDeselectCellRangeInCol(FromRow, ToRow, ColNum);
  end;
{--------}
{$IFDEF SuppressWarnings}
{$WARNINGS OFF}
{$ENDIF}
procedure TOvcSelectionList.slDeselectCellRangeInCol(Row1, Row2 : TRowNum;
                                                     ColNum : TColNum);
  var
    Inx : integer;
    i   : integer;
    RRA : POvcSelRRArray;
    MustDelete : boolean;
    StillGoing : boolean;
  begin
    Inx := 0;
    {take care of the simple special case first: there are no
     selections in the column at all}
    if (not Assigned(slArray^[ColNum])) then
      Exit;
    {make sure the array has at least one spare element: we could
     be splitting a range}
    RRA := slArray^[ColNum];
    if (RRA^.RRCount = RRA^.RRTotal) then
      begin
        AllocRRArray(RRA);
        slArray^[ColNum] := RRA;
      end;
    {with this array}
    with RRA^ do
      begin
        {search for the place to delete from}
        MustDelete := false;
        for i := 0 to pred(RRCount) do
          if (Row1 < RRs[i].L) then
            begin
              MustDelete := true;
              Inx := i;
              Break;{out of for loop}
            end
          else if (Row1 <= RRs[i].H) then
            begin
              MustDelete := true;
              Inx := succ(i);
              Break;{out of for loop}
            end;

        {if the range to deselect appears after all other
         ranges, just exit, nothing to do}
        if not MustDelete then
          Exit;
        {walk through the array starting at pred(Inx)
         and split/remove as we go}
        if (Inx > 0) then
          dec(Inx);
        StillGoing := true;
        while StillGoing and (Inx < RRCount) do
          if (RRs[Inx].L < Row1) then
            if (RRs[Inx].H < Row1) then
              inc(Inx)
            else {H >= Row1} if (RRs[Inx].H > Row2) then
              begin
                {split, the deselect range is entirely within this range}
                Move(RRs[Inx], RRs[succ(Inx)], (RRCount-Inx)*RRElemSize);
                inc(RRCount);
                RRs[Inx].H := pred(Row1);
                RRs[succ(Inx)].L := succ(Row2);
                StillGoing := false;
              end
            else {H >= Row1 and <= Row2}
              begin
                RRs[Inx].H := pred(Row1);
                inc(Inx);
              end
          else {L >= Row1} if (RRs[Inx].L <= Row2) then
            if (RRs[Inx].H > Row2) then
              begin
                RRs[Inx].L := succ(Row2);
                StillGoing := false;
              end
            else {H <= Row2}
              begin
                {delete the range completely}
                dec(RRCount);
                Move(RRs[succ(Inx)], RRs[Inx], (RRCount-Inx)*RRElemSize);
              end
          else {L >= Row1 and > Row2}
            StillGoing := false;
      end;
    {check to see whether we've managed to deselect every cell, if so
     free the row range array}
    if (RRA^.RRCount = 0) then
      begin
        FreeRRArray(slArray^[ColNum]);
        dec(slColWithSelCount);
      end;
  end;
{$IFDEF SuppressWarnings}
{$WARNINGS ON}
{$ENDIF}
{--------}
procedure TOvcSelectionList.ExtendRange(RowNum : TRowNum; ColNum : TColNum;
                                        IsSelecting : boolean);
  begin
    if (RowNum < 0) or (RowNum >= slRowCount) or
       (ColNum < 0) or (ColNum >= slColCount) then
      Exit;
    slSelecting := IsSelecting;
    slActiveRow := RowNum;
    slActiveCol := ColNum;
    slEmptyRange := (slAnchorRow = RowNum) and (slAnchorCol = ColNum);
    if not slEmptyRange then
      begin
        slColMin := MinL(slAnchorCol, ColNum);
        slColMax := MaxL(slAnchorCol, ColNum);
        slRowMin := MinL(slAnchorRow, RowNum);
        slRowMax := MaxL(slAnchorRow, RowNum);
      end;
  end;
{--------}
function TOvcSelectionList.HaveSelection : boolean;
  begin
    Result := (not slEmptyRange) or (slColWithSelCount <> 0);
  end;
{--------}
function TOvcSelectionList.IsCellSelected(RowNum : TRowNum; ColNum : TColNum) : boolean;
  var
    i : integer;
  begin
    {assume false, the cell is not selected}
    Result := false;
    {sanity checks}
    if (RowNum < 0) or (RowNum >= slRowCount) or
       (ColNum < 0) or (ColNum >= slColCount) then
      Exit;
    {check in current range}
    if (not slEmptyRange) then
      if (slColMin <= ColNum) and (ColNum <= slColMax) and
         (slRowMin <= RowNum) and (RowNum <= slRowMax) then
        begin
          Result := slSelecting;
          Exit;
        end;
    {if the column array exists, search through it; note we use a
     sequential search: it'll be faster than a binary search for a
     'few' elements, and generally there will be 'few' elements}
    if Assigned(slArray^[ColNum]) then with slArray^[ColNum]^ do
      for i := 0 to pred(RRCount) do
        if (RRs[i].L <= RowNum) and (RowNum <= RRs[i].H) then
          begin
            Result := true;
            Exit;
          end;
  end;
{--------}
procedure TOvcSelectionList.Iterate(SI : TSelectionIterator; ExtraData : pointer);
  var
    ColNum   : TColNum;
    RangeNum : integer;
  begin
    {fix the current range}
    if not slEmptyRange then
      begin
        if slSelecting then
          SelectCellRange(slRowMin, slColMin, slRowMax, slColMax)
        else
          DeselectCellRange(slRowMin, slColMin, slRowMax, slColMax);
        slEmptyRange := true;
      end;
    {iterate through the ranges}
    for ColNum := 0 to pred(slColCount) do
      if Assigned(slArray^[ColNum]) then
        with slArray^[ColNum]^ do
          for RangeNum := 0 to pred(RRCount) do
            if not SI(RRs[RangeNum].L, ColNum, RRs[RangeNum].H, ColNum, ExtraData) then
              Exit;
  end;
{--------}
procedure TOvcSelectionList.SelectAll;
  var
    ColNum : TColNum;
  begin
    for ColNum := 0 to pred(slColCount) do
      begin
        if not Assigned(slArray^[ColNum]) then
          AllocRRArray(slArray^[ColNum]);
        with slArray^[ColNum]^ do
          begin
            RRCount := 1;
            RRs[0].L := 0;
            RRs[0].H := pred(slRowCount);
          end;
      end;
    slColWithSelCount := slColCount;
  end;
{--------}
procedure TOvcSelectionList.SelectCell(RowNum : TRowNum; ColNum : TColNum);
  begin
    {sanity checks}
    if (RowNum < 0) or (RowNum >= slRowCount) or
       (ColNum < 0) or (ColNum >= slColCount) then
      Exit;
    {do it}
    slSelectCellRangeInCol(RowNum, RowNum, ColNum);
  end;
{--------}
procedure TOvcSelectionList.SelectCellRange(FromRow : TRowNum; FromCol : TColNum;
                                            ToRow : TRowNum; ToCol : TColNum);
  var
    ColNum : TColNum;
    SwapTemp : Integer;
  begin
    {save the caller from himself: sort the rows/cols into ascending order}
    if FromRow > ToRow then
      begin
        SwapTemp := FromRow;
        FromRow := ToRow;
        ToRow := SwapTemp;
      end;
    if FromCol > ToCol then
      begin
        SwapTemp := FromCol;
        FromCol := ToCol;
        ToCol := SwapTemp;
      end;
    {sanity checks}
    if (FromRow < 0) or (FromRow >= slRowCount) or
       (ToRow < 0) or (ToRow >= slRowCount) or
       (FromCol < 0) or (FromCol >= slColCount) or
       (ToCol < 0) or (ToCol >= slColCount) then
      Exit;
    {for each column, select cells in that column}
    for ColNum := FromCol to ToCol do
      slSelectCellRangeInCol(FromRow, ToRow, ColNum);
  end;
{--------}
{$IFDEF SuppressWarnings}
{$WARNINGS OFF}
{$ENDIF}
procedure TOvcSelectionList.slSelectCellRangeInCol(Row1, Row2 : TRowNum;
                                                   ColNum : TColNum);
  var
    i       : integer;
    Inx     : integer;
    NextInx : integer;
    RRA     : POvcSelRRArray;
    MustInsert   : boolean;
    StillGoing   : boolean;
    AlreadyMerged: boolean;
  begin
    Inx := 0;
    {take care of the simple special case first: there are no
     selections in the column as yet}
    if (not Assigned(slArray^[ColNum])) then
      begin
        AllocRRArray(slArray^[ColNum]);
        inc(slColWithSelCount);
        with slArray^[ColNum]^ do
          begin
            RRCount := 1;
            RRs[0].L := Row1;
            RRs[0].H := Row2;
          end;
        Exit;
      end;
    {make sure the array has at least one spare element}
    RRA := slArray^[ColNum];
    if (RRA^.RRCount = RRA^.RRTotal) then
      begin
        AllocRRArray(RRA);
        slArray^[ColNum] := RRA;
      end;
    {with this array}
    with RRA^ do
      begin
        {search for the place to insert/merge}
        MustInsert := false;
        for i := 0 to pred(RRCount) do
          if (Row1 < RRs[i].L) then
            begin
              MustInsert := true;
              Inx := i;
              Break;{out of for loop}
            end;
        {if the new range appears after all the other ranges, add it
         to the end of the list; check to be able to merge it first}
        if not MustInsert then
          begin
            if (Row1 <= succ(RRs[pred(RRCount)].H)) then
              RRs[pred(RRCount)].H := MaxL(Row2, RRs[pred(RRCount)].H)
            else
              begin
                RRs[RRCount].L := Row1;
                RRs[RRCount].H := Row2;
                inc(RRCount);
              end;
            Exit;
          end;
        {otherwise we must insert; first insert the new range}
        Move(RRs[Inx], RRs[succ(Inx)], (RRCount-Inx) * RRElemSize);
        RRs[Inx].L := Row1;
        RRs[Inx].H := Row2;
        inc(RRCount);
        {now walk through the array starting at pred(Inx) and merge
         ranges as we move forward}
        if (Inx > 0) then
          dec(Inx);
        NextInx := succ(Inx);
        AlreadyMerged := false;
        StillGoing := true;
        while StillGoing and (NextInx < RRCount) do
          begin
            if (succ(RRs[Inx].H) >= RRs[NextInx].L) then
              begin
                RRs[Inx].H := MaxL(RRs[Inx].H, RRs[NextInx].H);
                inc(NextInx);
                AlreadyMerged := true;
              end
            else if AlreadyMerged then
              StillGoing := false
            else
              begin
                inc(Inx);
                inc(NextInx);
                AlreadyMerged := true;
              end;
          end;
        {by this point we know we must get rid of the elements
         in between Inx and NextInx -- they've been merged into
         other ranges}
        if ((NextInx - Inx) > 1) then
          begin
            if (NextInx < RRCount) then
              Move(RRs[NextInx], RRs[succ(Inx)], (RRCount-NextInx)*RRElemSize);
            dec(RRCount, NextInx - Inx - 1);
          end;
      end;
  end;
{$IFDEF SuppressWarnings}
{$WARNINGS ON}
{$ENDIF}
{--------}
procedure TOvcSelectionList.SetRangeAnchor(RowNum : TRowNum; ColNum : TColNum;
                                           Action : TOvcTblSelectionType);
  begin
    {sanity checks}
    if (RowNum < 0) or (RowNum >= slRowCount) or
       (ColNum < 0) or (ColNum >= slColCount) then
      Exit;
    {what's happening? deselecting all, or adding a new range}
    if (Action = tstDeselectAll) then
      DeselectAll
    else {an additional range is being set up}
      if not slEmptyRange then
        if slSelecting then
          SelectCellRange(slRowMin, slColMin, slRowMax, slColMax)
        else
          DeselectCellRange(slRowMin, slColMin, slRowMax, slColMax);
    slAnchorRow := RowNum;
    slAnchorCol := ColNum;
    slActiveRow := RowNum;
    slActiveCol := ColNum;
    slEmptyRange := true;
  end;
{--------}
procedure TOvcSelectionList.SetColCount(ColCount : TColNum);
  begin
    if (ColCount >= 0) then
      begin
        ReallocColArray(slArray, slColCount, ColCount);
        slColCount := ColCount;
      end;
  end;
{--------}
procedure TOvcSelectionList.SetRowCount(RowCount : TRowNum);
  begin
    if (RowCount >= 0) then
      slRowCount := RowCount;
  end;
{====================================================================}

end.

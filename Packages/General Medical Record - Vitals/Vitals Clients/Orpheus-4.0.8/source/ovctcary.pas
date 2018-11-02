{*********************************************************}
{*                  OVCTCARY.PAS 4.06                    *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcary;
  {-Orpheus Table - Cell Array class}

interface

{Note: this class exists for the *sole* purpose of providing a sorted
       list of cell addresses that need repainting. It has no other
       possible application. It also stores a flag that states that
       the unused bit of the table window needs painting}

uses
  SysUtils, Classes, OvcTCmmn;

type
  TOvcCellAddress = packed record
    Row : TRowNum;
    Col : TColNum;
  end;

  TOvcCellArray = class
    protected {private}

      FArray : pointer;
      FLimit : Integer;
      FCount : Integer;

      DoUnusedBit : boolean;


    protected

      function GetEmpty : boolean;


    public
      destructor Destroy; override;

      procedure AddCell(RowNum : TRowNum; ColNum : TColNum);
      procedure AddUnusedBit;
      procedure Clear;
      function DeleteCell(RowNum : TRowNum; ColNum : TColNum) : boolean;
      procedure GetCellAddr(Inx : Integer; var CellAddr : TOvcCellAddress);
      procedure Merge(CA : TOvcCellArray);
      function MustDoUnusedBit : boolean;

      property Count : Integer
         read FCount;

      property Empty : boolean
         read GetEmpty;
    end;

implementation


type
  POvcCellArrayPrim = ^TOvcCellArrayPrim;
  TOvcCellArrayPrim = array [0..9999] of TOvcCellAddress;


{===TOvcCellArray====================================================}
destructor TOvcCellArray.Destroy;
  begin
    if Assigned(FArray) then
      FreeMem(FArray {, sizeof(TOvcCellAddress) * FLimit});
  end;
{--------}
procedure TOvcCellArray.AddCell(RowNum : TRowNum; ColNum : TColNum);
  var
    NewLimit : Integer;
    L, R, M  : Integer;
    NewArray : pointer;
    MCell    : TOvcCellAddress;
  begin
    {grow array if required}
    if (FCount = FLimit) then
      begin
        NewLimit := FLimit + 128;
        GetMem(NewArray, sizeof(TOvcCellAddress) * NewLimit);
        if Assigned(FArray) then
          begin
            Move(FArray^, NewArray^, sizeof(TOvcCellAddress) * FLimit);
            FreeMem(FArray {, sizeof(TOvcCellAddress) * FLimit});
          end;
        FLimit := NewLimit;
        FArray := NewArray;
      end;
    {do special case, er, specially}
    if (FCount = 0) then
      begin
        with POvcCellArrayPrim(FArray)^[0] do
          begin
            Row := RowNum;
            Col := ColNum;
          end;
        FCount := 1;
        Exit;
      end;
    {binary search through array, insert in order}
    L := 0;
    R := pred(FCount);
    repeat
      M := (L + R) div 2;
      MCell := POvcCellArrayPrim(FArray)^[M];
      if (RowNum = MCell.Row) then
        if (ColNum = MCell.Col) then
          Exit {nothing to do-already present}
        else if (ColNum < MCell.Col) then
          R := M - 1
        else
          L := M + 1
      else if (RowNum < MCell.Row) then
        R := M - 1
      else
        L := M + 1;
    until (L > R);
    {insert at L}
    if (L < FCount) then
      Move(POvcCellArrayPrim(FArray)^[L],
           POvcCellArrayPrim(FArray)^[L+1],
           sizeof(TOvcCellAddress)*(FCount-L));
    with POvcCellArrayPrim(FArray)^[L] do
      begin
        Row := RowNum;
        Col := ColNum;
      end;
    inc(FCount);
  end;
{--------}
procedure TOvcCellArray.AddUnusedBit;
  begin
    DoUnusedBit := true;
  end;
{--------}
procedure TOvcCellArray.Clear;
  begin
    FCount := 0;
    DoUnusedBit := false;
  end;
{--------}
function TOvcCellArray.DeleteCell(RowNum : TRowNum; ColNum : TColNum) : boolean;
  var
    L, R, M  : Integer;
    MCell    : TOvcCellAddress;
  begin
    Result := false;
    {do special case, er, specially}
    if (FCount = 0) then
      Exit;
    {binary search through array}
    L := 0;
    R := pred(FCount);
    repeat
      M := (L + R) div 2;
      MCell := POvcCellArrayPrim(FArray)^[M];
      if (RowNum = MCell.Row) then
        if (ColNum = MCell.Col) then
          begin
            {got it}
            dec(FCount);
            if (FCount > M) then
              Move(POvcCellArrayPrim(FArray)^[M+1],
                   POvcCellArrayPrim(FArray)^[M],
                   sizeof(TOvcCellAddress)*(FCount-M));
            Result := true;
            Exit;
          end
        else if (ColNum < MCell.Col) then
          R := M - 1
        else
          L := M + 1
      else if (RowNum < MCell.Row) then
        R := M - 1
      else
        L := M + 1;
    until (L > R);
  end;
{--------}
procedure TOvcCellArray.GetCellAddr(Inx : Integer; var CellAddr : TOvcCellAddress);
  begin
    if (0 <= Inx) and (Inx < FCount) then
      CellAddr := POvcCellArrayPrim(FArray)^[Inx]
    else
      FillChar(CellAddr, sizeof(CellAddr), 0);
  end;
{--------}
function TOvcCellArray.GetEmpty : boolean;
  begin
    Result := (Count = 0) and (not DoUnusedBit);
  end;
{--------}
procedure TOvcCellArray.Merge(CA : TOvcCellArray);
  var
    NewA     : POvcCellArrayPrim;
    InxMerge : integer;
    InxSelf  : integer;
    InxCA    : integer;
    CellSelf : TOvcCellAddress;
    CellCA   : TOvcCellAddress;
    NewLimit : integer;
    MergeNum : integer;
    i        : integer;
  begin
    {if both cell arrays are empty, there's nothing to do}
    if (Count = 0) and (CA.Count = 0) then
      Exit;
    {make a new array at least as large as both arrays put together}
    NewLimit := ((Count + CA.Count) + 127) and $7FFFFF80;
    GetMem(NewA, sizeof(TOvcCellAddress) * NewLimit);
    {prepare for the loop}
    InxMerge := 0;
    InxSelf := 0;
    InxCA := 0;
    if (Count > 0) then
      CellSelf := POvcCellArrayPrim(FArray)^[0];
    if (CA.Count > 0) then
      CellCA := POvcCellArrayPrim(CA.FArray)^[0];
    {loop until one (or both) of the arrays is exhausted}
    while (InxSelf < Count) and (InxCA < CA.Count) do
      begin
        if (CellSelf.Row < CellCA.Row) then
          MergeNum := 1
        else if (CellSelf.Row > CellCA.Row) then
          MergeNum := 2
        else {CellSelf.Row = CellCA.Row}
          if (CellSelf.Col < CellCA.Col) then
            MergeNum := 1
          else if (CellSelf.Col > CellCA.Col) then
            MergeNum := 2
          else {both rows & cols equal}
            MergeNum := 0;
        case MergeNum of
          0 : begin {equal}
                NewA^[InxMerge] := CellSelf;
                inc(InxMerge);
                inc(InxSelf);
                if (InxSelf < Count) then
                  CellSelf := POvcCellArrayPrim(FArray)^[InxSelf];
                inc(InxCA);
                if (InxCA < CA.Count) then
                  CellCA := POvcCellArrayPrim(CA.FArray)^[InxCA];
              end;
          1 : begin
                NewA^[InxMerge] := CellSelf;
                inc(InxMerge);
                inc(InxSelf);
                if (InxSelf < Count) then
                  CellSelf := POvcCellArrayPrim(FArray)^[InxSelf];
              end;
          2 : begin
                NewA^[InxMerge] := CellCA;
                inc(InxMerge);
                inc(InxCA);
                if (InxCA < CA.Count) then
                  CellCA := POvcCellArrayPrim(CA.FArray)^[InxCA];
              end;
        end;{case}
      end;
    {after this loop one (or both) of the input merge streams has been
     exhausted; copy the remaining elements from the other}
    if (InxSelf = Count) then {self array exhausted}
      for i := InxCA to pred(CA.Count) do
        begin
          NewA^[InxMerge] := POvcCellArrayPrim(CA.FArray)^[i];
          inc(InxMerge);
        end
    else if (InxCA = CA.Count) then {CA array exhausted}
      for i := InxSelf to pred(Count) do
        begin
          NewA^[InxMerge] := POvcCellArrayPrim(FArray)^[i];
          inc(InxMerge);
        end;
    {all merged, replace the current array with the merged array}
    FreeMem(FArray {, sizeof(TOvcCellAddress) * FLimit});
    FArray := NewA;
    FLimit := NewLimit;
    FCount := InxMerge;
  end;
{--------}
function TOvcCellArray.MustDoUnusedBit : boolean;
  begin
    Result := DoUnusedBit;
  end;
{====================================================================}


end.

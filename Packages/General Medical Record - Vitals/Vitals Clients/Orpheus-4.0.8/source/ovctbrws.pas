{*********************************************************}
{*                  OVCTBRWS.PAS 4.06                    *}
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

unit ovctbrws;
  {-Orpheus Table Rows array}

interface

uses
  Windows, SysUtils, Classes, OvcConst, OvcTCmmn, OvcSpAry;

type
  TOvcTableRows = class(TPersistent)
    {-Sparse array for rows}
    protected {private}
      {property fields}
      FActiveCount : TRowNum;
      FList      : TOvcSparseArray;
      FDefHeight : integer;
      FLimit     : TRowNum;
      {property event fields}
      FOnCfgChanged : TRowChangeNotifyEvent;

    protected
      {property read access}
      function GetRow(RowNum : TRowNum) : TRowStyle;
      function GetRowHeight(RowNum : TRowNum) : integer;
      function GetRowHidden(RowNum : TRowNum) : boolean;
      function GetRowIsSpecial(RowNum : TRowNum) : boolean;
      {property write access}
      procedure SetDefHeight(H : integer);
      procedure SetRow(RowNum : TRowNum; const RS : TRowStyle);
      procedure SetRowHeight(RowNum : TRowNum; H : integer);
      procedure SetRowHidden(RowNum : TRowNum; H : boolean);
      procedure SetLimit(RowNum : TRowNum);

      {general}
      procedure trDoCfgChanged(RowNum1, RowNum2 : TRowNum; Action : TOvcTblActions);

    public {protected}
      procedure rwScaleHeights(M, D : integer);

      property OnCfgChanged : TRowChangeNotifyEvent
         write FOnCfgChanged;

    public
      constructor Create;
        {-Create an array of row styles}
      destructor Destroy; override;
        {-Destroy an array of row styles}

      procedure Append(const RS : TRowStyle);
        {-Add row to end of current list, increment Limit}
      procedure Clear;
        {-Delete all row styles (reset all rows to the defaults)}
      procedure Delete(RowNum : TRowNum);
        {-Delete a row, move rows below it up one, decrement Limit}
      procedure Exchange(const RowNum1, RowNum2 : TRowNum);
        {-Exchange two rows}
      procedure Insert(const RowNum : TRowNum;
                       const RS : TRowStyle);
        {-Insert a row, move rows below it down one, increment Limit}
      procedure Reset(const RowNum : TRowNum);
        {-Reset a row to the defaults}

      property List [RowNum : TRowNum] : TRowStyle
        {-Array of row styles}
         read GetRow write SetRow;
         default;

      {properties}
      property Count : TRowNum
        {-The current number of rows with explicit attributes}
         read FActiveCount;

      property DefaultHeight : integer
        {-The default row height}
         read FDefHeight write SetDefHeight;

      property Height [RowNum : TRowNum] : integer
        {-Array of row heights}
         read GetRowHeight write SetRowHeight;

      property Hidden [RowNum : TRowNum] : boolean
        {-Array of row hidden flags}
         read GetRowHidden write SetRowHidden;

      property RowIsSpecial [RowNum : TRowNum] : boolean
         read GetRowIsSpecial;

      property Limit : TRowNum
        {-Maximum number of rows}
         read FLimit write SetLimit;
  end;


implementation


{===Extra RowStyle routines==========================================}
function NewRowStyle(AHeight : integer; AHidden : boolean) : PRowStyle;
  {-Allocate a row style on the heap}
  begin
    Result := New(PRowStyle);
    with Result^ do
      begin
        Height := AHeight;
        Hidden := AHidden;
      end;
  end;
{--------}
function DelRow(Index : Integer; Item : pointer; ExtraData : pointer) : boolean; far;
  {-Iterator to delete a row style from the sparse list}
  var
    R : PRowStyle absolute Item;
  begin
    Dispose(R);
    Result := true;
  end;
{--------------------------------------------------------------------}

{Note: the row numbers passed to this class have a minimum limit of
       zero, and an upper limit that consists of two parts. Firstly
       the real upper limit is the value of Limit: if a row number
       is greater than this an out-of-bounds exception is generated.
       Secondly the upper limit for rows with explicit styles is
       MaxSparseArrayItems, since that is the limit for the under-
       lying sparse array. Generally exceeding this limit causes the
       action to be ignored, no exception is generated.}


{===TOvcTableRows==========================================================}
constructor TOvcTableRows.Create;
  begin
    FList := TOvcSparseArray.Create;
    FDefHeight := tbDefRowHeight;
    FLimit := tbDefRowCount;
  end;
{--------}
destructor TOvcTableRows.Destroy;
  begin
    if Assigned(FList) then
      begin
        Clear;
        FList.Free;
      end;
  end;
{--------}
procedure TOvcTableRows.Append(const RS : TRowStyle);
  begin
    Insert(Limit, RS);
  end;
{--------}
procedure TOvcTableRows.Clear;
  var
    DummyPtr : pointer;
  begin
    DummyPtr := nil;
    FList.ForAll(DelRow, false, DummyPtr);
    FList.Clear;
    FActiveCount := 0;
    trDoCfgChanged(0, 0, taAll);
  end;
{--------}
procedure TOvcTableRows.Delete(RowNum : TRowNum);
  var
    RS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        RS := PRowStyle(FList[RowNum]);
        if Assigned(RS) then
          begin
            Dispose(RS);
            dec(FActiveCount);
          end;
        FList.Delete(RowNum);
        Limit := Limit - 1;
        trDoCfgChanged(RowNum, 0, taDelete);
      end;
  end;
{--------}
procedure TOvcTableRows.trDoCfgChanged(RowNum1, RowNum2 : TRowNum; Action : TOvcTblActions);
  {-On a change, call the notify event handler}
  begin
    if Assigned(FOnCfgChanged) then
      FOnCfgChanged(Self, RowNum1, RowNum2, Action);
  end;
{--------}
procedure TOvcTableRows.Exchange(const RowNum1, RowNum2 : TRowNum);
  begin
    if (RowNum1 < 0) or (RowNum1 >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum2 < 0) or (RowNum2 >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum1 <> RowNum2) and
       (RowNum1 < OvcSpAry.MaxSparseArrayItems) and
       (RowNum2 < OvcSpAry.MaxSparseArrayItems) then
      begin
        FList.Exchange(RowNum1, RowNum2);
        trDoCfgChanged(RowNum1, RowNum2, taExchange);
      end;
  end;
{--------}
function TOvcTableRows.GetRow(RowNum : TRowNum) : TRowStyle;
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (FActiveCount > 0) and (RowNum < OvcSpAry.MaxSparseArrayItems) then
      PRS := PRowStyle(FList[RowNum])
    else
      PRS := nil;
    if Assigned(PRS) then
      begin
        Result := PRS^;
        if (Result.Height = UseDefHt) then
          Result.Height := DefaultHeight;
      end
    else
      with Result do
        begin
          Height := DefaultHeight;
          Hidden := false;
        end;
  end;
{--------}
function TOvcTableRows.GetRowHeight(RowNum : TRowNum) : integer;
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    Result := DefaultHeight;
    if (FActiveCount > 0) and (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        PRS := PRowStyle(FList[RowNum]);
        if Assigned(PRS) then
          begin
            Result := PRS^.Height;
            if (Result = UseDefHt) then
              Result := DefaultHeight;
          end;
      end;
  end;
{--------}
function TOvcTableRows.GetRowHidden(RowNum : TRowNum) : boolean;
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    Result := false;
    if (FActiveCount > 0) and (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        PRS := PRowStyle(FList[RowNum]);
        if Assigned(PRS) then
          Result := PRS^.Hidden;
      end;
  end;
{--------}
function TOvcTableRows.GetRowIsSpecial(RowNum : TRowNum) : boolean;
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (FActiveCount > 0) and (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        PRS := PRowStyle(FList[RowNum]);
        Result := Assigned(PRS);
      end
    else
      Result := false;
  end;
{--------}
procedure TOvcTableRows.Insert(const RowNum : TRowNum;
                               const RS : TRowStyle);
  var
    Height : integer;
  begin
    {note: you can insert a style at row number Limit}
    if (RowNum < 0) or (RowNum > Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum >= OvcSpAry.MaxSparseArrayItems) then
      TableErrorRes(SCTableMaxRows);
    Height := RS.Height;
    if (Height < 1) or (Height = DefaultHeight) then
      Height := UseDefHt;
    if (RS.Hidden = false) and (Height = UseDefHt) then
      FList.Insert(RowNum, nil)
    else
      begin
        FList.Insert(RowNum, NewRowStyle(Height, RS.Hidden));
        inc(FActiveCount);
      end;
    Limit := Limit + 1;
    trDoCfgChanged(RowNum, 0, taInsert);
  end;
{--------}
procedure TOvcTableRows.Reset(const RowNum : TRowNum);
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (FActiveCount > 0) and (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        PRS := PRowStyle(FList[RowNum]);
        if Assigned(PRS) then
          begin
            Dispose(PRS);
            FList[RowNum] := nil;
            dec(FActiveCount);
            trDoCfgChanged(RowNum, 0, taSingle);
          end;
      end;
  end;
{--------}
type
  PScaleExtraData = ^TScaleExtraData;
  TScaleExtraData = packed record
    M, D : integer;
  end;
  {------}
function ScaleHeight(Index : Integer; Item : pointer;
                     ExtraData : pointer) : boolean; far;
  var
    RS : PRowStyle absolute Item;
    ED : PScaleExtraData absolute ExtraData;
  begin
    Result := true;
    with RS^ do
      if (Height <> UseDefHt) then
        Height := MulDiv(Height, ED^.M, ED^.D);
  end;
  {------}
procedure TOvcTableRows.rwScaleHeights(M, D : integer);
  var
    ExtraData : TScaleExtraData;
  begin
    FDefHeight := MulDiv(FDefHeight, M, D);
    if (FActiveCount > 0) then
      begin
        ExtraData.M := M;
        ExtraData.D := D;
        FList.ForAll(ScaleHeight, false, @ExtraData);
      end;
  end;
{--------}
procedure TOvcTableRows.SetDefHeight(H : integer);
  begin
    if (H <> FDefHeight) and (H >= 1) then
      begin
        FDefHeight := H;
        trDoCfgChanged(0, 0, taAll);
      end;
  end;
{--------}
procedure TOvcTableRows.SetLimit(RowNum : TRowNum);
  begin
    if RowNum < 1 then
      RowNum := 1;
    if (RowNum <> FLimit) then
      begin
        FLimit := RowNum;
        trDoCfgChanged(RowLimitChanged, 0, taGeneral);
      end;
  end;
{--------}
procedure TOvcTableRows.SetRow(RowNum : TRowNum; const RS : TRowStyle);
  var
    PRS : PRowStyle;
    Height : integer;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        Height := RS.Height;
        if (Height < 1) or (Height = DefaultHeight) then
          Height := UseDefHt;
        if (RS.Hidden = false) and (Height = UseDefHt) then
          Reset(RowNum)
        else
          begin
            PRS := PRowStyle(FList[RowNum]);
            if Assigned(PRS) then
              PRS^ := RS
            else
              begin
                FList[RowNum] := NewRowStyle(Height, RS.Hidden);
                inc(FActiveCount);
              end;
            trDoCfgChanged(RowNum, 0, taSingle);
          end;
      end;
  end;
{--------}
procedure TOvcTableRows.SetRowHeight(RowNum : TRowNum; H : integer);
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        if (H < 1) or (H = DefaultHeight) then
          H := UseDefHt;
        PRS := PRowStyle(FList[RowNum]);
        if Assigned(PRS) then
          begin
            if (H <> PRS^.Height) then
              begin
                if (H = UseDefHt) then
                  if not PRS^.Hidden then
                    begin
                      Dispose(PRS);
                      FList[RowNum] := nil;
                      dec(FActiveCount);
                    end
                  else
                    PRS^.Height := UseDefHt
                else
                  PRS^.Height := H;
                trDoCfgChanged(RowNum, 0, taSingle);
              end;
          end
        else if (H <> UseDefHt) then {only create new style if not default}
          begin
            FList[RowNum] := NewRowStyle(H, false);
            inc(FActiveCount);
            trDoCfgChanged(RowNum, 0, taSingle);
          end;
      end;
  end;
{--------}
procedure TOvcTableRows.SetRowHidden(RowNum : TRowNum; H : boolean);
  var
    PRS : PRowStyle;
  begin
    if (RowNum < 0) or (RowNum >= Limit) then
      TableErrorRes(SCTableRowOutOfBounds);
    if (RowNum < OvcSpAry.MaxSparseArrayItems) then
      begin
        PRS := PRowStyle(FList[RowNum]);
        if Assigned(PRS) then
          begin
            if (H <> PRS^.Hidden) then
              begin
                if (not H) and (PRS^.Height = UseDefHt) then
                  begin
                    Dispose(PRS);
                    FList[RowNum] := nil;
                    dec(FActiveCount);
                  end
                else
                  PRS^.Hidden := H;
                trDoCfgChanged(RowNum, 0, taSingle);
              end;
          end
        else if H then {only create new style if hidden}
          begin
            FList[RowNum] := NewRowStyle(UseDefHt, H);
            inc(FActiveCount);
            trDoCfgChanged(RowNum, 0, taSingle);
          end;
      end;
  end;
{====================================================================}


end.

{*********************************************************}
{*                  OVCEDITN.PAS 4.06                    *}
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

unit ovceditn;
  {Editor paragraph node handling}

interface

uses
  OvcConst, OvcData;



type
  UndoType = (
    utSavePos,   {save a position}
    utInsert,    {an insertion within a paragraph}
    utInsPara,   {an insertion of an entire paragraph before another}
    utPlacePara, {an insertion of an entire paragraph after another}
    utDelete,    {a deletion within a paragraph}
    utDelPara,   {a deletion of an entire paragraph}
    utReplace);  {a replacement of text within a paragraph}

type
  PLineMap = ^LineMap;
  LineMap  = array[1..High(SmallInt)] of Word;

type
  {this variable sized structure is stored in a global undo}
  {buffer and mapped into a TUndoNode as required}
  PUndoRec = ^TUndoRec;
  TUndoRec = packed record
    PNum     : Integer;    {paragraph number}
    PPos     : Integer;    {position in paragraph}
    DSize    : Word;       {data size in characters (unicode: not bytes)}
    PrevSize : Word;       {size of previous record}
    Flags    : Byte;       {contains undo type and flags}
    LinkNum  : Byte;       {link number}
    Data     : record end; {data-dynamically allocated}
  end;

const
  UndoRecSize = SizeOf(TUndoRec);

type
  TUndoNode = class(TObject)
  public
    UndoRec : PUndoRec;

    procedure Init(PUR   : PUndoRec;         {location in buffer}
                   UT    : UndoType;
                   Link  : Byte;
                   MF    : Boolean;          {modified flag}
                   PSize : Word;
                   P     : Integer;
                   Pos   : Integer;
                   D     : PChar;        {data}
                   DLen  : Word);            {data length}
      {-init the data fields of the object}
    procedure InitReplace(PUR   : PUndoRec;  {location in buffer}
                          Link  : Byte;
                          MF    : Boolean;   {modified flag}
                          PSize : Word;
                          P     : Integer;
                          Pos   : Integer;
                          D     : PChar; {data}
                          DLen  : Word;      {data length}
                          R     : PChar; {replace data}
                          RLen  : Word);     {replace data length}
      {-init the data fields of the object for a replace action}
    procedure Done(PUR : PUndoRec);
      {-conditionall destroy a paragraph node if associated}
    function  GetUndoType(PUR : PUndoRec) : UndoType;
      {-return the undo type for this undo record}
    function  ModFlag(PUR : PUndoRec) : Boolean;
      {-return the state of the modified flag}
    procedure SetModFlag(PUR   : PUndoRec; Value : Boolean);
      {-return the modified flag for this undo record}
  end;


  TParaNode = class(TObject)
  public
    BufSize   : Word;       {size of buffer}
    LineCount : Integer;    {number of lines in this paragraph}
    Map       : PLineMap;   {pointer to line map}
    MapSize   : Word;       {number of elements in line map}
    Next      : TParaNode;  {next paragraph in list}
    Prev      : TParaNode;  {previous paragraph in list}
    S         : PChar;  {text of paragraph; nil if empty}
    SLen      : Word;       {current length}

    constructor Init(P       : PChar;
                     WrapCol : Integer;
                     TabSize : Integer);
      {-create paragraph from text of P^}
    constructor InitLen(P       : PChar;
                        Len     : Word;
                        WrapCol : Integer;
                        TabSize : Integer);
      {-create paragraph with Len characters from P^}
    destructor Destroy;
      override;

    function  GetS : PChar;
      {-return pointer to text of paragraph}
    function  ExpandToLength(NBS : Word) : Boolean;
      {-expand buffer to size NBS}
    function  EstimateMapSize(Len : Word; WrapCol : Integer) : Word;
      {-return an estimated map size}
    procedure ExpandLineMap(NMS : Word);
      {-expand line map to size NMS}
    procedure Recalc(WrapCol, TabSize : Integer);
      {-calculate the number of lines in this paragraph given the specified
        wrap column}
    procedure RecalcAfterInsDel(WrapCol, TabSize, Pos, RplLen, Count : Integer;
                                var FL, LL : Integer);
      {-calculate the number of lines after an insertion or deletion}
    function  NthLine(N : Integer; var Len : Word) : PChar;
      {-return a pointer to the Nth line of this paragraph; Len is its length}
    function  PosToLine(Pos : Integer; var Col : Integer) : Integer;
      {-given a position in the paragraph, return the line and Col}
    function  InsertTextPrim(St : PChar; StLen : Word;
                             Pos, WrapCol, TabSize : Integer;
                             var FL, LL : Integer) : Word;
      {-insert StLen characters from St^ at Pos}
    function  InsertText(St : PChar; Pos, WrapCol, TabSize : Integer;
                         var FL, LL : Integer) : Word;
      {-insert St^ at Pos}
    procedure DeleteText(Pos, Count, WrapCol, TabSize : Integer;
                         var FL, LL : Integer);
      {-delete count characters at Pos}
    function  ReplaceText(Pos, Count, WrapCol, TabSize : Integer;
                          St : PChar; StLen : Integer;
                          var FL, LL : Integer) : Word;
      {-replace the next Count characters at Pos with text of St^}
    function  TrimWhiteSpace : Word;
      {-trim trailing white space from end of paragraph}
    function  CountWhiteSpace(Pos : Integer) : Word;
      {-count amount of white space prior to Pos}
  end;



implementation

uses
  SysUtils, OvcEditU, OvcMisc;


const
  {undo record bit flags}
  urModFlag  = $80;
  urTypeMask = $7F;


{*** TUndoNode ***}

procedure TUndoNode.Done(PUR : PUndoRec);
var
  PPN : TParaNode;
begin
  {if this node is a deleted paragraph--then destroy it}
  if GetUndoType(PUR) = utDelPara then begin
    {put stored object pointer into temp para node}
    move(PUR^.Data, PPN, PUR^.DSize);
    PPN.Free;
  end;
end;

function TUndoNode.GetUndoType(PUR : PUndoRec) : UndoType;
begin
  Result := UndoType(PUR^.Flags and urTypeMask);
end;

procedure TUndoNode.Init(PUR : PUndoRec; UT : UndoType; Link : Byte;
                         MF : Boolean; PSize : Word; P : Integer;
                         Pos : Integer; D : PChar; DLen : Word);
begin
  with PUR^ do begin
    PrevSize := PSize;
    Flags := Ord(UT);
    if MF then
      Flags := Flags or urModFlag;
    LinkNum  := Link;
    PNum     := P;
    PPos     := Pos;
    DSize    := DLen;
    if DLen <> 0 then
      Move(D^, Data, DLen * SizeOf(Char));
  end;
end;

procedure TUndoNode.InitReplace(PUR : PUndoRec; Link : Byte; MF : Boolean;
                                PSize : Word; P : Integer; Pos : Integer;
                                D : PChar; DLen : Word; R : PChar; RLen : Word);
var
  DP : PChar;
begin
  with PUR^ do begin
    PrevSize := PSize;
    Flags := Ord(utReplace);
    if MF then
      Flags := Flags or urModFlag;
    LinkNum  := Link;
    PNum     := P;
    PPos     := Pos;
    DSize    := DLen+RLen+2;
    DP       := @Data;
    Move(D^, DP^, DLen * SizeOf(Char));
    DP[DLen] := #0;
    Inc(DP, DLen+1);
    Move(R^, DP^, RLen * SizeOf(Char));
    DP[RLen] := #0;
  end;
end;

function TUndoNode.ModFlag(PUR : PUndoRec) : Boolean;
begin
  Result := PUR^.Flags and urModFlag <> 0;
end;

procedure TUndoNode.SetModFlag(PUR : PUndoRec; Value : Boolean);
begin
  with PUR^ do
    if Value then
      Flags := Flags or urModFlag
    else
      Flags := Flags and not urModFlag;
end;


{*** TParaNode ***}

function TParaNode.CountWhiteSpace(Pos : Integer) : Word;
  {-Count amount of white space prior to Pos}
var
  L : Word;
begin
  Result := 0;
  if S <> nil then begin
    L := Pos;
    while (L > 0) and edWhiteSpace(S[L-1]) do begin
      Dec(L);
      Inc(Result);
    end;
  end;
end;

procedure TParaNode.DeleteText(Pos, Count, WrapCol, TabSize : Integer;
                               var FL, LL : Integer);
  {-Delete count characters at Pos}
begin
  if S = nil then
    Exit;
  if Pos > SLen then
    Exit;
  Dec(Pos);
  if Pos+Count >= SLen then begin
    SLen := Pos;
    S[Pos] := #0;
  end else begin
    edDeleteSubString(S, SLen, Count, Pos);
    Dec(SLen, Count);
  end;
  RecalcAfterInsDel(WrapCol, TabSize, Pos, 0, -Count, FL, LL);
end;

destructor TParaNode.Destroy;
  {-Destroy the paragraph}
begin
  if (S <> nil) then begin
    FreeMem(S, BufSize);
    S := nil;
  end;

  if (Map <> nil) then begin
    FreeMem(Map, MapSize*SizeOf(Word));
    Map := nil;
  end;

  inherited Destroy;
end;

function TParaNode.EstimateMapSize(Len : Word; WrapCol : Integer) : Word;
  {-Return an estimated map size}
var
  MS : Word;
begin
  if (WrapCol = High(SmallInt)) or (WrapCol = 0) then
    Result := 1
  else begin
    MS := (Len div WrapCol);
    Inc(MS, MS div 5);
    MS := (MS+7) and $FFF8;
    if MS < 8 then
      MS := 8;
    Result := MS;
  end;
end;

procedure TParaNode.ExpandLineMap(NMS : Word);
  {-Expand line map to size NMS}
var
  NMap : PLineMap;
begin
  NMS := (NMS+$7) and $FFF8;
  if NMS < 8 then
    NMS := 8;
  if NMS <= MapSize then
    Exit;

  GetMem(NMap, NMS*SizeOf(Word));
  FillChar(NMap^, NMS*SizeOf(Word), 0);

  Move(Map^, NMap^, MapSize*SizeOf(Word));

  FreeMem(Map, MapSize*SizeOf(Word));

  Map := NMap;
  MapSize := NMS;
end;

function TParaNode.ExpandToLength(NBS : Word) : Boolean;
  {-Expand buffer to size NBS}
var
  P : PChar;
begin
  Result := False;
  if NBS > BufSize then begin
    NBS := (NBS+$F) and $FFF0;
    GetMem(P, NBS * SizeOf(Char));
    if P = nil then
      Exit;
    if (BufSize <> 0) then begin
      Move(S^, P^, (SLen+1) * SizeOf(Char));
      FreeMem(S);
    end else
      P^ := #0;
    S := P;
    BufSize := NBS;
  end;
  Result := True;
end;

function TParaNode.GetS : PChar;
  {-Return pointer to text of paragraph}
begin
  if S = nil then
    Result := ''
  else
    Result := S;
end;

constructor TParaNode.Init(P : PChar; WrapCol, TabSize : Integer);
  {-Create paragraph from text of P^}
begin
  InitLen(P, StrLen(P), WrapCol, TabSize);
  {InitLen calls inherited Create}
end;

constructor TParaNode.InitLen(P : PChar; Len : Word;
                              WrapCol, TabSize : Integer);
  {-Create paragraph with Len characters from P^}
var
  Size : Word;
begin
  inherited Create;

  Map := nil;
  Next := nil;
  Prev := nil;
  Size := Len+1;
  LineCount := 1;

  {make copy of line}
  if Size = 1 then begin
    S := nil;
    BufSize := 0;
  end else begin
    BufSize := (Size+7) and $FFF8;
    GetMem(S, BufSize * SizeOf(Char));
    if S = nil then
      raise EOutOfMemory.Create(GetOrphStr(SCOutOfMemory));
    StrLCopy(S, P, Len);
  end;
  SLen := Len;

  {allocate initial line map}
  MapSize := EstimateMapSize(Len, WrapCol);
  GetMem(Map, MapSize*SizeOf(Word));
  if Map = nil then
    raise EOutOfMemory.Create(GetOrphStr(SCOutOfMemory));

  FillChar(Map^, MapSize*SizeOf(Word), 0);
  Recalc(WrapCol, TabSize);
end;

function TParaNode.InsertTextPrim(St : PChar; StLen : Word;
                                  Pos, WrapCol, TabSize : Integer;
                                  var FL, LL : Integer) : Word;
  {-Insert StLen characters from St^ at Pos}
var
  NBS : Word;
begin
  Dec(Pos);
  if Pos > SLen then
    NBS := Pos
  else
    NBS := SLen;
  Inc(NBS, StLen+1);
  if not ExpandToLength(NBS) then begin
    Result := oeOutOfMemory;
    Exit;
  end;

  if Pos > SLen then begin
    edPadPrim(S, Pos);
    SLen := Pos;
  end;

  edStrStInsert(S, St, SLen, StLen, Pos);
  Inc(SLen, StLen);
  RecalcAfterInsDel(WrapCol, TabSize, Pos, 0, StLen, FL, LL);
  Result := 0;
end;

function TParaNode.InsertText(St : PChar; Pos, WrapCol, TabSize : Integer;
                              var FL, LL : Integer) : Word;
  {-Insert St^ at Pos}
begin
  Result := InsertTextPrim(St, StrLen(St), Pos, WrapCol, TabSize, FL, LL);
end;

function TParaNode.NthLine(N : Integer; var Len : Word) : PChar;
  {-Return a pointer to the Nth line of this paragraph; Len is its length}
var
  S1 : PChar;
begin
  if (N < 1) or (N > LineCount) then begin
    S1 := '';
    Len := 0;
  end else if LineCount = 1 then begin
    S1 := GetS;
    Len := SLen;
  end else begin
    S1 := S;
    Inc(S1, Map^[N]);
    if N = LineCount then
      Len := StrLen(S1)
    else
      Len := Map^[N+1]-Map^[N];
  end;
  Result := S1;
end;

function TParaNode.PosToLine(Pos : Integer; var Col : Integer) : Integer;
  {-Given a position in the paragraph, return the line and Col}
var
  I : Word;
  LC : Integer;
begin
  if LineCount = 1 then begin
    Col := Pos;
    Result := 1;
  end else begin
    {make sure we don't have to search more than 1/4 of the line map}
    LC := LineCount;
    if (LC > 20) then
      if (Pos <= Map^[LC div 2]) then begin
        LC := LC div 2;
        if (Pos <= Map^[LC div 2]) then
          LC := LC div 2;
      end else if (Pos <= Map^[LC-(LC div 2)]) then
        Dec(LC, LC div 2);
    I := edFindPosInMap(Map, LC, Pos);
    Col := Pos-Map^[I];
    Result := I;
  end;
end;

procedure TParaNode.Recalc(WrapCol, TabSize : Integer);
  {-Calculate the number of lines in this paragraph given the specified
    wrap column}
var
  P, LP : PChar;
  Len, MS : Word;
  WC : Integer;
  HT : Boolean;
begin
  LineCount := 1;
  if (WrapCol = High(SmallInt)) or (WrapCol = 0) or (S = nil) then
    Exit;

  P := S;
  Len := SLen;

  {do we need to expand the line map before we start?}
  MS := EstimateMapSize(Len, WrapCol);
  if MS > MapSize then
    ExpandLineMap(MS);

  HT := (Len > 0) and edHaveTabs(P, Len);
  if HT then
    WC := edGetActualCol(P, WrapCol, TabSize)
  else
    WC := WrapCol;

  LP := P;
  while Len > WC do begin
    P := edFindNextLine(LP, WC);
    Dec(Len, PtrDiff(P, LP));
    if Len > 0 then begin
      Inc(LineCount);

      {do we need to expand the line map?}
      if LineCount > MapSize then
        ExpandLineMap(LineCount);
      Map^[LineCount] := PtrDiff(P, S);

      if HT then
        WC := edGetActualCol(P, WrapCol, TabSize)
      else if WrapCol > Len then
        WC := Len
      else
        WC := WrapCol;
      LP := P;
    end;
  end;
end;

procedure TParaNode.RecalcAfterInsDel(WrapCol, TabSize, Pos : Integer;
                                      RplLen, Count : Integer;
                                      var FL, LL : Integer);
  {-Calculate the number of lines after an insertion, deletion, or
    replacement}
label
  ExitPoint;
var
  P, LP : PChar;
  Len, O, PO, ML, PML : Word;
  WC, OL, I, L, C  : Integer;
  HT : Boolean;
begin
  L := PosToLine(Pos+1, C);
  OL := L;

  if (WrapCol = High(SmallInt)) or (WrapCol=0) or (S = nil) then begin
    FL := L;
    LL := L;
    Exit;
  end;

  if L > 1 then
    Dec(L);

  LP := NthLine(L, Len);
  Len := SLen-Map^[L];

  HT := (Len > 0) and edHaveTabs(LP, Len);
  if HT then
    WC := edGetActualCol(LP, WrapCol, TabSize)
  else
    WC := WrapCol;

  FL := 0;
  LL := 0;
  ML := Map^[L];
  PO := ML;
  while Len > WC do begin
    {get the start of the next line}
    P := edFindNextLine(LP, WC);

    {adjust the remaining length}
    Dec(Len, PtrDiff(P, LP));

    if Len > 0 then begin
      Inc(L);

      {do we need to expand the line map?}
      if L > MapSize then
        ExpandLineMap(L);

      O := PtrDiff(P, S);
      PML := ML;
      ML := Map^[L];

      {did the length of the previous line change?}
      if (FL = 0) and (ML <> 0) and (Pos >= ML) and (Pos < O) then begin
        LL := L;
        FL := L-1;
        Map^[L] := O;
      end else if (ML <> 0) and (ML = O-Count) and
                  ((RplLen = 0) or (O >= Pos+RplLen)) then begin
        {the line breaks didn't change from this point on}
        for I := L to LineCount do
          {all we need to do is adjust the offsets}
          Inc(Map^[I], Count);
        goto ExitPoint;
      end else begin
        if FL = 0 then
          FL := L;
        LL := L;

        if (RplLen = 0) and (Abs(Count) <= WC) and (ML <> 0) then
          {was a whole line deleted?}
          if (ML = PO-Count) and (Count < 0) and (Pos < O) then begin
            Move(Map^[L+1], Map^[L], (LineCount-L)*SizeOf(Word));
            Dec(LineCount);
            for I := L to LineCount do
              Inc(Map^[I], Count);
            goto ExitPoint;
          end else if (O = PML+Count) and (Count > 0) and (Pos < O) then begin
            {a whole line inserted?}
            Inc(LineCount);
            ExpandLineMap(LineCount);
            Move(Map^[L], Map^[L+1], (LineCount-L)*SizeOf(Word));
            Map^[L] := O;
            for I := L+1 to LineCount do
              Inc(Map^[I], Count);
            goto ExitPoint;
          end;
        Map^[L] := O;
      end;
      PO := O;

      if HT then
        WC := edGetActualCol(P, WrapCol, TabSize)
      else if WrapCol > Len then
        WC := Len
      else
        WC := WrapCol;
      LP := P;
    end;
  end;

  LineCount := L;

ExitPoint:
  if MapSize > LineCount then
    Map^[LineCount+1] := 0;
  if (FL = 0) then
    if OL = 1 then
      FL := OL
    else
      FL := OL-1
  else if (FL > OL) then
    FL := OL;
  if LL = 0 then
    LL := OL;
end;

function TParaNode.ReplaceText(Pos, Count, WrapCol, TabSize : Integer;
                               St : PChar; StLen : Integer;
                               var FL, LL : Integer) : Word;
  {-Replace the next Count characters at Pos with text of St^}
var
  L, Delta, FL1, LL1 : Integer;
begin
  Dec(Pos);
  Delta := StLen-Count;
  if Delta > 0 then
    if not ExpandToLength(SLen+Delta+1) then begin
      Result := oeOutOfMemory;
      Exit;
    end;

  if (StLen > 0) and (Count > 0) then begin
    if Delta >= 0 then
      L := Count
    else
      L := StLen;
    Move(St^, S[Pos], L * SizeOf(Char));
    RecalcAfterInsDel(WrapCol, TabSize, Pos, L, L, FL1, LL1);
  end else begin
    FL1 := High(SmallInt);
    LL1 := 0
  end;

  if Delta < 0 then
    edDeleteSubString(S, SLen, -Delta, Pos+StLen)
  else if Delta > 0 then
    edStrStInsert(S, @St[Count], SLen, Delta, Pos+Count);

  if Delta <> 0 then begin
    Inc(SLen, Delta);
    RecalcAfterInsDel(WrapCol, TabSize, Pos, 0, Delta, FL, LL);
  end;

  if (Delta = 0) or (FL1 < FL) then
    FL := FL1;
  if (Delta = 0) or (LL1 > LL) then
    LL := LL1;

  Result := 0;
end;

function TParaNode.TrimWhiteSpace : Word;
  {-Trim trailing white space from end of paragraph}
var
  L, N : Word;
begin
  N := 0;
  if S <> nil then begin
    L := SLen;
    while (L > 0) and edWhiteSpace(S[L-1]) do
      Dec(L);
    N := SLen-L;
    S[L] := #0;
    SLen := L;
  end;
  Result := N;
end;


end.

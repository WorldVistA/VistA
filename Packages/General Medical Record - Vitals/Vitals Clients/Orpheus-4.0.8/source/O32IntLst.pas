{*********************************************************}
{*                  O32INTLST.PAS 4.08                   *}
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
{*   Armin Biernaczyk:                                                        *}
{*     07/2011: Changed 'FList.List^[M]' to 'FList.List[M]' in several        *}
{*              places (for compatibility with Delphi Pulsar)                 *}
{* ***** END LICENSE BLOCK *****                                              *}

{$APPTYPE GUI}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}

{The following is a modified version of stack code, which was originally written
 for Algorithms Alfresco. It is copyright(c)2001 by Julian M. Bucknall and is
 used here with permission.}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit o32intlst;
  {Integer List class for Orpheus.}

interface

uses
  Classes;

type
  TO32IntList = class
    protected {private}
      FAllowDups : boolean;
      FCount     : integer;
      FIsSorted  : boolean;
      FList      : TList;
      function ilGetCapacity : integer;
      function ilGetItem(aInx : integer) : integer;
      procedure ilSetCapacity(aValue : integer);
      procedure ilSetCount(aValue : integer);
      procedure ilSetIsSorted(aValue : boolean);
      procedure ilSetItem(aInx : integer; aValue : integer);
      procedure ilSort;
    public
      constructor Create;
      destructor Destroy; override;
      function Add(aItem : integer) : integer;
      procedure Clear;
      procedure Insert(aInx : Integer; aItem : Pointer);
      property AllowDups : boolean
                  read FAllowDups write FAllowDups;
      property Capacity : integer
                  read ilGetCapacity write ilSetCapacity;
      property Count : integer
                  read FCount write ilSetCount;
      property IsSorted : boolean
                  read FIsSorted write ilSetIsSorted;
      property Items[aInx  : integer] : integer
                  read ilGetItem write ilSetItem; default;
  end;

implementation

uses
  SysUtils;

{===== TO32IntList ===================================================}
constructor TO32IntList.Create;
begin
  inherited Create;
  FList := TList.Create;
  FIsSorted := true;
  FAllowDups := false;
end;
{--------}
destructor TO32IntList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;
{--------}
function TO32IntList.Add(aItem : integer) : integer;
var
  L, R, M : integer;
begin
  if (not IsSorted) or (Count = 0) then
    Result := FList.Add(pointer(aItem))
  else begin
    Result := -1;
    L := 0;
    R := pred(Count);
    while (L <= R) do begin
      M := (L + R) div 2;
      if (integer(FList.List[M]) = aItem) then begin
        if AllowDups then begin
          FList.Insert(M, pointer(aItem));
          Result := M;
        end;
        Exit;
      end;
      if (integer(FList.List[M]) < aItem) then
        L := M + 1
      else
        R := M - 1;
    end;
    FList.Insert(L, pointer(aItem));
    Result := L;
  end;
  inc(FCount);
end;
{--------}
procedure TO32IntList.Clear;
begin
  FList.Clear;
  FCount := 0;
  FIsSorted := true;
end;
{--------}
function TO32IntList.ilGetCapacity : integer;
begin
  Result := FList.Capacity;
end;
{--------}
function TO32IntList.ilGetItem(aInx : integer) : integer;
begin
  Assert((0 <= aInx) and (aInx < Count), 'Index out of bounds');
  Result := integer(FList.List[aInx]);
end;
{--------}
procedure TO32IntList.ilSetCapacity(aValue : integer);
begin
  FList.Capacity := aValue;
end;
{--------}
procedure TO32IntList.ilSetCount(aValue : integer);
begin
  FList.Count := aValue;
  FCount := FList.Count;
end;
{--------}
procedure TO32IntList.ilSetIsSorted(aValue : boolean);
begin
  if (aValue <> FIsSorted) then begin
    FIsSOrted := aValue;
    if FIsSorted then
      ilSort;
  end;
end;
{--------}
procedure TO32IntList.ilSetItem(aInx : integer; aValue : integer);
begin
  Assert((0 <= aInx) and (aInx < Count), 'Index out of bounds');
  FList.List[aInx] := pointer(aValue);
end;
{--------}
procedure TO32IntList.ilSort;
begin
  Assert(false, 'TO32IntList.ilSort has not been implemented yet');
end;
{--------}
procedure TO32IntList.Insert(aInx : Integer; aItem : Pointer);
begin
  FIsSorted := false;
  FList.Insert(aInx, pointer(aItem));
  inc(FCount);
end;
{===== TO32IntList - end =============================================}

end.

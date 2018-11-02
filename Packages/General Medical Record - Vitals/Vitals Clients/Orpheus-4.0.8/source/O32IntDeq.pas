{*********************************************************}
{*                  O32INTDEQ.PAS 4.08                   *}
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
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{The following is a modified version of deque code, which was originally written
 for Algorithms Alfresco. It is copyright(c)2001 by Julian M. Bucknall and is
 used here with permission.}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit o32intdeq;
  {A simple deque class for Orpheus}

interface

uses
  Classes;

type
  TO32IntDeque = class
    protected {private}
      FList : TList;
      FHead : integer;
      FTail : integer;
      procedure idGrow;
    public
      constructor Create(aCapacity : integer);
      destructor Destroy; override;
      function IsEmpty : boolean;
      procedure Enqueue(aValue: integer);
      procedure Push(aValue: integer);
      function  Pop: integer;
  end;

implementation

uses
  SysUtils;

{=== TO32IntDeque ====================================================}
constructor TO32IntDeque.Create(aCapacity : integer);
begin
  inherited Create;
  FList := TList.Create;
  FList.Count := aCapacity;
  {let's help out the user of the deque by putting the head and tail
   pointers in the middle: it's probably more efficient}
  FHead := aCapacity div 2;
  FTail := FHead;
end;
{--------}
destructor TO32IntDeque.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;
{--------}
procedure TO32IntDeque.Enqueue(aValue : integer);
begin
  FList.List[FTail] := pointer(aValue);
  inc(FTail);
  if (FTail = FList.Count) then
    FTail := 0;
  if (FTail = FHead) then
    idGrow;
end;
{--------}
procedure TO32IntDeque.idGrow;
var
  OldCount : integer;
  i, j     : integer;
begin
  {grow the list by 50%}
  OldCount := FList.Count;
  FList.Count := (OldCount * 3) div 2;
  {expand the data into the increased space, maintaining the deque}
  if (FHead = 0) then
    FTail := OldCount
  else begin
    j := FList.Count;
    for i := pred(OldCount) downto FHead do begin
      dec(j);
      FList.List[j] := FList.List[i]
    end;
    FHead := j;
  end;
end;
{--------}
function TO32IntDeque.IsEmpty : boolean;
begin
  Result := FHead = FTail;
end;
{--------}
procedure TO32IntDeque.Push(aValue : integer);
begin
  if (FHead = 0) then
    FHead := FList.Count;
  dec(FHead);
  FList.List[FHead] := pointer(aValue);
  if (FTail = FHead) then
    idGrow;
end;
{--------}
function TO32IntDeque.Pop : integer;
begin
  if FHead = FTail then
    raise Exception.Create('Integer deque is empty: cannot pop');
  Result := integer(FList.List[FHead]);
  inc(FHead);
  if (FHead = FList.Count) then
    FHead := 0;
end;
{=== TO32IntDeque - end ==============================================}

end.

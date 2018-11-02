{*********************************************************}
{*                  O32WideCharSet.PAS 4.06              *}
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
{* The Initial Developer of the Original Code is Sebastian Zierer             *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

 unit O32WideCharSet;

interface

uses
  SysUtils;

type
  PWideCharSet = ^TWideCharSet;

  TWideCharSetEnumerator = class
  private
    FIndex: Integer;
    FList: PWideCharSet;
    FCurrent: Char;
  public
    constructor Create(AList: PWideCharSet);
    function GetCurrent: Char;
    function MoveNext: Boolean;
    property Current: Char read GetCurrent;
  end;

  TWideCharSet = record
  private
    FChars: array[0..255] of TSysCharSet;
  public
    function GetEnumerator: TWideCharSetEnumerator;
    class operator Include(Rec: TWideCharSet; AChar: Char): TWideCharSet;
    class operator Include(Rec: TWideCharSet; AChar: string): TWideCharSet;
    class operator Add(Rec: TWideCharSet; AChar: Char): TWideCharSet;
    class operator Subtract(Rec: TWideCharSet; AChar: Char): TWideCharSet;
    class operator Exclude(Rec: TWideCharSet; AChar: Char): TWideCharSet;
    class operator Exclude(Rec: TWideCharSet; AChar: string): TWideCharSet;
    class operator In(AChar: Char; Rec: TWideCharSet): Boolean;
    class operator Implicit(S: TSysCharSet): TWideCharSet;
    class operator Implicit(Rec: TWideCharSet): TSysCharSet;
  end;

implementation

{ TWideCharSet }

class operator TWideCharSet.Exclude(Rec: TWideCharSet;
  AChar: Char): TWideCharSet;
begin
  Result := Rec;
  Exclude(Result.FChars[Word(AChar) div 256], AnsiChar(Word(AChar) mod 256));
end;

class operator TWideCharSet.Exclude(Rec: TWideCharSet;
  AChar: string): TWideCharSet;
var
  C: Char;
begin
  Result := Rec;
  for C in AChar do
    Exclude(Result.FChars[Word(C) div 256], AnsiChar(Word(C) mod 256));
end;

function TWideCharSet.GetEnumerator: TWideCharSetEnumerator;
begin
  Result := TWideCharSetEnumerator.Create(@Self);
end;

class operator TWideCharSet.Include(Rec: TWideCharSet;
  AChar: Char): TWideCharSet;
begin
  Result := Rec;
  Include(Result.FChars[Word(AChar) div 256], AnsiChar(Word(AChar) mod 256));
end;

class operator TWideCharSet.Include(Rec: TWideCharSet;
  AChar: string): TWideCharSet;
var
  C: Char;
begin
  Result := Rec;
  for C in AChar do
    Include(Result.FChars[Word(C) div 256], AnsiChar(Word(C) mod 256));
end;

class operator TWideCharSet.Add(Rec: TWideCharSet;
  AChar: Char): TWideCharSet;
begin
  Result := Rec;
  Include(Result, AChar);
end;

class operator TWideCharSet.Subtract(Rec: TWideCharSet;
  AChar: Char): TWideCharSet;
begin
  Result := Rec;
  Exclude(Result, AChar);
end;

class operator TWideCharSet.Implicit(S: TSysCharSet): TWideCharSet;
begin
  Result.FChars[0] := S;
end;

class operator TWideCharSet.Implicit(Rec: TWideCharSet): TSysCharSet;
begin
  Result := Rec.FChars[0];
end;

class operator TWideCharSet.In(AChar: Char; Rec: TWideCharSet): Boolean;
begin
  Result := AnsiChar(Word(AChar) mod 256) in Rec.FChars[Word(AChar) div 256];
end;


{ TWideCharSetEnumerator }

constructor TWideCharSetEnumerator.Create(AList: PWideCharSet);
begin
  inherited Create;
  FIndex := -1;
  FList := AList;
end;

function TWideCharSetEnumerator.GetCurrent: Char;
begin
  Result := FCurrent;
end;

function TWideCharSetEnumerator.MoveNext: Boolean;
var
  C: Char;
begin
  Result := True;
  if FIndex = -1 then
    Inc(FIndex);

  while FList.FChars[FIndex] = [] do
  begin
    Inc(FIndex);
    if FIndex > High(FList.FChars) then
      Exit(False);
  end;

  for C in FList.FChars[FIndex] do
  begin
    FCurrent := Char(FIndex * 256 + Word(C));
    Break;
  end;
  Exclude(FList^, FCurrent);
end;

end.

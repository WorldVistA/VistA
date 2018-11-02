{*********************************************************}
{*                  OVCVALID.PAS 4.06                    *}
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

unit ovcvalid;

interface

uses
  OvcPB;

const
  {the following special characters are used by ValidateSubfields}
  PartialChar = 'p';  {prohibit Partial entry in this subfield}
  ReqdChar    = 'r';  {entire subfield is Required}
  UnlessChar  = 'u';  {no blanks in subfield unless whole field is blank}

{*** validation routine helper functions ***}

function ValidateNoBlanks(EF : TOvcPictureBase) : Word;
  {-validate that no usable fields in a string contain spaces}
function ValidateNotPartial(EF : TOvcPictureBase) : Word;
  {-validate that no usable fields in a string contain spaces unless all do}
function ValidateSubfields(EF : TOvcPictureBase; const SubfieldMask : string) : Word;
  {-validate that subfields in a string meet the requirements of SubfieldMask}


implementation

uses
  OvcData;


{*** validation routine helper functions ***}

function ValidateNoBlanks(EF : TOvcPictureBase) : Word;
  {-validate that no usable fields in a string contain spaces}
var
  I      : Integer;
  S      : string;
  Flags  : TPictureFlags;
begin
  {assume success}
  Result := 0;

  {get a copy of the edit string}
  S := EF.EditString;
  EF.pbGetPictureFlags(Flags);

  {if string is larger than the mask--can't validate it}
  if Length(S) > MaxPicture then
    Exit;

  {check for blanks}
  for I := 1 to Length(S) do begin
    if (Flags[I-1] <> pflagLiteral) and (S[I] = ' ') then begin
      Result := oeBlanksInField;
      EF.CurrentPos := I-1;
      Break;
    end;
  end;
end;

function ValidateNotPartial(EF : TOvcPictureBase) : Word;
  {-validate that no usable fields in a string contain spaces unless all do}
var
  I            : Integer;
  S            : string;
  Flags        : TPictureFlags;
  BlankIsError : Boolean;
begin
  {assume success}
  Result := 0;

  {initialize flags table}
  EF.pbGetPictureFlags(Flags);

  {get a copy of the edit string}
  S := EF.EditString;

  {if string is larger than the mask--can't validate it}
  if Length(S) > MaxPicture then
    Exit;

  {check for blanks}
  BlankIsError := False;
  for I := 1 to Length(S) do begin
    if Flags[I-1] <> pflagLiteral then begin
      if S[I] <> ' ' then
        BlankIsError := True
      else if BlankIsError then begin
        Result := oeBlanksInField;
        EF.CurrentPos := I-1;
        Break;
      end;
    end;
  end;
end;

function ValidateSubfields(EF : TOvcPictureBase; const SubfieldMask : string) : Word;
  {-validate that subfields in a string meet the requirements of SubfieldMask}
var
  I      : Integer;
  S      : string;
  Flags  : TPictureFlags;
  Ch     : Char;

  function SubFieldHasBlanks(I : Integer) : Boolean;
    {-return true if the subfield that contains index I has any blanks}
  var
    Start, Stop, J : Integer;
  begin
    {find start of subfield}
    Start := I;
    while (Start > 0) and (Flags[Start-1] <> pflagLiteral) do
      Dec(Start);

    {find end of subfield}
    Stop := I;
    while Flags[Stop+1] <> pflagLiteral do
      Inc(Stop);

    {scan subfield for blanks}
    for J := Start to Stop do
      if S[J+1] = ' ' then begin
        Result := True;
        Exit;
      end;

    Result := False;
  end;

  function WholeFieldIsBlank : Boolean;
    {-return true if an entire field is blank}
  var
    Start, Stop, J : Integer;
  begin
    {find start of first subfield}
    Start := 0;
    while Flags[Start] = pflagLiteral do
      Inc(Start);

    {find end of last subfield}
    Stop := Length(SubfieldMask)-1;
    while Flags[Stop] = pflagLiteral do
      Dec(Stop);

    {scan for non-blanks}
    for J := Start to Stop do
      if (Flags[J] <> pflagLiteral) and (S[J+1] <> ' ') then begin
        Result := False;
        Exit;
      end;

    Result := True;
  end;

begin
  {assume success}
  Result := 0;

  {initialize flags table}
  EF.pbGetPictureFlags(Flags);

  {modify our copy of the flags table based on SubfieldMask}
  for I := 1 to Length(SubfieldMask) do begin
    case SubfieldMask[I] of
      ReqdChar,
      PartialChar,
      UnlessChar : {no change};
    else
      Flags[I-1] := pflagLiteral;
    end;
  end;

  S := EF.EditString;
  for I := 1 to Length(S) do begin
    if (Flags[I-1] <> pflagLiteral) then begin
      Ch := S[I];
      case SubfieldMask[I] of
        ReqdChar :
          if (Ch = ' ') then begin
            Result := oeBlanksInField;
            EF.CurrentPos := I-1;
            Break;
          end;
        PartialChar :
          if (Ch <> ' ') and SubFieldHasBlanks(I-1) then begin
            Result := oePartialEntry;
            EF.CurrentPos := I-1;
            Break;
          end;
        UnlessChar :
          if (Ch = ' ') and not WholeFieldIsBlank then begin
            Result := oePartialEntry;
            EF.CurrentPos := I;
            Break;
          end;
      end;
    end;
  end;
end;


end.

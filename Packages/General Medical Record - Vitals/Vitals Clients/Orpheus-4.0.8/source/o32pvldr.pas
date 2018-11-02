{*********************************************************}
{*                  O32PVLDR.PAS 4.06                    *}
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

{$I OVC.INC}  {-Defines}

unit o32pvldr;
  {Paradox Mask Validator}

interface

uses
  O32Vldtr, Classes, Windows;

const
  ParadoxMaskCount  = 8;
  ParadoxMaskLength = 25;

  {Sample Paradox Masks}
  ParadoxMaskLookup : array [1..ParadoxMaskCount] of string =
  ('!\(999\)000-0000;1;_     Phone             (415)555-1212',
   '!99999;1;_               Extension         15450',
   '000\-00\-0000;1;_        Social Security   555-55-5555',
   '00000;1;_                Short Zip Code    90504',
   '00000\-9999;1;_          Long Zip Code     90504-0000',
   '!99/99/00;1;_            Date              06/27/01',
   '!90:00:00>LL;1;_         Long Time         09:05:15PM',
   '!90:00;1;_               Short Time        13:45');

type
{class - TO32ParadoxValidator}
  TO32ParadoxValidator = class(TO32BaseValidator)
  protected {private}
    FMaskBlank: Char;

    procedure SetInput(const Value: string); override;
    procedure SetMask(const Value: string); override;
    function  GetValid: Boolean; override;
    function  GetSampleMasks: TStringList; override;
    function  Validate(const Value: string; var Pos: Integer): Boolean;
    function  DoValidateChar(NewChar: Char;
                             MaskOffset: Integer): Boolean;
    function  ValidateChar(NewChar: Char;
                           Offset: Integer): Boolean;
    function FindLiteralChar(MaskOffset: Integer; InChar: Char): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    function IsValid: Boolean; override;
    property Valid;
    property Input;
  published
    {Properties}
    property Mask;
    {Events}
    property BeforeValidation;
    property AfterValidation;
    property OnValidationError;
  end;

implementation

uses
  Mask, SysUtils, O32VlReg, MaskUtils, OVCStr;

{===== TO32ParadoxValidator ==========================================}

constructor TO32ParadoxValidator.Create(AOwner: TComponent);
begin
  inherited;
  FMaskBlank := DefaultBlank;
end;
{=====}

function TO32ParadoxValidator.GetValid: Boolean;
begin
  result := IsValid;
end;
{=====}

function TO32ParadoxValidator.GetSampleMasks: TStringList;
var
  I : Integer;
begin
  { Set the length of the mask portion of the string }
  FSampleMaskLength := ParadoxMaskLength;

  FSampleMasks.Clear;

  { Load the string list }
  for I := 1 to ParadoxMaskCount do
    FSampleMasks.Add(ParadoxMaskLookup[I]);
  result := FSampleMasks;
end;
{=====}

function TO32ParadoxValidator.IsValid: Boolean;
var
  ErrorPos: Integer;
begin
  DoBeforeValidation;

  {assume the worst}
  FValid := false;

  {Set up validation and execute it against the input}
  FValid := Validate(FInput, ErrorPos);

  DoAfterValidation;

  if not FValid then begin
    DoOnError(self, 'Validation Error Encountered at string position '
      + IntToStr(ErrorPos));
  end;

  result := FValid;
end;
{=====}

procedure TO32ParadoxValidator.SetInput(const Value: string);
begin
  if FInput <> Value then
    FInput := Value;
end;
{=====}

procedure TO32ParadoxValidator.SetMask(const Value: string);
begin
  if FMask <> Value then
    FMask := Value;
end;
{=====}

function TO32ParadoxValidator.Validate(const Value: string; var Pos: Integer): Boolean;
var
  I : Integer;
begin
  result := true;
  Pos := 0;
  for I := 1 to Length(Value) do begin
    if not ValidateChar(Value[I], I) then begin
      result := false;
      Pos := I;
      Exit;
    end;
  end;
end;
{=====}

function TO32ParadoxValidator.ValidateChar(NewChar: Char;
                                           Offset: Integer): Boolean;
var
  MaskOffset: Integer;
begin
  Result := True;
  if FMask <> '' then
  begin
    Result := False;
    MaskOffset := OffsetToMaskOffset(FMask, Offset);
    if MaskOffset >= 0 then
    begin
      Result := DoValidateChar(NewChar, MaskOffset);
    end;
  end;
end;
{=====}

function TO32ParadoxValidator.FindLiteralChar(MaskOffset: Integer;
                                         InChar: Char): Integer;
var
  CType: TMaskCharType;
  LitChar: Char;
begin
  Result := -1;
  while MaskOffset < Length(Mask) do
  begin
    Inc(MaskOffset);
    CType := MaskGetCharType(Mask, MaskOffset);
    if CType in [mcLiteral, mcIntlLiteral] then
    begin
      LitChar := Mask[MaskOffset];
      if CType = mcIntlLiteral then
        LitChar := MaskIntlLiteralToChar(LitChar);
      if LitChar = InChar then
        Result := MaskOffset;
      Exit;
    end;
  end;
end;
{=====}

function TO32ParadoxValidator.DoValidateChar(NewChar: Char;
                                           MaskOffset: Integer): Boolean;
var
  Dir: TMaskDirectives;
  Str: string;
  CType: TMaskCharType;

  function IsKatakana(const Chr: Byte): Boolean;
  begin
    Result := (SysLocale.PriLangID = LANG_JAPANESE) and (Chr in [$A1..$DF]);
  end;

  function TestChar(NewChar: Char): Boolean;
  var
    Offset: Integer;
  begin
    Offset := MaskOffsetToOffset(FMask, MaskOffset);
    Result := not ((MaskOffset < Length(FMask)) and
               (UpCase(FMask[MaskOffset]) = UpCase(Mask[MaskOffset+1]))) or
               (ByteType(FMask, Offset) = mbTrailByte) or
               (ByteType(FMask, Offset+1) = mbLeadByte);
  end;

begin
  Result := True;
  CType := MaskGetCharType(FMask, MaskOffset);
  if not (CType in [mcLiteral, mcIntlLiteral]) then begin
    Dir := MaskGetCurrentDirectives(FMask, MaskOffset);
    case FMask[MaskOffset] of
      mMskNumeric, mMskNumericOpt:
        begin
          if not ((NewChar >= '0') and (NewChar <= '9')) then
            Result := False;
        end;
      mMskNumSymOpt:
        begin
          if not (((NewChar >= '0') and (NewChar <= '9')) or
                 (NewChar = ' ') or(NewChar = '+') or(NewChar = '-')) then
            Result := False;
        end;
      mMskAscii, mMskAsciiOpt:
        begin
          if CharInSet(NewChar, LeadBytes) and TestChar(NewChar) then
          begin
            Result := False;
            Exit;
          end;
          if IsCharAlpha(NewChar) then
          begin
            Str := ' ';
            Str[1] := NewChar;
            if (mdUpperCase in Dir)  then
              Str := AnsiUpperCase(Str)
            else if mdLowerCase in Dir then
              Str := AnsiLowerCase(Str);
          end;
        end;
      mMskAlpha, mMskAlphaOpt, mMskAlphaNum, mMskAlphaNumOpt:
        begin
          if CharInSet(NewChar, LeadBytes) then
          begin
            if TestChar(NewChar) then
              Result := False;
            Exit;
          end;
          Str := ' ';
          Str[1] := NewChar;
          if IsKatakana(Byte(NewChar)) then
            Exit;
          if not IsCharAlpha(NewChar) then
          begin
            Result := False;
            if ((FMask[MaskOffset] = mMskAlphaNum) or
                (FMask[MaskOffset] = mMskAlphaNumOpt)) and
                (IsCharAlphaNumeric(NewChar)) then
              Result := True;
          end
          else if mdUpperCase in Dir then
            Str := AnsiUpperCase(Str)
          else if mdLowerCase in Dir then
            Str := AnsiLowerCase(Str);
        end;
    end;
  end;
end;

initialization
    RegisterValidator(TO32ParadoxValidator);

finalization
    UnRegisterValidator(TO32ParadoxValidator);

end.


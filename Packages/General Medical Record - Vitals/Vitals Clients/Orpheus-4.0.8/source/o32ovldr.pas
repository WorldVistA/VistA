{*********************************************************}
{*                  O32OVLDR.PAS 4.06                    *}
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

unit o32ovldr;
  {Orpheus Mask Validator}

interface

uses
  Classes, O32VlDtr;

const
  OrpheusMaskCount  = 17;
  OrpheusMaskLength = 11;

  { Sample Orpheus Masks }
  OrpheusMaskLookup : array [1..OrpheusMaskCount] of string =
  ('XXXXXXXXXX any character',
   '!!!!!!!!!! any char (upper)',
   'LLLLLLLLLL any char (lower)',
   'xxxxxxxxxx any char (mixed)',
   'aaaaaaaaaa alphas only',
   'AAAAAAAAAA alphas (upper)',
   'llllllllll alphas (lower)',
   '9999999999 0-9',
   'iiiiiiiiii 0-9, -',
   '########## 0-9, -, .',
   'EEEEEEEEEE 0-9, E, -, .',
   'KKKK       Hexadecimal (1F3E) Allows 0-9, A-F, uppercase Alpha characters',
   'KK         Hexadecimal (FF) Allows 0-9, A-F, uppercase Alpha characters',
   'OOOOOOOOOO 0-7 (octal)',
   'bbbbbbbbbb 0, 1 (binary)',
   'B          T or F (upper)',   {Changed due to problem 667982}
   'Y          Y or N (upper)');  {Changed due to problem 667982}


  {Validation Error Codes}
  vecNotAnyOrUpperChar = 1;
  vecNotAnyOrLowerChar = 2;
  vecNotAlphaChar      = 3;
  vecNotUpperAlpha     = 4;
  vecNotLowerAlpha     = 5;
  vecNotDS             = 6;
  vecNotDSM            = 9;
  vecNotDSMP           = 10;
  vecNotDSMPE          = 11;
  vecNotHexadecimal    = 12;
  vecNotBinary         = 13;
  vecNotOctal          = 14;
  vecNotTrueFalse      = 15;
  vecNotYesNo          = 16;
  vecTooLongInput      = 20; {New code to fix problem 866667}

type
{class - TO32OrMaskValidator}
  TO32OrMaskValidator = class(TO32BaseValidator)
  protected {private}
    FMaskBlank: Char;

    procedure SetInput(const Value: string); override;
    procedure SetMask(const Value: string); override;
    function  GetValid: Boolean; override;
    function  GetSampleMasks: TStringList; override;
    function  Validate(const Value: string; var ErrorPos: Integer): Boolean;
  public
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
  SysUtils, OvcData, O32VlReg;


{===== TO32OrMaskValidator ===========================================}

function TO32OrMaskValidator.GetSampleMasks: TStringList;
var
  I : Integer;
begin
  { Set the length of the mask portion of the string }
  FSampleMaskLength := OrpheusMaskLength;

  FSampleMasks.Clear;

  { Load the string list }
  for I := 1 to OrpheusMaskCount do
    FSampleMasks.Add(OrpheusMaskLookup[I]);
  result := FSampleMasks;
end;
{=====}

function TO32OrMaskValidator.GetValid: Boolean;
begin
  result := IsValid;
end;
{=====}

function TO32OrMaskValidator.IsValid: Boolean;
var
  ErrorStr: string;
  ErrorPos: Integer;
begin
  DoBeforeValidation;

  {assume the worst}
  FValid := false;

  {Set up validation and execute it against the input}
  FValid := Validate(FInput, ErrorPos);

  DoAfterValidation;

  if not FValid then begin
    case FErrorCode of
      vecNotAnyOrUpperChar :
        ErrorStr := 'Lowercase characters not allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotAnyOrLowerChar :
        ErrorStr := 'Uppercase characters not allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotAlphaChar      :
        ErrorStr := 'Non-Alpha characters not allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotUpperAlpha     :
        ErrorStr := 'Non-Uppercase Alpha characters not allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotLowerAlpha     :
        ErrorStr := 'Non-Lowercase Alpha characters not allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotDS             :
        ErrorStr := 'Digits and spaces only allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotDSM            :
        ErrorStr := 'Digits, spaces and ''-'' only allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotDSMP           :
        ErrorStr := 'Digits, spaces ''-'', and ''.'' only allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotDSMPE          :
        ErrorStr := 'Digits, spaces ''-'', ''.'', and ''e/E'' only allowed '
          + 'in position ' + IntToStr(ErrorPos) + '.';
      vecNotHexadecimal    :
        ErrorStr := 'Hexadecimal characters only (0-F) allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotBinary         :
        ErrorStr := 'Binary characters only (0, 1, and space) allowed in '
          + 'position ' + IntToStr(ErrorPos) + '.';
      vecNotOctal          :
        ErrorStr := 'Octal characters only (0-7) allowed in position '
          + IntToStr(ErrorPos) + '.';
      vecNotTrueFalse      :
        ErrorStr := 'Only True/false characters (T, t, F, f) allowed in '
          + 'position ' + IntToStr(ErrorPos) + '.';
      vecNotYesNo          :
        ErrorStr := 'Only Yes/No characters (Y, y, N, n) allowed in position '
          + IntToStr(ErrorPos) + '.';
{
    Fix for problem 866667
    New code added - translation also added
}
      vecTooLongInput      :
        ErrorStr := 'The input is not allowed to be longer than '
          + IntToStr(ErrorPos-1) + ' characters.';
    end;
    DoOnError(self, 'Invalid match at character position ' + IntToStr(ErrorPos));
  end;
  result := FValid;
end;
{=====}

procedure TO32OrMaskValidator.SetInput(const Value: string);
begin
  if FInput <> Value then
    FInput := Value;
end;
{=====}

procedure TO32OrMaskValidator.SetMask(const Value: string);
begin
  if FMask <> Value then
    FMask := Value;
end;
{=====}

function TO32OrMaskValidator.Validate(const Value: string;
                                      var ErrorPos: Integer): Boolean;
var
  I: Integer;
begin
  ErrorPos := 0;
  result := true;
  if Length(Input) > Length(FMask) then begin
    result := false;
    ErrorPos := Length(FMask) + 1;
{
    Fix for problem 866667
    If the error code is not set up, depending controls will sometimes
    fail to recoginze that there was a problem with the validation related
    to the input string beeing longer than the mask.
}
    FErrorCode := vecTooLongInput;
    exit;
  end;

  for I := 1 to Length(Input) do begin
    case FMask[I] of
      {pmAnyChar     : 'X' allows any character}
        { do nothing here - All entry is OK.}

      pmForceUpper  : {'!' allows any uppercase character}
        if (ord(Input[I]) in [97..122]{lowercase characters}) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotAnyOrUpperChar;
          exit;
        end;

      pmForceLower  : {'L' allows any lowercase character}
        if (ord(Input[I]) in [65..90]{uppercase characters}) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotAnyOrLowerChar;
          exit;
        end;

      {pmForceMixed  : 'x' allows any character. Just like 'X'}
       { do nothing here - All entry is ok, no way to force mixed case without }
       { back tracking }

      pmAlpha       : {'a' allows alphas only}
        if not (ord(Input[I]) in [65..90, 97..122]{any alpha}) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotAlphaChar;
          exit;
        end;

      pmUpperAlpha  : {'A' allows uppercase alphas only}
        if not (ord(Input[I]) in [65..90]{uppercase alpha}) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotUpperAlpha;
          exit;
        end;

      pmLowerAlpha  : {'l' allows lowercase alphas only}
        if not (ord(Input[I]) in [97..122]{lowercase alpha}) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotLowerAlpha;
          exit;
        end;

      pmPositive    : {'9' allows numbers and spaces only}
        if not (ord(Input[I]) in [48..57, 32]) then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotDS;
          exit;
        end;

      pmWhole       : {'i' allows numbers, spaces, minus}
        if not (ord(Input[I]) in [48..57, 32, 45]) then
        begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotDSM;
          exit;
        end;

      pmDecimal     : {'#' allows numbers, spaces, minus, period}
        if not (ord(Input[I]) in [48..57, 32, 45, 46])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotDSMP;
          exit;
        end;

      pmScientific  : {'E' allows numbers, spaces, minus, period, 'e'}
        if not (ord(Input[I]) in [48..57, 32, 45, 46, 101, 69])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotDSMPE;
          exit;
        end;

      pmHexadecimal : {'K' allows 0-9 and uppercase A-F}
        if not (ord(Input[I]) in [48..57, 65..70])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotHexadecimal;
          exit;
        end;

      pmBinary      : {'b' allows 0-1, space}
        if not (ord(Input[I]) in [48, 49, 32])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotBinary;
          exit;
        end;

      pmOctal       : {'O' allows 0-7, space}
        if not (ord(Input[I]) in [48..55, 32])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotOctal;
          exit;
        end;

      pmTrueFalse   : {'B' allows T, t, F, f}
        if not (ord(Input[I]) in [84, 116, 70, 102])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotTrueFalse;
          exit;
        end;

      pmYesNo       : {'Y' allows Y, y, N, n}
        if not (ord(Input[I]) in [89, 121, 78, 110])
        then begin
          result := false;
          ErrorPos := I;
          FErrorCode := vecNotYesNo;
          exit;
        end;
    end;
  end;
end;


initialization
    RegisterValidator(TO32OrMaskValidator);

finalization
    UnRegisterValidator(TO32OrMaskValidator);

end.


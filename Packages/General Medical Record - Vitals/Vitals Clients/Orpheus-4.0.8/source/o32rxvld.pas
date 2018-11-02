{*********************************************************}
{*                  O32RXVLD.PAS 4.06                    *}
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

unit o32rxvld;
  {Unit for the Orpheus RegEx Validator}

interface

uses Classes, O32Vldtr, O32RxNgn, SysUtils;

const
  RXMaskCount  = 13;
  RXMaskLength = 80;

  {Sample Regular Expressions for the Regex validator Property editor...}
  RXMaskLookup : array [1..RXMaskCount] of string =
  ('.+                                                                               1 or more of any characters allowed. Minimum of 1 character required. Note: This is the default behavior. No expression is needed.',
   '.*                                                                               Any number of any character allowed. Note: Although This expression allows an empty string, The RegexEngine will fail an empty string.',
   '(1[012]|[1-9]):[0-5][0-9] (am|pm)                                                Time of day: Standard AM/PM time display (9:17 am) or (12:30 pm)',
   '(1[012]|[1-9]):[0-5][0-9]:[0-5][0-9] (am|pm)                                     Time of day: Standard AM/PM time diplay with seconds. (9:17:22 am)',
   '(([01]?[0-9])|(2[0-3])):[0-5][0-9]                                               Time of day: 24 hour clock (15:22).',
   '(([01]?[0-9])|(2[0-3])):[0-5][0-9]:[0-5][0-9]                                    Time of day: 24 hour clock with seconds (15:22:07).',
   '(\(?[1-9][0-9][0-9]\)? )?[1-9][0-9][0-9]\-[0-9][0-9][0-9][0-9]                   Telephone Number: Optional area-code with optional parenthesis',
   '(0?[1-9]|1[012])(\\|/|\-)([012]?[1-9]|[123]0|31)(\\|/|\-)([123][0-9])?[0-9][0-9] Date: (mm\dd\yy) or (mm\dd\yyyy) formats. Also accepts / and - separators. Note: Only covers years from 1000-3999',
   '(y(es)?)|(no?)                                                                   Boolean: Y, y, N, n, Yes, yes, No or no',
   '(t(rue)?)|(f(alse)?)                                                             Boolean: T, t, F, f, True, False, true or false',
   '([0-9]|[A-F])+                                                                   Hexadecimal: Allows any number of characters in the range 0-9 and A-F',
   '[0-7]+                                                                           Octal: Allows any number of characters in the range 0-7.',
   '[01]+                                                                            Binary:Allows any number of binary characters (0 and 1).');

  {Error Codes}
  EC_NO_ERROR      = 0;
  EC_INVALID_EXPR  = 1;
  EC_INVALID_INPUT = 2;
  EC_NO_MATCH      = 3;

type
{class - TO32RegExValidator}
  TO32RegExValidator = class(TO32BaseValidator)
  protected {private}
    FLogging        : Boolean;           {Log validator parsing?}
    FLogFile        : String;            {Logging file name}
    FRegexEngine    : TO32RegExEngine;   {Regex engine used by the validator}
    FExprErrorPos   : Integer;           {Error position in the Regex string}
    FExprErrorCode  : TO32RegexError;    {Regex string error code}
    FIgnoreCase     : Boolean;           {Case sensitive matching}
    procedure SetIgnoreCase(const Value: Boolean);
    procedure SetLogging(const Value: Boolean);
    procedure SetLogFile(const Value: String);
    procedure SetMask(const Value: String); override;
    function  GetValid: Boolean; override;
    function  GetSampleMasks: TStringList; override;
    procedure SetInput(const Value: string); override;
    function CheckExpression(var ErrorPos: Integer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValid: Boolean; override;
    function GetExprError: String;
    property Valid;
    property ExprErrorPos: Integer read FExprErrorPos write FExprErrorPos;
  published
    property Input;
    { Surfaced the Mask property as "Expression" for the Regex validator
      Left Mask exposed as public for automated use such as the ValidatorPool}
    property Expression: string read FMask write SetMask stored true;
    property Logging: Boolean read FLogging write SetLogging
      default False;
    property LogFile: String read FLogFile write SetLogFile;
    property IgnoreCase: Boolean read FIgnoreCase write SetIgnoreCase stored true
      default True;
    {Events}
    property BeforeValidation;
    property AfterValidation;
    property OnValidationError;
  end;

implementation

uses
  O32VlReg;

{=== TO32RegExValidator ==============================================}
constructor TO32RegExValidator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLogging    := false;
  FLogFile    := 'parse.log';
  FIgnoreCase := true;

  FRegexEngine := TO32RegExEngine.Create('');
  FRegexEngine.Logging    := FLogging;
  FRegexEngine.LogFile    := FLogFile;
  FRegexEngine.IgnoreCase := FIgnoreCase;
end;
{=====}

destructor TO32RegExValidator.Destroy;
begin
  FRegexEngine.Free;
  inherited Destroy;
end;
{=====}

function TO32RegExValidator.GetSampleMasks: TStringList;
var
  I : Integer;
begin
  { Set the length of the mask portion of the string }
  FSampleMaskLength := RXMaskLength;

  FSampleMasks.Clear;

  { Load the string list }
  for I := 1 to RXMaskCount do
    FSampleMasks.Add(RXMaskLookup[I]);
  result := FSampleMasks;
end;
{=====}

procedure TO32RegExValidator.SetMask(const Value: String);
var
  OldExpression: String;
begin
  OldExpression := FMask;
  FMask := Value;
  if not CheckExpression(FExprErrorPos) then
    FMask := OldExpression;
end;
{=====}

procedure TO32RegExValidator.SetInput(const Value: string);
begin
  if FInput <> Value then
    FInput := Value;
end;
{=====}

function TO32RegExValidator.CheckExpression(var ErrorPos: Integer): Boolean;
begin
  if (FMask <> '') then begin
    FRegexEngine.RegexString := FMask;
    if not FRegexEngine.Parse(FExprErrorPos, FExprErrorCode) then begin
      result := false;
      FErrorCode := EC_INVALID_EXPR;
      DoOnError(self, GetExprError);
    end else
      result := true;
  end else begin
  {Allow the user to initialize the Validator with an empty string}
    result := true;
    ErrorPos := 0;
    FExprErrorPos := 0;
    FErrorCode := EC_NO_ERROR;
    FExprErrorCode := recNone;
  end;
end;
{=====}

function TO32RegExValidator.GetValid: Boolean;
begin
  result := IsValid;
end;
{=====}

function TO32RegExValidator.IsValid: Boolean;
var
  RegExStr: String;
begin
  DoBeforeValidation;

  {assume the worst}
  FValid := false;

  {Create a copy of the Expression and then enclose it in anchor operators so
   that the RegexEngine only matches the whole string...}
  RegExStr := FMask;
  {Check for Anchor operator ^}
  if (Pos('^', RegExStr) <> 1) then
    Insert('^', RegExStr, 1);
  {Check for Anchor operator $}
  if (Pos('$', RegExStr) <> Length(RegExStr)) then
    RegexStr := RegExStr + '$';

  {Pass the RegexStr into the RegexEngine}
  FRegexEngine.RegexString := RegExStr;

  if (RegExStr = '') then begin
    FErrorCode := EC_INVALID_EXPR;
    FValid := false;
  end else if (FInput = '') then begin
    FErrorCode := EC_INVALID_INPUT;
    FValid := false;
  end else begin
    if (FRegexEngine.MatchString(FInput) = 1) then begin
      FValid := true;
      FErrorCode := 0;
    end else begin
      FValid := false;
      FErrorCode := EC_NO_MATCH;
    end;
  end;

  result := FValid;

  DoAfterValidation
end;
{=====}

procedure TO32RegExValidator.SetLogging(const Value: Boolean);
begin
  if (FLogging <> Value) then begin
    FLogging := Value;
    FRegexEngine.Logging := FLogging;
  end;
end;
{=====}

procedure TO32RegExValidator.SetIgnoreCase(const Value: Boolean);
begin
  if (FIgnoreCase <> Value) then begin
    FIgnoreCase := Value;
    FRegexEngine.IgnoreCase := FIgnoreCase;
  end;
end;
{=====}

procedure TO32RegExValidator.SetLogFile(const Value: String);
begin
  if (FLogFile <> Value) then begin
    FLogFile := Value;
    FRegexEngine.LogFile := FLogFile;
  end;
end;
{=====}

function TO32RegExValidator.GetExprError: String;
begin
  case FExprErrorCode of
    recNone         : result := '';
    recSuddenEnd    : result := 'Incomplete Expression';
    recMetaChar     : result := 'Read a metacharacter where there should have'
      + ' been a normal character';
    recNoCloseParen : result := 'Missing closing parenthesis';
    recExtraChars   : result := 'Unrecognizable text at the end of the'
      + ' expression';
  end;
end;
{=====}

initialization

    RegisterValidator(TO32RegexValidator);

finalization

    UnRegisterValidator(TO32RegexValidator);

end.

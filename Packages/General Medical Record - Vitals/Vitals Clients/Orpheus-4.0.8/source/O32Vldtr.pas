{*********************************************************}
{*                    O32VLDTR.PAS 4.06                  *}
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

unit o32vldtr;
  {-Base classes for the TO32Validator and descendant components}

{
TO32BaseValidator is the abstract ancestor for all Orpheus Validator components
Descendants must override SetInput, SetMask, GetValid and IsValid plus define
the validation to provide full functionality.

Descendant classes which call the RegisterValidator and UnRegisterValidator
procedures in their unit's Initialization and Finalization sections will be
available as a selection in the ValidatorType property of components that use
validators internally.
}

interface

uses
  Windows, Classes, OvcBase;

type
  TValidationEvent = (veOnChange, veOnEnter, veOnExit);

  TValidatorErrorEvent =
    procedure(Sender: TObject; const ErrorMsg: string) of object;

  TValidatorClass = class of TO32BaseValidator;

  TO32BaseValidator = class(TO32Component)
  protected {private}
    {property variables}
    FBeforeValidation   : TNotifyEvent;
    FAfterValidation    : TNotifyEvent;
    FOnUserValidation   : TNotifyEvent;
    FOnErrorEvent       : TValidatorErrorEvent;

    FInput              : string;
    FMask               : string;
    FValid              : boolean ;
    FErrorCode          : Word;
    FSampleMaskLength   : Word;
    FSampleMasks        : TStringList;

    procedure SetAbout(const Value: string);
    procedure SetInput(const Value: string); virtual; abstract;
    procedure SetMask(const Value: string); virtual; abstract;
    procedure SetValid(Value: boolean);
    function  GetAbout: string;
    function  GetValid: Boolean; virtual; abstract;
    function  GetSampleMasks: TStringList; virtual; abstract;
    procedure DoOnUserValidation;
    procedure DoBeforeValidation;
    procedure DoAfterValidation;
    procedure DoOnError(Sender: TObject; const ErrorMsg: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {Public Methods}
    function IsValid: Boolean; virtual; abstract;
    function SampleMaskLength: integer;

    {Public Properties}
    property Input : string read FInput
      write SetInput;
    property Mask : string read FMask write SetMask;
    property Valid : boolean read GetValid;
    property ErrorCode: Word read FErrorCode;
    property SampleMasks: TStringList read GetSampleMasks;

    {Public Events}
    property BeforeValidation : TNotifyEvent
      read FBeforeValidation write FBeforeValidation;
    property AfterValidation : TNotifyEvent
      read FAfterValidation write FAfterValidation;
    property OnValidationError : TValidatorErrorEvent
      read FOnErrorEvent write FOnErrorEvent;

  published
    property About : string read GetAbout write SetAbout
      stored False;
  end;

implementation

uses
  OvcVer;

{===== TO32BaseValidator ===========================================}
constructor TO32BaseValidator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSampleMaskLength := 0;
  FSampleMasks := TStringList.Create;
end;
{=====}

destructor TO32BaseValidator.Destroy;
begin
  FSampleMasks.Clear;
  FSampleMasks.Free;
  inherited Destroy;
end;
{=====}

function TO32BaseValidator.SampleMaskLength: integer;
begin
  result := FSampleMaskLength;
end;
{=====}

function TO32BaseValidator.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32BaseValidator.SetAbout(const Value : string);
begin
end;
{=====}

procedure TO32BaseValidator.SetValid(Value: boolean);
begin
  if FValid <> Value then
    FValid := Value;
end;
{=====}

procedure TO32BaseValidator.DoOnUserValidation;
begin
  if Assigned(FOnUserValidation) then
    FOnUserValidation(Self);
end;
{=====}

procedure TO32BaseValidator.DoBeforeValidation;
begin
  if Assigned(FBeforeValidation) then
    FBeforeValidation(Self);
end;
{=====}

procedure TO32BaseValidator.DoAfterValidation;
begin
  if Assigned(FAfterValidation) then
    FAfterValidation(Self);
end;
{=====}

procedure TO32BaseValidator.DoOnError(Sender: TObject; const ErrorMsg: string);
begin
  if Assigned(FOnErrorEvent) then
    FOnErrorEvent(Self, ErrorMsg);
end;

end.

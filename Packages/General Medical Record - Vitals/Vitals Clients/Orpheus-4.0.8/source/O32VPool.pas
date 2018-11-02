{*********************************************************}
{*                    O32VPOOL.PAS 4.06                  *}
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

unit o32vpool;
  {O32ValidatorPool component classes}

interface

uses
  OvcBase, Classes, Graphics, stdctrls, O32Vldtr, o32ovldr, o32pvldr, o32rxvld;

type
  TO32ValidatorPool = class;

  TVPoolNotifyEvent =
    procedure (Sender: TObject; ValidatorItem: Integer) of object;


  { - TO32ValidatorItem - }
  TO32ValidatorItem = class(TO32CollectionItem)
  protected {private}
    FValidator        : TO32BaseValidator;
    FValidationEvent  : String;
    FValidatorClass   : TValidatorClass;
    FValidatorType    : String;
    FBeepOnError      : Boolean;
    FMask             : String;

    {Component for which this item will validate}
    FComponent        : TCustomEdit;
    FComponentColor   : TColor;
    FErrorColor       : TColor;
    {Event for which this object will execute a validation}
    FEvent            : TValidationEvent;

    procedure DoValidation(Sender: TObject);
    procedure SetComponent(Value: TCustomEdit);
    procedure SetValidatorType(const Value: String);
    procedure AssignValidator;
    procedure SetEvent(Event: TValidationEvent);
    procedure AssignEvent;
    function ValidatorPool: TO32ValidatorPool;
  public
    constructor Create(Collection: TCollection); override;
    property Validator: TO32BaseValidator
      read FValidator write FValidator;
    property ValidatorClass: TValidatorClass read FValidatorClass
      write FValidatorClass;
  published
    property BeepOnError: Boolean
      read FBeepOnError write FBeepOnError;
    property Name;
    property ErrorColor: TCOlor
      read FErrorColor write FErrorColor;
    property Component: TCustomEdit
      read FComponent write SetComponent;
    property Mask: String
      read FMask write FMask;
    property ValidationEvent: TValidationEvent
      read FEvent write SetEvent;
    property ValidatorType : string
      read FValidatorType write SetValidatorType stored true;
  end;

  TO32Validators = class(TO32Collection)
  protected {private}
    FValidatorPool : TO32ValidatorPool;
    function GetItem(Index: Integer): TO32ValidatorItem;
  public
    constructor Create(AOwner : TPersistent;
      ItemClass : TCollectionItemClass); override;
    function AddItem(ValidatorClass: TValidatorClass): TCollectionItem;
    procedure Delete(Index: Integer);
    procedure DeleteByName(const Name: String);
    function GetValidatorByName(const Name: String): TO32BaseValidator;
    property ValidatorPool: TO32ValidatorPool
      read FValidatorPool;
    property Items[index: Integer]: TO32ValidatorItem
      read GetItem;
  end;

  { - TO32ValidatorPool - }
  TO32ValidatorPool = class(TO32Component)
  protected {private}
    FValidators: TO32Validators;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Name;
    property Validators: TO32Validators
      read FValidators
      write FValidators;
  end;

implementation

uses
  Windows, SysUtils, Controls, Dialogs;

{===== TO32ValidatorPool =============================================}

constructor TO32ValidatorPool.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FValidators := TO32Validators.Create(self, TO32ValidatorItem);
end;
{=====}

destructor TO32ValidatorPool.Destroy;
begin
  FValidators.Free;
  inherited Destroy;
end;


{===== TO32Validators ================================================}
constructor TO32Validators.Create(AOwner : TPersistent;
                                  ItemClass : TCollectionItemClass);
begin
  inherited;
  FValidatorPool := TO32ValidatorPool(AOwner);
end;
{=====}

function TO32Validators.GetValidatorByName(const Name: String): TO32BaseValidator;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    if TO32ValidatorItem(Items[i]).Name = Name then begin
      result := TO32ValidatorItem(Items[i]).Validator;
      exit;
    end;
  end;
  result := nil;
end;
{=====}

function TO32Validators.AddItem(ValidatorClass: TValidatorClass):
  TCollectionItem;
var
  NewItem: TO32ValidatorItem;
begin
  NewItem := TO32ValidatorItem(inherited Add);
  NewItem.ValidatorClass := ValidatorClass;
  NewItem.Validator := ValidatorClass.Create(FValidatorPool);
  result := NewItem;
end;
{=====}

procedure TO32Validators.Delete(Index: Integer);
begin
  TO32ValidatorItem(Items[Index]).Validator.Free;
    inherited Delete(Index);
end;
{=====}

procedure TO32Validators.DeleteByName(const Name: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    if TO32ValidatorItem(Items[i]).Name = Name then begin
      TO32ValidatorItem(Items[i]).Validator.Free;
        inherited Delete(i);
      exit;
    end;
  end;
end;
{=====}

function TO32Validators.GetItem(Index : Integer) : TO32ValidatorItem;
begin
  result := TO32ValidatorItem(inherited GetItem(Index));
end;

{===== TO32ValidatorItem =============================================}
type
  TProtectedCustomEdit = class(TCustomEdit);
  TProtectedWinControl = class(TWinControl);

constructor TO32ValidatorItem.Create(Collection: TCollection);
begin
  inherited;
  SetName('ValidatorItem' + IntToStr(Collection.Count));
  FErrorColor  := clRed;
  FBeepOnError := true;
end;
{=====}

procedure TO32ValidatorItem.DoValidation(Sender: TObject);
begin
  if not (csDesigning in ValidatorPool.ComponentState)
  and (FValidator <> nil) then begin
    { set the validator's values }
    FValidator.Mask := FMask;
    FValidator.Input := FComponent.Text;
    { execute validation }
    if not FValidator.IsValid then begin
      { beep or not }
      if BeepOnError then MessageBeep(0);
      TProtectedCustomEdit(FComponent).Color := FErrorColor;
      FComponent.SetFocus;
    end
    else
      if (FComponent is TCustomEdit) then
        TProtectedCustomEdit(FComponent).Color := FComponentColor;
  end;
end;

procedure TO32ValidatorItem.SetComponent(Value: TCustomEdit);
begin
  if (Value is TCustomEdit) and (FComponent <> Value) then begin
    FComponent := Value;
    FComponentColor := TProtectedCustomEdit(FComponent).Color;
    AssignEvent;
  end;
end;
{=====}

procedure TO32ValidatorItem.SetEvent(Event: TValidationEvent);
begin
  FEvent := Event;
  AssignEvent;
end;
{=====}

procedure TO32ValidatorItem.AssignEvent;
begin
  if (FComponent <> nil) then
    case FEvent of
      veOnChange:
        TProtectedCustomEdit(FComponent).OnChange := DoValidation;
      veOnEnter :
        TProtectedCustomEdit(FComponent).OnEnter  := DoValidation;
      veOnExit  :
        TProtectedCustomEdit(FComponent).OnExit   := DoValidation;
    end;
end;
{=====}

procedure TO32ValidatorItem.SetValidatorType(const Value: string);
begin
  if FValidatorType <> Value then begin
    FValidatorType := Value;
    AssignValidator;
  end;
end;
{=====}

procedure TO32ValidatorItem.AssignValidator;
begin
  if (FValidatorType = 'None') or (FValidatorType = '')then
    FValidatorClass := nil
  else try
    FValidatorClass := TValidatorClass(FindClass(FValidatorType));
  except
    FValidatorClass := nil;
  end;

  if FValidatorClass <> nil then
    FValidator
      := FValidatorClass.Create((Collection as TO32Validators).FValidatorPool);
end;
{=====}

function TO32ValidatorItem.ValidatorPool: TO32ValidatorPool;
begin
  Result := TO32Validators(Collection).FValidatorPool;
end;
{=====}

end.

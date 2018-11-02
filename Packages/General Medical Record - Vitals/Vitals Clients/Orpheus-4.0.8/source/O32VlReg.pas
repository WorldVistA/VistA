{*********************************************************}
{*                    O32VLREG.PAS 4.06                  *}
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

unit o32vlreg;
  {Registration unit for the Orpheus Validator components.}

interface

uses
  Classes, O32Vldtr;

var
  ValidatorList: TStrings;

procedure RegisterValidator(ValidatorClass: TValidatorClass);
procedure UnRegisterValidator(ValidatorClass: TValidatorClass);
procedure GetRegisteredValidators(aList: TStrings);

implementation

procedure RegisterValidator(ValidatorClass: TValidatorClass);
begin
  if ValidatorClass.InheritsFrom(TO32BaseValidator) then begin
    if ValidatorList.IndexOf(ValidatorClass.ClassName) = -1 then begin
      RegisterClass(TPersistentClass(ValidatorClass));
      ValidatorList.Add(ValidatorClass.ClassName);
    end;
  end;
end;
{=====}

procedure UnRegisterValidator(ValidatorClass: TValidatorClass);
var
  i: Integer;
begin
  i := ValidatorList.IndexOf(ValidatorClass.ClassName);
  if i > -1 then begin
    ValidatorList.Delete(i);
    UnRegisterClass(TPersistentClass(ValidatorClass));
  end;
end;
{=====}

procedure GetRegisteredValidators(aList: TStrings);
begin
  Assert(Assigned(ValidatorList));
  Assert(Assigned(aList));

  aList.Clear;
  aList.BeginUpdate;
  aList.Assign(ValidatorList);
  aList.EndUpdate;
end;

initialization

  ValidatorList := TStringList.Create;
  ValidatorList.Add('None');


finalization

  ValidatorList.Free;

end.

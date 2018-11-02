{*********************************************************}
{*                  OVCFXFPE.PAS 4.06                    *}
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

unit ovcfxfpe;
  {-Fixed font property editors}

interface

uses
  Classes, Graphics, Controls, Forms, Dialogs, SysUtils, TypInfo, DesignIntf, DesignEditors,
  OvcFxFnt;

type
  {fixed font name property editor}
  TOvcFixFontNameProperty = class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes;
      override;
    procedure GetValues(Proc : TGetStrProc);
      override;
  end;

  {fixed font property editor}
  TOvcFixFontProperty = class(TClassProperty)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
  end;


implementation


{*** TOvcFixFontNameProperty ***}

function TOvcFixFontNameProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TOvcFixFontNameProperty.GetValues(Proc : TGetStrProc);
var
  i : integer;
begin
  for i := 0 to pred(FixedFontNames.Count) do
    Proc(FixedFontNames[i]);
end;


{*** TOvcFixFontProperty ***}

procedure TOvcFixFontProperty.Edit;
var
  FF : TOvcFixedFont;
  FontDialog : TFontDialog;
begin
  FontDialog := nil;
  FF := nil;
  try
    FontDialog := TFontDialog.Create(Application);
    FF := TOvcFixedFont.Create;
    FF.Assign(TOvcFixedFont(GetOrdValue));
    FontDialog.Font := FF.Font;
    FontDialog.Options :=
        FontDialog.Options + [fdForceFontExist, fdFixedPitchOnly];
    if FontDialog.Execute then begin
      FF.Font.Assign(FontDialog.Font);
      SetOrdValue(NativeInt(FF));
    end;
  finally
    FontDialog.Free;
    FF.Free;
  end;
end;

function TOvcFixFontProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paMultiSelect, paSubProperties, paDialog, paReadOnly];
end;


end.

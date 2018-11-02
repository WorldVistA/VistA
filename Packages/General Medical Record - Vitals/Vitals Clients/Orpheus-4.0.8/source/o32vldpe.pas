{*********************************************************}
{*                    O32VLDPE.PAS 4.06                  *}
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

unit o32vldpe;
  {-Expression property editor for the Validators}

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons, StdCtrls,
  DesignIntf, DesignEditors, SysUtils, ExtCtrls, OvcConst, OvcData, OvcExcpt,
  OvcMisc, OvcStr, Dialogs, O32Vldtr, O32VlOP1;

type
  TTO32FrmValidatorExpression = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblMask: TLabel;
    lblMaskEdit: TLabel;
    Bevel1: TBevel;
    lblMaskDescription: TLabel;
    lblMaskList: TLabel;
    lbMask: TListBox;
    edMask: TEdit;
    procedure lbMaskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected { Private declarations }
    Ex    : TStringList;
  end;

type
  {property editor for picture masks}
  TSampleMaskProperty = class(TStringProperty)
  private
    ValType: string;
  public
    function GetAttributes: TPropertyAttributes; override;
    function AllEqual: Boolean; override;
    procedure Edit; override;
  end;


implementation


uses
  O32RXVld, O32VPool;

{$R *.DFM}


{*** TPictureMaskProperty ***}

function TSampleMaskProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect]
end;

function TSampleMaskProperty.AllEqual: Boolean;
begin
  Result := True;
end;

type
  ProtectedValOp = class(TValidatorOptions);

procedure TSampleMaskProperty.Edit;
var
  Form       : TTO32FrmValidatorExpression;
  I, J       : Integer;
  Mask       : string;
  C          : TObject;
  V          : TO32BaseValidator;
  S1         : string;
  S          : string;
  StringList : TStringList;
  ValClass   : TValidatorClass;
begin
  V := nil;
  C := nil;
  Form := TTO32FrmValidatorExpression.Create(Application);
  try
    with Form do begin
      C := TObject(GetComponent(0));
      { Base Validator calling }
      if C is TO32BaseValidator then begin
        V := (C as TO32BaseValidator);
        if V <> nil then begin
          ValType := (C as TO32BaseValidator).ClassName;
          Mask := TO32RegexValidator(C).Mask;
        end;
      end
      { ValidatorOptions class calling}
      else if C is TValidatorOptions then begin
        try
          ValClass :=
            TValidatorClass(FindClass((C as TValidatorOptions).ValidatorType));
        except
          ValClass := nil;
        end;
        if ValClass <> nil then begin
          { Create a validator so that we can access its sample masks. }
          { We will destroy it later.                                  }
          V := ValClass.Create(ProtectedValOp(C).FOwner);
          ValType := (C as TValidatorOptions).ValidatorType;
          Mask := TValidatorOptions(C).Mask;
        end;
      end
      { ValidatorItem calling }
      else if C is TO32ValidatorItem then begin
        V := (C as TO32ValidatorItem).Validator;
        if V <> nil then begin
          ValType := V.ClassName;
          Mask := TO32ValidatorItem(C).Mask;
        end;
      end
      else Mask := '';

      J := -1;

      { Set form captions }
      if ValType = 'TO32RegexValidator' then begin
        LblMaskEdit.Caption := 'Regular Expression';
        Caption := 'Sample Regular Expressions';
      end
      else if ValType = 'TO32ParadoxValidator' then begin
        LblMaskEdit.Caption := 'Paradox Mask';
        Caption := 'Sample Paradox Masks';
      end
      else if ValType = 'TO32OrMaskValidator' then begin
        LblMaskEdit.Caption := 'Orpheus Mask';
        Caption := 'Sample Orpheus Masks';
      end
      else begin
        LblMaskEdit.Caption := 'Validator Mask';
        if V <> nil then
          Caption := 'Sample Masks for the '
            + (V as TO32BaseValidator).ClassName
        else
          Caption := 'Sample Masks';
      end;

      { load sample masks from the resource file depending on the type of }
      { validator }

      if V <> nil then begin
        StringList := V.SampleMasks;
        for I := 0 to StringList.Count - 1 do begin
          { first SampleMaskLength characters is the sample mask -- the     }
          { remaining part of the string is a short description of the mask }
          S := StringList[I];
          { trim the left portion and add it to the combo box            }
          S1 := Trim(Copy(S, 1, V.SampleMaskLength));
          Form.lbMask.Items.Add(S1);
          { take the remaining portion of the string, trim it and        }
          { add it to the string list                                    }
          S := Trim(Copy(S, V.SampleMaskLength + 1, 255));
          Form.Ex.Add(S);
        end;

        {if only one field is selected select the combo box item}
        {that corresponds to the current mask character}
        if PropCount = 1 then begin
          with Form.lbMask do begin
            for I := 0 to Items.Count-1 do begin
              if Items[I] = Mask then begin
                J := I;
                Break;
              end;
            end;
          end;
        end else Mask := '';

        {show current mask at top of combo box list}
        edMask.Text := Mask;

        {set explanation text, if any}
        if J >= 0 then begin
          lbMask.ItemIndex := J;
          lblMask.Caption := Ex.Strings[J]
        end else
          lblMask.Caption := '';

        {show the form}
        ShowModal;

        if ModalResult = idOK then begin
          {update all selected components with new mask}
          for I := 1 to PropCount do begin
            C := TComponent(GetComponent(I-1));
            if C is TO32RegexValidator then
              (C as TO32RegexValidator).Expression := edMask.Text
            else if C is TValidatorOptions then
              (C as TValidatorOptions).Mask := edMask.Text
            else if C is TO32ValidatorItem then
              (C as TO32ValidatorItem).Mask := edMask.Text
            else if C is TO32BaseValidator then
              (C as TO32BaseValidator).Mask := edMask.Text;
          end;
          Modified;
        end;
      end;
    end;
  finally
    Form.Free;
    { If we had to temporarily create a validator, then we destroy it here. }
    if (C <> nil) and (C is TValidatorOptions) and (V <> nil) then V.Free;
  end;
end;


{*** TfrmPictureMask ***}

procedure TTO32FrmValidatorExpression.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  {create string list for the mask explanation strings}
  Ex    := TStringList.Create;
end;

procedure TTO32FrmValidatorExpression.lbMaskClick(Sender: TObject);
var
  I : Integer;
begin
  I := lbMask.ItemIndex;
  if (I >= 0) and (I < Ex.Count) then begin
    lblMask.Caption := Ex.Strings[I];
    edMask.Text := lbMask.Items[I];
  end else
    lblMask.Caption := '';
end;

procedure TTO32FrmValidatorExpression.FormDestroy(Sender: TObject);
begin
  {destroy string list}
  Ex.Free;
end;

end.

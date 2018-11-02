{*********************************************************}
{*                   OVCSFPE.PAS 4.06                    *}
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

unit OvcSfPe;
  {-Simple field property editor}

interface

uses
  Windows, Buttons, Classes, Controls, DesignIntf, DesignEditors, Graphics, Forms,
  StdCtrls, SysUtils, OvcConst, OvcData, OvcMisc;

type
  TOvcfrmSimpleMask = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cbxMaskCharacter: TComboBox;
    lblPictureChars: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbxMaskCharacterChange(Sender: TObject);
  protected
    { Private declarations }
    Mask : Char;
  end;

type
  {property editor for picture mask}
  TSimpleMaskProperty = class(TCharProperty)
  public
    function GetAttributes: TPropertyAttributes;
      override;
    function AllEqual: Boolean;
      override;
    procedure Edit;
      override;
  end;


implementation


uses
  OvcSf, OvcAe, OvcTCSim;

{$R *.DFM}

procedure TOvcfrmSimpleMask.FormCreate(Sender: TObject);
var
  I : Word;
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  {load mask character strings}
  for I := stsmFirst to stsmLast do
    cbxMaskCharacter.Items.Add(GetOrphStr(I));
end;

procedure TOvcfrmSimpleMask.cbxMaskCharacterChange(Sender: TObject);
var
  I : Integer;
  S : string;

begin
  {return the mask character}
  with cbxMaskCharacter do begin
    S := AnsiUpperCase(Text);
    if S > '' then
      for I := 0 to Items.Count-1 do
        if AnsiUpperCase(Copy(Items[I], 1, MinI(Length(S), Length(Items[I]))))
          = S then
        begin
          ItemIndex := I;
          Break;
        end;
    if ItemIndex > -1 then
      Mask := Items[ItemIndex][1]
  end;
end;


{*** TSimpleMaskProperty ***}

type
  TLocalSF = class(TOvcCustomSimpleField);

function TSimpleMaskProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect]
end;

function TSimpleMaskProperty.AllEqual: Boolean;
begin
  Result := True;
end;

procedure TSimpleMaskProperty.Edit;
var
  SfPE : TOvcfrmSimpleMask;
  I, J : Integer;
  C    : TComponent;
begin
  SfPE := TOvcfrmSimpleMask.Create(Application);
  try
    C := TComponent(GetComponent(0));
    if C is TOvcCustomSimpleField then
      SfPE.Mask := TLocalSF(C).PictureMask
    else if C is TOvcSimpleArrayEditor then
      SfPE.Mask := TOvcSimpleArrayEditor(C).PictureMask
    else if C is TOvcTCSimpleField then
      SfPE.Mask := TOvcTCSimpleField(C).PictureMask;

    J := -1;

    {if only one field is selected select the combo box item}
    {that corresponds to the current mask character}
    if PropCount = 1 then begin
      with SfPE.cbxMaskCharacter do begin
        for I := 0 to Items.Count-1 do begin
          if Items[I][1] = SfPE.Mask then begin
            J := I;
            Break;
          end;
        end;
        ItemIndex := J;
      end;
    end;

    {show the form}
    SfPE.ShowModal;

    if SfPe.ModalResult = idOK then begin
      {update all selected components with new mask}
      for I := 1 to PropCount do begin
        C := TComponent(GetComponent(I-1));
        if C is TOvcCustomSimpleField then
          TLocalSF(C).PictureMask := SfPE.Mask
        else if C is TOvcSimpleArrayEditor then
          TOvcSimpleArrayEditor(C).PictureMask := SfPE.Mask
        else if C is TOvcTCSimpleField then
          TOvcTCSimpleField(C).PictureMask := SfPE.Mask;
      end;
      Modified;
    end;
  finally
    SfPE.Free;
  end;
end;

end.

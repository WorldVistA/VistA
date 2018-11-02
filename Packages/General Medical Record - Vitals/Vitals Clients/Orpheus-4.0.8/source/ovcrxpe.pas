{*********************************************************}
{*                   OVCRXPE.PAS 4.06                    *}
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

unit ovcrxpe;
  {-Property editor for the Regular Expression Validator component}

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Buttons, StdCtrls,
  DesignIntf, DesignEditors,
  SysUtils, ExtCtrls, OvcRxVld,
  OvcConst,
  OvcData,
  OvcExcpt,
  OvcMisc,
  OvcStr
  ;

type
  TOvcfrmRegexEditor = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblMask: TLabel;
    lblExpressionEdit: TLabel;
    Bevel1: TBevel;
    lblExpressionDesc: TLabel;
    lblExpressionList: TLabel;
    lbMask: TListBox;
    edExpression: TEdit;
    BtnHelp: TButton;
    procedure lbMaskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    { Private declarations }
    Ex : TStringList;
  end;

type
  {property editor for regular expressions}
  TRegexProperty = class(TStringProperty)
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
  OvcPf, OvcAe, OvcTCPic, OvcPLb;

{$R *.DFM}


{*** TRegexProperty ***}

type
  TLocalRXValidator = class(TOvcRegexValidator);

function TRegexProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paMultiSelect]
end;

function TRegexProperty.AllEqual: Boolean;
begin
  Result := True;
end;

procedure TRegexProperty.Edit;
var
  RxPE : TOvcfrmRegexEditor;
  I, J : Integer;
  Regex : string;
  C    : TComponent;
begin
  RxPE := TOvcfrmRegexEditor.Create(Application);
  try
    with RxPE do begin
      C := TComponent(GetComponent(0));
      if C is TOvcRegexValidator then
        Regex := TLocalRXValidator(C).Expression;

      J := -1;

      {if only one field is selected select the combo box item}
      {that corresponds to the current mask character}
      if PropCount = 1 then begin
        with RxPE.lbMask do begin
          for I := 0 to Items.Count-1 do begin
            if Items[I] = Regex then begin
              J := I;
              Break;
            end;
          end;
        end;
      end else
        Regex := '';

      {show current mask at top of combo box list}
      edExpression.Text := Regex;

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
          if C is TOvcCustomPictureField then
            TLocalRXValidator(C).Expression := edExpression.Text
          else if C is TOvcPictureArrayEditor then
            TOvcPictureArrayEditor(C).PictureMask := edExpression.Text
          else if C is TOvcTCPictureField then
            TOvcTCPictureField(C).PictureMask := edExpression.Text
          else if C is TOvcPictureLabel then
            TOvcPictureLabel(C).PictureMask := edExpression.Text;
        end;
        Modified;
      end;
    end;
  finally
    RxPE.Free;
  end;
end;


{*** TOvcfrmRegexEditor ***}

procedure TOvcfrmRegexEditor.FormCreate(Sender: TObject);
var
  I    : Word;
  S1   : string;
  S    : string;
const
  ExpressionLen = 90;
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  {create a string list for the mask explanation strings}
  Ex := TStringList.Create;

  {load the picture mask strings from the resource file}
  for I := strxFirst to strxLast do begin
    {first ExpressionLen characters is the sample expression--remaining part}
    {of the string is a short description of the expression}
    S := GetOrphStr(I);

    {trim the left portion and add it to the combo box}
    S1 := Trim(Copy(S, 1, ExpressionLen));
    lbMask.Items.Add(S1);

    {take the remaining portion of the string, trim it and}
    {add it to the string list}
    S := Trim(Copy(S, ExpressionLen + 1, 255));
    Ex.Add(S);
  end;
end;

procedure TOvcfrmRegexEditor.lbMaskClick(Sender: TObject);
var
  I : Integer;
begin
  I := lbMask.ItemIndex;
  if (I >= 0) and (I < Ex.Count) then begin
    lblMask.Caption := Ex.Strings[I];
    edExpression.Text := lbMask.Items[I];
  end else
    lblMask.Caption := '';
end;

procedure TOvcfrmRegexEditor.FormDestroy(Sender: TObject);
begin
  {destroy string list}
  Ex.Free;
end;


end.

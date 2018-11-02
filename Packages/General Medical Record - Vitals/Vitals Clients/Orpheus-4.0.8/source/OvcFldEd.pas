{*********************************************************}
{*                   OVCFLDED.PAS 4.06                   *}
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

unit ovcflded;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, OvcRptVw, OvcBase, OvcCmbx;

type
  TfrmOvcRvFldEd = class(TForm)
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Panel6: TPanel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtExpression: TEdit;
    cbxField: TOvcComboBox;
    cbxOp: TOvcComboBox;
    cbxFunc: TOvcComboBox;
    Label1: TLabel;
    edtName: TEdit;
    edtCaption: TEdit;
    edtHint: TEdit;
    Label3: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ComboBox1: TOvcComboBox;
    Label12: TLabel;
    Label13: TLabel;
    edtWidth: TEdit;
    edtPrintWidth: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnNewField: TButton;
    btnDelete: TButton;
    Label14: TLabel;
    Label15: TLabel;
    procedure btnNewFieldClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxFieldClick(Sender: TObject);
    procedure cbxOpClick(Sender: TObject);
    procedure cbxFuncClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
  private
    FEditField : TOvcRvField;
    procedure SelectField(const FieldName: string);
    procedure SetEditField(const Value: TOvcRvField);
    { Private declarations }
  public
    { Public declarations }
    EditReportView : TOvcCustomReportView;
    procedure PopulateList;
    procedure PopulateFieldCombo;
    property EditField: TOvcRvField read FEditField write SetEditField;
  end;

implementation

{$R *.DFM}

procedure TfrmOvcRvFldEd.PopulateList;
var
  i: Integer;
begin
  ListBox1.Clear;
  for i := 0 to pred(EditReportView.Fields.Count) do
    if EditReportView.Field[i].Expression <> '' then
      ListBox1.Items.AddObject(EditReportView.Field[i].Name, EditReportView.Field[i]);
end;

procedure TfrmOvcRvFldEd.PopulateFieldCombo;
var
  i: Integer;
  F: TOvcRvField;
begin
  cbxField.Items.Clear;
  for i := 0 to pred(EditReportView.Fields.Count) do begin
    F := TOvcRvField(EditReportView.Fields[i]);
    if not F.NoDesign then
      cbxField.Items.Add(' ' + F.Name + ' ');
  end;
end;

procedure TfrmOvcRvFldEd.SelectField(const FieldName: string);
begin
  ListBox1.ItemIndex := ListBox1.Items.IndexOf(FieldName);
  ListBox1Click(nil);
end;

procedure TfrmOvcRvFldEd.btnNewFieldClick(Sender: TObject);
begin
  EditField := nil;
  with EditReportView.Fields.Add do begin
    Name := 'New_Field';
    Expression := '''New Field''';
  end;
  PopulateList;
  PopulateFieldCombo;
  SelectField('New_Field');
end;

procedure TfrmOvcRvFldEd.ListBox1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex <> -1 then begin
    EditField := TOvcRvField(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  end else
    EditField := nil;
end;

procedure TfrmOvcRvFldEd.SetEditField(const Value: TOvcRvField);
begin
  if FEditField <> nil then
    with EditField do begin
      Name := edtName.Text;
      Caption := edtCaption.Text;
      Hint := edtHint.Text;
      Alignment := TAlignment(ComboBox1.ItemIndex);
      DefaultWidth := StrToInt(edtWidth.Text);
      DefaultPrintWidth := StrToInt(edtPrintWidth.Text);
      //FormatMask := edtFormat.Text;
      Expression := edtExpression.Text;
      try
        ValidateExpression;
      except
        edtExpression.SetFocus;
        raise;
      end;
    end;
  FEditField := Value;
  if FEditField <> nil then begin
    with EditField do begin
      edtName.Text := Name;
      edtName.Enabled := not InUse;
      edtCaption.Text := Caption;
      edtHint.Text := Hint;
      ComboBox1.ItemIndex := ord(Alignment);
      edtWidth.Text := IntToStr(DefaultWidth);
      edtPrintWidth.Text := IntToStr(DefaultPrintWidth);
      edtExpression.Text := Expression;
      //edtFormat.Text := FormatMask;
    end;
    btnDelete.Enabled := True;
  end else begin
    edtName.Text := '';
    edtCaption.Text := '';
    edtHint.Text := '';
    ComboBox1.ItemIndex := 0;
    edtWidth.Text := '50';
    edtPrintWidth.Text := '1440';
    edtExpression.Text := '';
    //edtFormat.Text := '';
    btnDelete.Enabled := False;
  end;
end;

procedure TfrmOvcRvFldEd.btnOKClick(Sender: TObject);
begin
  EditField := nil;
  ModalResult := mrOK;
end;

procedure TfrmOvcRvFldEd.cbxFieldClick(Sender: TObject);
begin
  if cbxField.ItemIndex <> -1 then begin
    edtExpression.SelText := cbxField.Items[cbxField.ItemIndex];
    edtExpression.SetFocus;
    edtExpression.SelStart := length(edtExpression.Text);
    edtExpression.SelLength := 0;
    cbxField.ItemIndex := -1;
  end;
end;

procedure TfrmOvcRvFldEd.cbxOpClick(Sender: TObject);
begin
  if cbxOp.ItemIndex <> -1 then begin
    edtExpression.SelText := cbxOp.Items[cbxOp.ItemIndex];
    edtExpression.SetFocus;
    edtExpression.SelStart := length(edtExpression.Text);
    edtExpression.SelLength := 0;
    cbxOp.ItemIndex := -1;
  end;
end;

procedure TfrmOvcRvFldEd.cbxFuncClick(Sender: TObject);
begin
  if cbxFunc.ItemIndex <> -1 then begin
    edtExpression.SelText := cbxFunc.Items[cbxFunc.ItemIndex];
    edtExpression.SetFocus;
    edtExpression.SelStart := length(edtExpression.Text);
    edtExpression.SelLength := 0;
    cbxFunc.ItemIndex := -1;
  end;
end;

procedure TfrmOvcRvFldEd.btnDeleteClick(Sender: TObject);
var
  Tmp : TOvcRvField;
begin
  if EditField.InUse then
    raise Exception.Create('The field is in use by a view or another field expression - it cannot be deleted');
  Tmp := EditField;
  EditField := nil;
  Tmp.Free;
  PopulateList;
  PopulateFieldCombo;
end;

procedure TfrmOvcRvFldEd.edtNameExit(Sender: TObject);
begin
  if FEditField <> nil then
    with EditField do begin
      Name := edtName.Text;
    end;
  PopulateList; {name changed}
end;

end.

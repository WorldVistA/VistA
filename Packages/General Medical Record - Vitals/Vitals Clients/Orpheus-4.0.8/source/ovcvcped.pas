
{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
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

{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{*********************************************************}
{*                  OVCVCPED.PAS 4.06                    *}
{*********************************************************}

unit ovcvcped;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, OvcBase, OvcEF, OvcPB, OvcNF, OvcRptVw, ExtCtrls,
  OvcCmbx;

type
  TfrmViewCEd = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    ListBox1: TListBox;
    chkTotals: TCheckBox;
    chkGroupBy: TCheckBox;
    chkShowHint: TCheckBox;
    chkAllowResize: TCheckBox;
    edtWidth: TEdit;
    edtPrintWidth: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    cbxMeasure: TComboBox;
    Bevel1: TBevel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    edtAgg: TEdit;
    Label6: TLabel;
    cbxField: TOvcComboBox;
    Label7: TLabel;
    cbxOp: TOvcComboBox;
    Label8: TLabel;
    cbxFunc: TOvcComboBox;
    Bevel3: TBevel;
    procedure ListBox1Click(Sender: TObject);
    procedure chkTotalsClick(Sender: TObject);
    procedure edtWidthChange(Sender: TObject);
    procedure edtPrintWidthChange(Sender: TObject);
    procedure chkShowHintClick(Sender: TObject);
    procedure chkAllowResizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbxMeasureChange(Sender: TObject);
    procedure cbxFieldClick(Sender: TObject);
    procedure cbxOpClick(Sender: TObject);
    procedure cbxFuncClick(Sender: TObject);
    procedure edtAggChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    InLoad: Boolean;
    function CurrentToTwips(const S: string): Integer;
    function TwipsToCurrent(T: Integer): string;
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

function TwipsToPoints(T: Integer): double;
begin
  Result := T / 20;
end;

function TwipsToInches(T: Integer): double;
begin
  Result := T / 1440;
end;

function TwipsToCMs(T: Integer): double;
begin
  Result := TwipsToInches(T) * 2.54;
end;

function PointsToTwips(P: double): Integer;
begin
  Result := round(P * 20);
end;

function InchesToTwips(I: double): Integer;
begin
  Result := round(I * 1440);
end;

function CMsTOTwips(C: double): Integer;
begin
  Result := InchesToTwips(C / 2.54);
end;

function TfrmViewCEd.TwipsToCurrent(T: Integer): string;
begin
  case cbxMeasure.ItemIndex of
  0 : // twips
    Result := IntToStr(T);
  1 : // inches
    Result := FloatToStrF(TwipsToInches(T), ffFixed, 6, 3);
  2 : // CMs
    Result := FloatToStrF(TwipsToCMs(T), ffFixed, 5, 2);
  else//3 : // points
    Result := FloatToStrF(TwipsToPoints(T), ffFixed, 4, 1);
  end;
end;

function TfrmViewCEd.CurrentToTwips(const S: string): Integer;
begin
  case cbxMeasure.ItemIndex of
  0 : // twips
    Result := StrToInt(S);
  1 : // inches
    Result := InchesToTwips(StrToFloat(S));
  2 : // CMs
    Result := CMsToTwips(StrToFloat(S));
  else//3 : // Points
    Result := PointsToTwips(StrToFloat(S));
  end;
end;

procedure TfrmViewCEd.ListBox1Click(Sender: TObject);
var
  i : Integer;
  TAllowResize,
  TGroupBy, TShowHint, TTotals, AnyGrouped : Boolean;
  TWidth, TPrintWidth: Integer;
  TAgg: string;
begin
  InLoad := True;
  try
    TGroupBy := True;
    TShowHint := True;
    TAllowResize := True;
    TTotals := True;
    TWidth := -1;
    TPrintWidth := -1;
    TAgg := '<empty>';
    AnyGrouped := False;
    for i := 0 to pred(ListBox1.Items.Count) do
      if ListBox1.Selected[i] then begin
        with TOvcRvViewField(ListBox1.Items.Objects[i]) do begin
          TGroupBy := TGroupBy and GroupBy;
          AnyGrouped := AnyGrouped or GroupBy;
          TShowHint := TShowHint and ShowHint;
          TAllowResize := TAllowResize and AllowResize;
          TTotals := TTotals and ComputeTotals;
          if TWidth = -1 then
            TWidth := Width
          else
            if Width <> TWidth then
              TWidth := -2;
          if TPrintWidth = -1 then
            TPrintWidth := PrintWidth
          else
            if PrintWidth <> TPrintWidth then
              TPrintWidth := -2;
          if TAgg = '<empty>' then
            TAgg := Aggregate
          else
            if TAgg = Aggregate then
            else
              TAgg := '<diff>';
        end;
      end;
    chkGroupBy.Checked := TGroupBy;
    chkTotals.Checked := TTotals;
    chkShowHint.Checked := TShowHint;
    chkAllowResize.Checked := TAllowResize;
    chkTotals.Enabled := not AnyGrouped;
    chkShowHint.Enabled := not AnyGrouped;
    if TWidth >= 0 then
      edtWidth.Text := IntToStr(TWidth)
    else
      edtWidth.Text := '';
    if TPrintWidth >= 0 then
      edtPrintWidth.Text := TwipsToCurrent(TPrintWidth)
    else
      edtPrintWidth.Text := '';
    if TAgg <> '<diff>' then begin
      if TAgg <> '<empty>' then
        edtAgg.Text := TAgg
      else
        edtAgg.Text := '';
      edtAgg.Enabled := True;
      cbxField.Enabled := True;
      cbxOp.Enabled := True;
      cbxFunc.Enabled := True;
    end else begin
      edtAgg.Text := '';
      edtAgg.Enabled := False;
      cbxField.Enabled := False;
      cbxOp.Enabled := False;
      cbxFunc.Enabled := False;
    end;
  finally
    InLoad := False;
  end;
end;

procedure TfrmViewCEd.chkTotalsClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with TOvcRvViewField(ListBox1.Items.Objects[i]) do
        ComputeTotals := chkTotals.Checked and not GroupBy;
    end;
end;

procedure TfrmViewCEd.edtWidthChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with TOvcRvViewField(ListBox1.Items.Objects[i]) do
        if edtWidth.Text <> '' then
          Width := StrToInt(edtWidth.Text);
    end;
end;

procedure TfrmViewCEd.edtPrintWidthChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with TOvcRvViewField(ListBox1.Items.Objects[i]) do
        if edtPrintWidth.Text <> '' then
          PrintWidth := CurrentToTwips(edtPrintWidth.Text);
    end;
end;

procedure TfrmViewCEd.chkShowHintClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with TOvcRvViewField(ListBox1.Items.Objects[i]) do
        ShowHint := chkShowHint.Checked and not GroupBy;
    end;
end;

procedure TfrmViewCEd.chkAllowResizeClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with TOvcRvViewField(ListBox1.Items.Objects[i]) do
        AllowResize := chkAllowResize.Checked;
    end;
end;

procedure TfrmViewCEd.FormShow(Sender: TObject);
begin
  cbxMeasure.ItemIndex := 0;
end;

procedure TfrmViewCEd.cbxMeasureChange(Sender: TObject);
begin
  Listbox1Click(nil);
end;

procedure TfrmViewCEd.cbxFieldClick(Sender: TObject);
begin
  if cbxField.ItemIndex <> -1 then begin
    edtAgg.SelText := cbxField.Items[cbxField.ItemIndex];
    edtAgg.SetFocus;
    edtAgg.SelStart := length(edtAgg.Text);
    edtAgg.SelLength := 0;
    cbxField.ItemIndex := -1;
  end;
end;

procedure TfrmViewCEd.cbxOpClick(Sender: TObject);
begin
  if cbxOp.ItemIndex <> -1 then begin
    edtAgg.SelText := cbxOp.Items[cbxOp.ItemIndex];
    edtAgg.SetFocus;
    edtAgg.SelStart := length(edtAgg.Text);
    edtAgg.SelLength := 0;
    cbxOp.ItemIndex := -1;
  end;
end;

procedure TfrmViewCEd.cbxFuncClick(Sender: TObject);
begin
  if cbxFunc.ItemIndex <> -1 then begin
    edtAgg.SelText := cbxFunc.Items[cbxFunc.ItemIndex];
    edtAgg.SetFocus;
    edtAgg.SelStart := length(edtAgg.Text);
    edtAgg.SelLength := 0;
    cbxFunc.ItemIndex := -1;
  end;
end;

procedure TfrmViewCEd.edtAggChange(Sender: TObject);
var
  i : Integer;
begin
  if InLoad then exit;
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then
      TOvcRvViewField(ListBox1.Items.Objects[i]).Aggregate := edtAgg.Text;
end;

procedure TfrmViewCEd.btnOkClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to pred(Listbox1.Items.Count) do
    {check aggregate expressions for validity}
    if TOvcRvViewField(ListBox1.Items.Objects[i]).Aggregate <> '' then
      TOvcRvViewField(ListBox1.Items.Objects[i]).AggExp;
  ModalResult := mrOK;
end;

end.


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
{*                  OVCRVPED.PAS 4.06                    *}
{*********************************************************}

unit ovcrvped;
{-view property editor for the report view component}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, OvcBase, OvcEF, OvcPB, OvcNF;

type
  TRVCmpEd2 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    chkShowHeader: TCheckBox;
    chkShowFooter: TCheckBox;
    chkShowGroupTotals: TCheckBox;
    ListBox1: TListBox;
    Label1: TLabel;
    chkTotals: TCheckBox;
    ChkOwnerDraw: TCheckBox;
    edtWidth: TOvcNumericField;
    edtPrintWidth: TOvcNumericField;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    Label2: TLabel;
    edtFilterIndex: TOvcNumericField;
    chkGroupBy: TCheckBox;
    edtTag: TOvcNumericField;
    edtColTag: TOvcNumericField;
    chkShowGroupCounts: TCheckBox;
    chkShowHint: TCheckBox;
    chkDescending: TCheckBox;
    chkAllowResize: TCheckBox;
    chkHidden: TCheckBox;
    chkVisible: TCheckBox;
    cbxSortDir: TComboBox;
    Label3: TLabel;
    edtFilterExp: TEdit;
    Label4: TLabel;
    edtAgg: TEdit;
    Label5: TLabel;
    cbxDefaultSort: TComboBox;
    Label6: TLabel;
    procedure ListBox1Click(Sender: TObject);
    procedure chkTotalsClick(Sender: TObject);
    procedure ChkOwnerDrawClick(Sender: TObject);
    procedure edtWidthChange(Sender: TObject);
    procedure edtPrintWidthChange(Sender: TObject);
    procedure edtColTagChange(Sender: TObject);
    procedure chkShowHintClick(Sender: TObject);
    procedure chkAllowResizeClick(Sender: TObject);
    procedure chkVisibleClick(Sender: TObject);
    procedure cbxSortDirChange(Sender: TObject);
    procedure edtAggExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation
uses
  OvcRvCEd;

{$R *.DFM}

procedure TRVCmpEd2.ListBox1Click(Sender: TObject);
var
  i : Integer;
  TAllowResize,
  TVisible,
  TGroupBy, TOwnerDraw, TShowHint, TTotals, AnyGrouped : Boolean;
  TSortDir, TWidth, TPrintWidth, TTag : Integer;
  TAgg: string;
begin
  TGroupBy := True;
  TOwnerDraw := True;
  TShowHint := True;
  TAllowResize := True;
  TTotals := True;
  TWidth := -1;
  TPrintWidth := -1;
  TTag := -1;
  TVisible := True;
  AnyGrouped := False;
  TSortDir := -1;
  TAgg := '<none>';

  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do begin
        TGroupBy := TGroupBy and GroupBy;
        AnyGrouped := AnyGrouped or GroupBy;
        TOwnerDraw := TOwnerDraw and OwnerDraw;
        TShowHint := TShowHint and ShowHint;
        TAllowResize := TAllowResize and AllowResize;
        TTotals := TTotals and ComputeTotals;
        TVisible := TVisible and Visible;
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
        if TTag = -1 then
          TTag := Tag
        else
          if Tag <> TTag then
            TTag := -2;
        if TSortDir = -1 then
          TSortDir := SortDir
        else
          if SortDir <> TSortDir then
            TSortDir := -2;
        if TAgg = '<none>' then
          TAgg := AggExp
        else
          if AggExp <> TAgg then
            TAgg := '<multi>';
      end;
    end;
  chkGroupBy.Checked := TGroupBy;
  chkTotals.Checked := TTotals;
  chkOwnerDraw.Checked := TOwnerDraw;
  chkShowHint.Checked := TShowHint;
  chkAllowResize.Checked := TAllowResize;
  chkTotals.Enabled := not AnyGrouped and btnOk.Enabled;
  chkOwnerDraw.Enabled := not AnyGrouped and btnOk.Enabled;
  chkShowHint.Enabled := not AnyGrouped and btnOk.Enabled;
  chkVisible.Checked := TVisible;
  if TWidth >= 0 then begin
    edtWidth.AsInteger := TWidth;
    edtWidth.Uninitialized := False;
  end else
    edtWidth.Uninitialized := True;
  if TPrintWidth >= 0 then begin
    edtPrintWidth.AsInteger := TPrintWidth;
    edtPrintWidth.Uninitialized := False;
  end else
    edtPrintWidth.Uninitialized := True;
  if TTag >= 0 then begin
    edtColTag.AsInteger := TTag;
    edtColTag.Uninitialized := False;
  end else
    edtColTag.Uninitialized := True;
  if TSortDir >= 0 then begin
    cbxSortDir.Enabled := btnOk.Enabled;
    cbxSortDir.ItemIndex := TSortDir;
  end else begin
    cbxSortDir.ItemIndex := -1;
    cbxSortDir.Enabled := False;
  end;
  if TAgg = '<none>' then begin
    edtAgg.Enabled := btnOk.Enabled;
    edtAgg.Text := '';
  end else
  if TAgg = '<multi>' then begin
    edtAgg.Enabled := False;
    edtAgg.Text := '';
  end else begin
    edtAgg.Enabled := btnOk.Enabled;
    edtAgg.TExt := TAgg;
  end;
end;

procedure TRVCmpEd2.chkTotalsClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        ComputeTotals := chkTotals.Checked and not GroupBy;
    end;
end;

procedure TRVCmpEd2.ChkOwnerDrawClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        OwnerDraw := chkOwnerDraw.Checked and not GroupBy;
    end;
end;

procedure TRVCmpEd2.edtWidthChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        Width := edtWidth.AsInteger;
    end;
end;

procedure TRVCmpEd2.edtPrintWidthChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        PrintWidth := edtPrintWidth.AsInteger;
    end;
end;

procedure TRVCmpEd2.edtColTagChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        ColTag := edtColTag.AsInteger;
    end;
end;

procedure TRVCmpEd2.chkShowHintClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        ShowHint := chkShowHint.Checked and not GroupBy;
    end;
end;

procedure TRVCmpEd2.chkAllowResizeClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        AllowResize := chkAllowResize.Checked;
    end;
end;

procedure TRVCmpEd2.chkVisibleClick(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        Visible := chkVisible.Checked;
    end;
end;

procedure TRVCmpEd2.cbxSortDirChange(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        SortDir := cbxSortDir.ItemIndex;
    end;
end;

procedure TRVCmpEd2.edtAggExit(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to pred(ListBox1.Items.Count) do
    if ListBox1.Selected[i] then begin
      with PTmpColumnProp(ListBox1.Items.Objects[i])^ do
        AggExp := edtAgg.Text;
    end;
end;

end.

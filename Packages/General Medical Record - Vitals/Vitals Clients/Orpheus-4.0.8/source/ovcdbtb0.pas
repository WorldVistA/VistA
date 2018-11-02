{*********************************************************}
{*                  OVCDBTB0.PAS 4.06                    *}
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

unit ovcdbtb0;
  {-Property editor for the data-aware table component}

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, DesignIntf, DesignEditors,
  Buttons, Forms, Dialogs, StdCtrls, OvcBase, OvcEf, OvcPb, OvcPf, OvcNf,
  ExtCtrls, OvcTCmmn, OvcTCell, OvcDbTbl, OvcTbCls, OvcTable, OvcSf, OvcSc;

type
  TOvcfrmDbColEditor = class(TForm)
    ctlColNumber: TOvcSimpleField;
    ctlCell: TComboBox;
    ctlHidden: TCheckBox;
    ctlWidth: TOvcSimpleField;
    Panel1: TPanel;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    btnFirst: TSpeedButton;
    btnLast: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    DefaultController: TOvcController;
    OvcSpinner1: TOvcSpinner;
    OvcSpinner2: TOvcSpinner;
    edFieldType: TEdit;
    edFieldName: TEdit;
    edDataType: TEdit;
    edDataSize: TEdit;
    btnProperties: TBitBtn;
    btnApply: TButton;
    btnClose: TButton;
    procedure btnApplyClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnPropertiesClick(Sender: TObject);
    procedure ctlColNumberChange(Sender: TObject);
    procedure ctlColNumberExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

  private
    FCols        : TOvcTableColumns;
    FColNum      : Integer;
    CurCellIndex : Integer;
    Cells        : TStringList;
    Ops          : TOvcDbTableOptionSet;

  protected
    procedure AddCellComponentName(const S : string);
    procedure GetCells;
    procedure RefreshColData;
    procedure SetColNum(C : Integer);

  public
    Editor : TObject;

    procedure SetCols(CS : TOvcTableColumns);

    property Cols : TOvcTableColumns
       read FCols
       write SetCols;

    property ColNum : Integer
       read FColNum
       write SetColNum;
  end;

  {-A table column property editor}
  TOvcDbTableColumnProperty = class(TClassProperty)
  public
    procedure Edit;
      override;
    function GetAttributes: TPropertyAttributes;
      override;
  end;


implementation

{$R *.DFM}

uses
  Db, TypInfo, OvcDbTb1, OvcTCBef, OvcTCSim, OvcTCPic, OvcTCNum;


{*** TOvcDbTableColumnProperty ***}

procedure TOvcDbTableColumnProperty.Edit;
var
  ColEditor : TOvcfrmDbColEditor;
begin
  ColEditor := TOvcfrmDbColEditor.Create(Application);
  try
    ColEditor.Editor := Self;
    ColEditor.SetCols(TOvcTableColumns(GetOrdValue));
    ColEditor.ShowModal;
    Designer.Modified;
  finally
    ColEditor.Free;
  end;
end;

function TOvcDbTableColumnProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paReadOnly];
end;


{*** TDbColEditor ***}

procedure TOvcfrmDbColEditor.AddCellComponentName(const S : string);
begin
  Cells.Add(S);
end;

procedure TOvcfrmDbColEditor.btnApplyClick(Sender: TObject);
var
  I       : Integer;
  Col     : Integer;
  Idx     : Integer;
  Cell    : TOvcBaseTableCell;
  OldCell : TOvcBaseTableCell;
  UseIt   : Boolean;
  Fld     : string;
begin
  with TOvcDbTableColumn(FCols[FColNum]) do begin
    {make sure at least one column remains visible}
    if not Hidden and ctlHidden.Checked then begin
      I := 0;
      for Idx := 0 to TOvcDbTable(FCols.Table).ColumnCount-1 do
        if not FCols[Idx].Hidden then
          Inc(I);
      if I = 1 then begin
        ctlHidden.Checked := False;
        raise Exception.Create('Cannot hide this column. At least one column must remain visible.');
      end;
    end;

    Hidden := ctlHidden.Checked;
    FCols[FColNum].Width := ctlWidth.AsInteger;
    if (ctlCell.ItemIndex <> CurCellIndex) then begin
      Idx := ctlCell.ItemIndex;

      {check to see if this cell is already in use}
      UseIt := True;
      Cell := TOvcBaseTableCell(Cells.Objects[Idx]);
      if Assigned(Cell) and (Cell.References > 0) then begin
        Col := -1;
        for I := 0 to Pred(FCols.Count) do
          if Cell = FCols[I].DefaultCell then begin
            Fld := TOvcDbTableColumn(FCols[I]).DataField;
            Col := I;
            Break;
          end;
        if Col > -1 then
          UseIt := MessageDlg(Format(
            'This cell is already used by column %d (field name: %s). ' +
            'If columns with different data requirements use this cell, ' +
            'data corruption is possible. ' +
            'Do you wish to assign this cell to this column also?',
            [Col, Fld]), mtWarning, [mbYes, mbNo], 0) = mrYes;
      end;

      if UseIt then begin
        CurCellIndex := Idx;
        OldCell := DefaultCell;
        DefaultCell := TOvcBaseTableCell(Cells.Objects[CurCellIndex]);

        {set cell properties for this field assignment}
        if (Field <> nil) and (DefaultCell <> nil) then
          if not TOvcDbTable(FCols.Table).SetCellProperties(Field, DefaultCell) then begin
            {revert to previous setting}
            DefaultCell := OldCell;
            RefreshColData;
            raise Exception.Create('Field data type is incompatible with selected cell component '+
                                   'or cell type is not supported.');
          end;
      end else begin
        ctlCell.ItemIndex := 0;
        ctlColNumber.AsInteger := FColNum;
      end;

    end;
  end;

  RefreshColData;
end;

procedure TOvcfrmDbColEditor.btnCloseClick(Sender: TObject);
begin
  btnApplyClick(Self);
  Cells.Free;
end;

procedure TOvcfrmDbColEditor.btnFirstClick(Sender: TObject);
begin
  btnApplyClick(Self);
  ColNum := 0;
end;

procedure TOvcfrmDbColEditor.btnLastClick(Sender: TObject);
begin
  btnApplyClick(Self);
  ColNum := Pred(FCols.Count);
end;

procedure TOvcfrmDbColEditor.btnNextClick(Sender: TObject);
begin
  btnApplyClick(Self);
  if (ColNum < Pred(FCols.Count)) then
    ColNum := ColNum + 1;
end;

procedure TOvcfrmDbColEditor.btnPrevClick(Sender: TObject);
begin
  btnApplyClick(Self);
  if (ColNum > 0) then
    ColNum := ColNum - 1;
end;

procedure TOvcfrmDbColEditor.btnPropertiesClick(Sender: TObject);
var
  frmProperties : TOvcfrmProperties;
  C             : TOvcBaseTableCell;
  S             : TOvcTCSimpleField absolute C;
  P             : TOvcTCPictureField absolute C;
  N             : TOvcTCNumericField absolute C;
  Fld           : TField;
begin
  frmProperties := TOvcfrmProperties.Create(Self);
  try
    with frmProperties do begin
      C := FCols[ColNum].DefaultCell;
      if Assigned(C) then begin
        if C is TOvcTCSimpleField then begin
          edPictureMask.MaxLength := 1;
          edPictureMask.AsString := S.PictureMask;
          edDecimalPlaces.AsInteger := S.DecimalPlaces;
          edDecimalPlaces.Enabled :=
            (S.DataType in [sftDouble, sftExtended, sftReal, sftReal]);
          if ShowModal = mrOk then begin
            if Length(edPictureMask.AsString) > 0 then
              S.PictureMask := edPictureMask.AsString[1];
            S.DecimalPlaces := edDecimalPlaces.AsInteger;
          end;
        end else if C is TOvcTCPictureField then begin
          edPictureMask.MaxLength := 255;
          edPictureMask.AsString := P.PictureMask;
          edDecimalPlaces.AsInteger := P.DecimalPlaces;
          edDecimalPlaces.Enabled :=
            (P.DataType in [pftDouble, pftExtended, pftReal, pftReal]);
          Fld := TOvcDbTableColumn(FCols[ColNum]).Field;
          rgDateOrTime.Enabled := Fld.DataType = ftDateTime;
          rgDateOrTime.ItemIndex :=
            Ord(TOvcDbTableColumn(FCols[ColNum]).DateOrTime);
          if ShowModal = mrOk then begin
            if Length(edPictureMask.AsString) > 0 then
              P.PictureMask := edPictureMask.AsString;
            P.DecimalPlaces := edDecimalPlaces.AsInteger;
            if rgDateOrTime.Enabled then
              TOvcDbTableColumn(FCols[ColNum]).DateOrTime :=
                OvcDbTbl.TDateOrTime(rgDateOrTime.ItemIndex);
          end;
        end else if C is TOvcTCNumericField then begin
          edPictureMask.MaxLength := 255;
          edPictureMask.AsString := N.PictureMask;
          edDecimalPlaces.AsInteger := 0;
          edDecimalPlaces.Enabled := False;
          if ShowModal = mrOk then begin
            if Length(edPictureMask.AsString) > 0 then
              N.PictureMask := edPictureMask.AsString;
          end;
        end;
      end;
    end;
  finally
    frmProperties.Free;
  end;
end;

procedure TOvcfrmDbColEditor.ctlColNumberChange(Sender: TObject);
var
  I : Integer;
begin
  btnApplyClick(Self);
  I := ctlColNumber.CurrentPos;
  ColNum := ctlColNumber.AsInteger;
  ctlColNumber.SetSelection(I, I);
end;

procedure TOvcfrmDbColEditor.ctlColNumberExit(Sender: TObject);
begin
  btnApplyClick(Self);
  ColNum := ctlColNumber.AsInteger;
end;

procedure TOvcfrmDbColEditor.GetCells;
var
  Designer : IDesigner;
  TI       : PTypeInfo;
  Index    : Integer;
  C        : TComponent;
  Cell     : TOvcBaseTableCell absolute C;
begin
  Cells.Sorted := True;
  Cells.AddObject('(None)', nil);
  TI := TOvcBaseTableCell.ClassInfo;
  if (Editor is TClassProperty) then
    Designer := TClassProperty(Editor).Designer
  else {the editor is a TDefaultEditor}
    Designer := TDefaultEditor(Editor).Designer;
  Designer.GetComponentNames(GetTypeData(TI), AddCellComponentName);
  for Index := 1 to Pred(Cells.Count) do
    Cells.Objects[Index] := Designer.GetComponent(Cells[Index]);
  ctlCell.Items := Cells;
end;

procedure TOvcfrmDbColEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {restore table options}
  TOvcDbTable(FCols.Table).Options := Ops;

  {reset active column to first visible column}
  TOvcDbTable(FCols.Table).ActiveColumn := 0;
end;

procedure TOvcfrmDbColEditor.FormShow(Sender: TObject);
begin
  {record current state of the table options}
  Ops := TOvcDbTable(FCols.Table).Options;
  TOvcDbTable(FCols.Table).Options := TOvcDbTable(FCols.Table).Options +
    [dtoCellsPaintText];

  if not Assigned(Cells) then begin
    Cells := TStringList.Create;
    GetCells;
  end;
  RefreshColData;
end;

procedure TOvcfrmDbColEditor.RefreshColData;
var
  I   : Integer;
  Fld : TField;
  C   : TOvcBaseTableCell;
begin
  CurCellIndex := Cells.IndexOfObject(FCols[ColNum].DefaultCell);
  ctlColNumber.RangeHi := IntToStr(Pred(FCols.Count));
  ctlHidden.Checked := FCols[ColNum].Hidden;
  ctlWidth.AsInteger := FCols[ColNum].Width;
  ctlCell.ItemIndex := CurCellIndex;

  Fld := TOvcDbTableColumn(FCols[ColNum]).Field;
  if Assigned(Fld) then begin
    edFieldType.Text := Fld.ClassName;
    if Fld.Name = '' then
      edFieldName.Text := Fld.DisplayName
    else
      edFieldName.Text := Fld.Name;
    edDataType.Text := GetEnumName(TypeInfo(TFieldType), Ord(Fld.DataType));
    if Fld.DataType in [ftString, ftMemo] then
      edDataSize.Text := Format('%d', [Fld.DataSize-1])
    else
      edDataSize.Text := Format('%d', [Fld.DataSize]);
  end;

  {update the enabled status of the nav buttons}
  btnPrev.Enabled := (ColNum > 0);
  btnNext.Enabled := (ColNum < Pred(FCols.Count));
  btnFirst.Enabled := (ColNum > 0);
  btnLast.Enabled := (ColNum < Pred(FCols.Count));

  {set state of the "Cell Properties" button}
  C := FCols[ColNum].DefaultCell;
  if Assigned(C) then begin
    btnProperties.Enabled := (C is TOvcTCSimpleField) or
                             (C is TOvcTCPictureField) or
                             (C is TOvcTCNumericField);
  end else
    btnProperties.Enabled := False;

  {make the current column visible in the table, if possible}
  I := TOvcDbTable(FCols.Table).IncCol(ColNum, 0);
  if not FCols[I].Hidden then begin
    TOvcDbTable(FCols.Table).MakeColumnVisible(I);
    TOvcDbTable(FCols.Table).ActiveColumn := I;
  end;
end;

procedure TOvcfrmDbColEditor.SetColNum(C : Integer);
begin
  if (FColNum <> C) then begin
    FColNum := C;
    ctlColNumber.AsInteger := C;
    RefreshColData;
  end;
end;

procedure TOvcfrmDbColEditor.SetCols(CS : TOvcTableColumns);
begin
  if Assigned(FCols) then
    FCols.Free;
  FCols := CS;
  FColNum := 0;
end;

end.

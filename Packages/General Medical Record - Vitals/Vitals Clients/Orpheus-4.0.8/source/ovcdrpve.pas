{*********************************************************}
{*                  OVCDRPVE.PAS 4.06                    *}
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

unit Ovcdrpve;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, OvcRptVw, OvcDRpVw, ExtCtrls, DesignIntf, DesignEditors;

type
  TOvcfrmRvDataItemEditor = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnOk: TButton;
    procedure bntAddClick(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure btnDeleteClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  public
    ReportView : TOvcDataReportView;
    FieldCount : Integer;
    CurRow : Integer;
    Dsgn : IDesigner;
    SaveOnEnumerate  : TOvcDRVEnumEvent;
    procedure LoadData;
    procedure OvcDataReportView1Enumerate(Sender: TObject;
      Data: TOvcDataRvItem; var Stop: Boolean; UserData: Pointer);
  end;

  {property editor for the data report view's items property}
  TOvcReportViewItemsProperty = class(TPropertyEditor)
  public
    procedure Edit;
      override;
    function GetAttributes : TPropertyAttributes;
      override;
    function GetValue : string;
      override;
  end;

var
  OvcfrmRvDataItemEditor: TOvcfrmRvDataItemEditor;

    procedure ShowRvDataItemsEditor(Des : IDesigner;
                                    DataReportView : TOvcDataReportView);

implementation

{$R *.DFM}

procedure TOvcfrmRvDataItemEditor.OvcDataReportView1Enumerate(Sender: TObject;
  Data: TOvcDataRvItem; var Stop: Boolean; UserData: Pointer);
var
  j : ^integer absolute UserData;
  i : Integer;
begin
  Caption := IntToStr(j^);
  if j^ <> -1 then begin
    for i := 0 to pred(FieldCount) do
      StringGrid1.Cells[i,j^] := Data.AsString[i];
    StringGrid1.Objects[0,j^] := Data;
    dec(j^);
  end;
end;

procedure TOvcfrmRvDataItemEditor.LoadData;
var
  i,j : Integer;
begin
  with StringGrid1 do begin
    RowCount := ReportView.Items.Count + 1;
    j := RowCount - 1;
    ReportView.Enumerate(@j);
    {for j := 0 to pred(ReportView.Items.Count) do begin
      for i := 0 to pred(FieldCount) do
        Cells[i,j+1] := ReportView.Items.Item[j].AsString[i];
    end;}
    if RowCount = 1 then begin
      RowCount := 2;
      for i := 0 to pred(FieldCount) do
        Cells[i,1] := '';
      Enabled := False;
    end;
    FixedRows := 1;
  end;
  btnDelete.Enabled := False;
end;

procedure TOvcfrmRvDataItemEditor.bntAddClick(Sender: TObject);
begin
  ReportView.Items.Add;
  LoadData;
  {StringGrid1.RowCount := ReportView.Items.Count + 1;}
  StringGrid1.Enabled := True;
  StringGrid1.SetFocus;
end;

procedure TOvcfrmRvDataItemEditor.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if ReportView.Items.Count > 0 then
    try
      TOvcDataRvItem(StringGrid1.Objects[0, ARow]).AsString[ACol] := Value;
      {ReportView.Items[ARow - 1].AsString[ACol] := Value;}
      if Dsgn <> nil then
        Dsgn.Modified;
    except
    end;
end;

procedure TOvcfrmRvDataItemEditor.btnDeleteClick(Sender: TObject);
begin
  if CurRow > 0 then begin
    TOvcDataRvItem(StringGrid1.Objects[0, CurRow]).Free;
    {ReportView.Items.Item[CurRow - 1].Free;}
    LoadData;
  end;
end;

procedure TOvcfrmRvDataItemEditor.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CurRow := ARow;
  if CurRow > 0 then
    btnDelete.Enabled := True;
end;

procedure ShowRvDataItemsEditor(Des : IDesigner; DataReportView : TOvcDataReportView);
var
  i : Integer;
  s : string;
begin
  with TOvcfrmRvDataItemEditor.Create(Application) do
    try
      ReportView := DataReportView;
      SaveOnEnumerate := ReportView.OnEnumerate;
      ReportView.OnEnumerate := OvcDataReportView1Enumerate;
      FieldCount := DataReportView.Fields.Count;
      Dsgn := Des;
      with StringGrid1 do begin
        FixedCols := 0;
        ColCount := FieldCount;
        CurRow := -1;
        for i := 0 to pred(FieldCount) do begin
          s := TOvcRvField(DataReportView.Field[i]).Caption;
          if s = '' then
            s := TOvcRvField(DataReportView.Field[i]).Name;
          Cells[i,0] := s;
          StringGrid1.ColWidths[i] := TOvcRvField(DataReportView.Field[i]).DefaultWidth;
        end;
        LoadData;
      end;
      ShowModal;
      ReportView.OnEnumerate := SaveOnEnumerate;
    finally
      Free;
    end;
end;

{*** TOvcReportViewItemsProperty ***}

function TOvcReportViewItemsProperty.GetAttributes : TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TOvcReportViewItemsProperty.GetValue: string;
begin
  Result := '(' + TOvcDataRvItems(GetOrdValueAt(0)).ClassName + ')';
end;

procedure TOvcReportViewItemsProperty.Edit;
begin
  ShowRvDataItemsEditor(Designer, GetComponent(0) as TOvcDataReportView);
end;


end.

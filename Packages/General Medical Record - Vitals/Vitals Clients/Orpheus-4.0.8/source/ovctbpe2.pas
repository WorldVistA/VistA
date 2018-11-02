{*********************************************************}
{*                  OVCTBPE2.PAS 4.06                    *}
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
{* Roman Kassebaum                                                            *}
{* Patrick Lajko/CDE Software                                                 *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctbpe2;
  {-Property editor for the data-aware table component}

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, DesignIntf, DesignEditors,
  TypInfo, Forms, Dialogs, StdCtrls, OvcBase, OvcEf, OvcPb, OvcNf, Buttons, ExtCtrls,
  OvcTCmmn, OvcTCell, OvcTbCls, OvcTable, OvcSf, OvcSc;

type
  TOvcfrmColEditor = class(TForm)
    ctlColNumber: TOvcSimpleField;
    ctlDefaultCell: TComboBox;
    ctlHidden: TCheckBox;
    ctlWidth: TOvcSimpleField;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DoneButton: TBitBtn;
    ApplyButton: TBitBtn;
    DefaultController: TOvcController;
    OvcSpinner1: TOvcSpinner;
    OvcSpinner2: TOvcSpinner;
    ctlShowRightLine: TCheckBox;
    Label5: TLabel;
    procedure ctlColNumberExit(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ctlColNumberChange(Sender: TObject);
  private
    { Private declarations }
    FCols : TOvcTableColumns;
    FColNum : TColNum;
    CurCellIndex : integer;
    Cells     : TStringList;

  protected
    procedure GetCells;
    procedure RefreshColData;
    procedure SetColNum(C : TColNum);

    procedure AddCellComponentName(const S : string);

  public
    { Public declarations }
    Editor : TObject;
    procedure SetCols(CS : TOvcTableColumns);

    property Cols : TOvcTableColumns
       read FCols
       write SetCols;

    property ColNum : TColNum
       read FColNum
       write SetColNum;

  end;

  {-A table column property editor}
  TOvcTableColumnProperty = class(TClassProperty)
    public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
    end;


implementation

{$R *.DFM}



{===TOvcTableColumnProperty==========================================}
procedure TOvcTableColumnProperty.Edit;
  var
    ColEditor : TOvcfrmColEditor;
  begin
    ColEditor := TOvcfrmColEditor.Create(Application);
    try
      ColEditor.Editor := Self;
      ColEditor.SetCols(TOvcTableColumns(GetOrdValue));
      ColEditor.ShowModal;
      Designer.Modified;
      finally
      ColEditor.Free;
    end;{try..finally}
  end;
{--------}
function TOvcTableColumnProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;
{====================================================================}


{===TColEditor=======================================================}
procedure TOvcfrmColEditor.AddCellComponentName(const S : string);
  begin
    Cells.Add(S);
  end;
{--------}
procedure TOvcfrmColEditor.ApplyButtonClick(Sender: TObject);
  begin
    with FCols[ColNum] do
      begin
        Hidden := ctlHidden.Checked;
        ShowRightLine := ctlShowRightLine.Checked; // CDE
        FCols[ColNum].Width := ctlWidth.AsInteger;
        if (ctlDefaultCell.ItemIndex <> CurCellIndex) then
          begin
            CurCellIndex := ctlDefaultCell.ItemIndex;
            FCols[FColNum].DefaultCell := TOvcBaseTableCell(Cells.Objects[CurCellIndex]);
          end;
      end;
  end;
{--------}
procedure TOvcfrmColEditor.ctlColNumberExit(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := ctlColNumber.AsInteger;
  end;
{--------}
procedure TOvcfrmColEditor.DoneButtonClick(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    Cells.Free;
  end;
{--------}
procedure TOvcfrmColEditor.FormShow(Sender: TObject);
  begin
    if not Assigned(Cells) then
      begin
        Cells := TStringList.Create;
        GetCells;
      end;
    RefreshColData;
  end;
{--------}
procedure TOvcfrmColEditor.GetCells;
  var
    Designer : IDesigner;
    TI   : PTypeInfo;
    Index: Integer;
    C    : TComponent;
    Cell : TOvcBaseTableCell absolute C;
  begin
    Cells.Sorted := true;
    Cells.AddObject('(None)', nil);
    TI := TOvcBaseTableCell.ClassInfo;
    if (Editor is TClassProperty) then
      Designer := TClassProperty(Editor).Designer
    else {the editor is a TDefaultEditor}
      Designer := TDefaultEditor(Editor).Designer;
    Designer.GetComponentNames(GetTypeData(TI), AddCellComponentName);
    for Index := 1 to pred(Cells.Count) do
      Cells.Objects[Index] := Designer.GetComponent(Cells[Index]);
    ctlDefaultCell.Items := Cells;
  end;
{--------}
procedure TOvcfrmColEditor.RefreshColData;
  begin
    CurCellIndex := Cells.IndexOfObject(FCols[ColNum].DefaultCell);

    ctlColNumber.RangeHi := IntToStr(pred(FCols.Count));

    ctlHidden.Checked := FCols[ColNum].Hidden;
    ctlShowRightLine.Checked := FCols[ColNum].ShowRightLine;
    ctlWidth.AsInteger := FCols[ColNum].Width;
    ctlDefaultCell.ItemIndex := CurCellIndex;
  end;
{--------}
procedure TOvcfrmColEditor.SetColNum(C : TColNum);
  begin
    if (FColNum <> C) then
      begin
        FColNum := C;
        ctlColNumber.AsInteger := C;
        RefreshColData;
      end;
  end;
{--------}
procedure TOvcfrmColEditor.SetCols(CS : TOvcTableColumns);
  begin
    if Assigned(FCols) then
      FCols.Free;
    FCols := CS;
    FColNum := 0;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton1Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (ColNum > 0) then
      ColNum := ColNum - 1;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton2Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (ColNum < pred(FCols.Count)) then
      ColNum := ColNum + 1;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton3Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := 0;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton4Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := pred(FCols.Count);
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton5Click(Sender: TObject);
  var
    C : TOvcTableColumn;
  begin
    C := TOvcTableColumn.Create(FCols.Table);
    FCols.Insert(FColNum, C);
    RefreshColData;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton6Click(Sender: TObject);
  begin
    if (FCols.Count > 1) then
      begin
        FCols.Delete(FColNum);
        if (FColNum = FCols.Count) then
             ColNum := pred(FColNum)
        else RefreshColData;
      end;
  end;
{====================================================================}


procedure TOvcfrmColEditor.ctlColNumberChange(Sender: TObject);
begin
  ApplyButtonClick(Self);
  ColNum := ctlColNumber.AsInteger;
end;

end.

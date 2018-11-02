{*********************************************************}
{*                  OVCTBPE1.PAS 4.06                    *}
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

unit ovctbpe1;
  {-Property editor for the table component}

interface

uses
  Windows, Classes, Graphics, Controls, DesignIntf, DesignEditors, Messages, SysUtils,
  Forms, Dialogs, StdCtrls, OvcBase, OvcEf, OvcPb, OvcNf, Buttons, ExtCtrls, OvcTCmmn,
  OvcTable, OvcTbRws, OvcSf, OvcSc;

type
  TOvcfrmRowEditor = class(TForm)
    ctlHidden: TCheckBox;
    ctlUseDefHeight: TRadioButton;
    ctlUseCustHeight: TRadioButton;
    DoneButton: TBitBtn;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Reset: TBitBtn;
    ctlHeight: TOvcSimpleField;
    ctlDefaultHeight: TOvcSimpleField;
    ctlRowLimit: TOvcSimpleField;
    ctlRowNumber: TOvcSimpleField;
    ApplyButton: TBitBtn;
    DefaultController: TOvcController;
    OvcSpinner1: TOvcSpinner;
    OvcSpinner2: TOvcSpinner;
    OvcSpinner3: TOvcSpinner;
    OvcSpinner4: TOvcSpinner;
    procedure ctlUseDefHeightClick(Sender: TObject);
    procedure ctlUseCustHeightClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ctlRowNumberExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ctlRowNumberChange(Sender: TObject);
  private
    { Private declarations }
    FRows : TOvcTableRows;
    FRowNum : TRowNum;
    CurDefHt  : boolean;

  protected
    procedure RefreshRowData;
    procedure SetRowNum(R : TRowNum);

  public
    { Public declarations }
    procedure SetRows(RS : TOvcTableRows);

    property Rows : TOvcTableRows
       read FRows
       write SetRows;

    property RowNum : TRowNum
       read FRowNum
       write SetRowNum;

  end;

  {-A table row property editor}
  TOvcTableRowProperty = class(TClassProperty)
    public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
    end;


implementation

{$R *.DFM}



{===TOvcTableRowProperty=============================================}
procedure TOvcTableRowProperty.Edit;
  var
    RowEditor : TOvcfrmRowEditor;
  begin
    RowEditor := TOvcfrmRowEditor.Create(Application);
    try
      RowEditor.SetRows(TOvcTableRows(GetOrdValue));
      RowEditor.ShowModal;
      Designer.Modified;
    finally
      RowEditor.Free;
    end;{try..finally}
  end;
{--------}
function TOvcTableRowProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;
{====================================================================}


{===TRowEditor=======================================================}
procedure TOvcfrmRowEditor.ApplyButtonClick(Sender: TObject);
  var
    RS : TRowStyle;
  begin
    FRows.Limit := ctlRowLimit.AsInteger;
    if FRowNum >= FRows.Limit then
      RowNum := pred(FRows.Limit);
    FRows.DefaultHeight := ctlDefaultHeight.AsInteger;
    with RS do
      begin
        if ctlUseDefHeight.Checked then
          Height := ctlDefaultHeight.AsInteger
        else
          begin
            Height := ctlHeight.AsInteger;
            if (Height = FRows.DefaultHeight) then
              ctlUseDefHeight.Checked := true;
          end;
        Hidden := ctlHidden.Checked;
        FRows[RowNum] := RS;
      end;
  end;
{--------}
procedure TOvcfrmRowEditor.ctlRowNumberExit(Sender: TObject);
  begin
    RowNum := ctlRowNumber.AsInteger;
  end;
{--------}
procedure TOvcfrmRowEditor.ctlUseCustHeightClick(Sender: TObject);
  begin
    CurDefHt := false;
    ctlHeight.Enabled := true;
  end;
{--------}
procedure TOvcfrmRowEditor.ctlUseDefHeightClick(Sender: TObject);
  begin
    CurDefHt := true;
    ctlHeight.AsInteger := FRows.DefaultHeight;
    ctlHeight.Enabled := false;
  end;
{--------}
procedure TOvcfrmRowEditor.FormShow(Sender: TObject);
  begin
    ctlDefaultHeight.AsInteger := FRows.DefaultHeight;
    ctlRowLimit.AsInteger := FRows.Limit;
    RefreshRowData;
  end;
{--------}
procedure TOvcfrmRowEditor.RefreshRowData;
  begin
    CurDefHt := FRows.Height[RowNum] = FRows.DefaultHeight;

    ctlRowNumber.RangeHi := IntToStr(pred(FRows.Limit));

    ctlHidden.Checked := FRows.Hidden[RowNum];
    ctlHeight.AsInteger := FRows.Height[RowNum];
    if CurDefHt then
      begin
        ctlUseDefHeight.Checked := true;
        ctlHeight.Enabled := false;
      end
    else
      begin
        ctlUseCustHeight.Checked := true;
        ctlHeight.Enabled := true;
      end;

    ctlRowLimit.AsInteger := FRows.Limit;
  end;
{--------}
procedure TOvcfrmRowEditor.ResetClick(Sender: TObject);
  begin
    FRows.Clear;
    ctlDefaultHeight.AsInteger := FRows.DefaultHeight;
    RefreshRowData;
  end;
{--------}
procedure TOvcfrmRowEditor.SetRowNum(R : TRowNum);
  begin
    if (FRowNum <> R) then
      begin
        FRowNum := R;
        ctlRowNumber.AsInteger := R;
        RefreshRowData;
      end;
  end;
{--------}
procedure TOvcfrmRowEditor.SetRows(RS : TOvcTableRows);
  begin
    if Assigned(FRows) then
      FRows.Free;
    FRows := RS;
    FRowNum := 0;
    CurDefHt := FRows.Height[RowNum] = FRows.DefaultHeight;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton1Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (RowNum > 0) then
      RowNum := RowNum - 1;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton2Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (RowNum < pred(FRows.Limit)) then
      RowNum := RowNum + 1;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton3Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    RowNum := 0;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton4Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    RowNum := pred(FRows.Limit);
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton5Click(Sender: TObject);
  var
    RS : TRowStyle;
  begin
    RS.Hidden := false;
    RS.Height := FRows.DefaultHeight;
    FRows.Insert(FRowNum, RS);
    RefreshRowData;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton6Click(Sender: TObject);
  begin
    FRows.Delete(FRowNum);
    RefreshRowData;
  end;
{====================================================================}

procedure TOvcfrmRowEditor.DoneButtonClick(Sender: TObject);
begin
  ApplyButtonClick(Self);
end;

procedure TOvcfrmRowEditor.ctlRowNumberChange(Sender: TObject);
begin
  ApplyButtonClick(Self);
  RowNum := ctlRowNumber.AsInteger;
end;

end.

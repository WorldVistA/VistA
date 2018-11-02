
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
{*                  OVCRVPDG.PAS 4.06                    *}
{*********************************************************}

unit ovcrvpdg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OvcBase, OvcPrCbx, ExtCtrls, OvcRptVw, OvcCmbx, OvcRvCbx, OvcDlg,
  Printers;

type
  TOvcRvPrintDialog = class;
  TOvcfrmRptVwPrintDlg = class(TForm)
    OvcViewComboBox1: TOvcViewComboBox;
    RadioGroup1: TRadioGroup;
    OvcPrinterComboBox1: TOvcPrinterComboBox;
    OvcPrinterComboBox1Label1: TOvcAttachedLabel;
    OvcViewComboBox1Label1: TOvcAttachedLabel;
    btnOk: TButton;
    btnCancel: TButton;
    btnAbort: TButton;
    lblPageText: TLabel;
    lblPageNumber: TLabel;
    chkSelected: TCheckBox;
    Bevel1: TBevel;
    btnHelp: TButton;
    RadioGroup2: TRadioGroup;
    btnPreview: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure OvcViewComboBox1Change(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
  private
    procedure SetProperties;
  public
    Comp : TOvcRvPrintDialog;
    Mode : TRVPrintMode;
    Aborting : Boolean;
    procedure PrintStatus(Sender : TObject; Page : Integer;
      var Abort : Boolean);
  end;

  TOvcRvPOption = (rdShowPrinterCombo, rdShowViewCombo, rdShowGroupControl,
    rdShowSelectedCheckbox, rdShowHelp);
  TOvcRvPOptions = set of TOvcRVPOption;

  TOvcRvPrintDialog = class(TOvcBaseDialog)

  protected {private}
    {property variables}
    FCaption : string;
    FDefaultOrientation: TPrinterOrientation;
    FOptions : TOvcRvPOptions;
    FReportView : TOvcCustomReportView;
    FSelectedCheckedInit : Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    property SelectedCheckedInit : Boolean
      read FSelectedCheckedInit write FSelectedCheckedInit;

    function Execute : Boolean;
      override;

  published
    {properties}
    property Caption : string
      read FCaption write FCaption;
    property DefaultOrientation: TPrinterOrientation
      read FDefaultOrientation write FDefaultOrientation
      default poPortrait;
    property Options : TOvcRvPOptions
      read FOptions write FOptions
      default [rdShowPrinterCombo, rdShowViewCombo, rdShowGroupControl,
        rdShowSelectedCheckbox];
    property ReportView : TOvcCustomReportView
      read FReportView write FReportView;
    {inherited properties}
    property Font;
    property Icon;
    property Placement;
    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}

{ TOvcRvPrintDialog }

constructor TOvcRvPrintDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions := [rdShowPrinterCombo, rdShowViewCombo, rdShowGroupControl,
    rdShowSelectedCheckbox];
  FPlacement.Height := 332;
  FPlacement.Width := 307;
end;

destructor TOvcRvPrintDialog.Destroy;
begin
  inherited Destroy;
end;

function TOvcRvPrintDialog.Execute: Boolean;
var
  F : TOvcfrmRptVwPrintDlg;
begin
  if not assigned(FReportView) then
    raise Exception.Create('Print dialog''s Report view property not assigned');
  F := TOvcfrmRptVwPrintDlg.Create(Application);
  with F do
    try
      DoFormPlacement(F);
      OvcViewComboBox1.Visible := rdShowViewCombo in Options;
      if OvcViewComboBox1.Visible then
        OvcViewComboBox1.ReportView := ReportView;
      RadioGroup1.Visible := rdShowGroupControl in Options;
      OvcPrinterComboBox1.Visible := rdShowPrinterCombo in Options;
      chkSelected.Visible := rdShowSelectedCheckbox in Options;
      chkSelected.Checked := SelectedCheckedInit;
      btnHelp.Visible := rdShowHelp in Options;
      Comp := Self;
      RadioGroup1.Enabled := ReportView.IsGrouped;
      chkSelected.Enabled := ReportView.MultiSelect;
      Caption := Self.Caption;
      case DefaultOrientation of
      poPortrait:
        RadioGroup2.ItemIndex := 0;
      else
        RadioGroup2.ItemIndex := 1;
      end;
      Result := ShowModal <> mrCancel;
    finally
      Free;
    end;
end;

{ new}
procedure TOvcRvPrintDialog.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) then
    if (AComponent = ReportView) then
      ReportView := nil;
  inherited Notification(AComponent, Operation);
end;

procedure TOvcfrmRptVwPrintDlg.SetProperties;
begin
  if Comp.ReportView.CurrentView <> nil then begin
    Comp.ReportView.OnPrintStatus := PrintStatus;
    case RadioGroup1.ItemIndex of
    0 : Mode := pmExpandAll;
    1 : Mode := pmCollapseAll;
    2 : Mode := pmCurrent;
    else
      raise Exception.Create('Internal error');
    end;
    lblPageText.Visible := True;
    lblPageNumber.Visible := True;
    btnOk.Enabled := False;
    btnCancel.Enabled := False;
    OvcViewComboBox1.Enabled := False;
    RadioGroup1.Enabled := False;
    OvcPrinterComboBox1.Enabled := False;
    btnAbort.Enabled := True;
    Aborting := False;
    if RadioGroup2.ItemIndex = 0 then
      Printer.Orientation := poPortrait
    else
      Printer.Orientation := poLandscape;
  end;
end;

procedure TOvcfrmRptVwPrintDlg.btnOkClick(Sender: TObject);
begin
  if Printer.Printers.Count = 0 then
    raise Exception.Create('No printer installed');
  SetProperties;
  try
    Comp.ReportView.Print(Mode,
      chkSelected.Visible and chkSelected.Checked);
  finally
    lblPageText.Visible := False;
    lblPageNumber.Visible := False;
    btnOk.Enabled := True;
    btnCancel.Enabled := True;
    OvcViewComboBox1.Enabled := True;
    OvcPrinterComboBox1.Enabled := True;
    RadioGroup1.Enabled := True;
    btnAbort.Enabled := False;
  end;
  ModalResult := mrOK;
end;

procedure TOvcfrmRptVwPrintDlg.PrintStatus(Sender : TObject; Page : Integer;
  var Abort : Boolean);
begin
  lblPageNumber.Caption := IntToStr(Page);
  Abort := Aborting;
  Application.ProcessMessages;
end;

procedure TOvcfrmRptVwPrintDlg.btnAbortClick(Sender: TObject);
begin
  Aborting := Self.Aborting;
  Caption := 'Aborting....';
end;

procedure TOvcfrmRptVwPrintDlg.OvcViewComboBox1Change(Sender: TObject);
begin
  RadioGroup1.Enabled := Comp.ReportView.IsGrouped;
  chkSelected.Enabled := Comp.ReportView.MultiSelect;
end;

procedure TOvcfrmRptVwPrintDlg.btnHelpClick(Sender: TObject);
begin
  Comp.OnHelpClick(Self);
end;

procedure TOvcfrmRptVwPrintDlg.btnPreviewClick(Sender: TObject);
begin
  if Printer.Printers.Count = 0 then
    raise Exception.Create('No printer installed');
  SetProperties;
  try
    Comp.ReportView.PrintPreview(Mode,
      chkSelected.Visible and chkSelected.Checked);
  finally
    lblPageText.Visible := False;
    lblPageNumber.Visible := False;
    btnOk.Enabled := True;
    btnCancel.Enabled := True;
    OvcViewComboBox1.Enabled := True;
    OvcPrinterComboBox1.Enabled := True;
    RadioGroup1.Enabled := True;
    btnAbort.Enabled := False;
  end;
end;

end.

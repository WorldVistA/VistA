{*********************************************************}
{*                   OVCCLCDG.PAS 4.06                   *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcclcdg;
  {-Calculator dialog}

interface

uses
  Windows, Classes, Controls, ExtCtrls, Forms, Graphics, StdCtrls, SysUtils,
  OvcBase, OvcConst, OvcData, OvcExcpt, OvcDlg, OvcCalc;

type
  TOvcfrmCalculatorDlg = class(TForm)
    btnHelp: TButton;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    OvcCalculator1: TOvcCalculator;
    procedure FormShow(Sender: TObject);
  public
    Value: double;
  end;

type
  TOvcCalculatorDialog = class(TOvcBaseDialog)
  protected {private}
    {property variables}
    FCalculator : TOvcCalculator;
    FValue      : Double;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function Execute : Boolean; override;

    property Calculator : TOvcCalculator
      read FCalculator;

  published
    {properties}
    property Caption;
    property Font;
    property Icon;
    property Options;
    property Placement;
    property Value: Double
      read FValue write FValue;

    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}


constructor TOvcCalculatorDialog.Create(AOwner : TComponent);
begin
  if not ((AOwner is TCustomForm) or (AOwner is TCustomFrame)) then
    raise EOvcException.Create(GetOrphStr(SCOwnerMustBeForm));

  inherited Create(AOwner);

  FPlacement.Height := 200;
  FPlacement.Width := 225;

  FCalculator := TOvcCalculator.Create(nil);
  FCalculator.Visible := False;
  FCalculator.Parent := (AOwner as TWinControl);
end;

destructor TOvcCalculatorDialog.Destroy;
begin
  inherited Destroy;
end;

function TOvcCalculatorDialog.Execute : Boolean;
var
  F : TOvcfrmCalculatorDlg;
begin
  F := TOvcfrmCalculatorDlg.Create(Application);
  try
    DoFormPlacement(F);

    F.btnHelp.Visible := doShowHelp in Options;
    F.btnHelp.OnClick := FOnHelpClick;

    {transfer Calculator properties}
    F.OvcCalculator1.Colors.Assign(FCalculator.Colors);
    F.OvcCalculator1.Font := FCalculator.Font;
    F.OvcCalculator1.TapeFont := FCalculator.TapeFont;
    F.OvcCalculator1.Decimals := FCalculator.Decimals;
    F.OvcCalculator1.Options := FCalculator.Options;
    F.OvcCalculator1.TapeHeight := FCalculator.TapeHeight;
    F.OvcCalculator1.TapeSeparatorChar := FCalculator.TapeSeparatorChar;
    F.OvcCalculator1.Hint := FCalculator.Hint;
    F.OvcCalculator1.PopupMenu := FCalculator.PopupMenu;
    F.OvcCalculator1.ShowHint := FCalculator.ShowHint;
    F.Value := FValue;

    {show the memo form}
    Result := F.ShowModal = mrOK;
    if Result then begin
      FCalculator.DisplayValue := F.OvcCalculator1.DisplayValue;
      FValue := FCalculator.DisplayValue;
    end;

  finally
    F.Free;
  end;
end;

procedure TOvcfrmCalculatorDlg.FormShow(Sender: TObject);
begin
  OvcCalculator1.DisplayValue := Value;
  OvcCalculator1.LastOperand := Value;
end;

end.

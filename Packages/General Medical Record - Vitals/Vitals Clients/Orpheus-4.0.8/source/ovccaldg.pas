{*********************************************************}
{*                   OVCCALDG.PAS 4.06                   *}
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

unit ovccaldg;
  {-Calendar dialog}

interface

uses
  Windows, Classes, Controls, ExtCtrls, Forms, Graphics, StdCtrls, SysUtils,
  OvcBase, OvcConst, OvcData, OvcExcpt, OvcCal, OvcDlg;

type

  TOvcfrmCalendarDlg = class(TForm)
    btnHelp: TButton;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    OvcCalendar1: TOvcCalendar;
    procedure OvcCalendar1DblClick(Sender: TObject);
  end;


type
  TOvcCalendarDialog = class(TOvcBaseDialog)

  protected {private}
    {property variables}
    FCalendar  : TOvcCalendar;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    function Execute : Boolean;
      override;

    property Calendar : TOvcCalendar
      read FCalendar;

  published
    {properties}
    property Caption;
    property Font;
    property Icon;
    property Options;
    property Placement;


    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}


constructor TOvcCalendarDialog.Create(AOwner : TComponent);
begin
  if not ((AOwner is TCustomForm) or (Owner is TCustomFrame)) then
    raise EOvcException.Create(GetOrphStr(SCOwnerMustBeForm));

  inherited Create(AOwner);

  FPlacement.Height := 200;
  FPlacement.Width := 225;

  FCalendar := TOvcCalendar.Create(nil);
  FCalendar.Visible := False;
  FCalendar.Parent := AOwner as TWinControl;
end;

destructor TOvcCalendarDialog.Destroy;
begin
  inherited Destroy;
end;

function TOvcCalendarDialog.Execute : Boolean;
var
  F : TOvcfrmCalendarDlg;
begin
  F := TOvcfrmCalendarDlg.Create(Application);
  try
    DoFormPlacement(F);

    F.btnHelp.Visible := doShowHelp in Options;
    F.btnHelp.OnClick := FOnHelpClick;

    {transfer calendar properties}
    F.OvcCalendar1.Colors.Assign(FCalendar.Colors);
    F.OvcCalendar1.DateFormat := FCalendar.DateFormat;
    F.OvcCalendar1.DayNameWidth := FCalendar.DayNameWidth;
    F.OvcCalendar1.Font := FCalendar.Font;
    F.OvcCalendar1.Hint := FCalendar.Hint;
    F.OvcCalendar1.Options := FCalendar.Options;
    F.OvcCalendar1.PopupMenu := FCalendar.PopupMenu;
    F.OvcCalendar1.ShowHint := FCalendar.ShowHint;
    F.OvcCalendar1.WeekStarts := FCalendar.WeekStarts;
    F.OvcCalendar1.Date := FCalendar.Date;

    {show the memo form}
    Result := F.ShowModal = mrOK;
    if Result then
      FCalendar.Date := F.OvcCalendar1.Date;

  finally
    F.Free;
  end;
end;

procedure TOvcfrmCalendarDlg.OvcCalendar1DblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;


end.

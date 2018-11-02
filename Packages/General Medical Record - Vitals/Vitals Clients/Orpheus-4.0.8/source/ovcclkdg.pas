{*********************************************************}
{*                  OVCCLKDG.PAS 4.06                    *}
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

unit ovcclkdg;
  {-Clock dialog}

interface

uses
  Windows, Classes, Controls, ExtCtrls, Forms, Graphics, StdCtrls, SysUtils,
  OvcBase, OvcConst, OvcData, OvcExcpt, OvcDlg, OvcClock;

type

  TOvcfrmClockDlg = class(TForm)
    btnHelp: TButton;
    Panel1: TPanel;
    btnCancel: TButton;
    OvcClock1: TOvcClock;
    OvcController1: TOvcController;
  end;


type
  TOvcClockDialog = class(TOvcBaseDialog)

  protected {private}
    {property variables}
    FClock   : TOvcClock;

    {property methods}
    function GetClockFace : TBitMap;
    procedure SetClockFace(Value : TBitMap);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    function Execute : Boolean;
      override;

    property Clock : TOvcClock
      read FClock;

  published
    {properties}
    property Caption;
    property ClockFace : TBitMap
      read GetClockFace write SetClockFace;
    property Font;
    property Icon;
    property Options;
    property Placement;

    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}


constructor TOvcClockDialog.Create(AOwner : TComponent);
begin
  if not ((AOwner is TCustomForm) or (AOwner is TCustomFrame)) then
    raise EOvcException.Create(GetOrphStr(SCOwnerMustBeForm));

  inherited Create(AOwner);

  FPlacement.Height := 230;
  FPlacement.Width := 185;

  FClock := TOvcClock.Create(nil);
  FClock.Visible := False;
(*
  FClock.Parent := AOwner as TForm;
*)
  FClock.Parent := (AOwner as TWinControl);
end;

destructor TOvcClockDialog.Destroy;
begin
  inherited Destroy;
end;

function TOvcClockDialog.Execute : Boolean;
var
  F : TOvcfrmClockDlg;
begin
  F := TOvcfrmClockDlg.Create(Application);
  try
    DoFormPlacement(F);

    F.btnHelp.Visible := doShowHelp in Options;
    F.btnHelp.OnClick := FOnHelpClick;

    {transfer Clock properties}
    F.OvcClock1.ClockFace.Assign(FClock.ClockFace);
    F.OvcClock1.ClockMode := FClock.ClockMode;
    F.OvcClock1.Color := FClock.Color;
    F.OvcClock1.DrawMarks := FClock.DrawMarks;
    F.OvcClock1.HandOptions.Assign(FClock.HandOptions);
    F.OvcClock1.TimeOffset := FClock.TimeOffset;
    F.OvcClock1.MinuteOffset := FClock.MinuteOffset;
    F.OvcClock1.Hint := FClock.Hint;
    F.OvcClock1.PopupMenu := FClock.PopupMenu;
    F.OvcClock1.ShowHint := FClock.ShowHint;

    {show the memo form}
    F.ShowModal;
    Result := True;
  finally
    F.Free;
  end;
end;

function TOvcClockDialog.GetClockFace : TBitMap;
begin
  Result := FClock.ClockFace;
end;

procedure TOvcClockDialog.SetClockFace(Value : TBitMap);
begin
  FClock.ClockFace := Value;
end;


end.

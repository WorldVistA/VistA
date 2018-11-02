{*********************************************************}
{*                  OVCMODG.PAS 4.06                    *}
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

unit ovcmodg;

interface

uses
  UITypes, Windows, Classes, Controls, Dialogs, ExtCtrls, Forms, Graphics,
  Messages, StdCtrls, SysUtils, OvcConst, OvcData, OvcDlg;

type

  TOvcfrmMemoDlg = class(TForm)
    btnHelp: TButton;
    Panel1: TPanel;
    Memo: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    lblReadOnly: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
  public
  end;


type
  TOvcMemoDialog = class(TOvcBaseDialog)

  protected {private}
    {property variables}
    FLines         : TStrings;
    FMemoFont      : TFont;
    FReadOnly      : Boolean;
    FWordWrap      : Boolean;

    {property methods}
    procedure SetLines(Value : TStrings);
    procedure SetMemoFont(Value : TFont);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    function Execute : Boolean;
      override;

  published
    {properties}
    property Caption;
    property Font;
    property Icon;
    property Options;
    property Placement;

    property Lines : TStrings
      read FLines write SetLines;
    property MemoFont : TFont
      read FMemoFont write SetMemoFont;
    property ReadOnly : Boolean
      read FReadOnly write FReadOnly
      default False;
    property WordWrap : Boolean
      read FWordWrap write FWordWrap
      default True;

    {events}
    property OnHelpClick;
  end;


implementation

{$R *.DFM}


constructor TOvcMemoDialog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FLines    := TStringList.Create;
  FMemoFont := TFont.Create;
  FReadOnly := False;
  FWordWrap := True;
end;

destructor TOvcMemoDialog.Destroy;
begin
  FLines.Free;
  FLines := nil;

  FMemoFont.Free;
  FMemoFont := nil;

  inherited Destroy;
end;

function TOvcMemoDialog.Execute : Boolean;
var
  F : TOvcfrmMemoDlg;
begin
  F := TOvcfrmMemoDlg.Create(Application);
  try
    DoFormPlacement(F);

    {set memo properties}
    F.Memo.Lines.Assign(FLines);
    F.Memo.Modified := False;
    F.Memo.Font := FMemoFont;
    F.Memo.WordWrap := FWordWrap;
    F.Memo.ReadOnly := FReadOnly;
    if F.Memo.ReadOnly then begin
      F.btnOK.Visible := False;
      F.btnCancel.Caption := GetOrphStr(SCCloseCaption);
    end;
    F.lblReadOnly.Visible := F.Memo.ReadOnly;

    F.btnHelp.Visible := doShowHelp in Options;
    F.btnHelp.OnClick := FOnHelpClick;

    {show the memo form}
    Result := F.ShowModal = mrOK;

    if Result and F.Memo.Modified then
      FLines.Assign(F.Memo.Lines);
  finally
    F.Free;
  end;
end;

procedure TOvcMemoDialog.SetLines(Value : TStrings);
begin
  FLines.Assign(Lines);
end;

procedure TOvcMemoDialog.SetMemoFont(Value : TFont);
begin
  FMemoFont.Assign(Value);
end;


{*** TOvcMemoDlg ***}

procedure TOvcfrmMemoDlg.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
  CanClose := True;
  if Memo.Modified and (ModalResult = mrCancel) then
    if MessageDlg(GetOrphStr(SCCancelQuery), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      CanClose := False;
end;

end.


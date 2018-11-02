{*********************************************************}
{*                   OVCDLG.PAS 4.06                    *}
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

unit ovcdlg;
  {non-visual dialog base classes}

interface

uses
  Classes, Forms, Graphics,
  OvcBase;

type
  TOvcDialogPosition = (mpCenter, mpCenterTop, mpCustom);
  TOvcDialogOption = (doShowHelp, doSizeable);
  TOvcDialogOptions = set of TOvcDialogOption;

  TOvcDialogPlacement = class(TPersistent)
  

  protected {private}
    {property variables}
    FPosition : TOvcDialogPosition;
    FHeight   : Integer;
    FLeft     : Integer;
    FTop      : Integer;
    FWidth    : Integer;
    function LeftTopUsed: Boolean;

  published
    {properties}
    property Position : TOvcDialogPosition
      read FPosition write FPosition
      default mpCenter;
    property Top : Integer
      read FTop write FTop
      stored LeftTopUsed
      default 10;
    property Left : Integer
      read FLeft write FLeft
      stored LeftTopUsed
      default 10;
    property Height : Integer
      read FHeight write FHeight;
    property Width : Integer
      read FWidth write FWidth;
  end;

  TOvcBaseDialog = class(TOvcComponent)
  

  protected {private}
    {property variables}
    FCaption   : string;
    FFont      : TFont;
    FIcon      : TIcon;
    FOptions   : TOvcDialogOptions;
    FPlacement : TOvcDialogPlacement;

    {event variables}
    FOnHelpClick : TNotifyEvent;

    {property methods}
    procedure SetFont(Value : TFont);
    procedure SetIcon(Value : TIcon);

    {internal methods}
    procedure DoFormPlacement(Form : TForm);


    {protected properties}
    property Caption : string
      read FCaption write FCaption;
    property Font : TFont
      read FFont write SetFont;
    property Icon : TIcon
      read FIcon write SetIcon;
    property Options : TOvcDialogOptions
      read FOptions write FOptions;
    property Placement : TOvcDialogPlacement
      read FPlacement write FPlacement;

    {protected events}
    property OnHelpClick : TNotifyEvent
      read FOnHelpClick write FOnHelpClick;

  public
  

    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    function Execute : Boolean;
      virtual; abstract;
  end;


implementation


{ new}
function TOvcDialogPlacement.LeftTopUsed: Boolean;
begin
  Result := Position = mpCustom;
end;

constructor TOvcBaseDialog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FFont := TFont.Create;
  FIcon := TIcon.Create;
  FOptions := [doSizeable];
  FPlacement := TOvcDialogPlacement.Create;
  FPlacement.Left := 10;
  FPlacement.Height := 250;
  FPlacement.Top := 10;
  FPlacement.Width := 400;
end;

destructor TOvcBaseDialog.Destroy;
begin
  FFont.Free;
  FFont := nil;

  FIcon.Free;
  FIcon := nil;

  FPlacement.Free;
  FPlacement := nil;

  inherited Destroy;
end;

procedure TOvcBaseDialog.DoFormPlacement(Form : TForm);
begin
  Form.Caption := FCaption;
  Form.Font := FFont;
  Form.Icon := FIcon;

  {set proper style for displayed form}
  if doSizeable in FOptions then
    Form.BorderStyle := bsSizeable
  else
    Form.BorderStyle:= bsDialog;
  if (Screen.ActiveForm <> nil) and
     (Screen.ActiveForm.FormStyle = fsStayOnTop) then
    Form.FormStyle := fsStayOnTop;

  Form.Height := FPlacement.Height;
  Form.Width  := FPlacement.Width;

  {set position}
  case FPlacement.Position of
    mpCenter :
      begin
        Form.Top := (Screen.Height - Form.Height) div 2;
        Form.Left := (Screen.Width - Form.Width) div 2;
      end;
    mpCenterTop :
      begin
        Form.Top := (Screen.Height - Form.Height) div 3;
        Form.Left := (Screen.Width - Form.Width) div 2;
      end;
    mpCustom :
      begin
        Form.Top    := FPlacement.Top;
        Form.Left   := FPlacement.Left;
      end;
  end;
end;

procedure TOvcBaseDialog.SetFont(Value : TFont);
begin
  FFont.Assign(Value);
end;

procedure TOvcBaseDialog.SetIcon(Value : TIcon);
begin
  FICon.Assign(Value);
end;


end.

{*********************************************************}
{*                  OVCEDPOP.PAS 4.06                    *}
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
{$J+} {Writable constants}

unit ovcedpop;
  {-base popup edit field class}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcEditF;

const
  MsgClose = WM_USER+100;
  MsgOpen  = WM_USER+101;

type
  TOvcEdButton = class(TBitBtn)
  public
     procedure Click;
       override;
  end;

  TOvcPopupEvent =
    procedure(Sender : TObject) of object;

  TOvcPopupAnchor = (paLeft, paRight);

  TOvcEdPopup = class(TOvcCustomEdit)
  protected {private}
    {property variables}
    FButton        : TOvcEdButton;
    FButtonGlyph   : TBitmap;
    FPopupActive   : Boolean;
    FPopupAnchor   : TOvcPopupAnchor;
    FOnPopupClose  : TOvcPopupEvent;
    FOnPopupOpen   : TOvcPopupEvent;
    FShowButton    : Boolean;

    {property methods}
    function GetButtonGlyph : TBitmap;
    procedure SetButtonGlyph(Value : TBitmap);
    procedure SetShowButton(Value : Boolean);

    {internal methods}
    function GetButtonWidth : Integer;

    procedure CMDialogKey(var Msg : TCMDialogKey);
      message CM_DIALOGKEY;

  protected
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    function GetButtonEnabled : Boolean;
      dynamic;
    procedure GlyphChanged;
      dynamic;
    procedure Loaded;
      override;

    procedure OnMsgClose(var M : TMessage);
      message MsgClose;
    procedure OnMsgOpen(var M : TMessage);
      message MsgOpen;

    property PopupAnchor : TOvcPopupAnchor
      read FPopupAnchor write FPopupAnchor;
    property ShowButton : Boolean
      read FShowButton write SetShowButton;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;

    property ButtonGlyph : TBitmap
      read GetButtonGlyph
      write SetButtonGlyph;

    procedure PopupClose(Sender : TObject);
      dynamic;
    procedure PopupOpen;
      dynamic;

    property OnPopupClose : TOvcPopupEvent
      read FOnPopupClose
      write FOnPopupClose;

    property OnPopupOpen : TOvcPopupEvent
      read FOnPopupOpen
      write FOnPopupOpen;

    property PopupActive : Boolean
      read FPopupActive;

    property Controller;
  end;

implementation

{*** TOvcEdButton ***}

procedure TOvcEdButton.Click;
begin
  TOvcEdPopup(Parent).PopupOpen;
end;


{*** TOvcEdPopup ***}

constructor TOvcEdPopup.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  FShowButton := True;
  FButton := TOvcEdButton.Create(Self);
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.Caption := '';
  FButton.TabStop := False;
  FButton.Style := bsNew;

  FButtonGlyph := TBitmap.Create;
end;

procedure TOvcEdPopup.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

procedure TOvcEdPopup.CreateWnd;
begin
  inherited CreateWnd;

  {force button placement}
  SetBounds(Left, Top, Width, Height);

  FButton.Enabled := GetButtonEnabled;
end;


destructor TOvcEdPopup.Destroy;
begin
  {destroy button}
  FButton.Free;
  FButton := nil;

  {destroy button glyph}
  FButtonGlyph.Free;
  FButtonGlyph := nil;

  inherited Destroy;
end;

function TOvcEdPopup.GetButtonEnabled : Boolean;
begin
  Result := not ReadOnly;
end;

function TOvcEdPopup.GetButtonWidth : Integer;
begin
  if FShowButton then begin
    Result := GetSystemMetrics(SM_CXHSCROLL);
    if Assigned(FButtonGlyph) and not FButtonGlyph.Empty then
      if FButtonGlyph.Width + 4 > Result then
        Result := FButtonGlyph.Width + 4;
  end else
    Result := 0;
end;

function TOvcEdPopup.GetButtonGlyph : TBitmap;
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  Result := FButtonGlyph
end;

procedure TOvcEdPopup.GlyphChanged;
begin
end;

procedure TOvcEdPopup.Loaded;
begin
  inherited Loaded;

  if Assigned(FButtonGlyph) then
    FButton.Glyph.Assign(FButtonGlyph);
end;

procedure TOvcEdPopup.OnMsgClose(var M : TMessage);
begin
  if (Assigned(FOnPopupClose)) then
    FOnPopupClose(Self);
end;

procedure TOvcEdPopup.OnMsgOpen(var M : TMessage);
begin
  if (Assigned(FOnPopupOpen)) then
    FOnPopupOpen(Self);
end;


procedure TOvcEdPopup.PopupClose;
begin
  FPopupActive := False;
  PostMessage(Handle, MsgClose, 0, 0);
end;

procedure TOvcEdPopup.PopupOpen;
begin
  FPopupActive := True;
  PostMessage(Handle, MsgOpen, 0, 0);
end;

procedure TOvcEdPopup.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
var
  H : Integer;
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not HandleAllocated then
    Exit;

  if not FShowButton then begin
    FButton.Height := 0;
    FButton.Width := 0;
    Exit;
  end;

  H := ClientHeight;
  if BorderStyle = bsNone then begin
    FButton.Height := H;
    FButton.Width := GetButtonWidth;
    FButton.Left := Width - FButton.Width;
    FButton.Top := 0;
  end else if Ctl3D then begin
    FButton.Height := H;
    FButton.Width := GetButtonWidth;
    FButton.Left := Width - FButton.Width - 4;
    FButton.Top := 0;
  end else begin
    FButton.Height := H - 2;
    FButton.Width := GetButtonWidth;
    FButton.Left := Width - FButton.Width - 1;
    FButton.Top := 1;
  end;
end;

procedure TOvcEdPopup.SetButtonGlyph(Value : TBitmap);
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  if not Assigned(Value) then begin
    FButtonGlyph.Free;
    FButtonGlyph := TBitmap.Create;
  end else
    FButtonGlyph.Assign(Value);

  GlyphChanged;

  FButton.Glyph.Assign(FButtonGlyph);
  SetBounds(Left, Top, Width, Height);
end;

procedure TOvcEdPopup.SetShowButton(Value : Boolean);
begin
  if Value <> FShowButton then begin
    FShowButton := Value;
    {force resize and redisplay of button}
    SetBounds(Left, Top, Width, Height);
  end;
end;

procedure TOvcEdPopup.CMDialogKey(var Msg : TCMDialogKey);
begin
  if PopupActive then begin
    with Msg do begin
      if ((CharCode = VK_RETURN) or (CHarCode = VK_ESCAPE)) then begin
        PopupClose(Self);
        Result := 1;
      end;
    end;
  end else
    inherited;
end;

end.

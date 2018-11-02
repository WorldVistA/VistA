{*********************************************************}
{*                  OVCSPLDG.PAS 4.06                    *}
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

(* Change Log)

  - Access violation if the splash dialog image has not been set. - 9/10/01 PHB.
*)

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcspldg;
  {-splash dialog}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, OvcDlg;

type

  TOvcSplashDialog = class;

  TOvcfrmSplashDlg = class(TForm)
    Image: TImage;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params : TCreateParams);
      override;
  private
    Dialog : TOvcSplashDialog;
  public
  end;


  TOvcSplashDialog = class(TOvcBaseDialog)

  protected {private}
    {property variables}
    FActive         : Boolean;
    FDelay          : Integer;
    FPictureHiRes   : TPicture;
    FPictureLoRes   : TPicture; {256 color}
    FStayOnTop      : Boolean;
    FVisible        : Boolean;

    {event variables}
    FOnClick        : TNotifyEvent;
    FOnClose        : TNotifyEvent;
    FOnDblClick     : TNotifyEvent;

    {internal variables}
    Splash          : TOvcfrmSplashDlg;
    sdSavedOnCreate : TNotifyEvent;

    {property methods}
    procedure SetHiResPicture(Value : TPicture);
    procedure SetLoResPicture(Value : TPicture);
    procedure SetVisible(Value : Boolean);

    {internal methods}
    procedure DoOnClick(Sender: TObject);
    procedure DoOnCreate(Sender : TObject);
    procedure DoOnDblClick(Sender: TObject);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;


    function Execute : Boolean;
      override;
    procedure Close;
    procedure Show;

    property Visible : Boolean
      read FVisible write SetVisible;

  published
    {properties}
    property Placement;

    property Active : Boolean
      read FActive write FActive
      default True;
    property Delay : Integer
      read FDelay write FDelay
      default 0;
    property PictureHiRes : TPicture
      read FPictureHiRes write SetHiResPicture;
    property PictureLoRes : TPicture
      read FPictureLoRes write SetLoResPicture;
    property StayOnTop : Boolean
      read FStayOnTop write FStayOnTop
      default True;

    {events}
    property OnClick : TNotifyEvent
      read FOnClick write FOnClick;
    property OnClose : TNotifyEvent
      read FOnClose write FOnClose;
    property OnDblClick : TNotifyEvent
      read FOnDblClick write FOnDblClick;
  end;


implementation

{$R *.DFM}

{*** TOvcSplashDialog ***}

procedure TOvcfrmSplashDlg.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := WS_POPUP or WS_BORDER;
end;

procedure TOvcfrmSplashDlg.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  Dialog.Close;
end;


{*** TOvcSplashDialog ***}

procedure TOvcSplashDialog.Close;
begin
  if Assigned(Splash) then begin
    if Splash.Timer.Interval <> 1 then begin
      {to avoid letting the user destroy the splash form from}
      {an event handler which, happens to be of the form or a}
      {component on the form, we will always delay the "hide"}
      {by using the timer to trigger it.}
      Splash.Timer.Interval := 1;
      Splash.Timer.Enabled := True;
      Exit;
    end;
    Splash.Timer.Enabled := False;
    Splash.Hide;
    Splash.Free;
    Splash := nil;
    {notify that splash screen has been closed}
    if Assigned(FOnClose) then
      FOnClose(Self);
  end;
  FVisible := False;
end;

constructor TOvcSplashDialog.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {hook forms OnCreate}
  if not (csDesigning in ComponentState) then
    if Owner is TForm then begin
      sdSavedOnCreate := TForm(Owner).OnCreate;
      TForm(Owner).OnCreate := DoOnCreate;
    end;

  FActive := True;
  FOptions := [];
  FPictureHiRes := TPicture.Create;
  FPictureLoRes := TPicture.Create;
  FStayOnTop := True;
end;

destructor TOvcSplashDialog.Destroy;
begin
  if Assigned(Splash) and not (csDestroying in ComponentState) then
    Splash.Free;

  FPictureHiRes.Free;
  FPictureHiRes := nil;
  FPictureLoRes.Free;
  FPictureLoRes := nil;

  inherited Destroy;
end;

procedure TOvcSplashDialog.DoOnClick(Sender: TObject);
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TOvcSplashDialog.DoOnDblClick(Sender: TObject);
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

procedure TOvcSplashDialog.DoOnCreate(Sender : TObject);
begin
  if FActive then
    Show;
  if Assigned(sdSavedOnCreate) then begin
    sdSavedOnCreate(Sender);
    {unhook from form's OnCreate}
    TForm(Owner).OnCreate := sdSavedOnCreate;
  end;
end;

function TOvcSplashDialog.Execute : Boolean;
begin
  Show;
  Result := True;
end;

procedure TOvcSplashDialog.SetHiResPicture(Value : TPicture);
begin
  FPictureHiRes.Assign(Value);
end;

procedure TOvcSplashDialog.SetLoResPicture(Value : TPicture);
begin
  FPictureLoRes.Assign(Value);
end;

procedure TOvcSplashDialog.SetVisible(Value : Boolean);
begin
  if Value then
    Show
  else
    Close;
end;

procedure TOvcSplashDialog.Show;
var
  DC           : hDC;
  BitsPerPixel : Word;
begin
{ - begin}
  // if there is no image assigned then fail and bail...
  { - Modified }
  if (FPictureHiRes.Graphic = nil) and (FPictureLoRes.Graphic = nil) then
    exit;
{ - end}

  if not Assigned(Splash) then
    Splash := TOvcfrmSplashDlg.Create(Application);

  Splash.Dialog := Self;
  Splash.Image.OnClick := DoOnClick;
  Splash.Image.OnDblClick := DoOnDblClick;

  DC := GetDC(0);
  try
    BitsPerPixel := GetDeviceCaps(DC, PLANES) * GetDeviceCaps(DC, BITSPIXEL);
  finally
    ReleaseDC(0, DC);
  end;

  if (FPictureLoRes.Graphic <> nil) and
     not FPictureLoRes.Graphic.Empty and (BitsPerPixel < 8) then
    Splash.Image.Picture.Assign(FPictureLoRes)
  else
    Splash.Image.Picture.Assign(FPictureHiRes);

  DoFormPlacement(Splash);

  case FPlacement.Position of
    mpCenter :
      begin
        Splash.ClientWidth := Splash.Image.Picture.Graphic.Width;
        Splash.ClientHeight := Splash.Image.Picture.Graphic.Height;
        Splash.Top := (Screen.Height - Splash.ClientHeight) div 2;
        Splash.Left := (Screen.Width - Splash.ClientWidth) div 2;
      end;
    mpCenterTop :
      begin
        Splash.ClientWidth := Splash.Image.Picture.Graphic.Width;
        Splash.ClientHeight := Splash.Image.Picture.Graphic.Height;
        Splash.Top := (Screen.Height - Splash.ClientHeight) div 3;
        Splash.Left := (Screen.Width - Splash.ClientWidth) div 2;
      end;
    mpCustom :
      begin
        Splash.Top  := FPlacement.Top;
        Splash.Left := FPlacement.Left;
        Splash.Image.Stretch := True;
      end;
  end;

  if FStayOnTop then
    Splash.FormStyle := fsStayOnTop
  else
    Splash.FormStyle := fsNormal;

  if FDelay > 0 then begin
    Splash.Timer.Interval := FDelay;
    Splash.Timer.Enabled := True;
  end;

  Splash.Show;
  Splash.Update;
  FVisible := True;
end;


end.

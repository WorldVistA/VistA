{*********************************************************}
{*                    OVCABTN.PAS 4.06                   *}
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


unit ovcabtn;
  {-Attached Button component}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics,
  Menus, Messages, SysUtils, OvcConst, OvcData, OvcExcpt, OvcVer;

type
  {position of button when attached to a control}
  TOvcButtonPosition = (bpRight, bpLeft, bpTop, bpBottom);

type
  TOvcAttachedButton = class(TBitBtn)

  protected {private}
    {property instance variables}
    FAttachedControl : TWinControl;
    FAttachTwoWay    : Boolean;
    FPosition        : TOvcButtonPosition;
    FSeparation      : Integer;

    {private instance variables}
    abNewWndProc     : Pointer;
    abPrevWndProc    : Pointer;
    abSizing         : Boolean;

    {property methods}
    function GetAbout : string;
    procedure SetAbout(const Value : string);
    procedure SetAttachedControl(Value : TWinControl);
    procedure SetAttachTwoWay(Value : Boolean);
    procedure SetPosition(Value : TOvcButtonPosition);
    procedure SetSeparation(Value : Integer);

    {internal methods}
    procedure abHookControl;
    procedure abSetButtonBounds(CR : TRect);
    procedure abSetControlBounds;
    procedure abUnHookControl;
    procedure abWndProc(var Msg : TMessage);
      {-window procedure}

    {private message response methods}
    procedure OMRecreateWnd(var Msg : TMessage);
      message OM_RECREATEWND;

  protected
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;

  published
    property About : string
      read GetAbout write SetAbout stored False;
    property AttachedControl : TWinControl
      read FAttachedControl write SetAttachedControl;
    property AttachTwoWay : Boolean
      read FAttachTwoWay write SetAttachTwoWay
      default False;
    property Position : TOvcButtonPosition
      read FPosition write SetPosition
      default bpRight;
    property Separation : Integer
      read FSeparation write SetSeparation;
  end;


implementation

{*** TOvcAttachedButton ***}

procedure TOvcAttachedButton.abHookControl;
var
  P : Pointer;
begin
  {hook into attached control's window procedure}
  if (AttachedControl <> nil) then begin
    AttachedControl.HandleNeeded;

    {save original window procedure if not already saved}
    P := Pointer(GetWindowLong(AttachedControl.Handle, GWL_WNDPROC));

    if (P <> abNewWndProc) then begin
      abPrevWndProc := Pointer(GetWindowLong(AttachedControl.Handle, GWL_WNDPROC));

      {change to ours}
      SetWindowLong(AttachedControl.Handle, GWL_WNDPROC, NativeInt(abNewWndProc));
    end;
  end;
end;

procedure TOvcAttachedButton.abSetButtonBounds(CR : TRect);
begin
  if abSizing then
    Exit;

  abSizing := True;
  try
    case FPosition of
      bpRight  : SetBounds(CR.Right + Separation, CR.Top, Width, CR.Bottom-CR.Top);
      bpLeft   : SetBounds(CR.Left - Width - Separation, CR.Top, Width, CR.Bottom-CR.Top);
      bpTop    : SetBounds(CR.Left, CR.Top-Height - Separation, CR.Right-CR.Left, Height);
      bpBottom : SetBounds(CR.Left, CR.Bottom + Separation, CR.Right-CR.Left, Height);
    end;
  finally
    abSizing := False;
  end;
end;

procedure TOvcAttachedButton.abSetControlBounds;
var
  acW : Integer;
  acH : Integer;
begin
  if abSizing then
    Exit;

  if (AttachedControl = nil) then
    Exit;

  if not FAttachTwoWay then
    Exit;

  abSizing := True;
  try
    acW := AttachedControl.Width;
    acH := AttachedControl.Height;
    case FPosition of
      bpRight  : AttachedControl.SetBounds(Left-acW-Separation, Top, acW, Height);
      bpLeft   : AttachedControl.SetBounds(Left+Width+Separation, Top, acW, Height);
      bpTop    : AttachedControl.SetBounds(Left, Top+Height+Separation, Width, acH);
      bpBottom : AttachedControl.SetBounds(Left, Top-acH-Separation, Width, acH);
    end;
  finally
    abSizing := False;
  end;
end;

procedure TOvcAttachedButton.abUnHookControl;
begin
  if (AttachedControl <> nil) then begin
    if Assigned(abPrevWndProc) and AttachedControl.HandleAllocated then
      SetWindowLong(AttachedControl.Handle, GWL_WNDPROC, NativeInt(abPrevWndProc));
  end;
  abPrevWndProc := nil;
end;

procedure TOvcAttachedButton.abWndProc(var Msg : TMessage);
begin
  if (AttachedControl <> nil) then begin
    with Msg do
      if Assigned(abPrevWndProc) then
        Result := CallWindowProc(abPrevWndProc,
          AttachedControl.Handle, Msg, wParam, lParam)
      else
        Result := CallWindowProc(DefWndProc,
          AttachedControl.Handle, Msg, wParam, lParam);
    try
      case Msg.Msg of
        WM_SIZE, WM_MOVE :
          abSetButtonBounds(AttachedControl.BoundsRect);
      end;
    except
      Application.HandleException(Self);
    end
  end;

  with Msg do begin
    if Msg = WM_DESTROY then begin
      {the window handle for the attached control has been destroyed}
      {we need to un-attach and then re-attach (if possible)}
      abUnHookControl;
      if not (csDestroying in ComponentState) then
        PostMessage(Handle, OM_RECREATEWND, 0, 0);
    end;

    {if we get this message, we must be attached -- return self}
    if Msg = OM_ISATTACHED then
      Result := NativeInt(Self);
  end;
end;

constructor TOvcAttachedButton.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  {create a callable window proc pointer}
    abNewWndProc := Classes.MakeObjectInstance(abWndProc);

  {initialize inherited properties}
  Width  := 21;
  Height := 21;

  {initialize property variables}
  FAttachTwoWay := False;
  FPosition     := bpRight;
  FSeparation   := 1;
end;

procedure TOvcAttachedButton.CreateWnd;
begin
  inherited CreateWnd;

  {hook into attached control's window procedure}
  abHookControl;

  {adjust our position and size}
  if (AttachedControl <> nil) and AttachedControl.HandleAllocated then
    abSetButtonBounds(AttachedControl.BoundsRect);
end;

destructor TOvcAttachedButton.Destroy;
begin
  {unhook from attached control's window procedure}
  abUnHookControl;
  FAttachedControl := nil;

  Classes.FreeObjectInstance(abNewWndProc);
  abNewWndProc := nil;

  inherited Destroy;
end;

function TOvcAttachedButton.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcAttachedButton.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = AttachedControl) and (Operation = opRemove) then
    AttachedControl := nil;
end;

procedure TOvcAttachedButton.OMRecreateWnd(var Msg : TMessage);
begin
  RecreateWnd;
end;

procedure TOvcAttachedButton.SetAttachedControl(Value : TWinControl);
var
  WC : TWinControl;
begin
  if Value <> FAttachedControl then begin

    {unhook from attached control's window procedure}
    abUnHookControl;

    {insure that we are the only one to hook to this control}
    if not (csLoading in ComponentState) and Assigned(Value) then begin
      {send message asking if this control is attached to anything}
      {the control itself won't be able to respond unless it is attached}
      {in which case, it will be our hook into the window procedure that}
      {is actually responding}

      if Value.HandleAllocated then begin
        WC := TWinControl(SendMessage(Value.Handle, OM_ISATTACHED, 0, 0));
        if Assigned(WC) then
          raise EOvcException.CreateFmt(GetOrphStr(SCControlAttached) , [WC.Name]);
      end;
    end;

    FAttachedControl := Value;
    RecreateWnd;
  end;
end;

procedure TOvcAttachedButton.SetAttachTwoWay(Value : Boolean);
begin
  if (Value <> FAttachTwoWay) then begin
    FAttachTwoWay := Value;
  end;
end;

procedure TOvcAttachedButton.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
var
  L, T, H, W : Integer;
begin
  {if anything changes, may need to adjust attached control}
  L := Left;
  T := Top;
  H := Height;
  W := Width;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if (L <> Left) or (T <> Top) or (H <> Height) or (W <> Width) then
    abSetControlBounds;
end;

procedure TOvcAttachedButton.SetPosition(Value : TOvcButtonPosition);
begin
  if (Value <> FPosition) then begin
    FPosition := Value;
    if not (csLoading in ComponentState) then
      if (AttachedControl <> nil) then
        abSetButtonBounds(AttachedControl.BoundsRect);
  end;
end;

procedure TOvcAttachedButton.SetSeparation(Value : Integer);
begin
  if (Value <> FSeparation) then begin
    FSeparation := Value;
    if not (csLoading in ComponentState) then
      if (AttachedControl <> nil) then
        abSetButtonBounds(AttachedControl.BoundsRect);
  end;
end;

procedure TOvcAttachedButton.SetAbout(const Value : string);
begin
end;


end.

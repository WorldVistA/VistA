{*********************************************************}
{*                    OVCBORDR.PAS 4.06                  *}
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

unit ovcbordr;
  {Old style, To be deprecated - simple, single, solid borders for entry
   controls}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcConst, OvcData,
  OvcMisc, OvcEditF;

type
  TOvcBorderStyle = (bpsSolid);

  TOvcBorderEdButton = class(TBitBtn)
  public
     procedure Click; override;
  end;

  TOvcBorder = class(TPersistent)
  protected {private}
    FEnabled     : Boolean;         {is border used}
    FBorderStyle : TOvcBorderStyle; {bpsSolid only for now}
    FPenColor    : TColor;          {color of pen}
    FPenStyle    : TPenStyle;       {Windows pen style}
    FPenWidth    : integer;         {width of pen}

    FOnChange : TNotifyEvent;  {notify owner of changes}

  protected
    procedure DoOnChange;
    procedure SetDefaults;

    procedure SetEnabled(Value : Boolean);
    procedure SetBorderStyle(Value : TOvcBorderStyle);
    procedure SetPenColor(Value : TColor);
    procedure SetPenStyle(Value : TPenStyle);
    procedure SetPenWidth(Value : integer);

  public
    procedure Assign(Value : TPersistent); override;
    constructor Create;

  published
    property BorderStyle : TOvcBorderStyle
      read FBorderStyle
      write SetBorderStyle
      stored FEnabled
      default bpsSolid;

    property Enabled : Boolean
      read FEnabled
      write SetEnabled
      default False;

    property OnChange : TNotifyEvent
      read FOnChange
      write FOnChange;

    property PenColor : TColor
      read FPenColor
      write SetPenColor
      stored FEnabled
      default clBlack;

    property PenStyle : TPenStyle
      read FPenStyle
      write SetPenStyle
      stored FEnabled
      default psSolid;

    property PenWidth : integer
      read FPenWidth
      write SetPenWidth
      stored FEnabled
      default 2;
  end;


  TOvcBorders = class(TPersistent)
  protected {private}
    FLeftBorder    : TOvcBorder;
    FRightBorder   : TOvcBorder;
    FTopBorder     : TOvcBorder;
    FBottomBorder  : TOvcBorder;

  public
    procedure Assign(Source : TPersistent); override;
    constructor Create;
    destructor  Destroy; override;

  published
    property BottomBorder : TOvcBorder
      read FBottomBorder
      write FBottomBorder;

    property LeftBorder : TOvcBorder
      read FLeftBorder
      write FLeftBorder;

    property RightBorder : TOvcBorder
      read FRightBorder
      write FRightBorder;

    property TopBorder : TOvcBorder
      read FTopBorder
      write FTopBorder;
  end;

  TOvcBorderParent = class(TOvcCustomControl)

  protected {private}
    {property variables}
    FBorders       : TOvcBorders;
    FEdit          : TOvcCustomEdit;
    FLabelInfo     : TOvcLabelInfo;

    FOrgHeight     : integer;

  protected
    DefaultLabelPosition : TOvcLabelPosition;
    DoingBorders : Boolean;

    procedure BorderChanged(ABorder : TObject);
    function  GetAttachedLabel : TOvcAttachedLabel;
    procedure Paint; override;
    procedure PaintBorders; virtual;

    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KillFOCUS;

    {internal methods}
    procedure LabelChange(Sender : TObject);
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure PositionLabel;

    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;

    procedure OrAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OrPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OrRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;


    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;

  public
    ButtonWidth  : integer;
    DoShowButton : Boolean;

    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;
    procedure SetEditControl(EC : TOvcCustomEdit); virtual;

    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;

    property Canvas;

    property EditControl : TOvcCustomEdit
      read FEdit
      write FEdit;

  published
    property Borders : TOvcBorders
      read FBorders
      write FBorders;

    property LabelInfo : TOvcLabelInfo
      read FLabelInfo
      write FLabelInfo;
  end;

implementation

uses
  OvcBCalc;

procedure TOvcBorderEdButton.Click;
begin
  TOvcBorderEdPopup(Parent).PopupOpen;
end;

{******************************************************************************}
{                                 TOvcBorder                                   }
{******************************************************************************}
constructor TOvcBorder.Create;
begin
  inherited Create;
  SetDefaults;
end;


procedure TOvcBorder.Assign(Value : TPersistent);
var
  B : TOvcBorder absolute Value;
begin
  if (Value <> nil) and (Value is TOvcBorder) then begin
    Enabled    := B.Enabled;
    PenColor   := B.PenColor;
    PenStyle   := B.PenStyle;
    PenWidth   := B.PenWidth;
  end else
    inherited Assign(Value);
end;


procedure TOvcBorder.DoOnChange;
begin
  if (Assigned(FOnChange)) then
    FOnChange(Self);
end;


procedure TOvcBorder.SetDefaults;
begin
  FEnabled   := False;
  FPenColor  := clBlack;
  FPenStyle  := psSolid;
  FPenWidth  := 2;
end;

procedure TOvcBorder.SetBorderStyle(Value : TOvcBorderStyle);
begin
  if (FBorderStyle <> Value) then begin
    FBorderStyle := Value;
    DoOnChange;
  end;
end;


procedure TOvcBorder.SetEnabled(Value : Boolean);
begin
  if (FEnabled <> Value) then begin
    FEnabled := Value;
    DoOnChange;
  end;
end;


procedure TOvcBorder.SetPenColor(Value : TColor);
begin
  if (FPenColor <> Value) then begin
    FPenColor := Value;
    DoOnChange;
  end;
end;


procedure TOvcBorder.SetPenStyle(Value : TPenStyle);
begin
  if (FPenStyle <> Value) then begin
    FPenStyle := Value;
    DoOnChange;
  end;
end;


procedure TOvcBorder.SetPenWidth(Value : integer);
begin
  if (FPenWidth <> Value) and (Value > 0) then begin
    FPenWidth := Value;
    DoOnChange;
  end;
end;

{******************************************************************************}
{                               TOvcBorders                                    }
{******************************************************************************}

constructor TOvcBorders.Create;
begin
  inherited Create;

  FBottomBorder := TOvcBorder.Create;
  FLeftBorder   := TOvcBorder.Create;
  FRightBorder  := TOvcBorder.Create;
  FTopBorder    := TOvcBorder.Create;
end;

destructor  TOvcBorders.Destroy;
begin
  FBottomBorder.Free;
  FBottomBorder := nil;

  FLeftBorder.Free;
  FLeftBorder := nil;

  FRightBorder.Free;
  FRightBorder := nil;

  FTopBorder.Free;
  FTopBorder := nil;

  inherited Destroy;
end;

procedure TOvcBorders.Assign(Source : TPersistent);
var
  B : TOvcBorders absolute Source;
begin
  if (Source <> nil) and (Source is TOvcBorders) then begin
    FBottomBorder.Assign(B.BottomBorder);
    FLeftBorder.Assign(B.LeftBorder);
    FRightBorder.Assign(B.RightBorder);
    FTopBorder.Assign(B.TopBorder);
  end else
    inherited Assign(Source);
end;


{******************************************************************************}
{                               TOvcBorderParent                               }
{******************************************************************************}

procedure TOvcBorderParent.BorderChanged(ABorder : TObject);
begin
  PaintBorders;
end;


procedure TOvcBorderParent.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;


constructor TOvcBorderParent.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  Parent := TWinControl(AOwner);

  Height := 21;
  Width := 121;

  FOrgHeight := 21;

  ControlStyle := ControlStyle - [csSetCaption];

  ParentColor := True;
  Ctl3D       := False;


  {set default position and reference point}
  DefaultLabelPosition := lpTopLeft;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;

  {create borders class and assign notifications}
  FBorders := TOvcBorders.Create;

  FBorders.LeftBorder.OnChange   := BorderChanged;
  FBorders.RightBorder.OnChange  := BorderChanged;
  FBorders.TopBorder.OnChange    := BorderChanged;
  FBorders.BottomBorder.OnChange := BorderChanged;
end;

destructor TOvcBorderParent.Destroy;
begin
  {detatch and destroy label, if any}
  FLabelInfo.Visible := False;

  {dispose the borders object}
  FBorders.Free;
  FLabelInfo.Free;
  FBorders := nil;
  FLabelInfo := nil;

  inherited Destroy;
end;

function TOvcBorderParent.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;


procedure TOvcBorderParent.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  if (Assigned(FEdit)) then
    FEdit.SetFocus;
end;

procedure TOvcBorderParent.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;
end;

procedure TOvcBorderParent.LabelAttach(Sender : TObject; Value : Boolean);
var
  PF : TWinControl;
  S  :string;
begin
  if csLoading in ComponentState then
    Exit;

  PF := GetImmediateParentForm(Self);
  if Value then begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := TOvcAttachedLabel.CreateEx(PF, Self);
      FLabelInfo.ALabel.Parent := Parent;

      S := GenerateComponentName(PF, Name + 'Label');
      FLabelInfo.ALabel.Name := S;
      FLabelInfo.ALabel.Caption := S;

      FLabelInfo.SetOffsets(0, 0);
      PositionLabel;
      FLabelInfo.ALabel.BringToFront;
      {turn off auto size}
      TLabel(FLabelInfo.ALabel).AutoSize := False;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;


procedure TOvcBorderParent.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;


procedure TOvcBorderParent.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure TOvcBorderParent.Notification(AComponent : TComponent; Operation: TOperation);
var
  PF : TWinControl;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := GetImmediateParentForm(Self);
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end
    end;
  end;
end;


procedure TOvcBorderParent.OrAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;


procedure TOvcBorderParent.OrPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin
    if DefaultLabelPosition = lpTopLeft then begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top;
    end else begin
      DX := FLabelInfo.ALabel.Left - Left;
      DY := FLabelInfo.ALabel.Top - Top - Height;
    end;
    if (DX <> FLabelInfo.OffsetX) or (DY <> FLabelInfo.OffsetY) then
      PositionLabel;
  end;
end;


procedure TOvcBorderParent.OrRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the reattachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
                          FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
                          FLabelInfo.ALabel.Top - Top - Height);
  end;
end;


procedure TOvcBorderParent.PositionLabel;
begin
  if FLabelInfo.Visible and Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) and
     not (csLoading in ComponentState) then begin

    if DefaultLabelPosition = lpTopLeft then begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY - FLabelInfo.ALabel.Height + Top,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end else begin
      FLabelInfo.ALabel.SetBounds(Left + FLabelInfo.OffsetX,
                         FLabelInfo.OffsetY + Top + Height,
                         FLabelInfo.ALabel.Width, FLabelInfo.ALabel.Height);
    end;
  end;
end;


procedure TOvcBorderParent.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not HandleAllocated then
    Exit;

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;


procedure TOvcBorderParent.SetEditControl(EC : TOvcCustomEdit);
begin
  FEdit := EC;
end;


procedure TOvcBorderParent.Paint;
begin
  PaintBorders;
end;

procedure TOvcBorderParent.PaintBorders;
var
  R  : TRect;
  C  : TCanvas;
  W  : integer;
  BW : integer;
begin
  Height := FOrgHeight;


  C := Canvas;
  if DoShowButton then
    W := ButtonWidth + 4
  else
    W := 0;

  if (FBorders.LeftBorder.Enabled) then
    FEdit.Left := FBorders.LeftBorder.PenWidth
  else
    FEdit.Left := 0;

  if (FBorders.TopBorder.Enabled) then
    FEdit.Top := FBorders.TopBorder.PenWidth
  else
    FEdit.Top := 0;

  if (not (FBorders.LeftBorder.Enabled or FBorders.RightBorder.Enabled)) then
    FEdit.Width := Width
  else begin
    BW := W;
    if (FBorders.LeftBorder.Enabled) then
      BW := FBorders.LeftBorder.PenWidth;
    if (FBorders.RightBorder.Enabled) then
      BW := BW + FBorders.RightBorder.PenWidth;
    FEdit.Width := Width - BW;
  end;

  if (not (FBorders.TopBorder.Enabled or FBorders.BottomBorder.Enabled)) then
{    Height := FEdit.Height}
    FEdit.Height := Height
  else begin
    BW := 0;
    if (FBorders.TopBorder.Enabled) then
      BW := FBorders.TopBorder.PenWidth;
    if (FBorders.BottomBorder.Enabled) then
      BW := BW + FBorders.BottomBorder.PenWidth;

    FEdit.Height := Height - BW;
  end;

  R.Left   := 0;
  R.Top    := 0;
  R.Right  := Width;
  R.Bottom := Height;

  if (Assigned(FBorders.FLeftBorder)) then begin
    if (FBorders.LeftBorder.Enabled) then begin
      C.Pen.Color := FBorders.LeftBorder.PenColor;
      C.Pen.Width := FBorders.LeftBorder.PenWidth;
      C.Pen.Style := FBorders.LeftBorder.PenStyle;

      C.MoveTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Top);
      C.LineTo(R.Left + (FBorders.LeftBorder.PenWidth div 2), R.Bottom);
    end;
  end;

  if (Assigned(FBorders.FRightBorder)) then begin
    if (FBorders.RightBorder.Enabled) then begin
      C.Pen.Color := FBorders.RightBorder.PenColor;
      C.Pen.Width := FBorders.RightBorder.PenWidth;
      C.Pen.Style := FBorders.RightBorder.PenStyle;

      if ((FBorders.RightBorder.PenWidth mod 2) = 0) then begin
        C.MoveTo(R.Right - (FBorders.RightBorder.PenWidth div 2), R.Top);
        C.LineTo(R.Right - (FBorders.RightBorder.PenWidth div 2), R.Bottom);
      end else begin
        C.MoveTo(R.Right - (FBorders.RightBorder.PenWidth div 2) - 1, R.Top);
        C.LineTo(R.Right - (FBorders.RightBorder.PenWidth div 2) - 1, R.Bottom);
      end;
    end;
  end;

  if (Assigned(FBorders.FTopBorder)) then begin
    if (FBorders.TopBorder.Enabled) then begin
      C.Pen.Color := FBorders.TopBorder.PenColor;
      C.Pen.Width := FBorders.TopBorder.PenWidth;
      C.Pen.Style := FBorders.TopBorder.PenStyle;

      C.MoveTo(R.Left, R.Top + (FBorders.TopBorder.PenWidth div 2));
      C.LineTo(R.Right, R.Top + (FBorders.TopBorder.PenWidth div 2));
    end;
  end;

  if (Assigned(FBorders.FBottomBorder)) then begin
    if (FBorders.BottomBorder.Enabled) then begin
      C.Pen.Color := FBorders.BottomBorder.PenColor;
      C.Pen.Width := FBorders.BottomBorder.PenWidth;
      C.Pen.Style := FBorders.BottomBorder.PenStyle;

      if ((FBorders.BottomBorder.PenWidth mod 2) = 0) then begin
        C.MoveTo(R.Left, R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
        C.LineTo(R.Right - (FBorders.BottomBorder.PenWidth div 2),
                 R.Bottom - (FBorders.BottomBorder.PenWidth div 2));
      end else begin
        C.MoveTo(R.Left, R.Bottom - (FBorders.BottomBorder.PenWidth div 2) - 1);
        C.LineTo(R.Right, R.Bottom - (FBorders.BottomBorder.PenWidth div 2) - 1);
      end;
    end;
  end;
  if (Assigned(FEdit)) then
    FEdit.Refresh;
  ValidateRect(Handle, @R);
end;

end.




{*********************************************************}
{*                   OVCEDITF.PAS 4.06                   *}
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

unit ovceditf;
  {-old style base edit field class w/ attached label}
  {to be deprecated in a future release}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcConst, OvcData, OvcExcpt, OvcVer,
  OvcMisc;

type
  TOvcCustomEdit = class(TCustomEdit)
  protected {private}
    {property variables}
    FController  : TOvcController;
    FLabelInfo   : TOvcLabelInfo;
    {property methods}
    function GetAbout : string;
    function GetAttachedLabel : TOvcAttachedLabel;
    procedure SetAbout(const Value : string);
    procedure SetController(Value : TOvcController);
    {internal methods}
    procedure LabelChange(Sender : TObject);
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure PositionLabel;
    {VCL message methods}
    procedure CMVisibleChanged(var Msg : TMessage); message CM_VISIBLECHANGED;
    procedure OrAssignLabel(var Msg : TMessage); message OM_ASSIGNLABEL;
    procedure OrPositionLabel(var Msg : TMessage); message OM_POSITIONLABEL;
    procedure OrRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;
  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;
    procedure CreateWnd; override;
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;
    function ControllerAssigned : Boolean;
    property About : string read GetAbout write SetAbout stored False;
    property LabelInfo : TOvcLabelInfo read FLabelInfo write FLabelInfo;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property AttachedLabel : TOvcAttachedLabel read GetAttachedLabel;
    property Controller : TOvcController read FController write SetController;
  end;

  TOvcEdit = class(TOvcCustomEdit)
  published
    {properties}
    property Anchors;
    property BiDiMode;
    property ParentBiDiMode;
    property Constraints;
    property DragKind;
    property About;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property LabelInfo;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    {events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnStartDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

{===== TOvcCustomEdit ================================================}

procedure TOvcCustomEdit.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;
{=====}

function TOvcCustomEdit.ControllerAssigned : Boolean;
begin
  Result := Assigned(FController);
end;
{=====}

constructor TOvcCustomEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  {set default position and reference point}
  DefaultLabelPosition := lpTopLeft;

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
end;
{=====}

procedure TOvcCustomEdit.CreateWnd;
var
  OurForm : TWinControl;
begin
  OurForm := GetImmediateParentForm(Self);

  {do this only when the component is first dropped on the form, not during loading}
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    ResolveController(OurForm, FController);

  if not Assigned(FController) and not (csLoading in ComponentState) then begin
    {try to find a controller on this form that we can use}
    FController := FindController(OurForm);

    {if not found and we are not designing, use default controller}
    if not Assigned(FController) and not (csDesigning in ComponentState) then
      FController := DefaultController;
  end;

  inherited CreateWnd;
end;
{=====}

destructor TOvcCustomEdit.Destroy;
begin
  {detatch and destroy label, if any}
  FLabelInfo.Visible := False;

  {destroy label info}
  FLabelInfo.Free;
  FLabelInfo := nil;

  inherited Destroy;
end;
{=====}

function TOvcCustomEdit.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;
{=====}

function TOvcCustomEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TOvcCustomEdit.LabelAttach(Sender : TObject; Value : Boolean);
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
{=====}

procedure TOvcCustomEdit.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;
{=====}

procedure TOvcCustomEdit.Notification(AComponent : TComponent; Operation: TOperation);
var
  PF : TWinControl;
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      PF := GetImmediateParentForm(Self);
      if Assigned(PF) and not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end
    end;

  if (AComponent = FController) and (Operation = opRemove) then
    FController := nil
  else if (Operation = opInsert) and (FController = nil) then begin
    if (AComponent is TOvcController) then
      FController := TOvcController(AComponent);
  end;
end;
{=====}

procedure TOvcCustomEdit.OrAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;
{=====}

procedure TOvcCustomEdit.OrPositionLabel(var Msg : TMessage);
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
{=====}

procedure TOvcCustomEdit.OrRecordLabelPosition(var Msg : TMessage);
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
{=====}

procedure TOvcCustomEdit.PositionLabel;
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
{=====}

procedure TOvcCustomEdit.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not HandleAllocated then
    Exit;

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;
{=====}

procedure TOvcCustomEdit.SetController(Value : TOvcController);
begin
  FController := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;
{=====}

procedure TOvcCustomEdit.SetAbout(const Value : string);
begin
end;

end.

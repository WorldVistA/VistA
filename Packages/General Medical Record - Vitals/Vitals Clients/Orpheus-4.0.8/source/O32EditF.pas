{*********************************************************}
{*                   O32EDITF.PAS 4.06                   *}
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

unit o32editf;
  {-base FlexEdit field class w/ attached label}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcConst, OvcData, OvcVer,
  OvcMisc;

type
  {base class for non-OvcController dependent edit fields...}
  TO32CustomEdit = class(TCustomEdit)
  protected {private}
    {property variables}
    FLabelInfo   : TOvcLabelInfo;
    {property methods}
    function GetAbout : string;
    function GetAttachedLabel : TOvcAttachedLabel;
    procedure SetAbout(const Value : string);
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
    property About : string read GetAbout write SetAbout stored False;
    property LabelInfo : TOvcLabelInfo read FLabelInfo write FLabelInfo;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    property AttachedLabel : TOvcAttachedLabel read GetAttachedLabel;
  end;

  TO32Edit = class(TO32CustomEdit)
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

{===== TO32CustomEdit ==============================================}
procedure TO32CustomEdit.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;
{=====}

constructor TO32CustomEdit.Create(AOwner : TComponent);
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

procedure TO32CustomEdit.CreateWnd;
//  OurForm : TWinControl;
begin
//  OurForm := GetImmediateParentForm(Self);
  inherited CreateWnd;
end;
{=====}

destructor TO32CustomEdit.Destroy;
begin
  {detatch and destroy label, if any}
  FLabelInfo.Visible := False;

  {destroy label info}
  FLabelInfo.Free;
  FLabelInfo := nil;

  inherited Destroy;
end;
{=====}

function TO32CustomEdit.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;
{=====}

function TO32CustomEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32CustomEdit.LabelAttach(Sender : TObject; Value : Boolean);
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

procedure TO32CustomEdit.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;
{=====}

procedure TO32CustomEdit.Notification(AComponent : TComponent; Operation: TOperation);
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
end;
{=====}

procedure TO32CustomEdit.OrAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;
{=====}

procedure TO32CustomEdit.OrPositionLabel(var Msg : TMessage);
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

procedure TO32CustomEdit.OrRecordLabelPosition(var Msg : TMessage);
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

procedure TO32CustomEdit.PositionLabel;
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

procedure TO32CustomEdit.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not HandleAllocated then
    Exit;

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;
{=====}

procedure TO32CustomEdit.SetAbout(const Value : string);
begin
end;

end.

{*********************************************************}
{*                    OVCLB.PAS 4.06                    *}
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

unit ovclb;
  {-ListBox that supports internal tab stops}

interface

uses
  Windows, Classes, Controls, Forms, Graphics, Menus, Messages, StdCtrls,
  SysUtils, OvcBase, OvcConst, OvcData, OvcExcpt, OvcMisc, OvcVer;

type
  TOvcCustomListBox = class(TCustomListBox)
  {.Z+}
  protected {private}
    {property variables}
    FController       : TOvcController;
    FHorizontalScroll : Boolean;
    FLabelInfo        : TOvcLabelInfo;
    FTabStops         : TStrings; {in average character positions}

    {event variables}
    FOnTabStopsChange : TNotifyEvent;

    {internal variables}
    tlTabs            : array[0..99] of Integer;
    tlTabsDU          : array[0..99] of Integer;

    {property methods}
    function GetAbout : string;
    procedure SetAbout(const Value : string);
    procedure SetController(Value : TOvcController);
    procedure SetHorizontalScroll(Value : Boolean);
    procedure SetTabStopsStr(Value : TStrings);

    {internal methods}
    function GetAttachedLabel : TOvcAttachedLabel;
    procedure LabelAttach(Sender : TObject; Value : Boolean);
    procedure LabelChange(Sender : TObject);
    procedure PositionLabel;
    function tlGetItemWidth(Index : Integer) : Integer;
    procedure tlSetTabStops;
    procedure tlResetHorizontalExtent; virtual;

    {private message methods}
    procedure OMAssignLabel(var Msg : TMessage);
      message OM_ASSIGNLABEL;
    procedure OMPositionLabel(var Msg : TMessage);
      message OM_POSITIONLABEL;
    procedure OMRecordLabelPosition(var Msg : TMessage);
      message OM_RECORDLABELPOSITION;

    {VCL control methods}
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;
    procedure CMVisibleChanged(var Msg : TMessage);
      message CM_VISIBLECHANGED;


    {windows message handling methods}
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
    procedure LBAddString(var Msg : TMessage);
      message LB_ADDSTRING;
    procedure LBDeleteString(var Msg : TMessage);
      message LB_DELETESTRING;

  protected
    {descendants can set the value of this variable after calling inherited }
    {create to set the default location and point-of-reference (POR) for the}
    {attached label. if dlpTopLeft, the default location and POR will be at }
    {the top left of the control. if dlpBottomLeft, the default location and}
    {POR will be at the bottom left}
    DefaultLabelPosition : TOvcLabelPosition;

    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;

    procedure DoOnTabStopsChanged;
      dynamic;
  {.Z-}

    {properties}
    property About : string
      read GetAbout write SetAbout stored False;
    property HorizontalScroll : Boolean
      read FHorizontalScroll write SetHorizontalScroll;
    property LabelInfo : TOvcLabelInfo
      read FLabelInfo write FLabelInfo;
    property TabStops : TStrings
      read FTabStops write SetTabStopsStr;

    {events}
    property OnTabStopsChange : TNotifyEvent
      read FOnTabStopsChange write FOnTabStopsChange;

  public
  {.Z+}
    constructor Create(AOwner : TComponent);
      override;
    destructor  Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;
  {.Z-}

    procedure ClearTabStops;
    procedure ResetHorizontalScrollbar;
    procedure SetTabStops(const Value : array of Integer);

    property AttachedLabel : TOvcAttachedLabel
      read GetAttachedLabel;
    property Controller : TOvcController
      read FController write SetController;
  end;

  TOvcListBox = class(TOvcCustomListBox)
  published
    {properties}
    {$IFDEF VERSION4}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property About;
    property Align;
    property BorderStyle;
    property Color;
    property Columns;
    property Controller;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property HorizontalScroll default False;
    property IntegralHeight;
    property ItemHeight;
    property LabelInfo;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStops;
    property Items;
    property TabStop;
    property Visible;

    {events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
    property OnTabStopsChange;
  end;


implementation

{*** TOvcCustomListBox ***}

procedure TOvcCustomListBox.ClearTabStops;
begin
  FTabStops.Clear;

  tlSetTabStops;
  Invalidate;

  DoOnTabStopsChanged;
end;

procedure TOvcCustomListBox.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if not HandleAllocated then
    Exit;

  tlSetTabStops;
end;

procedure TOvcCustomListBox.CMVisibleChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  if LabelInfo.Visible then
    AttachedLabel.Visible := Visible;
end;

constructor TOvcCustomListBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FLabelInfo := TOvcLabelInfo.Create;
  FLabelInfo.OnChange := LabelChange;
  FLabelInfo.OnAttach := LabelAttach;
  DefaultLabelPosition := lpTopLeft;

  FTabStops := TStringList.Create;
  {TStringList(FTabStops).Sorted := True;}
end;

procedure TOvcCustomListBox.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Style or LBS_USETABSTOPS;
    if FHorizontalScroll then
      Style := Style or WS_HSCROLL;
  end;
end;

procedure TOvcCustomListBox.CreateWnd;
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

  tlSetTabStops;
end;

destructor TOvcCustomListBox.Destroy;
begin
  FLabelInfo.Visible := False;
  FLabelInfo.Free;
  FLabelInfo := nil;

  FTabStops.Free;
  FTabStops := nil;

  inherited Destroy;
end;

procedure TOvcCustomListBox.DoOnTabStopsChanged;
begin
  if csLoading in ComponentState then
    Exit;

  if Assigned(FOnTabStopsChange) then
    FOnTabStopsChange(Self);
end;

function TOvcCustomListBox.GetAttachedLabel : TOvcAttachedLabel;
begin
  if not FLabelInfo.Visible then
    raise Exception.Create(GetOrphStr(SCLabelNotAttached));

  Result := FLabelInfo.ALabel;
end;

function TOvcCustomListBox.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcCustomListBox.LabelAttach(Sender : TObject; Value : Boolean);
var
  {$IFDEF VERSION5}
  PF : TWinControl;
  {$ELSE}
  PF : TForm;
  {$ENDIF}
  S  : string;
begin
  if csLoading in ComponentState then
    Exit;

  {$IFDEF VERSION5}
  PF := GetImmediateParentForm(Self);
  {$ELSE}
  PF := TForm(GetParentForm(Self));
  {$ENDIF}
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
      FLabelInfo.ALabel.AutoSize := False;
    end;
  end else begin
    if Assigned(PF) then begin
      FLabelInfo.ALabel.Free;
      FLabelInfo.ALabel := nil;
    end;
  end;
end;

procedure TOvcCustomListBox.LabelChange(Sender : TObject);
begin
  if not (csLoading in ComponentState) then
    PositionLabel;
end;

procedure TOvcCustomListBox.Notification(AComponent : TComponent;
          Operation : TOperation);
var
  {$IFDEF VERSION5}
  PF : TWinControl;
  {$ELSE}
  PF : TForm;
  {$ENDIF}
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then begin
    if Assigned(FLabelInfo) and (AComponent = FLabelInfo.ALabel) then begin
      {$IFDEF VERSION5}
      PF := GetImmediateParentForm(Self);
      {$ELSE}
      PF := TForm(GetParentForm(Self));
      {$ENDIF}
      if Assigned(PF) and
         not (csDestroying in PF.ComponentState) then begin
        FLabelInfo.FVisible := False;
        FLabelInfo.ALabel := nil;
      end;
    end else if (AComponent = FController) then
      FController := nil;
  end else if (Operation = opInsert) and (FController = nil) and
          (AComponent is TOvcController) then
    FController := TOvcController(AComponent);
end;

procedure TOvcCustomListBox.OMAssignLabel(var Msg : TMessage);
begin
  FLabelInfo.ALabel := TOvcAttachedLabel(Msg.lParam);
end;

procedure TOvcCustomListBox.OMPositionLabel(var Msg : TMessage);
const
  DX : Integer = 0;
  DY : Integer = 0;
begin
  if FLabelInfo.Visible and
     Assigned(FLabelInfo.ALabel) and
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

procedure TOvcCustomListBox.OMRecordLabelPosition(var Msg : TMessage);
begin
  if Assigned(FLabelInfo.ALabel) and
     (FLabelInfo.ALabel.Parent <> nil) then begin
    {if the label was cut and then pasted, this will complete the re-attachment}
    FLabelInfo.FVisible := True;

    if DefaultLabelPosition = lpTopLeft then
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top + FLabelInfo.ALabel.Height - Top)
    else
      FLabelInfo.SetOffsets(FLabelInfo.ALabel.Left - Left,
        FLabelInfo.ALabel.Top - Top - Height);
  end;
end;

procedure TOvcCustomListBox.PositionLabel;
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

procedure TOvcCustomListBox.ResetHorizontalScrollbar;
begin
  tlResetHorizontalExtent;
end;

procedure TOvcCustomListBox.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if HandleAllocated then
    PostMessage(Handle, OM_POSITIONLABEL, 0, 0);
end;

procedure TOvcCustomListBox.SetController(Value : TOvcController);
begin
  FController := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcCustomListBox.SetHorizontalScroll(Value : Boolean);
begin
  if Value <> FHorizontalScroll then begin
    FHorizontalScroll := Value;
    if not (csLoading in ComponentState) then
      RecreateWnd;
  end;
end;

procedure TOvcCustomListBox.SetTabStops(const Value : array of Integer);
var
  I : Integer;
begin
  FTabStops.Clear;
  for I := Low(Value) to High(Value) do
    FTabStops.Add(IntToStr(Value[I]));

  tlSetTabStops;
  Invalidate;

  DoOnTabStopsChanged;
end;

procedure TOvcCustomListBox.SetTabStopsStr(Value : TStrings);
var
  I : Integer;
begin
  if Assigned(Value) then begin
    {verify each tab value}
    for I := 0 to Value.Count-1 do
      StrToInt(Value[I]);
    FTabStops.Assign(Value);
    {TStringList(FTabStops).Sort;}
  end else
    FTabStops.Clear;

  tlSetTabStops;
  Invalidate;

  DoOnTabStopsChanged;
end;

procedure TOvcCustomListBox.SetAbout(const Value : string);
begin
end;

function TOvcCustomListBox.tlGetItemWidth(Index : Integer) : Integer;
var
  S : string;
begin
  S := Items[Index];
  if  FTabStops.Count > 0 then
    Result := LOWORD(GetTabbedTextExtent(
      Canvas.Handle, @S[1], Length(S), FTabStops.Count, tlTabs))
  else
    Result := Canvas.TextWidth(S);
end;

procedure TOvcCustomListBox.tlResetHorizontalExtent;
var
  I : Integer;
  W : Integer;
  X : Integer;
begin
  if not FHorizontalScroll then
    Exit;

  X := 0;
  for I := 0 to Items.Count - 1 do begin
    W := tlGetItemWidth(I);
    if W > X then
      X := W;
  end;

  SendMessage(Handle, LB_SETHORIZONTALEXTENT, X+5, 0);
end;

procedure TOvcCustomListBox.tlSetTabStops;
var
  DBU  : Integer;
  ACW  : Integer;
  I    : Integer;
  S    : string;
begin
  if not HandleAllocated then
    Exit;

  {get dialog base units}
  DBU := LOWORD(GetDialogBaseUnits);

  {get average character width}
  S := GetOrphStr(SCAlphaString);
  ACW := Canvas.TextWidth(S) div Length(S);

  {fill tab array}
  for I := 0 to FTabStops.Count-1 do begin
    tlTabs[I] := StrToInt(FTabStops[I]) * ACW; {pixel width}
    tlTabsDU[I] := 4*tlTabs[I] div DBU;        {width in dialog units}
  end;

  {set tab stop positions}
  if FTabStops.Count > 0 then
    Perform(LB_SETTABSTOPS, FTabStops.Count, LongInt(@tlTabsDU))
  else
    Perform(LB_SETTABSTOPS, 0, LongInt(nil));

  tlResetHorizontalExtent;
end;

procedure TOvcCustomListBox.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  if csDesigning in ComponentState then
    DefaultHandler(Msg)
  else
    inherited;
end;

procedure TOvcCustomListBox.LBAddString(var Msg : TMessage);
begin
  inherited;
  if HorizontalScroll then
    ResetHorizontalScrollBar;
end;

procedure TOvcCustomListBox.LBDeleteString(var Msg : TMessage);
begin
  inherited;
  if HorizontalScroll then
    ResetHorizontalScrollBar;
end;

end.

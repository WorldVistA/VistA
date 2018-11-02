{*********************************************************}
{*                  OVCDBTIM.PAS 4.06                    *}
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

unit ovcdbtim;
  {-Data aware time edit field w/ popup}

interface

uses
  Windows, Classes, Controls, Db, DbConsts, DbCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcEdTim, OvcEditF;

type
  TOvcCustomDbTimeEdit = class(TOvcTimeEdit)
  

  protected {private}
    FAlignment    : TAlignment;
    FAutoUpdate   : Boolean;
    FCanvas       : TControlCanvas;
    FDataLink     : TFieldDataLink;
    FFocused      : Boolean;
    FPreserveDate : Boolean;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    function GetReadOnly : Boolean;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetFocused(Value : Boolean);
    procedure SetReadOnly(Value : Boolean);

    {internal methods}
    procedure DataChange(Sender : TObject);
    procedure EditingChange(Sender : TObject);
    function  GetTextMargins : TPoint;
    procedure UpdateData(Sender : TObject);

    {message methods}
    procedure WMCut(var Message : TMessage);
      message WM_CUT;
    procedure WMPaste(var Message : TMessage);
      message WM_PASTE;
    procedure WMPaint(var Message : TWMPaint);
      message WM_PAINT;
    procedure CMEnter(var Message : TCMEnter);
      message CM_ENTER;
    procedure CMExit(var Message : TCMExit);
      message CM_EXIT;
    procedure CMGetDataLink(var Message : TMessage);
      message CM_GETDATALINK;

  protected
    procedure Change;
      override;
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure KeyPress(var Key : Char);
      override;
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;


    {protected properties}
    property AutoUpdate : Boolean
      read FAutoUpdate write FAutoUpdate;
    property DataField : string
      read GetDataField write SetDataField;
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;
    property PreserveDate : Boolean
      read FPreserveDate write FPreserveDate;

  

    property ReadOnly : Boolean {hides ancestor's ReadOnly property}
      read GetReadOnly write SetReadOnly;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    {public properties}
    property Field : TField
      read GetField;
  end;

  TOvcDbTimeEdit = class(TOvcCustomDbTimeEdit)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AutoSelect;
    property AutoSize;
    property AutoUpdate;
    property BorderStyle;
    property CharCase;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragMode;
    property DurationDisplay;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property LabelInfo;
    property MaxLength;
    property NowString;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PreserveDate;
    property PrimaryField;
    property ReadOnly;
    property ShowHint;
    property ShowSeconds;
    property ShowUnits;
    property TabOrder;
    property TabStop;
    property TimeMode;
    property UnitsLength;
    property Visible;

    {inherited events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetTime;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSetTime;
    property OnStartDrag;
  end;

implementation

uses
  ovcstr;

const
  TimeFieldTypes : set of  TFieldType = [ftTime, ftDateTime];

{*** TOvcCustomDbTimeEdit ***}

procedure TOvcCustomDbTimeEdit.Change;
begin
  FDataLink.Modified;

  inherited Change;
end;

procedure TOvcCustomDbTimeEdit.CMEnter(var Message : TCMEnter);
begin
  SetFocused(True);

  inherited;
end;

procedure TOvcCustomDbTimeEdit.CMExit(var Message : TCMExit);
var
  WasModified : Boolean;
begin
  if FAutoUpdate then begin
    WasModified := Modified;
    DoExit;    {force update of date}
    try
      if WasModified then
        FDataLink.UpdateRecord;
    except
      SelectAll;
      SetFocus;
      raise;
    end;
  end;
  SetFocused(False);
end;

procedure TOvcCustomDbTimeEdit.CMGetDataLink(var Message : TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

constructor TOvcCustomDbTimeEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  inherited ReadOnly := True;

  ControlStyle := ControlStyle + [csReplicatable];
  FAutoUpdate := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

procedure TOvcCustomDbTimeEdit.DataChange(Sender : TObject);
var
  P  : Integer;
  DT : TDateTime;
  S  : string;
begin
  if FDataLink.Field <> nil then begin
    if FAlignment <> FDataLink.Field.Alignment then begin
      FAlignment := FDataLink.Field.Alignment;
      Text := '';
    end;
    if FDataLink.Field.DataType in TimeFieldTypes then begin
      if FDataLink.Field.IsNull then
        Text := ''
      else begin
        DT := FDataLink.Field.AsDateTime;
        if FTimeMode = tmDuration then
          SetTime(DT)
        else
          SetTime(Frac(DT));
      end;
    end else if FDataLink.Field.DataType = ftFloat then begin
      if FDataLink.Field.IsNull then
        Text := ''
      else begin
        DT := FDataLink.Field.AsFloat;
        if FTimeMode = tmDuration then
          SetTime(DT)
        else
          SetTime(Frac(DT))
      end;
    end else begin
      S := FDataLink.Field.ClassName;
      S[1] := '(';
      P := Pos('Field', S);
      if P > 0 then begin
        S[P] := ')';
        setlength(s,p);
        //S[0] := Char(P);
      end else
        S := Concat(S, ')');
      Text := S;
    end;
  end else begin
    FAlignment := taLeftJustify;
    if csDesigning in ComponentState then
      Text := Name
    else
      Text := '';
  end;
end;

destructor TOvcCustomDbTimeEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  FCanvas.Free;
  FCanvas := nil;

  inherited Destroy;
end;

procedure TOvcCustomDbTimeEdit.EditingChange(Sender : TObject);
begin
  inherited ReadOnly := not FDataLink.Editing;
end;

function TOvcCustomDbTimeEdit.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcCustomDbTimeEdit.GetDataSource : TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TOvcCustomDbTimeEdit.GetField : TField;
begin
  Result := FDataLink.Field;
end;

function TOvcCustomDbTimeEdit.GetReadOnly : Boolean;
begin
  Result := FDataLink.ReadOnly;
  if FDataLink.Field <> nil then
    if not ((FDataLink.Field.DataType in TimeFieldTypes) or
            (FDataLink.Field.DataType = ftFloat)) then
      Result := True;
end;

function TOvcCustomDbTimeEdit.GetTextMargins : TPoint;
var
  DC         : HDC;
  SaveFont   : HFont;
  I          : Integer;
  SysMetrics : TTextMetric;
  Metrics    : TTextMetric;
begin
  if NewStyleControls then begin
    if BorderStyle = bsNone then
      I := 0
    else if Ctl3D then
      I := 1
    else
      I := 2;
    Result.X := SendMessage(Handle, EM_GETMARGINS, 0, 0) and $0000FFFF + I;
    Result.Y := I;
  end else begin
    if BorderStyle = bsNone then
      I := 0
    else begin
      DC := GetDC(0);
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC(0, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then
        I := Metrics.tmHeight;
      I := I div 4;
    end;
    Result.X := I;
    Result.Y := I;
  end;
end;

procedure TOvcCustomDbTimeEdit.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  {start edit mode if cutting or pasting}
  if (Key = VK_DELETE) or ((Key = VK_INSERT) and (ssShift in Shift)) then
    FDataLink.Edit;
end;

procedure TOvcCustomDbTimeEdit.KeyPress(var Key : Char);
begin
  inherited KeyPress(Key);

  if CharInSet(Key, [#32..#255]) and (FDataLink.Field <> nil) and
     not FDataLink.Field.IsValidChar(Key) then begin
    MessageBeep(0);
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255 :
      FDataLink.Edit;
    #27:
      begin
        FDataLink.Reset;
        SelectAll;
        Key := #0;
      end;
  end;
end;

procedure TOvcCustomDbTimeEdit.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then
    DataSource := nil;
end;

procedure TOvcCustomDbTimeEdit.SetDataField(const Value : string);
begin
  try
    FDataLink.FieldName := Value;
  except
    FDataLink.FieldName := '';
    raise;
  end;
end;

procedure TOvcCustomDbTimeEdit.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcCustomDbTimeEdit.SetFocused(Value : Boolean);
begin
  if FFocused <> Value then begin
    FFocused := Value;
    if (FAlignment <> taLeftJustify) then
      Invalidate;
    FDataLink.Reset;
  end;
end;

procedure TOvcCustomDbTimeEdit.SetReadOnly(Value : Boolean);
begin
  FDataLink.ReadOnly := Value;
end;

procedure TOvcCustomDbTimeEdit.UpdateData(Sender : TObject);
var
  DT : TDateTime;
begin
  if FDataLink.Field.DataType in TimeFieldTypes then begin
    DT := FDataLink.Field.AsDateTime;
    if Text = '' then begin
      {save just the date portion}
      if FPreserveDate and (FTimeMode <> tmDuration) and
        (FDataLink.Field.DataType = ftDateTime) and (Trunc(DT) <> 0) then
        FDataLink.Field.AsDateTime := Trunc(DT)
      else
        FDataLink.Field.Clear;
    end else begin
      DoExit;  {validate field and translate date}
      if FPreserveDate and (FTimeMode <> tmDuration) then
        FDataLink.Field.AsDateTime := Trunc(DT) + FTime
      else
        FDataLink.Field.AsDateTime := FTime
    end;
  end else if FDataLink.Field.DataType = ftFloat then begin
    if Text = '' then
      FDataLink.Field.Clear
    else begin
      DoExit;  {validate field and translate date}
      FDataLink.Field.AsFloat := FTime;
    end;
  end else
    FDataLink.Field.Text := Text;
end;

procedure TOvcCustomDbTimeEdit.WMCut(var Message : TMessage);
begin
  FDataLink.Edit;

  inherited;
end;

procedure TOvcCustomDbTimeEdit.WMPaint(var Message : TWMPaint);
var
  Left    : Integer;
  Margins : TPoint;
  R       : TRect;
  DC      : HDC;
  PS      : TPaintStruct;
  S       : string;
begin
  if ((FAlignment = taLeftJustify) or FFocused) and not (csPaintCopy in ControlState) then begin
    inherited;
    Exit;
  end;

  {draw right and center justify manually unless the edit has the focus}
  if FCanvas = nil then begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := Self;
  end;
  DC := Message.DC;
  if DC = 0 then
    DC := BeginPaint(Handle, PS);
  FCanvas.Handle := DC;
  try
    FCanvas.Font := Font;
    with FCanvas do begin
      R := ClientRect;
      if not (NewStyleControls and Ctl3D) and (BorderStyle = bsSingle) then begin
        Brush.Color := clWindowFrame;
        FrameRect(R);
        InflateRect(R, -1, -1);
      end;
      Brush.Color := Color;
      if (csPaintCopy in ControlState) and (FDataLink.Field <> nil) then begin
        S := FDataLink.Field.DisplayText;
      end else
        S := Text;
      if PasswordChar <> #0 then FillChar(S[1], Length(S), PasswordChar);
      Margins := GetTextMargins;
      case FAlignment of
        taLeftJustify  : Left := Margins.X;
        taRightJustify : Left := ClientWidth - TextWidth(S) - Margins.X - 2;
      else
        Left := (ClientWidth - TextWidth(S)) div 2;
      end;
      TextRect(R, Left, Margins.Y, S);
    end;
  finally
    FCanvas.Handle := 0;
    if Message.DC = 0 then
      EndPaint(Handle, PS);
  end;
end;

procedure TOvcCustomDbTimeEdit.WMPaste(var Message : TMessage);
begin
  FDataLink.Edit;

  inherited;
end;

function TOvcCustomDbTimeEdit.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcCustomDbTimeEdit.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

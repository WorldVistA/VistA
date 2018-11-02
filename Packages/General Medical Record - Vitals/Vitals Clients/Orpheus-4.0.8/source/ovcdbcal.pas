{*********************************************************}
{*                  OVCDBCAL.PAS 4.06                    *}
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

unit ovcdbcal;
  {-Data-Aware Calendar component}

interface

uses
  Classes, Controls, Db, DbCtrls, Graphics, Menus, Messages, SysUtils,
  OvcBase, OvcCal, OvcConst, OvcData, OvcExcpt,
  Forms; { for bsNone definition}

type
  TOvcDbCalendar = class(TOvcCustomCalendar)
  

  protected {private}
    {property variables}
    FAutoUpdate  : Boolean;
    FDataLink    : TFieldDataLink;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure calDataChange(Sender : TObject);
    procedure calUpdateData(Sender : TObject);

    {windows message methods}
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;

    {vcl methods}
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

  protected
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure KeyPress(var Key : Char);
      override;

    {dynamic event wrappers}
    procedure DoOnChange(Value : TDateTime);
      override;
    function IsReadOnly : Boolean;
      override;
    procedure SetCalendarDate(Value : TDateTime);
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    property Field : TField
      read GetField;

  published
    property AutoUpdate : Boolean
      read FAutoUpdate
      write FAutoUpdate default False;

    property DataField : string
      read GetDataField
      write SetDataField;

    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle default bsNone;
    property Colors;
    property Color;
    property Ctl3D;
    property Cursor;
    property DateFormat default dfLong;
    property DayNameWidth default 3;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LabelInfo;
    property Options default [cdoShortNames, cdoShowYear, cdoShowInactive, cdoShowRevert, cdoShowToday, cdoShowNavBtns];
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WeekStarts default dtSunday;

    {inherited events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawDate;
    property OnDrawItem;
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


const
  {field types supported}
  SupportedFieldTypes : set of  TFieldType = [ftDate, ftDateTime, ftFloat];


{*** TOvcDbCalendar ***}

procedure TOvcDbCalendar.calDataChange(Sender : TObject);
begin
  if Field <> nil then begin
    {update our display value}
    case Field.DataType of
      ftDate,
      ftDateTime : Self.AsDateTime := Field.AsDateTime;
      ftFloat    : Self.AsDateTime := Field.AsFloat;
    else
      Self.AsDateTime := SysUtils.Date;
    end;
  end else
    Self.AsDateTime := SysUtils.Date;
end;

procedure TOvcDbCalendar.calUpdateData(Sender : TObject);
var
  DT : TDateTime;
begin
  if (DataSource = nil) or (Field = nil) then
    Exit;

  case Field.DataType of
    ftDate     : Field.AsDateTime := Self.AsDateTime;
    ftDateTime :
      begin
        {preserve unedited time portion of field value}
        DT := Field.AsDateTime;
        Field.AsDateTime := Trunc(Self.AsDateTime) + Frac(DT);
      end;
    ftFloat    :
      begin
        DT := Field.AsFloat;
        Field.AsFloat := Trunc(Self.AsDateTime) + Frac(DT);
      end;
  end;
end;

procedure TOvcDbCalendar.CMExit(var Msg : TMessage);
begin
  try
    if FDataLink.Editing then
      FDataLink.UpdateRecord;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TOvcDbCalendar.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbCalendar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {initialize default property values}
  FAutoUpdate               := False;

  {create the data link object}
  FDataLink                 := TFieldDataLink.Create;
  FDataLink.Control         := Self;

  {set notification routines}
  FDataLink.OnActiveChange  := calDataChange;
  FDataLink.OnDataChange    := calDataChange;
  FDataLink.OnUpdateData    := calUpdateData;
end;

destructor TOvcDbCalendar.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

procedure TOvcDbCalendar.DoOnChange(Value : TDateTime);
begin
  FDataLink.Modified;
  inherited DoOnChange(Value);
end;

function TOvcDbCalendar.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbCalendar.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbCalendar.GetField : TField;
begin
  Result := FDataLink.Field;
end;

function TOvcDbCalendar.IsReadOnly : Boolean;
begin
  Result := inherited IsReadOnly or (DataSource = nil) or
            not (DataSource.State in [dsEdit, dsInsert]);
end;

procedure TOvcDbCalendar.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    Refresh;
  end;
end;

procedure TOvcDbCalendar.SetCalendarDate(Value : TDateTime);
begin
  inherited SetCalendarDate(Value);

  if FDataLink.Editing then
    if AutoUpdate then begin
      try
        FDataLink.UpdateRecord;
      except
        SetFocus;
        raise;
      end;
    end;
end;

procedure TOvcDbCalendar.SetDataField(const Value : string);
var
  SaveName : string;
begin
  {save current field name}
  SaveName := FDataLink.FieldName;
  try
    FDataLink.FieldName := Value;
  except
    FDataLink.FieldName := '';
    raise;
  end;

  {see if this is a valid field type}
  if not (csLoading in ComponentState) and (Field <> nil) and
         (csDesigning in ComponentState) and
         not (Field.DataType in SupportedFieldTypes) then begin

    {restore old field name}
    try
      FDataLink.FieldName := SaveName;
    except
      {ignore any errors}
    end;

    raise EOvcException.Create(GetOrphStr(SCInvalidFieldType));
  end;

  if csDesigning in ComponentState then
    RecreateWnd
  else
    Refresh;
end;

procedure TOvcDbCalendar.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);

  Refresh;
end;

procedure TOvcDbCalendar.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  {see if we need to enter edit mode}
  if (DataSource <> nil) then
    if not FDataLink.Editing and DataSource.AutoEdit then
      FDataLink.Edit;

  inherited;
end;

procedure TOvcDbCalendar.WMKeyDown(var Msg : TWMKeyDown);
begin
  {see if we need to enter edit mode}
  if (DataSource <> nil) then
    if not FDataLink.Editing and DataSource.AutoEdit then
      FDataLink.Edit;

  inherited;
end;

procedure TOvcDbCalendar.KeyPress(var Key : Char);
begin
  case Key of
    #13 : calUpdateData(Self);       {date selected}
    #32 : calUpdateData(Self);       {date selected}
  end;
  inherited KeyPress(Key);
end;

function TOvcDbCalendar.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbCalendar.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

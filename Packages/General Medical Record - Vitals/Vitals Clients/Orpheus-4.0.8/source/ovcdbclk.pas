{*********************************************************}
{*                  OVCDBCLK.PAS 4.06                    *}
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

unit ovcdbclk;
  {-Data-Aware Clock component}

interface

uses
  Classes, Controls, Db, DbCtrls, Forms, Graphics, Menus, Messages, OvcBase,
  OvcClock, OvcConst, OvcData, OvcExcpt, SysUtils;

type
  TOvcDbClock = class(TOvcCustomClock)
  protected {private}
    {property variables}
    FDataLink : TFieldDataLink;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure clkDataChange(Sender : TObject);

    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

  protected
    procedure Notification(AComponent : TComponent; Operation : TOperation);
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
    property DataField : string
      read GetDataField
      write SetDataField;

    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    {properties}
    property Anchors;
    property Constraints;
    property About;
    property Align;
    property Color;
    property Controller;
    property ClockFace;
    property DrawMarks default True;
    property Hint;
    property HandOptions;
    property LabelInfo;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TimeOffset default 0;
    property Visible;
    property DigitalOptions;
    property DisplayMode default dmAnalog;

    {events}
    property OnClick;
    property OnDblClick;
    property OnHourChange;
    property OnMinuteChange;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSecondChange;
  end;


implementation


const
  {field types supported}
  SupportedFieldTypes : set of  TFieldType = [ftTime, ftDateTime];


{*** TOvcDbClock ***}

procedure TOvcDbClock.clkDataChange(Sender : TObject);
begin
  if Field <> nil then begin
    {update our display value}
    case Field.DataType of
      ftTime,
      ftDateTime : Self.Time := Field.AsDateTime;
      ftFloat    : Self.Time := Field.AsFloat;
    else
      Self.Time := SysUtils.Date;
    end;
  end else
    Self.Time := SysUtils.Date;
end;

procedure TOvcDbClock.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbClock.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {create the data link object}
  FDataLink                 := TFieldDataLink.Create;
  FDataLink.Control         := Self;

  {set notification routines}
  FDataLink.OnActiveChange  := clkDataChange;
  FDataLink.OnDataChange    := clkDataChange;
end;

destructor TOvcDbClock.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

function TOvcDbClock.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbClock.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbClock.GetField : TField;
begin
  Result := FDataLink.Field;
end;

procedure TOvcDbClock.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    Refresh;
  end;
end;

procedure TOvcDbClock.SetDataField(const Value : string);
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

procedure TOvcDbClock.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);

  Refresh;
end;

function TOvcDbClock.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbClock.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

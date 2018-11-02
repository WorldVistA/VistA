{*********************************************************}
{*                  OVCDBSLD.PAS 4.06                    *}
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

unit ovcdbsld;
  {-Data-Aware slider component}

interface

uses
  Classes, Controls, Db, DbCtrls, Graphics, Messages,
  OvcConst, OvcData, OvcExcpt, OvcSlide, SysUtils,
  Forms; { for bsSingle definition}

type
  TOvcDbSlider = class(TOvcCustomSlider)
  

  protected {private}
    {property variables}
    FDataLink    : TFieldDataLink;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure slDataChange(Sender : TObject);
    procedure slUpdateData(Sender : TObject);

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

    {dynamic event wrappers}
    procedure DoOnChange;
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
      read GetDataField write SetDataField;
    property DataSource : TDataSource
      read GetDataSource write SetDataSource;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle default bsSingle;
    property Color;
    property Ctl3D;
    property Cursor;
    property DrawMarks default True;
    property Enabled;
    property LabelInfo;
    property Max;
    property Min;
    property Orientation default soHorizontal;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ShowHint;
    property Step;
    property TabOrder;
    property TabStop;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
  end;


implementation


const
  {field types supported}
  SupportedFieldTypes : set of  TFieldType = [ftSmallint, ftInteger,
    ftWord, ftFloat, ftCurrency, ftBCD, ftLargeint];


{*** TOvcDbSlider ***}

procedure TOvcDbSlider.CMExit(var Msg : TMessage);
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

procedure TOvcDbSlider.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbSlider.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {create the data link object}
  FDataLink                 := TFieldDataLink.Create;
  FDataLink.Control         := Self;

  {set notification routines}
  FDataLink.OnActiveChange  := slDataChange;
  FDataLink.OnDataChange    := slDataChange;
  FDataLink.OnUpdateData    := slUpdateData;
end;

destructor TOvcDbSlider.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

procedure TOvcDbSlider.DoOnChange;
begin
  FDataLink.Modified;

  inherited DoOnChange;
end;

function TOvcDbSlider.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbSlider.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbSlider.GetField : TField;
begin
  Result := FDataLink.Field;
end;

procedure TOvcDbSlider.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    Refresh;
  end;
end;

procedure TOvcDbSlider.SetDataField(const Value : string);
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

procedure TOvcDbSlider.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);

  Refresh;
end;

procedure TOvcDbSlider.slDataChange(Sender : TObject);
begin
  {update our display value}
  if Field <> nil then begin
    Position := Field.AsFloat;
  end else
    Position := Min;
end;

procedure TOvcDbSlider.slUpdateData(Sender : TObject);
begin
  if (DataSource = nil) or (Field = nil) then
    Exit;

  Field.AsFloat := Position;
end;

procedure TOvcDbSlider.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  {see if we need to enter edit mode}
  if (DataSource <> nil) then
    if not FDataLink.Editing and DataSource.AutoEdit then
      FDataLink.Edit;

  inherited;
end;

procedure TOvcDbSlider.WMKeyDown(var Msg : TWMKeyDown);
begin
  {see if we need to enter edit mode}
  if (DataSource <> nil) then
    if not FDataLink.Editing and DataSource.AutoEdit then
      FDataLink.Edit;

  inherited;
end;

function TOvcDbSlider.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbSlider.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

{*********************************************************}
{*                 OVCDBCCB.PAS 4.06                     *}
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

unit ovcdbccb;
  {-data-aware color ComboBox}

interface

uses
  Classes, Controls, Messages, Menus, Db, DbCtrls, Graphics, StdCtrls,
  OvcBase, OvcClrCb, OvcConst, OvcData, OvcExcpt, OvcCmbx;

type
  TOvcDbColorComboBox = class(TOvcCustomColorComboBox)
  

  protected {private}
    {property variables}
    FDataLink : TFieldDataLink;

    {internal variables}
    ccbBusy   : Boolean;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);

    {internal methods}
    procedure ccbDataChange(Sender : TObject);
    procedure ccbUpdateData(Sender : TObject);

    {vcl methods}
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

  protected
    procedure Change;
      override;
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

    property SelectedColor : TColor
      read GetSelectedColor write SetSelectedColor;

   published
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
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property HotTrack;
    property Items;
    property ItemHeight;
    property LabelInfo;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColorNames;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    {inherited events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectionChange;
    property OnStartDrag;
    property OnMouseWheel;
  end;


implementation


const
  {field types supported}
  SupportedFieldTypes : set of  TFieldType = [ftSmallint, ftInteger,
    ftWord, ftFloat, ftCurrency, ftBCD, ftLargeint];

{*** TOvcDbColorComboBox ***}

procedure TOvcDbColorComboBox.ccbDataChange(Sender : TObject);
begin
  if ccbBusy then
    Exit;

  {update our display value}
  if Field <> nil then begin
    ItemIndex := Field.AsInteger;
  end else
    ItemIndex := -1;
end;

procedure TOvcDbColorComboBox.ccbUpdateData(Sender : TObject);
begin
  if (DataSource = nil) or (Field = nil) then
    Exit;

  Field.AsInteger := ItemIndex;
end;

procedure TOvcDbColorComboBox.Change;
begin
  inherited Change;

  ccbBusy := True;
  try
    {see if we need to enter edit mode}
    if (DataSource <> nil) then
      if not FDataLink.Editing and DataSource.AutoEdit then
        FDataLink.Edit;

    Field.AsInteger := ItemIndex;
    try
      if FDataLink.Editing then
        FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
  finally
    ccbBusy := False;
  end;
end;

procedure TOvcDbColorComboBox.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := NativeInt(FDataLink);
end;

constructor TOvcDbColorComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {create the data link object}
  FDataLink                 := TFieldDataLink.Create;
  FDataLink.Control         := Self;

  {set notification routines}
  FDataLink.OnActiveChange  := ccbDataChange;
  FDataLink.OnDataChange    := ccbDataChange;
  FDataLink.OnUpdateData    := ccbUpdateData;
end;

destructor TOvcDbColorComboBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

function TOvcDbColorComboBox.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbColorComboBox.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbColorComboBox.GetField : TField;
begin
  Result := FDataLink.Field;
end;

procedure TOvcDbColorComboBox.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
     (AComponent = DataSource) then begin
    DataSource := nil;
    Refresh;
  end;
end;

procedure TOvcDbColorComboBox.SetDataField(const Value : string);
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

procedure TOvcDbColorComboBox.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);

  Refresh;
end;

function TOvcDbColorComboBox.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbColorComboBox.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

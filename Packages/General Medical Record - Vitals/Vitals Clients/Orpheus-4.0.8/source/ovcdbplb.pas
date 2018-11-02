{*********************************************************}
{*                  OVCDBPLB.PAS 4.06                    *}
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

unit ovcdbplb;
  {-Data-aware picture label component}

interface

uses
  Windows, Classes, Controls, Db, DbConsts, DbCtrls, Forms, Graphics, Menus,
  Messages, SysUtils, OvcBase, OvcPLb, OvcRLbl;

type
  TShowDateOrTime = (ftShowDate, ftShowTime);

type
  TOvcDbPictureLabel = class(TOvcCustomPictureLabel)
  

  protected {private}
    {property variables}
    FDataLink       : TFieldDataLink;
    FShowDateOrTime : TShowDateOrTime;

    {property methods}
    function GetDataField : string;
    function GetDataSource : TDataSource;
    function GetField : TField;
    procedure SetDataField(const Value : string);
    procedure SetDataSource(Value : TDataSource);
    procedure SetShowDateOrTime(Value : TShowDateOrTime);

    {internal methods}
    procedure plDataChange(Sender : TObject);
    procedure plGetFieldValue;

    {vcl message methods}
    procedure CMGetDataLink(var Msg : TMessage);
      message CM_GETDATALINK;

  protected
    procedure Notification(AComponent : TComponent; Operation : TOperation);
      override;
    procedure Paint;
      override;

    function plGetSampleDisplayData : string;
      override;
      {-return the text to display while in design mode}

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
    {properties}
    property DataField : string
      read GetDataField
      write SetDataField;

    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    property ShowDateOrTime : TShowDateOrTime
      read FShowDateOrTime
      write SetShowDateOrTime;

    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property Alignment;
    property AutoSize;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property FontAngle;
    property OriginX;
    property OriginY;
    property ParentColor;
    property ParentShowHint;
    property PictureMask;
    property PopupMenu;
    property ShadowColor;
    property ShadowedText;
    property ShowHint;
    property Transparent;
    property UseIntlMask;
    property Visible;

    {events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;


implementation



{*** TOvcDbPictureLabel ***}

procedure TOvcDbPictureLabel.CMGetDataLink(var Msg : TMessage);
begin
  Msg.Result := Integer(FDataLink);
end;

constructor TOvcDbPictureLabel.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];

  {create data link}
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := plDataChange;

  FShowDateOrTime := ftShowDate;
end;

destructor TOvcDbPictureLabel.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

function TOvcDbPictureLabel.GetDataField : string;
begin
  Result := FDataLink.FieldName;
end;

function TOvcDbPictureLabel.GetDataSource : TDataSource;
begin
  if Assigned(FDataLink) then
    Result := FDataLink.DataSource
  else
    Result := nil;
end;

function TOvcDbPictureLabel.GetField : TField;
begin
  Result := FDataLink.Field;
end;

procedure TOvcDbPictureLabel.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and  (AComponent = DataSource) then
    DataSource := nil;
end;

procedure TOvcDbPictureLabel.Paint;
var
  S : string;
begin
  if not (csPaintCopy in ControlState) or (Field = nil) or
         (csDesigning in ComponentState) or
     not FDataLink.Active then begin
    inherited Paint;
    Exit;
  end else begin
    S := FCaption;
    if Field.DataType = ftDateTime then begin
      case FShowDateOrTime of
        ftShowDate : FCaption := DateToStr(Field.AsDateTime);
        ftShowTime : FCaption := TimeToStr(Field.AsDateTime);
      end;
    end else
      FCaption := Field.DisplayText;
    inherited Paint;
    FCaption := S;
  end;
end;

procedure TOvcDbPictureLabel.plDataChange(Sender : TObject);
begin
  plGetFieldValue;
end;

procedure TOvcDbPictureLabel.plGetFieldValue;
begin
  if Field <> nil then begin
    case Field.DataType of
      ftString   : SetAsString(Field.AsString);
      ftSmallInt,
      ftWord,
      ftInteger  : SetAsInteger(Field.AsInteger);
      ftBoolean  : SetAsBoolean(Field.AsBoolean);
      ftFloat,
      ftCurrency : SetAsFloat(Field.AsFloat);
      ftDate     : SetAsDate(Field.AsDateTime);
      ftTime     : SetAsTime(Field.AsDateTime);
      ftDateTime :
        if FShowDateOrTime = ftShowDate then
          SetAsDate(Field.AsDateTime)
        else
          SetAsTime(Field.AsDateTime);
    else
      SetAsString(Field.AsString);
    end;
  end else
    SetAsString(plGetSampleDisplayData);
end;

function TOvcDbPictureLabel.plGetSampleDisplayData : string;
begin
  if (Field <> nil) and FDataLink.Active then
    Result := plGetDisplayString
  else
    Result := inherited plGetSampleDisplayData;
end;

procedure TOvcDbPictureLabel.SetDataField(const Value : string);
begin
  FDataLink.FieldName := Value;
end;

procedure TOvcDbPictureLabel.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;

  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TOvcDbPictureLabel.SetShowDateOrTime(Value : TShowDateOrTime);
begin
  if Value <> FShowDateOrTime then begin
    FShowDateOrTime := Value;
    plGetFieldValue;
    Invalidate;
  end;
end;

function TOvcDbPictureLabel.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbPictureLabel.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

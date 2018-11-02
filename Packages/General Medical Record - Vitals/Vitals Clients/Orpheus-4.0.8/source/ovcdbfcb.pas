{*********************************************************}
{*                  OVCDBFCB.PAS 4.06                    *}
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

unit ovcdbfcb;
  {-db field ComboBox}

interface

uses
  Windows, Classes, Controls, DB, DBCtrls, ExtCtrls, Graphics, Menus, StdCtrls,
  SysUtils, OvcBase, OvcCmbx;

type
  TOvcFieldTypeSet = set of TFieldType;

  TOvcDbFieldComboBox = class(TOvcBaseComboBox)
  

  protected {private}
    FDataLink         : TFieldDataLink;
    FOmitFields       : TOvcFieldTypeSet;
    FShowHiddenFields : Boolean;

    {property methods}
    function GetDataSource : TDataSource;
    function GetFieldName : string;
    procedure SetDataSource(Value : TDataSource);
    procedure SetOmitFields(Value : TOvcFieldTypeSet);
    procedure SetShowHiddenFields(Value : Boolean);

    {internal methods}
    procedure ActiveChanged(Sender : TObject);

  protected
    procedure DrawItem(Index : Integer; ItemRect : TRect; State : TOwnerDrawState);
      override;
    procedure Loaded;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure Populate;

    function ExecuteAction(Action: TBasicAction): Boolean;
      override;
    function UpdateAction(Action: TBasicAction): Boolean;
      override;

    property FieldName : string
      read GetFieldName;

    property OmitFields : TOvcFieldTypeSet
      read FOmitFields
      write SetOmitFields;

  published
    {properties}
    property DataSource : TDataSource
      read GetDataSource
      write SetDataSource;

    property ShowHiddenFields : Boolean
      read FShowHiddenFields
      write SetShowHiddenFields
        default False;

    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AutoSearch;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property Items;
    property KeyDelay;
    property LabelInfo;
    property MRUListColor;
    property MRUListCount;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    {events}
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
    property OnSelectionChange;
    property OnStartDrag;
    property OnMouseWheel;
  end;


implementation


procedure TOvcDbFieldComboBox.ActiveChanged(Sender : TObject);
begin
  Populate;
end;

constructor TOvcDbFieldComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FDataLink := TFieldDataLink.Create;
  FDataLink.OnActiveChange := ActiveChanged;
  FOmitFields := [];
  FShowHiddenFields := False;
end;

destructor TOvcDbFieldComboBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

procedure TOvcDbFieldComboBox.DrawItem(Index : Integer; ItemRect: TRect;
                                      State : TOwnerDrawState);
var
  SepRect    : TRect;
  BkColor    : TColor;
  TxtRect    : TRect;
  TxtItem    : string;
  BkMode     : Integer;

begin
  with Canvas do begin
    if (FMRUList.Items.Count > 0) and (Index < FMRUList.Items.Count) then
      BkColor := FMRUListColor
    else
      BkColor := Color;

    if odSelected in State then
      Brush.Color := clHighlight
    else
      Brush.Color := BkColor;
    FillRect(ItemRect);

    TxtRect := ItemRect;
    TxtItem := Items[Index];
    BkMode := GetBkMode(Canvas.Handle);
    SetBkMode(Canvas.Handle, TRANSPARENT);
    DrawText(Canvas.Handle, PChar(TxtItem), Length(TxtItem), TxtRect,
      DT_SINGLELINE or DT_VCENTER or DT_LEFT);
    SetBkMode(Canvas.Handle, BkMode);

    if (FMRUList.Items.Count > 0) and (Index = FMRUList.Items.Count - 1) then begin
      SepRect := ItemRect;
      SepRect.Top    := SepRect.Bottom - cbxSeparatorHeight;
      SepRect.Bottom := SepRect.Bottom;
      Pen.Color := clGrayText;

      if not DrawingEdit then
        with SepRect do
          Rectangle(Left-1, Top, Right+1, Bottom);
    end;
  end;
end;

function TOvcDbFieldComboBox.GetDataSource : TDataSource;
begin
  Result:= FDataLink.DataSource;
end;

function TOvcDbFieldComboBox.GetFieldName : string;
var
  I : Integer;
begin
  Result := '';
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then begin
    with DataSource.DataSet do begin
      for I := 0 to FieldCount-1 do begin
        if Fields[I].DisplayLabel = Text then begin
          Result:= Fields[I].FieldName;
          Break;
        end
      end;
    end;
  end;
end;

procedure TOvcDbFieldComboBox.Loaded;
begin
  inherited Loaded;

  Populate;
end;

procedure TOvcDbFieldComboBox.Populate;
var
  I : Integer;
begin
  if csDesigning in ComponentState then
    Exit;

  if csLoading in ComponentState then
    Exit;

  ClearItems;

  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    for I := 0 to DataSource.DataSet.FieldCount-1 do
      if DataSource.DataSet.Fields[I].Visible or FShowHiddenFields then
        if not (DataSource.DataSet.Fields[I].DataType in FOmitFields) then
          Items.Add(DataSource.DataSet.Fields[I].DisplayLabel);
end;

procedure TOvcDbFieldComboBox.SetDataSource(Value : TDataSource);
begin
  FDataLink.DataSource := Value;
  Populate;
end;

procedure TOvcDbFieldComboBox.SetOmitFields(Value : TOvcFieldTypeSet);
begin
  if Value <> FOmitFields then begin
    FOmitFields := Value;
    Populate;
  end;
end;

procedure TOvcDbFieldComboBox.SetShowHiddenFields(Value : Boolean);
begin
  if Value <> FShowHiddenFields then begin
    FShowHiddenFields := Value;
    if not (csLoading in ComponentState) then
      Populate;
  end;
end;

function TOvcDbFieldComboBox.ExecuteAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited ExecuteAction(Action) or (FDataLink <> nil) and
    FDataLink.ExecuteAction(Action);
end;

function TOvcDbFieldComboBox.UpdateAction(Action : TBasicAction) : Boolean;
begin
  Result := inherited UpdateAction(Action) or (FDataLink <> nil) and
    FDataLink.UpdateAction(Action);
end;

end.

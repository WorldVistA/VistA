{*********************************************************}
{*                   OVCDBTCB.PAS 4.06                  *}
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

unit ovcdbtcb;
  {table combobox}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, StdCtrls, OvcCmbx,
  OvcBase, Menus, Db, OvcDbHLL;

type
  TOvcDbTableNameComboBox = class(TOvcBaseComboBox)
  

  protected {private}
    FDbEngineHelper : TOvcDbEngineHelperBase;
    FAliasName      : string;
    function GetTableName : string;
    procedure SetAliasName(const Value : string);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent : TComponent;
                           Operation : TOperation); override;
  public
    procedure Populate;

    property TableName : string
      read GetTableName;
  published
    property AliasName : string
      read FAliasName
      write SetAliasName;
    property DbEngineHelper : TOvcDbEngineHelperBase
      read FDbEngineHelper
      write FDbEngineHelper;

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
    property HotTrack;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property KeyDelay;
    property LabelInfo;
    property MRUListColor;
    property MRUListCount;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style default ocsDropDown;
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

{*** TOvcAliasComboBox ***}

procedure TOvcDbTableNameComboBox.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcDbTableNameComboBox.Populate;
begin
  ClearItems;
  OvcGetTableNames(DbEngineHelper, FAliasName, Items);
end;

function TOvcDbTableNameComboBox.GetTableName : string;
begin
  if (ItemIndex > -1) then
    Result := Items[ItemIndex]
  else
    Result := '';
end;

procedure TOvcDbTableNameComboBox.Notification(AComponent : TComponent;
                                               Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    if (Assigned(DBEngineHelper)) and (AComponent = FDbEngineHelper) then
      DBEngineHelper := nil;
  end;
end;

procedure TOvcDbTableNameComboBox.SetAliasName(const Value : string);
begin
  if Value <> FAliasName then begin
    FAliasName := Value;
    Populate;
  end;
end;

end.

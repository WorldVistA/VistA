{*********************************************************}
{*                   OVCDBACB.PAS 4.06                   *}
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
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcdbacb;

interface

uses
  Windows, Classes, OvcCmbx, OvcDbTCb, OvcDbHLL;

type
  TOvcDbAliasComboBox = class(TOvcBaseComboBox)
  

  protected {private}
    FDbEngineHelper    : TOvcDbEngineHelperBase;
    FTableNameComboBox : TOvcDbTableNameComboBox;
    function GetAliasName : string;
    function GetPath : string;
    function GetDriverName : string;
  protected
    procedure Loaded; override;

    procedure Notification(AComponent : TComponent;
                           Operation : TOperation);
      override;

    procedure SelectionChanged; override;
  public
    procedure Populate;

    property AliasName : string
      read GetAliasName;
    property Path : string
      read GetPath;
    property DriverName : string
      read GetDriverName;

  published
    property TableNameComboBox : TOvcDbTableNameComboBox
      read FTableNameComboBox
      write FTableNameComboBox;

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

procedure TOvcDbAliasComboBox.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcDbAliasComboBox.Populate;
begin
  ClearItems;
  OvcGetAliasNames(DbEngineHelper, Items);
end;

procedure TOvcDbAliasComboBox.SelectionChanged;
begin
  if (FTableNameComboBox <> nil) then
    FTableNameComboBox.AliasName := GetAliasName;
  inherited SelectionChanged;
end;

function TOvcDbAliasComboBox.GetAliasName : string;
begin
  if (ItemIndex > -1) then
    Result := Items[ItemIndex]
  else
    Result := '';
end;

function TOvcDbAliasComboBox.GetPath : string;
begin
  Result := '';
  if (ItemIndex > -1) then
    OvcGetAliasPath(DbEngineHelper, Items[ItemIndex], Result);
end;

function TOvcDbAliasComboBox.GetDriverName : string;
begin
  Result := '';
  if (ItemIndex > -1) then
    OvcGetAliasDriverName(DbEngineHelper, Items[ItemIndex], Result);
end;

procedure TOvcDbAliasComboBox.Notification(AComponent : TComponent;
                                           Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) then begin
    if (Assigned(DBEngineHelper)) and (AComponent = FDbEngineHelper) then
      DBEngineHelper := nil;
  end;
end;

end.

{*********************************************************}
{*                   OVCHSCBX.PAS 4.06                  *}
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

unit ovchscbx;
  {-History combo box}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, OvcCmbx;

type
  TOvcHistoryComboBox = class(TOvcBaseComboBox)
  protected {private}
    FMaxHistory : Integer;

    {procedure UpdateHistory;} {moved to public}

  protected
    procedure DoExit;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    procedure UpdateHistory; {moved from protected}
  published
    property MaxHistory : Integer
      read FMaxHistory
      write FMaxHistory
      default 5;

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
    property Items;
    property ItemHeight;
    property KeyDelay;
    property LabelInfo;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
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

{*** TOvcHistoryComboBox ***}

constructor TOvcHistoryComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {defaults}
  FMaxHistory := 5;

  {disable MRU list}
  FMRUList.MaxItems := 0;
end;

procedure TOvcHistoryComboBox.DoExit;
begin
  UpdateHistory;

  inherited DoExit;
end;

procedure TOvcHistoryComboBox.UpdateHistory;
var
  I     : Integer;
  Found : Boolean;
begin
  if (Text > '') then begin
    Found := False;
    for I := 0 to Pred(Items.Count) do
      if AnsiCompareText(Text, Items[I]) = 0 then begin
        Found := True;
        Break;
      end;
    if not Found then begin
      {delete from bottom}
      while (Items.Count > 0) and (Items.Count >= FMaxHistory) do
        Items.Delete(Items.Count-1);
      {add to top}
      Items.Insert(0, Text);
      ItemIndex := Items.IndexOf(Text);
    end;
  end;
end;

end.

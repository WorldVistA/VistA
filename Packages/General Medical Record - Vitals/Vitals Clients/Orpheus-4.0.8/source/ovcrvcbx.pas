{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
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

{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

{*********************************************************}
{*                  OVCRVCBX.PAS 4.00                    *}
{*********************************************************}

unit ovcrvcbx;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics,
  StdCtrls, OvcBase, OvcCmbx, OvcRptVw;

type
  TOvcViewComboBox = class(TOvcBaseComboBox)
  protected
    FReportView : TOvcCustomReportView;
    procedure SelectionChanged; override;
    procedure ChangeNotification(Sender : TOvcCustomReportView;
                Event : TRvChangeEvent);
    procedure Loaded; override;
    procedure LoadList;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetReportView(Value : TOvcCustomReportView);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property ReportView : TOvcCustomReportView
      read FReportView write SetReportView;

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
    property DroppedWidth;
    property Enabled;
    property Font;
    property HotTrack default False;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property KeyDelay default 500;
    property LabelInfo;
    property MaxLength;
    property MRUListColor default clWindow;
    property MRUListCount;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    {property Text;}
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

procedure TOvcViewComboBox.SelectionChanged;
begin
  inherited SelectionChanged;
  if (ItemIndex <> -1) and (ReportView <> nil) then begin
    ReportView.ActiveViewByTitle := Text;
    if ReportView.Enabled then
      ReportView.SetFocus;
  end;
end;

procedure TOvcViewComboBox.ChangeNotification(Sender : TOvcCustomReportView; Event : TRvChangeEvent);
var
  i, j : Integer;
  Found : Boolean;
begin
  case Event of
  rvViewCreate :
    begin
      with ReportView do
        for i := 0 to pred(Views.Count) do
          if (View[i].Title <> '')
          and not (View[i].Hidden) then begin
            Found := False;
            for j := 0 to pred(List.Count) do
              if List[J] = View[i].Title then begin
                Found := True;
                break;
              end;
            if not Found then
              AddItem(View[i].Title,nil);
          end;
    end;
  rvViewDestroy :
    begin
      i := pred(List.Count);
      while (i >= 0) and (i < List.Count) do begin
        if (i < List.Count) then
          if ReportView.ViewNameByTitle(List[i]) = '' then
            RemoveItem(List[i]);
        dec(i);
      end;
    end;
  rvViewSelect :
  if  HandleAllocated then
    begin
      i := List.IndexOf(ReportView.ActiveViewByTitle);
      if i <> -1 then
        ListIndex := i;
    end;
  rvDestroying :
    ReportView := nil
  end;
end;

constructor TOvcViewComboBox.Create;
begin
  inherited Create(AOwner);
  Style := ocsDropDownList;
end;

destructor TOvcViewComboBox.Destroy;
begin
  ReportView := nil;
  inherited Destroy;
end;

procedure TOvcViewComboBox.Loaded;
begin
  inherited Loaded;
  if ReportView <> nil then
    LoadList;
end;

procedure TOvcViewComboBox.LoadList;
var
  i : Integer;
begin
  with ReportView do begin
    ClearItems;
    for i := 0 to pred(Views.Count) do
      if View[i].Title <> '' then
        if not View[i].Hidden then
          AddItem(View[i].Title, nil);
    i := List.IndexOf(ActiveViewByTitle);
    if i <> -1 then
      ListIndex := i;
  end;
end;

procedure TOvcViewComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if (AComponent = ReportView) then begin
      if HandleAllocated then
        ItemIndex := -1;
      ClearItems;
      FReportView := nil;
    end else
    if (AComponent = Self) and (ReportView <> nil) then
      ReportView := nil;
end;

procedure TOvcViewComboBox.SetReportView(Value : TOvcCustomReportView);
begin
  if Value <> FReportView then begin
    if ([csDestroying, csLoading] * ComponentState) = [] then
      Items.Clear;
    if FReportView <> nil then
      FReportView.UnRegisterChangeNotification(ChangeNotification);
    FReportView := Value;
    if Value <> nil then begin
      if not (csLoading in ComponentState) then
        LoadList;
      FReportView.RegisterChangeNotification(ChangeNotification);
    end;
  end;
end;

end.

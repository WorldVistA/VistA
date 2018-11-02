{*********************************************************}
{*                   OVCFMCBX.PAS 4.08                   *}
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

unit ovcfmcbx;
  {-File association ComboBox}

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Graphics, Registry, OvcCmbx,
  StdCtrls;

type
  TOvcAssociationComboBox = class(TOvcBaseComboBox)
  protected {private}
(*
    FSavedItemList : TStringList;
    procedure vFreeObjects;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
*)
    procedure DrawItem(Index : Integer; ItemRect : TRect;
      State : TOwnerDrawState); override;
    procedure Loaded; override;

    function GetDescription : string;
    function GetIcon : HIcon;

  public
(*
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
*)
    procedure Populate;

    property Description : string read GetDescription;
    property AssociatedIcon : HIcon read GetIcon;

  published
    {properties}
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

uses
  ShellApi;


{*** TOvcAssociationComboBox ***}

type
  TOvcAssociationItem = class
    Extension   : string;
    FileName    : string;
    Description : string;
  end;

function vLoadIcon(const Str : string) : HIcon;
var
  FileName : array[0..255] of char;
  IconNum : Word;
begin
  StrPCopy(FileName, Str);
  IconNum := 0;
  Result := ExtractAssociatedIcon(MainInstance, FileName, IconNum);
end;

(*
  Changes, AB 05/2001:
    The code for 'DestroyWnd' / 'CreateWnd' lead to crashes:
    In 'DestroyWnd' all the objects stored in 'Items' were destroyed (for no obvious
    reason); as DestroyWnd + CreateWnd is called after 'Populate', all then objects
    get lost.
    Moreover, the use of 'FSavedItemList' is unclear, as the items stored here are
    never used...

    Removing all this code makes the component work... }

procedure TOvcAssociationComboBox.vFreeObjects;
var
  I : Integer;
begin
  if (FSavedItemList.Count > 0) then
    for I := 0 to Pred(FSavedItemList.Count) do
      TOvcAssociationItem(FSavedItemList.Objects[I]).Free;
end;


procedure TOvcAssociationComboBox.DestroyWnd;
var
  I: integer;
begin
  if not (csDesigning in ComponentState) then begin
    if (FSavedItemList <> nil) then begin
      vFreeObjects;
      FSavedItemList.Clear;
      FSavedItemList.Assign(FMRUList.Items);
    end;
    {free association objects}
    for I := 0 to pred(Items.Count) do
      TOvcAssociationItem(Items.Objects[I]).Free;
  end;
  inherited DestroyWnd;
end;

procedure TOvcAssociationComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if not (csDesigning in ComponentState) then begin
    vFreeObjects;
    FSavedItemList.Clear;
  end;
end;

constructor TOvcAssociationComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSavedItemList := TStringList.Create;
end;

destructor TOvcAssociationComboBox.Destroy;
begin
  vFreeObjects;
  FSavedItemList.Free;

  inherited Destroy;
end;
*)


procedure TOvcAssociationComboBox.DrawItem(Index : Integer; ItemRect: TRect;
            State : TOwnerDrawState);
var
  SepRect    : TRect;
  BkColor    : TColor;
  TxtRect    : TRect;
  Obj        : TOvcAssociationItem;
  TxtItem    : array [0..63] of char;
  BkMode     : Integer;
  Icon       : HIcon;
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
    Obj := TOvcAssociationItem(Items.Objects[Index]);
    StrPLCopy(TxtItem, Obj.Extension + ' (' + Obj.Description + ')', High(TxtItem));

    Icon := vLoadIcon(Obj.FileName);
    if (Icon <> 0) then begin
      DrawIconEx(Handle, ItemRect.Left, ItemRect.Top, Icon,
        ItemHeight - 2, ItemHeight - 2, 0, 0, DI_NORMAL);
      TxtRect.Left := TxtRect.Left + ItemHeight;
    end;

    BkMode := GetBkMode(Canvas.Handle);
    SetBkMode(Canvas.Handle, TRANSPARENT);
    DrawText(Canvas.Handle, TxtItem, StrLen(TxtItem), TxtRect,
      DT_SINGLELINE or DT_VCENTER or DT_LEFT);
    SetBkMode(Canvas.Handle, BkMode);
    if (FMRUList.Items.Count > 0) and (Index = Pred(FMRUList.Items.Count)) then begin
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

procedure TOvcAssociationComboBox.Loaded;
begin
  inherited Loaded;

  if not (csDesigning in ComponentState) then begin
    Populate;
  end;
end;

procedure TOvcAssociationComboBox.Populate;
var
  Reg  : TRegistry;
  SL : TStringList;
  I, P, L  : Integer;
  FileExtension : string;
  ClassID : string;
  ClassDescription : string;
  DefaultStr : string;
  Obj : TOvcAssociationItem;
begin
  SL := TStringList.Create;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('',False);
    Reg.GetKeyNames(SL);
    SL.Sort;
    if (SL.Count > 0) then
      for I := 0 to Pred(SL.Count) do begin
        if (SL.Strings[I] <> '') and (SL.Strings[I][1] = '.') then begin
          FileExtension := '*' + SL[I];
          if Reg.OpenKey('\' + SL[I], False) then begin
            ClassID := Reg.ReadString('');
            if Reg.OpenKey('\' + ClassID, False) then begin
              ClassDescription := Reg.ReadString('');
              if ClassDescription <> '' then begin
                if Reg.OpenKey('DefaultIcon', False) then begin
                  DefaultStr := Reg.ReadString('');
                  if DefaultStr <> '' then begin
                    P := Pos(',', DefaultStr);
                    L := Length(DefaultStr);
                    Delete(DefaultStr, P, L-P+1);
                    Obj := TOvcAssociationItem.Create;
                    Obj.FileName := DefaultStr;
                    Obj.Extension := FileExtension;
                    Obj.Description := ClassDescription;
                    AddItem(FileExtension, Obj);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
  finally
    Reg.Free;
    SL.Free;
  end;
end;

function TOvcAssociationComboBox.GetDescription : string;
begin
  if (ListIndex > -1) then
    Result := TOvcAssociationItem(List.Objects[ListIndex]).Description
  else
    Result := '';
end;

function TOvcAssociationComboBox.GetIcon : HIcon;
begin
  if (ListIndex > -1) then
    Result := vLoadIcon(TOvcAssociationItem(Items.Objects[ItemIndex]).FileName)
  else
    Result := 0;
end;

end.

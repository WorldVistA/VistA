{*********************************************************}
{*                   OVCFLCBX.PAS 4.06                   *}
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

unit ovcflcbx;
  {-file ComboBox}

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Graphics, OvcCmbx, StdCtrls;

type
  TOvcCbxFileAttribute = (cbxReadOnly, cbxHidden, cbxSysFile, cbxArchive,
                          cbxAnyFile);

  TOvcCbxFileAttributes = set of TOvcCbxFileAttribute;

type
  TOvcFileComboBox = class(TOvcBaseComboBox)
  protected {private}
    {property variables}
    FAttributes : TOvcCbxFileAttributes;
    FDirName    : string;
    FFileMask   : string;
    FShowIcons  : Boolean;

    procedure SetAttributes(Value : TOvcCbxFileAttributes);
    procedure SetDirectory(const Value : string);
    procedure SetFileMask(const Value : string);
    procedure SetShowIcons(Value : Boolean);

    procedure DrawItem(Index : Integer; ItemRect : TRect; State : TOwnerDrawState);
      override;

  protected
    procedure Loaded;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
    procedure Populate;

  published
    property Attributes : TOvcCbxFileAttributes
      read FAttributes
      write SetAttributes
      default [cbxAnyFile];

    property Directory : string
      read FDirName
      write SetDirectory;

    property FileMask : string
      read FFileMask
      write SetFileMask;

    property ShowIcons : Boolean
      read FShowIcons
      write SetShowIcons
      default True;

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

uses
  ShellApi;

function FullName(const Directory, Str : string) : string;
begin
  if Directory = '' then
    Result := GetCurrentDir + Str
  else
    if Directory[Length(Directory)] = ':' then
      Result := Directory + Str
    else
      if Directory[Length(Directory)] = '\' then
        Result := Directory + Str
      else
        Result := Directory + '\' + Str;
end;

function vLoadIcon(const Str : string) : HIcon;
var
  FileName : array[0..255] of char;
  IconNum : Word;
begin
  StrPCopy(FileName, Str);
  IconNum := 0;
  Result := ExtractAssociatedIcon(MainInstance, FileName, IconNum
  );
end;

{*** TOvcFileComboBox ***}

constructor TOvcFileComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAttributes := [cbxAnyFile];
  FDirName := '.';
  FFileMask := '*.*';
  FShowIcons := True;
end;

procedure TOvcFileComboBox.Loaded;
begin
  inherited Loaded;

  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcFileComboBox.DrawItem(Index : Integer; ItemRect: TRect;
                                   State : TOwnerDrawState);
var
  Icon       : HIcon;
  SepRect    : TRect;
  BkColor    : TColor;
  TxtRect    : TRect;
  TxtItem    : array [0..255] of char;
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

    if FShowIcons then begin
      with Items do
        Icon := vLoadIcon(FullName(Directory, Items[Index]));
      if Icon <> 0 then begin
        DrawIconEx(
          Handle, ItemRect.Left, ItemRect.Top, Icon,
          ItemHeight - 2,
          ItemHeight - 2,
          0,
          0,
          DI_NORMAL
        );
      end;
      with ItemRect do
        TxtRect := Rect(Left + ItemHeight, Top, Right, Bottom);
    end else
      TxtRect := ItemRect;
    StrPCopy(TxtItem, Items[Index]);

    BkMode := GetBkMode(Canvas.Handle);
    SetBkMode(Canvas.Handle, TRANSPARENT);
    DrawText(Canvas.Handle, TxtItem, StrLen(TxtItem), TxtRect,
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

procedure TOvcFileComboBox.Populate;
var
  SR          : TSearchRec;
  lAttributes : Word;
  StrFiles    : TStringList;
begin
  ClearItems;

  lAttributes := 0;
  if cbxReadOnly in FAttributes then
    lAttributes := lAttributes or faReadOnly;
  if cbxHidden in FAttributes then
    lAttributes := lAttributes or faHidden;
  if cbxSysFile in FAttributes then
    lAttributes := lAttributes or faSysFile;
  if cbxArchive in FAttributes then
    lAttributes := lAttributes or faArchive;
  if cbxAnyFile in FAttributes then
    lAttributes := lAttributes or faAnyFile;

  if FindFirst(FullName(Directory, FileMask), lAttributes, SR) = 0 then begin
    StrFiles := TStringList.Create;
    try
      repeat
        if (SR.Attr and faDirectory) = 0 then
          StrFiles.AddObject(SR.Name, Pointer(SR.Attr));
      until FindNext(SR) <> 0;
      StrFiles.Sort;
      Items.AddStrings(StrFiles);
    finally
      StrFiles.Free;
    end;
  end;
  FindClose(SR);
end;

procedure TOvcFileComboBox.SetAttributes(Value : TOvcCbxFileAttributes);
begin
  if Value <> FAttributes then begin
    FAttributes := Attributes;
    Populate;
  end;
end;

procedure TOvcFileComboBox.SetDirectory(const Value : string);
begin
  if Value <> FDirName then begin
    FDirName := Value;
    Populate;
  end;
end;

procedure TOvcFileComboBox.SetFileMask(const Value : string);
begin
  if Value <> FFileMask then begin
    FFileMask := Value;
    Populate;
  end;
end;

procedure TOvcFileComboBox.SetShowIcons(Value : Boolean);
begin
  if Value <> FShowIcons then begin
    FShowIcons := Value;
    DroppedDown := False;
  end;
end;


end.

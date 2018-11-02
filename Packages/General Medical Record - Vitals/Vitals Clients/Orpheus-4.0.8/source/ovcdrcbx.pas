{*********************************************************}
{*                   OVCDRCBX.PAS 4.08                   *}
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
{$D+}

unit ovcdrcbx;
  {-directory combo box}

interface

uses
  UITypes, Types, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ExtCtrls, Menus, OvcCmbx, OvcMisc, OvcFlCbx;

type
  TOvcDirectoryComboBox = class(TOvcBaseComboBox)
  protected {private}
    {property variables}
    FDirectory    : string;
    FDrive        : Char;
    FMask         : string;
    FFileComboBox : TOvcFileComboBox;

    {internal variables}
    cbDirLevel  : Integer;
    cbDirImages : TImageList;

    {property methods}
    procedure SetDirectory(const Value : string);
    procedure SetDrive(const Value : Char);
    procedure SetMask(const Value : string);
    procedure DrawItem(Index : Integer; ItemRect : TRect;
      State : TOwnerDrawState); override;
  protected
    procedure Loaded; override;
    procedure Notification(Component: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Populate;
    procedure SelectionChanged; override;
  published
    property Directory : string
      read FDirectory write SetDirectory;
    property Drive : Char
      read FDrive write SetDrive default #0;
    property Mask : string
      read FMask write SetMask;
    property FileComboBox : TOvcFileComboBox
      read FFileComboBox write FFileComboBox;
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

function DirectoryCount(const Directory : string) : Integer;
var
  Str : string;
begin
  Result := 0;
  Str := Directory;
  while Pos('\', Str) <> 0 do begin
    Inc(Result);
    Delete(Str, 1, Pos('\', Str));
  end;
end;

function DirectoryParse(const Directory : string;
  const Count : Integer) : string;
var
  Str : string;
  I   : Integer;
begin
  Str := Directory;
  for I := 2 to Count do
    if Pos('\', Str) <> 0 then begin
      Delete(Str, 1, Pos('\', Str));
    end;
  if Pos('\', Str) <> 0 then begin
    Str := Copy(Str, 1, Pos('\', Str) - 1);
  end;
  Result := Str;
end;

function DirectoryParseTo(const Directory : string;
  const Count : Integer) : string;
var
  Str : string;
  I   : Integer;
begin
  Result := '';
  Str := Directory;
  for I := 1 to Count do
    if Pos('\', Str) <> 0 then begin
      if Result = '' then
        Result := Copy(Str, 1, Pos('\', Str) - 1)
      else
        Result := Result + '\' + Copy(Str, 1, Pos('\', Str) - 1);
      Delete(Str, 1, Pos('\', Str));
    end;

  if (Length(Result) > 0) and (Result[Length(Result)] = ':') then
    Result := Result + '\';
end;

function FullName(const Directory, Str : string) : string;
var
  LastChar : Char;
begin
  if Directory = '' then
    Result := GetCurrentDir + '\' + Str
  else begin
    LastChar := Directory[Length(Directory)];
    if (LastChar = ':') or (LastChar = '\') then
      Result := Directory + Str
    else
      Result := Directory + '\' + Str;
  end;
end;

function vLoadIcon(const Str : string) : HIcon;
var
  FileName : array[0..255] of Char;
  IconNum  : Word;
begin
  StrPCopy(FileName, Str);
  IconNum := 0;
  Result := ExtractAssociatedIcon(MainInstance, FileName, IconNum);
end;

{*** TOvcDirectoryComboBox ***}

constructor TOvcDirectoryComboBox.Create(AOwner : TComponent);
var
  Bmp : TBitmap;
begin
  inherited Create(AOwner);

  { FItemHeight is set at the end of the inherited method (via 'RecalcHeight')
    - and the height of the ComboBox is set accordingly. FItemHeight may be different
    from 16: Setting it to 16 now is likely to lead to a height of the Combobox that does
    not match FItemHeight (as the height ist not recalculated).
    In 'TOvcBaseComboBox.Loaded' the method 'RecalcHeight' is called again; as the font
    might be different, this might lead to setting ItemHeight to a different value: if
    this value happens to be 16, the height of the ComboBox will not be modified.
    The solution is not to set FItemHeight here. }
//  FItemHeight := 16;
  FDirectory := '.';
  FMask := '*.*';

  {create image object and load bitmaps}
  Bmp := Graphics.TBitmap.Create;
  try
    Bmp.Handle := LoadBaseBitmap('ORFOLDEROPEN');
    cbDirImages := TImageList.CreateSize(Bmp.Width, Bmp.Height);
    cbDirImages.AddMasked(Bmp, clWhite);
    Bmp.Handle := LoadBaseBitmap('ORFOLDERCLOSED');
    cbDirImages.AddMasked(Bmp, clWhite);
  finally
    Bmp.Free;
  end;
end;

destructor TOvcDirectoryComboBox.Destroy;
begin
  cbDirImages.Free;
  cbDirImages := nil;

  inherited Destroy;
end;

procedure TOvcDirectoryComboBox.Loaded;
begin
  inherited Loaded;

  SetDirectory(FDirectory);
  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcDirectoryComboBox.Notification(Component: TComponent;
                                             Operation: TOperation);
begin
  inherited Notification(Component, Operation);

  if (Component is TControl) and (Operation = opRemove) then
    if (Component as TControl) = FFileComboBox then
      FileComboBox := nil;
end;

procedure TOvcDirectoryComboBox.DrawItem(Index : Integer; ItemRect: TRect;
            State : TOwnerDrawState);
var
  SepRect     : TRect;
  BkColor     : TColor;
  TxtRect     : TRect;
  TxtItem     : array [0..63] of Char;
  BkMode      : Integer;
  IsDirectory : Boolean;
  IsOpen      : Boolean;
  LocalLevel  : Integer;
  LocalOffset : Integer;
  DrawingMRUItem : Boolean;
  Icon        : HIcon;
begin
  IsDirectory := (Word(Items.Objects[Index]) and faDirectory) = faDirectory;
  IsOpen := (Word(Items.Objects[Index]) and (faAnyFile + 1)) = (faAnyFile + 1);
  if IsOpen then
    LocalLevel := (Word(Items.Objects[Index]) xor (faAnyFile + 1)) - 1
  else
    LocalLevel := cbDirLevel;

  {Don't indent if drawing edit portion}
  if DrawingEdit then
    LocalOffset := (ItemHeight div 2)
  else
    LocalOffset := (ItemHeight div 2) * LocalLevel + 1;

  TxtRect := ItemRect;
  DrawingMRUItem := (Index < FMRUList.Items.Count) and not DrawingEdit;
  if DrawingMRUItem then begin
    TxtRect.Left := TxtRect.Left + (ItemHeight div 2);
    StrPCopy(TxtItem, Items[Index]);
    BkColor := FMRUListColor;
  end else begin
    TxtRect.Left := TxtRect.Left + ItemHeight + LocalOffset;
    StrPLCopy(TxtItem, DirectoryParse(Items[Index], LocalLevel + 1), High(TxtItem));
    BkColor := Color;
  end;

  if odSelected in State then
    Canvas.Brush.Color := clHighlight
  else
    Canvas.Brush.Color := BkColor;
  Canvas.FillRect(ItemRect);

  if not DrawingMRUItem then begin
    cbDirImages.BkColor := Canvas.Brush.Color;
    if IsOpen then
      cbDirImages.Draw(Canvas, ItemRect.Left + LocalOffset, ItemRect.Top, 0)
    else if IsDirectory then
      cbDirImages.Draw(Canvas, ItemRect.Left + LocalOffset, ItemRect.Top, 1)
    else begin
      Icon := vLoadIcon(FullName(Directory, Items[Index]));
      if Icon <> 0 then
        DrawIconEx(Handle, ItemRect.Left + LocalOffset, ItemRect.Top, Icon,
                   ItemHeight, ItemHeight, 0, 0, DI_NORMAL);
    end;
  end;

  BkMode := GetBkMode(Canvas.Handle);
  SetBkMode(Canvas.Handle, TRANSPARENT);
  DrawText(Canvas.Handle, TxtItem, StrLen(TxtItem), TxtRect,
    DT_SINGLELINE or DT_VCENTER or DT_LEFT);
  SetBkMode(Canvas.Handle, BkMode);

  if DrawingMRUItem and (Index = FMRUList.Items.Count - 1) then begin
    SepRect := ItemRect;
    SepRect.Top    := SepRect.Bottom - cbxSeparatorHeight;
    SepRect.Bottom := SepRect.Bottom;
    Canvas.Pen.Color := clGrayText;

    if not DrawingEdit then
      with SepRect do
        Canvas.Rectangle(Left-1, Top, Right+1, Bottom);
  end;
end;

procedure TOvcDirectoryComboBox.Populate;
var
  SR             : TSearchRec;
  StrDirectories : TStringList;
  StrTree        : TStringList;
  I              : Integer;
  FullDirectory  : string;
  Path           : string;
begin
  FullDirectory := FullName(FDirectory, FMask);
  if FindFirst(FullDirectory, faDirectory, SR) = 0 then begin
    StrDirectories := TStringList.Create;
    StrTree := TStringList.Create;
    try
      repeat
        if (SR.Attr and faDirectory) = faDirectory then
          if (SR.Name <> '.') and (SR.Name <> '..') then begin
            Path := FDirectory;
            if (Path <> '') and (Path[Length(Path)] <> '\') then
              Path := Path + '\';
            Path := Path + SR.Name;
            StrDirectories.AddObject(Path, Pointer(SR.Attr));
          end;
      until FindNext(SR) <> 0;
      StrDirectories.Sort;
      cbDirLevel := DirectoryCount(FullDirectory);
      for I := 1 to cbDirLevel do begin
        Path := DirectoryParseTo(FullDirectory, I);
        StrTree.AddObject(Path, Pointer(I + faAnyFile + 1));
      end;
      if (FMRUList.Items.Count > 0) then
        for I := Pred(Items.Count) downto FMRUList.Items.Count do
          Items.Delete(I)
      else
        Clear;
      Text := '';
      Items.AddStrings(StrTree);
      Items.AddStrings(StrDirectories);

      ItemIndex := FMRUList.Items.Count + cbDirLevel - 1;
    finally
      StrTree.Free;
      StrDirectories.Free;
    end;
  end;
  FindClose(SR);
end;

procedure TOvcDirectoryComboBox.SetDirectory(const Value : string);
begin
  FDirectory := Value;
  if (FDirectory = '.') or (FDirectory = '') or (FDirectory = '\') then begin
    FDirectory := GetCurrentDir;
  end;
  if (FDirectory = '\') then
    FDirectory := Copy(FDirectory, 1, 3);
  Populate;
end;

procedure TOvcDirectoryComboBox.SetDrive(const Value : Char);
begin
  if Value <> FDrive then begin
    FDrive := Value;
    { if FDirectory is an empty string }
    if (FDirectory = '')
    { or FDirectory is not an empty string, and it points to a drive }
    { other than FDrive, then modify FDirectory to point at the root }
    { of the newly selected drive.                                   }
    or ((FDirectory <> '') and (FDrive <> FDirectory[1])) then
      FDirectory := FDrive + ':\';
    Populate;
  end;
end;

procedure TOvcDirectoryComboBox.SetMask(const Value : string);
begin
  if Value <> FMask then begin
    FMask := Value;
    Populate;
  end;
end;

procedure TOvcDirectoryComboBox.SelectionChanged;
begin
  FDirectory := Items[ItemIndex];
  if (FFileComboBox <> nil) then
    FFileComboBox.Directory := FDirectory;
  Populate;
  inherited SelectionChanged;
end;

end.

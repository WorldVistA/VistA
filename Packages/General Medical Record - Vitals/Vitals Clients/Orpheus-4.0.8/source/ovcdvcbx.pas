{*********************************************************}
{*                   OVCDVCBX.PAS 4.06                  *}
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

unit ovcdvcbx;
  {-drive combo box}

interface

uses
  Windows, SysUtils, Classes, Messages, OvcCmbx, OvcDrCbx;

type
  TOvcDriveComboBox = class(TOvcBaseComboBox)
  protected {private}
    {property variables}
    FDrive    : Char;
    FFirstDrive : Char;
    FDirComboBox : TOvcDirectoryComboBox;
    FVolName  : string;

    {property methods}
    procedure SetDrive(const Value : Char);

  protected
    procedure Loaded;
      override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;

    { - Added}
    procedure SetFirstDrive(Value: Char);

  public
    constructor Create(AOwner : TComponent);
      override;
    procedure Populate;
    procedure SelectionChanged;
      override;

    property Drive : Char
      read FDrive
      write SetDrive;
    property VolumeName : string
      read FVolName;

  published
    property DirectoryComboBox : TOvcDirectoryComboBox
      read FDirComboBox
      write FDirComboBox;

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
    property FirstScannedDrive: Char
      read FFirstDrive write SetFirstDrive
      default 'A';
    property Font;
    property HotTrack;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property LabelInfo;
    property MRUListColor;
    property MRUListCount;
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

uses
  ovcStr;

function GetVolume(DriveChar: Char): string;
const
  MaxVolSize = 260;
var
  Path : array [0..3] of Char;
  NU, VolSize : DWord;
  Vol : PChar;
begin
  Path[0] := DriveChar;
  Path[1] := ':';
  Path[2] := #0;
  VolSize := MaxVolSize;
  GetMem(Vol, MaxVolSize * SizeOf(Char));
  Vol[0] := #0;
  Result := '';
  try
    if WNetGetConnection(Path, Vol, VolSize) = WN_SUCCESS then
      Result := StrPas(Vol)
    else begin
      if GetVolumeInformation(PChar(DriveChar + ':\'),
        Vol, MAX_PATH, nil, NU, NU, nil, 0) then
        Result := Vol;
      Result := Format('[%s]',[Result]);
    end;
  finally
    FreeMem(Vol, MaxVolSize);
  end;
end;

constructor TOvcDriveComboBox.Create(AOwner : TComponent);
var
  Dir : String;
begin
  inherited Create(AOwner);
  FAutoSearch := False;
  FFirstDrive := 'A';
  FStyle := ocsDropDownList;
  GetDir(0, Dir);
  FDrive := Dir[1];
  if FDrive = '\' then
    FDrive := #0;
end;

procedure TOvcDriveComboBox.Loaded;
begin
  inherited Loaded;

  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcDriveComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDirComboBox) then
    FDirComboBox := nil;
end;

{ - added}
procedure TOvcDriveComboBox.SetFirstDrive(Value: Char);
begin
  if CharInSet(UpCase(Value), ['A'..'Z']) then
    FFirstDrive := UpCase(Value)
  else
    FFirstDrive := 'A';
  Populate;
end;

procedure TOvcDriveComboBox.Populate;
var
  I         : Integer;
  DriveChar : Char;
  SavedErrorMode: Word;
  VolumeStr: string;
begin

  ClearItems;
  SavedErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    SendMessage(Handle, CB_DIR, DDL_Drives + DDL_Exclusive, NativeInt(PChar('*.*')));
    if Items.Count > 0 then
      for I := 0 to Pred(Items.Count) do begin
        DriveChar := UpCase(Items[I][3]);

{ - begin}
        { Skip any drives that are lower than FFirstDrive }
        if DriveChar < FFirstDrive then
          Items[I] := Format('%s:', [DriveChar])
        else begin
          { prevent empty volume information from being displayed as '[]' }
          VolumeStr := GetVolume(DriveChar);
          if VolumeStr <> '[]' then
            Items[I] := Format('%s: %s', [DriveChar, VolumeStr])
          else
            Items[I] := Format('%s:', [DriveChar]);
        end;
{ - end}

        if (DriveChar = FDrive) then
          ItemIndex := I;
      end;
  finally
    SetErrorMode(SavedErrorMode);
  end;
end;

procedure TOvcDriveComboBox.SelectionChanged;
begin
  FVolName := Items[ItemIndex];
  FDrive := FVolName[1];
  Delete(FVolName, 1, 2);
  if (FDirComboBox <> nil) then
    FDirComboBox.Drive := FDrive;
  inherited SelectionChanged;
end;

procedure TOvcDriveComboBox.SetDrive(const Value : Char);
var
  I  : Integer;
begin
  if (Value = FDrive) then
    Exit;
  if (Items.Count < 1)
    then Populate;
  if (Value = '') then begin
    FDrive := Value;
    ItemIndex := -1;
    SelectionChanged;
  end else begin
    for I := 0 to Pred(Items.Count) do
      if (UpCase(Items[I][1]) = UpCase(Value)) and (Items[I][2] = ':') then begin
        ItemIndex := I;
        break;
      end;
    if (ItemIndex > 0) then
      FDrive := UpCase(Value);
    SelectionChanged;
  end;
end;

end.

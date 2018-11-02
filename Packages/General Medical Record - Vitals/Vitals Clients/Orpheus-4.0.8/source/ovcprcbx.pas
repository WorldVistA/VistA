{*********************************************************}
{*                   OVCPRCBX.PAS 4.06                  *}
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
{*     Sebastian Zierer                                                       *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcprcbx;

interface

uses
  UITypes, Windows, Messages, SysUtils, Classes, Graphics, Controls, Printers,
  ExtCtrls, OvcCmbx, OvcMisc, StdCtrls;

type
  TOvcPrinterComboBox = class(TOvcBaseComboBox)
  protected {private}
    FShowIcons     : Boolean;
    FSelectPrinter : Boolean;
    cbPrnImages    : TImageList;
  protected
    procedure Loaded; override;
    procedure DrawItem(Index : Integer; ItemRect : TRect;
      State : TOwnerDrawState); override;
    procedure SelectionChanged; override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Populate;
  published
    property ShowIcons : Boolean
      read FShowIcons write FShowIcons
      default True;
    property SelectPrinter : Boolean
      read FSelectPrinter write FSelectPrinter
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

{*** TOvcPrinterComboBox ***}

constructor TOvcPrinterComboBox.Create(AOwner : TComponent);
var
  Bmp1, Bmp2 : TBitmap;
begin
  FSelectPrinter := True;
  Bmp1 := Graphics.TBitmap.Create;
  Bmp2 := Graphics.TBitmap.Create;
  Bmp1.Handle := LoadBaseBitmap('ORPRINTER1');  {local printer icon}
  Bmp2.Handle := LoadBaseBitmap('ORPRINTER2');  {network printer icon}
  try
    if (Bmp1.Height > 0) and (Bmp2.Height > 0) then begin
      FItemHeight := Bmp1.Height + 4;
      cbPrnImages := TImageList.CreateSize(Bmp1.Width, Bmp1.Height);
      cbPrnImages.AddMasked(Bmp1, clWhite);
      cbPrnImages.AddMasked(Bmp2, clWhite);
      FShowIcons := True;
    end;
  finally
    Bmp1.Free;
    Bmp2.Free;
  end;
  inherited Create(AOwner);
end;

destructor TOvcPrinterComboBox.Destroy;
begin
  cbPrnImages.Free;
  inherited Destroy;
end;

procedure TOvcPrinterComboBox.Loaded;
begin
  inherited Loaded;
  if not (csDesigning in ComponentState) then
    Populate;
end;

procedure TOvcPrinterComboBox.Populate;
begin
  ClearItems;
  if (Printer.Printers.Count > 0) then begin
    Items.Assign(Printer.Printers);
    ItemIndex := Printer.PrinterIndex;
  end else
    ItemIndex := -1;
end;

procedure TOvcPrinterComboBox.SelectionChanged;
begin
  if SelectPrinter then with Printer do
    PrinterIndex := Printers.IndexOf(Items[ItemIndex]);
  inherited SelectionChanged;
end;

procedure TOvcPrinterComboBox.DrawItem(Index : Integer; ItemRect : TRect;
  State : TOwnerDrawState);
var
  TxtRect : TRect;
  SepRect : TRect;
  TxtItem : string;
  BkMode  : Integer;
  BkColor  : TColor;
  IconIndex : Integer;
begin
  TxtItem := Items[Index];
  TxtRect := ItemRect;
  if ((FMRUList.Items.Count > 0) and (Index < FMRUList.Items.Count)) then
    BkColor := FMRUListColor
  else
    BkColor := Color;
  with Canvas do begin
    if odSelected in State then
      Brush.Color := clHighlight
    else
      Brush.Color := BkColor;
    FillRect(ItemRect);
    if ShowIcons then begin
      cbPrnImages.BkColor := Brush.Color;
      IconIndex := Byte(Pos('\\', Items[Index]) <> 0);
      cbPrnImages.Draw(Canvas, ItemRect.Left+1, ItemRect.Top+1, IconIndex);
      TxtRect.Left := TxtRect.Left + cbPrnImages.Width + 5;
    end;
    BkMode := GetBkMode(Handle);
    SetBkMode(Handle, TRANSPARENT);
    DrawText(Handle, PChar(TxtItem), Length(TxtItem), TxtRect, DT_VCENTER or DT_LEFT);
    SetBkMode(Handle, BkMode);
    if (FMRUList.Items.Count > 0) and (Index = FMRUList.Items.Count - 1) then begin
      SepRect := ItemRect;
      SepRect.Top    := SepRect.Bottom - cbxSeparatorHeight;
      SepRect.Bottom := SepRect.Bottom;
      Pen.Color := clGrayText;

      if not DrawingEdit then
        if (cbxSeparatorHeight = 2) then
          Frame3D(Canvas, SepRect, clGray, clBlack, 1)
        else with SepRect do
          Rectangle(Left-1, Top, Right+1, Bottom);
    end;
  end;
end;

end.

{*********************************************************}
{*                   OVCFTCBX.PAS 4.06                   *}
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

unit ovcftcbx;
  {-font ComboBox}

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Controls, Graphics, Printers,
  OvcCmbx, OvcData, OvcMisc, StdCtrls;

  {  StdCtrls, Menus, ExtCtrls, OvcBase}

type
  TFontCategories   = (fcAll, fcTrueType, fcDevice);
  TFontPitches      = (fpAll, fpFixed, fpVariable);

  TOvcFontComboBox = class(TOvcBaseComboBox)
  protected {private}
    {property variables}
    FPreviewFont    : Boolean;         {If True, fonts are previewed on list}
    FCategories     : TFontCategories; {Categories to list}
    FPitchStyles    : TFontPitches;    {Pitches to list}
    FPreviewControl : TControl;        {Control used to preview font}

    {internal variables}
    fcTTBitmap      : TBitmap;         {TrueType bitmap}
    fcDevBitmap     : TBitmap;         {Device font bitmap}

    {property methods}
    function GetFontName : string;
    procedure SetFontName(const FontName : string);
    procedure SetPreviewControl(Value: TControl);

    {internal methods}
    function FontIsSymbol(const FontName: string): Boolean;

    {private message methods}
    procedure OMUpdatePreview(var Message: TMessage);
      message OM_FONTUPDATEPREVIEW;

    {vcl message methods}
    procedure CmFontChange(var Message: TMessage);
      message CM_FONTCHANGE;

  protected
    procedure DrawItem(Index : Integer; ItemRect : TRect; State : TOwnerDrawState);
      override;
    procedure Loaded;
      override;
    procedure KeyDown(var Key: Word; Shift: TShiftState);
      override;
    procedure Notification(Component: TComponent; Operation: TOperation);
      override;

    procedure DoPreview;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure Populate;
    procedure SelectionChanged;
      override;

    property FontName : string
      read GetFontName
      write SetFontName;

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

    property FontCategories : TFontCategories
      read FCategories
      write FCategories
      default fcAll;

    property FontPitchStyles : TFontPitches
      read FPitchStyles
      write FPitchStyles
      default fpAll;

    property PreviewControl : TControl
      read FPreviewControl
      write SetPreviewControl;

    property PreviewFont : Boolean
      read FPreviewFont
      write FPreviewFont
      default False;

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


type
  { This allows access to protected TControl properties by typecasting }
  TOvcPreviewControl = class(TControl);

{callback used by FontIsSymbol()}
function GetFontCharSet(lpLF : PLogFont; lpTM : PTextMetric;
         FontType : Integer; lParam : NativeInt): Integer; far; stdcall;
begin
  PByte(lParam)^ := lpLF^.lfCharSet;
  Result := 0;
end;

{font family enumeration callbacks}
function EnumFontFamProc(lpLF : PEnumLogFont; lpTM : PNewTextMetric;
         FontType : Integer; lParam : NativeInt) : Integer; far; stdcall;
var
  FontCombo : TOvcFontComboBox;
  Bitmap    : TBitmap;
begin
  FontCombo := TOvcFontComboBox(lParam);
  with FontCombo do begin
    { Filter fonts according to properties }
    if (FontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE) then begin
      Bitmap := fcTTBitmap;
      if (FontCategories in [fcAll, fcTrueType]) then begin
        if ((lpLF^.elfLogFont.lfPitchAndFamily and VARIABLE_PITCH = VARIABLE_PITCH)
          and (FontPitchStyles in [fpAll, fpVariable]))
          or ((lpLF^.elfLogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH)
          and (FontPitchStyles in [fpAll, fpFixed])) then
          if Items.IndexOf(lpLF^.elfLogFont.lfFaceName) = -1 then
            Items.AddObject(lpLF^.elfLogFont.lfFaceName, Bitmap)
      end;
    end else begin
      Bitmap := fcDevBitmap;
      if (FontCategories in [fcAll, fcDevice]) then begin
        if ((lpLF^.elfLogFont.lfPitchAndFamily and VARIABLE_PITCH = VARIABLE_PITCH)
          and (FontPitchStyles in [fpAll, fpVariable]))
          or ((lpLF^.elfLogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH)
          and (FontPitchStyles in [fpAll, fpFixed])) then
          if Items.IndexOf(lpLF^.elfLogFont.lfFaceName) = -1 then
            Items.AddObject(lpLF^.elfLogFont.lfFaceName, Bitmap)
      end;
    end;
  end;
  Result := 1;
end;

function EnumPrinterFontFamProc(lpLF : PEnumLogFont; lpTM : PNewTextMetric;
         FontType : Integer; lParam : NativeInt) : Integer; far; stdcall;
var
  FontCombo : TOvcFontComboBox;
  Bitmap    : TBitmap;
  FaceName  : string;
begin
  FontCombo := TOvcFontComboBox(lParam);
  FaceName  := StrPas(lpLF^.elfFullName);
  with FontCombo do begin
    if Items.IndexOf(FaceName) > -1 then begin
      Result := 1;
      Exit;
    end;
    { Filter fonts according to properties }
    if (FontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE) then begin
      Bitmap := fcTTBitmap;
      if (FontCategories in [fcAll, fcTrueType]) then begin
        if ((lpLF^.elfLogFont.lfPitchAndFamily and VARIABLE_PITCH = VARIABLE_PITCH)
          and (FontPitchStyles in [fpAll, fpVariable]))
          or ((lpLF^.elfLogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH)
          and (FontPitchStyles in [fpAll, fpFixed])) then
          if Items.IndexOf(lpLF^.elfLogFont.lfFaceName) = -1 then
            Items.AddObject(lpLF^.elfLogFont.lfFaceName, Bitmap)
      end;
    end else begin
      Bitmap := fcDevBitmap;
      if (FontCategories in [fcAll, fcDevice]) then begin
        if ((lpLF^.elfLogFont.lfPitchAndFamily and VARIABLE_PITCH = VARIABLE_PITCH)
          and (FontPitchStyles in [fpAll, fpVariable]))
          or ((lpLF^.elfLogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH)
          and (FontPitchStyles in [fpAll, fpFixed])) then
          if Items.IndexOf(lpLF^.elfLogFont.lfFaceName) = -1 then
            Items.AddObject(lpLF^.elfLogFont.lfFaceName, Bitmap)
      end;
    end;
  end;
  Result := 1;
end;


{*** TOvcFontComboBox ***}

procedure TOvcFontComboBox.CMFontChange(var Message : TMessage);
var
  Item : string;
begin
  if ItemIndex > -1 then begin
    Item := Items[ItemIndex];
    Populate;
    ItemIndex := Items.IndexOf(Item);
    if ItemIndex < 0 then
      {the selected font is no longer valid}
      Change;
  end else begin
    Populate;
    Change;
  end;
end;

constructor TOvcFontComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPreviewFont := False;

  fcTTBitmap   := TBitmap.Create;
  fcDevBitmap  := TBitmap.Create;
end;

destructor TOvcFontComboBox.Destroy;
begin

  fcTTBitmap.Free;
  fcDevBitmap.Free;

  inherited Destroy;
end;

procedure TOvcFontComboBox.DoPreview;
begin
  if (Assigned(FPreviewControl)) and (ItemIndex > - 1) then
    TOvcPreviewControl(FPreviewControl).Font.Name := Items[ItemIndex];
end;

procedure TOvcFontComboBox.DrawItem(Index : Integer; ItemRect: TRect;
                                   State : TOwnerDrawState);
var
  Bitmap     : TBitmap;
  SepRect    : TRect;
  BkColor    : TColor;
  TxtRect    : TRect;
  BmpRect    : TRect;
  TxtItem    : array [0..255] of char;
  BkMode     : Integer;
  Printer    : TPrinter;
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

    Bitmap := TBitmap(Items.Objects[Index]);
    if Bitmap <> nil then begin
      BmpRect := Rect(ItemRect.Left, ItemRect.Top,
        ItemRect.Left + Bitmap.Width, ItemRect.Top + Bitmap.Height);
      BrushCopy(BmpRect, Bitmap, Rect(0, 0, Bitmap.Width, Bitmap.Height), clYellow);
    end;

    Printer := TPrinter.Create;
    try
      if FPreviewFont and (Printer.Printers.Count > 0) then begin
        { Do not draw symbol font names with the actual font - use the default }
        if not FontIsSymbol(Items[Index]) then
          Canvas.Font.Name := Items[Index]
        else
          Canvas.Font.Name := Font.Name;
      end;
    except
      Printer.Free;
    end;

    with ItemRect do
      TxtRect := Rect(Left + Bitmap.Width + 2, Top, Right, Bottom);
    StrPCopy(TxtItem, Items[Index]);
    BkMode := GetBkMode( Canvas.Handle );
    SetBkMode( Canvas.Handle, TRANSPARENT );
    DrawText(Canvas.Handle, TxtItem, StrLen(TxtItem), TxtRect,
      DT_VCENTER or DT_LEFT);
    SetBkMode( Canvas.Handle, BkMode );

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

function TOvcFontComboBox.FontIsSymbol(const FontName: string): Boolean;
var
  CharSet        : Byte;
  DC             : hDC;
  FntStr         : array [0..63] of char;
begin
  DC            := GetDC(0);
  CharSet       := 0;
  StrPCopy(FntStr, FontName);

  try
    EnumFonts(DC, FntStr, @GetFontCharSet, PChar(@CharSet)); //SZ FIXME EnumFonts is 16-bit compatibility function
    if CharSet = 0 then
      { It's a printer font }
      EnumFonts(Printer.Handle, FntStr, @GetFontCharSet, PChar(@CharSet));
  finally
    ReleaseDC(0, DC);
  end;

  Result := (CharSet = SYMBOL_CHARSET);
end;

function TOvcFontComboBox.GetFontName : string;
begin
  if ItemIndex > -1 then
    Result := Items[ItemIndex]
  else
    Result := '';
end;

procedure TOvcFontComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DOWN, VK_UP:
      begin
        { Update the preview control's font AFTER the selection has been updated }
        PostMessage(Handle, OM_FONTUPDATEPREVIEW, 0, NativeInt(Self));
      end;
  end;

  inherited KeyDown(Key, Shift);
end;

procedure TOvcFontComboBox.Loaded;
begin
  inherited Loaded;

  if not (csDesigning in ComponentState) then begin
    fcTTBitmap.Handle  := LoadBaseBitmap('ORTRUETYPEFONT');
    fcDevBitmap.Handle := LoadBaseBitmap('ORDEVICEFONT');
    Populate;
  end;
end;

procedure TOvcFontComboBox.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited Notification(Component, Operation);

  if (Component is TControl) and (Operation = opRemove) then
    if (Component as TControl) = FPreviewControl then
      PreviewControl := nil;
end;

procedure TOvcFontComboBox.OMUpdatePreview(var Message: TMessage);
begin
  DoPreview;
end;

procedure TOvcFontComboBox.Populate;
var
  DC            : HDC;
  TempList      : TStringList;
begin
  Clear;
  DC := GetDC(0);
  TempList := TStringList.Create;
  try
    EnumFontFamilies(DC, nil, @EnumFontFamProc, Integer(Self));      //SZ FIXME EnumFontFamilies is 16-bit compatibility function
    if (Printer.Printers.Count > 0) and (Printer.Handle > 0) then
      EnumFontFamilies(Printer.Handle, nil, @EnumPrinterFontFamProc,
        Integer(Self));
    TempList.Assign(Items);
    TempList.Sort;
    Items.Assign(TempList);
  finally
    ReleaseDC(0, DC);
    TempList.Free;
  end;
end;

procedure TOvcFontComboBox.SelectionChanged;
begin
  inherited SelectionChanged;

  DoPreview;
end;

procedure TOvcFontComboBox.SetPreviewControl(Value: TControl);
begin
  if (Value <> Self) then
    FPreviewControl := Value;
end;

procedure TOvcFontComboBox.SetFontName(const FontName : string);
var
  I : Integer;
begin
  I := Items.IndexOf(FontName);
  if I > -1 then
    ItemIndex := I;
end;

end.

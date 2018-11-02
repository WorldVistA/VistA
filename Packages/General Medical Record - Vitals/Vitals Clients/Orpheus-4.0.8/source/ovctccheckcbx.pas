{*********************************************************}
{*                  ovctccheckcbx.PAS 4.08               *}
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

unit ovctccheckcbx;

  {-Orpheus Table Cell - check combo box type}

interface

{$I OVC.INC}

uses
  UITypes, Types, Windows, Messages, Forms, Controls, StdCtrls, Classes,
  Graphics, OvcBase, ovccklb, ovctcmmn, OvcTCell, OvcTCStr, Themes;

type
  TCellCheckComboBoxItem = class(TCollectionItem)
  private
    FValue: string;
    FDisplayValue: string;
    FDisplayValueShort: string;
    procedure SetDisplayValue(const Value: string);
    procedure SetDisplayValueShort(const Value: string);
    procedure SetValue(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property DisplayValue: string read FDisplayValue write SetDisplayValue;
    property DisplayValueShort: string read FDisplayValueShort write SetDisplayValueShort;
    property Value: string read FValue write SetValue;
  end;

  TCellCheckComboBoxItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TCellCheckComboBoxItem;
    procedure SetItem(Index: Integer; const Value: TCellCheckComboBoxItem);
    constructor CreateOwned(const AOwner: TControl);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TCellCheckComboBoxItem; overload;
    function Add(DisplayName, DisplayNameShort, Value: string): TCellCheckComboBoxItem; overload;
    property Items[Index: Integer]: TCellCheckComboBoxItem read GetItem write SetItem; default;
    constructor Create;
  end;

  TCellCheckComboBoxInfo = record
    RTItems: TCellCheckComboBoxItems;
    CheckedItems: TStrings;
    TextHint: string;
  end;
  PCellCheckComboBoxInfo = ^TCellCheckComboBoxInfo;

  TOvcTCCheckComboBoxEdit = class(TCustomControl)
  private
    FCell: TOvcBaseTableCell;
    FDropDown: TOvcPopupWindow;
    FCheckList: TOvcCheckList;
    FItems: TCellCheckComboBoxItems;
    FIsDroppedDown: Boolean;
    FCloseTime: Cardinal;
    FInUpdate: Boolean;
    FOnStateChange: TOvcStateChangeEvent;
    FCellAttr: TOvcCellAttributes;
    FDropDownCount: Integer;
    FCheckedItems: TStrings;
    procedure ShowDropDown;
    procedure SetItems(const Value: TCellCheckComboBoxItems);
    procedure DropDownClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckListStateChange(Sender: TObject; Index: Integer; OldState, NewState: TCheckBoxState);
    procedure CheckedItemsChange(Sender: TObject);
    procedure SetOnStateChange(const Value: TOvcStateChangeEvent);
//    class procedure DrawArrow(Canvas: TCanvas; const CellRect: TRect; const CellAttr: TOvcCellAttributes);
    class procedure DrawButton(Canvas: TCanvas; const CellRect: TRect);
    procedure DrawBackground(Canvas: TCanvas; const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean);
    class procedure DrawText(Canvas: TCanvas; const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean; Items: TCellCheckComboBoxItems; const CheckedItems: TStrings);
    procedure SetCellAttr(const Value: TOvcCellAttributes);
    procedure SetDropDownCount(const Value: Integer);
    procedure SetCheckedItems(const Value: TStrings);
    procedure CheckListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function GetMultiCheck: Boolean;
    procedure SetMultiCheck(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer;
      Y: Integer); override;
    procedure DoOnStateChange(Index : Integer; OldState, NewState : TCheckBoxState); virtual;
    procedure CMFocusChanged(var Message: TCMFocusChanged);
      message CM_FOCUSCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CMRelease(var Message: TMessage); message CM_RELEASE;
    property CellAttr: TOvcCellAttributes read FCellAttr write SetCellAttr;

    procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
    property CellOwner : TOvcBaseTableCell read FCell write FCell;
  published
    property Items: TCellCheckComboBoxItems read FItems write SetItems;
    property CheckedItems: TStrings read FCheckedItems write SetCheckedItems;
    property OnStateChange: TOvcStateChangeEvent read FOnStateChange write SetOnStateChange;
    property DropDownCount: Integer read FDropDownCount write SetDropDownCount default 8;
    property MultiCheck: Boolean read GetMultiCheck write SetMultiCheck default True;
  end;

  TOvcTCCustomCheckComboBox = class(TOvcTCBaseString)
  protected {private}
    {property fields - even size}
    FDropDownCount        : Integer;
    FEdit                 : TOvcTCCheckComboBoxEdit;
    FItems                : TCellCheckComboBoxItems;
    FMaxLength            : Word;

    {property fields - odd size}
    FAutoAdvanceChar      : Boolean;
    FAutoAdvanceLeftRight : Boolean;
    FHideButton           : Boolean;
    FSaveStringValue      : boolean;
    FSorted               : Boolean;
    FShowArrow            : Boolean;
    FUseRunTimeItems      : Boolean;

    {events}
    FOnChange             : TNotifyEvent;
    FOnDropDown           : TNotifyEvent;
    FOnDrawItem           : TDrawItemEvent;
    FOnMeasureItem        : TMeasureItemEvent;
  private
    FMultiCheck: Boolean;
    FTextHint: string;
    procedure SetItems(const Value: TCellCheckComboBoxItems);
    procedure SetMultiCheck(const Value: Boolean);
    procedure SetTextHint(const Value: string);
  protected
    function GetCellEditor : TControl; override;

//    procedure SetShowArrow(Value : Boolean);
//    procedure SetItems(I : TStrings);
//    procedure SetSorted(S : boolean);

    procedure DrawArrow(Canvas   : TCanvas; const CellRect : TRect; const CellAttr : TOvcCellAttributes);
    procedure DrawButton(Canvas   : TCanvas; const CellRect : TRect);
    procedure DrawBackground(Canvas: TCanvas; const CellRect: TRect; CellAttr: TOvcCellAttributes);

    procedure tcPaint(TableCanvas : TCanvas;
                const CellRect    : TRect;
                      RowNum      : TRowNum;
                      ColNum      : TColNum;
                const CellAttr    : TOvcCellAttributes;
                      Data        : pointer); override;
    {properties}
//    property AutoAdvanceChar : boolean read FAutoAdvanceChar write FAutoAdvanceChar;
//    property AutoAdvanceLeftRight : boolean read FAutoAdvanceLeftRight write FAutoAdvanceLeftRight;
    property DropDownCount : Integer read FDropDownCount write FDropDownCount;
    property HideButton: Boolean read FHideButton write FHideButton;
    property Items: TCellCheckComboBoxItems read FItems write SetItems;
//    property Sorted : boolean read FSorted write SetSorted;
//    property ShowArrow : Boolean read FShowArrow write SetShowArrow;
    property UseRunTimeItems: Boolean read FUseRunTimeItems write FUseRunTimeItems;
    {events}
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
    property MultiCheck: Boolean read FMultiCheck write SetMultiCheck default True;
    property TextHint: string read FTextHint write SetTextHint;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function CreateEditControl : TOvcTCCheckComboBoxEdit; virtual;

    function  EditHandle : THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect : TRect); override;

    procedure SaveEditedData(Data : pointer); override;
    procedure StartEditing(RowNum : TRowNum; ColNum : TColNum; CellRect : TRect;
      const CellAttr : TOvcCellAttributes; CellStyle: TOvcTblEditorStyle; Data : pointer); override;
    procedure StopEditing(SaveValue : boolean; Data : pointer); override;
  end;

  TOvcTCCheckComboBox = class(TOvcTCCustomCheckComboBox)
  published
    property AcceptActivationClick default True;
    property Access default otxDefault;
    property Adjust default otaDefault;
//      property AutoAdvanceChar default False;
//      property AutoAdvanceLeftRight default False;
    property Color;
    property DropDownCount default 8;
    property Font;
    property HideButton default False;
    property Hint;
    property Items;
    property ShowHint default False;
    property Margin default 4;
    property MultiCheck;
//      property MaxLength default 0;
//      property SaveStringValue default False;
//      property ShowArrow default False;
//      property Sorted default False;
    property Table;
    property TableColor default True;
    property TableFont default True;
    property TextHiColor default clBtnHighlight;
    property TextStyle default tsFlat;
    property UseRunTimeItems default False;
    property TextHint;

    {events inherited from custom ancestor}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnOwnerDraw;
  end;

implementation

uses
  SysUtils, ovctccbx, ovcmisc;

var
  OvcComboBoxBitmap      : TBitmap;
  ComboBoxResourceCount : Integer = 0;

const
  ComboBoxHeight = 24;

function ThemesEnabled: Boolean; inline;
begin
  Result := StyleServices.Enabled;
end;

function ThemeServices: TCustomStyleServices; inline;
begin
  Result := StyleServices;
end;

{ TCellCheckComboBoxItem }

procedure TCellCheckComboBoxItem.Assign(Source: TPersistent);
  procedure AssignCellCheckComboBoxItem(Src: TCellCheckComboBoxItem);
  begin
    FValue := Src.Value;
    FDisplayValue := Src.FDisplayValue;
    FDisplayValueShort := Src.FDisplayValueShort;
    Changed(False);
  end;
begin
  if Source is TCellCheckComboBoxItem then
    AssignCellCheckComboBoxItem(Source as TCellCheckComboBoxItem)
  else
    inherited;
end;

procedure TCellCheckComboBoxItem.SetDisplayValue(const Value: string);
begin
  FDisplayValue := Value;
  Changed(False);
end;

procedure TCellCheckComboBoxItem.SetDisplayValueShort(const Value: string);
begin
  FDisplayValueShort := Value;
  Changed(False);
end;

procedure TCellCheckComboBoxItem.SetValue(const Value: string);
begin
  FValue := Value;
  Changed(False);
end;

{ TOvcTCCheckComboBoxEdit }

procedure TOvcTCCheckComboBoxEdit.CheckedItemsChange(Sender: TObject);
begin
  if not FInUpdate then
    Invalidate;
end;

procedure TOvcTCCheckComboBoxEdit.CheckListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
begin
  I := FCheckList.ItemAtPos(Point(x, y), True);
  if I <> -1 then
    if not FCheckList.Selected[I] then
      FCheckList.Selected[I] := True;
end;

procedure TOvcTCCheckComboBoxEdit.CheckListStateChange(Sender: TObject;
  Index: Integer; OldState, NewState: TCheckBoxState);
var
  I: Integer;
begin
  if not FInUpdate then
    if (Index < FItems.Count) then
    begin
      if NewState = cbChecked then
        FCheckedItems.Add(FItems[Index].Value)
      else
      begin
        I := FCheckedItems.IndexOf(FItems[Index].Value);
        if I <> -1 then
          FCheckedItems.Delete(I);
      end;
      DoOnStateChange(Index, OldState, NewState);
    end;
end;

procedure TOvcTCCheckComboBoxEdit.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  Invalidate;
end;

procedure TOvcTCCheckComboBoxEdit.CMRelease(var Message: TMessage);
begin
  Free;
end;

constructor TOvcTCCheckComboBoxEdit.Create(AOwner: TComponent);
begin
  inherited;
  FCheckedItems := TStringList.Create;
  TStringList(FCheckedItems).Sorted := True;
  TStringList(FCheckedItems).Duplicates := dupIgnore;
  TStringList(FCheckedItems).OnChange := CheckedItemsChange;
  Width := 145;
  Height := 21;
  DropDownCount := 8;
  ControlStyle := ControlStyle + [csOpaque];
  FCellAttr.caAccess := otxDefault;
  FCellAttr.caAdjust := otaDefault;
  FCellAttr.caColor := clWindow; // Background Color
  FCellAttr.caFont := Font;
  FCellAttr.caFontColor := clBtnText;
  FCellAttr.caFontHiColor := clHighlightText;
  FCellAttr.caTextStyle := tsFlat;
  FDropDown := TOvcPopupWindow.CreateNew(Self);
  FDropDown.CloseAction := caHide;
  FDropDown.OnClose := DropDownClose;
  FDropDown.Color := clBlack;
  FItems := TCellCheckComboBoxItems.CreateOwned(Self);
  FCheckList := TOvcCheckList.Create(FDropDown);
  FCheckList.OnStateChange := CheckListStateChange;
  FCheckList.Align := alClient;
  FCheckList.AlignWithMargins := True; // Align with Margins = 1 so we get a black border
  FCheckList.Margins.Left := 1;
  FCheckList.Margins.Top:= 1;
  FCheckList.Margins.Right := 1;
  FCheckList.Margins.Bottom := 1;
  FCheckList.BorderStyle := bsNone;
  FCheckList.Parent := FDropDown;
  FCheckList.BoxClickOnly := False;
  FCheckList.WantDblClicks := False;
  FCheckList.OnMouseMove := CheckListMouseMove;
  FCheckList.MultiCheck := True;
  FDropDown.ActiveControl := FCheckList;
  TabStop := True;
end;

destructor TOvcTCCheckComboBoxEdit.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FCheckedItems);
  inherited;
end;

procedure TOvcTCCheckComboBoxEdit.DoOnStateChange(Index: Integer; OldState,
  NewState: TCheckBoxState);
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, Index, OldState, NewState);
  Invalidate;
end;

(*
class procedure TOvcTCCheckComboBoxEdit.DrawArrow(Canvas: TCanvas;
  const CellRect: TRect; const CellAttr: TOvcCellAttributes);
var
  ArrowDim : Integer;
  X, Y     : Integer;
  LeftPoint, RightPoint, BottomPoint : TPoint;
  Width    : integer;
  Height   : integer;
  R        : TRect;
begin
  R := CellRect;
  R.Left := R.Right - OvcComboBoxButtonWidth;
  Width := R.Right - R.Left;
  Height := R.Bottom - R.Top;
  with Canvas do
    begin
      Brush.Color := CellAttr.caColor;
      FillRect(R);
      Pen.Color := CellAttr.caFont.Color;
      Brush.Color := Pen.Color;
      ArrowDim := MinI(Width, Height) div 3;
      X := R.Left + (Width - ArrowDim) div 2;
      Y := R.Top + (Height - ArrowDim) div 2;
      LeftPoint := Point(X, Y);
      RightPoint := Point(X+ArrowDim, Y);
      BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
      Polygon([LeftPoint, RightPoint, BottomPoint]);
    end;
end;
*)

procedure TOvcTCCheckComboBoxEdit.DrawBackground(Canvas: TCanvas;
  const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean);
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := CellAttr.caColor;
    Pen.Color := clBlack;
    Rectangle(CellRect);
    R := CellRect;
    Inc(R.Top, 2);
    Inc(R.Left, 2);
    Dec(R.Bottom, 2);
    Dec(R.Right, 1 + OvcComboBoxButtonWidth);
    if Focused then
    begin
      Brush.Color := clHighlight;
      FillRect(R);
      Brush.Color := CellAttr.caColor;
      DrawFocusRect(R);
    end;
  end;
end;

class procedure TOvcTCCheckComboBoxEdit.DrawButton(Canvas: TCanvas;
  const CellRect: TRect);
var
  EffCellWidth : Integer;
  Wd, Ht       : Integer;
  TopPixel     : Integer;
  BotPixel     : Integer;
  LeftPixel    : Integer;
  RightPixel   : Integer;
  SrcRect      : TRect;
  DestRect     : TRect;
  Details: TThemedElementDetails;
  BtnRect: TRect;
begin
  {Calculate the effective cell width (the cell width less the size
   of the button)}
  EffCellWidth := CellRect.Right - CellRect.Left - OvcComboBoxButtonWidth;

  {Calculate the black border's rectangle}
  LeftPixel := CellRect.Left + EffCellWidth;
  RightPixel := CellRect.Right - 1;
  TopPixel := CellRect.Top + 1;
  BotPixel := CellRect.Bottom - 1;

  if ThemesEnabled then
  begin
    Details := ThemeServices.GetElementDetails(tcDropDownButtonNormal);
    BtnRect := CellRect;
    BtnRect.Left := CellRect.Right - OvcComboBoxButtonWidth;
    ThemeServices.DrawElement(canvas.handle, Details, BtnRect);
  end
  else
  {Paint the button}
  with Canvas do
    begin
      {FIRST: paint the black border around the button}
      Pen.Color := clBlack;
      Pen.Width := 1;
      Brush.Color := clBtnFace;
      {Note: Rectangle excludes the Right and bottom pixels}
      Rectangle(LeftPixel, TopPixel, RightPixel, BotPixel);
      {SECOND: paint the highlight border on left/top sides}
      {decrement drawing area}
      inc(TopPixel);
      dec(BotPixel);
      inc(LeftPixel);
      dec(RightPixel);
      {Note: PolyLine excludes the end points of a line segment,
             but since the end points are generally used as the
             starting point of the next we must adjust for it.}
      Pen.Color := clBtnHighlight;
      PolyLine([Point(RightPixel-1, TopPixel),
                Point(LeftPixel, TopPixel),
                Point(LeftPixel, BotPixel)]);
      {THIRD: paint the highlight border on bottom/right sides}
      Pen.Color := clBtnShadow;
      PolyLine([Point(LeftPixel, BotPixel-1),
                Point(RightPixel-1, BotPixel-1),
                Point(RightPixel-1, TopPixel-1)]);
      inc(TopPixel);
      dec(BotPixel);
      inc(LeftPixel);
      dec(RightPixel);
      PolyLine([Point(LeftPixel, BotPixel-1),
                Point(RightPixel-1, BotPixel-1),
                Point(RightPixel-1, TopPixel-1)]);
      {THIRD: paint the arrow bitmap}
      Wd := OvcComboBoxBitmap.Width;
      Ht := OvcComboBoxBitmap.Height;
      SrcRect := Rect(0, 0, Wd, Ht);
      with DestRect do
        begin
          Left := CellRect.Left + EffCellWidth + 5;
          Top := CellRect.Top +
                 ((CellRect.Bottom - CellRect.Top - Ht) div 2);
          Right := Left + Wd;
          Bottom := Top + Ht;
        end;
      BrushCopy(DestRect, OvcComboBoxBitmap, SrcRect, clSilver);
    end;
end;

class procedure TOvcTCCheckComboBoxEdit.DrawText(Canvas: TCanvas;
  const CellRect: TRect; CellAttr: TOvcCellAttributes; Focused: Boolean;
  Items: TCellCheckComboBoxItems; const CheckedItems: TStrings);
var
  S: string;
  I: Integer;
  R: TRect;
begin
  R := CellRect;
  Inc(R.Top, 2);
  Inc(R.Left, 2);
  Dec(R.Bottom, 2);
  Dec(R.Right, 1 + OvcComboBoxButtonWidth);

  S := '';
  for I := 0 to Items.Count - 1 do
    if CheckedItems.IndexOf(Items[I].Value) <> -1 then
    begin
      if S <> '' then
        S := S + '; ';
      if Items[I].DisplayValueShort <> '' then
        S := S + Items[I].DisplayValueShort
      else if Items[I].DisplayValue <> '' then
        S := S + Items[I].DisplayValue
      else
        S := S + Items[I].Value;
    end;

  Canvas.Brush.Style := bsClear;
  Canvas.Font := CellAttr.caFont;
  if Focused then
    Canvas.Font.Color := CellAttr.caFontHiColor
  else
    Canvas.Font.Color := CellAttr.caFontColor;
  Canvas.TextRect(R, S, [tfVerticalCenter, tfEndEllipsis, tfSingleLine]);
end;

procedure TOvcTCCheckComboBoxEdit.DropDownClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FIsDroppedDown := False;
  FCloseTime := GetTickCount;
  Invalidate;
end;

function TOvcTCCheckComboBoxEdit.GetMultiCheck: Boolean;
begin
  Result := FCheckList.MultiCheck;
end;

procedure TOvcTCCheckComboBoxEdit.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Windows.SetFocus(Handle);
  if Button = mbLeft then
    if not FIsDroppedDown and (GetTickCount - FCloseTime > GetDoubleClickTime) then
      ShowDropDown
    else
      FCloseTime := 0;
  inherited;
end;

procedure TOvcTCCheckComboBoxEdit.Paint;
begin
  inherited;
  DrawBackground(Canvas, ClientRect, FCellAttr, Focused and not FIsDroppedDown);
  DrawText(Canvas, ClientRect, FCellAttr, Focused and not FIsDroppedDown, FItems, FCheckedItems);
  DrawButton(Canvas, ClientRect);
end;

procedure TOvcTCCheckComboBoxEdit.SetCellAttr(const Value: TOvcCellAttributes);
begin
  FCellAttr := Value;
  Invalidate;
end;

procedure TOvcTCCheckComboBoxEdit.SetCheckedItems(const Value: TStrings);
begin
  FCheckedItems.Assign(Value);
  // Assigning FCheckedItems also assignes the "Sorted" and "Duplicates"
  // properties but we need to ignore duplicates - otherwise it is not
  // possible to uncheck items reliably after save/loadrecreateitems
  if FCheckedItems is TStringList then // FCheckedItems is created as TStringList, but we better double check
  begin
    TStringList(FCheckedItems).Sorted := True;
    TStringList(FCheckedItems).Duplicates := dupIgnore;
  end;
end;

procedure TOvcTCCheckComboBoxEdit.SetDropDownCount(const Value: Integer);
begin
  FDropDownCount := Value;
end;

procedure TOvcTCCheckComboBoxEdit.SetItems(
  const Value: TCellCheckComboBoxItems);
begin
  FItems.Assign(Value);
end;

procedure TOvcTCCheckComboBoxEdit.SetMultiCheck(const Value: Boolean);
begin
  FCheckList.MultiCheck := Value;
end;

procedure TOvcTCCheckComboBoxEdit.SetOnStateChange(
  const Value: TOvcStateChangeEvent);
begin
  FOnStateChange := Value;
end;

procedure TOvcTCCheckComboBoxEdit.ShowDropDown;
var
  P: TPoint;
  I: Integer;
  Monitor: TMonitor;
begin
  P := ClientToScreen(Point(0, Height));
  FCheckList.Items.BeginUpdate;
  FInUpdate := True;
  try
    FCheckList.Items.Clear;
    for I := 0 to FItems.Count - 1 do
    begin
      if FItems[I].DisplayValue <> '' then
        FCheckList.Items.Add(FItems[I].DisplayValue)
      else
        FCheckList.Items.Add(FItems[I].Value);
    end;
    for I := 0 to FItems.Count - 1 do
      if FCheckedItems.IndexOf(FItems[I].Value) <> -1 then
        FCheckList.States[I] := cbChecked
      else
        FCheckList.States[I] := cbUnchecked;
  finally
    FInUpdate := False;
    FCheckList.Items.EndUpdate;
  end;
  FDropDown.Width := Self.Width;
  FDropDown.Height := FCheckList.ItemHeight * MinI(FItems.Count, FDropDownCount) + 2;
  // keep dropdown within screen
  Monitor := Screen.MonitorFromPoint(P);
  if Assigned(Monitor) and (P.Y + FDropDown.Height > Monitor.WorkareaRect.Bottom) then
  begin
    P := ClientToScreen(Point(0, 0));
    P.Y := P.Y - FDropDown.Height;
    if P.Y < Monitor.Top then
      P.Y := Monitor.Top;
  end;
  FDropDown.Popup(P);
  FIsDroppedDown := True;
end;

procedure TOvcTCCheckComboBoxEdit.WMKillFocus(var Msg: TWMKillFocus);
begin

end;

procedure TOvcTCCheckComboBoxEdit.WMSetFocus(var Msg: TWMSetFocus);
begin
  if Assigned(CellOwner) then
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;

{ TCellCheckComboBoxItems }

function TCellCheckComboBoxItems.Add: TCellCheckComboBoxItem;
begin
  Result := TCellCheckComboBoxItem(inherited Add);
end;

constructor TCellCheckComboBoxItems.CreateOwned(const AOwner: TControl);
begin
  inherited Create(AOwner, TCellCheckComboBoxItem);
end;

function TCellCheckComboBoxItems.Add(DisplayName, DisplayNameShort,
  Value: string): TCellCheckComboBoxItem;
begin
  Result := Add;
  Result.DisplayValue := DisplayName;
  Result.DisplayValueShort := DisplayNameShort;
  Result.Value := Value;
end;

constructor TCellCheckComboBoxItems.Create;
begin
  inherited Create(nil, TCellCheckComboBoxItem);
end;

function TCellCheckComboBoxItems.GetItem(
  Index: Integer): TCellCheckComboBoxItem;
begin
  Result := TCellCheckComboBoxItem(inherited Items[Index]);
end;

procedure TCellCheckComboBoxItems.SetItem(Index: Integer;
  const Value: TCellCheckComboBoxItem);
begin
  inherited Items[index] := Value;
end;

procedure TCellCheckComboBoxItems.Update(Item: TCollectionItem);
begin
  inherited;
  if Owner is TOvcTCCheckComboBoxEdit then
    TOvcTCCheckComboBoxEdit(Owner).Invalidate;
end;

{ TOvcTCCustomCheckComboBox }

constructor TOvcTCCustomCheckComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  FItems := TStringList.Create;
  FDropDownCount := 8;
  if (ComboBoxResourceCount = 0) then
    begin
      OvcComboBoxBitmap := TBitMap.Create;
      OvcComboBoxBitmap.Handle := LoadBaseBitMap('ORTCCOMBOARROW');
      OvcComboBoxButtonWidth := OvcComboBoxBitmap.Width + 11;
    end;
  inc(ComboBoxResourceCount);
  FAcceptActivationClick := true;
  FShowArrow := False;
  FHideButton := False;
  FMultiCheck := True;
  FItems := TCellCheckComboBoxItems.Create;
end;

function TOvcTCCustomCheckComboBox.CreateEditControl: TOvcTCCheckComboBoxEdit;
begin
  Result := TOvcTCCheckComboBoxEdit.Create(FTable);
end;

destructor TOvcTCCustomCheckComboBox.Destroy;
begin
  FreeAndNil(FItems);
  Dec(ComboBoxResourceCount);
  if (ComboBoxResourceCount = 0) then
    OvcComboBoxBitmap.Free;
  inherited Destroy;
end;

procedure TOvcTCCustomCheckComboBox.DrawArrow(Canvas: TCanvas;
  const CellRect: TRect; const CellAttr: TOvcCellAttributes);
var
  ArrowDim : Integer;
  X, Y     : Integer;
  LeftPoint, RightPoint, BottomPoint : TPoint;
  Width    : integer;
  Height   : integer;
  R        : TRect;
begin
  R := CellRect;
  R.Left := R.Right - OvcComboBoxButtonWidth;
  Width := R.Right - R.Left;
  Height := R.Bottom - R.Top;
  with Canvas do
    begin
      Brush.Color := CellAttr.caColor;
      FillRect(R);
      Pen.Color := CellAttr.caFont.Color;
      Brush.Color := Pen.Color;
      ArrowDim := MinI(Width, Height) div 3;
      X := R.Left + (Width - ArrowDim) div 2;
      Y := R.Top + (Height - ArrowDim) div 2;
      LeftPoint := Point(X, Y);
      RightPoint := Point(X+ArrowDim, Y);
      BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
      Polygon([LeftPoint, RightPoint, BottomPoint]);
    end;
end;

procedure TOvcTCCustomCheckComboBox.DrawBackground(Canvas: TCanvas;
  const CellRect: TRect; CellAttr: TOvcCellAttributes);
var
  R: TRect;
begin
  with Canvas do
  begin
    Brush.Color := CellAttr.caColor;
    FillRect(CellRect);
    R := CellRect;
    Inc(R.Top, 2);
    Inc(R.Left, 2);
    Dec(R.Bottom, 2);
    Dec(R.Right, 1 + OvcComboBoxButtonWidth);
  end;
end;

procedure TOvcTCCustomCheckComboBox.DrawButton(Canvas: TCanvas;
  const CellRect: TRect);
begin
  TOvcTCCheckComboBoxEdit.DrawButton(Canvas, CellRect);
end;

function TOvcTCCustomCheckComboBox.EditHandle: THandle;
begin
  if Assigned(FEdit) then
    Result := FEdit.Handle
  else
    Result := 0;
end;

procedure TOvcTCCustomCheckComboBox.EditHide;
begin
  if Assigned(FEdit) then
    with FEdit do
      begin
        SetWindowPos(FEdit.Handle, HWND_TOP,
                     0, 0, 0, 0,
                     SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
      end;
end;

procedure TOvcTCCustomCheckComboBox.EditMove(CellRect: TRect);
var
  EditHandle : HWND;
  NewTop : Integer;
begin
  if Assigned(FEdit) then
    begin
      EditHandle := FEdit.Handle;
      with CellRect do
        begin
          NewTop := Top;
          if FEdit.Ctl3D then
            InflateRect(CellRect, -1, -1);
          SetWindowPos(EditHandle, HWND_TOP,
                       Left, NewTop, Right-Left, ComboBoxHeight,
                       SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        end;
      InvalidateRect(EditHandle, nil, false);
      UpdateWindow(EditHandle);
    end;
end;

function TOvcTCCustomCheckComboBox.GetCellEditor: TControl;
begin
  Result := FEdit;
end;

procedure TOvcTCCustomCheckComboBox.SaveEditedData(Data: pointer);
var
  ItemRec : PCellCheckComboBoxInfo absolute Data;
begin
  if Assigned(Data) then
    ItemRec^.CheckedItems.Assign(FEdit.CheckedItems);
end;

procedure TOvcTCCustomCheckComboBox.SetItems(
  const Value: TCellCheckComboBoxItems);
begin
  FItems.Assign(Value);
end;

procedure TOvcTCCustomCheckComboBox.SetMultiCheck(const Value: Boolean);
begin
  FMultiCheck := Value;
end;

procedure TOvcTCCustomCheckComboBox.SetTextHint(const Value: string);
begin
  FTextHint := Value;
  if Assigned(FTable) then
    FTable.Invalidate;
end;

procedure TOvcTCCustomCheckComboBox.StartEditing(RowNum: TRowNum;
  ColNum: TColNum; CellRect: TRect; const CellAttr: TOvcCellAttributes;
  CellStyle: TOvcTblEditorStyle; Data: pointer);
var
  ItemRec : PCellCheckComboBoxInfo absolute Data;
begin
  FEdit := CreateEditControl;
  with FEdit do
    begin
      Color := CellAttr.caColor;
      Ctl3D := false;
      case CellStyle of
        tes3D     : Ctl3D := true;
      end;{case}
      Left := CellRect.Left;
      Top := CellRect.Top;
      Width := CellRect.Right - CellRect.Left;
      Font := CellAttr.caFont;
      Font.Color := CellAttr.caFontColor;
      Hint := Self.Hint;
      ShowHint := Self.ShowHint;
      Visible := true;
      CellOwner := Self;
      TabStop := False;
      Parent := FTable;
      DropDownCount := Self.DropDownCount;
      FEdit.MultiCheck := Self.FMultiCheck;
//      Sorted := Self.Sorted;
      if UseRunTimeItems then
        Items := ItemRec^.RTItems
      else
        Items := Self.Items;
      if Data = nil then
        FEdit.CheckedItems.Clear
      else
        FEdit.CheckedItems := ItemRec^.CheckedItems;

      OnChange := Self.OnChange;
      OnClick := Self.OnClick;
      OnDblClick := Self.OnDblClick;
      OnDragDrop := Self.OnDragDrop;
      OnDragOver := Self.OnDragOver;
      OnDrawItem := Self.OnDrawItem;
      OnDropDown := Self.OnDropDown;
      OnEndDrag := Self.OnEndDrag;
      OnEnter := Self.OnEnter;
      OnExit := Self.OnExit;
      OnKeyDown := Self.OnKeyDown;
      OnKeyPress := Self.OnKeyPress;
      OnKeyUp := Self.OnKeyUp;
      OnMeasureItem := Self.OnMeasureItem;
      OnMouseDown := Self.OnMouseDown;
      OnMouseMove := Self.OnMouseMove;
      OnMouseUp := Self.OnMouseUp;
    end;
end;

procedure TOvcTCCustomCheckComboBox.StopEditing(SaveValue: boolean;
  Data: pointer);
var
  ItemRec : PCellCheckComboBoxInfo absolute Data;
begin
  if SaveValue and Assigned(Data) then
    ItemRec^.CheckedItems.Assign(FEdit.CheckedItems);

  PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
  FEdit := nil;
end;

procedure TOvcTCCustomCheckComboBox.tcPaint(TableCanvas: TCanvas;
  const CellRect: TRect; RowNum: TRowNum; ColNum: TColNum;
  const CellAttr: TOvcCellAttributes; Data: pointer);
var
  ItemRec   : PCellCheckComboBoxInfo absolute Data;
  ActiveRow : TRowNum;
  ActiveCol : TColNum;
  R         : TRect;
  S         : string;
  OurItems  : TCellCheckComboBoxItems;
  I         : Integer;
  LCellAttr : TOvcCellAttributes;
begin
  LCellAttr := CellAttr;
  {If the cell is invisible let the ancestor do all the work}
  if (LCellAttr.caAccess = otxInvisible) then begin
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, nil);
    Exit;
  end;

  {If we have valid data, get the string to display from the stringlist
   or from the Data pointer. }
  S := '';
  if (Data <> nil) then
  begin
    if UseRunTimeItems then
      OurItems := ItemRec^.RTItems
    else
      OurItems := Items;

      for I := 0 to OurItems.Count - 1 do
      begin
        if ItemRec^.CheckedItems.IndexOf(OurItems[I].Value) <> -1 then
        begin
          if S <> '' then
            S := S + '; ';
          if OurItems[I].DisplayValueShort <> '' then
            S := S + OurItems[I].DisplayValueShort
          else if OurItems[I].DisplayValue <> '' then
            S := S + OurItems[I].DisplayValue
          else if OurItems[I].Value <> '' then
            S := S + OurItems[I].Value;
        end;
      end;

      // if nothing is displayed, display TextHint instead
      // try getting row specific hint from ItemRec^
      if (S = '') and (ItemRec^.TextHint <> '') then
      begin
        S := ItemRec^.TextHint;
        LCellAttr.caFontColor := clGray;
      end;
    // if still no hint available, try using the TextHint TOvcTCCustomCheckComboBox
      if (S = '') and (FTextHint <> '') then
      begin
        S := FTextHint;
        LCellAttr.caFontColor := clGray;
      end;
    end
//  {Otherwise, mock up a string in design mode.}
  else if (csDesigning in ComponentState) and (Items.Count > 0) then
    S := Items[RowNum mod Items.Count].Value;

  ActiveRow := tcRetrieveTableActiveRow;
  ActiveCol := tcRetrieveTableActiveCol;
  {Calculate the effective cell width (the cell width less the size of the button)}
  R := CellRect;
  dec(R.Right, OvcComboBoxButtonWidth);
  if (ActiveRow = RowNum) and (ActiveCol = ColNum) then begin
    if FHideButton then begin
      {let ancestor paint the text}
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);
    end else begin
      {Paint the string in the restricted rectangle}
      inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
      {Paint the button on the right side}
      DrawButton(TableCanvas, CellRect);
    end;
  end else if FShowArrow then begin
    {paint the string in the restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, LCellAttr, @S);
    {Paint the arrow on the right side}
    DrawArrow(TableCanvas, CellRect, LCellAttr);
  end else
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, LCellAttr, @S);
end;

end.

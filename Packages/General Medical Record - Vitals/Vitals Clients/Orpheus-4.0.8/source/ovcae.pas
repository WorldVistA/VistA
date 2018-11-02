{*********************************************************}
{*                    OVCAE.PAS 4.06                     *}
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

unit ovcae;
  {-Array editors using simple, picture and numeric edit fields}

interface

uses
  Types, Windows, Classes, Controls, Forms, Graphics, Menus, Messages, SysUtils,
  OvcNf, OvcPf, OvcSf, OvcColor, OvcBase, OvcCmd, OvcConst, OvcData, OvcEf, OvcStr;

type
  {event to get a pointer to the cell's value}
  TGetItemEvent =
    procedure(Sender : TObject; Index : Integer; var Value : Pointer)
    of object;
  {event to get color of the item cell}
  TGetItemColorEvent =
    procedure(Sender : TObject; Index : Integer; var FG, BG : TColor)
    of object;
  {event to notify of a scroll action}
  TSelectEvent =
    procedure(Sender : TObject; NewIndex : Integer)
    of object;

type
  {base class for array editors}
  TOvcBaseArrayEditor = class(TOvcCustomControlEx)

  protected {private}
    {property variables}
    FActiveIndex       : Integer;       {the focused cell}
    FBorderStyle       : TBorderStyle;  {border around the control}
    FDisabledColors    : TOvcColors;    {colors for disabled fields}
    FHighlightColors   : TOvcColors;    {highlight colors}
    FLineColor         : TColor;        {color of row divider lines}
    FNumItems          : Integer;       {total elements in array}
    FOptions           : TOvcEntryFieldOptions;
    FPadChar           : Char;      {character used to pad end of string}
    FRowHeight         : Integer;       {pixel height of one row}
    FTextMargin        : Integer;       {indent from left (right)}
    FUseScrollBar      : Boolean;       {true to use virtical scroll bar}

    {event variables}
    FOnChange          : TNotifyEvent;  {change notification}
    FOnError           : TValidationErrorEvent;
    FOnGetItem         : TGetItemEvent; {method to call to get item pointer}
    FOnGetItemColor    : TGetItemColorEvent;
    FOnSelect          : TSelectEvent;  {scroll notification}
    FOnUserCommand     : TUserCommandEvent;
    FOnUserValidation  : TUserValidationEvent;

    {internal/working variables}
    aeCell             : TOvcBaseEntryField;{abstract edit cell object}
    aeDivisor          : Integer;       {divisor for scroll bar}
    aeHighIndex        : Integer;       {highest index value}
    aeItemPtr          : Pointer;       {pointer to data element}
    aeNumRows          : Integer;       {visible rows in window}
    aeRangeLo          : TRangeType;    {low field range limit}
    aeRangeHi          : TRangeType;    {high field range limit}
    aeRangeLoaded      : Boolean;       {flag to tell when loaded}
    aeTopIndex         : Integer;       {index of the top item}
    aeVSHigh           : Integer;       {vertical scroll limit}

    {variables to transfer to the edit cell field}
    aeDecimalPlaces    : Byte;          {max decimal places}
    aeMaxLength        : Word;          {maximum length of string}

    {property methods}
    function GetRangeHi : string;
    function GetRangeLo : string;
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetLineColor(Value : TColor);
    procedure SetNumItems(Value : Integer);
    procedure SetOptions(Value : TOvcEntryFieldOptions);
    procedure SetPadChar(Value : Char);
    procedure SetRangeHi(const Value : string);
    procedure SetRangeLo(const Value : string);
    procedure SetRowHeight(Value : Integer);
    procedure SetTextMargin(Value : Integer);
    procedure SetUseScrollBar(Value : Boolean);

    {general (internal) routines}
    procedure aeAdjustIntegralHeight;
      {-resizes the component so no partial items appear}
    procedure aeColorChanged(AColor : TObject);
      {-highlight color change-repaint}
    function aeMakeItemVisible(Index : Integer) : Boolean;
      {-displays the Index item, scrolling as required}
    procedure aePreFocusProcess;
      {-get ready to receive focus}
    procedure aeReadRangeHi(Stream : TStream);
      {-called to read the high range from the stream}
    procedure aeReadRangeLo(Stream : TStream);
      {-called to read the low range from the stream}
    function aeScaleDown(N : Integer) : SmallInt;
      {-returns a scaled down scroll bar value}
    function aeScaleUp(N : SmallInt) : Integer;
      {-returns a scaled up scroll bar value}
    procedure aeSetVScrollPos;
      {-sets the vertical scroll bar position}
    procedure aeSetVScrollRange;
      {-sets the horizontal scroll bar position}
    procedure aeUpdateDisplay(Scrolled : Boolean; OldItem, NewItem : Integer);
      {-invalidate or scroll necessary region}
    procedure aeWriteRangeHi(Stream : TStream);
      {-called to store the high range on the stream}
    procedure aeWriteRangeLo(Stream : TStream);
      {-called to store the low range on the stream}

    {VCL control messages}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMEnabledChanged(var Msg : TMessage);
      message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;
    procedure CMGotFocus(var Msg : TMessage);
      message CM_GOTFOCUS;
    procedure CMLostFocus(var Msg : TMessage);
      message CM_LOSTFOCUS;

    {windows message methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;
    procedure WMMouseActivate(var Msg : TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;
    procedure WMSize(var Msg : TWMSize);
      message WM_SIZE;
    procedure WMVScroll(var Msg : TWMScroll);
      message WM_VSCROLL;

  protected
    procedure ChangeScale(M, D : Integer);
      override;
    procedure CreateParams(var Params: TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DefineProperties(Filer : TFiler);
      override;
    procedure Paint;
      override;

    {abstract internal methods}
    procedure aeCreateEditCell;
      dynamic; abstract;
      {-create the edit celll}
    function aeGetEditString : PChar;
      dynamic; abstract;
      {-return the edit cells edit string}
    procedure aeGetSampleDisplayData(P : PChar);
      dynamic; abstract;
      {-cause edit cell to display sample data}

    {event wraper methods}
    procedure DoGetCellValue(Index : Integer);
      virtual; abstract;
      {-get the value for the "Index" cell}
    procedure DoGetItemColor(Index : Integer; var FG, BG : TColor);
      virtual;
      {-get the color values for the "Index" cell}
    function DoPutCellValue : Integer;
      dynamic; abstract;
      {-store the current value of the edit cell. Result is error code}
    procedure DoOnSelect(NewIndex : Integer);
      dynamic;
      {-perform scroll action notification}

    {abstract property method}
    procedure SetActiveIndex(Value : Integer);
      virtual; abstract;
      {-set the active array item}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor  Destroy;
      override;
    procedure SetFocus;
      override;

    function WriteCellValue : Integer;
      {-write the current cell value. return 0 or error code}

    property ItemIndex : Integer
      read FActiveIndex write SetActiveIndex stored False;

  published
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle;
    property DisabledColors : TOvcColors
      read FDisabledColors write FDisabledColors;
    property HighlightColors : TOvcColors
      read FHighlightColors write FHighlightColors;
    property LineColor : TColor
      read FLineColor write SetLineColor;
    property Options : TOvcEntryFieldOptions
      read FOptions write SetOptions;

    {placed here so RowHeight is set prior to NumItems}
    property RowHeight : Integer
      read FRowHeight write SetRowHeight;
    property NumItems : Integer
      read FNumItems write SetNumItems;
    property PadChar : Char
      read FPadChar write SetPadChar;
    property RangeHi : string
      read GetRangeHi write SetRangeHi stored False;
    property RangeLo : string
      read GetRangeLo write SetRangeLo stored False;
    property TextMargin : Integer
      read FTextMargin write SetTextMargin;
    property UseScrollBar : Boolean
       read FUseScrollBar write SetUseScrollBar;

    {events}
    property OnGetItem : TGetItemEvent
      read FOnGetItem write FOnGetItem;
    property OnGetItemColor : TGetItemColorEvent
      read FOnGetItemColor write FOnGetItemColor;
    {events echoed to the edit field object}
    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;
    property OnError : TValidationErrorEvent
      read FOnError write FOnError;
    property OnSelect : TSelectEvent
      read FOnSelect write FOnSelect;
    property OnUserCommand : TUserCommandEvent
      read FOnUserCommand write FOnUserCommand;
    property OnUserValidation : TUserValidationEvent
      read FOnUserValidation write FOnUserValidation;

    {inherited properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property Align;
    property Color;
    property Ctl3D;
    property Controller;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Width;

    {inherited events}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

type
  TSimpleCellField = class;
  TOvcSimpleArrayEditor = class(TOvcBaseArrayEditor)

  protected {private}
    {variables to transfer to the edit cell field}
    aeDataType    : TSimpleDataType;
    aePictureMask : Char;

    {property methods}
    procedure SetArrayDataType(Value: TSimpleDataType);
      {-set the data type for this field}
    procedure SetDecimalPlaces(Value : Byte);
      {-set the number of decimal places for the edit field}
    procedure SetMaxLength(Value : Word);
      {-set the maximum length of the edit field}
    procedure SetPictureMask(Value : Char);
      {-set the picture mask}

  protected
    procedure aeCreateEditCell;
      override;
      {-create the edit celll}
    function aeGetEditString : PChar;
      override;
      {-return the edit cells edit string}
    procedure aeGetSampleDisplayData(P : PChar);
      override;
      {-obtain sample data for the edit cell to display}

    {event wrapper methods}
    procedure DoGetCellValue(Index : Integer);
      override;
      {-get the value for the cell with "Index"}
    function DoPutCellValue : Integer;
      override;
      {-store the current value of the edit cell. Result is error code}

    {virtual property method}
    procedure SetActiveIndex(Value : Integer);
      override;
      {-set the active array item}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

  published
    {properties for the edit cell field}
    property DataType : TSimpleDataType
      read aeDataType write SetArrayDataType;
    property DecimalPlaces : Byte
      read aeDecimalPlaces write SetDecimalPlaces;
    property MaxLength : Word
      read aeMaxLength write SetMaxLength;
    property PictureMask : Char
      read aePictureMask write SetPictureMask;
  end;


  TSimpleCellField = class(TOvcSimpleField)
  protected {private}
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    procedure CreateWnd;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
  end;

type
  TPictureCellField = class;
  TOvcPictureArrayEditor = class(TOvcBaseArrayEditor)

  protected {private}
    {variables to transfer to the edit cell field}
    aeDataType    : TPictureDataType;
    aeEpoch       : Integer;
    aePictureMask : string;

    {property methods}
    procedure SetArrayDataType(Value: TPictureDataType);
      {-set the data type for this field}
    procedure SetDecimalPlaces(Value : Byte);
      {-set the number of decimal places for the edit field}
    procedure SetEpoch(Value : Integer);
      {-set the epoch value}
    procedure SetMaxLength(Value : Word);
      {-set the maximum length of the edit field}
    procedure SetPictureMask(const Value : string);
      {-set the picture mask}

  protected
    procedure aeCreateEditCell;
      override;
      {-create the edit celll}
    function aeGetEditString : PChar;
      override;
      {-return the edit cells edit string}
    procedure aeGetSampleDisplayData(P : PChar);
      override;
      {-obtain sample data for the edit cell to display}

    {event wrapper methods}
    procedure DoGetCellValue(Index : Integer);
      override;
      {-get the value for the cell with "Index"}
    function DoPutCellValue : Integer;
      override;
      {-store the current value of the edit cell. Result is error code}

    {virtual property method}
    procedure SetActiveIndex(Value : Integer);
      override;
      {-set the active array item}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

  published
    {properties for the edit cell field}
    property DataType : TPictureDataType
      read aeDataType write SetArrayDataType;
    property DecimalPlaces : Byte
      read aeDecimalPlaces write SetDecimalPlaces;
    property Epoch : Integer
      read aeEpoch write SetEpoch;
    property MaxLength : Word
      read aeMaxLength write SetMaxLength;
    property PictureMask : string
      read aePictureMask write SetPictureMask;
  end;


  TPictureCellField = class(TOvcPictureField)
  protected {private}
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    procedure CreateWnd;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
  end;

type
  TNumericCellField = class;
  TOvcNumericArrayEditor = class(TOvcBaseArrayEditor)

  protected {private}
    {variables to transfer to the edit cell field}
    aeDataType    : TNumericDataType;
    aePictureMask : string;

    {property methods}
    procedure SetArrayDataType(Value: TNumericDataType);
      {-set the data type for this field}
    procedure SetPictureMask(const Value : string);
      {-set the picture mask}

  protected
    procedure aeCreateEditCell;
      override;
      {-create the edit celll}
    function aeGetEditString : PChar;
      override;
      {-return the edit cells edit string}
    procedure aeGetSampleDisplayData(P : PChar);
      override;
      {-obtain sample data for the edit cell to display}

    {event wrapper methods}
    procedure DoGetCellValue(Index : Integer);
      override;
      {-get the value for the cell with "Index"}
    function DoPutCellValue : Integer;
      override;
      {-store the current value of the edit cell. Result is error code}

    {virtual property method}
    procedure SetActiveIndex(Value : Integer);
      override;
      {-set the active array item}

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

  published
    {properties for the edit cell field}
    property DataType : TNumericDataType
      read aeDataType write SetArrayDataType;
    property PictureMask : string
      read aePictureMask write SetPictureMask;
  end;


  TNumericCellField = class(TOvcNumericField)
  protected {private}
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg : TWMSetFocus);
      message WM_SETFOCUS;

  protected
    procedure CreateWnd;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;
  end;


implementation



type
  {local class to allow access to protected entry field data/methods}
  TLocalEF = class(TOvcBaseEntryField);


{*** TOvcBaseArrayEditor ***}

procedure TOvcBaseArrayEditor.aeAdjustIntegralHeight;
  {-resizes the component so no partial items appear}
begin
  if not HandleAllocated then
    Exit;

  if csLoading in ComponentState then
    Exit;

  if ClientHeight <> aeNumRows*FRowHeight then
    ClientHeight := aeNumRows*FRowHeight;
end;

procedure TOvcBaseArrayEditor.aeColorChanged(AColor : TObject);
  {-highlight color change-repaint}
begin
  Repaint;
end;

function TOvcBaseArrayEditor.aeMakeItemVisible(Index : Integer) : Boolean;
begin
  Result := False;

  if Index < 0 then
    Index := 0;
  if Index > aeHighIndex then
    Index := aeHighIndex;

  if Index < aeTopIndex then begin
    aeTopIndex := Index;
    Result := True;
  end else if Index > aeTopIndex+Pred(aeNumRows) then begin
    aeTopIndex := Index-Pred(aeNumRows);
    Result := True;
  end;

  {move the cell control to the new Position}
  aeCell.SetSelection(0, 0);
  aeCell.Top := (Index-aeTopIndex)*FRowHeight;
  aeCell.SetSelection(0, 255);
end;

procedure TOvcBaseArrayEditor.aePreFocusProcess;
  {-get ready to receive focus}
var
  FGColor : TColor;
  BGColor : TColor;
begin
  DoGetCellValue(FActiveIndex);

  {get color for the active cell}
  FGColor := Font.Color;
  BGColor := Color;
  DoGetItemColor(FActiveIndex, FGColor, BGColor);
  aeCell.Font.Color := FGColor;
  aeCell.Color := BGColor;
  aeCell.EFColors.Highlight.TextColor := FHighlightColors.TextColor;
  aeCell.EFColors.Highlight.BackColor := FHighlightColors.BackColor;
end;

procedure TOvcBaseArrayEditor.aeReadRangeHi(Stream : TStream);
  {-called to read the high range from the stream}
begin
  Stream.Read(aeRangeHi, SizeOf(TRangeType));
  aeRangeLoaded := True;
end;

procedure TOvcBaseArrayEditor.aeReadRangeLo(Stream : TStream);
  {-called to read the low range from the stream}
begin
  Stream.Read(aeRangeLo, SizeOf(TRangeType));
  aeRangeLoaded := True;
end;

function TOvcBaseArrayEditor.aeScaleDown(N : Integer) : SmallInt;
  {-returns a scaled down scroll bar value}
begin
  Result := N div aeDivisor;
end;

function TOvcBaseArrayEditor.aeScaleUp(N : SmallInt) : Integer;
  {-returns a scaled up scroll bar value}
begin
  if N = aeVSHigh then
    Result := aeHighIndex
  else
    Result := N * aeDivisor;
end;

procedure TOvcBaseArrayEditor.aeSetVScrollPos;
  {-sets the virtical scroll bar position}
begin
  if FUseScrollBar then
    SetScrollPos(Handle, SB_VERT, aeScaleDown(FActiveIndex), True);
end;

procedure TOvcBaseArrayEditor.aeSetVScrollRange;
  {-sets the horizontal scroll bar position}
begin
  if not FUseScrollBar then
    Exit;

  aeDivisor := 1;
  if aeHighIndex < aeNumRows then
    aeVSHigh := 1
  else if aeHighIndex <= High(SmallInt) then
    aeVSHigh := aeHighIndex
  else begin
    aeDivisor := 2*(aeHighIndex div 32768);
    aeVSHigh := aeHighIndex div aeDivisor;
  end;
  if (FNumItems > aeNumRows) or (csDesigning in ComponentState) then
    SetScrollRange(Handle, SB_VERT, 0, aeVSHigh, False)
  else
    SetScrollRange(Handle, SB_VERT, 0, 0, False);
end;

procedure TOvcBaseArrayEditor.aeUpdateDisplay(Scrolled : Boolean;
          OldItem, NewItem : Integer);
  {-invalidate or scroll necessary region}
var
  ClipArea : TRect;
  D, Y     : Integer;
begin
  if Scrolled then begin
    D := OldItem - NewItem;
    if Abs(D) <= aeNumRows then begin
      ClipArea := ClientRect;

      {omit area for new cell}
      if NewItem > OldItem then
        Dec(ClipArea.Bottom, FRowHeight)
      else
        Inc(ClipArea.Top, FRowHeight);

      {calc amount to scroll}
      Y := (D) * FRowHeight;

      {scroll the window setting up a clipping region}
      ScrollWindow(Handle, 0, LOWORD(Y), @ClipArea, @ClipArea);
      Update;
    end else  {more than one page}
      Invalidate;
  end else begin
    Y := (OldItem-aeTopIndex)*FRowHeight;
    ClipArea := Rect(0, Y, ClientWidth, Y+aeCell.Height);
    InvalidateRect(Handle, @ClipArea, False);
  end;
end;

procedure TOvcBaseArrayEditor.aeWriteRangeHi(Stream : TStream);
  {-called to store the high range on the stream}
begin
  Stream.Write(aeRangeHi, SizeOf(TRangeType));
end;

procedure TOvcBaseArrayEditor.aeWriteRangeLo(Stream : TStream);
  {-called to store the low range on the stream}
begin
  Stream.Write(aeRangeLo, SizeOf(TRangeType));
end;

procedure TOvcBaseArrayEditor.ChangeScale(M, D : Integer);
begin
  inherited ChangeScale(M, D);

  if M <> D then
    {scale row height}
    RowHeight := MulDiv(FRowHeight, M, D);
end;

procedure TOvcBaseArrayEditor.CMCtl3DChanged(var Msg : TMessage);
begin
  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

    if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  inherited;
end;

procedure TOvcBaseArrayEditor.CMEnabledChanged(var Msg : TMessage);
begin
  inherited;

  if Assigned(aeCell) then
    aeCell.Enabled := Self.Enabled;
end;

procedure TOvcBaseArrayEditor.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  {adjust integral height}
  aeAdjustIntegralHeight;
end;

procedure TOvcBaseArrayEditor.CMGotFocus(var Msg : TMessage);
begin
  {do nothing -- cell edit field will respond}
end;

procedure TOvcBaseArrayEditor.CMLostFocus(var Msg : TMessage);
begin
  {do nothing -- cell edit field will respond}
end;

constructor TOvcBaseArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if NewStyleControls then
    ControlStyle := ControlStyle + [csClickEvents]
  else
    ControlStyle := ControlStyle + [csClickEvents, csFramed];

  {set default values for inherited persistent properties}
  Align           := alNone;
  Color           := clWindow;
  Ctl3D           := True;
  Height          := 150;
  ParentColor     := False;
  ParentCtl3D     := True;
  ParentFont      := True;
  TabStop         := True;
  Width           := 100;

  {set default values for persistent properties}
  if csDesigning in ComponentState then
    FActiveIndex := -1
  else
    FActiveIndex := 0;
  FOptions           := efDefOptions;
  FBorderStyle       := bsSingle;
  FLineColor         := clSilver;
  FNumItems          := 0;
  FPadChar           := DefPadChar;
  FRowHeight         := 17;
  FTextMargin        := 2;
  FUseScrollBar      := True;

  {set defaults for working variables}
  aeDecimalPlaces    := 0;
  aeDivisor          := 1;
  aeHighIndex        := Pred(FNumItems);
  aeMaxLength        := 10;
  aeNumRows          := 0;
  aeRangeLoaded      := False;
  aeTopIndex         := 0;
  aeVSHigh           := 0;

  {create colors object}
  FDisabledColors := TOvcColors.Create(clGrayText, clWindow);
  FDisabledColors.OnColorChange := aeColorChanged;
  FHighlightColors := TOvcColors.Create(clHighlightText, clHighlight);
  FHighlightColors.OnColorChange := aeColorChanged;
end;

procedure TOvcBaseArrayEditor.CreateParams(var Params: TCreateParams);
const
  ScrollBar : array[Boolean] of Integer = (0, WS_VSCROLL);
begin
  inherited CreateParams(Params);

  with Params do
    Style := Integer(Style) or
      ScrollBar[FUseScrollBar] or BorderStyles[FBorderStyle];

  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcBaseArrayEditor.CreateWnd;
begin
  inherited CreateWnd;

  {create the edit cell control}
  aeCreateEditCell;

  if PopupMenu <> nil then
    TLocalEF(aeCell).PopupMenu := PopupMenu;

  {set properties for the edit cell to match our settings}
  aeCell.Options                   := FOptions;
  aeCell.PadChar                   := FPadChar;
  aeCell.TextMargin                := FTextMargin;
  aeCell.TabStop                   := Self.TabStop;
  aeCell.Enabled                   := Self.Enabled;
  aeCell.EFColors.Highlight.BackColor := FHighlightColors.BackColor;
  aeCell.EFColors.Highlight.TextColor := FHighlightColors.TextColor;
  aeCell.EFColors.Disabled.TextColor  := FDisabledColors.TextColor;
  aeCell.EFColors.Disabled.BackColor  := FDisabledColors.BackColor;

  aeCell.SetBounds(0, 0, ClientWidth, FRowHeight-1);
  aeCell.Name := 'EditCell';
  if not aeRangeLoaded then begin
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end else begin
    TLocalEF(aeCell).efRangeHi := aeRangeHi;
    TLocalEF(aeCell).efRangeLo := aeRangeLo;
  end;
  aeCell.Parent := Self;

  {set the scroll bar range}
  aeSetVScrollRange;

  {force current item to be visible}
  aeMakeItemVisible(FActiveIndex);
end;

procedure TOvcBaseArrayEditor.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('RangeHigh', aeReadRangeHi, aeWriteRangeHi, True);
  Filer.DefineBinaryProperty('RangeLow', aeReadRangeLo, aeWriteRangeLo, True);
end;

destructor TOvcBaseArrayEditor.Destroy;
begin
  {dispose of the color objects}
  FDisabledColors.Free;
  FHighlightColors.Free;

  inherited Destroy;
end;

procedure TOvcBaseArrayEditor.DoGetItemColor(Index : Integer; var FG, BG : TColor);
begin
  if Assigned(FOnGetItemColor) then
    FOnGetItemColor(Self, Index, FG, BG);
end;

procedure TOvcBaseArrayEditor.DoOnSelect(NewIndex : Integer);
  {-perform scroll action notification}
begin
  {if another array editor is connected, pass msg to it}
  if not (csDesigning in ComponentState) and Assigned(FOnSelect) then
    FOnSelect(Self, NewIndex);
end;

function TOvcBaseArrayEditor.GetRangeHi : string;
  {-get the high field range string value}
begin
  Result := TLocalEF(aeCell).efRangeToStRange(aeRangeHi);
end;

function TOvcBaseArrayEditor.GetRangeLo : string;
  {-get the low field range string value}
begin
  Result := TLocalEF(aeCell).efRangeToStRange(aeRangeLo);
end;

procedure TOvcBaseArrayEditor.Paint;
var
  CR          : TRect;
  IR, Clip    : TRect;
  I           : Integer;
  X, Y        : Integer;
  T           : array[0..MaxEditLen] of Char;
  P           : PChar;
  FGColor     : TColor;
  BGColor     : TColor;
  SaveFGColor : TColor;
begin
  {get the client area}
  CR := ClientRect;

  {get the cliping region}
  if csDesigning in ComponentState then
    Clip := CR
  else
    GetClipBox(Canvas.Handle, Clip);

  {set up the proper font and colors}
  Canvas.Font := Font;
  SaveFGColor := Font.Color;

  {starting offset for text}
  X := aeCell.TextMargin-1;

  for I := aeTopIndex to aeTopIndex + Pred(aeNumRows) do begin
    if I <> FActiveIndex then begin
      CR.Top := (I-aeTopIndex)*FRowHeight;
      CR.Bottom := CR.Top+FRowHeight-1;
      if I = aeTopIndex + Pred(aeNumRows) then
        CR.Bottom := ClientHeight;
      Y := CR.Top + TLocalEF(aeCell).efTopMargin;

      if Bool(IntersectRect(IR, CR, Clip)) then begin
        DoGetCellValue(I);

        if Enabled then begin
          FGColor := SaveFGColor;
          BGColor := Color;
        end else begin
          FGColor := FDisabledColors.TextColor;
          BGColor := FDisabledColors.BackColor;
        end;

        DoGetItemColor(I, FGColor, BGColor);

        Canvas.Font.Color := FGColor;
        Canvas.Brush.Color := BGColor;
        Canvas.FillRect(CR);

        if csDesigning in ComponentState then begin
          aeGetSampleDisplayData(T);
          if (aeCell is TOvcNumericField) or (efoRightAlign in FOptions) then begin
            TrimAllSpacesPChar(T);

            {set right alignment}
            SetTextAlign(Canvas.Handle, TA_RIGHT);

            {paint the text right aligned}
            ExtTextOut(Canvas.Handle, CR.Right-FTextMargin-1, Y,
              {ETO_OPAQUE+}ETO_CLIPPED, @CR, T, StrLen(T), nil);
          end else
            ExtTextOut(Canvas.Handle, X, Y, ETO_CLIPPED, @CR, T, StrLen(T), nil);
        end else begin
          P := aeGetEditString;
          if (aeCell is TOvcNumericField) or (efoRightAlign in FOptions) then begin
            StrCopy(T, P);
            TrimAllSpacesPChar(T);

            {set right alignment}
            SetTextAlign(Canvas.Handle, TA_RIGHT);

            {paint the text right aligned}
            ExtTextOut(Canvas.Handle, CR.Right-FTextMargin-1, Y,
              ETO_CLIPPED, @CR, T, StrLen(T), nil);
          end else
            ExtTextOut(Canvas.Handle, X, Y, ETO_CLIPPED,
              @CR, P, StrLen(P), nil);
        end;
      end;
    end;
  end;

  {restore the active item value}
  DoGetCellValue(FActiveIndex);

  if Enabled then begin
    FGColor := SaveFGColor;
    BGColor := Color;
  end else begin
    FGColor := FDisabledColors.TextColor;
    BGColor := FDisabledColors.BackColor;
  end;

  DoGetItemColor(FActiveIndex, FGColor, BGColor);
  aeCell.Font.Color := FGColor;
  aeCell.Color := BGColor;

  if not Enabled then begin
    aeCell.EFColors.Disabled.TextColor := FGColor;
    aeCell.EFColors.Disabled.BackColor := BGColor;
  end;

  {paint the active cell with the proper colors}
  aeCell.Repaint;

  {draw cell divider lines}
  Y := -1;
  Canvas.Pen.Color := FLineColor;
  for I := 0 to Pred(aeNumRows)-1 do begin
    Inc(Y, FRowHeight);
    Canvas.PolyLine([Point(0, Y), Point(ClientWidth, Y)]);
  end;
end;

procedure TOvcBaseArrayEditor.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseArrayEditor.SetFocus;
begin
  if Assigned(aeCell) {and not aeCell.Focused} then
    inherited SetFocus;
end;

procedure TOvcBaseArrayEditor.SetLineColor(Value : TColor);
begin
  if Value <> FLineColor then begin
    FLineColor := Value;
    Refresh;
  end;
end;

procedure TOvcBaseArrayEditor.SetNumItems(Value : Integer);
begin
  if csLoading in ComponentState then
    aeNumRows := Height div FRowHeight;

  if Value >= aeNumRows then
    FNumItems := Value
  else
    FNumItems := aeNumRows;
  aeHighIndex := Pred(FNumItems);

  {reset the scroll bar}
  if HandleAllocated then begin
    aeSetVScrollRange;
    aeSetVScrollPos;
  end;
end;

procedure TOvcBaseArrayEditor.SetOptions(Value : TOvcEntryFieldOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;
    if (efoForceInsert in FOptions) then
      Exclude(FOptions, efoForceOvertype);
    if (efoForceOvertype in FOptions) then
      Exclude(FOptions, efoForceInsert);

    if Assigned(aeCell) then begin
      aeCell.Options := FOptions;
      FOptions := aeCell.Options;
    end;
  end;
end;

procedure TOvcBaseArrayEditor.SetPadChar(Value : Char);
begin
  if Value <> FPadChar then begin
    FPadChar := Value;
    if csDesigning in ComponentState then
      Exit;

    if Assigned(aeCell) then begin
      aeCell.PadChar := FPadChar;
      FPadChar := aeCell.PadChar;
    end;
  end;
end;

procedure TOvcBaseArrayEditor.SetRangeHi(const Value : string);
  {-set the high field range from a string value}
begin
  aeCell.RangeHi := Value;

  {reassign to get the range from the edit field}
  aeRangeHi := TLocalEF(aeCell).efRangeHi;
end;

procedure TOvcBaseArrayEditor.SetRangeLo(const Value : string);
  {-set the low field range from a string value}
begin
  aeCell.RangeLo := Value;
  {reassign to get the range from the edit field}
  aeRangeLo := TLocalEF(aeCell).efRangeLo;
end;

procedure TOvcBaseArrayEditor.SetRowHeight(Value : Integer);
  {-set the cell row height}
begin
  if (Value <> FRowHeight) and (Value > 0) then begin
    FRowHeight := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseArrayEditor.SetTextMargin(Value : Integer);
  {-set the text margin}
begin
  if (Value <> FTextMargin) and (Value >= 2) then begin
    FTextMargin := Value;
    if Assigned(aeCell) then begin
      aeCell.TextMargin := FTextMargin;
      FTextMargin := aeCell.TextMargin;
    end;
    Refresh;
  end;
end;

procedure TOvcBaseArrayEditor.SetUseScrollBar(Value : Boolean);
  {-set use of vertical scroll bar}
begin
  if Value <> FUseScrollBar then begin
    FUseScrollBar := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseArrayEditor.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1;  {don't erase background}
end;

procedure TOvcBaseArrayEditor.WMLButtonDown(var Msg : TWMLButtonDown);
var
  Pt : TPoint;
begin
  inherited;
  if (FNumItems > 0) then begin
    GetCursorPos(Pt);
    Pt := ScreenToClient(Pt);
    SetActiveIndex(aeTopIndex+(Pt.Y div FRowHeight));
    {give the edit control the focus}
    aeCell.SetFocus;
  end;
end;

procedure TOvcBaseArrayEditor.WMMouseActivate(var Msg : TWMMouseActivate);
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;
end;

procedure TOvcBaseArrayEditor.WMSetFocus(var Msg : TWMSetFocus);
begin
  inherited;
  {if the focus isn't comming from our child edit cell}
  if Msg.FocusedWnd <> aeCell.Handle then begin
    aePreFocusProcess;

    {give the edit control the focus}
    aeCell.SetFocus;
  end else
    {give the focus to the previous control}

      SendMessage(TForm(GetParentForm(Self)).Handle, WM_NEXTDLGCTL, 1, 0);
end;

procedure TOvcBaseArrayEditor.WMSize(var Msg : TWMSize);
begin
  inherited;
  aeNumRows := ClientHeight div FRowHeight;

  {force num items at least as large as the number of rows}
  if FNumItems < aeNumRows then
    FNumItems := aeNumRows;

  {adjust size of edit field}
  if Assigned(aeCell) then
    aeCell.Width := ClientWidth;

  aeAdjustIntegralHeight;
end;

procedure TOvcBaseArrayEditor.WMVScroll(var Msg : TWMVScroll);
begin
  case Msg.ScrollCode of
    SB_LINEDOWN : SetActiveIndex(FActiveIndex+1);
    SB_LINEUP   : SetActiveIndex(FActiveIndex-1);
    SB_PAGEDOWN : SetActiveIndex(FActiveIndex+Pred(aeNumRows));
    SB_PAGEUP   : SetActiveIndex(FActiveIndex-Pred(aeNumRows));
    SB_THUMBPOSITION,
    SB_THUMBTRACK :
      SetActiveIndex(aeScaleUp(Msg.Pos));
  end;
end;

function TOvcBaseArrayEditor.WriteCellValue : Integer;
  {-write the current cell value. return 0 or error code}
begin
  Result := DoPutCellValue;
end;


{*** TOvcSimpleArrayEditor ***}

procedure TOvcSimpleArrayEditor.aeCreateEditCell;
  {-create the edit celll}
begin
  aeCell.Free;
  aeCell := TSimpleCellField.Create(Self);
  AeCell.Controller := Controller;

  TSimpleCellField(aeCell).DataType := aeDataType;
  TSimpleCellField(aeCell).DecimalPlaces := aeDecimalPlaces;
  TSimpleCellField(aeCell).PictureMask := aePictureMask;
  TSimpleCellField(aeCell).MaxLength := aeMaxLength;
end;

function TOvcSimpleArrayEditor.aeGetEditString : PChar;
  {-return the edit cells edit string}
begin
  Result := TSimpleCellField(aeCell).efEditSt;
end;

procedure TOvcSimpleArrayEditor.aeGetSampleDisplayData(P : PChar);
  {-cause edit cell to display sample data}
begin
  TSimpleCellField(aeCell).efGetSampleDisplayData(P);
end;

constructor TOvcSimpleArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set defaults}
  aeDataType    := sftString;
  aePictureMask := pmAnyChar;
end;

destructor TOvcSimpleArrayEditor.Destroy;
begin
  aeCell.Free;
  inherited Destroy;
end;

procedure TOvcSimpleArrayEditor.DoGetCellValue(Index : Integer);
  {-get value for this array index and assign to the edit field}
begin
  aeItemPtr := nil;
  if Assigned(FOnGetItem) and not (csDesigning in ComponentState) then
    FOnGetItem(Self, Index, aeItemPtr);

  if aeItemPtr = nil then
    TSimpleCellField(aeCell).efSetInitialValue
  else begin
    TSimpleCellField(aeCell).SetValue(aeItemPtr^);
    TSimpleCellField(aeCell).efSaveEditString;
  end;
end;

function TOvcSimpleArrayEditor.DoPutCellValue : Integer;
  {-assign the value of the edit field to the associated variable}
begin
  Result := 0;
  if (aeItemPtr <> nil) then
    Result := TSimpleCellField(aeCell).GetValue(aeItemPtr^);
end;

procedure TOvcSimpleArrayEditor.SetActiveIndex(Value : Integer);
  {-set the currently selected item}
var
  OldItem  : Integer;
  Scrolled : Boolean;
  Err      : Integer;
begin
  if csDesigning in ComponentState then
    Exit;

  {verify valid index}
  if Value < 0 then
    Value := 0
  else if Value > aeHighIndex then
    Value := aeHighIndex;

  if (Value <> FActiveIndex) then begin
    if TSimpleCellField(aeCell).Modified then begin
      {put value of cell field into user var}
      Err := DoPutCellValue;
      if Err <> 0 then begin
        PostMessage(aeCell.Handle, om_ReportError, Err, 0);
        Exit;
      end;
    end;

    TSimpleCellField(aeCell).efCaret.Visible := False;
    TSimpleCellField(aeCell).SetSelection(0, 0);
    TSimpleCellField(aeCell).Update;

    OldItem := FActiveIndex;

    {disable cell painting}
    SendMessage(aeCell.Handle, WM_SETREDRAW, 0, 0);
    try
      FActiveIndex := Value;
      Scrolled := aeMakeItemVisible(Value);

      TSimpleCellField(aeCell).efCaret.Visible := True;
      TSimpleCellField(aeCell).SetSelection(0, 255);

      {get the new pointer and value}
      DoGetCellValue(FActiveIndex);

      {reset horizontal offset}
      TSimpleCellField(aeCell).efHOffset := 0;
    finally
      {allow cell painting}
      SendMessage(aeCell.Handle, WM_SETREDRAW, 1, 0);
    end;

    aeSetVScrollPos;
    aeUpdateDisplay(Scrolled, OldItem, Value);
    DoOnSelect(FActiveIndex);
  end;
end;

procedure TOvcSimpleArrayEditor.SetArrayDataType(Value: TSimpleDataType);
  {-set the data type for this field}
begin
  aeDataType := Value;
  if Assigned(aeCell) then begin
    TSimpleCellField(aeCell).DataType := aeDataType;

    {reset our copies of the edit field properties}
    aeDataType := TSimpleCellField(aeCell).DataType;
    aeMaxLength := TSimpleCellField(aeCell).MaxLength;
    aeDecimalPlaces := TSimpleCellField(aeCell).DecimalPlaces;
    aePictureMask := TSimpleCellField(aeCell).PictureMask;
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end;
  Refresh;
end;

procedure TOvcSimpleArrayEditor.SetDecimalPlaces(Value : Byte);
  {-set the number of decimal places for the edit field}
begin
  if aeDecimalPlaces <> Value then begin
    aeDecimalPlaces := Value;
    if Assigned(aeCell) then begin
      TSimpleCellField(aeCell).DecimalPlaces := aeDecimalPlaces;

      {reset our copy of the edit field property}
      aeDecimalPlaces := TSimpleCellField(aeCell).DecimalPlaces;
    end;
    Refresh;
  end;
end;

procedure TOvcSimpleArrayEditor.SetMaxLength(Value : Word);
  {-set the maximum length of the edit field}
begin
  if aeMaxLength <> Value then begin
    aeMaxLength := Value;
    if Assigned(aeCell) then begin
      TSimpleCellField(aeCell).MaxLength := aeMaxLength;

      {reset our copy of the edit field property}
      aeMaxLength := TSimpleCellField(aeCell).MaxLength;
    end;
    Refresh;
  end;
end;

procedure TOvcSimpleArrayEditor.SetPictureMask(Value: Char);
  {-set the picture mask}
begin
  if aePictureMask <> Value then begin
    aePictureMask := Value;
    if Assigned(aeCell) then begin
      TSimpleCellField(aeCell).PictureMask := aePictureMask;

      {reset our copy of the edit field property}
      aePictureMask := TSimpleCellField(aeCell).PictureMask;
    end;
    Refresh;
  end;
end;

{*** TSimpleCellField ***}

constructor TSimpleCellField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assgin edit field properties}
  ParentFont  := True;
  ParentColor := True;
  Ctl3D       := False;
  ParentCtl3D := False;
  BorderStyle := bsNone; {TBorderStyle(0);}
  AutoSize    := False;
  Borders.LeftBorder.Enabled := False;
  Borders.RightBorder.Enabled := False;
  Borders.TopBorder.Enabled := False;
  Borders.BottomBorder.Enabled := False;
end;

procedure TSimpleCellField.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcSimpleArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnChange         := TOvcSimpleArrayEditor(Parent).OnChange;
  OnClick          := TOvcSimpleArrayEditor(Parent).OnClick;
  OnDblClick       := TOvcSimpleArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcSimpleArrayEditor(Parent).OnEnter;
  OnError          := TOvcSimpleArrayEditor(Parent).OnError;
  OnExit           := TOvcSimpleArrayEditor(Parent).OnExit;
  OnKeyDown        := TOvcSimpleArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcSimpleArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcSimpleArrayEditor(Parent).OnKeyUp;
  OnMouseDown      := TOvcSimpleArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcSimpleArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcSimpleArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcSimpleArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcSimpleArrayEditor(Parent).OnUserValidation;
end;

procedure TSimpleCellField.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  case Cmd of
    ccUp       :
      Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
    ccDown     :
      Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    ccFirstPage:
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
    ccLastPage :
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, High(SmallInt)), Parent.Handle);
    ccPrevPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
    ccNextPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
  else
    inherited;
  end;
end;

procedure TSimpleCellField.WMKillFocus(var Msg : TWMKillFocus);
begin
  {save the current cell value}
  TOvcBaseArrayEditor(Parent).DoPutCellValue;

  inherited;
end;

procedure TSimpleCellField.WMSetFocus(var Msg : TWMSetFocus);
begin
  TOvcBaseArrayEditor(Parent).aePreFocusProcess;
  inherited;
end;


{*** TOvcPictureArrayEditor ***}

procedure TOvcPictureArrayEditor.aeCreateEditCell;
  {-create the edit celll}
begin
  aeCell.Free;
  aeCell := TPictureCellField.Create(Self);
  AeCell.Controller := Controller;

  TPictureCellField(aeCell).DataType := aeDataType;
  TPictureCellField(aeCell).DecimalPlaces := aeDecimalPlaces;
  TPictureCellField(aeCell).Epoch := aeEpoch;
  TPictureCellField(aeCell).PictureMask := aePictureMask;
  TPictureCellField(aeCell).MaxLength := aeMaxLength;
end;

function TOvcPictureArrayEditor.aeGetEditString : PChar;
  {-return the edit cells edit string}
begin
  Result := TPictureCellField(aeCell).efEditSt;
end;

procedure TOvcPictureArrayEditor.aeGetSampleDisplayData(P : PChar);
  {-cause edit cell to display sample data}
begin
  TPictureCellField(aeCell).efGetSampleDisplayData(P);
end;

constructor TOvcPictureArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set defaults}
  aeDataType      := pftString;
  aePictureMask   := 'XXXXXXXXXXXXXXX';
end;

destructor TOvcPictureArrayEditor.Destroy;
begin
  aeCell.Free;
  inherited Destroy;
end;

procedure TOvcPictureArrayEditor.DoGetCellValue(Index : Integer);
  {-get value for this array index and assign to the edit field}
begin
  aeItemPtr := nil;
  if Assigned(FOnGetItem) and not (csDesigning in ComponentState) then
    FOnGetItem(Self, Index, aeItemPtr);

  if aeItemPtr = nil then
    TPictureCellField(aeCell).efSetInitialValue
  else begin
    TPictureCellField(aeCell).SetValue(aeItemPtr^);
    TPictureCellField(aeCell).efSaveEditString;
  end;
end;

function TOvcPictureArrayEditor.DoPutCellValue : Integer;
  {-assign the value of the edit field to the associated variable}
begin
  Result := 0;
  if (aeItemPtr <> nil) then
    Result := TPictureCellField(aeCell).GetValue(aeItemPtr^);
end;

procedure TOvcPictureArrayEditor.SetActiveIndex(Value : Integer);
  {-set the currently selected item}
var
  OldItem  : Integer;
  Scrolled : Boolean;
  Err      : Integer;
begin
  if csDesigning in ComponentState then
    Exit;

  {verify valid index}
  if Value < 0 then
    Value := 0
  else if Value > aeHighIndex then
    Value := aeHighIndex;

  if (Value <> FActiveIndex) then begin
    if TPictureCellField(aeCell).Modified then begin
      {put value of cell field into user var}
      Err := DoPutCellValue;
      if Err <> 0 then begin
        PostMessage(aeCell.Handle, om_ReportError, Err, 0);
        Exit;
      end;
    end;

    TPictureCellField(aeCell).efCaret.Visible := False;
    TPictureCellField(aeCell).SetSelection(0, 0);
    TPictureCellField(aeCell).Update;

    OldItem := FActiveIndex;

    {disable cell painting}
    SendMessage(aeCell.Handle, WM_SETREDRAW, 0, 0);
    try
      FActiveIndex := Value;
      Scrolled := aeMakeItemVisible(Value);

      TPictureCellField(aeCell).efCaret.Visible := True;
      TPictureCellField(aeCell).SetSelection(0, 255);

      {get the new pointer and value}
      DoGetCellValue(FActiveIndex);
      {reset horizontal offset}
      TPictureCellField(aeCell).efHOffset := 0;
    finally
      {allow cell painting}
      SendMessage(aeCell.Handle, WM_SETREDRAW, 1, 0);
    end;

    aeSetVScrollPos;
    aeUpdateDisplay(Scrolled, OldItem, Value);
    DoOnSelect(FActiveIndex);
  end;
end;

procedure TOvcPictureArrayEditor.SetArrayDataType(Value: TPictureDataType);
  {-set the data type for this field}
begin
  aeDataType := Value;
  if Assigned(aeCell) then begin
    TPictureCellField(aeCell).DataType := aeDataType;

    {reset our copies of the edit field properties}
    aeDataType := TPictureCellField(aeCell).DataType;
    aeMaxLength := TPictureCellField(aeCell).MaxLength;
    aeDecimalPlaces := TPictureCellField(aeCell).DecimalPlaces;
    aePictureMask := TPictureCellField(aeCell).PictureMask;
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end;
  Refresh;
end;

procedure TOvcPictureArrayEditor.SetDecimalPlaces(Value : Byte);
  {-set the number of decimal places for the edit field}
begin
  if aeDecimalPlaces <> Value then begin
    aeDecimalPlaces := Value;
    if Assigned(aeCell) then begin
      TPictureCellField(aeCell).DecimalPlaces := aeDecimalPlaces;

      {reset our copy of the edit field property}
      aeDecimalPlaces := TPictureCellField(aeCell).DecimalPlaces;
    end;
    Refresh;
  end;
end;

procedure TOvcPictureArrayEditor.SetEpoch(Value : Integer);
begin
  if Value <> aeEpoch then begin
    aeEpoch := Value;
    if Assigned(aeCell) then begin
      TPictureCellField(aeCell).Epoch := aeEpoch;

      {reset our copy of the edit field property}
      aeEpoch := TPictureCellField(aeCell).Epoch;
    end;
  end;
end;

procedure TOvcPictureArrayEditor.SetMaxLength(Value : Word);
  {-set the maximum length of the edit field}
begin
  if aeMaxLength <> Value then begin
    aeMaxLength := Value;
    if Assigned(aeCell) then begin
      TPictureCellField(aeCell).MaxLength := aeMaxLength;

      {reset our copy of the edit field property}
      aeMaxLength := TPictureCellField(aeCell).MaxLength;
    end;
    Refresh;
  end;
end;

procedure TOvcPictureArrayEditor.SetPictureMask(const Value : string);
  {-set the picture mask}
begin
  if aePictureMask <> Value then begin
    aePictureMask := Value;
    if Assigned(aeCell) then begin
      TPictureCellField(aeCell).PictureMask := aePictureMask;

      {reset our copy of the edit field properties}
      aePictureMask := TPictureCellField(aeCell).PictureMask;
      aeMaxLength := TPictureCellField(aeCell).MaxLength;
      aeDecimalPlaces := TPictureCellField(aeCell).DecimalPlaces;
    end;
    Refresh;
  end;
end;


{*** TPictureCellField ***}

constructor TPictureCellField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assgin edit field properties}
  ParentFont := True;
  ParentColor := True;
  Ctl3D := False;
  ParentCtl3D := False;
  BorderStyle := TBorderStyle(0);
  AutoSize := False;
end;

procedure TPictureCellField.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcPictureArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnChange         := TOvcPictureArrayEditor(Parent).OnChange;
  OnClick          := TOvcPictureArrayEditor(Parent).OnClick;
  OnDblClick       := TOvcPictureArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcPictureArrayEditor(Parent).OnEnter;
  OnError          := TOvcPictureArrayEditor(Parent).OnError;
  OnExit           := TOvcPictureArrayEditor(Parent).OnExit;
  OnKeyDown        := TOvcPictureArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcPictureArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcPictureArrayEditor(Parent).OnKeyUp;
  OnMouseDown      := TOvcPictureArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcPictureArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcPictureArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcPictureArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcPictureArrayEditor(Parent).OnUserValidation;
end;

procedure TPictureCellField.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  case Cmd of
    ccUp       :
      Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
    ccDown     :
      Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    ccFirstPage:
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
    ccLastPage :
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, High(SmallInt)), Parent.Handle);
    ccPrevPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
    ccNextPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
  else
    inherited;
  end;
end;

procedure TPictureCellField.WMKillFocus(var Msg : TWMKillFocus);
begin
  {save the current cell value}
  TOvcBaseArrayEditor(Parent).DoPutCellValue;

  inherited;
end;

procedure TPictureCellField.WMSetFocus(var Msg : TWMSetFocus);
begin
  TOvcBaseArrayEditor(Parent).aePreFocusProcess;

  inherited;
end;


{*** TOvcNumericArrayEditor ***}

procedure TOvcNumericArrayEditor.aeCreateEditCell;
  {-create the edit celll}
begin
  aeCell.Free;
  aeCell := TNumericCellField.Create(Self);
  AeCell.Controller := Controller;

  TNumericCellField(aeCell).DataType := aeDataType;
  TNumericCellField(aeCell).DecimalPlaces := aeDecimalPlaces;
  TNumericCellField(aeCell).PictureMask := aePictureMask;
  TNumericCellField(aeCell).MaxLength := Length(aePictureMask);
end;

function TOvcNumericArrayEditor.aeGetEditString : PChar;
  {-return the edit cells edit string}
begin
  Result := TNumericCellField(aeCell).efEditSt;
end;

procedure TOvcNumericArrayEditor.aeGetSampleDisplayData(P : PChar);
  {-cause edit cell to display sample data}
begin
  TNumericCellField(aeCell).efGetSampleDisplayData(P);
end;

constructor TOvcNumericArrayEditor.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {set defaults}
  aeDataType       := nftLongInt;
  aePictureMask    := '##########';
  aeRangeHi.rtLong := High(Integer);
  aeRangeLo.rtLong := Low(Integer);
end;

destructor TOvcNumericArrayEditor.Destroy;
begin
  aeCell.Free;
  inherited Destroy;
end;

procedure TOvcNumericArrayEditor.DoGetCellValue(Index : Integer);
  {-get value for this array index and assign to the edit field}
begin
  aeItemPtr := nil;
  if Assigned(FOnGetItem) and not (csDesigning in ComponentState) then
    FOnGetItem(Self, Index, aeItemPtr);

  if aeItemPtr = nil then
    TNumericCellField(aeCell).efSetInitialValue
  else begin
    TNumericCellField(aeCell).SetValue(aeItemPtr^);
    TNumericCellField(aeCell).efSaveEditString;
  end;
end;

function TOvcNumericArrayEditor.DoPutCellValue : Integer;
  {-assign the value of the edit field to the associated variable}
begin
  Result := 0;
  if (aeItemPtr <> nil) then
    Result := TNumericCellField(aeCell).GetValue(aeItemPtr^);
end;

procedure TOvcNumericArrayEditor.SetActiveIndex(Value : Integer);
  {-set the currently selected item}
var
  OldItem  : Integer;
  Scrolled : Boolean;
  Err      : Integer;
begin
  if csDesigning in ComponentState then
    Exit;

  {verify valid index}
  if Value < 0 then
    Value := 0
  else if Value > aeHighIndex then
    Value := aeHighIndex;

  if (Value <> FActiveIndex) then begin
    if TNumericCellField(aeCell).Modified then begin
      {put value of cell field into user var}
      Err := DoPutCellValue;
      if Err <> 0 then begin
        PostMessage(aeCell.Handle, om_ReportError, Err, 0);
        Exit;
      end;
    end;

    TNumericCellField(aeCell).efCaret.Visible := False;
    TNumericCellField(aeCell).SetSelection(0, 0);
    TNumericCellField(aeCell).Update;

    OldItem := FActiveIndex;

    {disable cell painting}
    SendMessage(aeCell.Handle, WM_SETREDRAW, 0, 0);
    try
      FActiveIndex := Value;
      Scrolled := aeMakeItemVisible(Value);

      TNumericCellField(aeCell).efCaret.Visible := True;
      TNumericCellField(aeCell).SetSelection(0, 255);

      {get the new pointer and value}
      DoGetCellValue(FActiveIndex);
      {reset horizontal offset}
      TNumericCellField(aeCell).efHOffset := 0;
    finally
      {allow cell painting}
      SendMessage(aeCell.Handle, WM_SETREDRAW, 1, 0);
    end;

    aeSetVScrollPos;
    aeUpdateDisplay(Scrolled, OldItem, Value);
    DoOnSelect(FActiveIndex);
  end;
end;

procedure TOvcNumericArrayEditor.SetArrayDataType(Value: TNumericDataType);
  {-set the data type for this field}
begin
  aeDataType := Value;
  if Assigned(aeCell) then begin
    TNumericCellField(aeCell).DataType := aeDataType;

    {reset our copies of the edit field properties}
    aeDataType := TNumericCellField(aeCell).DataType;
    aeDecimalPlaces := TNumericCellField(aeCell).DecimalPlaces;
    aePictureMask := TNumericCellField(aeCell).PictureMask;
    aeRangeHi := TLocalEF(aeCell).efRangeHi;
    aeRangeLo := TLocalEF(aeCell).efRangeLo;
  end;
  Refresh;
end;

procedure TOvcNumericArrayEditor.SetPictureMask(const Value : string);
  {-set the picture mask}
begin
  if aePictureMask <> Value then begin
    aePictureMask := Value;
    if Assigned(aeCell) then begin
      TNumericCellField(aeCell).PictureMask := aePictureMask;

      {reset our copies of the edit field properties}
      aePictureMask := TNumericCellField(aeCell).PictureMask;
      aeMaxLength := TNumericCellField(aeCell).MaxLength;
      aeDecimalPlaces := TNumericCellField(aeCell).DecimalPlaces;
    end;
    Refresh;
  end;
end;


{*** TNumericCellField ***}

constructor TNumericCellField.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {assgin edit field properties}
  ParentFont := True;
  ParentColor := True;
  Ctl3D := False;
  ParentCtl3D := False;
  BorderStyle := TBorderStyle(0);
  AutoSize := False;
end;

procedure TNumericCellField.CreateWnd;
begin
  {set controller before window is created}
  Controller := TOvcNumericArrayEditor(Parent).Controller;
  inherited CreateWnd;

  {assign parent event handlers to the edit cell}
  OnClick          := TOvcNumericArrayEditor(Parent).OnClick;
  OnChange         := TOvcNumericArrayEditor(Parent).OnChange;
  OnError          := TOvcNumericArrayEditor(Parent).OnError;
  OnDblClick       := TOvcNumericArrayEditor(Parent).OnDblClick;
  OnEnter          := TOvcNumericArrayEditor(Parent).OnEnter;
  OnKeyDown        := TOvcNumericArrayEditor(Parent).OnKeyDown;
  OnKeyPress       := TOvcNumericArrayEditor(Parent).OnKeyPress;
  OnKeyUp          := TOvcNumericArrayEditor(Parent).OnKeyUp;
  OnExit           := TOvcNumericArrayEditor(Parent).OnExit;
  OnMouseDown      := TOvcNumericArrayEditor(Parent).OnMouseDown;
  OnMouseMove      := TOvcNumericArrayEditor(Parent).OnMouseMove;
  OnMouseUp        := TOvcNumericArrayEditor(Parent).OnMouseUp;
  OnUserCommand    := TOvcNumericArrayEditor(Parent).OnUserCommand;
  OnUserValidation := TOvcNumericArrayEditor(Parent).OnUserValidation;
end;

procedure TNumericCellField.WMKeyDown(var Msg : TWMKeyDown);
var
  Cmd : Word;
begin
  {process keyboard commands}
  Cmd := Controller.EntryCommands.Translate(TMessage(Msg));
  case Cmd of
    ccUp       :
      Parent.Perform(WM_VSCROLL, SB_LINEUP, 0);
    ccDown     :
      Parent.Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    ccFirstPage:
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, 0), Parent.Handle);
    ccLastPage :
      Parent.Perform(WM_VSCROLL, MAKELONG(SB_THUMBPOSITION, High(SmallInt)), Parent.Handle);
    ccPrevPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEUP, 0);
    ccNextPage :
      Parent.Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
  else
    inherited;
  end;
end;

procedure TNumericCellField.WMKillFocus(var Msg : TWMKillFocus);
begin
  {save the current cell value}
  TOvcBaseArrayEditor(Parent).DoPutCellValue;

  inherited;
end;

procedure TNumericCellField.WMSetFocus(var Msg : TWMSetFocus);
begin
  TOvcBaseArrayEditor(Parent).aePreFocusProcess;

  inherited;
end;



end.

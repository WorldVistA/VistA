{*********************************************************}
{*                    OVCCALC.PAS 4.06                   *}
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

// PM 05-NOV-2015 Fixed error in WMSetCursor
//                Added theming support in procedure TOvcCustomCalculator.Paint
//                Added theming support in procedure TOvcCustomCalculator.cDrawCalcButton
// PM 07-NOV-2015 Extended Theming support with mouse over hot tracking
//                Fixed refresh bug of display, by uncommenting a line in TOvcCustomCalculator.cRefreshDisplays

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovccalc;
  {-calculator component}

interface

uses
  UITypes, Types, Windows, Buttons, Classes, ClipBrd, Controls, ExtCtrls,
  Forms, Graphics, Menus, Messages, StdCtrls, SysUtils, OvcData, OvcConst, OvcBase,
  OvcMisc, Vcl.Themes;

type
  TOvcCalculatorButton = (
    cbNone, cbTape, cbBack, cbClearEntry, cbClear, cbAdd, cbSub, cbMul, cbDiv,
    cb0, cb1, cb2, cb3, cb4, cb5,  cb6, cb7, cb8, cb9,
    cbDecimal, cbEqual, cbInvert, cbChangeSign, cbPercent, cbSqrt,
    cbMemClear, cbMemRecall, cbMemStore, cbMemAdd, cbMemSub, cbSubTotal);

  TOvcButtonInfo = packed record
    Position : TRect;      {position and size}
    Caption  : string; {button text}
    Visible  : Boolean;    {true to display button}
  end;

  TOvcButtonArray = array[cbTape..cbMemSub] of TOvcButtonInfo;

type
  TOvcCalculatorOperation = (
    coNone, coAdd, coSub, coMul, coDiv,
    coEqual, coInvert, coPercent, coSqrt,
    coMemClear, coMemRecall, coMemStore, coMemAdd, coMemSub, coSubTotal);

  TOvcCalcState = (csValid, csLocked, csClear);
  TOvcCalcStates = set of TOvcCalcState;

type
  TOvcCalcColorArray = array[0..7] of TColor;
  TOvcCalcColorScheme = (cscalcCustom, cscalcWindows, cscalcDark,
                        cscalcOcean, cscalcPlain);
  TOvcCalcSchemeArray = array[TOvcCalcColorScheme] of TOvcCalcColorArray;
  TOvcCalcDisplayString = array[TOvcCalculatorButton] of string;
  TOvcCalcButtonToOperation = array[cbNone..cbSubTotal] of TOvcCalculatorOperation;


const
  {DisabledMemoryButtons, Display, DisplayTextColor, EditButtons,
   FunctionButtons, MemoryButtons, NumberButtons, OperatorButtons}
  CalcScheme : TOvcCalcSchemeArray =
    ((0, 0, 0, 0, 0, 0, 0, 0),
     (clGray, clWindow, clWindowText, clMaroon, clNavy, clRed,  clBlue,   clRed),
     (clGray, clBlack,  clAqua,       clBlack,  clTeal, clNavy, clMaroon, clBlue),
     (clGray, clAqua,   clBlack,      clPurple, clNavy, clNavy, clAqua,   clBlue),
     (clGray, clWhite,  clNavy,       clBlack,  clNavy, clNavy, clBlue,   clBlue)
    );
{ You must set the Length of the first entry (cbNone) to the Length of the largest entry}
  CalcDisplayString : TOvcCalcDisplayString =
    ('  ','  ','  ','CE','C' ,'+' ,'-' ,'*' ,'/',
     '  ','  ','  ','  ','  ','  ','  ','  ','  ','  ',
     '  ','=' ,'1/','-+','%' ,'SQ',
     'MC','MR','MS','M+','M-','*' );

  CalcButtontoOperation : TOvcCalcButtonToOperation =
    (coNone, coNone, coNone, coNone, coNone, coAdd, coSub, coMul, coDiv,
     coNone, coNone, coNone, coNone, coNone, coNone,  coNone, coNone, coNone, coNone,
     coNone, coEqual, coInvert, coNone, coPercent, coSqrt,
     coMemClear, coMemRecall, coMemStore, coMemAdd, coMemSub, coSubTotal);

type
  TOvcCalcColors = class(TPersistent)

  private
    {property variables}
    FUpdating     : Boolean;
    FOnChange     : TNotifyEvent;

    {internal variables}
    SettingScheme : Boolean;

    {internal methods}
    procedure DoOnChange;

    {property methods}
    function GetColor(const Index : Integer) : TColor;
    function GetDisplayTextColor: TColor;
    procedure SetColor(const Index : Integer; const Value : TColor);
    procedure SetColorScheme(const Value : TOvcCalcColorScheme);
    procedure SetDisplayTextColor(const Value : TColor);

  public
    {property variables}
    FCalcColors   : TOvcCalcColorArray;
    FColorScheme  : TOvcCalcColorScheme;

    procedure Assign(Source : TPersistent);
      override;
    procedure BeginUpdate;
    procedure EndUpdate;

    property OnChange : TNotifyEvent
      read FOnChange write FOnChange;

  published
    property ColorScheme : TOvcCalcColorScheme
      read FColorScheme write SetColorScheme;
    property DisabledMemoryButtons : TColor index 0
      read GetColor write SetColor;
    property Display : TColor index 1
      read GetColor write SetColor;
    property DisplayTextColor : TColor read GetDisplayTextColor write SetDisplayTextColor nodefault;
    property EditButtons : TColor index 3
      read GetColor write SetColor;
    property FunctionButtons : TColor index 4
      read GetColor write SetColor;
    property MemoryButtons : TColor index 5
      read GetColor write SetColor;
    property NumberButtons : TColor index 6
      read GetColor write SetColor;
    property OperatorButtons : TColor index 7
      read GetColor write SetColor;
  end;

type

  TOvcCalcPanel = class(TPanel)
  protected
    procedure Click;
      override;
  public
  end;

type

  TOvcCustomCalculatorEngine = class
  protected {private}
    {property variables}
    FDecimals            : Integer;
    FShowSeparatePercent : Boolean;

    {internal variables}
    cCalculated          : Extended;
    cLastOperation       : TOvcCalculatorOperation;
    cOperationCount      : Integer;
    cMemory              : Extended;     {value stored in memory register}
    cOperands            : array [0..3] of Extended;     {the operand stack}
    cState               : TOvcCalcStates;

  public
    function AddOperand(const Value : Extended; const Button : TOvcCalculatorOperation) : Boolean;
        virtual; abstract;
    function AddOperation(const Button : TOvcCalculatorOperation) : Boolean;
        virtual; abstract;
    procedure ClearAll;
    procedure PushOperand(const Value : Extended);
    function PopOperand : Extended;
    function TopOperand : Extended;

    {public properties}
    property Decimals : Integer
      read FDecimals write FDecimals;
    property LastOperation : TOvcCalculatorOperation
      read cLastOperation write cLastOperation;
    property Memory : Extended
      read cMemory write cMemory;
    property OperationCount : Integer
      read cOperationCount write cOperationCount;
    property ShowSeparatePercent : Boolean
      read FShowSeparatePercent write FShowSeparatePercent;
    property State : TOvcCalcStates
      read cState write cState;
  end;

type

  TOvcCalcTape = class(TObject)
  protected {private}
    {property variables}
    FMaxPaperCount    : Integer;
    FShowTape         : Boolean;
    FTapeDisplaySpace : Integer;
    FVisible          : Boolean;

    {internal variables}
    taListBox         : TListBox;
    taTapeColor       : TColor;
    taHeight          : Integer;
    taOwner           : TComponent;
    taOperandSize     : Integer;
    taFont            : TFont;
    taMaxTapeCount    : Integer;
    taTapeInitialized : Boolean;
    taWidth           : Integer;

    procedure ValidateListBox;
    function GetFont : TFont;
    procedure SetFont(const Value : TFont);
    function GetHeight : Integer;
    procedure SetHeight(const Value : Integer);
    function GetTape : TStrings;
    procedure SetTape(const Value : TStrings);
    function GetTapeColor : TColor;
    procedure SetTapeColor(const Value : TColor);
    function GetTop : Integer;
    procedure SetTop(const Value : Integer);
    function GetTopIndex : Integer;
    procedure SetTopIndex(const Value : Integer);
    function GetVisible : Boolean;
    procedure SetVisible(const Value : Boolean);
    function GetWidth : Integer;
    procedure SetWidth(const Value : Integer);

  protected
    procedure Add(const Value : string);
    procedure DeleteFirst;
    procedure taOnClick(Sender : TObject);
    procedure taOnDblClick(Sender : TObject);
    procedure taOnDrawItem(Control: TWinControl; Index: Integer;
                           Rect:TRect;State: TOwnerDrawState);
    procedure taTapeFontChange(Sender : TObject);

  public
    constructor Create(const AOwner : TComponent; const AOperandSize : Integer);
    destructor Destroy;
      override;

    procedure InitializeTape;
    procedure SetBounds(const ALeft, ATop, AWidth, AHeight : Integer);
    function GetDisplayedItemCount : Integer;
    procedure AddToTape(const Value : string;
                         const OpString : string);
    procedure AddToTapeLeft(const Value : string);
    procedure ClearTape;
    procedure RefreshDisplays;
    procedure SpaceTape(const Value : char);

    property Font : TFont
      read GetFont write SetFont;
    property Height : Integer
      read GetHeight write SetHeight;
    property MaxPaperCount : Integer
      read FMaxPaperCount write FMaxPaperCount;
    property ShowTape : Boolean
      read FShowTape write FShowTape;
    property Tape : TStrings
      read GetTape write SetTape;
    property TapeColor : TColor
      read GetTapeColor write SetTapeColor;
    property TapeDisplaySpace : Integer
      read FTapeDisplaySpace write FTapeDisplaySpace;
    property Top : Integer
      read GetTop write SetTop;
    property TopIndex : Integer
      read GetTopIndex write SetTopIndex;
    property Visible : Boolean
      read GetVisible write SetVisible;
    property Width : Integer
      read GetWidth write SetWidth;
  end;

type
  TOvcCalcButtonPressedEvent =
    procedure(Sender : TObject; Button : TOvcCalculatorButton)
    of object;

  TOvcCalculatorOption = (coShowItemCount, coShowMemoryButtons,
    coShowClearTapeButton, coShowTape, coShowSeparatePercent);
  TOvcCalculatorOptions = set of TOvcCalculatorOption;

  TOvcCustomCalculator = class(TOvcCustomControl)

  protected {private}
    {property variables}
    FBorderStyle       : TBorderStyle;
    FColors            : TOvcCalcColors;
    FDisplay           : Extended;     {the calculated value}
    FDisplayStr        : string;       {the string that is displayed}
    FLastOperand       : Extended;
    FOptions           : TOvcCalculatorOptions;
    FTapeSeparatorChar : Char;

    {event variables}
    FOnButtonPressed   : TOvcCalcButtonPressedEvent;

    {internal variables}
    cButtons           : TOvcButtonArray;
    cDecimalEntered    : Boolean;
    cDownButton        : TOvcCalculatorButton;
    cHitTest           : TPoint;       {location of mouse cursor}
    cLastButton        : TOvcCalculatorButton;
    cMargin            : Integer;
    cMinus0            : Boolean;
    cOverBar           : Boolean;
    cPanel             : TOvcCalcPanel;
    cPopup             : Boolean;      {true if being created as a popup}
    cScrBarWidth       : Integer;
    cSizeOffset        : Integer;      { the offset of the sizing line }
    cSizing            : Boolean;      { Are we showing the sizing cursor? }
    cTabCursor         : HCursor;      {design-time tab slecting cursor handle}
    cTape              : TOvcCalcTape;
    cEngine            : TOvcCustomCalculatorEngine;

    cMouseOverButton   : TOvcCalculatorButton;  // PM 07-NOV-2015 For mouse over theme styling
    cMouseTracking     : Boolean;

    {internal methods}
    procedure cAdjustHeight;
    procedure cCalculateLook;
    procedure cClearAll;
    procedure cColorChange(Sender : TObject);
    procedure cDisplayError;
    procedure cDrawCalcButton(const Button : TOvcButtonInfo; const Pressed, MouseOver : Boolean);  // PM 07-11-2015 Added MouseOVer parameter
    procedure cDrawFocusState;
    procedure cDrawSizeLine;
    procedure cEvaluate(const Button : TOvcCalculatorButton);
    function cFormatString(const Value : Extended) : string;
    function cGetFontWidth : Integer;
    procedure cInvalidateIndicator;
    procedure cRefreshDisplays;
    procedure cSetDisplayString(const Value : string);
    procedure cTapeFontChange(Sender : TObject);

    {property methods}
    function GetDecimals : Integer;
    function GetMaxPaperCount : Integer;
    function GetMemory : Extended;
    function GetOperand : Extended;
    function GetTape : TStrings;
    function GetTapeFont : TFont;
    function GetTapeHeight : Integer;
    function GetVisible : Boolean;
    procedure SetBorderStyle(const Value : TBorderStyle);
    procedure SetDecimals(const Value : Integer);
    procedure SetDisplay(const Value : Extended);
    procedure SetDisplayStr(const Value : string);
    procedure SetMaxPaperCount(const Value : Integer);
    procedure SetMemory(const Value : Extended);
    procedure SetOperand(const Value : Extended);
    procedure SetOptions(const Value : TOvcCalculatorOptions);
    procedure SetTape(const Value : TStrings);
    procedure SetTapeFont(const Value : TFont);
    procedure SetTapeHeight(const Value : Integer);
    procedure SetVisible(const Value : Boolean);

    {VCL control methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMEnter(var Msg : TMessage);
      message CM_ENTER;
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;

    {windows message handlers}
    procedure WMCancelMode(var Msg : TMessage);
      message WM_CANCELMODE;
    procedure WMEraseBkgnd(var Msg : TWMEraseBkgnd);
      message WM_ERASEBKGND;
    procedure WMGetText(var Msg : TWMGetText);
      message WM_GETTEXT;
    procedure WMGetTextLength(var Msg : TWMGetTextLength);
      message WM_GETTEXTLENGTH;
    procedure WMKeyDown(var Msg : TWMKeyDown);
      message WM_KEYDOWN;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;
    procedure WMLButtonDown(var Msg : TWMMouse);
      message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Msg : TWMMouse);
      message WM_LBUTTONUP;
    procedure WMMouseMove(var Msg : TWMMouse);
      message WM_MOUSEMOVE;
    procedure WMMouseLeave(var Msg: TWMMouse);      // PM 07-NOV-2015
      message WM_MOUSELEAVE;                        // PM 07-NOV-2015
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
    procedure WMSetText(var Msg : TWMSetText);
      message WM_SETTEXT;
    procedure WMSetCursor(var Msg : TWMSetCursor);
      message WM_SETCURSOR;

  protected
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Paint;
      override;

    {protected properties}
    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle;
    property Colors : TOvcCalcColors
      read FColors write FColors;
    property Decimals : Integer
      read GetDecimals write SetDecimals;
    property MaxPaperCount : Integer
      read GetMaxPaperCount write SetMaxPaperCount;
    property Options : TOvcCalculatorOptions
      read  FOptions write SetOptions;
    property TapeFont : TFont
      read GetTapeFont write SetTapeFont;
    property TapeHeight : Integer
      read GetTapeHeight write SetTapeHeight;
    property TapeSeparatorChar : Char
      read FTapeSeparatorChar write FTapeSeparatorChar;
    property Visible : Boolean
      read GetVisible write SetVisible;

    {protected events}
    property OnButtonPressed : TOvcCalcButtonPressedEvent
      read FOnButtonPressed  write FOnButtonPressed;

  public

    constructor Create(AOwner : TComponent);
      override;
    constructor CreateEx(AOwner : TComponent; AsPopup : Boolean);
      virtual;
    destructor Destroy;
      override;
    procedure KeyPress(var Key : Char);
      override;
    procedure PushOperand(const Value : Extended);
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;

    procedure CopyToClipboard;
    procedure PasteFromClipboard;
    procedure PressButton(Button : TOvcCalculatorButton);

    {public properties}
    property LastOperand : Extended
      read FLastOperand write FLastOperand;
    property Memory : Extended
      read GetMemory write SetMemory;
    property Operand : Extended
      read GetOperand write SetOperand;
    property DisplayStr : string
      read FDisplayStr write SetDisplayStr;
    property DisplayValue : Extended
      read FDisplay write SetDisplay;
    property Tape : TStrings
      read GetTape write SetTape;
  end;

  TOvcCalculator = class(TOvcCustomCalculator)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle default bsNone;
    property Ctl3D;
    property Font;  {must be prior to "Colors"}
    property TapeFont; {must be prior to "Colors"}
    property Colors;
    property Cursor;
    property Decimals;
    property DragCursor;
    property DragMode;
    property Enabled;
    property LabelInfo;
    property MaxPaperCount default 9999;
    property TapeHeight ; {Must be Prior to Options}
    property Options default [coShowMemoryButtons, coShowItemCount];
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property TapeSeparatorChar default '_';
    property Visible default True;

    {events}
    property OnButtonPressed;
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
    property OnMouseWheel;
    property OnStartDrag;
  end;


implementation

uses
  ovcstr, OvcFormatSettings;

const
  calcDefMinSize = 30;


{*** TOvcCalcColors ***}

procedure TOvcCalcColors.Assign(Source : TPersistent);
begin
  if Source is TOvcCalcColors then begin
    FCalcColors := TOvcCalcColors(Source).FCalcColors;
    FColorScheme := TOvcCalcColors(Source).FColorScheme;
    FOnChange := TOvcCalcColors(Source).FOnChange;
  end else
    inherited Assign(Source);
end;

procedure TOvcCalcColors.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TOvcCalcColors.EndUpdate;
begin
  FUpdating := False;
  DoOnChange;
end;

procedure TOvcCalcColors.DoOnChange;
begin
  if not FUpdating and Assigned(FOnChange) then
    FOnChange(Self);

  if not SettingScheme then
    FColorScheme := cscalcCustom;
end;

function TOvcCalcColors.GetColor(const Index : Integer) : TColor;
begin
  Result := FCalcColors[Index];
end;

function TOvcCalcColors.GetDisplayTextColor: TColor;
begin
  Result := FCalcColors[2];
end;

procedure TOvcCalcColors.SetColor(const Index : Integer; const Value : TColor);
begin
  if Value <> FCalcColors[Index] then begin
    FCalcColors[Index] := Value;
    DoOnChange;
  end;
end;

procedure TOvcCalcColors.SetColorScheme(const Value : TOvcCalcColorScheme);
begin
  if Value <> FColorScheme then begin
    SettingScheme := True;
    try
      FColorScheme := Value;
      if Value <> cscalcCustom then begin
        FCalcColors := CalcScheme[Value];
        DoOnChange;
      end;
    finally
      SettingScheme := False;
    end;
  end;
end;

procedure TOvcCalcColors.SetDisplayTextColor(const Value : TColor);
begin
  if Value <> FCalcColors[2] then begin
    FCalcColors[2] := Value;
    DoOnChange;
  end;
end;


{*** TOvcCalcTape ***}

constructor TOvcCalcTape.Create(const AOwner : TComponent; const AOperandSize : Integer);
begin
  inherited Create;
  taOwner           := AOwner;
  FVisible          := False;
  taOperandSize     := AOperandSize;
  taFont            := TFont.Create;
  taFont.Name       := 'Courier New';
  taFont.Size       := 10;
  taFont.Style      := [];
end;

destructor TOvcCalcTape.Destroy;
begin
  taFont.Free;
  taFont := nil;

  inherited Destroy;
end;

procedure TOvcCalcTape.ValidateListBox;
begin
  if not Assigned(taListBox) then begin
    taListBox := TListBox.Create(taOwner);
    with taListBox do begin
      OnClick         := taOnClick;
      OnDblClick      := taOnDblClick;
      OnDrawItem      := taOnDrawItem;
      Style           := lbOwnerDrawFixed;
      Parent          := taOwner as TWinControl;
      ParentFont      := False;
      ParentCtl3D     := True;
      BorderStyle     := bsSingle;
      Color           := taTapeColor;
      Visible         := FVisible;
      Width           := taWidth;
      Height          := taHeight;
      Font.Assign(taFont);
      Font.OnChange   := taFont.OnChange;
      taFont.OnChange := taTapeFontChange;
      TabStop         := False;
    end;
    taTapeInitialized := False;
  end;
  InitializeTape;
end;

procedure TOvcCalcTape.Add(const Value : string);
begin
  ValidateListBox;
  taListBox.Items.Add(Value);
end;

procedure TOvcCalcTape.DeleteFirst;
begin
  ValidateListBox;
  with taListBox, Items do
    if Strings[0] = '' then
      taListBox.Items.Delete(0)
    else
      Inc(taMaxTapeCount);
end;

procedure TOvcCalcTape.SetFont(const Value : TFont);
begin
  taFont.Assign(Value);
  taFont.OnChange(Self);
end;

function TOvcCalcTape.GetFont : TFont;
begin
  Result := taFont;
end;

procedure TOvcCalcTape.SetHeight(const Value : Integer);
begin
  taHeight := Value;
  if Visible then begin
    ValidateListBox;
    taListBox.Height := Value;
  end;
end;

function TOvcCalcTape.GetHeight : Integer;
begin
  if Visible then begin
    ValidateListBox;
    Result := taListBox.Height;
  end else
    Result := taHeight;
end;

function TOvcCalcTape.GetTape : TStrings;
begin
  ValidateListBox;
  Result := taListBox.Items;
end;

procedure TOvcCalcTape.SetTape(const Value : TStrings);
begin
  ValidateListBox;
  taListBox.Items.Assign(Value);
end;

function TOvcCalcTape.GetTapeColor : TColor;
begin
  if Visible then begin
    ValidateListBox;
    Result := taListBox.Color;
  end else
    Result := taTapeColor;
end;

procedure TOvcCalcTape.SetTapeColor(const Value : TColor);
begin
  taTapeColor := Value;
  if Visible then begin
    ValidateListBox;
    taListBox.Color := Value;
  end;
end;

procedure TOvcCalcTape.SetTop(const Value : Integer);
begin
  ValidateListBox;
  taListBox.Top := Value;
end;

function TOvcCalcTape.GetTop : Integer;
begin
  ValidateListBox;
  Result := taListBox.Top;
end;

function TOvcCalcTape.GetVisible : Boolean;
begin
  Result := FVisible;
end;

procedure TOvcCalcTape.SetVisible(const Value : Boolean);
begin
  FVisible := Value;
  if Assigned(taListBox) then begin
    if not Value and taListBox.Visible then begin
      if csDesigning in taListBox.Owner.ComponentState then begin
        taListBox.Visible := Value;
        taListBox.Height := 0;
      end else
        taListBox.Visible := Value;
    end else if Value and not taListBox.Visible then begin
      taListBox.Visible := Value;
      taListBox.Height := taHeight;
    end;
  end else if Value then begin
    ValidateListBox;
    taListBox.Visible := Value;
  end;
end;

procedure TOvcCalcTape.SetWidth(const Value : Integer);
begin
  taWidth := Value;
  if Visible then begin
    ValidateListBox;
    taListBox.Width := Value;
  end;
end;

function TOvcCalcTape.GetWidth : Integer;
begin
  if Visible then begin
    ValidateListBox;
    Result := taListBox.Width;
  end else
    Result := taWidth;
end;

procedure TOvcCalcTape.SetTopIndex(const Value : Integer);
begin
  ValidateListBox;
  taListBox.TopIndex := Value;
end;

function TOvcCalcTape.GetTopIndex : Integer;
begin
  ValidateListBox;
  Result := taListBox.TopIndex;
end;

procedure TOvcCalcTape.SetBounds(const ALeft, ATop, AWidth, AHeight : Integer);
begin
  ValidateListBox;
  taListBox.SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TOvcCalcTape.InitializeTape;
begin
  if not Assigned(taListBox) then
    Exit;
  if csDesigning in taListBox.Owner.ComponentState then
    if not taListBox.HandleAllocated then
      Exit;
  if taTapeInitialized then
    Exit;
  ClearTape;
  taTapeInitialized := True;
end;

procedure TOvcCalcTape.taOnClick(Sender : TObject);
begin
  ValidateListBox;
  (taListBox.Owner as TOvcCustomCalculator).SetFocus;
end;

procedure TOvcCalcTape.taOnDblClick(Sender : TObject);
var
  Str : string;
begin
  ValidateListBox;
  if (taListBox.Items.Count < 1) then
    Exit;
  Str := taListBox.Items.Strings[taListBox.ItemIndex];
  try
    if (Str[1] = '0') and
       (Str[2] <> '.') then
      Exit;
    if taListBox.Items.Strings[taListBox.ItemIndex] <> '' then begin
      (taListBox.Owner as TOvcCustomCalculator).DisplayValue :=
        StrToFloat(Copy(Str,1,  Length(Str) - taOperandSize));
      (taListBox.Owner as TOvcCustomCalculator).LastOperand :=
        StrToFloat(Copy(Str,1,  Length(Str) - taOperandSize));
      (taListBox.Owner as TOvcCustomCalculator).Operand :=
        StrToFloat(Copy(Str,1,  Length(Str) - taOperandSize));
      (taListBox.Owner as TOvcCustomCalculator).DisplayStr :=
        Copy(Str,1,             Length(Str) - taOperandSize);
      (taListBox.Owner as TOvcCustomCalculator).SetFocus;
    end;
  except
  end;
end;

procedure TOvcCalcTape.taOnDrawItem(Control: TWinControl; Index: Integer;
                                   Rect:TRect;State: TOwnerDrawState);
var
  SaveColor : TColor;
  SaveBack : TColor;
  Str : String;
  I, FirstUsedIndex : Integer;
begin
  FirstUsedIndex := 0;
  if Index > FMaxPaperCount then
    with (Control as TListBox) do begin
      for I := 0 to Index do begin
        if Items[I] <> '' then begin
          FirstUsedIndex := I;
          Break;
        end;
      end;
    end;

  Str := (Control as TListBox).Items[Index];
  with (Control as TListBox).Canvas do begin        { draw on control canvas, not on the form }
    FillRect(Rect);						  { clear the rectangle }

    SaveColor := (Control as TListBox).Canvas.Font.Color;
    try
      SaveBack := (Control as TListBox).Canvas.Brush.Color;
      try
        if (Trim(Str) <> '') then begin
          if (Trim(Str)[1] = '-') then
            (Control as TListBox).Canvas.Font.Color := clRed;
          if FTapeDisplaySpace > Length(Str) then
            Str := Str + StringOfChar(' ', FTapeDisplaySpace - Length(Str));
          TextOut(Rect.Left, Rect.Top, Copy(Str, 1, Length(Str) - 1));
          if Index - FirstUsedIndex >= FMaxPaperCount then
            (Control as TListBox).Canvas.Brush.Color := clRed;
          TextOut(PenPos.X, PenPos.Y, Copy(Str, Length(Str), 1));
        end;
      finally
        (Control as TListBox).Canvas.Brush.Color := SaveBack;
      end;
    finally
      (Control as TListBox).Canvas.Font.Color := SaveColor;
    end;
  end;
end;

procedure TOvcCalcTape.taTapeFontChange(Sender : TObject);
begin
  if Visible then begin
    taListBox.Font.Assign(taFont);
    taListBox.Font.OnChange(Sender);
  end;
end;

function TOvcCalcTape.GetDisplayedItemCount : Integer;
var
  DC         : hDC;
  SaveFont   : hFont;
  Size       : TSize;
begin
  if not Assigned(taListBox) then begin
    Result := 0;
    Exit;
  end;

  DC := GetDC(0);
  SaveFont := SelectObject(DC, taListBox.Font.Handle);
  GetTextExtentPoint32(DC, ' 0123456789', 11, Size);
  Result := taListBox.ClientHeight div Size.cy;
  if Result < 3 then
    Result := 3;
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

procedure TOvcCalcTape.AddToTape(const Value : string; const OpString : string);
  {-adds an operand to the tape display}
var
  TapeString : string;
  DSpace     : Integer;
begin
  DSpace := FTapeDisplaySpace - Length(Value);
  TapeString := StringOfChar(' ', DSpace - taOperandSize);
  TapeString := TapeString + Value + ' ' + OpString;
  Add(TapeString);
  DeleteFirst;
  TopIndex := taMaxTapeCount - GetDisplayedItemCount + 2;
end;

{adds an operand to the tape display}
procedure TOvcCalcTape.AddToTapeLeft(const Value : string);
var
  TapeString : string;
  DSpace : Integer;
begin
  DSpace := FTapeDisplaySpace - Length(Value);
  TapeString := StringOfChar(' ', DSpace);
  TapeString := Value + TapeString;
  Add(Value);
  DeleteFirst;
  TopIndex := taMaxTapeCount - GetDisplayedItemCount + 2;
end;

procedure TOvcCalcTape.ClearTape;
var
  I : Integer;
begin
  if not Assigned(taListBox) then
    Exit;
  if csDesigning in taListBox.Owner.ComponentState then
    if not taListBox.HandleAllocated then
      Exit;
  taMaxTapeCount := 30; {set starting line count}

  taListBox.Items.Clear;
  for I := 0 to taMaxTapeCount - 1 do
    taListBox.Items.Add('');
  taListBox.TopIndex := taMaxTapeCount - GetDisplayedItemCount + 2;
end;

procedure TOvcCalcTape.RefreshDisplays;
var
  I, Diff : Integer;
  S : string;

  function AllSame(const Str : string) : Boolean;
  var
    I : Integer;
  begin
    Result := True;
    for I := 2 to Length(Str) do begin
      if Str[1] <> Str[I] then
        Exit;
    end;
  end;

begin
  if not Assigned(taListBox) then
    Exit;
  if not taListBox.HandleAllocated then
    Exit;

  if FShowTape then begin
    for I := 0 to taMaxTapeCount - 1 do begin
      S := taListBox.Items.Strings[I];
      if S <> '' then begin
        Diff := FTapeDisplaySpace - Length(S);
        if S[1] = ' ' then begin
          if Diff >= 0 then
            S := StringOfChar(' ', Diff) + S
          else if AllSame(copy(S, 1, -Diff)) then
            S := copy(S,-Diff + 1, Length(S));
        end else begin
          if AllSame(S) and (not CharInSet(S[1], ['0'..'9'])) then
            if Diff >= 0 then
              S := S + StringOfChar(S[1], Diff)
            else
              S := copy(S, 1, Length(S)-Diff + 1)
          else if (Diff >= 0) and not ((S[1] <> '0') or (S[2] <> '.')) then
            S :=  StringOfChar(' ', Diff) + S;
        end;
        taListBox.Items.Strings[I] := S;
      end;
    end;
    taListBox.TopIndex := taMaxTapeCount - GetDisplayedItemCount + 2;
  end;
end;

procedure TOvcCalcTape.SpaceTape(const Value : char);
var
  TapeString : string;
begin
  TapeString := StringOfChar(Value, FTapeDisplaySpace);
  Add(TapeString);
  DeleteFirst;
  TopIndex := taMaxTapeCount - GetDisplayedItemCount + 2;
end;


{*** TOvcCustomCalculatorEngine ***}

procedure TOvcCustomCalculatorEngine.ClearAll;
var
  I : Integer;
begin
  for I := 0 to 3 do
    cOperands[I] := 0;
  cLastOperation := coNone;
  cOperationCount := 0;
  cState := [csValid, csClear];
end;

procedure TOvcCustomCalculatorEngine.PushOperand(const Value : Extended);
var
  I : Integer;
begin
  for I := 2 downto 0 do
    cOperands[I+1] := cOperands[I];
  cOperands[0] := Value;
end;

function TOvcCustomCalculatorEngine.PopOperand : Extended;
var
  I : Integer;
begin
  Result := cOperands[0];
  for I := 0 to 2 do
    cOperands[I] := cOperands[I+1];
  cOperands[3] := 0;
end;

function TOvcCustomCalculatorEngine.TopOperand : Extended;
begin
  Result := cOperands[0];
end;


{*** TOvcBasicCalculatorEngine ***}
type
  TOvcBasicCalculatorEngine = class(TOvcCustomCalculatorEngine)
  protected {private}
    {internal methods}
    procedure cEvaluate(const Operation : TOvcCalculatorOperation);
  public
    function AddOperand(const Value : Extended; const Button : TOvcCalculatorOperation) : Boolean;
        override;
    function AddOperation(const Button : TOvcCalculatorOperation) : Boolean;
        override;
  end;

function TOvcBasicCalculatorEngine.AddOperand(
  const Value : Extended;
  const Button : TOvcCalculatorOperation) : Boolean;
var
  I : Integer;
begin
  Result := False;
  if Button <> coNone then begin
    if csValid in cState then begin
      Result := True;
      for I := 2 downto 0 do
        cOperands[I+1] := cOperands[I];
      cOperands[0] := Value;
    end;
  end;
end;

procedure TOvcBasicCalculatorEngine.cEvaluate(const Operation : TOvcCalculatorOperation);
begin
  if csValid in cState then begin
    {evaluate the expression}
    case Operation of
      coAdd        : begin
                       cOperands[1] := cOperands[1] + cOperands[0];
                       PopOperand;
                     end;
      coSub        : begin
                       cOperands[1] := cOperands[1] - cOperands[0];
                       PopOperand;
                     end;
      coMul        : begin
                       cOperands[1] := cOperands[1] * cOperands[0];
                       PopOperand;
                     end;
      coDiv        : begin
                       cOperands[1] := cOperands[1] / cOperands[0];
                       PopOperand;
                     end;
      coEqual      : ;
      coNone       : ;
      coPercent    : begin
                       if cLastOperation in [coAdd, coSub] then
                         cOperands[0] := (cOperands[0] / 100) * cOperands[1]  {do markup/down}
                       else
                         cOperands[0] := cOperands[0] / 100; {as a percentage}
                       cState := [csValid, csClear];
                     end;
      coMemStore   : begin
                       cMemory := cOperands[0];
                       Include(cState, csClear);
                     end;
      coMemRecall  : begin
                       cOperands[0] := cMemory;
                       cState := [csValid, csClear];
                     end;
      coMemClear   : begin
                       cMemory := 0;
                     end;
      coMemAdd,
      coMemSub     : begin
                       try
                         if Operation = coMemAdd then
                           cMemory := cMemory + cOperands[0]
                         else
                           cMemory := cMemory - cOperands[0];
                       except
                         cMemory := 0;
                       end;
                       Include(cState, csClear);
                     end;
      coInvert     : begin
                       cOperands[0] := 1 / cOperands[0];
                     end;
      coSqrt       : begin
                       cOperands[0] := Sqrt(cOperands[0]);
                     end;
    end;
  end;
end;

function TOvcBasicCalculatorEngine.AddOperation(const Button : TOvcCalculatorOperation) : Boolean;
begin
  Result := False;
  if csValid in cState then begin
    {evaluate the expression}
    case Button of
      coAdd        : begin
                       cEvaluate(cLastOperation);
                       cState := [csValid, csClear];
                       if cLastOperation in [coAdd, coSub] then
                         Inc(cOperationCount)
                       else
                         cOperationCount := 1;
                       cLastOperation := Button;
                       Result := True;
                     end;
      coSub        : begin
                       cEvaluate(cLastOperation);
                       cState := [csValid, csClear];
                       if cLastOperation in [coAdd, coSub] then
                         Inc(cOperationCount)
                       else
                         cOperationCount := 1;
                       cLastOperation := Button;
                       Result := True;
                     end;
      coMul        : begin
                       cEvaluate(cLastOperation);
                       cState := [csValid, csClear];
                       if cLastOperation = Button then
                         cOperationCount := cOperationCount + 1
                       else
                         cOperationCount := 1;
                       cLastOperation := Button;
                       Result := True;
                     end;
      coDiv        : begin
                       cEvaluate(cLastOperation);
                       cState := [csValid, csClear];
                       if cLastOperation = Button then
                         cOperationCount := cOperationCount + 1
                       else
                         cOperationCount := 1;
                       cLastOperation := Button;
                       Result := True;
                     end;
      coEqual      : begin
                       Include(cState, csClear);
                       if cLastOperation <> coNone then begin
                         cEvaluate(cLastOperation);
                         cState := [csClear, csValid];
                         if cLastOperation = coEqual then
                           cLastOperation := coNone
                         else
                           cLastOperation := Button;
                       end;
                       Result := True;
                     end;
      coNone       : Result := True;
      coPercent    : begin
                       cEvaluate(Button);
                       if not ShowSeparatePercent then begin
                         cEvaluate(cLastOperation);
                         cState := [csValid, csClear];
                         if cLastOperation = Button then
                           cOperationCount := cOperationCount + 1
                         else
                           cOperationCount := 0;
                         cLastOperation := coEqual;
                         Result := True;
                       end else begin
                         if cLastOperation = Button then
                           cOperationCount := cOperationCount + 1
                         else
                           cOperationCount := 0;
                         Result := True;
                       end;
                     end;
      coMemStore   : begin
                       cEvaluate(Button);
                     end;
      coMemRecall  : begin
                       cEvaluate(Button);
                       Result := True;
                     end;
      coMemClear   : begin
                       cEvaluate(Button);
                     end;
      coMemAdd,
      coMemSub     : begin
                       cEvaluate(Button);
                     end;
      coInvert     : begin
                       cEvaluate(Button);
                       Result := True;
                     end;
      coSqrt       : begin
                       cEvaluate(Button);
                       Result := True;
                     end;
    end;
  end;
end;


{*** TOvcCalcPanel ***}

procedure TOvcCalcPanel.Click;
begin
  (Owner as TOvcCustomCalculator).SetFocus;
end;


{*** TOvcCustomCalculator ***}

procedure TOvcCustomCalculator.cAdjustHeight;
var
  DC         : hDC;
  SaveFont   : hFont;
  I          : Integer;
  SysMetrics : TTextMetric;
  Metrics    : TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  if NewStyleControls then begin
    if Ctl3D then
      I := 8
    else
      I := 6;
    I := GetSystemMetrics(SM_CYBORDER) * I;
  end else begin
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then
      I := Metrics.tmHeight;
    I := I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;
  cPanel.Height := Metrics.tmHeight + I;
end;

procedure TOvcCustomCalculator.cCalculateLook;
var
  CW  : Integer;  {client width}
  BW  : Integer;  {button width}
  BH  : Integer;  {button height}
  LBW : Integer;  {large button width}
  M1  : Integer;  {margin between buttons}
  M2  : Integer;  {left and right edge margins}
  M3  : Integer;  {margin between panel and frst row of buttons}
  M4  : Integer;  {margin between memory buttons and other buttons}
  TM  : Integer;  {area where the panel is placed}
  X   : Integer;
  Y   : Integer;
  PW  : Integer;  {panel width}
  B   : TOvcCalculatorButton;
begin
  if not HandleAllocated then
    Exit;

  {set panel height based on font}
  cAdjustHeight;

  for B := Low(cButtons) to High(cButtons) do
    cButtons[B].Visible := True;

  CW := ClientWidth;

  if Width <= 200 then begin
    M1 := 2;
    M2 := 4;
  end else begin
    M1 := 4;
    M2 := 6;
  end;
  {save left/right/top/bottom margin value}
  cMargin := M2;

  M4 := M2;
  if coShowMemoryButtons in FOptions then begin
    BW := (CW - 3*M2 - 4*M1) div 6;
    M4 := CW - 2*M2 - 6*BW - 4*M1;
  end else begin
    BW := (CW - 2*M2 - 4*M1) div 5;
    if (CW - 2*M2 - 4*M1) div 6 >= 4 then
      Inc(M2, 2)
    else if (CW - 2*M2 - 4*M1) div 6 >= 2 then
      Inc(M2, 1);
  end;

  {button height, using an estimate for TM}
  TM := M2 + M2 + cPanel.Height;

  if coShowTape in FOptions then
    TM := TM + M2 + cTape.Height;

  BH := (ClientHeight - TM - M2 - 4*M1) div 5;

  {calculate actual area below panel}
  M3 := ClientHeight - M2 - cPanel.Height - 5*BH - 4*M1 - M2;

  {calculate actual height of area above buttons}
  TM := M2 + M3 + cPanel.Height;

  {large button width}
  if coShowClearTapeButton in FOptions then
    LBW := (5*BW + 3*M1 - 2*M1) div 4
  else
    LBW := (4*BW + 3*M1 - 2*M1) div 3;

  {calculate the width of the edit window}
  cMargin := M2;
  if coShowMemoryButtons in FOptions then
    PW := 6*BW + M4 + 4*M1
  else
    PW := 5*BW + 4*M1;

  if coShowTape in FOptions then
    PW := PW - cScrBarWidth;


  {position tape display and edit panel}
  if coShowTape in FOptions then begin
    cTape.Visible := True;
    cTape.SetBounds(cMargin, cMargin, PW + cScrBarWidth, cTape.Height);
    cPanel.SetBounds(cMargin + 2, cTape.Height + M2 +
                     cMargin, PW, cPanel.Height);
  end else begin
    cTape.Visible := False;
    cPanel.SetBounds(cMargin, cMargin, PW, cPanel.Height);
  end;

  {calculate # of characters required to fill display space}
  {"FontWidth div 2" makes sure there is no cut off charaters}
  if coShowTape in FOptions then
    cTape.TapeDisplaySpace := (cTape.Width - cScrBarWidth - (cGetFontWidth div 2))
                      div cGetFontWidth
  else
    cTape.TapeDisplaySpace := (cPanel.Width - (cGetFontWidth div 2)) div cGetFontWidth;

  cTape.InitializeTape;

  {redraw the edit panel and Tape}
  cRefreshDisplays;

  {memory column}
  if coShowMemoryButtons in FOptions then begin
    X := M2;
    Y := TM;
    cButtons[cbMemClear].Position := Rect(X, Y, X+BW, Y+BH);
    cButtons[cbMemClear].Caption := GetOrphStr(SCCalcMC);

    Y := TM + BH + M1;
    cButtons[cbMemRecall].Position := Rect(X, Y, X+BW, Y+BH);
    cButtons[cbMemRecall].Caption := GetOrphStr(SCCalcMR);

    Y := TM + 2*BH + 2*M1;
    cButtons[cbMemStore].Position := Rect(X, Y, X+BW, Y+BH);
    cButtons[cbMemStore].Caption := GetOrphStr(SCCalcMS);

    Y := TM + 3*BH + 3*M1;
    cButtons[cbMemAdd].Position := Rect(X, Y, X+BW, Y+BH);
    cButtons[cbMemAdd].Caption := GetOrphStr(SCCalcMPlus);

    Y := TM + 4*BH + 4*M1;
    cButtons[cbMemSub].Position := Rect(X, Y, X+BW, Y+BH);
    cButtons[cbMemSub].Caption := GetOrphStr(SCCalcMMinus);
  end else
    for B := cbMemClear to cbMemSub do
      cButtons[B].Visible := False;

  {row 1 - large buttons}
  Y := TM;
  if coShowMemoryButtons in FOptions then
    if coShowClearTapeButton in FOptions then
      X := BW + M2 + M4
    else
      X := 2*BW + M4 + M2 + M1
  else
    if coShowClearTapeButton in FOptions then
      X := M2
    else
      X := BW + M2 + M1;

  cButtons[cbTape].Position := Rect(X, Y, X+LBW, Y+BH);
  cButtons[cbTape].Caption := GetOrphStr(SCCalcCT);

  if coShowClearTapeButton in FOptions then begin
    cButtons[cbTape].Visible := True;
    Inc(X, LBW+M1);
    if ((BW+M1)*5 - (LBW+M1)*4) >= 3 then
      Inc(X, 1);
  end else begin
    cButtons[cbTape].Visible := False;
  end;

  cButtons[cbBack].Position := Rect(X, Y, X+LBW, Y+BH);
  cButtons[cbBack].Caption := GetOrphStr(SCCalcBack);

  Inc(X, LBW+M1);
  if coShowClearTapeButton in FOptions then begin
    if ((BW+M1)*5 - (LBW+M1)*4) >= 2 then
      Inc(X, 1);
  end else begin
    if ((BW+M1)*4 - (LBW+M1)*3) >= 2 then
      Inc(X, 1);
  end;
  cButtons[cbClearEntry].Position := Rect(X, Y, X+LBW, Y+BH);
  cButtons[cbClearEntry].Caption := GetOrphStr(SCCalcCE);

  Inc(X, LBW+M1);
  if coShowClearTapeButton in FOptions then begin
    if ((BW+M1)*5 - (LBW+M1)*4) >= 1 then
      Inc(X, 1);
  end else begin
    if ((BW+M1)*4 - (LBW+M1)*3) >= 1 then
      Inc(X, 1);
  end;
  cButtons[cbClear].Position := Rect(X, Y, X+LBW, Y+BH);
  cButtons[cbClear].Caption := GetOrphStr(SCCalcC);

  {row 2}
  Y := TM + BH + M1;
  if coShowMemoryButtons in FOptions then
    X := M2 + BW + M4
  else
    X := M2;
  cButtons[cb7].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb7].Caption := '7';

  Inc(X, BW+M1);
  cButtons[cb8].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb8].Caption := '8';

  Inc(X, BW+M1);
  cButtons[cb9].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb9].Caption := '9';

  Inc(X, BW+M1);
  cButtons[cbDiv].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbDiv].Caption := '/';

  Inc(X, BW+M1);
  cButtons[cbSqrt].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbSqrt].Caption := GetOrphStr(SCCalcSqrt);

  {row 3}
  Y := TM + 2*BH + 2*M1;
  if coShowMemoryButtons in FOptions then
    X := M2 + BW + M4
  else
    X := M2;
  cButtons[cb4].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb4].Caption := '4';

  Inc(X, BW+M1);
  cButtons[cb5].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb5].Caption := '5';

  Inc(X, BW+M1);
  cButtons[cb6].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb6].Caption := '6';

  Inc(X, BW+M1);
  cButtons[cbMul].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbMul].Caption := '*';

  Inc(X, BW+M1);
  cButtons[cbPercent].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbPercent].Caption := '%';

  {row 4}
  Y := TM + 3*BH + 3*M1;
  if coShowMemoryButtons in FOptions then
    X := M2 + BW + M4
  else
    X := M2;
  cButtons[cb1].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb1].Caption := '1';

  Inc(X, BW+M1);
  cButtons[cb2].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb2].Caption := '2';

  Inc(X, BW+M1);
  cButtons[cb3].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb3].Caption := '3';

  Inc(X, BW+M1);
  cButtons[cbSub].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbSub].Caption := '-';

  Inc(X, BW+M1);
  cButtons[cbInvert].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbInvert].Caption := '1/x';

  {row 5}
  Y := TM + 4*BH + 4*M1;
  if coShowMemoryButtons in FOptions then
    X := M2 + BW + M4
  else
    X := M2;
  cButtons[cb0].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cb0].Caption := '0';

  Inc(X, BW+M1);
  cButtons[cbChangeSign].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbChangeSign].Caption := '+/-';

  Inc(X, BW+M1);
  cButtons[cbDecimal].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbDecimal].Caption := FormatSettings.DecimalSeparator;

  Inc(X, BW+M1);
  cButtons[cbAdd].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbAdd].Caption := '+';

  Inc(X, BW+M1);
  cButtons[cbEqual].Position := Rect(X, Y, X+BW, Y+BH);
  cButtons[cbEqual].Caption := '=';
end;

procedure TOvcCustomCalculator.cClearAll;
begin
  if not HandleAllocated then
    Exit;

  cEngine.ClearAll;
  FLastOperand := 0;
  DisplayValue := 0;
  FDisplayStr := '0';
  cMinus0 := False;
  cTape.InitializeTape;
  cPanel.Caption := StringOfChar(' ',
                       (cTape.TapeDisplaySpace
                        - Length('0')
                        - Length(CalcDisplayString[cbNone]))
                       ) + '0' + '  ';
end;

procedure TOvcCustomCalculator.cColorChange(Sender : TObject);
begin
  {update panel background color}
  if Assigned(cPanel) then begin
    cPanel.Color := FColors.Display;
    cPanel.Font.Color := FColors.DisplayTextColor;
    {update the main font color}
    if not (csLoading in ComponentState) and (Font <> nil) then
      Font.Color := FColors.DisplayTextColor;
  end;

  if Assigned(cTape) then begin
    cTape.TapeColor := FColors.Display;
  end;

  Invalidate;
end;

procedure TOvcCustomCalculator.cDisplayError;
begin
  cSetDisplayString('****** ');
  cEngine.State := [csLocked]; {user will have to clear this}
  MessageBeep(0);
end;

procedure TOvcCustomCalculator.cDrawCalcButton(const Button : TOvcButtonInfo; const Pressed, MouseOver : Boolean);

  Procedure cDrawCalcButton_NoTheme;  // PM 05-NOV-2015 old non themed draw routine
  var
    TR  : TRect;
    Buf : array[0..255] of Char;
  begin
    if Button.Visible then begin
      TR := DrawButtonFace(Canvas, Button.Position, 1, bsNew, False, Pressed, False);
      StrPLCopy(Buf, Button.Caption, 255);
      DrawText(Canvas.Handle, Buf, StrLen(Buf), TR,
               DT_CENTER or DT_VCENTER or DT_SINGLELINE);

      if Focused and (Button.Caption = '=') then
        cDrawFocusState;
    end;
  end;

  Procedure cDrawCalcButton_Themed;  // PM 05-NOV-2015 new themed draw routine
  var
    lDetails: TThemedElementDetails;
    lRect: TRect;

  begin
    if not Button.Visible then
      exit;

    if Pressed then
    begin
      lDetails := StyleServices.GetElementDetails(tbPushButtonPressed);
    end
    else if MouseOver then
    begin
      lDetails := StyleServices.GetElementDetails(tbPushButtonHot);
    end
    else if Focused and (Button.Caption = '=')  then
    begin
      lDetails := StyleServices.GetElementDetails(tbPushButtonDefaulted);
    end
    else
      lDetails := StyleServices.GetElementDetails(tbPushButtonNormal);

    StyleServices.DrawElement(Canvas.Handle, lDetails, Button.Position);
    lRect := Button.Position;
    StyleServices.DrawText(Canvas.Handle, lDetails, Button.Caption, lRect, [tfCenter, tfVerticalCenter, tfSingleLine], Canvas.Font.Color);
  end;

begin
  if StyleServices.Enabled then
    cDrawCalcButton_Themed      // PM 05-NOV-2015 if theming is enabled, draw themed
  else
    cDrawCalcButton_NoTheme;    // PM 05-NOV-2015 else use the hold routine
end;


procedure TOvcCustomCalculator.cDrawFocusState;
var
  R : TRect;
begin
  R := cButtons[cbEqual].Position;
  InflateRect(R, -3, -3);
  Canvas.DrawFocusRect(R);
end;

procedure TOvcCustomCalculator.cDrawSizeLine;
var
  OldPen : TPen;
begin
  if (cSizing) then
    with Canvas do begin
      OldPen := TPen.Create;
      try
        OldPen.Assign(Pen);
        Pen.Color := clBlack;
        Pen.Mode := pmXor;
        Pen.Style := psDot;
        Pen.Width := 1;
        MoveTo(0, cSizeOffset);
        LineTo(ClientWidth, cSizeOffset);
      finally
        Canvas.Pen := OldPen;
        OldPen.Free;
      end;
    end;
end;

procedure TOvcCustomCalculator.cEvaluate(const Button : TOvcCalculatorButton);
begin
  if csValid in cEngine.State then begin
    try
      {evaluate the expression}
      if cEngine.AddOperation(CalcButtontoOperation[Button]) then begin
        DisplayValue := cEngine.TopOperand;
        if Button in [cbAdd, cbSub, cbMul, cbDiv, cbEqual, cbPercent, cbNone] then
          if (Button in [cbAdd, cbSub, cbMul, cbDiv]) and (cLastButton = Button) then
            cTape.AddToTape(cFormatString(LastOperand), CalcDisplayString[Button])
          else
            cTape.AddToTape(FDisplayStr, CalcDisplayString[Button]);
        if (Button = cbEqual) and (cEngine.LastOperation = coEqual) then begin
          if coShowItemCount in FOptions then
            cTape.AddToTapeLeft(Format('%3.3d',[cEngine.OperationCount+1]));
          cTape.AddToTape(cFormatString(DisplayValue), CalcDisplayString[cbSubTotal]);
          cTape.SpaceTape(TapeSeparatorChar);
        end;
        FDisplayStr := cFormatString(DisplayValue);
      end;
    except
      cDisplayError;
    end;
  end;
end;

function TOvcCustomCalculator.cFormatString(const Value : Extended) : string;
begin
  if cEngine.Decimals = 0 then
    Result := Format('%g',[Value])
  else if cEngine.Decimals < 0 then
    Result := Format('%.*f',[-cEngine.Decimals, Value])
  else
    Result := Format('%.*f',[cEngine.Decimals, Value]);
end;

function TOvcCustomCalculator.cGetFontWidth : Integer;
var
  DC         : hDC;
  SaveFont   : hFont;
  Size       : TSize;
begin
  if not assigned(cPanel) then begin
    Result := 8; {Return something resonable }
    Exit;
  end;
  DC := GetDC(0);
  SaveFont := SelectObject(DC, cPanel.Font.Handle);
  GetTextExtentPoint32(DC, ' 0123456789', 11, Size);
  Result := Round(Size.cx/11);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

procedure TOvcCustomCalculator.cInvalidateIndicator;
begin
  InvalidateRect(Handle, @cButtons[cbMemRecall].Position, False);
  InvalidateRect(Handle, @cButtons[cbMemClear].Position, False);
end;

procedure TOvcCustomCalculator.cRefreshDisplays;
begin
  if not cPanel.HandleAllocated then
    Exit;

  cTape.RefreshDisplays;
  DisplayValue := DisplayValue; // PM 08-11-2015 uncommented, because it is needed to refresh display. e.g. on horisontal resize
end;

procedure TOvcCustomCalculator.cSetDisplayString(const Value : string);
var
  DSpace : Integer;
begin
  try
    if cPanel.HandleAllocated then begin
      DSpace := cTape.TapeDisplaySpace
              - Length(Value)
              - Length(CalcDisplayString[cbNone]);
      cPanel.Caption := StringOfChar(' ', DSpace) + Value + '  ';
    end;
  except
    cDisplayError;
  end;
end;

procedure TOvcCustomCalculator.cTapeFontChange(Sender : TObject);
begin
  cPanel.Font := TapeFont;
end;

procedure TOvcCustomCalculator.SetBorderStyle(const Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

function TOvcCustomCalculator.GetDecimals : Integer;
begin
  Result := cEngine.Decimals;
end;

procedure TOvcCustomCalculator.SetDecimals(const Value : Integer);
begin
  if Value <> cEngine.Decimals then begin
    cEngine.Decimals := Value;
    ccalculateLook;
    Invalidate;
  end;
end;

function TOvcCustomCalculator.GetMemory : Extended;
begin
  Result := cEngine.Memory;
end;

procedure TOvcCustomCalculator.SetMemory(const Value : Extended);
begin
  if Value <> cEngine.Memory then begin
    cEngine.Memory := Value;
    cCalculateLook;
    Invalidate;
  end;
end;

procedure TOvcCustomCalculator.SetMaxPaperCount(const Value : Integer);
begin
  if Value <> cTape.MaxPaperCount then begin
    cTape.MaxPaperCount := Value;
    Invalidate;
  end;
end;

function TOvcCustomCalculator.GetMaxPaperCount : Integer;
begin
  Result := cTape.MaxPaperCount;
end;

procedure TOvcCustomCalculator.SetOptions(const Value : TOvcCalculatorOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;


    cTape.ShowTape := coShowTape in FOptions;
    cTape.Visible := coShowTape in FOptions;
    cEngine.ShowSeparatePercent := coShowSeparatePercent in FOptions;

    cCalculateLook;
    Invalidate;
  end;
end;

function TOvcCustomCalculator.GetTape : TStrings;
begin
  Result := cTape.Tape;
end;

procedure TOvcCustomCalculator.SetTape(const Value : TStrings);
begin
  cTape.Tape := Value;
end;

function TOvcCustomCalculator.GetTapeFont : TFont;
begin
  Result := cTape.Font;
end;

procedure TOvcCustomCalculator.SetTapeFont(const Value : TFont);
begin
  cTape.Font := Value;
end;

function TOvcCustomCalculator.GetTapeHeight : Integer;
begin
  Result := cTape.Height;
end;

procedure TOvcCustomCalculator.SetTapeHeight(const Value : Integer);
begin
  cTape.Height := Value;
  cCalculateLook;
  Invalidate;
end;

function TOvcCustomCalculator.GetVisible : Boolean;
begin
  Result := inherited Visible;
end;

procedure TOvcCustomCalculator.SetVisible(const Value : Boolean);
begin
  inherited Visible := Value;

  cTape.Visible := cTape.ShowTape;
end;

procedure TOvcCustomCalculator.SetDisplay(const Value : Extended);
var
  ValueString : string;
begin
  try
    FDisplay := Value;
    if cPanel.HandleAllocated then begin
      ValueString := cFormatString(Value);
      cSetDisplayString(ValueString);
    end;
  except
    cDisplayError;
  end;
end;

procedure TOvcCustomCalculator.SetDisplayStr(const Value : string);
begin
  FDisplayStr := Value;
  while (Length(FDisplayStr) > 0) and (FDisplayStr[1] = ' ') do
    FDisplayStr := Copy(FDisplayStr, 2, Length(FDisplayStr) - 1);
end;

function TOvcCustomCalculator.GetOperand : Extended;
begin
  Result := cEngine.TopOperand;
end;

procedure TOvcCustomCalculator.SetOperand(const Value : Extended);
begin
  if Value = cEngine.TopOperand then
    Exit;
  cEngine.PushOperand(Value);
end;

procedure TOvcCustomCalculator.CMCtl3DChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  Invalidate;
end;

procedure TOvcCustomCalculator.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  Msg.Result := Integer(cOverBar);
end;

procedure TOvcCustomCalculator.CMEnter(var Msg : TMessage);
var
  R : TRect;
begin
  inherited;

  {invalidate the "=" button to ensure that the focus rect is painted}
  R := cButtons[cbEqual].Position;
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomCalculator.CMExit(var Msg : TMessage);
var
  R : TRect;
begin
  inherited;

  {invalidate the "=" button to ensure that the focus rect is painted}
  R := cButtons[cbEqual].Position;
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomCalculator.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if not (csLoading in ComponentState) and Assigned(cPanel) then begin
    cPanel.Color := FColors.Display;
    cPanel.Font.Color := FColors.DisplayTextColor;
    FColors.FCalcColors[2] := Font.Color;
  end;

  cCalculateLook;
  Invalidate;
end;

procedure TOvcCustomCalculator.WMEraseBkgnd(var Msg : TWMEraseBkgnd);
begin
  Msg.Result := 1;   {don't erase background, just say we did}
end;

procedure TOvcCustomCalculator.WMGetText(var Msg : TWMGetText);
begin
  if not cPanel.HandleAllocated then
    Exit;

  Msg.Result := SendMessage(cPanel.Handle, WM_GETTEXT,
    TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

procedure TOvcCustomCalculator.WMGetTextLength(var Msg : TWMGetTextLength);
begin
  if not cPanel.HandleAllocated then
    Exit;

  Msg.Result := SendMessage(cPanel.Handle, WM_GETTEXTLENGTH,
    TMessage(Msg).wParam, TMessage(Msg).lParam);
end;

procedure TOvcCustomCalculator.WMKeyDown(var Msg : TWMKeyDown);
begin
  if Msg.CharCode = Ord('M') then begin
    if (GetAsyncKeyState(VK_CONTROL) and $8000) <> 0 then begin
      PressButton(cbMemStore);
    end;
  end else if Msg.CharCode = VK_RETURN then
    PressButton(cbEqual);

  inherited;
end;

procedure TOvcCustomCalculator.WMSetText(var Msg : TWMSetText);
var
  I : Integer;
  C : Char;
begin
  cClearAll;
  for I := 0 to Pred(StrLen(Msg.Text)) do begin
    C := Msg.Text[I];
    KeyPress(C);
  end;
  Msg.Result := 1{true};
end;

procedure TOvcCustomCalculator.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  inherited;

  cHitTest.X := Msg.Pos.X;
  cHitTest.Y := Msg.Pos.Y;
end;

procedure TOvcCustomCalculator.WMSetCursor(var Msg : TWMSetCursor);
var
  vHitTest : TPoint;

  procedure SetNewCursor(C : HCursor);
  begin
    SetCursor(C);
    Msg.Result := Ord(True);
  end;

begin
//  if not (coShowTape in FOptions) then
//    Exit;
//  if csDesigning in ComponentState then begin
  if (coShowTape in FOptions) and (csDesigning in ComponentState) then begin // else cursor is only updated if showtape is enabled
    if (Msg.HitTest = HTCLIENT) then begin
      cOverBar := False;
      vHitTest := ScreenToClient(cHitTest);
      if vHitTest.Y > cTape.Top + cTape.Height then
        if vHitTest.Y < cTape.Top + cTape.Height+4 then
          cOverBar := True;
    end;

    {set appropriate cursor}
    if cOverBar then
      SetNewCursor(cTabCursor)
    else
      inherited;
  end else
    inherited;
end;

procedure TOvcCustomCalculator.WMCancelMode(var Msg : TMessage);
begin
  inherited;

  cSizing := False;
end;

procedure TOvcCustomCalculator.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  Invalidate;
end;

procedure TOvcCustomCalculator.WMLButtonDown(var Msg : TWMMouse);
begin
  inherited;

  {are we currently showing a sizing cursor? if so the user wants to
   resize a column/row}
  if (cOverBar) then begin
    cSizeOffset := Msg.YPos;
    cSizing := True;
    cDrawSizeLine;
  end;
end;

procedure TOvcCustomCalculator.WMLButtonUp(var Msg : TWMMouse);
var
  Form : TForm;
begin
  inherited;

  if (cSizing) then begin
    cDrawSizeLine;
    cSizing := False;
    cTape.Height := cSizeOffset - 8;
    cCalculateLook;

    Refresh;
    if (csDesigning in ComponentState) then begin
      Form := TForm(GetParentForm(Self));
      if (Form <> nil) and (Form.Designer <> nil) then
        Form.Designer.Modified;
    end;
  end;
end;

procedure TOvcCustomCalculator.WMMouseMove(var Msg : TWMMouse);

var
  B     : TOvcCalculatorButton;  // PM 07-11-2015
  mEvnt : TTrackMouseEvent;      // PM 07-11-2015
begin
  inherited;

  if (cSizing) then begin
    cDrawSizeLine;
    if Msg.YPos >= calcDefMinSize + cTape.Top then
      if Msg.YPos <= Height - calcDefMinSize then
        cSizeOffset := Msg.YPos + 2
      else
        cSizeOffset := Height - calcDefMinSize
    else
      cSizeOffset := calcDefMinSize + cTape.Top;
    cDrawSizeLine;
  end;

  // PM 07-NOV-2015 logic to check i mouse is hovering a button, used for theming
  if not cMouseTracking then  // to trigger an MouseLeave notifikation
  begin
    mEvnt.cbSize := SizeOf(mEvnt);
    mEvnt.dwFlags := TME_LEAVE;
    mEvnt.hwndTrack := Handle;
    TrackMouseEvent(mEvnt);
    cMouseTracking := True;
  end;

  if not PtInRect(cButtons[cMouseOverButton].Position, Point(Msg.XPos,Msg.YPos)) then
  begin
    InvalidateRect(Handle, @cButtons[cMouseOverButton].Position, False);
    cMouseOverButton := cbNone;
    for B := Low(cButtons) to High(cButtons) do
    begin
      if cButtons[B].Visible and PtInRect(cButtons[B].Position, Point(Msg.XPos,Msg.YPos)) then
      begin
        cMouseOverButton := B;
        InvalidateRect(Handle, @cButtons[cMouseOverButton].Position, False);
        Break;
      end;
    end;
  end;
  Msg.Result := 0;
end;


// PM 07-NOV-2015 make sure to disable hot tracking
procedure TOvcCustomCalculator.WMMouseLeave(var Msg : TWMMouse);
begin
  inherited;

  if not (cMouseOverButton = cbNone) then
  begin
    InvalidateRect(Handle, @cButtons[cMouseOverButton].Position, False);
    cMouseOverButton := cbNone;
  end;
  cMouseTracking  := false;
  Msg.Result      := 0;
end;



procedure TOvcCustomCalculator.CopyToClipboard;
begin
  Clipboard.AsText := Text;
end;

constructor TOvcCustomCalculator.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if cPopup then
    ControlStyle           := ControlStyle + [csClickEvents, csFramed] - [csCaptureMouse]
  else
    ControlStyle           := ControlStyle + [csClickEvents, csFramed, csCaptureMouse];

  Color                    := clBtnFace;
  TabStop                  := True;
  Width                    := 200;
  Font.Name                := 'Default';
  Font.Size                := 8;
  Font.Style               := [];
  cDecimalEntered          := False;
  cSizing                  := False;
  cScrBarWidth             := 18;

  {create edit control}
  cPanel                   := TOvcCalcPanel.Create(Self);
  cPanel.Parent            := Self;
  cPanel.ParentFont        := False;
  cPanel.Font.Name         := 'Courier New';
  cPanel.Font.Size         := 10;
  cPanel.Font.Style        := [];
  cPanel.ParentCtl3D       := True;
  cPanel.Alignment         := taLeftJustify;
  cPanel.BevelOuter        := bvLowered;
  cPanel.BorderStyle       := bsNone;
  cPanel.Color             := clWindow;
  cPanel.BevelWidth        := 2;
  cPanel.Caption           := '0 ';

  {set property defaults}
  FBorderStyle             := bsNone;
  Height                   := 140;
  FTapeSeparatorChar       := '_';
  FOptions                 := [coShowMemoryButtons, coShowItemCount];
  FColors                  := TOvcCalcColors.Create;
  FColors.OnChange         := cColorChange;

  {assign default color scheme}
  FColors.FCalcColors      := CalcScheme[cscalcWindows];

  {create tape}
  cTape := TOvcCalcTape.Create(Self, Length(CalcDisplayString[cbNone]));
  cTape.ShowTape           := False;
  cTape.TapeColor          := clWindow;
  cTape.MaxPaperCount      := 9999;
  TapeHeight               := Height div 3;
  TapeFont.OnChange        := cTapeFontChange;
  TapeFont.Name            := 'Courier New';
  TapeFont.Size            := 10;
  TapeFont.Style           := [];
  cTape.Visible            := cTape.ShowTape;

  cEngine := TOvcBasicCalculatorEngine.Create;
  cEngine.Decimals         := 2;
  cEngine.ShowSeparatePercent := False;

  if csDesigning in ComponentState then
    cTabCursor := Screen.Cursors[crVSplit];

  cMouseOverButton := cbNone; // PM 07-NOV-2015 For mouse over theme styling
  cMouseTracking   := false;
end;

constructor TOvcCustomCalculator.CreateEx(AOwner : TComponent; AsPopup : Boolean);
begin
  cPopup := AsPopup;
  Create(AOwner);
end;

procedure TOvcCustomCalculator.CreateParams(var Params : TCreateParams);
const
  BorderStyles : array[TBorderStyle] of Integer = (0, WS_BORDER);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Integer(Style) or BorderStyles[FBorderStyle];
    if cPopup then begin
      Style := WS_POPUP or WS_BORDER;
      WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    end;
  end;

  if NewStyleControls and (Ctl3D or cPopup) and (FBorderStyle = bsSingle) then begin
    if not cPopup then
      Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

procedure TOvcCustomCalculator.CreateWnd;
begin
  inherited CreateWnd;

  if Ctl3D then begin              //SZ moved to here from Paint
    cPanel.BevelOuter := bvLowered;
    cPanel.BorderStyle := bsNone;
  end else begin
    cPanel.BevelOuter := bvNone;
    cPanel.BorderStyle := bsSingle;
  end;

  cCalculateLook;
  cClearAll;

  cPanel.Color := FColors.Display;
end;

destructor TOvcCustomCalculator.Destroy;
begin
  cTape.Free;
  cTape := nil;

  cEngine.Free;
  cEngine := nil;

  FColors.Free;
  FColors := nil;

  cTabCursor := 0;

  inherited Destroy;
end;

procedure TOvcCustomCalculator.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  case Key of
    VK_DELETE : if Shift = [] then
                  PressButton(cbClearEntry);
    VK_F9     : if Shift = [] then
                  PressButton(cbChangeSign);
  end;
end;

procedure TOvcCustomCalculator.KeyPress(var Key : Char);
begin
  inherited KeyPress(Key);

  case Key of
    '0' : PressButton(cb0);
    '1' : PressButton(cb1);
    '2' : PressButton(cb2);
    '3' : PressButton(cb3);
    '4' : PressButton(cb4);
    '5' : PressButton(cb5);
    '6' : PressButton(cb6);
    '7' : PressButton(cb7);
    '8' : PressButton(cb8);
    '9' : PressButton(cb9);

    '+' : PressButton(cbAdd);
    '-' : PressButton(cbSub);
    '*' : PressButton(cbMul);
    '/' : PressButton(cbDiv);

    '.' : PressButton(cbDecimal);
    '=' : PressButton(cbEqual);
    'r' : PressButton(cbInvert);
    '%' : PressButton(cbPercent);
    '@' : PressButton(cbSqrt);

    ^L  : PressButton(cbMemClear);  {^L}
    ^R  : PressButton(cbMemRecall); {^R}
    ^P  : PressButton(cbMemAdd);    {^P}
    ^S  : PressButton(cbMemSub);    {^S}
    ^T  : PressButton(cbTape);      {^T}

    ^C  : CopyToClipboard;          {^C}{copy}
    ^V  : PasteFromClipboard;       {^V}{paste}

    #8  : PressButton(cbBack);      {backspace}
    #27 : PressButton(cbClear);     {esc}
  else
    if Key = FormatSettings.DecimalSeparator then
      PressButton(cbDecimal);
  end;
end;

procedure TOvcCustomCalculator.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  B : TOvcCalculatorButton;
begin
  SetFocus;

  if Button = mbLeft then begin
    cDownButton := cbNone;
    for B := Low(cButtons) to High(cButtons) do
      if cButtons[B].Visible and PtInRect(cButtons[B].Position, Point(X,Y)) then begin
        if (B in [cbMemClear, cbMemRecall]) and (cEngine.Memory = 0) then
          Exit;
        cDownButton := B;
        InvalidateRect(Handle, @cButtons[cDownButton].Position, False);
        Break;
      end;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TOvcCustomCalculator.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if cDownButton = cbNone then
    Exit;

  InvalidateRect(Handle, @cButtons[cDownButton].Position, False);

  {if still over the button...}
  if PtInRect(cButtons[cDownButton].Position, Point(X,Y)) then
    PressButton(cDownButton);

  cDownButton := cbNone;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TOvcCustomCalculator.PasteFromClipboard;
var
  I : Integer;
  C : Char;
  S : string;
begin
  S := Clipboard.AsText;
  if S > '' then begin
    cClearAll;
    for I := 1 to Length(S) do begin
      C := S[I];
      if CharInSet(C, ['0'..'9', FormatSettings.DecimalSeparator, '.', '+', '-', '*', '/', '=', '%']) then
        KeyPress(C);
    end;
  end;
end;

procedure TOvcCustomCalculator.PressButton(Button : TOvcCalculatorButton);

  procedure Initialize;
  begin
    if (cLastButton <> cbClear) and (Button = cbClear) then begin
      cClearAll;
      cTape.SpaceTape(TapeSeparatorChar);
    end;

    if (csLocked in cEngine.State) then begin
      MessageBeep(0);
      Exit;
    end;

    {this logic is here to make cbEqual clear all the second time}
    if (cLastButton in [cbEqual, cbClear, cbNone]) and (Button = cbEqual) then begin
      Button := cbClear;
      cClearAll;
    end;

    if (cLastButton = cbPercent) and (Button in [cbAdd, cbSub, cbMul, cbDiv, cbEqual]) then
      cEvaluate(Button)
    else if ((((cLastButton in [cbEqual{, cbMemRecall}]) and
               (Button in [cbAdd, cbSub, cbMul, cbDiv])))) and
             cEngine.AddOperand(StrToFloat(FDisplayStr), CalcButtontoOperation[Button]) then begin
      cEvaluate(Button);
    end else if (Button = cbMemStore) then begin
      if (cLastButton <> cbEqual) then
        cEvaluate(Button);
      SetMemory(DisplayValue);
    end else if cEngine.AddOperand(LastOperand, CalcButtontoOperation[Button]) then begin
      cEvaluate(Button);

    {remove special operations from stack
     03/2011: added cmMemRecall to fix the following bug:
     "3" [MS] "10" [-] [MR] [=]  -> "-7" }
      if Button in [cbInvert, cbSqrt, cbEqual, cbMemRecall] then
        LastOperand := cEngine.PopOperand;
    end;
  end;

  procedure NumberButton;
  var
    D    : Extended;
    DP   : Integer;
  begin
    begin
      if cEngine.LastOperation = coEqual then begin
        {clear pending operations if last command was =}
        cClearAll;
      end;

      if csClear in cEngine.State then begin
        if (Decimals < 0) then begin
          FDisplayStr := '0.' + StringOfChar('0', -Decimals);
        end else begin
          FDisplayStr := '';
          cDecimalEntered := False;
        end;
      end;

      FDisplayStr := FDisplayStr + cButtons[Button].Caption[1];
      if cMinus0 then begin
        FDisplayStr := '-' + FDisplayStr;
        cMinus0 := False;
      end;

      if (Decimals < 0) and not cDecimalEntered then begin
        if Pos(FormatSettings.DecimalSeparator, FDisplayStr) > 0 then begin
          DP := Pos(FormatSettings.DecimalSeparator, FDisplayStr);
          if FDisplayStr[1] = '0' then
            FDisplayStr := Copy(FDisplayStr,2,DP-2) +
                           Copy(FDisplayStr,DP+1,1) +
                           FormatSettings.DecimalSeparator +
                           Copy(FDisplayStr,DP+2,Length(FDisplayStr) - DP)
          else
            FDisplayStr := Copy(FDisplayStr,1,DP-1) +
                           Copy(FDisplayStr,DP+1,1) +
                           FormatSettings.DecimalSeparator +
                           Copy(FDisplayStr,DP+2,Length(FDisplayStr) - DP);
        end;
      end;
      D := StrToFloat(FDisplayStr);
      LastOperand := D;
      if (D <> 0) or
         (Pos(FormatSettings.DecimalSeparator, FDisplayStr) > 0) then begin
        DisplayValue := D;
        cSetDisplayString(FDisplayStr);
        cEngine.State := [csValid];
      end else begin
        FDisplayStr := '0';
        DisplayValue := D;
        cEngine.State := [csValid, csClear];
      end;
    end;
  end;

  procedure DecimalButton;
  var
    D    : Extended;
  begin
    {check if the decimal was first character entered after a command}
    if csClear in cEngine.State then begin
      FDisplayStr := '0' + FormatSettings.DecimalSeparator;
      cSetDisplayString(FDisplayStr);
      cDecimalEntered := True;
      cEngine.State := [csValid];
    end;

    {check if there is already a decimal separator in the string}
    if Pos(FormatSettings.DecimalSeparator, FDisplayStr) = 0 then begin
      FDisplayStr := FDisplayStr + FormatSettings.DecimalSeparator;
      if (pos(FormatSettings.DecimalSeparator, FDisplayStr) = 1) then
        FDisplayStr := '0' + FDisplayStr;
      D := StrToFloat(FDisplayStr);
      cSetDisplayString(FDisplayStr);
      LastOperand := D;
      cEngine.State := [csValid];
      cDecimalEntered := True;
    end;
  end;

  procedure BackButton;
  var
    D    : Extended;
    DP   : Integer;
    SaveSign : string;
  begin
    if FDisplayStr = '' then exit;
    D := StrToFloat(FDisplayStr);
    if D <> 0 then begin
      if Length(FDisplayStr) > 1 then begin
        if (Decimals < 0) and not cDecimalEntered then begin
          if Pos(FormatSettings.DecimalSeparator, FDisplayStr) > 0 then begin
            if FDisplayStr[1] = '-' then begin
              SaveSign :='-';
              FDisplayStr := Copy(FDisplayStr,2,Length(FDisplayStr)-1);
            end else begin
              SaveSign :='';
            end;
            DP := Pos(FormatSettings.DecimalSeparator, FDisplayStr);
            FDisplayStr := '0' + Copy(FDisplayStr,1,DP-2) +
                           FormatSettings.DecimalSeparator +
                           Copy(FDisplayStr,DP-1,1) +
                           Copy(FDisplayStr,DP+1,Length(FDisplayStr) - DP);
            if (FDisplayStr[1] = '0') and (FDisplayStr[2] <> '.') then
              FDisplayStr := Copy(FDisplayStr,2,Length(FDisplayStr)-1);
            FDisplayStr := SaveSign + FDisplayStr;
          end;
        end;
        FDisplayStr := Copy(FDisplayStr, 1, Length(FDisplayStr)-1);
        LastOperand := StrToFloat(FDisplayStr);
        cSetDisplayString(FDisplayStr);
      end else begin
        LastOperand := 0;
        cMinus0 := False;
        DisplayValue := LastOperand;
        cEngine.State := [csValid, csClear];
      end;
    end;
  end;

  procedure ClearEntryButton;
  begin
    begin
      FDisplayStr := '';
      LastOperand := 0;
      cMinus0 := False;
      DisplayValue := LastOperand;
    end;
  end;

  procedure ChangeSignButton;
  begin
    if Length(FDisplayStr) > 0 then begin
      if FDisplayStr[1] <> '-' then begin
        FDisplayStr := '-' + FDisplayStr;
        LastOperand := StrToFloat(FDisplayStr);
        cSetDisplayString(FDisplayStr);
      end else begin
        FDisplayStr := Copy(FDisplayStr, 2, Length(FDisplayStr)-1);
        LastOperand := StrToFloat(FDisplayStr);
        cSetDisplayString(FDisplayStr);
      end;
      DisplayValue := LastOperand;
    end else begin
      LastOperand := 0;
      cMinus0 := not cMinus0;
      DisplayValue := LastOperand;
      if cMinus0 then
        FDisplayStr := '-';
      cEngine.State := [csValid, csClear];
    end;
  end;

  procedure ClearTapeButton;
  var
    I : Integer;
  begin
    with Tape do begin
      for I := 0 to Count - 1 do begin
        Strings[I] := '';
      end;
      cTape.RefreshDisplays;
    end;
  end;

begin
  if not HandleAllocated then
    Exit;

  {simulate a button down if needed}
  if cDownButton = cbNone then begin
    cDownButton := Button;
    InvalidateRect(Handle, @cButtons[cDownButton].Position, False);
    Update;
  end;

  try try
    Initialize;
    case Button of
      cb0..cb9     : NumberButton;
      cbDecimal    : DecimalButton;
      cbBack       : BackButton;
      cbClearEntry : ClearEntryButton;
      cbMemStore,
      cbMemClear,
      cbMemAdd,
      cbMemSub     : cInvalidateIndicator;
      cbChangeSign : ChangeSignButton;
      cbTape       : ClearTapeButton;
      cbSqrt,
      cbInvert     : {};
    end;
  except
    cDisplayError;
  end;
  finally
    {simulate a button up, if the mouse button is up or we aren't focused}
    if not Focused or (GetAsyncKeyState(GetLeftButton) and $8000 = 0) then begin
      InvalidateRect(Handle, @cButtons[cDownButton].Position, False);
      cDownButton := cbNone;
      Update;
    end;
  end;

  cLastButton := Button;
  if Assigned(FOnButtonPressed) then
    FOnButtonPressed(Self, Button);
end;

procedure TOvcCustomCalculator.PushOperand(const Value : Extended);
begin
  cEngine.PushOperand(Value);
  LastOperand := Value;
  DisplayValue := Value;
end;

procedure TOvcCustomCalculator.Paint;
var
  B       : TOvcCalculatorButton;
begin
  Canvas.Font := Font;
  if StyleServices.Enabled then                                   //PM 05-Nov-2015 if theming enabled
    Canvas.Brush.Color := StyleServices.GetSystemColor(clBtnFace) //PM 05-Nov-2015 get theming color
  else                                                            //PM 05-Nov-2015
    Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(ClientRect);

{  if Ctl3D then begin              //SZ this causes 100% CPU usage when Themes are active, moved to CreateWnd
    cPanel.BevelOuter := bvLowered;
    cPanel.BorderStyle := bsNone;
  end else begin
    cPanel.BevelOuter := bvNone;
  cPanel.BorderStyle := bsSingle;
  end; }

  {draw buttons}
  for B := Low(cButtons) to High(cButtons) do begin
    if (B in [cbMemClear, cbMemRecall, cbMemStore, cbMemAdd, cbMemSub]) then begin
      if (B in [cbMemClear, cbMemRecall]) and (cEngine.Memory = 0) then
        Canvas.Font.Color := FColors.DisabledMemoryButtons
      else
        Canvas.Font.Color := FColors.MemoryButtons;
    end else if (B in [cbBack, cbClearEntry, cbClear, cbTape]) then
      Canvas.Font.Color := FColors.EditButtons
    else if (B in [cbAdd, cbSub, cbMul, cbDiv, cbEqual]) then
      Canvas.Font.Color := FColors.OperatorButtons
    else if (B in [cb0..cb9, cbDecimal]) then
      Canvas.Font.Color := FColors.NumberButtons
    else if (B in [cbInvert, cbChangeSign, cbPercent, cbSqrt]) then
      Canvas.Font.Color := FColors.FunctionButtons;

    cDrawCalcButton(cButtons[B], (B = cDownButton), (B = cMouseOverButton));
  end;
end;

procedure TOvcCustomCalculator.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  if Height <> AHeight then
    if coShowTape in FOptions then
      if Top <> ATop then begin
        if TapeHeight + (AHeight - Height) > calcDefMinSize then begin
          TapeHeight := TapeHeight + (AHeight - Height);
        end else begin
          TapeHeight := calcDefMinSize;
        end
      end;

  inherited Setbounds(ALeft, ATop, AWidth, AHeight);

  cCalculateLook;
end;


end.

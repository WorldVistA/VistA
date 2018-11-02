{*********************************************************}
{*                  OVCEDCLC.PAS 4.06                    *}
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

unit ovcedclc;
  {-numeric edit field with popup calculator}

interface

uses
  Windows, Buttons, Classes, Controls, Forms, Graphics, Menus, Messages,
  StdCtrls, SysUtils, MultiMon, OvcBase, OvcCalc, OvcEdPop, OvcMisc;

type
  TOvcCustomNumberEdit = class(TOvcEdPopup)
  

  protected {private}
    FAllowIncDec     : Boolean;
    FCalculator      : TOvcCalculator;

    {internal variables}
    PopupClosing     : Boolean;
    HoldCursor       : TCursor;
    WasAutoScroll    : Boolean;

    {property methods}
    function GetAsFloat : Double;
    function GetAsInteger : Integer;
    function GetAsString : string;
    function GetPopupColors : TOvcCalcColors;
    function GetPopupDecimals : Integer;
    function GetPopupFont : TFont;
    function GetPopupHeight : Integer;
    function GetPopupWidth : Integer;
    function GetReadOnly : Boolean;
    procedure SetAsFloat(Value : Double);
    procedure SetAsInteger(Value : Integer);
    procedure SetAsString(const Value : string);
    procedure SetPopupColors(Value : TOvcCalcColors);
    procedure SetPopupDecimals(Value : Integer);
    procedure SetPopupFont(Value : TFont);
    procedure SetPopupHeight(Value : Integer);
    procedure SetPopupWidth(Value : Integer);
    procedure SetReadOnly(Value : Boolean);

    {internal methods}
    procedure PopupButtonPressed(Sender : TObject; Button : TOvcCalculatorButton);
    procedure PopupKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure PopupKeyPress(Sender : TObject; var Key : Char);
    procedure PopupMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);

  protected
    procedure DoExit;
      override;
    procedure GlyphChanged;
      override;
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure KeyPress(var Key : Char);
      override;


    property AllowIncDec : Boolean
      read FAllowIncDec write FAllowIncDec;
    property PopupColors : TOvcCalcColors
      read GetPopupColors write SetPopupColors;
    property PopupDecimals : Integer
      read GetPopupDecimals write SetPopupDecimals;
    property PopupFont : TFont
      read GetPopupFont write SetPopupFont;
    property PopupHeight : Integer
      read GetPopupHeight write SetPopupHeight;
    property PopupWidth : Integer
      read GetPopupWidth write SetPopupWidth;
    property ReadOnly : Boolean
      read GetReadOnly write SetReadOnly;

  public
  

    constructor Create(AOwner : TComponent);
      override;


    procedure PopupClose(Sender : TObject);
      override;
    procedure PopupOpen;
      override;

    property AsInteger : Integer
      read GetAsInteger
      write SetAsInteger;

    {public properties}
    property Calculator : TOvcCalculator
      read FCalculator;
    property AsFloat : Double
      read GetAsFloat write SetAsFloat;
    property AsString : string
      read GetAsString write SetAsString;
  end;

  TOvcNumberEdit = class(TOvcCustomNumberEdit)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AllowIncDec;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property ButtonGlyph;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property LabelInfo;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupAnchor;
    property PopupColors;
    property PopupDecimals;
    property PopupFont;
    property PopupHeight;
    property PopupWidth;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property ShowButton;
    property TabOrder;
    property TabStop;
    property Visible;

    {events}
    property OnChange;
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
    property OnPopupClose;
    property OnPopupOpen;
    property OnStartDrag;
  end;


implementation

uses
  Types, ovcstr, OvcFormatSettings;

{*** TOvcCustomNumberEdit ***}

constructor TOvcCustomNumberEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  FAllowIncDec := False;

  {load button glyph}
  FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCLC');
  FButton.Glyph.Assign(FButtonGlyph);

  FCalculator := TOvcCalculator.CreateEx(Self, True);
  FCalculator.OnButtonPressed := PopupButtonPressed;
  FCalculator.OnExit := PopupClose;
  FCalculator.OnKeyDown := PopupKeyDown;
  FCalculator.OnKeyPress := PopupKeyPress;
  FCalculator.OnMouseDown := PopupMouseDown;
  FCalculator.Visible := False; {to avoid flash at 0,0}
  FCalculator.Options := [coShowItemCount];
  FCalculator.BorderStyle := bsSingle;
  FCalculator.ParentFont   := False;
end;

procedure TOvcCustomNumberEdit.DoExit;
begin
  if not PopupActive then
    inherited DoExit;
end;

function TOvcCustomNumberEdit.GetAsFloat : Double;
var
  I : Integer;
  S : string;
begin
  S := Text;
  for I := Length(S) downto 1 do
    if not CharInSet(S[I], ['0'..'9', '+', '-', 'e', 'E', FormatSettings.DecimalSeparator]) then
      Delete(S, I, 1);
  Result := StrToFloat(S);
end;

function TOvcCustomNumberEdit.GetAsInteger : Integer;
begin
  Result := Round(GetAsFloat);
end;

function TOvcCustomNumberEdit.GetAsString : string;
begin
  Result := Text;
end;

function TOvcCustomNumberEdit.GetPopupColors : TOvcCalcColors;
begin
  Result := FCalculator.Colors;
end;

function TOvcCustomNumberEdit.GetPopupDecimals : Integer;
begin
  Result := FCalculator.Decimals;
end;

function TOvcCustomNumberEdit.GetPopupFont : TFont;
begin
  Result := FCalculator.Font;
end;

function TOvcCustomNumberEdit.GetPopupHeight : Integer;
begin
  Result := FCalculator.Height;
end;

function TOvcCustomNumberEdit.GetPopupWidth : Integer;
begin
  Result := FCalculator.Width;
end;

function TOvcCustomNumberEdit.GetReadOnly : Boolean;
begin
  Result := inherited ReadOnly;
end;

procedure TOvcCustomNumberEdit.GlyphChanged;
begin
  inherited GlyphChanged;

  if FButtonGlyph.Empty then
    FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCLC');
end;

procedure TOvcCustomNumberEdit.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if (Key = VK_DOWN) and (ssAlt in Shift) then
    PopupOpen;
end;

procedure TOvcCustomNumberEdit.KeyPress(var Key : Char);
var
  D : Double;
  X : Integer;
  L : Integer;
begin
  inherited KeyPress(Key);

  if not ((Key = #22) or (Key = #3) or (Key = #24)) then begin
    if not CharInSet(Key, [#27, '0'..'9', '.', FormatSettings.DecimalSeparator,
                    #8, '+', '-', '*', '/']) then begin
      Key := #0;
      MessageBeep(0);
      Exit;
    end;

    {Disallow more than one DecimalSeparator in the number}
    if (SelLength <> Length(Text))
    and (Key = FormatSettings.DecimalSeparator) and (Pos(FormatSettings.DecimalSeparator, Text) > 0)
    then begin
      Key := #0;
      MessageBeep(0);
      Exit;
    end;

    if FAllowIncDec and CharInSet(Key, ['+', '-']) then begin
      if Text = '' then
        Text := '0';
      D := StrToFloat(Text);
      X := SelStart;
      L := SelLength;

      if Key = '+' then
        Text := FloatToStr(D+1)
      else {'-'}
        Text := FloatToStr(D-1);

      SelStart := X;
      SelLength := L;

      Key := #0; {clear key}
    end;

    if CharInSet(Key, ['+', '*', '/']) then begin
      PopUpOpen;
      FCalculator.KeyPress(Key);
      Key := #0; {clear key}
    end;
  end;
end;

procedure TOvcCustomNumberEdit.PopupButtonPressed(Sender : TObject;
          Button : TOvcCalculatorButton);
begin
  case Button of
    cbEqual :
      begin
        {get the current value}
        Text := FloatToStr(FCalculator.DisplayValue);
        Modified := True;

        {hide the calculator}
        PopupClose(Sender);
        SetFocus;
        SelStart := Length(Text);
        SelLength := 0;
      end;
  end;
end;

procedure TOvcCustomNumberEdit.PopupClose(Sender : TObject);
begin
  if not FCalculator.Visible then
    Exit; {already closed, exit}

  if PopupClosing then
    Exit;

  PopupClosing := True; {avoid recursion}
  try
    inherited PopupClose(Sender);

    if GetCapture = FCalculator.Handle then
      ReleaseCapture;

    SetFocus;
    FCalculator.Hide;  {hide the calculator}
    TForm(FCalculator.Parent).AutoScroll := WasAutoScroll;
    Cursor := HoldCursor;

    {change parentage so that we control the window handle destruction}
    FCalculator.Parent := Self;
  finally
    PopupClosing := False;
  end;
end;

procedure TOvcCustomNumberEdit.PopupKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
var
  X : Integer;
begin
  case Key of

    VK_TAB :
      begin
        if Shift = [ssShift] then begin
          PopupClose(Sender);
          PostMessage(Handle, WM_KeyDown, VK_TAB, Integer(ssShift));
        end else if Shift = [] then begin
          PopupClose(Sender);
          PostMessage(Handle, WM_KeyDown, VK_TAB, 0);
        end;
      end;


    VK_UP : if Shift = [ssAlt] then begin
              PopupClose(Sender);
              X := SelStart;
              SetFocus;
              SelStart := X;
              SelLength := 0;
            end;
  end;
end;

procedure TOvcCustomNumberEdit.PopupKeyPress(Sender : TObject; var Key : Char);
var
  X : Integer;
begin
  case Key of
    #27 :
      begin
        PopupClose(Sender);
        X := SelStart;
        SetFocus;
        SelStart := X;
        SelLength := 0;
      end;
  end;
end;

procedure TOvcCustomNumberEdit.PopupMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
  I : Integer;
begin
  P := Point(X,Y);
  if not PtInRect(FCalculator.ClientRect, P) then
    PopUpClose(Sender);

  {convert to our coordinate system}
  P := ScreenToClient(FCalculator.ClientToScreen(P));

  if PtInRect(ClientRect, P) then begin
    I := SelStart;
    SetFocus;
    SelStart := I;
    SelLength := 0;
  end;
end;

procedure TOvcCustomNumberEdit.PopupOpen;
var
  P       : TPoint;
  R       : TRect;
  F       : TCustomForm;
  MonInfo : TMonitorInfo;
begin
  if FCalculator.Visible then
    Exit;  {already popped up, exit}

  inherited PopupOpen;

  FCalculator.Parent := GetImmediateParentForm(Self);
  if FCalculator.Parent is TForm then begin
    WasAutoScroll := TForm(FCalculator.Parent).AutoScroll;
    TForm(FCalculator.Parent).AutoScroll := False;
  end;

  {set 3d to be the same as our own}
  FCalculator.ParentCtl3D := False;
  FCalculator.Ctl3D := False;

  {determine the proper position}
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  F := GetParentForm(Self);
  if Assigned(F) then begin
    FillChar(MonInfo, SizeOf(MonInfo), #0);
    MonInfo.cbSize := SizeOf(MonInfo);
    GetMonitorInfo(F.Monitor.Handle, @MonInfo);
    R := MonInfo.rcWork;
  end;
  if FPopupAnchor = paLeft then
    P := ClientToScreen(Point(-3, Height-4))
  else {paRight}
    P := ClientToScreen(Point(Width-FCalculator.Width-1, Height-2));
  if not Ctl3D then begin
    Inc(P.X, 3);
    Inc(P.Y, 3);
  end;
  if P.Y + FCalculator.Height >= R.Bottom then
    P.Y := P.Y - FCalculator.Height - Height;
  if P.X + FCalculator.Width >= R.Right then
    P.X := R.Right - FCalculator.Width - 1;
  if P.X <= R.Left then
    P.X := R.Left + 1;

  MoveWindow(FCalculator.Handle, P.X, P.Y, FCalculator.Width, FCalculator.Height, False);

  HoldCursor := Cursor;
  Cursor := crArrow;
  FCalculator.PressButton(cbClear);
  FCalculator.Show;
  FCalculator.Visible := True;
  if Text <> '' then
    FCalculator.PushOperand(AsFloat)
  else
    FCalculator.PushOperand(0);
  FCalculator.SetFocus;

  SetCapture(FCalculator.Handle);
end;

procedure TOvcCustomNumberEdit.SetAsFloat(Value : Double);
begin
  Text := FloatToStr(Value);
end;

procedure TOvcCustomNumberEdit.SetAsInteger(Value : Integer);
begin
  Text := IntToStr(Value);
end;

procedure TOvcCustomNumberEdit.SetAsString(const Value : string);
begin
  Text := Value;
end;

procedure TOvcCustomNumberEdit.SetPopupColors(Value : TOvcCalcColors);
begin
  FCalculator.Colors := Value;
end;

procedure TOvcCustomNumberEdit.SetPopupDecimals(Value : Integer);
begin
  FCalculator.Decimals := Value;
end;

procedure TOvcCustomNumberEdit.SetPopupFont(Value : TFont);
begin
  if Assigned(Value) then
    FCalculator.Font.Assign(Value);
end;

procedure TOvcCustomNumberEdit.SetPopupHeight(Value : Integer);
begin
  FCalculator.Height := Value;
end;

procedure TOvcCustomNumberEdit.SetPopupWidth(Value : Integer);
begin
  FCalculator.Width := Value;
end;

procedure TOvcCustomNumberEdit.SetReadOnly(Value : Boolean);
begin
  inherited ReadOnly := Value;

  FButton.Enabled := not ReadOnly;
end;

end.

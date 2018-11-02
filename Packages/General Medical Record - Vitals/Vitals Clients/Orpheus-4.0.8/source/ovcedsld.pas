{*********************************************************}
{*                  OVCEDSLD.PAS 4.06                    *}
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

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcedsld;
  {-numeric edit field with popup slider control}

interface

uses
  Types, Windows, Buttons, Classes, Controls, Forms, Graphics, Menus, Messages,
  StdCtrls, SysUtils, OvcBase, OvcConst, OvcData, OvcEdPop, OvcMisc, OvcSlide,
  OvcExcpt,imm;

type
  TOvcCustomSliderEdit = class(TOvcEdPopup)
  

  protected {private}
    FAllowIncDec     : Boolean;
    FSlider          : TOvcSlider;
    FValidate        : Boolean;

    {internal variables}
    PopupClosing     : Boolean;
    HoldCursor       : TCursor;
    WasAutoScroll    : Boolean;

    {property methods}
    function GetAsFloat : Double;
    function GetAsInteger : Integer;
    function GetAsString : string;
    function GetPopupDrawMarks : Boolean;
    function GetPopupHeight : Integer;
    function GetPopupMax : Double;
    function GetPopupMin : Double;
    function GetPopupStep : Double;
    function GetPopupWidth : Integer;
    function GetReadOnly : Boolean;
    procedure SetAsFloat(const Value : Double);
    procedure SetAsInteger(Value : Integer);
    procedure SetAsString(const Value : string);
    procedure SetPopupDrawMarks(Value : Boolean);
    procedure SetPopupHeight(Value : Integer);
    procedure SetPopupMax(const Value : Double);
    procedure SetPopupMin(const Value : Double);
    procedure SetPopupStep(const Value : Double);
    procedure SetPopupWidth(Value : Integer);
    procedure SetReadOnly(Value : Boolean);

    {internal methods}
    procedure PopupChange(Sender : TObject);
    procedure PopupKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
    procedure PopupKeyPress(Sender : TObject; var Key : Char);
    procedure PopupMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);

    {VCL message methods}
    procedure CMExit(var Message : TCMExit);
      message CM_EXIT;

    {windows message methods}
    procedure WMLButtonDown(var Msg : TWMLButtonDown);
      message WM_LBUTTONDOWN;

    procedure WMImeComposition(var Msg: TMessage); message WM_IME_COMPOSITION;
  protected
    procedure DoExit;
      override;
    procedure GlyphChanged;
      override;
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure KeyPress(var Key : Char);
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;


    property AllowIncDec : Boolean
      read FAllowIncDec write FAllowIncDec;
    property PopupHeight : Integer
      read GetPopupHeight write SetPopupHeight;
    property PopupDrawMarks : Boolean
      read GetPopupDrawMarks write SetPopupDrawMarks;
    property PopupMax : Double
      read GetPopupMax write SetPopupMax;
    property PopupMin : Double
      read GetPopupMin write SetPopupMin;
    property PopupStep : Double
      read GetPopupStep write SetPopupStep;
    property PopupWidth : Integer
      read GetPopupWidth write SetPopupWidth;
    property Validate : Boolean
      read FValidate write FValidate;
    

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
      read GetAsInteger write SetAsInteger;
    property AsFloat : Double
      read GetAsFloat write SetAsFloat;
    property AsString : string
      read GetAsString write SetAsString;
    property Slider : TOvcSlider
      read FSlider;
  end;

  TOvcSliderEdit = class(TOvcCustomSliderEdit)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AllowIncDec default False;
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
    property PopupAnchor default paLeft;
    property PopupDrawMarks default True;
    property PopupHeight default 20;
    property PopupMax;
    property PopupMenu;
    property PopupMin;
    property PopupStep;
    property PopupWidth default 121;
    property ReadOnly default False;
    property ShowButton default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Validate default False;
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
    property OnStartDrag;
  end;

implementation

uses
  OVCStr, OvcFormatSettings;

{*** TOvcCustomSliderEdit ***}


//clc as in numeric field - ovcnf
procedure TOvcCustomSliderEdit.WMImeComposition(var Msg: TMessage);
var IMEContext: HIMC;
    p: WideString;
    FImeCount: integer;
//var AString:String;
begin
  if ImeMode <> imDisable then
  if (Msg.LParam and GCS_RESULTSTR) <> 0 then//Retrieve or update the string of the composition result.
  begin
    IMEContext := ImmGetContext(Handle);
    try
      FImeCount := ImmGetCompositionStringW(IMEContext, GCS_RESULTSTR, nil, 0) div 2;
      if FImeCount > 0 then
       begin
        SetLength(p, FImeCount);
        ImmGetCompositionStringW(IMEContext, GCS_RESULTSTR, PWideChar(p), FImeCount*2);
        //this does cancel the IME input and Orpheus components gets their input from else where...
        //just throw input away

        //     procedure efEdit(var Msg : TMessage; Cmd : Word); PastePrim(Pchar(p[1]));//p[Counter]
        (*if ANSIString(p) <> p then
        begin
          AString := StrPas(efEditSt);
          Insert(p, AString,efHPos+1);
          StrPCopy(efEditSt,AString);
          inc(efHPos,Length(p));
        end;*)
       end;
    finally
      ImmReleaseContext(Handle, IMEContext);
    end;
  end;
  inherited;
end;

procedure TOvcCustomSliderEdit.CMExit(var Message : TCMExit);
begin
  if Modified then begin
    try
      GetAsFloat;
    except
      SetFocus;
      raise
    end;
  end;

  inherited;
end;

constructor TOvcCustomSliderEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  FAllowIncDec := False;

  {load button glyph}
  FButtonGlyph.Handle := LoadBaseBitmap('ORBTNSLD');
  FButton.Glyph.Assign(FButtonGlyph);

  FSlider := TOvcSlider.CreateEx(Self, True);
  FSlider.OnExit := PopupClose;
  FSlider.OnKeyDown := PopupKeyDown;
  FSlider.OnKeyPress := PopupKeyPress;
  FSlider.OnMouseDown := PopupMouseDown;
  FSlider.OnChange := PopupChange;
  FSlider.Visible := False; {to avoid flash at 0,0}
  FSlider.BorderStyle := bsSingle;
  FSlider.Width := Width;
  //clc prevents ImeEditor from opening
   ImeMode := imClose;
end;

procedure TOvcCustomSliderEdit.DoExit;
begin
  if not PopupActive then
    inherited DoExit;
end;

function TOvcCustomSliderEdit.GetAsFloat : Double;
var
  I : Integer;
  S : string;
begin
  S := Text;
  for I := Length(S) downto 1 do
    if not CharInSet(S[I], ['0'..'9', '+', '-', FormatSettings.DecimalSeparator]) then
      Delete(S, I, 1);
  Result := StrToFloat(S);
  if FValidate and ((Result < FSlider.Min) or (Result > FSlider.Max)) then begin
    S := ^M'[' + FloatToStr(FSlider.Min) + ', ' + FloatToStr(FSlider.Max) + ']';
    raise EOvcException.Create(GetOrphStr(SCRangeError)+S);
  end;
end;

function TOvcCustomSliderEdit.GetAsInteger : Integer;
begin
  Result := Round(GetAsFloat);
end;

function TOvcCustomSliderEdit.GetAsString : string;
begin
  Result := FloatToStr(GetAsFloat);
end;

function TOvcCustomSliderEdit.GetPopupDrawMarks : Boolean;
begin
  Result := FSlider.DrawMarks;
end;

function TOvcCustomSliderEdit.GetPopupHeight : Integer;
begin
  Result := FSlider.Height;
end;

function TOvcCustomSliderEdit.GetPopupMax : Double;
begin
  Result := FSlider.Max;
end;

function TOvcCustomSliderEdit.GetPopupMin : Double;
begin
  Result := FSlider.Min;
end;

function TOvcCustomSliderEdit.GetPopupStep : Double;
begin
  Result := FSlider.Step;
end;

function TOvcCustomSliderEdit.GetPopupWidth : Integer;
begin
  Result := FSlider.Width;
end;

function TOvcCustomSliderEdit.GetReadOnly : Boolean;
begin
  Result := inherited ReadOnly;
end;

procedure TOvcCustomSliderEdit.GlyphChanged;
begin
  inherited GlyphChanged;

  if FButtonGlyph.Empty then
    FButtonGlyph.Handle := LoadBaseBitmap('ORBTNSLD');
end;

procedure TOvcCustomSliderEdit.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if (Key = VK_DOWN) and (ssAlt in Shift) then
    PopupOpen;
end;

procedure TOvcCustomSliderEdit.KeyPress(var Key : Char);
var
  D : Double;
  X : Integer;
  L : Integer;
begin
  inherited KeyPress(Key);

  if not CharInSet(Key, [#27, '0'..'9', '.', FormatSettings.DecimalSeparator, #8, '+', '-', '*', '/']) then begin
    Key := #0;
    MessageBeep(0);
    Exit;
  end;

  if FAllowIncDec  and CharInSet(Key, ['+', '-']) then begin
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
end;

procedure TOvcCustomSliderEdit.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if not FSlider.Visible then
    inherited MouseDown(Button,  Shift, X, Y)
  else
    PopupMouseDown(Self, Button,  Shift, X, Y);
end;

procedure TOvcCustomSliderEdit.MouseMove(Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
begin
  if not FSlider.Visible then
    inherited MouseMove(Shift, X, Y)
  else begin
    {convert to slider coords}
    P := FSlider.ScreenToClient(ClientToScreen(Point(X, Y)));
    FSlider.MouseMove(Shift, P.X, P.Y);
    MouseCapture := True;
  end;
end;

procedure TOvcCustomSliderEdit.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
begin
  if not FSlider.Visible then
    inherited MouseUp(Button,  Shift, X, Y)
  else begin
    {convert to slider coords}
    P := FSlider.ScreenToClient(ClientToScreen(Point(X, Y)));
    FSlider.MouseUp(Button,  Shift, P.X, P.Y);
    MouseCapture := True;
  end;
end;

procedure TOvcCustomSliderEdit.PopupChange(Sender : TObject);
begin
  Text := FloatToStr(FSlider.Position);
  Modified := True;
end;

procedure TOvcCustomSliderEdit.PopupClose(Sender : TObject);
begin
  if not FSlider.Visible then
    Exit; {already closed, exit}

  if PopupClosing then
    Exit;

  PopupClosing := True; {avoid recursion}
  try
    inherited PopupClose(Sender);

    if GetCapture = FSlider.Handle then
      ReleaseCapture;

    SetFocus;
    FSlider.Hide;
    if (FSlider.Parent is TCustomForm) then
      TForm(FSlider.Parent).AutoScroll := WasAutoScroll
    else if (FSlider.Parent is TCustomFrame) then
      TFrame(FSlider.Parent).AutoScroll := WasAutoScroll;
    Cursor := HoldCursor;

    {change parentage so that we control the window handle destruction}
    FSlider.Parent := Self;
  finally
    PopupClosing := False;
  end;

  MouseCapture := False;
end;

procedure TOvcCustomSliderEdit.PopupKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
var
  X : Integer;
begin
  case Key of
    VK_UP : if Shift = [ssAlt] then begin
              PopupClose(Sender);
              X := SelStart;
              SetFocus;
              SelStart := X;
              SelLength := 0;
            end;
  end;
end;

procedure TOvcCustomSliderEdit.PopupKeyPress(Sender : TObject; var Key : Char);
var
  X : Integer;
begin
  case Key of
    #27, #13 :
      begin
        PopupClose(Sender);
        X := SelStart;
        SetFocus;
        SelStart := X;
        SelLength := 0;
      end;
  end;
end;

procedure TOvcCustomSliderEdit.PopupMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
begin
  P := FSlider.ScreenToClient(ClientToScreen(Point(X, Y)));
  if not PtInRect(FSlider.ClientRect, P) then
    PopUpClose(Sender)
  else
    FSlider.MouseDown(Button, Shift, P.X, P.Y);
end;

procedure TOvcCustomSliderEdit.PopupOpen;
var
  P : TPoint;
  R : TRect;
  F : TCustomForm;
begin
  if FSlider.Visible then
    Exit;  {already popped up, exit}

  inherited PopupOpen;

  FSlider.Parent := GetImmediateParentForm(Self);
  if (FSlider.Parent is TForm) then
    WasAutoScroll := TForm(FSlider.Parent).AutoScroll
  else if (FSlider.Parent is TCustomFrame) then
    WasAutoScroll := TFrame(FSlider.Parent).AutoScroll;

  {set 3d to be the same as our own}
  FSlider.ParentCtl3D := False;
  FSlider.Ctl3D := Ctl3D;

  {determine the proper position}
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);    //http://www.vbaccelerator.com/home/Vb/Tips/Working_with_Multiple_Monitors/article.asp
  F := GetParentForm(Self);
  if Assigned(F) then
    R := Rect(F.Monitor.Left, F.Monitor.Top,
//              F.Monitor.Width-F.Monitor.Left,
  //            F.Monitor.Height-F.Monitor.Top);
  //clc corrected...they have been aware of dual monitor problem just wrong medicine - now it works!!!
               F.Monitor.Width+F.Monitor.Left,
               F.Monitor.Height+F.Monitor.Top);



  if FPopupAnchor = paLeft then
    P := ClientToScreen(Point(-3, Height-4))
  else {paRight}
    P := ClientToScreen(Point(Width-FSlider.Width-1, Height-2));
  if not Ctl3D then begin
    Inc(P.X, 3);
    Inc(P.Y, 3);
  end;
  if P.Y + FSlider.Height >= R.Bottom then
    P.Y := P.Y - FSlider.Height - Height;
  if P.X + FSlider.Width >= R.Right then
    P.X := R.Right - FSlider.Width - 1;
  if P.X <= R.Left then
    P.X := R.Left + 1;

  MoveWindow(FSlider.Handle, P.X, P.Y, FSlider.Width, FSlider.Height, False);

  HoldCursor := Cursor;
  Cursor := crArrow;
  FSlider.Show;
  FSlider.Visible := True;

  {initialize slider position}
  if Text > '' then
    try
      FSlider.Position := StrToFloat(Text)
    except
      {ignore error and set to minimum}
      FSlider.Position := Fslider.Min;
    end
  else
    FSlider.Position := Fslider.Min;

  MouseCapture := True;

  FSlider.BringToFront;
  FSlider.SetFocus;
end;

procedure TOvcCustomSliderEdit.SetAsFloat(const Value : Double);
begin
  Text := FloatToStr(Value);
end;

procedure TOvcCustomSliderEdit.SetAsInteger(Value : Integer);
begin
  Text := IntToStr(Value);
end;

procedure TOvcCustomSliderEdit.SetAsString(const Value : string);
begin
  Text := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupDrawMarks(Value : Boolean);
begin
  FSlider.DrawMarks := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupHeight(Value : Integer);
begin
  FSlider.Height := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupMax(const Value : Double);
begin
  FSlider.Max := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupMin(const Value : Double);
begin
  FSlider.Min := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupStep(const Value : Double);
begin
  FSlider.Step := Value;
end;

procedure TOvcCustomSliderEdit.SetPopupWidth(Value : Integer);
begin
  FSlider.Width := Value;
end;

procedure TOvcCustomSliderEdit.SetReadOnly(Value : Boolean);
begin
  inherited ReadOnly := Value;

  FButton.Enabled := not ReadOnly;
end;

procedure TOvcCustomSliderEdit.WMLButtonDown(var Msg : TWMLButtonDown);
begin
  if MouseCapture then begin
    MouseDown(mbLeft, [], Msg.XPos, MSg.YPos);
  end else
    inherited;
end;


end.


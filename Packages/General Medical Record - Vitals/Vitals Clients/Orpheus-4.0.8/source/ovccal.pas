{*********************************************************}
{*                    OVCCAL.PAS 4.06                    *}
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

unit ovccal;
  {-Calendar component}

interface

uses
  Types, Windows, Buttons, Classes, Controls, Forms, Graphics, Menus, Messages,
  SysUtils, OvcBase, OvcConst, OvcData, OvcIntl, OvcMisc, OvcDate;

type
  TOvcDateFormat   = (dfShort, dfLong);
  TOvcDayNameWidth = 1..3;
  TOvcDayType = (dtSunday, dtMonday, dtTuesday, dtWednesday,
                dtThursday, dtFriday, dtSaturday);
  TOvcCalDisplayOption = (cdoShortNames, cdoShowYear, cdoShowInactive,
                         cdoShowRevert, cdoShowToday, cdoShowNavBtns,
                         cdoHideActive);
  TOvcCalDisplayOptions = set of TOvcCalDisplayOption;

type
  TOvcCalColorArray = array[0..5] of TColor;
  TOvcCalColorScheme = (cscalCustom, cscalClassic, cscalWindows,
                       cscalGold, cscalOcean, cscalRose);
  TOvcCalSchemeArray = array[TOvcCalColorScheme] of TOvcCalColorArray;

const
  {ActiveDay, DayNames, Days, InactiveDays, MonthAndYear, Weekend}
  CalScheme : TOvcCalSchemeArray =
    ((0, 0, 0, 0, 0, 0),
     (clHighlight, clWindow, clWindow,  clWindow, clWindow, clWindow),
     (clRed,       clMaroon, clBlack,   clGray,   clBlue,   clRed),
     (clBlack,     clBlack,  clYellow,  clGray,   clBlack,  clTeal),
     (clBlack,     clBlack,  clAqua,    clGray,   clBlack,  clNavy),
     (clRed,       clRed,    clFuchsia, clGray,   clBlue,   clTeal)
    );

type
  TOvcCalColors = class(TPersistent)

  protected {private}
    {property variables}
    FUpdating     : Boolean;
    FOnChange     : TNotifyEvent;

    {internal variables}
    SettingScheme : Boolean;

    {property methods}
    function GetColor(Index : Integer) : TColor;
    procedure SetColor(Index : Integer; Value : TColor);
    procedure SetColorScheme(Value : TOvcCalColorScheme);

    {internal methods}
    procedure DoOnChange;

  public
    {public property variables}
    FCalColors    : TOvcCalColorArray;
    FColorScheme  : TOvcCalColorScheme;

    procedure Assign(Source : TPersistent);
      override;
    procedure BeginUpdate;
    procedure EndUpdate;

    property OnChange : TNotifyEvent
      read  FOnChange write FOnChange;

  published
    property ActiveDay : TColor index 0
      read  GetColor write SetColor;
    property ColorScheme : TOvcCalColorScheme
      read  FColorScheme write SetColorScheme;
    property DayNames : TColor index 1
      read  GetColor write SetColor;
    property Days : TColor index 2
      read  GetColor write SetColor;
    property InactiveDays : TColor index 3
      read  GetColor write SetColor;
    property MonthAndYear : TColor index 4
      read  GetColor write SetColor;
    property Weekend : TColor index 5
      read  GetColor write SetColor;
  end;

type
  TDateChangeEvent = procedure(Sender : TObject; Date : TDateTime)
    of object;
  TCalendarDateEvent =
    procedure(Sender : TObject; ADate : TDateTime; const Rect : TRect)
    of object;
  TGetHighlightEvent =
    procedure(Sender : TObject; ADate : TDateTime; var Color : TColor)
    of object;
  TGetDateEnabledEvent =
    procedure(Sender : TObject; ADate : TDateTime; var Enabled : Boolean)
    of object;


  TOvcCustomCalendar = class(TOvcCustomControl)

  protected {private}
    {property variables}
    FBorderStyle     : TBorderStyle;
    FBrowsing        : Boolean;
    FColors          : TOvcCalColors;
    FOptions         : TOvcCalDisplayOptions;
    FDate            : TDateTime;
    FDay             : Integer;     {calendar day}
    FDateFormat      : TOvcDateFormat;
    FDayNameWidth    : TOvcDayNameWidth;
    FDrawHeader      : Boolean;     {true to draw day name header}
    FIntlSup         : TOvcIntlSup; {international date/time support}
    FMonth           : Integer;     {calendar month}
    FReadOnly        : Boolean;     {true if in read only mode}
    FWantDblClicks   : Boolean;      {true to include cs_dblclks style}
    FWeekStarts      : TOvcDayType; {the day that begins the week}
    FYear            : Integer;     {calendar year}

    {event variables}
    FOnChange        : TDateChangeEvent;
    FOnDrawDate      : TCalendarDateEvent;
    FOnDrawItem      : TCalendarDateEvent;
    FOnGetDateEnabled: TGetDateEnabledEvent;
    FOnGetHighlight  : TGetHighlightEvent;

    {internal variables}
    clBtnLeft        : TSpeedButton;
    clBtnRevert      : TSpeedButton;
    clBtnRight       : TSpeedButton;
    clBtnToday       : TSpeedButton;
    clInPopup        : Boolean;
    clBtnNextYear    : TSpeedButton;
    clBtnPrevYear    : TSpeedButton;
    clCalendar       : array[1..49] of Byte;     {current month grid}
    clDay            : Word;
    clFirst          : Byte;            {index for first day in current month}
    clLast           : Byte;            {index for last day in current month}
    clMonth          : Word;
    clRowCol         : array[0..8, 0..6] of TRect;  {cell TRect info}
    cSettingScheme   : Boolean;
    clYear           : Word;
    clWidth          : Integer;          {client width - margins}
    clMask           : array[0..MaxDateLen] of Char; {default date mask}
    clPopup          : Boolean;          {true if being created as a popup}
    clRevertDate     : TDateTime;        {date on entry}
    clRowCount       : Integer;          {7 if no header, otherwise 8}
    clStartRow       : Integer;          {first row number}

    {property methods}
    function GetAsDateTime : TDateTime;
    function GetAsStDate : TStDate;
    function GetCalendarDate : TDateTime;
    function GetDay : Integer;
    function GetMonth : Integer;
    function GetYear : Integer;
    procedure SetAsDateTime(Value : TDateTime);
    procedure SetAsStDate(Value : TStDate);
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure SetDate(Value : TDateTime);
    procedure SetDateFormat(Value : TOvcDateFormat);
    procedure SetDayNameWidth(Value : TOvcDayNameWidth);
    procedure SetDisplayOptions(Value : TOvcCalDisplayOptions);
    procedure SetDrawHeader(Value : Boolean);
    procedure SetIntlSupport(Value : TOvcIntlSup);
    procedure SetWantDblClicks(Value : Boolean);
    procedure SetWeekStarts(Value : TOvcDayType);

    {internal methods}
    procedure calChangeMonth(Sender : TObject);
    procedure calColorChange(Sender : TObject);
    function calGetCurrentRectangle : TRect;
      {-get bounding rectangle for the current calendar day}
    function calGetValidDate(ADate : TDateTime; Delta : Integer) : TDateTime;
    procedure calRebuildCalArray;
      {-recalculate the contents of the calendar array}
    procedure calRecalcSize;
      {-calcualte new sizes for rows and columns}

    {VCL control methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMEnter(var Msg : TMessage);
      message CM_ENTER;
    procedure CMExit(var Msg : TMessage);
      message CM_EXIT;
    procedure CMFontChanged(var Msg : TMessage);
      message CM_FONTCHANGED;

    {windows message methods}
    procedure WMEraseBkgnd(var Msg : TWMEraseBkgnd);
      message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    procedure WMKillFocus(var Msg : TWMKillFocus);
      message WM_KILLFOCUS;

  protected
    procedure calBtnClick(Sender : TObject);
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DoOnChange(Value : TDateTime);
      dynamic;
    function DoOnGetDateEnabled(ADate : TDateTime) : Boolean;
      dynamic;
    procedure DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
      override;
    function IsReadOnly : Boolean;
      dynamic;
      {-return true if the calendar is in read-only mode}
    procedure KeyDown(var Key : Word; Shift : TShiftState);
      override;
    procedure KeyPress(var Key : Char);
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Paint;
      override;

    {virtual property methods}
    procedure SetCalendarDate(Value : TDateTime);
      virtual;

  public
    constructor Create(AOwner : TComponent);
      override;
    constructor CreateEx(AOwner : TComponent; AsPopup : Boolean);
      virtual;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;


    function DateString(const Mask : string): string;
    function DayString : string;
    procedure IncDay(Delta : Integer);
    procedure IncMonth(Delta : Integer);
    procedure IncYear(Delta : Integer);
    function MonthString : string;
    procedure SetToday;

    property AsDateTime : TDateTime
      read GetAsDateTime write SetAsDateTime;
    property AsStDate : TStDate
      read GetAsStDate write SetAsStDate;
    property Browsing : Boolean
      read FBrowsing;
    property Canvas;
    property Day : Integer
      read GetDay;
    property Month : Integer
      read GetMonth;
    property Year : Integer
      read GetYear;

    {properties}
    property BorderStyle : TBorderStyle
      read  FBorderStyle write SetBorderStyle;
    property CalendarDate : TDateTime
      read  GetCalendarDate write SetCalendarDate;
    property Colors : TOvcCalColors
      read  FColors write FColors;
    property Date : TDateTime
      read  FDate write SetDate;
    property DateFormat : TOvcDateFormat
      read  FDateFormat write SetDateFormat;
    property DayNameWidth : TOvcDayNameWidth
      read  FDayNameWidth write SetDayNameWidth;
    property DrawHeader : Boolean
      read  FDrawHeader write SetDrawHeader;
    property IntlSupport : TOvcIntlSup
      read  FIntlSup write SetIntlSupport;
    property Options : TOvcCalDisplayOptions
      read  FOptions write SetDisplayOptions;
    property ReadOnly : Boolean
      read  FReadOnly write FReadOnly;
    property WantDblClicks : Boolean
      read FWantDblClicks write SetWantDblClicks;
    property WeekStarts : TOvcDayType
      read  FWeekStarts write SetWeekStarts;

    {events}
    property OnChange : TDateChangeEvent
      read  FOnChange write FOnChange;
    property OnDrawDate : TCalendarDateEvent
      read  FOnDrawDate write FOnDrawDate;
    property OnDrawItem : TCalendarDateEvent
      read  FOnDrawItem write FOnDrawItem;
    property OnGetDateEnabled : TGetDateEnabledEvent
      read  FOnGetDateEnabled write FOnGetDateEnabled;
    property OnGetHighlight : TGetHighlightEvent
      read  FOnGetHighlight write FOnGetHighlight;
  end;


  TOvcCalendar = class(TOvcCustomCalendar)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property Align;
    property BorderStyle;
    property Colors;
    property Color;
    property Ctl3D;
    property Cursor;
    property DateFormat default dfLong;
    property DayNameWidth;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property LabelInfo;
    property Options;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly default False;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantDblClicks default True;
    property WeekStarts default dtSunday;
    {events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawDate;
    property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetDateEnabled;
    property OnGetHighlight;
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
  OvcFormatSettings;

const
  calMargin = 4; {left, right, and top margin}

{*** TOvcCalColors ***}

procedure TOvcCalColors.Assign(Source : TPersistent);
begin
  if Source is TOvcCalColors then begin
    FCalColors := TOvcCalColors(Source).FCalColors;
    FColorScheme := TOvcCalColors(Source).FColorScheme;
    FOnChange := TOvcCalColors(Source).FOnChange;
  end else
    inherited Assign(Source);
end;

procedure TOvcCalColors.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TOvcCalColors.EndUpdate;
begin
  FUpdating := False;
  DoOnChange;
end;

procedure TOvcCalColors.DoOnChange;
begin
  if not FUpdating and Assigned(FOnChange) then
    FOnChange(Self);

  if not SettingScheme then
    FColorScheme := cscalCustom;
end;

function TOvcCalColors.GetColor(Index : Integer) : TColor;
begin
  Result := FCalColors[Index];
end;

procedure TOvcCalColors.SetColor(Index : Integer; Value : TColor);
begin
  if Value <> FCalColors[Index] then begin
    FCalColors[Index] := Value;
    DoOnChange;
  end;
end;

procedure TOvcCalColors.SetColorScheme(Value : TOvcCalColorScheme);
begin
  if Value <> FColorScheme then begin
    SettingScheme := True;
    try
      FColorScheme := Value;
      if Value <> cscalCustom then begin
        FCalColors := CalScheme[Value];
        DoOnChange;
      end;
    finally
      SettingScheme := False;
    end;
  end;
end;


{*** TOvcCustomCalendar ***}

procedure TOvcCustomCalendar.calBtnClick(Sender : TObject);
var
  Key : Word;
begin
  SetFocus;
  Key := 0;

  if Sender = clBtnLeft then begin
    Key := VK_PRIOR;
    KeyDown(Key, []);
  end else if Sender = clBtnRevert then begin
    Key := VK_ESCAPE;
    KeyDown(Key, []);
  end else if Sender = clBtnRight then begin
    Key := VK_NEXT;
    KeyDown(Key, []);
  end else if Sender = clBtnToday then begin
    Key := VK_BACK;
    KeyDown(Key, [ssAlt]);
  end else if Sender = clBtnNextYear then begin
    Key := VK_NEXT;
    KeyDown(Key, [ssCtrl]);
  end else if Sender = clBtnPrevYear then begin
    Key := VK_PRIOR;
    KeyDown(Key, [ssCtrl]);
  end;
end;

procedure TOvcCustomCalendar.calChangeMonth(Sender : TObject);
var
  Y, M, D : Word;
  MO      : Integer;
  MI      : TMenuItem;
begin
  MI := (Sender as TMenuItem);
  DecodeDate(FDate, Y, M, D);
  MO := MI.Tag;
  {set month and year}
  if (MO > M) and (MI.HelpContext < 3) then
    Dec(Y)
  else if (MO < M) and (MI.HelpContext > 3) then
    Inc(Y);
  M := M + MO;
  {set day}
  if D > DaysInMonth(MO, Y, 0) then
    D := DaysInMonth(MO, Y, 0);
  SetDate(calGetValidDate(EncodeDate(Y, MO, D)-1, +1));
  if (Assigned(FOnChange)) then
    FOnChange(Self, FDate);
end;

procedure TOvcCustomCalendar.calColorChange(Sender : TObject);
begin
  Invalidate;
end;

function TOvcCustomCalendar.calGetCurrentRectangle : TRect;
  {-get bounding rectangle for the current date}
var
  Idx  : Integer;
  R, C : Integer;
begin
  {index into the month grid}
  Idx := clFirst + Pred(clDay) + 13;
  R := (Idx div 7);
  C := (Idx mod 7);
  Result := clRowCol[R,C];
end;

{added}
{Modified July 9, 2001}
function TOvcCustomCalendar.calGetValidDate(ADate : TDateTime;
  Delta : Integer) : TDateTime;
var
  I, X : Integer;
  Valid: Boolean;
  Fwd: Boolean;
begin
  Valid := false;
  Fwd := false;
  X := Delta;
  I := 1;
  while not Valid and (I < 1000) do begin
    {If the date is valid then yay!}
    if (DoOnGetDateEnabled(ADate + (X * I))) then begin
      Valid := true;
      Fwd := True;
    end
    {otherwise check the other direction}
    else if (DoOnGetDateEnabled(ADate - (X * I))) then begin
      valid := true;
    end
    else Inc(I);
  end;
  if Valid then
    if Fwd then Result := ADate + (X * I)
    else Result := ADate - (X * I)
  else
    raise(Exception.Create(GetOrphStr(SCInvalidDate)));
end;

procedure TOvcCustomCalendar.calRebuildCalArray;
var
  Day1 : TOvcDayType;
  I, J : Integer;
begin
  HandleNeeded;
  DecodeDate(FDate, clYear, clMonth, clDay);

  {get the first day of the current month and year}
  Day1 := TOvcDayType(SysUtils.DayOfWeek(EncodeDate(clYear, clMonth, 1)) -1);

  {find its index}
  I := Byte(Day1) - Byte(WeekStarts) + 1;
  if I < 1 then
    Inc(I, 7);
  clFirst := I;

  {find the index of the last day in the month}
  clLast := clFirst + DaysInMonth(clMonth, clYear, 0) - 1;

  {initialize the first part of the calendar}
  if clMonth = 1 then
    J := DaysInMonth(12, clYear-1, 0)
  else
    J := DaysInMonth(clMonth-1, clYear, 0);
  for I := clFirst-1 downto 1 do begin
    clCalendar[I] := J;
    Dec(J);
  end;

  {initialize the rest of the calendar}
  J := 1;
  for I := clFirst to 49 do begin
    clCalendar[I] := J;
    if I = clLast then
      J := 1
    else
      Inc(J);
  end;
end;

procedure TOvcCustomCalendar.calRecalcSize;
  {-calcualte new sizes for rows and columns}
var
  R   : Integer;
  C   : Integer;
  D1  : Integer;
  D2  : Integer;
  CH  : Integer;
  RH  : Integer;
  Row : array[0..8] of Integer;
  Col : array[0..6] of Integer;

  function SumOf(const A : array of Integer; First, Last : Integer) : Integer;
  var
    I : Integer;
  begin
    Result := 0;
    for I := First to Last do
      Result := Result  + A[I];
  end;

begin
  if not HandleAllocated then
    Exit;

  {clear row/col position structure}
  FillChar(clRowCol, SizeOf(clRowCol), #0);

  {set the way the buttons should look}
  clBtnLeft.Flat     := not Ctl3D and not clPopup;
  clBtnRevert.Flat   := not Ctl3D and not clPopup;
  clBtnRight.Flat    := not Ctl3D and not clPopup;
  clBtnToday.Flat    := not Ctl3D and not clPopup;
  clBtnNextYear.Flat := not Ctl3D and not clPopup;
  clBtnPrevYear.Flat := not Ctl3D and not clPopup;

  clBtnRevert.Visible := cdoShowRevert in FOptions;
  clBtnToday.Visible := cdoShowToday in FOptions;
  clBtnLeft.Visible := (cdoShowNavBtns in FOptions);
  clBtnRight.Visible := (cdoShowNavBtns in FOptions);
  clBtnNextYear.Visible := (cdoShowNavBtns in FOptions);
  clBtnPrevYear.Visible := (cdoShowNavBtns in FOptions);

  clWidth := ClientWidth - 2*calMargin;
  {store row and column sizes}
  for C := 0 to 6 do
    Col[C] := clWidth div 7;

  Canvas.Font := Font;
(*
  Row[0] := Round(1.3 * Canvas.TextHeight('Yy')); {button and date row}
  Row[1] := Round(1.5 * Canvas.TextHeight('Yy'));; {day name row}
*)

  if (DrawHeader) then begin
    {button and date row}
    Row[0] := Round(1.4 * Canvas.TextHeight('Yy'));
    {day name row}
    Row[1] := Round(1.5 * Canvas.TextHeight('Yy'))
  end else begin
    {button and date row}
    Row[0] := Round(1.3 * Canvas.TextHeight('Yy'));
    {day name row}
    Row[1] := 0;
  end;

  CH := ClientHeight - 2*calMargin - Row[0] - Row[1];
  RH := CH div 7;
  for R := 2 to 8 do
    Row[R] := RH;

  {distribute any odd horizontal space equally among the columns}
  for C := 0 to clWidth mod 7 do
    Inc(Col[C]);

  {distribute odd vertical space to top 2 rows}
  D1 := 0;
  for R := 0 to 8 do
    D1 := D1 + Row[R];
  D1 := ClientHeight - D1 - 2*calMargin;
  D2 := D1 div 2;
  D1 := D1 - D2;
  Row[0] := Row[0] + D1;
  if (DrawHeader) then
    Row[1] := Row[1] + D2;

  {initialize each cells TRect structure using}
  {the row heights from the Row[] array and the}
  {column widths from the Col[] array}
  for R := clStartRow to 7 do begin
    for C := 0 to 6 do begin
      clRowCol[R, C].Left := SumOf(Col, 0, C-1) + calMargin;
      clRowCol[R, C].Right := SumOf(Col, 0, C) + calMargin;
      clRowCol[R, C].Top := SumOf(Row, 0, R-1) + calMargin;
      clRowCol[R, C].Bottom := SumOf(Row, 0, R) + calMargin;
    end;
  end;

  {position and size the left and right month buttons}
  {position and size the next and prev year buttons}
  clBtnNextYear.Height := Row[0] - calMargin;
  clBtnNextYear.Width := Col[1] - calMargin;
  if clBtnNextYear.Width < clBtnNextYear.Glyph.Width + 3 then
    clBtnNextYear.Width := clBtnNextYear.Glyph.Width + 3;
  clBtnNextYear.Top := calMargin;
  clBtnNextYear.Left := ClientWidth - calMargin - clBtnNextYear.Width;

  clBtnPrevYear.Height := Row[0] - calMargin;
  clBtnPrevYear.Width := Col[5] - calMargin;
  if clBtnPrevYear.Width < clBtnPrevYear.Glyph.Width + 3 then
    clBtnPrevYear.Width := clBtnPrevYear.Glyph.Width + 3;
  clBtnPrevYear.Top := calMargin;
  clBtnPrevYear.Left := calMargin;

  clBtnLeft.Height := Row[0] - calMargin;
  clBtnLeft.Width := Col[0] - calMargin;
  if clBtnLeft.Width < clBtnLeft.Glyph.Width + 3 then
    clBtnLeft.Width := clBtnLeft.Glyph.Width + 3;
  clBtnLeft.Top := calMargin;
  clBtnLeft.Left := clBtnPrevYear.Left + clBtnPrevYear.Width;

  clBtnRight.Height := Row[0] - calMargin;
  clBtnRight.Width := Col[6] - calMargin;
  if clBtnRight.Width < clBtnRight.Glyph.Width + 3 then
    clBtnRight.Width := clBtnRight.Glyph.Width + 3;
  clBtnRight.Top := calMargin;
  clBtnRight.Left := clBtnNextYear.Left - clBtnRight.Width;

  {position and size "today" button}
  clBtnToday.Height := Row[8];
  clBtnToday.Width := Col[5] + Col[6] - calMargin;
  clBtnToday.Top := ClientHeight - calMargin - clBtnToday.Height + 1;
  clBtnToday.Left := ClientWidth - calMargin - clBtnToday.Width;


  {position and size "revert" button}
  clBtnRevert.Height := Row[8];
  clBtnRevert.Width := Col[5] + Col[6] - calMargin;
  clBtnRevert.Top := ClientHeight - calMargin - clBtnRevert.Height + 1;
  clBtnRevert.Left := clBtnToday.Left - clBtnRevert.Width - calMargin;
end;

procedure TOvcCustomCalendar.CMCtl3DChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) or not HandleAllocated then
    Exit;

  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;

  calReCalcSize;

  Invalidate;
end;

procedure TOvcCustomCalendar.CMEnter(var Msg : TMessage);
var
  R : TRect;
begin
  inherited;

  clRevertDate := FDate;

  {invalidate the active date to ensure that the focus rect is painted}
  R := calGetCurrentRectangle;
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomCalendar.CMExit(var Msg : TMessage);
var
  R : TRect;
begin
  inherited;

  {invalidate the active date to ensure that the focus rect is painted}
  R := calGetCurrentRectangle;
  InvalidateRect(Handle, @R, False);
end;

procedure TOvcCustomCalendar.CMFontChanged(var Msg : TMessage);
begin
  inherited;

  if csLoading in ComponentState then
    Exit;

  calRecalcSize;
  Invalidate;
end;

constructor TOvcCustomCalendar.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csClickEvents, csFramed] - [csCaptureMouse];

  Height        := 140;
  TabStop       := True;
  Width         := 200;
  Font.Name     := 'MS Sans Serif';
  Font.Size     := 8;

  FBorderStyle  := bsNone;
  FDayNameWidth := 3;
  FDateFormat   := dfLong;
  FOptions      := [cdoShortNames, cdoShowYear, cdoShowInactive,
                    cdoShowRevert, cdoShowToday, cdoShowNavBtns];
  FWantDblClicks  := True;
  FWeekStarts   := dtSunday;

  {create navigation buttons}
  clBtnLeft := TSpeedButton.Create(Self);
  clBtnLeft.Parent := Self;
  clBtnLeft.Glyph.Handle := LoadBaseBitmap('ORLEFTARROW');
  clBtnLeft.OnClick := calBtnClick;

  clBtnRight := TSpeedButton.Create(Self);
  clBtnRight.Parent := Self;
  clBtnRight.Glyph.Handle := LoadBaseBitmap('ORRIGHTARROW');
  clBtnRight.OnClick := calBtnClick;

  clBtnNextYear := TSpeedButton.Create(Self);
  clBtnNextYear.Parent := Self;
  clBtnNextYear.Glyph.Handle := LoadBaseBitmap('ORRIGHTARROWS');
  clBtnNextYear.OnClick := calBtnClick;

  clBtnPrevYear := TSpeedButton.Create(Self);
  clBtnPrevYear.Parent := Self;
  clBtnPrevYear.Glyph.Handle := LoadBaseBitmap('ORLEFTARROWS');
  clBtnPrevYear.OnClick := calBtnClick;

  {create "revert" button}
  clBtnRevert := TSpeedButton.Create(Self);
  clBtnRevert.Parent := Self;
  clBtnRevert.Glyph.Handle := LoadBaseBitmap('ORREVERT');
  clBtnRevert.OnClick := calBtnClick;

  {create "today" button}
  clBtnToday := TSpeedButton.Create(Self);
  clBtnToday.Parent := Self;
  clBtnToday.Glyph.Handle := LoadBaseBitmap('ORTODAY');
  clBtnToday.OnClick := calBtnClick;

  {assign default color scheme}
  FColors := TOvcCalColors.Create;
  FColors.OnChange := calColorChange;
  FColors.FCalColors := CalScheme[cscalWindows];

  {assign default international support object}
  FIntlSup := OvcIntlSup;

  FDrawHeader:= True;
  clRowCount := 8;
  clStartRow := 0;
end;

constructor TOvcCustomCalendar.CreateEx(AOwner : TComponent; AsPopup : Boolean);
begin
  clPopup := AsPopup;
  Create(AOwner);
end;

procedure TOvcCustomCalendar.CreateParams(var Params : TCreateParams);
const
  BorderStyles : array[TBorderStyle] of Integer = (0, WS_BORDER);
begin
  inherited CreateParams(Params);

  with Params do begin
    Style := Integer(Style) or BorderStyles[FBorderStyle];
    if clPopup then begin
      Style := WS_POPUP or WS_BORDER;
      WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    end;
  end;

  if NewStyleControls and (Ctl3D or clPopup) and (FBorderStyle = bsSingle) then begin
    if not clPopup then
      Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;

  {set style to reflect desire for double clicks}
  if FWantDblClicks then
    ControlStyle := ControlStyle + [csDoubleClicks]
  else
    ControlStyle := ControlStyle - [csDoubleClicks];

  {get windows date mask}
  FIntlSup.InternationalLongDatePChar(clMask, cdoShortNames in FOptions, False);
end;

procedure TOvcCustomCalendar.CreateWnd;
begin
  inherited CreateWnd;

  calRecalcSize;

  {if not set, get current date}
  if FDate = 0 then
    SetDate(calGetValidDate(SysUtils.Date-1, +1));
end;

destructor TOvcCustomCalendar.Destroy;
begin
  FColors.Free;
  FColors := nil;

  inherited Destroy;
end;

function TOvcCustomCalendar.DateString(const Mask : string): string;
var
  M   : string;
begin
  M := Mask;
  if Length(M) = 0 then
    M := StrPas(clMask);

  {convert calendar month and year to a string}
  Result := FIntlSup.DateToDateString(M, DateTimeToStDate(FDate), True);
end;

function TOvcCustomCalendar.DayString: string;
begin
  Result := IntlSupport.DayOfWeekToString(DayOfWeek(DateTimeToStDate(FDate)));
end;

procedure TOvcCustomCalendar.DoOnChange(Value : TDateTime);
begin
  if Assigned(FOnChange) then
    FOnChange(Self, Value);
end;


function TOvcCustomCalendar.DoOnGetDateEnabled(ADate : TDateTime) : Boolean;
begin
  Result := True;
  if Assigned(FOnGetDateEnabled) then
    FOnGetDateEnabled(Self, ADate, Result);
end;

procedure TOvcCustomCalendar.DoOnMouseWheel(Shift : TShiftState; Delta, XPos, YPos : SmallInt);
var
  Key : Word;
begin
  inherited DoOnMouseWheel(Shift, Delta, XPos, YPos);

  if Abs(Delta) = WHEEL_DELTA then begin
    {inc/dec month}
    if Delta < 0 then
      Key := VK_NEXT
    else
      Key := VK_PRIOR;
    KeyDown(Key, []);
  end else if Abs(Delta) > WHEEL_DELTA then begin
    {inc/dec year}
    if Delta < 0 then
      Key := VK_NEXT
    else
      Key := VK_PRIOR;
    KeyDown(Key, [ssCtrl]);
  end else if Abs(Delta) < WHEEL_DELTA then begin
    {inc/dec Week}
    if Delta < 0 then
      Key := VK_DOWN
    else
      Key := VK_UP;
    KeyDown(Key, []);
  end;
end;

function TOvcCustomCalendar.GetAsDateTime : TDateTime;
begin
  Result := FDate;
end;

function TOvcCustomCalendar.GetAsStDate : TStDate;
begin
  Result := DateTimeToStDate(FDate)
end;

function TOvcCustomCalendar.IsReadOnly : Boolean;
begin
  Result := ReadOnly;
end;

        {revised}
procedure TOvcCustomCalendar.KeyDown(var Key : Word; Shift : TShiftState);
var
  Y  : Word;
  M  : Word;
  D  : Word;
  HD : TDateTime;

begin
  inherited KeyDown(Key, Shift);

  if IsReadOnly then
    Exit;

  HD := FDate;
  case Key of
    VK_LEFT  : if Shift = [] then
                 SetDate(calGetValidDate(FDate, -1));
    VK_RIGHT : if Shift = [] then
                 SetDate(calGetValidDate(FDate, +1));
    VK_UP    : if Shift = [] then
                 SetDate(calGetValidDate(FDate, -7));
    VK_DOWN  : if Shift = [] then
                 SetDate(calGetValidDate(FDate, +7));
    VK_HOME  :
      begin
        if ssCtrl in Shift then begin
          DecodeDate(FDate, Y, M, D);
          SetDate(calGetValidDate(EncodeDate(Y, 1, 1)-1, +1));
        end else if Shift = [] then begin
          DecodeDate(FDate, Y, M, D);
          SetDate(calGetValidDate(EncodeDate(Y, M, 1)-1, +1));
        end;
      end;
    VK_END   :
      begin
        if ssCtrl in Shift then begin
          DecodeDate(FDate, Y, M, D);
          SetDate(calGetValidDate(EncodeDate(Y, 12, DaysInMonth(12, Y, 0))+1, -1));
        end else if Shift = [] then begin
          DecodeDate(FDate, Y, M, D);
          SetDate(calGetValidDate(EncodeDate(Y, M, DaysInMonth(M, Y, 0))+1, -1));
        end;
      end;
    VK_PRIOR :
      begin
        if ssCtrl in Shift then begin
          IncYear(-1);
        end else if Shift = [] then begin
          IncMonth(-1);
        end;
      end;
    VK_NEXT :
      begin
        if ssCtrl in Shift then begin
          IncYear(1);
        end else if Shift = [] then begin
          IncMonth(1);
        end;
      end;
    VK_BACK :
      begin
        if ssAlt in Shift then
          SetDate(calGetValidDate(SysUtils.Date-1, +1));
      end;
    VK_ESCAPE:
      begin
        if Shift = [] then
          SetDate(calGetValidDate(clRevertDate-1, +1));
      end;
  end;

  if HD <> FDate then begin
      FBrowsing := True;
    try
      DoOnChange(FDate);
    finally
      FBrowsing := False;
    end;
  end;
end;

procedure TOvcCustomCalendar.KeyPress(var Key : Char);
begin
  inherited KeyPress(Key);

  if IsReadOnly then
    Exit;

  case Key of
    '+' : SetDate(calGetValidDate(FDate, +1));
    '-' : SetDate(calGetValidDate(FDate, -1));
    #13 : DoOnChange(FDate);       {date selected}
    #32 : DoOnChange(FDate);       {date selected}
    ^Z  : SetDate(calGetValidDate(SysUtils.Date-1, +1));
  end;
end;

procedure TOvcCustomCalendar.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  Yr          : Word;
  M           : Word;
  D           : Word;
  Yr2         : Word;
  M2          : Word;
  D2          : Word;
  R, C        : Integer;
  OldIdx      : Integer;
  NewIdx      : Integer;
  Re          : TRect;
  Ignore      : Boolean;
begin
  {exit if this click happens when the popup menu is active}
  if clInPopup then
    Exit;

  SetFocus;

  inherited MouseDown(Button, Shift, X, Y);

  if IsReadOnly then
    Exit;

  {if we have the mouse captured, see if a button was clicked}
  if GetCapture = Handle then begin
    if (cdoShowNavBtns in Options) then begin
      Re := clBtnLeft.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnLeft.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnLeft.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnLeft.Click;
        Exit;
      end;


      Re := clBtnRight.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnRight.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnRight.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnRight.Click;
        Exit;
      end;

      Re := clBtnNextYear.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnNextYear.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnNextYear.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnNextYear.Click;
        Exit;
      end;

      Re := clBtnPrevYear.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnPrevYear.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnPrevYear.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnPrevYear.Click;
        Exit;
      end;
    end;

    if (cdoShowRevert in Options) then begin
      Re := clBtnRevert.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnRevert.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnRevert.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnRevert.Click;
        Exit;
      end;
    end;

    if (cdoShowToday in Options) then begin
      Re := clBtnToday.ClientRect;
      Re.TopLeft := ScreenToClient(clBtnToday.ClientToScreen(Re.TopLeft));
      Re.BottomRight := ScreenToClient(clBtnToday.ClientToScreen(Re.BottomRight));
      if PtInRect(Re, Point(X, Y)) then begin
        clBtnToday.Click;
        Exit;
      end;
    end;
  end;

  {save current date}
  DecodeDate(FDate, Yr, M, D);
  M2 := M;

  {calculate the row and column clicked on}
  for R := 2 to 8 do begin
    for C := 0 to 6 do begin
      if PtInRect(clRowCol[R,C], Point(X, Y)) then begin
        {convert to an index}
        NewIdx := ((R-2) * 7) + Succ(C);
        OldIdx := clFirst + Pred(clDay);
        Ignore := False;
        if NewIdx <> OldIdx then begin

          {see if this date is disabled - selection not allowed}
          if not DoOnGetDateEnabled(FDate+(NewIdx-OldIdx)) then
            Break;

          DecodeDate(FDate+(NewIdx-OldIdx), Yr2, M2, D2);
          if not (cdoShowInactive in FOptions) then begin
            {will this change the month?}
            if M2 <> M then
              Ignore := True;
          end;
          {convert to a date and redraw}
          if not Ignore then
            SetDate(FDate+(NewIdx-OldIdx));
        end;

        if (not Ignore) and (Button = mbLeft) then begin
          if M2 <> M then begin
              FBrowsing := True;
            try
              DoOnChange(FDate);
            finally
              FBrowsing := False;
            end;
          end else
            DoOnChange(FDate);
        end;

        Break;
      end;
    end;
  end;
end;

procedure TOvcCustomCalendar.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P  : TPoint;
  M  : TPopUpMenu;
  MI : TMenuItem;
  I  : Integer;
  J  : Integer;
  K  : Integer;
  MO : Integer;
  YR : Word;
  MM : Word;
  DA : Word;
  HC : Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);

  if (PopUpMenu = nil) and (Button = mbRight) and
     (Y < clRowCol[1,0].Top) {above day names} and
     (X > clBtnPrevYear.Left + clBtnNextYear.Width) and
     (X < clBtnNextYear.Left) then begin

    if not Focused and CanFocus then
      SetFocus;

    M := TPopupMenu.Create(Self);
    try
      DecodeDate(FDate, YR, MM, DA);
      MO := MM; {convert to integer to avoid wrap-around errors with words}

      {determine the starting month}
      I := MO - 3;
      if I < 1 then
        I := MO - 3 + 12;

      {determine the ending month + 1}
      J := MO + 4;
      if J > 12 then
        J := MO + 4 - 12;

      K := 0;
      {create the menu items}
      repeat
        MI := TMenuItem.Create(M);
        MI.Caption := FormatSettings.LongMonthNames[I];
        MI.Enabled := Enabled;
        MI.OnClick := calChangeMonth;
        MI.Tag := I;
        MI.HelpContext := K;
        M.Items.Add(MI);
        Inc(I);
        Inc(K);
        if I > 12 then
          I := 1;
      until I = J;

      HC := GetCapture = Handle;

      P.X := X-20;
      P.Y := Y - ((GetSystemMetrics(SM_CYMENU)*7) div 2);
      P := ClientToScreen(P);
      {move the mouse to cause the menu item to highlight}
      PostMessage(Handle, WM_MOUSEMOVE, 0, MAKELONG(P.X,P.Y+1));

      clInPopup := True;
      try
        M.PopUp(P.X, P.Y);

        Application.ProcessMessages;

        {capture the mouse again}
        if clPopup and HC then
          SetCapture(Handle);
      finally
        clInPopup := false;
      end;
    finally
      M.Free;
    end;
  end;
end;

procedure TOvcCustomCalendar.IncDay(Delta : Integer);
  {-change the day by Delta (signed) days}
begin
  if Delta > 0 then
    SetDate(calGetValidDate(FDate+Delta-1, +1))
  else
    SetDate(calGetValidDate(FDate+Delta+1, -1))
end;


procedure TOvcCustomCalendar.IncMonth(Delta : Integer);
  {-change the month by Delta (signed) months}
var
  Y, M, D    : Word;
  iY, iM, iD : Integer;
begin
  DecodeDate(FDate, Y, M, D);
  iY := Y; iM := M; iD := D;
  Inc(iM, Delta);
  if iM > 12 then begin
    iM := iM - 12;
    Inc(iY);
  end else if iM < 1 then begin
    iM := iM + 12;
    Dec(iY);
  end;
  if iD > DaysInMonth(iM, iY, 0) then
    iD := DaysInMonth(iM, iY, 0);

  SetDate(calGetValidDate(EncodeDate(iY, iM, iD)-1, +1));
end;


procedure TOvcCustomCalendar.IncYear(Delta : Integer);
var
  Y, M, D  : Word;
  iY, iM, iD : Integer;
begin
  DecodeDate(FDate, Y, M, D);
  iY := Y; iM := M; iD := D;
  Inc(iY, Delta);
  if iD > DaysInMonth(iM, iY, 0) then
    iD := DaysInMonth(iM, iY, 0);
  SetDate(calGetValidDate(EncodeDate(iY, iM, iD)-1, +1));
end;

function TOvcCustomCalendar.MonthString: string;
var
  M, D, Y : Word;
begin
  DecodeDate(FDate, Y, M, D);
  Result := IntlSupport.MonthToString(M);
end;

procedure TOvcCustomCalendar.Paint;
var
  R, C     : Integer;
  I        : Integer;
  {CurIndex : Integer;}
  SatCol   : Integer;
  SunCol   : Integer;
  DOW      : TOvcDayType;

  procedure DrawDate;
  var
    R : TRect;
    S : string;
  begin
    if FDateFormat = dfLong then
      if cdoShowYear in FOptions then
        S := FormatDateTime('mmmm yyyy', FDate)
      else
        S := FormatDateTime('mmmm', FDate)
    else
      if cdoShowYear in FOptions then
        S := FormatDateTime('mmm yyyy', FDate)
      else
        S := FormatDateTime('mmm', FDate);

    R := clRowCol[0,1];
    R.Right := clRowCol[0,6].Left;

    {switch to short date format if string won't fit}
    if FDateFormat = dfLong then
      if Canvas.TextWidth(S) > R.Right-R.Left then
        S := FormatDateTime('mmm yyyy', FDate);

    Canvas.Font.Color := FColors.MonthAndYear;
    if Assigned(FOnDrawDate) then
      FOnDrawDate(Self, FDate, R)
    else
      DrawText(Canvas.Handle, PChar(S), Length(S), R, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
  end;

  procedure DrawDayNames;
  var
    I : Integer;
    S : string;
  begin
    {draw the day name column labels}
    Canvas.Font.Color := FColors.DayNames;
    I := 0;
    DOW := FWeekStarts;
    repeat
      {record columns for weekends}
      if DOW = dtSaturday then
        SatCol := I;
      if DOW = dtSunday then
        SunCol := I;

      {get the day name}
      S := Copy(FormatSettings.ShortDayNames[Ord(DOW)+1], 1, FDayNameWidth);

      {draw the day name above each column}
      DrawText(Canvas.Handle, PChar(S), Length(S), clRowCol[1,I],
        DT_SINGLELINE or DT_CENTER or DT_VCENTER);
      Inc(I);
      if DOW < High(DOW) then
        Inc(DOW)
      else
        DOW := Low(DOW);
    until DOW = WeekStarts;
  end;

  procedure DrawLine;
  begin
    if Ctl3D then begin
      Canvas.Pen.Color := clBtnHighlight;
      Canvas.MoveTo(0, clRowCol[1,0].Bottom-3);
      Canvas.LineTo(ClientWidth, clRowCol[1,0].Bottom-3);
      Canvas.Pen.Color := clBtnShadow;
      Canvas.MoveTo(0,  clRowCol[1,0].Bottom-2);
      Canvas.LineTo(ClientWidth, clRowCol[1,0].Bottom-2);
    end else if BorderStyle = bsSingle then begin
      Canvas.Pen.Color := Font.Color;
      Canvas.MoveTo(0, clRowCol[1,0].Bottom-3);
      Canvas.LineTo(ClientWidth, clRowCol[1,0].Bottom-3);
    end;
  end;

  procedure DrawDay(R, C, I : Integer; Grayed{, Current} : Boolean);
  var
    Cl     : TColor;
    OldIdx : Integer;
    NewIdx : Integer;
    S      : string;
  begin

    {avoid painting day number under buttons}
    if cdoShowRevert in FOptions then
      if (R = 8) {bottom} and (C >= 3) then
        Exit;
    if cdoShowToday in FOptions then
      if (R = 8) {bottom} and (C >= 5) then
        Exit;

    {convert to a string and draw it centered in its rectangle}
    S := IntToStr(clCalendar[I]);

    if Grayed then
      Canvas.Font.Color := FColors.InactiveDays;

    if not Grayed or (cdoShowInactive in FOptions) then begin
      NewIdx := ((R-2) * 7) + Succ(C);
      OldIdx := clFirst + Pred(clDay);
      if Assigned(FOnGetHighlight) then begin
        Cl := Canvas.Font.Color;
        FOnGetHighlight(Self, FDate+(NewIdx-OldIdx), Cl);
        Canvas.Font.Color := Cl;
      end;
      if Assigned(FOnDrawItem) then
        FOnDrawItem(Self, FDate+(NewIdx-OldIdx), clRowCol[R,C])
      else
        DrawText(Canvas.Handle, S, Length(S), clRowCol[R,C], DT_SINGLELINE or DT_CENTER or DT_VCENTER);
    end;
  end;

  procedure DrawFocusBox;
  var
    R  : TRect;
    S  : string;
    BS : TButtonStyle;
  begin
    S := IntToStr(clDay);
    if Ctl3D then
      BS := bsNew
    else
      BS := bsWin31;
    if Focused then
      R := DrawButtonFace(Canvas, calGetCurrentRectangle, 1, BS, True, True, False)
    else
      R := DrawButtonFace(Canvas, calGetCurrentRectangle, 1, BS, True, False, False);
    DrawText(Canvas.Handle, S, Length(S), R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;

begin
  Canvas.Font := Font;
  Canvas.Brush.Color := Color;{clBtnFace;}
  Canvas.FillRect(ClientRect);

  {draw the month and year at the top of the calendar}
  DrawDate;

  {draw the days of the week}
  DrawDayNames;

  {draw line under day names}
  DrawLine;

  {draw each day}
  {CurIndex := clFirst + Pred(clDay);}
  I := 1;
  for R := 2 to 8 do
    for C := 0 to 6 do begin
      if (C = SatCol) or (C = SunCol) then
        Canvas.Font.Color := FColors.WeekEnd
      else
        Canvas.Font.Color := FColors.Days;
      DrawDay(R, C, I, (I < clFirst) or (I > clLast){, I = CurIndex});
      Inc(I);
    end;

  Canvas.Font.Color := FColors.ActiveDay;
  if not Assigned(FOnDrawItem) then
    if not (cdoHideActive in FOptions) then
      DrawFocusBox;
end;

function TOvcCustomCalendar.GetCalendarDate : TDateTime;
begin
  Result := FDate;
end;

function TOvcCustomCalendar.GetDay : Integer;
begin
  Result := clDay;
end;

function TOvcCustomCalendar.GetMonth : Integer;
begin
  Result := clMonth;
end;

function TOvcCustomCalendar.GetYear : Integer;
begin
  Result := clYear;
end;

procedure TOvcCustomCalendar.SetAsDateTime(Value : TDateTime);
begin
  SetDate(calGetValidDate(Value-1, +1));
end;

procedure TOvcCustomCalendar.SetAsStDate(Value : TStDate);
begin
  SetDate(calGetValidDate(StDateToDateTime(Value)-1, +1));
end;

procedure TOvcCustomCalendar.SetBorderStyle(Value : TBorderStyle);
begin
  if Value <> FBorderStyle then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomCalendar.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited Setbounds(ALeft, ATop, AWidth, AHeight);

  if csLoading in ComponentState then
    Exit;

  calRecalcSize;
end;

procedure TOvcCustomCalendar.SetCalendarDate(Value : TDateTime);
  {-Changes:
    03/2011, AB: minor bugfix: To compare NewDate and CalenderDate we have to convert
                 the type of one operand. }
var
  NewDate : TStDate;
begin
  NewDate := DateTimeToStDate(Value);
  if (NewDate = BadDate) or (NewDate = DateTimeToStDate(CalendarDate)) or
     (IncDateTrunc(NewDate,  1, 0) = BadDate) or
     (IncDateTrunc(NewDate, -1, 0) = BadDate) then begin
    Exit;
  end;
  SetDate(calGetValidDate(Value-1, +1));
end;

procedure TOvcCustomCalendar.SetDate(Value : TDateTime);
var
  R : TRect;
  Y : Word;
  M : Word;
  D : Word;
begin
  if Value <> FDate then begin
    {determine if the new date is in the same month}
    DecodeDate(Value, Y, M, D);
    if (clYear = Y) and (clMonth = M) then begin
      {invalidate the old date}
      R := calGetCurrentRectangle;
      InvalidateRect(Handle, @R, False);
    end else
      Invalidate;

    DecodeDate(Value, clYear, clMonth, clDay);
    FDate := Value;
    calRebuildCalArray;

    {invalidate the new date}
    R := calGetCurrentRectangle;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TOvcCustomCalendar.SetDateFormat(Value : TOvcDateFormat);
begin
  if Value <> FDateFormat then begin
   FDateFormat := Value;
   Invalidate;
  end;
end;

procedure TOvcCustomCalendar.SetDayNameWidth(Value : TOvcDayNameWidth);
begin
  if Value <> FDayNameWidth then begin
   FDayNameWidth := Value;
   Invalidate;
  end;
end;

procedure TOvcCustomCalendar.SetDisplayOptions(Value : TOvcCalDisplayOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;
    calRecalcSize;
    Invalidate;
  end;
end;

procedure TOvcCustomCalendar.SetDrawHeader(Value : Boolean);
  {-set the DrawHeader property value}
begin
  if Value <> FDrawHeader then begin
    FDrawHeader := Value;
    if FDrawHeader then begin
      clStartRow := 0;
      clRowCount := 8;
    end else begin
      clStartRow := 2;
      clRowCount := 7;
    end;
    calRecalcSize;
    Refresh;
  end;
end;

procedure TOvcCustomCalendar.SetIntlSupport(Value : TOvcIntlSup);
  {-set the international support object this field will use}
begin
  if Assigned(Value) then
    FIntlSup := Value
  else
    FIntlSup := OvcIntlSup;
end;

procedure TOvcCustomCalendar.SetToday;
  {-set the calendar to todays date}
begin
  SetDate(calGetValidDate(SysUtils.Date-1, +1));
end;

procedure TOvcCustomCalendar.SetWantDblClicks(Value : Boolean);
begin
  if Value <> FWantDblClicks then begin
    FWantDblClicks := Value;
    RecreateWnd;
  end;
end;

procedure TOvcCustomCalendar.SetWeekStarts(Value : TOvcDayType);
begin
  if Value <> FWeekStarts then begin
    FWeekStarts := Value;
    if csLoading in ComponentState then
      Exit;
    calRebuildCalArray;
    Invalidate;
  end;
end;

procedure TOvcCustomCalendar.WMEraseBkgnd(var Msg : TWMEraseBkgnd);
begin
  Msg.Result := 1;   {don't erase background, just say we did}
end;

procedure TOvcCustomCalendar.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;

procedure TOvcCustomCalendar.WMKillFocus(var Msg : TWMKillFocus);
begin
  inherited;

  Invalidate;
end;


end.

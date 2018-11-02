{*********************************************************}
{*                  OVCEDCAL.PAS 4.06                    *}
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

unit ovcedcal;
  {-date edit field with popup calendar}

interface

uses
  Types, Windows, Buttons, Classes, Controls, Forms, Graphics, Menus, Messages,
  StdCtrls, SysUtils, MultiMon, OvcBase, OvcCal, OvcConst, OvcData, OvcEdPop, OvcExcpt,
  OvcIntl, OvcMisc, OvcEditF, OvcDate;

type
  TOvcDateOrder = (doMDY, doDMY, doYMD);
  TOvcRequiredDateField = (rfYear, rfMonth, rfDay);
  TOvcRequiredDateFields = set of TOvcRequiredDateField;

  {Events}
  TOvcGetDateEvent = procedure(Sender : TObject; var Value : string) of object;
  TOvcPreParseDateEvent = procedure(Sender : TObject; var Value : string)
    of object;
  TOvcGetDateMaskEvent = procedure(Sender : TObject; var Mask : string)
    of object;

  TOvcCustomDateEdit = class(TOvcEdPopup)
  protected {private}
    {property variables}
    FAllowIncDec         : Boolean;
    FCalendar            : TOvcCalendar;
    FDate                : TDateTime;
    FEpoch               : Integer;
    FForceCentury        : Boolean;
    FRequiredFields      : TOvcRequiredDateFields;
    FTodayString         : string;

    {event variables}
    FOnGetDate           : TOvcGetDateEvent;
    FOnGetDateMask       : TOvcGetDateMaskEvent;
    FOnPreParseDate      : TOvcPreParseDateEvent;
    FOnSetDate           : TNotifyEvent;

    {internal variables}
    DateOrder            : TOvcDateOrder;
    HoldCursor           : TCursor;
    PopupClosing         : Boolean;
    WasAutoScroll        : Boolean;

    {property methods}
    function GetDate : TDateTime;
    function GetEpoch : Integer;
    function GetPopupColors : TOvcCalColors;
    function GetPopupFont : TFont;
    function GetPopupHeight : Integer;
    function GetPopupDateFormat : TOvcDateFormat;
    function GetPopupDayNameWidth : TOvcDayNameWidth;
    function GetPopupOptions : TOvcCalDisplayOptions;
    function GetPopupWeekStarts : TOvcDayType;
    function GetPopupWidth : Integer;
    function GetReadOnly : Boolean;
    procedure SetEpoch(Value : Integer);
    procedure SetForceCentury(Value : Boolean);
    procedure SetPopupColors(Value : TOvcCalColors);
    procedure SetPopupFont(Value : TFont);
    procedure SetPopupHeight(Value : Integer);
    procedure SetPopupWidth(Value : Integer);
    procedure SetPopupDateFormat(Value : TOvcDateFormat);
    procedure SetPopupDayNameWidth(Value : TOvcDayNameWidth);
    procedure SetPopupOptions(Value : TOvcCalDisplayOptions);
    procedure SetPopupWeekStarts(Value : TOvcDayType);
    procedure SetReadOnly(Value : Boolean);

    {internal methods}
    function  ParseDate(const Value : string) : string;
    procedure PopupDateChange(Sender : TObject; Date : TDateTime);
    procedure PopupKeyDown(Sender : TObject; var Key : Word;
                           Shift : TShiftState);
    procedure PopupKeyPress(Sender : TObject; var Key : Char);
    procedure PopupMouseDown(Sender : TObject; Button : TMouseButton;
                             Shift : TShiftState; X, Y : Integer);
  protected
    procedure DoExit; override;
    procedure GlyphChanged; override;
    procedure KeyDown(var Key : Word; Shift : TShiftState); override;
    procedure KeyPress(var Key : Char); override;
    procedure SetDate(Value : TDateTime);

    {protected properties}
    property AllowIncDec : Boolean read FAllowIncDec write FAllowIncDec;
    property Epoch : Integer read GetEpoch write SetEpoch;
    property ForceCentury : Boolean read FForceCentury write SetForceCentury;
    property PopupColors : TOvcCalColors read GetPopupColors
                                         write SetPopupColors;
    property PopupFont : TFont read GetPopupFont write SetPopupFont;
    property PopupHeight : Integer read GetPopupHeight write SetPopupHeight;
    property PopupWidth : Integer read GetPopupWidth write SetPopupWidth;
    property PopupDateFormat : TOvcDateFormat read GetPopupDateFormat
                                              write SetPopupDateFormat;
    property PopupDayNameWidth : TOvcDayNameWidth read GetPopupDayNameWidth
                                                  write SetPopupDayNameWidth;
    property PopupOptions : TOvcCalDisplayOptions read GetPopupOptions
                                                  write SetPopupOptions;
    property PopupWeekStarts : TOvcDayType read GetPopupWeekStarts
                                           write SetPopupWeekStarts;
    property ReadOnly : Boolean read GetReadOnly write SetReadOnly;
    property RequiredFields : TOvcRequiredDateFields read FRequiredFields
                                                     write FRequiredFields;
    property TodayString : string read FTodayString write FTodayString;

    {protected events}
    property OnGetDate : TOvcGetDateEvent read FOnGetDate write FOnGetDate;
    property OnGetDateMask : TOvcGetDateMaskEvent read FOnGetDateMask
                                                  write FOnGetDateMask;
    property OnPreParseDate : TOvcPreParseDateEvent read FOnPreParseDate
                                                    write FOnPreParseDate;
    property OnSetDate : TNotifyEvent read FOnSetDate write FOnSetDate;

  public
    constructor Create(AOwner : TComponent); override;
    function DateString(const Mask : string) : string;
    function FormatDate(Value : TDateTime) : string; dynamic;
    procedure PopupClose(Sender : TObject); override;
    procedure PopupOpen; override;
    procedure SetDateText(Value : string); dynamic;
    {public properties}
    property Calendar : TOvcCalendar read FCalendar;
    property Date: TDateTime read GetDate write SetDate;
  end;


  TOvcDateEdit = class(TOvcCustomDateEdit)
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
    property CharCase;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Epoch;
    property Font;
    property ForceCentury;
    property HideSelection;
    property LabelInfo;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupAnchor;
    property PopupColors;
    property PopupDateFormat;
    property PopupDayNameWidth;
    property PopupFont;
    property PopupHeight;
    property PopupMenu;
    property PopupOptions;
    property PopupWidth;
    property PopupWeekStarts;
    property ReadOnly;
    property RequiredFields;
    property ShowButton;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TodayString;
    property Visible;

    {inherited events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetDate;
    property OnGetDateMask;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPopupClose;
    property OnPopupOpen;
    property OnPreParseDate;
    property OnSetDate;
    property OnStartDrag;
  end;

implementation

uses
  OVCStr, OvcFormatSettings;

{*** TOvcCustomDateEdit ***}

constructor TOvcCustomDateEdit.Create(AOwner : TComponent);
var
  C : array[0..1] of Char;

  function GetLocaleInt(lcType: Cardinal; Default: Integer): Integer;
  var
    Len: Integer;
    S: string;
  begin
    Result := Default;
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, nil, 0);
    if Len = 0 then
      Exit;
    SetLength(S, Len);
    Len := GetLocaleInfo(LOCALE_USER_DEFAULT, lcType, PChar(S), Length(S));
    S := Copy(S, 1, Len - 1);
    Result := StrToIntDef(S, Default);
  end;

begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  FAllowIncDec         := True;
  FForceCentury        := False;
  FRequiredFields      := [rfMonth, rfDay];
  FTodayString         := FormatSettings.DateSeparator;

  {get the date order from windows}
  C[0] := '0'; {default}

//  GetProfileString('intl', 'iDate', '0', C, 2);   //SZ: GetProfileString is deprecated
//  DateOrder := TOvcDateOrder(Ord(C[0])-Ord('0'));
  DateOrder := TOvcDateOrder(GetLocaleInt(LOCALE_IDATE, 0));

  {load button glyph}
  FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCAL');
  FButton.Glyph.Assign(FButtonGlyph);

  FCalendar := TOvcCalendar.CreateEx(Self, True);
  FCalendar.OnChange     := PopupDateChange;
  FCalendar.OnExit       := PopupClose;
  FCalendar.OnKeyDown    := PopupKeyDown;
  FCalendar.OnKeyPress   := PopupKeyPress;
  FCalendar.OnMouseDown  := PopupMouseDown;
  FCalendar.Visible      := False;  {to avoid flash at 0,0}
  FCalendar.BorderStyle  := bsSingle;
  FCalendar.ParentFont   := False;
  FCalendar.Parent       := GetImmediateParentForm(Self);
end;

procedure TOvcCustomDateEdit.DoExit;
begin
  try
    SetDateText(Text);
  except
    SetFocus;
    raise;
  end;

  if not PopupActive then
    inherited DoExit;
end;

function TOvcCustomDateEdit.DateString(const Mask : string) : string;
begin
  Result := OvcIntlSup.DateToDateString(Mask, DateTimeToSTDate(Date), False);
end;

function TOvcCustomDateEdit.FormatDate(Value : TDateTime) : string;
var
  DateMask : string;
  Mask     : string;
begin
  DateMask := OvcIntlSup.InternationalDate(FForceCentury);
  if Assigned(FOnGetDateMask) then begin
    FOnGetDateMask(Self, DateMask);
    {see if the date order needs to be changed}
    Mask := AnsiUpperCase(DateMask);
    if (Pos('M', Mask) > Pos('Y', Mask)) or
       (Pos('N', Mask) > Pos('Y', Mask)) then
      DateOrder := doYMD
    else if (Pos('M', Mask) > Pos('D', Mask)) or
            (Pos('N', Mask) > Pos('D', Mask)) then
      DateOrder := doDMY
    else
      DateOrder := doMDY;
  end;
  Result := OvcIntlSup.DateToDateString(DateMask, DateTimeToSTDate(Value), False);
end;

function TOvcCustomDateEdit.GetDate : TDateTime;
begin
  SetDateText(Text);
  Result := FDate;
end;

function TOvcCustomDateEdit.GetEpoch : Integer;
begin
  Result := FEpoch;

  if (csWriting in ComponentState) then
    Exit;

  if (Result = 0) and ControllerAssigned then
    Result := Controller.Epoch;
end;

function TOvcCustomDateEdit.GetPopupColors : TOvcCalColors;
begin
  Result := FCalendar.Colors;
end;

function  TOvcCustomDateEdit.GetPopupDateFormat : TOvcDateFormat;
begin
  Result := FCalendar.DateFormat;
end;

function  TOvcCustomDateEdit.GetPopupDayNameWidth : TOvcDayNameWidth;
begin
  Result := FCalendar.DayNameWidth;
end;

function TOvcCustomDateEdit.GetPopupFont : TFont;
begin
  Result := FCalendar.Font;
end;

function TOvcCustomDateEdit.GetPopupHeight : Integer;
begin
  Result := FCalendar.Height;
end;

function  TOvcCustomDateEdit.GetPopupOptions: TOvcCalDisplayOptions;
begin
  Result := FCalendar.Options;
end;

function  TOvcCustomDateEdit.GetPopupWeekStarts: TOvcDayType;
begin
  Result := FCalendar.WeekStarts;
end;

function TOvcCustomDateEdit.GetPopupWidth : Integer;
begin
  Result := FCalendar.Width;
end;

function TOvcCustomDateEdit.GetReadOnly : Boolean;
begin
  Result := inherited ReadOnly;
end;

procedure TOvcCustomDateEdit.GlyphChanged;
begin
  inherited GlyphChanged;

  if FButtonGlyph.Empty then
    FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCAL');
end;

procedure TOvcCustomDateEdit.KeyDown(var Key : Word; Shift : TShiftState);
begin
  inherited KeyDown(Key, Shift);

  if ShowButton and (Key = VK_DOWN) and (ssAlt in Shift) then
    PopupOpen;
end;

procedure TOvcCustomDateEdit.KeyPress(var Key : Char);
var
  D : Word;
  M : Word;
  Y : Word;
begin
  inherited KeyPress(Key);

  if (ReadOnly) then Exit;

  if FAllowIncDec and CharInSet(Key, ['+', '-']) then begin
  {accept current date}
    DoExit;
    if FDate = 0 then
      DecodeDate(SysUtils.Date, Y, M, D)
    else
      DecodeDate(FDate, Y, M, D);
    if Key = '+' then begin
      Inc(D);
      if D > DaysInMonth(M, Y, Epoch) then begin
        D := 1;
        Inc(M);
        if M > 12 then begin
          Inc(Y);
          M := 1;
        end;
      end;
    end else begin
    {Key = '-'}
      Dec(D);
      if D < 1 then begin
        Dec(M);
        if M < 1 then begin
          M := 12;
          Dec(Y);
        end;
        D := DaysInMonth(M, Y, Epoch);
      end;
    end;
    SetDate(STDateToDateTime(DMYToSTDate(D, M, Y, Epoch)));

    {clear}
    Key := #0;
  end;
end;

function TOvcCustomDateEdit.ParseDate(const Value : string) : string;
var
  S           : string;
  ThisYear    : Word;
  ThisMonth   : Word;
  ThisDay     : Word;
  DefaultDate : TStDate;
  Increment   : Integer;
  Occurrence  : Integer;
  StartDate   : TStDate;

  procedure DoSetDate;
  var
    I   : integer;
    D   : TStDate;
    DOW : TStDayType;
  begin
    D   := StartDate;
    DOW := DayofWeek(DateTimeToStDate(SysUtils.Date));
    if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[1],1,3)), S) > 0 then begin
      DOW := Sunday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[2],1,3)), S) > 0 then begin
      DOW := Monday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[3],1,3)), S) > 0 then begin
      DOW := Tuesday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[4],1,3)), S) > 0 then begin
      DOW := Wednesday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[5],1,3)), S) > 0 then begin
      DOW := Thursday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[6],1,3)), S) > 0 then begin
      DOW := Friday;
    end else if Pos(AnsiUppercase(Copy(FormatSettings.LongDayNames[7],1,3)), S) > 0 then begin
      DOW := Saturday;
    end else begin
      if DefaultDate > 0 then begin
        D := DefaultDate;
        Occurrence := 0;
      end else if DefaultDate < 0 then begin
        Result := S;
        exit;
      end;
    end;
    I := 0;
    while I < Occurrence do begin
      D := D + Increment;
      if DayOfWeek(D) = DOW then begin
        inc(I);
      end;
    end;
    Result := FormatDate(StDateToDateTime(D));
  end;

begin
  {The following code provides the user the ability to enter dates
  using text descriptions.  All descriptions assume the current
  date as a reference date.  The following descriptions are currently
  supported:
    <day of week>              Next is assumed; may be abbreviated -- 1st 3 chars
    Next <day of week>
    Last                       current day of week is assumed
    Last <day of week>
    First  | 1st               current day of week is assumed
    First  | 1st <day of week>
    Second | 2nd               current day of week is assumed
    Second | 2nd <day of week>
    Third  | 3rd               current day of week is assumed
    Third  | 3rd <day of week>
    Fourth | 4th               current day of week is assumed
    Fourth | 4th <day of week>
    Final  | lst               current day of week is assumed
    Final  | lst <day of week>
    BOM    | Begin             returns first day of current month
    EOM    | End               returns last day of current month
    Yesterday                  returns yesterday's date
    Today                      returns today's date
    Tomorrow                   returns tomorrow's date}

  S := AnsiUppercase(Value);
  if Pos(GetOrphStr(SCCalYesterday), S) > 0 then begin
    Result := FormatDate(StDateToDateTime(DateTimeToStDate(SysUtils.Date) - 1));
  end else if Pos(GetOrphStr(SCCalToday), S) > 0 then begin
    Result := FormatDate(StDateToDateTime(DateTimeToStDate(SysUtils.Date)));
  end else if Pos(GetOrphStr(SCCalTomorrow), S) > 0 then begin
    Result := FormatDate(StDateToDateTime(DateTimeToStDate(SysUtils.Date) + 1));
  end else if Pos(GetOrphStr(SCCalNext), S) > 0 then begin
    Increment   := 1;
    Occurrence  := 1;
    StartDate   := DateTimeToStDate(SysUtils.Date);
    DefaultDate := StartDate + 7;
    DoSetDate;
  end else if Pos(GetOrphStr(SCCalLast), S) > 0 then begin
    Increment   := -1;
    Occurrence  := 1;
    StartDate   := DateTimeToStDate(SysUtils.Date);
    DefaultDate := StartDate - 7;
    DoSetDate;
  end else if Pos(GetOrphStr(SCCalPrev), S) > 0 then begin
    Increment   := -1;
    Occurrence  := 1;
    StartDate   := DateTimeToStDate(SysUtils.Date);
    DefaultDate := StartDate - 7;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalFirst), S) > 0)
           or (Pos(GetOrphStr(SCCal1st), S) > 0) then begin
    Increment   := 1;
    Occurrence  := 1;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(1, ThisMonth, ThisYear, Epoch) - 1;
    DefaultDate := 0;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalSecond), S) > 0)
           or (Pos(GetOrphStr(SCCal2nd), S) > 0) then begin
    Increment   := 1;
    Occurrence  := 2;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(1, ThisMonth, ThisYear, Epoch) - 1;
    DefaultDate := 0;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalThird), S) > 0)
           or (Pos(GetOrphStr(SCCal3rd), S) > 0) then begin
    Increment   := 1;
    Occurrence  := 3;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(1, ThisMonth, ThisYear, Epoch) - 1;
    DefaultDate := 0;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalFourth), S) > 0)
           or (Pos(GetOrphStr(SCCal4th), S) > 0) then begin
    Increment   := 1;
    Occurrence  := 4;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(1, ThisMonth, ThisYear, Epoch) - 1;
    DefaultDate := 0;
    DoSetDate;
  end else if Pos(GetOrphStr(SCCalFinal), S) > 0 then begin
    Increment   := -1;
    Occurrence  := 1;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(DaysInMonth(ThisMonth,
                                           ThisYear, Epoch),
                                ThisMonth, ThisYear, Epoch) + 1;
    DefaultDate := 0;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalBOM), S) > 0)
           or (Pos(GetOrphStr(SCCalBegin), S) > 0) then begin
    Increment   := 0;
    Occurrence  := 0;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(1, ThisMonth, ThisYear, Epoch);
    DefaultDate := StartDate;
    DoSetDate;
  end else if (Pos(GetOrphStr(SCCalEOM), S) > 0)
           or (Pos(GetOrphStr(SCCalEnd), S) > 0) then begin
    Increment   := 0;
    Occurrence  := 0;
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    StartDate   := DMYToStDate(DaysInMonth(ThisMonth,
                                           ThisYear, Epoch),
                                ThisMonth, ThisYear, Epoch);
    DefaultDate := StartDate;
    DoSetDate;
  end else begin
    Increment   := 1;
    Occurrence  := 1;
    StartDate   := DateTimeToStDate(SysUtils.Date);
    DefaultDate := -1;
    DoSetDate;
  end;
end;

procedure TOvcCustomDateEdit.PopupClose(Sender : TObject);
begin
  if not FCalendar.Visible then
  {already closed, exit}
    Exit;

  if PopupClosing then
    Exit;

  {avoid recursion}
  PopupClosing := True;

  try
    inherited PopupClose(Sender);

    if GetCapture = FCalendar.Handle then
      ReleaseCapture;

    SetFocus;
    {hide the Calendar}
    FCalendar.Hide;
    if FCalendar.Parent is TForm then
      TForm(FCalendar.Parent).AutoScroll := WasAutoScroll;

    Cursor := HoldCursor;

    {change parentage so that we control the window handle destruction}
    FCalendar.Parent := Self;
  finally
    PopupClosing := False;
  end;
end;

procedure TOvcCustomDateEdit.PopupKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
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
    VK_UP  :
      begin
        if Shift = [ssAlt] then begin
          PopupClose(Sender);
          X := SelStart;
          SetFocus;
          SelStart := X;
          SelLength := 0;
        end;
      end;
  end;
end;

procedure TOvcCustomDateEdit.PopupKeyPress(Sender : TObject; var Key : Char);
var
  X : Integer;
begin
  case Key of
    #13,
    #32,
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

procedure TOvcCustomDateEdit.PopupMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  P : TPoint;
  I : Integer;
begin
  P := Point(X,Y);
  if not PtInRect(FCalendar.ClientRect, P) then
    PopUpClose(Sender);

  {convert to our coordinate system}
  P := ScreenToClient(FCalendar.ClientToScreen(P));

  if PtInRect(ClientRect, P) then begin
    I := SelStart;
    SetFocus;
    SelStart := I;
    SelLength := 0;
  end;
end;

procedure TOvcCustomDateEdit.PopupOpen;
var
  P       : TPoint;
  R       : TRect;
  F       : TCustomForm;
  MonInfo : TMonitorInfo;
begin
  if FCalendar.Visible then
  {already popped up, exit}
    Exit;

  inherited PopupOpen;

  {force update of date}
  DoExit;

  FCalendar.Parent := GetParentForm(Self);
  if FCalendar.Parent is TForm then begin
    WasAutoScroll := TForm(FCalendar.Parent).AutoScroll;
    TForm(FCalendar.Parent).AutoScroll := False;
  end;

  {set 3d to be the same as our own}
  FCalendar.ParentCtl3D  := False;
  FCalendar.Ctl3D := False;

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
    P := ClientToScreen(Point(Width-FCalendar.Width-1, Height-2));
  if not Ctl3D then begin
    Inc(P.X, 3);
    Inc(P.Y, 3);
  end;
  if P.Y + FCalendar.Height >= R.Bottom then
    P.Y := P.Y - FCalendar.Height - Height;
  if P.X + FCalendar.Width >= R.Right then
    P.X := R.Right - FCalendar.Width - 1;
  if P.X <= R.Left then
    P.X := R.Left + 1;

  MoveWindow(FCalendar.Handle, P.X, P.Y, FCalendar.Width, FCalendar.Height, False);

  if Text = '' then
    FCalendar.Date := SysUtils.Date
  else
    FCalendar.Date := FDate;

  HoldCursor := Cursor;
  Cursor := crArrow;
  FCalendar.Show;
  FCalendar.SetFocus;

  SetCapture(FCalendar.Handle);
end;

procedure TOvcCustomDateEdit.PopupDateChange(Sender : TObject; Date : TDateTime);
begin
  {get the current value}
  SetDate(FCalendar.Date);
  Modified := True;

  if FCalendar.Browsing then
    Exit;

  {hide the Calendar}
  PopupClose(Sender);
  SetFocus;
  SelStart := Length(Text);
  SelLength := 0;
end;

procedure TOvcCustomDateEdit.SetDate(Value : TDateTime);
begin
  FDate := Value;
  Modified := True;

  if FDate = 0 then
    Text := ''
  else
    Text := FormatDate(FDate);

  if Assigned(FOnSetDate) then
    FOnSetDate(Self);
end;

procedure TOvcCustomDateEdit.SetDateText(Value : string);
var
  Field      : Integer;
  I1         : Integer;
  I2         : Integer;
  Error      : Integer;
  ThisYear   : Word;
  ThisMonth  : Word;
  ThisDay    : Word;
  Year       : Word;
  Month      : Word;
  Day        : Word;
  EpochYear  : Integer;
  EpochCent  : Integer;
  StringList : TStringList;
  FieldOrder : string[3];
  S          : string;
begin
  if Assigned(FOnPreParseDate) then
    FOnPreParseDate(Self, Value);
  Value := ParseDate(Value);

  if Assigned(FOnGetDate) then
    FOnGetDate(Self, Value);

  if (Value = '') and (FRequiredFields <> []) then begin
    FDate := 0;
    Text := '';
    Exit;
  end;

  if AnsiCompareText(Value, TodayString) = 0 then begin
    SetDate(SysUtils.Date);
    Text := FormatDate(FDate);
  end else begin
    DecodeDate(SysUtils.Date, ThisYear, ThisMonth, ThisDay);
    Value := AnsiUpperCase(Value);
    StringList := TStringList.Create;
    try
      {parse the string into subfields using a string list to hold the parts}
      I1 := 1;
      while (I1 <= Length(Value)) and not CharInSet(Value[I1], ['0'..'9', 'A'..'Z']) do
        Inc(I1);
      while I1 <= Length(Value) do begin
        I2 := I1;
        while (I2 <= Length(Value)) and CharInSet(Value[I2], ['0'..'9', 'A'..'Z']) do
          Inc(I2);
        StringList.Add(Copy(Value, I1, I2-I1));
        while (I2 <= Length(Value)) and not CharInSet(Value[I2], ['0'..'9', 'A'..'Z']) do
          Inc(I2);
        I1 := I2;
      end;

      case DateOrder of
        doMDY : FieldOrder := 'MDY';
        doDMY : FieldOrder := 'DMY';
        doYMD : FieldOrder := 'YMD';
      end;

      Year := 0;
      Month := 0;
      Day := 0;
      Error := 0;
      for Field := 1 to Length(FieldOrder) do begin
        if StringList.Count > 0 then
          S := StringList[0]
        else
          S := '';

        case FieldOrder[Field] of
          'M' :
            begin
              if (S = '') or CharInSet(S[1], ['0'..'9']) then begin
              {numeric month}
                try
                  if S = '' then
                    Month := 0
                  else
                    Month := StrToInt(S);
                except
                  Month := 0;
                  {error converting month number}
                  Error := SCMonthConvertError;
                end;
                if not (Month in [1..12]) then
                  Month := 0;
              end else begin
              {one or more letters in month}
                Month := 0;
                I1 := 1;
                S := Copy(S, 1, 3);
                {error converting month name}
                Error := SCMonthNameConvertError;
                repeat
                  if S = AnsiUpperCase(Copy(FormatSettings.ShortMonthNames[I1], 1, Length(S))) then begin
                    Month := I1;
                    I1 := 13;
                    Error := 0;
                  end else
                    Inc(I1);
                until I1 = 13;
              end;

              if Month = 0 then begin
                if rfMonth in FRequiredFields then
                {month required}
                  Error := SCMonthRequired
                else
                  Month := ThisMonth;
              end else if StringList.Count > 0 then
                StringList.Delete(0);

              if Error > 0 then
                Break;
            end;
          'Y' :
            begin
              try
                if S = '' then
                  Year := 0
                else
                  Year := StrToInt(S);
              except
                Year := 0;
                {error converting year}
                Error := SCYearConvertError;
              end;
              if (Epoch = 0) and (Year < 100) and (S <> '') then
                {default to current century if Epoch is zero}
                Year := Year + (ThisYear div 100 * 100)
              else if (Epoch > 0) and (Year < 100) and (S <> '') then begin
                {use epoch}
                EpochYear := Epoch mod 100;
                EpochCent := (Epoch div 100) * 100;
                if (Year < EpochYear) then
                  Inc(Year,EpochCent+100)
                else
                  Inc(Year,EpochCent);
              end;
              if Year = 0 then begin
                if rfYear in FRequiredFields then
                {year is required}
                  Error := SCYearRequired
                else
                  Year := ThisYear;
              end else if StringList.Count > 0 then
                StringList.Delete(0);
              if Error > 0 then
                Break;
            end;
          'D' :
            begin
              try
                if S = '' then
                  Day := 0
                else
                  Day := StrToInt(S);
              except
                Day := 0;
                {error converting day}
                Error := SCDayConvertError;
              end;
              if not (Day in [1..31]) then
                Day := 0;
              if Day = 0 then begin
                if rfDay in FRequiredFields then
                {day is required}
                  Error := SCDayRequired
                else
                  Day := ThisDay;
                end
              else if StringList.Count > 0 then
                StringList.Delete(0);

              if Error > 0 then
                Break;
            end;
        end;
      end;

      case Error of
        SCDayConvertError :
          if S = '' then
            raise EOvcException.Create(
              GetOrphStr(SCInvalidDay) + ' "' + Value + '"')
          else
            raise EOvcException.Create(
              GetOrphStr(SCInvalidDay) + ' "' + S + '"');
        SCMonthConvertError :
          if S = '' then
            raise EOvcException.Create(
              GetOrphStr(SCInvalidMonth) + ' "' + Value + '"')
          else
            raise EOvcException.Create(
              GetOrphStr(SCInvalidMonth) + ' "' + S + '"');
        SCMonthNameConvertError :
          if S = '' then
            raise EOvcException.Create(
              GetOrphStr(SCInvalidMonthName) + ' "' + Value + '"')
          else
            raise EOvcException.Create(
              GetOrphStr(SCInvalidMonthName) + ' "' + S + '"');
        SCYearConvertError :
          if S = '' then
            raise EOvcException.Create(
              GetOrphStr(SCInvalidYear) + ' "' + Value + '"')
          else
            raise EOvcException.Create(
              GetOrphStr(SCInvalidYear) + ' "' + S + '"');
        SCDayRequired :
          raise EOvcException.Create(
            GetOrphStr(SCDayRequired));
        SCMonthRequired :
          raise EOvcException.Create(
            GetOrphStr(SCMonthRequired));
        SCYearRequired :
          raise EOvcException.Create(
            GetOrphStr(SCYearRequired));
      end;

      try
        SetDate(STDatetoDateTime(DMYToStDate(Day, Month, Year, Epoch)));
        Text := FormatDate(FDate);
      except
        raise EOvcException.Create(
          GetOrphStr(SCInvalidDate) + ' "' + Value + '"');
      end;

    finally
      StringList.Free;
    end;
  end;
end;

procedure TOvcCustomDateEdit.SetEpoch(Value : Integer);
begin
  if Value <> FEpoch then
    if (Value = 0) or ((Value >= MinYear) and (Value <= MaxYear)) then
      FEpoch := Value;
end;

procedure TOvcCustomDateEdit.SetForceCentury(Value : Boolean);
begin
  if Value <> FForceCentury then begin
    FForceCentury := Value;
    SetDate(FCalendar.Date);
  end;
end;

procedure TOvcCustomDateEdit.SetPopupColors(Value : TOvcCalColors);
begin
  FCalendar.Colors := Value;
end;

procedure TOvcCustomDateEdit.SetPopupDateFormat(Value : TOvcDateFormat);
begin
  FCalendar.DateFormat := Value;
end;

procedure TOvcCustomDateEdit.SetPopupFont(Value : TFont);
begin
  if Assigned(Value) then
    FCalendar.Font.Assign(Value);
end;

procedure TOvcCustomDateEdit.SetPopupHeight(Value : Integer);
begin
  FCalendar.Height := Value;
end;

procedure TOvcCustomDateEdit.SetPopupDayNameWidth(Value : TOvcDayNameWidth);
begin
  FCalendar.DayNameWidth := Value;
end;

procedure TOvcCustomDateEdit.SetPopupOptions(Value : TOvcCalDisplayOptions);
begin
  FCalendar.Options := Value;
end;

procedure TOvcCustomDateEdit.SetPopupWidth(Value : Integer);
begin
  FCalendar.Width := Value;
end;

procedure TOvcCustomDateEdit.SetPopupWeekStarts(Value : TOvcDayType);
begin
  FCalendar.WeekStarts := Value;
end;

procedure TOvcCustomDateEdit.SetReadOnly(Value : Boolean);
begin
  inherited ReadOnly := Value;

  FButton.Enabled := not ReadOnly;
end;

end.

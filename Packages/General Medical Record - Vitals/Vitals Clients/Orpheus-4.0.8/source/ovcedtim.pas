{*********************************************************}
{*                  OVCEDTIM.PAS 4.06                    *}
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

unit ovcedtim;
  {-time edit field}

interface

uses
  Windows, Buttons, Classes, Controls, Forms, Graphics, Menus, Messages,
  StdCtrls, SysUtils, OvcConst, OvcData, OvcExcpt, OvcIntl, OvcMisc,
  OvcEditF, OvcDate;

type
  TOvcTimeField = (tfHours, tfMinutes, tfSeconds);
  TOvcTimeMode = (tmClock, tmDuration);
  TOvcDurationDisplay = (ddHMS, ddHM, ddMS, ddHHH, ddMMM, ddSSS);

  TOvcGetTimeEvent = procedure(Sender : TObject; var Value : string)
    of object;
  TOvcPreParseTimeEvent = procedure(Sender : TObject; var Value : string)
    of object;

  TOvcCustomTimeEdit = class(TOvcCustomEdit)
  

  protected {private}
    {property variables}
    FDurationDisplay     : TOvcDurationDisplay;
    FNowString           : string;
    FDefaultToPM         : Boolean;
    FPrimaryField        : TOvcTimeField;
    FShowSeconds         : Boolean;
    FShowUnits           : Boolean;
    FTime                : TDateTime;
    FTimeMode            : TOvcTimeMode;
    FUnitsLength         : Integer;

    {event variables}
    FOnGetTime           : TOvcGetTimeEvent;
    FOnPreParseTime      : TOvcPreParseTimeEvent;
    FOnSetTime           : TNotifyEvent;

    {property methods}
    function GetAsHours : Integer;
    function GetAsMinutes : Integer;
    function GetAsSeconds : Integer;
    function GetTime : TDateTime;
    procedure SetAsHours(Value : Integer);
    procedure SetAsMinutes(Value : Integer);
    procedure SetAsSeconds(Value : Integer);
    procedure SetDurationDisplay(Value : TOvcDurationDisplay);
    procedure SetShowSeconds(Value : Boolean);
    procedure SetShowUnits(Value : Boolean);
    procedure SetTimeMode(Value : TOvcTimeMode);
    procedure SetUnitsLength(Value : Integer);

    {internal methods}
     procedure ParseFields(const Value : string; S : TStringList);

  protected
    procedure DoExit;
      override;
    procedure SetTime(Value : TDateTime);
    procedure SetTimeText(Value : string);
      dynamic;


    {protected properties}
    property DefaultToPM  : Boolean
      read FDefaultToPM write FDefaultToPM;
    property DurationDisplay : TOvcDurationDisplay
      read FDurationDisplay write SetDurationDisplay;
    property NowString : string
      read FNowString write FNowString;
    property PrimaryField : TOvcTimeField
      read FPrimaryField write FPrimaryField;
    property ShowSeconds : Boolean
      read FShowSeconds write SetShowSeconds;
    property ShowUnits : Boolean
      read FShowUnits write SetShowUnits;
    property TimeMode : TOvcTimeMode
      read FTimeMode write SetTimeMode;
    property UnitsLength : Integer
      read FUnitsLength write SetUnitsLength;

    {protected events}
    property OnGetTime : TOvcGetTimeEvent
      read FOnGetTime write FOnGetTime;
    property OnPreParseTime : TOvcPreParseTimeEvent
      read FOnPreParseTime write FOnPreParseTime;
    property OnSetTime : TNotifyEvent
      read FOnSetTime write FOnSetTime;

  public
  

    constructor Create(AOwner : TComponent);
      override;


     function FormatTime(Value : TDateTime) : string;
      dynamic;

    {public properties}
    property AsDateTime : TDateTime
      read GetTime write SetTime;
    property AsHours : Integer
      read GetAsHours write SetAsHours;
    property AsMinutes : Integer
      read GetAsMinutes write SetAsMinutes;
    property AsSeconds : Integer
      read GetAsSeconds write SetAsSeconds;
  end;

  TOvcTimeEdit = class(TOvcCustomTimeEdit)
  published
    {properties}
    property Anchors;
    property Constraints;
    property DragKind;
    property About;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Controller;
    property Ctl3D;
    property Cursor;
    property DefaultToPM;
    property DragCursor;
    property DragMode;
    property DurationDisplay;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property LabelInfo;
    property MaxLength;
    property NowString;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property PrimaryField;
    property ReadOnly;
    property ShowHint;
    property ShowSeconds;
    property ShowUnits;
    property TabOrder;
    property TabStop;
    property TimeMode;
    property UnitsLength;
    property Visible;

    {inherited events}
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetTime;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPreParseTime;
    property OnSetTime;
    property OnStartDrag;
  end;


implementation

uses
  OVCStr, OvcFormatSettings;

procedure DateTimeToHMS(D : TDateTime; var H, M, S : Integer);
var
  HS, Days : Double;
begin
  HS := 1 / 86400 / 2; {half second portion of a day}
  Days := Trunc(D);
  D := (D-Days) * 24;
  H := Trunc(D + HS);
  D := (D - H) * 60;
  M := Trunc(D + HS);
  S := Trunc((D - M + HS) * 60);
  H := Trunc(H  + Days * 24);
end;

function HMSToDateTime(H, M, S : Integer) : TDateTime;
var
  HID, MID, SID : Double;
begin
  HID := 24;
  MID := 24*60;
  SID := 24*60*60;
  Result := H / HID + M / MID + S / SID;
end;

{*** TOvcCustomTimeEdit ***}

constructor TOvcCustomTimeEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  FDurationDisplay := ddHMS;
  FPrimaryField    := tfHours;
  FNowString       := FormatSettings.TimeSeparator;
  FShowSeconds     := False;
  FTime            := SysUtils.Time;
  FTimeMode        := tmClock;
  FUnitsLength     := 1;
end;

procedure TOvcCustomTimeEdit.DoExit;
begin
  try
    SetTimeText(Text);
  except
    SetFocus;
    raise;
  end;
  inherited DoExit;
end;

function TOvcCustomTimeEdit.FormatTime(Value : TDateTime) : string;
var
  H, M, S  : Integer;
  TimeMask : string;
begin
  TimeMask := OvcIntlSup.InternationalTime(FShowSeconds);

  if FTimeMode = tmClock then
    Result := OvcIntlSup.TimeToTimeString(TimeMask, DateTimeToSTTime(Value), False)
  else begin
    DateTimeToHMS(Value, H, M, S);
    if FShowUnits then begin
      case FDurationDisplay of
        ddHMS : Result :=
          IntToStr(H) + ' ' + Copy(GetOrphStr(SCHoursName), 1, FUnitsLength) + ' ' +
          InttoStr(M) + ' ' + Copy(GetOrphStr(SCMinutesName), 1, FUnitsLength) + ' ' +
          InttoStr(S) + ' ' + Copy(GetOrphStr(SCSecondsName), 1, FUnitsLength);
        ddHM  : Result :=
          IntToStr(H) + ' ' + Copy(GetOrphStr(SCHoursName), 1, FUnitsLength) + ' ' +
          InttoStr(M) + ' ' + Copy(GetOrphStr(SCMinutesName), 1, FUnitsLength);
        ddMS  : Result :=
          InttoStr(H*60+M) + ' ' + Copy(GetOrphStr(SCMinutesName), 1, FUnitsLength) + ' ' +
          InttoStr(S) + ' ' + Copy(GetOrphStr(SCSecondsName), 1, FUnitsLength);
        ddHHH : Result :=
          IntToStr(H) + ' ' + Copy(GetOrphStr(SCHoursName), 1, FUnitsLength);
        ddMMM : Result :=
          InttoStr(H*60+M) + ' ' + Copy(GetOrphStr(SCMinutesName), 1, FUnitsLength);
        ddSSS : Result :=
          InttoStr((H*60+M)*60+S) + ' ' + Copy(GetOrphStr(SCSecondsName), 1, FUnitsLength);
      end;
    end else begin
      case FDurationDisplay of
        ddHMS : Result := IntToStr(H) + FormatSettings.TimeSeparator + InttoStr(M) + FormatSettings.TimeSeparator + InttoStr(S);
        ddHM  : Result := IntToStr(H) + FormatSettings.TimeSeparator + InttoStr(M);
        ddMS  : Result := IntToStr(H*60+M) + FormatSettings.TimeSeparator + InttoStr(S);
        ddHHH : Result := IntToStr(H);
        ddMMM : Result := IntToStr(H*60+M);
        ddSSS : Result := IntToStr((H*60+M)*60+S);
      end;
    end;
  end;
end;

function TOvcCustomTimeEdit.GetAsHours : Integer;
var
  H, M, S  : Integer;
begin
  DateTimeToHMS(FTime, H, M, S);
  Result := H;
end;

function TOvcCustomTimeEdit.GetAsMinutes : Integer;
var
  H, M, S  : Integer;
begin
  DateTimeToHMS(FTime, H, M, S);
  Result := H*60+M;
end;

function TOvcCustomTimeEdit.GetAsSeconds : Integer;
var
  H, M, S  : Integer;
begin
  DateTimeToHMS(FTime, H, M, S);
  Result := (H*60+M)*60+S;
end;

function TOvcCustomTimeEdit.GetTime : TDateTime;
begin
  SetTimeText(Text);
  Result := FTime;
end;

procedure TOvcCustomTimeEdit.SetAsHours(Value : Integer);
var
  D, H : Integer;
begin
  H := Value;
  D := H div 24;
  H := H - D * 24;
  SetTime(D + EncodeTime(H, 0, 0, 0));
end;

procedure TOvcCustomTimeEdit.SetAsMinutes(Value : Integer);
var
  D, H, M : Integer;
begin
  M := Value;
  D := M div (24 * 60);
  M := M - D * (24 * 60);
  H := M div 60;
  M := M - H * 60;
  SetTime(D + EncodeTime(H, M, 0, 0));
end;

procedure TOvcCustomTimeEdit.SetAsSeconds(Value : Integer);
var
  D, H, M, S : Integer;
begin
  S := Value;
  D := S div (24 * 60 * 60);
  S := S - D * (24 * 60 * 60);
  H := S div (60 * 60);
  S := S - H * (60 * 60);
  M := S div 60;
  S := S - M * 60;
  SetTime(D + EncodeTime(H, M, S, 0));
end;

procedure TOvcCustomTimeEdit.SetDurationDisplay(Value : TOvcDurationDisplay);
begin
  if Value <> FDurationDisplay then begin
    FDurationDisplay := Value;
    if not (csLoading in ComponentState) then
      SetTime(FTime); {force redisplay with current options}
  end;
end;

procedure TOvcCustomTimeEdit.SetShowSeconds(Value : Boolean);
begin
  if Value <> FShowSeconds then begin
    FShowSeconds := Value;
    if not (csLoading in ComponentState) then
      SetTime(FTime); {force redisplay with current options}
  end;
end;

procedure TOvcCustomTimeEdit.SetShowUnits(Value : Boolean);
begin
  if Value <> FShowUnits then begin
    FShowUnits := Value;
    if not (csLoading in ComponentState) then
      SetTime(FTime); {force redisplay with current options}
  end;
end;

procedure TOvcCustomTimeEdit.SetTime(Value : TDateTime);
begin
  FTime := Value;
  Modified := True;

  if FTime < 0 then
    Text := ''
  else
    Text := FormatTime(FTime);

  if Assigned(FOnSetTime) then
    FOnSetTime(Self);
end;

procedure TOvcCustomTimeEdit.SetTimeMode(Value : TOvcTimeMode);
begin
  if Value <> FTimeMode then begin
    FTimeMode := Value;
    if not (csLoading in ComponentState) then
      SetTime(FTime); {force redisplay with current options}
  end;
end;

procedure TOvcCustomTimeEdit.ParseFields(const Value : string; S : TStringList);
var
  I  : Integer;
  I1 : Integer;
  I2 : Integer;
  T  : string;
begin
  {parse the string into subfields using a string list to hold the parts}
  I1 := 1;
  while (I1 <= Length(Value)) and not CharInSet(Value[I1], ['0'..'9', 'A'..'Z']) do
    Inc(I1);
  while I1 <= Length(Value) do begin
    I2 := I1;
    while (I2 <= Length(Value)) and CharInSet(Value[I2], ['0'..'9', 'A'..'Z']) do
      Inc(I2);

    T := Copy(Value, I1, I2-I1);
    {if this is a combination of numbers and letters without sperators}
    {representing multiple fields, split them up}
    while Length(T) > 0 do begin
      I := 1;
      case T[1] of
        'A'..'Z' : while CharInSet(T[I], ['A'..'Z']) do Inc(I);
        '0'..'9' : while CharInSet(T[I], ['0'..'9']) do Inc(I);
      end;
      S.Add(Copy(T, 1, I-1));
      Delete(T, 1, I-1);
    end;

    while (I2 <= Length(Value)) and not CharInSet(Value[I2], ['0'..'9', 'A'..'Z']) do
      Inc(I2);
    I1 := I2;
  end;
end;

procedure TOvcCustomTimeEdit.SetTimeText(Value : string);
var
  Field        : Integer;
  Error        : Integer;
  Hours        : Integer;
  Minutes      : Integer;
  Seconds      : Integer;
  FieldList    : TStringList;
  S            : string;
  FieldCount   : Integer;
  Am, Pm, AmPm : string;
  FoundUnits   : Boolean;
  V            : Integer;
begin
  if Assigned(FOnPreParseTime) then
    FOnPreParseTime(Self, Value);

  if Assigned(FOnGetTime) then
    FOnGetTime(Self, Value);

  if (Value = '') then begin
    FTime := 0;
    Text := '';
    Exit;
  end;

  if AnsiCompareText(Value, NowString) = 0 then begin
    SetTime(SysUtils.Time);
    Text := FormatTime(FTime);
  end else begin
    Value := AnsiUpperCase(Value);
    FieldList := TStringList.Create;
    try
      {break entry into fields}
      ParseFields(Value, FieldList);

      Hours := -1;
      Minutes := -1;
      Seconds := -1;
      if FTimeMode = tmDuration then begin
        {if a single field entered, assume primary field}
        if FieldList.Count = 1 then begin
          case FPrimaryField of
            tfHours   : Hours := StrToIntDef(FieldList[0], -1);
            tfMinutes : Minutes := StrToIntDef(FieldList[0], -1);
            tfSeconds : Seconds := StrToIntDef(FieldList[0], -1);
          end;
        end else begin
          FieldCount := FieldList.Count;
          FoundUnits := False;
          for Field := 1 to FieldCount do begin
            if FoundUnits then begin
              FoundUnits := False;
              Continue; {skip this field - it is a unit field}
            end;
            S := FieldList[Field-1];
            V := StrToIntDef(S, -1);
            {if more fields, see if next field is units for this one}
            if Field < FieldCount then begin
              S := FieldList[Field]; {get next field value}
              if not CharInSet(S[1], ['0'..'9']) then begin
                if PartialCompare(S, GetOrphStr(SCHoursName)) then begin
                  Hours := V;
                  FoundUnits := True;
                end else if PartialCompare(S, GetOrphStr(SCMinutesName)) then begin
                  Minutes := V;
                  FoundUnits := True;
                end else if PartialCompare(S, GetOrphStr(SCSecondsName)) then begin
                  Seconds := V;
                  FoundUnits := True;
                end;
              end;
            end;
            {uses "logical" units for the time field based on prior fields}
            if not FoundUnits then begin
              if Hours = -1 then
                Hours := V
              else if Minutes = -1 then
                Minutes := V
              else if Seconds = -1 then
                Seconds := V;
            end;
          end;
        end;

        {if a value assigned, set time and exit}
        if (Hours > -1) or (Minutes > -1) or (Seconds > -1) then begin
          if Hours = -1 then
            Hours := 0;
          if Minutes = -1 then
            Minutes := 0;
          if Seconds = -1 then
            Seconds := 0;
          SetTime(HMSToDateTime(Hours, Minutes, Seconds));
          Exit;
        end;
      end;

      {handle as "normal" time -- "hh:mm:ss tt" format or variations}
      Hours := 0;
      Minutes := 0;
      Seconds := 0;
      Error := 0;

      {set default am/pm}
      {in case user has deleted these window settings}
      if (FormatSettings.TimeAmString > '') and (FormatSettings.TimePmString > '') then begin
        Am := AnsiUpperCase(FormatSettings.TimeAmString[1]);
        Pm := AnsiUpperCase(FormatSettings.TimePmString[1]);
      end else begin
        Am := 'A';
        Pm := 'P'
      end;
      if FDefaultToPM then
        AmPm := Pm
      else
        AmPm := Am;

      {see if we're using a 24 hour time format}
      if (Pos(Am, FormatSettings.ShortTimeFormat) = 0) and
         (Pos(Pm, FormatSettings.ShortTimeFormat) = 0) then
        AmPm := '';

      FieldCount := FieldList.Count;
      for Field := FieldCount-1 downto 0 do begin
        S := AnsiUpperCase(FieldList[Field]);
        if Pos(Am, S) > 0 then begin
          AmPm := Am;
          FieldList.Delete(Field);
          Continue;
        end;
        if Pos(Pm, S) > 0 then begin
          AmPm := Pm;
          FieldList.Delete(Field);
          Continue;
        end;
      end;

      FieldCount := FieldList.Count;
      for Field := 1 to FieldCount do begin
        S := FieldList[Field-1];
        case Field of
          1 :
            begin
              if (S = '') or CharInSet(S[1], ['0'..'9']) then begin
                V := StrToIntDef(S, 0);
                if FTimeMode = tmDuration then begin
                  case FPrimaryField of
                    tfHours   : Hours := V;
                    tfMinutes : Minutes := V;
                    tfSeconds : Seconds := V;
                  end;
                end else begin
                  Hours := V;
                  if (Hours < 12) and (AmPm = Pm) then
                    Inc(Hours, 12);
                  if not (Hours in [0..23]) then
                    Error := SCTimeConvertError;
                end;
              end;
              if Error > 0 then
                Break;
            end;
          2 :
            begin
              if (S = '') or CharInSet(S[1], ['0'..'9']) then begin
                V := StrToIntDef(S, 0);
                if FTimeMode = tmDuration then begin
                  case FPrimaryField of
                    tfHours   : Minutes := V;
                    tfMinutes : Seconds := V;
                  end;
                end else begin
                  Minutes := V;
                  if not (Minutes in [0..59]) then
                    Error := SCTimeConvertError;
                end;
              end;
              if Error > 0 then
                Break;
            end;
          3 :
            begin
              if (S = '') or CharInSet(S[1], ['0'..'9']) then begin
                V := StrToIntDef(S, 0);
                if FTimeMode = tmDuration then begin
                  case FPrimaryField of
                    tfHours   : Seconds := V;
                  end;
                end else begin
                  Seconds := V;
                  if not (Seconds in [0..59]) then
                    Error := SCTimeConvertError;
                end;
              end;
              if Error > 0 then
                Break;
            end;
        end;
      end;

      {special handling for times at or just after midnight}
      if (AmPm = Am) then
        if (Hours = 12) or (Hours = 24) then
          Hours := 0;

      if Error > 0 then
        raise EOvcException.Create(GetOrphStr(Error) + ' "' + Value + '"');

      SetTime(HMSToDateTime(Hours, Minutes, Seconds));

    finally
      FieldList.Free;
    end;

  end;
end;

procedure TOvcCustomTimeEdit.SetUnitsLength(Value : Integer);
begin
  if Value <> FUnitsLength then begin
    FUnitsLength := Value;
    if not (csLoading in ComponentState) then
      SetTime(FTime); {force redisplay with current options}
  end;
end;


end.

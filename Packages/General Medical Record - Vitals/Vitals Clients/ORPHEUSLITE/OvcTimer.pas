{*********************************************************}
{*                  OVCTIMER.PAS 4.06                    *}
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

{$IFDEF VERSION6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}


unit ovctimer;
  {-Timer Pool Component}

interface

uses
  Windows, Classes, Messages, SysUtils, Forms, OvcExcpt, OvcVer;

type
  TTriggerEvent =
    procedure(Sender : TObject; Handle : Integer; Interval : Cardinal; ElapsedTime : LongInt)
    of object;

type
  {.Z+}
  PEventRec       = ^TEventRec;
  TEventRec       = packed record
    erHandle      : Integer;        {handle of this event record}
    erInitTime    : LongInt;        {time when trigger was created}
    erElapsed     : LongInt;        {total elapsed time (ms)}
    erInterval    : Cardinal;       {trigger interval}
    erLastTrigger : LongInt;        {time last trigger was fired}
    erOnTrigger   : TTriggerEvent;  {method to call when fired}
    erEnabled     : Boolean;        {true if trigger is active}
    erRecurring   : Boolean;        {false for one time trigger}
  end;
  {.Z-}

type
  TOvcTimerPool = class(TComponent)
  {.Z+}
  protected {private}
    {property variables}
    FOnAllTriggers : TTriggerEvent;

    {internal variables}
    tpList         : TList;    {list of event TEventRec records}
    tpHandle       : hWnd;     {our window handle}
    tpInterval     : Cardinal; {the actual Window's timer interval}
    tpEnabledCount : Integer;  {count of active triggers}

    {property methods}
    function GetAbout : string;
    function GetElapsedTriggerTime(Handle : Integer) : LongInt;
    function GetElapsedTriggerTimeSec(Handle : Integer) : LongInt;
    function GetOnTrigger(Handle : Integer) : TTriggerEvent;
    function GetTriggerCount : Integer;
    function GetTriggerEnabled(Handle : Integer) : Boolean;
    function GetTriggerInterval(Handle : Integer) : Cardinal;
    procedure SetAbout(const Value : string);
    procedure SetOnTrigger(Handle : Integer; Value: TTriggerEvent);
    procedure SetTriggerEnabled(Handle : Integer; Value: Boolean);
    procedure SetTriggerInterval(Handle : Integer; Value: Cardinal);

    {internal methods}
    procedure tpCalcNewInterval;
      {-calculates the needed interval for the window's timer}
    function tpCountEnabledTriggers : Integer;
      {-returns the number of enabled/active timer triggers}
    function tpCreateTriggerHandle : Integer;
      {-returns a unique timer trigger handle}
    function tpEventIndex(Handle : Integer) : Integer;
      {-returns the internal list index corresponding to the trigger handle}
    procedure tpSortTriggers;
      {-sorts the internal list of timer trigger event records}
    procedure tpTimerWndProc(var Msg : TMessage);
      {-window procedure to catch timer messages}
    procedure tpUpdateTimer;
      {-re-create the windows timer with a new timer interval}

  protected
    procedure DoTriggerNotification;
      virtual;
      {-conditionally sends notification of all events}

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;
  {.Z-}

    function AddOneShot(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
      {-adds or updates one timer trigger. removed automatically after one firing}
    function AddOneTime(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
      {-adds a new timer trigger. removed automatically after one firing}
    function Add(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
      {-adds a new timer trigger and returns a handle}
    procedure Remove(Handle : Integer);
      {-removes the timer trigger}
    procedure RemoveAll;
      {-disable and destroy all timer triggers}
    procedure ResetElapsedTime(Handle : Integer);
      {-resets ElapsedTime for a given Trigger to 0}

    {public properties}
    property Count : Integer
      read GetTriggerCount;

    property ElapsedTime[Handle : Integer] : LongInt
      read GetElapsedTriggerTime;
    property ElapsedTimeSec[Handle : Integer] : LongInt
      read GetElapsedTriggerTimeSec;
    property Enabled[Handle : Integer] : Boolean
      read GetTriggerEnabled write SetTriggerEnabled;
    property Interval[Handle : Integer] : Cardinal
      read GetTriggerInterval write SetTriggerInterval;

    {events}
    property OnTrigger[Handle : Integer] : TTriggerEvent
      read GetOnTrigger write SetOnTrigger;

  published
    property About : string
      read GetAbout write SetAbout stored False;
    property OnAllTriggers : TTriggerEvent
      read FOnAllTriggers write FOnAllTriggers;
  end;


implementation
{$R-,Q-}

const
  tpDefMinInterval     = 55;     {smallest timer interval allowed}
  tpDefHalfMinInterval = tpDefMinInterval div 2;



{*** internal routines ***}

function NewEventRec : PEventRec;
begin
  GetMem(Result, SizeOf(TEventRec));
  FillChar(Result^, SizeOf(TEventRec), #0);
end;

procedure FreeEventRec(ER : PEventRec);
begin
  if (ER <> nil) then
    FreeMem(ER, SizeOf(TEventRec));
end;


{*** TOvcTimerPool ***}

constructor TOvcTimerPool.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {create internal list for trigger event records}
  tpList := TList.Create;

  {allocate a window handle for the timer}
  tpHandle := AllocateHWnd(tpTimerWndProc);
end;

destructor TOvcTimerPool.Destroy;
var
  I : Integer;
begin
  {force windows timer to be destroyed}
  tpInterval := 0;
  tpUpdateTimer;

  {free contents of list}
  for I := 0 to tpList.Count-1 do
    FreeEventRec(tpList[I]);

  {destroy the internal list}
  tpList.Free;
  tpList := nil;

  {deallocate our window handle}
  DeallocateHWnd(tpHandle);

  inherited Destroy;
end;

function TOvcTimerPool.AddOneShot(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
  {-adds or updates one timer trigger. removed automatically after one firing}
var
  I : Integer;
begin
  {if this OnTrigger handler is already installed, remove it}
  if Assigned(OnTrigger) then begin
    for I := 0 to tpList.Count-1 do
      with PEventRec(tpList[I])^ do
        if @erOnTrigger = @OnTrigger then begin
          Remove(erHandle);
          Break;
        end;
  end;
  {add the one-time trigger}
  Result := AddOneTime(OnTrigger, Interval);
end;

function TOvcTimerPool.AddOneTime(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
  {-adds a new timer trigger. removed automatically after one firing}
var
  I : Integer;
begin
  {add trigger}
  Result := Add(OnTrigger, Interval);

  {if added, set to non-recurring}
  if (Result > -1) then begin
    I := tpEventIndex(Result);
    if I > -1 then
      PEventRec(tpList[I])^.erRecurring := False
    else
      Result := -1;
  end;
end;

function TOvcTimerPool.Add(OnTrigger : TTriggerEvent; Interval : Cardinal) : Integer;
  {-adds a new timer trigger and returns a handle}
var
  ER : PEventRec;
begin
  Result := -1;  {assume error}
  {create new event record}
  ER := NewEventRec;
  if (ER = nil) then
    Exit;

  {force interval to be at least the minimum}
  if Interval < tpDefMinInterval then
    Interval := tpDefMinInterval;

  {fill event record}
  with ER^ do begin
    erEnabled     := True;
    erHandle      := tpCreateTriggerHandle;
    erInitTime    := GetTickCount;
    erElapsed     := 0;
    erInterval    := Interval;
    erLastTrigger := erInitTime;
    erOnTrigger   := OnTrigger;
    erRecurring   := True;
  end;

  {add trigger record to the list}
  tpList.Add(ER);

  {return the trigger event handle}
  Result := ER^.erHandle;

  {re-calculate the number of active triggers}
  tpEnabledCount := tpCountEnabledTriggers;

  {calculate new interval for the windows timer}
  tpCalcNewInterval;
  tpSortTriggers;
  tpUpdateTimer;
end;

procedure TOvcTimerPool.DoTriggerNotification;
  {-conditionally sends notification for all events}
var
  ER : PEventRec;
  TC : LongInt;
  I  : Integer;
  ET : longint;
begin
  TC := GetTickCount;

  {cycle through all triggers}
  I := 0;
  while I < tpList.Count do begin
    ER := PEventRec(tpList[I]);
    if ER^.erEnabled then begin
      {is it time to fire this trigger}
      if (TC < ER^.erLastTrigger) then
        ET := (High(LongInt) - ER^.erLastTrigger) + (TC - Low(LongInt))
      else
        ET := TC - ER^.erLastTrigger;

      if (ET >= LongInt(ER^.erInterval)-tpDefHalfMinInterval) then begin
        {update event record with this trigger time}
        ER^.erLastTrigger := TC;

        {check if total elapsed time for trigger >= MaxLongInt}
        if ((MaxLongInt - ER^.erElapsed) < ET) then
          ER^.erElapsed := MaxLongInt
        else
          ER^.erElapsed := ER^.erElapsed + ET;

{ - Moved}
        if not ER^.erRecurring then begin
          Remove(ER^.erHandle);
          Dec(I); {adjust loop index for this deletion}
        end;

        {call user event handler, if assigned}
        if Assigned(ER^.erOnTrigger) then
          ER^.erOnTrigger(Self, ER^.erHandle, ER^.erInterval, ER^.erElapsed);

        {call general event handler, if assigned}
        if Assigned(FOnAllTriggers) then
          FOnAllTriggers(Self, ER^.erHandle, ER^.erInterval, ER^.erElapsed);

{ - Moved up before the event handler calls}
(*
        if not ER^.erRecurring then begin
          Remove(ER^.erHandle);
          Dec(I); {adjust loop index for this deletion}
        end;
*)
      end;
    end;
    Inc(I);
  end;
end;

function TOvcTimerPool.GetElapsedTriggerTime(Handle : Integer) : LongInt;
  {-return the number of miliseconds since the timer trigger was created}
var
  I  : Integer;
  ET : longint;
  ER : PEventRec;
  TC : LongInt;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then begin
    ER := PEventRec(tpList[I]);
    if ER^.erElapsed = High(LongInt) then
      Result := High(LongInt)
    else begin
      TC := GetTickCount;
      if (TC < ER^.erInitTime) then begin
        ET := (High(LongInt) - ER^.erInitTime) + (TC - Low(LongInt));
        if (ET < ER^.erElapsed) then
          ER^.erElapsed := High(LongInt)
        else
          ER^.erElapsed := ET;
      end else
        ER^.erElapsed := TC - ER^.erInitTime;
      Result := ER^.erElapsed;
    end;
  end else
    raise EInvalidTriggerHandle.Create;
end;

function TOvcTimerPool.GetElapsedTriggerTimeSec(Handle : Integer) : LongInt;
  {-return the number of seconds since the timer trigger was created}
begin
  Result := GetElapsedTriggerTime(Handle) div 1000;
end;

function TOvcTimerPool.GetOnTrigger(Handle : Integer) : TTriggerEvent;
  {-returns the timer trigger's event method address}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then
    Result := PEventRec(tpList[I])^.erOnTrigger
  else
    raise EInvalidTriggerHandle.Create;
end;

function TOvcTimerPool.GetTriggerCount : Integer;
  {-returns the number of maintained timer triggers}
begin
  Result := tpList.Count;
end;

function TOvcTimerPool.GetTriggerEnabled(Handle : Integer) : Boolean;
  {-returns the timer trigger's enabled status}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then
    Result := PEventRec(tpList[I])^.erEnabled
  else
    raise EInvalidTriggerHandle.Create;
end;

function TOvcTimerPool.GetTriggerInterval(Handle : Integer) : Cardinal;
  {-returns the interval for the timer trigger with Handle}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then
    Result := PEventRec(tpList[I])^.erInterval
  else
    raise EInvalidTriggerHandle.Create;
end;

function TOvcTimerPool.GetAbout : string;
begin
  Result := OrVersionStr;
end;

procedure TOvcTimerPool.Remove(Handle : Integer);
  {-removes the timer trigger}
var
  ER : PEventRec;
  I  : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then begin
    ER := PEventRec(tpList[I]);
    tpList.Delete(I);
    FreeEventRec(ER);
    tpEnabledCount := tpCountEnabledTriggers;
    tpCalcNewInterval;
    tpUpdateTimer;
  end;
end;

procedure TOvcTimerPool.RemoveAll;
  {-disable and destroy all timer triggers}
var
  ER : PEventRec;
  I  : Integer;
begin
  for I := tpList.Count-1 downto 0 do begin
    ER := PEventRec(tpList[I]);
    tpList.Delete(I);
    FreeEventRec(ER);
  end;
  tpEnabledCount := 0;
  tpInterval := 0;
  tpUpdateTimer;
end;

procedure TOvcTimerPool.ResetElapsedTime(Handle : Integer);
  {-resets ElapsedTime for a given Trigger to 0}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then
    PEventRec(tpList[I])^.erInitTime := LongInt(GetTickCount)
  else
    raise EInvalidTriggerHandle.Create;
end;

procedure TOvcTimerPool.SetOnTrigger(Handle : Integer; Value: TTriggerEvent);
  {-sets the method to call when the timer trigger fires}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then
    PEventRec(tpList[I])^.erOnTrigger := Value
  else
    raise EInvalidTriggerHandle.Create;
end;

procedure TOvcTimerPool.SetTriggerEnabled(Handle : Integer; Value: Boolean);
  {-sets the timer trigger's enabled status}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then begin
    if (Value <> PEventRec(tpList[I])^.erEnabled) then begin
      PEventRec(tpList[I])^.erEnabled := Value;
      {If the timer is being activated, then initialize LastTrigger}
      if PEventRec(tpList[I])^.erEnabled then
        PEventRec(tpList[I])^.erLastTrigger := GetTickCount;
      tpEnabledCount := tpCountEnabledTriggers;
      tpCalcNewInterval;
      tpUpdateTimer;
    end;
  end else
    raise EInvalidTriggerHandle.Create;
end;

procedure TOvcTimerPool.SetTriggerInterval(Handle : Integer; Value : Cardinal);
  {-sets the timer trigger's interval}
var
  I : Integer;
begin
  I := tpEventIndex(Handle);
  if (I > -1) then begin
    if Value <> PEventRec(tpList[I])^.erInterval then begin
      PEventRec(tpList[I])^.erInterval := Value;
      tpCalcNewInterval;
      tpUpdateTimer;
    end;
  end else
    raise EInvalidTriggerHandle.Create;
end;

procedure TOvcTimerPool.SetAbout(const Value : string);
begin
end;

procedure TOvcTimerPool.tpCalcNewInterval;
  {-calculates the needed interval for the window's timer}
var
  I    : Integer;
  N, V : LongInt;
  TR   : LongInt;
  ER   : PEventRec;
  TC   : LongInt;
  Done : Boolean;
begin
  {find shortest trigger interval}
  TC := GetTickCount;
  tpInterval := High(Cardinal);
  for I := 0 to tpList.Count-1 do begin
    ER := PEventRec(tpList[I]);
    if ER^.erEnabled then begin
      if (ER^.erInterval < tpInterval) then
        tpInterval := ER^.erInterval;

      {is this interval greater than the remaining time on any existing triggers}
      TR := 0;
      if (TC < ER^.erLastTrigger) then
        TR := TR + MaxLongInt
      else
        TR := TC - ER^.erLastTrigger;
      if LongInt(tpInterval) > (LongInt(ER^.erInterval) - TR) then
        tpInterval := (LongInt(ER^.erInterval) - TR);
    end;
  end;

  {limit to smallest allowable interval}
  if tpInterval < tpDefMinInterval then
    tpInterval := tpDefMinInterval;

  if tpInterval = High(Cardinal) then
    tpInterval := 0
  else begin
    {find interval that evenly divides into all trigger intervals}
    V := tpInterval; {use LongInt so it is possible for it to become (-)}
    repeat
      Done := True;
      for I := 0 to tpList.Count-1 do begin
        N := PEventRec(tpList[I])^.erInterval;
        if (N mod V) <> 0 then begin
          Dec(V, N mod V);
          Done := False;
          Break;
        end;
      end;
    until Done or (V <= tpDefMinInterval);

    {limit to smallest allowable interval}
    if V < tpDefMinInterval then
      V := tpDefMinInterval;

    tpInterval := V;
  end;
end;

function TOvcTimerPool.tpCountEnabledTriggers : Integer;
  {-returns the number of enabled/active timer triggers}
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to tpList.Count-1 do
    if PEventRec(tpList[I])^.erEnabled then
      Inc(Result);
end;

function TOvcTimerPool.tpCreateTriggerHandle : Integer;
  {-returns a unique timer trigger handle}
var
  I : Integer;
  H : Integer;
begin
  Result := 0;
  for I := 0 to tpList.Count-1 do begin
    H := PEventRec(tpList[I])^.erHandle;
    if H >= Result then
      Result := H + 1;
  end;
end;

function TOvcTimerPool.tpEventIndex(Handle : Integer) : Integer;
  {-returns the internal list index corresponding to Handle}
var
  I : Integer;
begin
  Result := -1;
  for I := 0 to tpList.Count-1 do
    if PEventRec(tpList[I])^.erHandle = Handle then begin
      Result := I;
      Break;
    end;
end;

procedure TOvcTimerPool.tpSortTriggers;
  {-sorts the internal list of timer trigger event records}
var
  I    : Integer;
  Done : Boolean;
begin
  repeat
    Done := True;
    for I := 0 to tpList.Count-2 do begin
      if (PEventRec(tpList[I])^.erInterval >
          PEventRec(tpList[I+1])^.erInterval) then begin
        tpList.Exchange(I, I+1);
        Done := False;
      end;
    end;
  until Done;
end;

procedure TOvcTimerPool.tpTimerWndProc(var Msg : TMessage);
  {-window procedure to catch timer messages}
begin
  with Msg do
    if Msg = WM_TIMER then
      try
        DoTriggerNotification;
      except
        Application.HandleException(Self);
      end
    else
      Result := DefWindowProc(tpHandle, Msg, wParam, lParam);
end;

procedure TOvcTimerPool.tpUpdateTimer;
  {-re-create the windows timer with a new timer interval}
begin
  {remove existing timer, if any}
  if KillTimer(tpHandle, 1) then {ignore return value};

  if (tpInterval <> 0) and (tpEnabledCount > 0) then
    if SetTimer(tpHandle, 1, tpInterval, nil) = 0 then
      raise ENoTimersAvailable.Create;
end;


end.

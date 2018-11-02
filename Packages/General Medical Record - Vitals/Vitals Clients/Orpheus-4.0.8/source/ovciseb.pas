{*********************************************************}
{*                   OVCISEB.PAS 4.06                    *}
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

unit ovciseb;
  {-abstract incremental search edit control base class}

interface

uses
  Windows, Classes, SysUtils, OvcBase, OvcEditF, OvcBordr;

type
  TOvcBaseISE = class(TOvcCustomEdit)
  protected {private}
    {property variables}
    FAutoSearch    : Boolean;
    FBorders       : TOvcBorders;
    FCaseSensitive : Boolean;
    FKeyDelay      : Integer;
    FPreviousText  : string;
    FShowResults   : Boolean;

    {internal variables}
    isTimer        : Integer;         {timer-pool handle}

    {property methods}
    procedure SetAutoSearch(Value : Boolean);
    procedure SetKeyDelay(Value : Integer);

    {internal methods}
    procedure isTimerEvent(Sender : TObject; Handle : Integer;
                           Interval : Cardinal; ElapsedTime : Integer);

  protected
    procedure DoExit;
      override;
    procedure KeyUp(var Key : Word; Shift : TShiftState);
      override;

    {protected properties}
    property AutoSearch : Boolean
      read FAutoSearch write SetAutoSearch;
    property CaseSensitive : Boolean
      read FCaseSensitive write FCaseSensitive;
    property KeyDelay : Integer
      read FKeyDelay write SetKeyDelay;
    property ShowResults : Boolean
      read FShowResults write FShowResults;

  public
    constructor Create(AOwner: TComponent);
      override;
    destructor Destroy;
      override;

    property Borders : TOvcBorders
      read FBorders
      write FBorders;

    property PreviousText : string
      read FPreviousText write FPreviousText;

    function ISUpperCase(const S : string) : string;
      {return the AnsiUpperCase(S) if not CaseSensitive}

    {public methods}
    procedure PerformSearch;
      virtual; abstract;
      {search for Text}
  end;


implementation


{*** TOvcBaseISE ***}

constructor TOvcBaseISE.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if (csDesigning in ComponentState) then
    Text := Name
  else
    Text := '';

  {initialize property variables}
  FAutoSearch    := True;
  FCaseSensitive := False;
  FKeyDelay      := 500;
  FShowResults   := True;

  isTimer := -1;
end;

destructor TOvcBaseISE.Destroy;
begin
  if ControllerAssigned and (isTimer > -1) then begin
    Controller.TimerPool.Remove(isTimer);
    isTimer := -1;
  end;

  inherited Destroy;
end;

procedure TOvcBaseISE.DoExit;
begin
  if (isTimer > -1) then
    Controller.TimerPool.Remove(isTimer);

  if Modified then begin
    Modified := False;
    isTimer := -1;
    PerformSearch;
  end;

  inherited DoExit;
end;

procedure TOvcBaseISE.isTimerEvent(Sender : TObject;
          Handle : Integer; Interval : Cardinal; ElapsedTime : Integer);
begin
  {perform a search if modified}
  if Modified then begin
    Modified := False;
    isTimer := -1;
    PerformSearch;
  end;
end;

function TOvcBaseISE.ISUpperCase(const S : string) : string;
  {return the AnsiUpperCase(S) if not CaseSensitive}
begin
  if not CaseSensitive then
    Result := AnsiUpperCase(S)
  else
    Result := S;
end;

procedure TOvcBaseISE.KeyUp(var Key : Word; Shift : TShiftState);
var
  DoIt : Boolean;
begin
  DoIt := True;
  if (ISUpperCase(Text) = PreviousText) then
    DoIt := False;

  inherited KeyUp(Key, Shift);

  {start/reset timer}
  if AutoSearch and DoIt then begin
    {see if we need to reset our timer}
    if (isTimer > -1) then
      Controller.TimerPool.Remove(isTimer);
    isTimer := Controller.TimerPool.AddOneTime(isTimerEvent, FKeyDelay);
  end;

end;

procedure TOvcBaseISE.SetAutoSearch(Value : Boolean);
begin
  if (Value <> FAutoSearch) then begin
    FAutoSearch := Value;
    RecreateWnd;
  end;
end;

procedure TOvcBaseISE.SetKeyDelay(Value : Integer);
begin
  if (Value <> FKeyDelay) and (Value >= 0) then begin
    FKeyDelay := Value;
  end;
end;


end.

{*********************************************************}
{*                    OVCBTIME.PAS 4.06                  *}
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
{$J+} {Writable constants}

unit ovcbtime;
  {-base time edit field class w/ label and borders}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, MultiMon, StdCtrls, SysUtils, OvcBase, OvcVer, OvcEditF, OvcBordr,
  OvcBCalc, OvcEdTim;

const
  BorderMsgClose = WM_USER+20;
  BorderMsgOpen  = WM_USER+21;

type
  TOvcTimeEditEx = class(TOvcTimeEdit)
  protected
    BorderParent : TOvcBorderEdPopup;
  end;

  TOvcBorderedTimeEdit = class(TOvcBorderParent)
  protected
    FOvcEdit : TOvcTimeEditEx;

    FAsHours    : Integer;
    FAsMinutes  : Integer;
    FAsSeconds  : Integer;

    {base property values}
    FBiDiMode      : TBiDiMode;
    FParentBiDiMode: Boolean;
    FDragKind      : TDragKind;
    FAbout         : string;
    FAutoSelect    : Boolean;
    FAutoSize      : Boolean;
    FBorderStyle   : TBorderStyle;
    FCharCase      : TEditCharCase;
    FController    : TOvcController;
    FCursor        : TCursor;
    FDragCursor    : TCursor;
    FDragMode      : TDragMode;
    FEnabled       : Boolean;
    FFont          : TFont;
    FHeight        : integer;
    FHideSelection : Boolean;
    FImeMode       : TImeMode;
    FImeName       : string;
    FMaxLength     : Integer;
    FOEMConvert    : Boolean;
    FParentFont    : Boolean;
    FParentShowHint: Boolean;
    FPasswordChar  : Char;
    FPopupMenu     : TPopupMenu;
    FReadOnly      : Boolean;
    FShowHint      : Boolean;
    FTabOrder      : TTabOrder;
    FText          : string;
    FVisible       : Boolean;
    FWidth         : integer;

    {events}
    FOnChange      : TNotifyEvent;
    FOnClick       : TNotifyEvent;
    FOnDblClick    : TNotifyEvent;
    FOnDragDrop    : TDragDropEvent;
    FOnDragOver    : TDragOverEvent;

    FOnEndDrag     : TEndDragEvent;
    FOnEnter       : TNotifyEvent;
    FOnExit        : TNotifyEvent;
    FOnKeyDown     : TKeyEvent;
    FOnKeyPress    : TKeyPressEvent;
    FOnKeyUp       : TKeyEvent;
    FOnMouseDown   : TMouseEvent;
    FOnMouseMove   : TMouseMoveEvent;
    FOnMouseUp     : TMouseEvent;
    FOnStartDrag   : TStartDragEvent;

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

    {base property methods}
    function GetBiDiMode : TBiDiMode;
    function GetParentBiDiMode : Boolean;
    function GetDragKind : TDragKind;

    procedure SetBiDiMode(Value : TBiDiMode); override;
    procedure SetParentBiDiMode(Value : Boolean); override;
    procedure SetDragKind(Value : TDragKind);

    function GetAbout : string;
    function GetAutoSelect : Boolean;
    function GetAutoSize : Boolean;
    function GetCharCase : TEditCharCase;
    function GetController : TOvcController;
    function GetCursor : TCursor;
    function GetDragCursor : TCursor;
    function GetDragMode : TDragMode;
    function GetEditEnabled : Boolean;
    function GetFont : TFont;
    function GetHideSelection : Boolean;
    function GetImeMode : TImeMode;
    function GetImeName : string;
    function GetMaxLength : Integer;
    function GetOEMConvert : Boolean;
    function GetParentShowHint : Boolean;
    function GetPasswordChar : Char;
    function GetReadOnly : Boolean;
    function GetEditText : string;


    function GetOnChange   : TNotifyEvent;
    function GetOnClick    : TNotifyEvent;
    function GetOnDblClick : TNotifyEvent;
    function GetOnDragDrop : TDragDropEvent;
    function GetOnDragOver : TDragOverEvent;
    function GetOnEndDrag  : TEndDragEvent;
    function GetOnKeyDown  : TKeyEvent;
    function GetOnKeyPress : TKeyPressEvent;
    function GetOnKeyUp    : TKeyEvent;
    function GetOnMouseDown: TMouseEvent;
    function GetOnMouseMove: TMouseMoveEvent;
    function GetOnMouseUp  : TMouseEvent;


    procedure SetAbout(const Value : string);
    procedure SetAutoSelect(Value : Boolean);
    procedure SetAutoSize(Value : Boolean); override;
    procedure SetCharCase(Value : TEditCharCase);
    procedure SetEditController(Value : TOvcController);
    procedure SetCursor(Value : TCursor);
    procedure SetDragCursor(Value : TCursor);
    procedure SetEditDragMode(Value : TDragMode);
    procedure SetEditEnabled(Value : Boolean);
    procedure SetFont(Value : TFont);
    procedure SetHideSelection(Value : Boolean);
    procedure SetImeMode(Value : TImeMode);
    procedure SetImeName(const Value : string);
    procedure SetMaxLength(Value : Integer);
    procedure SetOEMConvert(Value : Boolean);
    procedure SetParentShowHint(Value : Boolean);
    procedure SetPasswordChar(Value : Char);
    procedure SetReadOnly(Value : Boolean);
    procedure SetEditText(const Value : string);


    procedure SetOnChange(Value : TNotifyEvent);
    procedure SetOnClick(Value : TNotifyEvent);
    procedure SetOnDblClick(Value : TNotifyEvent);
    procedure SetOnDragDrop(Value : TDragDropEvent);
    procedure SetOnDragOver(Value : TDragOverEvent);
    procedure SetOnEndDrag(Value : TEndDragEvent);
    procedure SetOnKeyDown(Value : TKeyEvent);
    procedure SetOnKeyPress(Value : TKeyPressEvent);
    procedure SetOnKeyUp(Value : TKeyEvent);
    procedure SetOnMouseDown(Value : TMouseEvent);
    procedure SetOnMouseMove(Value : TMouseMoveEvent);
    procedure SetOnMouseUp(Value : TMouseEvent);

    {property methods}
    function GetAsHours : Integer;
    function GetAsMinutes : Integer;
    function GetAsSeconds : Integer;
    function GetDefaultToPM : Boolean;
    function GetDurationDisplay : TOvcDurationDisplay;
    function GetNowString : string;
    function GetPrimaryField : TOvcTimeField;
    function GetShowSeconds : Boolean;
    function GetShowUnits : Boolean;
    function GetTime : TDateTime;
    function GetTimeMode : TOvcTimeMode;
    function GetUnitsLength : integer;

    function GetOnGetTime : TOvcGetTimeEvent;
    function GetOnPreParseTime : TOvcPreParseTimeEvent;
    function GetOnSetTime : TNotifyEvent;

    procedure SetAsHours(Value : Integer);
    procedure SetAsMinutes(Value : Integer);
    procedure SetAsSeconds(Value : Integer);
    procedure SetDefaultToPM(Value : Boolean);
    procedure SetDurationDisplay(Value : TOvcDurationDisplay);
    procedure SetNowString(const Value : string);
    procedure SetPrimaryField(Value : TOvcTimeField);
    procedure SetShowSeconds(Value : Boolean);
    procedure SetShowUnits(Value : Boolean);
    procedure SetTime(Value : TDateTime);
    procedure SetTimeMode(Value : TOvcTimeMode);
    procedure SetUnitsLength(Value : Integer);

    procedure SetOnGetTime(Value : TOvcGetTimeEvent);
    procedure SetOnPreParseTime(Value : TOvcPreParseTimeEvent);
    procedure SetOnSetTime(Value : TNotifyEvent);

  public
    constructor Create(AOwner : TComponent);
      override;

    destructor Destroy; override;

    property AsDateTime : TDateTime
      read GetTime
      write SetTime;

    property AsHours : Integer
      read GetAsHours
      write SetAsHours;

    property AsMinutes : Integer
      read GetAsMinutes
      write SetAsMinutes;

    property AsSeconds : Integer
      read GetAsSeconds
      write SetAsSeconds;

    property EditControl : TOvcTimeEditEx
      read FOvcEdit;

  published
    property DefaultToPM  : Boolean
      read GetDefaultToPM
      write SetDefaultToPM;

    property DurationDisplay : TOvcDurationDisplay
      read GetDurationDisplay
      write SetDurationDisplay;

    property NowString : string
      read GetNowString
      write SetNowString;

    property PrimaryField : TOvcTimeField
      read GetPrimaryField
      write SetPrimaryField;

    property ShowSeconds : Boolean
      read GetShowSeconds
      write SetShowSeconds;

    property ShowUnits : Boolean
      read GetShowUnits
      write SetShowUnits;

    property TimeMode : TOvcTimeMode
      read GetTimeMode
      write SetTimeMode;

    property UnitsLength : Integer
      read GetUnitsLength
      write SetUnitsLength;

    property OnGetTime : TOvcGetTimeEvent
      read GetOnGetTime
      write SetOnGetTime;

    property OnPreParseTime : TOvcPreParseTimeEvent
      read GetOnPreParseTime
      write SetOnPreParseTime;

    property OnSetTime : TNotifyEvent
      read GetOnSetTime
      write SetOnSetTime;


    property Anchors;

    property BiDiMode : TBiDiMode
      read GetBiDiMode
      write SetBiDiMode;

    property ParentBiDiMode : Boolean
      read GetParentBiDiMode
      write SetParentBiDiMode;

    property Constraints;

    property DragKind : TDragKind
      read GetDragKind
      write SetDragKind;

    property ReadOnly : Boolean
      read GetReadOnly
      write SetReadOnly;

    property AutoSize : Boolean
      read GetAutoSize
      write SetAutoSize;

    property About : string
      read GetAbout
      write SetAbout;

    property AutoSelect : Boolean
      read GetAutoSelect
      write SetAutoSelect;

    property CharCase : TEditCharCase
      read GetCharCase
      write SetCharCase;

    property Controller : TOvcController
      read GetController
      write SetEditController;

    property Cursor : TCursor
      read GetCursor
      write SetCursor;

    property DragCursor : TCursor
      read GetDragCursor
      write SetDragCursor;

    property DragMode : TDragMode
      read GetDragMode
      write SetDragMode;

    property Enabled : Boolean
      read FEnabled
      write FEnabled;

    property Font : TFont
      read GetFont
      write SetFont;

    property HideSelection : Boolean
      read GetHideSelection
      write SetHideSelection;

    property ImeMode : TImeMode
      read GetImeMode
      write SetImeMode;

    property ImeName;

    property MaxLength : integer
      read GetMaxLength
      write SetMaxLength;

    property OEMConvert : Boolean
      read GetOEMConvert
      write SetOEMConvert;

    property ParentShowHint : Boolean
      read GetParentShowHint
      write SetParentShowHint;

    property PasswordChar : Char
      read GetPasswordChar
      write SetPasswordChar;

    property PopupMenu;

    property ShowHint;

    property TabOrder;
    property TabStop;
    property Visible;

    {events}
    property OnChange : TNotifyEvent
      read GetOnChange
      write SetOnChange;

    property OnClick : TNotifyEvent
      read GetOnClick
      write SetOnClick;

    property OnDblClick : TNotifyEvent
      read GetOnDblClick
      write SetOnDblClick;

    property OnDragDrop : TDragDropEvent
      read GetOnDragDrop
      write SetOnDragDrop;

    property OnDragOver : TDragOverEvent
      read GetOnDragOver
      write SetOnDragOver;

    property OnEndDrag : TEndDragEvent
      read GetOnEndDrag
      write SetOnEndDrag;

    property OnEnter;
    property OnExit;

    property OnKeyDown : TKeyEvent
      read GetOnKeyDown
      write SetOnKeyDown;

    property OnKeyPress : TKeyPressEvent
      read GetOnKeyPress
      write SetOnKeyPress;

    property OnKeyUp : TKeyEvent
      read GetOnKeyUp
      write SetOnKeyUp;

    property OnMouseDown : TMouseEvent
      read GetOnMouseDown
      write SetOnMouseDown;

    property OnMouseMove : TMouseMoveEvent
      read GetOnMouseMove
      write SetOnMouseMove;

    property OnMouseUp : TMouseEvent
      read GetOnMouseUp
      write SetOnMouseUp;
    property OnStartDrag;
  end;


implementation

{******************************************************************************}
{                        TOvcBorderedTimeEdit                                }
{******************************************************************************}

constructor TOvcBorderedTimeEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FOvcEdit := TOvcTimeEditEx.Create(Self);
  SetEditControl(TOvcCustomEdit(FOvcEdit));

  FOvcEdit.Ctl3D := False;
  FOvcEdit.BorderStyle := bsNone;
  FOvcEdit.ParentColor := True;
  FOvcEdit.Parent := Self;
  FOvcEdit.Top := 0;
  FOvcEdit.Left := 0;
  FOvcEdit.TabStop := TabStop;

  Height := FEdit.Height;
  Width  := FEdit.Width;

  Borders.BottomBorder.Enabled := True;

  FBiDiMode      := FOvcEdit.BiDiMode;
  FParentBiDiMode:= FOvcEdit.ParentBiDiMode;
  FDragKind      := FOvcEdit.DragKind;
  FAbout         := FOvcEdit.About;
  FAutoSelect    := FOvcEdit.AutoSelect;
  FAutoSize      := FOvcEdit.AutoSize;
  FBorderStyle   := FOvcEdit.BorderStyle;
  FCharCase      := FOvcEdit.CharCase;
  FCursor        := FOvcEdit.Cursor;
  FDragCursor    := FOvcEdit.DragCursor;
  FDragMode      := FOvcEdit.DragMode;
  FEnabled       := True;
  FFont          := FOvcEdit.Font;
  FHideSelection := FOvcEdit.HideSelection;
  FImeMode       := FOvcEdit.ImeMode;
  FImeName       := FOvcEdit.ImeName;
  FMaxLength     := FOvcEdit.MaxLength;
  FOEMConvert    := FOvcEdit.OEMConvert;
  FParentFont    := FOvcEdit.ParentFont;
  FParentShowHint:= FOvcEdit.ParentShowHint;
  FPasswordChar  := FOvcEdit.PasswordChar;
  FPopupMenu     := FOvcEdit.PopupMenu;
  FReadOnly      := FOvcEdit.ReadOnly;
  FShowHint      := FOvcEdit.ShowHint;
  FTabOrder      := FOvcEdit.TabOrder;
  FText          := FOvcEdit.Text;
  FVisible       := True;

  FOnChange      := FOvcEdit.OnChange;
  FOnClick       := FOvcEdit.OnClick;
  FOnDblClick    := FOvcEdit.OnDblClick;
  FOnDragDrop    := FOvcEdit.OnDragDrop;
  FOnDragOver    := FOvcEdit.OnDragOver;

  FOnEndDrag     := FOvcEdit.OnEndDrag;
  FOnEnter       := FOvcEdit.OnEnter;
  FOnExit        := FOvcEdit.OnExit;
  FOnKeyDown     := FOvcEdit.OnKeyDown;
  FOnKeyPress    := FOvcEdit.OnKeyPress;
  FOnKeyUp       := FOvcEdit.OnKeyUp;
  FOnMouseDown   := FOvcEdit.OnMouseDown;
  FOnMouseMove   := FOvcEdit.OnMouseMove;
  FOnMouseUp     := FOvcEdit.OnMouseUp;
  FOnStartDrag   := FOvcEdit.OnStartDrag;
end;

destructor TOvcBorderedTimeEdit.Destroy;
begin
  FOvcEdit.Free;
  FOvcEdit := nil;

  inherited Destroy;
end;


function TOvcBorderedTimeEdit.GetAsHours : Integer;
begin
  Result := FOvcEdit.AsHours;
  FAsHours := Result;
end;

function TOvcBorderedTimeEdit.GetAsMinutes : Integer;
begin
  Result := FOvcEdit.AsMinutes;
  FAsMinutes := Result;
end;

function TOvcBorderedTimeEdit.GetAsSeconds : Integer;
begin
  Result := FOvcEdit.AsSeconds;
  FAsSeconds := Result;
end;

function TOvcBorderedTimeEdit.GetDefaultToPM : Boolean;
begin
  Result := FOvcEdit.DefaultToPM;
  FDefaultToPM := Result;
end;

function TOvcBorderedTimeEdit.GetDurationDisplay : TOvcDurationDisplay;
begin
  Result := FOvcEdit.DurationDisplay;
  FDurationDisplay := Result;
end;

function TOvcBorderedTimeEdit.GetNowString : string;
begin
  Result := FOvcEdit.NowString;
  FNowString := Result;
end;

function TOvcBorderedTimeEdit.GetPrimaryField : TOvcTimeField;
begin
  Result := FOvcEdit.PrimaryField;
  FPrimaryField := Result;
end;

function TOvcBorderedTimeEdit.GetShowSeconds : Boolean;
begin
  Result := FOvcEdit.ShowSeconds;
  FShowSeconds := Result;
end;

function TOvcBorderedTimeEdit.GetShowUnits : Boolean;
begin
  Result := FOvcEdit.ShowUnits;
  FShowUnits := Result;
end;

function TOvcBorderedTimeEdit.GetTime : TDateTime;
begin
  Result := FOvcEdit.FTime;
  FTime := Result;
end;

function TOvcBorderedTimeEdit.GetTimeMode : TOvcTimeMode;
begin
  Result := FOvcEdit.TimeMode;
  FTimeMode := Result;
end;

function TOvcBorderedTimeEdit.GetUnitsLength : integer;
begin
  Result := FOvcEdit.UnitsLength;
  FUnitsLength := Result;
end;


function TOvcBorderedTimeEdit.GetOnGetTime : TOvcGetTimeEvent;
begin
  Result := FOvcEdit.OnGetTime;
  FOnGetTime := Result;
end;

function TOvcBorderedTimeEdit.GetOnPreParseTime : TOvcPreParseTimeEvent;
begin
  Result := FOvcEdit.OnPreParseTime;
  FOnPreParseTime := Result;
end;

function TOvcBorderedTimeEdit.GetOnSetTime : TNotifyEvent;
begin
  Result := FOvcEdit.OnSetTime;
  FOnSetTime := Result;
end;

procedure TOvcBorderedTimeEdit.SetAsHours(Value : Integer);
begin
  FOvcEdit.AsHours := Value;
  FAsHours := Value;
end;

procedure TOvcBorderedTimeEdit.SetAsMinutes(Value : Integer);
begin
  FOvcEdit.AsMinutes := Value;
  FAsMinutes := Value;
end;

procedure TOvcBorderedTimeEdit.SetAsSeconds(Value : Integer);
begin
  FOvcEdit.AsSeconds := Value;
  FAsSeconds := Value;
end;

procedure TOvcBorderedTimeEdit.SetDefaultToPM(Value : Boolean);
begin
  FOvcEdit.DefaultToPM := Value;
  FDefaultToPM := Value;
end;

procedure TOvcBorderedTimeEdit.SetDurationDisplay(Value : TOvcDurationDisplay);
begin
  FOvcEdit.DurationDisplay := Value;
  FDurationDisplay := Value;
end;

procedure TOvcBorderedTimeEdit.SetNowString(const Value : string);
begin
  FOvcEdit.NowString := Value;
  FNowString := Value;
end;

procedure TOvcBorderedTimeEdit.SetPrimaryField(Value : TOvcTimeField);
begin
  FOvcEdit.PrimaryField := Value;
  FPrimaryField := Value;
end;

procedure TOvcBorderedTimeEdit.SetShowSeconds(Value : Boolean);
begin
  FOvcEdit.ShowSeconds := Value;
  FShowSeconds := Value;
end;

procedure TOvcBorderedTimeEdit.SetShowUnits(Value : Boolean);
begin
  FOvcEdit.ShowUnits := Value;
  FShowUnits := Value;
end;

procedure TOvcBorderedTimeEdit.SetTime(Value : TDateTime);
begin
  FOvcEdit.FTime := Value;
  FTime := Value;
end;

procedure TOvcBorderedTimeEdit.SetTimeMode(Value : TOvcTimeMode);
begin
  FOvcEdit.TimeMode := Value;
  FTimeMode := Value;
end;

procedure TOvcBorderedTimeEdit.SetUnitsLength(Value : Integer);
begin
  FOvcEdit.UnitsLength := Value;
  FUnitsLength := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnGetTime(Value : TOvcGetTimeEvent);
begin
  FOvcEdit.OnGetTime := Value;
  FOnGetTime := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnPreParseTime(Value : TOvcPreParseTimeEvent);
begin
  FOvcEdit.OnPreParseTime := Value;
  FOnPreParseTime := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnSetTime(Value : TNotifyEvent);
begin
  FOvcEdit.OnSetTime := Value;
  FOnSetTime := Value;
end;




{Base property transfers}
function TOvcBorderedTimeEdit.GetReadOnly : Boolean;
begin
  Result := FOvcEdit.ReadOnly;
  FReadOnly := Result;
end;


procedure TOvcBorderedTimeEdit.SetReadOnly(Value : Boolean);
begin
  FReadOnly := Value;
  FOvcEdit.ReadOnly := Value;
end;

{base property methods}
function TOvcBorderedTimeEdit.GetBiDiMode : TBiDiMode;
begin
  Result := FOvcEdit.BiDiMode;
  FBiDiMode := Result;
end;

function TOvcBorderedTimeEdit.GetParentBiDiMode : Boolean;
begin
  Result := FOvcEdit.ParentBiDiMode;
  FParentBiDiMode := Result;
end;

function TOvcBorderedTimeEdit.GetDragKind : TDragKind;
begin
  Result := FOvcEdit.DragKind;
  FDragKind := Result;
end;


procedure TOvcBorderedTimeEdit.SetBiDiMode(Value : TBiDiMode);
begin
  if (Value <> FBiDiMode) then begin
    inherited;
    FBiDiMode := Value;
    FOvcEdit.BiDiMode := Value;
  end;
end;

procedure TOvcBorderedTimeEdit.SetParentBiDiMode(Value : Boolean);
begin
  if (Value <> FParentBiDiMode) then begin
    inherited;
    FParentBiDiMode := Value;
    FOvcEdit.ParentBiDiMode := Value;
  end;
end;

procedure TOvcBorderedTimeEdit.SetDragKind(Value : TDragKind);
begin
  if (Value <> FDragKind) then begin
    FDragKind := Value;
    FOvcEdit.DragKind := Value;
  end;
end;

function TOvcBorderedTimeEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;

function TOvcBorderedTimeEdit.GetAutoSelect : Boolean;
begin
  Result := FOvcEdit.AutoSelect;
  FAutoSelect := FOvcEdit.AutoSelect;
end;

function TOvcBorderedTimeEdit.GetAutoSize : Boolean;
begin
  Result := FOvcEdit.AutoSize;
  FAutoSize := FOvcEdit.AutoSize;
end;

function TOvcBorderedTimeEdit.GetCharCase : TEditCharCase;
begin
  Result := FOvcEdit.CharCase;
  FCharCase := Result;
end;

function TOvcBorderedTimeEdit.GetController : TOvcController;
begin
  Result := FOvcEdit.Controller;
  FController := Result;
end;

function TOvcBorderedTimeEdit.GetCursor : TCursor;
begin
  Result := FOvcEdit.Cursor;
  FCursor := Result;
end;


function TOvcBorderedTimeEdit.GetDragCursor : TCursor;
begin
  Result := FOvcEdit.DragCursor;
  FDragCursor := Result;
end;


function TOvcBorderedTimeEdit.GetDragMode : TDragMode;
begin
  Result := FOvcEdit.DragMode;
  FDragMode := Result;
end;


function TOvcBorderedTimeEdit.GetEditEnabled : Boolean;
begin
  Result := FOvcEdit.Enabled;
  FEnabled := FOvcEdit.Enabled;
end;

function TOvcBorderedTimeEdit.GetFont : TFont;
begin
  Result := FOvcEdit.Font;
  FFont  := Result;
end;

function TOvcBorderedTimeEdit.GetHideSelection : Boolean;
begin
  Result := FOvcEdit.HideSelection;
  FHideSelection := Result;
end;

function TOvcBorderedTimeEdit.GetImeMode : TImeMode;
begin
  Result := FOvcEdit.ImeMode;
  FImeMode := Result;
end;

function TOvcBorderedTimeEdit.GetImeName : string;
begin
  Result := FOvcEdit.ImeName;
  FImeName := Result;
end;

function TOvcBorderedTimeEdit.GetMaxLength : Integer;
begin
  Result := FOvcEdit.MaxLength;
  FMaxLength := Result;
end;

function TOvcBorderedTimeEdit.GetOEMConvert : Boolean;
begin
  Result := FOvcEdit.OEMConvert;
  FOEMConvert := Result;
end;

function TOvcBorderedTimeEdit.GetParentShowHint : Boolean;
begin
  Result := FOvcEdit.ParentShowHint;
  FParentShowHint := Result;
end;

function TOvcBorderedTimeEdit.GetPasswordChar : Char;
begin
  Result := FOvcEdit.PasswordChar;
  FPasswordChar := Result;
end;

function TOvcBorderedTimeEdit.GetEditText: string;
begin
  Result := FOvcEdit.Text;
  FText := Result;
end;

function TOvcBorderedTimeEdit.GetOnChange : TNotifyEvent;
begin
  Result := FOvcEdit.OnChange;
  FOnChange := Result;
end;

function TOvcBorderedTimeEdit.GetOnClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnClick;
  FOnClick := Result;
end;

function TOvcBorderedTimeEdit.GetOnDblClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnDblClick;
  FOnDblClick := Result;
end;

function TOvcBorderedTimeEdit.GetOnDragDrop : TDragDropEvent;
begin
  Result := FOvcEdit.OnDragDrop;
  FOnDragDrop := Result;
end;

function TOvcBorderedTimeEdit.GetOnDragOver : TDragOverEvent;
begin
  Result := FOvcEdit.OnDragOver;
  FOnDragOver := Result;
end;

function TOvcBorderedTimeEdit.GetOnEndDrag : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDrag;
  FOnEndDrag := Result;
end;

function TOvcBorderedTimeEdit.GetOnKeyDown : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyDown;
  FOnKeyDown := Result;
end;

function TOvcBorderedTimeEdit.GetOnKeyPress : TKeyPressEvent;
begin
  Result := FOvcEdit.OnKeyPress;
  FOnKeyPress := Result;
end;

function TOvcBorderedTimeEdit.GetOnKeyUp : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyUp;
  FOnKeyUp := Result;
end;

function TOvcBorderedTimeEdit.GetOnMouseDown : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseDown;
  FOnMouseDown := Result;
end;

function TOvcBorderedTimeEdit.GetOnMouseMove : TMouseMoveEvent;
begin
  Result := FOvcEdit.OnMouseMove;
  FOnMouseMove := Result;
end;

function TOvcBorderedTimeEdit.GetOnMouseUp : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseUp;
  FOnMouseUp := Result;
end;



procedure TOvcBorderedTimeEdit.SetAbout(const Value : string);
begin
end;


procedure TOvcBorderedTimeEdit.SetAutoSelect(Value : Boolean);
begin
  FAutoSelect := Value;
  FOvcEdit.AutoSelect := Value;
end;


procedure TOvcBorderedTimeEdit.SetAutoSize(Value : Boolean);
begin
  FAutoSize := Value;
  FOvcEdit.AutoSize := Value;
end;


procedure TOvcBorderedTimeEdit.SetCharCase(Value : TEditCharCase);
begin
  FCharCase := Value;
  FOvcEdit.CharCase := Value;
end;


procedure TOvcBorderedTimeEdit.SetEditController(Value : TOvcController);
begin
  FController := Value;
  FOvcEdit.Controller := Value;
end;

procedure TOvcBorderedTimeEdit.SetCursor(Value : TCursor);
begin
  FCursor := Value;
  FOvcEdit.Cursor := Value;
end;


procedure TOvcBorderedTimeEdit.SetDragCursor(Value : TCursor);
begin
  FDragCursor := Value;
  FOvcEdit.DragCursor := Value;
end;


procedure TOvcBorderedTimeEdit.SetEditDragMode(Value : TDragMode);
begin
  FDragMode := Value;
  FOvcEdit.DragMode := Value;
end;

procedure TOvcBorderedTimeEdit.SetEditEnabled(Value : Boolean);
begin
  FEnabled := Value;
  Enabled  := Value;
  FOvcEdit.Enabled := Value;
end;

procedure TOvcBorderedTimeEdit.SetFont(Value : TFont);
begin
  FFont := Value;
  FOvcEdit.Font := Value;
end;

procedure TOvcBorderedTimeEdit.SetHideSelection(Value : Boolean);
begin
  FHideSelection := Value;
  FOvcEdit.HideSelection := Value;
end;

procedure TOvcBorderedTimeEdit.SetImeMode(Value : TImeMode);
begin
  FImeMode := Value;
  FOvcEdit.ImeMode := Value;
end;

procedure TOvcBorderedTimeEdit.SetImeName(const Value : string);
begin
  FImeName := Value;
  FOvcEdit.ImeName := Value;
end;

procedure TOvcBorderedTimeEdit.SetMaxLength(Value : Integer);
begin
  FMaxLength := Value;
  FOvcEdit.MaxLength := Value;
end;

procedure TOvcBorderedTimeEdit.SetOEMConvert(Value : Boolean);
begin
  FOEMConvert := Value;
  FOvcEdit.OEMConvert := Value;
end;

procedure TOvcBorderedTimeEdit.SetParentShowHint(Value : Boolean);
begin
  FParentShowHint := Value;
  FOvcEdit.ParentShowHint := Value;
end;

procedure TOvcBorderedTimeEdit.SetPasswordChar(Value : Char);
begin
  FPasswordChar := Value;
  FOvcEdit.PasswordChar := Value;
end;


procedure TOvcBorderedTimeEdit.SetEditText(const Value : string);
begin
  FText := Value;
  FOvcEdit.Text := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnChange(Value : TNotifyEvent);
begin
  FOnChange := Value;
  FOvcEdit.OnChange := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnClick(Value : TNotifyEvent);
begin
  FOnClick := Value;
  FOvcEdit.OnClick := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnDblClick(Value : TNotifyEvent);
begin
  FOnDblClick := Value;
  FOvcEdit.OnDblClick := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnDragDrop(Value : TDragDropEvent);
begin
  FOnDragDrop := Value;
  FOvcEdit.OnDragDrop := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnDragOver(Value : TDragOverEvent);
begin
  FOnDragOver := Value;
  FOvcEdit.OnDragOver := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnEndDrag(Value : TEndDragEvent);
begin
  FOnEndDrag := Value;
  FOvcEdit.OnEndDrag := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnKeyDown(Value : TKeyEvent);
begin
  FOnKeyDown := Value;
  FOvcEdit.OnKeyDown := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnKeyPress(Value : TKeyPressEvent);
begin
  FOnKeyPress := Value;
  FOvcEdit.OnKeyPress := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnKeyUp(Value : TKeyEvent);
begin
  FOnKeyUp := Value;
  FOvcEdit.OnKeyUp := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnMouseDown(Value : TMouseEvent);
begin
  FOnMouseDown := Value;
  FOvcEdit.OnMouseDown := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnMouseMove(Value : TMouseMoveEvent);
begin
  FOnMouseMove := Value;
  FOvcEdit.OnMouseMove := Value;
end;

procedure TOvcBorderedTimeEdit.SetOnMouseUp(Value : TMouseEvent);
begin
  FOnMouseUp := Value;
  FOvcEdit.OnMouseUp := Value;
end;

end.

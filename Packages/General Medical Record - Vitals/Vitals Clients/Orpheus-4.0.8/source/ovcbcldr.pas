{*********************************************************}
{*                    OVCBCLDR.PAS 4.06                  *}
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

unit ovcbcldr;
  {-base edit field class w/ label and borders}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, MultiMon, StdCtrls, SysUtils, OvcBase, OvcVer, OvcMisc,
  OvcBordr, OvcEditF, OvcBCalc, OvcEdCal, OvcCal;

const
  BorderMsgClose = WM_USER+10;
  BorderMsgOpen  = WM_USER+11;

type
  TOvcDateEditEx = class(TOvcDateEdit)
  protected
    BorderParent : TOvcBorderEdPopup;
  end;

  TOvcBorderedDateEdit = class(TOvcBorderEdPopup)
  protected
    {base property values}
    FOvcEdit : TOvcDateEditEx;

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
    FPopupAnchor   : TOvcPopupAnchor;
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
    FOnEndDock     : TEndDragEvent;
    FOnStartDock   : TStartDockEvent;
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

    FAllowIncDec         : Boolean;
    FCalendar            : TOvcCalendar;
    FDate                : TDateTime;
    FDateText            : string;
    FEpoch               : Integer;
    FForceCentury        : Boolean;
    FRequiredFields      : TOvcRequiredDateFields;
    FTodayString         : string;

    {event variables}
    FOnGetDate           : TOvcGetDateEvent;
    FOnGetDateMask       : TOvcGetDateMaskEvent;
    FOnPreParseDate      : TOvcPreParseDateEvent;
    FOnSetDate           : TNotifyEvent;

    {base property methods}
    function GetBiDiMode : TBiDiMode;
    function GetParentBiDiMode : Boolean;
    function GetDragKind : TDragKind;
    function GetOnEndDock : TEndDragEvent;
    function GetOnStartDock : TStartDockEvent;

    procedure SetBiDiMode(Value : TBiDiMode); override;
    procedure SetParentBiDiMode(Value : Boolean); override;
    procedure SetDragKind(Value : TDragKind);
    procedure SetOnEndDock(Value : TEndDragEvent);
    procedure SetOnStartDock(Value : TStartDockEvent);

    function GetAbout : string;
    function GetAllowIncDec : Boolean;
    function GetAutoSelect : Boolean;
    function GetAutoSize : Boolean;
    function GetCharCase : TEditCharCase;
    function GetController : TOvcController;
    function GetCursor : TCursor;
    function GetDragCursor : TCursor;
    function GetDragMode : TDragMode;
    function GetEditEnabled : Boolean;
    function GetForceCentury : Boolean;
    function GetFont : TFont;
    function GetHideSelection : Boolean;
    function GetImeMode : TImeMode;
    function GetImeName : string;
    function GetMaxLength : Integer;
    function GetOEMConvert : Boolean;
    function GetParentFont : Boolean;
    function GetParentShowHint : Boolean;
    function GetPasswordChar : Char;
    function GetReadOnly : Boolean;
    function GetRequiredFields : TOvcRequiredDateFields;
    function GetEditText : string;
    function GetEditShowButton : Boolean;
    function GetTodayString : string;

    function GetOnGetDate      : TOvcGetDateEvent;
    function GetOnGetDateMask  : TOvcGetDateMaskEvent;
    function GetOnPreParseDate : TOvcPreParseDateEvent;
    function GetOnSetDate      : TNotifyEvent;

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

    function  GetOnPopupClose : TOvcPopupEvent;
    function  GetOnPopupOpen : TOvcPopupEvent;

    procedure SetAbout(const Value : string);
    procedure SetAllowIncDec(Value : Boolean);
    procedure SetAutoSelect(Value : Boolean);
    procedure SetAutoSize(Value : Boolean); override;
    procedure SetCharCase(Value : TEditCharCase);
    procedure SetEditController(Value : TOvcController);
    procedure SetCursor(Value : TCursor);
    procedure SetDragCursor(Value : TCursor);
    procedure SetEditDragMode(Value : TDragMode);
    procedure SetEditEnabled(Value : Boolean);
    procedure SetFont(Value : TFont);
    procedure SetForceCentury(Value : Boolean);
    procedure SetHideSelection(Value : Boolean);
    procedure SetImeMode(Value : TImeMode);
    procedure SetImeName(const Value : string);
    procedure SetMaxLength(Value : Integer);
    procedure SetOEMConvert(Value : Boolean);
    procedure SetParentFont(Value : Boolean);
    procedure SetParentShowHint(Value : Boolean);
    procedure SetPasswordChar(Value : Char);
    procedure SetReadOnly(Value : Boolean);
    procedure SetRequiredFields(Value : TOvcRequiredDateFields);
    procedure SetEditText(const Value : string);
    procedure SetEditShowButton(Value : Boolean);
    procedure SetTodayString(const Value : string);

    procedure SetOnGetDate(Value : TOvcGetDateEvent);
    procedure SetOnGetDateMask(Value : TOvcGetDateMaskEvent);
    procedure SetOnPreParseDate(Value : TOvcPreParseDateEvent);
    procedure SetOnSetDate(Value : TNotifyEvent);

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

    procedure SetOnPopupClose(Value : TOvcPopupEvent);
    procedure SetOnPopupOpen(Value : TOvcPopupEvent);

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

    procedure SetEpoch(Value : Integer);
    procedure SetEditForceCentury(Value : Boolean);
    procedure SetPopupColors(Value : TOvcCalColors);
    procedure SetPopupFont(Value : TFont);
    procedure SetPopupHeight(Value : Integer);
    procedure SetPopupWidth(Value : Integer);
    procedure SetPopupDateFormat(Value : TOvcDateFormat);
    procedure SetPopupDayNameWidth(Value : TOvcDayNameWidth);
    procedure SetPopupOptions(Value : TOvcCalDisplayOptions);
    procedure SetPopupWeekStarts(Value : TOvcDayType);


  protected
    procedure GlyphChanged;
      override;
    procedure SetDate(Value : TDateTime);

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy; override;

    function DateString(const Mask : string) : string;

    function FormatDate(Value : TDateTime) : string;

    procedure SetDateText(const Value : string);

    property Calendar : TOvcCalendar
      read FCalendar;

    property EditControl : TOvcDateEditEx
      read FOvcEdit;

  published
    property Anchors;

    property BiDiMode : TBiDiMode
      read GetBiDiMode
      write SetBiDiMode;

    property Constraints;

    property ParentBiDiMode : Boolean
      read GetParentBiDiMode
      write SetParentBiDiMode;

    property DragKind : TDragKind
      read GetDragKind
      write SetDragKind;
    property About : string
      read GetAbout
      write SetAbout;

    property AllowIncDec : Boolean
      read GetAllowIncDec
      write SetAllowIncDec;

    property AutoSelect : Boolean
      read GetAutoSelect
      write SetAutoSelect;

    property AutoSize : Boolean
      read GetAutoSize
      write SetAutoSize;

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

    property Epoch : Integer
      read GetEpoch
      write SetEpoch;

    property Enabled : Boolean
      read FEnabled
      write FEnabled;

    property Font : TFont
      read GetFont
      write SetFont;

    property ForceCentury : Boolean
      read GetForceCentury
      write SetEditForceCentury;

    property HideSelection : Boolean
      read GetHideSelection
      write SetHideSelection;

    property ImeMode : TImeMode
      read GetImeMode
      write SetImeMode;

    property ImeName;

    property ParentFont : Boolean
      read GetParentFont
      write SetParentFont;

    property ParentShowHint : Boolean
      read GetParentShowHint
      write SetParentShowHint;

    property PopupAnchor : TOvcPopupAnchor
      read FPopupAnchor
      write FPopupAnchor;

    property PopupColors : TOvcCalColors
      read GetPopupColors
      write SetPopupColors;

    property PopupFont : TFont
      read GetPopupFont
      write SetPopupFont;

    property PopupHeight : Integer
      read GetPopupHeight
      write SetPopupHeight;

    property PopupMenu;

    property PopupWidth : Integer
      read GetPopupWidth
      write SetPopupWidth;

    property PopupDateFormat : TOvcDateFormat
      read  GetPopupDateFormat
      write SetPopupDateFormat;

    property PopupDayNameWidth : TOvcDayNameWidth
      read  GetPopupDayNameWidth
      write SetPopupDayNameWidth;

    property PopupOptions : TOvcCalDisplayOptions
      read  GetPopupOptions
      write SetPopupOptions;

    property PopupWeekStarts : TOvcDayType
      read  GetPopupWeekStarts
      write SetPopupWeekStarts;

    property ReadOnly : Boolean
      read GetReadOnly
      write SetReadOnly;

    property RequiredFields : TOvcRequiredDateFields
      read GetRequiredFields
      write SetRequiredFields;

    property ShowButton : Boolean
      read GetEditShowButton
      write SetEditShowButton;

    property ShowHint;
    property TabOrder;

    property TodayString : string
      read GetTodayString
      write SetTodayString;

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

    property OnGetDate : TOvcGetDateEvent
      read GetOnGetDate
      write SetOnGetDate;

    property OnGetDateMask : TOvcGetDateMaskEvent
      read GetOnGetDateMask
      write SetOnGetDateMask;

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

    property OnPopupClose : TOvcPopupEvent
      read GetOnPopupClose
      write SetOnPopupClose;

    property OnPopupOpen : TOvcPopupEvent
      read GetOnPopupOpen
      write SetOnPopupOpen;

    property OnPreParseDate : TOvcPreParseDateEvent
      read GetOnPreParseDate
      write SetOnPreParseDate;

    property OnSetDate : TNotifyEvent
      read GetOnSetDate
      write SetOnSetDate;

    property OnStartDrag;
  end;


implementation

uses
  OvcFormatSettings;

{******************************************************************************}
{                        TOvcBorderedDateEdit                                  }
{******************************************************************************}

constructor TOvcBorderedDateEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FOvcEdit := TOvcDateEditEx.Create(Self);
  SetEditControl(TOvcCustomEdit(FOvcEdit));

  FOvcEdit.Ctl3D := False;
  FOvcEdit.BorderStyle := bsNone;
  FOvcEdit.ParentColor := True;
  FOvcEdit.Parent := Self;
  FOvcEdit.Top := 0;
  FOvcEdit.Left := 0;
  FOvcEdit.TabStop := TabStop;
  FOvcEdit.BorderParent := Self;

  FButton        := FOvcEdit.FButton;
  FButtonGlyph   := FOvcEdit.FButtonGlyph;
  FPopupActive   := FOvcEdit.FPopupActive;
  FOnPopupClose  := FOvcEdit.FOnPopupClose;
  FShowButton    := FOvcEdit.FShowButton;

  Height := FEdit.Height;
  Width  := FEdit.Width;

  DoShowButton := FOvcEdit.ShowButton;
  ButtonWidth := FOvcEdit.ButtonGlyph.Width + 4;

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
  FOnEndDock     := FOvcEdit.OnEndDock;
  FOnStartDock   := FOvcEdit.OnStartDock;
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

  FAllowIncDec         := True;
  FForceCentury        := False;
  FRequiredFields      := [rfMonth, rfDay];
  FTodayString         := FormatSettings.DateSeparator;

  {load button glyph}
  FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCAL');
  FButton.Glyph.Assign(FButtonGlyph);

  FCalendar := FOvcEdit.Calendar;
end;


destructor TOvcBorderedDateEdit.Destroy;
begin
  FOvcEdit.Free;
  FOvcEdit := nil;

  inherited Destroy;
end;

function TOvcBorderedDateEdit.DateString(const Mask : string) : string;
begin
  Result := FOvcEdit.DateString(Mask);
end;

function TOvcBorderedDateEdit.FormatDate(Value : TDateTime) : string;
begin
  Result := FOvcEdit.FormatDate(Value);
end;


function TOvcBorderedDateEdit.GetParentFont : Boolean;
begin
  Result := FOvcEdit.ParentFont;
  FParentFont := Result;
end;


function TOvcBorderedDateEdit.GetDate : TDateTime;
begin
  Result := FOvcEdit.GetDate;
end;

function TOvcBorderedDateEdit.GetEpoch : Integer;
begin
  Result := FOvcEdit.GetEpoch;
end;

function  TOvcBorderedDateEdit.GetOnPopupClose : TOvcPopupEvent;
begin
  Result := FOvcEdit.OnPopupClose;
  FOnPopupClose := Result;
end;

function TOvcBorderedDateEdit.GetOnPopupOpen : TOvcPopupEvent;
begin
  Result := FOvcEdit.OnPopupOpen;
  FOnPopupOpen := Result;
end;

function TOvcBorderedDateEdit.GetPopupColors : TOvcCalColors;
begin
  Result := FOvcEdit.Calendar.Colors;
end;

function  TOvcBorderedDateEdit.GetPopupDateFormat : TOvcDateFormat;
begin
  Result := FOvcEdit.Calendar.DateFormat;
end;

function  TOvcBorderedDateEdit.GetPopupDayNameWidth : TOvcDayNameWidth;
begin
  Result := FOvcEdit.Calendar.DayNameWidth;
end;

function TOvcBorderedDateEdit.GetPopupFont : TFont;
begin
  Result := FOvcEdit.Calendar.Font;
end;

function TOvcBorderedDateEdit.GetPopupHeight : Integer;
begin
  Result := FOvcEdit.Calendar.Height;
end;

function  TOvcBorderedDateEdit.GetPopupOptions: TOvcCalDisplayOptions;
begin
  Result := FOvcEdit.Calendar.Options;
end;

function  TOvcBorderedDateEdit.GetPopupWeekStarts: TOvcDayType;
begin
  Result := FOvcEdit.Calendar.WeekStarts;
end;

function TOvcBorderedDateEdit.GetPopupWidth : Integer;
begin
  Result := FOvcEdit.Calendar.Width;
end;

function TOvcBorderedDateEdit.GetReadOnly : Boolean;
begin
  FReadOnly := FOvcEdit.ReadOnly;
  Result := FReadOnly;
end;

function TOvcBorderedDateEdit.GetRequiredFields : TOvcRequiredDateFields;
begin
  FRequiredFields := FOvcEdit.RequiredFields;
  Result := FRequiredFields;
end;

procedure TOvcBorderedDateEdit.GlyphChanged;
begin
  inherited GlyphChanged;

  if FButtonGlyph.Empty then
    FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCAL');
end;



procedure TOvcBorderedDateEdit.SetDate(Value : TDateTime);
begin
  FOvcEdit.SetDate(Value);
  FDate := Value;
end;

procedure TOvcBorderedDateEdit.SetDateText(const Value : string);
begin
  FOvcEdit.SetDateText(Value);
  FDateText := Value;
end;


procedure TOvcBorderedDateEdit.SetReadOnly(Value : Boolean);
begin
  FOvcEdit.ReadOnly := Value;
  FReadOnly := Value;
end;

procedure TOvcBorderedDateEdit.SetRequiredFields(Value : TOvcRequiredDateFields);
begin
  FRequiredFields := Value;
  FOvcEdit.RequiredFields := Value;
end;

procedure TOvcBorderedDateEdit.SetEpoch(Value : Integer);
begin
  FOvcEdit.SetEpoch(Value);
  FEpoch := Value;
end;

procedure TOvcBorderedDateEdit.SetEditForceCentury(Value : Boolean);
begin
  FOvcEdit.SetForceCentury(Value);
  FForceCentury := Value;
end;

procedure TOvcBorderedDateEdit.SetOnPopupClose(Value : TOvcPopupEvent);
begin
  FOvcEdit.OnPopupClose := Value;
  FOnPopupClose := Value;
end;

procedure TOvcBorderedDateEdit.SetOnPopupOpen(Value : TOvcPopupEvent);
begin
  FOvcEdit.OnPopupOpen := Value;
  FOnPopupOpen := Value;
end;

procedure TOvcBorderedDateEdit.SetPopupColors(Value : TOvcCalColors);
begin
  FOvcEdit.SetPopupColors(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupFont(Value : TFont);
begin
  FOvcEdit.SetPopupFont(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupHeight(Value : Integer);
begin
  FOvcEdit.SetPopupHeight(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupWidth(Value : Integer);
begin
  FOvcEdit.SetPopupWidth(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupDateFormat(Value : TOvcDateFormat);
begin
  FOvcEdit.SetPopupDateFormat(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupDayNameWidth(Value : TOvcDayNameWidth);
begin
  FOvcEdit.SetPopupDayNameWidth(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupOptions(Value : TOvcCalDisplayOptions);
begin
  FOvcEdit.SetPopupOptions(Value);
end;

procedure TOvcBorderedDateEdit.SetPopupWeekStarts(Value : TOvcDayType);
begin
  FOvcEdit.SetPopupWeekStarts(Value);
end;



{base property methods}
function TOvcBorderedDateEdit.GetBiDiMode : TBiDiMode;
begin
  Result := FOvcEdit.BiDiMode;
  FBiDiMode := Result;
end;

function TOvcBorderedDateEdit.GetParentBiDiMode : Boolean;
begin
  Result := FOvcEdit.ParentBiDiMode;
  FParentBiDiMode := Result;
end;

function TOvcBorderedDateEdit.GetDragKind : TDragKind;
begin
  Result := FOvcEdit.DragKind;
  FDragKind := Result;
end;

function TOvcBorderedDateEdit.GetOnEndDock : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDock;
  FOnEndDock := Result;
end;

function TOvcBorderedDateEdit.GetOnStartDock : TStartDockEvent;
begin
  Result := FOvcEdit.OnStartDock;
  FOnStartDock := Result;
end;


procedure TOvcBorderedDateEdit.SetBiDiMode(Value : TBiDiMode);
begin
  if (Value <> FBiDiMode) then begin
    inherited;
    FBiDiMode := Value;
    FOvcEdit.BiDiMode := Value;
  end;
end;

procedure TOvcBorderedDateEdit.SetParentBiDiMode(Value : Boolean);
begin
  if (Value <> FParentBiDiMode) then begin
    inherited;
    FParentBiDiMode := Value;
    FOvcEdit.ParentBiDiMode := Value;
  end;
end;

procedure TOvcBorderedDateEdit.SetDragKind(Value : TDragKind);
begin
  if (Value <> FDragKind) then begin
    FDragKind := Value;
    FOvcEdit.DragKind := Value;
  end;
end;

procedure TOvcBorderedDateEdit.SetOnEndDock(Value : TEndDragEvent);
begin
  FOnEndDock := Value;
  FOvcEdit.OnEndDock := Value;
end;

procedure TOvcBorderedDateEdit.SetOnStartDock(Value : TStartDockEvent);
begin
  FOnStartDock := Value;
  FOvcEdit.OnStartDock := Value;
end;

function TOvcBorderedDateEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;

function TOvcBorderedDateEdit.GetAllowIncDec : Boolean;
begin
  Result := FOvcEdit.AllowIncDec;
  FAllowIncDec := Result;
end;

function TOvcBorderedDateEdit.GetAutoSelect : Boolean;
begin
  Result := FOvcEdit.AutoSelect;
  FAutoSelect := FOvcEdit.AutoSelect;
end;

function TOvcBorderedDateEdit.GetAutoSize : Boolean;
begin
  Result := FOvcEdit.AutoSize;
  FAutoSize := FOvcEdit.AutoSize;
end;

function TOvcBorderedDateEdit.GetCharCase : TEditCharCase;
begin
  Result := FOvcEdit.CharCase;
  FCharCase := Result;
end;

function TOvcBorderedDateEdit.GetController : TOvcController;
begin
  Result := FOvcEdit.Controller;
  FController := Result;
end;

function TOvcBorderedDateEdit.GetCursor : TCursor;
begin
  Result := FOvcEdit.Cursor;
  FCursor := Result;
end;


function TOvcBorderedDateEdit.GetDragCursor : TCursor;
begin
  Result := FOvcEdit.DragCursor;
  FDragCursor := Result;
end;


function TOvcBorderedDateEdit.GetDragMode : TDragMode;
begin
  Result := FOvcEdit.DragMode;
  FDragMode := Result;
end;


function TOvcBorderedDateEdit.GetEditEnabled : Boolean;
begin
  Result := FOvcEdit.Enabled;
  FEnabled := FOvcEdit.Enabled;
end;

function TOvcBorderedDateEdit.GetFont : TFont;
begin
  Result := FOvcEdit.Font;
  FFont  := Result;
end;

function TOvcBorderedDateEdit.GetForceCentury : Boolean;
begin
  Result := FOvcEdit.ForceCentury;
  FForceCentury  := Result;
end;

function TOvcBorderedDateEdit.GetHideSelection : Boolean;
begin
  Result := FOvcEdit.HideSelection;
  FHideSelection := Result;
end;

function TOvcBorderedDateEdit.GetImeMode : TImeMode;
begin
  Result := FOvcEdit.ImeMode;
  FImeMode := Result;
end;

function TOvcBorderedDateEdit.GetImeName : string;
begin
  Result := FOvcEdit.ImeName;
  FImeName := Result;
end;

function TOvcBorderedDateEdit.GetMaxLength : Integer;
begin
  Result := FOvcEdit.MaxLength;
  FMaxLength := Result;
end;

function TOvcBorderedDateEdit.GetOEMConvert : Boolean;
begin
  Result := FOvcEdit.OEMConvert;
  FOEMConvert := Result;
end;

function TOvcBorderedDateEdit.GetParentShowHint : Boolean;
begin
  Result := FOvcEdit.ParentShowHint;
  FParentShowHint := Result;
end;

function TOvcBorderedDateEdit.GetPasswordChar : Char;
begin
  Result := FOvcEdit.PasswordChar;
  FPasswordChar := Result;
end;

function TOvcBorderedDateEdit.GetEditText: string;
begin
  Result := FOvcEdit.Text;
  FText := Result;
end;

function  TOvcBorderedDateEdit.GetEditShowButton : Boolean;
begin
  Result := FOvcEdit.ShowButton;
  FShowButton := Result;
end;

function TOvcBorderedDateEdit.GetTodayString : string;
begin
  Result := FOvcEdit.TodayString;
  FTodayString := Result;
end;

function TOvcBorderedDateEdit.GetOnGetDate : TOvcGetDateEvent;
begin
  Result := FOvcEdit.OnGetDate;
  FOnGetDate := Result;
end;

function TOvcBorderedDateEdit.GetOnGetDateMask : TOvcGetDateMaskEvent;
begin
  Result := FOvcEdit.OnGetDateMask;
  FOnGetDateMask := Result;
end;

function TOvcBorderedDateEdit.GetOnPreParseDate : TOvcPreParseDateEvent;
begin
  Result := FOvcEdit.OnPreParseDate;
  FOnPreParseDate := Result;
end;

function TOvcBorderedDateEdit.GetOnSetDate : TNotifyEvent;
begin
  Result := FOvcEdit.OnSetDate;
  FOnSetDate := Result;
end;

function TOvcBorderedDateEdit.GetOnChange : TNotifyEvent;
begin
  Result := FOvcEdit.OnChange;
  FOnChange := Result;
end;

function TOvcBorderedDateEdit.GetOnClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnClick;
  FOnClick := Result;
end;

function TOvcBorderedDateEdit.GetOnDblClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnDblClick;
  FOnDblClick := Result;
end;

function TOvcBorderedDateEdit.GetOnDragDrop : TDragDropEvent;
begin
  Result := FOvcEdit.OnDragDrop;
  FOnDragDrop := Result;
end;

function TOvcBorderedDateEdit.GetOnDragOver : TDragOverEvent;
begin
  Result := FOvcEdit.OnDragOver;
  FOnDragOver := Result;
end;

function TOvcBorderedDateEdit.GetOnEndDrag : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDrag;
  FOnEndDrag := Result;
end;

function TOvcBorderedDateEdit.GetOnKeyDown : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyDown;
  FOnKeyDown := Result;
end;

function TOvcBorderedDateEdit.GetOnKeyPress : TKeyPressEvent;
begin
  Result := FOvcEdit.OnKeyPress;
  FOnKeyPress := Result;
end;

function TOvcBorderedDateEdit.GetOnKeyUp : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyUp;
  FOnKeyUp := Result;
end;

function TOvcBorderedDateEdit.GetOnMouseDown : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseDown;
  FOnMouseDown := Result;
end;

function TOvcBorderedDateEdit.GetOnMouseMove : TMouseMoveEvent;
begin
  Result := FOvcEdit.OnMouseMove;
  FOnMouseMove := Result;
end;

function TOvcBorderedDateEdit.GetOnMouseUp : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseUp;
  FOnMouseUp := Result;
end;



procedure TOvcBorderedDateEdit.SetAbout(const Value : string);
begin
  FAbout := Value;
  FOvcEdit.About := Value;
end;

procedure TOvcBorderedDateEdit.SetAllowIncDec(Value : Boolean);
begin
  FAllowIncDec := Value;
  FOvcEdit.AllowIncDec := Value;
end;

procedure TOvcBorderedDateEdit.SetAutoSelect(Value : Boolean);
begin
  FAutoSelect := Value;
  FOvcEdit.AutoSelect := Value;
end;


procedure TOvcBorderedDateEdit.SetAutoSize(Value : Boolean);
begin
  FAutoSize := Value;
  FOvcEdit.AutoSize := Value;
end;


procedure TOvcBorderedDateEdit.SetCharCase(Value : TEditCharCase);
begin
  FCharCase := Value;
  FOvcEdit.CharCase := Value;
end;

procedure TOvcBorderedDateEdit.SetEditController(Value : TOvcController);
begin
  FController := Value;
  FOvcEdit.Controller := Value;
end;

procedure TOvcBorderedDateEdit.SetCursor(Value : TCursor);
begin
  FCursor := Value;
  FOvcEdit.Cursor := Value;
end;


procedure TOvcBorderedDateEdit.SetDragCursor(Value : TCursor);
begin
  if (Value <> FDragCursor) then begin
    FDragCursor := Value;
    FOvcEdit.DragCursor := Value;
  end;
end;


procedure TOvcBorderedDateEdit.SetEditDragMode(Value : TDragMode);
begin
  if (Value <> FDragMode) then begin
    FDragMode := Value;
    FOvcEdit.DragMode := Value;
  end;
end;

procedure TOvcBorderedDateEdit.SetEditEnabled(Value : Boolean);
begin
  Enabled := Value;
  FEnabled := Value;
  FOvcEdit.Enabled := Value;
end;

procedure TOvcBorderedDateEdit.SetEditShowButton(Value : Boolean);
begin
  FOvcEdit.ShowButton := Value;
  FShowButton := Value;
end;

procedure TOvcBorderedDateEdit.SetFont(Value : TFont);
begin
  FFont := Value;
  FOvcEdit.Font := Value;
end;

procedure TOvcBorderedDateEdit.SetForceCentury(Value : Boolean);
begin
  FForceCentury := Value;
  FOvcEdit.ForceCentury := Value;
end;

procedure TOvcBorderedDateEdit.SetHideSelection(Value : Boolean);
begin
  FHideSelection := Value;
  FOvcEdit.HideSelection := Value;
end;

procedure TOvcBorderedDateEdit.SetImeMode(Value : TImeMode);
begin
  FImeMode := Value;
  FOvcEdit.ImeMode := Value;
end;

procedure TOvcBorderedDateEdit.SetImeName(const Value : string);
begin
  FImeName := Value;
  FOvcEdit.ImeName := Value;
end;

procedure TOvcBorderedDateEdit.SetMaxLength(Value : Integer);
begin
  FMaxLength := Value;
  FOvcEdit.MaxLength := Value;
end;

procedure TOvcBorderedDateEdit.SetOEMConvert(Value : Boolean);
begin
  FOEMConvert := Value;
  FOvcEdit.OEMConvert := Value;
end;

procedure TOvcBorderedDateEdit.SetParentFont(Value : Boolean);
begin
  FParentFont := Value;
  FOvcEdit.ParentFont := Value;
end;

procedure TOvcBorderedDateEdit.SetParentShowHint(Value : Boolean);
begin
  FParentShowHint := Value;
  FOvcEdit.ParentShowHint := Value;
end;

procedure TOvcBorderedDateEdit.SetPasswordChar(Value : Char);
begin
  FPasswordChar := Value;
  FOvcEdit.PasswordChar := Value;
end;


procedure TOvcBorderedDateEdit.SetEditText(const Value : string);
begin
  FText := Value;
  FOvcEdit.Text := Value;
end;

procedure TOvcBorderedDateEdit.SetTodayString(const Value : string);
begin
  FTodayString := Value;
  FOvcEdit.TodayString := Value;
end;


procedure TOvcBorderedDateEdit.SetOnGetDate(Value : TOvcGetDateEvent);
begin
  FOnGetDate := Value;
  FOvcEdit.OnGetDate := Value;
end;

procedure TOvcBorderedDateEdit.SetOnGetDateMask(Value : TOvcGetDateMaskEvent);
begin
  FOnGetDateMask := Value;
  FOvcEdit.OnGetDateMask := Value;
end;

procedure TOvcBorderedDateEdit.SetOnPreParseDate(Value : TOvcPreParseDateEvent);
begin
  FOnPreParseDate := Value;
  FOvcEdit.OnPreParseDate := Value;
end;

procedure TOvcBorderedDateEdit.SetOnSetDate(Value : TNotifyEvent);
begin
  FOnSetDate := Value;
  FOvcEdit.OnSetDate := Value;
end;


procedure TOvcBorderedDateEdit.SetOnChange(Value : TNotifyEvent);
begin
  FOnChange := Value;
  FOvcEdit.OnChange := Value;
end;

procedure TOvcBorderedDateEdit.SetOnClick(Value : TNotifyEvent);
begin
  FOnClick := Value;
  FOvcEdit.OnClick := Value;
end;

procedure TOvcBorderedDateEdit.SetOnDblClick(Value : TNotifyEvent);
begin
  FOnDblClick := Value;
  FOvcEdit.OnDblClick := Value;
end;

procedure TOvcBorderedDateEdit.SetOnDragDrop(Value : TDragDropEvent);
begin
  FOnDragDrop := Value;
  FOvcEdit.OnDragDrop := Value;
end;

procedure TOvcBorderedDateEdit.SetOnDragOver(Value : TDragOverEvent);
begin
  FOnDragOver := Value;
  FOvcEdit.OnDragOver := Value;
end;

procedure TOvcBorderedDateEdit.SetOnEndDrag(Value : TEndDragEvent);
begin
  FOnEndDrag := Value;
  FOvcEdit.OnEndDrag := Value;
end;

procedure TOvcBorderedDateEdit.SetOnKeyDown(Value : TKeyEvent);
begin
  FOnKeyDown := Value;
  FOvcEdit.OnKeyDown := Value;
end;

procedure TOvcBorderedDateEdit.SetOnKeyPress(Value : TKeyPressEvent);
begin
  FOnKeyPress := Value;
  FOvcEdit.OnKeyPress := Value;
end;

procedure TOvcBorderedDateEdit.SetOnKeyUp(Value : TKeyEvent);
begin
  FOnKeyUp := Value;
  FOvcEdit.OnKeyUp := Value;
end;

procedure TOvcBorderedDateEdit.SetOnMouseDown(Value : TMouseEvent);
begin
  FOnMouseDown := Value;
  FOvcEdit.OnMouseDown := Value;
end;

procedure TOvcBorderedDateEdit.SetOnMouseMove(Value : TMouseMoveEvent);
begin
  FOnMouseMove := Value;
  FOvcEdit.OnMouseMove := Value;
end;

procedure TOvcBorderedDateEdit.SetOnMouseUp(Value : TMouseEvent);
begin
  FOnMouseUp := Value;
  FOvcEdit.OnMouseUp := Value;
end;

end.

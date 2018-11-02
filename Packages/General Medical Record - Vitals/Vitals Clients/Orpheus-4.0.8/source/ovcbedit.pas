{*********************************************************}
{*                    OVCBEDIT.PAS 4.06                  *}
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

unit ovcbedit;
  {-base edit field class w/ label and borders}

interface

uses
  Windows, Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  Messages, StdCtrls, SysUtils, OvcBase, OvcVer,
  OvcBordr, OvcEditF;

type
  TOvcBorderedEdit = class;

  TOvcEditEx = class(TOvcEdit)
  protected
    BorderParent : TOvcBorderedEdit;
  end;


  TOvcBorderedEdit = class(TOvcBorderParent)
  protected
    FOvcEdit : TOvcEditEx;

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

  protected
    procedure CreateWnd; override;

    {property methods}
    function GetBiDiMode : TBiDiMode;
    function GetParentBiDiMode : Boolean;
    function GetDragKind : TDragKind;
    function GetOnEndDock : TEndDragEvent;
    function GetOnStartDock : TStartDockEvent;

    procedure SetEditBiDiMode(Value : TBiDiMode);
    procedure SetEditParentBiDiMode(Value : Boolean);
    procedure SetDragKind(Value : TDragKind);
    procedure SetOnEndDock(Value : TEndDragEvent);
    procedure SetOnStartDock(Value : TStartDockEvent);

    function GetAbout : string;
    function GetAutoSelect : Boolean;
    function GetAutoSize : Boolean;
    function GetCharCase : TEditCharCase;
    function GetController : TOvcController;
    function GetCursor : TCursor;
    function GetDragCursor : TCursor;
    function GetDragMode : TDragMode;
    function GetEditEnabled : Boolean;
    function GetEditHeight  : integer;
    function GetEditWidth   : integer;
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
    function GetParentFont : Boolean;

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
    procedure SetEditHeight(Value : integer);
    procedure SetEditWidth(Value : integer);
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
    procedure SetParentFont(Value : Boolean);

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

    procedure KeyPress(var Key : Char); override;
  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    property EditControl : TOvcEditEx
      read FOvcEdit;

  published
    property Anchors;

    property BiDiMode : TBiDiMode
      read GetBiDiMode
      write SetEditBiDiMode;

    property ParentBiDiMode : Boolean
      read GetParentBiDiMode
      write SetEditParentBiDiMode;

    property DragKind : TDragKind
      read GetDragKind
      write SetDragKind;

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

    property ParentFont : Boolean
      read GetParentFont
      write SetParentFont;

    property ParentShowHint : Boolean
      read GetParentShowHint
      write SetParentShowHint;

    property PasswordChar : Char
      read GetPasswordChar
      write SetPasswordChar;

    property PopupMenu;

    property ReadOnly : Boolean
      read GetReadOnly
      write SetReadOnly;

    property ShowHint;
    property TabOrder;
    property TabStop;

    property Text : string
      read GetEditText
      write SetEditText;

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

    property OnEndDock : TEndDragEvent
      read GetOnEndDock
      write SetOnEndDock;

    property OnStartDock : TStartDockEvent
      read GetOnStartDock
      write SetOnStartDock;

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
{                        TOvcBorderedEdit                                      }
{******************************************************************************}

constructor TOvcBorderedEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FOvcEdit := TOvcEditEx.Create(Self);
  FOvcEdit.BorderParent := Self;
  SetEditControl(TOvcCustomEdit(FOvcEdit));

  FOvcEdit.Parent := Self;
  FOvcEdit.Ctl3D := False;
  FOvcEdit.BorderStyle := bsNone;
  FOvcEdit.ParentColor := True;
  FOvcEdit.TabStop := TabStop;
  Borders.BottomBorder.Enabled := True;

  FOvcEdit.Top := 0;
  FOvcEdit.Left := 0;

(*
  Height := FOvcEdit.BorderParent.Height;
  Width  := FOvcEdit.BorderParent.Width;
*)

  FBiDiMode      := FOvcEdit.BiDiMode;
  FParentBiDiMode:= FOvcEdit.ParentBiDiMode;
  FDragKind      := FOvcEdit.DragKind;
  FAbout         := FOvcEdit.About;
  FAutoSelect    := FOvcEdit.AutoSelect;
  FAutoSize      := FOvcEdit.AutoSize;
  FBorderStyle   := FOvcEdit.BorderStyle;
  FCharCase      := FOvcEdit.CharCase;
  FController    := FOvcEdit.Controller;
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
  FVisible       := FOvcEdit.Visible;

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
end;

destructor TOvcBorderedEdit.Destroy;
begin
  FOvcEdit.Free;
  FOvcEdit := nil;

  inherited Destroy;
end;

procedure TOvcBorderedEdit.CreateWnd;
begin
  inherited CreateWnd;

  SetBounds(Left, Top, Width, Height);
end;

function TOvcBorderedEdit.GetBiDiMode : TBiDiMode;
begin
  Result := FOvcEdit.BiDiMode;
  FBiDiMode := Result;
end;

function TOvcBorderedEdit.GetParentBiDiMode : Boolean;
begin
  Result := FOvcEdit.ParentBiDiMode;
  FParentBiDiMode := Result;
end;

function TOvcBorderedEdit.GetDragKind : TDragKind;
begin
  Result := FOvcEdit.DragKind;
  FDragKind := Result;
end;

function TOvcBorderedEdit.GetOnEndDock : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDock;
  FOnEndDock := Result;
end;

function TOvcBorderedEdit.GetOnStartDock : TStartDockEvent;
begin
  Result := FOvcEdit.OnStartDock;
  FOnStartDock := Result;
end;


procedure TOvcBorderedEdit.SetEditBiDiMode(Value : TBiDiMode);
begin
  FBiDiMode := Value;
  FOvcEdit.BiDiMode := Value;
end;

procedure TOvcBorderedEdit.SetEditParentBiDiMode(Value : Boolean);
begin
  FParentBiDiMode := Value;
  FOvcEdit.ParentBiDiMode := Value;
end;

procedure TOvcBorderedEdit.SetDragKind(Value : TDragKind);
begin
  FDragKind := Value;
  FOvcEdit.DragKind := Value;
end;

procedure TOvcBorderedEdit.SetOnEndDock(Value : TEndDragEvent);
begin
  FOnEndDock := Value;
  FOvcEdit.OnEndDock := Value;
end;

procedure TOvcBorderedEdit.SetOnStartDock(Value : TStartDockEvent);
begin
  FOnStartDock := Value;
  FOvcEdit.OnStartDock := Value;
end;

function TOvcBorderedEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;

function TOvcBorderedEdit.GetAutoSelect : Boolean;
begin
  Result := FOvcEdit.AutoSelect;
  FAutoSelect := FOvcEdit.AutoSelect;
end;

function TOvcBorderedEdit.GetAutoSize : Boolean;
begin
  Result := FOvcEdit.AutoSize;
  FAutoSize := FOvcEdit.AutoSize;
end;

function TOvcBorderedEdit.GetCharCase : TEditCharCase;
begin
  Result := FOvcEdit.CharCase;
  FCharCase := Result;
end;

function TOvcBorderedEdit.GetController : TOvcController;
begin
  Result := FOvcEdit.Controller;
  FController := Result;
end;

function TOvcBorderedEdit.GetCursor : TCursor;
begin
  Result := FOvcEdit.Cursor;
  FCursor := Result;
end;


function TOvcBorderedEdit.GetDragCursor : TCursor;
begin
  Result := FOvcEdit.DragCursor;
  FDragCursor := Result;
end;


function TOvcBorderedEdit.GetDragMode : TDragMode;
begin
  Result := FOvcEdit.DragMode;
  FDragMode := Result;
end;


function TOvcBorderedEdit.GetEditEnabled : Boolean;
begin
  Result := FOvcEdit.Enabled;
  FEnabled := FOvcEdit.Enabled;
end;

function TOvcBorderedEdit.GetEditHeight : integer;
begin
  Result := FOvcEdit.Height;
{  FHeight := FOvcEdit.Height;}
end;

function TOvcBorderedEdit.GetEditWidth : integer;
begin
  Result := FOvcEdit.Width;
  FWidth := FOvcEdit.Width;
end;

function TOvcBorderedEdit.GetFont : TFont;
begin
  Result := FOvcEdit.Font;
  FFont  := Result;
end;

function TOvcBorderedEdit.GetHideSelection : Boolean;
begin
  Result := FOvcEdit.HideSelection;
  FHideSelection := Result;
end;

function TOvcBorderedEdit.GetImeMode : TImeMode;
begin
  Result := FOvcEdit.ImeMode;
  FImeMode := Result;
end;

function TOvcBorderedEdit.GetImeName : string;
begin
  Result := FOvcEdit.ImeName;
  FImeName := Result;
end;

function TOvcBorderedEdit.GetMaxLength : Integer;
begin
  Result := FOvcEdit.MaxLength;
  FMaxLength := Result;
end;

function TOvcBorderedEdit.GetOEMConvert : Boolean;
begin
  Result := FOvcEdit.OEMConvert;
  FOEMConvert := Result;
end;

function TOvcBorderedEdit.GetParentFont : Boolean;
begin
  Result := FOvcEdit.ParentFont;
  FParentFont := Result;
end;

function TOvcBorderedEdit.GetParentShowHint : Boolean;
begin
  Result := FOvcEdit.ParentShowHint;
  FParentShowHint := Result;
end;

function TOvcBorderedEdit.GetPasswordChar : Char;
begin
  Result := FOvcEdit.PasswordChar;
  FPasswordChar := Result;
end;

function TOvcBorderedEdit.GetReadOnly : Boolean;
begin
  Result := FOvcEdit.ReadOnly;
  FReadOnly := Result;
end;


function TOvcBorderedEdit.GetEditText: string;
begin
  Result := FOvcEdit.Text;
  FText := Result;
end;

function TOvcBorderedEdit.GetOnChange : TNotifyEvent;
begin
  Result := FOvcEdit.OnChange;
  FOnChange := Result;
end;

function TOvcBorderedEdit.GetOnClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnClick;
  FOnClick := Result;
end;

function TOvcBorderedEdit.GetOnDblClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnDblClick;
  FOnDblClick := Result;
end;

function TOvcBorderedEdit.GetOnDragDrop : TDragDropEvent;
begin
  Result := FOvcEdit.OnDragDrop;
  FOnDragDrop := Result;
end;

function TOvcBorderedEdit.GetOnDragOver : TDragOverEvent;
begin
  Result := FOvcEdit.OnDragOver;
  FOnDragOver := Result;
end;

function TOvcBorderedEdit.GetOnEndDrag : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDrag;
  FOnEndDrag := Result;
end;

function TOvcBorderedEdit.GetOnKeyDown : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyDown;
  FOnKeyDown := Result;
end;

function TOvcBorderedEdit.GetOnKeyPress : TKeyPressEvent;
begin
  Result := FOvcEdit.OnKeyPress;
  FOnKeyPress := Result;
end;

function TOvcBorderedEdit.GetOnKeyUp : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyUp;
  FOnKeyUp := Result;
end;

function TOvcBorderedEdit.GetOnMouseDown : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseDown;
  FOnMouseDown := Result;
end;

function TOvcBorderedEdit.GetOnMouseMove : TMouseMoveEvent;
begin
  Result := FOvcEdit.OnMouseMove;
  FOnMouseMove := Result;
end;

function TOvcBorderedEdit.GetOnMouseUp : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseUp;
  FOnMouseUp := Result;
end;


procedure TOvcBorderedEdit.SetAbout(const Value : string);
begin
end;


procedure TOvcBorderedEdit.SetAutoSelect(Value : Boolean);
begin
  FAutoSelect := Value;
  FOvcEdit.AutoSelect := Value;
end;


procedure TOvcBorderedEdit.SetAutoSize(Value : Boolean);
begin
  FAutoSize := Value;
  FOvcEdit.AutoSize := Value;
end;


procedure TOvcBorderedEdit.SetCharCase(Value : TEditCharCase);
begin
  FCharCase := Value;
  FOvcEdit.CharCase := Value;
end;

procedure TOvcBorderedEdit.SetEditController(Value : TOvcController);
begin
  FController := Value;
  FOvcEdit.Controller := Value;
end;

procedure TOvcBorderedEdit.SetCursor(Value : TCursor);
begin
  FCursor := Value;
  FOvcEdit.Cursor := Value;
end;

procedure TOvcBorderedEdit.SetDragCursor(Value : TCursor);
begin
  FDragCursor := Value;
  FOvcEdit.DragCursor := Value;
end;


procedure TOvcBorderedEdit.SetEditDragMode(Value : TDragMode);
begin
  FDragMode := Value;
  FOvcEdit.DragMode := Value;
end;

procedure TOvcBorderedEdit.SetEditEnabled(Value : Boolean);
begin
  FEnabled := Value;
  Enabled  := Value;
  FOvcEdit.Enabled := Value;
end;

procedure TOvcBorderedEdit.SetEditHeight(Value : integer);
begin
  FHeight := Value;
  FOvcEdit.Height := Value;
  Refresh;
end;

procedure TOvcBorderedEdit.SetEditWidth(Value : integer);
begin
  FWidth := Value;
  FOvcEdit.Width := Value;
  Refresh;
end;

procedure TOvcBorderedEdit.SetFont(Value : TFont);
begin
  FFont := Value;
  FOvcEdit.Font := Value;
end;

procedure TOvcBorderedEdit.SetHideSelection(Value : Boolean);
begin
  FHideSelection := Value;
  FOvcEdit.HideSelection := Value;
end;

procedure TOvcBorderedEdit.SetImeMode(Value : TImeMode);
begin
  FImeMode := Value;
  FOvcEdit.ImeMode := Value;
end;

procedure TOvcBorderedEdit.SetImeName(const Value : string);
begin
  FImeName := Value;
  FOvcEdit.ImeName := Value;
end;

procedure TOvcBorderedEdit.SetMaxLength(Value : Integer);
begin
  FMaxLength := Value;
  FOvcEdit.MaxLength := Value;
end;

procedure TOvcBorderedEdit.SetOEMConvert(Value : Boolean);
begin
  FOEMConvert := Value;
  FOvcEdit.OEMConvert := Value;
end;


procedure TOvcBorderedEdit.SetParentFont(Value : Boolean);
begin
  FParentFont := Value;
  FOvcEdit.ParentFont := Value;
end;


procedure TOvcBorderedEdit.SetParentShowHint(Value : Boolean);
begin
  FParentShowHint := Value;
  FOvcEdit.ParentShowHint := Value;
end;

procedure TOvcBorderedEdit.SetPasswordChar(Value : Char);
begin
  FPasswordChar := Value;
  FOvcEdit.PasswordChar := Value;
end;

procedure TOvcBorderedEdit.SetReadOnly(Value : Boolean);
begin
  FReadOnly := Value;
  FOvcEdit.ReadOnly := Value;
end;

procedure TOvcBorderedEdit.SetEditText(const Value : string);
begin
  FText := Value;
  FOvcEdit.Text := Value;
end;

procedure TOvcBorderedEdit.SetOnChange(Value : TNotifyEvent);
begin
  FOnChange := Value;
  FOvcEdit.OnChange := Value;
end;

procedure TOvcBorderedEdit.SetOnClick(Value : TNotifyEvent);
begin
  FOnClick := Value;
  FOvcEdit.OnClick := Value;
end;

procedure TOvcBorderedEdit.SetOnDblClick(Value : TNotifyEvent);
begin
  FOnDblClick := Value;
  FOvcEdit.OnDblClick := Value;
end;

procedure TOvcBorderedEdit.SetOnDragDrop(Value : TDragDropEvent);
begin
  FOnDragDrop := Value;
  FOvcEdit.OnDragDrop := Value;
end;

procedure TOvcBorderedEdit.SetOnDragOver(Value : TDragOverEvent);
begin
  FOnDragOver := Value;
  FOvcEdit.OnDragOver := Value;
end;

procedure TOvcBorderedEdit.SetOnEndDrag(Value : TEndDragEvent);
begin
  FOnEndDrag := Value;
  FOvcEdit.OnEndDrag := Value;
end;

procedure TOvcBorderedEdit.SetOnKeyDown(Value : TKeyEvent);
begin
  FOnKeyDown := Value;
  FOvcEdit.OnKeyDown := Value;
end;

procedure TOvcBorderedEdit.SetOnKeyPress(Value : TKeyPressEvent);
begin
  FOnKeyPress := Value;
  FOvcEdit.OnKeyPress := Value;
end;

procedure TOvcBorderedEdit.SetOnKeyUp(Value : TKeyEvent);
begin
  FOnKeyUp := Value;
  FOvcEdit.OnKeyUp := Value;
end;

procedure TOvcBorderedEdit.SetOnMouseDown(Value : TMouseEvent);
begin
  FOnMouseDown := Value;
  FOvcEdit.OnMouseDown := Value;
end;

procedure TOvcBorderedEdit.SetOnMouseMove(Value : TMouseMoveEvent);
begin
  FOnMouseMove := Value;
  FOvcEdit.OnMouseMove := Value;
end;

procedure TOvcBorderedEdit.SetOnMouseUp(Value : TMouseEvent);
begin
  FOnMouseUp := Value;
  FOvcEdit.OnMouseUp := Value;
end;

procedure TOvcBorderedEdit.KeyPress(var Key : Char);
begin
  inherited KeyPress(Key);
end;

end.


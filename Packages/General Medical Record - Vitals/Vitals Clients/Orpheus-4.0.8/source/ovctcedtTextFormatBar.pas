{*********************************************************}
{*                  OVCTCEDT.PAS 4.08                    *}
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

unit ovctcedtTextFormatBar;

interface

{$IFDEF WIN32}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ovcbase, ovcspeed, ComCtrls, ExtCtrls,
  Buttons, AppEvnts;

type
  TSubClassMessageEvent = procedure(Msg: TMessage) of object;

  TFormSubClasser = class(TControl)
  private
    FForm: TCustomForm;
    FOnMessage: TSubClassMessageEvent;
    procedure RevertParentWindowProc;
    class function SubClassWindowProc(hWnd: HWND; uMsg: UINT; wParam: WPARAM;
      lParam: LPARAM; uIdSubclass: UINT_PTR; dwRefData: DWORD_PTR): LRESULT; stdcall; static;
    procedure SetOnMessage(const Value: TSubClassMessageEvent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoMessage(var Msg: TMessage);
  public
    destructor Destroy; override;
    procedure SetForm(AForm: TCustomForm);
    property OnMessage: TSubClassMessageEvent read FOnMessage write SetOnMessage;
  end;

type
  TOvcTextFormatBar = class(TForm)
    Timer1: TTimer;
    btnBold: TSpeedButton;
    btnItalic: TSpeedButton;
    btnUnderline: TSpeedButton;
    procedure Timer1Timer(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FAllowedFontStyles: TFontStyles;
    FFormSubClasser: TFormSubClasser;
    FAttachedControl: TWinControl;
    procedure SetAllowedFontStyles(const Value: TFontStyles);
    procedure SetPopupParent(const Value: TCustomForm);
    function GetPopupParent: TCustomForm;
    procedure FormMessage(Msg: TMessage);
    procedure SetAttachedControl(const Value: TWinControl);
  protected
    procedure WMMouseActivate(var Message: TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    destructor Destroy; override;
    property AllowedFontStyles: TFontStyles read FAllowedFontStyles write SetAllowedFontStyles default [fsBold, fsItalic, fsUnderline];
    procedure UpdatePosition;
    property PopupParent: TCustomForm read GetPopupParent write SetPopupParent;
    property AttachedControl: TWinControl read FAttachedControl write SetAttachedControl;
  end;

//var
//  ovcTextFormatBar: TOvcTextFormatBar;

{$ENDIF}

implementation

{$IFDEF WIN32}

{$R *.dfm}

{$I OVC.inc}

uses
  Types, CommCtrl, ovctcedtHTMLText, ovcRTF_IText, Generics.Collections, ovcTable;

function SetWindowSubclass(hWnd: HWND; pfnSubclass: SUBCLASSPROC;
  uIdSubclass: UINT_PTR; dwRefData: DWORD_PTR): BOOL; stdcall; external comctl32; // XP or newer; Winapi.CommCtrl.SetWindowSubClass is broken (InitComCtl not called)

function DefSubclassProc(hWnd: HWND; uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall; external comctl32; // XP or newer; Winapi.CommCtrl.SetWindowSubClass is broken (InitComCtl not called)

function RemoveWindowSubclass(hWnd: HWND; pfnSubclass: SUBCLASSPROC;
  uIdSubclass: UINT_PTR): BOOL; stdcall; external comctl32;

{ TOvcTextFormatBar }

procedure TOvcTextFormatBar.btnBoldClick(Sender: TObject);
var
  RE: TOvcCustomHtmlTextEditBase;
begin
  if FAttachedControl is TOvcCustomHtmlTextEditBase then
    RE := TOvcCustomHtmlTextEditBase(FAttachedControl)
  else
    RE := nil;
//  if Screen.ActiveControl is TOvcCustomHtmlTextEditBase then
//    RE := TOvcCustomHtmlTextEditBase(Screen.ActiveControl)
//  else
//    RE := nil;

  if Assigned(RE) then
    RE.GetIDoc.Selection.Font.Bold := Integer(tomToggle);
end;

procedure TOvcTextFormatBar.btnItalicClick(Sender: TObject);
var
  RE: TOvcCustomHtmlTextEditBase;
begin
  if FAttachedControl is TOvcCustomHtmlTextEditBase then
    RE := TOvcCustomHtmlTextEditBase(FAttachedControl)
  else
    RE := nil;
//  if Screen.ActiveControl is TOvcCustomHtmlTextEditBase then
//    RE := TOvcCustomHtmlTextEditBase(Screen.ActiveControl)
//  else
//    RE := nil;

  if Assigned(RE) then
    RE.GetIDoc.Selection.Font.Italic := Integer(tomToggle);
end;

procedure TOvcTextFormatBar.btnUnderlineClick(Sender: TObject);
var
  RE: TOvcCustomHtmlTextEditBase;
  Doc: ITextDocument;
begin
  if FAttachedControl is TOvcCustomHtmlTextEditBase then
    RE := TOvcCustomHtmlTextEditBase(FAttachedControl)
  else
    RE := nil;
//  if Screen.ActiveControl is TOvcCustomHtmlTextEditBase then
//    RE := TOvcCustomHtmlTextEditBase(Screen.ActiveControl)
//  else
//    RE := nil;

  if Assigned(RE) then
  begin
    Doc := RE.GetIDoc;
    if Doc.Selection.Font.Underline <> tomNone then
      Doc.Selection.Font.Underline := tomNone
    else
      Doc.Selection.Font.Underline := tomSingle;
  end;
end;

procedure TOvcTextFormatBar.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params Do
  begin
    if CheckWin32Version(5, 1) then
      WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;
  end;
end;

destructor TOvcTextFormatBar.Destroy;
begin
  FreeAndNil(FFormSubClasser);
  inherited;
end;

procedure TOvcTextFormatBar.FormCreate(Sender: TObject);
begin
  FAllowedFontStyles := [fsBold, fsItalic, fsUnderline];
end;

procedure TOvcTextFormatBar.FormMessage(Msg: TMessage);
begin
  if Msg.Msg = WM_MOVE then
    UpdatePosition;
end;

procedure TOvcTextFormatBar.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color := $A7ABB0;
  Canvas.Brush.Style := bsSolid;
  Canvas.FrameRect(ClientRect);
end;

function TOvcTextFormatBar.GetPopupParent: TCustomForm;
begin
  Result := inherited PopupParent;
end;

procedure TOvcTextFormatBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FAttachedControl) then
  begin
    FAttachedControl := nil;
  end;
end;

procedure TOvcTextFormatBar.SetAllowedFontStyles(const Value: TFontStyles);
var
  Buttons: TObjectList<TSpeedButton>;
  I: Integer;
begin
  FAllowedFontStyles := Value;
  btnBold.Visible := fsBold in FAllowedFontStyles;
  btnItalic.Visible := fsItalic in FAllowedFontStyles;
  btnUnderline.Visible := fsUnderline in FAllowedFontStyles;
  Buttons := TObjectList<TSpeedButton>.Create(False);
  try
    if btnBold.Visible then
      Buttons.Add(btnBold);
    if btnItalic.Visible then
      Buttons.Add(btnItalic);
    if btnUnderline.Visible then
      Buttons.Add(btnUnderline);

    for I := 0 to Buttons.Count - 1 do
      Buttons[I].Left := 4 + (24 * I);
    Width := 4 + (24 * Buttons.Count) + 4;
  finally
    Buttons.Free;
  end;
end;

procedure TOvcTextFormatBar.SetAttachedControl(const Value: TWinControl);
begin
  if (Value <> FAttachedControl) and (Value <> Self) then
  begin
    if FAttachedControl <> nil then
      RemoveFreeNotification(FAttachedControl);
    FAttachedControl := Value;

    if FAttachedControl <> nil then
      FAttachedControl.FreeNotification(Value);
  end;
end;

procedure TOvcTextFormatBar.SetPopupParent(const Value: TCustomForm);
begin
  FreeAndNil(FFormSubClasser);
  inherited PopupParent := Value;
  FFormSubClasser := TFormSubClasser.Create(Self);
  FFormSubClasser.OnMessage := FormMessage;
  FFormSubClasser.SetForm(Value);
end;

procedure TOvcTextFormatBar.Timer1Timer(Sender: TObject);
var
  RE: TOvcCustomHtmlTextEditBase;
begin
  if FAttachedControl is TOvcCustomHtmlTextEditBase then
    RE := TOvcCustomHtmlTextEditBase(FAttachedControl)
  else
    RE := nil;

//  if Screen.ActiveControl is TOvcCustomHtmlTextEditBase then
//    RE := TOvcCustomHtmlTextEditBase(Screen.ActiveControl)
//  else
//    RE := nil;

  Visible := Assigned(RE) and (RE = Screen.ActiveControl);

  btnBold.Enabled := Assigned(RE);
  btnItalic.Enabled := Assigned(RE);
  btnUnderline.Enabled := Assigned(RE);
  if Assigned(RE) then
  begin
    btnBold.Down := fsBold in TOvcCustomHtmlTextEditBase(RE).SelAttributes.Style;
    btnItalic.Down := fsItalic in TOvcCustomHtmlTextEditBase(RE).SelAttributes.Style;
    btnUnderline.Down := fsUnderline in TOvcCustomHtmlTextEditBase(RE).SelAttributes.Style;
  end;
//  UpdatePosition;
end;

procedure TOvcTextFormatBar.UpdatePosition;
var
  RE: TOvcCustomHtmlTextEditBase;
  Form: TCustomForm;
  P, P2: TPoint;
  R: TRect;
  Table: TOvcTable;
begin
  if FAttachedControl is TOvcCustomHtmlTextEditBase then
    RE := TOvcCustomHtmlTextEditBase(FAttachedControl)
  else
    Exit;

  if Screen.ActiveControl <> FAttachedControl then
    Exit;

//  if Screen.ActiveControl is TOvcCustomHtmlTextEditBase then
//    RE := TOvcCustomHtmlTextEditBase(Screen.ActiveControl)
//  else
//    Exit;

  Form := GetParentForm(RE);
  if Form = nil then
    Exit;

  P := RE.ClientToScreen(Point(1, RE.Height - 2));

  // keep popup within table
  if RE.Parent is TOvcTable then
  begin
    Table := TOvcTable(RE.Parent);
    P2 := Table.ScreenToClient(Point(P.X, P.Y + Height));
    if not PtInRect(Table.ClientRect, P2) then
    begin
      P2 := Table.ScreenToClient(RE.ClientToScreen(Point(1, -Height - 2)));
      if PtInRect(Table.ClientRect, P2) then
        P := RE.ClientToScreen(Point(1, -Height - 2));
    end;
  end;

  // Popup above Memo if it would not fit on the screen
  R := Form.Monitor.WorkareaRect;
  if P.Y + Height > R.Bottom then
    P := RE.ClientToScreen(Point(1, -Height - 2));

  if (AllowedFontStyles <> []) then
    SetWindowPos(Handle, HWND_TOP, P.X, P.Y, 0, 0, SWP_SHOWWINDOW or SWP_NOSIZE or SWP_NOZORDER or SWP_NOACTIVATE);
end;

procedure TOvcTextFormatBar.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

{ TFormSubClasser }

destructor TFormSubClasser.Destroy;
begin
  RevertParentWindowProc;
  inherited;
end;

procedure TFormSubClasser.DoMessage(var Msg: TMessage);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Msg);
end;

procedure TFormSubClasser.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FForm) then
  begin
    RevertParentWindowProc;
  end;
end;

procedure TFormSubClasser.RevertParentWindowProc;
begin
  if FForm <> nil then
  begin
    if not RemoveWindowSubclass(FForm.Handle, SubClassWindowProc, NativeUInt(Self)) then
      RaiseLastOSError;
    FForm := nil;
  end;
end;

procedure TFormSubClasser.SetForm(AForm: TCustomForm);
begin
  RevertParentWindowProc;
  if Assigned(FForm) then
    FForm.RemoveFreeNotification(Self);

  FForm := AForm;

  if Assigned(FForm) then
  begin
    SetWindowSubClass(FForm.Handle, TFormSubClasser.SubClassWindowProc, NativeUInt(Self), NativeUInt(Self));
    FForm.FreeNotification(Self);
  end;
//  else
//    RevertParentWindowProc;
end;

procedure TFormSubClasser.SetOnMessage(const Value: TSubClassMessageEvent);
begin
  FOnMessage := Value;
end;

class function TFormSubClasser.SubClassWindowProc(hWnd: HWND; uMsg: UINT;
  wParam: WPARAM; lParam: LPARAM; uIdSubclass: UINT_PTR;
  dwRefData: DWORD_PTR): LRESULT;
var
  Msg: TMessage;
begin
  if uMsg = WM_NCDESTROY then
    TFormSubClasser(dwRefData).RevertParentWindowProc;

  msg.Msg := uMsg;
  msg.WParam := wParam;
  msg.LParam := lParam;
  msg.Result := 0;
  TFormSubClasser(dwRefData).DoMessage(msg);

  Result := DefSubclassProc(hWnd, uMsg, wParam, lParam);
end;

{$ENDIF}

end.

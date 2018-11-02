{*********************************************************}
{*                  O32IMGFM.PAS 4.06                    *}
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

unit o32imgfm;
  {ImageForm component}

interface

uses
  Classes, Forms, Controls, Windows, Messages, ExtCtrls, Graphics, SysUtils;

type
  TProtectedForm = class(TForm);

  TO32CustomImageForm = class(TGraphicControl)
  protected{private}
    FAutoSize           : Boolean;
    FOpaqueRgn          : Hrgn;
    FPicture            : TBitmap;
    FStretch            : Boolean;
    FTransparentColor   : TColor;
    FDragControl        : TComponent;
    FDrawing            : Boolean;
    ifPictureChanged    : Boolean;

    {WndProc pointers}
    NewWndProc          : Pointer;
    PrevWndProc         : Pointer;

    function  GetAbout: string;
    procedure SetAbout(const Value : string);
    function  GetCanvas: TCanvas;
    procedure SetAutoSize(Value: Boolean); override;
    procedure SetDragControl(Control: TComponent);
    procedure SetPicture(Value: TBitmap);
    procedure AdjustFormSize;
    procedure SetTransparentColor(Value: TColor);
    procedure SetParent(Value: TWinControl); override;
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
  protected
    function  DestRect: TRect;
    function  DoPaletteChange: Boolean;
    function  GetPalette: HPALETTE; override;
    procedure Paint; override;
    procedure DestroyWindow;
    procedure ifWndProc(var Message: TMessage);
    procedure HookForm;
    property  AutoSize: Boolean read FAutoSize write SetAutoSize;
    property  Picture: TBitmap read FPicture write SetPicture;
    property  DragControl: TComponent
              read FDragControl write SetDragControl;
    property  TransparentColor: TColor
              read FTransparentColor write SetTransparentColor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property  Canvas: TCanvas read GetCanvas;

    procedure RenderForm;
  published
    property  About: string
              read GetAbout write SetAbout stored False;
  end;

  TO32ImageForm = class(To32CustomImageForm)
  published
    property Align;
    property AutoSize default True;
    property DragControl;
    property Picture;
    property PopupMenu;
    property ShowHint;
    property TransparentColor default clBlack;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
  end;

implementation

uses
  OvcVer, Types;

{===== TO32CustomImageForm ===========================================}

constructor TO32CustomImageForm.Create(AOwner: TComponent);
  begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FPicture := TBitmap.Create;

  { Create a callable window proc pointer which will be used to replace the }
  { parent forms default WndProc with our NewWndProc }
    NewWndProc := Classes.MakeObjectInstance(ifWndProc);

  FOpaqueRgn := 0;
  FAutoSize := true;
  Height := 105;
  Width := 105;
  ifPictureChanged := true;
  { Do baby fish "dry" their beds at night? }
end;
{=====}

destructor TO32CustomImageForm.Destroy;
begin
  if FOpaqueRgn <> 0 then
    DeleteObject(FOpaqueRgn);
  FPicture.Free;
  inherited Destroy;
end;
{=====}

procedure TO32CustomImageForm.Notification(AComponent: TComponent;
                                           Operation: TOperation);
begin
  inherited;
  if (AComponent = FDragControl) and (Operation = opRemove) then
    FDragControl := nil;
end;
{=====}

function TO32CustomImageForm.GetAbout : string;
begin
  Result := OrVersionStr;
end;
{=====}

procedure TO32CustomImageForm.SetAbout(const Value : string);
begin
  {Leave Empty}
end;
{=====}

function TO32CustomImageForm.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if FPicture = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      FPicture := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  Result := FPicture.Canvas
end;
{=====}

procedure TO32CustomImageForm.SetAutoSize(Value: Boolean);
begin
  FAutoSize := Value;
  if FAutoSize then
    AdjustFormSize;
end;
{=====}

procedure TO32CustomImageForm.AdjustFormSize;
begin
  if (FPicture <> nil) and (FPicture.Width > 0) and (FPicture.height > 0)
  then begin
    TForm(Parent).ClientWidth := FPicture.Width;
    TForm(Parent).ClientHeight := FPicture.Height;
  end;
  Invalidate;
end;
{=====}

procedure TO32CustomImageForm.SetDragControl(Control: TComponent);
begin
  { prevent the drag control property from being set to self.  }
  { this causes the control to handle certain evnts improperly }
  if Control = self then
    Exit;

  FDragControl := Control;
end;
{=====}

procedure TO32CustomImageForm.SetPicture(Value: TBitmap);
begin
  FPicture.Assign(Value);
  if FAutoSize then
    AdjustFormSize;
  ifPictureChanged := true;
end;
{=====}

procedure TO32CustomImageForm.SetTransparentColor(Value: TColor);
begin
  if FTransparentColor <> Value then begin
    FTransparentColor := Value;
    ifPictureChanged := true;
  end;
end;
{=====}

function TO32CustomImageForm.DestRect: TRect;
begin
  Result := Rect(0, 0, Picture.Width, Picture.Height);
end;
{=====}

function TO32CustomImageForm.DoPaletteChange: Boolean;
var
  ParentForm: TCustomForm;
  Tmp: TBitmap;
begin
  Result := False;
  Tmp := Picture;
  if Visible and (not (csLoading in ComponentState)) and (Tmp <> nil) and
    (Tmp.PaletteModified) then
  begin
    if (Tmp.Palette = 0) then
      Tmp.PaletteModified := False
    else
    begin
      ParentForm := GetParentForm(Self);
      if Assigned(ParentForm) and ParentForm.Active and Parentform.HandleAllocated then
      begin
        if FDrawing then
          ParentForm.Perform(wm_QueryNewPalette, 0, 0)
        else
          PostMessage(ParentForm.Handle, wm_QueryNewPalette, 0, 0);
        Result := True;
        Tmp.PaletteModified := False;
      end;
    end;
  end;
end;
{=====}

function TO32CustomImageForm.GetPalette: HPALETTE;
begin
  Result := 0;
  if FPicture <> nil then
    Result := FPicture.Palette;
end;
{=====}

procedure TO32CustomImageForm.Paint;
var
  Save: Boolean;
begin
  { Designtime specific painting }
  if csDesigning in ComponentState then begin
    { Regular form with an image on it at designtime }
    with inherited Canvas do begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
  end
  { Runtime specific painting }
  else if ifPictureChanged then begin
  { render the form according to the image... }
    RenderForm;
    ifPictureChanged := false;
  end;

  {Normal painting}
  Save := FDrawing;
  FDrawing := True;
  try
    with inherited Canvas do
      StretchDraw(DestRect, FPicture);
  finally
    FDrawing := Save;
  end;
end;
{=====}

procedure TO32CustomImageForm.DestroyWindow;
begin
  if FOpaqueRgn <> 0 then
  begin
    DeleteObject(FOpaqueRgn);
    FOpaqueRgn := 0;
    SetWindowRgn(GetParentForm(self).Handle, FOpaqueRgn, False);
  end;
end;
{=====}

procedure TO32CustomImageForm.ifWndProc(var Message: TMessage);
var
  Ctrl: TControl;
begin
  if not (csDesigning in componentstate) then
  with Message do begin

    case Msg of

      WM_SHOWWINDOW: begin
        { Create the properly shaped region before the form shows itself the }
        { first time. }
        if FOpaqueRgn = 0 then begin
          RenderForm;
          ifPictureChanged := false;
        end;
      end;

      WM_NCHITTEST: begin
        { Trick windows to think our DragControl is the form's caption bar }
        with TWMNCHitTest(Message) do begin
          Ctrl := Parent.ControlAtPos(ScreenToClient(Point(XPos, YPos)), True);
          { If the mouse is over the DragControl then fool Windows into }
          { thinking the DragControl is the caption area }
          if (ctrl = FDragControl) then begin
            Result := htCaption;
            { exit to prevent the default message handler from ruining }
            { everything.  That dang ol' default message handler ruins }
            { everything! }
            exit;
          end;
        end;
      end;
    end; {case}

    { Pass the message on... }
    if PrevWndProc <> nil then
      Result := CallWindowProc(PrevWndProc, TForm(Parent).Handle, Msg,
        WParam, LParam)
    else
      Result := CallWindowProc(TProtectedForm(Parent).DefWndProc,
        TForm(Parent).Handle, Msg, wParam, lParam);
  end;
end;
{=====}

procedure TO32CustomImageForm.SetParent(Value: TWinControl);
begin
  inherited SetParent(Value);

  if (Value is TForm) then begin
    { Remove the form's borders and border icons }
    TForm(Value).BorderStyle := bsNone;
    TForm(Parent).BorderIcons := [];
    Align := alClient;

    {At designtime we allow the form to handle its own messages.  At runtime,  }
    { we replace the form's WndProc with our own so we can intercept its mouse }
    {clicks, and such }
    if not (csDesigning in ComponentState) then HookForm;
  end;
end;
{=====}

procedure TO32CustomImageForm.HookForm;
var
  P : Pointer;
  ParentForm: TForm;
begin
  { Allows us to intercept the parent form's messages }
  ParentForm := TForm(GetParentForm(self));
  {hook into form's window procedure}
  if (ParentForm <> nil) then begin
    if not ParentForm.HandleAllocated then ParentForm.HandleNeeded;
    {save original window procedure if not already saved}
    P := Pointer(GetWindowLong(ParentForm.Handle, GWL_WNDPROC));
    if (P <> NewWndProc) then begin
      PrevWndProc := P;
      {redirect message handling to our NewWndProc}
      SetWindowLong(ParentForm.Handle, GWL_WNDPROC, NativeInt(NewWndProc));
    end;
  end;
end;
{=====}

procedure TO32CustomImageForm.RenderForm;
var
  TransparentRgn: HRgn;
  X, Y, XTransparent: Integer;
  Success: Boolean;
begin
  { assume a good outcome }
  Success := true;

  { Loop through each scan line and each pixel, looking for pixels that are the}
  { same color as the transparent color }

  FOpaqueRgn := CreateRectRgn(0, 0, FPicture.Width, FPicture.Height);
  for Y := 0 to FPicture.Height - 1 do begin
    X := 0;

    { Loop through the pixels in this row... }
    while (X < FPicture.Width) do begin

      {Process non-transparent pixels...}
      while (X < FPicture.Width)
      and (FPicture.Canvas.Pixels[X, Y] <> FTransparentColor) do Inc(X);

      {Process transparent pixels...}
      XTransparent := X;
      while (X < FPicture.Width)
      and (FPicture.Canvas.Pixels[X, Y] = FTransparentColor) do Inc(X);

      {If there was a region of transparent pixels in this line then process it }
      if (XTransparent < X) then begin
        TransparentRgn := CreateRectRgn(XTransparent, Y, X, Y + 1);
        if CombineRgn(FOpaqueRgn, FOPaqueRgn, TransparentRgn, RGN_XOR) = NULLREGION
        then Success := false;
        DeleteObject(TransparentRgn);
      end;
    end;
  end;

  { Apply the newly shaped region to the form }
  if Success then
    SetWindowRgn(TForm(Parent).Handle, FOpaqueRgn, true);
end;

end.

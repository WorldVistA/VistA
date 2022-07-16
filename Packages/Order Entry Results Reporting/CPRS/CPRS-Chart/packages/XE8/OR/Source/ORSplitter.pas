unit ORSplitter;

interface

uses Controls, Graphics, ExtCtrls, Classes, Types, Windows;

type
  TSplitOrientation = (soHorizontal, soVertical);
  TORSplitter = class(TGraphicControl)
  private
    FActiveControl: TWinControl;
    FAutoSnap: Boolean;
    FBeveled: Boolean;
    FBrush: TBrush;
    FDownPos: TPoint;
    FLineDC: HDC;
    FLineVisible: Boolean;
    FMinSize: NaturalNumber;
    FMaxSize: Integer;
    FNewSize: Integer;
    FOldKeyDown: TKeyEvent;
    FOldSize: Integer;
    FPrevBrush: HBrush;
    FResizeStyle: TResizeStyle;
    FSplit: Integer;
    FOnCanResize: TCanResizeEvent;
    FOnMoved: TNotifyEvent;
    FOnPaint: TNotifyEvent;
    fSplitOrientation: TSplitOrientation;
    procedure AllocateLineDC;
    procedure CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
    procedure DrawLine;
    procedure FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ReleaseLineDC;
    procedure SetBeveled(Value: Boolean);
    procedure UpdateSize(X, Y: Integer);
    procedure SetSplitOrientation(const Value: TSplitOrientation);
    function GetSplitOrientation: TSplitOrientation;
  protected
    function CanResize(var NewSize: Integer): Boolean; reintroduce; virtual;
    function DoCanResize(var NewSize: Integer): Boolean; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure RequestAlign; override;
    procedure StopSizing; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas;
  published
    property Align default alNone;
    property AutoSnap: Boolean read FAutoSnap write FAutoSnap default True;
    property Beveled: Boolean read FBeveled write SetBeveled default False;
    property Color;
    property Cursor;
    property Constraints;
    property MinSize: NaturalNumber read FMinSize write FMinSize;
    property ParentColor;
    property ResizeStyle: TResizeStyle read FResizeStyle write FResizeStyle;
    property Visible;
    property Width;
    property Height;
    property OnCanResize: TCanResizeEvent read FOnCanResize write FOnCanResize;
    property OnMoved: TNotifyEvent read FOnMoved write FOnMoved;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property SplitOrientation: TSplitOrientation read GetSplitOrientation write SetSplitOrientation;
  end;


implementation

uses Themes, Forms;

{ TORSplitter }

type
  TWinControlAccess = class(TWinControl);

constructor TORSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csGestures];
  FOldSize := -1;
end;

destructor TORSplitter.Destroy;
begin
  FBrush.Free;
  inherited Destroy;
end;

procedure TORSplitter.AllocateLineDC;
begin
  FLineDC := GetDCEx(Parent.Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS or DCX_LOCKWINDOWUPDATE);
  if ResizeStyle = rsPattern then begin
    if FBrush = nil then begin
      FBrush := TBrush.Create;
      if TStyleManager.IsCustomStyleActive then
        with StyleServices do
          FBrush.Bitmap := AllocPatternBitmap(clBlack, GetStyleColor(scSplitter))
      else
        FBrush.Bitmap := AllocPatternBitmap(clBlack, clWhite);
    end;
    FPrevBrush := SelectObject(FLineDC, FBrush.Handle);
  end;
end;

procedure TORSplitter.DrawLine;
var
  P: TPoint;
begin
  FLineVisible := not FLineVisible;
  P := Point(Left, Top);
  if (SplitOrientation = soVertical) then
    P.X := Left + FSplit
  else
    P.Y := Top + FSplit;
  PatBlt(FLineDC, p.X, p.Y, Width, Height, PATINVERT);
end;

procedure TORSplitter.ReleaseLineDC;
begin
  if FPrevBrush <> 0 then
    SelectObject(FLineDC, FPrevBrush);
  ReleaseDC(Parent.Handle, FLineDC);
  if FBrush <> nil then begin
    FBrush.Free;
    FBrush := nil;
  end;
end;

procedure TORSplitter.RequestAlign;
begin
  inherited RequestAlign;
  if (Cursor <> crVSplit) and (Cursor <> crHSplit) then Exit;
  if SplitOrientation = soVertical then
    Cursor := crHSplit
  else
    Cursor := crVSplit;
end;

procedure TORSplitter.Paint;
const
  XorColor = $00FFD8CE;
var
  FrameBrush: HBRUSH;
  R: TRect;
begin
  R := ClientRect;
  if TStyleManager.IsCustomStyleActive then
    Canvas.Brush.Color := StyleServices.GetSystemColor(clBtnFace)
  else
    Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  if Beveled then begin
    if (SplitOrientation = soVertical) then
      InflateRect(R, -1, 2)
    else
      InflateRect(R, 2, -1);
    OffsetRect(R, 1, 1);
    FrameBrush := CreateSolidBrush(ColorToRGB(StyleServices.GetSystemColor(clBtnHighlight)));
    FrameRect(Canvas.Handle, R, FrameBrush);
    DeleteObject(FrameBrush);
    OffsetRect(R, -2, -2);
    FrameBrush := CreateSolidBrush(ColorToRGB(StyleServices.GetSystemColor(clBtnShadow)));
    FrameRect(Canvas.Handle, R, FrameBrush);
    DeleteObject(FrameBrush);
  end;
  if csDesigning in ComponentState then
    { Draw outline }
    with Canvas do begin
      Pen.Style := psDot;
      Pen.Mode := pmXor;
      Pen.Color := XorColor;
      Brush.Style := bsClear;
      Rectangle(0, 0, ClientWidth, ClientHeight);
    end;
  if Assigned(FOnPaint) then FOnPaint(Self);
end;

function TORSplitter.DoCanResize(var NewSize: Integer): Boolean;
begin
  Result := CanResize(NewSize);
  if Result and (NewSize <= MinSize) and FAutoSnap then
    NewSize := 0;
end;

function TORSplitter.CanResize(var NewSize: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnCanResize) then FOnCanResize(Self, NewSize, Result);
end;

procedure TORSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then begin
    FDownPos := Point(X, Y);
    UpdateSize(X, Y);
    AllocateLineDC;
    with ValidParentForm(Self) do
      if ActiveControl <> nil then begin
        FActiveControl := ActiveControl;
        FOldKeyDown := TWinControlAccess(FActiveControl).OnKeyDown;
        TWinControlAccess(FActiveControl).OnKeyDown := FocusKeyDown;
      end;
    if ResizeStyle in [rsLine, rsPattern] then DrawLine;
  end;
end;

procedure TORSplitter.CalcSplitSize(X, Y: Integer; var NewSize, Split: Integer);
var
  S: Integer;
begin
  if (SplitOrientation = soVertical) then
    Split := X - FDownPos.X
  else
    Split := Y - FDownPos.Y;
  S := 0;
  NewSize := S;
  if S < FMinSize then
    NewSize := FMinSize
  else if S > FMaxSize then
    NewSize := FMaxSize;
  if S <> NewSize then begin
    if Align in [alRight, alBottom] then
      S := S - NewSize
    else
      S := NewSize - S;
    Inc(Split, S);
  end;
end;

procedure TORSplitter.UpdateSize(X, Y: Integer);
begin
  CalcSplitSize(X, Y, FNewSize, FSplit);
end;

procedure TORSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewSize, Split: Integer;
begin
  inherited;
  if (ssLeft in Shift) and (Align = alNone) then begin
    CalcSplitSize(X, Y, NewSize, Split);
    if DoCanResize(NewSize) then begin
      if ResizeStyle in [rsLine, rsPattern] then DrawLine;
      FNewSize := NewSize;
      FSplit := Split;
      if ResizeStyle in [rsLine, rsPattern] then DrawLine;
    end;
  end;
end;

procedure TORSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ResizeStyle in [rsLine, rsPattern] then DrawLine;
  StopSizing;
end;

procedure TORSplitter.FocusKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    StopSizing
  else if Assigned(FOldKeyDown) then
    FOldKeyDown(Sender, Key, Shift);
end;

function TORSplitter.GetSplitOrientation: TSplitOrientation;
begin
  case Align of
    alLeft, alRight: Result := soVertical;
    alTop, alBottom: Result := soHorizontal;
  else
    Result := fSplitOrientation;
  end;
end;

procedure TORSplitter.SetBeveled(Value: Boolean);
begin
  FBeveled := Value;
  Repaint;
end;

procedure TORSplitter.SetSplitOrientation(const Value: TSplitOrientation);
begin
  fSplitOrientation := Value;
  RequestAlign;
end;

procedure TORSplitter.StopSizing;
begin
  if FLineVisible then DrawLine;
  ReleaseLineDC;
  if Assigned(FActiveControl) then begin
    TWinControlAccess(FActiveControl).OnKeyDown := FOldKeyDown;
    FActiveControl := nil;
  end;
  if SplitOrientation = soVertical then
    Left := Left + FSplit
  else
    Top := Top + FSplit;

  if Assigned(FOnMoved) then
    FOnMoved(Self);
end;


end.

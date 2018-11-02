{*********************************************************}
{*                  OVCSPLIT.PAS 4.06                    *}
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

unit ovcsplit;
  {-Splitter component}

interface

uses
  Types, Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, OvcBase, OvcData;

type
  TSplitterOrientation = (soVertical, soHorizontal);

type
  {section to act as parent for components}
  TOvcSection = class(TOvcCollectibleControl)

  protected {private}
    {windows message response methods}
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;
  protected
  public
    constructor Create(AOwner : TComponent);
      override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;

  published
    property Color default clBtnFace;
    property Height stored False;
    property Left stored False;
    property Top stored False;
    property Width stored False;
  end;

  TOvcSplitter = class(TOvcCustomControlEx)

  protected {private}
    {property variables}
    FAllowResize      : Boolean;
    FAutoScale        : Boolean;
    FAutoUpdate       : Boolean;
    FBorderStyle      : TBorderStyle;
    FOrientation      : TSplitterOrientation;
    FPosition         : Integer;
    FRelativePosition : Double;
    FColorLeft        : TColor;
    FColorRight       : TColor;
    FShowHandle       : Boolean;
    FSplitterColor    : TColor;
    FSplitterSize     : Integer;

    {event variables}
    FOnOwnerDraw   : TNotifyEvent;
    FOnResize      : TNotifyEvent;

    {internal variables}
    {CanAlign       : Boolean;}
    FirstTime      : Boolean;
    FPaneColl      : TOvcCollection;
    sCanResize     : Boolean;
    sPos           : TPoint;

    {property methods}
    function GetSection(Index : Integer) : TOvcSection;
    procedure SetAutoUpdate(Value : Boolean);
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure SetColorLeft(Value : TColor);
    procedure SetColorRight(Value : TColor);
    procedure SetOrientation(Value : TSplitterOrientation);
    procedure SetPosition(Value : Integer);
    procedure SetShowHandle(const Value : Boolean);
    procedure SetSplitterColor(Value : TColor);
    procedure SetSplitterSize(Value : Integer);

    {internal methods}
    procedure sDrawSplitter(X, Y : Integer);
    procedure sInvalidateSplitter;
    procedure sSetPositionPrim(Value : Integer);
    procedure sSetSectionInfo;

    {VCL control methods}
    procedure CMCtl3DChanged(var Msg : TMessage);
      message CM_CTL3DCHANGED;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;

    {windows message response methods}
    procedure WMEraseBkGnd(var Msg : TWMEraseBkGnd);
      message WM_ERASEBKGND;
    procedure WMSetCursor(var Msg : TWMSetCursor);
      message WM_SETCURSOR;

  protected
    procedure AncestorNotFound(Reader: TReader; const ComponentName: string;
      ComponentClass: TPersistentClass; var Component: TComponent);
    procedure Resize;
      override;
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;
    procedure DoOnResize;
      dynamic;
    procedure DoOnOwnerDraw;
      virtual;
    {procedure Loaded; override;}
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Paint;
      override;
    procedure ReadState(Reader : TReader);
      override;
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;


    {public methods}
    procedure Center;
      {-position the splitter bar in the middle of the region}

    {public properties}
    property Section[Index : Integer] : TOvcSection
      read GetSection;

  published
    {properties}
    property AllowResize : Boolean
      read FAllowResize write FAllowResize
      default True;
    property AutoScale : Boolean
      read FAutoScale write FAutoScale
      default True;
    property AutoUpdate : Boolean
      read FAutoUpdate write SetAutoUpdate
      default False;

    property BorderStyle : TBorderStyle
      read FBorderStyle write SetBorderStyle
      default bsNone;

    property ColorLeft : TColor
      read FColorLeft write SetColorLeft
      default clBlack;
    property ColorRight : TColor
      read FColorRight write SetColorRight
      default clBlack;
    property Orientation : TSplitterOrientation
      read FOrientation write SetOrientation
      default soVertical;
    property Position : Integer
      read FPosition write SetPosition;
    property ShowHandle : Boolean
      read FShowHandle write SetShowHandle
      default False;
    property SplitterColor : TColor
      read FSplitterColor write SetSplitterColor
      default clWindowText;
    property SplitterSize : Integer
      read FSplitterSize write SetSplitterSize
      default 3;

    {events}
    property OnOwnerDraw : TNotifyEvent
      read FOnOwnerDraw write FOnOwnerDraw;
    property OnResize : TNotifyEvent
      read FOnResize write FOnResize;

    {inherited properties}
    property Anchors;
    property Constraints;
    property Align;
    property Color;
    property Ctl3D default True;
    property Enabled;
    property ParentCtl3D default False;
    property ParentShowHint;
    property ShowHint;
    property Visible;
  end;


implementation


{*** TOvcSection ***}

constructor TOvcSection.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  ParentCtl3D := True;
  Color := clBtnFace;
  Parent := TWinControl(AOwner);
end;

procedure TOvcSection.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (ALeft = Left) and (ATop = Top) and (AWidth = Width) and (AHeight = Height) then exit;
  DisableAlign;
  try
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  finally
    EnableAlign;
  end;
end;

procedure TOvcSection.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  if not (csDesigning in ComponentState) then
    Msg.Result := HTTRANSPARENT
  else
    inherited;
end;


{*** TOvcSplitter ***}

procedure TOvcSplitter.Center;
begin
  case Orientation of
    soHorizontal : Position := (ClientHeight - FSplitterSize) div 2;
    soVertical   : Position := (ClientWidth - FSplitterSize) div 2;
  end;
end;

procedure TOvcSplitter.CMCtl3DChanged(var Msg : TMessage);
begin
  inherited;

  if (csLoading in ComponentState) then
    Exit;

  {update section size and position}
  sSetSectionInfo;

  Refresh;
end;

procedure TOvcSplitter.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  if sCanResize then
    Msg.Result := 1
  else
    inherited;
end;

constructor TOvcSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FirstTime := True;

  FPaneColl := TOvcCollection.Create(Self, TOvcSection);

  Ctl3D  := True;
  Height := 100;
  Width  := 200;

  if Classes.GetClass(TOvcSection.ClassName) = nil then
    Classes.RegisterClass(TOvcSection);

  FPaneColl.Add.Name := 'SPL1';
  FPaneColl.Add.Name := 'SPL2';

  FAllowResize      := True;
  FAutoScale        := True;
  {FAutoUpdate       := False;} {redundant}
  FBorderStyle      := bsNone;
  FOrientation      := soVertical;
  FRelativePosition := 0.5;
  FPosition         := Width div 2;
  FSplitterColor    := clWindowText;
  FSplitterSize     := 3;

  sPos.X := -1;
  sPos.Y := -1;

  if Screen.Cursors[crVSplit] = 0 then
    Screen.Cursors[crVSplit] := LoadCursor(0, IDC_SIZENS);
  if Screen.Cursors[crHSplit] = 0 then
    Screen.Cursors[crHSplit] := LoadCursor(0, IDC_SIZEWE);

end;

procedure TOvcSplitter.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Integer(Params.Style) or BorderStyles[FBorderStyle];
end;

procedure TOvcSplitter.CreateWnd;
begin
  inherited CreateWnd;

  {update section size and position}
  sSetSectionInfo;
end;

procedure TOvcSplitter.ReSize;
begin
  inherited Resize;
  if FAutoScale and not (csLoading in ComponentState) then begin
    case Orientation of
      soHorizontal :
        if (Height <> 0) then
          Position := Round(Height * FRelativePosition);
      soVertical   :
        if (Width <> 0)  then
          Position := Round(Width * FRelativePosition);
    end;
  end;
  DoOnResize;
end;

destructor TOvcSplitter.Destroy;
begin
  Parent := nil;
  FPaneColl.Free;

  inherited Destroy;
end;

procedure TOvcSplitter.DoOnOwnerDraw;
begin
  if Assigned(FOnOwnerDraw) then
    FOnOwnerDraw(Self);
end;

procedure TOvcSplitter.DoOnResize;
begin
  if Assigned(FOnResize) then
    FOnResize(Self);
end;

function TOvcSplitter.GetSection(Index : Integer) : TOvcSection;
begin
  if (Index < 0) or (FPaneColl = nil) or (Index >= FPaneColl.Count) then
    Result := nil
  else
    Result := TOvcSection(FPaneColl.Item[Index]);
end;

{
procedure TOvcSplitter.Loaded;
begin
  inherited Loaded;
  CanAlign := True;
end;
}

procedure TOvcSplitter.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  Delta : Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);

  if sCanResize then begin
    if (Button = mbLeft) then begin
      case Orientation of
        soHorizontal : Delta := FPosition - Y;
        soVertical   : Delta := FPosition - X;
      else
        Delta := 0;
      end;
      if Abs(Delta) < FSplitterSize then begin
        SetCapture(Handle);
        sDrawSplitter(X, Y);
      end;
    end;
  end;
end;

procedure TOvcSplitter.MouseMove(Shift : TShiftState; X, Y : Integer);
begin
  inherited MouseMove(Shift, X, Y);

  case Orientation of
    soHorizontal :
      if (Y < 0) or (Y > ClientHeight) or (Y = FPosition) then
        Exit;
    soVertical   :
      if (X < 0) or (X > ClientWidth) or (X = FPosition) then
        Exit;
  end;

  if (GetCapture = Handle) and sCanResize then begin
    sDrawSplitter(X, Y);

    if AutoUpdate then
      {update section size and position}
      sSetSectionInfo;
  end;
end;

procedure TOvcSplitter.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if sCanResize then begin
    ReleaseCapture;
    sCanResize := False;
    sDrawSplitter(-1, -1); {erase}

    {update Section size and position}
    sSetSectionInfo;
    Refresh;

    DoOnResize;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TOvcSplitter.Paint;
var
  P, P1  : Integer;
  S, S1  : Integer;
  CW, CH : Integer;
  CW3, CH3, PS2 : Integer;
  Split0,
  Split1 : Boolean;
begin
  {update section size and position}
  sSetSectionInfo;

  if Assigned(FOnOwnerDraw) then begin
    DoOnOwnerDraw;
    Exit;
  end;

  P  := Position;
  P1 := Position-1;
  CW := ClientWidth;
  CH := ClientHeight;
  S  := FSplitterSize;
  S1 := FSplitterSize-1;

  if not Ctl3D then begin
    Canvas.Pen.Color := SplitterColor;
    Canvas.Brush.Color := SplitterColor;
    case Orientation of
      soHorizontal : Canvas.Rectangle(0, P, CW, P+S);
      soVertical   : Canvas.Rectangle(P, 0, P+S, CH);
    end;
    if ShowHandle then
      case Orientation of
        soHorizontal :
          begin
            Canvas.Pen.Color := clWhite;
            CW3 := CW div 3;
            PS2 := P + S div 2;
            Canvas.MoveTo(CW3, PS2 + 1);
            Canvas.LineTo(CW3, PS2 - 1);
            Canvas.LineTo(2 * CW3, PS2 - 1);
            Canvas.Pen.Color := clGray;
            Canvas.LineTo(2 * CW3, PS2 + 1);
            Canvas.LineTo(CW3, PS2 + 1);
          end;
        soVertical   :
          begin
            Canvas.Pen.Color := clWhite;
            CH3 := CH div 3;
            PS2 := P + S div 2;
            Canvas.MoveTo(PS2 + 1, CH3);
            Canvas.LineTo(PS2 - 1, CH3);
            Canvas.LineTo(PS2 - 1, 2 * CH3);
            Canvas.Pen.Color := clGray;
            Canvas.LineTo(PS2 + 1, 2 * CH3);
            Canvas.LineTo(PS2 + 1, CH3);
          end;
      end;
    Exit;
  end;

  Canvas.Brush.Color := Color;

  Split0 := (Section[0] <> nil) and (Section[0].ControlCount > 0) and
    (Section[0].Controls[0] is TOvcSplitter)
    and (Section[0].Controls[0].Align = alClient);
  Split1 := (Section[1] <> nil) and (Section[1].ControlCount > 0) and
    (Section[1].Controls[0] is TOvcSplitter)
    and (Section[1].Controls[0].Align = alClient);

  {draw highlight border (right and bottom of each section)}
  Canvas.Pen.Color := clBtnHighlight;
  case Orientation of
    soHorizontal :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(0, P1),
                         Point(CW-1, P1),
                        Point(CW-1, 0)]);
        if not Split1 then
          Canvas.PolyLine([Point(0, CH-1),
                         Point(CW-1, CH-1),
                         Point(CW-1, P+S1)]);
      end;
    soVertical   :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(0, CH-1),
                         Point(P1, CH-1),
                         Point(P1, 0)]);
        if not Split1 then
          Canvas.PolyLine([Point(P+S1, CH-1),
                         Point(CW-1, CH-1),
                         Point(CW-1, 0)]);
      end;
  end;

  {draw shadow border (left and top of each section)}
  Canvas.Pen.Color := clBtnShadow;
  case Orientation of
    soHorizontal :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(0, P1-1),
                         Point(0, 0),
                         Point(CW-1, 0)]);
        if not Split1 then
          Canvas.PolyLine([Point(0, CH-2),
                         Point(0, P+S),
                         Point(CW-1, P+S)]);
      end;
    soVertical   :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(0, CH-2),
                         Point(0, 0),
                         Point(P1 + 1, 0)]);
        if not Split1 then
          Canvas.PolyLine([Point(P+S, CH-2),
                         Point(P+S, 0),
                         Point(CW-1, 0)]);
      end;
  end;

  {draw border (left and top of each section)}
  Canvas.Pen.Color := clBlack;
  case Orientation of
    soHorizontal :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(1, P1-1),
                         Point(1, 1),
                         Point(CW-1, 1)]);
        if not Split1 then
          Canvas.PolyLine([Point(1, CH-2),
                         Point(1, P+S+1),
                         Point(CW-1, P+S+1)]);
      end;
    soVertical   :
      begin
        if not Split0 then
          Canvas.PolyLine([Point(1, CH-2),
                         Point(1, 1),
                         Point(P-1, 1)]);
        if not Split1 then
          Canvas.PolyLine([Point(P+S+1, CH-2),
                         Point(P+S+1, 1),
                         Point(CW-1, 1)]);
      end;
  end;

  {draw splitter bar}
  Canvas.Pen.Color := Color;
  Canvas.Brush.Color := Color;
  case Orientation of
    soHorizontal :
      Canvas.Rectangle(0, P, CW, P+S);
    soVertical   :
      Canvas.Rectangle(P, 0, P+S, CH);
  end;
  if ShowHandle then
    case Orientation of
      soHorizontal :
        begin
          Canvas.Pen.Color := clWhite;
          CW3 := CW div 3;
          PS2 := P + S div 2 + 1;
          Canvas.MoveTo(CW3, PS2 + 1);
          Canvas.LineTo(CW3, PS2 - 1);
          Canvas.LineTo(2 * CW3, PS2 - 1);
          Canvas.Pen.Color := clGray;
          Canvas.LineTo(2 * CW3, PS2 + 1);
          Canvas.LineTo(CW3, PS2 + 1);
        end;
      soVertical   :
        begin
          Canvas.Pen.Color := clWhite;
          CH3 := CH div 3;
          PS2 := P + S div 2 + 1;
          Canvas.MoveTo(PS2 + 1, CH3);
          Canvas.LineTo(PS2 - 1, CH3);
          Canvas.LineTo(PS2 - 1, 2 * CH3);
          Canvas.Pen.Color := clGray;
          Canvas.LineTo(PS2 + 1, 2 * CH3);
          Canvas.LineTo(PS2 + 1, CH3);
        end;
    end;
end;

procedure TOvcSplitter.AncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
  if copy(ComponentName,1,4) = 'SPL1' then
    Component := Section[0]
  else
  if copy(ComponentName,1,4) = 'SPL2' then
    Component := Section[1];
end;

procedure TOvcSplitter.ReadState(Reader : TReader);
var
  SaveAncestorNotFound : TAncestorNotFoundEvent;
begin
  if FirstTime then begin
    FPaneColl.Clear;
    FirstTime := False;
  end;
  SaveAncestorNotFound := Reader.OnAncestorNotFound;
  try
    Reader.OnAncestorNotFound := AncestorNotFound;
    inherited ReadState(Reader);
  finally
    Reader.OnAncestorNotFound := SaveAncestorNotFound;
  end;
end;

procedure TOvcSplitter.sDrawSplitter(X, Y : Integer);
begin
  if AutoUpdate and (X > -1) and (Y > -1) then begin
    sInvalidateSplitter;
    case Orientation of
      soHorizontal : sSetPositionPrim(Y);
      soVertical   : sSetPositionPrim(X);
    end;
    sInvalidateSplitter;
    Exit;
  end;


  {do we need to erase first?}
  if (sPos.X > -1) or (sPos.Y > -1) then begin
    case Orientation of
      soHorizontal :
        PatBlt(Canvas.Handle, 0, sPos.Y, ClientWidth, FSplitterSize - 1, DSTINVERT);
      soVertical   :
        PatBlt(Canvas.Handle, sPos.X, 0, FSplitterSize - 1, ClientHeight, DSTINVERT);
    end;
  end;

  {record new position}
  sPos.X := X;
  sPos.Y := Y;

  if not sCanResize then
    Exit;

  case Orientation of
    soHorizontal :
      begin
        sSetPositionPrim(sPos.Y);
        sPos.Y := Position;
        PatBlt(Canvas.Handle, 0, FPosition, ClientWidth, FSplitterSize - 1, DSTINVERT);
        if ClientHeight <> 0 then
          FRelativePosition := FPosition / ClientHeight;
      end;
    soVertical   :
      begin
        sSetPositionPrim(sPos.X);
        sPos.X := Position;
        PatBlt(Canvas.Handle, FPosition, 0, FSplitterSize - 1, ClientHeight, DSTINVERT);
        if ClientWidth <> 0 then
          FRelativePosition := FPosition / ClientWidth;
      end;
  end;
end;

procedure TOvcSplitter.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
(*
var
  P : Double;
*)
begin
  if (ALeft = Left) and (ATop = Top)
  and (AWidth = Width) and (AHeight = Height) then exit;

  (*
  case FOrientation of
    soHorizontal :
      if ALeft + ATop + AHeight = 0 then
        Exit;
    soVertical :
      if ALeft + ATop + AWidth = 0 then
        Exit;
  end;
  *)

  (*         - Moved this functionality to the Resize method
  if FAutoScale and not (csLoading in ComponentState) then begin
    P := Position;
    case Orientation of
      soHorizontal :
        if (Height <> 0) and (AHeight <> 0) then
          Position := Round(P / Height * AHeight);
      soVertical   :
        if (Width <> 0) and (AWidth <> 0) then
          Position := Round(P / Width * AWidth);
    end;
  end;
  *)

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TOvcSplitter.sInvalidateSplitter;
var
  R : TRect;
begin
  case Orientation of
    soHorizontal : R := Rect(0, Position-2, ClientWidth, Position+FSplitterSize+2);
    soVertical   : R := Rect(Position-2, 0, Position+FSplitterSize+2, ClientHeight);
  end;
  InvalidateRect(Handle, @R, True);
  if Handle <> 0 then {};
end;

procedure TOvcSplitter.SetAutoUpdate(Value : Boolean);
begin
  if (Value <> FAutoUpdate) then
    FAutoUpdate := Value;
end;

procedure TOvcSplitter.SetBorderStyle(Value : TBorderStyle);
begin
  if (Value <> FBorderStyle) then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcSplitter.SetOrientation(Value : TSplitterOrientation);
begin
  if (Value <> FOrientation) then begin
    FOrientation := Value;

    if (csLoading in ComponentState) then
      Exit;

    if not HandleAllocated then
      Exit;

    {force position to readjust}
    sSetPositionPrim(FPosition);

    {update Section size and position}
    sSetSectionInfo;
    Refresh;
  end;
end;

procedure TOvcSplitter.SetPosition(Value : Integer);
begin
  if Value < 0 then
    Value := 0;
  if (csLoading in ComponentState)
  or not HandleAllocated then begin
    FPosition := Value;
    case Orientation of
      soHorizontal :
        if ClientHeight <> 0 then
          FRelativePosition := FPosition / ClientHeight;
      soVertical   :
        if ClientWidth <> 0 then
          FRelativePosition := FPosition / ClientWidth;
    end;
    Exit;
  end;

  sSetPositionPrim(Value);
  Refresh;

  DoOnResize;
end;

procedure TOvcSplitter.SetShowHandle(const Value : Boolean);
begin
  if Value <> FShowHandle then begin
    FShowHandle := Value;
    Refresh;
  end;
end;

procedure TOvcSplitter.SetSplitterColor(Value : TColor);
begin
  {color to use if not Ctl3D}
  if (Value <> FSplitterColor) then begin
    FSplitterColor := Value;
    Refresh;
  end;
end;

procedure TOvcSplitter.SetSplitterSize(Value : Integer);
begin
  if (Value <> FSplitterSize) then begin
    FSplitterSize := Value;

    if (csLoading in ComponentState) then
      Exit;

    if not HandleAllocated then
      Exit;

    {update Section size and position}
    sSetSectionInfo;
    Refresh;
  end;
end;

procedure TOvcSplitter.sSetPositionPrim(Value : Integer);
var
  MinPos : Integer;
  MaxPos : Integer;
  PF     : TForm;
begin
  if (ClientHeight = 0) or (ClientWidth = 0) then
    exit;
  MinPos := 0;
  case Orientation of
    soHorizontal :
      begin
        MaxPos := ClientHeight - FSplitterSize - 2;
        if Value < MinPos then
          Value := MinPos;
        if Value > MaxPos then
          Value := MaxPos;
        FPosition := Value;
      end;
    soVertical :
      begin
        MaxPos := ClientWidth - FSplitterSize - 2;
        if Value < MinPos then
          Value := MinPos;
        if Value > MaxPos then
          Value := MaxPos;
        FPosition := Value;
      end;
  end;

  {notify the designer of the change}
  if not AutoScale and (csDesigning in ComponentState) then begin
    PF := TForm(GetParentForm(Self));
    if Assigned(PF) and (PF.Designer <> nil) then
      PF.Designer.Modified;
  end;
end;

procedure TOvcSplitter.sSetSectionInfo;
var
  P      : Integer;
  S      : Integer;
  CW, CH : Integer;
  Split0,
  Split1 : Boolean;
begin
  if (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated then
    Exit;

  if Section[0] = nil then exit;

  P  := Position;
  CW := ClientWidth;
  CH := ClientHeight;
  S  := FSplitterSize;

  Split0 := (Section[0] <> nil) and (Section[0].ControlCount > 0) and
    (Section[0].Controls[0] is TOvcSplitter)
    and (Section[0].Controls[0].Align = alClient);
  Split1 := (Section[1] <> nil) and (Section[1].ControlCount > 0) and
    (Section[1].Controls[0] is TOvcSplitter)
    and (Section[1].Controls[0].Align = alClient);

  if Ctl3D then begin
    case Orientation of
      soHorizontal :
        begin
          if Split0 then
            Section[0].SetBounds(0, 0, CW, P)
          else
            Section[0].SetBounds(2, 2, CW-3, P-3);
          if Split1 then
            Section[1].SetBounds(0, P+S, CW, CH-P-S)
          else
            Section[1].SetBounds(2, P+S+2, CW-3, CH-P-S-3);
        end;
      soVertical :
        begin
          if Split0 then
            Section[0].SetBounds(0, 0, P, CH)
          else
            Section[0].SetBounds(2, 2, P-3, CH-3);
          if Split1 then
            Section[1].SetBounds(P+S, 0, CW-P-S, CH)
          else
            Section[1].SetBounds(P+S+2, 2, CW-P-S-3, CH-3);
        end;
    end;
  end else begin
    case Orientation of
      soHorizontal :
        begin
          Section[0].SetBounds(0, 0, CW, P);
          Section[1].SetBounds(0, P+S, CW, CH-P-S);
        end;
      soVertical :
        begin
          Section[0].SetBounds(0, 0, P, CH);
          Section[1].SetBounds(P+S, 0, CW-P-S, CH);
        end;
    end;
  end;
end;

procedure TOvcSplitter.WMEraseBkGnd(var Msg : TWMEraseBkGnd);
begin
  Msg.Result := 1  {don't erase background}
end;

procedure TOvcSplitter.WMSetCursor(var Msg : TWMSetCursor);
var
  Cur : hCursor;
  P   : TPoint;
begin
  Cur := 0;

  if Msg.HitTest = HTCLIENT then begin
    GetCursorPos(P);
    P := ScreenToClient(P);
    {are we over the split region?}
    case Orientation of
      soHorizontal : if Abs(Position - P.Y) <= FSplitterSize then
        Cur := Screen.Cursors[crVSplit];
      soVertical   : if Abs(Position - P.X) <= FSplitterSize then
        Cur := Screen.Cursors[crHSplit];
    end;
  end;

  sCanResize := (FAllowResize or (csDesigning in ComponentState)) and (Cur <> 0);
  if sCanResize then
    SetCursor(Cur)
  else
    inherited;
end;

procedure TOvcSplitter.SetColorLeft(Value: TColor);
begin
  FColorLeft := Value;
  if Section[0] <> nil then
    Section[0].Color := Value;
end;

procedure TOvcSplitter.SetColorRight(Value: TColor);
begin
  FColorRight := Value;
  if Section[1] <> nil then
    Section[1].Color := Value;
end;

procedure TOvcSplitter.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  Section[0].Name := 'SPL1' + Value + Owner.Name;
  Section[1].Name := 'SPL2' + Value + Owner.Name;
end;

end.

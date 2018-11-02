{*********************************************************}
{*                    OVCBTNHD.PAS 4.08                  *}
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

unit ovcbtnhd;
  {-Button header component}

interface

uses
  Windows, Classes, Controls, ExtCtrls, Forms, Graphics,
  Types, Messages, SysUtils, OvcBase, OvcConst, OvcData, OvcMisc, OvcDrag;

type
  TOvcButtonHeaderStyle = (bhsNone, bhsRadio, bhsButton);
  TOvcBHDrawingStyle = (bhsDefault, bhsThin, bhsFlat, bhsEtched);
  TOvcButtonHeaderSection = class(TOvcCollectible)

  protected
    {property variables}
    FAlignment: TAlignment;
    FAllowResize: Boolean;
    FCaption: string;
    FImageIndex: Integer;
    FHint: string;
    FLeftImageindex: Integer;
    FPaintRect: TRect;
    FVisible: Boolean;
    FWidth: Integer;

  protected
    procedure Changed; override;
    {property methods}
    procedure SetAlignment(Value : TAlignment);
    procedure SetCaption(const Value : string);
    procedure SetImageIndex(Value : Integer);
    procedure SetLeftImageIndex(const Value: Integer);
    procedure SetWidth(Value : Integer);

    function GetBaseName : string;
      override;
    function GetDisplayText : string;
      override;
    function GetWidth: Integer;
    procedure SetVisible(const Value: Boolean);

  public
    constructor Create(AOwner : TComponent);
      override;
    property PaintRect : TRect
      read fPaintRect;

  published
    property Alignment : TAlignment
      read FAlignment write SetAlignment
      default taLeftJustify;
    property AllowResize : Boolean
      read FAllowResize write FAllowResize
      default True;
    property Caption : string
      read FCaption write SetCaption;
    property ImageIndex : Integer
      read FImageIndex write SetImageIndex
      default -1;
    property Hint: string
      read FHint write FHint;
    property LeftImageIndex: Integer
      read FLeftImageIndex write SetLeftImageIndex
      default -1;
    property Visible: Boolean
      read FVisible write SetVisible
      default True;
    property Width : Integer
      read GetWidth write SetWidth
      default 75;
  end;

  TOvcTextAttrEvent = procedure(Sender : TObject; Canvas : TCanvas; Index : Integer)
    of object;

  TOvcButtonHeaderRearrangingEvent = procedure(Sender: TObject;
    OldIndex, NewIndex: Integer; var Allow: Boolean) of object;
  TOvcButtonHeaderRearrangedEvent = procedure(Sender: TObject;
    OldIndex, NewIndex: Integer) of object;

  TOvcButtonHeader = class(TOvcCustomControl)

  protected
    {property variables}
    FAllowResize    : Boolean;
    FAllowDragRearrange: Boolean;
    FBorderStyle    : TBorderStyle;
    FDrawingStyle   : TOvcBHDrawingStyle;
    FLeftImages,
    FRightImages    : TImageList;
    FItemIndex      : Integer;
    FPushRect       : TRect;
    FSections       : TOvcCollection;
    FStyle          : TOvcButtonHeaderStyle;
    FTextMargin     : Integer;
    FWordWrap       : Boolean;

    {event variables}
    FOnChangeTextAttr : TOvcTextAttrEvent;
    FOnClick        : TNotifyEvent;
    FOnSized        : TSectionEvent;
    FOnSizing       : TSectionEvent;

    {internal variables}
    bhCanResize     : Boolean;
    bhMouseOffset   : Integer;
    bhResizeSection : Integer;
    bhSectionPressed: Integer;
    bhDraw          : TBitMap;

    bhHitTest : TPoint;

    DragShow : TOvcDragShow;
    FDragSection: TOvcButtonHeaderSection;

    FRearranged: TOvcButtonHeaderRearrangedEvent;
    FRearranging: TOvcButtonHeaderRearrangingEvent;

    DragStartX, DragStartY: Integer;
    Dragging: Boolean;
    CurrentItem: TOvcButtonHeaderSection;
    MoveFrom, MoveTo: Integer;

    SectionChanged  : Boolean;

    {property methods}
    function GetResizeSection: Integer;
    function GetSection(Index : Integer) : TOvcButtonHeaderSection;
    function GetSectionCount : Integer;
    procedure SetBorderStyle(Value : TBorderStyle);
    procedure AncestorNotFound(Reader: TReader;
      const ComponentName: string; ComponentClass: TPersistentClass;
      var Component: TComponent);
    procedure ReadState(Reader: TReader); override;
    procedure SetDrawingStyle(const Value: TOvcBHDrawingStyle);
    procedure SetLeftImages(Value : TImageList);
    procedure SetRightImages(Value : TImageList);
    procedure SetItemIndex(Value : Integer);
    procedure SetSection(Index : Integer; Value : TOvcButtonHeaderSection);
    procedure SetTextMargin(Value : Integer);
    procedure SetWordWrap(Value : Boolean);
    procedure SetStyle(Value : TOvcButtonHeaderStyle);

    {internal methods}
    procedure bhCollectionChanged(Sender : TObject);
    procedure bhGetEditorCaption(var Caption : string);

    {VCL control methods}
    procedure CMDialogChar(var Msg : TCMDialogChar);
      message CM_DIALOGCHAR;
    procedure CMDesignHitTest(var Msg : TCMDesignHitTest);
      message CM_DESIGNHITTEST;
    procedure CMHintShow(var Message: TMessage);
      message CM_HINTSHOW;

    {windows message response methods}
    procedure WMSetCursor(var Msg : TWMSetCursor);
      message WM_SETCURSOR;
    procedure WMNCHitTest(var Msg : TWMNCHitTest);
      message WM_NCHITTEST;

  protected
    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseMove(Shift : TShiftState; X, Y : Integer);
      override;
    procedure MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
      override;
    procedure Notification(AComponent : TComponent; Operation: TOperation);
      override;
    procedure Paint;
      override;

    procedure DoOnChangeTextAttr(Canvas : TCanvas;Index : Integer);
      dynamic;
    procedure DoOnClick;
      virtual;
    procedure DoOnSized(ASection, AWidth : Integer);
      dynamic;
    procedure DoOnSizing(ASection, AWidth : Integer);
      dynamic;
    function DoRearranging(OldIndex, NewIndex: Integer): Boolean;
      dynamic;
    procedure DoRearranged(OldIndex, NewIndex: Integer);
      dynamic;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    {public properties}

    property DragSection: TOvcButtonHeaderSection read FDragSection;
    property PushRect : TRect read fPushRect;
    property ResizeSection: Integer read GetResizeSection;
    property Section[Index : Integer] : TOvcButtonHeaderSection
      read GetSection write SetSection;
    property SectionCount : Integer
      read GetSectionCount;

  published
    {properties}
    property AllowDragRearrange: Boolean
                   read FAllowDragRearrange write FAllowDragRearrange
                   default False;
    property AllowResize : Boolean
                   read FAllowResize write FAllowResize
                   default True;
    property BorderStyle : TBorderStyle
                   read FBorderStyle write SetBorderStyle
                   default bsNone;
    property DrawingStyle : TOvcBHDrawingStyle
                   read FDrawingStyle write SetDrawingStyle
                   default bhsDefault;
    property Images : TImageList
                   read FRightImages write SetRightImages;
    property ItemIndex : Integer
                   read FItemIndex write SetItemIndex;
    property LabelInfo;
    property LeftImages: TImageList
                   read FLeftImages write SetLeftImages;
    property Sections : TOvcCollection
                   read FSections write FSections;
    property Style : TOvcButtonHeaderStyle
                   read FStyle write SetStyle
                   default bhsRadio;
    property TextMargin : Integer
                   read FTextMargin write SetTextMargin
                   default 0;
    property WordWrap : Boolean
                   read FWordWrap write SetWordWrap
                   default False;

    {events}
    property OnClick : TNotifyEvent
                   read FOnClick write FOnClick;
    property OnSizing : TSectionEvent
                   read FOnSizing write FOnSizing;
    property OnSized : TSectionEvent
                   read FOnSized write FOnSized;

    property OnRearranging: TOvcButtonHeaderRearrangingEvent
                   read FRearranging write FRearranging;
    property OnRearranged: TOvcButtonHeaderRearrangedEvent
                   read FRearranged write FRearranged;

    {inherited properties}
    property Anchors;
    property Constraints;
    property Align;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    {inherited events}
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


implementation


{*** TOvcButtonHeaderSection ***}

procedure TOvcButtonHeaderSection.Changed;
begin
  inherited Changed;
  if (Owner <> nil) and (Owner is TOvcButtonHeader) then
    TOvcButtonHeader(Owner).Invalidate;
end;

constructor TOvcButtonHeaderSection.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FAlignment := taLeftJustify;
  FImageIndex := -1;
  FLeftImageIndex := -1;
  FWidth := 75;
  FAllowResize := True;
  FVisible := True;
end;

function TOvcButtonHeaderSection.GetBaseName : string;
begin
  Result := GetOrphStr(SCSectionBaseName);
end;

function TOvcButtonHeaderSection.GetDisplayText : string;

  function TrimAmpersand(const S : string) : string;
  var
    p : Integer;
  begin
    Result := S;
    p := Pos('&', Result);
    while p <> 0 do begin
      Delete(Result,p,1);
      p := Pos('&',Result);
    end;
  end;

begin
  if Caption > '' then
    Result := TrimAmpersand(Caption) + ': ' + ClassName
  else
    Result := Name + ': ' + ClassName;
end;

function TOvcButtonHeaderSection.GetWidth: Integer;
begin
  if Visible then
    Result := FWidth
  else
    Result := 0;
end;

procedure TOvcButtonHeaderSection.SetAlignment(Value : TAlignment);
begin
  if (Value <> FAlignment) then begin
    FAlignment := Value;
    Changed;
  end;
end;

procedure TOvcButtonHeaderSection.SetCaption(const Value : string);
begin
  if Value <> Caption then begin
    FCaption := Value;
    Changed;
  end;
end;

procedure TOvcButtonHeaderSection.SetImageIndex(Value : Integer);
begin
  if Value <> ImageIndex then begin
    FImageIndex := Value;
    Changed;
  end;
end;

procedure TOvcButtonHeaderSection.SetLeftImageIndex(const Value: Integer);
begin
  if Value <> LeftImageIndex then begin
    FLeftImageIndex := Value;
    Changed;
  end;
end;

procedure TOvcButtonHeaderSection.SetVisible(const Value: Boolean);
begin
  if Value <> FVisible then begin
    FVisible := Value;
    Changed;
  end;
end;

procedure TOvcButtonHeaderSection.SetWidth(Value : Integer);
begin
  if Value <> FWidth then begin
    FWidth := Value;
    Changed;
  end;
end;

{*** TOvcButtonHeader ***}

procedure TOvcButtonHeader.bhCollectionChanged;
begin
  Invalidate;
end;

procedure TOvcButtonHeader.bhGetEditorCaption(var Caption : string);
begin
  Caption := GetOrphStr(SCEditingSections);
end;

procedure TOvcButtonHeader.CMDialogChar(var Msg : TCMDialogChar);
var
  I : Integer;
begin
  if Enabled then with Msg do begin
    for I := 0 to Pred(FSections.Count) do
    if IsAccel(CharCode, Section[I].Caption) then begin
      ItemIndex := I;
      Result := 1;
      Exit;
    end;
  end;

  inherited;
end;

procedure TOvcButtonHeader.CMDesignHitTest(var Msg : TCMDesignHitTest);
begin
  if bhCanResize then
    Msg.Result := 1
  else
    inherited;
end;

constructor TOvcButtonHeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if Classes.GetClass(TOvcButtonHeaderSection.ClassName) = nil then
    Classes.RegisterClass(TOvcButtonHeaderSection);

  ControlStyle := ControlStyle + [csOpaque];

  Width := 250;
  Height := 20;

  FSections := TOvcCollection.Create(Self, TOvcButtonHeaderSection);
  FSections.OnChanged := bhCollectionChanged;
  FSections.OnGetEditorCaption := bhGetEditorCaption;

  FAllowResize := True;
  FBorderStyle := bsNone;
  FStyle       := bhsRadio;
  FTextMargin  := 0;
  FWordWrap    := False;

  bhSectionPressed := -1;

end;

procedure TOvcButtonHeader.CreateParams(var Params : TCreateParams);
const
  BorderStyles: array[TBorderStyle] of Integer = (0, WS_BORDER);
begin
  inherited CreateParams(Params);

  Params.Style := Integer(Params.Style) or BorderStyles[FBorderStyle];
  if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
    Params.Style := Params.Style and not WS_BORDER;
    Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
  end;
end;

destructor TOvcButtonHeader.Destroy;
begin
  if FLeftImages <> nil then
    FLeftImages.OnChange := nil;
  if FRightImages <> nil then
    FRightImages.OnChange := nil;
  FSections.Free;
  FSections := nil;

  bhDraw.Free;
  bhDraw := nil;
  inherited Destroy;
end;

procedure TOvcButtonHeader.DoOnChangeTextAttr(Canvas : TCanvas; Index : Integer);
begin
  if Assigned(FOnChangeTextAttr) then
    FOnChangeTextAttr(Self, Canvas, Index);
end;

procedure TOvcButtonHeader.DoOnClick;
begin
  Invalidate;
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TOvcButtonHeader.DoOnSizing(ASection, AWidth : Integer);
begin
  if Assigned(FOnSizing) then
    FOnSizing(Self, ASection, AWidth);
end;

procedure TOvcButtonHeader.DoOnSized(ASection, AWidth : Integer);
begin
  if Assigned(FOnSized) then
    FOnSized(Self, ASection, AWidth);
end;

function TOvcButtonHeader.DoRearranging(OldIndex, NewIndex: Integer): Boolean;
begin
  Result := True;
  if Assigned(FReArranging) then
    FReArranging(Self, OldIndex, NewIndex, Result);
end;

procedure TOvcButtonHeader.DoRearranged(OldIndex, NewIndex: Integer);
begin
  if Assigned(FRearranged) then
    FRearranged(Self, OldIndex, NewIndex);
end;

function TOvcButtonHeader.GetResizeSection: Integer;
begin
  if not bhCanResize then
    Result := -1
  else
    Result := bhResizeSection;
end;

function TOvcButtonHeader.GetSection(Index : Integer) : TOvcButtonHeaderSection;
begin
  Result := TOvcButtonHeaderSection(FSections[Index]);
end;

function TOvcButtonHeader.GetSectionCount : Integer;
begin
  Result := FSections.Count;
end;

{ several changes}
procedure TOvcButtonHeader.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
var
  I, J, Z, Y2: Integer;
  P: TPoint;
  R: TRect;
begin
  if bhCanResize then begin
    inherited MouseDown(Button, Shift, X, Y);
    if (Button = mbLeft) then
      SetCapture(Handle);
  end else begin
    if not (csDesigning in ComponentState) and (Button = mbLeft) then begin
      Y2 := 2;
      J := -1;
      for I := 0 to FSections.Count - 1 do begin
        Inc(Y2, Section[I].Width);
        if Y2 > X then begin
          J := I;
          Break;
        end;
      end;
      if (J <> -1) and (J < FSections.Count) then begin
        inherited MouseDown(Button, Shift, X, Y);
        case Style of
        bhsRadio :
          begin
            ItemIndex := J;
            Invalidate;
          end;
        bhsButton :
          begin
            bhSectionPressed := J;
            FItemIndex := J;
            Refresh;
          end;
        bhsNone :
          FItemIndex := J;
        end;
        SectionChanged := True;
      end;
    end;
    if AllowDragRearrange then begin
      Z := 2;
      J := -1;
      for I := 0 to FSections.Count - 1 do begin
        Inc(Z, Section[I].Width);
        if Z > X then begin
          J := I;
          Break;
        end;
      end;
      if (J <> -1) and (J < FSections.Count) then begin
        P := ClientToScreen(Point(X, Y));
        R := Section[J].PaintRect;
        R.TopLeft := ClientToScreen(R.TopLeft);
        R.BottomRight := ClientToScreen(R.BottomRight);
        DragShow := TOvcDragShow.Create(P.x, P.y, R, clBtnFace);
        FDragSection := Section[J];
        DragStartX := X;
        DragStartY := Y;
        DragShow.HideDragImage;
        Dragging := False;
      end;
    end;
  end;
end;

procedure TOvcButtonHeader.MouseMove(Shift : TShiftState; X, Y : Integer);
var
  I, J, Z      : Integer;
  AbsPos : Integer;
  MinPos : Integer;
  MaxPos : Integer;
  P: TPoint;
begin
  inherited MouseMove(Shift, X, Y);
  if DragShow <> nil then begin
    if Dragging then begin
      P := ClientToScreen(Point(X, Y));
      DragShow.DragMove(P.x, P.y);
      if X < 0 then
        Z := 0
      else
        if X > Section[FSections.Count -1].PaintRect.Right then
          Z := FSections.Count -1
        else begin
          Z := -1;
          J := 2;
          for I := 0 to FSections.Count - 1 do begin
            if X < J then
              break;
            Inc(J, Section[I].Width);
            Z := I;
            if J > X then
              Break;
          end;
        end;
      if (Z <> -1) and (DragSection.Index <> Z) then begin
        if DoRearranging(DragSection.Index, Z) then begin
          if MoveFrom = -1 then
            MoveFrom := DragSection.Index;
          MoveTo := Z;
          DragSection.Index := Z;
        end else
          MoveTo := -1;
      end;
    end else begin
      if (abs(X - DragStartX) > 4)
      or (abs(Y - DragStartY) > 4) then begin
        DragShow.ShowDragImage;
        Dragging := True;
        MoveFrom := -1;
        MoveTo := -1;
        if ItemIndex <> -1 then
          CurrentItem := Section[ItemIndex]
        else
          CurrentItem := nil;
        P := ClientToScreen(Point(X, Y));
        DragShow.DragMove(P.x, P.y);
        Invalidate;
      end;
    end;
  end else if (GetCapture = Handle) then
    if bhCanResize then begin
      {absolute position of this item}
      AbsPos := 2;
      for I := 0 to bhResizeSection do
        Inc(AbsPos, Section[I].Width);
      if bhResizeSection > 0 then MinPos := AbsPos -
        Section[bhResizeSection].Width + 2
      else
        MinPos := 2;

      MaxPos := ClientWidth - 2;
      if X < MinPos then
        X := MinPos;
      if X > MaxPos then
        X := MaxPos;

      Section[bhResizeSection].Width := Section[bhResizeSection].Width -
        (AbsPos - X - 2) - bhMouseOffset;
      DoOnSizing(bhResizeSection, Section[bhResizeSection].Width);

      Refresh;
    end;
end;

{ several changes}
procedure TOvcButtonHeader.MouseUp(Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
{var}
  {I, J, Z : Integer;}
  {SectionChanged  : Boolean;}
begin
  if DragShow <> nil then begin
    DragShow.Free;
    DragShow := nil;
    if Dragging then begin
      inherited MouseUp(Button, Shift, X, Y);
      if CurrentItem <> nil then
        ItemIndex := CurrentItem.Index;
      Dragging := False;
      FDragSection := nil;
      Invalidate;
      if (MoveFrom <> -1) and (MoveTo <> -1) then
        DoRearranged(MoveFrom, MoveTo);
      {exit;}
    end;
  end;

  if bhCanResize then begin
    ReleaseCapture;
    DoOnSized(bhResizeSection,
      Section[bhResizeSection].Width);
    bhCanResize := False;
  end else begin
    (* !!.02
    SectionChanged := False;
    if (Y >= 0) and (Y <= Height) and (X >= 0) and (X <= Width) then
      if not (csDesigning in ComponentState) and (Button = mbLeft) then begin
        Z := 2;
        J := -1;
        for I := 0 to FSections.Count - 1 do begin
          Inc(Z, Section[I].Width);
          if Z > X then begin
            J := I;
            Break;
          end;
        end;
        if (J <> -1) and (J < FSections.Count) then begin
          inherited MouseDown(Button, Shift, X, Y);
          case Style of
          bhsRadio :
            begin
              ItemIndex := J;
              Invalidate;
            end;
          bhsButton :
            begin
              bhSectionPressed := J;
              FItemIndex := J;
              Refresh;
            end;
          bhsNone :
            FItemIndex := J;
          end;
          SectionChanged := True;
        end;
      end;
    *)
    case Style of
    bhsButton :
      begin
        bhSectionPressed := -1;
        if SectionChanged then begin
          if PtInRect(ClientRect, Point(X,Y)) then
            DoOnClick;
          Refresh;
        end;
      end;
    bhsNone :
      if SectionChanged then
        if PtInRect(ClientRect, Point(X,Y)) then
          DoOnClick;
    end;
  end;

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TOvcButtonHeader.Notification(AComponent : TComponent; Operation : TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
    if AComponent = FLeftImages then
      FLeftImages := nil
    else
    if AComponent = FRightImages then
      FRightImages := nil;
end;

procedure TOvcButtonHeader.Paint;
var
  I, W    : Integer;
  S       : string;
  R, R2   : TRect;
  WM, AL  : Word;
  Img, Img2,
  H,T : Integer;
  BDim    : TPoint;
  DraggedSection: Boolean;
begin
  if DragShow <> nil then
    DragShow.HideDragImage;
  if (bhDraw <> nil) and ((bhDraw.Width <> Width) or (bhDraw.Height <> Height)) then begin
    bhDraw.Free;
    bhDraw := nil;
  end;
  if bhDraw = nil then begin
    bhDraw            := TBitMap.Create;
    bhDraw.Width      := Width;
    bhDraw.Height     := Height;
  end;

  with bhDraw.Canvas do begin
    Font := Self.Font;
    Brush.Color := clBtnFace;
    I := 0;
    R := Rect(0, 0, 0, ClientHeight);
    if (BorderStyle <> bsNone) and (DrawingStyle <> bhsDefault) then
      InflateRect(R,0,1);
    W := 0;
    repeat
      AL := 0;
      DraggedSection := False;
      if I < FSections.Count then begin
        with Section[I] do begin
          W := Width;
          case Alignment of
            taLeftJustify  : AL := DT_LEFT;
            taRightJustify : AL := DT_RIGHT;
            taCenter       : AL := DT_CENTER;
          end;
          S := Caption;
          Img := ImageIndex;
          if (Images = nil) or (Img >= Images.Count) then
            Img := -1;
          Img2 := LeftImageIndex;
          if (LeftImages = nil) or (Img2 >= LeftImages.Count) then
            Img2 := -1;
          DraggedSection := Dragging and (Section[I] = FDragSection);
        end;
      end else begin
        S := '';
        Img := -1;
        Img2 := -1;
      end;
      Inc(I);
      R.Left := R.Right;
      Inc(R.Right, W);
      if (ClientWidth - R.Right < 2) or (I > FSections.Count) then
        R.Right := ClientWidth;
      if I <= SectionCount then
        Section[I-1].fPaintRect := R;

      if ((Style = bhsRadio) and (FItemIndex = I-1))
      or ((Style = bhsButton) and (bhSectionPressed = I-1)) then begin
        fPushRect := R;
        case DrawingStyle of
        bhsDefault :
          DrawFrameControl(Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED);
        bhsThin :
          DrawEdge(bhDraw.Canvas.Handle, R, EDGE_SUNKEN, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
        bhsFlat :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_SUNKEN, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
            dec(R.Right, 2);
          end;
        bhsEtched :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_SUNKEN, BF_LEFT or BF_RIGHT or BF_BOTTOM or BF_TOP or BF_MIDDLE);
            dec(R.Right, 2);
          end;
        end;
      end else
      if Style <> bhsNone then begin
        case DrawingStyle of
        bhsDefault :
          DrawFrameControl(bhDraw.Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH);
        bhsThin :
          DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
        bhsFlat :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
            dec(R.Right, 2);
          end;
        bhsEtched :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_MIDDLE);
            dec(R.Right, 2);
            if (I <= FSections.Count) and ((FItemIndex <> I) or (Style <> bhsRadio)) then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Right - 2, R.Top + 3);
              LineTo(R.Right - 2, R.Bottom - 3);
              Pen.Color := clBtnHighlight;
              MoveTo(R.Right - 1, R.Top + 3);
              LineTo(R.Right - 1, R.Bottom - 3);
            end;
            if I = 1 then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Left, R.Top + 1);
              LineTo(R.Left, R.Bottom - 1);
              Pen.Color := clBtnHighlight;
              MoveTo(R.Left + 1, R.Top + 1);
              LineTo(R.Left + 1, R.Bottom - 2);
            end;
            if I > FSections.Count then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Right - 1, R.Top + 1);
              LineTo(R.Right - 1, R.Bottom - 1);
            end;
          end;
        end;
      end else begin
        case DrawingStyle of
        bhsDefault :
          DrawFrameControl(Handle, R, DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED);
        bhsThin :
          DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
        bhsFlat :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_LEFT or BF_RIGHT or BF_MIDDLE);
            dec(R.Right, 2);
          end;
        bhsEtched :
          begin
            inc(R.Right, 2);
            DrawEdge(bhDraw.Canvas.Handle, R, EDGE_ETCHED, BF_BOTTOM or BF_TOP or BF_MIDDLE);
            dec(R.Right, 2);
            if I <= FSections.Count then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Right - 2, R.Top + 3);
              LineTo(R.RIght - 2, R.Bottom - 3);
              Pen.Color := clBtnHighlight;
              MoveTo(R.Right - 1, R.Top + 3);
              LineTo(R.RIght - 1, R.Bottom - 3);
            end;
            if I = 1 then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Left, R.Top + 1);
              LineTo(R.Left, R.Bottom - 1);
              Pen.Color := clBtnHighlight;
              MoveTo(R.Left + 1, R.Top + 1);
              LineTo(R.Left + 1, R.Bottom - 2);
            end;
            if I > FSections.Count then begin
              Pen.Color := clBtnShadow;
              MoveTo(R.Right - 1, R.Top + 1);
              LineTo(R.Right - 1, R.Bottom - 1);
            end;
          end;
        end;
      end;

      if FWordWrap then
        WM := DT_WORDBREAK
      else
        WM := DT_VCENTER or DT_SINGLELINE;

      R2 := Rect(R.Left+2, R.Top+2, R.Right-4, R.Bottom-1);

      if (Images <> nil) and (Img <> -1) then begin
        BDim.x := Images.Width;
        BDim.y := Images.Height;
        if (BDim.x <> 0) and (BDim.y <> 0) then begin
          dec(R2.Right,BDim.X + 2);
          H := R2.Bottom-R2.Top;
          if H <= BDim.y then
            T := R2.Top
          else
            T := R2.Top + (H - BDim.y) shr 1;
          Images.Draw(bhDraw.Canvas,R2.Right + 2,T,Img);
        end;
      end;

      if (LeftImages <> nil) and (Img2 <> -1) then begin
        BDim.x := LeftImages.Width;
        BDim.y := LeftImages.Height;
        if (BDim.x <> 0) and (BDim.y <> 0) then begin
          H := R2.Bottom-R2.Top;
          if H <= BDim.y then
            T := R2.Top
          else
            T := R2.Top + (H - BDim.y) shr 1;
          LeftImages.Draw(bhDraw.Canvas,R2.Left ,T,Img2);
          inc(R2.Left,BDim.X + 2);
        end;
      end;

      if TextMargin < (R2.Right-R2.Left) div 2 then
        InflateRect(R2, -TextMargin, 0);

      if S <> '' then begin
        if not WordWrap then
          S := GetDisplayString(bhDraw.Canvas,S,1,R2.Right-R2.Left);
        DoOnChangeTextAttr(bhDraw.Canvas,I-1);
      end;
      DrawText(Handle, PChar(S), length(S), R2, AL or WM);
      if DraggedSection then
        PatBlt(Handle, R2.Left, R2.Top, R2.Right - R2.Left, R2.Bottom - R2.Top, DSTINVERT);

    until R.Right = ClientWidth;
  end;
  Canvas.CopyMode := cmSrcCopy;
  Canvas.CopyRect(ClientRect, bhDraw.Canvas, ClientRect);
  if DragShow <> nil then
    DragShow.ShowDragImage;
end;

procedure TOvcButtonHeader.AncestorNotFound(Reader: TReader; const ComponentName: string;
    ComponentClass: TPersistentClass; var Component: TComponent);
begin
  Component := FSections.ItemByName(ComponentName);
end;

procedure TOvcButtonHeader.ReadState(Reader : TReader);
var
  SaveAncestorNotFound : TAncestorNotFoundEvent;
begin
  SaveAncestorNotFound := Reader.OnAncestorNotFound;
  try
    Reader.OnAncestorNotFound := AncestorNotFound;
    inherited ReadState(Reader);
  finally
    Reader.OnAncestorNotFound := SaveAncestorNotFound;
  end;
end;

procedure TOvcButtonHeader.SetBorderStyle(Value : TBorderStyle);
begin
  if (Value <> FBorderStyle) then begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TOvcButtonHeader.SetDrawingStyle(
  const Value: TOvcBHDrawingStyle);
begin
  FDrawingStyle := Value;
  Refresh;
end;

procedure TOvcButtonHeader.SetLeftImages(Value : TImageList);
begin
  if Value <> FLeftImages then begin
    if FLeftImages <> nil then
      FLeftImages.OnChange := nil;
    FLeftImages := Value;
    if FLeftImages <> nil then
      FLeftImages.OnChange := bhCollectionChanged;
    Refresh;
  end;
end;

procedure TOvcButtonHeader.SetRightImages(Value : TImageList);
begin
  if Value <> FRightImages then begin
    if FRightImages <> nil then
      FRightImages.OnChange := nil;
    FRightImages := Value;
    if FRightImages <> nil then
      FRightImages.OnChange := bhCollectionChanged;
    Refresh;
  end;
end;

procedure TOvcButtonHeader.SetItemIndex(Value : Integer);
begin
  if (Value <> FItemIndex) and (Value < FSections.Count) then begin
    FItemIndex := Value;
    DoOnClick;
  end;
end;

procedure TOvcButtonHeader.SetSection(Index: Integer; Value: TOvcButtonHeaderSection);
begin
  FSections[Index] := Value;
end;

procedure TOvcButtonHeader.SetStyle(Value : TOvcButtonHeaderStyle);
begin
  if (Value <> FStyle) then begin
    FStyle := Value;
    Refresh;
  end;
end;

procedure TOvcButtonHeader.SetTextMargin(Value : Integer);
begin
  if (Value <> FTextMargin) and (Value >= 0) then begin
    FTextMargin := Value;
    Refresh;
  end;
end;

procedure TOvcButtonHeader.SetWordWrap(Value : Boolean);
begin
  if (Value <> FWordWrap) then begin
    FWordWrap := Value;
    Refresh;
  end;
end;

procedure TOvcButtonHeader.WMNCHitTest(var Msg : TWMNCHitTest);
begin
  inherited;

  bhHitTest := SmallPointToPoint(Msg.Pos);
end;

procedure TOvcButtonHeader.WMSetCursor(var Msg : TWMSetCursor);
var
  Cur : hCursor;
  I   : Integer;
  X   : Integer;
  AllowRes : Boolean;
begin
  Cur := 0;
  bhResizeSection := 0;
  bhHitTest := ScreenToClient(bhHitTest);
  X := 2;
  AllowRes := True;
  if Msg.HitTest = HTCLIENT then
    for I := 0 to FSections.Count - 1 do begin
      Inc(X, Section[I].Width);
      bhMouseOffset := X - (bhHitTest.X + 2);
      if Abs(bhMouseOffset) < 4 then begin
        Cur := LoadCursor(0, IDC_SIZEWE);
        bhResizeSection := I;
        AllowRes := Section[I].AllowResize;
        Break;
      end;
    end;

  AllowRes := FAllowResize and AllowRes;
  bhCanResize := (AllowRes or (csDesigning in ComponentState))
    and (Cur <> 0);
  if bhCanResize then begin
    SetCursor(Cur);
    Msg.Result := 1;
  end else
    inherited;
end;

procedure TOvcButtonHeader.CMHintShow(var Message: TMessage);
var
  i: Integer;
begin
  for i := 0 to Sections.Count - 1 do
    if PtInRect(Section[i].PaintRect, TCMHintShow(Message).HintInfo.CursorPos) then begin
      if Section[i].Hint <> '' then
        TCMHintShow(Message).HintInfo.HintStr := Section[i].Hint;
      break;
    end;
  inherited;
end;

end.

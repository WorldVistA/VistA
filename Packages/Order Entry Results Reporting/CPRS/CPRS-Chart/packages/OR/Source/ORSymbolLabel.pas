unit ORSymbolLabel;

interface

{$MINENUMSIZE 2}
{$M+}

uses
  System.Classes,
  System.SysUtils,
  System.Types,
  System.TypInfo,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Winapi.Windows;

type
  TORSymbolLabel = class;

  TORSymbol = class(TPersistent)
  private const
    DefaultColor = clWindowText;
    DefaultValue = 32;
  private
    FBackgroundColor: TColor;
    FBackgroundValue: Word;
    FForegroundColor: TColor;
    FForegroundValue: Word;
    FOwner: TORSymbolLabel;
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetBackgroundValue(const Value: Word);
    procedure SetForegroundColor(const Value: TColor);
    procedure SetForegroundValue(const Value: Word);
  public
    constructor Create(AOwner: TORSymbolLabel);
    procedure FromString(Value: string);
    function ToString: string; override;
  published
    property BackgroundColor: TColor read FBackgroundColor
      write SetBackgroundColor default DefaultColor;
    property BackgroundValue: Word read FBackgroundValue
      write SetBackgroundValue default DefaultValue;
    property ForegroundColor: TColor read FForegroundColor
      write SetForegroundColor default DefaultColor;
    property ForegroundValue: Word read FForegroundValue
      write SetForegroundValue default DefaultValue;
  end;

  TORSymbolLabel = class(TCustomLabel)
  private const
    SymbolFontName = 'Segoe MDL2 Assets';
  private
    FSymbol: TORSymbol;
    function GetSymbolSize: Integer;
    procedure SetSymbol(const Value: TORSymbol);
  protected
    procedure DoDrawText(var Rect: TRect; Flags: Longint); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SymbolSize: Integer read GetSymbolSize;
  published
    property Symbol: TORSymbol read FSymbol write SetSymbol;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property Color nodefault;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FocusControl;
    property Font;
    property GlowSize; // Windows Vista only
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Touch;
    property Layout;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  ORFn;

{ TORSymbol }

constructor TORSymbol.Create(AOwner: TORSymbolLabel);
begin
  FOwner := AOwner;
  inherited Create;
  FBackgroundColor := DefaultColor;
  FBackgroundValue := DefaultValue;
  FForegroundColor := DefaultColor;
  FForegroundValue := DefaultValue;
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

procedure TORSymbol.FromString(Value: string);

  function ConvertColor(S: string): TColor;
  var
    LColor: Integer;
  begin
    if not IdentToColor(S, LColor) then
      Result := TColor(StrToIntDef(S, DefaultColor))
    else
      Result := TColor(LColor);
  end;

begin
  ForegroundValue := StrToIntDef(Piece(Value, ';', 1), DefaultValue);
  ForegroundColor := ConvertColor(Piece(Value, ';', 2));
  BackgroundValue := StrToIntDef(Piece(Value, ';', 3), DefaultValue);
  BackgroundColor := ConvertColor(Piece(Value, ';', 4));
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

procedure TORSymbol.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

procedure TORSymbol.SetBackgroundValue(const Value: Word);
begin
  if Value = 0 then
    FBackgroundValue := DefaultValue
  else
    FBackgroundValue := Value;
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

procedure TORSymbol.SetForegroundColor(const Value: TColor);
begin
  FForegroundColor := Value;
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

procedure TORSymbol.SetForegroundValue(const Value: Word);
begin
  if Value = 0 then
    FForegroundValue := DefaultValue
  else
    FForegroundValue := Value;
  FOwner.AdjustBounds;
  FOwner.Invalidate;
end;

function TORSymbol.ToString: string;
begin
  Result := IntToStr(FForegroundValue) + ';' + ColorToString(FForegroundColor) +
    ';' + IntToStr(FBackgroundValue) + ';' + ColorToString(FBackgroundColor);
end;

{ TORSymbolLabel }

constructor TORSymbolLabel.Create(AOwner: TComponent);
begin
  inherited;
  FSymbol := TORSymbol.Create(Self);
  Caption := ' ';
  EllipsisPosition := epNone;
  ShowAccelChar := False;
  StyleElements := [];
  Transparent := True;
  WordWrap := False;
end;

destructor TORSymbolLabel.Destroy;
begin
  FSymbol.Free;
  inherited;
end;

procedure TORSymbolLabel.DoDrawText(var Rect: TRect; Flags: Longint);
var
  Rect1, Rect2: TRect;
  DrawCount: Integer;
begin
  Rect1 := Rect;
  Rect2 := Rect;
  DrawCount := 0;
  Flags := Flags or DT_NOPREFIX;
  Flags := DrawTextBiDiModeFlags(Flags);
  Canvas.Font := Font;
  Canvas.Font.Name := SymbolFontName;
  if Assigned(FSymbol) then
  begin
    if FSymbol.BackgroundValue <> TORSymbol.DefaultValue then
    begin
      Canvas.Font.Color := FSymbol.BackgroundColor;
      Winapi.Windows.DrawTextW(Canvas.Handle, Char(FSymbol.BackgroundValue), 1,
        Rect1, Flags);
      Rect := Rect1;
      inc(DrawCount);
    end;
    if FSymbol.ForegroundValue <> TORSymbol.DefaultValue then
    begin
      Canvas.Font.Color := FSymbol.ForegroundColor;
      Winapi.Windows.DrawTextW(Canvas.Handle, Char(FSymbol.ForegroundValue), 1,
        Rect2, Flags);
      inc(DrawCount);
      if DrawCount > 1 then
      begin
        if Rect.Width < Rect2.Width then
          Rect := Rect2;
      end
      else
        Rect := Rect2
    end;
  end;
  if (DrawCount = 0) and ((Flags and DT_CALCRECT) = DT_CALCRECT) then
    Winapi.Windows.DrawTextW(Canvas.Handle, '', 1, Rect, Flags);
end;

function TORSymbolLabel.GetSymbolSize: Integer;
var
  TextWidth: Integer;
begin
  Canvas.Font := Font;
  Canvas.Font.Name := SymbolFontName;
  Result := 0;
  if FSymbol.BackgroundValue <> TORSymbol.DefaultValue then
    Result := Canvas.TextWidth(Char(FSymbol.BackgroundValue));
  if FSymbol.FForegroundValue <> TORSymbol.DefaultValue then
  begin
    TextWidth := Canvas.TextWidth(Char(FSymbol.ForegroundValue));
    if Result < TextWidth then
      Result := TextWidth;
  end;
end;

procedure TORSymbolLabel.SetSymbol(const Value: TORSymbol);
begin
  FSymbol.BackgroundColor := Value.BackgroundColor;
  FSymbol.BackgroundValue := Value.BackgroundValue;
  FSymbol.ForegroundColor := Value.ForegroundColor;
  FSymbol.ForegroundValue := Value.ForegroundValue;
  AdjustBounds;
  Invalidate;
end;

end.

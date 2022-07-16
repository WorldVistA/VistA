unit ORRadioCheck;

interface

uses Windows, Classes, SysUtils, ComCtrls, ExtCtrls, StdCtrls, Controls, Graphics, Messages, ORStaticText;

const
  OR_DEFAULT_SPACING = 3;
  DEFAULT_ICON_SIZE  = 17; // default size
  DEFAULT_MAX_WIDTH  = 0;

type
  TORRadioCheck = class(TPanel)
  private
    fCheck: TCheckbox;
    fRadio: TRadioButton;

    fSingleLine: boolean;
    fFocusOnBox: boolean;
    fGrayedToChecked: boolean;
    fAllowAllUnchecked: boolean;
    fAssociate: TControl;
    fSpacing: integer;
    fUseRadioStyle: boolean;
    fPreDelimiter: TSysCharSet;
    fPostDelimiter: TSysCharSet;
    IconSize: integer;
    FontHeight: integer;

    fLines: TStrings; // property holder for Lines
    fDisplayed: TStringList;

    fTransparent: boolean;        // property holder for Transparent
    fVerticalSpace: integer;      // property holder for VerticalSpace

    Resizing: boolean;  // flag stating the control is resizing
    Painting: boolean;
    FirstTime: boolean; // flag stating the control needs initialization
    fWordWrap: boolean;
    fMaxWidth: integer;
    fWrapByChar: boolean;
    fPauseResize: boolean;
    ResizeRequested: boolean;

    LargestPixelWidth: longint;
    fClicksDisabled: Boolean;
    FStringData: string;

    function GetGroupIndex: integer;
    procedure SetAssociate(const Value: TControl);
    procedure SetGroupIndex(const Value: integer);
    procedure SetUseRadioStyle(const Value: boolean);
    procedure SetSpacing(const Value: integer);
    function GetSingleLine: boolean;

    procedure TextToCanvas(y: integer; s: string);
    procedure SetMaxWidth(const Value: integer);
    procedure SetWrapByChar(const Value: boolean);

    procedure SyncAllowAllUnchecked;
    procedure SetPostDelimiter(const Value: TSysCharSet);
    procedure SetPreDelimiter(const Value: TSysCharSet);
    function GetChecked: boolean;
    procedure SetChecked(const Value: boolean);
    function GetText: string;
    function GetLine(const idx: integer): string;
    procedure SetLine(const idx: integer; const Value: string);
    function GetCount: integer;
    function BoxWidth: integer;
    procedure SetFocusOnBox(const Value: boolean);
    function GetState: TCheckBoxState;
    procedure SetState(const Value: TCheckBoxState);
    function GetCaption: string;
    procedure SetCaption(const Value: string);

  protected
    procedure DoEnter; override; // fires when the control is entered; used for displaying the focus status
    procedure DoExit; override;  // fires when the control is exited; used for displaying the focus status

    procedure SetName(const Value: TComponentName); override; // Sets the text in the control when the name is changed

    procedure SetAllowAllUnchecked(const Value: boolean);
    procedure UpdateAssociate;

    procedure Paint; override;
    procedure Resize; override;
    procedure RefreshParts;

    procedure SetLines(const Value: TStrings);          // write accessor for Lines
    procedure SetText(const Value: string);                // write accessor for Text
    procedure SetVerticalSpace(const Value: integer);      // write accessor for VerticalSpace
    procedure SetTransparent(const Value: boolean);        // write accessor for Transparent
    procedure SetWordWrap(const Value: boolean);

    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
    function LargestTextWidth: longint;
    property ClicksDisabled: Boolean read FClicksDisabled write FClicksDisabled;
  public
    property Caption: string read GetCaption write SetCaption;
    property Displayed: TStringList read fDisplayed;
    constructor Create(AOwner: TComponent); override; // constructor
    destructor Destroy; override;                     // destructor
    procedure PauseResize;
    procedure ResumeResize;

    property SingleLine: boolean read GetSingleLine;
    property PreDelimiters: TSysCharSet read fPreDelimiter write SetPreDelimiter;
    property PostDelimiters: TSysCharSet read fPostDelimiter write SetPostDelimiter;

    property Checkbox: TCheckbox read fCheck write fCheck;
    property RadioButton: TRadioButton read fRadio write fRadio;
    property DockManager;
    property Line[const idx: integer]: string read GetLine write SetLine;                                     // user-formatted text; CRLF delimited
    property StringData: string read FStringData write FStringData;
  published
    property AutoSize;
    property AllowAllUnchecked: boolean read FAllowAllUnchecked write SetAllowAllUnchecked default True;
    property Associate: TControl read FAssociate write SetAssociate;
    property GroupIndex: integer read GetGroupIndex write SetGroupIndex default 0;
    property Spacing: integer read fSpacing write SetSpacing default OR_DEFAULT_SPACING;
    property UseRadioStyle: boolean read fUseRadioStyle write SetUseRadioStyle default False;
    property Checked: boolean read GetChecked write SetChecked;
    property Text: string read GetText write SetText;
    property Lines: TStrings read fLines write SetLines;
    property Transparent: boolean read fTransparent write SetTransparent default True;            // determines if the background is transparent
    property VerticalSpace: integer read fVerticalSpace write SetVerticalSpace default DEFAULT_ICON_SIZE;         // number of vertical pixel spaces between items when using multi-line
    property WordWrap: boolean read fWordWrap write SetWordWrap default False;
    property MaxWidth: integer read fMaxWidth write SetMaxWidth default DEFAULT_MAX_WIDTH;
    property WrapByChar: boolean read fWrapByChar write SetWrapByChar default False;
    property Count: integer read GetCount;
    property FocusOnBox: boolean read FFocusOnBox write SetFocusOnBox default false;
    property State: TCheckBoxState read GetState write SetState;
  end;

implementation

uses ORFn, Math, System.UITypes;

{ TORRadioCheck }

function TORRadioCheck.BoxWidth: integer;
begin
  Result := Max(fCheck.Width, fRadio.Width);
end;

function TORRadioCheck.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  if HandleAllocated and (Align <> alClient) and
    (not (csDesigning in ComponentState) or (ControlCount > 0)) then
  begin
    NewWidth := Max(fRadio.Width, fCheck.Width) + fSpacing + LargestTextWidth + Margins.Left + Margins.Right;
    NewHeight := Max(fDisplayed.Count * FontHeight, fCheck.Height) + Margins.Top + Margins.Bottom + (fVerticalSpace * fLines.Count);
  end;
end;

constructor TORRadioCheck.Create(AOwner: TComponent);
begin
  inherited;
  IconSize := DEFAULT_ICON_SIZE; // default size

  BevelInner := bvNone;
  BevelOuter := bvNone;
  ShowCaption := False;
  ParentFont := True;


  // initialize objects
  fLines := TStringList.Create;
  fDisplayed := TStringList.Create;

  // set internal property values
  fMaxWidth := DEFAULT_MAX_WIDTH;
  fTransparent := True;
  fVerticalSpace := OR_DEFAULT_SPACING;
  fWordWrap := False;
  Caption := '';
  fWrapByChar := False;
  fPauseResize := False;
  ResizeRequested := False;

  // set flags
  Resizing := False;
  Painting := False;
  FirstTime := True;

  // set inherited property values
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Alignment := taLeftJustify;
  fSpacing := OR_DEFAULT_SPACING;
  Height := IconSize + Margins.Top + Margins.Bottom;
  Width := IconSize + Margins.Left + Margins.Right + fSpacing;
  FontHeight := FontHeightInPixels(Font);

  fCheck := TCheckbox.Create(Self);
  fCheck.Parent := Self;
  fCheck.Left := 0;
  fCheck.Top := 0;
  fCheck.Caption := '';
  fCheck.Width := fCheck.Height;
  IconSize := fCheck.Height;
  fCheck.ParentFont := True;
  fCheck.Visible := True;
  fCheck.OnClick := Self.OnClick;

  fRadio := TRadioButton.Create(Self);
  fRadio.Parent := Self;
  fRadio.Left := 0;
  fRadio.Top := 0;
  fRadio.Width := fRadio.Height;
  fRadio.Caption := '';
  fRadio.Visible := False;
  fRadio.ParentFont := True;
  fRadio.OnClick := Self.OnClick;

  UseRadioStyle := False;
  fSingleLine := True;
  fFocusOnBox := False;
  fGrayedToChecked := True;
  fAllowAllUnchecked := True;
  fAssociate := nil;
end;

destructor TORRadioCheck.Destroy;
begin
  // free up objects
  if assigned(fLines) then fLines.Free;
  if assigned(fDisplayed) then fDisplayed.Free;
  inherited;
end;

procedure TORRadioCheck.DoEnter;
begin
  Paint;
  inherited;
end;

procedure TORRadioCheck.DoExit;
begin
  Paint;
  inherited;
end;

function TORRadioCheck.GetCaption: string;
begin
  Result := GetText;
end;

function TORRadioCheck.GetChecked: boolean;
begin
  Result := fCheck.Checked;
end;

function TORRadioCheck.GetCount: integer;
begin
  Result := fLines.Count;
end;

function TORRadioCheck.GetGroupIndex: integer;
begin
  Result := fRadio.Tag;
end;

function TORRadioCheck.GetLine(const idx: integer): string;
begin
  if (idx >= 0) and (idx < Count) then
    Result := fLines[idx]
  else
    raise exception.Create('line index out of bounds (' + IntToStr(idx) + ')');
end;

function TORRadioCheck.GetSingleLine: boolean;
begin
  Result := (fLines.Count = 1); // assumption: this may need to be < 2
end;

function TORRadioCheck.GetState: TCheckBoxState;
begin
  Result := fCheck.State;
end;

function TORRadioCheck.GetText: string;
begin
  Result := fLines.Text;
end;

function TORRadioCheck.LargestTextWidth: longint;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to (fLines.Count - 1) do begin
    if Trim(fLines[i]) <> '' then begin
      Result := Max(FontWidthInPixels(Font, fLines[i]), Result);
    end;
  end;
end;

procedure TORRadioCheck.Paint;
var
  r: TRect;                   // rectangle used to draw the border
  i: integer;                 // loops
  OldPenColor,                // saves the former pen color while drawing the border
  OldBrushColor: TColor;      // saves the former brush color while drawing the border
  OldPenStyle: TPenStyle;     // saves the former pen style while drawing the border
  OldBrushStyle: TBrushStyle; // saves the former brush style while drawing the border
begin
  if assigned(Canvas) then begin
    if not Painting then begin
      Painting := True;
      try
        FontHeight := FontHeightInPixels(Font);
        fCheck.Visible := (not fUseRadioStyle);
        fRadio.Visible := fUseRadioStyle;
        if fUseRadioStyle then begin
          fCheck.Width := 0;
          fRadio.Width := IconSize;
        end else begin
          fCheck.Width := IconSize;
          fRadio.Width := 0;
        end;
        fCheck.Top := Max(fCheck.Height, FontHeight) - fCheck.Height + Margins.Top;
        fRadio.Top := fCheck.Top;

        {------------------}
        { Draw the outline }
        {------------------}
        OldBrushColor := Canvas.Brush.Color;
        OldBrushStyle := Canvas.Brush.Style;
        OldPenColor := Canvas.Pen.Color; // save old settings
        OldPenStyle := Canvas.Pen.Style;
        try
          Canvas.Font.Assign(Font); // make sure using the correct font to draw with
          Canvas.Pen.Width := 1;
          if Transparent then begin
            Canvas.Brush.Style := bsClear;
            Canvas.Brush.Color := clNone;
          end else begin
            Canvas.Brush.Style := bsSolid;
            Canvas.Brush.Color := Color;
          end;

          Canvas.Brush.Color := clNone;
          Canvas.Brush.Style := bsClear;
          if Focused then begin               // focused control uses dotted line in font color
            Canvas.Pen.Style := psDot;
            Canvas.Pen.Color := Font.Color;
          end else begin                      // normal drawing just draws a rectangle that overwrites previous rectangles
            Canvas.Pen.Style := psSolid;
            Canvas.Pen.Color := Color;
          end;
          r := Rect(0, 0, Width, Height);
          if Transparent then begin
            Canvas.TextFlags := 0;
            Canvas.FrameRect(r);
          end else begin
            Canvas.TextFlags := ETO_OPAQUE;
            Canvas.Rectangle(r);              // draw the rectangle
          end;

          {---------------}
          { Draw the text }
          {---------------}
          // write out the strings after determining if they are wrapped
          for i := 0 to (fDisplayed.Count - 1) do begin // loop through lines, determine if they need wrapped
            TextToCanvas(Margins.Top + (i * (FontHeight + VerticalSpace)), fDisplayed[i]);
          end;
        finally
          Canvas.Brush.Color := OldBrushColor;
          Canvas.Brush.Style := OldBrushStyle;
          Canvas.Pen.Color := OldPenColor;
          Canvas.Pen.Style := OldPenStyle;
        end;
      finally
        Painting := False;
      end;
    end;
  end;
end;

procedure TORRadioCheck.PauseResize;
begin
  fPauseResize := True;
end;

procedure TORRadioCheck.RefreshParts;
begin
  fCheck.Repaint;
  fRadio.Repaint;
  Invalidate;
end;

procedure TORRadioCheck.Resize;
var
  i: integer;
  sl: TStringList;
  WorkWidth: integer;
begin
  inherited;
  FontHeight := FontHeightInPixels(Font);
  if fPauseResize then begin
    ResizeRequested := True;
  end else begin
    if not Resizing then begin
      Resizing := True;
      try
        fDisplayed.Clear;
        LargestPixelWidth := FindFontMetrics(Font).tmMaxCharWidth;
        if fWordWrap then begin // word handling is Word Wrap
          if (fMaxWidth > 0) then begin
            WorkWidth := Min(LargestTextWidth, fMaxWidth);
          end else begin
            WorkWidth := Width - fSpacing - BoxWidth;
          end;
          for i := 0 to (fLines.Count - 1) do
          begin
            if fWrapByChar and (fMaxWidth > 0) then
              sl := WrapTextByChar(fLines[i], fMaxWidth, Canvas, PreSeparatorChars, PostSeparatorChars)
            else
              sl := WrapTextByPixels(fLines[i], WorkWidth, Canvas, PreSeparatorChars, PostSeparatorChars);
            fDisplayed.AddStrings(sl);
            sl.Free;
          end;
        end else begin // no word wrapping
          fDisplayed.Text := fLines.Text;
        end;
        Invalidate;
      finally
        Resizing := False;
      end;
    end;
  end;
end;

procedure TORRadioCheck.ResumeResize;
begin
  fPauseResize := False;
  if ResizeRequested then Resize;
end;

procedure TORRadioCheck.SetAllowAllUnchecked(const Value: boolean);
begin
  FAllowAllUnchecked := Value;
  SyncAllowAllUnchecked;
end;

procedure TORRadioCheck.SetAssociate(const Value: TControl);
begin
  if (FAssociate <> Value) then
  begin
    if (assigned(FAssociate)) then
      FAssociate.RemoveFreeNotification(Self);
    FAssociate := Value;
    if (assigned(FAssociate)) then
    begin
      FAssociate.FreeNotification(Self);
      UpdateAssociate;
    end;
  end;
end;

procedure TORRadioCheck.UpdateAssociate;

  procedure EnableCtrl(Ctrl: TControl; DoCtrl: boolean);
  var
    i: integer;
    DoIt: boolean;

  begin
    if DoCtrl then
      Ctrl.Enabled := Checked;

    // added (csAcceptsControls in Ctrl.ControlStyle) below to prevent disabling of
    // child sub controls, like the TBitBtn in the TORComboBox.  If the combo box is
    // already disabled, we don't want to disable the button as well - when we do, we
    // lose the disabled glyph that is stored on that button for the combo box.

    if (Ctrl is TWinControl) and (csAcceptsControls in Ctrl.ControlStyle) then
    begin
      for i := 0 to TWinControl(Ctrl).ControlCount - 1 do
      begin
        if DoCtrl then
          DoIt := TRUE
        else
          DoIt := (TWinControl(Ctrl).Controls[i] is TWinControl);
        if DoIt then
          EnableCtrl(TWinControl(Ctrl).Controls[i], TRUE);
      end;
    end;
  end;

begin
  if (assigned(FAssociate)) then
    EnableCtrl(FAssociate, FALSE);
end;

procedure TORRadioCheck.SetCaption(const Value: string);
begin
  SetText(Value);
end;

procedure TORRadioCheck.SetChecked(const Value: boolean);
begin
  if (Value <> fCheck.Checked) or (Value <> fRadio.Checked) then begin
    fCheck.Checked := Value;
    fRadio.Checked := Value;
  end;
  invalidate;
end;

procedure TORRadioCheck.SetFocusOnBox(const Value: boolean);
begin
  fFocusOnBox := Value;
  invalidate;
end;

procedure TORRadioCheck.SetGroupIndex(const Value: integer);
begin
  fRadio.Tag := Value;
end;

procedure TORRadioCheck.SetLine(const idx: integer; const Value: string);
begin
  if (idx >= 0) and (idx < Count) then begin
    if fLines[idx] <> Value then begin
      fLines[idx] := Value;
      Resize;
    end;
  end else
    raise exception.Create('line index out of bounds (' + IntToStr(idx) + ')');
end;

procedure TORRadioCheck.SetLines(const Value: TStrings);
begin
  if (Value.Text <> fLines.Text) then begin
    fLines.Text := Value.Text;
    Resize;
  end;
end;

procedure TORRadioCheck.SetMaxWidth(const Value: integer);
begin
  if (fMaxWidth <> Value) then begin
    fMaxWidth := Value;
    Resize;
  end;
end;

procedure TORRadioCheck.SetName(const Value: TComponentName);
begin
  inherited;
  if (Name <> Value) then begin
    inherited SetName(Value);
    fLines.Text := Name;
  end;
end;

procedure TORRadioCheck.SetPostDelimiter(const Value: TSysCharSet);
begin
  fPostDelimiter := Value;
end;

procedure TORRadioCheck.SetPreDelimiter(const Value: TSysCharSet);
begin
  fPreDelimiter := Value;
end;

procedure TORRadioCheck.SetUseRadioStyle(const Value: boolean);
begin
  if (Value <> fUseRadioStyle) then begin
    fUseRadioStyle := Value;
  end;
  Repaint;
end;

procedure TORRadioCheck.SetVerticalSpace(const Value: integer);
begin
  if (fVerticalSpace <> Value) then begin
    fVerticalSpace := Value;
    Invalidate;
  end;
end;

procedure TORRadioCheck.SetSpacing(const Value: integer);
begin
  fSpacing := Value;
  Invalidate;
end;

procedure TORRadioCheck.SetState(const Value: TCheckBoxState);
begin
  fCheck.State := Value;
  fRadio.Checked := fCheck.Checked;
end;

procedure TORRadioCheck.SetText(const Value: string);
begin
  fLines.Text := Value;
  Resize;
end;

procedure TORRadioCheck.SetTransparent(const Value: boolean);
begin
  if (fTransparent <> Value) then begin
    fTransparent := Value;
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
  end;
  Invalidate;
end;

procedure TORRadioCheck.SetWordWrap(const Value: boolean);
begin
  if (fWordWrap <> Value) then begin
    fWordWrap := Value;
  end;
  Resize;
end;

procedure TORRadioCheck.SetWrapByChar(const Value: boolean);
begin
  fWrapByChar := Value;
  Resize;
end;

procedure TORRadioCheck.SyncAllowAllUnchecked;
var
  i: integer;
  cb: TORRadioCheck;

begin
  if (assigned(Parent) and (GroupIndex <> 0)) then
  begin
    for i := 0 to Parent.ControlCount - 1 do
    begin
      if (Parent.Controls[i] is TORRadioCheck) then
      begin
        cb := TORRadioCheck(Parent.Controls[i]);
        if ((cb <> Self) and (cb.GroupIndex = GroupIndex)) then
          cb.FAllowAllUnchecked := FAllowAllUnchecked;
      end;
    end;
  end;
end;

procedure TORRadioCheck.TextToCanvas(y: integer; s: string);
begin
  if assigned(Canvas) then begin
    case Alignment of // x position based on alignment property of control
      taLeftJustify:  Canvas.TextOut(IconSize + fSpacing + Margins.Left, y, s);
      taRightJustify: Canvas.TextOut(IconSize + fSpacing + (Width - Margins.Right - Canvas.TextWidth(s)), y, s);
      taCenter:       Canvas.TextOut(IconSize + fSpacing + ((Width div 2) - Margins.Right - (Canvas.TextWidth(s) div 2)), y, s);
    end;
  end;
end;

end.

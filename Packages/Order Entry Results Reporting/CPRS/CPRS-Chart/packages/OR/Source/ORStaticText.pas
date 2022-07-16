unit ORStaticText;

(*************************************************************************************************
  OR Static Text control - Static Text control that adds multi-line capability;
                           mainly used to replace label controls that speech engines can't read.
**************************************************************************************************)

interface

uses
  Windows, Messages, Graphics, Controls, ExtCtrls, StdCtrls, Classes, SysUtils;

type
  { TORStaticText component class }
  TORStaticText = class(TPanel) // Does not accept controls
  private
    fLines: TStringList; // property holder for Lines
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

    LargestTextWidth: integer;
    LargestPixelWidth: integer;
    LargestPixelHeight: integer;

    procedure TextToCanvas(y: integer; s: string);
    procedure SetMaxWidth(const Value: integer);
    procedure SetWrapByChar(const Value: boolean);

  protected
    procedure DoEnter; override; // fires when the control is entered; used for displaying the focus status
    procedure DoExit; override;  // fires when the control is exited; used for displaying the focus status

    procedure SetName(const Value: TComponentName); override; // Sets the text in the control when the name is changed

    function GetText: string;                           // read accessor for Text

    procedure SetLines(const Value: TStringList);          // write accessor for Lines
    procedure SetText(const Value: string);             // write accessor for Text
    procedure SetVerticalSpace(const Value: integer);      // write accessor for VerticalSpace
    procedure SetTransparent(const Value: boolean);        // write accessor for Transparent
    procedure SetWordWrap(const Value: boolean);

    procedure Paint; override;   // draws the control on the canvas
    procedure Resize; override;
  public
    property Caption;
    property Displayed: TStringList read fDisplayed;
    constructor Create(AOwner: TComponent); override; // constructor
    destructor Destroy; override;                     // destructor
    procedure PauseResize;
    procedure ResumeResize;
  published
    property AutoSize;
    property Text: string read GetText write SetText;                                             // control text in a single line
    property Lines: TStringList read fLines write SetLines;                                       // user-formatted text; CRLF delimited
    property Transparent: boolean read fTransparent write SetTransparent default True;            // determines if the background is transparent
    property VerticalSpace: integer read fVerticalSpace write SetVerticalSpace default 1;         // number of vertical pixel spaces between items when using multi-line
    property WordWrap: boolean read fWordWrap write SetWordWrap default True;
    property MaxWidth: integer read fMaxWidth write SetMaxWidth default 0;
    property WrapByChar: boolean read fWrapByChar write SetWrapByChar default False;
  end;

implementation

uses
  StrUtils, Math, Forms, System.UITypes, ORFn;

{ TORStaticText }

{==================================================================================================}
{  constructor Create - Create an instance of TORStaticText.                                       }
{--------------------------------------------------------------------------------------------------}
{               AOwner: component responsible for creation/destruction of the component            }
{==================================================================================================}
constructor TORStaticText.Create(AOwner: TComponent);
begin
  inherited;

  // initialize objects
  fLines := TStringList.Create;
  fDisplayed := TStringList.Create;

  // set internal property values
  fTransparent := True;
  fVerticalSpace := 1;
  AutoSize := False;
  fWordWrap := True;
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
  Height := 1;
  Width := 1;
  ControlStyle := ControlStyle - [csAcceptsControls]; // should react like an edit, not like a panel
end;

{==================================================================================================}
{  destructor Destroy - destroy the instance of TORStatic                                          }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
destructor TORStaticText.Destroy;
begin
  // free up objects
  if assigned(fLines) then fLines.Free;
  if assigned(fDisplayed) then fDisplayed.Free;

  inherited;
end;

{==================================================================================================}
{  procedure DoEnter - override of TWinControl DoEnter: fired when a control is entered            }
{                      Needed to repaint the control to show focus                                 }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
procedure TORStaticText.DoEnter;
begin
  Paint;
  inherited;
end;

{==================================================================================================}
{  procedure DoExit - override of TWinControl DoExit: fired when a control is exited               }
{                     Needed to repaint the control to show loss of focus                          }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
procedure TORStaticText.DoExit;
begin
  Paint;
  inherited;
end;

{==================================================================================================}
{  function GetText - write accessor for Text property                                             }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
function TORStaticText.GetText: string;
begin
  Result := fLines.Text;
end;

{==================================================================================================}
{ procedure TextToCanvas - Draws the text on the canvas based on the current control properties    }
{--------------------------------------------------------------------------------------------------}
{                       y: y coordinate to start drawing the string                                }
{                       s: string to be drawn on canvas                                            }
{==================================================================================================}
procedure TORStaticText.TextToCanvas(y: integer; s: string);
begin
  if assigned(Canvas) then begin
    case Alignment of // x position based on alignment property of control
      taLeftJustify:  Canvas.TextOut(Margins.Left, y, s);
      taRightJustify: Canvas.TextOut((Width - Margins.Right - Canvas.TextWidth(s)), y, s);
      taCenter:       Canvas.TextOut(((Width div 2) - Margins.Right - (Canvas.TextWidth(s) div 2)), y, s);
    end;
  end;
end;

{==================================================================================================}
{  procedure Paint - override of TWinControl Paint                                                 }
{                    Draws the control on the canvas                                               }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
procedure TORStaticText.Paint;
var
  r: TRect;                   // rectangle used to draw the border
  i: integer;                 // loops
  py: integer;                // position y
  OldPenColor,                // saves the former pen color while drawing the border
  OldBrushColor: TColor;      // saves the former brush color while drawing the border
  OldPenStyle: TPenStyle;     // saves the former pen style while drawing the border
  OldBrushStyle: TBrushStyle; // saves the former brush style while drawing the border
begin
  if assigned(Canvas) then begin
    if not Painting then begin
      Painting := True;
      try
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
          py := Margins.Top;
          for i := 0 to (fDisplayed.Count - 1) do begin // loop through lines, determine if they need wrapped
            //ExtTextOut(Canvas.Handle, Margins.Left, py, TextFlags, nil, fDisplayed[i], Length(fDisplayed[i]), nil);
            TextToCanvas(py, fDisplayed[i]);
            inc(py, LargestPixelHeight + VerticalSpace);
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


procedure TORStaticText.PauseResize;
begin
  fPauseResize := True;
end;

{==================================================================================================}
{  procedure Resize - override of TWinControl Resize                                               }
{                    Resizes the controls based on current property settings                       }
{--------------------------------------------------------------------------------------------------}
{==================================================================================================}
procedure TORStaticText.Resize;
var
  i: integer;
  TextWidth: integer;
  TextHeight: integer;
  sl: TStringList;
begin
  inherited;
  if fPauseResize then begin
    ResizeRequested := True;
  end else begin
    if not Resizing then begin
      Resizing := True;
      try
        LargestTextWidth := 0;
        LargestPixelWidth := 0;
        LargestPixelHeight := 0;
        if fWordWrap and (fMaxWidth > 0) then begin // word handling is Word Wrap
          for i := 0 to (fLines.Count - 1) do begin
            if Trim(fLines[i]) <> '' then begin
              TextWidth := Canvas.TextWidth(fLines[i]);
              LargestTextWidth := Max(LargestTextWidth, TextWidth);
              LargestPixelWidth := Max(LargestPixelWidth, (TextWidth div Length(fLines[i]) + 1));
              TextHeight := Canvas.TextHeight(fLines[i]);
              LargestPixelHeight := Max(LargestPixelHeight, TextHeight + 1);
            end;
          end;
          if (fMaxWidth > 0) then begin
            LargestTextWidth := Min(LargestTextWidth, fMaxWidth);
          end;
          for i := 0 to (fLines.Count - 1) do
          begin
            if fWrapByChar then
              sl := WrapTextByChar(fLines[i], fMaxWidth, Canvas, PreSeparatorChars, PostSeparatorChars)
            else
              sl := WrapTextByPixels(fLines[i], LargestTextWidth, Canvas, PreSeparatorChars, PostSeparatorChars);
            fDisplayed.AddStrings(sl);
            sl.Free;
          end;
        end else begin // no word wrapping
          fDisplayed.Text := fLines.Text;
        end;

        if AutoSize then begin
          Width := LargestTextWidth * LargestPixelWidth + Margins.Left + Margins.Right;
          Height := fDisplayed.Count * LargestPixelHeight + Margins.Top + Margins.Bottom;
        end;
        Invalidate;
      finally
        Resizing := False;
      end;
    end;
  end;
end;

procedure TORStaticText.ResumeResize;
begin
  fPauseResize := False;
  if ResizeRequested then Resize;
end;

{==================================================================================================}
{  procedure SetLines - write accessor for Lines property                                          }
{--------------------------------------------------------------------------------------------------}
{                Value: Lines' new value                                                           }
{==================================================================================================}
procedure TORStaticText.SetLines(const Value: TStringList);
begin
  if (Value.Text <> fLines.Text) then begin
    fLines.Text := Value.Text;
    Resize;
  end;
end;

{==================================================================================================}
{  procedure SetMultiLine - write accessor for MultiLine property                                  }
{--------------------------------------------------------------------------------------------------}
{                    Value: MultiLine's new value                                                  }
{==================================================================================================}
procedure TORStaticText.SetMaxWidth(const Value: integer);
begin
  if (fMaxWidth <> Value) then begin
    fMaxWidth := Value;
    Resize;
  end;
end;

{==================================================================================================}
{  procedure SetName - overwrite write accessor for Name property                                  }
{--------------------------------------------------------------------------------------------------}
{               Value: New name for the component                                                  }
{==================================================================================================}
procedure TORStaticText.SetName(const Value: TComponentName);
begin
  if (Name <> Value) then begin
    inherited SetName(Value);
    fLines.Text := Name;
  end;
end;

{==================================================================================================}
{  procedure SetTransparent - write accessor for Transparent property                              }
{--------------------------------------------------------------------------------------------------}
{                    Value: Transparent's new value                                                }
{==================================================================================================}
procedure TORStaticText.SetText(const Value: string);
begin
  if (Value <> fLines.Text) then begin
    fLines.Text := Value;
    Resize;
  end;
end;

procedure TORStaticText.SetTransparent(const Value: boolean);
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

{==================================================================================================}
{  procedure SetVerticalSpace - write accessor for VerticalSpace property                          }
{--------------------------------------------------------------------------------------------------}
{                        Value: VerticalSpace's new value                                          }
{==================================================================================================}
procedure TORStaticText.SetVerticalSpace(const Value: integer);
begin
  if (fVerticalSpace <> Value) then begin
    fVerticalSpace := Value;
    Invalidate;
  end;
end;

procedure TORStaticText.SetWordWrap(const Value: boolean);
begin
  if (fWordWrap <> Value) then begin
    fWordWrap := Value;
  end;
  Resize;
end;

procedure TORStaticText.SetWrapByChar(const Value: boolean);
begin
  fWrapByChar := Value;
  Resize;
end;

end.

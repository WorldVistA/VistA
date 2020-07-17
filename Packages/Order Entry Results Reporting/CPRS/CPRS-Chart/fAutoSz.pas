unit fAutoSz;
{ provides the basic mechanism to resize all the controls on a form when the form size is
  changed.  Differs from frmAResize in that this one descends directly from TForm, rather
  than TPage }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmAutoSz = class(TfrmBase508Form)
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FSizes: TList;
    FAutoSizeDisabled: Boolean;
  protected
    procedure Loaded; override;
    property AutoSizeDisabled: Boolean read FAutoSizeDisabled write FAutoSizeDisabled;
  public
  end;

var
  frmAutoSz: TfrmAutoSz;

implementation

{$R *.DFM}

uses
  ORfn, VA508AccessibilityRouter;
type
  TSizeRatio = class         // records relative sizes and positions for resizing logic
  public
    FControl: TControl;
    FLeft: Extended;
    FTop: Extended;
    FWidth: Extended;
    FHeight: Extended;
    constructor Create(AControl: TControl; W, H: Integer);
  end;

{ TSizeRatio methods }

constructor TSizeRatio.Create(AControl: TControl; W, H: Integer);
begin
  FControl := AControl;
  with AControl do
  begin
    FLeft   := Left   / W;
    FTop    := Top    / H;
    FWidth  := Width  / W;
    FHeight := Height / H;
  end;
end;

{ TfrmAutoSz methods }

procedure TfrmAutoSz.Loaded;
{ record initial size & position info for resizing logic }
var
  SizeRatio: TSizeRatio;
  i,W,H: Integer;
  Control: TControl;
begin
  inherited Loaded;
  FSizes := TList.Create;
  if AutoSizeDisabled then Exit;
  W := ClientWidth;
  H := ClientHeight;
  for i := 0 to ComponentCount - 1 do if Components[i] is TControl then
  begin
    Control := TControl(Components[i]);
    W := HigherOf(W, Control.Left + Control.Width);
    H := HigherOf(H, Control.Top + Control.Height);
  end;
  ClientHeight := H;
  ClientWidth := W;
  for i := 0 to ComponentCount - 1 do if Components[i] is TControl then
  begin
    SizeRatio := TSizeRatio.Create(TControl(Components[i]), W, H);
    FSizes.Add(SizeRatio);
  end;
end;

procedure TfrmAutoSz.FormResize(Sender: TObject);
{ resize child controls using their design time proportions }
var
  SizeRatio: TSizeRatio;
  i, W, H: Integer;
begin
  inherited;
  if AutoSizeDisabled then Exit;
  W := HigherOf(ClientWidth, HorzScrollBar.Range);
  H := HigherOf(ClientHeight, VertScrollBar.Range);
  with FSizes do for i := 0 to Count - 1 do
  begin
    SizeRatio := Items[i];
    with SizeRatio do
      if ((FControl is TLabel) and TLabel(FControl).AutoSize) or ((FControl is TStaticText) and TStaticText(FControl).AutoSize) then
      begin
        FControl.Left := Round(FLeft*W);
        FControl.Top  := Round(FTop*H);
      end
      else FControl.SetBounds(Round(FLeft*W), Round(FTop*H), Round(FWidth*W), Round(FHeight*H));
  end; {with FSizes}
end;

procedure TfrmAutoSz.FormDestroy(Sender: TObject);
{ destroy objects used to record size and position information for controls }
var
  SizeRatio: TSizeRatio;
  i: Integer;
begin
  inherited;
  if FSizes <> nil then with FSizes do for i := 0 to Count-1 do
  begin
    SizeRatio := Items[i];
    SizeRatio.Free;
  end;
  FSizes.Free;
end;

initialization
  SpecifyFormIsNotADialog(TfrmAutoSz);


end.

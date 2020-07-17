unit fAResize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  fPage, ExtCtrls, VA508AccessibilityManager;

type
  TfrmAutoResize = class(TfrmPage)
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FSizes: TList;
  protected
    procedure Loaded; override;
  end;

var
  frmAutoResize: TfrmAutoResize;

implementation

uses VA508AccessibilityRouter;

{$R *.DFM}

type
  TSizeRatio = class         // records relative sizes and positions for resizing logic
  public
    CLeft: Extended;
    CTop: Extended;
    CWidth: Extended;
    CHeight: Extended;
    constructor Create(ALeft, ATop, AWidth, AHeight: Extended);
  end;

{ TSizeRatio methods }

constructor TSizeRatio.Create(ALeft, ATop, AWidth, AHeight: Extended);
begin
  CLeft := ALeft; CTop := ATop; CWidth := AWidth; CHeight := AHeight;
end;

{ TfrmAutoResize methods }

procedure TfrmAutoResize.Loaded;
{ record initial size & position info for resizing logic }
var
  SizeRatio: TSizeRatio;
  i,H,W: Integer;
begin
  FSizes := TList.Create;
  H := ClientHeight;
  W := ClientWidth;
  for i := 0 to ControlCount - 1 do with Controls[i] do
  begin
    SizeRatio := TSizeRatio.Create(Left/W, Top/H, Width/W, Height/H);
    FSizes.Add(SizeRatio);
  end;
  inherited Loaded;
end;

procedure TfrmAutoResize.FormResize(Sender: TObject);
{ resize child controls using their design time proportions }
var
  SizeRatio: TSizeRatio;
  i,H,W: Integer;
begin
  inherited;
  H := Height;
  W := Width;
  with FSizes do for i := 0 to ControlCount - 1 do
  begin
    SizeRatio := Items[i];
    with SizeRatio do
      if Controls[i] is TLabel then with Controls[i] do
        SetBounds(Round(CLeft*W), Round(CTop*H), Width, Height)
      else
        Controls[i].SetBounds(Round(CLeft*W), Round(CTop*H), Round(CWidth*W), Round(CHeight*H));
  end; {with FSizes}
end;

procedure TfrmAutoResize.FormDestroy(Sender: TObject);
{ destroy objects used to record size and position information for controls }
var
  SizeRatio: TSizeRatio;
  i: Integer;
begin
  inherited;
  with FSizes do for i := 0 to Count-1 do
  begin
    SizeRatio := Items[i];
    SizeRatio.Free;
  end;
  FSizes.Free;
end;


initialization
  SpecifyFormIsNotADialog(TfrmAutoResize);


end.

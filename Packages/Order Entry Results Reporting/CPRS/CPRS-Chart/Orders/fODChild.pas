unit fODChild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, fAutoSZ, ORFn, VA508AccessibilityManager;

type
  TfrmODChild = class(TfrmAutoSz)
    lblWarning: TLabel;
    Panel1: TPanel;
    lstODComplex: TListBox;
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lstODComplexDrawItem(Control: TWinControl; Index: Integer;
      TheRect: TRect; State: TOwnerDrawState);
    procedure lstODComplexMeasureItem(Control: TWinControl; Index: Integer;
      var TheHeight: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FCmdOK: boolean;
  public
    { Public declarations }
  end;

function ActionOnComplexOrder(AnList: TStringList; CaptionTxt: string = ''; ShowCancel: boolean = False): boolean;

implementation

uses
  System.UITypes;

{$R *.DFM}
function ActionOnComplexOrder(AnList: TStringList; CaptionTxt: string; ShowCancel: boolean): boolean;
var
  i: integer;
  frmODChild: TfrmODChild;
begin
  frmODChild := TfrmODChild.Create(nil);
  try
    try
      ResizeFormToFont(TForm(frmODChild));
      if Length(CaptionTxt)>0 then
        frmODChild.lblWarning.Caption := CaptionTxt;

      for i := 0 to AnList.count - 1 do
        frmODChild.lstODComplex.Items.Add(AnList[i]);

      if not ShowCancel then
      begin
        frmODChild.btnOK.Visible := False;
        frmODChild.btnCancel.Caption := 'OK';
      end;

      frmODChild.ShowModal;
      if frmODChild.FCmdOK then Result := True else Result := False;
    except
      on e: Exception do
        Result := False;
    end;
  finally
    frmODChild.Release;
  end;
end;

procedure TfrmODChild.FormCreate(Sender: TObject);
begin
  FCmdOK := False;
end;

procedure TfrmODChild.lstODComplexDrawItem(Control: TWinControl;
  Index: Integer; TheRect: TRect; State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
  SaveColor: TColor;
begin
  inherited;
  with lstODComplex do
  begin
    ARect := TheRect;
    ARect.Left := ARect.Left + 2;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    SaveColor := Canvas.Brush.Color;
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := Piece(Items[index],'^',2);
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
      Canvas.Brush.Color := SaveColor;
      ARect.Right := ARect.Right + 4;
    end;
  end;
end;

procedure TfrmODChild.lstODComplexMeasureItem(Control: TWinControl;
  Index: Integer; var TheHeight: Integer);
var
  x :string;
  tempHeight: integer;
  R: TRect;
begin
  inherited;
  tempHeight := 0;
  TheHeight := MainFontHeight + 2;
  with lstODComplex do if Index < Items.Count then
  begin
    R := ItemRect(Index);
    R.Left   := 0;
    R.Right  := R.Right - 4;
    R.Top    := 0;
    R.Bottom := 0;
    x := Piece(Items[index],'^',2);
    TempHeight := WrappedTextHeightByFont(Canvas, Font, x, R);
    TempHeight := HigherOf(TempHeight,TheHeight);
    if TempHeight > 255 then TempHeight := 255;
    if TempHeight < 13 then TempHeight := 13;
  end;
  TheHeight := TempHeight;
end;

procedure TfrmODChild.btnOKClick(Sender: TObject);
begin
  FCmdOK := True;
  Close;
end;

procedure TfrmODChild.btnCancelClick(Sender: TObject);
begin
  FCmdOK := False;
  Close;
end;

end.

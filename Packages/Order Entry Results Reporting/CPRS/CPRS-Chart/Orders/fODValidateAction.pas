unit fODValidateAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ORFn, uCore, StdCtrls, CheckLst, ComCtrls,ExtCtrls,uConst, ORCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmInvalidActionList = class(TfrmBase508Form)
    pnlTop: TPanel;
    lstActDeniedOrders: TCaptionListBox;
    Label1: TLabel;
    hdrAction: THeaderControl;
    pnlBottom: TPanel;
    Label2: TLabel;
    lstValidOrders: TCaptionListBox;
    Panel1: TPanel;
    btnOK: TButton;
    procedure lstActDeniedOrdersDrawItem(Control: TWinControl;
      Index: Integer; TheRect: TRect; State: TOwnerDrawState);
    procedure lstActDeniedOrdersMeasureItem(Control: TWinControl;
      Index: Integer; var AHeight: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure hdrActionSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    procedure lstValidOrdersMeasureItem(Control: TWinControl;
      Index: Integer; var AHeight: Integer);
    procedure lstValidOrdersDrawItem(Control: TWinControl; Index: Integer;
      TheRect: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    TheInvaList: TStringList;
    procedure RedrawActiveList;
  public
    { Public declarations }
  end;

  procedure DisplayOrdersForAction(TheInvalidList: TStringList; TheValidList: TStringList; TheAction: String);

implementation

uses
  VA2006Utils, System.UITypes;

{$R *.DFM}

procedure DisplayOrdersForAction(TheInvalidList: TStringList; TheValidList: TStringList; TheAction: String);
var
  frmInvalidActionList: TfrmInvalidActionList;
  i: integer;
begin
  frmInvalidActionList := TfrmInvalidActionList.Create(Application);
  frmInvalidActionList.TheInvaList :=TheInvalidList;
  if TheAction = OA_CHGEVT then
  begin
    frmInvalidActionList.Caption  := 'Change Release Event';
    frmInvalidActionList.Label1.Caption := 'You can not change the release event for the following orders.';
    frmInvalidActionList.Label2.Caption := 'You can change the release event for the following orders.';
  end;
  if TheAction = OA_EDREL then
  begin
    frmInvalidActionList.Caption  := 'Release Order(s) To Service';
    frmInvalidActionList.Label1.Caption := 'You can not release the following orders to service.';
    frmInvalidActionList.Label2.Caption := 'You can release the following orders to service.';
  end;
  for i := 0 to TheInvalidList.Count - 1 do
  begin
    frmInvalidActionList.lstActDeniedOrders.Items.Add(Piece(TheInvalidList[i], U, 1) + ' ' + Piece(TheInvalidList[i], U, 2));
  end;
  for i := 0 to TheValidList.Count - 1 do
  begin
    frmInvalidActionList.lstValidOrders.Items.Add(TheValidList[i]);
  end;
  if TheValidList.Count = 0 then
  begin
    frmInvalidActionList.lstValidOrders.Visible := False;
    frmInvalidActionList.pnlBottom.Visible := False;
    frmInvalidActionList.Height := frmInvalidActionList.Height - frmInvalidActionList.pnlBottom.Height;
  end;
  Beep;
  frmInvalidActionList.ShowModal;
  frmInvalidActionList.TheInvaList.Free;
end;

procedure TfrmInvalidActionList.lstActDeniedOrdersDrawItem(
  Control: TWinControl; Index: Integer; TheRect: TRect;
  State: TOwnerDrawState);
var
  x,x1,x2: string;
  ARect: TRect;
  i,RightSide: integer;
  SaveColor: TColor;
begin
  inherited;
  with lstActDeniedOrders do
  begin
    ARect := TheRect;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    RightSide := -2;
    for i := 0 to 1 do
    begin
      RightSide := RightSide + hdrAction.Sections[i].Width;
      Canvas.MoveTo(RightSide, ARect.Bottom - 1);
      Canvas.LineTo(RightSide, ARect.Top);
    end;
    if Index < Items.Count then
    begin
      x1 := FilteredString(Piece(TheInvaList[index],'^',1));
      x2 := Piece(TheInvaList[index],'^',2);
      for i := 0 to 1 do
      begin
        if i > 0 then ARect.Left := ARect.Right + 2 else ARect.Left := 2;
        ARect.Right := ARect.Left + hdrAction.Sections[i].Width - 6;
        SaveColor := Canvas.Brush.Color;
        if i = 0 then
          x := x1;
        if i = 1 then
          x := x2;
        DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
        Canvas.Brush.Color := SaveColor;
        ARect.Right := ARect.Right + 4;
      end;
    end;
  end;
end;

procedure TfrmInvalidActionList.lstActDeniedOrdersMeasureItem(
  Control: TWinControl; Index: Integer; var AHeight: Integer);
var
  x1,x2: string;
  ARect: TRect;
  TextHeight, ReasonHeight, NewHeight: Integer;
begin
  inherited;
  AHeight := MainFontHeight + 2;
  NewHeight := AHeight;
  with lstActDeniedOrders do if Index < Items.Count then
  begin
    x1 := FilteredString(Piece(TheInvaList[index],'^',1));
    x2 := Piece(TheInvaList[index],'^',2);

    ARect := ItemRect(Index);
    ARect.Right := hdrAction.Sections[0].Width - 6;
    ARect.Left := 0; ARect.Top := 0; ARect.Bottom := 0;
    TextHeight := DrawText(Canvas.Handle, PChar(x1), Length(x1), ARect,
        DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_WORDBREAK) + 2;

    ARect := ItemRect(Index);
    ARect.Right := hdrAction.Sections[1].Width - 6;
    ARect.Left := 0; ARect.Top := 0; ARect.Bottom := 0;
    ReasonHeight := DrawText(Canvas.Handle, PChar(x2), Length(x2), ARect,
      DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_WORDBREAK) + 2;
    NewHeight := HigherOf(TextHeight, ReasonHeight);
    if NewHeight > 255 then NewHeight := 255;
    if NewHeight <  13 then NewHeight := 13;
  end;
  AHeight := NewHeight;
end;

procedure TfrmInvalidActionList.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInvalidActionList.FormCreate(Sender: TObject);
begin
  FixHeaderControlDelphi2006Bug(hdrAction);
  TheInvaList := TStringList.Create;
end;

procedure TfrmInvalidActionList.hdrActionSectionResize(
  HeaderControl: THeaderControl; Section: THeaderSection);
begin
  inherited;
  LockDrawing;
  try
    RedrawActiveList;
  finally
    UnlockDrawing;
  end;
  lstActDeniedOrders.Invalidate;
end;

procedure TfrmInvalidActionList.RedrawActiveList;
var
  i, SaveTop: Integer;
begin
  with lstActDeniedOrders do
  begin
    LockDrawing;
    try
      SaveTop := TopIndex;
      Clear;
      for i := 0 to TheInvaList.Count - 1 do
        Items.Add(Piece(TheInvaList[i], U, 1) + ' ' + Piece(TheInvaList[i], U, 2));
      TopIndex := SaveTop;
    finally
      UnlockDrawing;
    end;
  end;
end;

procedure TfrmInvalidActionList.lstValidOrdersMeasureItem(
  Control: TWinControl; Index: Integer; var AHeight: Integer);
var
  x: string;
  ARect: TRect;
  NewHeight: Integer;
begin
  inherited;
  AHeight := MainFontHeight + 2;
  NewHeight := AHeight;
  with lstValidOrders do if Index < Items.Count then
  begin
    x := FilteredString(lstValidOrders.Items[index]);
    ARect := ItemRect(Index);
    ARect.Right := hdrAction.Sections[0].Width - 6;
    ARect.Left := 0; ARect.Top := 0; ARect.Bottom := 0;
    NewHeight := DrawText(Canvas.Handle, PChar(x), Length(x), ARect,
        DT_CALCRECT or DT_LEFT or DT_NOPREFIX or DT_WORDBREAK) + 2;
    if NewHeight > 255 then NewHeight := 255;
    if NewHeight <  13 then NewHeight := 13;
  end;
  AHeight := NewHeight;
end;

procedure TfrmInvalidActionList.lstValidOrdersDrawItem(
  Control: TWinControl; Index: Integer; TheRect: TRect;
  State: TOwnerDrawState);
var
  x: string;
  ARect: TRect;
  SaveColor: TColor;
begin
  inherited;
  with lstValidOrders do
  begin
    ARect := TheRect;
    Canvas.FillRect(ARect);
    Canvas.Pen.Color := Get508CompliantColor(clSilver);
    SaveColor := Canvas.Brush.Color;    
    Canvas.MoveTo(ARect.Left, ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right, ARect.Bottom - 1);
    if Index < Items.Count then
    begin
      x := FilteredString(lstValidOrders.Items[index]);
      DrawText(Canvas.Handle, PChar(x), Length(x), ARect, DT_LEFT or DT_NOPREFIX or DT_WORDBREAK);
      Canvas.Brush.Color := SaveColor;
      ARect.Right := ARect.Right + 4;
    end;
  end;
end;

procedure TfrmInvalidActionList.FormResize(Sender: TObject);
begin
  if pnlBottom.Visible then
    pnlTop.Height := (Height div 5 ) * 2
end;

end.

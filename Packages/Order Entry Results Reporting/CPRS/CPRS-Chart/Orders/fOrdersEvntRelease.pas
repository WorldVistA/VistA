unit fOrdersEvntRelease;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  ,ORFn, uCore, rOrders, fOrders, StdCtrls, ORCtrls, ExtCtrls, Grids,fAutoSz,
  Spin, ComCtrls, VA508AccessibilityManager;

type
  TfrmOrdersEvntRelease = class(TfrmAutoSz)
    pnlTop: TPanel;
    lblPtInfo: TStaticText;
    pnlBottom: TPanel;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    grdEvtList: TCaptionStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    btnApply: TButton;
    updown1: TUpDown;
    edtNumber: TEdit;
    Panel3: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdEvtListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdEvtListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure grdEvtListKeyPress(Sender: TObject; var Key: Char);
    procedure grdEvtListDblClick(Sender: TObject);
    procedure pnlBottomResize(Sender: TObject);
    procedure edtNumberChange(Sender: TObject);
    procedure edtNumberKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnApplyClick(Sender: TObject);
    procedure btnApplyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNumberClick(Sender: TObject);
    procedure updown1Click(Sender: TObject; Button: TUDBtnType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FEvtList: TStringList;
    FTotal: Integer;
    FDGroup: Integer;
    FViewName: string;
    FPtEvt:      string;
    FEvent:  TOrderDelayEvent;
    fPreTxt: string;
    FOkPressed:  Boolean;
    procedure ShowEvents(NumOfEvts: integer);
  public
    { Public declarations }
  end;

  procedure SelectEvtReleasedOrders(var OrderView: TOrderView);

implementation

uses rMisc, VAUtils;

{$R *.DFM}

const
   TAB = #9;

procedure SelectEvtReleasedOrders(var OrderView: TOrderView);
const
  FROM_SERVER = TRUE;
var
  frmOrdersEvntRelease: TfrmOrdersEvntRelease;
begin
  frmOrdersEvntRelease := TfrmOrdersEvntRelease.Create(Application);
  SetFormPosition(frmOrdersEvntRelease);
  try
    with frmOrdersEvntRelease do
    begin
      FDGroup    := OrderView.DGroup;
      ShowModal;
      if FOkPressed then
      begin
        frmOrders.FromDCRelease := True;
        OrderView.Changed   := FOkPressed;
        OrderView.DGroup    := FDGroup;
        OrderView.CtxtTime  := 0;
        OrderView.TextView  := 0;
        OrderView.ViewName  := FViewName;
        OrderView.EventDelay.PtEventIFN := StrToIntDef(FPtEvt,0);
        if FEvent.PtEventIFN > 0 then OrderView.EventDelay := FEvent
        else
        begin
          OrderView.EventDelay.EventType := 'C';
          OrderView.EventDelay.Specialty := 0;
          OrderView.EventDelay.Effective := 0;
          OrderView.EventDelay.PtEventIFN := 0;
        end;
      end else
        OrderView.Changed := False;
    end;
  finally
    frmOrdersEvntRelease.FEvtList.Clear;
    frmOrdersEvntRelease.Release;
    frmOrdersEvntRelease.FOkPressed := False;
  end;
end;

procedure TfrmOrdersEvntRelease.FormCreate(Sender: TObject);
var
  CurrTS: string;
  SpeCap: string;
  ATotal: integer;
begin
  CurrTS := Piece(GetCurrentSpec(Patient.DFN),'^',1);
  if Length(CurrTS)>0 then
    SpeCap := #13 + '  The current treating specialty is ' + CurrTS
  else
    SpeCap := #13 + '  No treating specialty is available.';
  FPtEvt     := '';
  FEvent.EventType := #0;
  FEvent.EventIFN  := 0;
  FEvent.EventName := '';
  FEvent.PtEventIFN := 0;
  FEvent.Specialty  := 0;
  FEvent.Effective := 0;
  FOkPressed := False;
  FEvtList := TStringList.Create;
  FTotal := 5;
  edtNumber.Text := '5';
  fPreTxt := edtNumber.Text;
  if Patient.Inpatient then
    lblPtInfo.Caption := '  ' + Patient.Name + ' is currently admitted to ' + Encounter.LocationName +  SpeCap
  else
  begin
    if Encounter.Location > 0 then
      lblPtInfo.Caption := '  ' + Patient.Name + ' is currently at ' + Encounter.LocationName +  SpeCap
    else
      lblPtInfo.Caption := '  ' + Patient.Name + ' currently is an outpatient. ' +  SpeCap;
  end;
  lblPtInfo.Top := (pnlTop.Height - lblPtInfo.Height) div 2;
  grdEvtList.Cells[0,0] := 'Event Name';
  grdEvtList.Cells[1,0] := 'Date/Time Occured';
  SetPtEvtList(TStrings(fevtList),Patient.DFN, ATotal);
end;

procedure TfrmOrdersEvntRelease.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOrdersEvntRelease.FormShow(Sender: TObject);
begin
  ShowEvents(fTotal);
end;

procedure TfrmOrdersEvntRelease.grdEvtListDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if gdFixed in State then
    begin
      grdEvtList.Canvas.Brush.Color := clBtnFace;
      grdEvtList.Canvas.Font.Color := clBtnText;
    end
  else if gdSelected in State then
    begin
      grdEvtList.Canvas.Brush.Color := clHighlight;
      grdEvtList.Canvas.Font.Color := clHighlightText;
    end
  else
    begin
      grdEvtList.Canvas.Font.Color := clWindowText;
      grdEvtList.Canvas.Brush.Color := clWindow;
    end;

  grdEvtList.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
    Piece(grdEvtList.Cells[ACol, ARow], TAB, 1));

  grdEvtList.Canvas.Font.Color := clWindowText;
  grdEvtList.Canvas.Brush.Color := clWindow;
end;

procedure TfrmOrdersEvntRelease.grdEvtListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  EvtInfo: string;
begin
  grdEvtList.MouseToCell(X,Y,ACol,ARow);
  if ARow>0 then
  begin
    FPtEvt := Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,2);
    if StrToIntDef(FPtEvt,0)>0 then
      FEvent.PtEventIFN := StrToInt(FPtEvt);
    EvtInfo := EventInfo(FPtEvt);
    FEvent.EventIFN  := StrToIntDef( Piece(EvtInfo,'^',2),0);
    if FEvent.EventIFN > 0 then
    begin
      FEvent.EventType := CharAt(Piece(EvtInfo,'^',1),1);
      FEvent.EventName := Piece(EvtInfo,'^',3);
    end;
    FDGroup := DGroupAll;
    FViewName := 'Patient event -- ' + Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,1)
       + ' on ' + grdEvtList.Cells[1,grdEvtList.Row];
  end;
end;

procedure TfrmOrdersEvntRelease.btnOKClick(Sender: TObject);
var
  EvtInfo: string;
begin
  if grdEvtList.Row < 1 then
  begin
    ShowMsg('You need to select an event first.');
    FOkPressed := False;
    Exit;
  end
  else
  begin
    if AnsiCompareText(grdEvtList.Cells[0,1],'No event order found') = 0 then
    begin
      FOKPressed := False;
      Exit;
    end;
    if FPtEvt = '' then
    begin
     FPtEvt := Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,2);
     if StrToIntDef(FPtEvt,0)>0 then
       FEvent.PtEventIFN := StrToInt(FPtEvt);
     EvtInfo := EventInfo(FPtEvt);
     FEvent.EventIFN  := StrToIntDef( Piece(EvtInfo,'^',2),0);
     if FEvent.EventIFN > 0 then
     begin
       FEvent.EventType := CharAt(Piece(EvtInfo,'^',1),1);
       FEvent.EventName := Piece(EvtInfo,'^',3);
     end;
     FDGroup := DGroupAll;
     FViewName := 'Patient event -- ' + Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,1)
        + ' on ' + grdEvtList.Cells[1,grdEvtList.Row];
     FOkPressed := True;
     Close;
    end else
    begin
     FOkPressed := True;
     Close;
    end;
  end;
end;

procedure TfrmOrdersEvntRelease.grdEvtListKeyPress(Sender: TObject;
  var Key: Char);
var
  EvtInfo: string;
begin
  if grdEvtList.Row > 0 then
  begin
    FPtEvt := Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,2);
    if StrToIntDef(FPtEvt,0)>0 then
      FEvent.PtEventIFN := StrToInt(FPtEvt);
    EvtInfo := EventInfo(FPtEvt);
    FEvent.EventIFN  := StrToIntDef( Piece(EvtInfo,'^',2),0);
    if FEvent.EventIFN > 0 then
    begin
      FEvent.EventType := CharAt(Piece(EvtInfo,'^',1),1);
      FEvent.EventName := Piece(EvtInfo,'^',3);
    end;
    FDGroup := DGroupAll;
    FViewName := 'Released orders for event--Delayed ' + Piece(grdEvtList.Cells[0,grdEvtList.Row],TAB,1)
      + ' on ' + grdEvtList.Cells[1,grdEvtList.Row];
    if Key = #13 then btnOKClick(Self);
  end;
end;

procedure TfrmOrdersEvntRelease.grdEvtListDblClick(Sender: TObject);
begin
  if grdEvtList.Row > 0 then
    btnOKClick(Self);
end;

procedure TfrmOrdersEvntRelease.pnlBottomResize(Sender: TObject);
begin
  grdEvtList.ColWidths[0] := ( grdEvtList.Width div 3 ) * 2;
  grdEvtList.ColWidths[1] := grdEvtList.Width - grdEvtList.ColWidths[0] - 4;
end;

procedure TfrmOrdersEvntRelease.ShowEvents(NumOfEvts: integer);
var
  temptot,idx,jdx: integer;
begin
  with grdEvtList do
    for idx := 0 to ColCount - 1 do
      for jdx:= 1 to RowCount - 1 do
        begin
          Cells[idx,jdx] := '';
        end;
  if NumOfEvts = 0 then  temptot := fevtList.Count
  else temptot := NumOfEvts;
  if temptot > fevtList.Count then
     temptot := fevtList.Count;
  grdEvtList.RowCount := temptot + 1;
  if temptot = 0 then
  begin
    grdEvtList.RowCount := 2;
    grdEvtList.FixedRows := 1;
    grdEvtList.Cells[0,1] := 'No event order found';
    btnOK.Enabled := False;
  end else
  begin
    for idx := 1 to grdEvtList.RowCount-1 do
    begin
      grdEvtList.Cells[0,idx] := Piece(fevtList[idx-1],'^',2)+ TAB + Piece(fevtList[idx-1],'^',1);
      grdEvtList.Cells[1,idx] := FormatFMDateTime('c',StrToFloat(Piece(fevtList[idx-1],'^',3)));
    end;
  end;
end;

procedure TfrmOrdersEvntRelease.edtNumberChange(Sender: TObject);
begin
  inherited;
  if (CharAt(edtNumber.Text,1)='A') or (CharAt(edtNumber.Text,1)='a') then
  begin
    edtNumber.Text := 'ALL';
    edtNumber.SelectAll;
    fTotal := 0;
  end
  else if (StrToIntDef(edtNumber.Text,0)=0) and (AnsiCompareText(edtNumber.Text,'all')<>0) then
    edtNumber.Text := fPreTxt
  else if StrToIntDef(edtNumber.Text,0)>0 then
    fTotal := StrtoInt(edtNumber.Text);
end;

procedure TfrmOrdersEvntRelease.edtNumberKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key=VK_RETURN then
    btnApplyClick(Self);
end;

procedure TfrmOrdersEvntRelease.btnApplyClick(Sender: TObject);
begin
  inherited;
  fPreTxt := edtNumber.Text;
  ShowEvents(fTotal);
end;

procedure TfrmOrdersEvntRelease.btnApplyKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    btnApplyClick(Self);
end;

procedure TfrmOrdersEvntRelease.edtNumberClick(Sender: TObject);
begin
  inherited;
  edtNumber.SelectAll;
end;

procedure TfrmOrdersEvntRelease.updown1Click(Sender: TObject;
  Button: TUDBtnType);
begin
  inherited;
  fTotal := updown1.Position;
  edtNumber.Text := IntToStr(updown1.Position);
  btnApplyClick(Self);
end;

procedure TfrmOrdersEvntRelease.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveUserBounds(Self);
  Action := caFree;
end;

end.

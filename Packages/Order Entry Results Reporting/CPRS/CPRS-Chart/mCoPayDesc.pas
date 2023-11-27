unit mCoPayDesc;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, UBAConst, VA508AccessibilityManager, rMisc, uConst;

type
  TfraCoPayDesc = class(TFrame)
    lblCaption: TStaticText;
    pnlSCandRD: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    lblHNC2: TVA508StaticText;
    lblHNC: TVA508StaticText;
    lblMST2: TVA508StaticText;
    lblMST: TVA508StaticText;
    lblSWAC2: TVA508StaticText;
    lblSWAC: TVA508StaticText;
    lblIR2: TVA508StaticText;
    lblIR: TVA508StaticText;
    lblAO2: TVA508StaticText;
    lblAO: TVA508StaticText;
    lblSC2: TVA508StaticText;
    lblSC: TVA508StaticText;
    lblCV2: TVA508StaticText;
    lblCV: TVA508StaticText;
    lblSHAD: TVA508StaticText;
    lblSHAD2: TVA508StaticText;
    lblCL: TVA508StaticText;
    lblCL2: TVA508StaticText;
    pnlRight: TPanel;
    gpRight: TGridPanel;
    gpMain: TGridPanel;
    pnlBorderLeft: TPanel;
    pnlBorderRight: TPanel;
    procedure lblEnter(Sender: TObject);
    procedure lblExit(Sender: TObject);
    procedure gpRightResize(Sender: TObject);
  private
    FlblWidth: array[0..1] of integer;
    procedure ConvertShortLabelsToLong;
    procedure AdjustLblGrid;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Loaded; override;
  public
    procedure ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText);
    procedure LabelCaptionsOn(CaptionsOn : Boolean = true);
    constructor Create(AOwner: TComponent); override;
    function AdjustAndGetSize: integer;
  end;

implementation

uses uGlobalVar, rPCE, UBAGlobals, VAUtils, VA508AccessibilityRouter, ORFn;

{$R *.DFM}
var
    FOSTFHintWndActive: boolean;
    FOSTFhintWindow: THintWindow;


{ TfraCoPayDesc }

constructor TfraCoPayDesc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := FALSE;
  ListSCDisabilities(memSCDisplay.Lines);
  lblSC.Hint          := BAFactorsRec.FBAFactorSC;
  lblSC2.Hint         := BAFactorsRec.FBAFactorSC;
  lblCV.Hint          := BAFactorsRec.FBAFactorCV;
  lblCV2.Hint         := BAFactorsRec.FBAFactorCV;
  lblAO.Hint          := BAFactorsRec.FBAFactorAO;
  lblAO2.Hint         := BAFactorsRec.FBAFactorAO;
  lblIR.Hint          := BAFactorsRec.FBAFactorIR;
  lblIR2.Hint         := BAFactorsRec.FBAFactorIR;
  lblSWAC.Hint        := BAFactorsRec.FBAFactorEC;
  lblSWAC2.Hint       := BAFactorsRec.FBAFactorEC;
  lblMST.Hint         := BAFactorsRec.FBAFactorMST;
  lblMST2.Hint        := BAFactorsRec.FBAFactorMST;
  lblHNC.Hint         := BAFactorsRec.FBAFactorHNC;
  lblHNC2.Hint        := BAFactorsRec.FBAFactorHNC;
  lblSHAD.Hint        := BAFactorsRec.FBAFactorSHAD;
  lblSHAD2.Hint       := BAFactorsRec.FBAFactorSHAD;
  lblCL.Visible := IsLejeuneActive;
  lblCL2.Visible := IsLejeuneActive;
  if IsLejeuneActive then
  begin
   lblCL.Hint          := BAFactorsRec.FBAFactorCL;
   lblCL2.Hint         := BAFactorsRec.FBAFactorCL;
  end
  else
    gpRight.RowCollection[8].Value := 0;

  if ScreenReaderActive then
    ConvertShortLabelsToLong;
end;

procedure TfraCoPayDesc.gpRightResize(Sender: TObject);
var
  adj: integer;

begin
  adj :=  (gpRight.Width - FlblWidth[0] - FlblWidth[1]) div 2;
  gpRight.ColumnCollection[0].Value := FlblWidth[0] + adj;
end;

procedure TfraCoPayDesc.LabelCaptionsOn(CaptionsOn: Boolean);
begin
  //Abbreviated captions
  lblSC.ShowHint := CaptionsOn;
  lblCV.ShowHint := CaptionsOn;
  lblAO.ShowHint := CaptionsOn;
  lblIR.ShowHint := CaptionsOn;
  lblSWAC.ShowHint := CaptionsOn;
  lblMST.ShowHint := CaptionsOn;
  lblHNC.ShowHint := CaptionsOn;
  lblSHAD.ShowHint := CaptionsOn;
  if IsLejeuneActive then
   lblCL.ShowHint := CaptionsOn;
  //Long captions
  lblSC2.ShowHint := CaptionsOn;
  lblCV2.ShowHint := CaptionsOn;
  lblAO2.ShowHint := CaptionsOn;
  lblIR2.ShowHint := CaptionsOn;
  lblSWAC2.ShowHint := CaptionsOn;
  lblMST2.ShowHint  := CaptionsOn;
  lblHNC2.ShowHint := CaptionsOn;
  lblSHAD2.ShowHint := CaptionsOn;
  if IsLejeuneActive then
   lblCL2.ShowHint := CaptionsOn;
end;

procedure TfraCoPayDesc.lblEnter(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [fsBold];
end;

procedure TfraCoPayDesc.lblExit(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [];
end;

procedure TfraCoPayDesc.Loaded;
begin
  inherited;
  AdjustLblGrid;
  gpRightResize(nil);
end;

function TfraCoPayDesc.AdjustAndGetSize: integer;
var
  ht, i: integer;

begin
  ht := TextHeightByFont(MainFont.Handle, 'Tg') + 2;
  lblCaption.Height := ht;
  lblSCDisplay.Height := ht;
  Result := 4;
  gpRight.RowCollection.BeginUpdate;
  try
    for i := 0 to gpRight.RowCollection.Count - 1 do
      if gpRight.RowCollection[i].Value > 0 then
      begin
        gpRight.RowCollection[i].Value := ht;
        inc(Result, ht);
      end;
  finally
    gpRight.RowCollection.EndUpdate;
  end;
  inc(Result, ht + 10);
end;

procedure TfraCoPayDesc.AdjustLblGrid;
var
  i: integer;
  item: TControlItem;
  lbl: TVA508StaticText;

begin
  FlblWidth[0] := 0;
  FlblWidth[1] := 0;
  for i := 0 to gpRight.ControlCollection.Count - 1 do
  begin
    Item := gpRight.ControlCollection[i];
    lbl := Item.Control as TVA508StaticText;
    if FlblWidth[Item.Column] < lbl.Width then
      FlblWidth[Item.Column] := lbl.Width;
  end;
  inc(FlblWidth[0], 10);
  inc(FlblWidth[1], 10);
  Constraints.MinWidth := ((FlblWidth[0] + FlblWidth[1]) * 2) + 12;
end;

procedure TfraCoPayDesc.CMFontChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    AdjustLblGrid;
end;

procedure TfraCoPayDesc.ConvertShortLabelsToLong;
begin
  lblSC2.Caption := BAFactorsRec.FBAFactorSC;
  lblCV2.Caption := BAFactorsRec.FBAFactorCV;
  lblAO2.Caption := BAFactorsRec.FBAFactorAO;
  lblIR2.Caption  := BAFactorsRec.FBAFactorIR;
  lblSWAC2.Caption := BAFactorsRec.FBAFactorEC;
  lblSHAD2.Caption := BAFactorsRec.FBAFactorSHAD;
  lblMST2.Caption := BAFactorsRec.FBAFactorMST;
  lblHNC2.Caption := BAFactorsRec.FBAFactorHNC;

  if IsLejeuneActive then
  begin
   lblCL2.Caption := BAFactorsRec.FBAFactorCL;
  end;
end;

procedure TfraCoPayDesc.ShowTreatmentFactorHints(var pHintText: string;
  var pCompName: TVA508StaticText);
var
 HRect: TRect;
 thisRect: TRect;
 x,y: integer;

begin
  try
     if FOSTFhintWndActive then
        begin
        FOSTFhintWindow.ReleaseHandle;
        FOSTFhintWndActive := False;
        end;
  except
     on E: Exception do
        begin
//        Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');
        raise;
        end;
  end;

  try
      FOSTFhintWindow := THintWindow.Create(Self);
      FOSTFhintWindow.Color := clInfoBk;
      GetWindowRect(pCompName.Handle,thisRect);
      x := thisRect.Left;
      y := thisRect.Top;
      hrect := FOSTFhintWindow.CalcHintRect(Screen.Width, pHintText,nil);
      hrect.Left   := hrect.Left + X;
      hrect.Right  := hrect.Right + X;
      hrect.Top    := hrect.Top + Y;
      hrect.Bottom := hrect.Bottom + Y;

      LabelCaptionsOn(not FOSTFHintWndActive);

      FOSTFhintWindow.ActivateHint(hrect, pHintText);
      FOSTFHintWndActive := True;
  except
     on E: Exception do
        begin
//        Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');
          raise;
        end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfraCoPayDesc);

end.

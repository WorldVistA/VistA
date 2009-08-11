unit mCoPayDesc;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ORCtrls, UBAConst, VA508AccessibilityManager;

type
  TfraCoPayDesc = class(TFrame)
    pnlRight: TPanel;
    lblCaption: TStaticText;
    pnlSCandRD: TPanel;
    lblSCDisplay: TLabel;
    memSCDisplay: TCaptionMemo;
    Spacer2: TLabel;
    pnlMain: TPanel;
    spacer1: TLabel;
    pnlHNC: TPanel;
    lblHNC2: TVA508StaticText;
    lblHNC: TVA508StaticText;
    pnlMST: TPanel;
    lblMST2: TVA508StaticText;
    lblMST: TVA508StaticText;
    pnlSWAC: TPanel;
    lblSWAC2: TVA508StaticText;
    lblSWAC: TVA508StaticText;
    pnlIR: TPanel;
    lblIR2: TVA508StaticText;
    lblIR: TVA508StaticText;
    pnlAO: TPanel;
    lblAO2: TVA508StaticText;
    lblAO: TVA508StaticText;
    pnlSC: TPanel;
    lblSC2: TVA508StaticText;
    lblSC: TVA508StaticText;
    pnlCV: TPanel;
    lblCV2: TVA508StaticText;
    lblCV: TVA508StaticText;
    pnlSHD: TPanel;
    lblSHAD: TVA508StaticText;
    lblSHAD2: TVA508StaticText;
    procedure lblEnter(Sender: TObject);
    procedure lblExit(Sender: TObject);
  private
    { Private declarations }
    procedure ConvertShortLabelsToLong;
  public
    procedure ShowTreatmentFactorHints(var pHintText: string; var pCompName: TVA508StaticText);
    procedure LabelCaptionsOn(CaptionsOn : Boolean = true);
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses rPCE, UBAGlobals, VAUtils, VA508AccessibilityRouter;

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
  if ScreenReaderActive then
    ConvertShortLabelsToLong;
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
  //Long captions
  lblSC2.ShowHint := CaptionsOn;
  lblCV2.ShowHint := CaptionsOn;
  lblAO2.ShowHint := CaptionsOn;
  lblIR2.ShowHint := CaptionsOn;
  lblSWAC2.ShowHint := CaptionsOn;
  lblMST2.ShowHint  := CaptionsOn;
  lblHNC2.ShowHint := CaptionsOn;
  lblSHAD2.ShowHint := CaptionsOn;
end;

procedure TfraCoPayDesc.lblEnter(Sender: TObject);
begin
  (Sender as TVA508StaticText).Font.Style := [fsBold];
end;

procedure TfraCoPayDesc.lblExit(Sender: TObject);
begin
    (Sender as TVA508StaticText).Font.Style := [];
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
        {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');{$endif}
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
        {$ifdef debug}Show508Message('Unhandled exception in procedure TfrmSignOrders.ShowTreatmentFactorHints()');{$endif}
        raise;
        end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfraCoPayDesc);

end.

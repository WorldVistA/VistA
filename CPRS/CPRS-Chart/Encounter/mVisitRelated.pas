unit mVisitRelated;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, rPCE, uPCE;

type
  TfraVisitRelated = class(TFrame)
    gbVisitRelatedTo: TGroupBox;
    chkSCYes: TCheckBox;
    chkAOYes: TCheckBox;
    chkIRYes: TCheckBox;
    chkECYes: TCheckBox;
    chkMSTYes: TCheckBox;
    chkMSTNo: TCheckBox;
    chkECNo: TCheckBox;
    chkIRNo: TCheckBox;
    chkAONo: TCheckBox;
    chkSCNo: TCheckBox;
    chkHNCYes: TCheckBox;
    chkHNCNo: TCheckBox;
    chkCVYes: TCheckBox;
    chkCVNo: TCheckBox;
    chkSHDYes: TCheckBox;
    chkSHDNo: TCheckBox;
    lblSCNo: TStaticText;
    lblSCYes: TStaticText;
    procedure chkClick(Sender: TObject);
  private
    FSCCond: TSCConditions;
    procedure SetCheckEnable(CheckYes, CheckNo: TCheckBox; Allow: Boolean);
    procedure SetCheckState(CheckYes, CheckNo: TCheckBox; CheckState: Integer);
    function GetCheckState(CheckYes, CheckNo: TCheckBox): Integer;

  public
    constructor Create(AOwner: TComponent); override;
    procedure GetRelated(PCEData: TPCEData); overload;
    procedure GetRelated(var ASCRelated, AAORelated, AIRRelated,
                                AECRelated, AMSTRelated, AHNCRelated, ACVRelated,ASHDRelated: integer); overload;
    procedure InitAllow(SCCond: TSCConditions);
    procedure InitRelated(PCEData: TPCEData); overload;
    procedure InitRelated(const ASCRelated, AAORelated, AIRRelated,
                                AECRelated, AMSTRelated, AHNCRelated, ACVRelated,ASHDRelated: integer); overload;

  end;

implementation

uses VA508AccessibilityRouter;

{$R *.DFM}

const
  TAG_SCYES      = 1;
  TAG_AOYES      = 2;
  TAG_IRYES      = 3;
  TAG_ECYES      = 4;
  TAG_MSTYES     = 5;
  TAG_HNCYES     = 6;
  TAG_CVYES      = 7;
  TAG_SHDYES     = 8;
  TAG_SCNO       = 11;
  TAG_AONO       = 12;
  TAG_IRNO       = 13;
  TAG_ECNO       = 14;
  TAG_MSTNO      = 15;
  TAG_HNCNO      = 16;
  TAG_CVNO       = 17;
  TAG_SHDNO      = 18;


procedure TfraVisitRelated.chkClick(Sender: TObject);

  procedure DisableCheck(ACheckBox: TCheckBox);
  begin
    ACheckBox.Checked := False; ACheckBox.Enabled := False;
  end;

begin
  inherited;
  if Sender is TCheckBox then with TCheckBox(Sender) do case Tag of
    TAG_SCYES:   if Checked then chkSCNo.Checked    := False;
    TAG_AOYES:   if Checked then chkAONo.Checked    := False;
    TAG_IRYES:   if Checked then chkIRNo.Checked    := False;
    TAG_ECYES:   if Checked then chkECNo.Checked    := False;
    TAG_MSTYES:  if Checked then chkMSTNo.Checked   := False;
    TAG_HNCYES:  if Checked then chkHNCNo.Checked   := False;
    TAG_CVYES:   if Checked then chkCVNo.Checked    := False;
    TAG_SHDYES:  if Checked then chkSHDNo.Checked   := False;
    TAG_SCNO:    if Checked then chkSCYes.Checked   := False;
    TAG_AONO:    if Checked then chkAOYes.Checked   := False;
    TAG_IRNO:    if Checked then chkIRYes.Checked   := False;
    TAG_ECNO:    if Checked then chkECYes.Checked   := False;
    TAG_MSTNO:   if Checked then chkMSTYes.Checked  := False;
    TAG_HNCNO:   if Checked then chkHNCYes.Checked  := False;
    TAG_CVNO:    if Checked then chkCVYes.Checked   := False;
    TAG_SHDNO:   if Checked then chkSHDYes.Checked := False;
  end;
  if chkSCYes.Checked then
  begin
    DisableCheck(chkAOYes);
    DisableCheck(chkIRYes);
    DisableCheck(chkECYes);
    DisableCheck(chkSHDYes);
//    DisableCheck(chkMSTYes);
    DisableCheck(chkAONo);
    DisableCheck(chkIRNo);
    DisableCheck(chkECNo);
    DisableCheck(chkSHDNo);
//    DisableCheck(chkMSTNo);
  end else
  begin
    SetCheckEnable(chkSCYes,  chkSCNo,  FSCCond.SCAllow);
    SetCheckEnable(chkAOYes,  chkAONo,  FSCCond.AOAllow);
    SetCheckEnable(chkIRYes,  chkIRNo,  FSCCond.IRAllow);
    SetCheckEnable(chkECYes,  chkECNo,  FSCCond.ECAllow);
    SetCheckEnable(chkSHDYEs, chkSHDNo, FSCCond.SHDAllow);
  end;
  SetCheckEnable(chkMSTYes, chkMSTNo, FSCCond.MSTAllow);
  SetCheckEnable(chkHNCYes, chkHNCNo, FSCCond.HNCAllow);
  SetCheckEnable(chkCVYes, chkCVNo,   FSCCond.CVAllow);

  if chkAOYes.Checked or chkIRYes.Checked or chkECYes.Checked or chkSHDYes.Checked then //or chkMSTYes.Checked then
  begin
    if FSCCond.SCAllow then
    begin
       chkSCYes.Checked := False;
       chkSCNo.Checked := True;
    end;
  end;
end;

constructor TfraVisitRelated.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := FALSE;
  lblSCYes.Height := 13;
  lblSCNo.Height := 13;
end;

function TfraVisitRelated.GetCheckState(CheckYes, CheckNo: TCheckBox): Integer;
begin
  Result := SCC_NA;
  if CheckYes.Enabled and CheckYes.Checked then Result := SCC_YES;
  if CheckNo.Enabled and CheckNo.Checked then Result := SCC_NO;
end;

procedure TfraVisitRelated.GetRelated(PCEData: TPCEData);
begin
  PCEData.SCRelated  := GetCheckState(chkSCYes,  chkSCNo);
  PCEData.AORelated  := GetCheckState(chkAOYes,  chkAONo);
  PCEData.IRRelated  := GetCheckState(chkIRYes,  chkIRNo);
  PCEData.ECRelated  := GetCheckState(chkECYes,  chkECNo);
  PCEData.MSTRelated := GetCheckState(chkMSTYes, chkMSTNo);
  PCEData.HNCRelated := GetCheckState(chkHNCYes, chkHNCNo);
  PCEData.CVRelated  := GetCheckState(chkCVYes,  chkCVNo);
  PCEData.SHADRelated := GetCheckState(chkSHDYes, chkSHDNo);
end;

procedure TfraVisitRelated.GetRelated(var ASCRelated, AAORelated,
  AIRRelated, AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHDRelated: integer);
begin
  ASCRelated  := GetCheckState(chkSCYes,  chkSCNo);
  AAORelated  := GetCheckState(chkAOYes,  chkAONo);
  AIRRelated  := GetCheckState(chkIRYes,  chkIRNo);
  AECRelated  := GetCheckState(chkECYes,  chkECNo);
  AMSTRelated := GetCheckState(chkMSTYes, chkMSTNo);
  AHNCRelated := GetCheckState(chkHNCYes, chkHNCNo);
  ACVRelated  := GetCheckState(chkCVYes,  chkCVNo);
  ASHDRelated := GetCheckState(chkSHDYes, chkSHDNo);
end;

procedure TfraVisitRelated.InitAllow(SCCond: TSCConditions);
begin
  FSCCond := SCCond;
  with FSCCond do
  begin
    SetCheckEnable(chkSCYes,  chkSCNo,  SCAllow);
    SetCheckEnable(chkAOYes,  chkAONo,  AOAllow);
    SetCheckEnable(chkIRYes,  chkIRNo,  IRAllow);
    SetCheckEnable(chkECYes,  chkECNo,  ECAllow);
    SetCheckEnable(chkMSTYes, chkMSTNo, MSTAllow);
    SetCheckEnable(chkHNCYes, chkHNCNo, HNCAllow);
    SetCheckEnable(chkCVYes,  chkCVNo,  CVAllow);
    SetCheckEnable(chkSHDYes, chkSHDNo, SHDAllow);
  end;
end;

procedure TfraVisitRelated.InitRelated(PCEData: TPCEData);
begin
  SetCheckState(chkSCYes,  chkSCNo,  PCEData.SCRelated);
  SetCheckState(chkAOYes,  chkAONo,  PCEData.AORelated);
  SetCheckState(chkIRYes,  chkIRNo,  PCEData.IRRelated);
  SetCheckState(chkECYes,  chkECNo,  PCEData.ECRelated);
  SetCheckState(chkMSTYes, chkMSTNo, PCEData.MSTRelated);
  SetCheckState(chkHNCYes, chkHNCNo, PCEData.HNCRelated);
  SetCheckState(chkCVYes,  chkCVNo,  PCEData.CVRelated);
  SetCheckState(chkSHDYes, chkSHDNo, PCEData.SHADRelated);
   //HDS00015356: GWOT Default, if Related no specified default to "Yes"
  // -1=Null, 0=No, 1 = Yes
  if FSCCond.CVAllow then
  begin
    if PCEData.CVRelated = SCC_NA then
       chkCVYes.Checked := True;
  end;
end;

procedure TfraVisitRelated.InitRelated(const ASCRelated, AAORelated, AIRRelated,
  AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHDRelated: integer);
begin
  SetCheckState(chkSCYes,  chkSCNo,  ASCRelated);
  SetCheckState(chkAOYes,  chkAONo,  AAORelated);
  SetCheckState(chkIRYes,  chkIRNo,  AIRRelated);
  SetCheckState(chkECYes,  chkECNo,  AECRelated);
  SetCheckState(chkMSTYes, chkMSTNo, AMSTRelated);
  SetCheckState(chkHNCYes, chkHNCNo, AHNCRelated);
  SetCheckState(chkCVYes,  chkCVNo,  ACVRelated);
  SetCheckState(chkSHDYes, chkSHDNo, ASHDRelated);
   //HDS00015356: GWOT Default, if Related no specified default to "Yes"
   // -1=Null, 0=No, 1 = Yes
  if FSCCond.CVAllow then
  begin
    if ACVRelated = SCC_NA then
       chkCVYes.Checked := True;
  end;
end;

procedure TfraVisitRelated.SetCheckEnable(CheckYes, CheckNo: TCheckBox;
  Allow: Boolean);
begin
  CheckYes.Enabled := Allow;
  CheckNo.Enabled := Allow;
end;

procedure TfraVisitRelated.SetCheckState(CheckYes, CheckNo: TCheckBox; CheckState: Integer);
begin
  if CheckYes.Enabled then
    case CheckState of
    SCC_NA:  begin
               CheckYes.Checked := False;
               CheckNo.Checked := False;
             end;
    SCC_NO:  begin
               CheckYes.Checked := False;
               CheckNo.Checked := True;
             end;
    SCC_YES: begin
               CheckYes.Checked := True;
               CheckNo.Checked := False;
             end;
    end; {case}
  chkClick(Self);
end;


initialization
  SpecifyFormIsNotADialog(TfraVisitRelated);

end.

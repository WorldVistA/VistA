unit mVisitRelated;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, rPCE, uPCE, VA508AccessibilityManager, uConst;

type
  tVA508Captions = record
   CheckBox: TCheckBox;
   OrigCaption: String;
   OrigWidth: Integer;
   VA508Label: TStaticText;
  end;

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
    chkCLYes: TCheckBox;
    chkCLNo: TCheckBox;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    procedure chkClick(Sender: TObject);
  private
    FSCCond: TSCConditions;
    VA508Captions: Array of tVA508Captions;
    procedure SetCheckEnable(CheckYes, CheckNo: TCheckBox; Allow: Boolean);
    procedure SetCheckState(CheckYes, CheckNo: TCheckBox; CheckState: Integer);
    function GetCheckState(CheckYes, CheckNo: TCheckBox): Integer;
    procedure HandleVA508Caption();
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetRelated(PCEData: TPCEData); overload;
    procedure GetRelated(var ASCRelated, AAORelated, AIRRelated,
                                AECRelated, AMSTRelated, AHNCRelated, ACVRelated,ASHDRelated, AClReleated: integer); overload;
    procedure InitAllow(SCCond: TSCConditions);
    procedure InitRelated(PCEData: TPCEData); overload;
    procedure InitRelated(const ASCRelated, AAORelated, AIRRelated,
                                AECRelated, AMSTRelated, AHNCRelated, ACVRelated,ASHDRelated, ACLRelated: integer); overload;

  end;

implementation

uses VA508AccessibilityRouter, VAUtils, rMisc, uGlobalVar;

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
  //Camp Lejeune
  TAG_CLYES      = 19;
  TAG_CLNO       = 20;

procedure TfraVisitRelated.chkClick(Sender: TObject);

  procedure DisableCheck(ACheckBox: TCheckBox);
  begin
    ACheckBox.Checked := False; ACheckBox.Enabled := False;
    ACheckBox.Font.Style := [];
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
    TAG_SHDNO:   if Checked then chkSHDYes.Checked  := False;
    //Camp Lejeune
    TAG_CLYES:   if Checked then chkCLNo.Checked    := False;
    TAG_CLNO:    if Checked then chkCLYes.Checked   := False;
  end;
  if chkSCYes.Checked then
  begin
    DisableCheck(chkAOYes);
    DisableCheck(chkIRYes);
    DisableCheck(chkECYes);
    DisableCheck(chkAONo);
    DisableCheck(chkIRNo);
    DisableCheck(chkECNo);
  end else
  begin
    SetCheckEnable(chkSCYes,  chkSCNo,  FSCCond.SCAllow);
    SetCheckEnable(chkAOYes,  chkAONo,  FSCCond.AOAllow);
    SetCheckEnable(chkIRYes,  chkIRNo,  FSCCond.IRAllow);
    SetCheckEnable(chkECYes,  chkECNo,  FSCCond.ECAllow);
  end;
  SetCheckEnable(chkMSTYes, chkMSTNo, FSCCond.MSTAllow);
  SetCheckEnable(chkHNCYes, chkHNCNo, FSCCond.HNCAllow);
  SetCheckEnable(chkCVYes, chkCVNo,   FSCCond.CVAllow);
  //Camp Lejeune
  if IsLejeuneActive then SetCheckEnable(chkCLYes, chkCLNo,   FSCCond.CLAllow);

  if ScreenReaderActive then
   HandleVA508Caption();

  if chkAOYes.Checked or chkIRYes.Checked or chkECYes.Checked then
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

  chkCLYes.Visible := IsLejeuneActive;
  chkCLNo.Visible := IsLejeuneActive;

end;

destructor TfraVisitRelated.Destroy;
begin
  inherited;
  SetLength(VA508Captions, 0);
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
  if IsLejeuneActive then
   PCEData.CLRelated := GetCheckState(chkCLYes, chkCLNo)
  else
   PCEData.CLRelated := SCC_NA;
end;

procedure TfraVisitRelated.GetRelated(var ASCRelated, AAORelated,
  AIRRelated, AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHDRelated, AClReleated: integer);
begin
  ASCRelated  := GetCheckState(chkSCYes,  chkSCNo);
  AAORelated  := GetCheckState(chkAOYes,  chkAONo);
  AIRRelated  := GetCheckState(chkIRYes,  chkIRNo);
  AECRelated  := GetCheckState(chkECYes,  chkECNo);
  AMSTRelated := GetCheckState(chkMSTYes, chkMSTNo);
  AHNCRelated := GetCheckState(chkHNCYes, chkHNCNo);
  ACVRelated  := GetCheckState(chkCVYes,  chkCVNo);
  ASHDRelated := GetCheckState(chkSHDYes, chkSHDNo);
  if IsLejeuneActive then
   AClReleated := GetCheckState(chkCLYes, chkCLNo)
  else
   AClReleated := SCC_NA;
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

   if ScreenReaderActive then
    HandleVA508Caption();

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
  if IsLejeuneActive then
   SetCheckState(chkCLYes, chkCLNo,   PCEData.CLRelated); //Camp lejeune
   //HDS00015356: GWOT Default, if Related no specified default to "Yes"
  // -1=Null, 0=No, 1 = Yes
  if FSCCond.CVAllow then
  begin
    if PCEData.CVRelated = SCC_NA then
       chkCVYes.Checked := True;
  end;
end;

procedure TfraVisitRelated.InitRelated(const ASCRelated, AAORelated, AIRRelated,
  AECRelated, AMSTRelated, AHNCRelated, ACVRelated, ASHDRelated, ACLRelated: integer);
begin
  SetCheckState(chkSCYes,  chkSCNo,  ASCRelated);
  SetCheckState(chkAOYes,  chkAONo,  AAORelated);
  SetCheckState(chkIRYes,  chkIRNo,  AIRRelated);
  SetCheckState(chkECYes,  chkECNo,  AECRelated);
  SetCheckState(chkMSTYes, chkMSTNo, AMSTRelated);
  SetCheckState(chkHNCYes, chkHNCNo, AHNCRelated);
  SetCheckState(chkCVYes,  chkCVNo,  ACVRelated);
  SetCheckState(chkSHDYes, chkSHDNo, ASHDRelated);
  if IsLejeuneActive then
   SetCheckState(chkCLYes,  chkCLNo,  ACLRelated);
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
  if CheckYes.Enabled and CheckNo.Enabled then CheckNo.Font.Style := [fsBold]
  else CheckNo.Font.Style := [];
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

//procedure TfraVisitRelated.HandleVA508Caption(ParentCheckBox: TCheckBox; chkEnabled: Boolean);
procedure TfraVisitRelated.HandleVA508Caption();
Var
 i,X: Integer;
 LabelExist: Boolean;
 ParentCheckBox: TCheckBox;
begin
 for x := 0 to ComponentCount -1 do
 begin
   if Components[x] is TCheckBox then
   begin
    ParentCheckBox := TCheckBox(Components[x]);

 LabelExist := False;
 for I := Low(VA508Captions) to High(VA508Captions) do
 begin
   if VA508Captions[i].CheckBox = ParentCheckBox then
   begin
    LabelExist := true;
    //Setup the caption
    if ParentCheckBox.Enabled then
    begin
     VA508Captions[i].CheckBox.Caption := VA508Captions[i].OrigCaption;
     VA508Captions[i].CheckBox.Width := VA508Captions[i].OrigWidth;
    end else begin
     VA508Captions[i].CheckBox.Caption := '';
     VA508Captions[i].CheckBox.Width := 20;
    end;
    //handle the label's visibility
    VA508Captions[i].VA508Label.Visible := not ParentCheckBox.Enabled;
    Break;
   end;
  if LabelExist then Break;
 end;


 if (not ParentCheckBox.Enabled) and (ParentCheckBox.Visible)and (not LabelExist) and (Trim(ParentCheckBox.Caption) <> '') then
 begin
  SetLength(VA508Captions, length(VA508Captions) + 1);
  with VA508Captions[High(VA508Captions)] do
  begin
   CheckBox := ParentCheckBox;
   OrigCaption := ParentCheckBox.Caption;
   OrigWidth := ParentCheckBox.Width;
   ParentCheckBox.Width := 20;
   ParentCheckBox.Caption := '';

   VA508Label := TStaticText.Create(ParentCheckBox.Owner);
   VA508Label.Parent := ParentCheckBox.Parent;
   VA508Label.Top := ParentCheckBox.Top;
   VA508Label.Left := ParentCheckBox.Left + 15;
   VA508Label.TabStop := true;
   VA508Label.Caption := Trim(OrigCaption) + ' disabled';
   VA508Label.TabOrder := ParentCheckBox.TabOrder;
   VA508Label.Visible := true;
  end;
 end;

  end;
 end;






end;


initialization
  SpecifyFormIsNotADialog(TfraVisitRelated);

end.

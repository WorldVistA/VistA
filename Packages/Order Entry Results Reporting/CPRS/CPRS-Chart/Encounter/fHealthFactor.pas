unit fHealthFactor;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  ORCtrls,
  fPCEBaseMain,
  VA508AccessibilityManager,
  U508CaptionEdit,
  U508ORComboBox;

type
  TfrmHealthFactors = class(TfrmPCEBaseMain)
    gridMagUCUMData: TGridPanel;
    pnlLevelSeverity: TPanel;
    lblHealthLevel: TLabel;
    cboHealthLevel: U508ORComboBox.TORComboBox;
    pnlUCUM: TPanel;
    lblUCUM: TLabel;
    lblUCUM2: TLabel;
    pnlMagnitude: TPanel;
    lblMag: TLabel;
    edtMag: U508CaptionEdit.TCaptionEdit;
    procedure cboHealthLevelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
    procedure Loaded; override;
  end;

implementation

{$R *.DFM}

uses
  fEncounterFrame,
  VA508AccessibilityRouter,
  uPCE,
  rPCE,
  ORFn;

procedure tfrmHealthFactors.cboHealthLevelChange(Sender: TObject);
var
  CaptionIndex: Integer;
begin
  if(NotUpdating) and (cboHealthLevel.Text <> '') then
  begin
    for CaptionIndex := 0 to lstCaptionList.Items.Count - 1 do
      if lstCaptionList.Items[CaptionIndex].Selected
        and (lstCaptionList.Objects[CaptionIndex] is TPCEHealth) then
          TPCEHealth(lstCaptionList.Objects[CaptionIndex]).Level := cboHealthLevel.ItemID;
    GridChanged;
  end;
end;

procedure TfrmHealthFactors.edtMagChange(Sender: TObject);
var
  PCEHealth: TPCEHealth;
begin
  inherited;
  if (GridIndex < 0) or (lstCaptionList.SelCount <> 1) then Exit;
  PCEHealth := lstCaptionList.Objects[GridIndex] as TPCEHealth;
  PCEHealth.Magnitude := edtMag.Text;
end;

procedure TfrmHealthFactors.edtMagExit(Sender: TObject);
begin
  inherited;
  PostValidateMag(edtMag);
end;

procedure TfrmHealthFactors.edtMagKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  ValidateMagKeyPress(Sender, Key);
end;

procedure TfrmHealthFactors.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_HlthNm;
  FPCEListCodesProc := ListHealthCodes;
  FPCEItemClass := TPCEHealth;
  FPCECode := 'HF';
  PCELoadORCombo(cboHealthLevel);
end;

procedure TfrmHealthFactors.FormShow(Sender: TObject);
begin
  grdMain.Realign; // Fixes an issue with the columns not initially adjusting
  inherited;
end;

procedure TfrmHealthFactors.Loaded;
begin
  AutoSizeDisabled := True;
  inherited Loaded;
end;

procedure TfrmHealthFactors.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumHFLevel, NoPCEValue);
end;

procedure TfrmHealthFactors.UpdateControls;
var
  HaveHealthFactors: Boolean;
  First: Boolean;
  SameHealthLevel: Boolean;
  CaptionIndex: Integer;
  HealthLevelResult: string;
  APCEHealth: TPCEHealth;
begin
  inherited;
  if NotUpdating then
  begin
    BeginUpdate;
    try
      HaveHealthFactors := lstCaptionList.SelCount > 0;
      lblHealthLevel.Enabled := HaveHealthFactors;
      cboHealthLevel.Enabled := HaveHealthFactors;

      if HaveHealthFactors then
      begin
        First := True;
        SameHealthLevel := True;
        HealthLevelResult := NoPCEValue;

        for CaptionIndex := 0 to lstCaptionList.Items.Count - 1 do
        begin
          if lstCaptionList.Items[CaptionIndex].Selected and (lstCaptionList.Objects[CaptionIndex] is TPCEHealth) then
          begin
            APCEHealth := TPCEHealth(lstCaptionList.Objects[CaptionIndex]);
            if First then
            begin
              First := False;
              HealthLevelResult := APCEHealth.Level;
            end
            else
            begin
              if SameHealthLevel then
                SameHealthLevel := HealthLevelResult = APCEHealth.Level;
            end;
          end;
        end;

        if SameHealthLevel then
          cboHealthLevel.SelectByID(HealthLevelResult)
        else
          cboHealthLevel.Text := '';
      end
      else
      begin
        cboHealthLevel.Text := '';
      end;

      HaveHealthFactors := lstCaptionList.SelCount = 1;
      lblUCUM.Caption := 'Unified Code for Units of Measure  (UCUM)';
      if HaveHealthFactors then
      begin
        APCEHealth := TPCEHealth(lstCaptionList.Objects[GridIndex]);
        ParseMagUCUMData(APCEHealth.UCUMInfo, lblMag, edtMag, lblUCUM, lblUCUM2);
        if edtMag.Visible then
        begin
          edtMag.Text := APCEHealth.Magnitude;
          amgrMain.AccessText[edtMag] := lblMag.Caption +
            ' Units are ' + lblUCUM2.Caption +
            ' Values are ' + edtMag.Hint;
        end;
      end
      else
      begin
        lblMag.Visible := False;
        edtMag.Visible := False;
        lblUCUM.Visible := False;
        lblUCUM2.Visible := False;
      end;

      if lblMag.Visible then lblMag.Top := 0; // Reposition to Top. Messed up when set to invisible;
      if not lblUCum.Visible then
      begin
        // We need the label as a spacer
        lblUCUM.Caption := ' ';
        lblUCum.Visible := True;
      end;
      lblUCum.Top := 0; // Reposition to Top. Messed up when set to invisible;

    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmHealthFactors);

end.

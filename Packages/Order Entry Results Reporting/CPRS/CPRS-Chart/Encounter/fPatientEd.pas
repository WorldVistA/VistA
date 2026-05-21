unit fPatientEd;

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
  TfrmPatientEd = class(TfrmPCEBaseMain)
    gridMagUCUMData: TGridPanel;
    pnlLevelSeverity: TPanel;
    pnlUCUM: TPanel;
    lblUCUM: TLabel;
    lblUCUM2: TLabel;
    pnlMagnitude: TPanel;
    lblMag: TLabel;
    edtMag: U508CaptionEdit.TCaptionEdit;
    lblUnderstanding: TLabel;
    cboPatUnderstanding: U508ORComboBox.TORComboBox;
    procedure cboPatUnderstandingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
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

{///////////////////////////////////////////////////////////////////////////////
//Name:procedure tfrmPatientEd.cboPatUnderstandingChange(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:Change the level of understanding assigned to the education item.
///////////////////////////////////////////////////////////////////////////////}
procedure tfrmPatientEd.cboPatUnderstandingChange(Sender: TObject);
var
  CaptionIndex: Integer;
begin
  if NotUpdating and (cboPatUnderstanding.Text <> '') then
  begin
    for CaptionIndex := 0 to lstCaptionList.Items.Count - 1 do
      if lstCaptionList.Items[CaptionIndex].Selected and (lstCaptionList.Objects[CaptionIndex] is TPCEPat) then
        TPCEPat(lstCaptionList.Objects[CaptionIndex]).Level := cboPatUnderstanding.ItemID;
    GridChanged;
  end;
end;

procedure TfrmPatientEd.edtMagChange(Sender: TObject);
var
  APCEPat: TPCEPat;
begin
  inherited;
  if (GridIndex < 0) or (lstCaptionList.SelCount <> 1) then Exit;
  APCEPat := lstCaptionList.Objects[GridIndex] as TPCEPat;
  APCEPat.Magnitude := edtMag.Text;
end;

procedure TfrmPatientEd.edtMagExit(Sender: TObject);
begin
  inherited;
  PostValidateMag(edtMag);
end;

procedure TfrmPatientEd.edtMagKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  ValidateMagKeyPress(Sender, Key);
end;

procedure TfrmPatientEd.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_PedNm;
  FPCEListCodesProc := ListPatientCodes;
  FPCEItemClass := TPCEPat;
  FPCECode := 'PED';
  PCELoadORCombo(cboPatUnderstanding);
end;

procedure TfrmPatientEd.FormShow(Sender: TObject);
begin
  grdMain.Realign; // Fixes an issue with the columns not initially adjusting
  inherited;
end;

procedure TfrmPatientEd.Loaded;
begin
  AutoSizeDisabled := True;
  inherited;
end;

procedure TfrmPatientEd.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumPEDLevel, NoPCEValue);
end;

procedure TfrmPatientEd.UpdateControls;
var
  HaveEducationItems: Boolean;
  First: Boolean;
  SameLevelOfUnderstanding: Boolean;
  CaptionIndex: Integer;
  LevelOfUnderstanding: string;
  PCEPat: TPCEPat;
begin
  inherited;
  if NotUpdating then
  begin
    BeginUpdate;
    try
      HaveEducationItems :=  lstCaptionList.SelCount > 0;
      lblUnderstanding.Enabled := HaveEducationItems;
      cboPatUnderstanding.Enabled := HaveEducationItems;

      if HaveEducationItems then
      begin
        First := True;
        SameLevelOfUnderstanding := True;
        LevelOfUnderstanding := NoPCEValue;

        for CaptionIndex := 0 to lstCaptionList.Items.Count - 1 do
        begin
          if lstCaptionList.Items[CaptionIndex].Selected and (lstCaptionList.Objects[CaptionIndex] is TPCEPat) then
          begin
            PCEPat := TPCEPat(lstCaptionList.Objects[CaptionIndex]);
            if First then
            begin
              First := False;
              LevelOfUnderstanding := PCEPat.Level;
            end
            else
            begin
              if SameLevelOfUnderstanding then
                SameLevelOfUnderstanding := LevelOfUnderstanding = PCEPat.Level;
            end;
          end;
        end;

        if SameLevelOfUnderstanding then
          cboPatUnderstanding.SelectByID(LevelOfUnderstanding)
        else
          cboPatUnderstanding.Text := '';
      end
      else
      begin
        cboPatUnderstanding.Text := '';
      end;

      HaveEducationItems := lstCaptionList.SelCount = 1;
      lblUCUM.Caption := 'Unified Code for Units of Measure  (UCUM)';
      if HaveEducationItems then
      begin
        PCEPat := TPCEPat(lstCaptionList.Objects[GridIndex]);
        ParseMagUCUMData(PCEPat.UCUMInfo, lblMag, edtMag, lblUCUM, lblUCUM2);
        if edtMag.Visible then
        begin
          edtMag.Text := PCEPat.Magnitude;
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
  SpecifyFormIsNotADialog(TfrmPatientEd);

end.

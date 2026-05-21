unit fExam;

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
  TfrmExams = class(TfrmPCEBaseMain)
    gridMagUCUMData: TGridPanel;
    pnlResult: TPanel;
    pnlUCUM: TPanel;
    lblExamResults: TLabel;
    lblUCUM: TLabel;
    cboExamResults: U508ORComboBox.TORComboBox;
    lblUCUM2: TLabel;
    pnlMagnitude: TPanel;
    lblMag: TLabel;
    edtMag: U508CaptionEdit.TCaptionEdit;
    procedure cboExamResultsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject); override;
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

procedure TfrmExams.cboExamResultsChange(Sender: TObject);
var
  CaptionIdx: Integer;
begin
  if NotUpdating and (cboExamResults.Text <> '') and
    (lstCaptionList.SelCount > 0) then
  begin
    for CaptionIdx := 0 to lstCaptionList.Items.Count - 1 do
      if lstCaptionList.Items[CaptionIdx].Selected and
        (lstCaptionList.Objects[CaptionIdx] is TPCEExams) then
        TPCEExams(lstCaptionList.Objects[CaptionIdx]).Results :=
          cboExamResults.ItemID;
    GridChanged;
  end;
end;

procedure TfrmExams.edtMagChange(Sender: TObject);
var
  APCEExams: TPCEExams;
begin
  inherited;
  if (GridIndex < 0) or (lstCaptionList.SelCount <> 1) then Exit;
  APCEExams := lstCaptionList.Objects[GridIndex] as TPCEExams;
  APCEExams.Magnitude := edtMag.Text;
end;

procedure TfrmExams.edtMagExit(Sender: TObject);
begin
  inherited;
  PostValidateMag(edtMag);
end;

procedure TfrmExams.edtMagKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  ValidateMagKeyPress(Sender, Key);
end;

procedure TfrmExams.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_XamNm;
  FPCEListCodesProc := ListExamsCodes;
  FPCEItemClass := TPCEExams;
  FPCECode := 'XAM';
  PCELoadORCombo(cboExamResults);
end;

procedure TfrmExams.FormResize(Sender: TObject);
begin
  grdMain.Realign; // Fixes an issue with the columns not initially adjusting
  inherited;
end;

procedure TfrmExams.Loaded;
begin
  AutoSizeDisabled := True;
  inherited Loaded;
end;

procedure TfrmExams.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumExamResults, NoPCEValue);
end;

procedure TfrmExams.UpdateControls;
var
  HaveCaptions: Boolean;
  First: Boolean;
  SameResult: Boolean;
  CaptionIndex: Integer;
  ExamResult: string;
  APCEExams: TPCEExams;
begin
  inherited;
  if NotUpdating then
  begin
    BeginUpdate;
    try
      HaveCaptions := lstCaptionList.SelCount > 0;
      lblExamResults.Enabled := HaveCaptions;
      cboExamResults.Enabled := HaveCaptions;

      if HaveCaptions then
      begin
        First := True;
        SameResult := True;
        ExamResult := NoPCEValue;

        for CaptionIndex := 0 to lstCaptionList.Items.Count - 1 do
        begin
          if lstCaptionList.Items[CaptionIndex].Selected then
          begin
            if not (lstCaptionList.Objects[CaptionIndex] is TPCEExams) then
              Continue;
            APCEExams := TPCEExams(lstCaptionList.Objects[CaptionIndex]);
            if First then
            begin
              First := False;
              ExamResult := APCEExams.Results;
            end
            else
            begin
              if SameResult then
                SameResult := ExamResult = APCEExams.Results;
            end;
          end;
        end;

        if SameResult then
          cboExamResults.SelectByID(ExamResult)
        else
          cboExamResults.Text := '';
      end
      else
      begin
        cboExamResults.Text := '';
      end;

      HaveCaptions := lstCaptionList.SelCount = 1;
      lblUCUM.Caption := 'Unified Code for Units of Measure  (UCUM)';
      if HaveCaptions then
      begin
        APCEExams := TPCEExams(lstCaptionList.Objects[GridIndex]);
        ParseMagUCUMData(APCEExams.UCUMInfo, lblMag, edtMag, lblUCUM, lblUCUM2);
        if edtMag.Visible then
        begin
          edtMag.Text := APCEExams.Magnitude;
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
  SpecifyFormIsNotADialog(TfrmExams);

end.

unit fExam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmExams = class(TfrmPCEBaseMain)
    lblExamResults: TLabel;
    cboExamResults: TORComboBox;
    lblUCUM2: TLabel;
    lblUCUM: TLabel;
    edtMag: TCaptionEdit;
    lblMag: TLabel;
    procedure cboExamResultsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
  private
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public   
  end;

var
  frmExams: TfrmExams;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, uMisc;

procedure TfrmExams.cboExamResultsChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboExamResults.Text <> '') and (lstCaptionList.SelCount > 0) then
  begin
    for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) and (lstCaptionList.Objects[i] is TPCEExams) then
        TPCEExams(lstCaptionList.Objects[i]).Results := cboExamResults.ItemID;
    GridChanged;
  end;
end;

procedure TfrmExams.edtMagChange(Sender: TObject);
var
 item: TPCEExams;

begin
  inherited;
  if (GridIndex<0) or (lstCaptionList.SelCount <> 1) then exit;
  item := lstCaptionList.Objects[GridIndex] as TPCEExams;
  item.Magnitude := edtMag.Text;
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

procedure TfrmExams.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumExamResults, NoPCEValue);
end;

procedure TfrmExams.UpdateControls;
var
  ok, First: boolean;
  SameR: boolean;
  i: integer;
  Res: string;
  Obj: TPCEExams;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
      lblExamResults.Enabled := ok;
      cboExamResults.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameR := TRUE;
        Res := NoPCEValue;

        for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected then
          begin
            if not (lstCaptionList.Objects[i] is TPCEExams) then
              continue;
            Obj := TPCEExams(lstCaptionList.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Res := Obj.Results;
            end
            else
            begin
              if(SameR) then
                SameR := (Res = Obj.Results);
            end;
          end;
        end;

        if(SameR) then
          cboExamResults.SelectByID(Res)
        else
          cboExamResults.Text := '';
      end
      else
      begin
        cboExamResults.Text := '';
      end;

      ok := (lstCaptionList.SelCount = 1);
      if(ok) then
      begin
        Obj := TPCEExams(lstCaptionList.Objects[GridIndex]);
        ParseMagUCUMData(Obj.UCUMInfo, lblMag, edtMag, lblUCUM, lblUCUM2);
        if edtMag.Visible then
          edtMag.Text := Obj.Magnitude;
      end
      else
      begin
        lblMag.Visible := False;
        edtMag.Visible := False;
        lblUCUM.Visible := False;
        lblUCUM2.Visible := False;
      end;

    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmExams);

end.


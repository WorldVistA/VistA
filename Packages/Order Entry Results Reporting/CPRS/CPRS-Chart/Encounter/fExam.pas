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
    procedure cboExamResultsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  fEncounterFrame, VA508AccessibilityRouter;

procedure TfrmExams.cboExamResultsChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboExamResults.Text <> '') then
  begin
    TPCEExams(lstRenameMe.Objects[lstRenameMe.Selected.Index]).Results := cboExamResults.ItemID;

    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEExams(lstRenameMe.Objects[lstRenameMe.Selected.Index]).Results := cboExamResults.ItemID;

    GridChanged;
  end;
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
      ok := (lstRenameMe.SelCount > 0);
      lblExamResults.Enabled := ok;
      cboExamResults.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameR := TRUE;
        Res := NoPCEValue;

        for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCEExams(lstRenameMe.Objects[i]);
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
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmExams);

end.


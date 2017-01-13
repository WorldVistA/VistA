unit fImmunization;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmImmunizations = class(TfrmPCEBaseMain)
    lblReaction: TLabel;
    lblSeries: TLabel;
    cboImmReaction: TORComboBox;
    cboImmSeries: TORComboBox;
    ckbContra: TCheckBox;
    lblContra: TLabel;

    procedure cboImmSeriesChange(Sender: TObject);
    procedure cboImmReactionChange(Sender: TObject);
    procedure ckbContraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ckbContraEnter(Sender: TObject);
    procedure ckbContraExit(Sender: TObject);
  private
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
//    procedure ChangeProvider;
  end;

var
  frmImmunizations: TfrmImmunizations;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter;

procedure TfrmImmunizations.cboImmSeriesChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboImmSeries.Text <> '') then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEImm(lstRenameMe.Objects[i]).Series := cboImmSeries.ItemID;
    GridChanged;
  end;
end;

procedure TfrmImmunizations.cboImmReactionChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboImmReaction.Text <> '') then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEImm(lstRenameMe.Objects[i]).Reaction := cboImmReaction.ItemID;
    GridChanged;
  end;
end;

procedure TfrmImmunizations.ckbContraClick(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEImm(lstRenameMe.Objects[i]).Contraindicated := ckbContra.Checked;
    GridChanged;
  end;
end;

procedure TfrmImmunizations.ckbContraEnter(Sender: TObject);
begin
  inherited;
  frmImmunizations.Invalidate;
end;

procedure TfrmImmunizations.ckbContraExit(Sender: TObject);
begin
  inherited;
  frmImmunizations.Invalidate;
end;

procedure TfrmImmunizations.FormCreate(Sender: TObject);
begin
  inherited;
  FTabName := CT_ImmNm;
  FPCEListCodesProc := ListImmunizCodes;
  FPCEItemClass := TPCEImm;
  FPCECode := 'IMM';
  PCELoadORCombo(cboImmReaction);
  PCELoadORCombo(cboImmSeries);
end;

procedure TfrmImmunizations.FormPaint(Sender: TObject);
begin
inherited;
  if ckbContra.Focused = True then
  begin
    frmImmunizations.Canvas.Pen.Width := 1;
    frmImmunizations.Canvas.Pen.Style := psDot;
    frmImmunizations.Canvas.MoveTo(lblContra.Left - 2,lblContra.Top - 1);
    frmImmunizations.Canvas.LineTo(lblContra.Left + lblContra.Width + 2,lblContra.Top - 1);
    frmImmunizations.Canvas.LineTo(lblContra.Left + lblContra.Width + 2,lblContra.Top + lblContra.Height);
    frmImmunizations.Canvas.LineTo(lblContra.Left - 2,lblContra.Top + lblContra.Height);
    frmImmunizations.Canvas.LineTo(lblContra.Left - 2,lblContra.Top - 1);
  end;
end;

procedure TfrmImmunizations.UpdateNewItemStr(var x: string);
begin
  inherited;
  SetPiece(x, U, pnumImmSeries, NoPCEValue);
  SetPiece(x, U, pnumImmReaction, NoPCEValue);
  SetPiece(x, U, pnumImmRefused, '0');
  SetPiece(x, U, pnumImmContra, '0');
end;

procedure TfrmImmunizations.UpdateControls;
var
  ok, Contra, First: boolean;
  SameS, SameR, SameC: boolean;
  i: integer;
  Ser, React: string;
  Obj: TPCEImm;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstRenameMe.SelCount > 0);
      lblSeries.Enabled := ok;
      lblReaction.Enabled := ok;
      cboImmSeries.Enabled := ok;
      cboImmReaction.Enabled := ok;
      ckbContra.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameS := TRUE;
        SameR := TRUE;
        SameC := TRUE;
        Contra := FALSE;
        Ser := NoPCEValue;
        React := NoPCEValue;
        for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCEImm(lstRenameMe.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              Contra := Obj.Contraindicated;
              Ser := Obj.Series;
              React := Obj.Reaction;
            end
            else
            begin
              if(SameS) then
                SameS := (Ser = Obj.Series);
              if(SameR) then
                SameR := (React = Obj.Reaction);
              if(SameC) then
                SameC := (Contra = Obj.Contraindicated);
            end;
          end;
        end;
        if(SameS) then
          cboImmSeries.SelectByID(Ser)
        else
          cboImmSeries.Text := '';
        if(SameR) then
          cboImmReaction.SelectByID(React)
        else
          cboImmReaction.Text := '';
        if(SameC) then
          ckbContra.Checked := Contra
        else
          ckbContra.State := cbGrayed;
      end
      else
      begin
        cboImmSeries.Text := '';
        cboImmReaction.Text := '';
        ckbContra.Checked := FALSE;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmImmunizations);

end.

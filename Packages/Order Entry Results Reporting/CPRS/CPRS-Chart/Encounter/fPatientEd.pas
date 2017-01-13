unit fPatientEd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmPatientEd = class(TfrmPCEBaseMain)
    lblUnderstanding: TLabel;
    cboPatUnderstanding: TORComboBox;
    procedure cboPatUnderstandingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

var
  frmPatientEd: TfrmPatientEd;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter;

{///////////////////////////////////////////////////////////////////////////////
//Name:procedure tfrmPatientEd.cboPatUnderstandingChange(Sender: TObject);
//Created: Jan 1999
//By: Robert Bott
//Location: ISL
//Description:Change the level of understanding assigned to the education item.
///////////////////////////////////////////////////////////////////////////////}
procedure tfrmPatientEd.cboPatUnderstandingChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboPatUnderstanding.Text <> '') then
  begin
     for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEPat(lstRenameMe.Objects[i]).Level := cboPatUnderstanding.ItemID;

    GridChanged;
  end;
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

procedure TfrmPatientEd.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumPEDLevel, NoPCEValue);
end;

procedure TfrmPatientEd.UpdateControls;
var
  ok, First: boolean;
  SameLOU: boolean;
  i: integer;
  LOU: string;
  Obj: TPCEPat;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstRenameMe.SelCount > 0);
      lblUnderstanding.Enabled := ok;
      cboPatUnderstanding.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameLOU := TRUE;
        LOU := NoPCEValue;

       for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCEPat(lstRenameMe.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              LOU := Obj.Level;
            end
            else
            begin
              if(SameLOU) then
                SameLOU := (LOU = Obj.Level);
            end;
          end;
        end;
      
        if(SameLOU) then
          cboPatUnderstanding.SelectByID(LOU)
        else
          cboPatUnderstanding.Text := '';
      end
      else
      begin
        cboPatUnderstanding.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmPatientEd);

end.

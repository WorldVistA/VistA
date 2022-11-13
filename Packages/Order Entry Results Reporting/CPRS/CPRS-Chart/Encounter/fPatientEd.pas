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
    edtMag: TCaptionEdit;
    lblUCUM2: TLabel;
    lblUCUM: TLabel;
    lblMag: TLabel;
    procedure cboPatUnderstandingChange(Sender: TObject);
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
  frmPatientEd: TfrmPatientEd;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, uMisc;

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
     for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) and (lstCaptionList.Objects[i] is TPCEPat) then
        TPCEPat(lstCaptionList.Objects[i]).Level := cboPatUnderstanding.ItemID;
    GridChanged;
  end;
end;

procedure TfrmPatientEd.edtMagChange(Sender: TObject);
var
 item: TPCEPat;

begin
  inherited;
  if (GridIndex<0) or (lstCaptionList.SelCount <> 1) then exit;
  item := lstCaptionList.Objects[GridIndex] as TPCEPat;
  item.Magnitude := edtMag.Text;
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
      ok := (lstCaptionList.SelCount > 0);
      lblUnderstanding.Enabled := ok;
      cboPatUnderstanding.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameLOU := TRUE;
        LOU := NoPCEValue;

       for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected and (lstCaptionList.Objects[i] is TPCEPat) then
          begin
            Obj := TPCEPat(lstCaptionList.Objects[i]);
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

      ok := (lstCaptionList.SelCount = 1);
      if(ok) then
      begin
        Obj := TPCEPat(lstCaptionList.Objects[GridIndex]);
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
  SpecifyFormIsNotADialog(TfrmPatientEd);

end.

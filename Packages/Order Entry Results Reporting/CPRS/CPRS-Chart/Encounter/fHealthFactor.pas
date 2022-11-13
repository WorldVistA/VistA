unit fHealthFactor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, ORCtrls, CheckLst, ExtCtrls, Buttons, uPCE, rPCE, ORFn,
  fPCELex, fPCEOther, ComCtrls, fPCEBaseMain, VA508AccessibilityManager;

type
  TfrmHealthFactors = class(TfrmPCEBaseMain)
    lblHealthLevel: TLabel;
    cboHealthLevel: TORComboBox;
    lblMag: TLabel;
    lblUCUM: TLabel;
    edtMag: TCaptionEdit;
    lblUCUM2: TLabel;

    procedure cboHealthLevelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtMagKeyPress(Sender: TObject; var Key: Char);
    procedure edtMagChange(Sender: TObject);
    procedure edtMagExit(Sender: TObject);
  private
  protected
    procedure UpdateNewItemStr(var x: string); override;
    procedure UpdateControls; override;
  public
  end;

var
  frmHealthFactors: TfrmHealthFactors;

implementation

{$R *.DFM}

uses
  fEncounterFrame, VA508AccessibilityRouter, uMisc;

procedure tfrmHealthFactors.cboHealthLevelChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboHealthLevel.Text <> '') then
  begin
    for i := 0 to lstCaptionList.Items.Count-1 do
      if(lstCaptionList.Items[i].Selected) and (lstCaptionList.Objects[i] is TPCEHealth) then
        TPCEHealth(lstCaptionList.Objects[i]).Level := cboHealthLevel.ItemID;
    GridChanged;
  end;
end;

procedure TfrmHealthFactors.edtMagChange(Sender: TObject);
var
 item: TPCEHealth;

begin
  inherited;
  if (GridIndex<0) or (lstCaptionList.SelCount <> 1) then exit;
  item := lstCaptionList.Objects[GridIndex] as TPCEHealth;
  item.Magnitude := edtMag.Text;
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

procedure TfrmHealthFactors.UpdateNewItemStr(var x: string);
begin
  SetPiece(x, U, pnumHFLevel, NoPCEValue);
end;

procedure TfrmHealthFactors.UpdateControls;
var
  ok, First: boolean;
  SameHL: boolean;
  i: integer;
  HL: string;
  Obj: TPCEHealth;

begin
  inherited;
  if(NotUpdating) then
  begin
    BeginUpdate;
    try
      ok := (lstCaptionList.SelCount > 0);
      lblHealthLevel.Enabled := ok;
      cboHealthLevel.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameHL := TRUE;
        HL := NoPCEValue;

        for i := 0 to lstCaptionList.Items.Count-1 do
        begin
          if lstCaptionList.Items[i].Selected and (lstCaptionList.Objects[i] is TPCEHealth) then
          begin
            Obj := TPCEHealth(lstCaptionList.Objects[i]);
            if(First) then
            begin
              First := FALSE;
              HL := Obj.Level;
            end
            else
            begin
              if(SameHL) then
                SameHL := (HL = Obj.Level);
            end;
          end;
        end;

        if(SameHL) then
          cboHealthLevel.SelectByID(HL)
        else
          cboHealthLevel.Text := '';
      end
      else
        cboHealthLevel.Text := '';

      ok := (lstCaptionList.SelCount = 1);
      if ok then
      begin
        Obj := TPCEHealth(lstCaptionList.Objects[GridIndex]);
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
  SpecifyFormIsNotADialog(TfrmHealthFactors);

end.

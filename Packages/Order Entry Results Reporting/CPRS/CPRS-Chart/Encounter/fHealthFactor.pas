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

    procedure cboHealthLevelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  fEncounterFrame, VA508AccessibilityRouter;

procedure tfrmHealthFactors.cboHealthLevelChange(Sender: TObject);
var
  i: integer;

begin
  if(NotUpdating) and (cboHealthLevel.Text <> '') then
  begin
    for i := 0 to lstRenameMe.Items.Count-1 do
      if(lstRenameMe.Items[i].Selected) then
        TPCEPat(lstRenameMe.Objects[i]).Level := cboHealthLevel.ItemID;
    GridChanged;
  end;
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
      ok := (lstRenameMe.SelCount > 0);
      lblHealthLevel.Enabled := ok;
      cboHealthLevel.Enabled := ok;
      if(ok) then
      begin
        First := TRUE;
        SameHL := TRUE;
        HL := NoPCEValue;

        for i := 0 to lstRenameMe.Items.Count-1 do
        begin
          if lstRenameMe.Items[i].Selected then
          begin
            Obj := TPCEHealth(lstRenameMe.Objects[i]);
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
      begin
        cboHealthLevel.Text := '';
      end;
    finally
      EndUpdate;
    end;
  end;
end;

initialization
  SpecifyFormIsNotADialog(TfrmHealthFactors);

end.

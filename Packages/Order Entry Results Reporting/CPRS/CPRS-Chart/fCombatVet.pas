unit fCombatVet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fBase508Form, StdCtrls, VA508AccessibilityManager, Buttons,
  ExtCtrls;
const
  clCPRSYellow = TColor($01C9FF);  //Blue 1 Green 201 Red 255
  clCPRSRed = TColor($2F01C1);  //Blue 47 Green 1 Red 193
  clCPRSBlue = TColor($914F01);  //Blue 145 Green 79 Red 1

type
  TfrmCombatVet = class(TfrmBase508Form)
    pnlTop: TPanel;
    BitBtn1: TBitBtn;
    edtServiceBranch: TEdit;
    edtStatus: TEdit;
    edtSeparationDate: TEdit;
    edtExpireDate: TEdit;
    edtOEF_OIF: TEdit;
    lblServiceBranch: TLabel;
    lblStatus: TLabel;
    lblSepDate: TLabel;
    lblExpireDate: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCombatVet: TfrmCombatVet;

implementation

{$R *.dfm}

uses uCore, ORFn;

procedure TfrmCombatVet.FormShow(Sender: TObject);
const
  FONTFACTOR = 2; //WAT - edit control height wasn't increasing as font size increased
begin
  inherited;
  ResizeFormToFont(Self);
  edtServiceBranch.Text := Patient.CombatVet.ServiceBranch;
  edtStatus.Text := Patient.CombatVet.Status;
  edtSeparationDate.Text := Patient.CombatVet.ServiceSeparationDate;
  edtExpireDate.Text := Patient.CombatVet.ExpirationDate;
  edtOEF_OIF.Text := Patient.CombatVet.OEF_OIF;
  //WAT
  edtServiceBranch.Height := Round(FONTFACTOR * MainFontWidth);
  edtStatus.Height := Round(FONTFACTOR * MainFontWidth);
  edtSeparationDate.Height := Round(FONTFACTOR * MainFontWidth);
  edtExpireDate.Height := Round(FONTFACTOR * MainFontWidth);
  if edtOEF_OIF.GetTextLen > 0 then  edtOEF_OIF.Height := Round(FONTFACTOR * MainFontWidth);
  BitBtn1.Height := BitBtn1.Height + MainFontWidth;
  BitBtn1.Width := BitBtn1.Width + MainFontWidth;
  //WAT
end;

end.

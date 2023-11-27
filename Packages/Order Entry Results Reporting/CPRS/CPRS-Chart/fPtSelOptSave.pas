unit fPtSelOptSave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, fBase508Form, VA508AccessibilityManager;

type
  TfrmPtSelOptSave = class(TfrmBase508Form)
    pnlClinSave: TPanel;
    rGrpClinSave: TKeyClickRadioGroup;
    lblClinSettings: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure rGrpClinSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPtSelOptSave: TfrmPtSelOptSave;

implementation

{$R *.DFM}

uses
  rCore, mPtSelOptns;

procedure TfrmPtSelOptSave.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  self.caption := 'Save Patient List Settings';
  mPtSelOptns.clinDoSave := false; // Initialize.
  mPtSelOptns.clinSaveToday := false;
  lblClinSettings.text := 'Save ' + mPtSelOptns.clinDefaults +
                             CRLF + ' defaults as follows?';
  rGrpClinSave.itemIndex := -1;
//  rGrpClinSave.TabStop := True;
  btnOK.Enabled := False;
end;

procedure TfrmPtSelOptSave.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPtSelOptSave.btnOKClick(Sender: TObject);
begin

if ((rGrpClinSave.itemIndex < 0) or (rGrpClinSave.itemIndex >1)) then
  begin
    InfoBox('No selection made', 'Clinic Save Options', MB_OK);
    exit;
  end;
  if (rGrpClinSave.itemIndex = 0) then
    mPtSelOptns.clinSaveToday := false;
  if (rGrpClinSave.itemIndex = 1) then
    mPtSelOptns.clinSaveToday := true;
  mPtSelOptns.clinDoSave := true;
close;

end;

procedure TfrmPtSelOptSave.rGrpClinSaveClick(Sender: TObject);
var
  Chosen: Boolean;
begin
  Chosen := rGrpClinSave.ItemIndex >= 0;
//  rGrpClinSave.TabStop := not Chosen;
  btnOK.Enabled := Chosen;
end;

end.

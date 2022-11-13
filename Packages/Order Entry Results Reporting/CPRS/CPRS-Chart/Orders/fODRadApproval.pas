unit fODRadApproval;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ORCtrls, ORfn, ExtCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmODRadApproval = class(TfrmBase508Form)
    cmdOK: TButton;
    cmdCancel: TButton;
    cboRadiologist: TORComboBox;
    SrcLabel: TLabel;
    pnlBase: TORAutoPanel;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FRadiologist: string ;
    FChanged: Boolean;
  end;

procedure SelectApprovingRadiologist(FontSize: Integer; var Radiologist: string) ;

implementation

{$R *.DFM}

uses rODRad, rCore, uCore;

const
  TX_RAD_TEXT = 'Select radiologist or press Cancel.';
  TX_RAD_CAP = 'No Radiologist Selected';

procedure SelectApprovingRadiologist(FontSize: Integer; var Radiologist: string);
{ displays radiologist selection form and returns a record of the selection }
var
  frmODRadApproval: TfrmODRadApproval;
  W, H: Integer;
begin
  frmODRadApproval := TfrmODRadApproval.Create(Application);
  try
    with frmODRadApproval do
    begin
      Font.Size := FontSize;
      W := ClientWidth;
      H := ClientHeight;
      ResizeToFont(FontSize, W, H);
      ClientWidth  := W; pnlBase.Width  := W;
      ClientHeight := H; pnlBase.Height := H;
      FChanged := False;
      SubsetOfRadiologists(cboRadiologist.Items);
      ShowModal;
      Radiologist := FRadiologist ;
    end; {with frmODRadApproval}
  finally
    frmODRadApproval.Release;
  end;
end;

procedure TfrmODRadApproval.cmdCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmODRadApproval.cmdOKClick(Sender: TObject);
begin
  if cboRadiologist.ItemIEN = 0 then
  begin
    InfoBox(TX_RAD_TEXT, TX_RAD_CAP, MB_OK or MB_ICONWARNING);
    FChanged := False ;
    Exit;
  end;
  FChanged := True;
  FRadiologist := cboRadiologist.Items[cboRadiologist.ItemIndex] ;
  Close;
end;

end.

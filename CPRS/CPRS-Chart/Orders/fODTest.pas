unit fODTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fODBase, ComCtrls, ExtCtrls, StdCtrls, ORCtrls, Mask, RZDebug;

type
  TfrmODTest = class(TfrmODBase)
    lblMedication: TLabel;
    cboMedAlt: TORComboBox;
    cboMedication: TORComboBox;
    lblDosage: TLabel;
    cboInstructions: TORComboBox;
    lblRoute: TLabel;
    cboRoute: TORComboBox;
    lblSchedule: TLabel;
    cboSchedule: TORComboBox;
    lblQuantity: TLabel;
    txtQuantity: TEdit;
    lblRefills: TLabel;
    txtRefills: TMaskEdit;
    spnRefills: TUpDown;
    lblPickup: TLabel;
    cboPickup: TORComboBox;
    lblSC: TLabel;
    cboSC: TORComboBox;
    Label1: TLabel;
    cboPriority: TORComboBox;
    Label2: TLabel;
    memComments: TMemo;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmODTest: TfrmODTest;

implementation

{$R *.DFM}

procedure TfrmODTest.Timer1Timer(Sender: TObject);
var
  AControl: TControl;
begin
  inherited;
  AControl := GetCaptureControl;
  if AControl <> nil then Writeln(AControl.Name) else Writeln('nil');
end;

end.

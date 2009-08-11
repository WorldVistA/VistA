unit tfVType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, fBase508Form;

type
  TfrmLaunch = class(TfrmBase508Form)
    grpFontSize: TRadioGroup;
    cmdShow: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    cmdClose: TButton;
    procedure cmdShowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLaunch: TfrmLaunch;

implementation

{$R *.DFM}

uses ORFn, ORNet, fVType, uCore;

procedure TfrmLaunch.FormCreate(Sender: TObject);
begin
  if not ConnectToServer('OR CPRS GUI CHART') then
  begin
    Close;     // need a way to exit without needing the broker (close may call it)
    Exit;
  end;
  User    := TUser.Create;                   // creates the user object defined in uCore
  Patient := TPatient.Create;                // creates the patient object defined in uCore
  Encounter := TEncounter.Create;            // creates the encounter object defined in uCore
  Encounter.Location := 16;
end;

procedure TfrmLaunch.cmdShowClick(Sender: TObject);
begin
  case grpFontSize.ItemIndex of
  0: Self.Font.Size := 8;
  1: Self.Font.Size := 10;
  2: Self.Font.Size := 12;
  3: Self.Font.Size := 14;
  4: Self.Font.Size := 18;
  end;
  UpdateVisitType;
  //Edit1.Text := IntToStr(Patient.DFN) + U + Patient.Name + U + Encounter.LocationName;
end;

procedure TfrmLaunch.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

end.

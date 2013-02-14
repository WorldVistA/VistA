unit fPtSens;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, fBase508Form, VA508AccessibilityManager;

type
  TfrmPtSens = class(TfrmBase508Form)
    imgWarning: TImage;
    memWarning: TMemo;
    cmdYes: TButton;
    cmdNo: TButton;
    lblContinue: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure cmdYesClick(Sender: TObject);
    procedure cmdNoClick(Sender: TObject);
  private
    FContinue: Boolean;
  public
    { Public declarations }
  end;

function RestrictedPtWarning: Boolean;

implementation

{$R *.DFM}

function RestrictedPtWarning: Boolean;
var
  frmPtSens: TfrmPtSens;
begin
  frmPtSens := TfrmPtSens.Create(Application);
  try
    frmPtSens.ShowModal;
    Result := frmPtSens.FContinue;
  finally
    frmPtSens.Free;
  end;
end;

procedure TfrmPtSens.FormCreate(Sender: TObject);
begin
  FContinue := False;
  imgWarning.Picture.Icon.Handle := LoadIcon(0, IDI_EXCLAMATION);
end;

procedure TfrmPtSens.cmdYesClick(Sender: TObject);
begin
  FContinue := True;
  Close;
end;

procedure TfrmPtSens.cmdNoClick(Sender: TObject);
begin
  FContinue := False;
  Close;
end;

end.

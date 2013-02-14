unit fVitalsDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORDtTm, fBase508Form, VA508AccessibilityManager;

type
  TfrmVitalsDate = class(TfrmBase508Form)
    dteVitals: TORDateBox;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    btnNow: TButton;
    procedure btnNowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVitalsDate: TfrmVitalsDate;

implementation

{$R *.DFM}

uses
  ORFn;
  
procedure TfrmVitalsDate.btnNowClick(Sender: TObject);
begin
  dteVitals.Text := 'NOW';
end;

procedure TfrmVitalsDate.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(Self);
end;

end.

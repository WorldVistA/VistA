unit fRemVisitInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mVisitRelated, ORDtTm,fBase508Form, VA508AccessibilityManager;

type
  TfrmRemVisitInfo = class(TfrmBase508Form)
    fraVisitRelated: TfraVisitRelated;
    btnOK: TButton;
    btnCancel: TButton;
    dteVitals: TORDateBox;
    lblVital: TLabel;
    btnNow: TButton;
    procedure btnNowClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  ORFn;
  
procedure TfrmRemVisitInfo.btnNowClick(Sender: TObject);
begin
  dteVitals.Text := 'NOW';
end;

procedure TfrmRemVisitInfo.FormCreate(Sender: TObject);
begin
  ResizeAnchoredFormToFont(self);
  btnOK.Top := fraVisitRelated.Top + fraVisitRelated.Height;
  btnCancel.Top := btnOK.Top;
end;

end.

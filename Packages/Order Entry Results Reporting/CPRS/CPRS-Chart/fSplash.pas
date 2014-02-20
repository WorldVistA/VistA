unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmSplash = class(TfrmBase508Form)
    pnlMain: TPanel;
    lblVersion: TStaticText;
    lblCopyright: TStaticText;
    pnlImage: TPanel;
    Image1: TImage;
    lblSplash: TStaticText;
    pnl508Disclaimer: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

uses VAUtils;

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := 'version ' +
                        FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblSplash.Caption := lblSplash.Caption + ' ' + lblVersion.Caption;
  lblSplash.Invalidate;
end;

end.

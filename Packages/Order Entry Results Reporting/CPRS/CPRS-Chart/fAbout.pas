unit fAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, StdCtrls, ExtCtrls, VA508AccessibilityManager;

type
  TfrmAbout = class(TfrmAutoSz)
    pnlLogo: TPanel;
    Image1: TImage;
    lblProductName: TStaticText;
    lblFileVersion: TStaticText;
    lblCompanyName: TStaticText;
    lblComments: TStaticText;
    lblCRC: TStaticText;
    lblInternalName: TStaticText;
    lblOriginalFileName: TStaticText;
    pnlBottom: TPanel;
    pnlButton: TPanel;
    cmdOK: TButton;
    pnlCopyright: TPanel;
    lblLegalCopyright: TMemo;
    pnl508Disclaimer: TPanel;
    lbl508Notice: TMemo;
    pnlInfo: TPanel;
    pnlTop: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAbout;

implementation

{$R *.DFM}

uses VAUtils, ORFn;

procedure ShowAbout;
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    ResizeFormToFont(TForm(frmAbout));
    frmAbout.lblProductName.Font.Size := frmAbout.lblLegalCopyright.Font.Size + 4;
    frmAbout.lblLegalCopyright.SelStart := 0;
    frmAbout.lblLegalCopyright.SelLength := 0;
    frmAbout.lbl508Notice.SelStart := 0;
    frmAbout.lbl508Notice.SelLength := 0;
    frmAbout.ShowModal;
  finally
    frmAbout.Release;
  end;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  inherited;
  lblProductName.Caption        := FileVersionValue(Application.ExeName, FILE_VER_PRODUCTNAME);
  lblFileVersion.Caption        := FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblComments.Caption           := FileVersionValue(Application.ExeName, FILE_VER_COMMENTS);  // version comment
  lblInternalName.Caption       := FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME);
  lblCompanyName.Caption        := 'Developed by the ' + FileVersionValue(Application.ExeName, FILE_VER_COMPANYNAME);
  lblOriginalFileName.Caption   := FileVersionValue(Application.ExeName, FILE_VER_ORIGINALFILENAME);  //patch
  lblCRC.Caption                := 'CRC: ' + IntToHex(CRCForFile(Application.ExeName), 8);
  lblLegalCopyright.Text        := FileVersionValue(Application.ExeName, FILE_VER_LEGALCOPYRIGHT);
end;

end.

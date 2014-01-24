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
    lblFileDescription: TStaticText;
    lblInternalName: TStaticText;
    lblOriginalFileName: TStaticText;
    pnlBottom: TPanel;
    pnlButton: TPanel;
    cmdOK: TButton;
    pnlCopyright: TPanel;
    lblLegalCopyright: TMemo;
    pnl508Disclaimer: TPanel;
    lbl508Notice: TMemo;
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
  lblCompanyName.Caption        := 'Developed by the ' + FileVersionValue(Application.ExeName, FILE_VER_COMPANYNAME);
  lblFileDescription.Caption    := 'Compiled ' + FileVersionValue(Application.ExeName, FILE_VER_FILEDESCRIPTION);  //date
  lblFileVersion.Caption        := FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblInternalName.Caption       := FileVersionValue(Application.ExeName, FILE_VER_INTERNALNAME);
  lblLegalCopyright.Text        := FileVersionValue(Application.ExeName, FILE_VER_LEGALCOPYRIGHT);
  lblOriginalFileName.Caption   := FileVersionValue(Application.ExeName, FILE_VER_ORIGINALFILENAME);  //patch
  lblProductName.Caption        := FileVersionValue(Application.ExeName, FILE_VER_PRODUCTNAME);
  lblComments.Caption           := FileVersionValue(Application.ExeName, FILE_VER_COMMENTS);  // version comment
  lblCRC.Caption                := 'CRC: ' + IntToHex(CRCForFile(Application.ExeName), 8);
end;

end.

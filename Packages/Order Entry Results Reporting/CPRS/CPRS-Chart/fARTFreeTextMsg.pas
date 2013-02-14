unit fARTFreeTextMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fAutoSz, StdCtrls, ComCtrls, ORFn, ExtCtrls, ORCtrls,
  VA508AccessibilityManager;

type
  TfrmARTFreeTextMsg = class(TfrmAutoSz)
    pnlText: TORAutoPanel;
    pnlButton: TORAutoPanel;
    cmdContinue: TButton;
    lblText: TLabel;
    memFreeText: TCaptionRichEdit;
    lblComments: TOROffsetLabel;
    procedure cmdContinueClick(Sender: TObject);
  private
    FContinue: boolean;
  public
  end;

  const
    LABEL_TEXT = 'You may now add any comments you may have to the message that' + CRLF +
                 'is going to be sent with the request to add this reactant.' + CRLF + CRLF +

                 'You may want to add things like sign/symptoms, observed or historical, etc.,' + CRLF +
                 'that may be useful to the reviewer.' + CRLF + CRLF +

                 'Already included are the entry you attempted, the patient you attempted to' + CRLF +
                 'enter it for, and your name, title, and contact information.';

  var
    tmpList: TStringList;

  procedure GetFreeTextARTComment(var AFreeTextComment: TStringList; var OKtoContinue: boolean);

implementation

{$R *.dfm}

procedure GetFreeTextARTComment(var AFreeTextComment: TStringList; var OKtoContinue: boolean);
var
  frmARTFreeTextMsg: TfrmARTFreeTextMsg;
begin
  frmARTFreeTextMsg := TfrmARTFreeTextMsg.Create(Application);
  tmpList := TStringList.Create;
  try
    with frmARTFreeTextMsg do
    begin
      FContinue := OKtoContinue;
      tmpList.Text := '';
      lblText.Caption := LABEL_TEXT;
      ResizeFormToFont(TForm(frmARTFreeTextMsg));
      ActiveControl := memFreeText;
      frmARTFreeTextMsg.ShowModal;
      OKtoContinue := FContinue;
      FastAssign(tmpList, AFreeTextComment);
    end;
  finally
    tmpList.Free;
    frmARTFreeTextMsg.Release;
  end;
end;

procedure TfrmARTFreeTextMsg.cmdContinueClick(Sender: TObject);
begin
  inherited;
  tmpList.Assign(memFreeText.Lines);
  FContinue := True;
  Close;
end;

end.

unit fSignItem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, rCore, XWBHash,
  ORCtrls, fBase508Form, VA508AccessibilityManager;

type
  TfrmSignItem = class(TfrmBase508Form)
    txtESCode: TCaptionEdit;
    lblESCode: TLabel;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblText: TMemo;
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    FESCode: string;
  public
    { Public declarations }
  end;

procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);

implementation

{$R *.DFM}

uses
  VAUtils;

const
  TX_INVAL_MSG = 'Not a valid electronic signature code.  Enter a valid code or press Cancel.';
  TX_INVAL_CAP = 'Unrecognized Signature Code';

procedure SignatureForItem(FontSize: Integer; const AText, ACaption: string; var ESCode: string);
var
  frmSignItem: TfrmSignItem;
begin
  frmSignItem := TfrmSignItem.Create(Application);
  try
    ResizeAnchoredFormToFont(frmSignItem);
    with frmSignItem do
    begin
      FESCode := '';
      Caption := ACaption;
      lblText.Text := AText;
      ShowModal;
      ESCode := FESCode;
    end;
  finally
    frmSignItem.Release;
  end;
end;

procedure TfrmSignItem.cmdOKClick(Sender: TObject);
begin
  if not ValidESCode(txtESCode.Text) then
  begin
    InfoBox(TX_INVAL_MSG, TX_INVAL_CAP, MB_OK);
    txtESCode.SetFocus;
    txtESCode.SelectAll;
    Exit;
  end;
  FESCode := Encrypt(txtESCode.Text);
  Close;
end;

procedure TfrmSignItem.cmdCancelClick(Sender: TObject);
begin
  FESCode := '';
  Close;
end;

end.

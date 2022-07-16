unit fPKIPINPrompt;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.UITypes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  oPKIEncryption;

type
  TfrmPKIPINPrompt = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtPINValue: TEdit;
    lblInstructions: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lblPIN: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    class function GetPINValue: string;
    class function VerifyPKIPIN(aPKIEncryptionEngine: IPKIEncryptionEngine): TPKIPINResult;
  end;

implementation

{$R *.dfm}


uses
  oPKIEncryptionEx, VAUtils;

procedure TfrmPKIPINPrompt.FormCreate(Sender: TObject);
begin
  Self.Font := Application.MainForm.Font;
end;

procedure TfrmPKIPINPrompt.FormShow(Sender: TObject);
begin
  edtPINValue.SetFocus;
end;

class function TfrmPKIPINPrompt.VerifyPKIPIN(aPKIEncryptionEngine: IPKIEncryptionEngine): TPKIPINResult;
// Prompt the user up to three times for their PIN value
var
  aTryCount: integer;
  aMessage: string;
  aPKIEncryptionEngineEx: IPKIEncryptionEngineEx;
begin
  // First we get an interface that CAN validate PINs
  if aPKIEncryptionEngine.QueryInterface(IPKIEncryptionEngineEx, aPKIEncryptionEngineEx) <> 0 then
    begin
      MessageDlg('Internal error with IPKIEncryptionEngineEx', mtError, [mbOk], 0);
      Result := prError;
    end
  else
    with TfrmPKIPINPrompt.Create(Application) do
      try
        aTryCount := 1;
        edtPINValue.Text := '';

        while aTryCount < 4 do
          case ShowModal of
            mrOK:
              try
                if aPKIEncryptionEngineEx.getIsValidPIN(edtPINValue.Text, aMessage) then
                  begin
                    Result := prOK;
                    Exit;
                  end
                else
                  begin
                    case aTryCount of
                      1:
                        MessageDlg('Invalid PIN Value Entered. You have 2 attempts left.', mtInformation, [mbOk], 0);
                      2:
                        MessageDlg('Invalid PIN Value Entered. You have one attempt left before the card is locked.', mtInformation, [mbOk], 0);
                    end;
//                    Result := prError;
                    inc(aTryCount);
                    edtPINValue.Text := '';
                  end;
              except
                Result := prError;
                Exit;
              end;
            mrCancel:
              begin
                if aTryCount > 1 then
                  MessageDlg('PKI PIN Entry Cancelled. Note: The invalid attempts are still logged on your card.', mtConfirmation, [mbOk], 0);
                Result := prCancel;
                Exit;
              end;
          end;
        MessageDlg('Card is locked due to repeated invalid attempts.', mtError, [mbOk], 0);
        Result := prLocked; // This is only reached if the while loop runs out
      finally
        Free;
      end;
end;

class function TfrmPKIPINPrompt.GetPINValue: string;
begin
  with TfrmPKIPINPrompt.Create(Application) do
    try
      if ShowModal = mrOK then
        Result := edtPINValue.Text
      else
        Result := '';
    finally
      Free;
    end;
end;

end.

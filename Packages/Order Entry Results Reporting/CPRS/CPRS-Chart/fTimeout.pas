unit fTimeout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ExtCtrls, StdCtrls, ORFn, VA508AccessibilityManager;

type
  TfrmTimeout = class(TfrmAutoSz)
    timCountDown: TTimer;
    pnlTop: TPanel;
    Label1: TStaticText;
    Label2: TStaticText;
    pnlBottom: TPanel;
    btnClose: TButton;
    cmdContinue: TButton;
    lblCount: TStaticText;
    pnlWarning: TPanel;
    imgWarning: TImage;
    lblWarning: TLabel;
    lblWarningMultiple: TLabel;
    lblWarningContinue: TLabel;
    lblWarningPatient: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure timCountDownTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCount: Integer;
  end;

function AllowTimeout: Boolean;

implementation

{$R *.DFM}

uses uCore;

function AllowTimeout: Boolean;
var
  frmTimeout: TfrmTimeout;
begin
  frmTimeout := TfrmTimeout.Create(nil);
  try
    ResizeFormToFont(frmTimeout);
    Result := frmTimeout.ShowModal = mrOK;
    // ModalResult mrOK: shut down
    // ModalResult mrCancel: don't shut down
  finally
    FreeAndNil(frmTimeout);
  end;
end;

procedure TfrmTimeout.FormCreate(Sender: TObject);
begin
  inherited;
  Application.Restore;
  Application.BringToFront;
  MessageBeep(MB_ICONASTERISK);
  FCount := User.CountDown;
  lblCount.Caption := IntToStr(FCount);
end;

procedure TfrmTimeout.FormShow(Sender: TObject);
begin
  inherited;
  SetForegroundWindow(Handle);
  lblWarningPatient.Caption := Patient.Name;
  lblWarning.Font.Size := lblWarningPatient.Font.Size + 4;
  if CPRSInstances < 2 then
  begin
    pnlWarning.Visible := false;
    Height := Height - pnlWarning.Height;
  end;
end;

procedure TfrmTimeout.timCountDownTimer(Sender: TObject);
begin
  inherited;
  if FCount = User.CountDown then
  begin
    MessageBeep(MB_ICONASTERISK);
    timCountDown.Enabled  := False;
    try
      timCountDown.Interval := 1000;
    finally
      timCountDown.Enabled  := True;
    end;
  end;
  Dec(FCount);
  lblCount.Caption := IntToStr(FCount);
  if FCount < 1 then
  begin
    timCountDown.Enabled := False;
    ModalResult := mrOK;
  end;
end;

end.

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
    procedure cmdContinueClick(Sender: TObject);
    procedure timCountDownTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FContinue: Boolean;
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
  frmTimeout := TfrmTimeout.Create(Application);
  try
    ResizeFormToFont(TForm(frmTimeout));
    frmTimeout.ShowModal;
    Result := not frmTimeout.FContinue;
  finally
    frmTimeout.Release;
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

procedure TfrmTimeout.btnCloseClick(Sender: TObject);
begin
  inherited;
  FContinue := False;
  Close;
end;

procedure TfrmTimeout.cmdContinueClick(Sender: TObject);
begin
  inherited;
  FContinue := True;
  Close;
end;

procedure TfrmTimeout.timCountDownTimer(Sender: TObject);
begin
  inherited;
  if FCount = User.CountDown then
  begin
    MessageBeep(MB_ICONASTERISK);
    timCountDown.Enabled  := False;
    timCountDown.Interval := 1000;
    timCountDown.Enabled  := True;
  end;
  Dec(FCount);
  lblCount.Caption := IntToStr(FCount);
  if FCount < 1 then
  begin
    timCountDown.Enabled := False;
    Close;
  end;
end;

end.

unit fGMV_ShowSingleVital;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls;

type
  TfrmGMV_ShowSingleVital = class(TForm)
    pnlMain: TPanel;
    memDisplay: TMemo;
    lblInstructionsToClose: TLabel;
    tmrSingleView: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrSingleViewTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowSingleVital(DisplayText: TStringList);

implementation

{$R *.DFM}

procedure ShowSingleVital(DisplayText: TStringList);
var
  dsktpW: Integer;
  dsktpH: Integer;
begin
  with TfrmGMV_ShowSingleVital.Create(Application) do
  try
    memDisplay.Lines.Clear;
    memDisplay.Lines.Assign(DisplayText);
    height := 45 + memDisplay.Lines.Count * 12+50;
    
    dsktpW := GetSystemMetrics(SM_CXFULLSCREEN);
    dsktpH := GetSystemMetrics(SM_CYFULLSCREEN);
    Top := Mouse.CursorPos.y;
    Left := Mouse.CursorPos.x;
    if (dsktpW - Left) < Width then
      Left := dsktpW - Width;
    if (dsktpH - Top) < Height then
      Top := dsktpH - Height;
    tmrSingleView.Enabled := True;
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmGMV_ShowSingleVital.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ModalResult := mrOK;
end;

procedure TfrmGMV_ShowSingleVital.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ModalResult := mrOk;
end;

procedure TfrmGMV_ShowSingleVital.tmrSingleViewTimer(Sender: TObject);
begin
  tmrSingleView.Enabled := False;
  ModalResult := mrOK;
end;

end.


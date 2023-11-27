unit VA508AccessibilityCompileInfo;

interface

{$UNDEF DELAY_BEFORE_SHOW}
{$DEFINE DELAY_BEFORE_SHOW}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DateUtils, StrUtils;

type
  TfrmProgress = class(TForm)
    pnlMain: TPanel;
    pnlProject: TPanel;
    lblProj: TLabel;
    lblProject: TLabel;
    pnlFile: TPanel;
    lblComp: TLabel;
    lblFile: TLabel;
    pnlErrorData: TPanel;
    pnlErrors: TPanel;
    lblNumErrors: TLabel;
    lblErrors: TLabel;
    pnlWarnings: TPanel;
    lblNumWarnings: TLabel;
    lblWarnings: TLabel;
    btnRelease: TButton;
    Panel1: TPanel;
    lblTotal: TLabel;
    lblTotalLines: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    lblBuilt: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lblCached: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TStopCompileProc = procedure of object;

procedure StartMonitor(ProjectText: string; StopProc: TStopCompileProc);
procedure StopMonitor;
procedure Update508Monitor(FileName: String; TotalLines,
        Warnings, Errors, Cached, Built: integer; ForceDisplay: boolean = false);

implementation

uses VAUtils, UResponsiveGUI;

{$R *.dfm}

const
{$IFDEF DELAY_BEFORE_SHOW}
  SECONDS_BEFORE_SHOW = 3;
{$ENDIF}
  UPDATE_FREQUENCY = 50;

var
  frmProgress: TfrmProgress = nil;
  uProjectText: string;
  uStopProc: TStopCompileProc;
  uRunning: boolean = false;
  uLastUpdate: TDateTime;
{$IFDEF DELAY_BEFORE_SHOW}
  uStartTime: TDateTime;
{$ENDIF}

procedure Hookup;
begin
  if not assigned(frmProgress) then
    frmProgress := TfrmProgress.Create(nil);
  frmProgress.lblProject.Caption := GetFileWithShortenedPath(uProjectText, frmProgress.lblProject.Width, frmProgress.Canvas);
  frmProgress.lblFile.Caption := '';
  frmProgress.Show;
  TResponsiveGUI.ProcessMessages(True);
end;

procedure StartMonitor(ProjectText: string; StopProc: TStopCompileProc);
begin
  uLastUpdate := 0;
  uProjectText := ProjectText;
  uStopProc := StopProc;
{$IFDEF DELAY_BEFORE_SHOW}
  if assigned(frmProgress) then
    Hookup
  else
    uStartTime := Now;
{$ELSE}
  Hookup;
{$ENDIF}
end;

procedure StopMonitor;
begin
  if assigned(frmProgress) then
    FreeAndNil(frmProgress);
end;

procedure Update508Monitor(FileName: String; TotalLines,
          Warnings, Errors, Cached, Built: integer; ForceDisplay: boolean = false);
begin
{$IFDEF DELAY_BEFORE_SHOW}
  if not assigned(frmProgress) then
  begin
    if ForceDisplay or (SecondSpan(Now, uStartTime) > SECONDS_BEFORE_SHOW) then
      Hookup;
  end;
{$ENDIF}
  if assigned(frmProgress) then
  begin
    frmProgress.lblFile.Caption := FileName;
    frmProgress.lblTotalLines.Caption := IntToStr(TotalLines);
    frmProgress.lblWarnings.Caption := IntToStr(Warnings);
    frmProgress.lblErrors.Caption := IntToStr(Errors);
    frmProgress.lblCached.Caption := IntToStr(Cached);
    frmProgress.lblBuilt.Caption := IntToStr(Built);
    if MilliSecondSpan(Now, uLastUpdate) > UPDATE_FREQUENCY then
    begin
      TResponsiveGUI.ProcessMessages(True);
      uLastUpdate := Now; 
    end;
  end;
end;

procedure TfrmProgress.btnReleaseClick(Sender: TObject);
begin
  btnRelease.Enabled := False;
  if assigned(uStopProc) then
    uStopProc;
  Close;
end;

procedure TfrmProgress.FormCreate(Sender: TObject);
begin
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 3;
end;

initialization

finalization
  if assigned(frmProgress) then
    FreeAndNil(frmProgress);
end.

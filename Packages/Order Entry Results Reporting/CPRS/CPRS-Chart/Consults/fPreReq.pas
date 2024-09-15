unit fPreReq;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, ComCtrls, ExtCtrls, fBase508Form, VA508AccessibilityManager,
  uReports, uPrinting;

type
  TfrmPrerequisites = class(TfrmBase508Form)
    lblFontTest: TLabel;
    memReport: ORExtensions.TRichEdit;
    pnlButton: TPanel;
    cmdContinue: TButton;
    cmdCancel: TButton;
    cmdPrint: TButton;
    dlgPrintReport: uPrinting.TPrintDialog;
    procedure memReportClick(Sender: TObject);
    procedure cmdContinueClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OnActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AlignButtons();
  end;

function DisplayPrerequisites(ReportText: TStrings; ReportTitle: string): Boolean;

var
  ContinueWithOrder: Boolean;

implementation

uses
  uCore, rCore, rReports, Printers, rMisc;

{$R *.DFM}

function CreateReportBox(ReportText: TStrings; ReportTitle: string): TfrmPrerequisites;
var
  i, AWidth, MaxWidth, AHeight: Integer;

begin
  Result := TfrmPrerequisites.Create(Application);
  try
    with Result do
    begin
      MaxWidth := PnlButton.Width;
      for i := 0 to ReportText.Count - 1 do
      begin
        AWidth := lblFontTest.Canvas.TextWidth(ReportText[i]);
        if AWidth > MaxWidth then MaxWidth := AWidth;
      end;
      MaxWidth := MaxWidth + (GetSystemMetrics(SM_CXFRAME) * 2) + GetSystemMetrics(SM_CXVSCROLL);
      AHeight := (ReportText.Count * lblFontTest.Height) + ReportText.Count +
        (GetSystemMetrics(SM_CYFRAME) * 3) + GetSystemMetrics(SM_CYCAPTION);
      AHeight := AHeight + pnlbutton.Height;
      AHeight := HigherOf(AHeight, 250);
      if AHeight > (Screen.Height - 60) then AHeight := Screen.Height - 60;
      if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
      Width := MaxWidth;
      Height := AHeight;
      ForceInsideWorkArea(Result);
      QuickCopy(ReportText, memReport);
      //Quick fix to work around glich in resize algorithim
      AlignButtons();
      for i := 1 to Length(ReportTitle) do if ReportTitle[i] = #9 then ReportTitle[i] := ' ';
      Caption := ReportTitle;
      memReport.SelStart := 0;
    end;
  except
    KillObj(@Result);
    raise;
  end;
end;

function DisplayPrerequisites(ReportText: TStrings; ReportTitle: string): Boolean;
var
  frmPrerequisites: TfrmPrerequisites;
begin
  frmPrerequisites := CreateReportBox(ReportText, ReportTitle);
  try
    frmPrerequisites.ShowModal;
    Result := ContinueWithOrder;
  finally
    frmPrerequisites.Release;
  end;
end;

procedure TfrmPrerequisites.memReportClick(Sender: TObject);
begin
  //Close;
end;

procedure TfrmPrerequisites.cmdContinueClick(Sender: TObject);
begin
  ContinueWithOrder := True;
  Close;
end;

procedure TfrmPrerequisites.cmdCancelClick(Sender: TObject);
begin
  ContinueWithOrder := False;
  Close;
end;

procedure TfrmPrerequisites.cmdPrintClick(Sender: TObject);
var
  AHeader: TStringList;
  memPrintReport: ORExtensions.TRichEdit;
  MaxLines, LastLine, ThisPage, i: integer;
  ErrMsg: string;
  RemoteSiteID: string;    //for Remote site printing
  RemoteQuery: string;    //for Remote site printing
const
  PAGE_BREAK = '**PAGE BREAK**';
begin
  RemoteSiteID := '';
  RemoteQuery := '';
  if dlgPrintReport.Execute then
    begin
      AHeader := TStringList.Create;
      CreatePatientHeader(AHeader, Self.Caption);
      memPrintReport := CreateReportTextComponent(Self);
      try
        MaxLines := 60 - AHeader.Count;
        LastLine := 0;
        ThisPage := 0;
        with memPrintReport do
          begin
            repeat
              with Lines do
                begin
                  for i := 0 to MaxLines do
                    if i < memReport.Lines.Count then
                      Add(memReport.Lines[LastLine + i])
                    else
                      Break;
                  LastLine := LastLine + i;
                  Add(' ');
                  Add(' ');
                  Add(StringOfChar('-', 74));
                  if LastLine >= memReport.Lines.Count - 1 then
                    Add('End of report')
                  else
                    begin
                      ThisPage := ThisPage + 1;
                      Add('Page ' + IntToStr(ThisPage));
                      Add(PAGE_BREAK);
                    end;
                end;
              until LastLine >= memReport.Lines.Count - 1;
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Self.Caption, ErrMsg, True);
          end;
      finally
        memPrintReport.Free;
        AHeader.Free;
      end;
    end;
  memReport.SelStart := 0;
  memReport.Invalidate;
end;

procedure TfrmPrerequisites.AlignButtons;
Const
  BtnSpace = 8;
begin
  cmdCancel.Left := self.Width - cmdCancel.Width - (BtnSpace * 3) - 3;
  cmdContinue.Left := cmdCancel.Left - BtnSpace - cmdContinue.Width;
end;

procedure TfrmPrerequisites.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveUserBounds(Self); //Save Position & Size of Form
end;

procedure TfrmPrerequisites.FormCreate(Sender: TObject);
begin
  inherited;
  SetFormPosition(Self); //Get Saved Position & Size of Form
  ResizeAnchoredFormToFont(Self);
  //SetFormPosition(Self); //Get Saved Position & Size of Form
end;

procedure TfrmPrerequisites.OnActivate(Sender: TObject);
begin
  if Self.VertScrollBar.IsScrollBarVisible then Self.VertScrollBar.Position := 0;
end;
end.

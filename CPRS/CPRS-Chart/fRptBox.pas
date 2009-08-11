unit fRptBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, ComCtrls, ExtCtrls, fFrame, fBase508Form,
  VA508AccessibilityManager, uReports;

type
  TfrmReportBox = class(TfrmBase508Form)
    lblFontTest: TLabel;
    memReport: TRichEdit;
    pnlButton: TPanel;
    cmdPrint: TButton;
    dlgPrintReport: TPrintDialog;
    cmdClose: TButton;
    procedure memReportClick(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

procedure ReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean);
function ModelessReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean): TfrmReportBox;
procedure PrintStrings(Form: TForm; StringText: TStrings; const Title, Trailer: string);

implementation

uses
  uCore, rCore, rReports, Printers, rMisc;

{$R *.DFM}

function CreateReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean): TfrmReportBox;
var
  i, AWidth, MaxWidth, AHeight: Integer;
  Rect: TRect;
  // %$@# buttons!
  BtnArray: array of TButton;
  BtnRight: array of integer;
  BtnLeft:  array of integer;
  //cmdCloseRightMargin: integer;
  //cmdPrintRightMargin: integer;
  j, k: integer;
begin
  Result := TfrmReportBox.Create(Application);
  try
    with Result do
    begin
      k := 0;
      with pnlButton do for j := 0 to ControlCount - 1 do
        if Controls[j] is TButton then
          begin
            SetLength(BtnArray, k+1);
            SetLength(BtnRight, k+1);
            BtnArray[j] := TButton(Controls[j]);
            BtnRight[j] := ResizeWidth(Font, MainFont, BtnArray[j].Width - BtnArray[j].Width - BtnArray[j].Left);
            k := k + 1;
          end;
      //cmdCloseRightMargin := ResizeWidth(Font, MainFont, pnlButton.Width - cmdClose.Width - cmdClose.Left);
      //cmdPrintRightMargin := ResizeWidth(Font, MainFont, pnlButton.Width - cmdPrint.Width - cmdPrint.Left);
      MaxWidth := 350;
      for i := 0 to ReportText.Count - 1 do
      begin
        AWidth := lblFontTest.Canvas.TextWidth(ReportText[i]);
        if AWidth > MaxWidth then MaxWidth := AWidth;
      end;
      cmdPrint.Visible := AllowPrint;
      MaxWidth := MaxWidth + GetSystemMetrics(SM_CXVSCROLL);
      AHeight := (ReportText.Count * (lblFontTest.Height + 2)) + pnlbutton.Height;
      AHeight := HigherOf(AHeight, 250);
      if AHeight > (Screen.Height - 80) then AHeight := Screen.Height - 80;
      if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
      ClientWidth := MaxWidth;
      ClientHeight := AHeight;
      Rect := BoundsRect;
      ForceInsideWorkArea(Rect);
      BoundsRect := Rect;
      ResizeAnchoredFormToFont(Result);

      memReport.Align := alClient; //CQ6661

      //CQ6889 - force Print & Close buttons to bottom right of form regardless of selected font size
      cmdClose.Left := (pnlButton.Left+pnlButton.Width)-cmdClose.Width;
      cmdPrint.Left := (cmdClose.Left-cmdPrint.Width)-1;
      //end CQ6889

      SetLength(BtnLeft, k);
      for j := 0 to k - 1 do
      begin
        BtnLeft[j] := pnlButton.Width - BtnArray[j].Width - BtnRight[j];
      end;
      //cmdClose.Left := pnlButton.Width - cmdClose.Width - cmdCloseRightMargin;
      //cmdPrint.Left := pnlButton.Width - cmdPrint.Width - cmdPrintRightMargin;
      QuickCopy(ReportText, memReport);
      for i := 1 to Length(ReportTitle) do if ReportTitle[i] = #9 then ReportTitle[i] := ' ';
      Caption := ReportTitle;
      memReport.SelStart := 0;
    end;
  except
    KillObj(@Result);
    raise;
  end;
end;

procedure ReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean);
var
  frmReportBox: TfrmReportBox;
  
begin
  frmReportBox := CreateReportBox(ReportText, ReportTitle, AllowPrint);
  try
    frmReportBox.ShowModal;
  finally
    frmReportBox.Release;
  end;
end;

function ModelessReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean): TfrmReportBox;
begin
  Result := CreateReportBox(ReportText, ReportTitle, AllowPrint);
  Result.FormStyle := fsStayOnTop;
  Result.Show;
end;

procedure PrintStrings(Form: TForm; StringText: TStrings; const Title, Trailer: string);
var
  AHeader: TStringList;
  memPrintReport: TRichEdit;
  MaxLines, LastLine, ThisPage, i: integer;
  ErrMsg: string;
//  RemoteSiteID: string;    //for Remote site printing
//  RemoteQuery: string;    //for Remote site printing
  dlgPrintReport: TPrintDialog;

const
  PAGE_BREAK = '**PAGE BREAK**';

begin
//  RemoteSiteID := '';
//  RemoteQuery := '';
  dlgPrintReport := TPrintDialog.Create(Form);
  try
    frmFrame.CCOWBusy := True;
    if dlgPrintReport.Execute then
    begin
      AHeader := TStringList.Create;
      CreatePatientHeader(AHeader, Title);
      memPrintReport := CreateReportTextComponent(Form);
      try
        MaxLines := 60 - AHeader.Count;
        LastLine := 0;
        ThisPage := 0;
        with memPrintReport do
          begin
            repeat
              with Lines do
                begin
                  AddStrings(AHeader);
                  for i := 0 to MaxLines do
                    if i < StringText.Count then
                      Add(StringText[LastLine + i])
                    else
                      Break;
                  LastLine := LastLine + i;
                  Add(' ');
                  Add(' ');
                  Add(StringOfChar('-', 74));
                  if LastLine >= StringText.Count - 1 then
                    Add(Trailer)
                  else
                    begin
                      ThisPage := ThisPage + 1;
                      Add('Page ' + IntToStr(ThisPage));
                      Add(PAGE_BREAK);
                    end;
                end;
              until LastLine >= StringText.Count - 1;
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Title, ErrMsg);
          end;
      finally
        memPrintReport.Free;
        AHeader.Free;
      end;
    end;
  finally
    frmFrame.CCOWBusy := False;
    dlgPrintReport.Free;
  end;
end;

procedure TfrmReportBox.memReportClick(Sender: TObject);
begin
  //Close;
end;

procedure TfrmReportBox.cmdPrintClick(Sender: TObject);
begin
  PrintStrings(Self, memReport.Lines, Self.Caption, 'End of report');
  memReport.Invalidate;
end;

procedure TfrmReportBox.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if(not (fsModal in FormState)) then
    Action := caFree;
end;

end.

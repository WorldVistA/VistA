unit fPtDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ORCtrls, ORFn, ComCtrls, fBase508Form,
  VA508AccessibilityManager, uReports, U_CPTEditMonitor, uPrinting;

type
  TfrmPtDemo = class(TfrmBase508Form)
    lblFontTest: TLabel;
    memPtDemo: TRichEdit;
    dlgPrintReport: uPrinting.TPrintDialog;
    CPPtDemo: TCopyEditMonitor;
    pnlTop: TPanel;
    cmdNewPt: TButton;
    cmdClose: TButton;
    cmdPrint: TButton;
    procedure cmdCloseClick(Sender: TObject);
    procedure cmdNewPtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure CopyToMonitor(Sender: TObject; var AllowMonitor: Boolean);
  private
    { Private declarations }
    FNewPt: Boolean;
  public
    { Public declarations }
  end;

procedure PatientInquiry(var NewPt: Boolean);

implementation

{$R *.DFM}

uses rCover, rReports, Printers, uCore;

procedure PatientInquiry(var NewPt: Boolean);
{ displays patient demographics, returns true in NewPt if the user pressed 'Select New' btn }
var
  frmPtDemo: TfrmPtDemo;
begin
  if StrToInt64Def(Patient.DFN, 0) <= 0 then
    exit;
  frmPtDemo := TfrmPtDemo.Create(Application);
  try
    with frmPtDemo do
    begin
      frmPtDemo.ShowModal;
      NewPt := FNewPt;
    end; { with frmPtDemo }
  finally
    frmPtDemo.Release;
  end;
end;

procedure TfrmPtDemo.FormCreate(Sender: TObject);
var
  i, MaxWidth, AWidth, AHeight: Integer;

  // RTC #953958 begin
  procedure AdjustButtonSize(aButton: TButton);
  const
    Gap = 5;
  var
    frm: TForm;
    i: Integer;
  begin
    frm := Application.MainForm;
    font.Assign(frm.font);
    i := (frm.Canvas.TextWidth(aButton.Caption) + Gap + Gap);
    if aButton.Width < i then
      aButton.Width := i;
    // Buttons are aligned to the right so the height is set based on pnlTop.height
    // if aButton.Height < frm.Canvas.TextHeight(aButton.Caption) then
    // aButton.Height := (frm.Canvas.TextHeight(aButton.Caption) + Gap);
    aButton.Invalidate;
  end;

  function ButtonWidth(aButton: TButton): Integer;
  begin
    Result := aButton.Width;
    if aButton.AlignWithMargins then
      Result := Result + aButton.Margins.Left + aButton.Margins.Right;
  end;
  // RTC #953958 end

begin
  FNewPt := False;
  LoadDemographics(memPtDemo.Lines);
  memPtDemo.SelStart := 0;
  ResizeAnchoredFormToFont(self);
  MaxWidth := 350; // make sure at least 350 wide
  for i := 0 to memPtDemo.Lines.Count - 1 do
  begin
    AWidth := lblFontTest.Canvas.TextWidth(memPtDemo.Lines[i]);
    if AWidth > MaxWidth then
      MaxWidth := AWidth;
  end;
  { width = borders + inset of memo box (left=8) }
  MaxWidth := MaxWidth + (GetSystemMetrics(SM_CXFRAME) * 2) +
    GetSystemMetrics(SM_CXVSCROLL) + 16;
  { height = height of lines + title bar + borders + 4 lines (room for buttons) }
  AHeight := ((memPtDemo.Lines.Count + 4) * (lblFontTest.Height + 1)) +
    (GetSystemMetrics(SM_CYFRAME) * 3) + GetSystemMetrics(SM_CYCAPTION);
  AHeight := HigherOf(AHeight, 250); // make sure at least 250 high
  if AHeight > (Screen.Height - 120) then
    AHeight := Screen.Height - 120;
  if MaxWidth > Screen.Width then
    MaxWidth := Screen.Width;
  Width := MaxWidth;
  Height := AHeight;
  Constraints.MinHeight := pnlTop.Height + GetSystemMetrics(SM_CYCAPTION) +
    GetSystemMetrics(SM_CYHSCROLL) + 7;

  ForceInsideWorkArea(Self);

  // RTC #953958 begin
  AdjustButtonSize(cmdNewPt);
  AdjustButtonSize(cmdPrint);
  AdjustButtonSize(cmdClose);
  Constraints.MinWidth := ButtonWidth(cmdNewPt) + ButtonWidth(cmdPrint) +
    ButtonWidth(cmdClose) + GetSystemMetrics(SM_CXBORDER) +
    GetSystemMetrics(SM_CXBORDER) + 7;
  // RTC #953958 end
end;

procedure TfrmPtDemo.cmdNewPtClick(Sender: TObject);
begin
  FNewPt := True;
  Close;
end;

procedure TfrmPtDemo.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPtDemo.cmdPrintClick(Sender: TObject);
var
  AHeader: TStringList;
  memPrintReport: TRichEdit;
  StartLine, MaxLines, LastLine, ThisPage, i: Integer;
  ErrMsg: string;
  RemoteSiteID: string; // for Remote site printing
  RemoteQuery: string; // for Remote site printing
const
  PAGE_BREAK = '**PAGE BREAK**';
begin
  RemoteSiteID := '';
  RemoteQuery := '';
  if dlgPrintReport.Execute then
  begin
    AHeader := TStringList.Create;
    CreatePatientHeader(AHeader, self.Caption);
    memPrintReport := CreateReportTextComponent(self);
    try
      MaxLines := 60 - AHeader.Count;
      LastLine := 0;
      ThisPage := 0;
      with memPrintReport do
      begin
        StartLine := 4;
        repeat
          with Lines do
          begin
            for i := StartLine to MaxLines do
              // if i < memPtDemo.Lines.Count - 1 then
              if i < memPtDemo.Lines.Count then
                Add(memPtDemo.Lines[LastLine + i])
              else
                Break;
            LastLine := LastLine + i;
            Add(' ');
            Add(' ');
            Add(StringOfChar('-', 74));
            if LastLine >= memPtDemo.Lines.Count - 1 then
              Add('End of report')
            else
            begin
              ThisPage := ThisPage + 1;
              Add('Page ' + IntToStr(ThisPage));
              Add(PAGE_BREAK);
              StartLine := 0;
            end;
          end;
        until LastLine >= memPtDemo.Lines.Count - 1;
        PrintWindowsReport(memPrintReport, PAGE_BREAK, self.Caption,
          ErrMsg, True);
      end;
    finally
      memPrintReport.Free;
      AHeader.Free;
    end;
  end;
  memPtDemo.SelStart := 0;
  memPtDemo.Invalidate;
end;

procedure TfrmPtDemo.CopyToMonitor(Sender: TObject; var AllowMonitor: Boolean);
begin
  inherited;
  CPPtDemo.ItemIEN := -1;
  CPPtDemo.RelatedPackage := self.Caption + ';' + Patient.Name;
  AllowMonitor := True;
end;

end.

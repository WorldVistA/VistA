unit fRptBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORFn, ComCtrls, ExtCtrls, fFrame, fBase508Form, Types,
  VA508AccessibilityManager, uReports, Vcl.Menus, U_CPTEditMonitor, fDeviceSelect,
  WinApi.ShellApi, WinApi.RichEdit, uPrinting;

type
  TfrmReportBox = class(TfrmBase508Form)
    lblFontTest: TLabel;
    memReport: TRichEdit;
    pnlButton: TPanel;
    cmdPrint: TButton;
    dlgPrintReport: uPrinting.TPrintDialog;
    cmdClose: TButton;
    pmnu: TPopupMenu;
    mnuCopy: TMenuItem;
    CPRptBox: TCopyEditMonitor;
    procedure memReportClick(Sender: TObject);
    procedure cmdPrintClick(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure CPRptBoxCopyToMonitor(Sender: TObject; var AllowMonitor: Boolean);
   private
    fPrintHeader: Boolean;
    fVistAPrint: boolean;
    property PrintHeader: Boolean read fPrintHeader write fPrintHeader;
    property VistAPrint: boolean read fVistaPrint write fVistAPrint;
   protected
     procedure WndProc(var Message: TMessage); override;
   public
    VistADevice: string;
  end;

procedure ReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; includeHeader: boolean = true);
function ModelessReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; includeHeader: boolean = true): TfrmReportBox;
function VistAPrintReportBox(ReportText: TStrings; ReportTitle: string): string;
procedure PrintStrings(Form: TForm; StringText: TStrings; const Title, Trailer: string; includeHeader: boolean = true);

implementation

uses
  uCore, rCore, rReports, Printers, rMisc;

{$R *.DFM}

function CreateReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; includeHeader: boolean = true;
                        VistAPrintOnly: boolean = true): TfrmReportBox;
var
  i, AWidth, MinWidth, MaxWidth, AHeight: Integer;
  BtnArray: array of TButton;
  BtnRight: array of integer;
  BtnLeft:  array of integer;
  //cmdCloseRightMargin: integer;
  //cmdPrintRightMargin: integer;
  j, k: integer;
  line: string;
  Format: TCharFormat2;
  AdjWidth: boolean;

begin
  Result := TfrmReportBox.Create(Application);
  try
    with Result do
    begin
      { Enable URL detection in the memReport TRichEdit }
      i := SendMessage(memReport.Handle, EM_GETEVENTMASK, 0, 0);
      SendMessage(memReport.Handle, EM_SETEVENTMASK, 0, i or ENM_LINK);
      SendMessage(memReport.Handle, EM_AUTOURLDETECT, Integer(True), 0);
      lblFontTest.Font.Size := MainFontSize;
      k := 0;
      MinWidth := 0;
      with pnlButton do for j := 0 to ControlCount - 1 do
        if Controls[j] is TButton then
          begin
            SetLength(BtnArray, k+1);
            SetLength(BtnRight, k+1);
            BtnArray[k] := TButton(Controls[j]);
            BtnRight[k] := ResizeWidth(Font, MainFont, BtnArray[k].Width - BtnArray[k].Width - BtnArray[k].Left);
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
      printHeader := includeHeader;
      vistaPrint := VistaPrintOnly;
      vistaDevice := '';
      MaxWidth := MaxWidth + GetSystemMetrics(SM_CXVSCROLL);
      AHeight := (ReportText.Count * (lblFontTest.Height + 2)) + pnlbutton.Height;
      AHeight := HigherOf(AHeight, 250);
      if AHeight > (Screen.Height - 80) then AHeight := Screen.Height - 80;
      if MaxWidth > Screen.Width then MaxWidth := Screen.Width;
      ClientWidth := MaxWidth;
      ClientHeight := AHeight;
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
        MinWidth := MinWidth + BtnArray[j].Width;
      end;
      Width := width + (GetSystemMetrics(SM_CXVSCROLL) *2);
      Constraints.MinWidth := MinWidth + (MinWidth div 2) + (GetSystemMetrics(SM_CXVSCROLL) *2);
      if (mainFontSize = 8) then Constraints.MinHeight := 285
      else if (mainFontSize = 10) then Constraints.MinHeight := 325
      else if (mainFontSize = 12) then Constraints.MinHeight := 390
      else if mainFontSize = 14 then Constraints.MinHeight := 460
      else Constraints.MinHeight := 575;
      QuickCopy(ReportText, memReport);
      for i := 1 to Length(ReportTitle) do if ReportTitle[i] = #9 then ReportTitle[i] := ' ';
      Caption := ReportTitle;

      // RTC 1291792
      AdjWidth := False;
      with memReport do
      begin
        if Lines.Count > 1 then
        begin
          i := 0;
          repeat
            line := Lines[i];
            j := Length(line);
            if (j > 0) and (ord(line[j]) > 32) and (Length(Lines[i + 1]) > 0)
              and (ord(Lines[i + 1][1]) > 32) then
            begin
              CaretPos := Point(j - 1, i);
              SelLength := 1;
              FillChar(Format, SizeOf(TCharFormat2), 0);
              Format.cbSize := SizeOf(TCharFormat2);
              SendGetStructMessage(Handle, EM_GETCHARFORMAT, WPARAM(true),
                Format, true);
              if (Format.dwEffects and CFE_LINK) <> 0 then
              begin
                line := line + Lines[i + 1];
                Lines[i] := line;
                Lines.Delete(i + 1);
                dec(i);
                AdjWidth := true;
              end;
            end;
            inc(i);
          until i >= (Lines.Count - 1);
        end;
        SelStart := 0;
        if AdjWidth then
        begin
          MaxWidth := 350;
          for i := 0 to Lines.Count - 1 do
          begin
            AWidth := lblFontTest.Canvas.TextWidth(Lines[i]);
            if AWidth > MaxWidth then
              MaxWidth := AWidth;
          end;
          MaxWidth := MaxWidth + GetSystemMetrics(SM_CXVSCROLL) + MainFont.Size;
          if MaxWidth > Screen.Width then
            MaxWidth := Screen.Width;
          Result.ClientWidth := MaxWidth;
        end;
      end;

      ForceInsideWorkArea(Result);
      SetLength(BtnArray, 0);
      SetLength(BtnRight, 0);
      SetLength(BtnLeft, 0);
    end;
  except
    KillObj(@Result);
    raise;
  end;
end;

procedure ReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; includeHeader: boolean = true);
var
  frmReportBox: TfrmReportBox;

begin
  Screen.Cursor := crHourglass;  //wat cq 18425 added hourglass and disabled mnuFileOpen
  fFrame.frmFrame.mnuFileOpen.Enabled := False;
  frmReportBox := CreateReportBox(ReportText, ReportTitle, AllowPrint, includeHeader, false);
  try
    frmReportBox.ShowModal;
  finally
    frmReportBox.Release;
    Screen.Cursor := crDefault;
    fFrame.frmFrame.mnuFileOpen.Enabled := True;
  end;
end;

function ModelessReportBox(ReportText: TStrings; ReportTitle: string; AllowPrint: boolean; includeHeader: boolean = true): TfrmReportBox;
begin
  Result := CreateReportBox(ReportText, ReportTitle, AllowPrint, includeHeader, false);
  Result.FormStyle := fsStayOnTop;
  Result.Show;
end;

function VistAPrintReportBox(ReportText: TStrings; ReportTitle: string): string;
var
  frmReportBox: TfrmReportBox;

begin
  Screen.Cursor := crHourglass;  //wat cq 18425 added hourglass and disabled mnuFileOpen
  fFrame.frmFrame.mnuFileOpen.Enabled := False;
  frmReportBox := CreateReportBox(ReportText, ReportTitle, true, false, true);
  try
    frmReportBox.ShowModal;
    Result := frmReportBox.VistADevice;
  finally
    frmReportBox.Release;
    Screen.Cursor := crDefault;
    fFrame.frmFrame.mnuFileOpen.Enabled := True;
  end;
end;

procedure PrintStrings(Form: TForm; StringText: TStrings; const Title, Trailer: string; includeHeader: boolean = true);
var
  AHeader: TStringList;
  memPrintReport: TRichEdit;
  MaxLines, LastLine, ThisPage, i: integer;
  ErrMsg: string;
//  RemoteSiteID: string;    //for Remote site printing
//  RemoteQuery: string;    //for Remote site printing
  dlgPrintReport: uPrinting.TPrintDialog;
    BM: TBitmap;
const
  PAGE_BREAK = '**PAGE BREAK**';

begin
//  RemoteSiteID := '';
//  RemoteQuery := '';
 BM := TBitmap.Create;
  try
  dlgPrintReport := uPrinting.TPrintDialog.Create(Form);
  try
    frmFrame.CCOWBusy := True;
    if dlgPrintReport.Execute then
    begin
      AHeader := TStringList.Create;
      if includeHeader then  CreatePatientHeader(AHeader, Title);
      memPrintReport := CreateReportTextComponent(Form);
      try
        MaxLines := 60 - AHeader.Count;
        LastLine := 0;
        ThisPage := 0;
        BM.Canvas.Font := memPrintReport.Font;
        with memPrintReport do
          begin
            repeat
              with Lines do
                begin
                 for i := 0 to MaxLines do begin
                   if BM.Canvas.TextWidth(StringText[LastLine + i]) > Width then begin
                     MaxLines := Maxlines - (BM.Canvas.TextWidth(StringText[LastLine + i]) div Width);
                   end;
                   if i >= MaxLines then begin
                     break;
                   end;

                    if i < StringText.Count then
                     // Add(IntToStr(i) + ') ' + StringText[LastLine + i])
                     Add(StringText[LastLine + i])
                    else
                      Break;
                  end;

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
                      MaxLines := 60 - AHeader.Count;
                    end;
                end;
              until LastLine >= StringText.Count - 1;
            PrintWindowsReport(memPrintReport, PAGE_BREAK, Title, ErrMsg, includeHeader);
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
  finally
    BM.free;
  end;
end;

{ Enable URL detection in the memReport TRichEdit }
procedure TfrmReportBox.WndProc(var Message: TMessage);
var
  p: TENLink;
  aURL: string;
begin
  if (Message.Msg = WM_NOTIFY) then
    begin
      if (PNMHDR(Message.LParam).code = EN_LINK) then
        begin
          p := TENLink(Pointer(TWMNotify(Message).NMHdr)^);
          if (p.Msg = WM_LBUTTONDOWN) then
            begin
              SendMessage(memReport.Handle, EM_EXSETSEL, 0, LongInt(@(p.chrg)));
              aURL := memReport.SelText;
              ShellExecute(Handle, 'open', PChar(aURL), NIL, NIL, SW_SHOWNORMAL);
            end
        end
    end;

  inherited;
end;

procedure TfrmReportBox.memReportClick(Sender: TObject);
begin
  //Close;
end;

procedure TfrmReportBox.mnuCopyClick(Sender: TObject);
begin
  inherited;
  memReport.CopyToClipboard;
end;

procedure TfrmReportBox.cmdPrintClick(Sender: TObject);
begin
  if VistAPrint then
    begin
      VistaDevice := SelectDevice(Self, Encounter.Location, FALSE, 'Print Device Selection');
    end
  else
    begin
      PrintStrings(Self, memReport.Lines, Self.Caption, 'End of report', PrintHeader);
      memReport.Invalidate;
    end;
end;

procedure TfrmReportBox.CPRptBoxCopyToMonitor(Sender: TObject; var AllowMonitor: Boolean);
begin
  inherited;
  CPRptBox.RelatedPackage := self.Caption+';'+ Patient.Name;
  CPRptBox.ItemIEN := -1;
  AllowMonitor := true;
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


procedure TfrmReportBox.FormResize(Sender: TObject);
begin
  inherited;
  self.memReport.Refresh;
end;

end.

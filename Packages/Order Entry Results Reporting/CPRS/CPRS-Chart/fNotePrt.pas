unit fNotePrt;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORCtrls, StdCtrls, Mask, ORNet, ORFn, ComCtrls, uPrinting,
  VA508AccessibilityManager;

type
  TfrmNotePrint = class(TfrmAutoSz)
    grpChooseCopy: TGroupBox;
    radChartCopy: TRadioButton;
    radWorkCopy: TRadioButton;
    grpDevice: TGroupBox;
    lblMargin: TLabel;
    lblLength: TLabel;
    txtRightMargin: TMaskEdit;
    txtPageLength: TMaskEdit;
    cmdOK: TButton;
    cmdCancel: TButton;
    lblNoteTitle: TMemo;
    cboDevice: TORComboBox;
    lblPrintTo: TLabel;
    dlgWinPrinter: uPrinting.TPrintDialog;
    chkDefault: TCheckBox;
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboDeviceChange(Sender: TObject);
    procedure radChartCopyClick(Sender: TObject);
    procedure radWorkCopyClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
  private
    { Private declarations }
    FNote: Integer;
    FReportText: ORExtensions.TRichEdit;
    procedure DisplaySelectDevice;
  public
    { Public declarations }
  end;

procedure PrintNote(ANote: Longint; const ANoteTitle: string; MultiNotes: boolean = False);

implementation

{$R *.DFM}

uses rCore, rTIU, rReports, uCore, Printers, uReports;

const
  TX_NODEVICE = 'A device must be selected to print, or press ''Cancel'' to not print.';
  TX_NODEVICE_CAP = 'Device Not Selected';
  TX_ERR_CAP = 'Print Error';
  PAGE_BREAK = '**PAGE BREAK**';

procedure PrintNote(ANote: Longint; const ANoteTitle: string; MultiNotes: boolean = False);
{ displays a form that prompts for a device and then prints the progress note }
var
  frmNotePrint: TfrmNotePrint;
  DefPrt: string;
  aAllowToPrint: string;
  aAllowPrint: Integer;
begin
  aAllowToPrint := AllowPrintOfNote(ANote);
  aAllowPrint := StrToIntDef(Piece(aAllowToPrint, '^', 1), 0);

  if aAllowPrint < 1 then
    begin
      InfoBox(Piece(aAllowToPrint, U, 2), 'Not Allowed to Print', MB_OK);
      Exit;
    end;

  frmNotePrint := TfrmNotePrint.Create(Application);
  try
    ResizeFormToFont(TForm(frmNotePrint));
    with frmNotePrint do
      begin
        { check to see of Chart Print allowed outside of MAS }
        // if AllowChartPrintForNote(ANote) then
        if aAllowPrint = 2 then
          begin
            { This next code begs the question: Why are we even bothering to check
              radWorkCopy if we immediately check the other button?
              Short answer: it seems to wokr better
              Long answer: The checkboxes have to in some way register with the group
              they are in.  If this doesn't happen, both will be initially included
              the tab order.  This means that the first time tabbing through the
              controls, the work copy button would be tabbed to and selected after the
              chart copy.  Tabbing through controls should not change the group
              selection.
            }
            radWorkCopy.Checked := True;
            radChartCopy.Checked := True;
          end
        else
          begin
            radChartCopy.Enabled := False;
            radWorkCopy.Checked := True;
          end;

      lblNoteTitle.Text := ANoteTitle;
      frmNotePrint.Caption := 'Print ' + Piece(Piece(ANoteTitle, #9, 2), ',', 1);
      FNote := ANote;
      DefPrt := GetDefaultPrinter(User.Duz, Encounter.Location);

        if User.CurrentPrinter = '' then
          User.CurrentPrinter := DefPrt;

      with cboDevice do
        begin
          if Printer.Printers.Count > 0 then
            begin
              Items.Add('WIN;Windows Printer^Windows Printer');
              Items.Add('^--------------------VistA Printers----------------------');
            end;
          if User.CurrentPrinter <> '' then
            begin
              InitLongList(Piece(User.CurrentPrinter, ';', 2));
              SelectByID(User.CurrentPrinter);
            end
          else
            InitLongList('');
        end;

     { if ((DefPrt = 'WIN;Windows Printer') and (User.CurrentPrinter = DefPrt)) then
        cmdOKClick(frmNotePrint) //CQ6660
        //Commented out for CQ6660
         //or
         //((User.CurrentPrinter <> '') and
          //(MultiNotes = True)) then
           //frmNotePrint.cmdOKClick(frmNotePrint)
        //end CQ6660
      else }
        frmNotePrint.ShowModal;
    end;
  finally
    frmNotePrint.Release;
  end;
end;

procedure TfrmNotePrint.DisplaySelectDevice;
begin
  with cboDevice, lblPrintTo do
  begin
    if radChartCopy.Checked then Caption := 'Print Chart Copy on:  ' + Piece(ItemID, ';', 2);
    if radWorkCopy.Checked then Caption := 'Print Work Copy on:  ' + Piece(ItemID, ';', 2);
  end;
end;

procedure TfrmNotePrint.cboDeviceNeedData(Sender: TObject; const StartFrom: string;
  Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  inherited;
  sl := TStringList.Create;
  try
    setSubsetOfDevices(sl,StartFrom, Direction);
    cboDevice.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

procedure TfrmNotePrint.cboDeviceChange(Sender: TObject);
begin
  inherited;
  with cboDevice do if ItemIndex > -1 then
  begin
    txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
    txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
    DisplaySelectDevice;
  end;
end;

procedure TfrmNotePrint.radChartCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure TfrmNotePrint.radWorkCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure TfrmNotePrint.cmdOKClick(Sender: TObject);
var
  ADevice, ErrMsg: string;
  ChartCopy: Boolean;
  RemoteSiteID: string;    //for Remote site printing
  RemoteQuery: string;    //for Remote site printing
begin
  inherited;
  RemoteSiteID := '';
  RemoteQuery := '';

  if cboDevice.ItemID = '' then
     begin
     InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
     Exit;
     end;

  if radChartCopy.Checked then
     ChartCopy := True
  else ChartCopy := False;


  if Piece(cboDevice.ItemID, ';', 1) = 'WIN' then
    begin
    if dlgWinPrinter.Execute then
       begin
       FReportText := CreateReportTextComponent(Self);
       GetFormattedNote(FReportText.Lines, FNote, ChartCopy);
       PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrMsg);
       if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
       end
    end
  else
    begin
    ADevice := Piece(cboDevice.ItemID, ';', 2);
    PrintNoteToDevice(FNote, ADevice, ChartCopy, ErrMsg);

    if Length(ErrMsg) > 0 then
        InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
    end;

  if chkDefault.Checked then
     SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));

  User.CurrentPrinter := cboDevice.ItemID;
  Close;
end;

procedure TfrmNotePrint.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

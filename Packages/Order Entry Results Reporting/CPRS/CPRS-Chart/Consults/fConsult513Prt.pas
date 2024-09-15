unit fConsult513Prt;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fAutoSz, ORCtrls, StdCtrls, Mask, ORNet, ORFn, ComCtrls,
  VA508AccessibilityManager, uReports, Vcl.ExtCtrls, uPrinting;

type
  Tfrm513Print = class(TfrmAutoSz)
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
    lblConsultTitle: TMemo;
    cboDevice: TORComboBox;
    lblPrintTo: TLabel;
    dlgWinPrinter: uPrinting.TPrintDialog;
    chkDefault: TCheckBox;
    pnlBUttons: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cboDeviceChange(Sender: TObject);
    procedure radChartCopyClick(Sender: TObject);
    procedure radWorkCopyClick(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);

  private
    { Private declarations }
    FConsult: Integer;
    FReportText: ORExtensions.TRichEdit;
    procedure DisplaySelectDevice;
  public
    { Public declarations }
  end;

procedure PrintSF513(AConsult: Longint; AConsultTitle: string);

implementation

{$R *.DFM}

uses rCore, rConsults, Printers, rReports, uCore;

const
  TX_NODEVICE = 'A device must be selected to print, or press ''Cancel'' to not print.';
  TX_NODEVICE_CAP = 'Device Not Selected';
  TX_ERR_CAP = 'Print Error';
  TX_QUEUED_CAP = 'Printing Report' ;
  PAGE_BREAK = '**PAGE BREAK**';

procedure PrintSF513(AConsult: Longint; AConsultTitle: string);
{ displays a form that prompts for a device and then prints the SF513 }
var
  frm513Print: Tfrm513Print;
  DefPrt: string;
begin
  frm513Print := Tfrm513Print.Create(Application);
  try
    ResizeFormToFont(TForm(frm513Print));
    with frm513Print do
    begin
      lblConsultTitle.Text := AConsultTitle;
      FConsult := AConsult;
      DefPrt := GetDefaultPrinter(User.Duz, Encounter.Location);
      if User.CurrentPrinter = '' then User.CurrentPrinter := DefPrt;
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
      if (DefPrt = 'WIN;Windows Printer') and
         (User.CurrentPrinter = DefPrt) then
         cmdOKClick(frm513Print)
      else
         ShowModal;
    end;
  finally
    frm513Print.Release;
  end;
end;

procedure Tfrm513Print.DisplaySelectDevice;
begin
  with cboDevice, lblPrintTo do
  begin
    if radChartCopy.Checked then Caption := 'Print Chart Copy on:  ' + Piece(ItemID, ';', 2);
    if radWorkCopy.Checked then Caption := 'Print Work Copy on:  ' + Piece(ItemID, ';', 2);
  end;
end;

procedure Tfrm513Print.cboDeviceNeedData(Sender: TObject; const StartFrom: string;
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

procedure Tfrm513Print.cboDeviceChange(Sender: TObject);
begin
  inherited;
  with cboDevice do if ItemIndex > -1 then
    begin
      txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
      txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
      DisplaySelectDevice;
    end;
end;

procedure Tfrm513Print.radChartCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure Tfrm513Print.radWorkCopyClick(Sender: TObject);
begin
  inherited;
  DisplaySelectDevice;
end;

procedure Tfrm513Print.cmdOKClick(Sender: TObject);
var
  ADevice, ErrMsg: string;
  ChartCopy: string;
  RemoteSiteID: string; // for Remote site printing
  RemoteQuery: string; // for Remote site printing
  sl: TSTrings;
begin
  inherited;
  FReportText := CreateReportTextComponent(Self);
  RemoteSiteID := '';
  RemoteQuery := '';
  if cboDevice.ItemID = '' then
  begin
    InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
    Exit;
  end;
  if radChartCopy.Checked then
    ChartCopy := 'C'
  else
    ChartCopy := 'W';
  if Piece(cboDevice.ItemID, ';', 1) = 'WIN' then
  begin
    if dlgWinPrinter.Execute then
      with FReportText do
      begin
        sl := TStringList.Create;
        try
          setFormattedSF513(sl, FConsult, ChartCopy);
          QuickCopy(sl, FReportText);
          PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrMsg);
          if Length(ErrMsg) > 0 then
            InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
        finally
          sl.Free;
        end;
      end;
  end
  else
  begin
    ADevice := Piece(cboDevice.ItemID, ';', 2);
    PrintSF513ToDevice(FConsult, ADevice, ChartCopy, ErrMsg);
    if (ErrMsg <> '') and (Piece(ErrMsg, U, 1) <> '0') then
    begin
      ErrMsg := Piece(ErrMsg, U, 2);
      if Length(ErrMsg) > 0 then
        InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
    end;
  end;
  if chkDefault.Checked then
    SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));
  User.CurrentPrinter := cboDevice.ItemID;
  FReportText.Free;
  Close;
end;

procedure Tfrm513Print.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

unit fLabPrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ORCtrls, ORNet, Mask, ComCtrls, fBase508Form,
  VA508AccessibilityManager;

type
  TfrmLabPrint = class(TfrmBase508Form)
    lblLabTitle: TMemo;
    lblPrintTo: TLabel;
    grpDevice: TGroupBox;
    lblMargin: TLabel;
    lblLength: TLabel;
    txtRightMargin: TMaskEdit;
    txtPageLength: TMaskEdit;
    cboDevice: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    dlgWinPrinter: TPrintDialog;
    chkDefault: TCheckBox;
    procedure cboDeviceChange(Sender: TObject);
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure FindVType;
  private
    { Private declarations }
    FReports: String;
    FDaysBack: Integer;
    FReportText: TRichEdit;
    procedure DisplaySelectDevice;
  public
    { Public declarations }
  end;

var
  frmLabPrint: TfrmLabPrint;

procedure PrintLabs(AReports: String; const ALabTitle: string; ADaysBack: Integer);  //Lontint
function StringPad(aString: string; aStringCount, aPadCount: integer): String;

implementation

{$R *.DFM}

uses ORFn, rCore, uCore, fLabs, rLabs, Printers, rReports, fFrame, uReports;

const
  TX_NODEVICE = 'A device must be selected to print, or press ''Cancel'' to not print.';
  TX_NODEVICE_CAP = 'Device Not Selected';
  TX_ERR_CAP = 'Print Error';
  PAGE_BREAK = '**PAGE BREAK**';
  QT_OTHER      = 0;
  QT_HSTYPE     = 1;
  QT_DATERANGE  = 2;
  QT_IMAGING    = 3;
  QT_NUTR       = 4;
  QT_PROCEDURES = 19;
  QT_SURGERY    = 28;
  QT_HSCOMPONENT   = 5;
  QT_HSWPCOMPONENT = 6;

procedure PrintLabs(AReports: String; const ALabTitle: string; ADaysBack: Integer);
{ displays a form that prompts for a device and then prints the report }
var
  frmLabPrint: TfrmLabPrint;
  DefPrt: string;
begin
  frmLabPrint := TfrmLabPrint.Create(Application);
  try
    ResizeAnchoredFormToFont(frmLabPrint);
    with frmLabPrint do
    begin
      lblLabTitle.Text := ALabTitle;
      FReports := AReports;
      FDaysBack := ADaysBack;
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
         cmdOKClick(frmLabPrint)
      else
         ShowModal;
    end;
  finally
    frmLabPrint.Release;
  end;
end;

procedure TfrmLabPrint.DisplaySelectDevice;
begin
  with cboDevice, lblPrintTo do
  begin
   Caption := 'Print Report on:  ' + Piece(ItemID, ';', 2);
  end;
end;

procedure TfrmLabPrint.cboDeviceChange(Sender: TObject);
begin
  inherited;
  with cboDevice do if ItemIndex > -1 then
    begin
      txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
      txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
      DisplaySelectDevice;
    end;
end;

procedure TfrmLabPrint.cboDeviceNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
begin
inherited;
  cboDevice.ForDataUse(SubsetOfDevices(StartFrom, Direction));
end;

function StringPad(aString: string; aStringCount, aPadCount: integer): String;
var
  s: integer;
begin
  if aStringCount >= aPadCount then
    aStringCount := aPadCount - 1;
  Result := copy(aString, 1, aStringCount);
  s := aPadCount - length(Result);
  if s < 0 then s := 0;
  Result := Result + StringOfChar(' ', s);
end;

procedure TfrmLabPrint.cmdOKClick(Sender: TObject);
var
  ADevice, ErrMsg: string;
  daysback: integer;
  date1, date2: TFMDateTime;
  today: TDateTime;
  RemoteSiteID: string;    //for Remote site printing
  RemoteQuery: string;    //for Remote site printing
  ListItem: TListItem;
  aReport: TStringList;
  aQualifier: string;
  i: integer;
  MoreID: String;  //Restores MaxOcc value
  aCaption: string;
begin
  inherited;
  FReportText := CreateReportTextComponent(Self);
  RemoteSiteID := '';
  RemoteQuery := '';
  MoreID := '';
  aReport := TStringList.Create;
  if uQualifier = '' then
    aQualifier := piece(uRemoteType,'^',5)  //Health Summary Type Report
  else
    begin
      MoreID := ';' + Piece(uQualifier,';',3);
      aQualifier := piece(uRemoteType,'^',5);
    end;
  with frmLabs.TabControl1 do
    if TabIndex > 0 then
      begin
        RemoteSiteID := TRemoteSite(Tabs.Objects[TabIndex]).SiteID;
        RemoteQuery := TRemoteSite(Tabs.Objects[TabIndex]).CurrentLabQuery;
      end;
  if cboDevice.ItemID = '' then
  begin
    InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
    Exit;
  end;
  today := FMDateTimeToDateTime(FMToday);
  if frmLabs.lstDates.ItemIEN > 0 then
    begin
      daysback := frmLabs.lstDates.ItemIEN;
      date1 := FMToday;
      If daysback = 1 then
        date2 := DateTimeToFMDateTime(today)
      Else
        date2 := DateTimeToFMDateTime(today - daysback);
    end
  else
    frmLabs.BeginEndDates(date1,date2,daysback);
  date1 := date1 + 0.2359;
  if Piece(cboDevice.ItemID, ';', 1) = 'WIN' then
    begin
      if dlgWinPrinter.Execute then with FReportText do
        begin
          if uReportType = 'V' then
            begin
              case uQualifierType of
                QT_IMAGING:
                  begin
                    for i := 0 to frmLabs.lvReports.Items.Count - 1 do
                      if frmLabs.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmLabs.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          QuickCopy(GetFormattedReport(FReports, aQualifier,
                            Patient.DFN, nil , RemoteSiteID, RemoteQuery, uHState), FReportText);
                          aCaption := piece(uRemoteType,'^',4);    //nil used to be uHSComponents
                          PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
                QT_NUTR:
                  begin
                    for i := 0 to frmLabs.lvReports.Items.Count - 1 do
                      if frmLabs.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmLabs.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
                            Patient.DFN, nil, RemoteSiteID, RemoteQuery, uHState), FReportText);
                          aCaption := piece(uRemoteType,'^',4);
                          PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
                QT_HSCOMPONENT:
                  begin
                    if (length(piece(uHState,';',2)) > 0) then
                      begin
                        FReportText.Clear;
                        aReport.Clear;
                        CreatePatientHeader(aReport,piece(uRemoteType,'^',4));
                        QuickCopy(aReport, FReportText);
                        FindVType;
                        aCaption := piece(uRemoteType,'^',4) + ';1';
                        PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                      end
                    else
                      begin
                        QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
                          Patient.DFN, nil, RemoteSiteID, RemoteQuery, uHState), FReportText);
                        aCaption := piece(uRemoteType,'^',4);
                        PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                      end;
                  end;
                QT_HSWPCOMPONENT:
                  begin
                    if (length(piece(uHState,';',2)) > 0) then
                      begin
                        FReportText.Clear;
                        aReport.Clear;
                        CreatePatientHeader(aReport,piece(uRemoteType,'^',4));
                        QuickCopy(aReport, FReportText);
                        FindVType;
                        aCaption := piece(uRemoteType,'^',4) + ';1';
                        PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                      end
                    else
                      begin
                        QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
                           Patient.DFN, nil, RemoteSiteID, RemoteQuery, uHState), FReportText);
                        aCaption := piece(uRemoteType,'^',4);
                        PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                      end;
                  end;
                QT_PROCEDURES:
                  begin
                    for i := 0 to frmLabs.lvReports.Items.Count - 1 do
                      if frmLabs.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmLabs.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          QuickCopy(GetFormattedReport(FReports, aQualifier,
                            Patient.DFN, nil, RemoteSiteID, RemoteQuery, uHState), FReportText);
                          aCaption := piece(uRemoteType,'^',4);
                          PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
                QT_SURGERY:
                  begin
                    for i := 0 to frmLabs.lvReports.Items.Count - 1 do
                      if frmLabs.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmLabs.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          QuickCopy(GetFormattedReport(FReports, aQualifier,
                            Patient.DFN, nil, RemoteSiteID, RemoteQuery, uHState), FReportText);
                          aCaption := piece(uRemoteType,'^',4);
                          PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
              end;
            end
          else
            begin
              QuickCopy(GetFormattedLabReport(FReports, FDaysBack, Patient.DFN,
              frmLabs.lstTests.Items, date1, date2, RemoteSiteID, RemoteQuery), FReportText);
              PrintWindowsReport(FReportText, PAGE_BREAK, Self.Caption, ErrMsg);
              if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
            end;
        end;
    end
  else  // if it's not a Win printer
    begin
      if uReportType = 'V' then
        begin
          case uQualifierType of
            QT_HSCOMPONENT:
              begin
                if (length(piece(uHState,';',2)) > 0) then
                  begin
                    FindVType;
                    aReport.Clear;
                    QuickCopy(FReportText.Lines, aReport);
                    ADevice := Piece(cboDevice.ItemID, ';', 2);
                    PrintVReports(ErrMsg, ADevice, piece(uRemoteType,'^',4),aReport);
                    if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                  end
                else
                  begin
                    ADevice := Piece(cboDevice.ItemID, ';', 2);
                    PrintReportsToDevice(FReports, aQualifier + MoreID,
                       Patient.DFN, ADevice, ErrMsg, nil, RemoteSiteID, RemoteQuery, uHState);
                    ErrMsg := Piece(FReportText.Lines[0], U, 2);
                    if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                  end;
              end;
            QT_HSWPCOMPONENT:
              begin
                if (length(piece(uHState,';',2)) > 0) then
                  begin
                    FindVType;
                    aReport.Clear;
                    QuickCopy(FReportText, aReport);
                    ADevice := Piece(cboDevice.ItemID, ';', 2);
                    PrintVReports(ErrMsg, ADevice, piece(uRemoteType,'^',4),aReport);
                    if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                  end
                else
                  begin
                    ADevice := Piece(cboDevice.ItemID, ';', 2);
                    PrintReportsToDevice(FReports, aQualifier + MoreID,
                       Patient.DFN, ADevice, ErrMsg, nil, RemoteSiteID, RemoteQuery, uHState);
                    ErrMsg := Piece(FReportText.Lines[0], U, 2);
                    if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                  end;
              end;
          end;
        end
      else
        begin
          ADevice := Piece(cboDevice.ItemID, ';', 2);
          PrintLabsToDevice(FReports, FDaysBack, Patient.DFN, ADevice,
          frmLabs.lstTests.Items, ErrMsg, date1, date2, RemoteSiteID, RemoteQuery);
          ErrMsg := Piece(FReportText.Lines[0], U, 2);
          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
        end;
    end;
  if chkDefault.Checked then SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));
  User.CurrentPrinter := cboDevice.ItemID;
  aReport.Free;
  FReportText.Free;
  Close;
end;
procedure TfrmLabPrint.FindVType;
var
  i,j,k,L,cnt: integer;
  aBasket: TStringList;
  aID, aHead, aData, aCol, x: string;
  ListItem: TListItem;
  aWPFlag: Boolean;
begin
  aBasket := TStringList.Create;
  aBasket.Clear;
  aHead := '';
  cnt := 2;
  for i := 0 to uColumns.Count - 1 do
    begin
      if (piece(uColumns[i],'^',7) = '1') and (not(piece(uColumns[i],'^',4) = '1')) then
        begin
          L := StrToIntDef(piece(uColumns[i],'^',6),15);
          if length(piece(uColumns[i],'^',8)) > 0 then
            x := piece(uColumns[i],'^',8)
          else
            x := piece(uColumns[i],'^',1);
          x := StringPad(x, L, L+1);
          if frmLabs.TabControl1.Tabs.Count > 1  then
            aHead := aHead + x
          else
            if i = 0 then
              continue
            else
              aHead := aHead + x;
        end;
    end;
  if length(aHead) > 0 then
    begin
      FReportText.Lines.Add(aHead);
      FReportText.Lines.Add('-------------------------------------------------------------------------------');
    end;
  for i := 0 to frmLabs.lvReports.Items.Count - 1 do
    if frmLabs.lvReports.Items[i].Selected then
      begin
        aData := '';
        aWPFlag := false;
        ListItem := frmLabs.lvReports.Items[i];
        aID := ListItem.SubItems[0];
       if frmLabs.TabControl1.Tabs.Count > 1 then
          begin
            L := StrToIntDef(piece(uColumns[0],'^',6),10);
            x := StringPad(ListItem.Caption, L, L+1);
            aData := x;
          end;
        for j := 0 to LabRowObjects.ColumnList.Count - 1 do
          begin
            aCol := TCellObject(LabRowObjects.ColumnList[j]).Handle;
            if piece(aID,':',1) = piece(TCellObject(LabRowObjects.ColumnList[j]).Handle,':',1) then
              if ListItem.Caption = (piece(TCellObject(LabRowObjects.ColumnList[j]).Site,';',1)) then
                begin
                  if (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',7) = '1') and
                   (not (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',4) = '1')) then
                    begin
                      FastAssign(TCellObject(LabRowObjects.ColumnList[j]).Data, aBasket);
                      for k := 0 to aBasket.Count - 1 do
                        begin
                          L := StrToIntDef(piece(uColumns[StrToInt(piece(aCol,':',2))],'^',6),15);
                          x := StringPad(aBasket[k], L, L+1);
                          aData := aData + x;
                        end;
                    end;
                end;
          end;
        FReportText.Lines.Add(aData);
        cnt := cnt + 1;
        if cnt > 40 then
          begin
            cnt := 0;
            FReportText.Lines.Add('**PAGE BREAK**');
          end;
        for j := 0 to LabRowObjects.ColumnList.Count - 1 do
          begin
            aCol := TCellObject(LabRowObjects.ColumnList[j]).Handle;
            if piece(aID,':',1) = piece(TCellObject(LabRowObjects.ColumnList[j]).Handle,':',1) then
              if ListItem.Caption = (piece(TCellObject(LabRowObjects.ColumnList[j]).Site,';',1)) then
                begin
                  if (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',7) = '1') and
                     (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',4) = '1') then
                    begin
                      aWPFlag := true;
                      FastAssign(TCellObject(LabRowObjects.ColumnList[j]).Data, aBasket);
                      FReportText.Lines.Add(TCellObject(LabRowObjects.ColumnList[j]).Name);
                      cnt := cnt + 1;
                      for k := 0 to aBasket.Count - 1 do
                        begin
                          FReportText.Lines.Add('' + aBasket[k]);
                          cnt := cnt + 1;
                          if cnt > 40 then
                            begin
                              cnt := 0;
                              FReportText.Lines.Add('**PAGE BREAK**');
                            end;
                        end;
                    end;
                end;
          end;
        if aWPFlag = true then
          begin
            FReportText.Lines.Add('===============================================================================');
          end;
      end;
  aBasket.Free;
end;

procedure TfrmLabPrint.cmdCancelClick(Sender: TObject);
begin
inherited;
  Close;
end;

end.

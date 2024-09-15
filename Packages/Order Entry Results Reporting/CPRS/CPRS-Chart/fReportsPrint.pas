unit fReportsPrint;

interface

uses
  ORExtensions,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, fAutoSz, ORCtrls, ORNet, Mask, ComCtrls, rECS, uPrinting,
  fBase508Form, VA508AccessibilityManager;

type
  TfrmReportPrt = class(TfrmBase508Form)
    lblReportsTitle: TMemo;
    lblPrintTo: TLabel;
    grpDevice: TGroupBox;
    lblMargin: TLabel;
    lblLength: TLabel;
    txtRightMargin: TMaskEdit;
    txtPageLength: TMaskEdit;
    cboDevice: TORComboBox;
    cmdOK: TButton;
    cmdCancel: TButton;
    dlgWinPrinter: uPrinting.TPrintDialog;
    chkDefault: TCheckBox;
    procedure cboDeviceChange(Sender: TObject);
    procedure cmdOKClick(Sender: TObject);
    procedure cmdCancelClick(Sender: TObject);
    procedure cboDeviceNeedData(Sender: TObject; const StartFrom: String;
      Direction, InsertAt: Integer);
    procedure FindVType;
  private
    FReports: string;
    FReportText: ORExtensions.TRichEdit;
    procedure DisplaySelectDevice;
  end;

procedure PrintReports(AReports: string; const AReportsTitle: string);
function StringPad(aString: string; aStringCount, aPadCount: integer): String;

implementation

{$R *.DFM}

uses ORFn, rCore, uCore, fReports, rReports, uReports, Printers, fFrame,
  VAUtils;

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

procedure PrintReports(AReports: string; const AReportsTitle: string);
{ displays a form that prompts for a device and then prints the report }
var
  frmReportPrt: TfrmReportPrt;
  DefPrt: string;
begin
  frmReportPrt := TfrmReportPrt.Create(nil);
  try
    ResizeAnchoredFormToFont(TForm(frmReportPrt));
    with frmReportPrt do
    begin
      lblReportsTitle.Text := AReportsTitle;
      FReports := AReports;
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
         cmdOKClick(frmReportPrt)
      else
         ShowModal;
    end;
  finally
    FreeAndNil(frmReportPrt);
  end;
end;

procedure TfrmReportPrt.FindVType;
var
  i,j,k,L,cnt: integer;
  aBasket: TStringList;
  aID, aHead, aData, aCol, x: string;
  ListItem: TListItem;
  aWPFlag: Boolean;
  DistanceFromLeft, DistanceRemaining, TotalSpaceAvailable: Integer;
  SigText, LineBreak, PageBreak, LeftMask: string;
  LinesPerPage, Limit, Z: Integer;
  WrappedSig: TStringList;

  function WrapTextOverride(const Line, BreakStr: string;
    const BreakChars: TSysCharSet; MaxCol: Integer): string;
  const
    QuoteChars = ['"'];
    FirstIndex = Low(string);
    StrAdjust = 1 - Low(string);
  var
    Col, Pos: Integer;
    LinePos: Integer;
    BreakLen, BreakPos: Integer;
    QuoteChar, CurChar: Char;
    ExistingBreak: Boolean;
    L: Integer;
  begin
    Col := FirstIndex;
    Pos := FirstIndex;
    LinePos := FirstIndex;
    BreakPos := 0;
    QuoteChar := #0;
    ExistingBreak := False;
    BreakLen := BreakStr.Length;
    Result := '';
    while Pos <= High(Line) do
    begin
      CurChar := Line[Pos];
      if IsLeadChar(CurChar) then
      begin
        L := CharLength(Line, Pos) div SizeOf(Char) - 1;
        Inc(Pos, L);
        Inc(Col, L);
      end
      else
      begin
      if CharInSet(CurChar, QuoteChars) then
        if QuoteChar = #0 then
          QuoteChar := CurChar
        else if CurChar = QuoteChar then
          QuoteChar := #0;
      if QuoteChar = #0 then
      begin
        if CurChar = BreakStr[FirstIndex] then
        begin
          ExistingBreak := StrLComp(PChar(BreakStr), PChar(@Line[Pos]), BreakLen) = 0;
          if ExistingBreak then
          begin
            Inc(Pos, BreakLen-1);
            BreakPos := Pos;
          end;
        end;

        if not ExistingBreak then
          if CharInSet(CurChar, BreakChars) then
            BreakPos := Pos;
        end;
      end;

      Inc(Pos);
      Inc(Col);

      if not CharInSet(QuoteChar, QuoteChars) and (ExistingBreak or
        ((Col > MaxCol - StrAdjust) and (BreakPos > LinePos))) then
      begin
        Col := FirstIndex;
        Result := Result + Line.SubString(LinePos - FirstIndex, BreakPos - LinePos + 1);
        if not CharInSet(CurChar, QuoteChars) then
        begin
          while Pos <= High(Line) do
          begin
            if CharInSet(Line[Pos], BreakChars) then
            begin
              Inc(Pos);
              ExistingBreak := False;
            end
            else
            begin
              if StrLComp(PChar(@Line[Pos]), sLineBreak, Length(sLineBreak)) = 0 then
              begin
                Inc(Pos, Length(sLineBreak));
                ExistingBreak := True;
              end
              else
                Break;
            end;
          end;
        end;
        if (Pos <= High(Line)) and not ExistingBreak then
          Result := Result + BreakStr;

        Inc(BreakPos);
        LinePos := BreakPos;
        Pos := LinePos;
        ExistingBreak := False;
      end;
    end;
    Result := Result + Line.SubString(LinePos - FirstIndex);
  end;

begin
  aBasket := TStringList.Create;
  try
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
            if frmReports.TabControl1.Tabs.Count > 1  then
              aHead := aHead + x
            else
              if i = 0 then
                continue
              else
                aHead := aHead + x;
          end;
      end;

    if (Length(aHead) > 0) and Assigned(FReportText) then
    begin
      FReportText.Lines.Add(aHead);
      FReportText.Lines.Add('-------------------------------------------------------------------------------');
      TotalSpaceAvailable := Length(FReportText.Lines[FReportText.Lines.Count - 1]);
    end else
      TotalSpaceAvailable := 80;
    for i := 0 to frmReports.lvReports.Items.Count - 1 do
      if frmReports.lvReports.Items[i].Selected then
      begin
        aData := '';
        aWPFlag := false;
        ListItem := frmReports.lvReports.Items[i];
        aID := ListItem.SubItems[0];
        if frmReports.TabControl1.Tabs.Count > 1 then
        begin
          if uColumns.Count > 0 then
            L := StrToIntDef(piece(uColumns[0],'^',6),10)
          else
            L := 10;
          x := StringPad(ListItem.Caption, L, L+1);
          aData := x;
        end;
        for j := 0 to RowObjects.ColumnList.Count - 1 do
        begin
          aCol := TCellObject(RowObjects.ColumnList[j]).Handle;
          if piece(aID,':',1) = piece(TCellObject(RowObjects.ColumnList[j]).Handle,':',1) then
            if ListItem.Caption = (piece(TCellObject(RowObjects.ColumnList[j]).Site,';',1)) then
            begin
              if (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',7) = '1') and
                (not (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',4) = '1')) then
              begin
                FastAssign(TCellObject(RowObjects.ColumnList[j]).Data, aBasket);
                if POS('SIG', piece(uColumns[StrToInt(piece(aCol, ':', 2))], '^', 1)) > 0 then
                begin
                  DistanceFromLeft := Length(aData); //distance from the left side of the page
                  DistanceRemaining := TotalSpaceAvailable - DistanceFromLeft; //Distance to end of page
                  LinesPerPage := 40;
                  Limit := 10; //Arbitrary limit to detrmine if there is enough space to bother with wrapping.
                  LineBreak := #13#10;
                  PageBreak := '**PAGE BREAK**';
                  X := '';
                  LeftMask := StringOfChar(' ', DistanceFromLeft);
                  //remove any line breaks from the text
                  SigText := StringReplace(aBasket.Text, #13#10, '', [rfReplaceAll]);
                  if DistanceRemaining < Limit then
                  begin
                    DistanceRemaining := TotalSpaceAvailable;
                    LeftMask := '';
                    X := X + LineBreak;
                  end;
                  WrappedSig := TStringList.Create;
                  try
                    WrappedSig.Text := WrapTextOverride(SigText, LineBreak + LeftMask, [' '], DistanceRemaining);
                    for Z := 0 to WrappedSig.Count - 1 do
                    begin
                      Inc(Cnt);
                      if Cnt > LinesPerPage then
                      begin
                        x := x  + PageBreak + LineBreak;
                        Cnt := 0;
                      end;
                      X := X + WrappedSig.Strings[Z] + LineBreak;
                    end;
                  finally
                    FreeAndNil(WrappedSig);
                  end;
                  aData := aData + x;
                end else begin
                  for k := 0 to aBasket.Count - 1 do
                  begin
                    L := StrToIntDef(piece(uColumns[StrToInt(piece(aCol,':',2))],'^',6),15);
                    x := StringPad(aBasket[k], L, L+1);
                    aData := aData + x;
                  end;
                end;
              end;
            end;
        end;
        if Assigned(FReportText) then FReportText.Lines.Add(aData);
        cnt := cnt + 1;
        if cnt > 40 then
        begin
          cnt := 0;
          if Assigned(FReportText) then FReportText.Lines.Add('**PAGE BREAK**');
        end;
        for j := 0 to RowObjects.ColumnList.Count - 1 do
        begin
          aCol := TCellObject(RowObjects.ColumnList[j]).Handle;
          if piece(aID,':',1) = piece(TCellObject(RowObjects.ColumnList[j]).Handle,':',1) then
            if ListItem.Caption = (piece(TCellObject(RowObjects.ColumnList[j]).Site,';',1)) then
            begin
              if (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',7) = '1') and
                (piece(uColumns[StrToInt(piece(aCol,':',2))],'^',4) = '1') then
              begin
                aWPFlag := true;
                FastAssign(TCellObject(RowObjects.ColumnList[j]).Data, aBasket);
                if Assigned(FReportText) then
                  FReportText.Lines.Add(TCellObject(RowObjects.ColumnList[j]).Name);
                cnt := cnt + 1;
                for k := 0 to aBasket.Count - 1 do
                begin
                  if Assigned(FReportText) then FReportText.Lines.Add('' + aBasket[k]);
                  cnt := cnt + 1;
                  if cnt > 40 then
                  begin
                    cnt := 0;
                    if Assigned(FReportText) then
                      FReportText.Lines.Add('**PAGE BREAK**');
                  end;
                end;
              end;
            end;
        end;
        if aWPFlag and Assigned(FReportText) then
        begin
          FReportText.Lines.Add('===============================================================================');
        end;
      end;
  finally
    FreeAndNil(aBasket);
  end;
end;

function DeleteLineBreaks(const S: string): string;
var
  Source, SourceEnd: PChar;
begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  while Source < SourceEnd do
  begin
    case Source^ of
      #10: Source^ := #32;
      #13: Source^ := #32;
    end;
    Inc(Source);
  end;
  Result := S;
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

procedure TfrmReportPrt.DisplaySelectDevice;
begin
  with cboDevice, lblPrintTo do
  begin
   Caption := 'Print Report on:  ' + Piece(ItemID, ';', 2);
  end;
end;

procedure TfrmReportPrt.cboDeviceChange(Sender: TObject);
begin
  inherited;
  with cboDevice do if ItemIndex > -1 then
    begin
      txtRightMargin.Text := Piece(Items[ItemIndex], '^', 4);
      txtPageLength.Text := Piece(Items[ItemIndex], '^', 5);
      DisplaySelectDevice;
    end;
end;

procedure TfrmReportPrt.cmdOKClick(Sender: TObject);
var
  ADevice, ErrMsg: string;
  RemoteSiteID: string;
  RemoteQuery: string;
  aQualifier: string;
  aReport: TStringList;
  aCaption: string;
  i: integer;
  ListItem: TListItem;
  MoreID: String;  //Restores MaxOcc value
begin
  inherited;
  FReportText := CreateReportTextComponent(Self);
  try
    RemoteSiteID := '';
    RemoteQuery := '';
    MoreID := '';
    aReport := TStringList.Create;
    try
      if uQualifier = '' then
        aQualifier := piece(uRemoteType,'^',5)  //Health Summary Type Report
      else
        begin
          MoreID := ';' + Piece(uQualifier,';',3);
          aQualifier := piece(uRemoteType,'^',5);
        end;
      with frmReports.TabControl1 do
        if TabIndex > 0 then
          begin
            RemoteSiteID := TRemoteSite(Tabs.Objects[TabIndex]).SiteID;
            RemoteQuery := TRemoteSite(Tabs.Objects[TabIndex]).CurrentReportQuery;
          end;
      if cboDevice.ItemID = '' then
      begin
        InfoBox(TX_NODEVICE, TX_NODEVICE_CAP, MB_OK);
        Exit;
      end;
      if Piece(cboDevice.ItemID, ';', 1) = 'WIN' then
        begin
          if dlgWinPrinter.Execute then with FReportText do
            begin
              if uReportType = 'V' then
                begin
                  case uQualifierType of
                    QT_IMAGING:
                      begin
                        for i := 0 to frmReports.lvReports.Items.Count - 1 do
                          if frmReports.lvReports.Items[i].Selected then
                            begin
                              ListItem := frmReports.lvReports.Items[i];
                              aQualifier := ListItem.SubItems[0];
                              ADevice := Piece(cboDevice.ItemID, ';', 2);
    //                          QuickCopy(GetFormattedReport(FReports, aQualifier,
    //                            Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                              GetFormattedReport(FReportText.Lines, FReports, aQualifier,
                                Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                              aCaption := piece(uRemoteType,'^',4);
                              PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                              if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                            end;
                      end;
                    QT_NUTR:
                      begin
                        for i := 0 to frmReports.lvReports.Items.Count - 1 do
                          if frmReports.lvReports.Items[i].Selected then
                            begin
                              ListItem := frmReports.lvReports.Items[i];
                              aQualifier := ListItem.SubItems[0];
                              ADevice := Piece(cboDevice.ItemID, ';', 2);
    //                          QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
    //                            Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                              GetFormattedReport(FReportText.Lines, FReports, aQualifier + MoreID,
                                Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
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
    //                        QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
    //                          Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                            GetFormattedReport(FReportText.Lines, FReports, aQualifier + MoreID,
                              Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
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
    //                        QuickCopy(GetFormattedReport(FReports, aQualifier + MoreID,
    //                           Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                            GetFormattedReport(FReportText.Lines, FReports, aQualifier + MoreID,
                               Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                            aCaption := piece(uRemoteType,'^',4);
                            PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                            if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                          end;
                      end;
                    QT_PROCEDURES:
                      begin
                        for i := 0 to frmReports.lvReports.Items.Count - 1 do
                          if frmReports.lvReports.Items[i].Selected then
                            begin
                              ListItem := frmReports.lvReports.Items[i];
                              aQualifier := ListItem.SubItems[0];
                              ADevice := Piece(cboDevice.ItemID, ';', 2);
    //                          QuickCopy(GetFormattedReport(FReports, aQualifier,
    //                            Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                              GetFormattedReport(FReportText.Lines, FReports, aQualifier,
                                Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                              aCaption := piece(uRemoteType,'^',4);
                              PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                              if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                            end;
                      end;
                    QT_SURGERY:
                      begin
                        for i := 0 to frmReports.lvReports.Items.Count - 1 do
                          if frmReports.lvReports.Items[i].Selected then
                            begin
                              ListItem := frmReports.lvReports.Items[i];
                              aQualifier := ListItem.SubItems[0];
                              ADevice := Piece(cboDevice.ItemID, ';', 2);
    //                          QuickCopy(GetFormattedReport(FReports, aQualifier,
    //                            Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                              GetFormattedReport(FReportText.Lines, FReports, aQualifier,
                                Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                              aCaption := piece(uRemoteType,'^',4);
                              PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                              if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                            end;
                      end;
                  end;
                end
              else
                begin
                  if (Pos('OR_ECS1',FReports)>0) or (Pos('OR_ECS2',FReports)>0) then
                  begin
                    ShowMsg('The Event Capture report can only be printed by Vista printer.');
                    Exit;
                  end;
                  aQualifier := Piece(uRemoteType,'^',5);
    //              QuickCopy(GetFormattedReport(FReports, aQualifier,
    //                 Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState), FReportText);
                  GetFormattedReport(FReportText.Lines, FReports, aQualifier,
                     Patient.DFN, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                  aCaption := piece(uRemoteType,'^',4);
                  PrintWindowsReport(FReportText, PAGE_BREAK, aCaption, ErrMsg);
                  if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                end;
            end;
        end
      else  // if it's not a Win printer
        begin
          if uReportType = 'V' then
            begin
              case uQualifierType of
                QT_IMAGING:
                  begin
                    for i := 0 to frmReports.lvReports.Items.Count - 1 do
                      if frmReports.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmReports.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          PrintReportsToDevice(piece(FReports,':',1), aQualifier + MoreID,
                             Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                          ErrMsg := Piece(FReportText.Lines[0], U, 2);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
                QT_NUTR:
                  begin
                    for i := 0 to frmReports.lvReports.Items.Count - 1 do
                      if frmReports.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmReports.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          PrintReportsToDevice(piece(FReports,':',1), aQualifier + MoreID,
                             Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                          ErrMsg := Piece(FReportText.Lines[0], U, 2);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
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
                           Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
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
                           Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                        ErrMsg := Piece(FReportText.Lines[0], U, 2);
                        if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                      end;
                  end;
                QT_PROCEDURES:
                  begin
                    for i := 0 to frmReports.lvReports.Items.Count - 1 do
                      if frmReports.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmReports.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          PrintReportsToDevice(piece(FReports,':',1), aQualifier,
                             Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                          ErrMsg := Piece(FReportText.Lines[0], U, 2);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
                QT_SURGERY:
                  begin
                    for i := 0 to frmReports.lvReports.Items.Count - 1 do
                      if frmReports.lvReports.Items[i].Selected then
                        begin
                          ListItem := frmReports.lvReports.Items[i];
                          aQualifier := ListItem.SubItems[0];
                          ADevice := Piece(cboDevice.ItemID, ';', 2);
                          PrintReportsToDevice(piece(FReports,':',1), aQualifier + MoreID,
                             Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                          ErrMsg := Piece(FReportText.Lines[0], U, 2);
                          if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                        end;
                  end;
              end;
            end
          else
            begin
              ADevice := Piece(cboDevice.ItemID, ';', 2);
              aQualifier := Piece(uRemoteType,'^',5);
              if (Pos('OR_ECS1',FReports)>0) or (Pos('OR_ECS2',FReports)>0) then
                begin
                  uECSReport.ReportType := 'P';
                  uECSReport.PrintDEV   := Piece(cboDevice.ItemID,';',1);
                  PrintECSReportToDevice(uECSReport);
                end
              else
                begin
                  PrintReportsToDevice(FReports, aQualifier + MoreID,
                     Patient.DFN, ADevice, ErrMsg, uHSComponents, RemoteSiteID, RemoteQuery, uHState);
                  ErrMsg := Piece(FReportText.Lines[0], U, 2);
                  if Length(ErrMsg) > 0 then InfoBox(ErrMsg, TX_ERR_CAP, MB_OK);
                end;
            end;
        end;
      if chkDefault.Checked then SaveDefaultPrinter(Piece(cboDevice.ItemID, ';', 1));
      User.CurrentPrinter := cboDevice.ItemID;
    finally
      FreeAndNil(aReport);
    end;
  finally
    FreeAndNil(FReportText);
  end;
  Close;
end;

procedure TfrmReportPrt.cmdCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmReportPrt.cboDeviceNeedData(Sender: TObject;
  const StartFrom: String; Direction, InsertAt: Integer);
var
  sl: TSTrings;
begin
  inherited;
  sl := TSTringList.Create;
  try
    setSubsetOfDevices(sl,StartFrom, Direction);
    cboDevice.ForDataUse(sl);
  finally
    sl.Free;
  end;
end;

end.
